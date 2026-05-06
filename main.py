import sqlite3
import random
import string
from datetime import datetime, timedelta
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
DATABASE = 'policy_sandbox.db'

# ================== Database Helpers ==================
def get_db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with app.app_context():
        db = get_db()
        cursor = db.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS country_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                population INTEGER NOT NULL,
                urbanization_rate REAL NOT NULL,
                fuel_dependency TEXT NOT NULL,
                income_level TEXT NOT NULL,
                political_stability TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id)
            )
        ''')
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS simulations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                country_data_id INTEGER NOT NULL,
                policy_type TEXT NOT NULL,
                percentage_change REAL NOT NULL,
                policy_target TEXT NOT NULL,
                time_frame TEXT NOT NULL,
                short_term_impact TEXT,
                long_term_impact TEXT,
                risk_probability REAL,
                confidence_level TEXT,
                simulation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id),
                FOREIGN KEY (country_data_id) REFERENCES country_data (id)
            )
        ''')
        db.commit()

# ================== Helper Functions ==================
def generate_impacts(policy_type, percentage_change, policy_target, time_frame,
                     fuel_dependency, income_level, political_stability, urbanization_rate):
    """Simulasikan dampak berdasarkan parameter yang diberikan."""
    short_term = []
    long_term = []

    # Faktor risiko berdasarkan stabilitas politik dan pendapatan
    risk_base = 30
    if political_stability == 'low':
        risk_base += 20
    elif political_stability == 'medium':
        risk_base += 10

    if income_level == 'low':
        risk_base += 15
    elif income_level == 'lower-middle':
        risk_base += 10
    elif income_level == 'upper-middle':
        risk_base += 5

    # Pengaruh jenis kebijakan
    if policy_type == 'Subsidi BBM':
        if percentage_change < 0:
            short_term.append("Pengurangan subsidi BBM dapat meningkatkan harga energi dan memicu protes masyarakat.")
            long_term.append("Beralih ke energi alternatif secara bertahap, menurunkan beban fiskal dalam jangka panjang.")
        else:
            short_term.append("Peningkatan subsidi BBM menstabilkan harga tetapi membebani anggaran negara.")
            long_term.append("Ketergantungan pada BBM meningkat, memperburuk defisit fiskal.")
        risk_base += 10 if fuel_dependency == 'high' else 5
    elif policy_type == 'Pajak':
        if percentage_change > 0:
            short_term.append("Kenaikan pajak mengurangi daya beli masyarakat, terutama kelompok bawah.")
            long_term.append("Pendapatan negara meningkat, memungkinkan pembangunan infrastruktur sosial.")
        else:
            short_term.append("Penurunan pajak mendorong konsumsi dan investasi jangka pendek.")
            long_term.append("Risiko penurunan penerimaan negara jika tidak diimbangi sektor lain.")
        risk_base += 5 if income_level in ['low', 'lower-middle'] else 0
    elif policy_type == 'Bantuan Sosial':
        short_term.append("Bantuan sosial langsung meningkatkan kesejahteraan masyarakat rentan.")
        long_term.append("Program berkelanjutan dapat mengurangi kemiskinan struktural, namun perlu dikelola dengan baik.")
        risk_base -= 10 if political_stability == 'high' else 0
    elif policy_type == 'Upah Minimum':
        if percentage_change > 0:
            short_term.append("Kenaikan upah minimum meningkatkan daya beli pekerja, tapi dapat menambah biaya produksi.")
            long_term.append("Meningkatkan standar hidup, namun berpotensi menimbulkan inflasi jika tidak diimbangi produktivitas.")
        else:
            short_term.append("Penurunan upah minimum menekan biaya produksi tapi mengurangi pendapatan pekerja.")
            long_term.append("Dapat menurunkan daya saing tenaga kerja dan meningkatkan ketimpangan.")
        risk_base += 5

    # Pengaruh urbanisasi dan populasi
    if urbanization_rate > 70:
        short_term.append("Kebijakan ini berdampak besar pada daerah perkotaan yang padat.")
        long_term.append("Urbanisasi tinggi menuntut kebijakan transportasi dan perumahan yang terintegrasi.")

    # Sesuaikan dengan target kebijakan
    target_lower = policy_target.lower()
    if 'transportasi' in target_lower:
        short_term.append("Sektor transportasi akan merasakan dampak langsung dalam beberapa bulan.")
    elif 'industri' in target_lower:
        short_term.append("Industri akan menyesuaikan biaya produksi, mempengaruhi harga barang.")
    elif 'pertanian' in target_lower:
        short_term.append("Sektor pertanian mungkin memerlukan penyesuaian subsidi pupuk dan harga gabah.")

    # Pengaruh jangka waktu
    if time_frame == 'pendek':
        long_term.append("Dampak jangka panjang masih belum terlihat jelas dalam simulasi pendek ini.")
    elif time_frame == 'menengah':
        long_term.append("Dalam 3-5 tahun, efek struktural mulai terlihat pada perekonomian.")
    elif time_frame == 'panjang':
        long_term.append("Simulasi jangka panjang menunjukkan perubahan fundamental dalam kebijakan publik.")

    # Probabilitas risiko dan tingkat keyakinan
    risk_probability = min(95, max(5, risk_base + (abs(percentage_change) * 0.3)))
    confidence_level = 'tinggi' if political_stability == 'high' and income_level in ['high', 'upper-middle'] else 'sedang' if political_stability != 'low' else 'rendah'

    return {
        'short_term_impact': ' '.join(short_term),
        'long_term_impact': ' '.join(long_term),
        'risk_probability': round(risk_probability, 1),
        'confidence_level': confidence_level
    }


# ================== Routes ==================

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username', '').strip()
    password = data.get('password', '').strip()

    if not username or not password:
        return jsonify({'success': False, 'message': 'Username dan password wajib diisi.'}), 400

    db = get_db()
    try:
        db.execute('INSERT INTO users (username, password) VALUES (?, ?)', (username, password))
        db.commit()
        user = db.execute('SELECT id, username FROM users WHERE username = ?', (username,)).fetchone()
        return jsonify({'success': True, 'data': dict(user)}), 201
    except sqlite3.IntegrityError:
        return jsonify({'success': False, 'message': 'Username sudah digunakan.'}), 400

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username', '').strip()
    password = data.get('password', '').strip()

    db = get_db()
    user = db.execute('SELECT id, username FROM users WHERE username = ? AND password = ?', (username, password)).fetchone()
    if user:
        return jsonify({'success': True, 'data': dict(user)})
    else:
        return jsonify({'success': False, 'message': 'Username atau password salah.'}), 401

@app.route('/api/country-data', methods=['POST'])
def save_country_data():
    data = request.get_json()
    required_fields = ['user_id', 'population', 'urbanization_rate', 'fuel_dependency', 'income_level', 'political_stability']
    if not all(k in data for k in required_fields):
        return jsonify({'success': False, 'message': 'Data negara tidak lengkap.'}), 400

    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        INSERT INTO country_data (user_id, population, urbanization_rate, fuel_dependency, income_level, political_stability)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (
        data['user_id'],
        data['population'],
        data['urbanization_rate'],
        data['fuel_dependency'],
        data['income_level'],
        data['political_stability']
    ))
    db.commit()
    new_id = cursor.lastrowid
    return jsonify({'success': True, 'data': {'country_data_id': new_id}})

@app.route('/api/simulate', methods=['POST'])
def run_simulation():
    data = request.get_json()
    required = ['user_id', 'country_data_id', 'policy_type', 'percentage_change', 'policy_target', 'time_frame']
    if not all(k in data for k in required):
        return jsonify({'success': False, 'message': 'Parameter simulasi tidak lengkap.'}), 400

    db = get_db()
    country = db.execute('SELECT * FROM country_data WHERE id = ? AND user_id = ?',
                         (data['country_data_id'], data['user_id'])).fetchone()
    if not country:
        return jsonify({'success': False, 'message': 'Data negara tidak ditemukan.'}), 404

    # Ambil data negara untuk analisis
    impacts = generate_impacts(
        policy_type=data['policy_type'],
        percentage_change=data['percentage_change'],
        policy_target=data['policy_target'],
        time_frame=data['time_frame'],
        fuel_dependency=country['fuel_dependency'],
        income_level=country['income_level'],
        political_stability=country['political_stability'],
        urbanization_rate=country['urbanization_rate']
    )

    # Simpan hasil simulasi
    cursor = db.cursor()
    cursor.execute('''
        INSERT INTO simulations (user_id, country_data_id, policy_type, percentage_change,
                                 policy_target, time_frame, short_term_impact, long_term_impact,
                                 risk_probability, confidence_level)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        data['user_id'],
        data['country_data_id'],
        data['policy_type'],
        data['percentage_change'],
        data['policy_target'],
        data['time_frame'],
        impacts['short_term_impact'],
        impacts['long_term_impact'],
        impacts['risk_probability'],
        impacts['confidence_level']
    ))
    db.commit()
    simulation_id = cursor.lastrowid

    result = {
        'simulation_id': simulation_id,
        'short_term_impact': impacts['short_term_impact'],
        'long_term_impact': impacts['long_term_impact'],
        'risk_probability': impacts['risk_probability'],
        'confidence_level': impacts['confidence_level']
    }
    return jsonify({'success': True, 'data': result})

@app.route('/api/history/<int:user_id>', methods=['GET'])
def get_history(user_id):
    db = get_db()
    rows = db.execute('''
        SELECT id, user_id, country_data_id, policy_type, percentage_change, policy_target,
               time_frame, short_term_impact, long_term_impact, risk_probability,
               confidence_level, simulation_date
        FROM simulations
        WHERE user_id = ?
        ORDER BY simulation_date DESC
    ''', (user_id,)).fetchall()

    history = []
    for row in rows:
        sim = dict(row)
        # Format tanggal agar cocok dengan frontend (ISO string)
        sim['simulation_date'] = row['simulation_date'] if row['simulation_date'] else datetime.now().isoformat()
        history.append(sim)

    return jsonify({'success': True, 'data': history})

@app.route('/api/country-data/user/<int:user_id>', methods=['GET'])
def get_user_country_data(user_id):
    db = get_db()
    # Ambil data negara terbaru untuk user
    row = db.execute('''
        SELECT * FROM country_data
        WHERE user_id = ?
        ORDER BY created_at DESC
        LIMIT 1
    ''', (user_id,)).fetchone()

    if row:
        return jsonify({'success': True, 'data': dict(row)})
    else:
        return jsonify({'success': True, 'data': None})  # frontend handle null

# ================== Main ==================
if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)
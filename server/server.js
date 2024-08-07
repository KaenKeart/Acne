const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const bcrypt = require('bcrypt');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());  // เพิ่ม CORS Middleware
app.use(bodyParser.json());

// สร้างการเชื่อมต่อฐานข้อมูล
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'acne'
});

db.connect(err => {
    if (err) {
        throw err;
    }
    console.log('MySQL connected...');
});

// Endpoint สำหรับการสมัครสมาชิก
app.post('/signin', (req, res) => {
    const { username, password, email } = req.body;
    const hashedPassword = bcrypt.hashSync(password, 10);

    const query = 'INSERT INTO users (username, password, email) VALUES (?, ?, ?)';
    db.query(query, [username, hashedPassword, email], (err, result) => {
        if (err) {
            return res.status(500).send({ status: 'error', message: 'User registration failed' });
        }
        res.send({ status: 'success', message: 'User registered successfully' });
    });
});

// Endpoint สำหรับการเข้าสู่ระบบ
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    const query = 'SELECT * FROM users WHERE username = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            return res.status(500).send({ status: 'error', message: 'User not found' });
        }
        if (results.length > 0) {
            const user = results[0];
            if (bcrypt.compareSync(password, user.password)) {
                res.send({ status: 'success', message: 'Login successful' });
            } else {
                res.status(401).send({ status: 'error', message: 'Invalid password' });
            }
        } else {
            res.status(404).send({ status: 'error', message: 'User not found' });
        }
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`Server running on port ${port}`);
});

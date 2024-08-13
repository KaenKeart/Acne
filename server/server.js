const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const crypto = require("crypto"); // ใช้ crypto เพื่อคอมพิวเตอร์ MD5
const cors = require("cors");
const app = express();
const port = 3000;

app.use(
  cors({
    origin: "*",
  })
);
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "acne",
});

db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
    process.exit(1);
  }
  console.log("MySQL connected...");
});

function hashMD5(password) {
  return crypto.createHash("md5").update(password).digest("hex");
}

app.post("/signin", (req, res) => {
  const { username, password, email } = req.body;

  if (!username || !password || !email) {
    return res
      .status(400)
      .send({ status: "error", message: "Missing required fields" });
  }

  const hashedPassword = hashMD5(password);

  const query =
    "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
  db.query(query, [username, hashedPassword, email], (err, result) => {
    if (err) {
      console.error("Error during user registration:", err);
      return res.status(500).send({
        status: "error",
        message: "User registration failed",
        error: err.message,
      });
    }
    res.send({ status: "success", message: "User registered successfully" });
  });
});

app.post("/login", (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res
      .status(400)
      .send({ status: "error", message: "Missing username or password" });
  }

  const hashedPassword = hashMD5(password);

  const query = "SELECT * FROM users WHERE username = ?";
  db.query(query, [username], (err, results) => {
    if (err) {
      console.error("Error during user login:", err);
      return res.status(500).send({
        status: "error",
        message: "An error occurred during login",
        error: err.message,
      });
    }
    if (results.length === 0) {
      return res
        .status(404)
        .send({ status: "error", message: "User not found" });
    }

    const user = results[0];
    if (user.password === hashedPassword) {
      res.send({ status: "success", message: "Login successful" });
    } else {
      res.status(401).send({ status: "error", message: "Invalid password" });
    }
  });
});

app.use((err, req, res, next) => {
  console.error("Server error:", err);
  res.status(500).send({
    status: "error",
    message: "An internal server error occurred",
    error: err.message,
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});

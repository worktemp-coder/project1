#!/usr/bin/env python3
"""Capstone Flask App — Secured"""
import os
import hmac
import logging
import sqlite3
import tempfile
from flask import Flask, request, jsonify

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(name)s %(message)s',
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

DB_PATH = os.environ.get('USERS_DB', os.path.join(tempfile.gettempdir(), 'users.db'))


def init_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        "CREATE TABLE IF NOT EXISTS users ("
        "id INTEGER PRIMARY KEY, username TEXT, email TEXT)"
    )
    conn.commit()
    conn.close()


init_db()


@app.route('/users/<int:user_id>')
def get_user(user_id):
    conn = sqlite3.connect(DB_PATH)
    user = conn.execute(
        "SELECT id, username, email FROM users WHERE id=?",
        (user_id,),
    ).fetchone()
    conn.close()

    if not user:
        return jsonify({"error": "Not found"}), 404

    return jsonify({"user": {"id": user[0], "username": user[1]}})


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid body"}), 400

    password = data.get('password', '')

    secret = os.environ.get('APP_SECRET')
    if not secret:
        logger.error("APP_SECRET not configured")
        return jsonify({"error": "Server error"}), 500

    if hmac.compare_digest(password, secret):
        return jsonify({"token": "logged-in"})

    logger.warning(f"Failed login from {request.remote_addr}")
    return jsonify({"error": "Invalid credentials"}), 401


@app.route('/health')
def health():
    return jsonify({"status": "ok", "version": "1.0"})


@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Not found"}), 404


@app.errorhandler(500)
def server_error(e):
    logger.error(f"Internal error: {e}", exc_info=True)
    return jsonify({"error": "Internal server error"}), 500


if __name__ == '__main__':
    debug = os.environ.get('FLASK_DEBUG', 'false').lower() == 'true'
    app.run(host='0.0.0.0', debug=debug)  # nosec B104
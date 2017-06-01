#flask part
import os
from flask import Flask, render_template, g, jsonify
import sqlite3
from contextlib import closing

# Make app & configuration
app = Flask(__name__)
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, './db/postlist.db'),
    DEBUG=True,
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='default'
))

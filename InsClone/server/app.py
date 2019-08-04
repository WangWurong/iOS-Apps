from flask import Flask, jsonify, request, g
import sqlite3

app = Flask(__name__)
DATABASE = './database/InsClone.db'


def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

@app.route('/')
def index():
    return response_wrapper(200, 'server works', {})

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.json['username']
        password = request.json['password']
        # status = login(username, password)
        conn = get_db()
        with conn:
            res = login_user(conn, (username, password))
            return response_wrapper(200, res, {})
        return response_wrapper(500, 'error in conn to db', {})
    elif request.method == 'GET':
        return response_wrapper(200, 'get login', {})

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        conn = get_db()
        with conn:
            username = request.json['username']
            password = request.json['password']
            # insert into db
            new_user = (username, password)
            signup_user(conn, new_user)
            print(new_user)
            return response_wrapper(200, 'succeed sign up: ' + username + password, {})
        return response_wrapper(500, 'error in sign up user', {})
    elif request.method == 'GET':
        return response_wrapper(200, 'get sign up', {})

def signup_user(conn, new_user):
    """
    Create a new user into the USER table
    :param conn:
    :param user:
    :return: user id
    """
    sql = ''' INSERT INTO USER(username,password) VALUES(?,?) '''
    cur = conn.cursor()
    cur.execute(sql, new_user)
    return cur.lastrowid

def login_user(conn, user):
    cur = conn.cursor()
    cur.execute("SELECT * FROM USER")
    rows = cur.fetchall()
    print(rows)
    if len(rows) == 1:
        return 'sucess'
    else:
        return 'no such user'

def response_wrapper(status, msg, data):
    return jsonify({
        'statusCode': status,
        'message': msg,
        'data': data
        })


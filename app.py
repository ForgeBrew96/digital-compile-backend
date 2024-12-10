from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import os
import psycopg2, psycopg2.extras
import json

def get_db_connection():
  connection = psycopg2.connect(
    host='localhost',
    database='compile_db',
    user=os.environ['POSTGRES_USER'],
    password=os.environ['POSTGRES_PASSWORD']
  )
  return connection

load_dotenv()
app = Flask(__name__)
CORS(app)

@app.route('/')
def basepage():
  return f"Welcome to the Compile Data Base: Search by cards, users and protocols. Happy DBing!"

@app.route('/protocols')
def index_protocols():
  try:
    connection = get_db_connection()
    cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cursor.execute("SELECT * FROM protocols;")
    protocols = cursor.fetchall()
    connection.close()
    return protocols
  except:
    return "Application Error", 500

#Protocols CRUD=================================  
@app.route('/protocols', methods=['POST'])
def create_protocol():
    try:
        new_protocol = request.json
        print("Received Data:", new_protocol)
        connection = get_db_connection() 
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        query = """ INSERT INTO protocols (name, description, img_url, playstyle) VALUES (%s, %s, %s, %s) RETURNING * """
        values = ( new_protocol['name'], new_protocol['description'], new_protocol['img_url'], new_protocol['playstyle'] )
        cursor.execute(query, values) 
        created_protocol = cursor.fetchone() 
        connection.commit() 
        connection.close()

        return jsonify(created_protocol), 201
    except Exception as e:
        print("Error:", e) 
        return str(e), 500

@app.route('/protocols/<protocol_id>', methods=['DELETE'])
def delete_protocol(protocol_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute("DELETE FROM protocols WHERE protocol_id = %s", (protocol_id,))
        if cursor.rowcount == 0:
            return "Protocol not found", 404
        connection.commit()
        cursor.close()
        return "Protocol deleted successfully", 204
    except Exception as e:
        return str(e), 500

#Cards CRUD=================================
@app.route('/cards')
def index_cards():
  try:
    connection = get_db_connection()
    cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cursor.execute("SELECT * FROM cards;")
    cards = cursor.fetchall()
    connection.close()
    return cards
  except:
    return "Application Error", 500
  
@app.route('/cards', methods=['POST'])
def create_cards():
    try:
        new_card = request.json
        print("Received Data:", new_card)

        is_original = True if new_card['creator_id'] == 1 else False
        effects_json = json.dumps(new_card['effects'])

        connection = get_db_connection() 
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

        query = """ INSERT INTO cards (name, point_value, creator_id, protocol_id, effects, is_original) VALUES (%s, %s, %s, %s, %s, %s) RETURNING * """
        values = ( new_card['name'], new_card['point_value'], new_card['creator_id'], new_card['protocol_id'], effects_json, is_original )

        cursor.execute(query, values) 
        created_card = cursor.fetchone() 
        connection.commit() 
        connection.close()

        return jsonify(created_card), 201
    except Exception as e:
        print("Error:", e) 
        return str(e), 500
    
app.run()

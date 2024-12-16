from auth_middleware import token_required
from flask import Flask, request, jsonify, g
from flask_cors import CORS
from dotenv import load_dotenv
import os
import jwt
import bcrypt
import psycopg2, psycopg2.extras
import json

def get_db_connection():
    if 'ON_HEROKU' in os.environ:
        connection = psycopg2.connect(
            os.getenv('DATABASE_URL'), 
            sslmode='require'
        )
    else:
        connection = psycopg2.connect(
            host='localhost',
            database=os.getenv('POSTGRES_DATABASE'),
            user=os.getenv('POSTGRES_USERNAME'),
            password=os.getenv('POSTGRES_PASSWORD')
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

@app.route('/protocols/<protocol_id>', methods=['PUT'])
def update_protocol(protocol_id):
    try:
        data = request.json

        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        
        # Check if protocol exists
        cursor.execute("SELECT * FROM protocols WHERE protocol_id = %s", (protocol_id,))
        if cursor.fetchone() is None:
            connection.close()
            return jsonify({"error": "Protocol Not Found"}), 404

        # Update protocol
        cursor.execute("""
            UPDATE protocols 
            SET img_url = %s
            WHERE protocol_id = %s 
            RETURNING *
        """, (data['img_url'], protocol_id))
        
        updated_protocol = cursor.fetchone()
        connection.commit()
        connection.close()
        return jsonify(updated_protocol), 202
    except Exception as e:
        return jsonify({"error": str(e)}), 500

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
    query = """SELECT cards.*, protocols.img_url FROM cards JOIN protocols ON cards.protocol_id = protocols.protocol_id;"""
    cursor.execute(query)
    cards = cursor.fetchall()
    connection.close()
    return cards
  except:
    return "Application Error", 500
  
@app.route('/cards/<card_id>', methods=['GET'])
def show_card(card_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute("SELECT * FROM cards WHERE card_id = %s", (card_id,))
        card = cursor.fetchone()
        if card is None:
            connection.close()
            return "Card Not Found", 404
        connection.close()
        return card, 200
    except Exception as e:
        return str(e), 500
  
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
    
@app.route('/cards/<card_id>', methods=['PUT'])
def update_card(card_id):
    try:
      
      effects_json = json.dumps(request.json['effects'])

      connection = get_db_connection()
      cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
      cursor.execute("UPDATE cards SET name = %s, point_value = %s, protocol_id = %s, effects = %s WHERE card_id = %s RETURNING *", (request.json['name'], request.json['point_value'], request.json['protocol_id'], effects_json, card_id))
      updated_card = cursor.fetchone()
      if updated_card is None:
        return "Card Not Found", 404
      connection.commit()
      connection.close()
      return updated_card, 202
    except Exception as e:
      return str(e), 500
    
@app.route('/cards/<card_id>', methods=['DELETE'])
def delete_card(card_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute("DELETE FROM cards WHERE card_id = %s", (card_id,))
        if cursor.rowcount == 0:
            return "Card not found", 404
        connection.commit()
        cursor.close()
        return "Card deleted successfully", 204
    except Exception as e:
        return str(e), 500
    

#User Account CRUD=================================

@app.route('/users')
def index_users():
  try:
    connection = get_db_connection()
    cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cursor.execute("SELECT * FROM users;")
    users = cursor.fetchall()
    connection.close()
    return users
  except:
    return "Application Error", 500
  
@app.route('/sign-token', methods=['POST'])
def sign_token():
    try:
        user_data = request.get_json()
        
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        
        cursor.execute("SELECT * FROM users WHERE id = %s AND username = %s;", (user_data["id"], user_data["username"]))
        user = cursor.fetchone()
        
        if user is None:
            return jsonify({"error": "Invalid user."}), 401
        
        password_is_valid = bcrypt.checkpw(bytes(user_data["password"], 'utf-8'), bytes(user["password"], 'utf-8'))
        
        if not password_is_valid:
            return jsonify({"error": "Invalid credentials."}), 401
        
        token = jwt.encode({"id": user["id"], "username": user["username"]}, os.getenv('JWT_SECRET'), algorithm="HS256")
        
        return jsonify({"token": f"Bearer {token}"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        connection.close()


@app.route('/verify-token', methods=['POST'])
def verify_token():
    try:
      token = request.headers.get('Authorization').split(' ')[1]
      decoded_token = jwt.decode(token, os.getenv('JWT_SECRET'), algorithms="HS256")
      return jsonify({"user": decoded_token })
    except Exception as error:
        return jsonify({"error": error.message})

@app.route('/auth/signup', methods=['POST'])
def signup():
    try:
        new_user_data = request.get_json()
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute("SELECT * FROM users WHERE username = %s;", (new_user_data["username"],))
        existing_user = cursor.fetchone()
        if existing_user:
            cursor.close()
            return jsonify({"error": "Username already taken"}), 400
        hashed_password = bcrypt.hashpw(bytes(new_user_data["password"], 'utf-8'), bcrypt.gensalt())
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s) RETURNING username", (new_user_data["username"], hashed_password.decode('utf-8')))
        created_user = cursor.fetchone()
        connection.commit()
        connection.close()
        token = jwt.encode(created_user, os.getenv('JWT_SECRET'))
        return jsonify({"token": token, "user": created_user}), 201
    except Exception as error:
        return jsonify({"error": str(error)}), 401

@app.route('/auth/signin', methods=["POST"])
def signin():
    try:
        sign_in_form_data = request.get_json()
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute("SELECT * FROM users WHERE username = %s;", (sign_in_form_data["username"],))
        existing_user = cursor.fetchone()
        if existing_user is None:
            return jsonify({"error": "Invalid credentials."}), 401
        password_is_valid = bcrypt.checkpw(bytes(sign_in_form_data["password"], 'utf-8'), bytes(existing_user["password"], 'utf-8'))
        if not password_is_valid:
            return jsonify({"error": "Invalid credentials."}), 401
        token = jwt.encode({"username": existing_user["username"], "id": existing_user["id"]}, os.getenv('JWT_SECRET'))
        return jsonify({"token": token}), 201
    except Exception as error:
        return jsonify({"error": "Invalid credentials."}), 401
    finally:
        connection.close()

@app.route('/vip-lounge')
@token_required
def vip_lounge():
    return f"Welcome to the party, {g.user['username']}"

if __name__ == '__main__':
    app.run()


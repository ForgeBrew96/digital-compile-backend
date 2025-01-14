import psycopg2, psycopg2.extras
import os

def get_db_connection():
    if 'ON_HEROKU' in os.environ:
        connection = psycopg2.connect(
            os.getenv('HEROKU_POSTGRESQL_YELLOW_URL')
        )
    else:
        connection = psycopg2.connect(
            host='localhost',
            database=os.getenv('POSTGRES_DATABASE'),
            user=os.getenv('POSTGRES_USERNAME'),
            password=os.getenv('POSTGRES_PASSWORD')
        )
    return connection
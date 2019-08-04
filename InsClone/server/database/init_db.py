# reference: https://datatofish.com/create-database-python-using-sqlite3/
import sqlite3
conn = sqlite3.connect('InsClone.db')
c = conn.cursor()

c.execute('''CREATE TABLE USER
             ([generated_id] INTEGER PRIMARY KEY,[username] text, [password] text)''')

conn.commit()

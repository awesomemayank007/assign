from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL
import yaml

app = Flask(__name__)

# Configure db
#db = yaml.load(open('db.yaml'))
app.config['MYSQL_HOST'] = "mysql.assign.svc.cluster.local"
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "password"
app.config['MYSQL_DB'] = "flaskapp"

mysql = MySQL(app)

@app.route('/users')
def users():
    cur = mysql.connection.cursor()
    resultValue = cur.execute("SELECT * FROM users")
    if resultValue > 0:
        userDetails = cur.fetchall()
        return render_template('users.html',userDetails=userDetails)

if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0")

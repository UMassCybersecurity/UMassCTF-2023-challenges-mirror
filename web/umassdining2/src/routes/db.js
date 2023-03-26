const mysql = require('mysql2');

const pool = mysql.createPool({
    host: process.env.SQL_HOST,
    user: 'root',
    password: process.env.MYSQL_ROOT_PASSWORD,
    database: 'umassdining'
}).promise();

class DBHelper{
    async getAllUsers(){
        let users = await pool.query("SELECT * FROM users");
        return users[0];
    }
    async getUser(username){
        let users = await pool.query(
            "SELECT * FROM users WHERE username=?",
            [username]
        );
        return users[0];
    }
    async createUser(username,password){
        await pool.query(
            `INSERT INTO users (username,password)
            VALUES (?,?)`,
            [username,password]
        );
    }
    async authUser(username,password){
        let user = await pool.query(
            "SELECT * FROM users WHERE username=? AND password=?",
            [username,password]
        );
        return user[0];
    }
}
module.exports = new DBHelper();
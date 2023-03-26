const mysql = require('mysql2');

const pool = mysql.createPool({
    host: process.env.SQL_HOST,
    user: 'root',
    password: process.env.MYSQL_ROOT_PASSWORD,
    database: 'secureblocks'
}).promise();

class DBHelper{
    async getAllUsers(){
        let users = await pool.query("SELECT * FROM users ORDER BY diamonds");
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
            `INSERT INTO users (username,password,diamonds)
            VALUES (?,?,?)`,
            [username,password,0]
        );
    }
    async deleteUser(username){
        await pool.query(
            "DELETE FROM users WHERE username=?",
            [username]
        );
    }
    async editDiamonds(username,diamonds){
        await pool.query(
            `UPDATE users SET diamonds = ?
            WHERE username=?;`,
            [diamonds,username]
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
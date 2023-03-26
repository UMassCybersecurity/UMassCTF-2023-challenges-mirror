CREATE DATABASE IF NOT EXISTS secureblocks;
USE secureblocks;

CREATE TABLE users 
(username VARCHAR(255), password VARCHAR(255), diamonds INT(64));

INSERT INTO users (username,password,diamonds) 
VALUES 
('admin','bruh-idk-l0ng-p4ssw0rd$-k1nd4-overrated?',9999999);
CREATE USER IF NOT EXISTS 'Admin1'@'%' IDENTIFIED BY 'Admin@123';
GRANT ALL PRIVILEGES ON mydb.* TO 'Admin1'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS mydb.users (
    id VARCHAR(100) PRIMARY KEY,
    role ENUM('user', 'author', 'mod', 'admin') NOT NULL,
    created_on DATETIME NOT NULL
);


CREATE TABLE IF NOT EXISTS mydb.blogs (
  id VARCHAR(100),
  blog_name VARCHAR(255),
  status VARCHAR(20)
);

-- to forcibly run this
-- mysql -h mysql-service -uroot -prootpass123  -e "use mydb;
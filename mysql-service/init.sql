CREATE USER IF NOT EXISTS 'Admin1'@'%' IDENTIFIED BY 'Admin@123';
GRANT ALL PRIVILEGES ON mydb.* TO 'Admin1'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- this creates able in mydb as it was specified in dockercompose file

CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(50) PRIMARY KEY,
  role VARCHAR(10),
  status TEXT
);

CREATE TABLE IF NOT EXISTS blogs (
    id VARCHAR(100),
    blogName VARCHAR(255),
    status VARCHAR(20)
);

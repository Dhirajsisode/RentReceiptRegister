CREATE DATABASE IF NOT EXISTS rent_receipt_db;
USE rent_receipt_db;

CREATE TABLE IF NOT EXISTS rent_receipt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant VARCHAR(40) NOT NULL,
    rent_month VARCHAR(5) NOT NULL,
    rent INT NOT NULL,
    paid_on DATE NOT NULL,
    UNIQUE KEY unique_tenant_month (tenant, rent_month)
);

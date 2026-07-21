-- ==========================================
-- Projeto: Banco de Dados Concessionária
-- Autor: Vinícius Assumpção Francisco
-- Banco: MySQL
-- ==========================================

CREATE DATABASE concessionaria;

USE concessionaria;

CREATE TABLE marca (
    marca_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_marca VARCHAR(100) NOT NULL,
    origem VARCHAR(100)
);

CREATE TABLE cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

CREATE TABLE vendedor (
    vendedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_contratacao DATE
);

CREATE TABLE inventario (
    inventario_id INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    transmissao VARCHAR(100) NOT NULL,
    motor VARCHAR(100) NOT NULL,
    combustivel VARCHAR(100) NOT NULL,
    ano YEAR NOT NULL,
    cor VARCHAR(100) NOT NULL,
    quilometragem INT NOT NULL,
    placa VARCHAR(20) NOT NULL UNIQUE,
    situacao VARCHAR(100) NOT NULL,
    marca_id INT NOT NULL,
    CONSTRAINT fk_inventario_marca
        FOREIGN KEY (marca_id)
        REFERENCES marca(marca_id)
);

CREATE TABLE venda (
    venda_id INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_venda DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(100) NOT NULL,
    cliente_id INT NOT NULL,
    inventario_id INT NOT NULL,
    vendedor_id INT NOT NULL,

    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(cliente_id),

    CONSTRAINT fk_venda_inventario
        FOREIGN KEY (inventario_id)
        REFERENCES inventario(inventario_id),

    CONSTRAINT fk_venda_vendedor
        FOREIGN KEY (vendedor_id)
        REFERENCES vendedor(vendedor_id)
);
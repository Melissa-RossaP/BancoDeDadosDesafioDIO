-- APAGAR TABELAS 
DROP TABLE IF EXISTS ItensServico;
DROP TABLE IF EXISTS OrdemServico;
DROP TABLE IF EXISTS Veiculos;
DROP TABLE IF EXISTS Servicos;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Clientes;

-- TABELA CLIENTES
CREATE TABLE Clientes (
    cliente_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- TABELA VEICULOS
CREATE TABLE Veiculos (
    veiculo_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    ano INT,
    placa VARCHAR(20) UNIQUE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- TABELA SERVICOS
CREATE TABLE Servicos (
    servico_id INTEGER PRIMARY KEY AUTOINCREMENT,
    descricao VARCHAR(200),
    preco DECIMAL(10,2)
);

-- TABELA FUNCIONARIOS
CREATE TABLE Funcionarios (
    funcionario_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2)
);

-- TABELA ORDEM DE SERVICO
CREATE TABLE OrdemServico (
    os_id INTEGER PRIMARY KEY AUTOINCREMENT,
    veiculo_id INTEGER,
    funcionario_id INTEGER,
    data_abertura DATE,
    data_fechamento DATE,
    status VARCHAR(30),
    FOREIGN KEY (veiculo_id) REFERENCES Veiculos(veiculo_id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(funcionario_id)
);

-- TABELA ITENS DE SERVICO
CREATE TABLE ItensServico (
    os_id INTEGER,
    servico_id INTEGER,
    quantidade INTEGER,
    valor_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    PRIMARY KEY (os_id, servico_id),
    FOREIGN KEY (os_id) REFERENCES OrdemServico(os_id),
    FOREIGN KEY (servico_id) REFERENCES Servicos(servico_id)
);

-- INSERT CLIENTES
INSERT INTO Clientes (nome, telefone, email) VALUES
('Melissa Mel', '119999999999', 'mel@gmail.com'),
('Luidy Lu', '11898888888', 'luluidy@gmail.com'),
('Sabrininha', '11977777779', 'sasasas@gmail.com'),
('Luluiz', '11977777777', 'luiz@gmail.com'),
('Jajana', '11877777779', 'jajana@gmail.com'),
('Maria Silva', '11999999999', 'maria@email.com'),
('Carla Rocha', '11944444444', 'carla@email.com');

-- INSERT VEICULOS
INSERT INTO Veiculos (cliente_id, marca, modelo, ano, placa) VALUES
(1, 'Toyota', 'Corolla', 2020, 'ABC1234'),
(2, 'Honda', 'Civic', 2019, 'XYZ5678'),
(3, 'Fiat', 'Uno', 2015, 'DEF3456'),
(4, 'Chevrolet', 'Onix', 2021, 'GHI7890'),
(5, 'Volkswagen', 'Gol', 2018, 'JKL1122'),
(6, 'Hyundai', 'HB20', 2022, 'MNO3344'),
(7, 'Ford', 'Ka', 2017, 'PQR7788');

-- INSERT FUNCIONARIOS
INSERT INTO Funcionarios (nome, cargo, salario) VALUES
('Carlos Mendes', 'Mecânico', 3000.00),
('Rafael Lima', 'Mecânico', 3200.00),
('João Pereira', 'Mecânico', 3100.00),
('Marcos Silva', 'Auxiliar Mecânico', 2200.00),
('Ana Paula', 'Atendente', 2500.00),
('Beatriz Souza', 'Atendente', 2600.00),
('Lucas Fernandes', 'Recepcionista', 2300.00),
('Paulo Henrique', 'Gerente', 4500.00);

-- INSERT SERVICOS
INSERT INTO Servicos (descricao, preco) VALUES
('Troca de óleo', 150.00),
('Alinhamento', 100.00),
('Balanceamento', 120.00),
('Revisão completa', 300.00);

-- INSERT ORDEM DE SERVICO
INSERT INTO OrdemServico (veiculo_id, funcionario_id, data_abertura, status) VALUES
(1, 1, '2026-01-20', 'Aberta'),
(2, 2, '2026-01-21', 'Em andamento'),
(3, 3, '2026-01-22', 'Fechada'),
(4, 4, '2026-01-23', 'Aberta'),
(5, 5, '2026-01-24', 'Em andamento'),
(6, 6, '2026-01-25', 'Fechada'),
(7, 7, '2026-01-26', 'Em andamento');


-- INSERT ITENS DE SERVICO
INSERT INTO ItensServico (os_id, servico_id, quantidade, valor_unitario, valor_total) VALUES
-- OS 1
(1, 1, 1, 150.00, 150.00),
(1, 2, 1, 100.00, 100.00),

-- OS 2
(2, 3, 2, 120.00, 240.00),

-- OS 3
(3, 4, 1, 300.00, 300.00),

-- OS 4
(4, 1, 1, 150.00, 150.00),
(4, 3, 1, 120.00, 120.00),

-- OS 5
(5, 2, 2, 100.00, 200.00),

-- OS 6
(6, 4, 1, 300.00, 300.00),

-- OS 7
(7, 1, 1, 150.00, 150.00),
(7, 2, 1, 100.00, 100.00),
(7, 3, 1, 120.00, 120.00);

-- CONSULTAS DO DESAFIO

-- Clientes cadastrados
SELECT nome, telefone, email FROM Clientes;

-- Veículos de 2020 ou mais novos
SELECT marca, modelo, ano, placa
FROM Veiculos
WHERE ano >= 2020;

-- Veículos e seus clientes
SELECT c.nome AS cliente, v.marca, v.modelo, v.placa
FROM Veiculos v
JOIN Clientes c ON v.cliente_id = c.cliente_id;

-- Valor total de cada item de serviço
SELECT os_id, servico_id, quantidade, valor_unitario,
       quantidade * valor_unitario AS valor_calculado
FROM ItensServico;

-- Serviços do mais caro para o mais barato
SELECT descricao, preco
FROM Servicos
ORDER BY preco DESC;

-- Ordens de serviço com cliente e funcionário
SELECT os.os_id, c.nome AS cliente, f.nome AS funcionario,
       os.status, os.data_abertura
FROM OrdemServico os
JOIN Veiculos v ON os.veiculo_id = v.veiculo_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
JOIN Funcionarios f ON os.funcionario_id = f.funcionario_id;

-- Ordens com valor total maior que 200
SELECT os_id, SUM(valor_total) AS total_ordem
FROM ItensServico
GROUP BY os_id
HAVING SUM(valor_total) > 200;

-- Resumo completo da ordem de serviço
SELECT os.os_id, c.nome AS cliente, v.marca, v.modelo,
       f.nome AS funcionario, os.status,
       SUM(i.valor_total) AS valor_total_ordem
FROM OrdemServico os
JOIN Veiculos v ON os.veiculo_id = v.veiculo_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
JOIN Funcionarios f ON os.funcionario_id = f.funcionario_id
JOIN ItensServico i ON os.os_id = i.os_id
GROUP BY os.os_id, c.nome, v.marca, v.modelo, f.nome, os.status;

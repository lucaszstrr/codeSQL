CREATE TABLE cidade(
    codCidade int PRIMARY KEY AUTO_INCREMENT,
    nome varchar(50) UNIQUE NOT NULL,
    siglaEstado char(2) NOT NULL REFERENCES estado(siglaEstado) ON DELETE no action ON UPDATE cascade
);


CREATE TABLE departamento(
    codDepartamento int PRIMARY KEY,
    nome varchar(40) UNIQUE NOT NULL,
    descricaoFuncional varchar(80),
    localizacao varchar(255)
);


CREATE TABLE estado(
    siglaEstado varchar(2) PRIMARY KEY,
    nome varchar(30) UNIQUE NOT NULL
);


CREATE TABLE vendedor(
    codVendedor bigint PRIMARY KEY AUTO_INCREMENT,
    nome varchar(60) NOT NULL,
    dataNascimento DATE,
    endereco varchar(60),
    cep char(8),
    telefone varchar(20),
    codCidade int DEFAULT 1,
    dataContratacao DATE DEFAULT (current_date),
    codDepartamento int,
    FOREIGN KEY (codDepartamento) REFERENCES departamento(codDepartamento) ON DELETE set null ON UPDATE cascade,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE cascade ON UPDATE cascade
);


CREATE TABLE cliente(
    codCliente bigint PRIMARY KEY AUTO_INCREMENT,
	endereco varchar(60),
	codCidade int NOT NULL,
	telefone varchar(20),
	tipo char(1), 
	dataCadastro DATE DEFAULT (CURRENT_DATE),
	cep char(8),
	CONSTRAINT fk_cli_cid FOREIGN KEY (codCidade) REFERENCES cidade (codCidade) ON DELETE no action ON UPDATE cascade
);


CREATE TABLE clienteFisico(
    codCliente bigint PRIMARY KEY,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente) ON DELETE no action ON UPDATE cascade,
    nome varchar(50) NOT NULL,
    dataNascimento DATE,
    cpf varchar(11) UNIQUE NOT NULL,
    rg varchar(8)
);


CREATE TABLE clienteJuridico(
    codCliente bigint PRIMARY KEY,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente) ON DELETE no action ON UPDATE cascade,
    nomeFantasia varchar(80) UNIQUE,
    razaoSocial varchar(80) UNIQUE NOT NULL,
    ie varchar(20) UNIQUE NOT NULL
);


CREATE TABLE classe(
    codClasse int PRIMARY KEY AUTO_INCREMENT,
    sigla varchar(12),
    nome varchar(40) NOT NULL,
    descricao varchar(80)
);


CREATE TABLE produto(
    codProduto serial PRIMARY KEY,
    descricao varchar(40) NOT NULL,
    unidadeMedida char(2),
    embalagem varchar(15) DEFAULT 'fardo',
    codClasse int,
    FOREIGN KEY (codClasse) REFERENCES classe(codClasse) ON DELETE set null ON UPDATE set null,
    precoVenda DECIMAL(14, 2),
    estoqueMinimo DECIMAL(14, 2)
);


CREATE TABLE produtoLote(
    codProduto bigint UNSIGNED,
    numeroLote bigint UNSIGNED,
    PRIMARY KEY (codProduto, numeroLote),
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto) ON DELETE cascade ON UPDATE cascade,
    quantidadeAdquirida DECIMAL(14,2),
    quantidadeVendida DECIMAL(14, 2),
    precoCusto DECIMAL(14, 2),
    dataValidade DATE
);


CREATE TABLE venda(
    codVenda serial PRIMARY KEY, 
    codCliente bigint NOT NULL,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente) ON DELETE cascade ON UPDATE restrict,
    codVendedor bigint DEFAULT 100,
    FOREIGN KEY (codVendedor) REFERENCES vendedor(codVendedor) ON UPDATE cascade,
    dataVenda DATE DEFAULT (CURRENT_DATE),
    enderecoEntrega varchar(60),
    status varchar(30)
);


CREATE TABLE itemVenda(
    codVenda bigint UNSIGNED,
    codProduto bigint UNSIGNED,
    numeroLote bigint UNSIGNED,
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0),
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda) ON DELETE cascade ON UPDATE cascade,
    FOREIGN KEY (codProduto, numeroLote) REFERENCES produtoLote(codProduto, numeroLote) ON DELETE no action ON UPDATE cascade
);


CREATE TABLE fornecedor(
    codFornecedor bigint PRIMARY KEY,
    nomeFantasia varchar(80) UNIQUE,
    razaoSocial varchar(80) UNIQUE NOT NULL,
    ie varchar(20) UNIQUE NOT NULL,
    cgc varchar(20) UNIQUE NOT NULL,
    endereco varchar(60),
    telefone varchar(20),
    codCidade int,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE restrict ON UPDATE cascade
);


CREATE TABLE pedido(
    codPedido bigint PRIMARY KEY,
    dataRealizacao DATE DEFAULT (CURRENT_DATE),
    dataEntrega DATE,
    codFornecedor bigint,
    FOREIGN KEY (codFornecedor) REFERENCES fornecedor(codFornecedor) ON DELETE cascade ON UPDATE set null,
    valor DECIMAL(20, 2)
);


CREATE TABLE itemPedido(
    codPedido bigint,
    codProduto bigint,
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0),
    PRIMARY KEY (codPedido, codProduto),
    FOREIGN KEY (codPedido) REFERENCES pedido(codPedido) ON DELETE cascade ON UPDATE cascade
);


CREATE TABLE contasPagar(
    codTitulo bigint PRIMARY KEY,
    dataVencimento DATE NOT NULL,
    parcela int,
    codPedido bigint,
    FOREIGN KEY (codPedido) REFERENCES itemPedido(codPedido) ON DELETE cascade ON UPDATE cascade,
    valor DECIMAL(20, 2),
    dataPagamento DATE,
    localPagamento varchar(80),
    juros DECIMAL(12, 2),
    correcaoMonetaria DECIMAL(12, 2)
);


CREATE TABLE contasReceber(
    codTitulo bigint PRIMARY KEY,
    dataVencimento DATE NOT NULL,
    codVenda bigint UNSIGNED,
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda) ON DELETE cascade ON UPDATE cascade,
    parcela bigint,
    valor DECIMAL(20, 2),
    dataPagamento DATE,
    localPagamento varchar(80),
    juros DECIMAL(12, 2),
    correcaoMonetaria DECIMAL(12, 2)
);

----INSERTS----
-- Inserindo estados
INSERT INTO estado (siglaEstado, nome) VALUES 
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais');

-- Inserindo cidades
INSERT INTO cidade (nome, siglaEstado) VALUES 
('São Paulo', 'SP'),
('Rio de Janeiro', 'RJ'),
('Belo Horizonte', 'MG');

-- Inserindo departamentos
INSERT INTO departamento (codDepartamento, nome) VALUES 
(123, 'Vendas'),
(456, 'Marketing'),
(789, 'Financeiro');

-- Inserindo vendedores
INSERT INTO vendedor (codVendedor, nome, dataNascimento, endereco, cep, telefone, codCidade, dataContratacao, codDepartamento) VALUES 
(1, 'Carlos Silva', '1985-06-15', 'Rua A, 123', '01001000', '11999999999', 1, '2000-01-01', 123),
(2, 'Mariana Souza', '1990-09-22', 'Av. B, 456', '20040002', '21988888888', 2, '2000-01-01', 456),
(3, 'Roberto Lima', '1982-11-05', 'Rua E, 789', '30130000', '31955555555', 3, '2000-01-01', 789);

-- Inserindo clientes
INSERT INTO cliente (endereco, codCidade, telefone, tipo, cep) VALUES 
('Rua C, 789', 1, '11977777777', 'F', '01153000'),
('Av. D, 101', 2, '21966666666', 'J', '20050030'),
('Rua F, 555', 3, '31988887777', 'F', '30110020');

-- Inserindo clientes físicos
INSERT INTO clienteFisico (codCliente, nome, dataNascimento, cpf, rg) VALUES 
(1, 'João Pereira', '1992-08-10', '12345678901', '12345678'),
(2, 'Ana Souza', '1988-04-15', '98765432100', '87654321');

-- Inserindo clientes jurídicos
INSERT INTO clienteJuridico (codCliente, nomeFantasia, razaoSocial, ie) VALUES 
(1, 'Loja XYZ', 'XYZ Comércio Ltda', '987654321');

-- Inserindo classes de produtos
INSERT INTO classe (codClasse, sigla, nome, descricao) VALUES 
(1, 'asd', 'classe1', 'Alimentos'),
(2, 'asd', 'classe2', 'Bebidas'),
(3, 'asd', 'classe3', 'Eletrônicos');

-- Inserindo produtos
INSERT INTO produto (descricao, unidadeMedida, embalagem, codClasse, precoVenda, estoqueMinimo) VALUES 
('Arroz', 'kg', 'pacote', 1, 5.50, 10),
('Refrigerante', 'L', 'garrafa', 2, 7.00, 5),
('Fone de Ouvido', 'un', 'caixa', 3, 150.00, 2);

-- Inserindo lotes de produtos
INSERT INTO produtoLote (codProduto, numeroLote, quantidadeAdquirida, quantidadeVendida, precoCusto, dataValidade) VALUES 
(4, 101, 200, 50, 4.00, '2025-12-31'),
(5, 202, 150, 30, 5.00, '2025-09-15'),
(6, 303, 20, 5, 120.00, NULL);

-- Inserindo fornecedores
INSERT INTO fornecedor (codFornecedor, nomeFantasia, razaoSocial, ie, cgc, endereco, telefone, codCidade) VALUES 
(1, 'Fornecedor A', 'Fornecedor A Ltda', '1122334455', '12345678000101', 'Rua E, 55', '1133334444', 1),
(2, 'Fornecedor B', 'Fornecedor B Ltda', '2233445566', '98765432000102', 'Av. G, 78', '2134445555', 2);

-- Inserindo pedidos
INSERT INTO pedido (codPedido, dataEntrega, codFornecedor, valor) VALUES 
(1, '2025-04-10', 1, 500.00),
(2, '2025-05-20', 2, 1000.00);

-- Inserindo itens nos pedidos
INSERT INTO itemPedido (codPedido, codProduto, quantidade) VALUES 
(1, 4, 100),
(1, 5, 50),
(2, 6, 10);

-- Inserindo vendas
INSERT INTO venda (codCliente, codVendedor, enderecoEntrega, status) VALUES 
(1, 1, 'Rua C, 789', 'Finalizada'),
(2, 2, 'Av. D, 101', 'Pendente'),
(3, 3, 'Rua F, 555', 'Em andamento');

-- Inserindo itens das vendas
INSERT INTO itemVenda (codVenda, codProduto, numeroLote, quantidade) VALUES 
(7, 4, 101, 100),
(8, 5, 202, 100),
(9, 6, 303, 10);


-- Inserindo contas a pagar
INSERT INTO contasPagar (codTitulo, dataVencimento, parcela, codPedido, valor, localPagamento, juros, correcaoMonetaria) VALUES 
(1, '2025-05-01', 1, 1, 500.00, 'Banco X', 5.00, 2.00),
(2, '2025-06-15', 2, 2, 1000.00, 'Banco Y', 10.00, 5.00);

INSERT INTO contasReceber (codTitulo, codVenda, dataVencimento, parcela, valor, dataPagamento, juros, correcaoMonetaria)
VALUES 
(1, 7, '2025-04-01', 1, 500.00, NULL, 0.00, 0.00),
(2, 8, '2025-05-01', 2, 500.00, NULL, 0.00, 0.00);


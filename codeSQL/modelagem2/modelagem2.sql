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


CREATE TABLE  cidade(
    codCidade int PRIMARY KEY AUTO_INCREMENT,
    nome varchar(50) UNIQUE NOT NULL,
    siglaEstado char(2) NOT NULL,
    FOREIGN KEY (siglaEstado) REFERENCES estado(siglaEstado)
);


CREATE TABLE vendedor(
    codVendedor int PRIMARY KEY AUTO_INCREMENT,
    nome varchar(50) UNIQUE NOT NULL,
    dataNascimento DATE,
    endereco varchar(60),
    cep char(8),
    telefone varchar(20),
    codCidade int, 
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade),
    dataContratacao DATE DEFAULT (CURRENT_DATE),
    codDepartamento int,
    FOREIGN KEY (codDepartamento) REFERENCES departamento(codDepartamento)
);


CREATE TABLE cliente(
    codCliente int PRIMARY KEY AUTO_INCREMENT,
    endereco varchar(60),
    codCidade int NOT NULL,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade),
    telefone varchar(20),
    tipo char(1) CHECK (tipo IN('F', 'J')),
    dataCadastro DATE DEFAULT (CURRENT_DATE),
    cep char(8)
);


CREATE TABLE clienteFisico(
    codCliente int PRIMARY KEY,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente),
    nome varchar(50) NOT NULL,
    dataNascimento DATE,
    cpf varchar(11) UNIQUE NOT NULL,
    rg varchar(8)
);


CREATE TABLE clienteJuridico(
    codCliente int PRIMARY KEY,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente),
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
    codProduto int PRIMARY KEY AUTO_INCREMENT,
    descricao varchar(40) NOT NULL,
    unidadeMedida char(2),
    embalagem varchar(15) DEFAULT 'fardo',
    codClasse int,
    FOREIGN KEY (codClasse) REFERENCES classe(codClasse),
    precoVenda DECIMAL(14, 2),
    estoqueMinimo DECIMAL(14, 2)
);


CREATE TABLE produtoLote(
    codProduto int PRIMARY KEY,
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto),
    numeroLote int,
    quantidadeAdquirida DECIMAL(14,2),
    quantidadeVendida DECIMAL(14, 2),
    precoCusto DECIMAL(14, 2),
    dataValidade DATE
);


CREATE TABLE venda(
    codVenda int PRIMARY KEY, 
    codCliente int,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente),
    codVendedor int,
    FOREIGN KEY (codVendedor) REFERENCES vendedor(codVendedor),
    dataVenda DATE DEFAULT (CURRENT_DATE),
    enderecoEntrega varchar(60),
    status varchar(30)
);


CREATE TABLE itemVenda(
    codVenda int,
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda),
    codProduto int,
    FOREIGN KEY (codProduto) REFERENCES produtoLote(codProduto),
    numeroLote int PRIMARY KEY,
    FOREIGN KEY (numeroLote) REFERENCES produtoLote(numeroLote),
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0)
);

DROP TABLE itemVenda;

CREATE TABLE fornecedor(
    codFornecedor int PRIMARY KEY,
    nomeFantasia varchar(80) UNIQUE,
    razaoSocial varchar(80) UNIQUE NOT NULL,
    ie varchar(20) UNIQUE NOT NULL,
    cgc varchar(20) UNIQUE NOT NULL,
    endereco varchar(60),
    telefone varchar(20),
    codCidade int,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade)
);


CREATE TABLE pedido(
    codPedido int PRIMARY KEY,
    dataRealizacao DATE DEFAULT (CURRENT_DATE),
    dataEntrega DATE,
    codFornecedor int,
    FOREIGN KEY (codFornecedor) REFERENCES fornecedor(codFornecedor),
    valor DECIMAL(20, 2)
);


CREATE TABLE pessoa(
    nome varchar(40) UNIQUE NOT NULL,
    idade int NOT NULL,
    sexo varchar(5) CHECK (sexo in('M', 'F', 'Outro'))
);

CREATE TABLE itemPedido(
    codPedido int PRIMARY KEY,
    FOREIGN KEY (codPedido) REFERENCES pedido(codPedido),
    codProduto int,
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0)
);


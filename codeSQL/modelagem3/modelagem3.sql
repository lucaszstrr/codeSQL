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
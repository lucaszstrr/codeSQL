CREATE TABLE departamento(
    codDepartamento SERIAL,
    nome varchar(40) UNIQUE NOT NULL,
    descricaoFuncional varchar(80),
    localizacao varchar(255)
)

CREATE TABLE estado(
    siglaEstado varchar(2),
    nome varchar(30) UNIQUE NOT NULL
);

CREATE TABLE  cidade(
    codCidade int KEY AUTO_INCREMENT,
    nome varchar(50) UNIQUE NOT NULL,
    siglaEstado varchar(2) NOT NULL
);

CREATE TABLE vendedor(
    codVendedor int KEY AUTO_INCREMENT,
    nome varchar(50) UNIQUE NOT NULL,
    dataNascimento DATE,
    endereco varchar(60),
    cep char(8),
    telefone varchar(20),
    codCidade int, 
    dataContratacao DATE DEFAULT (CURRENT_DATE),
    codDepartamento int
);

CREATE TABLE cliente(
    codCliente int KEY AUTO_INCREMENT,
    endereco varchar(60),
    codCidade int NOT NULL,
    telefone varchar(20),
    tipo char(1) CHECK (tipo IN('F', 'J')),
    dataCadastro DATE DEFAULT (CURRENT_DATE),
    cep char(8)
);

CREATE TABLE clienteFisico(
    codCliente int,
    nome varchar(50) NOT NULL,
    dataNascimento DATE,
    cpf varchar(11) UNIQUE NOT NULL,
    rg varchar(8)
);

CREATE TABLE clienteJuridico(
    codCliente int,
    nomeFantasia varchar(80) UNIQUE,
    razaoSocial varchar(80) UNIQUE NOT NULL,
    ie varchar(20) UNIQUE NOT NULL
);

CREATE TABLE classe(
    codClasse int KEY AUTO_INCREMENT,
    sigla varchar(12),
    nome varchar(40) NOT NULL,
    descricao varchar(80)
);

CREATE TABLE produto(
    codProduto int KEY AUTO_INCREMENT,
    descricao varchar(40) NOT NULL,
    unidadeMedida char(2),
    embalagem varchar(15) DEFAULT 'fardo',
    codClasse int,
    precoVenda DECIMAL(14, 2),
    estoqueMinimo DECIMAL(14, 2)
);

CREATE TABLE produtoLote(
    codProduto int,
    numeroLote int,
    quantidadeAdquirida DECIMAL(14,2),
    quantidadeVendida DECIMAL(14, 2),
    precoCusto DECIMAL(14, 2),
    dataValidade DATE
);

CREATE TABLE venda(
    codVenda int, 
    codCliente int,
    codVendedor int,
    dataVenda DATE DEFAULT (CURRENT_DATE),
    enderecoEntrega varchar(60),
    status varchar(30)
);

CREATE TABLE itemVenda(
    codVenda int,
    codProduto int,
    numeroLote int,
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0)
);

CREATE TABLE fornecedor(
    codFornecedor int,
    nomeFantasia varchar(80) UNIQUE,
    razaoSocial varchar(80) UNIQUE NOT NULL,
    ie varchar(20) UNIQUE NOT NULL,
    cgc varchar(20) UNIQUE NOT NULL,
    endereco varchar(60),
    telefone varchar(20),
    codCidade int
);

CREATE TABLE pedido(
    codPedido SERIAL,
    dataRealizacao DATE DEFAULT (CURRENT_DATE),
    dataEntrega DATE,
    codFornecedor int,
    valor DECIMAL(20, 2)
);

CREATE TABLE itemPedido(
    codPedido int,
    codProduto int,
    quantidade DECIMAL(14, 2) NOT NULL CHECK (quantidade>=0)
);
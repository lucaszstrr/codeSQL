-- Informações dos produtos cadastrados
SELECT * FROM produto;

-- Listando fornecedores
SELECT codFornecedor, nomeFantasia, endereco, telefone, codCidade FROM fornecedor;

-- Consultando o codigo e data da venda que está finalizada e/ou em andamento
SELECT codVenda, dataVenda FROM venda WHERE status = 'Finalizada' || status = 'Em andamento';

-- Listando todas as infos da tabela de pessoas jurídicas
SELECT * FROM clienteJuridico;

-- Nome dos departamentos 
SELECT nome FROM departamento;
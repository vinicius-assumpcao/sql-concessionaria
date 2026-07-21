USE concessionaria;

-- ==========================================
-- PROJETO: CONCESSIONÁRIA
-- ARQUIVO: CONSULTAS SQL
-- ==========================================

-- ==========================================
-- CONSULTAS BÁSICAS
-- ==========================================

-- 1. Listar todos os clientes
SELECT * FROM cliente;

-- 2. Listar todos os vendedores
SELECT * FROM vendedor;

-- 3. Listar todas as marcas
SELECT * FROM marca;

-- 4. Listar todos os veículos
SELECT * FROM inventario;

-- 5. Veículos disponíveis
SELECT *
FROM inventario
WHERE situacao = 'Disponível';

-- 6. Veículos vendidos
SELECT *
FROM inventario
WHERE situacao = 'Vendido';

-- 7. Veículos fabricados a partir de 2023
SELECT *
FROM inventario
WHERE ano >= 2023;

-- 8. Clientes em ordem alfabética
SELECT *
FROM cliente
ORDER BY nome;

-- 9. Cinco veículos com maior quilometragem
SELECT *
FROM inventario
ORDER BY quilometragem DESC
LIMIT 5;

-- 10. Cinco maiores vendas
SELECT *
FROM venda
ORDER BY valor_venda DESC
LIMIT 5;

-- ==========================================
-- JOINS
-- ==========================================

-- 11. Veículos com suas respectivas marcas
SELECT
    i.modelo,
    m.nome_marca,
    i.ano,
    i.cor,
    i.preco
FROM inventario i
INNER JOIN marca m
ON i.marca_id = m.marca_id;

-- 12. Histórico completo de vendas
SELECT
    v.venda_id,
    c.nome,
    c.sobrenome,
    i.modelo,
    m.nome_marca,
    vd.nome AS vendedor,
    v.valor_venda,
    v.forma_pagamento,
    v.data_venda
FROM venda v
INNER JOIN cliente c
ON v.cliente_id = c.cliente_id
INNER JOIN inventario i
ON v.inventario_id = i.inventario_id
INNER JOIN marca m
ON i.marca_id = m.marca_id
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id;

-- ==========================================
-- FUNÇÕES DE AGREGAÇÃO
-- ==========================================

-- 13. Valor total vendido
SELECT SUM(valor_venda) AS faturamento_total
FROM venda;

-- 14. Média das vendas
SELECT AVG(valor_venda) AS ticket_medio
FROM venda;

-- 15. Maior venda
SELECT MAX(valor_venda) AS maior_venda
FROM venda;

-- 16. Menor venda
SELECT MIN(valor_venda) AS menor_venda
FROM venda;

-- 17. Quantidade total de vendas
SELECT COUNT(*) AS total_vendas
FROM venda;

-- ==========================================
-- GROUP BY
-- ==========================================

-- 18. Quantidade de veículos por marca
SELECT
    m.nome_marca,
    COUNT(*) AS quantidade
FROM inventario i
INNER JOIN marca m
ON i.marca_id = m.marca_id
GROUP BY m.nome_marca;

-- 19. Quantidade de vendas por vendedor
SELECT
    vd.nome,
    COUNT(*) AS vendas
FROM venda v
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id
GROUP BY vd.nome;

-- 20. Faturamento por vendedor
SELECT
    vd.nome,
    SUM(v.valor_venda) AS faturamento
FROM venda v
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id
GROUP BY vd.nome;

-- 21. Ticket médio por vendedor
SELECT
    vd.nome,
    AVG(v.valor_venda) AS ticket_medio
FROM venda v
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id
GROUP BY vd.nome;

-- ==========================================
-- HAVING
-- ==========================================

-- 22. Vendedores com mais de cinco vendas
SELECT
    vd.nome,
    COUNT(*) AS vendas
FROM venda v
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id
GROUP BY vd.nome
HAVING COUNT(*) > 5;

-- 23. Marcas com mais de dois veículos cadastrados
SELECT
    m.nome_marca,
    COUNT(*) AS quantidade
FROM inventario i
INNER JOIN marca m
ON i.marca_id = m.marca_id
GROUP BY m.nome_marca
HAVING COUNT(*) > 2;

-- ==========================================
-- SUBQUERIES
-- ==========================================

-- 24. Veículo mais caro do estoque
SELECT *
FROM inventario
WHERE preco = (
    SELECT MAX(preco)
    FROM inventario
);

-- 25. Veículo mais barato do estoque
SELECT *
FROM inventario
WHERE preco = (
    SELECT MIN(preco)
    FROM inventario
);

-- 26. Clientes que já realizaram compras
SELECT *
FROM cliente
WHERE cliente_id IN (
    SELECT cliente_id
    FROM venda
);

-- ==========================================
-- EXISTS
-- ==========================================

-- 27. Clientes que possuem pelo menos uma compra
SELECT *
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM venda v
    WHERE v.cliente_id = c.cliente_id
);

-- ==========================================
-- CASE
-- ==========================================

-- 28. Classificação da quilometragem
SELECT
    modelo,
    quilometragem,
    CASE
        WHEN quilometragem < 10000 THEN 'Baixa'
        WHEN quilometragem < 30000 THEN 'Média'
        ELSE 'Alta'
    END AS categoria
FROM inventario;

-- 29. Classificação por faixa de preço
SELECT
    modelo,
    preco,
    CASE
        WHEN preco < 90000 THEN 'Econômico'
        WHEN preco < 150000 THEN 'Intermediário'
        ELSE 'Premium'
    END AS categoria
FROM inventario;

-- ==========================================
-- VIEW
-- ==========================================

DROP VIEW IF EXISTS vw_historico_vendas;

CREATE VIEW vw_historico_vendas AS
SELECT
    v.venda_id,
    c.nome,
    c.sobrenome,
    i.modelo,
    m.nome_marca,
    vd.nome AS vendedor,
    v.valor_venda,
    v.forma_pagamento,
    v.data_venda
FROM venda v
INNER JOIN cliente c
ON v.cliente_id = c.cliente_id
INNER JOIN inventario i
ON v.inventario_id = i.inventario_id
INNER JOIN marca m
ON i.marca_id = m.marca_id
INNER JOIN vendedor vd
ON v.vendedor_id = vd.vendedor_id;

-- 30. Consultar a VIEW criada
SELECT *
FROM vw_historico_vendas;

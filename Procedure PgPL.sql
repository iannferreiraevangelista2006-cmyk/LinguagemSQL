CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    produto_id INT REFERENCES produtos(id),
    quantidade INT NOT NULL,
    valor_total DECIMAL(10, 2),
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO produtos (nome, preco, estoque) VALUES 
('Produto A', 10.00, 100),
('Produto B', 20.00, 50),
('Produto C', 5.00, 200);

CREATE OR REPLACE PROCEDURE realizar_venda(p_produto_id INT, p_quantidade INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_preco DECIMAL(10, 2);
    v_estoque_atual INT;
    v_valor_total DECIMAL(10, 2);
BEGIN

    SELECT preco, estoque INTO v_preco, v_estoque_atual 
    FROM produtos 
    WHERE id = p_produto_id;


    IF NOT FOUND THEN
        RAISE EXCEPTION 'Erro: Produto com ID % não encontrado.', p_produto_id;
    END IF;


    IF v_estoque_atual < p_quantidade THEN
        RAISE EXCEPTION 'Erro: Estoque insuficiente. (Disponível: %, Solicitado: %)', v_estoque_atual, p_quantidade;
    END IF;


    v_valor_total := v_preco * p_quantidade;


    INSERT INTO vendas (produto_id, quantidade, valor_total)
    VALUES (p_produto_id, p_quantidade, v_valor_total);


    UPDATE produtos 
    SET estoque = estoque - p_quantidade 
    WHERE id = p_produto_id;

    RAISE NOTICE 'Venda realizada com sucesso! Total: R$ %', v_valor_total;

END;
$$;

CALL realizar_venda(1, 2); 

CALL realizar_venda(2, 60);

SELECT * FROM vendas;
SELECT * FROM produtos;

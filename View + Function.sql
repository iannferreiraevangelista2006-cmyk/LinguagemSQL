
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    active BOOLEAN
);


INSERT INTO users (name, email, active) VALUES 
('Lucas Silva', 'lucas@email.com', true),
('Mariana Souza', 'mari@email.com', false),
('Crimson Tech', 'suporte@email.com', true);



CREATE OR REPLACE VIEW active_users_view AS
SELECT id, name, email
FROM users
WHERE active = true;



CREATE OR REPLACE FUNCTION check_user_status(p_id INT) 
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
DECLARE
    v_active BOOLEAN;
BEGIN
   
    SELECT active INTO v_active 
    FROM users 
    WHERE id = p_id;

    IF NOT FOUND THEN
        RETURN 'Usuário não encontrado';
    ELSIF v_active = true THEN
        RETURN 'Usuário ativo';
    ELSE
        RETURN 'Usuário inativo';
    END IF;
END;
$$;


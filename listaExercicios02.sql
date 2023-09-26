DELIMITER //

CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END;
//

DELIMITER ;

CALL sp_ListarAutores(); 

DELIMITER //

CREATE PROCEDURE sp_LivrosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END;
//

DELIMITER ;

CALL sp_LivrosPorCategoria('CategoriaEscolhida');

DELIMITER //

CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoria_nome VARCHAR(100), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END;
//

DELIMITER ;

CALL sp_ContarLivrosPorCategoria('CategoriaDesejada', @total);
SELECT @total;

DELIMITER //

CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoria_nome VARCHAR(100), OUT possui_livros BOOLEAN)
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoria_nome
    ) INTO possui_livros;
END;
//

DELIMITER ;

CALL sp_VerificarLivrosCategoria('CategoriaDesejada', @possui_livros);
SELECT @possui_livros;

DELIMITER //

CREATE PROCEDURE sp_LivrosAteAno(IN ano_limite INT)
BEGIN
    SELECT Titulo
    FROM Livro
    WHERE Ano_Publicacao <= ano_limite;
END;
//

DELIMITER ;

CALL sp_LivrosAteAno(AnoDesejado);

DELIMITER //

CREATE PROCEDURE sp_TitulosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END;
//

DELIMITER ;

CALL sp_TitulosPorCategoria('CategoriaDesejada');

DELIMITER //

CREATE PROCEDURE sp_AdicionarLivro(
    IN titulo VARCHAR(255),
    IN editora_id INT,
    IN ano_publicacao INT,
    IN numero_paginas INT,
    IN categoria_id INT,
    OUT mensagem VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SET mensagem = 'Erro: Título duplicado. O livro já existe.';
    END;

    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (titulo, editora_id, ano_publicacao, numero_paginas, categoria_id);

    SET mensagem = 'Livro adicionado com sucesso.';
END;
//

DELIMITER ;

CALL sp_AdicionarLivro('Novo Livro', 1, 2023, 250, 2, @mensagem);
SELECT @mensagem;

DELIMITER //

CREATE PROCEDURE sp_AutorMaisAntigo(OUT nome_autor VARCHAR(255))
BEGIN
    SELECT CONCAT(Nome, ' ', Sobrenome)
    FROM Autor
    WHERE Data_Nascimento = (
        SELECT MIN(Data_Nascimento)
        FROM Autor
    ) LIMIT 1 INTO nome_autor;
END;
//

DELIMITER ;

CALL sp_AutorMaisAntigo(@nome_autor);
SELECT @nome_autor;

DELIMITER //

CREATE PROCEDURE sp_LivrosESeusAutores()
BEGIN
    SELECT Livro.Titulo, CONCAT(Autor.Nome, ' ', Autor.Sobrenome) AS NomeAutor
    FROM Livro
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID;
END;
//

DELIMITER ;

CALL sp_LivrosESeusAutores();
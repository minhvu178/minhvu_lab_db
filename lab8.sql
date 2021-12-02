DROP DATABASE IF EXISTS poke_trade;
CREATE DATABASE poke_trade;
USE poke_trade;

CREATE TABLE trainers (
    PRIMARY KEY     (trainer_id),
    trainer_id      INT AUTO_INCREMENT,
    trainer_name    CHAR(16)
);

CREATE TABLE pokemon_species (
    PRIMARY KEY     (species_id),
    species_id      INT AUTO_INCREMENT,
    species_name   CHAR(16)
);

CREATE TABLE pokemon (
    PRIMARY KEY     (pokemon_id),
    pokemon_id      INT AUTO_INCREMENT,
    FOREIGN KEY     (trainer_id) REFERENCES  trainers(trainer_id),
    trainer_id      INT NOT NULL,
    pokemon_name    CHAR(16),
    available       BOOLEAN
    
);

INSERT INTO trainers(trainer_name) 
VALUES ('Will'), -- Elite Four from Pokémon Gold/Silver/Crystal era.
       ('Koga'),
       ('Bruno'),
       ('Lance');

INSERT INTO pokemon_species (species_name)
VALUES ('Pikachu'),
       ('Charmander'),
       ('Bulbasuar'),
       ('Squirtle'),
       ('Geodude'),
       ('Magikarp'),
       ('Weedle'),
       ('Butterfree');

SET @max_limit = 6;
SET @min_limit = 1;


DROP FUNCTION IF EXISTS trainer_active;
CREATE FUNCTION trainer_active (IDtrainer INT)
RETURNS BOOLEAN
BEGIN
    RETURN (SELECT COUNT(*) FROM pokemon WHERE trainer_id = IDtrainer AND available = true) >= @min_limit
END;


DELIMITER //

CREATE TRIGGER max_limit
AFTER INSERT ON pokemon FOR EACH ROW
BEGIN

    IF 
    (SELECT COUNT(*) FROM pokemon WHERE available = true GROUP BY trainer_id HAVING trainer_id = NEW.trainer_id) > @max_limit; 
    THEN
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exceed limits.';
        END;
    END IF;
END;
//
DELIMITER;

DELIMITER //

CREATE TRIGGER min_delete
AFTER DELETE ON pokemon FOR EACH ROW
BEGIN
    IF
    (SELECT COUNT(*) FROM pokemon WHERE available = true GROUP BY trainer_id HAVING trainer_id = OLD.trainer_id) < @min_limit;
    THEN 
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exceed limits.';
        END;
    END IF;
END;
COMMIT//

DELIMITER;



SELECT * FROM trainers;
SELECT * FROM pokemon;
INSERT INTO pokemon (trainer_id, pokemon_name, available) 
VALUES (1, 'Pikachu', true),
       (1, 'Charmander', true),
       (1, 'Bulbasuar', true),
       (1, 'Squirtle', true),
       (1, 'Geodude', true),
       (1, 'Magikarp', true),
       (1, 'Magikarp', true),
       (2, 'Charmander', true),
       (2, 'Bulbasuar', true),
       (2, 'Squirtle', true),
       (2, 'Geodude', true),
       (2, 'Magikarp', true);
       

SELECT * FROM pokemon;

INSERT INTO pokemon (trainer_id, pokemon_name, available) 
VALUES (1, 'Pikachu', true),
       (1, 'Charmander', true),
       (1, 'Bulbasuar', true),
       (1, 'Squirtle', true),
       (1, 'Geodude', true),
       (1, 'Magikarp', true),
       (2, 'Charmander', true),
       (2, 'Bulbasuar', true),
       (2, 'Squirtle', true),
       (2, 'Geodude', true),
       (2, 'Magikarp', true);


SELECT * FROM pokemon;

DELETE FROM pokemon WHERE trainer_id = 1;
-- DROP FUNCTION IF EXISTS pokemon_available;
-- CREATE FUNCTION pokemon_available(trainer_name CHAR(16), pokemon_name CHAR(16))
-- RETURN BOOLEAN
-- RETURN (
--     SELECT CASE WHEN EXISTS (
--         SELECT available FROM pokemon 
--     )
-- );

-- CREATE PROCEDURE trade_pokemon(first_trainer CHAR(16), second_trainer CHAR(16), first_pokemon CHAR(16), second_pokemon CHAR(16))
-- BEGIN
--     START TRANSACION;
--         IF BALA

-- DELIMITER //
-- CREATE PROCEDURE remove_trainer(@trainer_id INT)
-- BEGIN
--         DELETE FROM trainers WHERE trainer_id = @trainer_id;

-- END//



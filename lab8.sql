-- WB: Good work Minh.
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
DELIMITER //

DROP FUNCTION IF EXISTS trainer_active;
CREATE FUNCTION trainer_active (IDtrainer INT)
RETURNS BOOLEAN
BEGIN
    RETURN (SELECT COUNT(*) FROM pokemon WHERE trainer_id = IDtrainer AND available = true) >= @min_limit;
END
//

CREATE TRIGGER max_limit
AFTER INSERT ON pokemon FOR EACH ROW
BEGIN

    IF 
    (SELECT COUNT(*) FROM pokemon WHERE available = true GROUP BY trainer_id HAVING trainer_id = NEW.trainer_id) > @max_limit
    THEN
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exceed limits.';
        END;
    END IF;
END
//



CREATE TRIGGER min_delete
AFTER DELETE ON pokemon FOR EACH ROW
BEGIN
    IF
    (SELECT COUNT(*) FROM pokemon WHERE available = true GROUP BY trainer_id HAVING trainer_id = OLD.trainer_id) < @min_limit
    THEN 
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exceed limits.';
        END;
    END IF;
END
//
DELIMITER ;



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
DELIMITER $$
-- DELETE FROM pokemon WHERE trainer_id = 1;
DROP FUNCTION IF EXISTS pokemon_available;
CREATE FUNCTION pokemon_available(trainerId CHAR(16), pokemonId CHAR(16))
RETURNS BOOLEAN
  BEGIN
   IF EXISTS (SELECT available FROM pokemon WHERE trainer_id = trainerId AND pokemon_id = pokemonId)
     THEN
       RETURN TRUE;
     ELSE
       RETURN FALSE;
  END IF;
  END
$$


CREATE PROCEDURE remove_trainer(trainerId CHAR(16))
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    DELETE FROM trainers WHERE trainer_id = trainerId;
    DELETE FROM pokemon WHERE trainer_id = trainerId;
    SET FOREIGN_KEY_CHECKS=1;
END
$$


CREATE PROCEDURE trade_pokemon(first_trainer CHAR(16), second_trainer CHAR(16),first_pokemon CHAR(16), second_pokemon CHAR(16))
BEGIN
START TRANSACTION;
  SET @firstTrainer = (SELECT first_trainer);
  SET @secondTrainer = (SELECT second_trainer);
  SET @firstPokemon = (SELECT first_pokemon);
  SET @secondPokemon = (SELECT second_pokemon);

  SET @countPokemon1 = (SELECT COUNT(*) FROM pokemon e WHERE e.available = TRUE GROUP BY e.trainer_id HAVING e.trainer_id = @firstTrainer);
  SET @countPokemon2 = (SELECT COUNT(*) FROM pokemon e WHERE e.available = TRUE GROUP BY e.trainer_id HAVING e.trainer_id = @secondTrainer);

  IF (@countPokemon1 < @min_limit OR @countPokemon1 >@max_limit) OR (@countPokemon2 < @min_limit OR @countPokemon2 >@max_limit) THEN 
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exceed limits.';
            ROLLBACK;
        END;
    ELSE 
        IF !pokemon_available(@firstTrainer, @firstPokemon) OR !pokemon_available(@secondTrainer, @secondPokemon) THEN 
            BEGIN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pokemon not available for trade.';
                ROLLBACK;
            END;
        ELSE 
            
            -- IF (SELECT COUNT(*) FROM pokemon e WHERE e.available = TRUE GROUP BY e.trainer_id HAVING e.trainer_id = @secondTrainer) = 0 THEN
            --     DELETE FROM trainers WHERE trainer_id = @secondPokemon;
            --     UPDATE pokemon SET pokemon_id = @firstPokemon, trainer_id = @firstTrainer;
                    
            -- ELSE 

            --     IF (SELECT COUNT(*) FROM pokemon e WHERE e.available = TRUE GROUP BY e.trainer_id HAVING e.trainer_id = @secondTrainer) = 0
            --       THEN 
                    
            --         UPDATE pokemon
            --         SET trainer_id = @firstTrainer
            --         WHERE trainer_id = @secondTrainer AND ( pokemon_id = @secondPokemon OR pokemon_id = @firstPokemon);
            --     END IF;
            -- END IF;

            UPDATE pokemon SET trainer_id = @secondTrainer WHERE pokemon_id = @firstPokemon;
            UPDATE pokemon SET trainer_id = @firstTrainer WHERE pokemon_id = @secondPokemon;
        END IF;
     END IF;
  COMMIT;
END
$$
DELIMITER ;

CALL trade_pokemon(1,2,13,20);
SELECT * FROM pokemon;
CALL trade_pokemon(1,2,1,23);
SELECT * FROM pokemon;
CALL remove_trainer(1);
SELECT * FROM pokemon;

-- 
-- 
-- DELIMITER //
-- 
-- CREATE PROCEDURE remove_trainer(@trainer_id INT)
-- BEGIN
--         DELETE FROM trainers WHERE trainer_id = @trainer_id
-- END;
-- 
-- //
-- DELIMITER ;



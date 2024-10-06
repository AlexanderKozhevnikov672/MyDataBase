CREATE OR REPLACE FUNCTION check_player_new_info()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  cnt INTEGER;
BEGIN
  SELECT COUNT(*) INTO cnt
  FROM cw.clan
  WHERE cw.clan.clan_id = NEW.clan_id;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No clan with "%" id', NEW.clan_id
          USING ERRCODE = '22000';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER check_player_new_info
BEFORE INSERT OR UPDATE ON cw.player
FOR EACH ROW
EXECUTE PROCEDURE check_player_new_info();



CREATE OR REPLACE FUNCTION check_war_new_info()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  cnt INTEGER;
BEGIN
  IF NEW.attacker_id = NEW.defender_id THEN
    RAISE EXCEPTION 'Attacker id cannot be equal to defender id'
          USING ERRCODE = '22000';
  END IF;

  IF NOT NEW.winner_id IN (NEW.attacker_id, NEW.defender_id) THEN
    RAISE EXCEPTION 'Winner id should be in (attacker_id, defender_id)'
          USING ERRCODE = '22000';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM cw.clan
  WHERE cw.clan.clan_id = NEW.attacker_id;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No clan with "%" id', NEW.attacker_id
          USING ERRCODE = '22000';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM cw.clan
  WHERE cw.clan.clan_id = NEW.defender_id;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No clan with "%" id', NEW.defender_id
          USING ERRCODE = '22000';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER check_war_new_info
BEFORE INSERT OR UPDATE ON cw.war
FOR EACH ROW
EXECUTE PROCEDURE check_war_new_info();



CREATE OR REPLACE FUNCTION check_character_new_info()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$$
DECLARE
  cnt INTEGER;
BEGIN
  SELECT COUNT(*) INTO cnt
  FROM cw.class
  WHERE cw.class.name = NEW.class;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No class named "%"', NEW.class
          USING ERRCODE = '22000';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM cw.element
  WHERE cw.element.name = NEW.element;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No element named "%"', NEW.element
          USING ERRCODE = '22000';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM cw.player
  WHERE cw.player.player_id = NEW.owner_id;

  IF cnt = 0 THEN
    RAISE EXCEPTION 'No player with "%" id', NEW.owner_id
          USING ERRCODE = '22000';
  END IF;

  SELECT COUNT(*) INTO cnt
  FROM cw.character
  WHERE cw.character.owner_id = NEW.owner_id;

  IF cnt = 2 THEN
    RAISE EXCEPTION 'Player "%" cannot have more than 2 characters', NEW.owner_id
          USING ERRCODE = '22000';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER check_character_new_info
BEFORE INSERT OR UPDATE ON cw.character
FOR EACH ROW
EXECUTE PROCEDURE check_character_new_info();

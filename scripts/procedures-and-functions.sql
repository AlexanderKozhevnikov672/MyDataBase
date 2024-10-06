CREATE OR REPLACE PROCEDURE insert_quest(quest_name VARCHAR(32), quest_value INTEGER)
LANGUAGE SQL
AS $$
  INSERT INTO cw.quest (name, value) VALUES
    (quest_name, quest_value);
$$;

CREATE OR REPLACE PROCEDURE insert_clan(clan_name VARCHAR(32))
LANGUAGE SQL
AS $$
  INSERT INTO cw.clan (name) VALUES
    (clan_name);
$$;

CREATE OR REPLACE PROCEDURE insert_player(player_clan_id INTEGER, player_nickname VARCHAR(32))
LANGUAGE SQL
AS $$
  INSERT INTO cw.player (clan_id, nickname) VALUES
    (player_clan_id, player_nickname);
$$;



CREATE OR REPLACE FUNCTION get_player_achievements(player_id_ INTEGER)
RETURNS TABLE(achievement_id INTEGER, quest_id INTEGER, date DATE)
AS $$
  SELECT achievement_id, quest_id, date
  FROM cw.achievement
  WHERE player_id_ = player_id;
$$
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_clan_wars(clan_id INTEGER, clan_status VARCHAR(32))
RETURNS TABLE(war_id INTEGER, war_result VARCHAR(32), attacker_id INTEGER,
              defender_id INTEGER, winner_id INTEGER, date DATE)
AS $$
  SELECT war_id, 
    CASE
      WHEN clan_id = winner_id THEN 'won'::text
      ELSE 'lose'::text
    END AS war_result, attacker_id, defender_id, winner_id, date
  FROM cw.war
  WHERE clan_id IN (attacker_id, defender_id) AND (clan_status = 'all'
        OR (clan_status = 'attacker' AND clan_id = attacker_id)
        OR (clan_status = 'defender' AND clan_id = defender_id));
$$
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_player_characters(player_id INTEGER)
RETURNS TABLE(character_id INTEGER, class VARCHAR(32), element VARCHAR(32),
              level INTEGER, name VARCHAR(32))
AS $$
  SELECT character_id, class, element, level, name
  FROM cw.character
  WHERE owner_id = player_id;
$$
LANGUAGE SQL;

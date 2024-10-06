CREATE OR REPLACE VIEW cw.player_achievements AS
SELECT cw.player.nickname, cw.quest.name AS quest_name, cw.achievement.date
FROM cw.achievement
LEFT JOIN cw.player ON cw.player.player_id = cw.achievement.player_id
LEFT JOIN cw.quest ON cw.quest.quest_id = cw.achievement.quest_id;

CREATE OR REPLACE VIEW cw.clan_wars AS
SELECT cw.war.date, a.name AS attacker_name, d.name AS defender_name,
  CASE 
    WHEN a.clan_id = cw.war.winner_id THEN a.name
    ELSE d.name
  END AS winner_name
FROM cw.war
LEFT JOIN cw.clan AS a ON cw.war.attacker_id = a.clan_id
LEFT JOIN cw.clan AS d ON cw.war.defender_id = d.clan_id;

CREATE OR REPLACE VIEW cw.character_info AS
SELECT cw.character.name AS character_name, cw.player.nickname AS player_nickname,
       cw.character.level, cw.character.class, cw.class.skill, cw.class.strength,
       cw.class.defence, cw.class.speed, cw.class.mana, cw.class.iq,
       cw.character.element, cw.element.spell, cw.element.animal
FROM cw.character
LEFT JOIN cw.player ON cw.character.owner_id = cw.player.player_id
LEFT JOIN cw.class ON cw.class.name = cw.character.class
LEFT JOIN cw.element ON cw.element.name = cw.character.element;

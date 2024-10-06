-- Сортировка кланов по количеству участников
SELECT cw.clan.clan_id, cw.clan.name, COUNT(*) AS member_count
FROM cw.player
LEFT JOIN cw.clan ON cw.player.clan_id = cw.clan.clan_id
GROUP BY cw.clan.clan_id
ORDER BY member_count DESC, cw.clan.clan_id;

-- Сортировка кланов по количеству побед в войнах
SELECT cw.clan.clan_id, cw.clan.name, COUNT(*) AS win_count
FROM cw.war
LEFT JOIN cw.clan ON cw.war.winner_id = cw.clan.clan_id
GROUP BY cw.clan.clan_id
ORDER BY win_count DESC, cw.clan.clan_id;

-- Поиск кланов, которые участвовали хотя бы 5 в войнах в этом году
SELECT cw.clan.clan_id, cw.clan.name, COUNT(*) AS war_count
FROM cw.clan, cw.war
WHERE (cw.clan.clan_id = cw.war.attacker_id OR cw.clan.clan_id = cw.war.attacker_id) AND cw.war.date >= '2024-01-01'
GROUP BY cw.clan.clan_id
HAVING COUNT(*) >= 5
ORDER BY war_count DESC, cw.clan.clan_id;

-- Подсчёт квестовых очков для каждого игрока
SELECT cw.player.player_id, cw.player.nickname, SUM(cw.quest.value) AS point_count
FROM cw.achievement
LEFT JOIN cw.player ON cw.achievement.player_id = cw.player.player_id
LEFT JOIN cw.quest ON cw.achievement.quest_id = cw.quest.quest_id
GROUP BY cw.player.player_id
ORDER BY point_count DESC, cw.player.player_id;

-- Подсчёт для каждого квеста количество игроков, выполнивших его
SELECT cw.quest.quest_id, cw.quest.name, COUNT(*) AS player_count
FROM cw.achievement
LEFT JOIN cw.quest ON cw.achievement.quest_id = cw.quest.quest_id
GROUP BY cw.quest.quest_id
ORDER BY player_count DESC, cw.quest.quest_id;

-- Для каждого квеста находит первого игрока, который его выполнил
WITH helper AS (
  SELECT cw.achievement.quest_id, MIN(cw.achievement.date)
  FROM cw.achievement
  GROUP BY cw.achievement.quest_id
)
SELECT cw.quest.quest_id, cw.quest.name, cw.player.player_id, cw.player.nickname, cw.achievement.date
FROM cw.achievement
LEFT JOIN cw.player ON cw.achievement.player_id = cw.player.player_id
LEFT JOIN cw.quest ON cw.achievement.quest_id = cw.quest.quest_id
WHERE (cw.quest.quest_id, cw.achievement.date) IN (
  SELECT *
  FROM helper
)
ORDER BY cw.achievement.date, cw.quest.quest_id;

-- Подсчёт суммарного количество очков за квесты у кланов
SELECT cw.clan.clan_id, cw.clan.name, SUM(cw.quest.value) AS point_count
FROM cw.achievement
LEFT JOIN cw.player ON cw.achievement.player_id = cw.player.player_id
LEFT JOIN cw.quest ON cw.achievement.quest_id = cw.quest.quest_id
LEFT JOIN cw.clan ON cw.player.clan_id = cw.clan.clan_id
GROUP BY cw.clan.clan_id
ORDER BY point_count DESC, cw.clan.clan_id;

-- Подсчёт рейтинга у кланов
WITH win_helper AS (
  SELECT cw.war.winner_id, COUNT(*) AS win_count
  FROM cw.war
  GROUP BY cw.war.winner_id
), point_helper AS (
  SELECT cw.clan.clan_id, SUM(cw.quest.value) AS point_count
  FROM cw.achievement
  LEFT JOIN cw.player ON cw.achievement.player_id = cw.player.player_id
  LEFT JOIN cw.quest ON cw.achievement.quest_id = cw.quest.quest_id
  LEFT JOIN cw.clan ON cw.player.clan_id = cw.clan.clan_id
  GROUP BY cw.clan.clan_id
)
SELECT cw.clan.clan_id, cw.clan.name,
  CASE
    WHEN win_helper.win_count IS NULL THEN point_helper.point_count
    WHEN point_helper.point_count IS NULL THEN win_helper.win_count * 100
    ELSE win_helper.win_count * 100 + point_helper.point_count
  END AS raiting
FROM cw.clan
LEFT JOIN win_helper ON cw.clan.clan_id = win_helper.winner_id
LEFT JOIN point_helper ON cw.clan.clan_id = point_helper.clan_id
ORDER BY raiting DESC, cw.clan.clan_id;

-- Для каждого клана находит его первую победу в войнах
WITH helper AS (
  SELECT cw.war.winner_id, MIN(cw.war.date)
  FROM cw.war
  GROUP BY cw.war.winner_id
)
SELECT cw.clan.clan_id, cw.clan.name, cw.war.date,
  CASE
    WHEN cw.war.winner_id = cw.war.attacker_id THEN cw.war.defender_id
    ELSE cw.war.attacker_id
  END AS opponent
FROM cw.war
LEFT JOIN cw.clan ON cw.war.winner_id = cw.clan.clan_id
WHERE (cw.clan.clan_id, cw.war.date) IN (
  SELECT *
  FROM helper
)
ORDER BY cw.war.date, cw.clan.clan_id;

-- Поиск для каждого игрока квеста, который он выполнил последним
WITH helper AS (
  SELECT cw.achievement.player_id, MAX(cw.achievement.date)
  FROM cw.achievement
  GROUP BY cw.achievement.player_id
)
SELECT cw.player.player_id, cw.player.nickname, cw.achievement.date, cw.achievement.quest_id
FROM cw.achievement
LEFT JOIN cw.player ON cw.achievement.player_id = cw.player.player_id
WHERE (cw.player.player_id, cw.achievement.date) IN (
  SELECT *
  FROM helper
)
ORDER BY cw.achievement.date DESC, cw.player.player_id;

-- Для каждого игрока считает суммарный уровень его персонажей
SELECT cw.player.player_id, cw.player.nickname, SUM(cw.character.level) AS level_count
FROM cw.character
LEFT JOIN cw.player ON cw.character.owner_id = cw.player.player_id
GROUP BY cw.player.player_id
ORDER BY level_count DESC, cw.player.player_id;

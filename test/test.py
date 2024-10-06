import pytest
import psycopg2
import datetime
import sys


@pytest.fixture
def cursor():
	conn = psycopg2.connect(database="project", user="postgres", password="postgres", host="localhost", port="5432")
	conn.autocommit = True
	cursor = conn.cursor()
	yield cursor
	cursor.close()
	conn.close()


def test_clan_sorting_by_member_count(cursor):
	cursor.execute("""
		SELECT cw.clan.clan_id, cw.clan.name, COUNT(*) AS member_count
		FROM cw.player
		LEFT JOIN cw.clan ON cw.player.clan_id = cw.clan.clan_id
		GROUP BY cw.clan.clan_id
		ORDER BY member_count DESC, cw.clan.clan_id;
	""")

	assert cursor.fetchall() == [
        (1, 'Clan 1', 3),
        (2, 'Clan 2', 3),
        (3, 'Clan 3', 3),
        (4, 'Clan 4', 3),
        (5, 'Clan 5', 3),
        (6, 'Clan 6', 3),
        (7, 'Clan 7', 3),
        (8, 'Clan 8', 3),
        (9, 'Clan 9', 3),
        (10, 'Clan 10', 3),
    ]


def test_quest_first_player(cursor):
	cursor.execute("""
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
	""")

	assert cursor.fetchall() == [
		(1, 'Quest 1', 1, 'Player 1', datetime.date(2024, 1, 1)),
		(2, 'Quest 2', 1, 'Player 1', datetime.date(2024, 1, 2)),
		(3, 'Quest 3', 1, 'Player 1', datetime.date(2024, 1, 3)),
		(4, 'Quest 4', 2, 'Player 2', datetime.date(2024, 1, 4)),
		(5, 'Quest 5', 2, 'Player 2', datetime.date(2024, 1, 5)),
		(6, 'Quest 6', 2, 'Player 2', datetime.date(2024, 1, 6)),
		(7, 'Quest 7', 3, 'Player 3', datetime.date(2024, 1, 7)),
		(8, 'Quest 8', 3, 'Player 3', datetime.date(2024, 1, 8)),
		(9, 'Quest 9', 3, 'Player 3', datetime.date(2024, 1, 9)),
		(10, 'Quest 10', 4, 'Player 4', datetime.date(2024, 1, 10)),
		(11, 'Quest 11', 4, 'Player 4', datetime.date(2024, 1, 11)),
		(12, 'Quest 12', 4, 'Player 4', datetime.date(2024, 1, 12)),
		(13, 'Quest 13', 5, 'Player 5', datetime.date(2024, 1, 13)),
		(14, 'Quest 14', 5, 'Player 5', datetime.date(2024, 1, 14)),
		(15, 'Quest 15', 5, 'Player 5', datetime.date(2024, 1, 15)),
		(16, 'Quest 16', 6, 'Player 6', datetime.date(2024, 1, 16)),
		(17, 'Quest 17', 6, 'Player 6', datetime.date(2024, 1, 17)),
		(18, 'Quest 18', 6, 'Player 6', datetime.date(2024, 1, 18)),
		(19, 'Quest 19', 7, 'Player 7', datetime.date(2024, 1, 19)),
		(20, 'Quest 20', 7, 'Player 7', datetime.date(2024, 1, 20)),
		(21, 'Quest 21', 7, 'Player 7', datetime.date(2024, 1, 21)),
		(22, 'Quest 22', 8, 'Player 8', datetime.date(2024, 1, 22)),
		(23, 'Quest 23', 8, 'Player 8', datetime.date(2024, 1, 23)),
		(24, 'Quest 24', 8, 'Player 8', datetime.date(2024, 1, 24)),
		(25, 'Quest 25', 9, 'Player 9', datetime.date(2024, 1, 25)),
		(26, 'Quest 26', 9, 'Player 9', datetime.date(2024, 1, 26)),
		(27, 'Quest 27', 9, 'Player 9', datetime.date(2024, 1, 27)),
		(28, 'Quest 28', 10, 'Player 10', datetime.date(2024, 1, 28)),
		(29, 'Quest 29', 10, 'Player 10', datetime.date(2024, 1, 29)),
		(30, 'Quest 30', 10, 'Player 10', datetime.date(2024, 1, 30)),
	]


def test_clan_raiting_count(cursor):
	cursor.execute("""
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
	""")

	assert cursor.fetchall() == [
		(3, 'Clan 3', 2170),
		(2, 'Clan 2', 1360),
		(4, 'Clan 4', 970),
		(1, 'Clan 1', 550),
		(5, 'Clan 5', 100),
		(6, 'Clan 6', 100),
		(7, 'Clan 7', 100),
		(8, 'Clan 8', 100),
		(9, 'Clan 9', 100),
		(10, 'Clan 10', 100),
		(11, 'Clan 11', 100),
		(12, 'Clan 12', 100),
		(13, 'Clan 13', 100),
		(14, 'Clan 14', 100),
		(15, 'Clan 15', 100),
		(16, 'Clan 16', 100),
		(17, 'Clan 17', 100),
		(18, 'Clan 18', 100),
		(19, 'Clan 19', 100),
		(20, 'Clan 20', 100),
		(21, 'Clan 21', 100),
		(22, 'Clan 22', 100),
		(23, 'Clan 23', 100),
		(24, 'Clan 24', 100),
		(25, 'Clan 25', 100),
		(26, 'Clan 26', 100),
		(27, 'Clan 27', 100),
		(28, 'Clan 28', 100),
		(29, 'Clan 29', 100),
		(30, 'Clan 30', 100),
	]


def test_clan_first_war_win(cursor):
	cursor.execute("""
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
	""")

	assert cursor.fetchall() == [
		(1, 'Clan 1', datetime.date(2024, 1, 1), 2),
		(3, 'Clan 3', datetime.date(2024, 1, 2), 4),
		(5, 'Clan 5', datetime.date(2024, 1, 3), 6),
		(7, 'Clan 7', datetime.date(2024, 1, 4), 8),
		(9, 'Clan 9', datetime.date(2024, 1, 5), 10),
		(11, 'Clan 11', datetime.date(2024, 1, 6), 12),
		(13, 'Clan 13', datetime.date(2024, 1, 7), 14),
		(15, 'Clan 15', datetime.date(2024, 1, 8), 16),
		(17, 'Clan 17', datetime.date(2024, 1, 9), 18),
		(19, 'Clan 19', datetime.date(2024, 1, 10), 20),
		(21, 'Clan 21', datetime.date(2024, 1, 11), 22),
		(23, 'Clan 23', datetime.date(2024, 1, 12), 24),
		(25, 'Clan 25', datetime.date(2024, 1, 13), 26),
		(27, 'Clan 27', datetime.date(2024, 1, 14), 28),
		(29, 'Clan 29', datetime.date(2024, 1, 15), 30),
		(2, 'Clan 2', datetime.date(2024, 1, 16), 3),
		(4, 'Clan 4', datetime.date(2024, 1, 17), 5),
		(6, 'Clan 6', datetime.date(2024, 1, 18), 7),
		(8, 'Clan 8', datetime.date(2024, 1, 19), 9),
		(10, 'Clan 10', datetime.date(2024, 1, 20), 11),
		(12, 'Clan 12', datetime.date(2024, 1, 21), 13),
		(14, 'Clan 14', datetime.date(2024, 1, 22), 15),
		(16, 'Clan 16', datetime.date(2024, 1, 23), 17),
		(18, 'Clan 18', datetime.date(2024, 1, 24), 19),
		(20, 'Clan 20', datetime.date(2024, 1, 25), 21),
		(22, 'Clan 22', datetime.date(2024, 1, 26), 23),
		(24, 'Clan 24', datetime.date(2024, 1, 27), 25),
		(26, 'Clan 26', datetime.date(2024, 1, 28), 27),
		(28, 'Clan 28', datetime.date(2024, 1, 29), 29),
		(30, 'Clan 30', datetime.date(2024, 1, 30), 1),
	]


def test_player_last_achievement(cursor):
	cursor.execute("""
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
	""")

	assert cursor.fetchall() == [
		(10, 'Player 10', datetime.date(2024, 1, 30), 30),
		(9, 'Player 9', datetime.date(2024, 1, 27), 27),
		(8, 'Player 8', datetime.date(2024, 1, 24), 24),
		(7, 'Player 7', datetime.date(2024, 1, 21), 21),
		(6, 'Player 6', datetime.date(2024, 1, 18), 18),
		(5, 'Player 5', datetime.date(2024, 1, 15), 15),
		(4, 'Player 4', datetime.date(2024, 1, 12), 12),
		(3, 'Player 3', datetime.date(2024, 1, 9), 9),
		(2, 'Player 2', datetime.date(2024, 1, 6), 6),
		(1, 'Player 1', datetime.date(2024, 1, 3), 3),
	]


def test_character_trigger(cursor):
	try:
		cursor.execute("""
			INSERT INTO cw.character (owner_id, class, element, level, name) VALUES
			    (1, 'Mage', 'Fire', 10, 'Magna');
		""")
		assert False

	except Exception:
		_, value, _ = sys.exc_info()
		assert value.args[0].startswith('Player "1" cannot have more than 2 characters')


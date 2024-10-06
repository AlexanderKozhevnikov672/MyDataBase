CREATE SCHEMA IF NOT EXISTS cw;

CREATE TABLE IF NOT EXISTS cw.quest (
  quest_id SERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL,
  value INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS cw.clan (
  clan_id SERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS cw.player (
  player_id SERIAL PRIMARY KEY,
  clan_id INTEGER,
  nickname VARCHAR(32) NOT NULL,
  FOREIGN KEY (clan_id) REFERENCES cw.clan(clan_id)
);

CREATE TABLE IF NOT EXISTS cw.achievement (
  achievement_id SERIAL PRIMARY KEY,
  player_id INTEGER NOT NULL,
  quest_id INTEGER NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (player_id) REFERENCES cw.player(player_id),
  FOREIGN KEY (quest_id) REFERENCES cw.quest(quest_id)
);

CREATE TABLE IF NOT EXISTS cw.war (
  war_id SERIAL PRIMARY KEY,
  attacker_id INTEGER NOT NULL,
  defender_id INTEGER NOT NULL CHECK (defender_id != attacker_id),
  winner_id INTEGER NOT NULL CHECK (winner_id IN (attacker_id, defender_id)),
  date DATE NOT NULL,
  FOREIGN KEY (attacker_id) REFERENCES cw.clan(clan_id),
  FOREIGN KEY (defender_id) REFERENCES cw.clan(clan_id)
);

CREATE TABLE IF NOT EXISTS cw.class (
  name VARCHAR(32) PRIMARY KEY,
  skill	VARCHAR(32) NOT NULL,
  strength INTEGER NOT NULL,
  defence	INTEGER	NOT NULL,
  speed	INTEGER	NOT NULL,
  mana INTEGER NOT NULL,
  iq INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS cw.element (
  name VARCHAR(32) PRIMARY KEY,
  spell VARCHAR(32)	NOT NULL,
  animal VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS cw.character (
  character_id SERIAL PRIMARY KEY,
  owner_id INTEGER NOT NULL,
  class VARCHAR(32)	NOT NULL,
  element VARCHAR(32)	NOT NULL,
  level INTEGER	NOT NULL,
  name VARCHAR(32) NOT NULL,
  FOREIGN KEY (owner_id) REFERENCES cw.player(player_id),
  FOREIGN KEY (class) REFERENCES cw.class(name),
  FOREIGN KEY (element) REFERENCES cw.element(name)
);

CREATE INDEX IF NOT EXISTS idx_quest_value ON cw.quest (value);

CREATE INDEX IF NOT EXISTS idx_player_clan_id ON cw.player (clan_id);

CREATE INDEX IF NOT EXISTS idx_achievement_player_id ON cw.achievement (player_id);
CREATE INDEX IF NOT EXISTS idx_achievement_quest_id ON cw.achievement (quest_id);

CREATE INDEX IF NOT EXISTS idx_war_attacker_id ON cw.war (attacker_id);
CREATE INDEX IF NOT EXISTS idx_war_defender_id ON cw.war (defender_id);
CREATE INDEX IF NOT EXISTS idx_war_winner_id ON cw.war (winner_id);

CREATE INDEX IF NOT EXISTS idx_character_owner_id ON cw.character (owner_id);
CREATE INDEX IF NOT EXISTS idx_character_class ON cw.character (class);
CREATE INDEX IF NOT EXISTS idx_character_element ON cw.character (element);
CREATE INDEX IF NOT EXISTS idx_character_level ON cw.character (level);

CREATE INDEX IF NOT EXISTS idx_class_strength ON cw.class (strength);
CREATE INDEX IF NOT EXISTS idx_class_defence ON cw.class (defence);
CREATE INDEX IF NOT EXISTS idx_class_speed ON cw.class (speed);
CREATE INDEX IF NOT EXISTS idx_class_mana ON cw.class (mana);
CREATE INDEX IF NOT EXISTS idx_class_iq ON cw.class (iq);

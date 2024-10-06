## QUEST

| Название   | Описание        | Тип данных    | Ограничение   |
| ---------- | --------------- | ------------- | ------------- |
| `quest_id` | ID квеста       | `INTEGER`     | `PRIMARY KEY` |
| `name`     | Название квеста | `VARCHAR(32)` | `NOT NULL`    |
| `value`    | Ценность квеста | `INTEGER`     | `NOT NULL`    |

## CLAN

| Название  | Описание       | Тип данных    | Ограничение   |
| --------- | -------------- | ------------- | ------------- |
| `clan_id` | ID клана       | `INTEGER`     | `PRIMARY KEY` |
| `name`    | Название клана | `VARCHAR(32)` | `NOT NULL`    |

## PLAYER

| Название    | Описание   | Тип данных    | Ограничение   |
| ----------- | ---------- | ------------- | ------------- |
| `player_id` | ID игрока  | `INTEGER`     | `PRIMARY KEY` |
| `clan_id`   | ID клана   | `INTEGER`     | `FOREIGN KEY REFERENCES clans(clan_id)` |
| `nickname`  | Ник игрока | `VARCHAR(32)` | `NOT NULL`    |

## ACHIEVEMENT

| Название         | Описание       | Тип данных | Ограничение   |
| ---------------- | -------------- | ---------- | ------------- |
| `achievement_id` | ID достижения  | `INTEGER`  | `PRIMARY KEY` |
| `player_id`      | ID игрока      | `INTEGER`  | `NOT NULL FOREIGN KEY REFERENCES player(player_id)` |
| `quest_id`       | ID квеста      | `INTEGER`  | `NOT NULL FOREIGN KEY REFERENCES quest(quest_id)`   |
| `date`           | Дата получения | `DATE`     | `NOT NULL`    |

## WAR

| Название      | Описание      | Тип данных | Ограничение   |
| ------------- | ------------- | ---------- | ------------- |
| `war_id`      | ID войны      | `INTEGER`  | `PRIMARY KEY` |
| `attacker_id` | ID атакующего | `INTEGER`  | `NOT NULL FOREIGN KEY REFERENCES clan(clan_id)` |
| `defender_id` | ID защитника  | `INTEGER`  | `NOT NULL FOREIGN KEY REFERENCES clan(clan_id) CHECK (defender_id != attacker_id)` |
| `winner_id`   | ID победителя | `INTEGER`  | `NOT NULL CHECK (winner_id IN (arracker_id, defender_id))` |
| `date`        | Дата войны    | `DATE`     | `NOT NULL`    |

## CLASS

| Название   | Описание           | Тип данных    | Ограничение   |
| ---------- | ------------------ | ------------- | ------------- |
| `name`     | Название класса    | `VARCHAR(32)` | `PRIMARY KEY` |
| `skill`    | Способность класса | `VARCHAR(32)` | `NOT NULL`    |
| `strength` | Бонус к силе       | `INTEGER`     | `NOT NULL`    |
| `defence`  | Бонус к защите     | `INTEGER`     | `NOT NULL`    |
| `speed`    | Бонус к скорости   | `INTEGER`     | `NOT NULL`    |
| `mana`     | Бонус к мане       | `INTEGER`     | `NOT NULL`    |
| `iq`       | Бонус к интеллекту | `INTEGER`     | `NOT NULL`    |

## ELEMENT

| Название   | Описание           | Тип данных    | Ограничение   |
| ---------- | ------------------ | ------------- | ------------- |
| `name`     | Название элемента  | `VARCHAR(32)` | `PRIMARY KEY` |
| `spell`    | Главное заклинание | `VARCHAR(32)` | `NOT NULL`    |
| `animal`   | Животное стихии    | `VARCHAR(32)` | `NOT NULL`    |

## CHARACTER

| Название       | Описание          | Тип данных    | Ограничение   |
| -------------- | ----------------- | ------------- | ------------- |
| `character_id` | ID персонажа      | `INTEGER`     | `PRIMARY KEY` |
| `owner_id`     | ID владельца      | `INTEGER`     | `NOT NULL FOREIGN KEY REFERENCES player(player_id)` |
| `class`        | Класс персонажа   | `VARCHAR(32)` | `NOT NULL FOREIGN KEY REFERENCES class(name)` |
| `element`      | Элемент персонажа | `VARCHAR(32)` | `NOT NULL FOREIGN KEY REFERENCES element(name)` |
| `level`        | Уровень персонажа | `INTEGER`     | `NOT NULL`    |
| `name`         | Имя персонажа     | `VARCHAR(32)` | `NOT NULL`    |

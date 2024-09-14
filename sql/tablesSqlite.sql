CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- serial is replaced by AUTOINCREMENT
  name TEXT NOT NULL,
  profile_photo TEXT,
  profile_banner TEXT,
  followers INTEGER NOT NULL DEFAULT 0,
  email TEXT NOT NULL,
  --im_from TEXT,
  --phone TEXT,
  --fav_food TEXT,
  --fav_color TEXT
  UNIQUE(email)
);

CREATE TABLE user_login (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE ON UPDATE CASCADE, -- fk_profile references user_profile
  logged_in INTEGER, -- boolean is replaced by INTEGER (0/1)
  email TEXT NOT NULL,
  password TEXT NOT NULL,
  UNIQUE(id, fk_profile), -- UNIQUE constraint on both columns
  UNIQUE(email)
);

CREATE TABLE post (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  photo TEXT,
  txt TEXT,
  likes INTEGER NOT NULL DEFAULT 0,
  UNIQUE(id, fk_profile) -- UNIQUE constraint on both columns
);

CREATE TABLE follows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fk_profile INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  fk_follower INTEGER NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  UNIQUE(fk_profile, fk_follower) -- UNIQUE constraint on both columns
);
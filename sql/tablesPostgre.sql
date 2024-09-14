CREATE TABLE user_profile(
	pk_profile serial PRIMARY KEY,
	name varchar(150) NOT null,
	profile_photo text,
	profile_banner text,
	followers int NOT null DEFAULT 0,
	-- im_from varchar(60),
	-- phone varchar(40),
	-- fav_food varchar(40),
	-- fav_color varchar(40)
)

CREATE TABLE user_login(
	pk_login serial PRIMARY KEY,
	fk_profile int NOT null,
	logged_in boolean,
	email varchar(150) NOT null,
	password varchar(150) NOT null,
	UNIQUE(pk_login, fk_profile),
	UNIQUE(email),
	FOREIGN KEY (fk_profile) REFERENCES user_profile(pk_profile) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE post(
	pk_post serial PRIMARY KEY,
	fk_profile int NOT null,
	photo text,
	txt varchar(280),
	likes int NOT null DEFAULT 0,
	UNIQUE(pk_post, fk_profile),
	FOREIGN KEY (fk_profile) REFERENCES user_profile(pk_profile)
)

CREATE TABLE follows(
	pk_follows serial PRIMARY KEY,
	fk_profile int NOT null,
	fk_follower int NOT null,
	UNIQUE(fk_profile, fk_follower),
	FOREIGN KEY (fk_profile) REFERENCES user_profile(pk_profile) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (fk_follower) REFERENCES user_profile(pk_profile) ON DELETE CASCADE ON UPDATE CASCADE
)
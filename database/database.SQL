-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** "user"

CREATE TABLE "user"
(
 "user_id"      serial NOT NULL,
 "display_name" varchar(50) NOT NULL,
 "email"        varchar(50) NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "image"        varchar(250) NOT NULL,
 "active"       boolean NOT NULL,
 CONSTRAINT "PK_users" PRIMARY KEY ( "user_id" )
);








-- ************************************** "deck"

CREATE TABLE "deck"
(
 "deck_id"      serial NOT NULL,
 "deck_name"    varchar(50) NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "user_id"      integer NOT NULL,
 "description"  varchar(250) NOT NULL,
 CONSTRAINT "PK_decks" PRIMARY KEY ( "deck_id" ),
 CONSTRAINT "FK_33" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_33" ON "deck"
(
 "user_id"
);








-- ************************************** "user_deck"

CREATE TABLE "user_deck"
(
 "user_id"      integer NOT NULL,
 "deck_id"      integer NOT NULL,
 "time_created" time with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "referred_by"  integer NULL,
 "status"       smallint NULL,
 CONSTRAINT "FK_122" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_126" FOREIGN KEY ( "deck_id" ) REFERENCES "deck" ( "deck_id" ),
 CONSTRAINT "FK_190" FOREIGN KEY ( "referred_by" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_122" ON "user_deck"
(
 "user_id"
);

CREATE INDEX "fkIdx_126" ON "user_deck"
(
 "deck_id"
);

CREATE INDEX "fkIdx_190" ON "user_deck"
(
 "referred_by"
);








-- ************************************** "card"

CREATE TABLE "card"
(
 "card_id"      serial NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "deck_id"      integer NOT NULL,
 CONSTRAINT "PK_cards" PRIMARY KEY ( "card_id" ),
 CONSTRAINT "FK_230" FOREIGN KEY ( "deck_id" ) REFERENCES "deck" ( "deck_id" )
);

CREATE INDEX "fkIdx_230" ON "card"
(
 "deck_id"
);








-- ************************************** "yield_vote"

CREATE TABLE "yield_vote"
(
 "user_id"      integer NOT NULL,
 "value"        smallint NOT NULL,
 "card_id"      integer NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT "FK_90" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" ),
 CONSTRAINT "FK_97" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_90" ON "yield_vote"
(
 "card_id"
);

CREATE INDEX "fkIdx_97" ON "yield_vote"
(
 "user_id"
);








-- ************************************** "version"

CREATE TABLE "version"
(
 "version_id"   serial NOT NULL,
 "front"        varchar(250) NOT NULL,
 "back"         varchar(250) NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "user_id"      integer NOT NULL,
 "extra"        varchar(250) NOT NULL,
 "card_id"      integer NOT NULL,
 CONSTRAINT "PK_versions" PRIMARY KEY ( "version_id", "card_id" ),
 CONSTRAINT "FK_238" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" ),
 CONSTRAINT "FK_53" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_238" ON "version"
(
 "card_id"
);

CREATE INDEX "fkIdx_53" ON "version"
(
 "user_id"
);








-- ************************************** "tested_vote"

CREATE TABLE "tested_vote"
(
 "user_id"      integer NOT NULL,
 "value"        boolean NOT NULL,
 "card_id"      integer NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT "FK_90" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" ),
 CONSTRAINT "FK_97" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_90" ON "tested_vote"
(
 "card_id"
);

CREATE INDEX "fkIdx_97" ON "tested_vote"
(
 "user_id"
);








-- ************************************** "image"

CREATE TABLE "image"
(
 "image_id"     serial NOT NULL,
 "user_id"      integer NOT NULL,
 "source"       varchar(250) NOT NULL,
 "card_id"      integer NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT "PK_images" PRIMARY KEY ( "image_id" ),
 CONSTRAINT "FK_140" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" ),
 CONSTRAINT "FK_179" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_140" ON "image"
(
 "card_id"
);

CREATE INDEX "fkIdx_179" ON "image"
(
 "user_id"
);








-- ************************************** "extra"

CREATE TABLE "extra"
(
 "extra_id"     serial NOT NULL,
 "content"      varchar(250) NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "user_id"      integer NOT NULL,
 "card_id"      integer NOT NULL,
 CONSTRAINT "PK_extras" PRIMARY KEY ( "extra_id" ),
 CONSTRAINT "FK_253" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_256" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" )
);

CREATE INDEX "fkIdx_253" ON "extra"
(
 "user_id"
);

CREATE INDEX "fkIdx_256" ON "extra"
(
 "card_id"
);








-- ************************************** "card_comment"

CREATE TABLE "card_comment"
(
 "comment_id"   serial NOT NULL,
 "content"      varchar(250) NOT NULL,
 "user_id"      integer NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "card_id"      integer NOT NULL,
 CONSTRAINT "PK_comments" PRIMARY KEY ( "comment_id" ),
 CONSTRAINT "FK_40" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_74" FOREIGN KEY ( "card_id" ) REFERENCES "card" ( "card_id" )
);

CREATE INDEX "fkIdx_40" ON "card_comment"
(
 "user_id"
);

CREATE INDEX "fkIdx_74" ON "card_comment"
(
 "card_id"
);








-- ************************************** "version_user"

CREATE TABLE "version_user"
(
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "status"       smallint NOT NULL,
 "version_id"   integer NOT NULL,
 "card_id"      integer NOT NULL,
 "user_id"      integer NOT NULL,
 CONSTRAINT "FK_274" FOREIGN KEY ( "version_id", "card_id" ) REFERENCES "version" ( "version_id", "card_id" ),
 CONSTRAINT "FK_279" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_274" ON "version_user"
(
 "version_id",
 "card_id"
);

CREATE INDEX "fkIdx_279" ON "version_user"
(
 "user_id"
);








-- ************************************** "version_comment"

CREATE TABLE "version_comment"
(
 "version_comment_id" serial NOT NULL,
 "content"            varchar(250) NOT NULL,
 "time_created"       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "user_id"            integer NOT NULL,
 "version_id"         integer NOT NULL,
 "card_id"            integer NOT NULL,
 CONSTRAINT "PK_version_comments" PRIMARY KEY ( "version_comment_id", "version_id", "card_id" ),
 CONSTRAINT "FK_68" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_71" FOREIGN KEY ( "version_id", "card_id" ) REFERENCES "version" ( "version_id", "card_id" )
);

CREATE INDEX "fkIdx_68" ON "version_comment"
(
 "user_id"
);

CREATE INDEX "fkIdx_71" ON "version_comment"
(
 "version_id",
 "card_id"
);








-- ************************************** "review"

CREATE TABLE "review"
(
 "review_id"       serial NOT NULL,
 "version_id"      integer NOT NULL,
 "user_id"         integer NOT NULL,
 "time_created"    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "option_selected" smallint NOT NULL,
 "card_id"         integer NOT NULL,
 CONSTRAINT "PK_reviews" PRIMARY KEY ( "review_id" ),
 CONSTRAINT "FK_110" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_174" FOREIGN KEY ( "version_id", "card_id" ) REFERENCES "version" ( "version_id", "card_id" )
);

CREATE INDEX "fkIdx_110" ON "review"
(
 "user_id"
);

CREATE INDEX "fkIdx_174" ON "review"
(
 "version_id",
 "card_id"
);








-- ************************************** "extra_user"

CREATE TABLE "extra_user"
(
 "user_id"      integer NOT NULL,
 "time_created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "extra_id"     integer NOT NULL,
 "status"       smallint NOT NULL,
 CONSTRAINT "FK_263" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_268" FOREIGN KEY ( "extra_id" ) REFERENCES "extra" ( "extra_id" )
);

CREATE INDEX "fkIdx_263" ON "extra_user"
(
 "user_id"
);

CREATE INDEX "fkIdx_268" ON "extra_user"
(
 "extra_id"
);








-- ************************************** "card_comment_like"

CREATE TABLE "card_comment_like"
(
 "card_comment_like_id" serial NOT NULL,
 "content"              boolean NOT NULL,
 "date_created"         time with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "comment_id"           integer NOT NULL,
 "user_id"              integer NOT NULL,
 CONSTRAINT "PK_card_comment_likes" PRIMARY KEY ( "card_comment_like_id" ),
 CONSTRAINT "FK_198" FOREIGN KEY ( "comment_id" ) REFERENCES "card_comment" ( "comment_id" ),
 CONSTRAINT "FK_201" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" )
);

CREATE INDEX "fkIdx_198" ON "card_comment_like"
(
 "comment_id"
);

CREATE INDEX "fkIdx_201" ON "card_comment_like"
(
 "user_id"
);








-- ************************************** "version_comment_like"

CREATE TABLE "version_comment_like"
(
 "content"            boolean NOT NULL,
 "time_created"       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 "user_id"            integer NOT NULL,
 "version_comment_id" integer NOT NULL,
 "version_id"         integer NOT NULL,
 "card_id"            integer NOT NULL,
 CONSTRAINT "PK_version_comment_likes" PRIMARY KEY ( "version_comment_id", "version_id", "card_id", "user_id" ),
 CONSTRAINT "FK_201" FOREIGN KEY ( "user_id" ) REFERENCES "user" ( "user_id" ),
 CONSTRAINT "FK_210" FOREIGN KEY ( "version_comment_id", "version_id", "card_id" ) REFERENCES "version_comment" ( "version_comment_id", "version_id", "card_id" )
);

CREATE INDEX "fkIdx_201" ON "version_comment_like"
(
 "user_id"
);

CREATE INDEX "fkIdx_210" ON "version_comment_like"
(
 "version_comment_id",
 "version_id",
 "card_id"
);








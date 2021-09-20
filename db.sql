BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS "org" (
    "id" integer PRIMARY KEY NOT NULL,
    "name" varchar NOT NULL,
    "base_repo_role" varchar NOT NULL,
    "billing_address" varchar NOT NULL
);

insert into
    "org"
VALUES
    (
        1,
        'The Beatles',
        'repo_read',
        '64 Penny Ln Liverpool, UK'
    );

insert into
    "org"
VALUES
    (
        2,
        'Monsters Inc.',
        'repo_read',
        '123 Scarers Rd Monstropolis, USA'
    );

CREATE TABLE IF NOT EXISTS "user" (
    "id" integer PRIMARY KEY NOT NULL,
    "email" varchar NOT NULL
);

insert into
    "user"
VALUES
    (1, 'john@beatles.com');

insert into
    "user"
VALUES
    (2, 'paul@beatles.com');

insert into
    "user"
VALUES
    (3, 'ringo@beatles.com');

insert into
    "user"
VALUES
    (4, 'mike@monsters.com');

insert into
    "user"
VALUES
    (5, 'sully@monsters.com');

insert into
    "user"
VALUES
    (6, 'randall@monsters.com');

insert into
    "user"
VALUES
    (7, 'admin@admin.com');

CREATE TABLE IF NOT EXISTS "repo" (
    "id" integer PRIMARY KEY NOT NULL,
    "name" varchar NOT NULL,
    "orgId" integer,
    CONSTRAINT "FK_55f707b7d91f446ca54614d3d58" FOREIGN KEY ("orgId") REFERENCES "org" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

insert into
    "repo"
VALUES
    (1, 'Abbey Road', 1);

insert into
    "repo"
VALUES
    (2, 'Paperwork', 2);

CREATE TABLE IF NOT EXISTS "issue" (
    "id" integer PRIMARY KEY NOT NULL,
    "title" varchar NOT NULL,
    "repoId" integer,
    CONSTRAINT "FK_ea2740984b988e2f7bcf80154bb" FOREIGN KEY ("repoId") REFERENCES "repo" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

insert into
    "issue"
VALUES
    (1, 'Too much critical acclaim', 1);

CREATE TABLE IF NOT EXISTS "repo_role" (
    "id" integer PRIMARY KEY NOT NULL,
    "role" varchar NOT NULL,
    "repoId" integer,
    "userId" integer,
    CONSTRAINT "FK_a6c9930e941e29fe25b60fee7e2" FOREIGN KEY ("repoId") REFERENCES "repo" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "FK_09dd160f8d088a121117d39a7cf" FOREIGN KEY ("userId") REFERENCES "user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

insert into
    "repo_role"
VALUES
    (1, 'owner', 1, 1);

insert into
    "repo_role"
VALUES
    (2, 'member', 1, 2);

insert into
    "repo_role"
VALUES
    (3, 'member', 1, 3);

insert into
    "repo_role"
VALUES
    (4, 'owner', 2, 4);

insert into
    "repo_role"
VALUES
    (5, 'member', 2, 5);

insert into
    "repo_role"
VALUES
    (6, 'member', 2, 6);

CREATE TABLE IF NOT EXISTS "org_role" (
    "id" integer PRIMARY KEY NOT NULL,
    "role" varchar NOT NULL,
    "orgId" integer,
    "userId" integer,
    CONSTRAINT "FK_dc15c640353d813a5aefdfeed2b" FOREIGN KEY ("orgId") REFERENCES "org" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "FK_b18ea10aa1e3a24364899a4d005" FOREIGN KEY ("userId") REFERENCES "user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

insert into
    "org_role"
VALUES
    (1, 'owner', 1, 1);

insert into
    "org_role"
VALUES
    (3, 'member', 1, 3);

insert into
    "org_role"
VALUES
    (4, 'owner', 2, 4);

insert into
    "org_role"
VALUES
    (5, 'member', 2, 5);

insert into
    "org_role"
VALUES
    (6, 'member', 2, 6);

COMMIT;
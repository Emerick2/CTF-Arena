USE ctfarena;

-- Mission 1.0 — Découvrir et classer les données

SHOW tables;

DESCRIBE categories;
DESCRIBE challenges;
DESCRIBE equipes;
DESCRIBE joueurs;
DESCRIBE soumissions;
DESCRIBE validations;

-- equipes :
-- publiques : nom, ecole
-- internes : id_equipe
-- sensibles : bannie, date_inscription
--
-- joueurs :
-- publiques : pseudo, role_plateforme
-- internes : id_joueurs, id_equipe
-- sensibles : email, mot_de_passe_hash, derniere_ip
--
-- categories :
-- publiques : nom
-- internes : id_categorie
-- sensibles : 
-- 
-- challenges :
-- publiques : id_challenge, titre, id_categorie, difficulte, points uniquement lorsque le challenge est ouvert
-- internes : statut, id_auteur
-- sensibles : flag
--
-- soumissions :
-- publiques : aucune
-- internes : id_soumission, id_joueur, id_challenge, correct, date_soumission
-- sensibles : flag_propose, ip_source
--
-- validations :
-- publiques : id_equipe, id_challenge, date_validation
-- internes : id_joueur
-- sensibles : aucune


-- Mission 1.1 — Créer les comptes
DROP USER IF EXISTS 'admin_ctf'@'localhost';
CREATE USER 'admin_ctf'@'localhost' IDENTIFIED BY '!IOAO4Ijo8zaid*oZOi2zZ_';

DROP USER IF EXISTS 'orga_ctf'@'localhost';
CREATE USER 'orga_ctf'@'localhost' IDENTIFIED BY 'zaaz4eIjo8zaid*oZOi22zZ+';

DROP USER IF EXISTS 'app_web'@'localhost';
CREATE USER 'app_web'@'localhost' IDENTIFIED BY 'aad5e8z6e245OAO4Ijo8zaid*oZOi2zZ';

DROP USER IF EXISTS 'auditeur'@'localhost';
CREATE USER 'auditeur'@'localhost' IDENTIFIED BY '!zeI56OAO4Ijo852zaid*oZOi2zZ786zeza**';

SELECT user, host FROM mysql.user;


-- 5. Question (en commentaire) : pourquoi ne faut-il pas créer app_web avec @'%' ?
-- localhost limite l'origine des connexions au serveur local.
-- '%' permettrait des connexions depuis tous les hôtes autorisés par le réseau, ce qui augmente l'exposition du compte applicatif.

-- Mission 1.2 — Appliquer la matrice de droits

-- admin_ctf :
GRANT ALL PRIVILEGES
    ON ctfarena.*
    TO 'admin_ctf'@'localhost';

-- orga_ctf :
GRANT SELECT, INSERT, UPDATE
    ON ctfarena.challenges
    TO 'orga_ctf'@'localhost';

GRANT SELECT, INSERT, UPDATE
    ON ctfarena.categories
    TO 'orga_ctf'@'localhost';

GRANT SELECT
    ON ctfarena.equipes
    TO 'orga_ctf'@'localhost';

-- app_web
GRANT SELECT
    ON ctfarena.equipes
    TO 'app_web'@'localhost';

GRANT SELECT
    ON ctfarena.categories
    TO 'app_web'@'localhost';

GRANT SELECT
    ON ctfarena.validations
    TO 'app_web'@'localhost';

GRANT INSERT
    ON ctfarena.soumissions
    TO 'app_web'@'localhost';

GRANT SELECT(id_joueur, pseudo, id_equipe, role_plateforme)
    ON ctfarena.joueurs
    TO 'app_web'@'localhost';


GRANT SELECT(id_challenge, titre, id_categorie, difficulte, points, statut, id_auteur)
    ON ctfarena.challenges
    TO 'app_web'@'localhost';


-- auditeur
GRANT SELECT
    ON ctfarena.soumissions
    TO 'auditeur'@'localhost';

GRANT SELECT
    ON ctfarena.validations
    TO 'auditeur'@'localhost';

FLUSH PRIVILEGES;


SHOW GRANTS FOR 'admin_ctf'@'localhost';
SHOW GRANTS FOR 'orga_ctf'@'localhost';
SHOW GRANTS FOR 'app_web'@'localhost';
SHOW GRANTS FOR 'auditeur'@'localhost';


-- Mission 1.3 — Tester le cloisonnement
-- La réponse est dans le README.


-- Mission 1.4 — Passer aux rôles
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_ctf'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'orga_ctf'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_web'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'auditeur'@'localhost';

-- role_admin, role_orga, role_app, role_audit.
-- role_admin :
CREATE ROLE role_admin;

GRANT ALL PRIVILEGES
    ON ctfarena.*
    TO role_admin;


GRANT role_admin TO 'admin_ctf'@'localhost';
SET DEFAULT ROLE ALL TO 'admin_ctf'@'localhost';

-- role_orga
CREATE ROLE role_orga;

GRANT SELECT, INSERT, UPDATE
    ON ctfarena.challenges
    TO role_orga;

GRANT SELECT, INSERT, UPDATE
    ON ctfarena.categories
    TO role_orga;

GRANT SELECT
    ON ctfarena.equipes
    TO role_orga;


GRANT role_orga TO 'orga_ctf'@'localhost';
SET DEFAULT ROLE ALL TO 'orga_ctf'@'localhost';

-- role_app
CREATE ROLE role_app;

GRANT SELECT
    ON ctfarena.equipes
    TO role_app;

GRANT SELECT
    ON ctfarena.categories
    TO role_app;

GRANT SELECT
    ON ctfarena.validations
    TO role_app;

GRANT INSERT
    ON ctfarena.soumissions
    TO role_app;

GRANT SELECT(id_joueur, pseudo, id_equipe, role_plateforme)
    ON ctfarena.joueurs
    TO role_app;


GRANT SELECT(id_challenge, titre, id_categorie, difficulte, points, statut, id_auteur)
    ON ctfarena.challenges
    TO role_app;


GRANT role_app TO 'app_web'@'localhost';
SET DEFAULT ROLE ALL TO 'app_web'@'localhost';


-- role_audit :
CREATE ROLE role_audit;

GRANT SELECT
    ON ctfarena.soumissions
    TO role_audit;

GRANT SELECT
    ON ctfarena.validations
    TO role_audit;

GRANT role_audit TO 'auditeur'@'localhost';
SET DEFAULT ROLE ALL TO 'auditeur'@'localhost';


FLUSH PRIVILEGES;


-- Mission 1.5 — Appliquer une décision RGPD

REVOKE SELECT
    ON ctfarena.soumissions
    FROM role_audit;


GRANT SELECT(id_soumission, id_joueur, id_challenge, correct, date_soumission)
    ON ctfarena.soumissions
    TO role_audit;

FLUSH PRIVILEGES;

-- 2. Prouvez-le par deux tests sous auditeur : une requête refusée, une requête acceptée.

-- requête refusée 1 :
SELECT flag_propose
FROM soumissions
LIMIT 10;

-- requête refusée 2 :
SELECT ip_source
FROM soumissions
LIMIT 10;

-- requête acceptée 1 :
SELECT date_soumission
FROM soumissions
LIMIT 10;

-- requête acceptée 2 :
SELECT id_joueur
FROM soumissions
LIMIT 10;



-- Mission 1.6 - Réagir à un compte compromis
ALTER USER 'orga_ctf'@'localhost' ACCOUNT LOCK;

-- 2. Essayez de vous connecter avec : notez le message et le numéro d'erreur.
-- sudo mysql -u orga_ctf -p
-- ERROR 1045 (28000): Access denied for user 'orga_ctf'@'localhost' (using password: YES)

ALTER USER 'orga_ctf'@'localhost'
IDENTIFIED BY 'Orga!Nouveau2026';

ALTER USER 'orga_ctf'@'localhost' ACCOUNT UNLOCK;

ALTER USER 'app_web'@'localhost'
WITH MAX_USER_CONNECTIONS 20;

ALTER USER 'orga_ctf'@'localhost'
PASSWORD EXPIRE INTERVAL 90 DAY;

ALTER USER 'auditeur'@'localhost'
PASSWORD EXPIRE INTERVAL 90 DAY;


-- Bonus 1.B — Auditer les droits sans SHOW GRANTS
-- Pourquoi les rôles sont-ils préférables aux droits donnés compte par compte ?
-- Les rôles sont préférables aux droits donnés compte par compte parce qu’il est bien plus simple de gérer les permissions de seulement 4 rôles plutôt que de gérer des centaines d’utilisateurs. Cela permet de corriger plus facilement un problème de permission si on en trouve un, cela permet également de vérifier les permissions d’une catégorie d’utilisateurs rapidement. Enfin, cela a également l’avantage de mettre tous les utilisateurs à égalité face à leurs droits dans l’édition de la base de données.


SELECT GRANTEE, TABLE_NAME, PRIVILEGE_TYPE
FROM information_schema.TABLE_PRIVILEGES
WHERE TABLE_SCHEMA = 'ctfarena'
ORDER BY GRANTEE, TABLE_NAME, PRIVILEGE_TYPE;

SELECT GRANTEE, TABLE_NAME, COLUMN_NAME, PRIVILEGE_TYPE
FROM information_schema.COLUMN_PRIVILEGES
WHERE TABLE_SCHEMA = 'ctfarena'
ORDER BY GRANTEE, TABLE_NAME, COLUMN_NAME;

SELECT GRANTEE, PRIVILEGE_TYPE
FROM information_schema.SCHEMA_PRIVILEGES
WHERE TABLE_SCHEMA = 'ctfarena';

/*!80000 SELECT FROM_USER, FROM_HOST, TO_USER, TO_HOST
FROM mysql.role_edges */;

/*M!100600 SELECT Host, User, Role
FROM mysql.roles_mapping */;

-- Incohérence du bonus :
-- la matrice obligatoire autorise role_orga à lire challenges.flag,
-- pourtant classé sensible. On ne peut donc pas prouver que seul
-- role_admin accède aux colonnes sensibles.
-- On conserve la matrice obligatoire et documente cette exception.


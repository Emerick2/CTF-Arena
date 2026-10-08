USE ctfarena;

-- Mission 1.0 — Découvrir et classer les données

SHOW tables;

DESCRIBE categories;
DESCRIBE challenges;
DESCRIBE equipes;
DESCRIBE joueurs;
DESCRIBE soumissions;
DESCRIBE validations;

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

-- Mission 1.1 - Créer les comptes

DROP USER IF EXISTS
    'admin_ctf'@'localhost',
    'orga_ctf'@'localhost',
    'app_web'@'localhost',
    'auditeur'@'localhost';

DROP ROLE IF EXISTS role_admin, role_orga, role_app, role_audit;

CREATE USER 'admin_ctf'@'localhost'
IDENTIFIED BY '!IOAO4Ijo8zaid*oZOi2zZ_';

CREATE USER 'orga_ctf'@'localhost'
IDENTIFIED BY 'zaaz4eIjo8zaid*oZOi22zZ+';

CREATE USER 'app_web'@'localhost'
IDENTIFIED BY 'aad5e8z6e245OAO4Ijo8zaid*oZOi2zZ';

CREATE USER 'auditeur'@'localhost'
IDENTIFIED BY '!zeI56OAO4Ijo852zaid*oZOi2zZ786zeza**';

SELECT user, host
FROM mysql.user
WHERE user IN ('admin_ctf', 'orga_ctf', 'app_web', 'auditeur');

-- Pourquoi localhost et pas '%' ?
-- localhost limite l'origine des connexions au serveur local.
-- '%' permettrait des connexions depuis tous les hôtes autorisés
-- par le réseau, ce qui augmente l'exposition du compte applicatif.

-- Mission 1.2 - Accorder les droits directement aux comptes

GRANT ALL PRIVILEGES ON ctfarena.*
TO 'admin_ctf'@'localhost';

GRANT SELECT, INSERT, UPDATE ON ctfarena.challenges
TO 'orga_ctf'@'localhost';

GRANT SELECT, INSERT, UPDATE ON ctfarena.categories
TO 'orga_ctf'@'localhost';

GRANT SELECT ON ctfarena.equipes
TO 'orga_ctf'@'localhost';

GRANT SELECT ON ctfarena.equipes
TO 'app_web'@'localhost';

GRANT SELECT ON ctfarena.categories
TO 'app_web'@'localhost';

GRANT SELECT ON ctfarena.validations
TO 'app_web'@'localhost';

GRANT INSERT ON ctfarena.soumissions
TO 'app_web'@'localhost';

GRANT SELECT (
    id_joueur,
    pseudo,
    id_equipe,
    role_plateforme
) ON ctfarena.joueurs
TO 'app_web'@'localhost';

GRANT SELECT (
    id_challenge,
    titre,
    id_categorie,
    difficulte,
    points,
    statut,
    id_auteur
) ON ctfarena.challenges
TO 'app_web'@'localhost';

GRANT SELECT ON ctfarena.soumissions
TO 'auditeur'@'localhost';

GRANT SELECT ON ctfarena.validations
TO 'auditeur'@'localhost';

SHOW GRANTS FOR 'admin_ctf'@'localhost';
SHOW GRANTS FOR 'orga_ctf'@'localhost';
SHOW GRANTS FOR 'app_web'@'localhost';
SHOW GRANTS FOR 'auditeur'@'localhost';
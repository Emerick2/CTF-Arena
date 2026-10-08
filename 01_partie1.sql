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


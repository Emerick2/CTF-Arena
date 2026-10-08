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
-- Il ne faut pas créer un app_web avec @’%’ Sinon cela va permettre à app_web d’accéder à tous les espaces de la base de données, ce qui n’est pas ce qui est voulu.

-- +--------------------+
-- | Tables_in_ctfarena |
-- +--------------------+
-- | categories         |
-- | challenges         |
-- | equipes            |
-- | joueurs            |
-- | soumissions        |
-- | validations        |
-- +--------------------+

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
-- Mission 1.4 - Passer aux rôles

-- Supprimer les privilèges directs avant d'attribuer les rôles.

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'admin_ctf'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'orga_ctf'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'app_web'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'auditeur'@'localhost';

CREATE ROLE role_admin, role_orga, role_app, role_audit;

GRANT ALL PRIVILEGES ON ctfarena.* TO role_admin;

GRANT SELECT, INSERT, UPDATE
ON ctfarena.challenges TO role_orga;

GRANT SELECT, INSERT, UPDATE
ON ctfarena.categories TO role_orga;

GRANT SELECT ON ctfarena.equipes TO role_orga;

GRANT SELECT ON ctfarena.equipes TO role_app;
GRANT SELECT ON ctfarena.categories TO role_app;
GRANT SELECT ON ctfarena.validations TO role_app;
GRANT INSERT ON ctfarena.soumissions TO role_app;

GRANT SELECT (
    id_joueur,
    pseudo,
    id_equipe,
    role_plateforme
) ON ctfarena.joueurs TO role_app;

GRANT SELECT (
    id_challenge,
    titre,
    id_categorie,
    difficulte,
    points,
    statut,
    id_auteur
) ON ctfarena.challenges TO role_app;

GRANT SELECT ON ctfarena.soumissions TO role_audit;
GRANT SELECT ON ctfarena.validations TO role_audit;

GRANT role_admin TO 'admin_ctf'@'localhost';
GRANT role_orga TO 'orga_ctf'@'localhost';
GRANT role_app TO 'app_web'@'localhost';
GRANT role_audit TO 'auditeur'@'localhost';

-- Commentaires exécutables : le serveur choisit sa syntaxe.
-- /*!80000 ... */ : MySQL.
-- /*M!100600 ... */ : MariaDB.

/*!80000 SET DEFAULT ROLE ALL TO 'admin_ctf'@'localhost' */;
/*!80000 SET DEFAULT ROLE ALL TO 'orga_ctf'@'localhost' */;
/*!80000 SET DEFAULT ROLE ALL TO 'app_web'@'localhost' */;
/*!80000 SET DEFAULT ROLE ALL TO 'auditeur'@'localhost' */;

/*M!100600 SET DEFAULT ROLE role_admin FOR 'admin_ctf'@'localhost' */;
/*M!100600 SET DEFAULT ROLE role_orga FOR 'orga_ctf'@'localhost' */;
/*M!100600 SET DEFAULT ROLE role_app FOR 'app_web'@'localhost' */;
/*M!100600 SET DEFAULT ROLE role_audit FOR 'auditeur'@'localhost' */;

SHOW GRANTS FOR 'app_web'@'localhost';

/*
-- TEST MANUEL : fermer et rouvrir les connexions de test.
-- Refaire les cinq tests de la mission 1.3.
-- Attendu : mêmes résultats.

-- Compte app_web
-- Attendu : role_app actif.
SELECT CURRENT_ROLE();
-- Résultat réel : à compléter.
*/

-- Pourquoi utiliser des rôles ?
-- Les rôles centralisent les droits d'un profil.
-- Un nouvel utilisateur reçoit simplement le rôle adapté.
-- Une modification du rôle s'applique à ses utilisateurs.
-- Les rôles facilitent l'audit et la révocation des accès.
-- Retirer les droits directs évite les autorisations résiduelles.

-- Paradoxe : app_web peut insérer une soumission,
-- mais ne peut pas lire le flag pour vérifier la réponse.
-- La procédure DEFINER de la partie 3 résoudra ce problème.

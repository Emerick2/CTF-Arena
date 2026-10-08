USE ctfarena;

-- Mission 1.0 — Découvrir et classer les données

SHOW tables;

DESCRIBE categories;
DESCRIBE challenges;
DESCRIBE equipes;
DESCRIBE joueurs;
DESCRIBE soumissions;
DESCRIBE validations;


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

-- DROP USER IF EXISTS 'app_web'@'localhost';
-- CREATE USER 'app_web'@'localhost' IDENTIFIED BY 'MotDeP@sse1';
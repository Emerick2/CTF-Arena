# CTF-Arena
Une base de données SQL pour une CTF.


### Mission 1.3 — Tester le cloisonnement
| Compte | Commande | Prédiction | Résultat |
|---|---|---|---|
| app_web | SELECT flag FROM challenges;  | Il n'a pas les permisions | Il n'a pas les permisions |
| app_web | DELETE FROM soumissions;   | Il n'a pas les permisions | Il n'a pas les permisions |
| orga_ctf | DELETE FROM challenges WHERE id_challenge = 20;   | Il n'a pas les permisions | Il n'a pas les permisions |
| auditeur | SELECT * FROM joueurs;   | Il n'a pas les permisions | Il n'a pas les permisions |
| app_web | SELECT pseudo FROM joueurs LIMIT 3;  | La liste des pseudos apparaît. | La liste des pseudos apparaît. | 
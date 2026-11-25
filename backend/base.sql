CREATE DATABASE IF NOT EXISTS mini_projet_flutter CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mini_projet_flutter;

CREATE TABLE IF NOT EXISTS livres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    auteur VARCHAR(100) NOT NULL,
    annee SMALLINT UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO livres (titre, auteur, annee) VALUES
('Le jardin bleu', 'Amira Trabelsi', 2020),
('Voyage à Tunis', 'Sami Ben Ali', 2018),
('La maison des étoiles', 'Nour Mansouri', 2021),
('Un été à Sousse', 'Yasmine Gharbi', 2019),
('Les chemins du désert', 'Karim Haddad', 2017),
('Le carnet de Lina', 'Lina Bouaziz', 2022),
('Demain commence ici', 'Mehdi Ferchichi', 2023);

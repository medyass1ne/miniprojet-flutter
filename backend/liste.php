<?php
require 'config.php';

try {
    $livres = $pdo->query('SELECT id, titre, auteur, annee FROM livres ORDER BY id DESC')->fetchAll();
    respond($livres);
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Impossible de charger les livres.'], 500);
}

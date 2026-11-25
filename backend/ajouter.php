<?php
require 'config.php';

$titre = trim($_POST['titre'] ?? '');
$auteur = trim($_POST['auteur'] ?? '');
$annee = filter_var($_POST['annee'] ?? '', FILTER_VALIDATE_INT);

if ($titre === '' || $auteur === '' || $annee === false || $annee < 1000 || $annee > 2100) {
    respond(['success' => false, 'message' => 'Vérifiez le titre, l’auteur et l’année.']);
}

try {
    $requete = $pdo->prepare('INSERT INTO livres (titre, auteur, annee) VALUES (?, ?, ?)');
    $requete->execute([$titre, $auteur, $annee]);
    respond(['success' => true, 'message' => 'Livre ajouté.']);
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Impossible d’ajouter le livre.'], 500);
}

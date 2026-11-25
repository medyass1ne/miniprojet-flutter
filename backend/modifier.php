<?php
require 'config.php';

$id = (int) ($_POST['id'] ?? 0);
$titre = trim($_POST['titre'] ?? '');
$auteur = trim($_POST['auteur'] ?? '');
$annee = filter_var($_POST['annee'] ?? '', FILTER_VALIDATE_INT);

if ($id <= 0 || $titre === '' || $auteur === '' || $annee === false || $annee < 1000 || $annee > 2100) {
    respond(['success' => false, 'message' => 'Vérifiez les données du livre.']);
}

try {
    $requete = $pdo->prepare('UPDATE livres SET titre = ?, auteur = ?, annee = ? WHERE id = ?');
    $requete->execute([$titre, $auteur, $annee, $id]);
    respond(['success' => true, 'message' => 'Livre modifié.']);
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Impossible de modifier le livre.'], 500);
}

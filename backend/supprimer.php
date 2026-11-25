<?php
require 'config.php';

$id = (int) (json_input()['id'] ?? 0);

if ($id <= 0) {
    respond(['success' => false, 'message' => 'Identifiant invalide.']);
}

try {
    $requete = $pdo->prepare('DELETE FROM livres WHERE id = ?');
    $requete->execute([$id]);
    respond(['success' => true, 'message' => 'Livre supprimé.']);
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Impossible de supprimer le livre.'], 500);
}

<?php
require 'config.php';

$in = json_input();
$username = trim($in['username'] ?? '');
$password = $in['password'] ?? '';

if (!preg_match('/^[A-Za-z0-9_.-]{3,50}$/', $username)) {
    respond(['success' => false, 'message' => 'Nom d’utilisateur invalide (3 à 50 caractères).']);
}

if (strlen($password) < 6) {
    respond(['success' => false, 'message' => 'Le mot de passe doit contenir au moins 6 caractères.']);
}

try {
    $requete = $pdo->prepare('INSERT INTO users (username, password) VALUES (?, ?)');
    $requete->execute([$username, password_hash($password, PASSWORD_DEFAULT)]);
    respond(['success' => true, 'message' => 'Compte créé avec succès.']);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        respond(['success' => false, 'message' => 'Ce nom d’utilisateur existe déjà.']);
    }
    respond(['success' => false, 'message' => 'Impossible de créer le compte.'], 500);
}

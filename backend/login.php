<?php
require 'config.php';

$in = json_input();
$username = trim($in['username'] ?? '');
$password = $in['password'] ?? '';

if ($username === '' || $password === '') {
    respond(['success' => false, 'message' => 'Veuillez remplir tous les champs.']);
}

try {
    $requete = $pdo->prepare('SELECT password FROM users WHERE username = ?');
    $requete->execute([$username]);
    $user = $requete->fetch();

    if ($user && password_verify($password, $user['password'])) {
        respond(['success' => true, 'message' => 'Connexion réussie.']);
    }

    respond(['success' => false, 'message' => 'Nom d’utilisateur ou mot de passe incorrect.']);
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Connexion impossible.'], 500);
}

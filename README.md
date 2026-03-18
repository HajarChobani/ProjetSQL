# Système de Gestion Universitaire – Oracle PL/SQL

Ce projet consiste à développer une base de données relationnelle sous Oracle permettant de gérer un système universitaire complet.  
Il prend en charge la gestion des étudiants, professeurs, cours et inscriptions, tout en exploitant les fonctionnalités avancées de PL/SQL.

---

## Objectifs du projet

- Concevoir une base de données structurée avec clés primaires et clés étrangères  
- Automatiser la génération des identifiants grâce aux **séquences**  
- Implémenter des **procédures**, **fonctions**, **curseurs**, **packages** et **triggers**  
- Gérer les **exceptions personnalisées**  
- Assurer le suivi des modifications via un **système d’audit**

---

## Technologies utilisées

- **Oracle Database**  
- **SQL**  
- **PL/SQL**  
- **SQL\*Plus**

---

## Fonctionnalités principales

### Gestion automatique des identifiants
- Séquences pour générer les IDs : étudiants, professeurs, cours, inscriptions

### Manipulation des données
- Insertion et récupération via **procédures stockées**
- Fonctions pour calculs spécifiques (ex. expérience des professeurs)

### Curseurs
- Utilisation de curseurs pour parcourir les enregistrements  
- Boucles `CURSOR FOR LOOP`

### Package PL/SQL
- Organisation de la logique métier dans un package dédié

### Trigger d’audit
- Déclencheur permettant d’auditer les modifications (INSERT, UPDATE, DELETE)

### Gestion des exceptions
- Exceptions personnalisées pour un contrôle précis des erreurs

---

## Concepts PL/SQL démontrés

- Séquences  
- Procédures et fonctions  
- `SELECT INTO`  
- Curseurs (`CURSOR FOR LOOP`)  
- Packages  
- Triggers  
- Exceptions personnalisées  

---

## Auteur

Projet réalisé par **Hajar Chobani**.


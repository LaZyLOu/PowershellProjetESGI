-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mer. 01 mars 2023 à 14:47
-- Version du serveur : 10.5.18-MariaDB-0+deb11u1
-- Version de PHP : 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `Powershell`
--

-- --------------------------------------------------------

--
-- Structure de la table `computer`
--

CREATE TABLE `computer` (
  `guid` varchar(255) NOT NULL,
  `nom_computer` varchar(255) DEFAULT NULL,
  `marque` varchar(255) DEFAULT NULL,
  `modele` varchar(255) DEFAULT NULL,
  `num_serie` varchar(255) DEFAULT NULL,
  `num_mac` varchar(255) DEFAULT NULL,
  `processeur` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `disque` varchar(255) DEFAULT NULL,
  `bitlocker` tinyint(1) DEFAULT NULL,
  `adress_ip` varchar(15) DEFAULT NULL,
  `moniteur_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `licence`
--

CREATE TABLE `licence` (
  `id` int(11) NOT NULL,
  `licence_num` varchar(255) DEFAULT NULL,
  `fournisseur` varchar(255) DEFAULT NULL,
  `validity_date` date DEFAULT NULL,
  `validity_time` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `moniteur`
--

CREATE TABLE `moniteur` (
  `id` int(11) NOT NULL,
  `num_serie` varchar(255) DEFAULT NULL,
  `marque` varchar(255) DEFAULT NULL,
  `modele` varchar(255) DEFAULT NULL,
  `warranty_start` date DEFAULT NULL,
  `warranty_time` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `service`
--

CREATE TABLE `service` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `vlan` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `telephone`
--

CREATE TABLE `telephone` (
  `id` int(11) NOT NULL,
  `marque` varchar(255) DEFAULT NULL,
  `modele` varchar(255) DEFAULT NULL,
  `num_telephone` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `guid` varchar(255) NOT NULL,
  `nom_prenom` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `computer_id` varchar(255) DEFAULT NULL,
  `licence_id` int(11) DEFAULT NULL,
  `telephone_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `computer`
--
ALTER TABLE `computer`
  ADD PRIMARY KEY (`guid`),
  ADD KEY `fk_moniteur` (`moniteur_id`);

--
-- Index pour la table `licence`
--
ALTER TABLE `licence`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `moniteur`
--
ALTER TABLE `moniteur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `telephone`
--
ALTER TABLE `telephone`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`guid`),
  ADD KEY `fk_service` (`service_id`),
  ADD KEY `fk_computer` (`computer_id`),
  ADD KEY `fk_licence` (`licence_id`),
  ADD KEY `fk_telephone` (`telephone_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `licence`
--
ALTER TABLE `licence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `moniteur`
--
ALTER TABLE `moniteur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `service`
--
ALTER TABLE `service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `telephone`
--
ALTER TABLE `telephone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `computer`
--
ALTER TABLE `computer`
  ADD CONSTRAINT `fk_moniteur` FOREIGN KEY (`moniteur_id`) REFERENCES `moniteur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_computer` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`guid`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_licence` FOREIGN KEY (`licence_id`) REFERENCES `licence` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_service` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_telephone` FOREIGN KEY (`telephone_id`) REFERENCES `telephone` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

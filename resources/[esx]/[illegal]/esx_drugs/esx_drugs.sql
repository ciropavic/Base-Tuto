USE `es_extended`;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('cannabis', 'Feuille de cannabis', 3, 0, 1),
	('marijuana', 'Marijuana', 2, 0, 1),
	('meth', 'Sky Blue', 3, 0, 1),
	('meth_pooch', 'Pochon de Sky Blue', 2, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weed_processing', 'Carte Acces Labo Weed'),
	('meth_processing', 'Carte Acces Labo Meth'),
;

USE `es_extended`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_lostmc', 'Lost Mc', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_lostmc', 'Lost Mc', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_lostmc', 'Lost Mc', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('lostmc', 'Lost Mc')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('lostmc',0,'recruit','Recrue',0,'{}','{}'),
	('lostmc',1,'officer','Captaine de route',0,'{}','{}'),
	('lostmc',2,'sergeant','Sergent d\'armes',0,'{}','{}'),
	('lostmc',3,'lieutenant','Vice Président',0,'{}','{}'),
	('lostmc',4,'boss','President',0,'{}','{}')
;

----------------------------------------------------------------
---------------------Creation des tablespace--------------------
----------------------------------------------------------------
CREATE TABLESPACE tbs_datas
DATAFILE '/home/aurelien/Documents/M1IFI/tbs_oradata/projectbdd/tbs_datas.dbf' SIZE 10M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

CREATE TABLESPACE tbs_indexes
DATAFILE '/home/aurelien/Documents/M1IFI/tbs_oradata/projectbdd/tbs_indexes.dbf' SIZE 10M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

CREATE TABLESPACE tbs_users
DATAFILE '/home/aurelien/Documents/M1IFI/tbs_oradata/projectbdd/tbs_user.dbf' SIZE 5M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 100k;

CREATE TEMPORARY TABLESPACE tbs_temp
TEMPFILE '/home/aurelien/Documents/M1IFI/tbs_oradata/projectbdd/tbs_temp.dbf' SIZE 5M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 100k;

-------------------------------------------------------------------------------------------------
----------Creation des tables dans la base de données et écriture dans les tablespaces-----------
-------------------------------------------------------------------------------------------------

--Creation table FILM
CREATE TABLE FILM (
	id_film     NUMBER(9) NOT NULL,
	titre      	VARCHAR2(100) NOT NULL,
	genre    	VARCHAR2(25) NOT NULL,
	date_sortie DATE NOT NULL
	
)TABLESPACE tbs_datas;

ALTER TABLE FILM ADD(CONSTRAINT chk_genre CHECK(genre IN ('Action','Comedie','Horreur','Romantique','Enfants')));
ALTER TABLE FILM ADD(CONSTRAINT pk_film PRIMARY KEY(id_film) USING INDEX TABLESPACE tbs_indexes);

--Creation table DVD	
CREATE TABLE DVD (
	id_dvd    NUMBER(9) NOT NULL,
	id_f#     NUMBER(9) NOT NULL,
	quantite  NUMBER(9)
)TABLESPACE tbs_datas;

ALTER TABLE DVD ADD(CONSTRAINT pk_dvd PRIMARY KEY(id_dvd) USING INDEX TABLESPACE tbs_indexes);
ALTER TABLE DVD ADD(CONSTRAINT fk_dvd_film FOREIGN KEY(id_f#) REFERENCES FILM(id_film));

CREATE INDEX idx_fk_dvd_film ON DVD(id_f#) TABLESPACE tbs_indexes;

--Creation table BLUERAY
CREATE TABLE BLUERAY (
	id_br    NUMBER(9) NOT NULL,
	id_f#    NUMBER(9) NOT NULL,
	quantite NUMBER(9)
)TABLESPACE tbs_datas;

ALTER TABLE BLUERAY ADD(CONSTRAINT pk_br PRIMARY KEY(id_br) USING INDEX TABLESPACE tbs_indexes);
ALTER TABLE BLUERAY ADD(CONSTRAINT fk_br_film FOREIGN KEY(id_f#) REFERENCES FILM(id_film));

CREATE INDEX idx_fk_br_film ON BLUERAY(id_f#) TABLESPACE tbs_indexes;

--Creation table VHS
CREATE TABLE VHS (
	id_vhs   NUMBER(9) NOT NULL,
	id_f#    NUMBER(9) NOT NULL,
	quantite NUMBER(9)
)TABLESPACE tbs_datas;

ALTER TABLE VHS ADD(CONSTRAINT pk_vhs PRIMARY KEY(id_vhs) USING INDEX TABLESPACE tbs_indexes);
ALTER TABLE VHS ADD(CONSTRAINT fk_vhs_film FOREIGN KEY(id_f#) REFERENCES FILM(id_film));

CREATE INDEX idx_fk_vhs_film ON VHS(id_f#) TABLESPACE tbs_indexes;

--Creation table CLIENTS 
CREATE TABLE CLIENTS (
	id_client NUMBER(9) NOT NULL,
	nom       VARCHAR2(50) NOT NULL,
	prenom    VARCHAR2(50) NOT NULL,
	adresse   VARCHAR2(100) NOT NULL,
  ville     VARCHAR2(50) NOT NULL,
	telephone VARCHAR2(50),
	email     VARCHAR2(50) NOT NULL
)TABLESPACE tbs_datas;

ALTER TABLE CLIENTS ADD(CONSTRAINT pk_clients PRIMARY KEY(id_client) USING INDEX TABLESPACE tbs_indexes);

--Creation table VENTE   
CREATE TABLE VENTE (
	id_vente   NUMBER(9) NOT NULL,
	id_cli#    NUMBER(9) NOT NULL,
	id_dvd#    NUMBER(9),
	id_br#     NUMBER(9),
	id_vhs#    NUMBER(9),
	qte_dvd    NUMBER(9),
	qte_br     NUMBER(9),
	qte_vhs    NUMBER(9),
	date_vente DATE NOT NULL,
	prix_vente NUMBER(9) NOT NULL
)TABLESPACE tbs_datas; 

ALTER TABLE VENTE ADD(CONSTRAINT pk_vente PRIMARY KEY(id_vente) USING INDEX TABLESPACE tbs_indexes);
ALTER TABLE VENTE ADD(CONSTRAINT fk_vente_clients FOREIGN KEY(id_cli#) REFERENCES CLIENTS(id_client));
ALTER TABLE VENTE ADD(CONSTRAINT fk_vente_dvd FOREIGN KEY(id_dvd#) REFERENCES DVD(id_dvd));
ALTER TABLE VENTE ADD(CONSTRAINT fk_vente_br FOREIGN KEY(id_br#) REFERENCES BLUERAY(id_br));
ALTER TABLE VENTE ADD(CONSTRAINT fk_vente_vhs FOREIGN KEY(id_vhs#) REFERENCES VHS(id_vhs));

CREATE INDEX idx_fk_vente_clients ON VENTE(id_cli#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_vente_dvd ON VENTE(id_dvd#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_vente_br ON VENTE(id_br#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_vente_vhs ON VENTE(id_vhs#) TABLESPACE tbs_indexes;

--Creation table LOCATIONS
CREATE TABLE LOCATIONS (
	id_loc       NUMBER(9) NOT NULL,
	id_cli#      NUMBER(9) NOT NULL,
	id_dvd#      NUMBER(9),
	id_br#      NUMBER(9),
	id_vhs#      NUMBER(9),
	qte_dvd   NUMBER(9),
	qte_br   NUMBER(9),
	qte_vhs   NUMBER(9),
	date_debut_loc DATE NOT NULL,
	date_fin_loc DATE NOT NULL,
	prix_loc NUMBER(9) NOT NULL
)TABLESPACE tbs_datas;

ALTER TABLE LOCATIONS ADD(CONSTRAINT pk_locations PRIMARY KEY(id_loc) USING INDEX TABLESPACE tbs_indexes);
ALTER TABLE LOCATIONS ADD(CONSTRAINT fk_locations_clients FOREIGN KEY(id_cli#) REFERENCES CLIENTS(id_client));
ALTER TABLE LOCATIONS ADD(CONSTRAINT fk_locations_dvd FOREIGN KEY(id_dvd#) REFERENCES DVD(id_dvd));
ALTER TABLE LOCATIONS ADD(CONSTRAINT fk_locations_br FOREIGN KEY(id_br#) REFERENCES BLUERAY(id_br));
ALTER TABLE LOCATIONS ADD(CONSTRAINT fk_locations_vhs FOREIGN KEY(id_vhs#) REFERENCES VHS(id_vhs));

CREATE INDEX idx_fk_locations_clients ON LOCATIONS(id_cli#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_locations_dvd ON LOCATIONS(id_dvd#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_locations_br ON LOCATIONS(id_br#) TABLESPACE tbs_indexes;
CREATE INDEX idx_fk_locations_vhs ON LOCATIONS(id_vhs#) TABLESPACE tbs_indexes;

--Creation de la table qui contient les erreurs
CREATE TABLE ERREUR (
    id_err NUMBER(9) NOT NULL,
    erreur VARCHAR2(255) UNIQUE
)TABLESPACE tbs_datas;

ALTER TABLE ERREUR ADD(CONSTRAINT pk_erreur PRIMARY KEY(id_err) USING INDEX TABLESPACE tbs_indexes);
----------------------------------------------------------------
--------------Gestion des auto increment des tables-------------
----------------------------------------------------------------

--Creation des séquences
CREATE SEQUENCE film_sequence;
CREATE SEQUENCE dvd_sequence;
CREATE SEQUENCE br_sequence;
CREATE SEQUENCE vhs_sequence;
CREATE SEQUENCE clients_sequence;
CREATE SEQUENCE vente_sequence;
CREATE SEQUENCE locations_sequence;
CREATE SEQUENCE erreur_sequence;

--Delimiter avec / pour en creer plusieurs à la volée
--Creation des trigger qui incrémentent à chaque nouvel INSERT
CREATE OR REPLACE TRIGGER film_on_insert
  BEFORE INSERT ON FILM
  FOR EACH ROW
BEGIN
  SELECT film_sequence.nextval
  INTO :new.id_film
  FROM dual;
END; 
/
CREATE OR REPLACE TRIGGER dvd_on_insert
  BEFORE INSERT ON DVD
  FOR EACH ROW
BEGIN
  SELECT dvd_sequence.nextval
  INTO :new.id_dvd
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER br_on_insert
  BEFORE INSERT ON BLUERAY
  FOR EACH ROW
BEGIN
  SELECT br_sequence.nextval
  INTO :new.id_br
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER vhs_on_insert
  BEFORE INSERT ON VHS
  FOR EACH ROW
BEGIN
  SELECT vhs_sequence.nextval
  INTO :new.id_vhs
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER clients_on_insert
  BEFORE INSERT ON CLIENTS
  FOR EACH ROW
BEGIN
  SELECT clients_sequence.nextval
  INTO :new.id_client
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER vente_on_insert
  BEFORE INSERT ON VENTE
  FOR EACH ROW
BEGIN
  SELECT vente_sequence.nextval
  INTO :new.id_vente
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER locations_on_insert
  BEFORE INSERT ON LOCATIONS
  FOR EACH ROW
BEGIN
  SELECT locations_sequence.nextval
  INTO :new.id_loc
  FROM dual;
END;
/
CREATE OR REPLACE TRIGGER erreur_on_insert
  BEFORE INSERT ON ERREUR
  FOR EACH ROW
BEGIN
  SELECT erreur_sequence.nextval
  INTO :new.id_err
  FROM dual;
END;
/

----------------------------------------------------------------
------------------Gestion erreurs avec trigger------------------
----------------------------------------------------------------

--Insertion des messages d'erreurs
INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une location doit concerner un produit.');
INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une vente doit concerner un produit.');


--Trigger qui vérifie qu'un support est définis pour la table LOCATION avant un INSERT
CREATE TRIGGER before_insert_locations BEFORE INSERT
ON LOCATIONS FOR EACH ROW
BEGIN
    IF :new.id_dvd# IS NULL
    AND :new.id_br# IS NULL
    AND :new.id_vhs# IS NULL
      THEN
		--on insert une ligne qui existe déjà dans la table erreur, comme elle est
		--en index UNIQUE celà nous permet d'avoir une erreur détaillé
        INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une location doit concerner un produit.');
    END IF;
END ;
/
--Trigger qui vérifie qu'un support est définis pour la table LOCATION avant un UPDATE
CREATE TRIGGER before_update_locations BEFORE UPDATE
ON LOCATIONS FOR EACH ROW
BEGIN
    IF :new.id_dvd# IS NULL
    AND :new.id_br# IS NULL
    AND :new.id_vhs# IS NULL
      THEN
		--on insert une ligne qui existe déjà dans la table erreur, comme elle est
		--en index UNIQUE celà nous permet d'avoir une erreur détaillé
        INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une location doit concerner un produit.');
    END IF;
END;
/
--Trigger qui vérifie qu'un support est définis pour la table VENTE avant un INSERT
CREATE TRIGGER before_insert_vente BEFORE INSERT
ON VENTE FOR EACH ROW
BEGIN
    IF :new.id_dvd# IS NULL
    AND :new.id_br# IS NULL
    AND :new.id_vhs# IS NULL
      THEN
		--on insert une ligne qui existe déjà dans la table erreur, comme elle est
		--en index UNIQUE celà nous permet d'avoir une erreur détaillé
        INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une vente doit concerner un produit.');
    END IF;
END;
/
--Trigger qui vérifie qu'un support est définis pour la table VENTE avant un UPDATE
CREATE TRIGGER before_update_vente BEFORE UPDATE
ON VENTE FOR EACH ROW
BEGIN
    IF :new.id_dvd# IS NULL
    AND :new.id_br# IS NULL
    AND :new.id_vhs# IS NULL
      THEN
		--on insert une ligne qui existe déjà dans la table erreur, comme elle est
		--en index UNIQUE celà nous permet d'avoir une erreur détaillé
        INSERT INTO ERREUR (erreur) VALUES ('Erreur : Une vente doit concerner un produit.');
    END IF;
END;
/

----------------------------------------------------------------
--------------------Creation des utilisateurs-------------------
----------------------------------------------------------------

-- Creation du propriétaire
CREATE USER proprietaire IDENTIFIED BY passwd
  DEFAULT TABLESPACE tbs_users
  TEMPORARY TABLESPACE tbs_temp
  QUOTA UNLIMITED ON users;
  
GRANT CONNECT, CREATE TABLE TO proprietaire;

ALTER AUTHORIZATION
   ON [ OBJECT :: ] DVD
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] FILM
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] BLUERAY
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] VHS
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] CLIENTS
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] LOCATIONS
   TO { SCHEMA OWNER | proprietaire }
ALTER AUTHORIZATION
   ON [ OBJECT :: ] VENTES
   TO { SCHEMA OWNER | proprietaire }


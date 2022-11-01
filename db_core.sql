DROP DATABASE IF EXISTS  COOL_DB;

CREATE DATABASE COOL_DB;
USE COOL_DB;

DROP TABLE IF EXISTS EMPLOYE;

CREATE TABLE EMPLOYE(matricule varchar(32),
                    nom varchar(128),
                    prenom varchar(128),
                    contact varchar(32),
                    email varchar(128) UNIQUE NOT NULL,
                    primary key(matricule));

DROP TABLE IF EXISTS POSTE;

CREATE TABLE POSTE(
    designation varchar(32),
    commentaire varchar(128),

    primary key(designation)
);

DROP TABLE IF EXISTS POSTE_EMPLOYE;

CREATE TABLE POSTE_EMPLOYE(
    employe varchar(32),
    poste varchar(32),
    superieur_h varchar(32) default '*',
    _service varchar(32) default '*',
    departement varchar(32) default '*',
    sous_direction varchar(32) default '*',
    direction varchar(32) default '*',

    primary key(employe,poste)
);

DROP TABLE IF EXISTS EXERCICE_COMPTABLE;

CREATE TABLE ERXERCICE_COMPTABLE(
    id_exercice varchar(32),
    date_debut date,
    date_fin date,
    commentaire varchar(255),

    primary key(id_exercice)
);

DROP TABLE IF EXISTS _SERVICE;

CREATE TABLE _SERVICE(designation varchar(32),
                    manager varchar(32),
                    commentaire varchar(128),
                    departement varchar(32),
                    sous_direction varchar(32),
                    direction varchar(32),
                    primary key(designation));

DROP TABLE IF EXISTS DEPARTEMENT;

CREATE TABLE DEPARTEMENT(designation varchar(32),
                    manager varchar(32),
                    commentaire varchar(128),
                    sous_direction varchar(32),
                    direction varchar(32),
                    primary key(designation));

DROP TABLE IF EXISTS SOUS_DIRECTION;

CREATE TABLE SOUS_DIRECTION(designation varchar(32),
                    manager varchar(32),
                    commentaire varchar(128),
                    direction varchar(32),
                    primary key(designation));

DROP TABLE IF EXISTS DIRECTION;

CREATE TABLE DIRECTION(designation varchar(32),
                    manager varchar(32),
                    commentaire varchar(128),
                    primary key(designation));

INSERT INTO EMPLOYE(matricule,nom,prenom,contact) VALUES("*","*","*","*");
INSERT INTO _SERVICE(designation,commentaire,departement,sous_direction,direction,manager) VALUES("*","","*","*","*","*");
INSERT INTO DEPARTEMENT(designation,commentaire,sous_direction,direction,manager) VALUES("*","","*","*","*");
INSERT INTO SOUS_DIRECTION(designation,commentaire,direction,manager) VALUES("*","*","*","*");
INSERT INTO DIRECTION(designation,commentaire,manager) VALUES("*","*","*");


ALTER TABLE POSTE_EMPLOYE ADD CONSTRAINT FK_poste_employe_direction FOREIGN KEY(direction) REFERENCES DIRECTION(designation);
ALTER TABLE POSTE_EMPLOYE ADD CONSTRAINT FK_poste_employe_departement FOREIGN KEY(departement) REFERENCES DEPARTEMENT(designation);
ALTER TABLE POSTE_EMPLOYE ADD CONSTRAINT FK_poste_employe_sousdirection FOREIGN KEY(sous_direction) REFERENCES SOUS_DIRECTION(designation);
ALTER TABLE POSTE_EMPLOYE ADD CONSTRAINT FK_poste_employe_service FOREIGN KEY(_service) REFERENCES _service(designation);

ALTER TABLE _SERVICE ADD CONSTRAINT FK_service_direction FOREIGN KEY(direction) REFERENCES DIRECTION(designation);
ALTER TABLE _SERVICE ADD CONSTRAINT FK_service_departement FOREIGN KEY(departement) REFERENCES DEPARTEMENT(designation);
ALTER TABLE _SERVICE ADD CONSTRAINT FK_service_sousdirection FOREIGN KEY(sous_direction) REFERENCES SOUS_DIRECTION(designation);


ALTER TABLE DEPARTEMENT ADD CONSTRAINT FK_departement_direction FOREIGN KEY(direction) REFERENCES DIRECTION(designation);
ALTER TABLE DEPARTEMENT ADD CONSTRAINT FK_departement_sousdirection FOREIGN KEY(sous_direction) REFERENCES SOUS_DIRECTION(designation);

ALTER TABLE SOUS_DIRECTION ADD CONSTRAINT FK_sddirection_direction FOREIGN KEY(direction) REFERENCES DIRECTION(designation);




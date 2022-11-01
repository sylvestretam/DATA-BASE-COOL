DROP TABLE IF EXISTS MAGASIN;

CREATE TABLE MAGASIN(
    id_magasin varchar(32),
    designation varchar(32),
    localisation varchar(64),

    primary key(id_magasin)
);

DROP TABLE IF EXISTS MAGASINIER;
CREATE TABLE MAGASINIER(
    magasinier varchar(32),
    magasin varchar(32),

    primary key(magasinier,magasin)
);

ALTER TABLE MAGASINIER ADD CONSTRAINT FK_magasigner_employe FOREIGN KEY(magasinier) REFERENCES EMPLOYE(matricule);
ALTER TABLE MAGASINIER ADD CONSTRAINT FK_magasigner_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);

DROP TABLE IF EXISTS INVENTORISTE;
CREATE TABLE INVENTORISTE(
    inventoriste varchar(32),
    magasin varchar(32),

    primary key(inventoriste,magasin)
);

ALTER TABLE INVENTORISTE ADD CONSTRAINT FK_inventoriste_employe FOREIGN KEY(inventoriste) REFERENCES EMPLOYE(matricule);
ALTER TABLE INVENTORISTE ADD CONSTRAINT FK_inventoriste_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);

DROP TABLE IF EXISTS FOURNITURE;
CREATE TABLE FOURNITURE(
    id_fourniture varchar(32),
    designation varchar(32),
    unite_stockage varchar(16),
    perimable integer,

    primary key(id_fourniture)
);

DROP TABLE IF EXISTS UNITE_CONSOMATION;
CREATE TABLE UNITE_CONSOMATION(
    id_unite integer auto_increment,
    fourniture varchar(32),
    unite varchar(16),
    conversion double,

    primary key(id_unite)
);

ALTER TABLE UNITE_CONSOMATION ADD CONSTRAINT FK_fourniture_unite FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);

DROP TABLE IF EXISTS STOCK_FOURNITURE;
CREATE TABLE STOCK_FOURNITURE(
    magasin varchar(32),
    fourniture varchar(32),
    quantite_en_stock double,

    primary key(magasin,fourniture)
);

ALTER TABLE STOCK_FOURNITURE ADD CONSTRAINT FK_stock_fourniture_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);
ALTER TABLE STOCK_FOURNITURE ADD CONSTRAINT FK_stock_fourniture_fourniture FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);

DROP TABLE IF EXISTS INVENTAIRE_FOURNITURE;
CREATE TABLE INVENTAIRE_FOURNITURE(
    id_inventaire integer auto_increment,
    inventoriste varchar(32),
    magasin varchar(32),
    date_creation date,
    statu integer,
    commentaire varchar(1000),

    primary key(id_inventaire)
);

ALTER TABLE INVENTAIRE_FOURNITURE ADD CONSTRAINT FK_inventaire_fourniture_employe FOREIGN KEY(inventoriste) REFERENCES EMPLOYE(matricule);
ALTER TABLE INVENTAIRE_FOURNITURE ADD CONSTRAINT FK_inventaire_fourniture_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);

DROP TABLE IF EXISTS LIGNE_INVENTAIRE_FOURNITURE;
CREATE TABLE LIGNE_INVENTAIRE_FOURNITURE(
    inventaire integer,
    fourniture varchar(32),
    quantite_logique double,
    quantite_reel double,
    statu integer default 0,

    primary key(inventaire,fourniture)
);

DROP TABLE IF EXISTS FOURNISSEUR;
CREATE TABLE FOURNISSEUR(
    matricule varchar(32),
    designation varchar(32),

    primary key(matricule)
);

DROP TABLE IF EXISTS LIVRAISON;
CREATE TABLE LIVRAISON(
    id_livraison integer auto_increment,
    fournisseur varchar(32),
    date_livraison date,
    commentaire varchar(64),
    magasin varchar(32),
    magasinier varchar(32),

    primary key(id_livraison)
);

ALTER TABLE LIVRAISON ADD CONSTRAINT FK_fournisseur_livraison FOREIGN KEY(fournisseur) REFERENCES FOURNISSEUR(matricule);
ALTER TABLE LIVRAISON ADD CONSTRAINT FK_fournisseur_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);
ALTER TABLE LIVRAISON ADD CONSTRAINT FK_fournisseur_magasinier FOREIGN KEY(magasinier) REFERENCES EMPLOYE(matricule);

DROP TABLE IF EXISTS LOT;
CREATE TABLE LOT(
    id_lot integer auto_increment,
    fourniture varchar(32),
    livraison integer,
    date_peremption date,
    quantite double,

    primary key(id_lot)
);

ALTER TABLE LOT ADD CONSTRAINT FK_fourniture_lot FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);
ALTER TABLE LOT ADD CONSTRAINT FK_livraison_lot FOREIGN KEY(livraison) REFERENCES LIVRAISON(id_livraison);

DROP TABLE IF EXISTS BUDGET_FOURNITURE;
CREATE TABLE BUDGET_FOURNITURE(
    id_budget integer auto_increment,
    employe varchar(32),
    poste varchar(32),
    exercice varchar(32),
    date_creation date,
    date_validation date,
    statu_validation integer,
    statu_consomation integer,

    primary key(id_budget)
);

ALTER TABLE BUDGET_FOURNITURE ADD CONSTRAINT FK_budget_fourniture_employe FOREIGN KEY(employe) REFERENCES EMPLOYE(matricule);
ALTER TABLE BUDGET_FOURNITURE ADD CONSTRAINT FK_budget_fourniture_poste FOREIGN KEY(poste) REFERENCES POSTE(designation);
ALTER TABLE BUDGET_FOURNITURE ADD CONSTRAINT FK_budget_fourniture_exercice FOREIGN KEY(exercice) REFERENCES EXERCICE_COMPTABLE(id_exercice);

DROP TABLE IF EXISTS LIGNE_BUDGET_FOURNITURE;
CREATE TABLE LIGNE_BUDGET_FOURNITURE(
    fourniture varchar(32),
    budget integer,
    unite integer,
    quantite double,
    statu_validation integer,
    statu_consomation integer,

    primary key(fourniture,budget)
);

ALTER TABLE LIGNE_BUDGET_FOURNITURE ADD CONSTRAINT FK_ligne_budget_budget FOREIGN KEY(budget) REFERENCES BUDGET_FOURNITURE(id_budget);
ALTER TABLE LIGNE_BUDGET_FOURNITURE ADD CONSTRAINT FK_ligne_budget_employe FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);
ALTER TABLE LIGNE_BUDGET_FOURNITURE ADD CONSTRAINT FK_ligne_budget_unite FOREIGN KEY(unite) REFERENCES UNITE_CONSOMATION(id_unite);


DROP TABLE IF EXISTS DEMANDE_FOURNITURE;
CREATE TABLE DEMANDE_FOURNITURE(
    id_demande integer auto_increment,
    exercice varchar(32),
    demandeur varchar(32),
    magasin varchar(32),
    date_creation date,
    statu_validation integer default 0,
    statu_livraison integer default 0,
    date_livraison date,

    primary key(id_demande)
);

ALTER TABLE DEMANDE_FOURNITURE ADD CONSTRAINT FK_demande_fourniture_exercice FOREIGN KEY(exercice) REFERENCES EXERCICE_COMPTABLE(id_exercice);
ALTER TABLE DEMANDE_FOURNITURE ADD CONSTRAINT FK_demande_fourniture_employe FOREIGN KEY(demandeur) REFERENCES EMPLOYE(matricule);
ALTER TABLE DEMANDE_FOURNITURE ADD CONSTRAINT FK_demande_fourniture_magasin FOREIGN KEY(magasin) REFERENCES MAGASIN(id_magasin);

DROP TABLE IF EXISTS LIGNE_DEMANDE_FOURNITURE;
CREATE TABLE LIGNE_DEMANDE_FOURNITURE(
    demande integer,
    fourniture varchar(32),
    unite integer,
    quantite double,
    statu integer,

    primary key(demande,fourniture)
);

ALTER TABLE LIGNE_DEMANDE_FOURNITURE ADD CONSTRAINT FK_ligne_demande_fourniture_demande FOREIGN KEY(demande) REFERENCES DEMANDE_FOURNITURE(id_demande);
ALTER TABLE LIGNE_DEMANDE_FOURNITURE ADD CONSTRAINT FK_ligne_demande_fourniture_fourniture FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);
ALTER TABLE LIGNE_DEMANDE_FOURNITURE ADD CONSTRAINT FK_ligne_demande_fourniture_unite FOREIGN KEY(unite) REFERENCES UNITE_CONSOMATION(id_unite);

DROP TABLE IF EXISTS DEMANDE_FOURNITURE_VALIDE;
CREATE TABLE DEMANDE_FOURNITURE_VALIDE(
    demande integer,
    valideur varchar(32),
    date_validation date,

    primary key(demande,valideur)
);

ALTER TABLE DEMANDE_FOURNITURE_VALIDE ADD CONSTRAINT FK_demande_fourniture_valide_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE DEMANDE_FOURNITURE_VALIDE ADD CONSTRAINT FK_demande_fourniture_valide_demande FOREIGN KEY(demande) REFERENCES DEMANDE(id_demande);

DROP TABLE IF EXISTS VALIDEUR_DEPASSEMENT_SERVICE;
CREATE TABLE VALIDEUR_DEPASSEMENT_SERVICE(
    valideur varchar(32),
    _service varchar(32),

    primary key(valideur,_service)
);

ALTER TABLE VALIDEUR_DEPASSEMENT_SERVICE ADD CONSTRAINT FK_valideur_depassement_service_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE VALIDEUR_DEPASSEMENT_SERVICE ADD CONSTRAINT FK_valideur_depassement_service_ser FOREIGN KEY(_service) REFERENCES _SERVICE(designation);

DROP TABLE IF EXISTS VALIDEUR_DEPASSEMENT_DEP;
CREATE TABLE VALIDEUR_DEPASSEMENT_DEP(
    valideur varchar(32),
    departement varchar(32),

    primary key(valideur,departement)
);

ALTER TABLE VALIDEUR_DEPASSEMENT_DEP ADD CONSTRAINT FK_valideur_depassement_departement_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE VALIDEUR_DEPASSEMENT_DEP ADD CONSTRAINT FK_valideur_depassement_departement_dep FOREIGN KEY(departement) REFERENCES DEPARTEMENT(designation);

DROP TABLE IF EXISTS VALIDEUR_DEPASSEMENT_SD;
CREATE TABLE VALIDEUR_DEPASSEMENT_SD(
    valideur varchar(32),
    sous_direction varchar(32),

    primary key(valideur,sous_direction)
);

ALTER TABLE VALIDEUR_DEPASSEMENT_SD ADD CONSTRAINT FK_valideur_depassement_sd_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE VALIDEUR_DEPASSEMENT_SD ADD CONSTRAINT FK_valideur_depassement_sd_sd FOREIGN KEY(sous_direction) REFERENCES SOUS_DIRECTION(designation);

DROP TABLE IF EXISTS VALIDEUR_DEPASSEMENT_DIR;
CREATE TABLE VALIDEUR_DEPASSEMENT_DIR(
    valideur varchar(32),
    direction varchar(32),

    primary key(valideur,direction)
);

ALTER TABLE VALIDEUR_DEPASSEMENT_DIR ADD CONSTRAINT FK_valideur_depassement_dir_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE VALIDEUR_DEPASSEMENT_DIR ADD CONSTRAINT FK_valideur_depassement_dir_dir FOREIGN KEY(direction) REFERENCES DIRECTION(designation);

DROP TABLE IF EXISTS VALIDEUR_DEPASSEMENT_IND;
CREATE TABLE VALIDEUR_DEPASSEMENT_IND(
    valideur varchar(32),
    employe varchar(32),

    primary key(valideur,employe)
);

ALTER TABLE VALIDEUR_DEPASSEMENT_IND ADD CONSTRAINT FK_valideur_depassement_ind_valideur FOREIGN KEY(valideur) REFERENCES EMPLOYE(matricule);
ALTER TABLE VALIDEUR_DEPASSEMENT_IND ADD CONSTRAINT FK_valideur_depassement_ind_employe FOREIGN KEY(employe) REFERENCES EMPLOYE(matricule);

DROP TABLE IF EXISTS AVIS_LIVRAISON_PARTIEL;
CREATE TABLE AVIS_LIVRAISON_PARTIEL(
    id_avis integer auto_increment;
    demande_associe integer,
    date_creation date,
    magasinier varchar(32),
    statu_validation integer,
    statu_livraison integer default 0,
    
    primary key(id_avis)
);

ALTER TABLE AVIS_LIVRAISON_PARTIEL ADD CONSTRAINT FK_avis_livraison_partiel_demande_associe FOREIGN KEY(demande_associe) REFERENCES DEMANDE_FOURNITURE(id_demande);
ALTER TABLE AVIS_LIVRAISON_PARTIEL ADD CONSTRAINT FK_avis_livraison_partiel_demande_magasinier FOREIGN KEY(magasinier) REFERENCES EMPLOYE(matricule);

DROP TABLE IF EXISTS LIGNE_AVIS_LIVRAISON_PARTIEL;
CREATE TABLE LIGNE_AVIS_LIVRAISON_PARTIEL(
    avis integer,
    fourniture varchar(32),
    quantite_en_stock double,
    unite integer,

    primary key(avis,fourniture)
);

ALTER TABLE LIGNE_AVIS_LIVRAISON_PARTIEL ADD CONSTRAINT FK_ligne_avis_livraison_partiel_demande_associe FOREIGN KEY(avis) REFERENCES AVIS_LIVRAISON_PARTIEL(id_avis);
ALTER TABLE LIGNE_AVIS_LIVRAISON_PARTIEL ADD CONSTRAINT FK_ligne_avis_livraison_partiel_demande_fourniture FOREIGN KEY(fourniture) REFERENCES FOURNITURE(id_fourniture);
ALTER TABLE LIGNE_AVIS_LIVRAISON_PARTIEL ADD CONSTRAINT FK_ligne_avis_livraison_partiel_unite FOREIGN KEY(unite) REFERENCES UNITE_CONSOMATION(id_unite);
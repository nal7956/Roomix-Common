DROP TABLE IF EXISTS package, artikel, hotelLeistung, reservierung, reservierungsEinheit, belegung, rechnung, rechnungsPosition,
stornierungsKondition, stornierung, ausstattung, zimmerAusstattung, zimmer, zimmerkategoriepreis, zimmerKategorie,
personenBelegung, person, vertragsPartner, saison, kontingent, partnerVertrag, zahlungsart, zahlungsModalitaet,
bezahlung, gruppenmitglieder, gruppe, kontakt, reservierungsOption;



create table person (
	personID int,					-- primary key
	istVIP int,
	-- wird er archiviert?
	archivieren int
);

create table gruppe(
	gruppenID int,						-- primary key
	gruppenName varchar(50),
	gruppenLeiterID int					-- references person id
);

create table kontakt(
	kontaktID int,	-- primary key
	personID int,		-- references person table
	-- kontankt details
	kontaktName varchar(50),
	telefonnummer NUMERIC,
	strasse varchar(30),
	ort varchar(30),
	plz varchar(8),
	land varchar(30),
	email varchar(10),
	kreditkartennummer int,
	notiz text
);


create table vertragsPartner(
	vertragsPartnerID int,			-- primary key
	vertragsPartnerTyp varchar(50)
);


create table gruppenMitglieder(
	gruppenID int,		-- primary key
	personID int			-- primary key
);

-- gehört evtl auch zu reservierungseinheit
create table reservierungsOption(
	optionsID int,					  -- primary key
	reservierungsID int, 			-- references reservierungs id in table reservierung
	optionsDatum DATE,
	optionsBezeichnung varchar(50),
	optionsStatus BOOLEAN
);


create table partnerVertrag(
	vertragsID int,									-- primary key
	vertragsPartnerID int, 					-- references vertragsPartner table
	stornierungsKonditionID int,		-- references table stornierungsKondition
	startDatum DATE,
	endDatum DATE,
	rabattAnteil int
);

create table kontingent(
	kontingentID int, 				 -- primary key
	vertragsID int, 					 -- references partnerVertrag table
	zimmerKategorieID int,		 -- references zimmerKategorie table
	anzahlZimmer int, 				 -- anzahl der Zimmer für das Kontingent
	preisProZimmer NUMERIC(2)	 -- Preis für ein Zimmer für eine Nacht -> überschreibt quasi Kategorie Preis
);

create table zimmerKategorie(
	zimmerKategorieID int,				-- primary key
	zimmerKategorieBezeichnung varchar(50)
);

create table zimmerKategoriePreis(
	kategoriePreisID int,  -- primary key
	zimmerKategorieID int, -- references zimmerKategorie
	saisonID int, 			   -- references saison table
	listenPreis NUMERIC(2),
	einstandsPreis NUMERIC(2),
	mindestPreis NUMERIC(2),
	tagesPreis NUMERIC(2)
);

create TABLE saison(
	saisonID int,
	saisonBezeichnung VARCHAR(50),
	saisionAufschlag int,
	saisonStartDatum DATE,
	saisonEndDatum DATE
);

create table zahlungsArt(
	zahlungsArtID int,
	zahlungsArtBezeichnung VARCHAR(50)
);

CREATE TABLE  zahlungsModalitaet(
	zahlungsModalitaetID int,		-- primary key
	zahlungsArtID int, 		-- references zahlungsArt table
	-- anzahl tage zur Zahlung
	zahlungsFrist int
);

CREATE TABLE bezahlung(
	bezahlungsID int,					-- primary key
	zahlungsModalitaetID int, -- references zahlungsModalitaet
	rechnungsID int,					-- references rechnung
	betrag NUMERIC(2),
	erstellungsDatum DATE,	-- wann die Bezahlung erstellt wurde
	bezahlDatum DATE 				-- wann die Zahlung eingegangen ist
);

CREATE TABLE rechnung(
	rechnungsID int,					-- primary key
	kontaktName varchar(50), 	-- bezieht sich nicht unbedingt auf den Kontaktnamen der oben in der Kontakt tabelle steht
	strasse varchar(30),
	ort varchar(30),
	plz varchar(8),
	land varchar(30),
	rechnungsStatus ENUM('paid', 'open', 'canceled', 'partlyPaid')
);

CREATE TABLE reservierung(
	reservierungsID int,			-- primary key
	vertragsPartnerID int,    -- references table vertragsPartner
	personID int,							-- references table person
	reservierungsStatus ENUM('open', 'confirmed', 'canceled')
);

CREATE TABLE reservierungsEinheit(
	reservierungsEinheitID int, -- primary key
	reservierungsID int, 			  -- references table reservierung
	zimmerKategorieID int,			-- references table zimmerKategorie
	belegungsID int,						-- references table belegung
	zimmerID int,								-- references table zimmer
	stornierungsID int,					-- references table stornierung
	packageID int,							-- references table package (might be null)
	startDatum DATE,
	endDatum DATE
);

CREATE TABLE belegung(
	belegungsID int,						-- primary key
	anreiseDatum DATE,
	abreiseDatum DATE,
	positionsID int, 						-- references table position
	zimmerID int								-- references table zimmer
);

CREATE TABLE zimmer(
	zimmerID int,    						-- primary key
	zimmerKategorieID int,			-- references table zimmerKategorie
	zimmerStatus ENUM('frei-ungereinigt', 'frei-gereinigt', 'besetzt-gereinigt', 'besetzt-ungereinigt', 'out-of-order')
);


CREATE TABLE personenBelegung(
	belegungsID int,			-- primary key (references belegung)
	personID int					-- primary key (references person)
);


CREATE TABLE ausstattung(
	ausstattungsID int,										-- primary key
	ausstattungsBezeichnung varchar(50),
	ausstattungsAufschlag NUMERIC(2)
);

CREATE TABLE zimmerAusstattung(
	zimmerID int, 						-- references table zimmer
	ausstattungsID int				-- references table ausstattung
);

CREATE TABLE stornierung(
	stornierungsID int,								-- primary key
	stornierungsKonditionID int,			-- references stornierungsKondition
	-- stornierungskonditionen
	stornierungsDatum DATE,
	stornierungsBezeichnung varchar(50)
);

CREATE TABLE stornierungsKondition(
	stornierungsKonditionID int,				-- primary key
	stornierungsBetrag NUMERIC(2),
	tageVorAnkunft int
);

CREATE TABLE rechnungsPosition (
	positionsID int, 							-- primary key
	rechnungsID int,							-- references table rechnung
	belegungsID int, 							-- references table belegung (optional -> might be null)
	reservierungsEinheitID int, 	-- references reservierungsEinheit
	reservierungsID int,					-- references table reservierung
	hotelLeistungsID int,					-- references table hotelleistung
	preis int,
	datum DATE,
	menge int
);

CREATE TABLE hotelLeistung(
	hotelLeistungsID int,			-- primary key
	artikelID int							-- references artikel
);

CREATE TABLE artikel(
	artikelID int,						-- primary key
	packageBezeichnung VARCHAR(50)
);

CREATE TABLE package(
	packageID int,			-- primary key
	artikelID int			  -- references table artikel
);


-- ############### Mitarbeiter ############### --


-- ############### Key constraints ############### --

ALTER TABLE artikel
		ADD PRIMARY KEY (artikelID);

ALTER TABLE package
		ADD PRIMARY KEY (packageID),
		add CONSTRAINT fkey_package_artikelID FOREIGN KEY (artikelID) REFERENCES artikel(artikelID);

ALTER TABLE hotelLeistung
		ADD PRIMARY KEY (hotelLeistungsID),
		ADD CONSTRAINT fkey_hotelLeistung_artikelID FOREIGN KEY(artikelID) REFERENCES artikel(artikelID);

ALTER TABLE person
	add PRIMARY KEY(personID),
	add constraint person_vip check (istVIP = '1' or istVIP = '0');

ALTER TABLE gruppe
		add PRIMARY KEY (gruppenID),
		add CONSTRAINT fkey_gruppenleiter FOREIGN KEY (gruppenLeiterID) REFERENCES person(personID) ;

ALTER TABLE kontakt
		add PRIMARY KEY (kontaktID),
		add constraint fkey_personID FOREIGN KEY(personID) REFERENCES person(personID);

ALTER TABLE vertragsPartner
		add PRIMARY KEY (vertragsPartnerID);

ALTER TABLE gruppenMitglieder
		ADD PRIMARY KEY (personID, gruppenID),
		ADD CONSTRAINT fkey_gruppenMitglied FOREIGN KEY (personID) REFERENCES person(personID),
		ADD	CONSTRAINT fkey_gruppe FOREIGN KEY (gruppenID) REFERENCES gruppe(gruppenID);


ALTER TABLE stornierungsKondition
		ADD PRIMARY KEY (stornierungsKonditionID);

ALTER TABLE partnerVertrag
		ADD PRIMARY KEY (vertragsID),
	  ADD CONSTRAINT fkey_vertragsPartnerID FOREIGN KEY (vertragsPartnerID) REFERENCES vertragsPartner(vertragsPartnerID),
		ADD CONSTRAINT fkey_stornierungsKonditionID FOREIGN KEY (stornierungsKonditionID) REFERENCES stornierungsKondition(stornierungsKonditionID);

ALTER TABLE zimmerKategorie
		ADD PRIMARY KEY (zimmerKategorieID);

ALTER TABLE kontingent
		ADD PRIMARY KEY (kontingentID),
		ADD CONSTRAINT fkey_vertragsID FOREIGN KEY (vertragsID) REFERENCES partnerVertrag(vertragsID),
		ADD CONSTRAINT fkey_zimmerKategorieID FOREIGN KEY (zimmerKategorieID) REFERENCES zimmerKategorie(zimmerKategorieID);

ALTER TABLE saison
		ADD PRIMARY KEY (saisonID);

ALTER TABLE zimmerKategoriePreis
		ADD PRIMARY KEY (kategoriePreisID),
		ADD CONSTRAINT fkey_zkp_zimmerKategorieID FOREIGN KEY (zimmerKategorieID) REFERENCES zimmerKategorie(zimmerKategorieID),
		ADD CONSTRAINT fkey_zkp_saisonID FOREIGN KEY (saisonID) REFERENCES saison(saisonID);

ALTER TABLE zahlungsArt
		ADD PRIMARY KEY (zahlungsArtID);

ALTER TABLE zahlungsModalitaet
		ADD PRIMARY KEY (zahlungsModalitaetID),
		ADD CONSTRAINT fkey_zahlungsart FOREIGN KEY (zahlungsArtID) REFERENCES zahlungsArt(zahlungsArtID);

ALTER TABLE rechnung
		ADD PRIMARY KEY (rechnungsID);

ALTER TABLE bezahlung
		ADD PRIMARY KEY (bezahlungsID),
		ADD CONSTRAINT fkey_zahlungsModalitaetID FOREIGN KEY (zahlungsModalitaetID) REFERENCES zahlungsModalitaet(zahlungsModalitaetID),
		ADD CONSTRAINT fkey_rechnungsID FOREIGN KEY (rechnungsID) REFERENCES rechnung(rechnungsID);

ALTER TABLE reservierung
		ADD PRIMARY KEY (reservierungsID ),
		ADD CONSTRAINT fkey_reservierungPerson FOREIGN KEY (personID) REFERENCES person(personID),
		ADD CONSTRAINT fkey_res_vertragsPartnerID FOREIGN KEY (vertragsPartnerID) REFERENCES vertragsPartner(vertragsPartnerID);

ALTER TABLE reservierungsOption
		ADD PRIMARY KEY (optionsID),
		ADD CONSTRAINT fkey_reservierung FOREIGN KEY (reservierungsID) REFERENCES reservierung(reservierungsID);

ALTER TABLE zimmer
		ADD PRIMARY KEY (zimmerID),
		ADD CONSTRAINT fkey_zimmer_zimmerKategorieID FOREIGN KEY (zimmerKategorieID) REFERENCES zimmerKategorie(zimmerKategorieID);


ALTER TABLE ausstattung
		ADD PRIMARY KEY (ausstattungsID);

ALTER TABLE zimmerAusstattung
		ADD PRIMARY KEY (zimmerID, ausstattungsID),
		ADD CONSTRAINT fkey_zimmerAusstattung_zimmerID FOREIGN KEY (zimmerID) REFERENCES zimmer(zimmerID),
		ADD CONSTRAINT fkey_zimmerAusstattung_ausstattungsID FOREIGN KEY (ausstattungsID) REFERENCES ausstattung(ausstattungsID);

ALTER TABLE stornierung
		add PRIMARY KEY (stornierungsID ),
		ADD CONSTRAINT fkey_stornierung_konditionsID FOREIGN KEY (stornierungsKonditionID) REFERENCES stornierungsKondition(stornierungsKonditionID);


ALTER TABLE personenBelegung
		ADD PRIMARY KEY (belegungsID, personID),
		ADD CONSTRAINT fkey_personenBelegung_personID FOREIGN KEY (personID) REFERENCES person(personID);


ALTER TABLE belegung
		ADD PRIMARY KEY (belegungsID),
		ADD CONSTRAINT fkey_belegung_zimmerID FOREIGN KEY (zimmerID) REFERENCES zimmer(zimmerID);


ALTER TABLE personenBelegung
		ADD CONSTRAINT fkey_personenBelegung_belegungsID FOREIGN KEY (belegungsID) REFERENCES belegung(belegungsID);

ALTER TABLE rechnungsPosition
		ADD PRIMARY KEY (positionsID ),
		ADD CONSTRAINT fkey_position_rechnungsID FOREIGN KEY (rechnungsID) REFERENCES rechnung(rechnungsID),
		ADD CONSTRAINT fkey_position_reserveriungsID FOREIGN KEY (reservierungsID) REFERENCES reservierung(reservierungsID),
		ADD CONSTRAINT fkey_position_hotelLeistungsID FOREIGN KEY (hotelLeistungsID) REFERENCES hotelLeistung(hotelLeistungsID),
		ADD CONSTRAINT fkey_position_belegungsID FOREIGN KEY (belegungsID) REFERENCES belegung(belegungsID);

ALTER TABLE belegung
		ADD CONSTRAINT fkey_belegung_positionsID FOREIGN KEY (positionsID) REFERENCES rechnungsPosition(positionsID);

-- add primary keys (zimmer, belegung, package, stornierung)
ALTER TABLE reservierungsEinheit
		ADD PRIMARY KEY (reservierungsEinheitID),
		ADD CONSTRAINT fkey_e_reservierungsID FOREIGN KEY (reservierungsID) REFERENCES reservierung(reservierungsID),
		ADD CONSTRAINT fkey_e_zimmerKategorieID FOREIGN KEY (zimmerKategorieID) REFERENCES zimmerKategorie(zimmerKategorieID),
		ADD CONSTRAINT fkey_e_belegungsID FOREIGN KEY (belegungsID) REFERENCES belegung(belegungsID),
		ADD CONSTRAINT fkey_e_zimmerID FOREIGN KEY (zimmerID) REFERENCES zimmer(zimmerID),
		ADD CONSTRAINT fkey_e_stornierungsID FOREIGN KEY (stornierungsID) REFERENCES stornierung(stornierungsID),
		ADD CONSTRAINT fkey_e_packageID FOREIGN KEY  (packageID) REFERENCES package(packageID);

ALTER TABLE rechnungsPosition
		ADD CONSTRAINT fkey_position_reID FOREIGN KEY (reservierungsEinheitID) REFERENCES reservierungsEinheit(reservierungsEinheitID);
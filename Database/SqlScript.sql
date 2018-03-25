DROP DATABASE IF EXISTS Roomix;

CREATE DATABASE Roomix;
USE Roomix;

CREATE TABLE Season (
	SeasonID INTEGER AUTO_INCREMENT,
	Description VARCHAR(150) NOT NULL,
	Surcharge INTEGER NOT NULL, -- TODO Was ist hier gemeint? Vllt doch Geld?
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	PRIMARY KEY (SeasonID)
);

CREATE TABLE RoomCategory(
	RoomCategoryID INTEGER NOT NULL,
	CategoryDescription varchar(150) NOT NULL,
	PRIMARY KEY (RoomCategoryID)
);

CREATE TABLE Facility (
	FacilityID INTEGER AUTO_INCREMENT,
	Description VARCHAR(150) NOT NULL,
	Surcharge DECIMAL(5) NOT NULL,
	PRIMARY KEY (FacilityID)
);

CREATE TABLE Room(
	RoomID INTEGER AUTO_INCREMENT,
	RoomCategory INTEGER NOT NULL,
	Status VARCHAR(20) NOT NULL,
	PRIMARY KEY (RoomID),
	FOREIGN KEY (RoomCategory) REFERENCES RoomCategory(RoomCategoryID)
);

CREATE TABLE RoomFacility(
	Room INTEGER NOT NULL,
	Facility INTEGER NOT NULL,
	UNIQUE (Room, Facility),
	FOREIGN KEY (Facility) REFERENCES Facility(FacilityID),
	FOREIGN KEY (Room) REFERENCES Room(RoomID)
);

CREATE TABLE RoomCategoryPrice(
	RoomCategoryPriceID INTEGER AUTO_INCREMENT,
	RoomCategory INTEGER NOT NULL,
	Season INTEGER NOT NULL,
	ListPrice DECIMAL(5) NOT NULL,
	AcquisitionPrice DECIMAL(5) NOT NULL,
	MinimumPrice DECIMAL(5) NOT NULL,
	DayPrice DECIMAL(5),
	PRIMARY KEY (RoomCategoryPriceID),
	FOREIGN KEY (RoomCategory) REFERENCES RoomCategory(RoomCategoryID),
	FOREIGN KEY (Season) REFERENCES Season(SeasonID)
);

CREATE TABLE Contact(
	ContactID INTEGER AUTO_INCREMENT,
	Forename varchar(50),
	Surname varchar(50),
	CompanyName VARCHAR(50),
	PhoneNumber VARCHAR(50) NOT NULL ,
	Street varchar(50)NOT NULL ,
	Place varchar(50)NOT NULL ,
	Postcode varchar(50)NOT NULL ,
	Country varchar(30)NOT NULL ,
	Email varchar(50)NOT NULL ,
	Active BOOLEAN NOT NULL DEFAULT TRUE ,
	PRIMARY KEY (ContactID)
);

CREATE TABLE ContactNote(
	ContactNoteID INTEGER AUTO_INCREMENT,
	Contact INTEGER NOT NULL,
	NoteContent VARCHAR(500) NOT NULL,
	PRIMARY KEY (ContactNoteID),
	FOREIGN KEY (Contact) REFERENCES Contact(ContactID)
);

CREATE TABLE CreditCard(
	CreditCardID INTEGER AUTO_INCREMENT,
	Number VARCHAR(50) NOT NULL ,
	Owner varchar(50),
	Type VARCHAR(10) NOT NULL,
	ValidDate DATE NOT NULL,
	Contact INTEGER,
	PRIMARY KEY (CreditCardID),
	FOREIGN KEY (Contact) REFERENCES Contact(ContactID)
);

CREATE TABLE Person (
	PersonID INT AUTO_INCREMENT,
	IsVIP BOOLEAN NOT NULL,
	Archive BOOLEAN NOT NULL,
	Contact INTEGER NOT NULL,
	PRIMARY KEY (PersonID),
	FOREIGN KEY (Contact) REFERENCES Contact(ContactID)
);

CREATE TABLE ContractingParty(
	ContractingPartyID INTEGER AUTO_INCREMENT,
	ContractingPartyType varchar(50) NOT NULL ,
	Contact INTEGER NOT NULL ,
	PRIMARY KEY (ContractingPartyID),
	FOREIGN KEY (Contact) REFERENCES Contact(ContactID)
);

CREATE TABLE CancellationCondition(
	CancellationConditionID INTEGER AUTO_INCREMENT,
	CancellationFee DECIMAL(5) NOT NULL ,
	DaysBeforeArrival INTEGER NOT NULL,
  PRIMARY KEY (CancellationConditionID)
);

CREATE TABLE Article(
	ArticleID INTEGER AUTO_INCREMENT,
	ArticleDescription VARCHAR(50),
  PRIMARY KEY (ArticleID)
);

CREATE TABLE HotelService(
	HotelServiceID INTEGER AUTO_INCREMENT,
	Article INTEGER NOT NULL ,
  PRIMARY KEY (HotelServiceID),
  FOREIGN KEY (Article) REFERENCES Article(ArticleID)
);

CREATE TABLE Package(
	PackageID INTEGER,
	Article INTEGER NOT NULL ,
  PRIMARY KEY (PackageID),
  FOREIGN KEY (Article) REFERENCES Article(ArticleID)
);

CREATE TABLE Cancellation(
	CancellationID INTEGER AUTO_INCREMENT,
	CancellationCondition INTEGER NOT NULL ,
	Date TIMESTAMP NOT NULL DEFAULT NOW(),
	Description varchar(150),
	PRIMARY KEY (CancellationID),
  FOREIGN KEY (CancellationCondition)
    REFERENCES CancellationCondition(CancellationConditionID)
);

CREATE TABLE PartnerAgreement(
	AgreementID INTEGER AUTO_INCREMENT,
  ContractingParty INTEGER NOT NULL,
	CancellationCondition INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	ExpiryDate DATE NOT NULL,
	Discount INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (AgreementID),
  FOREIGN KEY (ContractingParty)
    REFERENCES ContractingParty(ContractingPartyID),
  FOREIGN KEY (CancellationCondition)
    REFERENCES CancellationCondition(CancellationConditionID)
);

CREATE TABLE Reservation(
	ReservationID INTEGER AUTO_INCREMENT,
	ContractingParty INTEGER NOT NULL,
	Person INTEGER NOT NULL,
	ReservationStatus VARCHAR(15) NOT NULL,
  PRIMARY KEY (ReservationID),
  FOREIGN KEY (ContractingParty) REFERENCES ContractingParty(ContractingPartyID),
  FOREIGN KEY (Person) REFERENCES Person(PersonID)
);

CREATE TABLE ReservationOption(
	OptionID INTEGER AUTO_INCREMENT,
	Reservation INTEGER NOT NULL ,
	OptionDueDate DATE NOT NULL,
	OptionDescription varchar(150) NOT NULL,
	OptionStatus BOOLEAN NOT NULL,
  PRIMARY KEY (OptionID),
  FOREIGN KEY (Reservation) REFERENCES Reservation(ReservationID)
);

CREATE TABLE Squad (
	SquadID INTEGER AUTO_INCREMENT,
	SquadName VARCHAR(50) NOT NULL,
	SquadLeader INTEGER NOT NULL,
  PRIMARY KEY (SquadID),
  FOREIGN KEY (SquadLeader) REFERENCES Person(PersonID)
);

CREATE TABLE SquadMember (
	Squad INTEGER,
	SquadMember INTEGER NOT NULL,
  UNIQUE (Squad, SquadMember),
  FOREIGN KEY (Squad) REFERENCES Squad(SquadID),
  FOREIGN KEY (SquadMember) REFERENCES Person(PersonID)
);

CREATE TABLE PaymentType(
	PaymentTypeID INTEGER NOT NULL,
	PaymentTypeDescription VARCHAR(150),
  PRIMARY KEY (PaymentTypeID)
);

CREATE TABLE Invoice(
	InvoiceID INTEGER AUTO_INCREMENT,
	Name varchar(50) NOT NULL,
	Street varchar(50)NOT NULL,
	Place varchar(50)NOT NULL,
	Postcode varchar(50)NOT NULL,
	Country varchar(30)NOT NULL,
	MakingOutDate TIMESTAMP NOT NULL DEFAULT NOW(),
  Status VARCHAR(15) NOT NULL,
  PRIMARY KEY (InvoiceID)
);

CREATE TABLE Payment(
	PaymentID INTEGER NOT NULL,
	Invoice INTEGER NOT NULL,
  PaymentType INTEGER NOT NULL,
	Amount DECIMAL(5) NOT NULL,
  MakingOutDate TIMESTAMP NOT NULL DEFAULT NOW(),
  DueDate DATE NOT NULL,
  PaidDate DATE,
  PRIMARY KEY (PaymentID),
  FOREIGN KEY (Invoice) REFERENCES Invoice(InvoiceID),
  FOREIGN KEY (PaymentType) REFERENCES PaymentType(PaymentTypeID)
);

CREATE TABLE ReservationUnit(
	ReservationUnitID INTEGER NOT NULL ,
	Reservation INTEGER NOT NULL,
	RoomCategory INTEGER NOT NULL,
	Cancelation INTEGER,
	Package INTEGER,
  StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
  PRIMARY KEY (ReservationUnitID),
  FOREIGN KEY (Reservation) REFERENCES Reservation(ReservationID),
  FOREIGN KEY (RoomCategory) REFERENCES RoomCategory(RoomCategoryID),
  FOREIGN KEY (Cancelation) REFERENCES Cancellation(CancellationID),
  FOREIGN KEY (Package) REFERENCES Package(PackageID)
);

CREATE TABLE RoomAssignment(
  RoomAssignmentID INTEGER AUTO_INCREMENT,
  ArrivalDate DATE NOT NULL,
	DepartureDate DATE NOT NULL,
  Room INTEGER NOT NULL,
  ReservationUnit INTEGER NOT NULL,
  PRIMARY KEY (RoomAssignmentID),
  FOREIGN KEY (Room) REFERENCES Room(RoomID),
  FOREIGN KEY (ReservationUnit) REFERENCES ReservationUnit(ReservationUnitID)
);

CREATE TABLE PersonRoomAssignment(
	RoomAssignment INTEGER NOT NULL,
	Person INTEGER NOT NULL,
  UNIQUE (RoomAssignment, Person),
  FOREIGN KEY (RoomAssignment) REFERENCES RoomAssignment(RoomAssignmentID),
  FOREIGN KEY (Person) REFERENCES Person(PersonID)
);

CREATE TABLE InvoicePosition (
	InvoicePositionID INTEGER AUTO_INCREMENT,
  Reservation INTEGER NOT NULL,
  ReservationUnit INTEGER NOT NULL,
	Invoice INTEGER,
	RoomAssignment INTEGER, -- Only HotelService OR RoomAssignment
	HotelService INTEGER,
	Amount DECIMAL(5) NOT NULL ,
	MakingOutDate TIMESTAMP NOT NULL DEFAULT NOW(),
	Count INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY (InvoicePositionID),
	FOREIGN KEY (Reservation) REFERENCES Reservation(ReservationID),
	FOREIGN KEY (ReservationUnit) REFERENCES ReservationUnit(ReservationUnitID),
	FOREIGN KEY (Invoice) REFERENCES Invoice(InvoiceID)
);

-- Constrain Checks
DELIMITER //
CREATE TRIGGER InvoicePositionInsertConstrain BEFORE INSERT On InvoicePosition
	FOR EACH ROW
	BEGIN
    IF (NEW.Count <= 0) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Count must be bigger than zero';
    END IF;
		IF (NEW.RoomAssignment IS NULL AND NEW.HotelService IS NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You must specify the Invoice Position';
    END IF;
    IF (NEW.RoomAssignment IS NOT NULL AND NEW.HotelService IS NOT NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Multiple specifications in the Invoice Position';
    END IF;
	END;
	//
CREATE TRIGGER InvoicePositionUpdateConstrain BEFORE UPDATE On InvoicePosition
	FOR EACH ROW
	BEGIN
    IF (NEW.Count <= 0) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Count must be bigger than zero';
    END IF;
		IF (NEW.RoomAssignment IS NULL AND NEW.HotelService IS NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You must specify the Invoice Position';
    END IF;
    IF (NEW.RoomAssignment IS NOT NULL AND NEW.HotelService IS NOT NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Multiple specifications in the Invoice Position';
    END IF;
    IF (NEW.Invoice IS NOT NULL) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invoice already make. Changes are not Allowed';
		END IF;
	END;
	//
CREATE TRIGGER ContactInserConstrain BEFORE INSERT On Contact
	FOR EACH ROW
	BEGIN
		IF (NEW.CompanyName IS NULL) THEN
			IF (NEW.Forename IS NULL OR New.Surname IS NULL ) THEN
				SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add or update row: Forname and Surename OR CompanyName is required';
			END IF;
		END IF;
	END;
	//
CREATE TRIGGER ContactUpdateConstrain BEFORE UPDATE On Contact
	FOR EACH ROW
	BEGIN
		IF (NEW.CompanyName IS NULL) THEN
			IF (NEW.Forename IS NULL OR New.Surname IS NULL ) THEN
				SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add or update row: Forname and Surename OR CompanyName is required';
			END IF;
		END IF;
	END;
	//
CREATE TRIGGER CategoryPriceInsertConstrain BEFORE INSERT On RoomCategoryPrice
	FOR EACH ROW
	BEGIN
		IF (NEW.DayPrice IS NULL) THEN
			SET NEW.DayPrice = NEW.ListPrice;
		END IF;
		IF (NEW.DayPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DayPrice is under Minimum Price';
		END IF;
		IF (NEW.AcquisitionPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'AcquisitionPrice is under Minimum Price';
		END IF;
		IF (NEW.ListPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ListPrice is under Minimum Price';
		END IF;
	END;
	//
CREATE TRIGGER CategoryPriceUpdateConstrain BEFORE UPDATE On RoomCategoryPrice
	FOR EACH ROW
	BEGIN
		IF (NEW.DayPrice IS NULL) THEN
			SET NEW.DayPrice = NEW.ListPrice;
		END IF;
		IF (NEW.DayPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DayPrice is under Minimum Price';
		END IF;
		IF (NEW.AcquisitionPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'AcquisitionPrice is under Minimum Price';
		END IF;
		IF (NEW.ListPrice <= NEW.MinimumPrice) THEN
			SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ListPrice is under Minimum Price';
		END IF;
	END;
	//

DELIMITER ;


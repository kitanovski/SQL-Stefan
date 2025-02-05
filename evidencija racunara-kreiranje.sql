-- Креирање базе података са подршком за ћирилична слова
CREATE DATABASE EvidencijaRacunara
    COLLATE Cyrillic_General_CI_AS;
GO

-- Коришћење базе података
USE EvidencijaRacunara;
GO

-- Табеле за евиденцију
CREATE TABLE Lica (
                      LiceID INT PRIMARY KEY IDENTITY(1,1),
                      Prezime NVARCHAR(50),
                      Ime NVARCHAR(50),
                      JMBG CHAR(13) UNIQUE
);

CREATE TABLE TipoviRacunara (
                                TipID INT PRIMARY KEY IDENTITY(1,1),
                                NazivTipa NVARCHAR(50)
);

CREATE TABLE Komponente (
                            KomponentaID INT PRIMARY KEY IDENTITY(1,1),
                            NazivKomponente NVARCHAR(100)
);

CREATE TABLE Racunari (
                          RacunarID INT PRIMARY KEY IDENTITY(1,1),
                          TipID INT FOREIGN KEY REFERENCES TipoviRacunara(TipID),
                          InternaOznaka NVARCHAR(50),
                          SerijskiBroj NVARCHAR(50)
);

CREATE TABLE Konfiguracija (
                               KonfiguracijaID INT PRIMARY KEY IDENTITY(1,1),
                               RacunarID INT FOREIGN KEY REFERENCES Racunari(RacunarID),
                               KomponentaID INT FOREIGN KEY REFERENCES Komponente(KomponentaID)
);

CREATE TABLE Evidencija (
                            EvidencijaID INT PRIMARY KEY IDENTITY(1,1),
                            LiceID INT FOREIGN KEY REFERENCES Lica(LiceID),
                            RacunarID INT FOREIGN KEY REFERENCES Racunari(RacunarID),
                            DatumZaduzenja DATE,
                            DatumRazduzenja DATE NULL
);

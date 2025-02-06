This Microsoft SQL Server code creates a new database for tracking computer-related inventory and assignments, using a Cyrillic case-insensitive collation to support Cyrillic characters in text fields. Let's break the code into sections for easier understanding:

### 1. **Create Database**
```sql
CREATE DATABASE EvidencijaRacunara
    COLLATE Cyrillic_General_CI_AS;
GO
```
- A new database named `EvidencijaRacunara` is created.
- The `COLLATE Cyrillic_General_CI_AS` setting specifies that the database supports Cyrillic characters (`Cyrillic_General`) in a case-insensitive (`CI`) and accent-sensitive (`AS`) manner.

---

### 2. **Set the Active Database**
```sql
USE EvidencijaRacunara;
GO
```
- This command switches the context to the newly created `EvidencijaRacunara` database, so that all subsequent commands apply to this database.

---

### 3. **Create Tables**
#### 3.1. Table: `Lica` (People)
```sql
CREATE TABLE Lica (
    LiceID INT PRIMARY KEY IDENTITY(1,1),
    Prezime NVARCHAR(50),
    Ime NVARCHAR(50),
    JMBG CHAR(13) UNIQUE
);
```
- **Purpose:** Used to store data about people.
- Columns:
    - `LiceID`: Unique identifier for each person, auto-incremented (`IDENTITY(1,1)`).
    - `Prezime`: Last name, up to 50 Unicode characters (`NVARCHAR(50)`).
    - `Ime`: First name, up to 50 Unicode characters.
    - `JMBG`: Unique 13-character string to identify individuals (e.g., a national ID number).

---

#### 3.2. Table: `TipoviRacunara` (Computer Types)
```sql
CREATE TABLE TipoviRacunara (
    TipID INT PRIMARY KEY IDENTITY(1,1),
    NazivTipa NVARCHAR(50)
);
```
- **Purpose:** Stores different types of computers (e.g., desktop, laptop).
- Columns:
    - `TipID`: Auto-incremented unique identifier for computer types.
    - `NazivTipa`: Name of the computer type (up to 50 Unicode characters).

---

#### 3.3. Table: `Komponente` (Components)
```sql
CREATE TABLE Komponente (
    KomponentaID INT PRIMARY KEY IDENTITY(1,1),
    NazivKomponente NVARCHAR(100)
);
```
- **Purpose:** Tracks hardware components (e.g., CPU, RAM, etc.).
- Columns:
    - `KomponentaID`: Auto-incremented unique identifier for each component.
    - `NazivKomponente`: Name of the component (up to 100 Unicode characters).

---

#### 3.4. Table: `Racunari` (Computers)
```sql
CREATE TABLE Racunari (
    RacunarID INT PRIMARY KEY IDENTITY(1,1),
    TipID INT FOREIGN KEY REFERENCES TipoviRacunara(TipID),
    InternaOznaka NVARCHAR(50),
    SerijskiBroj NVARCHAR(50)
);
```
- **Purpose:** Tracks individual computers.
- Columns:
    - `RacunarID`: Auto-incremented unique identifier for each computer.
    - `TipID`: Foreign key referencing the `TipID` in `TipoviRacunara` (links each computer to its type).
    - `InternaOznaka`: Internal designation for the computer (up to 50 Unicode characters).
    - `SerijskiBroj`: Serial number of the computer (up to 50 Unicode characters).

---

#### 3.5. Table: `Konfiguracija` (Configuration)
```sql
CREATE TABLE Konfiguracija (
    KonfiguracijaID INT PRIMARY KEY IDENTITY(1,1),
    RacunarID INT FOREIGN KEY REFERENCES Racunari(RacunarID),
    KomponentaID INT FOREIGN KEY REFERENCES Komponente(KomponentaID)
);
```
- **Purpose:** Maps computers to their hardware components.
- Columns:
    - `KonfiguracijaID`: Auto-incremented unique identifier for each configuration.
    - `RacunarID`: Foreign key referencing `RacunarID` in `Racunari` (links the configuration to a computer).
    - `KomponentaID`: Foreign key referencing `KomponentaID` in `Komponente` (links the configuration to a component).

---

#### 3.6. Table: `Evidencija` (Record)
```sql
CREATE TABLE Evidencija (
    EvidencijaID INT PRIMARY KEY IDENTITY(1,1),
    LiceID INT FOREIGN KEY REFERENCES Lica(LiceID),
    RacunarID INT FOREIGN KEY REFERENCES Racunari(RacunarID),
    DatumZaduzenja DATE,
    DatumRazduzenja DATE NULL
);
```
- **Purpose:** Tracks the assignment of computers to individuals.
- Columns:
    - `EvidencijaID`: Auto-incremented unique identifier for each record.
    - `LiceID`: Foreign key referencing `LiceID` in `Lica` (links the record to a person).
    - `RacunarID`: Foreign key referencing `RacunarID` in `Racunari` (links the record to a computer).
    - `DatumZaduzenja`: Date when the computer was assigned.
    - `DatumRazduzenja`: Nullable (`NULL`) date when the computer was returned.

---

### Summary of Relationships
- **People (`Lica`) are assigned to computers (`Racunari`)** using the `Evidencija` table.
- **Computers (`Racunari`) are described by their types (`TipoviRacunara`)** and can have multiple associated hardware components (`Komponente`) via the `Konfiguracija` table.

This schema supports tracking computer assignments, their configurations, and the individuals responsible for them.
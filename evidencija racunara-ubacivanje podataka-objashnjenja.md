The provided SQL script is a sequence of `INSERT` statements used to populate tables in a Microsoft SQL Server database. Here's an explanation of each part of the script:

---

### **Key Highlights:**
1. **Purpose**: Populate the database with an initial dataset, including computer types, components, people, computer configurations, and assignment records (evidence of who has used which computer).

2. **Database Structure**: The code assumes the existence of the following tables:
    - `TipoviRacunara` (types of computers)
    - `Komponente` (components)
    - `Lica` (individuals/people)
    - `Racunari` (computers)
    - `Konfiguracija` (relationships between computers and components)
    - `Evidencija` (records of computer assignments to individuals)

---

### **Step-by-Step Explanation:**

#### **1. Insert Types of Computers**
```sql
INSERT INTO TipoviRacunara (NazivTipa) VALUES ('P3'), ('P4');
```
- Inserts two types of computers into the `TipoviRacunara` table: `P3` and `P4`.
- `TipoviRacunara` likely has columns:
    - `TipID`: Primary key (likely auto-incremented).
    - `NazivTipa`: Name of the computer type.

---

#### **2. Insert Components**
```sql
INSERT INTO Komponente (NazivKomponente)
VALUES ('Монитор 14 инча'), ('Монитор 17 инча'), ('HDD 100 GB'), ('HDD 200 GB'), ('HDD 500 GB'), ('Тастатура'), ('Миш');
```
- Adds computer components into the `Komponente` table.
- Each component has a descriptive name in the `NazivKomponente` column.

---

#### **3. Insert People**
```sql
INSERT INTO Lica (Prezime, Ime, JMBG)
VALUES
    ('Тот', 'Иван', '3101975710108'),
    ('Мајић', 'Милан', '2202972710203'),
    ('Петровић', 'Јелена', '1203998710104'),
    ('Јовановић', 'Ана', '2506985710205');
```
- Populates the `Lica` table with individuals' information.
- The table likely has:
    - `LiceID`: Primary key (auto-incremented).
    - `Prezime`: Last name.
    - `Ime`: First name.
    - `JMBG`: Unique identification number (a personal ID).

---

#### **4. Insert Computers with Types**
```sql
INSERT INTO Racunari (TipID, InternaOznaka, SerijskiBroj)
SELECT T.TipID, R.InternaOznaka, R.SerijskiBroj
FROM TipoviRacunara T
         JOIN (
    VALUES
        ('P4', 'A100', '31A0E2332'),
        ('P3', 'A101', '32O54R324'),
        ('P4', 'A102', '74K53A462'),
        ('P4', 'A103', '42J35A644')
) AS R(NazivTipa, InternaOznaka, SerijskiBroj)
              ON T.NazivTipa = R.NazivTipa;
```
- Populates the `Racunari` table by:
    1. Matching the `NazivTipa` (type name) from inline data with the `TipoviRacunara` table.
    2. Inserting appropriate `TipID`, `InternaOznaka` (internal code), and `SerijskiBroj` (serial number) for each computer.

The `Racunari` table likely has:
- `RacunarID`: Primary key.
- `TipID`: Foreign key referring to `TipoviRacunara`.
- `InternaOznaka`: Internal label for the computer.
- `SerijskiBroj`: Serial number.

---

#### **5. Connect Computers with Components**
```sql
INSERT INTO Konfiguracija (RacunarID, KomponentaID)
SELECT R.RacunarID, K.KomponentaID
FROM Racunari R
         JOIN (
    VALUES
        (1, 'Монитор 17 инча'), (1, 'HDD 200 GB'), (1, 'Тастатура'),
        (2, 'Монитор 14 инча'), (2, 'HDD 100 GB'), (2, 'Тастатура'), (2, 'Миш'),
        (3, 'Монитор 17 инча'), (3, 'HDD 200 GB'), (3, 'Тастатура'),
        (4, 'Монитор 14 инча'), (4, 'HDD 500 GB'), (4, 'Тастатура')
) AS Config(RacunarID, NazivKomponente)
         JOIN Komponente K ON Config.NazivKomponente = K.NazivKomponente
              ON R.RacunarID = Config.RacunarID;
```
- Populates the `Konfiguracija` table, which links computers to their components:
    1. Matches `RacunarID` (from `Racunari`) and `KomponentaID` (from `Komponente`) using the component names.
    2. Inserts these relationships into the `Konfiguracija` table.

The `Konfiguracija` table likely stores:
- `RacunarID`: Foreign key referring to the `Racunari` table.
- `KomponentaID`: Foreign key referring to the `Komponente` table.

For example:
- Computer `1` (P4, A100) has a 17-inch monitor, a 200GB HDD, and a keyboard.

---

#### **6. Record Computer Assignments**
```sql
INSERT INTO Evidencija (LiceID, RacunarID, DatumZaduzenja, DatumRazduzenja)
VALUES
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 1, '2013-01-12', NULL),
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 2, '2014-01-12', '2014-02-01'),
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 3, '2013-01-12', NULL),
    ((SELECT LiceID FROM Lica WHERE JMBG = '2202972710203'), 4, '2013-12-20', '2014-01-31');
```
- Populates the `Evidencija` table with records of which person (`LiceID`) was assigned which computer (`RacunarID`), along with assignment (`DatumZaduzenja`) and return (`DatumRazduzenja`) dates.
- Some records have `DatumRazduzenja` as `NULL`, indicating that these computers have not yet been returned.

The `Evidencija` table likely has:
- `EvidencijaID`: Primary key.
- `LiceID`: Foreign key referring to `Lica`.
- `RacunarID`: Foreign key referring to `Racunari`.
- `DatumZaduzenja`: Date of assignment.
- `DatumRazduzenja`: Date of return (can be `NULL`).

For example:
- Person with JMBG `3101975710108` (Ivan Tot) was assigned computer `1` on 2013-01-12 and has not yet returned it.

---

### **Summary**
The script does the following:
1. Inserts predefined data into tables: types of computers, components, people.
2. Creates relationships between computers (`Racunari`), their components (`Konfiguracija`), and their assignments to people (`Evidencija`).

If you need further assistance or details about specific table structures, feel free to ask!
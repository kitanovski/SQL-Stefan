The provided SQL Server code implements various tasks for managing and querying data in a database. Let’s break each statement and its purpose in an easy-to-understand manner:

---

### **a) Retrieving the Current Number of Assigned Computers by Type for Each Person**
Understanding the query:

```sql
SELECT
    L.Prezime,
    L.Ime,
    T.NazivTipa,
    COUNT(R.RacunarID) AS BrojZaduzenihRacunara
FROM Lica L
         JOIN Evidencija E ON L.LiceID = E.LiceID
         JOIN Racunari R ON E.RacunarID = R.RacunarID
         JOIN TipoviRacunara T ON R.TipID = T.TipID
WHERE E.DatumRazduzenja IS NULL
GROUP BY L.Prezime, L.Ime, T.NazivTipa;
```

- **Goal**:
    - Show the number of computers currently assigned (`zaduzen`) to each person, grouped by the type of computer.

- **Key aspects**:
    - `E.DatumRazduzenja IS NULL`: Ensures the query only includes computers that are currently assigned (i.e., not returned yet).
    - The `JOIN` clauses link the following tables:
        - `Lica` (Persons): Provides personal details (`Ime`, `Prezime`).
        - `Evidencija` (Assignments): Tracks who the computer is assigned to.
        - `Racunari` (Computers): Represents computers currently in use.
        - `TipoviRacunara` (Computer Types): Describes the type of these computers.
    - `GROUP BY`: Groups the query results by person's last name, first name, and computer type.

---

### **b) Finding Unassigned Computers with a Specific Component (`HDD 200GB`)**
Understanding the query:

```sql
SELECT R.RacunarID, R.InternaOznaka, R.SerijskiBroj
FROM Racunari R
WHERE R.RacunarID IN (
    SELECT K.RacunarID
    FROM Konfiguracija K
             JOIN Komponente C ON K.KomponentaID = C.KomponentaID
    WHERE C.NazivKomponente = 'HDD 200 GB'
) AND R.RacunarID NOT IN (
    SELECT E.RacunarID
    FROM Evidencija E
    WHERE E.DatumRazduzenja IS NULL
);
```

- **Goal**:
    - Display computers that are *currently unassigned* and include the `HDD 200GB` component in their configuration.

- **Key aspects**:
    - The query uses two subqueries:
        1. The first subquery finds computers that include the `HDD 200GB` component (via the `Konfiguracija` and `Komponente` tables).
        2. The second subquery finds computers that are *assigned* (still in use) by checking `Evidencija` where `E.DatumRazduzenja IS NULL`.
    - Only computers (`R.RacunarID`) that satisfy both conditions (having `HDD 200GB` and not being currently assigned) are included in the output.

---

### **c) Stored Procedure for Persons Who Borrow Computers with `HDD 200GB` in a Given Month**
Understanding the procedure:

```sql
CREATE PROCEDURE LicaSaHDD200GB @Mesec INT, @Godina INT
AS
BEGIN
    SELECT DISTINCT L.Prezime, L.Ime, L.JMBG
    FROM Lica L
             JOIN Evidencija E ON L.LiceID = E.LiceID
             JOIN Racunari R ON E.RacunarID = R.RacunarID
             JOIN Konfiguracija K ON R.RacunarID = K.RacunarID
             JOIN Komponente C ON K.KomponentaID = C.KomponentaID
    WHERE C.NazivKomponente = 'HDD 200 GB'
      AND MONTH(E.DatumZaduzenja) = @Mesec
      AND YEAR(E.DatumZaduzenja) = @Godina;
END;
```

- **Goal**:
    - Retrieve the list of persons (last name, first name, and their ID `JMBG`) who borrowed (`zaduzenje`) computers with the `HDD 200GB` component during a specified month and year.

- **Key aspects**:
    - Procedure parameters:
        - `@Mesec` (Month) and `@Godina` (Year) specify the period to filter the data.
    - The query joins multiple tables to filter:
        - Persons (`Lica`), assignments (`Evidencija`), computers (`Racunari`), configurations of the computers (`Konfiguracija`), and detailed components (`Komponente`).
    - `MONTH()` and `YEAR()` functions filter the `DatumZaduzenja` (assignment date).

---

### **d) Trigger to Prevent `JMBG` Changes for Persons with Assigned Computers**
Understanding the trigger:

```sql
CREATE TRIGGER OnemoguciPromenuJMBG
    ON Lica
    INSTEAD OF UPDATE
    AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
                 JOIN deleted d ON i.LiceID = d.LiceID
        WHERE i.JMBG <> d.JMBG AND EXISTS (
            SELECT 1
            FROM Evidencija E
            WHERE E.LiceID = d.LiceID AND E.DatumRazduzenja IS NULL
        )
    )
        BEGIN
            RAISERROR('Није дозвољено мењати ЈМБГ док лице има задужене рачунаре.', 16, 1);
            ROLLBACK;
        END
    ELSE
        BEGIN
            UPDATE Lica
            SET JMBG = i.JMBG
            FROM Lica L
                     JOIN inserted i ON L.LiceID = i.LiceID;
        END
END;
```

- **Goal**:
    - Prevent updates to the `JMBG` field of a person (stored in the `Lica` table) if they currently have any assigned computers (`DatumRazduzenja IS NULL`).

- **Key aspects**:
    - `INSTEAD OF UPDATE`:
        - This trigger intercepts update operations on the `Lica` table.
    - Logic:
        - When an update is attempted, the trigger checks:
            1. If the `JMBG` field is being changed (`i.JMBG <> d.JMBG`).
            2. If the person currently has assigned computers (using the `Evidencija` table, where `DatumRazduzenja IS NULL`).
        - If both conditions are true:
            - `RAISERROR` raises an error, and the operation is rolled back.
        - Otherwise:
            - The update proceeds to alter the `JMBG`.

---

### Summary
Each part of this script is designed for specific business requirements and database integrity:

1. Query (a): Shows assigned computer counts by type per person.
2. Query (b): Identifies available computers with specific components (`HDD 200GB`).
3. Procedure (c): Lists persons who borrowed specific computers in a given month.
4. Trigger (d): Enforces data integrity by preventing `JMBG` changes if the person has currently assigned computers.
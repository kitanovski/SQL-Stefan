This query is designed to retrieve a list of computers (`RacunarID`, `InternaOznaka`, `SerijskiBroj`) from the `Racunari` table that meet certain conditions based on their configuration and usage status. Here's a detailed explanation of the code:
``` sql
SELECT RacunarID, InternaOznaka, SerijskiBroj
FROM Racunari
```
1. **Direct Columns Selected**: The query is fetching three columns from the `Racunari` table:
    - `RacunarID`: likely the unique identifier for each computer.
    - `InternaOznaka`: an internal label or mark for the computer.
    - `SerijskiBroj`: the serial number of the computer.
``` sql
WHERE RacunarID IN (
    -- Find computers that have "HDD 200 GB" in their configuration
    SELECT RacunarID
    FROM Konfiguracija
    WHERE KomponentaID = (
        SELECT KomponentaID FROM Komponente WHERE NazivKomponente = 'HDD 200 GB'
    )
)
```
1. **Filters for Specific Configuration**:
    - The subquery ensures that only computers (`RacunarID`s) whose configurations include a component named `'HDD 200 GB'` are selected.
    - It cross-references:
        - The `Konfiguracija` table, which associates computers (`RacunarID`) with specific components (`KomponentaID`).
        - The `Komponente` table, to locate the `KomponentaID` corresponding to the `'HDD 200 GB'` component.

In short, this ensures the query only includes computers equipped with an `'HDD 200 GB'` component.
``` sql
AND RacunarID NOT IN (
    -- Exclude computers that are currently assigned (DatumRazduzenja IS NULL)
    SELECT RacunarID
    FROM Evidencija
    WHERE DatumRazduzenja IS NULL
);
```
1. **Excludes Currently Assigned Computers**:
    - This part excludes any computers that are currently in use. This is determined by another subquery in the `Evidencija` table.
    - The `Evidencija` table likely tracks computer assignments, and if a computer has no `DatumRazduzenja` (date of return), it means the computer is still assigned.
    - Only computers that are not actively assigned are included in the final results.

### Summary of What the Query Does
The query retrieves a list of computers that:
1. Have `'HDD 200 GB'` in their configuration (from the `Konfiguracija` table).
2. Are not currently assigned or in use (based on the `Evidencija` table).

### Key Tables Functional Summary
- **`Racunari` **: Stores details about computers.
- **`Konfiguracija` **: Connects computers (`RacunarID`) to their components (`KomponentaID`).
- **`Komponente` **: Lists all hardware components with details like their names (`NazivKomponente`).
- **`Evidencija` **: Tracks computer assignments, including return statuses (via `DatumRazduzenja`).

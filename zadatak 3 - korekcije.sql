SELECT RacunarID, InternaOznaka, SerijskiBroj
FROM Racunari
WHERE RacunarID IN (
    -- Find computers that have "HDD 200 GB" in their configuration
    SELECT RacunarID
    FROM Konfiguracija
    WHERE KomponentaID = (
        SELECT KomponentaID FROM Komponente WHERE NazivKomponente = 'HDD 200 GB'
    )
) AND RacunarID NOT IN (
    -- Exclude computers that are currently assigned (DatumRazduzenja IS NULL)
    SELECT RacunarID
    FROM Evidencija
    WHERE DatumRazduzenja IS NULL
);

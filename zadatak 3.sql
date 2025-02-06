-- 3. За израђену базу података креирати и приказати SQL код следећих упита:

-- a) Креирати SQL наредбу која за свако лице приказује тренутни укупни број задужених рачунара по типовима.
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

-- b) Користећи искључиво подупите креирати SQL наредбу која приказује тренутно незадужене рачунаре који у својој конфигурацији имају компоненту HDD 200GB.
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

-- c) Креирати ускладиштену процедуру која за прослеђени месец враћа списак лица (презиме, име и ЈМБГ) која су у том месецу задужила рачунаре који у својој конфигурацији имају компоненту HDD 200GB.
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
GO

-- d) Креирати окидач који онемогућава промену ЈМБГ одређеног лица уколико то лице тренутно дугује неки рачунар.
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
GO

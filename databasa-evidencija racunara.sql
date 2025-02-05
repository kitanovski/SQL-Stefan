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
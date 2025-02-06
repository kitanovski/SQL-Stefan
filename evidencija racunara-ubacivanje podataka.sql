-- Убацивање почетних података
INSERT INTO TipoviRacunara (NazivTipa) VALUES ('P3'), ('P4');

INSERT INTO Komponente (NazivKomponente)
VALUES ('Монитор 14 инча'), ('Монитор 17 инча'), ('HDD 100 GB'), ('HDD 200 GB'), ('HDD 500 GB'), ('Тастатура'), ('Миш');

INSERT INTO Lica (Prezime, Ime, JMBG)
VALUES
    ('Тот', 'Иван', '3101975710108'),
    ('Мајић', 'Милан', '2202972710203'),
    ('Петровић', 'Јелена', '1203998710104'),
    ('Јовановић', 'Ана', '2506985710205');

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

INSERT INTO Evidencija (LiceID, RacunarID, DatumZaduzenja, DatumRazduzenja)
VALUES
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 1, '2013-01-12', NULL),
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 2, '2014-01-12', '2014-02-01'),
    ((SELECT LiceID FROM Lica WHERE JMBG = '3101975710108'), 3, '2013-01-12', NULL),
    ((SELECT LiceID FROM Lica WHERE JMBG = '2202972710203'), 4, '2013-12-20', '2014-01-31');
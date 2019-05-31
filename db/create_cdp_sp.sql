--use SGCasaDEApostas;
--go

use p3g6;
go


-- Stored proc to list all Booker Names
CREATE PROCEDURE cdp.ListBookerNames
AS
	SELECT Nome from cdp.casa_de_apostas;
GO

-- Stored Proc to list people who bet on a given booker 
CREATE PROCEDURE cdp.ListBettersPerBooker @Name_Booker  VARCHAR(255)
AS
	IF @Name_Booker is NULL
	BEGIN 
		PRINT 'Insert the ID of the Booker'
		RETURN 0
	END
	SELECT Primeiro_Nome, Ultimo_Nome, Telemovel, NIF  FROM cdp.apostador LEFT JOIN cdp.aposta_em ON Nome_CAP = @Name_Booker GROUP BY Primeiro_Nome, Ultimo_Nome, Telemovel, NIF;
GO
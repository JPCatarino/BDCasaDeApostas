use SGCasaDEApostas;
go

CREATE PROCEDURE cdp.ListBettersPerBooker @ID_Booker  INT 
AS
	IF @ID_Booker is NULL
	BEGIN 
		PRINT 'Insert the ID of the Booker'
		RETURN
	END
	SELECT Primeiro_Nome, Ultimo_Nome, Telemovel, NIF  FROM cdp.apostador 
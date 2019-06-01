--use SGCasaDEApostas;
use p3g6;
go


--A procedure that lists the games for a given booker
CREATE PROCEDURE cdp.ListGamesPerBooker @Name_Booker  VARCHAR(255)
AS
	IF @Name_Booker is NULL
	BEGIN 
		PRINT 'Insert the ID of the Booker'
		RETURN 0
	END
	
	--Lista as apostas
	--TODO: das apostas sacar os jogos
	SELECT ID, Descricao, Odds, DataHora FROM cdp.aposta_normal LEFT JOIN cdp.disponibiliza ON Nome_CAP = @Name_Booker GROUP BY ID, Descricao, Odds, DataHora;
GO
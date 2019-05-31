--use SGCasaDEApostas;
--go

use p3g6;
go

-- Trigger para vincular um usuário a uma casa de apostas após este realizar uma aposta, caso ainda não esteja
CREATE TRIGGER cdp.addToApostaEm ON cdp.[faz]
AFTER INSERT 
AS
	DECLARE @uCheck INT;
	DECLARE @NomeCAP VARCHAR(255);
	DECLARE @IDApostador INT;
	DECLARE @NIFApostador VARCHAR(9);
	DECLARE @EmailApostador VARCHAR(255);
	DECLARE @IDAposta INT;

	SELECT @IDApostador = ID_apostador FROM inserted;
	SELECT @NIFApostador = NIF_apostador FROM inserted;
	SELECT @EmailApostador = Email_apostador FROM inserted;
	SELECT @IDAposta = ID_aposta FROM inserted;
	SELECT @NomeCAP = Nome_CAP FROM cdp.disponibiliza WHERE ID_APOSTA = @IDAposta;
	SELECT @uCheck = NIF_apostador FROM cdp.aposta_em JOIN inserted ON NIF_APOST = NIF_apostador AND Nome_CAP = @NomeCAP;
	IF (@uCheck is null)
	BEGIN
		INSERT INTO cdp.aposta_em (Nome_CAP, ID_APOST, NIF_APOST, Email_APOST) VALUES (@NomeCAP, @IDApostador, @NIFApostador, @EmailApostador);
	END


;
GO
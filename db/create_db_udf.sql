use p3g6;
GO

CREATE SCHEMA utils;
go

-- Aux Function to check if a given parameter is not null
CREATE FUNCTION utils.IsNullOrEmpty(@toCheck VARCHAR(MAX)) RETURNS bit AS
BEGIN
IF @toCheck IS NOT NULL AND LEN(@toCheck) > 0
	BEGIN
	RETURN 0
	END
RETURN 1
END
GO

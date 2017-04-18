DROP TRIGGER CPI.GIPI_WPACK_LINE_SUBLINE_TAXDX;

CREATE OR REPLACE TRIGGER CPI.GIPI_WPACK_LINE_SUBLINE_TAXDX
BEFORE DELETE
ON CPI.GIPI_WPACK_LINE_SUBLINE FOR EACH ROW
DECLARE
BEGIN

DELETE FROM GIPI_WPOLNREP
 WHERE PAR_ID = :OLD.PAR_ID;

END;
/



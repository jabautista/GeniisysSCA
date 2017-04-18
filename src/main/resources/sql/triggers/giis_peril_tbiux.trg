DROP TRIGGER CPI.GIIS_PERIL_TBIUX;

CREATE OR REPLACE TRIGGER CPI.giis_peril_tbiux
BEFORE INSERT OR UPDATE
ON CPI.GIIS_PERIL FOR EACH ROW
/*
** Trigger to check if basc_line_cd has also value if basc_perl_cd has value and vice versa. 
*/
DECLARE
BEGIN  
  IF :NEW.basc_perl_cd IS NOT NULL AND :NEW.basc_line_cd IS NULL 
  THEN
    RAISE_APPLICATION_ERROR(-20014, 'Geniisys Exception#E#Invalid reference, basc_line_cd should have a value if basc_perl_cd has a value.');
  ELSIF :NEW.basc_line_cd IS NOT NULL AND :NEW.basc_perl_cd IS NULL
  THEN
    RAISE_APPLICATION_ERROR(-20014, 'Geniisys Exception#E#Invalid reference, basc_perl_cd should have a value if basc_line_cd has a value.');
  END IF;
END;
/



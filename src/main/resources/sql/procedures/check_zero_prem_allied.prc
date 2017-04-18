DROP PROCEDURE CPI.CHECK_ZERO_PREM_ALLIED;

CREATE OR REPLACE PROCEDURE CPI.CHECK_ZERO_PREM_ALLIED(
   p_line_cd                  GIUW_WPERILDS.line_cd%TYPE,
   p_peril_cd                 GIUW_WPERILDS.peril_cd%TYPE,
   p_tsi_amt                  GIUW_WPERILDS.tsi_amt%TYPE,
   p_prem_amt                 GIUW_WPERILDS.prem_amt%TYPE
)
AS
BEGIN
   FOR i IN(SELECT peril_type
              FROM GIIS_PERIL
             WHERE line_cd = p_line_cd
               AND peril_cd = p_peril_cd)
   LOOP
      IF i.peril_type = 'A' AND p_tsi_amt != 0 AND p_prem_amt = 0 THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot post Distribution with Allied peril(s) whose TSI is only endorsed.');
      END IF;
   END LOOP;
END;
/



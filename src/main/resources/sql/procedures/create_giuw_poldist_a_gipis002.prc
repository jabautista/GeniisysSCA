DROP PROCEDURE CPI.CREATE_GIUW_POLDIST_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Create_Giuw_Poldist_A_Gipis002
 (p_takeup_term IN VARCHAR2,
  p_no_of_takeup OUT NUMBER,
  p_yearly_tag OUT VARCHAR2) IS                  
BEGIN
  FOR b1 IN (SELECT no_of_takeup, yearly_tag
                 FROM GIIS_TAKEUP_TERM
                 WHERE takeup_term = p_takeup_term)
      LOOP
       p_no_of_takeup := b1.no_of_takeup;
        p_yearly_tag   := b1.yearly_tag;
      END LOOP;
END;
/



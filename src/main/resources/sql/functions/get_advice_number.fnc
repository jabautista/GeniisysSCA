DROP FUNCTION CPI.GET_ADVICE_NUMBER;

CREATE OR REPLACE FUNCTION CPI.Get_Advice_Number
(
  p_advice_id gicl_advice.advice_id%TYPE
) RETURN VARCHAR2
AS

/* MJ Fabroa 04/05/2013
** Function to get advice number
** Created by Ms Jen 
** DB Request: GEN-2013-56_Get_Advice_Number_C_V01_03012013
*/

  v_advice_no VARCHAR2(50);
  v_exs BOOLEAN := FALSE;
BEGIN
  FOR c IN (SELECT UPPER(line_cd||'-'||iss_cd||'-'||advice_year||'-'||LTRIM(TO_CHAR(advice_seq_no,'0000009'))) advice_no
              FROM GICL_ADVICE
             WHERE advice_id = p_advice_id)
  LOOP
     v_advice_no := c.advice_no;
     v_exs := TRUE;
     EXIT;
  END LOOP;
  IF v_exs = TRUE THEN
     RETURN(v_advice_no);
  ELSE
     RETURN(NULL);
  END IF;
END;
/



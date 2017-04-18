DROP FUNCTION CPI.CHECK_DURATION;

CREATE OR REPLACE FUNCTION CPI.Check_Duration (pdate1  IN  DATE,
                         pdate2  IN  DATE)
  RETURN NUMBER IS
  
/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : May 26, 2010
**  Reference By  : (GIPIS097 - Endorsement Item Peril Information)
**  Description   : Function that return the number of days depending on the dates inputed.
*/    
BEGIN
  IF TO_NUMBER(to_char(LAST_DAY(to_date('01-FEB-'||to_char(pdate1,'yyyy'), 'DD-MON-RRRR')),'DD'))= 29 
       AND pdate1 <= LAST_DAY(to_date('01-FEB-'||to_char(pdate1,'yyyy'), 'DD-MON-RRRR')) 
       AND pdate2 >= LAST_DAY(to_date('01-FEB-'||to_char(pdate1,'yyyy'), 'DD-MON-RRRR')) THEN
     RETURN(366);
  ELSIF TO_NUMBER(to_char(LAST_DAY(to_date('01-FEB-'||to_char(pdate2,'yyyy'), 'DD-MON-RRRR')),'DD'))= 29 
  	 AND pdate1 <= LAST_DAY(to_date('01-FEB-'||to_char(pdate2,'yyyy'), 'DD-MON-RRRR')) 
  	 AND pdate2 >= LAST_DAY(to_date('01-FEB-'||to_char(pdate2,'yyyy'), 'DD-MON-RRRR')) THEN
     RETURN(366);
  ELSE
     RETURN(365);
  END IF;
END;
/



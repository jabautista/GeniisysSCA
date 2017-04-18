CREATE OR REPLACE PACKAGE BODY CPI.GIPI_POLNREP_PKG AS

  FUNCTION get_polnrep_count (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
    RETURN NUMBER IS

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : July 15, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description  : Returns the count of policy renewal/replacement.
*/
    v_count NUMBER(1) := 0;

  BEGIN
    SELECT count(*)
      INTO v_count
      FROM gipi_polnrep a,
           gipi_polbasic b
     WHERE a.new_policy_id = b.policy_id
       AND a.old_policy_id = p_policy_id;

    RETURN v_count;
  END get_polnrep_count;
  
--  added by gab 5.11.2016 SR 21421
  FUNCTION get_latest_renew_no (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
    RETURN VARCHAR2 IS
    
    v_return VARCHAR2(1) := 'N';
    
  BEGIN
      FOR i IN (SELECT '1'
                FROM GIPI_POLNREP
                WHERE old_policy_id = p_policy_id
                AND new_policy_id IN (SELECT policy_id
                                        FROM GIPI_POLBASIC
                                       WHERE pol_flag NOT IN ('4', '5')))
      LOOP
        v_return := 'Y';
        EXIT;
      END LOOP;
                
      RETURN v_return;                     
  END;

END GIPI_POLNREP_PKG;
/



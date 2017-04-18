DROP FUNCTION CPI.CHECK_FOR_EXISTING_FRPS;

CREATE OR REPLACE FUNCTION CPI.CHECK_FOR_EXISTING_FRPS
        (p_dist_no     IN giuw_wpolicyds_dtl.dist_no%TYPE,
         p_dist_seq_no IN giuw_wpolicyds_dtl.dist_seq_no%TYPE)
         RETURN BOOLEAN IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : CHECK_FOR_EXISTING_FRPS program unit
  */
  
  FOR c1 IN (SELECT 1
               FROM giri_wdistfrps
              WHERE dist_seq_no = p_dist_seq_no
                AND dist_no     = p_dist_no)
  LOOP
    RETURN(TRUE);
  END LOOP;
  RETURN(FALSE);
END;
/



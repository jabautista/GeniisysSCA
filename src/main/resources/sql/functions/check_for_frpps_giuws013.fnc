DROP FUNCTION CPI.CHECK_FOR_FRPPS_GIUWS013;

CREATE OR REPLACE FUNCTION CPI.CHECK_FOR_FRPPS_GIUWS013
        (p_dist_no     IN giuw_wpolicyds_dtl.dist_no%TYPE,
         p_dist_seq_no IN giuw_wpolicyds_dtl.dist_seq_no%TYPE)
         RETURN VARCHAR2 IS
BEGIN
  /*
  **  Created by   : Anthony Santos
  **  Date Created : July 21, 2011
  **  Reference By : (GIUWS013
  */
  
  FOR c1 IN (SELECT 1
               FROM giri_wdistfrps
              WHERE dist_seq_no = p_dist_seq_no
                AND dist_no     = p_dist_no)
  LOOP
    RETURN 'TRUE';
  END LOOP;
  RETURN 'FALSE';
END;
/



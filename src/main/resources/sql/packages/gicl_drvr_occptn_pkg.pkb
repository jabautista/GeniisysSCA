CREATE OR REPLACE PACKAGE BODY CPI.gicl_drvr_occptn_pkg
AS
   FUNCTION drvr_occptn_list (p_find_text IN VARCHAR2)
      RETURN drvr_occptn_lov_tab PIPELINED
   IS
      v_drvr   drvr_occptn_lov_type;
   BEGIN
      FOR i IN (SELECT drvr_occ_cd, occ_desc
                  FROM gicl_drvr_occptn
                 WHERE 1 = 1
                   AND (   UPPER (occ_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                        OR UPPER (drvr_occ_cd) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                       ))
      LOOP
         v_drvr.drvr_occ_cd := i.drvr_occ_cd;
         v_drvr.occ_desc := i.occ_desc;
         PIPE ROW (v_drvr);
      END LOOP;
   END;
END gicl_drvr_occptn_pkg;
/



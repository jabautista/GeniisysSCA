CREATE OR REPLACE PACKAGE BODY CPI.giis_clm_stat_pkg
AS
   FUNCTION get_clm_stat_dtl 
      RETURN giis_clm_stat_tab PIPELINED
   IS
      v_clm   giis_clm_stat_type;
   BEGIN
      FOR i IN (SELECT   clm_stat_cd, clm_stat_desc
                    FROM giis_clm_stat
                   WHERE clm_stat_type = 'N' AND clm_stat_cd != 'NO'
                ORDER BY clm_stat_cd)
      LOOP
         v_clm.clm_stat_cd := i.clm_stat_cd;
         v_clm.clm_stat_desc := i.clm_stat_desc;
         PIPE ROW (v_clm);
      END LOOP;
   END;

   FUNCTION get_clm_desc (p_clm_stat_cd giis_clm_stat.clm_stat_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_clm_desc   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      FOR clm_desc IN (SELECT clm_stat_desc
                         FROM giis_clm_stat
                        WHERE clm_stat_cd = p_clm_stat_cd)
      LOOP
         v_clm_desc := clm_desc.clm_stat_desc;
         EXIT;
      END LOOP;

      RETURN v_clm_desc;
   END get_clm_desc;
END giis_clm_stat_pkg;
/



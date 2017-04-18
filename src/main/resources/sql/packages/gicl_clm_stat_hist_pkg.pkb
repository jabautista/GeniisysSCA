CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_stat_hist_pkg
AS
/*
  **  Created by   :  Tonio
  **  Date Created :  08.22.2011
  **  Reference By : GICLS010 Claims Basic Info
  */  
   FUNCTION get_stat_hist (p_claim_id gicl_processor_hist.claim_id%TYPE)
      RETURN gicl_clm_stat_hist_tab PIPELINED
   IS
      v_hist   gicl_clm_stat_hist_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.clm_stat_cd, b.clm_stat_desc,
                         a.user_id, a.remarks, a.clm_stat_dt
                    FROM gicl_clm_stat_hist a, giis_clm_stat b
                   WHERE a.claim_id = p_claim_id
                     AND b.clm_stat_cd = a.clm_stat_cd
                ORDER BY a.clm_stat_dt DESC)
      LOOP
         v_hist.claim_id := i.claim_id;
         v_hist.clm_stat_cd := i.clm_stat_cd;
         v_hist.user_id := i.user_id;
         v_hist.clm_stat_dt := i.clm_stat_dt;
         v_hist.remarks := i.remarks;
         v_hist.clm_stat_desc := i.clm_stat_desc;
         v_hist.dsp_clm_stat_dt := TO_CHAR(i.clm_stat_dt, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_hist);
      END LOOP;
   END get_stat_hist;
END gicl_clm_stat_hist_pkg;
/



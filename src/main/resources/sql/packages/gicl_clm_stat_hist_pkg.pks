CREATE OR REPLACE PACKAGE CPI.gicl_clm_stat_hist_pkg
IS
   TYPE gicl_clm_stat_hist_type IS RECORD (
      claim_id      gicl_clm_stat_hist.claim_id%TYPE,
      clm_stat_cd    gicl_clm_stat_hist.clm_stat_cd%TYPE,
      clm_stat_desc    giis_clm_stat.clm_stat_desc%TYPE,
      user_id       gicl_clm_stat_hist.user_id%TYPE,
      clm_stat_dt   gicl_clm_stat_hist.clm_stat_dt%TYPE,
      remarks   gicl_clm_stat_hist.remarks%TYPE,
      dsp_clm_stat_dt   VARCHAR2(200)
   );
   
   TYPE gicl_clm_stat_hist_tab IS TABLE OF gicl_clm_stat_hist_type;
   /*
  **  Created by   :  Tonio
  **  Date Created :  08.22.2011
  **  Reference By : GICLS010 Claims Basic Info
  */  

   FUNCTION get_stat_hist (p_claim_id gicl_processor_hist.claim_id%TYPE)
      RETURN gicl_clm_stat_hist_tab PIPELINED;
END gicl_clm_stat_hist_pkg;
/



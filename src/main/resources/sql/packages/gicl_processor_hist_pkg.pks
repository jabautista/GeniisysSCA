CREATE OR REPLACE PACKAGE CPI.gicl_processor_hist_pkg
IS
   TYPE gicl_processor_hist_type IS RECORD (
      claim_id      gicl_processor_hist.claim_id%TYPE,
      in_hou_adj    gicl_processor_hist.in_hou_adj%TYPE,
      user_id       gicl_processor_hist.user_id%TYPE,
      last_update   gicl_processor_hist.last_update%TYPE,
      dsp_last_update varchar2(200)
   );
   
   TYPE gicl_processor_hist_tab IS TABLE OF gicl_processor_hist_type;
   /*
  **  Created by   :  Tonio
  **  Date Created :  08.22.2011
  **  Reference By : GICLS010 Claims Basic Info
  */  

   FUNCTION get_processor_hist (p_claim_id gicl_processor_hist.claim_id%TYPE)
      RETURN gicl_processor_hist_tab PIPELINED;
END;
/



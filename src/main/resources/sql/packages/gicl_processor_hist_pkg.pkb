CREATE OR REPLACE PACKAGE BODY CPI.gicl_processor_hist_pkg
AS
/*
  **  Created by   :  Tonio
  **  Date Created :  08.22.2011
  **  Reference By : GICLS010 Claims Basic Info
  */  
   FUNCTION get_processor_hist (p_claim_id gicl_processor_hist.claim_id%TYPE)
      RETURN gicl_processor_hist_tab PIPELINED
   IS
   v_hist gicl_processor_hist_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_processor_hist
                 WHERE claim_id = p_claim_id ORDER BY last_update DESC)
      LOOP
         v_hist.claim_id := i.claim_id;
         v_hist.in_hou_adj := i.in_hou_adj;
         v_hist.user_id := i.user_id;
         v_hist.last_update := i.last_update;
         v_hist.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW(v_hist);
      END LOOP;
   END;
END;
/



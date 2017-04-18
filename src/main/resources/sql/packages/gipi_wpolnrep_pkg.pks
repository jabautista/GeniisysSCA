CREATE OR REPLACE PACKAGE CPI.Gipi_Wpolnrep_Pkg AS

  TYPE gipi_wpolnrep_type IS RECORD
    (par_id           GIPI_WPOLNREP.par_id%TYPE,      
     old_policy_id    GIPI_WPOLNREP.old_policy_id%TYPE,
     line_cd          GIPI_POLBASIC.line_cd%TYPE,
     subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
     iss_cd           GIPI_POLBASIC.iss_cd%TYPE,
     issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
     pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
     renew_no         GIPI_POLBASIC.renew_no%TYPE,
     rec_flag         GIPI_WPOLNREP.rec_flag%TYPE,
     ren_rep_sw       GIPI_WPOLNREP.ren_rep_sw%TYPE,
     expiry_date      GIPI_POLBASIC.expiry_date%TYPE);
     
     
  TYPE gipi_wpolnrep_tab IS TABLE OF gipi_wpolnrep_type;
  
  FUNCTION get_gipi_wpolnrep (p_par_id     GIPI_WPOLNREP.par_id%TYPE)
    RETURN gipi_wpolnrep_tab PIPELINED;
    
  PROCEDURE set_gipi_wpolnrep (p_par_id          IN GIPI_WPOLNREP.par_id%TYPE,
                               p_old_policy_id   IN GIPI_WPOLNREP.old_policy_id%TYPE,
                               p_pol_flag        IN GIPI_WPOLBAS.pol_flag%TYPE,
                               p_user_id         IN GIPI_WPOLNREP.user_id%TYPE); 
  
  PROCEDURE del_gipi_wpolnreps (p_par_id   GIPI_WPOLNREP.par_id%TYPE);     

  PROCEDURE del_gipi_wpolnrep (p_par_id        GIPI_WPOLNREP.par_id%TYPE,
                               p_old_policy_id GIPI_WPOLNREP.old_policy_id%TYPE);

  PROCEDURE get_gipi_wpolnrep_exist (p_par_id  IN GIPI_WPOLNREP.par_id%TYPE,
  									 p_exist   OUT NUMBER);            
  
  FUNCTION get_ongoing_wpolnrep (p_old_policy_id GIPI_WPOLNREP.old_policy_id%TYPE,
                                 p_par_id        GIPI_WPOLNREP.par_id%TYPE)
    RETURN VARCHAR2;                             
   
  PROCEDURE set_wpolnrep_sublines (
    p_pack_par_id 		  IN  GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
    p_old_pack_policy_id   IN  GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE
  );
  
  FUNCTION get_gipi_wpolnrep2(
    p_par_id     GIPI_WPOLNREP.par_id%TYPE
  )
    RETURN gipi_wpolnrep_tab PIPELINED;
                                                       
END Gipi_Wpolnrep_Pkg;
/



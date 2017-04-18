CREATE OR REPLACE PACKAGE CPI.Gipi_Pack_Wpolnrep_Pkg AS

  TYPE gipi_pack_wpolnrep_type IS RECORD
    (pack_par_id           GIPI_PACK_WPOLNREP.pack_par_id%TYPE,      
     old_pack_policy_id    GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE,
     line_cd               GIPI_PACK_POLBASIC.line_cd%TYPE,
     subline_cd            GIPI_PACK_POLBASIC.subline_cd%TYPE,
     iss_cd                GIPI_PACK_POLBASIC.iss_cd%TYPE,
     issue_yy              GIPI_PACK_POLBASIC.issue_yy%TYPE,
     pol_seq_no            GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
     renew_no              GIPI_PACK_POLBASIC.renew_no%TYPE,
     rec_flag              GIPI_PACK_WPOLNREP.rec_flag%TYPE,
     ren_rep_sw            GIPI_PACK_WPOLNREP.ren_rep_sw%TYPE,
     expiry_date           GIPI_POLBASIC.expiry_date%TYPE);
     
     
  TYPE gipi_pack_wpolnrep_tab IS TABLE OF gipi_pack_wpolnrep_type;
  
  FUNCTION get_gipi_pack_wpolnrep (p_pack_par_id     GIPI_PACK_WPOLNREP.pack_par_id%TYPE)
    RETURN gipi_pack_wpolnrep_tab PIPELINED;
    
  PROCEDURE set_gipi_pack_wpolnrep(p_pack_par_id         IN  GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
                                   p_old_pack_policy_id  IN  GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE,
                                   p_pol_flag            IN  GIPI_PACK_WPOLBAS.pol_flag%TYPE,
                                   p_user_id             IN  GIPI_PACK_WPOLNREP.user_id%TYPE); 
  
  PROCEDURE del_gipi_pack_wpolnreps (p_pack_par_id        GIPI_PACK_WPOLNREP.pack_par_id%TYPE);     

  PROCEDURE del_gipi_pack_wpolnrep (p_pack_par_id        GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
                                    p_old_pack_policy_id GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE);

  PROCEDURE get_gipi_pack_wpolnrep_exist (p_pack_par_id      IN        GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
                                          p_exist            OUT        NUMBER);
  
  FUNCTION get_ongoing_pack_wpolnrep (p_old_pack_pol_id 		GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE,
                                      p_pack_par_id         	GIPI_PACK_WPOLNREP.pack_par_id%TYPE)
    RETURN VARCHAR2;                                      
                                                       
END Gipi_Pack_Wpolnrep_Pkg;
/



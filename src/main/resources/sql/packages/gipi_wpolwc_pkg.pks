CREATE OR REPLACE PACKAGE CPI.Gipi_Wpolwc_Pkg AS

  TYPE gipi_wpolwc_type IS RECORD
    (wc_cd         GIPI_WPOLWC.wc_cd%TYPE,
     wc_sw         VARCHAR2(10),
     wc_title      VARCHAR2(2000),
     wc_title2     VARCHAR2(2000),
     wc_text1     VARCHAR2(2000),
     wc_text2     VARCHAR2(2000), 
     wc_text3     VARCHAR2(2000), 
     wc_text4     VARCHAR2(2000), 
     wc_text5     VARCHAR2(2000), 
     wc_text6     VARCHAR2(2000), 
     wc_text7     VARCHAR2(2000), 
     wc_text8     VARCHAR2(2000), 
     wc_text9     VARCHAR2(2000),
     wc_text10     VARCHAR2(2000),
     wc_text11     VARCHAR2(2000), 
     wc_text12     VARCHAR2(2000), 
     wc_text13     VARCHAR2(2000), 
     wc_text14     VARCHAR2(2000), 
     wc_text15     VARCHAR2(2000), 
     wc_text16     VARCHAR2(2000), 
     wc_text17     VARCHAR2(2000), 
     change_tag    GIPI_WPOLWC.change_tag%TYPE,
     wc_remarks    GIPI_WPOLWC.wc_remarks%TYPE,
     print_sw      GIPI_WPOLWC.print_sw%TYPE,
     print_seq_no  GIPI_WPOLWC.print_seq_no%TYPE,
     rec_flag      GIPI_WPOLWC.rec_flag%TYPE,
     line_cd       GIPI_WPOLWC.line_cd%TYPE,
     par_id        GIPI_WPOLWC.par_id%TYPE,
     swc_seq_no       GIPI_WPOLWC.swc_seq_no%TYPE);
     
  TYPE gipi_wpolwc_tab IS TABLE OF gipi_wpolwc_type;
  
  FUNCTION get_gipi_wpolwc (p_line_cd           GIPI_WPOLWC.line_cd%TYPE,
                            p_par_id            GIPI_WPOLWC.par_id%TYPE)
    RETURN gipi_wpolwc_tab PIPELINED;                        

  
  Procedure set_gipi_wpolwc (p_wpolwc           GIPI_WPOLWC%ROWTYPE);
      
  
  Procedure del_gipi_wpolwc (p_line_cd          GIPI_WPOLWC.line_cd%TYPE,
                             p_par_id           GIPI_WPOLWC.par_id%TYPE,
                             p_wc_cd            GIPI_WPOLWC.wc_cd%TYPE);    
    
  Procedure del_all_gipi_wpolwc (p_line_cd            GIPI_WPOLWC.line_cd%TYPE,
                                  p_par_id            GIPI_WPOLWC.par_id%TYPE);   
                                  
  FUNCTION get_policy_count(p_par_id         GIPI_WPOLWC.par_id%TYPE,
                                 p_line_cd        GIPI_WPOLWC.line_cd%TYPE,
                            p_wc_cd            GIPI_WPOLWC.wc_cd%TYPE,
                            p_swc_seq_no    GIPI_WPOLWC.swc_seq_no%TYPE)
    RETURN NUMBER; 
    
  FUNCTION endt_peril_wc_exists(p_par_id     GIPI_WITMPERL.par_id%TYPE,
                                p_line_cd    GIPI_WITMPERL.line_cd%TYPE,
                                p_peril_cd   GIPI_WITMPERL.peril_cd%TYPE)
    RETURN VARCHAR2;
    
  Procedure include_wc(p_par_id     GIPI_WPOLWC.par_id%TYPE,
                       p_line_cd    GIPI_WPOLWC.line_cd%TYPE,
                       p_peril_cd   GIPI_WITMPERL.peril_cd%TYPE);    
    
    Procedure DEL_GIPI_WPOLWC (p_par_id IN GIPI_WPOLWC.par_id%TYPE);
    
    FUNCTION get_gipi_wpolwc1(p_par_id       GIPI_WPOLWC.par_id%TYPE,
                               p_line_cd       GIPI_WPOLWC.line_cd%TYPE)  
         RETURN gipi_wpolwc_tab PIPELINED;
         
    FUNCTION get_default_wc_details(p_line_cd     GIPI_WPOLWC.line_cd%TYPE,
                                     p_main_wc_cd GIPI_WPOLWC.wc_cd%TYPE)
      RETURN gipi_wpolwc_tab PIPELINED;
	  
	 FUNCTION exist_wpolwc_polwc(p_line_cd     		GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd		GIPI_POLBASIC.subline_cd%TYPE,
								 p_iss_cd			GIPI_POLBASIC.iss_cd%TYPE,
								 p_issue_yy			GIPI_POLBASIC.issue_yy%TYPE,
								 p_pol_seq_no		GIPI_POLBASIC.pol_seq_no%TYPE,
								 p_wc_cd			GIPI_WPOLWC.wc_cd%TYPE,
								 p_swc_seq_no		GIPI_WPOLWC.swc_seq_no%TYPE)
      RETURN VARCHAR;

    PROCEDURE set_default_wc(
        p_par_id            GIPI_WPOLWC.par_id%TYPE,
        p_line_cd           GIPI_WPOLWC.line_cd%TYPE,
        p_peril_cd          GIIS_PERIL_CLAUSES.peril_cd%TYPE
    );
      
END Gipi_Wpolwc_Pkg;
/



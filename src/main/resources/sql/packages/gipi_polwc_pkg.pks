CREATE OR REPLACE PACKAGE CPI.GIPI_POLWC_PKG AS

  PROCEDURE update_polwc_from_openpolicy(p_policy_id	GIPI_POLWC.policy_id%TYPE,
  										 p_par_id		GIPI_WPOLWC.par_id%TYPE);
										 
  FUNCTION get_policy_count(p_policy_id		GIPI_POLWC.policy_id%TYPE)
    RETURN NUMBER;
    
    
  TYPE gipi_related_wc_info_type IS RECORD (
    
   policy_id               GIPI_POLWC.policy_id%TYPE,
   print_sw                GIPI_POLWC.print_sw%TYPE,
   print_seq_no            GIPI_POLWC.print_seq_no%TYPE,
   wc_cd                   GIPI_POLWC.wc_cd%TYPE,
   swc_seq_no              GIPI_POLWC.swc_seq_no%TYPE,
   wc_title                GIPI_POLWC.wc_title%TYPE,
   wc_title2               GIPI_POLWC.wc_title2%TYPE,
   wc_remarks              GIPI_POLWC.wc_remarks%TYPE,
   change_tag              GIPI_POLWC.change_tag%TYPE,
   wc_text01               GIPI_POLWC.wc_text01%TYPE,
   wc_text02               GIPI_POLWC.wc_text02%TYPE,
   wc_text03               GIPI_POLWC.wc_text03%TYPE,
   wc_text04               GIPI_POLWC.wc_text04%TYPE,
   wc_text05               GIPI_POLWC.wc_text05%TYPE,
   wc_text06               GIPI_POLWC.wc_text06%TYPE,
   wc_text07               GIPI_POLWC.wc_text07%TYPE,
   wc_text08               GIPI_POLWC.wc_text08%TYPE,
   wc_text09               GIPI_POLWC.wc_text09%TYPE,
   wc_text10               GIPI_POLWC.wc_text10%TYPE,
   wc_text11               GIPI_POLWC.wc_text11%TYPE,
   wc_text12               GIPI_POLWC.wc_text12%TYPE,
   wc_text13               GIPI_POLWC.wc_text13%TYPE,
   wc_text14               GIPI_POLWC.wc_text14%TYPE,
   wc_text15               GIPI_POLWC.wc_text15%TYPE,
   wc_text16               GIPI_POLWC.wc_text16%TYPE,
   wc_text17               GIPI_POLWC.wc_text17%TYPE
  );
  
  TYPE gipi_related_wc_info_tab IS TABLE OF gipi_related_wc_info_type;
  
  FUNCTION get_related_wc_info(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
     
    RETURN gipi_related_wc_info_tab PIPELINED;
    
END GIPI_POLWC_PKG;
/



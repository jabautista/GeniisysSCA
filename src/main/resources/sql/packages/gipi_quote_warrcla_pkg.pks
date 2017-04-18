CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Warrcla_Pkg AS

  TYPE gipi_quote_wc_type IS RECORD
    (quote_id            GIPI_QUOTE_WC.quote_id%TYPE,
     line_cd             GIPI_QUOTE_WC.line_cd%TYPE,
     wc_cd               GIPI_QUOTE_WC.wc_cd%TYPE,
     print_seq_no        GIPI_QUOTE_WC.print_seq_no%TYPE,
     wc_title            GIPI_QUOTE_WC.wc_title%TYPE,
     wc_text             VARCHAR2(32767),
     wc_remarks          GIPI_QUOTE_WC.wc_remarks%TYPE,
     print_sw            GIPI_QUOTE_WC.print_sw%TYPE,
     change_tag          GIPI_QUOTE_WC.change_tag%TYPE,
     user_id             GIPI_QUOTE_WC.user_id%TYPE,
     last_update         GIPI_QUOTE_WC.last_update%TYPE,
     wc_title2           GIPI_QUOTE_WC.wc_title2%TYPE,
     swc_seq_no          GIPI_QUOTE_WC.swc_seq_no%TYPE,
	 wc_sw               VARCHAR2(10));   

  TYPE gipi_quote_wc_tab IS TABLE OF gipi_quote_wc_type;
  
  TYPE gipi_quote_warrcla_type IS RECORD
    (quote_id            GIPI_QUOTE_WC.quote_id%TYPE,
     line_cd             GIPI_QUOTE_WC.line_cd%TYPE,
     wc_cd               GIPI_QUOTE_WC.wc_cd%TYPE,
     print_seq_no        GIPI_QUOTE_WC.print_seq_no%TYPE,
     wc_title            GIPI_QUOTE_WC.wc_title%TYPE,
     wc_text01           GIPI_QUOTE_WC.wc_text01%TYPE,
     wc_text02           GIPI_QUOTE_WC.wc_text02%TYPE,
     wc_text03           GIPI_QUOTE_WC.wc_text03%TYPE,
     wc_text04           GIPI_QUOTE_WC.wc_text04%TYPE,
     wc_text05           GIPI_QUOTE_WC.wc_text05%TYPE,
     wc_text06           GIPI_QUOTE_WC.wc_text06%TYPE,
     wc_text07           GIPI_QUOTE_WC.wc_text07%TYPE,
     wc_text08           GIPI_QUOTE_WC.wc_text08%TYPE,
     wc_text09           GIPI_QUOTE_WC.wc_text09%TYPE,
     wc_text10           GIPI_QUOTE_WC.wc_text10%TYPE,
     wc_text11           GIPI_QUOTE_WC.wc_text11%TYPE,
     wc_text12           GIPI_QUOTE_WC.wc_text12%TYPE,
     wc_text13           GIPI_QUOTE_WC.wc_text13%TYPE,
     wc_text14           GIPI_QUOTE_WC.wc_text14%TYPE,
     wc_text15           GIPI_QUOTE_WC.wc_text15%TYPE,
     wc_text16           GIPI_QUOTE_WC.wc_text16%TYPE,
     wc_text17           GIPI_QUOTE_WC.wc_text17%TYPE,
     wc_remarks          GIPI_QUOTE_WC.wc_remarks%TYPE,
     print_sw            GIPI_QUOTE_WC.print_sw%TYPE,
     change_tag          GIPI_QUOTE_WC.change_tag%TYPE,
     user_id             GIPI_QUOTE_WC.user_id%TYPE,
     last_update         GIPI_QUOTE_WC.last_update%TYPE,
     wc_title2           GIPI_QUOTE_WC.wc_title2%TYPE,
     swc_seq_no          GIPI_QUOTE_WC.swc_seq_no%TYPE,
	 wc_sw               VARCHAR2(10));

  TYPE gipi_quote_warrcla_tab IS TABLE OF gipi_quote_warrcla_type;

  FUNCTION get_gipi_quote_wc (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_wc_tab PIPELINED; 
	
	
  PROCEDURE set_gipi_quote_wc (p_gipi_quote_wc            IN GIPI_QUOTE_WC%ROWTYPE,
                               p_quote_id			     OUT GIPI_QUOTE.quote_id%TYPE );	
								 
  PROCEDURE del_gipi_quote_wc (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_wc_cd                     GIPI_QUOTE_WC.wc_cd%TYPE );			
							   
  PROCEDURE del_gipi_quote_wc_all (p_quote_id                  GIPI_QUOTE.quote_id%TYPE);	
  
  PROCEDURE attach_warranty(p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                            p_line_cd   GIPI_QUOTE.line_cd%TYPE,
                            p_peril_cd  GIIS_PERIL.peril_cd%TYPE);
                            
  PROCEDURE set_gipi_quote_warrcla (p_quote_id          IN       GIPI_QUOTE.quote_id%TYPE,
                                    p_gipi_quote_wc     IN       GIPI_QUOTE_WC%ROWTYPE );
                                    
  FUNCTION get_gipi_quote_warrcla (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_warrcla_tab PIPELINED; 								   					 

END Gipi_Quote_Warrcla_Pkg;
/



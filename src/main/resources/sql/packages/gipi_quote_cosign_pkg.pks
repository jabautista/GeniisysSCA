CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Cosign_Pkg AS

  TYPE gipi_quote_cosign_type IS RECORD
    (quote_id                GIPI_QUOTE_COSIGN.quote_id%TYPE,
	 cosign_id				 GIPI_QUOTE_COSIGN.cosign_id%TYPE,
	 cosign_name			 GIIS_COSIGNOR_RES.cosign_name%TYPE,
     assd_no                 GIPI_QUOTE_COSIGN.assd_no%TYPE,
	 indem_flag				 GIPI_QUOTE_COSIGN.indem_flag%TYPE,
	 bonds_flag				 GIPI_QUOTE_COSIGN.bonds_flag%TYPE,
	 bonds_ri_flag			 GIPI_QUOTE_COSIGN.bonds_ri_flag%TYPE);  							   	
							   
  TYPE gipi_quote_cosign_tab IS TABLE OF gipi_quote_cosign_type;

  FUNCTION get_gipi_quote_cosign (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
  		   						  p_assd_no	   GIIS_COSIGNOR_RES.assd_no%TYPE)
    RETURN gipi_quote_cosign_tab PIPELINED;

  FUNCTION get_gipi_quote_cosign (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_cosign_tab PIPELINED;
    
  PROCEDURE del_gipi_quote_cosign(
    p_quote_id      GIPI_QUOTE_COSIGN.quote_id%TYPE,
    p_cosign_id     GIPI_QUOTE_COSIGN.cosign_id%TYPE
    );
      
  PROCEDURE set_gipi_quote_cosign(
    p_quote_id      GIPI_QUOTE_COSIGN.quote_id%TYPE,
    p_cosign_id     GIPI_QUOTE_COSIGN.cosign_id%TYPE,
    p_assd_no       GIPI_QUOTE_COSIGN.assd_no%TYPE,
    p_indem_flag    GIPI_QUOTE_COSIGN.indem_flag%TYPE,     
    p_bonds_flag    GIPI_QUOTE_COSIGN.bonds_flag%TYPE, 
    p_bonds_ri_flag GIPI_QUOTE_COSIGN.bonds_ri_flag%TYPE
    );
        
END Gipi_Quote_Cosign_Pkg;
/



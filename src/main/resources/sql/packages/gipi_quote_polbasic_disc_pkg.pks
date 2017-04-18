CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Polbasic_Disc_Pkg AS

  TYPE gipi_quote_polbasic_disc_type IS RECORD
    (quote_id				GIPI_QUOTE_POLBASIC_DISCOUNT.quote_id%TYPE,
	 sequence				GIPI_QUOTE_POLBASIC_DISCOUNT.sequence%TYPE,
	 line_cd				GIPI_QUOTE_POLBASIC_DISCOUNT.line_cd%TYPE,	
 	 subline_cd				GIPI_QUOTE_POLBASIC_DISCOUNT.subline_cd%TYPE,
	 disc_rt				GIPI_QUOTE_POLBASIC_DISCOUNT.disc_rt%TYPE,
	 disc_amt				GIPI_QUOTE_POLBASIC_DISCOUNT.disc_amt%TYPE,
	 surcharge_amt			GIPI_QUOTE_POLBASIC_DISCOUNT.surcharge_amt%TYPE,
	 surcharge_rt			GIPI_QUOTE_POLBASIC_DISCOUNT.surcharge_rt%TYPE,
	 orig_prem_amt			GIPI_QUOTE_POLBASIC_DISCOUNT.orig_prem_amt%TYPE,
	 net_prem_amt			GIPI_QUOTE_POLBASIC_DISCOUNT.net_prem_amt%TYPE,
	 net_gross_tag			GIPI_QUOTE_POLBASIC_DISCOUNT.net_gross_tag%TYPE,
	 last_update			GIPI_QUOTE_POLBASIC_DISCOUNT.last_update%TYPE,
	 remarks				GIPI_QUOTE_POLBASIC_DISCOUNT.remarks%TYPE);
	 
  TYPE gipi_quote_polbasic_disc_tab IS TABLE OF gipi_quote_polbasic_disc_type; 
   
  FUNCTION get_gipi_quote_polbasic_disc (p_quote_id	 GIPI_QUOTE_POLBASIC_DISCOUNT.quote_id%TYPE)
    RETURN gipi_quote_polbasic_disc_tab PIPELINED;
	
  PROCEDURE set_gipi_quote_polbasic_disc (
  	 v_quote_id				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.quote_id%TYPE,
	 v_sequence				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.sequence%TYPE,
	 v_line_cd				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.line_cd%TYPE,	
 	 v_subline_cd			IN  GIPI_QUOTE_POLBASIC_DISCOUNT.subline_cd%TYPE,
	 v_disc_rt				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.disc_rt%TYPE,
	 v_disc_amt				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.disc_amt%TYPE,
	 v_surcharge_amt		IN  GIPI_QUOTE_POLBASIC_DISCOUNT.surcharge_amt%TYPE,
	 v_surcharge_rt			IN  GIPI_QUOTE_POLBASIC_DISCOUNT.surcharge_rt%TYPE,
	 v_orig_prem_amt		IN  GIPI_QUOTE_POLBASIC_DISCOUNT.orig_prem_amt%TYPE,
	 v_net_prem_amt			IN  GIPI_QUOTE_POLBASIC_DISCOUNT.net_prem_amt%TYPE,
	 v_net_gross_tag		IN  GIPI_QUOTE_POLBASIC_DISCOUNT.net_gross_tag%TYPE,	 
	 v_remarks				IN  GIPI_QUOTE_POLBASIC_DISCOUNT.remarks%TYPE);
	 
  PROCEDURE del_gipi_quote_polbasic_disc (p_quote_id  GIPI_QUOTE_POLBASIC_DISCOUNT.quote_id%TYPE,
  										  p_sequenceNo GIPI_QUOTE_POLBASIC_DISCOUNT.sequence%TYPE);	 

END Gipi_Quote_Polbasic_Disc_Pkg;
/



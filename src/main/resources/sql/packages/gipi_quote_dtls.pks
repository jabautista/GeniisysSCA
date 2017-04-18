CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Dtls AS

  TYPE gipi_quote_dtl_type IS RECORD
  (quote_id           GIPI_QUOTE.quote_id%TYPE,
   item_no            GIPI_QUOTE_ITEM.item_no%TYPE,
   item_title         GIPI_QUOTE_ITEM.item_title%TYPE,
   item_desc          GIPI_QUOTE_ITEM.item_desc%TYPE, 
   currency_cd        GIPI_QUOTE_ITEM.currency_cd%TYPE,
   currency_desc      GIIS_CURRENCY.currency_desc%TYPE,  
   currency_rate      GIPI_QUOTE_ITEM.currency_rate%TYPE,  
   coverage_cd        GIPI_QUOTE_ITEM.coverage_cd%TYPE,
   coverage_desc      GIIS_COVERAGE.coverage_desc%TYPE,
   peril_cd           GIPI_QUOTE_ITMPERIL.peril_cd%TYPE, 
   peril_name         GIIS_PERIL.peril_name%TYPE, 
   prem_rt            GIPI_QUOTE_ITMPERIL.prem_rt%TYPE, 
   tsi_amt            GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
   prem_amt           GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
   comp_rem           GIPI_QUOTE_ITMPERIL.comp_rem%TYPE,
   short_name	      GIIS_CURRENCY.short_name%TYPE,
   basic_peril_cd     GIPI_QUOTE_ITMPERIL.basic_peril_cd%TYPE,
   peril_type	      GIPI_QUOTE_ITMPERIL.peril_type%TYPE,
   ann_prem_amt	      GIPI_QUOTE_ITMPERIL.ann_prem_amt%TYPE);

  TYPE gipi_quote_dtl_tab IS TABLE OF gipi_quote_dtl_type;

  FUNCTION get_gipi_quote_dtls (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_dtl_tab PIPELINED; 
	
  PROCEDURE set_gipi_quote_dtls (p_gipi_quote_dtl           IN GIPI_QUOTE_ITMPERIL%ROWTYPE);		
								 
  PROCEDURE del_gipi_quote_dtls (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                 p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								 p_peril_cd                 GIPI_QUOTE_ITMPERIL.peril_cd%TYPE ); 				
								 
  PROCEDURE del_gipi_quote_all_dtls (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                     p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE); 		
									 
  PROCEDURE update_gipi_quote_prem(p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
  								   p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								   p_peril_cd                   GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
								   p_peril_premAmt              GIPI_QUOTE_ITMPERIL.prem_amt%TYPE);
  
  PROCEDURE set_gipi_quote_itmperil_dtls (p_peril   IN GIPI_QUOTE_ITMPERIL%ROWTYPE);
  
  FUNCTION get_quote_dtls_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_dtl_tab PIPELINED;
    
 PROCEDURE del_gipi_quote_itmperil_dtls (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                         p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								         p_peril_cd                 GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
                                         p_line_cd                  GIPI_QUOTE.line_cd%TYPE); 				
	                                 									 								 								 				 

END Gipi_Quote_Dtls;
/



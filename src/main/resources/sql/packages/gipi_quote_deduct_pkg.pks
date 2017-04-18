CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Deduct_Pkg AS

  TYPE gipi_quote_deduct_type IS RECORD
    (quote_id			 GIPI_QUOTE_DEDUCTIBLES.quote_id%TYPE,	  	 
     item_no			 GIPI_QUOTE_DEDUCTIBLES.item_no%TYPE,
	 peril_cd			 GIPI_QUOTE_DEDUCTIBLES.peril_cd%TYPE,
	 peril_name			 GIIS_PERIL.peril_name%TYPE,
	 ded_deductible_cd	 GIPI_QUOTE_DEDUCTIBLES.ded_deductible_cd%TYPE,
	 ded_type            GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
     deductible_title	 GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
	 deductible_text	 GIPI_QUOTE_DEDUCTIBLES.deductible_text%TYPE,
	 deductible_amt		 GIPI_QUOTE_DEDUCTIBLES.deductible_amt%TYPE,
	 deductible_rt  	 GIPI_QUOTE_DEDUCTIBLES.deductible_rt%TYPE,
     -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
     aggregate_sw        gipi_quote_deductibles.aggregate_sw%TYPE,
     ceiling_sw          gipi_quote_deductibles.ceiling_sw%TYPE,
     create_date         gipi_quote_deductibles.create_date%TYPE,
     create_user         gipi_quote_deductibles.create_user%TYPE,
     max_amt             gipi_quote_deductibles.max_amt%TYPE,
     min_amt             gipi_quote_deductibles.min_amt%TYPE,
     range_sw            gipi_quote_deductibles.range_sw%TYPE
     -- added nieko 02172016 end
     );
	   
  TYPE gipi_quote_deduct_tab IS TABLE OF gipi_quote_deduct_type; 
        
  FUNCTION get_gipi_quote_deduct (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED; 

  PROCEDURE set_gipi_quote_deduct (p_gipi_quote_deduct          IN GIPI_QUOTE_DEDUCTIBLES%ROWTYPE);		
	
  PROCEDURE del_gipi_quote_deduct (p_quote_id				  GIPI_QUOTE_DEDUCTIBLES.quote_id%TYPE);
  
  FUNCTION get_quote_deduct_with_tsi (p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED;
    
  PROCEDURE del_gipi_quote_deduct2 (p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                    p_peril_cd GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
                                    p_item_no  GIPI_QUOTE_DEDUCTIBLES.item_no%TYPE);
                                    
  
  PROCEDURE del_gipi_quote_deduct3 (p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                                    p_item_no   GIPI_QUOTE_DEDUCTIBLES.item_no%TYPE,
                                    p_peril_cd  GIPI_QUOTE_DEDUCTIBLES.peril_cd%TYPE,
                                    p_deduct_cd GIPI_QUOTE_DEDUCTIBLES.ded_deductible_cd%TYPE);
  
  FUNCTION get_gipi_quote_deduct_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_deduct_tab PIPELINED;  									 
		
    TYPE deductible_info_tg_type IS RECORD (
		quote_id			gipi_quote_deductibles.quote_id%TYPE,
		item_no				gipi_quote_deductibles.item_no%TYPE,
		peril_cd			gipi_quote_deductibles.peril_cd%TYPE,
        ded_deductible_cd	gipi_quote_deductibles.ded_deductible_cd%TYPE,
        deductible_text	    gipi_quote_deductibles.deductible_text%TYPE,
        deductible_amt	    gipi_quote_deductibles.deductible_amt%TYPE,
        deductible_rt	    gipi_quote_deductibles.deductible_rt%TYPE,
		deductible_title	giis_deductible_desc.deductible_title%TYPE,
		ded_type			giis_deductible_desc.ded_type%TYPE --added by steven 1/3/2013 "ded_type"
    );

    TYPE deductible_info_tg_tab IS TABLE OF deductible_info_tg_type;
    
    FUNCTION get_deductible_info_tg(
        p_quote_id 	 gipi_quote_deductibles.quote_id%TYPE,
        p_item_no	 gipi_quote_deductibles.item_no%TYPE,
        p_peril_cd	 gipi_quote_deductibles.peril_cd%TYPE,
		p_line_cd	 giis_deductible_desc.line_cd%TYPE,
		p_subline_cd giis_deductible_desc.subline_cd%TYPE
    )
        RETURN deductible_info_tg_tab PIPELINED;
      
	PROCEDURE set_deductible_info_giimm002(
		p_quote_id			IN gipi_quote_deductibles.quote_id%TYPE,
		p_item_no			IN gipi_quote_deductibles.item_no%TYPE,
		p_peril_cd			IN gipi_quote_deductibles.peril_cd%TYPE,
		p_deductible_cd		IN gipi_quote_deductibles.ded_deductible_cd%TYPE,
		p_deductible_amt	IN gipi_quote_deductibles.deductible_amt%TYPE,
		p_deductible_rt		IN gipi_quote_deductibles.deductible_rt%TYPE,
		p_deductible_text   IN gipi_quote_deductibles.deductible_text%TYPE
	);
	  									 
	PROCEDURE del_deductible_info_giimm002(
		p_quote_id			IN gipi_quote_deductibles.quote_id%TYPE,
		p_item_no			IN gipi_quote_deductibles.item_no%TYPE,
		p_peril_cd			IN gipi_quote_deductibles.peril_cd%TYPE,
		p_deductible_cd		IN gipi_quote_deductibles.ded_deductible_cd%TYPE
	);
    
    -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
    FUNCTION get_all_gipi_quote_deduct (v_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_deduct_tab PIPELINED;  
      
    FUNCTION get_item_gipi_quote_deduct (
      v_quote_id   gipi_quote.quote_id%TYPE,
      v_item_no    gipi_quote_deductibles.item_no%TYPE
    )
      RETURN gipi_quote_deduct_tab PIPELINED;

    FUNCTION get_peril_gipi_quote_deduct (
      v_quote_id   gipi_quote.quote_id%TYPE,
      v_item_no    gipi_quote_deductibles.item_no%TYPE,
      v_peril_cd   gipi_quote_deductibles.peril_cd%TYPE
    )
      RETURN gipi_quote_deduct_tab PIPELINED;
	
    PROCEDURE check_quote_deductible (
      p_quote_id           IN       gipi_quote_deductibles.quote_id%TYPE,
      p_item_no            IN       gipi_quote_deductibles.item_no%TYPE,
      p_ded_type           IN       giis_deductible_desc.ded_type%TYPE,
      p_deductible_level   IN       NUMBER,
      p_message            OUT      VARCHAR2
    );	
    
    TYPE peril_list_type IS RECORD
    (
     peril_cd   giis_peril.peril_cd%TYPE,
     peril_name giis_peril.peril_name%TYPE,
     peril_type giis_peril.peril_type%TYPE,
     tsi_amt    gipi_quote_itmperil.tsi_amt%TYPE,
     prem_amt   gipi_quote_itmperil.prem_amt%TYPE,
     item_no   gipi_quote_itmperil.prem_amt%TYPE);
   
    TYPE peril_list_tab IS TABLE OF peril_list_type;
    
    FUNCTION get_quote_itmperl_list (
     p_quote_id           IN       gipi_quote_deductibles.quote_id%TYPE
    )
    RETURN peril_list_tab PIPELINED;  
    
    
    PROCEDURE del_quote_deduct_base_tsi (
      p_quote_id   gipi_quote_deductibles.quote_id%TYPE
    );
    -- added nieko 02172016 end
END Gipi_Quote_Deduct_Pkg;
/



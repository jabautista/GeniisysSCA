CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Item_Pkg AS

  TYPE gipi_quote_item_type IS RECORD
      (quote_id			   GIPI_QUOTE_ITEM.quote_id%TYPE, 			              
	   item_no 			   GIPI_QUOTE_ITEM.item_no%TYPE,         
	   item_title		   GIPI_QUOTE_ITEM.item_title%TYPE,      
	   item_desc		   GIPI_QUOTE_ITEM.item_desc%TYPE,      
	   currency_cd		   GIPI_QUOTE_ITEM.currency_cd%TYPE,      
	   currency_rate	   GIPI_QUOTE_ITEM.currency_rate%TYPE,      
	   pack_line_cd		   GIPI_QUOTE_ITEM.pack_line_cd%TYPE,       
	   pack_subline_cd	   GIPI_QUOTE_ITEM.pack_subline_cd%TYPE,       
	   tsi_amt			   GIPI_QUOTE_ITEM.tsi_amt%TYPE,       
	   prem_amt			   GIPI_QUOTE_ITEM.prem_amt%TYPE,       
	   cpi_rec_no		   GIPI_QUOTE_ITEM.cpi_rec_no%TYPE,       
       cpi_branch_cd	   GIPI_QUOTE_ITEM.cpi_branch_cd%TYPE,       
       coverage_cd		   GIPI_QUOTE_ITEM.coverage_cd%TYPE,       
	   mc_motor_no		   GIPI_QUOTE_ITEM.mc_motor_no%TYPE,       
	   mc_plate_no		   GIPI_QUOTE_ITEM.mc_plate_no%TYPE,       
	   mc_serial_no		   GIPI_QUOTE_ITEM.mc_serial_no%TYPE,       
	   date_from		   GIPI_QUOTE_ITEM.date_from%TYPE,       
	   date_to			   GIPI_QUOTE_ITEM.date_to%TYPE,       
	   ann_prem_amt		   GIPI_QUOTE_ITEM.ann_prem_amt%TYPE,       
	   ann_tsi_amt		   GIPI_QUOTE_ITEM.ann_tsi_amt%TYPE,       
	   changed_tag		   GIPI_QUOTE_ITEM.changed_tag%TYPE,       
	   comp_sw			   GIPI_QUOTE_ITEM.comp_sw%TYPE,       
	   discount_sw		   GIPI_QUOTE_ITEM.discount_sw%TYPE,       
	   group_cd			   GIPI_QUOTE_ITEM.group_cd%TYPE,       
	   item_desc2		   GIPI_QUOTE_ITEM.item_desc2%TYPE,       
	   item_grp			   GIPI_QUOTE_ITEM.item_grp%TYPE,      
	   other_info		   GIPI_QUOTE_ITEM.other_info%TYPE,       
	   pack_ben_cd		   GIPI_QUOTE_ITEM.pack_ben_cd%TYPE,       
	   prorate_flag		   GIPI_QUOTE_ITEM.prorate_flag%TYPE,       
	   rec_flag			   GIPI_QUOTE_ITEM.rec_flag%TYPE,       
	   region_cd		   GIPI_QUOTE_ITEM.region_cd%TYPE,       
	   short_rt_percent	   GIPI_QUOTE_ITEM.short_rt_percent%TYPE,       
	   surcharge_sw		   GIPI_QUOTE_ITEM.surcharge_sw%TYPE,
	   coverage_desc	   GIIS_COVERAGE.coverage_desc%TYPE,      
	   currency_desc	   GIIS_CURRENCY.currency_desc%TYPE);

  TYPE gipi_quote_item_tab IS TABLE OF gipi_quote_item_type;
	   
  FUNCTION get_gipi_quote_item (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_item_tab PIPELINED; 
	
	
  PROCEDURE set_gipi_quote_item (p_gipi_quote_item          IN GIPI_QUOTE_ITEM%ROWTYPE);	
								 
  FUNCTION get_gipi_quote_item_by_item (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                                        p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN gipi_quote_item_tab PIPELINED; 
	
  TYPE gipi_quote_item_rep IS RECORD
    (item_no          VARCHAR(10),           
     item_title       VARCHAR(250),      
     item_desc        VARCHAR(2000),      
     currency_cd      VARCHAR(10),      
     currency_rate    VARCHAR(15),      
     coverage_cd      VARCHAR(10),       
     item_desc2       VARCHAR(2000),       
     region_cd 	      VARCHAR(10));
	 
  TYPE gipi_quote_item_rep_tab IS TABLE OF gipi_quote_item_rep;	 
	
  FUNCTION get_gipi_quote_item_report (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_item_rep_tab PIPELINED; 	
  
  PROCEDURE del_gipi_quote_item (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                                 p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE);								 

  PROCEDURE del_gipi_quote_all_items (p_quote_id    GIPI_QUOTE.quote_id%TYPE );								 

  PROCEDURE updateQuoteItemPremAmt(p_quote_id    GIPI_QUOTE.quote_id%TYPE,
  								   p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE,
								   p_prem_amt    GIPI_QUOTE.prem_amt%TYPE);
  
  FUNCTION get_gipi_quote_item_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_item_tab PIPELINED;
    
  PROCEDURE set_gipi_quote_item2
   (p_quote_id			IN		GIPI_QUOTE_ITEM.quote_id%TYPE,		
	p_item_no			IN    	GIPI_QUOTE_ITEM.item_no%TYPE,
	p_item_title		IN		GIPI_QUOTE_ITEM.item_title%TYPE,
	p_item_desc 		IN		GIPI_QUOTE_ITEM.item_desc%TYPE,		
	p_item_desc2  		IN		GIPI_QUOTE_ITEM.item_desc2%TYPE,
	p_currency_cd		IN		GIPI_QUOTE_ITEM.currency_cd%TYPE,
	p_currency_rate 	IN		GIPI_QUOTE_ITEM.currency_rate%TYPE,	
	p_coverage_cd		IN		GIPI_QUOTE_ITEM.coverage_cd%TYPE);
    
    PROCEDURE set_gipi_quote_item3 (
       p_quote_id          gipi_quote_item.quote_id%TYPE,
       p_item_no           gipi_quote_item.item_no%TYPE,
       p_prem_amt          gipi_quote_item.prem_amt%TYPE,
       p_tsi_amt           gipi_quote_item.tsi_amt%TYPE,
       p_item_title        gipi_quote_item.item_title%TYPE,
       p_item_desc         gipi_quote_item.item_desc%TYPE,
       p_item_desc2        gipi_quote_item.item_desc2%TYPE,
       p_currency_cd       gipi_quote_item.currency_cd%TYPE,
       p_currency_rate     gipi_quote_item.currency_rate%TYPE,
       p_coverage_cd       gipi_quote_item.coverage_cd%TYPE,
       p_pack_line_cd      gipi_quote_item.pack_line_cd%TYPE,
       p_pack_subline_cd   gipi_quote_item.pack_subline_cd%TYPE,
       p_date_from         gipi_quote_item.date_from%TYPE,
       p_date_to           gipi_quote_item.date_to%TYPE
    );
    
    PROCEDURE post_commit_quote_item (
       p_quote_id        gipi_quote_item.quote_id%TYPE,
       p_currency_cd     gipi_quote_item.currency_cd%TYPE,
       p_currency_rate   gipi_quote_item.currency_rate%TYPE
    );
    
    PROCEDURE del_quote_item_addl (
        p_quote_id        gipi_quote_item.quote_id%TYPE,
        p_item_no         gipi_quote_item.item_no%TYPE,
        p_currency_cd     gipi_quote_item.currency_cd%TYPE
    );
    
    FUNCTION check_gipi_quote_item_exists(
        p_quote_id      GIPI_QUOTE_ITEM.quote_id%TYPE,
        p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE
    )
      RETURN VARCHAR2;
	
    
    -- added nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
    FUNCTION quote_has_item (
        p_quote_id        gipi_quote_item.quote_id%TYPE
    )
      RETURN BOOLEAN;
      
    FUNCTION get_quote_items_wo_peril (
        p_quote_id        gipi_quote_item.quote_id%TYPE
    )
      RETURN VARCHAR2; 
      
    FUNCTION get_quote_items_currency_count (
        p_quote_id        gipi_quote_item.quote_id%TYPE
    )
      RETURN NUMBER;     
    
    FUNCTION get_quote_items_curr_rt_count (
        p_quote_id        gipi_quote_item.quote_id%TYPE
    )
      RETURN NUMBER;  
    
    FUNCTION quote_item_has_peril(
        p_quote_id        gipi_quote_item.quote_id%TYPE,
        p_item_no         gipi_quote_item.item_no%TYPE            
    )
      RETURN BOOLEAN; 
    -- added nieko 02172016  end  		 						 
END Gipi_Quote_Item_Pkg;
/



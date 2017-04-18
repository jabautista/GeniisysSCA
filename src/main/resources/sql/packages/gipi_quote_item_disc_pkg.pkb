CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Item_Disc_Pkg AS

  FUNCTION get_gipi_quote_item_disc (p_quote_id	 GIPI_QUOTE_ITEM_DISCOUNT.quote_id%TYPE--,
  		   							 --p_item_no	 GIPI_QUOTE_ITEM_DISCOUNT.item_no%TYPE
									 )
    RETURN gipi_quote_item_disc_tab PIPELINED IS

	v_discount	 gipi_quote_item_disc_type;

  BEGIN
    FOR i IN (
		SELECT quote_id,       sequence,      line_cd,       subline_cd,     item_no,
			   disc_amt, 	   disc_rt, 	  surcharge_amt, surcharge_rt,   orig_prem_amt,
			   net_prem_amt,   net_gross_tag, last_update,   remarks
		  FROM GIPI_QUOTE_ITEM_DISCOUNT
		 WHERE quote_id = p_quote_id
		   --AND item_no	= p_item_no
		 ORDER BY sequence ASC)
    LOOP
		v_discount.quote_id			:= i.quote_id;
	 	v_discount.sequence			:= i.sequence;
	 	v_discount.line_cd			:= i.line_cd;
 	 	v_discount.subline_cd		:= i.subline_cd;
		v_discount.item_no			:= i.item_no;
	 	v_discount.disc_rt			:= i.disc_rt;
	 	v_discount.disc_amt			:= i.disc_amt;
	 	v_discount.surcharge_amt	:= i.surcharge_amt;
	 	v_discount.surcharge_rt		:= i.surcharge_rt;
	 	v_discount.orig_prem_amt	:= i.orig_prem_amt;
	 	v_discount.net_prem_amt		:= i.net_prem_amt;
	 	v_discount.net_gross_tag	:= i.net_gross_tag;
	 	v_discount.last_update		:= i.last_update;
	 	v_discount.remarks			:= i.remarks;
	  PIPE ROW(v_discount);
	END LOOP;

    RETURN;
  END get_gipi_quote_item_disc;

  PROCEDURE set_gipi_quote_item_disc (
  	 v_quote_id				IN  GIPI_QUOTE_ITEM_DISCOUNT.quote_id%TYPE,
	 v_sequence				IN  GIPI_QUOTE_ITEM_DISCOUNT.sequence%TYPE,
	 v_line_cd				IN  GIPI_QUOTE_ITEM_DISCOUNT.line_cd%TYPE,
 	 v_subline_cd			IN  GIPI_QUOTE_ITEM_DISCOUNT.subline_cd%TYPE,
 	 v_item_no				IN  GIPI_QUOTE_ITEM_DISCOUNT.item_no%TYPE,
	 v_disc_rt				IN  GIPI_QUOTE_ITEM_DISCOUNT.disc_rt%TYPE,
	 v_disc_amt				IN  GIPI_QUOTE_ITEM_DISCOUNT.disc_amt%TYPE,
	 v_surcharge_amt		IN  GIPI_QUOTE_ITEM_DISCOUNT.surcharge_amt%TYPE,
	 v_surcharge_rt			IN  GIPI_QUOTE_ITEM_DISCOUNT.surcharge_rt%TYPE,
	 v_orig_prem_amt		IN  GIPI_QUOTE_ITEM_DISCOUNT.orig_prem_amt%TYPE,
	 v_net_prem_amt			IN  GIPI_QUOTE_ITEM_DISCOUNT.net_prem_amt%TYPE,
	 v_net_gross_tag		IN  GIPI_QUOTE_ITEM_DISCOUNT.net_gross_tag%TYPE,
	 v_remarks				IN  GIPI_QUOTE_ITEM_DISCOUNT.remarks%TYPE) IS

  BEGIN

   	MERGE INTO GIPI_QUOTE_ITEM_DISCOUNT
	 USING DUAL ON (quote_id    = v_quote_id
		    	   	AND item_no = v_item_no
					AND sequence = v_sequence)-- added by tonio may 20,2010 considered sequence no so that previously created values will not be overwritten.
	 WHEN NOT MATCHED THEN
		INSERT (quote_id, 		 sequence,        line_cd,        subline_cd,
				item_no, 		 disc_rt, 		  disc_amt,		  surcharge_amt,
				surcharge_rt,	 orig_prem_amt,   net_prem_amt,   net_gross_tag,
				last_update,	 remarks)
		VALUES (v_quote_id,      v_sequence,      v_line_cd,      v_subline_cd,
				v_item_no, 		 v_disc_rt,	   	  v_disc_amt,     v_surcharge_amt,
				v_surcharge_rt,	 v_orig_prem_amt, v_net_prem_amt, v_net_gross_tag,
				sysdate,		 v_remarks)
	 WHEN MATCHED THEN
	 	UPDATE SET line_cd			= v_line_cd,
 	 		   	   subline_cd		= v_subline_cd,
	 		  	   disc_rt			= v_disc_rt,
	 		  	   disc_amt			= v_disc_amt,
	 		  	   surcharge_amt	= v_surcharge_amt,
	 		  	   surcharge_rt		= v_surcharge_rt,
	 		  	   orig_prem_amt	= v_orig_prem_amt,
	 		  	   net_prem_amt		= v_net_prem_amt,
	 		  	   net_gross_tag	= v_net_gross_tag,
			  	   last_update		= sysdate,
	 		  	   remarks			= v_remarks;
  END set_gipi_quote_item_disc;

  PROCEDURE del_gipi_quote_item_disc (p_quote_id	 GIPI_QUOTE_ITEM_DISCOUNT.quote_id%TYPE,
  		   							  p_item_no	 	 GIPI_QUOTE_ITEM_DISCOUNT.item_no%TYPE) IS

  BEGIN

    DELETE FROM GIPI_QUOTE_ITEM_DISCOUNT
	 WHERE quote_id = p_quote_id
   	   AND item_no  = p_item_no;

  END del_gipi_quote_item_disc;

END Gipi_Quote_Item_Disc_Pkg;
/



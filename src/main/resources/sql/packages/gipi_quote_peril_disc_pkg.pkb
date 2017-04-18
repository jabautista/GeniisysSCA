CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Peril_Disc_Pkg AS

  FUNCTION get_gipi_quote_peril_disc (p_quote_id	 GIPI_QUOTE_PERIL_DISCOUNT.quote_id%TYPE--,
  		   							  --p_item_no		 GIPI_QUOTE_PERIL_DISCOUNT.item_no%TYPE,
									  --p_peril_cd	 GIPI_QUOTE_PERIL_DISCOUNT.peril_cd%TYPE
									  )
    RETURN gipi_quote_peril_disc_tab PIPELINED IS



	v_discount	 gipi_quote_peril_disc_type;

  BEGIN
    FOR i IN (
		SELECT a.quote_id,     a.sequence,      a.line_cd,       a.subline_cd,
			   a.item_no,	   a.peril_cd,      b.peril_name,	 a.disc_amt,
			   a.disc_rt,      a.surcharge_amt, a.surcharge_rt,  a.orig_peril_prem_amt,
			   a.net_prem_amt, a.net_gross_tag, a.last_update,   a.level_tag,
			   a.discount_tag, a.remarks
		  FROM GIPI_QUOTE_PERIL_DISCOUNT a, GIIS_PERIL b
		 WHERE a.peril_cd = b.peril_cd
		   AND a.line_cd  = b.line_cd
		   AND a.quote_id = p_quote_id
		   --AND a.item_no  = p_item_no
		   --AND a.peril_cd = p_peril_cd
		 ORDER BY sequence, item_no, peril_cd ASC)
    LOOP
		v_discount.quote_id			  	 := i.quote_id;
	 	v_discount.sequence				 := i.sequence;
	 	v_discount.line_cd				 := i.line_cd;
 	 	v_discount.subline_cd			 := i.subline_cd;
		v_discount.item_no				 := i.item_no;
		v_discount.peril_cd				 := i.peril_cd;
		v_discount.peril_name			 := i.peril_name;
	 	v_discount.disc_rt				 := i.disc_rt;
	 	v_discount.disc_amt				 := i.disc_amt;
	 	v_discount.surcharge_amt		 := i.surcharge_amt;
	 	v_discount.surcharge_rt			 := i.surcharge_rt;
	 	v_discount.orig_peril_prem_amt	 := i.orig_peril_prem_amt;
	 	v_discount.net_prem_amt			 := i.net_prem_amt;
	 	v_discount.net_gross_tag		 := i.net_gross_tag;
	 	v_discount.level_tag			 := i.level_tag;
		v_discount.discount_tag			 := i.discount_tag;
	 	v_discount.last_update			 := i.last_update;
	 	v_discount.remarks				 := i.remarks;
	  PIPE ROW(v_discount);
	END LOOP;

    RETURN;
  END get_gipi_quote_peril_disc;

  PROCEDURE set_gipi_quote_peril_disc (
  	 v_quote_id				IN  GIPI_QUOTE_PERIL_DISCOUNT.quote_id%TYPE,
	 v_sequence				IN  GIPI_QUOTE_PERIL_DISCOUNT.sequence%TYPE,
	 v_line_cd				IN  GIPI_QUOTE_PERIL_DISCOUNT.line_cd%TYPE,
 	 v_subline_cd			IN  GIPI_QUOTE_PERIL_DISCOUNT.subline_cd%TYPE,
 	 v_item_no				IN  GIPI_QUOTE_PERIL_DISCOUNT.item_no%TYPE,
 	 v_peril_cd				IN  GIPI_QUOTE_PERIL_DISCOUNT.peril_cd%TYPE,
	 v_disc_rt				IN  GIPI_QUOTE_PERIL_DISCOUNT.disc_rt%TYPE,
	 v_disc_amt				IN  GIPI_QUOTE_PERIL_DISCOUNT.disc_amt%TYPE,
	 v_surcharge_amt		IN  GIPI_QUOTE_PERIL_DISCOUNT.surcharge_amt%TYPE,
	 v_surcharge_rt			IN  GIPI_QUOTE_PERIL_DISCOUNT.surcharge_rt%TYPE,
	 v_orig_peril_prem_amt	IN  GIPI_QUOTE_PERIL_DISCOUNT.orig_peril_prem_amt%TYPE,
	 v_net_prem_amt			IN  GIPI_QUOTE_PERIL_DISCOUNT.net_prem_amt%TYPE,
	 v_net_gross_tag		IN  GIPI_QUOTE_PERIL_DISCOUNT.net_gross_tag%TYPE,
	 v_level_tag			IN	GIPI_QUOTE_PERIL_DISCOUNT.level_tag%TYPE,
	 v_discount_tag			IN	GIPI_QUOTE_PERIL_DISCOUNT.discount_tag%TYPE,
	 v_remarks				IN  GIPI_QUOTE_PERIL_DISCOUNT.remarks%TYPE) IS

  BEGIN

	MERGE INTO GIPI_QUOTE_PERIL_DISCOUNT
	 USING DUAL ON (quote_id 	 = v_quote_id
		    	    AND item_no	 = v_item_no
		   			AND peril_cd = v_peril_cd
                    AND sequence = v_sequence)
	 WHEN NOT MATCHED THEN
	   	  INSERT (quote_id, 	   sequence,       line_cd,               subline_cd,
				  item_no, 		   peril_cd, 	   disc_rt, 		 	  disc_amt,
				  surcharge_amt,   surcharge_rt,   orig_peril_prem_amt,   net_prem_amt,
				  net_gross_tag,   level_tag,      discount_tag, 	 	  last_update,
				  remarks)
		  VALUES (v_quote_id,      v_sequence,     v_line_cd,             v_subline_cd,
				  v_item_no, 	   v_peril_cd,     v_disc_rt,	   	  	  v_disc_amt,
				  v_surcharge_amt, v_surcharge_rt, v_orig_peril_prem_amt, v_net_prem_amt,
				  v_net_gross_tag, v_level_tag,    v_discount_tag, 		  sysdate,
				  v_remarks)
	 WHEN MATCHED THEN
	 	  UPDATE SET line_cd			   = v_line_cd,
		  	  	 	 subline_cd		   	   = v_subline_cd,
			  		 --sequence			   = v_sequence,
	 		  		 disc_rt			   = v_disc_rt,
	 		  		 disc_amt			   = v_disc_amt,
	 		  		 surcharge_amt		   = v_surcharge_amt,
	 		  		 surcharge_rt		   = v_surcharge_rt,
	 		 		 orig_peril_prem_amt   = v_orig_peril_prem_amt,
	 		  		 net_prem_amt		   = v_net_prem_amt,
	 		  		 net_gross_tag		   = v_net_gross_tag,
			  		 level_tag			   = v_level_tag,
			  		 discount_tag		   = v_discount_tag,
			  		 last_update		   = sysdate,
	 		  		 remarks			   = v_remarks;
  END set_gipi_quote_peril_disc;

  PROCEDURE del_gipi_quote_peril_disc (p_quote_id	 GIPI_QUOTE_PERIL_DISCOUNT.quote_id%TYPE,
  		   							   p_item_no	 GIPI_QUOTE_PERIL_DISCOUNT.item_no%TYPE,
									   p_peril_cd	 GIPI_QUOTE_PERIL_DISCOUNT.peril_cd%TYPE) IS

  BEGIN

	DELETE FROM GIPI_QUOTE_PERIL_DISCOUNT
	 WHERE quote_id = p_quote_id
	   AND item_no	= P_item_no
	   AND peril_cd = p_peril_cd;

  END del_gipi_quote_peril_disc;

END Gipi_Quote_Peril_Disc_Pkg;
/



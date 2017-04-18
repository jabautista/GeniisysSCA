CREATE OR REPLACE PACKAGE BODY CPI.giac_bank_dep_slip_dtl_pkg
AS
  
  /*
  **  Created by   :  Emman
  **  Date Created :  03.24.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Fetches the list of GBDSD block records in GIACS035
  */
  FUNCTION get_gbdsd_list (p_dep_id			GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
  		   				   p_dep_no			GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE)
	RETURN gbdsd_list_tab PIPELINED
  IS
    v_gbdsd_list		  gbdsd_list_type;
  BEGIN
    FOR i IN (SELECT gbdsd.dep_id, gbdsd.dep_no, gbdsd.currency_cd, gbdsd.bank_cd,
				     gbdsd.or_pref, gbdsd.check_no, gibn.bank_sname || ' - ' || gbdsd.check_no dsp_check_no,
				   	 gbdsd.payor, gbdsd.or_no, gbdsd.or_pref || ' - ' || gbdsd.or_no dsp_or_pref_suf,
				   	 gbdsd.amount, gcur.short_name currency_short_name, gbdsd.foreign_curr_amt,
				   	 gbdsd.currency_rt, gbdsd.bounce_tag, gbdsd.otc_tag, gbdsd.local_sur,
				   	 gbdsd.foreign_sur, gbdsd.net_colln_amt, gbdsd.error_tag, gbdsd.book_tag,
				   	 gbdsd.deposited_amt, gbdsd.loc_error_amt
			    FROM GIAC_BANK_DEP_SLIP_DTL gbdsd, GIAC_BANKS gibn, GIIS_CURRENCY gcur
			   WHERE gbdsd.dep_id	   = p_dep_id
			     AND gbdsd.dep_no	   = NVL(p_dep_no, gbdsd.dep_no)
			     AND gbdsd.bank_cd 	   = gibn.bank_cd
			     AND gbdsd.currency_cd = gcur.main_currency_cd (+))
	LOOP
		v_gbdsd_list.dep_id		   	  		 := i.dep_id;
	    v_gbdsd_list.dep_no					 := i.dep_no;
	    v_gbdsd_list.currency_cd			 := i.currency_cd;
	    v_gbdsd_list.bank_cd				 := i.bank_cd;
	    v_gbdsd_list.or_pref				 := i.or_pref;
	    v_gbdsd_list.check_no				 := i.check_no;
	    v_gbdsd_list.dsp_check_no			 := i.dsp_check_no;
	    v_gbdsd_list.payor					 := i.payor;
	    v_gbdsd_list.or_no					 := i.or_no;
	    v_gbdsd_list.dsp_or_pref_suf		 := i.dsp_or_pref_suf;
	    v_gbdsd_list.amount					 := i.amount;
	    v_gbdsd_list.currency_short_name	 := i.currency_short_name;
	    v_gbdsd_list.foreign_curr_amt		 := i.foreign_curr_amt;
	    v_gbdsd_list.currency_rt			 := i.currency_rt;
	    v_gbdsd_list.bounce_tag				 := i.bounce_tag;
	    v_gbdsd_list.otc_tag				 := i.otc_tag;
	    v_gbdsd_list.local_sur				 := i.local_sur;
	    v_gbdsd_list.foreign_sur			 := i.foreign_sur;
	    v_gbdsd_list.net_colln_amt			 := i.net_colln_amt;
	    v_gbdsd_list.error_tag				 := i.error_tag;
	    v_gbdsd_list.book_tag				 := i.book_tag;
	    v_gbdsd_list.deposited_amt			 := i.deposited_amt;
	    v_gbdsd_list.loc_error_amt			 := i.loc_error_amt;
	
		PIPE ROW(v_gbdsd_list);
	END LOOP;
  END get_gbdsd_list;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  03.28.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Gets the loc error amt for ERROR block in GIACS035 (Close DCB)
  */
  FUNCTION get_loc_error_amt (p_dep_id		GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
  		   					  p_dep_no		GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
							  p_bank_cd		GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
							  p_check_no	GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
							  p_or_pref		GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
							  p_or_no		GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE)
	RETURN VARCHAR2 --GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE
  IS
  	v_loc_error_amt			  GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE := NULL;
	v_loc_char				  VARCHAR2(20) := '';
  BEGIN
    FOR c in (SELECT loc_error_amt
                FROM giac_bank_dep_slip_dtl
               WHERE dep_id = p_dep_id
                 AND dep_no = p_dep_no
                 AND bank_cd = p_bank_cd
                 AND check_no = p_check_no
                 AND or_pref = p_or_pref
                 AND or_no = p_or_no) 
    LOOP
      v_loc_error_amt := c.loc_error_amt;
	  v_loc_char := TO_CHAR(v_loc_error_amt);
    END LOOP;
    
	RETURN v_loc_char;
  END get_loc_error_amt;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  03.28.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Gets the local_surcharge, foreign_surcharge and net_colln_amt of the check that has OTC
  */
  FUNCTION get_otc_surcharge(p_gacc_tran_id GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
  		   					 p_dcb_no		GIAC_DCB_BANK_DEP.dcb_no%TYPE,
							 p_item_no		GIAC_DCB_BANK_DEP.item_no%TYPE)
	RETURN otc_surcharge_tab PIPELINED
  IS
    v_otc_sur				 otc_surcharge_type;
  BEGIN
    FOR i IN (SELECT local_sur, foreign_sur, net_colln_amt
	            FROM giac_bank_dep_slip_dtl
	           WHERE dep_id IN(SELECT dep_id
	                             FROM giac_bank_dep_slips
	                            WHERE gacc_tran_id = p_gacc_tran_id
	            	              AND dcb_no = p_dcb_no
	              	              AND item_no = p_item_no)        
	              	              AND otc_tag = 'Y')
	LOOP
		v_otc_sur.local_sur		  := i.local_sur;
		v_otc_sur.foreign_sur	  := i.foreign_sur;
		v_otc_sur.net_colln_amt	  := i.net_colln_amt;
	END LOOP;
	
	PIPE ROW(v_otc_sur); -- pipe row outside the loop, to get only the last record
  END get_otc_surcharge;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  03.24.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Fetches the list of GBDSD block records in GIACS035 by tran_id
  */
  FUNCTION get_gbdsd_list_by_tran_id (p_gacc_tran_id			GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE)
	RETURN gbdsd_list_tab PIPELINED
  IS
    v_gbdsd_list		  gbdsd_list_type;
  BEGIN
    FOR i IN (SELECT gbdsd.dep_id, gbdsd.dep_no, gbdsd.currency_cd, gbdsd.bank_cd,
				     gbdsd.or_pref, gbdsd.check_no, gibn.bank_sname || ' - ' || gbdsd.check_no dsp_check_no,
				   	 gbdsd.payor, gbdsd.or_no, gbdsd.or_pref || ' - ' || gbdsd.or_no dsp_or_pref_suf,
				   	 gbdsd.amount, gcur.short_name currency_short_name, gbdsd.foreign_curr_amt,
				   	 gbdsd.currency_rt, gbdsd.bounce_tag, gbdsd.otc_tag, gbdsd.local_sur,
				   	 gbdsd.foreign_sur, gbdsd.net_colln_amt, gbdsd.error_tag, gbdsd.book_tag,
				   	 gbdsd.deposited_amt, gbdsd.loc_error_amt
			    FROM GIAC_BANK_DEP_SLIP_DTL gbdsd, GIAC_BANKS gibn, GIIS_CURRENCY gcur, GIAC_BANK_DEP_SLIPS gbds
			   WHERE gbds.gacc_tran_id = p_gacc_tran_id
			     AND gbdsd.dep_id	   = gbds.dep_id
			     AND gbdsd.bank_cd 	   = gibn.bank_cd
			     AND gbdsd.currency_cd = gcur.main_currency_cd (+))
	LOOP
		v_gbdsd_list.dep_id		   	  		 := i.dep_id;
	    v_gbdsd_list.dep_no					 := i.dep_no;
	    v_gbdsd_list.currency_cd			 := i.currency_cd;
	    v_gbdsd_list.bank_cd				 := i.bank_cd;
	    v_gbdsd_list.or_pref				 := i.or_pref;
	    v_gbdsd_list.check_no				 := i.check_no;
	    v_gbdsd_list.dsp_check_no			 := i.dsp_check_no;
	    v_gbdsd_list.payor					 := i.payor;
	    v_gbdsd_list.or_no					 := i.or_no;
	    v_gbdsd_list.dsp_or_pref_suf		 := i.dsp_or_pref_suf;
	    v_gbdsd_list.amount					 := i.amount;
	    v_gbdsd_list.currency_short_name	 := i.currency_short_name;
	    v_gbdsd_list.foreign_curr_amt		 := i.foreign_curr_amt;
	    v_gbdsd_list.currency_rt			 := i.currency_rt;
	    v_gbdsd_list.bounce_tag				 := i.bounce_tag;
	    v_gbdsd_list.otc_tag				 := i.otc_tag;
	    v_gbdsd_list.local_sur				 := i.local_sur;
	    v_gbdsd_list.foreign_sur			 := i.foreign_sur;
	    v_gbdsd_list.net_colln_amt			 := i.net_colln_amt;
	    v_gbdsd_list.error_tag				 := i.error_tag;
	    v_gbdsd_list.book_tag				 := i.book_tag;
	    v_gbdsd_list.deposited_amt			 := i.deposited_amt;
	    v_gbdsd_list.loc_error_amt			 := i.loc_error_amt;
	
		PIPE ROW(v_gbdsd_list);
	END LOOP;
  END get_gbdsd_list_by_tran_id;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  05.03.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Update GIAC_BANK_DEP_SLIP_DTL in OTC return button
  **  			     to delete the local_sur,foreign_sur and net_colln_amt of non-OTC checks
  */
  PROCEDURE update_gbdsd_in_otc(p_dep_id    GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE)
  IS
  BEGIN
  	   UPDATE giac_bank_dep_slip_dtl
         SET local_sur = NULL 
       WHERE dep_id = p_dep_id
         AND  otc_tag = 'N';
  
      UPDATE giac_bank_dep_slip_dtl
         SET foreign_sur = NULL
       WHERE dep_id = p_dep_id
         AND  otc_tag = 'N';
    
      UPDATE giac_bank_dep_slip_dtl
         SET net_colln_amt = NULL
       WHERE dep_id = p_dep_id
         AND  otc_tag = 'N';
  END update_gbdsd_in_otc;
  
  PROCEDURE set_giac_bank_dep_slip_dtl(p_dep_id		   	  		 GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
									   p_dep_no					 GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
									   p_currency_cd			 GIAC_BANK_DEP_SLIP_DTL.currency_cd%TYPE,
									   p_bank_cd				 GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
									   p_or_pref				 GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
									   p_check_no				 GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
									   p_payor					 GIAC_BANK_DEP_SLIP_DTL.payor%TYPE,
									   p_or_no					 GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE,
									   p_amount					 GIAC_BANK_DEP_SLIP_DTL.amount%TYPE,
									   p_foreign_curr_amt		 GIAC_BANK_DEP_SLIP_DTL.foreign_curr_amt%TYPE,
									   p_currency_rt			 GIAC_BANK_DEP_SLIP_DTL.currency_rt%TYPE,
									   p_bounce_tag				 GIAC_BANK_DEP_SLIP_DTL.bounce_tag%TYPE,
									   p_otc_tag				 GIAC_BANK_DEP_SLIP_DTL.otc_tag%TYPE,
									   p_local_sur				 GIAC_BANK_DEP_SLIP_DTL.local_sur%TYPE,
									   p_foreign_sur			 GIAC_BANK_DEP_SLIP_DTL.foreign_sur%TYPE,
									   p_net_colln_amt			 GIAC_BANK_DEP_SLIP_DTL.net_colln_amt%TYPE,
									   p_error_tag				 GIAC_BANK_DEP_SLIP_DTL.error_tag%TYPE,
									   p_book_tag				 GIAC_BANK_DEP_SLIP_DTL.book_tag%TYPE,
									   p_deposited_amt			 GIAC_BANK_DEP_SLIP_DTL.deposited_amt%TYPE,
									   p_loc_error_amt			 GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE)
  IS
  BEGIN
  	   MERGE INTO GIAC_BANK_DEP_SLIP_DTL
	   USING DUAL ON (dep_id		   	  	 = dep_id
 				  AND dep_no				 = dep_no
 				  AND bank_cd				 = bank_cd
 				  AND check_no				 = check_no
 				  AND or_pref				 = or_pref
 				  AND or_no					 = or_no)
	   WHEN NOT MATCHED THEN
		   INSERT (dep_id,       dep_no,      	 currency_cd,      	 bank_cd,
		   		   or_pref, 	  check_no,	 	 payor,			 	 or_no,
				   amount,	  	  foreign_curr_amt, currency_rt, 	 bounce_tag,
				   otc_tag,	  	  local_sur,     foreign_sur,		 net_colln_amt,
				   error_tag,	  book_tag,	 	 deposited_amt,	 	 loc_error_amt)
		   VALUES (p_dep_id,      p_dep_no,      p_currency_cd,      p_bank_cd,
		   		   p_or_pref, 	  p_check_no,	 p_payor,			 p_or_no,
				   p_amount,	  p_foreign_curr_amt, p_currency_rt, p_bounce_tag,
				   p_otc_tag,	  p_local_sur,   p_foreign_sur,		 p_net_colln_amt,
				   p_error_tag,	  p_book_tag,	 p_deposited_amt,	 p_loc_error_amt)
	   WHEN MATCHED THEN
	   		UPDATE SET currency_cd				 = p_currency_cd,
					   payor					 = p_payor,
					   amount					 = p_amount,
					   foreign_curr_amt			 = p_foreign_curr_amt,
					   currency_rt				 = p_currency_rt,
					   bounce_tag				 = p_bounce_tag,
					   otc_tag					 = p_otc_tag,
					   local_sur				 = p_local_sur,
					   foreign_sur				 = p_foreign_sur,
					   net_colln_amt			 = p_net_colln_amt,
					   error_tag				 = p_error_tag,
					   book_tag					 = p_book_tag,
					   deposited_amt			 = p_deposited_amt,
					   loc_error_amt			 = p_loc_error_amt;
  END set_giac_bank_dep_slip_dtl;
  
  PROCEDURE del_giac_bank_dep_slip_dtl(p_dep_id		   	  		 GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
									   p_dep_no					 GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
									   p_bank_cd				 GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
									   p_check_no				 GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
									   p_or_pref				 GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
									   p_or_no					 GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE)
  IS
  BEGIN
  	   DELETE GIAC_BANK_DEP_SLIP_DTL
	    WHERE dep_id		= p_dep_id
		  AND dep_no		= p_dep_no
		  AND bank_cd		= p_bank_cd
		  AND check_no		= p_check_no
		  AND or_pref		= p_or_pref
		  AND or_no			= p_or_no;
  END del_giac_bank_dep_slip_dtl;

END giac_bank_dep_slip_dtl_pkg;
/



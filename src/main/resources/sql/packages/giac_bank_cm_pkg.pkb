CREATE OR REPLACE PACKAGE BODY CPI.giac_bank_cm_pkg
AS

  FUNCTION get_locm_list(p_gacc_tran_id			GIAC_BANK_CM.gacc_tran_id%TYPE,
  		   				 p_item_no				GIAC_BANK_CM.item_no%TYPE)
	RETURN locm_list_tab PIPELINED
  IS
    v_locm 				 locm_list_type;
  BEGIN
    FOR i IN (SELECT gbcm.gacc_tran_id, gbcm.fund_cd, gbcm.branch_cd,
				     gbcm.or_pref || ' - ' || gbcm.or_no dsp_or_pref_suf,
				   	 gbcm.dcb_no, gbcm.currency_cd, gbcm.or_pref, gbcm.dcb_year,
				   	 gbcm.item_no, gbcm.or_no, gbcm.payor, gbcm.validation_dt,
				   	 gcur.short_name currency_short_name, gbcm.amount,
				   	 gbcm.foreign_curr_amt, gbcm.currency_rt
			    FROM GIAC_BANK_CM gbcm, GIIS_CURRENCY gcur
			   WHERE gbcm.gacc_tran_id = p_gacc_tran_id
			     AND gbcm.item_no		 = p_item_no
			     AND gbcm.currency_cd  = gcur.main_currency_cd)
	LOOP
		v_locm.gacc_tran_id	  	 		:= i.gacc_tran_id;
	    v_locm.fund_cd					:= i.fund_cd;
	    v_locm.branch_cd				:= i.branch_cd;
	    v_locm.dsp_or_pref_suf			:= i.dsp_or_pref_suf;
	    v_locm.dcb_no					:= i.dcb_no;
	    v_locm.currency_cd				:= i.currency_cd;
	    v_locm.or_pref					:= i.or_pref;
	    v_locm.dcb_year					:= i.dcb_year;
	    v_locm.item_no					:= i.item_no;
	    v_locm.or_no					:= i.or_no;
	    v_locm.payor					:= i.payor;
	    v_locm.validation_dt			:= i.validation_dt;
	    v_locm.currency_short_name		:= i.currency_short_name;
	    v_locm.amount					:= i.amount;
	    v_locm.foreign_curr_amt			:= i.foreign_curr_amt;
	    v_locm.currency_rt				:= i.currency_rt;
	
		PIPE ROW(v_locm);
	END LOOP;
  END;

END giac_bank_cm_pkg;
/



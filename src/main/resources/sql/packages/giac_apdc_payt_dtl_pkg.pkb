CREATE OR REPLACE PACKAGE BODY CPI.giac_apdc_payt_dtl_pkg
AS
  
  FUNCTION get_or_flag_for_apdc_payt_dtl(p_gacc_tran_id  GIAC_APDC_PAYT_DTL.gacc_tran_id%TYPE)
  RETURN VARCHAR2
  IS
    v_or_flag VARCHAR2(1) := NULL;
  BEGIN
     FOR c IN (SELECT DISTINCT c.gacc_tran_id, c.or_flag
                 FROM giac_direct_prem_collns a, 
                      giac_apdc_payt_dtl b, 
                      giac_order_of_payts c 
                WHERE a.gacc_tran_id (+) = b.gacc_tran_id 
                            AND b.gacc_tran_id = c.gacc_tran_id
                            AND b.gacc_tran_id = p_gacc_tran_id
                            AND b.pdc_id > 0)
        
     LOOP
       v_or_flag := c.or_flag;      			
  	 END LOOP;
     RETURN v_or_flag;
  END get_or_flag_for_apdc_payt_dtl;


  FUNCTION get_giac_apdc_payt_dtl(
  	   p_apdc_id				   giac_apdc_payt_dtl.APDC_ID%TYPE
  )RETURN giac_apdc_payt_dtl_tab PIPELINED
  
  IS
  	v_giac_apdc_payt_dtl		giac_apdc_payt_dtl_type;
  
  BEGIN
  	   FOR gapd IN (SELECT a.apdc_id, 	   a.pdc_id, 	 		 a.item_no, 	   a.bank_cd, 			   b.bank_name, 
	   	   		   		   b.bank_sname,   a.check_class, 		 f.rv_meaning check_class_desc,             a.check_no, 	   
                           a.check_date,   a.check_amt, 	    a.currency_cd,      c.short_name currency_name,		   	   
                           c.currency_desc,		   a.currency_rt,		   
						   a.fcurrency_amt,a.tin,		        a.check_flag,   		 d.rv_meaning check_status,				   a.user_id,
	   					   a.gacc_tran_id, a.last_update,		 a.gross_amt, 	   a.commission_amt,	   a.vat_amt,
	   					   a.fc_gross_amt, a.fc_tax_amt,		 a.replace_date,   a.pay_mode,			   a.intm_no,
	   					   a.dcb_no,	   a.bank_branch,		 a.remarks, 	   a.payor,				   a.address_1,	   a.address_2,
						   a.address_3,	   e.intm_name intermediary,			   a.particulars
  					  FROM giac_apdc_payt_dtl a
                          ,giac_banks b
                          ,giis_currency c
                          ,cg_ref_codes d
                          ,giis_intermediary e
                          ,cg_ref_codes f
	   				 WHERE apdc_id = p_apdc_id 
                       AND a.bank_cd = b.bank_cd
	     			   AND a.check_flag = d.rv_low_value
					   AND a.intm_no = e.intm_no (+)
		 			   AND d.rv_domain = 'GIAC_APDC_PAYT_DTL.CHECK_FLAG'
	     			   AND a.currency_cd = c.main_currency_cd (+)
                       AND a.check_class = f.rv_low_value
	     			   AND f.rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_CLASS'
				  ORDER BY item_no
	   )
	   LOOP 
	   		v_giac_apdc_payt_dtl.apdc_id	  				 := gapd.apdc_id;
			v_giac_apdc_payt_dtl.pdc_id		  				 := gapd.pdc_id;
			v_giac_apdc_payt_dtl.item_no	  				 := gapd.item_no;
			v_giac_apdc_payt_dtl.bank_cd	  				 := gapd.bank_cd;
			v_giac_apdc_payt_dtl.bank_name	  				 := gapd.bank_name;
			v_giac_apdc_payt_dtl.bank_sname	  				 := gapd.bank_sname;
			v_giac_apdc_payt_dtl.check_class  				 := gapd.check_class;
            v_giac_apdc_payt_dtl.check_class_desc			 := gapd.check_class_desc;
			v_giac_apdc_payt_dtl.check_no	  				 := gapd.check_no;
			v_giac_apdc_payt_dtl.check_date	  				 := gapd.check_date;
			v_giac_apdc_payt_dtl.check_amt	  				 := gapd.check_amt;
			v_giac_apdc_payt_dtl.currency_cd  				 := gapd.currency_cd;
			v_giac_apdc_payt_dtl.currency_desc				 := gapd.currency_desc;
			v_giac_apdc_payt_dtl.currency_name				 := gapd.currency_name;
			v_giac_apdc_payt_dtl.currency_rt				 := gapd.currency_rt;
			v_giac_apdc_payt_dtl.fcurrency_amt				 := gapd.fcurrency_amt;
			v_giac_apdc_payt_dtl.payor				   		 := gapd.payor;
		   	v_giac_apdc_payt_dtl.address_1			   		 := gapd.address_1;
	        v_giac_apdc_payt_dtl.address_2			   		 := gapd.address_2;
	        v_giac_apdc_payt_dtl.address_3			   		 := gapd.address_3;
	   		v_giac_apdc_payt_dtl.intermediary			   	 := gapd.intermediary;
	   		v_giac_apdc_payt_dtl.particulars			   	 := gapd.particulars;
			v_giac_apdc_payt_dtl.tin						 := gapd.tin;
			v_giac_apdc_payt_dtl.check_flag					 := gapd.check_flag;
			v_giac_apdc_payt_dtl.check_status				 := gapd.check_status;
			v_giac_apdc_payt_dtl.user_id					 := gapd.user_id;
			v_giac_apdc_payt_dtl.gacc_tran_id				 := gapd.gacc_tran_id;
			v_giac_apdc_payt_dtl.last_update				 := gapd.last_update;
			v_giac_apdc_payt_dtl.gross_amt					 := gapd.gross_amt;
			v_giac_apdc_payt_dtl.commission_amt				 := gapd.commission_amt;
			v_giac_apdc_payt_dtl.vat_amt					 := gapd.vat_amt;
			v_giac_apdc_payt_dtl.fc_gross_amt				 := gapd.fc_gross_amt;
			v_giac_apdc_payt_dtl.fc_tax_amt					 := gapd.fc_tax_amt;
			v_giac_apdc_payt_dtl.replace_date				 := gapd.replace_date;
			v_giac_apdc_payt_dtl.pay_mode					 := gapd.pay_mode;
			v_giac_apdc_payt_dtl.intm_no					 := gapd.intm_no;
			v_giac_apdc_payt_dtl.dcb_no						 := gapd.dcb_no;
			v_giac_apdc_payt_dtl.bank_branch				 := gapd.bank_branch;
			v_giac_apdc_payt_dtl.remarks					 := gapd.remarks;
            v_giac_apdc_payt_dtl.or_flag					 := get_or_flag_for_apdc_payt_dtl(gapd.gacc_tran_id);
			
			PIPE ROW (v_giac_apdc_payt_dtl);
		END LOOP;
		RETURN;
		
	END get_giac_apdc_payt_dtl;
	
  PROCEDURE set_giac_apdc_payt_dtl(
	   p_apdc_id				GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
	   p_pdc_id					GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
	   p_item_no				GIAC_APDC_PAYT_DTL.item_no%TYPE,
	   p_bank_cd				GIAC_APDC_PAYT_DTL.bank_cd%TYPE,
	   p_check_class			GIAC_APDC_PAYT_DTL.check_class%TYPE,
	   p_check_no				GIAC_APDC_PAYT_DTL.check_no%TYPE,
	   p_check_date				GIAC_APDC_PAYT_DTL.check_date%TYPE,
	   p_check_amt				GIAC_APDC_PAYT_DTL.check_amt%TYPE,
	   p_currency_cd			GIAC_APDC_PAYT_DTL.currency_cd%TYPE,
	   p_currency_rt			GIAC_APDC_PAYT_DTL.currency_rt%TYPE,
	   p_fcurrency_amt			GIAC_APDC_PAYT_DTL.fcurrency_amt%TYPE,
	   p_particulars			GIAC_APDC_PAYT_DTL.particulars%TYPE,
	   p_payor					GIAC_APDC_PAYT_DTL.payor%TYPE,
	   p_address_1				GIAC_APDC_PAYT_DTL.address_1%TYPE,
	   p_address_2				GIAC_APDC_PAYT_DTL.address_2%TYPE,
	   p_address_3				GIAC_APDC_PAYT_DTL.address_3%TYPE,
	   p_tin					GIAC_APDC_PAYT_DTL.tin%TYPE,
	   p_check_flag				GIAC_APDC_PAYT_DTL.check_flag%TYPE,
	   p_gross_amt				GIAC_APDC_PAYT_DTL.gross_amt%TYPE,
	   p_commission_amt			GIAC_APDC_PAYT_DTL.commission_amt%TYPE,
	   p_vat_amt				GIAC_APDC_PAYT_DTL.vat_amt%TYPE,
	   p_fc_gross_amt			GIAC_APDC_PAYT_DTL.fc_gross_amt%TYPE,
	   p_fc_comm_amt			GIAC_APDC_PAYT_DTL.fc_comm_amt%TYPE,
	   p_fc_tax_amt				GIAC_APDC_PAYT_DTL.fc_tax_amt%TYPE,
	   p_replace_date			GIAC_APDC_PAYT_DTL.replace_date%TYPE,
	   p_pay_mode				GIAC_APDC_PAYT_DTL.pay_mode%TYPE,
	   p_intm_no				GIIS_INTERMEDIARY.intm_no%TYPE,
	   p_bank_branch			GIAC_APDC_PAYT_DTL.bank_branch%TYPE
  )

  IS
  	--p_intm_no 				GIAC_APDC_PAYT_DTL.intm_no%TYPE;
        v_particulars           GIAC_APDC_PAYT_DTL.particulars%TYPE;
  BEGIN
--       BEGIN
--	  	   SELECT intm_no
--		     INTO p_intm_no
--			 FROM GIIS_INTERMEDIARY
--			WHERE intm_name = p_intm_name;
--	
--		   EXCEPTION 
--		        WHEN NO_DATA_FOUND THEN
--					 NULL;
--	   END;

        -- marco - UCPB SR 20752 - 11.17.2015 
        IF LENGTH(p_particulars) > 500 THEN
            v_particulars := GIACP.v('OR_PARTICULARS_TEXT') || ' various policies';
        ELSE
            v_particulars := p_particulars;
        END IF;

	   MERGE INTO GIAC_APDC_PAYT_DTL
	   USING DUAL ON (apdc_id = p_apdc_id 
                      AND pdc_id = p_pdc_id)
	   WHEN NOT MATCHED THEN
		 	INSERT (apdc_id, pdc_id, item_no, bank_cd, check_class, check_no,
				 check_date, check_amt, currency_cd, currency_rt, fcurrency_amt, particulars, 
				 payor, address_1, address_2, address_3, tin, check_flag, gross_amt, 
				 commission_amt, vat_amt, fc_gross_amt, fc_comm_amt, fc_tax_amt, replace_date,
				 pay_mode, intm_no, bank_branch)
		 	VALUES (p_apdc_id, p_pdc_id, p_item_no, p_bank_cd, p_check_class, p_check_no, 
				 p_check_date, p_check_amt, p_currency_cd, p_currency_rt, p_fcurrency_amt, 
				 v_particulars, p_payor, p_address_1, p_address_2, p_address_3, p_tin, p_check_flag, 
				 p_gross_amt, nvl(p_commission_amt, 0), nvl(p_vat_amt, 0), (p_gross_amt / p_currency_rt), (nvl(p_commission_amt, 0) / p_currency_rt), (nvl(p_vat_amt, 0) / p_currency_rt), 
				 p_replace_date, 'CHK', p_intm_no, p_bank_branch)
	   WHEN MATCHED THEN
			UPDATE SET --apdc_id 			= p_apdc_id,
				   	   item_no			= p_item_no,
					   bank_cd			= p_bank_cd,
					   check_class		= p_check_class,
					   check_no			= p_check_no,
					   check_date		= p_check_date,
					   check_amt		= p_check_amt,
					   currency_cd		= p_currency_cd,
					   currency_rt		= p_currency_rt,
					   fcurrency_amt	= p_fcurrency_amt,
					   particulars		= v_particulars,
					   payor			= p_payor,
					   address_1		= p_address_1,
					   address_2		= p_address_2,
					   address_3		= p_address_3,
					   tin				= p_tin,
					   check_flag		= p_check_flag,
					   gross_amt		= p_gross_amt,
					   commission_amt	= nvl(p_commission_amt, 0),
					   vat_amt			= nvl(p_vat_amt, 0),
					   fc_gross_amt		= (p_gross_amt / p_currency_rt),
					   fc_comm_amt		= (p_commission_amt / p_currency_rt),
					   fc_tax_amt		= (p_vat_amt / p_currency_rt),
					   replace_date		= p_replace_date,
					   pay_mode			= 'CHK',
					   intm_no			= p_intm_no,
					   bank_branch		= p_bank_branch;
  END set_giac_apdc_payt_dtl;	
  
  PROCEDURE delete_giac_apdc_payt_dtl(
  	   p_pdc_id			GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  )
  
  IS
  
  BEGIN
    
       DELETE 
         FROM giac_pdc_prem_colln
        WHERE pdc_id = p_pdc_id; 
  
  	   DELETE
	     FROM giac_apdc_payt_dtl
		WHERE pdc_id = p_pdc_id;
  
  END delete_giac_apdc_payt_dtl;	
  
  PROCEDURE cancel_apdc_payt_dtl(
  	  p_pdc_id			GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  )		   

  IS
  
  BEGIN
  
  	   UPDATE giac_apdc_payt_dtl
		  SET check_flag = 'C'
	    WHERE pdc_id = p_pdc_id; 
  
  END cancel_apdc_payt_dtl;	
	
  PROCEDURE update_apdc_payt_dtl_status(
    p_pdc_id        GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
    p_check_flag    GIAC_APDC_PAYT_DTL.check_flag%TYPE)  
  IS
  BEGIN
    UPDATE giac_apdc_payt_dtl
	   SET check_flag = p_check_flag
	 WHERE pdc_id = p_pdc_id;
     
    IF p_check_flag = 'R' THEN
      UPDATE giac_apdc_payt_dtl
	     SET replace_date = SYSDATE
	   WHERE pdc_id = p_pdc_id;
    END IF;
  END update_apdc_payt_dtl_status;
  
  /*
   **  Created by   :  D.Alcantara
   **  Date Created :  03.29.2012
   **  Reference By : (GIACS001 -  Enter O.R. Information)
   **  Description  : for validation if OR is from apdc
   */
  FUNCTION check_if_from_apdc (
    p_gacc_tran_id      GIAC_APDC_PAYT_DTL.gacc_tran_id%TYPE
  ) RETURN NUMBER is
    v_apdc      NUMBER := 0;
  BEGIN
    BEGIN
        SELECT DISTINCT 1 
          INTO v_apdc
          FROM GIAC_APDC_PAYT_DTL
         WHERE gacc_tran_id = p_gacc_tran_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_apdc := 0;
    END;
    RETURN v_apdc;
  END check_if_from_apdc;
  
  PROCEDURE val_del_apdc (
      p_pdc_id      GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  )
  AS
  BEGIN
     FOR i IN (SELECT 'gppc'
                 FROM giac_pdc_prem_colln a
                WHERE a.pdc_id = p_pdc_id)
     LOOP
        raise_application_error(-20001,'Geniisys Exception#E#Cannot delete record from giac_apdc_payt while dependent record(s) in giac_pdc_prem_colln exists.');
        EXIT;
     END LOOP;
     
     FOR i IN (SELECT 'gpr'
                 FROM giac_pdc_replace a
                WHERE a.pdc_id = p_pdc_id)
     LOOP
        raise_application_error(-20001,'Geniisys Exception#E#Cannot delete record from giac_apdc_payt while dependent record(s) in giac_pdc_replace exists.');
        EXIT;
     END LOOP;
  END;
END giac_apdc_payt_dtl_pkg;
/

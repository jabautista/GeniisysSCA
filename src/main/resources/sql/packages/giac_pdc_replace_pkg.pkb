CREATE OR REPLACE PACKAGE BODY CPI.giac_pdc_replace_pkg
AS
  
   FUNCTION get_giac_pdc_replace(
   		p_pdc_id			  GIAC_PDC_REPLACE.pdc_id%TYPE
   )RETURN giac_pdc_replace_tab PIPELINED
   
   IS
     v_giac_pdc_replace			giac_pdc_replace_type;
	 
   BEGIN
     	FOR i IN (SELECT a.item_no, a.pay_mode, a.bank_cd, b.bank_sname, b.bank_name,
			  	 		 a.check_class, a.check_no, a.check_date, a.amount,
						 a.currency_cd, a.gross_amt, a.commission_amt, a.vat_amt,
						 a.ref_no, c.rv_meaning check_class_desc, d.currency_desc
				    FROM GIAC_PDC_REPLACE a
                        ,GIAC_BANKS b
                        ,CG_REF_CODES c
                        ,GIIS_CURRENCY d
				   WHERE a.pdc_id = p_pdc_id
                     AND a.currency_cd = d.main_currency_cd
				     AND a.bank_cd = b.bank_cd (+)
                     AND c.rv_domain (+) = 'GIAC_CHK_DISBURSEMENT.CHECK_CLASS'
                     AND c.rv_low_value (+) = a.check_class
			  	 )
		LOOP	
	 		v_giac_pdc_replace.item_no		  := i.item_no;
			v_giac_pdc_replace.pay_mode		  := i.pay_mode;
			v_giac_pdc_replace.bank_cd		  := i.bank_cd;
			v_giac_pdc_replace.bank_sname	  := i.bank_sname;
            v_giac_pdc_replace.bank_name	  := i.bank_name;
			v_giac_pdc_replace.check_class	  := i.check_class;
            v_giac_pdc_replace.check_class_desc := i.check_class_desc;
			v_giac_pdc_replace.check_no		  := i.check_no;
			v_giac_pdc_replace.check_date	  := i.check_date;
			v_giac_pdc_replace.amount		  := i.amount;
			v_giac_pdc_replace.currency_cd	  := i.currency_cd;
            v_giac_pdc_replace.currency_desc	  := i.currency_desc;
			v_giac_pdc_replace.gross_amt	  := i.gross_amt;
			v_giac_pdc_replace.commission_amt := i.commission_amt;
			v_giac_pdc_replace.vat_amt		  := i.vat_amt;
			v_giac_pdc_replace.ref_no		  := i.ref_no;
			PIPE ROW (v_giac_pdc_replace);
		END LOOP;
		RETURN;
 
   END get_giac_pdc_replace;
   
   PROCEDURE insert_giac_pdc_replace(
   		p_pdc_id				GIAC_PDC_REPLACE.pdc_id%TYPE,
		p_item_no				GIAC_PDC_REPLACE.pdc_id%TYPE,
		p_pay_mode				GIAC_PDC_REPLACE.pay_mode%TYPE,
		p_bank_cd				GIAC_PDC_REPLACE.bank_cd%TYPE,
		p_check_class			GIAC_PDC_REPLACE.check_class%TYPE,
		p_check_no				GIAC_PDC_REPLACE.check_no%TYPE,
		p_check_date			GIAC_PDC_REPLACE.check_date%TYPE,
		p_amount				GIAC_PDC_REPLACE.amount%TYPE,
		p_currency_cd			GIAC_PDC_REPLACE.currency_cd%TYPE,
		p_gross_amt				GIAC_PDC_REPLACE.gross_amt%TYPE,
		p_commission_amt		GIAC_PDC_REPLACE.commission_amt%TYPE,
		p_vat_amt				GIAC_PDC_REPLACE.vat_amt%TYPE,
		p_ref_no				GIAC_PDC_REPLACE.ref_no%TYPE
   )
   
   IS
        v_exist                 VARCHAR2(1) := 'N';
   BEGIN
      --modified by jdiago 08012014 : added update if record is for update not insert
      BEGIN
        SELECT 'Y'
          INTO v_exist
          FROM giac_pdc_replace
         WHERE pdc_id = p_pdc_id
           AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_exist := 'N';
      END;
           
      IF v_exist = 'Y' THEN
         UPDATE giac_pdc_replace
            SET pay_mode = p_pay_mode,
                bank_cd = p_bank_cd,
                check_class = p_check_class,
                check_no = p_check_no,
                check_date = p_check_date,
                amount = p_amount,
                currency_cd = p_currency_cd,
                gross_amt = p_gross_amt,
                commission_amt = p_commission_amt,
                vat_amt = p_vat_amt,
                ref_no = p_ref_no
          WHERE pdc_id = p_pdc_id
            AND item_no = p_item_no;
      ELSE
         INSERT
		   INTO GIAC_PDC_REPLACE(pdc_id, item_no, pay_mode, bank_cd,
		  	   					 check_class, check_no, check_date, amount, currency_cd,
								 gross_amt, commission_amt, vat_amt, ref_no,
								 user_id, last_update)
						 VALUES (p_pdc_id, p_item_no, p_pay_mode, p_bank_cd,
						         p_check_class, p_check_no, p_check_date, p_amount, p_currency_cd,
						         p_gross_amt, p_commission_amt, p_vat_amt, p_ref_no,
						 		 NVL(giis_users_pkg.app_user,USER), SYSDATE);
      END IF;  
   END insert_giac_pdc_replace;
     
END giac_pdc_replace_pkg;
/



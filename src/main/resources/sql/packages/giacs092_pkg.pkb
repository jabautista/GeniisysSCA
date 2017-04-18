CREATE OR REPLACE PACKAGE BODY CPI.giacs092_pkg
AS
   FUNCTION get_branch_lov (
      p_gfun_fund_cd   VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_list branch_lov_type;
   BEGIN
      FOR i IN (SELECT a.branch_cd, a.branch_name
                  FROM giac_branches a
                 WHERE a.gfun_fund_cd = p_gfun_fund_cd
                   AND check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS092', p_user_id) = 1
                   AND EXISTS (SELECT 'X'
                                 FROM giac_apdc_payt b
                                WHERE b.branch_cd = a.branch_cd))
      LOOP
        v_list.branch_cd := i.branch_cd;
        v_list.branch_name := i.branch_name;
        PIPE ROW(v_list);
      END LOOP;
      RETURN;                          
   END get_branch_lov;
   
   FUNCTION get_pdc_payments (
      p_fund_cd VARCHAR2,
      p_branch_cd VARCHAR2,
      p_check_flag VARCHAR2,
      p_apdc_no NUMBER,
      p_apdc_date VARCHAR2,
      p_bank_sname VARCHAR2,
      p_check_no VARCHAR2,
      p_check_date VARCHAR2,
      p_check_amt NUMBER,
      p_short_name VARCHAR2
   )
      RETURN pdc_payment_tab PIPELINED
   IS
      v_list pdc_payment_type;
   BEGIN
      FOR i IN (SELECT   b.apdc_date, b.apdc_no, b.fund_cd, b.branch_cd, a.apdc_id, a.pdc_id, a.item_no,
                         a.bank_cd, a.check_class, a.check_no, a.check_date, a.check_amt, a.currency_cd,
                         a.currency_rt, a.fcurrency_amt, a.particulars, a.payor, a.address_1,
                         a.address_2, a.address_3, a.tin, a.check_flag, a.user_id, a.gacc_tran_id,
                         a.last_update, a.gross_amt, a.commission_amt, a.vat_amt, a.fc_gross_amt,
                         a.fc_comm_amt, a.fc_tax_amt, a.replace_date, a.pay_mode, a.intm_no,
                         b.cashier_cd, c.bank_sname, d.short_name, e.or_no, e.or_date, f.currency_desc
                    FROM giac_apdc_payt_dtl a, giac_apdc_payt b, giac_banks c, giis_currency d, giac_order_of_payts e, giis_currency f
                   WHERE a.apdc_id = b.apdc_id
                     AND a.bank_cd = c.bank_cd (+)
                     AND a.currency_cd = d.main_currency_cd (+)
                     AND a.gacc_tran_id = e.gacc_tran_id (+)
                     AND a.currency_cd = f.main_currency_cd (+)
                     AND b.fund_cd = p_fund_cd
                     AND b.branch_cd = p_branch_cd 
                     AND NVL(b.apdc_no, 0) = NVL(p_apdc_no, NVL(b.apdc_no, 0))
                     AND b.apdc_date = NVL(TO_DATE(p_apdc_date, 'mm-dd-yyyy'), b.apdc_date)
                     AND UPPER(c.bank_sname) LIKE UPPER(NVL(p_bank_sname, c.bank_sname))
                     AND UPPER(a.check_no) LIKE UPPER(NVL(p_check_no, a.check_no))
                     AND a.check_date = NVL(TO_DATE(p_check_date, 'mm-dd-yyyy'), a.check_date)
                     AND a.check_amt = NVL(p_check_amt, a.check_amt)
                     AND UPPER(d.short_name) LIKE UPPER(NVL(p_short_name, d.short_name))
                     AND a.check_flag = NVL(p_check_flag, a.check_flag)
                ORDER BY b.apdc_no, a.check_no)
      LOOP
         v_list.pdc_id := i.pdc_id;
         v_list.apdc_no := i.apdc_no;
         v_list.apdc_date := i.apdc_date;
         v_list.bank_sname := i.bank_sname;
         v_list.check_no := i.check_no;
         v_list.check_date := i.check_date;
         v_list.check_amt := i.check_amt;
         v_list.short_name := i.short_name;
         v_list.payor := i.payor;
         v_list.address_1 := i.address_1;
         v_list.address_2 := i.address_2;
         v_list.address_3 := i.address_3;
         v_list.tin := i.tin;
         v_list.or_no := i.or_no;
         v_list.or_date := i.or_date;
         v_list.particulars := i.particulars;
         v_list.gross_amt := i.gross_amt;
         v_list.commission_amt := i.commission_amt;
         v_list.vat_amt := i.vat_amt;
         v_list.currency_desc := i.currency_desc;
         v_list.currency_rt := i.currency_rt;
         v_list.fcurrency_amt := i.fcurrency_amt;
         
         BEGIN
            SELECT COUNT(pdc_id)
              INTO v_list.replace_count
              FROM giac_pdc_replace
             WHERE pdc_id = i.pdc_id; 
         END;
         
         BEGIN
            SELECT COUNT(pdc_id)
              INTO v_list.detail_count
              FROM giac_pdc_prem_colln
             WHERE pdc_id = i.pdc_id;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
      RETURN;             
   END get_pdc_payments; 
   
   FUNCTION get_details (p_pdc_id NUMBER)
      RETURN details_tab PIPELINED
   IS 
      v_list details_type;
   BEGIN
      FOR i IN (SELECT x.pdc_id, x.transaction_type, x.iss_cd,
                       x.prem_seq_no, x.inst_no, x.collection_amt,
                       x.premium_amt, x.tax_amt, x.user_id, x.last_update, y.currency_desc, x.currency_rt, x.fcurrency_amt,
                       RTRIM(c.line_cd) || '-' || RTRIM(c.subline_cd) || '-' || RTRIM(c.iss_cd) || 
                       '-' || LTRIM(TO_CHAR(c.issue_yy)) || '-' || LTRIM(TO_CHAR(c.pol_seq_no)) || 
                       DECODE(c.endt_seq_no,0,NULL, '-' ||c.endt_iss_cd ||'-'||LTRIM(TO_CHAR(c.endt_yy))||
                       '-' ||LTRIM(TO_CHAR(c.endt_seq_no)) || '-' || RTRIM(c.endt_type))||'-'||
                       LTRIM(TO_CHAR(c.renew_no)) policy_no, d.assd_name 
                  FROM giac_pdc_prem_colln x, giis_assured d, gipi_parlist e,
                       gipi_polbasic c, gipi_invoice b, giac_aging_soa_details a, giis_currency y
                 WHERE x.pdc_id = p_pdc_id
                   AND x.currency_cd = y.main_currency_cd (+)
                   AND e.assd_no = d.assd_no 
                   AND e.assd_no = d.assd_no 
                   AND e.assd_no = d.assd_no 
                   AND c.par_id = e.par_id 
                   AND a.policy_id = c.policy_id 
                   AND a.policy_id = c.policy_id 
                   AND a.policy_id = c.policy_id 
                   AND a.prem_seq_no = b.prem_seq_no 
                   AND a.iss_cd = b.iss_cd 
                   AND a.iss_cd = x.iss_cd (+)
                   AND x.inst_no = a.inst_no --marco - 10.02.2014
                   AND b.prem_seq_no = x.prem_seq_no)
      LOOP
         v_list.pdc_id := i.pdc_id;
         v_list.transaction_type := i.transaction_type;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.inst_no := i.inst_no;
         v_list.collection_amt := i.collection_amt;
         v_list.premium_amt := i.premium_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.assd_name := i.assd_name;
         v_list.policy_no := i.policy_no;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');
         v_list.currency_desc := i.currency_desc;
         v_list.currency_rt := i.currency_rt;
         v_list.fcurrency_amt := i.fcurrency_amt;
         
         
         IF v_list.tot_collection_amt IS NULL THEN
         BEGIN
                SELECT SUM(NVL(collection_amt, 0)), SUM(NVL(premium_amt, 0)), SUM(NVL(tax_amt, 0))
                  INTO v_list.tot_collection_amt, v_list.tot_premium_amt, v_list.tot_tax_amt
                  FROM giac_pdc_prem_colln
                 WHERE pdc_id = p_pdc_id;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_list.tot_collection_amt := 0;
                v_list.tot_premium_amt := 0;
                v_list.tot_tax_amt := 0;
         END;      
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
      RETURN;         
   END get_details;
   
   FUNCTION get_replacement (
      p_pdc_id NUMBER
   )
      RETURN replacement_tab PIPELINED
   IS
      v_list replacement_type;
   BEGIN
      FOR i IN (SELECT a.item_no, a.pay_mode, a.check_class, a.check_no, 
                       a.check_date, a.amount, a.gross_amt, a.commission_amt,
                       a.vat_amt, b.bank_sname, a.currency_cd
                  FROM giac_pdc_replace a, giac_banks b
                 WHERE a.pdc_id = p_pdc_id
                   AND a.bank_cd = b.bank_cd (+))
      LOOP
         v_list.item_no := i.item_no;
         v_list.pay_mode := i.pay_mode;
         v_list.bank_sname2 := i.bank_sname;
         v_list.check_class := i.check_class;
         v_list.check_no2 := i.check_no;
         v_list.check_date := i.check_date;
         v_list.amount := i.amount;
         v_list.gross_amt := i.gross_amt;
         v_list.commission_amt := i.commission_amt;
         v_list.vat_amt := i.vat_amt;
         
         --marco - 10.03.2014
         BEGIN
            SELECT currency_desc
              INTO v_list.currency_desc
              FROM GIIS_CURRENCY
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_list.currency_desc := NULL;
         END;
         
         IF v_list.bank_sname IS NULL THEN
            BEGIN
                SELECT bank_sname, check_no, check_amt, replace_date
                 INTO v_list.bank_sname, v_list.check_no, v_list.check_amt, v_list.replace_date
	             FROM giac_apdc_payt_dtl a,
	                  giac_banks b
	            WHERE a.bank_cd = b.bank_cd
	              AND a.pdc_id = p_pdc_id;
            EXCEPTION WHEN  NO_DATA_FOUND THEN
                v_list.bank_sname := ' ';
            END;
         END IF;
         
         IF v_list.tot_amount IS NULL THEN
            BEGIN
               SELECT SUM(NVL(amount, 0))
                 INTO v_list.tot_amount
                 FROM giac_pdc_replace
                WHERE pdc_id = p_pdc_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.tot_amount := 0;      
            END;
         END IF;
         
         
         PIPE ROW(v_list);
      END LOOP;
      RETURN;           
   END get_replacement;   
                  
END;
/



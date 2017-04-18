CREATE OR REPLACE PACKAGE BODY CPI.giacs211_pkg
AS

    FUNCTION get_bill_details (
       p_iss_cd        gipi_invoice.iss_cd%TYPE,
       p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
    )
       RETURN gipi_invoice_tab PIPELINED
    AS
      v_rec                 gipi_invoice_type;
      v_dsp_policy_status   VARCHAR2 (200);
      v_chk                 VARCHAR (1)       := 'N';
      v_input_vat           NUMBER (16, 2);
      v_commission_amt      NUMBER (16, 2);
      v_wholding_tax        NUMBER (16, 2);
      v_comm_paid           NUMBER (16, 2);
      v_wtax_rate           NUMBER (16, 2);
      v_wtax_paid           NUMBER (16, 2);
    BEGIN
       FOR i IN (SELECT a.iss_cd, a.prem_seq_no, a.due_date, a.policy_id,
                        a.currency_rt, a.property, a.currency_cd, a.prem_amt,
                        a.tax_amt, a.other_charges, a.notarial_fee, a.payt_terms,
                        a.insured, c.assd_no, c.designation, c.assd_name,
                        b.line_cd dsp_line_cd, b.subline_cd dsp_subline_cd,
                        b.iss_cd dsp_iss_cd, b.issue_yy dsp_issue_yy,
                        b.pol_seq_no dsp_pol_seq_no, b.renew_no dsp_renew_no,
                        b.endt_iss_cd dsp_endt_iss_cd, b.endt_yy dsp_endt_yy,
                        b.endt_seq_no dsp_endt_seq_no, b.endt_type dsp_endt_type,
                        b.pol_flag, b.incept_date, b.expiry_date, b.issue_date,
                        b.spld_date, b.ref_pol_no, g.line_cd pack_line_cd,
                        g.subline_cd pack_subline_cd, g.iss_cd pack_iss_cd,
                        g.issue_yy pack_issue_yy, g.pol_seq_no pack_pol_seq_no,
                        g.renew_no pack_renew_no, g.endt_iss_cd pack_endt_iss_cd,
                        g.endt_yy pack_endt_yy, g.endt_seq_no pack_endt_seq_no,
                        h.iss_cd pack_bill_iss_cd,
                        h.prem_seq_no pack_bill_prem_seq_no
                   FROM gipi_invoice a,
                        gipi_polbasic b,
                        giis_assured c,
                        gipi_pack_polbasic g,
                        gipi_pack_invoice h
                  WHERE a.prem_seq_no = p_prem_seq_no
                    AND a.iss_cd = p_iss_cd
                    AND a.policy_id = b.policy_id
                    AND b.assd_no = c.assd_no
                    AND b.pack_policy_id = g.pack_policy_id(+)
                    AND b.pack_policy_id = h.policy_id(+))
       LOOP
          v_rec.due_date := i.due_date;
          v_rec.iss_cd := i.iss_cd;
          v_rec.prem_seq_no := i.prem_seq_no;
          v_rec.policy_id := i.policy_id;
          v_rec.property := i.property;
          v_rec.currency_cd := i.currency_cd;
          v_rec.currency_rt := i.currency_rt;
          v_rec.prem_amt := i.prem_amt;
          v_rec.tax_amt := i.tax_amt;
          v_rec.other_charges := i.other_charges;
          v_rec.notarial_fee := i.notarial_fee;
          v_rec.due_date := i.due_date;
          v_rec.payt_terms := i.payt_terms;
          v_rec.insured := i.insured;
          v_rec.assd_no := i.assd_no;
          v_rec.designation := i.designation;
          v_rec.assd_name := i.assd_name;
          v_rec.dsp_line_cd := i.dsp_line_cd;
          v_rec.dsp_subline_cd := i.dsp_subline_cd;
          v_rec.dsp_iss_cd := i.dsp_iss_cd;
          v_rec.dsp_issue_yy := i.dsp_issue_yy;
          v_rec.dsp_pol_seq_no := i.dsp_pol_seq_no;
          v_rec.dsp_renew_no := i.dsp_renew_no;
          v_rec.dsp_endt_iss_cd := i.dsp_endt_iss_cd;
          v_rec.dsp_endt_yy := i.dsp_endt_yy;
          v_rec.dsp_endt_seq_no := i.dsp_endt_seq_no;
          v_rec.dsp_endt_type := i.dsp_endt_type;
          v_rec.pol_flag := i.pol_flag;
          v_rec.incept_date := i.incept_date;
          v_rec.expiry_date := i.expiry_date;
          v_rec.issue_date := i.issue_date;
          v_rec.spld_date := i.spld_date;
          v_rec.ref_pol_no := i.ref_pol_no;
          v_rec.due_date_char := TO_CHAR (v_rec.due_date, 'MM-DD-YYYY');
          v_rec.incept_date_char := TO_CHAR (v_rec.incept_date, 'MM-DD-YYYY');
          v_rec.expiry_date_char := TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
          v_rec.issue_date_char := TO_CHAR (v_rec.issue_date, 'MM-DD-YYYY');
          v_rec.spld_date_char := TO_CHAR (v_rec.spld_date, 'MM-DD-YYYY');
          v_rec.pack_line_cd := i.pack_line_cd;
          v_rec.pack_subline_cd := i.pack_subline_cd;
          v_rec.pack_iss_cd := i.pack_iss_cd;
          v_rec.pack_issue_yy := i.pack_issue_yy;
          v_rec.pack_pol_seq_no := i.pack_pol_seq_no;
          v_rec.pack_renew_no := i.pack_renew_no;
          v_rec.pack_endt_iss_cd := i.pack_endt_iss_cd;
          v_rec.pack_endt_yy := i.pack_endt_yy;
          v_rec.pack_endt_seq_no := i.pack_endt_seq_no;
          v_rec.pack_bill_iss_cd := i.pack_bill_iss_cd;
          v_rec.pack_bill_prem_seq_no := i.pack_bill_prem_seq_no;
          v_rec.intm_name := NULL;
          v_rec.ref_intm_cd := NULL;
          v_rec.intm_type := NULL;
          v_rec.share_percentage := NULL;
          v_rec.intrmdry_intm_no := NULL;

         IF v_rec.dsp_endt_seq_no = 0 
          THEN
            v_rec.dsp_endt_iss_cd := NULL;
            v_rec.dsp_endt_yy := NULL;
            v_rec.dsp_endt_seq_no := NULL;
         END IF;          

          BEGIN
             SELECT share_percentage, intrmdry_intm_no
               INTO v_rec.share_percentage, v_rec.intrmdry_intm_no
               FROM gipi_comm_invoice
              WHERE iss_cd = i.iss_cd
                AND prem_seq_no = i.prem_seq_no
                AND policy_id = i.policy_id
                AND ROWNUM = 1;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_rec.share_percentage := NULL;
                v_rec.intrmdry_intm_no := NULL;
          END;

          BEGIN
             SELECT intm_name, ref_intm_cd, intm_type
               INTO v_rec.intm_name, v_rec.ref_intm_cd, v_rec.intm_type
               FROM giis_intermediary
              WHERE intm_no = v_rec.intrmdry_intm_no;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_rec.intm_name := NULL;
                v_rec.ref_intm_cd := NULL;
                v_rec.intm_type := NULL;
          END;

          BEGIN
             SELECT SUBSTR (rv_meaning, 1, 30)
               INTO v_dsp_policy_status
               FROM cg_ref_codes
              WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                AND rv_low_value = i.pol_flag;

             IF i.pol_flag = '5'
             THEN
                v_rec.policy_status :=
                      v_dsp_policy_status
                   || ' - '
                   || TO_CHAR (i.spld_date, 'MM-DD-RRRR');
             ELSE
                v_rec.policy_status := v_dsp_policy_status;
             END IF;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_rec.policy_status := NULL;
          END;

          FOR a IN (SELECT reg_policy_sw
                      FROM gipi_polbasic
                     WHERE line_cd = i.dsp_line_cd
                       AND subline_cd = i.dsp_subline_cd
                       AND iss_cd = i.dsp_iss_cd
                       AND issue_yy = i.dsp_issue_yy
                       AND pol_seq_no = i.dsp_pol_seq_no
                       AND renew_no = i.dsp_renew_no
                       AND endt_iss_cd = NVL (i.dsp_endt_iss_cd, i.dsp_iss_cd)
                       AND endt_yy = NVL (i.dsp_endt_yy, 0)
                       AND endt_seq_no = NVL (i.dsp_endt_seq_no, 0)
                       AND NVL (endt_type, 'P') = NVL (i.dsp_endt_type, 'P'))
          LOOP
             IF a.reg_policy_sw = 'Y'
             THEN
                v_rec.reg_policy_sw := 'Regular';
             ELSE
                v_rec.reg_policy_sw := 'Special';
             END IF;
          END LOOP;

          v_rec.php_prem := NVL (v_rec.prem_amt, 0) * i.currency_rt;

          FOR chk IN (SELECT 1
                        FROM giis_parameters
                       WHERE param_name LIKE UPPER ('%OTHER_CHARGES_CODE%'))
          LOOP
             v_chk := 'Y';
          END LOOP;

          IF i.currency_rt <> 1
          THEN
             v_rec.php_tax := get_loc_inv_tax_sum (i.iss_cd, i.prem_seq_no);
          ELSE
             IF v_chk = 'Y'
             THEN
                v_rec.php_tax :=
                     (NVL (v_rec.tax_amt, 0) - NVL (v_rec.other_charges, 0)
                     )
                   * i.currency_rt;
             ELSE
                v_rec.php_tax := NVL (v_rec.tax_amt, 0) * i.currency_rt;
             END IF;
          END IF;

          v_rec.php_charges :=
               (NVL (v_rec.other_charges, 0) * i.currency_rt)
             + (NVL (v_rec.notarial_fee, 0) * i.currency_rt);
          v_rec.total_amt_due :=
               NVL (v_rec.php_prem, 0)
             + NVL (v_rec.php_tax, 0)
             + NVL (v_rec.php_charges, 0);

          BEGIN
             SELECT currency_desc
               INTO v_rec.curr_desc
               FROM giis_currency
              WHERE main_currency_cd = i.currency_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_rec.curr_desc := NULL;
          END;

          v_rec.foren_prem := v_rec.php_prem / i.currency_rt;
          v_rec.foren_tax := v_rec.php_tax / i.currency_rt;
          v_rec.foren_charges := v_rec.php_charges / i.currency_rt;
          v_rec.foren_total := v_rec.total_amt_due / i.currency_rt;

          BEGIN
             SELECT   NVL (c.input_vat_paid, 0)
                    + (  (NVL (a.commission_amt, 0) - NVL (c.comm_amt, 0))
                       * (NVL (b.input_vat_rate, 0) / 100)
                      ) input_vat
               INTO v_input_vat
               FROM gipi_comm_invoice a,
                    giis_intermediary b,
                    (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                              SUM (j.comm_amt) comm_amt, SUM (j.wtax_amt)
                                                                         wtax_amt,
                              SUM (j.input_vat_amt) input_vat_paid
                         FROM giac_comm_payts j, giac_acctrans k
                        WHERE j.gacc_tran_id = k.tran_id
                          AND k.tran_flag <> 'D'
                          AND j.iss_cd = i.iss_cd
                          AND j.prem_seq_no = i.prem_seq_no
                          AND j.intm_no = v_rec.intrmdry_intm_no
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag != 'D'
                                    AND x.gacc_tran_id = j.gacc_tran_id)
                     GROUP BY intm_no, iss_cd, prem_seq_no) c
              WHERE a.intrmdry_intm_no = b.intm_no
                AND a.iss_cd = c.iss_cd(+)
                AND a.prem_seq_no = c.prem_seq_no(+)
                AND a.intrmdry_intm_no = c.intm_no(+)
                AND a.iss_cd = i.iss_cd
                AND a.prem_seq_no = i.prem_seq_no
                AND a.intrmdry_intm_no = v_rec.intrmdry_intm_no;

             SELECT NVL (a.commission_amt, 0)
               INTO v_commission_amt
               FROM gipi_comm_invoice a
              WHERE a.iss_cd = i.iss_cd
                AND a.prem_seq_no = i.prem_seq_no
                AND a.intrmdry_intm_no = v_rec.intrmdry_intm_no;

             /* SELECT NVL (a.wholding_tax, 0)
               INTO v_wholding_tax
               FROM gipi_comm_invoice a
              WHERE a.iss_cd = i.iss_cd
                AND a.prem_seq_no = i.prem_seq_no
                AND a.intrmdry_intm_no = v_rec.intrmdry_intm_no; */
             
             /* SR-23298 JET NOV-02-2016 */
             SELECT NVL(SUM(aa.comm_amt), 0), NVL(SUM(aa.wtax_amt), 0)
               INTO v_comm_paid, v_wtax_paid
               FROM giac_comm_payts aa, giac_acctrans bb
              WHERE aa.iss_cd = i.iss_cd
                AND aa.prem_seq_no = i.prem_seq_no
                AND aa.intm_no = v_rec.intrmdry_intm_no
                AND aa.gacc_tran_id = bb.tran_id
                AND bb.tran_flag <> 'D'
                AND NOT EXISTS (
                    SELECT 1
                      FROM giac_reversals cc, giac_acctrans dd
                     WHERE cc.reversing_tran_id = dd.tran_id
                       AND dd.tran_flag <> 'D'
                       AND cc.gacc_tran_id = aa.gacc_tran_id
                );
             
             BEGIN
                SELECT NVL(wtax_rate, 0)
                  INTO v_wtax_rate
                  FROM giis_intermediary
                 WHERE intm_no = v_rec.intrmdry_intm_no;
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    v_wtax_rate := 0;
             END;
             
             v_wholding_tax := ((v_commission_amt - v_comm_paid) * (v_wtax_rate / 100)) + v_wtax_paid;
             
             v_rec.net_premium :=
                (  v_rec.total_amt_due
                 - (  (v_commission_amt * i.currency_rt)
                    - (v_wholding_tax * i.currency_rt)
                    + (v_input_vat * i.currency_rt)
                   )
                );
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_rec.net_premium := v_rec.total_amt_due;
          END;

          PIPE ROW (v_rec);
       END LOOP;
    END get_bill_details;

   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 04.30.2013
   **  Reference By      : GIACS211 - BILL PAYMENTS
   */
   FUNCTION get_gipi_invoice(
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER    
   )
      RETURN gipi_invoice_tab PIPELINED
   AS    
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec gipi_invoice_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.iss_cd, a.prem_seq_no
                                      FROM gipi_invoice a
                                     WHERE a.policy_id NOT IN (SELECT policy_id
                                                                 FROM giri_inpolbas)                                       
                                       ';                                                                                                                                                         
                         
      IF p_prem_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.prem_seq_no = '|| p_prem_seq_no;
      END IF;
      
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(a.iss_cd) LIKE '''||UPPER(p_iss_cd)||'''';
      END IF;     

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (UPPER(a.iss_cd) LIKE '''||UPPER(p_find_text)||''' OR a.prem_seq_no LIKE '''||p_find_text||''')';
      END IF;

      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id = '|| p_policy_id;
      END IF;

      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                   FROM gipi_polbasic
                                                  WHERE assd_no = '|| p_assd_no ||')';        
      END IF;

      IF p_intm_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (a.iss_cd, a.prem_seq_no) IN (SELECT iss_cd, prem_seq_no
                                                                FROM gipi_comm_invoice
                                                               WHERE intrmdry_intm_no = '|| p_intm_no ||')';
      END IF;
      
      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||'''';
      END IF;      

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id 
                                                  FROM gipi_polbasic
                                                 WHERE TO_CHAR(incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||''')';
      END IF;
      
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id 
                                                  FROM gipi_polbasic
                                                 WHERE TO_CHAR(expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||''')';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id 
                                                  FROM gipi_polbasic
                                                 WHERE TO_CHAR(issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||''')';
      END IF;
      
      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id 
                                                  FROM gipi_polbasic
                                                 WHERE pack_policy_id = '|| p_pack_policy_id||')';
      END IF;
      
      IF p_pack_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE pack_policy_id IN (SELECT policy_id 
                                                                            FROM gipi_pack_invoice
                                                                           WHERE iss_cd = '''|| p_pack_bill_iss_cd||'''))';
      END IF;      
      
      IF p_pack_bill_prem_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE pack_policy_id IN (SELECT policy_id 
                                                                            FROM gipi_pack_invoice
                                                                           WHERE prem_seq_no = '|| p_pack_bill_prem_seq_no||'))';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        v_sql := v_sql || ' ORDER BY prem_seq_no '||p_asc_desc_flag;
      ELSE
        v_sql := v_sql || ' ORDER BY prem_seq_no ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.iss_cd, 
                      v_rec.prem_seq_no;  
         EXIT WHEN c%NOTFOUND;              
                  
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;   
   END;

   FUNCTION get_policy_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_ref_pol_no    gipi_polbasic.ref_pol_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,  
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd   gipi_invoice.iss_cd%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER   )
      RETURN gipi_invoice_tab PIPELINED
   AS    
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec gipi_invoice_type;
      v_sql VARCHAR2(5000);      
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                                           a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.ref_pol_no, a.endt_type, 
                                           DECODE(a.endt_seq_no, 
                                                    0, NULL,
                                                    a.endt_iss_cd || ''-'' || a.endt_yy || ''-'' || a.endt_seq_no) endt_no
                                      FROM gipi_polbasic a
                                     WHERE a.policy_id NOT IN (SELECT policy_id
                                                                 FROM giri_inpolbas)
                                       AND NVL(a.endt_type, ''A'') = ''A''                                       
                                       ';                                                                                                                                                         
             
        
      IF p_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd = '''|| p_bill_iss_cd ||'''';
      ELSE
        v_sql := v_sql || ' AND a.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line(''AC'', '''||p_module_id||''', '''||p_user_id||''')))';
      END IF;

      IF p_line_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.line_cd = '''|| p_line_cd ||'''';
      END IF;

      IF p_subline_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.subline_cd = '''|| p_subline_cd ||'''';
      END IF;
      
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd = '''|| p_iss_cd ||'''';
      END IF;

      IF p_issue_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.issue_yy = '|| p_issue_yy;
      END IF;      

      IF p_pol_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pol_seq_no = '|| p_pol_seq_no;
      END IF;

      IF p_renew_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.renew_no = '|| p_renew_no;
      END IF;
      
      IF p_endt_seq_no IS NOT NULL 
      THEN
          IF p_endt_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_iss_cd = '''||p_endt_iss_cd||'''';
          END IF;

          IF p_endt_yy IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_yy = '||p_endt_yy;
          END IF;
                
          IF p_endt_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_seq_no = '||p_endt_seq_no;
          END IF;            
      ELSIF p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL
      THEN       
          IF p_endt_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_iss_cd = '''||p_endt_iss_cd||'''';
          END IF;

          IF p_endt_yy IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_yy = '||p_endt_yy;
          END IF;
          
          v_sql := v_sql || ' AND a.endt_seq_no <> 0';
      END IF;

      IF p_ref_pol_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.ref_pol_no = '''||p_ref_pol_no||'''';
      END IF;

      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT b.policy_id
                                                  FROM gipi_polbasic b
                                                      ,gipi_invoice c
                                                 WHERE b.policy_id = c.policy_id
                                                   AND TO_CHAR(c.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||'''';
      END IF;
      
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||'''';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||'''';
      END IF;

      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id = '|| p_pack_policy_id;
      END IF;
      
      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE assd_no = '|| p_assd_no ||')';        
      END IF;

      IF p_pack_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE pack_policy_id IN (SELECT policy_id 
                                                                            FROM gipi_pack_invoice
                                                                           WHERE iss_cd = '''|| p_pack_bill_iss_cd||'''))';
      END IF;      
      
      IF p_pack_bill_prem_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE pack_policy_id IN (SELECT policy_id 
                                                                            FROM gipi_pack_invoice
                                                                           WHERE prem_seq_no = '|| p_pack_bill_prem_seq_no||'))';
      END IF;                                                                           
      
      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (UPPER(a.line_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.subline_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.iss_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR a.issue_yy LIKE '''||UPPER(p_find_text)
                                ||''' OR a.pol_seq_no LIKE '''||UPPER(p_find_text)
                                ||''' OR a.renew_no LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.endt_iss_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR a.endt_seq_no LIKE '''||UPPER(p_find_text)
                                ||''' OR a.endt_yy LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.endt_type) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.ref_pol_no) LIKE '''||UPPER(p_find_text)
                                ||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
        THEN
            v_sql := v_sql || ' ORDER BY a.line_cd '||p_asc_desc_flag
                                    ||', a.subline_cd '||p_asc_desc_flag
                                    ||', a.iss_cd '||p_asc_desc_flag
                                    ||', a.issue_yy '||p_asc_desc_flag
                                    ||', a.pol_seq_no '||p_asc_desc_flag
                                    ||', a.renew_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'dspEndtIssCd dspEndtYy dspEndtSeqNo'
        THEN
            v_sql := v_sql || ' ORDER BY endt_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'refPolNo'
        THEN
            v_sql := v_sql || ' ORDER BY a.ref_pol_no '||p_asc_desc_flag;                                                                           
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY a.line_cd ASC, a.subline_cd ASC, a.iss_cd ASC, a.issue_yy ASC, a.pol_seq_no ASC, a.renew_no ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.policy_id, 
                      v_rec.dsp_line_cd,
                      v_rec.dsp_subline_cd,
                      v_rec.dsp_iss_cd,
                      v_rec.dsp_issue_yy,
                      v_rec.dsp_pol_seq_no,
                      v_rec.dsp_renew_no,
                      v_rec.dsp_endt_iss_cd,
                      v_rec.dsp_endt_yy,
                      v_rec.dsp_endt_seq_no,
                      v_rec.ref_pol_no,
                      v_rec.dsp_endt_type,
                      v_rec.endt_no;
         EXIT WHEN c%NOTFOUND;      
         
         IF v_rec.dsp_endt_seq_no = 0 
          THEN
            v_rec.dsp_endt_iss_cd := NULL;
            v_rec.dsp_endt_yy := NULL;
            v_rec.dsp_endt_seq_no := NULL;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;   
   END;

   FUNCTION get_pack_policy_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_pack_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_pack_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_pack_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_pack_polbasic.endt_seq_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,  
      p_assd_no       gipi_pack_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_pack_bill_iss_cd   gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd   gipi_invoice.iss_cd%TYPE, 
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN gipi_invoice_tab PIPELINED
   AS    
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec gipi_invoice_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.pack_policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                                           a.endt_iss_cd, a.endt_yy, a.endt_seq_no, d.iss_cd pack_bill_iss_cd, d.prem_seq_no,
                                           DECODE(a.endt_seq_no, 0, NULL,
                                                        a.endt_iss_cd || ''-'' || a.endt_yy || ''-'' || a.endt_seq_no) endt_no
                                      FROM gipi_pack_polbasic a
                                          ,gipi_pack_invoice d
                                     WHERE a.pack_policy_id NOT IN (SELECT pack_policy_id
                                                                      FROM giri_pack_inpolbas)
                                       AND a.pack_policy_id = d.policy_id 
                                       AND NVL(a.endt_type, ''A'') = ''A''                                     
                                       ';                                                                                                                                                         
      
      IF p_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd = '''|| p_bill_iss_cd ||'''';
      ELSE
        v_sql := v_sql || ' AND a.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line(''AC'', '''||p_module_id||''', '''||p_user_id||''')))';
      END IF;
                      
      IF p_line_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.line_cd = '''|| p_line_cd ||'''';
      END IF;

      IF p_subline_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.subline_cd = '''|| p_subline_cd ||'''';
      END IF;
      
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd = '''|| p_iss_cd ||'''';
      END IF;

      IF p_issue_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.issue_yy = '|| p_issue_yy;
      END IF;      

      IF p_pol_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pol_seq_no = '|| p_pol_seq_no;
      END IF;

      IF p_renew_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.renew_no = '|| p_renew_no;
      END IF;
      
      IF p_endt_seq_no IS NOT NULL
      THEN
          IF p_endt_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_iss_cd = '''||p_endt_iss_cd||'''';
          END IF;

          IF p_endt_yy IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_yy = '||p_endt_yy;
          END IF;

          IF p_endt_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_seq_no = '||p_endt_seq_no;
          END IF;
      ELSIF p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL
      THEN
          IF p_endt_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_iss_cd = '''||p_endt_iss_cd||'''';
          END IF;

          IF p_endt_yy IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.endt_yy = '||p_endt_yy;
          END IF;
          
          v_sql := v_sql || ' AND a.endt_yy > 0'; 
      END IF;
      
      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id IN (SELECT b.pack_policy_id
                                                       FROM gipi_pack_polbasic b
                                                           ,gipi_pack_invoice c
                                                      WHERE b.pack_policy_id = c.policy_id
                                                        AND TO_CHAR(c.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||'''';
      END IF;
      
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||'''';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||'''';
      END IF;
      
      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id IN (SELECT b.pack_policy_id
                                                       FROM gipi_pack_polbasic b
                                                           ,gipi_polbasic c
                                                      WHERE b.pack_policy_id = c.pack_policy_id
                                                        AND c.policy_id = '|| p_policy_id ||')';
      END IF;      

      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id IN (SELECT pack_policy_id
                                                       FROM gipi_pack_polbasic
                                                      WHERE assd_no = '|| p_assd_no ||')';        
      END IF;      

      IF p_pack_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id IN (SELECT policy_id 
                                                       FROM gipi_pack_invoice
                                                      WHERE iss_cd = '''|| p_pack_bill_iss_cd||''')';
      END IF;      
      
      IF p_pack_bill_prem_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pack_policy_id IN (SELECT policy_id 
                                                       FROM gipi_pack_invoice
                                                      WHERE prem_seq_no = '|| p_pack_bill_prem_seq_no||')';
      END IF;  

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (UPPER(a.line_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.subline_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.iss_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR a.issue_yy LIKE '''||UPPER(p_find_text)
                                ||''' OR a.pol_seq_no LIKE '''||UPPER(p_find_text)
                                ||''' OR a.renew_no LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.endt_iss_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR a.endt_seq_no LIKE '''||UPPER(p_find_text)
                                ||''' OR a.endt_yy LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(a.endt_type) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(d.iss_cd) LIKE '''||UPPER(p_find_text)
                                ||''' OR UPPER(d.prem_seq_no) LIKE '''||UPPER(p_find_text)
                                ||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'packPolicyNo'
        THEN
            v_sql := v_sql || ' ORDER BY a.line_cd '||p_asc_desc_flag
                                    ||', a.subline_cd '||p_asc_desc_flag
                                    ||', a.iss_cd '||p_asc_desc_flag
                                    ||', a.issue_yy '||p_asc_desc_flag
                                    ||', a.pol_seq_no '||p_asc_desc_flag
                                    ||', a.renew_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'packEndtNo'
        THEN
            v_sql := v_sql || ' ORDER BY endt_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'packBillNo'
        THEN
            v_sql := v_sql || ' ORDER BY d.iss_cd '||p_asc_desc_flag
                                    ||', d.prem_seq_no '||p_asc_desc_flag;                                                                                                                                     
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY a.line_cd ASC, a.subline_cd ASC, a.iss_cd ASC, a.issue_yy ASC, a.pol_seq_no ASC, a.renew_no ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.pack_policy_id, 
                      v_rec.pack_line_cd,
                      v_rec.pack_subline_cd,
                      v_rec.pack_iss_cd,
                      v_rec.pack_issue_yy,
                      v_rec.pack_pol_seq_no,
                      v_rec.pack_renew_no,
                      v_rec.pack_endt_iss_cd,
                      v_rec.pack_endt_yy,
                      v_rec.pack_endt_seq_no,
                      v_rec.pack_bill_iss_cd,
                      v_rec.pack_bill_prem_seq_no,
                      v_rec.endt_no;
         EXIT WHEN c%NOTFOUND;      
         
         IF v_rec.pack_endt_seq_no = 0 
          THEN
            v_rec.pack_endt_iss_cd := NULL;
            v_rec.pack_endt_yy := NULL;
            v_rec.pack_endt_seq_no := NULL;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;   
   END;

   FUNCTION get_giac_direct_prem_collns (
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_currency_cd     gipi_invoice.currency_cd%TYPE,
      p_currency_rt     gipi_invoice.currency_rt%TYPE,
      p_pol_flag        gipi_polbasic.pol_flag%TYPE,
      p_total_amt_due   NUMBER
   )
      RETURN giac_direct_prem_collns_tab PIPELINED
   IS
      v_rec              giac_direct_prem_collns_type;
      v_chk_payt         giac_parameters.param_value_v%TYPE;
      v_tran_flag        giac_acctrans.tran_flag%TYPE;
      v_enter_for_loop   BOOLEAN                              := FALSE;
   BEGIN
      FOR a IN (SELECT SUM(a.collection_amt) total_collection_amt --Added by Jerome Bautista 08.27.2015 SR 20096, 20103
            FROM giac_direct_prem_collns a, giac_acctrans b
           WHERE gacc_tran_id NOT IN (SELECT tran_id
                                        FROM giac_acctrans
                                       WHERE tran_flag = 'D')
             AND gacc_tran_id NOT IN (
                    SELECT aa.gacc_tran_id
                      FROM giac_reversals aa, giac_acctrans bb
                     WHERE aa.reversing_tran_id = bb.tran_id
                       AND bb.tran_flag != 'D')
             AND b140_iss_cd = p_iss_cd
             AND b140_prem_seq_no = p_prem_seq_no
             AND b.tran_id = a.gacc_tran_id
             -- added by shan 11.13.2014
             AND gacc_tran_id IN (SELECT tran_id
                                  FROM giac_acctrans
                                 WHERE ((GIACP.v('CHK_PAYT') = 'Y'
                                         AND tran_flag IN ('C','P'))
                                         OR (GIACP.v('CHK_PAYT') = 'N'))))
      LOOP
      
      v_rec.total_collection_amt := a.total_collection_amt;
      
      END LOOP;
      
      FOR i IN
         (SELECT a.gacc_tran_id, b.tran_class, b.gibr_branch_cd,
                 b.tran_class_no, b.jv_no, b.tran_year, b.tran_month,
                 b.tran_seq_no, b.tran_date, a.transaction_type,
                 a.collection_amt
            FROM giac_direct_prem_collns a, giac_acctrans b
           WHERE gacc_tran_id NOT IN (SELECT tran_id
                                        FROM giac_acctrans
                                       WHERE tran_flag = 'D')
             AND gacc_tran_id NOT IN (
                    SELECT aa.gacc_tran_id
                      FROM giac_reversals aa, giac_acctrans bb
                     WHERE aa.reversing_tran_id = bb.tran_id
                       AND bb.tran_flag != 'D')
             AND b140_iss_cd = p_iss_cd
             AND b140_prem_seq_no = p_prem_seq_no
             AND b.tran_id = a.gacc_tran_id
             -- added by shan 11.13.2014
             AND gacc_tran_id IN (SELECT tran_id
                                  FROM giac_acctrans
                                 WHERE ((GIACP.v('CHK_PAYT') = 'Y'
                                         AND tran_flag IN ('C','P'))
                                         OR (GIACP.v('CHK_PAYT') = 'N'))))
      LOOP
         v_enter_for_loop := TRUE;

         BEGIN
            /* to accomodate other transaction class */
            DECLARE
               CURSOR fire
               IS
                  SELECT tran_class
                    FROM giac_acctrans
                   WHERE tran_id = i.gacc_tran_id;

               CURSOR earth
               IS
                  SELECT    DECODE (or_pref_suf,
                                    NULL, NULL,
                                    or_pref_suf || '-'
                                   )
                         || TO_CHAR (or_no) or_no
                    FROM giac_order_of_payts
                   WHERE gacc_tran_id = i.gacc_tran_id;

               CURSOR air
               IS
                  SELECT    DECODE (dv_pref,
                                    NULL, NULL,
                                    dv_pref || '-'
                                   )
                         || TO_CHAR (dv_no) dv_no
                    FROM giac_disb_vouchers
                   WHERE gacc_tran_id = i.gacc_tran_id;

               CURSOR wind
               IS
                  SELECT                                      --tran_class_no
                         tran_class || '-' || tran_class_no
                    --issa, 02.23.2005
                  FROM   giac_acctrans
                   WHERE tran_id = i.gacc_tran_id;

               CURSOR metal
               IS
                  SELECT    DECODE (or_pref_suf,
                                    NULL, NULL,
                                    or_pref_suf || '-'
                                   )
                         || TO_CHAR (or_no) or_no
                    FROM giac_order_of_payts a, giac_pdc_checks b
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND gacc_tran_id_new = i.gacc_tran_id;

               --added by ailene 082206
               --to consider tran class 'CM' and 'DM'
               CURSOR sixth_element
               IS
                  SELECT memo_type || '-' || memo_year || '-' || memo_seq_no
                    FROM giac_cm_dm
                   WHERE gacc_tran_id = i.gacc_tran_id;

               -- end ailene
               v_tran_class   giac_acctrans.tran_class%TYPE;
            BEGIN
               OPEN fire;

               FETCH fire
                INTO v_tran_class;

               CLOSE fire;

               IF v_tran_class = 'COL'
               THEN
                  OPEN earth;

                  FETCH earth
                   INTO v_rec.dsp_or_no;

                  CLOSE earth;
               ELSIF v_tran_class = 'DV'
               THEN
                  OPEN air;

                  FETCH air
                   INTO v_rec.dsp_or_no;

                  CLOSE air;
               ELSIF v_tran_class = 'JV'
               THEN
                  OPEN wind;

                  FETCH wind
                   INTO v_rec.dsp_or_no;

                  CLOSE wind;
               ELSIF v_tran_class = 'PDC'
               THEN
                  OPEN metal;

                  FETCH metal
                   INTO v_rec.dsp_or_no;

                  CLOSE metal;
               --added by ailene 082206
               ELSIF v_tran_class IN ('CM', 'DM')
               THEN
                  OPEN sixth_element;

                  FETCH sixth_element
                   INTO v_rec.dsp_or_no;

                  CLOSE sixth_element;
               --end ailene
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dsp_or_no := NULL;
            END;
         END;

         v_rec.gacc_tran_id := i.gacc_tran_id;
         v_rec.transaction_type := i.transaction_type;
         v_rec.collection_amt := i.collection_amt;

         FOR rec1 IN (SELECT param_value_v
                        FROM giac_parameters
                       WHERE param_name = 'CHK_PAYT')
         LOOP
            v_chk_payt := rec1.param_value_v;
            EXIT;
         END LOOP;

         --get value of tran_flag
         IF NVL (v_chk_payt, 'N') = 'Y'
         THEN
            FOR rec2 IN (SELECT tran_flag
                           FROM giac_acctrans
                          WHERE tran_id = v_rec.gacc_tran_id)
            LOOP
               v_tran_flag := rec2.tran_flag;
               EXIT;
            END LOOP;
         ELSE
            v_tran_flag := NULL;
              --used null so that condition below    will always be satisfied
         --if chk_payt = 'N'
         END IF;

         IF NVL (v_tran_flag, 'C') IN ('C', 'P')
         THEN
            --issa, 02.23.2005/03.08.2005; para makita rin yung transaction na posted
                   --since yung C na tran_flag magiging P once nag-run ng trial balance
            v_rec.gibr_branch_cd := i.gibr_branch_cd;
            v_rec.tran_class := i.tran_class;
            v_rec.tran_class_no := i.tran_class_no;
            v_rec.jv_no := i.jv_no;
            v_rec.tran_year := i.tran_year;
            v_rec.tran_month := i.tran_month;
            v_rec.tran_seq_no := i.tran_seq_no;
            v_rec.tran_date := i.tran_date;
            v_rec.tran_date_char := TO_CHAR (v_rec.tran_date, 'MM-DD-YYYY');
            v_rec.dsp_transaction_type := v_rec.transaction_type;
            v_rec.dsp_collection_amt := v_rec.collection_amt;
--            v_rec.total_collection_amt := -- Commented out by Jerome Bautista 08.27.2015 SR 20096, 20103
--                 NVL (v_rec.total_collection_amt, 0)
--               + NVL (v_rec.dsp_collection_amt, 0);

            --NESTOR START (TO DISPLAY 0 WHEN POL_FLAG IS '5'
            IF p_pol_flag = '5'
            THEN
               v_rec.balance_due := 0;
            ELSE
               v_rec.balance_due :=
                    NVL (p_total_amt_due, 0)
                  - NVL (v_rec.total_collection_amt, 0);
            END IF;
         /*added by lina
         to have no value once the reference no is null*/
         ELSE
            v_rec.gibr_branch_cd := '';
            v_rec.tran_class := '';
            v_rec.tran_class_no := '';
            v_rec.jv_no := '';
            v_rec.tran_year := '';
            v_rec.tran_month := '';
            v_rec.tran_seq_no := '';
            v_rec.tran_date := '';
            v_rec.tran_date_char := '';
            v_rec.dsp_transaction_type := '';
            v_rec.dsp_collection_amt := 0;
            v_rec.total_collection_amt := 0;
            v_rec.balance_due := 0;
            v_rec.dsp_or_no := '';
         END IF;

         BEGIN
            BEGIN
               SELECT short_name                               --currency_desc
                 INTO v_rec.curr_desc2
                 FROM giis_currency
                WHERE main_currency_cd = p_currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.curr_desc2 := NULL;
            END;

            v_rec.foren_coll := v_rec.dsp_collection_amt / p_currency_rt;
            v_rec.conv_rate2 := p_currency_rt;
            v_rec.foren_total2 := v_rec.total_collection_amt / p_currency_rt;

            -- modified by randell 03082007.
            -- retrieves the correct foren_balance value
            IF v_rec.total_collection_amt = 0
            THEN
               v_rec.foren_balance := v_rec.balance_due / p_currency_rt;
            ELSE
               IF v_rec.balance_due = 0
               THEN
                  v_rec.foren_balance :=
                       (v_rec.total_collection_amt / p_currency_rt
                       )
                     - v_rec.foren_total2;
               ELSE
                  v_rec.foren_balance := (v_rec.balance_due / p_currency_rt);
               END IF;
            END IF;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      IF v_enter_for_loop = FALSE AND p_iss_cd IS NOT NULL
      THEN
         FOR rec1 IN (SELECT param_value_v
                        FROM giac_parameters
                       WHERE param_name = 'CHK_PAYT')
         LOOP
            v_chk_payt := rec1.param_value_v;
            EXIT;
         END LOOP;

         IF NVL (v_chk_payt, 'N') = 'Y'
         THEN
            FOR rec2 IN (SELECT tran_flag
                           FROM giac_acctrans
                          WHERE tran_id = v_rec.gacc_tran_id)
            LOOP
               v_tran_flag := rec2.tran_flag;
               EXIT;
            END LOOP;
         ELSE
            v_tran_flag := NULL;
         END IF;

         IF NVL (v_tran_flag, 'C') IN ('C', 'P')
         THEN
            v_rec.total_collection_amt :=
                 NVL (v_rec.total_collection_amt, 0)
               + NVL (v_rec.dsp_collection_amt, 0);

            IF p_pol_flag = '5'
            THEN
               v_rec.balance_due := 0;
            ELSE
               v_rec.balance_due :=
                    NVL (p_total_amt_due, 0)
                  - NVL (v_rec.total_collection_amt, 0);
            END IF;
         ELSE
            v_rec.total_collection_amt := 0;
            v_rec.balance_due := 0;
         END IF;

         BEGIN
            BEGIN
               SELECT short_name
                 INTO v_rec.curr_desc2
                 FROM giis_currency
                WHERE main_currency_cd = p_currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.curr_desc2 := NULL;
            END;

            v_rec.foren_coll := v_rec.dsp_collection_amt / p_currency_rt;
            v_rec.conv_rate2 := p_currency_rt;
            v_rec.foren_total2 := v_rec.total_collection_amt / p_currency_rt;

            IF v_rec.total_collection_amt = 0
            THEN
               v_rec.foren_balance := v_rec.balance_due / p_currency_rt;
            ELSE
               IF v_rec.balance_due = 0
               THEN
                  v_rec.foren_balance :=
                       (v_rec.total_collection_amt / p_currency_rt
                       )
                     - v_rec.foren_total2;
               ELSE
                  v_rec.foren_balance := (v_rec.balance_due / p_currency_rt);
               END IF;
            END IF;
         END;

         PIPE ROW (v_rec);
      END IF;
   END;

   FUNCTION get_giis_intermediary_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_type     giis_intermediary.intm_type%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN giis_intermediary_lov_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec giis_intermediary_lov_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.intm_no, a.ref_intm_cd, a.intm_name
                                      FROM giis_intermediary a
                                     WHERE 1=1                                                                      
                                       ';                                                                                                                                                         
                
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                 WHERE c.iss_cd = '''|| p_iss_cd ||''')';
      END IF;
      
      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                 WHERE c.policy_id = '|| p_policy_id ||')';
      END IF;

      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.policy_id = d.policy_id
                                                   AND d.assd_no = '|| p_assd_no ||')';          
      END IF;

      IF p_intm_type IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type = '''|| p_intm_type ||'''';
      END IF;
          
      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_invoice d
                                                 WHERE c.iss_cd = d.iss_cd
                                                   AND c.prem_seq_no = d.prem_seq_no
                                                   AND TO_CHAR(d.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;      

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||''')';
      END IF;
          
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||''')';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||''')';
      END IF;
          
      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_no IN (
                                                SELECT c.intrmdry_intm_no
                                                  FROM gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.policy_id = d.policy_id
                                                   AND d.pack_policy_id = '|| p_pack_policy_id||')';          
      ELSE          
          IF p_pack_bill_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.intm_no IN (
                                                    SELECT c.intrmdry_intm_no
                                                      FROM gipi_comm_invoice c
                                                          ,gipi_polbasic d
                                                     WHERE c.policy_id = d.policy_id
                                                       AND d.pack_policy_id IN (SELECT policy_id 
                                                                                  FROM gipi_pack_invoice
                                                                                 WHERE iss_cd = '''|| p_pack_bill_iss_cd||'''))';                                                                     
          END IF;      
              
          IF p_pack_bill_prem_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.intm_no IN (
                                                    SELECT c.intrmdry_intm_no
                                                      FROM gipi_comm_invoice c
                                                          ,gipi_polbasic d
                                                     WHERE c.policy_id = d.policy_id
                                                       AND d.pack_policy_id IN (SELECT policy_id 
                                                                                  FROM gipi_pack_invoice
                                                                                 WHERE prem_seq_no = '''|| p_pack_bill_prem_seq_no||'''))';
          END IF;
      END IF;

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (a.ref_intm_cd LIKE '''||UPPER(p_find_text)||''' OR a.intm_no LIKE '''||UPPER(p_find_text)||''' OR UPPER(a.intm_name) LIKE '''||UPPER(p_find_text)||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'intmNo'
        THEN
            v_sql := v_sql || ' ORDER BY intm_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'intmName'
        THEN
            v_sql := v_sql || ' ORDER BY intm_name '||p_asc_desc_flag;
        ELSIF p_order_by = 'refIntmCd'
        THEN
            v_sql := v_sql || ' ORDER BY ref_intm_cd '||p_asc_desc_flag;            
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY intm_no ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                    
      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.intm_no, 
                      v_rec.ref_intm_cd,
                      v_rec.intm_name;
         EXIT WHEN c%NOTFOUND;         
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END;

   FUNCTION get_giis_intm_type_lov(
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER 
   ) RETURN giis_intm_type_lov_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec giis_intm_type_lov_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT DISTINCT a.intm_type, a.intm_desc
                                      FROM giis_intm_type a
                                     WHERE 1=1                                                                      
                                       ';                                                                                                                                                         
      
                
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.iss_cd = '''|| p_iss_cd ||''')';
      END IF;
      
      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = '|| p_policy_id ||')';
      END IF;

      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = d.policy_id
                                                   AND d.assd_no = '|| p_assd_no ||')';          
      END IF;

      IF p_intm_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                 WHERE b.intm_no = '|| p_intm_no ||')';
      END IF;
          
      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_invoice d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.iss_cd = d.iss_cd
                                                   AND c.prem_seq_no = d.prem_seq_no
                                                   AND TO_CHAR(d.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;      

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||''')';
      END IF;
          
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||''')';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = d.policy_id
                                                   AND TO_CHAR(d.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||''')';
      END IF;
          
      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.intm_type IN (
                                                SELECT b.intm_type
                                                  FROM giis_intermediary b
                                                      ,gipi_comm_invoice c
                                                      ,gipi_polbasic d
                                                 WHERE c.intrmdry_intm_no = b.intm_no
                                                   AND c.policy_id = d.policy_id
                                                   AND d.pack_policy_id = '|| p_pack_policy_id||')';          
      ELSE          
          IF p_pack_bill_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.intm_type IN (
                                                    SELECT b.intm_type
                                                      FROM giis_intermediary b
                                                          ,gipi_comm_invoice c
                                                          ,gipi_polbasic d
                                                     WHERE c.intrmdry_intm_no = b.intm_no
                                                       AND c.policy_id = d.policy_id
                                                       AND d.pack_policy_id IN (SELECT policy_id 
                                                                                  FROM gipi_pack_invoice
                                                                                 WHERE iss_cd = '''|| p_pack_bill_iss_cd||'''))';                                                                     
          END IF;      
              
          IF p_pack_bill_prem_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.intm_type IN (
                                                    SELECT b.intm_type
                                                      FROM giis_intermediary b
                                                          ,gipi_comm_invoice c
                                                          ,gipi_polbasic d
                                                     WHERE c.intrmdry_intm_no = b.intm_no
                                                       AND c.policy_id = d.policy_id
                                                       AND d.pack_policy_id IN (SELECT policy_id 
                                                                                  FROM gipi_pack_invoice
                                                                                 WHERE prem_seq_no = '''|| p_pack_bill_prem_seq_no||'''))';
          END IF;
      END IF;

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (UPPER(a.intm_type) LIKE '''||UPPER(p_find_text)||''' OR UPPER(a.intm_desc) LIKE '''||UPPER(p_find_text)||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'intmType'
        THEN
            v_sql := v_sql || ' ORDER BY intm_type '||p_asc_desc_flag;
        ELSIF p_order_by = 'intmDesc'
        THEN
            v_sql := v_sql || ' ORDER BY intm_desc '||p_asc_desc_flag;
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY intm_type ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
--raise_application_error(-20001, v_sql);
      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.intm_type, 
                      v_rec.intm_desc;
         EXIT WHEN c%NOTFOUND;         
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END;

   FUNCTION get_giis_assured_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_policy_id       gipi_invoice.policy_id%TYPE,
      p_due_date        VARCHAR2,
      p_incept_date     VARCHAR2,
      p_expiry_date     VARCHAR2,
      p_issue_date      VARCHAR2,  
      p_intm_no         gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_pack_policy_id     gipi_pack_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd   gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd     gipi_invoice.iss_cd%TYPE, 
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER   
   )   RETURN giis_assured_lov_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec giis_assured_lov_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.assd_no, a.assd_name
                                      FROM giis_assured a
                                     WHERE a.assd_no >= 0                                       
                                       ';                                                                                                                                                         
      
      IF p_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                                    ,gipi_invoice c
                                               WHERE b.policy_id = c.policy_id
                                                 AND c.iss_cd = '''|| p_bill_iss_cd ||''')';
      END IF;
                      
      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                                    ,gipi_invoice c
                                               WHERE b.policy_id = c.policy_id 
                                                 AND TO_CHAR(c.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||''')';
      END IF;
      
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||''')';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||''')';
      END IF;
      
      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_polbasic b
                                               WHERE b.policy_id = '|| p_policy_id||')';      
      END IF;

      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.assd_no IN (SELECT b.assd_no 
                                                FROM gipi_pack_polbasic b
                                               WHERE b.pack_policy_id = '|| p_pack_policy_id||')';      
      END IF;


      IF p_pack_bill_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.assd_no IN (SELECT b.assd_no
                                                FROM gipi_pack_polbasic b
                                                    ,gipi_pack_invoice c
                                               WHERE b.pack_policy_id = c.policy_id
                                                 AND c.iss_cd = '''|| p_pack_bill_iss_cd||''')';
      END IF;      
      
      IF p_pack_bill_prem_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.assd_no IN (SELECT b.assd_no
                                                FROM gipi_pack_polbasic b
                                                    ,gipi_pack_invoice c
                                               WHERE b.pack_policy_id = c.policy_id
                                                 AND c.prem_seq_no = '|| p_pack_bill_prem_seq_no||')';      
      END IF;  

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (a.assd_no LIKE '''||p_find_text||''' OR UPPER(a.assd_name) LIKE '''||UPPER(p_find_text)||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'assdNo'
        THEN
            v_sql := v_sql || ' ORDER BY a.assd_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'assdName'
        THEN
            v_sql := v_sql || ' ORDER BY a.assd_name '||p_asc_desc_flag;
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY a.assd_name ASC';
      END IF;

      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.assd_no, 
                      v_rec.assd_name;
         EXIT WHEN c%NOTFOUND;
                  
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END;

   FUNCTION get_cg_ref_codes_lov
      RETURN cg_ref_codes_lov_tab PIPELINED
   IS
      v_rec   cg_ref_codes_lov_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 47) rv_meaning,
                         SUBSTR (rv_abbreviation, 1, 13) rv_abbreviation
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIPI_POLBASIC.ENDT_TYPE'
                ORDER BY rv_low_value)
      LOOP
         v_rec.rv_low_value := i.rv_low_value;
         v_rec.rv_meaning := i.rv_meaning;
         v_rec.rv_abbreviation := i.rv_abbreviation;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_premium_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN premium_info_tab PIPELINED
   IS
      v_rec   premium_info_type;
      v_bill_curr_cd    giis_currency.main_currency_cd%TYPE;
      v_curr_cd         giis_currency.main_currency_cd%TYPE;
      v_bill_curr_rt    giis_currency.currency_rt%TYPE;
      v_curr_rt         giis_currency.currency_rt%TYPE;
   BEGIN
      FOR i IN (SELECT a.iss_cd, a.prem_seq_no, a.peril_cd, a.item_grp,
                       a.tsi_amt, a.prem_amt, b.peril_name
                  FROM gipi_invperil a, giis_peril b
                 WHERE a.prem_seq_no = p_prem_seq_no
                   AND a.iss_cd = p_iss_cd
                   AND b.peril_cd = a.peril_cd
                   AND b.line_cd IN (
                          SELECT line_cd
                            FROM gipi_polbasic c, gipi_invoice d
                           WHERE c.policy_id = d.policy_id
                             AND d.iss_cd = a.iss_cd
                             AND d.prem_seq_no = a.prem_seq_no))
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.item_grp := i.item_grp;
         v_rec.tsi_amt := i.tsi_amt;
         
         -- shan 11.28.2014
         SELECT currency_cd, currency_rt
           INTO v_bill_curr_cd, v_bill_curr_rt
           FROM gipi_invoice
          WHERE iss_cd = i.iss_cd
            AND prem_seq_no = i.prem_seq_no;            
        
        SELECT main_currency_cd, currency_rt
          INTO v_curr_cd, v_curr_rt
          FROM giis_currency
         WHERE main_currency_cd = giacp.n('CURRENCY_CD');
               
         IF p_to_foreign = 0 THEN   -- convert to local -- shan 11.17.2014             
            IF v_bill_curr_cd <> v_curr_cd THEN
                v_curr_rt := v_bill_curr_rt;
            END IF;
         ELSE               -- convert to foreign
            v_curr_rt := 1;
         END IF;
         
         v_rec.prem_amt := i.prem_amt * v_curr_rt;  -- added v_curr_rt : shan 11.17.2014
         v_rec.peril_name := i.peril_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_taxes_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_currency_rt   gipi_invoice.currency_rt%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN taxes_info_tab PIPELINED
   IS
      v_rec   taxes_info_type;
      v_chk   VARCHAR (1)     := 'N';
      v_bill_curr_cd    giis_currency.main_currency_cd%TYPE;
      v_curr_cd         giis_currency.main_currency_cd%TYPE;
      v_bill_curr_rt    giis_currency.currency_rt%TYPE;
      v_curr_rt         giis_currency.currency_rt%TYPE;
   BEGIN
      FOR chk IN (SELECT 1
                    FROM giis_parameters
                   WHERE param_name LIKE UPPER ('%OTHER_CHARGES_CODE%'))
      LOOP
         v_chk := 'Y';
      END LOOP;

      IF v_chk = 'Y'
      THEN
         FOR i IN
            (SELECT a.iss_cd, a.prem_seq_no, a.tax_cd, a.item_grp, a.tax_amt,
                    b.tax_desc
               FROM gipi_inv_tax a, giis_tax_charges b
              WHERE a.prem_seq_no = p_prem_seq_no
                AND a.iss_cd = p_iss_cd
                AND b.iss_cd = a.iss_cd
                AND b.line_cd = a.line_cd
                /*AND a.tax_cd IN (
                           SELECT tax_cd
                             FROM giis_tax_charges c
                            WHERE c.tax_desc NOT LIKE
                                                     UPPER ('%OTHER CHARGES%'))*/--modified by albert 12.07.2016 (SR 5888)
                AND a.tax_cd NOT IN (SELECT param_value_n
                                       FROM giis_parameters
                                      WHERE param_name LIKE UPPER ('%OTHER_CHARGES_CODE%'))
                AND (   b.tax_cd = a.tax_cd
                     OR (b.tax_cd IS NULL AND a.tax_cd IS NULL)
                    )
                AND b.tax_id = a.tax_id)
         LOOP
            v_rec.iss_cd := i.iss_cd;
            v_rec.prem_seq_no := i.prem_seq_no;
            v_rec.tax_cd := i.tax_cd;
            v_rec.item_grp := i.item_grp;
            
            -- shan 11.28.2014
             SELECT currency_cd, currency_rt
               INTO v_bill_curr_cd, v_bill_curr_rt
               FROM gipi_invoice
              WHERE iss_cd = i.iss_cd
                AND prem_seq_no = i.prem_seq_no;            
            
            SELECT main_currency_cd, currency_rt
              INTO v_curr_cd, v_curr_rt
              FROM giis_currency
             WHERE main_currency_cd = giacp.n('CURRENCY_CD');
                   
             IF p_to_foreign = 0 THEN   -- convert to local -- shan 11.17.2014             
                IF v_bill_curr_cd <> v_curr_cd THEN
                    v_curr_rt := v_bill_curr_rt;
                END IF;
             ELSE               -- convert to foreign
                v_curr_rt := 1;
             END IF;
             
            v_rec.tax_amt := i.tax_amt;
            v_rec.tax_desc := i.tax_desc;
            v_rec.dsp_tax_amt :=
                             ROUND (NVL (v_rec.tax_amt, 0) * v_curr_rt, --p_currency_rt, -- changed by shan : 11.28.2014
                                    2);
            PIPE ROW (v_rec);
         END LOOP;
      ELSE
         FOR i IN (SELECT a.iss_cd, a.prem_seq_no, a.tax_cd, a.item_grp,
                          a.tax_amt, b.tax_desc
                     FROM gipi_inv_tax a, giis_tax_charges b
                    WHERE a.prem_seq_no = p_prem_seq_no
                      AND a.iss_cd = p_iss_cd
                      AND b.iss_cd = a.iss_cd
                      AND b.line_cd = a.line_cd
                      AND (   b.tax_cd = a.tax_cd
                           OR (b.tax_cd IS NULL AND a.tax_cd IS NULL)
                          )
                      AND b.tax_id = a.tax_id)
         LOOP
            v_rec.iss_cd := i.iss_cd;
            v_rec.prem_seq_no := i.prem_seq_no;
            v_rec.tax_cd := i.tax_cd;
            v_rec.item_grp := i.item_grp;
            
            -- shan 11.28.2014
             SELECT currency_cd, currency_rt
               INTO v_bill_curr_cd, v_bill_curr_rt
               FROM gipi_invoice
              WHERE iss_cd = i.iss_cd
                AND prem_seq_no = i.prem_seq_no;            
            
            SELECT main_currency_cd, currency_rt
              INTO v_curr_cd, v_curr_rt
              FROM giis_currency
             WHERE main_currency_cd = giacp.n('CURRENCY_CD');
                   
             IF p_to_foreign = 0 THEN   -- convert to local -- shan 11.17.2014             
                IF v_bill_curr_cd <> v_curr_cd THEN
                    v_curr_rt := v_bill_curr_rt;
                END IF;
             ELSE               -- convert to foreign
                v_curr_rt := 1;
             END IF;
             
            v_rec.tax_amt := i.tax_amt;
            v_rec.tax_desc := i.tax_desc;
            v_rec.dsp_tax_amt :=
                             ROUND (NVL (v_rec.tax_amt, 0) * v_curr_rt, --p_currency_rt, -- changed by shan 11.28.2014
                                    2);
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END;

   FUNCTION get_pdc_payments_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN pdc_payment_info_tab PIPELINED
   IS
      v_rec   pdc_payment_info_type;
      v_bill_curr_cd    giis_currency.main_currency_cd%TYPE;
      v_bill_curr_rt    giis_currency.currency_rt%TYPE;
   BEGIN
      FOR i IN (SELECT a.apdc_id, a.apdc_flag,
                       a.apdc_pref || '-' || a.apdc_no apdc_no, a.apdc_date,
                       a.payor, b.bank_branch, b.bank_cd, b.check_class,
                       b.check_no, b.check_date, c.bank_sname,
                       d.collection_amt, d.pdc_id, d.prem_seq_no, d.iss_cd, d.CURRENCY_CD
                  FROM giac_apdc_payt a,
                       giac_apdc_payt_dtl b,
                       giac_banks c,
                       giac_pdc_prem_colln d
                 WHERE d.prem_seq_no = p_prem_seq_no
                   AND d.iss_cd = p_iss_cd
                   AND a.apdc_id = b.apdc_id
                   AND b.pdc_id = d.pdc_id
                   AND a.apdc_flag <> 'C'
                   AND b.bank_cd = c.bank_cd)
      LOOP
         v_rec.apdc_id := i.apdc_id;
         v_rec.apdc_flag := i.apdc_flag;
         v_rec.apdc_no := i.apdc_no;
         v_rec.apdc_date := i.apdc_date;
         v_rec.payor := i.payor;
         v_rec.bank_branch := i.bank_branch;
         v_rec.bank_cd := i.bank_cd;
         v_rec.check_class := i.check_class;
         v_rec.check_no := i.check_no;
         v_rec.check_date := i.check_date;
         v_rec.bank_sname := i.bank_sname;
         
        -- shan 11.28.2014
         SELECT currency_cd, currency_rt
           INTO v_bill_curr_cd, v_bill_curr_rt
           FROM gipi_invoice
          WHERE iss_cd = i.iss_cd
            AND prem_seq_no = i.prem_seq_no;            
         
        /*SELECT currency_rt       -- shan 11.17.2014
          INTO v_curr_rt
          FROM giis_currency
         WHERE main_currency_cd = DECODE(p_to_foreign, 1, giacp.n('CURRENCY_CD'), i.currency_cd);*/
         
         --v_rec.collection_amt := i.collection_amt * v_curr_rt;  -- added v_curr_rt : shan 11.17.2014; replaced with codes below : shan 11.28.2014
                        
         IF p_to_foreign = 0 THEN   -- convert to local         
            v_rec.collection_amt := i.collection_amt; 
         ELSE               -- convert to foreign
            v_rec.collection_amt := i.collection_amt / v_bill_curr_rt; 
         END IF;
         
         v_rec.pdc_id := i.pdc_id;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.iss_cd := i.iss_cd;
         v_rec.sdf_check_date := TO_CHAR(i.check_date,'MM-DD-YYYY');
         v_rec.sdf_apdc_date := TO_CHAR(i.apdc_date,'MM-DD-YYYY');
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_balances_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN balances_info_tab PIPELINED
   IS
      v_rec   balances_info_type;
      v_bill_curr_cd    giis_currency.main_currency_cd%TYPE;
      v_curr_cd         giis_currency.main_currency_cd%TYPE;
      v_bill_curr_rt    giis_currency.currency_rt%TYPE;
      v_curr_rt         giis_currency.currency_rt%TYPE;
   BEGIN
      FOR i IN (SELECT inst_no, prem_balance_due, tax_balance_due, balance_amt_due
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_rec.inst_no := i.inst_no;
         
         -- shan 11.28.2014
         SELECT currency_cd, currency_rt
           INTO v_bill_curr_cd, v_bill_curr_rt
           FROM gipi_invoice
          WHERE iss_cd = p_iss_cd
            AND prem_seq_no = p_prem_seq_no;            
        
        SELECT main_currency_cd, currency_rt
          INTO v_curr_cd, v_curr_rt
          FROM giis_currency
         WHERE main_currency_cd = giacp.n('CURRENCY_CD');
               
--         IF p_to_foreign = 0 THEN   -- convert to local -- shan 11.17.2014             
--            IF v_bill_curr_cd <> v_curr_cd THEN
--                v_curr_rt := v_bill_curr_rt;
--            END IF;
--         ELSE               -- convert to foreign
--            v_curr_rt := 1;
--         END IF;
--         
--         v_rec.prem_balance_due := i.prem_balance_due * v_curr_rt;  -- added v_curr_rt : shan 11.17.2014
--         v_rec.tax_balance_due := i.tax_balance_due * v_curr_rt;  -- added v_curr_rt : shan 11.17.2014
--         v_rec.balance_amt_due := i.balance_amt_due *  v_curr_rt;  -- added v_curr_rt : shan 11.17.2014
         
        -- start added by gab 09.22.2015
         IF p_to_foreign = 0 THEN           
            v_curr_rt := 1;
         ELSE               
            IF v_bill_curr_cd <> v_curr_cd THEN
                v_curr_rt := v_bill_curr_rt;
            END IF;
         END IF;
         
         v_rec.prem_balance_due := i.prem_balance_due / v_curr_rt;
         v_rec.tax_balance_due := i.tax_balance_due / v_curr_rt;
         v_rec.balance_amt_due := i.balance_amt_due /  v_curr_rt;
         -- end 
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   
   FUNCTION get_iss_cd_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_type     giis_intermediary.intm_type%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN iss_cd_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec iss_cd_type;
      v_sql VARCHAR2(5000);
   BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT DISTINCT a.iss_cd
                                      FROM gipi_invoice a
                                     WHERE a.iss_cd IN (
                                                SELECT branch_cd
                                                  FROM TABLE (security_access.get_branch_line (''AC'',
                                                                                                '''||p_module_id||''',
                                                                                                '''||p_user_id||'''
                                                                                                )
                                                              )
                                                         )                                      
                                       ';

      IF p_intm_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd IN (
                                                SELECT c.iss_cd
                                                  FROM gipi_comm_invoice c
                                                 WHERE c.intrmdry_intm_no = '|| p_intm_no ||')';
      END IF;

      IF p_intm_type IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.iss_cd IN (
                                                SELECT c.iss_cd
                                                  FROM gipi_comm_invoice c
                                                      ,giis_intermediary d
                                                 WHERE c.intrmdry_intm_no = d.intm_no
                                                   AND d.intm_type = '''|| p_intm_type ||''')';
      END IF;

      IF p_due_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT c.iss_cd 
                                                FROM gipi_invoice c
                                               WHERE TO_CHAR(c.due_date, ''MM-DD-YYYY'') = '''|| p_due_date||''')';
      END IF;

      IF p_incept_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.incept_date, ''MM-DD-YYYY'') = '''|| p_incept_date||''')';
      END IF;
      
      IF p_expiry_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.expiry_date, ''MM-DD-YYYY'') = '''|| p_expiry_date||''')';
      END IF;

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_polbasic b
                                               WHERE TO_CHAR(b.issue_date, ''MM-DD-YYYY'') = '''|| p_issue_date||''')';
      END IF;
      
      IF p_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_polbasic b
                                               WHERE b.policy_id = '|| p_policy_id||')';      
      END IF;

      IF p_assd_no IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_polbasic b
                                               WHERE b.assd_no = '|| p_assd_no||')';      
      END IF;

      IF p_pack_policy_id IS NOT NULL
      THEN
        v_sql := v_sql || '  AND a.iss_cd IN (SELECT b.iss_cd 
                                                FROM gipi_pack_polbasic b
                                               WHERE b.pack_policy_id = '|| p_pack_policy_id||')';      
      ELSE
          IF p_pack_bill_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.iss_cd IN (SELECT b.iss_cd
                                                    FROM gipi_pack_invoice b
                                                   WHERE b.iss_cd = '''|| p_pack_bill_iss_cd||''')';
          END IF;      
          
          IF p_pack_bill_prem_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND a.iss_cd IN (SELECT c.iss_cd
                                                    FROM gipi_pack_invoice c
                                                   WHERE c.prem_seq_no = '|| p_pack_bill_prem_seq_no||')';      
          END IF;
      END IF;  

      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(a.iss_cd) LIKE '''||UPPER(p_find_text)||'''';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        v_sql := v_sql || ' ORDER BY a.iss_cd '||p_asc_desc_flag;
      ELSE
        v_sql := v_sql || ' ORDER BY a.iss_cd ASC';
      END IF;

      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql;
      LOOP      
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.iss_cd;
         EXIT WHEN c%NOTFOUND;
                  
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END get_iss_cd_lov;
END;
/

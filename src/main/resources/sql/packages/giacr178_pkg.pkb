CREATE OR REPLACE PACKAGE BODY CPI.GIACR178_PKG
AS

   FUNCTION get_giacr178 (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_line_cd     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr178_tab PIPELINED
   IS
      v_list giacr178_type;
      v_collection_amt giac_direct_prem_collns.collection_amt%TYPE;
      v_check VARCHAR2(10);
   BEGIN
      FOR i IN (SELECT d.line_cd, a.gibr_branch_cd, a.tran_date, a.posting_date,
                       a.tran_flag, a.tran_class,
                       LPAD (e.or_pref_suf, 5, ' ') || '-' || LPAD (e.or_no, 10, 0) or_no,
                       dv_pref || '-' || dv_no dv_no,
                       jv_pref_suff || '-' || LPAD (jv_no, 6, '0') jv_no,
                       d.booking_mth, d.booking_year,
                       SUM(b.collection_amt) collection_amt
                  FROM giac_acctrans a,
                       giac_direct_prem_collns b,
                       giac_order_of_payts e,
                       giac_disb_vouchers f,
                       gipi_invoice c,
                       gipi_polbasic d
                 WHERE a.tran_id = b.gacc_tran_id
                   AND b.b140_iss_cd = c.iss_cd
                   AND b.b140_prem_seq_no = c.prem_seq_no
                   AND c.policy_id = d.policy_id
                   AND a.tran_id = e.gacc_tran_id(+)
                   AND a.tran_id = f.gacc_tran_id(+)
                   AND EXISTS (SELECT 1
                                 FROM giac_chart_of_accts z, giac_acct_entries y
                                WHERE ((z.gl_acct_name LIKE 'PREMIUM%RECEIVABLE%'
                                        AND EXISTS (SELECT 1
                                                      FROM giis_line x
                                                     WHERE x.acct_line_cd = y.gl_sub_acct_1
                                                       AND x.line_cd = d.line_cd))
                                         OR (z.gl_acct_name LIKE 'PREMIUM%DEPOSIT%'))
                                  AND z.gl_acct_id = y.gl_acct_id
                                  AND y.gacc_tran_id = a.tran_id)
                   AND tran_flag <> 'D'
                   AND ((TRUNC (tran_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy') AND p_tran_post = 'T') 
                            OR (TRUNC (a.posting_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy') --Modified by pjsantos 11/09/2016, added alias to column posting_date from giac_acctrans. GENQA 5742
                            AND p_tran_post = 'P'))
                   AND d.line_cd = NVL (p_line_cd, d.line_cd)
                   AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg2 (NULL, a.gibr_branch_cd, p_module_id, p_user_id) = 1
              GROUP BY d.line_cd, a.gibr_branch_cd, a.tran_date, a.posting_date,
                       a.tran_flag, a.tran_class, 
                       LPAD (e.or_pref_suf, 5, ' ') || '-' || LPAD (e.or_no, 10, 0),
                       dv_pref || '-' || dv_no,
                       jv_pref_suff || '-' || LPAD (jv_no, 6, '0'),
                       d.booking_mth, d.booking_year
              ORDER BY 1, 3, 5)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.tran_date := i.tran_date;
         v_list.tran_date2 := TO_CHAR(i.tran_date, 'MM/DD/YYYY HH:MI:SS AM');
         v_list.posting_date := i.posting_date;
         v_list.posint_date2 := TO_CHAR(i.posting_date, 'MM/DD/YYYY HH:MI:SS AM');
         v_list.tran_flag := i.tran_flag;
         v_list.tran_class := i.tran_class;
           
         BEGIN
            SELECT line_cd||' - '||line_name
              INTO v_list.line
              FROM giis_line
             WHERE line_cd = i.line_cd;
             
            SELECT branch_cd||' - '||branch_name
              INTO v_list.branch
              FROM giac_branches
             WHERE branch_cd = i.gibr_branch_cd;    
         END;
         
         IF NVL(i.or_no,'-') <> '-' THEN
		    v_list.ref_no := i.or_no;
            v_check := 'OR';
         ELSIF NVL(i.dv_no,'-') <> '-' THEN
  	        v_list.ref_no := i.dv_no;
            v_check := 'DV';
         ELSE
  	        v_list.ref_no := i.jv_no;
            v_check := 'JV';  	
         END IF;
         
         IF TO_DATE(TO_CHAR(i.tran_date,'MONTH/RRRR'),'MONTH/RRRR') < TO_DATE(i.booking_mth||'/'||i.booking_year,'MONTH/RRRR') THEN     
  	        v_list.prem_recv := 0;
  	        v_list.prem_dep := i.collection_amt;
         ELSE	     
  	        v_list.prem_recv := i.collection_amt;
  	        v_list.prem_dep := 0;  	 
         END IF; 
         
         v_list.ref_no_used := v_check;
         
         GIACR178_PKG.get_ae_amounts(
            i.line_cd,
            i.gibr_branch_cd,
            p_module_id,
            p_user_id,
            i.tran_date,
            i.posting_date,
            i.tran_flag,
            i.tran_class,
            v_list.ref_no,
            v_check,
            v_list.ae_prem_recv,
            v_list.ae_prem_dep,
            v_list.tran_id
         ); 
         
         v_list.discrepancy_pr := v_list.prem_recv - v_list.ae_prem_recv;
         v_list.discrepancy_pd := v_list.prem_dep - v_list.ae_prem_dep;
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
                  
         PIPE ROW(v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         PIPE ROW(v_list);
      END IF;
      
   END get_giacr178;
   

   PROCEDURE get_ae_amounts(
      p_line_cd         IN VARCHAR2,
      p_branch_cd       IN VARCHAR2,
      p_module_id       IN VARCHAR2,
      p_user_id         IN VARCHAR2,
      p_tran_date       IN DATE,
      p_posting_date    IN DATE,
      p_tran_flag       IN VARCHAR2,
      p_tran_class      IN VARCHAR2,
      p_ref_no          IN VARCHAR2,
      p_ref_used        IN VARCHAR2,
      p_ae_prem_recv    OUT NUMBER,
      p_ae_prem_dep     OUT NUMBER,
      p_tran_id         OUT NUMBER
   )
   IS
      v_list             ae_amounts_type;
      v_gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE;
      v_ae_prem_recv     giac_acct_entries.debit_amt%TYPE:=0;
      v_debit_credit     giac_acct_entries.debit_amt%TYPE;
      v_tran_id          giac_acctrans.tran_id%TYPE;
   BEGIN
   
   
      BEGIN
         FOR i IN (SELECT a.tran_id
                   FROM giac_acctrans a,
                        giac_direct_prem_collns b,
                        giac_order_of_payts e,
                        giac_disb_vouchers f,
                        gipi_invoice c,
                        gipi_polbasic d
                  WHERE a.tran_id = b.gacc_tran_id
                    AND b.b140_iss_cd = c.iss_cd
                    AND b.b140_prem_seq_no = c.prem_seq_no
                    AND c.policy_id = d.policy_id
                    AND a.tran_id = e.gacc_tran_id(+)
                    AND a.tran_id = f.gacc_tran_id(+)
                    AND EXISTS (SELECT 1
                                  FROM giac_chart_of_accts z, giac_acct_entries y
                                 WHERE ((z.gl_acct_name LIKE 'PREMIUM%RECEIVABLE%'
                                         AND EXISTS (SELECT 1
                                                       FROM giis_line x
                                                      WHERE x.acct_line_cd = y.gl_sub_acct_1
                                                        AND x.line_cd = d.line_cd))
                                         OR (z.gl_acct_name LIKE 'PREMIUM%DEPOSIT%'))
                                   AND z.gl_acct_id = y.gl_acct_id
                                   AND y.gacc_tran_id = a.tran_id)
                    AND tran_flag <> 'D'
                    AND d.line_cd = NVL (p_line_cd, d.line_cd)
                    AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
                    AND check_user_per_iss_cd_acctg2 (NULL, a.gibr_branch_cd, p_module_id, p_user_id) = 1
                    AND a.tran_date = p_tran_date
                    AND NVL(a.posting_date, SYSDATE) = NVL(p_posting_date, NVL(a.posting_date, SYSDATE))
                    AND a.tran_flag = p_tran_flag
                    AND a.tran_class = p_tran_class
                    AND DECODE(p_ref_used,
                               'OR', LPAD (e.or_pref_suf, 5, ' ') || '-' || LPAD (e.or_no, 10, 0),
                               'DV', dv_pref || '-' || dv_no,
                               'JV', jv_pref_suff || '-' || LPAD (jv_no, 6, '0')) = p_ref_no)
         LOOP
            v_tran_id := i.tran_id;
         END LOOP;                         
      END;
      
      p_tran_id := v_tran_id; 
      
      FOR c1 IN (SELECT SUM(credit_amt) - SUM(debit_amt) debit_credit
                   FROM giac_acct_entries y                    
   	 	          WHERE y.gacc_tran_id = v_tran_id
   	 	            AND EXISTS (SELECT 1
   	 	                          FROM giac_chart_of_accts z
   	 	                         WHERE ((z.gl_acct_name LIKE 'PREMIUM%RECEIVABLE%' 
   	 	                                 AND EXISTS (SELECT 1
						                               FROM giis_line x
									                  WHERE x.acct_line_cd = y.gl_sub_acct_1
									                    AND x.line_cd = p_line_cd))
   		                            OR (z.gl_acct_name LIKE 'PREMIUM%DEPOSIT%'))
			        AND z.gl_acct_id = y.gl_acct_id))
      LOOP
  	     v_debit_credit := c1.debit_credit;
     END LOOP;						      
     
     FOR c1 IN (SELECT z.gl_acct_name 
                  FROM giac_chart_of_accts z, 
                       giac_acct_entries y
   	 	         WHERE ((z.gl_acct_name LIKE 'PREMIUM%RECEIVABLE%'
   	 	                 AND EXISTS (SELECT 1
						               FROM giis_line x
									  WHERE x.acct_line_cd = y.gl_sub_acct_1
									    AND x.line_cd = p_line_cd))
   	 	                  OR (z.gl_acct_name LIKE 'PREMIUM%DEPOSIT%'))
				   AND z.gl_acct_id = y.gl_acct_id
				   AND y.gacc_tran_id = v_tran_id)
        LOOP
  	       v_gl_acct_name := c1.gl_acct_name;
        END LOOP;						      
  
        IF v_gl_acct_name LIKE 'PREMIUM%RECEIVABLE%' THEN 
  	       p_ae_prem_recv := v_debit_credit;
  	       p_ae_prem_dep := 0;  	 
        ELSE
  	       p_ae_prem_recv := 0;
  	      p_ae_prem_dep := v_debit_credit;
        END IF;  
   END get_ae_amounts;
   
   FUNCTION get_bill_no_grp (
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_tran_date       VARCHAR2,
      p_posting_date    VARCHAR2,
      p_tran_flag       VARCHAR2,
      p_tran_class      VARCHAR2,
      p_ref_no          VARCHAR2,
      p_ref_used        VARCHAR2
   )
      RETURN bill_no_grp_tab PIPELINED
   IS
      v_list bill_no_grp_type;
      v_tran_date DATE := TO_DATE(p_tran_date, 'MM/DD/YYYY HH:MI:SS AM');
      v_posting_date DATE := TO_DATE(p_posting_date, 'MM/DD/YYYY HH:MI:SS AM');
   BEGIN
      FOR i IN (SELECT b.b140_iss_cd
                       || '-'
                       || LPAD (b.b140_prem_seq_no, 12, '0') bill_no,
                       b.last_update, 
                       d.booking_mth, d.booking_year, d.acct_ent_date
                  FROM giac_acctrans a,
                       giac_direct_prem_collns b,
                       giac_order_of_payts e,
                       giac_disb_vouchers f,
                       gipi_invoice c,
                       gipi_polbasic d
                 WHERE a.tran_id = b.gacc_tran_id
                    AND b.b140_iss_cd = c.iss_cd
                    AND b.b140_prem_seq_no = c.prem_seq_no
                    AND c.policy_id = d.policy_id
                    AND a.tran_id = e.gacc_tran_id(+)
                    AND a.tran_id = f.gacc_tran_id(+)
                    AND EXISTS (SELECT 1
                                  FROM giac_chart_of_accts z, giac_acct_entries y
                                 WHERE ((z.gl_acct_name LIKE 'PREMIUM%RECEIVABLE%'
                                         AND EXISTS (SELECT 1
                                                       FROM giis_line x
                                                      WHERE x.acct_line_cd = y.gl_sub_acct_1
                                                        AND x.line_cd = d.line_cd))
                                         OR (z.gl_acct_name LIKE 'PREMIUM%DEPOSIT%'))
                                   AND z.gl_acct_id = y.gl_acct_id
                                   AND y.gacc_tran_id = a.tran_id)
                    AND tran_flag <> 'D'
                    AND d.line_cd = NVL (p_line_cd, d.line_cd)
                    AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
                    AND check_user_per_iss_cd_acctg2 (NULL, a.gibr_branch_cd, p_module_id, p_user_id) = 1
                    AND TO_CHAR(a.tran_date, 'MM/DD/YYYY HH:MI:SS AM') = TO_CHAR(v_tran_date, 'MM/DD/YYYY HH:MI:SS AM')
                    AND NVL(TO_CHAR(a.posting_date, 'MM/DD/YYYY HH:MI:SS AM'), 'x') = NVL(TO_CHAR(v_posting_date, 'MM/DD/YYYY HH:MI:SS AM'), NVL(TO_CHAR(a.posting_date, 'MM/DD/YYYY HH:MI:SS AM'), 'x'))
                    AND a.tran_flag = p_tran_flag
                    AND a.tran_class = p_tran_class
                    AND DECODE(p_ref_used,
                               'OR', LPAD (e.or_pref_suf, 5, ' ') || '-' || LPAD (e.or_no, 10, 0),
                               'DV', dv_pref || '-' || dv_no,
                               'JV', jv_pref_suff || '-' || LPAD (jv_no, 6, '0')) = p_ref_no
               ORDER BY 1)
      LOOP
         v_list.bill_no := i.bill_no;
         v_list.booking_mth := i.booking_mth;
         v_list.booking_year := i.booking_year;
         v_list.create_date := i.last_update;
         v_list.acct_ent_date := i.acct_ent_date;
         
         BEGIN
            FOR b IN (SELECT DISTINCT a.last_update
                        FROM giac_acct_entries a,
                             giac_acctrans b
                       WHERE b.tran_class='PRD'
                         AND b.tran_flag IN ('C','P')
                         AND a.gacc_tran_id = b.tran_id                
                         AND TRUNC(b.tran_date) = v_list.acct_ent_date                             
                       ORDER BY a.last_update)
            LOOP
               v_list.batch_date := b.last_update;
            END LOOP;              
         END;
         
          
         PIPE ROW(v_list);
      END LOOP;
   END get_bill_no_grp;
   
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giclr257b_pkg
AS
   FUNCTION get_main (
      p_payee_no     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_user_id      VARCHAR2,
      p_search_by    VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
      v_payee_class_cd giac_parameters.param_value_v%TYPE;
      v_row_count NUMBER := 0;
      v_col_count NUMBER := 0;
      v_aging_exists VARCHAR2(1) := 'N';
      v_paid_amt NUMBER := 0;
   BEGIN
   
      v_list.company_name := giacp.v('COMPANY_NAME');
      v_list.company_address := giacp.v('COMPANY_ADDRESS');
      
      IF p_search_by = 1 THEN
         v_list.dsp_date := 'Claim File Date';
      ELSIF p_search_by = 2 THEN
         v_list.dsp_date := 'Loss Date';
      ELSIF p_search_by = 3 THEN
         v_list.dsp_date := 'Date Assigned';      
      END IF;
      
      IF p_as_of_date IS NULL THEN
         v_list.dsp_date := v_list.dsp_date || ' From ' || TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')
                            || ' To ' || TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
      ELSE
         v_list.dsp_date := v_list.dsp_date || ' As Of ' || TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');                               
      END IF;
   
      BEGIN
         SELECT param_value_v
           INTO v_payee_class_cd
           FROM giac_parameters
          WHERE param_name = 'ADJP_CLASS_CD';
      EXCEPTION WHEN OTHERS THEN
         v_payee_class_cd := NULL;
      END;
      
      BEGIN
         SELECT CEIL(COUNT(*)/ 4)
           INTO v_list.col_count
           FROM giis_report_aging
          WHERE report_id = 'GICLR257B';
      EXCEPTION WHEN OTHERS THEN
         v_list.col_count := 0;
      END;
   
      FOR i IN (SELECT b.payee_no, TRIM(DECODE (b.payee_first_name, '-', b.payee_last_name, b.payee_first_name
                                           || ' ' || b.payee_middle_name || ' ' || b.payee_last_name)) payee_name,
                       b.payee_class_cd, a.claim_id
                  FROM giis_payees b,
                       gicl_claims a,
                       giis_clm_stat f,
                       gicl_clm_adjuster d
                 WHERE b.payee_no = NVL(p_payee_no, b.payee_no) 
                   AND b.payee_class_cd = v_payee_class_cd
                   AND f.clm_stat_cd = a.clm_stat_cd
                   AND a.claim_id = d.claim_id
                   AND b.payee_no = d.adj_company_cd
                   AND d.complt_date IS NULL
                   AND d.cancel_tag IS NULL
                   AND (TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        <= TRUNC(TO_DATE(p_as_of_date, 'mm-dd-yyyy'))
                        OR TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        BETWEEN TRUNC(TO_DATE(p_from_date, 'mm-dd-yyyy')) AND TRUNC(TO_DATE(p_to_date, 'mm-dd-yyyy')))
                   AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS257', p_user_id) = 1
              ORDER BY b.payee_no)
      LOOP
         v_list.payee_no := i.payee_no;
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.payee_name := i.payee_name;
         v_row_count := 0;
         v_col_count := 0;
         
         FOR j IN (SELECT column_title, min_days, max_days
                     FROM giis_report_aging
                    WHERE report_id = 'GICLR257B'
                    ORDER BY column_no)
         LOOP
            v_col_count := v_col_count + 1;
            v_aging_exists := 'Y';
            
            IF v_col_count = 1 THEN
               v_list.col1 := j.column_title;
               v_row_count := v_row_count + 1;
            ELSIF v_col_count = 2 THEN
               v_list.col2 := j.column_title;
            ELSIF v_col_count = 3 THEN
               v_list.col3 := j.column_title;
            ELSIF v_col_count = 4 THEN
               v_list.col4 := j.column_title;
               v_list.dummy := i.payee_no || '_' || i.payee_class_cd || '_' || v_row_count;
               PIPE ROW(v_list);
               v_list.col1 := NULL;
               v_list.col2 := NULL;
               v_list.col3 := NULL;
               v_list.col4 := NULL;
               v_list.dummy := NULL;
               v_col_count := 0;         
            END IF;
            
         END LOOP;
         
         IF (v_col_count != 0 AND v_aging_exists = 'Y') OR (v_col_count = 0 AND v_aging_exists = 'N') THEN
            v_list.dummy := i.payee_no || '_' || i.payee_class_cd || '_' || v_row_count;
            PIPE ROW(v_list);
         END IF;
           
      END LOOP;
      
      IF v_list.payee_no IS NULL THEN
         PIPE ROW(v_list);
      END IF; 
   END get_main;
   
   FUNCTION get_details (
      p_payee_no       VARCHAR2,
      p_payee_class_cd VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_as_of_date     VARCHAR2,
      p_user_id        VARCHAR2,
      p_search_by      VARCHAR2
   )
      RETURN detail_tab PIPELINED
   IS
      v_list detail_type;
      v_payee_class_cd giac_parameters.param_value_v%TYPE;
      v_row_count NUMBER := 0;
      v_col_count NUMBER := 0;
      v_aging_exists VARCHAR2(1) := 'N';
      v_paid_amt NUMBER := 0;
   BEGIN
   
      BEGIN
         SELECT param_value_v
           INTO v_payee_class_cd
           FROM giac_parameters
          WHERE param_name = 'ADJP_CLASS_CD';
      EXCEPTION WHEN OTHERS THEN
         v_payee_class_cd := NULL;
      END;
   
      FOR i IN (SELECT a.claim_id, get_clm_no(a.claim_id) claim_no,
                       a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.pol_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                       a.assd_no, a.loss_date, a.clm_file_date, a.clm_stat_cd,
                       d.assign_date
                  FROM giis_payees b,
                       gicl_claims a,
                       giis_clm_stat f,
                       gicl_clm_adjuster d
                 WHERE b.payee_no = p_payee_no 
                   AND b.payee_class_cd = v_payee_class_cd
                   AND f.clm_stat_cd = a.clm_stat_cd
                   AND a.claim_id = d.claim_id
                   AND b.payee_no = d.adj_company_cd
                   AND d.complt_date IS NULL
                   AND d.cancel_tag IS NULL
                   AND (TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        <= TRUNC(TO_DATE(p_as_of_date, 'mm-dd-yyyy'))
                        OR TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        BETWEEN TRUNC(TO_DATE(p_from_date, 'mm-dd-yyyy')) AND TRUNC(TO_DATE(p_to_date, 'mm-dd-yyyy')))
                   AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS257', p_user_id) = 1
              ORDER BY b.payee_first_name, b.payee_last_name,b.payee_middle_name,
                       a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no, a.assured_name, a.issue_yy, a.renew_no,
                       a.pol_seq_no, a.loss_date, d.priv_adj_cd, d.adj_company_cd, b.payee_class_cd,a.clm_file_date)
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.assign_date := i.assign_date;
         v_list.claim_id := i.claim_id;
         v_col_count := 0;
         v_row_count := 0;
         
         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION WHEN OTHERS THEN
            v_list.assd_name := NULL;     
         END;
         
         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION WHEN OTHERS THEN
               v_list.clm_stat_desc := NULL;
         END;
         
         FOR j IN (SELECT column_title, min_days, max_days
                     FROM giis_report_aging
                    WHERE report_id = 'GICLR257B'
                    ORDER BY column_no)
         LOOP
            v_col_count := v_col_count + 1;
            v_aging_exists := 'Y';
            v_paid_amt := 0;            
            
            IF v_col_count = 1 THEN
               v_row_count := v_row_count + 1;
            ELSIF v_col_count = 4 THEN
               v_list.dummy := p_payee_no || '_' || p_payee_class_cd || '_' || v_row_count;
               PIPE ROW(v_list);
               v_list.dummy := NULL;
               v_col_count := 0;
               v_paid_amt := NULL;
            END IF;
            
         END LOOP;
         
         IF (v_col_count != 0 AND v_aging_exists = 'Y') OR (v_col_count = 0 AND v_aging_exists = 'N') THEN
            v_list.dummy := p_payee_no || '_' || p_payee_class_cd || '_' || v_row_count;
            PIPE ROW(v_list);  
         END IF;
      END LOOP;
   END get_details;
   
   FUNCTION get_grand_totals (
      p_payee_no     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_user_id      VARCHAR2,
      p_search_by    VARCHAR2
   )
      RETURN tot_tab PIPELINED
   IS
      v_list tot_type;
   BEGIN
      FOR i IN (SELECT SUM (tot1) tot1, SUM (tot2)tot2, SUM (tot3)tot3,
                       SUM (tot4) tot4, SUBSTR (dummy, INSTR (dummy, '_', 1, 2) + 1) AS row_no
                  FROM TABLE (giclr257b_pkg.get_main (p_payee_no,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_as_of_date,
                                                    p_user_id,
                                                    p_search_by))
              GROUP BY col1, col2, col3, col4, SUBSTR (dummy, INSTR (dummy, '_', 1, 2) + 1)
              ORDER BY SUBSTR (dummy, INSTR (dummy, '_', 1, 2) + 1))
      LOOP
         v_list.tot1 := i.tot1;
         v_list.tot2 := i.tot2;
         v_list.tot3 := i.tot3;
         v_list.tot4 := i.tot4;
         v_list.row_no := i.row_no;
         
         PIPE ROW(v_list);
         
      END LOOP;
   END get_grand_totals;
   
   FUNCTION get_amounts (
      p_policy_number    VARCHAR2,
      p_claim_id         VARCHAR2,
      p_payee_no         VARCHAR2,
      p_payee_class_cd   VARCHAR2
   )
      RETURN amount_tab PIPELINED
   IS
      v_list amount_type;
      v_days_outstanding NUMBER;
      v_paid_amt NUMBER;
      v_row_no NUMBER;
      v_col_no NUMBER;
   BEGIN
   
      FOR i IN (SELECT * FROM(SELECT b.payee_no,
                                     a.line_cd
                                     || '-'
                                     || a.subline_cd
                                     || '-'
                                     || a.pol_iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
                                     d.claim_id
                                FROM giis_payees b, gicl_claims a, giis_clm_stat f, gicl_clm_adjuster d
                               WHERE b.payee_class_cd = p_payee_class_cd
                                 AND f.clm_stat_cd = a.clm_stat_cd
                                 AND a.claim_id = d.claim_id
                                 AND b.payee_no = d.adj_company_cd
                                 AND d.complt_date IS NULL
                                 AND d.cancel_tag IS NULL)
                 WHERE claim_id = NVL(p_claim_id, claim_id)
                   AND policy_number LIKE NVL(p_policy_number, '%')
                   AND payee_no = p_payee_no)
      LOOP
         v_row_no := 1;
         v_col_no := 0;
         
         FOR k IN (SELECT assign_date
                     FROM gicl_clm_adjuster
                    WHERE claim_id = i.claim_id)
         LOOP
            v_days_outstanding := TRUNC(SYSDATE) - TRUNC(k.assign_date);
         END LOOP;
      
         FOR j IN (SELECT min_days, max_days
                     FROM giis_report_aging
                    WHERE report_id = 'GICLR257B')
         LOOP
            v_col_no := v_col_no + 1;
            
            IF v_days_outstanding BETWEEN j.min_days AND j.max_days THEN
               BEGIN
                  SELECT NVL(SUM(paid_amt), 0)
                    INTO v_paid_amt
                    FROM gicl_clm_loss_exp
                   WHERE payee_cd = p_payee_no
                     AND payee_class_cd = p_payee_class_cd
                     AND tran_id IS NOT NULL
                     AND claim_id = i.claim_id;  
               END;
            ELSE
               v_paid_amt := 0;   
            END IF;
            
            IF v_col_no = 1 THEN
               v_list.col1 := v_paid_amt;
            ELSIF v_col_no = 2 THEN
               v_list.col2 := v_paid_amt;
            ELSIF v_col_no = 3 THEN
               v_list.col3 := v_paid_amt;
            ELSIF v_col_no = 4 THEN
               v_list.col4 := v_paid_amt;
               v_list.row_no := v_row_no;
               PIPE ROW(v_list);
               v_row_no := v_row_no + 1;
               v_col_no := 0;
               v_list.col1 := NULL;
               v_list.col2 := NULL;
               v_list.col3 := NULL;
               v_list.col4 := NULL;
            END IF;
            
         END LOOP;
         
         IF v_col_no != 0 THEN
            v_list.row_no := v_row_no;
            PIPE ROW(v_list);
         END IF;
      
      END LOOP;
   END get_amounts;
   
   FUNCTION get_totals (
      p_payee_no         VARCHAR2,
      p_payee_class_cd   VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_user_id          VARCHAR2,
      p_search_by        VARCHAR2,
      p_dummy            VARCHAR2
   )
      RETURN amount_tab PIPELINED
   IS
      v_col1   NUMBER := 0;
      v_col2   NUMBER := 0;
      v_col3   NUMBER := 0;
      v_col4   NUMBER := 0;
      v_list amount_type;
   BEGIN
   
      v_list.col1 := 0;
      v_list.col2 := 0;
      v_list.col3 := 0;
      v_list.col4 := 0;
   
      FOR i IN (SELECT claim_id, policy_no, dummy
                  FROM TABLE (giclr257b_pkg.get_details (p_payee_no,
                                                           p_payee_class_cd,
                                                           p_from_date,
                                                           p_to_date,
                                                           p_as_of_date,
                                                           p_user_id,
                                                           p_search_by
                                                          )
                             )
                 WHERE dummy LIKE p_dummy)
      LOOP
         BEGIN
            SELECT SUM (col1), SUM (col2), SUM (col3), SUM (col4)
              INTO v_col1, v_col2, v_col3, v_col4
              FROM TABLE (giclr257b_pkg.get_amounts (i.policy_no,
                                                       i.claim_id,
                                                       p_payee_no,
                                                       p_payee_class_cd
                                                      )
                         )
             WHERE row_no = SUBSTR (i.dummy, INSTR (i.dummy, '_', 1, 2) + 1);
         END;
         
         v_list.col1 := v_list.col1 + v_col1;
         v_list.col2 := v_list.col2 + v_col2;
         v_list.col3 := v_list.col3 + v_col3;
         v_list.col4 := v_list.col4 + v_col4;        
         
      END LOOP;
      
      PIPE ROW(v_list);
   END get_totals;
   
   FUNCTION get_grand_tots (
      p_payee_no         VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_user_id          VARCHAR2,
      p_search_by        VARCHAR2,
      p_dummy            VARCHAR2
   )
      RETURN amount_tab PIPELINED
   IS
      v_payee_class_cd giac_parameters.param_value_v%TYPE;
      v_col1 NUMBER;
      v_col2 NUMBER;
      v_col3 NUMBER;
      v_col4 NUMBER;
      v_list amount_type;
   BEGIN
   
      v_list.col1 := 0;
      v_list.col2 := 0;
      v_list.col3 := 0;
      v_list.col4 := 0;
   
      BEGIN
         SELECT param_value_v
           INTO v_payee_class_cd
           FROM giac_parameters
          WHERE param_name = 'ADJP_CLASS_CD';
      EXCEPTION WHEN OTHERS THEN
         v_payee_class_cd := NULL;
      END;
   
      FOR i IN (SELECT a.claim_id, b.payee_no, a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.pol_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no
                  FROM giis_payees b,
                       gicl_claims a,
                       giis_clm_stat f,
                       gicl_clm_adjuster d
                 WHERE b.payee_no = NVL(p_payee_no, b.payee_no) 
                   AND b.payee_class_cd = v_payee_class_cd
                   AND f.clm_stat_cd = a.clm_stat_cd
                   AND a.claim_id = d.claim_id
                   AND b.payee_no = d.adj_company_cd
                   AND d.complt_date IS NULL
                   AND d.cancel_tag IS NULL
                   AND (TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        <= TRUNC(TO_DATE(p_as_of_date, 'mm-dd-yyyy'))
                        OR TRUNC(DECODE (p_search_by, 1, a.clm_file_date, 2, a.loss_date, 3, d.assign_date, a.clm_file_date))
                        BETWEEN TRUNC(TO_DATE(p_from_date, 'mm-dd-yyyy')) AND TRUNC(TO_DATE(p_to_date, 'mm-dd-yyyy')))
                   AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS257', p_user_id) = 1
              ORDER BY b.payee_no)
      LOOP
         BEGIN
            SELECT SUM (col1), SUM (col2), SUM (col3), SUM (col4)
              INTO v_col1, v_col2, v_col3, v_col4
              FROM TABLE (giclr257b_pkg.get_amounts (i.policy_no,
                                                       i.claim_id,
                                                       i.payee_no,
                                                       v_payee_class_cd
                                                      )
                         )
             WHERE row_no = SUBSTR (p_dummy, INSTR (p_dummy, '_', 1, 2) + 1);
         END;
         
         v_list.col1 := v_list.col1 + v_col1;
         v_list.col2 := v_list.col2 + v_col2;
         v_list.col3 := v_list.col3 + v_col3;
         v_list.col4 := v_list.col4 + v_col4;
         
      END LOOP;
      
         PIPE ROW(v_list);
      
   END get_grand_tots;   
END;
/



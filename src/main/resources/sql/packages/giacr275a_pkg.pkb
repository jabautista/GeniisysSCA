CREATE OR REPLACE PACKAGE BODY CPI.giacr275a_pkg
AS
   FUNCTION get_giacr_275a_report (
      p_cut_off_date    VARCHAR2,
      p_cut_off_param   VARCHAR2,
      p_date_param      VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_iss_param       VARCHAR2,
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT a.branch_cd || ' - ' || b.iss_name branch,
                       a.line_cd || ' - ' || c.line_name line,
                          a.intm_no
                       || ' - '
                       || d.ref_intm_cd
                       || ' - '
                       || d.intm_name intm,
                       a.policy_id, a.policy_no, e.assd_name, a.incept_date,
                       a.iss_cd || '-' || a.prem_seq_no bill_no, a.iss_cd,
                       a.prem_seq_no, a.share_percentage, a.premium_amt,
                       a.tax_amt, (a.premium_amt + a.tax_amt) amount_due
                  FROM giac_intm_prod_colln_ext a,
                       giis_issource b,
                       giis_line c,
                       giis_intermediary d,
                       giis_assured e
                 WHERE a.branch_cd = b.iss_cd
                   AND a.line_cd = c.line_cd
                   AND a.intm_no = d.intm_no
                   AND a.assd_no = e.assd_no
                   AND UPPER (a.user_id) = UPPER (p_user_id)
                   AND a.branch_cd = NVL (p_iss_cd, a.branch_cd)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   AND a.intm_no = NVL (p_intm_no, a.intm_no))
      LOOP
         FOR c IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPANY_NAME')
         LOOP
            v_list.company_name := c.param_value_v;
         END LOOP;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         IF p_cut_off_date IS NOT NULL
         THEN
            v_list.cut_off :=
                  'Cut-Off '
               || TO_CHAR (TO_DATE (p_cut_off_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
         THEN
            v_list.from_to :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         v_list.branch := i.branch;
         v_list.line := i.line;
         v_list.intm := i.intm;
         v_list.policy_no := i.policy_no;
         v_list.assd_name := i.assd_name;
         v_list.incept_date := i.incept_date;
         v_list.bill_no := i.bill_no;
         v_list.premium_amt := i.premium_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.amount_due := i.amount_due;
         v_list.policy_id := i.policy_id;
         v_list.share_percentage := i.share_percentage;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.iss_cd := i.iss_cd;
            
--         BEGIN
--            SELECT DECODE (p_cut_off_param, 1, tran_date, posting_date) ref_date, ref_no,
--                   collection_amt * (i.share_percentage / 100) collection_amt
--             INTO v_list.ref_date, v_list.ref_no, v_list.collection_amt      
--             FROM giac_premium_colln_v
--            WHERE TRUNC (DECODE (p_cut_off_param, 1, tran_date, posting_date)) <= TO_DATE (p_cut_off_date, 'mm/dd/yyyy')
--              AND iss_cd = i.iss_cd
--              AND prem_seq_no = i.prem_seq_no;
--            
--         EXCEPTION WHEN NO_DATA_FOUND THEN
--            v_list.ref_date := NULL;
--            v_list.ref_no := NULL;
--            v_list.collection_amt := 0;
--                   WHEN OTHERS THEN
--            v_list.ref_date := NULL;
--            v_list.ref_no := NULL;
--            v_list.collection_amt := 0;   
--         END;
         
         
--         FOR z IN
--            (SELECT iss_cd iss_cd_colln, prem_seq_no prem_seq_no_colln,
--                    tran_id, tran_class,
--                    DECODE (p_cut_off_param,
--                            1, tran_date,
--                            posting_date
--                           ) ref_date,
--                    ref_no,
--                      collection_amt
--                    * (i.share_percentage / 100) collection_amt
--                                            --, SUM(collection_amt) cs_balance
--               FROM giac_premium_colln_v
--              WHERE TRUNC (DECODE (p_cut_off_param,
--                                   1, tran_date,
--                                   posting_date
--                                  )
--                          ) <= TO_DATE (p_cut_off_date, 'mm/dd/yyyy')
--                AND iss_cd = i.iss_cd
--                AND prem_seq_no = i.prem_seq_no)
--         LOOP
--            v_list.ref_date := z.ref_date;
--            v_list.ref_no := z.ref_no;
--            v_list.collection_amt := z.collection_amt;
--         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         FOR c IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPANY_NAME')
         LOOP
            v_list.company_name := c.param_value_v;
         END LOOP;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         IF p_cut_off_date IS NOT NULL
         THEN
            v_list.cut_off :=
                  'Cut-Off '
               || TO_CHAR (TO_DATE (p_cut_off_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
         THEN
            v_list.from_to :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;
         
         PIPE ROW(v_list);
      END IF;
   END get_giacr_275a_report;
   
   FUNCTION get_colls (
      p_cut_off_date        VARCHAR2,
      p_cut_off_param       VARCHAR2,
      p_share_percentage    NUMBER,
      p_iss_cd              VARCHAR2,
      p_prem_seq_no         NUMBER,
      p_amount_due          NUMBER
   )
      RETURN colls_tab PIPELINED
   IS
      v_list colls_type;
   BEGIN
      FOR i IN (SELECT iss_cd iss_cd_colln, prem_seq_no prem_seq_no_colln, tran_id,
                       tran_class,
                       DECODE (p_cut_off_param, 1, tran_date, posting_date) ref_date, ref_no,
                       collection_amt * (p_share_percentage / 100) collection_amt
                  FROM giac_premium_colln_v
                 WHERE TRUNC (DECODE (p_cut_off_param, 1, tran_date, posting_date)) <= TO_DATE(p_cut_off_date, 'mm-dd-yyyy')
                   AND iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_list.tran_id := i.tran_id;
         v_list.tran_class := i.tran_class;
         v_list.ref_date := i.ref_date;
         v_list.ref_no := i.ref_no;
         v_list.collection_amt := NVL(i.collection_amt, 0);
         
         IF v_list.balance_due IS NULL THEN
            BEGIN
               SELECT p_amount_due - SUM(collection_amt * (p_share_percentage / 100))
                 INTO v_list.balance_due
                 FROM giac_premium_colln_v
                WHERE TRUNC (DECODE (p_cut_off_param, 1, tran_date, posting_date)) <= TO_DATE(p_cut_off_date, 'mm-dd-yyyy')
                  AND iss_cd = p_iss_cd
                  AND prem_seq_no = p_prem_seq_no;  
            END; 
         END IF;
      
         PIPE ROW(v_list);
      END LOOP;
      
      IF v_list.tran_id IS NULL THEN
         v_list.collection_amt := 0;
         v_list.balance_due := p_amount_due;
         PIPE ROW(v_list);
      END IF;
      
   END get_colls;
      
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIACS328_PKG 
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 06.04.2013
    **  Reference By : GIACS328 - AGING OF COLLECTIONS
    */
   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN brach_lov_tab PIPELINED
   IS
      v_branch   brach_lov_type;
   BEGIN
      FOR i IN (SELECT   UPPER (iss_cd) branch_cd,
                         UPPER (iss_name) branch_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                       iss_cd,
                                                       'GIACS328',
                                                       p_user_id
                                                      ) = 1
                ORDER BY 1)
      LOOP
         v_branch.iss_cd := i.branch_cd;
         v_branch.iss_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;

      RETURN;
   END get_branch_lov;

   PROCEDURE get_last_extract_param (
      p_user_id     giis_users.user_id%TYPE,
      p_from_date   OUT   VARCHAR2,
      p_to_date     OUT   VARCHAR2,
      p_extract_by  OUT   VARCHAR2,
      p_iss_cd      OUT   VARCHAR2,
      p_iss_name    OUT   VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT TO_CHAR (param_from_date, 'MM-DD-YYYY'), TO_CHAR (param_to_date, 'MM-DD-YYYY'), param_extract_by, param_branch_cd
           INTO p_from_date, p_to_date, p_extract_by, p_iss_cd
           FROM giac_aging_prem_paid_ext
          WHERE user_id = p_user_id AND ROWNUM = 1;
          
         
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_from_date := '';
            p_to_date := '';
            p_extract_by := '';
            p_iss_cd := '';
      END;
      
      BEGIN
         SELECT iss_name
           INTO p_iss_name 
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_iss_name := 'ALL BRANCHES';
      END;
      
   END get_last_extract_param;
   
   PROCEDURE extract_aging_of_collections (p_user_id giis_users.user_id%TYPE)
   IS
   BEGIN
      DELETE FROM giac_aging_prem_paid_ext
            WHERE user_id = p_user_id;
   END extract_aging_of_collections;

   PROCEDURE insert_to_aging_ext (
      p_user_id           giis_users.user_id%TYPE,
      p_from_date         DATE,
      p_to_date           DATE,
      p_eff_date          VARCHAR2,
      p_due_date          VARCHAR2,
      p_branch_cd         VARCHAR2,
      p_message     OUT   VARCHAR2
   )
   IS
      v_age           NUMBER;
      v_row_counter   NUMBER := 0;
      v_extract_by    VARCHAR2(1);
      v_column_no     NUMBER; --benjo 11.13.2015 GENQA-SR-5125
   BEGIN
      BEGIN
          DELETE FROM giac_aging_prem_paid_ext
                WHERE user_id = p_user_id;
      END;

      FOR ppa_ext IN
         (SELECT   b.b140_iss_cd iss_cd,
--                   get_policy_no (d.policy_id) policy_no, Comment out by pjsantos 12/13/2016, GENQA 5856
                   i.policy_no,                --Added by pjsantos 12/13/2016
                   b.b140_iss_cd || '-'
                   || TO_CHAR (b.b140_prem_seq_no) bill_no,
                   SUM (b.premium_amt) prem_paid, d.prem_amt,
                   e.intrmdry_intm_no intm_no, f.ref_intm_cd intm_cd,
                   TRUNC (incept_date) i_date, TRUNC (due_date) d_date,
                   TRUNC (g.eff_date) e_date, g.line_cd,
                   trunc(or_date) - trunc(due_date) age -- based on 07.24.2013 version : shan 04.28.2015
              FROM giac_direct_prem_collns b,
                   giac_acctrans c,
                   gipi_invoice d,
                   gipi_comm_invoice e,
                   giis_intermediary f,
                   gipi_polbasic g,
                   giac_order_of_payts h,     -- based on 07.24.2013 version : shan 04.28.2015
                   (SELECT    x.line_cd       -- Added by pjsantos 12/13/2016, for optimization GENQA 5856 
                             || '-'
                             || x.subline_cd
                             || '-'
                             || x.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (x.issue_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (x.pol_seq_no, '0999999'))
                             || '-'
                             || LTRIM (TO_CHAR( x.renew_no, '09'))
                             || DECODE (
                                   NVL (x.endt_seq_no, 0),
                                   0, '',
                                      ' / '
                                   || x.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (x.endt_yy, '09'))
                                   || '-'
                                   || LTRIM (TO_CHAR (x.endt_seq_no, '0999999'))
                                ) policy_no, policy_id
                        FROM gipi_polbasic x) i
             WHERE b.gacc_tran_id = c.tran_id
               AND c.tran_id = h.gacc_tran_id    -- based on 07.24.2013 version : shan 04.28.2015
               AND tran_flag <> 'D'
               AND b140_iss_cd = d.iss_cd
               AND b140_prem_seq_no = d.prem_seq_no
               AND d.iss_cd = e.iss_cd
               AND d.prem_seq_no = e.prem_seq_no
               AND e.intrmdry_intm_no = f.intm_no
               AND d.policy_id = g.policy_id
               AND pol_flag <> '5'
               AND b140_iss_cd = nvl(p_branch_cd, b140_iss_cd) 
               AND NOT EXISTS (
                      SELECT gacc_tran_id
                        FROM giac_acctrans z, giac_reversals t
                       WHERE z.tran_id = t.reversing_tran_id
                         AND z.tran_id = b.gacc_tran_id
                         AND z.tran_flag <> 'D')
--               AND TRUNC (c.tran_date) BETWEEN TO_DATE (   '01'       replaced by Kenneth L. 03.18.2014
--                                                        || TO_CHAR
--                                                                 (p_from_date,
--                                                                  'mmyyyy'
--                                                                 ),
--                                                        'ddmmyy'
--                                                       )
--                                           AND TRUNC (p_to_date)
                                           
               /*  AND TRUNC (c.tran_date) BETWEEN TRUNC (p_from_date)
                               AND TRUNC (p_to_date)*/   -- based on 07.24.2013 version, replacement below : shan 04.28.2015
                AND DECODE(p_eff_date, 'Y', trunc(G.eff_date), 'N', trunc(due_date))  
                        BETWEEN TO_DATE('01' || to_Char(p_from_date,'mmyy'),'ddmmyy')AND  trunc(p_to_date)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                b.b140_iss_cd,
                                                'GIACS328',
                                                p_user_id
                                               ) = 1*/--Replaced by codes below by pjsantos 12/13/2016, for optimization GENQA 5856
                AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS328', p_user_id))
                                WHERE branch_cd = b.b140_iss_cd)
                ANd g.policy_id = i.policy_id
          GROUP BY b140_iss_cd,
                   b140_prem_seq_no,
--                   d.policy_id, Comment out by pjsantos 12/13/2016, GENQA 5856
                   i.policy_no, --Added by pjsantos 12/13/2016, GENQA 5856
                   e.intrmdry_intm_no,
                   f.ref_intm_cd,
                   incept_date,
                   due_date,
                   g.line_cd,
                   g.eff_date,
                   or_date,     -- based on 07.24.2013 version : shan 04.28.2015
                   d.prem_amt)
      LOOP
         /*IF p_eff_date = 'Y'
         THEN
            v_age := p_from_date - ppa_ext.e_date;
            v_extract_by := 'E';
         ELSIF p_due_date = 'Y'
         THEN
            v_age := p_from_date - ppa_ext.d_date;
            v_extract_by := 'D';
         END IF;*/  -- based on 07.24.2013 version, replacement below : shan 04.28.2015
         
        IF ppa_ext.age < 0 THEN 
            v_age := 0;
        ELSE 
            v_age := ppa_ext.age;
        END IF;
        
        /* benjo 11.13.2015 GENQA-SR-5125 */
        BEGIN
           SELECT column_no
             INTO v_column_no
             FROM giis_report_aging
            WHERE report_id = 'GIACR328'
              AND v_age BETWEEN min_days AND max_days
              AND branch_cd IN (SELECT b.grp_iss_cd
                                  FROM giis_users a, giis_user_grp_hdr b
                                 WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id);
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              raise_application_error ('-20001', 'Geniisys Exception#E#No set-up found in aging columns for GIACR328.');
        END;
        
        IF p_eff_date = 'Y'
        THEN
           v_extract_by := 'E';
        ELSIF p_due_date = 'Y'
        THEN
           v_extract_by := 'D';
        END IF;
        /* benjo end */

         v_row_counter := v_row_counter + 1;

         INSERT INTO giac_aging_prem_paid_ext
                     (intm_no, ref_intm_cd, line_cd,
                      iss_cd, invoice_no, policy_no,
                      eff_date, incept_date, prem_amt,
                      gross_prem_amt, age, user_id, last_update,
                      due_date, param_from_date, param_to_date, param_extract_by, param_branch_cd
                     )
              VALUES (ppa_ext.intm_no, ppa_ext.intm_cd, ppa_ext.line_cd,
                      ppa_ext.iss_cd, ppa_ext.bill_no, ppa_ext.policy_no,
                      ppa_ext.e_date, ppa_ext.i_date, ppa_ext.prem_paid,
                      ppa_ext.prem_amt, v_age, p_user_id, SYSDATE,
                      ppa_ext.d_date, p_from_date, p_to_date, v_extract_by, p_branch_cd
                     );
      END LOOP;
      
      p_message :=
            'Extraction finished. '
         || TO_CHAR (v_row_counter)
         || ' records extracted.';
         
      IF v_row_counter = 0
      THEN
      p_message :=
            'Extraction finished. No records extracted.';
      END IF;
      
   END insert_to_aging_ext;
END GIACS328_PKG;
/

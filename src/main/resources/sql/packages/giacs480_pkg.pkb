CREATE OR REPLACE PACKAGE BODY CPI.giacs480_pkg
AS
   FUNCTION get_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_branches
                 WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     'GIACS480',
                                                     p_user_id
                                                    ) = 1
                   AND (   UPPER (branch_cd) LIKE
                                    NVL (UPPER (p_keyword), UPPER (branch_cd))
                        OR UPPER (branch_name) LIKE
                                  NVL (UPPER (p_keyword), UPPER (branch_name))
                       ))
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.branch_name := i.branch_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_company_lov (p_keyword VARCHAR2)
      RETURN company_lov_tab PIPELINED
   IS
      v_rec   company_lov_type;
   BEGIN
      FOR i IN
         (SELECT   payee_no, payee_last_name
              FROM giis_payees
             WHERE payee_class_cd IN (SELECT param_value_v
                                        FROM giac_parameters
                                       WHERE param_name = 'COMPANY_CLASS_CD')
               AND (   TO_CHAR (payee_no) LIKE
                                           NVL (UPPER(p_keyword), TO_CHAR (payee_no))
                    OR UPPER (payee_last_name) LIKE
                                      NVL (UPPER(p_keyword), UPPER (payee_last_name))
                   )
          ORDER BY 2)
      LOOP
         v_rec.payee_no := i.payee_no;
         v_rec.payee_last_name := i.payee_last_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_employee_lov (
      p_company_cd   giis_payees.payee_no%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN employee_lov_tab PIPELINED
   IS
      v_rec   employee_lov_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.ref_payee_cd,
                             a.payee_last_name
                          || DECODE (a.payee_first_name,
                                     NULL, NULL,
                                        ', '
                                     || a.payee_first_name
                                     || ' '
                                     || a.payee_middle_name
                                    ) emp_name
                     FROM giis_payees a, giis_payees b
                    WHERE a.ref_payee_cd IS NOT NULL
                      AND a.payee_class_cd IN giacp.v ('EMP_CLASS_CD')
                      AND a.master_payee_no = b.payee_no
                      AND b.payee_class_cd IN giacp.v ('COMPANY_CLASS_CD')
                      AND b.payee_no = p_company_cd
                      AND (   UPPER (a.ref_payee_cd) LIKE
                                 NVL (UPPER (p_keyword),
                                      UPPER (a.ref_payee_cd)
                                     )
                           OR UPPER (DECODE (a.payee_first_name,
                                             NULL, NULL,
                                                ', '
                                             || a.payee_first_name
                                             || ' '
                                             || a.payee_middle_name
                                            )
                                    ) LIKE
                                 NVL (UPPER (p_keyword),
                                      UPPER (DECODE (a.payee_first_name,
                                                     NULL, NULL,
                                                        ', '
                                                     || a.payee_first_name
                                                     || ' '
                                                     || a.payee_middle_name
                                                    )
                                            )
                                     )
                          )
                 ORDER BY 2)
      LOOP
         v_rec.ref_payee_cd := i.ref_payee_cd;
         v_rec.emp_name := i.emp_name;
         PIPE ROW (v_rec);
      END LOOP;
      
      RETURN;
   END;

   FUNCTION validate_date_params (p_as_of_date VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      SELECT DISTINCT 'Y'
                 INTO v_exist
                 FROM giac_sal_ded_billing_ext
                WHERE as_of_date = p_as_of_date AND user_id = p_user_id;

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END;

   PROCEDURE extract_giacs480 (
      p_as_of_date          DATE,
      p_iss_cd              giac_branches.branch_cd%TYPE,
      p_company_cd          giis_payees.payee_no%TYPE,
      p_employee_cd         giis_payees.ref_payee_cd%TYPE,
      p_user_id             giis_users.user_id%TYPE,
      p_exists        OUT   VARCHAR2
   )
   IS
      v_prem_paid      NUMBER        := 0;
      v_prem_balance   NUMBER        := 0;
      v_user_id        VARCHAR2 (10) := USER;
      v_extract_date   DATE          := SYSDATE;
      v_count          NUMBER        := 0;

      CURSOR c1 (v_iss_cd VARCHAR2, v_prem_seq_no NUMBER)
      IS
         SELECT   b140_iss_cd iss_cd, b140_prem_seq_no prem_seq_no, inst_no,
                  tran_date, get_ref_no (a.tran_id) ref_no,
                  SUM (collection_amt) prem_paid
             FROM giac_acctrans a, giac_direct_prem_collns b
            WHERE a.tran_id = b.gacc_tran_id
              AND b140_iss_cd = v_iss_cd
              AND b140_prem_seq_no = v_prem_seq_no
              AND tran_flag <> 'D'
              AND NOT EXISTS (
                     SELECT '1'
                       FROM giac_reversals x, giac_acctrans y
                      WHERE x.gacc_tran_id = b.gacc_tran_id
                        AND x.reversing_tran_id = y.tran_id
                        AND y.tran_flag <> 'D')
         GROUP BY b.b140_iss_cd,
                  b.b140_prem_seq_no,
                  b.inst_no,
                  a.tran_date,
                  a.tran_id;

      CURSOR c2 (v_policy_id NUMBER, v_iss_cd VARCHAR2, v_prem_seq_no NUMBER)
      IS
         SELECT '1'
           FROM giac_sal_ded_payt_ext
          WHERE policy_id = v_policy_id
            AND iss_cd = iss_cd
            AND prem_seq_no = v_prem_seq_no;

      c2_rep           c2%ROWTYPE;
   BEGIN
      FOR x IN
         (SELECT i.company_cd, i.company_name, i.ref_payee_cd employee_cd,
                 i.employee_name, i.employee_dept, h.iss_name, g.line_name,
                 b.policy_id, get_policy_no (b.policy_id) policy_no,
                 a.pack_policy_id,
                 get_pack_policy_no (a.pack_policy_id) pack_policy_no,
                 e.assd_name assured_name,
                 DECODE (b.acct_of_cd,
                         NULL, NULL,
                         (   DECODE (b.acct_of_cd_sw,
                                     'Y', 'Leased To: ',
                                     'fao: '
                                    )
                          || get_assd_name (b.acct_of_cd)
                         )
                        ) in_acct_of,
                 b.incept_date, b.expiry_date, c.iss_cd, c.prem_seq_no,
                 d.inst_no, c.payt_terms pay_term,
                 d.inst_no || '/' || j.total_inst amort_no,
                 NVL (c.prem_amt, 0) prem_amt, NVL (c.tax_amt, 0) tax_amt,
                 NVL (c.prem_amt, 0) + NVL (c.tax_amt, 0) total_amt_due,
                 d.due_date, NVL (d.prem_amt, 0)
                             + NVL (d.tax_amt, 0) prem_due
            FROM gipi_pack_polbasic a,
                 gipi_polbasic b,
                 gipi_invoice c,
                 gipi_installment d,
                 giis_assured e,
                 giis_line g,
                 giis_issource h,
                 (SELECT a.ref_payee_cd,
                            a.payee_first_name
                         || ' '
                         || a.payee_middle_name
                         || ' '
                         || a.payee_last_name employee_name,
                         a.designation employee_dept, b.payee_no company_cd,
                         b.payee_last_name company_name
                    FROM giis_payees a, giis_payees b
                   WHERE a.ref_payee_cd IS NOT NULL
                     AND a.payee_class_cd IN (giacp.v ('EMP_CLASS_CD'))
                     AND a.master_payee_no = b.payee_no
                     AND b.payee_class_cd IN (giacp.v ('COMPANY_CLASS_CD'))) i,
                 (SELECT   iss_cd, prem_seq_no, COUNT (inst_no) total_inst
                      FROM gipi_installment
                     WHERE 1 = 1
                  GROUP BY iss_cd, prem_seq_no) j,
                 giis_payterm k
           WHERE a.pack_policy_id = b.pack_policy_id
             AND b.policy_id = c.policy_id
             AND c.iss_cd = d.iss_cd
             AND c.prem_seq_no = d.prem_seq_no
             AND b.iss_cd = h.iss_cd
             AND b.line_cd = g.line_cd
             AND b.company_cd = i.company_cd
             AND b.employee_cd = i.ref_payee_cd
             AND d.iss_cd = j.iss_cd
             AND d.prem_seq_no = j.prem_seq_no
             AND a.line_cd = 'IP'
             AND c.payt_terms = k.payt_terms
             AND k.no_of_payt <> 1
             AND TRUNC (d.due_date) BETWEEN TRUNC (p_as_of_date, 'MONTH')
                                        AND TRUNC (p_as_of_date)
             AND h.iss_cd = NVL (p_iss_cd, h.iss_cd)
             AND i.company_cd = NVL (p_company_cd, i.company_cd)
             AND i.ref_payee_cd = NVL (p_employee_cd, i.ref_payee_cd)
             AND e.assd_no =
                    get_latest_assured_no2 (b.line_cd,
                                            b.subline_cd,
                                            b.iss_cd,
                                            b.issue_yy,
                                            b.pol_seq_no,
                                            b.renew_no
                                           ))
      LOOP
         FOR d IN (SELECT policy_id, iss_cd, prem_seq_no
                     FROM giac_sal_ded_billing_ext
                    WHERE as_of_date = p_as_of_date AND user_id = p_user_id)
         LOOP
            DELETE FROM giac_sal_ded_payt_ext
                  WHERE policy_id = d.policy_id
                    AND iss_cd = d.iss_cd
                    AND prem_seq_no = d.prem_seq_no
                    AND user_id = p_user_id;
         END LOOP;

         DELETE FROM giac_sal_ded_billing_ext
               WHERE as_of_date = p_as_of_date AND user_id = p_user_id;

         INSERT INTO giac_sal_ded_billing_ext
                     (as_of_date, company_cd, company_name,
                      employee_cd, employee_name, employee_dept,
                      iss_name, line_name, policy_id, policy_no,
                      pack_policy_id, pack_policy_no, assured_name,
                      in_acct_of, incept_date, expiry_date, iss_cd,
                      prem_seq_no, inst_no, pay_term, amort_no,
                      prem_amt, tax_amt, total_amt_due, prem_balance,
                      due_date, prem_due, user_id, extract_date
                     )
              VALUES (p_as_of_date, x.company_cd, x.company_name,
                      x.employee_cd, x.employee_name, x.employee_dept,
                      x.iss_name, x.line_name, x.policy_id, x.policy_no,
                      x.pack_policy_id, x.pack_policy_no, x.assured_name,
                      x.in_acct_of, x.incept_date, x.expiry_date, x.iss_cd,
                      x.prem_seq_no, x.inst_no, x.pay_term, x.amort_no,
                      x.prem_amt, x.tax_amt, x.total_amt_due, 0,
                      x.due_date, x.prem_due, v_user_id, v_extract_date
                     );

         v_prem_paid := 0;

         OPEN c2 (x.policy_id, x.iss_cd, x.prem_seq_no);

         FETCH c2
          INTO c2_rep;

         IF c2%NOTFOUND
         THEN
            FOR y IN c1 (x.iss_cd, x.prem_seq_no)
            LOOP
               INSERT INTO giac_sal_ded_payt_ext
                           (policy_id, iss_cd, prem_seq_no,
                            tran_date, ref_no, prem_paid, user_id,
                            extract_date
                           )
                    VALUES (x.policy_id, y.iss_cd, y.prem_seq_no,
                            y.tran_date, y.ref_no, y.prem_paid, v_user_id,
                            v_extract_date
                           );

               v_prem_paid := v_prem_paid + NVL (y.prem_paid, 0);
            END LOOP;
         END IF;

         CLOSE c2;

         v_prem_balance :=
                 NVL (x.prem_amt, 0) + NVL (x.tax_amt, 0)
                 - NVL (v_prem_paid, 0);

         UPDATE giac_sal_ded_billing_ext
            SET prem_balance = v_prem_balance
          WHERE policy_id = x.policy_id
            AND iss_cd = x.iss_cd
            AND prem_seq_no = x.prem_seq_no;
      END LOOP;

      SELECT COUNT (*)
        INTO v_count
        FROM giac_sal_ded_billing_ext
       WHERE as_of_date = p_as_of_date AND user_id = p_user_id;

      p_exists := TO_CHAR (v_count);
   END;
   
   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN when_new_form_instance_tab PIPELINED
   IS
      v_ext   when_new_form_instance_type;
   BEGIN
      FOR i IN (SELECT as_of_date
                  FROM giac_sal_ded_billing_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_ext.v_as_of_date := TO_CHAR (i.as_of_date, 'MM-DD-RRRR');
         PIPE ROW (v_ext);
      END LOOP;

      RETURN;
   END;
END;
/



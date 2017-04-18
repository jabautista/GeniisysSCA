CREATE OR REPLACE PACKAGE BODY CPI.giacr284_pkg
AS
    /*
   ** Created by: Marie Kris Felipe
   ** Date created: October 15, 2012
   ** Description: gets header details of premium collections based from the layout model
   */

   /* FUNCTION get_giacr284_header (
        p_date       NUMBER, --if 1 - tran date, else posting date =
        p_from_date  DATE,
        p_to_date    DATE,
        p_branch_cd  GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE
    ) RETURN giacr284_prem_colln_hdr_tab PIPELINED
    IS
        v_giacr284_header       giacr284_prem_colln_hdr_type;

    BEGIN
        SELECT get_cf_company_nameFormula
          INTO v_giacr284_header.company_name
          FROM dual;

        SELECT get_cf_company_addFormula
          INTO v_giacr284_header.company_address
          FROM dual;

        SELECT get_cf_from_toformula(p_from_date, p_to_date)
          INTO v_giacr284_header.from_to_date
          FROM dual;

        SELECT get_runtime
          INTO v_giacr284_header.runtime
          FROM dual;

        SELECT get_rundate
          INTO v_giacr284_header.rundate
          FROM dual;

       PIPE ROW(v_giacr284_header);

    END get_giacr284_header;*/

   /*
   ** Created by: Marie Kris Felipe
   ** Date created: October 15, 2012
   ** Description: gets all record details of premium collections based from the layout model
   */
   FUNCTION get_giacr284_details (
      p_date        NUMBER,           --if 1 - tran date, else posting date =
      p_from_date   DATE,
      p_to_date     DATE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr284_prem_colln_dtl_tab PIPELINED
   IS
      v_colln         giacr284_prem_colln_dtl_type;
      v_paymode_ctr   NUMBER;
   BEGIN
      v_paymode_ctr := 0;

      FOR c IN
         (SELECT   a.gibr_branch_cd branch_cd, b.b140_iss_cd iss_cd,
                   b.b140_prem_seq_no prem_seq_no,
                   
                   -- added by Kris 2012.10.22
                   a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0) or_no,
                   
                   --add leading zeros by MAC 10/12/2011.
                   a.payor payor,
                      b.b140_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0) bill_no,
                   
                   --add leading zeros by MAC 10/12/2011.
                   a.particulars particulars, a.gacc_tran_id gacc_tran_id,
                   SUM (NVL (b.premium_amt, 0)) premium_amt,
                   SUM (NVL (b.tax_amt, 0)) tax_amt,
                   SUM (NVL (b.collection_amt, 0)) collection_amt
              -- added by jomardiago 08292012

          --SUM(NVL(a.collection_amt,0)) collection_amt_order --comment out by cris 07/30/09

          /*replaced to display the collection amount per pay mode*/
                                          --amount collection_amount,
                                          --       DECODE(pay_mode, 'CHK', b.bank_sname||'-'||check_no,
                                          --                                'CM', b.bank_sname,
                                          --                      'CC', b.bank_sname,
                                          --                     '-') CHECK_NO  commented by alfie 09092009
          FROM     giac_order_of_payts a,
                   giac_direct_prem_collns b,
                   giac_acctrans c
              -- giac_collection_dtl d,
             --  giac_banks e
          WHERE    a.gacc_tran_id = b.gacc_tran_id
               AND a.gacc_tran_id = c.tran_id
               --  AND a.gacc_tran_id = d.gacc_tran_id
               AND b.gacc_tran_id = c.tran_id
               --   AND c.tran_id = d.gacc_tran_id
               --   AND b.gacc_tran_id = d.gacc_tran_id
               --   AND e.bank_cd(+) = d.bank_cd
               AND c.tran_flag <> 'D'
               AND c.tran_class <> 'CP'       -- Added by Jomar Diago 09032012
               AND NOT EXISTS (
                      SELECT gacc_tran_id
                        FROM giac_acctrans z, giac_reversals t
                       WHERE z.tran_id = t.reversing_tran_id
                         AND z.tran_id = a.gacc_tran_id
                         AND z.tran_flag <> 'D')
               AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
               AND a.gibr_branch_cd = b.b140_iss_cd
               /*AND check_user_per_iss_cd_acctg (NULL,
                                                  a.gibr_branch_cd,
                                                  :p_module_id) = 1*/
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 b.b140_iss_cd,
                                                 'GIACS284',
                                                 p_user_id
                                                ) = 1
               --added by reymon 05152012
               AND TRUNC (DECODE (p_date, 1, c.tran_date, c.posting_date))
                      BETWEEN p_from_date
                          AND p_to_date
          GROUP BY a.gibr_branch_cd,
                   b.b140_iss_cd,
                   b.b140_prem_seq_no,             -- added by Kris 2012.10.22
                   a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0),
                   --add leading zeros by MAC 10/12/2011.
                   a.payor,
                      b.b140_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0),
                   --add leading zeros by MAC 10/12/2011.
                   a.particulars,
                   a.gacc_tran_id
          --d.amount,
          --d.pay_mode,
          --DECODE (d.pay_mode,
          --'CHK', e.bank_sname || '-' || d.check_no,
          --'CM', e.bank_sname,
          --'CC', e.bank_sname,
          --'-')
          -- ORDER BY  a.or_pref_suf||'-'||a.or_no
          UNION
          SELECT   a.gibr_branch_cd branch_cd, b.b140_iss_cd iss_cd,
                   b.b140_prem_seq_no prem_seq_no, -- added by Kris 2012.10.22
                   a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0) or_no,
                   
                   --add leading zeros by MAC 10/12/2011.
                   a.payor payor,
                      b.b140_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0) bill_no,
                   
                   --add leading zeros by MAC 10/12/2011.
                   a.particulars particulars, a.gacc_tran_id gacc_tran_id,
                   SUM (NVL (b.premium_amt, 0)) premium_amt,
                   SUM (NVL (b.wholding_tax, 0)) tax_amt,
                   SUM (b.collection_amt) collection_amt
                 -- added by jomardiago 08292012
              --SUM(NVL(a.collection_amt,0)) collection_amt_order --comment out by cris 07/30/09
              /*replaced to display the collection amount per pay mode*/
              --amount collection_amount,
              --       DECODE(pay_mode, 'CHK', b.bank_sname||'-'||check_no,
              --                                'CM', b.bank_sname,
              --                      'CC', b.bank_sname,
              --                     '-') CHECK_NO  commented by alfie 09092009
          FROM     giac_order_of_payts a,
                   giac_inwfacul_prem_collns b,
                   giac_acctrans c
             --    giac_collection_dtl d, -- commented out by Kris 2012.10.30
             --    giac_banks e -- commented out by Kris 2012.10.30
          WHERE    a.gacc_tran_id = b.gacc_tran_id
               AND a.gacc_tran_id = c.tran_id
               AND b.gacc_tran_id = c.tran_id
               --   AND c.tran_id = d.gacc_tran_id
               --    AND b.gacc_tran_id = d.gacc_tran_id -- commented out by Kris 2012.10.30
               --    AND e.bank_cd(+) = d.bank_cd -- commented out by Kris 2012.10.30
               AND c.tran_flag <> 'D'
               AND c.tran_class <> 'CP'       -- Added by Jomar Diago 09032012
               AND NOT EXISTS (
                      SELECT gacc_tran_id
                        FROM giac_acctrans z, giac_reversals t
                       WHERE z.tran_id = t.reversing_tran_id
                         AND z.tran_id = a.gacc_tran_id
                         AND z.tran_flag <> 'D')
               AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
               AND a.gibr_branch_cd = b.b140_iss_cd		-- added by Daniel Marasigan SR 5531
               /*AND check_user_per_iss_cd_acctg (NULL,
                                              a.gibr_branch_cd,
                                              :p_module_id) = 1*/
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 b.b140_iss_cd,
                                                 'GIACS284',
                                                 p_user_id
                                                ) = 1
               --added by reymon 05152012
               AND TRUNC (DECODE (p_date, 1, c.tran_date, c.posting_date))
                      BETWEEN p_from_date
                          AND p_to_date
          GROUP BY a.gibr_branch_cd,
                   b.b140_iss_cd,
                   b.b140_prem_seq_no,             -- added by Kris 2012.10.22
                   a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0),
                   --add leading zeros by MAC 10/12/2011.
                   a.payor,
                      b.b140_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0),
                   --add leading zeros by MAC 10/12/2011.
                   a.particulars,
                   a.gacc_tran_id
           --d.amount,
           --d.pay_mode
          /* DECODE (d.pay_mode,
                  'CHK', e.bank_sname || '-' || d.check_no,
                  'CM', e.bank_sname,
                  'CC', e.bank_sname,
                  '-'
                 ),*/
          ORDER BY 1, 4)
      --3
      --3,6,4)
      LOOP
         /* Assign default values first before updating in Query2 */
         v_colln.comm_amt := 0;
         v_colln.input_vat_amt := 0;
         v_colln.wtax_amt := 0;
         v_colln.intm_no := NULL;
         v_colln.bill_no := '';

         /******  FOR QUERY2   ********/
         FOR q2 IN
            (SELECT comm_amt, input_vat_amt, intm_no, gacc_tran_id,
                       iss_cd
                    || '-'
                    || LPAD (TO_CHAR (prem_seq_no), 12, 0) bill_no,
                    wtax_amt
               FROM giac_comm_payts
              WHERE gacc_tran_id = c.gacc_tran_id
                AND iss_cd = c.iss_cd
                AND prem_seq_no = c.prem_seq_no
             UNION ALL
             SELECT comm_amt, comm_vat input_vat_amt, a180_ri_cd intm_no,
                    gacc_tran_id,
                       b140_iss_cd
                    || '-'
                    || LPAD (TO_CHAR (b140_prem_seq_no), 12, 0) bill_no,
                    tax_amount wtax_amt
               FROM giac_inwfacul_prem_collns
              WHERE gacc_tran_id = c.gacc_tran_id
                AND b140_iss_cd = c.iss_cd
                AND b140_prem_seq_no = c.prem_seq_no
             UNION ALL
             SELECT 0, 0, NULL, NULL, NULL, 0
               FROM DUAL
              WHERE NOT EXISTS (
                       SELECT comm_amt, input_vat_amt, intm_no, gacc_tran_id,
                                 iss_cd
                              || '-'
                              || LPAD (TO_CHAR (prem_seq_no), 12, 0) bill_no,
                              wtax_amt
                         FROM giac_comm_payts
                        WHERE gacc_tran_id = c.gacc_tran_id
                          AND iss_cd = c.iss_cd
                          AND prem_seq_no = c.prem_seq_no
                       UNION ALL
                       SELECT comm_amt, comm_vat input_vat_amt,
                              a180_ri_cd intm_no, gacc_tran_id,
                                 b140_iss_cd
                              || '-'
                              || LPAD (TO_CHAR (b140_prem_seq_no), 12, 0)
                                                                      bill_no,
                              tax_amount wtax_amt
                         FROM giac_inwfacul_prem_collns
                        WHERE gacc_tran_id = c.gacc_tran_id
                          AND b140_iss_cd = c.iss_cd
                          AND b140_prem_seq_no = c.prem_seq_no))
         LOOP
            v_colln.comm_amt := NVL (q2.comm_amt, 0);
            v_colln.input_vat_amt := NVL (q2.input_vat_amt, 0);
            v_colln.intm_no := q2.intm_no;
            v_colln.wtax_amt := NVL (q2.wtax_amt, 0);
            v_colln.bill_no := q2.bill_no;
         END LOOP;

         /* Assign default values first before updating in Query3 */
         v_colln.pay_mode := '';
         v_colln.check_no := '';
         v_colln.item_no := '';

         IF (c.collection_amt > 0.00)
         THEN
            /******  FOR QUERY3   ********/
            FOR q3 IN
               (SELECT a.gacc_tran_id, a.pay_mode,
                                                  --bank_sname||'-'||check_no check_no  --alfie 09092009
                                                  cc.b140_iss_cd,
                       cc.b140_prem_seq_no, a.item_no item_no, a.amount,
                       DECODE (pay_mode,
                               'CHK', b.bank_sname || '-' || check_no,
                               'CM', /*b.bank_sname*/ b.bank_sname || '-'
                                || check_no,
                               'CC', b.bank_sname,
                               '-'
                              ) check_no                     --added by alfie
                  FROM giac_collection_dtl a,
                       giac_banks b,
                       giac_direct_prem_collns cc  -- Added by Kris 2012.10.22
                 WHERE a.bank_cd = b.bank_cd(+)
                   AND c.gacc_tran_id = a.gacc_tran_id
                   AND cc.b140_iss_cd = c.iss_cd   -- Added by Kris 2012.10.22
                   AND cc.b140_prem_seq_no = c.prem_seq_no)
            LOOP
               v_colln.pay_mode := q3.pay_mode;
               v_colln.check_no := q3.check_no;
               v_colln.item_no := q3.item_no;
               v_colln.collection_amt := q3.amount;
               v_paymode_ctr := v_paymode_ctr + 1;
               EXIT WHEN v_paymode_ctr > q3.item_no;
            END LOOP;
         END IF;

         v_colln.branch_cd := c.branch_cd;
         v_colln.iss_cd := c.iss_cd;
         v_colln.or_no := c.or_no;
         v_colln.payor := c.payor;
         v_colln.bill_no := c.bill_no;
         v_colln.particulars := c.particulars;
         v_colln.gacc_tran_id := c.gacc_tran_id;
         v_colln.premium_amt := NVL (c.premium_amt, 0);
         v_colln.tax_amt := NVL (c.tax_amt, 0);
         v_colln.direct_collection_amt := NVL (c.collection_amt, 0);
         v_paymode_ctr := 0;

--         SELECT giacr284_pkg.get_cf_policy_noformula (c.bill_no)
--           INTO v_colln.policy_no
--           FROM DUAL;

         -- bonok :: 6.24.2015 :: SR 4719 - for optimization
         SELECT giacr284_pkg.get_cf_policy_noformula2(c.iss_cd, c.prem_seq_no)
           INTO v_colln.policy_no
           FROM DUAL;

         SELECT giacr284_pkg.get_cf_branch_nameformula (c.branch_cd)
           INTO v_colln.branch_name
           FROM DUAL;

         SELECT giacr284_pkg.get_cf_company_nameformula
           INTO v_colln.company_name
           FROM DUAL;

         SELECT giacr284_pkg.get_cf_company_addformula
           INTO v_colln.company_address
           FROM DUAL;

         SELECT giacr284_pkg.get_cf_from_toformula (p_from_date, p_to_date)
           INTO v_colln.from_to_date
           FROM DUAL;

         PIPE ROW (v_colln);
      END LOOP;

      RETURN;
   END get_giacr284_details;

   /*
   ** Description: gets the company name
   */
   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                    FROM DUAL)
      LOOP
         v_company_name := rec.v_company_name;
      END LOOP;

      RETURN (v_company_name);
   END get_cf_company_nameformula;

   /*
   ** Description: gets the address of the company
   */
   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2
   IS
      v_company_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR rec IN (SELECT UPPER (giacp.v ('COMPANY_ADDRESS'))
                                                           v_company_address
                    FROM DUAL)
      LOOP
         v_company_address := rec.v_company_address;
      END LOOP;

      RETURN (v_company_address);
   END get_cf_company_addformula;

   /*
   ** Description: formats the from and to dates
   */
   FUNCTION get_cf_from_toformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2
   IS
      v_from_to        VARCHAR2 (100);
      v_same_from_to   VARCHAR2 (100);
   BEGIN
      IF p_from_date = p_to_date
      THEN
         v_same_from_to := TO_CHAR (p_from_date, 'fmMonth DD, RRRR');
         RETURN (v_same_from_to);
      ELSE
         v_from_to :=
               'From '
            || TO_CHAR (p_from_date, 'fmMonth DD, RRRR')
            || ' to '
            || TO_CHAR (p_to_date, 'fmMonth DD, RRRR');
         RETURN (v_from_to);
      END IF;
   END get_cf_from_toformula;

   /*
   ** Description: Gets the branch name based from the branch code
   */
   FUNCTION get_cf_branch_nameformula (
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_branch_name   VARCHAR2 (50);
   BEGIN
      FOR rec IN (SELECT get_iss_name (p_branch_cd) branch_name
                    FROM DUAL)
      LOOP
         v_branch_name := rec.branch_name;
      END LOOP;

      RETURN (v_branch_name);
   END get_cf_branch_nameformula;

   /*
   ** Description: Gets the policy number based from the given bill no.
   */
   FUNCTION get_cf_policy_noformula (p_bill_no VARCHAR2)
      RETURN VARCHAR2
   IS
      v_policy_no   VARCHAR2 (100);
   BEGIN
      FOR rec IN (SELECT get_policy_no (policy_id) policy_no
                    --FROM gipi_comm_invoice
                  FROM   gipi_invoice
                   WHERE iss_cd || '-' || LPAD (TO_CHAR (prem_seq_no), 12, 0) =
                                                                    p_bill_no)
      --modified by MAC 10/12/2011
      LOOP
         v_policy_no := rec.policy_no;
      END LOOP;

      RETURN (v_policy_no);
   END get_cf_policy_noformula;
   
   FUNCTION get_cf_policy_noformula2 ( -- bonok :: 6.24.2015 :: SR 4719 - for optimization
      p_iss_cd       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no  gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_policy_no   VARCHAR2 (100);
   BEGIN
      FOR rec IN (SELECT get_policy_no (policy_id) policy_no
                    FROM gipi_invoice
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_policy_no := rec.policy_no;
         EXIT;
      END LOOP;

      RETURN (v_policy_no);
   END get_cf_policy_noformula2;
END giacr284_pkg;
/



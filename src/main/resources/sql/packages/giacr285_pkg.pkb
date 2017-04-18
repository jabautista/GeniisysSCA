CREATE OR REPLACE PACKAGE BODY CPI.giacr285_pkg
AS
   /*
   Created by: John Carlo M. Brigino
   October 15, 2012
   */
   FUNCTION get_giacr285_details (
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_date        NUMBER,
      p_from_date   giac_colln_batch.tran_date%TYPE,
      p_to_date     giac_colln_batch.tran_date%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr285_premium_coll_tab PIPELINED
   IS
      v_giacr285       giacr285_premium_coll_type;
      v_iss_cd         VARCHAR (2000);
      v_same_from_to   VARCHAR (2000);
      v_from_to        VARCHAR (2000);
   BEGIN
      SELECT giacp.v ('COMPANY_NAME') v_company_name
        INTO v_giacr285.company_name
        FROM DUAL;

      SELECT UPPER (giacp.v ('COMPANY_ADDRESS')) v_company_address
        INTO v_giacr285.company_address
        FROM DUAL;

      IF p_from_date = p_to_date
      THEN
         v_giacr285.from_to := TO_CHAR (p_from_date, 'fmMonth DD, RRRR');
      ELSE
         v_giacr285.from_to :=
               'From '
            || TO_CHAR (p_from_date, 'fmMonth DD, RRRR')
            || ' to '
            || TO_CHAR (p_to_date, 'fmMonth DD, RRRR');
      END IF;

      FOR x IN (SELECT   a.gibr_branch_cd branch_cd, b.b140_iss_cd iss_cd,
                         a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0) or_no,
                         
                         --abegail 12022010 added lpad for or_no
                         a.payor payor, b.b140_prem_seq_no prem_seq_no,
                            b.b140_iss_cd
                         || '-'
                         || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0)
                                                                      bill_no,
                         
                         --abegail 12022010 added lpad for prem_seq_no
                         a.particulars particulars,
                         a.gacc_tran_id gacc_tran_id,
                         SUM (b.premium_amt) premium_amt,
                         SUM (b.tax_amt) tax_amt,
                         
                         /*     SUM(a.collection_amt) collection_amt*/
                         --comment by cris 07/23/09
                         --replaced to get the collection amount per bill
                         SUM (b.collection_amt) collection_amt
                    FROM giac_order_of_payts a,
                         giac_direct_prem_collns b,
                         giac_acctrans c
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND c.tran_class <> 'CP' -- Added by Jomar Diago 09042012
                     AND NOT EXISTS (
                            SELECT gacc_tran_id
                              FROM giac_acctrans z, giac_reversals t
                             WHERE z.tran_id = t.reversing_tran_id
                               AND z.tran_id = a.gacc_tran_id
                               AND z.tran_flag <> 'D')
                     AND b.b140_iss_cd = NVL (p_branch_cd, b.b140_iss_cd)
                     /*AND check_user_per_iss_cd_acctg (NULL, b.b140_iss_cd, :p_module_id) =
                           1*/
                     --added by reymon 05152012
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.b140_iss_cd,
                                                       'GIACS284',
                                                       p_user_id
                                                      ) = 1
                     AND TRUNC (DECODE (p_date,
                                        1, c.tran_date,
                                        c.posting_date
                                       )
                               ) BETWEEN p_from_date AND p_to_date
                GROUP BY b.b140_iss_cd,
                         a.gibr_branch_cd,
                         a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0),
                         --abegail 12022010 added lpad for or_no
                         a.payor,
                            b.b140_iss_cd
                         || '-'
                         || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0),
                         --abegail 12022010 added lpad for prem_seq_no
                         a.particulars,
                         a.gacc_tran_id,
                         b.b140_prem_seq_no
                UNION
                SELECT   a.gibr_branch_cd branch_cd, b.b140_iss_cd iss_cd,
                         a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0) or_no,
                         
                         --abegail 12022010 added lpad for or_no
                         a.payor payor, b.b140_prem_seq_no prem_seq_no,
                            b.b140_iss_cd
                         || '-'
                         || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0)
                                                                      bill_no,
                         
                         --abegail 12022010 added lpad for prem_seq_no
                         a.particulars particulars,
                         a.gacc_tran_id gacc_tran_id,
                         SUM (b.premium_amt) premium_amt,
                         SUM (b.wholding_tax) tax_amt,
                         
                         /*     SUM(a.collection_amt) collection_amt*/
                         --comment by cris 07/23/09
                         --replaced to get the collection amount per bill
                         SUM (b.collection_amt) collection_amt
                    FROM giac_order_of_payts a,
                         giac_inwfacul_prem_collns b,
                         giac_acctrans c
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND c.tran_class <> 'CP' -- Added by Jomar Diago 09042012
                     AND NOT EXISTS (
                            SELECT gacc_tran_id
                              FROM giac_acctrans z, giac_reversals t
                             WHERE z.tran_id = t.reversing_tran_id
                               AND z.tran_id = a.gacc_tran_id
                               AND z.tran_flag <> 'D')
                     --AND b.b140_iss_cd = NVL(:p_branch_cd, b.b140_iss_cd) -- comment out by jomar diago 08252012
                     AND a.gibr_branch_cd =
                                           NVL (p_branch_cd, a.gibr_branch_cd)
                                                    -- added by jomar diago 08252012
                     /*AND check_user_per_iss_cd_acctg (NULL, b.b140_iss_cd, :p_module_id) =
                           1*/
                     --added by reymon 05152012
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       b.b140_iss_cd,
                                                       'GIACS284',
                                                       p_user_id
                                                      ) = 1
                     AND TRUNC (DECODE (p_date,
                                        1, c.tran_date,
                                        c.posting_date
                                       )
                               ) BETWEEN p_from_date AND p_to_date
                GROUP BY b.b140_iss_cd,
                         a.gibr_branch_cd,
                         a.or_pref_suf || '-' || LPAD (a.or_no, 10, 0),
                         --abegail 12022010 added lpad for or_no
                         a.payor,
                            b.b140_iss_cd
                         || '-'
                         || LPAD (TO_CHAR (b.b140_prem_seq_no), 12, 0),
                         --abegail 12022010 added lpad for prem_seq_no
                         a.particulars,
                         a.gacc_tran_id,
                         b.b140_prem_seq_no
                ORDER BY 2)
      LOOP
         v_giacr285.commission_amt := 0;
         v_giacr285.input_vat_amt := 0;
         v_giacr285.iss_cd := x.iss_cd;          -- added by Daniel Marasigan SR 5532 07.08.2016
         v_giacr285.branch_cd := x.branch_cd;    -- added by Daniel Marasigan SR 5532 07.08.2016
         
         FOR y IN (SELECT comm_amt, input_vat_amt, intm_no, gacc_tran_id,
                             iss_cd
                          || '-'
                          || LPAD (TO_CHAR (prem_seq_no), 12, 0) bill_no,
                          wtax_amt
                     FROM giac_comm_payts
                    WHERE gacc_tran_id = x.gacc_tran_id
                      AND iss_cd = x.iss_cd
                      AND prem_seq_no = x.prem_seq_no
                   UNION ALL
                   SELECT comm_amt, comm_vat input_vat_amt,
                          a180_ri_cd intm_no, gacc_tran_id,
                             b140_iss_cd
                          || '-'
                          || LPAD (TO_CHAR (b140_prem_seq_no), 12, 0) bill_no,
                          tax_amount wtax_amt
                     FROM giac_inwfacul_prem_collns
                    WHERE gacc_tran_id = x.gacc_tran_id
                      AND b140_iss_cd = x.iss_cd
                      AND b140_prem_seq_no = x.prem_seq_no
                                                          -- added by JCB, 10182012 -- will link this query to main query above.
                 )
         LOOP
            v_giacr285.bill_no := y.bill_no;
            v_giacr285.intm_no := y.intm_no;
            v_giacr285.commission_amt := NVL (y.comm_amt, 0);
            v_giacr285.input_vat_amt := NVL (y.input_vat_amt, 0);
            
            IF y.intm_no IS NOT NULL
            THEN
                SELECT intm_name               -- added by Daniel Marasigan SR 5532 07.08.2016
                INTO v_giacr285.intm_name
                FROM GIIS_INTERMEDIARY
                WHERE intm_no = y.intm_no;
            END IF;
         END LOOP;

         FOR z IN (SELECT gacc_tran_id, pay_mode,
                          bank_sname || '-'
                          || LPAD (check_no, 10, 0) check_no
                     --abegail 12022010 added lpad for check_no
                   FROM   giac_collection_dtl a, giac_banks b
                    WHERE a.bank_cd = b.bank_cd(+)
                          AND gacc_tran_id = x.gacc_tran_id)
         LOOP
            v_giacr285.pay_mode := z.pay_mode;
            v_giacr285.check_no := z.check_no;
         END LOOP;

         v_giacr285.gacc_tran_id := x.gacc_tran_id;
         v_giacr285.or_no := x.or_no;
         v_giacr285.payor := x.payor;
         v_giacr285.particulars := x.particulars;
         v_giacr285.bill_no := x.bill_no;
         v_giacr285.collection_amt := NVL (x.collection_amt, 0);
         v_giacr285.premium_amt := NVL (x.premium_amt, 0);
         v_giacr285.tax_amt := NVL (x.tax_amt, 0);

         SELECT get_iss_name (x.branch_cd) branch_name
           INTO v_giacr285.branch_name
           FROM DUAL;

         FOR y IN (SELECT get_policy_no (policy_id) policy_no
                     FROM gipi_invoice
                    WHERE iss_cd || '-' || LPAD (TO_CHAR (prem_seq_no), 12, 0) =
                                                                     x.bill_no)
         LOOP
            v_giacr285.policy_no := y.policy_no;
         END LOOP;

         SELECT UPPER ('For ' || get_iss_name (x.iss_cd) || ' Policies') iss_name, -- modified by Daniel Marasigan SR 5532 07.08.2016
                get_iss_name (x.iss_cd) iss_source
         INTO v_giacr285.iss_name, 
              v_giacr285.iss_source
         FROM DUAL;
         
         PIPE ROW (v_giacr285);
      END LOOP;

      RETURN;
   END;
END;
/
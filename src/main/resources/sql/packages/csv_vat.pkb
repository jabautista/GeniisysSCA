CREATE OR REPLACE PACKAGE BODY CPI.CSV_VAT
AS
   /* Created by: Ramon 08/13/2010, Generate CSV in GIACS108 - EVAT */
   /* Modified by: Ramon 08/19/2010, Added functions for input_vat reports */
   /*Modified by: Jongs 05/27/2013, Consolidated Udel's Modifications in ENHSEICI's csv_vat to the latest version of csv_vat (wtax)
                  Added Parameter P_MODULE_ID on wtax reports*/
   /*Modified by: Vondanix 12/16/2015 : added P_INCLUDE in CSV_INPUT_VAT2 and CSV_INPUT_VAT3 functionns.
   */

   --## FUNCTION CSV_EVAT ##--
   FUNCTION CSV_EVAT (p_line_cd       VARCHAR2,
                      p_branch_cd     VARCHAR2,
                      p_post_tran     VARCHAR2,
                      p_tran_date1    DATE,
                      p_tran_date2    DATE)
      RETURN evat_type
      PIPELINED
   IS
      v_evat            evat_rec_type;
      --1--
      v_line_name       GIIS_LINE.line_name%TYPE;
      --2--
      v_assd_name       GIIS_ASSURED.assd_name%TYPE;
      v_addr            VARCHAR2 (500);
      v_tin             GIIS_ASSURED.assd_tin%TYPE;
      data_found_flag   VARCHAR2 (1) := 'N';
      --3--
      v_evat1           NUMBER (12, 2);
   BEGIN
      FOR rec
      IN (SELECT   'DIRECT' dir_inw,
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   /*DECODE (
                      i.tran_class,
                      'COL',
                      DECODE (
                         b.or_no,
                         NULL,
                         ' ',
                         'COL ' || b.or_pref_suf || '-' || TO_CHAR (b.or_no)
                      ),
                      'DV',
                      DECODE (m.dv_no,
                              NULL, ' ',
                              'DV ' || m.dv_pref || '-' || TO_CHAR (m.dv_no)),
                      'JV',
                      DECODE (
                         i.tran_class_no,
                         NULL,
                         ' ',
                         i.tran_class || '-' || TO_CHAR (i.tran_class_no)
                      ),
                      TO_CHAR (i.jv_no)
                   )*/
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)   -- jhing GENQA 5302 -  03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no. 
                   || '-'
                   || h.inst_no
                      BILL_NO,
                   h.premium_amt premium,
                   DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt, --Dean 07.09.2012
                   f.tax_amt,
                   --DECODE (h.premium_amt, 0, 0, j.balance_amt_due) os_bal, --Dean 07.12.2012
                   j.balance_amt_due os_bal, --modified by MJ 03/08/2013. Confirmed with Ms April.
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_soa_details j,
                   giac_tax_collns f,
                   giac_direct_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i
           WHERE       1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND h.b140_iss_cd = j.iss_cd(+)
                   AND h.b140_prem_seq_no = j.prem_seq_no(+)
                   AND h.inst_no = j.inst_no(+)
                   AND f.b160_tax_cd = giacp.n ('EVAT')
                   AND h.gacc_tran_id = f.gacc_tran_id
                   AND h.b140_iss_cd = f.b160_iss_cd
                   AND h.b140_prem_seq_no = f.b160_prem_seq_no
                   AND h.inst_no = f.inst_no
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND d.iss_cd = NVL (p_branch_cd, d.iss_cd) --Commented out by Dean 07.09.2012
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd) --Dean 07.09.2012
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1 -- added by mikel 07.03.2012
                   AND a.iss_cd <> 'BB'
                   /*AND NOT EXISTS
                         (SELECT   n.gacc_tran_id
                            FROM   giac_reversals n, giac_acctrans o
                           WHERE       n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id)*/
                   AND NOT EXISTS
                         (SELECT   p.gacc_tran_id
                            FROM   GIAC_ADVANCED_PAYT p
                           WHERE       p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   /* AND (p.acct_ent_date IS NULL          -- jhing 03.29.2016 commented out conditions for acct_ent_date - GENQA 5302
                                        OR TRUNC (p.acct_ent_date) >=
                                             p_tran_date2)*/ )
                   AND i.tran_class IN ('COL', 'DV', 'JV')
                   AND i.tran_flag != 'D'
                   AND ( (p_post_tran = 'P'
                          AND TRUNC (i.posting_date) BETWEEN (p_tran_date1)
                                                         AND  (p_tran_date2))
                        OR (p_post_tran = 'T'
                            AND TRUNC (i.tran_date) BETWEEN (p_tran_date1)
                                                        AND  (p_tran_date2)))
          UNION ALL
          SELECT   'PPR', --mikel 02.12.2014; changed DIRECT to PPR
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   /*DECODE (
                      i.tran_class,
                      'COL',
                      DECODE (
                         b.or_no,
                         NULL,
                         ' ',
                         'COL ' || b.or_pref_suf || '-' || TO_CHAR (b.or_no)
                      ),
                      'DV',
                      DECODE (m.dv_no,
                              NULL, ' ',
                              'DV ' || m.dv_pref || '-' || TO_CHAR (m.dv_no)),
                      'JV',
                      DECODE (
                         i.tran_class_no,
                         NULL,
                         ' ',
                         i.tran_class || '-' || TO_CHAR (i.tran_class_no)
                      ),
                      TO_CHAR (i.jv_no)
                   )*/
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   ||  LPAD (h.b140_prem_seq_no, 12, 0)  -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no
                      BILL_NO,
                   h.premium_amt premium,
                   DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt, --Dean 07.09.2012
                   f.tax_amt,
                   --DECODE (h.premium_amt, 0, 0, j.balance_amt_due) os_bal, --Dean 07.12.2012
                   j.balance_amt_due os_bal, --modified by MJ 03/08/2013. Confirmed with Ms April.
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_soa_details j,
                   giac_tax_collns f,
                   giac_direct_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,   
                   giac_acctrans i,
                   giac_advanced_payt p
           WHERE       1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND j.iss_cd(+) = h.b140_iss_cd
                   AND j.prem_seq_no(+) = h.b140_prem_seq_no
                   AND j.inst_no(+) = h.inst_no
                   AND f.b160_tax_cd = Giacp.n ('EVAT')
                   AND h.gacc_tran_id = f.gacc_tran_id
                   AND i.tran_id = p.gacc_tran_id
                   AND h.gacc_tran_id = p.gacc_tran_id
                   AND h.b140_iss_cd = p.iss_cd
                   AND h.b140_prem_seq_no = p.prem_seq_no
                   AND h.inst_no = p.inst_no
                   AND h.b140_iss_cd = f.b160_iss_cd
                   AND h.b140_prem_seq_no = f.b160_prem_seq_no
                   AND h.inst_no = f.inst_no
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND d.iss_cd = NVL (p_branch_cd, d.iss_cd) --Commented out by Dean 07.09.2012
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd) --Dean 07.09.2012
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1 -- added by mikel 07.03.2012
                   AND a.iss_cd <> 'BB'
                   AND NOT EXISTS
                         (SELECT   n.gacc_tran_id
                            FROM   GIAC_REVERSALS n, GIAC_ACCTRANS o
                           WHERE       n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND ( (p_post_tran = 'P'
                                          AND (TRUNC (o.posting_date) IS NOT NULL
                                               OR TRUNC (o.posting_date) <=
                                                    p_tran_date2))
                                        OR (p_post_tran = 'T'
                                            AND TRUNC (O.TRAN_DATE) <=
                                                  p_tran_date2)))
                   AND p.acct_ent_date BETWEEN p_tran_date1 AND p_tran_date2
          UNION ALL
          SELECT   'INWARD',
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   /*DECODE (
                      i.tran_class,
                      'COL',
                      DECODE (
                         b.or_no,
                         NULL,
                         ' ',
                         'COL ' || b.or_pref_suf || '-' || TO_CHAR (b.or_no)
                      ),
                      'DV',
                      DECODE (m.dv_no,
                              NULL, ' ',
                              'DV ' || m.dv_pref || '-' || TO_CHAR (m.dv_no)),
                      'JV',
                      DECODE (
                         i.tran_class_no,
                         NULL,
                         ' ',
                         i.tran_class || '-' || TO_CHAR (i.tran_class_no)
                      ),
                      TO_CHAR (i.jv_no)
                   )*/
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0) -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no
                      bill_no,
                   h.premium_amt premium,
                   DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt, --Dean 07.09.2012
                   h.tax_amount,
                   --DECODE (h.premium_amt, 0, 0, j.balance_amt_due) os_bal, --Dean 07.12.2012
                   --DECODE (h.premium_amt, 0, 0, j.balance_due) os_bal, --Dean 07.16.2012
                   j.balance_due os_bal, --modified by MJ 03/08/2013. Confirmed by Ms April.
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   --giac_aging_soa_details j, Commented out by Dean 07.16.2012
                   giac_aging_ri_soa_details j, --Dean 07.16.2012
                   giac_inwfacul_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i
           WHERE       1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   --AND h.b140_iss_cd = j.iss_cd(+) Commented out by Dean 07.16.2012
                   AND h.b140_prem_seq_no = j.prem_seq_no(+)
                   AND h.inst_no = j.inst_no(+)
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND d.iss_cd = NVL (p_branch_cd, d.iss_cd) --Commented out by Dean 07.09.2012
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd) --Dean 07.09.2012
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1 -- added by mikel 07.03.2012
                   AND a.iss_cd <> 'BB'
                   /*AND NOT EXISTS
                         (SELECT   n.gacc_tran_id
                            FROM   giac_reversals n, giac_acctrans o
                           WHERE       n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id)*/
                   AND NOT EXISTS
                         (SELECT   p.gacc_tran_id
                            FROM   GIAC_ADVANCED_PAYT p
                           WHERE       p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   AND (p.acct_ent_date IS NULL
                                        OR TRUNC (p.acct_ent_date) >=
                                             p_tran_date2))
                   AND i.tran_class IN ('COL', 'DV', 'JV')
                   AND i.tran_flag != 'D'
                   AND ( (p_post_tran = 'P'
                          AND TRUNC (i.posting_date) BETWEEN (p_tran_date1)
                                                         AND  (p_tran_date2))
                        OR (p_post_tran = 'T'
                            AND TRUNC (i.tran_date) BETWEEN (p_tran_date1)
                                                        AND  (p_tran_date2)))
          UNION ALL
          SELECT   'INWARD',
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   /*DECODE (
                      i.tran_class,
                      'COL',
                      DECODE (
                         b.or_no,
                         NULL,
                         ' ',
                         'COL ' || b.or_pref_suf || '-' || TO_CHAR (b.or_no)
                      ),
                      'DV',
                      DECODE (m.dv_no,
                              NULL, ' ',
                              'DV ' || m.dv_pref || '-' || TO_CHAR (m.dv_no)),
                      'JV',
                      DECODE (
                         i.tran_class_no,
                         NULL,
                         ' ',
                         i.tran_class || '-' || TO_CHAR (i.tran_class_no)
                      ),
                      TO_CHAR (i.jv_no)
                   )*/
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)  -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no
                      bill_no,
                   h.premium_amt premium,
                   DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt, --Dean 07.09.2012
                   h.tax_amOUNt,
                   --DECODE (h.premium_amt, 0, 0, j.balance_amt_due) os_bal, --Dean 07.12.2012
                   --DECODE (h.premium_amt, 0, 0, j.balance_due) os_bal, --Dean 07.16.2012
                   j.balance_due os_bal, --modified by MJ 03/08/2013. Confirmed with Ms April.
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   --giac_aging_soa_details j, Commented out by Dean 07.16.2012
                   giac_aging_ri_soa_details j, --Dean 07.16.2012
                   giac_inwfacul_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i,
                   giac_advanced_payt p
           WHERE       1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   --AND h.b140_iss_cd = j.iss_cd(+) Commented out by Dean 07.16.2012
                   AND h.b140_prem_seq_no = j.prem_seq_no(+)
                   AND h.inst_no = j.inst_no(+)
                   AND i.tran_id = p.gacc_tran_id
                   AND h.gacc_tran_id = p.gacc_tran_id
                   AND h.b140_iss_cd = p.iss_cd
                   AND h.b140_prem_seq_no = p.prem_seq_no
                   AND h.inst_no = p.inst_no
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = h.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = m.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND i.tran_id = b.gacc_tran_id(+)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND d.iss_cd = NVL (p_branch_cd, d.iss_cd) --Commented out by Dean 07.09.2012
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd) --Dean 07.09.2012
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1 -- added by mikel 07.03.2012
                   AND a.iss_cd <> 'BB'
                   AND NOT EXISTS
                         (SELECT   n.gacc_tran_id
                            FROM   GIAC_REVERSALS n,
                                   GIAC_ACCTRANS o,
                                   GIAC_INWFACUL_PREM_COLLNS h
                           WHERE       n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND ( (p_post_tran = 'P'
                                          AND (TRUNC (o.posting_date) IS NOT NULL
                                               OR TRUNC (o.posting_date) <=
                                                    p_tran_date2))
                                        OR (p_post_tran = 'T'
                                            AND TRUNC (O.TRAN_DATE) <=
                                                  p_tran_date2)))
                   AND p.acct_ent_date BETWEEN p_tran_date1 AND p_tran_date2
          UNION ALL
          SELECT   'DIRECT' dir_inw,
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   ||  LPAD (h.b140_prem_seq_no, 12, 0)   -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no
                      BILL_NO,
                   -h.premium_amt premium,
                   -DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt,
                   -f.tax_amt,
                   -j.balance_amt_due os_bal,
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_soa_details j,
                   giac_tax_collns f,
                   giac_direct_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i,
                   giac_reversals c
           WHERE   1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND h.b140_iss_cd = j.iss_cd(+)
                   AND h.b140_prem_seq_no = j.prem_seq_no(+)
                   AND h.inst_no = j.inst_no(+)
                   AND f.b160_tax_cd = giacp.n ('EVAT')
                   AND h.gacc_tran_id = f.gacc_tran_id
                   AND h.b140_iss_cd = f.b160_iss_cd
                   AND h.b140_prem_seq_no = f.b160_prem_seq_no
                   AND h.inst_no = f.inst_no
                   AND c.gacc_tran_id = h.gacc_tran_id(+)
                   AND c.gacc_tran_id = h.gacc_tran_id(+)
                   AND c.gacc_tran_id = m.gacc_tran_id(+)
                   AND c.gacc_tran_id = m.gacc_tran_id(+)
                   AND c.gacc_tran_id = b.gacc_tran_id(+)
                   AND c.gacc_tran_id = b.gacc_tran_id(+)
                   AND c.reversing_tran_id = i.tran_id
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1
                   AND a.iss_cd <> 'BB'
                   AND i.tran_class IN ('COL', 'DV', 'JV', 'REV') --mikel 02.11.2014; added REV
                   AND i.tran_flag != 'D'
                   AND ( (p_post_tran = 'P'
                          AND TRUNC (i.posting_date) BETWEEN (p_tran_date1)
                                                         AND  (p_tran_date2))
                        OR (p_post_tran = 'T'
                            AND TRUNC (i.tran_date) BETWEEN (p_tran_date1)
                                                        AND  (p_tran_date2)))
          UNION ALL
          SELECT   'INWARD',
                   i.tran_date pyt_date,
                   i.tran_class tran_class,
                   get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)  -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no
                      bill_no,
                   -h.premium_amt premium,
                   -DECODE (h.premium_amt, 0, 0, h.collection_amt) pyt_amt,
                   -h.tax_amount,
                   -j.balance_due os_bal,
                   a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no,
                   a.ref_pol_no,
                   a.incept_date incept_date,
                   a.expiry_date expiry_date,
                   a.acct_ent_date,
                   a.subline_cd subline_cd,
                   a.iss_cd iss_cd,
                   a.issue_yy issue_yy,
                   a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no,
                   a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy,
                   a.endt_seq_no endt_seq_no,
                   a.assd_no,
                   a.par_id
            FROM   gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_ri_soa_details j,
                   giac_inwfacul_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i,
                   giac_reversals c
           WHERE       1 = 1
                   AND d.policy_id = a.policy_id
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.iss_cd = h.b140_iss_cd
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND d.prem_seq_no = h.b140_prem_seq_no
                   AND h.b140_prem_seq_no = j.prem_seq_no(+)
                   AND h.inst_no = j.inst_no(+)
                   AND c.gacc_tran_id = h.gacc_tran_id(+)
                   AND c.gacc_tran_id = h.gacc_tran_id(+)
                   AND c.gacc_tran_id = m.gacc_tran_id(+)
                   AND c.gacc_tran_id = m.gacc_tran_id(+)
                   AND c.gacc_tran_id = b.gacc_tran_id(+)
                   AND c.gacc_tran_id = b.gacc_tran_id(+)
                   AND c.reversing_tran_id = i.tran_id
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    i.gibr_branch_cd,
                                                    'GIACS108') = 1
                   AND a.iss_cd <> 'BB'
                   AND i.tran_class IN ('COL', 'DV', 'JV') --mikel 02.11.2014; added REV
                   AND i.tran_flag != 'D'
                   AND ( (p_post_tran = 'P'
                          AND TRUNC (i.posting_date) BETWEEN (p_tran_date1)
                                                         AND  (p_tran_date2))
                        OR (p_post_tran = 'T'
                            AND TRUNC (i.tran_date) BETWEEN (p_tran_date1)
                                                        AND  (p_tran_date2)))
          ORDER BY   1,
                     10,
                     16,
                     17,
                     18,
                     19,
                     20,
                     21,
                     22,
                     23)
      LOOP
         --1. get LINE_NAME--
         FOR l IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.line_cd)
         LOOP
            v_line_name := l.line_name;
         END LOOP;

         --end 1--

         --2. get TIN, ADDR, ASSD_NAME--
         --retrieve assured data by PAR_ID if by ASSD_NO is not applicable.--
         FOR a
         IN (SELECT   assd_name,
                      assd_tin,
                         NVL (mail_addr1, ' ')
                      || ' '
                      || NVL (mail_addr2, ' ')
                      || ' '
                      || NVL (mail_addr3, ' ')
                         address
               FROM   GIIS_ASSURED
              WHERE   assd_no = rec.assd_no)
         LOOP
            data_found_flag := 'Y';
            v_tin := a.assd_tin;
            v_addr := a.address;
            v_assd_name := a.assd_name;
         END LOOP;

         --if no data is found by ASSD_NO then get data by PAR_ID--
         IF data_found_flag = 'N'
         THEN
            FOR b
            IN (SELECT   assd_name,
                         assd_tin,
                            NVL (mail_addr1, ' ')
                         || ' '
                         || NVL (mail_addr2, ' ')
                         || ' '
                         || NVL (mail_addr3, ' ')
                            address
                  FROM   GIIS_ASSURED
                 WHERE   assd_no IN (SELECT   assd_no
                                       FROM   GIPI_PARLIST
                                      WHERE   Par_id = rec.par_id))
            LOOP
               v_tin := b.assd_tin;
               v_addr := b.address;
               v_assd_name := b.assd_name;
            END LOOP;
         END IF;

         --end 2--

         --3. get EVAT--
         IF NVL (rec.tax_amt, 0) = 0
         THEN
            v_evat1 := 0;
         ELSE
            v_evat1 := rec.tax_amt;
         END IF;

         --end 3--

         v_evat.dir_inw := rec.dir_inw;
         v_evat.line_name := v_line_name;
         v_evat.policy_no := rec.policy_no;
         v_evat.ref_pol_no := rec.ref_pol_no;
         v_evat.incept_date := rec.incept_date;
         v_evat.expiry_date := rec.expiry_date;
         v_evat.acct_ent_date := rec.acct_ent_date;
         v_evat.assd_name := v_assd_name;
         v_evat.addr := v_addr;
         v_evat.tin := v_tin;
         v_evat.bill_no := rec.bill_no;
         v_evat.premium := rec.premium;
         v_evat.evat := v_evat1;
         v_evat.pyt_date := rec.pyt_date;
         v_evat.pyt_ref := rec.pyt_ref;
         v_evat.pyt_amt := rec.pyt_amt;
         v_evat.os_bal := rec.os_bal;

         PIPE ROW (v_evat);
      END LOOP;

      RETURN;
   END CSV_EVAT;

   --## END FUNCTION CSV_EVAT ##--

   --## FUNCTION CSV_INPUT_VAT1 ##--
   FUNCTION CSV_INPUT_VAT1 (p_branch_cd    VARCHAR2,
                            p_include      VARCHAR2,
                            p_from_date    VARCHAR2,
                            p_to_date      VARCHAR2,
                            p_tran_post    VARCHAR2)
      RETURN input_vat1_type
      PIPELINED
   IS
      v_input_vat1   input_vat1_rec_type;
      --1--
      v_amt_o_vat    NUMBER;
   BEGIN
      FOR rec
      IN (SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7
                      "JOY",
                   b.payor name,
                   d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                   DECODE (
--                      b.or_no,
--                      NULL,
--                      'COL ',
--                      'COL ' || b.or_pref_suf || '-' || TO_CHAR (b.or_no)
--                   )
--                      ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (
                      NVL (e.debit_amt, 0),
                      0,
                      DECODE (NVL (e.credit_amt, 0), 0, 0, e.credit_amt * -1),
                      NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                   )
                      input_vat,
                   b.particulars particulars,
                   b.tin tin,
                   e.sl_cd,
                   ' ' address
            FROM   giac_order_of_payts b,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb
           WHERE       e.gacc_tran_id = b.gacc_tran_id(+)
                   AND d.tran_id = e.gacc_tran_id
                   AND e.gacc_gibr_branch_cd = gb.branch_cd
                   AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                   AND e.gl_acct_id IN
                            (SELECT   ch.gl_acct_id
                               FROM   giac_module_entries me,
                                      giac_modules m,
                                      giac_chart_of_accts ch
                              WHERE   me.module_id = m.module_id
                                      AND me.gl_acct_category =
                                            ch.gl_acct_category
                                      AND me.gl_control_acct =
                                            ch.gl_control_acct
                                      AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                      AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                      AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                      AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                      AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                      AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                      AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                      AND m.module_name = 'GIACS039')
                   AND d.tran_class = 'COL'
                   AND ( (p_tran_post = 'P'
                          AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                        p_from_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )
                                                 AND  TO_DATE (
                                                         p_to_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      ))
                        OR (p_tran_post = 'T'
                            AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                       p_from_date,
                                                       'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                    )
                                                AND  TO_DATE (
                                                        p_to_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )))
                   AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C')))
                   AND e.gacc_gibr_branch_cd =
                         NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    d.gibr_branch_cd,
                                                    'GIACS104') = 1 -- added by mikel 07.03.2012
          UNION ALL --changed to UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7
                      "JOY",
                   c.payee name,
                   d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16                   
--                   DECODE (c.dv_no,
--                           NULL, 'DV ',
--                           'DV ' || c.dv_pref || '-' || TO_CHAR (c.dv_no))
--                      ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (
                      NVL (e.debit_amt, 0),
                      0,
                      DECODE (NVL (e.credit_amt, 0), 0, 0, e.credit_amt * -1),
                      NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                   )
                      input_vat,
                   c.particulars particulars,
                   x.tin tin,
                   e.sl_cd,
                   x.mail_addr1 || ' ' || x.mail_addr2 || ' ' || x.mail_addr3
                      address
            FROM   giac_disb_vouchers c,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb,
                   giis_payees x
           WHERE       e.gacc_tran_id = c.gacc_tran_id(+)
                   AND d.tran_id = e.gacc_tran_id
                   AND e.gacc_gibr_branch_cd = gb.branch_cd
                   AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                   AND e.gl_acct_id IN
                            (SELECT   ch.gl_acct_id
                               FROM   giac_module_entries me,
                                      giac_modules m,
                                      giac_chart_of_accts ch
                              WHERE   me.module_id = m.module_id
                                      AND me.gl_acct_category =
                                            ch.gl_acct_category
                                      AND me.gl_control_acct =
                                            ch.gl_control_acct
                                      AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                      AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                      AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                      AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                      AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                      AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                      AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                      AND m.module_name = 'GIACS039')
                   AND d.tran_class = 'DV'
                   AND ( (p_tran_post = 'P'
                          AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                        p_from_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )
                                                 AND  TO_DATE (
                                                         p_to_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      ))
                        OR (p_tran_post = 'T'
                            AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                       p_from_date,
                                                       'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                    )
                                                AND  TO_DATE (
                                                        p_to_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )))
                   AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C')))
                   AND e.gacc_gibr_branch_cd =
                         NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    d.gibr_branch_cd,
                                                    'GIACS104') = 1 -- added by mikel 07.03.2012
                   AND c.payee_class_cd = x.payee_class_cd
                   AND c.payee_no = x.payee_no
          UNION ALL --changed to UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7
                      "JOY",
                   ' ' name,
                   d.tran_class tran_class,
                   NVL (d.tran_date, NULL) tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                   DECODE (
--                      d.tran_class,
--                      'JV',
--                      d.tran_class || '-' || d.jv_no,
--                         d.tran_class
--                      || '-'
--                      || TO_CHAR (d.tran_year)
--                      || '-'
--                      || TO_CHAR (d.tran_month)
--                      || '-'
--                      || TO_CHAR (d.tran_seq_no)
--                   )
--                      ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (
                      NVL (e.debit_amt, 0),
                      0,
                      DECODE (NVL (e.credit_amt, 0), 0, 0, e.credit_amt * -1),
                      NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                   )
                      input_vat,
                   d.particulars particulars,
                   ' ' tin,
                   e.sl_cd,
                   ' ' address
            FROM   giac_acctrans d, giac_acct_entries e, giac_branches gb
           WHERE       d.tran_id = e.gacc_tran_id
                   AND e.gacc_gibr_branch_cd = gb.branch_cd
                   AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                   AND e.gl_acct_id IN
                            (SELECT   ch.gl_acct_id
                               FROM   giac_module_entries me,
                                      giac_modules m,
                                      giac_chart_of_accts ch
                              WHERE   me.module_id = m.module_id
                                      AND me.gl_acct_category =
                                            ch.gl_acct_category
                                      AND me.gl_control_acct =
                                            ch.gl_control_acct
                                      AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                      AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                      AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                      AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                      AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                      AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                      AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                      AND m.module_name = 'GIACS039')
                   AND d.tran_class NOT IN ('COL', 'DV')
                   AND ( (p_tran_post = 'P'
                          AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                        p_from_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )
                                                 AND  TO_DATE (
                                                         p_to_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      ))
                        OR (p_tran_post = 'T'
                            AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                       p_from_date,
                                                       'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                    )
                                                AND  TO_DATE (
                                                        p_to_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )))
                   AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C')))
                   AND e.gacc_gibr_branch_cd =
                         NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    d.gibr_branch_cd,
                                                    'GIACS104') = 1 -- added by mikel 07.03.2012
          UNION ALL --changed to UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7
                      "JOY",
                   c.payee name,
                   d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                      f.document_cd
--                   || '-'
--                   || DECODE (f.line_cd, NULL, '', f.line_cd || '-')
--                   || DECODE (f.doc_year,
--                              NULL, '',
--                              SUBSTR (f.doc_year, 3) || '-')
--                   || DECODE (f.doc_mm, NULL, '', doc_mm || '-')
--                   || f.doc_seq_no
--                      ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (
                      NVL (e.debit_amt, 0),
                      0,
                      DECODE (NVL (e.credit_amt, 0), 0, 0, e.credit_amt * -1),
                      NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                   )
                      input_vat,
                   c.particulars particulars,
                   y.tin tin,
                   e.sl_cd,
                   y.mail_addr1 || ' ' || y.mail_addr2 || ' ' || y.mail_addr3
                      address
            FROM   giac_payt_requests_dtl c,
                   giac_payt_requests f,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb,
                   giis_payees y
           WHERE       e.gacc_tran_id = c.tran_id(+)
                   AND c.gprq_ref_id = f.ref_id
                   AND d.tran_id = e.gacc_tran_id
                   AND e.gacc_gibr_branch_cd = gb.branch_cd
                   AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                   AND e.gl_acct_id IN
                            (SELECT   ch.gl_acct_id
                               FROM   giac_module_entries me,
                                      giac_modules m,
                                      giac_chart_of_accts ch
                              WHERE   me.module_id = m.module_id
                                      AND me.gl_acct_category =
                                            ch.gl_acct_category
                                      AND me.gl_control_acct =
                                            ch.gl_control_acct
                                      AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                      AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                      AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                      AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                      AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                      AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                      AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                      AND m.module_name = 'GIACS039')
                   AND d.tran_class = 'DV'
                   AND f.with_dv = 'N'
                   AND ( (p_tran_post = 'P'
                          AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                        p_from_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )
                                                 AND  TO_DATE (
                                                         p_to_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      ))
                        OR (p_tran_post = 'T'
                            AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                       p_from_date,
                                                       'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                    )
                                                AND  TO_DATE (
                                                        p_to_date,
                                                        'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                     )))
                   AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C')))
                   AND e.gacc_gibr_branch_cd =
                         NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    d.gibr_branch_cd,
                                                    'GIACS104') = 1 -- added by mikel 07.03.2012
                   AND c.payee_class_cd = y.payee_class_cd
                   AND c.payee_cd = y.payee_no
          ORDER BY   name)
      LOOP
         --1. get AMT_SUBJTO_VAT--
         v_amt_o_vat := rec.input_vat / .12;
         --end 1--

         v_input_vat1.branch := rec.branch;
         v_input_vat1.name := rec.name;
         v_input_vat1.address := rec.address;
         v_input_vat1.tin := rec.tin;
         v_input_vat1.particulars := rec.particulars;
         v_input_vat1.tran_date := rec.tran_date;
         v_input_vat1.ref_no := rec.ref_no;
         v_input_vat1.amt_subjto_vat := v_amt_o_vat;
         v_input_vat1.input_vat := rec.input_vat;

         PIPE ROW (v_input_vat1);
      END LOOP;

      RETURN;
   END CSV_INPUT_VAT1;

   --## END FUNCTION CSV_INPUT_VAT1 ##--

   --## FUNCTION CSV_INPUT_VAT2 ##--
   FUNCTION CSV_INPUT_VAT2 (p_branch_cd    VARCHAR2,
                            p_include      VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
                            p_from_date    VARCHAR2,
                            p_to_date      VARCHAR2,
                            p_tran_post    VARCHAR2)
      RETURN input_vat2_type
      PIPELINED
   IS
      v_input_vat2       input_vat2_rec_type;
      --1--
      v_sl_nm            VARCHAR2 (1000);
      --2--
      v_add              VARCHAR2 (200);
      --3--
      v_tin              VARCHAR2 (30);
      --4--
      v_amt_o_vat        NUMBER;
      v_input_vat_rate   NUMBER;
   BEGIN
      FOR rec
      IN (  SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                        e.gl_acct_category
                     || '-'
                     || e.gl_control_acct
                     || '-'
                     || e.gl_sub_acct_1
                     || '-'
                     || e.gl_sub_acct_2
                     || '-'
                     || e.gl_sub_acct_3
                     || '-'
                     || e.gl_sub_acct_4
                     || '-'
                     || e.gl_sub_acct_5
                     || '-'
                     || e.gl_sub_acct_6
                     || '-'
                     || e.gl_sub_acct_7
                        "JOY",
                     DECODE (d.tran_class,
                             'COL',
                             b.payor,
                             'DV',
                             c.payee)
                        name,
                     d.tran_class tran_class,
                     d.tran_date tran_date,
--                   changed to get_ref_no by robert SR 5223 03.11.16
--                     DECODE (
--                        d.tran_class,
--                        'COL',
--                        DECODE (b.or_no,
--                                NULL, ' ',
--                                b.or_pref_suf || '-' || TO_CHAR (b.or_no)),
--                        'DV',
--                        DECODE (c.dv_no,
--                                NULL, ' ',
--                                c.dv_pref || '-' || TO_CHAR (c.dv_no)),
--                        'JV',
--                        DECODE (d.jv_no,
--                                NULL, ' ',
--                                d.tran_class || '-' || TO_CHAR (d.jv_no)),
--                           d.tran_class
--                        || '-'
--                        || TO_CHAR (d.tran_year)
--                        || '-'
--                        || TO_CHAR (d.tran_month)
--                        || '-'
--                        || TO_CHAR (d.tran_seq_no)
--                     )
--                        ref_no,
                     get_ref_no(e.gacc_tran_id) ref_no,
                     DECODE (NVL (e.debit_amt, 0),
                             0, e.credit_amt * -1,
                             e.debit_amt - NVL ( (e.credit_amt), 0))
                        input_vat,
                     DECODE (d.tran_class,
                             'COL',
                             b.particulars,
                             'DV',
                             c.particulars,
                             'JV',
                             d.particulars)
                        particulars,
                     e.sl_source_cd,
                     e.sl_cd,
                     e.sl_type_cd,
                     c.payee_no,
                     c.payee_class_cd
              FROM   giac_order_of_payts b,
                     giac_disb_vouchers c,
                     giac_acctrans d,
                     giac_acct_entries e,
                     giac_branches gb,
                     giac_sl_lists gl
             WHERE       e.gacc_tran_id = b.gacc_tran_id(+)
                     AND e.gacc_tran_id = c.gacc_tran_id(+)
                     AND d.tran_id = e.gacc_tran_id
                     AND e.gacc_tran_id = d.tran_id
                     AND e.gacc_gibr_branch_cd = gb.branch_cd
                     AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                     AND e.sl_cd = gl.sl_cd(+)
                     AND e.sl_type_cd = gl.sl_type_cd(+)
                     AND e.gl_acct_id IN
                              (SELECT   ch.gl_acct_id
                                 FROM   giac_module_entries me,
                                        giac_modules m,
                                        giac_chart_of_accts ch
                                WHERE   me.module_id = m.module_id
                                        AND me.gl_acct_category =
                                              ch.gl_acct_category
                                        AND me.gl_control_acct =
                                              ch.gl_control_acct
                                        AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                        AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                        AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                        AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                        AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                        AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                        AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                        AND m.module_name = 'GIACS039')
                     AND d.tran_flag <> 'D'
                     AND ( (p_tran_post = 'P'
                            AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                          p_from_date,
                                                          'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                       )
                                                   AND  TO_DATE (
                                                           p_to_date,
                                                           'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                        ))
                          OR (p_tran_post = 'T'
                              AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                         p_from_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      )
                                                  AND  TO_DATE (
                                                          p_to_date,
                                                          'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                       )))
                     AND e.gacc_gibr_branch_cd =
                           NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                     AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))) --added by vondanix  12.16.2015 RSIC GENQA 5223
                     AND check_user_per_iss_cd_acctg (NULL,
                                                      d.gibr_branch_cd,
                                                      'GIACS104') = 1 -- added by mikel 07.03.2012
          ORDER BY   2, 3, 7)
      LOOP
         --1. get SL_NAME--
         IF rec.sl_cd IS NOT NULL
         THEN
            IF rec.sl_source_cd = '2'
            THEN
               BEGIN
                  SELECT   DECODE (
                              payee_first_name,
                              NULL,
                                 payee_last_name
                              || ' '
                              || payee_first_name
                              || ' '
                              || payee_middle_name
                              || '  *',
                                 payee_last_name
                              || ', '
                              || payee_first_name
                              || ' '
                              || payee_middle_name
                              || '  *'
                           )
                              sl_nm
                    INTO   v_sl_nm
                    FROM   giis_payees a, giis_payee_class b
                   WHERE       a.payee_class_cd = b.payee_class_cd
                           AND b.sl_type_cd = rec.sl_type_cd
                           AND a.payee_no = rec.payee_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_sl_nm := '_invalid PAYEE_';
               END;
            ELSE
               BEGIN
                  SELECT   sl_name sl_nm
                    INTO   v_sl_nm
                    FROM   giac_sl_lists
                   WHERE   sl_type_cd = rec.sl_type_cd AND sl_cd = rec.sl_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_sl_nm := '_invalid SL_';
               END;
            END IF;
         ELSE
            v_sl_nm := '_______No SL Code_______';
         END IF;

         --end 1--

         --2. get ADDRESS--
         IF rec.sl_cd IS NOT NULL
         THEN
            IF rec.sl_source_cd = '2'
            THEN
               BEGIN
                  SELECT      mail_addr1
                           || ' '
                           || mail_addr2
                           || ' '
                           || mail_addr3
                              address
                    INTO   v_add
                    FROM   giis_payees a, giis_payee_class b
                   WHERE       a.payee_class_cd = b.payee_class_cd
                           AND b.sl_type_cd = rec.sl_type_cd
                           AND a.payee_no = rec.payee_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_add := '_invalid PAYEE_';
               END;
            ELSE
               BEGIN
                  SELECT      mail_addr1
                           || ' '
                           || mail_addr2
                           || ' '
                           || mail_addr3
                              address
                    INTO   v_add
                    FROM   GIIS_PAYEE_CLASS GPC,
                           GIIS_PAYEES GP,
                           GIAC_SL_LISTS GSL
                   WHERE       GPC.PAYEE_CLASS_CD = GP.PAYEE_CLASS_CD
                           AND gpc.sl_type_cd = gsl.sl_type_cd
                           AND gsl.sl_type_cd = rec.sl_type_cd
                           AND sl_cd = rec.sl_cd
                           AND payee_no = rec.sl_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_add := '_invalid SL_';
               END;
            END IF;
         ELSE
            v_add := '_______No SL Code_______';
         END IF;

         --end 2--

         --3. get TIN--
         IF rec.sl_cd IS NOT NULL
         THEN
            IF rec.sl_source_cd = '2'
            THEN
               BEGIN
                  SELECT   tin
                    INTO   v_tin
                    FROM   GIIS_PAYEE_CLASS GPC, GIIS_PAYEES GP
                   WHERE       GPC.PAYEE_CLASS_CD = GP.PAYEE_CLASS_CD
                           AND gpc.payee_class_cd = rec.payee_class_cd
                           AND payee_no = rec.payee_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_tin := '_invalid PAYEE_';
               END;
            ELSE
               BEGIN
                  SELECT   tin
                    INTO   v_tin
                    FROM   GIIS_PAYEE_CLASS GPC,
                           GIIS_PAYEES GP,
                           GIAC_SL_LISTS GSL
                   WHERE       GPC.PAYEE_CLASS_CD = GP.PAYEE_CLASS_CD
                           AND gpc.sl_type_cd = gsl.sl_type_cd
                           AND gsl.sl_type_cd = rec.sl_type_cd
                           AND sl_cd = rec.sl_cd
                           AND payee_no = rec.sl_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_tin := '_invalid SL_';
               END;
            END IF;
         END IF;

         --end 3--

         --4. get AMT_SUBJTO_VAT--
         SELECT   param_value_n / 100
           INTO   v_input_vat_rate
           FROM   giac_parameters
          WHERE   param_name = 'INPUT_VAT_RT';

         v_amt_o_vat := rec.input_vat / v_input_vat_rate;
         --end 4--

         v_input_vat2.branch := rec.branch;
         v_input_vat2.sl_name := v_sl_nm;
         v_input_vat2.address := v_add;
         v_input_vat2.tin := v_tin;
         v_input_vat2.particulars := rec.particulars;
         v_input_vat2.tran_date := rec.tran_date;
         v_input_vat2.ref_no := rec.ref_no;
         v_input_vat2.amt_subjto_vat := v_amt_o_vat;
         v_input_vat2.input_vat := rec.input_vat;

         PIPE ROW (v_input_vat2);
      END LOOP;

      RETURN;
   END CSV_INPUT_VAT2;

   --## END FUNCTION CSV_INPUT_VAT2 ##--

   --## FUNCTION CSV_INPUT_VAT3 ##--
   FUNCTION CSV_INPUT_VAT3 (p_branch_cd    VARCHAR2,
                            p_include      VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
                            p_from_date    VARCHAR2,
                            p_to_date      VARCHAR2,
                            p_tran_post    VARCHAR2)
      RETURN input_vat3_type
      PIPELINED
   IS
      v_input_vat3   input_vat3_rec_type;
      --1--
      v_tin          GIIS_PAYEES.tin%TYPE;
      --2--
      v_add          VARCHAR2 (200);
      --3--
      v_amt          NUMBER;
   BEGIN
      FOR rec
      IN (  SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                     SUM(DECODE (NVL (e.debit_amt, 0),
                                 0, e.credit_amt * -1,
                                 e.debit_amt - NVL ( (e.credit_amt), 0)))
                        input_vat,
                     e.sl_source_cd,
                     e.sl_cd,
                     e.sl_type_cd,
                     LTRIM(DECODE (
                              e.sl_cd,
                              NULL,
                              '_______No SL Code_______',
                              (DECODE (
                                  e.sl_source_cd,
                                  2,
                                  (SELECT      payee_last_name
                                            || ' '
                                            || payee_first_name
                                            || ' '
                                            || payee_middle_name
                                            || '  *'
                                     FROM   giis_payees a, giis_payee_class b
                                    WHERE   a.payee_class_cd = b.payee_class_cd
                                            AND b.sl_type_cd = e.sl_type_cd
                                            AND a.payee_no = e.sl_cd),
                                  (SELECT   sl_name
                                     FROM   giac_sl_lists
                                    WHERE   sl_type_cd = e.sl_type_cd
                                            AND sl_cd = e.sl_cd)
                               ))
                           ))
                        AS sl_name
              FROM   giac_order_of_payts b,
                     giac_disb_vouchers c,
                     giac_acctrans d,
                     giac_acct_entries e,
                     giac_branches gb,
                     giac_sl_lists gl
             WHERE       e.gacc_tran_id = b.gacc_tran_id(+)
                     AND e.gacc_tran_id = c.gacc_tran_id(+)
                     AND d.tran_id = e.gacc_tran_id
                     AND e.gacc_tran_id = d.tran_id
                     AND e.gacc_gibr_branch_cd = gb.branch_cd
                     AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
                     AND e.sl_cd = gl.sl_cd(+)
                     AND e.sl_type_cd = gl.sl_type_cd(+)
                     AND e.gl_acct_id IN
                              (SELECT   ch.gl_acct_id
                                 FROM   giac_module_entries me,
                                        giac_modules m,
                                        giac_chart_of_accts ch
                                WHERE   me.module_id = m.module_id
                                        AND me.gl_acct_category =
                                              ch.gl_acct_category
                                        AND me.gl_control_acct =
                                              ch.gl_control_acct
                                        AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                                        AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                                        AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                                        AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                                        AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                                        AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                                        AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                                        AND m.module_name = 'GIACS039')
                     AND d.tran_flag <> 'D'
                     AND ( (p_tran_post = 'P'
                            AND TRUNC(d.posting_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                          p_from_date,
                                                          'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                       )
                                                   AND  TO_DATE (
                                                           p_to_date,
                                                           'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                        ))
                          OR (p_tran_post = 'T'
                              AND TRUNC(d.tran_date) BETWEEN TO_DATE ( --added trunc vondanix 12.16.15 RSIC GENQA 5223
                                                         p_from_date,
                                                         'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                      )
                                                  AND  TO_DATE (
                                                          p_to_date,
                                                          'MM-DD-RRRR' --'fmMonth DD, RRRR' -- changed by shan 07.31.2014
                                                       )))
                     AND ( (p_include = 'I' AND d.tran_flag != 'D')
                        OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))) --added by vondanix  12.16.2015 RSIC GENQA 5223
                     AND e.gacc_gibr_branch_cd =
                           NVL (p_branch_cd, e.gacc_gibr_branch_cd)
                     AND check_user_per_iss_cd_acctg (NULL,
                                                      d.gibr_branch_cd,
                                                      'GIACS104') = 1 -- added by mikel 07.03.2012
          GROUP BY   e.gacc_gibr_branch_cd || '-' || gb.branch_name,
                     e.sl_source_cd,
                     e.sl_cd,
                     e.sl_type_cd
          ORDER BY   6,
                     3,
                     4,
                     5)
      LOOP
         --1. get TIN--
         BEGIN
            SELECT   tin
              INTO   v_tin
              FROM   giis_payees a, giis_payee_class b
             WHERE       a.payee_class_cd = b.payee_class_cd
                     AND b.sl_type_cd = rec.sl_type_cd
                     AND a.payee_no = rec.sl_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tin := NULL;
         END;

         --end 1--

         --2. get ADDRESS--
         FOR a
         IN (SELECT   mail_addr1 || ' ' || mail_addr2 || ' ' || mail_addr3
                         address
               FROM   giis_payees c, giis_payee_class d
              WHERE       c.payee_class_cd = d.payee_class_cd
                      AND d.sl_type_cd = rec.sl_type_cd
                      AND c.payee_no = rec.sl_cd)
         LOOP
            v_add := a.address;
            EXIT;
         END LOOP;

         --end 2--

         --3. get AMT_SUBJTO_VAT--
         v_amt := rec.input_vat / .12;
         --end 3--

         v_input_vat3.branch := rec.branch;
         v_input_vat3.sl_name := rec.sl_name;
         v_input_vat3.tin := v_tin;
         v_input_vat3.address := v_add;
         v_input_vat3.amt_subjto_vat := v_amt;
         v_input_vat3.input_vat := rec.input_vat;

         PIPE ROW (v_input_vat3);
      END LOOP;

      RETURN;
   END CSV_INPUT_VAT3;

   --## END FUNCTION CSV_INPUT_VAT3 ##--

   -- START added by Jayson 11.28.2011 --
   FUNCTION csv_wtax_giacr107 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id  VARCHAR2)
      RETURN wtax_giacr107_table
      PIPELINED
   IS
      rec_type   wtax_giacr107_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   INITCAP (d.class_desc) class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     SUM (a.income_amt) income,
                     SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d
             WHERE   1 = 1
                     /*AND a.gacc_tran_id NOT IN
                           (SELECT   e.gacc_tran_id
                              FROM   giac_reversals e, giac_acctrans f
                             WHERE   e.reversing_tran_id = f.tran_id
                                     AND f.tran_flag <> 'D')*/
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, p_MODULE_ID) = 1     
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
          /*  union all and succeeding codes commented out by jongs 02.26.2014           
          UNION ALL
          SELECT   INITCAP (d.class_desc) class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     -SUM (a.income_amt) income,
                     -SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d,
                     giac_reversals e
             WHERE   1 = 1
                     AND e.reversing_tran_id = c.tran_id
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND c.tran_flag <> 'D'
                     AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name  */
          ORDER BY   1, 3  
          /*ORDER BY   d.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.payee_class := rec1.class_desc;
         rec_type.payee_no := rec1.payee_cd;
         rec_type.name := rec1.name;
         rec_type.income_amount := rec1.income;
         rec_type.tax_withheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr107;

   FUNCTION csv_wtax_giacr110 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id      VARCHAR2,
                               p_tax_cd         VARCHAR2) -- Added by Jerome 10.20.2016 SR 5671
      RETURN wtax_giacr110_table
      PIPELINED
   IS
      rec_type   wtax_giacr110_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   INITCAP (d.class_desc) class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     e.bir_tax_cd,
                     e.whtax_desc,
                     b.tin,
                     SUM (a.income_amt) income,
                     e.percent_rate,
                     SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d,
                     giac_wholding_taxes e
             WHERE   1 = 1
                     /*AND a.gacc_tran_id NOT IN
                           (SELECT   e.gacc_tran_id
                              FROM   giac_reversals e, giac_acctrans f
                             WHERE   e.reversing_tran_id = f.tran_id
                                     AND f.tran_flag <> 'D')*/
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND e.whtax_id = a.gwtx_whtax_id
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, p_MODULE_ID) = 1     
                     AND e.whtax_code = NVL(p_tax_cd, e.whtax_code) -- Added by Jerome 10.20.2016 SR 5671
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     e.percent_rate,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd
          /*  union all and succeeding codes commented out by jongs 02.26.2014           
          UNION ALL
          SELECT   INITCAP (d.class_desc) class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     e.bir_tax_cd,
                     e.whtax_desc,
                     b.tin,
                     -SUM (a.income_amt) income,
                     e.percent_rate,
                     -SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d,
                     giac_wholding_taxes e,
                     giac_reversals f
             WHERE   1 = 1
                     AND f.reversing_tran_id = c.tran_id
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND a.gacc_tran_id = f.gacc_tran_id
                     AND c.tran_flag <> 'D'
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND e.whtax_id = a.gwtx_whtax_id
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, p_MODULE_ID) = 1     
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     e.percent_rate,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd  */
         ORDER BY   1, 3
          /*ORDER BY   class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.payee_class := rec1.class_desc;
         rec_type.payee_no := rec1.payee_cd;
         rec_type.name := rec1.name;
         rec_type.tax_cd := rec1.bir_tax_cd;
         rec_type.tax_name := rec1.whtax_desc;
         rec_type.tin := rec1.tin;
         rec_type.income_amt := rec1.income;
         rec_type.tax_rate := rec1.percent_rate;
         rec_type.tax_wheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr110;

   FUNCTION csv_wtax_giacr111 (p_post_tran      VARCHAR2,
                               p_date           DATE,
                               p_exclude_tag    VARCHAR2,
                               p_module_id  VARCHAR2)
      RETURN wtax_giacr111_table
      PIPELINED
   IS
      rec_type   wtax_giacr111_rec_type;
   BEGIN
      FOR rec1
      IN (SELECT   ROWNUM,
                   a.tin,
                   a.NAME,
                   a.bir_tax_cd,
                   a.income_amt,
                   a.percent_rate,
                   a.wholding_tax_amt
            FROM   (  SELECT      b.payee_last_name
                               || ' '
                               || b.payee_first_name
                               || ' '
                               || b.payee_middle_name
                                  NAME,
                               b.tin,
                               c.bir_tax_cd,
                               c.percent_rate,
                               SUM (d.income_amt) income_amt,
                               SUM (d.wholding_tax_amt) wholding_tax_amt
                        FROM   GIAC_ACCTRANS a,
                               GIIS_PAYEES b,
                               GIAC_WHOLDING_TAXES c,
                               GIAC_TAXES_WHELD d,
                               GIIS_PAYEE_CLASS e
                       WHERE       c.whtax_id = d.gwtx_whtax_id
                               AND b.payee_class_cd = e.payee_class_cd
                               AND b.payee_class_cd = d.payee_class_cd
                               AND b.payee_no = d.payee_cd
                               AND a.tran_id = d.gacc_tran_id
                               AND a.tran_flag <> 'D'
                               /*AND d.gacc_tran_id NOT IN
                                        (SELECT   e.gacc_tran_id
                                           FROM   GIAC_REVERSALS e,
                                                  GIAC_ACCTRANS f
                                          WHERE   e.reversing_tran_id =
                                                     f.tran_id
                                                  AND f.tran_flag <> 'D')*/
                               AND ( (P_POST_TRAN = 'T'
                                      AND TRUNC (a.tran_date) <= P_DATE)
                                    OR (P_POST_TRAN = 'P'
                                        AND TRUNC (a.posting_date) <= P_DATE))
                               AND ( (P_POST_TRAN = 'T'
                                      AND a.tran_flag <>
                                            NVL (P_EXCLUDE_TAG, ' '))
                                    OR P_POST_TRAN = 'P')
                               AND check_user_per_iss_cd_acctg (NULL, a.gibr_branch_cd, P_MODULE_ID) = 1     
                    GROUP BY      b.payee_last_name
                               || ' '
                               || b.payee_first_name
                               || ' '
                               || b.payee_middle_name,
                               b.tin,
                               c.bir_tax_cd,
                               c.percent_rate
                    /*   union all and succeeding codes commented out by jongs 02.26.2014           
                    UNION ALL
                    SELECT      b.payee_last_name
                               || ' '
                               || b.payee_first_name
                               || ' '
                               || b.payee_middle_name
                                  NAME,
                               b.tin,
                               c.bir_tax_cd,
                               c.percent_rate,
                               -SUM (d.income_amt) income_amt,
                               -SUM (d.wholding_tax_amt) wholding_tax_amt
                        FROM   GIAC_ACCTRANS a,
                               GIIS_PAYEES b,
                               GIAC_WHOLDING_TAXES c,
                               GIAC_TAXES_WHELD d,
                               GIIS_PAYEE_CLASS e,
                               GIAC_REVERSALS f
                       WHERE       c.whtax_id = d.gwtx_whtax_id
                               AND b.payee_class_cd = e.payee_class_cd
                               AND b.payee_class_cd = d.payee_class_cd
                               AND b.payee_no = d.payee_cd
                               AND f.reversing_tran_id = a.tran_id
                               AND f.gacc_tran_id = d.gacc_tran_id
                               AND a.tran_flag <> 'D'
                               AND ( (P_POST_TRAN = 'T'
                                      AND TRUNC (a.tran_date) <= P_DATE)
                                    OR (P_POST_TRAN = 'P'
                                        AND TRUNC (a.posting_date) <= P_DATE))
                               AND ( (P_POST_TRAN = 'T'
                                      AND a.tran_flag <>
                                            NVL (P_EXCLUDE_TAG, ' '))
                                    OR P_POST_TRAN = 'P')
                               AND check_user_per_iss_cd_acctg (NULL, a.gibr_branch_cd, P_MODULE_ID) = 1     
                    GROUP BY      b.payee_last_name
                               || ' '
                               || b.payee_first_name
                               || ' '
                               || b.payee_middle_name,
                               b.tin,
                               c.bir_tax_cd,
                               c.percent_rate */
                    --ORDER BY   NAME ASC) a)
                    ORDER BY   1 ASC) a)
      LOOP
         rec_type.seq_no := rec1.ROWNUM;
         rec_type.TIN := rec1.tin;
         rec_type.name := rec1.name;
         rec_type.atc_code := rec1.bir_tax_cd;
         rec_type.income_amt := rec1.income_amt;
         rec_type.tax_rate := rec1.percent_rate;
         rec_type.tax_wheld := rec1.wholding_tax_amt;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr111;

   FUNCTION csv_wtax_giacr253 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_tax_id         VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id  VARCHAR2)
      RETURN wtax_giacr253_table
      PIPELINED
   IS
      rec_type   wtax_giacr253_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   e.bir_tax_cd,
                     e.whtax_desc,
                     INITCAP (d.class_desc) class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     b.tin,
                     SUM (a.income_amt) income,
                     SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d,
                     giac_wholding_taxes e
             WHERE   1 = 1
                     /*AND a.gacc_tran_id NOT IN
                           (SELECT   e.gacc_tran_id
                              FROM   giac_reversals e, giac_acctrans f
                             WHERE       e.reversing_tran_id = f.tran_id
                                     AND f.tran_flag <> 'D'
                                     AND f.tran_date <= p_date2)*/
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND e.whtax_id = a.gwtx_whtax_id
                     AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
                     AND a.gwtx_whtax_id = NVL (p_tax_id, a.gwtx_whtax_id)
                     AND c.tran_flag <> NVL (p_exclude_tag, 'A')
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd  
          /*  union all and succeeding codes commented out by jongs 02.26.2014           
          UNION ALL
          SELECT   e.bir_tax_cd,
                     e.whtax_desc,
                     INITCAP (d.class_desc) class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     b.tin,
                     -SUM (a.income_amt) income,
                     -SUM (a.wholding_tax_amt) wtax
              FROM   giac_taxes_wheld a,
                     giis_payees b,
                     giac_acctrans c,
                     giis_payee_class d,
                     giac_wholding_taxes e,
                     giac_reversals f
             WHERE   1 = 1
                     AND a.payee_class_cd = b.payee_class_cd
                     AND a.payee_cd = b.payee_no
                     AND b.payee_class_cd = d.payee_class_cd
                     AND f.reversing_tran_id = c.tran_id
                     AND a.gacc_tran_id = f.gacc_tran_id
                     AND c.tran_flag <> 'D'
                     AND e.whtax_id = a.gwtx_whtax_id
                     AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
                     AND a.gwtx_whtax_id = NVL (p_tax_id, a.gwtx_whtax_id)
                     AND c.tran_flag <> NVL (p_exclude_tag, 'A')
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd  */
          ORDER BY   2, 3, 4
          /*ORDER BY   e.whtax_desc,
                     d.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.withholding_tax_cd := rec1.bir_tax_cd;
         rec_type.withholding_tax := rec1.whtax_desc;
         rec_type.payee_class := rec1.class_desc;
         rec_type.payee := rec1.NAME;
         rec_type.TIN := rec1.TIN;
         rec_type.income_amount := rec1.income;
         rec_type.tax_withheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr253;

   FUNCTION csv_wtax_giacr254 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_tax_id         VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id  VARCHAR2)
      RETURN wtax_giacr254_table
      PIPELINED
   IS
      rec_type   wtax_giacr254_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   INITCAP (a.class_desc) payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     TRUNC (c.tran_date) tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     SUM (d.income_amt) income,
                     SUM (d.wholding_tax_amt) wtax,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd,
                     b.mail_addr1 || ' ' || b.mail_addr2 || ' ' || b.mail_addr3
                        address
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d,
                     giac_wholding_taxes e
             WHERE   1=1
                    /* 
                     AND d.gacc_tran_id NOT IN
                           (SELECT   h.gacc_tran_id
                              FROM   giac_reversals h, giac_acctrans j
                             WHERE   h.reversing_tran_id = j.tran_id
                                     AND j.tran_flag <> 'D')
                                     */
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.gwtx_whtax_id = e.whtax_id
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND d.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND d.gwtx_whtax_id = NVL (p_tax_id, d.gwtx_whtax_id)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id),
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd,
                        b.mail_addr1
                     || ' '
                     || b.mail_addr2
                     || ' '
                     || b.mail_addr3
          /*  union all and succeeding codes commented out by jongs 02.26.2014                      
          UNION ALL
          SELECT   INITCAP (a.class_desc) payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     TRUNC (c.tran_date) tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     SUM (d.income_amt) income,
                     SUM (d.wholding_tax_amt) wtax,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd,
                     b.mail_addr1 || ' ' || b.mail_addr2 || ' ' || b.mail_addr3
                        address
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d,
                     giac_wholding_taxes e,
                     giac_reversals f
             WHERE   1 = 1
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.gwtx_whtax_id = e.whtax_id
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND f.reversing_tran_id = c.tran_id
                     AND d.gacc_tran_id = f.gacc_tran_id
                     AND c.tran_flag <> 'D'
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND d.gwtx_whtax_id = NVL (p_tax_id, d.gwtx_whtax_id)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id),
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd,
                        b.mail_addr1
                     || ' '
                     || b.mail_addr2
                     || ' '
                     || b.mail_addr3  */
          ORDER BY   9, 1, 2
          /*ORDER BY   e.whtax_desc,
                     class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.bir_tax_cd := rec1.bir_tax_cd;
         rec_type.bir_tax_name := rec1.whtax_desc;
         rec_type.payee_class := rec1.payee_class;
         rec_type.payee := rec1.NAME;
         rec_type.address := rec1.address;
         rec_type.TIN := rec1.TIN;
         rec_type.tran_date := rec1.tran_date;
         rec_type.posting_date := rec1.posting_date;
         rec_type.tran_class := rec1.tran_class;
         rec_type.ref_no := rec1.reference_no;
         rec_type.income_amt := rec1.income;
         rec_type.tax_wheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr254;

   FUNCTION csv_wtax_giacr255 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id  VARCHAR2)
      RETURN wtax_giacr255_table
      PIPELINED
   IS
      rec_type   wtax_giacr255_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   INITCAP (a.class_desc) payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     SUM (d.income_amt) income,
                     SUM (d.wholding_tax_amt) wtax
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d
             WHERE   1 = 1
                    /*   commented out by jongs 02.26.2014
                    
                    AND d.gacc_tran_id NOT IN
                           (SELECT   h.gacc_tran_id
                              FROM   giac_reversals h, giac_acctrans j
                             WHERE   h.reversing_tran_id = j.tran_id
                                     AND j.tran_flag <> 'D') */
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND d.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id)
          /*
          union all and succeeding codes commented out by jongs 02.26.2014
          
          UNION ALL
            SELECT   INITCAP (a.class_desc) payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        NAME,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     -SUM (d.income_amt) income,
                     -SUM (d.wholding_tax_amt) wtax
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d,
                     giac_reversals e
             WHERE   1 = 1
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND e.reversing_tran_id = c.tran_id
                     AND d.gacc_tran_id = e.gacc_tran_id
                     AND c.tran_flag <> 'D'
                     AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
                     AND ( (TRUNC (c.tran_date) BETWEEN p_date1 AND p_date2
                            AND p_post_tran = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN p_date1
                                                         AND  p_date2
                              AND p_post_tran = 'P'))
                     AND ( (p_post_tran = 'T'
                            AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                          OR p_post_tran = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id)  */
          ORDER BY   1, 2
          /*ORDER BY   class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.payee_class := rec1.payee_class;
         rec_type.payee := rec1.name;
         rec_type.tran_date := rec1.tran_date;
         rec_type.posting_date := rec1.posting_date;
         rec_type.ref_no := rec1.reference_no;
         rec_type.income_amt := rec1.income;
         rec_type.tax_wheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr255;

   FUNCTION csv_wtax_giacr256 (p_post_tran      VARCHAR2,
                               p_date1          DATE,
                               p_date2          DATE,
                               p_payee          VARCHAR2,
                               p_exclude_tag    VARCHAR2,
                               p_module_id      VARCHAR2,
                               p_tax_cd         VARCHAR2) -- Added by Jerome 10.20.2016 SR 5671
      RETURN wtax_giacr256_table
      PIPELINED
   IS
      rec_type   wtax_giacr256_rec_type;
   BEGIN
      FOR rec1
      IN (  SELECT   INITCAP (a.class_desc) Payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        Name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     SUM (d.income_amt) income,
                     SUM (d.wholding_tax_amt) wtax,
                     e.whtax_desc whtax,
                     e.percent_rate rate,
                     b.TIN,
                     e.bir_tax_cd,
                     b.mail_addr1 || ' ' || b.mail_addr2 || ' ' || b.mail_addr3
                        address
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d,
                     giac_wholding_taxes e
             WHERE   1 = 1
                     /*AND gacc_tran_id NOT IN
                           (SELECT   H.gacc_tran_id
                              FROM   giac_reversals H, giac_acctrans J
                             WHERE       H.reversing_tran_id = J.tran_id
                                     AND J.tran_flag <> 'D'
                                     AND j.tran_date <= :P_DATE2)*/
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND d.gacc_tran_id = c.tran_id
                     AND d.payee_class_cd = NVL (P_PAYEE, d.payee_class_cd)
                     AND c.tran_flag <> 'D'
                     AND ( (TRUNC (c.tran_date) BETWEEN P_DATE1 AND P_DATE2
                            AND P_POST_TRAN = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN P_DATE1
                                                         AND  P_DATE2
                              AND P_POST_TRAN = 'P'))
                     AND e.whtax_id = d.gwtx_whtax_id
                     AND ( (P_POST_TRAN = 'T'
                            AND c.tran_flag <> NVL (P_exclude_tag, ' '))
                          OR P_POST_TRAN = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1     
                     AND e.whtax_code = NVL(p_tax_cd, e.whtax_code) -- Added by Jerome 10.20.2016 SR 5671
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id),
                     e.whtax_desc,
                     e.percent_rate,
                     b.TIN,
                     e.bir_tax_cd,
                        b.mail_addr1
                     || ' '
                     || b.mail_addr2
                     || ' '
                     || b.mail_addr3
        /*  UNION ALL and succeeding codes commented out by jongs 02.26.2014  
        
           UNION ALL    
            SELECT   INITCAP (a.class_desc) Payee_class,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name
                        Name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id) reference_no,
                     -SUM (d.income_amt) income,
                     -SUM (d.wholding_tax_amt) wtax,
                     e.whtax_desc whtax,
                     e.percent_rate rate,
                     b.TIN,
                     e.bir_tax_cd,
                     b.mail_addr1 || ' ' || b.mail_addr2 || ' ' || b.mail_addr3
                        address
              FROM   giis_payee_class a,
                     giis_payees b,
                     giac_acctrans c,
                     giac_taxes_wheld d,
                     giac_wholding_taxes e,
                     giac_reversals f
             WHERE   1 = 1
                     AND d.payee_class_cd = b.payee_class_cd
                     AND d.payee_cd = b.payee_no
                     AND b.payee_class_cd = a.payee_class_cd
                     AND f.reversing_tran_id = c.tran_id
                     AND d.gacc_tran_id = f.gacc_tran_id
                     AND d.payee_class_cd = NVL (P_PAYEE, d.payee_class_cd)
                     AND c.tran_flag <> 'D'
                     AND ( (TRUNC (c.tran_date) BETWEEN P_DATE1 AND P_DATE2
                            AND P_POST_TRAN = 'T')
                          OR (TRUNC (c.posting_date) BETWEEN P_DATE1
                                                         AND  P_DATE2
                              AND P_POST_TRAN = 'P'))
                     AND e.whtax_id = d.gwtx_whtax_id
                     AND ( (P_POST_TRAN = 'T'
                            AND c.tran_flag <> NVL (P_exclude_tag, ' '))
                          OR P_POST_TRAN = 'P')
                     AND check_user_per_iss_cd_acctg (NULL, c.gibr_branch_cd, P_MODULE_ID) = 1
          GROUP BY   a.class_desc,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     get_ref_no (c.tran_id),
                     e.whtax_desc,
                     e.percent_rate,
                     b.TIN,
                     e.bir_tax_cd,
                        b.mail_addr1
                     || ' '
                     || b.mail_addr2
                     || ' '
                     || b.mail_addr3 */    
          ORDER BY   1, 2
          /*ORDER BY   CLASS_DESC,
                     RTRIM (b.payee_last_name)
                     || DECODE (b.payee_first_name,
                                '',
                                DECODE (b.payee_middle_name, '', NULL, ','),
                                ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name*/)
      LOOP
         rec_type.payee_class := rec1.payee_class;
         rec_type.payee := rec1.name;
         rec_type.address := rec1.address;
         rec_type.TIN := rec1.tin;
         rec_type.tax_cd := rec1.bir_tax_cd;
         rec_type.tax_name := rec1.whtax;
         rec_type.tax_rate := rec1.rate;
         rec_type.tran_date := rec1.tran_date;
         rec_type.posting_date := rec1.posting_date;
         rec_type.ref_no := rec1.reference_no;
         rec_type.income_amt := rec1.income;
         rec_type.tax_wheld := rec1.wtax;

         PIPE ROW (rec_type);
      END LOOP;

      RETURN;
   END csv_wtax_giacr256;
-- END added by Jayson 11.28.2011 --

END;
/



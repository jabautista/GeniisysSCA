CREATE OR REPLACE PACKAGE BODY CPI.giacr119_pkg
AS
   FUNCTION cf_co_nameformula
      RETURN VARCHAR2
   IS
      dum   VARCHAR2 (50);
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         dum := c.param_value_v;
         EXIT;
      END LOOP;

      RETURN UPPER (dum);
   END cf_co_nameformula;

   FUNCTION cf_company_addressformula
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN UPPER (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN UPPER (v_address);
   END cf_company_addressformula;

   FUNCTION cf_1formula (p_tran_date1 DATE, p_tran_date2 DATE)
      RETURN CHAR
   IS
      v_date   VARCHAR2 (70);
   BEGIN
      IF p_tran_date1 = p_tran_date2
      THEN
         v_date := TO_CHAR (p_tran_date1, 'fmMonth DD, YYYY');
      ELSE
         v_date :=
               'From '
            || TO_CHAR (p_tran_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (p_tran_date2, 'fmMonth DD, YYYY');
      END IF;

      RETURN (v_date);
   END cf_1formula;

   FUNCTION populate_giacr119_header (
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN giacr119_header_tab PIPELINED
   IS
      v_rec   giacr119_header_type;
   BEGIN
      v_rec.company_name := cf_co_nameformula;
      v_rec.company_address := cf_company_addressformula;
      v_rec.tran_date :=
         cf_1formula (TO_DATE (p_tran_date1, 'MM/DD/YYYY'),
                      TO_DATE (p_tran_date2, 'MM/DD/YYYY')
                     );
      PIPE ROW (v_rec);
      RETURN;
   END populate_giacr119_header;

   FUNCTION populate_giacr119_details (
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2,
      p_p            VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_line_cd      VARCHAR2,
      p_ri_cd        NUMBER
   )
      RETURN giacr119_details_tab PIPELINED
   AS
      v_rec        giacr119_details_type;
      tran_date1   DATE               := TO_DATE (p_tran_date1, 'MM/DD/YYYY');
      tran_date2   DATE               := TO_DATE (p_tran_date2, 'MM/DD/YYYY');
   BEGIN
      FOR i IN
         (SELECT   i.iss_name, l.line_name, r.ri_name, c.assured_name,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no, '09')) policy_number,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_seq_no, '0999999')) claim_no,
                      f.line_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.la_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.fla_seq_no, '0999999')) advice_no,
                   f.fla_date fla_date,
                   (NVL (f.adv_shr_amt, 0) * NVL (j.convert_rate, 1)
                   ) total_share,        --Dean 04.18.2012 Added convert rate
                   SUM (NVL (j.collection_amt, 0)) total_payments,
                   (  (NVL (f.adv_shr_amt, 0) * NVL (j.convert_rate, 1)
                      )                   --Dean 04.18.2012 Added convert rate
                    - SUM (NVL (j.collection_amt, 0))
                   ) total_amount_due
              FROM giis_line l,
                   giis_reinsurer r,
                   gicl_claims c,
                   gicl_advs_fla f,
                   giis_issource i,
                   giac_loss_ri_collns j,
                   giac_acctrans g
             WHERE f.claim_id = c.claim_id
               AND f.ri_cd = r.ri_cd
               AND f.line_cd = c.line_cd
               AND f.line_cd = l.line_cd
               AND i.iss_cd = c.iss_cd
               AND f.share_type = 3
               AND NVL (f.cancel_tag, 'N') = 'N'
               AND TRUNC (f.fla_date) BETWEEN (tran_date1) AND (tran_date2)
               AND l.line_cd = NVL (p_line_cd, l.line_cd)
               AND r.ri_cd = NVL (p_ri_cd, r.ri_cd)
               AND i.iss_cd = NVL (p_branch_cd, i.iss_cd)
               AND j.gacc_tran_id = g.tran_id
               AND j.a180_ri_cd = r.ri_cd
               AND j.e150_line_cd = l.line_cd
               AND j.e150_la_yy = f.la_yy
               AND j.e150_fla_seq_no = f.fla_seq_no
--   AND G.tran_flag IN ('C','P')
               AND g.tran_flag <> 'D'
               AND NOT EXISTS (
                      SELECT 1
                        FROM giac_acctrans x, giac_reversals y
                       WHERE x.tran_id = y.reversing_tran_id
                         AND y.gacc_tran_id = j.gacc_tran_id
                         AND x.tran_flag <> 'D')
               --Dean 04.18.2012 start
               AND NOT EXISTS (
                      SELECT 1
                        FROM gicl_advice
                       WHERE 1 = 1
                         AND gicl_advice.claim_id = f.claim_id
                         AND gicl_advice.adv_fla_id = f.adv_fla_id
                         AND NVL (gicl_advice.advice_flag, 'N') = 'N')
               AND 1 =
                      (SELECT DECODE
                                 (p_p,
                                  1, (SELECT 1
                                        FROM DUAL
                                       WHERE EXISTS (
                                                SELECT 1
                                                  FROM giac_direct_claim_payts c1,
                                                       gicl_advice c2,
                                                       giac_acctrans c3
                                                 WHERE 1 = 1
                                                   AND c1.claim_id =
                                                                    f.claim_id
                                                   AND c1.advice_id =
                                                                  c2.advice_id
                                                   AND c2.adv_fla_id =
                                                                  f.adv_fla_id
                                                   AND c1.gacc_tran_id =
                                                                    c3.tran_id
                                                   AND c3.tran_flag NOT IN
                                                                   ('D', 'O')
                                                   AND NOT EXISTS (
                                                          SELECT 1
                                                            FROM giac_acctrans x,
                                                                 giac_reversals y
                                                           WHERE 1 = 1
                                                             AND x.tran_id =
                                                                    y.reversing_tran_id
                                                             AND y.gacc_tran_id =
                                                                    c1.gacc_tran_id
                                                             AND x.tran_flag <>
                                                                           'D'))
                                          OR EXISTS (
                                                SELECT 1
                                                  FROM giac_inw_claim_payts c1,
                                                       gicl_advice c2,
                                                       giac_acctrans c3
                                                 WHERE 1 = 1
                                                   AND c1.claim_id =
                                                                    f.claim_id
                                                   AND c1.advice_id =
                                                                  c2.advice_id
                                                   AND c2.adv_fla_id =
                                                                  f.adv_fla_id
                                                   AND c1.gacc_tran_id =
                                                                    c3.tran_id
                                                   AND c3.tran_flag NOT IN
                                                                   ('D', 'O')
                                                   AND NOT EXISTS (
                                                          SELECT 1
                                                            FROM giac_acctrans x,
                                                                 giac_reversals y
                                                           WHERE 1 = 1
                                                             AND x.tran_id =
                                                                    y.reversing_tran_id
                                                             AND y.gacc_tran_id =
                                                                    c1.gacc_tran_id
                                                             AND x.tran_flag <>
                                                                           'D'))),
                                  0, 1
                                 )
                         FROM DUAL)
          --Dean 04.18.2012 end
          GROUP BY i.iss_name,
                   l.line_name,
                   r.ri_name,
                   c.assured_name,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no, '09')),
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_seq_no, '0999999')),
                      f.line_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.la_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.fla_seq_no, '0999999')),
                   f.fla_date,
                   (NVL (f.adv_shr_amt, 0) * NVL (j.convert_rate, 1)
                   )                                         --Dean 04.18.2012
--ORDER BY 1, 2, 3, 4, 6
          UNION
          SELECT   i.iss_name, l.line_name, r.ri_name, c.assured_name,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no, '09')) policy_number,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.clm_seq_no, '0999999')) claim_no,
                      f.line_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.la_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (f.fla_seq_no, '0999999')) advice_no,
                   f.fla_date "FLA_DATE",
                     NVL (f.adv_shr_amt, 0)
                   * NVL (a.convert_rate, 1) total_share,
                                          --Dean 04.18.2012 Added convert rate
                                                         0,                --0
                     NVL (f.adv_shr_amt, 0)
                   * NVL (a.convert_rate, 1) total_payments
                                                  --Dean 04.18.2012 replaced 0
              FROM giis_line l,
                   giis_reinsurer r,
                   gicl_claims c,
                   giis_issource i,
                   gicl_advs_fla f,
                   gicl_advice a      --Dean 04.18.2012 Added for convert rate
             WHERE f.claim_id = c.claim_id
               AND a.claim_id = c.claim_id                   --Dean 04.18.2012
               AND a.adv_fla_id = f.adv_fla_id               --Dean 04.18.2012
               AND f.ri_cd = r.ri_cd
               AND f.line_cd = c.line_cd
               AND f.line_cd = l.line_cd
               AND i.iss_cd = c.pol_iss_cd
               AND f.share_type = 3
               AND NVL (f.cancel_tag, 'N') = 'N'
               AND TRUNC (f.fla_date) BETWEEN (tran_date1) AND (tran_date2)
               AND r.ri_cd = NVL (p_ri_cd, r.ri_cd)
               AND l.line_cd = NVL (p_line_cd, l.line_cd)
               AND i.iss_cd = NVL (p_branch_cd, i.iss_cd)
               --Dean 04.18.2012 start - considered advice flag
               AND NOT EXISTS (
                      SELECT 1
                        FROM gicl_advice
                       WHERE 1 = 1
                         AND gicl_advice.claim_id = f.claim_id
                         AND gicl_advice.adv_fla_id = f.adv_fla_id
                         AND NVL (gicl_advice.advice_flag, 'N') = 'N')
               --Dean 04.18.2012 end
               AND NOT EXISTS (
                      SELECT 1
                        FROM giac_loss_ri_collns glrc, giac_acctrans gacc
                       WHERE f.line_cd = glrc.e150_line_cd
                         AND f.la_yy = glrc.e150_la_yy
                         AND f.fla_seq_no = glrc.e150_fla_seq_no
                         AND glrc.gacc_tran_id = gacc.tran_id
                         AND gacc.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giac_acctrans x, giac_reversals y
                                 WHERE x.tran_id = y.reversing_tran_id
                                   AND y.gacc_tran_id = glrc.gacc_tran_id
                                   AND x.tran_flag <> 'D'))
               AND 1 =
                      (SELECT DECODE
                                 (p_p,
                                  1, (SELECT 1
                                        FROM DUAL
                                       WHERE EXISTS (
                                                SELECT 1
                                                  FROM giac_direct_claim_payts c1,
                                                       gicl_advice c2,
                                                       giac_acctrans c3
                                                 WHERE 1 = 1
                                                   AND c1.claim_id =
                                                                    f.claim_id
                                                   AND c1.advice_id =
                                                                  c2.advice_id
                                                   AND c2.adv_fla_id =
                                                                  f.adv_fla_id
                                                   AND c1.gacc_tran_id =
                                                                    c3.tran_id
                                                   AND c3.tran_flag NOT IN
                                                                   ('D', 'O')
                                                   AND NOT EXISTS (
                                                          SELECT 1
                                                            FROM giac_acctrans x,
                                                                 giac_reversals y
                                                           WHERE 1 = 1
                                                             AND x.tran_id =
                                                                    y.reversing_tran_id
                                                             AND y.gacc_tran_id =
                                                                    c1.gacc_tran_id
                                                             AND x.tran_flag <>
                                                                           'D'))
                                          OR EXISTS (
                                                SELECT 1
                                                  FROM giac_inw_claim_payts c1,
                                                       gicl_advice c2,
                                                       giac_acctrans c3
                                                 WHERE 1 = 1
                                                   AND c1.claim_id =
                                                                    f.claim_id
                                                   AND c1.advice_id =
                                                                  c2.advice_id
                                                   AND c2.adv_fla_id =
                                                                  f.adv_fla_id
                                                   AND c1.gacc_tran_id =
                                                                    c3.tran_id
                                                   AND c3.tran_flag NOT IN
                                                                   ('D', 'O')
                                                   AND NOT EXISTS (
                                                          SELECT 1
                                                            FROM giac_acctrans x,
                                                                 giac_reversals y
                                                           WHERE 1 = 1
                                                             AND x.tran_id =
                                                                    y.reversing_tran_id
                                                             AND y.gacc_tran_id =
                                                                    c1.gacc_tran_id
                                                             AND x.tran_flag <>
                                                                           'D'))),
                                  0, 1
                                 )
                         FROM DUAL)
          ORDER BY 1, 2, 3, 4, 6)
      LOOP
         v_rec.iss_name := i.iss_name;
         v_rec.line_name := i.line_name;
         v_rec.ri_name := i.ri_name;
         v_rec.assured_name := i.assured_name;
         v_rec.policy_number := i.policy_number;
         v_rec.claim_number := i.claim_no;
         v_rec.advice_number := i.advice_no;
         v_rec.fla_date := i.fla_date;
         v_rec.total_share := i.total_share;
         v_rec.total_payments := i.total_payments;
         v_rec.total_amount_due := i.total_amount_due;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END populate_giacr119_details;
END giacr119_pkg;
/



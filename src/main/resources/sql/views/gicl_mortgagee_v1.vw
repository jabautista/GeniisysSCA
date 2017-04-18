DROP VIEW CPI.GICL_MORTGAGEE_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_mortgagee_v1 (claim_id,
                                                    policy_no,
                                                    mortg_cd,
                                                    mortg_name,
                                                    amount
                                                   )
AS
   SELECT   c.claim_id,
               b.line_cd
            || '-'
            || b.subline_cd
            || '-'
            || b.iss_cd
            || '-'
            || LTRIM (TO_CHAR (b.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
            a.mortg_cd, d.mortg_name, SUM (NVL (a.amount, 0)) amount
       FROM gicl_claims c, gipi_polbasic b, gipi_mortgagee a,
            giis_mortgagee d
      WHERE a.policy_id = b.policy_id
        AND b.renew_no = c.renew_no
        AND b.pol_seq_no = c.pol_seq_no
        AND b.issue_yy = c.issue_yy
        AND b.iss_cd = c.iss_cd
        AND b.subline_cd = c.subline_cd
        AND b.line_cd = c.line_cd
        AND b.eff_date <= c.loss_date
        AND a.mortg_cd = d.mortg_cd
        AND d.iss_cd =
               c.iss_cd
           -- add'l link, use index of giis_mortgagee to optimize. Pia, 041204
   GROUP BY claim_id,
            b.line_cd,
            b.subline_cd,
            b.iss_cd,
            b.issue_yy,
            b.pol_seq_no,
            b.renew_no,
            a.mortg_cd,
            d.mortg_name
            WITH READ ONLY;



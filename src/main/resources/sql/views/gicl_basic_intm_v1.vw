DROP VIEW CPI.GICL_BASIC_INTM_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_basic_intm_v1 (claim_id,
                                                     policy_no,
                                                     intrmdry_intm_no,
                                                     parent_intm_no,
                                                     intm_type,
                                                     intm_name
                                                    )
AS
   SELECT   /*+ALL_ROWS*/
            --totel--10/11/2007--added hint for opt
            a.claim_id,
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
            c.intrmdry_intm_no, e.parent_intm_no, e.intm_type, e.intm_name
       FROM gicl_claims a,
            gipi_polbasic b,
            gipi_comm_invoice c,
            giis_intermediary e
      WHERE a.renew_no = b.renew_no
        AND a.pol_seq_no = b.pol_seq_no
        AND a.issue_yy = b.issue_yy
        AND a.pol_iss_cd = b.iss_cd
        AND a.subline_cd = b.subline_cd
        AND a.line_cd = b.line_cd
        AND b.policy_id = c.policy_id
        AND b.pol_flag NOT IN ('4', '5')
        AND a.loss_date >= TRUNC (b.eff_date)
        AND c.intrmdry_intm_no = e.intm_no
   GROUP BY a.claim_id,
            b.line_cd,
            b.subline_cd,
            b.iss_cd,
            b.issue_yy,
            b.pol_seq_no,
            b.renew_no,
            c.intrmdry_intm_no,
            e.parent_intm_no,
            e.intm_type,
            e.intm_name
            WITH READ ONLY;



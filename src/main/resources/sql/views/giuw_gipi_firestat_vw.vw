DROP VIEW CPI.GIUW_GIPI_FIRESTAT_VW;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giuw_gipi_firestat_vw (policy_id,
                                                        pol_flag,
                                                        assd_no,
                                                        line_cd,
                                                        subline_cd,
                                                        iss_cd,
                                                        issue_yy,
                                                        pol_seq_no,
                                                        renew_no,
                                                        endt_iss_cd,
                                                        endt_yy,
                                                        endt_seq_no,
                                                        dist_no,
                                                        dist_seq_no,
                                                        poldist_dist_flag,
                                                        polbasic_dist_flag,
                                                        poldist_acct_ent_date,
                                                        poldist_acct_neg_date,
                                                        poldist_eff_date,
                                                        issue_date,
                                                        polbasic_eff_date,
                                                        booking_mth,
                                                        booking_year,
                                                        polbasic_acct_ent_date,
                                                        spld_acct_ent_date,
                                                        incept_date,
                                                        endt_expiry_date,
                                                        expiry_date,
                                                        cancel_date,
                                                        item_grp,
                                                        takeup_seq_no,
                                                        item_no,
                                                        peril_cd,
                                                        peril_type,
                                                        zone_type,
                                                        eq_zone_type,
                                                        share_cd,
                                                        currency_cd,
                                                        currency_rt,
                                                        dist_tsi,
                                                        dist_prem
                                                       )
AS
   SELECT   a.policy_id, a.pol_flag, a.assd_no, a.line_cd, a.subline_cd,
            a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd,
            a.endt_yy, a.endt_seq_no, e.dist_no, d.dist_seq_no,
            c.dist_flag poldist_dist_flag, a.dist_flag polbasic_dist_flag,
            c.acct_ent_date poldist_acct_ent_date,
            c.acct_neg_date poldist_acct_neg_date,
            c.eff_date poldist_eff_date, a.issue_date,
            a.eff_date polbasic_eff_date,
            NVL (b.multi_booking_mm, a.booking_mth) booking_mth,
            NVL (b.multi_booking_yy, a.booking_year) booking_year,
            a.acct_ent_date polbasic_acct_ent_date,
            NVL (b.spoiled_acct_ent_date,
                 a.spld_acct_ent_date
                ) spld_acct_ent_date,
            a.incept_date, a.endt_expiry_date, a.expiry_date, a.cancel_date,
            NVL (b.item_grp, 1) item_grp,
            NVL (b.takeup_seq_no, 1) takeup_seq_no, e.item_no, e.peril_cd,
            f.peril_type, f.zone_type, f.eq_zone_type, e.share_cd,
            b.currency_cd, b.currency_rt, NVL (e.dist_tsi, 0) dist_tsi,
            NVL (e.dist_prem, 0) dist_prem
       FROM gipi_polbasic a,
            gipi_invoice b,
            giuw_pol_dist c,
            giuw_policyds d,
            giuw_itemperilds_dtl e,
            giis_peril f,
            giis_line g
      WHERE 1 = 1
        AND (   (    g.line_cd = giisp.v ('LINE_CODE_FI')
                 AND g.menu_line_cd IS NULL
                )
             OR NVL (g.menu_line_cd, 'XXXXXX') = 'FI'
            )
        AND a.line_cd = g.line_cd
        AND a.policy_id = b.policy_id
        AND a.policy_id = c.policy_id
        AND NVL (b.item_grp, 1) = NVL (c.item_grp, NVL (b.item_grp, 1))
        AND NVL (b.takeup_seq_no, 1) =
                               NVL (c.takeup_seq_no, NVL (b.takeup_seq_no, 1))
        AND c.dist_no = d.dist_no
        AND NVL (d.item_grp, 1) = NVL (b.item_grp, 1)
        AND d.dist_no = e.dist_no
        AND d.dist_seq_no = e.dist_seq_no
        AND e.line_cd = f.line_cd
        AND e.peril_cd = f.peril_cd
        AND f.line_cd = g.line_cd
   ORDER BY a.line_cd,
            a.subline_cd,
            a.iss_cd,
            a.issue_yy,
            a.pol_seq_no,
            a.renew_no,
            a.endt_seq_no,
            e.dist_no,
            e.dist_seq_no,
            e.item_no,
            e.peril_cd;



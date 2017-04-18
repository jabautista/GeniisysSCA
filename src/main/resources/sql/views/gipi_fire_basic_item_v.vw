DROP VIEW CPI.GIPI_FIRE_BASIC_ITEM_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_fire_basic_item_v (line_cd,
                                                         subline_cd,
                                                         iss_cd,
                                                         issue_yy,
                                                         pol_seq_no,
                                                         renew_no,
                                                         item_no,
                                                         district_no,
                                                         block_no,
                                                         pol_flag,
                                                         ann_tsi_amt,
                                                         assd_no,
                                                         incept_date,
                                                         expiry_date
                                                        )
AS
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no,
          b.renew_no, a.item_no, a.district_no, a.block_no, b.pol_flag,
          e.ann_tsi_amt, f.assd_no, b.incept_date, b.expiry_date
     FROM gipi_fireitem a, gipi_polbasic b, gipi_item e, gipi_parlist f
    WHERE a.policy_id = b.policy_id
      AND a.policy_id = e.policy_id
      AND a.item_no = e.item_no
      AND b.par_id = f.par_id
      AND b.pol_flag != 'X'
      AND b.pol_flag != '5'
      AND NVL (b.eff_date, b.incept_date) =
             (SELECT MAX (NVL (d.eff_date, d.incept_date)) eff_date
                FROM gipi_polbasic d
               WHERE d.line_cd = b.line_cd
                 AND d.subline_cd = b.subline_cd
                 AND d.iss_cd = b.iss_cd
                 AND d.pol_seq_no = b.pol_seq_no
                 AND d.renew_no = b.renew_no
                 AND b.pol_flag != 'X'
                 AND b.pol_flag != '5');



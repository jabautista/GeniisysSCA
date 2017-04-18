DROP VIEW CPI.GIPI_VESSEL_ACC_V2;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_vessel_acc_v2 (line_cd,
                                                     subline_cd,
                                                     iss_cd,
                                                     issue_yy,
                                                     renew_no,
                                                     pol_flag,
                                                     incept_date,
                                                     expiry_date,
                                                     endt_expiry_date,
                                                     eff_date,
                                                     endt_seq_no,
                                                     endt_yy,
                                                     endt_iss_cd,
                                                     item_no,
                                                     vessel_cd,
                                                     ann_tsi_amt,
                                                     tsi_amt,
                                                     rec_flag,
                                                     par_id,
                                                     par_seq_no,
                                                     assd_no,
                                                     dist_flag,
                                                     assd_name
                                                    )
AS
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.ann_tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_seq_no, c.assd_no, f.dist_flag,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_waviation_item a,
          gipi_witem e,
          gipi_parlist c,
          giuw_pol_dist f,
          giis_assured d
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND c.par_id = f.par_id
      AND f.dist_no = f.dist_no
      AND e.ann_tsi_amt IS NOT NULL
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND NVL (b.expiry_date, b.endt_expiry_date) > SYSDATE
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.ann_tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_seq_no, c.assd_no, f.dist_flag,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_witem_ves a,
          gipi_witem e,
          gipi_parlist c,
          giuw_pol_dist f,
          giis_assured d
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND c.par_id = f.par_id
      AND f.dist_no = f.dist_no
      AND e.ann_tsi_amt IS NOT NULL
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND NVL (b.expiry_date, b.endt_expiry_date) > SYSDATE
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.ann_tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_seq_no, c.assd_no, f.dist_flag,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_wcargo a,
          gipi_witem e,
          gipi_parlist c,
          giuw_pol_dist f,
          giis_assured d
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND c.par_id = f.par_id
      AND f.dist_no = f.dist_no
      AND e.ann_tsi_amt IS NOT NULL
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND NVL (b.expiry_date, b.endt_expiry_date) > SYSDATE
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.ann_tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_seq_no, c.assd_no, f.dist_flag,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_wcargo_carrier a,
          gipi_witem e,
          gipi_parlist c,
          giuw_pol_dist f,
          giis_assured d
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND c.par_id = f.par_id
      AND f.dist_no = f.dist_no
      AND e.ann_tsi_amt IS NOT NULL
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND NVL (b.expiry_date, b.endt_expiry_date) > SYSDATE
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3');



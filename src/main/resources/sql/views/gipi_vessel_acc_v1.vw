DROP VIEW CPI.GIPI_VESSEL_ACC_V1;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_vessel_acc_v1 (policy_id,
                                                     line_cd,
                                                     subline_cd,
                                                     iss_cd,
                                                     issue_yy,
                                                     pol_seq_no,
                                                     renew_no,
                                                     item_no,
                                                     vessel_cd,
                                                     pol_flag,
                                                     dist_flag,
                                                     ann_tsi_amt,
                                                     assd_no,
                                                     assd_name,
                                                     incept_date,
                                                     expiry_date,
                                                     endt_expiry_date,
                                                     eff_date,
                                                     tsi_amt,
                                                     rec_flag,
                                                     endt_seq_no,
                                                     endt_yy,
                                                     endt_iss_cd
                                                    )
AS
   SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
          b.pol_seq_no, b.renew_no, a.item_no, a.vessel_cd, b.pol_flag,
          b.dist_flag, e.ann_tsi_amt, f.assd_no, d.assd_name, b.incept_date,
          b.expiry_date, b.endt_expiry_date, b.eff_date, e.tsi_amt,
          e.rec_flag, b.endt_seq_no, b.endt_yy, b.endt_iss_cd
     FROM gipi_aviation_item a,
          gipi_polbasic b,
          giis_assured d,
          gipi_item e,
          gipi_parlist f
    WHERE a.policy_id = b.policy_id
      AND a.policy_id = e.policy_id
      AND a.item_no = e.item_no
      AND b.par_id = f.par_id
      AND f.assd_no = d.assd_no
      AND b.pol_flag != 'X'
      AND b.pol_flag != '5'
      AND NVL (expiry_date, b.endt_expiry_date) > SYSDATE
   UNION
   SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
          b.pol_seq_no, b.renew_no, a.item_no, a.vessel_cd, b.pol_flag,
          b.dist_flag, e.ann_tsi_amt, f.assd_no, d.assd_name, b.incept_date,
          b.expiry_date, b.endt_expiry_date, b.eff_date, e.tsi_amt,
          e.rec_flag, b.endt_seq_no, b.endt_yy, b.endt_iss_cd
     FROM gipi_item_ves a,
          gipi_polbasic b,
          giis_assured d,
          gipi_item e,
          gipi_parlist f
    WHERE a.policy_id = b.policy_id
      AND a.policy_id = e.policy_id
      AND a.item_no = e.item_no
      AND b.par_id = f.par_id
      AND f.assd_no = d.assd_no
      AND b.pol_flag != 'X'
      AND b.pol_flag != '5'
      AND NVL (expiry_date, b.endt_expiry_date) > SYSDATE
   UNION
   SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
          b.pol_seq_no, b.renew_no, a.item_no, a.vessel_cd, b.pol_flag,
          b.dist_flag, e.ann_tsi_amt, f.assd_no, d.assd_name, b.incept_date,
          b.expiry_date, b.endt_expiry_date, b.eff_date, e.tsi_amt,
          e.rec_flag, b.endt_seq_no, b.endt_yy, b.endt_iss_cd
     FROM gipi_cargo a,
          gipi_polbasic b,
          giis_assured d,
          gipi_item e,
          gipi_parlist f
    WHERE a.policy_id = b.policy_id
      AND a.policy_id = e.policy_id
      AND a.item_no = e.item_no
      AND b.par_id = f.par_id
      AND f.assd_no = d.assd_no
      AND b.pol_flag != 'X'
      AND b.pol_flag != '5'
      AND NVL (expiry_date, b.endt_expiry_date) > SYSDATE
   UNION
   SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
          b.pol_seq_no, b.renew_no, a.item_no, a.vessel_cd, b.pol_flag,
          b.dist_flag, e.ann_tsi_amt, f.assd_no, d.assd_name, b.incept_date,
          b.expiry_date, b.endt_expiry_date, b.eff_date, e.tsi_amt,
          e.rec_flag, b.endt_seq_no, b.endt_yy, b.endt_iss_cd
     FROM gipi_cargo_carrier a,
          gipi_polbasic b,
          giis_assured d,
          gipi_item e,
          gipi_parlist f
    WHERE a.policy_id = b.policy_id
      AND a.policy_id = e.policy_id
      AND a.item_no = e.item_no
      AND b.par_id = f.par_id
      AND f.assd_no = d.assd_no
      AND b.pol_flag != 'X'
      AND b.pol_flag != '5'
      AND NVL (expiry_date, b.endt_expiry_date) > SYSDATE;



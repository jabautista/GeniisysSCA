DROP VIEW CPI.PPW_TRACKING_V;

/* Formatted on 2015/05/15 10:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.ppw_tracking_v (binder_line_cd,
                                                 binder_date,
                                                 binder_yy,
                                                 binder_seq_no,
                                                 ri_name,
                                                 assd_name,
                                                 policy_no,
                                                 ri_tsi_amt,
                                                 ri_prem_amt,
                                                 prem_warr_days,
                                                 incept_dates,
                                                 acc_ent_date,
                                                 booking_date,
                                                 policy_id,
                                                 iss_cd
                                                )
AS
   SELECT gbd.line_cd binder_line_cd, gbd.binder_date,
          gbd.binder_yy binder_yy, gbd.binder_seq_no binder_seq_no,
          grn.ri_name ri_name, gas.assd_name assd_name,
          get_policy_no (gpb.policy_id) policy_no, gbd.ri_tsi_amt ri_tsi_amt,
          gbd.ri_prem_amt ri_prem_amt, gfr.prem_warr_days prem_warr_days,
          gpb.incept_date incept_dates, gbd.acc_ent_date acc_ent_date,
          TO_DATE (gpb.booking_mth || gpb.booking_year,
                   'MM-YYYY'
                  ) booking_date,
          gwp.policy_id policy_id, gbd.iss_cd iss_cd
     FROM giri_binder gbd,
          giri_frps_ri gfr,
          giis_reinsurer grn,
          giri_distfrps gdf,
          giuw_pol_dist gwp,
          gipi_polbasic gpb,
          giis_assured gas
    WHERE gbd.fnl_binder_id = gfr.fnl_binder_id
      AND gbd.ri_cd = grn.ri_cd
      AND gfr.line_cd = gdf.line_cd
      AND gfr.frps_yy = gdf.frps_yy
      AND gfr.frps_seq_no = gdf.frps_seq_no
      AND gfr.reverse_sw <> 'Y'
      AND gfr.prem_warr_tag <> 'N'
      AND gdf.dist_no = gwp.dist_no
      AND gwp.policy_id = gpb.policy_id
      AND gpb.assd_no = gas.assd_no
      AND gpb.policy_id NOT IN (
             SELECT   policy_id
                 FROM gipi_invoice a, giac_direct_prem_collns b
                WHERE b140_iss_cd = a.iss_cd
                  AND b140_prem_seq_no = a.prem_seq_no
             GROUP BY policy_id, b140_iss_cd, b140_prem_seq_no
               HAVING SUM (a.prem_amt) = SUM (b.premium_amt));



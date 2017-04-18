DROP VIEW CPI.GICL_VESSEL_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_vessel_v1 (vessel_cd,
                                                 claim_id,
                                                 line_cd,
                                                 subline_cd,
                                                 iss_cd,
                                                 clm_yy,
                                                 clm_seq_no,
                                                 pol_iss_cd,
                                                 issue_yy,
                                                 pol_seq_no,
                                                 renew_no,
                                                 dsp_loss_date,
                                                 assured_name,
                                                 item_no
                                                )
AS
   SELECT b.vessel_cd, a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
          a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
          a.renew_no, a.dsp_loss_date,
          a.assured_name || ' ' || a.assd_name2 assured_name, b.item_no
     FROM gicl_claims a, gicl_hull_dtl b
    WHERE a.claim_id = b.claim_id
          WITH READ ONLY;



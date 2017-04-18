DROP VIEW CPI.GIPI_OPEN_PERIL_V2;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_peril_v2 (policy_id,
                                                     item_no,
                                                     line_cd,
                                                     op_subline_cd,
                                                     op_iss_cd,
                                                     op_pol_seqno,
                                                     vessel_cd,
                                                     geog_cd,
                                                     cargo_class_cd,
                                                     eta,
                                                     etd,
                                                     peril_cd,
                                                     rec_flag
                                                    )
AS
   SELECT c.policy_id, c.item_no, b.line_cd, b.op_subline_cd, b.op_iss_cd,
          b.op_pol_seqno, c.vessel_cd, c.geog_cd, c.cargo_class_cd, c.eta,
          c.etd, d.peril_cd, d.rec_flag
     FROM gipi_polbasic a, gipi_open_policy b, gipi_cargo c, gipi_itmperil d
    WHERE b.policy_id = c.policy_id
      AND c.rec_flag != 'D'
      AND c.policy_id = a.policy_id
      AND a.spld_flag != '3'
      AND c.policy_id = d.policy_id
      AND c.item_no = d.item_no;



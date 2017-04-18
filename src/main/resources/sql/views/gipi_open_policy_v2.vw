DROP VIEW CPI.GIPI_OPEN_POLICY_V2;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_policy_v2 (policy_id,
                                                      item_no,
                                                      line_cd,
                                                      op_subline_cd,
                                                      op_iss_cd,
                                                      op_pol_seqno,
                                                      vessel_cd,
                                                      geog_cd,
                                                      cargo_class_cd,
                                                      rec_flag,
                                                      eta,
                                                      etd
                                                     )
AS
   SELECT c.policy_id, c.item_no, b.line_cd, b.op_subline_cd, b.op_iss_cd,
          b.op_pol_seqno, c.vessel_cd, c.geog_cd, c.cargo_class_cd,
          c.rec_flag, c.eta, c.etd
     FROM gipi_polbasic a, gipi_open_policy b, gipi_cargo c
    WHERE b.policy_id = c.policy_id
      AND c.policy_id = a.policy_id
      AND a.spld_flag != '3';



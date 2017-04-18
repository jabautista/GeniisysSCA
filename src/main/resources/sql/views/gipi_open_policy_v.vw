DROP VIEW CPI.GIPI_OPEN_POLICY_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_policy_v (line_cd,
                                                     op_subline_cd,
                                                     op_iss_cd,
                                                     op_pol_seqno
                                                    )
AS
   SELECT   line_cd, op_subline_cd, op_iss_cd, op_pol_seqno
       FROM gipi_open_policy
   GROUP BY line_cd, op_subline_cd, op_iss_cd, op_pol_seqno;



DROP VIEW CPI.POLBASIC_COMM_INVOICE_V;

/* Formatted on 2015/05/15 10:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.polbasic_comm_invoice_v (intrmdry_intm_no,
                                                          prem_seq_no,
                                                          share_percentage,
                                                          commission_amt,
                                                          line_cd,
                                                          subline_cd,
                                                          issue_yy,
                                                          endt_yy,
                                                          pol_seq_no,
                                                          renew_no,
                                                          eff_date,
                                                          assd_no,
                                                          endt_seq_no,
                                                          endt_iss_cd
                                                         )
AS
   SELECT a.intrmdry_intm_no, a.prem_seq_no, a.share_percentage,
          a.commission_amt, b.line_cd, b.subline_cd, b.issue_yy, b.endt_yy,
          b.pol_seq_no, b.renew_no, b.eff_date, b.assd_no, b.endt_seq_no,
          b.endt_iss_cd
     FROM gipi_comm_invoice a, gipi_polbasic b
    WHERE a.policy_id = b.policy_id AND a.iss_cd = b.iss_cd;



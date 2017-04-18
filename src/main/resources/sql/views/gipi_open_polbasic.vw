DROP VIEW CPI.GIPI_OPEN_POLBASIC;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_polbasic (op_line_cd,
                                                     op_subline_cd,
                                                     op_iss_cd,
                                                     op_issue_yy,
                                                     op_pol_seqno,
                                                     op_renew_no,
                                                     line_cd,
                                                     subline_cd,
                                                     iss_cd,
                                                     issue_yy,
                                                     pol_seq_no,
                                                     renew_no,
                                                     endt_iss_cd,
                                                     endt_seq_no,
                                                     endt_yy,
                                                     incept_date,
                                                     expiry_date,
                                                     tsi_amt,
                                                     prem_amt,
                                                     policy_id
                                                    )
AS
   (SELECT c.line_cd op_line_cd, c.op_subline_cd, c.op_iss_cd, c.op_issue_yy,
           c.op_pol_seqno, c.op_renew_no, a.line_cd, a.subline_cd, a.iss_cd,
           a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_seq_no,
           a.endt_yy, a.incept_date, a.expiry_date, a.tsi_amt, a.prem_amt,
           a.policy_id
      FROM gipi_polbasic a, gipi_polbasic b, gipi_open_policy c
     WHERE a.line_cd = b.line_cd
       AND a.subline_cd = b.subline_cd
       AND a.iss_cd = b.iss_cd
       AND a.issue_yy = b.issue_yy
       AND a.pol_seq_no = b.pol_seq_no
       AND a.renew_no = b.renew_no
       AND c.policy_id = b.policy_id);



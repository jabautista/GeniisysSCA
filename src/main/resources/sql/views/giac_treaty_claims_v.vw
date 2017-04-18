DROP VIEW CPI.GIAC_TREATY_CLAIMS_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_treaty_claims_v (line_cd,
                                                       trty_yy,
                                                       ri_cd,
                                                       proc_year,
                                                       proc_qtr,
                                                       peril_cd,
                                                       loss_paid_amt,
                                                       loss_exp_amt,
                                                       share_cd,
                                                       treaty_seq_no
                                                      )
AS
   SELECT   line_cd, trty_yy, ri_cd,
            TO_NUMBER (TO_CHAR (payt_date, 'YYYY')) proc_year,
            CEIL (TO_NUMBER (TO_CHAR (payt_date, 'MM')) / 3) proc_qtr,
            peril_cd, SUM (loss_paid_amt) loss_paid_amt,
            SUM (loss_exp_amt) loss_exp_amt, share_cd, treaty_seq_no
       FROM giac_treaty_claims
   GROUP BY line_cd,
            trty_yy,
            ri_cd,
            TO_NUMBER (TO_CHAR (payt_date, 'YYYY')),
            CEIL (TO_NUMBER (TO_CHAR (payt_date, 'MM')) / 3),
            peril_cd,
            share_cd,
            treaty_seq_no;



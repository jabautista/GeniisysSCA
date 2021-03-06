DROP VIEW CPI.GIAC_TREATY_PERILS_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_treaty_perils_v (line_cd,
                                                       trty_yy,
                                                       share_cd,
                                                       ri_cd,
                                                       proc_year,
                                                       proc_qtr,
                                                       peril_cd,
                                                       premium_amt,
                                                       commission_amt
                                                      )
AS
   SELECT   line_cd, trty_yy, share_cd, ri_cd,
            TO_NUMBER (TO_CHAR (acct_ent_date, 'YYYY')) proc_year,
            CEIL (TO_NUMBER (TO_CHAR (acct_ent_date, 'MM')) / 3) proc_qtr,
            peril_cd, SUM (NVL (premium_amt, 0)) premium_amt,
            SUM (NVL (commission_amt, 0)) commission_amt
       FROM giac_treaty_perils
   GROUP BY line_cd,
            trty_yy,
            share_cd,
            ri_cd,
            TO_NUMBER (TO_CHAR (acct_ent_date, 'YYYY')),
            CEIL (TO_NUMBER (TO_CHAR (acct_ent_date, 'MM')) / 3),
            peril_cd;



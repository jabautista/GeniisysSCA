DROP VIEW CPI.GIUW_WPOLICYDS_POLICYDS_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giuw_wpolicyds_policyds_v (dist_no,
                                                            dist_seq_no,
                                                            tsi_amt,
                                                            prem_amt,
                                                            item_grp,
                                                            ann_tsi_amt
                                                           )
AS
   SELECT dist_no, dist_seq_no, tsi_amt, prem_amt, item_grp, ann_tsi_amt
     FROM giuw_wpolicyds
   UNION
   SELECT dist_no, dist_seq_no, tsi_amt, prem_amt, item_grp, ann_tsi_amt
     FROM giuw_policyds;



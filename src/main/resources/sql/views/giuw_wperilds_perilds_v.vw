DROP VIEW CPI.GIUW_WPERILDS_PERILDS_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giuw_wperilds_perilds_v (dist_no,
                                                          dist_seq_no,
                                                          peril_cd,
                                                          line_cd,
                                                          tsi_amt,
                                                          prem_amt,
                                                          ann_tsi_amt
                                                         )
AS
   SELECT dist_no, dist_seq_no, peril_cd, line_cd, tsi_amt, prem_amt,
          ann_tsi_amt
     FROM giuw_wperilds
   UNION
   SELECT dist_no, dist_seq_no, peril_cd, line_cd, tsi_amt, prem_amt,
          ann_tsi_amt
     FROM giuw_perilds;



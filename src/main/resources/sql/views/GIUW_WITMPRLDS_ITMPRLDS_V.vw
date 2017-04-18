CREATE OR REPLACE FORCE VIEW cpi.giuw_witmprlds_itmprlds_v (dist_no,
                                                            dist_seq_no,
                                                            item_no,
                                                            peril_cd,
                                                            line_cd,
                                                            tsi_amt,
                                                            prem_amt,
                                                            ann_tsi_amt
                                                           )
AS
   SELECT dist_no, dist_seq_no, item_no, peril_cd, line_cd, tsi_amt, prem_amt, ann_tsi_amt
     FROM giuw_witemperilds
   UNION
   SELECT dist_no, dist_seq_no, item_no, peril_cd, line_cd, tsi_amt, prem_amt, ann_tsi_amt
     FROM giuw_itemperilds;

CREATE OR REPLACE PUBLIC SYNONYM GIUW_WITMPRLDS_ITMPRLDS_V FOR CPI.GIUW_WITMPRLDS_ITMPRLDS_V;

GRANT SELECT ON CPI.GIUW_WITMPRLDS_ITMPRLDS_V TO PUBLIC;
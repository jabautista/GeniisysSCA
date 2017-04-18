CREATE OR REPLACE FORCE VIEW cpi.giuw_witemds_itemds_v (dist_no, dist_seq_no, item_no, tsi_amt, prem_amt, ann_tsi_amt)
AS
   SELECT dist_no, dist_seq_no, item_no, tsi_amt, prem_amt, ann_tsi_amt
     FROM giuw_witemds
   UNION
   SELECT dist_no, dist_seq_no, item_no, tsi_amt, prem_amt, ann_tsi_amt
     FROM giuw_itemds;

CREATE OR REPLACE PUBLIC SYNONYM GIUW_WITEMDS_ITEMDS_V FOR CPI.GIUW_WITEMDS_ITEMDS_V;

GRANT SELECT ON CPI.GIUW_WITEMDS_ITEMDS_V TO PUBLIC;
CREATE OR REPLACE PACKAGE CPI.recompute_dist_peril_pkg
AS
   PROCEDURE recompute_dtl_tables (p_dist_no giuw_perilds_dtl.dist_no%TYPE);

   PROCEDURE recompute_dtl_dist_prem (
      p_dist_no   giuw_perilds_dtl.dist_no%TYPE
   );

   PROCEDURE update_dist_spct1 (p_dist_no giuw_perilds_dtl.dist_no%TYPE);
END recompute_dist_peril_pkg;
/



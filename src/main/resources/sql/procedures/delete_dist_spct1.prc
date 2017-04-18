DROP PROCEDURE CPI.DELETE_DIST_SPCT1;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_SPCT1(
   p_dist_no            GIUW_POL_DIST.dist_no%TYPE
)
IS
BEGIN
   UPDATE GIUW_POLICYDS_DTL
      SET dist_spct1 = NULL
    WHERE dist_no = p_dist_no;
   
   UPDATE GIUW_ITEMDS_DTL
      SET dist_spct1 = NULL
    WHERE dist_no = p_dist_no;

   UPDATE GIUW_ITEMPERILDS_DTL
      SET dist_spct1 = NULL
    WHERE dist_no = p_dist_no;

   UPDATE GIUW_PERILDS_DTL
      SET dist_spct1 = NULL
    WHERE dist_no = p_dist_no;
END;
/



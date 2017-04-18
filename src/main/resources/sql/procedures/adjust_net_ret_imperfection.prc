DROP PROCEDURE CPI.ADJUST_NET_RET_IMPERFECTION;

CREATE OR REPLACE PROCEDURE CPI.ADJUST_NET_RET_IMPERFECTION(p_dist_no IN giuw_pol_dist.dist_no%TYPE) IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : ADJUST_NET_RET_IMPERFECTION program unit
  */
  
  /* Equalize the amounts of tables GIUW_WPERILDS
  ** and GIUW_WPERILDS_DTL. */
  ADJUST_PERIL_LEVEL_AMTS(p_dist_no); 
  
  /* Equalize the amounts of tables GIUW_WPOLICYDS
  ** and GIUW_WPOLICYDS_DTL. */
  ADJUST_POLICY_LEVEL_AMTS(p_dist_no);

  /* Equalize the amounts of tables GIUW_WITEMDS
  ** and GIUW_WITEMDS_DTL. */
  ADJUST_ITEM_LEVEL_AMTS(p_dist_no);

  /* Equalize the amounts of tables GIUW_WITEMPERILDS
  ** and GIUW_WITEMPERILDS_DTL. */
  ADJUST_ITEM_PERIL_LEVEL_AMTS(p_dist_no);

END;
/



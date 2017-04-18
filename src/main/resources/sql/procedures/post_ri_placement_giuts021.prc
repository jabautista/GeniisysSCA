DROP PROCEDURE CPI.POST_RI_PLACEMENT_GIUTS021;

CREATE OR REPLACE PROCEDURE CPI.POST_RI_PLACEMENT_GIUTS021 (p_dist_no   IN GIUW_POL_DIST.dist_no%TYPE,
                             v_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE,
                             v_line_cd     IN giri_distfrps.line_cd%TYPE,
                             v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                             v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
IS
  /*
  **  Created by      : Emman
  **  Date Created    : 08.17.2011
  **  Reference By    : (GIUTS021 - Redistribution)
  **  Description     : The procedure POST_RI_PLACEMENT
  */
  V_COUNT NUMBER;
  V_COUNT2 NUMBER;
BEGIN 
  --GIRI_FRPS_RI_PKG.delete_mrecords_giuts021(v_line_cd , v_frps_yy, v_frps_seq_no ); --commented out edgar 09/29/2014
  GIRI_DISTFRPS_PKG.create_giri_distfrps_giuts021(v_line_cd , v_frps_yy, v_frps_seq_no );
  GIRI_FRPS_PERIL_GRP_PKG.create_frps_peril_grp_giris026(v_line_cd , v_frps_yy, v_frps_seq_no );
  GIRI_FRPS_RI_PKG.create_giri_frps_ri_binder2(p_dist_no, v_line_cd , v_frps_yy, v_frps_seq_no );
  GIRI_FRPERIL_PKG.create_giri_frperil_giuts021(v_line_cd , v_frps_yy, v_frps_seq_no );
  GIRI_BINDER_PERIL_PKG.create_binder_peril_giuts021(v_line_cd , v_frps_yy, v_frps_seq_no );
  GIIS_FBNDR_SEQ_PKG.update_fbndr_seq_giris026(v_line_cd , v_frps_yy, v_frps_seq_no );
  GIRI_WFRPS_RI_PKG.delete_records_giris026(v_line_cd, v_frps_yy, v_frps_seq_no, p_dist_no, v_dist_seq_no );
  UPDATE giri_distfrps
     SET ri_flag     = '2'
        ,user_id     = NVL(giis_users_pkg.app_user, USER)
        ,create_date = SYSDATE
   WHERE line_cd     = v_line_cd
     AND frps_yy     = v_frps_yy
     AND frps_seq_no = v_frps_seq_no;
END POST_RI_PLACEMENT_GIUTS021;
/



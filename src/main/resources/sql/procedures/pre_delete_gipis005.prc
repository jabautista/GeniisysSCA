DROP PROCEDURE CPI.PRE_DELETE_GIPIS005;

CREATE OR REPLACE PROCEDURE CPI.PRE_DELETE_GIPIS005(p_par_id  GIPI_WOPEN_LIAB.par_id%TYPE,
                                                    p_geog_cd GIPI_WOPEN_LIAB.geog_cd%TYPE)
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 24, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete related records of the limit of liability. 
*/                                                 
IS
  CURSOR A IS
    SELECT dist_no
      FROM giuw_pol_dist
     WHERE par_id = p_par_id;
     
  CURSOR B(p_dist_no  giri_wdistfrps.dist_no%TYPE) IS
     SELECT frps_seq_no,
            frps_yy
       FROM giri_wdistfrps
      WHERE dist_no = p_dist_no;
BEGIN

  DELETE_WINVOICE(p_par_id);

  FOR A1 IN A LOOP
    GIUW_WPERILDS_DTL_PKG.DEL_GIUW_WPERILDS_DTL(A1.dist_no);
    GIUW_WITEMDS_DTL_PKG.DEL_GIUW_WITEMDS_DTL(A1.dist_no);
    GIUW_WPOLICYDS_DTL_PKG.DEL_GIUW_WPOLICYDS_DTL(A1.dist_no);
    GIUW_WPERILDS_PKG.DEL_GIUW_WPERILDS(A1.dist_no);
    GIUW_WITEMDS_PKG.DEL_GIUW_WITEMDS(A1.dist_no);
    GIUW_WPOLICYDS_PKG.DEL_GIUW_WPOLICYDS(A1.dist_no);
      
    FOR B1 IN B(A1.dist_no) LOOP
      GIRI_WDISTFRPS_PKG.DEL_GIRI_WDISTFRPS1(B1.frps_seq_no, B1.frps_yy);
    END LOOP;
  
    GIUW_POL_DIST_PKG.DEL_GIUW_POL_DIST(A1.dist_no);
     
  END LOOP;
  
  GIPI_WITMPERL_PKG.DEL_GIPI_WITMPERL2(p_par_id);
  GIPI_WITEM_PKG.DEL_ALL_GIPI_WITEM(p_par_id);
  GIPI_WOPEN_CARGO_PKG.del_all_gipi_wopen_cargo(p_par_id, p_geog_cd);
  GIPI_WOPEN_PERIL_PKG.del_all_gipi_wopen_peril(p_par_id, p_geog_cd);
  
  GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 3);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN OTHERS THEN
      RAISE;
END PRE_DELETE_GIPIS005;
/



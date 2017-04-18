DROP PROCEDURE CPI.PRE_DELETE_GIPIS078;

CREATE OR REPLACE PROCEDURE CPI.PRE_DELETE_GIPIS078(
    p_par_id            GIPI_WOPEN_LIAB.par_id%TYPE
)
IS
/*
**  Created by   : Marco Paolo Rebong
**  Date Created : November 12, 2012
**  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
**  Description  : pre-delete procedure for GIPI_WOPEN_LIAB 
*/
BEGIN
  FOR A1 IN(SELECT dist_no
              FROM GIUW_POL_DIST
             WHERE par_id = p_par_id)
  LOOP
    GIUW_WPERILDS_DTL_PKG.DEL_GIUW_WPERILDS_DTL(A1.dist_no);
    GIUW_WITEMDS_DTL_PKG.DEL_GIUW_WITEMDS_DTL(A1.dist_no);
    GIUW_WPOLICYDS_DTL_PKG.DEL_GIUW_WPOLICYDS_DTL(A1.dist_no);
    GIUW_WPERILDS_PKG.DEL_GIUW_WPERILDS(A1.dist_no);
    GIUW_WITEMDS_PKG.DEL_GIUW_WITEMDS(A1.dist_no);
    GIUW_WPOLICYDS_PKG.DEL_GIUW_WPOLICYDS(A1.dist_no);
      
    FOR B1 IN(SELECT frps_seq_no, frps_yy
                FROM GIRI_WDISTFRPS
               WHERE dist_no = A1.dist_no)
    LOOP
      GIRI_WDISTFRPS_PKG.DEL_GIRI_WDISTFRPS1(B1.frps_seq_no, B1.frps_yy);
    END LOOP;
    GIUW_POL_DIST_PKG.DEL_GIUW_POL_DIST(A1.dist_no);
  END LOOP;
  
  GIPI_WITMPERL_PKG.DEL_GIPI_WITMPERL2(p_par_id);
  GIPI_WITEM_PKG.DEL_ALL_GIPI_WITEM(p_par_id);
  GIPI_WOPEN_CARGO_PKG.del_gipi_wopen_cargo(p_par_id);
  GIPI_WOPEN_PERIL_PKG.del_gipi_wopen_peril(p_par_id);
  
  GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 3);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN OTHERS THEN
      NULL;
END;
/



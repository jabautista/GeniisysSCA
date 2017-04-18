DROP PROCEDURE CPI.DELETE_RI_TABLES_PACKAGE;

CREATE OR REPLACE PROCEDURE CPI.DELETE_RI_TABLES_PACKAGE (p_dist_no IN giuw_pol_dist.dist_no%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.25.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Delete records on giri tables based on the given parameter
    */
BEGIN
    FOR A IN (
        SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
          FROM GIRI_WFRPS_RI a, GIRI_WDISTFRPS b
         WHERE a.line_cd = b.line_cd
           AND a.frps_yy = b.frps_yy
           AND a.frps_seq_no = b.frps_seq_no
           AND b.dist_no = p_dist_no)
    LOOP    
        giri_wbinder_peril_pkg.del_giri_wbinder_peril(a.pre_binder_id);        
        giri_wbinder_pkg.del_giri_wbinder(a.pre_binder_id);
        giri_wfrperil_pkg.del_giri_wfrperil(a.line_cd, a.frps_yy, a.frps_seq_no);
        giri_wfrps_ri_pkg.del_giri_wfrps_ri(a.line_cd, a.frps_yy, a.frps_seq_no);
        giri_wdistfrps_pkg.del_giri_wdistfrps(p_dist_no);
    END LOOP;
END DELETE_RI_TABLES_PACKAGE;
/



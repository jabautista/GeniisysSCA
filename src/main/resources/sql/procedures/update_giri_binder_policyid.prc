DROP PROCEDURE CPI.UPDATE_GIRI_BINDER_POLICYID;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIRI_BINDER_POLICYID(
          p_par_id      IN  GIPI_PARLIST.par_id%TYPE,
          p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE)
IS
BEGIN
    FOR i IN (SELECT gb.fnl_binder_id
                FROM cpi.giri_binder gb, cpi.giri_frps_ri gfr,
                     cpi.giri_distfrps gd, cpi.giuw_pol_dist gpd,
                     cpi.gipi_parlist gp
               WHERE gb.fnl_binder_id = gfr.fnl_binder_id
                 AND gfr.line_cd = gd.line_cd
                 AND gfr.frps_yy = gd.frps_yy
                 AND gfr.frps_seq_no = gd.frps_seq_no
                 AND gd.dist_no = gpd.dist_no
                 AND gpd.par_id = gp.par_id
                 AND gpd.par_id = p_par_id)
    LOOP
        UPDATE giri_binder
           SET policy_id = p_policy_id
         WHERE fnl_binder_id = i.fnl_binder_id;
    END LOOP;
END;
/



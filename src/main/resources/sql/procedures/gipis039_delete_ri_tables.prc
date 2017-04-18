DROP PROCEDURE CPI.GIPIS039_DELETE_RI_TABLES;

CREATE OR REPLACE PROCEDURE CPI.gipis039_delete_ri_tables(p_dist_no  IN giuw_pol_dist.dist_no%TYPE) IS
/* Created by Vida
** Delete affected RI tables
** before deleting underwriting distribution
** tables
*/

BEGIN
  FOR A IN (SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
              FROM giri_wfrps_ri a, giri_wdistfrps b
             WHERE a.line_cd = b.line_cd
               AND a.frps_yy = b.frps_yy
               AND a.frps_seq_no = b.frps_seq_no
               AND b.dist_no = p_dist_no)
  LOOP
    DELETE giri_wbinder_peril
     WHERE pre_binder_id = a.pre_binder_id;

    DELETE giri_wbinder
     WHERE pre_binder_id = a.pre_binder_id;

    DELETE giri_wfrps_peril_grp
     WHERE line_cd = a.line_cd
       AND frps_yy = a.frps_yy
       AND frps_seq_no = a.frps_seq_no;

    DELETE giri_wfrperil
     WHERE line_cd = a.line_cd
       AND frps_yy = a.frps_yy
       AND frps_seq_no = a.frps_seq_no;

    DELETE giri_wfrps_ri
     WHERE line_cd = a.line_cd
       AND frps_yy = a.frps_yy
       AND frps_seq_no = a.frps_seq_no;

  END LOOP;

    DELETE giri_wdistfrps
     WHERE dist_no = p_dist_no;
END;
/



DROP PROCEDURE CPI.DELETE_RI_TABLES_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Delete_Ri_Tables_Gipis002
   (p_dist_no  IN GIUW_POL_DIST.dist_no%TYPE) IS
/* Created by Vida
** Delete affected RI tables
** before deleting underwriting distribution
** tables
*/

BEGIN
  --MESSAGE('Deleting RI tables...', NO_ACKNOWLEDGE);

  FOR A IN (SELECT A.pre_binder_id, b.line_cd, A.frps_yy, A.frps_seq_no
              FROM GIRI_WFRPS_RI A, GIRI_WDISTFRPS b
             WHERE A.line_cd = b.line_cd
               AND A.frps_yy = b.frps_yy
               AND A.frps_seq_no = b.frps_seq_no
               AND b.dist_no = p_dist_no)
  LOOP
    DELETE GIRI_WBINDER_PERIL
     WHERE pre_binder_id = A.pre_binder_id;

    DELETE GIRI_WBINDER
     WHERE pre_binder_id = A.pre_binder_id;

    DELETE GIRI_WFRPS_PERIL_GRP
     WHERE line_cd = A.line_cd
       AND frps_yy = A.frps_yy
       AND frps_seq_no = A.frps_seq_no;

    DELETE GIRI_WFRPERIL
     WHERE line_cd = A.line_cd
       AND frps_yy = A.frps_yy
       AND frps_seq_no = A.frps_seq_no;

    DELETE GIRI_WFRPS_RI
     WHERE line_cd = A.line_cd
       AND frps_yy = A.frps_yy
       AND frps_seq_no = A.frps_seq_no;

  END LOOP;

    DELETE GIRI_WDISTFRPS
     WHERE dist_no = p_dist_no;
END;
/



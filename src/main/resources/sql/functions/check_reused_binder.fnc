CREATE OR REPLACE FUNCTION CPI.check_reused_binder (
   p_fnl_binder_id   GIRI_BINDER.fnl_binder_id%TYPE,
   p_dist_no         GIUW_POL_DIST.dist_no%TYPE
)
/* Created by Mikel 04.14.2014
** Description : To check reused binder.
*/
   RETURN NUMBER
IS
   v_reused   NUMBER := 0;
BEGIN
   FOR rec IN (SELECT a.dist_no
                 FROM GIUW_POL_DIST a, GIRI_DISTFRPS b, GIRI_FRPS_RI c
                WHERE 1 = 1
                  AND a.dist_no = b.dist_no
                  AND b.line_cd = c.line_cd
                  AND b.frps_yy = c.frps_yy
                  AND b.frps_seq_no = c.frps_seq_no
                  AND c.fnl_binder_id = p_fnl_binder_id
                  AND a.dist_no > p_dist_no)
   LOOP
      v_reused := 1;
      EXIT;
   END LOOP;

   RETURN v_reused;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM check_reused_binder FOR CPI.check_reused_binder;

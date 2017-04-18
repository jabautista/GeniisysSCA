DROP FUNCTION CPI.GET_BINDER_NO;

CREATE OR REPLACE FUNCTION CPI.get_binder_no (p_fnl_binder_id giri_binder.fnl_binder_id%TYPE)
   RETURN VARCHAR2
IS
   v_binder_no   VARCHAR2 (30);
BEGIN
   FOR binder IN (SELECT    line_cd
                         || '-'
                         || binder_yy
                         || '-'
                         || LTRIM(TO_CHAR (binder_seq_no, '00000')) binder_no
                    FROM giri_binder
                   WHERE fnl_binder_id = p_fnl_binder_id)
   LOOP
      v_binder_no := binder.binder_no;
      EXIT;
   END LOOP binder;

   RETURN (v_binder_no);
END get_binder_no;
/



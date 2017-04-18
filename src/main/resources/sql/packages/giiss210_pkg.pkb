CREATE OR REPLACE PACKAGE BODY CPI.giiss210_pkg
AS
   FUNCTION get_rec_list (
      p_user_id               giis_non_renew_reason.user_id%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.non_ren_reason_cd, a.non_ren_reason_desc, a.line_cd, a.remarks, a.user_id,
                       a.last_update, active_tag --carlo 01-27-2017
                  FROM giis_non_renew_reason a
                 WHERE 1 = check_user_per_line2(line_cd, NULL, 'GIISS210', p_user_id)
                 ORDER BY a.non_ren_reason_cd
                   )                   
      LOOP
         v_rec.non_ren_reason_cd := i.non_ren_reason_cd;
         v_rec.non_ren_reason_desc := i.non_ren_reason_desc;
		 v_rec.line_cd := i.line_cd;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.active_tag := i.active_tag;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_line_rec_list (
      p_user_id               giis_non_renew_reason.user_id%TYPE
   )
      RETURN rec_line_tab PIPELINED
   IS 
      v_rec   rec_line_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.line_name
                  FROM giis_line a
                 WHERE 1 = check_user_per_line2(line_cd, NULL, 'GIISS210', p_user_id)
               )                   
      LOOP
		 v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;   

   PROCEDURE set_rec (p_rec giis_non_renew_reason%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_non_renew_reason
         USING DUAL
         ON (non_ren_reason_cd = p_rec.non_ren_reason_cd)
         WHEN NOT MATCHED THEN
            INSERT (non_ren_reason_cd, non_ren_reason_desc, line_cd, remarks, user_id, last_update, active_tag)--carlo 01-27-2017
            VALUES (p_rec.non_ren_reason_cd, p_rec.non_ren_reason_desc, p_rec.line_cd, p_rec.remarks,
                    p_rec.user_id, SYSDATE, p_rec.active_tag)
         WHEN MATCHED THEN
            UPDATE
               SET non_ren_reason_desc = p_rec.non_ren_reason_desc, line_cd = p_rec.line_cd,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE,
                   active_tag = p_rec.active_tag --carlo 01-27-2017
            ;
   END;

   PROCEDURE del_rec (p_non_ren_reason_cd giis_non_renew_reason.non_ren_reason_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_non_renew_reason
            WHERE non_ren_reason_cd = p_non_ren_reason_cd;
   END;

   PROCEDURE val_del_rec (p_non_ren_reason_cd giis_non_renew_reason.non_ren_reason_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT y.non_ren_reason_cd 
	             FROM giis_non_renew_reason x, giex_expiry y 
	            WHERE x.non_ren_reason_cd = y.non_ren_reason_cd
	              AND x.non_ren_reason_cd = p_non_ren_reason_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_NON_RENEW_REASON while dependent record(s) in GIEX_EXPIRY exists.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_add_rec (
       p_non_ren_reason_cd giis_non_renew_reason.non_ren_reason_cd%TYPE,
       p_non_ren_reason_desc giis_non_renew_reason.non_ren_reason_desc%TYPE
   )
   AS
      v_exists_cd    VARCHAR2 (1) := 'N';
      v_exists_desc  VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_non_renew_reason a
                 WHERE a.non_ren_reason_cd = p_non_ren_reason_cd)
      LOOP
         v_exists_cd := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_cd = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same non_ren_reason_cd.'
                                 );
      ELSE
          FOR i IN (SELECT '1'
                      FROM giis_non_renew_reason a
                     WHERE UPPER(a.non_ren_reason_desc) LIKE UPPER(p_non_ren_reason_desc))
          LOOP
             v_exists_desc := 'Y';
             EXIT;
          END LOOP;
                 
          IF v_exists_desc = 'Y'
          THEN
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Record already exists with the same non_ren_reason_desc.'
                                     );
          END IF;                            
      END IF;
   END;
END;
/



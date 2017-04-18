CREATE OR REPLACE PACKAGE BODY CPI.GIISS041_PKG
AS

   FUNCTION get_giiss041_rec_list(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_user_grp_desc            giis_user_grp_hdr.user_grp_desc%TYPE,
      p_iss_name                 giis_issource.iss_name%TYPE
   )
     RETURN giiss041_tab PIPELINED
   IS
      v_row                      giis041_type;
   BEGIN
      FOR i IN(SELECT a.user_grp, a.user_grp_desc, a.grp_iss_cd, b.iss_name, a.remarks, a.user_id, a.last_update
                 FROM giis_user_grp_hdr a,
                      giis_issource b
                WHERE a.grp_iss_cd = b.iss_cd
                  AND a.user_grp = NVL(p_user_grp, a.user_grp)
                  AND UPPER(a.user_grp_desc) LIKE UPPER(NVL(p_user_grp_desc, '%'))
                  AND UPPER(b.iss_name) LIKE UPPER(NVL(p_iss_name, '%'))
                ORDER BY a.user_grp, a.user_grp_desc)
      LOOP
         v_row.user_grp := i.user_grp;
         v_row.user_grp_desc := i.user_grp_desc;
         v_row.grp_iss_cd := i.grp_iss_cd;
         v_row.iss_name := i.iss_name;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         v_row.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_grp_iss_cd_lov(
      p_find_text                VARCHAR2
   )
     RETURN grp_iss_cd_tab PIPELINED
   IS
      v_row                      grp_iss_cd_type;
   BEGIN
      FOR i IN(SELECT iss_cd, iss_name
                 FROM giis_issource
                WHERE (UPPER(iss_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(iss_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_del_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_users
                WHERE user_grp = p_user_grp)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_USER_GRP_HDR while dependent record(s) in GIIS_USERS exists.');
      END LOOP;
   END;
   
   PROCEDURE del_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_user_grp_line
	    WHERE user_grp = p_user_grp;
       
      DELETE
        FROM giis_user_grp_dtl
	    WHERE user_grp = p_user_grp;
   
      DELETE
        FROM giis_user_grp_modules
	    WHERE user_grp = p_user_grp;
       
      DELETE
        FROM giis_user_grp_tran
       WHERE user_grp = p_user_grp;
   
      DELETE
        FROM giis_user_grp_hdr
       WHERE user_grp = p_user_grp;
   END;
   
   PROCEDURE add_rec(
      p_rec                      giis_user_grp_hdr%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_user_grp_hdr
      USING DUAL
         ON (user_grp = p_rec.user_grp)
       WHEN NOT MATCHED THEN
            INSERT (user_grp, user_grp_desc, user_id, last_update, remarks, grp_iss_cd)
            VALUES (p_rec.user_grp, p_rec.user_grp_desc, p_rec.user_id, SYSDATE, p_rec.remarks, p_rec.grp_iss_cd)
       WHEN MATCHED THEN
            UPDATE SET user_grp_desc = p_rec.user_grp_desc,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE,
                       remarks = p_rec.remarks,
                       grp_iss_cd = p_rec.grp_iss_cd;
   END;
   
   PROCEDURE val_add_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_user_grp_hdr
                WHERE user_grp = p_user_grp)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same user_grp.');
      END LOOP;
   END;
   
   FUNCTION get_user_grp_tran_list(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE,
      p_tran_desc                giis_transaction.tran_desc%TYPE
   )
     RETURN user_grp_tran_tab PIPELINED
   IS
      v_row                      user_grp_tran_type;
   BEGIN
      FOR i IN(SELECT a.*, b.tran_desc
                 FROM giis_user_grp_tran a,
                      giis_transaction b
                WHERE a.tran_cd = NVL(p_tran_cd, a.tran_cd)
                  AND UPPER(b.tran_desc) LIKE NVL(UPPER(p_tran_desc), '%')
                  AND a.tran_cd = b.tran_cd
                  AND a.user_grp = p_user_grp
                ORDER BY b.tran_desc, b.tran_cd)
      LOOP
         v_row.user_grp := i.user_grp;
         v_row.tran_cd := i.tran_cd;
         v_row.tran_desc := i.tran_desc;
         v_row.access_tag := i.access_tag;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         
         v_row.inc_all_tag := 'Y';
         FOR a IN (SELECT DISTINCT b.module_id
						  FROM giis_modules b,
                         giis_modules_tran c
						 WHERE b.module_id = c.module_id
						   AND c.tran_cd = i.tran_cd
						   AND NOT EXISTS (SELECT module_id
						                     FROM giis_user_grp_modules
											     WHERE user_grp = i.user_grp
											       AND module_id IN (b.module_id)
  	                                     AND tran_cd = i.tran_cd
                                        AND NVL(access_tag, 2) = 1))
         LOOP
            v_row.inc_all_tag := 'N';
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE del_user_grp_tran(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_user_grp_modules
	    WHERE user_grp = p_user_grp
	      AND tran_cd = p_tran_cd;
	   
      DELETE
        FROM giis_user_grp_dtl
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd;
     
      DELETE
        FROM giis_user_grp_line
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd;
         
      DELETE
        FROM giis_user_grp_tran
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd; 
   END;
   
   PROCEDURE val_add_user_grp_tran(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_user_grp_tran
                WHERE user_grp = p_user_grp
                  AND tran_cd = p_tran_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Row exists already with same User Group and Transaction Code.');
      END LOOP;
   END;
   
   PROCEDURE add_user_grp_tran(
      p_rec                      giis_user_grp_tran%ROWTYPE
   )
   IS
   BEGIN
      INSERT INTO giis_user_grp_tran
             (user_grp, tran_cd, user_id, last_update)
      VALUES (p_rec.user_grp, p_rec.tran_cd, p_rec.user_id, SYSDATE);
   END;
   
   FUNCTION get_user_grp_dtl_list(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE,
      p_iss_name                 giis_issource.iss_name%TYPE
   )
     RETURN user_grp_dtl_tab PIPELINED
   IS
      v_row                      user_grp_dtl_type;
   BEGIN
      FOR i IN(SELECT a.user_grp, a.iss_cd, a.tran_cd, b.iss_name
                 FROM giis_user_grp_dtl a,
                      giis_issource b
                WHERE a.iss_cd = b.iss_cd
                  AND a.user_grp = p_user_grp
                  AND a.tran_cd = p_tran_cd
                  AND UPPER(a.iss_cd) LIKE NVL(UPPER(p_iss_cd), '%')
                  AND UPPER(b.iss_name) LIKE NVL(UPPER(p_iss_name), '%'))
      LOOP
         v_row.user_grp := i.user_grp;
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         v_row.tran_cd := i.tran_cd;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_del_user_grp_dtl(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE
   )
   IS
   BEGIN
      FOR a IN(SELECT 1
	              FROM gipi_parlist
	             WHERE underwriter IN(SELECT user_id
	                                    FROM giis_users
	                                   WHERE user_grp = p_user_grp)
	               AND iss_cd IN(SELECT iss_cd
	                               FROM giis_user_grp_dtl
	                              WHERE user_grp = p_user_grp
 	                                AND tran_cd = p_tran_cd
	                                AND tran_cd = 1)
                  AND par_status != 99
	               AND iss_cd = p_iss_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_USER_GRP_DTL while dependent record(s) in GIPI_PARLIST exists.');
         EXIT;
	   END LOOP;
   END;
   
   PROCEDURE del_user_grp_dtl(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_user_grp_line
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd
         AND iss_cd = p_iss_cd;
         
      DELETE
        FROM giis_user_grp_dtl
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd
         AND iss_cd = p_iss_cd;
   END;
   
   PROCEDURE set_user_grp_dtl(
      p_rec                      giis_user_grp_dtl%ROWTYPE
   )
   IS
   BEGIN
      INSERT 
        INTO giis_user_grp_dtl
             (user_grp, iss_cd, user_id, last_update, tran_cd)
      VALUES (p_rec.user_grp, p_rec.iss_cd, p_rec.user_id, SYSDATE, p_rec.tran_cd);
   END;
   
   FUNCTION get_user_grp_line_list(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_line.line_cd%TYPE,
      p_line_name                giis_line.line_name%TYPE
   )
     RETURN user_grp_line_tab PIPELINED
   IS
      v_row                      user_grp_line_type;
   BEGIN
      FOR i IN(SELECT a.user_grp, a.tran_cd, a.iss_cd, a.line_cd, b.line_name, a.user_id, a.last_update, a.remarks
                 FROM giis_user_grp_line a,
                      giis_line b
                WHERE a.user_grp = p_user_grp
                  AND a.iss_cd = p_iss_cd
                  AND a.tran_cd = p_tran_cd
                  AND a.line_cd = b.line_cd
                  AND UPPER(a.line_cd) LIKE NVL(UPPER(p_line_cd), '%')
                  AND UPPER(b.line_name) LIKE NVL(UPPER(p_line_name), '%'))
      LOOP
         v_row.user_grp := i.user_grp;
         v_row.tran_cd := i.tran_cd;
         v_row.iss_cd := i.iss_cd;
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_del_user_grp_line(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_user_grp_line.line_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
	              FROM gipi_parlist
	             WHERE line_cd = p_line_cd
	               AND iss_cd = p_iss_cd
	               AND underwriter IN (SELECT user_id
	                                     FROM giis_users
	                                    WHERE user_grp = p_user_grp)
	               AND iss_cd IN(SELECT iss_cd
	                               FROM giis_user_grp_dtl
 	                              WHERE user_grp = p_user_grp
 	                                AND tran_cd = p_tran_cd
 	                                AND tran_cd = 1)
 	               AND par_status != 99)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_USER_GRP_LINE while dependent record(s) in GIPI_PARLIST exists.');
	   END LOOP;
   END;
   
   PROCEDURE del_user_grp_line(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_user_grp_line.line_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_user_grp_line
       WHERE user_grp = p_user_grp
         AND tran_cd = p_tran_cd
         AND iss_cd = p_iss_cd
         AND line_cd = p_line_cd;
   END;
   
   PROCEDURE set_user_grp_line(
      p_rec                      giis_user_grp_line%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_user_grp_line
      USING DUAL
         ON (user_grp = p_rec.user_grp
        AND tran_cd = p_rec.tran_cd
        AND iss_cd = p_rec.iss_cd
        AND line_cd = p_rec.line_cd)
       WHEN NOT MATCHED THEN
            INSERT (user_grp, line_cd, iss_cd, user_id, last_update, remarks, tran_cd)
            VALUES (p_rec.user_grp, p_rec.line_cd, p_rec.iss_cd, p_rec.user_id, SYSDATE, p_rec.remarks, p_rec.tran_cd)
       WHEN MATCHED THEN
            UPDATE SET remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
   FUNCTION get_module_list(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   )
     RETURN modules_tab PIPELINED
   IS
      v_row                      modules_type;
   BEGIN
      FOR i IN(SELECT a.*, b.module_desc
                 FROM giis_modules_tran a,
                      giis_modules b
                WHERE a.tran_cd = p_tran_cd
                  AND a.module_id = b.module_id
                  AND UPPER(a.module_id) LIKE UPPER(NVL(p_module_id, '%'))
                  AND UPPER(b.module_desc) LIKE UPPER(NVL(p_module_desc, '%'))
                ORDER BY a.module_id)
      LOOP
         v_row := NULL;
         FOR a IN(SELECT user_grp, module_id, user_id, last_update, remarks, access_tag
	                 FROM giis_user_grp_modules
	                WHERE user_grp = p_user_grp
	                  AND module_id = i.module_id
				  	      AND tran_cd = p_tran_cd)
         LOOP
            v_row.user_grp := a.user_grp;
            v_row.user_id := a.user_id;
	         v_row.last_update := TO_CHAR(a.last_update, 'MM-DD-YYYY HH:MI:SS AM');    
	         v_row.remarks := a.remarks;    
	         v_row.access_tag := a.access_tag;
            
            IF a.access_tag = 1 THEN
               v_row.inc_tag := 'Y';
            ELSIF a.access_tag = 2 OR a.access_tag IS NULL THEN
               v_row.inc_tag := 'N';
            END IF;
            EXIT;
         END LOOP;
         
         FOR b IN(SELECT rv_meaning
	                 FROM cg_ref_codes
	                WHERE rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
	                  AND rv_low_value = v_row.access_tag)
         LOOP
	         v_row.access_tag_desc := b.rv_meaning;
            EXIT;
         END LOOP;
         
         IF v_row.access_tag_desc IS NULL THEN
            v_row.access_tag_desc := 'No Access';
         END IF;
         
         v_row.tran_cd := i.tran_cd;
         v_row.module_id := i.module_id;
         v_row.module_desc := i.module_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE del_user_grp_modules(
      p_user_grp                 giis_user_grp_modules.user_grp%TYPE,
      p_module_id                giis_user_grp_modules.module_id%TYPE,
      p_tran_cd                  giis_user_grp_modules.tran_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_user_grp_modules
       WHERE user_grp = p_user_grp
         AND module_id = p_module_id
   	   AND tran_cd = p_tran_cd;
   END;
   
   PROCEDURE set_user_grp_modules(
      p_rec                      giis_user_grp_modules%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_user_grp_modules
      USING DUAL
         ON (user_grp = p_rec.user_grp
        AND module_id = p_rec.module_id
   	  AND tran_cd = p_rec.tran_cd)
       WHEN NOT MATCHED THEN
            INSERT (user_grp, module_id, tran_cd, remarks, access_tag)
            VALUES (p_rec.user_grp, p_rec.module_id, p_rec.tran_cd, p_rec.remarks, p_rec.access_tag)
       WHEN MATCHED THEN
            UPDATE SET remarks = p_rec.remarks,
                       access_tag = p_rec.access_tag;
   END;
   
   PROCEDURE check_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   )
   IS
      v_exists                   VARCHAR2(1) := 'N';
      v_access_tag_desc          cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      FOR c IN(SELECT rv_meaning
	              FROM cg_ref_codes
	             WHERE rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
	               AND rv_low_value = '1')
      LOOP
	      v_access_tag_desc := c.rv_meaning;
         EXIT;
	   END LOOP;
   
      FOR i IN(SELECT user_grp, module_id, tran_cd
                 FROM TABLE(giiss041_pkg.get_module_list(p_user_grp, p_tran_cd, p_module_id, p_module_desc)))
      LOOP
         FOR a IN (SELECT 1
  	                  FROM giis_user_grp_modules
  	                 WHERE user_grp = i.user_grp
  	                   AND module_id = i.module_id
				  	       AND tran_cd = i.tran_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
         
         IF v_exists = 'N' THEN
  	         INSERT INTO giis_user_grp_modules
	                (user_grp, module_id, tran_cd, access_tag)
	         VALUES (p_user_grp, i.module_id, i.tran_cd, '1');
         ELSE
            UPDATE giis_user_grp_modules
               SET access_tag = '1'
             WHERE user_grp = i.user_grp
               AND module_id = i.module_id
               AND tran_cd = i.tran_cd;
         END IF;
         
         v_exists := 'N';
      END LOOP;
   END;
   
   PROCEDURE uncheck_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT user_grp, module_id, tran_cd
                 FROM TABLE(giiss041_pkg.get_module_list(p_user_grp, p_tran_cd, p_module_id, p_module_desc)))
      LOOP
         UPDATE giis_user_grp_modules
            SET access_tag = '2'
          WHERE user_grp = i.user_grp
            AND module_id = i.module_id
            AND tran_cd = i.tran_cd;
      END LOOP;
   END;
   
   PROCEDURE copy_user_grp(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_new_user_grp             giis_user_grp_hdr.user_grp%TYPE,
      p_user_id                  giis_user_grp_hdr.user_id%TYPE
   )
   IS
      v_tran                     giis_user_grp_line.tran_cd%TYPE;
      v_iss                      giis_user_grp_line.iss_cd%TYPE;
   
      CURSOR c1 IS
	      (SELECT tran_cd, remarks, access_tag
	         FROM giis_user_grp_tran
	        WHERE user_grp = p_user_grp);
           
	   CURSOR c2 IS
         (SELECT module_id, remarks, access_tag
            FROM giis_user_grp_modules
           WHERE user_grp = p_user_grp
             AND tran_cd = v_tran);
       
	   CURSOR c3 IS
         (SELECT iss_cd, remarks
            FROM giis_user_grp_dtl
           WHERE user_grp = p_user_grp
             AND tran_cd = v_tran);
             
      CURSOR c4 IS
         (SELECT line_cd, remarks 
            FROM giis_user_grp_line
           WHERE user_grp = p_user_grp
             AND tran_cd = v_tran
             AND iss_cd = v_iss);
   BEGIN
      FOR c1_rec in c1 
      LOOP
         v_tran := c1_rec.tran_cd;
         INSERT INTO giis_user_grp_tran
				    (user_grp, tran_cd, user_id, last_update, remarks, access_tag)
         VALUES (p_new_user_grp, c1_rec.tran_cd, p_user_id, SYSDATE, c1_rec.remarks, c1_rec.access_tag);
         
         FOR c2_rec in c2
         LOOP
            INSERT INTO giis_user_grp_modules
					    (user_grp, module_id, user_id, last_update, remarks, access_tag, tran_cd)
			   VALUES (p_new_user_grp, c2_rec.module_id, p_user_id, SYSDATE, c2_rec.remarks, c2_rec.access_tag, c1_rec.tran_cd); 		
         END LOOP;
         
         FOR c3_rec in c3
         LOOP
            v_iss := c3_rec.iss_cd;
            INSERT INTO giis_user_grp_dtl
                   (user_grp, iss_cd, user_id, last_update, remarks, tran_cd)
            VALUES (p_new_user_grp, c3_rec.iss_cd, p_user_id, SYSDATE, c3_rec.remarks, v_tran);
            
            FOR c4_rec in c4
            LOOP
               INSERT INTO giis_user_grp_line
                      (user_grp, line_cd, iss_cd, user_id, last_update, remarks, tran_cd)
               VALUES (p_new_user_grp, c4_rec.line_cd, v_iss, p_user_id, SYSDATE, c4_rec.remarks, v_tran);
            END LOOP;
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_user_grp_lov(
      p_find_text                VARCHAR2
   )
     RETURN user_grp_tab PIPELINED
   IS
      v_row                      user_grp_type;
   BEGIN
      FOR i IN(SELECT user_grp, user_grp_desc
                 FROM giis_user_grp_hdr
                WHERE (TO_CHAR(user_grp) = NVL(p_find_text, TO_CHAR(user_grp))
                   OR UPPER(user_grp_desc) LIKE UPPER(NVL(p_find_text, '%')))
                ORDER BY user_grp)
      LOOP
         v_row.user_grp := i.user_grp;
         v_row.user_grp_desc := i.user_grp_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_tran_lov(
      p_find_text                VARCHAR2
   )
     RETURN tran_lov_tab PIPELINED
   IS
      v_row                      tran_lov_type;
   BEGIN
      FOR i IN(SELECT tran_cd, tran_desc 
                 FROM giis_transaction
                WHERE (TO_CHAR(tran_cd) LIKE NVL(p_find_text, '%')
                   OR UPPER(tran_desc) LIKE NVL(UPPER(p_find_text), '%'))
                ORDER BY tran_desc)
      LOOP
         v_row.tran_cd := i.tran_cd;
         v_row.tran_desc := i.tran_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_issue_lov(
      p_grp_iss_cd               giis_user_grp_hdr.grp_iss_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN grp_iss_cd_tab PIPELINED
   IS
      v_row                      grp_iss_cd_type;
      v_iss_cd_ho                giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_iss_cd_ho
           FROM giis_parameters
          WHERE param_name = 'ISS_CD_HO';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#I#No parameter set up in giis_parameters for ISS_CD_HO.');
         WHEN TOO_MANY_ROWS THEN
            raise_application_error(-20001, 'Geniisys Exception#I#Too many parameters set up in giis_parameters for ISS_CD_HO.');
      END;
   
      FOR i IN(SELECT *
                 FROM (SELECT iss_cd, iss_name
                         FROM giis_issource
                        WHERE NVL(claim_tag, 'N') = 'Y' 
                          AND p_grp_iss_cd = v_iss_cd_ho
                          AND (iss_cd = DECODE(NVL(online_sw,'N'),'N',NVL(p_grp_iss_cd,iss_cd))
                           OR DECODE(NVL(online_sw,'N'),'Y','Y') IN (SELECT NVL(online_sw,'N')
                                                                       FROM giis_issource
                                                                      WHERE iss_cd = NVL(p_grp_iss_cd,iss_cd)))
                        UNION
                       SELECT iss_cd,iss_name
                         FROM giis_issource 
                        WHERE NVL(claim_tag, 'N') = 'N'
                          AND (iss_cd = DECODE(NVL(online_sw,'N'),'N',NVL(p_grp_iss_cd,iss_cd))
                           OR DECODE(NVL(online_sw,'N'),'Y','Y') IN (SELECT NVL(online_sw,'N')
                                                                       FROM giis_issource
                                                                      WHERE iss_cd = NVL(p_grp_iss_cd,iss_cd))) 							  
                        ORDER BY iss_cd)
                WHERE (UPPER(iss_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(iss_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_line_lov(
      p_find_text                VARCHAR2
   )
     RETURN line_lov_tab PIPELINED
   IS
      v_row                      line_lov_type;
   BEGIN
      FOR i IN(SELECT line_cd, line_name
                 FROM giis_line
                WHERE (UPPER(line_cd) LIKE NVL(UPPER(p_find_text), '%')
                   OR UPPER(line_name) LIKE NVL(UPPER(p_find_text), '%'))
                ORDER BY line_cd)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE insert_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_access_tag               giis_user_grp_tran.access_tag%TYPE
   )
   IS
      v_exists                   VARCHAR2(1) := 'N';
   BEGIN
      FOR a IN(SELECT a.module_id
			        FROM giis_modules a,
                      giis_modules_tran b
		          WHERE a.module_id = b.module_id
						AND b.tran_cd = p_tran_cd)
      LOOP
         FOR b IN(SELECT 1
				  	     FROM giis_user_grp_modules
				  	    WHERE user_grp = p_user_grp
				  	      AND module_id = a.module_id
				  	      AND tran_cd = p_tran_cd)
         LOOP
            v_exists := 'Y';
            EXIT;       
         END LOOP;
         
         IF v_exists = 'N' THEN
            INSERT INTO giis_user_grp_modules
		             (user_grp, module_id, tran_cd, access_tag)
            VALUES (p_user_grp, a.module_id, p_tran_cd, p_access_tag);
         ELSE
            UPDATE giis_user_grp_modules
				   SET access_tag = p_access_tag
				 WHERE user_grp = p_user_grp
				   AND module_id = a.module_id
				   AND tran_cd = p_tran_cd;
         END IF;
      END LOOP;
   END;
   
END;
/



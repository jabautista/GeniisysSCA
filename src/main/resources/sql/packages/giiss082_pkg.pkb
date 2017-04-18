CREATE OR REPLACE PACKAGE BODY CPI.GIISS082_PKG
AS

   FUNCTION get_intm_rate_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_rate                  giis_intm_special_rate.rate%TYPE,
      p_override_tag          giis_intm_special_rate.override_tag%TYPE
   )
     RETURN intm_rate_tab PIPELINED
   IS
      v_row                   intm_rate_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_intm_special_rate
                WHERE intm_no = p_intm_no
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND rate = NVL(p_rate, rate)
                  AND UPPER(NVL(override_tag, 'N')) = UPPER(NVL(p_override_tag, NVL(override_tag, 'N')))
                ORDER BY get_peril_name(p_line_cd, peril_cd))
      LOOP
         v_row.intm_no := i.intm_no;
         v_row.iss_cd := i.iss_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.rate := i.rate;
         v_row.line_cd := i.line_cd;
         v_row.override_tag := i.override_tag;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_row.remarks := i.remarks;
         v_row.subline_cd := i.subline_cd;
      
         v_row.peril_name := NULL;
         FOR a IN(SELECT peril_name
                    FROM giis_peril
                   WHERE line_cd = i.line_cd
                     AND peril_cd = i.peril_cd)
         LOOP
            v_row.peril_name := a.peril_name;
            EXIT;
         END LOOP;
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_history_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_eff_date              VARCHAR2,
      p_expiry_date           VARCHAR2,
      p_old_comm_rt           giis_intm_special_rate_hist.old_comm_rate%TYPE,
      p_new_comm_rt           giis_intm_special_rate_hist.new_comm_rate%TYPE,
      p_override_tag          giis_intm_special_rate.override_tag%TYPE
   )
     RETURN intm_rate_hist_tab PIPELINED
   IS
      v_row                   intm_rate_hist_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_intm_special_rate_hist
                WHERE intm_no = p_intm_no
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND old_comm_rate = NVL(p_old_comm_rt, old_comm_rate)
                  AND new_comm_rate = NVL(p_new_comm_rt, new_comm_rate)
                  AND UPPER(NVL(override_tag, 'N')) = UPPER(NVL(p_override_tag, NVL(override_tag, 'N')))
                ORDER BY eff_date DESC)
      LOOP
         v_row.eff_date := TO_CHAR(i.eff_date, 'mm-dd-yyyy');
         v_row.expiry_date  := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
         v_row.old_comm_rate := i.old_comm_rate;
         v_row.new_comm_rate := i.new_comm_rate;
         v_row.override_tag := i.override_tag;
      
         FOR a IN(SELECT peril_name
                    FROM giis_peril
                   WHERE line_cd = i.line_cd
                     AND peril_cd = i.peril_cd)
         LOOP
            v_row.peril_name := a.peril_name;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_intm_lov(
      p_find_text             VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED
   IS
      v_row                   intm_lov_type;
   BEGIN
      FOR i IN(SELECT intm_no, intm_name
                 FROM giis_intermediary
                WHERE (TO_CHAR(intm_no) LIKE TO_CHAR(NVL(p_find_text, intm_no)) OR UPPER(intm_name) LIKE UPPER(NVL(p_find_text, intm_name)))
                ORDER BY intm_no)
      LOOP
         v_row.intm_no := i.intm_no;
         v_row.intm_name := i.intm_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_iss_cd_lov(
      p_line_cd            giis_line.line_cd%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN iss_cd_lov_tab PIPELINED
   IS
      v_row                iss_cd_lov_type;
   BEGIN
      FOR i IN(SELECT a.iss_cd, a.iss_name
                 FROM giis_issource a 
                WHERE check_user_per_iss_cd2(p_line_cd, a.iss_cd, 'GIISS082', p_user_id) = 1
                  AND (UPPER(iss_cd) LIKE UPPER(NVL(p_find_text, iss_cd)) OR
                      UPPER(iss_name) LIKE UPPER(NVL(p_find_text, iss_name)))
                ORDER BY iss_name)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_line_cd_lov(
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN line_lov_tab PIPELINED
   IS
      v_row                line_lov_type;
   BEGIN
      FOR i IN(SELECT a.line_name, a.line_cd
                 FROM giis_line A 
                WHERE check_user_per_line2(line_cd, p_iss_cd, 'GIISS082', p_user_id) = 1
                  AND (UPPER(line_cd) LIKE UPPER(NVL(p_find_text, line_cd)) OR
                      UPPER(line_name) LIKE UPPER(NVL(p_find_text, line_name))) 
                ORDER BY line_name)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_subline_cd_lov(
      p_line_cd            giis_line.line_cd%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED
   IS
      v_row                subline_lov_type;
   BEGIN
      FOR i IN(SELECT a.subline_name, a.subline_cd
                 FROM giis_subline a
                WHERE a.line_cd = NVL(p_line_cd, line_cd)
                  AND (UPPER(subline_cd) LIKE UPPER(NVL(p_find_text, subline_cd)) OR
                      UPPER(subline_name) LIKE UPPER(NVL(p_find_text, subline_name)))
                ORDER BY subline_name)
      LOOP
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_peril_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN peril_lov_tab PIPELINED
   IS
      v_row                   peril_lov_type;
   BEGIN
      FOR i IN(SELECT a.peril_name, a.peril_cd, SUBSTR(b.rv_meaning,1,20) peril_type
                 FROM giis_peril a, cg_ref_codes b
                WHERE a.line_cd = NVL(p_line_cd, a.line_cd)
                  AND a.peril_type = SUBSTR(b.rv_low_value,1,2)
                  AND b.rv_domain = 'GIIS_PERIL.PERIL_TYPE'
                  AND (UPPER(peril_cd) LIKE UPPER(NVL(p_find_text, peril_cd)) OR
                      UPPER(peril_name) LIKE UPPER(NVL(p_find_text, peril_name)) OR
                      UPPER(SUBSTR(b.rv_meaning,1,20)) LIKE UPPER(NVL(p_find_text, SUBSTR(b.rv_meaning,1,20))))
                ORDER BY a.peril_name)
      LOOP
         v_row.peril_cd := i.peril_cd;
         v_row.peril_name := i.peril_name;
         v_row.peril_type := UPPER(i.peril_type);
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_copy_intm_lov(
      p_find_text             VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED
   IS
      v_row                   intm_lov_type;
   BEGIN
      FOR i IN(SELECT a.intm_no, a.intm_name
                 FROM giis_intermediary a
                WHERE EXISTS(SELECT 1
                               FROM giis_intm_special_rate b
                              WHERE b.intm_no = a.intm_no)
                  AND (TO_CHAR(a.intm_no) LIKE TO_CHAR(NVL(p_find_text, a.intm_no)) OR UPPER(a.intm_name) LIKE UPPER(NVL(p_find_text, a.intm_name)))
                ORDER BY a.intm_no)
      LOOP
         v_row.intm_no := i.intm_no;
         v_row.intm_name := i.intm_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_copy_iss_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN iss_cd_lov_tab PIPELINED
   IS
      v_row                   iss_cd_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.iss_cd, b.iss_name
                 FROM giis_intm_special_rate a,
                      giis_issource b
                WHERE a.iss_cd = b.iss_cd
                  AND a.intm_no = p_intm_no
                  AND a.peril_cd IS NOT NULL
                  AND (UPPER(a.iss_cd) LIKE UPPER(NVL(p_find_text, a.iss_cd)) OR
                      UPPER(b.iss_name) LIKE UPPER(NVL(p_find_text, b.iss_name)))
                ORDER BY b.iss_name)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_copy_line_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN line_lov_tab PIPELINED
   IS
      v_row                   line_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.line_name, b.line_cd
                 FROM giis_line a,
                      giis_intm_special_rate b
                WHERE a.line_cd = b.line_cd
                  AND b.iss_cd = NVL(p_iss_cd, b.iss_cd)
                  AND b.intm_no = p_intm_no 
                  AND b.peril_cd IS NOT NULL
                  AND (UPPER(b.line_cd) LIKE UPPER(NVL(p_find_text, b.line_cd)) OR
                      UPPER(a.line_name) LIKE UPPER(NVL(p_find_text, a.line_name)))
                ORDER BY a.line_name)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_copy_subline_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED
   IS
      v_row                   subline_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.subline_name, b.subline_cd
                 FROM giis_subline a,
                      giis_intm_special_rate b
                WHERE a.subline_cd= b.subline_cd
                  AND b.line_cd = p_line_cd
                  AND b.iss_cd  = NVL(p_iss_cd, b.iss_cd)
                  AND b.intm_no = p_intm_no
                  AND (UPPER(b.subline_cd) LIKE UPPER(NVL(p_find_text, b.subline_cd)) OR
                      UPPER(a.subline_name) LIKE UPPER(NVL(p_find_text, a.subline_name)))
                ORDER BY b.subline_cd)
      LOOP
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE populate_perils(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_user_id               giis_intm_special_rate.user_id%TYPE
   )
   IS
      v_exists                NUMBER;
   BEGIN
      FOR i IN(SELECT a.peril_cd
					  FROM giis_peril a,
                      cg_ref_codes b
					 WHERE a.line_cd = NVL(p_line_cd, a.line_cd)
                  AND a.peril_type = SUBSTR(b.rv_low_value,1,2)
                  AND b.rv_domain = 'GIIS_PERIL.PERIL_TYPE'
                ORDER BY a.peril_cd)
   	LOOP
         BEGIN
            SELECT 1
		   	  INTO v_exists
		   	  FROM giis_intm_special_rate
		   	 WHERE intm_no = p_intm_no 
               AND iss_cd = p_iss_cd
               AND line_cd = p_line_cd 
               AND subline_cd = p_subline_cd 
               AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               INSERT INTO giis_intm_special_rate
		                (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update)
		         VALUES (p_intm_no, p_iss_cd, p_line_cd, p_subline_cd, i.peril_cd, 0, 'N', p_user_id, SYSDATE);
         END;
      END LOOP;
   END;
   
   PROCEDURE set_rec(
      p_rec                   giis_intm_special_rate%ROWTYPE
   )
   IS
      v_exist                 BOOLEAN := FALSE;
      v_old_comm_rate         giis_intm_special_rate_hist.old_comm_rate%TYPE;
   BEGIN
      MERGE INTO giis_intm_special_rate
      USING DUAL
         ON (intm_no = p_rec.intm_no
            AND iss_cd = p_rec.iss_cd
            AND line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd)
       WHEN NOT MATCHED THEN
            INSERT (intm_no, iss_cd, peril_cd, rate, line_cd, override_tag, user_id, last_update, remarks, subline_cd)
            VALUES (p_rec.intm_no, p_rec.iss_cd, p_rec.peril_cd, p_rec.rate, p_rec.line_cd, p_rec.override_tag, p_rec.user_id,
                    SYSDATE, p_rec.remarks, p_rec.subline_cd)
       WHEN MATCHED THEN
            UPDATE SET rate = p_rec.rate,
                       override_tag = p_rec.override_tag,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
                       
      FOR a IN(SELECT new_comm_rate
					  FROM giis_intm_special_rate_hist
					 WHERE intm_no = p_rec.intm_no
						AND iss_cd = p_rec.iss_cd
                  AND line_cd = p_rec.line_cd
                  AND subline_cd = p_rec.subline_cd
						AND peril_cd = p_rec.peril_cd
						AND expiry_date IS NULL)
      LOOP
         v_old_comm_rate := a.new_comm_rate;
         v_exist := TRUE;
         EXIT;
      END LOOP;
      
      IF v_exist THEN
         UPDATE giis_intm_special_rate_hist
				SET expiry_date = SYSDATE
			 WHERE intm_no = p_rec.intm_no
            AND iss_cd = p_rec.iss_cd
            AND line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd
			   AND peril_cd = p_rec.peril_cd
            AND new_comm_rate = v_old_comm_rate
				AND expiry_date IS NULL;
      END IF;
      
      IF v_old_comm_rate IS NULL THEN
         v_old_comm_rate := p_rec.rate;
      END IF;
      
      INSERT INTO giis_intm_special_rate_hist
             (intm_no, iss_cd, line_cd, subline_cd, peril_cd, old_comm_rate, new_comm_rate, override_tag, eff_date, expiry_date)				
      VALUES (p_rec.intm_no, p_rec.iss_cd, p_rec.line_cd, p_rec.subline_cd, p_rec.peril_cd, v_old_comm_rate,
              p_rec.rate, p_rec.override_tag, SYSDATE, NULL);
   END;
   
   PROCEDURE del_rec(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_peril_cd              giis_intm_special_rate.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_intm_special_rate_hist
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND line_cd = p_line_Cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd;
   
      DELETE
        FROM giis_intm_special_rate
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND line_cd = p_line_Cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd;
   END;
   
   PROCEDURE copy_intm_rate_giiss082(
      p_intm_no_to            giis_intm_special_rate.intm_no%TYPE,
      p_intm_no_from          giis_intm_special_rate.intm_no%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_user_id               giis_intm_special_rate.user_id%TYPE
   )
   IS
   BEGIN
      IF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NOT NULL THEN
         FOR c IN(SELECT peril_cd, rate, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND iss_cd = p_iss_cd 
                     AND line_cd = p_line_cd 
                     AND subline_cd = p_subline_cd
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to
                                             AND iss_cd = p_iss_cd
                                             AND line_cd = p_line_cd
                                             AND subline_cd = p_subline_cd))
         LOOP
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update) 
            VALUES (p_intm_no_to, p_iss_cd, p_line_cd, p_subline_cd, c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL THEN
         FOR c IN(SELECT peril_cd, rate, subline_cd, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND iss_cd = p_iss_cd
                     AND line_cd = p_line_cd 
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to
                                            AND iss_cd = p_iss_cd
                                            AND line_cd = p_line_cd))
         LOOP
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update) 
            VALUES (p_intm_no_to, p_iss_cd, p_line_cd, c.subline_cd , c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      ELSIF p_iss_cd IS NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NOT NULL THEN
         FOR c IN(SELECT peril_cd, rate, subline_cd, iss_cd, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND line_cd = p_line_cd
                     AND subline_cd = p_subline_cd 
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to
                                            AND line_cd = p_line_cd  
                                            AND subline_cd = p_subline_cd))                                           
         LOOP
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag ,user_id, last_update) 
            VALUES (p_intm_no_to , c.iss_cd, p_line_cd, p_subline_cd, c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NULL AND p_subline_cd IS NULL THEN
         FOR c IN(SELECT peril_cd, rate, line_cd, subline_cd, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND iss_cd = p_iss_cd 
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to
                                            AND iss_cd = p_iss_cd))
         LOOP
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update) 
            VALUES (p_intm_no_to, p_iss_cd, c.line_cd, c.subline_cd, c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      ELSIF p_iss_cd IS NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL THEN   
         FOR c IN(SELECT peril_cd, rate, line_cd, subline_cd, iss_cd, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND line_cd = p_line_cd 
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to
                                            AND line_cd = p_line_cd))
         LOOP 
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update) 
            VALUES (p_intm_no_to, c.iss_cd, c.line_cd, c.subline_cd, c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      ELSIF p_iss_cd IS NULL AND p_line_cd IS NULL AND p_subline_cd IS NULL THEN
         FOR c IN(SELECT peril_cd, rate, iss_cd, line_cd, subline_cd, override_tag
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no_from
                     AND peril_cd NOT IN(SELECT peril_cd
                                           FROM giis_intm_special_rate
                                          WHERE intm_no = p_intm_no_to))                       
         LOOP
            INSERT INTO giis_intm_special_rate
                   (intm_no, iss_cd, line_cd, subline_cd, peril_cd, rate, override_tag, user_id, last_update) 
            VALUES (p_intm_no_to, c.iss_cd, c.line_cd, c.subline_cd, c.peril_cd, c.rate, c.override_tag, p_user_id, SYSDATE);
         END LOOP;
      END IF;
   END;
   
   FUNCTION get_peril_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE
   )
     RETURN VARCHAR2
   IS
      v_result                VARCHAR2(5000); --VARCHAR2(500); niel SR-24013
   BEGIN
      FOR i IN(SELECT peril_cd
                 FROM giis_intm_special_rate
                WHERE intm_no = p_intm_no
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd)
      LOOP
         IF v_result IS NULL THEN
            v_result := TO_CHAR(i.peril_cd);
         ELSE
            v_result := v_result || ',' || TO_CHAR(i.peril_cd);
         END IF;
      END LOOP;
      
      RETURN v_result;
   END;

END;
/

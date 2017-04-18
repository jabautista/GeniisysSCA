CREATE OR REPLACE PACKAGE BODY CPI.giiss201_pkg
AS

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
                WHERE check_user_per_iss_cd2(NULL, a.iss_cd, 'GIISS201', p_user_id) = 1
                  AND (UPPER(iss_cd) LIKE UPPER(NVL(p_find_text, iss_cd)) OR
                      UPPER(iss_name) LIKE UPPER(NVL(p_find_text, iss_name)))
                ORDER BY iss_cd)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_intm_type_lov(
      p_find_text          VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED
   IS
      v_row                intm_lov_type;
   BEGIN
      FOR i IN(SELECT a.intm_desc, a.intm_type
                 FROM giis_intm_type a
                WHERE (UPPER(intm_type) LIKE UPPER(NVL(p_find_text, intm_type)) OR
                      UPPER(intm_desc) LIKE UPPER(NVL(p_find_text, intm_desc)))
                ORDER BY intm_type)
      LOOP
         v_row.intm_type := i.intm_type;
         v_row.intm_name := UPPER(i.intm_desc);
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
                WHERE check_user_per_line2(line_cd, p_iss_cd, 'GIISS201', p_user_id) = 1
                  AND (UPPER(line_cd) LIKE UPPER(NVL(p_find_text, line_cd)) OR
                      UPPER(line_name) LIKE UPPER(NVL(p_find_text, line_name))) 
                ORDER BY line_cd)
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
                WHERE a.line_cd = p_line_cd
                  AND (UPPER(subline_cd) LIKE UPPER(NVL(p_find_text, subline_cd)) OR
                      UPPER(subline_name) LIKE UPPER(NVL(p_find_text, subline_name)))
                ORDER BY subline_cd)
      LOOP
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_peril_lov(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN peril_lov_tab PIPELINED
   IS
      v_row                peril_lov_type;
   BEGIN
      FOR i IN(SELECT a.peril_name, a.peril_cd, SUBSTR(b.rv_meaning,1,20) peril_type
                 FROM giis_peril a, cg_ref_codes b
                WHERE a.line_cd = NVL(p_line_cd, a.line_cd)
                  AND a.peril_type = SUBSTR(b.rv_low_value,1,2)
                  AND b.rv_domain = 'GIIS_PERIL.PERIL_TYPE'
                  AND a.peril_cd NOT IN(SELECT peril_cd
                                          FROM giis_intmdry_type_rt c
                                         WHERE c.iss_cd = p_iss_cd
                                           AND c.intm_type = p_intm_type
                                           AND c.line_cd = p_line_cd
                                           AND c.subline_cd = p_subline_cd)
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
   
   FUNCTION get_rec_list(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_user_id            giis_intmdry_type_rt.user_id%TYPE
   )
     RETURN rec_tab PIPELINED
   IS 
      v_rec                rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_intmdry_type_rt
                 WHERE iss_cd = p_iss_cd
                   AND intm_type = p_intm_type
                   AND line_cd = p_line_cd
                   AND subline_cd = p_subline_cd)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.intm_type := i.intm_type;
         v_rec.line_cd := i.line_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.comm_rate := i.comm_rate;
         v_rec.user_id := i.user_id;
         v_rec.last_update := i.last_update;
         v_rec.remarks := i.remarks;
         v_rec.subline_cd := i.subline_cd;
         v_rec.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
      
         FOR p IN (SELECT peril_name
                     FROM giis_peril
                    WHERE peril_cd = i.peril_cd
                      AND line_cd = i.line_cd)
         LOOP
            v_rec.peril_name := p.peril_name;
            EXIT;
         END LOOP;
      
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_rec_history(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE
   )
     RETURN rec_hist_tab PIPELINED
   IS
      v_row                rec_hist_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_intmdry_type_rt_hist
                WHERE iss_cd = p_iss_cd
                  AND intm_type = p_intm_type
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                ORDER BY peril_cd, eff_date)
      LOOP
         FOR p IN(SELECT peril_name
                    FROM giis_peril
                   WHERE peril_cd = i.peril_cd
                     AND line_cd = p_line_cd)
         LOOP
            v_row.peril_name := p.peril_name;
            EXIT;
         END LOOP;
      
         v_row.old_comm_rate := i.old_comm_rate;
         v_row.new_comm_rate := i.new_comm_rate;
         v_row.dsp_eff_date := TO_CHAR(i.eff_date, 'mm-dd-yyyy');
         v_row.dsp_expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
         PIPE ROW(v_row);
      END LOOP;
   END;

   PROCEDURE set_rec(
      p_rec                giis_intmdry_type_rt%ROWTYPE
   )
   IS
      v_exist              BOOLEAN := FALSE;
      v_old_comm_rate      giis_intmdry_type_rt_hist.old_comm_rate%TYPE;
   BEGIN
      MERGE INTO giis_intmdry_type_rt
      USING DUAL
         ON (iss_cd = p_rec.iss_cd
            AND intm_type = p_rec.intm_type
            AND line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd)
       WHEN NOT MATCHED THEN
            INSERT (iss_cd, intm_type, line_cd, peril_cd, comm_rate, user_id, last_update, remarks, subline_cd)
            VALUES (p_rec.iss_cd, p_rec.intm_type, p_rec.line_cd, p_rec.peril_cd, p_rec.comm_rate, p_rec.user_id, SYSDATE, p_rec.remarks, p_rec.subline_cd)
       WHEN MATCHED THEN
            UPDATE SET comm_rate = p_rec.comm_rate,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
                       
      FOR i IN(SELECT new_comm_rate
                 FROM giis_intmdry_type_rt_hist
					 WHERE iss_cd = p_rec.iss_cd
					   AND intm_type = p_rec.intm_type
                  AND line_cd = p_rec.line_cd
                  AND subline_cd = p_rec.subline_cd
						AND peril_cd = p_rec.peril_cd
						AND expiry_date IS NULL)
      LOOP
         v_old_comm_rate := i.new_comm_rate;
         v_exist := TRUE;
         EXIT;
      END LOOP;
      
      IF NVL(v_old_comm_rate, p_rec.comm_rate - 1) <> p_rec.comm_rate THEN
         IF v_exist THEN
            UPDATE giis_intmdry_type_rt_hist
               SET expiry_date = SYSDATE
             WHERE iss_cd = p_rec.iss_cd
               AND intm_type = p_rec.intm_type
               AND line_cd = p_rec.line_cd
               AND subline_cd = p_rec.subline_cd
               AND peril_cd = p_rec.peril_cd
               AND new_comm_rate = v_old_comm_rate
               AND expiry_date IS NULL;
         END IF;
         
         IF v_old_comm_rate IS NULL THEN
            v_old_comm_rate := p_rec.comm_rate;
         END IF;
      
         INSERT INTO giis_intmdry_type_rt_hist
                (iss_cd, intm_type, line_cd, subline_cd, peril_cd, old_comm_rate, new_comm_rate, eff_date, expiry_date)				
         VALUES (p_rec.iss_cd, p_rec.intm_type, p_rec.line_cd, p_rec.subline_cd, p_rec.peril_cd, v_old_comm_rate, p_rec.comm_rate, SYSDATE, NULL);
      END IF;
   END;

   PROCEDURE del_rec(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_peril_cd           giis_intmdry_type_rt.peril_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_intmdry_type_rt_hist
       WHERE iss_cd = p_iss_cd
         AND intm_type = p_intm_type
         AND line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd;
   
      DELETE FROM giis_intmdry_type_rt
       WHERE iss_cd = p_iss_cd
         AND intm_type = p_intm_type
         AND line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd;
   END;

   PROCEDURE val_del_rec(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_peril_cd           giis_intmdry_type_rt.peril_cd%TYPE
   )
   AS
      v_exists             VARCHAR2(1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_intmdry_type_rt_hist
                 WHERE iss_cd = p_iss_cd
                   AND intm_type = p_intm_type
                   AND line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd = p_peril_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTMDRY_TYPE_RT ' || 
                                          'while dependent record(s) in GIIS_INTMDRY_TYPE_RT_HIST exists.');
      END IF;
   END;
   
END;
/



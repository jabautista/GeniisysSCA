CREATE OR REPLACE PACKAGE BODY CPI.giiss202_pkg
AS 
   FUNCTION get_iss_lov (
      p_line_cd   VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN iss_lov_tab PIPELINED
   IS
      v_list iss_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE check_user_per_iss_cd2 (NULL, iss_cd,'GIISS202', p_user_id) = 1
              ORDER BY iss_name)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_iss_lov;
   
   FUNCTION get_copy_iss_lov
      RETURN iss_lov_tab PIPELINED
   IS
      v_list iss_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                  FROM giis_issource
              ORDER BY iss_name)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW(v_list);
      END LOOP;                    
   END get_copy_iss_lov;   
   
   FUNCTION get_line_lov (p_iss_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_list line_lov_type;
   BEGIN
      FOR i IN (SELECT line_name , line_cd 
                  FROM giis_line
                 WHERE check_user_per_line2 (line_cd, p_iss_cd, 'GIISS202', p_user_id) = 1
              ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_line_lov;
   
   FUNCTION get_subline_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN subline_lov_tab PIPELINED
   IS
      v_list subline_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT subline_name subline_name, subline_cd subline_cd
                  FROM giis_subline
                 WHERE line_cd = NVL (p_line_cd, line_cd)
              ORDER BY subline_name)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_subline_lov;
   
   FUNCTION get_rec_list (
      p_iss_cd        VARCHAR2,
      p_intm_no       VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_list rec_type;
   BEGIN
      FOR i IN (SELECT iss_cd, intm_no, line_cd, subline_cd,
                        peril_cd, get_peril_name(line_cd,peril_cd) peril_name,
                        comm_rate, user_id, last_update, remarks
                  FROM giis_spl_override_rt
                 WHERE iss_cd = p_iss_cd
                   AND intm_no = p_intm_no
                   AND line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
              ORDER BY peril_name)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.intm_no := i.intm_no;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.peril_cd := i.peril_cd;
         v_list.peril_name := i.peril_name;
         v_list.comm_rate := i.comm_rate;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_rec_list;
   
   FUNCTION get_peril_lov (
      p_line_cd         VARCHAR2,
      p_selected_perils VARCHAR2
   )
      RETURN peril_lov_tab PIPELINED
   IS
      v_list peril_lov_type;
   BEGIN
      FOR i IN (SELECT  a.peril_name, a.peril_cd, SUBSTR (b.rv_meaning, 1, 20) peril_meaning
                  FROM giis_peril a, cg_ref_codes b
                 WHERE a.line_cd = p_line_cd
                   AND a.peril_type = SUBSTR (b.rv_low_value, 1, 2)
                   AND b.rv_domain = 'GIIS_PERIL.PERIL_TYPE'
--                   AND a.peril_cd NOT IN (NVL(p_selected_perils, -999999))
              ORDER BY a.peril_name)
      LOOP
         v_list.peril_cd := i.peril_cd;
         v_list.peril_name := i.peril_name;
         v_list.peril_meaning := i.peril_meaning;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_peril_lov;
   
   FUNCTION get_selected_perils (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_selected_perils VARCHAR2(32767);
   BEGIN
   
      FOR i IN (SELECT peril_cd
                  FROM giis_spl_override_rt
                 WHERE subline_cd = p_subline_cd
                   AND line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND intm_no = p_intm_no
              ORDER BY peril_cd)
      LOOP
         v_selected_perils := TRIM(v_selected_perils) || TRIM(i.peril_cd) || ',';
      END LOOP;
      
      RETURN v_selected_perils;
      
   END get_selected_perils;
   
   PROCEDURE set_rec (p_rec giis_spl_override_rt%ROWTYPE)
   IS
      v_exists VARCHAR2(1) := 'N';
      v_comm_rate giis_spl_override_rt.comm_rate%TYPE;
   BEGIN
   
      BEGIN
         SELECT 'Y', comm_rate
           INTO v_exists, v_comm_rate
           FROM giis_spl_override_rt
          WHERE intm_no = p_rec.intm_no
            AND iss_cd = p_rec.iss_cd
            AND line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';       
      END;
      
      IF v_exists = 'Y' THEN
         BEGIN
            UPDATE giis_spl_override_rt
               SET comm_rate = p_rec.comm_rate,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE,
                   remarks = p_rec.remarks
             WHERE iss_cd = p_rec.iss_cd
               AND intm_no = p_rec.intm_no
               AND line_cd = p_rec.line_cd
               AND subline_cd = p_rec.subline_cd
               AND peril_cd = p_rec.peril_cd;               
         END;
         
         
         IF p_rec.comm_rate != v_comm_rate THEN
            BEGIN
               UPDATE giis_spl_override_rt_hist
                  SET expiry_date = SYSDATE
                WHERE  iss_cd = p_rec.iss_cd
                  AND intm_no = p_rec.intm_no
                  AND line_cd = p_rec.line_cd
                  AND subline_cd = p_rec.subline_cd
                  AND peril_cd = p_rec.peril_cd;
                  
               INSERT INTO giis_spl_override_rt_hist
                           (iss_cd, intm_no, line_cd, subline_cd, peril_cd,
                            old_comm_rate, new_comm_rate, eff_date)
               VALUES (p_rec.iss_cd, p_rec.intm_no, p_rec.line_cd, p_rec.subline_cd,
                       p_rec.peril_cd, v_comm_rate, p_rec.comm_rate, SYSDATE);    
            END;   
         END IF;
      ELSE
         BEGIN
            INSERT INTO giis_spl_override_rt
                        (iss_cd, intm_no, line_cd, subline_cd, peril_cd, comm_rate,
                         user_id, last_update, remarks)
            VALUES (p_rec.iss_cd, p_rec.intm_no, p_rec.line_cd, p_rec.subline_cd,
                    p_rec.peril_cd, p_rec.comm_rate, p_rec.user_id, SYSDATE, p_rec.remarks);
                    
            INSERT INTO giis_spl_override_rt_hist
                        (iss_cd, intm_no, line_cd, subline_cd, peril_cd,
                         old_comm_rate, new_comm_rate, eff_date)
            VALUES (p_rec.iss_cd, p_rec.intm_no, p_rec.line_cd, p_rec.subline_cd,
                    p_rec.peril_cd, p_rec.comm_rate, p_rec.comm_rate, SYSDATE);             
                           
         END;   
      END IF;
   
   
--      MERGE INTO giis_spl_override_rt
--         USING DUAL
--         ON (intm_no = p_rec.intm_no
--             AND iss_cd = p_rec.iss_cd
--             AND line_cd = p_rec.line_cd
--             AND subline_cd = p_rec.subline_cd
--             AND peril_cd = p_rec.peril_cd)
--         WHEN NOT MATCHED THEN
--            INSERT (intm_no, iss_cd, line_cd, subline_cd, peril_cd,
--                    comm_rate, user_id, last_update, remarks)
--            VALUES (p_rec.intm_no, p_rec.iss_cd, p_rec.line_cd,
--                    p_rec.subline_cd, p_rec.peril_cd, p_rec.comm_rate,
--                    p_rec.user_id, SYSDATE, p_rec.remarks)
--         WHEN MATCHED THEN
--            UPDATE
--               SET comm_rate = p_rec.comm_rate,
--                   user_id = p_rec.user_id,
--                   last_update = SYSDATE,
--                   remarks = p_rec.remarks;
   END set_rec;
   
   PROCEDURE del_rec (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_peril_cd     VARCHAR2
   )
   IS
   BEGIN
      
      DELETE
        FROM giis_spl_override_rt_hist
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd; 
        
   
      DELETE
        FROM giis_spl_override_rt
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND peril_cd = p_peril_cd; 
   END del_rec;
   
   PROCEDURE populate (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2
   )
   IS
   BEGIN
      FOR i IN(SELECT DISTINCT peril_cd
  					  FROM giis_peril
                WHERE line_cd LIKE p_line_cd
                MINUS
               SELECT DISTINCT peril_cd
  					  FROM giis_peril
 					 WHERE line_cd LIKE p_line_cd
   					AND subline_cd <> p_subline_cd
					 MINUS
					SELECT peril_cd
  					  FROM giis_spl_override_rt
 				    WHERE intm_no = p_intm_no
 						AND iss_cd = p_iss_cd
 						AND line_cd LIKE p_line_cd
   					AND subline_cd LIKE p_subline_cd)
	   LOOP
		   INSERT INTO giis_spl_override_rt
                (iss_cd, intm_no, line_cd, peril_cd,
                 subline_cd, comm_rate, user_id, last_update)
		   VALUES(p_iss_cd, p_intm_no, p_line_cd, i.peril_cd,
                p_subline_cd, 0, p_user_id, SYSDATE);
                
         INSERT INTO giis_spl_override_rt_hist
                        (iss_cd, intm_no, line_cd, subline_cd, peril_cd,
                         old_comm_rate, new_comm_rate, eff_date)
            VALUES (p_iss_cd, p_intm_no, p_line_cd, p_subline_cd,
                    i.peril_cd, 0, 0, SYSDATE);
                
	   END LOOP;
   END populate;
   
   PROCEDURE copy (
      p_intm_no_from   VARCHAR2,
      p_iss_cd_from    VARCHAR2,
      p_intm_no_to     VARCHAR2,
      p_iss_cd_to      VARCHAR2,
      p_line_cd        VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
   IS
   BEGIN
      FOR c IN (SELECT peril_cd,comm_rate
                  FROM giis_spl_override_rt
                 WHERE intm_no    = p_intm_no_from
                   AND iss_cd     = p_iss_cd_from
                   AND line_cd    = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd NOT IN (SELECT peril_cd
        									  	      FROM giis_spl_override_rt
  	 		  									     WHERE intm_no    = p_intm_no_to
                                           AND iss_cd     = p_iss_cd_to
                                           AND line_cd    = p_line_cd
                                           AND subline_cd = p_subline_cd))
      LOOP
 	      INSERT INTO giis_spl_override_rt
                (intm_no, iss_cd, line_cd, subline_cd,
 	  			     peril_cd, comm_rate, user_id, last_update) 
         VALUES(p_intm_no_to, p_iss_cd_to, p_line_cd, p_subline_cd,
	 	    	    c.peril_cd, c.comm_rate, p_user_id, SYSDATE);
                
         INSERT INTO giis_spl_override_rt_hist
                        (iss_cd, intm_no, line_cd, subline_cd, peril_cd,
                         old_comm_rate, new_comm_rate, eff_date)
            VALUES (p_iss_cd_to, p_intm_no_to, p_line_cd, p_subline_cd,
                    c.peril_cd, c.comm_rate, c.comm_rate, SYSDATE);                
                
      END LOOP;
   END copy;
   
   FUNCTION get_history(
      p_iss_cd       giis_spl_override_rt_hist.iss_cd%TYPE,
      p_intm_no      giis_spl_override_rt_hist.intm_no%TYPE,
      p_line_cd      giis_spl_override_rt_hist.line_cd%TYPE,
      p_subline_cd   giis_spl_override_rt_hist.subline_cd%TYPE,
      p_old_comm_rate giis_spl_override_rt_hist.old_comm_rate%TYPE,
      p_new_comm_rate giis_spl_override_rt_hist.new_comm_rate%TYPE
   )
      RETURN history_tab PIPELINED
   IS
      v_list history_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_spl_override_rt_hist
                 WHERE iss_cd = p_iss_cd
                   AND intm_no = p_intm_no
                   AND line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND old_comm_rate = NVL(p_old_comm_rate, old_comm_rate)
                  AND new_comm_rate = NVL(p_new_comm_rate, new_comm_rate)
--                   AND peril_cd = NVL(p_peril_cd, peril_cd)
                   ORDER BY eff_date desc)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.intm_no := i.intm_no;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.peril_cd := i.peril_cd;
         v_list.old_comm_rate := i.old_comm_rate;
         v_list.new_comm_rate := i.new_comm_rate;
         v_list.eff_date := TO_CHAR(i.eff_date, 'mm-dd-yyyy');
         v_list.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
         
         BEGIN
            SELECT peril_name
              INTO v_list.peril_name
              FROM giis_peril
             WHERE peril_cd = i.peril_cd
               AND line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.peril_name := NULL;       
         END;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_history;      
      
END;
/



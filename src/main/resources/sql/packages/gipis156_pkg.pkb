CREATE OR REPLACE PACKAGE BODY CPI.GIPIS156_PKG AS
   
   FUNCTION get_gipis156_booking_hist(
      p_policy_id       VARCHAR2,
      p_takeup_seq_no   VARCHAR2,
      p_prem_seq_no     VARCHAR2
   )
      RETURN gipis156_booking_hist_tab PIPELINED
   IS
   	  v_prem_seq_no 		gipi_booking_hist.prem_seq_no%TYPE;
	  v_takeup_seq_no 	gipi_booking_hist.takeup_seq_no%TYPE;
	  v_no_of_takeup		gipi_invoice.no_of_takeup%TYPE;
	  v_prem_seq				gipi_booking_hist.prem_seq_no%TYPE;
      v_select          VARCHAR2(32767);
      v_where           VARCHAR2(32767);
      v_endt_type       gipi_polbasic.endt_type%TYPE;
      TYPE cur_typ IS REF CURSOR;
      c                 cur_typ;
      v_list gipis156_booking_hist_type;
   BEGIN
   
      v_select := 'SELECT policy_id, takeup_seq_no, iss_cd,
                          prem_seq_no, old_reg_pol_sw, new_reg_pol_sw,
                          old_cred_branch, new_cred_branch, old_booking_mm,
                          new_booking_mm, old_booking_yy, new_booking_yy, user_id,
                          last_update, hist_no 
                     FROM gipi_booking_hist';                     
                     
      BEGIN
         SELECT endt_type
           INTO v_endt_type
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_endt_type := NULL;    
      END;
           
      FOR i IN (SELECT DISTINCT a.no_of_takeup no_of_take, min(b.prem_seq_no) prem_seq, b.takeup_seq_no take
                  FROM gipi_invoice a, gipi_booking_hist b
	          	 WHERE b.policy_id = a.policy_id
                   AND b.policy_id = p_policy_id
                   AND b.takeup_seq_no = a.takeup_seq_no
				   AND b.takeup_seq_no =p_takeup_seq_no
		      GROUP BY b.takeup_seq_no ,a.no_of_takeup)
      LOOP
         v_prem_seq_no := i.prem_seq;
	     v_takeup_seq_no := i.take;
		 v_no_of_takeup := i.no_of_take;
      END LOOP;
      
      IF NVL(v_endt_type, 'A') = 'N' THEN
         v_where := 'WHERE policy_id = ' || p_policy_id || ' AND takeup_seq_no = 0 AND prem_seq_no = 0';
      ELSIF v_no_of_takeup = 1 THEN
         v_where := 'WHERE policy_id = ' || p_policy_id || ' AND takeup_seq_no = ' || p_takeup_seq_no || ' AND prem_seq_no = ' || v_prem_seq_no;
      ELSIF v_no_of_takeup > 1 THEN
         v_where := 'WHERE policy_id = ' || p_policy_id || ' AND takeup_seq_no = ' || p_takeup_seq_no || ' AND prem_seq_no = ' || p_prem_seq_no;
      ELSE
         v_where := 'WHERE policy_id = ' || p_policy_id || ' AND takeup_seq_no = ' || p_takeup_seq_no || ' AND prem_seq_no = ' || p_prem_seq_no;      
      END IF;
      
      v_select := v_select || ' ' || v_where || ' ORDER BY hist_no';
      
      OPEN c FOR v_select;
      
      LOOP
         FETCH c
           INTO v_list.policy_id, v_list.takeup_seq_no, v_list.iss_cd,
                v_list.prem_seq_no, v_list.old_reg_pol_sw, v_list.new_reg_pol_sw,
                v_list.old_cred_branch, v_list.new_cred_branch, v_list.old_booking_mm,
                v_list.new_booking_mm, v_list.old_booking_yy, v_list.new_booking_yy, v_list.user_id,
                v_list.last_update, v_list.hist_no;
                
         v_list.old_booking_mm_yy := v_list.old_booking_mm || ' ' || v_list.old_booking_yy;
         v_list.new_booking_mm_yy := v_list.new_booking_mm || ' ' || v_list.new_booking_yy;
         
         FOR i IN(SELECT DISTINCT a.no_of_takeup no_of_take
		         FROM gipi_invoice a, gipi_booking_hist b
				WHERE b.policy_id = a.policy_id
                  AND b.policy_id = p_policy_id
                  AND b.takeup_seq_no = a.takeup_seq_no
				  AND b.takeup_seq_no = p_takeup_seq_no)
         LOOP
            v_no_of_takeup := i.no_of_take;
         END LOOP;
         
         FOR i IN(SELECT DISTINCT a.no_of_takeup no_of_take
		         FROM gipi_invoice a, gipi_booking_hist b
				WHERE b.policy_id = a.policy_id
                  AND b.policy_id = p_policy_id
                  AND b.takeup_seq_no = a.takeup_seq_no
				  AND b.takeup_seq_no = p_takeup_seq_no)
	      LOOP
	         v_no_of_takeup := i.no_of_take;
	      END LOOP;
          
          IF v_no_of_takeup > 1 THEN
             BEGIN
                FOR i IN(SELECT old_booking_mm || ' ' ||old_booking_yy oldyear, old_reg_pol_sw, new_booking_mm || ' ' ||new_booking_yy newyear, new_reg_pol_sw, user_id, TO_CHAR(last_update, giisp.v('REP_DATE_FORMAT')) updt
						   FROM gipi_booking_hist
						  WHERE hist_no = v_list.hist_no
						    AND policy_id = p_policy_id
						    AND takeup_seq_no = p_takeup_seq_no
						    AND prem_seq_no = p_prem_seq_no)
	            LOOP
                   v_list.dsp_old_booking_mth_yy := i.oldyear;
                   v_list.old_r_pol_switch := i.old_reg_pol_sw;
                   v_list.dsp_new_booking_mth_yy := i.newyear;
                   v_list.new_r_pol_switch := i.new_reg_pol_sw;
                   v_list.dsp_user_id  := i.user_id;
                   v_list.dsp_last_update := i.updt;
	            END LOOP;
                
                FOR rec IN (SELECT a.iss_name iss_name
                              FROM giis_issource a, gipi_booking_hist b
                             WHERE b.hist_no = v_list.hist_no
                               AND a.iss_cd = v_list.old_cred_branch
                               AND policy_id = p_policy_id  
                               AND takeup_seq_no = p_takeup_seq_no
                               AND prem_seq_no = p_prem_seq_no)
                LOOP			
                   v_list.dsp_old_cred_branch := rec.iss_name;
                END LOOP;
                
                FOR x IN (select a.iss_name iss_name
							from giis_issource a, gipi_booking_hist b
						   where b.hist_no = v_List.hist_no
							 and a.iss_cd = v_list.NEW_CRED_BRANCH
							 AND policy_id = p_policy_id
							 AND takeup_seq_no = p_takeup_seq_no
							 AND prem_seq_no = p_prem_seq_no)
                LOOP
                   v_list.dsp_new_cred_branch := x.iss_name;
                END LOOP;
                
             END;
          ELSE
             BEGIN
                FOR i IN(SELECT old_booking_mm || ' ' ||old_booking_yy oldyear, old_reg_pol_sw, new_booking_mm || ' ' ||new_booking_yy newyear, new_reg_pol_sw, user_id, TO_CHAR(last_update, giisp.v('REP_DATE_FORMAT')) updt
                           FROM gipi_booking_hist
                          WHERE hist_no = v_list.hist_no
                            AND policy_id = p_policy_id)
                LOOP
                   v_list.dsp_old_booking_mth_yy := i.oldyear;
                   v_list.old_r_pol_switch := i.old_reg_pol_sw;
                   v_list.dsp_new_booking_mth_yy := i.newyear;
                   v_list.new_r_pol_switch := i.new_reg_pol_sw;
                   v_list.dsp_user_id := i.user_id;
                   v_list.dsp_last_update := i.updt;
                END LOOP;
                
                FOR rec IN (SELECT a.iss_name iss_name
                              FROM giis_issource a, gipi_booking_hist b
                             WHERE b.hist_no = v_list.hist_no
                               AND a.iss_cd = v_list.OLD_CRED_BRANCH
                               AND policy_id = p_policy_id)
                LOOP			
                    v_list.dsp_old_cred_branch := rec.iss_name;
                END LOOP;
                
                FOR x IN (SELECT a.iss_name iss_name
							FROM giis_issource a, gipi_booking_hist b
						   WHERE b.hist_no = v_list.hist_no
						 	 AND a.iss_cd = v_list.new_cred_branch
							 AND policy_id = p_policy_id)
                LOOP
                   v_list.DSP_NEW_CRED_BRANCH := x.iss_name;
                END LOOP;
             END;   
          END IF;
         
         EXIT WHEN c%NOTFOUND;
         PIPE ROW(v_list);
              
      END LOOP;
      
      CLOSE c;
      
   END get_gipis156_booking_hist;  
   
   FUNCTION get_gipis156_banc_hist (
      p_policy_id   VARCHAR2
   )
      RETURN gipis156_banca_hist_tab PIPELINED
   IS
      v_list gipis156_banca_hist_type;
      v_tot NUMBER;
      v_counter NUMBER;
   BEGIN
   
      BEGIN
         SELECT COUNT(*)
           INTO v_tot
           FROM gipi_bancassurance_hist
          WHERE policy_id = p_policy_id;  
      END;
      
      v_counter := v_tot;
   
      FOR i IN REVERSE 1 .. v_tot
      LOOP
         SELECT hist_no, old_area, new_area, old_branch, new_branch,
                old_manager, new_manager, user_id, last_update
           INTO v_list.hist_no, v_list.old_area, v_list.new_area, v_list.old_branch, v_list.new_branch,
                v_list.old_manager, v_list.new_manager, v_list.user_id, v_list.last_update
           FROM gipi_bancassurance_hist    
          WHERE policy_id = p_policy_id
            AND hist_no = v_counter;
            
         BEGIN
            SELECT gs.area_desc, gb.branch_desc
              INTO v_list.dsp_area_desc_old, v_list.dsp_branch_desc_old
              FROM gipi_bancassurance_hist a, giis_banc_area gs,
                   giis_banc_branch gb
              WHERE policy_id = p_policy_id
                and gs.area_cd = a.old_area
                and gb.branch_cd = a.old_branch
                AND a.hist_no = v_counter;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.dsp_area_desc_old := NULL;
            v_list.dsp_branch_desc_old := NULL;          
         END;
         
         BEGIN
            SELECT gs.area_desc, gb.branch_desc
              INTO v_list.dsp_area_desc_new, v_list.dsp_branch_desc_new
              FROM gipi_bancassurance_hist a, giis_banc_area gs,
                   giis_banc_branch gb
             WHERE policy_id = p_policy_id
               AND gs.area_cd =  a.new_area
               AND gb.branch_cd = a.new_branch
               AND a.hist_no = v_counter;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.dsp_area_desc_new := NULL;
            v_list.dsp_branch_desc_new := NULL;       
         END;
         
         BEGIN
            SELECT NVL(a.payee_last_name,'')
                   || ','
                   || NVL(a.payee_first_name,'')
                   || ','
                   || NVL(a.payee_middle_name,'')manager_name
              INTO v_list.dsp_mgr_name_new     
              FROM giis_payees a, giis_banc_branch b
             WHERE b.branch_cd = v_list.new_branch
               AND a.payee_no = b.manager_cd
               AND a.payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS')
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.dsp_mgr_name_new := NULL;      
         END;
         
         BEGIN
            SELECT NVL(a.payee_last_name,'')
                   || ','
                   || NVL(a.payee_first_name,'')
                   || ','
                   || NVL(a.payee_middle_name,'')manager_name
              INTO v_list.dsp_mgr_name_old     
              FROM giis_payees a, giis_banc_branch b
             WHERE b.branch_cd = v_list.old_branch
               AND a.payee_no = b.manager_cd
               AND a.payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS');
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.dsp_mgr_name_old := NULL;      
         END;
            
         v_counter := v_counter - 1;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_gipis156_banc_hist;
   
   FUNCTION get_banc_area_lov
      RETURN gipis156_banc_area_tab PIPELINED
   IS
      v_list gipis156_banc_area_type;
   BEGIN
      FOR i IN (SELECT area_cd, area_desc
                  FROM giis_banc_area
              ORDER BY 1)
      LOOP
         v_list.area_cd := i.area_cd;
         v_list.area_desc := i.area_desc;
         PIPE ROW(v_list);
      END LOOP;
   END get_banc_area_lov;
   
   FUNCTION get_banc_branch_lov(
      p_area_cd VARCHAR2
   )
      RETURN gipis156_banc_branch_tab PIPELINED
   IS
      v_list gipis156_banc_branch_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_desc, manager_cd
                  FROM giis_banc_branch
                 WHERE area_cd = NVL(p_area_cd, area_cd)
              ORDER BY branch_cd)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_desc := i.branch_desc;
         v_list.manager_cd := i.manager_cd;
         
         IF v_list.manager_cd IS NOT NULL THEN
            BEGIN
               SELECT NVL(a.payee_last_name,'')
                      || ','
                      || NVL(a.payee_first_name,'')
                      || ','
                      || NVL(a.payee_middle_name,'')manager_name
                INTO v_list.manager_name      
                FROM giis_payees a, giis_banc_branch b
               WHERE b.branch_cd = v_list.branch_cd
                 AND a.payee_no = b.manager_cd
                 AND a.payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS');
              EXCEPTION WHEN NO_DATA_FOUND THEN
                 v_list.manager_name := NULL;   
              END;
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_banc_branch_lov;   
   
   FUNCTION get_iss_lov (
      p_line_cd VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN iss_tab PIPELINED
   IS
      v_list iss_type;
   BEGIN
      FOR i IN (SELECT iss_name, iss_cd
                  FROM giis_issource
                 WHERE cred_br_tag = 'Y'
                   AND check_user_per_iss_cd2(p_line_cd, iss_cd,'GIPIS156', p_user_id) = 1
              ORDER BY iss_name)
      LOOP
         v_list.iss_name := i.iss_name;
         v_list.iss_cd := i.iss_cd;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_iss_lov;
   
   PROCEDURE update_gipis156 (
      p_policy_id       VARCHAR2,
      p_cred_branch     VARCHAR2,
      p_booking_mth     VARCHAR2,
      p_booking_year    VARCHAR2,   
      p_reg_policy_sw   VARCHAR2,
      p_takeup_seq_no   VARCHAR2,
      p_area_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_manager_cd      VARCHAR2,
      p_no_of_takeup    OUT VARCHAR2
   )
   IS
      v_no_of_takeup		gipi_invoice.no_of_takeup%TYPE;
   BEGIN
      
      FOR i IN(SELECT DISTINCT a.no_of_takeup no_of_take
				 FROM gipi_invoice a
				WHERE a.policy_id = p_policy_id)
	  LOOP
	     v_no_of_takeup := i.no_of_take;
	  END LOOP;
      
      IF v_no_of_takeup = 1 THEN
	     UPDATE gipi_invoice
	        SET multi_booking_yy = p_booking_year,
	            multi_booking_mm = p_booking_mth
	 	  WHERE takeup_seq_no = p_TAKEUP_SEQ_NO
            AND policy_id = p_policy_id;
      END IF;
      
      p_no_of_takeup := NVL(v_no_of_takeup, 1);
      
      UPDATE gipi_polbasic
         SET cred_branch = p_cred_branch,
             booking_mth = p_booking_mth,
             booking_year = p_booking_year,
             reg_policy_sw = p_reg_policy_sw,
             area_cd = p_area_cd,
             branch_cd = p_branch_cd,
             manager_cd = manager_cd
       WHERE policy_id = p_policy_id;  
   
   END update_gipis156;
   
   FUNCTION val_area_cd (
      p_area_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_temp VARCHAR2(100);
   BEGIN
      BEGIN
         SELECT area_desc
           INTO v_temp      
           FROM giis_banc_area
          WHERE area_cd = p_area_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
      v_temp := 'NO DATA';
      END;
      RETURN v_temp;        
   END val_area_cd;  
   
   FUNCTION val_banc_branch_cd (
      p_area_cd   VARCHAR2,
      p_branch_cd VARCHAR2
   )
      RETURN gipis156_banc_branch_tab PIPELINED
   IS
      v_list gipis156_banc_branch_type;
   BEGIN
      BEGIN
         SELECT branch_cd, branch_desc, manager_cd
           INTO v_list.branch_cd, v_list.branch_desc, v_list.manager_cd
           FROM giis_banc_branch
          WHERE area_cd = NVL(p_area_cd, area_cd)
            AND branch_cd = p_branch_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.branch_cd := NULL;
         v_list.branch_desc := 'NO DATA';
         v_list.manager_cd := NULL;      
      END;
     
      IF v_list.manager_cd IS NOT NULL THEN
         BEGIN
            SELECT NVL(a.payee_last_name,'')
                   || ','
                   || NVL(a.payee_first_name,'')
                   || ','
                   || NVL(a.payee_middle_name,'')manager_name
             INTO v_list.manager_name      
             FROM giis_payees a, giis_banc_branch b
            WHERE b.branch_cd = v_list.branch_cd
              AND a.payee_no = b.manager_cd
              AND a.payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS');
           EXCEPTION WHEN NO_DATA_FOUND THEN
              v_list.manager_name := NULL;   
           END;
      END IF;
      PIPE ROW(v_list);
   END;
   
   PROCEDURE update_gipis156_invoice(
      p_policy_id          VARCHAR2,
      p_iss_cd             VARCHAR2,
      p_prem_seq_no        VARCHAR2,
      p_multi_booking_yy   VARCHAR2,
      p_multi_booking_mm   VARCHAR2   
    )
    IS
    BEGIN
      
       UPDATE gipi_invoice
          SET multi_booking_yy = p_multi_booking_yy,
              multi_booking_mm = p_multi_booking_mm
        WHERE policy_id = p_policy_id
          AND iss_cd = p_iss_cd
          AND prem_seq_no = p_prem_seq_no;       
          
    
    END update_gipis156_invoice;
    
    -- apollo 08.06.2015 - SR#19928 - to update booking dates in gipi_polbasic
    PROCEDURE update_polbasic_booking_date (p_policy_id VARCHAR2)
    IS
       v_booking_mth    gipi_polbasic.booking_mth%TYPE;  
       v_booking_year   gipi_polbasic.booking_year%TYPE;
    BEGIN
       
       SELECT multi_booking_mm, multi_booking_yy
         INTO v_booking_mth, v_booking_year
         FROM gipi_invoice
        WHERE policy_id = p_policy_id
          AND NVL(takeup_seq_no, 1) = 1
          AND item_grp = 1;
       
       UPDATE gipi_polbasic
         SET booking_mth = v_booking_mth,
             booking_year = v_booking_year
       WHERE policy_id = p_policy_id;            
           
    END update_polbasic_booking_date;        

END;
/



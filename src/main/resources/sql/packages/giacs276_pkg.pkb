CREATE OR REPLACE PACKAGE BODY CPI.GIACS276_PKG
AS

    PROCEDURE check_last_extract(
        p_comm      NUMBER,
        p_from_date DATE, 
        p_to_date   DATE,
        p_line_cd   VARCHAR2,
        p_alert_out OUT VARCHAR2   
    )
    IS
    v_line_count               NUMBER;
    v_to_extract_count         NUMBER;
    v_to_extract_from_date     DATE;
    v_to_extract_to_date       DATE;
    v_extracted_count          NUMBER;
    v_extracted_from_date      DATE;
    v_extracted_to_date        DATE;
    v_extracted_line_cd        VARCHAR2(2);

    BEGIN
        IF p_comm = 1 THEN

             SELECT count(DISTINCT line_cd)
                 INTO v_line_count
                FROM giac_comm_income_ext
               WHERE user_id = USER;
     
            IF v_line_count = 0 THEN
                RETURN;
            ELSIF v_line_count = 1 THEN
                SELECT DISTINCT line_cd
                     INTO v_extracted_line_cd
                    FROM giac_comm_income_ext
                    WHERE user_id = USER;
            ELSE
                v_extracted_line_cd := NULL;
            END IF;    
        
            SELECT MIN(acct_ent_date) from_date, 
                      MAX(acct_ent_date) to_date
              INTO v_extracted_from_date,
                   v_extracted_to_date
                FROM giac_comm_income_ext
              WHERE user_id = USER;

            SELECT count(*), MIN(acct_ent_date), MAX(acct_ent_date)
                INTO v_to_extract_count, v_to_extract_from_date, v_to_extract_to_date
                 FROM(SELECT a.policy_id, b.peril_cd, c.acct_ent_date
                         FROM gipi_polbasic a,
                                  gipi_itmperil b,
                                 giuw_pol_dist c
                       WHERE a.policy_id = b.policy_id
                         AND a.policy_id = c.policy_id
                          AND a.pol_flag != '5'
                         AND c.acct_ent_date BETWEEN p_from_date AND p_to_date
                         AND a.line_cd = nvl(p_line_cd, a.line_cd)
                       GROUP BY a.policy_id, 
                                  c.acct_ent_date,
                                  b.peril_cd);

            IF v_extracted_from_date <= v_to_extract_from_date AND
                 v_extracted_to_date >= v_to_extract_to_date AND
                 nvl(p_line_cd, 'X') = nvl(v_extracted_line_cd, nvl(p_line_cd, 'X')) THEN

                SELECT count(*)
                    INTO v_extracted_count
                    FROM giac_comm_income_ext
                 WHERE acct_ent_date BETWEEN p_from_date AND p_to_date
                      AND line_cd = nvl(p_line_cd, line_cd)
                     AND user_id = USER;
                         
                /*IF v_to_extract_count = v_extracted_count THEN
                   BEGIN 
                       p_alert_out := 'EXTRACT_AGAIN'; 
                      IF alert_button = alert_button1 THEN
                          RETURN; 
                      ELSIF alert_button = alert_button2 THEN 
                                RAISE form_trigger_failure;                  
                      END IF;
                     END;    
                END IF;*/
            END IF;                 

        ELSIF p_comm = 2 THEN

             SELECT count(DISTINCT line_cd)
                 INTO v_line_count
                FROM giac_comm_expense_ext
               WHERE user_id = USER;
     
            IF v_line_count = 0 THEN
                RETURN;
            ELSIF v_line_count = 1 THEN
                SELECT DISTINCT line_cd
                     INTO v_extracted_line_cd
                    FROM giac_comm_expense_ext
                  WHERE user_id = USER;
            ELSE
                v_extracted_line_cd := NULL;
            END IF;    
        
            SELECT MIN(acct_ent_date) from_date, 
                      MAX(acct_ent_date) to_date
              INTO v_extracted_from_date,
                   v_extracted_to_date
                FROM giac_comm_expense_ext
              WHERE user_id = USER;
           
            SELECT count(*), MIN(acct_ent_date), MAX(acct_ent_date)
                INTO v_to_extract_count, v_to_extract_from_date, v_to_extract_to_date
                FROM (SELECT a.policy_id, a.acct_ent_date,    d.peril_cd
                                 FROM gipi_polbasic a,
                                         gipi_comm_invoice c,
                                         gipi_comm_inv_peril d
                             WHERE a.policy_id = c.policy_id
                                  AND c.iss_cd    = d.iss_cd
                                 AND c.prem_seq_no = d.prem_seq_no
                                 AND a.pol_flag != '5'
                                 AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                                 AND a.policy_id > 0
                                 AND a.line_cd = nvl(p_line_cd, a.line_cd)
                             GROUP BY a.policy_id, a.acct_ent_date, d.peril_cd
                          UNION
                             SELECT a.policy_id, a.acct_ent_date, c.peril_cd
                                FROM gipi_polbasic a,
                                         gipi_itmperil c
                             WHERE a.policy_id = c.policy_id
                                 AND a.pol_flag != '5'
                                 AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                                 AND a.iss_cd = 'RI'
                                 AND a.line_cd = nvl(p_line_cd, a.line_cd)
                             GROUP BY a.policy_id, a.acct_ent_date, c.peril_cd);

            IF v_extracted_from_date <= v_to_extract_from_date AND
                 v_extracted_to_date >= v_to_extract_to_date AND
                 nvl(p_line_cd, 'X') = nvl(v_extracted_line_cd, nvl(p_line_cd, 'X')) THEN
                     
                SELECT count(*)
                    INTO v_extracted_count
                    FROM giac_comm_expense_ext
                 WHERE acct_ent_date BETWEEN p_from_date AND p_to_date
                      AND line_cd = nvl(p_line_cd, line_cd)
                     AND user_id = USER;

               /* IF v_to_extract_count = v_extracted_count THEN
                    DECLARE 
                     alert_button     NUMBER; 
                   BEGIN 
                       alert_button := show_alert('EXTRACT_AGAIN'); 
                    IF alert_button = alert_button1 THEN
                      RETURN; 
                    ELSIF alert_button = alert_button2 THEN 
                            RAISE form_trigger_failure;      			
                    END IF;
                    END;
                END IF;*/
            END IF;			 	

        END IF;	
   END;	
   
   PROCEDURE ext_comm_income (
         p_from_date         DATE, 
         p_to_date           DATE,
         p_line_cd           VARCHAR2,
         p_user          IN  giac_redist_binders_ext.USER_ID%type,
         --p_message       OUT VARCHAR2,
         p_rec_extracted OUT NUMBER,
         p_iss               NUMBER
   )
   IS
        v_count                     NUMBER;
        v_row_counter               NUMBER:=0;
        v_policy_id                 giac_comm_income_ext.policy_id%TYPE;
        v_assd_no                   giac_comm_income_ext.assd_no%TYPE;
        v_incept_date               giac_comm_income_ext.incept_date%TYPE;
        v_acct_ent_date             giac_comm_income_ext.acct_ent_date%TYPE;
        v_peril_cd                  giac_comm_income_ext.peril_cd%TYPE;
        v_total_prem_amt            giac_comm_income_ext.total_prem_amt%TYPE;
        v_line_cd                   giac_comm_income_ext.line_cd%TYPE;
        v_iss_cd                    giac_comm_income_ext.iss_cd%TYPE;
        v_cred_branch               giac_comm_income_ext.cred_branch%TYPE;
        v_nr_prem_amt               giac_comm_income_ext.nr_prem_amt%TYPE;
        v_facul_prem                giac_comm_income_ext.facul_prem%TYPE;
        v_facul_comm                giac_comm_income_ext.facul_comm%TYPE;
        v_treaty1_prem              giac_comm_income_ext.treaty1_prem%TYPE;
        v_treaty1_comm              giac_comm_income_ext.treaty1_comm%TYPE;
        v_treaty2_prem              giac_comm_income_ext.treaty2_prem%TYPE;
        v_treaty2_comm              giac_comm_income_ext.treaty2_comm%TYPE;
        v_treaty3_prem              giac_comm_income_ext.treaty3_prem%TYPE;
        v_treaty3_comm              giac_comm_income_ext.treaty3_comm%TYPE;
        v_treaty4_prem              giac_comm_income_ext.treaty4_prem%TYPE;
        v_treaty4_comm              giac_comm_income_ext.treaty4_comm%TYPE;
        v_treaty5_prem              giac_comm_income_ext.treaty5_prem%TYPE;
        v_treaty5_comm              giac_comm_income_ext.treaty5_comm%TYPE;
        v_treaty6_prem              giac_comm_income_ext.treaty6_prem%TYPE;
        v_treaty6_comm              giac_comm_income_ext.treaty6_comm%TYPE;
        v_treaty7_prem              giac_comm_income_ext.treaty7_prem%TYPE;
        v_treaty7_comm              giac_comm_income_ext.treaty7_comm%TYPE;
        v_treaty8_prem              giac_comm_income_ext.treaty8_prem%TYPE;
        v_treaty8_comm              giac_comm_income_ext.treaty8_comm%TYPE;
        v_trty1_acct_type           giac_comm_income_ext.trty1_acct_type%TYPE;
        v_trty2_acct_type           giac_comm_income_ext.trty2_acct_type%TYPE;
        v_trty3_acct_type           giac_comm_income_ext.trty3_acct_type%TYPE;
        v_trty4_acct_type           giac_comm_income_ext.trty4_acct_type%TYPE;
        v_trty5_acct_type           giac_comm_income_ext.trty5_acct_type%TYPE;
        v_trty6_acct_type           giac_comm_income_ext.trty6_acct_type%TYPE;
        v_trty7_acct_type           giac_comm_income_ext.trty7_acct_type%TYPE;
        v_trty8_acct_type           giac_comm_income_ext.trty8_acct_type%TYPE;
        v_nr_share                  NUMBER := 0;   /*--Gzelle 09282015 SR18792--*/ 
		v_treaty_prem               giac_comm_income_ext.treaty1_prem%TYPE;  --Deo [02.27.2017]: SR-5865
    BEGIN
        DELETE FROM giac_comm_income_ext
         WHERE user_id = p_user;
         COMMIT;

        FOR rec IN (SELECT /*+ INDEX (a polbasic_pk) INDEX (b parlist_pk) */  --Deo [02.27.2017]: added hints (SR-5865)
        				   a.policy_id, 
                           b.assd_no, 
                           a.incept_date, 
                           d.acct_ent_date,
                           c.peril_cd, 
                           a.line_cd, 
                           a.iss_cd,
                           a.cred_branch
                    FROM gipi_polbasic a,
                         gipi_parlist b,
                         gipi_itmperil c,
                         giuw_pol_dist d
                         , (SELECT branch_cd
                              FROM TABLE (security_access.get_branch_line ('AC',
                                                                           'GIACS276',
                                                                           p_user
                                                                        )
                                         )) f --Deo [02.27.2017]: SR-5865
                    WHERE a.par_id = b.par_id
                      AND a.policy_id = c.policy_id
                      AND a.policy_id = d.policy_id
                      --AND a.pol_flag != '5' --Deo [02.27.2017]: modified condition for excluding spoiled policies (SR-5865)
                      AND (   a.pol_flag != '5'
                           OR (    a.pol_flag = '5'
                               AND NVL (a.spld_acct_ent_date, TRUNC (a.spld_date)) > p_to_date
                              )
                          )
                      --end Deo [02.27.2017]
                      AND d.acct_ent_date BETWEEN p_from_date AND p_to_date
                      AND a.line_cd = nvl(p_line_cd, a.line_cd)
                      --AND check_user_per_line2(p_line_cd, a.iss_cd, 'GIACS276', p_user) = 1
                      --AND check_user_per_iss_cd2(a.line_cd, DECODE(p_iss, 1,a.cred_branch, 2, a.iss_cd), 'GIACS276', p_user) = 1 	--changed to GIACS276 Gzelle 10192015 SR18729  --Deo [02.27.2017]: comment out (SR-5865)
                      --AND check_user_per_iss_cd2(p_line_cd, a.cred_branch, 'GIACS276', p_user) = 1
                      --Deo [02.27.2017]: add start (SR-5865)
                      AND (   d.dist_flag = '3'
                           OR (    d.dist_flag IN ('4', '5')
                               AND d.acct_ent_date IN (
                                      SELECT MAX (acct_ent_date)
                                        FROM giuw_pol_dist
                                       WHERE policy_id = a.policy_id
                                         AND acct_ent_date BETWEEN p_from_date AND p_to_date)
                              )
                          )
                      AND a.par_id = d.par_id
                      AND b.par_id = d.par_id
                      AND f.branch_cd = DECODE (p_iss, 1, a.cred_branch, 2, a.iss_cd)
                      --Deo [02.27.2017]: add ends (SR-5865)
                    GROUP BY a.policy_id, 
                             b.assd_no, 
                             a.incept_date, 
                             d.acct_ent_date,
                             c.peril_cd, 
                             a.line_cd, 
                             a.iss_cd,
                             a.cred_branch
                   )
        LOOP--main loop 
            v_policy_id     := rec.policy_id;                
            v_assd_no       := rec.assd_no;                                    
            v_incept_date   := rec.incept_date;                            
            v_acct_ent_date := rec.acct_ent_date;                        
            v_peril_cd      := rec.peril_cd;                                                                    
            v_line_cd       := rec.line_cd;                                    
            v_iss_cd        := rec.iss_cd;
            v_cred_branch   := rec.cred_branch;
            --reset amounts
            v_total_prem_amt:= NULL;
            v_nr_prem_amt   := NULL;        
            v_facul_prem    := 0 /*NULL*/; --Deo [02.27.2017]: replace null with 0 (SR-5865)
            v_facul_comm    := 0 /*NULL*/; --Deo [02.27.2017]: replace null with 0 (SR-5865)
            v_treaty1_prem  := NULL;
            v_treaty1_comm  := NULL;
            v_trty1_acct_type := NULL;    
            v_treaty2_prem    := NULL;
            v_treaty2_comm    := NULL;
            v_trty2_acct_type := NULL;    
            v_treaty3_prem    := NULL;
            v_treaty3_comm    := NULL;
            v_trty3_acct_type := NULL;    
            v_treaty4_prem    := NULL;
            v_treaty4_comm    := NULL;
            v_trty4_acct_type := NULL;    
            v_treaty5_prem    := NULL;
            v_treaty5_comm    := NULL;
            v_trty5_acct_type := NULL;    
            v_treaty6_prem    := NULL;
            v_treaty6_comm    := NULL;
            v_trty6_acct_type := NULL;    
            v_treaty7_prem    := NULL;
            v_treaty7_comm    := NULL;
            v_trty7_acct_type := NULL;    
            v_treaty8_prem    := NULL;
            v_treaty8_comm    := NULL;
            v_trty8_acct_type := NULL;    
            v_treaty_prem     := 0; --Deo [02.27.2017]: SR-5865

            /*--premium  --Deo [02.27.2017]: comment out starts (SR-5865)
            FOR vfm IN (SELECT SUM(a.prem_amt) total_prem_amt 
                                      FROM gipi_itmperil a
                                   WHERE a.policy_id = rec.policy_id
                                           AND a.peril_cd = rec.peril_cd
                                          AND EXISTS (SELECT 'X'
                                                             FROM gipi_polbasic x
                                                                    WHERE x.policy_id = rec.policy_id
                                                                    AND x.pol_flag != '5'
                                                                    AND x.acct_ent_date = rec.acct_ent_date
                                                                    --AND check_user_per_iss_cd(rec.line_cd,rec.cred_branch,'GIACS276')=1
                                                                    --AND check_user_per_iss_cd(rec.line_cd,rec.iss_cd,'GIACS276')=1
                                                                    AND x.policy_id > 0) 
                                    )
            LOOP
                v_total_prem_amt := vfm.total_prem_amt;
                EXIT;
            END LOOP;		 						 	 
            --retention		
            FOR rec1 IN (SELECT SUM(b.dist_prem) nr_prem_amt, b.dist_spct   /*--Gzelle 09282015 SR18792--*   
                                         FROM giuw_pol_dist a,
                                              giuw_perilds_dtl b, 
                                              giis_dist_share c
                                        WHERE 1=1
                                            AND a.policy_id = rec.policy_id	
                                            AND a.dist_no = b.dist_no
                                            AND b.share_cd = c.share_cd
                                            AND b.line_cd = c.line_cd
                                            AND b.peril_cd = rec.peril_cd
                                            ANd a.acct_ent_date = rec.acct_ent_date
                                            AND c.share_type = 1
                                            AND EXISTS (SELECT 'X'
                                                                FROM gipi_polbasic x
                                                                     WHERE x.policy_id = rec.policy_id
                                                                       AND x.pol_flag != '5'
                                                                       --AND check_user_per_iss_cd(rec.line_cd,rec.cred_branch,'GIACS276')=1
                                                                       --AND check_user_per_iss_cd(rec.line_cd,rec.iss_cd,'GIACS276')=1
                                                                       AND x.acct_ent_date = rec.acct_ent_date
                                                                       AND x.policy_id > 0) 
                                         GROUP BY b.dist_spct)  /*--Gzelle 09282015 SR18792--* 
            LOOP
                v_nr_prem_amt	:= rec1.nr_prem_amt;
                v_nr_share      := rec1.dist_spct;  /*--Gzelle 09282015 SR18792--* 
                EXIT;
            END LOOP;*/  --Deo [02.27.2017]: comment out ends (SR-5865)
    	 	
            --Deo [02.27.2017]: add start, replace codes commented out above to handle redistribution and convert amount to local (SR-5865)
            FOR rec1 IN (SELECT SUM (b.dist_prem * f.currency_rt) prem_amt,
                                SUM (  DECODE (c.share_type, 1, b.dist_prem, 0)
                                     * f.currency_rt
                                    ) nr_prem_amt
                           FROM giuw_pol_dist a,
                                giuw_perilds_dtl b,
                                giis_dist_share c,
                                giuw_policyds d,
                                giuw_policyds_dtl e,
                                gipi_invoice f
                          WHERE a.policy_id = rec.policy_id
                            AND a.dist_no = b.dist_no
                            AND b.share_cd = c.share_cd
                            AND b.line_cd = c.line_cd
                            AND b.peril_cd = rec.peril_cd
                            AND a.acct_ent_date = rec.acct_ent_date
                            AND a.dist_no = d.dist_no
                            AND b.dist_seq_no = d.dist_seq_no
                            AND d.dist_no = e.dist_no
                            AND d.dist_seq_no = e.dist_seq_no
                            AND b.share_cd = e.share_cd
                            AND a.policy_id = f.policy_id
                            AND d.item_grp = f.item_grp)
            LOOP
               v_total_prem_amt := rec1.prem_amt;
               v_nr_prem_amt := rec1.nr_prem_amt;
            END LOOP;
            
            IF v_nr_prem_amt <> v_total_prem_amt
            THEN
            --Deo [02.27.2017]: add ends (SR-5865)
            --facultative
            FOR rec2 IN ( SELECT SUM(c.ri_prem_amt) * b.currency_rt facul_prem,  --Deo [02.27.2017]: added * b.currency_rt (SR-5865)
                                                     SUM(c.ri_comm_amt) * b.currency_rt facul_comm  --Deo [02.27.2017]: added * b.currency_rt (SR-5865)
                                            FROM giuw_pol_dist a,
                                                 giri_distfrps b, 
                                                 giri_frperil c,
                                                 giri_frps_ri d,
                                                 giri_binder e
                                         WHERE 1=1
                                             AND a.policy_id = rec.policy_id	
                                             AND a.dist_no = b.dist_no
                                             AND b.line_cd = c.line_cd
                                             AND b.frps_yy = c.frps_yy
                                             AND b.frps_seq_no = c.frps_seq_no
                                             AND c.line_cd = d.line_cd
                                             AND c.frps_yy = d.frps_yy
                                             AND c.frps_seq_no = d.frps_seq_no								 
                                             AND c.ri_seq_no = d.ri_seq_no
                                             AND d.fnl_binder_id = e.fnl_binder_id
                                             AND c.peril_cd = rec.peril_cd
                                             AND a.acct_ent_date = rec.acct_ent_date --start Gzelle 09282015 SR18792-- 
                                             --AND e.acc_ent_date = rec.acct_ent_date 
                                             AND e.acc_ent_date = a.acct_ent_date       /*--start Gzelle 09282015 SR18792--*/ 
                                        GROUP BY b.currency_rt --Deo [02.27.2017]: SR-5865
                                             )
            LOOP	 									 
                v_facul_prem := rec2.facul_prem + v_facul_prem; --Deo [02.27.2017]: added + v_facul_prem (SR-5865)
                v_facul_comm := rec2.facul_comm + v_facul_comm; --Deo [02.27.2017]: added + v_facul_comm (SR-5865)
                --EXIT;  --Deo [02.27.2017]: comment out (SR-5865)
            END LOOP;

            --treaty		
            FOR rec3 IN (SELECT /*+ RULE*/ SUM(b.premium_amt) treaty_prem, 
                                                    SUM(b.commission_amt) treaty_comm,
                                                    d.ca_trty_type
                                         FROM giis_ca_trty_type d,
                                              giis_dist_share c,
                                              giac_treaty_cession_dtl b,
                                              giac_treaty_cessions a
                                        WHERE 1=1
                                            AND a.policy_id = rec.policy_id	
                                            AND a.cession_id = b.cession_id
                                            AND a.share_cd = c.share_cd
                                            AND a.line_cd = c.line_cd
                                            AND b.peril_cd = rec.peril_cd
                                            AND a.acct_ent_date = rec.acct_ent_date
                                            AND c.acct_trty_type = d.ca_trty_type
                                            AND c.share_type NOT IN (1,3)
                                            AND a.take_up_type = 'P' --Deo [02.27.2017]: SR-5865
                                      GROUP BY d.ca_trty_type)
            LOOP
                IF rec3.ca_trty_type = 1 THEN			
                    v_treaty1_prem 		:= rec3.treaty_prem;
                    v_treaty1_comm 		:= rec3.treaty_comm;
                    v_trty1_acct_type	:= rec3.ca_trty_type;	
                ELSIF	rec3.ca_trty_type = 2 THEN			
                    v_treaty2_prem := rec3.treaty_prem;
                    v_treaty2_comm := rec3.treaty_comm;
                    v_trty2_acct_type	:= rec3.ca_trty_type;	
                ELSIF	rec3.ca_trty_type = 3 THEN			
                    v_treaty3_prem := rec3.treaty_prem;
                    v_treaty3_comm := rec3.treaty_comm;
                    v_trty3_acct_type	:= rec3.ca_trty_type;		
                ELSIF	rec3.ca_trty_type = 4 THEN			
                    v_treaty4_prem := rec3.treaty_prem;
                    v_treaty4_comm := rec3.treaty_comm;
                    v_trty4_acct_type	:= rec3.ca_trty_type;		
                ELSIF	rec3.ca_trty_type = 5 THEN			
                    v_treaty5_prem := rec3.treaty_prem;
                    v_treaty5_comm := rec3.treaty_comm;
                    v_trty5_acct_type	:= rec3.ca_trty_type;		
                ELSIF	rec3.ca_trty_type = 6 THEN			
                    v_treaty6_prem := rec3.treaty_prem;
                    v_treaty6_comm := rec3.treaty_comm;
                    v_trty6_acct_type	:= rec3.ca_trty_type;		
                ELSIF	rec3.ca_trty_type = 7 THEN			
                    v_treaty7_prem := rec3.treaty_prem;
                    v_treaty7_comm := rec3.treaty_comm;
                    v_trty7_acct_type	:= rec3.ca_trty_type;		
                ELSIF	rec3.ca_trty_type = 8 THEN			
                    v_treaty8_prem := rec3.treaty_prem;
                    v_treaty8_comm := rec3.treaty_comm;
                    v_trty8_acct_type	:= rec3.ca_trty_type;	
                END IF;	
                v_treaty_prem := rec3.treaty_prem + v_treaty_prem;  --Deo [02.27.2017]: SR-5865
            END LOOP;
            
            END IF; --Deo [02.27.2017]: close if (SR-5865)
            
            --IF v_nr_share <> 100 THEN   /*--Gzelle 09282015 SR18792--*/  --Deo [02.27.2017]: comment out (SR-5865)
            IF NVL (v_facul_prem, 0) <> 0 OR NVL (v_treaty_prem, 0) <> 0 THEN --Deo [02.27.2017]: SR-5865
            v_row_counter := v_row_counter + 1;

            INSERT INTO giac_comm_income_ext
                (
                 policy_id,					assd_no, 					incept_date, 			acct_ent_date, 
                 peril_cd, 					total_prem_amt,	 			line_cd, 				iss_cd, 
                 nr_prem_amt, 				treaty1_prem, 				treaty1_comm, 			trty1_acct_type,
                 treaty2_prem, 				treaty2_comm, 				trty2_acct_type,		treaty3_prem, 			
                 treaty3_comm,	 			trty3_acct_type,			treaty4_prem,		 	treaty4_comm,  		
                 trty4_acct_type,			treaty5_prem, 				treaty5_comm, 			trty5_acct_type,
                 treaty6_prem,				treaty6_comm,				trty6_acct_type,	    treaty7_prem,
                 treaty7_comm, 		  	    trty7_acct_type,			treaty8_prem,     	    treaty8_comm,
                 trty8_acct_type,			facul_prem, 				facul_comm,			    user_id,
                 last_update,               cred_branch,                 param_from_date,        param_to_date,   --added param_from_date and param_to_date -> Gzelle 09212015 SR18729
                 param_line_cd 
                 )
                VALUES
                (
                 v_policy_id,				v_assd_no, 					v_incept_date,			v_acct_ent_date, 
                 v_peril_cd, 				v_total_prem_amt,			v_line_cd,				v_iss_cd, 
                 v_nr_prem_amt,				v_treaty1_prem, 			v_treaty1_comm, 		v_trty1_acct_type,
                 v_treaty2_prem, 			v_treaty2_comm, 			v_trty2_acct_type,	    v_treaty3_prem, 		
                 v_treaty3_comm,			v_trty3_acct_type,		    v_treaty4_prem, 		v_treaty4_comm,
                 v_trty4_acct_type, 	    v_treaty5_prem, 			v_treaty5_comm, 		v_trty5_acct_type,
                 v_treaty6_prem, 			v_treaty6_comm,				v_trty6_acct_type,	    v_treaty7_prem, 			
                 v_treaty7_comm, 			v_trty7_acct_type,		    v_treaty8_prem, 		v_treaty8_comm,			
                 v_trty8_acct_type,		    v_facul_prem, 				v_facul_comm, 			p_user,
                 SYSDATE,					v_cred_branch,               p_from_date,            p_to_date,       --added param_from_date and param_to_date -> Gzelle 09212015 SR18729 
                 p_line_cd  
                );
            END IF;                     /*--Gzelle 09282015 SR18792--*/ 
        END LOOP;--end main loop
    	
        /*IF v_row_counter = 0 THEN 
            p_rec_extracted := v_row_counter;
            --p_message := 'There were 0 records extracted for the dates specified.';
        ELSE
            p_rec_extracted := v_row_counter;
            --p_message := 'Extraction finished! '||to_char(v_row_counter)|| ' records extracted.';
        END IF;*/  --Deo [02.27.2017]: comment out (SR-5865)
        p_rec_extracted := v_row_counter;
    END;
    
    PROCEDURE ext_comm_expense(
         p_from_date         DATE, 
         p_to_date           DATE,
         p_line_cd           VARCHAR2,
         p_user          IN  giac_redist_binders_ext.USER_ID%type,
         --p_message       OUT VARCHAR2,
         p_rec_extracted OUT NUMBER,
         p_iss               NUMBER
    ) 
    IS
	     v_row_counter		NUMBER := 0;  --Deo [02.27.2017]: add initialize to 0 (SR-5865)
          TYPE policy_id_tab            IS TABLE OF gipi_polbasic.policy_id%TYPE;
          TYPE assd_no_tab              IS TABLE OF gipi_parlist.assd_no%TYPE;
          TYPE incept_date_tab          IS TABLE OF gipi_polbasic.incept_date%TYPE;
          TYPE acct_ent_date_tab        IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
          TYPE peril_cd_tab             IS TABLE OF gipi_comm_inv_peril.peril_cd%TYPE;
          TYPE premium_amt_tab          IS TABLE OF gipi_comm_inv_peril.premium_amt%TYPE;
          TYPE commission_amt_tab       IS TABLE OF gipi_comm_inv_peril.commission_amt%TYPE;
          TYPE line_cd_tab              IS TABLE OF gipi_polbasic.line_cd%TYPE;
          TYPE iss_cd_tab               IS TABLE OF gipi_polbasic.iss_cd%TYPE;
          TYPE cred_branch_tab          IS TABLE OF gipi_polbasic.cred_branch%TYPE;
          vv_policy_id                  policy_id_tab;
          vv_assd_no                    assd_no_tab;
          vv_incept_date                incept_date_tab;
          vv_acct_ent_date              acct_ent_date_tab;
          vv_peril_cd                   peril_cd_tab;
          vv_premium_amt                premium_amt_tab;
          vv_commission_amt             commission_amt_tab;
          vv_line_cd                    line_cd_tab;
          vv_iss_cd                     iss_cd_tab;
          vv_cred_branch                cred_branch_tab;
          v_ri_iss_cd                   giis_parameters.param_value_v%TYPE := NVL (giisp.v ('ISS_CD_RI'), 'RI'); --Deo [02.27.2017]: SR-5865
    BEGIN	
	    --extract_comm_expense(p_from_date, p_to_date, p_line_cd, USER);--database procedure
        
        --delete records for the specified user
          DELETE FROM giac_comm_expense_ext
           WHERE user_id = p_user;
          COMMIT;
          --retrieve/extract records
          SELECT policy_id, assd_no, incept_date, acct_ent_date,
                 peril_cd, premium_amt,  commission_amt, line_cd, iss_cd, cred_branch
          BULK COLLECT
            INTO vv_policy_id,
                 vv_assd_no,
                 vv_incept_date,
                 vv_acct_ent_date,
                 vv_peril_cd,
                 vv_premium_amt,
                 vv_commission_amt,
                 vv_line_cd,
                 vv_iss_cd,
                 vv_cred_branch
            FROM (/*  --Deo [02.27.2017]: comment out starts (SR-5865)
            	  SELECT a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                         d.peril_cd, sum(d.premium_amt) premium_amt, sum(d.commission_amt) commission_amt,
                         a.line_cd, a.iss_cd,
                         a.cred_branch
                    FROM gipi_polbasic a,
                         gipi_parlist b,
                         gipi_comm_invoice c,
                         gipi_comm_inv_peril d
                   WHERE a.policy_id = c.policy_id
                     AND c.iss_cd	= d.iss_cd
                     AND c.prem_seq_no = d.prem_seq_no
                     AND a.par_id = b.par_id
                     --AND check_user_per_line2(p_line_cd, a.iss_cd, 'GIACS276', p_user) = 1
                     AND check_user_per_iss_cd2(a.line_cd, DECODE(p_iss, 1,a.cred_branch, 2, a.iss_cd), 'GIACS276', p_user) = 1	--changed to GIACS276 Gzelle 10192015 SR18729
                     --AND check_user_per_iss_cd2(p_line_cd, a.cred_branch, 'GIACS276', p_user) = 1
                     AND a.pol_flag != '5'
                     AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                     AND a.policy_id > 0
                     AND a.line_cd = nvl(p_line_cd, a.line_cd)
                   GROUP BY a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                         d.peril_cd, a.line_cd, a.iss_cd, a.cred_branch
                   UNION
                  SELECT a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                         c.peril_cd, sum(c.prem_amt), sum(c.ri_comm_amt), a.line_cd, a.iss_cd,
                         a.cred_branch
                    FROM gipi_polbasic a,
                         gipi_parlist b,
                         gipi_itmperil c
                   WHERE a.policy_id = c.policy_id
                     AND a.par_id = b.par_id
                     AND a.pol_flag != '5'
                     AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                     --AND check_user_per_line2(p_line_cd, a.iss_cd, 'GIACS276', p_user) = 1
                     AND check_user_per_iss_cd2(a.line_cd, DECODE(p_iss, 1,a.cred_branch, 2, a.iss_cd), 'GIACS276', p_user) = 1	--changed to GIACS276 Gzelle 10192015 SR18729
                     --AND check_user_per_iss_cd2(p_line_cd, a.cred_branch, 'GIACS276', p_user) = 1
                     AND a.iss_cd = 'RI'
                     AND a.line_cd = nvl(p_line_cd, a.line_cd)
                   GROUP BY a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                         c.peril_cd, a.line_cd, a.iss_cd, a.cred_branch);*/  --Deo [02.27.2017]: comment out ends (SR-5865)
                  --Deo [02.27.2017]: add start (SR-5865)
                  SELECT   policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
                           SUM (prem_amt) premium_amt, SUM (ri_comm_amt) commission_amt, line_cd,
                           iss_cd, cred_branch
                      FROM (SELECT a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                                   d.peril_cd, d.item_no, a.line_cd, a.iss_cd, a.cred_branch,
                                   d.prem_amt * c.currency_rt prem_amt,
                                     (SELECT k.old_ri_comm_amt
                                        FROM gipi_itmperil_ri_comm_hist k
                                       WHERE k.policy_id = a.policy_id
                                         AND k.item_no = d.item_no
                                         AND k.peril_cd = d.peril_cd
                                         AND k.tran_id IN (
                                                SELECT MIN (n.tran_id)
                                                  FROM gipi_itmperil_ri_comm_hist n
                                                 WHERE n.policy_id = a.policy_id
                                                   AND n.item_no = d.item_no
                                                   AND n.peril_cd = d.peril_cd
                                                   AND n.acct_ent_date <= p_to_date
                                                   AND TRUNC (n.post_date) > p_to_date)
                                      UNION ALL
                                      SELECT z.ri_comm_amt
                                        FROM gipi_itmperil z
                                       WHERE z.policy_id = a.policy_id
                                         AND z.item_no = d.item_no
                                         AND z.peril_cd = d.peril_cd
                                         AND NOT EXISTS (
                                                SELECT 1
                                                  FROM gipi_itmperil_ri_comm_hist n
                                                 WHERE n.policy_id = a.policy_id
                                                   AND n.item_no = d.item_no
                                                   AND n.peril_cd = d.peril_cd
                                                   AND n.acct_ent_date <= p_to_date
                                                   AND TRUNC (n.post_date) > p_to_date))
                                   * c.currency_rt ri_comm_amt
                              FROM gipi_polbasic a, gipi_parlist b, gipi_item c,
                                   gipi_itmperil d
                             WHERE a.iss_cd = v_ri_iss_cd
                               AND a.line_cd = NVL (p_line_cd, a.line_cd)
                               AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                               AND (   a.pol_flag != '5'
                                    OR (    a.pol_flag = '5'
                                        AND NVL (a.spld_acct_ent_date, TRUNC (a.spld_date)) >
                                                                                      p_to_date
                                       )
                                   )
                               AND a.par_id = b.par_id
                               AND a.policy_id = c.policy_id
                               AND c.policy_id = d.policy_id
                               AND c.item_no = d.item_no
                               AND check_user_per_iss_cd2 (NULL,
                                                           DECODE (p_iss,
                                                                   1, a.cred_branch,
                                                                   2, a.iss_cd
                                                                  ),
                                                           'GIACS276',
                                                           p_user
                                                          ) = 1)
                  GROUP BY policy_id, assd_no, incept_date, acct_ent_date,
                           peril_cd, line_cd, iss_cd, cred_branch);
                  --Deo [02.27.2017]: add ends (SR-5865)
          --insert records in giac_comm_expense_ext
          IF SQL% FOUND THEN
             v_row_counter := vv_policy_id.COUNT; --Deo [02.27.2017]: SR-5865
            FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
              INSERT INTO giac_comm_expense_ext
                (policy_id,            assd_no,                incept_date,           acct_ent_date,         peril_cd,
                 prem_amt,             comm_amt,               line_cd,               iss_cd,                cred_branch,
                 user_id,              last_update,            param_from_date,       param_to_date,         param_line_cd)    --added param_from_date and param_to_date -> Gzelle 09212015 SR18729
              VALUES
                (vv_policy_id(i),      vv_assd_no(i),          vv_incept_date(i),     vv_acct_ent_date(i),   vv_peril_cd(i),
                 vv_premium_amt(i),    vv_commission_amt(i),   vv_line_cd(i),         vv_iss_cd(i),          vv_cred_branch(i),
                 p_user,               sysdate,                p_from_date,           p_to_date,             p_line_cd);       --added p_from_date and p_to_date -> Gzelle 09212015 SR18729
          END IF;
          COMMIT;
                
                  /*SELECT count(*)
                    INTO v_row_counter
                    FROM giac_comm_expense_ext
                   WHERE acct_ent_date BETWEEN p_from_date	AND p_to_date
                     --AND check_user_per_iss_cd(p_line_cd,iss_cd,'GIACS276')=1 
                     --AND check_user_per_iss_cd(p_line_cd,cred_branch,'GIACS276')=1
                     AND line_cd = nvl(p_line_cd, line_cd)
                     AND user_id = p_user;
                IF v_row_counter = 0 THEN 
                    p_rec_extracted := v_row_counter;
                    --p_message := 'There were 0 records extracted for the dates specified.';
                ELSE
                    p_rec_extracted := v_row_counter;
                    --p_message := 'Extraction finished! '||to_char(v_row_counter)|| ' records extracted.';
                END IF;*/  --Deo [02.27.2017]: comment out (SR-5865)
                p_rec_extracted := v_row_counter;
    END;
    
    PROCEDURE ext_rec_giacs276(
            p_comm           IN NUMBER,
            p_iss            IN NUMBER,
            p_from_date      IN VARCHAR2, 
            p_to_date        IN VARCHAR2,
            p_line_cd        IN VARCHAR2,
            p_user           IN VARCHAR2,
            p_rec_extracted OUT NUMBER
    )
    IS
    BEGIN
        IF p_comm = 1 THEN
            ext_comm_income(TO_DATE(p_from_date,'MM-DD-RRRR'), TO_DATE(p_to_date,'MM-DD-RRRR'), p_line_cd, p_user, p_rec_extracted, p_iss);
        ELSIF p_comm = 2 THEN
            ext_comm_expense(TO_DATE(p_from_date,'MM-DD-RRRR'), TO_DATE(p_to_date,'MM-DD-RRRR'), p_line_cd, p_user, p_rec_extracted, p_iss);
        END IF;
    END;
    
    
    FUNCTION get_giacs276_line_lov(
        p_module_id         GIIS_MODULES.module_id%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_find_text         VARCHAR2
    )
      RETURN giacs276_line_tab PIPELINED
    IS
        v_row               giacs276_line_type;
    BEGIN
        FOR i IN(SELECT l.line_cd, l.line_name
                   FROM GIIS_LINE l
                  WHERE UPPER(NVL(line_cd, '*')) LIKE UPPER(NVL(p_find_text, NVL(line_cd, '*'))) 
                    --OR UPPER(line_name) LIKE UPPER(NVL(p_find_text, line_name)))
                 ORDER BY l.line_cd, l.line_name)
        LOOP
            v_row.line_cd := i.line_cd;
            v_row.line_name := i.line_name;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    /*---start Gzelle 09222015 SR18729---*/ 
    PROCEDURE get_initial_values( 
        p_comm          IN OUT  VARCHAR2, 
        p_user_id       IN      giis_users.user_id%TYPE, 
        p_from_date     OUT     VARCHAR2, 
        p_to_date       OUT     VARCHAR2, 
        p_line_cd       OUT     giis_line.line_cd%TYPE, 
        p_line_name     OUT     giis_line.line_name%TYPE 
    ) 
    AS 
        v_cnt_incme NUMBER := 0; 
        v_cnt_exp   NUMBER := 0;  
        
    BEGIN 
        FOR i IN(SELECT DISTINCT param_line_cd, param_from_date, param_to_date,'CI' comm /*INCOME*/ 
                            FROM giac_comm_income_ext 
                           WHERE user_id = p_user_id 
                       UNION ALL 
                 SELECT DISTINCT param_line_cd, param_from_date, param_to_date,'CE' comm /*EXPENSE*/ 
                            FROM giac_comm_expense_ext 
                           WHERE user_id = p_user_id) 
        LOOP 
            IF NVL(p_comm,'CI') = 'CI' 
            THEN 
                IF i.comm = 'CI' 
                THEN 
                    v_cnt_incme := v_cnt_incme + 1; 
                    p_line_cd   := i.param_line_cd; 
                    p_from_date := TO_CHAR(i.param_from_date,'MM-DD-RRRR'); 
                    p_to_date   := TO_CHAR(i.param_to_date,'MM-DD-RRRR'); 
                    p_line_name := NVL(get_line_name(i.param_line_cd),'ALL LINES'); 
                END IF; 
            ELSIF p_comm = 'CE' 
            THEN 
                IF i.comm = 'CE' 
                THEN 
                    v_cnt_exp := v_cnt_exp + 1; 
                    p_line_cd   := i.param_line_cd; 
                    p_from_date := TO_CHAR(i.param_from_date,'MM-DD-RRRR'); 
                    p_to_date   := TO_CHAR(i.param_to_date,'MM-DD-RRRR'); 
                    p_line_name := NVL(get_line_name(i.param_line_cd),'ALL LINES'); 
                END IF;             
            END IF; 
        END LOOP; 
    END; 

    /*09232015*/ 
    PROCEDURE val_extract_print( 
        p_trigger       IN     VARCHAR2, 
        p_comm          IN     VARCHAR2, 
        p_user_id       IN OUT giis_users.user_id%TYPE, 
        p_from_date     IN     VARCHAR2, 
        p_to_date       IN     VARCHAR2, 
        p_line_cd       IN     giis_line.line_cd%TYPE, 
        p_out           OUT    VARCHAR2 
    ) 
    AS 
        v_rec_cnt   NUMBER := 0; 
        v_all_count NUMBER := 0; 
        v_dist_line VARCHAR2(2) := NULL; 
    BEGIN 
         
        IF p_comm = 'CI' 
        THEN 
            BEGIN  
                SELECT COUNT(*) 
                  INTO v_all_count 
                  FROM giac_comm_income_ext 
                   WHERE user_id = p_user_id 
                   AND param_from_date = TO_DATE(p_from_date,'MM-DD-RRRR') 
                   AND param_to_date = TO_DATE(p_to_date,'MM-DD-RRRR'); 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    v_all_count := 0; 
            END; 
             
            BEGIN 
                SELECT DISTINCT param_line_cd 
                  INTO v_dist_line 
                  FROM giac_comm_income_ext; 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    v_dist_line := NULL; 
            END; 
 
            IF v_all_count != 0 AND v_dist_line = p_line_cd 
            THEN 
                v_rec_cnt := v_all_count;  
            ELSIF v_all_count != 0 AND v_dist_line IS NULL AND p_line_cd IS NULL 
            THEN  
                v_rec_cnt := v_all_count;  
            END IF; 
             
            BEGIN 
                SELECT user_id 
                  INTO p_user_id 
                  FROM giac_comm_income_ext 
                 WHERE user_id = p_user_id 
                   AND ROWNUM = 1;  
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    p_user_id := '';          
            END; 
        ELSIF p_comm = 'CE'  
        THEN 
            BEGIN 
                SELECT COUNT(*) 
                  INTO v_all_count 
                  FROM giac_comm_expense_ext 
                   WHERE user_id = p_user_id 
                   AND param_from_date = TO_DATE(p_from_date,'MM-DD-RRRR') 
                   AND param_to_date = TO_DATE(p_to_date,'MM-DD-RRRR'); 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    v_all_count := 0; 
            END;  
              
            BEGIN  
                SELECT DISTINCT param_line_cd 
                  INTO v_dist_line 
                  FROM giac_comm_expense_ext; 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    v_dist_line := NULL; 
            END; 
 
            IF v_all_count != 0 AND v_dist_line = p_line_cd 
            THEN 
                v_rec_cnt := v_all_count;  
            ELSIF v_all_count != 0 AND v_dist_line IS NULL AND p_line_cd IS NULL 
            THEN  
                v_rec_cnt := v_all_count;  
            END IF; 
             
            BEGIN 
                SELECT user_id 
                  INTO p_user_id 
                  FROM giac_comm_expense_ext 
                 WHERE user_id = p_user_id 
                   AND ROWNUM = 1;  
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    p_user_id := '';          
            END;                    
        END IF; 
        p_out := v_rec_cnt; 
    END; 
        
    /*---end Gzelle 09222015 SR18729---*/ 
        

END GIACS276_PKG;
/



CREATE OR REPLACE PROCEDURE CPI.POPULATE_PERIL(
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1) := 'N'; 
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_peril_cd         gipi_witmperl.peril_cd%TYPE;
  v_line_cd          gipi_witmperl.line_cd%TYPE;
  v_tarf_cd          gipi_witmperl.tarf_cd%TYPE;
  v_prem_rt          gipi_witmperl.prem_rt%TYPE;
  v_tsi_amt          gipi_witmperl.tsi_amt%TYPE;
  v_prem_amt         gipi_witmperl.prem_amt%TYPE;
  v_comp_rem         gipi_witmperl.comp_rem%TYPE;
  expire_sw          VARCHAR2(1) := 'N';
  perl_exist         VARCHAR2(1) := 'N';
  v_dep_pct          NUMBER(3,2) := Giisp.n('MC_DEP_PCT')/100;
  v_auto_comp_dep    giis_parameters.param_value_v%TYPE := Giisp.v('AUTO_COMPUTE_MC_DEP');
  v_round_off        giis_parameters.param_value_n%TYPE; -- added by: Nica 1.18.2014
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
  v_prem_perl        gipi_polbasic.ann_prem_amt%TYPE   := 0; -- jhing 07.16.2015
  v_recompute_premrt    giis_parameters.param_value_v%TYPE := NVL(giisp.v('RECOMP_RENEWAL_PREM_RT'),'N') ; 
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_PERIL program unit 
  */     
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
  
  IF NVL(v_auto_comp_dep, 'N') = 'Y' THEN
  	  BEGIN
		SELECT DECODE (param_value_n,
					 10, -1,
					 100, -2,
					 1000, -3,
					 10000, -4,
					 100000, -5,
					 1000000, -6,
					 9
					)
			INTO v_round_off
			FROM giis_parameters
		   WHERE param_name = 'ROUND_OFF_PLACE';
	  EXCEPTION
		  WHEN NO_DATA_FOUND
		  THEN
			 v_round_off := 9;
	  END; -- added by: Nica 01.18.2014
  END IF;
  
  IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
          FOR PERIL IN ( 
            SELECT peril_cd, line_cd
              FROM giex_itmperil
             WHERE item_no   = v_item_no
               AND policy_id = p_old_pol_id)--v_policy_id )                  
          LOOP                 
            IF item_exist = 'N' THEN 
               expire_sw := 'N';
               FOR EX IN (
                  SELECT ann_prem_amt prem_amt,      tsi_amt,
                         prem_rt,       comp_rem
                    FROM giex_itmperil
                   WHERE item_no   = v_item_no
                     AND peril_cd  = peril.peril_cd
                     AND policy_id = p_old_pol_id)
               LOOP
                 v_peril_cd         := peril.peril_cd;
                 v_line_cd          := peril.line_cd;
                 v_prem_amt         := ex.prem_amt;
                 v_tsi_amt          := ex.tsi_amt;
                 --v_tarf_cd          := data.tarf_cd;
                 v_comp_rem         := ex.comp_rem;
                 v_prem_rt          := ex.prem_rt;
                 expire_sw          := 'Y';
               END LOOP;
               IF NVL(v_tsi_amt,0) > 0  THEN
                  --CLEAR_MESSAGE;
                  --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
                  --SYNCHRONIZE;    
                    INSERT INTO gipi_witmperl (
                                par_id,            item_no,        peril_cd, 
                                line_cd,           tsi_amt,        prem_amt,
                                prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                tarf_cd,           comp_rem,       rec_flag)
                    VALUES(p_new_par_id,           v_item_no,      v_peril_cd,
                                v_line_cd,         v_tsi_amt,      v_prem_amt,
                                v_prem_rt,         v_tsi_amt,      v_prem_amt,
                                v_tarf_cd,         v_comp_rem,     'A');
                  v_peril_cd := NULL;
                  v_line_cd  := NULL;
                  v_prem_amt := NULL;
                  v_tsi_amt  := NULL;
                  v_tarf_cd  := NULL;
                  v_prem_rt  := NULL;
                  v_comp_rem := NULL;
                END IF;                 
              ELSE
                EXIT;             
              END IF;                        
          END LOOP;
          item_exist := 'Y';
          FOR DATA IN ( 
            SELECT peril_cd,      ann_prem_amt prem_amt,        tsi_amt,
                   tarf_cd,       prem_rt,         comp_rem,
                   line_cd
              FROM gipi_itmperil
             WHERE item_no   = v_item_no
               AND policy_id = v_policy_id) 
          LOOP
            IF expire_sw = 'N' THEN 
               perl_exist         := 'N';
               v_peril_cd         := data.peril_cd;
               v_line_cd          := data.line_cd;
               v_prem_amt         := data.prem_amt;
               v_tsi_amt          := data.tsi_amt;
               v_tarf_cd          := data.tarf_cd;
               v_prem_rt          := data.prem_rt;
               v_comp_rem         := data.comp_rem;
                 FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                            FROM gipi_polbasic
                          WHERE line_cd     =  x_line_cd
                            AND subline_cd  =  x_subline_cd
                            AND iss_cd      =  x_iss_cd
                            AND issue_yy    =  to_char(x_issue_yy)
                            AND pol_seq_no  =  to_char(x_pol_seq_no)
                            AND renew_no    =  to_char(x_renew_no)
                            AND (endt_seq_no = 0 OR 
                                (endt_seq_no > 0 AND 
                                TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                            AND pol_flag In ('1','2','3')
                            AND NVL(endt_seq_no,0) = 0
                          ORDER BY eff_date, endt_seq_no)
                 LOOP      
                    v_endt_id  := b1.policy_id;
                     FOR DATA2 IN ( 
                       /*SELECT ann_prem_amt prem_amt,        tsi_amt,       
                              tarf_cd,       prem_rt,         comp_rem,
                              ri_comm_rate,  ri_comm_amt
                         FROM gipi_itmperil
                        WHERE peril_cd  = v_peril_cd
                          AND item_no = v_item_no                         
                          AND policy_id = v_endt_id) */ -- replaced by Jhing 07.16.2015 with query below to correct premium. GENQA SR # 4812. Changes integrated from latest CS.
                           SELECT a.ann_prem_amt, a.prem_amt,        a.tsi_amt,       
                                      tarf_cd,       prem_rt,         comp_rem,
                                      ri_comm_rate,  ri_comm_amt,
                                      prorate_flag, 
                                      ROUND ( NVL (endt_expiry_date, expiry_date) - eff_date) e_no_of_days,
                                      DECODE ( NVL (comp_sw, 'N'),
                                                         'Y', 1,
                                                         'M', -1,
                                                         0
                                                        ) comp_sw, 
                                      incept_date, expiry_date,
                                      short_rt_percent short_rt, peril_cd, endt_seq_no, a.policy_id
                                 FROM gipi_itmperil a, gipi_polbasic b
                                WHERE 1 = 1
                                  AND a.policy_id = b.policy_id
                                  AND peril_cd  =  v_peril_cd
                                  AND item_no = v_item_no                   
                                  AND a.policy_id = v_endt_id )                          
                     LOOP
                       IF v_policy_id <> v_endt_id THEN    
                          -- added by jhing 07.16.2015 to resolve GENQA SR # 4812
                          IF data2.prorate_flag = 1 THEN                 
                                v_prem_perl := (data2.prem_amt / (data2.e_no_of_days + data2.comp_sw) )
                                                * check_duration (data2.incept_date, data2.expiry_date);  
                          ELSIF data2.prorate_flag = 3 THEN
                                v_prem_perl := (data2.prem_amt * 100) / data2.short_rt;
                          ELSE
                                v_prem_perl := data2.prem_amt;
                          END IF;
                        
                          -- v_prem_amt         := NVL(v_prem_amt,0) + NVL(data2.prem_amt,0); -- jhing 07.16.2015 replaced with code below: GENQA SR # 4812
                          v_prem_amt         := NVL(v_prem_amt,0) + NVL(v_prem_perl,0);
                          v_tsi_amt          := NVL(v_tsi_amt,0) + NVL(data2.tsi_amt,0);
                          v_tarf_cd          := NVL(data2.tarf_cd, v_tarf_cd);
                          IF NVL(data2.prem_rt,0) > 0 THEN
                             v_prem_rt          := data2.prem_rt;
                          END IF;   
                          v_comp_rem         := NVL(data2.comp_rem, v_comp_rem);                        
                       END IF;    
                     END LOOP;
                 END LOOP;    
            END IF;  
            IF NVL(v_tsi_amt,0) > 0  THEN
               --CLEAR_MESSAGE;
               --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
               --SYNCHRONIZE;    
                 FOR perl IN (
                   SELECT 1
                     FROM gipi_witmperl
                    WHERE item_no  = v_item_no
                      AND peril_cd = v_peril_cd
                      AND par_id   = p_new_par_id)
                 LOOP    
                   perl_exist := 'Y';
                   EXIT;
                 END LOOP;
                 
                 /*FOR a IN (
                       SELECT '1'                
                              FROM giex_dep_perl b
                           WHERE b.line_cd  = v_line_cd
                             AND b.peril_cd = v_peril_cd
                             AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
                             --AND b.line_cd = Giisp.v('LINE_CODE_MC'))
                         LOOP            
                             v_tsi_amt  := v_tsi_amt - (v_tsi_amt*v_dep_pct);             
                             v_prem_amt := ROUND((v_tsi_amt * (v_prem_rt/100)),2);
                         END LOOP;*/ -- replaced by: Nica 01.18.2014
                 
                /*FOR a IN (SELECT NVL (rate, 0) rate
						  FROM giex_dep_perl
						 WHERE line_cd = v_line_cd
						   AND peril_cd = v_peril_cd
						   AND NVL(v_auto_comp_dep, 'N') = 'Y')
				LOOP
					IF a.rate <> 0 THEN 
						 v_tsi_amt :=
							ROUND ((  v_tsi_amt
									- (v_tsi_amt * (a.rate / 100))
								   ),
								   v_round_off
								  );
				         v_prem_amt := ROUND((v_tsi_amt * (v_prem_rt/100)),2);
					END IF;          
				END LOOP;*/ --benjo 11.23.2016 SR-5621 comment out
                
               compute_depreciation_amounts (v_policy_id, v_item_no, v_line_cd, v_peril_cd, v_tsi_amt); --benjo 11.23.2016 SR-5621
               IF v_prem_rt <> 0 THEN --nieko 01112017, SR 23665
                    v_prem_amt := v_tsi_amt * (v_prem_rt/100); --benjo 11.23.2016 SR-5621
               END IF;   
                         --message(v_tsi_amt||':'||v_prem_rt);message(v_tsi_amt||':'||v_prem_rt);
                         
               IF perl_exist = 'N' THEN
                    INSERT INTO gipi_witmperl (
                             par_id,            item_no,        peril_cd, 
                             line_cd,           tsi_amt,        prem_amt,
                             prem_rt,           ann_tsi_amt,    ann_prem_amt,
                             tarf_cd,           comp_rem,       rec_flag)
                    VALUES(p_new_par_id,      v_item_no,      v_peril_cd,
                             v_line_cd,         v_tsi_amt,      v_prem_amt,
                             v_prem_rt,         v_tsi_amt,      v_prem_amt,
                             v_tarf_cd,         v_comp_rem,     'A');
               END IF;
               v_peril_cd         := NULL;
               v_line_cd          := NULL;
               v_prem_amt         := NULL;
               v_tsi_amt          := NULL;
               v_tarf_cd          := NULL;
               v_prem_rt          := NULL;
               v_comp_rem         := NULL;
            END IF;                 
          END LOOP;    
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
        FOR PERIL IN ( 
            SELECT peril_cd, line_cd
              FROM giex_itmperil
             WHERE item_no   = v_item_no
               AND policy_id = p_old_pol_id)--v_policy_id )                  
          LOOP                 
            IF item_exist = 'N' THEN 
               expire_sw := 'N';
               FOR EX IN (
                  SELECT ann_prem_amt prem_amt,      tsi_amt,
                         prem_rt,       comp_rem
                    FROM giex_itmperil
                   WHERE item_no   = v_item_no
                     AND peril_cd  = peril.peril_cd
                     AND policy_id = p_old_pol_id)
               LOOP
                 v_peril_cd         := peril.peril_cd;
                 v_line_cd          := peril.line_cd;
                 v_prem_amt         := ex.prem_amt;
                 v_tsi_amt          := ex.tsi_amt;
                 --v_tarf_cd          := data.tarf_cd;
                 v_comp_rem         := ex.comp_rem;
                 v_prem_rt          := ex.prem_rt;
                 expire_sw          := 'Y';
               END LOOP;
               IF NVL(v_tsi_amt,0) > 0  THEN
                  --CLEAR_MESSAGE;
                  --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
                  --SYNCHRONIZE;    
                    INSERT INTO gipi_witmperl (
                                par_id,            item_no,        peril_cd, 
                                line_cd,           tsi_amt,        prem_amt,
                                prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                tarf_cd,           comp_rem,       rec_flag)
                    VALUES(p_new_par_id,           v_item_no,      v_peril_cd,
                                v_line_cd,         v_tsi_amt,      v_prem_amt,
                                v_prem_rt,         v_tsi_amt,      v_prem_amt,
                                v_tarf_cd,         v_comp_rem,     'A');
                  v_peril_cd := NULL;
                  v_line_cd  := NULL;
                  v_prem_amt := NULL;
                  v_tsi_amt  := NULL;
                  v_tarf_cd  := NULL;
                  v_prem_rt  := NULL;
                  v_comp_rem := NULL;
                END IF;                 
              ELSE
                EXIT;             
              END IF;                        
          END LOOP;
          item_exist := 'Y';
          FOR DATA IN ( 
            SELECT peril_cd,      ann_prem_amt prem_amt,        tsi_amt,
                   tarf_cd,       prem_rt,         comp_rem,
                   line_cd
              FROM gipi_itmperil
             WHERE item_no   = v_item_no
               AND policy_id = v_policy_id) 
          LOOP
            IF expire_sw = 'N' THEN 
               perl_exist         := 'N';
               v_peril_cd         := data.peril_cd;
               v_line_cd          := data.line_cd;
               v_prem_amt         := data.prem_amt;
               v_tsi_amt          := data.tsi_amt;
               v_tarf_cd          := data.tarf_cd;
               v_prem_rt          := data.prem_rt;
               v_comp_rem         := data.comp_rem;
               FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                           FROM gipi_polbasic
                          WHERE line_cd     =  x_line_cd
                            AND subline_cd  =  x_subline_cd
                            AND iss_cd      =  x_iss_cd
                            AND issue_yy    =  to_char(x_issue_yy)
                            AND pol_seq_no  =  to_char(x_pol_seq_no)
                            AND renew_no    =  to_char(x_renew_no)
                            AND (endt_seq_no = 0 OR 
                                (endt_seq_no > 0 AND 
                                TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                            AND pol_flag In ('1','2','3')
                          ORDER BY eff_date, endt_seq_no)
                 LOOP      
                    v_endt_id  := b1.policy_id;
                     FOR DATA2 IN ( 
                       /*SELECT ann_prem_amt prem_amt,        tsi_amt,       
                              tarf_cd,       prem_rt,         comp_rem,
                              ri_comm_rate,  ri_comm_amt
                         FROM gipi_itmperil
                        WHERE peril_cd  = v_peril_cd
                          AND item_no = v_item_no                         
                          AND policy_id = v_endt_id)*/ -- jhing 07.16.2015 replaced code with code below to correct computation of premium. GENQA SR #  4812
                       SELECT a.ann_prem_amt, a.prem_amt,        a.tsi_amt,       
                                      tarf_cd,       prem_rt,         comp_rem,
                                      ri_comm_rate,  ri_comm_amt,
                                      prorate_flag, 
                                      ROUND ( NVL (endt_expiry_date, expiry_date) - eff_date) e_no_of_days,
                                      DECODE ( NVL (comp_sw, 'N'),
                                                         'Y', 1,
                                                         'M', -1,
                                                         0
                                                        ) comp_sw, 
                                      incept_date, expiry_date,
                                      short_rt_percent short_rt, peril_cd, endt_seq_no, a.policy_id
                                 FROM gipi_itmperil a, gipi_polbasic b
                                WHERE 1 = 1
                                  AND a.policy_id = b.policy_id
                                  AND peril_cd  =  v_peril_cd
                                  AND item_no = v_item_no                   
                                  AND a.policy_id = v_endt_id )                           
                     LOOP
                       
                       -- added by jhing 07.16.2015 to resolve GENQA SR # 4812
                       IF data2.prorate_flag = 1 THEN                 
                          v_prem_perl := (data2.prem_amt / (data2.e_no_of_days + data2.comp_sw) )
                                                * check_duration (data2.incept_date, data2.expiry_date);  
                       ELSIF data2.prorate_flag = 3 THEN
                          v_prem_perl := (data2.prem_amt * 100) / data2.short_rt;
                       ELSE
                          v_prem_perl := data2.prem_amt;
                       END IF;    
                                       
                       IF v_policy_id <> v_endt_id THEN    
                          -- v_prem_amt         := NVL(v_prem_amt,0) + NVL(data2.prem_amt,0);  -- jhing 07.16.2015 replaced with code below: GENQA SR # 4812
                          v_prem_amt         := NVL(v_prem_amt,0) + NVL(v_prem_perl,0);  
                          v_tsi_amt          := NVL(v_tsi_amt,0) + NVL(data2.tsi_amt,0);
                          v_tarf_cd          := NVL(data2.tarf_cd, v_tarf_cd);
                          IF NVL(data2.prem_rt,0) > 0 THEN
                             v_prem_rt          := data2.prem_rt;
                          END IF;   
                          v_comp_rem         := NVL(data2.comp_rem, v_comp_rem);                        
                       END IF;    
                     END LOOP;
                 END LOOP;              
            END IF;  
            IF NVL(v_tsi_amt,0) > 0  THEN
               --CLEAR_MESSAGE;
               --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
               --SYNCHRONIZE;    
                 FOR perl IN (
                   SELECT 1
                     FROM gipi_witmperl
                    WHERE item_no  = v_item_no
                      AND peril_cd = v_peril_cd
                      AND par_id   = p_new_par_id)
                 LOOP    
                   perl_exist := 'Y';
                   EXIT;
                 END LOOP;
                 
                 /*FOR a IN (
                       SELECT '1'                
                              FROM giex_dep_perl b
                           WHERE b.line_cd  = v_line_cd
                             AND b.peril_cd = v_peril_cd
                             AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
                             --AND b.line_cd = Giisp.v('LINE_CODE_MC'))
                         LOOP            
                             v_tsi_amt  := v_tsi_amt - (v_tsi_amt*v_dep_pct);             
                             v_prem_amt := ROUND((v_tsi_amt * (v_prem_rt/100)),2);
                         END LOOP;*/ -- replaced by: Nica 01.18.2014

                 -- jhing set premium rate based on parameter. 
                IF v_recompute_premrt  = 'Y' THEN
                    v_prem_rt := ( v_prem_amt / v_tsi_amt   ) * 100 ;                
                END IF; 
                        
                /*FOR a IN (SELECT NVL (rate, 0) rate
						  FROM giex_dep_perl
						 WHERE line_cd = v_line_cd
						   AND peril_cd = v_peril_cd
						   AND NVL(v_auto_comp_dep, 'N') = 'Y')
				LOOP
					IF a.rate <> 0 THEN 
						 v_tsi_amt :=
							ROUND ((  v_tsi_amt
									- (v_tsi_amt * (a.rate / 100))
								   ),
								   v_round_off
								  );
				         v_prem_amt := ROUND((v_tsi_amt * (v_prem_rt/100)),2);  
					END IF;          
				END LOOP;*/ --benjo 11.23.2016 SR-5621 comment out
                
               compute_depreciation_amounts (v_policy_id, v_item_no, v_line_cd, v_peril_cd, v_tsi_amt); --benjo 11.23.2016 SR-5621
               IF v_prem_rt <> 0 THEN --nieko 01112017, SR 23665
                    v_prem_amt := v_tsi_amt * (v_prem_rt/100); --benjo 11.23.2016 SR-5621
               END IF;          
                         --message(v_tsi_amt||':'||v_prem_rt);message(v_tsi_amt||':'||v_prem_rt);
                         
               IF perl_exist = 'N' THEN
                    INSERT INTO gipi_witmperl (
                             par_id,            item_no,        peril_cd, 
                             line_cd,           tsi_amt,        prem_amt,
                             prem_rt,           ann_tsi_amt,    ann_prem_amt,
                             tarf_cd,           comp_rem,       rec_flag)
                    VALUES(p_new_par_id,      v_item_no,      v_peril_cd,
                             v_line_cd,         v_tsi_amt,      v_prem_amt,
                             v_prem_rt,         v_tsi_amt,      v_prem_amt,
                             v_tarf_cd,         v_comp_rem,     'A');
               END IF;
               v_peril_cd         := NULL;
               v_line_cd          := NULL;
               v_prem_amt         := NULL;
               v_tsi_amt          := NULL;
               v_tarf_cd          := NULL;
               v_prem_rt          := NULL;
               v_comp_rem         := NULL;
            END IF;                 
          END LOOP; 
     END LOOP;
   END IF;
END;
/
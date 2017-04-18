DROP PROCEDURE CPI.GIPIS097_VALIDATE_BACK_ALLIED;

CREATE OR REPLACE PROCEDURE CPI.gipis097_validate_back_allied (
   p_par_id         GIPI_PARLIST.par_id%TYPE,
   p_item_no        GIPI_WITEM.item_no%TYPE,
   p_peril_cd       NUMBER,
   p_peril_type     VARCHAR2,
   p_basc_perl_cd   NUMBER,
   p_tsi_amt        NUMBER,
   p_prem_amt       NUMBER,
   p_existing_perils VARCHAR2
)
IS
   r_itmperl      VARCHAR2 (20) := 'EXISTING_PERILS';
--   rg_id          recordgroup;
--   rg_id2         recordgroup;
   cnt_basic      NUMBER        := 0;
   cnt_basic3     NUMBER        := 0;
   cnt_allied     NUMBER        := 0;
   attach_exist   VARCHAR2 (1)  := 'N';
   allied_exist   VARCHAR2 (1)  := 'N';
   allied_rg      VARCHAR2 (1)  := 'N';
   cnt            NUMBER;
   cnt2           NUMBER;
   cnt3           NUMBER        := 0;
   b_type         VARCHAR2 (1);
   b_peril        NUMBER;
   b_item         NUMBER;
   b_tsi          NUMBER;
   b_line         VARCHAR2 (5);
   p_peril        NUMBER;
   p_item         NUMBER;
   p_tsi          NUMBER;
   p_line         VARCHAR2 (5);
   b3_peril       NUMBER;
   b3_item        NUMBER;
   b3_tsi         NUMBER;
   b3_tsi1        NUMBER        := 0;
   b3_line        VARCHAR2 (5);
   dum_tsi        NUMBER        := NULL;
   rg_tsi         NUMBER        := NULL;
   sel_tsi        NUMBER        := NULL;
   prem_tsi       NUMBER        := NULL;
   att_tsi        NUMBER        := 0;
   fin_tsi        NUMBER        := 0;
   basc_tsi       NUMBER        := NULL;
   exist_sw       VARCHAR2 (1);
   comp_tsi       NUMBER;
   curr_exist     VARCHAR2 (1);
   
   v_prov_prem_tag       gipi_wpolbas.prov_prem_tag%TYPE;
   v_prorate_flag        gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw             gipi_wpolbas.comp_sw%TYPE;
   v_short_rt_percent    gipi_wpolbas.short_rt_percent%TYPE;
   v_endt_expiry_date    gipi_wpolbas.endt_expiry_date%TYPE;
   v_eff_date            gipi_wpolbas.eff_date%TYPE;
   v_expiry_date         gipi_wpolbas.expiry_date%TYPE;
   v_incept_date         gipi_wpolbas.incept_date%TYPE;
   var_expiry_date       DATE;
   v_line_cd             gipi_wpolbas.line_cd%TYPE;
   v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no            gipi_wpolbas.renew_no%TYPE;
   var_plan_sw           VARCHAR2 (1);
   var_comp_no_of_days   NUMBER;
   v_prov_prem_pct       gipi_wpolbas.prov_prem_pct%TYPE;
   v_temp_existing_perils VARCHAR2(32672);
   v_temp_row VARCHAR2(5000);
BEGIN

   var_expiry_date := extract_expiry (p_par_id);    

   FOR i IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, prov_prem_tag,
                    prorate_flag, comp_sw, short_rt_percent, endt_expiry_date, prov_prem_pct,
                    eff_date, expiry_date, incept_date
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP
      v_line_cd := i.line_cd;
      v_subline_cd := i.subline_cd;
      v_iss_cd := i.iss_cd;
      v_issue_yy := i.issue_yy;
      v_pol_seq_no := i.pol_seq_no;
      v_renew_no := i.renew_no;
      v_prov_prem_tag := i.prov_prem_tag;
      v_prov_prem_pct := i.prov_prem_pct;
      v_prorate_flag := i.prorate_flag;
      v_comp_sw := i.comp_sw;
      v_short_rt_percent := i.short_rt_percent;
      v_endt_expiry_date := i.endt_expiry_date;
      v_incept_date := i.incept_date;
      v_expiry_date := i.expiry_date;
      v_eff_date := i.eff_date;
      EXIT;
   END LOOP;

   /* compute first the resulting ann_tsi_amt for the tsi_amt entered */
   FOR a1 IN (SELECT   b250.policy_id, b380.ann_tsi_amt, b250.line_cd, b250.iss_cd,
                       b250.subline_cd, b250.pol_seq_no, b250.issue_yy, b250.renew_no,
                       b250.eff_date,
                          b250.endt_iss_cd
                       || '-'
                       || TO_CHAR (b250.endt_yy, '09')
                       || TO_CHAR (b250.endt_seq_no, '099999') endt_no
                  FROM gipi_itmperil b380, gipi_polbasic b250
                 WHERE b250.line_cd = v_line_cd
                   AND b250.subline_cd = v_subline_cd
                   AND b250.iss_cd = v_iss_cd
                   AND b250.issue_yy = v_issue_yy
                   AND b250.pol_seq_no = v_pol_seq_no
                   AND b250.renew_no = v_renew_no
                   AND b250.policy_id = b380.policy_id
                   AND b380.item_no = p_item_no
                   AND b380.peril_cd = p_peril_cd
                   AND b250.pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (b250.eff_date) >
                              v_eff_date
                   AND TRUNC (DECODE (NVL (b250.endt_expiry_date, b250.expiry_date),
                                      b250.expiry_date, var_expiry_date,
                                      b250.endt_expiry_date, b250.endt_expiry_date
                                     )
                             ) >= v_eff_date
              ORDER BY b250.eff_date)
   LOOP
      comp_tsi := NVL (a1.ann_tsi_amt, 0) + NVL (p_tsi_amt, 0);
      fin_tsi := 0; --Gzelle 08042015 SR19936 reset fin_tsi - per policy
      /* check if peril type is basic or allied */
      IF p_peril_type = 'B'
      THEN
         /* for basic peril check if the peril has an attached allied peril */
         SELECT COUNT (*)
           INTO cnt_allied
           FROM giis_peril a170
          WHERE a170.line_cd = v_line_cd AND a170.peril_type = 'A'
                AND a170.basc_perl_cd = p_peril_cd;

         IF cnt_allied > 0
         THEN
            /*Basic peril has an existing attached allied peril */
            FOR allied1 IN (SELECT a170.peril_cd
                              FROM giis_peril a170
                             WHERE a170.line_cd = v_line_cd
                               AND a170.peril_type = 'A'
                               AND (a170.basc_perl_cd = p_peril_cd OR a170.basc_perl_cd IS NULL))
            LOOP
               prem_tsi := NULL;
               sel_tsi := NULL;

               FOR c1 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                            FROM gipi_itmperil a
                           WHERE a.policy_id = a1.policy_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = allied1.peril_cd)
               LOOP
                  sel_tsi := c1.ann_tsi_amt;
                  
                  v_temp_existing_perils := p_existing_perils;

                  IF LENGTH(v_temp_existing_perils) > 0
                  THEN
                     WHILE LENGTH(v_temp_existing_perils) > 0
                     LOOP
                     
                        SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                          INTO v_temp_row
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                          INTO b_peril
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                          INTO b_tsi
                          FROM DUAL;
                                               
                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                          INTO b_item
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                          INTO b_line
                          FROM DUAL;

                        IF     b_peril = allied1.peril_cd
                           AND b_line = v_line_cd
                           AND b_item = p_item_no
                        THEN
                           sel_tsi := NVL (sel_tsi, 0) + NVL (b_tsi, 0);
                        END IF;
                        
                        SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                          INTO v_temp_existing_perils
                          FROM DUAL;
                     END LOOP;
                  END IF;

                  IF NVL (sel_tsi, 0) > 0
                  THEN
                     allied_exist := 'Y';
                  END IF;

                  EXIT;
               END LOOP;

               prem_tsi := NVL (sel_tsi, 0);

               IF fin_tsi < prem_tsi
               THEN
                  fin_tsi := prem_tsi;
               END IF; 
            END LOOP;

            /* check for existence of other basic perils in policy and it's endorsements  */
            IF allied_exist = 'Y'
            THEN
               FOR chk_basic IN (SELECT a170.peril_cd
                                   FROM giis_peril a170
                                  WHERE a170.line_cd = v_line_cd
                                    AND a170.peril_type = 'B'
                                    AND peril_cd <> p_peril_cd)
               LOOP
                  v_temp_existing_perils := p_existing_perils;

                  IF LENGTH(v_temp_existing_perils) > 0
                  THEN
                     allied_rg := 'N';
                     b3_peril := NULL;
                     b3_tsi := 0;
                     b3_tsi1 := 0;
                     b3_item := NULL;
                     b3_line := NULL;

                     WHILE LENGTH(v_temp_existing_perils) > 0 
                     LOOP
                        SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                          INTO v_temp_row
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                          INTO b3_peril
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                          INTO b3_tsi
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 3)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 4))-INSTR(v_temp_row, '@', 1, 3)-1) 
                          INTO b3_tsi1
                          FROM DUAL; 
                                              
                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                          INTO b3_item
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                          INTO b3_line
                          FROM DUAL;                                              

                        IF     b3_peril = chk_basic.peril_cd
                           AND b3_line = v_line_cd
                           AND b3_item = p_item_no
                        THEN
                           IF NVL (b3_tsi, 0) = 0
                           THEN
                              EXIT;
                           ELSIF NVL (b3_tsi, 0) >= NVL (fin_tsi, 0)
                           THEN
                              allied_rg := 'Y';
                              cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                              EXIT;
                           END IF;
                        END IF;
                        
                        SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                          INTO v_temp_existing_perils
                          FROM DUAL;                        
                     END LOOP;
                  END IF;               

                  IF allied_rg = 'N'
                  THEN
                     curr_exist := 'N';

                     FOR c3 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                                  FROM gipi_itmperil a
                                 WHERE a.policy_id = a1.policy_id
                                   AND a.item_no = p_item_no
                                   AND a.peril_cd = chk_basic.peril_cd)
                     LOOP
                        curr_exist := 'Y';

                        IF NVL (c3.ann_tsi_amt, 0) = 0
                        THEN
                           EXIT;
                        ELSIF NVL (c3.ann_tsi_amt, 0) + NVL (b3_tsi1, 0) >= NVL (fin_tsi, 0)
                        THEN
                           cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                           EXIT;
                        END IF;
                     END LOOP;

                     IF curr_exist = 'N'
                     THEN
                        FOR c4 IN (SELECT   b380.ann_tsi_amt
                                       FROM gipi_itmperil b380, gipi_polbasic b250
                                      WHERE b250.line_cd = a1.line_cd
                                        AND b250.subline_cd = a1.subline_cd
                                        AND b250.iss_cd = a1.iss_cd
                                        AND b250.issue_yy = a1.issue_yy
                                        AND b250.pol_seq_no = a1.pol_seq_no
                                        AND b250.renew_no = a1.renew_no
                                        AND b250.policy_id = b380.policy_id
                                        AND b380.item_no = p_item_no
                                        AND b380.peril_cd = chk_basic.peril_cd
                                        AND b250.pol_flag IN ('1', '2', '3', 'X')
                                        AND b250.eff_date > v_eff_date
                                        AND b250.eff_date < a1.eff_date
                                        --AND NVL(b250.endt_expiry_date,b250.expiry_date) >= :b240.eff_date
                                        AND TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                                                b250.expiry_date
                                                               ),
                                                           b250.expiry_date, var_expiry_date,
                                                           b250.endt_expiry_date, b250.endt_expiry_date
                                                          )
                                                  ) >= v_eff_date
                                   ORDER BY b250.eff_date DESC)
                        LOOP
                           curr_exist := 'Y';

                           IF NVL (c4.ann_tsi_amt, 0) = 0
                           THEN
                              EXIT;
                           ELSIF NVL (c4.ann_tsi_amt, 0) + NVL (b3_tsi1, 0) > NVL (fin_tsi, 0)
                           THEN
                              cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                              EXIT;
                           END IF;
                        END LOOP;
                     END IF;
                  END IF;
                              /*    IF NVL(cnt_basic3,0) > 0 THEN
                                     EXIT;
                                  END IF;
               */
               END LOOP;

               --END IF;
                /* check if the attached allied peril for this basic peril is existing */
               FOR allied_chk IN (SELECT a170.peril_cd peril_cd
                                    FROM giis_peril a170
                                   WHERE a170.line_cd = v_line_cd
                                     AND a170.peril_type = 'A'
                                     AND a170.basc_perl_cd = p_peril_cd)
               LOOP
                  FOR c3 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                               FROM gipi_itmperil a
                              WHERE a.policy_id = a1.policy_id
                                AND a.item_no = p_item_no
                                AND a.peril_cd = allied_chk.peril_cd)
                  LOOP
                     b_peril := NULL;
                     b_tsi := 0;
                     b_item := NULL;
                     b_line := NULL;

                     v_temp_existing_perils := p_existing_perils;

                     IF LENGTH(v_temp_existing_perils) > 0
                     THEN
                        WHILE LENGTH(v_temp_existing_perils) > 0
                        LOOP
                        
                            SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                              INTO v_temp_row
                              FROM DUAL;

                            SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                              INTO b_peril
                              FROM DUAL;

                            SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                              INTO b_tsi
                              FROM DUAL;
                                                   
                            SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                              INTO b_item
                              FROM DUAL;

                            SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                              INTO b_line
                              FROM DUAL;

                           IF     b_peril = allied_chk.peril_cd
                              AND b_line = v_line_cd
                              AND b_item = p_item_no
                           THEN
                              c3.ann_tsi_amt := NVL (c3.ann_tsi_amt, 0) + NVL (b_tsi, 0);
                           END IF;
                           
                            SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                              INTO v_temp_existing_perils
                              FROM DUAL;                           
                        END LOOP;
                     END IF;     

                     IF NVL (c3.ann_tsi_amt, 0) = 0
                     THEN
                        EXIT;
                     ELSE
                        attach_exist := 'Y';
                        att_tsi := c3.ann_tsi_amt;
                        EXIT;
                     END IF;
                  END LOOP;
               --END IF;
               END LOOP;
            END IF;

--            IF :parameter.tsi_limit_sw = 'Y'
--            THEN
               IF comp_tsi != 0 AND comp_tsi < fin_tsi AND NVL (cnt_basic3, 0) <= 0
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#E#TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no '
                      || a1.endt_no
                      || ' to be less than an allied peril in the same endorsement.');
               ELSIF NVL (comp_tsi, 0) = 0 AND NVL (cnt_basic3, 0) <= 0 AND allied_exist = 'Y'
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#I#This basic peril cannot be zero out because there is an existing allied peril in endt no '
                      || a1.endt_no
                      || ' which has an effecitivity date later than '
                      || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY'));
               ELSIF NVL (comp_tsi, 0) = 0 AND allied_exist = 'Y' AND attach_exist = 'Y'
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#I#This basic peril cannot be zero out because there is an existing allied peril attached to it in endt no '
                      || a1.endt_no
                      || ' which has an effecitivity date later than '
                      || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY'));
               ELSIF comp_tsi != 0 AND comp_tsi < att_tsi AND allied_exist = 'Y'
                     AND attach_exist = 'Y'
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#E#TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no '
                      || a1.endt_no
                      || ' to be less than allied peril attached to it in the same endorsement.');
               END IF;
           -- END IF;
         ELSE
            /*Basic peril has an existing open allied peril*/
            FOR allied2 IN (SELECT a170.peril_cd peril_cd
                              FROM giis_peril a170
                             WHERE a170.line_cd = v_line_cd
                               AND a170.peril_type = 'A'
                               AND a170.basc_perl_cd IS NULL)
            LOOP
               prem_tsi := 0;

               FOR c1 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                            FROM gipi_itmperil a
                           WHERE a.policy_id = a1.policy_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = allied2.peril_cd)
               LOOP
                  sel_tsi := c1.ann_tsi_amt;

                  IF NVL (sel_tsi, 0) = 0
                  THEN
                     EXIT;
                  ELSE
                     allied_exist := 'Y';
                     EXIT;
                  END IF;
               END LOOP;

               v_temp_existing_perils := p_existing_perils;
               b_peril := NULL;
               b_tsi := 0;
               b_item := NULL;
               b_line := NULL;
               sel_tsi := 0; --Added by Jerome Bautista 09.22.2015 SR 20316

               IF LENGTH(v_temp_existing_perils) > 0
               THEN
                  WHILE LENGTH(v_temp_existing_perils) > 0
                  LOOP
                    SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                      INTO v_temp_row
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                      INTO b_peril
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                      INTO b_tsi
                      FROM DUAL;
                                                   
                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                      INTO b_item
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                      INTO b_line
                      FROM DUAL;     

                     IF b_peril = allied2.peril_cd AND b_line = v_line_cd AND b_item =
                                                                                      p_item_no
                     THEN
                        sel_tsi := NVL (sel_tsi, 0) + NVL (b_tsi, 0);
                     END IF;

                    SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                      INTO v_temp_existing_perils
                      FROM DUAL;               
                  END LOOP;
               END IF;

               fin_tsi := 0;                                                    --bdarusin  02182002
               prem_tsi := NVL (sel_tsi, 0);

               IF NVL (fin_tsi, 0) < prem_tsi
               THEN
                  fin_tsi := prem_tsi;
               END IF;
            END LOOP;

            IF allied_exist = 'Y'
            THEN
               FOR chk_basic IN (SELECT a170.peril_cd
                                   FROM giis_peril a170
                                  WHERE a170.line_cd = v_line_cd
                                    AND a170.peril_type = 'B'
                                    AND a170.peril_cd <> p_peril_cd)
               LOOP
                  b3_peril := NULL;
                  b3_tsi := 0;
                  b3_tsi1 := 0;
                  b3_item := NULL;
                  b3_line := NULL;
                  v_temp_existing_perils := p_existing_perils;

                  IF LENGTH(v_temp_existing_perils) > 0
                  THEN
                     allied_rg := 'N';

                     WHILE LENGTH(v_temp_existing_perils) > 0
                     LOOP
                     
                        SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                          INTO v_temp_row
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                          INTO b3_peril
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                          INTO b3_tsi
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 3)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 4))-INSTR(v_temp_row, '@', 1, 3)-1) 
                          INTO b3_tsi1
                          FROM DUAL; 
                                              
                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                          INTO b3_item
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                          INTO b3_line
                          FROM DUAL;

                        IF     b3_peril = chk_basic.peril_cd
                           AND b3_line = v_line_cd
                           AND b3_item = p_item_no
                        THEN
                           IF NVL (b3_tsi, 0) = 0
                           THEN
                              EXIT;
                           ELSIF NVL (b3_tsi, 0) >= NVL (fin_tsi, 0)
                           THEN
                              allied_rg := 'Y';
                              cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                              EXIT;
                           END IF;
                        END IF;

                        SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                          INTO v_temp_existing_perils
                          FROM DUAL;                         
                     END LOOP;
                  END IF;

                  IF allied_rg = 'N'
                  THEN
                     curr_exist := 'N';

                     FOR c3 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                                  FROM gipi_itmperil a
                                 WHERE a.policy_id = a1.policy_id
                                   AND a.item_no = p_item_no
                                   AND a.peril_cd = chk_basic.peril_cd)
                     LOOP
                        curr_exist := 'Y';

                        IF NVL (c3.ann_tsi_amt, 0) = 0
                        THEN
                           EXIT;
                        ELSIF NVL (c3.ann_tsi_amt, 0) + NVL (b3_tsi1, 0) >= NVL (fin_tsi, 0)
                        THEN
                           cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                           EXIT;
                        END IF;
                     END LOOP;

                     IF curr_exist = 'N'
                     THEN
                        FOR c4 IN (SELECT   b380.ann_tsi_amt
                                       FROM gipi_itmperil b380, gipi_polbasic b250
                                      WHERE b250.line_cd = a1.line_cd
                                        AND b250.subline_cd = a1.subline_cd
                                        AND b250.iss_cd = a1.iss_cd
                                        AND b250.issue_yy = a1.issue_yy
                                        AND b250.pol_seq_no = a1.pol_seq_no
                                        AND b250.renew_no = a1.renew_no
                                        AND b250.policy_id = b380.policy_id
                                        AND b380.item_no = p_item_no
                                        AND b380.peril_cd = chk_basic.peril_cd
                                        AND b250.pol_flag IN ('1', '2', '3', 'X')
                                        AND b250.eff_date > v_eff_date
                                        AND b250.eff_date < a1.eff_date
                                        --AND NVL(b250.endt_expiry_date,b250.expiry_date) >= :b240.eff_date
                                        AND TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                                                b250.expiry_date
                                                               ),
                                                           b250.expiry_date, var_expiry_date,
                                                           b250.endt_expiry_date, b250.endt_expiry_date
                                                          )
                                                  ) >= v_eff_date
                                   ORDER BY b250.eff_date DESC)
                        LOOP
                           IF NVL (c4.ann_tsi_amt, 0) = 0
                           THEN
                              EXIT;
                           ELSIF NVL (c4.ann_tsi_amt, 0) + NVL (b3_tsi1, 0) >= NVL (fin_tsi, 0)
                           THEN
                              curr_exist := 'Y';
                              cnt_basic3 := NVL (cnt_basic3, 0) + 1;
                              EXIT;
                           END IF;
                        END LOOP;
                     END IF;
                  END IF;
               END LOOP;
               
               -- bonok :: 06.26.2014 :: validate only when allied peril exists
               IF comp_tsi != 0
               THEN
                  IF comp_tsi < fin_tsi AND NVL (cnt_basic3, 0) < 1
                  THEN
                     raise_application_error (-20001, 'Geniisys Exception#E#Tsi Amount Entered will cause the Ann TSI Amount of this peril in endt no '
                         || a1.endt_no
                         || ' to be less than an allied peril in the same endorsement.');
                  END IF;
               ELSIF NVL (comp_tsi, 0) = 0 AND NVL (cnt_basic3, 0) < 1 AND allied_exist = 'Y'
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#I#This basic peril cannot be zero out because there is an existing allied peril in endt no '
                      || a1.endt_no
                      || ' which has an effecitivity date later than '
                      || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY'));
               END IF;
            END IF;

--            IF :parameter.tsi_limit_sw = 'Y'
--            THEN

               -- bonok :: 06.26.2014 :: validate only when allied peril exists
--               IF comp_tsi != 0
--               THEN
--                  IF comp_tsi < fin_tsi AND NVL (cnt_basic3, 0) < 1
--                  THEN
--                     raise_application_error (-20001, 'Geniisys Exception#E#Tsi Amount Entered will cause the Ann TSI Amount of this peril in endt no '
--                         || a1.endt_no
--                         || ' to be less than an allied peril in the same endorsement.');
--                  END IF;
--               ELSIF NVL (comp_tsi, 0) = 0 AND NVL (cnt_basic3, 0) < 1 AND allied_exist = 'Y'
--               THEN
--                  raise_application_error (-20001, 'Geniisys Exception#I#This basic peril cannot be zero out because there is an existing allied peril in endt no '
--                      || a1.endt_no
--                      || ' which has an effecitivity date later than '
--                      || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY'));
--               END IF;
          --  END IF;
         END IF;
      --END IF;
      ELSIF p_peril_type = 'A'
      THEN
         IF p_basc_perl_cd IS NULL
         THEN
            /*Open allied peril*/
            FOR basic1 IN (SELECT DISTINCT b380.peril_cd
                                      FROM giis_peril a170, gipi_itmperil b380, gipi_polbasic b250
                                     WHERE b250.policy_id = a1.policy_id
                                       AND b250.policy_id = b380.policy_id
                                       AND b380.line_cd = a170.line_cd
                                       AND b380.peril_cd = a170.peril_cd
                                       AND b380.item_no = p_item_no
                                       AND a170.peril_type = 'B'
                                       AND b250.pol_flag IN ('1', '2', '3', 'X'))
            LOOP
               prem_tsi := NULL;

               FOR c1 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                            FROM gipi_itmperil a
                           WHERE a.policy_id = a1.policy_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = basic1.peril_cd)
               LOOP
                  sel_tsi := c1.ann_tsi_amt;
                  v_temp_existing_perils := p_existing_perils;

                  IF LENGTH(v_temp_existing_perils) > 0
                  THEN
                     b_peril := NULL;
                     b_tsi := 0;
                     b_item := NULL;
                     b_line := NULL;

                     WHILE LENGTH(v_temp_existing_perils) > 0
                     LOOP
                        SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                          INTO v_temp_row
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                          INTO b_peril
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                          INTO b_tsi
                          FROM DUAL;
                                                       
                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                          INTO b_item
                          FROM DUAL;

                        SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                          INTO b_line
                          FROM DUAL;                     

                        IF b_peril = basic1.peril_cd AND b_line = v_line_cd
                           AND b_item = p_item_no
                        THEN
                           sel_tsi := NVL (sel_tsi, 0) + NVL (b_tsi, 0);
                        END IF;
                        
                        SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                          INTO v_temp_existing_perils
                          FROM DUAL;  
                                                  
                     END LOOP;
                  END IF;

                  IF NVL (sel_tsi, 0) > 0
                  THEN
                     cnt_basic := NVL (cnt_basic, 0) + 1;
                  END IF;

                  EXIT;
               END LOOP;

               prem_tsi := sel_tsi;

               IF NVL (fin_tsi, 0) = 0 AND NVL (prem_tsi, 0) > 0
               THEN
                  fin_tsi := prem_tsi;
               END IF;

               IF NVL (fin_tsi, 0) < prem_tsi AND NVL (fin_tsi, 0) > 0 AND NVL (prem_tsi, 0) > 0
               THEN
                  fin_tsi := prem_tsi;
               END IF;
            END LOOP;

            IF comp_tsi > fin_tsi-- AND :parameter.tsi_limit_sw = 'Y'
            THEN
               raise_application_error (-20001, 'Geniisys Exception#E#Tsi Amount entered will cause the Ann TSI Amount of this peril '
                          || 'to be greater than one of the basic peril in '
                          || a1.endt_no
                          || '.');
            END IF;
         ELSE
            /*Existing allied peril with basic*/
            prem_tsi := NULL;

            FOR c1 IN (SELECT a.ann_tsi_amt ann_tsi_amt
                         FROM gipi_itmperil a
                        WHERE a.policy_id = a1.policy_id
                          AND a.item_no = p_item_no
                          AND a.peril_cd = p_basc_perl_cd)
            LOOP
               sel_tsi := c1.ann_tsi_amt;
               v_temp_existing_perils := p_existing_perils;

               IF LENGTH(v_temp_existing_perils) > 0
               THEN
                  b_peril := NULL;
                  b_tsi := 0;
                  b_item := NULL;
                  b_line := NULL;

                  WHILE LENGTH(v_temp_existing_perils) > 0
                  LOOP
                    SELECT SUBSTR(v_temp_existing_perils, INSTR(v_temp_existing_perils, ',', 1, 1)+1, INSTR(v_temp_existing_perils, ',', INSTR(v_temp_existing_perils, ',', 1, 2))-INSTR(v_temp_existing_perils, ',', 1, 1)-1) 
                      INTO v_temp_row
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 1)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 2))-INSTR(v_temp_row, '@', 1, 1)-1) 
                      INTO b_peril
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 2)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 3))-INSTR(v_temp_row, '@', 1, 2)-1) 
                      INTO b_tsi
                      FROM DUAL;
                                                   
                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 4)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 5))-INSTR(v_temp_row, '@', 1, 4)-1) 
                      INTO b_item
                      FROM DUAL;

                    SELECT SUBSTR(v_temp_row, INSTR(v_temp_row, '@', 1, 5)+1, INSTR(v_temp_row, '@', INSTR(v_temp_row, '@', 1, 6))-INSTR(v_temp_row, '@', 1, 5)-1) 
                      INTO b_line
                      FROM DUAL;                  
 
                     IF     b_peril = p_basc_perl_cd
                        AND b_line = v_line_cd
                        AND b_item = p_item_no
                     THEN
                        sel_tsi := NVL (sel_tsi, 0) + NVL (b_tsi, 0);
                     END IF;
                        
                    SELECT REPLACE(v_temp_existing_perils, ','||v_temp_row||',') 
                      INTO v_temp_existing_perils
                      FROM DUAL;                       
                  END LOOP;
               END IF;

               EXIT;
            END LOOP;

            prem_tsi := sel_tsi;

            IF fin_tsi < prem_tsi
            THEN
               fin_tsi := prem_tsi;
            END IF;

            IF comp_tsi > fin_tsi --AND :parameter.tsi_limit_sw = 'Y'
            THEN
               raise_application_error (-20001, 'Geniisys Exception#E#Tsi Amount entered will cause the Ann TSI Amount of this peril '
                          || 'to be greater than the basic peril attached to it in '
                          || a1.endt_no
                          || '.');
            END IF;
         END IF;
      END IF;
   END LOOP;
END;
/



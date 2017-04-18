CREATE OR REPLACE PACKAGE BODY CPI.GICLR203A_PKG
AS
   FUNCTION get_giclr_203a_report (
      p_branch_clm_pol      VARCHAR2,
      p_date_sw             VARCHAR2,
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_intermediary_tag    VARCHAR2,
      p_iss_cd              VARCHAR2,
      p_line_cd             VARCHAR2,
      p_line_cd_tag         VARCHAR2,
      p_loss_cat_cd         VARCHAR2,
      p_peril_cd            VARCHAR2,
      p_session_id          VARCHAR2,
      p_subline_cd          VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list         report_type;
      v_pol_iss_cd   gicl_claims.pol_iss_cd%type;
    
   BEGIN
      FOR i IN (SELECT   b.claim_no, DECODE (p_line_cd_tag, '0', p_line_cd_tag, b.line_cd) line_cd, b.loss_cat_cd, DECODE (p_intermediary_tag,
                 '0', p_intermediary_tag, b.intm_type) intm_type, DECODE (p_intermediary_tag, '0', p_intermediary_tag, b.buss_source) intm_ri_no,
                 b.claim_id, b.line_cd line_cd2, b.policy_no, b.assd_no, b.iss_cd, b.incept_date, b.iss_cd iss_cd2, b.expiry_date, b.recovered_amt,
                 b.item_no, b.grouped_item_no, b.peril_cd, b.loss_date, b.clm_file_date, b.clm_stat_cd, b.tsi_amt, b.prem_amt,
                 b.loss_reserve, b.expense_reserve, b.losses_paid, b.expenses_paid
            FROM gicl_res_brdrx_extr b
           WHERE b.session_id = p_session_id
             AND TRUNC (b.loss_date) BETWEEN TRUNC
                                                 (DECODE (p_date_sw,
                                                          1, NVL
                                                               (TO_DATE (p_from_date,
                                                                         'MM-DD-YYYY'
                                                                        ),
                                                                TO_DATE ('01-JAN',
                                                                         'DD-MON'
                                                                        )
                                                               ),
                                                          b.loss_date
                                                         )
                                                 )
                                         AND TRUNC
                                                 (DECODE (p_date_sw,
                                                          1, NVL
                                                               (TO_DATE (p_to_date,
                                                                         'MM-DD-YYYY'
                                                                        ),
                                                                SYSDATE
                                                               ),
                                                          b.loss_date
                                                         )
                                                 )
             AND TRUNC (b.clm_file_date)
                    BETWEEN TRUNC (DECODE (p_date_sw,
                                           2, NVL (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                                                   TO_DATE ('01-JAN', 'DD-MON')
                                                  ),
                                           b.clm_file_date
                                          )
                                  )
                        AND TRUNC (DECODE (p_date_sw,
                                           2, NVL (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                                                   SYSDATE
                                                  ),
                                           b.clm_file_date
                                          )
                                  )
             AND b.line_cd = NVL (p_line_cd, b.line_cd)
             AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             AND b.iss_cd =
                    DECODE (p_branch_clm_pol,
                            1, NVL (p_iss_cd, b.iss_cd),
                            2, b.iss_cd
                           )
             AND NVL (b.pol_iss_cd, '*') =
                    DECODE (p_branch_clm_pol,
                            1, NVL (b.pol_iss_cd, '*'),
                            2, NVL (p_iss_cd, NVL (b.pol_iss_cd, '*'))
                           )
             AND b.loss_cat_cd = NVL (p_loss_cat_cd, b.loss_cat_cd)
             AND b.peril_cd = NVL (TO_NUMBER (p_peril_cd), b.peril_cd)
        ORDER BY line_cd, loss_cat_cd, intm_type, intm_ri_no, claim_no
      
      )
      LOOP
      
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.intm_type := i.intm_type;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := TO_CHAR(i.incept_date, 'mm-dd-yyyy'); --i.incept_date;           -- apollo 7.27.2015 SR#19674
         v_list.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy'); --i.expiry_date;           -- for proper displaying
         v_list.clm_file_date := TO_CHAR(i.clm_file_date, 'mm-dd-yyyy'); --i.clm_file_date;     -- of date in 
         v_list.loss_date := TO_CHAR(i.loss_date, 'mm-dd-yyyy'); --i.loss_date;                 -- print to excel
         v_list.item_name := get_gpa_item_title(i.claim_id,i.line_cd,i.item_no,NVL(i.grouped_item_no,0));
         v_list.tsi_amt := NVL(i.tsi_amt,0);
         v_list.prem_amt := NVL(i.prem_amt,0);
         v_list.loss_reserve := NVL(i.loss_reserve,0);
         v_list.expense_reserve := NVL(i.expense_reserve,0);
         v_list.losses_paid := NVL(i.losses_paid,0);
         v_list.expenses_paid := NVL(i.expenses_paid,0);
         v_list.recovered_amt := NVL(i.recovered_amt,0);
         v_list.intm_type := i.intm_type;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.intm := null;
                  
         BEGIN
           SELECT assd_name
             INTO v_list.assd_name
             FROM giis_assured
            WHERE assd_no = i.assd_no;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.assd_name := NULL;
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_list.ri_iss_cd
             FROM giac_parameters
            WHERE param_name = 'RI_ISS_CD';
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
               v_list.ri_iss_cd := 'RI';
         END;

         BEGIN
           IF i.iss_cd = v_list.ri_iss_cd THEN
              v_list.intm_type_desc := 'REINSURANCE';
           ELSE
              BEGIN
                SELECT intm_desc
                  INTO v_list.intm_type_desc
                  FROM giis_intm_type
                 WHERE intm_type = i.intm_type;
              EXCEPTION
                  WHEN others then
                    v_list.intm_type_desc := NULL;
              END;
           END IF;   
         END;
         
         BEGIN
            v_list.intm_ri_no := TO_NUMBER(NVL(i.intm_RI_no,0));
         END;
         
         BEGIN
           IF i.iss_cd = v_list.ri_iss_cd then
              v_list.intm_ri := 'Reinsurer';
           ELSE
              v_list.intm_ri := 'Intermediary';
           END IF;
         END;
         
           BEGIN
             IF i.iss_cd = v_list.ri_iss_cd then
               BEGIN
                 SELECT ri_name
                   INTO v_list.ri_name
                   FROM giis_reinsurer
                  WHERE ri_cd = i.intm_ri_no;
               EXCEPTION   
                   WHEN NO_DATA_FOUND THEN
                       v_list.ri_name := NULL;
             END;
           ELSE
               BEGIN
                 SELECT intm_name
                   INTO v_list.ri_name
                   FROM giis_intermediary
                  WHERE intm_no = i.intm_ri_no;
               EXCEPTION   
                   WHEN NO_DATA_FOUND THEN
                        v_list.ri_name := NULL;
             END;
           END IF;
         END;
                
         BEGIN
           IF p_date_sw = '1' then
             v_list.date_sw := 'CLAIMS REGISTER (BASED ON LOSS DATE)';
           ELSE
             v_list.date_sw := 'CLAIMS REGISTER (BASED ON CLAIM FILE DATE)';
           END IF;
         END;
         

         BEGIN
           IF NVL(p_line_cd_tag,'1') != '0' then
             v_list.cf_break := 'LINE-LOSS CATEGORY';
          else
             v_list.cf_break := 'LOSS CATEGORY';
          end if;
          if nvl(p_intermediary_tag,'1') != '0' then
             v_list.cf_break := v_list.cf_break || '-INTERMEDIARY';
          end if;
         END;
         
         BEGIN
           IF p_from_date IS NULL THEN
              v_list.date_from := (TO_DATE('01-JAN','DD-MON'));
           ELSE
              v_list.date_from := (TO_DATE(p_from_date,'MM-DD-YYYY'));
           END IF;
           IF p_to_date IS NULL THEN
              v_list.date_to := SYSDATE;
           ELSE
              v_list.date_to := (TO_DATE(p_to_date,'MM-DD-YYYY'));
           END IF;
         END;
         
         BEGIN
              v_list.date_title := TO_CHAR(v_list.date_from,'fmMonth DD, YYYY')||
                  ' to '||TO_CHAR(v_list.date_to,'fmMonth DD, YYYY');
         END;
            
         BEGIN 
           FOR t IN (SELECT a.pol_iss_cd
                       FROM gicl_claims a
                      WHERE a.claim_id= i.claim_id)
           LOOP
                      v_pol_iss_cd := t.pol_iss_cd;
           END LOOP;

           IF v_pol_iss_cd = 'RI' THEN
              FOR k IN (SELECT g.ri_name, a.ri_cd
                          FROM gicl_claims a, giis_reinsurer g
                         WHERE a.claim_id = i.claim_id
                           AND a.ri_cd    = g.ri_cd(+))
              LOOP
               v_list.intm :=(TO_CHAR(k.ri_cd)||chr(10)||(k.ri_name));
              END LOOP;
           ELSE
              FOR j IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                          FROM gicl_intm_itmperil a, giis_intermediary b
                         WHERE a.intm_no = b.intm_no
                           AND a.claim_id = i.claim_id
                           AND a.item_no = i.item_no
                           AND a.peril_cd = i.peril_cd)
             LOOP
              v_list.intm := TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||CHR(10)||
                       j.intm_name||CHR(10)||v_list.intm;
             END LOOP;    
           END IF;
         END;
         
         BEGIN
           IF i.iss_cd = v_list.ri_iss_cd THEN
              v_list.total_per_ri := 'Totals per Reinsurer';
           ELSE
              v_list.total_per_ri := 'Totals per Intermediary';
           END IF;
         END;
         
         BEGIN
           IF v_list.intm_type = v_list.ri_iss_cd THEN
              v_list.total_per_intm_type := 'Reinsurance Totals';
           ELSE
              v_list.total_per_intm_type := 'Totals per Source of Business';
           END IF;  
         END;
         
         BEGIN
           SELECT line_name 
             INTO v_list.line_name
             FROM giis_line
            WHERE line_cd = i.line_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.line_name := NULL;
         END;
         
         BEGIN
           SELECT iss_name
             INTO v_list.branch_name
             FROM giis_issource
            WHERE iss_cd = i.iss_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.branch_name := NULL;
         END;
    
         BEGIN
           SELECT loss_cat_des
             INTO v_list.loss_cat_des
             FROM giis_loss_ctgry
            WHERE loss_cat_cd = i.loss_cat_cd
             AND line_cd = i.line_cd2; --i.line_cd carloR 09.21.2016 SR 23037
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.loss_cat_des := null;
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_list.withdrawn_status
             FROM giac_parameters
            WHERE param_name LIKE 'WITHDRAWN';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_list.withdrawn_status := 'WD';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_list.denied_status
             FROM giac_parameters
            WHERE param_name LIKE 'DENIED';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_list.denied_status := 'DN';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_list.cancelled_status
             FROM giac_parameters
            WHERE param_name like 'CANCELLED';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_list.cancelled_status := 'CC';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_list.closed_status
             FROM giac_parameters
            WHERE param_name LIKE 'CLOSED CLAIM';
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.closed_status := 'CD';
         END;
         
         BEGIN
           IF i.clm_stat_cd NOT IN (v_list.cancelled_status, 
                                   v_list.closed_status,
                                   v_list.denied_status,
                                   v_list.withdrawn_status) THEN
              v_list.clm_stat_desc := 'OPEN';
           ELSE
             BEGIN 
               SELECT clm_stat_desc
                 INTO v_list.clm_stat_desc
                 FROM giis_clm_stat
                WHERE clm_stat_cd = i.clm_stat_cd;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      v_list.clm_stat_desc := 'OPEN';
             END;
           END IF;
         END;
         
         BEGIN
           SELECT peril_name 
             INTO v_list.peril_name
             FROM giis_peril
            WHERE line_cd  = i.line_cd2 --i.line_cd carloR 09.21.2016 SR 23037
              AND peril_cd = i.peril_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.peril_name := null;
         END;
 
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr_203a_report;
   
   /* Added by dren 09.15.2015
   ** For SR 0020264
   ** Added CSV Report for giclr_203a
   */   
   FUNCTION CSV_GICLR203A (
      p_branch_clm_pol      VARCHAR2,
      p_date_sw             VARCHAR2,
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_intermediary_tag    VARCHAR2,
      p_iss_cd              VARCHAR2,
      p_line_cd             VARCHAR2,
      p_line_cd_tag         VARCHAR2,
      p_loss_cat_cd         VARCHAR2,
      p_peril_cd            VARCHAR2,
      p_session_id          VARCHAR2,
      p_subline_cd          VARCHAR2
   )
      RETURN GICLR203A_CSV_TABLE PIPELINED
   IS
      v_list         GICLR203A_CSV_REPORT;
      v_pol_iss_cd   gicl_claims.pol_iss_cd%type;
      v_withdrawn_status    GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
      v_denied_status       GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
      v_cancelled_status    GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
      v_closed_status       GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;        
    
   BEGIN
      FOR i IN (SELECT   b.claim_no, DECODE (p_line_cd_tag, '0', p_line_cd_tag, b.line_cd) line_cd, b.loss_cat_cd, DECODE (p_intermediary_tag,
                 '0', p_intermediary_tag, b.intm_type) intm_type, DECODE (p_intermediary_tag, '0', p_intermediary_tag, b.buss_source) intm_ri_no,
                 b.claim_id, b.line_cd line_cd2, b.policy_no, b.assd_no, b.iss_cd, b.incept_date, b.iss_cd iss_cd2, b.expiry_date, b.recovered_amt,
                 b.item_no, b.grouped_item_no, b.peril_cd, b.loss_date, b.clm_file_date, b.clm_stat_cd, b.tsi_amt, b.prem_amt,
                 b.loss_reserve, b.expense_reserve, b.losses_paid, b.expenses_paid
            FROM gicl_res_brdrx_extr b
           WHERE b.session_id = p_session_id
             AND TRUNC (b.loss_date) BETWEEN TRUNC
                                                 (DECODE (p_date_sw,
                                                          1, NVL
                                                               (TO_DATE (p_from_date,
                                                                         'MM-DD-YYYY'
                                                                        ),
                                                                TO_DATE ('01-JAN',
                                                                         'DD-MON'
                                                                        )
                                                               ),
                                                          b.loss_date
                                                         )
                                                 )
                                         AND TRUNC
                                                 (DECODE (p_date_sw,
                                                          1, NVL
                                                               (TO_DATE (p_to_date,
                                                                         'MM-DD-YYYY'
                                                                        ),
                                                                SYSDATE
                                                               ),
                                                          b.loss_date
                                                         )
                                                 )
             AND TRUNC (b.clm_file_date)
                    BETWEEN TRUNC (DECODE (p_date_sw,
                                           2, NVL (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                                                   TO_DATE ('01-JAN', 'DD-MON')
                                                  ),
                                           b.clm_file_date
                                          )
                                  )
                        AND TRUNC (DECODE (p_date_sw,
                                           2, NVL (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                                                   SYSDATE
                                                  ),
                                           b.clm_file_date
                                          )
                                  )
             AND b.line_cd = NVL (p_line_cd, b.line_cd)
             AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
             AND b.iss_cd =
                    DECODE (p_branch_clm_pol,
                            1, NVL (p_iss_cd, b.iss_cd),
                            2, b.iss_cd
                           )
             AND NVL (b.pol_iss_cd, '*') =
                    DECODE (p_branch_clm_pol,
                            1, NVL (b.pol_iss_cd, '*'),
                            2, NVL (p_iss_cd, NVL (b.pol_iss_cd, '*'))
                           )
             AND b.loss_cat_cd = NVL (p_loss_cat_cd, b.loss_cat_cd)
             AND b.peril_cd = NVL (TO_NUMBER (p_peril_cd), b.peril_cd)
        ORDER BY line_cd, loss_cat_cd, intm_type, intm_ri_no, claim_no
      )
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := TO_CHAR(i.incept_date, 'mm-dd-yyyy'); 
         v_list.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy'); 
         v_list.clm_file_date := TO_CHAR(i.clm_file_date, 'mm-dd-yyyy');  
         v_list.loss_date := TO_CHAR(i.loss_date, 'mm-dd-yyyy'); 
         v_list.item_name := get_gpa_item_title(i.claim_id,i.line_cd,i.item_no,NVL(i.grouped_item_no,0));
         v_list.tsi_amt := NVL(i.tsi_amt,0);
         v_list.prem_amt := NVL(i.prem_amt,0);
         v_list.loss_reserve := NVL(i.loss_reserve,0);
         v_list.expense_reserve := NVL(i.expense_reserve,0);
         v_list.losses_paid := NVL(i.losses_paid,0);
         v_list.expenses_paid := NVL(i.expenses_paid,0);
         v_list.recovered_amt := NVL(i.recovered_amt,0);
         v_list.intm := null;
                  
         BEGIN
           SELECT assd_name
             INTO v_list.assd_name
             FROM giis_assured
            WHERE assd_no = i.assd_no;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.assd_name := NULL;
         END;        
            
         BEGIN 
           FOR t IN (SELECT a.pol_iss_cd
                       FROM gicl_claims a
                      WHERE a.claim_id= i.claim_id)
           LOOP
                      v_pol_iss_cd := t.pol_iss_cd;
           END LOOP;

           IF v_pol_iss_cd = 'RI' THEN
              FOR k IN (SELECT g.ri_name, a.ri_cd
                          FROM gicl_claims a, giis_reinsurer g
                         WHERE a.claim_id = i.claim_id
                           AND a.ri_cd    = g.ri_cd(+))
              LOOP
               v_list.intm :=(TO_CHAR(k.ri_cd)||(k.ri_name));
              END LOOP;
           ELSE
              FOR j IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                          FROM gicl_intm_itmperil a, giis_intermediary b
                         WHERE a.intm_no = b.intm_no
                           AND a.claim_id = i.claim_id
                           AND a.item_no = i.item_no
                           AND a.peril_cd = i.peril_cd)
             LOOP
              v_list.intm := TO_CHAR(j.intm_no)||' / '||j.ref_intm_cd||j.intm_name||v_list.intm;
             END LOOP;    
           END IF;
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_withdrawn_status
             FROM giac_parameters
            WHERE param_name LIKE 'WITHDRAWN';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_withdrawn_status := 'WD';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_denied_status
             FROM giac_parameters
            WHERE param_name LIKE 'DENIED';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_denied_status := 'DN';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_cancelled_status
             FROM giac_parameters
            WHERE param_name like 'CANCELLED';
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  v_cancelled_status := 'CC';
         END;
         
         BEGIN
           SELECT param_value_v
             INTO v_closed_status
             FROM giac_parameters
            WHERE param_name LIKE 'CLOSED CLAIM';
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_closed_status := 'CD';
         END;
         
         BEGIN
           IF i.clm_stat_cd NOT IN (v_cancelled_status, 
                                   v_closed_status,
                                   v_denied_status,
                                   v_withdrawn_status) THEN
              v_list.clm_stat_desc := 'OPEN';
           ELSE
             BEGIN 
               SELECT clm_stat_desc
                 INTO v_list.clm_stat_desc
                 FROM giis_clm_stat
                WHERE clm_stat_cd = i.clm_stat_cd;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      v_list.clm_stat_desc := 'OPEN';
             END;
           END IF;
         END;
         
         BEGIN
           SELECT peril_name 
             INTO v_list.peril_name
             FROM giis_peril
            WHERE line_cd  = i.line_cd2 --i.line_cd carloR 09.21.2016 SR 23037
              AND peril_cd = i.peril_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_list.peril_name := null;
         END;
 
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END CSV_GICLR203A; -- Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203A - End
    
END;
/



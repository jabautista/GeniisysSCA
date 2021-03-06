CREATE OR REPLACE PACKAGE BODY CPI.giclr208lr_pkg
AS
/*
    **  Created by   :  Ildefonso L. Ellarina Jr.
    **  Date Created : 04.12.2013
    **  Reference By : GICLR208LR - OUTSTANDING LOSS  DISTRIBUTION REGISTER
    */
   FUNCTION get_giclr208lr_report (
      p_intm_break    NUMBER,
      p_os_date       NUMBER,
      p_date_option   NUMBER,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_session_id    VARCHAR2, 
      p_claim_id      VARCHAR2
   )
      RETURN get_giclr208lr_report_tab PIPELINED
   IS
      v_list            get_giclr208lr_report_type;
      v_param           VARCHAR2 (100);
      v_pol_iss_cd      gicl_claims.pol_iss_cd%type; 
      v_intm_ri         VARCHAR2(1000);
      v_clm_stat        giis_clm_stat.clm_stat_desc%type;
      v_clm_stat1       giis_clm_stat.clm_stat_desc%type;
      v_outstanding     NUMBER(16,2);
      v_share_type   NUMBER := 0;
      v_xol_amt      NUMBER := 0;
   BEGIN
      v_list.exist := 'N';

      BEGIN
         SELECT param_value_v
           INTO v_list.company_name
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_list.company_name := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_list.company_address := NULL;
      END;

      BEGIN
         IF p_intm_break = 0
         THEN
            v_list.report_title :=
                        'OUTSTANDING LOSS DISTRIBUTION REGISTER - PER BRANCH';
         ELSIF p_intm_break = 1
         THEN
            v_list.report_title :=
                  'OUTSTANDING LOSS DISTRIBUTION REGISTER - PER INTERMEDIARY';
         END IF;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_os_date,
                           1, 'Loss Date',
                           2, 'Claim File Date',
                           3, 'Booking Month'
                          )
              INTO v_param
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param := NULL;
         END;

         v_list.cf_param_date := '(Based on ' || v_param || ')';
      END;

      BEGIN
         IF p_date_option = 1
         THEN
            BEGIN
               SELECT    'from '
                      || TO_CHAR (TO_DATE (p_from_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                      || ' to '
                      || TO_CHAR (TO_DATE (p_to_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                 INTO v_list.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.cf_date := NULL;
            END;
         ELSIF p_date_option = 2
         THEN
            BEGIN
               SELECT    'as of '
                      || TO_CHAR (TO_DATE (p_as_of_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                 INTO v_list.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.cf_date := NULL;
            END;
         END IF;

         FOR txn_temp_rec IN (SELECT   a.brdrx_record_id, a.buss_source,
                                       a.iss_cd, a.line_cd, a.subline_cd,
                                       a.claim_id, a.assd_no, a.claim_no,
                                       a.policy_no, a.clm_file_date,
                                       a.loss_date, a.loss_cat_cd, a.item_no,
                                       a.grouped_item_no, a.peril_cd,
                                       a.intm_no, NVL (a.tsi_amt, 0) tsi_amt,
                                       (  NVL (a.loss_reserve, 0)
                                        - NVL (a.losses_paid, 0)
                                       ) outstanding_loss
                                  FROM gicl_res_brdrx_extr a
                                 WHERE a.session_id = p_session_id
                                   AND a.claim_id =
                                                 NVL (p_claim_id, a.claim_id)
                                   AND (  NVL (a.loss_reserve, 0)
                                        - NVL (a.losses_paid, 0)
                                       ) > 0
                              ORDER BY a.intm_no,a.iss_cd,a.line_cd,a.claim_no)
         LOOP
            v_list.intm_no := txn_temp_rec.intm_no;
            v_list.iss_cd := txn_temp_rec.iss_cd;
            v_list.line_cd := txn_temp_rec.line_cd;
            v_list.claim_no := txn_temp_rec.claim_no;
            v_list.policy_no := txn_temp_rec.policy_no;
            v_list.loss_date := txn_temp_rec.loss_date;
            v_list.clm_file_date := txn_temp_rec.clm_file_date; 
            v_list.item_name := get_gpa_item_title(txn_temp_rec.claim_id,txn_temp_rec.line_cd,txn_temp_rec.item_no,txn_temp_rec.grouped_item_no);
            v_list.tsi_amt := txn_temp_rec.tsi_amt;
            
                       
            BEGIN
              FOR i IN (SELECT intm_name
                          FROM giis_intermediary
                         WHERE intm_no = txn_temp_rec.intm_no)
              LOOP
                v_list.intm_name := i.intm_name;
              END LOOP;    
            END; 
            
            BEGIN
              FOR i IN (SELECT iss_name
                          FROM giis_issource
                         WHERE iss_cd = txn_temp_rec.iss_cd)
              LOOP
                v_list.iss_name := i.iss_name;
              END LOOP;
            END ;
            
            BEGIN
              FOR i IN (SELECT line_name
                          FROM giis_line
                         WHERE line_cd = txn_temp_rec.line_cd)
              LOOP
                v_list.line_name := i.line_name;
              END LOOP;
            END;
            
            BEGIN
              FOR i IN (SELECT assd_name
                          FROM giis_assured
                         WHERE assd_no = txn_temp_rec.assd_no)
              LOOP
                v_list.assd_name := i.assd_name;
              END LOOP;
            END;
            
            BEGIN
              BEGIN
                SELECT pol_iss_cd
                  INTO v_pol_iss_cd 
                  FROM gicl_claims
                 WHERE claim_id = txn_temp_rec.claim_id;   
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_pol_iss_cd := NULL; 
              END;
               
              IF v_pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
                 BEGIN 
                   FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                               FROM gicl_claims a, giis_reinsurer b
                              WHERE a.ri_cd = b.ri_cd
                                AND a.claim_id = txn_temp_rec.claim_id)
                   LOOP
                     v_list.intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
                   END LOOP;
                 END;
              ELSE            
                IF p_intm_break = 1 THEN
                   BEGIN
                     FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name, 
                                      b.ref_intm_cd ref_intm_cd
                                 FROM gicl_res_brdrx_extr a, giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.session_id = p_session_id 
                                  AND a.claim_id = txn_temp_rec.claim_id
                                  AND a.item_no = txn_temp_rec.item_no
                                  AND a.peril_cd = txn_temp_rec.peril_cd
                                  AND a.intm_no = txn_temp_rec.intm_no) 
                     LOOP
                       v_list.intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                                    i.intm_name;
                     END LOOP;
                   END;    
                ELSIF p_intm_break = 0 THEN
                   BEGIN 
                     FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                                FROM gicl_intm_itmperil a, giis_intermediary b
                               WHERE a.intm_no = b.intm_no
                                 AND a.claim_id = txn_temp_rec.claim_id
                                 AND a.item_no = txn_temp_rec.item_no
                                 AND a.peril_cd = txn_temp_rec.peril_cd) 
                     LOOP
                       v_list.intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||
                                    m.intm_name||CHR(10);
                     END LOOP;
                   END; 
                END IF;
              END IF;
            END;
            
            BEGIN
              FOR i IN (SELECT pol_eff_date
                          FROM gicl_claims
                         WHERE claim_id = txn_temp_rec.claim_id)
              LOOP
                v_list.eff_date := i.pol_eff_date;
              END LOOP;
            END;
            
            BEGIN
              FOR i IN (SELECT expiry_date
                          FROM gicl_claims
                         WHERE claim_id = txn_temp_rec.claim_id)
              LOOP
                v_list.expiry_date := i.expiry_date;
              END LOOP;
            END;
            
            BEGIN
              FOR i IN (SELECT loss_cat_des
                          FROM giis_loss_ctgry
                         WHERE line_cd = txn_temp_rec.line_cd
                           AND loss_cat_cd = txn_temp_rec.loss_cat_cd)
              LOOP
                v_list.cf_loss_ctgry := i.loss_cat_des;
              END LOOP;  
            END;
            
            BEGIN
              FOR i IN (SELECT loss_loc1, loss_loc2, loss_loc3
                          FROM gicl_claims
                         WHERE loss_cat_cd = txn_temp_rec.loss_cat_cd
                           AND claim_id = txn_temp_rec.claim_id)
              LOOP
                v_list.location := i.loss_loc1||' '||i.loss_loc2||' '||i.loss_loc3;
              END LOOP;
            END;
            
            BEGIN
              FOR i IN (SELECT peril_name
                          FROM giis_peril
                         WHERE peril_cd = txn_temp_rec.peril_cd
                           AND line_cd = txn_temp_rec.line_cd)
              LOOP
                v_list.peril_name := i.peril_name;
              END LOOP;
            END;
            
            BEGIN
              v_clm_stat := NULL;
                            
              FOR i IN (SELECT b.clm_stat_desc
                          FROM GICL_CLM_LOSS_EXP a, giis_clm_stat b
                         WHERE CLAIM_ID = txn_temp_rec.CLAIM_ID
                           AND NVL(CANCEL_SW,'N') = 'N'
                           AND ITEM_NO = txn_temp_rec.item_no
                           AND PERIL_CD = txn_temp_rec.peril_cd
                           AND CLM_LOSS_ID IN (SELECT MAX(CLM_LOSS_ID) 
                                                 FROM GICL_CLM_LOSS_EXP
                                        WHERE CLAIM_ID = txn_temp_rec.claim_id
                                      AND NVL(CANCEL_SW,'N') = 'N'
                                      AND ITEM_NO = txn_temp_rec.item_no
                                      AND PERIL_CD = txn_temp_rec.peril_cd)
                           AND b.clm_stat_cd = a.item_stat_cd)
              LOOP
                v_clm_stat := i.clm_stat_desc;
              END LOOP;
              
              IF v_clm_stat is NULL THEN
                BEGIN
                  SELECT b.clm_stat_desc
                    INTO v_clm_stat1
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.claim_id = txn_temp_rec.claim_id
                     AND b.clm_stat_cd = a.clm_stat_cd;
                  exception
                    WHEN OTHERS THEN
                      v_clm_stat1 := null;
                END;
                v_list.claim_status := v_clm_stat1;
              ELSE
                v_list.claim_status := v_clm_stat;
              END IF;
            END;
            
            BEGIN

              v_list.outstanding_loss := txn_temp_rec.outstanding_loss;
              
              FOR rcvry IN
                (SELECT recovered_amt
                   FROM gicl_rcvry_brdrx_extr
                  WHERE session_id = p_session_id
                    AND claim_id = NVL(p_claim_id, claim_id)
                    AND item_no = txn_temp_rec.item_no
                    AND peril_cd = txn_temp_rec.peril_cd
                    AND payee_type = 'L')
              LOOP
                v_list.outstanding_loss := NVL(v_list.outstanding_loss, 0) - rcvry.recovered_amt;
              END LOOP;           
            END;
            
            BEGIN

              v_outstanding := 0;
              
              FOR i IN
                (SELECT (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) outstanding_loss, a.grp_seq_no,
                        a.claim_id, a.item_no, a.peril_cd
                   FROM gicl_res_brdrx_ds_extr a
                  WHERE a.session_id = p_session_id
                    AND a.grp_seq_no IN (SELECT b.share_cd
                                           FROM giis_dist_share b
                                          WHERE b.line_cd = txn_temp_rec.line_cd
                                            AND b.share_type = 1)
                    AND a.claim_id = txn_temp_rec.claim_id
                    AND a.item_no = txn_temp_rec.item_no
                    AND a.peril_cd = txn_temp_rec.peril_cd
                    AND (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) > 0) 
              LOOP
                v_outstanding :=  i.outstanding_loss + v_outstanding;
              END LOOP;

              FOR j IN
                (SELECT SUM(shr_recovery_amt) recovered_amt
                   FROM gicl_rcvry_brdrx_ds_extr
                  WHERE session_id = p_session_id
                    AND claim_id = txn_temp_rec.claim_id
                    AND item_no = txn_temp_rec.item_no
                    AND peril_cd = txn_temp_rec.peril_cd
                    AND grp_seq_no IN (SELECT b.share_cd
                                         FROM giis_dist_share b
                                        WHERE b.line_cd = txn_temp_rec.line_cd
                                          AND b.share_type = 1)
                    AND payee_type = 'L')
              LOOP
                IF j.recovered_amt IS NOT NULL THEN
                   v_outstanding :=  v_outstanding - j.recovered_amt;
                END IF;
              END LOOP;
              v_list.cf_share_type1 := v_outstanding;
            END;
            
            BEGIN
            	
              v_outstanding := 0;

              FOR i IN 
                (SELECT (NVL(a.loss_reserve,0) - NVL(a.losses_paid,0)) outstanding_loss
                   FROM gicl_res_brdrx_ds_extr a
                  WHERE a.session_id = p_session_id
                    AND a.grp_seq_no IN (SELECT b.share_cd
                                           FROM giis_dist_share b
                                          WHERE b.line_cd = txn_temp_rec.line_cd
                                            AND b.share_type = 2)
                    AND a.claim_id = txn_temp_rec.claim_id
                    AND a.item_no = txn_temp_rec.item_no
                    AND a.peril_cd = txn_temp_rec.peril_cd
                    AND (NVL(a.loss_reserve,0) - NVL(a.losses_paid,0)) > 0)
              LOOP
                v_outstanding :=  i.outstanding_loss + v_outstanding;
              END LOOP;

              FOR j IN
                (SELECT SUM(shr_recovery_amt) recovered_amt
                   FROM gicl_rcvry_brdrx_ds_extr
                  WHERE claim_id = txn_temp_rec.claim_id
                    AND item_no = txn_temp_rec.item_no
                    AND peril_cd = txn_temp_rec.peril_cd
                    AND grp_seq_no IN (SELECT b.share_cd
                                         FROM giis_dist_share b
                                        WHERE b.line_cd = txn_temp_rec.line_cd
                                          AND b.share_type = 2)
                    AND payee_type = 'L')
              LOOP
                IF j.recovered_amt IS NOT NULL THEN
                     v_outstanding :=  v_outstanding - j.recovered_amt;
                END IF;
              END LOOP;
              v_list.cf_share_type2 := v_outstanding;              
            END;
            
            BEGIN
	
              v_outstanding := 0;

              FOR i IN 
                (SELECT (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) outstanding_loss
                   FROM gicl_res_brdrx_ds_extr a
                  WHERE a.session_id = p_session_id
                    AND a.grp_seq_no IN (SELECT b.share_cd
                                           FROM giis_dist_share b
                                          WHERE b.line_cd = txn_temp_rec.line_cd
                                            AND b.share_type = 3)
                    AND a.claim_id = txn_temp_rec.claim_id
                    AND a.item_no = txn_temp_rec.item_no
                    AND a.peril_cd = txn_temp_rec.peril_cd
                    AND (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) > 0)
              LOOP
                v_outstanding :=  i.outstanding_loss + v_outstanding;
              END LOOP;

              FOR j IN
                (SELECT SUM(shr_recovery_amt) recovered_amt
                   FROM gicl_rcvry_brdrx_ds_extr
                  WHERE claim_id = txn_temp_rec.claim_id
                    AND item_no = txn_temp_rec.item_no
                    AND peril_cd = txn_temp_rec.peril_cd
                    AND grp_seq_no IN (SELECT b.share_cd
                                         FROM giis_dist_share b
                                        WHERE b.line_cd = txn_temp_rec.line_cd
                                          AND b.share_type = 3)
                    AND payee_type = 'L')
              LOOP
                IF j.recovered_amt IS NOT NULL THEN
                     v_outstanding :=  v_outstanding - j.recovered_amt;
                END IF;
              END LOOP;
              v_list.cf_share_type3 := v_outstanding;               
            END;

            BEGIN
               v_xol_amt := 0;

              BEGIN
                SELECT param_value_v
                  INTO v_share_type
                  FROM giac_parameters
                 WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';
              END;
            	
              
              FOR rec IN 
                (SELECT (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) outstanding_loss
                   FROM gicl_res_brdrx_ds_extr a
                  WHERE a.session_id = p_session_id
                    AND a.grp_seq_no IN (SELECT b.share_cd
                                           FROM giis_dist_share b
                                          WHERE b.line_cd = txn_temp_rec.line_cd
                                            AND b.share_type = v_share_type)
                    AND a.claim_id = txn_temp_rec.claim_id
                    AND a.item_no = txn_temp_rec.item_no
                    AND a.peril_cd = txn_temp_rec.peril_cd
                    AND (NVL(a.loss_reserve, 0) - NVL(a.losses_paid, 0)) > 0)
              LOOP    
                v_xol_amt := v_xol_amt + rec.outstanding_loss;
              END LOOP;
              
              FOR j IN
                (SELECT SUM(shr_recovery_amt) recovered_amt
                   FROM gicl_rcvry_brdrx_ds_extr
                  WHERE claim_id = txn_temp_rec.claim_id
                    AND item_no = txn_temp_rec.item_no
                    AND peril_cd = txn_temp_rec.peril_cd
                    AND grp_seq_no IN (SELECT b.share_cd
                                         FROM giis_dist_share b
                                        WHERE b.line_cd = txn_temp_rec.line_cd
                                          AND b.share_type = v_share_type)
                    AND payee_type = 'L')
              LOOP
                IF j.recovered_amt IS NOT NULL THEN
                   v_xol_amt := v_xol_amt - j.recovered_amt;
                END IF;
              END LOOP;              
              v_list.cf_share_type4 := v_xol_amt;              
            END;
            
            BEGIN
              BEGIN
                SELECT (NVL(v_list.cf_share_type2,0) + NVL(v_list.cf_share_type3,0))
                  INTO v_list.recoverable
                  FROM dual;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   v_list.recoverable := null;
              END;
            END;
      
            v_list.exist := 'Y';
         
            PIPE ROW (v_list);
         END LOOP;
      END;
      
      IF v_list.exist = 'N' THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.company_name := NULL;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.company_address := NULL;
         END;
         
         BEGIN
            IF p_intm_break = 0
            THEN
               v_list.report_title :=
                           'OUTSTANDING LOSS DISTRIBUTION REGISTER - PER BRANCH';
            ELSIF p_intm_break = 1
            THEN
               v_list.report_title :=
                     'OUTSTANDING LOSS DISTRIBUTION REGISTER - PER INTERMEDIARY';
            END IF;
         END;

         BEGIN
            BEGIN
               SELECT DECODE (p_os_date,
                              1, 'Loss Date',
                              2, 'Claim File Date',
                              3, 'Booking Month'
                             )
                 INTO v_param
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_param := NULL;
            END;

            v_list.cf_param_date := '(Based on ' || v_param || ')';
         END;
         
         IF p_date_option = 1
         THEN
            BEGIN
               SELECT    'from '
                      || TO_CHAR (TO_DATE (p_from_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                      || ' to '
                      || TO_CHAR (TO_DATE (p_to_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                 INTO v_list.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.cf_date := NULL;
            END;
         ELSIF p_date_option = 2
         THEN
            BEGIN
               SELECT    'as of '
                      || TO_CHAR (TO_DATE (p_as_of_date,'MM-DD-YYYY'), 'fmMonth DD, YYYY')
                 INTO v_list.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.cf_date := NULL;
            END;
         END IF;
         
         PIPE ROW(v_list);
      END IF;

      RETURN;
   END get_giclr208lr_report;
END giclr208lr_pkg;
/



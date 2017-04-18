CREATE OR REPLACE PACKAGE BODY CPI.giclr209e_pkg
AS
/*
    **  Created by   :  Ildefonso L. Ellarina Jr.
    **  Date Created : 04.15.2013
    **  Reference By : GICLR209E - LOSS EXPENSES PAID DISTRIBUTION REGISTER
    */
    FUNCTION cf_trandateformula(
        p_claim_id      NUMBER,
        p_clm_loss_id   NUMBER,
        p_paid_date     NUMBER,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_paid_loss     NUMBER    
    )
       RETURN VARCHAR2
    IS
       v_tran_date     VARCHAR2 (100);
       var_tran_date   VARCHAR2 (200);
       v_loss          NUMBER;
    BEGIN
       FOR a IN (SELECT SIGN (p_paid_loss) expenses_paid
                   FROM DUAL)
       LOOP
          v_loss := a.expenses_paid;

          IF v_loss < 1 THEN
             FOR d1 IN (SELECT DISTINCT TO_CHAR (a.date_paid, 'MM-DD-RRRR') tran_date, TO_CHAR (a.cancel_date, 'MM-DD-RRRR') cancel_date
                                   FROM gicl_clm_res_hist a, giac_acctrans b, giac_reversals c
                                  WHERE a.tran_id = c.gacc_tran_id 
                                    AND b.tran_id = c.reversing_tran_id 
                                    AND a.claim_id = p_claim_id 
                                    AND a.clm_loss_id = p_clm_loss_id)
             LOOP
                v_tran_date := d1.tran_date || CHR (10) || 'cancelled ' || d1.cancel_date;

                IF var_tran_date IS NULL THEN
                   var_tran_date := v_tran_date;
                ELSE
                   var_tran_date := v_tran_date || CHR (10) || var_tran_date;
                END IF;
             END LOOP;
          ELSE
             FOR d2 IN (SELECT DISTINCT TO_CHAR (a.date_paid, 'MM-DD-RRRR') tran_date
                                   FROM gicl_clm_res_hist a, giac_acctrans b
                                  WHERE a.claim_id = p_claim_id
                                    AND a.clm_loss_id = p_clm_loss_id
                                    AND a.tran_id = b.tran_id
                                    AND DECODE (p_paid_date, 1, TRUNC (a.date_paid), 2, TRUNC (b.posting_date)) 
                                    BETWEEN TO_DATE(p_from_date,'mm-dd-yyyy') AND TO_DATE(p_to_date,'mm-dd-yyyy'))
             LOOP
                v_tran_date := d2.tran_date;

                IF var_tran_date IS NULL THEN
                   var_tran_date := v_tran_date;
                ELSE
                   var_tran_date := v_tran_date || CHR (10) || var_tran_date;
                END IF;
             END LOOP;
          END IF;
       END LOOP;

       RETURN (var_tran_date);
    END;      
   FUNCTION get_giclr209e_report (
      p_intm_break   NUMBER,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2
   )
      RETURN get_giclr209e_report_tab PIPELINED
   IS
      v_list          get_giclr209e_report_type;
      v_param         VARCHAR2 (100);
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri       VARCHAR2 (1000);
      v_clm_stat      giis_clm_stat.clm_stat_desc%TYPE;
      v_clm_stat1     giis_clm_stat.clm_stat_desc%TYPE;
      var_clm_stat    VARCHAR2 (500);
      v_paid          NUMBER (16, 2);
      v_share_type    NUMBER                             := 0;
      v_xol_amt       NUMBER                             := 0;
      v_tran_date     VARCHAR2 (100);
      var_tran_date   VARCHAR2 (200);
      v_loss          NUMBER;
      v_not_exist     BOOLEAN := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.company_name
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_name := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_address := NULL;
      END;

      BEGIN
         IF p_intm_break = 0
         THEN
            v_list.report_title :=
                      'LOSS EXPENSES PAID DISTRIBUTION REGISTER - PER BRANCH';
         ELSIF p_intm_break = 1
         THEN
            v_list.report_title :=
                'LOSS EXPENSES PAID DISTRIBUTION REGISTER - PER INTERMEDIARY';
         END IF;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
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
         SELECT    'from '
                || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                            'fmMonth DD, YYYY'
                           )
           INTO v_list.cf_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_date := NULL;
      END;

      BEGIN
         FOR txn_temp_rec IN (SELECT   a.brdrx_record_id, a.buss_source,
                                       a.iss_cd, a.line_cd, a.subline_cd,
                                       a.claim_id, a.assd_no, a.claim_no,
                                       a.policy_no, a.clm_file_date,
                                       a.loss_date, a.loss_cat_cd, a.item_no,
                                       a.grouped_item_no, a.peril_cd,
                                       a.intm_no, a.clm_loss_id,
                                       NVL (a.tsi_amt, 0) tsi_amt,
                                       NVL (a.expenses_paid, 0) paid_loss,
                                       a.pd_date_opt
                                  FROM gicl_res_brdrx_extr a
                                 WHERE a.session_id = p_session_id
                                   AND a.claim_id =
                                                  NVL (p_claim_id, a.claim_id)
                                   AND NVL (a.expenses_paid, 0) <> 0
                              ORDER BY a.intm_no,
                                       a.iss_cd,
                                       a.line_cd,
                                       a.claim_no)
         LOOP
            v_list.flag := 'N';
            v_not_exist := FALSE;
            v_list.intm_no := txn_temp_rec.intm_no;
            v_list.iss_cd := txn_temp_rec.iss_cd;
            v_list.line_cd := txn_temp_rec.line_cd;
            v_list.claim_no := txn_temp_rec.claim_no;
            v_list.policy_no := txn_temp_rec.policy_no;
            v_list.loss_date := txn_temp_rec.loss_date;
            v_list.clm_file_date := txn_temp_rec.clm_file_date;
            v_list.item_name :=
               get_gpa_item_title (txn_temp_rec.claim_id,
                                   txn_temp_rec.line_cd,
                                   txn_temp_rec.item_no,
                                   txn_temp_rec.grouped_item_no
                                  );
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
            END;

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
                  WHEN NO_DATA_FOUND
                  THEN
                     v_pol_iss_cd := NULL;
               END;

               IF v_pol_iss_cd = giacp.v ('RI_ISS_CD')
               THEN
                  BEGIN
                     FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                                 FROM gicl_claims a, giis_reinsurer b
                                WHERE a.ri_cd = b.ri_cd
                                  AND a.claim_id = txn_temp_rec.claim_id)
                     LOOP
                        v_list.intm_ri :=
                                         TO_CHAR (r.ri_cd) || '/'
                                         || r.ri_name;
                     END LOOP;
                  END;
               ELSE
                  IF p_intm_break = 1
                  THEN
                     BEGIN
                        FOR i IN (SELECT a.intm_no intm_no,
                                         b.intm_name intm_name,
                                         b.ref_intm_cd ref_intm_cd
                                    FROM gicl_res_brdrx_extr a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.session_id = p_session_id
                                     AND a.claim_id = txn_temp_rec.claim_id
                                     AND a.item_no = txn_temp_rec.item_no
                                     AND a.peril_cd = txn_temp_rec.peril_cd
                                     AND a.intm_no = txn_temp_rec.intm_no)
                        LOOP
                           v_list.intm_ri :=
                                 TO_CHAR (i.intm_no)
                              || '/'
                              || i.ref_intm_cd
                              || '/'
                              || i.intm_name;
                        END LOOP;
                     END;
                  ELSIF p_intm_break = 0
                  THEN
                     BEGIN
                        FOR m IN (SELECT a.intm_no, b.intm_name,
                                         b.ref_intm_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = txn_temp_rec.claim_id
                                     AND a.item_no = txn_temp_rec.item_no
                                     AND a.peril_cd = txn_temp_rec.peril_cd)
                        LOOP
                           v_list.intm_ri :=
                                 TO_CHAR (m.intm_no)
                              || '/'
                              || m.ref_intm_cd
                              || '/'
                              || m.intm_name
                              || CHR (10);
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
                  v_list.LOCATION :=
                      i.loss_loc1 || ' ' || i.loss_loc2 || ' ' || i.loss_loc3;
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
               var_clm_stat := NULL;

               FOR i IN (SELECT b.le_stat_desc
                           FROM gicl_clm_loss_exp a, gicl_le_stat b
                          WHERE claim_id = txn_temp_rec.claim_id
                            AND NVL (cancel_sw, 'N') = 'N'
                            AND item_no = txn_temp_rec.item_no
                            AND peril_cd = txn_temp_rec.peril_cd
                            AND clm_loss_id = txn_temp_rec.clm_loss_id
                            AND payee_type = 'E'
                            AND b.le_stat_cd = a.item_stat_cd)
               LOOP
                  v_clm_stat := i.le_stat_desc;

                  IF var_clm_stat IS NULL
                  THEN
                     var_clm_stat := v_clm_stat;
                  ELSE
                     var_clm_stat :=
                                 v_clm_stat || '/' || CHR (10)
                                 || var_clm_stat;
                  END IF;
               END LOOP;

               IF var_clm_stat IS NULL
               THEN
                  BEGIN
                     SELECT b.clm_stat_desc
                       INTO v_clm_stat1
                       FROM gicl_claims a, giis_clm_stat b
                      WHERE a.claim_id = txn_temp_rec.claim_id
                        AND b.clm_stat_cd = a.clm_stat_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_clm_stat1 := NULL;
                  END;

                  v_list.claim_status := v_clm_stat1;
               ELSE
                  v_list.claim_status := var_clm_stat;
               END IF;
            END;

            BEGIN
               v_list.paid_loss := txn_temp_rec.paid_loss;

               FOR rcvry IN (SELECT recovered_amt
                               FROM gicl_rcvry_brdrx_extr
                              WHERE session_id = p_session_id
                                AND claim_id = NVL (p_claim_id, claim_id)
                                AND item_no = txn_temp_rec.item_no
                                AND peril_cd = txn_temp_rec.peril_cd
                                AND payee_type = 'L')
               LOOP
                  v_list.paid_loss :=
                               NVL (v_list.paid_loss, 0)
                               - rcvry.recovered_amt;
               END LOOP;
            END;

            BEGIN
               v_paid := 0;

               FOR i IN
                  (SELECT NVL (a.expenses_paid, 0) paid_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = txn_temp_rec.line_cd
                                AND a.share_type = 1)
                      AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                      AND a.item_no = txn_temp_rec.item_no
                      AND a.peril_cd = txn_temp_rec.peril_cd
                      AND a.brdrx_record_id = txn_temp_rec.brdrx_record_id
                      AND NVL (a.expenses_paid, 0) <> 0)
               LOOP
                  v_paid := v_paid + i.paid_loss;
               END LOOP;

               v_list.cf_share_type1 := v_paid;
            END;

            BEGIN
               v_paid := 0;

               FOR i IN
                  (SELECT NVL (a.expenses_paid, 0) paid_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = txn_temp_rec.line_cd
                                AND a.share_type = 2)
                      AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                      AND a.item_no = txn_temp_rec.item_no
                      AND a.peril_cd = txn_temp_rec.peril_cd
                      AND a.brdrx_record_id = txn_temp_rec.brdrx_record_id
                      AND NVL (a.expenses_paid, 0) <> 0)
               LOOP
                  v_paid := i.paid_loss + v_paid;
               END LOOP;

               v_list.cf_share_type2 := v_paid;
            END;

            BEGIN
               v_paid := 0;

               FOR i IN
                  (SELECT NVL (a.expenses_paid, 0) paid_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = txn_temp_rec.line_cd
                                AND a.share_type = 3)
                      AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                      AND a.item_no = txn_temp_rec.item_no
                      AND a.peril_cd = txn_temp_rec.peril_cd
                      AND a.brdrx_record_id = txn_temp_rec.brdrx_record_id
                      AND NVL (a.expenses_paid, 0) <> 0)
               LOOP
                  v_paid := i.paid_loss + v_paid;
               END LOOP;

               v_list.cf_share_type3 := v_paid;
            END;

            BEGIN
               BEGIN
                  SELECT param_value_v
                    INTO v_share_type
                    FROM giac_parameters
                   WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';
               END;

               FOR rec IN (SELECT NVL (a.expenses_paid, 0) paid_loss
                             FROM gicl_res_brdrx_ds_extr a
                            WHERE a.session_id = p_session_id
                              AND a.grp_seq_no IN (
                                     SELECT a.share_cd
                                       FROM giis_dist_share a
                                      WHERE a.line_cd = txn_temp_rec.line_cd
                                        AND a.share_type = v_share_type)
                              AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                              AND a.item_no = txn_temp_rec.item_no
                              AND a.peril_cd = txn_temp_rec.peril_cd
                              AND a.brdrx_record_id = txn_temp_rec.brdrx_record_id
                              AND NVL (a.expenses_paid, 0) <> 0)
               LOOP
                  v_xol_amt := v_xol_amt + rec.paid_loss;
               END LOOP;              

               v_list.cf_share_type4 := v_xol_amt;
            END;

            BEGIN
               BEGIN
                  SELECT (  NVL (v_list.cf_share_type2, 0)
                          + NVL (v_list.cf_share_type3, 0)
                         )
                    INTO v_list.RECOVERABLE
                    FROM DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.RECOVERABLE := NULL;
               END;
            END;

--            BEGIN
--               FOR a IN (SELECT SIGN (txn_temp_rec.paid_loss) expenses_paid
--                           FROM DUAL)
--               LOOP
--                  v_loss := a.expenses_paid;

--                  IF v_loss < 1
--                  THEN
--                     FOR d1 IN
--                        (SELECT DISTINCT TO_CHAR (a.date_paid,
--                                                  'MM-DD-RRRR'
--                                                 ) tran_date,
--                                         TO_CHAR (a.cancel_date,
--                                                  'MM-DD-RRRR'
--                                                 ) cancel_date
--                                    FROM gicl_clm_res_hist a,
--                                         giac_acctrans b,
--                                         giac_reversals c
--                                   WHERE a.tran_id = c.gacc_tran_id
--                                     AND b.tran_id = c.reversing_tran_id
--                                     AND a.claim_id = txn_temp_rec.claim_id
--                                     AND a.clm_loss_id =
--                                                      txn_temp_rec.clm_loss_id)
--                     LOOP
--                        v_tran_date :=
--                              d1.tran_date
--                           || CHR (10)
--                           || 'cancelled '||CHR (10)
--                           || d1.cancel_date;

--                        IF var_tran_date IS NULL
--                        THEN
--                           var_tran_date := v_tran_date;
--                        ELSE
--                           var_tran_date :=
--                                      v_tran_date || CHR (10)
--                                      || var_tran_date;
--                        END IF;
--                     END LOOP;
--                  ELSE
--                     FOR d2 IN
--                        (SELECT DISTINCT TO_CHAR (a.date_paid,
--                                                  'MM-DD-RRRR'
--                                                 ) tran_date
--                                    FROM gicl_clm_res_hist a,
--                                         giac_acctrans b
--                                   WHERE a.claim_id = txn_temp_rec.claim_id
--                                     AND a.clm_loss_id =
--                                                      txn_temp_rec.clm_loss_id
--                                     AND a.tran_id = b.tran_id
--                                     AND DECODE (p_paid_date,
--                                                 1, TRUNC (a.date_paid),
--                                                 2, TRUNC (b.posting_date)
--                                                ) BETWEEN TO_DATE
--                                                                 (p_from_date,
--                                                                  'mm-dd-yyyy'
--                                                                 )
--                                                      AND TO_DATE
--                                                                 (p_to_date,
--                                                                  'mm-dd-yyyy'
--                                                                 ))
--                     LOOP
--                        v_tran_date := d2.tran_date;

--                        IF var_tran_date IS NULL
--                        THEN
--                           var_tran_date := v_tran_date;
--                        ELSE
--                           var_tran_date :=
--                                      v_tran_date || CHR (10)
--                                      || var_tran_date;
--                        END IF;
--                     END LOOP;
--                  END IF;
--               END LOOP;

--               v_list.tran_date := var_tran_date;
--            END;
            
            --v_list.tran_date := giclr209e_pkg.cf_trandateformula(txn_temp_rec.claim_id, txn_temp_rec.clm_loss_id, p_paid_date, p_from_date, p_to_date, txn_temp_rec.paid_loss);
            v_list.tran_date := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(txn_temp_rec.claim_id, TO_DATE (p_from_date, 'MM-DD-YYYY'), TO_DATE (p_to_date, 'MM-DD-YYYY'), txn_temp_rec.pd_date_opt, 'E', 'TRAN_DATE');
            PIPE ROW (v_list);
         END LOOP;
      END;
      
     IF v_not_exist THEN
        v_list.flag  := 'Y';
        PIPE ROW(v_list);
     END IF;       

      RETURN;
   END get_giclr209e_report;
END giclr209e_pkg;
/



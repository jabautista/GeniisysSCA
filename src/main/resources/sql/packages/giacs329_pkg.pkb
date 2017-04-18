CREATE OR REPLACE PACKAGE BODY CPI.giacs329_pkg
AS
   /* Created by : Joms Diago
   ** Date Created : 07.04.2013
   */
   FUNCTION validate_date_params (p_as_of_date VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
      v_count   NUMBER := 0;
   BEGIN 
      -- marco - 07.25.2014
      SELECT COUNT(1)
        INTO v_count
        FROM GIAC_AGING_PREM_REP_EXT
       WHERE user_id = p_user_id;
       
      IF v_count = 0 THEN
         RETURN 'X';
      END IF;
      
      SELECT DISTINCT 'Y' 
                 INTO v_exist
                 FROM giac_aging_prem_rep_ext
                WHERE user_id = p_user_id
                  AND as_of_date = TO_DATE (p_as_of_date, 'MM-DD-RRRR');

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END;
/*Modified by pjsantos 11/16/2016 for optimization GENQA 5187*/
   PROCEDURE extract_giacs329 (
      p_as_of_date         DATE,
      p_branch_cd          giac_branches.branch_cd%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_intm_type          VARCHAR2, --marco - 08.05.2014 - added
      p_intm_no            NUMBER,   --
      p_exists       OUT   VARCHAR2
   )
   IS
      v_include_rec        NUMBER                                        := 1;
      v_row_counter        NUMBER                                        := 0;
      v_assd_name          giac_aging_prem_rep_ext.assd_name%TYPE;
      v_intm_name          giac_aging_prem_rep_ext.intm_name%TYPE;
      v_age                giac_aging_parameters.max_no_days%TYPE;
      v_inst_no            giac_aging_prem_rep_ext.inst_no%TYPE;
      v_iss_cd             giac_aging_prem_rep_ext.iss_cd%TYPE;
      v_prem_seq_no        giac_aging_prem_rep_ext.prem_seq_no%TYPE;
      v_aging_id           giac_aging_prem_rep_ext.aging_id%TYPE;
      v_balance_amt_due    giac_aging_prem_rep_ext.balance_amt_due%TYPE  := 0;
      v_collection_amt     giac_direct_prem_collns.collection_amt%TYPE   := 0;
      v_fund_cd            giac_parameters.param_value_v%TYPE:=GIACP.V('FUND_CD');
      v_intm_type          giis_intermediary.intm_type%TYPE;
      v_column_no          giac_aging_prem_rep_ext.column_no%TYPE;
      v_column_title       giac_aging_prem_rep_ext.column_title%TYPE;
      v_prem_bal_due       giac_aging_prem_rep_ext.prem_bal_due%TYPE     := 0;
      v_tax_bal_due        giac_aging_prem_rep_ext.tax_bal_due%TYPE      := 0;
      v_inv_no             giac_aging_prem_rep_ext.ref_inv_no%TYPE;
      v_last_update        giac_aging_prem_rep_ext.last_update%TYPE;
      al_id                NUMBER;
      v_temp_col           NUMBER;
      v_due_tag            giac_aging_prem_rep_ext.due_tag%TYPE;
      v_parent_intm_no     giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag            giis_intermediary.lic_tag%TYPE;
      var_parent_intm_no   giis_intermediary.parent_intm_no%TYPE;
      var_lic_tag          giis_intermediary.lic_tag%TYPE;
      var_intm_no          giis_intermediary.intm_no%TYPE;
      v_assd_no            NUMBER;
      v_special_pol        VARCHAR2 (1);
      v_as_off_date        giac_aging_prem_rep_ext.as_of_date%TYPE;
      v_policy_id          gipi_polbasic.policy_id%TYPE;
      v_afterdate_coll     giac_aging_prem_rep_ext.afterdate_coll%TYPE   := 0;
      v_afterdate_prem     giac_aging_prem_rep_ext.afterdate_prem%TYPE   := 0;
      v_afterdate_tax      giac_aging_prem_rep_ext.afterdate_tax%TYPE;
      iss_cd_var           gipi_invoice.iss_cd%TYPE;
      prem_seq_var         gipi_invoice.prem_seq_no%TYPE;
      v_intm_no            giis_intermediary.intm_no%TYPE;
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);
      TYPE prem_rec IS RECORD (
           fund_cd              giac_aging_prem_rep_ext.fund_cd%TYPE, 
           branch_cd            giac_aging_prem_rep_ext.branch_cd%TYPE,
           intm_no              giac_aging_prem_rep_ext.intm_no%TYPE,
           intm_name            giac_aging_prem_rep_ext.intm_name%TYPE,
           intm_type            giac_aging_prem_rep_ext.intm_type%TYPE,
           assd_no              giac_aging_prem_rep_ext.assd_no%TYPE,
           assd_name            giac_aging_prem_rep_ext.assd_name%TYPE,
           policy_no            giac_aging_prem_rep_ext.policy_no%TYPE,
           iss_cd               giac_aging_prem_rep_ext.iss_cd%TYPE,
           prem_seq_no          giac_aging_prem_rep_ext.prem_seq_no%TYPE,
           inst_no              giac_aging_prem_rep_ext.inst_no%TYPE,
           due_date             giac_aging_prem_rep_ext.due_date%TYPE, 
           aging_id             giac_aging_prem_rep_ext.aging_id%TYPE,
           column_no            giac_aging_prem_rep_ext.column_no%TYPE,
           column_title         giac_aging_prem_rep_ext.column_title%TYPE,
           balance_amt_due      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
           prem_bal_due         giac_aging_prem_rep_ext.prem_bal_due%TYPE,
           tax_bal_due          giac_aging_prem_rep_ext.tax_bal_due%TYPE, 
           ref_pol_no           giac_aging_prem_rep_ext.ref_pol_no%TYPE,
           ref_inv_no           giac_aging_prem_rep_ext.ref_inv_no%TYPE, 
           user_id              giac_aging_prem_rep_ext.user_id%TYPE, 
           last_update          giac_aging_prem_rep_ext.last_update%TYPE,
           no_of_days           giac_aging_prem_rep_ext.no_of_days%TYPE,
           due_tag              giac_aging_prem_rep_ext.due_tag%TYPE, 
           lic_tag              giac_aging_prem_rep_ext.lic_tag%TYPE, 
           parent_intm_no       giac_aging_prem_rep_ext.parent_intm_no%TYPE,
           spld_date            giac_aging_prem_rep_ext.spld_date%TYPE, 
           incept_date          giac_aging_prem_rep_ext.incept_date%TYPE,
           expiry_date          giac_aging_prem_rep_ext.expiry_date%TYPE, 
           as_of_date           giac_aging_prem_rep_ext.as_of_date%TYPE,
           afterdate_coll       giac_aging_prem_rep_ext.afterdate_coll%TYPE,
           afterdate_prem       giac_aging_prem_rep_ext.afterdate_prem%TYPE,
           afterdate_tax        giac_aging_prem_rep_ext.afterdate_tax%TYPE, 
           line_cd              giac_aging_prem_rep_ext.line_cd%TYPE
        );  
        
      TYPE prem_tbl IS TABLE OF  prem_rec;
      prem_rcvbl_list  prem_tbl:=prem_tbl();
      
        TYPE    POLICY_ID_TAB           IS TABLE OF    giac_soa_rep_v.policy_id%TYPE;
        TYPE    POLICY_NO_TAB           IS TABLE OF    giac_soa_rep_v.policy_no%TYPE;
        TYPE    ASSD_NO_TAB             IS TABLE OF    giac_soa_rep_v.assd_no%TYPE;
        TYPE    ISS_CD_TAB              IS TABLE OF    giac_soa_rep_v.iss_cd%TYPE;
        TYPE    CRED_BRANCH_TAB         IS TABLE OF    giac_soa_rep_v.cred_branch%TYPE;
        TYPE    LINE_CD_TAB             IS TABLE OF    giac_soa_rep_v.line_cd%TYPE;
        TYPE    SUBLINE_CD_TAB          IS TABLE OF    giac_soa_rep_v.subline_cd%TYPE;
        TYPE    ISSUE_YY_TAB            IS TABLE OF    giac_soa_rep_v.issue_yy%TYPE;
        TYPE    RENEW_NO_TAB            IS TABLE OF    giac_soa_rep_v.renew_no%TYPE;
        TYPE    POL_SEQ_NO_TAB          IS TABLE OF    giac_soa_rep_v.pol_seq_no%TYPE;
        TYPE    LINE_NAME_TAB           IS TABLE OF    giac_soa_rep_v.line_name%TYPE;
        TYPE    ACCT_ENT_DATE_TAB       IS TABLE OF    giac_soa_rep_v.acct_ent_date%TYPE;
        TYPE    REF_POL_NO_TAB          IS TABLE OF    giac_soa_rep_v.ref_pol_no%TYPE;
        TYPE    INCEPT_DATE_TAB         IS TABLE OF    giac_soa_rep_v.incept_date%TYPE;
        TYPE    ISSUE_DATE_TAB          IS TABLE OF    giac_soa_rep_v.issue_date%TYPE;
        TYPE    SPLD_DATE_TAB           IS TABLE OF    giac_soa_rep_v.spld_date%TYPE;
        TYPE    POL_FLAG_TAB            IS TABLE OF    giac_soa_rep_v.pol_flag%TYPE;
        TYPE    EFF_DATE_TAB            IS TABLE OF    giac_soa_rep_v.eff_date%TYPE;
        TYPE    EXPIRY_DATE_TAB         IS TABLE OF    giac_soa_rep_v.expiry_date%TYPE;
        TYPE    POLICY_ID2_TAB          IS TABLE OF    giac_soa_rep_v.policy_id2%TYPE;
        TYPE    ASSD_NO2_TAB            IS TABLE OF    giac_soa_rep_v.assd_no2%TYPE;
        TYPE    ASSD_NAME_TAB           IS TABLE OF    giac_soa_rep_v.assd_name%TYPE;
        TYPE    REG_POLICY_SW_TAB       IS TABLE OF    giac_soa_rep_v.reg_policy_sw%TYPE;
        TYPE    ENDT_TYPE_TAB           IS TABLE OF    giac_soa_rep_v.endt_type%TYPE;
        TYPE    SPLD_ACCT_ENT_DATE_TAB  IS TABLE OF    giac_soa_rep_v.spld_acct_ent_date%TYPE; 
        VV_POLICY_ID           POLICY_ID_TAB;
        VV_POLICY_NO           POLICY_NO_TAB;
        VV_ASSD_NO             ASSD_NO_TAB;
        VV_ISS_CD              ISS_CD_TAB;
        VV_CRED_BRANCH         CRED_BRANCH_TAB;
        VV_LINE_CD             LINE_CD_TAB;
        VV_SUBLINE_CD          SUBLINE_CD_TAB;
        VV_ISSUE_YY            ISSUE_YY_TAB;
        VV_RENEW_NO            RENEW_NO_TAB;
        VV_POL_SEQ_NO          POL_SEQ_NO_TAB;
        VV_LINE_NAME           LINE_NAME_TAB;
        VV_ACCT_ENT_DATE       ACCT_ENT_DATE_TAB;
        VV_REF_POL_NO          REF_POL_NO_TAB;
        VV_INCEPT_DATE         INCEPT_DATE_TAB;
        VV_ISSUE_DATE          ISSUE_DATE_TAB;
        VV_SPLD_DATE           SPLD_DATE_TAB;
        VV_POL_FLAG            POL_FLAG_TAB;
        VV_EFF_DATE            EFF_DATE_TAB;
        VV_EXPIRY_DATE         EXPIRY_DATE_TAB;
        VV_POLICY_ID2          POLICY_ID2_TAB;
        VV_ASSD_NO2            ASSD_NO2_TAB;
        VV_ASSD_NAME           ASSD_NAME_TAB;
        VV_REG_POLICY_SW       REG_POLICY_SW_TAB;
        VV_ENDT_TYPE           ENDT_TYPE_TAB;
        VV_SPLD_ACCT_ENT_DATE  SPLD_ACCT_ENT_DATE_TAB;
   BEGIN   
   
      DELETE FROM giac_aging_prem_rep_ext
            WHERE user_id = p_user_id;

     /* FOR c IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'FUND_CD')
      LOOP
         v_fund_cd := c.param_value_v;
         EXIT;
      END LOOP;

      FOR cur1 IN (SELECT *
                     FROM giac_soa_rep_v a
                    WHERE a.reg_policy_sw = 
                             DECODE (v_special_pol,
                                     'Y', a.reg_policy_sw,
                                     'Y'
                                    )
                      AND NVL (a.endt_type, 'A') = 'A'
                      AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
                      --AND a.acct_ent_date IS NOT NULL
                      --AND a.iss_cd != 'RI')
                      --marco - 08.05.2014 - replaced lines above based on procedure EXTRACT_AGING_OF_PREM_RECV
                      AND TRUNC(acct_ent_date) <= p_as_of_date
                      AND a.iss_cd IN (DECODE(check_user_per_iss_cd_acctg2(NULL, iss_cd, 'GIACS329', p_user_id), 1, iss_cd, NULL))
                      AND EXISTS (SELECT 'X'
                                    FROM GIPI_COMM_INVOICE aa,
                                         GIIS_INTERMEDIARY bb
                                   WHERE aa.policy_id = policy_id2
                                     AND aa.intrmdry_intm_no = bb.intm_no
                                     AND intrmdry_intm_no = NVL(p_intm_no, intrmdry_intm_no)
                                     AND intm_type = NVL(p_intm_type, intm_type)
                                     AND ROWNUM = 1))           
      LOOP
         v_include_rec := 1;

         IF p_as_of_date < cur1.acct_ent_date
         THEN
            v_include_rec := 0;
         END IF;

         IF     (   (cur1.spld_date IS NULL)
                 OR (    TRUNC (cur1.spld_date) > p_as_of_date
                     AND cur1.spld_date IS NOT NULL
                     AND cur1.pol_flag = '5'
                    )
                 OR (cur1.spld_date IS NOT NULL AND cur1.pol_flag = '1')
                )
            AND (v_include_rec = 1)
         THEN
            v_policy_id := cur1.policy_id;

            FOR cur_endt_tax IN (SELECT COUNT (*) endt_tax_count
                                   FROM gipi_endttext
                                  WHERE policy_id = cur1.policy_id
                                    AND endt_tax = 'Y')
            LOOP
               FOR cur_endt_tax2 IN (SELECT policy_id
                                       FROM gipi_polbasic
                                      WHERE line_cd = cur1.line_cd
                                        AND subline_cd = cur1.subline_cd
                                        AND iss_cd = cur1.iss_cd
                                        AND issue_yy = cur1.issue_yy
                                        AND renew_no = cur1.renew_no
                                        AND pol_seq_no = cur1.pol_seq_no
                                        AND endt_seq_no = 0)
               LOOP
                  v_policy_id := cur_endt_tax2.policy_id;
               END LOOP;
            END LOOP;

            FOR cur2a IN (SELECT iss_cd, prem_seq_no
                            FROM gipi_invoice
                           WHERE policy_id = cur1.policy_id)
            LOOP
               iss_cd_var := cur2a.iss_cd;
               prem_seq_var := cur2a.prem_seq_no;

               FOR c IN (SELECT intm_name, intm_type, a.parent_intm_no,
                                lic_tag, b.intrmdry_intm_no intm_no
                           FROM giis_intermediary a, gipi_comm_invoice b
                          WHERE a.intm_no = b.intrmdry_intm_no
                            AND b.policy_id = v_policy_id)
               LOOP
                  v_intm_name := c.intm_name;
                  v_intm_type := c.intm_type;
                  v_lic_tag := c.lic_tag;
                  v_parent_intm_no := c.parent_intm_no;
                  v_intm_no := c.intm_no;

                  IF v_lic_tag = 'Y'
                  THEN
                     v_parent_intm_no := c.intm_no;
                     v_lic_tag := 'Y';
                  ELSIF v_lic_tag = 'N'
                  THEN
                     IF v_parent_intm_no IS NULL
                     THEN
                        v_parent_intm_no := c.intm_no;
                        v_lic_tag := 'N';
                     ELSE
                        var_lic_tag := v_lic_tag;

                        WHILE var_lic_tag = 'N'
                         AND v_parent_intm_no IS NOT NULL
                        LOOP
                           BEGIN
                              SELECT intm_no, parent_intm_no,
                                     lic_tag
                                INTO var_intm_no, var_parent_intm_no,
                                     var_lic_tag
                                FROM giis_intermediary
                               WHERE intm_no = v_parent_intm_no;

                              v_parent_intm_no := var_parent_intm_no;

                              IF var_lic_tag = 'Y'
                              THEN
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                              ELSE
                                 NULL;
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                           END;
                        END LOOP;
                     END IF;
                  END IF;

                  EXIT;
               END LOOP;

               FOR cur3 IN (SELECT   due_date, inst_no, prem_amt
                                FROM gipi_installment
                               WHERE iss_cd = iss_cd_var
                                 AND prem_seq_no = prem_seq_var
                            ORDER BY inst_no)
               LOOP
                  v_age := ((p_as_of_date) - TRUNC (cur3.due_date));
                  v_inst_no := cur3.inst_no;
                  v_iss_cd := iss_cd_var;
                  v_prem_seq_no := prem_seq_var;
                  v_aging_id := 0;

                  IF (p_as_of_date - cur3.due_date) <= 0
                  THEN
                     FOR a IN (SELECT aging_id, rep_col_no, last_update
                                 FROM giac_aging_parameters
                                WHERE (ABS (v_age) BETWEEN min_no_days
                                                       AND max_no_days
                                      )
                                  AND gibr_branch_cd = v_iss_cd
                                  AND over_due_tag = 'N')
                     LOOP
                        v_aging_id := a.aging_id;
                        v_column_no := a.rep_col_no;
                        v_last_update := a.last_update;
                        v_due_tag := 'N';
                        EXIT;
                     END LOOP;
                  ELSIF (p_as_of_date - cur3.due_date) > 0
                  THEN
                     FOR b IN (SELECT aging_id, rep_col_no, last_update
                                 FROM giac_aging_parameters
                                WHERE (v_age BETWEEN min_no_days AND max_no_days
                                      )
                                  AND gibr_branch_cd = v_iss_cd
                                  AND over_due_tag = 'Y')
                     LOOP
                        v_aging_id := b.aging_id;
                        v_column_no := b.rep_col_no;
                        v_last_update := b.last_update;
                        v_due_tag := 'Y';
                        EXIT;
                     END LOOP;
                  END IF;

                  BEGIN
                     SELECT DISTINCT MAX (col_no)
                                INTO v_temp_col
                                FROM giac_soa_title;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_temp_col := 0;
                  END;

                  IF v_column_no > v_temp_col
                  THEN
                     v_column_no := v_temp_col;
                  END IF;

                  FOR c IN (SELECT col_title
                              FROM giac_soa_title
                             WHERE col_no = v_column_no AND rep_cd = 1)
                  LOOP
                     v_column_title := c.col_title;
                     EXIT;
                  END LOOP;

                  IF    cur1.spld_date IS NULL
                     OR (cur1.spld_date IS NOT NULL AND cur1.pol_flag = '1')
                  THEN
                     FOR s1 IN (SELECT balance_amt_due, prem_balance_due,
                                       tax_balance_due
                                  FROM giac_aging_soa_details
                                 WHERE iss_cd = iss_cd_var
                                   AND prem_seq_no = prem_seq_var
                                   AND inst_no = cur3.inst_no)
                     LOOP
                        v_balance_amt_due := s1.balance_amt_due;
                        v_prem_bal_due := s1.prem_balance_due;
                        v_tax_bal_due := s1.tax_balance_due;
                        EXIT;
                     END LOOP;

                     v_afterdate_coll := 0;
                     v_afterdate_prem := 0;
                     v_afterdate_tax := 0;

                     FOR c1 IN
                        (SELECT   SUM (a.collection_amt) collection_amt,
                                  SUM (a.premium_amt) prem_amt,
                                  SUM (a.tax_amt) tax_amt
                             FROM giac_direct_prem_collns a, giac_acctrans b
                            WHERE a.gacc_tran_id = b.tran_id
                              AND a.b140_iss_cd = iss_cd_var
                              AND a.b140_prem_seq_no = prem_seq_var
                              AND a.inst_no = cur3.inst_no
                              AND b.tran_flag != 'D'
                              AND b.tran_id >= 0
                              AND NOT EXISTS (
                                     SELECT gr.gacc_tran_id
                                       FROM giac_reversals gr,
                                            giac_acctrans ga
                                      WHERE gr.reversing_tran_id = ga.tran_id
                                        AND ga.tran_flag != 'D'
                                        AND gr.gacc_tran_id = a.gacc_tran_id)
                              AND (   TRUNC (b.posting_date) > p_as_of_date
                                   OR b.posting_date IS NULL
                                  )
                         GROUP BY a.b140_iss_cd, a.b140_prem_seq_no,
                                  a.inst_no)
                     LOOP
                        v_balance_amt_due :=
                                        v_balance_amt_due + c1.collection_amt;
                        v_prem_bal_due := v_prem_bal_due + c1.prem_amt;
                        v_tax_bal_due := v_tax_bal_due + c1.tax_amt;
                        v_afterdate_coll := c1.collection_amt;
                        v_afterdate_prem := c1.prem_amt;
                        v_afterdate_tax := c1.tax_amt;
                        EXIT;
                     END LOOP;
                  ELSIF (    cur1.spld_date IS NOT NULL
                         AND cur1.pol_flag = '5'
                         AND cur1.spld_date > p_as_of_date
                        )
                  THEN
                     FOR s2 IN (SELECT   (  NVL (prem_amt, 0)
                                          + NVL (other_charges, 0)
                                          + NVL (notarial_fee, 0)
                                          + NVL (tax_amt, 0)
                                         )
                                       * NVL (currency_rt, 1) balance,
                                       (  NVL (prem_amt, 0)
                                        * NVL (currency_rt, 1)
                                       ) prem_amt,
                                       (NVL (tax_amt, 0)
                                        * NVL (currency_rt, 1)
                                       ) tax_amt
                                  FROM gipi_invoice
                                 WHERE policy_id = cur1.policy_id
                                   AND iss_cd = iss_cd_var
                                   AND prem_seq_no = prem_seq_var)
                     LOOP
                        v_balance_amt_due := s2.balance;
                        v_prem_bal_due := s2.prem_amt;
                        v_tax_bal_due := s2.tax_amt;
                        EXIT;
                     END LOOP;

                     FOR c2 IN
                        (SELECT   SUM (a.collection_amt) collection_amt,
                                  SUM (a.premium_amt) prem_amt,
                                  SUM (a.tax_amt) tax_amt
                             FROM giac_direct_prem_collns a, giac_acctrans b
                            WHERE a.gacc_tran_id = b.tran_id
                              AND a.b140_iss_cd = iss_cd_var
                              AND a.b140_prem_seq_no = prem_seq_var
                              AND a.inst_no = cur3.inst_no
                              AND b.tran_flag != 'D'
                              AND b.tran_id >= 0
                              AND NOT EXISTS (
                                     SELECT gr.gacc_tran_id
                                       FROM giac_reversals gr,
                                            giac_acctrans ga
                                      WHERE gr.reversing_tran_id = ga.tran_id
                                        AND ga.tran_flag != 'D'
                                        AND gr.gacc_tran_id = a.gacc_tran_id)
                              AND TRUNC (b.posting_date) <= p_as_of_date
                         GROUP BY a.b140_iss_cd, a.b140_prem_seq_no,
                                  a.inst_no)
                     LOOP
                        v_balance_amt_due :=
                                        v_balance_amt_due - c2.collection_amt;
                        v_prem_bal_due := v_prem_bal_due - c2.prem_amt;
                        v_tax_bal_due := v_tax_bal_due - c2.tax_amt;
                        EXIT;
                     END LOOP;
                  END IF;

                  FOR i IN (SELECT ref_inv_no
                              FROM gipi_invoice
                             WHERE policy_id = cur1.policy_id
                               AND iss_cd = iss_cd_var
                               AND prem_seq_no = prem_seq_var)
                  LOOP
                     v_inv_no := i.ref_inv_no;
                     EXIT;
                  END LOOP;

                  INSERT INTO giac_aging_prem_rep_ext
                              (fund_cd,
                               branch_cd, intm_no,
                               intm_name,
                               intm_type,
                               assd_no,
                               assd_name,
                               policy_no,
                               iss_cd,
                               prem_seq_no, inst_no,
                               due_date, aging_id,
                               column_no,
                               column_title,
                               balance_amt_due,
                               prem_bal_due,
                               tax_bal_due, ref_pol_no,
                               ref_inv_no, user_id, last_update, no_of_days,
                               due_tag, lic_tag, parent_intm_no,
                               spld_date, incept_date,
                               expiry_date, as_of_date,
                               afterdate_coll,
                               afterdate_prem,
                               afterdate_tax, line_cd
                              )
                       VALUES (NVL (v_fund_cd, 'NULL'),
                               NVL (cur1.iss_cd, 'NULL'), NVL (v_intm_no, 0),
                               NVL (v_intm_name, 'NULL'),
                               NVL (v_intm_type, 'NULL'),
                               NVL (cur1.assd_no2, 0),
                               NVL (cur1.assd_name, 'NULL'),
                               NVL (cur1.policy_no, 'NULL'),
                               NVL (iss_cd_var, 'NULL'),
                               NVL (prem_seq_var, 0), NVL (v_inst_no, 0),
                               cur3.due_date, NVL (v_aging_id, 0),
                               NVL (v_column_no, 0),
                               NVL (v_column_title, 'NULL TITLE'),
                               NVL (v_balance_amt_due, 0),
                               NVL (v_prem_bal_due, 0),
                               NVL (v_tax_bal_due, 0), cur1.ref_pol_no,
                               v_inv_no, p_user_id, TRUNC (SYSDATE), v_age,
                               v_due_tag, v_lic_tag, v_parent_intm_no,
                               cur1.spld_date, cur1.incept_date,
                               cur1.expiry_date, p_as_of_date,
                               NVL (v_afterdate_coll, 0),
                               NVL (v_afterdate_prem, 0),
                               NVL (v_afterdate_tax, 0), cur1.line_cd
                              );

                  v_row_counter := v_row_counter + 1;
               END LOOP;
            END LOOP;
         END IF;
         END LOOP;*/
      v_sql := 'SELECT * 
                     FROM giac_soa_rep_v a
                    WHERE NVL (a.endt_type, ''A'') = ''A''
                      AND a.iss_cd = NVL ('''||p_branch_cd||''', a.iss_cd)
                      AND TRUNC(acct_ent_date) <= '''|| p_as_of_date||'''
                      AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS329'', '''||p_user_id||'''))
                                WHERE branch_cd = a.iss_cd )
                      AND EXISTS (SELECT ''X''
                                    FROM GIPI_COMM_INVOICE aa,
                                         GIIS_INTERMEDIARY bb
                                   WHERE aa.policy_id = policy_id2
                                     AND aa.intrmdry_intm_no = bb.intm_no ';
                  IF p_intm_no IS NOT NULL
                    THEN
                        v_sql := v_sql || ' AND intrmdry_intm_no = '''||p_intm_no||''' ';
                  END IF;
                  IF p_intm_type IS NOT NULL
                    THEN
                        v_sql := v_sql || ' AND intm_type = '''||p_intm_type||''' ';
                  END IF;
                  v_sql := v_sql || ' AND ROWNUM = 1) ';
OPEN c FOR v_sql;        
 FETCH c BULK COLLECT INTO         
        VV_POLICY_ID ,          
        VV_POLICY_NO ,          
        VV_ASSD_NO   ,          
        VV_ISS_CD    ,          
        VV_CRED_BRANCH ,        
        VV_LINE_CD     ,        
        VV_SUBLINE_CD  ,        
        VV_ISSUE_YY     ,       
        VV_RENEW_NO     ,       
        VV_POL_SEQ_NO   ,       
        VV_LINE_NAME    ,       
        VV_ACCT_ENT_DATE ,      
        VV_REF_POL_NO   ,       
        VV_INCEPT_DATE  ,       
        VV_ISSUE_DATE   ,       
        VV_SPLD_DATE    ,       
        VV_POL_FLAG     ,       
        VV_EFF_DATE     ,       
        VV_EXPIRY_DATE  ,       
        VV_POLICY_ID2   ,       
        VV_ASSD_NO2     ,       
        VV_ASSD_NAME    ,       
        VV_REG_POLICY_SW ,      
        VV_ENDT_TYPE     ,      
        VV_SPLD_ACCT_ENT_DATE;  
   IF vv_policy_id.COUNT != 0 THEN   
      FOR z IN vv_policy_id.FIRST..vv_policy_id.LAST      
      LOOP
         v_include_rec := 1;

         IF p_as_of_date < vv_acct_ent_date(z)
         THEN
            v_include_rec := 0;
         END IF;

         IF     (   (vv_spld_date(z) IS NULL)
                 OR (    TRUNC (vv_spld_date(z)) > p_as_of_date
                     AND vv_spld_date(z) IS NOT NULL
                     AND vv_pol_flag(z) = '5'
                    )
                 OR (vv_spld_date(z) IS NOT NULL AND vv_pol_flag(z) = '1')
                )
            AND (v_include_rec = 1)
         THEN
            v_policy_id := vv_policy_id(z);

            FOR cur_endt_tax IN (SELECT COUNT (*) endt_tax_count
                                   FROM gipi_endttext
                                  WHERE policy_id = vv_policy_id(z)
                                    AND endt_tax = 'Y')
            LOOP
               FOR cur_endt_tax2 IN (SELECT policy_id
                                       FROM gipi_polbasic
                                      WHERE line_cd = vv_line_cd(z)
                                        AND subline_cd = vv_subline_cd(z)
                                        AND iss_cd = vv_iss_cd(z)
                                        AND issue_yy = vv_issue_yy(z)
                                        AND renew_no = vv_renew_no(z)
                                        AND pol_seq_no = vv_pol_seq_no(z)
                                        AND endt_seq_no = 0)
               LOOP
                  v_policy_id := cur_endt_tax2.policy_id;
               END LOOP;
            END LOOP;

            FOR cur2a IN (SELECT iss_cd, prem_seq_no
                            FROM gipi_invoice
                           WHERE policy_id = vv_policy_id(z))
            LOOP
               iss_cd_var := cur2a.iss_cd;
               prem_seq_var := cur2a.prem_seq_no;

               FOR c IN (SELECT intm_name, intm_type, a.parent_intm_no,
                                lic_tag, b.intrmdry_intm_no intm_no
                           FROM giis_intermediary a, gipi_comm_invoice b
                          WHERE a.intm_no = b.intrmdry_intm_no
                            AND b.policy_id = v_policy_id)
               LOOP
                  v_intm_name := c.intm_name;
                  v_intm_type := c.intm_type;
                  v_lic_tag := c.lic_tag;
                  v_parent_intm_no := c.parent_intm_no;
                  v_intm_no := c.intm_no;

                  IF v_lic_tag = 'Y'
                  THEN
                     v_parent_intm_no := c.intm_no;
                     v_lic_tag := 'Y';
                  ELSIF v_lic_tag = 'N'
                  THEN
                     IF v_parent_intm_no IS NULL
                     THEN
                        v_parent_intm_no := c.intm_no;
                        v_lic_tag := 'N';
                     ELSE
                        var_lic_tag := v_lic_tag;

                        WHILE var_lic_tag = 'N'
                         AND v_parent_intm_no IS NOT NULL
                        LOOP
                           BEGIN
                              SELECT intm_no, parent_intm_no,
                                     lic_tag
                                INTO var_intm_no, var_parent_intm_no,
                                     var_lic_tag
                                FROM giis_intermediary
                               WHERE intm_no = v_parent_intm_no;

                              v_parent_intm_no := var_parent_intm_no;

                              IF var_lic_tag = 'Y'
                              THEN
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                              ELSE
                                 NULL;
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                           END;
                        END LOOP;
                     END IF;
                  END IF;

                  EXIT;
               END LOOP;

               FOR cur3 IN (SELECT   due_date, inst_no, prem_amt
                                FROM gipi_installment
                               WHERE iss_cd = iss_cd_var
                                 AND prem_seq_no = prem_seq_var
                            ORDER BY inst_no)
               LOOP
                  v_age := ((p_as_of_date) - TRUNC (cur3.due_date));
                  v_inst_no := cur3.inst_no;
                  v_iss_cd := iss_cd_var;
                  v_prem_seq_no := prem_seq_var;
                  v_aging_id := 0;

                  IF (p_as_of_date - cur3.due_date) <= 0
                  THEN
                     FOR a IN (SELECT aging_id, rep_col_no, last_update
                                 FROM giac_aging_parameters
                                WHERE (ABS (v_age) BETWEEN min_no_days
                                                       AND max_no_days
                                      )
                                  AND gibr_branch_cd = v_iss_cd
                                  AND over_due_tag = 'N')
                     LOOP
                        v_aging_id := a.aging_id;
                        v_column_no := a.rep_col_no;
                        v_last_update := a.last_update;
                        v_due_tag := 'N';
                        EXIT;
                     END LOOP;
                  ELSIF (p_as_of_date - cur3.due_date) > 0
                  THEN
                     FOR b IN (SELECT aging_id, rep_col_no, last_update
                                 FROM giac_aging_parameters
                                WHERE (v_age BETWEEN min_no_days AND max_no_days
                                      )
                                  AND gibr_branch_cd = v_iss_cd
                                  AND over_due_tag = 'Y')
                     LOOP
                        v_aging_id := b.aging_id;
                        v_column_no := b.rep_col_no;
                        v_last_update := b.last_update;
                        v_due_tag := 'Y';
                        EXIT;
                     END LOOP;
                  END IF;

                  BEGIN
                     SELECT DISTINCT MAX (col_no)
                                INTO v_temp_col
                                FROM giac_soa_title;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_temp_col := 0;
                  END;

                  IF v_column_no > v_temp_col
                  THEN
                     v_column_no := v_temp_col;
                  END IF;

                  FOR c IN (SELECT col_title
                              FROM giac_soa_title
                             WHERE col_no = v_column_no AND rep_cd = 1)
                  LOOP
                     v_column_title := c.col_title;
                     EXIT;
                  END LOOP;

                  IF    vv_spld_date(z) IS NULL
                     OR (vv_spld_date(z) IS NOT NULL AND vv_pol_flag(z) = '1')
                  THEN
                     FOR s1 IN (SELECT balance_amt_due, prem_balance_due,
                                       tax_balance_due
                                  FROM giac_aging_soa_details
                                 WHERE iss_cd = iss_cd_var
                                   AND prem_seq_no = prem_seq_var
                                   AND inst_no = cur3.inst_no)
                     LOOP
                        v_balance_amt_due := s1.balance_amt_due;
                        v_prem_bal_due := s1.prem_balance_due;
                        v_tax_bal_due := s1.tax_balance_due;
                        EXIT;
                     END LOOP;

                     v_afterdate_coll := 0;
                     v_afterdate_prem := 0;
                     v_afterdate_tax := 0;

                     FOR c1 IN
                        (SELECT   SUM (a.collection_amt) collection_amt,
                                  SUM (a.premium_amt) prem_amt,
                                  SUM (a.tax_amt) tax_amt
                             FROM giac_direct_prem_collns a, giac_acctrans b
                            WHERE a.gacc_tran_id = b.tran_id
                              AND a.b140_iss_cd = iss_cd_var
                              AND a.b140_prem_seq_no = prem_seq_var
                              AND a.inst_no = cur3.inst_no
                              AND b.tran_flag != 'D'
                              AND b.tran_id >= 0
                              AND NOT EXISTS (
                                     SELECT gr.gacc_tran_id
                                       FROM giac_reversals gr,
                                            giac_acctrans ga
                                      WHERE gr.reversing_tran_id = ga.tran_id
                                        AND ga.tran_flag != 'D'
                                        AND gr.gacc_tran_id = a.gacc_tran_id)
                              AND (   TRUNC (b.posting_date) > p_as_of_date
                                   OR b.posting_date IS NULL
                                  )
                         GROUP BY a.b140_iss_cd, a.b140_prem_seq_no,
                                  a.inst_no)
                     LOOP
                        v_balance_amt_due :=
                                        v_balance_amt_due + c1.collection_amt;
                        v_prem_bal_due := v_prem_bal_due + c1.prem_amt;
                        v_tax_bal_due := v_tax_bal_due + c1.tax_amt;
                        v_afterdate_coll := c1.collection_amt;
                        v_afterdate_prem := c1.prem_amt;
                        v_afterdate_tax := c1.tax_amt;
                        EXIT;
                     END LOOP;
                  ELSIF (    vv_spld_date(z) IS NOT NULL
                         AND vv_pol_flag(z) = '5'
                         AND vv_spld_date(z) > p_as_of_date
                        )
                  THEN
                     FOR s2 IN (SELECT   (  NVL (prem_amt, 0)
                                          + NVL (other_charges, 0)
                                          + NVL (notarial_fee, 0)
                                          + NVL (tax_amt, 0)
                                         )
                                       * NVL (currency_rt, 1) balance,
                                       (  NVL (prem_amt, 0)
                                        * NVL (currency_rt, 1)
                                       ) prem_amt,
                                       (NVL (tax_amt, 0)
                                        * NVL (currency_rt, 1)
                                       ) tax_amt
                                  FROM gipi_invoice
                                 WHERE policy_id = vv_policy_id(z)
                                   AND iss_cd = iss_cd_var
                                   AND prem_seq_no = prem_seq_var)
                     LOOP
                        v_balance_amt_due := s2.balance;
                        v_prem_bal_due := s2.prem_amt;
                        v_tax_bal_due := s2.tax_amt;
                        EXIT;
                     END LOOP;

                     FOR c2 IN
                        (SELECT   SUM (a.collection_amt) collection_amt,
                                  SUM (a.premium_amt) prem_amt,
                                  SUM (a.tax_amt) tax_amt
                             FROM giac_direct_prem_collns a, giac_acctrans b
                            WHERE a.gacc_tran_id = b.tran_id
                              AND a.b140_iss_cd = iss_cd_var
                              AND a.b140_prem_seq_no = prem_seq_var
                              AND a.inst_no = cur3.inst_no
                              AND b.tran_flag != 'D'
                              AND b.tran_id >= 0
                              AND NOT EXISTS (
                                     SELECT gr.gacc_tran_id
                                       FROM giac_reversals gr,
                                            giac_acctrans ga
                                      WHERE gr.reversing_tran_id = ga.tran_id
                                        AND ga.tran_flag != 'D'
                                        AND gr.gacc_tran_id = a.gacc_tran_id)
                              AND TRUNC (b.posting_date) <= p_as_of_date
                         GROUP BY a.b140_iss_cd, a.b140_prem_seq_no,
                                  a.inst_no)
                     LOOP
                        v_balance_amt_due :=
                                        v_balance_amt_due - c2.collection_amt;
                        v_prem_bal_due := v_prem_bal_due - c2.prem_amt;
                        v_tax_bal_due := v_tax_bal_due - c2.tax_amt;
                        EXIT;
                     END LOOP;
                  END IF;

                  FOR i IN (SELECT ref_inv_no
                              FROM gipi_invoice
                             WHERE policy_id = vv_policy_id(z)
                               AND iss_cd = iss_cd_var
                               AND prem_seq_no = prem_seq_var)
                  LOOP
                     v_inv_no := i.ref_inv_no;
                     EXIT;
                  END LOOP;
            IF NVL(v_balance_amt_due, 0) != 0
                THEN
                /*  INSERT INTO giac_aging_prem_rep_ext
                              (fund_cd,
                               branch_cd, intm_no,
                               intm_name,
                               intm_type,
                               assd_no,
                               assd_name,
                               policy_no,
                               iss_cd,
                               prem_seq_no, inst_no,
                               due_date, aging_id,
                               column_no,
                               column_title,
                               balance_amt_due,
                               prem_bal_due,
                               tax_bal_due, ref_pol_no,
                               ref_inv_no, user_id, last_update, no_of_days,
                               due_tag, lic_tag, parent_intm_no,
                               spld_date, incept_date,
                               expiry_date, as_of_date,
                               afterdate_coll,
                               afterdate_prem,
                               afterdate_tax, line_cd
                              )
                       VALUES (NVL (v_fund_cd, 'NULL'),
                               NVL (prem_rcvbl_list(z).iss_cd, 'NULL'), NVL (v_intm_no, 0),
                               NVL (v_intm_name, 'NULL'),
                               NVL (v_intm_type, 'NULL'),
                               NVL (prem_rcvbl_list(z).assd_no2, 0),
                               NVL (prem_rcvbl_list(z).assd_name, 'NULL'),
                               NVL (prem_rcvbl_list(z).policy_no, 'NULL'),
                               NVL (iss_cd_var, 'NULL'),
                               NVL (prem_seq_var, 0), NVL (v_inst_no, 0),
                               cur3.due_date, NVL (v_aging_id, 0),
                               NVL (v_column_no, 0),
                               NVL (v_column_title, 'NULL TITLE'),
                               NVL (v_balance_amt_due, 0),
                               NVL (v_prem_bal_due, 0),
                               NVL (v_tax_bal_due, 0), prem_rcvbl_list(z).ref_pol_no,
                               v_inv_no, p_user_id, TRUNC (SYSDATE), v_age,
                               v_due_tag, v_lic_tag, v_parent_intm_no,
                               prem_rcvbl_list(z).spld_date, prem_rcvbl_list(z).incept_date,
                               prem_rcvbl_list(z).expiry_date, p_as_of_date,
                               NVL (v_afterdate_coll, 0),
                               NVL (v_afterdate_prem, 0),
                               NVL (v_afterdate_tax, 0), prem_rcvbl_list(z).line_cd
                              );
                 
                  v_row_counter := v_row_counter + 1;*/
                
                
                 prem_rcvbl_list.extend;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).fund_cd:= (NVL(v_fund_cd,'NULL'));
                 prem_rcvbl_list(prem_rcvbl_list.LAST).branch_cd:= NVL (vv_iss_cd(z),'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).intm_no := NVL (v_intm_no, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).intm_name := NVL (v_intm_name, 'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).intm_type := NVL (v_intm_type, 'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).assd_no := NVL(vv_assd_no2(z),0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).assd_name := NVL(vv_assd_name(z),'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).policy_no:= NVL(vv_policy_no(z),'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).iss_cd := NVL(iss_cd_var,'NULL');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).prem_seq_no := NVL(prem_seq_var,0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).inst_no := NVL(v_inst_no,0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).due_date := cur3.due_date;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).aging_id := NVL (v_aging_id, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).column_no := NVL (v_column_no, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).column_title := NVL (v_column_title, 'NULL TITLE');
                 prem_rcvbl_list(prem_rcvbl_list.LAST).balance_amt_due := NVL (v_balance_amt_due, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).prem_bal_due := NVL (v_prem_bal_due, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).tax_bal_due := NVL (v_tax_bal_due, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).ref_pol_no := vv_ref_pol_no(z);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).ref_inv_no := v_inv_no;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).user_id := p_user_id;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).last_update := TRUNC (SYSDATE);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).no_of_days := v_age;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).due_tag := v_due_tag;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).lic_tag := v_lic_tag;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).parent_intm_no := v_parent_intm_no;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).spld_date := vv_spld_date(z);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).incept_date := vv_incept_date(z);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).expiry_date := vv_expiry_date(z);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).as_of_date := p_as_of_date;
                 prem_rcvbl_list(prem_rcvbl_list.LAST).afterdate_coll := NVL (v_afterdate_coll, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).afterdate_prem := NVL (v_afterdate_prem, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).afterdate_tax := NVL (v_afterdate_tax, 0);
                 prem_rcvbl_list(prem_rcvbl_list.LAST).line_cd := vv_line_cd(z);
                END IF;
               END LOOP;
            END LOOP;
         END IF;
      END LOOP;      
      FORALL i IN prem_rcvbl_list.FIRST..prem_rcvbl_list.LAST     
    INSERT INTO (SELECT  fund_cd,
                         branch_cd, 
                         intm_no,
                         intm_name,
                         intm_type,
                         assd_no,
                         assd_name,
                         policy_no,
                         iss_cd,
                         prem_seq_no, 
                         inst_no,
                         due_date, 
                         aging_id,
                         column_no,
                         column_title,
                         balance_amt_due,
                         prem_bal_due,
                         tax_bal_due, 
                         ref_pol_no,
                         ref_inv_no, 
                         user_id, 
                         last_update, 
                         no_of_days,
                         due_tag, 
                         lic_tag, 
                         parent_intm_no,
                         spld_date, 
                         incept_date,
                         expiry_date, 
                         as_of_date,
                         afterdate_coll,
                         afterdate_prem,
                         afterdate_tax, 
                         line_cd FROM giac_aging_prem_rep_ext) VALUES prem_rcvbl_list(i);
                         
    
    SELECT COUNT(*)
      INTO v_row_counter
      FROM giac_aging_prem_rep_ext
     WHERE user_id = p_user_id;     
     p_exists := TO_CHAR (v_row_counter); 
    --pjsantos end
    END IF;
   END;

   FUNCTION get_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_list   branch_lov_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, INITCAP (iss_name) iss_name 
                    FROM giis_issource
                   WHERE 1=1/*iss_cd =
                            DECODE
                                  (check_user_per_iss_cd_acctg2 (NULL,
                                                                 iss_cd,
                                                                 'GIACS329',
                                                                 p_user_id
                                                                ),
                                   1, iss_cd,
                                   NULL
                                  )*/--Comment out by pjsantos 11/22/2016 replaced by code below, GENQA 5187
                     AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS329', p_user_id))
                                WHERE branch_cd = iss_cd )
                     AND (   UPPER (iss_cd) LIKE
                                       NVL (UPPER (p_keyword), UPPER (iss_cd))
                          OR UPPER (iss_name) LIKE
                                UPPER (NVL (UPPER (p_keyword),
                                            UPPER (iss_name)
                                           )
                                      )
                         )
                ORDER BY 2)
      LOOP
         v_list.branch_cd := i.iss_cd;
         v_list.branch_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_intmtype_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN intmtype_lov_tab PIPELINED
   IS
      v_list   intmtype_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_type, INITCAP (intm_desc) intm_desc
                    FROM giis_intm_type
                   WHERE (   UPPER (intm_type) LIKE
                                    NVL (UPPER (p_keyword), UPPER (intm_type))
                          OR UPPER (intm_desc) LIKE
                                UPPER (NVL (UPPER (p_keyword),
                                            UPPER (intm_desc)
                                           )
                                      )
                         )
                ORDER BY 1)
      LOOP
         v_list.intm_type := i.intm_type;
         v_list.intm_desc := i.intm_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_intm_lov (
      p_intm_type   giis_intm_type.intm_type%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN intm_lov_tab PIPELINED
   IS
      v_list   intm_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_no, INITCAP (intm_name) intm_name
                    FROM giis_intermediary
                   WHERE intm_type = NVL (p_intm_type, intm_type)
                     AND (   UPPER (intm_no) LIKE
                                 '%' || UPPER (NVL (p_keyword, intm_no))
                                 || '%'
                          OR UPPER (intm_name) LIKE
                                '%' || UPPER (NVL (p_keyword, intm_name))
                                || '%'
                         )
                ORDER BY 1)
      LOOP
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN when_new_form_instance_tab PIPELINED
   IS
      v_ext   when_new_form_instance_type;
   BEGIN
      FOR i IN (SELECT as_of_date
                  FROM giac_aging_prem_rep_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_ext.v_as_of_date := TO_CHAR (i.as_of_date, 'MM-DD-RRRR');
         PIPE ROW (v_ext);
      END LOOP;

      RETURN;
   END;
END giacs329_pkg;
/



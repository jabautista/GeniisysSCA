DROP PROCEDURE CPI.GICLS032_INSERT_INTO_GRQD;

CREATE OR REPLACE PROCEDURE CPI.gicls032_insert_into_grqd (
   p_claim_id         gicl_claims.claim_id%TYPE,
   p_advice_id        gicl_advice.advice_id%TYPE,
   p_user_id          giis_users.user_id%TYPE,
   p_ref_id           giac_payt_requests_dtl.gprq_ref_id%TYPE,
   p_tran_id          giac_payt_requests_dtl.tran_id%TYPE,
   p_payee_cd         giac_payt_requests_dtl.payee_cd%TYPE,
   p_payee_class_cd   giac_payt_requests_dtl.payee_class_cd%TYPE,
   p_payee_amount     giac_payt_requests_dtl.payt_amt%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  2.28.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - insert_into_grqd
   */

   v_payee              giac_payt_requests_dtl.payee%TYPE;
   v_payt_req_flag      giac_payt_requests_dtl.payt_req_flag%TYPE;
   v_particulars        giac_payt_requests_dtl.particulars%TYPE;
   v_particulars1       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars2       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars3       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars4       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars5       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars6       VARCHAR2 (240);
   v_particulars7       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars8       giac_payt_requests_dtl.particulars%TYPE;
   v_particulars9       VARCHAR2 (2000);
   v_payee_class        VARCHAR2 (100);
   v_payee_part         VARCHAR2 (500); --VARCHAR2 (100); modified by robert SR 13239
   v_doc_number         gicl_loss_exp_bill.doc_number%TYPE;
   v_doc_type           VARCHAR2 (100);
   v_all9               VARCHAR2 (900); --VARCHAR2 (300); modified by robert SR 13239
   v_param_value_v      giac_parameters.param_value_v%TYPE;
   v_param_value2_v     giis_parameters.param_value_v%TYPE;
   v_count              VARCHAR2 (10);
   v_count2             VARCHAR2 (10);
   v_loss_cat           giis_loss_ctgry.loss_cat_des%TYPE;
   v_payt_amt           giac_payt_requests_dtl.payt_amt%TYPE;
   v_dv_fcurrency_amt   giac_payt_requests_dtl.dv_fcurrency_amt%TYPE;
   v_hist_seq_no        gicl_clm_loss_exp.hist_seq_no%TYPE;
   v_remarks            gicl_clm_loss_exp.remarks%TYPE;
   -- added by mildred 06232011 to validate length of "payment for : particular"
   v_length             NUMBER;
   v_line_cd            gicl_claims.line_cd%TYPE;
   v_subline_cd         gicl_claims.subline_cd%TYPE;
   v_iss_cd             gicl_claims.iss_cd%TYPE;
   v_clm_yy             gicl_claims.clm_yy%TYPE;
   v_clm_seq_no         gicl_claims.clm_seq_no%TYPE;
   v_pol_seq_no         gicl_claims.pol_seq_no%TYPE;
   v_pol_iss_cd         gicl_claims.pol_iss_cd%TYPE;
   v_issue_yy           gicl_claims.issue_yy%TYPE;
   v_renew_no           gicl_claims.renew_no%TYPE;
   v_assured_name       gicl_claims.assured_name%TYPE;
   v_loss_date          gicl_claims.loss_date%TYPE;
   v_payee_remarks      gicl_advice.payee_remarks%TYPE;
   v_currency_cd        gicl_advice.currency_cd%TYPE;
   v_convert_rate       gicl_advice.convert_rate%TYPE;
   v_req_dtl_no         NUMBER;
   v_local_currency     NUMBER                                         := giacp.n ('CURRENCY_CD');
   v_ex_gratia_sw       VARCHAR2(1);
   v_final_tag          VARCHAR2(1);
BEGIN
   SELECT line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no, pol_seq_no, pol_iss_cd, pol_seq_no, issue_yy,
          renew_no, assured_name, loss_date
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, v_clm_seq_no, v_pol_seq_no, v_pol_iss_cd, v_pol_seq_no, v_issue_yy,
          v_renew_no, v_assured_name, v_loss_date
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   SELECT currency_cd, convert_rate, payee_remarks
     INTO v_currency_cd, v_convert_rate, v_payee_remarks
     FROM gicl_advice
    WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

   BEGIN
      SELECT param_value_v
        INTO v_param_value_v
        FROM giac_parameters
       WHERE param_name = 'CLM_CSR_INTM';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_param_value_v := NULL;
   END;

--begin kim 08/04/04
--this is used to get the value of the param_name INCLUDE_REMARKS_TO_PAYEE
   BEGIN
      SELECT param_value_v
        INTO v_param_value2_v
        FROM giis_parameters
       WHERE param_name = 'INCLUDE_REMARKS_TO_PAYEE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_param_value2_v := NULL;
   END;

--end kim 08/04/04
   BEGIN
      v_payt_req_flag := 'N';
      
      FOR i IN (
          SELECT ex_gratia_sw, final_tag        
            FROM gicl_clm_loss_exp
           WHERE claim_id = p_claim_id
             AND advice_id = p_advice_id)
      LOOP
        v_ex_gratia_sw := i.ex_gratia_sw;
        v_final_tag    := i.final_tag;
        EXIT;
      END LOOP;
      
      IF v_ex_gratia_sw = 'Y'
      THEN
         v_particulars1 := 'Ex Gratia settlement on ' || v_line_cd || ' claim.';
      ELSIF (v_ex_gratia_sw = 'N' OR v_ex_gratia_sw IS NULL)
      THEN
         IF v_final_tag = 'Y'
         THEN
            v_particulars1 := 'Full and final settlement on ' || v_line_cd || ' claim.';
         ELSIF (v_final_tag = 'N' OR v_final_tag IS NULL)
         THEN
            v_particulars1 := 'Partial settlement on ' || v_line_cd || ' claim.';
         END IF;
      END IF;
      
      v_particulars2 :=
            'CLAIM NO.     :  '
         || v_line_cd
         || '-'
         || v_subline_cd
         || '-'
         || v_iss_cd
         || '-'
         || LPAD (TO_CHAR (v_clm_yy), 2, '0')
         || '-'
         || LPAD (TO_CHAR (v_clm_seq_no), 7, '0');
      v_particulars3 := 'ASSURED       :  ' || v_assured_name;
      v_particulars4 :=
            'POLICY NO.    :  '
         || v_line_cd
         || '-'
         || v_subline_cd
         || '-'
         || v_pol_iss_cd
         || '-'
         || LPAD (TO_CHAR (v_issue_yy), 2, '0')
         || '-'
         || LPAD (TO_CHAR (v_pol_seq_no), 7, '0')
         || '-'
         || LPAD (TO_CHAR (v_renew_no), 2, '0');

      BEGIN
         SELECT    'TERM          :  '
                || TO_CHAR (pol_eff_date, 'fmMONTH dd, YYYY')
                || ' - '
                || TO_CHAR (expiry_date, 'fmMONTH dd, YYYY')
           INTO v_particulars5
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001, 'Effective and expiry date for this claim are not found in gicl_claims.');
      END;

-- Added by Maridor (06-28-2001)
-- displays the intermediary name in details when parameter CLM_CSR_INTM = 'Y'
      BEGIN
         v_count := 0;
         
         FOR m IN (SELECT TO_CHAR (a.intm_no) || '/' || b.ref_intm_cd intm
                     FROM gicl_intm_itmperil a, giis_intermediary b
                    WHERE a.intm_no = b.intm_no
                      AND a.claim_id = p_claim_id)
         LOOP
            IF v_count = 0
            THEN
               v_particulars6 := 'INTERMEDIARY  :  ' || m.intm;
            ELSIF v_count > 1
            THEN
               --v_particulars6 := 'INTERMEDIARY  :  ' || m.intm || CHR (10) || '                 ' || v_particulars6;
               v_particulars6 := CHR (10) || '                 ' || m.intm;
            END IF;
            
            v_count := v_count + 1;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      v_particulars7 := 'ACCIDENT      :  ' || TO_CHAR (v_loss_date, 'fmMONTH DD, YYYY');
      
      BEGIN
        v_count := 0;
        
        FOR n IN (
              SELECT d.peril_sname || ' - ' || loss_cat_des peril_loss_cat_des
               FROM gicl_clm_loss_exp a                 
                   ,gicl_item_peril b
                   ,giis_loss_ctgry c
                   ,giis_peril d
              WHERE a.claim_id = p_claim_id
                AND a.advice_id = p_advice_id                                                            
                AND a.payee_cd = p_payee_cd
                AND a.payee_class_cd = p_payee_class_cd                     
                AND b.claim_id = a.claim_id                    
                AND b.peril_cd = a.peril_cd
                AND b.line_cd = v_line_cd                                                            
                AND c.loss_cat_cd = b.loss_cat_cd                                        
                AND c.line_cd = b.line_cd                                          
                AND d.peril_cd = b.peril_cd
                AND d.line_cd = b.line_cd)
        LOOP
            IF v_count = 0
            THEN
               v_particulars8 := 'LOSS CATEGORY :  ' || n.peril_loss_cat_des;
            ELSIF v_count > 1
            THEN
               v_particulars8 := CHR (10) || '                 ' || n.peril_loss_cat_des;
            END IF;
        END LOOP;                
      END;                       

      -- added by gmi.. 07/27/2005
      BEGIN
         v_count2 := 0;

         FOR c IN (SELECT a.class_desc class_desc, b.payee_last_name last_name, c.doc_number doc_num,
                          DECODE (c.doc_type, 1, 'INVOICE', 2, 'BILL') doc_type, d.hist_seq_no
                     FROM giis_payee_class a, giis_payees b, gicl_loss_exp_bill c, gicl_clm_loss_exp d, gicl_advice e
                    WHERE c.claim_id = p_claim_id
                      AND e.claim_id = c.claim_id
                      AND d.claim_id = c.claim_id
                      AND c.claim_loss_id = d.clm_loss_id
                      AND a.payee_class_cd = b.payee_class_cd
                      AND a.payee_class_cd = c.payee_class_cd
                      AND e.advice_id = d.advice_id
                      AND e.claim_id = d.claim_id
                      AND e.advice_id = p_advice_id
                      AND b.payee_no = c.payee_cd)
         LOOP
            v_count2 := v_count2 + 1;
            v_payee_class := c.class_desc;
            v_payee_part := c.last_name;
            v_doc_number := c.doc_num;
            v_doc_type := c.doc_type;
            v_all9 := v_payee_class || '-' || v_payee_part || '/' || v_doc_type || '-' || v_doc_number;

             /*modifeid by: jess.08.12.10: check first if value is less than 2000
            ** before assigning to the variable to avoid ora-06502*/
            IF LENGTH (v_particulars9 || CHR (10) || '                 ' || v_all9) < 2000
            THEN
               IF v_count2 = 1
               THEN
                  v_particulars9 := 'PAYMENT FOR   :  ' || v_all9;
               ELSIF v_count2 > 1
               THEN
                  v_particulars9 := v_particulars9 || CHR (10) || '                 ' || v_all9;
               END IF;
            ELSE                                                                                             -- else exit the loop
               EXIT;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

-- added by mildred 06232011 to validate length of "payment for : particular"
-- if exceeds 500, particulars will be replaced by VARIOUS to avoid ora 6502
      v_length := NVL (LENGTH (v_particulars9), 0);

      IF v_length > 500
      THEN
         v_particulars9 := 'PAYMENT FOR   :  VARIOUS ';
      END IF;

--end mildred
      IF v_param_value_v = 'Y'
      THEN
         v_particulars :=
               v_particulars1
            || CHR (10)
            || v_particulars2
            || CHR (10)
            || v_particulars3
            || CHR (10)
            || v_particulars4
            || CHR (10)
            || v_particulars5
            || CHR (10)
            || v_particulars6
            || CHR (10)
            || v_particulars7
            || CHR (10)
            || v_particulars8
            || CHR (10)
            || v_particulars9;
      ELSE
         v_particulars :=
               v_particulars1
            || CHR (10)
            || v_particulars2
            || CHR (10)
            || v_particulars3
            || CHR (10)
            || v_particulars4
            || CHR (10)
            || v_particulars5
            || CHR (10)
            || v_particulars7
            || CHR (10)
            || v_particulars8
            || CHR (10)
            || v_particulars9;
      END IF;
   END;

-- End of Maridor's additions

   /* modified by judyann 09302004
   ** orig: payee_first_name||' '||payee_middle_name||' '||payee_last_name */
   FOR a IN (SELECT DECODE (payee_first_name,
                            NULL, payee_last_name,
                            DECODE (payee_middle_name,
                                    NULL, payee_first_name || ' ' || payee_last_name,
                                    payee_first_name || ' ' || payee_middle_name || ' ' || payee_last_name
                                   )
                           ) payee
               FROM giis_payees
              WHERE payee_no = p_payee_cd AND payee_class_cd = p_payee_class_cd)
   LOOP
      IF v_payee_remarks IS NOT NULL
      THEN
         v_payee := a.payee || ' ' || v_payee_remarks;
      ELSE
         v_payee := a.payee;
      END IF;

--end kim 08/04/04
-- added/modified by A.R.C. 09.17.2004
      EXIT;
   END LOOP;

   IF v_payee IS NULL
   THEN
      raise_application_error (-20001, 'Payee Name is not found.');
   END IF;

   IF v_particulars IS NULL
   THEN
      raise_application_error (-20001, 'Particulars is null.');
   END IF;

   v_req_dtl_no := 1;

   BEGIN
      --BETH 08042006 SELECT p_payee_amount * decode(:c011.nbt_dsp_curr_cd, variable.v_local_currency, 1, :c015.convert_Rate)
      SELECT p_payee_amount           --* decode(variable.v_advice_currency, variable.v_local_currency, 1, variable.v_advice_rate)
        INTO v_payt_amt
        FROM DUAL;
   END;

   BEGIN
      INSERT INTO giac_payt_requests_dtl
                  (req_dtl_no, gprq_ref_id, tran_id, payee_class_cd, payt_req_flag, payee_cd, payee, particulars,
                   currency_cd, payt_amt, user_id, last_update,
                   dv_fcurrency_amt, currency_rt
                  )
           VALUES (v_req_dtl_no, p_ref_id, p_tran_id, p_payee_class_cd, v_payt_req_flag, p_payee_cd, v_payee, v_particulars,
                   v_currency_cd, v_payt_amt, p_user_id, SYSDATE,
                   v_payt_amt * DECODE (v_currency_cd, v_local_currency, 1, 1 / v_convert_rate), NVL (v_convert_rate, 1)
                  );
   EXCEPTION
      WHEN OTHERS
      THEN
         --VARIABLE.lv_sqlcode := SQLCODE;
         --VARIABLE.lv_sqlerrm := SQLERRM;
         --MESSAGE (TO_CHAR (VARIABLE.lv_sqlcode) || VARIABLE.lv_sqlerrm);
         raise_application_error (-20001, TO_CHAR (SQLCODE) || SQLERRM);
   END;

   IF SQL%NOTFOUND
   THEN
      raise_application_error (-20001, 'Cannot insert into GIAC_PAYT_REQUESTS_DTL');
   ELSE
      RETURN;
   END IF;
END;
/



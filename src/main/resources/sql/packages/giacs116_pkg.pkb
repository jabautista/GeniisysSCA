CREATE OR REPLACE PACKAGE BODY CPI.giacs116_pkg
AS
   FUNCTION get_amla_details (
      p_from_date    giac_acctrans.tran_date%TYPE,
      p_to_date      giac_acctrans.tran_date%TYPE--,
      --p_tran_class   giac_acctrans.tran_class%TYPE
   )
      RETURN amla_dtl_tab PIPELINED
   AS
      v_amla_dtl    amla_dtl_type;
      v_seq_no      NUMBER := 0;
      
      v_pay_mode   giac_collection_dtl.pay_mode%TYPE;
      v_pm_cnt     NUMBER           := 0;
      v_ctr_val    NUMBER           := giacp.n ('AMLA_CTR_VAL'); --added by Mark C 07142015      
   BEGIN
   /*
      FOR i IN (SELECT b.gibr_branch_cd,
                       TO_CHAR (a.tran_date, 'YYYYMMDD') tran_date,
                       DECODE (a.tran_class, 'COL', 'CCOL', 'CCDM') tran_type,
                       get_ref_no(a.tran_id) ref_no, b.collection_amt,
                       b.currency_cd, b.payor, c.currency_rt, c.short_name,
                       b.address_1||' '||b.address_2||' '||b.address_3 address
                  FROM giac_acctrans a, giac_order_of_payts b, giis_currency c
                 WHERE a.tran_id = b.gacc_tran_id
                   AND a.tran_class = NVL(p_tran_class, 'COL')
                   AND a.tran_flag <> 'D'
                   AND b.collection_amt > 500000
                   AND b.or_flag = 'P'
                   AND b.currency_cd = c.main_currency_cd
                   AND TRUNC(a.tran_date) >= p_from_date
                   AND TRUNC(a.tran_date) <= p_to_date) */		--commented by Mark C 07142015, replaced with codes below
      FOR i IN
         (
          --Direct
          SELECT b.gibr_branch_cd, a.tran_id, TO_CHAR (a.tran_date, 'YYYYMMDD') tran_date,
                   c.short_name, f.assd_no,
                   b.or_pref_suf || '-' || b.or_no ref_no, f.line_cd,
                   f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                   f.renew_no
              FROM giac_acctrans a,
                   giac_order_of_payts b,
                   giis_currency c,
                   giac_direct_prem_collns d,
                   gipi_invoice e,
                   gipi_polbasic f
             WHERE a.tran_id = b.gacc_tran_id
               AND a.tran_id = d.gacc_tran_id
               AND d.b140_iss_cd = e.iss_cd
               AND d.b140_prem_seq_no = e.prem_seq_no
               AND e.policy_id = f.policy_id
               AND a.tran_class = 'COL'
               AND a.tran_flag <> 'D'
               AND (   d.collection_amt > v_ctr_val
                    OR get_prem_amt (f.line_cd,
                                     f.subline_cd,
                                     f.iss_cd,
                                     f.issue_yy,
                                     f.pol_seq_no,
                                     f.renew_no
                                    ) > v_ctr_val
                   )
               AND b.or_flag = 'P'
               AND b.currency_cd = c.main_currency_cd
               AND TRUNC (a.tran_date) >= p_from_date
               AND TRUNC (a.tran_date) <= p_to_date
               AND f.pol_flag NOT IN ('4', '5')             -- added by Mark C. 07222015, to not include cancelled and spoiled policies
          GROUP BY a.tran_id,
                   TO_CHAR (a.tran_date, 'YYYYMMDD'),
                   c.short_name,
                   f.assd_no,
                   b.or_pref_suf || '-' || b.or_no,
                   f.line_cd,
                   f.subline_cd,
                   f.iss_cd,
                   f.issue_yy,
                   f.pol_seq_no,
                   f.renew_no,
                   b.gibr_branch_cd
          UNION
          --Inward
          SELECT  b.gibr_branch_cd, a.tran_id, TO_CHAR (a.tran_date, 'YYYYMMDD') tran_date,
                   c.short_name, f.assd_no,
                   b.or_pref_suf || '-' || b.or_no ref_no, f.line_cd,
                   f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                   f.renew_no
              FROM giac_acctrans a,
                   giac_order_of_payts b,
                   giis_currency c,
                   giac_inwfacul_prem_collns d,
                   gipi_invoice e,
                   gipi_polbasic f
             WHERE a.tran_id = b.gacc_tran_id
               AND a.tran_id = d.gacc_tran_id
               AND d.b140_iss_cd = e.iss_cd
               AND d.b140_prem_seq_no = e.prem_seq_no
               AND e.policy_id = f.policy_id
               AND a.tran_class = 'COL'
               AND a.tran_flag <> 'D'
               AND (   d.collection_amt > v_ctr_val
                    OR get_prem_amt (f.line_cd,
                                     f.subline_cd,
                                     f.iss_cd,
                                     f.issue_yy,
                                     f.pol_seq_no,
                                     f.renew_no
                                    ) > v_ctr_val
                   )
               AND b.or_flag = 'P'
               AND b.currency_cd = c.main_currency_cd
               AND TRUNC (a.tran_date) >= p_from_date
               AND TRUNC (a.tran_date) <= p_to_date
               AND f.pol_flag NOT IN ('4', '5')             -- added by Mark C. 07222015, to not include cancelled and spoiled policies
          GROUP BY a.tran_id,
                   TO_CHAR (a.tran_date, 'YYYYMMDD'),
                   b.or_pref_suf || '-' || b.or_no,
                   c.short_name,
                   f.assd_no,
                   b.or_pref_suf || '-' || b.or_no,
                   f.line_cd,
                   f.subline_cd,
                   f.iss_cd,
                   f.issue_yy,
                   f.pol_seq_no,
                   f.renew_no,
                   b.gibr_branch_cd
          ORDER BY tran_id)                   
      LOOP
        v_seq_no := v_seq_no + 1;
        v_amla_dtl.seq_no := v_seq_no;
        v_amla_dtl.branch_cd := i.gibr_branch_cd;
        v_amla_dtl.tran_date := i.tran_date;
        --v_amla_dtl.tran_type := i.tran_type;  -- commented out by Mark C. 07142015
        v_amla_dtl.ref_no := i.ref_no;
       /* v_amla_dtl.local_amt := i.collection_amt;
        v_amla_dtl.foreign_amt := i.collection_amt / i.currency_rt; */  -- commented out by Mark C. 07142015, replace with codes added below
        v_amla_dtl.currency_sname := i.short_name;
        
         --Added by Mark C. 07142015, pay_mode, tran_type
         BEGIN
            SELECT COUNT (DISTINCT pay_mode)
              INTO v_pm_cnt
              FROM giac_collection_dtl
             WHERE gacc_tran_id = i.tran_id AND pay_mode <> 'CW';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_pm_cnt := 0;
         END;

         IF v_pm_cnt > 1
         THEN
            v_amla_dtl.tran_type := 'NPLPY';
         ELSE
            BEGIN
               SELECT DISTINCT pay_mode
                          INTO v_pay_mode
                          FROM giac_collection_dtl
                         WHERE gacc_tran_id = i.tran_id AND pay_mode <> 'CW';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_pay_mode := NULL;
            END;                                  

            IF v_pay_mode = 'CA'
            THEN                                                        --Cash
               v_amla_dtl.tran_type := 'NPLPC';
            ELSIF v_pay_mode = 'CM'
            THEN                                                 --Credit Memo
               v_amla_dtl.tran_type := 'NLPLD';
            ELSIF v_pay_mode IN ('CHK', 'PDC')
            THEN                                                       --Check
               v_amla_dtl.tran_type := 'NPLPM';
            ELSIF v_pay_mode = 'CC'
            THEN                                                 --Credit Card
               v_amla_dtl.tran_type := 'NPLPR';
            ELSIF v_pay_mode = 'WT'
            THEN                                               --Wire Transfer
               v_amla_dtl.tran_type := 'NPLPW';
            ELSE
               v_amla_dtl.tran_type := 'NPLPS';
            END IF;
         END IF;			--Mark C. 07142015: add ends
                 
        giacs116_pkg.get_payor_dtl(i.assd_no,
        						   --i.payor, i.address, NULL, NULL,		--commented out by Mark C. 07142015
        						   v_amla_dtl.payor_type,
                                   v_amla_dtl.corporate_name, v_amla_dtl.last_name, v_amla_dtl.first_name,
                                   v_amla_dtl.middle_name,v_amla_dtl.address1, v_amla_dtl.address2,
                                   v_amla_dtl.address3, v_amla_dtl.birthdate);
        
        IF v_amla_dtl.payor_type = 'Y' THEN
            v_amla_dtl.client_type := 2;
        ELSIF v_amla_dtl.payor_type = 'N' THEN
            v_amla_dtl.client_type := 1;
        END IF;

         --Added by Mark C. 07142015, get various policy info
         v_amla_dtl.policy_no :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));
            
         --            edited by gab 05.11.2016 SR 21922
         giacs116_pkg.get_pol_dtl (i.line_cd,
                                   i.subline_cd,
                                   i.iss_cd,
                                   i.issue_yy,
                                   i.pol_seq_no,
                                   i.renew_no,
                                   v_amla_dtl.eff_date,
                                   v_amla_dtl.expiry_date,
                                   v_amla_dtl.local_amt,
                                   v_amla_dtl.foreign_amt,
                                   v_amla_dtl.fc_tsi_amt, 
                                   v_amla_dtl.tsi_amt
                                  );  
        PIPE ROW(v_amla_dtl);
      END LOOP;
      
      /*		-- commented out by Mark C. 07062015, only collection transactions are reportable for covered persons report
      FOR a IN (SELECT a.gibr_branch_cd, TO_CHAR(a.tran_date, 'YYYYMMDD') tran_date,
                       DECODE(a.tran_class, 'DV', 'CBPYM', 'CCDM') tran_type,
                       get_ref_no(a.tran_id) ref_no, b.dv_amt,
                       b.dv_fcurrency_amt, d.short_name,
                       b.payee, c.payee_class_cd, c.payee_cd
                  FROM giac_acctrans a, giac_disb_vouchers b,
                       giac_payt_requests_dtl c, giis_currency d
                 WHERE a.tran_id = b.gacc_tran_id
                   AND b.gacc_tran_id = c.tran_id
                   AND b.currency_cd = d.main_currency_cd
                   AND b.dv_amt > 500000
                   AND a.tran_flag <> 'D'
                   AND b.print_tag = 6
                   AND a.tran_class = NVL(p_tran_class, 'DV')
                   AND TRUNC(a.tran_date) >= p_from_date
                   AND TRUNC(a.tran_date) <= p_to_date)
       LOOP
        v_seq_no := v_seq_no + 1;
        v_amla_dtl.seq_no := v_seq_no;
        v_amla_dtl.branch_cd := a.gibr_branch_cd;
        v_amla_dtl.tran_date := a.tran_date;
        v_amla_dtl.tran_type := a.tran_type;
        v_amla_dtl.ref_no := a.ref_no;
        v_amla_dtl.local_amt := a.dv_amt;
        v_amla_dtl.foreign_amt := a.dv_fcurrency_amt;
        v_amla_dtl.currency_sname := a.short_name;
        giacs116_pkg.get_payor_dtl(a.payee, NULL, a.payee_class_cd, a.payee_cd, v_amla_dtl.payor_type,
                                   v_amla_dtl.corporate_name, v_amla_dtl.last_name, v_amla_dtl.first_name,
                                   v_amla_dtl.middle_name,v_amla_dtl.address1, v_amla_dtl.address2,
                                   v_amla_dtl.address3, v_amla_dtl.birthdate);
        
        IF v_amla_dtl.payor_type = 'Y' THEN
            v_amla_dtl.client_type := 2;
        ELSIF v_amla_dtl.payor_type = 'N' THEN
            v_amla_dtl.client_type := 1;
        END IF;
        PIPE ROW(v_amla_dtl);
       END LOOP;
       
       FOR c IN (SELECT b.gibr_branch_cd, TO_CHAR(b.tran_date, 'YYYYMMDD') tran_date,
                        DECODE(b.tran_class, 'CM', 'CCDM', 'DM', 'CDBM', 'CCDM') tran_type,
                        get_ref_no(b.tran_id) ref_no, a.local_amt,
                        a.amount, c.short_name, a.recipient
                   FROM giac_cm_dm a, giac_acctrans b,
                        giis_currency c
                  WHERE a.gacc_tran_id = b.tran_id
                    AND a.currency_cd = c.main_currency_cd
                    AND b.tran_flag <> 'D'
                    AND a.memo_status = 'P'
                    AND a.local_amt > 500000
                    AND (b.tran_class = NVL(p_tran_class, 'CM')
                         OR b.tran_class = NVL(p_tran_class, 'DM'))
                    AND TRUNC(b.tran_date) >= p_from_date
                    AND TRUNC(b.tran_date) <= p_to_date)
       LOOP
        v_seq_no := v_seq_no + 1;
        v_amla_dtl.seq_no := v_seq_no;
        v_amla_dtl.branch_cd := c.gibr_branch_cd;
        v_amla_dtl.tran_date := c.tran_date;
        v_amla_dtl.tran_type := c.tran_type;
        v_amla_dtl.ref_no := c.ref_no;
        v_amla_dtl.local_amt := c.local_amt;
        v_amla_dtl.foreign_amt := c.amount;
        v_amla_dtl.currency_sname := c.short_name;
        giacs116_pkg.get_payor_dtl(c.recipient, NULL, NULL, NULL, v_amla_dtl.payor_type,
                                   v_amla_dtl.corporate_name, v_amla_dtl.last_name, v_amla_dtl.first_name,
                                   v_amla_dtl.middle_name,v_amla_dtl.address1, v_amla_dtl.address2,
                                   v_amla_dtl.address3, v_amla_dtl.birthdate);
        
        IF v_amla_dtl.payor_type = 'Y' THEN
            v_amla_dtl.client_type := 2;
        ELSIF v_amla_dtl.payor_type = 'N' THEN
            v_amla_dtl.client_type := 1;
        END IF;
        PIPE ROW(v_amla_dtl);
       END LOOP;*/
   END get_amla_details;
   
  PROCEDURE get_payor_dtl (
	  p_assd_no             IN      gipi_polbasic.assd_no%TYPE,
      --p_payor               IN      giac_order_of_payts.payor%TYPE,
      --p_address             IN      VARCHAR2,
      --p_class_cd            IN      giac_payt_requests_dtl.payee_class_cd%TYPE,
      --p_payee_cd            IN      giac_payt_requests_dtl.payee_cd%TYPE,
      p_payor_type          OUT     VARCHAR2,
      p_corporate_name      OUT     VARCHAR2,
      p_last_name           OUT     VARCHAR2,
      p_first_name          OUT     VARCHAR2,
      p_middle_name         OUT     VARCHAR2,
      p_address1            OUT     VARCHAR2,
      p_address2            OUT     VARCHAR2,
      p_address3            OUT     VARCHAR2,
      p_birthdate           OUT     VARCHAR2
  )
  AS
    v_address   VARCHAR2(250);
  BEGIN
    BEGIN
       /* 
        SELECT UPPER(SUBSTR(REPLACE(intm_name, ','), 1, 90)) corporate_name, NULL last_name, NULL first_name,
               NULL middle_name, 'Y' payor_type, 
               UPPER(REPLACE(mail_addr1||' '||mail_addr2||' '||mail_addr3, ',')) address,
               TO_CHAR(birthdate, 'YYYYMMDD') birth_date
          INTO p_corporate_name, p_last_name, p_first_name,
               p_middle_name, p_payor_type,
               v_address, p_birthdate
          FROM giis_intermediary
         WHERE intm_name = p_payor
        UNION ALL 
        SELECT DECODE(corporate_tag, 'I', NULL, UPPER(SUBSTR(REPLACE(assd_name, ','), 1, 90))) corporate_name,
               DECODE(corporate_tag, 'I', UPPER(SUBSTR(REPLACE(last_name, ','), 1, 30)), NULL) last_name,
               DECODE(corporate_tag, 'I', UPPER(SUBSTR(REPLACE(first_name, ','), 1, 30)), NULL) first_name,
               DECODE(corporate_tag, 'I', UPPER(SUBSTR(REPLACE(middle_initial, ','), 1, 30)), NULL) middle_initial,
               DECODE(corporate_tag, 'I', 'N', 'Y') payor_type,
               UPPER(REPLACE(mail_addr1||' '||mail_addr2||' '||mail_addr3, ',')) address,
               NULL
          FROM giis_assured
         WHERE assd_name = p_payor
        UNION ALL
        SELECT UPPER (SUBSTR(REPLACE(ri_name, ','), 1, 90)) corporate_name, NULL last_name, NULL first_name,
               NULL middle_name, 'Y' payor_type, 
               UPPER(REPLACE(mail_address1||' '||mail_address2||' '||mail_address3, ',')) address,
               NULL
          FROM giis_reinsurer
         WHERE ri_name = p_payor;
        
        p_address1 := SUBSTR(v_address, 1, 30);
        p_address2 := SUBSTR(v_address, 31, 30);
        p_address3 := SUBSTR(v_address, 61, 30); */ 	-- --commented out by Mark C. 07142015, values are obtained by assured maintenance, replaced by codes below
        
         SELECT DECODE (corporate_tag,
                        'I', NULL,
                        UPPER (SUBSTR (REPLACE (assd_name, ','), 1, 90))
                       ) corporate_name,
                DECODE (corporate_tag,
                        'I', UPPER (SUBSTR (REPLACE (last_name, ','), 1, 30)),
                        NULL
                       ) last_name,
                DECODE (corporate_tag,
                        'I', UPPER (SUBSTR (REPLACE (first_name, ','), 1, 30)),
                        NULL
                       ) first_name,
                DECODE (corporate_tag,
                        'I', UPPER (SUBSTR (REPLACE (middle_initial, ','),
                                            1,
                                            30
                                           )
                                   ),
                        NULL
                       ) middle_initial,
                DECODE (corporate_tag, 'I', 'N', 'Y') payor_type,
                UPPER (REPLACE (mail_addr1, ',')) address1,
                UPPER (REPLACE (mail_addr2, ',')) address2,
                UPPER (SUBSTR (REPLACE (mail_addr3, ','), 1, 30)) address3,
                TO_CHAR(TO_DATE (birth_year, 'YYYY'), 'YYYY')||TO_CHAR(TO_DATE (birth_month, 'mm'), 'mm')||TO_CHAR(TO_DATE (birth_date, 'dd'), 'dd') birthdate --added by gab 04.27.2016 SR 21922
           INTO p_corporate_name,
                p_last_name,
                p_first_name,
                p_middle_name,
                p_payor_type,
                p_address1,
                p_address2,
                p_address3,
                p_birthdate
           FROM giis_assured
          WHERE assd_no = p_assd_no;
                  
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
         /*   IF p_class_cd IS NULL OR p_payee_cd IS NULL THEN
                p_payor_type := 'Y';
                p_corporate_name := UPPER(SUBSTR(REPLACE(p_payor, ','), 1, 90));
                p_address1 := UPPER(SUBSTR(REPLACE(p_address, ','), 1, 30));
                p_address2 := UPPER(SUBSTR(REPLACE(p_address, ','), 31, 30));
                p_address3 := UPPER(SUBSTR(REPLACE(p_address, ','), 61, 30));
            ELSE
                SELECT SUBSTR(DECODE(payee_first_name, NULL, REPLACE(payee_last_name, ','), NULL), 1, 90) corporate_name,
                       SUBSTR(DECODE(payee_first_name, NULL, NULL, REPLACE(payee_last_name, ',')), 1, 30) last_name,
                       SUBSTR(DECODE(payee_first_name, NULL, NULL, REPLACE(payee_first_name, ',')), 1, 30) first_name,
                       SUBSTR(DECODE(payee_first_name, NULL, NULL, REPLACE(payee_middle_name, ',')), 1, 30) middle_name,
                       DECODE(payee_first_name, NULL, 'Y', 'N') payor_type,
                       UPPER(REPLACE(mail_addr1||' '||mail_addr2||' '||mail_addr3, ',')) address,
                       NULL
                  INTO p_corporate_name, p_last_name, p_first_name,
                       p_middle_name, p_payor_type,
                       v_address, p_birthdate
                  FROM giis_payees
                 WHERE payee_no = p_payee_cd
                   AND payee_class_cd = p_class_cd;
                
                p_address1 := SUBSTR(v_address, 1, 30);
                p_address2 := SUBSTR(v_address, 31, 30);
                p_address3 := SUBSTR(v_address, 61, 30);
            END IF; */ --commented out by Mark C. 07142015,	values are obtained from assured maintenance
            NULL;
    END;
  END get_payor_dtl;
  PROCEDURE insert_amla_ext(
      p_from_date       IN    giac_acctrans.tran_date%TYPE,
      p_to_date         IN    giac_acctrans.tran_date%TYPE,
      --p_tran_class      IN    giac_acctrans.tran_class%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE, --added by gab
      p_count           OUT   NUMBER,
      p_sum_amount      OUT   NUMBER
   )
   AS
	  v_refno_cnt   NUMBER := 0;                  -- Added by Mark C. 07142015   		
   BEGIN
        DELETE cpi.giac_amla_ext
         WHERE user_id = p_user_id;
        COMMIT;
        
        FOR rec IN (SELECT *
                      FROM TABLE (giacs116_pkg.get_amla_details (p_from_date, p_to_date
                      													  --, p_tran_class
                      													  )))
        LOOP
            INSERT INTO CPI.giac_amla_ext
               (seq_no, branch_cd, tran_date, tran_type, ref_no, client_type,
                local_amt, foreign_amt, currency_sname, payor_type, corporate_name,
                last_name, first_name, middle_name, address1, address2, address3,
                birthdate, user_id, last_update, policy_no, eff_date, expiry_date, --added by Mark C. 07132015, policy_no, eff_date, expiry_date
                tsi_amt) --added by gab 04.08.2016 SR 21922
             VALUES
               (rec.seq_no, rec.branch_cd, rec.tran_date, rec.tran_type, rec.ref_no, rec.client_type,
                rec.local_amt, rec.foreign_amt, rec.currency_sname, rec.payor_type, rec.corporate_name,
                rec.last_name, rec.first_name, rec.middle_name, rec.address1, rec.address2, rec.address3,
                rec.birthdate, p_user_id, SYSDATE, rec.policy_no, rec.eff_date, rec.expiry_date, --added by Mark C. 07132015, rec.policy_no, rec.eff_date, rec.expiry_date
                rec.tsi_amt); --added by gab 04.08.2016 SR 21922  
        END LOOP;
        
        --Mark C. 07142015, added codes to update duplicate ref_no
        BEGIN
           FOR c_ref IN (SELECT   ref_no, COUNT (seq_no)
                           FROM cpi.giac_amla_ext
                          WHERE user_id = p_user_id
                       GROUP BY ref_no
                         HAVING COUNT (seq_no) > 1)
           LOOP
              FOR c_seq IN (SELECT   seq_no, ref_no
                              FROM cpi.giac_amla_ext
                             WHERE user_id = p_user_id AND ref_no = c_ref.ref_no
                          ORDER BY 1)
              LOOP
                 v_refno_cnt := v_refno_cnt + 1;

                 UPDATE cpi.giac_amla_ext
                    SET ref_no = c_seq.ref_no || '-' || TO_CHAR (v_refno_cnt)
                  WHERE user_id = p_user_id AND seq_no = c_seq.seq_no;
              END LOOP;

              v_refno_cnt := 0;
           END LOOP;
        END;

      --Mark C. 07142015, add ends
        COMMIT;
        
        BEGIN
            SELECT SUM(local_amt), MAX(seq_no)
              INTO p_sum_amount, p_count
              FROM giac_amla_ext
             WHERE user_id = p_user_id;
        EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                p_sum_amount := 0;
                p_count := 0;
        END;
   END insert_amla_ext;
  
-- Mark C. 07142015, added the ff. procedure to retrieve various policy info
   PROCEDURE get_pol_dtl (
      p_line_cd       IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date      OUT      VARCHAR2,
      p_expiry_date   OUT      VARCHAR2,
      p_loc_prem      OUT      NUMBER,
      p_for_prem      OUT      NUMBER,
      p_loc_tsi       OUT      NUMBER, --added by gab 05.02.2016 SR 21922
      p_for_tsi       OUT      NUMBER --added by gab 05.02.2016 SR 21922
   )
   AS
   BEGIN
      FOR rec IN (SELECT TO_CHAR (eff_date, 'YYYYMMDD') eff_date
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND endt_seq_no = 0)
      LOOP
         p_eff_date := rec.eff_date;
         EXIT;
      END LOOP rec;

      FOR i IN (SELECT   TO_CHAR (NVL (expiry_date, endt_expiry_date),
                                  'YYYYMMDD'
                                 ) expiry_date
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag NOT IN ('4', '5')
                ORDER BY endt_seq_no DESC)
      LOOP
         p_expiry_date := i.expiry_date;
         EXIT;
      END LOOP;

      -- edited by gab 05.02.2016 SR 21922
      BEGIN
         SELECT SUM (NVL (a.prem_amt, 0)) loc_prem,
                SUM (NVL (b.prem_amt, 0)) for_prem,
                SUM (NVL (a.tsi_amt, 0)) loc_tsi,
                ROUND(SUM(NVL (a.tsi_amt, 0)) / SUM(NVL(b.currency_rt, 1)),2)  for_tsi 
           INTO p_loc_prem,
                p_for_prem,
                p_loc_tsi,
                p_for_tsi
           FROM gipi_polbasic a, gipi_invoice b
          WHERE a.policy_id = b.policy_id
            AND a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND a.pol_flag != '5';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_loc_prem := 0;
            p_for_prem := 0;
      END;
   END get_pol_dtl;

-- Mark C. 07142015, added the ff. function to get prem amt of policy and endts.
   FUNCTION get_prem_amt (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_prem_amt   NUMBER := 0;
   BEGIN
      BEGIN
         SELECT SUM (NVL (prem_amt, 0)) prem_amt
           INTO v_prem_amt
           FROM gipi_polbasic a
          WHERE pol_flag != '5'
            AND line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND issue_yy = p_issue_yy
            AND pol_seq_no = p_pol_seq_no
            AND renew_no = p_renew_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_prem_amt := 0;
      END;

      RETURN (v_prem_amt);
   END get_prem_amt;
-- Mark C. 07142015, add ends

END giacs116_pkg;
/



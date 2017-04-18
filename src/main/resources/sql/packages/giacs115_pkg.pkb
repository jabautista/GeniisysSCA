CREATE OR REPLACE PACKAGE BODY CPI.GIACS115_PKG
AS
   /* Created by : Bonok
   * Date Created : 9.30.2013
   * Reference By : GIACS115 - BIR RELIEF FORMS
   *
   */ 

   FUNCTION get_giacs115_list(
      p_rep_type           VARCHAR2,
      p_alp_type           VARCHAR2,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE
   ) RETURN giacs115_tab PIPELINED AS
      res                  giacs115_type;
   BEGIN
      IF p_rep_type = 'A' THEN
         IF p_alp_type = 'E' THEN
            IF p_bir_freq_tag_query = 'M' THEN
               FOR i IN (SELECT report_id, report_title
                           FROM giis_reports
                          WHERE report_id IN ('1601E')) -- ('1601E', '1601F', '1600')Edited by MarkS 9.15.2016 SR5632
               LOOP
                  res.report_id := i.report_id;
                  res.report_title := i.report_title;
                     
                  PIPE ROW(res);
               END LOOP;
            ELSIF p_bir_freq_tag_query = 'A' THEN
               FOR i IN (SELECT report_id, report_title
                           FROM giis_reports
                          WHERE report_id IN ('1604E')) -- ('1604E', '1604CF'Edited by MarkS 9.15.2016 SR5632
               LOOP
                  res.report_id := i.report_id;
                  res.report_title := i.report_title;
                     
                  PIPE ROW(res);
               END LOOP;
            END IF; 
         ELSE
            /* IF p_bir_freq_tag_query = 'M' THEN --commented out by MarkS for SR5632
               FOR i IN (SELECT report_id, report_title
                           FROM giis_reports
                          WHERE report_id IN ('SAWT')
                            AND bir_freq_tag = 'M')
               LOOP
                  res.report_id := i.report_id;
                  res.report_title := i.report_title;
                     
                  PIPE ROW(res);
               END LOOP;
            ELSIF p_bir_freq_tag_query = 'A' THEN
               FOR i IN (SELECT report_id, report_title
                           FROM giis_reports
                          WHERE report_id IN ('SAWT')
                            AND bir_freq_tag = 'A')
               LOOP
                  res.report_id := i.report_id;
                  res.report_title := i.report_title;
                     
                  PIPE ROW(res);
               END LOOP;
            END IF; */ 
            --Edited by MarkS 9.15.2016 SR5632
            FOR i IN (SELECT report_id, report_title
                           FROM giis_reports
                          WHERE report_id IN ('SAWT')
                            AND bir_freq_tag = 'A')
               LOOP
                  res.report_id := i.report_id;
                  res.report_title := i.report_title;
                     
                  PIPE ROW(res);
               END LOOP;
             --end SR5632
         END IF;
      ELSIF p_rep_type = 'R' THEN
         IF p_alp_type = 'S' THEN 
             FOR i IN (SELECT report_id, report_title
                               FROM giis_reports
                              WHERE report_id IN ('2550M')) -- ('2550M', '2551M')Edited by MarkS 9.15.2016 SR5632
             LOOP
                res.report_id := i.report_id;
                res.report_title := i.report_title;
                         
                PIPE ROW(res);
             END LOOP;
         END IF;
      END IF;
   END;
   
   FUNCTION check_extract(
      p_rep_type           VARCHAR2,
      p_alp_type           VARCHAR2,
      p_report_id          giis_reports.report_id%TYPE,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_map_expanded_ext.user_id%TYPE
   ) RETURN VARCHAR2 AS
      v_ext                VARCHAR2(1) :='N';
   BEGIN
      IF p_rep_type = 'A' THEN
		   IF p_alp_type = 'E' THEN
			   IF p_report_id IN ('1601E', '1604E') THEN
			      BEGIN
   			      SELECT DISTINCT 'Y'
						  INTO v_ext
						  FROM giac_map_expanded_ext
						 WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
						   AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
						   AND user_id = p_user_id
						   AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL (period_tag, 'M'), 'A');
			      EXCEPTION
			         WHEN NO_DATA_FOUND THEN
			            v_ext := 'N';
			      END;
			   END IF;  
			ELSIF p_alp_type = 'W' THEN
				IF p_report_id IN ('SAWT') THEN
				   BEGIN
				      SELECT DISTINCT 'Y'
						  INTO v_ext
						  FROM giac_sawt_ext
						 WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
						   AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
						   AND user_id = p_user_id
						   AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL (period_tag, 'M'), 'A');
				   EXCEPTION
				      WHEN NO_DATA_FOUND THEN
				         v_ext := 'N';
				   END;
				END IF;  
		   END IF;
	   ELSIF p_rep_type = 'R' --added by robert SR 5473 03.14.16
       THEN
          IF p_alp_type = 'S'
          THEN
             IF p_report_id IN ('2550M')
             THEN
                BEGIN
                   SELECT DISTINCT 'Y'
                     INTO v_ext
                     FROM GIAC_RELIEF_SLS_EXT
                    WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
                      AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
                      AND user_id = p_user_id
                      AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL (period_tag, 'M'), 'A');
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      v_ext := 'N';
                END;
             END IF;
          END IF;
	   END IF;

      RETURN(v_ext);
   END;
   
   PROCEDURE extract_giacs115(
      p_report_id          IN  giis_reports.report_id%TYPE,
      p_rep_type           IN  VARCHAR2,
      p_alp_type           IN  VARCHAR2,
      p_bir_freq_tag_query IN  giac_map_expanded_ext.period_tag%TYPE,
      p_month              IN  giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_yyear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN  giac_sawt_ext.user_id%TYPE,
      p_count              OUT NUMBER
   ) AS
      v_with_report           VARCHAR2(1) := 'N';
   BEGIN
      BEGIN
         SELECT bir_with_report
           INTO v_with_report
           FROM giis_reports
          WHERE bir_tag = 'Y' 
            AND report_id = p_report_id;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
               raise_application_error(-20001, 'Geniisys Exception#I#No record found in GIIS_REPORTS.');
      END;
      
      IF NVL(v_with_report,'N') = 'N' THEN --Edited by MarkS 9.15.2016 SR5632
            raise_application_error(-20001, 'Geniisys Exception#I#Not yet available in the system.');
      ELSIF NVL(v_with_report,'N') = 'Y' THEN --Edited by MarkS 9.15.2016 SR5632
         continue_extract(p_report_id, p_bir_freq_tag_query, p_month, p_myear, p_yyear, p_user_id, p_count);      
      END IF;
   END;
   
   PROCEDURE continue_extract(
      p_report_id          IN  giis_reports.report_id%TYPE,
      p_bir_freq_tag_query IN  giac_map_expanded_ext.period_tag%TYPE,
      p_month              IN  giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_yyear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN  giac_sawt_ext.user_id%TYPE,
      p_count              OUT NUMBER
   ) AS
      v_count              NUMBER := 0;
   BEGIN
      IF p_report_id IN ('1601E', '1604E') THEN
         map_expanded(p_month, p_myear, p_yyear, p_bir_freq_tag_query, p_user_id);
         
         SELECT COUNT (*)
			  INTO v_count
           FROM giac_map_expanded_ext
          WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
            AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
            AND user_id = p_user_id
            AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL (period_tag, 'M'), 'A');
      ELSIF p_report_id IN ('SAWT') THEN
         sawt_expanded(p_month, p_myear, p_yyear, p_bir_freq_tag_query, p_user_id);
			
         SELECT COUNT (*)
			  INTO v_count
			  FROM giac_sawt_ext
			 WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
			   AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
			   AND user_id = p_user_id
			   AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL (period_tag, 'M'), 'A');
      ELSIF p_report_id IN ('2550M') THEN
         sls_vat(p_month, p_myear, p_yyear, p_bir_freq_tag_query, p_user_id);

         SELECT COUNT (*)
           INTO v_count
           FROM giac_relief_sls_ext
          WHERE return_month = DECODE (p_bir_freq_tag_query, 'M', p_month, 12)
            AND return_year = DECODE (p_bir_freq_tag_query, 'M', p_myear, p_yyear)
            AND user_id = p_user_id
            AND period_tag = DECODE (p_bir_freq_tag_query, 'M', NVL(period_tag, 'M'), 'A');
      END IF;
      
      p_count := v_count;
   END;
   
   PROCEDURE map_expanded (
      p_return_month       giac_map_expanded_ext.return_month%TYPE,
      p_return_myear       giac_map_expanded_ext.return_year%TYPE,
      p_return_yyear       giac_map_expanded_ext.return_year%TYPE,
      p_period_tag         giac_map_expanded_ext.period_tag%TYPE,
      p_user_id            giac_map_expanded_ext.user_id%TYPE
   ) AS
      v_seq_no             NUMBER(8) := 0;
      v_tin                VARCHAR2(15);
      v_atc_code           VARCHAR2(5);
      v_ret_mm             giac_map_expanded_ext.return_month%TYPE;
      v_ret_yr             giac_map_expanded_ext.return_year%TYPE;
   BEGIN
      DELETE FROM giac_map_expanded_ext
       WHERE return_month = DECODE (p_period_tag, 'M', p_return_month, 12)
         AND return_year = DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
         AND period_tag = DECODE (p_period_tag, 'M', NVL (period_tag, 'M'), 'A')
         AND user_id = p_user_id;
         
      FOR rec IN (SELECT *
                    FROM (SELECT DECODE (b.payee_first_name, NULL, b.payee_last_name, NULL) corporate_name,
                                 DECODE (b.payee_first_name, NULL, NULL, b.payee_last_name) last_name,
                                 b.payee_first_name first_name, b.payee_middle_name middle_name, b.tin,
                                 e.bir_tax_cd atc_code, e.percent_rate tax_rate,
                                 SUM (d.income_amt) tax_base, SUM (d.wholding_tax_amt) wtax
                            FROM giis_payee_class a,
                                 giis_payees b,
                                 giac_acctrans c,
                                 giac_taxes_wheld d,
                                 giac_wholding_taxes e
                           WHERE 1 = 1
                             AND d.payee_class_cd = b.payee_class_cd
                             AND d.gwtx_whtax_id = e.whtax_id
                             AND d.payee_cd = b.payee_no
                             AND b.payee_class_cd = a.payee_class_cd
                             AND d.gacc_tran_id = c.tran_id
                             AND c.tran_flag <> 'D'
                             AND DECODE (p_period_tag, 'M', TO_CHAR (c.posting_date, 'MM'), 'A') =
                                 DECODE (p_period_tag, 'M', LTRIM(TO_CHAR(p_return_month,'00')), 'A')
                             AND TO_NUMBER(TO_CHAR (c.posting_date, 'RRRR')) =
                                 DECODE (p_period_tag, 'M', p_return_myear, TO_NUMBER(p_return_yyear))
                             AND b.payee_class_cd NOT IN (giacp.v ('ASSD_CLASS_CD'),giacp.v ('INTM_CLASS_CD'))
                           GROUP BY DECODE (b.payee_first_name, NULL, b.payee_last_name, NULL),
                                    DECODE (b.payee_first_name, NULL, NULL, b.payee_last_name),
                                    b.payee_first_name, b.payee_middle_name, b.tin, e.bir_tax_cd, e.percent_rate
                          UNION ALL
                          SELECT DECODE (b.lic_tag, 'N', a.intm_name, b.intm_name),
                                 NULL, NULL, NULL,
                                 DECODE (b.lic_tag, 'Y', b.tin, a.tin), e.bir_tax_cd, e.percent_rate, SUM (d.income_amt),
                                 SUM (d.wholding_tax_amt) wtax
                            FROM giis_intermediary a,
                                 giis_intermediary b,
                                 giac_acctrans c,
                                 giac_taxes_wheld d,
                                 giac_wholding_taxes e
                           WHERE 1 = 1
                             AND d.payee_class_cd = giacp.v('INTM_CLASS_CD')
                             AND d.gwtx_whtax_id = e.whtax_id
                             AND d.payee_cd = b.intm_no
                             AND d.gacc_tran_id = c.tran_id
                             AND a.intm_no = NVL (b.parent_intm_no, b.intm_no)
                             AND c.tran_flag <> 'D'
                             AND DECODE (p_period_tag, 'M', TO_CHAR (c.posting_date, 'MM'), 'A') =
                                 DECODE (p_period_tag, 'M', LTRIM(TO_CHAR(p_return_month,'00')), 'A')
                             AND TO_NUMBER(TO_CHAR (c.posting_date, 'RRRR')) = 
                                 DECODE (p_period_tag,'M', p_return_myear, TO_NUMBER(p_return_yyear))
                           GROUP BY DECODE (b.lic_tag, 'N', a.intm_name, b.intm_name),
                                    DECODE (b.lic_tag, 'Y', b.tin, a.tin), e.bir_tax_cd, e.percent_rate
                          UNION ALL
                          SELECT DECODE (b.corporate_tag, 'C', b.assd_name, NULL),
                                 DECODE (b.corporate_tag, 'I', b.last_name, NULL),
                                 DECODE (b.corporate_tag,'I', b.first_name, NULL),
                                 DECODE (b.corporate_tag, 'I', b.middle_initial, NULL),
                                 b.assd_tin, e.bir_tax_cd, e.percent_rate,
                                 SUM (d.income_amt), SUM (d.wholding_tax_amt)
                            FROM giis_assured b,
                                 giac_acctrans c,
                                 giac_taxes_wheld d,
                                 giac_wholding_taxes e
                           WHERE 1 = 1
                             AND d.payee_class_cd = giacp.v ('ASSD_CLASS_CD')
                             AND d.gwtx_whtax_id = e.whtax_id
                             AND d.payee_cd = b.assd_no
                             AND d.gacc_tran_id = c.tran_id
                             AND c.tran_flag <> 'D'
                             AND DECODE (p_period_tag,'M', TO_CHAR (c.posting_date, 'MM'), 'A') =
                                 DECODE (p_period_tag,'M', LTRIM(TO_CHAR(p_return_month,'00')), 'A')
                             AND TO_NUMBER(TO_CHAR (c.posting_date, 'RRRR')) = 
                                 DECODE (p_period_tag, 'M', p_return_myear, TO_NUMBER(p_return_yyear))
                           GROUP BY DECODE (b.corporate_tag, 'C', b.assd_name, NULL),
                                    DECODE (b.corporate_tag, 'I', b.last_name, NULL),
                                    DECODE (b.corporate_tag, 'I', b.first_name, NULL),
                                    DECODE (b.corporate_tag, 'I', b.middle_initial, NULL),
                                    b.assd_tin, e.bir_tax_cd, e.percent_rate)
                   WHERE wtax <> 0                   
                   ORDER BY corporate_name || last_name, atc_code)
      LOOP
         BEGIN
            v_tin := TO_NUMBER (REPLACE (REPLACE (rec.tin, '-', ''), ' '));

            IF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 5 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 6 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 7 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 8 THEN
               v_tin := NULL;
            ELSE
               IF v_tin = 0 THEN
                  v_tin := NULL;
               ELSIF LENGTH (rec.tin) = 15 AND LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 12 THEN
                  v_tin := REPLACE (rec.tin, ' ', '-');
               ELSIF LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 12 AND LENGTH (rec.tin) = 12 THEN
                  v_tin :=
                        SUBSTR (rec.tin, 1, 3)
                     || '-'
                     || SUBSTR (rec.tin, 4, 3)
                     || '-'
                     || SUBSTR (rec.tin, 7, 3)
                     || '-'
                     || SUBSTR (rec.tin, 10, 3);
               ELSIF LENGTH (rec.tin) = 11 AND LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 9 THEN
                  v_tin := REPLACE (rec.tin, ' ', '-') || '-000';
               ELSIF LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 9 AND LENGTH (rec.tin) = 9 THEN
                  v_tin :=
                        SUBSTR (rec.tin, 1, 3)
                     || '-'
                     || SUBSTR (rec.tin, 4, 3)
                     || '-'
                     || SUBSTR (rec.tin, 7, 3)
                     || '-000';
               ELSE
                  v_tin := NULL;
               END IF;
            END IF;
         EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
               v_tin := NULL;
         END;

         v_atc_code := SUBSTR (rec.atc_code, 1, 5);
         v_seq_no := v_seq_no + 1;

         SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
           INTO v_ret_mm
           FROM DUAL;

         SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
           INTO v_ret_yr
           FROM DUAL;

         INSERT INTO giac_map_expanded_ext
                     (return_month, return_year, seq_no, corporate_name,
                      last_name, first_name, middle_name, tin,
                      atc_code, tax_rate, tax_base, wholding_tax_amt,
                      user_id, last_update, period_tag
                     )
              VALUES (v_ret_mm, v_ret_yr, v_seq_no, UPPER(rec.corporate_name),
                      UPPER(rec.last_name), UPPER(rec.first_name), UPPER(rec.middle_name), v_tin,
                      v_atc_code, rec.tax_rate, rec.tax_base, rec.wtax,
                      p_user_id, SYSDATE, p_period_tag
                     );
      END LOOP;
   END;
   
   PROCEDURE sawt_expanded (
      p_return_month       giac_sawt_ext.return_month%TYPE,
      p_return_myear       giac_sawt_ext.return_year%TYPE,
      p_return_yyear       giac_sawt_ext.return_year%TYPE,
      p_period_tag         giac_sawt_ext.period_tag%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) AS
      v_seq_no          NUMBER (8) := 0;
      v_tin             VARCHAR2 (15);
      v_rec_tin         giis_payees.tin%TYPE;
      v_atc_code        VARCHAR2 (5);
      v_corporate_name  giac_sawt_ext.corporate_name%TYPE;
      v_last_name       giac_sawt_ext.last_name%TYPE;
      v_first_name      giac_sawt_ext.first_name%TYPE;
      v_middle_name     giac_sawt_ext.middle_name%TYPE;
      v_base_amount     giac_sawt_ext.base_amount%TYPE;
      v_creditable_amt  giac_sawt_ext.creditable_amt%TYPE;
      v_tax_rate        giac_sawt_ext.tax_rate%TYPE;
      v_ret_mm          giac_sawt_ext.return_month%TYPE;
      v_ret_yr          giac_sawt_ext.return_year%TYPE;
      v_exists          NUMBER(1) := 0;
   BEGIN
      DELETE FROM giac_sawt_ext
       WHERE return_month = DECODE (p_period_tag, 'M', p_return_month, 12)
		   AND return_year = DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
			AND period_tag = DECODE (p_period_tag, 'M', NVL (period_tag, 'M'), 'Y')
         AND user_id = p_user_id;
        
      SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
        INTO v_ret_mm
        FROM DUAL;

      SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
        INTO v_ret_yr
        FROM DUAL;
        
      v_atc_code := 'WC160';
      v_tax_rate := 2;
        
      FOR rec IN (SELECT SUM(NVL(wtax_amt, 0)) wtax_amt, payor, tin
                    FROM (SELECT SUM(NVL(amount, 0)) wtax_amt, c.payor, c.tin
                            FROM giac_collection_dtl a, giac_acctrans b, giac_order_of_payts c
                           WHERE 1 = 1
                             AND a.gacc_tran_id = b.tran_id
                             AND a.gacc_tran_id = c.gacc_tran_id
                             AND b.tran_flag <> 'D'
                             AND a.pay_mode = 'CW'
                             AND DECODE (p_period_tag, 'M', TO_CHAR (b.posting_date, 'MM'), 'A') =
                                 DECODE (p_period_tag, 'M', LTRIM(TO_CHAR(p_return_month,'00')), 'A')
                             AND TO_NUMBER(TO_CHAR (b.posting_date, 'RRRR')) = 
                                 DECODE (p_period_tag,'M', p_return_myear, TO_NUMBER(p_return_yyear))
                           GROUP BY c.payor, c.tin
                        UNION ALL
                           SELECT -SUM(NVL(amount, 0)) wtax_amt, c.payor, c.tin
                             FROM giac_reversals a,
                                  giac_acctrans b,
                                  giac_order_of_payts c,
                                  giac_collection_dtl d
                            WHERE a.reversing_tran_id = b.tran_id
                              AND a.gacc_tran_id = c.gacc_tran_id
                              AND a.gacc_tran_id = d.gacc_tran_id
                              AND b.tran_flag <> 'D'
                              AND d.pay_mode = 'CW'
                              AND c.or_flag = 'C'
                              AND DECODE (p_period_tag, 'M', TO_CHAR (b.posting_date, 'MM'), 'A') =
                                  DECODE (p_period_tag, 'M', LTRIM(TO_CHAR(p_return_month,'00')), 'A')
                              AND TO_NUMBER(TO_CHAR (b.posting_date, 'RRRR')) = 
                                  DECODE (p_period_tag,'M', p_return_myear, TO_NUMBER(p_return_yyear))
                            GROUP BY c.payor, c.tin)
                   GROUP BY payor, tin
                   ORDER BY payor ASC)
      LOOP      
         FOR i IN (SELECT payee_last_name, payee_first_name, payee_middle_name, tin
                     FROM giis_payees
                    WHERE payee_last_name || ' ' || payee_first_name || ' ' || payee_middle_name = rec.payor
                       OR payee_last_name = rec.payor
                      AND payee_class_cd NOT IN (giacp.v ('ASSD_CLASS_CD'), giacp.v ('INTM_CLASS_CD'), giacp.v ('RI_CLASS_CD')))
         LOOP
            v_exists := 1;
            v_rec_tin := i.tin;
            IF i.payee_first_name IS NOT NULL THEN
               v_last_name := i.payee_last_name;
               v_first_name := i.payee_first_name;
               v_middle_name := i.payee_middle_name;
            ELSE
               v_corporate_name := i.payee_last_name;
            END IF;
         END LOOP;
            
         IF v_exists = 0 THEN
            FOR i IN (SELECT assd_name, last_name, first_name, middle_initial middle_name, assd_tin, corporate_tag
                        FROM giis_assured
                       WHERE assd_name = rec.payor
                       ORDER BY LENGTH(NVL(assd_tin, 'X')) DESC)
            LOOP
               v_exists := 1;
               v_rec_tin := i.assd_tin;
               IF i.corporate_tag IN ('C', 'J') THEN
                  v_corporate_name := i.assd_name;
               ELSE
                  v_last_name := i.last_name;
                  v_first_name := i.first_name;
                  v_middle_name := i.middle_name;
               END IF;
            END LOOP;
         END IF;
            
         IF v_exists = 0 THEN
            FOR i IN (SELECT intm_name, tin
                        FROM giis_intermediary
                       WHERE intm_name = rec.payor)
            LOOP
               v_exists := 1;
               v_rec_tin := i.tin;
               v_corporate_name := i.intm_name;
            END LOOP;
         END IF;
            
         IF v_exists = 0 THEN
            FOR i IN (SELECT ri_name, ri_tin
                        FROM giis_reinsurer
                       WHERE ri_name = rec.payor)
            LOOP
               v_exists := 1;
               v_rec_tin := i.ri_tin;
               v_corporate_name := i.ri_name;
            END LOOP;
         END IF;
            
         IF v_exists = 0 THEN
            v_rec_tin := rec.tin;
            v_corporate_name := rec.payor;
         END IF;
            
         BEGIN
            v_tin := TO_NUMBER (REPLACE (REPLACE (v_rec_tin, '-', ''), ' '));

            IF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 5 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 6 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 7 THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 8 THEN
               v_tin := NULL;
            ELSE
               IF v_tin = 0 THEN
                  v_tin := NULL;
               ELSIF LENGTH (v_rec_tin) = 15 AND LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 12 THEN
                  v_tin := REPLACE (v_rec_tin, ' ', '-');
               ELSIF     LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 12 AND LENGTH (v_rec_tin) = 12 THEN
                  v_tin :=
                      SUBSTR (v_rec_tin, 1, 3)
                   || '-'
                   || SUBSTR (v_rec_tin, 4, 3)
                   || '-'
                   || SUBSTR (v_rec_tin, 7, 3)
                   || '-'
                   || SUBSTR (v_rec_tin, 10, 3);
               ELSIF LENGTH (v_rec_tin) = 11 AND LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 9 THEN
                  v_tin := REPLACE (v_rec_tin, ' ', '-') || '-000';
               ELSIF LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 9 AND LENGTH (v_rec_tin) = 9 THEN
                  v_tin :=
                      SUBSTR (v_rec_tin, 1, 3)
                   || '-'
                   || SUBSTR (v_rec_tin, 4, 3)
                   || '-'
                   || SUBSTR (v_rec_tin, 7, 3)
                   || '-000';
               ELSE
                  v_tin := NULL;
               END IF;
            END IF;
         EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
               v_tin := NULL;
         END;
         
         v_base_amount := rec.wtax_amt / (v_tax_rate/100);
         v_seq_no := v_seq_no + 1;
              
         INSERT INTO giac_sawt_ext
                     (return_month, return_year, seq_no, corporate_name,
                      last_name, first_name, middle_name, tin,
                      atc_code, tax_rate, base_amount, creditable_amt,
                      user_id, last_update, period_tag
                     )
              VALUES (v_ret_mm, v_ret_yr, v_seq_no, UPPER(v_corporate_name),
                      UPPER(v_last_name), UPPER(v_first_name), UPPER(v_middle_name), v_tin,
                      v_atc_code, v_tax_rate, v_base_amount, rec.wtax_amt,
                      USER, SYSDATE, p_period_tag
                     );
                     
         v_corporate_name := NULL;
         v_last_name := NULL;
         v_first_name := NULL;
         v_middle_name := NULL;
         v_tin := NULL;
         v_exists := 0;
      END LOOP;
   END;
   
   FUNCTION get_giacs115_csv_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_csv_tab PIPELINED AS
      res                  giacs115_csv_type;
   BEGIN
      IF p_report_id = '1601E' THEN
         FOR i IN (SELECT payee_name, tin, atc_code, tax_rate, tax_base, wholding_tax_amt  
                     FROM (SELECT DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name) payee_name,
                                  seq_no, tin, atc_code, tax_rate, SUM(tax_base) tax_base, SUM(wholding_tax_amt) wholding_tax_amt 
                             FROM giac_map_expanded_ext
                            WHERE return_month = p_month
                              AND return_year = p_myear
                              AND user_id = p_user_id
                            GROUP BY DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name),
                                  seq_no, tin, atc_code, tax_rate
                            ORDER BY seq_no) 
                        UNION ALL
                           SELECT NULL, NULL, NULL, NULL, SUM (tax_base), SUM (wholding_tax_amt)
                             FROM giac_map_expanded_ext
                            WHERE return_month = p_month
                              AND return_year = p_myear
                              AND user_id = p_user_id)
         LOOP
            res.payee_name := NVL(i.payee_name, '');
            res.tin := i.tin;
            res.atc_code := i.atc_code;
            res.tax_rate := i.tax_rate;
            res.tax_base := i.tax_base;
            res.wholding_tax_amt := i.wholding_tax_amt;
            
            PIPE ROW(res);
         END LOOP;
      ELSIF p_report_id = '1604E' THEN
         FOR i IN (SELECT payee_name, tin, atc_code, tax_rate, tax_base, wholding_tax_amt
						   FROM (SELECT DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name) payee_name,
								          seq_no, tin, atc_code, tax_rate, SUM(tax_base) tax_base, SUM(wholding_tax_amt) wholding_tax_amt
								     FROM giac_map_expanded_ext
								    WHERE return_month = 12
                              AND return_year = p_yyear
                              AND period_tag = 'Y'
                              AND user_id = p_user_id
                            GROUP BY DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name),
                                  seq_no, tin, atc_code, tax_rate
                            ORDER BY seq_no)
                         UNION ALL
                           SELECT NULL, NULL, NULL, NULL, SUM (tax_base), SUM (wholding_tax_amt)
                             FROM giac_map_expanded_ext
                            WHERE return_month = 12
                              AND return_year = p_yyear
                              AND period_tag = 'Y'
                              AND user_id = p_user_id)
         LOOP
            res.payee_name := NVL(i.payee_name, '');
            res.tin := i.tin;
            res.atc_code := i.atc_code;
            res.tax_rate := i.tax_rate;
            res.tax_base := i.tax_base;
            res.wholding_tax_amt := i.wholding_tax_amt;
            
            PIPE ROW(res);
         END LOOP;
      END IF;
   END;   
   
   FUNCTION get_giacs115_sawt_csv_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_sawt_csv_tab PIPELINED AS    
      res                  giacs115_sawt_csv_type;
   BEGIN
      FOR i IN (SELECT payee_name, tin, atc_code, tax_rate, base_amount, creditable_amt
                  FROM (SELECT DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name) payee_name,
                               seq_no, tin, atc_code, tax_rate, SUM(base_amount) base_amount, SUM(creditable_amt) creditable_amt
                          FROM giac_sawt_ext
                         WHERE return_month = p_month
                           AND return_year = p_myear
                           AND user_id = p_user_id
                         GROUP BY DECODE(corporate_name, NULL, last_name||', '||first_name||' '||middle_name, corporate_name),
                               seq_no, tin, atc_code, tax_rate
                         ORDER BY seq_no)
                     UNION ALL
                        SELECT NULL, NULL, NULL, NULL, SUM (base_amount), SUM (creditable_amt)
                          FROM giac_sawt_ext
                         WHERE return_month = p_month
                           AND return_year = p_myear
                           AND user_id = p_user_id)
      LOOP
         res.payee_name := NVL(i.payee_name, '');
         res.tin := i.tin;
         res.atc_code := i.atc_code;
         res.tax_rate := i.tax_rate;
         res.base_amount := i.base_amount;
         res.creditable_amt := i.creditable_amt;
            
         PIPE ROW(res);
      END LOOP;
   END;
   
   FUNCTION get_giacs115_dat_map_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED AS
      res                  giacs115_dat_type;
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_corporate_name	   giac_map_expanded_ext.corporate_name%TYPE;
	   v_last_name				giac_map_expanded_ext.last_name%TYPE;
	   v_first_name			giac_map_expanded_ext.first_name%TYPE;
	   v_middle_name			giac_map_expanded_ext.middle_name%TYPE;
      v_text					VARCHAR2(30000);
   BEGIN
      FOR i IN (SELECT 'DMAP'||','||'D'||p_report_id||','||seq_no||','||
                       SUBSTR(REPLACE(tin, '-'), 1, 9)||','||DECODE(tin, NULL, '0000','0'||SUBSTR(REPLACE(tin, '-'), 10, 3))||',' text1,
                       corporate_name, last_name, first_name, middle_name,
                       TO_CHAR(return_month, 'FM09')||'/'||return_year||','||
                       atc_code||',,'||TO_CHAR(tax_rate, 'FM99999.00')||','||
                       TO_CHAR(tax_base, 'FM999999999999.00')||','||TO_CHAR(wholding_tax_amt, 'FM999999999999.00') text2
					   FROM giac_map_expanded_ext
					  WHERE return_month = p_month
					    AND return_year = p_myear
					    AND user_id = p_user_id
                 ORDER BY seq_no)
      LOOP
         v_text := NULL;
			v_corporate_name := i.corporate_name;
			v_last_name := i.last_name;
			v_first_name := i.first_name;
			v_middle_name := i.middle_name;
         
         FOR i IN 1..LENGTH (Giacp.v ('SPECIAL_ARRAY'))
			LOOP
				v_corporate_name := REPLACE(v_corporate_name, SUBSTR (v_special_char, i, 1));
				v_last_name := REPLACE(v_last_name, SUBSTR (v_special_char, i, 1));
				v_first_name := REPLACE(v_first_name, SUBSTR (v_special_char, i, 1));
				v_middle_name := REPLACE(v_middle_name, SUBSTR (v_special_char, i, 1));
			END LOOP;
			
         v_text := i.text1;
			IF v_corporate_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_corporate_name, 1, 50)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_last_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_last_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_first_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_first_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_middle_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_middle_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
         
         res.dat_rows := v_text||i.text2;
         PIPE ROW(res);
      END LOOP;
   END;
   
   PROCEDURE get_giacs115_dat_map_details(
      p_report_id          IN giis_reports.report_id%TYPE,
      p_month              IN giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   ) AS
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_fund_desc          giis_funds.fund_desc%TYPE;
      v_rdo_cd					VARCHAR2(3) := giacp.v('BIR_RDO_CODE');
      v_branch_code        VARCHAR2(4) := giacp.v('BIR_BRANCH_CODE');
	   v_tin						VARCHAR2(20) := giacp.v('COMPANY_TIN');
      v_tax_base			   NUMBER(14,2);
	   v_wheld_amt			   NUMBER(14,2);
   BEGIN      
      SELECT fund_desc
	     INTO v_fund_desc
	     FROM giis_funds
	    WHERE fund_cd = giacp.v('FUND_CD');
   
      v_tin := SUBSTR(REPLACE(v_tin, '-'), 1, 9);
	   v_branch_code := '0'||SUBSTR(REPLACE(v_branch_code, '-'), 1, 3);
      
      FOR i IN 1..LENGTH (Giacp.v ('SPECIAL_ARRAY'))
	   LOOP
	 	   v_fund_desc := REPLACE(v_fund_desc, SUBSTR (v_special_char, i, 1));
	   END LOOP;
      
      p_file_name := v_tin||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')||LTRIM(TO_CHAR(TO_NUMBER(p_month),'00'))
	 					   ||p_myear||p_report_id||'.dat';
                        
      p_header := 'HMAP'||','||'H'||p_report_id||','||v_tin||','||v_branch_code||
                  ','||'"'||v_fund_desc||'"'||','||TO_CHAR(TO_NUMBER(p_month),'00')||
                  '/'||p_myear||','||v_rdo_cd;
                  
      SELECT SUM (tax_base), SUM (wholding_tax_amt)
		  INTO v_tax_base, v_wheld_amt
		  FROM giac_map_expanded_ext
		 WHERE return_month = p_month
		   AND return_year = p_myear
		   AND user_id = p_user_id;   
		   
		p_footer := 'CMAP'||','||'C'||p_report_id||','||v_tin||','||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')||','||
						LTRIM(TO_CHAR(TO_NUMBER(p_month),'00'))||'/'||p_myear||','||v_tax_base||','||v_wheld_amt;
   END;
   
   FUNCTION get_giacs115_dat_map_ann_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED AS
      res                  giacs115_dat_type;
      v_text					VARCHAR2(30000);
      v_corporate_name	   giac_map_expanded_ext.corporate_name%TYPE;
	   v_last_name				giac_map_expanded_ext.last_name%TYPE;
	   v_first_name			giac_map_expanded_ext.first_name%TYPE;
	   v_middle_name			giac_map_expanded_ext.middle_name%TYPE;
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_tin						VARCHAR2(20) := giacp.v('COMPANY_TIN');
      v_branch_code        VARCHAR2(4) := giacp.v('BIR_BRANCH_CODE');
      v_eoyear					VARCHAR2(10);
   BEGIN
      v_tin := SUBSTR(REPLACE(v_tin, '-'), 1, 9);
	   v_branch_code := '0'||SUBSTR(REPLACE(v_branch_code, '-'), 1, 3);
	   v_eoyear := TO_CHAR(LAST_DAY(TO_DATE(12||'-'||p_yyear, 'MM-YYYY')),'MM/DD/YYYY');
   
      FOR rec IN (SELECT 'D4'||','||p_report_id||','||v_tin||','||v_branch_code||','||v_eoyear||
	  							 ','||seq_no||','||SUBSTR(REPLACE(tin, '-'), 1, 9)||','||DECODE(tin, NULL, '0000','0'||SUBSTR(REPLACE(tin, '-'), 10, 3))||',' text1,
								 corporate_name, last_name, first_name, middle_name,
								 atc_code||','||TO_CHAR(tax_base, 'FM999999999999.00')||','||
								 TO_CHAR(tax_rate, 'FM99999.00')||','||TO_CHAR(wholding_tax_amt, 'FM999999999999.00') text2
						  FROM giac_map_expanded_ext
						 WHERE return_month = 12
						   AND return_year = p_yyear
						   AND period_tag = p_bir_freq_tag_query
						   AND user_id = p_user_id
						 ORDER BY seq_no)
		LOOP
			v_text := NULL;
			v_corporate_name := rec.corporate_name;
			v_last_name := rec.last_name;
			v_first_name := rec.first_name;
			v_middle_name := rec.middle_name;
			
			FOR i IN 1..LENGTH (Giacp.v ('SPECIAL_ARRAY'))
			LOOP
				v_corporate_name := REPLACE(v_corporate_name, SUBSTR (v_special_char, i, 1));
				v_last_name := REPLACE(v_last_name, SUBSTR (v_special_char, i, 1));
				v_first_name := REPLACE(v_first_name, SUBSTR (v_special_char, i, 1));
				v_middle_name := REPLACE(v_middle_name, SUBSTR (v_special_char, i, 1));
			END LOOP;
         
			v_text := rec.text1;
			IF v_corporate_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_corporate_name, 1, 50)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_last_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_last_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_first_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_first_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_middle_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_middle_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			
			res.dat_rows := v_text||rec.text2;
         
         PIPE ROW(res);
		END LOOP;
   END;
   
   PROCEDURE get_giacs115_dat_map_ann_dtls(
      p_report_id          IN giis_reports.report_id%TYPE,
      p_yyear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_bir_freq_tag_query IN giac_map_expanded_ext.period_tag%TYPE,
      p_amended_rtn        IN VARCHAR2,
      p_no_of_sheets       IN NUMBER,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   ) AS
      v_rdo_cd					VARCHAR2(3) := giacp.v('BIR_RDO_CODE');
      v_tin						VARCHAR2(20) := giacp.v('COMPANY_TIN');
      v_branch_code        VARCHAR2(4) := giacp.v('BIR_BRANCH_CODE');
      v_eoyear					VARCHAR2(10);
      v_fund_desc				VARCHAR2(1000);
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_wheld_amt			   NUMBER(14,2);
   BEGIN
      SELECT fund_desc
	     INTO v_fund_desc
	     FROM giis_funds
	    WHERE fund_cd = giacp.v('FUND_CD');
		  
	   v_tin := SUBSTR(REPLACE(v_tin, '-'), 1, 9);
	   v_branch_code := '0'||SUBSTR(REPLACE(v_branch_code, '-'), 1, 3);
	   v_eoyear := TO_CHAR(LAST_DAY(TO_DATE(12||'-'||p_yyear, 'MM-YYYY')),'MM/DD/YYYY');
		  
	   FOR i IN 1..LENGTH (giacp.v ('SPECIAL_ARRAY'))
	   LOOP
	 	   v_fund_desc := REPLACE(v_fund_desc, SUBSTR (v_special_char, i, 1));
	   END LOOP;
      
      p_file_name := v_tin||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')
	 						||TO_CHAR(LAST_DAY(TO_DATE(12||'-'||p_yyear, 'MM-YYYY')),'MMDDYYYY')
	 					   ||p_report_id||'.dat';
                     
      p_header := 'H'||p_report_id||','||v_tin||','||v_branch_code||
                  ','||v_eoyear||','||p_amended_rtn||','||p_no_of_sheets||','||v_rdo_cd;
                  
      SELECT SUM (wholding_tax_amt)
		  INTO v_wheld_amt
		  FROM giac_map_expanded_ext
		 WHERE return_month = 12
		   AND return_year = p_yyear
		   AND period_tag = p_bir_freq_tag_query
		   AND user_id = p_user_id;
         
      p_footer := 'C4'||','||p_report_id||','||v_tin||','||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')||','||v_eoyear||','||v_wheld_amt;
   END;
   
   FUNCTION get_giacs115_dat_sawt_list(
      p_sawt_form          VARCHAR2,
      p_month              giac_sawt_ext.return_month%TYPE,
      p_myear              giac_sawt_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED AS
      res                  giacs115_dat_type;
      v_text					VARCHAR2(30000);
      v_corporate_name	   giac_map_expanded_ext.corporate_name%TYPE;
	   v_last_name				giac_map_expanded_ext.last_name%TYPE;
	   v_first_name			giac_map_expanded_ext.first_name%TYPE;
	   v_middle_name			giac_map_expanded_ext.middle_name%TYPE;
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_tin						VARCHAR2(20) := giacp.v('COMPANY_TIN');
      v_branch_code        VARCHAR2(4) := giacp.v('BIR_BRANCH_CODE');
   BEGIN
      FOR rec IN (SELECT 'DSAWT'||','||'D'||p_sawt_form||','||seq_no||','||
                         SUBSTR(REPLACE(tin, '-'), 1, 9)||','||DECODE(tin, NULL, '0000','0'||SUBSTR(REPLACE(tin, '-'), 10, 3))||',' text1,
                         corporate_name, last_name, first_name, middle_name,
                         TO_CHAR(return_month, 'FM09')||'/'||return_year||',,'||
                         atc_code||','||TO_CHAR(tax_rate, 'FM99999.00')||','||
                         TO_CHAR(base_amount, 'FM999999999999.00')||','||TO_CHAR(creditable_amt, 'FM999999999999.00') text2
                    FROM giac_sawt_ext
                   WHERE return_month = p_month
                     AND return_year = p_myear
                     AND user_id = p_user_id
                   ORDER BY seq_no)
      LOOP
			v_text := NULL;
			v_corporate_name := rec.corporate_name;
			v_last_name := rec.last_name;
			v_first_name := rec.first_name;
			v_middle_name := rec.middle_name;
			
			FOR i IN 1..LENGTH (Giacp.v ('SPECIAL_ARRAY'))
			LOOP
				v_corporate_name := REPLACE(v_corporate_name, SUBSTR (v_special_char, i, 1));
				v_last_name := REPLACE(v_last_name, SUBSTR (v_special_char, i, 1));
				v_first_name := REPLACE(v_first_name, SUBSTR (v_special_char, i, 1));
				v_middle_name := REPLACE(v_middle_name, SUBSTR (v_special_char, i, 1));
			END LOOP;
			v_text := rec.text1;
			IF v_corporate_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_corporate_name, 1, 50)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_last_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_last_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_first_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_first_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			IF v_middle_name IS NOT NULL THEN
				v_text := v_text||'"'||SUBSTR(v_middle_name, 1, 30)||'",';
			ELSE
				v_text := v_text||',';
			END IF;
			
			res.dat_rows := v_text||rec.text2;
         
         PIPE ROW(res);
		END LOOP;
   END;
   
   PROCEDURE get_giacs115_dat_sawt_details(
      p_sawt_form          IN VARCHAR2,
      p_month              IN giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   ) AS
      v_special_char       giis_parameters.param_value_v%TYPE:= giacp.v ('SPECIAL_ARRAY');
      v_fund_desc          giis_funds.fund_desc%TYPE;
      v_rdo_cd					VARCHAR2(3) := giacp.v('BIR_RDO_CODE');
      v_branch_code        VARCHAR2(4) := giacp.v('BIR_BRANCH_CODE');
	   v_tin						VARCHAR2(20) := giacp.v('COMPANY_TIN');
      v_tax_base			   NUMBER(14,2);
	   v_wheld_amt			   NUMBER(14,2);
   BEGIN
      SELECT fund_desc
	     INTO v_fund_desc
	     FROM giis_funds
	    WHERE fund_cd = giacp.v('FUND_CD');

	   v_tin := SUBSTR(REPLACE(v_tin, '-'), 1, 9);
	   v_branch_code := '0'||SUBSTR(REPLACE(v_branch_code, '-'), 1, 3);  

	   FOR i IN 1..LENGTH (Giacp.v ('SPECIAL_ARRAY'))
	   LOOP
	 	   v_fund_desc := REPLACE(v_fund_desc, SUBSTR (v_special_char, i, 1));
	   END LOOP;
      
      p_file_name := v_tin||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')||LTRIM(TO_CHAR(TO_NUMBER(p_month),'00'))
	 						||p_myear||p_sawt_form||'.dat';
                     
      p_header := 'HSAWT'||','||'H'||p_sawt_form||','||v_tin||','||v_branch_code||
 	 				   ','||'"'||v_fund_desc||'"'||',"","","",'||TO_CHAR(TO_NUMBER(p_month),'00')||
 	 					'/'||p_myear||','||v_rdo_cd;
                  
      SELECT SUM (base_amount), SUM (creditable_amt)
		  INTO v_tax_base, v_wheld_amt
		  FROM giac_sawt_ext
		 WHERE return_month = p_month
		   AND return_year = p_myear
		   AND user_id = p_user_id;
		   
		p_footer := 'CSAWT'||','||'C'||p_sawt_form||','||v_tin||','||TO_CHAR(TO_NUMBER(v_branch_code), 'FM0999')||','||
						LTRIM(TO_CHAR(TO_NUMBER(p_month),'00'))||'/'||p_myear||','||v_tax_base||','||v_wheld_amt;				 
   END;
   
   PROCEDURE sls_vat (
      p_return_month   giac_relief_sls_ext.return_month%TYPE,
      p_return_myear   giac_relief_sls_ext.return_year%TYPE,
      p_return_yyear   giac_relief_sls_ext.return_year%TYPE,
      p_period_tag     giac_relief_sls_ext.period_tag%TYPE,
      p_user_id        giac_relief_sls_ext.user_id%TYPE
   )
   AS
      v_tin               giis_assured.assd_tin%TYPE;
      v_ret_mm            giac_map_expanded_ext.return_month%TYPE;
      v_ret_yr            giac_map_expanded_ext.return_year%TYPE;
      tran_month          VARCHAR2 (50);
      tin_listing_owner   VARCHAR2 (200)
                  := giac_bir_rlf_alp.get_valid_tin (giacp.v ('COMPANY_TIN'));
      v_mmrrrr            VARCHAR2 (7);
   BEGIN
      DELETE FROM giac_relief_sls_ext
            WHERE return_month =
                               DECODE (p_period_tag,
                                       'M', p_return_month,
                                       12
                                      )
              AND return_year =
                     DECODE (p_period_tag,
                             'M', p_return_myear,
                             p_return_yyear
                            )
              AND period_tag =
                        DECODE (p_period_tag,
                                'M', NVL (period_tag, 'M'),
                                'Y'
                               )
              AND user_id = p_user_id;

      SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
        INTO v_ret_mm
        FROM DUAL;

      SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
        INTO v_ret_yr
        FROM DUAL;

      v_mmrrrr := v_ret_mm || '-' || v_ret_yr;
      tran_month :=
              TO_CHAR (LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR')), 'MM/DD/RRRR');

      FOR rec IN
         (SELECT   iss_source, first_name, last_name, middle_initial, corporate_name,
                   address1, address2, payor_tin, SUM (tax_amt) tax_amt,
                   SUM (exempt_sales) exempt_sales,
                   SUM (zero_rated_sales) zero_rated_sales,
                   SUM (taxable_sales) taxable_sales
              FROM (SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ) first_name,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ) last_name,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ) middle_initial,
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ) corporate_name,
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2
                                   ) address1,
                             UPPER (b.mail_addr3) address2,
                             b.assd_tin payor_tin,
                             SUM (NVL (f.tax_amt, 0)) tax_amt,
                             SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             SUM (NVL (h.prem_zero_rated, 0))
                                                             zero_rated_sales,
                             
                             --SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             SUM
                                (DECODE (f.tax_amt,
                                         0, 0,
                                         DECODE (h.prem_vatable,
                                                 0, (f.tax_amt / .12),
                                                 NVL (h.prem_vatable, 0)
                                                )
                                        )
                                ) taxable_sales             --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115', p_user_id
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND NOT EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND (   TRUNC (o.posting_date) IS NOT NULL
                                        OR TRUNC (o.posting_date) <=
                                              LAST_DAY (TO_DATE (v_mmrrrr,
                                                                 'MM-RRRR'
                                                                )
                                                       )
                                       ))
                         AND NOT EXISTS (
                                SELECT p.gacc_tran_id
                                  FROM giac_advanced_payt p
                                 WHERE p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   AND (   p.acct_ent_date IS NULL
                                        OR TRUNC (p.acct_ent_date) >=
                                              LAST_DAY
                                                     (TO_DATE (p_return_month,
                                                               'MM'
                                                              )
                                                     )
                                       ))
                         AND i.tran_class IN ('COL', 'DV', 'JV')
                         AND i.tran_flag != 'D'
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (i.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             'FM09'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             SUM (NVL (f.tax_amt, 0)) tax_amt,
                             SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             SUM (NVL (h.prem_zero_rated, 0))
                                                             zero_rated_sales,
                             
                             --SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             SUM
                                (DECODE (f.tax_amt,
                                         0, 0,
                                         DECODE (h.prem_vatable,
                                                 0, (f.tax_amt / .12),
                                                 NVL (h.prem_vatable, 0)
                                                )
                                        )
                                ) taxable_sales             --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giac_advanced_payt p,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND i.tran_id = p.gacc_tran_id
                         AND h.gacc_tran_id = p.gacc_tran_id
                         AND h.b140_iss_cd = p.iss_cd
                         AND h.b140_prem_seq_no = p.prem_seq_no
                         AND h.inst_no = p.inst_no
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115', p_user_id
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND NOT EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND (   TRUNC (o.posting_date) IS NOT NULL
                                        OR TRUNC (o.posting_date) <=
                                              LAST_DAY (TO_DATE (v_mmrrrr,
                                                                 'MM-RRRR'
                                                                )
                                                       )
                                       ))
                         AND p.acct_ent_date BETWEEN TO_DATE (v_mmrrrr,
                                                              'MM-RRRR'
                                                             )
                                                 AND LAST_DAY
                                                           (TO_DATE (v_mmrrrr,
                                                                     'MM-RRRR'
                                                                    )
                                                           )
                         --added by albert 03.08.2017 (PFIC SR 23879 - consider posting date during extraction) 
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (i.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             'FM09'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                         --end albert 03.08.2017  
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL                           --for direct reversals
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             -SUM (NVL (f.tax_amt, 0)),
                             -SUM (NVL (h.prem_vat_exempt, 0)),
                             -SUM (NVL (h.prem_zero_rated, 0)),
                             
                             ---SUM (NVL (h.prem_vatable, 0))
                             -SUM
                                 (DECODE (f.tax_amt,
                                          0, 0,
                                          DECODE (h.prem_vatable,
                                                  0, (f.tax_amt / .12),
                                                  NVL (h.prem_vatable, 0)
                                                 )
                                         )
                                 ) taxable_sales            --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115'
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND DECODE (p_period_tag,
                                               'M', TO_CHAR (o.posting_date,
                                                             'MM'
                                                            ),
                                               'Y'
                                              ) =
                                          DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               'FM09'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                   AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                           'RRRR'
                                                          )
                                                 ) =
                                          DECODE (p_period_tag,
                                                  'M', p_return_myear,
                                                  TO_NUMBER (p_return_yyear)
                                                 ))
                         AND NOT EXISTS (
                                SELECT p.gacc_tran_id
                                  FROM giac_advanced_payt p
                                 WHERE p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   AND (   p.acct_ent_date IS NULL
                                        OR TRUNC (p.acct_ent_date) >=
                                              LAST_DAY
                                                     (TO_DATE (p_return_month,
                                                               'MM'
                                                              )
                                                     )
                                       ))
                         AND i.tran_class IN ('COL', 'DV', 'JV')
                         AND i.tran_flag != 'D'
                         AND (   TRUNC (i.posting_date) IS NOT NULL
                              OR TRUNC (i.posting_date) <=
                                      LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                             )
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             -SUM (NVL (f.tax_amt, 0)) tax_amt,
                             -SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             -SUM (NVL (h.prem_zero_rated, 0)
                                  ) zero_rated_sales,
                             
                             ---SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             -SUM
                                 (DECODE (f.tax_amt,
                                          0, 0,
                                          DECODE (h.prem_vatable,
                                                  0, (f.tax_amt / .12),
                                                  NVL (h.prem_vatable, 0)
                                                 )
                                         )
                                 ) taxable_sales            --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giac_advanced_payt p,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND i.tran_id = p.gacc_tran_id
                         AND h.gacc_tran_id = p.gacc_tran_id
                         AND h.b140_iss_cd = p.iss_cd
                         AND h.b140_prem_seq_no = p.prem_seq_no
                         AND h.inst_no = p.inst_no
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115', p_user_id
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND DECODE (p_period_tag,
                                               'M', TO_CHAR (o.posting_date,
                                                             'MM'
                                                            ),
                                               'Y'
                                              ) =
                                          DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               'FM09'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                   AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                           'RRRR'
                                                          )
                                                 ) =
                                          DECODE (p_period_tag,
                                                  'M', p_return_myear,
                                                  TO_NUMBER (p_return_yyear)
                                                 ))
                         AND p.acct_ent_date <=
                                      LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no)
          GROUP BY iss_source, first_name,
                   last_name,
                   middle_initial,
                   corporate_name,
                   address1,
                   address2,
                   payor_tin
                            UNION ALL                                          --RI transactions
                            SELECT   iss_source, NULL, NULL, NULL, ri_name, address1, address2, ri_tin,
                                     SUM (tax_amt), SUM (exempt_sales), SUM (zero_rated_sales),
                                     SUM (taxable_sales) exempt_sales
                                FROM (SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name) ri_name,
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2
                                                     ) address1,
                                               UPPER (a.mail_address3) address2, a.ri_tin,
                                               SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115', p_user_id
                                                                           ) = 1
                                           AND NOT EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND (   TRUNC (o.posting_date) IS NOT NULL
                                                          OR TRUNC (o.posting_date) <=
                                                                LAST_DAY (TO_DATE (v_mmrrrr,
                                                                                   'MM-RRRR'
                                                                                  )
                                                                         )
                                                         ))
                                           AND NOT EXISTS (
                                                  SELECT p.gacc_tran_id
                                                    FROM giac_advanced_payt p
                                                   WHERE p.gacc_tran_id = h.gacc_tran_id
                                                     AND p.iss_cd = h.b140_iss_cd
                                                     AND p.prem_seq_no = h.b140_prem_seq_no
                                                     AND p.inst_no = h.inst_no
                                                     AND (   p.acct_ent_date IS NULL
                                                          OR TRUNC (p.acct_ent_date) >=
                                                                LAST_DAY
                                                                       (TO_DATE (p_return_month,
                                                                                 'MM'
                                                                                )
                                                                       )
                                                         ))
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                           AND DECODE (p_period_tag,
                                                       'M', TO_CHAR (i.posting_date, 'MM'),
                                                       'Y'
                                                      ) =
                                                  DECODE (p_period_tag,
                                                          'M', LTRIM (TO_CHAR (p_return_month,
                                                                               'FM09'
                                                                              )
                                                                     ),
                                                          'Y'
                                                         )
                                           AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                                  DECODE (p_period_tag,
                                                          'M', p_return_myear,
                                                          TO_NUMBER (p_return_yyear)
                                                         )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      UNION ALL
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giac_advanced_payt p,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = p.gacc_tran_id
                                           AND h.gacc_tran_id = p.gacc_tran_id
                                           AND h.b140_iss_cd = p.iss_cd
                                           AND h.b140_prem_seq_no = p.prem_seq_no
                                           AND h.inst_no = p.inst_no
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND i.tran_id = h.gacc_tran_id(+)
                                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115', p_user_id
                                                                           ) = 1
                                           AND NOT EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND (   TRUNC (o.posting_date) IS NOT NULL
                                                          OR TRUNC (o.posting_date) <=
                                                                LAST_DAY (TO_DATE (v_mmrrrr,
                                                                                   'MM-RRRR'
                                                                                  )
                                                                         )
                                                         ))
                                           AND p.acct_ent_date BETWEEN TO_DATE (v_mmrrrr,
                                                                                'MM-RRRR'
                                                                               )
                                                                   AND LAST_DAY
                                                                             (TO_DATE (v_mmrrrr,
                                                                                       'MM-RRRR'
                                                                                      )
                                                                             )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      UNION ALL                                   
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name) ri_name,
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2
                                                     ) address1,
                                               UPPER (a.mail_address3) address2, a.ri_tin,
                                               -SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               -SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115', p_user_id
                                                                           ) = 1
                                           AND EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND DECODE (p_period_tag,
                                                                 'M', TO_CHAR (o.posting_date,
                                                                               'MM'
                                                                              ),
                                                                 'Y'
                                                                ) =
                                                            DECODE
                                                               (p_period_tag,
                                                                'M', LTRIM
                                                                       (TO_CHAR (p_return_month,
                                                                                 'FM09'
                                                                                )
                                                                       ),
                                                                'Y'
                                                               )
                                                     AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                                             'RRRR'
                                                                            )
                                                                   ) =
                                                            DECODE (p_period_tag,
                                                                    'M', p_return_myear,
                                                                    TO_NUMBER (p_return_yyear)
                                                                   ))
                                           AND NOT EXISTS (
                                                  SELECT p.gacc_tran_id
                                                    FROM giac_advanced_payt p
                                                   WHERE p.gacc_tran_id = h.gacc_tran_id
                                                     AND p.iss_cd = h.b140_iss_cd
                                                     AND p.prem_seq_no = h.b140_prem_seq_no
                                                     AND p.inst_no = h.inst_no
                                                     AND (   p.acct_ent_date IS NULL
                                                          OR TRUNC (p.acct_ent_date) >=
                                                                LAST_DAY
                                                                       (TO_DATE (p_return_month,
                                                                                 'MM'
                                                                                )
                                                                       )
                                                         ))
                                           AND (   TRUNC (i.posting_date) IS NOT NULL
                                                OR TRUNC (i.posting_date) <=
                                                        LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                                               )
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      UNION ALL
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               -SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               -SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giac_advanced_payt p,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = p.gacc_tran_id
                                           AND h.gacc_tran_id = p.gacc_tran_id
                                           AND h.b140_iss_cd = p.iss_cd
                                           AND h.b140_prem_seq_no = p.prem_seq_no
                                           AND h.inst_no = p.inst_no
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND i.tran_id = h.gacc_tran_id(+)
                                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115', p_user_id
                                                                           ) = 1
                                           AND EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND DECODE (p_period_tag,
                                                                 'M', TO_CHAR (o.posting_date,
                                                                               'MM'
                                                                              ),
                                                                 'Y'
                                                                ) =
                                                            DECODE
                                                               (p_period_tag,
                                                                'M', LTRIM
                                                                       (TO_CHAR (p_return_month,
                                                                                 'FM09'
                                                                                )
                                                                       ),
                                                                'Y'
                                                               )
                                                     AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                                             'RRRR'
                                                                            )
                                                                   ) =
                                                            DECODE (p_period_tag,
                                                                    'M', p_return_myear,
                                                                    TO_NUMBER (p_return_yyear)
                                                                   ))
                                           AND TRUNC (p.acct_ent_date) <=
                                                        LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin)
                            GROUP BY iss_source, ri_name, address1, address2, ri_tin
         )
      LOOP
         v_tin := giac_bir_rlf_alp.get_valid_tin (rec.payor_tin);

         INSERT INTO giac_relief_sls_ext
                     (return_month, return_year, iss_source, cust_tin, registered_name,
                      last_name, first_name, middle_name,
                      address1, address2, exempt_sales,
                      zero_rated_sales, taxable_sales_net_vat, output_tax,
                      tin_owner_listing, taxable_month, user_id,
                      last_update, period_tag
                     )
              VALUES (v_ret_mm, v_ret_yr, rec.iss_source, v_tin, rec.corporate_name,
                      rec.last_name, rec.first_name, rec.middle_initial,
                      rec.address1, rec.address2, rec.exempt_sales,
                      rec.zero_rated_sales, rec.taxable_sales, rec.tax_amt,
                      tin_listing_owner, tran_month, p_user_id,
                      SYSDATE, p_period_tag
                     );
      END LOOP;
   END sls_vat;         
   --added by robert SR 5473 03.14.16
    FUNCTION generate_csv_rlf_sls (
       p_month     giac_relief_sls_ext.return_month%TYPE,
       p_myear     giac_relief_sls_ext.return_year%TYPE,
       p_user_id   giac_relief_sls_ext.user_id%TYPE
    )
       RETURN giacs115_rlf_sls_csv_tab PIPELINED
    AS
       res   giacs115_rlf_sls_csv_type;
    BEGIN
       FOR i IN (SELECT iss_source, payee_name, tin, address1, address2,
                        exempt_sales, zero_rated_sales, taxable_sales_net_vat,
                        output_tax
                   FROM (SELECT iss_source,
                                DECODE (registered_name,
                                        NULL, last_name
                                         || ', '
                                         || first_name
                                         || ' '
                                         || middle_name,
                                        registered_name
                                       ) payee_name,
                                cust_tin tin, address1, address2, exempt_sales,
                                zero_rated_sales, taxable_sales_net_vat,
                                output_tax
                           FROM giac_relief_sls_ext
                          WHERE return_month = p_month
                            AND return_year = p_myear
                            AND user_id = p_user_id)
                 UNION ALL
                 SELECT NULL, NULL, NULL, NULL, NULL, SUM (exempt_sales),
                        SUM (zero_rated_sales), SUM (taxable_sales_net_vat),
                        SUM (output_tax)
                   FROM giac_relief_sls_ext
                  WHERE return_month = p_month
                    AND return_year = p_myear
                    AND user_id = p_user_id)
       LOOP
          res.issuing_source := i.iss_source;
          res.payee_name := i.payee_name;
          res.tin := i.tin;
          res.first_address := i.address1;
          res.second_address := i.address2;
          res.tax_exempt := i.exempt_sales;
          res.zero_rated := i.zero_rated_sales;
          res.taxable := i.taxable_sales_net_vat;
          res.output_tax := i.output_tax;
          PIPE ROW (res);
       END LOOP;
    END;
    
    FUNCTION generate_dat_rlf_sls_list (
       p_month     giac_relief_sls_ext.return_month%TYPE,
       p_myear     giac_relief_sls_ext.return_year%TYPE,
       p_user_id   giac_relief_sls_ext.user_id%TYPE
    )
       RETURN giacs115_dat_tab PIPELINED
    AS
       res                       giacs115_dat_type;
       v_special_char            giis_parameters.param_value_v%TYPE := giacp.v ('SPECIAL_ARRAY');
       v_text                    VARCHAR2 (32767);
       v_text2                   VARCHAR2 (32767);
       v_corporate_name          VARCHAR (500);
       v_last_name               VARCHAR (500);
       v_first_name              VARCHAR (500);
       v_middle_name             VARCHAR (500);
       v_exempt_sales            NUMBER (30, 2);
       v_zero_rated_sales        NUMBER (30, 2);
       v_taxable_sales_net_vat   NUMBER (30, 2);
       v_output_tax              NUMBER (30, 2);
       v_addr1                   VARCHAR (500);
       v_addr2                   VARCHAR (500);
    BEGIN
       FOR i IN (SELECT    'D,S,"'
                        || SUBSTR (REPLACE (cust_tin, '-'), 1, 9)
                        || '",' text1,
                        registered_name, last_name, first_name, middle_name,
                        address1, address2, exempt_sales, zero_rated_sales,
                        taxable_sales_net_vat, output_tax,
                           SUBSTR (REPLACE (tin_owner_listing, '-'), 1, 9)
                        || ','
                        || taxable_month text3
                   FROM giac_relief_sls_ext
                  WHERE return_month = p_month
                    AND return_year = p_myear
                    AND user_id = p_user_id)
       LOOP
          v_text := NULL;
          v_text2 := NULL;
          v_corporate_name := i.registered_name;
          v_last_name := i.last_name;
          v_first_name := i.first_name;
          v_middle_name := i.middle_name;
          v_addr1 := i.address1;
          v_addr2 := i.address2;
          v_exempt_sales := i.exempt_sales;
          v_zero_rated_sales := i.zero_rated_sales;
          v_taxable_sales_net_vat := i.taxable_sales_net_vat;
          v_output_tax := i.output_tax;

          FOR i IN 1 .. LENGTH (giacp.v ('SPECIAL_ARRAY'))
          LOOP
             v_corporate_name :=
                        REPLACE (v_corporate_name, SUBSTR (v_special_char, i, 1));
             v_last_name := REPLACE (v_last_name, SUBSTR (v_special_char, i, 1));
             v_first_name :=
                            REPLACE (v_first_name, SUBSTR (v_special_char, i, 1));
             v_middle_name :=
                           REPLACE (v_middle_name, SUBSTR (v_special_char, i, 1));
             v_addr1 := REPLACE (v_addr1, SUBSTR (v_special_char, i, 1));
             v_addr2 := REPLACE (v_addr2, SUBSTR (v_special_char, i, 1));
          END LOOP;

          v_text := i.text1;

          IF v_corporate_name IS NOT NULL
          THEN
             v_text := v_text || '"' || SUBSTR (v_corporate_name, 1, 50) || '",';
          ELSE
             v_text := v_text || ',';
          END IF;

          IF v_last_name IS NOT NULL
          THEN
             v_text := v_text || '"' || SUBSTR (v_last_name, 1, 30) || '",';
          ELSE
             v_text := v_text || ',';
          END IF;

          IF v_first_name IS NOT NULL
          THEN
             v_text := v_text || '"' || SUBSTR (v_first_name, 1, 30) || '",';
          ELSE
             v_text := v_text || ',';
          END IF;

          IF v_middle_name IS NOT NULL
          THEN
             v_text := v_text || '"' || SUBSTR (v_middle_name, 1, 30) || '",';
          ELSE
             v_text := v_text || ',';
          END IF;

          IF v_addr1 IS NOT NULL
          THEN
             v_text2 := v_text2 || '"' || SUBSTR (v_addr1, 1, 4000) || '",';
          ELSE
             v_text2 := v_text2 || ',';
          END IF;

          IF v_addr2 IS NOT NULL
          THEN
             v_text2 := v_text2 || '"' || SUBSTR (v_addr2, 1, 4000) || '",';
          ELSE
             v_text2 := v_text2 || ',';
          END IF;

          IF v_exempt_sales = 0
          THEN
             v_text2 :=
                      v_text2 || TO_CHAR (v_exempt_sales, 'FM999999999999')
                      || ',';
          ELSE
             v_text2 :=
                   v_text2 || TO_CHAR (v_exempt_sales, 'FM999999999999.00')
                   || ',';
          END IF;

          IF v_zero_rated_sales = 0
          THEN
             v_text2 :=
                  v_text2 || TO_CHAR (v_zero_rated_sales, 'FM999999999999')
                  || ',';
          ELSE
             v_text2 :=
                v_text2 || TO_CHAR (v_zero_rated_sales, 'FM999999999999.00')
                || ',';
          END IF;

          IF v_taxable_sales_net_vat = 0
          THEN
             v_text2 :=
                   v_text2
                || TO_CHAR (v_taxable_sales_net_vat, 'FM999999999999')
                || ',';
          ELSE
             v_text2 :=
                   v_text2
                || TO_CHAR (v_taxable_sales_net_vat, 'FM999999999999.00')
                || ',';
          END IF;

          IF v_output_tax = 0
          THEN
             v_text2 := v_text2 || TO_CHAR (v_output_tax, 'FM999999999999')
                        || ',';
          ELSE
             v_text2 :=
                     v_text2 || TO_CHAR (v_output_tax, 'FM999999999999.00')
                     || ',';
          END IF;

          res.dat_rows := v_text || v_text2 || i.text3;
          PIPE ROW (res);
       END LOOP;
    END;
    
    PROCEDURE generate_dat_rlf_sls_details (
       p_month       IN       giac_relief_sls_ext.return_month%TYPE,
       p_myear       IN       giac_relief_sls_ext.return_year%TYPE,
       p_user_id     IN       giac_relief_sls_ext.user_id%TYPE,
       p_file_name   OUT      VARCHAR2,
       p_header      OUT      VARCHAR2,
       p_footer      OUT      VARCHAR2
    )
    AS
       v_fund_desc      giis_funds.fund_desc%TYPE;
       v_tin            VARCHAR2 (20)                  := giacp.v ('COMPANY_TIN');
       v_branch_code    VARCHAR2 (4)               := giacp.v ('BIR_BRANCH_CODE');
       addr1            VARCHAR (500);
       addr2            VARCHAR (500);
       vat_exempt       NUMBER (30, 2);
       zero_rated       NUMBER (30, 2);
       taxable_sales    NUMBER (30, 2);
       output_tax       NUMBER (30, 2);
       v_special_char   giis_parameters.param_value_v%TYPE
                                                     := giacp.v ('SPECIAL_ARRAY');
       v_rdo_cd         VARCHAR2 (3)                  := giacp.v ('BIR_RDO_CODE');
    BEGIN
       SELECT fund_desc
         INTO v_fund_desc
         FROM giis_funds
        WHERE fund_cd = giacp.v ('FUND_CD');

       v_tin := SUBSTR (REPLACE (v_tin, '-'), 1, 9);
       v_branch_code := '0' || SUBSTR (REPLACE (v_branch_code, '-'), 1, 3);

       SELECT SUBSTR (giacp.v ('COMPANY_ADDRESS'), 1, 500)
         INTO addr1
         FROM DUAL;

       SELECT SUBSTR (giacp.v ('COMPANY_ADDRESS'), 501, 500)
         INTO addr2
         FROM DUAL;

       FOR i IN 1 .. LENGTH (giacp.v ('SPECIAL_ARRAY'))
       LOOP
          v_fund_desc := REPLACE (v_fund_desc, SUBSTR (v_special_char, i, 1));
          addr1 := REPLACE (addr1, SUBSTR (v_special_char, i, 1));
          addr2 := REPLACE (addr2, SUBSTR (v_special_char, i, 1));
       END LOOP;

       SELECT SUM (exempt_sales), SUM (zero_rated_sales),
              SUM (taxable_sales_net_vat), SUM (output_tax)
         INTO vat_exempt, zero_rated,
              taxable_sales, output_tax
         FROM giac_relief_sls_ext
        WHERE return_month = p_month
          AND return_year = p_myear
          AND user_id = p_user_id;

       p_file_name :=
              v_tin
          || 'S'
          || LTRIM (TO_CHAR (TO_NUMBER (p_month), '00'))
          || p_myear
          || '.dat';
       p_header :=
             'H,S,"'
         || v_tin
         || '","'
         || v_fund_desc
         || '","","","","'
         || v_fund_desc
         || '","'
         || addr1
         || '","'
         || addr2
         || '",'
         || TO_CHAR(vat_exempt, 'FM999999999999.00')
         || ','
         || TO_CHAR(zero_rated, 'FM999999999999.00')
         || ','
         || TO_CHAR(taxable_sales, 'FM999999999999.00')
         || ','
         || TO_CHAR(output_tax, 'FM999999999999.00')
         || ','
         || v_rdo_cd
         || ','
         || TO_CHAR (LAST_DAY (TO_DATE (p_month, 'MM')),
                     'MM/DD'
                    )
         || '/'
         || p_myear;
         
         p_footer := NULL;
    END;
    --end of codes by robert SR 5473 03.14.16
END;
/



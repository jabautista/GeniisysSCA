CREATE OR REPLACE PACKAGE BODY CPI.giac_uploading_pkg
AS
   PROCEDURE upload_excel_type1 (
      p_check_date        IN       VARCHAR2,
      p_fcollection_amt   IN       VARCHAR2,
      p_policy_no         IN       VARCHAR2,
      p_bill_no           IN       VARCHAR2,
      p_payor             IN       VARCHAR2,
      p_bank              IN       VARCHAR2,
      p_pay_mode          IN       VARCHAR2,
      p_check_class       IN       VARCHAR2,
      p_check_no          IN       VARCHAR2,
      p_payment_date      IN       VARCHAR2,
      p_currency_cd       IN       VARCHAR2,
      p_convert_rate      IN       VARCHAR2,
      p_atm_tag           IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2,
      p_query             OUT      VARCHAR2
   )
   IS
      v_values      VARCHAR2 (32767);
      v_columns     VARCHAR2 (32767);
      v_fcoll_amt   giac_upload_prem_dtl.fcollection_amt%TYPE;
      v_line_cd     gipi_polbasic.line_cd%TYPE;
      v_subline_cd     gipi_polbasic.subline_cd%TYPE;
      v_iss_cd         gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pos1        NUMBER;
      v_pos2        NUMBER;
      v_pos3        NUMBER;
      v_pos4        NUMBER;
      v_pos5        NUMBER;
      v_pos6        NUMBER;
      v_payt_date   DATE;
      v_pay_mode                    giac_upload_prem_dtl.pay_mode%TYPE;
      v_bank              giac_upload_prem_dtl.bank%TYPE;
      v_check_class       giac_upload_prem_dtl.check_class%TYPE;
      v_check_no          giac_upload_prem_dtl.check_no%TYPE;
      v_check_date        giac_upload_prem_dtl.check_date%TYPE;
      v_dum_bill_no                PLS_INTEGER;
      v_bill_no                        giac_upload_prem_atm_dtl.bill_no%TYPE;
      v_item_no           NUMBER;
      v_coll_amt            giac_upload_prem_dtl.collection_amt%TYPE;
      v_conv_rt           giac_upload_prem_dtl.convert_rate%TYPE;
      v_stmnt                   VARCHAR2(32767);
      v_hash_bill   NUMBER;
      v_hash_collection NUMBER;
      
   BEGIN
   
      v_hash_bill := TO_NUMBER(p_hash_bill);
      v_hash_collection := TO_NUMBER(p_hash_collection);
      
   
      IF p_check_date IS NOT NULL THEN
         v_values := v_values || 'TO_DATE(''' || p_check_date || ''',''MM/DD/YYYY''),';
         v_columns := v_columns || 'CHECK_DATE,';
         
         --Deo [11.29.2016]: add start
         BEGIN
            v_check_date := TO_DATE (TRIM (p_check_date), 'MM/DD/YYYY');
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error
                        (-20001,
                            'Geniisys Exception#E#Error in converting file. '
                         || 'Check Date format should be MM/DD/YYYY.'
                        );
         END;
         --Deo [11.29.2016]: add ends
      END IF;

      IF p_fcollection_amt IS NOT NULL THEN
         IF TO_NUMBER(p_fcollection_amt) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Zero collection amount found in excel file.');
         ELSIF TO_NUMBER(p_fcollection_amt) < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Negative collection amount found in excel file.');
         END IF;   
         
         v_values := v_values || 'REPLACE(''' || p_fcollection_amt || ''','','',NULL),';
         v_columns := v_columns || 'FCOLLECTION_AMT,';
         v_fcoll_amt := TO_NUMBER(REPLACE(p_fcollection_amt,',',NULL));
         v_hash_collection := v_hash_collection + TO_NUMBER(REPLACE(p_fcollection_amt,',',NULL));
         
      ELSIF p_fcollection_amt IS NULL OR p_fcollection_amt = '' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null collection amount found in excel file.');
      END IF;
      
      
      IF p_atm_tag = 'Y' THEN
         v_pos2 := INSTR(p_bill_no,'-',1,2);
         
         IF v_pos2 <> 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. BILL_NO in excel file must be in the form of ACCT_ISS_CD-PREM_SEQ_NO.');
         ELSE
            v_pos1 := instr(p_bill_no,'-',1,1);
            IF v_pos1 = 0 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. BILL_NO in excel file must be in the form of ACCT_ISS_CD-PREM_SEQ_NO.');
            END IF;
            BEGIN
               v_dum_bill_no := TO_NUMBER(REPLACE(REPLACE(SUBSTR(p_bill_no,1,v_pos1-1),'.','x'),' ','x'));
               v_dum_bill_no := TO_NUMBER(REPLACE(REPLACE(SUBSTR(p_bill_no,v_pos1+1),'.','x'),' ','x'));
            EXCEPTION
               WHEN VALUE_ERROR THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Value of ACCT_ISS_CD or PREM_SEQ_NO of BILL_NO in excel file must be a numeric whole number.');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. BILL_NO in excel file must be in the form of ACCT_ISS_CD-PREM_SEQ_NO.');      
            END;
            
            v_columns := v_columns || 'BILL_NO,'; 
            v_values := v_values ||''''||p_bill_no||''',';
            v_bill_no := p_bill_no;
--            v_values := v_values ||''''||v_dum_bill_no||''',';
--            v_bill_no := v_dum_bill_no;
            v_hash_bill := v_hash_bill + TO_NUMBER(SUBSTR(p_bill_no,1,v_pos1-1))
                                       + TO_NUMBER(SUBSTR(p_bill_no,v_pos1+1)); 
         END IF;
      ELSE
         IF p_policy_no IS NOT NULL THEN
      
             v_columns := v_columns || 'LINE_CD,SUBLINE_CD,ISS_CD,ISSUE_YY,POL_SEQ_NO,RENEW_NO,';
             v_pos6 := INSTR(p_policy_no , '-', 1, 6);
             
             IF v_pos6 <> 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');
             ELSE
                v_pos1 := instr(p_policy_no,'-',1,1);
                v_pos2 := instr(p_policy_no,'-',1,2);
                v_pos3 := instr(p_policy_no,'-',1,3);
                v_pos4 := instr(p_policy_no,'-',1,4);
                v_pos5 := instr(p_policy_no,'-',1,5);
                
                IF v_pos1 = 0 OR v_pos2 = 0 OR v_pos3 = 0 OR v_pos4 = 0 OR v_pos5 = 0 THEN
                   RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');                
                END IF;    
                
                BEGIN
                   v_line_cd := SUBSTR(p_policy_no, 1, v_pos1-1);
                   v_subline_cd := SUBSTR(p_policy_no, v_pos1+1, v_pos2-v_pos1-1);
                   v_iss_cd := SUBSTR(p_policy_no, v_pos2+1, v_pos3-v_pos2-1);
                   v_issue_yy := TO_NUMBER(SUBSTR(p_policy_no, v_pos3+1, v_pos4-v_pos3-1));
                   v_pol_seq_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos4+1, v_pos5-v_pos4-1));
                   v_renew_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos5+1));
                   
                EXCEPTION WHEN OTHERS THEN   
                   RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');   
                END;
                
                GIAC_UPLOADING_PKG.chk_pol_no(v_line_cd,v_subline_cd,v_iss_cd,v_iss_cd);
                
                v_values := v_values ||''''||v_line_cd||''','
                                     ||''''||v_subline_cd||''',' 
                                     ||''''||v_iss_cd||''','
                                     ||v_issue_yy||','
                                     ||v_pol_seq_no||','
                                     ||v_renew_no||',';
                                     
                v_hash_bill := v_hash_bill + v_pol_seq_no;
             END IF;
          END IF;    
      END IF;
      
      IF p_payor IS NOT NULL THEN
         v_values := v_values||''''||REPLACE(UPPER(p_payor),'''','''''')||''',';
         v_columns := v_columns || 'PAYOR,';
      END IF;
          
      IF p_bank IS NOT NULL THEN
         v_values := v_values||''''||REPLACE(UPPER(p_bank),'''','''''')||''',';
         v_columns := v_columns || 'BANK,';
             
         IF this_bank_exist(p_bank) = 'No' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The bank '||p_bank||' is invalid. Please check the bank''s maintenance.');
         END IF;
                    
      END IF;
         
      IF p_pay_mode IS NOT NULL THEN
         v_values := v_values||''''||p_pay_mode||''',';
         v_columns := v_columns || 'PAY_MODE,';
      END IF;
         
      IF p_check_class IS NOT NULL THEN
         v_values := v_values||''''||p_check_class||''',';
         v_columns := v_columns || 'CHECK_CLASS,';
      END IF;
         
      IF p_check_no IS NOT NULL THEN
         v_values := v_values||''''||UPPER(p_check_no)||''',';
         v_columns := v_columns || 'CHECK_NO,';
      END IF;
         
      IF p_payment_date IS NOT NULL THEN
         BEGIN --Deo [11.29.2016]: added begin
             v_payt_date := TO_DATE(p_payment_date,'MM/DD/YYYY');
             v_values := v_values||'PAYMENT_DATE_COLUMN,';
             v_columns := v_columns || 'PAYMENT_DATE_COLUMN,';
         --Deo [11.29.2016]: add start
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error
                        (-20001,
                            'Geniisys Exception#E#Error in converting file. '
                         || 'Payment Date format should be MM/DD/YYYY.'
                        );
         END;
         --Deo [11.29.2016]: add ends
      ELSE
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. No value found for PAYMENT_DATE in excel file.');   
      END IF;
         
      IF p_currency_cd IS NOT NULL THEN
         v_values := v_values ||p_currency_cd ||',';
         v_columns := v_columns||'CURRENCY_CD,';    
      END IF;
         
      IF p_convert_rate IS NOT NULL THEN
         v_values := v_values ||p_convert_rate || ',';
         v_columns := v_columns || 'CONVERT_RATE,';
         v_conv_rt := TO_NUMBER(REPLACE(p_convert_rate,',',NULL));
      END IF;
         
      GIAC_UPLOADING_PKG.chk_pay_mode(p_pay_mode, p_bank, p_check_class, p_check_no, TO_DATE(p_check_date, 'MM-DD-YYYY'));
      
      IF p_atm_tag = 'Y' THEN
            BEGIN
                SELECT nvl(max(item_no),0) + 1
                  INTO v_item_no
                  FROM giac_upload_prem_atm_dtl
                 WHERE source_cd  = p_source_cd
                   AND file_no    = p_file_no
                   AND bill_no    = v_bill_no
                   AND payor      = p_payor;
            END;
        ELSE
            BEGIN
                SELECT nvl(max(item_no),0) + 1
                  INTO v_item_no
                  FROM giac_upload_prem_dtl
                 WHERE source_cd  = p_source_cd
                   AND file_no    = p_file_no
                   AND line_cd    = v_line_cd
                   AND subline_cd = v_subline_cd
                   AND iss_cd     = v_iss_cd
                   AND issue_yy   = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no
                   AND renew_no   = v_renew_no
                   AND payor      = p_payor;
            END;
      END IF;
        
        v_columns := REPLACE(v_columns,'PAYMENT_DATE_COLUMN,',NULL);
        v_values  := REPLACE(v_values,'PAYMENT_DATE_COLUMN,',NULL);
        
        IF INSTR(REPLACE(v_columns, 'FCOLLECTION_AMT', NULL),'COLLECTION_AMT,') = 0 THEN
           v_columns := v_columns||'COLLECTION_AMT,';
        END IF;
        
        v_coll_amt := NVL(v_fcoll_amt*v_conv_rt,0);
        v_values := 'VALUES('||v_values||v_coll_amt||','''||p_source_cd||''','||p_file_no||','||v_item_no||')';
       
        IF p_atm_tag = 'Y' THEN
            v_stmnt := 'INSERT INTO GIAC_UPLOAD_PREM_ATM_DTL('||v_columns||'SOURCE_CD,FILE_NO,ITEM_NO) '||v_values;
        ELSE
            v_stmnt := 'INSERT INTO GIAC_UPLOAD_PREM_DTL('||v_columns||'SOURCE_CD,FILE_NO,ITEM_NO) '||v_values;
        END IF;
        
        BEGIN
           EXEC_IMMEDIATE(v_stmnt);
        EXCEPTION
           WHEN dup_val_on_index THEN
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Duplicate Policy/Bill found in excel file.');
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Error occurred in INSERT. '|| TO_CHAR(SUBSTR(SQLERRM, 11, LENGTH(SQLERRM) - 10) || '.'));
        END;

        
      p_hash_bill := TO_CHAR(v_hash_bill);
      p_hash_collection := TO_CHAR(v_hash_collection);
      p_query := v_stmnt;
      
   END upload_excel_type1;
   
   PROCEDURE upload_excel_type1_b (
      p_or_tag              IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_atm_tag             IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_payt_date           IN   VARCHAR2
   )
   IS
      v_tran_flag giac_acctrans.tran_flag%TYPE;
      v_exist     VARCHAR2(1) := 'N';
--      v_hash_file                    VARCHAR2(20) := NULL;
   BEGIN
      --Deo [11.29.2016]: add start
      IF p_atm_tag = 'Y'
      THEN
         IF p_or_tag = 'G'
         THEN
            FOR i IN
               (SELECT COUNT (DISTINCT currency_cd) ctr,
                       COUNT (DISTINCT convert_rate) cnt_rt
                  FROM giac_upload_prem_atm_dtl
                 WHERE source_cd = p_source_cd AND file_no = p_file_no)
            LOOP
               IF i.ctr > 1
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Error on converting file. Only one currency is allowed per OR.'
                     );
               END IF;

               IF i.cnt_rt > 1
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR.'
                     );
               END IF;
            END LOOP;
         ELSIF p_or_tag = 'I'
         THEN
            FOR i IN
               (SELECT   COUNT (DISTINCT currency_cd) ctr,
                         COUNT (DISTINCT convert_rate) cnt_rt,
                         payor, bill_no
                    FROM giac_upload_prem_atm_dtl
                   WHERE source_cd = p_source_cd AND file_no = p_file_no
                GROUP BY payor, bill_no)
            LOOP
               IF i.ctr > 1
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Error on converting file. Only one currency is allowed per OR,'
                      || CHR (10) || i.payor || ' - ' || i.bill_no || '.'
                     );
               END IF;

               IF i.cnt_rt > 1
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR,'
                      || CHR (10) || i.payor || ' - ' || i.bill_no || '.'
                     );
               END IF;
            END LOOP;
         END IF;
      ELSE
      --Deo [11.29.2016]: add ends
         IF p_or_tag = 'G' THEN
            FOR i IN (SELECT COUNT(DISTINCT CURRENCY_CD) ctr,
                             COUNT (DISTINCT convert_rate) cnt_rt --Deo [11.29.2016]
                        FROM giac_upload_prem_dtl
                       WHERE source_cd  = p_source_cd
                      AND file_no    = p_file_no)
            LOOP
               IF i.ctr > 1 THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error on converting file. Only one currency is allowed per OR.');
               END IF;
               
               IF i.cnt_rt > 1 --Deo [11.29.2016]
               THEN
                  raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR.');
               END IF;
            END LOOP;
         ELSIF p_or_tag = 'I' THEN
            FOR i IN (SELECT COUNT(DISTINCT CURRENCY_CD) ctr, payor, line_cd, subline_cd, iss_cd, 
                             issue_yy, pol_seq_no, renew_no, source_cd, file_no,
                             COUNT (DISTINCT convert_rate) cnt_rt --Deo [11.29.2016]
                        FROM giac_upload_prem_dtl
                       WHERE source_cd  = p_source_cd
                         AND file_no    = p_file_no
                    GROUP BY payor, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, source_cd, file_no)
            LOOP
               IF i.ctr > 1 THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error on converting file. Only one currency is allowed per OR,'||chr(10)||i.payor||' - '||i.line_cd||'-'||
                                            i.subline_cd||'-'||i.iss_cd||'-'||TO_CHAR(i.issue_yy,'fm09')||'-'||
                                            TO_CHAR(i.pol_seq_no,'fm0999999')||'-'||TO_CHAR(i.renew_no,'fm09')||'.');
               END IF;
               
               IF i.cnt_rt > 1 --Deo [11.29.2016]
               THEN
                  raise_application_error
                        (-20001,
                            'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR,'
                         || CHR (10) || i.payor || ' - ' || i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd
                         || '-' || TO_CHAR (i.issue_yy, 'fm09') || '-' || TO_CHAR (i.pol_seq_no, 'fm0999999')
                         || '-' || TO_CHAR (i.renew_no, 'fm09') || '.'
                        );            
               END IF;
            END LOOP;          
         END IF;
      END IF; --Deo [11.29.2016]
      
      IF p_atm_tag = 'Y' THEN
         INSERT INTO giac_upload_prem_atm (source_cd, file_no, bill_no, payor, collection_amt, iss_cd)
                (SELECT source_cd, file_no, to_number(replace(replace(substr(bill_no,instr(bill_no,'-',1,1)+1),'.','x'),' ','x')), payor, sum(collection_amt) collection_amt, 
                    get_branch_cd(TO_NUMBER(REPLACE(REPLACE(SUBSTR(bill_no,1,instr(bill_no,'-',1,1)-1),'.','x'),' ','x')))
                   FROM giac_upload_prem_atm_dtl 
                  WHERE source_cd = p_source_cd
                    AND file_no = p_file_no
                GROUP BY source_cd, file_no, bill_no, payor);
      ELSE
         INSERT INTO giac_upload_prem (source_cd, file_no, line_cd, subline_cd, iss_cd, 
                                       issue_yy, pol_seq_no, renew_no, payor, collection_amt, 
                                       fcollection_amt, currency_cd, convert_rate)
                (SELECT source_cd, file_no, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, 
                        payor, SUM(fcollection_amt*convert_rate) collection_amt,
                        SUM(fcollection_amt) fcollection_amt, currency_cd, convert_rate
                   FROM giac_upload_prem_dtl 
                  WHERE source_cd = p_source_cd
                    AND file_no = p_file_no
               GROUP BY source_cd, file_no, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, 
                   renew_no, payor, currency_cd, convert_rate);          
      END IF;
      
      FOR rec IN (SELECT file_name, tran_class, tran_id
                    FROM giac_upload_file a
                   WHERE hash_collection = p_hash_collection
                     AND hash_bill = p_hash_bill
                     AND no_of_records = p_records_converted
                     AND file_status <> 'C')
      LOOP
         
         IF rec.tran_class = 'JV' THEN
                SELECT tran_flag 
                  INTO v_tran_flag
                  FROM giac_acctrans
                 WHERE tran_id = rec.tran_id;
                IF v_tran_flag = 'P' THEN
                    SELECT 'Y'
                      INTO v_exist
                      FROM giac_reversals
                     WHERE gacc_tran_id = rec.tran_id;
                    IF v_exist = 'N' THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
                    END IF;     
                ELSIF v_tran_flag = 'D' THEN
                    NULL;
                ELSE    
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
                END IF;
        ELSE    
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
        END IF;
      
      END LOOP;
      
      BEGIN
         UPDATE giac_upload_file
              SET hash_collection = p_hash_collection,
                  hash_bill = p_hash_bill,
                  file_status = '1',
                  no_of_records = p_records_converted,
                  payment_date = TO_DATE(p_payt_date, 'mm-dd-yyyy')
          WHERE source_cd = p_source_cd
            AND file_no = p_file_no;
      END;
        
   END upload_excel_type1_b;
   
   PROCEDURE upload_excel_type2 (
      p_intm_no           IN   VARCHAR2,
      p_payor             IN   VARCHAR2,
      p_policy_no         IN   VARCHAR2,
      p_endt_no           IN   VARCHAR2,
      p_fgross_prem_amt   IN   VARCHAR2,
      p_fcomm_amt         IN   VARCHAR2,
      p_fwhtax_amt        IN   VARCHAR2,
      p_finput_vat_amt    IN   VARCHAR2,
      p_fnet_amt_due      IN   VARCHAR2,
      p_gross_tag         IN   VARCHAR2,
      p_currency_cd       IN   VARCHAR2,
      p_convert_rate      IN   VARCHAR2,
      p_source_cd         IN   VARCHAR2,
      p_file_no           IN   VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2,
      p_query             OUT  VARCHAR2
   )
   IS
      v_columns         VARCHAR2(32767);
      v_values          VARCHAR2(32767);
      v_intm_no         NUMBER;
      v_intm_exists     BOOLEAN := FALSE;
      v_line_cd         gipi_polbasic.line_cd%TYPE;
      v_subline_cd      gipi_polbasic.subline_cd%TYPE;
      v_iss_cd          gipi_polbasic.iss_cd%TYPE;
      v_issue_yy        gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no        gipi_polbasic.renew_no%TYPE;
      v_pos1            NUMBER;
      v_pos2            NUMBER;
      v_pos3            NUMBER;
      v_pos4            NUMBER;
      v_pos5            NUMBER;
      v_pos6            NUMBER;
      v_hash_bill       NUMBER;
      v_hash_collection NUMBER;
      v_endt_iss_cd     gipi_polbasic.endt_iss_cd%TYPE;
      v_endt_yy         gipi_polbasic.endt_yy%TYPE;
      v_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
      v_fgprem_amt        NUMBER;
      v_fcomm_amt        NUMBER;
      v_fwhtax_amt      NUMBER;
      v_finvat_amt        NUMBER;
      v_fnet_amt        NUMBER;
      v_crrnt_curr_cd   NUMBER;
      v_conv_rt         NUMBER;
      v_gprem_amt        NUMBER;
      v_comm_amt        NUMBER;
      v_whtax_amt       NUMBER;
      v_invat_amt        NUMBER;
      v_net_amt            NUMBER;
      v_stmnt           VARCHAR2(32767);
   BEGIN
   
      v_hash_bill := TO_NUMBER(p_hash_bill);
      v_hash_collection := TO_NUMBER(p_hash_collection);
      
      IF variables_intm_no IS NOT NULL --Deo [11.29.2016]
         AND variables_intm_no != TO_NUMBER(REPLACE(p_intm_no,',',NULL))
      THEN
         variables_intm_no := NULL;
         raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Only one INTM_NO is allowed.');
      END IF;
   
      IF p_intm_no IS NOT NULL THEN
         v_intm_no := TO_NUMBER(REPLACE(p_intm_no,',',NULL));
         FOR intm_rec IN (SELECT 'x'
                            FROM giis_intermediary
                            WHERE intm_no = v_intm_no)
         LOOP
            v_intm_exists := TRUE;
         END LOOP;
         
         IF NOT v_intm_exists THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid/null value for INTM_NO in excel file.');
          END IF;
         
         v_columns := v_columns||'INTM_NO_COLUMN,';
         v_values := v_values||'INTM_NO_COLUMN,';
         variables_intm_no := v_intm_no; --Deo [11.29.2016]
      ELSE --Deo [11.29.2016]
         raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. INTM_NO in excel file cannot be Null.');
      END IF;
      
      IF p_payor IS NOT NULL THEN
         v_columns := v_columns||'PAYOR,';
         v_values := v_values||''''||REPLACE(p_payor,'''','''''')||''',';
      END IF;
      
      IF p_policy_no IS NOT NULL THEN
      
         v_columns := v_columns || 'LINE_CD,SUBLINE_CD,ISS_CD,ISSUE_YY,POL_SEQ_NO,RENEW_NO,';
         v_pos6 := INSTR(p_policy_no , '-', 1, 6);
             
         IF v_pos6 <> 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');
         ELSE
            v_pos1 := instr(p_policy_no,'-',1,1);
            v_pos2 := instr(p_policy_no,'-',1,2);
            v_pos3 := instr(p_policy_no,'-',1,3);
            v_pos4 := instr(p_policy_no,'-',1,4);
            v_pos5 := instr(p_policy_no,'-',1,5);
                
            IF v_pos1 = 0 OR v_pos2 = 0 OR v_pos3 = 0 OR v_pos4 = 0 OR v_pos5 = 0 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');                
            END IF;    
                
            BEGIN
               v_line_cd := SUBSTR(p_policy_no, 1, v_pos1-1);
               v_subline_cd := SUBSTR(p_policy_no, v_pos1+1, v_pos2-v_pos1-1);
               v_iss_cd := SUBSTR(p_policy_no, v_pos2+1, v_pos3-v_pos2-1);
               v_issue_yy := TO_NUMBER(SUBSTR(p_policy_no, v_pos3+1, v_pos4-v_pos3-1));
               v_pol_seq_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos4+1, v_pos5-v_pos4-1));
               v_renew_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos5+1));
                   
            EXCEPTION WHEN OTHERS THEN   
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');   
            END;
                
            GIAC_UPLOADING_PKG.chk_pol_no(v_line_cd,v_subline_cd,v_iss_cd,v_iss_cd);
                
            v_values := v_values ||''''||v_line_cd||''','
                                 ||''''||v_subline_cd||''',' 
                                 ||''''||v_iss_cd||''','
                                 ||v_issue_yy||','
                                 ||v_pol_seq_no||','
                                 ||v_renew_no||',';
                                     
            v_hash_bill := v_hash_bill + v_pol_seq_no;
         END IF;
      END IF;
      
      IF p_endt_no IS NULL THEN
         v_endt_iss_cd := v_iss_cd;
         v_endt_yy         := 0;
         v_endt_seq_no := 0;
      ELSE
         
         v_pos3 := instr(p_endt_no,'-',1,3);
         IF v_pos3 <> 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. ENDT_NO in excel file must be in the form of ENDT_ISS_CD-ENDT_YY-ENDT_SEQ_NO.');
         ELSE
            v_pos1 := instr(p_endt_no,'-',1,1);
            v_pos2 := instr(p_endt_no,'-',1,2);
          
            IF v_pos1 = 0 OR v_pos2 = 0 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. ENDT_NO in excel file must be in the form of ENDT_ISS_CD-ENDT_YY-ENDT_SEQ_NO.');
            END IF;    
            
            BEGIN
               v_endt_iss_cd := substr(p_endt_no,1,v_pos1-1);
               v_endt_yy := to_number(substr(p_endt_no,v_pos1+1,v_pos2-v_pos1-1));
               v_endt_seq_no := to_number(substr(p_endt_no,v_pos2+1));
            EXCEPTION 
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. ENDT_NO in excel file must be in the form of ENDT_ISS_CD-ENDT_YY-ENDT_SEQ_NO.');
            END;
         END IF;
      END IF;
      
      v_columns := v_columns || 'ENDT_ISS_CD,ENDT_YY,ENDT_SEQ_NO,';
      v_values := v_values  ||''''||v_endt_iss_cd||''','
                            ||v_endt_yy||','
                            ||v_endt_seq_no||',';
                            
      v_hash_bill := v_hash_bill + v_endt_seq_no;
      
      IF p_fgross_prem_amt IS NOT NULL THEN
         v_fgprem_amt := TO_NUMBER(REPLACE(NVL(p_fgross_prem_amt,'0'),',',NULL));
         IF v_fgprem_amt = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/zero value found for FGROSS_PREM_AMT in excel file.');
         END IF;
         
         v_columns := v_columns||'FGROSS_PREM_AMT,';
         v_values := v_values||v_fgprem_amt||',';
         
      ELSE
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/zero value found for FGROSS_PREM_AMT in excel file.');
      END IF;
      
      v_fcomm_amt := TO_NUMBER(REPLACE(NVL(p_fcomm_amt,'0'),',',NULL));
      v_columns := v_columns||'FCOMM_AMT,';
      v_values := v_values||v_fcomm_amt||',';
      
      v_fwhtax_amt := to_number(replace(nvl(p_fwhtax_amt,'0'),',',NULL));
      
      IF v_fcomm_amt = 0 AND v_fwhtax_amt <> 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/zero value found for FCOMM_AMT in excel file. Therefore, FWHTAX_AMT and FINPUT_VAT_AMT must also be null/zero.');
      END IF;
      
      v_columns := v_columns||'FWHTAX_AMT,';
        v_values := v_values||v_fwhtax_amt||',';      
      
      v_finvat_amt := TO_NUMBER(REPLACE(NVL(p_finput_vat_amt,'0'),',',NULL));
      
      IF v_fcomm_amt = 0 AND v_finvat_amt <> 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/zero value found for FCOMM_AMT in excel file. Therefore, FWHTAX_AMT and FINPUT_VAT_AMT must also be null/zero.');
      END IF;
          
      v_columns := v_columns||'FINPUT_VAT_AMT,';
      v_values := v_values||v_finvat_amt||',';
      
      v_fnet_amt := TO_NUMBER(REPLACE(NVL(p_fnet_amt_due,'0'),',',NULL));
      
      FOR sign_rec IN (SELECT 'x'
                         FROM dual
                        WHERE v_fcomm_amt <> 0
                          AND (SIGN(v_fgprem_amt) <> SIGN(v_fcomm_amt) OR 
                               SIGN(v_fgprem_amt) <> DECODE(v_fwhtax_amt,0,SIGN(v_fgprem_amt),SIGN(v_fwhtax_amt)) OR
                               SIGN(v_fgprem_amt) <> DECODE(v_finvat_amt,0,SIGN(v_fgprem_amt),SIGN(v_finvat_amt))))
      LOOP                                                         
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. FGROSS_PREM_AMT, FCOMM_AMT, FWHTAX_AMT, FINPUT_VAT_AMT in excel file must have either all positive or all negative values.');
      END LOOP;
      
      IF v_fnet_amt <> v_fgprem_amt - (v_fcomm_amt - v_fwhtax_amt + v_finvat_amt) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. FNET_AMT_DUE in excel file must be equal to FGROSS_PREM_AMT - (FCOMM_AMT - FWHTAX_AMT + FINPUT_VAT_AMT).');
      END IF;
        
      v_columns := v_columns||'FNET_AMT_DUE,';
      v_values := v_values||v_fnet_amt||',';
      
      v_hash_collection := v_hash_collection + v_fnet_amt;
      
      IF NVL(p_gross_tag,'X') NOT IN ('Y','N') THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. GROSS_TAG in excel file must be either Y or N.');
      END IF;

      v_columns := v_columns||'GROSS_TAG,';                      
        v_values := v_values ||''''||p_gross_tag||''',';
      
      v_columns := v_columns||'CURRENCY_CD,';
      v_values := v_values ||p_currency_cd||',';    
      v_crrnt_curr_cd := TO_NUMBER(p_currency_cd);
      
      v_columns := v_columns||'CONVERT_RATE,';
      v_values := v_values ||p_convert_rate||',';    
      v_conv_rt := TO_NUMBER(REPLACE(p_convert_rate,',',NULL));
      
      v_columns := replace(v_columns,'INTM_NO_COLUMN,',NULL);
      v_values  := replace(v_values,'INTM_NO_COLUMN,',NULL);
      
      IF INSTR(v_columns,'GROSS_PREM_AMT,COMM_AMT,WHTAX_AMT,INPUT_VAT_AMT,NET_AMT_DUE') = 0 THEN
         v_columns := v_columns||'GROSS_PREM_AMT,COMM_AMT,WHTAX_AMT,INPUT_VAT_AMT,NET_AMT_DUE';
      END IF;
      
      v_gprem_amt :=     NVL(v_fgprem_amt*v_conv_rt,0);          
         v_comm_amt := NVL(v_fcomm_amt*v_conv_rt,0);           
        v_whtax_amt := NVL(v_fwhtax_amt*v_conv_rt,0);
        v_invat_amt := NVL(v_finvat_amt*v_conv_rt,0);     
        v_net_amt := NVL(v_fnet_amt*v_conv_rt,0);
      
      v_values := 'VALUES('||v_values||v_gprem_amt||','||v_comm_amt||','||v_whtax_amt||','||v_invat_amt||
                           ','||v_net_amt||','''||p_source_cd||''','||p_file_no||')';
                          
      v_stmnt := 'INSERT INTO GIAC_UPLOAD_PREM_COMM('||v_columns||',source_cd,file_no) '||v_values;
      
      BEGIN
         exec_immediate(v_stmnt);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Duplicate Policy/Endorsement ('||v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'
                                                                                                                           ||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no
                                                                                                                           ||'/'||v_endt_iss_cd||'-'||v_endt_yy||'-'||v_endt_seq_no||') found in excel file.');
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Error occurred in INSERT. ' || TO_CHAR(SUBSTR(SQLERRM, 11, LENGTH(SQLERRM) - 10) || '.'));
      END;
      
      p_hash_bill := TO_CHAR(v_hash_bill);
      p_hash_collection := TO_CHAR(v_hash_collection);
      p_query := v_stmnt;                    
      
   END upload_excel_type2;
   
   PROCEDURE upload_excel_type2_b (
      p_or_tag              IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_intm_no             IN   VARCHAR2
   )
   IS
      v_tran_flag giac_acctrans.tran_flag%TYPE;
      v_exist VARCHAR2(1) := 'N';
   BEGIN
   
      IF p_or_tag = 'G' THEN
      
         FOR i in (SELECT COUNT(DISTINCT CURRENCY_CD) ctr,
                          COUNT (DISTINCT convert_rate) cnt_rt --Deo [11.29.2016]
                  FROM giac_upload_prem_comm
                 WHERE source_cd  = p_source_cd
                   AND file_no    = p_file_no) 
         LOOP
            IF i.ctr > 1 THEN
                 RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Only one currency is allowed per OR.');
            END IF;
            
            IF i.cnt_rt > 1 --Deo [11.29.2016]
            THEN
               raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR.');
            END IF;
         END LOOP;
         
      ELSIF p_or_tag = 'I' THEN
      
         FOR i in (SELECT COUNT(DISTINCT CURRENCY_CD) ctr, payor, line_cd, 
                          subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                          source_cd, file_no,
                          COUNT (DISTINCT convert_rate) cnt_rt --Deo [11.29.2016]
                     FROM giac_upload_prem_comm
                    WHERE source_cd  = p_source_cd
                      AND file_no    = p_file_no
                 GROUP BY payor, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, source_cd, file_no) 
         LOOP
            IF i.ctr > 1 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Only one currency is allowed per OR,'||chr(10)||i.payor||' - '||i.line_cd||'-'||
                                                i.subline_cd||'-'||i.iss_cd||'-'||TO_CHAR(i.issue_yy,'fm09')||'-'||
                                                TO_CHAR(i.pol_seq_no,'fm0999999')||'-'||TO_CHAR(i.renew_no,'fm09')||'.');                                   
                                   
            END IF;
            
            IF i.cnt_rt > 1 --Deo [11.29.2016]
            THEN
               raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Error in converting file. Only one CONVERT_RATE is allowed per OR,'
                      || CHR (10) || i.payor || ' - ' || i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd
                      || '-' || TO_CHAR (i.issue_yy, 'fm09') || '-' || TO_CHAR (i.pol_seq_no, 'fm0999999')
                      || '-' || TO_CHAR (i.renew_no, 'fm09') || '.'
                     );            
            END IF;
         END LOOP;   
         
      END IF;
      
      FOR rec IN (SELECT file_name, tran_id, tran_class 
                    FROM giac_upload_file a
                   WHERE hash_collection = round(p_hash_collection,2)
                     AND hash_bill = p_hash_bill
                     AND no_of_records = p_records_converted
                     AND file_status <> 'C')
      LOOP
         
         IF rec.tran_class = 'JV' THEN
            SELECT tran_flag 
              INTO v_tran_flag
              FROM giac_acctrans
             WHERE tran_id = rec.tran_id;
        
            IF v_tran_flag = 'P' THEN
               SELECT 'Y'
                 INTO v_exist
                 FROM giac_reversals
                WHERE gacc_tran_id = rec.tran_id;
            
               IF v_exist = 'N' THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
               END IF;     
            
            ELSIF v_tran_flag = 'D' THEN
               NULL;
            ELSE    
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
            END IF; 
        
         ELSE    
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
         END IF;
      
      END LOOP;
      
      UPDATE giac_upload_file
           SET hash_collection = p_hash_collection,
               hash_bill = p_hash_bill,
               file_status = '1',
               no_of_records = p_records_converted,
               intm_no = p_intm_no
       WHERE source_cd = p_source_cd
         AND file_no = p_file_no;
      
      
   END upload_excel_type2_b;
   
   PROCEDURE upload_excel_type3 (
      p_assured           IN       VARCHAR2,
      p_policy_no         IN       VARCHAR2,
      p_fprem_amt         IN       VARCHAR2,
      p_ftax_amt          IN       VARCHAR2,
      p_fcomm_amt         IN       VARCHAR2,
      p_fcomm_vat         IN       VARCHAR2,
      p_fcollection_amt   IN       VARCHAR2,
      p_currency_cd       IN       VARCHAR2,
      p_convert_rate      IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_check_curr        IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   )
   IS
      n_length              NUMBER;
      v_exist                VARCHAR2(1) := 'N';
      v_flag                BOOLEAN := FALSE;
      v_flag1                BOOLEAN := FALSE;
      v_flag2                BOOLEAN := FALSE;
      v_flag3                BOOLEAN := FALSE;
      v_flag4                BOOLEAN := FALSE;
      v_flag5                BOOLEAN := FALSE;
      v_flag6                BOOLEAN := FALSE;
      v_flag7                BOOLEAN := FALSE;
      v_flag8                BOOLEAN := FALSE;
      v_flag9                BOOLEAN := FALSE;
      v_file                VARCHAR2(100);
      v_policy_no           VARCHAR2(1000);
      v_fprem_amt            VARCHAR2(1000);
      v_ftax_amt            VARCHAR2(1000);
      v_fcomm_amt            VARCHAR2(1000);
      v_fcomm_vat            VARCHAR2(1000);
      v_fcollection            VARCHAR2(1000);
      v_currency            VARCHAR2(1000);
      v_convert_rt            VARCHAR2(1000);
      v_ri_cd               VARCHAR2(1000);
      v_switch                VARCHAR2(1) := 'N';
      v_line_sw                VARCHAR2(1) := 'N';
      v_subline_sw          VARCHAR2(1) := 'N';
      v_iss_sw                VARCHAR2(1) := 'N';
      v_line                NUMBER;
      v_subline                NUMBER;
      v_issue                NUMBER;
      v_year                NUMBER;
      v_pol_sequence        NUMBER;
      v_renew                NUMBER;            
      v_prem_amt            NUMBER;
      v_tax_amt                NUMBER;
      v_comm_vat            NUMBER;
      v_comm_amt            NUMBER;
      v_collection            NUMBER;
      v_rate                  NUMBER;
      v_lprem_amt            giac_upload_inwfacul_prem.lprem_amt%TYPE;
      v_ltax_amt            giac_upload_inwfacul_prem.ltax_amt%TYPE;
      v_lcomm_amt            giac_upload_inwfacul_prem.lcomm_amt%TYPE;
      v_lcomm_vat            giac_upload_inwfacul_prem.lcomm_vat%TYPE;
      v_lcollection            giac_upload_inwfacul_prem.lcollection_amt%TYPE;
      v_ri                    giac_upload_file.ri_cd%TYPE;
      v_line_cd             giac_upload_inwfacul_prem.line_cd%TYPE;
      v_subline_cd            giac_upload_inwfacul_prem.subline_cd%TYPE;
      v_iss_cd                 giac_upload_inwfacul_prem.iss_cd%TYPE;
      v_issue_yy            giac_upload_inwfacul_prem.issue_yy%TYPE;
      v_pol_seq_no            giac_upload_inwfacul_prem.pol_seq_no%TYPE;
      v_renew_no            giac_upload_inwfacul_prem.renew_no%TYPE;
      v_hash_bill            giac_upload_file.hash_bill%TYPE;
      v_hash_collection        giac_upload_file.hash_collection%TYPE;
      v_hash_file            giac_upload_file.file_name%TYPE;
      v_curr                giac_upload_inwfacul_prem.currency_cd%TYPE;
      v_assured                giac_upload_inwfacul_prem.assured%TYPE; 
      v_tran_flag           giac_acctrans.tran_flag%type;  
      v_exist2              VARCHAR2(1) := 'N';
      v_tran_class          giac_acctrans.tran_class%type;
      v_tran_id             giac_acctrans.tran_id%type;
   BEGIN
   
      v_hash_bill := TO_NUMBER(p_hash_bill);
      v_hash_collection := TO_NUMBER(p_hash_collection);
      
      v_assured     := TRIM(p_assured);
      v_policy_no   := TRIM(p_policy_no);
      v_fprem_amt   := TRIM(p_fprem_amt);
      v_ftax_amt    := TRIM(p_ftax_amt);
      v_fcomm_amt   := TRIM(p_fcomm_amt);
      v_fcomm_vat   := TRIM(p_fcomm_vat);
      v_fcollection := TRIM(p_fcollection_amt);
      v_currency    := TRIM(p_currency_cd);
      v_convert_rt  := TRIM(p_convert_rate);
      v_ri_cd       := TRIM(p_ri_cd);
   
--      n_length       := length(ltrim(rtrim(v_assured)));
--      v_assured         := upper(substr(v_assured, 1, n_length-2));
--      v_assured         := ltrim(rtrim(v_assured));

--      n_length       := length(ltrim(rtrim(v_policy_no)));
--      v_policy_no    := upper(substr(v_policy_no, 1, n_length));  
--      v_policy_no    := ltrim(rtrim(v_policy_no));
                
      v_line_cd             := substr(v_policy_no, 1, instr(v_policy_no, '-', 1, 1) - 1);
      v_line                 := instr(v_policy_no, '-', 1, 1);
            
      v_policy_no    := substr(v_policy_no, instr(v_policy_no, '-')+1);
      v_subline_cd   := substr(v_policy_no, 1, instr(v_policy_no, '-', 1, 1) - 1);
      v_subline          := instr(v_policy_no, '-', 1, 1); --:= instr(v_policy_no, '-', 1, 1) - nvl(v_line, 0); nieko 0927
                
      v_policy_no    := substr(v_policy_no, instr(v_policy_no, '-')+1);
      v_iss_cd       := substr(v_policy_no, 1, instr(v_policy_no, '-', 1, 1) - 1);
      v_issue        := instr(v_policy_no, '-', 1, 1);
                
      v_policy_no    := substr(v_policy_no, instr(v_policy_no, '-')+1);
      v_issue_yy     := substr(v_policy_no, 1, instr(v_policy_no, '-', 1, 1) - 1);
      v_year                  := instr(v_policy_no, '-', 1, 1);
                
      v_policy_no    := substr(v_policy_no, instr(v_policy_no, '-')+1);
      v_pol_seq_no   := to_number(substr(v_policy_no, 1, instr(v_policy_no, '-', 1, 1) - 1));
      v_pol_sequence := instr(v_policy_no, '-', 1, 1);
                
      v_renew_no         := substr(v_policy_no, instr(v_policy_no, '-')+1);        
                
      n_length       := length(ltrim(rtrim(v_fprem_amt)));
--      v_fprem_amt    := upper(substr(v_fprem_amt, 1, n_length-2)); 
      v_fprem_amt    := ltrim(rtrim(v_fprem_amt));
      v_prem_amt         := to_number(replace(v_fprem_amt, ',', null));
                
      n_length       := length(ltrim(rtrim(v_ftax_amt)));
--      v_ftax_amt     := upper(substr(v_ftax_amt, 1, n_length-2)); 
      v_ftax_amt     := ltrim(rtrim(v_ftax_amt));
      v_tax_amt             := to_number(replace(v_ftax_amt, ',', null));
                
      n_length       := length(ltrim(rtrim(v_fcomm_amt)));
--      v_fcomm_amt    := upper(substr(v_fcomm_amt, 1, n_length-2)); 
      v_fcomm_amt    := ltrim(rtrim(v_fcomm_amt));
      v_comm_amt         := to_number(replace(v_fcomm_amt, ',', null));
                
      n_length       := length(ltrim(rtrim(v_fcomm_vat)));
--      v_fcomm_vat    := upper(substr(v_fcomm_vat, 1, n_length-2)); 
      v_fcomm_vat    := ltrim(rtrim(v_fcomm_vat));
      v_comm_vat         := to_number(replace(v_fcomm_vat, ',', null));
                
      n_length       := length(ltrim(rtrim(v_fcollection)));
--      v_fcollection  := upper(substr(v_fcollection, 1, n_length-2)); 
      v_fcollection  := ltrim(rtrim(v_fcollection));
      v_collection     := to_number(replace(v_fcollection, ',', null));
              
      n_length       := length(ltrim(rtrim(v_currency)));
--      v_currency     := upper(substr(v_currency, 1, n_length-2)); 
      v_currency     := ltrim(rtrim(v_currency));
                
      n_length       := length(ltrim(rtrim(v_convert_rt)));
--      v_convert_rt   := upper(substr(v_convert_rt, 1, n_length-2)); 
      v_convert_rt   := ltrim(rtrim(v_convert_rt));
      v_rate                 := to_number(replace(v_convert_rt, ',', null));
                
      n_length       := length(ltrim(rtrim(v_ri_cd)));
--      v_ri_cd        := upper(substr(v_ri_cd, 1, n_length-2)); 
      v_ri_cd               := ltrim(rtrim(v_ri_cd));
              
      v_lprem_amt         := nvl(v_prem_amt, 0) * nvl(v_rate, 0);
      v_ltax_amt         := nvl(v_tax_amt, 0) * nvl(v_rate, 0);
      v_lcomm_amt         := nvl(v_comm_amt, 0) * nvl(v_rate, 0);
      v_lcomm_vat         := nvl(v_comm_vat, 0) * nvl(v_rate, 0);
      v_lcollection     := nvl(v_collection, 0) * nvl(v_rate, 0);
      
      IF v_currency <> TO_NUMBER(p_check_curr) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Multiple currency not allowed.');
      END IF;
      
      --Deo [11.29.2016]: add start
      IF variables_convert_rate IS NOT NULL
         AND variables_convert_rate != v_rate
      THEN
         variables_convert_rate := NULL;
         raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Multiple CONVERT_RATE is not allowed.');
      END IF;
      
      variables_convert_rate := v_rate;
      --Deo [11.29.2016]: add ends
      
      IF p_policy_no IS NULL THEN
           RETURN;
        ELSE
           v_hash_bill                     := NVL(v_hash_bill, 0) + TO_NUMBER(v_pol_seq_no);
           v_hash_collection                 := NVL(v_hash_collection, 0) + NVL(v_collection, 0);
        END IF;
      
      IF p_ri_cd IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null value in RI_CD is not allowed.');
        ELSE    
           IF v_ri IS NULL THEN
              BEGIN
                   SELECT 'Y'
                   INTO v_exist
                   FROM giis_reinsurer
                     WHERE ri_cd = p_ri_cd;
              EXCEPTION
                   WHEN no_data_found THEN
                      v_exist := 'N';
                END;
              
            v_ri := v_ri_cd;
          
         END IF;    
        
           IF NVL(v_exist, 'N') = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. RI_CD value does not exist.');
           END IF;    
        END IF;
      
      IF v_line = 0 OR v_subline = 0 OR v_issue = 0 OR v_year = 0 OR v_pol_sequence = 0 OR v_renew_no IS NULL THEN
--         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. '||v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'
--                                       ||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Policy No. format should be LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');
        END IF;
      
      GIAC_UPLOADING_PKG.chk_pol_no(v_line_cd,v_subline_cd,v_iss_cd,v_iss_cd);
      
      IF NVL(v_collection, 0) <> ((v_prem_amt + v_tax_amt) - (v_comm_amt + v_comm_vat)) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. FCOLLECTION_AMT in excel must be equal to (FPREM_AMT + FTAX_AMT) - (FCOMM_AMT + FCOMM_VAT).');
        END IF;
      
      IF v_collection IS NULL OR v_collection = 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/Zero value found for FCOLLECTION_AMT in excel.');
        END IF;
      
      BEGIN
         INSERT INTO giac_upload_inwfacul_prem
                (source_cd, file_no, line_cd,
                 subline_cd, iss_cd, issue_yy,
                 pol_seq_no, renew_no, lcollection_amt,
                 lprem_amt, ltax_amt, lcomm_amt,
                 lcomm_vat, fcollection_amt, fprem_amt,
                 ftax_amt, fcomm_amt, fcomm_vat,
                 currency_cd, convert_rate, assured,
                 ri_cd) 
           VALUES (p_source_cd, p_file_no, v_line_cd,
                 v_subline_cd, v_iss_cd, TO_NUMBER(v_issue_yy),
                 TO_NUMBER(v_pol_seq_no), TO_NUMBER(v_renew_no), v_lcollection,
                 v_lprem_amt, v_ltax_amt, v_lcomm_amt,
                 v_lcomm_vat, v_collection, v_prem_amt,
                 v_tax_amt, v_comm_amt, v_comm_vat,
                 TO_NUMBER(v_currency), v_rate, v_assured,
                 v_ri_cd);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Duplicate value for policy ('||v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'
                                       ||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no||') found in excel file.');
      END;
      
      p_hash_bill := TO_CHAR(v_hash_bill);
      p_hash_collection := TO_CHAR(v_hash_collection);
  
   END upload_excel_type3;
   
   PROCEDURE upload_excel_type3_b (
      p_hash_bill           IN  VARCHAR2,
      p_hash_collection     IN  VARCHAR2,
      p_records_converted   IN  VARCHAR2,
      p_source_cd           IN  VARCHAR2,
      p_file_no             IN  VARCHAR2,
      p_ri_cd               IN  VARCHAR2
   )
   IS
      v_hash_file    giac_upload_file.file_name%TYPE;
      v_tran_class  giac_acctrans.tran_class%TYPE;
      v_tran_id     giac_acctrans.tran_id%TYPE;
      v_tran_flag   giac_acctrans.tran_flag%TYPE;
      v_exist2      VARCHAR2(1) := 'N';  
   BEGIN
      /*
      ** nieko 
      ** 07142016
      ** demo only
      BEGIN
         SELECT file_name, tran_class, tran_id
           INTO v_hash_file, v_tran_class, v_tran_id
           FROM giac_upload_file
          WHERE hash_bill = p_hash_bill
            AND hash_collection = p_hash_collection
            AND no_of_records = p_records_converted 
            AND file_status <> 'C';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
            v_hash_file := NULL;
      END;
      
      IF v_tran_class = 'JV' THEN
         SELECT tran_flag 
           INTO v_tran_flag
           FROM giac_acctrans
          WHERE tran_id = v_tran_id;
            
         IF v_tran_flag = 'P' THEN
            SELECT 'Y'
              INTO v_exist2
              FROM giac_reversals
             WHERE gacc_tran_id = v_tran_id;
            
            IF v_exist2 = 'N' THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||v_hash_file||'.xls.');
            END IF;     
            
         ELSIF v_tran_flag = 'D' THEN
            NULL;
         ELSE    
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||v_hash_file||'.xls.');
         END IF; 
      ELSE    
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||v_hash_file||'.xls.');
      END IF;*/
      FOR rec IN (SELECT file_name, tran_class, tran_id
                    FROM giac_upload_file a
                   WHERE hash_collection = p_hash_collection
                     AND hash_bill = p_hash_bill
                     AND no_of_records = p_records_converted
                     AND file_status <> 'C')
      LOOP
         
         IF rec.tran_class = 'JV' THEN
                SELECT tran_flag 
                  INTO v_tran_flag
                  FROM giac_acctrans
                 WHERE tran_id = rec.tran_id;
                IF v_tran_flag = 'P' THEN
                    SELECT 'Y'
                      INTO v_exist2
                      FROM giac_reversals
                     WHERE gacc_tran_id = rec.tran_id;
                    IF v_exist2 = 'N' THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
                    END IF;     
                ELSIF v_tran_flag = 'D' THEN
                    NULL;
                ELSE    
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
                END IF;
        ELSE    
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||rec.file_name||'.xls');
        END IF;
      
      END LOOP;
          
      
      /*IF v_hash_file IS NOT NULL THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exists in the database and are the same with the file ' ||v_hash_file||'.xls.');
      ELSE*/
      BEGIN
         UPDATE giac_upload_file
            SET hash_bill = p_hash_bill,
                hash_collection = p_hash_collection,
                no_of_records = p_records_converted,
                --ri_cd = p_ri_cd,                  --nieko Accounting Uploading GIACS608
                file_status = '1'
          WHERE source_cd = p_source_cd
            AND file_no = p_file_no;
       END;     
      --END IF;
   
   END upload_excel_type3_b;
   
   PROCEDURE upload_excel_type4 (
      p_binder_no         IN       VARCHAR2,
      p_fprem_amt         IN       VARCHAR2,
      p_fprem_vat         IN       VARCHAR2,
      p_fcomm_amt         IN       VARCHAR2,
      p_fcomm_vat         IN       VARCHAR2,
      p_fwholding         IN       VARCHAR2,
      p_fdisb_amt         IN       VARCHAR2,
      p_currency          IN       VARCHAR2,
      p_convert_rt        IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_check_curr        IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   )
   IS
      n_length          NUMBER;
      v_binder_no        VARCHAR2(1000);
      v_fprem_amt        VARCHAR2(1000);
      v_fprem_vat        VARCHAR2(1000);
      v_fcomm_amt        VARCHAR2(1000);
      v_fcomm_vat        VARCHAR2(1000);
      v_fwholding        VARCHAR2(1000);
      v_fdisb_amt        VARCHAR2(1000);
      v_currency        VARCHAR2(1000);
      v_convert_rt        VARCHAR2(1000);
      v_ri_cd           VARCHAR2(1000);
      v_line            NUMBER;
      v_binder_year        NUMBER;
      v_prem_amt        NUMBER;
      v_prem_vat        NUMBER;
      v_comm_amt        NUMBER;
      v_comm_vat        NUMBER;
      v_wholding        NUMBER;
      v_disb_amt        NUMBER;
      v_rate            NUMBER;
      v_line_cd            giac_upload_outfacul_prem.line_cd%TYPE;
      v_binder_yy        giac_upload_outfacul_prem.binder_yy%TYPE;
      v_binder_seq_no    giac_upload_outfacul_prem.binder_seq_no%TYPE;
      v_lprem_amt        giac_upload_outfacul_prem.lprem_amt%TYPE;
      v_lprem_vat        giac_upload_outfacul_prem.lprem_vat%TYPE;
      v_lcomm_amt        giac_upload_outfacul_prem.lcomm_amt%TYPE;
      v_lcomm_vat        giac_upload_outfacul_prem.lcomm_vat%TYPE;
      v_lwholding_vat    giac_upload_outfacul_prem.lwholding_vat%TYPE;
      v_ldisb_amt        giac_upload_outfacul_prem.ldisb_amt%TYPE;
      v_curr            giac_upload_outfacul_prem.currency_cd%TYPE;
      v_hash_bill        giac_upload_file.hash_bill%TYPE;
      v_hash_collection    giac_upload_file.hash_collection%TYPE;
      v_hash_file        giac_upload_file.file_name%TYPE;
      v_ri                giac_upload_file.ri_cd%TYPE;
      v_exist            VARCHAR2(1) := 'N';
      v_line_exist                VARCHAR2(1) := 'N';
      v_dum_err_msg       VARCHAR2(200);
   BEGIN
     
      v_hash_bill := TO_NUMBER(p_hash_bill);
      v_hash_collection := TO_NUMBER(p_hash_collection);
      
      v_binder_no := TRIM(p_binder_no);
      v_fprem_amt := TRIM(p_fprem_amt);
      v_fprem_vat := TRIM(p_fprem_vat);
      v_fcomm_amt := TRIM(p_fcomm_amt);
      v_fcomm_vat := TRIM(p_fcomm_vat);
      v_fwholding := TRIM(p_fwholding);
      v_fdisb_amt := TRIM(p_fdisb_amt);
      v_currency := TRIM(p_currency);
      v_convert_rt := TRIM(p_convert_rt);
      v_ri_cd := TRIM(p_ri_cd);
      
      n_length           := length(ltrim(rtrim(v_binder_no)));
--      v_binder_no        := upper(substr(v_binder_no, 1, n_length-2)); 
      v_binder_no        := ltrim(rtrim(v_binder_no));
      
      v_line_cd            := substr(v_binder_no, 1, instr(v_binder_no, '-', 1, 1) - 1);
      v_line            := instr(v_binder_no, '-', 1, 1);
      
      v_binder_no        := substr(v_binder_no, instr(v_binder_no, '-')+1);
      v_binder_yy        := substr(v_binder_no, 1, instr(v_binder_no, '-', 1, 1) - 1);
--      v_binder_year         := instr(v_binder_no, '-', 1, 1) - nvl(v_line, 0);
      v_binder_year := LENGTH(v_binder_yy);
      
      v_binder_seq_no    := substr(v_binder_no, instr(v_binder_no, '-')+1);        
      
      n_length       := length(ltrim(rtrim(v_fprem_amt)));
--      v_fprem_amt    := upper(substr(v_fprem_amt, 1, n_length-2)); 
      v_fprem_amt    := ltrim(rtrim(v_fprem_amt));
      v_prem_amt         := to_number(replace(v_fprem_amt, ',', null));
        
      n_length       := length(ltrim(rtrim(v_fprem_vat)));
--      v_fprem_vat     := upper(substr(v_fprem_vat, 1, n_length-2)); 
      v_fprem_vat     := ltrim(rtrim(v_fprem_vat));
      v_prem_vat             := to_number(replace(v_fprem_vat, ',', null));
        
      n_length       := length(ltrim(rtrim(v_fcomm_amt)));
--      v_fcomm_amt    := upper(substr(v_fcomm_amt, 1, n_length-2)); 
      v_fcomm_amt    := ltrim(rtrim(v_fcomm_amt));
      v_comm_amt         := to_number(replace(v_fcomm_amt, ',', null));
        
      n_length       := length(ltrim(rtrim(v_fcomm_vat)));
--      v_fcomm_vat    := upper(substr(v_fcomm_vat, 1, n_length-2)); 
      v_fcomm_vat    := ltrim(rtrim(v_fcomm_vat));
      v_comm_vat         := to_number(replace(v_fcomm_vat, ',', null));
                                                                   
      n_length       := length(ltrim(rtrim(v_fwholding)));
--      v_fwholding    := upper(substr(v_fwholding, 1, n_length-2)); 
      v_fwholding    := ltrim(rtrim(v_fwholding));
      v_wholding         := to_number(replace(v_fwholding, ',', null));                                                                   
                                                                   
      n_length       := length(ltrim(rtrim(v_fdisb_amt)));
--      v_fdisb_amt       := upper(substr(v_fdisb_amt, 1, n_length-2)); 
      v_fdisb_amt       := ltrim(rtrim(v_fdisb_amt));
      v_disb_amt         := to_number(replace(v_fdisb_amt, ',', null));
      
        n_length       := length(ltrim(rtrim(v_currency)));
--      v_currency     := upper(substr(v_currency, 1, n_length-2)); 
      v_currency     := ltrim(rtrim(v_currency));
        
      n_length       := length(ltrim(rtrim(v_convert_rt)));
--      v_convert_rt   := upper(substr(v_convert_rt, 1, n_length-2)); 
      v_convert_rt   := ltrim(rtrim(v_convert_rt));
      v_rate                 := to_number(replace(v_convert_rt, ',', null));
        
      n_length       := length(ltrim(rtrim(v_ri_cd)));
--      v_ri_cd        := upper(substr(v_ri_cd, 1, n_length-2)); 
      v_ri_cd               := ltrim(rtrim(v_ri_cd));
      
        v_lprem_amt             := nvl(v_prem_amt, 0) * nvl(v_rate, 0);
      v_lprem_vat             := nvl(v_prem_vat, 0) * nvl(v_rate, 0);
      v_lcomm_amt             := nvl(v_comm_amt, 0) * nvl(v_rate, 0);
      v_lcomm_vat             := nvl(v_comm_vat, 0) * nvl(v_rate, 0);
      v_lwholding_vat    := nvl(v_wholding, 0) * nvl(v_rate, 0);
      v_ldisb_amt         := nvl(v_disb_amt, 0) * nvl(v_rate, 0);
      
      
      IF v_currency <> TO_NUMBER(p_check_curr) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Multiple currency not allowed.');
      END IF;
      
      --Deo [11.29.2016]: add start
      IF variables_convert_rate IS NOT NULL
         AND variables_convert_rate != v_rate
      THEN
         variables_convert_rate := NULL;
         raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Multiple CONVERT_RATE is not allowed.');
      END IF;
      
      IF variables_ri_cd IS NOT NULL
         AND variables_ri_cd != v_ri_cd
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. Only one RI_CD is allowed.');
      END IF;
      
      variables_convert_rate := v_rate;
      variables_ri_cd := v_ri_cd;
      --Deo [11.29.2016]: add ends
      
      IF v_binder_no IS NULL THEN
           RETURN;
        ELSE
--           v_row1                                  := nvl(v_row1, 0) + 1;
           v_hash_bill        := nvl(v_hash_bill, 0) + to_number(v_binder_seq_no);
           v_hash_collection     := nvl(v_hash_collection, 0) + nvl(v_disb_amt, 0);
--           :upload.records_converted := nvl(:upload.records_converted, 0) + 1;
        END IF;
        
      IF v_ri_cd IS NULL AND v_ri IS NULL THEN
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null value in RI_CD is not allowed.');
        ELSE    
           IF v_ri IS NULL THEN
              BEGIN
                   SELECT 'Y'
                   INTO v_exist
                   FROM giis_reinsurer
                     WHERE ri_cd = v_ri_cd;
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      v_exist := 'N';
                END;
              
            v_ri := v_ri_cd;
          
         END IF;    
        
          IF nvl(v_exist, 'N') = 'N' THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. RI_CD value does not exist.');
          END IF;    
        END IF;
      
      IF v_line = 0 OR v_binder_year = 0 OR v_binder_seq_no IS NULL THEN
--         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||v_line||'-'||v_binder_year||'-'||v_binder_seq_no);
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Binder No. format should be LINE_CD-BINDER_YY-BINDER_SEQ_NO.');   
        END IF;
      
      BEGIN
           SELECT 'Y'
             INTO v_line_exist
             FROM giis_line
            WHERE line_cd = v_line_cd;
        EXCEPTION 
              WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid line code: '||v_line_cd||' found in excel file.');   
        END;
      
      IF NVL(v_disb_amt, 0) <> ((v_prem_amt + v_prem_vat) - (v_comm_amt + v_comm_vat + v_wholding)) THEN
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. FDISB_AMT in excel must be equal to (FPREM_AMT + FPREM_VAT) - (FCOMM_AMT + FCOMM_VAT + FWHOLDING_VAT).');    
        END IF;
      
      IF v_disb_amt IS NULL OR v_disb_amt = 0 THEN
          RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Null/Zero value found for FDISB_AMT in excel.');
        END IF;
      
      BEGIN
           INSERT INTO giac_upload_outfacul_prem(source_cd, file_no, line_cd,
                                               binder_yy, binder_seq_no, ldisb_amt,
                                               lprem_amt, lprem_vat, lcomm_amt,
                                               lcomm_vat, lwholding_vat, fdisb_amt,
                                               fprem_amt, fprem_vat, fcomm_amt,
                                               fcomm_vat, fwholding_vat, currency_cd, convert_rate)
              VALUES(p_source_cd, p_file_no, v_line_cd, TO_NUMBER(v_binder_yy),
                     TO_NUMBER(v_binder_seq_no), NVL(v_ldisb_amt, 0),
                     NVL(v_lprem_amt, 0), NVL(v_lprem_vat, 0), NVL(v_lcomm_amt, 0),
                     NVL(v_lcomm_vat, 0), NVL(v_lwholding_vat, 0), NVL(v_disb_amt, 0),
                     NVL(v_prem_amt, 0), NVL(v_prem_vat, 0), NVL(v_comm_amt, 0),
                     NVL(v_comm_vat, 0), NVL(v_wholding, 0), TO_NUMBER(v_currency), NVL(v_rate, 0));
        EXCEPTION
           WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Duplicate value for policy ('||v_line_cd||'-'||v_binder_yy||'-'||v_binder_seq_no||') found in excel file.');
        END;
      
      p_hash_bill := v_hash_bill;
      p_hash_collection := v_hash_collection;
   
   END upload_excel_type4;
   
   --Deo [11.29.2016]: add start
   PROCEDURE upload_excel_type4_b (
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_ri_cd               IN   VARCHAR2
   )
   IS
      v_tran_flag    giac_acctrans.tran_flag%TYPE;
      v_exist        VARCHAR2 (1)                      := 'N';
   BEGIN
      FOR rec IN (SELECT file_name, tran_class, tran_id
                    FROM giac_upload_file a
                   WHERE hash_collection = ROUND (p_hash_collection, 2)
                     AND hash_bill = p_hash_bill
                     AND no_of_records = p_records_converted
                     AND file_status <> 'C')
      LOOP
         IF rec.tran_class = 'JV'
         THEN
            SELECT tran_flag
              INTO v_tran_flag
              FROM giac_acctrans
             WHERE tran_id = rec.tran_id;

            IF v_tran_flag = 'P'
            THEN
               SELECT 'Y'
                 INTO v_exist
                 FROM giac_reversals
                WHERE gacc_tran_id = rec.tran_id;

               IF v_exist = 'N'
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Error in converting file. '
                      || 'The records in the file being converted already '
                      || 'exists in the database and are the same with the file '
                      || rec.file_name
                      || '.xls'
                     );
               END IF;
            ELSIF v_tran_flag = 'D'
            THEN
               NULL;
            ELSE
               raise_application_error
                  (-20001,
                      'Geniisys Exception#E#Error in converting file. '
                   || 'The records in the file being converted already exists '
                   || 'in the database and are the same with the file '
                   || rec.file_name
                   || '.xls'
                  );
            END IF;
         ELSE
            raise_application_error
               (-20001,
                   'Geniisys Exception#E#Error in converting file. The records '
                || 'in the file being converted already exists in the database '
                || 'and are the same with the file '
                || rec.file_name
                || '.xls'
               );
         END IF;
      END LOOP;

      BEGIN
         UPDATE giac_upload_file
            SET hash_bill = p_hash_bill,
                hash_collection = p_hash_collection,
                no_of_records = p_records_converted,
                ri_cd = p_ri_cd,
                file_status = '1'
          WHERE source_cd = p_source_cd AND file_no = p_file_no;
      END;
   END upload_excel_type4_b;
   --Deo [11.29.2016]: add ends
   
   PROCEDURE upload_excel_type5 (
      p_reference_no      IN       VARCHAR2,
      p_payor             IN       VARCHAR2,
      p_famount           IN       VARCHAR2,
      p_fdeposit_date     IN       VARCHAR2,
      p_row               IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   )
   IS
      n_length            NUMBER;
      v_reference_no      VARCHAR2 (1000);
      v_fdeposit_date     VARCHAR2 (1000);
      v_payor             VARCHAR2 (1000);
      v_famount           VARCHAR2 (1000);
      v_iss_cd            NUMBER (3);
      v_banc_branch_cd    NUMBER (5);
      v_ref_seq_no        NUMBER (8);
      v_mod_cd            NUMBER (3);
      v_deposit_date      DATE;
      v_amount            NUMBER;
      v_hash_bill         NUMBER;
      v_hash_collection   NUMBER;
      v_iss_exist         VARCHAR2 (1) := 'N';
      v_rec_id            NUMBER;
   BEGIN
   
      v_hash_bill := TO_NUMBER(p_hash_bill);
      v_hash_collection := TO_NUMBER(p_hash_collection);
      
      v_reference_no := TRIM(p_reference_no);
      v_payor := TRIM(p_payor);
      v_famount := TRIM(p_famount);
      v_fdeposit_date := TRIM(p_fdeposit_date);
      
      n_length         := length(ltrim(rtrim(v_reference_no)));
--      v_reference_no   := upper(substr(v_reference_no, 1, n_length-2));
      v_reference_no   := ltrim(rtrim(v_reference_no));
        
      BEGIN
         n_length         := length(ltrim(rtrim(v_fdeposit_date)));
--         v_fdeposit_date  := upper(substr(v_fdeposit_date, 1, n_length-2)); 
         v_deposit_date   := to_date(ltrim(rtrim(v_fdeposit_date)),'MM/DD/YYYY');
      EXCEPTION
         WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Deposit Date in Excel is not a valid date. Please check Date format at row '||p_row||' in the Excel file.');
              NULL;
      END;
      
      IF n_length IS NULL --Deo [11.29.2016]
      THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Deposit Date cannot be Null. Please check row '||p_row||' in the Excel file.');
      END IF;
            
      v_iss_cd         := substr(v_reference_no, 1, instr(v_reference_no, '-', 1, 1) - 1);
      v_banc_branch_cd := substr(v_reference_no, instr(v_reference_no, '-', 1, 1) + 1, instr(v_reference_no, '-', 1, 2) - 4);
      v_ref_seq_no     := substr(v_reference_no, instr(v_reference_no, '-', 1, 2) + 1, instr(v_reference_no, '-', 1, 3) - 9);
      v_mod_cd         := substr(v_reference_no, instr(v_reference_no, '-', 1, 3) + 1);
      
      BEGIN
         IF LENGTH (v_reference_no) <> 18 OR LENGTH (TO_NUMBER (v_iss_cd)) > 2 OR LENGTH (TO_NUMBER (v_banc_branch_cd)) > 4 OR LENGTH (TO_NUMBER (v_ref_seq_no)) > 7 OR LENGTH (TO_NUMBER (v_mod_cd)) > 2 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Bank Reference Number format should be ISS_CD-BANC_BRANCH_CD-REF_SEQ_NO-MOD_CD. Invalid Bank Reference Number format in row '||p_row);
         END IF;
      EXCEPTION
         WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Bank Reference Number format should be ISS_CD-BANC_BRANCH_CD-REF_SEQ_NO-MOD_CD. Invalid Bank Reference Number format in row '||p_row);
      END;
      
      n_length         := length(ltrim(rtrim(v_payor)));
--      v_payor          := upper(substr(v_payor, 1, n_length-2)); 
      v_payor          := ltrim(rtrim(v_payor));
        
      n_length         := length(ltrim(rtrim(v_famount)));
--      v_famount        := upper(substr(v_famount, 1, n_length-2)); 
      v_famount        := ltrim(rtrim(v_famount));
      v_amount         := to_number(replace(v_famount, ',', null));
      
      IF v_reference_no IS NULL THEN
          RETURN;
      ELSE
--          v_row1                                  := nvl(v_row1, 0) + 1;
          v_hash_bill                             := nvl(v_hash_bill, 0) + to_number(replace(v_reference_no,'-'));
          v_hash_collection                 := nvl(v_hash_collection, 0) + nvl(v_amount, 0);
--          :upload.records_converted := nvl(:upload.records_converted, 0) + 1;
      END IF;
      
      BEGIN
         SELECT 'Y'
           INTO v_iss_exist
           FROM giis_issource
          WHERE acct_iss_cd = v_iss_cd;
      EXCEPTION 
         WHEN no_data_found THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid Acct Issue code: '||v_iss_cd||' at row '||p_row);
      END;
      
      IF nvl(v_amount, 0) <= 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Amount in Excel cannot be 0, null, or negative. Please check row '||p_row||' in the Excel file.');
      END IF;
      
      IF nvl(v_amount, 0) > 99999999999999.99 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Amount in Excel cannot exceed 99,999,999,999,999.99. Please check row '||p_row||' in the Excel file.');
      END IF;
      
      BEGIN
         BEGIN
            SELECT nvl(max(rec_id),0) + 1
              INTO v_rec_id
              FROM giac_upload_prem_refno
             WHERE file_no =  p_file_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec_id := 1; 
         END; 
       
      INSERT INTO giac_upload_prem_refno
                  (rec_id, bank_ref_no, source_cd, file_no,
                   acct_iss_cd, payor, collection_amt,
                   iss_cd, banc_branch_cd, ref_seq_no, mod_cd
                  )
           VALUES (v_rec_id, v_reference_no, p_source_cd, p_file_no,
                   TO_NUMBER (v_iss_cd), v_payor, v_amount,
                   TO_NUMBER (v_iss_cd), v_banc_branch_cd, v_ref_seq_no, v_mod_cd
                  );
      END;
      
      p_hash_bill := v_hash_bill;
      p_hash_collection := v_hash_collection;
   
   END upload_excel_type5;
   
   PROCEDURE upload_excel_type5_b (
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_deposit_date        IN   VARCHAR2 
   )
   IS
      v_hash_file VARCHAR2(1000);
      v_tran_class giac_acctrans.tran_class%type;
      v_tran_id giac_acctrans.tran_id%type;
   BEGIN
   
   
      BEGIN
         SELECT file_name, tran_class, tran_id
           INTO v_hash_file, v_tran_class, v_tran_id
           FROM giac_upload_file
          WHERE hash_bill = p_hash_bill
            AND hash_collection = p_hash_collection
            AND no_of_records = p_records_converted 
            AND file_status <> 'C';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
            v_hash_file := null;
      END;
      
      IF v_hash_file IS NOT NULL THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. The records in the file being converted already exist in the database and are the same with the file '||v_hash_file||'.xls');
      ELSE
         UPDATE giac_upload_file
            SET hash_bill = p_hash_bill,
                hash_collection = p_hash_collection,
                no_of_records = p_records_converted,
                file_status = 1,
                payment_date = TO_DATE(p_deposit_date, 'mm-dd-yyyy')
          WHERE source_cd = p_source_cd
            AND file_no = p_file_no; 
      END IF;
      
      
   END upload_excel_type5_b;
   
   PROCEDURE chk_pol_no (
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_endt_iss_cd   VARCHAR2
   )
   IS
      v_temp VARCHAR2(1);
   BEGIN
      
      --line cd validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_line
          WHERE line_cd = p_line_cd;
          
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid line code: '||p_line_cd||' found in excel file.');
      END;
      
      --subline validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_subline
          WHERE subline_cd = p_subline_cd
            AND line_cd = p_line_cd; --added by john 4.17.2015
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid subline code: '||p_subline_cd||' found in excel file.');       
      END;
      
      --line, subline combination validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_subline
          WHERE line_cd = p_line_cd
            AND subline_cd = p_subline_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid line-subline combination: '||p_line_cd||'-'||p_subline_cd||' found in excel file.');       
      END;
      
      --iss_cd validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid issuing source code: '||p_iss_cd||' found in excel file.');       
      END;
      
      --endt_iss_cd
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_issource
          WHERE iss_cd = p_endt_iss_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in converting file. Invalid endt issuing source code: '||p_endt_iss_cd||' found in excel file.');       
      END;
      
   END chk_pol_no;
   
   PROCEDURE chk_pay_mode (
      p_pay_mode      giac_upload_prem_dtl.pay_mode%TYPE,
      p_bank          giac_upload_prem_dtl.bank%TYPE,
      p_check_class   giac_upload_prem_dtl.check_class%TYPE,
      p_check_no      giac_upload_prem_dtl.check_no%TYPE,
      p_check_date    giac_upload_prem_dtl.check_date%TYPE
   )
   IS
   BEGIN
      IF p_pay_mode IS NULL OR p_pay_mode = '' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Null value for pay mode found in excel file.');
      ELSIF p_pay_mode NOT IN ('CA','CC','CHK','CM') THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid value for pay mode found in excel file.');
      ELSE
         IF p_pay_mode = 'CC' THEN
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Bank in excel file cannot be null for CC pay mode.');
            ELSIF p_check_no IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Check number in excel file cannot be null for CC pay mode.');
            END IF;
         ELSIF p_pay_mode = 'CM' THEN    
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Bank in excel file cannot be null for CM pay mode.');
            END IF;
         ELSIF p_pay_mode = 'CHK' THEN
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Bank in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_class IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Check class in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_class NOT IN ('L','R','O','M') THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid value for check class found in excel file.');
            ELSIF p_check_no IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Check number in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_date IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Check date in excel file cannot be null for CHK pay mode.');
            END IF;
         END IF;   
      END IF;
   END;
   
   FUNCTION get_process_data_list (p_source_cd VARCHAR2)
      RETURN process_data_list_tab PIPELINED
   IS
      v_list process_data_list_type;
   BEGIN
      FOR i IN (SELECT file_no, file_name, hash_collection,
                       convert_date, upload_date, file_status,
                       remarks, user_id, last_update,
                       transaction_type
                  FROM GIAC_UPLOAD_FILE
                 WHERE source_cd = p_source_cd)
      LOOP
         v_list.file_no := i.file_no;
         v_list.file_name := i.file_name;
         v_list.hash_collection := i.hash_collection;
         v_list.convert_date := i.convert_date;
         v_list.upload_date := i.upload_date;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update, 'mm-dd-yyyy HH:MI:SS AM');
         
         v_list.transaction_type := i.transaction_type;
         
         BEGIN
            SELECT rv_meaning
              INTO v_list.status
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_UPLOAD_FILE.FILE_STATUS'
               AND rv_low_value = i.file_status;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.status := NULL;      
         END;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_process_data_list; 
   
   PROCEDURE check_for_claim(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_module_id     VARCHAR2
   )
   IS
   BEGIN
        IF p_module_id = 'GIACS604' THEN
            FOR i IN(
                SELECT *
                 FROM giac_upload_prem_atm
                WHERE source_cd = p_source_cd 
                  AND file_no = p_file_no
            )
            LOOP
              IF i.prem_chk_flag IN ('WC','PC','FC','OC') THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Data to be processed contains at least one policy with existing claim. Would you like to override and continue with the processing?');
              END IF;  
            END LOOP;
        END IF;
        
   END;
   
   PROCEDURE check_for_override(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2
   )
   IS
   BEGIN
        IF p_module_id = 'GIACS604' THEN
            FOR i IN(
                SELECT *
                 FROM giac_upload_prem_atm
                WHERE source_cd = p_source_cd 
                  AND file_no = p_file_no
            )
            LOOP
              IF i.prem_chk_flag <> 'OK' THEN
                IF giac_validate_user_fn(p_user_id,'UA','GIACS604') = 'FALSE' THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#'|| p_user_id ||' is not allowed to process invalid records. Would you like to override?');
                END IF;
              END IF;  
              
            END LOOP;
        END IF;
        
        --nieko Accounting Uploading GIACS608
        IF p_module_id = 'GIACS608' THEN
            FOR i IN(
                SELECT *
                 FROM giac_upload_inwfacul_prem
                WHERE source_cd = p_source_cd 
                  AND file_no = p_file_no
            )
            LOOP
              IF i.prem_chk_flag <> 'OK' THEN
                IF giac_validate_user_fn(p_user_id,'UA','GIACS608') = 'FALSE' THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#'|| p_user_id ||' is not allowed to process invalid records. Would you like to override?');
                END IF;
              END IF;  
              
            END LOOP;
        END IF;
        
   END;
   
   FUNCTION get_branch_cd(
        p_acct_branch_cd   NUMBER
   )
   RETURN VARCHAR2
   IS
        v_branch_cd     VARCHAR2(2);
   BEGIN
        SELECT branch_cd
          INTO v_branch_cd
          FROM giac_branches
         WHERE GFUN_FUND_CD = giacp.v ('FUND_CD')
           AND acct_branch_cd = p_acct_branch_cd;
        
        RETURN v_branch_cd;
   END;
   
END; 
/


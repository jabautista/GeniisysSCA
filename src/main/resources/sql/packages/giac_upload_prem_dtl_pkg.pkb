CREATE OR REPLACE PACKAGE BODY CPI.giac_upload_prem_dtl_pkg
AS
   PROCEDURE upload_excel_type1 (
      p_payor             IN   VARCHAR2,
      p_policy_no         IN   VARCHAR2,
      p_fcollection_amt   IN   VARCHAR2,
      p_pay_mode          IN   VARCHAR2,
      p_check_class       IN   VARCHAR2,
      p_check_no          IN   VARCHAR2,
      p_check_date        IN   VARCHAR2,
      p_bank              IN   VARCHAR2,
      p_payment_date      IN   VARCHAR2,
      p_currency_cd       IN   VARCHAR2,
      p_convert_rate      IN   VARCHAR2
   )
   IS
      v_values      VARCHAR2 (32767);
      v_columns     VARCHAR2 (32767);
      v_fcoll_amt   giac_upload_prem_dtl.fcollection_amt%TYPE;
      v_line_cd     gipi_polbasic.line_cd%TYPE;
	  v_subline_cd 	gipi_polbasic.subline_cd%TYPE;
 	  v_iss_cd 		gipi_polbasic.iss_cd%TYPE;
	  v_issue_yy 	gipi_polbasic.issue_yy%TYPE;
	  v_pol_seq_no 	gipi_polbasic.pol_seq_no%TYPE;
	  v_renew_no 	gipi_polbasic.renew_no%TYPE;
      v_pos1        NUMBER;
      v_pos2        NUMBER;
      v_pos3        NUMBER;
      v_pos4        NUMBER;
      v_pos5        NUMBER;
      v_pos6        NUMBER;
      v_payt_date   DATE;
      v_pay_mode					giac_upload_prem_dtl.pay_mode%TYPE;
	  v_bank              giac_upload_prem_dtl.bank%TYPE;
	  v_check_class       giac_upload_prem_dtl.check_class%TYPE;
	  v_check_no          giac_upload_prem_dtl.check_no%TYPE;
	  v_check_date        giac_upload_prem_dtl.check_date%TYPE;
   BEGIN
   
      IF p_check_date IS NOT NULL AND p_check_date <> '' THEN
         v_values := v_values || 'TO_DATE(''' || p_check_date || ''',''MM/DD/YYYY'')';
         v_columns := v_columns || 'CHECK_DATE,';
      END IF;

      IF p_fcollection_amt IS NOT NULL AND p_fcollection_amt <> '' THEN
      
         IF TO_NUMBER(p_fcollection_amt) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Zero collection amount found in excel file.');
         ELSIF TO_NUMBER(p_fcollection_amt) < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Negative collection amount found in excel file.');
         END IF;   
         
         v_values := v_values || 'replace(''' || p_fcollection_amt || ''','','',NULL)';
         v_columns := v_columns || 'FCOLLECTION_AMT,';
         v_fcoll_amt := to_number(replace(p_fcollection_amt,',',NULL));
         
      ELSIF p_fcollection_amt IS NULL OR p_fcollection_amt = '' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Null collection amount found in excel file.');
      END IF;
      
      IF p_policy_no IS NOT NULL AND p_policy_no <> '' THEN
      
         v_columns := v_columns || 'LINE_CD,SUBLINE_CD,ISS_CD,ISSUE_YY,POL_SEQ_NO,RENEW_NO,';
         v_pos6 := INSTR(p_policy_no , '-', 1, 6);
         
         IF v_pos6 <> 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');
         ELSE
            v_pos1 := instr(p_policy_no,'-',1,1);
            v_pos2 := instr(p_policy_no,'-',1,2);
            v_pos3 := instr(p_policy_no,'-',1,3);
            v_pos4 := instr(p_policy_no,'-',1,4);
            v_pos5 := instr(p_policy_no,'-',1,5);
            
            IF v_pos1 = 0 OR v_pos2 = 0 OR v_pos3 = 0 OR v_pos4 = 0 OR v_pos5 = 0 THEN
			   RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');				
            END IF;	
            
            BEGIN
               v_line_cd := SUBSTR(p_policy_no, 1, v_pos1-1);
               v_subline_cd := SUBSTR(p_policy_no, v_pos1+1, v_pos2-v_pos1-1);
               v_iss_cd := SUBSTR(p_policy_no, v_pos2+1, v_pos3-v_pos2-1);
               v_issue_yy := TO_NUMBER(SUBSTR(p_policy_no, v_pos3+1, v_pos4-v_pos3-1));
               v_pol_seq_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos4+1, v_pos5-v_pos4-1));
               v_renew_no := TO_NUMBER(SUBSTR(p_policy_no, v_pos5+1));
               
            EXCEPTION WHEN OTHERS THEN   
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. POLICY_NO in excel file must be in the form of LINE_CD-SUBLINE_CD-ISS_CD-ISSUE_YY-POL_SEQ_NO-RENEW_NO.');   
            END;
            
            GIAC_UPLOAD_PREM_DTL_PKG.chk_pol_no(v_line_cd,v_subline_cd,v_iss_cd,v_iss_cd);
            
            v_values := v_values ||''''||v_line_cd||''','
					             ||''''||v_subline_cd||''',' 
					             ||''''||v_iss_cd||''','
					             ||v_issue_yy||','
					             ||v_pol_seq_no||','
					             ||v_renew_no;
         END IF;
         
         IF p_payor IS NOT NULL OR p_payor <> '' THEN
            v_values := v_values||''''||REPLACE(p_payor,'''','''''')||'''';
            v_columns := v_columns || 'PAYOR,';
         END IF;
         
         IF p_bank IS NOT NULL OR p_bank <> '' THEN
            v_values := v_values||''''||REPLACE(p_bank,'''','''''')||'''';
            v_columns := v_columns || 'BANK,';
            
            IF this_bank_exist(p_bank) = 'No' THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. The bank '||p_bank||' is invalid. Please check the bank''s maintenance.');
            END IF;
            		
         END IF;
         
         IF p_pay_mode IS NOT NULL OR p_pay_mode <> '' THEN
            v_values := v_values||''''||p_pay_mode||'''';
            v_columns := v_columns || 'PAY_MODE,';
         END IF;
         
         IF p_check_class IS NOT NULL AND p_check_class <> '' THEN
            v_values := v_values||''''||p_check_class||'''';
            v_columns := v_columns || 'CHECK_CLASS,';
         END IF;
         
         IF p_check_no IS NOT NULL AND p_check_no <> '' THEN
            v_values := v_values||''''||p_check_no||'''';
            v_columns := v_columns || 'CHECK_NO,';
         END IF;
         
         IF p_payment_date IS NOT NULL AND p_payment_date <> '' THEN
            v_payt_date := TO_DATE(p_payment_date,'MM/DD/YYYY');
         END IF;
         
         IF p_currency_cd IS NOT NULL AND p_currency_cd <> '' THEN
            v_values := v_values ||p_currency_cd;
            v_columns := 'CURRENCY_CD,';	
         END IF;
         
         IF p_convert_rate IS NOT NULL AND p_convert_rate <> '' THEN
            v_values := v_values ||p_convert_rate;
            v_columns := 'CONVERT_RATE,';
         END IF;
         
         GIAC_UPLOAD_PREM_DTL_PKG.chk_pay_mode(p_pay_mode, p_bank, p_check_class, p_check_no, TO_DATE(p_check_date, 'mm-dd-yyyy'));
         
         
      END IF;
      
   END upload_excel_type1;
   
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
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Invalid line code: '||p_line_cd||' found in excel file.');
      END;
      
      --subline validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_subline
          WHERE subline_cd = p_subline_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Invalid subline code: '||p_subline_cd||' found in excel file.');       
      END;
      
      --line, subline combination validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_subline
          WHERE line_cd = p_line_cd
            AND subline_cd = p_subline_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Invalid line-subline combination: '||p_line_cd||'-'||p_subline_cd||' found in excel file.');       
      END;
      
      --iss_cd validation
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Invalid issuing source code: '||p_iss_cd||' found in excel file.');       
      END;
      
      --endt_iss_cd
      BEGIN
         SELECT 1
           INTO v_temp
           FROM giis_issource
          WHERE iss_cd = p_endt_iss_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Error in converting file. Invalid endt issuing source code: '||p_endt_iss_cd||' found in excel file.');       
      END;
      
   END chk_pol_no;
   
   PROCEDURE chk_pay_mode (
      p_pay_mode	  giac_upload_prem_dtl.pay_mode%TYPE,
      p_bank          giac_upload_prem_dtl.bank%TYPE,
      p_check_class   giac_upload_prem_dtl.check_class%TYPE,
      p_check_no      giac_upload_prem_dtl.check_no%TYPE,
      p_check_date    giac_upload_prem_dtl.check_date%TYPE
   )
   IS
   BEGIN
      IF p_pay_mode IS NULL OR p_pay_mode = '' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Null value for pay mode found in excel file.');
      ELSIF p_pay_mode NOT IN ('CA','CC','CHK','CM') THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Invalid value for pay mode found in excel file.');
      ELSE
         IF p_pay_mode = 'CC' THEN
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Bank in excel file cannot be null for CC pay mode.');
            ELSIF p_check_no IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Check number in excel file cannot be null for CC pay mode.');
            END IF;
         ELSIF p_pay_mode = 'CM' THEN	
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Bank in excel file cannot be null for CM pay mode.');
            END IF;
         ELSIF p_pay_mode = 'CHK' THEN
            IF p_bank IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Bank in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_class IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Check class in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_class NOT IN ('L','R','O','M') THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Invalid value for check class found in excel file.');
            ELSIF p_check_no IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Check number in excel file cannot be null for CHK pay mode.');
            ELSIF p_check_date IS NULL THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#Check date in excel file cannot be null for CHK pay mode.');
            END IF;
         END IF;   
      END IF;
   END;
   
END;
/



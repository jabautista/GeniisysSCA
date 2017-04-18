CREATE OR REPLACE PACKAGE BODY CPI.GIACR197A_PKG
AS

    FUNCTION populate_giacr197a(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_ASSD_NO         NUMBER,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_TYPE       VARCHAR2,
     P_USER            VARCHAR2
    )
     RETURN populate_giacr197a_tab PIPELINED
    AS
     ntt            populate_giacr197a_type;
     v_bm           VARCHAR2(5);
     v_tag          VARCHAR2(5);
     v_name1        VARCHAR2(75);
     v_name2        VARCHAR2(75);
     v_from_date1   DATE; 
     v_to_date1     DATE;
     v_from_date2   DATE;
     v_to_date2     DATE;
     v_and          VARCHAR2(25);
     v_rep_date     VARCHAR2(9);
     v_as_of_date   DATE;
     v_param_date   DATE;
     v_count        NUMBER(1) := 0;
    BEGIN
         BEGIN
           SELECT PARAM_VALUE_V
             INTO ntt.company_name
             FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'COMPANY_NAME';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             ntt.company_name := '(NO COMPANY_NAME IN GIIS_PARAMETERS)';
           WHEN TOO_MANY_ROWS THEN
             ntt.company_name := '(TOO MANY VALUES OF COMPANY_NAME IN GIIS_PARAMETERS)';
         END;
                 
         BEGIN
           SELECT PARAM_VALUE_V
             INTO ntt.company_address
             FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'COMPANY_ADDRESS';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             ntt.company_address := '(NO COMPANY_ADDRESS IN GIIS_PARAMETERS)';
           WHEN TOO_MANY_ROWS THEN
             ntt.company_address := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         END;
                 
         BEGIN
             ntt.report_title := giacp.v('SOA_TITLE');
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             ntt.report_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
           WHEN TOO_MANY_ROWS THEN
             ntt.report_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         END;
                 
         
         SELECT NVL(giacp.v ('SOA_SIGNATORY'), 'N')		-- SR-3985 : shan 06.19.2015
           INTO ntt.print_signatory
           FROM DUAL;
          
         
         BEGIN
           FOR C IN (SELECT PARAM_DATE
                     FROM GIAC_SOA_REP_EXT
                     WHERE USER_ID = P_USER -- USER		-- SR-3882 : shan 06.19.2015
                     AND ROWNUM =1)
           LOOP
             ntt.report_date := C.PARAM_DATE;
           END LOOP;
           IF ntt.report_date IS NULL THEN
             ntt.report_date  := SYSDATE;
           END IF;
         END;
             
         BEGIN
            FOR i IN(
                SELECT A.DATE_TAG, A.FROM_DATE1, A.TO_DATE1, A.FROM_DATE2, 
                       A.TO_DATE2,  A.AS_OF_DATE, A.PARAM_DATE, B.REP_DATE 
                  FROM GIAC_SOA_REP_EXT A, GIAC_SOA_REP_EXT_PARAM B
                 WHERE ROWNUM = 1 
                   AND A.USER_ID = P_USER
                   AND B.USER_ID = P_USER
               )
                   
            LOOP
                v_tag           := i.DATE_TAG;
                v_from_date1    := i.FROM_DATE1;
                v_to_date1      := i.TO_DATE1;
                v_from_date2    := i.FROM_DATE2;
                v_to_date2      := i.TO_DATE2;
                v_as_of_date    := i.AS_OF_DATE;
                v_param_date    := i.PARAM_DATE;
                v_rep_date      := i.REP_DATE;
                    
                IF v_rep_date = 'F' THEN  
                  IF V_TAG = 'BK' THEN
                    v_name1 := 'Booking Dates from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'IN' THEN
                    v_name1 := 'Incept Dates from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'IS' THEN
                    v_name1 := 'Issue Dates from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'BKIN' THEN
                    v_name1 := 'Booking Dates from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
                    v_name2 := 'Inception Dates from '||TO_CHAR(v_from_date2,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date2,'fmMonth DD, YYYY');
                  ELSIF v_tag = 'BKIS' THEN
                    v_name1 := 'Booking Dates from '||TO_CHAR(v_from_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date1,'fmMonth DD, YYYY');
                    v_name2 := 'Issue Dates from '||TO_CHAR(v_from_date2,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date2,'fmMonth DD, YYYY');
                  ELSE
                    ntt.dsp_name := '(Unknown Basis of Extraction)';
                  END IF;
                      
                  SELECT DECODE(v_name2,NULL,NULL,' and ') 
                    INTO v_and
                    FROM DUAL;
                     
                  ntt.dsp_name      := ('Based on '||v_name1);
                  ntt.dsp_name2     := (v_and||v_name2);
                      
                ELSIF v_rep_date = 'A' THEN 
                          
                          
                  IF v_tag = 'BK' THEN
                    v_name1 := 'Booking Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'IN' THEN
                    v_name1 := 'Incept Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'IS' THEN
                    v_name1 := 'Issue Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                    v_name2 := NULL;
                  ELSIF v_tag = 'BKIN' THEN
                    v_name1 := 'Booking Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                    v_name2 := 'Incept Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                  ELSIF v_tag = 'BKIS' THEN
                    v_name1 := 'Booking Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                    v_name2 := 'Issue Dates As Of Date '||TO_CHAR(v_as_of_date,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_param_date,'fmMonth DD, YYYY');
                  ELSE
                    ntt.dsp_name := '(Unknown Basis of Extraction)';
                  END IF;
                      
                  SELECT DECODE(v_name2,NULL,NULL,' and ') 
                    INTO v_and
                    FROM DUAL;
                     
                  ntt.dsp_name      := ('Based on '||v_name1);
                  ntt.dsp_name2     := (v_and||v_name2);   
                END IF; 
            END LOOP;
                
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                ntt.dsp_name := 'X';
              WHEN TOO_MANY_ROWS THEN
                ntt.dsp_name := 'X';
         END;
             
        ntt.date_label      := giacp.v('SOA_DATE_LABEL');
        ntt.system_date     := SYSDATE;
    
        FOR i IN (
            SELECT   UPPER (a.assd_name) assd_name, a.assd_no, a.column_title,
                     a.prem_bal_due, a.tax_bal_due, a.balance_amt_due, a.policy_no,
                     a.inst_no,
                     a.iss_cd || '-' || LPAD(a.prem_seq_no,12,0) || '-' || LPAD(a.inst_no,2,0) bill_no, --Dren 04.28.2016 SR-5341
                     a.due_date, a.incept_date, a.no_of_days, a.ref_pol_no, a.branch_cd,
                     a.intm_type, b.col_no,
                     SUM (DECODE (c.tax_cd, 8, c.tax_bal_due, 0)) doc_stamps,
                     SUM (DECODE (c.tax_cd, 9, c.tax_bal_due, 0)) lgt,
                     SUM (DECODE (c.tax_cd, 10, c.tax_bal_due, 0)) fst,
                       SUM (DECODE (c.tax_cd, 1, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 2, c.tax_bal_due, 0)) "PTAX_EVAT",
                       SUM (DECODE (c.tax_cd, 3, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 4, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 5, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 6, c.tax_bal_due, 0))
                     + SUM (DECODE (c.tax_cd, 7, c.tax_bal_due, 0)) "OTHER_TAX"
                FROM GIAC_SOA_REP_EXT a, GIAC_SOA_TITLE b, GIAC_SOA_REP_TAX_EXT c
               WHERE 1 = 1
                 AND a.iss_cd = c.iss_cd
                 AND a.prem_seq_no = c.prem_seq_no
                 AND a.inst_no = c.inst_no
                 AND a.user_id = c.user_id
                 AND a.column_title = b.col_title
                 AND a.balance_amt_due != 0
                 AND a.user_id = P_USER
                 AND a.assd_no = NVL (P_ASSD_NO, a.assd_no)
                 AND a.branch_cd = NVL (P_BRANCH_CD, a.branch_cd)
                 AND a.intm_type = NVL (P_INTM_TYPE, intm_type)
                 AND a.due_tag = DECODE (P_INC_OVERDUE, 'I', a.due_tag, 'N', 'Y')
                 AND prem_bal_due >= NVL (P_BAL_AMT_DUE, prem_bal_due)
            GROUP BY a.assd_name,
                     a.assd_no,
                     a.column_title,
                     a.prem_bal_due,
                     a.tax_bal_due,
                     a.balance_amt_due,
                     a.policy_no,
                     a.inst_no,
                     a.iss_cd || '-' || LPAD(a.prem_seq_no,12,0) || '-' || LPAD(a.inst_no,2,0), --Dren 04.28.2016 SR-5341
                     a.due_date,
                     a.incept_date,
                     a.no_of_days,
                     a.ref_pol_no,
                     a.branch_cd,
                     a.intm_type,
                     b.col_no
             ORDER BY a.assd_name
        
        )
        
        LOOP
        
            ntt.branch_cd       := i.branch_cd;
            ntt.assd_name       := i.assd_name;
            ntt.assd_no         := i.assd_no;
            ntt.column_title    := i.column_title;
            ntt.policy_no       := i.policy_no;
            ntt.inst_no         := i.inst_no;
            ntt.bill_no         := i.bill_no;
            ntt.due_date        := i.due_date;
            ntt.incept_date     := i.incept_date;
            ntt.no_of_days      := i.no_of_days;
            ntt.ref_pol_no      := i.ref_pol_no;
            ntt.intm_type       := i.intm_type;
            ntt.col_no          := i.col_no;
            ntt.prem_bal_due    := i.prem_bal_due;
            ntt.tax_bal_due     := i.tax_bal_due;
            ntt.balance_amt_due := i.balance_amt_due;
            ntt.doc_stamps      := i.doc_stamps;
            ntt.lgt             := i.lgt;
            ntt.fst             := i.fst;
            ntt.ptax_evat       := i.ptax_evat;
            ntt.other_tax       := i.other_tax;
            v_count := 1;
             
             BEGIN
               SELECT DECODE( SIGN(3-NVL(LENGTH(BILL_ADDR1||BILL_ADDR2||BILL_ADDR3), 0)), 1, 'MAIL',-1,'BILL','MAIL') ADDR
                 INTO v_bm
                 FROM GIIS_ASSURED
                WHERE ASSD_NO = i.assd_no;
                
                IF (V_BM = 'MAIL' OR V_BM IS NULL) THEN
                     SELECT MAIL_ADDR1||DECODE(MAIL_ADDR2,NULL,'',' ')||MAIL_ADDR2||DECODE(MAIL_ADDR3,NULL,'',' ')||MAIL_ADDR3
                       INTO ntt.assd_add
                       FROM GIIS_ASSURED
                      WHERE ASSD_NO = i.assd_no;
                ELSIF V_BM = 'BILL' THEN
                     SELECT BILL_ADDR1||DECODE(BILL_ADDR2,NULL,'',' ')||BILL_ADDR2||DECODE(BILL_ADDR3,NULL,'',' ')||BILL_ADDR3
                       INTO ntt.assd_add
                       FROM GIIS_ASSURED
                      WHERE ASSD_NO = i.assd_no;
                ELSE
                     ntt.assd_add := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
                END IF;
                
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ntt.assd_add := '';
                  WHEN TOO_MANY_ROWS THEN
                    ntt.assd_add := '';
             
             END;
             
             BEGIN
             
                FOR i IN(
                    SELECT label
                      FROM giac_rep_signatory 
                     WHERE report_id = 'GIACR197A'
                     ORDER BY item_no	-- SR-3882 : shan 06.19.2015
                )
                
                LOOP
                ntt.cf_label := i.label;
                EXIT;	-- SR-3882 : shan 06.19.2015
                END LOOP;
             
             END;
             
             BEGIN
             
                FOR i IN(
                    SELECT signatory 
                      FROM giac_rep_signatory a, giis_signatory_names b
                     WHERE a.signatory_id = b.signatory_id
                       AND report_id = 'GIACR197A'
                     ORDER BY item_no	-- SR-3882 : shan 06.19.2015
                )
                
                LOOP
                ntt.cf_signatory := i.signatory;
                EXIT;	-- SR-3882 : shan 06.19.2015
                END LOOP;
             
             END;
             
             BEGIN
             
                FOR i IN(
                    SELECT designation 
                      FROM giac_rep_signatory a, giis_signatory_names b
                     WHERE a.signatory_id = b.signatory_id
                       AND report_id = 'GIACR197A'
                     ORDER BY item_no	-- SR-3882 : shan 06.19.2015
                )
                
                LOOP
                ntt.cf_designation := i.designation;
                EXIT;	-- SR-3882 : shan 06.19.2015
                END LOOP;
             
             END;
            
        PIPE ROW(ntt);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(ntt);
        END IF;
        --RETURN;
    END;

END;
/

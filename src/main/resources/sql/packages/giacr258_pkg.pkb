CREATE OR REPLACE PACKAGE BODY CPI.GIACR258_PKG
AS
    FUNCTION get_giacr258_report (
      P_BAL_AMT_DUE     NUMBER,
      P_BRANCH_CD       VARCHAR2,
      P_INC_OVERDUE     VARCHAR2,
      P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
      P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
      P_MONTH           VARCHAR2,
      P_USER            VARCHAR2
    )
      RETURN populate_giacr258_tab PIPELINED
    IS
         ntt populate_giacr258_type;
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
         ntt.date_label     := giacp.v('SOA_DATE_LABEL');
         ntt.system_date    := SYSDATE;
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
             
         BEGIN
           FOR C IN (SELECT PARAM_DATE
                     FROM GIAC_SOA_REP_EXT
                     WHERE USER_ID = P_USER
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
    
        
        FOR i IN (
            SELECT DISTINCT a.branch_cd, 
                            b.ref_intm_cd, 
                            c.iss_name,
                            UPPER(a.INTM_NAME) intm_name,
                            DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no) intm_no,
                            DECODE (a.lic_tag, 'N', a.intm_type, b.intm_type) intm_type,
                            SUM(NVL(a.balance_amt_due,0)) br_bal_tot,
                            SUM(NVL(a.prem_bal_due,0)) br_prem_tot,
                            SUM(NVL(a.tax_bal_due,0)) br_tax_tot,
                            a.parent_intm_no parent_intm_no
              FROM GIAC_SOA_REP_EXT a, GIIS_INTERMEDIARY b, GIIS_ISSOURCE c
             WHERE b.intm_no = DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no)
               AND a.USER_ID = UPPER(P_USER)
               AND a.iss_cd = c.iss_cd
               AND a.BRANCH_CD = NVL(P_BRANCH_CD,a.BRANCH_CD)
               AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
               AND a.parent_intm_no != a.intm_no 
               AND a.intm_type = nvl(P_INTM_TYPE, a.intm_type)
               AND a.DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
               HAVING SUM(a.balance_amt_due) >= NVL(P_BAL_AMT_DUE, SUM(a.balance_amt_due))
               AND SUM(a.balance_amt_due) <> 0
            GROUP BY a.branch_cd,
                     c.iss_name,
                     UPPER(a.intm_name),
                     DECODE(a.lic_tag, 'N', a.intm_no, a.parent_intm_no),
                     DECODE(a.lic_tag, 'N', a.intm_type, b.intm_type),
                     b.ref_intm_cd,
                     a.parent_intm_no
            ORDER BY a.branch_cd,
                     DECODE(a.lic_tag, 'N', a.intm_no, a.parent_intm_no),
                     b.ref_intm_cd
        )            
        LOOP
             ntt.branch_cd      := i.branch_cd;
             ntt.iss_name       := i.iss_name;
             ntt.intm_no        := i.intm_no;
             ntt.parent_intm_no := i.parent_intm_no;
             ntt.ref_intm_cd    := i.ref_intm_cd;
             ntt.intm_name      := i.intm_name;
             ntt.br_prem_tot    := i.br_prem_tot;
             ntt.br_tax_tot     := i.br_tax_tot;
             ntt.br_bal_tot     := i.br_bal_tot;
             v_count := 1;
             
             FOR a IN (SELECT intm_name
                         FROM giis_intermediary
                        WHERE intm_no = i.parent_intm_no)
             LOOP
                ntt.parent_intm_name := a.intm_name;
                EXIT;
             END LOOP;
        
            PIPE ROW(ntt);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(ntt);
        END IF;
        --RETURN;
    END get_giacr258_report;
    
    --return all columns regardless if value is 0
    FUNCTION fetch_giacr258_dynamic_cols
     RETURN col_details_tab PIPELINED
    IS
     ntt    col_details_type;
    BEGIN
    
        FOR j IN (
            SELECT DISTINCT COL_TITLE,COL_NO
              FROM GIAC_SOA_TITLE
             WHERE rep_cd = 1
            ORDER BY COL_NO ASC
        )
    		
        LOOP
            ntt.col_title   := j.col_title;
            ntt.col_no      := j.col_no;
        PIPE ROW(ntt);
        END LOOP;
        RETURN;
    END fetch_giacr258_dynamic_cols;
    
    --return all details and converts null details to 0
    FUNCTION fetch_giacr258_dynamic_dets(
      P_BAL_AMT_DUE     NUMBER,
      P_BRANCH_CD       VARCHAR2,
      P_INC_OVERDUE     VARCHAR2,
      P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
      P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
      P_MONTH           VARCHAR2,
      P_USER            VARCHAR2
    )
     RETURN col_details_tab PIPELINED
    IS
     ntt    col_details_type;
    BEGIN
        FOR i IN (
            SELECT DISTINCT COL_TITLE,COL_NO
              FROM GIAC_SOA_TITLE
             WHERE rep_cd = 1
            ORDER BY COL_NO ASC
        )
    		
        LOOP
            ntt.col_title   := i.col_title;
            ntt.col_no      := i.col_no;
            
            BEGIN
                SELECT SUM(balance_amt_due) intmbal
                  INTO ntt.int_m_bal
                  FROM GIAC_SOA_REP_EXT a, GIIS_INTERMEDIARY b, GIIS_ISSOURCE c
                 WHERE b.intm_no = DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no)
                   AND a.USER_ID = UPPER(P_USER)
                   AND a.iss_cd = c.iss_cd
                   AND a.BRANCH_CD = NVL(P_BRANCH_CD,a.BRANCH_CD)
                   AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                   AND a.parent_intm_no != a.intm_no 
                   AND a.intm_type = nvl(P_INTM_TYPE, a.intm_type)
                   AND a.DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                   AND a.column_title = i.col_title
                   AND a.column_no = i.col_no
                   HAVING SUM(a.balance_amt_due) >= NVL(P_BAL_AMT_DUE, SUM(a.balance_amt_due))
                   AND SUM(a.balance_amt_due) <> 0
                GROUP BY a.column_title,
                         a.column_no;
            
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                ntt.int_m_bal   := 0;
            
            END;
         
        PIPE ROW(ntt);
        END LOOP;
        
        RETURN;
    END fetch_giacr258_dynamic_dets;
    
    --return all intm total and converts null details to 0
    FUNCTION fetch_total_par_intm(
      P_BAL_AMT_DUE     NUMBER,
      P_BRANCH_CD       VARCHAR2,
      P_INC_OVERDUE     VARCHAR2,
      P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
      P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
      P_MONTH           VARCHAR2,
      P_USER            VARCHAR2
    )
     RETURN col_details_tab PIPELINED
    IS
     ntt    col_details_type;
    BEGIN
        FOR i IN (
            SELECT DISTINCT COL_TITLE,COL_NO
              FROM GIAC_SOA_TITLE
             WHERE rep_cd = 1
            ORDER BY COL_NO ASC
        )
    		
        LOOP
            ntt.col_title   := i.col_title;
            ntt.col_no      := i.col_no;
            
            BEGIN
                SELECT SUM(balance_amt_due) intmbal
                  INTO ntt.int_m_bal
                  FROM GIAC_SOA_REP_EXT a, GIIS_INTERMEDIARY b, GIIS_ISSOURCE c
                 WHERE b.intm_no = DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no)
                   AND a.USER_ID = UPPER(P_USER)
                   AND a.iss_cd = c.iss_cd
                   AND a.BRANCH_CD = NVL(P_BRANCH_CD,a.BRANCH_CD)
                   AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                   AND a.parent_intm_no != a.intm_no 
                   AND a.intm_type = nvl(P_INTM_TYPE, a.intm_type)
                   AND a.DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                   AND a.column_title(+) = i.col_title
                   AND a.column_no(+) = i.col_no
                   HAVING SUM(a.balance_amt_due) >= NVL(P_BAL_AMT_DUE, SUM(a.balance_amt_due))
                   AND SUM(a.balance_amt_due) <> 0
                GROUP BY a.column_title,
                         a.column_no;
            
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                ntt.int_m_bal   := 0;
            
            END;
         
        PIPE ROW(ntt);
        END LOOP;
        
        RETURN;
    END fetch_total_par_intm;
    
    --return all branch total and converts null details to 0
    FUNCTION fetch_total_branch(
      P_BAL_AMT_DUE     NUMBER,
      P_BRANCH_CD       VARCHAR2,
      P_INC_OVERDUE     VARCHAR2,
      P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
      P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
      P_MONTH           VARCHAR2,
      P_USER            VARCHAR2
    )
     RETURN col_details_tab PIPELINED
    IS
     ntt    col_details_type;
    BEGIN
        FOR i IN (
            SELECT DISTINCT COL_TITLE,COL_NO
              FROM GIAC_SOA_TITLE
             WHERE rep_cd = 1
            ORDER BY COL_NO ASC
        )
    		
        LOOP
            ntt.col_title   := i.col_title;
            ntt.col_no      := i.col_no;
            
            BEGIN
                SELECT SUM(balance_amt_due) intmbal
                  INTO ntt.int_m_bal
                  FROM GIAC_SOA_REP_EXT a, GIIS_INTERMEDIARY b, GIIS_ISSOURCE c
                 WHERE b.intm_no = DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no)
                   AND a.USER_ID = UPPER(P_USER)
                   AND a.iss_cd = c.iss_cd
                   AND a.BRANCH_CD = NVL(P_BRANCH_CD,a.BRANCH_CD)
                   AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                   AND a.parent_intm_no != a.intm_no 
                   AND a.intm_type = nvl(P_INTM_TYPE, a.intm_type)
                   AND a.DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                   AND a.column_title(+) = i.col_title
                   AND a.column_no(+) = i.col_no
                   HAVING SUM(a.balance_amt_due) >= NVL(P_BAL_AMT_DUE, SUM(a.balance_amt_due))
                   AND SUM(a.balance_amt_due) <> 0
                GROUP BY a.column_title,
                         a.column_no;
            
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                ntt.int_m_bal   := 0;
            
            END;
         
        PIPE ROW(ntt);
        END LOOP;
        
        RETURN;
    END fetch_total_branch;
    
       -- SR-3570 : shan 08.04.2015
   FUNCTION GET_COLUMN_HEADER
        RETURN column_header_tab PIPELINED
    AS
        rep     column_header_type;
        v_no_of_col_allowed     NUMBER := 6;
        v_dummy     NUMBER := 0;
        v_count     NUMBER := 0;
        v_title_tab     title_tab;
        v_index     NUMBER := 0;
        v_id        NUMBER := 0;
    BEGIN
        v_title_tab := title_tab ();

        FOR t IN (SELECT DISTINCT col_title, col_no, rep_cd
                    FROM giac_soa_title
                   WHERE rep_cd = 1
                   ORDER BY col_no)
        LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.col_title;
            v_title_tab (v_index).col_no := t.col_no;
        END LOOP;

        v_index := 1;
        
        rep.no_of_dummy := 1;

          IF v_title_tab.COUNT > v_no_of_col_allowed
          THEN
             rep.no_of_dummy :=
                                  TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

             IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
             THEN
                rep.no_of_dummy := rep.no_of_dummy + 1;
             END IF;
          END IF;
                                       
        LOOP
            v_id := v_id + 1;
            rep.dummy := v_id;            
            
            rep.col_title1 := NULL;
            rep.col_no1 := NULL;
            rep.col_title2 := NULL;
            rep.col_no2 := NULL;
            rep.col_title3 := NULL;
            rep.col_no3 := NULL;
            rep.col_title4 := NULL;
            rep.col_no4 := NULL;
            rep.col_title5 := NULL;
            rep.col_no5 := NULL;
            rep.col_title6 := NULL;
            rep.col_no6 := NULL;
            
             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title1 := v_title_tab (v_index).col_title;
                rep.col_no1 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title2 := v_title_tab (v_index).col_title;
                rep.col_no2 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title3 := v_title_tab (v_index).col_title;
                rep.col_no3 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title4 := v_title_tab (v_index).col_title;
                rep.col_no4 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title5 := v_title_tab (v_index).col_title;
                rep.col_no5 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;
             
             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title6 := v_title_tab (v_index).col_title;
                rep.col_no6 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
        END LOOP;
         
    END GET_COLUMN_HEADER;
    
    FUNCTION get_report_details(
        p_bal_amt_due   NUMBER,
        p_branch_cd     VARCHAR2,
        p_inc_overdue   VARCHAR2,
        p_intm_no       giis_intermediary.intm_no%TYPE,
        p_intm_type     VARCHAR2,
        p_month         VARCHAR2,
        p_user          VARCHAR2
    ) RETURN rep_tab PIPELINED
    AS
        ntt             rep_type;
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
        v_exist         VARCHAR2(1) := 'N';
    BEGIN
        -- ======== report header ==========
        ntt.date_label     := giacp.v('SOA_DATE_LABEL');
        ntt.system_date    := SYSDATE;
        ntt.report_title := giacp.v('SOA_TITLE');
        
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
            FOR C IN (SELECT PARAM_DATE
                        FROM GIAC_SOA_REP_EXT
                       WHERE USER_ID = P_USER
                         AND ROWNUM = 1)
            LOOP
                ntt.report_date := C.PARAM_DATE;
            END LOOP;
                   
            IF ntt.report_date IS NULL THEN
                ntt.report_date  := SYSDATE;
            END IF;
        END;
                
        ntt.cf_label := ntt.date_label || ' ' || TO_CHAR(ntt.report_date, 'fmMonth DD, RRRR');
        
        BEGIN
            FOR i IN(
                    SELECT A.DATE_TAG, A.FROM_DATE1, A.TO_DATE1, A.FROM_DATE2, 
                           A.TO_DATE2,  A.AS_OF_DATE, A.PARAM_DATE, B.REP_DATE 
                      FROM GIAC_SOA_REP_EXT A, GIAC_SOA_REP_EXT_PARAM B
                     WHERE ROWNUM = 1 
                       AND A.USER_ID = P_USER
                       AND B.USER_ID = P_USER
            ) LOOP
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
        
        -- ======== report records =========
        FOR i IN ( SELECT DISTINCT a.branch_cd, 
                            b.ref_intm_cd, 
                            c.iss_name,
                            UPPER(a.INTM_NAME) intm_name,
                            DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no) intm_no,
                            DECODE (a.lic_tag, 'N', a.intm_type, b.intm_type) intm_type,
                            SUM(NVL(a.balance_amt_due,0)) br_bal_tot,
                            SUM(NVL(a.prem_bal_due,0)) br_prem_tot,
                            SUM(NVL(a.tax_bal_due,0)) br_tax_tot,
                            a.parent_intm_no parent_intm_no
                      FROM GIAC_SOA_REP_EXT a, GIIS_INTERMEDIARY b, GIIS_ISSOURCE c
                     WHERE b.intm_no = DECODE (a.lic_tag, 'N', a.intm_no, a.parent_intm_no)
                       AND a.USER_ID = UPPER(P_USER)
                       AND a.iss_cd = c.iss_cd
                       AND a.BRANCH_CD = NVL(P_BRANCH_CD,a.BRANCH_CD)
                       AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                       AND a.parent_intm_no != a.intm_no 
                       AND a.intm_type = nvl(P_INTM_TYPE, a.intm_type)
                       AND a.DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                    HAVING SUM(a.balance_amt_due) >= NVL(P_BAL_AMT_DUE, SUM(a.balance_amt_due))
                       AND SUM(a.balance_amt_due) <> 0
                     GROUP BY a.branch_cd,
                              c.iss_name,
                              UPPER(a.intm_name),
                              DECODE(a.lic_tag, 'N', a.intm_no, a.parent_intm_no),
                              DECODE(a.lic_tag, 'N', a.intm_type, b.intm_type),
                              b.ref_intm_cd,
                              a.parent_intm_no
                     ORDER BY a.branch_cd, A.PARENT_INTM_NO,
                              DECODE(a.lic_tag, 'N', a.intm_no, a.parent_intm_no),
                              b.ref_intm_cd)
        LOOP
            v_exist            := 'Y';
            ntt.branch_cd      := NULL;
            ntt.iss_name       := NULL;
            ntt.intm_no        := NULL;
            ntt.parent_intm_no := NULL;
            ntt.ref_intm_cd    := NULL;
            ntt.intm_name      := NULL;
            ntt.br_prem_tot    := NULL;
            ntt.br_tax_tot     := NULL;
            ntt.br_bal_tot     := NULL;
            ntt.parent_intm_name := NULL;
            ntt.cf_branch       := NULL;
                         
            ntt.col_title1 := NULL;
            ntt.col_no1 := NULL;
            ntt.col_title2 := NULL;
            ntt.col_no2 := NULL;
            ntt.col_title3 := NULL;
            ntt.col_no3 := NULL;
            ntt.col_title4 := NULL;
            ntt.col_no4 := NULL;
            ntt.col_title5 := NULL;
            ntt.col_no5 := NULL;
            ntt.col_title6 := NULL;
            ntt.col_no6 := NULL;
             
            FOR j IN (SELECT *
                        FROM TABLE(GIACR258_PKG.get_column_header))
            LOOP
                ntt.branch_cd      := i.branch_cd;
                ntt.iss_name       := i.iss_name;
                ntt.cf_branch      := i.branch_cd || ' - ' || i.iss_name;
                ntt.intm_no        := i.intm_no;
                ntt.parent_intm_no := i.parent_intm_no;
                ntt.ref_intm_cd    := i.ref_intm_cd;
                ntt.intm_name      := i.intm_name;
                ntt.br_prem_tot    := i.br_prem_tot;
                ntt.br_tax_tot     := i.br_tax_tot;
                ntt.br_bal_tot     := i.br_bal_tot;
                v_count := 1;
                             
                FOR a IN (SELECT intm_name
                            FROM giis_intermediary
                           WHERE intm_no = i.parent_intm_no)
                LOOP
                    ntt.parent_intm_name := a.intm_name;
                    EXIT;
                END LOOP;
                
                ntt.branch_cd_dummy  :=  ntt.branch_cd || '_' || j.dummy;
                ntt.dummy            := j.dummy;
                                             
                ntt.no_of_dummy     := j.no_of_dummy;
                ntt.col_title1      := j.col_title1;
                ntt.col_no1         := j.col_no1;
                ntt.col_title2      := j.col_title2;
                ntt.col_no2         := j.col_no2;
                ntt.col_title3      := j.col_title3;
                ntt.col_no3         := j.col_no3;
                ntt.col_title4      := j.col_title4;
                ntt.col_no4         := j.col_no4;
                ntt.col_title5      := j.col_title5;
                ntt.col_no5         := j.col_no5;
                ntt.col_title6      := j.col_title6;
                ntt.col_no6         := j.col_no6;
             
                IF j.col_no1 IS NOT NULL THEN
                     ntt.intmbal1 := 0;
                     ntt.intmprem1 := 0;
                     ntt.intmtax1 := 0;
                ELSE
                     ntt.intmbal1 := NULL;
                     ntt.intmprem1 := NULL;
                     ntt.intmtax1 := NULL;
                END IF;
                
                IF j.col_no2 IS NOT NULL THEN
                     ntt.intmbal2 := 0;
                     ntt.intmprem2 := 0;
                     ntt.intmtax2 := 0;
                ELSE
                     ntt.intmbal2 := NULL;
                     ntt.intmprem2 := NULL;
                     ntt.intmtax2 := NULL;
                END IF;
                
                IF j.col_no3 IS NOT NULL THEN
                     ntt.intmbal3 := 0;
                     ntt.intmprem3 := 0;
                     ntt.intmtax3 := 0;
                ELSE
                     ntt.intmbal3 := NULL;
                     ntt.intmprem3 := NULL;
                     ntt.intmtax3 := NULL;
                END IF;
                
                IF j.col_no4 IS NOT NULL THEN
                     ntt.intmbal4 := 0;
                     ntt.intmprem4 := 0;
                     ntt.intmtax4 := 0;
                ELSE
                     ntt.intmbal4 := NULL;
                     ntt.intmprem4 := NULL;
                     ntt.intmtax4 := NULL;
                END IF;
                
                IF j.col_no5 IS NOT NULL THEN
                     ntt.intmbal5 := 0;
                     ntt.intmprem5 := 0;
                     ntt.intmtax5 := 0;
                ELSE
                     ntt.intmbal5 := NULL;
                     ntt.intmprem5 := NULL;
                     ntt.intmtax5 := NULL;
                END IF;
                
                IF j.col_no6 IS NOT NULL THEN
                     ntt.intmbal6 := 0;
                     ntt.intmprem6 := 0;
                     ntt.intmtax6 := 0;
                ELSE
                     ntt.intmbal6 := NULL;
                     ntt.intmprem6 := NULL;
                     ntt.intmtax6 := NULL;
                END IF;
                
                FOR k IN (SELECT branch_cd,
                                 intm_name,
                                 DECODE (lic_tag, 'N', intm_no, parent_intm_no) intm_no, 
                                 intm_type, 
                                 column_no,
                                 SUM(balance_amt_due) intmbal,
                                 SUM(prem_bal_due) intmprem,
                                 SUM(tax_bal_due) intmtax 
                            FROM giac_soa_rep_ext
                           WHERE USER_ID = UPPER(P_USER)
                             AND BRANCH_CD = i.branch_cd
                             AND DECODE (lic_tag, 'N', intm_no, parent_intm_no) = NVL(i.intm_no, DECODE (lic_tag, 'Y', intm_no, parent_intm_no))
                             AND intm_type = i.intm_type
                             AND parent_intm_no != DECODE (lic_tag, 'N', intm_no, parent_intm_no)
                             AND DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                             AND column_no IN (j.col_no1, j.col_no2, j.col_no3, j.col_no4, j.col_no5, j.col_no6)
                          HAVING SUM(balance_amt_due) <> 0
                           GROUP BY branch_cd,intm_name,column_no,parent_intm_no,DECODE (lic_tag, 'N', intm_no, parent_intm_no), intm_type)
                LOOP
                    IF j.col_no1 = k.column_no THEN
                         ntt.intmbal1 := NVL(k.intmbal,0);
                         ntt.intmprem1 := NVL(k.intmprem,0);
                         ntt.intmtax1 := NVL(k.intmtax,0);
                    ELSIF j.col_no2 = k.column_no THEN
                         ntt.intmbal2 := NVL(k.intmbal,0);
                         ntt.intmprem2 := NVL(k.intmprem,0);
                         ntt.intmtax2 := NVL(k.intmtax,0);
                    ELSIF j.col_no3 = k.column_no THEN
                         ntt.intmbal3 := NVL(k.intmbal,0);
                         ntt.intmprem3 := NVL(k.intmprem,0);
                         ntt.intmtax3 := NVL(k.intmtax,0);
                    ELSIF j.col_no4 = k.column_no THEN
                         ntt.intmbal4 := NVL(k.intmbal,0);
                         ntt.intmprem4 := NVL(k.intmprem,0);
                         ntt.intmtax4 := NVL(k.intmtax,0);
                    ELSIF j.col_no5 = k.column_no THEN
                         ntt.intmbal5 := NVL(k.intmbal,0);
                         ntt.intmprem5 := NVL(k.intmprem,0);
                         ntt.intmtax5 := NVL(k.intmtax,0);
                    ELSIF j.col_no6 = k.column_no THEN
                         ntt.intmbal6 := NVL(k.intmbal,0);
                         ntt.intmprem6 := NVL(k.intmprem,0);
                         ntt.intmtax6 := NVL(k.intmtax,0);
                    END IF;
                END LOOP;
                
                PIPE ROW(ntt);
            END LOOP;
        END LOOP;
        
        IF v_exist = 'N' THEN
            PIPE ROW(ntt);
        END IF;
        
    END get_report_details;
    
    -- end SR-3571
END;
/



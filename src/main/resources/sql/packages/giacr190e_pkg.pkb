CREATE OR REPLACE PACKAGE BODY CPI.GIACR190E_PKG
AS
    /** Created By:     Shan bati
     ** Date Created:   06.06.2013
     ** Referenced By:  GIACR190E - Reports on Premiums Receivable
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        V_NAME VARCHAR2(350);
    BEGIN
        SELECT PARAM_VALUE_V
          INTO V_NAME
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_NAME';
  
        RETURN (V_NAME);
        
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_NAME := '(NO COMPANY_NAME IN GIIS_PARAMETERS)';
            RETURN (V_NAME);
        WHEN TOO_MANY_ROWS THEN
            V_NAME := '(TOO MANY VALUES OF COMPANY_NAME IN GIIS_PARAMETERS)';
            RETURN (V_NAME);
    END CF_COMPANY_NAME;
       
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        V_ADD VARCHAR2(350);
    BEGIN
        SELECT PARAM_VALUE_V
          INTO V_ADD
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_ADDRESS';
  
        RETURN (V_ADD);
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADD := '(NO COMPANY_ADDRESS IN GIIS_PARAMETERS)';
            RETURN (V_ADD);
        WHEN TOO_MANY_ROWS THEN
            V_ADD := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
            RETURN (V_ADD);
    END CF_COMPANY_ADDRESS;
       
    
    FUNCTION CF_TITLE
        RETURN VARCHAR2
    AS
        v_title VARCHAR2(100);
    BEGIN
        v_title := giacp.v('SOA_TITLE');

        RETURN(v_title);

    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
            RETURN(v_title);
        WHEN TOO_MANY_ROWS THEN
            v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
            RETURN(v_title);
    END CF_TITLE;
        
       
    FUNCTION CF_DATE_LABEL
        RETURN VARCHAR2
    AS
        v_date_label  VARCHAR2(100);
    BEGIN
        v_date_label := giacp.v('SOA_DATE_LABEL');

        RETURN(v_date_label);

    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
            RETURN(v_date_label);
        WHEN TOO_MANY_ROWS THEN
            v_date_label := '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
            RETURN(v_date_label);
    END CF_DATE_LABEL;
          
    
    FUNCTION CF_DATE(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN DATE
    AS
        V_DATE DATE;
    BEGIN
        FOR C IN (SELECT PARAM_DATE
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = P_USER
                     AND ROWNUM =1)
        LOOP
            V_DATE := C.PARAM_DATE;
            EXIT;
        END LOOP;
        
        IF V_DATE IS NULL THEN
            V_DATE := SYSDATE;
        END IF;
        
        RETURN (V_DATE);
    END CF_DATE;
    
    
    FUNCTION CF_DATES(
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN VARCHAR2
    AS
        V_DATE			DATE;
        V_REP_DATE      varchar2(1); --RYAN 112807
    BEGIN
        FOR C IN (SELECT A.PARAM_DATE, B.REP_DATE
                    FROM GIAC_SOA_REP_EXT A, GIAC_SOA_REP_EXT_PARAM B
                   WHERE ROWNUM = 1 
                     AND A.USER_ID = P_USER 
                     AND B.USER_ID = P_USER)
        LOOP
            V_DATE := C.PARAM_DATE;
            V_REP_DATE := C.REP_DATE; --RYAN 112807
            
            EXIT;
        END LOOP;
  
        IF v_rep_date = 'F' THEN --ryan 112807 -> IF FROM_TO IS TAGGED        	
            IF V_DATE IS NULL THEN
                V_DATE := SYSDATE;
            END IF;
            --  RETURN ('As of '||TO_CHAR(SYSDATE,'fmMonth DD, YYYY')||', Cut-off '||TO_CHAR(V_DATE,'fmMonth DD, YYYY'));
            --RETURN ('As of '||TO_CHAR(:P_AS_OF_DATE,'fmMonth DD, YYYY')||', Cut-off '||TO_CHAR(V_DATE,'fmMonth DD, YYYY'));
            RETURN ('Cut-off '||TO_CHAR(V_DATE,'fmMonth DD, YYYY'));

        ELSIF V_REP_DATE = 'A' THEN --ryan 112807 -> IF AS_OF_DATE IS TAGGED
            RETURN ('As of '||TO_CHAR(P_AS_OF_DATE,'fmMonth DD, YYYY')||', Cut-off '||TO_CHAR(V_DATE,'fmMonth DD, YYYY'));
        ELSE --added
            RETURN NULL;
        END IF;
    END CF_DATES;
        
       
    FUNCTION CF_AS_OF_DATE(
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN VARCHAR2
    AS
        V_DATE			DATE;
    BEGIN
          FOR C IN (SELECT AS_OF_DATE
                      FROM GIAC_SOA_REP_EXT
                     WHERE USER_ID = P_USER
                       AND ROWNUM = 1)
        LOOP
            V_DATE := C.AS_OF_DATE;
            EXIT;
        END LOOP;
        
        IF V_DATE IS NULL THEN
            V_DATE := SYSDATE;
        END IF;
    
        --RETURN ('As of '||TO_CHAR(SYSDATE,'fmMonth DD, YYYY')||', Cut-off '||TO_CHAR(V_DATE,'fmMonth DD, YYYY'));
        RETURN ('Based on As Of Date: '||TO_CHAR(P_AS_OF_DATE,'fmMonth DD, YYYY'));

    END CF_AS_OF_DATE;
      
    
    FUNCTION CF_DATE_TAG1(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR
    AS
        V_TAG           VARCHAR2(5);
        V_NAME1         VARCHAR2(75);
        V_NAME2         VARCHAR2(75);
        V_FROM_DATE1    DATE; 
        V_TO_DATE1      DATE;
        V_FROM_DATE2    DATE;
        V_TO_DATE2      DATE;
        V_AND           VARCHAR2(25);
        V_AS_OF_DATE    DATE; --ryan 112807
        V_PARAM_DATE    DATE;---ryan 112807
        DSP_NAME        VARCHAR2(300);
        V_REP_DATE      varchar2(1);---ryan 112807
        V_BAL_DUE   VARCHAR2(16);
    BEGIN
        FOR C IN (SELECT A.DATE_TAG, A.FROM_DATE1, A.TO_DATE1, A.BALANCE_AMT_DUE, 
                         A.FROM_DATE2, A.TO_DATE2,  A.AS_OF_DATE, A.PARAM_DATE, B.REP_DATE --
                    FROM GIAC_SOA_REP_EXT A, GIAC_SOA_REP_EXT_PARAM B
                   WHERE ROWNUM = 1 
                     AND A.USER_ID = P_USER 
                     AND B.USER_ID = P_USER)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1; 
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;    
            V_REP_DATE := C.REP_DATE; --RYAN 112807
            V_AS_OF_DATE := C.AS_OF_DATE; --ryan 112807
            V_PARAM_DATE := C.PARAM_DATE; --ryan 112807
            V_BAL_DUE := C.BALANCE_AMT_DUE;
            EXIT; 
        END LOOP;
        
        IF v_rep_date = 'F' THEN  --ryan 112807 -> IF FROM_TO IS TAGGED
            /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
            IF V_TAG = 'BK' THEN
                V_NAME1 := 'Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IN' THEN
                V_NAME1 := 'Incept Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IS' THEN
                V_NAME1 := 'Issue Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'BKIN' THEN
                V_NAME1 := 'Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := 'Inception Dates from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
            ELSIF V_TAG = 'BKIS' THEN
                V_NAME1 := 'Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := 'Issue Dates from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
            ELSE
                DSP_NAME := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE(V_NAME2,NULL,NULL,' and ') 
              INTO V_AND
              FROM DUAL;
             
            DSP_NAME := ('Based on '||V_NAME1);
            /*PASS THE SECOND NAME TO CF_DATE_TAG2 */
            GIACR190E_PKG.DSP_NAME2 := (V_AND||V_NAME2);

            --RETURN (DSP_NAME);
            
        ELSIF v_rep_date = 'A' THEN --ryan 112807 -> IF AS_OF_DATE IS TAGGED
            IF V_TAG = 'BK' THEN
                V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IN' THEN
                V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IS' THEN
                V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'BKIN' THEN
                V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
            ELSIF V_TAG = 'BKIS' THEN
                V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');--||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
            ELSE
                DSP_NAME := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE(V_NAME2,NULL,NULL,' and ') 
              INTO V_AND
              FROM DUAL;
             
            DSP_NAME := ('Based on '||V_NAME1);
            /*PASS THE SECOND NAME TO CF_DATE_TAG2 */
            GIACR190E_PKG.DSP_NAME2 := (V_AND||V_NAME2);

            --RETURN (DSP_NAME);
        END IF; 
        
        RETURN (DSP_NAME);
    END CF_DATE_TAG1;
    
    
    FUNCTION CF_DATE_TAG2(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR2
    AS
        DSP_NAME2  VARCHAR2(200);
    BEGIN
        DSP_NAME2 := NVL(GIACR190E_PKG.DSP_NAME2,NULL);
        RETURN(DSP_NAME2);
    END CF_DATE_TAG2;
    
          
    FUNCTION CF_DATE_TAG3(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR2
    AS
        V_TAG           VARCHAR2(5);
        V_NAME1         VARCHAR2(75);
        V_NAME2         VARCHAR2(75);
        V_FROM_DATE1    DATE; 
        V_TO_DATE1      DATE;
        V_FROM_DATE2    DATE;
        V_TO_DATE2      DATE;
        V_AND           VARCHAR2(25);
        V_AS_OF_DATE    DATE; --ryan 112807
        V_PARAM_DATE    DATE; --ryan 112807
        DSP_NAME        VARCHAR2(300);
        V_REP_DATE      varchar2(1);
    BEGIN
        FOR C IN (SELECT A.DATE_TAG, A.FROM_DATE1, A.TO_DATE1,
                         A.FROM_DATE2, A.TO_DATE2, B.REP_DATE, A.AS_OF_DATE, A.PARAM_DATE --
                    FROM GIAC_SOA_REP_EXT A, GIAC_SOA_REP_EXT_PARAM B
                   WHERE ROWNUM = 1 
                     AND A.USER_ID = P_USER 
                     AND B.USER_ID = P_USER)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1; 
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;    
            V_REP_DATE := C.REP_DATE;
            V_AS_OF_DATE := C.AS_OF_DATE; --ryan 112807
            V_PARAM_DATE := C.PARAM_DATE; --ryan 112807
            EXIT; 
        END LOOP;
        
        IF v_rep_date = 'F' THEN  -- ---------------------------------------ryan 112807
            /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
            IF V_TAG = 'BK' THEN
                V_NAME1 := 'And Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IN' THEN
                V_NAME1 := 'And Incept Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IS' THEN
                V_NAME1 := 'And Issue Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'BKIN' THEN
                V_NAME1 := 'And Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := 'And Inception Dates from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
            ELSIF V_TAG = 'BKIS' THEN
                V_NAME1 := 'And Booking Dates from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
                V_NAME2 := 'And Issue Dates from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
            ELSE
                DSP_NAME := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE(V_NAME2,NULL,NULL,' and ') 
              INTO V_AND
              FROM DUAL;
             
            DSP_NAME := (V_NAME2);
            /*PASS THE SECOND NAME TO CF_DATE_TAG2 */
            GIACR190E_PKG.DSP_NAME2 := (V_AND||V_NAME2);

            --RETURN (DSP_NAME);
        
        ELSIF v_rep_date = 'A' THEN --ryan 112807	
            IF V_TAG = 'BK' THEN
                V_NAME1 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY'); 
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IN' THEN
                V_NAME1 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'IS' THEN
                V_NAME1 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL;
            ELSIF V_TAG = 'BKIN' THEN
                V_NAME1 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
            ELSIF V_TAG = 'BKIS' THEN
                V_NAME1 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
                V_NAME2 := NULL; --'As Of Date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_PARAM_DATE,'fmMonth DD, YYYY');
            ELSE
                DSP_NAME := '(Unknown Basis of Extraction)';
            END IF;

            SELECT DECODE(V_NAME2,NULL,NULL,' and ') 
              INTO V_AND
              FROM DUAL;
             
            DSP_NAME := (V_NAME2);
            /*PASS THE SECOND NAME TO CF_DATE_TAG2*/
            GIACR190E_PKG.DSP_NAME2 := (V_AND||V_NAME2);

            --RETURN (DSP_NAME);    
        END IF;
        
        RETURN (DSP_NAME);
    END CF_DATE_TAG3;
    
    
    PROCEDURE BEFOREREPORT
    AS    
    BEGIN
        SELECT GET_REP_DATE_FORMAT
          INTO GIACR190E_PKG.CP_DATE_FORMAT
          FROM DUAL;
    END BEFOREREPORT;
    
    
    FUNCTION GET_REPORT_HEADER(
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN report_header_tab PIPELINED
    AS
        rep     report_header_type;
    BEGIN
        BEFOREREPORT;
        
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.print_company       := giacp.v('SOA_HEADER');
        rep.rundate             := TO_CHAR(SYSDATE, GIACR190E_PKG.CP_DATE_FORMAT);
        rep.cf_title            := CF_TITLE;
        rep.cf_date_label       := CF_DATE_LABEL;
        rep.cf_date             := CF_DATE(P_USER);
        rep.cf_dates            := CF_DATES(P_USER, P_AS_OF_DATE);
        rep.cf_as_of_date       := CF_AS_OF_DATE(P_USER, P_AS_OF_DATE);
        rep.cf_date_tag1        := CF_DATE_TAG1(P_USER);
        rep.cf_date_tag2        := CF_DATE_TAG2(P_USER);
        rep.cf_date_tag3        := CF_DATE_TAG3(P_USER);
        
        PIPE ROW(rep);
    END GET_REPORT_HEADER; 


    FUNCTION CF_TOTAL(
        p_balance_amt_due       NUMBER,
        p_afterdate_collection  NUMBER
    ) RETURN NUMBER
    AS
        v_total number;
    BEGIN
        v_total := p_balance_amt_due - p_afterdate_collection;
        return(v_total);
    END CF_TOTAL;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_branch_cd     GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        p_intm_type     GIAC_SOA_REP_EXT.INTM_TYPE%TYPE,
        p_intm_no       GIAC_SOA_REP_EXT.INTM_NO%TYPE,
        p_param_date    GIAC_SOA_REP_EXT.PARAM_DATE%TYPE,
        p_bal_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%TYPE,
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        FOR i IN  ( SELECT DISTINCT c.iss_name, a.iss_cd,   
                           UPPER(a.INTM_NAME) intm_name, a.intm_no, a.intm_type||'-'||to_char(a.intm_no) agent_code,
                           SUM(balance_amt_due) balance_amt_due,
                           --SUM(prem_bal_due),SUM(tax_bal_due)
                           --SUM(afterdate_prem)  afterdate_collection,
                           SUM(afterdate_coll)  afterdate_collection,   -- judyann 05042005
                           a.intm_type --issa
                      FROM giac_soa_rep_ext a, giis_intermediary b, giis_issource c
                     WHERE a.intm_no = b.intm_no 
                       AND a.USER_ID = UPPER(P_USER)
                       AND a.iss_cd = c.iss_cd
                       AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                       AND a.PARAM_DATE = NVL(P_PARAM_DATE, a.PARAM_DATE)
                       AND a.iss_cd = NVL (P_BRANCH_CD, a.iss_cd) --issa
                       AND a.intm_type = NVl (p_intm_type, a.intm_type) --issa
                    HAVING sum(a.balance_amt_due) >= nvl(P_BAL_AMT_DUE, sum(a.balance_amt_due)) --ryan112807
                       AND sum(a.balance_amt_due) <> 0 --ryan112807
                     GROUP BY a.iss_cd,a.intm_name, a.intm_no,a.intm_type, a.iss_cd, c.iss_name
                     ORDER BY a.iss_cd, a.intm_no)
        LOOP
            rep.iss_cd                  := i.iss_cd;
            rep.iss_name                := i.iss_name;
            rep.intm_type               := i.intm_type;
            rep.intm_no                 := i.intm_no;
            rep.intm_name               := i.intm_name;
            rep.agent_code              := i.agent_code;
            rep.cf_total                := CF_TOTAL(i.balance_amt_due, i.afterdate_collection);
            rep.afterdate_collection    := i.afterdate_collection;
            rep.balance_amt_due         := i.balance_amt_due;            
            
            PIPE ROW(rep);
        END LOOP;
    END GET_REPORT_DETAILS;
    
    
    FUNCTION GET_COLUMN_HEADER
        RETURN column_header_tab PIPELINED
    AS
        rep     column_header_type;
    BEGIN
        FOR i IN (SELECT DISTINCT COL_TITLE,COL_NO  
                    FROM GIAC_SOA_TITLE
                   WHERE REP_CD = 8
                   ORDER BY COL_NO )
        LOOP
            rep.col_no      := i.col_no;
            rep.col_title   := i.col_title;
            
            PIPE ROW(rep);
        END LOOP;
    END GET_COLUMN_HEADER;
    
    
    FUNCTION GET_COLUMN_DETAILS(
        p_branch_cd     GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        p_intm_type     GIAC_SOA_REP_EXT.INTM_TYPE%TYPE,
        p_intm_no       GIAC_SOA_REP_EXT.INTM_NO%TYPE,
        p_param_date    GIAC_SOA_REP_EXT.PARAM_DATE%TYPE,
        p_bal_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%TYPE,
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN column_details_tab PIPELINED
    AS
        rep             column_details_type;
        v_col_title     GIAC_SOA_REP_EXT.COLUMN_TITLE%type;
    BEGIN
        FOR i IN ( SELECT DISTINCT c.iss_name, a.iss_cd,   
                           UPPER(a.INTM_NAME) intm_name, a.intm_no, a.intm_type||'-'||to_char(a.intm_no) agent_code,
                           SUM(balance_amt_due) balance_amt_due,
                           --SUM(prem_bal_due),SUM(tax_bal_due)
                           --SUM(afterdate_prem)  afterdate_collection,
                           SUM(afterdate_coll)  afterdate_collection,   -- judyann 05042005
                           a.intm_type --issa
                      FROM giac_soa_rep_ext a, giis_intermediary b, giis_issource c
                     WHERE a.intm_no = b.intm_no 
                       AND a.USER_ID = UPPER(P_USER)
                       AND a.iss_cd = c.iss_cd
                       AND a.INTM_NO = NVL(P_INTM_NO,a.INTM_NO)
                       AND a.PARAM_DATE = NVL(P_PARAM_DATE, a.PARAM_DATE)
                       AND a.iss_cd = NVL (P_BRANCH_CD, a.iss_cd) --issa
                       AND a.intm_type = NVl (p_intm_type, a.intm_type) --issa
                    HAVING sum(a.balance_amt_due) >= nvl(P_BAL_AMT_DUE, sum(a.balance_amt_due)) --ryan112807
                       AND sum(a.balance_amt_due) <> 0 --ryan112807
                     GROUP BY a.iss_cd,a.intm_name, a.intm_no,a.intm_type, a.iss_cd, c.iss_name
                     ORDER BY a.iss_cd, a.intm_no)
        LOOP
            rep.iss_cd      := i.iss_cd;
            rep.iss_name    := i.iss_name;
            rep.intm_type   := i.intm_type;
            rep.intm_no     := i.intm_no;
            rep.intm_name   := i.intm_name;
            
            FOR j IN (SELECT DISTINCT COL_TITLE,COL_NO  
                        FROM GIAC_SOA_TITLE
                       WHERE REP_CD = 8
                       ORDER BY COL_NO)
            LOOP
                rep.col_no          := j.col_no;
                    
                FOR k IN ( SELECT intm_no,  
                                   column_title,
                                   SUM(balance_amt_due) intmbal,
                                   SUM(prem_bal_due) intmprem,
                                   SUM(tax_bal_due) intmtax,
                                   iss_cd, --issa
                                   intm_type --issa
                              FROM giac_soa_rep_ext
                             WHERE user_id = UPPER(p_user)  --issa, added the where condition to filter the correct data, 02.04.2005
                               AND iss_cd = NVL (i.iss_cd, iss_cd) --issa
                               AND intm_type = NVl (i.intm_type, intm_type) --issa
                               AND INTM_NO = NVL(i.INTM_NO, INTM_NO)
                               AND column_title = j.col_title
                             GROUP BY intm_no, column_title, iss_cd, intm_type)
                LOOP
                    rep.column_title    := k.column_title;
                    rep.intmbal         := k.intmbal;
                    rep.intmprem        := k.intmprem;
                    rep.intmtax         := k.intmtax;
                    
                    v_col_title         := k.column_title;
                    
                    PIPE ROW(rep);
                END LOOP;
                
                /* to retrieve other column titles needed for cross tab */
                IF j.col_title <> v_col_title OR v_col_title IS NULL THEN
                    rep.column_title    := j.col_title;
                    rep.intmbal         := null;
                    rep.intmprem        := null;
                    rep.intmtax         := null;
                    
                    PIPE ROW(rep);
                END IF;
                
            END LOOP;
        END LOOP;
    END GET_COLUMN_DETAILS;   
    
    
END GIACR190E_PKG;
/



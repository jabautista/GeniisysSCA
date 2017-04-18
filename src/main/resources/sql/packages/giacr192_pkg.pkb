CREATE OR REPLACE PACKAGE BODY CPI.GIACR192_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   06.05.2013
     ** Referenced By:  GIACR192 - Statement of Account (Assured Summary)
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        V_NAME VARCHAR2(200);
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
    
    
    FUNCTION CF_DATE_TAG1(
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
        DSP_NAME        VARCHAR2(300);
        V_AS_OF_DATE    date;
    BEGIN
        FOR C IN (SELECT DATE_TAG, FROM_DATE1, TO_DATE1, FROM_DATE2, TO_DATE2,as_of_date
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = P_USER
                     AND ROWNUM = 1)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1;
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;   
            V_AS_OF_DATE:=c.as_of_date;  
            EXIT;
        END LOOP;
        
        /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
        IF V_AS_OF_DATE is  not NULL THEN
  	        V_NAME1 := 'As of date '||TO_CHAR(V_AS_OF_DATE,'fmMonth DD, YYYY');
        ELSIF V_TAG = 'BK' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'IN' THEN
            V_NAME1 := 'Incept Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'IS' THEN
            V_NAME1 := 'Issue Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'BKIN' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := 'Incept Date from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
        ELSIF V_TAG = 'BKIS' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := 'Issue Date from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
        ELSE
            DSP_NAME := '(Unknown Basis of Extraction)';
        END IF;
         
        SELECT DECODE(V_NAME2,NULL,NULL,' and ') 
          INTO V_AND
          FROM DUAL;
 
        DSP_NAME := ('Based on '||V_NAME1);
        /*PASS THE SECOND NAME TO CF_DATE_TAG2
        VARIABLES.DSP_NAME2 := (V_AND||V_NAME2);*/

        RETURN (DSP_NAME); 
    END CF_DATE_TAG1;
    
    
    FUNCTION CF_DATE_TAG2(
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
        DSP_NAME        VARCHAR2(300);
        V_AS_OF_DATE    date;
    BEGIN
        FOR C IN (SELECT DATE_TAG, FROM_DATE1, TO_DATE1, FROM_DATE2, TO_DATE2,as_of_date
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = P_USER
                     AND ROWNUM = 1)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1;
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;   
            V_AS_OF_DATE:=c.as_of_date;  
            EXIT;
        END LOOP;
        
        /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
        IF V_AS_OF_DATE is  not NULL THEN
  	        NULL;
        ELSIF V_TAG = 'BK' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'IN' THEN
            V_NAME1 := 'Incept Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'IS' THEN
            V_NAME1 := 'Issue Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := NULL;
        ELSIF V_TAG = 'BKIN' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := 'Incept Date from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
        ELSIF V_TAG = 'BKIS' THEN
            V_NAME1 := 'Booking Date from '||TO_CHAR(V_FROM_DATE1,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE1,'fmMonth DD, YYYY');
            V_NAME2 := 'Issue Date from '||TO_CHAR(V_FROM_DATE2,'fmMonth DD, YYYY')||' to '||TO_CHAR(V_TO_DATE2,'fmMonth DD, YYYY');
        ELSE
            DSP_NAME := '(Unknown Basis of Extraction)';
        END IF;
        
        SELECT DECODE(V_NAME2,NULL,NULL,'and ') 
          INTO V_AND
          FROM DUAL;
 
        DSP_NAME := (V_AND||V_NAME2);
    
        RETURN (DSP_NAME);
    END CF_DATE_TAG2;
    
    
    PROCEDURE BEFOREREPORT
    AS
    BEGIN
        SELECT GET_REP_DATE_FORMAT
          INTO GIACR192_PKG.CP_DATE_FORMAT
          FROM dual;
    END BEFOREREPORT;
    
    
    FUNCTION GET_REPORT_HEADER (
        p_user      GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN report_header_tab PIPELINED
    AS
        rep             report_header_type;
        v_from_to       VARCHAR2(1);
        v_ref_date      VARCHAR2(1);
    BEGIN
        BEFOREREPORT;
        
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.print_company       := giacp.v('SOA_HEADER');
        rep.rundate             := TO_CHAR(SYSDATE, GIACR192_PKG.CP_DATE_FORMAT);
        rep.cf_title            := CF_TITLE;
        rep.cf_date_label       := CF_DATE_LABEL;
        rep.cf_date             := CF_DATE(p_user);
        rep.cf_date_tag1        := CF_DATE_TAG1(p_user);
        rep.cf_date_tag2        := CF_DATE_TAG2(p_user);
        rep.print_date_tag      := giacp.v('SOA_FROM_TO');
        rep.print_user          := giacp.v('SOA_USER_ID');
        
        -- CF_DATE_TAG1 and CF_DATE_TAG2 format trigger (in page footer) 
        BEGIN
            v_from_to  := giacp.v('SOA_FROM_TO'); 
            v_ref_date := giacp.v('SOA_REF_DATE');

            IF v_from_to = 'N'  THEN
                IF v_ref_date = 'Y' THEN     
                    rep.print_footer_date   := 'Y';
                ELSE
                    rep.print_footer_date   := 'N';
                END IF;
             ELSE
                    rep.print_footer_date   := 'N';
            END IF;    	
        END;
        
        PIPE ROW(rep);
    END GET_REPORT_HEADER; 
    

    FUNCTION CF_BRANCH_NAME(
        p_branch_cd     GIAC_SOA_REP_EXT.BRANCH_CD%TYPE
    ) RETURN VARCHAR2
    AS        
    BEGIN
        FOR i IN (SELECT BRANCH_NAME
                    FROM GIAC_BRANCHES
                   WHERE BRANCH_CD = P_BRANCH_CD)
        LOOP
            RETURN(i.BRANCH_NAME); 
        END LOOP;
    END CF_BRANCH_NAME;
    
    
    FUNCTION get_report_details (
       p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
       p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
       p_inc_overdue   VARCHAR2,
       p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
       p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
       p_user          giac_soa_rep_ext.user_id%TYPE
    )
       RETURN report_details_tab PIPELINED
    AS
       rep                   report_details_type;
       v_pvv                 VARCHAR2 (1);
       v_col_title           giac_soa_rep_ext.column_title%TYPE;
       v_count               NUMBER (10)                           := 0;
       v_title_tab           title_tab;
       v_index               NUMBER                               := 0;
       v_id                  NUMBER                               := 0;
       v_no_of_col_allowed   NUMBER                               := 5;
       v_exist               VARCHAR2(1) := 'N';
    BEGIN
       /* BRANCH_TOTALS format trigger */
       BEGIN
          FOR i IN (SELECT param_value_v
                      FROM giac_parameters
                     WHERE param_name LIKE 'SOA_BRANCH_TOTALS')
          LOOP
             v_pvv := i.param_value_v;
          END LOOP;

          IF v_pvv LIKE 'Y'
          THEN
             rep.print_branch_totals := 'Y';
          ELSE
             rep.print_branch_totals := 'N';
          END IF;
       END;

       /*FOR i IN
          (
       /* modified by judyann 04032013
        ** omitted column and filter for intm type since the report is for assured
        * /
           SELECT DISTINCT branch_cd,intm_type, -- jenny vi lim 01062005
                                     LTRIM (UPPER (assd_name)) assd_name, assd_no,
                           SUM (balance_amt_due) sum_balance_amt_due,
                           SUM (prem_bal_due) sum_prem_bal_due,
                           SUM (tax_bal_due) sum_tax_bal_due
                      FROM giac_soa_rep_ext
                     WHERE user_id = UPPER (p_user)
                       AND branch_cd = NVL (p_branch_cd, branch_cd)
                       AND intm_type = nvl(p_intm_type, intm_type) -- jenny vi lim 01062005
                       AND assd_no = NVL (p_assd_no, assd_no)
                       AND due_tag =
                                    DECODE (p_inc_overdue,
                                            'I', due_tag,
                                            'N', 'Y'
                                           )
                    --replace the condition <>0 in order to filter through :p_bal_amt_due
                    --benidex 12/6/2007
           HAVING          SUM (balance_amt_due) >=
                                                   NVL (p_bal_amt_due,
                                                        -2147483647)
                  GROUP BY branch_cd, assd_name, assd_no, intm_type
                  ORDER BY 1, LTRIM (UPPER (assd_name)))
       LOOP
          v_id := 0;
          v_index := 0;
          v_title_tab := title_tab ();

          FOR t IN (SELECT DISTINCT col_title, col_no
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
             rep.branch_cd := NULL;
             rep.branch_name := NULL;
             rep.assd_no := NULL;
             rep.assd_name := NULL;
             rep.sum_balance_amt_due := NULL;
             rep.sum_prem_bal_due := NULL;
             rep.sum_tax_bal_due := NULL;
             
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
             
             rep.branch_cd := i.branch_cd;
             rep.branch_name := cf_branch_name (i.branch_cd);
             rep.assd_no := i.assd_no;
             rep.assd_name := i.assd_name;
             rep.sum_balance_amt_due := i.sum_balance_amt_due;
             rep.sum_prem_bal_due := i.sum_prem_bal_due;
             rep.sum_tax_bal_due := i.sum_tax_bal_due;
             v_count := 1;
             rep.branch_cd_dummy := rep.branch_cd || '_' || v_id;

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

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
          END LOOP;
       END LOOP;*/ -- replaced with codes below (moved the query for dynamic column in get_column_header()) : shan 03.04.2015
       
       FOR i IN
          (
       /* modified by judyann 04032013
        ** omitted column and filter for intm type since the report is for assured
        */
           SELECT DISTINCT branch_cd,intm_type, -- jenny vi lim 01062005
                                     LTRIM (UPPER (assd_name)) assd_name, assd_no,
                           SUM (balance_amt_due) sum_balance_amt_due,
                           SUM (prem_bal_due) sum_prem_bal_due,
                           SUM (tax_bal_due) sum_tax_bal_due
                      FROM giac_soa_rep_ext
                     WHERE user_id = UPPER (p_user)
                       AND branch_cd = NVL (p_branch_cd, branch_cd)
                       AND intm_type = nvl(p_intm_type, intm_type) -- jenny vi lim 01062005
                       AND assd_no = NVL (p_assd_no, assd_no)
                       AND due_tag =
                                    DECODE (p_inc_overdue,
                                            'I', due_tag,
                                            'N', 'Y'
                                           )
                    --replace the condition <>0 in order to filter through :p_bal_amt_due
                    --benidex 12/6/2007
           HAVING          SUM (balance_amt_due) >=
                                                   NVL (p_bal_amt_due,
                                                        -2147483647)
                  GROUP BY branch_cd, assd_name, assd_no, intm_type
                  ORDER BY 1, LTRIM (UPPER (assd_name)))
       LOOP
            rep.branch_cd := NULL;
            rep.branch_name := NULL;
            rep.assd_no := NULL;
            rep.assd_name := NULL;
            rep.sum_balance_amt_due := NULL;
            rep.sum_prem_bal_due := NULL;
            rep.sum_tax_bal_due := NULL;
                         
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
         
          FOR j IN (SELECT *
                    FROM TABLE(GIACR192_PKG.GET_COLUMN_HEADER))
          LOOP
             rep.branch_cd := i.branch_cd;
             rep.branch_name := cf_branch_name (i.branch_cd);
             rep.assd_no := i.assd_no;
             rep.assd_name := i.assd_name;
             rep.sum_balance_amt_due := i.sum_balance_amt_due;
             rep.sum_prem_bal_due := i.sum_prem_bal_due;
             rep.sum_tax_bal_due := i.sum_tax_bal_due;
             v_count := v_count + 1;
             rep.branch_cd_dummy := rep.branch_cd || '_' || j.dummy;
             rep.dummy  := j.dummy;
             
             rep.no_of_dummy := j.no_of_dummy;
             rep.col_title1 := j.col_title1;
             rep.col_no1 := j.col_no1;
             rep.col_title2 := j.col_title2;
             rep.col_no2 := j.col_no2;
             rep.col_title3 := j.col_title3;
             rep.col_no3 := j.col_no3;
             rep.col_title4 := j.col_title4;
             rep.col_no4 := j.col_no4;
             rep.col_title5 := j.col_title5;
             rep.col_no5 := j.col_no5;
             
            IF j.col_no1 IS NOT NULL THEN
                rep.intmbal1 := 0;
                rep.intmprem1 := 0;
                rep.intmtax1 := 0;
            ELSE
                rep.intmbal1 := NULL;
                rep.intmprem1 := NULL;
                rep.intmtax1 := NULL;
            END IF;
            
            IF j.col_no2 IS NOT NULL THEN
                rep.intmbal2 := 0;
                rep.intmprem2 := 0;
                rep.intmtax2 := 0;
            ELSE
                rep.intmbal2 := NULL;
                rep.intmprem2 := NULL;
                rep.intmtax2 := NULL;
            END IF;
            
            IF j.col_no3 IS NOT NULL THEN
                rep.intmbal3 := 0;
                rep.intmprem3 := 0;
                rep.intmtax3 := 0;
            ELSE
                rep.intmbal3 := NULL;
                rep.intmprem3 := NULL;
                rep.intmtax3 := NULL;
            END IF;
            
            IF j.col_no4 IS NOT NULL THEN
                rep.intmbal4 := 0;
                rep.intmprem4 := 0;
                rep.intmtax4 := 0;
            ELSE
                rep.intmbal4 := NULL;
                rep.intmprem4 := NULL;
                rep.intmtax4 := NULL;
            END IF;
            
            IF j.col_no5 IS NOT NULL THEN
                rep.intmbal5 := 0;
                rep.intmprem5 := 0;
                rep.intmtax5 := 0;
            ELSE
                rep.intmbal5 := NULL;
                rep.intmprem5 := NULL;
                rep.intmtax5 := NULL;
            END IF;
                            
            v_exist := 'N';
                                
            FOR k IN (SELECT  branch_cd, UPPER (assd_name) assd_name, assd_no,
                              intm_type,                     -- jenny vi lim 01062005
                                        column_no,column_title, SUM (balance_amt_due) intmbal,
                              SUM (prem_bal_due) intmprem, SUM (tax_bal_due) intmtax
                         FROM giac_soa_rep_ext
                        WHERE user_id = UPPER (p_user)
                          --AND column_no = p_column_no
                          AND column_no IN (j.col_no1, j.col_no2, j.col_no3, j.col_no4, j.col_no5)
                          AND branch_cd = i.branch_cd --NVL (p_branch_cd, branch_cd)
                          AND intm_type = i.intm_type --NVL (p_intm_type, intm_type)
                          -- jenny vi lim 01062005
                          AND assd_no = i.assd_no --NVL (p_assd_no, assd_no)
                          AND due_tag = DECODE (p_inc_overdue,
                                                'I', due_tag,
                                                'N', 'Y'
                                               )
                       HAVING SUM (balance_amt_due) <> 0
                     GROUP BY branch_cd, assd_name, assd_no, column_no, column_title, intm_type
                     ORDER BY branch_cd, assd_no, column_no)
            LOOP
                v_count := v_count + 1;
                v_exist := 'Y';
                
                IF j.col_no1 = k.column_no /*v_count = 1*/ THEN
                    rep.intmbal1 := NVL(k.intmbal,0);
                    rep.intmprem1 := NVL(k.intmprem,0);
                    rep.intmtax1 := NVL(k.intmtax,0);
                ELSIF j.col_no2 = k.column_no /*v_count = 2*/ THEN
                    rep.intmbal2 := NVL(k.intmbal,0);
                    rep.intmprem2 := NVL(k.intmprem,0);
                    rep.intmtax2 := NVL(k.intmtax,0);
                ELSIF j.col_no3 = k.column_no /*v_count = 3*/ THEN
                    rep.intmbal3 := NVL(k.intmbal,0);
                    rep.intmprem3 := NVL(k.intmprem,0);
                    rep.intmtax3 := NVL(k.intmtax,0);
                ELSIF j.col_no4 = k.column_no /*v_count = 4*/ THEN
                    rep.intmbal4 := NVL(k.intmbal,0);
                    rep.intmprem4 := NVL(k.intmprem,0);
                    rep.intmtax4 := NVL(k.intmtax,0);
                ELSIF j.col_no5 = k.column_no /*v_count = 5*/ THEN
                    rep.intmbal5 := NVL(k.intmbal,0);
                    rep.intmprem5 := NVL(k.intmprem,0);
                    rep.intmtax5 := NVL(k.intmtax,0);
                /*ELSE
                    v_count := v_count - 5;*/
                END IF;
                                
                PIPE ROW (rep);
            END LOOP;        
                            
            IF v_exist = 'N' THEN
                PIPE ROW(rep);
            END IF;
             
             --PIPE ROW(rep);
          END LOOP;
        END LOOP;      
    END get_report_details;
    
    
    FUNCTION GET_COLUMN_HEADER
        RETURN column_header_tab PIPELINED
    AS
        rep     column_header_type;
        v_no_of_col_allowed     NUMBER := 5;
        v_dummy     NUMBER := 0;
        v_count     NUMBER := 0;
        v_title_tab     title_tab;
        v_index     NUMBER := 0;
        v_id        NUMBER := 0;
    BEGIN
        /*FOR i IN (SELECT DISTINCT COL_TITLE, COL_NO   
                    FROM GIAC_SOA_TITLE 
                   WHERE rep_cd = 1 --issa
                   ORDER BY COL_NO)
        LOOP
            rep.col_no      := i.col_no;
            rep.col_title   := i.col_title;
            
            PIPE ROW(rep);
        END LOOP;*/ -- replaced with codes below : 03.04.2015
        
        -- for column matrix
        v_title_tab := title_tab ();

        FOR t IN (SELECT DISTINCT col_title, col_no
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

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
        END LOOP;
         
    END GET_COLUMN_HEADER;
    
    FUNCTION get_column_details (
       p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
       p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
       p_inc_overdue   VARCHAR2,
       p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
       p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
       p_user          giac_soa_rep_ext.user_id%TYPE,
       p_column_no     giac_soa_rep_ext.column_no%TYPE
    )
       RETURN column_details_tab PIPELINED
    AS
       rep   column_details_type;
       v_exist VARCHAR2(1) := 'N';
    BEGIN
       FOR i IN (SELECT   branch_cd, UPPER (assd_name) assd_name, assd_no,
                          intm_type,                     -- jenny vi lim 01062005
                                    column_no,column_title, SUM (balance_amt_due) intmbal,
                          SUM (prem_bal_due) intmprem, SUM (tax_bal_due) intmtax
                     FROM giac_soa_rep_ext
                    WHERE user_id = UPPER (p_user)
                      AND column_no = p_column_no
                      AND branch_cd = NVL (p_branch_cd, branch_cd)
                      AND intm_type = NVL (p_intm_type, intm_type)
                      -- jenny vi lim 01062005
                      AND assd_no = NVL (p_assd_no, assd_no)
                      AND due_tag = DECODE (p_inc_overdue,
                                            'I', due_tag,
                                            'N', 'Y'
                                           )
                   HAVING SUM (balance_amt_due) <> 0
                 GROUP BY branch_cd, assd_name, assd_no, column_no, column_title, intm_type)
       LOOP
          v_exist := 'Y';
          rep.branch_cd := i.branch_cd;
          rep.assd_no := i.assd_no;
          rep.assd_name := i.assd_name;
          rep.col_no := i.column_no;
          rep.column_title := i.column_title;
          rep.intmbal := NVL(i.intmbal,0);
          rep.intmprem := NVL(i.intmprem,0);
          rep.intmtax := NVL(i.intmtax,0);
          PIPE ROW (rep);
       END LOOP;
       
       IF v_exist = 'N' AND p_assd_no IS NOT NULL THEN
          rep.intmbal := 0;
          PIPE ROW (rep);
       END IF;
    END get_column_details;
    
    FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
                   WHERE owner = 'CPI'
                      AND package_name = 'CSV_SOA'
                      AND object_name = 'CSV_GIACR192'
                      AND in_out = 'OUT'
                      AND argument_name IS NOT NULL
               ORDER BY position)
      LOOP
         v_list.col_name := i.argument_name;
         
         IF(SUBSTR(i.argument_name, 0, 6) = 'COL_NO') THEN
            v_list.col_name := csv_soa.get_col_title(SUBSTR(i.argument_name, 7));
         END IF;
         
         IF v_list.col_name IS NULL THEN
            v_list.col_name := i.argument_name;
         END IF;
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;
    
    
END GIACR192_PKG;
/



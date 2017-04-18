CREATE OR REPLACE PACKAGE BODY CPI.GIACR193A_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.30.2013
     ** Referenced By:  GIACR193A - Statement of Account - Intm(AUI) Tax Breakdown 
     **/
    
    PROCEDURE BEFOREREPORT
    AS  
    BEGIN
        SELECT GET_REP_DATE_FORMAT
          INTO GIACR193A_PKG.rep_date_format
          FROM DUAL;
    END BEFOREREPORT;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_co_name   GIAC_PARAMETERS.param_value_v%type;
        v_co_exists BOOLEAN := FALSE;
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_co_name := c.param_value_v;
            v_co_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_co_exists = TRUE THEN
            RETURN(v_co_name);
        ELSE 
            v_co_name := 'Company name not available in GIAC_PARAMETERS.';
            RETURN(v_co_name);
        END IF;
        
        RETURN NULL;
    END CF_COMPANY_NAME;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_co_add    GIAC_PARAMETERS.param_value_v%type;
        v_co_exists BOOLEAN := FALSE;
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'COMPANY_ADDRESS')
        LOOP
            v_co_add := c.param_value_v;
            v_co_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_co_exists = TRUE THEN
            RETURN(v_co_add);
        ELSE 
            v_co_add := 'Company address not available in GIAC_PARAMETERS.';
            RETURN(v_co_add);
        END IF;
        
        RETURN NULL;
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
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN DATE
    AS
        V_DATE DATE;
    BEGIN
        FOR C IN (SELECT PARAM_DATE
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = p_user_id
                     AND ROWNUM = 1)
        LOOP
            V_DATE := C.PARAM_DATE;
            EXIT;
        END LOOP;
  
        IF V_DATE IS NULL THEN
            V_DATE := SYSDATE;
        END IF;
        
        RETURN(V_DATE);
    END CF_DATE;
    
        
    FUNCTION CF_DATE_TAG1(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
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
        FOR C IN (SELECT DATE_TAG, FROM_DATE1, TO_DATE1, FROM_DATE2, TO_DATE2, as_of_date
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = p_user_id
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
        elsIF V_TAG = 'BK' THEN
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
        /*PASS THE SECOND NAME TO CF_DATE_TAG2*/
        --VARIABLES.DSP_NAME2 := (V_AND||V_NAME2);

        RETURN (DSP_NAME);
    END CF_DATE_TAG1;
    
       
    FUNCTION CF_DATE_TAG2(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
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
        V_as_of_date    date;
    BEGIN
        FOR C IN (SELECT DATE_TAG, FROM_DATE1, TO_DATE1, FROM_DATE2, TO_DATE2,as_of_date
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = p_user_id
                     AND ROWNUM = 1)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1;
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;  
            V_as_of_date:=c.as_of_date; 
            EXIT;
        END LOOP;
        
        if V_as_of_date is not null then
            null;
        elsIF V_TAG = 'BK' THEN
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
     
        
    FUNCTION GET_REPORT_HEADER(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN report_header_tab PIPELINED
    AS
        rep             report_header_type;
        v_print_user    varchar2(1);
        v_from_to       VARCHAR2(1);
        v_ref_date      VARCHAR2(1);
    BEGIN
        BEFOREREPORT();
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        rep.print_company   := giacp.v('SOA_HEADER');        
        rep.title           := CF_TITLE;
        rep.date_label      := CF_DATE_LABEL;
        rep.paramdate       := CF_DATE(p_user_id);
        rep.date_tag1       := CF_DATE_TAG1(p_user_id);
        rep.date_tag2       := CF_DATE_TAG2(p_user_id);
        rep.print_date_tag  := giacp.v('SOA_FROM_TO');
        rep.rundate         := TO_CHAR(SYSDATE, GIACR193A_PKG.rep_date_format);
        
        --F_USER_ID format trigger
        v_print_user  := giacp.v('SOA_USER_ID'); 

        IF v_print_user = 'Y'  THEN
            --     RETURN(TRUE);              /*commented out by carla 010208 to hide username displayed on bottom of last page*/
        --   ELSE
            rep.print_user_id   := 'N';
        END IF;   
        
        
        --CF_DATE_TAG1 and CF_DATE_TAG3 (page footer) format trigger
        v_from_to  := giacp.v('SOA_FROM_TO'); 
        v_ref_date := giacp.v('SOA_REF_DATE');

        IF v_from_to = 'N'  THEN
            IF v_ref_date = 'Y' THEN     
                rep.print_footer_date := 'Y';
            ELSE
                 rep.print_footer_date := 'N';
            END IF;
        ELSE
            rep.print_footer_date := 'N';
        END IF;  
        
        PIPE ROW(rep);
    END GET_REPORT_HEADER;


    ----------------------------------    
    FUNCTION CF_LABEL
        RETURN VARCHAR2
    AS
        v_label   VARCHAR2(100);
    BEGIN
        FOR I IN (SELECT label
                    FROM giac_rep_signatory 
                   WHERE report_id = 'GIACR193A'
                   ORDER BY item_no)
        LOOP
            v_label := i.label;
            EXIT;
        END LOOP;

        RETURN(v_label);
    END CF_LABEL;
        
        
    FUNCTION CF_SIGNATORY
        RETURN VARCHAR2
    AS
        v_signatory   VARCHAR2(100);
    BEGIN
        FOR I IN (SELECT signatory 
                    FROM giac_rep_signatory a, giis_signatory_names b
                   WHERE a.signatory_id = b.signatory_id
                     AND report_id = 'GIACR193A'
                   ORDER BY item_no)
        LOOP
            v_signatory := i.signatory;
            EXIT;
        END LOOP;

        RETURN(v_signatory);
    END CF_SIGNATORY;
        
        
    FUNCTION CF_DESIGNATION
        RETURN VARCHAR2
    AS
        v_designation   VARCHAR2(100);
    BEGIN
        FOR I IN (SELECT designation 
                    FROM giac_rep_signatory a, giis_signatory_names b
                   WHERE a.signatory_id = b.signatory_id
                     AND report_id = 'GIACR193A'
                   ORDER BY item_no)
        LOOP
            v_designation := i.designation;
            EXIT;
        END LOOP;

        RETURN(v_designation);
    END CF_DESIGNATION;
    
    
    FUNCTION CF_BRANCH_NAME (
        p_branch_cd     GIAC_BRANCHES.BRANCH_CD%TYPE
    ) RETURN VARCHAR2
    AS
        v_branch_nm     GIAC_BRANCHES.branch_name%type;
        v_branch_exists BOOLEAN := FALSE;
    BEGIN
        FOR c IN (SELECT branch_name
                    FROM giac_branches
                  WHERE branch_cd = p_branch_cd)
        LOOP
            v_branch_nm := c.branch_name;
            v_branch_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_branch_exists = TRUE THEN
            RETURN(v_branch_nm);
        ELSE
            v_branch_nm := 'Branch code '||p_branch_cd||' does not exists in GIAC_BRANCHES';
            RETURN(v_branch_nm);
        END IF;
        
        RETURN NULL;
    END CF_BRANCH_NAME;
    
    
    FUNCTION CF_INTM_DESC (
        p_intm_type     GIIS_INTM_TYPE.INTM_TYPE%TYPE
    ) RETURN VARCHAR2
    AS
        v_intm_type_desc    GIIS_INTM_TYPE.intm_desc%type;
        v_intm_type_exists  BOOLEAN := FALSE;
    BEGIN
        FOR c IN (SELECT intm_desc
                    FROM giis_intm_type
                   WHERE intm_type = p_intm_type)
        LOOP
            v_intm_type_desc := c.intm_desc;
            v_intm_type_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_intm_type_exists = TRUE THEN
            RETURN(v_intm_type_desc);
        ELSE
            --v_intm_type_desc := 'Branch code '||:branch_cd||' does not exists in GIAC_BRANCHES'; commented out by reymon
            v_intm_type_desc := 'Intermediary type '||p_intm_type||' does not exists';
            RETURN(v_intm_type_desc);
        END IF;
        
        RETURN NULL;
    END CF_INTM_DESC;
    
    
    FUNCTION CF_INTM_ADD(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%TYPE
    ) RETURN VARCHAR2
    AS
        V_INTM_ADD VARCHAR2(250);
        V_BM       VARCHAR2(5);
    BEGIN
        FOR C1 IN (SELECT DECODE( SIGN(3-NVL(LENGTH(BILL_ADDR1||BILL_ADDR2||BILL_ADDR3), 0)), 1, 'MAIL',-1,'BILL','MAIL') ADDR
                     FROM GIIS_INTERMEDIARY
                    WHERE INTM_NO = P_INTM_NO) 
        LOOP
            V_BM := C1.ADDR;
            EXIT;
        END LOOP;
        
        IF (V_BM = 'MAIL' OR V_BM IS NULL) THEN
            SELECT MAIL_ADDR1||DECODE(MAIL_ADDR2,NULL,'',' ')||MAIL_ADDR2||DECODE(MAIL_ADDR3,NULL,'',' ')||MAIL_ADDR3
              INTO V_INTM_ADD
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO = P_INTM_NO;
            RETURN(V_INTM_ADD);
        ELSIF V_BM = 'BILL' THEN
            SELECT BILL_ADDR1||DECODE(BILL_ADDR2,NULL,'',' ')||BILL_ADDR2||DECODE(BILL_ADDR3,NULL,'',' ')||BILL_ADDR3
              INTO V_INTM_ADD
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO = P_INTM_NO;
            RETURN(V_INTM_ADD);
        ELSE
            V_INTM_ADD := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            RETURN(V_INTM_ADD);
        END IF;
        
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_INTM_ADD := 'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
            RETURN(V_INTM_ADD);
        WHEN TOO_MANY_ROWS THEN
            V_INTM_ADD := 'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
            RETURN(V_INTM_ADD);
    END CF_INTM_ADD;
    
    
    FUNCTION CF_LINE_NAME(
        p_line_cd       GIIS_LINE.LINE_CD%TYPE
    ) RETURN VARCHAR2
    AS
        v_line_nm       GIIS_LINE.line_name%type;
        v_line_exists   BOOLEAN := FALSE;
    BEGIN
        FOR c IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = p_line_cd)
        LOOP
            v_line_nm := c.line_name;
            v_line_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_line_exists = TRUE THEN
            RETURN(v_line_nm);
        ELSE
            v_line_nm := 'Line code '||p_line_cd||' does not exist in GIIS_LINE.';
            RETURN(v_line_nm);
        END IF;
        
        RETURN NULL;
    END CF_LINE_NAME;
    
    
    /**  Q_1  **/
    FUNCTION GET_REPORT_PARENT_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN report_parent_tab PIPELINED
    AS  
        rep     report_parent_type;
    BEGIN
        BEFOREREPORT();  --get report date format
        
        rep.label           := CF_LABEL;
        rep.signatory       := CF_SIGNATORY;
        rep.designation     := CF_DESIGNATION;
        rep.print_signatory := giacp.v('SOA_SIGNATORY');
        
        --M_3 format trigger
        FOR i IN (SELECT param_value_v
                      FROM giac_parameters
                     WHERE param_name LIKE 'SOA_BRANCH_TOTALS')
        LOOP
              rep.print_branch_totals := i.param_value_v;
        END LOOP; 
        
        FOR i IN  (--PAU 18MAY09 ADDED OPTIMIZER HINTS
                    SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           UPPER (a.intm_name) intm_name, a.intm_no, a.intm_type, -- jenny vi lim 01062005
                           get_ref_intm_cd (a.intm_no) ref_intm_cd, a.intm_type intm_type1,
                           SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd,
                           a.column_title, a.assd_no, a.assd_name, a.prem_bal_due,
                           a.tax_bal_due, a.balance_amt_due, a.policy_no,
                           -- a.iss_cd||'-'||a.prem_seq_no||'-'||a.inst_no bill_no, belle 10292010
                           --c.iss_cd || '-' || c.prem_seq_no || '-' || a.inst_no bill_no, --belle 10292010 commented out by reymon
                           a.iss_cd || '-' || TO_CHAR(a.prem_seq_no,'FM099999999999') || '-' || TO_CHAR(a.inst_no, 'FM09') bill_no, --added by reymon
                           a.incept_date, a.due_date, a.no_of_days, a.ref_pol_no, a.branch_cd, --b.col_no, belle 10292010
                           a.column_no,
                           a.iss_cd, a.prem_seq_no, a.inst_no, a.user_id --added by reymon
                           /**SUM(DECODE(c.tax_cd, 8, c.tax_bal_due, 0)) doc_stamps,
                           SUM(DECODE(c.tax_cd, 9, c.tax_bal_due, 0)) LGT,
                           SUM(DECODE(c.tax_cd, 10, c.tax_bal_due, 0)) FST,
                           SUM(DECODE(c.tax_cd, 1, c.tax_bal_due, 0)) + SUM(DECODE(c.tax_cd, 2, c.tax_bal_due, 0)) "PTAX/EVAT",
                           SUM(DECODE(c.tax_cd, 3, c.tax_bal_due, 0)) +
                           SUM(DECODE(c.tax_cd, 4, c.tax_bal_due, 0)) +
                           SUM(DECODE(c.tax_cd, 5, c.tax_bal_due, 0)) +
                           SUM(DECODE(c.tax_cd, 6, c.tax_bal_due, 0)) +
                           SUM(DECODE(c.tax_cd, 7, c.tax_bal_due, 0)) "OTHER TAXES"  **/   --belle 10292010
                          -----start belle 10292010
                          /*
                          ** Commented out by reymon
                          SUM (DECODE (c.tax_cd, giacp.n ('DOC_STAMPS'), c.tax_bal_due, 0)
                              ) doc_stamps,
                          SUM (DECODE (c.tax_cd, giacp.n ('LGT'), c.tax_bal_due, 0)) lgt,
                          SUM (DECODE (c.tax_cd, giacp.n ('FST'), c.tax_bal_due, 0)) fst,
                          SUM (DECODE (c.tax_cd, giacp.n ('EVAT'), c.tax_bal_due, 0))
                             + SUM (DECODE (c.tax_cd, giacp.n ('PREM_TAX'), c.tax_bal_due, 0)) PTAX/EVAT",
                          SUM (DECODE (c.tax_cd, giacp.n ('DOC_STAMPS'), 0,
                                                 giacp.n ('LGT'), 0,
                                                 giacp.n ('FST'), 0,
                                                 giacp.n ('EVAT'), 0,
                                                 giacp.n ('PREM_TAX'), 0,
                                                 c.tax_bal_due ) ) "OTHER TAXES"
                          ------end belle 10292010
                           */
                      FROM giac_soa_rep_ext a
                           --giac_soa_rep_tax_ext c commented out by reymon
                           --,GIAC_SOA_TITLE B commented by belle 10292010
                     WHERE 1 = 1
                       /* Commented out by reymon
                       AND a.iss_cd = c.iss_cd
                       AND a.prem_seq_no = c.prem_seq_no
                       AND a.inst_no = c.inst_no
                       AND a.user_id = c.user_id
                       */
                       --AND a.column_no= b.col_no belle 10292010
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')     -- jenny vi lim 01062005
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     /* Commented out by reymon
                     GROUP BY a.intm_name, a.intm_no, get_ref_intm_cd (a.intm_no), a.intm_type,
                              SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1),
                              a.column_title, a.assd_no, a.assd_name, a.prem_bal_due,
                              a.tax_bal_due, a.balance_amt_due, a.policy_no, a.inst_no,
                              --a.iss_cd||'-'||a.prem_seq_no||'-'||a.inst_no, belle 10292010
                              c.iss_cd || '-' || c.prem_seq_no || '-' || a.inst_no, --belle 10292010
                              a.due_date, a.incept_date, a.no_of_days, a.ref_pol_no,
                              a.branch_cd, --b.col_no belle 10292010
                              a.column_no  -- belle 10292010
                     */
                     ORDER BY a.branch_cd, a.intm_type, a.intm_no, a.column_no, --a.column_title desc, 
                              SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) )
        LOOP
            rep.branch_cd           := i.branch_cd;
            rep.cf_branch_name      := CF_BRANCH_NAME(i.branch_cd);
            rep.incept_date         := TO_CHAR(i.incept_date, GIACR193A_PKG.rep_date_format);
            rep.intm_type           := i.intm_type;
            rep.cf_intm_desc        := CF_INTM_DESC(i.intm_type);
            rep.cf_intm_add         := CF_INTM_ADD(i.intm_no);
            rep.ref_intm_cd         := i.ref_intm_cd;
            rep.intm_name           := i.intm_name;
            rep.intm_no             := i.intm_no;
            rep.column_title        := i.column_title;
            rep.line_cd             := i.line_cd;
            rep.cf_line_name        := CF_LINE_NAME(i.line_cd);
            rep.column_no           := i.column_no;
            rep.policy_no           := i.policy_no;
            rep.bill_no             := i.bill_no;
            rep.ref_pol_no          := i.ref_pol_no;
            rep.no_of_days          := i.no_of_days;
            rep.assd_name           := i.assd_name;
            rep.assd_no             := i.assd_no;
            rep.due_date            := TO_CHAR(i.due_date, GIACR193A_PKG.rep_date_format);
            rep.prem_bal_due        := i.prem_bal_due;
            rep.tax_bal_due         := i.tax_bal_due;
            rep.balance_amt_due     := i.balance_amt_due;
            rep.iss_cd              := i.iss_cd;
            rep.prem_seq_no         := i.prem_seq_no;
            rep.inst_no             := i.inst_no;
            rep.user_id             := i.user_id;
            
            PIPE ROW(rep);
        END LOOP;
    END GET_REPORT_PARENT_DETAILS;
    
    
    --------------------------------------------
    /**  Q_20  **/
    FUNCTION GET_TAX_HEADER 
        RETURN tax_header_tab PIPELINED
    AS
        rep     tax_header_type;
    BEGIN
        FOR i IN (SELECT tax_cd, DECODE(SIGN(LENGTH(tax_name) - 17), 1, INITCAP(tax_name), '                '||INITCAP(tax_name)) tax_name
                    FROM giac_taxes
                   WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                    giacp.n ('LGT'),
                                    giacp.n ('FST'),
                                    giacp.n ('EVAT'),
                                    giacp.n ('PREM_TAX'))
                   UNION
                  SELECT 99, '                Other Taxes'
                    FROM DUAL)
        LOOP
            rep.tax_cd      := i.tax_cd;
            rep.tax_name    := i.tax_name;
            
            PIPE ROW(rep);
        END LOOP;
    END GET_TAX_HEADER;
    
    
    -----------------------------
    /**  Q_2, Q_3, and Q_4  **/
    FUNCTION GET_REPORT_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type,
        p_line_cd       giis_line.LINE_CD%type,
        p_iss_cd        giac_soa_rep_ext.ISS_CD%type,
        p_prem_seq_no   giac_soa_rep_ext.PREM_SEQ_NO%type,
        p_inst_no       giac_soa_rep_ext.INST_NO%type        
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /* Q_2 * /
        FOR i IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                           a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                           SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd,
                           a.iss_cd, a.prem_seq_no, a.inst_no, a.user_id
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                       AND a.COLUMN_TITLE = p_column_title
                       AND SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) = p_line_cd
                       AND a.ISS_CD = p_iss_cd
                       AND a.PREM_SEQ_NO = p_prem_seq_no
                       AND a.INST_NO = p_inst_no
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := i.branch_cd;
            rep.intm_type       := i.intm_type;
            rep.intm_no         := i.intm_no;
            rep.column_title    := i.column_title;
            rep.line_cd         := i.line_cd;
            rep.iss_cd          := i.iss_cd;
            rep.prem_seq_no     := i.prem_seq_no;
            rep.inst_no         := i.inst_no;
            rep.user_id         := i.user_id;
            
            /* Q_3 * /
            FOR j IN ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                    
                PIPE ROW(rep);      --pipe row to retrieve tax_name
                
                /* Q_4 * /
                IF j.tax_cd = 99 THEN
                    FOR k IN (SELECT iss_cd, prem_seq_no, inst_no,
                                       DECODE (tax_cd,  giacp.n ('DOC_STAMPS'), tax_cd,
                                                        giacp.n ('LGT'), tax_cd,
                                                        giacp.n ('FST'), tax_cd,
                                                        giacp.n ('EVAT'), tax_cd,
                                                        giacp.n ('PREM_TAX'), tax_cd,
                                                        99 ) tax_cd,
                                       user_id, SUM (tax_bal_due) tax_bal_due
                                  FROM giac_soa_rep_tax_ext
                                 WHERE iss_cd = i.iss_cd
                                   AND prem_seq_no = i.prem_seq_no
                                   AND inst_no = i.inst_no
                                   AND user_id = i.user_id
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX')) 
                                 GROUP BY iss_cd, prem_seq_no, inst_no,
                                          DECODE (tax_cd, giacp.n ('DOC_STAMPS'), tax_cd,
                                                          giacp.n ('LGT'), tax_cd,
                                                          giacp.n ('FST'), tax_cd,
                                                          giacp.n ('EVAT'), tax_cd,
                                                          giacp.n ('PREM_TAX'), tax_cd,
                                                          99 ),
                                          user_id)
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due;
                        
                        PIPE ROW(rep);                    
                    END LOOP;
                ELSE
                    FOR k IN ( SELECT iss_cd, prem_seq_no, inst_no,
                                       DECODE (tax_cd,  giacp.n ('DOC_STAMPS'), tax_cd,
                                                        giacp.n ('LGT'), tax_cd,
                                                        giacp.n ('FST'), tax_cd,
                                                        giacp.n ('EVAT'), tax_cd,
                                                        giacp.n ('PREM_TAX'), tax_cd,
                                                        99 ) tax_cd,
                                       user_id, SUM (tax_bal_due) tax_bal_due
                                  FROM giac_soa_rep_tax_ext
                                 WHERE iss_cd = i.iss_cd
                                   AND prem_seq_no = i.prem_seq_no
                                   AND inst_no = i.inst_no
                                   AND user_id = i.user_id
                                   AND tax_cd = j.tax_cd
                                 GROUP BY iss_cd, prem_seq_no, inst_no,
                                          DECODE (tax_cd, giacp.n ('DOC_STAMPS'), tax_cd,
                                                          giacp.n ('LGT'), tax_cd,
                                                          giacp.n ('FST'), tax_cd,
                                                          giacp.n ('EVAT'), tax_cd,
                                                          giacp.n ('PREM_TAX'), tax_cd,
                                                          99 ),
                                          user_id )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due;
                        
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.iss_cd      := p_iss_cd;
            rep.prem_seq_no := p_prem_seq_no;
            rep.inst_no     := p_inst_no;
            rep.user_id     := p_user;
            rep.tax_cd      := j.tax_cd;
            rep.tax_name    := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN (SELECT iss_cd, prem_seq_no, inst_no,
                           DECODE (tax_cd,  giacp.n ('DOC_STAMPS'), tax_cd,
                                            giacp.n ('LGT'), tax_cd,
                                            giacp.n ('FST'), tax_cd,
                                            giacp.n ('EVAT'), tax_cd,
                                            giacp.n ('PREM_TAX'), tax_cd,
                                            99 ) tax_cd,
                           user_id, SUM (tax_bal_due) tax_bal_due
                      FROM giac_soa_rep_tax_ext
                     WHERE iss_cd = p_iss_cd --i.iss_cd
                       AND prem_seq_no = p_prem_seq_no --i.prem_seq_no
                       AND inst_no = p_inst_no --i.inst_no
                       AND user_id = p_user --i.user_id
                     GROUP BY iss_cd, prem_seq_no, inst_no,
                              DECODE (tax_cd, giacp.n ('DOC_STAMPS'), tax_cd,
                                              giacp.n ('LGT'), tax_cd,
                                              giacp.n ('FST'), tax_cd,
                                              giacp.n ('EVAT'), tax_cd,
                                              giacp.n ('PREM_TAX'), tax_cd,
                                              99 ),
                              user_id)
        LOOP
            rep.iss_cd      := k.iss_cd;
            rep.prem_seq_no := k.prem_seq_no;
            rep.inst_no     := k.inst_no;
            rep.user_id     := k.user_id;
            rep.tax_cd      := k.tax_cd;
            rep.tax_name    := NULL;
            rep.tax_bal_due := k.tax_bal_due;
            
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
                        
            PIPE ROW(rep);                    
        END LOOP;
    END GET_REPORT_TAX_DETAILS;
    
    
    /**     Q_5, Q_6 and Q_7  **/
    FUNCTION GET_LINE_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type,
        p_line_cd       giis_line.LINE_CD%type
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /** Q_5 ** /
        FOR i IN (SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                         DISTINCT a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                         SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd, a.user_id
                    FROM giac_soa_rep_ext a
                   WHERE 1 = 1
                     AND a.balance_amt_due != 0
                     AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                     AND a.user_id = p_user
                     AND a.intm_no = NVL (p_intm_no, a.intm_no)
                     AND a.intm_type LIKE NVL (p_intm_type, '%')
                     AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                     AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     AND a.COLUMN_TITLE = p_column_title
                     AND SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) = p_line_cd
                   ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := i.branch_cd;
            rep.intm_type       := i.intm_type;
            rep.intm_no         := i.intm_no;
            rep.column_title    := i.column_title;
            rep.line_cd         := i.line_cd;
            rep.user_id         := i.user_id;
            
            /** Q_6 ** /
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                
                PIPE ROW(rep);      --pipe row to retrieve tax_name
                
                /** Q_7 ** /
                IF j.tax_cd = 99 THEN
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                       SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       b.user_id, SUM (b.tax_bal_due) tax_bal_due_line
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.BRANCH_CD = i.branch_cd
                                   AND a.INTM_TYPE = i.intm_type
                                   AND a.INTM_NO = i.intm_no
                                   AND a.COLUMN_TITLE = i.column_title
                                   AND SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) = i.line_cd
                                   AND a.USER_ID = i.user_id
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX') )
                                 GROUP BY a.branch_cd,
                                          a.intm_type,
                                          a.intm_no,
                                          a.column_title,
                                          SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1),
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ),
                                          b.user_id
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_line;
                        
                        PIPE ROW(rep);                    
                    END LOOP;
                ELSE
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                       SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       b.user_id, SUM (b.tax_bal_due) tax_bal_due_line
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.BRANCH_CD = i.branch_cd
                                   AND a.INTM_TYPE = i.intm_type
                                   AND a.INTM_NO = i.intm_no
                                   AND a.COLUMN_TITLE = i.column_title
                                   AND SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) = i.line_cd
                                   AND a.USER_ID = i.user_id
                                   AND tax_cd = j.tax_cd
                                 GROUP BY a.branch_cd,
                                          a.intm_type,
                                          a.intm_no,
                                          a.column_title,
                                          SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1),
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ),
                                          b.user_id
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_line;    
                    
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.branch_cd       := p_branch_cd;
            rep.intm_type       := p_intm_type;
            rep.intm_no         := p_intm_no;
            rep.column_title    := p_column_title;
            rep.line_cd         := p_line_cd;
            rep.user_id         := p_user;
            rep.tax_cd          := j.tax_cd;
            rep.tax_name        := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                           SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) line_cd,
                           DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                             giacp.n ('LGT'), b.tax_cd,
                                             giacp.n ('FST'), b.tax_cd,
                                             giacp.n ('EVAT'), b.tax_cd,
                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                             99 ) tax_cd,
                           b.user_id, SUM (b.tax_bal_due) tax_bal_due_line
                      FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.inst_no = a.inst_no
                       AND a.user_id = b.user_id
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                       AND SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1) = p_line_cd
                       AND a.COLUMN_TITLE = p_column_title
                     GROUP BY a.branch_cd,
                              a.intm_type,
                              a.intm_no,
                              a.column_title,
                              SUBSTR (a.policy_no, 1, INSTR (a.policy_no, '-') - 1),
                              DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                giacp.n ('LGT'), b.tax_cd,
                                                giacp.n ('FST'), b.tax_cd,
                                                giacp.n ('EVAT'), b.tax_cd,
                                                giacp.n ('PREM_TAX'), b.tax_cd,
                                                99 ),
                              b.user_id
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := k.branch_cd;
            rep.intm_type       := k.intm_type;
            rep.intm_no         := k.intm_no;
            rep.column_title    := k.column_title;
            rep.line_cd         := k.line_cd;
            rep.user_id         := k.user_id;
            rep.tax_cd          := k.tax_cd;
            rep.tax_name        := NULL;
            rep.tax_bal_due     := k.tax_bal_due_line;
                           
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
                 
            PIPE ROW(rep);                    
        END LOOP;
        
    END GET_LINE_TAX_DETAILS;
    
    
    /**  Q_8, Q_9 and Q_10 **/    
    FUNCTION GET_COL_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /* Q_8 * /
        FOR i IN  ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                           DISTINCT a.branch_cd, a.intm_type, a.intm_no, a.column_title
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                       AND a.COLUMN_TITLE = p_column_title
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := i.branch_cd;
            rep.intm_type       := i.intm_type;
            rep.intm_no         := i.intm_no;
            rep.column_title    := i.column_title;
            
            /* Q_9 * /
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN ( giacp.n ('DOC_STAMPS'),
                                           giacp.n ('LGT'),
                                           giacp.n ('FST'),
                                           giacp.n ('EVAT'),
                                           giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                
                PIPE ROW(rep);  --pipe row to retrieve tax_names
                
                /* Q_10 * /
                IF j.tax_cd = 99 THEN
                    FOR k IN  ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_col
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.BRANCH_CD = i.branch_cd
                                   AND a.INTM_TYPE = i.intm_type
                                   AND a.INTM_NO = i.intm_no
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX') )
                                 GROUP BY a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                          DECODE (b.tax_cd,  giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                             giacp.n ('LGT'), b.tax_cd,
                                                             giacp.n ('FST'), b.tax_cd,
                                                             giacp.n ('EVAT'), b.tax_cd,
                                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                                             99 )
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_col;
                    
                        PIPE ROW(rep);
                    END LOOP;
                ELSE
                    FOR k IN  ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_col
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.BRANCH_CD = i.branch_cd
                                   AND a.INTM_TYPE = i.intm_type
                                   AND a.INTM_NO = i.intm_no
                                   AND tax_cd = j.tax_cd
                                 GROUP BY a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                                          DECODE (b.tax_cd,  giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                             giacp.n ('LGT'), b.tax_cd,
                                                             giacp.n ('FST'), b.tax_cd,
                                                             giacp.n ('EVAT'), b.tax_cd,
                                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                                             99 )
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_col;
                    
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.branch_cd       := p_branch_cd;
            rep.intm_type       := p_intm_type;
            rep.intm_no         := p_intm_no;
            rep.column_title    := p_column_title;
            rep.tax_cd          := j.tax_cd;
            rep.tax_name        := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN  ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                           DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                             giacp.n ('LGT'), b.tax_cd,
                                             giacp.n ('FST'), b.tax_cd,
                                             giacp.n ('EVAT'), b.tax_cd,
                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                             99 ) tax_cd,
                           SUM (b.tax_bal_due) tax_bal_due_col
                      FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.inst_no = a.inst_no
                       AND a.user_id = b.user_id
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     GROUP BY a.branch_cd, a.intm_type, a.intm_no, a.column_title,
                              DECODE (b.tax_cd,  giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                 giacp.n ('LGT'), b.tax_cd,
                                                 giacp.n ('FST'), b.tax_cd,
                                                 giacp.n ('EVAT'), b.tax_cd,
                                                 giacp.n ('PREM_TAX'), b.tax_cd,
                                                 99 )
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := k.branch_cd;
            rep.intm_type       := k.intm_type;
            rep.intm_no         := k.intm_no;
            rep.column_title    := k.column_title;
            rep.tax_cd          := k.tax_cd;
            rep.tax_name        := NULL;
            rep.tax_bal_due     := k.tax_bal_due_col;
            
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
                    
            PIPE ROW(rep);
        END LOOP;
    END GET_COL_TAX_DETAILS;
    
    
    /**  Q_11, Q_12, and Q_13  **/
    FUNCTION GET_INTM_NO_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /* Q_11 * /
        FOR i IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                           DISTINCT a.branch_cd, a.intm_type, a.intm_no
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := i.branch_cd;
            rep.intm_type       := i.intm_type;
            rep.intm_no         := i.intm_no;
        
            /* Q_12 * /
            FOR j IN (SELECT tax_cd, tax_name
                        FROM giac_taxes
                       WHERE tax_cd IN ( giacp.n ('DOC_STAMPS'),
                                         giacp.n ('LGT'),
                                         giacp.n ('FST'),
                                         giacp.n ('EVAT'),
                                         giacp.n ('PREM_TAX') )
                       UNION
                      SELECT 99, 'OTHER TAXES'
                        FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                
                PIPE ROW(rep);  --pipe row to retrieve tax names
                
                /* Q_13 * /
                IF j.tax_cd = 99 THEN
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_intmno
                                  FROM giac_soa_rep_ext a, 
                                       giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND a.intm_type = i.intm_type
                                   AND a.intm_no = i.intm_no
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX') )
                                 GROUP BY a.branch_cd, a.intm_type, a.intm_no,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 )
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_intmno;
                    
                        PIPE ROW(rep);
                    END LOOP;
                ELSE
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type, a.intm_no,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_intmno
                                  FROM giac_soa_rep_ext a, 
                                       giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND a.intm_type = i.intm_type
                                   AND a.intm_no = i.intm_no
                                   AND tax_cd = j.tax_cd
                                 GROUP BY a.branch_cd, a.intm_type, a.intm_no,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 )
                                 ORDER BY a.intm_no )
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_intmno;
                    
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.branch_cd       := p_branch_cd;
            rep.intm_type       := p_intm_type;
            rep.intm_no         := p_intm_no;
            rep.tax_cd          := j.tax_cd;
            rep.tax_name        := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd, a.intm_type, a.intm_no,
                           DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                             giacp.n ('LGT'), b.tax_cd,
                                             giacp.n ('FST'), b.tax_cd,
                                             giacp.n ('EVAT'), b.tax_cd,
                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                             99 ) tax_cd,
                           SUM (b.tax_bal_due) tax_bal_due_intmno
                      FROM giac_soa_rep_ext a, 
                           giac_soa_rep_tax_ext b
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.inst_no = a.inst_no
                       AND a.user_id = b.user_id
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     GROUP BY a.branch_cd, a.intm_type, a.intm_no,
                              DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                giacp.n ('LGT'), b.tax_cd,
                                                giacp.n ('FST'), b.tax_cd,
                                                giacp.n ('EVAT'), b.tax_cd,
                                                giacp.n ('PREM_TAX'), b.tax_cd,
                                                99 )
                     ORDER BY a.intm_no )
        LOOP
            rep.branch_cd       := k.branch_cd;
            rep.intm_type       := k.intm_type;
            rep.intm_no         := k.intm_no;
            rep.tax_cd          := k.tax_cd;
            rep.tax_name        := NULL;
            rep.tax_bal_due     := k.tax_bal_due_intmno;
                    
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
            PIPE ROW(rep);
        END LOOP;
    END GET_INTM_NO_TAX_DETAILS;
    
        
    /**  Q_14, Q_15, Q_19  **/
    FUNCTION GET_INTM_TYPE_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /* Q_14 * /
        FOR i IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                           DISTINCT a.branch_cd, a.intm_type
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y') )
        LOOP
            rep.branch_cd   := i.branch_cd;
            rep.intm_type   := i.intm_type;
            
            /* Q_15 * /
            FOR j IN (SELECT tax_cd, tax_name
                        FROM giac_taxes
                       WHERE tax_cd IN ( giacp.n ('DOC_STAMPS'),
                                         giacp.n ('LGT'),
                                         giacp.n ('FST'),
                                         giacp.n ('EVAT'),
                                         giacp.n ('PREM_TAX') )
                       UNION
                      SELECT 99, 'OTHER TAXES'
                        FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                    
                PIPE ROW(rep);  --pipe row to retrieve tax_names
                
                /* Q_16 * /
                IF j.tax_cd = 99 THEN
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_intmtype
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND a.intm_type = i.intm_type
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX') )
                                 GROUP BY a.branch_cd, a.intm_type,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ))
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_intmtype;
                        
                        PIPE ROW(rep);
                    END LOOP;
                ELSE
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd, a.intm_type,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_intmtype
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND a.intm_type = i.intm_type
                                   AND tax_cd = j.tax_cd
                                 GROUP BY a.branch_cd, a.intm_type,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ))
                    LOOP
                        rep.tax_bal_due := k.tax_bal_due_intmtype;
                        
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.branch_cd       := p_branch_cd;
            rep.intm_type       := p_intm_type;
            rep.tax_cd          := j.tax_cd;
            rep.tax_name        := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd, a.intm_type,
                           DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                             giacp.n ('LGT'), b.tax_cd,
                                             giacp.n ('FST'), b.tax_cd,
                                             giacp.n ('EVAT'), b.tax_cd,
                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                             99 ) tax_cd,
                           SUM (b.tax_bal_due) tax_bal_due_intmtype
                      FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.inst_no = a.inst_no
                       AND a.user_id = b.user_id
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     GROUP BY a.branch_cd, a.intm_type,
                              DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                giacp.n ('LGT'), b.tax_cd,
                                                giacp.n ('FST'), b.tax_cd,
                                                giacp.n ('EVAT'), b.tax_cd,
                                                giacp.n ('PREM_TAX'), b.tax_cd,
                                                99 ))
        LOOP
            rep.branch_cd       := k.branch_cd;
            rep.intm_type       := k.intm_type;
            rep.tax_cd          := k.tax_cd;
            rep.tax_name        := NULL;
            rep.tax_bal_due     := k.tax_bal_due_intmtype;
                        
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
            
            PIPE ROW(rep);
        END LOOP;
    END GET_INTM_TYPE_TAX_DETAILS;
    
        
    /**  Q_17, Q_18 and Q_19  **/
    FUNCTION GET_BRANCH_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED
    AS
        rep     tax_details_type;
    BEGIN
        /* Q_17 * /
        FOR i IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                           DISTINCT a.branch_cd
                      FROM giac_soa_rep_ext a
                     WHERE 1 = 1
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y') )
        LOOP
            rep.branch_cd   := i.branch_cd;
            
            /* Q_18 * /
            FOR j IN (SELECT tax_cd, tax_name
                        FROM giac_taxes
                       WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                        giacp.n ('LGT'),
                                        giacp.n ('FST'),
                                        giacp.n ('EVAT'),
                                        giacp.n ('PREM_TAX') )
                       UNION
                      SELECT 99, 'OTHER TAXES'
                        FROM DUAL)
            LOOP
                rep.tax_cd      := j.tax_cd;
                rep.tax_name    := j.tax_name;
                rep.tax_bal_due := null;
                
                PIPE ROW(rep);  --pipe row to retieve tax_names
                
                /* Q_19 * /
                IF j.tax_cd = 99 THEN
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_branch
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND tax_cd NOT IN (giacp.n ('DOC_STAMPS'), 
                                                      giacp.n ('LGT'), 
                                                      giacp.n ('FST'), 
                                                      giacp.n ('EVAT'),
                                                      giacp.n ('PREM_TAX') )
                                 GROUP BY a.branch_cd,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ) )
                    LOOP
                        rep.tax_bal_due     := k.tax_bal_due_branch;
                        
                        PIPE ROW(rep);
                    END LOOP;
                ELSE
                    FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)* /
                                       a.branch_cd,
                                       DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                         giacp.n ('LGT'), b.tax_cd,
                                                         giacp.n ('FST'), b.tax_cd,
                                                         giacp.n ('EVAT'), b.tax_cd,
                                                         giacp.n ('PREM_TAX'), b.tax_cd,
                                                         99 ) tax_cd,
                                       SUM (b.tax_bal_due) tax_bal_due_branch
                                  FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                                 WHERE 1 = 1
                                   AND a.iss_cd = b.iss_cd
                                   AND a.prem_seq_no = b.prem_seq_no
                                   AND a.inst_no = a.inst_no
                                   AND a.user_id = b.user_id
                                   AND a.balance_amt_due != 0
                                   AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                                   AND a.user_id = p_user
                                   AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                   AND a.intm_type LIKE NVL (p_intm_type, '%')
                                   AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                                   AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                                   AND a.branch_cd = i.branch_cd
                                   AND tax_cd = j.tax_cd
                                 GROUP BY a.branch_cd,
                                          DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                            giacp.n ('LGT'), b.tax_cd,
                                                            giacp.n ('FST'), b.tax_cd,
                                                            giacp.n ('EVAT'), b.tax_cd,
                                                            giacp.n ('PREM_TAX'), b.tax_cd,
                                                            99 ) )
                    LOOP
                        rep.tax_bal_due     := k.tax_bal_due_branch;
                        
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;            
        END LOOP;*/
        
        FOR j IN  ( SELECT tax_cd, tax_name
                      FROM giac_taxes
                     WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                      giacp.n ('LGT'),
                                      giacp.n ('FST'),
                                      giacp.n ('EVAT'),
                                      giacp.n ('PREM_TAX') )
                     UNION
                    SELECT 99, 'OTHER TAXES'
                      FROM DUAL)
        LOOP
            rep.branch_cd       := p_branch_cd;
            rep.tax_cd          := j.tax_cd;
            rep.tax_name        := j.tax_name;
            
            PIPE ROW(rep);            
        END LOOP;
        
        FOR k IN ( SELECT /*+ INDEX (A GIAC_SOA_REP_EXT_BRANCH_CD_IDX) INDEX (A GIAC_SOA_REP_EXT_INTM_NO_IDX) INDEX(A GIAC_SOA_REP_EXT_INTM_TYPE_IDX)*/
                           a.branch_cd,
                           DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                             giacp.n ('LGT'), b.tax_cd,
                                             giacp.n ('FST'), b.tax_cd,
                                             giacp.n ('EVAT'), b.tax_cd,
                                             giacp.n ('PREM_TAX'), b.tax_cd,
                                             99 ) tax_cd,
                           SUM (b.tax_bal_due) tax_bal_due_branch
                      FROM giac_soa_rep_ext a, giac_soa_rep_tax_ext b
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.inst_no = a.inst_no
                       AND a.user_id = b.user_id
                       AND a.balance_amt_due != 0
                       AND a.balance_amt_due >= NVL (p_bal_amt_due, a.balance_amt_due)
                       AND a.user_id = p_user
                       AND a.intm_no = NVL (p_intm_no, a.intm_no)
                       AND a.intm_type LIKE NVL (p_intm_type, '%')
                       AND a.branch_cd LIKE NVL (p_branch_cd, '%')
                       AND a.due_tag = DECODE (p_inc_overdue, 'I', a.due_tag, 'N', 'Y')
                     GROUP BY a.branch_cd,
                              DECODE (b.tax_cd, giacp.n ('DOC_STAMPS'), b.tax_cd,
                                                giacp.n ('LGT'), b.tax_cd,
                                                giacp.n ('FST'), b.tax_cd,
                                                giacp.n ('EVAT'), b.tax_cd,
                                                giacp.n ('PREM_TAX'), b.tax_cd,
                                                99 ) )
        LOOP
            rep.branch_cd       := k.branch_cd;
            rep.tax_cd          := k.tax_cd;
            rep.tax_name        := NULL;
            rep.tax_bal_due     := k.tax_bal_due_branch;
                  
            FOR j IN  ( SELECT tax_cd, tax_name
                          FROM giac_taxes
                         WHERE tax_cd IN (giacp.n ('DOC_STAMPS'),
                                          giacp.n ('LGT'),
                                          giacp.n ('FST'),
                                          giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX') )
                         UNION
                        SELECT 99, 'OTHER TAXES'
                          FROM DUAL)
            LOOP
                IF j.tax_cd = k.tax_cd THEN
                    rep.tax_name    := j.tax_name;
                    EXIT;
                END IF;
            END LOOP;
                  
            PIPE ROW(rep);
        END LOOP;
    END GET_BRANCH_TAX_DETAILS;
    
    FUNCTION get_giacr193a_csv (
       p_bal_amt_due   NUMBER,
       p_user          VARCHAR2,
       p_intm_no       NUMBER,
       p_intm_type     VARCHAR2,
       p_branch_cd     VARCHAR2,
       p_inc_overdue   VARCHAR2
    )
      RETURN giacr193a_csv_tab PIPELINED
    IS
       v_list giacr193a_csv_type;
       v_select_statement VARCHAR2(32767);
       
       TYPE v_type IS RECORD (
          branch              giac_branches.branch_name%TYPE,
          intermediary_type   giis_intm_type.intm_desc%TYPE,
          intermediay_no      giac_soa_rep_ext.intm_no%TYPE,
          ref_intm_cd         giis_intermediary.ref_intm_cd%TYPE,
          intermediay_name    giac_soa_rep_ext.intm_name%TYPE,
          address             VARCHAR2 (250),
          column_title        giac_soa_rep_ext.column_title%TYPE,
          line                giis_line.line_name%TYPE,
          policy              giac_soa_rep_ext.policy_no%TYPE,
          ref_pol_no          giac_soa_rep_ext.ref_pol_no%TYPE,
          assured             giac_soa_rep_ext.assd_name%TYPE,
          bill_no             VARCHAR2 (20),
          incept_date         giac_soa_rep_ext.incept_date%TYPE,
          due_date            giac_soa_rep_ext.due_date%TYPE,
          age                 giac_soa_rep_ext.no_of_days%TYPE,
          premium_amt         giac_soa_rep_ext.prem_bal_due%TYPE,
          doc_stamps          NUMBER,
          fst                 NUMBER,
          evat                NUMBER,
          lgt                 NUMBER,
          prem_tax            NUMBER,
          other_taxes         NUMBER,
          balance_amt         giac_soa_rep_ext.balance_amt_due%TYPE
       );

       TYPE v_tab IS TABLE OF v_type;
       v_list2 v_tab;
       
    BEGIN
       v_select_statement := 'SELECT a.branch_name "Branch", intm_desc "Intermediary_Type", a.intm_no "Intermediay_No", 
                                     a.ref_intm_cd "Ref_Intm_Cd", a.intm_name "Intermediay_Name", a.intm_address "Address", 
                                     a.column_title "Column_Title", a.line_name "Line", a.policy_no "Policy", 
                                     a.ref_pol_no "Ref_Pol_No", a.assd_name "Assured", a.bill_no "Bill_No", 
                                     a.incept_date "Incept_Date", a.due_date "Due_Date", a.no_of_days "Age", 
                                     a.prem_bal_due "Premium_Amt", ';
                                     
       
       
       IF giacp.n ('DOC_STAMPS') IS NOT NULL THEN          
          v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''DOC_STAMPS''), b.tax_bal_due, 0)), ';
       ELSE
          v_select_statement := v_select_statement || '0, ';
       END IF;
       
       IF giacp.n ('FST') IS NOT NULL THEN          
          v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''FST''), b.tax_bal_due, 0)), ';
       ELSE
          v_select_statement := v_select_statement || '0, ';
       END IF;
       
       IF giacp.n ('EVAT') IS NOT NULL THEN          
          v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''EVAT''), b.tax_bal_due, 0)), ';
       ELSE
          v_select_statement := v_select_statement || '0, ';
       END IF;
       
       IF giacp.n ('LGT') IS NOT NULL THEN          
          v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''LGT''), b.tax_bal_due, 0)), ';
       ELSE
          v_select_statement := v_select_statement || '0, ';
       END IF;
       
       IF giacp.n ('PREM_TAX') IS NOT NULL THEN          
          v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''PREM_TAX''), b.tax_bal_due, 0)), ';
       ELSE
          v_select_statement := v_select_statement || '0, ';
       END IF;
       
       v_select_statement := v_select_statement || 'SUM(DECODE(b.tax_cd, giacp.n(''DOC_STAMPS''), 0, 
                                                                         giacp.n(''FST''), 0,
                                                                         giacp.n(''EVAT''), 0,
                                                                         giacp.n(''LGT''), 0,
                                                                         giacp.n(''PREM_TAX''), 0,
                                                                         b.tax_bal_due)), ';
       
       v_select_statement := v_select_statement || 
                             '         a.balance_amt_due "Balance_Amt" ' ||
                             '    FROM TABLE (csv_soa.csv_giacr193a (' || NVL(TO_CHAR(p_bal_amt_due), 'NULL') || ', ''' || p_user || ''', ' || NVL(TO_CHAR(p_intm_no), 'NULL') || ', ''' || p_intm_type || ''', ''' || p_branch_cd || ''', ''' || p_inc_overdue || ''')) a, ' ||
                             '        giac_soa_rep_tax_ext b ' ||
                             '   WHERE a.iss_cd = b.iss_cd ' ||
                             '     AND a.prem_seq_no = b.prem_seq_no ' ||
                             '     AND a.inst_no = b.inst_no ' ||
                             '     AND a.user_id = b.user_id ' ||
                             'GROUP BY a.branch_name, a.intm_desc, a.intm_no, a.ref_intm_cd, a.intm_name, a.intm_address, ' ||
                             'a.column_title, a.line_name, a.policy_no, a.ref_pol_no, a.assd_name, a.bill_no, '||
                             'a.incept_date, a.due_date, a.no_of_days, a.prem_bal_due, a.balance_amt_due';
                             
                             
       EXECUTE IMMEDIATE v_select_statement
       BULK COLLECT INTO v_list2;
   
       IF v_list2.LAST > 0 THEN
          FOR i IN v_list2.FIRST..v_list2.LAST
          LOOP
             v_list.branch := v_list2(i).branch;
             v_list.intermediary_type := v_list2(i).intermediary_type;
             v_list.intermediay_no := v_list2(i).intermediay_no;
             v_list.ref_intm_cd := v_list2(i).ref_intm_cd;
             v_list.intermediay_name := v_list2(i).intermediay_name;
             v_list.address := v_list2(i).address;
             v_list.column_title := v_list2(i).column_title;
             v_list.line := v_list2(i).line;
             v_list.policy := v_list2(i).policy;
             v_list.ref_pol_no := v_list2(i).ref_pol_no;
             v_list.assured := v_list2(i).assured;
             v_list.bill_no := v_list2(i).bill_no;
             v_list.incept_date := v_list2(i).incept_date;
             v_list.due_date := v_list2(i).due_date;
             v_list.age := v_list2(i).age;
             v_list.premium_amt := v_list2(i).premium_amt;
             v_list.doc_stamps := v_list2(i).doc_stamps;
             v_list.fst := v_list2(i).fst;
             v_list.evat := v_list2(i).evat;
             v_list.lgt := v_list2(i).lgt;
             v_list.prem_tax := v_list2(i).prem_tax;
             v_list.other_taxes := v_list2(i).other_taxes;
             v_list.balance_amt := v_list2(i).balance_amt;
             
             PIPE ROW(v_list);
          END LOOP; 
       END IF;
                             
    END get_giacr193a_csv;
    
    FUNCTION get_csv_cols
       RETURN csv_col_tab PIPELINED
    IS
       v_list csv_col_type;
    BEGIN
       FOR i IN (SELECT INITCAP(argument_name) argument_name
                   FROM all_arguments
                    WHERE owner = 'CPI'
                       AND package_name = 'GIACR193A_PKG'
                       AND object_name = 'GET_GIACR193A_CSV'
                       AND in_out = 'OUT'
                       AND argument_name IS NOT NULL
                ORDER BY position)
      LOOP
         v_list.col_name := i.argument_name;
         
         IF(UPPER(i.argument_name) IN ('DOC_STAMPS', 'FST', 'EVAT', 'LGT', 'PREM_TAX')) THEN
            BEGIN
               SELECT INITCAP(tax_name)
                 INTO v_list.col_name
                 FROM giac_taxes
                WHERE tax_cd = giacp.n(UPPER(i.argument_name));
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.col_name := NULL;    
            END;
         END IF;
         
         IF UPPER(i.argument_name) = 'OTHER_TAXES' THEN
            v_list.col_name := 'Other Taxes';
         END IF;   
         
         IF v_list.col_name IS NULL THEN
            v_list.col_name := i.argument_name;
         END IF;
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;
    
END GIACR193A_PKG;
/



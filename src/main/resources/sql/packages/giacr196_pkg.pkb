CREATE OR REPLACE PACKAGE BODY CPI.GIACR196_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   06.03.2013
     ** Referenced By:  GIACR196 - Statement of Accounts (Intermediary with NET)
     **/
    
    
    FUNCTION CF_COMPANY_NAME    
        RETURN VARCHAR2
    AS
        v_name  varchar2(200);
    BEGIN
        SELECT PARAM_VALUE_V
          INTO v_name
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_NAME';
         
        RETURN (v_name);
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_NAME := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
            RETURN(V_NAME);
        WHEN TOO_MANY_ROWS THEN
            V_NAME := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
            RETURN(V_NAME);
    END CF_COMPANY_NAME;
        
        
    FUNCTION CF_COMPANY_ADDRESS 
        RETURN VARCHAR2
    AS
        V_ADD   VARCHAR2(350);
    BEGIN
        SELECT PARAM_VALUE_V
          INTO V_ADD
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_ADDRESS';
        
        RETURN (V_ADD);
        
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADD := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
            RETURN(V_ADD);
        WHEN TOO_MANY_ROWS THEN
            V_ADD := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETER)';
            RETURN(V_ADD);
    END CF_COMPANY_ADDRESS;
        
       
    FUNCTION CF_TITLE
        RETURN VARCHAR2
    AS
        v_title     varchar2(100);
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
        v_date_label    VARCHAR2(100);
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
        
    
    FUNCTION CF_DATE (
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN DATE
    AS
        v_date  DATE;
    BEGIN       
        FOR C IN (SELECT PARAM_DATE
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = P_USER_ID
                     AND ROWNUM = 1)
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
        p_user_id   IN  GIAC_SOA_REP_EXT.USER_ID%type
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
        DSP_NAME2       VARCHAR2(300);
    BEGIN
        FOR C IN (SELECT DATE_TAG, FROM_DATE1, TO_DATE1, FROM_DATE2, TO_DATE2
                    FROM GIAC_SOA_REP_EXT
                   WHERE USER_ID = P_USER_ID
                     AND ROWNUM = 1)
        LOOP
            V_TAG := C.DATE_TAG;
            V_FROM_DATE1 := C.FROM_DATE1; 
            V_TO_DATE1 := C.TO_DATE1;
            V_FROM_DATE2 := C.FROM_DATE2;
            V_TO_DATE2 := C.TO_DATE2;    
            EXIT;
        END LOOP;
        
        /*DECODE THE TAG SO AS TO DISPLAY THE PROPER LABEL*/
        IF V_TAG = 'BK' THEN
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
        /*PASS THE SECOND NAME TO CF_DATE_TAG2 */
        GIACR196_PKG.DSP_NAME2 := (V_AND||V_NAME2); 

        RETURN (DSP_NAME);
        
    END CF_DATE_TAG1;
    
    
    FUNCTION CF_LABEL
        RETURN VARCHAR2
    AS
        v_label   VARCHAR2(100);
    BEGIN
        FOR I IN (SELECT label
                    FROM giac_rep_signatory 
                   WHERE report_id = 'GIACR196')
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
                     AND report_id = 'GIACR196')
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
                     AND report_id = 'GIACR196')
        LOOP
            v_designation := i.designation;
            EXIT;
        END LOOP;

        RETURN(v_designation);
    END CF_DESIGNATION;
        
    
    FUNCTION CF_BRANCH_NAME(
        p_branch_cd     giis_issource.ISS_CD%type
    ) RETURN VARCHAR2
    AS
        V_BRANCH_NAME VARCHAR2(75);
    BEGIN
        FOR C IN (SELECT ISS_NAME
                    FROM GIIS_ISSOURCE
                   WHERE ISS_CD = P_BRANCH_CD)
        LOOP
            V_BRANCH_NAME := C.ISS_NAME;
            EXIT;
        END LOOP;
        
        RETURN (V_BRANCH_NAME);
    END CF_BRANCH_NAME;
    
    
    FUNCTION CF_REF_INTM_CD(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%TYPE
    ) RETURN VARCHAR2
    AS
        V_REF_INTM VARCHAR2(50);
    BEGIN
        FOR C IN (SELECT REF_INTM_CD
                    FROM GIIS_INTERMEDIARY
                   WHERE INTM_NO = P_INTM_NO)
        LOOP
            V_REF_INTM := C.REF_INTM_CD;
            EXIT;
        END LOOP;
        
        RETURN (V_REF_INTM);
    END CF_REF_INTM_CD;
    
    
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
    
    
    FUNCTION CF_COMM_AMT(
        p_cut_off       giac_acctrans.TRAN_DATE%type,
        p_intm_no       giac_comm_payts.INTM_NO%type,
        p_iss_cd        giac_comm_payts.ISS_CD%type,
        p_prem_seq_no   giac_comm_payts.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        V_COMM      NUMBER(16,2);
        V_COMM_PAID NUMBER(16,2);
    BEGIN
        FOR C IN (SELECT gspe.GACC_TRAN_ID, SUM(gspe.COMM_AMT) comm_amt
	                FROM giac_comm_payts gspe, GIAC_ACCTRANS C
	               WHERE GSPE.GACC_TRAN_ID = C.TRAN_ID
		             AND GSPE.GACC_TRAN_ID NOT IN (SELECT A.TRAN_ID 
                                                     FROM GIAC_ACCTRANS A, GIAC_REVERSALS B
                                                    WHERE B.REVERSING_TRAN_ID = A.TRAN_ID
                                                      AND A.TRAN_FLAG <> 'D')
		             AND gspe.intm_no = p_intm_no
		             AND gspe.iss_cd = p_iss_cd
		             AND gspe.prem_seq_no = p_prem_seq_no
		             AND TRUNC(C.TRAN_DATE) <= TRUNC(TO_DATE(P_CUT_OFF)) 
                   GROUP BY gspe.GACC_TRAN_ID) 
        LOOP
            V_COMM_PAID := C.COMM_AMT;
            EXIT;
        END LOOP; 
        
        IF V_COMM_PAID IS NULL THEN
            V_COMM_PAID := 0;
        END IF;
        
        FOR A IN (SELECT COMMISSION_AMT
                    FROM gipi_comm_invoice
                   WHERE intrmdry_intm_no = p_intm_no
                     AND iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no)  
        LOOP
            V_COMM := A.COMMISSION_AMT;
            EXIT;
        END LOOP;
        
        IF V_COMM IS NULL THEN
            V_COMM := 0;
        END IF;

        V_COMM := V_COMM - V_COMM_PAID;
        RETURN(V_COMM);
    END CF_COMM_AMT;
    
    
    FUNCTION CF_NET_AMT(
        p_balance_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%type,
        p_cf_comm_amt       NUMBER
    ) RETURN NUMBER
    AS
        V_NET NUMBER;
    BEGIN
        V_NET := NVL(P_BALANCE_AMT_DUE,0) - NVL(P_CF_COMM_AMT,0);
        RETURN (V_NET); 
    END CF_NET_AMT;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_cut_off       giac_acctrans.TRAN_DATE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    
    ) RETURN report_details_tab PIPELINED
    AS
        rep             report_details_type;
        v_from_to       VARCHAR2(1);
        v_ref_date      VARCHAR2(1);
        v_count         NUMBER(1) := 0;
    BEGIN
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.print_company       := giacp.v('SOA_HEADER');
        rep.cf_title            := CF_TITLE;
        rep.cf_date_label       := CF_DATE_LABEL;
        rep.cf_date             := CF_DATE(p_user);  
        rep.cf_date_tag1        := CF_DATE_TAG1(p_user);
        rep.cf_date_tag2        := NVL(GIACR196_PKG.dsp_name2, NULL);
        rep.print_date_tag      := giacp.v('SOA_FROM_TO');
        
        rep.print_user_id       := giacp.v('SOA_USER_ID');
        rep.cf_label            := CF_LABEL;
        rep.cf_signatory        := CF_SIGNATORY;
        rep.cf_designation      := CF_DESIGNATION;
        rep.print_signatory     := giacp.v('SOA_SIGNATORY');
                
        -- ** CF_DATE_TAG format trigger (in intm_no group footer) ** --
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
        
        
        FOR i IN ( SELECT UPPER(INTM_NAME) INTM_NAME, INTM_NO, intm_type, -- jenny vi lim 01062005
                           COLUMN_TITLE,ASSD_NO, ASSD_NAME,
                           BALANCE_AMT_DUE, POLICY_NO,
                           iss_cd||'-'||prem_seq_no||'-'||inst_no bill_no,
                           DUE_DATE, NO_OF_DAYS, REF_POL_NO,
                           PREM_BAL_DUE, TAX_BAL_DUE, ISS_CD,
                           PREM_SEQ_NO, BRANCH_CD, B.COL_NO
                      FROM GIAC_SOA_REP_EXT A, GIAC_SOA_TITLE B
                     WHERE A.COLUMN_NO = B.COL_NO 
                       AND REP_CD = 1 --added by april 07/21/2008
                       AND BALANCE_AMT_DUE != 0 
                       AND A.USER_ID = P_USER
                       AND INTM_NO = NVL(P_INTM_NO, INTM_NO) 
                       AND intm_type = nvl(p_intm_type, intm_type) -- jenny vi lim 01062005
                       AND DUE_TAG = DECODE(P_INC_OVERDUE, 'I',DUE_TAG,'N','Y')
                       AND BRANCH_CD = NVL(P_BRANCH_CD,BRANCH_CD)
                     ORDER BY INTM_NO,B.COL_NO,7,5,INST_NO )
        LOOP
            rep.branch_cd       := i.branch_cd;
            rep.cf_branch_name  := CF_BRANCH_NAME(i.branch_cd);
            rep.intm_no         := i.intm_no;
            rep.intm_name       := i.intm_name;
            rep.cf_ref_intm_cd  := CF_REF_INTM_CD(i.intm_no);
            rep.cf_intm_add     := CF_INTM_ADD(i.intm_no);
            rep.intm_type       := i.intm_type;
            rep.col_no          := i.col_no;
            rep.column_title    := i.column_title;
            rep.policy_no       := i.policy_no;
            rep.ref_pol_no      := i.ref_pol_no;
            rep.assd_no         := i.assd_no;
            rep.assd_name       := i.assd_name;
            rep.bill_no         := i.bill_no;
            rep.iss_cd          := i.iss_cd;
            rep.due_date        := i.due_date;
            rep.no_of_days      := i.no_of_days;
            rep.prem_seq_no     := i.prem_seq_no;
            rep.balance_amt_due := i.balance_amt_due;
            rep.prem_bal_due    := i.prem_bal_due;
            rep.tax_bal_due     := i.tax_bal_due;
            rep.cf_comm_amt     := CF_COMM_AMT(p_cut_off, i.intm_no, i.iss_cd, i.prem_seq_no);
            rep.cf_net_amt      := CF_NET_AMT(i.balance_amt_due, rep.cf_comm_amt);
            v_count := 1;
            PIPE ROW(rep);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(rep);
        END IF;
        
    END GET_REPORT_DETAILS;   


END GIACR196_PKG;
/



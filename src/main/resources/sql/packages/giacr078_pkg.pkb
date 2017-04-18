CREATE OR REPLACE PACKAGE BODY CPI.GIACR078_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   06.26.2013
     ** Referenced By:  GIACR078 - Collection Analysis Report
     **/
    
    FUNCTION get_report_header(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_date_tag      VARCHAR2
    ) RETURN report_header_tab PIPELINED
    AS
        rep     report_header_type;
        V_ADD   VARCHAR2(350);
    BEGIN
        SELECT PARAM_VALUE_V
	      INTO rep.company_name
	      FROM GIIS_PARAMETERS
	     WHERE PARAM_NAME='COMPANY_NAME';
         
        begin
            SELECT PARAM_VALUE_V
              INTO rep.company_address
              FROM GIIS_PARAMETERS
             WHERE PARAM_NAME = 'COMPANY_ADDRESS';
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.company_address := '(NO PARAMETER COMPANY_ADDRESS IN GIIS_PARAMETERS)';
            WHEN TOO_MANY_ROWS THEN
                rep.company_address := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        end;
        
        rep.rundate         := TO_CHAR(sysdate, GET_REP_DATE_FORMAT);
        rep.cf_date         := p_date_tag||' DATE '||' FROM '||TO_CHAR(p_date_from,'fmMONTH DD, YYYY')||' TO '||TO_CHAR(p_date_to,'fmMONTH DD, YYYY');
        rep.print_company   := giacp.v('SOA_HEADER');
        
        PIPE ROW(rep);
        
    END get_report_header;


    FUNCTION CF_INV_NO(
        p_iss_cd        giac_coll_analysis_ext.ISS_CD%type,
        p_prem_seq_no   giac_coll_analysis_ext.PREM_SEQ_NO%type
    ) RETURN VARCHAR2
    AS
        v_inv_no  VARCHAR2(50);
    BEGIN
         IF p_iss_cd IS NOT NULL AND p_prem_seq_no IS NOT NULL THEN
  	        v_inv_no := p_iss_cd||'-'||p_prem_seq_no; 
        ELSE
  	        v_inv_no := ' ';
        END IF;	
        
        RETURN(v_inv_no);
    END CF_INV_NO;
    
    
    FUNCTION CF_COLUMN_NO(
        p_age   giac_coll_analysis_ext.AGE%type
    ) RETURN NUMBER
    AS
        v_column_no giac_coll_analysis_title.column_no%TYPE :=0;
    BEGIN
        IF p_age < 0 THEN
		    v_column_no := 1;
	    ELSE	
            FOR a_rec IN (SELECT column_no
                            FROM giac_coll_analysis_title
                           WHERE min_days <= p_age 
                             AND max_days >= p_age)
            LOOP
              v_column_no := a_rec.column_no;
            END LOOP;
        END IF;
  
        RETURN(v_column_no);
    END CF_COLUMN_NO;
    
    
    FUNCTION get_report_details(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_rep_type      VARCHAR2,
        p_branch_cd     giac_coll_analysis_ext.BRANCH_CD%type,
        p_intm_no       giac_coll_analysis_ext.INTM_NO%type,
        p_user          giac_coll_analysis_ext.USER_ID%type
    ) RETURN report_details_tab PIPELINED
    AS
        rep         report_details_type;
        v_column    VARCHAR2(100);
        v_where     VARCHAR2(100);
    BEGIN
        /*IF UPPER(p_rep_type) = 'INTM' THEN
            v_column    := 'INTM_NAME';
            --v_where   := 'AND intm_no = NVL(:p_intm_no,intm_no)';
        ELSIF UPPER(p_rep_type) = 'BRANCH' THEN
            v_column    := 'BRANCH_CD';
            --v_where   := 'AND branch_cd = NVL(:p_branch_cd,branch_cd) ';
        END IF;*/
        
        FOR i IN (/*
                    ** Modified by   : MAC
                    ** Date Modified : 02/14/2013
                    ** Modifications : Remove SUBSTR to show the full length of payor and intermediary.
                                       Add leading zeros in OR number and prem_seq_no.
                                       Considered the value of parameter p_rep_type in printing records.
                                       Added security access.
                                       Removed 
                    */
                  SELECT RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)) branch_intm, policy_no,
                         or_pref || '-' || LPAD(or_no,10,0) or_no, iss_cd, LPAD(prem_seq_no,12,0) prem_seq_no,
                         /*SUBSTR (payor, 1, 30)*/ payor, intm_no,
                         /*SUBSTR (intm_name, 1, 30)*/ intm_name, effect_date, age, amount
                    FROM giac_coll_analysis_ext
                   WHERE 1 = 1
                     AND date_from = p_date_from
                     AND date_to = p_date_to
                     AND user_id = UPPER (p_user)
                     AND (DECODE(p_rep_type, 'BRANCH', DECODE(p_branch_cd, NULL, 'HO', branch_cd)) = NVL(p_branch_cd,'HO') OR 
                          DECODE(p_rep_type, 'INTM', DECODE(p_intm_no, NULL, 0, intm_no)) = NVL(p_intm_no,0))
                     AND check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS078', p_user) = 1
                     --
                   ORDER BY 1  )
        LOOP
            rep.branch_intm     := i.branch_intm;
            rep.policy_no       := i.policy_no;
            rep.or_no           := i.or_no;
            rep.iss_cd          := i.iss_cd;
            rep.prem_seq_no     := i.prem_seq_no;
            rep.payor           := i.payor;
            rep.intm_no         := i.intm_no;
            rep.intm_name       := i.intm_name;
            rep.effect_date     := TO_CHAR(i.effect_date, GET_REP_DATE_FORMAT);
            rep.age             := i.age;
            rep.amount          := i.amount;
            rep.cf_inv_no       := CF_INV_NO(i.iss_cd, i.prem_seq_no);
            rep.cf_column_no    := CF_COLUMN_NO(i.age);
            
            IF rep.cf_column_no = 0 THEN
                rep.cf_amount   := i.amount;
            ELSE
                rep.cf_amount   := 0;
            END IF;
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_details;
    
    
    FUNCTION get_analysis_title
        RETURN coll_analysis_title_tab PIPELINED
    AS
        rep     coll_analysis_title_type;
    BEGIN
        FOR i IN (SELECT column_no, column_title  
                    FROM giac_coll_analysis_title
                   ORDER BY column_no)
        LOOP            
            rep.column_no       := i.column_no;
            rep.column_title    := i.column_title;
            
            PIPE ROW(rep);
        END LOOP;
    END get_analysis_title;
    
    
    FUNCTION get_analysis_column_details(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_rep_type      VARCHAR2,
        p_branch_cd     giac_coll_analysis_ext.BRANCH_CD%type,
        p_intm_no       giac_coll_analysis_ext.INTM_NO%type,
        p_user          giac_coll_analysis_ext.USER_ID%type,
        p_branch_intm   VARCHAR2,
        p_policy_no     giac_coll_analysis_ext.POLICY_NO%type,
        p_or_no         VARCHAR2,
        --intm_no         giac_coll_analysis_ext.INTM_NO%type,
        p_age           giac_coll_analysis_ext.AGE%type
    ) RETURN analysis_column_details_tab PIPELINED
    AS
        rep             analysis_column_details_type;
        v_cf_column_no  NUMBER(10);
    BEGIN
        FOR i IN (SELECT RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)) branch_intm, policy_no,
                         or_pref || '-' || LPAD(or_no,10,0) or_no, iss_cd, LPAD(prem_seq_no,12,0) prem_seq_no,
                         /*SUBSTR (payor, 1, 30)*/ payor, intm_no,
                         /*SUBSTR (intm_name, 1, 30)*/ intm_name, effect_date, age, amount
                    FROM giac_coll_analysis_ext
                   WHERE 1 = 1
                     AND date_from = p_date_from
                     AND date_to = p_date_to
                     AND user_id = UPPER (p_user)
                     AND (DECODE(p_rep_type, 'BRANCH', DECODE(p_branch_cd, NULL, 'HO', branch_cd)) = NVL(p_branch_cd,'HO') OR 
                          DECODE(p_rep_type, 'INTM', DECODE(p_intm_no, NULL, 0, intm_no)) = NVL(p_intm_no,0))
                     AND check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS078', p_user) = 1
                     --
                     AND RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)) = 
                                            NVL(p_branch_intm, RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)))
                     AND policy_no = NVL(p_policy_no, policy_no)
                     AND or_pref || '-' || LPAD(or_no,10,0) = NVL(p_or_no, or_pref || '-' || LPAD(or_no,10,0))
                     --AND intm_no = p_intm_no
                     AND age = NVL(p_age, age)
                   ORDER BY 1 )
        LOOP
            rep.branch_intm     := i.branch_intm;
            rep.policy_no       := i.policy_no;
            rep.or_no           := i.or_no;
            rep.intm_no         := i.intm_no;
            rep.age             := i.age;
            
            FOR j IN (SELECT column_no, column_title  
                        FROM giac_coll_analysis_title
                       ORDER BY column_no)
            LOOP
                rep.column_no       := j.column_no;
                rep.column_title    := j.column_title;
                
                FOR k IN (SELECT RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)) branch_intm, policy_no,
                                 or_pref || '-' || LPAD(or_no,10,0) or_no, iss_cd, LPAD(prem_seq_no,12,0) prem_seq_no, payor, intm_no,
                                 intm_name intm_name1, effect_date, age, amount
                            FROM giac_coll_analysis_ext
                           WHERE 1 = 1
                             AND date_from = p_date_from
                             AND date_to = p_date_to
                             AND user_id = UPPER (p_user)
                             AND (DECODE(p_rep_type, 'BRANCH', DECODE(p_branch_cd, NULL, 'HO', branch_cd)) = NVL(p_branch_cd,'HO') OR 
                             DECODE(p_rep_type, 'INTM', DECODE(p_intm_no, NULL, 0, intm_no)) = NVL(p_intm_no,0))
                             AND check_user_per_iss_cd_acctg2(NULL, iss_cd, 'GIACS078', p_user) = 1
                             --
                             AND RTRIM (RPAD (DECODE(p_rep_type, 'BRANCH', branch_cd, 'INTM', intm_name), 240)) = i.branch_intm
                             AND policy_no = i.policy_no
                             AND or_pref || '-' || LPAD(or_no,10,0) = i.or_no
                             AND intm_no = i.intm_no
                             AND age = i.age
                        ORDER BY 1)
                LOOP
                    v_cf_column_no    := CF_COLUMN_NO(k.age);
                
                    IF v_cf_column_no = j.column_no THEN
                        rep.cf_amount   := k.amount;
                    ELSE
                        rep.cf_amount   := 0;
                    END IF;
                        
                    PIPE ROW(rep);
                END LOOP;
            END LOOP;
            
        END LOOP;
    END get_analysis_column_details;

END GIACR078_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIRIR036_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.14.2013
     ** Referenced By:  GIRIR036 - Outstanding Binders Report
     **/
     
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name      giis_parameters.PARAM_VALUE_V%type;
    BEGIN
        FOR A IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
  	        v_company_name := A.param_value_v;
        END LOOP;
  
        RETURN(v_company_name);
    END CF_COMPANY_NAME;
        
      
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_company_addr      giis_parameters.PARAM_VALUE_V%type ;
    BEGIN
        FOR A IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_ADDR')
        LOOP
  	        v_company_addr := A.param_value_v;
        END LOOP;
  
        RETURN(v_company_addr);
    END CF_COMPANY_ADDRESS;
        
        
    FUNCTION CF_SALUTATION
        RETURN VARCHAR2
    AS
        v_text          VARCHAR2(2000);
    BEGIN
        FOR A IN (SELECT text
                    FROM giis_document
                   WHERE report_id = 'GIRIR036'
                     AND title = 'SALUTATION')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_SALUTATION;
        
        
    FUNCTION CF_TEXT1
        RETURN VARCHAR2
    AS
        v_text          VARCHAR2(2000);
    BEGIN
        FOR A IN (SELECT text
                    FROM giis_document
                   WHERE report_id = 'GIRIR036'
                     AND title = 'TEXT_1')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_TEXT1;
    
    
    FUNCTION CF_TEXT2
        RETURN VARCHAR2
    AS
        v_text          VARCHAR2(2000);
    BEGIN
        FOR A IN (SELECT text
                    FROM giis_document
                   WHERE report_id = 'GIRIR036'
                     AND title = 'TEXT_2')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_TEXT2;
        
        
    FUNCTION CF_TEXT3
        RETURN VARCHAR2
    AS
        v_text          VARCHAR2(2000);
    BEGIN
        FOR A IN (SELECT text
                    FROM giis_document
                   WHERE report_id = 'GIRIR036'
                     AND title = 'TEXT_3')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_TEXT3;
        
        
    FUNCTION CF_DOC_DEPT_DESIGNATION
        RETURN VARCHAR2
    AS
        v_text          VARCHAR2(2000);
    BEGIN
        FOR A IN (SELECT text
                    FROM giis_document
                   WHERE report_id = 'GIRIR036'
                     AND title = 'DOC_DEPT_DESIGNATION')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_DOC_DEPT_DESIGNATION;
        
    
    FUNCTION get_report_details (
        p_ri_cd         GIRI_BINDER.RI_CD%TYPE,
        p_line_cd       GIRI_BINDER.LINE_CD%TYPE,
        p_from_date     GIRI_BINDER.BINDER_DATE%TYPE,
        p_to_date       GIRI_BINDER.BINDER_DATE%TYPE
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name            := CF_COMPANY_NAME;
        rep.company_address         := CF_COMPANY_ADDRESS;
        rep.cf_salutation           := CF_SALUTATION;
        rep.cf_text1                := CF_TEXT1;
        rep.cf_text2                := CF_TEXT2;
        rep.cf_text3                := CF_TEXT3;
        rep.cf_doc_dept_designation := CF_DOC_DEPT_DESIGNATION;
        
        FOR i IN  ( SELECT DISTINCT  I.assd_name, A.ri_cd, A.fnl_binder_id, H.line_cd,
                           E.LINE_CD || '-' ||  E.SUBLINE_CD || '-' || E.ISS_CD || '-' || LTRIM(TO_CHAR(E.ISSUE_YY, '09')) || '-' || 
                                    LTRIM(TO_CHAR(E.POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(E.RENEW_NO, '09'))||DECODE(E.REG_POLICY_SW,'N',' **') POLICY_NO, 
                           E.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(E.ENDT_YY, '09')) || '-' || LTRIM(TO_CHAR(E.ENDT_SEQ_NO, '099999')) ENDT_NO, 
                           E.ENDT_SEQ_NO, 
                           A.line_cd || '-' || LTRIM(TO_CHAR(A.binder_yy, '09')) || '-'  || LTRIM(TO_CHAR(A.binder_seq_no, '09999')) BINDER_NUMBER, 
                           NVL(p_ri_cd, A.ri_cd) RI_CD2, 
                           NVL(p_line_cd, A.line_cd) LINE_CD2 , 
                           C.line_name LINE_NAME, B.ri_name RI_NAME, A.binder_date, A.fnl_binder_id fnl_binder_id2, 
                           B.mail_address1, B.mail_address2, B.mail_address3
                      FROM gipi_parlist D,
                           gipi_polbasic E,
                           giuw_pol_dist F, 
                           giri_frps_ri H,
                           giri_distfrps G,
                           giri_binder A, 
                           giis_assured I,
                           giis_reinsurer B,
                           giis_line C  
                     WHERE A.binder_date >= (SELECT MIN(binder_date) FROM giri_binder) 
                       AND A.binder_date >=NVL(p_from_date, A.binder_date)
                       AND A.binder_date <= p_to_date
                       /*
                       AND A.binder_date BETWEEN NVL(:from_date,(SELECT MIN(binder_date) FROM giri_binder)) AND :to_date
                       */
                       AND A.ri_cd = B.ri_cd
                       AND A.line_cd = C.line_cd
                       AND A.reverse_date is null
                       AND (A.confirm_no is null OR A.confirm_date is null)
                       AND A.ri_cd = NVL( p_ri_cd, A.ri_cd)
                       AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                       AND D.par_id = E.par_id
                       AND I.assd_no = D.assd_no
                       AND E.policy_id = F.policy_id
                       AND F.dist_no = G.dist_no
                       AND G.line_cd = H.line_cd
                       AND G.frps_yy = H.frps_yy
                       AND G.frps_seq_no = H.frps_seq_no
                       AND A.fnl_binder_id = H.fnl_binder_id 
                       AND E.pol_flag IN ('1', '2', '3')
                       AND F.negate_date IS NULL
                       AND E.REG_POLICY_SW <> 'N'
                     ORDER BY A.RI_CD, C.LINE_NAME )
        LOOP
            rep.ri_cd           := i.ri_cd;
            rep.fnl_binder_id   := i.fnl_binder_id;
            rep.line_cd         := i.line_cd;
            rep.assd_name       := i.assd_name;
            rep.ri_cd2          := i.ri_cd2;
            rep.ri_name         := i.ri_name;
            rep.fnl_binder_id2  := i.fnl_binder_id2;
            rep.line_cd         := i.line_cd2;
            rep.line_name       := i.line_name;
            rep.mail_address1   := i.mail_address1;
            rep.mail_address2   := i.mail_address2;
            rep.mail_address3   := i.mail_address3;
            rep.policy_no       := i.policy_no;
            rep.endt_no         := i.endt_no;
            rep.endt_seq_no     := i.endt_seq_no;
            rep.binder_date     := i.binder_date;
            rep.binder_number   := i.binder_number;
        
            PIPE ROW(rep);
        END LOOP;
        
    END get_report_details;
    

END GIRIR036_PKG;
/



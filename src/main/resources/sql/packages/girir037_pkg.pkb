CREATE OR REPLACE PACKAGE BODY CPI.GIRIR037_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.14.2013
     ** Referenced By:  GIRIR037 - Outstanding Outward Binders
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
                   WHERE report_id = 'GIRIR037'
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
                   WHERE report_id = 'GIRIR037'
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
                   WHERE report_id = 'GIRIR037'
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
                   WHERE report_id = 'GIRIR037'
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
                   WHERE report_id = 'GIRIR037'
                     AND title = 'DOC_DEPT_DESIGNATION')
        LOOP
  	        v_text := A.text;
  	        EXIT;
        END LOOP;
  
        RETURN(v_text);
    END CF_DOC_DEPT_DESIGNATION;
        
    
    FUNCTION get_report_details(
        p_ri_cd                 GIRI_INPOLBAS.RI_CD%type,
        p_line_cd               GIPI_POLBASIC.LINE_CD%type,
        p_oar_print_date        VARCHAR2,
        p_date_sw               VARCHAR2,
        p_morethan              NUMBER,
        p_lessthan              NUMBER
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
        rep.exist                   := 'N';
        
        FOR i IN  ( SELECT e.accept_date,
                           (TRUNC(SYSDATE)-TRUNC(e.accept_date)) no_of_days,
                           E.ri_cd RI_CD,
                           A.line_cd LINE_CD,
                           C.line_name LINE_NAME,
                           B.ri_name RI_NAME,
                           B.mail_address1,
                           B.mail_address2,
                           B.mail_address3,
                           D.assd_name,
                           TO_NUMBER('0.00') AMOUNT_OFFERED, --marion 05.17.2010
                           TO_CHAR(A.eff_date,'MON-DD-RR')||'/'||NVL(TO_CHAR(A.endt_expiry_date,'MON-DD-RR'), TO_CHAR(A.expiry_date, 'MON-DD-RR')) TERM,
                           E.accept_no,
                           E.ri_policy_no,
                           E.ri_endt_no
                      FROM GIIS_ASSURED D, 
                           GIPI_POLBASIC A, 
                           GIRI_INPOLBAS E, 
                           GIIS_REINSURER B, 
                           GIIS_LINE C          
                     WHERE B.ri_cd = E.ri_cd
                       AND E.ri_cd = NVL( p_ri_cd, E.ri_cd)
                       AND A.line_cd = C.line_cd
                       AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                       AND A.policy_id = E.policy_id  
                       AND A.pol_flag IN ('1', '2', '3')
                       AND A.assd_no = D.assd_no 
                       AND A.REG_POLICY_SW <> 'N'   --added by cris on 021709 to eliminate special policies from the report
                       AND e.accept_date <= TRUNC(SYSDATE) --petermkaw 03162010
                       AND e.ri_binder_no IS NULL   --petermkaw
                       AND ((NVL(trunc(e.oar_print_date),'01-JAN-1990') = NVL(TO_DATE(p_oar_print_date,'MM-DD-RRRR'),NVL(trunc(e.oar_print_date),'01-JAN-1990'))) OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL))
                       AND ((NVL(trunc(TO_DATE(p_oar_print_date,'MM-DD-RRRR')),TRUNC(SYSDATE)) - trunc(e.accept_date)) BETWEEN TO_NUMBER(p_morethan) AND TO_NUMBER(p_lessthan))
                      --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                      --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                      --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                      --(sysdate) no oar_print_date with date accept <= sysdate. 
                      --added by petermkaw from enhancement of giris051
                     UNION
                    SELECT e.accept_date, 
                           (TRUNC(SYSDATE)-TRUNC(e.accept_date)) no_of_days,
                           E.ri_cd RI_CD,
                           A.line_cd LINE_CD,
                           C.line_name LINE_NAME,
                           B.ri_name RI_NAME,
                           B.mail_address1,
                           B.mail_address2,
                           B.mail_address3,
                           D.assd_name,
                           NVL(E.amount_offered,0.00) AMOUNT_OFFERED, --marion 05.17.2010
                           TO_CHAR(A.eff_date,'MON-DD-RR')||'/'||NVL(TO_CHAR(A.endt_expiry_date,'MON-DD-RR'), TO_CHAR(A.expiry_date,'MON-DD-RR')) TERM,
                           E.accept_no,
                           E.ri_policy_no,
                           E.ri_endt_no
                      FROM GIIS_ASSURED D, 
                           GIPI_WPOLBAS A, 
                           GIRI_WINPOLBAS E, 
                           GIIS_REINSURER B, 
                           GIIS_LINE C          
                     WHERE B.ri_cd = E.ri_cd
                       AND E.ri_cd = NVL( p_ri_cd, E.ri_cd)
                       AND A.line_cd = C.line_cd
                       AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                       AND A.par_id = E.par_id  
                       AND A.pol_flag IN ('1', '2', '3')
                       AND A.assd_no = D.assd_no  
                       AND e.accept_date <= TRUNC(SYSDATE) --petermkaw 03162010
                       AND e.ri_binder_no IS NULL --petermkaw
                       AND A.REG_POLICY_SW <> 'N'  -- analyn 03.16.2010 to exclude special policies
                       AND ((NVL(trunc(e.oar_print_date),'01-JAN-1990') = NVL(TO_DATE(p_oar_print_date,'MM-DD-RRRR'),NVL(trunc(e.oar_print_date),'01-JAN-1990'))) OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL))
                       AND ((NVL(trunc(TO_DATE(p_oar_print_date,'MM-DD-RRRR')),TRUNC(SYSDATE)) - trunc(e.accept_date)) BETWEEN TO_NUMBER(p_morethan) AND TO_NUMBER(p_lessthan))
                      --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                      --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                      --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                      --(sysdate) no oar_print_date with date accept <= sysdate. 
                      --added by petermkaw from enhancement of giris051
                     UNION
                    SELECT e.accept_date, 
                           (TRUNC(SYSDATE)-TRUNC(e.accept_date)) no_of_days,
                           E.ri_cd RI_CD, 
                           A.line_cd LINE_CD, 
                           C.line_name LINE_NAME, 
                           B.ri_name RI_NAME,
                           B.mail_address1,
                           B.mail_address2,
                           B.mail_address3,
                           D.assd_name,
                           NVL(E.AMOUNT_OFFERED,0.00) AMOUNT_OFFERED, --marion 05.17.2010
                           NULL TERM,
                           E.accept_no,
                           E.ri_policy_no,
                           E.ri_endt_no
                      FROM GIIS_ASSURED D, 
                           GIPI_PARLIST A, 
                           GIRI_WINPOLBAS E, 
                           GIIS_REINSURER B, 
                           GIIS_LINE C          
                     WHERE B.ri_cd = E.ri_cd
                       AND E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                       AND A.line_cd = C.line_cd
                       AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                       AND A.par_id = E.par_id  
                       AND A.assd_no = D.assd_no  
                       AND A.par_status = 2 -- analyn 03.23.2010
                       AND e.accept_date <= TRUNC(SYSDATE) --petermkaw 03162010
                       AND e.ri_binder_no IS NULL --petermkaw
                       AND ((NVL(trunc(e.oar_print_date),'01-JAN-1990') = NVL(TO_DATE(p_oar_print_date,'MM-DD-RRRR'),NVL(trunc(e.oar_print_date),'01-JAN-1990'))) OR (p_date_sw = 1 AND e.oar_print_date IS NOT NULL))
                       AND ((NVL(trunc(TO_DATE(p_oar_print_date,'MM-DD-RRRR')),TRUNC(SYSDATE)) - trunc(e.accept_date)) BETWEEN TO_NUMBER(p_morethan) AND TO_NUMBER(p_lessthan))
                      --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                      --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                      --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                      --(sysdate) no oar_print_date with date accept <= sysdate. 
                       AND NOT EXISTS (SELECT c.par_id  --petermkaw 02232010
                                         FROM GIPI_WPOLBAS c
                                        WHERE e.par_id = c.par_id) 
                       --added by petermkaw from enhancement of giris051
                     ORDER BY RI_CD )
        LOOP
            rep.ri_cd           := i.ri_cd;
            rep.ri_name         := i.ri_name;
            rep.mail_address1   := i.mail_address1;
            rep.mail_address2   := i.mail_address2;
            rep.mail_address3   := i.mail_address3;
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.assd_name       := i.assd_name;
            rep.ri_policy_no    := i.ri_policy_no;
            rep.ri_endt_no      := i.ri_endt_no;
            rep.accept_no       := i.accept_no;
            rep.term            := i.term;
            rep.no_of_days      := i.no_of_days;
            rep.accept_date     := i.accept_date;
            rep.amount_offered  := i.amount_offered;
            
            --CF_RI_POLICY_ENDT
            BEGIN
                IF i.RI_ENDT_NO IS NULL THEN
  	                rep.cf_ri_policy_endt   := i.RI_POLICY_NO;
                ELSE 
  	                rep.cf_ri_policy_endt   := i.RI_POLICY_NO||'/'||i.RI_ENDT_NO;
                END IF;
            END;
            
            --format trigger
            IF GIISP.V('ORA2010_SW') = 'Y' THEN
                rep.print_fields     := 'Y';
            ELSE
  	            rep.print_fields     := 'N';
            END IF;
            
            rep.exist := 'Y';
            
            PIPE ROW(rep);
        END LOOP;
        
        IF rep.exist = 'N' THEN
           PIPE ROW(rep);
        END IF;
       
    END get_report_details;
    

END GIRIR037_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIRIR114_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.06.2013
     ** Referenced By:  GIRIR114 - Inward Reinsurance Expiry List
     **/
     
     
     FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
     AS
        v_company    giis_parameters.param_value_v%TYPE;
     BEGIN
        FOR A IN (SELECT param_value_v name
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company := a.name;
        END LOOP;
        
        RETURN(v_company);
     END CF_COMPANY_NAME;
     
     
     FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
     AS
        v_address varchar2(500);
     BEGIN
        select param_value_v
          into v_address
          from giis_parameters 
         where param_name = 'COMPANY_ADDRESS';
         
        return(v_address);
        
     RETURN NULL; exception
        when no_data_found then null;
            return(v_address);
     
     END CF_COMPANY_ADDRESS;
     
     
     FUNCTION CF_TEXT1
        RETURN VARCHAR2
     AS
        v_text       giis_document.text%TYPE;
     BEGIN
        FOR A IN (SELECT text
                    FROM giis_document 
                   WHERE title = 'INW_RI_EXPIRY_NOTICE_TEXT1')
        LOOP
            v_text := a.text;
        END LOOP;
        
        RETURN(v_text);
     END CF_TEXT1;
     
     
     FUNCTION CF_TEXT2
        RETURN VARCHAR2
     AS
        v_text       giis_document.text%TYPE;
     BEGIN
        FOR A IN (SELECT text
                    FROM giis_document 
                   WHERE title = 'INW_RI_EXPIRY_NOTICE_TEXT2')
        LOOP
            v_text := a.text;
        END LOOP;
        
        RETURN(v_text);
     END CF_TEXT2;
     
     
     FUNCTION CF_SIGN_NAME
        RETURN VARCHAR2
     AS
        v_sign_name    giis_parameters.param_value_v%TYPE;
     BEGIN
        FOR A IN (SELECT param_value_v name 
                    FROM giis_parameters
                   WHERE param_name = 'RI SIGNATORY NAME')
        LOOP
            v_sign_name := a.name;
        END LOOP;
        
        RETURN(v_sign_name);
     END CF_SIGN_NAME;
     
     
     FUNCTION CF_SIGN_POSITION
        RETURN VARCHAR2
     AS
        v_sign_position    giis_parameters.param_value_v%TYPE;
     BEGIN
        FOR A IN (SELECT param_value_v name 
                    FROM giis_parameters
                   WHERE param_name = 'RI SIGNATORY POSITION')
        LOOP
            v_sign_position := a.name;
        END LOOP;
        
        RETURN(v_sign_position);
     END CF_SIGN_POSITION;
          
     
     FUNCTION CF_LINE_NAME(
        p_line_cd   GIXX_INW_TRAN.LINE_CD%TYPE
     ) RETURN VARCHAR2
     AS
        v_line    giis_line.line_name%TYPE;
     BEGIN
        FOR A IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = p_line_cd)
        LOOP
            v_line := a.line_name;
        END LOOP;
        
        return(v_line);
     END CF_LINE_NAME;
     
     
     FUNCTION CF_ASSD_NAME(
        p_assd_no   GIXX_INW_TRAN.ASSD_NO%TYPE
     ) RETURN VARCHAR2
     AS
        v_name     giis_assured.assd_name%TYPE;
     BEGIN
        FOR A IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = p_assd_no)
        LOOP
            v_name   := a.assd_name;
        END LOOP;
        
        return(v_name);
     END CF_ASSD_NAME;
         
     
     FUNCTION get_report_details(
        p_extract_id    gixx_inw_tran.EXTRACT_ID%type,
        p_month         varchar2,
        p_year          number
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.paramdate           := 'FOR THE MONTH OF '|| LTRIM(P_MONTH)|| ', '||LTRIM(TO_CHAR(P_YEAR));
        rep.cf_text1            := CF_TEXT1;
        rep.cf_text2            := CF_TEXT2;
        rep.cf_sign_name        := CF_SIGN_NAME;
        rep.cf_sign_position    := CF_SIGN_POSITION;
        
        FOR i IN ( SELECT DISTINCT  b.ri_cd, /*b.extract_id,*/  a.ri_name, 
                          A.mail_address1, a.mail_address2, a.mail_address3
                     FROM giis_reinsurer a, gixx_inw_tran b
                    WHERE a.ri_cd = b.ri_cd
                      AND extract_id =  p_extract_id
                    ORDER BY ri_name)
        LOOP
            rep.ri_cd           := i.ri_cd;
            rep.ri_name         := i.ri_name;
            rep.mail_address1   := i.mail_address1;
            rep.mail_address2   := i.mail_address2;
            rep.mail_address3   := i.mail_address3;
            
            FOR j IN (  SELECT ri_cd, extract_id, line_cd, policy_no, ri_policy_no, 
                               orig_tsi_amt, our_tsi_amt, accept_date, expiry_date, assd_no
                          FROM gixx_inw_tran
                         WHERE extract_id = p_extract_id
                           AND ri_cd = i.ri_cd
                         ORDER BY line_cd, policy_no)
            LOOP
                rep.extract_id      := j.extract_id;
                rep.line_cd         := j.line_cd;
                rep.cf_line_name    := CF_LINE_NAME(j.line_cd);
                rep.policy_no       := j.policy_no;
                rep.ri_policy_no    := j.ri_policy_no;
                rep.orig_tsi_amt    := j.orig_tsi_amt;
                rep.our_tsi_amt     := j.our_tsi_amt;
                rep.accept_date     := j.accept_date;
                rep.expiry_date     := j.expiry_date;
                rep.assd_no         := j.assd_no;
                rep.cf_assd_name    := CF_ASSD_NAME(j.assd_no);
                
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
        
    END get_report_details;
    

END GIRIR114_PKG;
/



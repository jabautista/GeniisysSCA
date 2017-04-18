CREATE OR REPLACE PACKAGE BODY CPI.GIRIR029_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.22.2013
     ** Referenced By:  GIRIR029 - RI Facultative Reciprocity Report
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name  giis_parameters.PARAM_VALUE_V%type;
    BEGIN
        SELECT param_value_v
          INTO v_company_name
          FROM GIIS_PARAMETERS
         WHERE param_name = 'COMPANY_NAME';       
        
        RETURN (v_company_name);
    END CF_COMPANY_NAME;
    
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_address   varchar2(500);
    BEGIN
        select param_value_v
          into v_address
          from giis_parameters
         where param_name = 'COMPANY_ADDRESS';
         
        return (v_address);
    RETURN NULL; EXCEPTION
        when no_data_found then
            null;
        return (v_address);
    END CF_COMPANY_ADDRESS;

    
    FUNCTION CF_DATE_PARAM(
        p_user_id   giri_fac_reciprocity.USER_ID%type
    ) RETURN VARCHAR2
    AS
        v_inward        giri_fac_reciprocity.INWARD_PARAM%type;
        v_outward       giri_fac_reciprocity.OUTWARD_PARAM%type;
        v_date_param1   varchar2(30);
        v_date_param2   varchar2(30);
    BEGIN
        select distinct inward_param, outward_param
          into v_inward, v_outward
          from giri_fac_reciprocity
         where user_id = p_user_id;
         
        IF v_inward = 'EFFECTIVITYDATE' THEN
            v_date_param1 := 'Effectivity Date / ';
        ELSIF v_inward = 'ISSUEDATE' THEN
            v_date_param1 := 'Issue Date / ';
        ELSIF v_inward = 'ACCEPTDATE' THEN
            v_date_param1 := 'Accept Date / ';
        ELSIF v_inward = 'ACCTENTDATE' THEN
            v_date_param1 := 'Acctg Entry Date / ';
        ELSIF v_inward = 'BOOKINGDATE' THEN
            v_date_param1 := 'Booking Date / ';
        END IF;   
        
        
        IF v_outward = 'INCEPTIONDATE' THEN
            v_date_param2 := 'Inception Date';
        ELSIF v_outward = 'BINDERDATE' THEN
            v_date_param2 := 'BinderDate';
        ELSIF v_outward = 'ACCTENTDATE' THEN
            v_date_param2 := 'Acctg Entry Date';
        END IF;
        
        RETURN(v_date_param1 || v_date_param2);
        
    EXCEPTION
        WHEN too_many_rows or no_data_found THEN
            NULL;
        RETURN null;
    
    END CF_DATE_PARAM;
    
    
    FUNCTION CF_DATE_VALUE(
        p_user_id   giri_fac_reciprocity.USER_ID%TYPE
    ) RETURN VARCHAR2
    AS
        v_from          giri_fac_reciprocity.FROM_DATE%type;
        v_to            giri_fac_reciprocity.TO_DATE%type;
        v_date_param1   varchar2(30);
        v_date_param2   varchar2(30);
    BEGIN
        select distinct from_date, to_date
          into v_from, v_to
          from giri_fac_reciprocity
         where user_id = p_user_id;
         
        v_date_param1 := TO_CHAR(v_from, 'fmMonth DD, RRRR');
        v_date_param2 := TO_CHAR(v_to, 'fmMonth DD, RRRR');
        
        RETURN ('From ' || v_date_param1 || ' to ' || v_date_param2);
    
    EXCEPTION
        WHEN too_many_rows or no_data_found THEN
            RETURN null;
            
    END CF_DATE_VALUE;

    FUNCTION get_report_details(
        p_ri_cd     GIRI_FAC_RECIPROCITY.RI_CD%TYPE,
        p_user_id   GIRI_FAC_RECIPROCITY.USER_ID%TYPE
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.cf_date_param       := CF_DATE_PARAM(p_user_id);
        rep.cf_date_value       := CF_DATE_VALUE(p_user_id);
        
        FOR i IN  ( SELECT A150.LINE_NAME 
                           ,A1801.RI_NAME RI_NAME
                           ,sum(D1402.APREM_AMT) ASSM_FACUL
                           ,sum(D1402.CPREM_AMT) CED_FACUL
                           ,NVL(sum(D1402.APREM_AMT),0)- NVL(sum(D1402.CPREM_AMT),0)  VAR_FACUL
                           --,(sum((D1402.APREM_AMT) - SUM(D1402.CPREM_AMT))) VAR_FACUL
                           ,sum((D1402.ALOSS_AMT/D1402.APREM_AMT) * 100) ALOSS_FACUL
                           ,sum((D1402.CLOSS_AMT/D1402.CPREM_AMT) * 100) CLOSS_FACUL
                      FROM GIRI_FAC_RECIPROCITY D1402
                           ,GIIS_REINSURER A1801
                           ,GIIS_LINE A150
                     WHERE A1801.RI_CD = D1402.RI_CD
                       AND A150.LINE_CD = D1402.LINE_CD
                       AND D1402.user_id = p_user_id
                       AND D1402.ri_cd = nvl(p_ri_cd, D1402.ri_cd) 
                     GROUP BY A150.LINE_NAME
                              ,A1801.RI_NAME 
                       /*
                       AND TO_CHAR(TO_DATE(D1402.TRAN_YY,'RR'),'YYYY') = :YEAR_V
                       AND UPPER(A1801.RI_SNAME) = UPPER(NVL(:REINSURER_V, A1801.RI_SNAME))
                       AND UPPER(TO_CHAR(TO_DATE(D1402.TRAN_MM,'MM'),'FMMonth')) = UPPER(NVL(:MONTH_V, TO_CHAR(TO_DATE(D1402.TRAN_MM,'MM'),'FMMonth')))
                       */ 
                      ORDER BY A1801.RI_NAME, A150.LINE_NAME )
        LOOP
            rep.ri_name     := i.ri_name;
            rep.line_name   := i.line_name;
            rep.assm_facul  := i.assm_facul;
            rep.ced_facul   := i.ced_facul;
            rep.var_facul   := i.var_facul;
            rep.aloss_facul := i.aloss_facul;
            rep.closs_facul := i.closs_facul;
        
            PIPE ROW(rep);
        END LOOP;
        
    END get_report_details;
    
END GIRIR029_PKG;
/



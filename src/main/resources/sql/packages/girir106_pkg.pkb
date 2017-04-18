CREATE OR REPLACE PACKAGE BODY CPI.GIRIR106_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.16.2013
     ** Referenced By:  GIRIR106 - Facultative Reinsurance Register Report (Detailed)
     **/    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name  giis_parameters.PARAM_VALUE_V%type;
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giis_parameters
	               WHERE param_name = 'COMPANY_NAME')  
        LOOP
            v_company_name := c.param_value_v;
        END LOOP;
        RETURN(v_company_name);
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
        when no_data_found then 
            null;
        
        return(v_address);
    END CF_COMPANY_ADDRESS;
        
        
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       VARCHAR2
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        
        IF p_report_month IS NOT NULL AND p_report_year IS NOT NULL THEN
            rep.cf_paramdate    := 'FOR THE MONTH OF ' || UPPER(p_report_month) || ', ' || p_report_year;
        END IF;
        
        FOR i IN  ( SELECT B250.LINE_CD
                           ,A120.LINE_NAME
                           ,B250.SUBLINE_CD
                           ,A210.SUBLINE_NAME
                           ,B250.LINE_CD||'-'||RTRIM(B250.SUBLINE_CD)||'-'||RTRIM(B250.ISS_CD)||'-'||LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))||'-'||
                                   LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(B250.RENEW_NO,'09'))  POLICY_NO
                           ,B250.ENDT_ISS_CD||'-'||LTRIM(TO_CHAR(B250.ENDT_YY,'09'))||'-'||LTRIM(TO_CHAR(B250.ENDT_SEQ_NO,'099999'))  ENDT_NO
                           ,A020.ASSD_NAME
                           ,TO_CHAR(D060.DIST_NO, '09999999')||' /'    DIST_NO
                           ,LTRIM(TO_CHAR(D060.DIST_SEQ_NO,'09999'))  DIST_SEQ_NO
                           ,B250.LINE_CD||'-'||LTRIM(TO_CHAR(D060.FRPS_YY,'09'))||'-'|| LTRIM(TO_CHAR(D060.FRPS_SEQ_NO, '09999999'))||' /'  FRPS_NO
                           ,LTRIM(TO_CHAR(D060.OP_GROUP_NO,'099999')) GROUP_NO
                           ,A180.RI_NAME      
                           ,A170.PERIL_NAME 
                           ,NVL(D040.RI_TSI_AMT,0)  SUM_INSURED
                           ,NVL(D040.RI_PREM_AMT,0) PREMIUM
                           ,NVL(D040.RI_COMM_AMT,0) COMMISSION
                           ,NVL(D040.RI_PREM_AMT,0) - NVL(D040.RI_COMM_AMT,0)  NET_PREMIUM
                      FROM GIPI_POLBASIC   B250
                           ,GIIS_LINE      A120
                           ,GIIS_SUBLINE   A210
                           ,GIUW_POL_DIST  C080
                           ,GIRI_DISTFRPS  D060
                           ,GIRI_FRPERIL   D040
                           ,GIIS_PERIL     A170
                           ,GIIS_REINSURER A180
                           ,GIIS_ASSURED   A020              
                     WHERE A120.LINE_CD    = A210.LINE_CD
                       AND A210.LINE_CD    = B250.LINE_CD
                       AND A210.SUBLINE_CD = B250.SUBLINE_CD
                       AND A020.ASSD_NO    = B250.ASSD_NO
                       AND B250.POLICY_ID  = C080.POLICY_ID
                       AND C080.DIST_NO    = D060.DIST_NO
                       AND D060.LINE_CD    = D040.LINE_CD
                       AND D060.FRPS_YY    = D040.FRPS_YY
                       AND D060.FRPS_SEQ_NO = D040.FRPS_SEQ_NO
                       AND D040.RI_CD      = A180.RI_CD
                       AND D040.LINE_CD    = A170.LINE_CD
                       AND D040.PERIL_CD   = A170.PERIL_CD
                       AND B250.SPLD_FLAG  = '1'
                       AND B250.DIST_FLAG  = '3'
                       AND TO_CHAR(B250.INCEPT_DATE,'fmMONTH') = NVL(P_REPORT_MONTH,TO_CHAR(B250.INCEPT_DATE,'fmMONTH'))
                       AND TO_CHAR(B250.INCEPT_DATE,'YYYY')  = NVL(P_REPORT_YEAR,TO_CHAR(B250.INCEPT_DATE,'YYYY'))
                     ORDER BY B250.LINE_CD,
                              B250.SUBLINE_CD,
                              B250.LINE_CD||'-'||RTRIM(B250.SUBLINE_CD)||'-'||RTRIM(B250.ISS_CD)||'-'||LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))||'-'||
                                   LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(B250.RENEW_NO,'09')),  --POLICY_NO
                              TO_CHAR(D060.DIST_NO, '09999999')||' /',
                              A180.RI_NAME,
                              A170.PERIL_NAME   )
        LOOP
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.subline_cd      := i.subline_cd;
            rep.subline_name    := i.subline_name;
            rep.policy_no       := i.policy_no;
            rep.endt_no         := i.endt_no;
            rep.assd_name       := i.assd_name;
            rep.dist_no         := i.dist_no;
            rep.dist_seq_no     := i.dist_seq_no;
            rep.frps_no         := i.frps_no;
            rep.group_no        := i.group_no;
            rep.ri_name         := i.ri_name;
            rep.peril_name      := i.peril_name;
            rep.sum_insured     := i.sum_insured;
            rep.commission      := i.commission;
            rep.premium         := i.premium;
            rep.net_premium     := i.net_premium;
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_details;
    


END GIRIR106_PKG;
/



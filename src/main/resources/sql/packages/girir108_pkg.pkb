CREATE OR REPLACE PACKAGE BODY CPI.GIRIR108_PKG
AS
    /** Created By:     Shan Bati
    ** Date Created:    05.17.2012
    ** Referenced By:   GIRIR108 - Outward Reinsurance Summary Report
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
            v_company_name  := c.param_value_v;
        END LOOP;
        
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
        
        return(v_address);
    RETURN NULL; exception
        when no_data_found then
            null;
        return (v_address);
    END CF_COMPANY_ADDRESS;
    
    
    FUNCTION get_report_details(
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
    ) RETURN report_details_tab PIPELINED
    AS
        rep             report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        
        IF p_report_month IS NOT NULL AND p_report_year IS NOT NULL THEN
            rep.cf_paramdate    := 'FOR THE MONTH OF ' || UPPER(p_report_month) || ', ' || p_report_year;
        END IF;
        
        FOR i IN  ( SELECT B250.LINE_CD
                          ,A120.LINE_NAME 
                          ,B250.LINE_CD||'-'||RTRIM(B250.SUBLINE_CD)||'-'||RTRIM(B250.ISS_CD)||'-'||LTRIM(TO_CHAR(B250.ISSUE_YY,'09')) ||'-'||
                                LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(B250.RENEW_NO, '09'))   POLICY_NO
                          ,B250.LINE_CD||'-'||LTRIM(TO_CHAR(D005.BINDER_YY,'09'))||'-'||LTRIM(TO_CHAR(D005.BINDER_SEQ_NO,'099999'))     BINDER_NO
                          ,A020.ASSD_NAME  
                          ,B250.POLICY_ID           
                          ,B250.INCEPT_DATE
                          ,B250.EXPIRY_DATE
                          ,D060.TSI_AMT  SUM_INSURED
                          ,D005.RI_TSI_AMT  AMT_ACCEPTED
                          ,D005.RI_SHR_PCT  PCT_ACCEPTED 
                          ,D050.REMARKS  FRPS_RI_REMARKS
                    FROM  GIIS_LINE       A120
                          ,GIPI_POLBASIC  B250
                          ,GIIS_ASSURED   A020
                          ,GIUW_POL_DIST  C080
                          ,GIRI_DISTFRPS  D060
                          ,GIRI_FRPS_RI   D050
                          ,GIRI_BINDER    D005  
                     WHERE A120.LINE_CD       = B250.LINE_CD
                       AND B250.ASSD_NO       = A020.ASSD_NO
                       AND B250.POLICY_ID     = C080.POLICY_ID
                       AND C080.DIST_NO       = D060.DIST_NO
                       AND D060.LINE_CD       = D050.LINE_CD
                       AND D060.FRPS_YY       = D050.FRPS_YY
                       AND D060.FRPS_SEQ_NO   = D050.FRPS_SEQ_NO
                       AND D050.FNL_BINDER_ID = D005.FNL_BINDER_ID
                       AND D005.BINDER_SEQ_NO IN (SELECT MAX(BINDER2.BINDER_SEQ_NO)
                                                    FROM GIRI_BINDER BINDER2
                                                   WHERE BINDER2.LINE_CD = B250.LINE_CD
                                                     AND BINDER2.BINDER_YY = D005.BINDER_YY)
                       AND B250.SPLD_FLAG     = '1'
                       AND B250.DIST_FLAG     = '3'
                       AND TO_CHAR(B250.INCEPT_DATE,'fmMONTH') = NVL(P_REPORT_MONTH,TO_CHAR(B250.INCEPT_DATE,'fmMONTH'))
                       AND TO_CHAR(B250.INCEPT_DATE,'YYYY')  = NVL(P_REPORT_YEAR,TO_CHAR(B250.INCEPT_DATE,'YYYY'))
                     ORDER BY B250.LINE_CD )
        LOOP
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.policy_no       := i.policy_no;
            rep.policy_id       := i.policy_id;
            rep.assd_name       := i.assd_name;
            rep.binder_no       := i.binder_no;
            rep.incept_date     := i.incept_date;
            rep.expiry_date     := i.expiry_date;
            rep.sum_insured     := i.sum_insured;
            rep.amt_accepted    := i.amt_accepted;
            rep.pct_accepted    := i.pct_accepted;
            rep.frps_ri_remarks := i.frps_ri_remarks;
            
            --CF_LOC_RISK1
            BEGIN
                IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk1
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_loc_risk1 := c.loc_risk1;
                    END LOOP;
                ELSE
                    rep.cf_loc_risk1 := null;
                END IF;
            END;
            
            --CF_LOC_RISK2
            BEGIN
                IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk2
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_loc_risk2 := c.loc_risk2;
                    END LOOP;
                ELSE
                    rep.cf_loc_risk2 := null;
                END IF;
            END;            
            
            --CF_LOC_RISK3
            BEGIN
                IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk3
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_loc_risk3 := c.loc_risk3;
                    END LOOP;
                ELSE
                    rep.cf_loc_risk3 := null;
                END IF;
            END;
            
            --CF_DESTN
            BEGIN
                IF i.line_cd = 'MN' THEN
                    FOR c IN (SELECT destn
                                FROM gipi_cargo
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_destn := c.destn;
                    END LOOP;
                ELSE
                    rep.cf_destn := null;
                END IF;
            END;
            
            --CF_VESSEL_CD
            BEGIN
                IF i.line_cd = 'MN' THEN
                    FOR c IN (SELECT vessel_cd
                                FROM gipi_cargo
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_vessel_cd  := c.vessel_cd;
                    END LOOP;                    
                ELSE
                    rep.cf_vessel_cd := null;
                END IF;
            END;
            
            --CF_VESSEL_NAME
            BEGIN
                IF i.line_cd = 'MN' THEN
                    FOR c IN (SELECT vessel_name
                                FROM giis_vessel
                               WHERE vessel_cd = rep.cf_vessel_cd)
                    LOOP
                        rep.cf_vessel_name := c.vessel_name;
                    END LOOP;    
                ELSE
                    rep.cf_vessel_name := null;
                END IF;
            END;
            
            
            PIPE ROW(rep);
        END LOOP;
        
    END get_report_details;


END GIRIR108_PKG;
/



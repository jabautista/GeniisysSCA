CREATE OR REPLACE PACKAGE BODY CPI.GIRIR105_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.10.2013
     ** Referenced By:  GIRIR105 - OUTSTANDING FRPS REPORT
     **/
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name        giis_parameters.param_name%type;
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
        p_from_date     VARCHAR2 ,
        p_to_date       VARCHAR2,
        p_line_cd       GIRI_DISTFRPS_WDISTFRPS_V.LINE_CD%type
    ) RETURN report_details_tab PIPELINED
    AS
        rep         report_details_type;
        POLICYVAR	NUMBER(6);
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        
        IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            rep.paramdate   := 'INCEPT DATE FOR THE PERIOD OF ' || TO_DATE(p_from_date, 'MM-DD-RR') || ' TO ' || TO_DATE(p_to_date, 'MM-DD-RR');
        ELSIF p_from_date IS NOT NULL AND p_to_date IS NULL THEN
            rep.paramdate   := 'INCEPT DATE FROM ' || TO_DATE(p_from_date, 'MM-DD-RR');
        ELSIF p_from_date IS NULL AND p_to_date IS NOT NULL THEN
            rep.paramdate   := 'INCEPT DATE TO ' || TO_DATE(p_to_date, 'MM-DD-RR');
        ELSE
            rep.paramdate   := NULL;
        END IF;
        
        FOR i IN (SELECT A120.LINE_NAME
                       ,A210.SUBLINE_NAME
                       ,B250.LINE_CD 
                       ,B250.SUBLINE_CD
                       ,B250.PAR_POLICY_ID POLICY_ID
                       ,B250.LINE_CD||'-'||TO_CHAR(B250.FRPS_YY,'09')||'-'||LTRIM(TO_CHAR(B250.FRPS_SEQ_NO,'09999999'))||'/'  FRPS_NO
                        -- ,TO_CHAR(B250.OP_GROUP_NO,'099999')     GROUP_NO
                       ,B250.LINE_CD||'-'||RTRIM(B250.ISS_CD)||'-'||LTRIM(TO_CHAR(B250.PAR_YY,'09'))||'-'||LTRIM(TO_CHAR(B250.PAR_SEQ_NO,'0999999'))||'-'||
                               LTRIM(TO_CHAR(B250.QUOTE_SEQ_NO,'09')) PAR_NO
                       ,DECODE(POL_SEQ_NO, 0, NULL, (B250.LINE_CD||'-'||RTRIM(B250.SUBLINE_CD)||'-'||RTRIM(B250.ISS_CD)||'-'||LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))
                                ||'-'||LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(B250.RENEW_NO,'09'))))  POLICY_NO
                       ,TO_CHAR(B250.CREATE_DATE,'MM-DD-YYYY')    RI_CREATE_DT
                       ,DECODE(ENDT_SEQ_NO, 0, NULL, (B250.ENDT_ISS_CD||'-'||TO_CHAR(B250.ENDT_YY,'09')||'-'||TO_CHAR(B250.ENDT_SEQ_NO,'099999')))  ENDT_NO
                       ,B250.ASSD_NAME   ASSURED   
                       ,NVL(B250.TSI_AMT,0)    TOTAL_SUM_INSURED ,NVL(B250.TOT_FAC_TSI,0)  FACULTATIVE_AMT
                  FROM GIIS_LINE        A120
                       ,GIIS_SUBLINE    A210
                       ,GIRI_DISTFRPS_WDISTFRPS_V B250
                 WHERE A120.LINE_CD     = B250.LINE_CD
                   AND A210.LINE_CD    = B250.LINE_CD
                   AND A210.SUBLINE_CD    = B250.SUBLINE_CD
                   AND B250.INCEPT_DATE BETWEEN NVL(TO_DATE(P_FROM_DATE, 'MM-DD-RRRR'), (SELECT MIN(B250.INCEPT_DATE) 
                                                                                           FROM GIRI_DISTFRPS_WDISTFRPS_V))  
                                            AND NVL(TO_DATE(P_TO_DATE, 'MM-DD-RRRR'), (SELECT MAX(B250.INCEPT_DATE) 
                                                                                         FROM GIRI_DISTFRPS_WDISTFRPS_V))
                   AND B250.LINE_CD = NVL(P_LINE_CD, B250.LINE_CD)
                 ORDER BY B250.LINE_CD,B250.SUBLINE_CD  )
        LOOP
            rep.line_cd             := i.line_cd;
            rep.line_name           := i.line_name;
            rep.subline_cd          := i.subline_cd;
            rep.subline_name        := i.subline_name;
            rep.policy_id           := i.policy_id;
            rep.frps_no             := i.frps_no;
            rep.par_no              := i.par_no;
            rep.policy_no           := i.policy_no;
            rep.ri_create_dt        := i.ri_create_dt;
            rep.endt_no             := i.endt_no;
            rep.assured             := i.assured;
            rep.total_sum_insured   := i.total_sum_insured;
            rep.facultative_amt     := i.facultative_amt;
            
            --CF_LOCATION1
            BEGIN
                IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk1
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_location1 := c.loc_risk1;
                    END LOOP;
                ELSE
                    rep.cf_location1 := null;
                END IF;
            END;
            
            --CF_LOCATION2
            BEGIN
                 IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk2
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_location2 := c.loc_risk2;
                    END LOOP;
                ELSE
                    rep.cf_location2 := null;
                END IF;
            END;
            
            --CF_LOCATION3
            BEGIN
                 IF i.line_cd = 'FI' THEN
                    FOR c IN (SELECT loc_risk3
                                FROM gipi_fireitem
                               WHERE policy_id = i.policy_id)
                    LOOP
                        rep.cf_location3 := c.loc_risk3;
                    END LOOP;
                ELSE
                    rep.cf_location3 := null;
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
                        rep.cf_vessel_cd := c.vessel_cd;
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
            
            --CF_SHARE_PCT
            BEGIN
                rep.cf_share_pct := ((NVL(i.facultative_amt,0) / NVL(i.total_sum_insured,0) * 100));
            EXCEPTION
                WHEN ZERO_DIVIDE THEN
                    rep.cf_share_pct := null;
            END;
            
            
            --B_2 (slash bet. policy and endt no) format trigger
            FOR A IN (SELECT COUNT(*) CNT
                        FROM GIIS_LINE		A120
                             ,GIIS_SUBLINE	A210
                             ,GIRI_DISTFRPS_WDISTFRPS_V B250
                       WHERE A120.LINE_CD 	= B250.LINE_CD
                         AND A210.LINE_CD	= B250.LINE_CD
                         AND A210.SUBLINE_CD	= B250.SUBLINE_CD
                         AND B250.LINE_CD = i.LINE_CD
                         AND B250.SUBLINE_CD = i.SUBLINE_CD
                         AND B250.ENDT_SEQ_NO = 0)
            LOOP 
                POLICYVAR := A.CNT;
            END LOOP;
    	
            IF POLICYVAR = 0 THEN
                rep.print_field := 'Y';
            ELSE
                rep.print_field := 'N';
            END IF;
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_details;
    

END GIRIR105_PKG;
/



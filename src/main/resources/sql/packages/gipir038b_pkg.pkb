CREATE OR REPLACE PACKAGE BODY CPI.GIPIR038B_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.20.2013
     ** Referenced By:  GIPIR038B - Fire Statistical Report
     **/
    FUNCTION populate_report(
        p_zone_type         GIIS_PERIL.ZONE_TYPE%type,
        p_as_of_sw          VARCHAR2,
        p_expired_as_of     VARCHAR2,
        p_period_start      VARCHAR2,
        p_period_end        VARCHAR2,
        p_user              VARCHAR2
    ) RETURN report_tab PIPELINED
    AS
        rep             report_type;
        v_print         boolean := false;
        v_days          number;
        v_year          varchar2(5);
        v_expired_as_of DATE := to_date(P_EXPIRED_AS_OF, 'MM-DD-RRRR');
        v_period_start  DATE := to_date(p_period_start, 'MM-DD-RRRR');
        v_period_end    DATE := to_date(p_period_end, 'MM-DD-RRRR');
        v_peril_cd      gixx_firestat_summary.peril_cd%TYPE;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO rep.company_name
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.company_name := ' ';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO rep.company_address
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.company_address := NULL;
        END;
        
        BEGIN
            SELECT RV_MEANING||' STATISTICS' 
              INTO rep.cf_title
              FROM CG_REF_CODES
             WHERE RV_DOMAIN = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
               AND RV_LOW_VALUE = P_ZONE_TYPE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                rep.cf_title := ' ';
        END;
        
        IF P_AS_OF_SW = 'Y' THEN
		    v_days := SYSDATE - V_EXPIRED_AS_OF;	
	    ELSE
		    V_DAYS := V_PERIOD_END - V_PERIOD_START;
	    END IF;
        
        IF P_AS_OF_SW = 'Y' THEN
            v_year := to_char(V_EXPIRED_AS_OF, 'YYYY');	
        ELSE
            V_YEAR := TO_CHAR(V_PERIOD_END, 'YYYY');
        END IF;
        
        IF v_days < 364 AND P_AS_OF_SW = 'N' THEN
            rep.cf_header := 'DIRECT PREMIUMS WRITTEN FROM ' || TO_CHAR(v_period_start, 'fmMonth DD, RRRR') || ' TO ' 
                                || TO_CHAR(v_period_end, 'fmMonth DD, RRRR');
        ELSIF v_days = 364 OR v_days > 365 THEN
            rep.cf_header := 'DIRECT PREMIUMS WRITTEN FOR THE YEAR ' || v_year;
        ELSIF v_days < 364 AND P_AS_OF_SW = 'Y' THEN
            rep.cf_header := 'DIRECT PREMIUMS WRITTEN AS OF ' || TO_CHAR(v_expired_as_of, 'fmMonth DD, RRRR');
        END IF;
        
        
        FOR i IN  ( SELECT nvl(COUNT(*),0) count, nvl(TARF_CD,' ') NVL_TARF_CD,NVL(TARIFF_ZONE,' ') NVL_TARIFF_ZONE
                      FROM (SELECT DISTINCT LINE_CD,SUBLINE_CD,ISS_CD,ISSUE_YY,POL_SEQ_NO,RENEW_NO ,TARIFF_zone,tarf_cd 
                              FROM GIXX_FIRESTAT_SUMMARY
                             WHERE PERIL_CD IN (SELECT PERIL_CD
                                                  FROM GIIS_PERIL
                                                 WHERE ZONE_TYPE = P_ZONE_TYPE)
                               AND USER_ID = P_USER
                               AND AS_OF_SW = P_AS_OF_SW
                               AND (AS_OF_SW = 'Y' 
                                     AND AS_OF_DATE = V_EXPIRED_AS_OF
                                     OR AS_OF_SW = 'N' 
                                     AND DATE_FROM = V_PERIOD_START
                                     AND DATE_TO = V_PERIOD_END)
                            )
                    GROUP BY TARF_CD,TARIFF_ZONE
                    order by TARF_CD,TARIFF_ZONE)
        LOOP
            rep.count           := i.count;
            rep.nvl_tarf_cd     := i.nvl_tarf_cd;
            rep.nvl_tariff_zone := i.nvl_tariff_zone;
            
            FOR a IN (select distinct peril_cd 
	                    from gixx_firestat_summary
  	                   where user_id = p_user
  	                     and as_of_sw = p_as_of_sw) 
            LOOP
  	            v_peril_cd := a.peril_cd;
            END LOOP;
  	                           
            IF v_peril_cd = 1 and i.nvl_tariff_zone <> 'X' THEN
                rep.cf_count := 0;
            ELSE 
                rep.cf_count := i.count;
            END IF;
            
            FOR j IN  ( SELECT nvl(tarf_cd,' ') NVL_TARF_CD1, nvl(tariff_zone,' ') NVL_TARIFF_ZONE1,
                               -- TARF_CD||'(Zone '||TARIFF_ZONE||')' TARIFF, 
                               TARF_CD TARIFF, SUM(TSI_AMT) sum_tsi_amt, SUM(PREM_AMT) sum_prem_amt
                          FROM GIXX_FIRESTAT_SUMMARY 
                         WHERE PERIL_CD IN (SELECT PERIL_CD
                                              FROM GIIS_PERIL
                                             WHERE ZONE_TYPE = P_ZONE_TYPE)              
                           AND USER_ID = P_USER  	
                           AND AS_OF_SW = P_AS_OF_SW
                           AND (AS_OF_SW = 'Y' 
                                 AND AS_OF_DATE = V_EXPIRED_AS_OF
                                 OR AS_OF_SW = 'N' 
                                 AND DATE_FROM = V_PERIOD_START
                                 AND DATE_TO = V_PERIOD_END )
                           AND tarf_cd = i.nvl_tarf_cd
                           AND tariff_zone = i.nvl_tariff_zone
                        GROUP BY TARF_CD,TARIFF_ZONE
                        ORDER BY TARF_CD,TARIFF_ZONE)
            LOOP
                rep.print_details   := 'Y';
                v_print             := true;
                rep.tariff          := j.tariff;
                rep.sum_tsi_amt     := j.sum_tsi_amt;
                rep.sum_prem_amt    := j.sum_prem_amt;
                
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
        
        IF v_print = false THEN
            rep.print_details       := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;
    

END GIPIR038B_PKG;
/



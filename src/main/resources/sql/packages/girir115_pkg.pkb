CREATE OR REPLACE PACKAGE BODY CPI.GIRIR115_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.19.2013
     ** Referenced By:  GIRIR115 - Motor Statistics for LTO
     **/
     
    FUNCTION populate_report(
        p_date_param        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_year              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN report_tab PIPELINED
    AS
        rep         report_type;
        v_print     boolean := false;
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
        
        IF p_date_param = 'BY' THEN
            rep.top_date := 'For the year ending ' || p_year;
        ELSIF p_date_param = 'BD' THEN
            rep.top_date := 'For the period of ' || TO_CHAR(TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR') 
                            || ' to ' || TO_CHAR(TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR');
        END IF;
  
        FOR i IN (SELECT peril_stat_name, subline, mla_cnt, outside_mla_cnt,
                         mla_prem, outside_mla_prem, user_id, last_update
                    FROM GIXX_LTO_STAT
                   WHERE (mla_cnt <> 0 
                      OR outside_mla_cnt <> 0)
                     AND user_id = P_USER_ID
                   ORDER BY peril_stat_name, subline)
        LOOP
            rep.peril_stat_name     := i.peril_stat_name;
            rep.subline             := i.subline;
            rep.mla_cnt             := i.mla_cnt;
            rep.outside_mla_cnt     := i.outside_mla_cnt;
            rep.mla_prem            := i.mla_prem;
            rep.outside_mla_prem    := i.outside_mla_prem;
            rep.user_id             := i.user_id;
            rep.last_update         := i.last_update;
            rep.print_details       := 'Y';
            v_print                 := true;
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_print = false THEN
            rep.print_details       := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;


END GIRIR115_PKG;
/



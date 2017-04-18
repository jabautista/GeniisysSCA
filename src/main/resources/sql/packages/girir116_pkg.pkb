CREATE OR REPLACE PACKAGE BODY CPI.GIRIR116_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.20.2013
     ** Referenced By:  GIRIR116 - Motor Statistics for NLTO
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
              INTO rep.comp_name
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.comp_name := ' ';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO rep.comp_address
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.comp_address := NULL;
        END;
        
        IF p_date_param = 'BY' THEN
            rep.top_date := 'For the year ending ' || p_year;
        ELSIF p_date_param = 'BD' THEN
            rep.top_date := 'For the period of ' || TO_CHAR(TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR') 
                            || ' to ' || TO_CHAR(TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR');
        END IF;
  
        FOR i IN (SELECT coverage, peril_name, pc_count, cv_count, mc_count,
                         pc_prem, cv_prem, mc_prem, user_id,  last_update
                    FROM GIXX_NLTO_STAT
                   WHERE user_id = p_user_id
                   ORDER BY coverage, peril_name)
        LOOP
            rep.coverage        := i.coverage;
            rep.peril_name      := i.peril_name;
            rep.pc_count        := i.pc_count;
            rep.pc_prem         := i.pc_prem;
            rep.cv_count        := i.cv_count;
            rep.cv_prem         := i.cv_prem;
            rep.mc_count        := i.mc_count;
            rep.mc_prem         := i.mc_prem;
            rep.user_id         := i.user_id;
            rep.last_update     := i.last_update;
            rep.print_details   := 'Y';
            v_print             := true;
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_print = false THEN
            rep.print_details       := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;

END GIRIR116_PKG;
/



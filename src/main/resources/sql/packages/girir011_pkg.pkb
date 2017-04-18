CREATE OR REPLACE PACKAGE BODY CPI.GIRIR011_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.21.2013
     ** Referenced By:  GIRIR011 - List of Reinsurer/Broker
     **/
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name  GIIS_PARAMETERS.PARAM_VALUE_V%type;
    BEGIN
        FOR i IN (SELECT param_value_v
                    FROM GIIS_PARAMETERS
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name  := i.param_value_v;
        END LOOP;
        
        RETURN (v_company_name);
    END CF_COMPANY_NAME;
    
    
    FUNCTION get_report_details(
        p_ri_type_desc  GIIS_REINSURER_TYPE.RI_TYPE_DESC%TYPE
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        
        FOR i IN  ( select a.ri_type ||' - '|| INITCAP(b.ri_type_desc) REINSURER_TYPE, 
                           a.ri_cd, 
                           a.ri_sname RI_SHORT_NAME, 
                           INITCAP(a.ri_name) REINSURER, 
                           a.mail_address1 ||' '|| a.mail_address2 ||' '|| a.mail_address3 ADDRESS
                      from GIIS_REINSURER a, GIIS_REINSURER_TYPE b
                     where a.ri_type = b.ri_type
                       and b.ri_type_desc like nvl(p_ri_type_desc,b.ri_type_desc)
                     order by 1, 3 )
        LOOP
            rep.reinsurer_type  := i.reinsurer_type;
            rep.ri_cd           := i.ri_cd;
            rep.ri_short_name   := i.ri_short_name;
            rep.reinsurer       := i.reinsurer;
            rep.address         := i.address;
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_details;


END GIRIR011_PKG;
/



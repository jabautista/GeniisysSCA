CREATE OR REPLACE PACKAGE BODY CPI.GIPIR037C_PKG 

AS
    FUNCTION get_gipir037c_details(
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2, 
        p_user_id                VARCHAR2,
        p_zone_type              VARCHAR2                  
    )RETURN gipir037c_tab PIPELINED AS
        var                     gipir037c_type;
    BEGIN
        FOR i IN (SELECT DISTINCT c.assd_name, SUM(a.share_tsi_amt) tsi_amt, SUM(a.share_prem_amt) prem_amt, a.tarf_cd, 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'00'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0000000'))||'-'||LTRIM(TO_CHAR(a.renew_no,'00')) policy_no,
                b.tarf_desc 
                FROM gipi_firestat_extract_dtl_vw a, giis_tariff b, giis_assured c
                WHERE a.tarf_cd = b.tarf_cd
                     AND a.assd_no = c.assd_no
                     AND CHECK_USER_PER_ISS_CD2 (a.line_cd, a.iss_cd, 'GIPIS901', p_user_id) = 1
                     AND a.user_id = p_user_id
                     AND (a.as_of_sw = 'Y' AND TRUNC(a.as_of_date) = TRUNC(NVL (TO_DATE(p_as_of, 'MM-DD-RRRR'), a.as_of_date))
                          OR a.as_of_sw = 'N' AND TRUNC(a.date_from) = TRUNC(NVL (TO_DATE(p_from_date, 'MM-DD-RRRR'), a.date_from))
                                              AND TRUNC(a.date_to) = TRUNC(NVL (TO_DATE(p_to_date, 'MM-DD-RRRR') , a.date_to)))
                     AND a.zone_type = p_zone_type
                GROUP BY c.assd_name,
                         b.tarf_desc,
                         a.tarf_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no
                ORDER BY a.tarf_cd, c.assd_name
        )
        
        LOOP
            var.assd_name      :=    i.assd_name;    
            var.tsi_amt        :=    i.tsi_amt;  
            var.prem_amt       :=    i.prem_amt;    
            var.tarf_cd        :=    i.tarf_cd;   
            var.policy_no      :=    i.policy_no;   
            var.tarf_desc      :=    i.tarf_desc;
            
            FOR n IN (SELECT param_value_v 
                        FROM giis_parameters
                       WHERE UPPER(param_name) = 'COMPANY_NAME')
            LOOP
                var.company_name := n.param_value_v;
            END LOOP;
     
            FOR o IN (SELECT param_value_v 
                        FROM giis_parameters
                       WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
            LOOP
                var.company_address := o.param_value_v;
            END LOOP;
            
            IF p_date = '1' THEN
                  var.v_date := 'From '||to_char(to_date(p_from_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY')||' To '||to_char(to_date(p_to_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY');
--                var.v_date := 'From '||to_char(to_date(p_from_date, 'fmMonth DD, YYYY'))||' To '||to_char(to_date(p_to_date, 'fmMonth DD, YYYY'));
            ELSE    
--                  var.v_date := 'As of '||to_char(to_date(p_as_of, 'fmMonth DD, YYYY'));
                var.v_date := 'As of '||to_char(to_date(p_as_of, 'mm-dd-yyyy'),'fmMonth DD, YYYY');
            END IF;
            
            PIPE ROW (var);
       END LOOP;
        
    END;
    
END GIPIR037C_PKG;
/



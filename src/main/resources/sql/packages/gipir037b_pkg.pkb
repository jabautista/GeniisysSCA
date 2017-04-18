CREATE OR REPLACE PACKAGE BODY CPI.GIPIR037B_PKG


AS
    FUNCTION get_gipir037b_details(
        p_as_of_sw               gipi_firestat_zone_dtl_v.as_of_sw%TYPE,
        p_user_id                VARCHAR2, 
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2                     
    )RETURN gipir037b_tab PIPELINED AS
        var                     gipir037b_type;
    BEGIN
        FOR i IN (SELECT a.trty_name, b.assd_name, b.policy_no, b.share_tsi_amt, b.share_prem_amt
                 FROM giis_dist_share a, gipi_firestat_zone_dtl_v b
                WHERE a.share_cd = b.share_cd 
                 AND a.line_cd  = 'FI'
                        and b.user_id = p_user_id
                        and b.as_of_sw = p_as_of_sw
                ORDER BY a.trty_name, b.assd_name
        )
        
        LOOP
            var.trty_name      :=    i.trty_name;       
            var.assd_name      :=    i.assd_name;    
            var.policy_no      :=    i.policy_no;   
            var.share_tsi_amt  :=    i.share_tsi_amt;   
            var.share_prem_amt :=    i.share_prem_amt;
            
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
--  	            var.v_date := 'As of '||to_char(to_date(p_as_of, 'fmMonth DD, YYYY'));
                var.v_date := 'As of '||to_char(to_date(p_as_of, 'mm-dd-yyyy'),'fmMonth DD, YYYY');
            END IF;
            
            PIPE ROW (var);
       END LOOP;
        
    END;
    
    FUNCTION get_gipir037b_details_v2(
        p_as_of_sw               gipi_firestat_zone_dtl_v.as_of_sw%TYPE,            
        p_user_id                VARCHAR2,
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2,
        p_zone_type              VARCHAR2,  
        p_line_cd_fi             VARCHAR2                    
    )RETURN gipir037b_tab PIPELINED AS
        var                     gipir037b_type;
       v_date_from         DATE := TO_DATE(p_from_date, 'MM-DD-YYYY');
       v_date_to           DATE := TO_DATE(p_to_date, 'MM-DD-YYYY');
       v_as_of_date        DATE := TO_DATE(p_as_of, 'MM-DD-YYYY');        
    BEGIN
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
            
        IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            var.v_date := 'From '||to_char(to_date(p_from_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY')||' To '||to_char(to_date(p_to_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY');
        ELSE	
            var.v_date := 'As of '||to_char(to_date(p_as_of, 'mm-dd-yyyy'),'fmMonth DD, YYYY');
        END IF;
                    
        FOR i IN (SELECT a.dist_share_name trty_name, a.share_cd, b.assd_name,  a.line_cd
                                               || '-'
                                               || a.subline_cd
                                               || '-'
                                               || a.iss_cd
                                               || '-'
                                               || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                               || '-'
                                               || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                               || '-'
                                               || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         SUM(a.share_tsi_amt) share_tsi_amt, SUM(a.share_prem_amt) share_prem_amt
                 FROM gipi_firestat_extract_dtl_vw a, giis_assured b
                WHERE a.line_cd  = p_line_cd_fi
                  AND a.zone_type = p_zone_type
                  AND a.assd_no = b.assd_no
                  AND a.user_id = p_user_id
                  AND a.as_of_sw = p_as_of_sw
                  AND (       a.as_of_sw = 'Y'
                                 AND TRUNC(a.as_of_date) = TRUNC(NVL (v_as_of_date , a.as_of_date))
                              OR     a.as_of_sw = 'N'
                                 AND TRUNC(a.date_from) = TRUNC(NVL (v_date_from, a.date_from))
                                 AND TRUNC(a.date_to) = TRUNC(NVL (v_date_to , a.date_to))
                             )
                GROUP BY a.dist_share_name, a.share_cd, b.assd_name,
                         a.line_cd
                      || '-'
                      || a.subline_cd
                      || '-'
                      || a.iss_cd
                      || '-'
                      || LTRIM (TO_CHAR (a.issue_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                      || '-'
                      || LTRIM (TO_CHAR (a.renew_no, '09'))
                ORDER BY a.share_cd, b.assd_name
        )
        
        LOOP
            var.trty_name      :=    i.trty_name;       
            var.assd_name      :=    i.assd_name;    
            var.policy_no      :=    i.policy_no;   
            var.share_tsi_amt  :=    i.share_tsi_amt;   
            var.share_prem_amt :=    i.share_prem_amt;
            
            PIPE ROW (var);
       END LOOP;
        
    END;    
    
END GIPIR037B_PKG;
/



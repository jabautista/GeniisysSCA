CREATE OR REPLACE PACKAGE BODY CPI.GIPIR038A_PKG

AS
    FUNCTION get_gipir038a_details(
           p_zone_type          VARCHAR2,
           p_user_id            VARCHAR2,
           p_as_of_sw           VARCHAR2,
           p_expired_as_of      VARCHAR2,
           p_period_start       VARCHAR2,
           p_period_end         VARCHAR2
    )RETURN gipir038a_tab PIPELINED AS
           var                  gipir038a_type;            
    
    BEGIN
        FOR i IN (SELECT COUNT(*) count_tarf, NVL(tariff_cd,' ') nvl_tariff_cd2, NVL(tariff_zone,' ') nvl_tariff_zone2
                        FROM (SELECT DISTINCT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no,tariff_zone,tariff_cd 
                                 FROM GIXX_FIRESTAT_SUMMARY
                                 WHERE peril_cd IN (SELECT peril_cd
                                                         FROM GIIS_PERIL
                                                         WHERE zone_type = p_zone_type)
                                 AND user_id = p_user_id
                                 AND as_of_sw = p_as_of_sw
                                 AND ((as_of_sw = 'Y' AND as_of_date = to_date(p_expired_as_of, 'mm/dd/yyyy')) OR (as_of_sw = 'N' AND date_from = to_date(p_period_start, 'mm/dd/yyyy') AND date_to = to_date(p_period_end, 'mm/dd/yyyy')))
                                 AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, 'GIPIS901', p_user_id) = 1)
                        GROUP BY tariff_cd,tariff_zone
            
        )
        
           
        LOOP
            var.count_tarf          :=    i.count_tarf;               
            var.nvl_tariff_cd2      :=    i.nvl_tariff_cd2;
            var.nvl_tariff_zone2    :=    i.nvl_tariff_zone2;
            
            BEGIN
                SELECT NVL (tariff_cd, ' ') tariff_cd, NVL (tariff_zone, ' ') tariff_zone3,
                         tariff_cd || '(Zone ' || tariff_zone || ')' tariff, SUM (tsi_amt) sum_tsi_amt,
                         SUM (prem_amt) sum_prem_amt
                    INTO var.tariff_cd, var.tariff_zone3, var.tariff, var.sum_tsi_amt, var.sum_prem_amt    
                    FROM gixx_firestat_summary
                   WHERE peril_cd IN (SELECT peril_cd
                                        FROM giis_peril
                                       WHERE zone_type = p_zone_type)
                     AND user_id = p_user_id
                     AND as_of_sw = p_as_of_sw
                     AND (   (as_of_sw = 'Y' AND as_of_date = TO_DATE(p_expired_as_of, 'mm/dd/yyyy'))        
                              OR
                             (as_of_sw = 'N' AND date_from = TO_DATE(p_period_start, 'mm/dd/yyyy') AND date_to = TO_DATE(p_period_end, 'mm/dd/yyyy'))
                         )
                     AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GIPIS901', p_user_id) = 1
                     AND NVL(tariff_zone, ' ') = NVL(i.nvl_tariff_zone2, ' ')
                GROUP BY tariff_cd, tariff_zone
                ORDER BY tariff_cd, tariff_zone;
            END;
            
            BEGIN
               SELECT param_value_v
                 INTO var.company_name                
                 FROM giis_parameters
                WHERE UPPER(param_name) = 'COMPANY_NAME';
            END;
            
            BEGIN
                SELECT rv_meaning || ' STATISTICS' title
                  INTO var.title
                  FROM cg_ref_codes
                  WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                  AND rv_low_value = p_zone_type;
            END;
                       
            IF ((TRUNC(SYSDATE) - to_date(p_expired_as_of, 'mm/dd/yyyy')) >= 364) AND p_as_of_sw = 'N' THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN FOR THE YEAR ' || to_char(TRUNC(SYSDATE), 'YYYY');
            ELSIF p_as_of_sw = 'N'  THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN FROM ' || to_char(to_date(p_period_start, 'mm/dd/yyyy'), 'fmMonth DD, YYYY')|| ' TO ' || to_char(to_date(p_period_end, 'mm/dd/yyyy'), 'fmMonth DD, YYYY');
            ELSIF p_as_of_sw = 'Y' THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN AS OF ' || to_char(to_date(p_expired_as_of, 'mm/dd/yyyy'), 'fmMonth DD, YYYY');      
            END IF;    
                   
            PIPE ROW (var);
            
        END LOOP;
        
        IF var.count_tarf IS NULL OR var.count_tarf = 0 THEN
        
           --var.count_tarf := 0;
           --var.sum_tsi_amt := 0;
           --var.sum_prem_amt := 0;
           
           BEGIN
               SELECT param_value_v
                 INTO var.company_name                
                 FROM giis_parameters
                WHERE UPPER(param_name) = 'COMPANY_NAME';
            END;
            
            BEGIN
                SELECT rv_meaning || ' STATISTICS' title
                  INTO var.title
                  FROM cg_ref_codes
                  WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                  AND rv_low_value = p_zone_type;
            END;
            
             IF ((TRUNC(SYSDATE) - to_date(p_expired_as_of, 'mm/dd/yyyy')) >= 364) AND p_as_of_sw = 'N' THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN FOR THE YEAR ' || to_char(TRUNC(SYSDATE), 'YYYY');
            ELSIF p_as_of_sw = 'N'  THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN FROM ' || to_char(to_date(p_period_start, 'mm/dd/yyyy'), 'fmMonth DD, YYYY')|| ' TO ' || to_char(to_date(p_period_end, 'mm/dd/yyyy'), 'fmMonth DD, YYYY');
            ELSIF p_as_of_sw = 'Y' THEN
                var.var_header := 'DIRECT PREMIUMS WRITTEN AS OF ' || to_char(to_date(p_expired_as_of, 'mm/dd/yyyy'), 'fmMonth DD, YYYY');      
            END IF;  
            
            PIPE ROW (var);
        END IF;
             
      END; 
      
    FUNCTION get_flood_zone_details
    
    RETURN flood_zone_tab PIPELINED AS
        fzone               flood_zone_type; 
        
    BEGIN
        FOR q IN (SELECT DISTINCT flood_zone flood_zone, '(Zone ' || flood_zone || ')' flood_zone2
           FROM giis_flood_zone a, giis_peril b, gixx_firestat_summary c
           WHERE flood_zone NOT IN (SELECT tariff_zone
                                    FROM gixx_firestat_summary)
            AND b.line_cd = c.line_cd
            AND b.peril_cd IN (SELECT peril_cd
                                 FROM giis_peril
                                WHERE zone_type = '1')
            AND b.line_cd = c.line_cd
            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GIPIS901') = 1
             ORDER BY flood_zone
        )
        
        LOOP
            fzone.flood_zone        :=      q.flood_zone;
            fzone.flood_zone2       :=      q.flood_zone2;
            
            PIPE ROW (fzone);
        END LOOP;
    END;  
      

END GIPIR038A_PKG;
/



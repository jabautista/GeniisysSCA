CREATE OR REPLACE PACKAGE BODY CPI.GIPIR203A_PKG
AS
    FUNCTION populate_header --Dren Niebres 07.18.2016 SR-5336 - Start
        RETURN gipir203a_head_tab PIPELINED
    IS
        v_detail        gipir203a_head_type;

    BEGIN
    
        BEGIN
            SELECT giisp.v('COMPANY_NAME')
              INTO v_detail.company_name
              FROM dual;
                  
        EXCEPTION
            WHEN no_data_found THEN
              v_detail.company_name := NULL;
        END;

        BEGIN
            SELECT giisp.v('COMPANY_ADDRESS')
              INTO v_detail.company_address
              FROM dual;
                  
        EXCEPTION
            WHEN no_data_found THEN
              v_detail.company_address := NULL;
        END;    
    
        PIPE ROW(v_detail);
    END populate_header; --Dren Niebres 07.18.2016 SR-5336 - End    
    FUNCTION populate_report_details (p_include_endt VARCHAR2)
        RETURN gipir203a_tab PIPELINED
    IS
        v_detail        gipir203a_type;
        v_count         NUMBER := 0;
    BEGIN                                      
        FOR rec IN (SELECT assd_no, policy_id, region_cd, ind_grp_cd, premium_amt  --Dren Niebres 07.18.2016 SR-5336 - Start
                      FROM GIXX_RECAPITULATION_DTL
                     ORDER BY assd_no,region_cd, ind_grp_cd, policy_id, premium_amt)
        LOOP
            v_count := 1;
            v_detail.assd_no        := rec.assd_no;
            v_detail.policy_id      := rec.policy_id;
            v_detail.region_cd      := rec.region_cd;
            v_detail.ind_grp_cd     := rec.ind_grp_cd;
            v_detail.premium_amt    := rec.premium_amt;
                
            FOR a IN (SELECT DISTINCT a.line_cd||' - '||b.line_name line_name
                        FROM gipi_polbasic a,giis_line b
                       WHERE 1 = 1
                         AND a.line_cd = b.line_cd
                         AND a.policy_id = rec.policy_id)
            LOOP
                v_detail.line_name := LTRIM(a.line_name);
                EXIT;
            END LOOP;
                
            FOR a IN (SELECT region_desc
                        FROM giis_region
                       WHERE region_cd = rec.region_cd)
            LOOP
                v_detail.region_desc := a.region_desc;
                EXIT;
            END LOOP;
                
            FOR c1 IN (SELECT INITCAP(ind_grp_nm) ind_grp_nm
                         FROM giis_industry_group
                        WHERE ind_grp_cd = rec.ind_grp_cd)
            LOOP
                v_detail.ind_grp_nm := c1.ind_grp_nm;
            END LOOP;
                
            FOR C1 IN (SELECT x.assd_name
                         FROM giis_assured x
                        WHERE x.assd_no = rec.assd_no)
            LOOP
                v_detail.assd_name := C1.assd_name;
            END LOOP;
                
       

            IF p_include_endt = 'N' THEN 

                FOR c1 IN (SELECT x.line_cd||'-'||x.subline_cd||'-'||x.iss_cd||'-'||LTRIM(TO_CHAR(x.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(x.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(x.renew_no,'09')) policy_no
                             FROM GIPI_POLBASIC x
                            WHERE x.policy_id = rec.policy_id)
                LOOP
                    v_detail.policy_no := c1.policy_no;
                END LOOP;    
                    
            ELSE 
                
                FOR c1 IN (SELECT get_policy_no(rec.policy_id) policy_no
                             FROM GIPI_POLBASIC x
                            WHERE x.policy_id = rec.policy_id)
                LOOP
                    v_detail.policy_no := c1.policy_no;
                END LOOP; 
                    
            END IF; --Dren Niebres 07.18.2016 SR-5336 - End    
                            
            PIPE ROW(v_detail);
        END LOOP;        

        
        IF v_count = 0 THEN
        
            PIPE ROW(v_detail);
        END IF;
    
    END populate_report_details;
    
END GIPIR203A_PKG;
/

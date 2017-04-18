CREATE OR REPLACE PACKAGE BODY CPI.GIPIS203_PKG 
AS

    -- Checks if records exist after extraction 
    FUNCTION check_extracted_record(
        p_rg1           VARCHAR2,
        p_rg2           VARCHAR2,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    ) RETURN VARCHAR2
    IS
        v_not_exists        VARCHAR2(5) := 'TRUE';
    BEGIN
    
        IF p_rg1 = 'summary' THEN  -- 1
        
           FOR rec IN (SELECT 'X' 
                         FROM gixx_recapitulation_dtl a , gipi_polbasic b 
                        WHERE a.policy_id = b.policy_id
                          AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id ) = 1 )
           LOOP
               v_not_exists := 'FALSE';
               EXIT;
           END LOOP;
        
        ELSE   
          
           IF p_rg2 = 'premium' THEN -- 2
           
              FOR rec IN (SELECT 'X'
                            FROM gixx_recapitulation_dtl a , gipi_polbasic b 
  						   WHERE a.policy_id = b.policy_id
  						     AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id ) = 1 )
	          LOOP
	              v_not_exists := 'FALSE';
	              EXIT;
	          END LOOP;
	       
           ELSE
           
	          FOR rec IN (SELECT 'X'
	                        FROM gixx_recapitulation_losses_dtl a , gipi_polbasic b 
  						   WHERE a.policy_id = b.policy_id
  						     AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id ) = 1 )
	          LOOP
	              v_not_exists := 'FALSE';
	              EXIT;
	          END LOOP;       
                
	       END IF; 
              
	    END IF;
        
        RETURN v_not_exists;
    END check_extracted_record;
    
    -- checks if records exist before printing
    FUNCTION check_record_bef_print(
        p_rg1           VARCHAR2,
        p_rg2           VARCHAR2
    ) RETURN VARCHAR2
    IS
        v_not_exists    VARCHAR2(5) := 'TRUE';
    BEGIN
    
        IF p_rg1 = 'summary' THEN
	   
           FOR rec IN (SELECT 'X'
                         FROM gixx_recapitulation_dtl)
           LOOP
               v_not_exists := 'FALSE';
               EXIT;
           END LOOP;
           
        ELSE
        	 
           IF p_rg2 = 'premium' THEN
              FOR rec IN (SELECT 'X'
                            FROM gixx_recapitulation_dtl)
              LOOP
                  v_not_exists := 'FALSE';
                  EXIT;
              END LOOP;              
              
           ELSE
              
              FOR rec IN (SELECT 'X'
                            FROM gixx_recapitulation_losses_dtl)
              LOOP
                  v_not_exists := 'FALSE';
                  EXIT;
              END LOOP;
                 
           END IF;	
           
        END IF;
        
        IF p_rg2 = 'premium' THEN
        
            FOR rec IN (SELECT 'X'
                          FROM gixx_recapitulation_dtl)
            LOOP
                v_not_exists := 'FALSE';
                EXIT;
            END LOOP; 
        
        ELSE
            
            FOR rec IN (SELECT 'X'
                          FROM gixx_recapitulation_losses_dtl)
            LOOP
                v_not_exists := 'FALSE';
                EXIT;
            END LOOP;
              
        END IF;
        
        RETURN (v_not_exists);
        
    END check_record_bef_print;
    
    -- Gets the list of regions to display into tablegrid
    FUNCTION get_recap_dtl_region_list(
        p_recap_dtl_type        VARCHAR2
    ) RETURN recap_dtl_region_tab PIPELINED
    IS
        v_dtl   recap_dtl_region_type;
    BEGIN
    
        IF p_recap_dtl_type = 'premium' THEN
            
            FOR rec IN (SELECT DISTINCT region_cd, ind_grp_cd 
                          FROM gixx_recapitulation_dtl
                         ORDER BY region_cd, ind_grp_cd)
            LOOP
                v_dtl.region_cd := rec.region_cd;
                v_dtl.ind_grp_cd := rec.ind_grp_cd;
                
                FOR i IN (SELECT INITCAP(IND_GRP_NM) ind_grp_nm
                            FROM giis_industry_group
                           WHERE ind_grp_cd = rec.ind_grp_cd)
                LOOP
                    v_dtl.ind_grp_nm := i.ind_grp_nm;
                END LOOP;
                
                FOR i IN (SELECT INITCAP(region_desc) region_desc
                            FROM giis_region
                           WHERE region_cd = rec.region_cd)
                LOOP
                    v_dtl.region_desc := i.region_desc;
                END LOOP;
                
                PIPE ROW(v_dtl);
            END LOOP;
        
        ELSE -- losses
        
            FOR rec IN (SELECT DISTINCT region_cd, ind_grp_cd 
                          FROM gixx_recapitulation_losses_dtl
                         ORDER BY region_cd, ind_grp_cd)
            LOOP
                v_dtl.region_cd := rec.region_cd;
                v_dtl.ind_grp_cd := rec.ind_grp_cd;
                
                FOR i IN (SELECT INITCAP(IND_GRP_NM) ind_grp_nm
                            FROM giis_industry_group
                           WHERE ind_grp_cd = rec.ind_grp_cd)
                LOOP
                    v_dtl.ind_grp_nm := i.ind_grp_nm;
                END LOOP;
                
                FOR i IN (SELECT INITCAP(region_desc) region_desc
                            FROM giis_region
                           WHERE region_cd = rec.region_cd)
                LOOP
                    v_dtl.region_desc := i.region_desc;
                END LOOP;
                
                PIPE ROW(v_dtl);
            END LOOP;
        
        END IF;
        
    END get_recap_dtl_region_list;
    
    -- Retrieves the list of Recaps Premium
    FUNCTION get_recap_dtl_prem_list(
        p_region_cd     gixx_recapitulation_dtl.region_cd%TYPE,
        p_ind_grp_cd    gixx_recapitulation_dtl.ind_grp_cd%TYPE
    ) RETURN recap_dtl_tab PIPELINED
    IS
        v_dtl   recap_dtl_type;
    BEGIN
    
        FOR rec IN (SELECT region_cd, ind_grp_cd, policy_id,
                           assd_no, premium_amt
                      FROM GIXX_RECAPITULATION_DTL
                     WHERE region_cd = p_region_cd
                       AND ind_grp_cd = p_ind_grp_cd)
        LOOP
        
            v_dtl.region_cd     := rec.region_cd;
            v_dtl.ind_grp_cd    := rec.ind_grp_cd;
            v_dtl.policy_id     := rec.policy_id;
            v_dtl.assd_no       := rec.assd_no;
            v_dtl.premium_amt   := rec.premium_amt;
            
            FOR c1 IN (SELECT x.line_cd||'-'||x.subline_cd||'-'||x.iss_cd||'-'||LTRIM(TO_CHAR(x.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(x.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(x.renew_no,'09')) policy_no,
	                          x.endt_iss_cd||'-'||LTRIM(TO_CHAR(x.endt_yy,'09'))||'-'||LTRIM(TO_CHAR(x.endt_seq_no,'0000009')) endt_no,
	                          x.endt_seq_no
	                     FROM GIPI_POLBASIC x
				        WHERE x.policy_id = rec.policy_id)
            LOOP
              --kim 06/22/2004
              -- the endorsement number will be included in the policy number 
              -- when the endt_seq_no is not equal to 0  	
                IF c1.endt_seq_no = 0 THEN
                    v_dtl.policy_no := c1.policy_no;
                ELSE
                    v_dtl.policy_no := c1.policy_no||' / '||c1.endt_no;
                END IF;	
            END LOOP;	
              
            --kim 06/03/2004
            -- for the assured name
            FOR c3 IN (SELECT assd_name 
                         FROM giis_assured
                        WHERE assd_no = rec.assd_no)
            LOOP
                v_dtl.assd_name := c3.assd_name;
            END LOOP;
        
            PIPE ROW(v_dtl);
        END LOOP;
    END get_recap_dtl_prem_list;
    
    -- Retrieves the list of Recaps Losses
    FUNCTION get_recap_dtl_loss_list(
        p_region_cd     GIXX_RECAPITULATION_LOSSES_DTL.region_cd%TYPE,
        p_ind_grp_cd    GIXX_RECAPITULATION_LOSSES_DTL.ind_grp_cd%TYPE
    ) RETURN recap_dtl_tab PIPELINED
    IS
        v_dtl   recap_dtl_type;
    BEGIN
    
        FOR rec IN (SELECT region_cd, ind_grp_cd, policy_id, assd_no, claim_id, loss_amt
                      FROM GIXX_RECAPITULATION_LOSSES_DTL
                     WHERE region_cd = p_region_cd
                       AND ind_grp_cd = p_ind_grp_cd)
        LOOP
            
            v_dtl.region_cd     := rec.region_cd;
            v_dtl.ind_grp_cd    := rec.ind_grp_cd;
            v_dtl.policy_id     := rec.policy_id;
            v_dtl.assd_no       := rec.assd_no;
            v_dtl.claim_id      := rec.claim_id;
            v_dtl.loss_amt      := rec.loss_amt;
            
            FOR c1 IN (SELECT x.line_cd||'-'||x.subline_cd||'-'||x.iss_cd||'-'||LTRIM(TO_CHAR(x.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(x.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(x.renew_no,'09')) policy_no,
						      y.line_cd||'-'||y.subline_cd||'-'||y.pol_iss_cd||'-'||LTRIM(TO_CHAR(y.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(y.clm_seq_no,'0000009')) claim_no,
	                          x.endt_iss_cd||'-'||LTRIM(TO_CHAR(x.endt_yy,'09'))||'-'||LTRIM(TO_CHAR(x.endt_seq_no,'0000009')) endt_no,
	                          x.endt_seq_no
	                     FROM GIPI_POLBASIC x,
					          GICL_CLAIMS y
				        WHERE x.line_cd     = y.line_cd
					      AND x.subline_cd  = y.subline_cd
					      AND x.iss_cd      = y.pol_iss_cd
					      AND x.issue_yy    = y.issue_yy
					      AND x.pol_seq_no  = y.pol_seq_no
					      AND x.renew_no    = y.renew_no
					      AND y.claim_id    = rec.claim_id
					      AND x.policy_id   = rec.policy_id)
			
            LOOP
                --kim 06/22/2004
                -- the endorsement number will be included in the policy number 
                -- when the endt_seq_no is not equal to 0  
                IF c1.endt_seq_no = 0 THEN
                    v_dtl.policy_no := c1.policy_no;
                ELSE
                    v_dtl.policy_no := c1.policy_no||' / '||c1.endt_no;
                END IF;	
                
                v_dtl.claim_no := c1.claim_no;
            END LOOP;	
          
            --kim 06/04/2004
            -- for the assured name
            FOR c3 IN (SELECT assd_name 
                         FROM giis_assured
                        WHERE assd_no = rec.assd_no)
            LOOP
                v_dtl.assd_name := c3.assd_name;
            END LOOP;
            
            PIPE ROW(v_dtl);
        END LOOP;
        
    END get_recap_dtl_loss_list;
    
END GIPIS203_PKG;
/



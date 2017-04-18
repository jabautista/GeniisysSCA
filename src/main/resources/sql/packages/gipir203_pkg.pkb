CREATE OR REPLACE PACKAGE BODY CPI.GIPIR203_PKG 
AS

    FUNCTION populate_gipir203_details
        RETURN recap_dtl_tab PIPELINED
    IS
        v_detail    recap_dtl_type;
        v_count     NUMBER := 0;
    BEGIN
    
         BEGIN
                SELECT giisp.v('COMPANY_NAME')
                  INTO v_detail.company_name
                  FROM dual;
                  
         EXCEPTION
                WHEN no_data_found THEN
                  v_detail.company_name := NULL;
         END;
        
        FOR rec IN (SELECT region_cd, ind_grp_cd, no_of_policy,
                           gross_prem, gross_losses, social_gross_prem
                      FROM gixx_recapitulation 
                     ORDER BY region_cd, ind_grp_cd)
        LOOP
            v_count := 1;
            v_detail.region_cd          := rec.region_cd;
            v_detail.ind_grp_cd         := rec.ind_grp_cd;
            v_detail.no_of_policy       := rec.no_of_policy;
            v_detail.gross_prem         := rec.gross_prem;
            v_detail.gross_losses       := rec.gross_losses;
            v_detail.social_gross_prem  := rec.social_gross_prem;
            
            FOR i IN (SELECT region_cd, region_desc
                        FROM giis_region
                       WHERE region_cd = rec.region_cd)
            LOOP
                v_detail.region_name := i.region_cd || ' - ' || i.region_desc;
            END LOOP;
            
            BEGIN
            
                SELECT INITCAP(IND_GRP_NM)
                  INTO v_detail.ind_grp_nm
                  FROM giis_industry_group
                 WHERE ind_grp_cd = rec.ind_grp_cd;
                 
            EXCEPTION
                WHEN no_data_found THEN
                  v_detail.ind_grp_nm := NULL;
            END;
            
            PIPE ROW(v_detail);
        END LOOP;
        
        IF v_count = 0 THEN
             
            PIPE ROW(v_detail);
        END IF;
    
    END populate_gipir203_details;

END GIPIR203_PKG;
/



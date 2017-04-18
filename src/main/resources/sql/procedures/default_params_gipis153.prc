DROP PROCEDURE CPI.DEFAULT_PARAMS_GIPIS153;

CREATE OR REPLACE PROCEDURE CPI.DEFAULT_PARAMS_GIPIS153 (
    p_par_id        IN  GIPI_WITMPERL.par_id%TYPE,
    p_prem_amt      OUT GIPI_WITMPERL.prem_amt%TYPE,
    p_tsi_amt       OUT GIPI_WITMPERL.tsi_amt%TYPE,
    p_share_pct     OUT GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
    p_policy_id     OUT GIPI_CO_INSURER.policy_id%TYPE,
    p_co_prem_amt   OUT GIPI_WITMPERL.prem_amt%TYPE,
    p_co_tsi_amt    OUT GIPI_WITMPERL.tsi_amt%TYPE
) IS
    v_co_ri_cd      gipi_co_insurer.co_ri_cd%TYPE;

BEGIN
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 04.30.2011
    **  Reference By     : (GIPIS153 - enter co insurer)
    **  Description     : Retrieves default values used in gipis153
    */
    FOR tot_prem IN (
      SELECT SUM(prem_amt) prem
        FROM gipi_witmperl        
       WHERE par_id = p_par_id)
    LOOP
       p_prem_amt := tot_prem.prem;
    END LOOP;
        
    FOR tot_tsi IN (
      SELECT SUM(a.tsi_amt) tsi
        FROM giis_peril b,
             gipi_witmperl a        
       WHERE b.line_cd = a.line_cd
         AND b.peril_cd = a.peril_cd
         AND b.peril_type = 'B'
         AND a.par_id = p_par_id)
    LOOP
       p_tsi_amt  := tot_tsi.tsi;
    END LOOP;
                  
    FOR co_ri IN (
       SELECT param_value_n
         FROM giis_parameters
       WHERE param_name = 'CO_INSURER_DEFAULT')
    LOOP
       v_co_ri_cd := co_ri.param_value_n;
    END LOOP;
    
    FOR pol IN (
        SELECT a.policy_id
          FROM gipi_polbasic a, gipi_wpolbas b
         WHERE a.line_cd     = b.line_cd
           AND a.subline_cd  = b.subline_cd
           AND a.iss_cd      = b.iss_cd
           AND a.issue_yy    = b.issue_yy
           AND a.pol_seq_no  = b.pol_seq_no
           AND a.renew_no    = b.renew_no
           AND a.endt_seq_no = 0
           AND b.par_id      = p_par_id
    ) LOOP
       p_policy_id := pol.policy_id;
    
       FOR get_shr IN (
          SELECT co_ri_shr_pct
            FROM gipi_co_insurer
           WHERE policy_id = pol.policy_id
             AND co_ri_cd  = v_co_ri_cd)
        LOOP
          p_share_pct := get_shr.co_ri_shr_pct;
        END LOOP;     
            
        p_co_prem_amt := ROUND(NVL(p_prem_amt,0) / p_share_pct * 100 ,2);
        p_co_tsi_amt  := ROUND(NVL(p_tsi_amt,0)  / p_share_pct * 100 ,2);
        
        --load default records from gipi_co_insurer
    END LOOP;  
END;
/



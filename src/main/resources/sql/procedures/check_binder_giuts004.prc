DROP PROCEDURE CPI.CHECK_BINDER_GIUTS004;

CREATE OR REPLACE PROCEDURE CPI.check_binder_giuts004(
    p_ri_cd         IN   giac_outfacul_prem_payts.a180_ri_cd%TYPE,
    p_fnl_binder_id IN   giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
    p_msg           OUT  NUMBER
)
IS
  /*
  **  Created by   : Robert John Virrey
  **  Date Created : August 15, 2011
  **  Reference By : (GIUTS004 - Reverse Binder)
  **  Description  : Check if there are collections from facul insurers
  **                 
  */
    v_param    giis_parameters.param_value_v%TYPE;
    v_msg      NUMBER;
BEGIN
    FOR param IN (
    SELECT param_value_v
      FROM giis_parameters 
     --WHERE param_name = 'ALLOW_NEG_DIST') --removed by j.diago 09.17.2014 replaced with RESTRICT_NEG_OF_BNDR_WFACPAYT
     WHERE param_name = 'RESTRICT_NEG_OF_BNDR_WFACPAYT') 
    LOOP
        v_param  :=  param.param_value_v;
        EXIT;
    END LOOP; 
        
    
     FOR A4 IN (SELECT SUM(NVL(a.disbursement_amt,0)) amt
                  FROM giac_outfacul_prem_payts a, 
                       giac_acctrans b
                 WHERE a.a180_ri_cd         =  p_ri_cd
                   AND a.d010_fnl_binder_id =  p_fnl_binder_id
                   AND a.gacc_tran_id       =  b.tran_id
                   AND b.tran_flag          <> 'D'        
                   AND NOT EXISTS (SELECT '1'
                                     FROM giac_reversals c, 
                                          giac_acctrans d
                                    WHERE a.gacc_tran_id = c.gacc_tran_id
                                      AND c.reversing_tran_id =  d.tran_id
                                      AND d.tran_flag <> 'D'))
    LOOP
         IF a4.amt <> 0 THEN
            IF v_param != 'Y' THEN --modified by j.diago 09.17.2014 from = 'Y' to != 'Y'
               v_msg := 1;
            ELSE
               v_msg := 2;    
            END IF;
            EXIT;
         END IF;                 
   END LOOP;   
   
   --added by j.diago 09.17.2014 to restrict binders that are grouped.
   FOR i IN (SELECT a.master_bndr_id, a.pack_binder_id
               FROM giri_frps_ri a, giri_binder b
              WHERE a.fnl_binder_id = b.fnl_binder_id
                AND b.fnl_binder_id = p_fnl_binder_id
                AND (a.master_bndr_id IS NOT NULL OR
                     a.pack_binder_id IS NOT NULL)
                AND b.reverse_date IS NULL)
   LOOP
      IF i.pack_binder_id IS NOT NULL THEN
         v_msg := '3';
      ELSE
         v_msg := '4';
      END IF;
          
      EXIT;
   END LOOP; 
        
   p_msg := v_msg;
END;
/



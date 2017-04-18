DROP PROCEDURE CPI.POPULATE_WCOMM_INVPERL;

CREATE OR REPLACE PROCEDURE CPI.populate_wcomm_invperl(
    p_dsp_line_cd   giis_line_subline_coverages.line_cd%TYPE,
    p_new_par_id    gipi_witmperl.par_id%TYPE,
    p_proc_intm_no  giis_intermediary.intm_no%TYPE,
    p_dsp_iss_cd    giis_intm_special_rate.iss_cd%TYPE,
    p_msg       OUT VARCHAR2,
    p_iss_cd    OUT giis_parameters.param_value_v%TYPE
) 
IS
  
  v_intm_no    gipi_wcomm_invoices.intrmdry_intm_no%TYPE;
  
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-18-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_WCOMM_INV_PERILS program unit 
  */
  FOR A IN ( SELECT item_grp, peril_cd, prem_amt
               FROM gipi_winvperl
              WHERE par_id = p_new_par_id) 
    LOOP 
        INSERT INTO gipi_wcomm_inv_perils
           (INTRMDRY_INTM_NO, PAR_ID, ITEM_GRP, PERIL_CD, PREMIUM_AMT, 
            COMMISSION_AMT,COMMISSION_RT,WHOLDING_TAX)
        VALUES (p_proc_intm_no, p_new_par_id, a.item_grp, a.peril_cd,
            a.prem_amt, 0, 0, 0);
    POPULATE_WCOMM_INV_PERILS(a.item_grp, p_dsp_line_cd, p_new_par_id, p_proc_intm_no, p_dsp_iss_cd, p_msg, p_iss_cd);
    END LOOP;                 
END;
/



DROP PROCEDURE CPI.POPULATE_WCOMM_INV_PERILS;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_WCOMM_INV_PERILS(
    p_item_grp      NUMBER,
    p_dsp_line_cd   giis_line_subline_coverages.line_cd%TYPE,
    p_new_par_id    gipi_witmperl.par_id%TYPE,
    p_proc_intm_no  giis_intermediary.intm_no%TYPE,
    p_dsp_iss_cd    giis_intm_special_rate.iss_cd%TYPE,
    p_msg       OUT VARCHAR2,
    p_iss_cd    OUT giis_parameters.param_value_v%TYPE
) 
IS
  v_peril_name             giis_peril.peril_name%type;
  v_total_commission       gipi_wcomm_invoices.commission_amt%type;
  v_total_wholding_tax     gipi_wcomm_invoices.wholding_tax%type;
  v_total_premium_amt      gipi_wcomm_invoices.premium_amt%type;
  v_total_net_commission   gipi_wcomm_invoices.commission_amt%type;
  v_dummy                  VARCHAR2(1);
  v_share_percentage       gipi_wcomm_invoices.share_percentage%TYPE;
  var_tax_amt              giis_intermediary.wtax_rate%TYPE;
  v_commission_amt         gipi_wcomm_inv_perils.commission_amt%TYPE;
  v_prem_amt               gipi_wcomm_inv_perils.premium_amt%TYPE;
  
  v_peril_cd               gipi_winvperl.peril_cd%TYPE;
  v_rate                   giis_intm_special_rate.rate%TYPE;
  
  
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-18-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_WCOMM_INV_PERILS program unit 
  */
  SELECT 'x'
    INTO v_dummy
    FROM giis_line_subline_coverages
   WHERE line_cd = p_dsp_line_cd    
     AND ROWNUM = 1;
  
  PACKAGE_COMMISSION(p_new_par_id, p_proc_intm_no, p_dsp_iss_cd, p_msg);
    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    FOR c1_rec IN (SELECT peril_cd,prem_amt
                     FROM gipi_winvperl
                    WHERE par_id   = p_new_par_id  
                      AND item_grp = p_item_grp) 
        LOOP
        BEGIN
       /*   IF :SYSTEM.RECORD_STATUS <> 'NEW' THEN
             NEXT_RECORD;
          END IF;*/
          v_peril_cd := c1_rec.peril_cd;
          BEGIN
          SELECT param_value_v
            INTO p_iss_cd
            FROM giis_parameters
           WHERE param_name = 'HO';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_msg := 'Parameter HO does not exist in giis parameters.';
        END;
        GET_INTMDRY_RATE(p_proc_intm_no, p_new_par_id, p_dsp_line_cd, p_dsp_iss_cd, v_peril_cd, v_rate);         
    
                --%%%%---
        DECLARE
          X      gipi_wcomm_invoices.share_percentage%TYPE := 0;
        BEGIN
          FOR temp IN (SELECT SHARE_PERCENTAGE
                         FROM GIPI_WCOMM_INVOICES
                        WHERE ITEM_GRP = p_item_grp 
                          AND PAR_ID = p_new_par_id) 
          LOOP
              v_share_percentage := temp.share_percentage;  
          END LOOP;
          END;
      
          BEGIN
            IF v_rate IS NOT NULL THEN
               BEGIN
                 SELECT peril_name
                   INTO v_peril_name
                   FROM giis_peril
                  WHERE peril_cd = c1_rec.peril_cd
                    AND line_cd  = p_dsp_line_cd;    
                      
                 FOR A IN ( SELECT wtax_rate
                              FROM giis_intermediary
                             WHERE intm_no = p_proc_intm_no ) 
                 LOOP
                   var_tax_amt := a.wtax_rate;
                   EXIT;
                 END LOOP;              
                 v_prem_amt := c1_rec.prem_amt * NVL(v_share_percentage,0)/100;
                 v_commission_amt := round(v_prem_amt * v_rate/100,2);
                 
                 UPDATE gipi_wcomm_inv_perils
                    SET premium_amt = v_prem_amt,
                        commission_rt = v_rate,
                        commission_amt = v_commission_amt,
                        wholding_tax = ROUND(NVL(v_commission_amt,0),2) 
                                               * NVL(var_tax_amt,0)/100
                  WHERE par_id = p_new_par_id
                    AND item_grp = p_item_grp 
                    AND peril_cd = c1_rec.peril_cd;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN 
                   NULL;
               END;
            END IF;  
          END;        
        END;
    END LOOP;
    --FIRST_RECORD;
END;
/



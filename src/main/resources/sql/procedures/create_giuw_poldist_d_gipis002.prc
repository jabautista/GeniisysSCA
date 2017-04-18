DROP PROCEDURE CPI.CREATE_GIUW_POLDIST_D_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Create_Giuw_Poldist_D_Gipis002
 (p_par_id IN NUMBER,
  v_tsi_amt OUT NUMBER,
  v_prem_amt OUT NUMBER,
  v_ann_tsi_amt OUT NUMBER,
  p_eff_date OUT DATE,
  p_expiry_date OUT DATE,
  p_endt_type OUT VARCHAR2,
  p_takeup_term OUT VARCHAR2,
  v_nodata IN OUT VARCHAR2,
  v_toomany IN OUT VARCHAR2) IS    
  CURSOR B IS
       SELECT  pol_dist_dist_no_s.NEXTVAL
         FROM  sys.dual;              
BEGIN
   FOR A IN (SELECT SUM(tsi_amt*NVL(currency_rt,1)) tsi,
                         SUM(prem_amt*NVL(currency_rt,1)) prem,
                         SUM(ann_tsi_amt*NVL(currency_rt,1)) ann_tsi
                    FROM GIPI_WITEM
                   WHERE par_id = p_par_id) LOOP
           v_tsi_amt     := A.tsi;
           v_prem_amt    := A.prem;
           v_ann_tsi_amt := A.ann_tsi;
 END LOOP; 
    
  BEGIN
    SELECT eff_date,
          expiry_date, 
          endt_type,
          takeup_term
       INTO p_eff_date,
          p_expiry_date,
          p_endt_type,
          p_takeup_term
       FROM GIPI_WPOLBAS
      WHERE par_id  =  p_par_id;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_nodata := 'Y';
       WHEN TOO_MANY_ROWS THEN
         v_toomany := 'Y';
  END;
END;
/



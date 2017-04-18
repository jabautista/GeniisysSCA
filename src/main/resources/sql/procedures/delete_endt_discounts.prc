DROP PROCEDURE CPI.DELETE_ENDT_DISCOUNTS;

CREATE OR REPLACE PROCEDURE CPI.DELETE_ENDT_DISCOUNTS(p_par_id  GIPI_WPERIL_DISCOUNT.par_id%TYPE) IS

   /*
   **  Created by    : Menandro G.C. Robes
   **  Date Created  : June 29, 2010
   **  Reference By  : (GIPIS097 - Endt Item Peril Information)
   **  Description   : Procedure which deletes discounts and updates the affected amounts of the discount.
   */   
BEGIN
  FOR A IN(
    SELECT disc_amt, item_no, peril_cd, 
           orig_peril_ann_prem_amt peril_prem,
           orig_item_ann_prem_amt item_prem,
           orig_pol_ann_prem_amt pol_prem 
      FROM gipi_wperil_discount
     WHERE par_id = p_par_id) 
  LOOP

     GIPI_WPOLBAS_PKG.update_gipi_wpolbas_discount(p_par_id, a.disc_amt, a.pol_prem);     
     GIPI_WITEM_PKG.update_gipi_witem_discount(p_par_id, a.item_no, a.disc_amt, a.item_prem);
     GIPI_WITMPERL_PKG.update_gipi_witmperl_discount(p_par_id, a.item_no, a.peril_cd, a.disc_amt, a.peril_prem);
  END LOOP;
  
  GIPI_WPERIL_DISCOUNT_PKG.DEL_GIPI_WPERIL_DISCOUNT(P_PAR_ID);  
  GIPI_WITEM_DISCOUNT_PKG.DEL_GIPI_WITEM_DISCOUNT(P_PAR_ID);
  GIPI_WPOLBAS_DISCOUNT_PKG.DEL_GIPI_WPOLBAS_DISCOUNT(P_PAR_ID);
       
END DELETE_ENDT_DISCOUNTS;
/



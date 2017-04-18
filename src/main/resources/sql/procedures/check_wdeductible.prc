DROP PROCEDURE CPI.CHECK_WDEDUCTIBLE;

CREATE OR REPLACE PROCEDURE CPI.check_wdeductible (p_par_id           IN  GIPI_WPOLBAS.par_id%TYPE,           --to be used in validation
                                                   p_item_no          IN  GIPI_WITMPERL.item_no%TYPE,         --to be used in validation
                                                   p_ded_type         IN  GIIS_DEDUCTIBLE_DESC.ded_type%TYPE, --to be used in validation
                                                   p_deductible_level IN  NUMBER,                             --level od deductible
                                                   p_message          OUT VARCHAR2)                           --validation message
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Policy Deductible)
**  Description  : This will check the deductible to be inserted.
                   This is used in policy and item level deductibles.
                   This returns the validation message. 
*/ 
                                                     
IS

  v_items             VARCHAR2(32767);
  v_currency_count    NUMBER;
  v_curr_rt_count     NUMBER;
                            
BEGIN 
    
  p_message  := 'SUCCESS';
    
  IF p_ded_type = 'T' THEN
     IF p_deductible_level = 1 THEN
        IF NOT GIPI_WITEM_PKG.PAR_HAS_ITEM(p_par_id) THEN
           p_message := 'There is still no item for this PAR. This type of deductible cannot be used. Please enter item first.';
        ELSE
           v_items            := GIPI_WITEM_PKG.GET_PAR_ITEMS_WO_PERIL(p_par_id);             
           v_currency_count   := GIPI_WITEM_PKG.GET_PAR_ITEMS_CURRENCY_COUNT(p_par_id);
           v_curr_rt_count    := GIPI_WITEM_PKG.GET_PAR_ITEMS_CURR_RT_COUNT(p_par_id);
                
           IF v_items IS NOT NULL THEN
              p_message := 'There is still no TSI amount for item/s ' || SUBSTR(RTRIM(LTRIM(v_items)), 1, LENGTH(RTRIM(LTRIM(v_items)))-1) || '. This type of deductible cannot be used. Please enter perils first.';
           ELSIF v_currency_count > 1 THEN
              p_message := 'You are only allowed to use this type of deductible for a single-currency policy.';
           ELSIF v_curr_rt_count > 1 THEN
              p_message := 'You are only allowed to use this type of deductible for a single-currency policy.';         
           END IF;
                
        END IF;
     ELSIF p_deductible_level = 2 THEN
        IF NOT GIPI_WITMPERL_PKG.PAR_ITEM_HAS_PERIL(p_par_id, p_item_no) THEN
           p_message := 'There is still no TSI amount for this item. Please enter peril(s) first before using the deductible';
        END IF;
     END IF;   
  END IF;
    
END check_wdeductible;
/



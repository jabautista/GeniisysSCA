DROP PROCEDURE CPI.UPDATE_DISCOUNT_AT_PERIL;

CREATE OR REPLACE PROCEDURE CPI.update_discount_at_peril(
	   	  		  p_par_id	   			    GIPI_WITEM.par_id%TYPE,
				  p_item_no	   				GIPI_WITEM.item_no%TYPE,
				  p_nbt_orig_item_no		GIPI_WITEM.item_no%TYPE,
				  p_peril_cd	   			GIPI_WPERIL_DISCOUNT.peril_cd%TYPE,
				  p_nbt_orig_peril_cd		GIPI_WPERIL_DISCOUNT.peril_cd%TYPE,
				  p_disc_amt				GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
				  p_nbt_orig_disc_amt		GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
				  p_surcharge_amt			GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE,
				  p_nbt_orig_surcharge_amt	GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE 
	   	  		  )
     IS
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.11.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: update_discount_at_peril program unit
	*/
-- Updated by RBD (08142002)
-- to include/add surcharge amount when updating the policy table(gipi_wpolbas), item table(gipi_witem) and peril table(gipi_witmperl)

  UPDATE GIPI_WPOLBAS
     SET prem_amt     = (prem_amt     + NVL(p_surcharge_amt,0) - NVL(p_nbt_orig_surcharge_amt,0)) - NVL(p_disc_amt,0) + NVL(p_nbt_orig_disc_amt,0) ,
         ann_prem_amt = (ann_prem_amt + NVL(p_surcharge_amt,0) - NVL(p_nbt_orig_surcharge_amt,0)) - NVL(p_disc_amt,0) + NVL(p_nbt_orig_disc_amt,0) 
   WHERE par_id  = p_par_id;
--     SET prem_amt     = prem_amt     - :b390.disc_amt + :b390.nbt_orig_disc_amt ,
--         ann_prem_amt = ann_prem_amt - :b390.disc_amt + :b390.nbt_orig_disc_amt 

  UPDATE GIPI_WITEM
     SET prem_amt     = (prem_amt      - NVL(p_nbt_orig_surcharge_amt,0)) + NVL(p_nbt_orig_disc_amt,0) ,
         ann_prem_amt = (ann_prem_amt  - NVL(p_nbt_orig_surcharge_amt,0)) + NVL(p_nbt_orig_disc_amt,0)
   WHERE par_id  = p_par_id
     AND item_no = NVL(p_nbt_orig_item_no,p_item_no);
--     SET prem_amt     = prem_amt      + :b390.nbt_orig_disc_amt ,
--         ann_prem_amt = ann_prem_amt  + :b390.nbt_orig_disc_amt

  UPDATE GIPI_WITEM
     SET prem_amt     = (prem_amt     + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0) ,
         ann_prem_amt = (ann_prem_amt + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0) 
   WHERE par_id  = p_par_id
     AND item_no = p_item_no;
--     SET prem_amt     = prem_amt     - :b390.disc_amt,
--         ann_prem_amt = ann_prem_amt - :b390.disc_amt 

  UPDATE GIPI_WITMPERL
     SET prem_amt     = (prem_amt      + NVL(p_nbt_orig_disc_amt,0)) - NVL(p_nbt_orig_surcharge_amt,0) ,
         ann_prem_amt = (ann_prem_amt  + NVL(p_nbt_orig_disc_amt,0)) - NVL(p_nbt_orig_surcharge_amt,0) 
   WHERE par_id   = p_par_id
     AND item_no  = NVL(p_nbt_orig_item_no,p_item_no)
     AND peril_cd = NVL(p_nbt_orig_peril_cd,p_peril_cd);
--     SET prem_amt     = prem_amt      + :b390.nbt_orig_disc_amt,
--         ann_prem_amt = ann_prem_amt  + :b390.nbt_orig_disc_amt

  UPDATE GIPI_WITMPERL
     SET prem_amt     = (prem_amt     + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0) ,
         ann_prem_amt = (ann_prem_amt + NVL(p_surcharge_amt,0)) - NVL(p_disc_amt,0) 
   WHERE par_id   = p_par_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd;
--     SET prem_amt     = prem_amt     - :b390.disc_amt ,
--         ann_prem_amt = ann_prem_amt - :b390.disc_amt 
END;
/



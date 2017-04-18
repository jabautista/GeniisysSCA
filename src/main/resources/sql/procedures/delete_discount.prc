DROP PROCEDURE CPI.DELETE_DISCOUNT;

CREATE OR REPLACE PROCEDURE CPI.Delete_Discount (p_par_id	   GIPI_WITEM.par_id%TYPE)
IS
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.08.2010
	**  Reference By 	: (GIPIS060 - Item Information)
	**  Description 	: Update GIPI_WITEM and GIPI_WITMPERL record, and GIPI_WPOLBAS.
	**					: Delete record on GIPI_WPERIL_DISCOUNT, GIPI_WITEM_DISCOUNT, GIPI_WPOLBAS_DISCOUNT
	**					: Difference on GIPIS010_DELETE_DISCOUNT - The Gipi_wpolbas update procedure is removed.
	**					    The procedure is called on separate action.
	*/
BEGIN
	FOR A IN(
		SELECT disc_amt, item_no, peril_cd,
			   orig_peril_ann_prem_amt peril_prem,
			   orig_item_ann_prem_amt item_prem,
			   orig_pol_ann_prem_amt pol_prem 
		  FROM GIPI_WPERIL_DISCOUNT
		 WHERE par_id   = p_par_id ) 
	LOOP
		UPDATE GIPI_WITEM
		   SET prem_amt     = prem_amt + A.disc_amt,
			   ann_prem_amt = NVL(A.item_prem,ann_prem_amt),
			   discount_sw  = 'N'
		 WHERE par_id   = p_par_id
		   AND item_no  = A.item_no;
		   
		UPDATE GIPI_WITMPERL
		   SET prem_amt     = prem_amt + A.disc_amt,
			   ann_prem_amt = NVL(A.peril_prem,ann_prem_amt),
			   discount_sw  = 'N'
		 WHERE par_id   = p_par_id
		   AND item_no  = A.item_no
		   AND peril_cd = A.peril_cd;
	END LOOP;
  
	Gipi_Wperil_Discount_Pkg.del_gipi_wperil_discount(p_par_id);   
	Gipi_Witem_Discount_Pkg.del_gipi_witem_discount(p_par_id);   
	Gipi_Wpolbas_Discount_Pkg.del_gipi_wpolbas_discount(p_par_id);   
	--Gipis060_Update_Gipi_Wpolbas2(p_par_id;
	COMMIT;
END;
/



DROP PROCEDURE CPI.GIPIS010_COPY_ITEM_PERIL;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Copy_Item_Peril (
	p_par_id		GIPI_WITMPERL.par_id%TYPE,
	p_item_no		GIPI_WITMPERL.item_no%TYPE,
	p_new_item_no	GIPI_WITMPERL.item_no%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.08.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Creates new record in GIPI_WITMPERL by copying the record specified
	**					  by the parameters (par_id, item_no)
	*/
BEGIN
	FOR PERIL IN (SELECT line_cd,		peril_cd,  
						 tarf_cd,		prem_rt,			tsi_amt,		prem_amt,
						 ann_tsi_amt,	ann_prem_amt,		rec_flag,		comp_rem,
						 discount_sw,	ri_comm_rate,		ri_comm_amt, 	prt_flag,
						 as_charge_sw,	surcharge_sw,		no_of_days,		base_amt,
						 aggregate_sw
					FROM GIPI_WITMPERL 
				   WHERE par_id = p_par_id
					 AND item_no = p_item_no)
	LOOP
		INSERT INTO GIPI_WITMPERL (
			par_id,				item_no,      		line_cd,           	peril_cd,
			tarf_cd,			prem_rt,            tsi_amt,           	prem_amt,
			ann_tsi_amt,		ann_prem_amt,       rec_flag,          	comp_rem,
			discount_sw,		ri_comm_rate,       ri_comm_amt,       	prt_flag,
			as_charge_sw,		surcharge_sw,		no_of_days,			base_amt,
			aggregate_sw )
		VALUES (
			p_par_id,			p_new_item_no,      peril.line_cd,     	peril.peril_cd,
			peril.tarf_cd,		peril.prem_rt,      peril.tsi_amt,     	peril.prem_amt,
			peril.ann_tsi_amt,	peril.ann_prem_amt, peril.rec_flag,    	peril.comp_rem,
			peril.discount_sw,	peril.ri_comm_rate, peril.ri_comm_amt, 	peril.prt_flag,
			peril.as_charge_sw,	peril.surcharge_sw,	peril.no_of_days,	peril.base_amt,
			peril.aggregate_sw);                  
	END LOOP;	
END;
/



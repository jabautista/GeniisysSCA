CREATE OR REPLACE PACKAGE CPI.Gipi_Witem_Discount_Pkg
AS
  	TYPE gipi_witem_discount_type IS RECORD
	(par_id					GIPI_WITEM_DISCOUNT.par_id%TYPE,									
	 line_cd				GIPI_WITEM_DISCOUNT.line_cd%TYPE,
	 item_no				GIPI_WITEM_DISCOUNT.item_no%TYPE,
	 item_title				GIPI_WITEM.item_title%TYPE,
	 subline_cd				GIPI_WITEM_DISCOUNT.subline_cd%TYPE,
	 disc_rt				GIPI_WITEM_DISCOUNT.disc_rt%TYPE,
	 disc_amt				GIPI_WITEM_DISCOUNT.disc_amt%TYPE,
	 net_gross_tag			GIPI_WITEM_DISCOUNT.net_gross_tag%TYPE,
	 orig_prem_amt			GIPI_WITEM_DISCOUNT.orig_prem_amt%TYPE,
	 SEQUENCE				GIPI_WITEM_DISCOUNT.SEQUENCE%TYPE,
	 remarks				GIPI_WITEM_DISCOUNT.remarks%TYPE,
	 net_prem_amt			GIPI_WITEM_DISCOUNT.net_prem_amt%TYPE,
	 surcharge_rt			GIPI_WITEM_DISCOUNT.surcharge_rt%TYPE,
	 surcharge_amt			GIPI_WITEM_DISCOUNT.surcharge_amt%TYPE
	 );
	 
	TYPE gipi_witem_discount_tab IS TABLE OF gipi_witem_discount_type;

	FUNCTION get_gipi_witem_discount (p_par_id     GIPI_WITEM_DISCOUNT.par_id%TYPE)
    RETURN gipi_witem_discount_tab PIPELINED;
	
	PROCEDURE set_gipi_witem_discount (p_witem_disc IN GIPI_WITEM_DISCOUNT%ROWTYPE);
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.19.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WITEM_DISCOUNT
	*/
	PROCEDURE del_gipi_witem_discount (p_par_id 	GIPI_WITEM_DISCOUNT.par_id%TYPE);
	
	PROCEDURE delete_other_discount(p_par_id 		gipi_witem.par_id%TYPE,
  								  p_item_no 	gipi_witem.item_no%TYPE);
	
END Gipi_Witem_Discount_Pkg;
/



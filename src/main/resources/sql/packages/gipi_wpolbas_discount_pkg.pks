CREATE OR REPLACE PACKAGE CPI.Gipi_Wpolbas_Discount_Pkg
AS
  	TYPE gipi_wpolbas_discount_type IS RECORD
	(par_id					GIPI_WPOLBAS_DISCOUNT.par_id%TYPE,									
	 line_cd				GIPI_WPOLBAS_DISCOUNT.line_cd%TYPE,
	 subline_cd				GIPI_WPOLBAS_DISCOUNT.subline_cd%TYPE,
	 disc_rt				GIPI_WPOLBAS_DISCOUNT.disc_rt%TYPE,
	 disc_amt				GIPI_WPOLBAS_DISCOUNT.disc_amt%TYPE,
	 net_gross_tag			GIPI_WPOLBAS_DISCOUNT.net_gross_tag%TYPE,
	 orig_prem_amt			GIPI_WPOLBAS_DISCOUNT.orig_prem_amt%TYPE,
	 SEQUENCE				GIPI_WPOLBAS_DISCOUNT.SEQUENCE%TYPE,
	 remarks				GIPI_WPOLBAS_DISCOUNT.remarks%TYPE,
	 net_prem_amt			GIPI_WPOLBAS_DISCOUNT.net_prem_amt%TYPE,
	 surcharge_rt			GIPI_WPOLBAS_DISCOUNT.surcharge_rt%TYPE,
	 surcharge_amt			GIPI_WPOLBAS_DISCOUNT.surcharge_amt%TYPE
	 );
	 
	TYPE gipi_wpolbas_discount_tab IS TABLE OF gipi_wpolbas_discount_type;
	
	FUNCTION get_gipi_wpolbas_discount (p_par_id     GIPI_WPOLBAS_DISCOUNT.par_id%TYPE)
    RETURN gipi_wpolbas_discount_tab PIPELINED;
	
	PROCEDURE set_gipi_wpolbas_discount (p_wpolbas_disc IN GIPI_WPOLBAS_DISCOUNT%ROWTYPE);
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.19.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WPOLBAS_DISCOUNT
	*/
	PROCEDURE del_gipi_wpolbas_discount (p_par_id 	GIPI_WPOLBAS_DISCOUNT.par_id%TYPE);
	
	PROCEDURE delete_all_discounts(p_par_id	GIPI_WPOLBAS_DISCOUNT.par_id%TYPE);
    
    FUNCTION validate_surcharge_amt(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE
        ) RETURN VARCHAR2;
    
    FUNCTION validate_disc_surc_amt_item(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE
        ) RETURN VARCHAR2;
            
    FUNCTION validate_disc_surc_amt_peril(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE,
        p_peril_cd  gipi_witmperl.peril_cd%TYPE
        ) RETURN VARCHAR2;
                
END Gipi_Wpolbas_Discount_Pkg;
/



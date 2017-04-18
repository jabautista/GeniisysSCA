CREATE OR REPLACE PACKAGE CPI.GIPI_PAR_VEHICLE_PKG
AS
	TYPE gipi_par_mc_type IS RECORD
    (par_id					GIPI_WITEM.par_id%TYPE,
	 item_no				GIPI_WITEM.item_no%TYPE,
	 item_title				GIPI_WITEM.item_title%TYPE,	/* master item start */
	 item_desc				GIPI_WITEM.item_desc%TYPE,
	 item_desc2				GIPI_WITEM.item_desc2%TYPE,
	 currency_cd			GIPI_WITEM.currency_cd%TYPE,
	 currency_rt			GIPI_WITEM.currency_rt%TYPE,
	 coverage_cd			GIPI_WITEM.coverage_cd%TYPE,	/* master item end */
	 currency_desc			GIIS_CURRENCY.currency_desc%TYPE,
	 coverage_desc			GIIS_COVERAGE.coverage_desc%TYPE,
	 plate_no				GIPI_WVEHICLE.plate_no%TYPE,
	 motor_no				GIPI_WVEHICLE.motor_no%TYPE,
	 serial_no				GIPI_WVEHICLE.serial_no%TYPE,
	 subline_type_cd		GIPI_WVEHICLE.subline_type_cd%TYPE,
	 mot_type				GIPI_WVEHICLE.mot_type%TYPE,
	 car_company_cd			GIPI_WVEHICLE.car_company_cd%TYPE,
	 coc_yy					GIPI_WVEHICLE.coc_yy%TYPE,
	 coc_seq_no				GIPI_WVEHICLE.coc_seq_no%TYPE,
	 coc_serial_no			GIPI_WVEHICLE.coc_serial_no%TYPE,
	 coc_type				GIPI_WVEHICLE.coc_type%TYPE,
	 repair_lim				GIPI_WVEHICLE.repair_lim%TYPE,
	 color					GIPI_WVEHICLE.color%TYPE,
	 model_year				GIPI_WVEHICLE.model_year%TYPE,
	 make					GIPI_WVEHICLE.make%TYPE,
	 est_value				GIPI_WVEHICLE.est_value%TYPE,
	 towing					GIPI_WVEHICLE.towing%TYPE,
	 assignee				GIPI_WVEHICLE.assignee%TYPE,
	 no_of_pass				GIPI_WVEHICLE.no_of_pass%TYPE,
	 tariff_zone			GIPI_WVEHICLE.tariff_zone%TYPE,
	 coc_issue_date			GIPI_WVEHICLE.coc_issue_date%TYPE,
	 mv_file_no				GIPI_WVEHICLE.mv_file_no%TYPE,
	 acquired_from			GIPI_WVEHICLE.acquired_from%TYPE,
	 ctv_tag				GIPI_WVEHICLE.ctv_tag%TYPE,
	 type_of_body_cd		GIPI_WVEHICLE.type_of_body_cd%TYPE,
	 unladen_wt				GIPI_WVEHICLE.unladen_wt%TYPE,
	 make_cd				GIPI_WVEHICLE.make_cd%TYPE,
	 series_cd				GIPI_WVEHICLE.series_cd%TYPE,
	 basic_color_cd			GIPI_WVEHICLE.basic_color_cd%TYPE,
	 color_cd				GIPI_WVEHICLE.color_cd%TYPE,
	 origin					GIPI_WVEHICLE.origin%TYPE,
	 destination			GIPI_WVEHICLE.destination%TYPE,
	 coc_atcn				GIPI_WVEHICLE.coc_atcn%TYPE,
	 coc_serial_sw			GIPI_WVEHICLE.coc_serial_sw%TYPE,
	 subline_cd				GIPI_WVEHICLE.subline_cd%TYPE,
	 motor_coverage			GIPI_WVEHICLE.motor_coverage%TYPE,
	 subline_type_desc		GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
	 car_company			GIIS_MC_CAR_COMPANY.car_company%TYPE,
	 basic_color			GIIS_MC_COLOR.basic_color%TYPE,
	 type_of_body			GIIS_TYPE_OF_BODY.type_of_body%TYPE, 
	 deductible_amt			NUMBER(16,2) /* detail ends here */,
	 exists_ded				NUMBER,
	 exists_ded2			NUMBER
	 /*user_id			  GIPI_QUOTE_ITEM_MC.user_id%TYPE,                
	 last_update		  GIPI_QUOTE_ITEM_MC.last_update%TYPE, 
	 engine_series        GIIS_MC_ENG_SERIES.engine_series%TYPE*/	 
	 );   

	TYPE gipi_par_mc_tab IS TABLE OF gipi_par_mc_type;	
  
	FUNCTION get_gipi_par_mc (
		p_par_id   GIPI_WVEHICLE.par_id%TYPE,
		p_item_no    GIPI_WVEHICLE.item_no%TYPE)
	RETURN gipi_par_mc_tab PIPELINED;

	FUNCTION get_all_gipi_par_mc (p_par_id      GIPI_WVEHICLE.par_id%TYPE)
    RETURN gipi_par_mc_tab PIPELINED;

	FUNCTION get_item_deductible_amount (
		p_par_id	GIPI_WDEDUCTIBLES.par_id%TYPE,
		p_item_no	GIPI_WDEDUCTIBLES.item_no%TYPE)
	RETURN NUMBER;
	
	FUNCTION records_in_wdeductibles (
		p_par_id	GIPI_WDEDUCTIBLES.par_id%TYPE,
		p_item_no GIPI_WDEDUCTIBLES.item_no%TYPE)
	RETURN NUMBER;
	
	FUNCTION records_in_witems (
		p_par_id	GIPI_WDEDUCTIBLES.par_id%TYPE,
		p_item_no GIPI_WDEDUCTIBLES.item_no%TYPE)
	RETURN NUMBER;
	
	PROCEDURE set_gipi_par_mc (p_par_item_mc             GIPI_WVEHICLE%ROWTYPE);
	
	PROCEDURE set_gipi_par_item (p_item		GIPI_WITEM%ROWTYPE);
	
	PROCEDURE delete_gipi_par_item (
		p_par_id		GIPI_WITEM.par_id%TYPE,
		p_item_no	GIPI_WITEM.item_no%TYPE);	
END GIPI_PAR_VEHICLE_PKG;
/



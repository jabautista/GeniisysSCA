CREATE OR REPLACE PACKAGE CPI.Gipi_Wvehicle_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WVEHICLE
    */
    TYPE gipi_wvehicle_type IS RECORD (
        par_id                 GIPI_WITEM.par_id%TYPE,
        item_no             GIPI_WITEM.item_no%TYPE,
        item_title             GIPI_WITEM.item_title%TYPE,
        item_grp             GIPI_WITEM.item_grp%TYPE,
        item_desc             GIPI_WITEM.item_desc%TYPE,
        item_desc2             GIPI_WITEM.item_desc2%TYPE,
        tsi_amt             GIPI_WITEM.tsi_amt%TYPE,
        prem_amt             GIPI_WITEM.prem_amt%TYPE,
        ann_prem_amt         GIPI_WITEM.ann_prem_amt%TYPE,
        ann_tsi_amt         GIPI_WITEM.ann_tsi_amt%TYPE,
        rec_flag             GIPI_WITEM.rec_flag%TYPE,
        currency_cd         GIPI_WITEM.currency_cd%TYPE,
        currency_rt         GIPI_WITEM.currency_rt%TYPE,
        group_cd             GIPI_WITEM.group_cd%TYPE,
        from_date             GIPI_WITEM.from_date%TYPE,
        TO_DATE             GIPI_WITEM.TO_DATE%TYPE,
        pack_line_cd         GIPI_WITEM.pack_line_cd%TYPE,
        pack_subline_cd     GIPI_WITEM.pack_subline_cd%TYPE,
        discount_sw         GIPI_WITEM.discount_sw%TYPE,
        coverage_cd         GIPI_WITEM.coverage_cd%TYPE,
        other_info             GIPI_WITEM.other_info%TYPE,
        surcharge_sw         GIPI_WITEM.surcharge_sw%TYPE,
        region_cd             GIPI_WITEM.region_cd%TYPE,
        changed_tag         GIPI_WITEM.changed_tag%TYPE,
        prorate_flag         GIPI_WITEM.prorate_flag%TYPE,
        comp_sw             GIPI_WITEM.comp_sw%TYPE,
        short_rt_percent     GIPI_WITEM.short_rt_percent%TYPE,
        pack_ben_cd         GIPI_WITEM.pack_ben_cd%TYPE,
        payt_terms             GIPI_WITEM.payt_terms%TYPE,
        risk_no             GIPI_WITEM.risk_no%TYPE,
        risk_item_no         GIPI_WITEM.risk_item_no%TYPE,
        currency_desc        GIIS_CURRENCY.currency_desc%TYPE,
        coverage_desc        GIIS_COVERAGE.coverage_desc%TYPE,
        plate_no            GIPI_WVEHICLE.plate_no%TYPE,
        motor_no            GIPI_WVEHICLE.motor_no%TYPE,
        serial_no            GIPI_WVEHICLE.serial_no%TYPE,
        subline_type_cd        GIPI_WVEHICLE.subline_type_cd%TYPE,
        mot_type            GIPI_WVEHICLE.mot_type%TYPE,
        car_company_cd        GIPI_WVEHICLE.car_company_cd%TYPE,
        coc_yy                GIPI_WVEHICLE.coc_yy%TYPE,
        coc_seq_no            GIPI_WVEHICLE.coc_seq_no%TYPE,
        coc_serial_no        GIPI_WVEHICLE.coc_serial_no%TYPE,
        coc_type            GIPI_WVEHICLE.coc_type%TYPE,
        repair_lim            GIPI_WVEHICLE.repair_lim%TYPE,
        color                GIPI_WVEHICLE.color%TYPE,
        model_year            GIPI_WVEHICLE.model_year%TYPE,
        make                GIPI_WVEHICLE.make%TYPE,
        est_value            GIPI_WVEHICLE.est_value%TYPE,
        towing                GIPI_WVEHICLE.towing%TYPE,
        assignee            GIPI_WVEHICLE.assignee%TYPE,
        no_of_pass            GIPI_WVEHICLE.no_of_pass%TYPE,
        tariff_zone            GIPI_WVEHICLE.tariff_zone%TYPE,
        coc_issue_date        GIPI_WVEHICLE.coc_issue_date%TYPE,
        mv_file_no            GIPI_WVEHICLE.mv_file_no%TYPE,
        acquired_from        GIPI_WVEHICLE.acquired_from%TYPE,
        ctv_tag                GIPI_WVEHICLE.ctv_tag%TYPE,
        type_of_body_cd        GIPI_WVEHICLE.type_of_body_cd%TYPE,
        unladen_wt            GIPI_WVEHICLE.unladen_wt%TYPE,
        make_cd                GIPI_WVEHICLE.make_cd%TYPE,
        series_cd            GIPI_WVEHICLE.series_cd%TYPE,
        basic_color_cd        GIPI_WVEHICLE.basic_color_cd%TYPE,
        color_cd            GIPI_WVEHICLE.color_cd%TYPE,
        origin                GIPI_WVEHICLE.origin%TYPE,
        destination            GIPI_WVEHICLE.destination%TYPE,
        coc_atcn            GIPI_WVEHICLE.coc_atcn%TYPE,
        coc_serial_sw        GIPI_WVEHICLE.coc_serial_sw%TYPE,
        subline_cd            GIPI_WVEHICLE.subline_cd%TYPE,
        motor_coverage        GIPI_WVEHICLE.motor_coverage%TYPE,
        subline_type_desc    GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
        car_company            GIIS_MC_CAR_COMPANY.car_company%TYPE,
        basic_color            GIIS_MC_COLOR.basic_color%TYPE,
        type_of_body        GIIS_TYPE_OF_BODY.type_of_body%TYPE, 
        deductible_amt        NUMBER(16,2) /* detail ends here */
        /*user_id              GIPI_QUOTE_ITEM_MC.user_id%TYPE,                
        last_update          GIPI_QUOTE_ITEM_MC.last_update%TYPE, 
        engine_series        GIIS_MC_ENG_SERIES.engine_series%TYPE*/);   

    TYPE gipi_wvehicle_tab IS TABLE OF gipi_wvehicle_type;

    TYPE gipi_wvehicle_par_type IS RECORD (
        par_id                gipi_wvehicle.par_id%TYPE,
        item_no                gipi_wvehicle.item_no%TYPE,
        subline_cd            gipi_wvehicle.subline_cd%TYPE,
        motor_no            gipi_wvehicle.motor_no%TYPE,
        plate_no            gipi_wvehicle.plate_no%TYPE,
        est_value            gipi_wvehicle.est_value%TYPE,
        make                gipi_wvehicle.make%TYPE,
        mot_type            gipi_wvehicle.mot_type%TYPE,
        color            gipi_wvehicle.color%TYPE,
        repair_lim            gipi_wvehicle.repair_lim%TYPE,
        serial_no            gipi_wvehicle.serial_no%TYPE,
        coc_seq_no            gipi_wvehicle.coc_seq_no%TYPE,
        coc_serial_no        gipi_wvehicle.coc_serial_no%TYPE,
        coc_type            gipi_wvehicle.coc_type%TYPE,
        assignee            gipi_wvehicle.assignee%TYPE,
        model_year            gipi_wvehicle.model_year%TYPE,
        coc_issue_date        gipi_wvehicle.coc_issue_date%TYPE,
        coc_yy                gipi_wvehicle.coc_yy%TYPE,
        towing                gipi_wvehicle.towing%TYPE,
        subline_type_cd        gipi_wvehicle.subline_type_cd%TYPE,
        no_of_pass            gipi_wvehicle.no_of_pass%TYPE,
        tariff_zone            gipi_wvehicle.tariff_zone%TYPE,
        mv_file_no            gipi_wvehicle.mv_file_no%TYPE,
        acquired_from        gipi_wvehicle.acquired_from%TYPE,
        ctv_tag                gipi_wvehicle.ctv_tag%TYPE,
        car_company_cd        gipi_wvehicle.car_company_cd%TYPE,
        type_of_body_cd        gipi_wvehicle.type_of_body_cd%TYPE,
        unladen_wt            gipi_wvehicle.unladen_wt%TYPE,
        make_cd                gipi_wvehicle.make_cd%TYPE,
        series_cd            gipi_wvehicle.series_cd%TYPE,
        basic_color_cd        gipi_wvehicle.basic_color_cd%TYPE,
        color_cd            gipi_wvehicle.color_cd%TYPE,
        origin                gipi_wvehicle.origin%TYPE,
        destination            gipi_wvehicle.destination%TYPE,
        coc_atcn            gipi_wvehicle.coc_atcn%TYPE,
        motor_coverage        gipi_wvehicle.motor_coverage%TYPE,
        coc_serial_sw        gipi_wvehicle.coc_serial_sw%TYPE,
        car_company            giis_mc_car_company.car_company%TYPE,
        engine_series        giis_mc_eng_series.engine_series%TYPE,
        basic_color         giis_mc_color.basic_color%TYPE,
        color_desc          giis_mc_color.color%TYPE,
		reg_type			gipi_wvehicle.reg_type%TYPE,
		mv_type				gipi_wvehicle.mv_type%TYPE,
		mv_type_desc		cg_ref_codes.rv_meaning%TYPE,
		mv_prem_type		gipi_wvehicle.mv_prem_type%TYPE,
		mv_prem_type_desc   cg_ref_codes.rv_meaning%TYPE,
		tax_type			gipi_wvehicle.tax_type%TYPE		
		);
    
    TYPE gipi_wvehicle_tab_all_cols IS TABLE OF gipi_wvehicle_par_type;
  
    FUNCTION get_gipi_wvehicle (
        p_par_id   GIPI_WVEHICLE.par_id%TYPE,
        p_item_no    GIPI_WVEHICLE.item_no%TYPE)
    RETURN gipi_wvehicle_tab PIPELINED;    

    FUNCTION get_all_gipi_wvehicle (p_par_id      GIPI_WVEHICLE.par_id%TYPE)
    RETURN gipi_wvehicle_tab PIPELINED;

    FUNCTION get_item_deductible_amount (
        p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    GIPI_WDEDUCTIBLES.item_no%TYPE)
    RETURN NUMBER;    
    
    Procedure set_gipi_vehicle (p_par_item_mc GIPI_WVEHICLE%ROWTYPE);
    
    Procedure set_gipi_wvehicle_1 (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no            IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no            IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no            IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value            IN GIPI_WVEHICLE.est_value%TYPE,
        p_make                IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type            IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color                IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no            IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no        IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type            IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee            IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd    IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone        IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from        IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag            IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd    IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd            IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd            IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd            IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination        IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn            IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw        IN GIPI_WVEHICLE.coc_serial_sw%TYPE);
		
	Procedure set_gipi_wvehicle_new (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no           IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no          IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no          IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value         IN GIPI_WVEHICLE.est_value%TYPE,
        p_make              IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type          IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color             IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no         IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no     IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type          IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee          IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd   IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone       IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from     IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag           IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd   IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd           IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd         IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd          IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination       IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn          IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw     IN GIPI_WVEHICLE.coc_serial_sw%TYPE,
		p_reg_type			IN GIPI_WVEHICLE.reg_type%TYPE,
		p_mv_type			IN GIPI_WVEHICLE.mv_type%TYPE,
		p_mv_prem_type		IN GIPI_WVEHICLE.mv_prem_type%TYPE);
    
    
    Procedure delete_gipi_par_item (
        p_par_id        GIPI_WITEM.par_id%TYPE,
        p_item_no    GIPI_WITEM.item_no%TYPE);

    Procedure del_gipi_wvehicle (
        p_par_id    GIPI_WVEHICLE.par_id%TYPE,
        p_item_no    GIPI_WVEHICLE.item_no%TYPE);
        
    Procedure del_gipi_wvehicle (p_par_id IN GIPI_WVEHICLE.par_id%TYPE);
    
    FUNCTION get_gipi_wvehicle1(
        p_par_id    IN gipi_wvehicle.par_id%TYPE,
        p_item_no    IN gipi_wvehicle.item_no%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED;
	
	FUNCTION get_gipi_wvehicle_pack_pol (
		p_par_id    IN gipi_wvehicle.par_id%TYPE,
        p_item_no    IN gipi_wvehicle.item_no%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED;
    
    PROCEDURE set_vehicle_on_mcupload (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no            IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no            IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no            IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value            IN GIPI_WVEHICLE.est_value%TYPE,
        p_make                IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type            IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color                IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no            IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no        IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type            IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee            IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd    IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone        IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from        IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag            IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd    IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd            IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd            IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd            IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination        IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn            IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw        IN GIPI_WVEHICLE.coc_serial_sw%TYPE
    );
    
    FUNCTION get_vehicles_GIPIS198(
        p_par_id    IN gipi_wvehicle.par_id%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED;
    
	/*
	**  Created by		: Gzelle
	**  Date Created 	: 09.24.2014
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: MC Fleet Upload - checks if entered codes are existing in maintenance tables
    */
    FUNCTION validate_mc_upload(
        p_subline_cd        giis_mc_subline_type.subline_cd%TYPE,
        p_subline_type_cd   giis_mc_subline_type.subline_type_cd%TYPE,
        p_car_company_cd    giis_mc_car_company.car_company_cd%TYPE,
        p_make_cd           giis_mc_make.make_cd%TYPE,
        p_make              giis_mc_make.make%TYPE,
        p_series_cd         giis_mc_eng_series.series_cd%TYPE,
        p_color             giis_mc_color.color%TYPE,
        p_basic_color_cd    giis_mc_color.basic_color_cd%TYPE,
        p_color_cd          giis_mc_color.color_cd%TYPE,
        p_par_id            gipi_witem.par_id%TYPE,
        p_item_no           gipi_witem.item_no%TYPE
    )
        RETURN BOOLEAN;
    
    FUNCTION get_par_vat_tag (p_par_id gipi_wvehicle.par_id%TYPE)
      RETURN VARCHAR2;

END Gipi_Wvehicle_Pkg;
/



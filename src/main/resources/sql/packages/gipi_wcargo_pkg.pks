CREATE OR REPLACE PACKAGE CPI.Gipi_Wcargo_Pkg
AS
    TYPE gipi_wcargo_type IS RECORD (
         par_id                 GIPI_WITEM.par_id%TYPE,
         item_no                 GIPI_WITEM.item_no%TYPE,
         item_title             GIPI_WITEM.item_title%TYPE,
         item_grp                 GIPI_WITEM.item_grp%TYPE,
         item_desc                 GIPI_WITEM.item_desc%TYPE,
         item_desc2             GIPI_WITEM.item_desc2%TYPE,
         tsi_amt                 GIPI_WITEM.tsi_amt%TYPE,
         prem_amt                 GIPI_WITEM.prem_amt%TYPE,
         ann_prem_amt             GIPI_WITEM.ann_prem_amt%TYPE,
         ann_tsi_amt             GIPI_WITEM.ann_tsi_amt%TYPE,
         rec_flag                 GIPI_WITEM.rec_flag%TYPE,
         currency_cd             GIPI_WITEM.currency_cd%TYPE,
         currency_rt             GIPI_WITEM.currency_rt%TYPE,
         group_cd                 GIPI_WITEM.group_cd%TYPE,
         from_date                 GIPI_WITEM.from_date%TYPE,
         TO_DATE                 GIPI_WITEM.TO_DATE%TYPE,
         pack_line_cd             GIPI_WITEM.pack_line_cd%TYPE,
         pack_subline_cd         GIPI_WITEM.pack_subline_cd%TYPE,
         discount_sw             GIPI_WITEM.discount_sw%TYPE,
         coverage_cd             GIPI_WITEM.coverage_cd%TYPE,
         other_info             GIPI_WITEM.other_info%TYPE,
         surcharge_sw             GIPI_WITEM.surcharge_sw%TYPE,
         region_cd                 GIPI_WITEM.region_cd%TYPE,
         changed_tag             GIPI_WITEM.changed_tag%TYPE,
         prorate_flag             GIPI_WITEM.prorate_flag%TYPE,
         comp_sw                 GIPI_WITEM.comp_sw%TYPE,
         short_rt_percent         GIPI_WITEM.short_rt_percent%TYPE,
         pack_ben_cd             GIPI_WITEM.pack_ben_cd%TYPE,
         payt_terms             GIPI_WITEM.payt_terms%TYPE,
         risk_no                 GIPI_WITEM.risk_no%TYPE,
         risk_item_no             GIPI_WITEM.risk_item_no%TYPE,
         print_tag                GIPI_WCARGO.print_tag%TYPE,
         vessel_cd                GIPI_WCARGO.vessel_cd%TYPE,
         geog_cd                GIPI_WCARGO.geog_cd%TYPE,
         cargo_class_cd            GIPI_WCARGO.cargo_class_cd%TYPE,
         voyage_no                GIPI_WCARGO.voyage_no%TYPE,
         bl_awb                    GIPI_WCARGO.bl_awb%TYPE,
         origin                    GIPI_WCARGO.origin%TYPE,
         destn                    GIPI_WCARGO.destn%TYPE,
         etd                      GIPI_WCARGO.etd%TYPE,
         eta                    GIPI_WCARGO.eta%TYPE,
         cargo_type                GIPI_WCARGO.cargo_type%TYPE,
         deduct_text            GIPI_WCARGO.deduct_text%TYPE,
         pack_method            GIPI_WCARGO.pack_method%TYPE,
         tranship_origin        GIPI_WCARGO.tranship_origin%TYPE,
         tranship_destination    GIPI_WCARGO.tranship_destination%TYPE,
         lc_no                    GIPI_WCARGO.lc_no%TYPE,
         invoice_value            GIPI_WCARGO.invoice_value%TYPE,
         inv_curr_cd              GIPI_WCARGO.inv_curr_cd%TYPE,
         inv_curr_rt            GIPI_WCARGO.inv_curr_rt%TYPE,
         markup_rate            GIPI_WCARGO.markup_rate%TYPE,
         rec_flag_wcargo        GIPI_WCARGO.rec_flag%TYPE,
         cpi_rec_no                GIPI_WCARGO.cpi_rec_no%TYPE,
         cpi_branch_cd            GIPI_WCARGO.cpi_branch_cd%TYPE,
         currency_desc            GIIS_CURRENCY.currency_desc%TYPE,
         coverage_desc            GIIS_COVERAGE.coverage_desc%TYPE,
         peril_exist            VARCHAR2(2000),
         itmperl_grouped_exists VARCHAR2(1)
         );
         
    TYPE gipi_wcargo_tab IS TABLE OF gipi_wcargo_type;

    TYPE gipi_wcargo_par_type IS RECORD (
        par_id                    gipi_wcargo.par_id%TYPE,
        item_no                    gipi_wcargo.item_no%TYPE,
        rec_flag                gipi_wcargo.rec_flag%TYPE,
        print_tag                gipi_wcargo.print_tag%TYPE,        
        vessel_cd                gipi_wcargo.vessel_cd%TYPE,
        geog_cd                    gipi_wcargo.geog_cd%TYPE,
        cargo_class_cd            gipi_wcargo.cargo_class_cd%TYPE,
        cargo_class_desc        giis_cargo_class.cargo_class_desc%TYPE,
        voyage_no                gipi_wcargo.voyage_no%TYPE,
        bl_awb                    gipi_wcargo.bl_awb%TYPE,
        origin                    gipi_wcargo.origin%TYPE,
        destn                    gipi_wcargo.destn%TYPE,
        etd                        gipi_wcargo.etd%TYPE,
        eta                        gipi_wcargo.eta%TYPE,
        cargo_type                gipi_wcargo.cargo_type%TYPE,
        cargo_type_desc            giis_cargo_type.cargo_type_desc%TYPE,
        deduct_text                gipi_wcargo.deduct_text%TYPE,
        pack_method                gipi_wcargo.pack_method%TYPE,
        tranship_origin            gipi_wcargo.tranship_origin%TYPE,
        tranship_destination    gipi_wcargo.tranship_destination%TYPE,
        lc_no                    gipi_wcargo.lc_no%TYPE,
        cpi_rec_no                gipi_wcargo.cpi_rec_no%TYPE,
        cpi_branch_cd            gipi_wcargo.cpi_branch_cd%TYPE,
        invoice_value            gipi_wcargo.invoice_value%TYPE,
        inv_curr_cd                gipi_wcargo.inv_curr_cd%TYPE,
        inv_curr_rt                gipi_wcargo.inv_curr_rt%TYPE,
        markup_rate                gipi_wcargo.markup_rate%TYPE);
    
    TYPE gipi_wcargo_par_tab IS TABLE OF gipi_wcargo_par_type;
    
    FUNCTION get_gipi_wcargos (p_par_id GIPI_WCARGO.par_id%TYPE)
    RETURN gipi_wcargo_tab PIPELINED;
    
    FUNCTION get_gipi_wcargos1 (
        p_par_id IN gipi_wcargo.par_id%TYPE,
        p_item_no IN gipi_wcargo.item_no%TYPE)
    RETURN gipi_wcargo_par_tab PIPELINED;
    
    Procedure set_gipi_wcargo(
         p_par_id                 GIPI_WCARGO.par_id%TYPE,
         p_item_no                 GIPI_WCARGO.item_no%TYPE,
         p_print_tag            GIPI_WCARGO.print_tag%TYPE,
         p_vessel_cd            GIPI_WCARGO.vessel_cd%TYPE,
         p_geog_cd                GIPI_WCARGO.geog_cd%TYPE,
         p_cargo_class_cd        GIPI_WCARGO.cargo_class_cd%TYPE,
         p_voyage_no            GIPI_WCARGO.voyage_no%TYPE,
         p_bl_awb                GIPI_WCARGO.bl_awb%TYPE,
         p_origin                GIPI_WCARGO.origin%TYPE,
         p_destn                GIPI_WCARGO.destn%TYPE,
         p_etd                  GIPI_WCARGO.etd%TYPE,
         p_eta                    GIPI_WCARGO.eta%TYPE,
         p_cargo_type            GIPI_WCARGO.cargo_type%TYPE,
         p_deduct_text            GIPI_WCARGO.deduct_text%TYPE,
         p_pack_method            GIPI_WCARGO.pack_method%TYPE,
         p_tranship_origin        GIPI_WCARGO.tranship_origin%TYPE,
         p_tranship_destination    GIPI_WCARGO.tranship_destination%TYPE,
         p_lc_no                GIPI_WCARGO.lc_no%TYPE,
         p_invoice_value        GIPI_WCARGO.invoice_value%TYPE,
         p_inv_curr_cd          GIPI_WCARGO.inv_curr_cd%TYPE,
         p_inv_curr_rt            GIPI_WCARGO.inv_curr_rt%TYPE,
         p_markup_rate            GIPI_WCARGO.markup_rate%TYPE,
         p_rec_flag_wcargo        GIPI_WCARGO.rec_flag%TYPE,
         p_cpi_rec_no            GIPI_WCARGO.cpi_rec_no%TYPE,
         p_cpi_branch_cd        GIPI_WCARGO.cpi_branch_cd%TYPE
         );

  Procedure del_gipi_wcargo(p_par_id    GIPI_WCARGO.par_id%TYPE,
                              p_item_no   GIPI_WCARGO.item_no%TYPE);

    Procedure del_gipi_wcargo (p_par_id IN GIPI_WCARGO.par_id%TYPE);

    FUNCTION get_gipi_wcargo_pack_pol (
        p_par_id IN gipi_wcargo.par_id%TYPE,
        p_item_no IN gipi_wcargo.item_no%TYPE)
    RETURN gipi_wcargo_par_tab PIPELINED;
END Gipi_Wcargo_Pkg;
/



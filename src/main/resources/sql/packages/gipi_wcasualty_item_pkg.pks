CREATE OR REPLACE PACKAGE CPI.Gipi_Wcasualty_Item_Pkg
AS
    TYPE gipi_wcasualty_item_type IS RECORD (
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
         section_line_cd        GIPI_WCASUALTY_ITEM.section_line_cd%TYPE,
         section_subline_cd        GIPI_WCASUALTY_ITEM.section_subline_cd%TYPE,
         section_or_hazard_cd    GIPI_WCASUALTY_ITEM.section_or_hazard_cd%TYPE,
         property_no_type        GIPI_WCASUALTY_ITEM.property_no_type%TYPE,
         capacity_cd            GIPI_WCASUALTY_ITEM.capacity_cd%TYPE,
         property_no            GIPI_WCASUALTY_ITEM.property_no%TYPE,
         LOCATION                GIPI_WCASUALTY_ITEM.LOCATION%TYPE,
         conveyance_info        GIPI_WCASUALTY_ITEM.conveyance_info%TYPE,
         limit_of_liability        GIPI_WCASUALTY_ITEM.limit_of_liability%TYPE,
         interest_on_premises    GIPI_WCASUALTY_ITEM.interest_on_premises%TYPE,
         section_or_hazard_info    GIPI_WCASUALTY_ITEM.section_or_hazard_info%TYPE,
         location_cd            GIPI_WCASUALTY_ITEM.location_cd%TYPE,
         currency_desc            GIIS_CURRENCY.currency_desc%TYPE,
         coverage_desc            GIIS_COVERAGE.coverage_desc%TYPE,
         itmperl_grouped_exists VARCHAR2(1)
         );
         
    TYPE gipi_wcasualty_item_tab IS TABLE OF gipi_wcasualty_item_type;

    TYPE gipi_wcasualty_item_par_type IS RECORD (
        par_id                    gipi_wcasualty_item.par_id%TYPE,
        item_no                    gipi_wcasualty_item.item_no%TYPE,
        section_line_cd            gipi_wcasualty_item.section_line_cd%TYPE,
        section_subline_cd        gipi_wcasualty_item.section_subline_cd%TYPE,
        section_or_hazard_cd    gipi_wcasualty_item.section_or_hazard_cd%TYPE,
        property_no_type        gipi_wcasualty_item.property_no_type%TYPE,
        capacity_cd                gipi_wcasualty_item.capacity_cd%TYPE,
        property_no                gipi_wcasualty_item.property_no%TYPE,
        location                gipi_wcasualty_item.location%TYPE,
        conveyance_info            gipi_wcasualty_item.conveyance_info%TYPE,
        limit_of_liability        gipi_wcasualty_item.limit_of_liability%TYPE,
        interest_on_premises    gipi_wcasualty_item.interest_on_premises%TYPE,
        section_or_hazard_info    gipi_wcasualty_item.section_or_hazard_info%TYPE,
        location_cd                gipi_wcasualty_item.location_cd%TYPE
    );
    
    TYPE gipi_wcasualty_item_par_tab IS TABLE OF gipi_wcasualty_item_par_type;
    
    FUNCTION get_gipi_wcasualty_items (p_par_id GIPI_WCASUALTY_ITEM.par_id%TYPE)
    RETURN gipi_wcasualty_item_tab PIPELINED;
    
    FUNCTION get_gipi_wcasualty_items1 (
        p_par_id     IN gipi_wcasualty_item.par_id%TYPE,
        p_item_no    IN gipi_wcasualty_item.item_no%TYPE)
    RETURN gipi_wcasualty_item_par_tab PIPELINED;
    
    Procedure set_gipi_wcasualty_item(
              p_par_id                      GIPI_WCASUALTY_ITEM.par_id%TYPE,
              p_item_no                      GIPI_WCASUALTY_ITEM.item_no%TYPE,
              p_section_line_cd              GIPI_WCASUALTY_ITEM.section_line_cd%TYPE,
              p_section_subline_cd          GIPI_WCASUALTY_ITEM.section_subline_cd%TYPE,
              p_section_or_hazard_cd      GIPI_WCASUALTY_ITEM.section_or_hazard_cd%TYPE,
              p_property_no_type          GIPI_WCASUALTY_ITEM.property_no_type%TYPE,
              p_capacity_cd                  GIPI_WCASUALTY_ITEM.capacity_cd%TYPE,
              p_property_no                  GIPI_WCASUALTY_ITEM.property_no%TYPE,
              p_location                  GIPI_WCASUALTY_ITEM.LOCATION%TYPE,
              p_conveyance_info              GIPI_WCASUALTY_ITEM.conveyance_info%TYPE,
              p_limit_of_liability          GIPI_WCASUALTY_ITEM.limit_of_liability%TYPE,
              p_interest_on_premises      GIPI_WCASUALTY_ITEM.interest_on_premises%TYPE,
              p_section_or_hazard_info      GIPI_WCASUALTY_ITEM.section_or_hazard_info%TYPE,
              p_location_cd                  GIPI_WCASUALTY_ITEM.location_cd%TYPE  
              );      
    
    Procedure del_gipi_wcasualty_item(p_par_id    GIPI_WCASUALTY_ITEM.par_id%TYPE,
                                        p_item_no   GIPI_WCASUALTY_ITEM.item_no%TYPE);            
    
    Procedure del_gipi_wcasualty_item (p_par_id IN GIPI_WCASUALTY_ITEM.par_id%TYPE);
	
	FUNCTION get_gipi_wcasualty_pack_pol (
		p_par_id IN gipi_wcasualty_item.par_id%TYPE,
		p_item_no IN gipi_wcasualty_item.item_no%TYPE)
	RETURN gipi_wcasualty_item_par_tab PIPELINED;
END;
/



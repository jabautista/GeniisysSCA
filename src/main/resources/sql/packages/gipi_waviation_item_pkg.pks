CREATE OR REPLACE PACKAGE CPI.Gipi_Waviation_Item_Pkg 
AS

  TYPE gipi_waviation_type IS RECORD (
		 par_id 				GIPI_WITEM.par_id%TYPE,
		 item_no 				GIPI_WITEM.item_no%TYPE,
		 item_title 			GIPI_WITEM.item_title%TYPE,
		 item_grp 				GIPI_WITEM.item_grp%TYPE,
		 item_desc 				GIPI_WITEM.item_desc%TYPE,
		 item_desc2 			GIPI_WITEM.item_desc2%TYPE,
		 tsi_amt 				GIPI_WITEM.tsi_amt%TYPE,
		 prem_amt 				GIPI_WITEM.prem_amt%TYPE,
		 ann_prem_amt 		    GIPI_WITEM.ann_prem_amt%TYPE,
		 ann_tsi_amt 			GIPI_WITEM.ann_tsi_amt%TYPE,
		 rec_flag 				GIPI_WITEM.rec_flag%TYPE,
		 currency_cd 			GIPI_WITEM.currency_cd%TYPE,
		 currency_rt 			GIPI_WITEM.currency_rt%TYPE,
		 group_cd 				GIPI_WITEM.group_cd%TYPE,
		 from_date 				GIPI_WITEM.from_date%TYPE,
		 TO_DATE 				GIPI_WITEM.TO_DATE%TYPE,
		 pack_line_cd 			GIPI_WITEM.pack_line_cd%TYPE,
		 pack_subline_cd 		GIPI_WITEM.pack_subline_cd%TYPE,
		 discount_sw 			GIPI_WITEM.discount_sw%TYPE,
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
         vessel_cd                GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
         total_fly_time          GIPI_WAVIATION_ITEM.total_fly_time%TYPE,
         qualification             GIPI_WAVIATION_ITEM.qualification%TYPE,
         purpose                 GIPI_WAVIATION_ITEM.purpose%TYPE,
         geog_limit                GIPI_WAVIATION_ITEM.geog_limit%TYPE,
         deduct_text             GIPI_WAVIATION_ITEM.deduct_text%TYPE,
         rec_flag_av             GIPI_WAVIATION_ITEM.rec_flag%TYPE,
         fixed_wing                GIPI_WAVIATION_ITEM.fixed_wing%TYPE,
         rotor                    GIPI_WAVIATION_ITEM.rotor%TYPE,
         prev_util_hrs            GIPI_WAVIATION_ITEM.prev_util_hrs%TYPE,
         est_util_hrs            GIPI_WAVIATION_ITEM.est_util_hrs%TYPE,
         currency_desc            GIIS_CURRENCY.currency_desc%TYPE,
         coverage_desc            GIIS_COVERAGE.coverage_desc%TYPE,
         itmperl_grouped_exists VARCHAR2(1)
         );
         
    TYPE gipi_waviation_tab IS TABLE OF gipi_waviation_type;
    
    TYPE gipi_waviation_par_type IS RECORD(
        par_id            gipi_waviation_item.par_id%TYPE,
        item_no            gipi_waviation_item.item_no%TYPE,
        vessel_cd        gipi_waviation_item.vessel_cd%TYPE,
        total_fly_time    gipi_waviation_item.total_fly_time%TYPE,
        qualification    gipi_waviation_item.qualification%TYPE,
        purpose            gipi_waviation_item.purpose%TYPE,
        geog_limit        gipi_waviation_item.geog_limit%TYPE,
        deduct_text        gipi_waviation_item.deduct_text%TYPE,
        rec_flag_av        gipi_waviation_item.rec_flag%TYPE,
        fixed_wing        gipi_waviation_item.fixed_wing%TYPE,
        rotor            gipi_waviation_item.rotor%TYPE,
        prev_util_hrs    gipi_waviation_item.prev_util_hrs%TYPE,
        est_util_hrs    gipi_waviation_item.est_util_hrs%TYPE,
        vessel_name        giis_vessel.vessel_name%TYPE,
        rpc_no            giis_vessel.rpc_no%TYPE,
        air_desc        giis_air_type.air_desc%TYPE);
        
    TYPE gipi_waviation_par_tab IS TABLE OF gipi_waviation_par_type;    
    
    FUNCTION get_gipi_waviation_item (p_par_id GIPI_WAVIATION_ITEM.par_id%TYPE)
    RETURN gipi_waviation_tab PIPELINED;
    
    FUNCTION get_gipi_waviation_item (
        p_par_id    GIPI_WAVIATION_ITEM.par_id%TYPE,
        p_item_no   GIPI_WAVIATION_ITEM.item_no%TYPE)
    RETURN gipi_waviation_par_tab PIPELINED;
    
    Procedure get_gipi_waviation_item_exist (p_par_id  IN GIPI_WAVIATION_ITEM.par_id%TYPE,
                                               p_exist   OUT NUMBER);
    
    Procedure set_gipi_waviation_item(
         p_par_id                 GIPI_WITEM.par_id%TYPE,
         p_item_no                 GIPI_WITEM.item_no%TYPE,
         p_vessel_cd            GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
         p_total_fly_time          GIPI_WAVIATION_ITEM.total_fly_time%TYPE,
         p_qualification         GIPI_WAVIATION_ITEM.qualification%TYPE,
         p_purpose                 GIPI_WAVIATION_ITEM.purpose%TYPE,
         p_geog_limit            GIPI_WAVIATION_ITEM.geog_limit%TYPE,
         p_deduct_text             GIPI_WAVIATION_ITEM.deduct_text%TYPE,
         p_rec_flag_av             GIPI_WAVIATION_ITEM.rec_flag%TYPE,
         --p_fixed_wing            GIPI_WAVIATION_ITEM.fixed_wing%TYPE,
         --p_rotor                GIPI_WAVIATION_ITEM.rotor%TYPE,
         p_prev_util_hrs        GIPI_WAVIATION_ITEM.prev_util_hrs%TYPE,
         p_est_util_hrs            GIPI_WAVIATION_ITEM.est_util_hrs%TYPE
        );
    
    Procedure del_gipi_waviation_item(p_par_id    GIPI_WAVIATION_ITEM.par_id%TYPE,
                                          p_item_no   GIPI_WAVIATION_ITEM.item_no%TYPE);
    
    Procedure del_gipi_waviation_item(p_par_id IN GIPI_WAVIATION_ITEM.par_id%TYPE);
    
    Procedure set_gipi_waviation_item(
         p_par_id                 GIPI_WITEM.par_id%TYPE,
         p_item_no                 GIPI_WITEM.item_no%TYPE,
         p_vessel_cd            GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
         p_total_fly_time          GIPI_WAVIATION_ITEM.total_fly_time%TYPE,
         p_qualification         GIPI_WAVIATION_ITEM.qualification%TYPE,
         p_purpose                 GIPI_WAVIATION_ITEM.purpose%TYPE,
         p_geog_limit            GIPI_WAVIATION_ITEM.geog_limit%TYPE,
         p_deduct_text             GIPI_WAVIATION_ITEM.deduct_text%TYPE,
         p_rec_flag_av             GIPI_WAVIATION_ITEM.rec_flag%TYPE,
         p_fixed_wing            GIPI_WAVIATION_ITEM.fixed_wing%TYPE,
         p_rotor                GIPI_WAVIATION_ITEM.rotor%TYPE,
         p_prev_util_hrs        GIPI_WAVIATION_ITEM.prev_util_hrs%TYPE,
         p_est_util_hrs            GIPI_WAVIATION_ITEM.est_util_hrs%TYPE);
    
    FUNCTION get_gipi_waviation_pack_pol (
        p_par_id IN gipi_waviation_item.par_id%TYPE,
        p_item_no IN gipi_waviation_item.item_no%TYPE)
    RETURN gipi_waviation_par_tab PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.Gipi_Wcomm_Invoices_Pkg AS

    TYPE gipi_wcomm_invoices_type IS RECORD (
        intrmdry_intm_no    GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
        intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
        parent_intm_no        GIIS_INTERMEDIARY.parent_intm_no%TYPE,
        parent_intm_name    GIIS_INTERMEDIARY.intm_name%TYPE,
        share_percentage    GIPI_WCOMM_INVOICES.share_percentage%TYPE,
        takeup_seq_no        GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
        item_grp            GIPI_WCOMM_INVOICES.item_grp%TYPE,
        par_id                GIPI_WCOMM_INVOICES.par_id%TYPE,
        premium_amt            GIPI_WCOMM_INVOICES.premium_amt%TYPE,
        commission_amt        GIPI_WCOMM_INVOICES.commission_amt%TYPE,
        wholding_tax        GIPI_WCOMM_INVOICES.wholding_tax%TYPE,
        net_commission        NUMBER,
		parent_intm_lic_tag        GIIS_INTERMEDIARY.lic_tag%TYPE,
		parent_intm_special_rate        GIIS_INTERMEDIARY.special_rate%TYPE,
		lic_tag        		GIIS_INTERMEDIARY.lic_tag%TYPE,     --added by christian 08.25.2012
		special_rate		GIIS_INTERMEDIARY.special_rate%TYPE --added by christian 08.25.2012
		);
        
    TYPE gipis085_b240_type IS RECORD (
        par_id              GIPI_PARLIST.par_id%TYPE,
        line_cd             GIPI_PARLIST.line_cd%TYPE,
        iss_cd              GIPI_PARLIST.iss_cd%TYPE,
        par_yy              GIPI_PARLIST.par_yy%TYPE,
        par_seq_no          GIPI_PARLIST.par_seq_no%TYPE,
        quote_seq_no        GIPI_PARLIST.quote_seq_no%TYPE,
        dsp_pack_par_no     VARCHAR2(155),
        drv_par_seq_no      VARCHAR2(155),
        pol_flag            GIPI_WPOLBAS.pol_flag%TYPE,
        assd_no             GIPI_PARLIST.assd_no%TYPE,
        dsp_assd_name       VARCHAR2(4000),
        par_status          GIPI_PARLIST.par_status%TYPE,
        nb_endt_yy          VARCHAR2(30),
        par_type            GIPI_PARLIST.par_type%TYPE,
        pack_par_id         GIPI_PARLIST.pack_par_id%TYPE,
        subline_cd          GIPI_WPOLBAS.subline_cd%TYPE
    );
    
    TYPE winvoice_item_grp_type IS RECORD (
        item_grp            GIPI_WINVOICE.item_grp%TYPE
    );
    
    TYPE gipi_winvperl_type IS RECORD (
         peril_cd            GIPI_WINVPERL.peril_cd%TYPE,
         prem_amt            GIPI_WINVPERL.prem_amt%TYPE,
         peril_name            GIIS_PERIL.peril_name%TYPE
    );
    
    TYPE pack_witmperl_type IS RECORD (
         item_no            GIPI_WITMPERL.item_no%TYPE,
         pack_line_cd        GIPI_WITEM.pack_line_cd%TYPE,
         peril_cd            GIPI_WITMPERL.peril_cd%TYPE,
         prem_amt            GIPI_WITMPERL.prem_amt%TYPE,
         peril_name            GIIS_PERIL.peril_name%TYPE
    );
     
    TYPE gipi_wcomm_invoices_tab IS TABLE OF gipi_wcomm_invoices_type;
    
    TYPE gipi_wcomm_invoices_cur IS REF CURSOR RETURN gipi_wcomm_invoices_type;
    
    TYPE gipis085_b240_cur IS REF CURSOR RETURN gipis085_b240_type;
    
    TYPE gipi_winvperl_cur IS REF CURSOR RETURN gipi_winvperl_type;
    
    TYPE pack_witmperl_cur IS REF CURSOR RETURN pack_witmperl_type;
    
    TYPE winvoice_item_grp_cur IS REF CURSOR RETURN winvoice_item_grp_type;
	
	TYPE gipis085_pack_var_type IS RECORD (
		 pack_par_id			GIPI_PARLIST.pack_par_id%TYPE,
		 par_id					GIPI_PARLIST.par_id%TYPE,
		 v_validate_banca		VARCHAR2(1),
		 v_pol_flag				GIPI_WPOLBAS.pol_flag%TYPE,
		 intm_no            	gipi_wcomm_invoices.intrmdry_intm_no%TYPE,
         intm_name    			VARCHAR2(4000),
         parent_intm_no   		gipi_wcomm_invoices.parent_intm_no%TYPE,
         parent_intm_name 		VARCHAR2(4000),
		 line_cd				GIPI_WPOLBAS.line_cd%TYPE,
		 subline_cd				GIPI_WPOLBAS.subline_cd%TYPE,
		 assd_no				GIPI_PARLIST.assd_no%TYPE,
		 par_type				GIPI_PARLIST.par_type%TYPE,
		 v_lov_tag				VARCHAR2(20),
		 v_wcominv_intm_no_lov	VARCHAR2(40),
		 v_msg_alert			VARCHAR2(100)
	);
	
	TYPE gipis085_pack_var_tab IS TABLE OF gipis085_pack_var_type;
  
    FUNCTION get_gipi_wcomm_invoices (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp            GIPI_WCOMM_INVOICES.item_grp%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED;    
    
    /**
    * Modified by: Emman 04.27.2010
    *  Get comm invoice using par_id only
    */
    
    FUNCTION get_gipi_wcomm_invoices2 (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED;    
    
    PROCEDURE set_gipi_wcomm_invoices (
        p_intrmdry_intm_no        IN  GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
        p_share_percentage        IN  GIPI_WCOMM_INVOICES.share_percentage%TYPE,
        p_takeup_seq_no            IN  GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
        p_item_grp                IN  GIPI_WCOMM_INVOICES.item_grp%TYPE,
        p_par_id                IN  GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_premium_amt            IN  GIPI_WCOMM_INVOICES.premium_amt%TYPE,
        p_commission_amt        IN  GIPI_WCOMM_INVOICES.commission_amt%TYPE,
        p_wholding_tax            IN  GIPI_WCOMM_INVOICES.wholding_tax%TYPE,
        p_parent_intm_no        IN GIPI_WCOMM_INVOICES.parent_intm_no%TYPE);     


    PROCEDURE del_gipi_wcomm_invoices (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp            GIPI_WCOMM_INVOICES.item_grp%TYPE);
    
    /*
    **  Modified by        : Mark JM
    **  Date Created     : 02.11.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record by supplying the par_id only
    */
    PROCEDURE del_gipi_wcomm_invoices_1 (p_par_id    GIPI_WCOMM_INVOICES.par_id%TYPE);
    
    /*
    ** Modified by : Emman 04.26.10
    ** Description: Delete record by supplying par_id, item_grp, takeup_seq_no, and intm no
    */
    
    PROCEDURE del_gipi_wcomm_invoices_2(
      p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
      p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
      p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
      p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE
    );
     
    /*
    ** Other functions for GIPIS085
    */
    FUNCTION get_default_tax_rt (par_intrmdry_intm_no GIIS_INTERMEDIARY.INTM_NO%TYPE)
    RETURN GIIS_INTERMEDIARY.WTAX_RATE%TYPE;
    
    FUNCTION check_peril_comm_rate (
       p_intrmdry_intm_no GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
       p_line_cd IN VARCHAR2,
       p_iss_cd IN VARCHAR2,
       p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE --null muna to sa ngayon   
    ) RETURN VARCHAR2;
    
    PROCEDURE APPLY_BTN_WHEN_BUTTON_PRESSED(
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_intrmdry_intm_no_nbt IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
       p_share_percentage IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_share_percentage_nbt IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_prev_share_percentage IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_line_cd IN VARCHAR2,
       p_iss_cd IN VARCHAR2,
       p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE, --null muna to sa ngayon       
       p_record_status IN VARCHAR2,
       p_wcominvper_peril_cd IN GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
       p_wcominvper_commission_amt IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_nbt_commission_amt IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
       p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
       p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_apply_btn_enabled OUT VARCHAR2, --Y for Yes, N for No
       p_commission_rt_enabled OUT VARCHAR2,
       p_commission_amt_enabled OUT VARCHAR2,
       var_message OUT VARCHAR2,
       var_tax_amt OUT GIIS_INTERMEDIARY.WTAX_RATE%TYPE,
       var_share_percentage OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       var_function OUT VARCHAR2,
       var_switch_no OUT VARCHAR2,
       var_switch_name OUT VARCHAR2  
     );
     
     /*PROCEDURE PACKAGE_COMMISSION(
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_iss_cd IN VARCHAR2,
       p_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
       var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE,
       p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
       p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
       p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       var_message IN OUT VARCHAR2
     );*/
     
     PROCEDURE package_commission(p_par_id            IN     GIPI_PARLIST.par_id%TYPE,
                                        p_message               OUT VARCHAR2);
     /*
     PROCEDURE GET_INTMDRY_RATE(
      p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
      p_nbt_ret_orig   IN VARCHAR2,
      p_par_type       IN VARCHAR2,
      p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
      p_line_cd IN VARCHAR2,
      p_iss_cd IN VARCHAR2,
      p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE,
      var_rate          IN OUT GIPI_COMM_INV_PERIL.commission_rt%TYPE,
      var_peril_cd IN GIPI_WCOMM_INV_PERILS.peril_cd%TYPE
     );*/
     
     PROCEDURE get_intmdry_rate(p_par_id                GIPI_PARLIST.par_id%TYPE,
                                      p_b240_par_type            GIPI_PARLIST.par_type%TYPE,
                                    p_b240_line_cd            GIPI_PARLIST.line_cd%TYPE,
                                    p_b240_iss_cd            GIPI_PARLIST.iss_cd%TYPE,
                                    p_intm_no                GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
                                         p_nbt_ret_orig            VARCHAR2,
                                    p_var_peril_cd            GIPI_WITMPERL.peril_cd%TYPE,
                                    p_nbt_intm_type            GIIS_INTERMEDIARY.intm_type%TYPE,
                                    p_global_cancel_tag        VARCHAR2,
                                    p_var_rate                OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE);
     
     FUNCTION GET_ADJUST_INTRMDRY_RATE(p_intrmdry_intm_no IN NUMBER,
                                  p_par_id IN NUMBER,
                                  p_peril_cd IN VARCHAR2) RETURN NUMBER;
     
     /*PROCEDURE POPULATE_WCOMM_INV_PERILS(
        p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_item_grp IN OUT GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
        p_line_cd IN VARCHAR2,
        p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE,
        p_nbt_ret_orig   IN VARCHAR2,  
        var_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
        p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
        p_prev_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
        p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
        p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
        p_iss_cd IN OUT VARCHAR2,
        var_message OUT VARCHAR2,
        var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE
    );*/
    
    PROCEDURE populate_wcomm_inv_perils(p_par_id                IN     GIPI_PARLIST.par_id%TYPE,
                                               p_line_cd                    IN       GIPI_PARLIST.line_cd%TYPE,
                                             p_item_grp                    IN       GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                             p_var_iss_cd                   OUT GIPI_POLBASIC.iss_cd%TYPE,
                                             p_message                       OUT VARCHAR2);
    
    /*PROCEDURE populate_package_perils (
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_iss_cd IN VARCHAR2,
       p_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
       var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE,
       p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
       p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
       p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       var_message OUT VARCHAR2
    );*/
    
    PROCEDURE populate_package_perils (p_par_id                    GIPI_PARLIST.par_id%TYPE,
                                     p_item_grp                GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                   pack_witmperl_list        OUT GIPI_WCOMM_INVOICES_PKG.pack_witmperl_cur);
    
    PROCEDURE GET_PACKAGE_INTM_RATE (
          PIR_ITEM_NO  GIPI_WITMPERL.item_no%TYPE,
          PIR_line_cd  GIPI_WITEM.pack_line_cd%TYPE,
          PIR_peril_cd GIPI_WITMPERL.peril_cd%TYPE,
          p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
          p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
          p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
          p_iss_cd IN VARCHAR2,
          var_iss_cd IN VARCHAR2,
          var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE
    );
    
    PROCEDURE INTM_NO_WHEN_VALIDATE_ITEM (
     p_par_id                              IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
     p_intm_no                              IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
     p_line_cd                              IN VARCHAR2,
     p_lov_tag                              IN VARCHAR2,
     p_global_cancel_tag                 IN VARCHAR2,
     var_message                          OUT VARCHAR2
     );
     
     PROCEDURE GET_PAR_TYPE_AND_ENDTTAX (
     p_par_id                              IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
     p_par_type                             OUT GIPI_PARLIST.par_type%TYPE,
     p_endt_tax                             OUT GIPI_WENDTTEXT.endt_tax%TYPE
     );
     
   PROCEDURE gipis085_new_form_instance(p_par_id                IN  GIPI_PARLIST.par_id%TYPE,
                                      p_global_cancel_tag       OUT  VARCHAR2,
									  p_is_package				IN  VARCHAR2,
                                        p_bancassurance_rec     OUT VARCHAR2,
                                      p_cancellation_type       OUT VARCHAR2,
                                        p_banca_btn_enabled     OUT VARCHAR2,
                                      p_banca_check_enabled     OUT VARCHAR2,
                                      p_var_banc_rate_sw        OUT VARCHAR2,
                                      p_var_override_whtax      OUT    GIIS_PARAMETERS.param_value_v%TYPE,
                                        p_var_v_comm_update_tag OUT    GIIS_USERS.comm_update_tag%TYPE,
                                      p_var_v_param_show_comm   OUT    GIAC_PARAMETERS.param_value_v%TYPE,
                                      p_var_endt_yy             OUT GIPI_WPOLBAS.endt_yy%TYPE,
                                      p_var_param_req_def_intm  OUT VARCHAR2,
                                      p_v_ora2010_sw            OUT VARCHAR2,
                                      p_v_validate_banca        OUT VARCHAR2,
                                      p_v_par_type              OUT GIPI_PARLIST.par_type%TYPE,
                                      p_v_endt_tax              OUT GIPI_WENDTTEXT.endt_tax%TYPE,
                                      p_v_pol_flag              OUT GIPI_WPOLBAS.pol_flag%TYPE,
                                      p_v_gipi_wpolnrep_exist   OUT VARCHAR2,
                                      p_v_lov_tag               OUT VARCHAR2,
                                      p_v_wcominv_intm_no_lov   OUT VARCHAR2,
                                      p_v_allow_apply_sl_comm   OUT VARCHAR2,
                                      p_gipis085_b240           OUT GIPI_WCOMM_INVOICES_PKG.gipis085_b240_cur,
                                      p_wcomm_invoices          OUT GIPI_WCOMM_INVOICES_PKG.gipi_wcomm_invoices_cur,
                                      p_winvoice                OUT GIPI_WINVOICE_PKG.gipi_winvoice_cur,
                                      p_wcomm_inv_perils        OUT GIPI_WCOMM_INV_PERILS_PKG.gipi_wcomm_inv_perils_cur,
                                      p_banc_type               OUT GIIS_BANC_TYPE_PKG.giis_banc_type_cur,
                                      p_banc_type_dtl_list      OUT GIIS_BANC_TYPE_DTL_PKG.giis_banc_type_dtl_cur,
                                      p_item_grp_list           OUT GIPI_WCOMM_INVOICES_PKG.winvoice_item_grp_cur,
                                      p_intm_no                 OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE, 
                                      p_dsp_intm_name           OUT VARCHAR2,
                                      p_parent_intm_no          OUT gipi_wcomm_invoices.parent_intm_no%TYPE,
                                      p_parent_intm_name        OUT VARCHAR2,
                                      p_msg_alert               OUT VARCHAR2,
                                      p_coinsurer_sw            OUT VARCHAR2, --Apollo Cruz 10.10.2014
                                      p_dflt_intm_no            OUT giis_assured_intm.intm_no%TYPE, --benjo 09.07.2016 SR-5604
                                      p_req_dflt_intm_per_assd  OUT VARCHAR2, --benjo 09.07.2016 SR-5604
                                      p_allow_upd_intm_per_assd OUT VARCHAR2); --benjo 09.07.2016 SR-5604
                                      
   PROCEDURE validate_gipis085_intm_no(p_par_id                  IN       GIPI_WCOMM_INVOICES.par_id%TYPE,
                                        p_intm_no                    IN     GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
                                      p_nbt_intm_type                IN OUT GIIS_INTERMEDIARY.intm_type%TYPE,
                                      p_assd_no                    IN        GIPI_PARLIST.assd_no%TYPE,
                                    p_line_cd                    IN       GIPI_PARLIST.line_cd%TYPE,
                                    p_par_type                    IN       GIPI_PARLIST.par_type%TYPE,
                                    p_drv_par_seq_no            IN       VARCHAR2,
                                    p_v_lov_tag                    IN OUT VARCHAR2,
                                    p_iss_name                       OUT GIIS_ISSOURCE.iss_name%TYPE,
                                    p_msg_alert                       OUT VARCHAR2);
                                    
   PROCEDURE populate_wcomm_inv_perils2(p_par_id                IN        GIPI_PARLIST.par_id%TYPE,
                                            p_item_grp                IN       GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                          p_takeup_seq_no            IN       GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
                                        p_line_cd                IN       GIPI_PARLIST.line_cd%TYPE,
                                          p_gipi_winvperl_list       OUT GIPI_WCOMM_INVOICES_PKG.gipi_winvperl_cur);
                                        
   PROCEDURE POPULATE_GIPI_WCOMM_INV_DTL(p_par_id                    GIPI_WCOMM_INVOICES.par_id%TYPE,
                                        p_item_grp                GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                      p_takeup_seq_no            GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
                                      p_intm_no                    GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE);
                                      
   PROCEDURE DEL_INS_GIPI_WCOMM_INV_DTL(p_item_grp          gipi_wcomm_inv_dtl.item_grp%type, 
                                     p_par_id            gipi_wcomm_inv_dtl.par_id%type,
                                     p_intrmdry_intm_no  gipi_wcomm_inv_dtl.intrmdry_intm_no%type, 
                                     p_parent_intm_no    gipi_wcomm_inv_dtl.parent_intm_no%type,
                                     p_share_percentage  gipi_wcomm_inv_dtl.share_percentage%type,
                                     p_premium_amt       gipi_wcomm_inv_dtl.premium_amt%type,
                                     p_commission_amt    gipi_wcomm_inv_dtl.commission_amt%type,
                                     p_wholding_tax      gipi_wcomm_inv_dtl.wholding_tax%type,
                                     p_takeup_seq_no     gipi_wcomm_inv_dtl.takeup_seq_no%type);
                                     
   PROCEDURE get_gipi_wcomm_inv_amt_columns
    (p_par_id       IN      GIPI_WCOMM_INVOICES.par_id%TYPE,
     p_item_grp     IN      GIPI_WCOMM_INVOICES.item_grp%TYPE,
     p_intm_no      IN      GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
     p_prem_amt     OUT     GIPI_WCOMM_INVOICES.premium_amt%TYPE,
     p_comm_amt     OUT     GIPI_WCOMM_INVOICES.commission_amt%TYPE,
     p_share_pct    OUT     GIPI_WCOMM_INVOICES.share_percentage%TYPE,
     p_wholding_tax OUT     GIPI_WCOMM_INVOICES.wholding_tax%TYPE,
     p_net_comm     OUT     NUMBER);
	 
   FUNCTION get_pack_gipi_wcomm_invoices (
        p_pack_par_id            GIPI_PARLIST.pack_par_id%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED;
	
   FUNCTION get_pack_initial_vars(p_pack_par_id             IN  GIPI_PARLIST.pack_par_id%TYPE)
   RETURN gipis085_pack_var_tab PIPELINED;
   
   PROCEDURE gipis160_new_form_instance( p_par_id                IN     GIPI_PARLIST.par_id%TYPE,
                                         p_v_wcominv_intm_no_lov    OUT VARCHAR2,
                                         p_v_lov_tag                OUT VARCHAR2,
                                         p_v_pol_flag               OUT GIPI_WPOLBAS.pol_flag%TYPE,
                                         p_intm_no                  OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE, 
                                         p_dsp_intm_name            OUT VARCHAR2,
                                         p_parent_intm_no           OUT gipi_wcomm_invoices.parent_intm_no%TYPE,
                                         p_parent_intm_name         OUT VARCHAR2,
                                         p_var_param_req_def_intm   OUT VARCHAR2,
                                         p_var_override_whtax       OUT GIIS_PARAMETERS.param_value_v%TYPE,
                                         p_v_ora2010_sw             OUT VARCHAR2,
                                         p_v_validate_banca         OUT VARCHAR2,
                                         p_v_allow_apply_sl_comm    OUT VARCHAR2,
                                         p_gipis160_b240            OUT GIPI_WCOMM_INVOICES_PKG.gipis085_b240_cur,
                                         p_gipis160_b450            OUT GIPI_WINVOICE_PKG.gipi_winvoice_cur,
                                         p_wcomm_inv_perils         OUT GIPI_WCOMM_INV_PERILS_PKG.gipi_wcomm_inv_perils_cur,
                                         p_banc_type                OUT GIIS_BANC_TYPE_PKG.giis_banc_type_cur,
                                         p_banc_type_dtl_list       OUT GIIS_BANC_TYPE_DTL_PKG.giis_banc_type_dtl_cur,
                                         p_var_banc_rate_sw         OUT VARCHAR2,
                                         p_v_gipi_wpolnrep_exist    OUT VARCHAR2,
                                         p_wcominv_intm_no          OUT GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE, --belle 06.04.12
                                         p_dflt_intm_no             OUT giis_assured_intm.intm_no%TYPE, --benjo 09.07.2016 SR-5604
                                         p_req_dflt_intm_per_assd   OUT VARCHAR2, --benjo 09.07.2016 SR-5604
                                         p_allow_upd_intm_per_assd  OUT VARCHAR2 --benjo 09.07.2016 SR-5604
                                        );
                                        
   FUNCTION get_gipi_wcomm_invoices3 (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp          GIPI_WCOMM_INVOICES.item_grp%TYPE,
        p_takeup_seq_no     GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED;
    
    PROCEDURE del_gipi_wcomm_inv_dtl (p_par_id   gipi_wcomm_inv_dtl.par_id%TYPE,
                                      p_item_grp gipi_witem.item_grp%TYPE);
    
    /*
       Apollo Cruz 09.29.2014
       recomputes the amounts in GIPIS085 tables
       to avoid discrepancy
    */
    PROCEDURE recompute_gipis085_amounts(
       p_par_id VARCHAR2       
    );
    
    PROCEDURE del_comm_invoice_related_recs(
       p_par_id   gipi_wcomm_invoices.par_id%TYPE
    );
    
    /*
       Apollo Cruz 10.24.2014
       modified version of apply_sliding_commission
       AVG is used instead of DISTINCT to handle multiple perils
       item group considered
    */
    PROCEDURE apply_sliding_commission (
       p_sliding_comm   IN OUT VARCHAR2,
       p_rate           IN OUT gipi_wcomm_inv_perils.commission_rt%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_subline_cd     giis_subline.subline_cd%TYPE,
       p_par_id         gipi_witmperl.par_id%TYPE,
       p_peril_cd       gipi_witmperl.peril_cd%TYPE,
       p_item_grp       gipi_witem.item_grp%TYPE
    );
                                      
END Gipi_Wcomm_Invoices_Pkg;
/



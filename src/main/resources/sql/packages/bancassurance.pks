CREATE OR REPLACE PACKAGE CPI.BANCASSURANCE
/* Created by : Marion
** Date : March 2, 2010
** Description : Function Validate_bancassurance will validate if the current record is for bancassurance.
**                     Procedure Get_Default_Tax_Rt and Process_Commission will override the peril commission rates,
**                 instead of retrieving the rates maintained, rates should be based from Giis_banc_Type.rate
**
*/

/**
 ** Recreated by emman 12.09.2010
*/
AS
FUNCTION Validate_Bancassurance
 (p_par_id   GIPI_WCOMM_INVOICES.par_id%TYPE)
 RETURN VARCHAR2;
PROCEDURE Get_Default_Tax_Rt
     ( p_B240_PAR_ID                     IN GIPI_PARLIST.par_id%TYPE,
       p_B240_par_type                    IN GIPI_PARLIST.par_type%TYPE,
       p_WCOMINV_PAR_ID                    IN GIPI_WCOMM_INVOICES.par_id%TYPE,
       p_wcominv_intrmdry_intm_no        IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
       p_WCOMINV_intrmdry_intm_no_nbt    IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
       p_WCOMINV_share_percentage        IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_WCOMINV_share_percentage_nbt    IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_b450_takeup_seq_no                IN GIPI_WINVOICE.takeup_seq_no%TYPE,
       p_SYSTEM_record_status            IN VARCHAR2,
       p_WCOMINV_ITEM_GRP                IN GIPI_WCOMM_INVOICES.item_grp%TYPE,
       variables_var_tax_amt            OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_GLOBAL_cancel_tag                IN VARCHAR2,
       v_rg_id                           OUT VARCHAR2,
       v_ov                               OUT VARCHAR2,
       variables_v_override_whtax      OUT VARCHAR2, 
       variables_v_comm_update_tag       OUT GIIS_USERS.comm_update_tag%TYPE,
       variables_switch_no                OUT VARCHAR2,
       variables_switch_name           OUT VARCHAR2,
       variables_v_param_show_comm       OUT VARCHAR2,
       p_wcominvper_wholding_tax       OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_wcominvper_commission_amt        IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       v_go_clear_block                   OUT VARCHAR2,
       v_remove_clrd_rw_frm_grp        OUT VARCHAR2,
       v_check_comm_peril               OUT VARCHAR2,
       v_msg_alert1                       OUT VARCHAR2,
       v_upd_wcomm_inv_prls               OUT VARCHAR2,
       v_pop_wcomm_inv_prls               OUT VARCHAR2,
       v_del_wcomm_inv_prls               OUT VARCHAR2,
       v_msg_alert2                       OUT VARCHAR2,
       v_show_view                       OUT VARCHAR2,
       v_hide_view                       OUT VARCHAR2,
       v_set_itm_prop1                   OUT NUMBER,
       v_set_itm_prop2                   OUT NUMBER,
       v_go_item                       OUT VARCHAR2,
       v_compute_tot_com               OUT VARCHAR2,
       v_add_group_row                   OUT VARCHAR2,
       v_policy_id                        IN GIPI_POLBASIC.policy_id%TYPE);
PROCEDURE Process_Commission
  ( p_b240_par_id                             IN GIPI_PARLIST.par_id%TYPE,
       p_WCOMINV_PAR_ID                        IN GIPI_WCOMM_INVOICES.par_id%TYPE,
    p_WCOMINV_ITEM_GRP                        IN GIPI_WCOMM_INVOICES.item_grp%TYPE,
    p_WCOMINV_intrmdry_intm_no                IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
    p_WCOMINV_intrmdry_intm_no_nbt            IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
    p_WCOMINV_share_percentage                IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
    p_WCOMINV_share_percentage_nbt            IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
    p_b450_takeup_seq_no                    IN GIPI_WINVOICE.takeup_seq_no%TYPE,
    p_SYSTEM_record_status                    IN VARCHAR2,
    variables_v_comm_update_tag               OUT GIIS_USERS.comm_update_tag%TYPE,
    variables_switch_no                    OUT VARCHAR2,
    variables_switch_name                   OUT VARCHAR2,
    variables_v_param_show_comm               OUT GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
    p_GLOBAL_cancel_tag                        IN VARCHAR2,
    p_wcominvper_wholding_tax               OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
    p_wcominvper_commission_amt                IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
    variables_var_tax_amt                    IN GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
    v_go_clear_block                       OUT VARCHAR2,
    v_remove_clrd_rw_frm_grp                OUT VARCHAR2,
    v_check_comm_peril                       OUT VARCHAR2,
    v_msg_alert1                           OUT VARCHAR2,
    v_upd_wcomm_inv_prls                   OUT VARCHAR2,
    v_pop_wcomm_inv_prls                   OUT VARCHAR2,
    v_del_wcomm_inv_prls                   OUT VARCHAR2,
    v_msg_alert2                           OUT VARCHAR2,
    v_show_view                               OUT VARCHAR2,
    v_hide_view                               OUT VARCHAR2,
    v_set_itm_prop1                           OUT NUMBER,
    v_set_itm_prop2                           OUT NUMBER,
    v_go_item                               OUT VARCHAR2,
    v_compute_tot_com                       OUT VARCHAR2);
    
FUNCTION Validate_Pack_Bancassurance
 (p_pack_par_id   GIPI_PARLIST.pack_par_id%TYPE)
 RETURN VARCHAR2;
END BANCASSURANCE;
/



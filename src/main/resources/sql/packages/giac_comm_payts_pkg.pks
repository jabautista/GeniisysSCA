CREATE OR REPLACE PACKAGE CPI.GIAC_COMM_PAYTS_PKG
AS
  TYPE giac_comm_payts_type IS RECORD (
         gacc_tran_id                                           GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
       bill_gacc_tran_id                                           GIAC_COMM_PAYTS.gacc_tran_id%TYPE,   -- shan 10.03.2014
       tran_type                                    GIAC_COMM_PAYTS.tran_type%TYPE,
       iss_cd                                        GIAC_COMM_PAYTS.iss_cd%TYPE,
       prem_seq_no                                    GIAC_COMM_PAYTS.prem_seq_no%TYPE,
       intm_no                                        GIAC_COMM_PAYTS.intm_no%TYPE,
       dsp_line_cd                                    VARCHAR2(30),
       dsp_assd_name                                VARCHAR2(500),
       comm_amt                                        GIAC_COMM_PAYTS.comm_amt%TYPE,
       input_vat_amt                                GIAC_COMM_PAYTS.input_vat_amt%TYPE,
       wtax_amt                                        GIAC_COMM_PAYTS.wtax_amt%TYPE,
       drv_comm_amt                                    NUMBER(10,2),
       print_tag                                    GIAC_COMM_PAYTS.print_tag%TYPE,
       def_comm_tag                                    GIAC_COMM_PAYTS.def_comm_tag%TYPE,
       particulars                                    GIAC_COMM_PAYTS.particulars%TYPE,
       currency_cd                                    GIAC_COMM_PAYTS.currency_cd%TYPE,
       curr_desc                                    GIIS_CURRENCY.currency_desc%TYPE,
       convert_rate                                    GIAC_COMM_PAYTS.convert_rate%TYPE,
       foreign_curr_amt                                GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
       parent_intm_no                                GIAC_COMM_PAYTS.parent_intm_no%TYPE,
       user_id                                        GIAC_COMM_PAYTS.user_id%TYPE,
       last_update                                    GIAC_COMM_PAYTS.last_update%TYPE,
       comm_tag                                        GIAC_COMM_PAYTS.comm_tag%TYPE,
       record_no                                    GIAC_COMM_PAYTS.record_no%TYPE,
       disb_comm                                    GIAC_COMM_PAYTS.disb_comm%TYPE,
       dsp_policy_id                                GIPI_COMM_INVOICE.policy_id%TYPE,
       dsp_intm_name                                GIIS_INTERMEDIARY.intm_name%TYPE,
       dsp_assd_no                                    GIPI_POLBASIC.assd_no%TYPE,
	   record_seq_no								GIAC_COMM_PAYTS.record_seq_no%TYPE  --added by robert SR 19752 07.28.15
  );
  
  TYPE giac_comm_payts_tab IS TABLE OF giac_comm_payts_type;
  
  TYPE bill_no_list_type IS RECORD (
         ho_prem                                               VARCHAR2(30),
       prem_seq_no                                    GIPI_COMM_INVOICE.prem_seq_no%TYPE,
       iss_cd                                        GIPI_COMM_INVOICE.iss_cd%TYPE,
       bill                                            GIPI_COMM_INVOICE.prem_seq_no%TYPE
  );
  
  TYPE bill_no_list_tab IS TABLE OF bill_no_list_type;
  
  TYPE tran_type_lov_type IS RECORD (
         tran_type                                          CG_REF_CODES.rv_low_value%TYPE,
       tran_desc                                    CG_REF_CODES.rv_meaning%TYPE
  );
  
  TYPE tran_type_lov_cur IS REF CURSOR RETURN tran_type_lov_type;
  
  TYPE gcop_inv_type IS RECORD (
       bill_gacc_tran_id         GIAC_COMM_PAYTS.GACC_TRAN_ID%type,  -- shan 10.02.2014
         bill_no               VARCHAR2(15),
         iss_cd                GIAC_COMM_PAYTS.iss_cd%TYPE,
       prem_seq_no          GIAC_COMM_PAYTS.prem_seq_no%TYPE,
       intm_no              GIAC_COMM_PAYTS.intm_no%TYPE,
       intm_name          GIIS_INTERMEDIARY.intm_name%TYPE,
       comm_amt              VARCHAR2(20),--GIAC_COMM_PAYTS.comm_amt%TYPE,
       invat_amt          VARCHAR2(20),--GIAC_COMM_PAYTS.input_vat_amt%TYPE,
       wtax                  VARCHAR2(20),--GIAC_COMM_PAYTS.wtax_amt%TYPE,
       ncomm_amt          VARCHAR2(20),--GIAC_COMM_PAYTS.comm_amt%TYPE,
       chk_tag_enable      VARCHAR2(1)
  );
  
  TYPE gcop_inv_tab IS TABLE OF gcop_inv_type;
  
  FUNCTION get_giac_comm_payts (
             p_gacc_tran_id        GIAC_COMM_PAYTS.gacc_tran_id%TYPE
          ) RETURN giac_comm_payts_tab PIPELINED;
          
  PROCEDURE get_giacs020_basic_var_values (
    p_gacc_tran_id                          IN  GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
	p_user_id								IN	GIAC_USER_FUNCTIONS.user_id%TYPE,
    p_comm_payable_param                    OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_assd_no                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_intm_no                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_item_no                          	OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_item_no_2                         OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_item_no_3                         OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_line_cd                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_module_id                         OUT GIAC_MODULES.module_id%TYPE,
    p_var_gen_type                          OUT GIAC_MODULES.generation_type%TYPE,
    p_var_sl_type_cd_1                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_sl_type_cd_2                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_sl_type_cd_3                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_input_vat_param                  	OUT GIAC_PARAMETERS.param_value_n%TYPE,
    p_is_user_exist                         OUT VARCHAR2,
    p_tran_source_comm_tag                  OUT GIAC_COMM_PAYTS.comm_tag%TYPE,
    p_tran_type_lov                         OUT GIAC_COMM_PAYTS_PKG.tran_type_lov_cur,
    p_iss_cd_lov                          	OUT GIIS_ISSOURCE_PKG.issue_source_acctg_list_cur
  );
  
  PROCEDURE set_giac_comm_payts(p_gacc_tran_id            GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                  p_intm_no                GIAC_COMM_PAYTS.intm_no%TYPE,
                                p_iss_cd                GIAC_COMM_PAYTS.iss_cd%TYPE,
                                p_prem_seq_no            GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                p_tran_type                GIAC_COMM_PAYTS.tran_type%TYPE,
                                p_comm_amt                GIAC_COMM_PAYTS.comm_amt%TYPE,
                                p_wtax_amt                GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                p_input_vat_amt            GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                                p_user_id                GIAC_COMM_PAYTS.user_id%TYPE,
                                p_last_update            GIAC_COMM_PAYTS.last_update%TYPE,
                                p_particulars            GIAC_COMM_PAYTS.particulars%TYPE,
                                p_currency_cd            GIAC_COMM_PAYTS.currency_cd%TYPE,
                                p_convert_rate            GIAC_COMM_PAYTS.convert_rate%TYPE,
                                p_foreign_curr_amt        GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                                p_def_comm_tag            GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                                p_print_tag                GIAC_COMM_PAYTS.print_tag%TYPE,
                                p_parent_intm_no        GIAC_COMM_PAYTS.parent_intm_no%TYPE,
                                p_comm_tag                GIAC_COMM_PAYTS.comm_tag%TYPE,
                                p_record_no                GIAC_COMM_PAYTS.record_no%TYPE,
                                p_disb_comm                GIAC_COMM_PAYTS.disb_comm%TYPE,
                                p_record_seq_no            GIAC_COMM_PAYTS.record_seq_no%TYPE); --added by robert SR 19752 07.28.15
                                
  PROCEDURE del_giac_comm_payts(p_gacc_tran_id            GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                  p_intm_no                GIAC_COMM_PAYTS.intm_no%TYPE,
                                p_iss_cd                GIAC_COMM_PAYTS.iss_cd%TYPE,
                                p_prem_seq_no            GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                p_comm_tag                GIAC_COMM_PAYTS.comm_tag%TYPE, --added by robert SR 19752 07.28.15
                                p_record_no                GIAC_COMM_PAYTS.record_no%TYPE, --added by robert SR 19752 07.28.15
                                p_record_seq_no            GIAC_COMM_PAYTS.record_seq_no%TYPE); --added by robert SR 19752 07.28.15
  
  FUNCTION get_bill_no_list (p_tran_type      NUMBER,
                                   p_iss_cd          GIAC_COMM_PAYTS.iss_cd%TYPE,
                                   p_gacc_tran_id      GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                             p_bill_no          VARCHAR2)
   RETURN bill_no_list_tab PIPELINED;
   
  PROCEDURE get_gipi_comm_invoice (p_iss_cd            IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                   p_prem_seq_no        IN       GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                 p_intm_no            IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                                   p_convert_rate        IN OUT GIAC_COMM_PAYTS.convert_rate%TYPE,
                                   p_currency_cd        IN OUT GIAC_COMM_PAYTS.currency_cd%TYPE,
                                 p_i_comm_amt        IN OUT GIPI_COMM_INVOICE.commission_amt%TYPE,
                                 p_i_wtax            IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                                 p_curr_desc        IN OUT GIIS_CURRENCY.currency_desc%TYPE,
                                 p_def_fgn_curr        IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                                 p_message               OUT VARCHAR2);
                                 
  FUNCTION chk_modified_comm(p_prem_seq_no          GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                 p_iss_cd             GIAC_COMM_PAYTS.iss_cd%TYPE)
  RETURN VARCHAR2;
  
  PROCEDURE chk_gcop_comm_inv_giac_pa(
   p_intm_no                        IN        GIAC_COMM_PAYTS.intm_no%TYPE,
   p_iss_cd                            IN        GIAC_COMM_PAYTS.iss_cd%TYPE,
   p_prem_seq_no                    IN        GIAC_COMM_PAYTS.prem_seq_no%TYPE,
   p_dsp_policy_id                    IN OUT GIPI_COMM_INVOICE.policy_id%TYPE,
   p_dsp_intm_name                    IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
   p_dsp_assd_no                    IN OUT GIPI_POLBASIC.assd_no%TYPE,
   p_dsp_assd_name                    IN OUT GIIS_ASSURED.assd_name%TYPE,
   p_field_level                     IN        BOOLEAN);
   
   PROCEDURE get_def_prem_pct(p_iss_cd                IN       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                p_prem_seq_no            IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                   p_var_inv_prem_amt    IN OUT GIPI_INVOICE.prem_amt%TYPE,
                                   p_var_other_charges   IN OUT GIPI_INVOICE.other_charges%TYPE,
                                 p_var_notarial_fee    IN OUT GIPI_INVOICE.notarial_fee%TYPE,
                                 p_var_pd_prem_amt        IN OUT GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
                                 p_var_c_premium_amt    IN OUT GIAC_DIRECT_PREM_COLLNS.premium_amt%type,
                                 p_var_has_premium        IN OUT VARCHAR2,
                                 p_var_clr_rec            IN OUT VARCHAR2,
                                 p_var_pct_prem        IN OUT NUMBER,
                              p_pd_prem                IN OUT VARCHAR2,
                                 p_message                IN OUT VARCHAR2);
                              
   PROCEDURE param2_mgmt_comp (p_iss_cd                IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                 p_prem_seq_no        IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                               p_intm_no            IN        GIAC_COMM_PAYTS.intm_no%TYPE,
                               p_comm_amt            IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                               p_wtax_amt            IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                               p_drv_comm_amt        IN OUT NUMBER,
                               p_def_comm_amt        IN OUT NUMBER,
                               p_var_max_input_vat    IN OUT NUMBER,
                               p_var_vat_rt            IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                               p_var_clr_rec        IN OUT VARCHAR2,
                               p_valid_comm_amt        IN OUT VARCHAR2,
                                 mgmt_pd_prem_amt     IN        GIAC_DIRECT_PREM_COLLNS.premium_amt%type,
                               mgmt_tot_prem_amt     IN       GIPI_INVOICE.prem_amt%type);
                               
   PROCEDURE validate_comm_payts_comm_amt(p_param               IN      VARCHAR2,
                                              p_prem_seq_no       IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                              p_intm_no           IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                                            p_iss_cd           IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                                            p_var_p_tran_type  IN      GIAC_COMM_PAYTS.tran_type%TYPE,
                                            p_var_p_tran_id       IN      GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                            p_var_i_comm_amt   IN      GIPI_COMM_INVOICE.commission_amt%TYPE,
                                            p_var_p_comm_amt   IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                                            p_var_r_comm_amt   IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                                            p_var_r_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                            p_var_i_wtax       IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                                            p_var_p_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE);
                                            
   PROCEDURE giacs020_intm_no_post_text(p_comm_amt               IN       GIAC_COMM_PAYTS.comm_amt%TYPE,
                                             p_prem_seq_no           IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                           p_intm_no               IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                                         p_iss_cd               IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                                         p_wtax_amt               IN      GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                         p_def_comm_tag           IN OUT GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                                         p_var_last_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE);
                                         
   PROCEDURE giacs020_comp_summary(p_def_comm_tag        IN     GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                       p_bill_gacc_tran_id         IN     GIAC_COMM_PAYTS.GACC_TRAN_ID%TYPE,   -- shan 10.02.2014
                         p_prem_seq_no           IN      GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                       p_intm_no               IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                       p_iss_cd                   IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                       p_tran_type               IN      GIAC_COMM_PAYTS.tran_type%TYPE,
                       p_convert_rate           IN OUT GIAC_COMM_PAYTS.convert_rate%TYPE,
                       p_currency_cd           IN OUT GIAC_COMM_PAYTS.currency_cd%TYPE,
                       p_curr_desc               IN OUT GIIS_CURRENCY.currency_desc%TYPE,
                       p_input_vat_amt           IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_comm_amt               IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_wtax_amt               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_foreign_curr_amt       IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                       p_def_input_vat           IN OUT NUMBER,
                       p_drv_comm_amt           IN OUT NUMBER,
                       p_def_comm_amt           IN OUT NUMBER,
                       p_def_wtax_amt           IN OUT NUMBER,
                         p_var_cg_dummy           IN OUT VARCHAR2,
                         p_var_prev_comm_amt     IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_prev_wtax_amt       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_prev_input_vat       IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_var_p_tran_type       IN OUT GIAC_COMM_PAYTS.tran_type%TYPE,
                       p_var_p_tran_id           IN OUT GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                       p_var_r_comm_amt           IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_i_comm_amt           IN OUT GIPI_COMM_INVOICE.commission_amt%TYPE,
                       p_var_p_comm_amt          IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_r_wtax               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_fdrv_comm_amt       IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_def_fgn_curr       IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                       p_var_pct_prem           IN        NUMBER,
                       p_var_i_wtax               IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                       p_var_p_wtax               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_var_tran_type       IN OUT NUMBER,
                       p_var_vat_rt               IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_var_input_vat_param   IN OUT NUMBER,
                       p_var_has_premium       IN OUT VARCHAR2,
                       p_var_clr_rec           IN OUT VARCHAR2,
                       p_control_v_comm_amt       IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_control_sum_inp_vat   IN OUT NUMBER,
                       p_control_v_input_vat   IN OUT NUMBER,
                       p_control_sum_comm_amt  IN OUT NUMBER,
                       p_control_sum_wtax_amt  IN OUT NUMBER,
                       p_control_v_wtax_amt       IN OUT NUMBER,
                       p_control_sum_net_comm_amt IN OUT NUMBER,
                       p_invalid_tran_type1_2     OUT VARCHAR2,
                       p_invalid_tran_type3_4     OUT VARCHAR2,
                       p_no_tran_type              OUT VARCHAR2, -- 0 if OK, otherwise, enter the transaction type number
                       p_inv_comm_fully_paid   IN OUT VARCHAR2,
                       p_message               IN OUT VARCHAR2);
                       
   PROCEDURE giacs020_pre_insert_comm_payts(p_gacc_tran_id        IN     GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                              p_intm_no            IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                                              p_parent_intm_no    IN OUT GIAC_COMM_PAYTS.parent_intm_no%TYPE,
                                            p_comm_tag            IN       GIAC_COMM_PAYTS.comm_tag%TYPE,
                                            p_record_no            IN OUT GIAC_COMM_PAYTS.record_no%TYPE,
                                            p_message            OUT VARCHAR2);
                                            
   PROCEDURE giacs020_aeg_parameters_y(
                                  p_gacc_branch_cd              IN     GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                           p_gacc_fund_cd              IN     GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                           p_gacc_tran_id              IN     GIAC_ACCTRANS.tran_id%TYPE,
                           p_iss_cd                      IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                           p_prem_seq_no              IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                           p_intm_no                  IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                           p_record_no                  IN     GIAC_COMM_PAYTS.record_no%TYPE,
                           p_disb_comm                  IN     GIAC_COMM_PAYTS.disb_comm%TYPE,
                           p_drv_comm_amt                IN     NUMBER,
                           p_currency_cd              IN     GIAC_COMM_PAYTS.currency_cd%TYPE,
                           p_convert_rate              IN     GIAC_COMM_PAYTS.convert_rate%TYPE,
                                  p_var_comm_take_up          IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
                                  aeg_tran_id                IN     GIAC_ACCTRANS.tran_id%TYPE,
                           aeg_module_nm              IN     GIAC_MODULES.module_name%TYPE,
                           aeg_sl_type_cd1            IN     GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd2            IN     GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd3            IN     GIAC_PARAMETERS.param_name%TYPE,
                           p_message                     OUT VARCHAR2);
                           
   PROCEDURE check_gcop_inv_chk_tag (p_checked                               IN OUT VARCHAR2,
                                         p_iss_cd                               IN       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                       p_prem_seq_no                            IN       GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                       p_comm_tag_displayed                 IN       VARCHAR2,
                                       p_tran_type                           IN       GIAC_COMM_PAYTS.tran_type%TYPE,
                                       p_var_comm_payable_param            IN       NUMBER,
                                       p_message                                     OUT VARCHAR2);
                                     
   PROCEDURE giacs020_key_delrec(p_iss_cd                        IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                        p_prem_seq_no              IN        GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                      p_intm_no                 IN        GIAC_COMM_PAYTS.intm_no%TYPE,
                                      p_comm_amt             IN        GIAC_COMM_PAYTS.comm_amt%TYPE,
                                      p_message                 OUT    VARCHAR2);
                                      
    TYPE comm_slip_type IS RECORD (

      intm_name          giis_intermediary.intm_name%TYPE,
      agent_cd           giac_comm_slip_ext.intm_no%TYPE,
      gacc_tran_id       giac_comm_slip_ext.gacc_tran_id%TYPE,  
      policy_no          varchar2(50),
      comm_amt           giac_comm_slip_ext.comm_amt%TYPE,
      wtax_amt           giac_comm_slip_ext.wtax_amt%TYPE,
      vat_amt            giac_comm_slip_ext.input_vat_amt%TYPE,
      net                giac_comm_slip_ext.input_vat_amt%TYPE,
      prem_seq_no        gipi_comm_inv_peril.prem_seq_no%type, 
      comm_paid          giac_comm_payts.comm_amt%TYPE,
      input_vat          giac_comm_payts.input_vat_amt%TYPE,
      wtax               giac_comm_payts.wtax_amt%TYPE,
      premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      user_id            giac_order_of_payts.user_id%TYPE,
      iss_cd             giac_comm_slip_ext.iss_cd%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      prem_amt           gipi_comm_inv_peril.premium_amt%TYPE,
      comm_amt_pol       gipi_comm_inv_peril.commission_amt%TYPE,
      share_pct          gipi_comm_invoice.share_percentage%TYPE,
      ovr_comm           giac_parent_comm_invprl.commission_amt%TYPE,
      total_comm         gipi_comm_inv_peril.commission_amt%TYPE,
      or_no              varchar2(50),
      or_date            date,
      comm_slip_date     giac_comm_slip_ext.comm_slip_date%TYPE
      );

   TYPE comm_slip_tab IS TABLE OF comm_slip_type;
   
   FUNCTION get_commission_slip (
        p_intm_no    GIAC_COMM_SLIP_EXT.intm_no%TYPE,    
        p_tran_id    GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE


   )
      RETURN comm_slip_tab PIPELINED;
      
      
     TYPE comm_peril_sname_type IS RECORD (

       peril_sname          giis_peril.peril_sname%TYPE,
       premium_amt          gipi_comm_inv_peril.premium_amt%TYPE,
       comm_rt              gipi_comm_inv_peril.commission_rt%TYPE,
       comm_amt             gipi_comm_inv_peril.commission_amt%TYPE,
       iss_cd               gipi_comm_inv_peril.iss_cd%TYPE,
       prem_seq_no          gipi_comm_inv_peril.prem_seq_no%TYPE
        );

   TYPE comm_peril_sname_tab IS TABLE OF comm_peril_sname_type;
   
   
   FUNCTION get_comm_peril_sname (
        p_intm_no      GIAC_COMM_SLIP_EXT.intm_no%TYPE,    
        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
        p_iss_cd       GIPI_COMM_INV_PERIL.iss_cd%TYPE,
        p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
        p_line_cd      GIIS_PERIL.line_cd%TYPE

   )
      RETURN comm_peril_sname_tab PIPELINED;    
      
   TYPE comm_slip_sign_type IS RECORD (

       item_no             GIAC_USERS.user_id%TYPE,
       label               VARCHAR2(25),
       signatory           GIIS_SIGNATORY_NAMES.signatory%TYPE,
       designation         GIIS_SIGNATORY_NAMES.designation%TYPE,
       branch_cd           GIAC_DOCUMENTS.branch_cd%TYPE
        );

   TYPE comm_slip_sign_tab IS TABLE OF comm_slip_sign_type;    
                                     
   FUNCTION get_comm_slip_sign (
          
            p_user_id      GIAC_USERS.user_id%TYPE,
            p_report_id    GIAC_DOCUMENTS.report_id%TYPE,
            p_branch_cd    GIAC_DOCUMENTS.branch_cd%TYPE
            
   )
      RETURN comm_slip_sign_tab PIPELINED;
      
      
   TYPE comm_computed_prem_type IS RECORD (
     partial_prem                giac_direct_prem_collns.premium_amt%TYPE,
     prem_amt                    NUMBER(16,2),
     partial_comm                giac_comm_slip_ext.comm_amt%TYPE,
     total_comm                  NUMBER(16,2)
   );
    
  TYPE comm_computed_prem_tab IS TABLE OF comm_computed_prem_type;
  
  
  FUNCTION get_comm_computed_prem (p_iss_cd   giac_direct_prem_collns.b140_iss_cd%TYPE,
                                     p_prem_seq_no  giac_direct_prem_collns.b140_prem_seq_no%TYPE
                                  )    
        RETURN comm_computed_prem_tab PIPELINED;   
   
  
  TYPE comm_total_wtax_type     IS RECORD (
     commpayts                GIAC_COMM_PAYTS.comm_amt%TYPE,
     s_wtax                   GIAC_COMM_PAYTS.wtax_amt%TYPE,
     ivat                     GIAC_COMM_PAYTS.input_vat_amt%TYPE,
     net_comm                 GIAC_COMM_PAYTS.comm_amt%TYPE
   );
    
  TYPE comm_total_wtax_tab IS TABLE OF  comm_total_wtax_type;
  
  
   FUNCTION get_comm_total_wtax    (p_intm_no      GIAC_COMM_PAYTS.intm_no%TYPE,
                                 p_iss_cd       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                 p_prem_seq_no  GIAC_COMM_PAYTS.prem_seq_no%TYPE
                                )   
        RETURN comm_total_wtax_tab PIPELINED; 
        
        
  TYPE intm_type_noFormula_type     IS RECORD (
     v_returned_string     varchar2(200)
   );
    
  TYPE intm_type_noFormula_tab IS TABLE OF  intm_type_noFormula_type;     
  
     FUNCTION get_intm_type_noFormula (
                            p_intm_no     giis_intermediary.parent_intm_no%type)
      RETURN intm_type_noFormula_tab PIPELINED;
     
        FUNCTION get_prem_payt_netcomm (
           p_tran_id            giac_acctrans.tran_id%type,
           p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%type,
           p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%type,
           p_curr_cd            giac_order_of_payts.currency_cd%type,
           p_curr_rt            gipi_invoice.currency_rt%type)
      RETURN NUMBER;
      
         FUNCTION get_comm_net_amt (
           p_tran_id            giac_acctrans.tran_id%type,
           p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%type,
           p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%type)
      RETURN NUMBER;
      
FUNCTION CF_remarksFormula (
           p_tran_id            giac_acctrans.tran_id%type,
           p_tran_class         giac_acctrans.tran_class%type)
      RETURN VARCHAR2;  
      
    PROCEDURE check_rel_comm_w_unprinted_or (
       p_gacc_tran_id     giac_comm_payts.gacc_tran_id%TYPE,
       p_iss_cd           gipi_comm_invoice.iss_cd%TYPE,
       p_prem_seq_no      gipi_comm_invoice.prem_seq_no%TYPE,
       p_ref_no       OUT VARCHAR2, 
       p_response     OUT VARCHAR2
    );
    
    -- shan 11.03.2014
    PROCEDURE param2_full_prem_payt(
        p_iss_cd                gipi_comm_invoice.iss_cd%TYPE,
        p_prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
        p_intm_no               gipi_comm_invoice.INTRMDRY_INTM_NO%TYPE,
        p_comm_amt          OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
        p_wtax_amt          OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
        p_input_vat_amt     OUT GIAC_COMM_PAYTS.INPUT_VAT_AMT%TYPE,
        p_def_comm_amt      OUT NUMBER,
        p_def_input_vat     OUT NUMBER,
        p_drv_comm_amt      OUT NUMBER,
        p_var_max_input_vat OUT NUMBER,
        p_var_clr_rec       OUT VARCHAR2,
        p_var_message       OUT VARCHAR2 
    );
    
    PROCEDURE param2_comm_full_paid(
        p_iss_cd                gipi_comm_invoice.iss_cd%TYPE,
        p_prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
        p_intm_no               gipi_comm_invoice.INTRMDRY_INTM_NO%TYPE,
        p_clr_rec           OUT VARCHAR2,
        p_message           OUT VARCHAR2 
    );
    
    -- start : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
    FUNCTION validate_bill_no(
        p_tran_type       giac_comm_payts.tran_type%TYPE,
        p_iss_cd          giac_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2;
   -- end : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
   --added by robert SR 19752 08.13.15
   PROCEDURE get_record_seq_no (
       p_gacc_tran_id    IN   giac_comm_payts.gacc_tran_id%TYPE,
       p_intm_no         IN   giac_comm_payts.intm_no%TYPE,
       p_iss_cd          IN   giac_comm_payts.iss_cd%TYPE,
       p_prem_seq_no     IN   giac_comm_payts.prem_seq_no%TYPE,
       p_comm_tag        IN   giac_comm_payts.comm_tag%TYPE,
       p_record_no       IN   giac_comm_payts.record_no%TYPE,
       p_record_seq_no   OUT  giac_comm_payts.record_seq_no%TYPE
    );
	
	PROCEDURE renumber_comm_payts (
	   p_gacc_tran_id   giac_comm_payts.gacc_tran_id%TYPE
	);
	--end robert SR 19752 08.13.15

    --PROCEDURE check_if_paid_or_unpaid (
    FUNCTION check_if_paid_or_unpaid ( -- Modified by Jerome Bautista 03.04.2016 SR 21279
        p_iss_cd          giac_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2; -- Added by Jerome Bautista 03.04.2016 SR 21279
    
    -- marco - SR 21585 - 03.16.2016
    PROCEDURE check_comm_payt_status (
        p_gacc_tran_id      giac_comm_payts.gacc_tran_id%TYPE
    );
   
END GIAC_COMM_PAYTS_PKG; 
/


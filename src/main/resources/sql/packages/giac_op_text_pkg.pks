CREATE OR REPLACE PACKAGE CPI.giac_op_text_pkg
AS
   PROCEDURE update_giac_op_text (
      p_gacc_tran_id    giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE,
      P_user_id            giis_users.user_id%TYPE
   );

   PROCEDURE update_giac_op_text_giacs020 (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
   );

   PROCEDURE del_giac_op_text (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_item_gen_type   giac_op_text.item_gen_type%TYPE
   );

   PROCEDURE del_giac_op_text2 (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_item_gen_type   giac_op_text.item_gen_type%TYPE
   );
   
   PROCEDURE del_giac_op_text3(p_gacc_tran_id            GIAC_OP_TEXT.gacc_tran_id%TYPE,
                               p_item_seq_no             GIAC_OP_TEXT.item_seq_no%TYPE,
                                 p_item_gen_type            GIAC_OP_TEXT.item_gen_type%TYPE);
   
   PROCEDURE del_giac_op_text4 (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_module_name giac_modules.MODULE_NAME%TYPE
   );                                 

   PROCEDURE gen_op_text (
      p_tran_source              VARCHAR2,
      p_or_flag                  VARCHAR2,
      p_giop_gacc_tran_id        giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_iss_cd              IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                  giac_comm_payts.inst_no%TYPE,
      p_tran_type                giac_comm_payts.tran_type%TYPE,
      p_prem_amt                 giac_direct_prem_collns.premium_amt%TYPE,
      p_giop_gacc_fund_cd        giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giacs007_record_count    NUMBER,
      p_prem_vatable                 giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt                 giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated                 giac_direct_prem_collns.prem_zero_rated%TYPE
   );

   PROCEDURE update_giac_op_text_y (
      p_giop_gacc_tran_id        giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_iss_cd              IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                  giac_comm_payts.inst_no%TYPE,
      p_tran_type                giac_comm_payts.tran_type%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_prem_amt                 giac_direct_prem_collns.premium_amt%TYPE,
      p_giop_gacc_fund_cd        giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_total_records            NUMBER,                   -- alfie: 03-15-2011
      p_prem_vatable             giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt             giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated             giac_direct_prem_collns.prem_zero_rated%TYPE
   );

   PROCEDURE check_op_text_insert_y (
      p_premium_amt         IN       NUMBER,
      p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
      p_iss_cd              IN       giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN       giac_comm_payts.prem_seq_no%TYPE,
      p_giop_gacc_tran_id   IN       giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_inst_no             IN       giac_comm_payts.inst_no%TYPE,
      p_giop_gacc_fund_cd   IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_zero_prem_op_text   IN OUT   VARCHAR2,
      p_seq_no              IN OUT   NUMBER,
      p_module_name         IN       giac_modules.module_name%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE,
      p_prem_vatable        IN         giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt        IN         giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated        IN         giac_direct_prem_collns.prem_zero_rated%TYPE
   );

   PROCEDURE update_giac_dv_text (
      p_giop_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name         giac_modules.module_name%TYPE
   );

   PROCEDURE check_op_text_insert_prem_y (
      p_seq_no              NUMBER,
      p_premium_amt         gipi_invoice.prem_amt%TYPE,
      p_prem_text           VARCHAR2,
      p_currency_cd         giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        giac_direct_prem_collns.convert_rate%TYPE,
      p_giop_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name         giac_modules.module_name%TYPE,
      p_gen_type            giac_modules.generation_type%TYPE
   );

   PROCEDURE check_op_text_2_y (
      v_b160_tax_cd                  NUMBER,
      v_tax_name                     VARCHAR2,
      v_tax_amt                      NUMBER,
      v_currency_cd                  NUMBER,
      v_convert_rate                 NUMBER,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_gen_type                     giac_modules.generation_type%TYPE,
      p_seq_no              IN OUT   NUMBER
   );

   PROCEDURE update_giac_op_text_n (
      p_giop_gacc_tran_id        giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_iss_cd              IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                  giac_comm_payts.inst_no%TYPE,
      p_tran_type                giac_comm_payts.tran_type%TYPE,
      p_prem_amt                 giac_direct_prem_collns.premium_amt%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_giop_gacc_fund_cd        giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );

   PROCEDURE check_op_text_insert_n (
      p_premium_amt         IN       NUMBER,
      p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                      giac_comm_payts.inst_no%TYPE,
      p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE
   );

   PROCEDURE check_op_text_2_n (
      p_b160_tax_cd                  NUMBER,
      p_tax_name                     VARCHAR2,
      p_tax_amt                      NUMBER,
      p_currency_cd                  NUMBER,
      p_convert_rate                 NUMBER,
      p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_column_no           IN       giac_taxes.column_no%TYPE,
      p_seq_no              OUT      NUMBER,
      p_sq                  IN       NUMBER,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE
   );
   
   PROCEDURE update_giac_op_text_giacs040(p_gacc_tran_id              GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE);
   
   PROCEDURE update_giac_op_text_giacs018(p_gacc_tran_id        GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                            p_var_module_name        GIAC_MODULES.module_name%TYPE);
                                          
    TYPE giac_op_text_type IS RECORD(
        gacc_tran_id            giac_op_text.gacc_tran_id%TYPE,
        item_seq_no             giac_op_text.item_seq_no%TYPE,
        print_seq_no            giac_op_text.print_seq_no%TYPE,
        item_amt                giac_op_text.item_amt%TYPE,
        item_gen_type           giac_op_text.item_gen_type%TYPE,
        item_text               giac_op_text.item_text%TYPE,
        currency_cd             giac_op_text.currency_cd%TYPE,
        line                    giac_op_text.line%TYPE,
        bill_no                 giac_op_text.bill_no%TYPE,
        or_print_tag            giac_op_text.or_print_tag%TYPE,
        foreign_curr_amt        giac_op_text.foreign_curr_amt%TYPE,
        user_id                 giac_op_text.user_id%TYPE,
        last_update             giac_op_text.last_update%TYPE,
        cpi_rec_no              giac_op_text.cpi_rec_no%TYPE,
        cpi_branch_cd           giac_op_text.cpi_branch_cd%TYPE,
        column_no               giac_op_text.column_no%TYPE,
        dsp_curr_sname          giis_currency.short_name%TYPE
        );                       
        
    TYPE giac_op_text_tab IS TABLE OF giac_op_text_type;
    
    FUNCTION get_giac_op_text(p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE)
    RETURN giac_op_text_tab PIPELINED;
    
    PROCEDURE update_giac_op_text_giacs022 (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
    );
                   
    TYPE when_new_forms_giacs025_type IS RECORD(
        def_curr_cd         giac_parameters.param_value_n%TYPE,
        curr_cd             giac_order_of_payts.currency_cd%TYPE,
        curr_sname          giis_currency.short_name%TYPE,
        dummy               VARCHAR2(1),
        unprinted           VARCHAR2(1),
        item_gen_type       giac_modules.generation_type%TYPE,
        item_gen_type_giacs001 giac_modules.generation_type%TYPE,
        op_amount         NUMBER,
        exact_amount      NUMBER,
        curr_rt             NUMBER
        );
        
    TYPE when_new_forms_giacs025_tab IS TABLE OF when_new_forms_giacs025_type;    
         
    FUNCTION when_new_forms_ins_giacs025(p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
    RETURN when_new_forms_giacs025_tab PIPELINED;
    
    PROCEDURE set_giac_op_text(
        p_gacc_tran_id            giac_op_text.gacc_tran_id%TYPE,
        p_item_seq_no             giac_op_text.item_seq_no%TYPE,
        p_print_seq_no            giac_op_text.print_seq_no%TYPE,
        p_item_amt                giac_op_text.item_amt%TYPE,
        p_item_gen_type           giac_op_text.item_gen_type%TYPE,
        p_item_text               giac_op_text.item_text%TYPE,
        p_currency_cd             giac_op_text.currency_cd%TYPE,
        p_line                    giac_op_text.line%TYPE,
        p_bill_no                 giac_op_text.bill_no%TYPE,
        p_or_print_tag            giac_op_text.or_print_tag%TYPE,
        p_foreign_curr_amt        giac_op_text.foreign_curr_amt%TYPE,
        p_user_id                 giac_op_text.user_id%TYPE,
        p_last_update             giac_op_text.last_update%TYPE,
        p_cpi_rec_no              giac_op_text.cpi_rec_no%TYPE,
        p_cpi_branch_cd           giac_op_text.cpi_branch_cd%TYPE,
        p_column_no               giac_op_text.column_no%TYPE
        );
        
    FUNCTION generate_particulars(p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE)
    RETURN giac_op_text_tab PIPELINED;
            
    PROCEDURE check_insert_tax_collns(
        p_gacc_tran_id    IN  giac_tax_collns.gacc_tran_id%TYPE,
        p_msg_alert       OUT VARCHAR2);
        
    PROCEDURE gen_seq_nos_or_prev(
        p_gacc_tran_id      IN  giac_op_text.gacc_tran_id%TYPE,
        p_item_gen_type     IN  giac_op_text.item_gen_type%TYPE,
        p_start_row         IN  VARCHAR2,    
        p_end_row           IN  VARCHAR2,
        p_print_seq_no      OUT giac_op_text.print_seq_no%TYPE,
        p_item_seq_no       OUT giac_op_text.item_seq_no%TYPE
        );        
        
    FUNCTION check_print_seq_no_or_prev(
        p_gacc_tran_id      giac_op_text.gacc_tran_id%TYPE,
        p_print_seq_no      giac_op_text.print_seq_no%TYPE,
        p_start_row         VARCHAR2,    
        p_end_row           VARCHAR2        
        ) RETURN VARCHAR2;
        
    PROCEDURE sum_amounts_or_prev(
        p_gacc_tran_id      IN  giac_op_text.gacc_tran_id%TYPE,
        p_start_row         IN  VARCHAR2,    
        p_end_row           IN  VARCHAR2,
        p_sum_item_amt      OUT VARCHAR2,
        p_sum_fc_amt        OUT VARCHAR2,
        p_sum_print1        OUT VARCHAR2,   
        p_sum_print2        OUT VARCHAR2
        );
        
    PROCEDURE update_op_text_giacs014(
       p_gacc_tran_id   giac_unidentified_collns.gacc_tran_id%TYPE,
       p_item_gen_type   giac_modules.generation_type%TYPE
    );            
    
    PROCEDURE validate_print_op_giacs025(
        p_gacc_tran_id      IN  giac_op_text.gacc_tran_id%TYPE,
        p_curr_cd           IN  giis_currency.main_currency_cd%TYPE,
        p_curr_sname        IN  giis_currency.short_name%TYPE,
        p_msg_1             OUT VARCHAR2,
        p_msg_2             OUT VARCHAR2,
        p_msg_3             OUT VARCHAR2
        );      
        
    PROCEDURE upd_giac_op_text_giacs019(
           p_gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE
    );
    
   FUNCTION get_total_premium (
    p_tran_id       giac_order_of_payts.gacc_tran_id%TYPE,
    p_currency_cd   giac_parameters.param_name%TYPE
   )
   RETURN NUMBER;
   
   PROCEDURE update_giac_op_text_giacs007(
                                p_gacc_tran_id  giac_order_of_payts.gacc_tran_id%TYPE,                         
                                p_module_name giac_modules.module_name%TYPE);
   
   PROCEDURE update_giac_op_text_giacs017 (
      p_gacc_tran_id      giac_inw_claim_payts.gacc_tran_id%TYPE,
      p_var_module_name   giac_modules.module_name%TYPE
   );
   
    FUNCTION get_giac_op_text_listing(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE,
        p_print_seq_no      GIAC_OP_TEXT.print_seq_no%TYPE,
        p_item_gen_type     GIAC_OP_TEXT.item_gen_type%TYPE,
        p_line              GIAC_OP_TEXT.line%TYPE,
        p_item_text         GIAC_OP_TEXT.item_text%TYPE,
        p_column_no         GIAC_OP_TEXT.column_no%TYPE,
        p_bill_no           GIAC_OP_TEXT.bill_no%TYPE,
        p_item_amt          GIAC_OP_TEXT.item_amt%TYPE,
        p_dsp_curr_sname    GIIS_CURRENCY.short_name%TYPE,
        p_foreign_curr_amt  GIAC_OP_TEXT.foreign_curr_amt%TYPE
    )
    RETURN giac_op_text_tab PIPELINED;

    TYPE print_seq_no_type IS RECORD(
        print_seq_no        GIAC_OP_TEXT.print_seq_no%TYPE
    );
    TYPE print_seq_no_tab IS TABLE OF print_seq_no_type;
    
    FUNCTION get_giac_op_text_print_seq_nos(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    RETURN print_seq_no_tab PIPELINED;
    
    TYPE item_seq_no_type IS RECORD(
        item_seq_no         GIAC_OP_TEXT.item_seq_no%TYPE
    );
    TYPE item_seq_no_tab IS TABLE OF item_seq_no_type;
    
    FUNCTION get_giac_op_text_item_seq_nos(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    RETURN item_seq_no_tab PIPELINED;
    
    PROCEDURE adjust_op_text_on_discrep (
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    );
    
    PROCEDURE check_op_text_2b_n(
        p_b160_tax_cd            NUMBER,
        p_tax_name        VARCHAR2,
        p_tax_amt            NUMBER,
        p_currency_cd     NUMBER,
        p_convert_rate    NUMBER,
        p_iss_cd          IN giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no     IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_column_no       IN giac_taxes.column_no%TYPE,
        p_seq_no              OUT      NUMBER,
        p_sq                  IN       NUMBER,
        p_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
        p_gen_type            IN OUT   giac_modules.generation_type%TYPE
    );
    
    FUNCTION validate_balance_acct_entries(p_gacc_tran_id    giac_direct_prem_collns.gacc_tran_id%TYPE)
        RETURN VARCHAR2;
    
    PROCEDURE gen_op_text_giacs007 (
      p_tran_source                 VARCHAR2,
      p_or_flag                     VARCHAR2,
      p_gacc_tran_id                giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   );
   
    PROCEDURE update_giac_op_text_giacs021(
        p_gacc_tran_id              GIAC_OP_TEXT.gacc_tran_id%TYPE
    );
    
    PROCEDURE adj_doc_stamps_in_giacs025(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    );
    
    PROCEDURE recompute_op_text (
       p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
    );
    
    PROCEDURE validate_before_recompute(
       p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
    );
    

END giac_op_text_pkg;
/
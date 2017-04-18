CREATE OR REPLACE PACKAGE CPI.giacs221_pkg
AS
   TYPE com_inquiry_records_type IS RECORD (
      count_              NUMBER,--added by pjsantos 11/25/2016, for optimization GENQA5857
      rownum_             NUMBER,--added by pjsantos 11/25/2016, for optimization GENQA5857 
      bill_iss_cd         gipi_comm_invoice.iss_cd%TYPE,
      prem_seq_no         gipi_comm_invoice.prem_seq_no%TYPE,
      line_cd             gipi_polbasic.line_cd%TYPE,
      subline_cd          gipi_polbasic.subline_cd%TYPE,
      iss_cd              gipi_polbasic.iss_cd%TYPE,
      issue_yy            gipi_polbasic.issue_yy%TYPE,
      pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      renew_no            gipi_polbasic.renew_no%TYPE,
      endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy             gipi_polbasic.endt_yy%TYPE,
      endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      assd_no             gipi_polbasic.assd_no%TYPE,
      assd_name           giis_assured.assd_name%TYPE,
      intm_type           giis_intermediary.intm_type%TYPE,
      intrmdry_intm_no    gipi_comm_invoice.intrmdry_intm_no%TYPE,
      ref_intm_cd         giis_intermediary.ref_intm_cd%TYPE,
      intm_name           giis_intermediary.intm_name%TYPE,
      currency_cd_f       gipi_invoice.currency_cd%TYPE,
      currency_rt_f       gipi_invoice.currency_rt%TYPE,
      short_name_f        giis_currency.short_name%TYPE,
      short_name_l        giis_currency.short_name%TYPE,
      parent_intm_no      gipi_comm_invoice.parent_intm_no%TYPE,
      parent_intm_name    giis_intermediary.intm_name%TYPE,
      rv_meaning          cg_ref_codes.rv_meaning%TYPE,
      reg_policy_sw       gipi_polbasic.reg_policy_sw%TYPE,
      pol_flag            gipi_polbasic.pol_flag%TYPE,
      spld_date           gipi_polbasic.spld_date%TYPE,
      incept_date         VARCHAR2 (50),
      expiry_date         VARCHAR2 (50),
      bill_no             VARCHAR2 (50),
      policy_number       VARCHAR2 (50),
      endt_no             VARCHAR2 (50),
      dsp_reg_policy_sw   VARCHAR2 (20),
      pol_status          VARCHAR2 (100),
      input_vat_l         NUMBER (16, 2),
      input_vat_f         NUMBER (16, 2),
      premium_paid_f      NUMBER (16, 2),
      premium_paid_l      NUMBER (16, 2),
      prem_paid_sname_f   VARCHAR2 (50),
      prem_paid_sname_l   VARCHAR2 (50),
      commission_amt_l    NUMBER (16, 2),
      commission_amt_f    NUMBER (16, 2),
      wholding_tax_l      NUMBER (16, 2),
      wholding_tax_f      NUMBER (16, 2),
      premium_amt_l       NUMBER (16, 2),
      premium_amt_f       NUMBER (16, 2),
      net_comm_f          NUMBER (16, 2),
      net_comm_l          NUMBER (16, 2),
      net_premium_amt_l   NUMBER (16, 2),
      net_premium_amt_f   NUMBER (16, 2)
   );

   TYPE com_inquiry_records_tab IS TABLE OF com_inquiry_records_type;

   TYPE giis_intermediary_lov_type IS RECORD (
      intm_no       giis_intermediary.intm_no%TYPE,
      ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      intm_name     giis_intermediary.intm_name%TYPE,
      intm_type     giis_intermediary.intm_type%TYPE
   );

   TYPE giis_intermediary_lov_tab IS TABLE OF giis_intermediary_lov_type;

   TYPE giis_intm_lov_type IS RECORD (
      intm_type   giis_intm_type.intm_type%TYPE,
      intm_desc   giis_intm_type.intm_desc%TYPE
   );

   TYPE giis_intm_lov_tab IS TABLE OF giis_intm_lov_type;

   TYPE giac_comm_payts_type IS RECORD (
      gacc_tran_id        giac_comm_payts.gacc_tran_id%TYPE,
      tran_type           giac_comm_payts.tran_type%TYPE,
      iss_cd              giac_comm_payts.iss_cd%TYPE,
      prem_seq_no         giac_comm_payts.prem_seq_no%TYPE,
      intm_no             giac_comm_payts.intm_no%TYPE,
      tran_class          giac_acctrans.tran_class%TYPE,
      tran_class_no       giac_acctrans.tran_class_no%TYPE,
      ref_no              VARCHAR2 (50),
      dsp_tran_date       VARCHAR2 (50),
      tran_date           giac_acctrans.tran_date%TYPE,
      branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      tran_flag           giac_acctrans.tran_flag%TYPE,
      tran_year           giac_acctrans.tran_year%TYPE,
      tran_month          giac_acctrans.tran_month%TYPE,
      tran_seq_no         giac_acctrans.tran_seq_no%TYPE,
      comm_amt            NUMBER (16, 2),
      comm_amt_f          NUMBER (16, 2),
      wtax_amt            NUMBER (16, 2),
      wtax_amt_f          NUMBER (16, 2),
      input_vat_amt       NUMBER (16, 2),
      input_vat_amt_f     NUMBER (16, 2),
      net_comm            NUMBER (16, 2),
      net_comm_f          NUMBER (16, 2),
      tot_com_amt         NUMBER (16, 2),
      tot_com_amt_f       NUMBER (16, 2),
      tot_wtax_amt        NUMBER (16, 2),
      tot_wtax_amt_f      NUMBER (16, 2),
      tot_input_vat       NUMBER (16, 2),
      tot_input_vat_f     NUMBER (16, 2),
      total               NUMBER (16, 2),
      total_f             NUMBER (16, 2),
      bd_com_amt          NUMBER (16, 2),
      bd_com_amt_f        NUMBER (16, 2),
      bd_wtax_amt         NUMBER (16, 2),
      bd_wtax_amt_f       NUMBER (16, 2),
      bd_input_vat        NUMBER (16, 2),
      bd_input_vat_f      NUMBER (16, 2),
      bal_due             NUMBER (16, 2),
      bal_due_f           NUMBER (16, 2),
      input_vat_l         NUMBER (16, 2),
      input_vat           NUMBER (16, 2),
      commission_amt_l    NUMBER (16, 2),
      wholding_tax_l      NUMBER (16, 2),
      wholding_tax_f      NUMBER (16, 2),
      dsp_comm_amt        NUMBER (16, 2),
      dsp_wtax_amt        NUMBER (16, 2),
      dsp_input_vat_amt   NUMBER (16, 2)
   );

   TYPE giac_comm_payts_tab IS TABLE OF giac_comm_payts_type;

   TYPE history_records_type IS RECORD (
      iss_cd            giac_new_comm_inv.iss_cd%TYPE,
      prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE,
      intm_no           giac_prev_comm_inv.intm_no%TYPE,
      dsp_intm_name     giis_intermediary.intm_name%TYPE,
      commission_amt    giac_prev_comm_inv.commission_amt%TYPE,
      wholding_tax      giac_prev_comm_inv.wholding_tax%TYPE,
      intm_no2          giac_new_comm_inv.intm_no%TYPE,
      dsp_intm_name2    giis_intermediary.intm_name%TYPE,
      commission_amt2   giac_new_comm_inv.commission_amt%TYPE,
      wholding_tax2     giac_new_comm_inv.wholding_tax%TYPE,
      tran_flag2        giac_new_comm_inv.tran_flag%TYPE,
      delete_sw2        giac_new_comm_inv.delete_sw%TYPE,
      post_date2        giac_new_comm_inv.post_date%TYPE,
      dsp_post_date2    VARCHAR2 (50),
      posted_by2        giac_new_comm_inv.posted_by%TYPE,
      user_id2          giac_new_comm_inv.user_id%TYPE
   );

   TYPE history_records_tab IS TABLE OF history_records_type;

   TYPE detail_records_type IS RECORD (
      peril_name    giis_peril.peril_name%TYPE,
      comm_rt       gipi_comm_inv_peril.commission_rt%TYPE,
      prem_amt_l    NUMBER (16, 2),
      prem_amt_f    NUMBER (16, 2),
      comm_amt_l    NUMBER (16, 2),
      comm_amt_f    NUMBER (16, 2),
      wtax_l        NUMBER (16, 2),
      wtax_f        NUMBER (16, 2),
      input_vat_l   NUMBER (16, 2),
      input_vat_f   NUMBER (16, 2),
      net_f         NUMBER (16, 2),
      net_l         NUMBER (16, 2)
   );

   TYPE detail_records_tab IS TABLE OF detail_records_type;

   TYPE comm_breakdown_records_type IS RECORD (
      parent_comm_rt          NUMBER (16, 2),
      parent_comm_amt         NUMBER (16, 2),
      child_comm_rt           NUMBER (16, 2),
      child_comm_amt          NUMBER (16, 2),
      dsp_peril_name          giis_peril.peril_name%TYPE,
      total_parent_comm_amt   NUMBER (16, 2),
      total_child_comm_amt    NUMBER (16, 2)
   );

   TYPE comm_breakdown_records_tab IS TABLE OF comm_breakdown_records_type;

   TYPE parent_comm_records_type IS RECORD (
      intm_no            giac_parent_comm_invoice.intm_no%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      commission_amt_l   NUMBER (16, 2),
      commission_amt_f   NUMBER (16, 2),
      wtax_l             NUMBER (16, 2),
      wtax_f             NUMBER (16, 2),
      input_vat_l        NUMBER (16, 2),
      input_vat_f        NUMBER (16, 2), 
      parent_payt_l      NUMBER (16, 2),
      parent_payt_f      NUMBER (16, 2),
      net_due_l          NUMBER (16, 2),
      net_due_f          NUMBER (16, 2)
   );

   TYPE parent_comm_records_tab IS TABLE OF parent_comm_records_type;

   FUNCTION get_comm_iss_cd (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_iss_cd      gipi_invoice.iss_cd%TYPE,
      /*Added by pjsantos 11/25/2016, for optimization GENQA 5857*/      
      p_order_by             VARCHAR2,      
      p_asc_desc_flag        VARCHAR2,      
      p_first_row            NUMBER,        
      p_last_row             NUMBER
      --pjsantos end
   )
      RETURN com_inquiry_records_tab PIPELINED;

   FUNCTION get_com_inquiry_records (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       NUMBER,
      p_assd_no       NUMBER,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_pol_iss_cd    VARCHAR2,
      p_issue_yy      NUMBER,
      p_pol_seq_no    NUMBER,
      p_renew_no      NUMBER,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER,
      p_endt_seq_no   NUMBER,
      /*Added by pjsantos 11/25/2016, for optimization GENQA 5857*/
      p_filter_assd_name     VARCHAR2,
      p_filter_intm_type     VARCHAR2,
      p_filter_ref_intm_cd   VARCHAR2,
      p_filter_ref_intm_name VARCHAR2,
      p_filter_incept_date   VARCHAR2,
      p_filter_expiry_date   VARCHAR2,
      p_filter_bill_no       VARCHAR2,
      p_filter_policy_no     VARCHAR2,
      p_filter_endt_no       VARCHAR2,
      p_order_by             VARCHAR2,      
      p_asc_desc_flag        VARCHAR2,      
      p_first_row            NUMBER,        
      p_last_row             NUMBER
      --pjsantos end
   )
      RETURN com_inquiry_records_tab PIPELINED;

   FUNCTION get_giis_intermediary_lov
      RETURN giis_intermediary_lov_tab PIPELINED;

   FUNCTION get_giis_intm_lov
      RETURN giis_intm_lov_tab PIPELINED;

   FUNCTION get_giis_intermediary_lov2(p_intm_type giis_intermediary.intm_type%TYPE)
      RETURN giis_intermediary_lov_tab PIPELINED;

   FUNCTION get_giac_comm_payts_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_commission_amt     NUMBER
   )
      RETURN giac_comm_payts_tab PIPELINED;

   FUNCTION get_history_records (
      p_iss_cd        gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_comm_invoice.prem_seq_no%TYPE,
      p_currency_cond VARCHAR
   )
      RETURN history_records_tab PIPELINED;

   FUNCTION get_detail_records (
      p_iss_cd        gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_comm_invoice.prem_seq_no%TYPE,
      p_intm_no       gipi_comm_inv_peril.intrmdry_intm_no%TYPE
   )
      RETURN detail_records_tab PIPELINED;

   FUNCTION get_comm_breakdown_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_currency_cond      VARCHAR
   )
      RETURN comm_breakdown_records_tab PIPELINED;

   FUNCTION get_parent_comm_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE
   )
      RETURN parent_comm_records_tab PIPELINED;
   /*Added by pjsantos 11/28/2016 additional findings for GENQA 5857*/
   TYPE assd_lov_rec IS RECORD(
      count_            NUMBER,
      rownum_           NUMBER,
      assd_no           giis_assured.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE);
   TYPE assd_lov_tab IS TABLE OF assd_lov_rec;   
   FUNCTION get_assd_lov(p_find_text            VARCHAR2,
                         p_bill_iss_cd          VARCHAR2,
                         p_order_by             VARCHAR2,      
                         p_asc_desc_flag        VARCHAR2,      
                         p_first_row            NUMBER,        
                         p_last_row             NUMBER)
   RETURN assd_lov_tab PIPELINED;
   --pjsantos end   
END;
/



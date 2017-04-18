CREATE OR REPLACE PACKAGE CPI.giacs250_pkg
AS

   TYPE fund_lov_type IS RECORD(
      fund_cd                 giis_funds.fund_cd%TYPE,
      fund_desc               giis_funds.fund_desc%TYPE
   );
   TYPE fund_lov_tab IS TABLE OF fund_lov_type;

   TYPE branch_lov_type IS RECORD(
      branch_cd               giac_branches.branch_cd%TYPE,
      branch_name             giac_branches.branch_name%TYPE
   );
   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   TYPE batch_comm_slip_type IS RECORD(
      iss_cd                  giac_comm_slip_ext.iss_cd%TYPE,
      gacc_tran_id            giac_comm_slip_ext.gacc_tran_id%TYPE,
      dsp_or_no               VARCHAR2(20),
      intm_no                 giac_comm_slip_ext.intm_no%TYPE,
      comm_amt                giac_comm_slip_ext.comm_amt%TYPE,
      wtax_amt                giac_comm_slip_ext.wtax_amt%TYPE,
      input_vat_amt           giac_comm_slip_ext.input_vat_amt%TYPE,
      net_amt                 NUMBER(12, 2),
      or_pref                 giac_order_of_payts.or_pref_suf%TYPE,
      or_no                   giac_order_of_payts.or_no%TYPE,
      intm_name               giis_intermediary.intm_name%TYPE
   );
   TYPE batch_comm_slip_tab IS TABLE OF batch_comm_slip_type;
   
   TYPE batch_comm_slip_list_type IS RECORD(
      iss_cd                  giac_comm_slip_ext.iss_cd%TYPE,
      gacc_tran_id            giac_comm_slip_ext.gacc_tran_id%TYPE,
      dsp_or_no               VARCHAR2(20),
      intm_no                 giac_comm_slip_ext.intm_no%TYPE,
      comm_amt                giac_comm_slip_ext.comm_amt%TYPE,
      wtax_amt                giac_comm_slip_ext.wtax_amt%TYPE,
      input_vat_amt           giac_comm_slip_ext.input_vat_amt%TYPE,
      net_amt                 NUMBER(12, 2),
      or_pref                 giac_order_of_payts.or_pref_suf%TYPE,
      or_no                   giac_order_of_payts.or_no%TYPE,
      intm_name               giis_intermediary.intm_name%TYPE,
      generate_flag           VARCHAR2(1),
      printed_flag            VARCHAR2(1),
      comm_slip_pref          VARCHAR2(5),
      comm_slip_no            NUMBER(12)
   );
   TYPE batch_comm_slip_list_tab IS TABLE OF batch_comm_slip_list_type;
   
   TYPE report_params_type IS RECORD(
      gacc_tran_id            giac_comm_slip_ext.gacc_tran_id%TYPE,
      branch_cd               giac_comm_slip_ext.iss_cd%TYPE,
      intm_no                 giac_comm_slip_ext.intm_no%TYPE,
      cs_no                   giac_doc_sequence.doc_seq_no%TYPE,
      cs_pref                 giac_doc_sequence.doc_pref_suf%TYPE
   );
   TYPE report_params_tab IS TABLE OF report_params_type;
   
   FUNCTION get_fund_lov(
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN fund_lov_tab PIPELINED;

   FUNCTION get_branch_lov(
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN branch_lov_tab PIPELINED;
     
   FUNCTION get_batch_comm_slip(
      p_fund_cd               giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd             giac_acctrans.gibr_branch_cd%TYPE,
      p_or_no                 giac_order_of_payts.or_no%TYPE,
      p_or_pref               giac_order_of_payts.or_pref_suf%TYPE
   )
     RETURN batch_comm_slip_tab PIPELINED;
     
   PROCEDURE populate_batch_comm_slip_temp(
      p_fund_cd               giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd             giac_acctrans.gibr_branch_cd%TYPE,
      p_or_no                 giac_order_of_payts.or_no%TYPE,
      p_or_pref               giac_order_of_payts.or_pref_suf%TYPE
   );
   
   FUNCTION get_batch_comm_slip_listing(
      p_or_pref               VARCHAR2,
      p_or_no                 NUMBER,
      p_intm_no               NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat_amt         NUMBER,
      p_net_amt               NUMBER
   )
     RETURN batch_comm_slip_list_tab PIPELINED;
     
   PROCEDURE get_comm_slip_seq(
      p_fund_cd         IN    giis_funds.fund_cd%TYPE,
      p_branch_cd       IN    giac_branches.branch_cd%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE,
      p_cs_pref         OUT   giac_doc_sequence.doc_pref_suf%TYPE,
      p_cs_seq_no       OUT   giac_doc_sequence.doc_seq_no%TYPE
   );
   
   PROCEDURE tag_all(
      p_or_pref               VARCHAR2,
      p_or_no                 NUMBER,
      p_intm_no               NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat_amt         NUMBER,
      p_net_amt               NUMBER
   );
   
   PROCEDURE untag_all;
   
   PROCEDURE generate_comm_slip_numbers(
      p_comm_slip_pref  IN    giac_doc_sequence.doc_pref_suf%TYPE,
      p_comm_slip_seq   IN    giac_doc_sequence.doc_seq_no%TYPE,
      p_count           OUT   NUMBER
   );
   
   PROCEDURE save_generate_flag(
      p_gacc_tran_id          giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no               giac_comm_slip_ext.intm_no%TYPE,
      p_generate_flag         VARCHAR2
   );
   
   FUNCTION get_batch_comm_slip_reports
     RETURN report_params_tab PIPELINED;
     
   PROCEDURE update_comm_slip_ext(
      p_fund_cd        IN     giis_funds.fund_cd%TYPE,
      p_branch_cd      IN     giac_branches.branch_cd%TYPE,
      p_gacc_tran_id   IN     giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no        IN     giac_comm_slip_ext.intm_no%TYPE,
      p_comm_slip_pref IN OUT giac_doc_sequence.doc_pref_suf%TYPE,
      p_comm_slip_seq  IN OUT giac_doc_sequence.doc_seq_no%TYPE,
      p_user_id        IN     giis_users.user_id%TYPE
   );
   
   PROCEDURE clear_comm_slip_no(
      p_gacc_tran_id          giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no               giac_comm_slip_ext.intm_no%TYPE
   );

END;
/



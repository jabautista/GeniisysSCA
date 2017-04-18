CREATE OR REPLACE PACKAGE CPI.gipir923_mx_pkg
AS
   TYPE report_type IS RECORD (
      dis_flag                   VARCHAR2 (2),
      line_cd                    gipi_uwreports_ext.line_cd%TYPE,
      subline_cd                 gipi_uwreports_ext.subline_cd%TYPE,
      iss_cd_head                gipi_uwreports_ext.iss_cd%TYPE,
      iss_cd                     gipi_uwreports_ext.iss_cd%TYPE,
      issue_yy                   gipi_uwreports_ext.issue_yy%TYPE,
      pol_seq_no                 gipi_uwreports_ext.pol_seq_no%TYPE,
      renew_no                   gipi_uwreports_ext.renew_no%TYPE,
      endt_iss_cd                gipi_uwreports_ext.iss_cd%TYPE,
      endt_yy                    gipi_uwreports_ext.endt_yy%TYPE,
      endt_seq_no                gipi_uwreports_ext.endt_seq_no%TYPE,
      issue_date                 gipi_uwreports_ext.issue_date%TYPE,
      incept_date                gipi_uwreports_ext.incept_date%TYPE,
      expiry_date                gipi_uwreports_ext.expiry_date%TYPE,
      policy_id                  gipi_uwreports_ext.policy_id%TYPE,
      total_tsi                  NUMBER (20, 2),
      total_prem                 NUMBER (20, 2),
      total_taxes                NUMBER (20, 2),
      other_taxes                NUMBER (20, 2),
      total_charges              NUMBER (20, 2),
      spld_date                  VARCHAR (30),
      pol_count                  NUMBER (20, 2),
      comm_amt                   NUMBER (20, 2),
      wholding_tax               NUMBER (20, 2),
      net_comm                   NUMBER (20, 2),
      ref_inv_no                 gipi_invoice.ref_inv_no%TYPE,
      cf_assd_name               giis_assured.assd_name%TYPE,
      cf_policy_no               VARCHAR2 (100),
      cf_iss_name                VARCHAR2 (200),
      cf_iss_title               VARCHAR2 (30),
      cf_line_name               giis_line.line_name%TYPE,
      cf_subline_name            giis_subline.subline_name%TYPE,
      cf_heading3                VARCHAR2 (150),
      cf_company                 VARCHAR2 (150),
      cf_based_on                VARCHAR2 (200),
      cf_company_address         VARCHAR2 (500),
      print_ref_inv_param        VARCHAR2 (1),
      show_total_taxes_param     VARCHAR2 (1),
      print_special_risk_param   VARCHAR2 (1),
      p_from                     number(20), 
      p_to                       number(20)
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE tax_type IS RECORD (
      policy_id    gipi_uwreports_ext.policy_id%TYPE,
      tax_cd       giis_tax_charges.tax_cd%TYPE,
      tax_name     giis_tax_charges.tax_desc%TYPE,
      line_cd      gipi_uwreports_ext.line_cd%TYPE,
      subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      tax_amt      NUMBER (20, 2)
   );

   TYPE tax_tab IS TABLE OF tax_type;

   TYPE special_risk_type IS RECORD (
      cp_sr_prem   NUMBER (20, 2),
      cp_fr_prem   NUMBER (20, 2),
      cp_sr_comm   NUMBER (20, 2),
      cp_fr_comm   NUMBER (20, 2),
      cp_sr_tsi    NUMBER (20, 2),
      cp_fr_tsi    NUMBER (20, 2)
   );

   TYPE special_risk_tab IS TABLE OF special_risk_type;

   TYPE summary_type IS RECORD (
      cf_cnt_spoiled        NUMBER (30),
      cf_prem_spoiled       NUMBER (20, 2),
      cf_comm_amt_spoiled   NUMBER (20, 2),
      cf_cnt_undist         NUMBER (30),
      cf_prem_undist        NUMBER (20, 2),
      cf_comm_amt_undist    NUMBER (20, 2),
      cf_cnt_dist           NUMBER (30),
      cf_prem_dist          NUMBER (20, 2),
      cf_comm_amt_dist      NUMBER (20, 2)
   );

   TYPE summary_tab IS TABLE OF summary_type;

   FUNCTION populate_gipir923_mx (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE,
      p_from         number,
      p_to           number
   )
      RETURN report_tab PIPELINED;

   FUNCTION populate_tax (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_policy_id    gipi_uwreports_ext.policy_id%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN tax_tab PIPELINED;

   FUNCTION populate_special_risk (
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param   VARCHAR2,
      p_scope       gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id     gipi_uwreports_ext.user_id%TYPE
   )
      RETURN special_risk_tab PIPELINED;

   FUNCTION populate_summary (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    VARCHAR2,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN summary_tab PIPELINED;
END;
/



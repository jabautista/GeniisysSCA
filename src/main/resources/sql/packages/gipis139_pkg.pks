CREATE OR REPLACE PACKAGE CPI.gipis139_pkg
AS
   TYPE subline_lov_type IS RECORD (
      subline_cd     gipi_polbasic.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   TYPE intermediary_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE intermediary_lov_tab IS TABLE OF intermediary_lov_type;

   TYPE intermediary_comm_type IS RECORD (
      intm_no            giis_intermediary.intm_no%TYPE,
      prem_seq_no        polbasic_comm_invoice_v.prem_seq_no%TYPE,
      share_percentage   polbasic_comm_invoice_v.share_percentage%TYPE,
      commission_amt     polbasic_comm_invoice_v.commission_amt%TYPE,
      line_cd            polbasic_comm_invoice_v.line_cd%TYPE,
      subline_cd         polbasic_comm_invoice_v.subline_cd%TYPE,
      issue_yy           polbasic_comm_invoice_v.issue_yy%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      pol_seq_no         polbasic_comm_invoice_v.pol_seq_no%TYPE,
      renew_no           polbasic_comm_invoice_v.renew_no%TYPE,
      endt_iss_cd        polbasic_comm_invoice_v.endt_iss_cd%TYPE,
      endt_yy            polbasic_comm_invoice_v.endt_yy%TYPE,
      endt_seq_no        polbasic_comm_invoice_v.endt_seq_no%TYPE,
      eff_date           polbasic_comm_invoice_v.eff_date%TYPE,
      assd_no            polbasic_comm_invoice_v.assd_no%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      policy_no          VARCHAR2 (50),
      invoice_no         VARCHAR2 (50),
      assured_name       giis_assured.assd_name%TYPE,
      cred_branch        gipi_polbasic.cred_branch%TYPE
   );

   TYPE intermediary_comm_tab IS TABLE OF intermediary_comm_type;

   TYPE comm_detail_type IS RECORD (
      parent_comm_rt    NUMBER (20, 2),
      parent_comm_amt   NUMBER (20, 2),
      child_comm_rt     NUMBER (20, 2),
      child_comm_amt    NUMBER (20, 2),
      peril_name        giis_peril.peril_name%TYPE,
      peril_cd          gipi_comm_inv_peril.peril_cd%TYPE
   );

   TYPE comm_detail_tab IS TABLE OF comm_detail_type;

   TYPE peril_detail_type IS RECORD (
      peril_name       giis_peril.peril_name%TYPE,
      peril_cd         gipi_comm_inv_peril.peril_cd%TYPE,
      premium_amt      NUMBER (20, 2),
      commission_amt   NUMBER (20, 2),
      commission_rt    NUMBER (20, 2)
   );

   TYPE peril_detail_tab IS TABLE OF peril_detail_type;

   FUNCTION get_subline_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED;

   FUNCTION get_line_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_intermediary_lov
      RETURN intermediary_lov_tab PIPELINED;

   FUNCTION get_intermediary_comm (
      p_intrmdry_intm_no   polbasic_comm_invoice_v.intrmdry_intm_no%TYPE,
      p_line_cd            polbasic_comm_invoice_v.line_cd%TYPE,
      p_subline_cd         polbasic_comm_invoice_v.subline_cd%TYPE,
      p_cred_branch        VARCHAR2,
      p_user_id            VARCHAR2,
      p_module_id          VARCHAR2
   )
      RETURN intermediary_comm_tab PIPELINED;

   FUNCTION get_peril_detail (
      p_intrmdry_intm_no   gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      p_iss_cd             gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id          gipi_comm_inv_peril.policy_id%TYPE,
      p_line_cd            giis_line.line_cd%TYPE
   )
      RETURN peril_detail_tab PIPELINED;

   FUNCTION get_comm_detail (
      p_intrmdry_intm_no   gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      p_iss_cd             gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id          gipi_comm_inv_peril.policy_id%TYPE,
      p_line_cd            giis_line.line_cd%TYPE
   )
      RETURN comm_detail_tab PIPELINED;
END;
/



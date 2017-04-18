CREATE OR REPLACE PACKAGE cpi.giacr216_pkg
AS
   TYPE giacr216_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      branch_cd            gipi_polbasic.iss_cd%TYPE,
      line_cd              gipi_polbasic.line_cd%TYPE,
      subline_cd           gipi_polbasic.subline_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      iss_name             giis_issource.iss_name%TYPE,
      policy_id            gipi_polbasic.policy_id%TYPE,
      POLICY               VARCHAR2 (100),
      pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
      renew_no             gipi_polbasic.renew_no%TYPE,
      endt                 VARCHAR2 (100),
      endt_seq_no          gipi_polbasic.endt_seq_no%TYPE,
      incept_date          VARCHAR2 (100),
      expiry_date          VARCHAR2 (100),
      spld_acct_ent_date   gipi_polbasic.spld_acct_ent_date%TYPE,
      pol_flag             gipi_polbasic.pol_flag%TYPE,
      inv_no               VARCHAR2 (100),
      bill_no              gipi_invoice.prem_seq_no%TYPE,
      tsi                  gipi_polbasic.tsi_amt%TYPE,
      prem                 gipi_polbasic.prem_amt%TYPE,
      ri_comm_amt          gipi_invoice.ri_comm_amt%TYPE,
      due_from_ri          NUMBER (20, 2),
      ri_cd                giri_inpolbas.ri_cd%TYPE,
      ri_name              giis_reinsurer.ri_name%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      rec_exist            VARCHAR2 (1),
      cnt_policy           NUMBER (12),
      cnt_endt             NUMBER (12),
      cnt_spoiled_policy   NUMBER (12),
      cnt_spoiled_endt     NUMBER (12)
   );

   TYPE giacr216_records_tab IS TABLE OF giacr216_records_type;

   TYPE peril_by_policy_type IS RECORD (
      policy_id     gipi_polbasic.policy_id%TYPE,
      peril_sname   VARCHAR2 (20),
      peril_cd      giis_peril.peril_cd%TYPE,
      tsi_amt       NUMBER (20, 2),
      prem_amt      NUMBER (20, 2),
      ri_comm_amt   NUMBER (20, 2),
      due_from_ri   NUMBER (20, 2)
   );

   TYPE peril_by_policy_tab IS TABLE OF peril_by_policy_type;

   TYPE peril_by_subline_type IS RECORD (
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      branch_cd     gipi_polbasic.iss_cd%TYPE,
      peril_type    giis_peril.peril_type%TYPE,
      peril_sname   VARCHAR2 (20),
      tsi_amt       NUMBER (20, 2),
      prem_amt      NUMBER (20, 2),
      ri_comm_amt   NUMBER (20, 2),
      due_from_ri   NUMBER (20, 2)
   );

   TYPE peril_by_subline_tab IS TABLE OF peril_by_subline_type;

   TYPE peril_by_line_type IS RECORD (
      line_cd       gipi_polbasic.line_cd%TYPE,
      branch_cd     gipi_polbasic.iss_cd%TYPE,
      peril_sname   VARCHAR2 (20),
      tsi_amt       NUMBER (20, 2),
      prem_amt      NUMBER (20, 2),
      ri_comm_amt   NUMBER (20, 2),
      due_from_ri   NUMBER (20, 2)
   );

   TYPE peril_by_line_tab IS TABLE OF peril_by_line_type;

   TYPE peril_by_branch_type IS RECORD (
      branch_cd     gipi_polbasic.iss_cd%TYPE,
      peril_sname   VARCHAR2 (20),
      tsi_amt       NUMBER (20, 2),
      prem_amt      NUMBER (20, 2),
      ri_comm_amt   NUMBER (20, 2),
      due_from_ri   NUMBER (20, 2)
   );

   TYPE peril_by_branch_tab IS TABLE OF peril_by_branch_type;

   FUNCTION get_giacr216_records (
      p_from_date     DATE,
      p_to_date       DATE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE,
      p_issue_code    VARCHAR2,
      p_policy_endt   VARCHAR2
   )
      RETURN giacr216_records_tab PIPELINED;

   FUNCTION get_peril_by_policy (
      p_from_date     DATE,
      p_to_date       DATE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_policy_tab PIPELINED;

   FUNCTION get_peril_by_subline (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_subline_tab PIPELINED;

   FUNCTION get_peril_by_line (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_line_tab PIPELINED;

   FUNCTION get_peril_by_branch (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_branch_tab PIPELINED;

   FUNCTION get_total_peril (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_issue_code    VARCHAR2,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN peril_by_branch_tab PIPELINED;
END;
/
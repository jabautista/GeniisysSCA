CREATE OR REPLACE PACKAGE CPI.gipi_bank_schedule_pkg
AS
   TYPE bank_schedule_type IS RECORD (
      policy_id          gipi_bank_schedule.policy_id%TYPE,
      bank_item_no       gipi_bank_schedule.bank_item_no%TYPE,
      bank               gipi_bank_schedule.bank%TYPE,
      cash_in_vault      gipi_bank_schedule.cash_in_vault%TYPE,
      cash_in_transit    gipi_bank_schedule.cash_in_transit%TYPE,
      bank_line_cd       gipi_bank_schedule.bank_line_cd%TYPE,
      bank_subline_cd    gipi_bank_schedule.bank_subline_cd%TYPE,
      bank_iss_cd        gipi_bank_schedule.bank_iss_cd%TYPE,
      bank_issue_yy      gipi_bank_schedule.bank_issue_yy%TYPE,
      bank_pol_seq_no    gipi_bank_schedule.bank_pol_seq_no%TYPE,
      bank_endt_seq_no   gipi_bank_schedule.bank_endt_seq_no%TYPE,
      bank_renew_no      gipi_bank_schedule.bank_renew_no%TYPE,
      bank_eff_date      gipi_bank_schedule.bank_eff_date%TYPE,
      bank_address       gipi_bank_schedule.bank_address%TYPE
   );

   TYPE bank_schedule_tab IS TABLE OF bank_schedule_type;

   FUNCTION get_bank_collection_list(p_policy_id   gipi_bank_schedule.policy_id%TYPE)
      RETURN bank_schedule_tab PIPELINED;
END gipi_bank_schedule_pkg;
/



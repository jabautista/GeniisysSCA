CREATE OR REPLACE PACKAGE CPI.GIXX_BANK_SCHEDULE_PKG
AS
   -- created by Kris 03.13.2013 for GIPIS101
   TYPE bank_schedule_type IS RECORD (
      extract_id         gixx_bank_schedule.extract_id%TYPE,
      bank_item_no       gixx_bank_schedule.bank_item_no%TYPE,
      bank               gixx_bank_schedule.bank%TYPE,
      cash_in_vault      gixx_bank_schedule.cash_in_vault%TYPE,
      cash_in_transit    gixx_bank_schedule.cash_in_transit%TYPE,
      bank_line_cd       gixx_bank_schedule.bank_line_cd%TYPE,
      bank_subline_cd    gixx_bank_schedule.bank_subline_cd%TYPE,
      bank_iss_cd        gixx_bank_schedule.bank_iss_cd%TYPE,
      bank_issue_yy      gixx_bank_schedule.bank_issue_yy%TYPE,
      bank_pol_seq_no    gixx_bank_schedule.bank_pol_seq_no%TYPE,
      bank_endt_seq_no   gixx_bank_schedule.bank_endt_seq_no%TYPE,
      bank_renew_no      gixx_bank_schedule.bank_renew_no%TYPE,
      bank_eff_date      gixx_bank_schedule.bank_eff_date%TYPE,
      bank_address       gixx_bank_schedule.bank_address%TYPE
   );

   TYPE bank_schedule_tab IS TABLE OF bank_schedule_type;

   FUNCTION get_bank_collection_list(
        p_extract_id   gixx_bank_schedule.extract_id%TYPE
   ) RETURN bank_schedule_tab PIPELINED;
   -- end 03.13.2013: for GIPIS101
   
END GIXX_BANK_SCHEDULE_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.gipi_bank_schedule_pkg
AS
   FUNCTION get_bank_collection_list(p_policy_id gipi_bank_schedule.policy_id%TYPE)
      RETURN bank_schedule_tab PIPELINED
   IS
      v_bank_schedule   bank_schedule_type;
   BEGIN
      FOR i IN (SELECT policy_id, bank_item_no, bank, cash_in_vault,
                       cash_in_transit, bank_line_cd, bank_subline_cd,
                       bank_iss_cd, bank_issue_yy, bank_pol_seq_no,
                       bank_endt_seq_no, bank_renew_no, bank_eff_date,
                       bank_address
                  FROM gipi_bank_schedule
                 WHERE policy_id = p_policy_id)
      LOOP
         v_bank_schedule.policy_id := i.policy_id;
         v_bank_schedule.bank_item_no := i.bank_item_no;
         v_bank_schedule.bank := i.bank;
         v_bank_schedule.cash_in_vault := i.cash_in_vault;
         v_bank_schedule.cash_in_transit := i.cash_in_transit;
         v_bank_schedule.bank_line_cd := i.bank_line_cd;
         v_bank_schedule.bank_subline_cd := i.bank_subline_cd;
         v_bank_schedule.bank_iss_cd := i.bank_iss_cd;
         v_bank_schedule.bank_issue_yy := i.bank_issue_yy;
         v_bank_schedule.bank_pol_seq_no := i.bank_pol_seq_no;
         v_bank_schedule.bank_endt_seq_no := i.bank_endt_seq_no;
         v_bank_schedule.bank_renew_no := i.bank_renew_no;
         v_bank_schedule.bank_eff_date := i.bank_eff_date;
         v_bank_schedule.bank_address := i.bank_address;
         PIPE ROW (v_bank_schedule);
      END LOOP;
   END get_bank_collection_list;
END gipi_bank_schedule_pkg;                 --moses05122011
/



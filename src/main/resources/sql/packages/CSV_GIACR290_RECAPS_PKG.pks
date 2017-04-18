CREATE OR REPLACE PACKAGE CPI.CSV_GIACR290_RECAPS_PKG
AS
    /*
       Created by : Carlo Rubenecia
       SR : 5506
       Date : 04.12.2016
       Description : CSV for Recaps I-V
    */
   TYPE giacr290_type1 IS RECORD (
      row_no                        NUMBER (10,2),
      row_title                     VARCHAR2(50),
      policy_count                  NUMBER (10),
      coc_count                     NUMBER (10),
      direct_premiums               VARCHAR2(50),
      prem_ceded_auth               VARCHAR2(50),
      prem_ceded_asean              VARCHAR2(50),
      prem_ceded_others             VARCHAR2(50),
      net_direct_prem_written       VARCHAR2(50),
      assumed_premiums_auth         VARCHAR2(50),
      assumed_premiums_asean        VARCHAR2(50),
      assumed_premiums_others       VARCHAR2(50),
      assumed_prem_ceded_auth       VARCHAR2(50),
      assumed_prem_ceded_asean      VARCHAR2(50),
      assumed_prem_ceded_others     VARCHAR2(50),
      net_premiums_written          VARCHAR2(50),
      unearned_prem_prev_year       VARCHAR2(50),
      unearned_prem_current_year    VARCHAR2(50),
      earned_premiums               VARCHAR2(50)
   );
   TYPE giacr290_tab1 IS TABLE OF giacr290_type1;

   TYPE giacr290_type2 IS RECORD (
      row_no                        NUMBER (10,2),
      row_title                     VARCHAR2 (50),
      count                         NUMBER (10),
      dir_loss_paid                 VARCHAR2 (50),
      dir_exp_paid                  VARCHAR2 (50),
      dir_losses_recov_auth         VARCHAR2 (50),
      dir_losses_recov_asean        VARCHAR2 (50),
      dir_losses_recov_others       VARCHAR2 (50),
      net_losses_paid_direct        VARCHAR2 (50),
      net_expenses_paid_direct      VARCHAR2 (50),
      inw_auth_losses_paid          VARCHAR2 (50),
      inw_auth_expenses_paid        VARCHAR2 (50),
      inw_asean_le_paid             VARCHAR2 (50),
      inw_others_le_paid            VARCHAR2 (50),
      inw_losses_recov_auth         VARCHAR2 (50),
      inw_losses_recov_asean        VARCHAR2 (50),
      inw_losses_recov_others       VARCHAR2 (50),
      net_written_loss              VARCHAR2 (50),
      net_written_exp               VARCHAR2 (50),
      net_losses_unpaid_cy          VARCHAR2 (50),
      net_exp_unpaid_cy             VARCHAR2 (50),
      net_losses_unpaid_py          VARCHAR2 (50),
      net_exp_unpaid_py             VARCHAR2 (50),
      losses_incurred               VARCHAR2 (50),
      expense_incurred              VARCHAR2 (50),
      earned_premium                VARCHAR2 (50),
      loss_ratio                    VARCHAR2 (50)
   );
   TYPE giacr290_tab2 IS TABLE OF giacr290_type2;
   
   TYPE giacr290_type3 IS RECORD (
      row_no                        NUMBER (10,2),
      row_title                     VARCHAR2 (50),
      direct_comm_expense           VARCHAR2 (50),
      comm_income_auth              VARCHAR2 (50),
      comm_income_asean             VARCHAR2 (50),
      comm_income_others            VARCHAR2 (50),
      net_direct_comm_expense       VARCHAR2 (50),
      assumed_comm_exp_auth         VARCHAR2 (50),
      assumed_comm_exp_asean        VARCHAR2 (50),
      assumed_comm_exp_others       VARCHAR2 (50),
      assumed_comm_income_auth      VARCHAR2 (50),
      assumed_comm_income_asean     VARCHAR2 (50),
      assumed_comm_income_others    VARCHAR2 (50),
      net_commission_expense        VARCHAR2 (50)
   );
   TYPE giacr290_tab3 IS TABLE OF giacr290_type3;

   TYPE giacr290_type4 IS RECORD (
      row_no                        NUMBER (10),
      row_title                     VARCHAR2 (50),
      direct_tsi                    VARCHAR2(50),
      tsi_ceded_auth                VARCHAR2(50),
      tsi_ceded_asean               VARCHAR2(50),
      tsi_ceded_others              VARCHAR2(50),
      net_direct_tsi                VARCHAR2(50),
      assumed_tsi_auth              VARCHAR2(50),
      assumed_tsi_asean             VARCHAR2(50),
      assumed_tsi_others            VARCHAR2(50),
      assumed_tsi_ceded_auth        VARCHAR2(50),
      assumed_tsi_ceded_asean       VARCHAR2(50),
      assumed_tsi_ceded_others      VARCHAR2(50),
      net_tsi_written               VARCHAR2(50)
   );
   TYPE giacr290_tab4 IS TABLE OF giacr290_type4;

   TYPE giacr290_type5 IS RECORD (
      row_no                        NUMBER (10,2),
      row_title                     VARCHAR2 (50),
      policy_count                  NUMBER (10),
      direct_loss                   VARCHAR2 (50),
      losses_recov_auth             VARCHAR2 (50),
      losses_recov_asean            VARCHAR2 (50),
      losses_recov_others           VARCHAR2 (50),
      net_direct_losses             VARCHAR2 (50),
      assumed_loss_auth             VARCHAR2 (50),
      assumed_loss_asean            VARCHAR2 (50),
      assumed_loss_others           VARCHAR2 (50),
      assumed_losses_recov_auth     VARCHAR2 (50),
      assumed_losses_recov_asean    VARCHAR2 (50),
      assumed_losses_recov_others   VARCHAR2 (50),
      net_losses_paid               VARCHAR2 (50)
   );
   TYPE giacr290_tab5 IS TABLE OF giacr290_type5;
   
   FUNCTION csv_giacr290_recap1
      RETURN giacr290_tab1 PIPELINED;
      
   FUNCTION csv_giacr290_recap3
      RETURN giacr290_tab3 PIPELINED;
      
   FUNCTION csv_giacr290_recap4
      RETURN giacr290_tab4 PIPELINED;
      
   FUNCTION csv_giacr290_recap5
      RETURN giacr290_tab5 PIPELINED;
   
   FUNCTION csv_giacr290_recap2
      RETURN giacr290_tab2 PIPELINED;

END;
/

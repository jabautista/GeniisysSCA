CREATE OR REPLACE PACKAGE BODY CPI.CSV_GIACR290_RECAPS_PKG
AS
    /*
       Created by : Carlo Rubenecia
       SR : 5506
       Date : 04.12.2016
       Description : CSV for Recaps I-V
    */
    FUNCTION csv_giacr290_recap1
        RETURN giacr290_tab1 PIPELINED
    IS
       v_list   giacr290_type1;
    BEGIN
           
        FOR q IN(SELECT rowno,
         rowtitle,
         rowcount_func policy_count,
         ctpl_count_func coc_count,
         NVL (direct_col, 0) direct_premiums,
         NVL (ceded_auth, 0) prem_ceded_auth,
         NVL (ceded_asean, 0) prem_ceded_asean,
         NVL (ceded_oth, 0) prem_ceded_others,
         NVL (net_direct, 0) net_direct_prem_written,
         NVL (inw_auth, 0) assumed_premiums_auth,
         NVL (inw_asean, 0) assumed_premiums_asean,
         NVL (inw_oth, 0) assumed_premiums_others,
         NVL (retced_auth, 0) assumed_prem_ceded_auth,
         NVL (retced_asean, 0) assumed_prem_ceded_asean,
         NVL (retced_oth, 0) assumed_prem_ceded_others,
         NVL (net_written, 0) net_premiums_written,
         NVL (prev_def_prem_amt, 0) unearned_prem_prev_year,
         NVL (curr_def_prem_amt, 0) unearned_prem_current_year,
         NVL (earned_premiums, 0) earned_premiums
         FROM TABLE (giacr290_pkg.get_giacr290_records ('PREMIUM'))
         ORDER BY rowno, rowtitle)
    
        LOOP
            v_list.row_no := q.rowno;
            v_list.row_title := q.rowtitle;
            v_list.policy_count := q.policy_count;
            v_list.coc_count := q.coc_count;
            v_list.direct_premiums  := trim(to_char(q.direct_premiums, '999,999,999,999,990.99'));
            v_list.prem_ceded_auth := trim(to_char(q.prem_ceded_auth, '999,999,999,999,990.99'));
            v_list.prem_ceded_asean  := trim(to_char(q.prem_ceded_asean, '999,999,999,999,990.99'));
            v_list.prem_ceded_others  := trim(to_char(q.prem_ceded_others, '999,999,999,999,990.99'));
            v_list.net_direct_prem_written  := trim(to_char(q.net_direct_prem_written, '999,999,999,999,990.99'));
            v_list.assumed_premiums_auth  := trim(to_char(q.assumed_premiums_auth, '999,999,999,999,990.99'));
            v_list.assumed_premiums_asean := trim(to_char(q.assumed_premiums_asean, '999,999,999,999,990.99'));
            v_list.assumed_premiums_others := trim(to_char(q.assumed_premiums_others, '999,999,999,999,990.99'));
            v_list.assumed_prem_ceded_auth := trim(to_char(q.assumed_prem_ceded_auth, '999,999,999,999,990.99'));
            v_list.assumed_prem_ceded_asean := trim(to_char(q.assumed_prem_ceded_asean, '999,999,999,999,990.99'));
            v_list.assumed_prem_ceded_others  := trim(to_char(q.assumed_prem_ceded_others, '999,999,999,999,990.99'));
            v_list.net_premiums_written  := trim(to_char(q.net_premiums_written , '999,999,999,999,990.99'));
            v_list.unearned_prem_prev_year := trim(to_char(q.unearned_prem_prev_year, '999,999,999,999,990.99'));
            v_list.unearned_prem_current_year := trim(to_char(q.unearned_prem_current_year, '999,999,999,999,990.99'));
            v_list.earned_premiums := trim(to_char(q.earned_premiums, '999,999,999,999,990.99'));
            PIPE ROW(v_list);
        END LOOP;
                    
    END csv_giacr290_recap1; 
    
    FUNCTION csv_giacr290_recap2
        RETURN giacr290_tab2 PIPELINED
    IS
       v_list   giacr290_type2;
    BEGIN
           
        FOR q IN(SELECT   rowno, rowtitle, rowcount_func count, NVL (direct_loss, 0) dir_loss_paid, NVL (direct_exp, 0) dir_exp_paid, 
         NVL (ceded_auth, 0) dir_losses_recov_auth, NVL (ceded_asean, 0)dir_losses_recov_asean, NVL (ceded_oth, 0) dir_losses_recov_others, 
         NVL (net_direct_loss, 0) net_losses_paid_direct,
         NVL (net_direct_exp, 0) net_expenses_paid_direct, NVL (inw_auth_loss, 0) inw_auth_losses_paid,
         NVL (inw_auth_exp, 0) inw_auth_expenses_paid, NVL (inw_asean, 0) inw_asean_le_paid, NVL (inw_oth, 0) inw_others_le_paid,
         NVL (retced_auth, 0) inw_losses_recov_auth, NVL (retced_asean, 0) inw_losses_recov_asean, NVL (retced_oth, 0) inw_losses_recov_others,
         NVL (net_written_loss, 0) net_written_loss, NVL (net_written_exp, 0) net_written_exp,
         NVL (net_osloss_cy, 0) net_losses_unpaid_cy, NVL (net_osexp_cy, 0) net_exp_unpaid_cy,
         NVL (net_osloss_py, 0)net_losses_unpaid_py, NVL (net_osexp_py, 0) net_exp_unpaid_py, 
         NVL (net_lossinc,0) losses_incurred,  NVL (net_expinc,0) expense_incurred, 
         NVL (earned_premiums, 0) earned_premium, NVL(lossratio,0) loss_ratio
    FROM TABLE (giacr290_pkg.get_giacr290_records ('LOSSPD'))
    ORDER BY rowno, rowtitle)
   
        LOOP
            v_list.row_no := q.rowno;
            v_list.row_title := q.rowtitle;
            v_list.count  := q.count;
            v_list.dir_loss_paid   := trim(to_char(q.dir_loss_paid,'999,999,999,999,990.99'));
            v_list.dir_exp_paid := trim(to_char(q.dir_exp_paid,'999,999,999,999,990.99'));
            v_list.dir_losses_recov_auth  := trim(to_char(q.dir_losses_recov_auth,'999,999,999,999,990.99'));
            v_list.dir_losses_recov_asean  := trim(to_char(q.dir_losses_recov_asean,'999,999,999,999,990.99'));
            v_list.dir_losses_recov_others  := trim(to_char(q.dir_losses_recov_others,'999,999,999,999,990.99'));
            v_list.net_losses_paid_direct   := trim(to_char(q.net_losses_paid_direct, '999,999,999,999,990.99'));
            v_list.net_expenses_paid_direct := trim(to_char(q.net_expenses_paid_direct,'999,999,999,999,990.99'));
            v_list.inw_auth_losses_paid    := trim(to_char(q.inw_auth_losses_paid,'999,999,999,999,990.99'));
            v_list.inw_auth_expenses_paid  := trim(to_char(q.inw_auth_expenses_paid,'999,999,999,999,990.99'));
            v_list.inw_asean_le_paid  := trim(to_char(q.inw_asean_le_paid,'999,999,999,999,990.99'));
            v_list.inw_others_le_paid   := trim(to_char(q.inw_others_le_paid,'999,999,999,999,990.99'));
            v_list.inw_losses_recov_auth  :=  trim(to_char(q.inw_losses_recov_auth,'999,999,999,999,990.99'));
            v_list.inw_losses_recov_asean := trim(to_char(q.inw_losses_recov_asean,'999,999,999,999,990.99'));
            v_list.inw_losses_recov_others  := trim(to_char(q.inw_losses_recov_others,'999,999,999,999,990.99'));
            v_list.net_written_loss := trim(to_char(q.net_written_loss,'999,999,999,999,990.99'));
            v_list.net_written_exp   :=  trim(to_char(q.net_written_exp,'999,999,999,999,990.99'));
            v_list.net_losses_unpaid_cy := trim(to_char(q.net_losses_unpaid_cy,'999,999,999,999,990.99'));
            v_list.net_exp_unpaid_cy   := trim(to_char(q.net_exp_unpaid_cy,'999,999,999,999,990.99'));
            v_list.net_losses_unpaid_py := trim(to_char(q.net_losses_unpaid_py,'999,999,999,999,990.99'));
            v_list.net_exp_unpaid_py  := trim(to_char(q.net_exp_unpaid_py,'999,999,999,999,990.99'));
            v_list.losses_incurred  := trim(to_char(q.losses_incurred,'999,999,999,999,990.99'));
            v_list.expense_incurred  := trim(to_char(q.expense_incurred,'999,999,999,999,990.99'));
            v_list.earned_premium   := trim(to_char(q.earned_premium,'999,999,999,999,990.99'));
            v_list.loss_ratio := q.loss_ratio;
            PIPE ROW(v_list);
        END LOOP;
                     
    END csv_giacr290_recap2;    

    FUNCTION csv_giacr290_recap3
        RETURN giacr290_tab3 PIPELINED
    IS
       v_list   giacr290_type3;
    BEGIN
           
        FOR q IN(SELECT rowno,
         rowtitle,
         NVL (direct_col, 0) direct_comm_expense,
         NVL (ceded_auth, 0) comm_income_auth,
         NVL (ceded_asean, 0) comm_income_asean,
         NVL (ceded_oth, 0) comm_income_others,
         NVL (net_direct, 0) net_direct_comm_expense,
         NVL (inw_auth, 0) assumed_comm_exp_auth,
         NVL (inw_asean, 0) assumed_comm_exp_asean,
         NVL (inw_oth, 0) assumed_comm_exp_others,
         NVL (retced_auth, 0) assumed_comm_income_auth,
         NVL (retced_asean, 0) assumed_comm_income_asean,
         NVL (retced_oth, 0) assumed_comm_income_others,
         NVL (net_written, 0) net_commission_expense
         FROM TABLE (giacr290_pkg.get_giacr290_records ('COMM'))
         ORDER BY rowno, rowtitle)
    
        LOOP
            v_list.row_no := q.rowno;
            v_list.row_title := q.rowtitle;
            v_list.direct_comm_expense  := trim(to_char(q.direct_comm_expense, '999,999,999,999,990.99'));
            v_list.comm_income_auth := trim(to_char(q.comm_income_auth, '999,999,999,999,990.99'));
            v_list.comm_income_asean  := trim(to_char(q.comm_income_asean, '999,999,999,999,990.99'));
            v_list.comm_income_others :=  trim(to_char(q.comm_income_others, '999,999,999,999,990.99'));
            v_list.net_direct_comm_expense  := trim(to_char(q.net_direct_comm_expense, '999,999,999,999,990.99'));
            v_list.assumed_comm_exp_auth  := trim(to_char(q.assumed_comm_exp_auth, '999,999,999,999,990.99'));
            v_list.assumed_comm_exp_asean :=  trim(to_char(q.assumed_comm_exp_asean, '999,999,999,999,990.99'));
            v_list.assumed_comm_exp_others :=  trim(to_char(q.assumed_comm_exp_others, '999,999,999,999,990.99'));
            v_list.assumed_comm_income_auth :=  trim(to_char(q.assumed_comm_income_auth, '999,999,999,999,990.99'));
            v_list.assumed_comm_income_asean := trim(to_char(q.assumed_comm_income_asean, '999,999,999,999,990.99'));
            v_list.assumed_comm_income_others  := trim(to_char(q.assumed_comm_income_others, '999,999,999,999,990.99'));
            v_list.net_commission_expense  := trim(to_char(q.net_commission_expense, '999,999,999,999,990.99'));
            PIPE ROW(v_list);
        END LOOP;
                  
    END csv_giacr290_recap3;    
    
    FUNCTION csv_giacr290_recap4
        RETURN giacr290_tab4 PIPELINED
    IS
       v_list   giacr290_type4;
    BEGIN
           
        FOR q IN(SELECT rowno,
         rowtitle,
         NVL (direct_col, 0) direct_tsi,
         NVL (ceded_auth, 0) tsi_ceded_auth,
         NVL (ceded_asean, 0) tsi_ceded_asean,
         NVL (ceded_oth, 0) tsi_ceded_others,
         NVL (net_direct, 0) net_direct_tsi,
         NVL (inw_auth, 0) assumed_tsi_auth,
         NVL (inw_asean, 0) assumed_tsi_asean,
         NVL (inw_oth, 0) assumed_tsi_others,
         NVL (retced_auth, 0) assumed_tsi_ceded_auth,
         NVL (retced_asean, 0) assumed_tsi_ceded_asean,
         NVL (retced_oth, 0) assumed_tsi_ceded_others,
         NVL (net_written, 0) net_tsi_written
         FROM TABLE (giacr290_pkg.get_giacr290_records ('TSI'))
         ORDER BY rowno, rowtitle)
         
        LOOP
            v_list.row_no := q.rowno;
            v_list.row_title := q.rowtitle;
            v_list.direct_tsi  := trim(to_char(q.direct_tsi, '999,999,999,999,990.00'));
            v_list.tsi_ceded_auth := trim(to_char(q.tsi_ceded_auth, '999,999,999,999,990.00'));
            v_list.tsi_ceded_asean := trim(to_char(q.tsi_ceded_asean, '999,999,999,999,990.00'));
            v_list.tsi_ceded_others  := trim(to_char(q.tsi_ceded_others, '999,999,999,999,990.00'));
            v_list.net_direct_tsi := trim(to_char(q.net_direct_tsi, '999,999,999,999,990.00'));
            v_list.assumed_tsi_auth  := trim(to_char(q.assumed_tsi_auth, '999,999,999,999,990.00'));
            v_list.assumed_tsi_asean  := trim(to_char(q.assumed_tsi_asean, '999,999,999,999,990.00'));
            v_list.assumed_tsi_others :=  trim(to_char(q.assumed_tsi_others, '999,999,999,999,990.00'));
            v_list.assumed_tsi_ceded_auth := trim(to_char(q.assumed_tsi_ceded_auth, '999,999,999,999,990.00'));
            v_list.assumed_tsi_ceded_asean := trim(to_char(q.assumed_tsi_ceded_asean, '999,999,999,999,990.00'));
            v_list.assumed_tsi_ceded_others := trim(to_char(q.assumed_tsi_ceded_others, '999,999,999,999,990.00')); 
            v_list.net_tsi_written  := trim(to_char(q.net_tsi_written, '999,999,999,999,990.00'));
            PIPE ROW(v_list);
        END LOOP;
                         
    END csv_giacr290_recap4; 
    
    FUNCTION csv_giacr290_recap5
        RETURN giacr290_tab5 PIPELINED
    IS
       v_list   giacr290_type5;
    BEGIN
    
        FOR q IN( SELECT rowno,
         rowtitle,
         rowcount_func policy_count,
         NVL (direct_col, 0) direct_loss,
         NVL (ceded_auth, 0) losses_recov_auth,
         NVL (ceded_asean, 0) losses_recov_asean,
         NVL (ceded_oth, 0) losses_recov_others,
         NVL (net_direct, 0) net_direct_losses,
         NVL (inw_auth, 0) assumed_loss_auth,
         NVL (inw_asean, 0) assumed_loss_asean,
         NVL (inw_oth, 0) assumed_loss_others,
         NVL (retced_auth, 0) assumed_losses_recov_auth,
         NVL (retced_asean, 0) assumed_losses_recov_asean,
         NVL (retced_oth, 0) assumed_losses_recov_others,
         NVL (net_written, 0) net_losses_paid
         FROM TABLE (giacr290_pkg.get_giacr290_records ('OSLOSS'))
         ORDER BY rowno, rowtitle)
         
        LOOP
            v_list.row_no := q.rowno;
            v_list.row_title := q.rowtitle;
            v_list.policy_count := q.policy_count;
            v_list.direct_loss  :=  trim(to_char(q.direct_loss,'999,999,999,999,990.99'));
            v_list.losses_recov_auth :=  trim(to_char(q.losses_recov_auth, '999,999,999,999,990.99'));
            v_list.losses_recov_asean := trim(to_char(q.losses_recov_asean, '999,999,999,999,990.99'));
            v_list.losses_recov_others  := trim(to_char(q.losses_recov_others, '999,999,999,999,990.99'));
            v_list.net_direct_losses :=  trim(to_char(q.net_direct_losses, '999,999,999,999,990.99'));
            v_list.assumed_loss_auth  :=  trim(to_char(q.assumed_loss_auth, '999,999,999,999,990.99'));
            v_list.assumed_loss_asean  :=  trim(to_char(q.assumed_loss_asean, '999,999,999,999,990.99'));
            v_list.assumed_loss_others := trim(to_char(q.assumed_loss_others, '999,999,999,999,990.99'));
            v_list.assumed_losses_recov_auth := trim(to_char(q.assumed_losses_recov_auth, '999,999,999,999,990.99'));
            v_list.assumed_losses_recov_asean:= trim(to_char(q.assumed_losses_recov_asean, '999,999,999,999,990.99'));
            v_list.assumed_losses_recov_others := trim(to_char(q.assumed_losses_recov_others, '999,999,999,999,990.99'));
            v_list.net_losses_paid  := trim(to_char(q.net_losses_paid, '999,999,999,999,990.99'));
            PIPE ROW(v_list);
        END LOOP;
                 
    END csv_giacr290_recap5;  
 
END;
/

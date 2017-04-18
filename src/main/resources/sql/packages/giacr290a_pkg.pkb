CREATE OR REPLACE PACKAGE BODY CPI.GIACR290A_PKG AS
FUNCTION populate_giacr209A(
    p_report_type   varchar2,
    p_row_title   varchar2,
    p_date2 varchar2
)
RETURN giacr209A_tab PIPELINED as 

    v_rec giacr209A_type;
BEGIN

    if(p_report_type = 'PREMIUM') then
         FOR a IN(
             SELECT 'ANNUAL STATEMENT FOR THE YEAR ENDED DECEMBER 31, '||P_DATE2||' OF THE '|| giacp.v('COMPANY_NAME') as rep_title,
                    'Details for Line Of Business: '|| p_row_title as dtl_sub_title,
                    get_policy_no(policy_id) AS pol_no,
                    SUM(direct_prem)        AS direct_col,
                    SUM(ceded_prem_auth) AS ceded_auth, 
                    SUM(ceded_prem_asean) AS ceded_asean, 
                    SUM(ceded_prem_oth) AS ceded_oth,
                    (SUM(direct_prem) - SUM(ceded_prem_auth) -  SUM(ceded_prem_asean) - SUM(ceded_prem_oth)) AS net_direct, 
                     SUM(inw_prem_auth) AS inw_auth, 
                     SUM(inw_prem_asean) AS inw_asean, 
                     SUM(inw_prem_oth) AS inw_oth, 
                     SUM(retceded_prem_auth) AS retced_auth, 
                     SUM(retceded_prem_asean) AS retced_asean, 
                     SUM(retceded_prem_oth) AS retced_oth,
                     (SUM(direct_prem) -   --marco - added column
                     SUM(ceded_prem_auth) - 
                     SUM(ceded_prem_asean) - 
                     SUM(ceded_prem_oth) +
                     SUM(inw_prem_auth) + 
                     SUM(inw_prem_asean) + 
                     SUM(inw_prem_oth) - 
                     SUM(retceded_prem_auth) - 
                     SUM(retceded_prem_asean) - 
                     SUM(retceded_prem_oth)) AS net_written,
                     chr(10)||chr(10)||'Premiums on'||chr(10)||' Direct Business' AS direct_title ,
                     'C  E  D  E  D    P  R  E  M  I  U  M  S' AS cedgroup_title,
                     chr(10)||'Net Premiums'||chr(10)||'Written on'||chr(10)||'Direct Business' as netdirect_title,
                     'A S S U M E D  P R E M I U M S' as assumed_title,
                     'R  E  T  R  O  C  E  D  E  D' as retroceded_title,
                     chr(10)||chr(10)||'Net Premiums'||chr(10)||'Written' as netwritten_title,
                     'RECAPITULATION I - PREMIUMS WRITTEN AND PREMIUMS EARNED (LESS RETURNS AND CANCELLATIONS)' as subtitle,
                     'Policy No.' as pol_title
                FROM giac_recap_summ_ext
                WHERE giac_recap_summ_ext.ROWTITLE = p_row_title
                GROUP BY get_policy_no(policy_id)
        )
        LOOP
            v_rec.pol_no := a.pol_no;
            v_rec.ceded_auth := a.ceded_auth;
            v_rec.ceded_asean := a.ceded_asean;
            v_rec.ceded_oth := a.ceded_oth;
            v_rec.net_direct := a.net_direct;
            v_rec.direct_prem := a.direct_col;
            v_rec.inw_auth := a.inw_auth;
            v_rec.inw_asean := a.inw_asean;
            v_rec.inw_oth := a.inw_oth;
            v_rec.retced_auth := a.retced_auth;
            v_rec.retced_asean := a.retced_asean;
            v_rec.retced_oth := a.retced_oth;
            v_rec.net_written := a.net_written;
            v_rec.direct_title := a.direct_title;
            v_rec.cedgroup_title := a.cedgroup_title;
            v_rec.netdirect_title := a.netdirect_title;
            v_rec.assumed_title := a.assumed_title;
            v_rec.retroceded_title := a.retroceded_title;
            v_rec.netwritten_title := a.netwritten_title;
            v_rec.subtitle := a.subtitle;
            v_rec.pol_title := a.pol_title;
            v_rec.rep_title := a.rep_title;
            v_rec.dtl_sub_title := a.dtl_sub_title;
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
            PIPE ROW (v_rec);
            
        END LOOP;
        if v_rec.company_name is null then
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
             PIPE ROW (v_rec);
        end if;
        
    elsif (p_report_type = 'TSI') then
         FOR a IN(
             SELECT 
                    'ANNUAL STATEMENT FOR THE YEAR ENDED DECEMBER 31, '||P_DATE2||' OF THE '|| giacp.v('COMPANY_NAME') as rep_title,
                    'Details for Line Of Business: '|| p_row_title as dtl_sub_title,
                    get_policy_no(policy_id) AS pol_no,
                    SUM(direct_tsi)        AS direct_col,
                    SUM(ceded_tsi_auth) AS ceded_auth, 
                    SUM(ceded_tsi_asean) AS ceded_asean, 
                    SUM(ceded_tsi_oth) AS ceded_oth,
                    (SUM(direct_tsi) - SUM(ceded_tsi_auth) -  SUM(ceded_tsi_asean) - SUM(ceded_tsi_oth)) AS net_direct, 
                     SUM(inw_tsi_auth) AS inw_auth, 
                     SUM(inw_tsi_asean) AS inw_asean, 
                     SUM(inw_tsi_oth) AS inw_oth, 
                     SUM(retceded_tsi_auth) AS retced_auth, 
                     SUM(retceded_tsi_asean) AS retced_asean, 
                     SUM(retceded_tsi_oth) AS retced_oth,
                     (SUM(direct_tsi) -     --marco - added column
                     SUM(ceded_tsi_auth) - 
                     SUM(ceded_tsi_asean) - 
                     SUM(ceded_tsi_oth) +
                     SUM(inw_tsi_auth) + 
                     SUM(inw_tsi_asean) + 
                     SUM(inw_tsi_oth) - 
                     SUM(retceded_tsi_auth) - 
                     SUM(retceded_tsi_asean) - 
                     SUM(retceded_tsi_oth)) AS net_written,
                     chr(10)||chr(10)||'Premiums on'||chr(10)||' Direct Business' AS direct_title ,
                     'R  I  S  K  S    C  E  D  E  D' AS cedgroup_title,
                     chr(10)||'Net Risks'||chr(10)||'on Direct'||chr(10)||'Business' as netdirect_title,
                     'R  I  S  K  S    A  S  S  U  M  E  D' as assumed_title,
                     'R  I  S  K  S    R  E  T  R  O  C  E  D  E  D' as retroceded_title,
                     chr(10)||chr(10)||'Net Risks'||chr(10)||'Written' as netwritten_title,
                     'RECAPITULATION IV - RISKS IN FORCE' as subtitle,
                     'Policy No.' as pol_title
                FROM giac_recap_summ_ext
                WHERE giac_recap_summ_ext.ROWTITLE = p_row_title
                GROUP BY get_policy_no(policy_id)
        )
        LOOP
            v_rec.pol_no := a.pol_no;
            v_rec.ceded_auth := a.ceded_auth;
            v_rec.ceded_asean := a.ceded_asean;
            v_rec.ceded_oth := a.ceded_oth;
            v_rec.net_direct := a.net_direct;
            v_rec.direct_prem := a.direct_col;
            v_rec.inw_auth := a.inw_auth;
            v_rec.inw_asean := a.inw_asean;
            v_rec.inw_oth := a.inw_oth;
            v_rec.retced_auth := a.retced_auth;
            v_rec.retced_asean := a.retced_asean;
            v_rec.retced_oth := a.retced_oth;
            v_rec.net_written := a.net_written;
            v_rec.direct_title := a.direct_title;
            v_rec.cedgroup_title := a.cedgroup_title;
            v_rec.netdirect_title := a.netdirect_title;
            v_rec.assumed_title := a.assumed_title;
            v_rec.retroceded_title := a.retroceded_title;
            v_rec.netwritten_title := a.netwritten_title;
            v_rec.subtitle := a.subtitle;
            v_rec.pol_title := a.pol_title;
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
            v_rec.rep_title := a.rep_title;
            v_rec.dtl_sub_title := a.dtl_sub_title;
            PIPE ROW (v_rec);
            
        END LOOP; 
        if v_rec.company_name is null then
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
             PIPE ROW (v_rec);
        end if; 
    elsif (p_report_type = 'COMM') then
         FOR a IN(
             SELECT 'ANNUAL STATEMENT FOR THE YEAR ENDED DECEMBER 31, '||P_DATE2||' OF THE '|| giacp.v('COMPANY_NAME') as rep_title,
                    'Details for Line Of Business: '|| p_row_title as dtl_sub_title,
                    get_policy_no(policy_id) AS pol_no,
                    SUM(direct_comm)        AS direct_col,
                    SUM(ceded_comm_auth) AS ceded_auth, 
                    SUM(ceded_comm_asean) AS ceded_asean, 
                    SUM(ceded_comm_oth) AS ceded_oth,
                    (SUM(direct_comm) - SUM(ceded_comm_auth) -  SUM(ceded_comm_asean) - SUM(ceded_comm_oth)) AS net_direct, 
                     SUM(inw_comm_auth) AS inw_auth, 
                     SUM(inw_comm_asean) AS inw_asean, 
                     SUM(inw_comm_oth) AS inw_oth, 
                     SUM(retceded_comm_auth) AS retced_auth, 
                     SUM(retceded_comm_asean) AS retced_asean, 
                     SUM(retceded_comm_oth) AS retced_oth,
                     (SUM(direct_comm) -    --marco - added column
                     SUM(ceded_comm_auth) - 
                     SUM(ceded_comm_asean) - 
                     SUM(ceded_comm_oth) +
                     SUM(inw_comm_auth) + 
                     SUM(inw_comm_asean) + 
                     SUM(inw_comm_oth) - 
                     SUM(retceded_comm_auth) - 
                     SUM(retceded_comm_asean) - 
                     SUM(retceded_comm_oth)) AS net_written,
                     'Commision'||chr(10)||'Expenses'||chr(10)||'on Direct'||chr(10)||'Business' AS direct_title ,
                     'COMMISSION INCOME FROM CEDED BUSINESS' AS cedgroup_title,
                     chr(10)||'Net Commision'||chr(10)||'Expenses on'||chr(10)||'Direct Business' as netdirect_title,
                     'COMMISSION EXPENSES ON ASSUMED BUSINESS' as assumed_title,
                     'COMMISSION INCOME FROM RETROCEDED BUSINESS' as retroceded_title,
                     chr(10)||chr(10)||'Net Commision'||chr(10)||'Expenses' as netwritten_title,
                     'RECAPITULATION III - COMMISSIONS' as subtitle,
                     'Policy No.' as pol_title
                FROM giac_recap_summ_ext
                WHERE giac_recap_summ_ext.ROWTITLE = p_row_title
                GROUP BY get_policy_no(policy_id)
        )
        LOOP
            v_rec.pol_no := a.pol_no;
            v_rec.ceded_auth := a.ceded_auth;
            v_rec.ceded_asean := a.ceded_asean;
            v_rec.ceded_oth := a.ceded_oth;
            v_rec.net_direct := a.net_direct;
            v_rec.direct_prem := a.direct_col;
            v_rec.inw_auth := a.inw_auth;
            v_rec.inw_asean := a.inw_asean;
            v_rec.inw_oth := a.inw_oth;
            v_rec.retced_auth := a.retced_auth;
            v_rec.retced_asean := a.retced_asean;
            v_rec.retced_oth := a.retced_oth;
            v_rec.net_written := a.net_written;
            v_rec.direct_title := a.direct_title;
            v_rec.cedgroup_title := a.cedgroup_title;
            v_rec.netdirect_title := a.netdirect_title;
            v_rec.assumed_title := a.assumed_title;
            v_rec.retroceded_title := a.retroceded_title;
            v_rec.netwritten_title := a.netwritten_title;
            v_rec.subtitle := a.subtitle;
            v_rec.pol_title := a.pol_title;
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
            v_rec.rep_title := a.rep_title;
            v_rec.dtl_sub_title := a.dtl_sub_title;
            PIPE ROW (v_rec);
            
        END LOOP;
        if v_rec.company_name is null then
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
             PIPE ROW (v_rec);
        end if;
    elsif (p_report_type = 'LOSSPD') then
         FOR a IN(
             SELECT 'ANNUAL STATEMENT FOR THE YEAR ENDED DECEMBER 31, '||P_DATE2||' OF THE '|| giacp.v('COMPANY_NAME') as rep_title,
                    'Details for Line Of Business: '|| p_row_title as dtl_sub_title,
                    get_recap_claim_no(claim_id) AS pol_no,
                    SUM(gross_loss + gross_exp)        AS direct_col,
                    SUM(loss_auth + exp_auth) AS ceded_auth, 
                    SUM(loss_asean + exp_asean) AS ceded_asean, 
                    SUM(loss_oth + exp_oth) AS ceded_oth,
                    --0 AS net_direct,  --marco - modified hard coded value
                    (SUM(gross_loss + gross_exp) - 
                     SUM(loss_auth + exp_auth) -  
                     SUM(loss_asean + exp_asean) - 
                     SUM(loss_oth + exp_oth)) AS net_direct,
                     SUM(inw_grs_loss_auth + inw_grs_exp_auth) AS inw_auth, 
                     SUM(inw_grs_loss_asean + inw_grs_exp_asean) AS inw_asean, 
                     SUM(inw_grs_loss_oth + inw_grs_exp_oth) AS inw_oth, 
                     SUM(ret_loss_auth + ret_exp_auth) AS retced_auth, 
                     SUM(ret_loss_asean + ret_exp_asean) AS retced_asean, 
                     SUM(ret_loss_oth + ret_exp_oth) AS retced_oth,
                     --0 AS net_written,  --marco - modified hard coded value
                     (SUM(gross_loss + gross_exp) - 
                     SUM(loss_auth + exp_auth) - 
                     SUM(loss_asean + exp_asean) - 
                     SUM(loss_oth + exp_oth) +
                     SUM(inw_grs_loss_auth + inw_grs_exp_auth) + 
                     SUM(inw_grs_loss_asean + inw_grs_exp_asean) + 
                     SUM(inw_grs_loss_oth + inw_grs_exp_oth) - 
                     SUM(ret_loss_auth + ret_exp_auth) - 
                     SUM(ret_loss_asean + ret_exp_asean) - 
                     SUM(ret_loss_oth + ret_exp_oth)) AS net_written,
                     'Losses'||chr(10)||'Paid on'||chr(10)||'Direct'||chr(10)||'Business' AS direct_title ,
                     'LOSS RECOVERIES ON CEDED BUSINESS' AS cedgroup_title,
                     'Net Losses'||chr(10)||'Paid on'||chr(10)||'Direct'||chr(10)||'Business' as netdirect_title,
                     'LOSSES ON ASSUMED BUSINESS' as assumed_title,
                     'LOSS RECOVERIES ON RETROCEDED BUSINESS' as retroceded_title,
                     chr(10)||chr(10)||'Net Losses'||chr(10)||'Paid' as netwritten_title,
                     'RECAPITULATION II - LOSSES PAID AND INCURRED' as subtitle,
                     'Claim No.' as pol_title
                FROM giac_recap_losspd_summ_ext
                WHERE giac_recap_losspd_summ_ext.ROWTITLE = p_row_title
                GROUP BY get_recap_claim_no(claim_id)
        )
        LOOP
            v_rec.pol_no := a.pol_no;
            v_rec.ceded_auth := a.ceded_auth;
            v_rec.ceded_asean := a.ceded_asean;
            v_rec.ceded_oth := a.ceded_oth;
            v_rec.net_direct := a.net_direct;
            v_rec.direct_prem := a.direct_col;
            v_rec.inw_auth := a.inw_auth;
            v_rec.inw_asean := a.inw_asean;
            v_rec.inw_oth := a.inw_oth;
            v_rec.retced_auth := a.retced_auth;
            v_rec.retced_asean := a.retced_asean;
            v_rec.retced_oth := a.retced_oth;
            v_rec.net_written := a.net_written;
            v_rec.direct_title := a.direct_title;
            v_rec.cedgroup_title := a.cedgroup_title;
            v_rec.netdirect_title := a.netdirect_title;
            v_rec.assumed_title := a.assumed_title;
            v_rec.retroceded_title := a.retroceded_title;
            v_rec.netwritten_title := a.netwritten_title;
            v_rec.subtitle := a.subtitle;
            v_rec.pol_title := a.pol_title;
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
            v_rec.rep_title := a.rep_title;
            v_rec.dtl_sub_title := a.dtl_sub_title;
            PIPE ROW (v_rec);
            
        END LOOP;
        if v_rec.company_name is null then
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
             PIPE ROW (v_rec);
        end if;
    elsif (p_report_type = 'OSLOSS') then
         FOR a IN(
             SELECT 'ANNUAL STATEMENT FOR THE YEAR ENDED DECEMBER 31, '||P_DATE2||' OF THE '|| giacp.v('COMPANY_NAME') as rep_title,
                    'Details for Line Of Business: '|| p_row_title as dtl_sub_title,
                    get_recap_claim_no(claim_id) AS pol_no,
                    SUM(gross_loss + gross_exp)        AS direct_col,
                    SUM(loss_auth + exp_auth) AS ceded_auth, 
                    SUM(loss_asean + exp_asean) AS ceded_asean, 
                    SUM(loss_oth + exp_oth) AS ceded_oth,
                    --0 AS net_direct, --marco - modified hard coded value
                    (SUM(gross_loss + gross_exp) - 
                     SUM(loss_auth + exp_auth) -  
                     SUM(loss_asean + exp_asean) - 
                     SUM(loss_oth + exp_oth)) AS net_direct,
                     SUM(inw_grs_loss_auth + inw_grs_exp_auth) AS inw_auth, 
                     SUM(inw_grs_loss_asean + inw_grs_exp_asean) AS inw_asean, 
                     SUM(inw_grs_loss_oth + inw_grs_exp_oth) AS inw_oth, 
                     SUM(ret_loss_auth + ret_exp_auth) AS retced_auth, 
                     SUM(ret_loss_asean + ret_exp_asean) AS retced_asean, 
                     SUM(ret_loss_oth + ret_exp_oth) AS retced_oth,
                     --0 AS net_written,  -- marco - modified hard coded value
                     (SUM(gross_loss + gross_exp) - 
                     SUM(loss_auth + exp_auth) - 
                     SUM(loss_asean + exp_asean) - 
                     SUM(loss_oth + exp_oth) +
                     SUM(inw_grs_loss_auth + inw_grs_exp_auth) + 
                     SUM(inw_grs_loss_asean + inw_grs_exp_asean) + 
                     SUM(inw_grs_loss_oth + inw_grs_exp_oth) - 
                     SUM(ret_loss_auth + ret_exp_auth) - 
                     SUM(ret_loss_asean + ret_exp_asean) - 
                     SUM(ret_loss_oth + ret_exp_oth)) AS net_written,
                     'Losses and'||chr(10)||'Claims Payable'||chr(10)||'on Direct'||chr(10)||'Business' AS direct_title ,
                     'LOSSES AND CLAIMS RECOVERABLE ON CEDED BUSINESS' AS cedgroup_title,
                     'Net Losses'||chr(10)||'Payable on'||chr(10)||'Direct'||chr(10)||'Business' as netdirect_title,
                     'LOSSES PAYABLE ON ASSUMED BUSINESS' as assumed_title,
                     'LOSSES AND CLAIMS RECOVERABLE ON RETROCEDED BUSINESSS' as retroceded_title,
                     chr(10)||chr(10)||'Net Losses'||chr(10)||'Paid' as netwritten_title,
                     'RECAPITULATION V - LOSSES AND CLAIMS PAYABLE' as subtitle,
                     'Claim No.' as pol_title
                FROM giac_recap_osloss_summ_ext
                WHERE giac_recap_osloss_summ_ext.ROWTITLE = p_row_title
                GROUP BY get_recap_claim_no(claim_id)
        )
        LOOP
            v_rec.pol_no := a.pol_no;
            v_rec.ceded_auth := a.ceded_auth;
            v_rec.ceded_asean := a.ceded_asean;
            v_rec.ceded_oth := a.ceded_oth;
            v_rec.net_direct := a.net_direct;
            v_rec.direct_prem := a.direct_col;
            v_rec.inw_auth := a.inw_auth;
            v_rec.inw_asean := a.inw_asean;
            v_rec.inw_oth := a.inw_oth;
            v_rec.retced_auth := a.retced_auth;
            v_rec.retced_asean := a.retced_asean;
            v_rec.retced_oth := a.retced_oth;
            v_rec.net_written := a.net_written;
            v_rec.direct_title := a.direct_title;
            v_rec.cedgroup_title := a.cedgroup_title;
            v_rec.netdirect_title := a.netdirect_title;
            v_rec.assumed_title := a.assumed_title;
            v_rec.retroceded_title := a.retroceded_title;
            v_rec.netwritten_title := a.netwritten_title;
            v_rec.subtitle := a.subtitle;
            v_rec.pol_title := a.pol_title;
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS'); 
            v_rec.rep_title := a.rep_title;
            v_rec.dtl_sub_title := a.dtl_sub_title;
            PIPE ROW (v_rec);
            
        END LOOP;
        if v_rec.company_name is null then
            v_rec.company_name := giacp.v('COMPANY_NAME');
            v_rec.company_address := giacp.v('COMPANY_ADDRESS');
             PIPE ROW (v_rec);
        end if;       
    end if;

        
   
END populate_giacr209a;


END;
/



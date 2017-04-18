CREATE OR REPLACE PACKAGE CPI.GICLS202_EXTRACTION_PKG AS
/*
** Created by   : MAC
** Date Created : 4/1/2013
** Descriptions : Created database package to solve discrepancy in the extraction of GICLS202 module.
                  Designed to be reused by GENIISYS WEB version.
                  Can handle extraction per claim, item, peril, intermediary, group seq no.
                  Includes function in getting parent intermediary, total premium amount and voucher and check number.
                  Includes function in checking reversals and close date.
                  Package is used in extracting Outstanding Losses, Paid amount, Recoveries and Claims Register.
*/
    PROCEDURE INITIALIZE_VARIABLES( p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
                                    p_session_id            gicl_res_brdrx_extr.session_id%TYPE,
                                    p_rep_name              gicl_res_brdrx_extr.extr_type%TYPE,     -- (1-Bordereaux or 2-Claims Register)
                                    p_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE,    -- (1-Outstanding or 2-Losses Paid)
                                    p_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE,   -- (1-Loss Date, 2-Claim File Date, 3-Booking Month)
                                    p_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE,-- (1-Loss, 2-Expense, 3-Loss+Expense)
                                    p_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE,       -- Reserve Tag (1 or 0)
                                    p_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE,   -- (1-Tran Date or 2-Posting Date)
                                    p_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Business Source (1 or 0) - under Bordereaux option
                                    p_per_issource          gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Issue Source (1 or 0) - under Bordereaux option
                                    p_per_line_subline      gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Bordereaux option
                                    p_per_policy            NUMBER,                                 -- Per Policy (1 or 0)- under Bordereaux option
                                    p_per_enrollee          NUMBER,                                 -- Per Enrollee (1 or 0)- under Bordereaux option
                                    p_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Claims Register option
                                    p_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Branch (1 or 0) - under Claims Register option
                                    p_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Intermediary (1 or 0) - under Claims Register option
                                    p_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE,  -- Per Loss Category (1 or 2) - under Claims Register option
                                    p_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE,     -- By Period From Date  
                                    p_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE,       -- By Period To Date
                                    p_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE,       -- As of Date
                                    p_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE,    -- Branch Parameter (1-Claim Iss Cd or 2-Policy Iss Cd)
                                    p_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE,  -- (1-Loss Date or 2-Claim File Date)
                                    p_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE, -- Net of Recovery (Y or N)
                                    p_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE,-- Net of Recovery From Date
                                    p_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE, -- Net of Recovery To Date
                                    p_date_option           NUMBER,                                 -- (1-By Period or 2-As Of)
                                    p_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE,       -- Line
                                    p_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline
                                    p_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,        -- Branch
                                    p_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,   -- Loss Category (Claims Register option only)
                                    p_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,      -- Peril
                                    p_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE,       -- Intermediary Number
                                    p_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE,       -- Line Code (Per Policy option only)
                                    p_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline Code (Per Policy option only)
                                    p_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE,        -- Issue Code (Per Policy option only)
                                    p_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE,    -- Issue Year (Per Policy option only)
                                    p_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE,    -- Policy Sequence Number (Per Policy option only)
                                    p_renew_no              gicl_res_brdrx_extr.renew_no%TYPE,      -- Renew Number (Per Policy option only)
                                    p_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE,      -- Enrollee Number (Per Enrollee option only)
                                    p_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE,  -- Control Type (Per Enrollee option only)
                                    p_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE -- Control Number (Per Enrollee option only)
                                   ); 
    
    v_user_id               gicl_res_brdrx_extr.user_id%TYPE;
    v_session_id            gicl_res_brdrx_extr.session_id%TYPE;
    v_rep_name              gicl_res_brdrx_extr.extr_type%TYPE;     -- (1-Bordereaux or 2-Claims Register)
    v_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE;    -- (1-Outstanding or 2-Losses Paid)
    v_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE;   -- (1-Loss Date; 2-Claim File Date; 3-Booking Month)
    v_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE;-- (1-Loss; 2-Expense; 3-Loss+Expense)
    v_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE;       -- Reserve Tag (1 or 0)
    v_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE;   -- (1-Tran Date or 2-Posting Date)
    v_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE;      -- Per Business Source (1 or 0) - under Bordereaux option
    v_iss_break             gicl_res_brdrx_extr.iss_cd_tag%TYPE;    -- Per Issue Source (1 or 0) - under Bordereaux option
    v_subline_break         gicl_res_brdrx_extr.line_cd_tag%TYPE;   -- Per Line/Subline (1 or 0) - under Bordereaux option
    v_per_policy            NUMBER;                                 -- Per Policy (1 or 0)- under Bordereaux option
    v_per_enrollee          NUMBER;                                 -- Per Enrollee (1 or 0)- under Bordereaux option
    v_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE;   -- Per Line/Subline (1 or 0) - under Claims Register option
    v_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE;    -- Per Branch (1 or 0) - under Claims Register option
    v_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE;      -- Per Intermediary (1 or 0) - under Claims Register option
    v_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE;  -- Per Loss Category (1 or 2) - under Claims Register option
    v_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE;     -- By Period From Date  
    v_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE;       -- By Period To Date
    v_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE;       -- As of Date
    v_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE;    -- Branch Parameter (1-Claim Iss Cd or 2-Policy Iss Cd)
    v_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE;  -- (1-Loss Date or 2-Claim File Date)
    v_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE; -- (Y or N)
    v_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE;-- Net of Recovery From Date
    v_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE; -- Net of Recovery To Date
    v_date_option           NUMBER;                                 -- (1-By Period or 2-As Of)
    v_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE;       -- Line
    v_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE;    -- Subline
    v_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE;        -- Branch
    v_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE;    -- Loss Category (Claims Register option only)
    v_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE;      -- Peril
    v_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE;       -- Intermediary Number
    v_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE;       -- Line Code (Per Policy Option only)
    v_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE;    -- Subline Code (Per Policy Option only)
    v_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE;        -- Issue Code (Per Policy Option only)
    v_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE;    -- Issue Year (Per Policy Option only)
    v_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE;    -- Policy Sequence Number (Per Policy Option only)
    v_renew_no              gicl_res_brdrx_extr.renew_no%TYPE;      -- Renew Number (Per Policy Option only)
    v_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE;      -- Enrollee Number (Per Enrollee option only)
    v_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE;  -- Control Type (Per Enrollee option only)
    v_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE; -- Control Number (Per Enrollee option only)
    v_brdrx_record_id       gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
    v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    v_posted                VARCHAR2(1);
    
    PROCEDURE EXTRACT_ALL;
    
    PROCEDURE EXTRACT_DISTRIBUTION;
    
    FUNCTION GET_PARENT_INTM(p_intrmdry_intm_no IN giis_intermediary.intm_no%TYPE)
        RETURN NUMBER;
    
    FUNCTION GET_TOT_PREM_AMT(p_claim_id IN gicl_claims.claim_id%type,
                              p_item_no  IN gicl_item_peril.item_no%type,
                              p_peril_cd IN gicl_item_peril.peril_cd%type)
         RETURN NUMBER;
    
    FUNCTION CHECK_CLOSE_DATE1(p_brdrx_type IN NUMBER,
                               p_claim_id IN gicl_claims.claim_id%type,
                               p_item_no  IN gicl_item_peril.item_no%type,
                               p_peril_cd IN gicl_item_peril.peril_cd%type,
                               p_date     IN DATE)
         RETURN NUMBER;
    
    FUNCTION CHECK_CLOSE_DATE2(p_brdrx_type IN NUMBER,
                               p_claim_id IN gicl_claims.claim_id%type,
                               p_item_no  IN gicl_item_peril.item_no%type,
                               p_peril_cd IN gicl_item_peril.peril_cd%type,
                               p_date     IN DATE)
         RETURN NUMBER;
         
    FUNCTION GET_REVERSAL(p_tran_id          IN gicl_clm_res_hist.tran_id%TYPE,
                          p_from_date         IN DATE,
                          p_to_date           IN DATE,
                          p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE)     
        RETURN NUMBER;
        
    FUNCTION GET_VOUCHER_CHECK_NO(p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
                                  p_item_no           IN gicl_clm_res_hist.item_no%TYPE,
                                  p_peril_cd          IN gicl_clm_res_hist.peril_cd%TYPE,
                                  p_grouped_item_no   IN gicl_clm_res_hist.grouped_item_no%TYPE,
                                  p_dsp_from_date     IN DATE,
                                  p_dsp_to_date       IN DATE,
                                  p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                                  p_payee_type        IN VARCHAR)     
        RETURN VARCHAR;
    FUNCTION GET_GICLR209_DTL(p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
                              p_dsp_from_date     IN DATE,
                              p_dsp_to_date       IN DATE,
                              p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                              p_payee_type        IN VARCHAR,
                              p_type              IN VARCHAR)     
        RETURN VARCHAR;
        
    -- marco - 05.22.2015 - GENQA SR 4457
    PROCEDURE save_last_extract_params(
        p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
        p_session_id            gicl_res_brdrx_extr.session_id%TYPE,
        p_rep_name              gicl_res_brdrx_extr.extr_type%TYPE,
        p_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE,
        p_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE,
        p_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE,
        p_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE,
        p_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE,
        p_per_issource          gicl_res_brdrx_extr.iss_cd_tag%TYPE,
        p_per_line_subline      gicl_res_brdrx_extr.line_cd_tag%TYPE,
        p_per_policy            NUMBER,
        p_per_enrollee          NUMBER,
        p_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE,
        p_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE,
        p_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE,
        p_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE,
        p_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE,  
        p_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE,
        p_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE,
        p_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE,
        p_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE,
        p_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE,
        p_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE,
        p_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE,
        p_date_option           NUMBER,
        p_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE,
        p_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE,
        p_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,
        p_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,
        p_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,
        p_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE,
        p_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE,
        p_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE,
        p_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE,
        p_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE,
        p_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE,
        p_renew_no              gicl_res_brdrx_extr.renew_no%TYPE,
        p_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE,
        p_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE,
        p_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE
    );
END GICLS202_EXTRACTION_PKG; 
/


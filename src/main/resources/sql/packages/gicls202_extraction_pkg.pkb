CREATE OR REPLACE PACKAGE BODY CPI.gicls202_extraction_pkg
AS
/*
** Created by   : MAC
** Date Created : 4/1/2013
** Descriptions : Created database package to solve discrepancy in the extraction of GICLS202 module.
                  Designed to be reused by GENIISYS WEB version.
                  Can handle extraction per claim, item, peril, intermediary, group seq no.
                  Includes function in getting parent intermediary, total premium amount and voucher and check number.
                  Includes function in checking reversals and close date.
                  Package is used in extracting Outstanding Losses, Paid amount, Recoveries and Claims Register.
                  Modified package to exclude records already closed, withdrawn, denied, and cancelled if extracting Outstanding based on Loss Date or Claim File Date.
*/
   PROCEDURE INITIALIZE_VARIABLES( p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
                                    p_session_id            gicl_res_brdrx_extr.session_id%TYPE,
                                    p_rep_name              gicl_res_brdrx_extr.extr_type%TYPE,     -- (1-Bordereaux or 2-Claims Register)
                                    p_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE,    -- (1-Outstanding or 2-Losses Paid)
                                    p_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE,   -- (1-Loss Date, 2-Claim File Date, 3-Booking Month)
                                    p_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE,-- (1-Loss, 2-Expense, 3-Loss+Expense)
                                    p_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE,       -- Reserve Tag (1 or 0)
                                    p_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE,   -- (1-Tran Date or 2-Posting Date)
                                    p_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Intermediary (1 or 0) - under Claims Register option
                                    p_per_issource          gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Issue Source (1 or 0) - under Bordereaux option
                                    p_per_line_subline      gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Bordereaux option
                                    p_per_policy            NUMBER,                                 -- Per Policy (1 or 0)- under Bordereaux option
                                    p_per_enrollee          NUMBER,                                 -- Per Enrollee (1 or 0)- under Bordereaux option
                                    p_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Claims Register option
                                    p_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Branch (1 or 0) - under Claims Register option
                                    p_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Business Source (1 or 0) - under Bordereaux option 
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
                                   )
   IS
   BEGIN
      --reset variables
      v_user_id := NULL;
      v_session_id := NULL;
      v_rep_name := NULL;
      v_brdrx_type := NULL;
      v_brdrx_date_option := NULL;
      v_brdrx_option := NULL;
      v_dsp_gross_tag := NULL;
      v_paid_date_option := NULL;
      v_per_intermediary := NULL;
      v_iss_break := NULL;
      v_subline_break := NULL;
      v_per_policy := NULL;
      v_per_enrollee := NULL;
      v_per_line := NULL;
      v_per_iss := NULL;
      v_per_buss := NULL;
      v_per_loss_cat := NULL;
      v_dsp_from_date := NULL;
      v_dsp_to_date := NULL;
      v_dsp_as_of_date := NULL;
      v_branch_option := NULL;
      v_reg_button := NULL;
      v_net_rcvry_chkbx := NULL;
      v_dsp_rcvry_from_date := NULL;
      v_dsp_rcvry_to_date := NULL;
      v_date_option := NULL;
      v_dsp_line_cd := NULL;
      v_dsp_subline_cd := NULL;
      v_dsp_iss_cd := NULL;
      v_dsp_loss_cat_cd := NULL;
      v_dsp_peril_cd := NULL;
      v_dsp_intm_no := NULL;
      v_dsp_line_cd2 := NULL;
      v_dsp_subline_cd2 := NULL;
      v_dsp_iss_cd2 := NULL;
      v_issue_yy := NULL;
      v_pol_seq_no := NULL;
      v_renew_no := NULL;
      v_dsp_enrollee := NULL;
      v_dsp_control_type := NULL;
      v_dsp_control_number := NULL;
      v_brdrx_ds_record_id := NULL;
      v_brdrx_rids_record_id := NULL;
      v_posted := NULL;
      v_user_id := p_user_id;
      v_session_id := p_session_id;
      v_rep_name := p_rep_name;
      v_dsp_from_date := p_dsp_from_date;
      v_dsp_to_date := p_dsp_to_date;
      v_branch_option := p_branch_option;
      v_date_option := p_date_option;
      v_dsp_line_cd := p_dsp_line_cd;
      v_dsp_subline_cd := p_dsp_subline_cd;
      v_dsp_iss_cd := p_dsp_iss_cd;
      v_dsp_peril_cd := p_dsp_peril_cd;
      v_net_rcvry_chkbx := 'N';
      v_brdrx_record_id := 0;
      v_brdrx_ds_record_id := 0;
      v_brdrx_rids_record_id := 0;

      IF v_rep_name = 1
      THEN                                                --Bordereaux option
         v_brdrx_type := p_brdrx_type;
         v_brdrx_option := p_brdrx_option;
         v_per_intermediary := p_per_intermediary;
         v_iss_break := p_per_issource;
         v_subline_break := p_per_line_subline;
         v_net_rcvry_chkbx := p_net_rcvry_chkbx;
         v_dsp_rcvry_from_date := p_dsp_rcvry_from_date;
         v_dsp_rcvry_to_date := p_dsp_rcvry_to_date;
         v_dsp_gross_tag := 0;
         v_per_policy := 0;
         v_per_enrollee := 0;

         IF v_brdrx_type = 1
         THEN                                            --Outstanding option
            v_brdrx_date_option := p_brdrx_date_option;
            v_dsp_gross_tag := p_dsp_gross_tag;
            v_dsp_as_of_date := p_dsp_as_of_date;
         ELSIF v_brdrx_type = 2
         THEN                                             --Losses Paid option
            v_paid_date_option := p_paid_date_option;
            v_per_policy := p_per_policy;
            v_per_enrollee := p_per_enrollee;

            IF v_per_policy = 1
            THEN                                        --Per Policy checkbox
               v_dsp_line_cd2 := p_dsp_line_cd2;
               v_dsp_subline_cd2 := p_dsp_subline_cd2;
               v_dsp_iss_cd2 := p_dsp_iss_cd2;
               v_issue_yy := p_issue_yy;
               v_pol_seq_no := p_pol_seq_no;
               v_renew_no := p_renew_no;
               v_branch_option := NULL;
               v_net_rcvry_chkbx := 'N';
               v_dsp_rcvry_from_date := NULL;
               v_dsp_rcvry_to_date := NULL;
               v_iss_break := 0;
               v_subline_break := 0;
               v_per_intermediary := 0;
            ELSIF v_per_enrollee = 1
            THEN
               v_dsp_enrollee := p_dsp_enrollee;
               v_dsp_control_type := p_dsp_control_type;
               v_dsp_control_number := p_dsp_control_number;
               v_branch_option := NULL;
               v_net_rcvry_chkbx := 'N';
               v_dsp_rcvry_from_date := NULL;
               v_dsp_rcvry_to_date := NULL;
               v_iss_break := 0;
               v_subline_break := 0;
               v_per_intermediary := 0;
            END IF;
         END IF;

         IF /*p_per_intermediary*/ p_per_buss = 1 -- apollo 07.23.2015 UCPB SR# 19674
         THEN
            v_dsp_intm_no := p_dsp_intm_no;
         END IF;
      ELSIF v_rep_name = 2
      THEN                                             --Claim Register option
         v_reg_button := p_reg_button;
         v_per_line := p_per_line;
         v_per_iss := p_per_iss;
         v_per_buss := p_per_buss;
         v_per_loss_cat := p_per_loss_cat;
         v_dsp_loss_cat_cd := p_dsp_loss_cat_cd;

         IF /*v_per_buss*/ p_per_intermediary = 1 -- apollo 07.23.2015 UCPB SR# 19674
         THEN
            v_dsp_intm_no := p_dsp_intm_no;
         END IF;
      END IF;
      gicls202_pkg.DELETE_DATA_GICLS202(p_user_id); --added by jerome 04/01/2015 for SR 18821
      gicls202_pkg.DELETE_RCVRY_DATA_GICLS202; --added by jerome 04/01/2015 for SR 18821
      
   END initialize_variables;

   PROCEDURE extract_all
   IS
      --getting outstanding amounts of Direct and Inward
      CURSOR claims_rec (
         p_user_id              gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id           gicl_res_brdrx_extr.session_id%TYPE,
         p_iss_break            NUMBER,
         p_subline_break        NUMBER,
         p_dsp_gross_tag        gicl_res_brdrx_extr.res_tag%TYPE,
         p_brdrx_type           gicl_res_brdrx_extr.brdrx_type%TYPE,
         p_paid_date_option     gicl_res_brdrx_extr.pd_date_opt%TYPE,
         p_brdrx_date_option    gicl_res_brdrx_extr.ol_date_opt%TYPE,
         p_branch_option        gicl_res_brdrx_extr.branch_opt%TYPE,
         p_brdrx_option         gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
         p_dsp_from_date        gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date          gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_dsp_as_of_date       gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_date_option          NUMBER,
         p_dsp_line_cd          gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd       gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd           gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd         gicl_res_brdrx_extr.peril_cd%TYPE,
--         p_per_intermediary     gicl_res_brdrx_extr.intm_tag%TYPE, -- apollo 07.23.2015 UCPB SR# 19674
         p_per_buss             NUMBER,
         p_per_policy           NUMBER,
         p_per_enrollee         NUMBER,
         p_dsp_line_cd2         gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd2      gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd2          gicl_res_brdrx_extr.iss_cd%TYPE,
         p_issue_yy             gicl_res_brdrx_extr.pol_iss_cd%TYPE,
         p_pol_seq_no           gicl_res_brdrx_extr.pol_seq_no%TYPE,
         p_renew_no             gicl_res_brdrx_extr.renew_no%TYPE,
         p_dsp_enrollee         gicl_res_brdrx_extr.enrollee%TYPE,
         p_dsp_control_type     gicl_res_brdrx_extr.control_type%TYPE,
         p_dsp_control_number   gicl_res_brdrx_extr.control_number%TYPE
      )
      IS
         SELECT p_session_id session_id, a.claim_id,
                --DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd,
                a.iss_cd iss_cd, -- edited by Kevin 12-22-2016
                --return RI Code if per intermediary else return 0
                DECODE (/*p_per_intermediary*/ p_per_buss, 1, a.ri_cd, 0) buss_source, -- apollo 07.23.2015 UCPB SR# 19674
                a.line_cd,
                DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year,
                a.assd_no, get_claim_number (a.claim_id) claim_no,
                (   a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (a.renew_no, '09'))
                ) policy_no,
                a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                a.expiry_date, c.ann_tsi_amt tsi_amt, 
                DECODE (p_brdrx_option, 2, 0, c.loss_reserve) loss_reserve,
                --return zero loss reserve if extraction is only for Expense
                DECODE (p_brdrx_option,
                        2, 0,
                        DECODE (p_dsp_gross_tag, 1, 0, c.losses_paid)
                       ) losses_paid,
--return zero losses paid if Reserve tag is tagged and if extraction is only for Expense
                DECODE (p_brdrx_option,
                        1, 0,
                        c.expense_reserve
                       ) expense_reserve,
                --return zero expense reserve if extraction is only for Loss
                DECODE (p_brdrx_option,
                        1, 0,
                        DECODE (p_dsp_gross_tag, 1, 0, c.expenses_paid)
                       ) expenses_paid,
--return zero expenses paid if Reserve tag is tagged and if extraction is only for Loss
                NVL (p_user_id, USER) user_id, SYSDATE last_update,
                c.grouped_item_no, c.clm_res_hist_id,
                DECODE (p_per_policy,
                        1, a.pol_iss_cd,
                        DECODE (p_per_enrollee, 1, a.pol_iss_cd, NULL)
                       ) pol_iss_cd,
                DECODE (p_per_policy,
                        1, a.issue_yy,
                        DECODE (p_per_enrollee, 1, a.issue_yy, NULL)
                       ) issue_yy,
                DECODE (p_per_policy,
                        1, a.pol_seq_no,
                        DECODE (p_per_enrollee, 1, a.pol_seq_no, NULL)
                       ) pol_seq_no,
                DECODE (p_per_policy,
                        1, a.renew_no,
                        DECODE (p_per_enrollee, 1, a.renew_no, NULL)
                       ) renew_no,
                c.grouped_item_title, c.control_cd, c.control_type_cd, c.intm_no
           FROM gicl_claims a,
                (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, d.intm_no,
                          (b.ann_tsi_amt * NVL (g.currency_rate, 1)
                          ) ann_tsi_amt,
--user currency rate in table GICL_CLM_ITEM in converting TSI by MAC 09/12/2013.
                          /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                          SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0))) loss_reserve,
                          SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                          SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0))) expense_reserve,
                          SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                          */
                          SUM
                             (DECODE
                                 (check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                  0, 0,             --return zero if not valid
                                  DECODE (a.dist_sw,
                                          'Y', NVL (a.convert_rate, 1)
                                           * NVL (a.loss_reserve, 0),
                                          0
                                         )
                                 )
                             * NVL (d.shr_intm_pct, 100) --Added by carlo 12/20/2016 SR 5878
                             / 100
                             ) loss_reserve,
                          SUM
                             (  DECODE
                                   (check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            NULL, NVL (a.convert_rate, 1)
                                             * NVL (a.losses_paid, 0),
                                            0
                                           )
                                   )
                              * NVL (d.shr_intm_pct, 100) --Added by carlo 12/20/2016 SR 5878
                              / 100
                              * get_reversal (a.tran_id,
                                              p_dsp_from_date,
                                              p_dsp_to_date,
                                              p_paid_date_option
                                             )
                             ) losses_paid,
                          SUM
                             (DECODE
                                 (check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                  0, 0,             --return zero if not valid
                                  DECODE (a.dist_sw,
                                          'Y', NVL (a.convert_rate, 1)
                                           * NVL (a.expense_reserve, 0),
                                          0
                                         )
                                 )
                             * NVL (d.shr_intm_pct, 100) --Added by carlo 12/20/2016 SR 5878
                             / 100
                             ) expense_reserve,
                          SUM
                             (  DECODE
                                   (check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            NULL, NVL (a.convert_rate, 1)
                                             * NVL (a.expenses_paid, 0),
                                            0
                                           )
                                   )
                              * get_reversal (a.tran_id,
                                              p_dsp_from_date,
                                              p_dsp_to_date,
                                              p_paid_date_option
                                             )
                             ) expenses_paid,
                          a.grouped_item_no, a.clm_res_hist_id, --include reserve / payment history in extract table by MAC 03/28/2014
                          DECODE (p_per_enrollee,
                                  1, e.grouped_item_title,
                                  NULL
                                 ) grouped_item_title,
                          DECODE (p_per_enrollee,
                                  1, e.control_cd,
                                  NULL
                                 ) control_cd,
                          DECODE (p_per_enrollee,
                                  1, e.control_type_cd,
                                  NULL
                                 ) control_type_cd
                     FROM gicl_clm_res_hist a,
                          gicl_item_peril b,
                          gicl_claims c,
                          gicl_intm_itmperil d,
                          (SELECT tran_id, tran_flag, posting_date
                             FROM giac_acctrans
                            WHERE p_brdrx_type = 2 AND tran_flag != 'D') d,
--retrieve records from table giac_acctrans if Losses Paid is selected by MAC 06/11/2013.
                          (SELECT claim_id, item_no, grouped_item_no,
                                  grouped_item_title, control_type_cd,
                                  control_cd
                             FROM gicl_accident_dtl
                            WHERE p_per_enrollee = 1) e,
--retrieve records from table gicl_accident_dtl if Per Enrollee is selected by MAC 06/11/2013.
                          (SELECT DISTINCT claim_id, item_no, peril_cd,
                                           clm_res_hist_id, grouped_item_no
                                      FROM gicl_reserve_ds
                                     WHERE NVL (negate_tag, 'N') <> 'Y'
                                       AND p_brdrx_type != 2
                           UNION
                           SELECT DISTINCT claim_id, item_no, peril_cd,
                                           NULL clm_res_hist_id,
                                           grouped_item_no
                                      FROM gicl_loss_exp_ds
                                     WHERE p_brdrx_type = 2) f,
                          gicl_clm_item g
--added table to get convert rate of TSI amount instead of using convert rate in gicl_clm_res_hist by MAC 09/12/2013
                 WHERE    a.claim_id = b.claim_id
                      AND A.CLAIM_ID = (DECODE(p_brdrx_type, 1, -- Dren 10.30.2015 SR-0020453 : Bordereaux Report Assured/Totals Error. - Start                            
                                               (SELECT V.CLAIM_ID 
                                                  FROM (SELECT CLAIM_ID, NVL(SUM(LOSS_RESERVE),0) LR, NVL(SUM(LOSSES_PAID),0) LP, NVL(SUM(EXPENSE_RESERVE),0) ER, NVL(SUM(EXPENSES_PAID),0) EP
                                                          FROM gicl_clm_res_hist
                                                         WHERE (DIST_SW != 'N' OR DIST_SW IS NULL)
                                                      GROUP BY CLAIM_ID) V 
                                                 WHERE ((LR-LP) > 0 or (ER-EP) > 0)
                                                   AND V.CLAIM_ID = A.CLAIM_ID), 2,
                                               (SELECT V.CLAIM_ID 
                                                  FROM (SELECT CLAIM_ID, NVL(SUM(LOSS_RESERVE),0) LR, NVL(SUM(LOSSES_PAID),0) LP, NVL(SUM(EXPENSE_RESERVE),0) ER, NVL(SUM(EXPENSES_PAID),0) EP
                                                          FROM gicl_clm_res_hist
                                                         WHERE TRAN_ID IS NOT NULL
                                                      GROUP BY CLAIM_ID) V                                         
                                                 WHERE V.CLAIM_ID = A.CLAIM_ID)
                                              )
                                       ) -- Dren 10.30.2015 SR-0020453 : Bordereaux Report Assured/Totals Error. - End                 
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND b.claim_id = d.claim_id(+)
                      AND b.item_no = d.item_no(+)
                      AND b.peril_cd = d.peril_cd(+)
                      AND DECODE (p_user_id,
                                  NULL, check_user_per_iss_cd (c.line_cd,
                                                               c.iss_cd,
                                                               'GICLS202'
                                                              ),
                                  --security in CS version
                                  check_user_per_iss_cd2 (c.line_cd,
                                                          c.iss_cd,
                                                          'GICLS202',
                                                          p_user_id
                                                         )
                                 ) = 1               --security in Web version
                      AND (   (DECODE
                                  (p_brdrx_date_option,
                                   3, TO_DATE
                                      (   NVL
                                             (a.booking_month,
                                              TO_CHAR (p_dsp_as_of_date,
                                                       'FMMONTH'
                                                      )
                                             )
                            --limit condition for Booking Month parameter only
                                       || ' 01, '
                                       || NVL (TO_CHAR (a.booking_year,
                                                        '0999'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'YYYY'
                                                       )
                                              ),
                                       'FMMONTH DD, YYYY'
                                      ),
                                   p_dsp_as_of_date
                                  ) <= p_dsp_as_of_date
                              )
                           OR DECODE (p_dsp_as_of_date, NULL, 1, 0) = 1
                          )
                      --always return true if As Of date parameter is null
                      AND (   (   (    TRUNC (NVL (a.date_paid,
                                                   p_dsp_as_of_date
                                                  )
                                             ) <= p_dsp_as_of_date
                                   AND p_date_option = 2
                                  )
                               OR 
                                  --condition in checking Date Paid if parameter date is As Of
                                  (    TRUNC (DECODE (p_paid_date_option,
                                                      1, a.date_paid,
                                                      2, d.posting_date,
                                                      NVL (a.date_paid,
                                                           p_dsp_to_date
                                                          )
                                                     )
                                             ) BETWEEN p_dsp_from_date
                                                   AND p_dsp_to_date
                                   AND p_date_option = 1
                                  )
                              )
--condition in checking Date Paid (Outstanding) or Tran Date/Posting Date (Losses Paid) if parameter date is By Period
                           --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                           OR (    DECODE (get_reversal (a.tran_id,
                                                         p_dsp_from_date,
                                                         p_dsp_to_date,
                                                         p_paid_date_option
                                                        ),
                                           1, 0,
                                           1
                                          ) = 1
                               AND p_brdrx_type = 2
                              )
                          )
                      AND (   DECODE (a.cancel_tag,
                                      'Y', TRUNC (a.cancel_date),
                                      --if record is already cancelled, check if cancellation happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                                      DECODE (p_date_option,
                                              1, (p_dsp_to_date + 1),
                                              2, (p_dsp_as_of_date + 1)
                                             )
                                     ) >
                                 DECODE (p_date_option,
                                         1, p_dsp_to_date,
                                         2, p_dsp_as_of_date
                                        )
                           --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                           OR (    DECODE (get_reversal (a.tran_id,
                                                         p_dsp_from_date,
                                                         p_dsp_to_date,
                                                         p_paid_date_option
                                                        ),
                                           1, 0,
                                           1
                                          ) = 1
                               AND p_brdrx_type = 2
                              )
                          )
                      --check if Close Date or Close Date2 happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                      /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                      AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                           OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                      */
                      AND (   DECODE
                                 (p_brdrx_option,
                                  2, 1,
                                  check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             )
                                 ) = 1
                           OR DECODE
                                 (p_brdrx_option,
                                  1, 1,
                                  check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             )
                                 ) = 1
                          )
                      AND b.peril_cd = NVL (p_dsp_peril_cd, b.peril_cd)
                      AND (   (a.tran_id IS NOT NULL AND p_brdrx_type = 2)
                           OR DECODE (p_brdrx_type, 1, 1, 0) = 1
                          )
                      --tran id should not be null if based on Losses Paid option else return true
                      AND (   (a.tran_id = d.tran_id AND p_brdrx_type = 2)
                           OR DECODE (p_brdrx_type, 1, 1, 0) = 1
                          )
                      AND a.tran_id = d.tran_id(+)
                      --AND ((d.tran_flag != 'D' AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran_flag should not be 'D' if based on Losses Paid option else return true
                      --if Per Policy
                      AND (   (    c.line_cd = NVL (p_dsp_line_cd2, c.line_cd)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      AND (   (    c.subline_cd =
                                         NVL (p_dsp_subline_cd2, c.subline_cd)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      AND (   (    c.pol_iss_cd =
                                             NVL (p_dsp_iss_cd2, c.pol_iss_cd)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      AND (   (    c.issue_yy = NVL (p_issue_yy, c.issue_yy)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      AND (   (    c.pol_seq_no =
                                              NVL (p_pol_seq_no, c.pol_seq_no)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      AND (   (    c.renew_no = NVL (p_renew_no, c.renew_no)
                               AND p_per_policy = 1
                              )
                           OR DECODE (p_per_policy, 0, 1, 0) = 1
                          )
                      --if Per Enrollee
                      AND a.claim_id = e.claim_id(+)
                      AND a.item_no = e.item_no(+)
                      AND a.grouped_item_no = e.grouped_item_no(+)
                      AND (   (    e.grouped_item_title IS NOT NULL
                               AND p_per_enrollee = 1
                              )
                           OR DECODE (p_per_enrollee, 0, 1, 0) = 1
                          )
                      AND (   (    e.grouped_item_title =
                                      NVL (p_dsp_enrollee,
                                           e.grouped_item_title
                                          )
                               AND p_per_enrollee = 1
                              )
                           OR DECODE (p_per_enrollee, 0, 1, 0) = 1
                          )
                      AND (   (    NVL (e.control_type_cd, 0) =
                                      NVL (p_dsp_control_type,
                                           NVL (e.control_type_cd, 0)
                                          )
                               AND p_per_enrollee = 1
                              )
                           OR DECODE (p_per_enrollee, 0, 1, 0) = 1
                          )
                      AND (   (    NVL (e.control_cd, 0) =
                                      NVL (p_dsp_control_number,
                                           NVL (e.control_cd, 0)
                                          )
                               AND p_per_enrollee = 1
                              )
                           OR DECODE (p_per_enrollee, 0, 1, 0) = 1
                          )
                      AND a.claim_id = f.claim_id
                      AND a.item_no = f.item_no
                      AND a.peril_cd = f.peril_cd
                      AND a.grouped_item_no = f.grouped_item_no
                      AND b.claim_id = g.claim_id
                      AND b.item_no = g.item_no
                 GROUP BY a.claim_id,
                          a.item_no,
                          a.peril_cd,
                          b.loss_cat_cd,
                          b.ann_tsi_amt,
                          d.intm_no,
                          NVL (g.currency_rate, 1),
                          a.grouped_item_no,                          
                          a.clm_res_hist_id, --include reserve / payment history in extract table by MAC 03/28/2014                           
                          DECODE (p_per_enrollee,
                                  1, e.grouped_item_title,
                                  NULL
                                 ),
                          DECODE (p_per_enrollee, 1, e.control_cd, NULL),
                          DECODE (p_per_enrollee, 1, e.control_type_cd, NULL)) c 
          WHERE 1 = 1
            --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all
            AND DECODE (/*p_per_intermediary*/ p_per_buss, -- apollo 07.23.2015 UCPB SR# 19674
                        1, a.pol_iss_cd,
                        NVL (giacp.v ('RI_ISS_CD'), 1)
                       ) = NVL (giacp.v ('RI_ISS_CD'), 1)
            AND (   (    DECODE (p_brdrx_date_option,
                                 1, TRUNC (a.dsp_loss_date),
                                 2, TRUNC (a.clm_file_date)
                                ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                     AND p_date_option = 1
                    )
                 OR 
--check if Loss Date or Claim file date is between From and To Date parameters
                    (    DECODE (p_brdrx_date_option,
                                 1, TRUNC (a.dsp_loss_date),
                                 2, TRUNC (a.clm_file_date)
                                ) <= p_dsp_as_of_date
                     AND p_date_option = 2
                    )
                 OR 
--check if Loss Date or Claim file date is less than or equal As Of Date parameter
                    (DECODE (p_brdrx_date_option, 3, 1, NULL, 1, 0) = 1)
                )
            --always return true if extraction is based on Booking Month or Losses Paid
            AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
            AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
            AND a.claim_id = c.claim_id
            AND DECODE
                   (p_user_id,
                    NULL, check_user_per_iss_cd (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS202'
                                                ),    --security in CS version
                    check_user_per_iss_cd2 (a.line_cd,
                                            a.iss_cd,
                                            'GICLS202',
                                            p_user_id
                                           )
                   ) = 1                             --security in Web version
            AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                   NVL (p_dsp_iss_cd,
                        DECODE (p_branch_option,
                                1, a.iss_cd,
                                2, a.pol_iss_cd,
                                1
                               )
                       )
            AND (   (    (     DECODE (p_brdrx_option, 2, 0, c.loss_reserve)
                             - DECODE (p_brdrx_option,
                                       2, 0,
                                       DECODE (p_dsp_gross_tag,
                                               1, 0,
                                               c.losses_paid
                                              )
                                       --) > 0 commented by aliza g. 03/31/2015 due to payment not being credited on os report
                                      ) != 0
                          OR   DECODE (p_brdrx_option,
                                       1, 0,
                                       c.expense_reserve
                                      )
                             - DECODE (p_brdrx_option,
                                       1, 0,
                                       DECODE (p_dsp_gross_tag,
                                               1, 0,
                                               c.expenses_paid
                                              )
                                      --) > 0 commented by aliza g. 03/31/2015 due to payment not being credited on os report
                                      ) != 0 --added by aliza g. 03/31/2015 due to payment not being credited on os report
                         )
                     AND p_brdrx_type = 1
                    )                                        --for Outstanding
                 OR (    (   DECODE (p_brdrx_option, 2, 0, c.losses_paid) != 0
                          OR DECODE (p_brdrx_option, 1, 0, c.expenses_paid) !=
                                                                             0
                         )
                     AND p_brdrx_type = 2
                    )
                );                                           --for Losses Paid

      --getting outstanding amounts per intermediary of Direct
      CURSOR claims_intm (
         p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
         p_iss_break           NUMBER,
         p_subline_break       NUMBER,
         p_dsp_gross_tag       gicl_res_brdrx_extr.res_tag%TYPE,
         p_brdrx_type          gicl_res_brdrx_extr.brdrx_type%TYPE,
         p_paid_date_option    gicl_res_brdrx_extr.pd_date_opt%TYPE,
         p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
         p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
         p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
         p_dsp_from_date       gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date         gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_date_option         NUMBER,
         p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
         p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE
      )
      IS
         SELECT p_session_id session_id, a.claim_id,
                DECODE (p_iss_break, 1, a.iss_cd, 0, 'DI') iss_cd,
                
                --return parent intermediary number if per intermediary
                get_parent_intm (c.intm_no) buss_source, a.line_cd,
                DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year,
                a.assd_no, get_claim_number (a.claim_id) claim_no,
                (   a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (a.renew_no, '09'))
                ) policy_no,
                a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                a.expiry_date, c.ann_tsi_amt tsi_amt, c.intm_no,
                DECODE (p_brdrx_option, 2, 0, c.loss_reserve) loss_reserve,
                
                --return zero loss reserve if extraction is only for Expense
                DECODE (p_brdrx_option,
                        2, 0,
                        DECODE (p_dsp_gross_tag, 1, 0, c.losses_paid)
                       ) losses_paid,
                
--return zero losses paid if Reserve tag is tagged and if extraction is only for Expense
                DECODE (p_brdrx_option,
                        1, 0,
                        c.expense_reserve
                       ) expense_reserve,
                
                --return zero expense reserve if extraction is only for Loss
                DECODE (p_brdrx_option,
                        1, 0,
                        DECODE (p_dsp_gross_tag, 1, 0, c.expenses_paid)
                       ) expenses_paid,
                
--return zero expenses paid if Reserve tag is tagged and if extraction is only for Loss
                NVL (p_user_id, USER) user_id, SYSDATE last_update,
                c.grouped_item_no, c.clm_res_hist_id
           FROM gicl_claims a,
                (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                          d.intm_no, NVL (d.shr_intm_pct, 100),
                          (  b.ann_tsi_amt
                           * NVL (d.shr_intm_pct, 100)
                           / 100
                           * NVL (g.currency_rate, 1)
                          ) ann_tsi_amt,
                          
--user currency rate in table GICL_CLM_ITEM in converting TSI by MAC 09/12/2013.

                          /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                          SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100) loss_reserve,
                          SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                          SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(\, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) *  NVL(d.shr_intm_pct,100)/100) expense_reserve,
                          SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                 DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                          */
                          SUM
                             (  DECODE
                                   (check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            'Y', NVL (a.convert_rate, 1)
                                             * NVL (a.loss_reserve, 0),
                                            0
                                           )
                                   )
                              * NVL (d.shr_intm_pct, 100)
                              / 100
                             ) loss_reserve,
                          SUM
                             (  DECODE
                                   (check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            NULL, NVL (a.convert_rate, 1)
                                             * NVL (a.losses_paid, 0),
                                            0
                                           )
                                   )
                              * NVL (d.shr_intm_pct, 100)
                              / 100
                              * get_reversal (a.tran_id,
                                              p_dsp_from_date,
                                              p_dsp_to_date,
                                              p_paid_date_option
                                             )
                             ) losses_paid,
                          SUM
                             (  DECODE
                                   (check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            'Y', NVL (a.convert_rate, 1)
                                             * NVL (a.expense_reserve, 0),
                                            0
                                           )
                                   )
                              * NVL (d.shr_intm_pct, 100)
                              / 100
                             ) expense_reserve,
                          SUM
                             (  DECODE
                                   (check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             ),
                                    0, 0,           --return zero if not valid
                                    DECODE (a.dist_sw,
                                            NULL, NVL (a.convert_rate, 1)
                                             * NVL (a.expenses_paid, 0),
                                            0
                                           )
                                   )
                              * NVL (d.shr_intm_pct, 100)
                              / 100
                              * get_reversal (a.tran_id,
                                              p_dsp_from_date,
                                              p_dsp_to_date,
                                              p_paid_date_option
                                             )
                             ) expenses_paid,
                          a.grouped_item_no, a.clm_res_hist_id --include reserve / payment history in extract table by MAC 03/28/2014
                     FROM gicl_clm_res_hist a,
                          gicl_item_peril b,
                          gicl_claims c,
                          gicl_intm_itmperil d,
                          (SELECT tran_id, tran_flag, posting_date
                             FROM giac_acctrans
                            WHERE p_brdrx_type = 2 AND tran_flag != 'D') e,
                          
--retrieve records from table giac_acctrans if Losses Paid is selected by MAC 06/11/2013.
                          (SELECT DISTINCT claim_id, item_no, peril_cd,
                                           clm_res_hist_id, grouped_item_no
                                      FROM gicl_reserve_ds
                                     WHERE NVL (negate_tag, 'N') <> 'Y'
                                       AND p_brdrx_type != 2
                           UNION
                           SELECT DISTINCT claim_id, item_no, peril_cd,
                                           NULL clm_res_hist_id,
                                           grouped_item_no
                                      FROM gicl_loss_exp_ds
                                     WHERE p_brdrx_type = 2) f,
                          gicl_clm_item g
--added table to get convert rate of TSI amount instead of using convert rate in gicl_clm_res_hist by MAC 09/12/2013
                 WHERE    a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND b.claim_id = d.claim_id(+)
                      AND b.item_no = d.item_no(+)
                      AND b.peril_cd = d.peril_cd(+)
                      AND DECODE (p_user_id,
                                  NULL, check_user_per_iss_cd (c.line_cd,
                                                               c.iss_cd,
                                                               'GICLS202'
                                                              ),
                                  --security in CS version
                                  check_user_per_iss_cd2 (c.line_cd,
                                                          c.iss_cd,
                                                          'GICLS202',
                                                          p_user_id
                                                         )
                                 ) = 1               --security in Web version
                      AND (   (DECODE
                                  (p_brdrx_date_option,
                                   3, TO_DATE
                                      (   NVL
                                             (a.booking_month,
                                              TO_CHAR (p_dsp_as_of_date,
                                                       'FMMONTH'
                                                      )
                                             )
                            --limit condition for Booking Month parameter only
                                       || ' 01, '
                                       || NVL (TO_CHAR (a.booking_year,
                                                        '0999'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'YYYY'
                                                       )
                                              ),
                                       'FMMONTH DD, YYYY'
                                      ),
                                   p_dsp_as_of_date
                                  ) <= p_dsp_as_of_date
                              )
                           OR DECODE (p_dsp_as_of_date, NULL, 1, 0) = 1
                          )
                      --always return true if As Of date parameter is null
                      AND (   (   (    TRUNC (NVL (a.date_paid,
                                                   p_dsp_as_of_date
                                                  )
                                             ) <= p_dsp_as_of_date
                                   AND p_date_option = 2
                                  )
                               OR 
                                  --condition in checking Date Paid if parameter date is As Of
                                  (    TRUNC (DECODE (p_paid_date_option,
                                                      1, a.date_paid,
                                                      2, e.posting_date,
                                                      NVL (a.date_paid,
                                                           p_dsp_to_date
                                                          )
                                                     )
                                             ) BETWEEN p_dsp_from_date
                                                   AND p_dsp_to_date
                                   AND p_date_option = 1
                                  )
                              )
--condition in checking Date Paid (Outstanding) or Tran Date/Posting Date (Losses Paid) if parameter date is By Period
                           --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                           OR (    DECODE (get_reversal (a.tran_id,
                                                         p_dsp_from_date,
                                                         p_dsp_to_date,
                                                         p_paid_date_option
                                                        ),
                                           1, 0,
                                           1
                                          ) = 1
                               AND p_brdrx_type = 2
                              )
                          )
                      AND (   DECODE (a.cancel_tag,
                                      'Y', TRUNC (a.cancel_date),
                                      --if record is already cancelled, check if cancellation happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                                      DECODE (p_date_option,
                                              1, (p_dsp_to_date + 1),
                                              2, (p_dsp_as_of_date + 1)
                                             )
                                     ) >
                                 DECODE (p_date_option,
                                         1, p_dsp_to_date,
                                         2, p_dsp_as_of_date
                                        )
                           --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                           OR (    DECODE (get_reversal (a.tran_id,
                                                         p_dsp_from_date,
                                                         p_dsp_to_date,
                                                         p_paid_date_option
                                                        ),
                                           1, 0,
                                           1
                                          ) = 1
                               AND p_brdrx_type = 2
                              )
                          )
                      --check if Close Date or Close Date2 happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                      /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                          AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                          OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                      */
                      AND (   DECODE
                                 (p_brdrx_option,
                                  2, 1,
                                  check_close_date1
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             )
                                 ) = 1
                           OR DECODE
                                 (p_brdrx_option,
                                  1, 1,
                                  check_close_date2
                                             (p_brdrx_type,
                                              a.claim_id,
                                              a.item_no,
                                              a.peril_cd,
                                              DECODE (p_brdrx_type,
                                                      1, SYSDATE,
                                                      DECODE (p_date_option,
                                                              1, p_dsp_to_date,
                                                              2, p_dsp_as_of_date
                                                             )
                                                     )
                                             )
                                 ) = 1
                          )
                      AND b.peril_cd = NVL (p_dsp_peril_cd, b.peril_cd)
                      AND DECODE (p_dsp_intm_no, NULL, 1, d.intm_no) =
                                                        NVL (p_dsp_intm_no, 1)
                      AND (   (a.tran_id IS NOT NULL AND p_brdrx_type = 2)
                           OR DECODE (p_brdrx_type, 1, 1, 0) = 1
                          )
                      --tran id should not be null if based on Losses Paid option else return true
                      AND (   (a.tran_id = e.tran_id AND p_brdrx_type = 2)
                           OR DECODE (p_brdrx_type, 1, 1, 0) = 1
                          )
                      --AND ((e.tran_flag != 'D' AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran_flag should not be 'D' if based on Losses Paid option else return true
                      AND a.tran_id = e.tran_id(+)
                      AND a.claim_id = f.claim_id
                      AND a.item_no = f.item_no
                      AND a.peril_cd = f.peril_cd
                      AND a.grouped_item_no = f.grouped_item_no
                      AND b.claim_id = g.claim_id
                      AND b.item_no = g.item_no
                 GROUP BY a.claim_id,
                          a.item_no,
                          a.peril_cd,
                          b.loss_cat_cd,
                          d.intm_no,
                          NVL (d.shr_intm_pct, 100),
                          b.ann_tsi_amt,
                          NVL (g.currency_rate, 1),
                          a.grouped_item_no,
                          a.clm_res_hist_id) c --include reserve / payment history in extract table by MAC 03/28/2014
          WHERE 1 = 1
            --select all records which policy issue code is not equal to RI
            AND a.pol_iss_cd != NVL (giacp.v ('RI_ISS_CD'), 1)
            AND (   (    DECODE (p_brdrx_date_option,
                                 1, TRUNC (a.dsp_loss_date),
                                 2, TRUNC (a.clm_file_date)
                                ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                     AND p_date_option = 1
                    )
                 OR 
--check if Loss Date or Claim file date is between From and To Date parameters
                    (    DECODE (p_brdrx_date_option,
                                 1, TRUNC (a.dsp_loss_date),
                                 2, TRUNC (a.clm_file_date)
                                ) <= p_dsp_as_of_date
                     AND p_date_option = 2
                    )
                 OR 
--check if Loss Date or Claim file date is less than or equal As Of Date parameter
                    (DECODE (p_brdrx_date_option, 3, 1, NULL, 1, 0) = 1)
                )
            --always return true if extraction is based on Booking Month or Losses Paid
            AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
            AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
            AND a.claim_id = c.claim_id
            AND DECODE
                   (p_user_id,
                    NULL, check_user_per_iss_cd (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS202'
                                                ),    --security in CS version
                    check_user_per_iss_cd2 (a.line_cd,
                                            a.iss_cd,
                                            'GICLS202',
                                            p_user_id
                                           )
                   ) = 1                             --security in Web version
            AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                   NVL (p_dsp_iss_cd,
                        DECODE (p_branch_option,
                                1, a.iss_cd,
                                2, a.pol_iss_cd,
                                1
                               )
                       )
            AND (   (    (     DECODE (p_brdrx_option, 2, 0, c.loss_reserve)
                             - DECODE (p_brdrx_option,
                                       2, 0,
                                       DECODE (p_dsp_gross_tag,
                                               1, 0,
                                               c.losses_paid
                                              )
                                      ) > 0
                          OR   DECODE (p_brdrx_option,
                                       1, 0,
                                       c.expense_reserve
                                      )
                             - DECODE (p_brdrx_option,
                                       1, 0,
                                       DECODE (p_dsp_gross_tag,
                                               1, 0,
                                               c.expenses_paid
                                              )
                                      ) > 0
                         )
                     AND p_brdrx_type = 1
                    )                                        --for Outstanding
                 OR (    (   DECODE (p_brdrx_option, 2, 0, c.losses_paid) != 0
                          OR DECODE (p_brdrx_option, 1, 0, c.expenses_paid) !=
                                                                             0
                         )
                     AND p_brdrx_type = 2
                    )
                );                                           --for Losses Paid

      --getting outstanding amounts based on Batch OS
      CURSOR claims_take_up (
         p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
         p_iss_break           NUMBER,
         p_subline_break       NUMBER,
         p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
         p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
         p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
         p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_date_option         NUMBER,
         p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
         p_posted              VARCHAR2,
         p_per_buss            NUMBER
--         p_per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE -- apollo 07.23.2015 UCPB SR# 19674
      --added parameter by MAC 06/08/2013.
      )
      IS
         SELECT p_session_id session_id, a.claim_id,
                DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd,
                
                --return RI Code if per intermediary else return 0
                0 buss_source, a.line_cd,
                DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year,
                a.assd_no, get_claim_number (a.claim_id) claim_no,
                (   a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (a.renew_no, '09'))
                ) policy_no,
                a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                a.expiry_date, c.ann_tsi_amt tsi_amt,
                DECODE (p_brdrx_option, 2, 0, c.os_loss) os_loss,
                
                --return zero os loss if extraction is only for Expense
                DECODE (p_brdrx_option, 1, 0, c.os_expense) os_exp,
                
                --return zero os expense if extraction is only for Loss
                NVL (p_user_id, USER) user_id, SYSDATE last_update,
                c.grouped_item_no, c.clm_res_hist_id
           FROM gicl_claims a,
                (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                        (b.ann_tsi_amt * NVL (a.convert_rate, 1)
                        ) ann_tsi_amt,
                        d.os_loss
/** NVL (a.convert_rate, 1)*/
--expense and loss in gicl_take_up_hist is already in local currency mlachica 02172014
                                                                      os_loss,
                        
                        --convert Loss to local currency by MAC 09/17/2013.
                        d.os_expense
/** NVL (a.convert_rate, 1)*/
--expense and loss in gicl_take_up_hist is already in local currency mlachica 02172014
                                                                   os_expense,
                        
                        --convert Expense to local currency by MAC 09/17/2013.
                        a.grouped_item_no, a.clm_res_hist_id
                   FROM gicl_clm_res_hist a,
                        gicl_item_peril b,
                        gicl_claims c,
                        gicl_take_up_hist d,
                        giac_acctrans e
                  WHERE a.claim_id = b.claim_id
                    AND a.item_no = b.item_no
                    AND a.peril_cd = b.peril_cd
                    AND a.claim_id = c.claim_id
                    AND a.claim_id = d.claim_id
                    AND a.clm_res_hist_id = d.clm_res_hist_id
                    AND d.acct_tran_id = e.tran_id
                    AND DECODE (p_user_id,
                                NULL, check_user_per_iss_cd (c.line_cd,
                                                             c.iss_cd,
                                                             'GICLS202'
                                                            ),
                                --security in CS version
                                check_user_per_iss_cd2 (c.line_cd,
                                                        c.iss_cd,
                                                        'GICLS202',
                                                        p_user_id
                                                       )
                               ) = 1                 --security in Web version
                    AND DECODE
                           (p_brdrx_date_option,
                            3, 
/*TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
|| ' 01, '
|| NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY')
*/
--replaced the commented code with below; as of booking date will consider the date of the takeup in gicl_take_up_hist
--and not the booking month in gicl_clm_res_hist
--mlachica 02142014
                            ( TO_DATE (   NVL (TO_CHAR (d.acct_date,
                                                        'FMMONTH'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'FMMONTH'
                                                       )
                                              )
                                       || ' 01, '
                                       || NVL (TO_CHAR (d.acct_date, 'YYYY'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'YYYY'
                                                       )
                                              ),
                                       'FMMONTH DD, YYYY'
                                      )
                             ),                            --mlachica 02142014
                            p_dsp_as_of_date
                           ) <= p_dsp_as_of_date
                    AND DECODE (p_posted,
                                'Y', TRUNC (e.posting_date),
                                TRUNC (e.tran_date)
                               ) = p_dsp_as_of_date
                    AND e.tran_flag = DECODE (p_posted, 'Y', 'P', 'C')
                    AND DECODE (p_brdrx_option,
                                1, d.os_loss,
                                2, d.os_expense,
                                (NVL (d.os_loss, 0) + NVL (d.os_expense, 0)
                                )
                               ) > 0) c
          WHERE
                --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all by MAC 06/08/2013.
                DECODE (/*p_per_intermediary*/ p_per_buss, -- apollo 07.23.2015 UCPB SR# 19674
                        1, a.pol_iss_cd,
                        NVL (giacp.v ('RI_ISS_CD'), 1)
                       ) = NVL (giacp.v ('RI_ISS_CD'), 1)
            AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
            AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
            AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
            AND a.claim_id = c.claim_id
            AND DECODE
                   (p_user_id,
                    NULL, check_user_per_iss_cd (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS202'
                                                ),    --security in CS version
                    check_user_per_iss_cd2 (a.line_cd,
                                            a.iss_cd,
                                            'GICLS202',
                                            p_user_id
                                           )
                   ) = 1                             --security in Web version
            AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                   NVL (p_dsp_iss_cd,
                        DECODE (p_branch_option,
                                1, a.iss_cd,
                                2, a.pol_iss_cd,
                                1
                               )
                       );

      --getting outstanding amounts per intermediary based on Batch OS
      CURSOR claims_take_up_intm (
         p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
         p_iss_break           NUMBER,
         p_subline_break       NUMBER,
         p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
         p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
         p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
         p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_date_option         NUMBER,
         p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
         p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE,
         p_posted              VARCHAR2
      )
      IS
         SELECT p_session_id session_id, a.claim_id,
                DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd,
                
                --return parent intermediary number
                get_parent_intm (c.intm_no) buss_source, a.line_cd,
                DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year,
                a.assd_no, get_claim_number (a.claim_id) claim_no,
                (   a.line_cd
                 || '-'
                 || a.subline_cd
                 || '-'
                 || a.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (a.renew_no, '09'))
                ) policy_no,
                a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                a.expiry_date, c.ann_tsi_amt tsi_amt, c.intm_no,
                DECODE (p_brdrx_option, 2, 0, c.os_loss) os_loss,
                
                --return zero os loss if extraction is only for Expense
                DECODE (p_brdrx_option, 1, 0, c.os_expense) os_exp,
                
                --return zero os expense if extraction is only for Loss
                NVL (p_user_id, USER) user_id, SYSDATE last_update,
                c.grouped_item_no, c.clm_res_hist_id
           FROM gicl_claims a,
                (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                        f.intm_no, NVL (f.shr_intm_pct, 100),
                        (  b.ann_tsi_amt
                         * NVL (f.shr_intm_pct, 100)
                         * NVL (a.convert_rate, 1)
                        ) ann_tsi_amt,
                        (d.os_loss * NVL (f.shr_intm_pct, 100) / 100
                        /** NVL (a.convert_rate, 1)*/--expense and loss in gicl_take_up_hist is already in local currency mlachica 02172014
                        ) os_loss,
                        
                        --convert Loss to local currency by MAC 09/17/2013.
                        (d.os_expense * NVL (f.shr_intm_pct, 100) / 100
                        /** NVL (a.convert_rate, 1)*/--expense and loss in gicl_take_up_hist is already in local currency mlachica 02172014
                        ) os_expense,
                        
                        --convert Expense to local currency by MAC 09/17/2013.
                        a.grouped_item_no, a.clm_res_hist_id
                   FROM gicl_clm_res_hist a,
                        gicl_item_peril b,
                        gicl_claims c,
                        gicl_take_up_hist d,
                        giac_acctrans e,
                        gicl_intm_itmperil f
                  WHERE a.claim_id = b.claim_id
                    AND a.item_no = b.item_no
                    AND a.peril_cd = b.peril_cd
                    AND a.claim_id = c.claim_id
                    AND a.claim_id = d.claim_id
                    AND a.clm_res_hist_id = d.clm_res_hist_id
                    AND d.acct_tran_id = e.tran_id
                    AND b.claim_id = f.claim_id(+)
                    AND b.item_no = f.item_no(+)
                    AND b.peril_cd = f.peril_cd(+)
                    AND DECODE (p_user_id,
                                NULL, check_user_per_iss_cd (c.line_cd,
                                                             c.iss_cd,
                                                             'GICLS202'
                                                            ),
                                --security in CS version
                                check_user_per_iss_cd2 (c.line_cd,
                                                        c.iss_cd,
                                                        'GICLS202',
                                                        p_user_id
                                                       )
                               ) = 1                 --security in Web version
                    AND DECODE
                           (p_brdrx_date_option,
                            3, 
/*TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
|| ' 01, '
|| NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY')
*/
--replaced the commented code with below; as of booking date will consider the date of the takeup in gicl_take_up_hist
--and not the booking month in gicl_clm_res_hist
--mlachica 02142014
                            ( TO_DATE (   NVL (TO_CHAR (d.acct_date,
                                                        'FMMONTH'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'FMMONTH'
                                                       )
                                              )
                                       || ' 01, '
                                       || NVL (TO_CHAR (d.acct_date, 'YYYY'),
                                               TO_CHAR (p_dsp_as_of_date,
                                                        'YYYY'
                                                       )
                                              ),
                                       'FMMONTH DD, YYYY'
                                      )
                             ),                            --mlachica 02142014
                            p_dsp_as_of_date
                           ) <= p_dsp_as_of_date
                    AND DECODE (p_posted,
                                'Y', TRUNC (e.posting_date),
                                TRUNC (e.tran_date)
                               ) = p_dsp_as_of_date
                    AND e.tran_flag = DECODE (p_posted, 'Y', 'P', 'C')
                    AND DECODE (p_dsp_intm_no, NULL, 1, f.intm_no) =
                                                        NVL (p_dsp_intm_no, 1)
                    AND DECODE (p_brdrx_option,
                                1, d.os_loss,
                                2, d.os_expense,
                                (NVL (d.os_loss, 0) + NVL (d.os_expense, 0)
                                )
                               ) > 0) c
          WHERE
                --iselect all records which policy issue code is not equal to RI by MAC 06/08/2013.
                a.pol_iss_cd != NVL (giacp.v ('RI_ISS_CD'), 1)
            AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
            AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
            AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
            AND a.claim_id = c.claim_id
            AND DECODE
                   (p_user_id,
                    NULL, check_user_per_iss_cd (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS202'
                                                ),    --security in CS version
                    check_user_per_iss_cd2 (a.line_cd,
                                            a.iss_cd,
                                            'GICLS202',
                                            p_user_id
                                           )
                   ) = 1                             --security in Web version
            AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                   NVL (p_dsp_iss_cd,
                        DECODE (p_branch_option,
                                1, a.iss_cd,
                                2, a.pol_iss_cd,
                                1
                               )
                       );

      --getting claims register of Direct and Inward
      CURSOR claims_reg (
         p_user_id            gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
         p_per_line           gicl_res_brdrx_extr.line_cd_tag%TYPE,
         p_per_iss            gicl_res_brdrx_extr.iss_cd_tag%TYPE,
         p_per_buss           gicl_res_brdrx_extr.intm_tag%TYPE,
         p_per_loss_cat       gicl_res_brdrx_extr.loss_cat_tag%TYPE,
         p_branch_option      gicl_res_brdrx_extr.branch_opt%TYPE,
         p_dsp_from_date      gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date        gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_dsp_line_cd        gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd     gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd         gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd       gicl_res_brdrx_extr.peril_cd%TYPE,
         p_per_intermediary   gicl_res_brdrx_extr.intm_tag%TYPE,
         p_reg_button         gicl_res_brdrx_extr.reg_date_opt%TYPE,
         p_dsp_loss_cat_cd    gicl_res_brdrx_extr.loss_cat_cd%TYPE,
         p_dsp_intm_no        gicl_res_brdrx_extr.intm_no%TYPE
      )
      IS
         SELECT   p_session_id session_id, a.claim_id, a.line_cd,
                  a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                  a.renew_no, a.iss_cd,
                  TO_NUMBER (TO_CHAR (a.loss_date, 'yyyy')) loss_year,
                  a.assd_no, get_claim_number (a.claim_id) claim_no,
                  (   a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09'))
                  ) policy_no,
                  a.clm_file_date, a.dsp_loss_date, a.loss_date,
                  a.pol_eff_date, a.expiry_date, a.clm_stat_cd, a.loss_cat_cd,
                  a.ri_cd, b.converted_recovered_amt,
                  get_tot_prem_amt (a.claim_id,
                                    c.item_no,
                                    c.peril_cd
                                   ) prem_amt,
                  c.item_no, c.peril_cd, c.ann_tsi_amt, c.loss_reserve,
                  c.losses_paid, c.expense_reserve, c.expenses_paid,
                  c.grouped_item_no, c.clm_res_hist_id,
                  DECODE (a.pol_iss_cd,
                          giacp.v ('RI_ISS_CD'), giacp.v ('RI_ISS_CD'),
                          NULL
                         ) intm_type,
                  DECODE (a.pol_iss_cd,
                          giacp.v ('RI_ISS_CD'), a.ri_cd,
                          NULL
                         ) buss_source,
                  NVL (p_user_id, USER) user_id, SYSDATE last_update
             FROM gicl_claims a,
                  (SELECT   claim_id,
                            SUM
                               (NVL (recovered_amt * convert_rate, 0)
                               ) converted_recovered_amt
                       FROM gicl_clm_recovery
                   GROUP BY claim_id) b,
                  (SELECT   b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                            NVL (a.convert_rate, 1) convert_rate,
                            (b.ann_tsi_amt * NVL (a.convert_rate, 1)
                            ) ann_tsi_amt,
                            SUM (DECODE (a.dist_sw,
                                         'Y', NVL (a.convert_rate, 1)
                                          * NVL (a.loss_reserve, 0),
                                         0
                                        )
                                ) loss_reserve,
                            SUM (DECODE (a.dist_sw,
                                         NULL, NVL (a.convert_rate, 1)
                                          * NVL (a.losses_paid, 0),
                                         0
                                        )
                                ) losses_paid,
                            SUM
                               (DECODE (a.dist_sw,
                                        'Y', NVL (a.convert_rate, 1)
                                         * NVL (a.expense_reserve, 0),
                                        0
                                       )
                               ) expense_reserve,
                            SUM (DECODE (a.dist_sw,
                                         NULL, NVL (a.convert_rate, 1)
                                          * NVL (a.expenses_paid, 0),
                                         0
                                        )
                                ) expenses_paid,
                            a.grouped_item_no, c.clm_res_hist_id
                       FROM gicl_clm_res_hist a,
                            gicl_item_peril b,
                            (SELECT DISTINCT claim_id, item_no, peril_cd,
                                             clm_res_hist_id, grouped_item_no
                                        FROM gicl_reserve_ds
                                       WHERE NVL (negate_tag, 'N') <> 'Y') c
                      WHERE a.peril_cd = b.peril_cd
                        AND a.item_no = b.item_no
                        AND a.claim_id = b.claim_id
                        AND NVL (a.dist_sw, 'Y') = 'Y'
                        AND b.loss_cat_cd =
                                        NVL (p_dsp_loss_cat_cd, b.loss_cat_cd)
                        AND a.claim_id = c.claim_id
                        AND a.item_no = c.item_no
                        AND a.peril_cd = c.peril_cd
                        AND a.grouped_item_no = c.grouped_item_no
                        AND DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), p_dsp_to_date + 1) > p_dsp_to_date --benjo 10.01.2015 GENQA-SR-4925
                   GROUP BY b.claim_id,
                            b.item_no,
                            b.peril_cd,
                            b.loss_cat_cd,
                            NVL (a.convert_rate, 1),
                            b.ann_tsi_amt,
                            a.grouped_item_no,
                            c.clm_res_hist_id) c
            WHERE 1 = 1
              AND b.claim_id(+) = a.claim_id
              AND a.claim_id = c.claim_id
              --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all
              AND DECODE (p_per_buss,
                          1, a.pol_iss_cd,
                          NVL (giacp.v ('RI_ISS_CD'), 1)
                         ) = NVL (giacp.v ('RI_ISS_CD'), 1)
              AND DECODE
                     (p_user_id,
                      NULL, check_user_per_iss_cd (a.line_cd,
                                                   a.iss_cd,
                                                   'GICLS202'
                                                  ),  --security in CS version
                      check_user_per_iss_cd2 (a.line_cd,
                                              a.iss_cd,
                                              'GICLS202',
                                              p_user_id
                                             )
                     ) = 1                           --security in Web version
              AND DECODE (p_reg_button,
                          1, TRUNC (a.dsp_loss_date),
                          2, TRUNC (a.clm_file_date)
                         ) BETWEEN p_dsp_from_date AND p_dsp_to_date
              AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
              AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
              AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
              AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                     NVL (p_dsp_iss_cd,
                          DECODE (p_branch_option,
                                  1, a.iss_cd,
                                  2, a.pol_iss_cd,
                                  1
                                 )
                         )
         ORDER BY a.claim_id;

      --getting claims register per intermediary of Direct
      CURSOR claims_reg_intm (
         p_user_id            gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
         p_per_line           gicl_res_brdrx_extr.line_cd_tag%TYPE,
         p_per_iss            gicl_res_brdrx_extr.iss_cd_tag%TYPE,
         p_per_buss           gicl_res_brdrx_extr.intm_tag%TYPE,
         p_per_loss_cat       gicl_res_brdrx_extr.loss_cat_tag%TYPE,
         p_branch_option      gicl_res_brdrx_extr.branch_opt%TYPE,
         p_dsp_from_date      gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date        gicl_res_brdrx_extr.TO_DATE%TYPE,
         p_dsp_line_cd        gicl_res_brdrx_extr.line_cd%TYPE,
         p_dsp_subline_cd     gicl_res_brdrx_extr.subline_cd%TYPE,
         p_dsp_iss_cd         gicl_res_brdrx_extr.iss_cd%TYPE,
         p_dsp_peril_cd       gicl_res_brdrx_extr.peril_cd%TYPE,
         p_per_intermediary   gicl_res_brdrx_extr.intm_tag%TYPE,
         p_reg_button         gicl_res_brdrx_extr.reg_date_opt%TYPE,
         p_dsp_loss_cat_cd    gicl_res_brdrx_extr.loss_cat_cd%TYPE,
         p_dsp_intm_no        gicl_res_brdrx_extr.intm_no%TYPE
      )
      IS
         SELECT   p_session_id session_id, a.claim_id, a.line_cd,
                  a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                  a.renew_no, a.iss_cd,
                  TO_NUMBER (TO_CHAR (a.loss_date, 'yyyy')) loss_year,
                  a.assd_no, get_claim_number (a.claim_id) claim_no,
                  (   a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09'))
                  ) policy_no,
                  a.clm_file_date, a.dsp_loss_date, a.loss_date,
                  a.pol_eff_date, a.expiry_date, a.clm_stat_cd, a.loss_cat_cd,
                  a.ri_cd,
                    b.converted_recovered_amt
                  * c.shr_intm_pct
                  / 100 converted_recovered_amt,
                    get_tot_prem_amt (a.claim_id,
                                      c.item_no,
                                      c.peril_cd
                                     )
                  * c.shr_intm_pct
                  / 100 prem_amt,
                  c.item_no, c.peril_cd, c.ann_tsi_amt, c.loss_reserve,
                  c.losses_paid, c.expense_reserve, c.expenses_paid,
                  c.grouped_item_no, c.clm_res_hist_id,
                  get_intm_type (get_parent_intm (c.intm_no)) intm_type,
                  get_parent_intm (c.intm_no) buss_source,
                  NVL (p_user_id, USER) user_id, SYSDATE last_update,
                  c.intm_no
             FROM gicl_claims a,
                  (SELECT   claim_id,
                            SUM
                               (NVL (recovered_amt * convert_rate, 0)
                               ) converted_recovered_amt
                       FROM gicl_clm_recovery
                   GROUP BY claim_id) b,
                  (SELECT   b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                            NVL (a.convert_rate, 1) convert_rate,
--                            (  b.ann_tsi_amt --commented out MarkS SR23012 9.5.2016 different with claims_reg tsi_amt is different when intm is present in extraction
--                             * NVL (c.shr_intm_pct, 100)
--                             * NVL (a.convert_rate, 1)
--                            ) ann_tsi_amt, 
                            (b.ann_tsi_amt * NVL (a.convert_rate, 1) --added by MarkS 9.5.2016
                            ) ann_tsi_amt,                           --END SR23012
                            NVL (c.intm_no, 0) intm_no,
                            NVL (c.shr_intm_pct, 100) shr_intm_pct,
                              SUM
                                 (DECODE (a.dist_sw,
                                          'Y', NVL (a.convert_rate, 1)
                                           * NVL (a.loss_reserve, 0),
                                          0
                                         )
                                 )
                            * NVL (c.shr_intm_pct, 100)
                            / 100 loss_reserve,
                              SUM (DECODE (a.dist_sw,
                                           NULL, NVL (a.convert_rate, 1)
                                            * NVL (a.losses_paid, 0),
                                           0
                                          )
                                  )
                            * NVL (c.shr_intm_pct, 100)
                            / 100 losses_paid,
                              SUM
                                 (DECODE (a.dist_sw,
                                          'Y', NVL (a.convert_rate, 1)
                                           * NVL (a.expense_reserve, 0),
                                          0
                                         )
                                 )
                            * NVL (c.shr_intm_pct, 100)
                            / 100 expense_reserve,
                              SUM
                                 (DECODE (a.dist_sw,
                                          NULL, NVL (a.convert_rate, 1)
                                           * NVL (a.expenses_paid, 0),
                                          0
                                         )
                                 )
                            * NVL (c.shr_intm_pct, 100)
                            / 100 expenses_paid,
                            a.grouped_item_no, d.clm_res_hist_id
                       FROM gicl_clm_res_hist a,
                            gicl_item_peril b,
                            gicl_intm_itmperil c,
                            (SELECT DISTINCT claim_id, item_no, peril_cd,
                                             clm_res_hist_id, grouped_item_no
                                        FROM gicl_reserve_ds
                                       WHERE NVL (negate_tag, 'N') <> 'Y') d
                      WHERE a.peril_cd = b.peril_cd
                        AND a.item_no = b.item_no
                        AND a.claim_id = b.claim_id
                        AND NVL (a.dist_sw, 'Y') = 'Y'
                        AND b.loss_cat_cd =
                                        NVL (p_dsp_loss_cat_cd, b.loss_cat_cd)
                        AND b.claim_id = c.claim_id(+)
                        AND b.item_no = c.item_no(+)
                        AND b.peril_cd = c.peril_cd(+)
                        AND DECODE (p_dsp_intm_no, NULL, 1, c.intm_no) =
                                                        NVL (p_dsp_intm_no, 1)
                        AND a.claim_id = d.claim_id
                        AND a.item_no = d.item_no
                        AND a.peril_cd = d.peril_cd
                        AND a.grouped_item_no = d.grouped_item_no
                   GROUP BY b.claim_id,
                            b.item_no,
                            b.peril_cd,
                            b.loss_cat_cd,
                            NVL (a.convert_rate, 1),
                            b.ann_tsi_amt,
                            NVL (c.intm_no, 0),
                            NVL (c.shr_intm_pct, 100),
                            a.grouped_item_no,
                            d.clm_res_hist_id) c
            WHERE 1 = 1
              AND b.claim_id(+) = a.claim_id
              AND a.claim_id = c.claim_id
              AND DECODE
                     (p_user_id,
                      NULL, check_user_per_iss_cd (a.line_cd,
                                                   a.iss_cd,
                                                   'GICLS202'
                                                  ),  --security in CS version
                      check_user_per_iss_cd2 (a.line_cd,
                                              a.iss_cd,
                                              'GICLS202',
                                              p_user_id
                                             )
                     ) = 1                           --security in Web version
              AND DECODE (p_reg_button,
                          1, TRUNC (a.dsp_loss_date),
                          2, TRUNC (a.clm_file_date)
                         ) BETWEEN p_dsp_from_date AND p_dsp_to_date
              AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
              AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
              AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
              AND a.pol_iss_cd != giacp.v ('RI_ISS_CD')
              AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) =
                     NVL (p_dsp_iss_cd,
                          DECODE (p_branch_option,
                                  1, a.iss_cd,
                                  2, a.pol_iss_cd,
                                  1
                                 )
                         )
         ORDER BY a.claim_id;

      CURSOR claims_rcvry (
         p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
         p_session_id            gicl_res_brdrx_extr.session_id%TYPE,
         p_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE,
         p_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE
      )
      IS
         SELECT   p_session_id session_id, ROWNUM rcvry_brdrx_record_id,
                  a.claim_id, a.line_cd, d.subline_cd, a.iss_cd,
                  b.recovery_id, b.recovery_payt_id,
                  SUM (  NVL (b.recovered_amt, 0)
                       * (  NVL (c.recoverable_amt, 0)
                          / get_rec_amt (c.recovery_id)
                         )
                      ) recovered_amt,
                  c.item_no, c.peril_cd, b.tran_date, b.acct_tran_id,
                  e.payee_type
             FROM gicl_clm_recovery a,
                  gicl_recovery_payt b,
                  gicl_clm_recovery_dtl c,
                  gicl_claims d,
                  gicl_clm_loss_exp e
            WHERE NVL (b.cancel_tag, 'N') = 'N'
              AND a.claim_id = b.claim_id
              AND b.claim_id = c.claim_id
              AND a.recovery_id = b.recovery_id
              AND b.recovery_id = c.recovery_id
              AND b.claim_id IN (SELECT claim_id
                                   FROM gicl_res_brdrx_extr
                                  WHERE session_id = p_session_id)
              AND b.claim_id = d.claim_id
              AND TRUNC (b.tran_date) BETWEEN p_dsp_rcvry_from_date
                                          AND p_dsp_rcvry_to_date
              AND c.claim_id = e.claim_id
              AND c.clm_loss_id = e.clm_loss_id
              AND DECODE
                     (p_user_id,
                      NULL, check_user_per_iss_cd (d.line_cd,
                                                   d.iss_cd,
                                                   'GICLS202'
                                                  ),  --security in CS version
                      check_user_per_iss_cd2 (d.line_cd,
                                              d.iss_cd,
                                              'GICLS202',
                                              p_user_id
                                             )
                     ) = 1                           --security in Web version
         GROUP BY p_session_id,
                  ROWNUM,
                  b.recovery_id,
                  b.recovery_payt_id,
                  a.claim_id,
                  a.line_cd,
                  d.subline_cd,
                  a.iss_cd,
                  c.item_no,
                  c.peril_cd,
                  b.tran_date,
                  b.acct_tran_id,
                  e.payee_type;

      v_exist       VARCHAR2 (1);
      v_postexist   VARCHAR2 (1);
      v_posted      VARCHAR2 (1);
   BEGIN
      IF v_rep_name = 1
      THEN                                                    --if Bordereaux
         IF v_brdrx_type = 1 AND v_date_option = 2
         THEN                                      --if Outstanding and As Of
            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_exist
                          FROM gicl_take_up_hist a, giac_acctrans b
                         WHERE a.acct_tran_id = b.tran_id
                           AND a.iss_cd = b.gibr_branch_cd
                           AND a.iss_cd = NVL (v_dsp_iss_cd, a.iss_cd)
                           AND TRUNC (b.tran_date) = v_dsp_as_of_date
                           AND b.tran_flag <> 'D';

               v_posted := 'N';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_exist := NULL;
            END;
         END IF;

         IF v_exist IS NOT NULL
         THEN                                            --if already taken up
            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_postexist
                          FROM gicl_take_up_hist a, giac_acctrans b
                         WHERE a.acct_tran_id = b.tran_id
                           AND a.iss_cd = b.gibr_branch_cd
                           AND a.iss_cd = NVL (v_dsp_iss_cd, a.iss_cd)
                           AND TRUNC (b.tran_date) = v_dsp_as_of_date
                           AND TRUNC (b.posting_date) = v_dsp_as_of_date;

               v_posted := 'Y';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_postexist := NULL;
            END;

            IF v_per_intermediary = 1 OR v_dsp_intm_no IS NOT NULL
            THEN  --if per intermediary and if Intermediary Number is not null
               FOR rec IN claims_take_up_intm (v_user_id,
                                               v_session_id,
                                               v_iss_break,
                                               v_subline_break,
                                               v_brdrx_date_option,
                                               v_branch_option,
                                               v_brdrx_option,
                                               v_dsp_as_of_date,
                                               v_date_option,
                                               v_dsp_line_cd,
                                               v_dsp_subline_cd,
                                               v_dsp_iss_cd,
                                               v_dsp_peril_cd,
                                               v_dsp_intm_no,
                                               v_posted
                                              )
               LOOP
                  v_brdrx_record_id := v_brdrx_record_id + 1;

                  INSERT INTO gicl_res_brdrx_extr
                              (session_id, brdrx_record_id,
                               claim_id, iss_cd, buss_source,
                               line_cd, subline_cd, loss_year,
                               assd_no, claim_no, policy_no,
                               loss_date, clm_file_date,
                               item_no, peril_cd, loss_cat_cd,
                               incept_date, expiry_date,
                               tsi_amt, intm_no, loss_reserve,
                               expense_reserve, user_id, last_update,
                               extr_type, brdrx_type,
                               ol_date_opt, brdrx_rep_type,
                               res_tag, pd_date_opt,
                               intm_tag, iss_cd_tag,
                               line_cd_tag, loss_cat_tag,
                               from_date,
                               TO_DATE,
                               branch_opt, reg_date_opt,
                               net_rcvry_tag, rcvry_from_date,
                               rcvry_to_date, grouped_item_no,
                               clm_res_hist_id, policy_tag, enrollee_tag  --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              )
                       VALUES (rec.session_id, v_brdrx_record_id,
                               rec.claim_id, rec.iss_cd, rec.buss_source,
                               rec.line_cd, rec.subline_cd, rec.loss_year,
                               rec.assd_no, rec.claim_no, rec.policy_no,
                               rec.loss_date, rec.clm_file_date,
                               rec.item_no, rec.peril_cd, rec.loss_cat_cd,
                               rec.incept_date, rec.expiry_date,
                               rec.tsi_amt, rec.intm_no, rec.os_loss,
                               rec.os_exp, rec.user_id, rec.last_update,
                               v_rep_name, v_brdrx_type,
                               v_brdrx_date_option, v_brdrx_option,
                               v_dsp_gross_tag, v_paid_date_option,
                               v_per_intermediary, v_iss_break,
                               v_subline_break, v_per_loss_cat,
                               v_dsp_from_date,
                               NVL (v_dsp_to_date, v_dsp_as_of_date),
                               NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                               v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                               v_dsp_rcvry_to_date, rec.grouped_item_no,
                               rec.clm_res_hist_id, v_per_policy, v_per_enrollee --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              );
               END LOOP;
            END IF;

            IF v_dsp_intm_no IS NULL
            THEN
               FOR rec IN claims_take_up (v_user_id,
                                          v_session_id,
                                          v_iss_break,
                                          v_subline_break,
                                          v_brdrx_date_option,
                                          v_branch_option,
                                          v_brdrx_option,
                                          v_dsp_as_of_date,
                                          v_date_option,
                                          v_dsp_line_cd,
                                          v_dsp_subline_cd,
                                          v_dsp_iss_cd,
                                          v_dsp_peril_cd,
                                          v_posted,
                                          v_per_buss
                                          --v_per_intermediary -- apollo 07.23.2015 UCPB SR# 19674
                                         )
               LOOP
                  v_brdrx_record_id := v_brdrx_record_id + 1;

                  INSERT INTO gicl_res_brdrx_extr
                              (session_id, brdrx_record_id,
                               claim_id, iss_cd, buss_source,
                               line_cd, subline_cd, loss_year,
                               assd_no, claim_no, policy_no,
                               loss_date, clm_file_date,
                               item_no, peril_cd, loss_cat_cd,
                               incept_date, expiry_date,
                               tsi_amt, loss_reserve, expense_reserve,
                               user_id, last_update, extr_type,
                               brdrx_type, ol_date_opt,
                               brdrx_rep_type, res_tag,
                               pd_date_opt, intm_tag,
                               iss_cd_tag, line_cd_tag, loss_cat_tag,
                               from_date,
                               TO_DATE,
                               branch_opt, reg_date_opt,
                               net_rcvry_tag, rcvry_from_date,
                               rcvry_to_date, grouped_item_no,
                               clm_res_hist_id, policy_tag, enrollee_tag  --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              )
                       VALUES (rec.session_id, v_brdrx_record_id,
                               rec.claim_id, rec.iss_cd, rec.buss_source,
                               rec.line_cd, rec.subline_cd, rec.loss_year,
                               rec.assd_no, rec.claim_no, rec.policy_no,
                               rec.loss_date, rec.clm_file_date,
                               rec.item_no, rec.peril_cd, rec.loss_cat_cd,
                               rec.incept_date, rec.expiry_date,
                               rec.tsi_amt, rec.os_loss, rec.os_exp,
                               rec.user_id, rec.last_update, v_rep_name,
                               v_brdrx_type, v_brdrx_date_option,
                               v_brdrx_option, v_dsp_gross_tag,
                               v_paid_date_option, v_per_intermediary,
                               v_iss_break, v_subline_break, v_per_loss_cat,
                               v_dsp_from_date,
                               NVL (v_dsp_to_date, v_dsp_as_of_date),
                               NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                               v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                               v_dsp_rcvry_to_date, rec.grouped_item_no,
                               rec.clm_res_hist_id, v_per_policy, v_per_enrollee --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              );
               END LOOP;
            END IF;
         ELSE                                                   --not taken up
            IF v_per_intermediary = 1 OR v_dsp_intm_no IS NOT NULL
            THEN
--use cursor claims_intm in inserting records in gicl_res_brdrx_extr if per intermediary (Direct only) or if Intermediary Number is not null
               FOR rec IN claims_intm (v_user_id,
                                       v_session_id,
                                       v_iss_break,
                                       v_subline_break,
                                       v_dsp_gross_tag,
                                       v_brdrx_type,
                                       v_paid_date_option,
                                       v_brdrx_date_option,
                                       v_branch_option,
                                       v_brdrx_option,
                                       v_dsp_from_date,
                                       v_dsp_to_date,
                                       v_dsp_as_of_date,
                                       v_date_option,
                                       v_dsp_line_cd,
                                       v_dsp_subline_cd,
                                       v_dsp_iss_cd,
                                       v_dsp_peril_cd,
                                       v_dsp_intm_no
                                      )
               LOOP
                  v_brdrx_record_id := v_brdrx_record_id + 1;

                  INSERT INTO gicl_res_brdrx_extr
                              (session_id, brdrx_record_id,
                               claim_id, iss_cd, buss_source,
                               line_cd, subline_cd, loss_year,
                               assd_no, claim_no, policy_no,
                               loss_date, clm_file_date,
                               item_no, peril_cd, loss_cat_cd,
                               incept_date, expiry_date,
                               tsi_amt, intm_no, loss_reserve,
                               losses_paid, expense_reserve,
                               expenses_paid, user_id,
                               last_update, extr_type, brdrx_type,
                               ol_date_opt, brdrx_rep_type,
                               res_tag, pd_date_opt,
                               intm_tag, iss_cd_tag,
                               line_cd_tag, loss_cat_tag,
                               from_date,
                               TO_DATE,
                               branch_opt, reg_date_opt,
                               net_rcvry_tag, rcvry_from_date,
                               rcvry_to_date, grouped_item_no,
                               clm_res_hist_id, policy_tag, enrollee_tag  --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              )
                       VALUES (rec.session_id, v_brdrx_record_id,
                               rec.claim_id, rec.iss_cd, rec.buss_source,
                               rec.line_cd, rec.subline_cd, rec.loss_year,
                               rec.assd_no, rec.claim_no, rec.policy_no,
                               rec.loss_date, rec.clm_file_date,
                               rec.item_no, rec.peril_cd, rec.loss_cat_cd,
                               rec.incept_date, rec.expiry_date,
                               rec.tsi_amt, rec.intm_no, rec.loss_reserve,
                               rec.losses_paid, rec.expense_reserve,
                               rec.expenses_paid, rec.user_id,
                               rec.last_update, v_rep_name, v_brdrx_type,
                               v_brdrx_date_option, v_brdrx_option,
                               v_dsp_gross_tag, v_paid_date_option,
                               v_per_intermediary, v_iss_break,
                               v_subline_break, v_per_loss_cat,
                               v_dsp_from_date,
                               NVL (v_dsp_to_date, v_dsp_as_of_date),
                               NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                               v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                               v_dsp_rcvry_to_date, rec.grouped_item_no,
                               rec.clm_res_hist_id, v_per_policy, v_per_enrollee --added fields per policy and per_enrollee tag by jonathan 02.20.2014 for UCPBGEN SR - 15063
                              );
               END LOOP;
            END IF;

            IF v_dsp_intm_no IS NULL
            THEN
               --use cursor claims_rec in inserting records in gicl_res_brdrx_extr both per intermediary (Inward only) and not per intermediary
               FOR rec IN claims_rec (v_user_id,
                                      v_session_id,
                                      v_iss_break,
                                      v_subline_break,
                                      v_dsp_gross_tag,
                                      v_brdrx_type,
                                      v_paid_date_option,
                                      v_brdrx_date_option,
                                      v_branch_option,
                                      v_brdrx_option,
                                      v_dsp_from_date,
                                      v_dsp_to_date,
                                      v_dsp_as_of_date,
                                      v_date_option,
                                      v_dsp_line_cd,
                                      v_dsp_subline_cd,
                                      v_dsp_iss_cd,
                                      v_dsp_peril_cd,
                                      --v_per_intermediary, -- apollo 07.23.2015 UCPB SR# 19674
                                      v_per_buss,
                                      v_per_policy,
                                      v_per_enrollee,
                                      v_dsp_line_cd2,
                                      v_dsp_subline_cd2,
                                      v_dsp_iss_cd2,
                                      v_issue_yy,
                                      v_pol_seq_no,
                                      v_renew_no,
                                      v_dsp_enrollee,
                                      v_dsp_control_type,
                                      v_dsp_control_number
                                     )
               LOOP
                  v_brdrx_record_id := v_brdrx_record_id + 1;

                  INSERT INTO gicl_res_brdrx_extr
                              (session_id, brdrx_record_id,
                               claim_id, iss_cd, buss_source,
                               line_cd, subline_cd, loss_year,
                               assd_no, claim_no, policy_no,
                               loss_date, clm_file_date,
                               item_no, peril_cd, loss_cat_cd,
                               incept_date, expiry_date,
                               tsi_amt, loss_reserve,
                               losses_paid, expense_reserve,
                               expenses_paid, user_id,
                               last_update, extr_type, brdrx_type,
                               ol_date_opt, brdrx_rep_type,
                               res_tag, pd_date_opt,
                               intm_tag, iss_cd_tag,
                               line_cd_tag, loss_cat_tag,
                               from_date,
                               TO_DATE,
                               branch_opt, reg_date_opt,
                               net_rcvry_tag, rcvry_from_date,
                               rcvry_to_date, grouped_item_no,
                               clm_res_hist_id, pol_iss_cd,
                               issue_yy, pol_seq_no, renew_no,
                               enrollee, control_type,
                               control_number, policy_tag, enrollee_tag,
                               intm_no
                              )
                       VALUES (rec.session_id, v_brdrx_record_id,
                               rec.claim_id, rec.iss_cd, rec.buss_source,
                               rec.line_cd, rec.subline_cd, rec.loss_year,
                               rec.assd_no, rec.claim_no, rec.policy_no,
                               rec.loss_date, rec.clm_file_date,
                               rec.item_no, rec.peril_cd, rec.loss_cat_cd,
                               rec.incept_date, rec.expiry_date,
                               rec.tsi_amt, rec.loss_reserve,
                               rec.losses_paid, rec.expense_reserve,
                               rec.expenses_paid, rec.user_id,
                               rec.last_update, v_rep_name, v_brdrx_type,
                               v_brdrx_date_option, v_brdrx_option,
                               v_dsp_gross_tag, v_paid_date_option,
                               v_per_intermediary, v_iss_break,
                               v_subline_break, v_per_loss_cat,
                               v_dsp_from_date,
                               NVL (v_dsp_to_date, v_dsp_as_of_date),
                               NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                               v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                               v_dsp_rcvry_to_date, rec.grouped_item_no,
                               rec.clm_res_hist_id, rec.pol_iss_cd,
                               rec.issue_yy, rec.pol_seq_no, rec.renew_no,
                               rec.grouped_item_title, rec.control_type_cd,
                               rec.control_cd, v_per_policy, v_per_enrollee,
                               rec.intm_no
                              );
               END LOOP;
            END IF;
         END IF;

         IF v_net_rcvry_chkbx = 'Y'
         THEN
            FOR rcvry IN claims_rcvry (v_user_id,
                                       v_session_id,
                                       v_dsp_rcvry_from_date,
                                       v_dsp_rcvry_to_date
                                      )
            LOOP
               INSERT INTO gicl_rcvry_brdrx_extr
                           (session_id, rcvry_brdrx_record_id,
                            claim_id, recovery_id,
                            recovery_payt_id, line_cd,
                            subline_cd, iss_cd, rcvry_pd_date,
                            item_no, peril_cd,
                            recovered_amt, acct_tran_id,
                            payee_type
                           )
                    VALUES (rcvry.session_id, rcvry.rcvry_brdrx_record_id,
                            rcvry.claim_id, rcvry.recovery_id,
                            rcvry.recovery_payt_id, rcvry.line_cd,
                            rcvry.subline_cd, rcvry.iss_cd, rcvry.tran_date,
                            rcvry.item_no, rcvry.peril_cd,
                            rcvry.recovered_amt, rcvry.acct_tran_id,
                            rcvry.payee_type
                           );
            END LOOP;
         END IF;
      ELSIF v_rep_name = 2
      THEN                                                --if Claims Register
         IF /*v_per_buss*/ v_per_intermediary = 1 OR v_dsp_intm_no IS NOT NULL -- apollo 07.23.2015 UCPB SR# 19674
         THEN
            FOR rec IN claims_reg_intm (v_user_id,
                                        v_session_id,
                                        v_per_line,
                                        v_per_iss,
                                        v_per_buss,
                                        v_per_loss_cat,
                                        v_branch_option,
                                        v_dsp_from_date,
                                        v_dsp_to_date,
                                        v_dsp_line_cd,
                                        v_dsp_subline_cd,
                                        v_dsp_iss_cd,
                                        v_dsp_peril_cd,
                                        v_per_intermediary,
                                        v_reg_button,
                                        v_dsp_loss_cat_cd,
                                        v_dsp_intm_no
                                       )
            LOOP
               v_brdrx_record_id := v_brdrx_record_id + 1;

               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id, claim_id,
                            iss_cd, buss_source, line_cd,
                            subline_cd, loss_year, assd_no,
                            claim_no, policy_no, loss_date,
                            clm_file_date, item_no, peril_cd,
                            loss_cat_cd, incept_date,
                            expiry_date, tsi_amt,
                            loss_reserve, losses_paid,
                            expense_reserve, expenses_paid,
                            user_id, last_update, extr_type,
                            brdrx_type, ol_date_opt,
                            brdrx_rep_type, res_tag,
                            pd_date_opt, intm_tag, iss_cd_tag,
                            line_cd_tag, loss_cat_tag, from_date,
                            TO_DATE,
                            branch_opt, reg_date_opt,
                            net_rcvry_tag, rcvry_from_date,
                            rcvry_to_date, grouped_item_no,
                            clm_res_hist_id, prem_amt,
                            clm_stat_cd, recovered_amt,
                            intm_type
                           )
                    VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                            rec.iss_cd, rec.buss_source, rec.line_cd,
                            rec.subline_cd, rec.loss_year, rec.assd_no,
                            rec.claim_no, rec.policy_no, rec.loss_date,
                            rec.clm_file_date, rec.item_no, rec.peril_cd,
                            rec.loss_cat_cd, rec.pol_eff_date,
                            rec.expiry_date, rec.ann_tsi_amt,
                            rec.loss_reserve, rec.losses_paid,
                            rec.expense_reserve, rec.expenses_paid,
                            rec.user_id, rec.last_update, v_rep_name,
                            v_brdrx_type, v_brdrx_date_option,
                            v_brdrx_option, v_dsp_gross_tag,
                            v_paid_date_option, v_per_buss, v_per_iss,
                            --extract correct tag of Intermediary, Issue Source by MAC 11/26/2013
                            v_per_line, v_per_loss_cat, v_dsp_from_date,
                            --extract correct tag of Line/Subline by MAC 11/26/2013
                            NVL (v_dsp_to_date, v_dsp_as_of_date),
                            NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                            v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                            v_dsp_rcvry_to_date, rec.grouped_item_no,
                            rec.clm_res_hist_id, rec.prem_amt,
                            rec.clm_stat_cd, rec.converted_recovered_amt,
                            rec.intm_type
                           );
            END LOOP;
         END IF;

         IF v_dsp_intm_no IS NULL
         THEN
            FOR rec IN claims_reg (v_user_id,
                                   v_session_id,
                                   v_per_line,
                                   v_per_iss,
                                   v_per_buss,
                                   v_per_loss_cat,
                                   v_branch_option,
                                   v_dsp_from_date,
                                   v_dsp_to_date,
                                   v_dsp_line_cd,
                                   v_dsp_subline_cd,
                                   v_dsp_iss_cd,
                                   v_dsp_peril_cd,
                                   v_per_intermediary,
                                   v_reg_button,
                                   v_dsp_loss_cat_cd,
                                   v_dsp_intm_no
                                  )
            LOOP
               v_brdrx_record_id := v_brdrx_record_id + 1;

               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id, claim_id,
                            iss_cd, buss_source, line_cd,
                            subline_cd, loss_year, assd_no,
                            claim_no, policy_no, loss_date,
                            clm_file_date, item_no, peril_cd,
                            loss_cat_cd, incept_date,
                            expiry_date, tsi_amt,
                            loss_reserve, losses_paid,
                            expense_reserve, expenses_paid,
                            user_id, last_update, extr_type,
                            brdrx_type, ol_date_opt,
                            brdrx_rep_type, res_tag,
                            pd_date_opt, intm_tag, iss_cd_tag,
                            line_cd_tag, loss_cat_tag, from_date,
                            TO_DATE,
                            branch_opt, reg_date_opt,
                            net_rcvry_tag, rcvry_from_date,
                            rcvry_to_date, grouped_item_no,
                            clm_res_hist_id, prem_amt,
                            clm_stat_cd, recovered_amt,
                            intm_type
                           )
                    VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                            rec.iss_cd, rec.buss_source, rec.line_cd,
                            rec.subline_cd, rec.loss_year, rec.assd_no,
                            rec.claim_no, rec.policy_no, rec.loss_date,
                            rec.clm_file_date, rec.item_no, rec.peril_cd,
                            rec.loss_cat_cd, rec.pol_eff_date,
                            rec.expiry_date, rec.ann_tsi_amt,
                            rec.loss_reserve, rec.losses_paid,
                            rec.expense_reserve, rec.expenses_paid,
                            rec.user_id, rec.last_update, v_rep_name,
                            v_brdrx_type, v_brdrx_date_option,
                            v_brdrx_option, v_dsp_gross_tag,
                            v_paid_date_option, v_per_buss, v_per_iss,
                            --extract correct tag of Intermediary, Issue Source by MAC 11/26/2013
                            v_per_line, v_per_loss_cat, v_dsp_from_date,
                            --extract correct tag of Line/Subline by MAC 11/26/2013
                            NVL (v_dsp_to_date, v_dsp_as_of_date),
                            NVL(v_branch_option, 0), v_reg_button, -- apollo 08.04.2015 added NVL in v_branch_option
                            v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                            v_dsp_rcvry_to_date, rec.grouped_item_no,
                            rec.clm_res_hist_id, rec.prem_amt,
                            rec.clm_stat_cd, rec.converted_recovered_amt,
                            rec.intm_type
                           );
            END LOOP;
         END IF;
      END IF;

      --COMMIT;
   END extract_all;

   PROCEDURE extract_distribution
   IS
      CURSOR loss_brdrx_extr (
         p_brdrx_extr_session_id   IN   gicl_res_brdrx_ds_extr.session_id%TYPE,
         p_bRDRX_TYPE       IN  gicl_res_brdrx_extr.brdrx_type%TYPE --added by aliza 03/31/2015
      )
      IS
SELECT
    --a.brdrx_record_id comment out by aliza 03/31/2014 replaced by code below
         b.brdrx_record_id brdrx_record_id, a.claim_id, a.iss_cd,
         a.buss_source, a.line_cd, a.subline_cd, a.loss_year, a.item_no,
         a.peril_cd, a.loss_cat_cd, a.grouped_item_no,         
--a.clm_res_hist_id, comment out by aliza g. 03/31/2015 repaced by codes below
         b.clm_res_hist_id clm_res_hist_id,
                                           /*03/31/2015 comment out by aliza g. for SR 18809*/
                                           /*a.loss_reserve, a.expense_reserve, a.losses_paid,
                                           a.expenses_paid*/
                                           /*03/31/2015 added out by aliza g. for SR 18809 to replace code above*/
                                           SUM (a.loss_reserve) loss_reserve,
         SUM (a.expense_reserve) expense_reserve,
         SUM (a.losses_paid) losses_paid, SUM (a.expenses_paid) expenses_paid, b.loss_reserve2, b.expense_reserve2 -- added by carlo SR-5878 01-11-2017
    FROM gicl_res_brdrx_extr a,
         (SELECT   MAX (clm_res_hist_id) clm_res_hist_id,
                   MAX (brdrx_record_id) brdrx_record_id, claim_id, item_no,
                   grouped_item_no, peril_cd, loss_cat_cd, buss_source, SUM(loss_reserve) loss_reserve2, SUM (expense_reserve) expense_reserve2
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_brdrx_extr_session_id
                and NVL(DECODE (p_bRDRX_TYPE, 
                       1, loss_reserve+expense_reserve,
                       2, losses_paid+expenses_paid 
                      ) ,0)             
             != 0  
          GROUP BY claim_id,
                   item_no,
                   peril_cd,
                   loss_cat_cd,
                   buss_source,
                   grouped_item_no,DECODE (p_bRDRX_TYPE, 
                       1, 1, 
                       2, clm_res_hist_id 
                      ),
                   loss_reserve,
                   expense_reserve) b
   WHERE session_id = p_brdrx_extr_session_id
     AND a.claim_id = b.claim_id
     AND a.item_no = b.item_no
     AND a.peril_cd = b.peril_cd
     AND a.grouped_item_no = b.grouped_item_no
/*03/31/2015 added by aliza g. for SR 18809*/
     AND a.brdrx_record_id = b.brdrx_record_id          --added by gab 03.21.2016 SR 21796
GROUP BY b.brdrx_record_id,
         a.buss_source,
         a.iss_cd,
         a.line_cd,
         a.subline_cd,
         a.claim_id,
         a.assd_no,
         a.loss_cat_cd,
         a.loss_year,
         a.item_no,
         a.peril_cd,
         a.grouped_item_no,
         a.intm_no,
         b.clm_res_hist_id,
         b.loss_reserve2, 
         b.expense_reserve2
HAVING SUM (  NVL(DECODE (brdrx_rep_type,
                        1, loss_reserve,
                        2, expense_reserve,
                        3, NVL(loss_reserve,0) + NVL(expense_reserve,0)
                       ),0)
              - NVL(DECODE (brdrx_rep_type,
                        1, losses_paid,
                        2, expenses_paid,
                        3, NVL(losses_paid,0) + NVL(expenses_paid,0)
                       ),0)
             ) != 0           ;       
/*03/31/2015 end of code added by aliza g. for SR 18809*/             

      CURSOR loss_reserve_ds (
         p_reserve_ds_claim_id          IN   gicl_reserve_ds.claim_id%TYPE,
         p_reserve_ds_item_no           IN   gicl_reserve_ds.item_no%TYPE,
         p_reserve_ds_peril_cd          IN   gicl_reserve_ds.peril_cd%TYPE,
         p_reserve_ds_grouped_item_no   IN   gicl_res_brdrx_extr.grouped_item_no%TYPE,
         p_reserve_ds_clm_res_hist_id   IN   gicl_res_brdrx_extr.clm_res_hist_id%TYPE,
         p_loss_reserve                 IN   gicl_res_brdrx_extr.loss_reserve%TYPE,
         p_expense_reserve              IN   gicl_res_brdrx_extr.expense_reserve%TYPE,
         p_losses_paid                  IN   gicl_res_brdrx_extr.losses_paid%TYPE,
         p_expenses_paid                IN   gicl_res_brdrx_extr.expenses_paid%TYPE
      )
      IS
         SELECT DISTINCT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                         a.grp_seq_no, a.shr_pct,
                         (p_loss_reserve * a.shr_pct / 100) loss_reserve,
                         (p_losses_paid * a.shr_pct / 100) losses_paid,
                         (p_expense_reserve * a.shr_pct / 100
                         ) expense_reserve,
                         (p_expenses_paid * a.shr_pct / 100) expenses_paid
                    FROM gicl_reserve_ds a
                   WHERE a.peril_cd = p_reserve_ds_peril_cd
                     AND a.item_no = p_reserve_ds_item_no
                     AND a.claim_id = p_reserve_ds_claim_id
                     AND a.grouped_item_no = p_reserve_ds_grouped_item_no
                     AND a.clm_res_hist_id = p_reserve_ds_clm_res_hist_id;

      CURSOR loss_reserve_rids (
         p_reserve_rids_claim_id          IN   gicl_reserve_rids.claim_id%TYPE,
         p_reserve_rids_clm_res_hist_id   IN   gicl_reserve_rids.clm_res_hist_id%TYPE,
         p_reserve_rids_clm_dist_no       IN   gicl_reserve_rids.clm_dist_no%TYPE,
         p_reserve_rids_grp_seq_no        IN   gicl_reserve_rids.grp_seq_no%TYPE,
         p_loss_reserve                   IN   gicl_res_brdrx_extr.loss_reserve%TYPE,
         p_expense_reserve                IN   gicl_res_brdrx_extr.expense_reserve%TYPE,
         p_losses_paid                    IN   gicl_res_brdrx_extr.losses_paid%TYPE,
         p_expenses_paid                  IN   gicl_res_brdrx_extr.expenses_paid%TYPE
      )
      IS
         SELECT DISTINCT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct,
                         a.shr_ri_pct_real,
                         (p_loss_reserve * a.shr_ri_pct_real / 100
                         ) loss_reserve,
                         (p_losses_paid * a.shr_ri_pct_real / 100
                         ) losses_paid,
                         (p_expense_reserve * a.shr_ri_pct_real / 100
                         ) expense_reserve,
                         (p_expenses_paid * a.shr_ri_pct_real / 100
                         ) expenses_paid
                    FROM gicl_reserve_rids a
                   WHERE a.grp_seq_no = p_reserve_rids_grp_seq_no
                     AND a.clm_dist_no = p_reserve_rids_clm_dist_no
                     AND a.clm_res_hist_id = p_reserve_rids_clm_res_hist_id
                     AND a.claim_id = p_reserve_rids_claim_id;

      --get all distributed recoveries only
      CURSOR rcvry_dist (
         p_rcvry_session_id   IN   gicl_rcvry_brdrx_extr.session_id%TYPE
      )
      IS
         SELECT a.rcvry_brdrx_record_id, a.claim_id, a.recovery_id,
                a.recovery_payt_id, a.line_cd, a.subline_cd, a.iss_cd,
                a.item_no, a.peril_cd, a.recovered_amt, a.acct_tran_id,
                a.payee_type
           FROM gicl_rcvry_brdrx_extr a
          WHERE a.session_id = p_rcvry_session_id
            AND a.recovery_id IN (
                   SELECT b.recovery_id
                     FROM gicl_recovery_ds b
                    WHERE b.recovery_id = a.recovery_id
                      AND b.recovery_payt_id = b.recovery_payt_id
                      AND NVL (b.negate_tag, 'N') = 'N');

      --get all undistributed recoveries only
      CURSOR rcvry_undist (
         p_rcvry_session_id   IN   gicl_rcvry_brdrx_extr.session_id%TYPE
      )
      IS
         SELECT a.rcvry_brdrx_record_id, a.claim_id, a.recovery_id,
                a.recovery_payt_id, a.line_cd, a.subline_cd, a.iss_cd,
                a.item_no, a.peril_cd, a.recovered_amt, NULL rec_dist_no,
                TO_NUMBER (TO_CHAR (rcvry_pd_date, 'RRRR')) dist_year,
                giisp.n ('NET_RETENTION') grp_seq_no, '1' share_type,
                100 share_pct, recovered_amt shr_recovery_amt, a.acct_tran_id,
                a.payee_type
           FROM gicl_rcvry_brdrx_extr a
          WHERE a.session_id = p_rcvry_session_id
            AND a.recovery_id NOT IN (SELECT recovery_id
                                        FROM gicl_rcvry_brdrx_ds_extr
                                       WHERE session_id = p_rcvry_session_id);

      --added cursor for distribution of losses paid per grp_seq_no by MAC 09/11/2013.
      CURSOR losses_paid_ds (
         p_paid_ds_claim_id          IN   gicl_reserve_ds.claim_id%TYPE,
         p_paid_ds_item_no           IN   gicl_reserve_ds.item_no%TYPE,
         p_paid_ds_peril_cd          IN   gicl_reserve_ds.peril_cd%TYPE,
         p_paid_ds_grouped_item_no   IN   gicl_res_brdrx_extr.grouped_item_no%TYPE,
         p_paid_ds_clm_res_hist_id   IN   gicl_res_brdrx_extr.clm_res_hist_id%TYPE, --extract losses paid distribution per history by MAC 03/28/2014.
         p_paid_date_option          IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
         p_dsp_from_date             IN   gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date               IN   gicl_res_brdrx_extr.TO_DATE%TYPE
      )
      IS
         SELECT b.claim_id, b.grp_seq_no, b.shr_loss_exp_pct shr_pct,
                a.clm_res_hist_id,
                ROUND
                   (DECODE
                       (c.payee_type,
                        'L', ABS (NVL (shr_le_adv_amt, 0))
                         * NVL (e.orig_curr_rate, e.convert_rate)
                         * SIGN (a.losses_paid)
                         * gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        0
                       ),
                    2
                   ) losses_paid,
                ROUND
                   (DECODE
                       (c.payee_type,
                        'E', ABS (NVL (shr_le_adv_amt, 0))
                         * NVL (e.orig_curr_rate, e.convert_rate)
                         * SIGN (a.expenses_paid)
                         * gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        0
                       ),
                    2
                   ) expenses_paid
           FROM gicl_clm_res_hist a,
                gicl_loss_exp_ds b,
                gicl_clm_loss_exp c,
                giac_acctrans d,
                gicl_advice e
          WHERE a.dist_sw IS NULL
            AND gicls202_extraction_pkg.get_reversal (a.tran_id,
                                                      p_dsp_from_date,
                                                      p_dsp_to_date,
                                                      p_paid_date_option
                                                     ) != 0
            AND a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND a.dist_no = b.clm_dist_no
            AND b.claim_id = c.claim_id
            AND b.clm_loss_id = c.clm_loss_id
            AND a.tran_id = d.tran_id
            AND a.advice_id = e.advice_id
            AND c.claim_id = p_paid_ds_claim_id
            AND c.item_no = p_paid_ds_item_no
            AND c.peril_cd = p_paid_ds_peril_cd
            AND c.grouped_item_no = p_paid_ds_grouped_item_no
            AND a.clm_res_hist_id = p_paid_ds_clm_res_hist_id --extract losses paid distribution per history by MAC 03/28/2014.
            AND (   DECODE (p_paid_date_option,
                            1, TRUNC (d.tran_date),
                            2, TRUNC (d.posting_date)
                           ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                 OR DECODE
                       (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        1, 0,
                        1
                       ) = 1
                )
            AND (   DECODE (a.cancel_tag,
                            'Y', TRUNC (a.cancel_date),
                            p_dsp_to_date + 1
                           ) > p_dsp_to_date
                 OR DECODE
                       (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        1, 0,
                        1
                       ) = 1
                );

      --added cursor for distribution of losses paid per RI by MAC 09/11/2013.
      CURSOR losses_paid_rids (
         p_paid_rids_claim_id          IN   gicl_reserve_ds.claim_id%TYPE,
         p_paid_rids_clm_res_hist_id   IN   gicl_res_brdrx_extr.clm_res_hist_id%TYPE,
         p_paid_rids_grp_seq_no        IN   gicl_loss_exp_rids.grp_seq_no%TYPE,
         p_paid_date_option            IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
         p_dsp_from_date               IN   gicl_res_brdrx_extr.from_date%TYPE,
         p_dsp_to_date                 IN   gicl_res_brdrx_extr.TO_DATE%TYPE
      )
      IS
         SELECT a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct shr_ri_pct,
                ROUND
                   (DECODE
                       (b.payee_type,
                        'L', ABS (NVL (shr_le_ri_adv_amt, 0))
                         * NVL (d.orig_curr_rate, d.convert_rate)
                         * SIGN (c.losses_paid)
                         * gicls202_extraction_pkg.get_reversal
                                                           (c.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        0
                       ),
                    2
                   ) losses_paid,
                ROUND
                   (DECODE
                       (b.payee_type,
                        'E', ABS (NVL (shr_le_ri_adv_amt, 0))
                         * NVL (d.orig_curr_rate, d.convert_rate)
                         * SIGN (c.expenses_paid)
                         * gicls202_extraction_pkg.get_reversal
                                                           (c.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                        0
                       ),
                    2
                   ) expenses_paid
           FROM gicl_loss_exp_rids a,
                gicl_clm_loss_exp b,
                gicl_clm_res_hist c,
                gicl_advice d
          WHERE a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND a.claim_id = c.claim_id
            AND a.clm_loss_id = c.clm_loss_id
            AND a.clm_dist_no = c.dist_no
            AND c.advice_id = d.advice_id
            AND a.grp_seq_no = p_paid_rids_grp_seq_no
            AND a.claim_id = p_paid_rids_claim_id
            AND c.clm_res_hist_id = p_paid_rids_clm_res_hist_id;

      v_rcvry_brdrx_ds_rec_id     gicl_rcvry_brdrx_ds_extr.rcvry_brdrx_ds_record_id%TYPE;
      v_rcvry_brdrx_rids_rec_id   gicl_rcvry_brdrx_rids_extr.rcvry_brdrx_rids_record_id%TYPE;
   BEGIN
      --FOR brdrx_extr_rec IN loss_brdrx_extr (v_session_id)--removed by aliza 03/31/2015
      FOR brdrx_extr_rec IN loss_brdrx_extr (v_session_id,v_brdrx_type)--added by aliza 03/31/2015
      LOOP
         IF v_rep_name = 1 AND v_brdrx_type = 2
         THEN               --for Bordereaux - Losses Paid by MAC 09/11/2013.
            FOR paid_ds_rec IN
               losses_paid_ds (brdrx_extr_rec.claim_id,
                               brdrx_extr_rec.item_no,
                               brdrx_extr_rec.peril_cd,
                               brdrx_extr_rec.grouped_item_no,
                               brdrx_extr_rec.clm_res_hist_id, --extract losses paid distribution per history by MAC 03/28/2014.
                               v_paid_date_option,
                               v_dsp_from_date,
                               v_dsp_to_date
                              )
            LOOP
               BEGIN
                  v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                  INSERT INTO gicl_res_brdrx_ds_extr
                              (session_id, brdrx_record_id,
                               brdrx_ds_record_id,
                               claim_id,
                               iss_cd,
                               buss_source,
                               line_cd,
                               subline_cd,
                               loss_year,
                               item_no,
                               peril_cd,
                               loss_cat_cd,
                               grp_seq_no, shr_pct,
                               loss_reserve, losses_paid, expense_reserve,
                               expenses_paid,
                               user_id, last_update
                              )
                       VALUES (v_session_id, brdrx_extr_rec.brdrx_record_id,
                               v_brdrx_ds_record_id,
                               brdrx_extr_rec.claim_id,
                               brdrx_extr_rec.iss_cd,
                               brdrx_extr_rec.buss_source,
                               brdrx_extr_rec.line_cd,
                               brdrx_extr_rec.subline_cd,
                               brdrx_extr_rec.loss_year,
                               brdrx_extr_rec.item_no,
                               brdrx_extr_rec.peril_cd,
                               brdrx_extr_rec.loss_cat_cd,
                               paid_ds_rec.grp_seq_no, paid_ds_rec.shr_pct,
                               0, paid_ds_rec.losses_paid, 0,
                               paid_ds_rec.expenses_paid,
                               NVL (v_user_id, USER), SYSDATE
                              );
               END;

               FOR paid_rids_rec IN
                  losses_paid_rids (paid_ds_rec.claim_id,
                                    paid_ds_rec.clm_res_hist_id,
                                    paid_ds_rec.grp_seq_no,
                                    v_paid_date_option,
                                    v_dsp_from_date,
                                    v_dsp_to_date
                                   )
               LOOP
                  BEGIN
                     v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                     INSERT INTO gicl_res_brdrx_rids_extr
                                 (session_id, brdrx_ds_record_id,
                                  brdrx_rids_record_id,
                                  claim_id,
                                  iss_cd,
                                  buss_source,
                                  line_cd,
                                  subline_cd,
                                  loss_year,
                                  item_no,
                                  peril_cd,
                                  loss_cat_cd,
                                  grp_seq_no,
                                  ri_cd,
                                  prnt_ri_cd,
                                  shr_ri_pct, loss_reserve,
                                  losses_paid, expense_reserve,
                                  expenses_paid,
                                  user_id, last_update
                                 )
                          VALUES (v_session_id, v_brdrx_ds_record_id,
                                  v_brdrx_rids_record_id,
                                  brdrx_extr_rec.claim_id,
                                  brdrx_extr_rec.iss_cd,
                                  brdrx_extr_rec.buss_source,
                                  brdrx_extr_rec.line_cd,
                                  brdrx_extr_rec.subline_cd,
                                  brdrx_extr_rec.loss_year,
                                  brdrx_extr_rec.item_no,
                                  brdrx_extr_rec.peril_cd,
                                  brdrx_extr_rec.loss_cat_cd,
                                  paid_ds_rec.grp_seq_no,
                                  paid_rids_rec.ri_cd,
                                  paid_rids_rec.prnt_ri_cd,
                                  paid_rids_rec.shr_ri_pct, 0,
                                  paid_rids_rec.losses_paid, 0,
                                  paid_rids_rec.expenses_paid,
                                  NVL (v_user_id, USER), SYSDATE
                                 );
                  END;
               END LOOP;
            END LOOP;
         ELSE                                                --not Losses Paid
            FOR reserve_ds_rec IN
               loss_reserve_ds (brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,
                                brdrx_extr_rec.grouped_item_no,
                                brdrx_extr_rec.clm_res_hist_id,
                                brdrx_extr_rec.loss_reserve2, --replaced by carlo
                                brdrx_extr_rec.expense_reserve2, --replaced by carlo
                                brdrx_extr_rec.losses_paid,
                                brdrx_extr_rec.expenses_paid
                               )
            LOOP
               BEGIN
                  v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                  INSERT INTO gicl_res_brdrx_ds_extr
                              (session_id, brdrx_record_id,
                               brdrx_ds_record_id,
                               claim_id,
                               iss_cd,
                               buss_source,
                               line_cd,
                               subline_cd,
                               loss_year,
                               item_no,
                               peril_cd,
                               loss_cat_cd,
                               grp_seq_no,
                               shr_pct,
                               loss_reserve,
                               losses_paid,
                               expense_reserve,
                               expenses_paid,
                               user_id, last_update
                              )
                       VALUES (v_session_id, brdrx_extr_rec.brdrx_record_id,
                               v_brdrx_ds_record_id,
                               brdrx_extr_rec.claim_id,
                               brdrx_extr_rec.iss_cd,
                               brdrx_extr_rec.buss_source,
                               brdrx_extr_rec.line_cd,
                               brdrx_extr_rec.subline_cd,
                               brdrx_extr_rec.loss_year,
                               brdrx_extr_rec.item_no,
                               brdrx_extr_rec.peril_cd,
                               brdrx_extr_rec.loss_cat_cd,
                               reserve_ds_rec.grp_seq_no,
                               reserve_ds_rec.shr_pct,
                               reserve_ds_rec.loss_reserve,
                               reserve_ds_rec.losses_paid,
                               reserve_ds_rec.expense_reserve,
                               reserve_ds_rec.expenses_paid,
                               NVL (v_user_id, USER), SYSDATE
                              );
               END;

               FOR reserve_rids_rec IN
                  loss_reserve_rids (reserve_ds_rec.claim_id,
                                     reserve_ds_rec.clm_res_hist_id,
                                     reserve_ds_rec.clm_dist_no,
                                     reserve_ds_rec.grp_seq_no,
                                     reserve_ds_rec.loss_reserve,
                                     reserve_ds_rec.expense_reserve,
                                     reserve_ds_rec.losses_paid,
                                     reserve_ds_rec.expenses_paid
                                    )
               LOOP
                  BEGIN
                     v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                     INSERT INTO gicl_res_brdrx_rids_extr
                                 (session_id, brdrx_ds_record_id,
                                  brdrx_rids_record_id,
                                  claim_id,
                                  iss_cd,
                                  buss_source,
                                  line_cd,
                                  subline_cd,
                                  loss_year,
                                  item_no,
                                  peril_cd,
                                  loss_cat_cd,
                                  grp_seq_no,
                                  ri_cd,
                                  prnt_ri_cd,
                                  shr_ri_pct,
                                  loss_reserve,
                                  losses_paid,
                                  expense_reserve,
                                  expenses_paid,
                                  user_id, last_update
                                 )
                          VALUES (v_session_id, v_brdrx_ds_record_id,
                                  v_brdrx_rids_record_id,
                                  brdrx_extr_rec.claim_id,
                                  brdrx_extr_rec.iss_cd,
                                  brdrx_extr_rec.buss_source,
                                  brdrx_extr_rec.line_cd,
                                  brdrx_extr_rec.subline_cd,
                                  brdrx_extr_rec.loss_year,
                                  brdrx_extr_rec.item_no,
                                  brdrx_extr_rec.peril_cd,
                                  brdrx_extr_rec.loss_cat_cd,
                                  reserve_ds_rec.grp_seq_no,
                                  reserve_rids_rec.ri_cd,
                                  reserve_rids_rec.prnt_ri_cd,
                                  reserve_rids_rec.shr_ri_pct_real,
                                  reserve_rids_rec.loss_reserve,
                                  reserve_rids_rec.losses_paid,
                                  reserve_rids_rec.expense_reserve,
                                  reserve_rids_rec.expenses_paid,
                                  NVL (v_user_id, USER), SYSDATE
                                 );
                  END;
               END LOOP;
            END LOOP;
         END IF;
      END LOOP;

      --COMMIT;

      --distribution details of recoveries
      IF v_net_rcvry_chkbx = 'Y'
      THEN
         BEGIN
            SELECT MAX (rcvry_brdrx_ds_record_id)
              INTO v_rcvry_brdrx_ds_rec_id
              FROM gicl_rcvry_brdrx_ds_extr;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rcvry_brdrx_ds_rec_id := 0;
         END;

         --distributed recoveries
         FOR rcvry_ds1_a IN rcvry_dist (v_session_id)
         LOOP
            FOR rcvry_ds1_b IN
               (SELECT a.rec_dist_no, a.dist_year, a.grp_seq_no,
                       a.share_type, a.share_pct,
                         (a.share_pct * NVL (rcvry_ds1_a.recovered_amt, 0)
                         )
                       / 100 shr_rcvry_amt_ds
                  FROM gicl_recovery_ds a
                 WHERE a.recovery_id = rcvry_ds1_a.recovery_id
                   AND a.recovery_payt_id = rcvry_ds1_a.recovery_payt_id
                   AND NVL (a.negate_tag, 'N') = 'N')
            LOOP
               v_rcvry_brdrx_ds_rec_id := NVL (v_rcvry_brdrx_ds_rec_id, 0)
                                          + 1;

               INSERT INTO gicl_rcvry_brdrx_ds_extr
                           (session_id, rcvry_brdrx_record_id,
                            rcvry_brdrx_ds_record_id, claim_id,
                            recovery_id,
                            recovery_payt_id,
                            line_cd, subline_cd,
                            iss_cd, item_no,
                            peril_cd, recovered_amt,
                            rec_dist_no, dist_year,
                            grp_seq_no, share_type,
                            share_pct,
                            shr_recovery_amt,
                            acct_tran_id, payee_type
                           )
                    VALUES (v_session_id, rcvry_ds1_a.rcvry_brdrx_record_id,
                            v_rcvry_brdrx_ds_rec_id, rcvry_ds1_a.claim_id,
                            rcvry_ds1_a.recovery_id,
                            rcvry_ds1_a.recovery_payt_id,
                            rcvry_ds1_a.line_cd, rcvry_ds1_a.subline_cd,
                            rcvry_ds1_a.iss_cd, rcvry_ds1_a.item_no,
                            rcvry_ds1_a.peril_cd, rcvry_ds1_a.recovered_amt,
                            rcvry_ds1_b.rec_dist_no, rcvry_ds1_b.dist_year,
                            rcvry_ds1_b.grp_seq_no, rcvry_ds1_b.share_type,
                            rcvry_ds1_b.share_pct,
                            rcvry_ds1_b.shr_rcvry_amt_ds,
                            rcvry_ds1_a.acct_tran_id, rcvry_ds1_a.payee_type
                           );

               --RI distribution details
               FOR rcvry_rids_b IN
                  (SELECT a.share_type, a.ri_cd, a.share_ri_pct,
                          (  a.share_ri_pct
                           / rcvry_ds1_b.share_pct
                           * rcvry_ds1_b.shr_rcvry_amt_ds
                          ) shr_rcvry_amt_rids
                     FROM gicl_recovery_rids a
                    WHERE a.recovery_id = rcvry_ds1_a.recovery_id
                      AND a.recovery_payt_id = rcvry_ds1_a.recovery_payt_id
                      AND a.rec_dist_no = rcvry_ds1_b.rec_dist_no
                      AND a.grp_seq_no = rcvry_ds1_b.grp_seq_no
                      AND NVL (a.negate_tag, 'N') = 'N')
               LOOP
                  v_rcvry_brdrx_rids_rec_id :=
                                        NVL (v_rcvry_brdrx_rids_rec_id, 0)
                                        + 1;

                  INSERT INTO gicl_rcvry_brdrx_rids_extr
                              (session_id, rcvry_brdrx_ds_record_id,
                               rcvry_brdrx_rids_record_id,
                               claim_id,
                               recovery_id,
                               recovery_payt_id,
                               line_cd, subline_cd,
                               iss_cd, item_no,
                               peril_cd,
                               rec_dist_no,
                               dist_year,
                               grp_seq_no,
                               share_type, ri_cd,
                               share_ri_pct,
                               shr_ri_recovery_amt,
                               acct_tran_id,
                               payee_type
                              )
                       VALUES (v_session_id, v_rcvry_brdrx_ds_rec_id,
                               v_rcvry_brdrx_rids_rec_id,
                               rcvry_ds1_a.claim_id,
                               rcvry_ds1_a.recovery_id,
                               rcvry_ds1_a.recovery_payt_id,
                               rcvry_ds1_a.line_cd, rcvry_ds1_a.subline_cd,
                               rcvry_ds1_a.iss_cd, rcvry_ds1_a.item_no,
                               rcvry_ds1_a.peril_cd,
                               rcvry_ds1_b.rec_dist_no,
                               rcvry_ds1_b.dist_year,
                               rcvry_ds1_b.grp_seq_no,
                               rcvry_ds1_b.share_type, rcvry_rids_b.ri_cd,
                               rcvry_rids_b.share_ri_pct,
                               rcvry_rids_b.shr_rcvry_amt_rids,
                               rcvry_ds1_a.acct_tran_id,
                               rcvry_ds1_a.payee_type
                              );
               END LOOP;
            END LOOP;
         END LOOP;

         --COMMIT;

         --undistributed recoveries
         FOR rcvry_ds2 IN rcvry_undist (v_session_id)
         LOOP
            v_rcvry_brdrx_ds_rec_id := NVL (v_rcvry_brdrx_ds_rec_id, 0) + 1;

            INSERT INTO gicl_rcvry_brdrx_ds_extr
                        (session_id, rcvry_brdrx_record_id,
                         rcvry_brdrx_ds_record_id, claim_id,
                         recovery_id, recovery_payt_id,
                         line_cd, subline_cd,
                         iss_cd, item_no,
                         peril_cd, recovered_amt,
                         rec_dist_no, dist_year,
                         grp_seq_no, share_type,
                         share_pct, shr_recovery_amt,
                         acct_tran_id, payee_type
                        )
                 VALUES (v_session_id, rcvry_ds2.rcvry_brdrx_record_id,
                         v_rcvry_brdrx_ds_rec_id, rcvry_ds2.claim_id,
                         rcvry_ds2.recovery_id, rcvry_ds2.recovery_payt_id,
                         rcvry_ds2.line_cd, rcvry_ds2.subline_cd,
                         rcvry_ds2.iss_cd, rcvry_ds2.item_no,
                         rcvry_ds2.peril_cd, rcvry_ds2.recovered_amt,
                         rcvry_ds2.rec_dist_no, rcvry_ds2.dist_year,
                         rcvry_ds2.grp_seq_no, rcvry_ds2.share_type,
                         rcvry_ds2.share_pct, rcvry_ds2.shr_recovery_amt,
                         rcvry_ds2.acct_tran_id, rcvry_ds2.payee_type
                        );
         END LOOP;

         --COMMIT;

         -- update buss_source column in all recovery brdrx tables
         FOR bs IN (SELECT DISTINCT session_id, claim_id, item_no, peril_cd,
                                    buss_source
                               FROM gicl_res_brdrx_extr
                              WHERE claim_id IN (
                                               SELECT claim_id
                                                 FROM gicl_rcvry_brdrx_extr
                                                WHERE session_id =
                                                                  v_session_id)
                                AND session_id = v_session_id)
         LOOP
            UPDATE gicl_rcvry_brdrx_extr
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;

            UPDATE gicl_rcvry_brdrx_ds_extr
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;

            UPDATE gicl_rcvry_brdrx_rids_extr
            
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;
         END LOOP;
      END IF;

      --COMMIT;
   END extract_distribution;

   FUNCTION get_parent_intm (
      p_intrmdry_intm_no   IN   giis_intermediary.intm_no%TYPE
   )
      RETURN NUMBER
   IS
      v_intm_no   giis_intermediary.intm_no%TYPE;
   BEGIN
      BEGIN
         SELECT     NVL (a.parent_intm_no, a.intm_no)
               INTO v_intm_no
               FROM giis_intermediary a
              WHERE LEVEL =
                       (SELECT     MAX (LEVEL)
                              FROM giis_intermediary b
                        CONNECT BY PRIOR b.parent_intm_no = b.intm_no
                               AND lic_tag = 'N'
                        START WITH b.intm_no = p_intrmdry_intm_no
                               AND lic_tag = 'N')
         CONNECT BY PRIOR a.parent_intm_no = a.intm_no
         START WITH a.intm_no = p_intrmdry_intm_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_intm_no := p_intrmdry_intm_no;
         WHEN OTHERS
         THEN
            NULL;
      END;

      RETURN v_intm_no;
   END get_parent_intm;

   FUNCTION get_tot_prem_amt (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_item_no    IN   gicl_item_peril.item_no%TYPE,
      p_peril_cd   IN   gicl_item_peril.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_tot_prem_amt   gipi_itmperil.prem_amt%TYPE;
   BEGIN
      BEGIN
         SELECT SUM (b.prem_amt) tot_prem_amt
           INTO v_tot_prem_amt
           FROM gipi_polbasic a,
                gipi_itmperil b,
                gicl_claims c,
                giuw_pol_dist d
          WHERE b.peril_cd = p_peril_cd
            AND b.item_no = p_item_no
            AND b.policy_id = a.policy_id
            AND c.loss_date >= a.eff_date
            AND c.loss_date <= NVL (a.endt_expiry_date, a.expiry_date)
            AND a.policy_id = d.policy_id
            AND d.dist_flag = '3'
            AND a.line_cd = c.line_cd
            AND a.subline_cd = c.subline_cd
            AND a.iss_cd = c.pol_iss_cd
            AND a.issue_yy = c.issue_yy
            AND a.pol_seq_no = c.pol_seq_no
            AND a.renew_no = c.renew_no
            AND c.claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tot_prem_amt := 0;
      END;

      RETURN (v_tot_prem_amt);
   END get_tot_prem_amt;

   FUNCTION check_close_date1 (
      p_brdrx_type   IN   NUMBER,
      p_claim_id     IN   gicl_claims.claim_id%TYPE,
      p_item_no      IN   gicl_item_peril.item_no%TYPE,
      p_peril_cd     IN   gicl_item_peril.peril_cd%TYPE,
      p_date         IN   DATE
   )
      RETURN NUMBER
   IS
      v_valid   NUMBER (1) := 0;
   BEGIN
      FOR i IN (SELECT 1
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND (   (    (a.close_date > p_date OR a.close_date IS NULL
                                )
                            AND p_brdrx_type = 1
                           )
                        OR p_brdrx_type = 2
                       )
                        --(DECODE(a.close_flag, 'WD', a.close_date, 'DN', a.close_date, p_date + 1) > p_date AND p_brdrx_type = 2))
                        --exclude record if CLOSE_DATE of invalid peril status is later than parameter date used in extracting Losses Paid by MAC 08/16/2013.
                        --exclude checking of close_flag if extracting Losses Paid by MAC 08/28/2013.
                        --(DECODE(a.close_flag, 'AP', p_date + 1, 'CP', p_date + 1, 'CC', p_date + 1, a.close_date) > p_date AND p_brdrx_type = 2))
              )
      LOOP
         v_valid := 1;
      END LOOP;

      RETURN (v_valid);
   END check_close_date1;

   FUNCTION check_close_date2 (
      p_brdrx_type   IN   NUMBER,
      p_claim_id     IN   gicl_claims.claim_id%TYPE,
      p_item_no      IN   gicl_item_peril.item_no%TYPE,
      p_peril_cd     IN   gicl_item_peril.peril_cd%TYPE,
      p_date         IN   DATE
   )
      RETURN NUMBER
   IS
      v_valid   NUMBER (1) := 0;
   BEGIN
      FOR i IN (SELECT 1
                  FROM gicl_item_peril a
                 WHERE a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND (   (    (   a.close_date2 > p_date
                                 OR a.close_date2 IS NULL
                                )
                            AND p_brdrx_type = 1
                           )
                        OR p_brdrx_type = 2
                       )
                        --(DECODE(a.close_flag2, 'WD', a.close_date2, 'DN', a.close_date2, p_date + 1) > p_date AND p_brdrx_type = 2))
                        --exclude record if CLOSE_DATE of invalid peril status is later than parameter date used in extracting Losses Paid by MAC 08/16/2013.
                        --exclude checking of close_flag2 if extracting Losses Paid by MAC 08/28/2013.
                        --(DECODE(a.close_flag2, 'AP', p_date + 1, 'CP', p_date + 1, 'CC', p_date + 1, a.close_date2) > p_date AND p_brdrx_type = 2))
              )
      LOOP
         v_valid := 1;
      END LOOP;

      RETURN (v_valid);
   END check_close_date2;

   FUNCTION get_reversal (
      p_tran_id            IN   gicl_clm_res_hist.tran_id%TYPE,
      p_from_date          IN   DATE,
      p_to_date            IN   DATE,
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE
   )
      RETURN NUMBER
   IS
      v_multiplier   NUMBER (1) := 1;
   BEGIN
      IF p_paid_date_option IS NULL
      THEN
         RETURN (v_multiplier);
      END IF;

      /*comment out by MAC 07/17/2013
      FOR i IN (SELECT gacc_tran_id
                  FROM giac_reversals
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         FOR ii IN (SELECT DISTINCT DECODE(p_paid_date_option, 1, TRUNC(date_paid), 2, TRUNC(posting_date)) date_paid, TRUNC(cancel_date) cancel_date
                      FROM gicl_clm_res_hist a, giac_acctrans b
                     WHERE cancel_tag = 'Y'
                       AND a.tran_id = i.gacc_tran_id
                       AND a.tran_id = b.tran_id)
         LOOP
             IF (ii.cancel_date <= p_to_date) AND (ii.date_paid BETWEEN p_from_date AND p_to_date) THEN
                 v_multiplier := 0; --return 0 amount if cancellation happens on or before TO date parameter and payment happens between parameter date
             ELSIF (ii.cancel_date BETWEEN p_from_date AND p_to_date) AND (ii.date_paid < p_from_date) THEN
                 v_multiplier := -1; --return negative amount if payment happens before FROM date parameter
             END IF;
         END LOOP;
      END LOOP;*/

      --return negative amount if posting date or tran date of reversal is between parameter date by MAC 07/17/2013.
      FOR i IN (SELECT DISTINCT 1
                           FROM giac_reversals a, giac_acctrans b
                          WHERE a.reversing_tran_id = b.tran_id
                            AND a.gacc_tran_id = p_tran_id
                            AND DECODE (p_paid_date_option,
                                        1, TRUNC (tran_date),
                                        2, TRUNC (posting_date)
                                       ) BETWEEN p_from_date AND p_to_date)
      LOOP
         v_multiplier := -1;

         FOR ii IN (SELECT 1
                      FROM gicl_clm_res_hist a, giac_acctrans b
                     WHERE a.tran_id = b.tran_id
                       AND a.tran_id = p_tran_id
                       AND DECODE (p_paid_date_option,
                                   1, TRUNC (tran_date),
                                   2, TRUNC (posting_date)
                                  ) BETWEEN p_from_date AND p_to_date)
         LOOP
            --Return zero if Date Paid and Reversal is included in extraction. Changes is only applied if Based on Tran Date by MAC 08/16/2013.
            --IF p_paid_date_option = 1 THEN comment out by MAC 09/10/2013
            v_multiplier := 0;
         --END IF;
         END LOOP;
      END LOOP;

      RETURN (v_multiplier);
   END get_reversal;

   FUNCTION get_voucher_check_no (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_item_no            IN   gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd           IN   gicl_clm_res_hist.peril_cd%TYPE,
      p_grouped_item_no    IN   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_dsp_from_date      IN   DATE,
      p_dsp_to_date        IN   DATE,
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_payee_type         IN   VARCHAR
   )
      RETURN VARCHAR
   IS
      var_dv_no   VARCHAR2 (11000); --modified by AlizaG  from 4000 to 110000 for SR 0020522
   BEGIN
      FOR i IN
         (SELECT a.tran_id,
                 DECODE (c.gacc_tran_id,
                         NULL, NULL,
                            ' /'
                         || c.check_pref_suf
                         || '-'
                         || LPAD (c.check_no, 10, 0)
                        ) check_no,
                 TO_CHAR (NVL (a.cancel_date, SYSDATE),
                          'MM/DD/YYYY'
                         ) cancel_date
            FROM gicl_clm_res_hist a,
                 giac_acctrans b,
                 giac_chk_disbursement c
           WHERE a.claim_id = p_claim_id
             AND a.item_no = NVL (p_item_no, a.item_no)
             AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
             AND a.grouped_item_no =
                                    NVL (p_grouped_item_no, a.grouped_item_no)
             AND a.tran_id IS NOT NULL
             AND a.tran_id = b.tran_id
             AND a.tran_id = c.gacc_tran_id(+)
             AND b.tran_flag != 'D'
             AND (   TRUNC (DECODE (p_paid_date_option,
                                    1, a.date_paid,
                                    2, b.posting_date
                                   )
                           ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND (   DECODE (a.cancel_tag,
                             'Y', TRUNC (a.cancel_date),
                             (p_dsp_to_date + 1)
                            ) > p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND DECODE (p_payee_type,
                         'L', NVL (a.losses_paid, 0),
                         'E', NVL (a.expenses_paid, 0)
                        ) <> 0)
      LOOP
         IF gicls202_extraction_pkg.get_reversal (i.tran_id,
                                                  p_dsp_from_date,
                                                  p_dsp_to_date,
                                                  p_paid_date_option
                                                 ) <> 1
         THEN
            IF var_dv_no IS NULL
            THEN
               var_dv_no :=
                     get_ref_no (i.tran_id)
                  || i.check_no
                  || ' cancelled '
                  || i.cancel_date;
            ELSE
               var_dv_no :=
                     var_dv_no
                  || CHR (10)
                  || get_ref_no (i.tran_id)
                  || i.check_no
                  || ' cancelled '
                  || i.cancel_date;
            END IF;
         ELSE
            IF var_dv_no IS NULL
            THEN
               var_dv_no := get_ref_no (i.tran_id) || i.check_no;
            ELSE
               var_dv_no :=
                  var_dv_no || CHR (10) || get_ref_no (i.tran_id)
                  || i.check_no;
            END IF;
         END IF;
      END LOOP;

      RETURN (var_dv_no);
   END get_voucher_check_no;

   FUNCTION get_giclr209_dtl (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_dsp_from_date      IN   DATE,
      p_dsp_to_date        IN   DATE,
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_payee_type         IN   VARCHAR,
      p_type               IN   VARCHAR
   )
      RETURN VARCHAR
   IS
      var_dv_no   VARCHAR2 (11000); --modified by Aliza G. from 4000 to 11000 01/28/2016 SR 21495
   BEGIN
      FOR i IN
         (SELECT a.tran_id,
                 DECODE (c.gacc_tran_id,
                         NULL, NULL,
                         c.check_pref_suf || '-' || LPAD (c.check_no, 10, 0)
                        ) check_no,
                 TO_CHAR (NVL (a.cancel_date, SYSDATE),
                          'MM-DD-YYYY'
                         ) cancel_date,
                 TO_CHAR (a.date_paid, 'MM-DD-YYYY') tran_date
            FROM gicl_clm_res_hist a,
                 giac_acctrans b,
                 giac_chk_disbursement c
           WHERE a.claim_id = p_claim_id
             AND a.tran_id IS NOT NULL
             AND a.tran_id = b.tran_id
             AND a.tran_id = c.gacc_tran_id(+)
             AND b.tran_flag != 'D'
             AND (   TRUNC (DECODE (p_paid_date_option,
                                    1, a.date_paid,
                                    2, b.posting_date
                                   )
                           ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND (   DECODE (a.cancel_tag,
                             'Y', TRUNC (a.cancel_date),
                             (p_dsp_to_date + 1)
                            ) > p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND DECODE (p_payee_type,
                         'L', NVL (a.losses_paid, 0),
                         'E', NVL (a.expenses_paid, 0)
                        ) <> 0)
      LOOP
         IF    (p_type = 'CHECK_NO' AND i.check_no IS NOT NULL)
            OR (p_type = 'TRAN_DATE' AND i.tran_date IS NOT NULL)
            OR (p_type = 'ITEM_STAT_CD')
         THEN
            IF p_type = 'CHECK_NO'
            THEN
               IF gicls202_extraction_pkg.get_reversal (i.tran_id,
                                                        p_dsp_from_date,
                                                        p_dsp_to_date,
                                                        p_paid_date_option
                                                       ) <> 1
               THEN
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no :=
                                 i.check_no || ' cancelled ' || i.cancel_date;
                  ELSE
                     var_dv_no :=
                           var_dv_no
                        || CHR (10)
                        || i.check_no
                        || ' cancelled '
                        || i.cancel_date;
                  END IF;
               ELSE
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no := i.check_no;
                  ELSE
                     var_dv_no := var_dv_no || CHR (10) || i.check_no;
                  END IF;
               END IF;
            ELSIF p_type = 'TRAN_DATE'
            THEN
               IF var_dv_no IS NULL
               THEN
                  var_dv_no := i.tran_date;
               ELSE
                  var_dv_no := var_dv_no || CHR (10) || i.tran_date;
               END IF;
            ELSIF p_type = 'ITEM_STAT_CD'
            THEN
               FOR ii IN (SELECT item_stat_cd
                            FROM gicl_clm_loss_exp
                           WHERE payee_type = p_payee_type
                             AND tran_id = i.tran_id)
               LOOP
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no := ii.item_stat_cd;
                  ELSE
                     var_dv_no := var_dv_no || CHR (10) || ii.item_stat_cd;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      RETURN (var_dv_no);
   END get_giclr209_dtl;
   
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
    )
    IS
        v_count             NUMBER := 0;
    BEGIN
        BEGIN
            SELECT 1
              INTO v_count
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_count := 0;
        END;
        
        IF v_count > 0 THEN
            MERGE INTO gicl_res_brdrx_extr_param
            USING DUAL ON (user_id = p_user_id)
             WHEN NOT MATCHED THEN
                  INSERT(line_cd, subline_cd, iss_cd, peril_cd, intm_no, loss_cat_cd, enrollee, control_type, control_number,
                          pol_line_cd, pol_subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, as_of_date, per_buss, per_issource,
                          per_line_subline, per_policy, per_enrollee, per_line, per_branch, per_intm, per_loss_cat, user_id)
                  VALUES(p_dsp_line_cd, p_dsp_subline_cd, p_dsp_iss_cd, p_dsp_peril_cd, p_dsp_intm_no, p_dsp_loss_cat_cd, p_dsp_enrollee, p_dsp_control_type, p_dsp_control_number,
                          p_dsp_line_cd2, p_dsp_subline_cd2, p_dsp_iss_cd2, p_issue_yy, p_pol_seq_no, p_renew_no, p_dsp_as_of_date, p_per_buss, p_per_issource,
                          p_per_line_subline, p_per_policy, p_per_enrollee, p_per_line, p_per_iss, p_per_intermediary, p_per_loss_cat, p_user_id)
             WHEN MATCHED THEN
           UPDATE
              SET line_cd = p_dsp_line_cd,
                  subline_cd = p_dsp_subline_cd,
                  iss_cd = p_dsp_iss_cd,
                  peril_cd = p_dsp_peril_cd, 
                  intm_no = p_dsp_intm_no, 
                  loss_cat_cd = p_dsp_loss_cat_cd, 
                  enrollee = p_dsp_enrollee, 
                  control_type = p_dsp_control_type, 
                  control_number = p_dsp_control_number,
                  pol_line_cd = p_dsp_line_cd2, 
                  pol_subline_cd = p_dsp_subline_cd2, 
                  pol_iss_cd = p_dsp_iss_cd2, 
                  issue_yy = p_issue_yy, 
                  pol_seq_no = p_pol_seq_no, 
                  renew_no = p_renew_no,
                  as_of_date = p_dsp_as_of_date,
                  per_buss = p_per_buss, 
                  per_issource = p_per_issource,
                  per_line_subline = p_per_line_subline, 
                  per_policy = p_per_policy, 
                  per_enrollee = p_per_enrollee, 
                  per_line = p_per_line, 
                  per_branch = p_per_iss, 
                  per_intm = p_per_intermediary, 
                  per_loss_cat = p_per_loss_cat;
        ELSE
            DELETE
              FROM gicl_res_brdrx_extr_param
             WHERE user_id = p_user_id;
        END IF;
    END;
    
END gicls202_extraction_pkg; 
/
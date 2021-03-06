DROP PROCEDURE CPI.SETUP_FOUR_GICLB001;

CREATE OR REPLACE PROCEDURE CPI.setup_four_giclb001(
    p_branch_cd             IN  GICL_CLAIMS.iss_cd%TYPE,
    p_tran_id               IN  GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
    p_gen_type              IN  GIAC_MODULES.generation_type%TYPE,
    p_module_id             IN  GIAC_MODULE_ENTRIES.module_id%TYPE,
    p_fund_cd               IN  GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
    p_user_id               IN  GIAC_ACCT_ENTRIES.user_id%TYPE,
    p_ri_recov              IN  VARCHAR2,
    p_separate_xol_entries  IN  VARCHAR2,
    p_message              OUT  VARCHAR2,
    p_message_type         OUT  VARCHAR2
) 
IS

    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.18.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  SETUP_FOUR program unit; 
    **                     Setup FOUR - OS_BOOKING_EXP = 'Y' and module entry for expenses is not null      
    */

  /* 
  ** UNPAID LOSSES -DIRECT-NET
  */
  cursor ULDL is (SELECT sum(a.os_loss * (d.shr_pct/100)) os_loss, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a,
                         gicl_reserve_ds d 
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND b.claim_id = d.claim_id
                     AND b.clm_res_hist_id = d.clm_res_hist_id
                     AND to_char(d.clm_dist_no) = a.dist_no
                     AND d.share_type = 1
                     AND a.acct_date is null
                     AND c.pol_iss_cd <> 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  cursor ULDE is (SELECT sum(a.os_expense * (d.shr_pct/100)) os_exp, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a,
                         gicl_reserve_ds d 
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND b.claim_id = d.claim_id
                     AND b.clm_res_hist_id = d.clm_res_hist_id
                     AND to_char(d.clm_dist_no) = a.dist_no
                     AND d.share_type = 1
                     AND a.acct_date is null
                     AND c.pol_iss_cd <> 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  /* 
  ** UNPAID LOSSES -NET RI
  */
  cursor ULRL is (SELECT sum(a.os_loss * (d.shr_pct/100)) os_loss, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a,
                         gicl_reserve_ds d 
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND b.claim_id = d.claim_id
                     AND b.clm_res_hist_id = d.clm_res_hist_id
                     AND to_char(d.clm_dist_no) = a.dist_no
                     AND d.share_type = 1
                     AND a.acct_date is null
                     AND c.pol_iss_cd = 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  cursor ULRE is (SELECT sum(a.os_expense * (d.shr_pct/100)) os_exp, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a,
                         gicl_reserve_ds d 
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND b.claim_id = d.claim_id
                     AND b.clm_res_hist_id = d.clm_res_hist_id
                     AND to_char(d.clm_dist_no) = a.dist_no
                     AND d.share_type = 1
                     AND a.acct_date is null
                     AND c.pol_iss_cd = 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  /* 
  ** CLAIMS PAYABLE - GROSS -DIRECT
  */
  cursor ULDLG is (SELECT sum(a.os_loss) os_loss, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND a.acct_date is null
                     AND c.pol_iss_cd <> 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  cursor ULDEG is (SELECT sum(a.os_expense) os_exp, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND a.acct_date is null
                     AND c.pol_iss_cd <> 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  /* 
  ** CLAIMS PAYABLE - GROSS - RI
  */
  cursor ULRLG is (SELECT sum(a.os_loss) os_loss, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND a.acct_date is null
                     AND c.pol_iss_cd = 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);

  cursor ULREG is (SELECT sum(a.os_expense) os_exp, b.peril_cd, a.acct_intm_cd, 
                         c.line_cd, c.subline_cd
                    FROM gicl_claims c, gicl_clm_res_hist b, gicl_take_up_hist a
                   WHERE c.claim_id = b.claim_id
                     AND b.claim_id = a.claim_id
                     AND b.clm_res_hist_id = a.clm_res_hist_id
                     AND a.acct_date is null
                     AND c.pol_iss_cd = 'RI'
                     AND a.iss_cd = p_branch_cd
                GROUP BY b.peril_cd, a.acct_intm_cd, c.line_cd, c.subline_cd);


  /* 
  ** RECOVERABLE FROM REINSURERS (break on reinsurer) 
  ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
  ** combined LOSS and EXPENSE
  */
  cursor RFRLD is (SELECT sum((a.os_loss * (d.shr_ri_pct/100)) + (a.os_expense * (d.shr_ri_pct/100))) os_loss,
                          a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type
                     FROM gicl_take_up_hist a, gicl_clm_res_hist c,
                          gicl_reserve_ds b, gicl_reserve_rids d
                    WHERE a.claim_id = c.claim_id
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND c.claim_id = b.claim_id
                      AND c.clm_res_hist_id = b.clm_res_hist_id
                      AND b.claim_id = d.claim_id
                      AND b.clm_res_hist_id = d.clm_res_hist_id
                      AND b.clm_dist_no = d.clm_dist_no
                      AND to_char(d.clm_dist_no) = a.dist_no
                      AND b.grp_seq_no = d.grp_seq_no
                      AND a.acct_date is null
                      AND a.iss_cd = p_branch_cd
                 GROUP BY a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type);
                          
-- added by judyann 03062006
-- for separate generation of RI recoverable entries for losses and expenses

  /* 
  ** RECOVERABLE FROM REINSURERS (break on reinsurer) 
  ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
  ** separated LOSS and EXPENSE
  */
  cursor RFRUL is (SELECT SUM((a.os_loss * (d.shr_ri_pct/100)))  os_loss,
                          a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type
                     FROM gicl_take_up_hist a, gicl_clm_res_hist c,
                          gicl_reserve_ds b, gicl_reserve_rids d
                    WHERE a.claim_id = c.claim_id
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND c.claim_id = b.claim_id
                      AND c.clm_res_hist_id = b.clm_res_hist_id
                      AND b.claim_id = d.claim_id
                      AND b.clm_res_hist_id = d.clm_res_hist_id
                      AND b.clm_dist_no = d.clm_dist_no
                      AND to_char(d.clm_dist_no) = a.dist_no
                      AND b.grp_seq_no = d.grp_seq_no
                      AND a.acct_date is null
                      AND a.iss_cd = p_branch_cd
                      AND a.os_loss <> 0
                 GROUP BY a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type);

  cursor RFRUE is (SELECT SUM((a.os_expense * (d.shr_ri_pct/100)))  os_expense,
                          a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type
                     FROM gicl_take_up_hist a, gicl_clm_res_hist c,
                          gicl_reserve_ds b, gicl_reserve_rids d
                    WHERE a.claim_id = c.claim_id
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND c.claim_id = b.claim_id
                      AND c.clm_res_hist_id = b.clm_res_hist_id
                      AND b.claim_id = d.claim_id
                      AND b.clm_res_hist_id = d.clm_res_hist_id
                      AND b.clm_dist_no = d.clm_dist_no
                      AND to_char(d.clm_dist_no) = a.dist_no
                      AND b.grp_seq_no = d.grp_seq_no
                      AND a.acct_date is null
                      AND a.iss_cd = p_branch_cd
                      AND a.os_expense <> 0
                 GROUP BY a.acct_intm_cd, b.line_cd, d.share_type, d.grp_seq_no,
                          d.ri_cd, d.acct_trty_type);                          

                       

  dismt              giac_direct_claim_payts.disbursement_amt%type;
  sum_deb            gicl_acct_entries.debit_amt%type;
  ws_misc_entries    giac_direct_claim_payts.disbursement_amt%type;
  
  v_claim_sl_cd   	 giac_parameters.param_value_n%type;
  v_ri_sl_type		 giac_sl_types.sl_type_cd%type;
  v_trty_shr_type	 giis_dist_share.share_type%type;
  v_xol_shr_type	 giis_dist_share.share_type%type;
  v_facul_shr_type	 giis_dist_share.share_type%type;
  v_item_no          giac_module_entries.item_no%type := 1;
BEGIN

  BEGIN
    SELECT param_value_n
      INTO v_claim_sl_cd
      FROM giac_parameters
     WHERE param_name = 'CLAIMS_SL_CD';
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --MSG_ALERT('No existing CLAIMS_SL_CD parameter on GIAC_PARAMETERS.','I',false);
     p_message := 'No existing CLAIMS_SL_CD parameter on GIAC_PARAMETERS.';
     p_message_type := 'I';
     v_claim_sl_cd := 2;
  END;
  
  BEGIN
    SELECT param_value_v
      INTO v_xol_shr_type
      FROM giac_parameters
     WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --MSG_ALERT('No existing XOL_TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.','I',false);
     p_message := 'No existing XOL_TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.';
     p_message_type := 'I';
     v_xol_shr_type := 4;
  END;
  
  BEGIN
    SELECT param_value_v
      INTO v_ri_sl_type
      FROM giac_parameters
     WHERE param_name = 'RI_SL_TYPE';
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --MSG_ALERT('No existing RI_SL_TYPE parameter on GIAC_PARAMETERS.','I',false);
     p_message := 'No existing RI_SL_TYPE parameter on GIAC_PARAMETERS.';
     p_message_type := 'I';
     v_ri_sl_type := 2;
  END;

  BEGIN
    SELECT param_value_v
      INTO v_trty_shr_type
      FROM giac_parameters
     WHERE param_name = 'TRTY_SHARE_TYPE';
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --MSG_ALERT('No existing TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.','I',false);
     p_message := 'No existing TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.';
     p_message_type := 'I';
     v_trty_shr_type := 2;
  END;

  BEGIN
    SELECT param_value_v
      INTO v_facul_shr_type
      FROM giac_parameters
     WHERE param_name = 'FACUL_SHARE_TYPE';
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --MSG_ALERT('No existing FACUL_SHARE_TYPE parameter on GIAC_PARAMETERS.','I',false);
     p_message := 'No existing FACUL_SHARE_TYPE parameter on GIAC_PARAMETERS.';
     p_message_type := 'I';
     v_facul_shr_type := 3;
  END;

  /*
  ** Call the deletion of accounting entry procedure.
  */
  --
  giac_acct_entries_pkg.aeg_delete_acct_entries(p_tran_id, p_gen_type);
  --
  
  /*
  ** Call the accounting entry generation procedure.
  */

  FOR uldl_rec in uldl LOOP
    v_item_no := 1;    /* for UNPAID LOSSES - DIRECT */
    aeg_crt_acct_entr_giclb001( uldl_rec.peril_cd       ,
                                p_module_id             ,
                                v_item_no               ,
                                uldl_rec.acct_intm_cd   ,
                                uldl_rec.line_cd        ,
                                uldl_rec.subline_cd     ,
                                null                    ,
                                uldl_rec.os_loss        ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR uldlg_rec in uldlg LOOP
    v_item_no := 9;    /* for LOSSES and CLAIMS PAYABLE - DIRECT */
    aeg_crt_acct_entr_giclb001( uldlg_rec.peril_cd      ,
                                p_module_id             ,
                                v_item_no               ,
                                uldlg_rec.acct_intm_cd  ,
                                uldlg_rec.line_cd       ,
                                uldlg_rec.subline_cd    ,
                                null                    ,
                                uldlg_rec.os_loss       ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR ulde_rec in ulde LOOP
    v_item_no := 2;    /* for UNPAID LOSS/EXPENSE - DIRECT */
    aeg_crt_acct_entr_giclb001( ulde_rec.peril_cd       ,
                                p_module_id             ,
                                v_item_no               ,
                                ulde_rec.acct_intm_cd   ,
                                ulde_rec.line_cd        ,
                                ulde_rec.subline_cd     ,
                                null                    ,
                                ulde_rec.os_exp         ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR uldeg_rec in uldeg LOOP
    v_item_no := 10;    /* for LOSS/EXPENSE and CLAIMS PAYABLE- DIRECT */
    aeg_crt_acct_entr_giclb001( uldeg_rec.peril_cd      ,
                                p_module_id             ,
                                v_item_no               ,
                                uldeg_rec.acct_intm_cd  ,
                                uldeg_rec.line_cd       ,
                                uldeg_rec.subline_cd    ,
                                null                    ,
                                uldeg_rec.os_exp        ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR ulrl_rec in ulrl LOOP
    v_item_no := 3;    /* for UNPAID LOSSES - FACUL */
    aeg_crt_acct_entr_giclb001( ulrl_rec.peril_cd       ,
                                p_module_id             ,
                                v_item_no               ,
                                ulrl_rec.acct_intm_cd   ,
                                ulrl_rec.line_cd        ,
                                ulrl_rec.subline_cd     ,
                                null                    ,
                                ulrl_rec.os_loss        ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR ulrlg_rec in ulrlg LOOP
    v_item_no := 11;    /* for LOSSES and CLMS PAYABLE - FACUL */
    aeg_crt_acct_entr_giclb001( ulrlg_rec.peril_cd      ,
                                p_module_id             ,
                                v_item_no               ,
                                ulrlg_rec.acct_intm_cd  ,
                                ulrlg_rec.line_cd       ,
                                ulrlg_rec.subline_cd    ,
                                null                    ,
                                ulrlg_rec.os_loss       ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR ulre_rec in ulre LOOP
    v_item_no := 4;    /* for UNPAID LOSS/EXPENSE - FACUL */
    aeg_crt_acct_entr_giclb001( ulre_rec.peril_cd       ,
                                p_module_id             ,
                                v_item_no               ,
                                ulre_rec.acct_intm_cd   ,
                                ulre_rec.line_cd        ,
                                ulre_rec.subline_cd     ,
                                null                    ,
                                ulre_rec.os_exp         ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;

  FOR ulreg_rec in ulreg LOOP
    v_item_no := 12;    /* for LOSSES/EXPENSES CLMS PAYABLE - FACUL */
    aeg_crt_acct_entr_giclb001( ulreg_rec.peril_cd      ,
                                p_module_id             ,
                                v_item_no               ,
                                ulreg_rec.acct_intm_cd  ,
                                ulreg_rec.line_cd       ,
                                ulreg_rec.subline_cd    ,
                                null                    ,
                                ulreg_rec.os_exp        ,
                                p_gen_type              ,
                                v_ri_sl_type            ,
                                v_claim_sl_cd           ,
                                p_branch_cd             ,
                                p_fund_cd               ,
                                p_tran_id               ,
                                p_user_id);
  END LOOP;
--
  IF p_ri_recov = 'N' THEN
     FOR rfrld_rec in rfrld LOOP
       IF rfrld_rec.share_type IN ( v_trty_shr_type, v_xol_shr_type) THEN
       /* check if xol share should be separated. reference: variable.v_separate_xol_entries
       ** if variable is Y and the share type = xol__shr_type, item number must be 16. Pia, 09.25.06 */
          IF p_separate_xol_entries = 'Y' AND
             rfrld_rec.share_type = v_xol_shr_type THEN
             v_item_no := 16;
          ELSE -- variable.v_separate_xol_entries = 'N'  or rfrld_rec.share_type != v_xol_shr_type             
             v_item_no := 5;    /* for RECOVERABLE FROM RI - TREATY */
          END IF;
          aeg_crt_acct_entr_giclb001( rfrld_rec.ri_cd           ,
                                      p_module_id               ,
                                      v_item_no                 ,
                                      rfrld_rec.acct_intm_cd    ,
                                      rfrld_rec.line_cd         ,
                                      null                      ,
                                      rfrld_rec.acct_trty_type  ,
                                      rfrld_rec.os_loss         ,
                                      p_gen_type                ,
                                      v_ri_sl_type              ,
                                      v_claim_sl_cd             ,
                                      p_branch_cd               ,
                                      p_fund_cd                 ,
                                      p_tran_id                 ,
                                      p_user_id);
       ELSIF rfrld_rec.share_type = v_facul_shr_type THEN
          v_item_no := 6;    /* for RECOVERABLE FROM RI - FACUL */
          aeg_crt_acct_entr_giclb001( rfrld_rec.ri_cd           ,
                                      p_module_id               ,
                                      v_item_no                 ,
                                      rfrld_rec.acct_intm_cd    ,
                                      rfrld_rec.line_cd         ,
                                      null                      ,
                                      rfrld_rec.acct_trty_type  ,
                                      rfrld_rec.os_loss         ,
                                      p_gen_type                ,
                                      v_ri_sl_type              ,
                                      v_claim_sl_cd             ,
                                      p_branch_cd               ,
                                      p_fund_cd                 ,
                                      p_tran_id                 ,
                                      p_user_id);

       END IF;
     END LOOP;
  ELSIF p_ri_recov = 'Y' THEN
     FOR rfrul_rec in rfrul LOOP
       IF rfrul_rec.share_type IN (v_trty_shr_type, v_xol_shr_type) THEN
       /* check if xol share should be separated. reference: variable.v_separate_xol_entries
       ** if variable is Y and the share type = xol__shr_type, item number must be 16. Pia, 09.25.06 */
          IF p_separate_xol_entries = 'Y' AND
             rfrul_rec.share_type = v_xol_shr_type THEN
             v_item_no := 16;
          ELSE -- variable.v_separate_xol_entries = 'N'  or rfrul_rec.share_type != v_xol_shr_type
             v_item_no := 5;    /* for RECOVERABLE FROM RI - TREATY */
          END IF;
          aeg_crt_acct_entr_giclb001( rfrul_rec.ri_cd           ,
                                      p_module_id               ,
                                      v_item_no                 ,
                                      rfrul_rec.acct_intm_cd    ,
                                      rfrul_rec.line_cd         ,
                                      null                      ,
                                      rfrul_rec.acct_trty_type  ,
                                      rfrul_rec.os_loss         ,
                                      p_gen_type                ,
                                      v_ri_sl_type              ,
                                      v_claim_sl_cd             ,
                                      p_branch_cd               ,
                                      p_fund_cd                 ,
                                      p_tran_id                 ,
                                      p_user_id);
       ELSIF rfrul_rec.share_type = v_facul_shr_type THEN
          v_item_no := 6;    /* for RECOVERABLE FROM RI - FACUL */
          aeg_crt_acct_entr_giclb001( rfrul_rec.ri_cd           ,
                                      p_module_id               ,
                                      v_item_no                 ,
                                      rfrul_rec.acct_intm_cd    ,
                                      rfrul_rec.line_cd         ,
                                      null                      ,
                                      rfrul_rec.acct_trty_type  ,
                                      rfrul_rec.os_loss         ,
                                      p_gen_type                ,
                                      v_ri_sl_type              ,
                                      v_claim_sl_cd             ,
                                      p_branch_cd               ,
                                      p_fund_cd                 ,
                                      p_tran_id                 ,
                                      p_user_id);
       END IF;
     END LOOP;  
     FOR rfrue_rec in rfrue LOOP
       IF rfrue_rec.share_type IN (v_trty_shr_type, v_xol_shr_type) THEN
             /* check if xol share should be separated. reference: variable.v_separate_xol_entries
             ** if variable is Y and the share type = xol__shr_type, item number must be 16. Pia, 09.25.06 */
                IF p_separate_xol_entries = 'Y' AND
                   rfrue_rec.share_type = v_xol_shr_type THEN
                   v_item_no := 17;
             ELSE -- variable.v_separate_xol_entries = 'N' or rfrue_rec.share_type != v_xol_shr_type
                v_item_no := 13;    /* for RECOVERABLE FROM RI - TREATY */
             END IF;
             aeg_crt_acct_entr_giclb001( rfrue_rec.ri_cd            ,
                                         p_module_id                ,
                                         v_item_no                  ,
                                         rfrue_rec.acct_intm_cd     ,
                                         rfrue_rec.line_cd          ,
                                         null                       ,
                                         rfrue_rec.acct_trty_type   ,
                                         rfrue_rec.os_expense       ,
                                         p_gen_type                 ,
                                         v_ri_sl_type               ,
                                         v_claim_sl_cd              ,
                                         p_branch_cd                ,
                                         p_fund_cd                  ,
                                         p_tran_id                  ,
                                         p_user_id);
       ELSIF rfrue_rec.share_type = v_facul_shr_type THEN
          v_item_no := 14;    /* for RECOVERABLE FROM RI - FACUL */
          aeg_crt_acct_entr_giclb001( rfrue_rec.ri_cd           ,
                                      p_module_id               ,
                                      v_item_no                 ,
                                      rfrue_rec.acct_intm_cd    ,
                                      rfrue_rec.line_cd         ,
                                      null                      ,
                                      rfrue_rec.acct_trty_type  ,
                                      rfrue_rec.os_expense      ,
                                      p_gen_type                ,
                                      v_ri_sl_type              ,
                                      v_claim_sl_cd             ,
                                      p_branch_cd               ,
                                      p_fund_cd                 ,
                                      p_tran_id                 ,
                                      p_user_id);
       END IF;       
     END LOOP;
  END IF;     
END;
/



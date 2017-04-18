CREATE OR REPLACE PACKAGE BODY CPI.gicl_take_up_hist_pkg
AS

    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  REVERSAL_NEXT_DAY program unit; 
    **                     This procedures create reversing accounting entries for
    **                     outstanding loss that had been created during the 
    **                     current transaction       
    */
    PROCEDURE reversal_next_day(
        p_dsp_date      giac_acctrans.tran_date%TYPE,
        p_user_id       giac_acctrans.user_id%TYPE
    ) 
    IS
      v_tran_id         giac_acctrans.tran_id%TYPE;     -- stores tran_id for acct entries to be generated  
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE; -- stores tran_seq_no for acct entries to be generated
    BEGIN
      --select the latest tran_date from gicl_take_up_hist so that all tran_id
      --from last extraction can be retrieved 
      FOR tran_date IN (
        SELECT MAX(tran_date) tran_date
          FROM gicl_take_up_hist
         WHERE acct_tran_id IS NOT NULL)
      LOOP
        --get all tran_id using tran_date as basis
        FOR old_id IN (
         SELECT DISTINCT acct_tran_id reverse_tran_id
           FROM gicl_take_up_hist
          WHERE tran_date = tran_date.tran_date
            AND acct_tran_id IS NOT NULL)
        LOOP
          --get value of tran_id
          BEGIN
            SELECT acctran_tran_id_s.nextval
              INTO v_tran_id
              FROM dual;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --lapse;               
            --msg_alert('ACCTRAN_TRAN_ID sequence not found.','E', TRUE);
            raise_application_error('-20001', 'ACCTRAN_TRAN_ID sequence not found.');
          END;
          --get info from giac_acctrans record to generate tran_seq_no and
          --to insert new record in giac_acctrans
          FOR acctrans IN (
            SELECT gfun_fund_cd, gibr_branch_cd, tran_flag, tran_class 
              FROM giac_acctrans
             WHERE tran_id = old_id.reverse_tran_id)
          LOOP
            v_tran_seq_no := giac_sequence_generation(acctrans.gfun_fund_cd,
                                                      acctrans.gibr_branch_cd,
                                                      'ACCTRAN_TRAN_SEQ_NO',
                                                      to_number(to_char(p_dsp_date + 1,'YYYY')),
                                                      to_number(to_char(p_dsp_date + 1,'MM')));
            --insert record in giac_acctrans
            INSERT INTO giac_acctrans(
              tran_id,     
              gfun_fund_cd, 
              gibr_branch_cd,
              tran_date,
              tran_flag,
              tran_class,
              tran_year, 
              tran_month, 
              tran_seq_no,
              user_id,          
              last_update,
              particulars)  --added by AlizaG. SR 5235
            VALUES(
              v_tran_id,       
              acctrans.gfun_fund_cd,
              acctrans.gibr_branch_cd,
              p_dsp_date +1, 
              'C',  
              'OLR',
              to_number(to_char(p_dsp_date +1,'YYYY')),
              to_number(to_char(p_dsp_date +1,'MM')),
              v_tran_seq_no,             
              p_user_id, 
              SYSDATE,
              'Reversal of Outstanding Losses Take-up for '||to_char(tran_date.tran_date,'fmMonth')||' '||to_char(tran_date.tran_date,'RRRR')); --added by AlizaG. SR 5235
            --select info of old tran_id to be used in insert
            FOR entry_data IN (
              SELECT gacc_gfun_fund_cd,  gacc_gibr_branch_cd,      acct_entry_id,
                     gl_acct_id,         gl_acct_category,         gl_control_acct, 
                     gl_sub_acct_1,      gl_sub_acct_2,            gl_sub_acct_3,
                     gl_sub_acct_4,      gl_sub_acct_5,            gl_sub_acct_6, 
                     gl_sub_acct_7,      sl_cd,                    credit_amt,
                     debit_amt,          generation_type,          sl_type_cd,
                     sl_source_cd   
                FROM giac_acct_entries
               WHERE gacc_tran_id = old_id.reverse_tran_id)
            LOOP
              --insert record in giac_acct_entries
              INSERT INTO giac_acct_entries(
                gacc_tran_id,                 gacc_gfun_fund_cd,            gacc_gibr_branch_cd,
                acct_entry_id,                gl_acct_id,                   gl_acct_category,
                gl_control_acct,              gl_sub_acct_1,                gl_sub_acct_2,
                gl_sub_acct_3,                gl_sub_acct_4,                gl_sub_acct_5,
                gl_sub_acct_6,                gl_sub_acct_7,                sl_cd,
                debit_amt,                    credit_amt,                   generation_type,
                sl_type_cd,                   sl_source_cd,                 user_id,
                last_update,                  remarks)
              VALUES (
                v_tran_id,                    entry_data.gacc_gfun_fund_cd, entry_data.gacc_gibr_branch_cd,
                entry_data.acct_entry_id,     entry_data.gl_acct_id,        entry_data.gl_acct_category,
                entry_data.gl_control_acct,   entry_data.gl_sub_acct_1,     entry_data.gl_sub_acct_2,
                entry_data.gl_sub_acct_3,     entry_data.gl_sub_acct_4,     entry_data.gl_sub_acct_5,
                entry_data.gl_sub_acct_6,     entry_data.gl_sub_acct_7,     entry_data.sl_cd,
                entry_data.credit_amt,        entry_data.debit_amt,         entry_data.generation_type,
                entry_data.sl_type_cd,        entry_data.sl_source_cd,      p_user_id,
                sysdate,                      'REVERSAL FOR TRAN_ID = '|| to_char(old_id.reverse_tran_id));
            END LOOP;     --end of entry data
            EXIT;
          END LOOP;       --end of acctrans                  
        END LOOP;         --end of old_id
        EXIT;
      END LOOP;           --end of tran_dtae
    END;

    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  REVERSAL_NEXT_MONTH program unit; 
    **                     This procedures create reversing accounting entries for
    **                     outstanding loss that had been created during the 
    **                     last transaction       
    */
    PROCEDURE reversal_next_month(
        p_dsp_date      giac_acctrans.tran_date%TYPE,
        p_user_id       giac_acctrans.user_id%TYPE
    )
    IS
      v_tran_id         giac_acctrans.tran_id%TYPE;     -- stores tran_id for acct entries to be generated  
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE; -- stores tran_seq_no for acct entries to be generated
    BEGIN
      --select the latest tran_date from gicl_take_up_hist so that all tran_id
      --from last extraction can be retrieved 
      FOR tran_date IN (
        SELECT MAX(tran_date) tran_date
          FROM gicl_take_up_hist
         WHERE acct_tran_id IS NOT NULL)
      LOOP
        --get all tran_id using tran_date as basis
        FOR old_id IN (
         SELECT DISTINCT acct_tran_id reverse_tran_id
           FROM gicl_take_up_hist
          WHERE tran_date = tran_date.tran_date
            AND acct_tran_id IS NOT NULL)
        LOOP
          --get value of tran_id
          BEGIN
            SELECT acctran_tran_id_s.nextval
              INTO v_tran_id
              FROM dual;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --lapse;               
            --msg_alert('ACCTRAN_TRAN_ID sequence not found.','E', TRUE);
            raise_application_error('-20001', 'ACCTRAN_TRAN_ID sequence not found.');
          END;
          --get info from giac_acctrans record to generate tran_seq_no and
          --to insert new record in giac_acctrans
          FOR acctrans IN (
            SELECT gfun_fund_cd, gibr_branch_cd, tran_flag, tran_class 
              FROM giac_acctrans
             WHERE tran_id = old_id.reverse_tran_id)
          LOOP
            v_tran_seq_no := giac_sequence_generation(acctrans.gfun_fund_cd,
                                                      acctrans.gibr_branch_cd,
                                                      'ACCTRAN_TRAN_SEQ_NO',
                                                      to_number(to_char(p_dsp_date,'YYYY')),
                                                      to_number(to_char(p_dsp_date,'MM')));
            --insert record in giac_acctrans
            INSERT INTO giac_acctrans(
              tran_id,     
              gfun_fund_cd, 
              gibr_branch_cd,
              tran_date,
              tran_flag,
              tran_class,
              tran_year, 
              tran_month, 
              tran_seq_no,
              user_id,          
              last_update,
              particulars)  --added by AlizaG. SR 5235
            VALUES(
              v_tran_id,       
              acctrans.gfun_fund_cd,
              acctrans.gibr_branch_cd,
              --p_dsp_date, comment out by aliza 12/09/2014 replaced by codes below
              p_dsp_date +1, 
              'C',  
              'OLR',
              --to_number(to_char(p_dsp_date,'YYYY')), comment out by aliza 12/09/2014 replaced by codes below 
              --to_number(to_char(p_dsp_date,'MM')),
              to_number(to_char(p_dsp_date+1,'YYYY')), 
              to_number(to_char(p_dsp_date+1,'MM')), 
              v_tran_seq_no,             
              p_user_id, 
              SYSDATE,
              'Reversal of Outstanding Losses Take-up for '||to_char(tran_date.tran_date,'fmMonth')||' '||to_char(tran_date.tran_date,'RRRR')); --added by AlizaG. SR 5235
            --select info of old tran_id to be used in insert
            FOR entry_data IN (
              SELECT gacc_gfun_fund_cd,  gacc_gibr_branch_cd,      acct_entry_id,
                     gl_acct_id,         gl_acct_category,         gl_control_acct, 
                     gl_sub_acct_1,      gl_sub_acct_2,            gl_sub_acct_3,
                     gl_sub_acct_4,      gl_sub_acct_5,            gl_sub_acct_6, 
                     gl_sub_acct_7,      sl_cd,                    credit_amt,
                     debit_amt,          generation_type,          sl_type_cd,
                     sl_source_cd   
                FROM giac_acct_entries
               WHERE gacc_tran_id =old_id.reverse_tran_id)
            LOOP
              --insert record in giac_acct_entries
              INSERT INTO giac_acct_entries(
                gacc_tran_id,                 gacc_gfun_fund_cd,            gacc_gibr_branch_cd,
                acct_entry_id,                gl_acct_id,                   gl_acct_category,
                gl_control_acct,              gl_sub_acct_1,                gl_sub_acct_2,
                gl_sub_acct_3,                gl_sub_acct_4,                gl_sub_acct_5,
                gl_sub_acct_6,                gl_sub_acct_7,                sl_cd,
                debit_amt,                    credit_amt,                   generation_type,
                sl_type_cd,                   sl_source_cd,                 user_id,
                last_update,                  remarks)
              VALUES (
                v_tran_id,                    entry_data.gacc_gfun_fund_cd, entry_data.gacc_gibr_branch_cd,
                entry_data.acct_entry_id,     entry_data.gl_acct_id,        entry_data.gl_acct_category,
                entry_data.gl_control_acct,   entry_data.gl_sub_acct_1,     entry_data.gl_sub_acct_2,
                entry_data.gl_sub_acct_3,     entry_data.gl_sub_acct_4,     entry_data.gl_sub_acct_5,
                entry_data.gl_sub_acct_6,     entry_data.gl_sub_acct_7,     entry_data.sl_cd,
                entry_data.credit_amt,        entry_data.debit_amt,         entry_data.generation_type,
                entry_data.sl_type_cd,        entry_data.sl_source_cd,      p_user_id,
                sysdate,                      'REVERSAL FOR TRAN_ID = '|| to_char(old_id.reverse_tran_id));
            END LOOP;     --end of entry data
            EXIT;
          END LOOP;       --end of acctrans                  
        END LOOP;         --end of old_id
        EXIT;
      END LOOP;           --end of tran_dtae
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  EXTRACT_OS_DETAILS program unit; 
    **                     This procedure creates record in table gicl_reserve_ds_xtr
    **                     and gicl_reserve_rids_xtr which will be used in reports 
    **                     that will support the genrated data during batch o/s take up       
    */
    PROCEDURE extract_os_details(p_tran_id     gicl_clm_res_hist.tran_id%TYPE) 
    IS
        v_ds_loss            gicl_take_up_hist.os_loss%TYPE;  --store sum of os_loss 
        v_ds_exp             gicl_take_up_hist.os_loss%TYPE;  --store sum of os_exp 
        v_rids_loss          gicl_take_up_hist.os_loss%TYPE;  --store sum of os_loss 
        v_rids_exp           gicl_take_up_hist.os_loss%TYPE;  --store sum of os_exp
        v_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE; --store grp_seq_no that will be updated
        v_offset_loss        gicl_take_up_hist.os_loss%TYPE;  --loss offset amount
        v_offset_exp         gicl_take_up_hist.os_loss%TYPE;  --expense offset amount
        v_ri_cd              gicl_reserve_rids.ri_cd%TYPE;    --store ri_cd that will be updated
    BEGIN
      --retrieved first all the records in table gicl_take_up_hist
      --that have acct_tran_id equal to the passed parameter
      FOR TAKE_UP IN(
        SELECT os_loss,      os_expense,
               claim_id,     clm_res_hist_id,
               item_no,      peril_cd,
               dist_no
          FROM gicl_take_up_hist
         WHERE acct_tran_id = p_tran_id)
      LOOP
        --initialize variables to be used
        v_ds_loss     := 0;
        v_ds_exp      := 0;
        v_grp_seq_no  := NULL;
        v_offset_loss := 0;
        v_offset_exp  := 0;
        --compute for the amounts for each grp_seq_no using records
        --in gicl_reserve_ds
        FOR RESDS IN(
          SELECT NVL(take_up.os_loss,0) * (shr_pct/100)    loss,
                 NVL(take_up.os_expense,0) * (shr_pct/100) expense,
                 acct_trty_type,
                 grp_seq_no,
                 share_type,
                 shr_pct,
                 line_cd
            FROM gicl_reserve_ds
           WHERE claim_id        = take_up.claim_id
             AND clm_res_hist_id = take_up.clm_res_hist_id
             AND clm_dist_no     = take_up.dist_no)
        LOOP
          --add all the accumulated amounts of gicl_reserve_ds per record 
          --in gicl_take_up_hist that will be used for offsetting
          v_ds_loss    := v_ds_loss + resds.loss;
          v_ds_exp     := v_ds_exp + resds.expense;
          v_grp_seq_no := resds.grp_seq_no;
          --insert record in extract table
          INSERT INTO gicl_reserve_ds_xtr
            (acct_tran_id,       acct_trty_type,        claim_id,
             grp_seq_no,         item_no,               peril_cd,
             line_cd,            share_type,            shr_pct,
             shr_loss_res_amt,   shr_exp_res_amt,       clm_res_hist_id,
             clm_dist_no)
          VALUES
            (p_tran_id,          resds.acct_trty_type,  take_up.claim_id,
             resds.grp_seq_no,   take_up.item_no,       take_up.peril_cd,
             resds.line_cd,      resds.share_type,      resds.shr_pct,
             resds.loss,         resds.expense,         take_up.clm_res_hist_id,
             take_up.dist_no);
        END LOOP;
        --check for offset amts 
        v_offset_loss := NVL(take_up.os_loss,0)    - NVL(v_ds_loss,0);
        v_offset_exp  := NVL(take_up.os_expense,0) - NVL(v_ds_exp,0);
        --if offset amt is detected then updated the corresponding record 
        IF NVL(v_offset_loss,0) <> 0 OR
           NVL(v_offset_exp,0)  <> 0 THEN
           UPDATE gicl_reserve_ds_xtr
              SET shr_exp_res_amt   = shr_exp_res_amt + v_offset_exp,
                  shr_loss_res_amt  = shr_loss_res_amt + v_offset_loss
            WHERE acct_tran_id = p_tran_id
              AND claim_id = take_up.claim_id
              AND clm_res_hist_id = take_up.clm_res_hist_id;
        END IF;
      END LOOP;
      --retrieved records in table gicl_reserve_ds_xtr
      --that have acct_tran_id equal to the passed parameter 
      --and only those with records in gicl_reserve_rids
      FOR RESDS IN(
        SELECT a.claim_id,         a.clm_res_hist_id,
               a.grp_seq_no,       a.item_no,
               a.line_cd,          a.peril_cd,
               a.shr_exp_res_amt,  a.shr_loss_res_amt,
               a.clm_dist_no,      a.shr_pct
          FROM gicl_reserve_ds_xtr a
         WHERE a.acct_tran_id    = p_tran_id
           AND EXISTS (SELECT '1'
                         FROM gicl_reserve_rids b
                        WHERE b.claim_id        = a.claim_id
                          AND b.clm_res_hist_id = a.clm_res_hist_id
                          AND b.clm_dist_no     = a.clm_dist_no))
      LOOP
        --initialize variables to be use
        v_rids_loss    := 0;
        v_rids_exp     := 0;
        v_ri_cd        := NULL;
        v_offset_loss  := 0;
        v_offset_exp   := 0;
        --compute for the amounts for each grp_seq_no using records
        --in gicl_reserve_ds
        FOR RESRIDS IN(
          SELECT NVL(resds.shr_loss_res_amt,0) * (shr_ri_pct/resds.shr_pct) loss,
                 NVL(resds.shr_exp_res_amt,0) * (shr_ri_pct/resds.shr_pct) expense,
    --             NVL(resds.shr_loss_res_amt,0) * (shr_ri_pct/100) loss,
    --             NVL(resds.shr_exp_res_amt,0) * (shr_ri_pct/100) expense,
                 shr_ri_pct,
                 ri_cd
            FROM gicl_reserve_rids
           WHERE claim_id        = resds.claim_id
             AND clm_res_hist_id = resds.clm_res_hist_id
             AND clm_res_hist_id = resds.clm_res_hist_id
             AND grp_seq_no      = resds.grp_seq_no
             AND clm_dist_no     = resds.clm_dist_no)
        LOOP
          --add all the accumulated amounts of gicl_reserve_rids per record 
          --in gicl_reserve_ds_xtr that will be used for offsetting
          v_rids_loss  := v_rids_loss + resrids.loss;
          v_rids_exp   := v_rids_exp + resrids.expense;
          v_ri_cd      := resrids.ri_cd;
          --insert record in gicl_reserve_rids_xtr
          INSERT INTO gicl_reserve_rids_xtr
            (acct_tran_id,       claim_id,              line_cd,
             grp_seq_no,         item_no,               peril_cd,
             shr_loss_res_amt,   shr_exp_res_amt,       clm_res_hist_id,
             shr_pct,            ri_cd,                 clm_dist_no)
          VALUES
            (p_tran_id,          resds.claim_id,        resds.line_cd,
             resds.grp_seq_no,   resds.item_no,         resds.peril_cd,
             resrids.loss,       resrids.expense,       resds.clm_res_hist_id,
             resrids.shr_ri_pct, resrids.ri_cd,         resds.clm_dist_no);
        END LOOP;
        --compute for offset amounts
        v_offset_loss := NVL(resds.shr_loss_res_amt ,0)    - NVL(v_rids_loss,0);
        v_offset_exp  := NVL(resds.shr_exp_res_amt,0) - NVL(v_rids_exp,0);
        --if offset amt is detected then updated the corresponding record 
        IF NVL(v_offset_loss,0) <> 0 OR
           NVL(v_offset_exp,0)  <> 0 THEN
           UPDATE gicl_reserve_rids_xtr
              SET shr_exp_res_amt   = shr_exp_res_amt + v_offset_exp,
                  shr_loss_res_amt  = shr_loss_res_amt + v_offset_loss
           WHERE acct_tran_id    = p_tran_id
             AND claim_id        = resds.claim_id
             AND clm_res_hist_id = resds.clm_res_hist_id
             AND grp_seq_no      = resds.grp_seq_no
             AND ri_cd           = v_ri_cd;
        END IF;
      END LOOP;
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)  
    */
    PROCEDURE validate_tran_date(
        p_dsp_date     IN  giac_acctrans.tran_date%TYPE,
        p_msg         OUT  VARCHAR2
    )
    IS
    BEGIN
        FOR A IN (
            SELECT tran_date, tran_flag
              FROM giac_acctrans
             WHERE tran_class = 'OL'
               AND tran_flag IN ('C','P')
             ORDER BY tran_date desc, tran_id desc)
        LOOP
            IF p_dsp_date < a.tran_date THEN
                --:control.dsp_date := NULL;         
                --MSG_ALERT('Transaction Date cannot be earlier than ' ||TO_CHAR(a.tran_date,'fm Month DD, YYYY'),'I',TRUE);
                p_msg := 'Transaction Date cannot be earlier than ' ||TO_CHAR(a.tran_date,'fm Month DD, YYYY');
            ELSIF a.tran_flag = 'P' AND p_dsp_date = a.tran_date THEN
                --:control.dsp_date := NULL;         
                --MSG_ALERT('Transaction Date cannot be equal to ' ||TO_CHAR(a.tran_date,'fm Month DD, YYYY')||' since transaction with the same day is already POSTED','I',TRUE);
                p_msg := 'Transaction Date cannot be equal to ' ||TO_CHAR(a.tran_date,'fm Month DD, YYYY')||' since transaction with the same day is already POSTED';
            END IF;
            EXIT;
        END LOOP;
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.18.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  REVERSE_ALL program unit;     
    */
    PROCEDURE reverse_all_giclb001(
        p_dsp_date   IN    giac_acctrans.tran_date%TYPE,
        p_user_id    IN    gicl_take_up_hist.user_id%TYPE,
        p_ctr       OUT    NUMBER
    ) 
    IS
      v_take_up_hist    gicl_take_up_hist.take_up_hist%type;
      v_acct_intm_cd    giis_intm_type.acct_intm_cd%type;
      v_ctr             number := 0;
      v_tran_date       date := sysdate;
    BEGIN
        IF Giacp.n('CLM_PD_PARAM') = 1 THEN 
            Populate_Batch_Revall(p_dsp_date);
        ELSIF Giacp.n('CLM_PD_PARAM') = 2 THEN     
            Populate_Batch_Revall2(p_dsp_date);
        END IF;         
        
      FOR i IN (SELECT a.claim_id, a.clm_res_hist_id, a.item_no, a.peril_cd,
--                       (a.losses * b.convert_rate) losses, (a.expenses * b.convert_rate) expenses, removed by Aliza G, GENQA SR 5217 applied changes by nica on SR 20053
                       a.losses losses, a.expenses expenses, --added by Aliza G, GENQA SR 5217 applied changes by nica on SR 20053
                       a.iss_cd, a.dist_no
                  FROM gicl_batch_takeup_revall a, gicl_clm_res_hist b
                 WHERE to_date('01-'||a.booking_month||'-'||to_char(a.booking_year), 'DD-MON-YYYY')
            <= trunc(p_dsp_date)
                       AND a.claim_id = b.claim_id
                       AND a.clm_res_hist_id = b.clm_res_hist_id)

    /*             WHERE booking_month = to_char(:control.dsp_date, 'FMMONTH') 
                   AND booking_year  = to_char(:control.dsp_date, 'YYYY'))*/
      LOOP
        v_take_up_hist := 1;
        FOR A IN (SELECT nvl(max(take_up_hist),0) + 1  take_up_hist
                    FROM gicl_take_up_hist
                   WHERE claim_id = i.claim_id)
        LOOP
           v_take_up_hist := a.take_up_hist;
        END LOOP;
        --get_intm_type(i.claim_id, v_acct_intm_cd);
        get_acct_intm_cd (i.claim_id, v_acct_intm_cd); 
          
        INSERT INTO gicl_take_up_hist
                    (claim_id,       clm_res_hist_id,   take_up_type,
                     take_up_hist,   item_no,           peril_cd, 
                     os_loss,        os_expense,        acct_intm_cd,
                     user_id,        last_update,       iss_cd,
                     tran_date,      dist_no)
             VALUES (i.claim_id,     i.clm_res_hist_id, 'N', 
                     v_take_up_hist, i.item_no,         i.peril_cd,
                     i.losses,       i.expenses,        v_acct_intm_cd,  
                     p_user_id,      sysdate,           i.iss_cd,
                     v_tran_date,    i.dist_no);
        v_ctr := nvl(v_ctr,0) + 1;
        --message('Extracted records...'||to_char(v_ctr),no_acknowledge);
        --synchronize;
      END LOOP;
      p_ctr := v_ctr;
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.18.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  when_button_pressed(control.book_os) program unit;     
    */
    PROCEDURE book_os_giclb001(
        p_module_name   IN  giac_modules.module_name%TYPE,
        p_dsp_date      IN  giac_acctrans.tran_date%TYPE,
        p_user_id       IN  giac_acctrans.user_id%TYPE,
        p_message      OUT  VARCHAR2,
        p_message_type OUT  VARCHAR2,
        p_ctr          OUT  NUMBER
    )
    IS  
      v_setup            number;
      v_takeup            number;
      v_gen_type        giac_modules.generation_type%type;
      v_module_id       giac_modules.module_id%type;
      v_fund_cd         giac_payt_requests.fund_cd%TYPE;
      v_tran_id            giac_acctrans.tran_id%TYPE;
      v_gl_acct_ctgry   giac_module_entries.gl_acct_category%type;
    BEGIN
      /********************************************************************************
      *  OS_BATCH_TAKEUP                                  *
      *     1 - o/s booking every month, reversal every following month          *
      *     2 - o/s booking every month, reversal every payment and closing          *
      *     3 - o/s booking every month, reversal every following day                 *
      *  OS_BATCH_SETUP                                  *
      *     1 - additional take_up                              *
      *     2 - reverse all                                  *
      ********************************************************************************/     
      BEGIN
        SELECT param_value_n
          INTO v_takeup
          FROM giac_parameters
         WHERE param_name = 'OS_BATCH_TAKEUP';
      EXCEPTION
        WHEN NO_DATA_FOUND then 
        --msg_alert('No OS_BATCH_TAKEUP parameter found in giac_parameters.','I',TRUE);
        raise_application_error('-20001', 'No OS_BATCH_TAKEUP parameter found in giac_parameters.');
      END;
      
      BEGIN
        SELECT param_value_n
          INTO v_setup
          FROM giac_parameters
         WHERE param_name = 'OS_BATCH_SETUP';
      EXCEPTION
        WHEN NO_DATA_FOUND then 
        --msg_alert('No OS_BATCH_SETUP parameter found in giac_parameters.','I',TRUE);
        raise_application_error('-20001', 'No OS_BATCH_SETUP parameter found in giac_parameters.');
      END;

      IF v_setup = 2 THEN
         gicl_take_up_hist_pkg.reverse_all_giclb001(p_dsp_date, p_user_id, p_ctr);
      END IF;
     
      BEGIN
        SELECT module_id, generation_type
          INTO v_module_id, v_gen_type
          FROM giac_modules
         WHERE module_name = p_module_name;
      EXCEPTION
        WHEN NO_DATA_FOUND then
          --msg_alert(variable.module_name ||' not found in giac_modules.','I',TRUE);
          raise_application_error('-20001', p_module_name ||' not found in giac_modules.');
      END;
      
      BEGIN
        SELECT param_value_v
          INTO v_fund_cd
          FROM giac_parameters
         WHERE param_name = 'FUND_CD';
      EXCEPTION
        WHEN NO_DATA_FOUND then
        --msg_alert('Fund code is not found in GIAC_PARAMETERS table.','E', TRUE);
        raise_application_error('-20001', 'Fund code is not found in GIAC_PARAMETERS table.');
      END;

      IF v_takeup = 1 THEN
         gicl_take_up_hist_pkg.reversal_next_month(p_dsp_date, p_user_id);
      END IF;
      --BETH 11082001
      --update tran_flag to 'D' for tran_id with same tran_date so as to eliminate duplicate
      --transaction per transaction date
      IF v_takeup = 1 THEN
         UPDATE giac_acctrans
            SET tran_flag = 'D'
          WHERE trunc(tran_date) = TRUNC(p_dsp_date)
            AND tran_flag = 'C'
            AND tran_class = 'OLR';
      END IF;
      UPDATE giac_acctrans
         SET tran_flag = 'D'
       WHERE trunc(tran_date) = TRUNC(p_dsp_date)
         AND tran_flag = 'C'
         AND tran_class = 'OL';
      IF v_takeup = 3 THEN
         UPDATE giac_acctrans
            SET tran_flag = 'D'
          WHERE trunc(tran_date) = TRUNC(p_dsp_date + 1)
            AND tran_flag = 'C'
            AND tran_class = 'OLR';
      END IF; 
      generate_batch_giclb001(v_module_id, v_fund_cd, p_dsp_date, p_user_id, v_gen_type, v_tran_id, p_message, p_message_type);
      gicl_take_up_hist_pkg.extract_os_details(v_tran_id);

      IF v_takeup = 3 THEN
         gicl_take_up_hist_pkg.reversal_next_day(p_dsp_date, p_user_id);
      END IF;
    END;

END gicl_take_up_hist_pkg;
/



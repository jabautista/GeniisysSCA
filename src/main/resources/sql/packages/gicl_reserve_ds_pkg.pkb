CREATE OR REPLACE PACKAGE BODY CPI.GICL_RESERVE_DS_PKG
AS
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 16, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   get Distribution details for PLA 
    */
    FUNCTION get_gicl_reserve_ds(
        p_claim_id              gicl_reserve_ds.claim_id%TYPE,
        p_line_cd               gicl_reserve_ds.line_cd%TYPE,
        p_clm_res_hist_id       gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_item_no               gicl_reserve_ds.item_no%TYPE,
        p_grouped_item_no       gicl_reserve_ds.grouped_item_no%TYPE,
        p_peril_cd              gicl_reserve_ds.peril_cd%TYPE,
        p_hist_seq_no           gicl_reserve_ds.hist_seq_no%TYPE
        )
    RETURN gicl_reserve_ds_tab PIPELINED IS
      v_list    gicl_reserve_ds_type;
    BEGIN
        FOR i IN (SELECT a.claim_id, a.clm_res_hist_id, a.dist_year,
                         a.clm_dist_no, a.item_no, a.peril_cd,
                         a.grp_seq_no, a.line_cd, a.user_id,
                         a.acct_trty_type, a.last_update, a.share_type,
                         a.shr_pct, a.hist_seq_no
                    FROM gicl_reserve_ds a
                   WHERE a.claim_id = p_claim_id
                     AND a.clm_res_hist_id = p_clm_res_hist_id
                     AND (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                     AND a.share_type <> 1)
        LOOP
            v_list.claim_id            := i.claim_id; 
            v_list.clm_res_hist_id     := i.clm_res_hist_id;
            v_list.dist_year           := i.dist_year;
            v_list.clm_dist_no         := i.clm_dist_no; 
            v_list.item_no             := i.item_no; 
            v_list.peril_cd            := i.peril_cd;
            v_list.grp_seq_no          := i.grp_seq_no; 
            v_list.line_cd             := i.line_cd; 
            v_list.user_id             := i.user_id;
            v_list.acct_trty_type      := i.acct_trty_type; 
            v_list.last_update         := i.last_update; 
            v_list.share_type          := i.share_type;
            v_list.shr_pct             := i.shr_pct; 
            v_list.hist_seq_no           := i.hist_seq_no;        
    
            BEGIN
              SELECT trty_name
                INTO v_list.dsp_trty_name
                FROM giis_dist_share
               WHERE line_cd = p_line_cd
                 AND share_cd = i.grp_seq_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.dsp_trty_name := null;
            END; 

            BEGIN
              SELECT sum(shr_loss_res_amt) loss, sum(shr_exp_res_amt) exp
                INTO v_list.dsp_shr_loss_res_amt, v_list.dsp_shr_exp_res_amt
                FROM gicl_reserve_ds
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND nvl(grouped_item_no,0) = p_grouped_item_no  
                 AND peril_cd = p_peril_cd
                 AND grp_seq_no = i.grp_seq_no
                 AND (negate_tag = 'N' or negate_tag is null)
                 AND hist_seq_no = p_hist_seq_no; 
            EXCEPTION
              WHEN NO_DATA_FOUND THEN 
                v_list.dsp_shr_loss_res_amt := null; 
                v_list.dsp_shr_exp_res_amt  := null;
            END;

            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

    /*
    **  Created by   :  Roy Encela
    **  Date Created :  April 16, 2012 
    **  Reference By :  GICLS024 - Claim Reserve 
    **  Description :   get Distribution details for Claim Reserve 
    **  Modified by Irwin, 6.25.2012
    */
    FUNCTION get_gicl_reserve_ds2(
        p_claim_id gicl_reserve_ds.claim_id%TYPE
    ) RETURN gicl_reserve_ds_tab2 PIPELINED
    IS
        v gicl_reserve_ds_type2;
    BEGIN
        FOR i IN(
            SELECT claim_id, clm_res_hist_id, dist_year, grp_seq_no,
                    hist_seq_no, line_cd, shr_pct, shr_loss_res_amt,
                    shr_exp_res_amt, clm_dist_no
              FROM GICL_RESERVE_DS 
             WHERE (negate_tag<>'Y' 
                OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details 
               AND claim_id = p_claim_id
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.dist_year := i.dist_year;
            v.hist_seq_no := i.hist_seq_no;
            v.line_cd := i.line_cd;
            v.shr_pct := i.shr_pct;
            v.shr_loss_res_amt := i.shr_loss_res_amt;
            v.shr_exp_res_amt := i.shr_exp_res_amt;
            v.grp_seq_no := i.grp_seq_no;
            v.clm_dist_no := i.clm_dist_no;
            
            BEGIN
              SELECT trty_name
                INTO v.dsp_trty_name
                FROM giis_dist_share
               WHERE line_cd = i.line_cd
                 AND share_cd = i.grp_seq_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v.dsp_trty_name := null;
            END;
                       
            
            PIPE ROW(v);
        END LOOP;
        RETURN;
    END;
    
    /*
    **  Created by   :  Roy Encela
    **  Date Created :  April 16, 2012 
    **  Reference By :  GICLS024 - Claim Reserve
    **  Description :   Save Claim Reserve 
    */
    PROCEDURE set_gicl_reserve_ds(
        p_claim_id         IN gicl_reserve_ds.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE, 
        p_trty_name        IN giis_dist_share.trty_name%TYPE,
        p_clm_dist_no      IN gicl_reserve_ds.clm_dist_no%TYPE, 
        p_grp_seq_no       IN gicl_reserve_ds.grp_seq_no%TYPE, 
        p_dist_year        IN gicl_reserve_ds.dist_year%TYPE,
        p_item_no          IN gicl_reserve_ds.item_no%TYPE, 
        p_peril_cd         IN gicl_reserve_ds.peril_cd%TYPE, 
        p_hist_seq_no      IN gicl_reserve_ds.hist_seq_no%TYPE, 
        p_line_cd          IN gicl_reserve_ds.line_cd%TYPE,   
        p_share_type       IN gicl_reserve_ds.share_type%TYPE, 
        p_shr_pct          IN gicl_reserve_ds.shr_pct%TYPE,
        p_shr_loss_res_amt IN gicl_reserve_ds.shr_loss_res_amt%TYPE, 
        p_shr_exp_res_amt  IN gicl_reserve_ds.shr_exp_res_amt%TYPE, 
        p_cpi_rec_no       IN gicl_reserve_ds.cpi_rec_no%TYPE, 
        p_cpi_branch_cd    IN gicl_reserve_ds.cpi_branch_cd%TYPE, 
        p_grouped_item_no  IN gicl_reserve_ds.grouped_item_no%TYPE,
        p_user_id          IN gicl_reserve_ds.user_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gicl_reserve_ds(claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no, dist_year,
                    item_no, peril_cd, hist_seq_no, line_cd, last_update, share_type, shr_pct,
                    shr_loss_res_amt, shr_exp_res_amt, cpi_rec_no, cpi_branch_cd, grouped_item_no, user_id)
             VALUES (p_claim_id, p_clm_res_hist_id, p_clm_dist_no, p_grp_seq_no, p_dist_year,
                    p_item_no, p_peril_cd, p_hist_seq_no, p_line_cd, SYSDATE, p_share_type, p_shr_pct,
                    p_shr_loss_res_amt, p_shr_exp_res_amt, p_cpi_rec_no, p_cpi_branch_cd, p_grouped_item_no,
                    p_user_id);
    END;
    
    FUNCTION get_gicl_reserve_ds3(
        p_claim_id         IN gicl_reserve_ds.claim_id%TYPE,
        p_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE, 
        p_item_no          IN gicl_reserve_ds.item_no%TYPE, 
        p_peril_cd         IN gicl_reserve_ds.peril_cd%TYPE
    ) RETURN gicl_reserve_ds_tab3 PIPELINED
    IS
        v gicl_reserve_ds_type3;
    BEGIN
        FOR i IN(
            SELECT claim_id, clm_res_hist_id, dist_year, grp_seq_no, hist_seq_no, line_cd,
                   shr_pct, shr_loss_res_amt, shr_exp_res_amt, clm_dist_no, share_type
              FROM gicl_reserve_ds
             WHERE (negate_tag <> 'Y' OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
               AND claim_id = p_claim_id
               AND clm_res_hist_id = p_clm_res_hist_id
               AND item_no = p_item_no
               AND peril_cd = p_peril_cd
             ORDER BY dist_year desc, share_type
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.dist_year := i.dist_year;
            v.hist_seq_no := i.hist_seq_no;
            v.line_cd := i.line_cd;
            v.shr_pct := i.shr_pct;
            v.shr_loss_res_amt := i.shr_loss_res_amt;
            v.shr_exp_res_amt := i.shr_exp_res_amt;
            v.grp_seq_no := i.grp_seq_no;
            v.clm_dist_no := i.clm_dist_no;
            v.share_type := i.share_type;
            v.upd_res_dist := giisp.v ('UPDATEABLE_RES_DIST');
            
            BEGIN
              SELECT trty_name, prtfolio_sw, xol_ded
                INTO v.dsp_trty_name, v.prtfolio_sw, v.xol_ded_amt
                FROM giis_dist_share
               WHERE line_cd = i.line_cd
                 AND share_cd = i.grp_seq_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v.dsp_trty_name := null;
                v.prtfolio_sw := null;
                v.xol_ded_amt := null;
            END;    
            
            v.net_ret := 'N';
            FOR a IN (SELECT 'Y'
               FROM gicl_reserve_ds
              WHERE share_type = '1'
                AND claim_id = i.claim_id
                AND clm_res_hist_id = i.clm_res_hist_id)
            LOOP
               v.net_ret := 'Y';
               EXIT;
            END LOOP;
            
            PIPE ROW(v);
        END LOOP;
        RETURN;
    END;
    
    PROCEDURE validate_xol_deduc(
        p_clm_res_hist_id       IN      gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_grp_seq_no            IN      gicl_reserve_ds.grp_seq_no%TYPE,
        p_line_cd               IN      gicl_reserve_ds.line_cd%TYPE,
        p_shr_loss_res_amt      IN      gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_shr_exp_res_amt       IN      gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_xol_ded               IN      gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded           IN      gicl_reserve_ds.xol_ded%TYPE,
        p_trigger_item          IN      VARCHAR2,
        p_new_xol_ded              OUT  VARCHAR2,
        p_msg                      OUT  VARCHAR2
    )
    IS
       v_total_ded_used   gicl_reserve_ds.xol_ded%TYPE;
       v_ded_maintained   giis_dist_share.xol_ded%TYPE;
       v_sum_loss_exp     NUMBER (17, 2):= p_shr_loss_res_amt+ p_shr_exp_res_amt;
       v_ded_allowed      giis_dist_share.xol_ded%TYPE;
       v_ded_added        giis_dist_share.xol_ded%type;
       v_new_xol          gicl_reserve_ds.xol_ded%TYPE := 0;
    BEGIN
       BEGIN
          SELECT NVL (SUM (NVL (xol_ded, 0)), 0)
            INTO v_total_ded_used
            FROM gicl_reserve_ds
           WHERE negate_tag IS NULL
             AND clm_res_hist_id <> p_clm_res_hist_id
             AND grp_seq_no = p_grp_seq_no
             AND line_cd = p_line_cd;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             --msg_alert ('No data found in table GICL_RESERVE_DS', 'W', TRUE);
             p_msg := 'No data found in table GICL_RESERVE_DS';
             RETURN;
       END;

       BEGIN
          SELECT NVL (xol_ded, 0)
            INTO v_ded_maintained
            FROM giis_dist_share
           WHERE line_cd = p_line_cd AND share_cd = p_grp_seq_no;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             --msg_alert(   'No data found in Maintenance Table GIIS_DIST_SHARE for LINE_CD: '|| p_line_cd|| ' and GRP_SEQ_NO: '|| p_grp_seq_no,'W',TRUE);
             p_msg := 'No data found in Maintenance Table GIIS_DIST_SHARE for LINE_CD: '|| p_line_cd|| ' and GRP_SEQ_NO: '|| p_grp_seq_no;
             RETURN;
       END;

       v_ded_allowed := v_ded_maintained - v_total_ded_used; 
       v_ded_added := NVL (p_xol_ded, 0) + NVL (p_dsp_xol_ded, 0);

       IF     (p_dsp_xol_ded = 0 OR p_dsp_xol_ded IS NULL) AND p_trigger_item = 'XOL_DED_APPLY_BTN'
       THEN
          --msg_alert('Enter deductible amount for this XOL. To remove XOL deductible, redistribute the reserve.','W',TRUE);
          p_msg := 'Enter deductible amount for this XOL. To remove XOL deductible, redistribute the reserve.';
          RETURN;
       END IF;

       IF v_ded_added < 0
       THEN
          --:e012.dsp_xol_ded := :e012.xol_ded;
          --msg_alert ('XOL deductible amount cannot be negative.', 'W', TRUE);
          v_new_xol := p_xol_ded;
          p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
          p_msg := 'XOL deductible amount cannot be negative.';
          RETURN;
       END IF;

       IF v_ded_added > v_sum_loss_exp
       THEN               -- if amount entered is greater than loss+expense amount
          IF v_ded_allowed = 0
          THEN
    -- if zero, display message that deductible is fully consumed, return previous amount
             --variables.v_ded_added := variables.v_previous_xol_ded;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert ('Deductible amount for this XOL is fully consumed.',-'W',-TRUE-);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL is fully consumed.';
             RETURN;
          ELSIF v_ded_allowed < 0
          THEN
    -- if negative, display message. This could happen if user maintained deductible (that is already exhausted) lower than previously maintained.
             --variables.v_ded_added := variables.v_previous_xol_ded;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert-('Deductible amount for this XOL has exceeded maintained amount.',-'W',-TRUE-);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL has exceeded maintained amount.';
             RETURN;
          ELSIF v_ded_allowed = p_xol_ded
          THEN                                     -- if equal, cannot add anymore
             --variables.v_ded_added := v_ded_allowed;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert ('Deductible amount for this XOL is fully consumed.','W',TRUE);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL is fully consumed.';
             RETURN;
          ELSIF v_ded_added > v_ded_allowed
          THEN               -- if greater than allowed, supply the allowed amount
             --variables.v_ded_added := v_ded_allowed;
             --:e012.dsp_xol_ded := v_ded_allowed - NVL (:e012.xol_ded, 0);
             --msg_alert (   'Deductible amount cannot exceed '|| TO_CHAR (v_ded_allowed - NVL (:e012.xol_ded, 0),'fm99,999,999,999,999.00'),'W',TRUE);
             v_new_xol := v_ded_allowed - NVL (p_xol_ded, 0);
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount cannot exceed '|| TO_CHAR (v_ded_allowed - NVL (p_xol_ded, 0),'fm99,999,999,999,999.00') ;
             RETURN;
          ELSE
    -- else, supply deductible amount equal to sum of loss + expense (maximum allowable deductible amount)
             --variables.v_ded_added := v_sum_loss_exp;
             --:e012.dsp_xol_ded := v_sum_loss_exp - NVL (:e012.xol_ded, 0);
             --msg_alert (   'Deductible amount cannot exceed '|| TO_CHAR (v_sum_loss_exp - NVL (:e012.xol_ded, 0),'fm99,999,999,999,999.00'),'W',TRUE);
             v_new_xol := v_sum_loss_exp - NVL (p_xol_ded, 0);
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount cannot exceed '|| TO_CHAR (v_sum_loss_exp - NVL (p_xol_ded, 0),'fm99,999,999,999,999.00');
             RETURN;
          END IF;
       ELSIF v_ded_added > (v_ded_allowed)
       THEN                    -- if amount entered is greater than allowed amount
          IF v_ded_allowed = 0
          THEN
    -- if zero, display message that deductible is fully consumed, return previous amount
             --variables.v_ded_added := variables.v_previous_xol_ded;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert ('Deductible amount for this XOL is fully consumed.','W',TRUE);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL is fully consumed.';
             RETURN;
          ELSIF v_ded_allowed < 0
          THEN
    -- if negative, display message. This could happen if user maintained deductible (that is already exhausted) lower than previously maintained.
             --variables.v_ded_added := variables.v_previous_xol_ded;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert('Deductible amount for this XOL has exceeded maintained amount.','W',TRUE);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL has exceeded maintained amount.';
             RETURN;
          ELSIF v_ded_allowed = p_xol_ded
          THEN                                     -- if equal, cannot add anymore
             --variables.v_ded_added := v_ded_allowed;
             --:e012.dsp_xol_ded := :e012.xol_ded;
             --msg_alert ('Deductible amount for this XOL is fully consumed.','W',TRUE);
             v_new_xol := p_xol_ded;
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount for this XOL is fully consumed.';
             RETURN;
          ELSE                           -- else, supply allowed deductible amount
             --variables.v_ded_added := v_ded_allowed;
             --:e012.dsp_xol_ded := v_ded_allowed - NVL (:e012.xol_ded, 0);
             --msg_alert (   'Deductible amount cannot exceed '|| TO_CHAR (v_ded_allowed - NVL (:e012.xol_ded, 0),'fm99,999,999,999,999.00'),'W',TRUE);
             v_new_xol := v_ded_allowed - NVL (p_xol_ded, 0);
             p_new_xol_ded := TO_CHAR (v_new_xol,'fm99,999,999,999,999.00');
             p_msg := 'Deductible amount cannot exceed '|| TO_CHAR (v_ded_allowed - NVL (p_xol_ded, 0),'fm99,999,999,999,999.00');
             RETURN;
          END IF;
       END IF;
    --GO_ITEM('e012.XOL_DED');
    END;
    
    PROCEDURE continue_xol_deduc(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_grp_seq_no    IN  giis_dist_share.line_cd%TYPE,
        p_xol_ded       IN  gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded   IN  gicl_reserve_ds.xol_ded%TYPE,
        p_msg_alert    OUT  VARCHAR2,
        p_msg          OUT  VARCHAR2
    )
    IS
       v_xol_trty_name   giis_xol.xol_trty_name%TYPE;
       v_layer_no        giis_dist_share.layer_no%TYPE;
       v_trty_name       giis_dist_share.trty_name%TYPE;
    BEGIN      
      BEGIN
         -- retrieve xol trty name, layer no, and layer name to be used on pop up message below
         SELECT a.xol_trty_name, b.layer_no, b.trty_name
           INTO v_xol_trty_name, v_layer_no, v_trty_name
           FROM giis_xol a, giis_dist_share b
          WHERE a.xol_id = b.xol_id
            AND b.line_cd = p_line_cd
            AND b.share_cd = p_grp_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --msg_alert('Please check Distribution Share Maintenance. XOL does not exists.','E',TRUE);
            p_msg_alert := 'Please check Distribution Share Maintenance. XOL does not exists.';
            p_msg := 1;
            RETURN;
      END;

      IF p_xol_ded IS NULL
      THEN
        p_msg_alert := TO_CHAR (p_dsp_xol_ded, 'fm99,999,999,999,999.00')
                     || ' deductible amount will be applied to the selected XOL record: '
                     || v_xol_trty_name
                     || ', Layer '
                     || TO_CHAR (v_layer_no)
                     || ' '
                     || v_trty_name
                     || '. Do you wish to continue?' ;
        p_msg := 2;
        RETURN;
                     
      ELSE
        p_msg_alert := 'This XOL already has '
                     || TO_CHAR (p_xol_ded,
                                 'fm99,999,999,999,999.00'
                                )
                     || ' deductible amount. Additional '
                     || TO_CHAR (p_dsp_xol_ded,
                                 'fm99,999,999,999,999.00'
                                )
                     || ' will be applied for this XOL record: '
                     || v_xol_trty_name
                     || ', Layer '
                     || TO_CHAR (v_layer_no)
                     || ' '
                     || v_trty_name
                     || '. Do you wish to continue?';
        p_msg := 2;
        RETURN;
      END IF;
    END;
    
    PROCEDURE check_xol_amount_limits(
        p_grp_seq_no                IN  gicl_reserve_ds.grp_seq_no%TYPE,
        p_line_cd                   IN  gicl_reserve_ds.line_cd%TYPE,
        p_claim_id                  IN  gicl_reserve_ds.claim_id%TYPE,
        p_item_no                   IN  gicl_reserve_ds.item_no%TYPE,
        p_peril_cd                  IN  gicl_reserve_ds.peril_cd%TYPE,
        p_clm_dist_no               IN  gicl_reserve_ds.clm_dist_no%TYPE,
        p_clm_res_hist_id           IN  gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_nbt_cat_cd                IN  gicl_claims.catastrophic_cd%TYPE,
        p_trigger_item              IN  VARCHAR2,
        p_c022_expense_reserve      IN  gicl_clm_reserve.expense_reserve%TYPE,
        p_c022_loss_reserve         IN  gicl_clm_reserve.loss_reserve%TYPE,
        p_c017_grouped_item_no      IN  GICL_CLM_RES_HIST.grouped_item_no%TYPE,
        p_shr_loss_res_amt          IN  gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_previous_loss_res_amt     IN  gicl_reserve_ds.shr_loss_res_amt%TYPE,
        p_xol_ded                   IN  gicl_reserve_ds.xol_ded%TYPE,
        p_dsp_xol_ded               IN  gicl_reserve_ds.xol_ded%TYPE,
        p_shr_exp_res_amt           IN  gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_previous_exp_res_amt      IN  gicl_reserve_ds.shr_exp_res_amt%TYPE,
        p_shr_pct                   IN  gicl_reserve_ds.shr_pct%TYPE,
        p_previous_shr_pct          IN  gicl_reserve_ds.shr_pct%TYPE,
        p_new_loss_res_amt         OUT  VARCHAR2,
        p_new_exp_res_amt          OUT  VARCHAR2,
        p_new_pct                  OUT  VARCHAR2,
        p_msg                      OUT  VARCHAR2,
        p_msg2                     OUT  VARCHAR2
    )
    IS
       v_xol_base_amount        giis_dist_share.xol_base_amount%TYPE;
       v_xol_allowed_amount     giis_dist_share.xol_allowed_amount%TYPE;
       v_total_xol_consumed     NUMBER (21, 2);
       v_total_xol_curr_claim   NUMBER (17, 2);
       v_xol_remaining_amount   NUMBER (21, 2);
       v_shr_le_res_amt         gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_le_res_pct             NUMBER (21, 18);
       v_le_res_pct2            NUMBER (21, 18);
       v_net_ret_amt            gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_curr_ds_xol_ded_amt    gicl_reserve_ds.xol_ded%TYPE;
    BEGIN
       SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate, 0)
                   + NVL (a.shr_exp_res_amt * c.convert_rate, 0)
                  )
         INTO v_total_xol_consumed
         FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
        WHERE NVL (a.negate_tag, 'N') = 'N'
          AND a.item_no = b.item_no
          AND a.grouped_item_no = b.grouped_item_no       -- added by gmi 02/28/06
          AND a.peril_cd = b.peril_cd
          AND a.claim_id = b.claim_id
          AND a.item_no = c.item_no
          AND a.grouped_item_no = c.grouped_item_no       -- added by gmi 02/28/06
          AND a.peril_cd = c.peril_cd
          AND a.claim_id = c.claim_id
          AND NVL (a.clm_dist_no, -1) = NVL(c.dist_no, -1)
          AND a.clm_res_hist_id = c.clm_res_hist_id
          AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
          AND a.grp_seq_no = p_grp_seq_no
          AND a.line_cd = p_line_cd
          AND NOT EXISTS (
                 SELECT 1               -- to exclude current record for total XOL
                   FROM gicl_reserve_ds d
                  WHERE d.claim_id = a.claim_id
                    AND d.item_no = a.item_no
                    AND d.peril_cd = a.peril_cd
                    AND NVL (d.grouped_item_no, 0) = NVL (a.grouped_item_no, 0)
                    AND NVL (d.grouped_item_no, 0) = NVL (p_c017_grouped_item_no, 0)
                    AND d.negate_tag IS NULL
                    AND d.grp_seq_no = p_grp_seq_no
                    AND d.line_cd = p_line_cd
                    AND d.claim_id = p_claim_id
                    AND d.item_no = p_item_no
                    AND d.peril_cd = p_peril_cd)
          AND c.negate_date IS NULL
          AND a.negate_tag IS NULL;

    -- check sum of the selected XOL of current claim / catastrophic claim
       SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate, 0)
                   + NVL (a.shr_exp_res_amt * c.convert_rate, 0)
                  )
         INTO v_total_xol_curr_claim
         FROM gicl_reserve_ds a,
              gicl_item_peril b,
              gicl_clm_res_hist c,
              gicl_claims e
        WHERE NVL (a.negate_tag, 'N') = 'N'
          AND a.claim_id = e.claim_id
          AND a.item_no = b.item_no
          AND a.grouped_item_no = b.grouped_item_no       -- added by gmi 02/28/06
          AND a.peril_cd = b.peril_cd
          AND a.claim_id = b.claim_id
          AND a.item_no = c.item_no
          AND a.grouped_item_no = c.grouped_item_no       -- added by gmi 02/28/06
          AND a.peril_cd = c.peril_cd
          AND a.claim_id = c.claim_id
          AND NVL (a.clm_dist_no, -1) = NVL (c.dist_no, -1)
          AND a.clm_res_hist_id = c.clm_res_hist_id
          AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
          AND a.grp_seq_no = p_grp_seq_no
          AND a.line_cd = p_line_cd
          AND DECODE (nvl(p_nbt_cat_cd, -1),-1, e.claim_id,e.catastrophic_cd) = NVL (p_nbt_cat_cd, p_claim_id)
          AND NOT EXISTS (
                 SELECT 1               -- to exclude current record for total XOL
                   FROM gicl_reserve_ds d
                  WHERE d.claim_id = a.claim_id
                    AND d.item_no = a.item_no
                    AND d.peril_cd = a.peril_cd
                    AND NVL (d.grouped_item_no, 0) = NVL (a.grouped_item_no, 0)
                    AND NVL (d.grouped_item_no, 0) = NVL (p_c017_grouped_item_no, 0)
                    AND d.negate_tag IS NULL
                    AND d.claim_id = p_claim_id
                    AND d.item_no = p_item_no
                    AND d.peril_cd = p_peril_cd)
          AND c.negate_date IS NULL
          AND a.negate_tag IS NULL;

    -- check allowed amount of XOL in maintenance and compute for remaining amount
       SELECT xol_base_amount, xol_allowed_amount,
                NVL (xol_aggregate_sum,
                       NVL (reinstatement_limit * xol_allowed_amount, 0)
                     + xol_allowed_amount
                    )
              - NVL (v_total_xol_consumed, 0)
         INTO v_xol_base_amount, v_xol_allowed_amount,
              v_xol_remaining_amount
         FROM giis_dist_share
        WHERE line_cd = p_line_cd AND share_cd = p_grp_seq_no;

    -- retrieve Net Ret value of this particular claim - item - peril for deductible checking
       SELECT NVL (SUM (  a.shr_loss_res_amt * b.convert_rate
                        + a.shr_exp_res_amt * b.convert_rate
                       ),
                   0
                  )
         INTO v_net_ret_amt
         FROM gicl_reserve_ds a, gicl_clm_res_hist b
        WHERE a.item_no = b.item_no
          AND a.grouped_item_no = b.grouped_item_no
          AND a.peril_cd = b.peril_cd
          AND a.claim_id = b.claim_id
          AND b.negate_date IS NULL
          AND a.negate_tag IS NULL
          AND a.share_type = 1
          AND a.clm_res_hist_id = p_clm_res_hist_id
          AND a.clm_dist_no = p_clm_dist_no
          AND a.claim_id = p_claim_id;

    -- retrieve accumulated XOL deductible amount for this particular claim - item - peril for deductible checking
       SELECT NVL (SUM (xol_ded), 0)
         INTO v_curr_ds_xol_ded_amt
         FROM gicl_reserve_ds
        WHERE negate_tag IS NULL
          AND share_type = 4
          AND clm_res_hist_id = p_clm_res_hist_id
          AND clm_dist_no = p_clm_dist_no
          AND claim_id = p_claim_id;

       v_xol_allowed_amount := v_xol_allowed_amount - NVL (v_total_xol_curr_claim, 0);

    -- if loss reserve field is modified
       IF p_trigger_item = 'SHR_LOSS_RES_AMT'
       THEN
          v_le_res_pct :=
               NVL (p_c022_loss_reserve, 0)
             / (NVL (p_c022_loss_reserve, 0) + NVL (p_c022_expense_reserve, 0));
          v_le_res_pct2 :=
               NVL (p_c022_expense_reserve, 0)
             / (NVL (p_c022_loss_reserve, 0) + NVL (p_c022_expense_reserve, 0));
          v_shr_le_res_amt := p_shr_loss_res_amt / v_le_res_pct;

          -- check for XOL deductible amount. Should not allow XOL deductible amount be less than Net Retention amount
          IF     p_previous_loss_res_amt < p_shr_loss_res_amt
             AND p_xol_ded IS NOT NULL
             AND (  v_net_ret_amt
                  - (  (p_shr_loss_res_amt - p_previous_loss_res_amt
                       )
                     + (  v_shr_le_res_amt * v_le_res_pct2
                        -   p_previous_loss_res_amt
                          * v_le_res_pct2
                          / v_le_res_pct
                       )
                    )
                 ) < v_curr_ds_xol_ded_amt
             AND p_xol_ded = p_dsp_xol_ded
          THEN
             p_new_loss_res_amt := p_previous_loss_res_amt;
             --msg_alert('Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.','I',FALSE);
             --p_validate_switch := FALSE;
             p_msg := 'Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.';
          END IF;

          IF v_xol_remaining_amount >= v_shr_le_res_amt
          THEN
             IF     v_shr_le_res_amt > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert(   'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90'),'I',FALSE);
                p_msg2 := 'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90');
                --p_validate_switch := FALSE;
             ELSIF v_xol_allowed_amount < 0 AND v_shr_le_res_amt > 0
             THEN
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSIF v_shr_le_res_amt < 0
             THEN
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert ('Negative amount is not allowed', 'I', FALSE);
                p_msg2 := 'Negative amount is not allowed';
                --p_validate_switch := FALSE;
             END IF;
          ELSIF     v_xol_remaining_amount < v_shr_le_res_amt
                AND v_xol_remaining_amount > 0
          THEN
             IF     v_shr_le_res_amt > v_xol_allowed_amount
                AND v_xol_remaining_amount > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert(   'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90'),'I',FALSE);
                p_msg2 := 'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90');
                --p_validate_switch := FALSE;
             ELSIF     v_shr_le_res_amt > v_xol_allowed_amount
                   AND v_xol_remaining_amount > v_xol_allowed_amount
                   AND v_xol_allowed_amount < 0
             THEN
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSE
                p_new_loss_res_amt := p_previous_loss_res_amt;
                --msg_alert (   'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_remaining_amount * v_le_res_pct, 'fm99,999,999,999,990.90'),'I',FALSE);
                p_msg2 := 'Loss reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_remaining_amount * v_le_res_pct, 'fm99,999,999,999,990.90');
                --p_validate_switch := FALSE;
             END IF;
          ELSE
             p_new_loss_res_amt := p_previous_loss_res_amt;
             --msg_alert ('XOL limit amount reached', 'I', FALSE);
             p_msg2 := 'XOL limit amount reached';
             --p_validate_switch := FALSE;
          END IF;
       END IF;

    -- if loss expense field is modified
       IF p_trigger_item = 'SHR_EXP_RES_AMT'
       THEN
          v_le_res_pct :=
               NVL (p_c022_expense_reserve, 0)
             / (NVL (p_c022_loss_reserve, 0) + NVL (p_c022_expense_reserve, 0));
          v_le_res_pct2 :=
               NVL (p_c022_loss_reserve, 0)
             / (NVL (p_c022_loss_reserve, 0) + NVL (p_c022_expense_reserve, 0));
          v_shr_le_res_amt := p_shr_exp_res_amt / v_le_res_pct;

          -- check for XOL deductible amount. Should not allow XOL deductible amount be less than Net Retention amount
          IF     p_previous_exp_res_amt < p_shr_exp_res_amt
             AND p_xol_ded IS NOT NULL
             AND (  v_net_ret_amt
                  - (  (p_shr_exp_res_amt - p_previous_exp_res_amt)
                     + (  v_shr_le_res_amt * v_le_res_pct2
                        -   p_previous_exp_res_amt
                          * v_le_res_pct2
                          / v_le_res_pct
                       )
                    )
                 ) < v_curr_ds_xol_ded_amt
             AND p_xol_ded = p_dsp_xol_ded
          THEN
             p_new_exp_res_amt := p_previous_exp_res_amt;
             --msg_alert('Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.','I',FALSE);
             p_msg := 'Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.';
             --p_validate_switch := FALSE;
          END IF;

          IF v_xol_remaining_amount >= v_shr_le_res_amt
          THEN
             IF     v_shr_le_res_amt > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert(   'Expense reserve amount cannot exceed XOL amount limit of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90' ), 'I', FALSE );
                p_msg2 := 'Expense reserve amount cannot exceed XOL amount limit of ' || TO_CHAR (v_xol_allowed_amount * v_le_res_pct, 'fm99,999,999,999,990.90' );
                --p_validate_switch := FALSE;
             ELSIF v_xol_allowed_amount < 0 AND v_shr_le_res_amt > 0
             THEN
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSIF v_shr_le_res_amt < 0
             THEN
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert ('Negative amount is not allowed', 'I', FALSE);
                p_msg2 := 'Negative amount is not allowed';
                --p_validate_switch := FALSE;
             END IF;
          ELSIF     v_xol_remaining_amount < v_shr_le_res_amt
                AND v_xol_remaining_amount > 0
          THEN
             IF     v_shr_le_res_amt > v_xol_allowed_amount
                AND v_xol_remaining_amount > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert(   'Expense reserve cannot exceed XOL allowable amount of '|| TO_CHAR (v_xol_allowed_amount * v_le_res_pct,'fm99,999,999,999,990.90'),'I',FALSE);
                p_msg2 := 'Expense reserve cannot exceed XOL allowable amount of '|| TO_CHAR (v_xol_allowed_amount * v_le_res_pct,'fm99,999,999,999,990.90');
                --p_validate_switch := FALSE;
             ELSIF     v_shr_le_res_amt > v_xol_allowed_amount
                   AND v_xol_remaining_amount > v_xol_allowed_amount
                   AND v_xol_allowed_amount < 0
             THEN
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSE
                p_new_exp_res_amt := p_previous_exp_res_amt;
                --msg_alert(   'Expense reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_remaining_amount * v_le_res_pct, 'fm99,999,999,999,990.90' ), 'I', FALSE );
                p_msg2 := 'Expense reserve cannot exceed XOL allowable amount of ' || TO_CHAR (v_xol_remaining_amount * v_le_res_pct, 'fm99,999,999,999,990.90' );
                --p_validate_switch := FALSE;
             END IF;
          ELSE
             p_new_exp_res_amt := p_previous_exp_res_amt;
             --msg_alert ('XOL limit amount reached', 'I', FALSE);
             p_msg2 := 'XOL limit amount reached';
             --p_validate_switch := FALSE;
          END IF;
       END IF;

    -- if share percent field is modified
       IF p_trigger_item = 'SHR_PCT'
       THEN
          -- get maximum allowable percentage of current XOL
          v_shr_le_res_amt := (NVL (p_c022_loss_reserve, 0) + NVL (p_c022_expense_reserve, 0));

          -- check for XOL deductible amount. Should not allow XOL deductible amount be less than Net Retention amount
          IF     p_previous_shr_pct < p_shr_pct
             AND p_xol_ded IS NOT NULL
             AND (  v_net_ret_amt
                  - (  v_shr_le_res_amt * (p_shr_pct / 100)
                     - v_shr_le_res_amt * (p_previous_shr_pct / 100)
                    )
                 ) < v_curr_ds_xol_ded_amt
             AND p_xol_ded = p_dsp_xol_ded
          THEN
             p_new_pct := p_previous_shr_pct;
             --msg_alert('Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.','I',FALSE);
             p_msg := 'Current distribution has XOL deductible. Net retention cannot be adjusted to amount lower than XOL deductible amount.';
             --p_validate_switch := FALSE;
          END IF;

          IF v_xol_remaining_amount >= v_shr_le_res_amt * (p_shr_pct / 100)
          THEN
             IF     v_shr_le_res_amt * (p_shr_pct / 100) > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_pct := p_previous_shr_pct;
                --msg_alert (   'Share percent cannot exceed XOL share limit of ' || TO_CHAR (v_xol_allowed_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent', 'I', FALSE);
                p_msg2 := 'Share percent cannot exceed XOL share limit of ' || TO_CHAR (v_xol_allowed_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent';
                --p_validate_switch := FALSE;
             ELSIF v_xol_allowed_amount < 0 AND p_shr_pct > 0
             THEN
                p_new_pct := p_previous_shr_pct;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSIF p_shr_pct < 0
             THEN
                p_new_pct := p_previous_shr_pct;
                --msg_alert ('Negative value is not allowed', 'I', FALSE);
                p_msg2 := 'Negative value is not allowed';
                --p_validate_switch := FALSE;
             END IF;
          ELSIF     v_xol_remaining_amount < v_shr_le_res_amt * (p_shr_pct / 100)
                AND v_xol_remaining_amount > 0
          THEN
             IF     v_shr_le_res_amt * (p_shr_pct / 100) > v_xol_allowed_amount
                AND v_xol_remaining_amount > v_xol_allowed_amount
                AND v_xol_allowed_amount > 0
             THEN
                p_new_pct := p_previous_shr_pct;
                --msg_alert (   'Share percent cannot exceed XOL share limit of ' || TO_CHAR (v_xol_allowed_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent', 'I', FALSE );
                p_msg2 := 'Share percent cannot exceed XOL share limit of ' || TO_CHAR (v_xol_allowed_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent';
                --p_validate_switch := FALSE;
             ELSIF     v_shr_le_res_amt * (p_shr_pct / 100) > v_xol_allowed_amount
                   AND v_xol_remaining_amount > v_xol_allowed_amount
                   AND v_xol_allowed_amount < 0
             THEN
                p_new_pct := p_previous_shr_pct;
                --msg_alert ('XOL limit amount reached', 'I', FALSE);
                p_msg2 := 'XOL limit amount reached';
                --p_validate_switch := FALSE;
             ELSE
                p_new_pct := p_previous_shr_pct;
                --msg_alert (   'Share percent cannot exceed XOL allowable share limit of ' || TO_CHAR (v_xol_remaining_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent', 'I', FALSE);
                p_msg2 := 'Share percent cannot exceed XOL allowable share limit of ' || TO_CHAR (v_xol_remaining_amount / v_shr_le_res_amt * 100, 'fm990.99999990' ) || ' percent';
                --p_validate_switch := FALSE;
             END IF;
          ELSE
             p_new_pct := p_previous_shr_pct;
             --msg_alert ('XOL limit amount reached', 'I', FALSE);
             p_msg2 := 'XOL limit amount reached';
             --p_validate_switch := FALSE;
          END IF;
       END IF;
    END;
    
    PROCEDURE update_shr_loss_res_amt (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_prev_loss_res_amt  gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    )
    IS
       v_shr_pct            gicl_reserve_ds.shr_pct%TYPE;
       v_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE;
    BEGIN
       FOR b IN (SELECT *
                   FROM gicl_reserve_ds
                  WHERE (negate_tag <> 'Y'
                     OR  negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                        AND claim_id = p_claim_id
                        AND clm_res_hist_id = p_clm_res_hist_id
                        AND item_no = p_item_no
                        AND peril_cd = p_peril_cd
                        AND grp_seq_no = p_grp_seq_no
                        AND clm_dist_no = p_clm_dist_no)
       LOOP
          v_shr_loss_res_amt := p_shr_loss_res_amt;
          v_shr_pct := p_shr_loss_res_amt * 100 / p_loss_reserve;
          v_shr_exp_res_amt := p_tot_exp_res_amt * v_shr_pct / 100;
          
          IF v_shr_loss_res_amt = 0 THEN 
               FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 DELETE gicl_reserve_rids
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          
               DELETE gicl_reserve_ds
                WHERE claim_id = b.claim_id
                  AND clm_res_hist_id = b.clm_res_hist_id
                  AND item_no = b.item_no
                  AND peril_cd = b.peril_cd
                  AND grp_seq_no = b.grp_seq_no;
          ELSE
               UPDATE gicl_reserve_ds
                 SET shr_pct = v_shr_pct,
                     shr_loss_res_amt = v_shr_loss_res_amt,
                     shr_exp_res_amt = v_shr_exp_res_amt
               WHERE claim_id = b.claim_id
                 AND clm_res_hist_id = b.clm_res_hist_id
                 AND item_no = b.item_no
                 AND peril_cd = b.peril_cd
                 AND grp_seq_no = b.grp_seq_no;

              FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 UPDATE gicl_reserve_rids
                    SET shr_ri_pct = v_shr_pct * i.shr_ri_pct_real / 100,
                        shr_loss_ri_res_amt =
                                          v_shr_loss_res_amt * i.shr_ri_pct_real / 100,
                        shr_exp_ri_res_amt =
                                           v_shr_exp_res_amt * i.shr_ri_pct_real / 100
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          END IF;

          IF p_net_ret = 'N'
          THEN
             GICL_RESERVE_DS_PKG.create_net_ret_for_loss (b.claim_id,
                                         b.peril_cd,
                                         b.item_no,
                                         p_loss_reserve,
                                         p_tot_exp_res_amt,
                                         b.grouped_item_no,
                                         p_distribution_date,
                                         b.clm_res_hist_id,
                                         b.clm_dist_no,
                                         p_c007_ann_tsi_amt,
                                         p_prev_loss_res_amt,
                                         v_shr_loss_res_amt,
                                         b.grp_seq_no,
                                         b.share_type,
                                         b.hist_seq_no
                                        );
          END IF;
       END LOOP;

       IF p_net_ret = 'Y'
       THEN
          FOR a IN (SELECT *
                      FROM gicl_reserve_ds
                     WHERE (negate_tag <> 'Y'
                        OR  negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                           AND claim_id = p_claim_id
                           AND clm_res_hist_id = p_clm_res_hist_id
                           AND item_no = p_item_no
                           AND peril_cd = p_peril_cd
                           AND share_type = 1)
          LOOP
             v_shr_loss_res_amt :=
                       a.shr_loss_res_amt
                       + (p_loss_reserve - p_tot_loss_res_amt);
             v_shr_pct := v_shr_loss_res_amt * 100 / p_loss_reserve;
             v_shr_exp_res_amt := p_tot_exp_res_amt * v_shr_pct / 100;

             UPDATE gicl_reserve_ds
                SET shr_pct = v_shr_pct,
                    shr_loss_res_amt = v_shr_loss_res_amt,
                    shr_exp_res_amt = v_shr_exp_res_amt
              WHERE claim_id = a.claim_id
                AND clm_res_hist_id = a.clm_res_hist_id
                AND item_no = a.item_no
                AND peril_cd = a.peril_cd
                AND grp_seq_no = a.grp_seq_no;
          END LOOP;
       END IF;
    END;
    
    PROCEDURE create_net_ret_for_loss (
       p_claim_id           gicl_claims.claim_id%TYPE,
       p_peril_cd           giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no            giuw_itemperilds_dtl.item_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_grouped_item_no    gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date  VARCHAR2,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_prev_loss_res_amt  gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type         gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no        gicl_reserve_ds.hist_seq_no%TYPE
    )
    IS
        v_line_cd               gicl_claims.line_cd%TYPE;
        v_subline_cd            gicl_claims.subline_cd%TYPE;
        v_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE;
        v_issue_yy              gicl_claims.issue_yy%TYPE;
        v_pol_seq_no            gicl_claims.pol_seq_no%TYPE;
        v_renew_no              gicl_claims.renew_no%TYPE;
        v_loss_date             gicl_claims.loss_date%TYPE;
        v_nbt_eff_date          gicl_claims.pol_eff_date%TYPE; --pol_eff_date
        v_nbt_expiry_date       gicl_claims.expiry_date%TYPE;
        
        v_net_shr_loss_res      gicl_reserve_ds.shr_loss_res_amt%TYPE; -- gets the value deducted from the loss reserve share
        v_shr_pct               gicl_reserve_ds.shr_pct%TYPE;
        v_shr_exp_res_amt       gicl_reserve_ds.shr_exp_res_amt%TYPE;
        v_share_type            gicl_reserve_ds.share_type%TYPE; -- share_type value of Net Ret available for the claim
        v_share_cd              gicl_reserve_ds.grp_seq_no%TYPE; -- share_cd value of Net Ret available for the claim
        v_acct_trty_type        gicl_reserve_ds.acct_trty_type%TYPE; -- acct_trty_type value of Net Ret available for the claim
        v_trty_name             giis_dist_share.trty_name%TYPE; -- trty_name value of Net Ret available for the claim
    BEGIN
        v_net_shr_loss_res    := p_prev_loss_res_amt - p_shr_loss_res_amt;

        SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no,
               renew_no, loss_date, pol_eff_date, expiry_date
          INTO v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no,
               v_renew_no, v_loss_date, v_nbt_eff_date, v_nbt_expiry_date
          FROM TABLE (gicl_claims_pkg.get_related_claims2 (p_claim_id));

       -- get Net Retention details
       FOR net_ret IN
          (SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
                    f.acct_trty_type, f.expiry_date, f.trty_name
               FROM gipi_polbasic a,
                    gipi_item b,
                    giuw_pol_dist c,
                    giuw_itemperilds_dtl d,
                    giis_dist_share f,
                    giis_parameters e
              WHERE f.share_cd = d.share_cd
                AND f.line_cd = d.line_cd
                AND d.peril_cd = p_peril_cd
                AND d.item_no = p_item_no
                AND d.item_no = b.item_no
                AND d.dist_no = c.dist_no
                AND e.param_type = 'V'
                AND c.dist_flag = e.param_value_v
                AND e.param_name = 'DISTRIBUTED'
                AND c.policy_id = b.policy_id
                AND TRUNC (DECODE (TRUNC (c.eff_date),
                                   TRUNC (a.eff_date), DECODE
                                                            (TRUNC (a.eff_date),
                                                             TRUNC (a.incept_date), v_nbt_eff_date,
                                                             a.eff_date
                                                            ),
                                   c.eff_date
                                  )
                          ) <= v_loss_date
                AND TRUNC (DECODE (TRUNC (c.expiry_date),
                                   TRUNC (a.expiry_date), DECODE
                                                        (NVL (a.endt_expiry_date,
                                                              a.expiry_date
                                                             ),
                                                         a.expiry_date, v_nbt_expiry_date,
                                                         a.endt_expiry_date
                                                        ),
                                   c.expiry_date
                                  )
                          ) >= v_loss_date
                AND b.policy_id = a.policy_id
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND a.line_cd = v_line_cd
                AND a.subline_cd = v_subline_cd
                AND a.iss_cd = v_pol_iss_cd
                AND a.issue_yy = v_issue_yy
                AND a.pol_seq_no = v_pol_seq_no
                AND a.renew_no = v_renew_no
                AND f.share_type = giisp.n ('NET_RETENTION')
           --roset, 6/9/2010, to select net ret
           GROUP BY a.line_cd,
                    a.subline_cd,
                    a.iss_cd,
                    a.issue_yy,
                    a.pol_seq_no,
                    a.renew_no,
                    d.share_cd,
                    f.share_type,
                    f.trty_yy,
                    f.acct_trty_type,
                    d.item_no,
                    d.peril_cd,
                    f.prtfolio_sw,
                    f.expiry_date,
                    f.trty_name)
       LOOP
          v_share_type := net_ret.share_type;
          v_share_cd := net_ret.share_cd;
          v_acct_trty_type := net_ret.acct_trty_type;
          v_trty_name := net_ret.trty_name;
       END LOOP;

       v_shr_pct := v_net_shr_loss_res * 100 / p_loss_reserve;
       v_shr_exp_res_amt := p_tot_exp_res_amt * v_shr_pct / 100;

       INSERT INTO gicl_reserve_ds
                   (claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no,
                    dist_year, item_no, peril_cd,
                    line_cd, grouped_item_no,
                    shr_loss_res_amt, shr_pct, shr_exp_res_amt,
                    share_type, acct_trty_type, hist_seq_no, negate_tag
                   )
            VALUES (p_claim_id, p_clm_res_hist_id, p_clm_dist_no, v_share_cd,
                    p_distribution_date, p_item_no, p_peril_cd,
                    v_line_cd, p_grouped_item_no,
                    v_net_shr_loss_res, v_shr_pct, v_shr_exp_res_amt,
                    v_share_type, v_acct_trty_type, p_hist_seq_no, null
                   );

       -- update gicl_policy_dist
       UPDATE gicl_policy_dist
          SET shr_tsi_pct = p_shr_loss_res_amt * 100 / p_loss_reserve,
              shr_tsi_amt =
                   p_c007_ann_tsi_amt
                 * (p_shr_loss_res_amt * 100 / p_loss_reserve)
                 / 100
        WHERE claim_id = p_claim_id
          AND grouped_item_no = p_grouped_item_no           --added by gmi 02/28/06
          AND item_no = p_item_no
          AND peril_cd = p_peril_cd
          AND share_type = p_share_type
          AND share_cd = p_grp_seq_no
          AND line_cd = v_line_cd;

       -- update gicl_policy_dist_ri
       FOR upd IN (SELECT ri_cd, shr_ri_pct_real
                     FROM gicl_reserve_rids
                    WHERE claim_id = p_claim_id
                      AND grouped_item_no = p_grouped_item_no
                      --added by gmi 02/28/06
                      AND item_no = p_item_no
                      AND peril_cd = p_peril_cd
                      AND clm_res_hist_id = p_clm_res_hist_id
                      AND clm_dist_no = p_clm_dist_no
                      AND grp_seq_no = p_grp_seq_no)
       LOOP
          UPDATE gicl_policy_dist_ri
             SET shr_ri_tsi_pct = upd.shr_ri_pct_real,
                 shr_ri_tsi_amt =
                      p_c007_ann_tsi_amt
                    * ((p_shr_loss_res_amt * 100 / p_loss_reserve) / 100)
                    * (upd.shr_ri_pct_real / 100)
           WHERE claim_id = p_claim_id
             AND grouped_item_no = p_grouped_item_no
             --added by gmi 02/28/06
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd
             AND share_cd = p_grp_seq_no
             AND share_type = p_share_type
             AND ri_cd = upd.ri_cd;
       END LOOP;
    END;
    
    PROCEDURE update_shr_pct (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_loss_reserve       gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_tot_shr_pct        gicl_reserve_ds.shr_pct%TYPE,
       p_shr_pct            gicl_reserve_ds.shr_pct%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    )
    IS
       v_shr_pct            gicl_reserve_ds.shr_pct%TYPE;
       v_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE;
    BEGIN
       FOR b IN (SELECT *
                   FROM gicl_reserve_ds
                  WHERE (negate_tag <> 'Y'
                     OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                        AND claim_id = p_claim_id
                        AND clm_res_hist_id = p_clm_res_hist_id
                        AND item_no = p_item_no
                        AND peril_cd = p_peril_cd
                        AND grp_seq_no = p_grp_seq_no
                        AND clm_dist_no = p_clm_dist_no)
       LOOP
          
          v_shr_pct := p_shr_pct;
          v_shr_loss_res_amt := p_tot_loss_res_amt * v_shr_pct/ 100;
          v_shr_exp_res_amt := p_tot_exp_res_amt * v_shr_pct / 100;
          
          IF v_shr_pct = 0 THEN 
               FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 DELETE gicl_reserve_rids
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          
               DELETE gicl_reserve_ds
                WHERE claim_id = b.claim_id
                  AND clm_res_hist_id = b.clm_res_hist_id
                  AND item_no = b.item_no
                  AND peril_cd = b.peril_cd
                  AND grp_seq_no = b.grp_seq_no;
          ELSE
              UPDATE gicl_reserve_ds
                 SET shr_pct = v_shr_pct,
                     shr_loss_res_amt = v_shr_loss_res_amt,
                     shr_exp_res_amt = v_shr_exp_res_amt
               WHERE claim_id = b.claim_id
                 AND clm_res_hist_id = b.clm_res_hist_id
                 AND item_no = b.item_no
                 AND peril_cd = b.peril_cd
                 AND grp_seq_no = b.grp_seq_no;

              FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 UPDATE gicl_reserve_rids
                    SET shr_ri_pct = v_shr_pct * i.shr_ri_pct_real / 100,
                        shr_loss_ri_res_amt = v_shr_loss_res_amt * i.shr_ri_pct_real / 100,
                        shr_exp_ri_res_amt = v_shr_exp_res_amt * i.shr_ri_pct_real / 100
                        
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          END IF;

          IF p_net_ret = 'N'
          THEN
             GICL_RESERVE_DS_PKG.create_net_ret_for_pct (b.claim_id,
                                         b.peril_cd,
                                         b.item_no,
                                         p_loss_reserve,
                                         p_tot_exp_res_amt,
                                         b.grouped_item_no,
                                         p_distribution_date,
                                         b.clm_res_hist_id,
                                         b.clm_dist_no,
                                         p_c007_ann_tsi_amt,
                                         b.grp_seq_no,
                                         b.share_type,
                                         b.hist_seq_no,
                                         p_tot_shr_pct,
                                         p_tot_loss_res_amt,
                                         p_shr_pct
                                        );
          END IF;
       END LOOP;

       IF p_net_ret = 'Y'
       THEN
          FOR a IN (SELECT *
                      FROM gicl_reserve_ds
                     WHERE (negate_tag <> 'Y'
                        OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                           AND claim_id = p_claim_id
                           AND clm_res_hist_id = p_clm_res_hist_id
                           AND item_no = p_item_no
                           AND peril_cd = p_peril_cd
                           AND share_type = 1)
          LOOP
              v_shr_pct := a.shr_pct + (100 - p_tot_shr_pct);
              v_shr_loss_res_amt := p_tot_loss_res_amt * v_shr_pct/ 100;
              v_shr_exp_res_amt := p_tot_exp_res_amt * v_shr_pct / 100;

             UPDATE gicl_reserve_ds
                SET shr_pct = v_shr_pct,
                    shr_loss_res_amt = v_shr_loss_res_amt,
                    shr_exp_res_amt = v_shr_exp_res_amt
              WHERE claim_id = a.claim_id
                AND clm_res_hist_id = a.clm_res_hist_id
                AND item_no = a.item_no
                AND peril_cd = a.peril_cd
                AND grp_seq_no = a.grp_seq_no;
          END LOOP;
       END IF;
    END;
    
    PROCEDURE update_shr_exp_res_amt (
       p_claim_id           gicl_reserve_rids.claim_id%TYPE,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_item_no            gicl_reserve_ds.item_no%TYPE,
       p_peril_cd           gicl_reserve_ds.peril_cd%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_expense_reserve    gicl_clm_res_hist.expense_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_tot_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_prev_exp_res_amt   gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_distribution_date  VARCHAR2,
       p_net_ret            VARCHAR2
    )
    IS
       v_shr_pct            gicl_reserve_ds.shr_pct%TYPE;
       v_shr_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE;
    BEGIN
       FOR b IN (SELECT *
                   FROM gicl_reserve_ds
                  WHERE (negate_tag <> 'Y'
                     OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                        AND claim_id = p_claim_id
                        AND clm_res_hist_id = p_clm_res_hist_id
                        AND item_no = p_item_no
                        AND peril_cd = p_peril_cd
                        AND grp_seq_no = p_grp_seq_no
                        AND clm_dist_no = p_clm_dist_no)
       LOOP
          v_shr_exp_res_amt  := p_shr_exp_res_amt;
          v_shr_pct          := v_shr_exp_res_amt * 100/p_expense_reserve;
          v_shr_loss_res_amt := p_tot_loss_res_amt * v_shr_pct/100;
          
          IF v_shr_exp_res_amt = 0 THEN 
               FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 DELETE gicl_reserve_rids
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          
               DELETE gicl_reserve_ds
                WHERE claim_id = b.claim_id
                  AND clm_res_hist_id = b.clm_res_hist_id
                  AND item_no = b.item_no
                  AND peril_cd = b.peril_cd
                  AND grp_seq_no = b.grp_seq_no;
          ELSE
              UPDATE gicl_reserve_ds
                 SET shr_pct = v_shr_pct,
                     shr_loss_res_amt = v_shr_loss_res_amt,
                     shr_exp_res_amt = v_shr_exp_res_amt
               WHERE claim_id = b.claim_id
                 AND clm_res_hist_id = b.clm_res_hist_id
                 AND item_no = b.item_no
                 AND peril_cd = b.peril_cd
                 AND grp_seq_no = b.grp_seq_no;

              FOR i IN (SELECT *
                          FROM gicl_reserve_rids
                         WHERE clm_dist_no = b.clm_dist_no
                           AND claim_id = b.claim_id
                           AND grp_seq_no = b.grp_seq_no
                           AND clm_res_hist_id = b.clm_res_hist_id)
              LOOP
                 UPDATE gicl_reserve_rids
                    SET shr_ri_pct = v_shr_pct * i.shr_ri_pct_real / 100,
                        shr_loss_ri_res_amt =
                                          v_shr_loss_res_amt * i.shr_ri_pct_real / 100,
                        shr_exp_ri_res_amt =
                                           v_shr_exp_res_amt * i.shr_ri_pct_real / 100
                  WHERE clm_dist_no = i.clm_dist_no
                    AND claim_id = i.claim_id
                    AND grp_seq_no = i.grp_seq_no
                    AND clm_res_hist_id = i.clm_res_hist_id
                    AND ri_cd = i.ri_cd;
              END LOOP;
          END IF;
          
          IF p_net_ret = 'N'
          THEN
             GICL_RESERVE_DS_PKG.create_net_ret_for_exp (b.claim_id,
                                         b.peril_cd,
                                         b.item_no,
                                         p_expense_reserve,
                                         p_tot_loss_res_amt,
                                         b.grouped_item_no,
                                         p_distribution_date,
                                         b.clm_res_hist_id,
                                         b.clm_dist_no,
                                         p_c007_ann_tsi_amt,
                                         p_prev_exp_res_amt,
                                         v_shr_exp_res_amt,
                                         b.grp_seq_no,
                                         b.share_type,
                                         b.hist_seq_no
                                        );
          END IF;
       END LOOP;

       IF p_net_ret = 'Y'
       THEN
          FOR a IN (SELECT *
                      FROM gicl_reserve_ds
                     WHERE (negate_tag <> 'Y'
                        OR negate_tag IS NULL) -- grace 09.07.2015 SR 4921 - added parentheses to correct the condition when displaying the distribution details
                           AND claim_id = p_claim_id
                           AND clm_res_hist_id = p_clm_res_hist_id
                           AND item_no = p_item_no
                           AND peril_cd = p_peril_cd
                           AND share_type = 1)
          LOOP
             v_shr_exp_res_amt  := a.shr_exp_res_amt + (p_expense_reserve - p_tot_exp_res_amt);
             v_shr_pct          := v_shr_exp_res_amt * 100/p_expense_reserve;
             v_shr_loss_res_amt := p_tot_loss_res_amt * v_shr_pct/100;

             UPDATE gicl_reserve_ds
                SET shr_pct = v_shr_pct,
                    shr_loss_res_amt = v_shr_loss_res_amt,
                    shr_exp_res_amt = v_shr_exp_res_amt
              WHERE claim_id = a.claim_id
                AND clm_res_hist_id = a.clm_res_hist_id
                AND item_no = a.item_no
                AND peril_cd = a.peril_cd
                AND grp_seq_no = a.grp_seq_no;
          END LOOP;
       END IF;
    END;
    
    PROCEDURE create_net_ret_for_pct (
       p_claim_id            gicl_claims.claim_id%TYPE,
       p_peril_cd            giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no             giuw_itemperilds_dtl.item_no%TYPE,
       p_loss_reserve        gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_exp_res_amt     gicl_reserve_ds.shr_exp_res_amt%TYPE,
       p_grouped_item_no     gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date   VARCHAR2,
       p_clm_res_hist_id     gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no         gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt    gicl_item_peril.ann_tsi_amt%TYPE,
       p_grp_seq_no          gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type          gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no         gicl_reserve_ds.hist_seq_no%TYPE,
       p_tot_shr_pct         gicl_reserve_ds.shr_pct%TYPE,
       p_tot_loss_res_amt    gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_upd_shr_pct         gicl_reserve_ds.shr_pct%TYPE
    )
    IS
       v_line_cd            gicl_claims.line_cd%TYPE;
       v_subline_cd         gicl_claims.subline_cd%TYPE;
       v_pol_iss_cd         gicl_claims.pol_iss_cd%TYPE;
       v_issue_yy           gicl_claims.issue_yy%TYPE;
       v_pol_seq_no         gicl_claims.pol_seq_no%TYPE;
       v_renew_no           gicl_claims.renew_no%TYPE;
       v_loss_date          gicl_claims.loss_date%TYPE;
       v_nbt_eff_date       gicl_claims.pol_eff_date%TYPE;         --pol_eff_date
       v_nbt_expiry_date    gicl_claims.expiry_date%TYPE;
       v_net_shr_loss_res   gicl_reserve_ds.shr_loss_res_amt%TYPE;
                           -- gets the value deducted from the loss reserve share
       v_net_shr_pct        gicl_reserve_ds.shr_pct%TYPE;
       v_shr_exp_res_amt    gicl_reserve_ds.shr_exp_res_amt%TYPE;
       v_share_type         gicl_reserve_ds.share_type%TYPE;
                           -- share_type value of Net Ret available for the claim
       v_share_cd           gicl_reserve_ds.grp_seq_no%TYPE;
                             -- share_cd value of Net Ret available for the claim
       v_acct_trty_type     gicl_reserve_ds.acct_trty_type%TYPE;
                       -- acct_trty_type value of Net Ret available for the claim
       v_trty_name          giis_dist_share.trty_name%TYPE;
                            -- trty_name value of Net Ret available for the claim
    BEGIN
       SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no,
              renew_no, loss_date, pol_eff_date, expiry_date
         INTO v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no,
              v_renew_no, v_loss_date, v_nbt_eff_date, v_nbt_expiry_date
         FROM TABLE (gicl_claims_pkg.get_related_claims2 (p_claim_id));

       -- get Net Retention details
       FOR net_ret IN
          (SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
                    f.acct_trty_type, f.expiry_date, f.trty_name
               FROM gipi_polbasic a,
                    gipi_item b,
                    giuw_pol_dist c,
                    giuw_itemperilds_dtl d,
                    giis_dist_share f,
                    giis_parameters e
              WHERE f.share_cd = d.share_cd
                AND f.line_cd = d.line_cd
                AND d.peril_cd = p_peril_cd
                AND d.item_no = p_item_no
                AND d.item_no = b.item_no
                AND d.dist_no = c.dist_no
                AND e.param_type = 'V'
                AND c.dist_flag = e.param_value_v
                AND e.param_name = 'DISTRIBUTED'
                AND c.policy_id = b.policy_id
                AND TRUNC (DECODE (TRUNC (c.eff_date),
                                   TRUNC (a.eff_date), DECODE
                                                            (TRUNC (a.eff_date),
                                                             TRUNC (a.incept_date), v_nbt_eff_date,
                                                             a.eff_date
                                                            ),
                                   c.eff_date
                                  )
                          ) <= v_loss_date
                AND TRUNC (DECODE (TRUNC (c.expiry_date),
                                   TRUNC (a.expiry_date), DECODE
                                                        (NVL (a.endt_expiry_date,
                                                              a.expiry_date
                                                             ),
                                                         a.expiry_date, v_nbt_expiry_date,
                                                         a.endt_expiry_date
                                                        ),
                                   c.expiry_date
                                  )
                          ) >= v_loss_date
                AND b.policy_id = a.policy_id
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND a.line_cd = v_line_cd
                AND a.subline_cd = v_subline_cd
                AND a.iss_cd = v_pol_iss_cd
                AND a.issue_yy = v_issue_yy
                AND a.pol_seq_no = v_pol_seq_no
                AND a.renew_no = v_renew_no
                AND f.share_type = giisp.n ('NET_RETENTION')
           --roset, 6/9/2010, to select net ret
           GROUP BY a.line_cd,
                    a.subline_cd,
                    a.iss_cd,
                    a.issue_yy,
                    a.pol_seq_no,
                    a.renew_no,
                    d.share_cd,
                    f.share_type,
                    f.trty_yy,
                    f.acct_trty_type,
                    d.item_no,
                    d.peril_cd,
                    f.prtfolio_sw,
                    f.expiry_date,
                    f.trty_name)
       LOOP
          v_net_shr_pct := 100 - p_tot_shr_pct;
          v_share_type := net_ret.share_type;
          v_share_cd := net_ret.share_cd;
          v_acct_trty_type := net_ret.acct_trty_type;
          v_trty_name := net_ret.trty_name;
       END LOOP;

       v_net_shr_loss_res := p_tot_loss_res_amt * v_net_shr_pct / 100;
       v_shr_exp_res_amt := p_tot_exp_res_amt * v_net_shr_pct / 100;

       INSERT INTO gicl_reserve_ds
                   (claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no,
                    dist_year, item_no, peril_cd, line_cd,
                    grouped_item_no, shr_loss_res_amt, shr_pct,
                    shr_exp_res_amt, share_type, acct_trty_type,
                    hist_seq_no, negate_tag
                   )
            VALUES (p_claim_id, p_clm_res_hist_id, p_clm_dist_no, v_share_cd,
                    p_distribution_date, p_item_no, p_peril_cd, v_line_cd,
                    p_grouped_item_no, v_net_shr_loss_res, v_net_shr_pct,
                    v_shr_exp_res_amt, v_share_type, v_acct_trty_type,
                    p_hist_seq_no, NULL
                   );

       -- update gicl_policy_dist
       UPDATE gicl_policy_dist
          SET shr_tsi_pct = v_net_shr_pct,
              shr_tsi_amt = p_c007_ann_tsi_amt * v_net_shr_pct / 100
        WHERE claim_id = p_claim_id
          AND grouped_item_no = p_grouped_item_no          --added by gmi 02/28/06
          AND item_no = p_item_no
          AND peril_cd = p_peril_cd
          AND share_type = p_share_type
          AND share_cd = p_grp_seq_no
          AND line_cd = v_line_cd;

       -- update gicl_policy_dist_ri
       FOR upd IN (SELECT ri_cd, shr_ri_pct_real
                     FROM gicl_reserve_rids
                    WHERE claim_id = p_claim_id
                      AND grouped_item_no = p_grouped_item_no
                      --added by gmi 02/28/06
                      AND item_no = p_item_no
                      AND peril_cd = p_peril_cd
                      AND clm_res_hist_id = p_clm_res_hist_id
                      AND clm_dist_no = p_clm_dist_no
                      AND grp_seq_no = p_grp_seq_no)
       LOOP
          UPDATE gicl_policy_dist_ri
             SET shr_ri_tsi_pct = upd.shr_ri_pct_real,
                 shr_ri_tsi_amt =
                      p_c007_ann_tsi_amt
                    * (p_upd_shr_pct / 100)
                    * (upd.shr_ri_pct_real / 100)
           WHERE claim_id = p_claim_id
             AND grouped_item_no = p_grouped_item_no
             --added by gmi 02/28/06
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd
             AND share_cd = p_grp_seq_no
             AND share_type = p_share_type
             AND ri_cd = upd.ri_cd;
       END LOOP;
    END;
    
    PROCEDURE create_net_ret_for_exp (
       p_claim_id           gicl_claims.claim_id%TYPE,
       p_peril_cd           giuw_itemperilds_dtl.peril_cd%TYPE,
       p_item_no            giuw_itemperilds_dtl.item_no%TYPE,
       p_expense_reserve    gicl_clm_res_hist.loss_reserve%TYPE,
       p_tot_loss_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grouped_item_no    gicl_reserve_ds.grouped_item_no%TYPE,
       p_distribution_date  VARCHAR2,
       p_clm_res_hist_id    gicl_reserve_ds.clm_res_hist_id%TYPE,
       p_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE,
       p_c007_ann_tsi_amt   gicl_item_peril.ann_tsi_amt%TYPE,
       p_prev_exp_res_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_shr_exp_res_amt    gicl_reserve_ds.shr_loss_res_amt%TYPE,
       p_grp_seq_no         gicl_reserve_ds.grp_seq_no%TYPE,
       p_share_type         gicl_reserve_ds.share_type%TYPE,
       p_hist_seq_no        gicl_reserve_ds.hist_seq_no%TYPE
    )
    IS
        v_line_cd               gicl_claims.line_cd%TYPE;
        v_subline_cd            gicl_claims.subline_cd%TYPE;
        v_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE;
        v_issue_yy              gicl_claims.issue_yy%TYPE;
        v_pol_seq_no            gicl_claims.pol_seq_no%TYPE;
        v_renew_no              gicl_claims.renew_no%TYPE;
        v_loss_date             gicl_claims.loss_date%TYPE;
        v_nbt_eff_date          gicl_claims.pol_eff_date%TYPE; --pol_eff_date
        v_nbt_expiry_date       gicl_claims.expiry_date%TYPE;
        
        v_net_shr_exp_res       gicl_reserve_ds.shr_exp_res_amt%TYPE;
        v_shr_pct               gicl_reserve_ds.shr_pct%TYPE;
        v_shr_loss_res_amt      gicl_reserve_ds.shr_loss_res_amt%TYPE;
        v_share_type            gicl_reserve_ds.share_type%TYPE; -- share_type value of Net Ret available for the claim
        v_share_cd              gicl_reserve_ds.grp_seq_no%TYPE; -- share_cd value of Net Ret available for the claim
        v_acct_trty_type        gicl_reserve_ds.acct_trty_type%TYPE; -- acct_trty_type value of Net Ret available for the claim
        v_trty_name             giis_dist_share.trty_name%TYPE; -- trty_name value of Net Ret available for the claim
    BEGIN
        v_net_shr_exp_res     := p_prev_exp_res_amt - p_shr_exp_res_amt;

        SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no,
               renew_no, loss_date, pol_eff_date, expiry_date
          INTO v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no,
               v_renew_no, v_loss_date, v_nbt_eff_date, v_nbt_expiry_date
          FROM TABLE (gicl_claims_pkg.get_related_claims2 (p_claim_id));

       -- get Net Retention details
       FOR net_ret IN
          (SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
                    f.acct_trty_type, f.expiry_date, f.trty_name
               FROM gipi_polbasic a,
                    gipi_item b,
                    giuw_pol_dist c,
                    giuw_itemperilds_dtl d,
                    giis_dist_share f,
                    giis_parameters e
              WHERE f.share_cd = d.share_cd
                AND f.line_cd = d.line_cd
                AND d.peril_cd = p_peril_cd
                AND d.item_no = p_item_no
                AND d.item_no = b.item_no
                AND d.dist_no = c.dist_no
                AND e.param_type = 'V'
                AND c.dist_flag = e.param_value_v
                AND e.param_name = 'DISTRIBUTED'
                AND c.policy_id = b.policy_id
                AND TRUNC (DECODE (TRUNC (c.eff_date),
                                   TRUNC (a.eff_date), DECODE
                                                            (TRUNC (a.eff_date),
                                                             TRUNC (a.incept_date), v_nbt_eff_date,
                                                             a.eff_date
                                                            ),
                                   c.eff_date
                                  )
                          ) <= v_loss_date
                AND TRUNC (DECODE (TRUNC (c.expiry_date),
                                   TRUNC (a.expiry_date), DECODE
                                                        (NVL (a.endt_expiry_date,
                                                              a.expiry_date
                                                             ),
                                                         a.expiry_date, v_nbt_expiry_date,
                                                         a.endt_expiry_date
                                                        ),
                                   c.expiry_date
                                  )
                          ) >= v_loss_date
                AND b.policy_id = a.policy_id
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND a.line_cd = v_line_cd
                AND a.subline_cd = v_subline_cd
                AND a.iss_cd = v_pol_iss_cd
                AND a.issue_yy = v_issue_yy
                AND a.pol_seq_no = v_pol_seq_no
                AND a.renew_no = v_renew_no
                AND f.share_type = giisp.n ('NET_RETENTION')
           --roset, 6/9/2010, to select net ret
           GROUP BY a.line_cd,
                    a.subline_cd,
                    a.iss_cd,
                    a.issue_yy,
                    a.pol_seq_no,
                    a.renew_no,
                    d.share_cd,
                    f.share_type,
                    f.trty_yy,
                    f.acct_trty_type,
                    d.item_no,
                    d.peril_cd,
                    f.prtfolio_sw,
                    f.expiry_date,
                    f.trty_name)
       LOOP
          v_share_type := net_ret.share_type;
          v_share_cd := net_ret.share_cd;
          v_acct_trty_type := net_ret.acct_trty_type;
          v_trty_name := net_ret.trty_name;
       END LOOP;
      
      v_shr_pct := v_net_shr_exp_res * 100 / p_expense_reserve;
      v_shr_loss_res_amt := p_tot_loss_res_amt * v_shr_pct / 100;

       INSERT INTO gicl_reserve_ds
                   (claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no,
                    dist_year, item_no, peril_cd, line_cd,
                    grouped_item_no, shr_loss_res_amt, shr_pct,
                    shr_exp_res_amt, share_type, acct_trty_type,
                    hist_seq_no, negate_tag
                   )
            VALUES (p_claim_id, p_clm_res_hist_id, p_clm_dist_no, v_share_cd,
                    p_distribution_date, p_item_no, p_peril_cd, v_line_cd,
                    p_grouped_item_no, v_shr_loss_res_amt, v_shr_pct,
                    v_net_shr_exp_res, v_share_type, v_acct_trty_type,
                    p_hist_seq_no, NULL
                   );

       -- update gicl_policy_dist
       UPDATE gicl_policy_dist
          SET shr_tsi_pct = p_shr_exp_res_amt * 100 / p_expense_reserve,
              shr_tsi_amt =
                   p_c007_ann_tsi_amt
                 * (p_shr_exp_res_amt * 100 / p_expense_reserve)
                 / 100
        WHERE claim_id = p_claim_id
          AND grouped_item_no = p_grouped_item_no           --added by gmi 02/28/06
          AND item_no = p_item_no
          AND peril_cd = p_peril_cd
          AND share_type = p_share_type
          AND share_cd = p_grp_seq_no
          AND line_cd = v_line_cd;

       -- update gicl_policy_dist_ri
       FOR upd IN (SELECT ri_cd, shr_ri_pct_real
                     FROM gicl_reserve_rids
                    WHERE claim_id = p_claim_id
                      AND grouped_item_no = p_grouped_item_no
                      --added by gmi 02/28/06
                      AND item_no = p_item_no
                      AND peril_cd = p_peril_cd
                      AND clm_res_hist_id = p_clm_res_hist_id
                      AND clm_dist_no = p_clm_dist_no
                      AND grp_seq_no = p_grp_seq_no)
       LOOP
          UPDATE gicl_policy_dist_ri
             SET shr_ri_tsi_pct = upd.shr_ri_pct_real,
                    shr_ri_tsi_amt =
                     p_c007_ann_tsi_amt
                   * ((p_shr_exp_res_amt * 100 / p_expense_reserve) / 100
                     )
                   * (upd.shr_ri_pct_real / 100)
           WHERE claim_id = p_claim_id
             AND grouped_item_no = p_grouped_item_no
             --added by gmi 02/28/06
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd
             AND share_cd = p_grp_seq_no
             AND share_type = p_share_type
             AND ri_cd = upd.ri_cd;
       END LOOP;
    END;
END GICL_RESERVE_DS_PKG;
/
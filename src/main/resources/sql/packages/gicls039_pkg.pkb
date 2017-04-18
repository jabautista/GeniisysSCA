CREATE OR REPLACE PACKAGE BODY CPI.gicls039_pkg
AS
   PROCEDURE reopen_claims (
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_refresh_sw        gicl_claims.refresh_sw%TYPE,
      p_max_endt_seq_no   gicl_claims.max_endt_seq_no%TYPE,
      p_dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      gicl_claims.pol_eff_date%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd        gicl_claims.iss_cd%TYPE,
      p_issue_yy          gicl_claims.issue_yy%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_renew_no          gicl_claims.renew_no%TYPE,
      p_assd_no           gicl_claims.assd_no%TYPE,
      p_acct_of_cd        gicl_claims.acct_of_cd%TYPE,
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_assd_name2        gicl_claims.assd_name2%TYPE,
      p_user_id           gicl_claims.user_id%TYPE
   )
   IS
      v_old_stat_cd   VARCHAR2 (2);
      v_chk_spld      VARCHAR2 (1)               := 'N';
      v_line_cd       gicl_claims.line_cd%TYPE;
   BEGIN
      BEGIN
         SELECT clm_stat_cd, line_cd
           INTO v_old_stat_cd, v_line_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_old_stat_cd := 'NW';
      END;

      FOR pol_flag IN (SELECT a.pol_flag
                         FROM gipi_polbasic a, gicl_claims b
                        WHERE b.claim_id = p_claim_id
                          AND a.line_cd = b.line_cd
                          AND a.subline_cd = b.subline_cd
                          AND a.iss_cd = b.pol_iss_cd
                          AND a.issue_yy = b.issue_yy
                          AND a.pol_seq_no = b.pol_seq_no
                          AND a.renew_no = b.renew_no
                          AND NVL (a.endt_seq_no, 0) > 0
                          AND a.pol_flag = '5'
                          AND TRUNC (a.eff_date) <= TRUNC (p_dsp_loss_date))
      LOOP
         v_chk_spld := 'Y';
         EXIT;
      END LOOP;

      BEGIN
         cpi.claim_status.update_status (p_claim_id, 'OP');
      END;

      IF NVL (v_chk_spld, 'N') = 'Y' AND NVL (p_refresh_sw, 'N') = 'Y'
      THEN
         cpi.gicl_claims_pkg.update_spoiled (p_claim_id,
                                             p_max_endt_seq_no,
                                             p_dsp_loss_date,
                                             p_pol_eff_date,
                                             NVL (p_line_cd, v_line_cd),
                                             p_subline_cd,
                                             p_pol_iss_cd,
                                             p_issue_yy,
                                             p_pol_seq_no,
                                             p_renew_no,
                                             p_assd_no,
                                             p_acct_of_cd,
                                             p_assured_name,
                                             p_assd_name2
                                            );
      ELSIF NVL (p_refresh_sw, 'N') = 'Y'
      THEN
         cpi.gicl_claims_pkg.update_endt_info (p_claim_id,
                                               p_max_endt_seq_no,
                                               p_dsp_loss_date,
                                               p_pol_eff_date,
                                               NVL (p_line_cd, v_line_cd),
                                               p_subline_cd,
                                               p_pol_iss_cd,
                                               p_issue_yy,
                                               p_pol_seq_no,
                                               p_renew_no,
                                               p_assd_no,
                                               p_acct_of_cd,
                                               p_assured_name,
                                               p_assd_name2
                                              );
      END IF;
   END;

   PROCEDURE close_claims (
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_line_cd         IN       gicl_claims.line_cd%TYPE,
      p_remarks         IN       gicl_claims.remarks%TYPE,
      p_recovery_sw     IN       gicl_claims.recovery_sw%TYPE,
      p_closed_status   IN       VARCHAR2,
      p_msg_txt         OUT      VARCHAR2
   )
   IS
      v_claim_id   gicl_claims.claim_id%TYPE;
      v_status     gicl_claims.clm_stat_cd%TYPE;
   BEGIN
      p_msg_txt := 'SUCCESS';

      BEGIN
         cpi.claim_status.update_status (p_claim_id, 'CD');
      END;
   END;

   PROCEDURE chk_clm_closing_gicls039 (
      v_claim_id      IN       gicl_claims.claim_id%TYPE,
      v_prntd_fla     IN       VARCHAR2,
      v_chk_tag       IN       VARCHAR2,
      v_batch_chkbx   OUT      VARCHAR2,
      v_tag_allow     OUT      VARCHAR2,
      v_param         OUT      VARCHAR2,
      v_msg_alert     OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT NVL (cpi.claim_status.validate_claim (v_claim_id, 'CD'), 'Y')
        INTO v_msg_alert
        FROM DUAL;

      IF v_msg_alert = 'Y'
      THEN
         v_batch_chkbx := 'Y';
         v_tag_allow := 'Y';
      ELSE
         v_batch_chkbx := 'N';
         v_tag_allow := 'N';
      END IF;

      IF NVL (v_prntd_fla, 0) = 1 AND v_msg_alert = 'Y'
      THEN
         BEGIN
            SELECT LTRIM (RTRIM (param_value_v)) param
              INTO v_param
              FROM giac_parameters
             WHERE param_name = 'CHECK_FLA';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_batch_chkbx := 'N';
               v_msg_alert :=
                  'Parameter CHECK_FLA does not exist. FLA cannot be validated. You cannot close the claim.';
            WHEN TOO_MANY_ROWS
            THEN
               v_batch_chkbx := 'N';
               v_msg_alert :=
                  'Multiple instance of CHECK_FLA parameter found. There will be no FLA Validation';
         END;
      END IF;
   END;

   PROCEDURE deny_claims_gicls039 (
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
      p_cat_payt_res_flag   IN OUT   VARCHAR2,
      p_cat_desc            OUT      VARCHAR2,
      p_msg_txt             OUT      VARCHAR2
   )
   IS
   BEGIN
      p_msg_txt := 'SUCCESS';

      BEGIN
         cpi.claim_status.update_status (p_claim_id, 'DN');
      END;
   END;

   PROCEDURE confirm_user_gicls039 (
      p_type                IN       VARCHAR2,
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
      p_select_type         IN       VARCHAR2,
      p_status_control      IN       NUMBER,
      p_cat_payt_res_flag   IN OUT   VARCHAR2,
      p_cat_desc            OUT      VARCHAR2,
      p_message_text        OUT      VARCHAR2
   )
   IS
      v_cat_res    VARCHAR2 (1)  := 'N';
      v_cat_payt   VARCHAR2 (1)  := 'N';
      v_res_net    VARCHAR2 (1)  := 'N';
      v_res_xol    VARCHAR2 (1)  := 'N';
      v_payt_net   VARCHAR2 (1)  := 'N';
      v_payt_xol   VARCHAR2 (1)  := 'N';
      v_temp       VARCHAR2 (10);
   BEGIN
      v_temp := SUBSTR (p_type, 1, INSTR (p_type, 'ing', 1, 1) - 1);

      IF (cpi.claim_status.get_paid_amt ('L', p_claim_id, NULL, NULL) > 0 OR cpi.claim_status.get_paid_amt ('E', p_claim_id, NULL, NULL) > 0)--added condition for Expense Kenneth 19935 08242015
      THEN
         p_message_text := 'LE';
      ELSIF (    cpi.claim_status.get_paid_amt ('L', p_claim_id, NULL, NULL) IS NULL
             AND cpi.claim_status.get_paid_amt ('E', p_claim_id, NULL, NULL) IS NULL
             AND cpi.claim_status.with_advice (p_claim_id) = 1
            )
      THEN
         p_message_text := 'AD';
      END IF;

      IF    claim_status.with_xol_in_reserve_cat (p_claim_id) = 1
         OR claim_status.with_xol_in_payment_cat (p_claim_id) = 1
      THEN
         FOR get_cat_desc IN (SELECT catastrophic_desc
                                FROM gicl_cat_dtl
                               WHERE catastrophic_cd = p_catastrophic_cd
                                 AND NVL (line_cd, p_line_cd) = p_line_cd)
         LOOP
            p_cat_desc :=
                  TO_CHAR (p_catastrophic_cd)
               || '-'
               || get_cat_desc.catastrophic_desc;
         END LOOP;

         IF p_status_control = 5
         THEN
            v_temp := SUBSTR (v_temp, 1, INSTR (v_temp, 'l', 1, 1));
         END IF;

         IF p_select_type = 'S'
         THEN
            p_message_text :=
                  'Claim''s catastrophic event is distributed for '
               || 'Excess of Loss, '
               || p_type
               || ' this will mean that you have to redistribute all claims under the event. <br><br>'
               || 'Are you sure you want to '
               || v_temp
               || ' this claim '
               || '('
               || p_line_cd
               || '-'
               || p_subline_cd
               || '-'
               || p_iss_cd
               || '-'
               || LPAD (TO_CHAR (p_clm_yy), 2, '0')
               || '-'
               || LPAD (TO_CHAR (p_clm_seq_no), 7, '0')
               || ')?';
         ELSE
            p_message_text :=
                  'Claim''s catastrophic event is distributed for '
               || 'Excess of Loss, '
               || p_type
               || ' this will mean redistributing all claim(s) under the event. '
               || 'Are you sure you want to '
               || v_temp
               || ' the claim(s)?';
         END IF;
      END IF;
   END;

   PROCEDURE withdraw_claims_gicls039 (
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
      p_cat_payt_res_flag   IN OUT   VARCHAR2,
      p_cat_desc            OUT      VARCHAR2,
      p_msg_txt             OUT      VARCHAR2
   )
   IS
   BEGIN
      p_msg_txt := 'SUCCESS';

      BEGIN
         cpi.claim_status.update_status (p_claim_id, 'WD');
      END;
   END;

   PROCEDURE cancel_claims_gicls039 (
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
      p_cat_payt_res_flag   IN OUT   VARCHAR2,
      p_cat_desc            OUT      VARCHAR2,
      p_msg_txt             OUT      VARCHAR2
   )
   IS
   BEGIN
       p_msg_txt := 'SUCCESS';

      BEGIN
         cpi.claim_status.update_status (p_claim_id, 'CC');
      END;
   END;
   
FUNCTION get_assured_lov (p_find_text VARCHAR2) -- added by gab 08.14.2015
   RETURN assured_tab PIPELINED
AS
   v_rec   assured_type;
BEGIN
   FOR i IN (SELECT DISTINCT assd_no, assured_name
                        FROM gicl_claims
                       WHERE assd_no LIKE NVL (p_find_text, assd_no)
                          OR assured_name LIKE
                                       NVL (UPPER (p_find_text), assured_name))
   LOOP
      v_rec.assd_no := i.assd_no;
      v_rec.assured_name := i.assured_name;
      PIPE ROW (v_rec);
   END LOOP;

   RETURN;
END;

    --moved from gicl_claims_pkg kenneth L SR 5147 11.13.2015
    FUNCTION get_claim_closing_listing(
       p_clm_line_cd       gicl_claims.line_cd%TYPE,
       p_clm_subline_cd    gicl_claims.subline_cd%TYPE,
       p_clm_iss_cd        gicl_claims.iss_cd%TYPE,
       p_clm_yy            gicl_claims.clm_yy%TYPE,
       p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
       p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
       p_pol_issue_yy      gicl_claims.issue_yy%TYPE,
       p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
       p_pol_renew_no      gicl_claims.renew_no%TYPE,
       p_assd_no           gicl_claims.assd_no%TYPE, 
       p_search_by         NUMBER,
       p_as_of_date        VARCHAR2,
       p_from_date         VARCHAR2,
       p_to_date           VARCHAR2,          
       p_status_control    VARCHAR2
       )
       RETURN gicl_claim_closing_tab PIPELINED
   IS
          v_claims                gicl_claim_closing_type;
       v_record                gicl_claims%ROWTYPE;
       v_cancelled_status      gicl_claims.clm_stat_cd%type;
       v_denied_status         gicl_claims.clm_stat_cd%type;
       v_closed_status         gicl_claims.clm_stat_cd%type;
       v_withdrawn_status      gicl_claims.clm_stat_cd%type;
       v_stmt_str              VARCHAR2 (2000);
       v_clm_setld             VARCHAR2 (1) := 'Y'; --true
       --v_advice_exist          NUMBER;              --VARCHAR2 (1) := 'N';

       --CHK_CLAIM_CLOSING
       v_item_payt_sw          VARCHAR2 (1) := 'N';
       v_res_net_cc            VARCHAR2 (1) := 'N';
       v_res_xol_cc            VARCHAR2 (1) := 'N';
       v_payt_net_cc           VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cc           VARCHAR2 (1) := 'N';
       v_res_net_2cd           VARCHAR2 (1) := 'N';                                --**
       v_res_xol_2cd           VARCHAR2 (1) := 'N';                                --**
       v_payt_net_2cd          VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_2cd          VARCHAR2 (1) := 'N';
       v_paid_net_2cd          VARCHAR2 (1) := 'N';                                --**
       v_paid_xol_2cd          VARCHAR2 (1) := 'N';                                --**
       v_res_net_cd            VARCHAR2 (1) := 'N';                                --**
       v_res_xol_cd            VARCHAR2 (1) := 'N';
       v_payt_net_cd           VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cd           VARCHAR2 (1) := 'N';

       v_losses_paid           NUMBER       := 0;
       v_expenses_paid         NUMBER       := 0;
       v_loss_res              NUMBER       := 0;
       v_exp_res               NUMBER       := 0;
       v_payt_sw               VARCHAR2 (1) := 'N';

       v_advice_exist          VARCHAR2 (1) := 'N';
       v_checked_payment       VARCHAR2 (1) := 'N';
       v_with_recovery         VARCHAR2 (1) := 'N';

       TYPE v_cur_type IS REF CURSOR;

       v_cursor   v_cur_type;

   BEGIN
      BEGIN  
        SELECT param_value_v
          INTO v_cancelled_status
          FROM giac_parameters
         WHERE param_name LIKE 'CANCELLED';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'CANCELLED parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_withdrawn_status
          FROM giac_parameters
         WHERE param_name LIKE 'WITHDRAWN';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'WITHDRAWN parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_denied_status
          FROM giac_parameters
         WHERE param_name LIKE 'DENIED';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'DENIED parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_closed_status
          FROM giac_parameters
         WHERE param_name LIKE 'CLOSED CLAIM';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'CLOSED CLAIM parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      v_stmt_str :=  'SELECT *'
                 ||  '  FROM gicl_claims a'
                 ||  ' WHERE 1=1'
                 ||  '   AND clm_yy = NVL(:p_clm_yy, clm_yy)'
                 ||  '   AND clm_seq_no = NVL(:p_clm_seq_no, clm_seq_no)'
                 ||  '   AND iss_cd = NVL(:p_clm_iss_cd, iss_cd)'
                 ||  '   AND subline_cd = NVL(:p_clm_subline_cd, subline_cd)'
                 ||  '   AND line_cd = NVL(:p_clm_line_cd, line_cd)'
                 ||  '   AND pol_iss_cd = NVL(:p_pol_iss_cd, pol_iss_cd)'
                 ||  '   AND issue_yy = NVL(:p_pol_issue_yy, issue_yy)'
                 ||  '   AND pol_seq_no = NVL(:p_pol_seq_no, pol_seq_no)'
                 ||  '   AND renew_no = NVL(:p_pol_renew_no, renew_no)'
                 ||  '   AND assd_no = NVL(:p_assd_no, assd_no)';                     
      
      IF p_search_by <> '0' THEN
        IF p_search_by = '1' THEN
          v_stmt_str := v_stmt_str || ' AND TRUNC(clm_file_date)';
        ELSIF p_search_by = '2' THEN
          v_stmt_str := v_stmt_str || ' AND TRUNC(loss_date)';
        END IF;
        
        IF p_as_of_date IS NOT NULL THEN
          v_stmt_str := v_stmt_str || ' < TO_DATE('''||p_as_of_date||''', ''MM-DD-YYYY'')';
        ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
          v_stmt_str := v_stmt_str || ' BETWEEN TO_DATE('''||p_from_date||''', ''MM-DD-YYYY'') AND TO_DATE('''||p_to_date||''', ''MM-DD-YYYY'')';
        END IF;
      END IF;
      
      IF p_status_control = '1' THEN

      v_stmt_str := v_stmt_str
                    || ' AND clm_stat_cd in(''' || v_cancelled_status || ''',
                                             ''' || v_closed_status || ''',
                                             ''' || v_withdrawn_status || ''',
                                             ''' || v_denied_status || ''')'||' 
                         ORDER BY get_claim_number(claim_id)';

      ELSIF p_status_control = '2' THEN

      v_stmt_str := v_stmt_str
                    || ' AND claim_id in (SELECT b.claim_id
                                             FROM gicl_clm_res_hist b,gicl_item_peril c
                                             WHERE b.claim_id = c.claim_id
                                              AND b.item_no = c.item_no
                                              AND tran_id IS NOT NULL
                                              AND nvl(b.grouped_item_no,0) = nvl(c.grouped_item_no,0)
                                              AND b.peril_cd = c.peril_cd
                                              AND NVL(cancel_tag, ''N'') = ''N'')
                           AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')
                         ORDER BY get_claim_number(claim_id)';
      ELSIF p_status_control IN ('3', '4', '5') THEN
      v_stmt_str := v_stmt_str
                    || ' AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')
                         ORDER BY get_claim_number(claim_id)';
      /*ELSIF p_status_control IN ('4','5') THEN

      v_stmt_str := v_stmt_str
                    || ' WHERE check_user_per_iss_Cd2(LINE_CD,iss_cd,:controlmodule, :user_id)=1
                          AND claim_id in (SELECT b.claim_id
                                             FROM gicl_clm_res_hist b,gicl_item_peril c
                                            WHERE B.claim_id = c.claim_id
                                              AND b.item_no = c.item_no
                                              AND nvl(b.grouped_item_no,0) = nvl(c.grouped_item_no,0)
                                              AND b.peril_cd = c.peril_cd
                                              AND tran_id IS NULL
                                              AND NVL(cancel_tag, ''N'') = ''N'')
                           AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')';*/
      END IF;

      OPEN v_cursor FOR v_stmt_str
         USING p_clm_yy, p_clm_seq_no, p_clm_iss_cd, p_clm_subline_cd, p_clm_line_cd, p_pol_iss_cd, p_pol_issue_yy, p_pol_seq_no, p_pol_renew_no, p_assd_no;             

      LOOP
          FETCH v_cursor INTO v_record;

          v_claims.claim_no         := v_record.line_cd || '-' || v_record.subline_cd || '-' || v_record.iss_cd || '-' ||
                                        LTRIM (TO_CHAR (v_record.clm_yy, '00')) || '-' || LTRIM (TO_CHAR (v_record.clm_seq_no, '0000009'));
          v_claims.policy_no        := v_record.line_cd || '-' || v_record.subline_cd || '-' || v_record.pol_iss_cd || '-' || LTRIM (TO_CHAR (v_record.issue_yy, '00')) || '-' ||
                                        LTRIM (TO_CHAR (v_record.pol_seq_no, '0000009')) || '-' || LTRIM (TO_CHAR (v_record.renew_no, '00'));
          v_claims.line_cd          := v_record.line_cd;
          v_claims.subline_cd       := v_record.subline_cd;
          v_claims.iss_cd           := v_record.iss_cd;
          v_claims.clm_yy           := v_record.clm_yy;
          v_claims.clm_seq_no       := v_record.clm_seq_no;
          v_claims.pol_iss_cd       := v_record.pol_iss_cd;
          v_claims.issue_yy         := v_record.issue_yy;
          v_claims.pol_seq_no       := v_record.pol_seq_no;
          v_claims.renew_no         := v_record.renew_no;
          v_claims.assd_no          := v_record.assd_no;
          v_claims.assured_name     := v_record.assured_name;
          v_claims.claim_id         := v_record.claim_id;
          v_claims.dsp_loss_date    := v_record.dsp_loss_date;
          v_claims.clm_file_date    := v_record.clm_file_date;
          v_claims.remarks          := v_record.remarks;
          v_claims.close_date       := v_record.close_date;
          v_claims.entry_date       := v_record.entry_date;
          v_claims.last_update      := v_record.last_update;
          v_claims.in_hou_adj       := v_record.in_hou_adj;
          v_claims.user_id          := v_record.user_id;
          v_claims.loss_res_amt     := v_record.loss_res_amt;
          v_claims.exp_res_amt      := v_record.exp_res_amt;
          v_claims.loss_pd_amt      := v_record.loss_pd_amt;
          v_claims.exp_pd_amt       := v_record.exp_pd_amt;
          v_claims.clm_control      := v_record.clm_control;
          v_claims.clm_coop         := v_record.clm_coop;
          v_claims.recovery_sw      := v_record.recovery_sw;
          v_claims.refresh_sw       := v_record.refresh_sw;
          v_claims.max_endt_seq_no  := v_record.max_endt_seq_no;
          v_claims.loss_date        := v_record.loss_date;
          v_claims.clm_setl_date    := v_record.clm_setl_date;
          v_claims.loss_loc1        := v_record.loss_loc1;
          v_claims.loss_loc2        := v_record.loss_loc2;
          v_claims.loss_loc3        := v_record.loss_loc3;
          v_claims.pol_eff_date     := v_record.pol_eff_date;
          v_claims.expiry_date      := v_record.expiry_date;
          v_claims.csr_no           := v_record.csr_no;
          v_claims.loss_cat_cd      := v_record.loss_cat_cd;
          v_claims.intm_no          := v_record.intm_no;
          v_claims.clm_amt          := v_record.clm_amt;
          v_claims.loss_dtls        := v_record.loss_dtls;
          v_claims.obligee_no       := v_record.obligee_no;
          v_claims.ri_cd            := v_record.ri_cd;
          v_claims.plate_no         := v_record.plate_no;
          v_claims.cpi_rec_no       := v_record.cpi_rec_no;
          v_claims.cpi_branch_cd    := v_record.cpi_branch_cd;
          v_claims.old_stat_cd      := v_record.old_stat_cd;
          v_claims.catastrophic_cd  := v_record.catastrophic_cd;
          v_claims.acct_of_cd       := v_record.acct_of_cd;
          v_claims.clm_stat_cd      := v_record.clm_stat_cd;
          v_claims.reason_cd        := v_record.reason_cd;
          
          BEGIN
            v_claims.reason_desc := '';

            SELECT reason_desc
              INTO v_claims.reason_desc
              FROM gicl_reasons
             WHERE reason_cd = v_claims.reason_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.reason_desc := '';
          END;
          
          BEGIN
          v_claims.clm_stat_desc := '';
    
            SELECT clm_stat_desc
              INTO v_claims.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = v_record.clm_stat_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.clm_stat_desc := '';
          END;
          
          BEGIN
          v_claims.dsp_cat_desc := '';

            SELECT catastrophic_desc
              INTO v_claims.dsp_cat_desc
              FROM gicl_cat_dtl
             WHERE catastrophic_cd = v_record.catastrophic_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.dsp_cat_desc := 'INVALID';
          END;

          BEGIN
          v_claims.pol_flag := '';

            SELECT a.pol_flag
              INTO v_claims.pol_flag
              FROM gipi_polbasic a, gicl_claims b
             WHERE b.claim_id = v_record.claim_id
               AND a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.iss_cd = b.pol_iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND NVL(a.endt_seq_no,0) = 0;
          EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.pol_flag := '';
          END;


          v_clm_setld := 'Y';

          FOR i IN (SELECT 1
                      FROM gicl_clm_res_hist
                     WHERE claim_id = v_record.claim_id
                       AND date_paid IS NOT NULL
                       AND tran_id IS NOT NULL
                       AND NVL (cancel_tag, 'N') = 'N'
                     GROUP BY claim_id
                    HAVING NVL (SUM (losses_paid), 0) <> 0
                        OR NVL (SUM (expenses_paid), 0) <> 0)
          LOOP
             v_clm_setld := 'N'; --false
             EXIT;
          END LOOP;

          v_claims.clm_setld  :=  v_clm_setld;

          v_advice_exist := 'N'; --to clear previous value
          v_checked_payment := 'N';

          IF p_status_control = '2' THEN
            FOR chk_adv IN (SELECT advice_id
                              FROM gicl_advice
                             WHERE claim_id = v_record.claim_id
                               AND advice_flag = 'Y'
                               AND (apprvd_tag = 'Y'
                                    OR batch_csr_id IS NOT NULL
                                    OR batch_dv_id IS NOT NULL
                                   ))
            LOOP
                v_advice_exist := 'Y';
                FOR chk_payment IN (SELECT '1'
                               FROM gicl_clm_loss_exp
                              WHERE advice_id = chk_adv.advice_id
                                AND tran_id IS NULL
                                AND tran_date IS NULL)
                LOOP
                    v_checked_payment := 'Y';
                END LOOP;

            END LOOP;

          ELSE
              IF  v_clm_setld = 'Y' THEN
                FOR chk_adv IN (SELECT advice_id
                                  FROM gicl_advice
                                 WHERE claim_id = v_record.claim_id
                                   AND advice_flag = 'Y'
                                   AND apprvd_tag = 'Y')
                LOOP
                    v_advice_exist := 'Y';
                    EXIT;
                END LOOP;
              END IF;
          END IF;

          v_claims.advice_exist := v_advice_exist;
          v_claims.chk_payment := v_checked_payment;

         -- CHECK CLAIM CLOSING

          v_payt_sw := 'N';

          FOR item_perl IN (SELECT item_no, peril_cd, close_flag, close_flag2,
                            grouped_item_no            --EMCY da091406te: GPA
                       FROM gicl_item_peril a
                      --WHERE claim_id = :c003.claim_id    --   EMCHANG
                     WHERE  claim_id = v_record.claim_id
                        --modified closed flag condition by Edison 09.05.2012, added closed_flag2
                        AND (   NVL (close_flag, 'AP') IN ('AP', 'CP', 'CC')
                             OR NVL (close_flag2, 'AP') IN ('AP', 'CP', 'CC')
                            ))
          LOOP
              v_item_payt_sw := 'N';                              --Edison 09.05.2012

              --check if payment has been made for active item peril
              FOR payt IN (SELECT '1'
                             FROM gicl_clm_res_hist
                            WHERE claim_id = v_record.claim_id
                              --WHERE claim_id = :c003.claim_id
                              AND item_no = item_perl.item_no
                              AND NVL (grouped_item_no, 0) =
                                                    NVL (item_perl.grouped_item_no, 0)
                              --EMCY da091406te:GPA
                              AND peril_cd = item_perl.peril_cd
                              AND tran_id IS NOT NULL
                              AND NVL (cancel_tag, 'N') = 'N')
              LOOP
                 v_item_payt_sw := 'Y';
                 --variables.v_goflag := TRUE;
                 --EXIT;

                 --to check the value of reserve and payments.
                 SELECT SUM (NVL (losses_paid, 0)) loss_paid,
                        SUM (NVL (expenses_paid, 0)) exp_paid
                   INTO v_losses_paid,
                        v_expenses_paid
                   FROM gicl_clm_res_hist
                  WHERE claim_id = v_record.claim_id
                    AND item_no = item_perl.item_no
                    AND peril_cd = item_perl.peril_cd
                    AND tran_id IS NOT NULL
                    AND NVL (cancel_tag, 'N') = 'N';

                 SELECT SUM (NVL (loss_reserve, 0)) loss,
                        SUM (NVL (expense_reserve, 0)) expense
                   INTO v_loss_res,
                        v_exp_res
                   FROM gicl_clm_res_hist
                  WHERE claim_id = v_record.claim_id
                    AND item_no = item_perl.item_no
                    AND peril_cd = item_perl.peril_cd
                    AND tran_id IS NULL
                    AND NVL (cancel_tag, 'N') = 'N'
                    AND clm_res_hist_id IN (
                           SELECT MAX (clm_res_hist_id)
                             FROM gicl_clm_res_hist
                            WHERE claim_id = v_record.claim_id
                              AND item_no = item_perl.item_no
                              AND peril_cd = item_perl.peril_cd
                              AND tran_id IS NULL
                              AND NVL (cancel_tag, 'N') = 'N');

                 IF     NVL (item_perl.close_flag, 'AP') = 'AP'
                    AND NVL (item_perl.close_flag2, 'AP') = 'AP'
                 THEN                            --if both (loss and expense) are open
                    IF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) <> 0
                    THEN                                       --if both have reserve
                       IF v_losses_paid <> 0 AND v_expenses_paid <> 0
                       THEN                                    --if both have payment
                          IF     v_loss_res = v_losses_paid
                             AND v_exp_res = v_expenses_paid
                          THEN                        --if both reserve are fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    ELSIF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) = 0
                    THEN                  --if has loss reserve but no expense reserve
                       IF NVL (v_losses_paid, 0) <> 0
                       THEN                                     --if loss has payment
                          IF v_loss_res = v_losses_paid
                          THEN                        --if loss reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    ELSIF NVL (v_exp_res, 0) <> 0 AND NVL (v_loss_res, 0) = 0
                    THEN                  --if has expense reserve but no loss reserve
                       IF NVL (v_expenses_paid, 0) <> 0
                       THEN                                  --if expense has payment
                          IF v_exp_res = v_expenses_paid
                          THEN                     --if expense reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag, 'AP') = 'AP'
                       AND NVL (item_perl.close_flag2, 'AP') != 'AP'
                 THEN                                   --if only loss reserve is open
                    IF NVL (v_loss_res, 0) <> 0
                    THEN                                        --if has loss reserve
                       IF NVL (v_losses_paid, 0) <> 0
                       THEN                                     --if loss has payment
                          IF v_loss_res = v_losses_paid
                          THEN                        --if loss reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag2, 'AP') = 'AP'
                       AND NVL (item_perl.close_flag, 'AP') != 'AP'
                 THEN                                    --if only expense res is open
                    IF NVL (v_exp_res, 0) <> 0
                    THEN                                     --if has expense reserve
                       IF NVL (v_expenses_paid, 0) <> 0
                       THEN                                  --if expense has payment
                          IF v_exp_res = v_expenses_paid
                          THEN                     --if expense reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag2, 'AP') != 'AP'
                       AND NVL (item_perl.close_flag, 'AP') != 'AP'
                 THEN                        --if both (loss and reserve) are not open
                    v_item_payt_sw := 'Y';
                    v_payt_sw := 'Y';
                 END IF;
              END LOOP;                                               -- end loop payt

              --if loss reserve has no payment
              IF v_item_payt_sw = 'N'
              THEN
                 IF item_perl.close_flag = 'AP'
                 THEN
                    gicl_claims_pkg.chk_cancelled_xol_res(
                                        v_res_net_cc,
                                        v_res_xol_cc,
                                        item_perl.item_no,
                                        item_perl.grouped_item_no,
                                        item_perl.peril_cd,
                                        v_record.claim_id
                                        );
                    gicl_claims_pkg.chk_cancelled_xol_payt (
                                        v_payt_net_cc,
                                        v_payt_xol_cc,
                                        item_perl.item_no,
                                        item_perl.grouped_item_no,
                                        item_perl.peril_cd,
                                        v_record.claim_id
                                        );
                 END IF;
              END IF;

              --IF LOSS RESERVE HAS PAYMENT AND ACTIVE
              IF     (item_perl.close_flag = 'AP' OR item_perl.close_flag2 = 'AP')
                 AND v_item_payt_sw = 'Y'
              THEN
                 gicl_claims_pkg.chk_cancelled_xol_res(
                                     v_res_net_2cd,
                                     v_res_xol_2cd,
                                     item_perl.item_no,
                                     item_perl.grouped_item_no,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_cancelled_xol_payt(
                                     v_payt_net_2cd,
                                     v_payt_xol_2cd,
                                     item_perl.item_no,
                                     item_perl.grouped_item_no,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_paid_xol_payt(
                                     v_paid_net_2cd,
                                     v_paid_xol_2cd,
                                     item_perl.item_no,
                                     NVL (item_perl.grouped_item_no, 0),
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
              END IF;

              --IF LOSS RESERVE IS CLOSED
              IF    item_perl.close_flag IN ('CP', 'CC')
                 OR item_perl.close_flag2 IN ('CP', 'CC')
              THEN
                 gicl_claims_pkg.chk_cancelled_xol_res (
                                     v_res_net_cd,
                                     v_res_xol_cd,
                                     item_perl.item_no,
                                     2,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_paid_xol_payt (
                                     v_payt_net_cd,
                                     v_payt_xol_cd,
                                     item_perl.item_no,
                                     2,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
              END IF;
          END LOOP;

          v_claims.payt_sw := v_payt_sw;

          v_with_recovery := 'N';
          FOR i IN
               (SELECT 1
                  FROM gicl_clm_recovery
                 WHERE claim_id = v_record.claim_id
                   AND NVL(cancel_tag, 'N') NOT IN ('C', 'Y'))
          LOOP
           v_with_recovery := 'Y';
          END LOOP;

          v_claims.with_recovery := v_with_recovery;

          EXIT WHEN v_cursor%NOTFOUND;
          PIPE ROW (v_claims);
      END LOOP;

      CLOSE v_cursor;
   END get_claim_closing_listing;
   
    
   --start kenneth L SR 5147 11.13.2015
    FUNCTION get_reason_lov (
       p_find_text       VARCHAR2,
       p_order_by        VARCHAR2,
       p_asc_desc_flag   VARCHAR2,
       p_from            NUMBER,
       p_to              NUMBER
    )
       RETURN reason_list_tab PIPELINED
    AS
       TYPE cur_type IS REF CURSOR;

       c       cur_type;
       v_rec   reason_list_type;
       v_sql   VARCHAR2 (9000);
    BEGIN
       v_sql :=
          'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.*
                                  FROM (select reason_cd, reason_desc from gicl_reasons';

       IF p_find_text IS NOT NULL
       THEN
          v_sql := v_sql || ' WHERE (reason_cd LIKE UPPER(''' || p_find_text || ''')
                                  OR reason_desc LIKE UPPER(''' || p_find_text || '''))';
       END IF;

       v_sql := v_sql || ' ) innersql';

       IF p_order_by IS NOT NULL
       THEN
          IF p_order_by = 'reasonCode'
          THEN
             v_sql := v_sql || ' ORDER BY reason_cd ';
          ELSIF p_order_by = 'reasonDesc'
          THEN
             v_sql := v_sql || ' ORDER BY reason_desc ';
          END IF;

          IF p_asc_desc_flag IS NOT NULL
          THEN
             v_sql := v_sql || p_asc_desc_flag;
          ELSE
             v_sql := v_sql || ' ASC';
          END IF;
       END IF;

       v_sql := v_sql || ' ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

       OPEN c FOR v_sql;

       LOOP
          FETCH c
           INTO v_rec.count_, v_rec.rownum_, v_rec.reason_cd, v_rec.reason_desc;

          EXIT WHEN c%NOTFOUND;
          PIPE ROW (v_rec);
       END LOOP;

       CLOSE c;
    END;
    
    PROCEDURE update_reason_cd (
       p_claim_id    IN   gicl_claims.claim_id%TYPE,
       p_reason_cd   IN   gicl_claims.reason_cd%TYPE
    )
    IS
    BEGIN
       UPDATE gicl_claims
          SET reason_cd = p_reason_cd
        WHERE claim_id = p_claim_id;
    END;
    --end kenneth L SR 5147 11.13.2015
    
END;
/

CREATE OR REPLACE PACKAGE BODY CPI.Bancassurance
/* Created by : Marion
** Date : March 2, 2010
** Description : Function Validate_bancassurance will validate if the current record is for bancassurance.
**                     Procedure Get_Default_Tax_Rt and Process_Commission will override the peril commission rates,
**                 instead of retrieving the rates maintained, rates should be based from Giis_banc_Type.rate
**
*/
AS

FUNCTION Validate_Bancassurance (
   p_par_id   GIPI_WCOMM_INVOICES.par_id%TYPE
)
   RETURN VARCHAR2
IS
   v_bancassurance   VARCHAR2(1) := NULL;

   BEGIN
    SELECT bancassurance_sw BANC_SW
      INTO v_bancassurance
      FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id;
  IF v_bancassurance IS NULL OR v_bancassurance <> 'Y' THEN
     v_bancassurance := 'N';
  END IF;
  RETURN (v_bancassurance);
END Validate_Bancassurance;

--get_default_tax_rt
PROCEDURE Get_Default_Tax_Rt
     ( p_B240_PAR_ID                     IN GIPI_PARLIST.par_id%TYPE,
       p_B240_par_type                    IN GIPI_PARLIST.par_type%TYPE,
       p_WCOMINV_PAR_ID                    IN GIPI_WCOMM_INVOICES.par_id%TYPE,
       p_wcominv_intrmdry_intm_no        IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
       p_WCOMINV_intrmdry_intm_no_nbt    IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
       p_WCOMINV_share_percentage        IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_WCOMINV_share_percentage_nbt    IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_b450_takeup_seq_no                IN GIPI_WINVOICE.takeup_seq_no%TYPE,
       p_SYSTEM_record_status            IN VARCHAR2,
       p_WCOMINV_ITEM_GRP                IN GIPI_WCOMM_INVOICES.item_grp%TYPE,
       variables_var_tax_amt            OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_GLOBAL_cancel_tag                IN VARCHAR2,
       v_rg_id                           OUT VARCHAR2,
       v_ov                               OUT VARCHAR2,
       variables_v_override_whtax       OUT VARCHAR2, 
       variables_v_comm_update_tag       OUT GIIS_USERS.comm_update_tag%TYPE,
       variables_switch_no                OUT VARCHAR2,
       variables_switch_name           OUT VARCHAR2,
       variables_v_param_show_comm       OUT VARCHAR2,
       p_wcominvper_wholding_tax       OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_wcominvper_commission_amt        IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       v_go_clear_block                   OUT VARCHAR2,
       v_remove_clrd_rw_frm_grp        OUT VARCHAR2,
       v_check_comm_peril               OUT VARCHAR2,
       v_msg_alert1                       OUT VARCHAR2,
       v_upd_wcomm_inv_prls               OUT VARCHAR2,
       v_pop_wcomm_inv_prls               OUT VARCHAR2,
       v_del_wcomm_inv_prls               OUT VARCHAR2,
       v_msg_alert2                       OUT VARCHAR2,
       v_show_view                       OUT VARCHAR2,
       v_hide_view                       OUT VARCHAR2,
       v_set_itm_prop1                   OUT NUMBER,
       v_set_itm_prop2                   OUT NUMBER,
       v_go_item                       OUT VARCHAR2,
       v_compute_tot_com               OUT VARCHAR2,
       v_add_group_row                   OUT VARCHAR2,
       v_policy_id                        IN GIPI_POLBASIC.policy_id%TYPE
  )IS
  VAR_CORP_TAG   GIIS_INTERMEDIARY.corp_tag%TYPE;
  v_pol_flag     GIPI_POLBASIC.pol_flag%TYPE       := NULL;
  V_ANN_TSI_AMT  GIPI_WPOLBAS.ANN_TSI_AMT%TYPE;
  V_ENDT_TYPE    GIPI_WPOLBAS.ENDT_TYPE%TYPE;
  v_whtax         GIPI_COMM_INV_PERIL.wholding_tax%TYPE        := 0;
  v_comm_amt     GIPI_COMM_INV_PERIL.commission_amt%TYPE    := 0;
BEGIN
      SELECT ANN_TSI_AMT, ENDT_TYPE
        INTO V_ANN_TSI_AMT, V_ENDT_TYPE
        FROM GIPI_WPOLBAS
       WHERE PAR_ID = p_B240_PAR_ID;
    IF p_B240_par_type = 'P' THEN
       BEGIN
          SELECT wtax_rate
            INTO variables_var_tax_amt
            FROM GIIS_INTERMEDIARY
           WHERE p_wcominv_intrmdry_intm_no = intm_no;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            variables_var_tax_amt := 0;
      END;
     Process_Commission( p_b240_par_id,p_WCOMINV_PAR_ID,p_WCOMINV_ITEM_GRP,p_WCOMINV_intrmdry_intm_no,
                       p_WCOMINV_intrmdry_intm_no_nbt,p_WCOMINV_share_percentage, p_WCOMINV_share_percentage_nbt,
                       p_b450_takeup_seq_no,p_SYSTEM_record_status,variables_v_comm_update_tag,variables_switch_no,
                       variables_switch_name,variables_v_param_show_comm,p_GLOBAL_cancel_tag,p_wcominvper_wholding_tax,
                       p_wcominvper_commission_amt,variables_var_tax_amt,v_go_clear_block,v_remove_clrd_rw_frm_grp,
                       v_check_comm_peril,v_msg_alert1,v_upd_wcomm_inv_prls,v_pop_wcomm_inv_prls,v_del_wcomm_inv_prls,
                       v_msg_alert2,v_show_view,v_hide_view,v_set_itm_prop1,v_set_itm_prop2,v_go_item,v_compute_tot_com
                       );
   ELSIF p_B240_par_type = 'E' THEN
           BEGIN
         SELECT pol_flag
           INTO v_pol_flag
           FROM GIPI_WPOLBAS
          WHERE par_id = p_B240_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND   THEN
            v_pol_flag := 1;
      END;

      IF v_pol_flag = 4 OR  p_GLOBAL_cancel_tag = 'Y'
      THEN
         DECLARE
            v_policy     GIPI_POLBASIC.policy_id%TYPE;
            v_eff_date   GIPI_POLBASIC.eff_date%TYPE;
            v_intm       GIIS_INTERMEDIARY.intm_no%TYPE;
            v_iss        GIPI_INVOICE.iss_cd%TYPE;
            v_prem       GIPI_INVOICE.prem_seq_no%TYPE;
            v_ctr        NUMBER := 1; -- aaron 050509
            v_rate       NUMBER(12);
         BEGIN
            FOR x IN (SELECT A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy,
                             A.pol_seq_no, A.renew_no, A.pol_flag,
                             b.par_type, cancelled_endt_id
                        FROM GIPI_WPOLBAS A, GIPI_PARLIST b
                       WHERE A.par_id = p_B240_par_id AND A.par_id = b.par_id)
            LOOP
               IF x.cancelled_endt_id IS NOT NULL
               THEN
                  FOR y IN (SELECT A.policy_id, c.intrmdry_intm_no intm,
                                   A.eff_date, b.iss_cd, b.prem_seq_no
                              FROM GIPI_POLBASIC A,
                                   GIPI_INVOICE b,
                                   GIPI_COMM_INVOICE c
                             WHERE A.policy_id = b.policy_id
                               AND b.policy_id = c.policy_id
                               AND b.iss_cd = c.iss_cd
                               AND b.prem_seq_no = c.prem_seq_no
                               AND A.policy_id = x.cancelled_endt_id)
                  LOOP
                     v_policy := y.policy_id;
                     v_intm := y.intm;
                     v_eff_date := y.eff_date;
                     v_iss := y.iss_cd;
                     v_prem := y.prem_seq_no;
                  END LOOP;
               ELSE
                  FOR y IN (SELECT A.policy_id, c.intrmdry_intm_no intm,
                                   A.eff_date, b.iss_cd, b.prem_seq_no
                              FROM GIPI_POLBASIC A,
                                   GIPI_INVOICE b,
                                   GIPI_COMM_INVOICE c
                             WHERE A.policy_id = b.policy_id
                               AND b.policy_id = c.policy_id
                               AND b.iss_cd = c.iss_cd
                               AND b.prem_seq_no = c.prem_seq_no
                               AND (    A.line_cd = x.line_cd
                                    AND A.subline_cd = x.subline_cd
                                    AND A.iss_cd = x.iss_cd
                                    AND A.issue_yy = x.issue_yy
                                    AND A.pol_seq_no = x.pol_seq_no
                                    AND A.renew_no = x.renew_no
                                   ))
                  LOOP
                          v_policy := y.policy_id;
                         v_intm := y.intm;
                         v_eff_date := y.eff_date;
                         v_iss := y.iss_cd;
                         v_prem := y.prem_seq_no;

                  END LOOP;
              END IF;

               FOR l IN (SELECT DISTINCT (ROUND (wholding_tax / DECODE(commission_amt,0,1,commission_amt), 2)--aaron 050709  /* mark jm 08.27.09 */
                                 * 100
                                ) wtax
                           FROM GIPI_COMM_INV_PERIL
                          WHERE policy_id = v_policy
                            AND iss_cd = v_iss
                            AND prem_seq_no = v_prem
                       ORDER BY 1 DESC) /* mark jm 08.27.09 */
               LOOP
                  variables_var_tax_amt := l.wtax;
                  EXIT;
               END LOOP;

            END LOOP;
         END;
        Process_Commission( p_b240_par_id,p_WCOMINV_PAR_ID,p_WCOMINV_ITEM_GRP,p_WCOMINV_intrmdry_intm_no,
                       p_WCOMINV_intrmdry_intm_no_nbt,p_WCOMINV_share_percentage, p_WCOMINV_share_percentage_nbt,
                       p_b450_takeup_seq_no,p_SYSTEM_record_status,variables_v_comm_update_tag,variables_switch_no,
                       variables_switch_name,variables_v_param_show_comm,p_GLOBAL_cancel_tag,p_wcominvper_wholding_tax,
                       p_wcominvper_commission_amt,variables_var_tax_amt,v_go_clear_block,v_remove_clrd_rw_frm_grp,
                       v_check_comm_peril,v_msg_alert1,v_upd_wcomm_inv_prls,v_pop_wcomm_inv_prls,v_del_wcomm_inv_prls,
                       v_msg_alert2,v_show_view,v_hide_view,v_set_itm_prop1,v_set_itm_prop2,v_go_item,v_compute_tot_com
                       );
      /*PAU 03FEB09*/
      /*FOR SELECTION OF WITH HOLDING TAX RATE DEPENDENT ON TAX AMT AND COMMISSION AMOUNT OF POLICY (INCLD ENDT)*/
      ELSIF V_POL_FLAG <> 4 AND p_B240_par_type = 'E' AND V_ANN_TSI_AMT = 0 AND NVL(V_ENDT_TYPE, 'Y') <> 'N' THEN

                DECLARE
                   RG_NAME         VARCHAR2 (40)                             := 'WT_RATE';
--marion           RG_ID           RECORDGROUP;
                   --GC_ID           GROUPCOLUMN;
                   RG_COL1                 VARCHAR2(40)                                                             := RG_NAME || '.REC';
                   RG_COL3                 VARCHAR2(50)                                                             := RG_NAME || '.POL';
                   RG_COL2                 VARCHAR2(40)                                                             := RG_NAME || '.WTR';
                   ERRCODE         NUMBER;
                   V_CTR           NUMBER                                    := 1;
                   V_INTM          GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
                   V_ISS_CD        GIPI_INVOICE.ISS_CD%TYPE;
                   V_PREM_SEQ_NO   GIPI_INVOICE.PREM_SEQ_NO%TYPE;
                   --V_POLICY_ID     GIPI_POLBASIC.POLICY_ID%TYPE;
                   --V_PERIL_CD      GIPI_INVPERIL.PERIL_CD%TYPE;
                    /*added by VJ 020509*/
                    v_alert_btn       NUMBER;
--marion            v_alert_id        alert;
--marion                    v_alert_msg       VARCHAR2(500);
                    /*end VJ */
                     v_rate          NUMBER(12); -- aaron
                BEGIN
                v_rg_id := 'Y';
/*
                   RG_ID := FIND_GROUP (RG_NAME);

                   DECLARE
                        V_TEMP NUMBER;
                   BEGIN
                        V_TEMP := GET_GROUP_ROW_COUNT(RG_ID);
                        IF V_TEMP > 0 THEN
                             WHILE V_TEMP <> 0 LOOP
                                  DELETE_GROUP_ROW(RG_ID, V_TEMP);
                                  V_TEMP := V_TEMP - 1;
                             END LOOP;
                        END IF;
                   END;
*/
                   FOR X IN (SELECT A.LINE_CD, A.SUBLINE_CD, A.ISS_CD, A.ISSUE_YY,
                                    A.POL_SEQ_NO, A.RENEW_NO, A.POL_FLAG, B.PAR_TYPE,
                                    CANCELLED_ENDT_ID
                               FROM GIPI_WPOLBAS A, GIPI_PARLIST B
                              WHERE A.PAR_ID = p_B240_PAR_ID AND A.PAR_ID = B.PAR_ID)
                   LOOP
                      FOR Y IN (SELECT A.POLICY_ID, C.INTRMDRY_INTM_NO INTM,
                                       B.ISS_CD, B.PREM_SEQ_NO
                                  FROM GIPI_POLBASIC A,
                                       GIPI_INVOICE B,
                                       GIPI_COMM_INVOICE C
                                 WHERE A.POLICY_ID = B.POLICY_ID
                                   AND B.POLICY_ID = C.POLICY_ID
                                   AND B.ISS_CD = C.ISS_CD
                                   AND B.PREM_SEQ_NO = C.PREM_SEQ_NO
                                   AND (    A.LINE_CD = X.LINE_CD
                                        AND A.SUBLINE_CD = X.SUBLINE_CD
                                        AND A.ISS_CD = X.ISS_CD
                                        AND A.ISSUE_YY = X.ISSUE_YY
                                        AND A.POL_SEQ_NO = X.POL_SEQ_NO
                                        AND A.RENEW_NO = X.RENEW_NO
                                       )ORDER BY A.policy_id)
                      LOOP
                          V_INTM := Y.INTM;
                         V_ISS_CD := Y.ISS_CD;
                         V_PREM_SEQ_NO := Y.PREM_SEQ_NO;


                         --V_POLICY_ID := Y.POLICY_ID;
                         --V_PERIL_CD := Y.PERIL_CD;
                       FOR l IN (SELECT DISTINCT(ROUND(WHOLDING_TAX / DECODE(COMMISSION_AMT, 0, 1, COMMISSION_AMT) * 100)) wtax, policy_id
                           FROM GIPI_COMM_INV_PERIL
                          WHERE policy_id = Y.policy_ID
                            AND iss_cd = v_iss_CD
                            AND prem_seq_no = v_prem_SEQ_NO)
               LOOP
                  IF v_rate != l.wtax THEN
                      v_ctr := v_ctr + 1;
                  END IF;
                  v_rate := l.wtax;
                  variables_var_tax_amt := l.wtax;
                  EXIT;
               END LOOP;

                     v_add_group_row := 'Y';
/*                                  ADD_GROUP_ROW(RG_ID, END_OF_GROUP);
                                  SET_GROUP_NUMBER_CELL(RG_COL1, V_CTR, V_CTR);
                                  sET_GROUP_NUMBER_CELL(RG_COL2, V_CTR, variables_VAR_TAX_AMT);
                                  SET_GROUP_CHAR_CELL(RG_COL3, V_CTR, Get_Policy_No(Y.POLICY_ID));
*/                              --    V_CTR := V_CTR + 1; -- comment out by aaron 050509
                      END LOOP;
                   END LOOP;
                   IF V_CTR > 1 THEN -- modified by aaron 050509
                        IF NVL(variables_v_override_whtax,'N')='Y' THEN
                            v_ov := 'Y';
                -------------------------------------
/*
                         IF Giac_Validate_User_Fn(USER,'OV',GET_APPLICATION_PROPERTY(CURRENT_FORM_NAME)) = 'TRUE' THEN
                               show_tax_rates;
                          ELSE
                                 v_alert_msg := 'There were changes made to the withholding tax rate, please choose which rate will be used.'||
                                              'Would you like to override?';
                                  v_alert_id := FIND_ALERT('CHECK_COMM_WHTAX');
                                  SET_ALERT_PROPERTY(v_alert_id,ALERT_MESSAGE_TEXT,v_alert_msg);
                                   v_alert_btn := SHOW_ALERT(v_alert_id);

                                   IF v_alert_btn = ALERT_BUTTON1 THEN
                                      variables_v_process := TRUE;
                                      go_item('CG$CTRL.user_name');
                                     animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'CG$CTRL','show');
                               END IF;
                            END IF;
*/
                        END IF;
                          Process_Commission( p_b240_par_id,p_WCOMINV_PAR_ID,p_WCOMINV_ITEM_GRP,p_WCOMINV_intrmdry_intm_no,
                       p_WCOMINV_intrmdry_intm_no_nbt,p_WCOMINV_share_percentage, p_WCOMINV_share_percentage_nbt,
                       p_b450_takeup_seq_no,p_SYSTEM_record_status,variables_v_comm_update_tag,variables_switch_no,
                       variables_switch_name,variables_v_param_show_comm,p_GLOBAL_cancel_tag,p_wcominvper_wholding_tax,
                       p_wcominvper_commission_amt,variables_var_tax_amt,v_go_clear_block,v_remove_clrd_rw_frm_grp,
                       v_check_comm_peril,v_msg_alert1,v_upd_wcomm_inv_prls,v_pop_wcomm_inv_prls,v_del_wcomm_inv_prls,
                       v_msg_alert2,v_show_view,v_hide_view,v_set_itm_prop1,v_set_itm_prop2,v_go_item,v_compute_tot_com
                       ); -- rose 01052009 flt for applied button to populate the perils in the lower block
                       ELSE
                         Process_Commission( p_b240_par_id,p_WCOMINV_PAR_ID,p_WCOMINV_ITEM_GRP,p_WCOMINV_intrmdry_intm_no,
                       p_WCOMINV_intrmdry_intm_no_nbt,p_WCOMINV_share_percentage, p_WCOMINV_share_percentage_nbt,
                       p_b450_takeup_seq_no,p_SYSTEM_record_status,variables_v_comm_update_tag,variables_switch_no,
                       variables_switch_name,variables_v_param_show_comm,p_GLOBAL_cancel_tag,p_wcominvper_wholding_tax,
                       p_wcominvper_commission_amt,variables_var_tax_amt,v_go_clear_block,v_remove_clrd_rw_frm_grp,
                       v_check_comm_peril,v_msg_alert1,v_upd_wcomm_inv_prls,v_pop_wcomm_inv_prls,v_del_wcomm_inv_prls,
                       v_msg_alert2,v_show_view,v_hide_view,v_set_itm_prop1,v_set_itm_prop2,v_go_item,v_compute_tot_com
                       );
                      END IF;
                END;
            ELSE
         BEGIN
            SELECT wtax_rate
              INTO variables_var_tax_amt
              FROM GIIS_INTERMEDIARY
             WHERE p_wcominv_intrmdry_intm_no = intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               variables_var_tax_amt := 0;
         END;
          Process_Commission( p_b240_par_id,p_WCOMINV_PAR_ID,p_WCOMINV_ITEM_GRP,p_WCOMINV_intrmdry_intm_no,
                       p_WCOMINV_intrmdry_intm_no_nbt,p_WCOMINV_share_percentage, p_WCOMINV_share_percentage_nbt,
                       p_b450_takeup_seq_no,p_SYSTEM_record_status,variables_v_comm_update_tag,variables_switch_no,
                       variables_switch_name,variables_v_param_show_comm,p_GLOBAL_cancel_tag,p_wcominvper_wholding_tax,
                       p_wcominvper_commission_amt,variables_var_tax_amt,v_go_clear_block,v_remove_clrd_rw_frm_grp,
                       v_check_comm_peril,v_msg_alert1,v_upd_wcomm_inv_prls,v_pop_wcomm_inv_prls,v_del_wcomm_inv_prls,
                       v_msg_alert2,v_show_view,v_hide_view,v_set_itm_prop1,v_set_itm_prop2,v_go_item,v_compute_tot_com
                       );
      END IF;
   END IF;
END Get_Default_Tax_Rt;

--process commission

PROCEDURE Process_Commission
  ( p_b240_par_id                             IN GIPI_PARLIST.par_id%TYPE,
       p_WCOMINV_PAR_ID                        IN GIPI_WCOMM_INVOICES.par_id%TYPE,
    p_WCOMINV_ITEM_GRP                        IN GIPI_WCOMM_INVOICES.item_grp%TYPE,
    p_WCOMINV_intrmdry_intm_no                IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
    p_WCOMINV_intrmdry_intm_no_nbt            IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
    p_WCOMINV_share_percentage                IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
    p_WCOMINV_share_percentage_nbt            IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
    p_b450_takeup_seq_no                    IN GIPI_WINVOICE.takeup_seq_no%TYPE,
    p_SYSTEM_record_status                    IN VARCHAR2,
    variables_v_comm_update_tag               OUT GIIS_USERS.comm_update_tag%TYPE,
    variables_switch_no                    OUT VARCHAR2,
    variables_switch_name                   OUT VARCHAR2,
    variables_v_param_show_comm               OUT GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
    p_GLOBAL_cancel_tag                        IN VARCHAR2,
    p_wcominvper_wholding_tax               OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
    p_wcominvper_commission_amt                IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
    variables_var_tax_amt                    IN GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
    v_go_clear_block                       OUT VARCHAR2,
    v_remove_clrd_rw_frm_grp                OUT VARCHAR2,
    v_check_comm_peril                       OUT VARCHAR2,
    v_msg_alert1                           OUT VARCHAR2,
    v_upd_wcomm_inv_prls                   OUT VARCHAR2,
    v_pop_wcomm_inv_prls                   OUT VARCHAR2,
    v_del_wcomm_inv_prls                   OUT VARCHAR2,
    v_msg_alert2                           OUT VARCHAR2,
    v_show_view                               OUT VARCHAR2,
    v_hide_view                               OUT VARCHAR2,
    v_set_itm_prop1                           OUT NUMBER,
    v_set_itm_prop2                           OUT NUMBER,
    v_go_item                               OUT VARCHAR2,
    v_compute_tot_com                       OUT VARCHAR2

  )IS
   v_pol_flag GIPI_WPOLBAS.pol_flag%TYPE;
BEGIN

  BEGIN
      SELECT pol_flag
        INTO v_pol_flag
        FROM GIPI_WPOLBAS
       WHERE par_id = p_b240_par_id;
    END;
       v_go_clear_block := 'Y';
  --   go_block('WCOMINVPER');
  --   clear_block(NO_COMMIT);
     DELETE GIPI_WCOMM_INV_PERILS
      WHERE par_id = p_WCOMINV_PAR_ID
        AND item_grp = p_WCOMINV_ITEM_GRP
        AND intrmdry_intm_no = p_WCOMINV_intrmdry_intm_no
        AND takeup_seq_no = p_b450_takeup_seq_no ;  -- aaron 050509

     v_remove_clrd_rw_frm_grp := 'Y';
--     REMOVE_CLEARED_ROW_FROM_GROUP;


   IF Giacp.v ('CHECK_COMM_PERIL') = 'Y' THEN

     v_check_comm_peril := 'Y';
/*
     check_peril_comm_rate;

      IF variables.missing_perils IS NOT NULL THEN
         msg_alert (
               'Please check intermediary commission rates for the following perils: '
            || variables.missing_perils
            || '.',
            'E',
            TRUE);
      END IF;
 */
  END IF;
   --END
       IF  p_WCOMINV_intrmdry_intm_no IS NULL
       AND p_WCOMINV_share_percentage IS NOT NULL THEN
      v_msg_alert1 := 'Y';

/*
      msg_alert ('Intermediary No. is required.', 'I', FALSE);
      go_item ('wcominv.intrmdry_intm_no');
      set_item_property ('wcominv.apply_button', enabled, property_false);
*/
   END IF;

   IF  p_SYSTEM_record_status = 'CHANGED' THEN
      IF NVL (p_WCOMINV_share_percentage, 0) <>
                                       NVL (p_WCOMINV_share_percentage_nbt, 0) THEN
        v_upd_wcomm_inv_prls := 'Y';
/*
         go_block ('wcominvper');
         update_wcomm_inv_perils;
         go_item ('wcominv.dsp_intm_name');
*/
      END IF;
   END IF;

   IF p_SYSTEM_record_status IN ('NEW', 'INSERT') THEN
      IF p_WCOMINV_intrmdry_intm_no IS NOT NULL THEN
         v_pop_wcomm_inv_prls := 'Y';

/*
         go_block ('wcominvper');
         clear_block (no_commit);
         populate_wcomm_inv_perils;
         go_item ('wcominv.share_percentage');
*/
         variables_switch_no := 'N';
         variables_switch_name := 'N';
      END IF;
   ELSIF p_SYSTEM_record_status = 'CHANGED' THEN
      IF NVL (p_WCOMINV_intrmdry_intm_no, 0) <> NVL (p_WCOMINV_intrmdry_intm_no_nbt, 0) THEN
           v_del_wcomm_inv_prls := 'Y';
/*
         go_block ('wcominvper');
         clear_block (no_commit);
         populate_wcomm_inv_perils;
         delete_wcomm_inv_perils;
         go_item ('wcominv.share_percentage');
*/
         variables_switch_no := 'N';
         variables_switch_name := 'N';
      END IF;
  END IF;

  BEGIN
      SELECT param_value_v
        INTO variables_v_param_show_comm
        FROM GIAC_PARAMETERS
       WHERE param_name = 'SHOW_COMM_AMT';
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
    v_msg_alert2 := 'Y';
--           msg_alert('No data found on giac_parameters for parameter ''SHOW_COMM_AMT''','I',TRUE);
  END;

  BEGIN
      SELECT comm_update_tag
        INTO variables_v_comm_update_tag
        FROM GIIS_USERS
       WHERE user_id = USER;--:cg$ctrl.cg$us;
  END;

  IF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag = 'N' THEN
        v_show_view := 'Y';
--      show_view ('CANVAS328');
   ELSIF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag ='Y' THEN
         v_hide_view := 'Y';
--      hide_view ('CANVAS328');
   END IF;


     -- go_item ('WCOMINV.SHARE_PERCENTAGE');--added by dannel 07/11/2006
   IF  variables_v_param_show_comm = 'Y' AND variables_v_comm_update_tag = 'N' THEN
       v_set_itm_prop1 := 1;
/*
       set_item_property ('WCOMINVPER.COMMISSION_RT', enabled, property_false);
       set_item_property ('WCOMINVPER.COMMISSION_AMT', enabled, property_false);
*/
   ELSIF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag = 'N' THEN
       v_set_itm_prop1 := 2;
/*
       show_view ('CANVAS328');
       set_item_property (
         'WCOMINVPER.COMMISSION_RT',
         navigable,
         property_false);
*/
   ELSE
       v_set_itm_prop1 := 3;
/*
      hide_view ('CANVAS328');
      go_item ('WCOMINV.SHARE_PERCENTAGE');--added by dannel 07/11/2006
*/      --set_item_property ('WCOMINVPER.COMMISSION_RT', enabled, property_true);
      -- mark jm 12.05.08 starts here
      IF v_pol_flag = 4 OR  p_GLOBAL_cancel_tag = 'Y' THEN
         v_set_itm_prop2 := 1;
/*
              SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_AMT', ENABLED, PROPERTY_FALSE);
              SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_RT', ENABLED, PROPERTY_FALSE);
      -- mark jm 12.05.08 ends here
*/
      ELSE
         v_set_itm_prop2 := 2;
/*
          set_item_property ('WCOMINVPER.COMMISSION_AMT', ENABLED, PROPERTY_TRUE);
          SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_RT', ENABLED, PROPERTY_TRUE);
*/
      END IF;
        v_go_item := 'Y';
--      go_item ('WCOMINVPER.COMMISSION_RT');

   END IF;


    p_wcominvper_wholding_tax :=   ROUND (NVL(p_wcominvper_commission_amt, 0),2)
                                 * NVL (variables_var_tax_amt, 0) / 100;
    v_compute_tot_com := 'Y';
--    compute_tot_com;
END Process_Commission;

FUNCTION Validate_Pack_Bancassurance (
   p_pack_par_id   GIPI_PARLIST.pack_par_id%TYPE
)
   RETURN VARCHAR2
IS
   v_bancassurance   VARCHAR2(1) := NULL;

   BEGIN
    SELECT bancassurance_sw BANC_SW
      INTO v_bancassurance
      FROM GIPI_WPOLBAS
     WHERE par_id IN (SELECT DISTINCT par_id
                              FROM gipi_parlist b240
                      WHERE b240.pack_par_id = p_pack_par_id)
       AND ROWNUM = 1;
  IF v_bancassurance IS NULL OR v_bancassurance <> 'Y' THEN
     v_bancassurance := 'N';
  END IF;
  RETURN (v_bancassurance);
END Validate_Pack_Bancassurance;

END Bancassurance;
/



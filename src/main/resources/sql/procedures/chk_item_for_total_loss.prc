DROP PROCEDURE CPI.CHK_ITEM_FOR_TOTAL_LOSS;

CREATE OR REPLACE PROCEDURE CPI.chk_item_for_total_loss(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,  
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_item_no           GICL_CLM_ITEM.item_no%TYPE,
    p_msg_alert     OUT VARCHAR2
    ) IS
  tl_flag       VARCHAR2(1);
BEGIN 
  --get selected item(s) after user selects LOV of items of the policy--
    FOR tl IN (SELECT 'x' x
                 FROM gicl_claims b,
                      gicl_clm_item a
                WHERE b.line_cd     = p_line_cd
                  AND b.subline_cd  = p_subline_cd
                  AND b.pol_iss_cd  = p_pol_iss_cd     
                  AND b.issue_yy    = p_issue_yy   
                  AND b.pol_seq_no  = p_pol_seq_no
                  AND b.renew_no    = p_renew_no
                  AND b.total_tag   = 'YK'
                  AND a.claim_id    = b.claim_id
                  AND a.item_no     = p_item_no
                  AND b.clm_stat_cd NOT IN ('DN','WD','CC'))
    LOOP
      tl_flag := tl.x;
    END LOOP;
    IF tl_flag = 'x' THEN
      p_msg_alert := 'Cannot create claim for this item. This item has been tagged as total loss.';--,'E',TRUE);
    END IF;
END;
/



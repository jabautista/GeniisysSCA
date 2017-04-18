DROP PROCEDURE CPI.CHECK_TOTAL_LOSS;

CREATE OR REPLACE PROCEDURE CPI.check_total_loss(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,  
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_msg_alert     OUT VARCHAR2 
    )IS
  ctr1                 NUMBER := 0;
  ctr2                 NUMBER := 0;
  v_ann_tsi_amt gipi_item.ann_tsi_amt%TYPE;
  tl_flag       VARCHAR2(1);
BEGIN
  --get the item(s) of the policy--
    FOR i IN (SELECT distinct a.item_no item_no
                FROM gipi_item a, gipi_polbasic b
               WHERE a.policy_id = b.policy_id
                 AND b.line_cd     = p_line_cd
                 AND b.subline_cd  = p_subline_cd
                 AND b.iss_cd      = p_pol_iss_cd     
                 AND b.issue_yy    = p_issue_yy   
                 AND b.pol_seq_no  = p_pol_seq_no
                 AND b.renew_no    = p_renew_no
                 AND b.pol_flag IN ('1','2','3','4'))
    LOOP
        ctr1:= ctr1+1;
        FOR tl IN (SELECT 'x' x
                     FROM gicl_claims b,
                          gicl_clm_item a
                    WHERE b.line_cd     = p_line_cd
                      AND b.subline_cd  = p_subline_cd
                      AND b.pol_iss_cd  = p_pol_iss_cd     
                      AND b.issue_yy    = p_issue_yy   
                      AND b.pol_seq_no  = p_pol_seq_no
                      AND b.renew_no    = p_renew_no
                      AND b.total_tag   = 'Y'
                      AND a.claim_id    = b.claim_id
                      AND a.item_no     = i.item_no
                      AND b.clm_stat_cd NOT IN ('DN','WD','CC'))
        LOOP
          tl_flag := tl.x;
        END LOOP;
        IF tl_flag = 'x' THEN
          ctr2 := ctr2+1; --no of items tagged as total loss
          tl_flag := null;
        END IF;
    END LOOP;
    IF ctr1 = ctr2 AND ctr1 <> 0 AND ctr2 <> 0 THEN
        p_msg_alert := 'Cannot create claim, all items for this policy had been tagged as total loss.';
        --do_key('DELETE_RECORD');
    END IF;
END;
/



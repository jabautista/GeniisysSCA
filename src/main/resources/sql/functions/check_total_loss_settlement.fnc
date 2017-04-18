DROP FUNCTION CPI.CHECK_TOTAL_LOSS_SETTLEMENT;

CREATE OR REPLACE FUNCTION CPI.Check_Total_Loss_Settlement
( 
/*MODIFIED BY pau 06AUG07 
**INCLUDED PERIL LEVEL CHECKING 
*/          
 p_grouped_item_no GICL_CLM_ITEM.GROUPED_ITEM_NO%TYPE, -- Added by marlo 07082010 
 p_peril_cd   GIPI_ITMPERIL.peril_cd%TYPE, --pau 06AUG07 
 p_item_no           GIPI_ITEM.item_no%TYPE,      --determines if the mortgagee is item or policy level  
  p_line_cd           GIPI_POLBASIC.line_cd%TYPE,  --to get the policy_id 
 p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
 p_loss_date        GICL_CLAIMS.loss_date%TYPE,
 p_eff_d8_frm_clm    GIPI_POLBASIC.incept_date%TYPE,
 p_expry_d8_frm_clm  GIPI_POLBASIC.expiry_date%TYPE ) RETURN BOOLEAN IS

/*created by emcyDA071907TE
**return FALSE if claim already has accumulated total loss
**and TRUE if not
*/          

/* MJ Fabroa 03/08/2013
** Function is temporarily disable by always returning TRUE.
*/

  v_total_loss    VARCHAR2 (1)                   := 'N';-- Added by Marlo 09212011
  v_paid_amount   gicl_claims.loss_pd_amt%TYPE   := 0; -- Added by Marlo 09212011
  
  CURSOR tsi_non_agg IS
   SELECT C.item_no, C.peril_cd, SUM(C.tsi_amt) tsi_amt--, b.policy_id--a.item_no, sum(a.tsi_amt) tsi_amt--, a.policy_id, c.aggregate_Sw, c.peril_cd, a.item_no 
     FROM GIPI_ITEM A, GIPI_POLBASIC b,
       GIPI_ITMPERIL C, GIIS_PERIL D --pau 06AUG07
     WHERE 1=1 
       AND EXISTS (SELECT 1 
                     FROM GIPI_ITMPERIL
             WHERE policy_id = A.policy_id
               AND item_no = A.item_no
          AND peril_cd = NVL(p_peril_cd, peril_cd) --pau 06AUG07 
             AND NVL(aggregate_sw,'N') <> 'Y') 
   --pau 06AUG07 start 
   AND b.line_cd = d.line_cd
   AND C.peril_cd = NVL(p_peril_cd, C.peril_cd)
   AND C.peril_cd = d.peril_cd
   AND A.item_no = C.item_no
   AND A.policy_id = C.policy_id   
    --pau 06AUG07 end 
        AND A.policy_id = b.policy_id 
      AND A.item_no = NVL(p_item_no,A.item_no)  
      AND b.line_cd    = p_line_cd 
      AND b.subline_cd = p_subline_cd 
      AND b.iss_cd     = p_iss_cd 
      AND b.issue_yy   = p_issue_yy 
      AND b.pol_seq_no = p_pol_seq_no 
      AND b.renew_no   = p_renew_no 
      AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_eff_d8_frm_clm,eff_date)) <= TRUNC(p_loss_date) 
      AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expry_d8_frm_clm,endt_expiry_date)) >= TRUNC(p_loss_date)
  GROUP BY C.item_No, C.peril_cd;

  CURSOR tsi_agg IS
   SELECT C.item_no, 
          C.peril_cd,SUM(C.tsi_amt) tsi_amt 
     FROM GIPI_ITEM A, GIPI_POLBASIC b, GIPI_ITMPERIL C,  GIIS_PERIL d 
    WHERE 1=1 
       AND d.peril_type = 'B' 
      AND b.line_cd = d.line_cd 
   AND C.peril_cd = NVL(p_peril_cd, C.peril_cd) --pau 06AUG07 
      AND C.peril_cd = d.peril_cd 
      AND C.aggregate_sw = 'Y'
      AND A.item_no = C.item_no 
      AND A.policy_id = C.policy_id 
      AND A.policy_id = b.policy_id 
      AND A.item_no = NVL(p_item_no,A.item_no) 
      AND b.renew_no   = p_renew_no 
      AND b.pol_seq_no = p_pol_seq_no 
      AND b.issue_yy   = p_issue_yy 
      AND b.iss_cd     = p_iss_cd 
      AND b.subline_cd = p_subline_cd 
      AND b.line_cd    = p_line_cd 
      AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_eff_d8_frm_clm,eff_date)) <= TRUNC(p_loss_date) 
      AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expry_d8_frm_clm,endt_expiry_date)) >= TRUNC(p_loss_date) 
    GROUP BY C.item_no, C.peril_cd;

  CURSOR amt_settled_for_agg(p_peril GICL_CLM_LOSS_EXP.peril_cd%TYPE,
                             p_item GICL_CLM_LOSS_EXP.item_no%TYPE) IS
   SELECT SUM(A.losses_paid) paid_amt
     FROM GICL_CLAIMS b, GICL_CLM_RES_HIST A
    WHERE 1=1
       AND A.claim_id = b.claim_id
      AND A.tran_id IS NOT NULL
      AND NVL(A.cancel_tag,'N') <> 'Y'
      AND b.line_cd = p_line_cd
      AND b.subline_cd = p_subline_cd
      AND b.iss_cd = p_iss_cd
      AND b.issue_yy = p_issue_yy
      AND b.pol_seq_no = p_pol_Seq_no
      AND b.renew_no = p_renew_no
      AND A.item_no = p_item
      AND nvl(A.GROUPED_ITEM_NO, 0) = p_grouped_item_no -- added by marlo 07082010
      AND A.peril_cd = NVL(p_peril, A.PERIL_CD);

  CURSOR amt_settled(p_peril GICL_CLM_LOSS_EXP.peril_cd%TYPE, --pau 06AUG07 ADDED PERIL_CD PARAMETER 
        p_item GICL_CLM_LOSS_EXP.item_no%TYPE) IS
   SELECT SUM(A.losses_paid) paid_amt
     FROM GICL_CLAIMS b, GICL_CLM_RES_HIST A
    WHERE 1=1
       AND A.claim_id = b.claim_id
      AND A.tran_id IS NOT NULL
      AND NVL(A.cancel_tag,'N') <> 'Y'    
      AND b.line_cd = p_line_cd
      AND b.subline_cd = p_subline_cd
      AND b.iss_cd = p_iss_cd
      AND b.issue_yy = p_issue_yy
      AND b.pol_seq_no = p_pol_Seq_no
      AND b.renew_no = p_renew_no
      AND A.item_no = p_item
      AND nvl(A.GROUPED_ITEM_NO, 0) = p_grouped_item_no -- added by marlo 07082010
   AND A.peril_cd = NVL(p_peril,A.PERIL_CD)
     GROUP BY A.claim_id; 
    
BEGIN   

   RETURN (TRUE); -- added by MJ Fabroa 03/08/2013

  /* Added by Marlo
   ** 01212011
   ** To check if the validation is claim-level or item level.
   ** For item-level validation, return true if at least one peril is already total loss.
   ** and for claim level validation, only return true if all item-peril is total loss.*/
   IF p_item_no IS NULL THEN
      --checks w/o aggreagate peril
      FOR i IN tsi_non_agg LOOP
         DBMS_OUTPUT.put_line ('tsi_non_arg');
         v_paid_amount := 0; 
         FOR j IN amt_settled (i.peril_cd, i.item_no) LOOP
            DBMS_OUTPUT.put_line (j.paid_amt || ' >= ' || i.tsi_amt);
            v_paid_amount := j.paid_amt;
         END LOOP;

         IF v_paid_amount >= i.tsi_amt THEN
            v_total_loss := 'Y';
         ELSE
            v_total_loss := 'N';
            EXIT;
         END IF;
      END LOOP;

      --checks policy w/ aggregate peril
      FOR i IN tsi_agg LOOP
         DBMS_OUTPUT.put_line ('tsi_arg');
         v_paid_amount := 0;  
         FOR j IN amt_settled_for_agg (i.peril_cd, i.item_no) LOOP
            DBMS_OUTPUT.put_line (j.paid_amt || ' >= ' || i.tsi_amt);
            v_paid_amount := j.paid_amt;
         END LOOP;

         IF v_paid_amount >= i.tsi_amt THEN
            v_total_loss := 'Y';
         ELSE
            v_total_loss := 'N';
            EXIT;
         END IF;
      END LOOP;

      IF v_total_loss = 'Y'
      THEN
         RETURN (FALSE);
      ELSE
         RETURN (TRUE);
      END IF;
   ELSE
   
      --checks w/o aggreagate peril
      DBMS_OUTPUT.PUT_LINE('tsi_non_arg');
      FOR i IN tsi_non_agg LOOP
          FOR j IN amt_settled(i.peril_cd, i.item_no) LOOP
              DBMS_OUTPUT.PUT_LINE(j.paid_amt ||' >= '|| i.tsi_amt);
              IF j.paid_amt >= i.tsi_amt THEN
                 DBMS_OUTPUT.PUT_LINE('total loss baby!');
                 RETURN (FALSE);
              END IF;
          END LOOP;
      END LOOP;   
  
      --checks policy w/ aggregate peril
      FOR i IN tsi_agg LOOP
          DBMS_OUTPUT.PUT_LINE('tsi_arg');
          FOR j IN amt_settled_for_agg(i.peril_cd, i.item_no) LOOP
              DBMS_OUTPUT.PUT_LINE(j.paid_amt ||' >= '|| i.tsi_amt);
              IF j.paid_amt >= i.tsi_amt THEN
                 DBMS_OUTPUT.PUT_LINE('total loss baby!');
                 RETURN(FALSE);
              END IF;
          END LOOP;
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('--O--K--');  
      RETURN(TRUE);
      -- end of original code as of 01212011  
   END IF;

END;
/



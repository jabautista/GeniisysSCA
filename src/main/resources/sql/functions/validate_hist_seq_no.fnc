DROP FUNCTION CPI.VALIDATE_HIST_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_HIST_SEQ_NO
            (p_claim_id  IN  GICL_CLAIMS.claim_id%TYPE,
             p_item_no   IN  GICL_ITEM_PERIL.item_no%TYPE,
             p_peril_cd  IN  GICL_ITEM_PERIL.peril_cd%TYPE)

RETURN VARCHAR2 AS

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.13.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Check for unprinted PLAs per item-peril and check for 
   **                  unprinted PLAs if PLAs have already been generated
   */ 

  v_ungen_sw     VARCHAR2(1) := 'N';
  v_unprint_sw   VARCHAR2(1) := 'N';
  v_msg_alert    VARCHAR2(500);

BEGIN
    
  FOR gen IN
      (SELECT MAX(hist_seq_no) hist_seq_no
         FROM GICL_RESERVE_DS
      WHERE claim_id   = p_claim_id
        AND item_no    = p_item_no
        AND peril_cd   = p_peril_cd)
  LOOP
    FOR ungen IN
      (SELECT 'Y'
       FROM GICL_RESERVE_RIDS
      WHERE claim_id    = p_claim_id
        AND item_no     = p_item_no
        AND peril_cd    = p_peril_cd
        AND res_pla_id  IS NULL
        AND hist_seq_no = gen.hist_seq_no)
    LOOP
        v_ungen_sw := 'Y';
        EXIT;
    END LOOP;
  END LOOP;

  IF v_ungen_sw = 'N' THEN
     FOR seq IN
       (SELECT MAX(hist_seq_no) sno
          FROM GICL_CLM_RES_HIST
         WHERE claim_id = p_claim_id
           AND item_no  = p_item_no
           AND peril_cd = p_peril_cd)
     LOOP
         FOR hist IN
         (SELECT clm_res_hist_id res_id
            FROM GICL_CLM_RES_HIST
           WHERE claim_id    = p_claim_id
             AND item_no     = p_item_no
             AND peril_cd    = p_peril_cd
             AND hist_seq_no = seq.sno)
       LOOP
         FOR res IN
           (SELECT pla_id
              FROM GICL_RESERVE_RIDS
             WHERE claim_id        = p_claim_id
               AND clm_res_hist_id = hist.res_id
               AND item_no         = p_item_no
               AND peril_cd        = p_peril_cd)
         LOOP
           FOR pla IN
             (SELECT print_sw
                FROM GICL_ADVS_PLA
               WHERE claim_id           = p_claim_id
                 AND pla_id             = res.pla_id
                 AND NVL(print_sw, 'N') = 'N')
           LOOP
             v_unprint_sw := 'Y';
             EXIT;
           END LOOP;
         END LOOP;
       END LOOP;
     END LOOP;
  END IF;
  

  IF v_ungen_sw = 'Y' AND v_unprint_sw = 'Y' THEN
       v_msg_alert := 'There are PLAs that have not been generated and printed for '||
                      'this claim. It is necessary to generate and print all PLAs before '||
                      'creating a settlement history. Generate and print PLAs now?';
                      
  ELSIF v_ungen_sw = 'N' AND v_unprint_sw = 'Y' THEN
       v_msg_alert := 'There are PLAs that have not been printed for this claim. '||
                      'It is necessary to print all PLAs before '||
                      'creating a settlement history. Print PLAs now?';
                      
  ELSIF v_ungen_sw = 'Y' AND v_unprint_sw = 'N' THEN
       v_msg_alert := 'There are PLAs that have not been generated for this claim. '||
                      'It is necessary to generate all PLAs and have it printed before '||
                      'creating a settlement history. Generate and print PLAs now?';
  ELSE
       v_msg_alert := NULL;
  END IF;
  
  RETURN v_msg_alert;

END;
/



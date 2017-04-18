DROP PROCEDURE CPI.PACK_ENDT_GET_AMOUNTS;

CREATE OR REPLACE PROCEDURE CPI.PACK_ENDT_GET_AMOUNTS (
    p_par_id        IN  GIPI_WPOLBAS.par_id%TYPE, -- this corresponds to the par_id of the sub-PAR of the the endt Package PAR
    p_pack_line_cd  IN  GIPI_WPOLBAS.line_cd%TYPE,-- line_cd of the sub-PAR of the the endt Package PAR
    p_line_cd       IN  GIPI_PACK_WPOLBAS.line_cd%TYPE, -- While the succeeding parameters must be from the endt Package not the par
    p_subline_cd    IN  GIPI_PACK_WPOLBAS.subline_cd%TYPE, -- Nica 11.15.2011
    p_iss_cd        IN  GIPI_PACK_WPOLBAS.iss_cd%TYPE,
    p_issue_yy      IN  GIPI_PACK_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no    IN  GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no      IN  GIPI_PACK_WPOLBAS.renew_no%TYPE,
    p_eff_date      IN  GIPI_PACK_WPOLBAS.eff_date%TYPE,
    p_ann_tsi_amt   OUT GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt  OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
    p_msg_alert     OUT VARCHAR2)
AS

    /*
	**  Created by		: Veronica V. Raymundo
	**  Date Created 	: 11.16.2011
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: For events that will delete existing records amounts must be reset and 
    **                   latest annualized amounts must be retrieved from the LATEST ENDT,
    **                   for policy without endt yet latest annualized amount will be the amounts of 
    **                   POLICY RECORD. For cases with short-term endt. annualized amount should be recomputed
    **                   by adding up all policy/endt that is not yet expired
	*/

      v_prorate                 GIPI_ITMPERIL.prem_rt%TYPE := 0;   
      v_amt_sw                  VARCHAR2(1);   -- switch that will determine if amount is already  	
      v_comp_prem               GIPI_POLBASIC.prem_amt%TYPE  := 0; -- variable that will store computed prem   
      v_expired_sw              VARCHAR2(1); -- switch that is used to determine if policy have short term endt.   
      
      -- fields that will be use in storing computed amounts when computing for the amount
      -- of records with short term endorsement	
      
      v_ann_tsi2                GIPI_POLBASIC.ann_tsi_amt%TYPE :=0; 
      v_ann_prem2               GIPI_POLBASIC.ann_prem_amt%TYPE :=0;
      
      --determines if a particular peril is an allied or basic peril
      --used in populating amounts on gipi_witem.
      
      --temp
       v_prem_amt				GIPI_WPOLBAS.prem_amt%TYPE;
       v_tsi_amt				GIPI_WPOLBAS.tsi_amt%TYPE;	
       v_success				BOOLEAN := FALSE;
       v_end_of_transaction	    BOOLEAN := FALSE;
  
    BEGIN
      v_prem_amt       := 0;
      v_tsi_amt        := 0;
      
      UPDATE gipi_witem
         SET tsi_amt      = null,
             prem_amt     = null,
             ann_tsi_amt  = null,
             ann_prem_amt = null
       WHERE par_id = p_par_id
         AND rec_flag = 'A';
       
      v_expired_sw := 'N';
      
      FOR SW IN(SELECT '1'
                  FROM GIPI_ITMPERIL A,
                       GIPI_POLBASIC C,
                       GIPI_PACK_POLBASIC B
                 WHERE B.line_cd      =  p_line_cd
                   AND B.subline_cd   =  p_subline_cd
                   AND B.iss_cd       =  p_iss_cd
                   AND B.issue_yy     =  p_issue_yy
                   AND B.pol_seq_no   =  p_pol_seq_no
                   AND B.renew_no     =  p_renew_no
                   AND b.pack_policy_id = c.pack_policy_id 
                   AND c.policy_id    =  A.policy_id
                   AND B.pol_flag   IN ('1','2','3')
                   AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
                   AND TRUNC(b.eff_date) <= TRUNC(p_eff_date)
                   AND TRUNC(NVL(b.endt_expiry_date, b.expiry_date)) <TRUNC(p_eff_date)
              ORDER BY B.eff_date DESC)
      LOOP
        v_expired_sw := 'Y';
        EXIT;
      END LOOP; 
      
      --for policy with no expired_sw
      IF v_expired_sw = 'N' THEN
           --get the amount from the latest endt
           v_amt_sw := 'N';
         FOR AMT IN (SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                       FROM gipi_pack_polbasic b250 
                      WHERE b250.line_cd    = p_line_cd
                        AND b250.subline_cd = p_subline_cd
                        AND b250.iss_cd     = p_iss_cd
                        AND b250.issue_yy   = p_issue_yy
                        AND b250.pol_seq_no = p_pol_seq_no
                        AND b250.renew_no   = p_renew_no
                        AND b250.pol_flag   IN ('1','2','3') 
                        AND NVL(b250.endt_seq_no, 0) > 0
                        AND b250.eff_date  <= NVL(p_eff_date,SYSDATE)
                   ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
         LOOP
            p_ann_tsi_amt      := amt.ann_tsi_amt; 
            p_ann_prem_amt     := amt.ann_prem_amt; 
            v_amt_sw := 'Y';
            EXIT;
         END LOOP;
         --for policy without endt., get amounts from policy
           IF v_amt_sw = 'N' THEN
             FOR AMT IN (SELECT b250.ann_tsi_amt, b250.ann_prem_amt
                      FROM gipi_pack_polbasic b250 
                     WHERE b250.line_cd    = p_line_cd
                       AND b250.subline_cd = p_subline_cd
                       AND b250.iss_cd     = p_iss_cd
                       AND b250.issue_yy   = p_issue_yy
                       AND b250.pol_seq_no = p_pol_seq_no
                       AND b250.renew_no   = p_renew_no
                       AND b250.pol_flag   IN ('1','2','3') 
                       AND nvl(b250.endt_seq_no, 0) = 0)
             LOOP
               p_ann_tsi_amt      := amt.ann_tsi_amt; 
               p_ann_prem_amt     := amt.ann_prem_amt;           
              EXIT;
             END LOOP;
           END IF;
           
           --to reset amounts on gipi_witem (for items existing from prev. endt or policy record).
           FOR par_item IN (SELECT item_no
                              FROM gipi_witem
                             WHERE par_id = p_par_id
                               and rec_flag <> 'A')
           LOOP
                FOR item_amt IN (SELECT b.ann_tsi_amt, b.ann_prem_amt
                                   FROM gipi_polbasic c,
                                        gipi_pack_polbasic b250,
                                        gipi_item     b
                             WHERE b250.line_cd    = p_line_cd
                               AND b250.subline_cd = p_subline_cd
                               AND b250.iss_cd     = p_iss_cd
                               AND b250.issue_yy   = p_issue_yy
                               AND b250.pol_seq_no = p_pol_seq_no
                               AND b250.renew_no   = p_renew_no
                               AND b250.pol_flag   IN ('1','2','3') 
                               AND b250.eff_date  <= NVL(p_eff_date,SYSDATE)
                               AND b250.pack_policy_id = c.pack_policy_id
                               AND c.policy_id  = b.policy_id
                               AND b.item_no    = par_item.item_no
                             ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
           LOOP
             UPDATE gipi_witem
                SET tsi_amt      = null,
                    prem_amt     = null,
                    ann_tsi_amt  = item_amt.ann_tsi_amt,
                    ann_prem_amt = item_amt.ann_prem_amt
              WHERE par_id  = p_par_id
                AND item_no = par_item.item_no;
             EXIT;
           END LOOP;           
           END LOOP;           
           --end of modification by iris bordey 09.09.2003
      ELSE     
         --for policy with short term endt. amounts should be recomputed by adding up 
         --all policy and endt. that is not yet expired.
         FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                          (C.prem_amt * a.currency_rt) prem,       
                          B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                          B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                          B.short_rt_percent   short_rt,
                          C.peril_cd, b.incept_date
                     FROM GIPI_ITEM     A,
                          GIPI_POLBASIC d, 
                          GIPI_PACK_POLBASIC B,  
                          GIPI_ITMPERIL C
                    WHERE B.line_cd      =  p_line_cd
                      AND B.subline_cd   =  p_subline_cd
                      AND B.iss_cd       =  p_iss_cd
                      AND B.issue_yy     =  p_issue_yy
                      AND B.pol_seq_no   =  p_pol_seq_no
                      AND B.renew_no     =  p_renew_no
                      AND B.pack_policy_id = d.pack_policy_id 
                      AND d.policy_id    =  A.policy_id 
                      AND d.policy_id    =  C.policy_id 
                      AND A.item_no      =  C.item_no
                      AND B.pol_flag     in('1','2','3') 
                      AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                      AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)
                  ) 
         LOOP
           v_comp_prem := 0;
           IF A2.prorate_flag = 1 THEN
              IF A2.endt_expiry_date <= A2.eff_date THEN
                 p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
				 GOTO RAISE_FORM_TRIGGER_FAILURE;
              ELSE
                 IF A2.comp_sw = 'Y' THEN
                    v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                                   check_duration(A2.incept_date, A2.expiry_date);
                                   --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                 ELSIF A2.comp_sw = 'M' THEN
                    v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                                   check_duration(A2.incept_date, A2.expiry_date);
                                   --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                 ELSE 
                    v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                                   check_duration(A2.incept_date, A2.expiry_date);
                                     --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                 END IF;
              END IF;
              v_comp_prem  := A2.prem/v_prorate;
           ELSIF A2.prorate_flag = 2 THEN
              v_comp_prem  :=  A2.prem;
           ELSE
              v_comp_prem :=  A2.prem/(A2.short_rt/100);  
           END IF;
           --accumulate premium for ann_prem_amt
           v_ann_prem2 := v_ann_prem2 + v_comp_prem;
           FOR TYPE IN(SELECT peril_type
                         FROM giis_peril
                        WHERE line_cd  = p_pack_line_cd
                          AND peril_cd = A2.peril_cd)
           LOOP
             IF type.peril_type = 'B' THEN
                v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
             END IF;
           END LOOP;        
         END LOOP; --end of A2 FOR-LOOP
         
         p_ann_tsi_amt  := v_ann_tsi2;
         p_ann_prem_amt := v_ann_prem2;
         
         --reset variables before computing
         v_comp_prem := 0;
         v_ann_tsi2  := 0;
         v_ann_prem2 := 0;
         FOR par_item IN (SELECT item_no
                            FROM GIPI_WITEM
                           WHERE par_id = p_par_id
                             AND rec_flag <> 'A')
         LOOP
              v_ann_tsi2  := 0;
              v_ann_prem2 := 0;
              FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                            (C.prem_amt * a.currency_rt) prem,       
                            B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                            B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                            B.short_rt_percent   short_rt,
                            C.peril_cd, b.incept_date
                       FROM GIPI_ITEM     A,
                            GIPI_POLBASIC D, 
                            GIPI_PACK_POLBASIC B,
                            GIPI_ITMPERIL C
                      WHERE B.line_cd      =  p_line_cd
                        AND B.subline_cd   =  p_subline_cd
                        AND B.iss_cd       =  p_iss_cd
                        AND B.issue_yy     =  p_issue_yy
                        AND B.pol_seq_no   =  p_pol_seq_no
                        AND B.renew_no     =  p_renew_no
                        AND B.pack_policy_id = d.pack_policy_id
                        AND d.policy_id    =  A.policy_id
                        AND d.policy_id    =  C.policy_id
                        AND A.item_no      =  C.item_no
                        AND a.item_no      =  par_item.item_no
                        AND B.pol_flag     IN('1','2','3') 
                        AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                        AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)
                    ) 
           LOOP
             v_comp_prem := 0;
             IF A2.prorate_flag = 1 THEN
                IF A2.endt_expiry_date <= A2.eff_date THEN
                   p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
				   GOTO RAISE_FORM_TRIGGER_FAILURE;
                ELSE
                  IF A2.comp_sw = 'Y' THEN
                     v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                                    check_duration(A2.incept_date, A2.expiry_date);
                                   --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                  ELSIF A2.comp_sw = 'M' THEN
                    v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                                   check_duration(A2.incept_date, A2.expiry_date);
                                   --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                  ELSE 
                    v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                                   check_duration(A2.incept_date, A2.expiry_date);
                                     --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                  END IF;
                END IF;
                v_comp_prem  := A2.prem/v_prorate;
             ELSIF A2.prorate_flag = 2 THEN
                v_comp_prem  :=  A2.prem;
             ELSE
                v_comp_prem :=  A2.prem/(A2.short_rt/100);  
             END IF;
             --accumulate premium for ann_prem_amt
             
             v_ann_prem2 := v_ann_prem2 + v_comp_prem;
             FOR TYPE IN(SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd  = p_pack_line_cd
                            AND peril_cd = A2.peril_cd)
             LOOP
               IF type.peril_type = 'B' THEN
                  v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
               END IF;
             END LOOP;   
           END LOOP; --end of A2 FOR-LOOP (per item-peril)
           
           UPDATE GIPI_WITEM
              SET tsi_amt      = NULL,
                  prem_amt     = NULL,
                  ann_prem_amt = v_ann_prem2,
                  ann_tsi_amt  = v_ann_tsi2
            WHERE par_id       = p_par_id
              AND item_no      = par_item.item_no;
         END LOOP; --end of par_item FOR-LOOP
      END IF;
      
      v_end_of_transaction := TRUE;
	  <<RAISE_FORM_TRIGGER_FAILURE>>
	  
      IF v_end_of_transaction THEN
		v_success := TRUE;
	  END IF;
       
    END;
/



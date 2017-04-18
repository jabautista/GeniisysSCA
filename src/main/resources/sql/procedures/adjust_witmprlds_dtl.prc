DROP PROCEDURE CPI.ADJUST_WITMPRLDS_DTL;

CREATE OR REPLACE PROCEDURE CPI.ADJUST_WITMPRLDS_DTL(
p_dist_no       giuw_pol_dist.dist_no%TYPE
) 
IS
v_difference number(20,2);
v_cntr_ref number(20);
v_cntr number(20);
v_temp number(20,2);

BEGIN 
  /*  Created by   : Christian Santos
  **  Date Created : 11/27/2012
  **  Reference By : GIUWS006
  **  Description  : ADJUST_WITMPRLDS_DTL program unit
  */
	FOR PRL IN (SELECT PERIL_CD, SHARE_CD, SUM(DIST_TSI) DIST_TSI, SUM(DIST_PREM) DIST_PREM, SUM(ANN_DIST_TSI) DIST_ANN_TSI
				FROM GIUW_WPERILDS_DTL
				WHERE DIST_NO = P_DIST_NO
				GROUP BY PERIL_CD, SHARE_CD)
	LOOP        
		FOR ITMP IN (SELECT PERIL_CD, SHARE_CD, SUM(DIST_TSI) DIST_TSI, SUM(DIST_PREM) DIST_PREM, SUM(ANN_DIST_TSI) DIST_ANN_TSI
		FROM GIUW_WITEMPERILDS_DTL
		WHERE DIST_NO = P_DIST_NO
		GROUP BY PERIL_CD, SHARE_CD)
		LOOP
	
		IF PRL.PERIL_CD = ITMP.PERIL_CD AND PRL.SHARE_CD = ITMP.SHARE_CD THEN
	
			IF PRL.DIST_PREM <> ITMP.DIST_PREM THEN
			
				v_difference := PRL.DIST_PREM - ITMP.DIST_PREM;
				v_cntr_ref := ABS(v_difference) * 100;
				
				IF(v_cntr_ref > 50) THEN -- added by: Nica 05.30.2013 -to prevent infinite loop. As per Ma'am Grace, tolerable difference must be up to 0.5 only
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot proceed. There are errors in distribution records.');
                END IF;
                
                v_cntr := 0;
				WHILE v_cntr <> v_cntr_ref
				LOOP
					FOR I IN (SELECT * FROM GIUW_WITEMPERILDS_DTL 
								WHERE DIST_NO = P_DIST_NO
								AND PERIL_CD = PRL.PERIL_CD
								AND SHARE_CD = PRL.SHARE_CD)
					LOOP
					v_cntr := v_cntr + 1; 
					IF SIGN(v_difference*100) = -1 THEN
					v_temp := (I.DIST_PREM*100-1)/100;
					--DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					ELSE
					v_temp := (I.DIST_PREM*100+1)/100;
					--DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					END IF;
						UPDATE GIUW_WITEMPERILDS_DTL
						SET DIST_PREM = v_temp
						WHERE PERIL_CD = I.PERIL_CD
						AND SHARE_CD = I.SHARE_CD
						AND ITEM_NO = I.ITEM_NO
						AND DIST_NO = P_DIST_NO;
					EXIT WHEN v_cntr = v_cntr_ref;
					END LOOP;  
									  
				END LOOP;
			END IF;
			
			IF PRL.DIST_TSI <> ITMP.DIST_TSI THEN
			
				v_difference := PRL.DIST_TSI - ITMP.DIST_TSI;
				v_cntr_ref := ABS(v_difference) * 100;
				
                IF(v_cntr_ref > 50) THEN -- added by: Nica 05.30.2013 -to prevent infinite loop. As per Ma'am Grace, tolerable difference must be up to 0.5 only
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot proceed. There are errors in distribution records.');
                END IF;
				
                v_cntr := 0;
				WHILE v_cntr <> v_cntr_ref
				LOOP
					FOR I IN (SELECT * FROM GIUW_WITEMPERILDS_DTL 
								WHERE DIST_NO = P_DIST_NO
								AND PERIL_CD = PRL.PERIL_CD
								AND SHARE_CD = PRL.SHARE_CD)
					LOOP
					v_cntr := v_cntr + 1; 
					IF SIGN(v_difference*100) = -1 THEN
					v_temp := (I.DIST_TSI*100-1)/100;
		--            DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					ELSE
					v_temp := (I.DIST_TSI*100+1)/100;
		--            DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					END IF;
						UPDATE GIUW_WITEMPERILDS_DTL
						SET DIST_TSI = v_temp
						WHERE PERIL_CD = I.PERIL_CD
						AND SHARE_CD = I.SHARE_CD
						AND ITEM_NO = I.ITEM_NO
						AND DIST_NO = P_DIST_NO;
					EXIT WHEN v_cntr = v_cntr_ref;
					END LOOP;  
									  
				END LOOP;
			END IF;    
	
			IF PRL.DIST_ANN_TSI <> ITMP.DIST_ANN_TSI THEN
			
				v_difference := PRL.DIST_ANN_TSI - ITMP.DIST_ANN_TSI;
				v_cntr_ref := ABS(v_difference) * 100;
				
				IF(v_cntr_ref > 50) THEN -- added by: Nica 05.30.2013 -to prevent infinite loop. As per Ma'am Grace, tolerable difference must be up to 0.5 only
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot proceed. There are errors in distribution records.');
                END IF;
                
                v_cntr := 0;
				WHILE v_cntr <> v_cntr_ref
				LOOP
					FOR I IN (SELECT * FROM GIUW_WITEMPERILDS_DTL 
								WHERE DIST_NO = P_DIST_NO
								AND PERIL_CD = PRL.PERIL_CD
								AND SHARE_CD = PRL.SHARE_CD)
					LOOP
					v_cntr := v_cntr + 1; 
					IF SIGN(v_difference*100) = -1 THEN
					v_temp := (I.DIST_PREM*100-1)/100;
					--DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					ELSE
					v_temp := (I.DIST_PREM*100+1)/100;
					--DBMS_OUTPUT.PUT_LINE(I.DIST_PREM||' -/+ 1 ='||v_temp);
					END IF;
						UPDATE GIUW_WITEMPERILDS_DTL
						SET DIST_PREM = v_temp
						WHERE PERIL_CD = I.PERIL_CD
						AND SHARE_CD = I.SHARE_CD
						AND ITEM_NO = I.ITEM_NO
						AND DIST_NO = P_DIST_NO;
					EXIT WHEN v_cntr = v_cntr_ref;
					END LOOP;  
									  
				END LOOP;
			END IF;    
	
		END IF;
	
		END LOOP;
	END LOOP;
END;
/



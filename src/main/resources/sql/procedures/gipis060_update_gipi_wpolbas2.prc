DROP PROCEDURE CPI.GIPIS060_UPDATE_GIPI_WPOLBAS2;

CREATE OR REPLACE PROCEDURE CPI.Gipis060_Update_Gipi_Wpolbas2(
		  p_par_id	   					IN GIPI_WITEM.par_id%TYPE,
		  p_negate_item					IN VARCHAR2,
		  p_prorate_flag 				IN GIPI_WPOLBAS.prorate_flag%TYPE,
		  p_comp_sw						IN VARCHAR2,
		  p_endt_expiry_date			IN VARCHAR2,
		  p_eff_date					IN VARCHAR2,
		  p_short_rt_percent			IN GIPI_WPOLBAS.short_rt_percent%TYPE,
		  p_expiry_date					IN VARCHAR2,
		  p_message						OUT VARCHAR2
		  )
 IS
   v_tsi             gipi_wpolbas.tsi_amt%TYPE :=0;
   v_ann_tsi         gipi_wpolbas.ann_tsi_amt%TYPE :=0;
   v_prem            gipi_wpolbas.prem_amt%TYPE:=0;
   v_ann_prem        gipi_wpolbas.ann_prem_amt%TYPE :=0;  
   v_ann_tsi2        gipi_wpolbas.ann_tsi_amt%TYPE :=0;
   v_ann_prem2       gipi_wpolbas.ann_prem_amt%TYPE :=0;  
   v_prorate         NUMBER(12,9);
   v_no_of_items     NUMBER;
   v_comp_prem       gipi_wpolbas.prem_amt%TYPE  := 0;
   expired_sw        VARCHAR2(1) := 'N';
   v_exist           VARCHAR2(1);
   v_line_cd		 gipi_wpolbas.line_cd%TYPE;
   v_iss_cd		 	 gipi_wpolbas.iss_cd%TYPE;
   v_subline_cd		 gipi_wpolbas.subline_cd%TYPE;
   v_issue_yy		 gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no		 gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no		 gipi_wpolbas.renew_no%TYPE;
   v_eff_date		 gipi_wpolbas.eff_date%TYPE;
   v_line_cd2		 gipi_parlist.line_cd%TYPE;
   v_endt_expiry_date2			GIPI_WPOLBAS.endt_expiry_date%TYPE;
   v_eff_date2					GIPI_WPOLBAS.eff_date%TYPE;
   v_expiry_date2				GIPI_WPOLBAS.expiry_date%TYPE;
BEGIN
  p_message := 'SUCCESS';
  v_endt_expiry_date2 := TO_DATE(NVL(p_endt_expiry_date, TO_CHAR(SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')), 'MM/DD/RRRR HH:MI:SS AM');
  v_eff_date2		  := TO_DATE(NVL(p_eff_date, TO_CHAR(SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')), 'MM/DD/RRRR HH:MI:SS AM');
  v_expiry_date2	  := TO_DATE(NVL(p_expiry_date, TO_CHAR(SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')), 'MM/DD/RRRR HH:MI:SS AM');
  
  SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date
    INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date
    FROM GIPI_WPOLBAS
   WHERE par_id = p_par_id;
  
  SELECT line_cd
    INTO v_line_cd2
    FROM GIPI_PARLIST
   WHERE par_id = p_par_id;
   
	-- summarize amounts of all items for this record 
  FOR A1 IN(SELECT SUM(NVL(tsi_amt,0)     *NVL(currency_rt,1))      TSI,
                   SUM(NVL(prem_amt,0)    *NVL(currency_rt,1))     PREM,
                   COUNT(item_no)    NO_OF_ITEMS
              FROM gipi_witem
             WHERE par_id = p_par_id) 
  LOOP
  	v_ann_tsi        := v_ann_tsi +  A1.tsi;
    v_tsi            := v_tsi +  A1.tsi;
    v_prem           := v_prem +  A1.prem;
    v_no_of_items    := nvl(A1.no_of_items,0);
    /** rollie 21feb2006
        disallows recomputation of prem if item_no was negated programmatically
    **/
    IF NVL(p_negate_item,'N') = 'Y' THEN
    	 v_ann_prem := v_ann_prem + A1.prem;
    ELSE
	     --Three conditions have to be considered for endt.
	     -- 2 indicates that computation should be base on 1 year span        
	     IF p_prorate_flag = 2 THEN
	        v_ann_prem := v_ann_prem + A1.prem;
	     -- 1 indicates that computation should be prorated   
	     ELSIF p_prorate_flag = 1 THEN
	        IF p_comp_sw = 'Y' THEN
	           v_prorate  :=  ((TRUNC( v_endt_expiry_date2) - TRUNC(v_eff_date2 )) + 1 )
	                           / (ADD_MONTHS(v_eff_date2,12) - v_eff_date2);
	        ELSIF p_comp_sw = 'M' THEN
	           v_prorate  :=  ((TRUNC( v_endt_expiry_date2) - TRUNC(v_eff_date2 )) - 1 )
	                          / (ADD_MONTHS(v_eff_date2,12) - v_eff_date2);
	        ELSE
	           v_prorate  :=  (TRUNC( v_endt_expiry_date2) - TRUNC(v_eff_date2 ))
	                          / (ADD_MONTHS(v_eff_date2,12) - v_eff_date2);
	        END IF;
	       --*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero
	        IF TRUNC(v_eff_date2) = TRUNC(v_endt_expiry_date2) THEN
	        	 v_prorate := 1;
	        END IF;		
	        --msg_alert('ann prem '||A1.prem ||' '|| (v_prorate),'I',FALSE);			
	        v_ann_prem := v_ann_prem +(A1.prem / (v_prorate));
	    	  -- 3 indicates that computation should be based with respect to the short rate percent.			  
	    ELSE
	        v_ann_prem :=  v_ann_prem +(A1.prem / (NVL(p_short_rt_percent,1)/100));
	    END IF;		
    END IF;    
  END LOOP;   
  /*check if policy has an existing expired short term endorsement(s) */ 
  expired_sw := 'N';
  FOR SW IN(SELECT '1'
              FROM GIPI_ITMPERIL A,
                   GIPI_POLBASIC B
             WHERE B.line_cd      =  v_line_cd
               AND B.subline_cd   =  v_subline_cd
               AND B.iss_cd       =  v_iss_cd
               AND B.issue_yy     =  v_issue_yy
               AND B.pol_seq_no   =  v_pol_seq_no
               AND B.renew_no     =  v_renew_no
               AND B.policy_id    =  A.policy_id
               AND B.pol_flag     in('1','2','3','X')
               AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
               AND TRUNC(B.eff_date) <=  TRUNC(v_eff_date)
               --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date) )< TRUNC(v_eff_date)
               AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                   v_expiry_date2, b.expiry_date,b.endt_expiry_date)) < v_eff_date
          ORDER BY B.eff_date DESC)
  LOOP
    expired_sw := 'Y';
    EXIT;
  END LOOP; 
  /*update amounts in gipi_wpolbas 
  **for policy that have expired short term endorsement
  **recompute annualized amounts, for policy that does not have 
  **expired short term endorsements just get the amounts from the
  **latest endorsements
  */ 
  -- there are no existing short-term endt.
  IF NVL(expired_sw , 'N') = 'N' THEN
  	 v_exist := 'N';
  	 -- query amounts from the latest endt
     FOR A2 IN ( SELECT b250.ann_tsi_amt  ANN_TSI,
                        b250.ann_prem_amt ANN_PREM
                   FROM gipi_wpolbas b, gipi_polbasic b250 
                  WHERE b.par_id        = p_par_id
                    AND b250.line_cd    = b.line_cd
                    AND b250.subline_cd = b.subline_cd
                    AND b250.iss_cd     = b.iss_cd
                    AND b250.issue_yy   = b.issue_yy
                    AND b250.pol_seq_no = b.pol_seq_no
                    AND b250.renew_no   = b.renew_no
                    AND b250.pol_flag   IN ('1','2','3','X') 
                    AND TRUNC(b250.eff_date) <=  TRUNC(b.eff_date)
                    --AND TRUNC(NVL(b250.endt_expiry_date,b250.expiry_date)) >= TRUNC(b.eff_date)
                    AND (TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                        v_expiry_date2, b250.expiry_date,b250.endt_expiry_date)) >= v_eff_date OR
                        p_negate_item = 'Y') 
                    AND NVL(b250.endt_seq_no,0) > 0
               ORDER BY b250.eff_date DESC)
     LOOP
     	 UPDATE gipi_wpolbas
          SET tsi_amt      = nvl(v_tsi,0),
              prem_amt     = nvl(v_prem,0),
              ann_tsi_amt  = A2.ann_tsi  +nvl(v_ann_tsi,0),
              ann_prem_amt = A2.ann_prem + nvl(v_ann_prem,0),
              no_of_items  = nvl(v_no_of_items,0)
        WHERE par_id = p_par_id;
       v_exist := 'Y'; -- toggle switch that will indicate that amount is alredy retrieved
       EXIT;
     END LOOP;     
     --for records with no endt. yet query it's amount from policy record
     IF v_exist = 'N' THEN
        FOR A2 IN ( SELECT b250.tsi_amt      TSI,
                           b250.prem_amt     PREM,
                           b250.ann_tsi_amt  ANN_TSI,
                           b250.ann_prem_amt ANN_PREM
                      FROM gipi_wpolbas b, gipi_polbasic b250 
                     WHERE b.par_id        = p_par_id
                       AND b250.line_cd    = b.line_cd
                       AND b250.subline_cd = b.subline_cd
                       AND b250.iss_cd     = b.iss_cd
                       AND b250.issue_yy   = b.issue_yy
                       AND b250.pol_seq_no = b.pol_seq_no
                       AND b250.renew_no   = b.renew_no
                       AND b250.pol_flag   IN ('1','2','3','X') 
                       AND NVL(b250.endt_seq_no,0) = 0
                  ORDER BY B.EFF_DATE DESC)
        LOOP
        	UPDATE gipi_wpolbas
             SET tsi_amt      = NVL(v_tsi,0),
                 prem_amt     = NVL(v_prem,0),
                 ann_tsi_amt  = A2.ann_tsi  + NVL(v_ann_tsi,0),
                 ann_prem_amt = A2.ann_prem + NVL(v_ann_prem,0),
                 no_of_items  = nvl(v_no_of_items,0)
           WHERE par_id = p_par_id;           
          EXIT;
        END LOOP;
     END IF;   
  ELSE 
     --for records with existing short term endt. amounts will be recomputed
     --by adding all amounts of policy and endt. that is not yet expired
     FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                      (C.prem_amt * a.currency_rt) prem,       
                      B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                      B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                      B.short_rt_percent   short_rt,
                      C.peril_cd
                 FROM GIPI_ITEM A,
                      GIPI_POLBASIC B,  
                      GIPI_ITMPERIL C
                WHERE B.line_cd      =  v_line_cd
                  AND B.subline_cd   =  v_subline_cd
                  AND B.iss_cd       =  v_iss_cd
                  AND B.issue_yy     =  v_issue_yy
                  AND B.pol_seq_no   =  v_pol_seq_no
                  AND B.renew_no     =  v_renew_no
                  AND B.policy_id    =  A.policy_id
                  AND B.policy_id    =  C.policy_id
                  AND A.item_no      =  C.item_no
                  AND B.pol_flag     in('1','2','3','X') 
                  AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
                  --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                  AND (TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                      v_expiry_date2, b.expiry_date,b.endt_expiry_date)) >= TRUNC(v_eff_date) OR
                      p_negate_item = 'Y')
             ORDER BY B.eff_date DESC) 
     LOOP
       v_comp_prem := 0;
       /** rollie 21feb2006
        	 disallows recomputation of prem if item_no was negated programmatically
    	 **/
       IF NVL(p_negate_item,'N') = 'Y' THEN
    	    v_comp_prem := a2.prem;
       ELSE
          IF A2.prorate_flag = 1 THEN
             IF A2.endt_expiry_date <= A2.eff_date THEN
		            p_message := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
		                       ' Restricted condition.';
					RETURN;
		         ELSE
		            IF A2.comp_sw = 'Y' THEN
		               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
		                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
		            ELSIF A2.comp_sw = 'M' THEN
		               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
		                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
		            ELSE 
		               v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
		                           (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
		            END IF;
		         END IF;
			        /*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero*/
			       IF TRUNC(v_eff_date2) = TRUNC(v_endt_expiry_date2) THEN
			          v_prorate := 1;
			       END IF;	  
		         v_comp_prem  := A2.prem/v_prorate;
		       ELSIF A2.prorate_flag = 2 THEN
		          v_comp_prem  :=  A2.prem;
		       ELSE
		          v_comp_prem :=  A2.prem/(A2.short_rt/100);  
		       END IF;
       END IF;
       v_ann_prem2 := v_ann_prem2 + v_comp_prem;
       FOR TYPE IN(SELECT peril_type
                     FROM giis_peril
                    WHERE line_cd  = v_line_cd2
                      AND peril_cd = A2.peril_cd)
       LOOP
         IF type.peril_type = 'B' THEN
            v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
         END IF;
       END LOOP;        
     END LOOP;
     UPDATE gipi_wpolbas
        SET tsi_amt      = NVL(v_tsi,0),
            prem_amt     = NVL(v_prem,0),
            ann_tsi_amt  = NVL(v_ann_tsi,0) + NVL(v_ann_tsi2,0) ,
            ann_prem_amt = NVL(v_ann_prem,0) + NVL(v_ann_prem2,0) ,
            no_of_items  = nvl(v_no_of_items,0)
      WHERE par_id = p_par_id;
  END IF;
  
  COMMIT;
--EXCEPTION
  --WHEN NO_DATA_FOUND THEN
     --RETURN;
END;
/



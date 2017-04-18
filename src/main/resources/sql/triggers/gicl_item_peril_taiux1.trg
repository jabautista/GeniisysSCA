DROP TRIGGER CPI.GICL_ITEM_PERIL_TAIUX1;

CREATE OR REPLACE TRIGGER CPI.GICL_ITEM_PERIL_TAIUX1
  AFTER INSERT OR UPDATE OF claim_id, item_no, peril_cd, grouped_item_no
  ON CPI.GICL_ITEM_PERIL FOR EACH ROW
DECLARE
  --BETH 07102002
  --     recreate this trigger to solve error in getting intermediary record
  v_claim_id                  GICL_ITEM_PERIL.claim_id%TYPE  :=  :NEW.claim_id;
  v_item_no                   GICL_ITEM_PERIL.item_no%TYPE   :=  :NEW.item_no;
  v_peril_cd                  GICL_ITEM_PERIL.peril_cd%TYPE  :=  :NEW.peril_cd;
  v_grouped_item_no     GICL_ITEM_PERIL.grouped_item_no%TYPE := NVL(:NEW.grouped_item_no,0);
  v_loss_date                 GICL_CLM_ITEM.loss_date%TYPE;
  v_tot_prem_amt              GIPI_ITMPERIL.prem_amt%TYPE;
  v_intm_shr_pct              NUMBER;--GIPI_COMM_INVOICE.share_percentage%TYPE;
  v_intm_no                   GIIS_INTERMEDIARY.intm_no%TYPE;
  v_losses_paid               GICL_CLM_RES_HIST.losses_paid%TYPE;
  v_count                     NUMBER;

  /* (1)
   *pau 19MAR07 MOD TO INSERT TO temp TABLE BEFORE INSERTING INTO gicl_intm_itmperil*/
  TYPE claim_id_tab      IS TABLE OF GICL_INTM_ITMPERIL.CLAIM_ID%TYPE;
  TYPE item_no_tab      IS TABLE OF GICL_INTM_ITMPERIL.ITEM_NO%TYPE;
  TYPE peril_cd_tab      IS TABLE OF GICL_INTM_ITMPERIL.PERIL_CD%TYPE;
  TYPE grouped_item_no_tab    IS TABLE OF GICL_INTM_ITMPERIL.GROUPED_ITEM_NO%TYPE;
  TYPE intm_no_tab      IS TABLE OF GICL_INTM_ITMPERIL.INTM_NO%TYPE;
  TYPE parent_intm_no_tab    IS TABLE OF GICL_INTM_ITMPERIL.PARENT_INTM_NO%TYPE;
  TYPE shr_intm_pct_tab     IS TABLE OF NUMBER;
  TYPE premium_amt_tab     IS TABLE OF GICL_INTM_ITMPERIL.PREMIUM_AMT%TYPE;
  TYPE shrpctzero_tab     IS TABLE OF NUMBER;
  vv_claim_id          claim_id_tab;
  vv_item_no       item_no_tab;
  vv_peril_cd       peril_cd_tab;
  vv_grouped_item_no     grouped_item_no_tab;
  vv_intm_no       intm_no_tab;
  vv_parent_intm_no      intm_no_tab;
  vv_shr_intm_pct      shr_intm_pct_tab;
  vv_premium_amt      premium_amt_tab;
  vv_shrpctzero       shrpctzero_tab;
  --(1)

  --jen.032007, is true if record already exists in gicl_intm_itmperil
  v_flag        BOOLEAN := FALSE;
  --jen/06202007, stores the issue cd of the claim.
  v_iss_cd             GICL_CLAIMS.iss_cd%TYPE;
  -- function that will retrieved the parent intermediary of
  -- particular intermediary

  FUNCTION get_parent_intm(p_intrmdry_intm_no    IN GIIS_INTERMEDIARY.intm_no%TYPE)
                           RETURN NUMBER IS
    v_intm_no        GIIS_INTERMEDIARY.intm_no%TYPE;
  BEGIN
    BEGIN
       SELECT NVL(A.parent_intm_no,A.intm_no)
         INTO v_intm_no
         FROM GIIS_INTERMEDIARY A
        WHERE intm_no            = p_intrmdry_intm_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_intm_no  := p_intrmdry_intm_no;
      WHEN OTHERS THEN
        v_intm_no  := p_intrmdry_intm_no;
    END;
    RETURN v_intm_no;
  END get_parent_intm;
BEGIN
  /*Modified by: jen.03202007
  **Will save the selected records in a collection before inserting into the table.
  **This is to avoid error ora-06502 caused by too large value of shr_intm_pct.
  --*/

  -- for update of claim_id, peril_cd and item_no
  -- delete first the records in table gicl_intmperil
  -- so that duplication of records will be eliminated

  FOR i IN (SELECT ISS_CD
            FROM GICL_CLAIMS
    WHERE CLAIM_ID = :NEW.CLAIM_ID)
  LOOP
    v_iss_cd := i.iss_cd;
  END LOOP;

  IF v_iss_cd <> 'RI' THEN

	   IF UPDATING THEN
	      DELETE FROM GICL_INTM_ITMPERIL
	       WHERE claim_id  = :OLD.claim_id
	         AND peril_cd  = :OLD.peril_cd
	         AND item_no   = :OLD.item_no
	  			 AND grouped_item_no = :OLD.grouped_item_no;
	   END IF;

	   --(a) pau 20mar07 (initialize table)
	   vv_claim_id := claim_id_tab();
	   vv_item_no := item_no_tab();
	   vv_peril_cd := peril_cd_tab();
	   vv_grouped_item_no := grouped_item_no_tab();
	   vv_intm_no := intm_no_tab();
	   vv_parent_intm_no := intm_no_tab();
	   vv_shr_intm_pct := shr_intm_pct_tab();
	   vv_premium_amt := premium_amt_tab();
	   vv_shrpctzero := shrpctzero_tab();
	   --(a)

	   -- get information from table gicl_claims
	   FOR clm_info IN(
	     SELECT TRUNC(c003.loss_date) loss_date, c003.pol_eff_date, c003.expiry_date,
	            c003.line_cd,   c003.subline_cd,   c003.pol_iss_cd,
	            c003.issue_yy,  c003.pol_seq_no,   c003.renew_no
	       FROM GICL_CLAIMS c003
	      WHERE c003.claim_id = v_claim_id)
	   LOOP
	     -- get the total premium from table gipi_itmperil
	     -- for the particular item and peril
		 RAISE_APPLICATION_ERROR(-20001,'dito ang error!');
	   BEGIN
	       SELECT SUM(b380.prem_amt) tot_prem_amt
	         INTO v_tot_prem_amt
	         FROM GIPI_POLBASIC b250,
	              GIPI_ITMPERIL b380
	        WHERE b250.policy_id   = b380.policy_id
	          AND b250.line_cd     = clm_info.line_cd
	          AND b250.subline_cd  = clm_info.subline_cd
	          AND b250.iss_cd      = clm_info.pol_iss_cd
	          AND b250.issue_yy    = clm_info.issue_yy
	          AND b250.pol_seq_no  = clm_info.pol_seq_no
	          AND b250.renew_no    = clm_info.renew_no
	          AND b250.pol_flag   IN ('1','2','3','X' )
	          AND TRUNC(DECODE(b250.eff_date,b250.incept_date,clm_info.pol_eff_date,
	                    b250.eff_date))     <= clm_info.loss_date
	          AND TRUNC(DECODE(b250.expiry_date,NVL(b250.endt_expiry_date,b250.expiry_date),
	                    clm_info.expiry_date, b250.endt_expiry_date))     >= clm_info.loss_date
	          AND b250.dist_flag        = '3'
	          AND b380.peril_cd         = v_peril_cd
	          AND b380.item_no          = v_item_no;
			  NULL;

	     EXCEPTION
	       WHEN OTHERS THEN
	         NULL;
	     END;
	     -- retrieve all the records from gipi_polbasic of policy and all endt.
	     FOR policies_rec IN (
	       SELECT b250.policy_id
	         FROM GIPI_POLBASIC b250
	        WHERE b250.line_cd     = clm_info.line_cd
	          AND b250.subline_cd  = clm_info.subline_cd
	          AND b250.iss_cd      = clm_info.pol_iss_cd
	          AND b250.issue_yy    = clm_info.issue_yy
	          AND b250.pol_seq_no  = clm_info.pol_seq_no
	          AND b250.renew_no    = clm_info.renew_no
	          AND b250.pol_flag   IN ('1','2','3','X' )
	          AND TRUNC(DECODE(b250.eff_date,b250.incept_date,clm_info.pol_eff_date,
	                    b250.eff_date))     <= clm_info.loss_date
	          AND TRUNC(DECODE(b250.expiry_date,NVL(b250.endt_expiry_date,b250.expiry_date),
	                    clm_info.expiry_date, b250.endt_expiry_date))     >= clm_info.loss_date
	          AND b250.dist_flag        = '3'
	          AND EXISTS (SELECT 'X'
	                        FROM GIPI_ITMPERIL b380
	                       WHERE b380.policy_id     = b250.policy_id
	                         AND b380.peril_cd      = v_peril_cd
	                         AND b380.item_no       = v_item_no)
	        ORDER BY b250 .policy_id)
	     LOOP
	       -- get the invoice record per policy_id retrieved

	       FOR invoice_rec IN (
	         SELECT d.iss_cd,
	                d.prem_seq_no,
	              	SUM(b.prem_amt) prem_amt
	           FROM GIPI_ITMPERIL b,
	                GIPI_ITEM C,
	              	GIPI_INVOICE d
	          WHERE C.item_no          = b.item_no
	            AND C.policy_id        = b.policy_id
	          	AND C.item_grp         = d.item_grp
	           	AND C.policy_id        = d.policy_id
	           	AND b.peril_cd         = v_peril_cd
	           	AND b.item_no          = v_item_no
	           	AND C.policy_id        = policies_rec.policy_id
	      		GROUP BY d.item_grp,d.iss_cd,d.prem_seq_no)
	       LOOP
	         -- get the share percentage per intermediary for the item peril
	         FOR intermediary_rec IN (
					   SELECT A.intrmdry_intm_no,
	               	  A.share_percentage
	             FROM GIPI_COMM_INVOICE A
	            WHERE A.prem_seq_no  = invoice_rec.prem_seq_no
	              AND A.iss_cd       = invoice_rec.iss_cd
	              AND A.policy_id    = policies_rec.policy_id)
	         LOOP
	    			 --retrieve the parent intermediary using the function
	           v_intm_no    := get_parent_intm(intermediary_rec.intrmdry_intm_no);
	           BEGIN
	             -- compute amts to get the percent of a particular intm
	             -- it should the amount per invoice * the share percent of the intm.
	             -- over the total premium of the item peril
	             v_intm_shr_pct  := (invoice_rec.prem_amt * (intermediary_rec.share_percentage))/
	                                 v_tot_prem_amt;
	           EXCEPTION
	           	 WHEN ZERO_DIVIDE THEN
	               v_intm_shr_pct  := 0;
	           END;
	           -- if the computed share percent per intermediary <> 0 then
	           -- insert/update records in gicl_intm_itmperil using the computed share percent

	           IF v_intm_shr_pct <> 0 THEN
	              BEGIN
	      			    --add element into the created collection variables if the number of element is equal to 0.
	      					--used in the for loop
	      					IF vv_intm_no.COUNT = 0 THEN
	         				   vv_claim_id.EXTEND;
	       						 vv_item_no.EXTEND;
	       						 vv_peril_cd.EXTEND;
	       						 vv_grouped_item_no.EXTEND;
	       						 vv_intm_no.EXTEND;
	       						 vv_parent_intm_no.EXTEND;
	       						 vv_shr_intm_pct.EXTEND;
								     vv_premium_amt.EXTEND;
								     vv_shrpctzero.EXTEND;
	      					END IF;

					      	--will loop from first element to the last element,
									--and will check if the following values already exists
	      					FOR j IN vv_intm_no.FIRST..vv_intm_no.LAST LOOP
	     						  IF vv_intm_no(j) = intermediary_rec.intrmdry_intm_no AND
	      					     vv_grouped_item_no(j) = v_grouped_item_no AND
	     								 vv_peril_cd(j) = v_peril_cd AND
	     								 vv_item_no(j) = v_item_no AND
	     								 vv_claim_id(j) = v_claim_id THEN

	        						 vv_shr_intm_pct(j) := vv_shr_intm_pct(j) + v_intm_shr_pct;
	     								 vv_premium_amt(j) := vv_premium_amt(j) + ((v_intm_shr_pct*v_tot_prem_amt)/100);
	      							 vv_shrpctzero(j) := 0;

	     								 v_flag := TRUE; --is true if record already exists
	                  END IF;
	                END LOOP;

	      		 			IF NOT v_flag THEN --if record does not exists, insert
	      					   --if the first element of vv_intm_no is not null, then add an element to the collection
	      						 IF vv_intm_no(1) IS NOT NULL THEN
	        						  vv_claim_id.EXTEND;
	         							vv_item_no.EXTEND;
	         							vv_peril_cd.EXTEND;
	         							vv_grouped_item_no.EXTEND;
	         							vv_intm_no.EXTEND;
	         							vv_parent_intm_no.EXTEND;
	         							vv_shr_intm_pct.EXTEND;
	         							vv_premium_amt.EXTEND;
	      								vv_shrpctzero.EXTEND;
	      						 END IF;

					      		 --equate the selected values to the collection variables, element # is the last element
	      						 vv_claim_id(vv_claim_id.COUNT) := v_claim_id;
	        					 vv_item_no(vv_item_no.COUNT) := v_item_no;
	        					 vv_peril_cd(vv_peril_cd.COUNT) := v_peril_cd;
	        					 vv_grouped_item_no(vv_grouped_item_no.COUNT) := v_grouped_item_no;
	        					 vv_intm_no(vv_intm_no.COUNT) := intermediary_rec.intrmdry_intm_no;
	      						 vv_parent_intm_no(vv_parent_intm_no.COUNT) := v_intm_no;
	      						 vv_shr_intm_pct(vv_shr_intm_pct.COUNT) := v_intm_shr_pct;
	      						 vv_premium_amt(vv_premium_amt.COUNT) := ((v_intm_shr_pct*v_tot_prem_amt)/100);
	      						 vv_shrpctzero(vv_shrpctzero.COUNT) := 0;
								 NULL;
	               END IF;
								v_flag := FALSE; --after insert to collection, return to false
	             END;
	           ELSE
	           	  --IF THE computed SHARE PERCENT per intermediary = 0 THEN
	              -- INSERT/UPDATE records IN gicl_intm_itmperil USING THE SHARE PERCENT FROM gipi_comm_inv_peril
	              BEGIN
	      			  IF vv_intm_no.COUNT = 0 THEN
	         			 		 vv_claim_id.EXTEND;
	      						 vv_item_no.EXTEND;
	        					 vv_peril_cd.EXTEND;
	        					 vv_grouped_item_no.EXTEND;
	        					 vv_intm_no.EXTEND;
	        					 vv_parent_intm_no.EXTEND;
	        					 vv_shr_intm_pct.EXTEND;
        						 vv_premium_amt.EXTEND;
	        					 vv_shrpctzero.EXTEND;
	      					END IF;

	      					FOR j IN vv_intm_no.FIRST..vv_intm_no.LAST
	      					LOOP
	     						  --if record exists
									IF vv_intm_no(j) = intermediary_rec.intrmdry_intm_no AND
	     								 vv_grouped_item_no(j) = v_grouped_item_no AND
	     								 vv_peril_cd(j) = v_peril_cd AND
	     								 vv_item_no(j) = v_item_no AND
	     								 vv_claim_id(j) = v_claim_id THEN

	     								 vv_shr_intm_pct(j) := intermediary_rec.share_percentage;
	     								 vv_premium_amt(j) := vv_premium_amt(j) + ((v_intm_shr_pct*v_tot_prem_amt)/100);
	      							 vv_shrpctzero(j) := 1;

	     		 						 v_flag := TRUE;
	     							END IF;
	                END LOOP;
	         				--if not exists
	       					IF NOT v_flag THEN
							NULL;
	      					   IF vv_intm_no(1) IS NOT NULL THEN
	      							  vv_claim_id.EXTEND;
	        						  vv_item_no.EXTEND;
	        							vv_peril_cd.EXTEND;
	        							vv_grouped_item_no.EXTEND;
	        							vv_intm_no.EXTEND;
	        							vv_parent_intm_no.EXTEND;
	        							vv_shr_intm_pct.EXTEND;
	        							vv_premium_amt.EXTEND;
	        							vv_shrpctzero.EXTEND;
	                   END IF;

	       						 vv_claim_id(vv_claim_id.COUNT) := v_claim_id;
	      						 vv_item_no(vv_item_no.COUNT) := v_item_no;
	      						 vv_peril_cd(vv_peril_cd.COUNT) := v_peril_cd;
	      						 vv_grouped_item_no(vv_grouped_item_no.COUNT) := v_grouped_item_no;
	      						 vv_intm_no(vv_intm_no.COUNT) := intermediary_rec.intrmdry_intm_no;
	      						 vv_parent_intm_no(vv_parent_intm_no.COUNT) := v_intm_no;
	        					 vv_shr_intm_pct(vv_shr_intm_pct.COUNT) := intermediary_rec.share_percentage;
	        					 vv_premium_amt(vv_premium_amt.COUNT) := ((v_intm_shr_pct*v_tot_prem_amt)/100);
	        					 vv_shrpctzero(vv_shrpctzero.COUNT) := 1;
	         		  END IF;
								v_flag := FALSE;
	             END;
	           END IF;
	         END LOOP;
	       END LOOP;
	     END LOOP;
	   END LOOP;
	   FOR i IN vv_intm_no.FIRST..vv_intm_no.LAST LOOP
	     BEGIN
			   UPDATE GICL_INTM_ITMPERIL
            SET shr_intm_pct    = vv_shr_intm_pct(i),
                premium_amt     = vv_premium_amt(i)
          WHERE intm_no         = vv_intm_no(i)
				    AND grouped_item_no = vv_grouped_item_no(i)
            AND peril_cd        = vv_peril_cd(i)
            AND item_no         = vv_item_no(i)
            AND claim_id        = vv_claim_id(i);
         IF SQL%NOTFOUND THEN
				    INSERT INTO GICL_INTM_ITMPERIL
	                     (claim_id,       item_no,
	                 		  peril_cd,       grouped_item_no,
	                 		  intm_no,        parent_intm_no,
	                  		shr_intm_pct,   premium_amt)
	              VALUES (vv_claim_id(i),     vv_item_no(i),
	           			  		vv_peril_cd(i),     vv_grouped_item_no(i),
	       								vv_intm_no(i),  	  vv_parent_intm_no(i),
	       								vv_shr_intm_pct(i), vv_premium_amt(i));
				 END IF;
			 END;
	   END LOOP;
  END IF;
END;
/

ALTER TRIGGER CPI.GICL_ITEM_PERIL_TAIUX1 DISABLE;



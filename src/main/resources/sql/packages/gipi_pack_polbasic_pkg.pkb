CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_POLBASIC_PKG
AS

    /*
	**  Created by		: Emman
	**  Date Created 	: 11.23.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This function returns the latest expiry date in case there is an endorsement of expiry 
	*/
    FUNCTION extract_expiry (
	    p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
		p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
		p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
		p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
		p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
		p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
	RETURN DATE
	IS
	  v_max_eff_date      gipi_polbasic.eff_date%TYPE;
	  v_expiry_date       gipi_polbasic.expiry_date%TYPE;
	  v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE;
	  v_v_expiry_date	  DATE;
	BEGIN
	  FOR A1 in (SELECT expiry_date
	              FROM gipi_pack_polbasic a
	             WHERE a.line_cd    = p_line_cd
	               AND a.subline_cd = p_subline_cd
	               AND a.iss_cd     = p_iss_cd
	               AND a.issue_yy   = p_issue_yy
	               AND a.pol_seq_no = p_pol_seq_no
	               AND a.renew_no   = p_renew_no
	               AND a.pol_flag in ('1','2','3','X')
	               AND NVL(a.endt_seq_no,0) = 0)
	  LOOP
	    v_expiry_date  := a1.expiry_date;
	    -- then check and retrieve for any change of expiry in case there is 
	    -- endorsement of expiry date
	    FOR B1 IN (SELECT expiry_date, endt_seq_no
	                 FROM gipi_pack_polbasic a
	                WHERE a.line_cd    = p_line_cd
	                  AND a.subline_cd = p_subline_cd
	                  AND a.iss_cd     = p_iss_cd
	                  AND a.issue_yy   = p_issue_yy
	                  AND a.pol_seq_no = p_pol_seq_no
	                  AND a.renew_no   = p_renew_no
	                  AND a.pol_flag IN ('1','2','3','X')
	                  AND NVL(a.endt_seq_no,0) > 0
	                  AND expiry_date <> a1.expiry_date
	                  AND expiry_date = endt_expiry_date
	                ORDER BY a.eff_date DESC)
	    LOOP
	      v_expiry_date  := b1.expiry_date;
	      v_max_endt_seq := b1.endt_seq_no;
	      FOR B2 IN (SELECT expiry_date, endt_seq_no
	                   FROM gipi_pack_polbasic a
	       			      WHERE a.line_cd    = p_line_cd
	            			AND a.subline_cd = p_subline_cd
		                    AND a.iss_cd     = p_iss_cd
		                    AND a.issue_yy   = p_issue_yy
		                    AND a.pol_seq_no = p_pol_seq_no
		                    AND a.renew_no   = p_renew_no
		                    AND a.pol_flag in ('1','2','3','X')
		                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
		                    AND expiry_date <> B1.expiry_date
		                    AND expiry_date = endt_expiry_date
	               ORDER BY a.eff_date desc)
	      LOOP
	        v_expiry_date  := b2.expiry_date;
	        v_max_endt_seq := b2.endt_seq_no;
	        EXIT;
	     END LOOP;
	      --check for change in expiry using backward endt. 
	      FOR C IN (SELECT expiry_date
	                  FROM gipi_pack_polbasic a  --A.R.C. 07.27.2006
	                 WHERE a.line_cd    = p_line_cd
	                   AND a.subline_cd = p_subline_cd
	               		 AND a.iss_cd     = p_iss_cd
	           		     AND a.issue_yy   = p_issue_yy
	       		         AND a.pol_seq_no = p_pol_seq_no
	  	         		 AND a.renew_no   = p_renew_no
	                   	 AND a.pol_flag in ('1','2','3','X')
	                   	 AND NVL(a.endt_seq_no,0) > 0
	                   	 AND expiry_date <> a1.expiry_date
	                   	 AND expiry_date = endt_expiry_date
	                   	 AND nvl(a.back_stat,5) = 2
	                   	 AND NVL(a.endt_seq_no,0) > v_max_endt_seq
	              ORDER BY a.endt_seq_no desc)
	      LOOP
	        v_expiry_date  := c.expiry_date;
	        EXIT;
	      END LOOP;    
	      EXIT;
	    END LOOP;
	  END LOOP;
	  v_v_expiry_date := v_expiry_date;
	  
	  RETURN v_v_expiry_date;      
	END extract_expiry;
	
	/*
    **  Created by      : Emman
    **  Date Created    : 11.23.2010
    **  Reference By    : (GIPIS031A - Package Endt Basic Information)
    **  Description     : This procedure returns the ann_tsi_amt, ann_prem_amt, and p_amt_sw of the given policy_no
    */
    Procedure get_amt_from_latest_endt (
        p_line_cd           IN GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN GIPI_PACK_POLBASIC.renew_no%TYPE,
        p_eff_date          IN GIPI_PACK_POLBASIC.eff_date%TYPE,
        p_field_name        IN VARCHAR2,
        p_ann_tsi_amt       OUT GIPI_PACK_POLBASIC.ann_tsi_amt%TYPE,
        p_ann_prem_amt      OUT GIPI_PACK_POLBASIC.ann_prem_amt%TYPE,
        p_amt_sw            OUT VARCHAR2)
    IS
    BEGIN
        p_amt_sw := 'N';
        
        IF p_field_name = 'SEARCH_FOR_POLICY2' THEN
            FOR AMT IN (
                SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                   FROM GIPI_PACK_POLBASIC b250
                  WHERE b250.line_cd    = p_line_cd
                    AND b250.subline_cd = p_subline_cd
                    AND b250.iss_cd     = p_iss_cd
                    AND b250.issue_yy   = p_issue_yy
                    AND b250.pol_seq_no = p_pol_seq_no
                    AND b250.renew_no   = p_renew_no
                    AND b250.pol_flag   IN ('1','2','3','X') 
                    AND NVL(b250.endt_seq_no, 0) > 0
                    AND b250.eff_date  <= nvl(p_eff_date,SYSDATE)
               ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
            LOOP
                p_ann_tsi_amt      := amt.ann_tsi_amt; 
                p_ann_prem_amt     := amt.ann_prem_amt; 
                p_amt_sw := 'Y';
                EXIT;
            END LOOP;
        ELSIF p_field_name = 'SEARCH_FOR_POLICY' THEN
            FOR AMT IN (
                SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                   FROM GIPI_PACK_POLBASIC b250
                  WHERE b250.line_cd    = p_line_cd
                    AND b250.subline_cd = p_subline_cd
                    AND b250.iss_cd     = p_iss_cd
                    AND b250.issue_yy   = p_issue_yy
                    AND b250.pol_seq_no = p_pol_seq_no
                    AND b250.renew_no   = p_renew_no
                    AND b250.pol_flag   IN ('1','2','3','X') 
                    AND NVL(b250.endt_seq_no, 0) > 0
                    AND b250.eff_date   = (SELECT MAX(b2501.eff_date)
                                            FROM gipi_pack_polbasic b2501
                                           WHERE b2501.line_cd    = p_line_cd
                                             AND b2501.subline_cd = p_subline_cd
                                             AND b2501.iss_cd     = p_iss_cd
                                             AND b2501.issue_yy   = p_issue_yy
                                             AND b2501.pol_seq_no = p_pol_seq_no
                                             AND b2501.renew_no   = p_renew_no
                                             AND NVL(b2501.endt_seq_no, 0) > 0
                                             AND b2501.pol_flag   IN ('1','2','3','X'))
               ORDER BY b250.endt_seq_no  DESC)
            LOOP
                p_ann_tsi_amt      := amt.ann_tsi_amt; 
                p_ann_prem_amt     := amt.ann_prem_amt; 
                p_amt_sw := 'Y';
                EXIT;
            END LOOP;
        END IF;        
    END get_amt_from_latest_endt;
	
	/*
    **  Created by      : Emman
    **  Date Created    : 11.23.2010
    **  Reference By    : (GIPIS031A - Package Endt Basic Information)
    **  Description     : This procedure returns the ann_tsi_amt, ann_prem_amt of the given policy_no who has no endt
    */
    Procedure get_amt_from_pol_wout_endt (
        p_line_cd           IN GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN GIPI_PACK_POLBASIC.renew_no%TYPE,        
        p_ann_tsi_amt       OUT GIPI_PACK_POLBASIC.ann_tsi_amt%TYPE,
        p_ann_prem_amt      OUT GIPI_PACK_POLBASIC.ann_prem_amt%TYPE)
    IS
    BEGIN
        FOR AMT IN (
            SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
              FROM GIPI_PACK_POLBASIC b250
             WHERE b250.line_cd    = p_line_cd
               AND b250.subline_cd = p_subline_cd
               AND b250.iss_cd     = p_iss_cd
               AND b250.issue_yy   = p_issue_yy
               AND b250.pol_seq_no = p_pol_seq_no
               AND b250.renew_no   = p_renew_no
               AND b250.pol_flag   IN ('1','2','3','X') 
               AND NVL(b250.endt_seq_no, 0) = 0)
        LOOP
            p_ann_tsi_amt      := amt.ann_tsi_amt; 
            p_ann_prem_amt     := amt.ann_prem_amt;           
            EXIT;
        END LOOP;
    END get_amt_from_pol_wout_endt;

	/*
	**  Created by		: Emman
	**  Date Created 	: 11.23.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This procedure returns the assd_no	
	*/
	PROCEDURE gipis031A_search_for_assured(
			  				    p_assd_no       IN OUT GIPI_PACK_WPOLBAS.assd_no%TYPE,
								p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
								p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
								p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
								p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
								p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
								p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
    IS
	  v_max_eff_date1           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of backward endt with update
	  v_max_eff_date2           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of endt with no update
	  v_max_eff_date            gipi_wpolbas.eff_date%TYPE;   --store eff_date to be use to retrieve assured
	  p_eff_date                gipi_wpolbas.eff_date%TYPE;   --field that will store policy's eff_date
	  p_policy_id               gipi_polbasic.policy_id%TYPE; --field that will store policy's policy_id
	  v_max_endt_seq_no         gipi_wpolbas.endt_seq_no%TYPE;--field that will store the maximum endt_seq_no for all endt
	  v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;--field that will store the maximum endt_seq_no for backward endt. with back_stat = '2'
	BEGIN
	  --get policy id and effectivity of policy 
	  FOR X IN (SELECT b2501.eff_date eff_date, b2501.pack_policy_id policy_id
	              FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	             WHERE b2501.line_cd    = p_line_cd
	               AND b2501.subline_cd = p_subline_cd
	               AND b2501.iss_cd     = p_iss_cd
	               AND b2501.issue_yy   = p_issue_yy
	               AND b2501.pol_seq_no = p_pol_seq_no
	               AND b2501.renew_no   = p_renew_no
	               AND b2501.pol_flag   IN ('1','2','3','X')
	               AND b2501.endt_seq_no = 0) 
	  LOOP
	    p_eff_date := x.eff_date;
	    p_policy_id := x.policy_id;
	    EXIT;
	  END LOOP;             	
	  --get the maximum endt_seq_no from all endt. of the policy
	  FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
	              FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	             WHERE b2501.line_cd    = p_line_cd
	               AND b2501.subline_cd = p_subline_cd
	               AND b2501.iss_cd     = p_iss_cd
	               AND b2501.issue_yy   = p_issue_yy
	               AND b2501.pol_seq_no = p_pol_seq_no
	               AND b2501.renew_no   = p_renew_no
	               AND b2501.pol_flag   IN ('1','2','3','X')
	               AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	               AND b2501.assd_no IS NOT NULL) 
	  LOOP
	    v_max_endt_seq_no := w.endt_seq_no;  
	    EXIT;
	  END LOOP;
	  --if maximum endt_seq_no is greater than 0 then check if latest
	  --assured should be from latest backward endt with update or  
	  -- from the latest endt that is not backward 
	  IF nvl(v_max_endt_seq_no,0) > 0 THEN
	     --get maximum endt_seq_no for backward endt. with updates
	     FOR G IN (SELECT MAX(b2501.endt_seq_no) endt_seq_no
	                 FROM gipi_pack_polbasic b2501
	                WHERE b2501.line_cd    = p_line_cd
	                  AND b2501.subline_cd = p_subline_cd
	                  AND b2501.iss_cd     = p_iss_cd
	                  AND b2501.issue_yy   = p_issue_yy
	                  AND b2501.pol_seq_no = p_pol_seq_no
	                  AND b2501.renew_no   = p_renew_no
	                  AND b2501.pol_flag   IN ('1','2','3','X')
	                  AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                  AND b2501.assd_no IS NOT NULL 
	                  AND nvl(b2501.back_stat,5) = 2) 
	     LOOP
	       v_max_endt_seq_no1 := g.endt_seq_no;
	       EXIT;
	     END LOOP;
	     --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
	     --backward endt. with update then get max. eff_date for both condition
	     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
	        --get max. eff_date for backward endt with updates
	        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                     AND b2501.subline_cd = p_subline_cd
	                     AND b2501.iss_cd     = p_iss_cd
	                     AND b2501.issue_yy   = p_issue_yy
	                     AND b2501.pol_seq_no = p_pol_seq_no
	                     AND b2501.renew_no   = p_renew_no
	                     AND b2501.pol_flag   IN ('1','2','3','X')
	                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                     AND nvl(b2501.back_stat,5) = 2
	                     AND b2501.assd_no IS NOT NULL 
	                     AND b2501.endt_seq_no = v_max_endt_seq_no1)
	        LOOP
	          v_max_eff_date1 := z.eff_date;
	          EXIT;
	        END LOOP;                             	
	        --get max eff_date for endt 
	        FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                     AND b2501.subline_cd = p_subline_cd
	                     AND b2501.iss_cd     = p_iss_cd
	                     AND b2501.issue_yy   = p_issue_yy
	                     AND b2501.pol_seq_no = p_pol_seq_no
	                     AND b2501.renew_no   = p_renew_no
	                     AND b2501.pol_flag   IN ('1','2','3','X')
	                     AND b2501.endt_seq_no != 0
	                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                     AND nvl(b2501.back_stat,5)!= 2
	                     AND b2501.assd_no IS NOT NULL ) 
	        LOOP
	          v_max_eff_date2 := y.eff_date;
	          EXIT;
	        END LOOP;               
	        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
	     ELSE
	        --adress should be from the latest backward endt. with updates
	        FOR C IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                      AND b2501.subline_cd = p_subline_cd
	                      AND b2501.iss_cd     = p_iss_cd
	                      AND b2501.issue_yy   = p_issue_yy
	                      AND b2501.pol_seq_no = p_pol_seq_no
	                      AND b2501.renew_no   = p_renew_no
	                      AND b2501.pol_flag   IN ('1','2','3','X')
	                      AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                      AND nvl(b2501.back_stat,5) = 2
	                      AND b2501.endt_seq_no = v_max_endt_seq_no1
	                      AND b2501.assd_no IS NOT NULL ) 
	        LOOP
	          v_max_eff_date := c.eff_date;
	          EXIT;
	        END LOOP;                      
	     END IF;
	  ELSE
	     --eff_date should be from policy for records with no endt or 
	     --no valid endt. that meets the conditions set
	     v_max_eff_date := p_eff_date;            	
	  END IF;
	  --get assured from records with eff_date equal to the derived eff_date
	  FOR A1 IN (SELECT b2501.assd_no
	               FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	              WHERE b2501.line_cd    = p_line_cd
	                AND b2501.subline_cd = p_subline_cd
	                AND b2501.iss_cd     = p_iss_cd
	                AND b2501.issue_yy   = p_issue_yy
	                AND b2501.pol_seq_no = p_pol_seq_no
	                AND b2501.renew_no   = p_renew_no
	                AND b2501.pol_flag   IN ('1','2','3','X') 
	                AND TRUNC(b2501.eff_date)   = TRUNC(v_max_eff_date)
	                AND b2501.assd_no IS NOT NULL 
	           ORDER BY b2501.endt_seq_no  DESC )
	  LOOP
	    p_assd_no := a1.assd_no;
	    EXIT;
	  END LOOP;
	END gipis031A_search_for_assured;
	
	/*
	**  Created by		: Emman
	**  Date Created 	: 11.23.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: Retrieve address based on the new specified policy number
	**					: Fires only when the entered policy number is changed
	**					: (Original Description)
	*/
	PROCEDURE gipis031A_search_for_address(p_add1 			IN OUT GIPI_WPOLBAS.address1%TYPE,
								p_add2 			IN OUT GIPI_WPOLBAS.address2%TYPE,
								p_add3 			IN OUT GIPI_WPOLBAS.address3%TYPE,
								p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
								p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
								p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
								p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
								p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
								p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE) IS
	  v_max_eff_date1           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of backward endt with update
	  v_max_eff_date2           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of endt with no update
	  v_max_eff_date            gipi_wpolbas.eff_date%TYPE;   --store eff_date to be use to retrieve address
	  p_eff_date                gipi_wpolbas.eff_date%TYPE;   --field that will store policy's eff_date
	  p_policy_id               gipi_polbasic.policy_id%TYPE; --field that will store policy's policy_id
	  v_max_endt_seq_no         gipi_wpolbas.endt_seq_no%TYPE;--field that will store the maximum endt_seq_no for all endt
	  v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;--field that will store the maximum endt_seq_no for backward endt. with back_stat = '2'
	BEGIN
	  --get policy id and effectivity of policy 
	  FOR X IN (SELECT b2501.eff_date eff_date, b2501.pack_policy_id policy_id
	              FROM gipi_pack_polbasic b2501
	             WHERE b2501.line_cd    = p_line_cd
	               AND b2501.subline_cd = p_subline_cd
	               AND b2501.iss_cd     = p_iss_cd
	               AND b2501.issue_yy   = p_issue_yy
	               AND b2501.pol_seq_no = p_pol_seq_no
	               AND b2501.renew_no   = p_renew_no
	               AND b2501.pol_flag   IN ('1','2','3','X')
	               AND b2501.endt_seq_no = 0) 
	  LOOP
	    p_eff_date := x.eff_date;
	    p_policy_id := x.policy_id;
	    EXIT;
	  END LOOP;             	
	  --get the maximum endt_seq_no from all endt. of the policy
	  FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
	              FROM gipi_pack_polbasic b2501
	             WHERE b2501.line_cd    = p_line_cd
	               AND b2501.subline_cd = p_subline_cd
	               AND b2501.iss_cd     = p_iss_cd
	               AND b2501.issue_yy   = p_issue_yy
	               AND b2501.pol_seq_no = p_pol_seq_no
	               AND b2501.renew_no   = p_renew_no
	               AND b2501.pol_flag   IN ('1','2','3','X')
	               AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	               AND (b2501.address1 IS NOT NULL OR
	                    b2501.address2 IS NOT NULL OR
	                    b2501.address3 IS NOT NULL)) 
	  LOOP
	    v_max_endt_seq_no := w.endt_seq_no;  
	    EXIT;
	  END LOOP;
	  --if maximum endt_seq_no is greater than 0 then check if latest
	  --address should be from latest backward endt with update or  
	  -- from the latest endt that is not backward 
	  IF v_max_endt_seq_no > 0 THEN
	     --get maximum endt_seq_no for backward endt. with updates
	     FOR G IN (SELECT MAX(b2501.endt_seq_no) endt_seq_no
	                 FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                WHERE b2501.line_cd    = p_line_cd
	                  AND b2501.subline_cd = p_subline_cd
	                  AND b2501.iss_cd     = p_iss_cd
	                  AND b2501.issue_yy   = p_issue_yy
	                  AND b2501.pol_seq_no = p_pol_seq_no
	                  AND b2501.renew_no   = p_renew_no
	                  AND b2501.pol_flag   IN ('1','2','3','X')
	                  AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                  AND (b2501.address1 IS NOT NULL OR
	                       b2501.address2 IS NOT NULL OR
	                       b2501.address3 IS NOT NULL)
	                  AND nvl(b2501.back_stat,5) = 2) 
	     LOOP
	       v_max_endt_seq_no1 := g.endt_seq_no;
	       EXIT;
	     END LOOP;
	     --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
	     --backward endt. with update then get max. eff_date for both condition
	     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
	        --get max. eff_date for backward endt with updates
	        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                     AND b2501.subline_cd = p_subline_cd
	                     AND b2501.iss_cd     = p_iss_cd
	                     AND b2501.issue_yy   = p_issue_yy
	                     AND b2501.pol_seq_no = p_pol_seq_no
	                     AND b2501.renew_no   = p_renew_no
	                     AND b2501.pol_flag   IN ('1','2','3','X')
	                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                     AND nvl(b2501.back_stat,5) = 2
	                     AND (b2501.address1 IS NOT NULL OR
	                          b2501.address2 IS NOT NULL OR
	                          b2501.address3 IS NOT NULL)
	                     AND b2501.endt_seq_no = v_max_endt_seq_no1)
	        LOOP
	          v_max_eff_date1 := z.eff_date;
	          EXIT;
	        END LOOP;                             	
	        --get max eff_date for endt 
	        FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                     AND b2501.subline_cd = p_subline_cd
	                     AND b2501.iss_cd     = p_iss_cd
	                     AND b2501.issue_yy   = p_issue_yy
	                     AND b2501.pol_seq_no = p_pol_seq_no
	                     AND b2501.renew_no   = p_renew_no
	                     AND b2501.pol_flag   IN ('1','2','3','X')
	                     AND b2501.endt_seq_no != 0
	                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                     AND nvl(b2501.back_stat,5)!= 2
	                     AND (b2501.address1 IS NOT NULL OR
	                          b2501.address2 IS NOT NULL OR
	                          b2501.address3 IS NOT NULL)) 
	        LOOP
	          v_max_eff_date2 := y.eff_date;
	          EXIT;
	        END LOOP;               
	        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
	     ELSE
	        --adress should be from the latest backward endt. with updates
	        FOR C IN (SELECT MAX(b2501.eff_date) eff_date
	                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	                   WHERE b2501.line_cd    = p_line_cd
	                      AND b2501.subline_cd = p_subline_cd
	                      AND b2501.iss_cd     = p_iss_cd
	                      AND b2501.issue_yy   = p_issue_yy
	                      AND b2501.pol_seq_no = p_pol_seq_no
	                      AND b2501.renew_no   = p_renew_no
	                      AND b2501.pol_flag   IN ('1','2','3','X')
	                      AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
	                      AND nvl(b2501.back_stat,5) = 2
	                      AND b2501.endt_seq_no = v_max_endt_seq_no1
	                      AND (b2501.address1 IS NOT NULL OR
	                           b2501.address2 IS NOT NULL OR
	                           b2501.address3 IS NOT NULL)) 
	        LOOP
	          v_max_eff_date := c.eff_date;
	          EXIT;
	        END LOOP;                      
	     END IF;
	  ELSE
	     --eff_date should be from policy for records with no endt or 
	     --no valid endt. that meets the conditions set
	     v_max_eff_date := p_eff_date;            	
	  END IF;
	  --get address from records with eff_date equal to the derived eff_date
	  FOR A1 IN (SELECT b2501.address1, b2501.address2, b2501.address3
	               FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
	              WHERE b2501.line_cd    = p_line_cd
	                AND b2501.subline_cd = p_subline_cd
	                AND b2501.iss_cd     = p_iss_cd
	                AND b2501.issue_yy   = p_issue_yy
	                AND b2501.pol_seq_no = p_pol_seq_no
	                AND b2501.renew_no   = p_renew_no
	                AND b2501.pol_flag   IN ('1','2','3','X') 
	                AND b2501.eff_date   = v_max_eff_date
	                AND (b2501.address1 IS NOT NULL OR
	                     b2501.address2 IS NOT NULL OR
	                     b2501.address3 IS NOT NULL)
	           ORDER BY b2501.endt_seq_no  DESC )
	  LOOP
	    p_add1 := a1.address1;
	    p_add2 := a1.address2;
	    p_add3 := a1.address3;
	    EXIT;
	  END LOOP;
	END gipis031A_search_for_address;

  
  FUNCTION get_policy_for_pack_endt(p_line_cd GIPI_PACK_WPOLBAS.line_cd%TYPE,
  		   							p_iss_cd  GIPI_PACK_WPOLBAS.iss_cd%TYPE, 
    								p_subline GIPI_PACK_WPOLBAS.subline_cd%TYPE,
                                    p_issue_yy GIPI_PACK_WPOLBAS.issue_yy%TYPE, --lbeltran SR2576 091115
                                    p_pol_seq_no GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
                                    p_renew_no GIPI_PACK_WPOLBAS.renew_no%TYPE,
									p_keyword VARCHAR2)
    RETURN gipi_pack_polbasic_lov_tab PIPELINED IS
    v_polbas    pack_polbasic_endt_lov_type;    --jmm SR-22834    
  BEGIN
    FOR i IN (
        SELECT a.pack_policy_id, subline_cd, iss_cd, to_char(issue_yy,'09') issue_yy,
	       to_char(pol_seq_no,'0000009') pol_seq_no, to_char(renew_no,'09') renew_no, a.assd_no, b.assd_name, e.ri_cd--jmm
          FROM gipi_pack_polbasic a, giis_assured b, (SELECT c.pack_policy_id, d.ri_cd      --- gcmiralles 02.23.2017 SR 23881
                                                        FROM giri_pack_inpolbas c, giis_reinsurer d
                                                       WHERE d.ri_cd = c.ri_cd) e
         WHERE line_cd = p_line_cd 
           AND endt_seq_no = 0 
           AND pol_flag NOT IN ('5', '4') 
           AND a.assd_no = b.assd_no 
           AND a.pack_policy_id = e.pack_policy_id(+) -- bonok :: 1.5.2017 :: UCPB SR 23641 :: additional findings - error when selecting package policies during endorsement
           AND subline_cd = NVL(p_subline, subline_cd) --jmm 
           AND iss_cd = NVL(p_iss_cd,iss_cd) 
           AND issue_yy = NVL(p_issue_yy, issue_yy) 
           AND pol_seq_no = NVL(p_pol_seq_no,pol_seq_no) 
           AND renew_no = NVL(p_renew_no,renew_no) --lbeltran SR2576 091115 
           AND (subline_cd LIKE UPPER ('%' || p_keyword || '%') OR 
                iss_cd LIKE UPPER ('%' || p_keyword || '%') OR
                issue_yy LIKE UPPER ('%' || p_keyword || '%') OR
                pol_seq_no LIKE UPPER ('%' || p_keyword || '%') OR
                renew_no LIKE UPPER ('%' || p_keyword || '%')))
    LOOP
		v_polbas.policy_id 	   := i.pack_policy_id;
        v_polbas.subline_cd    := i.subline_cd;
        v_polbas.iss_cd        := i.iss_cd;
        v_polbas.issue_yy      := i.issue_yy;
        v_polbas.pol_seq_no    := i.pol_seq_no;
        v_polbas.renew_no      := i.renew_no;
        v_polbas.assd_no       := i.assd_no; --jmm
        v_polbas.assd_name     := i.assd_name; --jmm
        v_polbas.ri_cd         := i.ri_cd; --jmm
        PIPE ROW(v_polbas);
    END LOOP;
    RETURN;    
  END get_policy_for_pack_endt;
  
  /*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  :  Gets the pack_policy_id from GIPI_PACK_POLBASIC. 
*/ 

    FUNCTION get_pack_policy_id (
      p_line_cd      GIPI_PACK_POLBASIC.line_cd%TYPE,
      p_subline_cd   GIPI_PACK_POLBASIC.subline_cd%TYPE,
      p_iss_cd       GIPI_PACK_POLBASIC.iss_cd%TYPE,
      p_issue_yy     GIPI_PACK_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no   GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
      p_renew_no     GIPI_PACK_POLBASIC.renew_no%TYPE
   )                                              
      RETURN NUMBER
   IS
      v_pack_pol_id   GIPI_PACK_POLBASIC.pack_policy_id%TYPE;
   BEGIN
      FOR i IN (SELECT pack_policy_id policy_id
                  FROM GIPI_PACK_POLBASIC
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         v_pack_pol_id := i.policy_id;
         EXIT;
      END LOOP;

      RETURN v_pack_pol_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_pack_policy_id;
   
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  :  Gets the pol_flag from GIPI_PACK_POLBASIC. 
*/
   FUNCTION get_pol_flag (p_pack_policy_id GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
      RETURN GIPI_PACK_POLBASIC.pol_flag%TYPE
   IS
      v_pol_flag   GIPI_PACK_POLBASIC.pol_flag%TYPE;
   BEGIN
      FOR i IN (SELECT pol_flag
                  FROM GIPI_PACK_POLBASIC
                 WHERE pack_policy_id = p_pack_policy_id)
      LOOP
         v_pol_flag := i.pol_flag;
      END LOOP;

      RETURN v_pol_flag;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_pol_flag;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  10 03, 2011
    **  Reference By : (GICLS010 - Claims Basic Information) 
    **  Description  :  Gets the list of policies for Package 
    */ 
    FUNCTION get_pack_policies_list(
        p_line_cd      GIPI_PACK_POLBASIC.line_cd%TYPE,
        p_subline_cd   GIPI_PACK_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd   GIPI_PACK_POLBASIC.iss_cd%TYPE,
        p_issue_yy     GIPI_PACK_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   GIPI_PACK_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     GIPI_PACK_POLBASIC.renew_no%TYPE
        )
    RETURN pack_policies_tab PIPELINED IS
      v_list        pack_policies_type;
    BEGIN
        FOR i IN(SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        ltrim(to_char(a.issue_yy,'09'))||'-'||
                        ltrim(to_char(a.pol_seq_no,'0999999'))||'-'||
                        ltrim(to_char(a.renew_no,'09')) policy_id,
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        a.pack_policy_id
                   FROM gipi_polbasic a, gipi_pack_polbasic b
                  WHERE a.pack_policy_id = b.pack_policy_id
                    AND a.pack_pol_flag  = 'Y'
                    AND a.pol_flag       IN ('1','2','3','X')
                    AND b.line_cd        = p_line_cd
                    AND b.subline_cd     = p_subline_cd
                    AND b.iss_cd         = p_pol_iss_cd
                    AND b.issue_yy       = p_issue_yy
                    AND b.pol_seq_no     = p_pol_seq_no
                    AND b.renew_no       = p_renew_no
                    AND b.endt_seq_no    = 0)
        LOOP
            v_list.nbt_pk_pol       := i.policy_id;
            v_list.line_cd          := i.line_cd;
            v_list.subline_cd       := i.subline_cd;
            v_list.iss_cd           := i.iss_cd;
            v_list.issue_yy         := i.issue_yy;
            v_list.pol_seq_no       := i.pol_seq_no;
            v_list.renew_no         := i.renew_no;
            v_list.pack_policy_id   := i.pack_policy_id;
        PIPE ROW(v_list);    
        END LOOP;        
    RETURN;            
    END;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  01.05.2012
    **  Reference By : (GIRIS053A - Generate Package Binders) 
    **  Description  :  Gets the list of binders for Package 
    */ 
    FUNCTION get_package_binders(
        p_line_cd           gipi_pack_polbasic.line_cd%TYPE,
        p_iss_cd            gipi_pack_polbasic.iss_cd%TYPE,
        p_module            VARCHAR2,
        p_endt_seq_no       gipi_pack_polbasic.endt_seq_no%TYPE,
        p_endt_iss_cd       gipi_pack_polbasic.endt_iss_cd%TYPE,
        p_endt_yy           gipi_pack_polbasic.endt_yy%TYPE
        )
    RETURN gipi_pack_polbasic_tab PIPELINED IS
      TYPE cur_type IS REF CURSOR;
      cur           cur_type;
      v_stmt        VARCHAR2(32000);
      v_row         gipi_pack_polbasic_type;
    BEGIN
        v_stmt := 'SELECT a.pack_policy_id, a.line_cd, a.subline_cd,
                          a.iss_cd, a.issue_yy, a.pol_seq_no, 
                          a.renew_no, a.endt_iss_cd, a.endt_yy, 
                          a.endt_seq_no, a.endt_type, a.pack_par_id, 
                          a.assd_no, b.assd_name
                     FROM gipi_pack_polbasic a,
                          giis_assured b
                    WHERE a.assd_no = b.assd_no(+) 
                      AND a.pack_policy_id IN (SELECT DISTINCT pack_policy_id 
                                                 FROM gipi_polbasic c, giuw_pol_dist A, giri_distfrps B 
                                                WHERE c.policy_id = a.policy_id 
                                                  AND A.dist_flag NOT IN(4,5) 
                                                  AND A.dist_no = B.dist_no)';
                                                  
        IF p_endt_seq_no IS NOT NULL OR p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
           v_stmt := v_stmt ||' AND a.pack_policy_id IN(SELECT DISTINCT c2.pack_policy_id 
                                                          FROM giuw_pol_dist A2, giri_distfrps B2, gipi_polbasic C2 
                                                         WHERE A2.dist_flag NOT IN(4,5) 
                                                           AND A2.dist_no   = B2.dist_no 
                                                           AND A2.policy_id = C2.policy_id 
                                                           AND C2.endt_seq_no > 0 
                                                           AND C2.endt_seq_no = nvl(:p_endt_seq_no,c2.endt_seq_no) 
                                                           AND C2.endt_iss_cd = nvl(:p_endt_iss_cd, c2.endt_iss_cd) 
                                                           AND C2.endt_yy = nvl(:p_endt_yy, c2.endt_yy)) ';
        END IF;         

        IF p_iss_cd IS NULL AND p_line_cd IS NOT NULL THEN
          v_stmt := v_stmt || ' AND a.line_cd = DECODE(check_user_per_line(:p_line_cd,:p_iss_cd,:p_module),1,:p_line_cd,NULL) 
                                AND a.iss_cd = DECODE(check_user_per_iss_cd(line_cd,iss_cd,:p_module),1,iss_cd,NULL) 
                              ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no';
          IF p_endt_seq_no IS NOT NULL OR p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
            OPEN cur FOR v_stmt
            USING p_endt_seq_no,
                  p_endt_iss_cd, 
                  p_endt_yy,
                  p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_line_cd,
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;      
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;	 
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          ELSE
            OPEN cur FOR v_stmt
            USING p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_line_cd,
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;     
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;		 
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          END IF;                   
        ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NULL THEN  	               
          v_stmt := v_stmt || ' AND a.line_cd = DECODE(check_user_per_line(line_cd,iss_cd,:p_module),1,line_cd,NULL) 
                                AND a.iss_cd = DECODE(check_user_per_iss_cd(:p_line_cd,:p_iss_cd,:p_module),1,:p_iss_cd,NULL) 
                              ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no';
          IF p_endt_seq_no IS NOT NULL OR p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
            OPEN cur FOR v_stmt
            USING p_endt_seq_no,
                  p_endt_iss_cd, 
                  p_endt_yy,
                  p_module,
                  p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_iss_cd;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;     
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;		 
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          ELSE
            OPEN cur FOR v_stmt
            USING p_module,
                  p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_iss_cd;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;    
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;		 
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          END IF;              
        ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL THEN  	               
          v_stmt := v_stmt || ' AND a.line_cd = DECODE(check_user_per_line(:p_line_cd,:p_iss_cd,:p_module),1,line_cd,NULL) 
                                AND a.iss_cd = DECODE(check_user_per_iss_cd(:p_line_cd,:p_iss_cd,:p_module),1,iss_cd,NULL) 
                              ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no';
          IF p_endt_seq_no IS NOT NULL OR p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
            OPEN cur FOR v_stmt
            USING p_endt_seq_no,
                  p_endt_iss_cd, 
                  p_endt_yy, 
                  p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_line_cd,
                  p_iss_cd,
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;     
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;	
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          ELSE
            OPEN cur FOR v_stmt
            USING p_line_cd,
                  p_iss_cd,
                  p_module,
                  p_line_cd,
                  p_iss_cd,
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;     
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;	
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          END IF;
        ELSIF p_iss_cd IS NULL AND p_line_cd IS NULL THEN  	               
          v_stmt := v_stmt || ' AND a.line_cd = DECODE(check_user_per_line(line_cd,iss_cd,:p_module),1,line_cd,NULL) 
                                AND a.iss_cd = DECODE(check_user_per_iss_cd(line_cd,iss_cd,:p_module),1,iss_cd,NULL) 
                              ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no';
          IF p_endt_seq_no IS NOT NULL OR p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
            OPEN cur FOR v_stmt
            USING p_endt_seq_no,
                  p_endt_iss_cd, 
                  p_endt_yy,  
                  p_module, 
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;  
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;	 
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          ELSE
            OPEN cur FOR v_stmt
            USING p_module, 
                  p_module;
            LOOP      
                FETCH cur 
                 INTO v_row.pack_policy_id, v_row.line_cd, v_row.subline_cd,
                      v_row.iss_cd, v_row.issue_yy, v_row.pol_seq_no, 
                      v_row.renew_no, v_row.endt_iss_cd, v_row.endt_yy, 
                      v_row.endt_seq_no, v_row.endt_type, v_row.pack_par_id, 
                      v_row.assd_no, v_row.assd_name;      
            
                EXIT WHEN cur%NOTFOUND;
                IF v_row.endt_seq_no <= 0 THEN 
                  v_row.endt_yy     := NULL;
                  v_row.endt_iss_cd := NULL;
                  v_row.endt_seq_no := NULL;	
                END IF;
                PIPE ROW(v_row);
            END LOOP;
            CLOSE cur;
          END IF;
        END IF;  
      RETURN;  
    END;
    
    FUNCTION check_pack_pol_giexs006 (
       p_line_cd       gipi_pack_polbasic.line_cd%TYPE,
       p_subline_cd    gipi_pack_polbasic.subline_cd%TYPE,
       p_iss_cd        gipi_pack_polbasic.iss_cd%TYPE,
       p_issue_yy      gipi_pack_polbasic.issue_yy%TYPE,
       p_pol_seq_no    gipi_pack_polbasic.pol_seq_no%TYPE,
       p_renew_no      gipi_pack_polbasic.renew_no%TYPE
    )
       RETURN check_pack_pol_giexs006_tab PIPELINED
    IS
       v_result	    check_pack_pol_giexs006_type;
    BEGIN
       FOR i IN(SELECT pack_pol_flag, pack_policy_id
                  FROM gipi_pack_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = p_issue_yy
                   AND pol_seq_no  = p_pol_seq_no
                   AND renew_no    = p_renew_no
                   AND NVL(endt_seq_no, 0) = 0)
       LOOP
           v_result.pack_policy_id := i.pack_policy_id;
           v_result.pack_pol_flag  := i.pack_pol_flag;
           PIPE ROW(v_result);
       END LOOP;
    END check_pack_pol_giexs006;
	
	PROCEDURE copy_pack_polbasic_giuts008a (
		p_policy_id   IN gipi_polbasic.policy_id%TYPE,--policy_id
		p_copy_pol_id IN gipi_pack_polbasic.pack_par_id%TYPE,--gen
		p_par_iss_cd  IN gipi_pack_polbasic.iss_cd%TYPE,--parIssCd
		p_pol_iss_cd  IN gipi_pack_polbasic.iss_cd%TYPE,
		p_line_cd     IN gipi_pack_polbasic.line_cd%TYPE,
		p_subline_cd  IN gipi_pack_polbasic.subline_cd%TYPE,
		p_iss_cd      IN gipi_pack_polbasic.iss_cd%TYPE,
		p_issue_yy    IN gipi_pack_polbasic.issue_yy%TYPE,
		p_pol_seq_no  IN gipi_pack_polbasic.pol_seq_no%TYPE,
		p_renew_no    IN gipi_pack_polbasic.renew_no%TYPE,
		p_user_id     IN giis_users.user_id%TYPE,
		message		 OUT VARCHAR2
	) IS
	    v_line_cd              gipi_pack_polbasic.line_cd%TYPE; 
        v_subline_cd           gipi_pack_polbasic.subline_cd%TYPE; 
        v_iss_cd               gipi_pack_polbasic.iss_cd%TYPE; 
        v_issue_yy             gipi_pack_polbasic.issue_yy%TYPE; 
        v_pol_seq_no           gipi_pack_polbasic.pol_seq_no%TYPE; 
        v_endt_iss_cd          gipi_pack_polbasic.endt_iss_cd%TYPE;   
        v_endt_yy              gipi_pack_polbasic.endt_yy%TYPE; 
        v_endt_seq_no          gipi_pack_polbasic.endt_seq_no%TYPE; 
        v_renew_no             gipi_pack_polbasic.renew_no%TYPE; 
        v_endt_type            gipi_pack_polbasic.endt_type%TYPE; 
        v_assd_no              gipi_pack_polbasic.assd_no%TYPE; 
        v_designation          gipi_pack_polbasic.designation%TYPE; 
        v_mortg_name           gipi_pack_polbasic.mortg_name%TYPE; 
        v_tsi_amt              gipi_pack_polbasic.tsi_amt%TYPE; 
        v_prem_amt             gipi_pack_polbasic.prem_amt%TYPE; 
        v_ann_tsi_amt          gipi_pack_polbasic.ann_tsi_amt%TYPE; 
        v_ann_prem_amt         gipi_pack_polbasic.ann_prem_amt%TYPE; 
        v_invoice_sw           gipi_pack_polbasic.invoice_sw%TYPE; 
        v_pool_pol_no          gipi_pack_polbasic.pool_pol_no%TYPE; 
        v_address1             gipi_pack_polbasic.address1%TYPE; 
        v_address2             gipi_pack_polbasic.address2%TYPE; 
        v_address3             gipi_pack_polbasic.address3%TYPE; 
        v_orig_policy_id       gipi_pack_polbasic.orig_policy_id%TYPE; 
        v_endt_expiry_date     gipi_pack_polbasic.endt_expiry_date%TYPE; 
        v_no_of_items          gipi_pack_polbasic.no_of_items%TYPE; 
        v_subline_type_cd      gipi_pack_polbasic.subline_type_cd%TYPE; 
        v_auto_renew_flag      gipi_pack_polbasic.auto_renew_flag%TYPE; 
        v_prorate_flag         gipi_pack_polbasic.prorate_flag%TYPE; 
        v_short_rt_percent     gipi_pack_polbasic.short_rt_percent%TYPE; 
        v_prov_prem_tag        gipi_pack_polbasic.prov_prem_tag%TYPE; 
        v_type_cd              gipi_pack_polbasic.type_cd%TYPE; 
        v_acct_of_cd           gipi_pack_polbasic.acct_of_cd%TYPE; 
        v_prov_prem_pct        gipi_pack_polbasic.prov_prem_pct%TYPE; 
        v_pack_pol_flag        gipi_pack_polbasic.pack_pol_flag%TYPE; 
        v_prem_warr_tag        gipi_pack_polbasic.prem_warr_tag%TYPE;
        v_ref_pol_no           gipi_pack_polbasic.ref_pol_no%TYPE;
        v_expiry_date          gipi_pack_polbasic.endt_expiry_date%TYPE;              
        v_incept_date          gipi_pack_polbasic.endt_expiry_date%TYPE; 
        v_discount_sw          gipi_pack_polbasic.discount_sw%TYPE;
        v_reg_policy_sw        gipi_pack_polbasic.reg_policy_sw%TYPE;
        v_co_insurance_sw      gipi_pack_polbasic.co_insurance_sw%TYPE;
        v_ref_open_pol_no      gipi_pack_polbasic.ref_open_pol_no%TYPE;
        v_fleet_print_tag      gipi_pack_polbasic.fleet_print_tag%TYPE;
        v_incept_tag           gipi_pack_polbasic.incept_tag%TYPE;
        v_expiry_tag           gipi_pack_polbasic.expiry_tag%TYPE;
        v_endt_expiry_tag      gipi_pack_polbasic.endt_expiry_tag%TYPE;
        v_foreign_acc_sw   	   gipi_pack_polbasic.foreign_acc_sw%TYPE;            
        v_comp_sw			   gipi_pack_polbasic.comp_sw%TYPE;   
	    v_with_tariff_sw       gipi_pack_polbasic.with_tariff_sw%TYPE;
	    v_place_cd             gipi_pack_polbasic.place_cd%TYPE;
        v_subline_time         NUMBER;
        v_surcharge_sw         gipi_pack_polbasic.surcharge_sw%TYPE;
        v_region_cd		       gipi_pack_polbasic.region_cd%TYPE;	
        v_industry_cd          gipi_pack_polbasic.industry_cd%TYPE;
        v_cred_branch          gipi_pack_polbasic.cred_branch%TYPE;
        v_booking_mth          gipi_wpolbas.booking_mth%TYPE;
        v_booking_year         gipi_wpolbas.booking_year%TYPE;
        v_vdate				   giis_parameters.param_value_n%TYPE;
	BEGIN
		SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,endt_iss_cd,endt_yy,endt_seq_no, renew_no,--9
		 	   invoice_sw,auto_renew_flag,prov_prem_tag,pack_pol_flag,reg_policy_sw,co_insurance_sw,endt_type,--7
			   incept_date,expiry_date,expiry_tag,assd_no,designation,address1,address2,address3,--8
			   DECODE(p_par_iss_cd,p_pol_iss_cd,mortg_name,null) mortg_name,tsi_amt,prem_amt,ann_tsi_amt,--4
			   ann_prem_amt,pool_pol_no,foreign_acc_sw,discount_sw,orig_policy_id,endt_expiry_date,no_of_items,--7
			   subline_type_cd,prorate_flag,short_rt_percent,type_cd,decode(acct_of_cd,0,null,acct_of_cd),prov_prem_pct,--6
			   prem_warr_tag,ref_pol_no,ref_open_pol_no,incept_tag,comp_sw,endt_expiry_tag,fleet_print_tag,--7
			   with_tariff_sw,place_cd,surcharge_sw,region_cd,industry_cd,cred_branch--6
		  INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_endt_iss_cd,v_endt_yy,v_endt_seq_no,v_renew_no,--9
			   v_invoice_sw,v_auto_renew_flag,v_prov_prem_tag,v_pack_pol_flag,v_reg_policy_sw,v_co_insurance_sw,v_endt_type,--7
			   v_incept_date,v_expiry_date,v_expiry_tag,v_assd_no,v_designation,v_address1,v_address2,v_address3,--8
			   v_mortg_name,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,--4
			   v_ann_prem_amt,v_pool_pol_no,v_foreign_acc_sw,v_discount_sw,v_orig_policy_id,v_endt_expiry_date,v_no_of_items,--7
			   v_subline_type_cd,v_prorate_flag,v_short_rt_percent,v_type_cd,v_acct_of_cd,v_prov_prem_pct,--6
			   v_prem_warr_tag,v_ref_pol_no,v_ref_open_pol_no,v_incept_tag,v_comp_sw,v_endt_expiry_tag,v_fleet_print_tag,--7
			   v_with_tariff_sw,v_place_cd,v_surcharge_sw,v_region_cd,v_industry_cd,v_cred_branch--6
		  FROM gipi_pack_polbasic
	     WHERE pack_policy_id = p_policy_id;
		 
        FOR a IN (SELECT subline_time
	 		        FROM giis_subline
			       WHERE line_cd = p_line_cd
   				     AND subline_cd = p_subline_cd) 
        LOOP
	        v_subline_time := TO_NUMBER(a.subline_time);
        END LOOP;
		   
		IF  v_endt_seq_no != 0 THEN
		    v_endt_seq_no := 0;
		    v_address1    := NULL;
		    v_address2    := NULL;
		    v_address3    := NULL;
		    v_assd_no     := NULL;
		    v_designation := NULL;
		    v_tsi_amt     := 0;
		    v_prem_amt    := 0;
		    FOR a1 IN (SELECT b250.ann_tsi_amt tsi,b250.ann_prem_amt prem
			 			 FROM gipi_pack_polbasic b250
					    WHERE b250.line_cd     = p_line_cd
						  AND b250.subline_cd  = p_subline_cd
						  AND b250.iss_cd      = p_iss_cd
						  AND b250.issue_yy    = p_issue_yy
						  AND b250.pol_seq_no  = p_pol_seq_no
						  AND b250.renew_no    = p_renew_no
						  AND b250.pol_flag   IN ('1','2','3') 
						  AND b250.eff_date    = (SELECT MAX(b2501.eff_date)
												    FROM gipi_pack_polbasic b2501
												   WHERE b2501.line_cd     = p_line_cd
 													 AND b2501.subline_cd  = p_subline_cd
													 AND b2501.iss_cd      = p_iss_cd
													 AND b2501.issue_yy    = p_issue_yy
													 AND b2501.pol_seq_no  = p_pol_seq_no
													 AND b2501.renew_no    = p_renew_no
													 AND b2501.pol_flag   IN ('1','2','3'))
					    ORDER BY b250.last_upd_date DESC)
		    LOOP
			    v_ann_tsi_amt   := A1.tsi;
			    v_ann_prem_amt  := A1.prem;
		    END LOOP;        
		ELSE
		    v_incept_date := TRUNC(SYSDATE) + (NVL(v_subline_time,0)/86400);
		    v_expiry_date := ADD_MONTHS(v_incept_date,12);
		    v_pol_seq_no  := NULL;
		    v_issue_yy    := TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2));
		END IF;
		   
		FOR c IN (SELECT param_value_n
					FROM giac_parameters
				   WHERE param_name = 'PROD_TAKE_UP')
		LOOP
		    v_vdate := c.param_value_n;
		END LOOP;						
  
		IF v_vdate > 3 THEN
		    message := 'The parameter value ('||TO_CHAR(v_vdate)||') 	for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.';
		    RETURN;
		END IF;
			
		IF v_vdate = 1 OR (v_vdate = 3 AND SYSDATE > v_incept_date) THEN
		    FOR c IN (SELECT booking_year,
			 				 TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'),
							 booking_mth
					    FROM giis_booking_month
					   WHERE (NVL(booked_tag, 'N') != 'Y')
 						 AND (booking_year > TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
						  OR (booking_year = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
						 AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM')) >= TO_NUMBER(TO_CHAR(SYSDATE,'MM'))))
					   ORDER BY 1, 2 )
		    LOOP
			    v_booking_year := TO_NUMBER(c.booking_year);       
			    v_booking_mth  := c.booking_mth;       	   
		    END LOOP; 					
		ELSIF v_vdate = 2 OR (v_vdate = 3 AND SYSDATE <= v_incept_date) THEN
		    FOR C IN (SELECT booking_year, 
							 TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'), booking_mth
					    FROM giis_booking_month
					   WHERE (NVL(booked_tag, 'N') <> 'Y')
 						 AND (booking_year > TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
						  OR (booking_year = TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
						 AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'))>= TO_NUMBER(TO_CHAR(v_incept_date, 'MM'))))
					   ORDER BY 1, 2 ) 
		    LOOP
			    v_booking_year := to_number(c.booking_year);       
			    v_booking_mth  := c.booking_mth;       	   
		    END LOOP; 					
		END IF;
			
		INSERT INTO gipi_pack_wpolbas
					(pack_par_id,line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,endt_iss_cd,endt_yy,--8
					endt_seq_no,renew_no,endt_type,incept_date,expiry_date,booking_year,booking_mth,eff_date,--8
					issue_date,pol_flag,assd_no,designation,mortg_name,tsi_amt,prem_amt,ann_tsi_amt,ann_prem_amt,--9
					invoice_sw,pool_pol_no,user_id,quotation_printed_sw,covernote_printed_sw,address1,address2,address3,--8
					orig_policy_id,endt_expiry_date,no_of_items,subline_type_cd,auto_renew_flag,prorate_flag,--6
					short_rt_percent,prov_prem_tag,type_cd,acct_of_cd,prov_prem_pct,same_polno_sw,pack_pol_flag,--7
					prem_warr_tag,discount_sw,reg_policy_sw,co_insurance_sw,ref_open_pol_no,fleet_print_tag,--6
					incept_tag,expiry_tag,endt_expiry_tag,foreign_acc_sw,comp_sw,with_tariff_sw,--6
					place_cd,surcharge_sw,region_cd,industry_cd,cred_branch)--5
		     VALUES (p_copy_pol_id,v_line_cd,v_subline_cd,p_par_iss_cd,v_issue_yy,v_pol_seq_no,v_endt_iss_cd,v_endt_yy,--8
			        v_endt_seq_no,00,v_endt_type,v_incept_date,v_expiry_date,v_booking_year,v_booking_mth,v_incept_date,--8
					SYSDATE,'1',v_assd_no,v_designation,v_mortg_name,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,--9
					v_invoice_sw,v_pool_pol_no,p_user_id,'N','N',v_address1,v_address2,v_address3,--8
					v_orig_policy_id,v_endt_expiry_date,v_no_of_items,v_subline_type_cd,v_auto_renew_flag,v_prorate_flag,--6
					v_short_rt_percent,v_prov_prem_tag,v_type_cd,v_acct_of_cd,v_prov_prem_pct,'N',v_pack_pol_flag,--7
					v_prem_warr_tag,v_discount_sw,v_reg_policy_sw,v_co_insurance_sw,v_ref_open_pol_no,v_fleet_print_tag,--6
					v_incept_tag,v_expiry_tag,v_endt_expiry_tag,v_foreign_acc_sw,NVL(v_comp_sw,'N'),v_with_tariff_sw,--6
					v_place_cd,v_surcharge_sw,v_region_cd,v_industry_cd,v_cred_branch);--5
					
					message := 'SUCCESS';
	END copy_pack_polbasic_giuts008a;

    /*
    **  Created by   :  Andrew Robes
    **  Date Created :  12.11.2012
    **  Reference By : (GIPIS090 - Print policy documents) 
    **  Description  :  Check if package policy has MC par 
    */ 
    FUNCTION check_if_with_mc (
        p_pack_par_id       gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN VARCHAR2
    IS
      v_with_mc VARCHAR2(1) := 'N';      
    BEGIN
      FOR x IN (SELECT 1
              FROM gipi_polbasic a
                  ,gipi_pack_polbasic b
             WHERE a.pack_policy_id = b.pack_policy_id
               AND b.pack_par_id = p_pack_par_id
               AND a.line_cd = 'MC')
      LOOP  	
        v_with_mc := 'Y';
      END LOOP;
      RETURN v_with_mc;
    END check_if_with_mc;
END GIPI_PACK_POLBASIC_PKG;
/

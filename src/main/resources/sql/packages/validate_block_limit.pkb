CREATE OR REPLACE PACKAGE BODY CPI.Validate_Block_Limit
/* Created by: Rose
** Created on: August 07, 2009
** This package will check the distribution if it exceeds the
** the block limit and it will also check the override.
*/
/*
** Modified by: Jhing 
** Modified on: 05/23/2012 
** Modification: Please refer to SR # QA - 9363 for complete details:
            Brief notes on changes: 
                  1. replaced checking for menu_line_cd of 'SU' to checking of menu_line_cd 'FI' for block limit validation since this validation should be 
                    triggered for FIRE blocks and not on bonds
                 2. modified the fields being used to validate tsi amount for total by par to address issue with triggering of validation when there is 
                    still remaining retention (net retention is not equal to 100% for PAR )
                 3. considered currency rate in validation 
                 4. disregarded spoiled, cancelled and expired policies in comparing tsi against retention/treaty limit
                 5. only considered dist_flag of 2 and 3 for comparing tsi againt retention/treaty limit     
                 6. modify query in retrieving fire items. Distinct is used to ensure checking is done per block and not per item to remove duplicate validation since 
                    amounts are compared using sum which is grouped/determined by block_id      
                 7. modified code in retrieving block details which exceeds limit. If only one block is retrieved, block description will 
                    be returned for v_block (province- city -district  desc - block desc ), otherwise VARIOUS will be returned to v_block       
*/
AS
PROCEDURE limit_validation(p_par_id            GIPI_PARLIST.par_id%TYPE,
                           p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
						   v_block             OUT VARCHAR2,
						   v_type_exceed       OUT VARCHAR2,
						   v_share_type        GIIS_DIST_SHARE.share_type%TYPE,
						   v_Eff_Date          GIUW_POL_DIST.eff_date%TYPE,
		                   v_dist_spct         GIUW_WPOLICYDS_DTL.dist_spct%TYPE)
IS
v_menu_line_cd 	GIIS_LINE.menu_line_cd%TYPE:='&$';
v_retn_lim_amt 	GIIS_BLOCK.retn_lim_amt%TYPE;
v_trty_lim_amt 	GIIS_BLOCK.trty_lim_amt%TYPE;
v_block_id 	    GIIS_BLOCK.block_id%TYPE;
tot_by_type    	NUMBER;
tot_by_policy  	NUMBER;
tot_by_par      NUMBER;
v_totals       	NUMBER;
v_items         NUMBER;
v_rates		    NUMBER;
v_count         NUMBER := 0 ; -- jhing 05.23.2012 
BEGIN
  SELECT NVL(menu_line_cd,'&$')
    INTO v_menu_line_cd
    FROM GIIS_LINE
    --WHERE line_cd = :b240.line_cd;
	WHERE line_cd = p_line_cd;
	IF p_line_cd  = Giisp.v('LINE_CODE_FI') OR v_menu_line_cd = 'FI' /* 'jhing 05.06.2012  'SU' replaced with 'FI'*/  THEN
			FOR x IN (SELECT  DISTINCT b.retn_lim_amt, b.trty_lim_amt, a.block_id, /* a.item_no,  -- jhing 05.23.2012 added DISTINCT and commented out a.item_no */ 
			                 b.province||' - '||b.city||' - '||b.district_desc||' - '||b.block_desc BLOCK
                       FROM GIPI_WFIREITM a, GIIS_BLOCK b
					   WHERE a.block_id = b.block_id
					 --AND a.par_id 	= :b240.par_id
                       AND a.par_id = p_par_id)
            LOOP
				v_retn_lim_amt := x.retn_lim_amt;
				v_trty_lim_amt := x.trty_lim_amt;
				v_block_id := x.block_id;
				-- v_block    := x.BLOCK;  -- jhing 05.23.2012 commented out                 
			IF v_retn_lim_amt IS NOT NULL OR v_trty_lim_amt IS NOT NULL THEN
					-------------checking of share_type-------
--rose 08132009 transfer dis part in forms in order to display 2 alerts if both retention and treaty was exceeded
			/*FOR chk_type IN (SELECT d.share_type, SUM(ROUND(dist_spct, 14)) dist_spct, a.eff_date
			                 FROM GIUW_POL_DIST a,GIUW_WPOLICYDS b,GIUW_WPOLICYDS_DTL c, GIIS_DIST_SHARE d
					 WHERE a.dist_no   = b.dist_no
					 AND a.dist_no     = c.dist_no
					 AND b.dist_seq_no = c.dist_seq_no
					 AND c.line_cd 	   = d.line_cd
					 AND c.share_cd    = d.share_cd*/
 				    /*AND a.par_id     = :b240.par_id
                     AND a.dist_no 	   = :C080.dist_no
                     AND b.dist_seq_no = :C1306.dist_seq_no*/
                     /*AND a.par_id 	   = p_par_id
					 AND a.dist_no 	   = p_dist_no
                     AND b.dist_seq_no = p_dist_seq_no
					 GROUP BY d.share_type, a.eff_date)
			LOOP		*/
			-----------totals of TSI by different items----------------
		    --A.R.C. 08.15.2006
			-- to correct the computation of amount with foreign currency
			--SELECT SUM(tsi_amt)
			SELECT /* SUM(tsi_amt*currency_rt) -- jhing 06.05.2012 replaced with : */ SUM(c.dist_tsi * NVL(a.currency_rt, 1)) /*jhing 06.05.2012*/
			       INTO tot_by_type
			       FROM GIPI_WITEM a, GIPI_WFIREITM b 
                   /*jhing *05.06.2012  added tables*/ , GIUW_WITEMDS_DTL c  , GIUW_POL_DIST d,  GIIS_DIST_SHARE e /* end jhing 05.06.2012 */
			       --WHERE a.par_id 	= :b240.par_id
                   WHERE a.par_id 	= p_par_id
			       AND a.par_id 	= b.par_id
			       AND a.item_no 	= b.item_no
                   AND b.block_id   = v_block_id
                   /*jhing 05.06.2012 added conditions*/
                   AND a.par_id     = d.par_id
                   AND a.item_no 	= c.item_no  
                   AND c.line_cd 	= e.line_cd      		                    
                   AND d.dist_no 	= c.dist_no
                   AND c.share_cd 	= e.share_cd                    		       
			       AND e.share_type = v_share_type ;
                   /* jhing 05.06.2012 end of added conditions*/ 
		             
			 -----------totals of selected policies----------------
			 --issa@fpac12.06.2006; changed SUM(polbsc.tsi_amt) to SUM(itmdtl.dist_tsi)
			 --to get correct amounts for comparison since amts shld be based on dist_tsi (like in block accumulation)
			 SELECT SUM(itmdtl.dist_tsi * NVL (gpitem.currency_rt, 1 ) /* jhing 05.06.2012 added currency_rt */)--SUM(polbsc.tsi_amt)
				INTO tot_by_policy
				FROM GIPI_POLBASIC polbsc, GIUW_POL_DIST poldist,
				     GIPI_ITEM gpitem, GIPI_FIREITEM gpfitm, GIUW_ITEMDS_DTL itmdtl, GIIS_DIST_SHARE distshare
				WHERE polbsc.policy_id 			= poldist.policy_id
				AND polbsc.policy_id 			= gpitem.policy_id
				AND gpitem.policy_id 			= gpfitm.policy_id
				AND gpitem.item_no 				= gpfitm.item_no
				AND poldist.dist_no				= itmdtl.dist_no
				AND gpitem.item_no 				= itmdtl.item_no
			    AND itmdtl.line_cd 				= distshare.line_cd
				AND itmdtl.share_cd 			= distshare.share_cd
				AND distshare.share_type        = v_share_type
				AND gpfitm.block_id 			= v_block_id
				AND TRUNC(polbsc.eff_date) 	 <= TRUNC(v_Eff_Date)
				AND TRUNC(polbsc.expiry_date) >= TRUNC(v_Eff_Date)
                /*  jhing 05.06.2012 added condition */
                AND polbsc.pol_flag NOT IN ('4','5','X')
                AND poldist.dist_flag IN( '2', '3')
                /* end jhing 05.06.2012 added condition */ ;
			-----------totals of selected pars----------------
		        SELECT /* SUM(wpolbs.tsi_amt) -- jhing 05.06.2012 replaced with: */ SUM(witmdtl.dist_tsi * NVL(gpwitm.currency_rt, 1)) 
			       INTO tot_by_par
			       FROM GIPI_WPOLBAS wpolbs, GIUW_POL_DIST poldist, GIPI_WITEM gpwitm, GIPI_WFIREITM gpwfitm,
				        GIUW_WITEMDS_DTL witmdtl, GIIS_DIST_SHARE distshare 
			       WHERE wpolbs.par_id 	= poldist.par_id
			       AND wpolbs.par_id 	= gpwitm.par_id
			       AND gpwitm.par_id 	= gpwfitm.par_id
			       AND gpwitm.item_no 	= gpwfitm.item_no
			       AND poldist.dist_no 	= witmdtl.dist_no
			       AND gpwitm.item_no 	= witmdtl.item_no
			       AND witmdtl.line_cd 	= distshare.line_cd
			       AND witmdtl.share_cd 	= distshare.share_cd
			       AND distshare.share_type = v_share_type
			       AND gpwfitm.block_id 	= v_block_id			      
                   AND wpolbs.par_id             <> p_par_id
			       AND TRUNC(wpolbs.eff_date)    <= TRUNC(v_eff_date)
			       AND TRUNC(wpolbs.expiry_date) >= TRUNC(v_eff_date);

		-- v_totals := (NVL(tot_by_type,0) + NVL(tot_by_policy,0) + NVL(tot_by_par,0)) * (v_dist_spct/100); -- jhing commented out and replaced with :
        v_totals := (NVL(tot_by_type,0) + NVL(tot_by_policy,0) + NVL(tot_by_par,0)) ;  -- jhing 05.06.2012 modified statement
		IF v_share_type = 1 THEN
		 IF v_retn_lim_amt < ROUND(v_totals,2) AND v_retn_lim_amt IS NOT NULL THEN
               v_type_exceed := 'NET';
               -- jhing 05.23.2012 
               v_count := v_count + 1;
               IF v_count = 1  THEN 
                  v_block := x.block  ; 
               ELSE 
                  v_block := 'VARIOUS';  
               END IF;
               -- end hing 05.23.2012
		 END IF;
	    ELSIF v_share_type = 2 THEN
		 IF v_trty_lim_amt < ROUND(v_totals,2) AND v_trty_lim_amt IS NOT NULL THEN
	           v_type_exceed := 'TREATY';
               -- jhing 05.23.2012 
               v_count := v_count + 1;  
               IF v_count = 1  THEN 
                  v_block := x.block  ; 
               ELSE 
                  v_block := 'VARIOUS';  
               END IF;
               -- end jhing 05.23.2012
		 END IF;
	    END IF;
	--END LOOP;
	END IF;
	END LOOP;
	END IF;
END;

FUNCTION check_override_function(p_part     VARCHAR2,
                                 p_module   VARCHAR2,
								 p_function VARCHAR2,
								 p_user     VARCHAR2)
RETURN VARCHAR2

AS
  v_param_value GIIS_PARAMETERS.param_value_v%TYPE := 'N';
  v_exist	VARCHAR2(1) := 'N';

BEGIN

  IF p_part = 'PARAMETER' THEN
  FOR param_val IN (SELECT param_value_v
 	 	              FROM GIIS_PARAMETERS
                     WHERE param_name LIKE 'OVERRIDE_EXCEED_BLOCK_LIMIT')
  LOOP
    v_param_value := NVL(param_val.param_value_v,'N');
  END LOOP;
  RETURN (v_param_value);

  ELSIF p_part = 'USER' THEN
  FOR chk_limit IN (SELECT '1'
                      FROM GIAC_USER_FUNCTIONS a, GIAC_MODULES b , GIAC_FUNCTIONS c
                     WHERE a.module_id = b.module_id
                       AND a.module_id = c.module_id
		               AND a.function_code = c.function_code
   		               AND module_name = p_module
   		               AND valid_tag = 'Y'
   		               AND a.function_code = p_function
   		               AND a.user_id = p_user
   		               AND validity_dt < SYSDATE
   		               AND NVL(termination_dt, SYSDATE) >= SYSDATE
   		               AND ROWNUM = 1)
  LOOP
    v_exist := 'Y';
  END LOOP;
  RETURN (v_exist);
  END IF;

END;

END;
/



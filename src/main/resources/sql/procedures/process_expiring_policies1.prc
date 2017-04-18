CREATE OR REPLACE PROCEDURE CPI.Process_Expiring_Policies1
  (p_intm_no              GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
   p_fr_date              DATE,
   p_to_date              DATE,
   inc_special_sw         VARCHAR2 DEFAULT 'N',
   p_line_cd              GIPI_POLBASIC.line_cd%TYPE,
   p_subline_cd           GIPI_POLBASIC.subline_cd%TYPE,
   p_iss_cd               GIPI_POLBASIC.iss_cd%TYPE,
   p_issue_yy             GIPI_POLBASIC.issue_yy%TYPE,
   p_pol_seq_no           GIPI_POLBASIC.pol_seq_no%TYPE,
   p_renew_no             GIPI_POLBASIC.renew_no%TYPE,
   p_def_is_pol_summ_sw   GIIS_PARAMETERS.param_value_v%TYPE,
   p_def_same_polno_sw    GIIS_PARAMETERS.param_value_v%TYPE,
   p_plate_no             GIPI_VEHICLE.plate_no%TYPE,
   p_user_id              giis_users.user_id%TYPE,
   p_cred_branch          gipi_polbasic.cred_branch%TYPE, --benjo 11.12.2015 UW-SPECS-2015-087
   t_policy_id         IN OUT DBMS_SQL.NUMBER_TABLE,
   t_line_cd           IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_subline_cd        IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_iss_cd            IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_issue_yy          IN OUT DBMS_SQL.NUMBER_TABLE,
   t_pol_seq_no        IN OUT DBMS_SQL.NUMBER_TABLE,
   t_renew_no          IN OUT DBMS_SQL.NUMBER_TABLE,
   t_expiry_date       IN OUT DBMS_SQL.DATE_TABLE,
   t_incept_date       IN OUT DBMS_SQL.DATE_TABLE,
   t_assd_no           IN OUT DBMS_SQL.NUMBER_TABLE,
   t_auto_sw           IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_intm_no           IN OUT DBMS_SQL.NUMBER_TABLE)
IS
    /*JOANNE consolidate all changes in process_expiring policies, 112813*/
    v_parlist_remarks        gipi_parlist.remarks%TYPE := NULL;  --jongs 08302013
    v_concat_remarks         gipi_parlist.remarks%TYPE := NULL;  --jongs 08302013
    v_char_left              NUMBER:=4000;

  v_a8_ren_prem_amt        GIPI_POLBASIC.ann_prem_amt%TYPE;
  v_currency_prem_amt      GIEX_EXPIRY.currency_prem_amt%TYPE;
  v_currency_tax_amt       GIEX_EXPIRY.currency_prem_amt%TYPE;
  o_currency_prem_amt2     GIEX_EXPIRY.currency_prem_amt%TYPE;
  v_total_currency_prm     GIEX_EXPIRY.currency_prem_amt%TYPE;
  v_currency_prm_ogrp      GIEX_EXPIRY.currency_prem_amt%TYPE;

  cnt_ext          NUMBER:=0;
  counter          NUMBER:=1;
  cntr             NUMBER:=1;
  cnt              NUMBER:=1;
  v_count          NUMBER:=0;
  v_peril_cnt      NUMBER:=0;
  v_skip           VARCHAR2(1):=NULL;
  v_policy_no      VARCHAR2(100);     --variable to keep the record being processed
  v_policy_ids     VARCHAR2(32000);   --variable to keep the policy_ids
  v_expiry_sw    VARCHAR2(1):='N';  --to identify if the policy already exists in giex_expiry.
  v_clm          VARCHAR2(1);
  v_bal          VARCHAR2(1);
  v_sw         VARCHAR2(1):='N';
  v_intm_sw        VARCHAR2(1):='N';
  various          VARCHAR2(100);
  TO_DATE          DATE;
  fr_date          DATE;
  t_peril_cds      DBMS_SQL.NUMBER_TABLE;
  t_item_nos       DBMS_SQL.NUMBER_TABLE;
  v_line_cd        GIPI_POLBASIC.line_cd%TYPE;
  v_subline_cd     GIPI_POLBASIC.subline_cd%TYPE;
  v_iss_cd         GIPI_POLBASIC.iss_cd%TYPE;
  v_issue_yy       GIPI_POLBASIC.issue_yy%TYPE;
  v_pol_seq_no     GIPI_POLBASIC.pol_seq_no%TYPE;
  v_renew_no       GIPI_POLBASIC.renew_no%TYPE;
  v_back_stat      GIPI_POLBASIC.back_stat%TYPE;
  v_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE;
  pv_endt_seq_no   GIPI_POLBASIC.endt_seq_no%TYPE;
  v_expiry_date    GIPI_POLBASIC.expiry_date%TYPE;
  v_incept_date    GIPI_POLBASIC.incept_date%TYPE;
  v_eff_date       GIPI_POLBASIC.eff_date%TYPE;
  v_assd_no        GIPI_POLBASIC.assd_no%TYPE;
  v_ext_date     GIPI_POLBASIC.expiry_date%TYPE  := SYSDATE;
  v_tsi           GIPI_POLBASIC.tsi_amt%TYPE;
  v_prem          GIPI_POLBASIC.prem_amt%TYPE;
  v_ann_prem       GIPI_POLBASIC.ann_prem_amt%TYPE;
  v_pol_id       GIPI_POLBASIC.policy_id%TYPE;
  v_exp_date     GIPI_POLBASIC.expiry_date%TYPE;
  v_inc_date     GIPI_POLBASIC.incept_date%TYPE;
  v_spld_flag      GIPI_POLBASIC.spld_flag%TYPE;
  v_expiry_tag    GIPI_POLBASIC.expiry_tag%TYPE;
  v_policy_id      GIPI_POLBASIC.policy_id%TYPE;
  v_intm_no        GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
  v_auto_sw        GIEX_EXPIRY.auto_sw%TYPE:='Y';
  v_ren_flag      GIEX_EXPIRY.renew_flag%TYPE;
  v_summ_sw       GIEX_EXPIRY.summary_sw%TYPE;
  v_same_sw     GIEX_EXPIRY.same_polno_sw%TYPE;
  v_reg_pol_sw     GIEX_EXPIRY.reg_policy_sw%TYPE;
  v_renewal_id    GIEX_EXPIRY.renewal_id%TYPE;
  v_tax           GIEX_EXPIRY.tax_amt%TYPE;
  v_pol_tax       GIEX_EXPIRY.tax_amt%TYPE;
  v_car_company    GIEX_EXPIRY.car_company%TYPE;
  v_rate          GIPI_ITEM.currency_rt%TYPE;
  v_item_title     GIPI_ITEM.item_title%TYPE;
  v_color          GIPI_VEHICLE.color%TYPE;
  v_motor_no       GIPI_VEHICLE.motor_no%TYPE;
  v_model_year     GIPI_VEHICLE.model_year%TYPE;
  v_make           GIPI_VEHICLE.make%TYPE;
  v_serial_no      GIPI_VEHICLE.serial_no%TYPE;
  v_plate_no       GIPI_VEHICLE.plate_no%TYPE;
  v_item_no        GIPI_VEHICLE.item_no%TYPE;
  v_line_mc        GIIS_LINE.line_cd%TYPE;
  v_line_fi        GIIS_LINE.line_cd%TYPE;
  v_loc_risk1      GIPI_FIREITEM.loc_risk1%TYPE;
  v_loc_risk2      GIPI_FIREITEM.loc_risk2%TYPE;
  v_loc_risk3      GIPI_FIREITEM.loc_risk3%TYPE;
  o_line_cd       GIEX_EXPIRY.line_cd%TYPE;
  o_peril_cd      GIEX_OLD_GROUP_PERIL.peril_cd%TYPE;
  o_prem_amt2      GIEX_OLD_GROUP_PERIL.prem_amt%TYPE;
  o_ren_prem_amt2  GIEX_OLD_GROUP_PERIL.prem_amt%TYPE;
  o_tsi_amt2       GIEX_OLD_GROUP_PERIL.tsi_amt%TYPE;
  o_ren_tsi_amt2   GIEX_OLD_GROUP_PERIL.tsi_amt%TYPE;
  v_orig_tsi_exp   GIEX_EXPIRY.tsi_amt%TYPE;
  v_orig_tsi_item  GIEX_EXPIRY.tsi_amt%TYPE;
  v_orig_tsi_ngrp  GIEX_EXPIRY.tsi_amt%TYPE;
  v_orig_tsi_ogrp  GIEX_EXPIRY.tsi_amt%TYPE;
  v_ren_tsi_ogrp   GIEX_EXPIRY.ren_tsi_amt%TYPE;
  v_orig_prm_ogrp  GIEX_EXPIRY.prem_amt%TYPE;
  v_ren_prm_ogrp   GIEX_EXPIRY.ren_prem_amt%TYPE;
  v_auto_dep    giis_parameters.param_value_v%TYPE
         := NVL (Giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N') ; --VARCHAR2(2);/*commented by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure*/
  v_dep_pct     giis_parameters.param_value_v%TYPE
         := NVL (Giisp.n ('MC_DEP_PCT'), 0) ; --NUMBER;/*commented by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure*/
  v_total_dep_tsi  GIEX_EXPIRY.tsi_amt%TYPE := 0;
  v_total_ren_tsi  GIEX_EXPIRY.ren_tsi_amt%TYPE := 0;
  v_total_dep_prm  GIEX_EXPIRY.prem_amt%TYPE:= 0;
  v_total_ren_prm  GIEX_EXPIRY.ren_prem_amt%TYPE:= 0;
  v_dep_tax_amt    GIPI_INV_TAX.tax_amt%TYPE:= 0;
  v_extraction    VARCHAR2(1);
  v_ctr            NUMBER;
  v_risk_no        GIEX_EXPIRY.risk_no%TYPE;
  v_risk_item_no   GIEX_EXPIRY.risk_item_no%TYPE;
  v_motor_coverage GIEX_EXPIRY.motor_coverage%TYPE;

  v_doc_stamps GIAC_PARAMETERS.PARAM_VALUE_N%TYPE := Giacp.N('DOC_STAMPS');
  v_param_doc  GIIS_PARAMETERS.PARAM_VALUE_V%TYPE := Giisp.V('COMPUTE_OLD_DOC_STAMPS');
    v_param_pa_doc  GIIS_PARAMETERS.PARAM_VALUE_V%TYPE := Giisp.V('COMPUTE_PA_DOC_STAMPS');       -- 7/14/2010: 2010-00090
  v_acct_iss_cd      GIIS_ISSOURCE.acct_iss_cd%TYPE:=NULL;
  v_ref_no           NUMBER;
  v_mod_no           NUMBER;
  v_ref             GIEX_EXPIRY.bank_Ref_no%TYPE:=NULL; --ppmk

/*JOANNE consolidate all changes in process_expiring policies, 112813*/
   v_total_renewal_tsi      giex_expiry.ren_tsi_amt%TYPE; -- jhing 07.20.2013
   v_total_renewal_prem     giex_expiry.ren_prem_amt%TYPE;
   v_total_orig_tsi         giex_expiry.tsi_amt%TYPE;     -- jhing 07.20.2013
   v_total_orig_prem        giex_expiry.prem_amt%TYPE;    -- jhing 07.20.2013
   v_total_currency_tsi1    giex_expiry.tsi_amt%TYPE;     -- jhing 07.20.2013
   v_total_currency_prem1   giex_expiry.prem_amt%TYPE;    -- jhing 07.20.2013
   v_cnt_itmperl            NUMBER := 0; --jongs 10.08.2013
   v_cnt_expiry             NUMBER := 0;
   v_cnt_deducs             NUMBER := 0;

   v_policy_orig_tsi        giex_expiry.orig_tsi_amt%TYPE; --joanne 05292014
BEGIN
  -- rollie 31mar2006
  -- to verify how extraction will be done ( policy/date )
  IF p_line_cd IS NULL OR p_subline_cd IS NULL OR p_iss_cd IS NULL OR
     p_issue_yy IS NULL OR  p_pol_seq_no IS NULL OR p_renew_no IS NULL THEN
  v_extraction := 'D';
  ELSE
  v_extraction := 'P';
  END IF;

  --v_auto_dep := Giisp.v('AUTO_COMPUTE_MC_DEP');/*commented by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure*/
  --v_dep_pct  := Giisp.n('MC_DEP_PCT');/*commented by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure*/

  DBMS_OUTPUT.PUT_LINE('START PROCEDURE : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));

  FOR a1 IN (
		SELECT A.line_cd, A.subline_cd, A.iss_cd, A.issue_yy, A.pol_seq_no,
			   A.renew_no, A.endt_seq_no,
				A.line_cd||A.subline_cd||A.iss_cd||A.issue_yy||A.pol_seq_no||A.renew_no
				policy_no, A.policy_id, A.eff_date eff_date, TRUNC(A.expiry_date)
				expiry_date, A.assd_no, A.incept_date, NVL(A.spld_flag,'1')
				spld_flag, A.expiry_tag, A.back_stat, A.reg_policy_sw
		  FROM GIPI_POLBASIC A,
			   GIIS_SUBLINE b, GIIS_LINE c
		 WHERE 1=1
				/*AND EXISTS (SELECT 1
						   FROM GIPI_VEHICLE gpv
					WHERE 1 = 1
				   AND A.policy_id = gpv.policy_id
				   AND gpv.plate_no LIKE '%'||p_plate_no
				 UNION ALL
				 SELECT 1
				   FROM dual
				  WHERE 1 = decode(p_plate_no, NULL, 1, 2)
				   )*/ --commented by gmi (optimize purpose) --
	   		AND EXISTS (SELECT 1
				          FROM GIPI_VEHICLE gpv
					     WHERE 1 = 1
				           AND A.policy_id = gpv.policy_id
				           AND gpv.plate_no LIKE '%'||p_plate_no
						 UNION ALL
						 SELECT 1
						   FROM dual
						  WHERE 1 = DECODE(p_plate_no, NULL, 1, 2))
			AND A.line_cd    = b.line_cd
		    AND A.subline_cd = b.subline_cd
			AND a.line_cd = c.line_cd --added by vercel 08.04.2008
		    AND b.op_flag    = 'N'
		 	AND (NVL(b.non_renewal_tag, 'N') <> 'Y' AND NVL(c.non_renewal_tag, 'N') <> 'Y')--added by vercel 08.04.2008
		    AND A.pol_flag IN ('1','2','3')
		    AND A.iss_cd NOT IN ('RI','BB')
		    AND NVL(A.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(A.reg_policy_sw,'Y'))
		    AND A.line_cd LIKE p_line_cd||'%'
		    --AND A.subline_cd LIKE p_subline_cd||'%' --benjo 11.24.2015 comment out
            AND A.subline_cd = NVL(p_subline_cd, A.subline_cd) --benjo 11.24.2015 GENQA-SR-5009
		    AND A.iss_cd LIKE p_iss_cd||'%'
            AND A.cred_branch LIKE p_cred_branch||'%' --benjo 11.12.2015 UW-SPECS-2015-087
			AND A.issue_yy = DECODE(v_extraction,'P',p_issue_yy,A.issue_yy)
			AND A.pol_seq_no = DECODE(v_extraction,'P',p_pol_seq_no,A.pol_seq_no)
			AND A.renew_no = DECODE(v_extraction,'P',p_renew_no,A.renew_no)
		   	/*added by Iris Bordey 04.21.2003
			**To check for policies already renewed(using manual renew).*/
			AND NOT EXISTS (SELECT '1'
			 				  FROM GIPI_POLBASIC X,
								   GIPI_POLNREP  y
						     WHERE 1=1
						   	   AND X.policy_id  = y.old_policy_id
						       AND X.line_cd    = A.line_cd
						       AND X.subline_cd = A.subline_cd
						       AND X.iss_cd     = A.iss_cd
						       AND X.issue_yy   = A.issue_yy
						       AND X.pol_seq_no = A.pol_seq_no
						       AND X.renew_no   = A.renew_no)
	        AND NOT EXISTS (SELECT '1'
							  FROM GIPI_POLBASIC X,
								   GIPI_WPOLNREP  y
						     WHERE 1=1
						       AND X.policy_id  = y.old_policy_id
						   	   AND X.line_cd    = A.line_cd
						       AND X.subline_cd = A.subline_cd
						   	   AND X.iss_cd     = A.iss_cd
						       AND X.issue_yy   = A.issue_yy
						       AND X.pol_seq_no = A.pol_seq_no
						       AND X.renew_no   = A.renew_no)
		   /* by: julie
		   ** check whether a policy already exists
			  in giex_expiry. a script similar to this was found at the latter part of this procedure
			  but removed for optimizaiton purposes.
		   */
		   AND NOT EXISTS (SELECT '1'
						  FROM GIEX_EXPIRY C
					  WHERE A.policy_id = C.policy_id)
		   AND Check_User_Per_Iss_Cd1(A.line_cd, A.iss_cd, p_user_id, 'GIEXS001') = 1
		   AND A.pack_policy_id IS NULL --A.R.C. 05.07.2007
		   AND ( A.endt_seq_no = 0 OR
		  		(A.endt_seq_no > 0 AND
			  		TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
	   UNION
		SELECT 'XX','XX','XX',0,0,0,0,'XX',0,SYSDATE,SYSDATE,0 , SYSDATE , '1', 'N',0 ,'Y' FROM dual  -- FOR THE LAST RECORD
	   ORDER BY 1,2,3,4,5,6,10 DESC, 7 DESC,11,12,9)
  LOOP
   -- records to be fetched will be accumulated then processed when a new policy is encountered
   -- still processing the same policy or first record
    IF v_policy_no IS NULL OR v_policy_no = a1.policy_no THEN
       IF a1.endt_seq_no = 0 THEN
          v_endt_seq_no := a1.endt_seq_no;
          v_policy_id   := a1.policy_id;
       END IF;
       IF v_policy_no IS NULL THEN
          v_policy_ids  := a1.policy_id;
       ELSE
          v_policy_ids  := v_policy_ids ||','||a1.policy_id;
       END IF;
       v_line_cd    := a1.line_cd;
       v_subline_cd := a1.subline_cd;
       v_iss_cd  := a1.iss_cd;
       v_issue_yy   := a1.issue_yy;
       v_pol_seq_no := a1.pol_seq_no;
       v_renew_no   := a1.renew_no;
       v_back_stat  := a1.back_stat;
       v_reg_pol_sw := a1.reg_policy_sw;
       --this will assure that you will get the latest change
       IF v_eff_date IS NULL
       OR v_eff_date > a1.eff_date
    AND a1.endt_seq_no <> 0 THEN
       v_eff_date  := a1.eff_date;
       END IF;
       IF v_expiry_date IS NULL
       OR v_expiry_date <> a1.expiry_date
    AND a1.endt_seq_no <> 0 THEN
          v_expiry_date  := a1.expiry_date;
       END IF;
       IF v_incept_date IS NULL
       OR v_incept_date <> a1.incept_date
    AND a1.endt_seq_no <> 0 THEN
          v_incept_date  := a1.incept_date;
       END IF;
    IF v_assd_no IS NULL THEN
          v_assd_no := a1.assd_no;
       END IF;
       IF NVL(v_auto_sw,'Y') = 'Y' THEN
         IF a1.endt_seq_no <> 0 THEN
            v_auto_sw := 'N';
         END IF;
       END IF;
       v_policy_no := a1.policy_no;
       v_spld_flag := NVL(a1.spld_flag,'1');
       v_expiry_tag:= NVL(a1.expiry_tag,'N');
    --processing new policy already
    ELSIF v_policy_no != a1.policy_no THEN
       -- first process the previous policy
       -- original policy was already expired
       IF NVL(v_endt_seq_no,1) != 0 AND v_back_stat <> 2 THEN
          NULL;
       ELSE
          IF (TRUNC(v_expiry_date) >= TRUNC(p_fr_date) AND TRUNC(v_expiry_date) <= TRUNC(p_to_date))
       OR v_extraction = 'P' THEN
             v_intm_sw := 'N';
       /*include renewal of policies without endts*/
             -- expiry was done with a specific intm_no
             IF p_intm_no IS NOT NULL THEN
                v_intm_sw := 'Y';
                DECLARE
                  TYPE     cv_type IS REF CURSOR;
                  CV       cv_type;
                  retval   NUMBER :=0;
                BEGIN
      --the ff statement was untagged, to resolve ora-01722 encountered
                  OPEN CV FOR
                    'SELECT 1 FROM GIPI_COMM_INVOICE WHERE POLICY_ID IN ('||v_policy_ids||') AND INTRMDRY_INTM_NO = :INTM AND ROWNUM = 1 '
                    USING p_intm_no;
                  LOOP
                    FETCH CV INTO retval;
                    EXIT WHEN CV%FOUND;
     EXIT WHEN CV%NOTFOUND; --added by gmi: to handle infinite loop when no records found
                  END LOOP;
                  CLOSE CV;
                  IF retval = 1 THEN
                    v_intm_sw := 'N';
                  END IF;
                END;
             END IF;
             IF v_intm_sw     = 'N' AND
                v_endt_seq_no = 0 AND
                v_policy_id IS NOT NULL AND
             v_policy_no  != 'XX' AND
             v_spld_flag  <> '2'  AND
             v_expiry_tag  = 'N'  AND
             v_expiry_sw   = 'N'   THEN       --include policy in expiry checking
                -- added by rbd to get the correct expiry date and inception date if policy has backward endt
                counter:=counter + 1;
                FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date
                             FROM GIPI_POLBASIC b2501
                            WHERE b2501.line_cd    = v_line_cd
                              AND b2501.subline_cd = v_subline_cd
                              AND b2501.iss_cd     = v_iss_cd
                              AND b2501.issue_yy   = v_issue_yy
                              AND b2501.pol_seq_no = v_pol_seq_no
                              AND b2501.renew_no   = v_renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND NVL(b2501.back_stat,5) = 2
                              AND b2501.pack_policy_id IS NULL
							  AND ( b2501.endt_seq_no = 0
							        OR (b2501.endt_seq_no > 0
									    AND TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date)))
                            ORDER BY endt_seq_no DESC )
                LOOP
                  -- get the last endorsement sequence of the policy
                  FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date
                                FROM GIPI_POLBASIC b2501
                               WHERE b2501.line_cd    = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd     = v_iss_cd
                                 AND b2501.issue_yy   = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no   = v_renew_no
                                 AND b2501.pol_flag   IN ('1','2','3')
                                 AND b2501.pack_policy_id IS NULL
								 AND ( b2501.endt_seq_no = 0
								 	  OR (b2501.endt_seq_no > 0
									  	  AND TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date)))
                               ORDER BY endt_seq_no DESC )
                  LOOP
                    IF z1.endt_seq_no = z1a.endt_seq_no THEN
                       v_expiry_date  := z1.expiry_date;
                       v_incept_date  := z1.incept_date;
                    ELSE
                       IF z1a.eff_date > v_eff_date THEN
                          v_expiry_date  := z1a.expiry_date;
                          v_incept_date  := z1a.incept_date;
                       ELSE
                          v_expiry_date  := z1.expiry_date;
                          v_incept_date  := z1.incept_date;
                       END IF;
                    END IF;
                    EXIT;
                  END LOOP;
                  EXIT;
                END LOOP;
                -- added by rbd to get the correct assured if policy has backward endt
                -- get the last endorsement sequence of the latest backward endt
                FOR z3 IN (SELECT endt_seq_no, assd_no
                             FROM GIPI_POLBASIC b2501
                            WHERE b2501.line_cd    = v_line_cd
                              AND b2501.subline_cd = v_subline_cd
                              AND b2501.iss_cd     = v_iss_cd
                              AND b2501.issue_yy   = v_issue_yy
                              AND b2501.pol_seq_no = v_pol_seq_no
                              AND b2501.renew_no   = v_renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND assd_no IS NOT NULL
                              AND NVL(b2501.back_stat,5) = 2
                              AND b2501.pack_policy_id IS NULL
							  AND ( b2501.endt_seq_no = 0
							        OR (b2501.endt_seq_no > 0
										AND TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date)))
                            ORDER BY endt_seq_no DESC )
                LOOP
                  -- get the last endorsement sequence of the policy
                  FOR z3a IN (SELECT endt_seq_no, eff_date, assd_no
                                FROM GIPI_POLBASIC b2501
                               WHERE b2501.line_cd    = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd     = v_iss_cd
                                 AND b2501.issue_yy   = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no   = v_renew_no
                                 AND b2501.pol_flag   IN ('1','2','3')
                                 AND assd_no IS NOT NULL
                                 AND b2501.pack_policy_id IS NULL --A.R.C. 05.07.2007
								 AND ( b2501.endt_seq_no = 0
								 	   OR (b2501.endt_seq_no > 0
									       AND TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date)))
                               ORDER BY endt_seq_no DESC )
                  LOOP
                    IF z3.endt_seq_no = z3a.endt_seq_no THEN
                       v_assd_no  := z3.assd_no;
                    ELSE
                       IF z3a.eff_date > v_eff_date THEN
                          v_assd_no  := z3a.assd_no;
                       ELSE
                          v_assd_no  := z3.assd_no;
                       END IF;
                    END IF;
                    EXIT;
                  END LOOP;
                  EXIT;
                END LOOP;
                v_count := v_count + 1;
                t_policy_id(v_count)  := v_policy_id;
                t_line_cd(v_count)    := v_line_cd;
                t_subline_cd(v_count) := v_subline_cd;
                t_iss_cd(v_count)    := v_iss_cd;
                t_issue_yy(v_count)   := v_issue_yy;
                t_pol_seq_no(v_count) := v_pol_seq_no;
                t_renew_no(v_count)   := v_renew_no;
                t_expiry_date(v_count):= v_expiry_date;
                t_incept_date(v_count):= v_incept_date;
                t_assd_no(v_count)    := v_assd_no;
                t_intm_no(v_count)    := v_intm_no;
                t_auto_sw(v_count)    := v_auto_sw;
             END IF;
          END IF;
       END IF;
       --second initialize the variables to be used
       v_line_cd    := NULL;
       v_subline_cd   := NULL;
       v_iss_cd    := NULL;
       v_issue_yy    := NULL;
       v_pol_seq_no   := NULL;
       v_renew_no    := NULL;
       v_expiry_date  := NULL;
       v_incept_date  := NULL;
       v_assd_no    := NULL;
       v_policy_ids   := NULL;
       v_policy_id    := NULL;
       v_endt_seq_no  := NULL;
       v_spld_flag    := NULL;
       v_expiry_tag   := NULL;
       v_reg_pol_sw   := NULL;
       v_auto_sw   := 'Y';
       v_expiry_sw   := 'N';
       v_eff_date     := NULL;

       --third insert data to the variables
       IF a1.endt_seq_no = 0 THEN
          v_endt_seq_no  := 0;
          v_policy_id  := a1.policy_id;
       END IF;

       IF a1.endt_seq_no <> 0 THEN
         v_auto_sw      := 'N';
       END IF;

       v_policy_ids  := a1.policy_id;
       v_line_cd    := a1.line_cd;
       v_subline_cd  := a1.subline_cd;
       v_iss_cd   := a1.iss_cd;
       v_issue_yy   := a1.issue_yy;
       v_pol_seq_no  := a1.pol_seq_no;
       v_renew_no   := a1.renew_no;
       v_expiry_date   := a1.expiry_date;
       v_incept_date   := a1.incept_date;
       v_assd_no   := a1.assd_no;
	   v_spld_flag   := NVL(a1.spld_flag,'1');
	   v_expiry_tag  := NVL(a1.expiry_tag,'N');
       v_policy_no  := a1.policy_no;
       v_reg_pol_sw  := a1.reg_policy_sw;
    END IF;
  END LOOP; --(end of first loop)

  v_line_mc := Giisp.v('LINE_CODE_MC');
  v_line_fi := Giisp.v('LINE_CODE_FI');

  IF t_policy_id.EXISTS(1) THEN
     FOR a1 IN t_policy_id.FIRST..t_policy_id.LAST
     LOOP
		  v_loc_risk1  := NULL;
		  v_loc_risk2  := NULL;
		  v_loc_risk3  := NULL;
		  v_item_title := NULL;
		  v_color      := NULL;
		  v_motor_no   := NULL;
		   v_model_year := NULL;
		   v_car_company:= NULL;
		   v_make       := NULL;
		   v_serial_no  := NULL;
		   v_plate_no   := NULL;
		   v_item_no    := NULL;
		   v_clm      := NULL;
		   v_bal      := NULL;
		   v_reg_pol_sw := NULL;
		   v_ren_flag   := '2';
		   v_pol_id     := t_policy_id(a1);
		   v_exp_date   := t_expiry_date(a1);
		   v_assd_no    := t_assd_no(a1);
		   v_intm_no    := t_intm_no(a1);
		   v_inc_date   := t_incept_date(a1);
		   v_auto_sw    := t_auto_sw(a1);

        /*JOANNE consolidate all changes in process_expiring policies, 112813*/
         /*** added by jongs 08302013 to insert remarks on giex_expiry ***/
         FOR z1 IN ( SELECT remarks
                      FROM gipi_parlist a, gipi_polbasic b
                     WHERE a.par_id = b.par_id
                       AND b.pack_policy_id IS NULL
                       AND b.line_cd = p_line_cd
                       AND b.subline_cd = p_subline_cd
                       AND b.iss_cd = p_iss_cd
                       AND b.issue_yy = p_issue_yy
                       AND b.pol_seq_no = p_pol_seq_no
                       AND b.renew_no = p_renew_no
                       AND b.pol_flag IN ('1', '2', '3')
                       AND (   b.endt_seq_no = 0 OR (b.endt_seq_no > 0 AND TRUNC(NVL(b.endt_expiry_date,b.expiry_date)) >= TRUNC (b.expiry_date)
                                                  )
                           )

                   )
         LOOP
           v_parlist_remarks := z1.remarks||chr(10);
           v_char_left := v_char_left - LENGTH(v_parlist_remarks);

           IF v_char_left >= 0 THEN
             v_concat_remarks  := v_concat_remarks||v_parlist_remarks;
           END IF;

         END LOOP;

         IF NVL(giisp.v('INSERT_POLREMARKS_REN'),'N') = 'N' THEN
           v_concat_remarks := NULL;
         END IF;
         /*** end jongs 08302013 ***/

		   /*added changes of udel - cherrie 12052012, to consolidate with the latest process_expiring_polices procedure */
		   /* Udel 08102012 added REF_POL_NO to insert into GIEX_EXPIRY */
		   FOR a2 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy,
							 pol_seq_no, renew_no,auto_renew_flag,
							 policy_id, reg_policy_sw, ref_pol_no, cred_branch
						FROM GIPI_POLBASIC
					   WHERE policy_id = v_pol_id
						 AND pack_policy_id IS NULL
			  )
		   LOOP
			 v_reg_pol_sw := a2.reg_policy_sw;
			 FOR a3 IN (SELECT '1'
						  FROM GICL_CLAIMS
						 WHERE line_cd     = a2.line_cd
						   AND subline_cd  = a2.subline_cd
						   AND pol_iss_cd  = a2.iss_cd
						   AND issue_yy    = a2.issue_yy
						   AND pol_seq_no  = a2.pol_seq_no
						   AND renew_no    = a2.renew_no
						   AND clm_stat_cd NOT IN ('CC','WD','DN'))
			 LOOP
			   v_clm := 'Y';
			   EXIT;
			 END LOOP;

			 v_tsi := 0;
			 v_orig_tsi_exp := 0;
			 v_prem := 0;

			 FOR a4 IN (SELECT NVL(prem_amt,0) prem, NVL(tsi_amt,0) tsi, NVL(ann_prem_amt,0) ann_prem
						  FROM GIPI_POLBASIC
						 WHERE line_cd     = a2.line_cd
						   AND subline_cd  = a2.subline_cd
						   AND iss_cd      = a2.iss_cd
						   AND issue_yy    = a2.issue_yy
						   AND pol_seq_no  = a2.pol_seq_no
						   AND renew_no    = a2.renew_no
						   AND pol_flag IN ('1','2','3')
						   AND pack_policy_id IS NULL
						   AND ( endt_seq_no = 0
								 OR ( endt_seq_no > 0
									  AND TRUNC(endt_expiry_date) >= TRUNC(expiry_date)))
						 ORDER BY endt_seq_no)
			 LOOP
			   v_orig_tsi_exp  := NVL(v_orig_tsi_exp,0)  + a4.tsi;
			   v_prem          := NVL(v_prem,0) + a4.prem;
			   v_ann_prem      := a4.ann_prem;
			 END LOOP;

			 FOR a5 IN (SELECT SUM(C.balance_amt_due) due
						  FROM GIPI_POLBASIC A, GIPI_INVOICE b, GIAC_AGING_SOA_DETAILS C
						 WHERE A.line_cd     = a2.line_cd
						   AND A.subline_cd  = a2.subline_cd
						   AND A.iss_cd      = a2.iss_cd
						   AND A.issue_yy    = a2.issue_yy
						   AND A.pol_seq_no  = a2.pol_seq_no
						   AND A.renew_no    = a2.renew_no
						   AND A.pol_flag IN ('1','2','3')
						   AND A.policy_id = b.policy_id
						   AND b.iss_cd = C.iss_cd
						   AND b.prem_seq_no = C.prem_seq_no
						   AND ( A.endt_seq_no = 0
								 OR ( A.endt_seq_no > 0
									  AND TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
						   AND A.pack_policy_id IS NULL)
			 LOOP
			   IF a5.due <> 0 THEN
				  v_bal := 'Y';
			   END IF;
			 END LOOP;

			 v_tax := 0;
			 v_pol_tax := 0;

			 FOR a6 IN(SELECT SUM(NVL(tax_amt,0)) tax,
							  item_grp, A.policy_id
						 FROM GIPI_POLBASIC A, GIPI_INVOICE b
						WHERE A.policy_id = b.policy_id
						  AND A.line_cd     = a2.line_cd
						  AND A.subline_cd  = a2.subline_cd
						  AND A.iss_cd      = a2.iss_cd
						  AND A.issue_yy    = a2.issue_yy
						  AND A.pol_seq_no  = a2.pol_seq_no
						  AND A.renew_no    = a2.renew_no
						  AND A.pol_flag IN ('1','2','3')
						  AND A.pack_policy_id IS NULL --A.R.C. 05.07.2007
						  AND ( A.endt_seq_no = 0
								OR ( A.endt_seq_no > 0
									 AND TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
						GROUP BY item_grp, A.policy_id)
			 LOOP
			   v_rate := 0;

			   FOR a7 IN (SELECT currency_rt
							FROM GIPI_ITEM
						   WHERE item_grp = a6.item_grp
							 AND policy_id = a6.policy_id)
			   LOOP
				 v_rate   := a7.currency_rt;
				 EXIT;
			   END LOOP;

			   v_tax := v_tax + (a6.tax * v_rate);

			   IF a2.policy_id = a6.policy_id THEN
				  v_pol_tax := v_pol_tax + (a6.tax * v_rate);
			   END IF;
			 END LOOP;

			 IF v_auto_sw = 'Y' AND NVL(a2.auto_renew_flag, 'N') = 'Y' THEN
				v_ren_flag := '3';
			 END IF;

			 --beth 10262000 derived the latest item title for policy
			 --     with more than one item, item title would be various
			 v_item_no := NULL;

			 FOR i IN (SELECT C.item_no, SUBSTR(C.item_title, 1,50) item_title
						 FROM GIPI_POLBASIC A,
							  GIPI_ITEM C
						WHERE A.line_cd = a2.line_cd
						  AND A.subline_cd = a2.subline_cd
						  AND A.iss_cd     = a2.iss_cd
						  AND A.issue_yy   = a2.issue_yy
						  AND A.pol_seq_no = a2.pol_seq_no
						  AND A.renew_no   = a2.renew_no
						  AND A.policy_id  = C.policy_id
						  AND A.pol_flag IN ('1','2','3')
						  AND A.pack_policy_id IS NULL --A.R.C. 05.07.2007
						  AND ( A.endt_seq_no = 0
								OR ( A.endt_seq_no > 0
									 AND TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
						ORDER BY eff_date ASC)
			 LOOP
			   IF NVL(v_item_no, i.item_no) = i.item_no THEN
				 v_item_no    := i.item_no;
				 v_item_title := i.item_title;
			   ELSE
				  v_item_title := 'VARIOUS';
				  EXIT;
			   END IF;
			 END LOOP;

			 --beth 10262000 for fire derived location of risk
			 --     if location of risk is not the same for more than one item
			 --     the value of location of risk would be various
			 IF a2.line_cd     =   v_line_fi THEN

				v_item_no := NULL;

				FOR fi IN (SELECT SUBSTR(b.loc_risk1, 1,50) loc_risk1,
								  SUBSTR(b.loc_risk2, 1,50) loc_risk2,
								  SUBSTR(b.loc_risk3, 1,50) loc_risk3,
								  c.risk_no,
								  c.risk_item_no,
								  b.item_no
							 FROM GIPI_POLBASIC A,
								  GIPI_FIREITEM  b,
								  GIPI_ITEM C
							WHERE A.line_cd = a2.line_cd
							  AND A.subline_cd = a2.subline_cd
							  AND A.iss_cd     = a2.iss_cd
							  AND A.issue_yy   = a2.issue_yy
							  AND A.pol_seq_no = a2.pol_seq_no
							  AND A.renew_no   = a2.renew_no
							  AND A.policy_id  = b.policy_id
							  AND b.policy_id  = C.policy_id
							  AND b.item_no    = C.item_no
							  AND A.pol_flag IN ('1','2','3')
							  AND A.pack_policy_id IS NULL
							  AND ( A.endt_seq_no = 0
									OR ( A.endt_seq_no > 0
										 AND TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
							ORDER BY b.item_no, eff_date ASC)
				LOOP
				  IF NVL(v_item_no, fi.item_no) = fi.item_no THEN
					 v_item_no := fi.item_no;
					 IF fi.loc_risk1 IS NOT NULL
						OR fi.loc_risk2 IS NOT NULL
						OR fi.loc_risk3 IS NOT NULL
					 THEN
						v_loc_risk1    := fi.loc_risk1;
						v_loc_risk2    := fi.loc_risk2;
						v_loc_risk3    := fi.loc_risk3;
						v_risk_no    := fi.risk_no;
						v_risk_item_no := fi.risk_item_no;
					 END IF;
				  ELSIF NVL(v_item_no, fi.item_no) <> fi.item_no THEN
					 IF v_loc_risk1 IS NULL
						AND v_loc_risk2 IS NULL
						AND v_loc_risk3 IS NULL
					 THEN
						v_item_no := fi.item_no;
						IF fi.loc_risk1 IS NOT NULL OR
						   fi.loc_risk2 IS NOT NULL OR
						   fi.loc_risk3 IS NOT NULL THEN
						   v_loc_risk1    := fi.loc_risk1;
						   v_loc_risk2    := fi.loc_risk2;
						   v_loc_risk3    := fi.loc_risk3;
						   v_risk_no   := fi.risk_no;
						   v_risk_item_no := fi.risk_item_no;
						END IF;
					 ELSIF NVL(v_loc_risk1, '%^&') <> NVL(fi.loc_risk1,'%^&') OR
						NVL(v_loc_risk2, '%^&') <> NVL(fi.loc_risk2,'%^&') OR
						NVL(v_loc_risk3, '%^&') <> NVL(fi.loc_risk3,'%^&') THEN
						v_loc_risk1    := 'VARIOUS';
						v_loc_risk2    := NULL;
						v_loc_risk3    := NULL;
						v_risk_no    := fi.risk_no;      -- added by gmi  060707
						v_risk_item_no := fi.risk_item_no; -- added by gmi  060707
						EXIT;
					 END IF;
				  END IF;
				END LOOP;
			 END IF;

			 IF a2.line_cd     =   v_line_mc THEN
			   v_item_no := NULL;
				FOR a9 IN (SELECT b.color,
								  b.motor_no,
								  b.model_year,
								d.car_company,
								  b.make,
								  b.serial_no,
								  b.plate_no,
								  b.item_no,
								  b.MOTOR_COVERAGE
							 FROM GIPI_POLBASIC A,
								  GIPI_VEHICLE  b,
								  GIPI_ITEM     C,
								  GIIS_MC_CAR_COMPANY d
							WHERE A.line_cd = a2.line_cd
							  AND A.subline_cd = a2.subline_cd
							  AND A.iss_cd     = a2.iss_cd
							  AND A.issue_yy   = a2.issue_yy
							  AND A.pol_seq_no = a2.pol_seq_no
							  AND A.renew_no   = a2.renew_no
							  AND A.policy_id  = b.policy_id
							  AND b.policy_id  = C.policy_id
							  AND b.item_no    = C.item_no
							AND b.car_company_cd = d.car_company_cd(+)
							  AND A.pol_flag IN ('1','2','3')
							  AND A.pack_policy_id IS NULL
							  AND ( A.endt_seq_no = 0
									OR ( A.endt_seq_no > 0
										 AND TRUNC(A.endt_expiry_date) >= TRUNC(A.expiry_date)))
							ORDER BY eff_date ASC)
				LOOP
				  IF NVL(v_item_no, a9.item_no) = a9.item_no THEN
					 v_item_no        := a9.item_no;
					 v_color          := NVL(a9.color, v_color);
					 v_motor_no       := NVL(a9.motor_no,v_motor_no);
					 v_model_year     := NVL(a9.model_year,v_model_year);
					 v_make           := NVL(a9.make, v_make);
					 v_serial_no      := NVL(a9.serial_no,v_serial_no);
					 v_plate_no       := NVL(a9.plate_no,v_plate_no);
					 v_car_company    := NVL(a9.car_company,v_car_company);
					 v_motor_coverage := NVL(a9.motor_coverage,v_motor_coverage);
				  ELSE
					 v_color          := 'VARIOUS';
					 v_motor_no       := 'VARIOUS';
					 v_model_year     := 'VAR.'   ;
					 v_make           := 'VARIOUS';
					 v_serial_no      := 'VARIOUS';
					 v_plate_no       := 'VARIOUS';
					 v_car_company    := NULL     ;
					 v_motor_coverage := NULL;
					 EXIT;
				  END IF;
				END LOOP;
			 END IF;

			 IF NVL(p_def_is_pol_summ_sw,'N') != 'Y' THEN
				v_summ_sw := 'N';
			 ELSE
				v_summ_sw := 'Y';
			 END IF;
			 IF NVL(p_def_same_polno_sw,'N') != 'Y' THEN
				v_same_sw := 'N';
			 ELSE
				v_same_sw := 'Y';
			 END IF;

			   /*Modified by Iris Bordey 08.29.2003
			   **Transferred end-if after insertion to all table affected by giex_expiry
			   **to resolve ora-02291 (parent key not found).
			   */
			   /*Commented by A.R.C. 03.07.2005
			   **Transferred to after insertion to table giex_expiry
			   **to resolve ora-02291 (parent key not found).
			   */
				v_renewal_id := TRANSLATE(a2.policy_id, '0123456789', 'ABCDGJMPTW');

			   BEGIN
				SELECT acct_iss_cd
				  INTO v_acct_iss_cd
				  FROM GIIS_ISSOURCE
				 WHERE iss_cd = a2.iss_cd;
			   END;

				Generate_Ref_No(v_acct_iss_cd,0000,v_ref_no,'GIEXS001');

			   /* petermkaw 06232010
			   ** changed mod_no to bank_ref_no and v_mod_no to v_ref
			   ** to acquire bank_ref_no form gipi_ref_no_hist and commented out the
			   ** population of v_ref below */
			   BEGIN
				SELECT bank_ref_no /*mod_no*/
				  INTO v_ref/*v_mod_no*/
				  FROM GIPI_REF_NO_HIST
				 WHERE acct_iss_cd = v_acct_iss_cd
				   AND branch_cd   = 0000
				   AND ref_no      = v_ref_no; --mod_no
				EXCEPTION
				 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
				 NULL;
				END;

            /*JOANNE consolidate all changes in process_expiring policies, 112813*/
		    /****************************   added by jongs 10182013     ********************************/
            SELECT COUNT(*)
              INTO v_cnt_expiry
              FROM giex_expiry
             WHERE policy_id = a2.policy_id;

            IF v_cnt_expiry = 0 THEN
            /*v_ref:=v_acct_iss_cd||'-'||0000||'-'||v_ref_no||'-'||v_mod_no;*/
                   INSERT INTO GIEX_EXPIRY
							 (policy_id,    expiry_date,  line_cd,      subline_cd,
							  iss_cd,       issue_yy,     pol_seq_no,   renew_no,
							  claim_flag,   extract_user, extract_date, user_id,
							  last_update,  renew_flag,   auto_renew_flag,
							  balance_flag, incept_date,
							  assd_no,      same_polno_sw,update_flag,  summary_sw,
							  auto_sw,      tax_amt,      policy_tax_amt,
							  color,        motor_no,     model_year,   make,
							  serialno,     plate_no,     item_title,   loc_risk1,
							  loc_risk2,    loc_risk3,    intm_no,      car_company,
							  orig_tsi_amt, reg_policy_sw, renewal_id,
							  risk_no,      risk_item_no,  motor_coverage,
							  bank_ref_no, ref_pol_no, /*added by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure */
                              remarks, cred_branch
				  )
					  VALUES (a2.policy_id, v_exp_date,   a2.line_cd,   a2.subline_cd,
							  a2.iss_cd,    a2.issue_yy,  a2.pol_seq_no,a2.renew_no,
							  v_clm,        p_user_id,    v_ext_date,   p_user_id,
							  SYSDATE,      v_ren_flag,   a2.auto_renew_flag,
							  v_bal,        v_inc_date,
							  v_assd_no,    v_same_sw,    'N',          v_summ_sw,
							  v_auto_sw,    v_tax,        v_pol_tax,
							  v_color,      v_motor_no,   v_model_year, v_make,
							  v_serial_no,  v_plate_no,   v_item_title, v_loc_risk1,
							  v_loc_risk2,  v_loc_risk3,  v_intm_no,    v_car_company,
							  v_orig_tsi_exp, v_reg_pol_sw,   v_renewal_id,
							  v_risk_no,      v_risk_item_no, v_motor_coverage,
							  v_ref, a2.ref_pol_no, /*added by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure */
                              v_concat_remarks, a2.cred_branch
				   );
            END IF;
			--start1
            /*JOANNE consolidate all changes in process_expiring policies codes by mam jhing, 112813 start*/
            -- jhing 07.20.2013 commented out codes ; need to recode logic
            -- in getting premium amount and TSI amount to ensure changes of peril rate
            -- in multi-item (with same peril) is covered correctly. This is to ensure
            -- extracted ren_tsi_amt and ren_prem_amt is equal to the amount processed

			   /*Added by A.R.C. 03.07.2005
			   **To resolve ora-02291 (parent key not found).
			   */
			  /* v_total_dep_tsi := 0;
			   v_total_dep_prm := 0;
			   v_total_ren_tsi := 0;
			   v_total_ren_prm := 0;
			   v_total_currency_prm := 0;
			   pv_endt_seq_no  :=NULL;
			   v_peril_cnt     := 0;

			   IF t_peril_cds.EXISTS(1) THEN
				FOR x1 IN t_peril_cds.FIRST.. t_peril_cds.LAST
				 LOOP
				t_peril_cds.DELETE;
				t_item_nos.DELETE;
				END LOOP;
			   END IF;

			   v_a8_ren_prem_amt := 0;
			   v_currency_prem_amt := 0;

			FOR a8 IN (
			   SELECT /*SUM(A.prem_amt * C.currency_rt) prem_amt2,
					  SUM(A.tsi_amt * C.currency_rt) tsi_amt2,*/
			/*		  (A.ann_prem_amt) currency_prem_amt,
					  (A.ann_prem_amt * C.currency_rt) ren_prem_amt,
					  (A.ann_tsi_amt * C.currency_rt) ren_tsi_amt,
					  A.line_cd, A.peril_cd,d.peril_type peril_type,
					  endt_seq_no, C.item_no
				 FROM GIPI_ITMPERIL A,
					  GIPI_POLBASIC b,
					  GIPI_ITEM     C,
					  GIIS_PERIL d
				WHERE b.line_cd         = a2.line_cd
				  AND b.subline_cd      = a2.subline_cd
				  AND b.iss_cd          = a2.iss_cd
				  AND b.issue_yy        = a2.issue_yy
				  AND b.pol_seq_no      = a2.pol_seq_no
				  AND b.renew_no        = a2.renew_no
				  AND d.peril_cd  = A.peril_cd
				  AND d.line_cd   = A.line_cd
				  AND A.policy_id       = b.policy_id
				  AND b.policy_id       = C.policy_id
				  AND A.policy_id       = b.policy_id
				  AND A.item_no         = C.item_no
				  AND b.pol_flag        IN('1','2','3')
				  AND b.pack_policy_id IS NULL
				  AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
				  AND (b.endt_seq_no = 0 OR
					  (b.endt_seq_no > 0 AND
					  TRUNC(b.endt_expiry_date) >= TRUNC(b.expiry_date)))
				ORDER BY EFF_DATE DESC, ENDT_SEQ_NO DESC)
				--GROUP BY A.peril_cd, A.line_cd, d.peril_type)
			 LOOP
				 v_skip := NULL;
				 IF NVL(pv_endt_seq_no,a8.endt_seq_no) <> a8.endt_seq_no THEN
					v_skip := 'N';
					FOR x1 IN t_peril_cds.FIRST.. t_peril_cds.LAST
					LOOP
						IF t_peril_cds(x1) = a8.peril_cd AND
							t_item_nos(x1)  = a8.item_no THEN
							v_skip := 'Y';
							--EXIT;
						END IF;
					END LOOP;
				 --EXIT;
				 END IF;

				 IF v_skip IS NULL THEN
					pv_endt_seq_no := a8.endt_seq_no;
				 END IF;

				 IF NVL(v_skip,'N') = 'N' THEN
					  v_peril_cnt              := v_peril_cnt + 1;
					  t_peril_cds(v_peril_cnt) := a8.peril_cd;
					  t_item_nos(v_peril_cnt)  := a8.item_no;
					  o_line_cd       := a8.line_cd;
					  o_peril_cd      := a8.peril_cd;
					  --o_prem_amt2     := a8.prem_amt2;
					  v_orig_tsi_ogrp := a8.ren_tsi_amt;
					  v_orig_prm_ogrp := a8.ren_prem_amt;
					  v_ren_tsi_ogrp  := a8.ren_tsi_amt;
					  v_ren_prm_ogrp  := a8.ren_prem_amt;
					  v_currency_prm_ogrp  := a8.currency_prem_amt;
				--   v_a8_ren_prem_amt := v_a8_ren_prem_amt + a8.ren_prem_amt;
				--   v_currency_prem_amt := v_currency_prem_amt + a8.currency_prem_amt;

					  /* rollie 25-OCT-2004
					  ** FOR AUTO COMPUTE OF tsi depreciation
					  ** look up ON TABLE giex_dep_perl */
					  /*commented by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure*/
					  /*
					  BEGIN
						SELECT 'Y'
						  INTO v_auto_dep
						  FROM GIEX_DEP_PERL
						 WHERE line_cd  = a8.line_cd
						   AND peril_cd = a8.peril_cd;
					  EXCEPTION
						WHEN NO_DATA_FOUND THEN
							v_auto_dep := 'N';
						WHEN TOO_MANY_ROWS THEN
							v_auto_dep := 'Y';
					  END;*/
					  /*replaced by codes below*/

				/*	  v_dep_pct := 0;

					  FOR gdp
					  IN (SELECT   rate
							FROM   giex_dep_perl
						   WHERE   line_cd = a8.line_cd
								   AND peril_cd = a8.peril_cd)
					  LOOP
						 v_dep_pct := gdp.rate;
					  END LOOP;
					  /*end, cherrie 12052012*/


					 --IF a8.line_cd = v_line_mc AND v_auto_dep = 'Y' THEN
				/*	  IF v_auto_dep = 'Y' THEN
						 o_ren_tsi_amt2       := v_ren_tsi_ogrp - (v_ren_tsi_ogrp * (v_dep_pct/100));
						 o_ren_prem_amt2      := v_ren_prm_ogrp - (v_ren_prm_ogrp * (v_dep_pct/100));
						 o_currency_prem_amt2 := v_currency_prm_ogrp - (v_currency_prm_ogrp * (v_dep_pct/100));
					  ELSE
						 o_ren_tsi_amt2       := v_ren_tsi_ogrp;
						 o_ren_prem_amt2      := v_ren_prm_ogrp;
						 o_currency_prem_amt2 := v_currency_prm_ogrp;
					  END IF;
					  --o_tsi_amt2      := v_orig_tsi_ogrp;
					  --o_prem_amt2     := v_orig_prm_ogrp;

					  IF a8.peril_type = 'B' THEN
						  --v_total_dep_tsi  := NVL(v_total_dep_tsi,0) + o_tsi_amt2;
						  v_total_ren_tsi  := NVL(v_total_ren_tsi,0) + o_ren_tsi_amt2;
					  END IF;

					  --v_total_dep_prm     := NVL(v_total_dep_prm,0) + o_prem_amt2;
					  v_total_ren_prm      := NVL(v_total_ren_prm,0) + o_ren_prem_amt2;
					  v_total_currency_prm := NVL(v_total_currency_prm,0) + o_currency_prem_amt2;
					  v_a8_ren_prem_amt    := v_total_ren_prm;
					  v_currency_prem_amt  := v_total_currency_prm;

					  BEGIN
						SELECT COUNT(*)
						  INTO v_ctr
						  FROM GIEX_OLD_GROUP_PERIL
						 WHERE policy_id = a2.policy_id
						   AND peril_cd = a8.peril_cd;
					  END;

					  IF NVL(v_ctr,0) = 0 THEN
							INSERT INTO GIEX_OLD_GROUP_PERIL
									  (policy_id,    line_cd,     peril_cd,     prem_amt,
										tsi_amt,    orig_tsi_amt, currency_prem_amt)
							VALUES (a2.policy_id, o_line_cd,   o_peril_cd,   o_ren_prem_amt2,
									o_ren_tsi_amt2, v_orig_tsi_ogrp,  o_currency_prem_amt2);
					  ELSE
						 UPDATE GIEX_OLD_GROUP_PERIL
							SET prem_amt     = prem_amt + o_ren_prem_amt2,
								tsi_amt      = tsi_amt + o_ren_tsi_amt2,
								orig_tsi_amt = orig_tsi_amt + v_orig_tsi_ogrp,
								currency_prem_amt = currency_prem_amt + o_currency_prem_amt2
						  WHERE policy_id = a2.policy_id
							AND peril_cd  = a8.peril_cd;
					  END IF;
				END IF; -- v_skip IF
			END LOOP; */-- end1 -- jhing 07.20.2013 end of commented out codes

            -- ==========================  jhing 07.20.2013 new code in exrtraction ===========================================
            -- Jhing remarks: re-coded the extraction of amounts to ensure correct premium and TSI is saved in the tables considering the following factors:
            --                1) depreciation - rounded off
            --                2) latest peril rate is retrieved and used in the computation of premium
            --                3) since tariff is for GUC discussion, if the prem_rt = 0 , then the prem_rt will be calculated
            --                   from premium/TSI
            DECLARE
               v_round_off            giis_parameters.param_value_n%TYPE;
               v_apply_dep            VARCHAR2 (1);
               v_policy_id            giex_expiry.policy_id%TYPE;
               v_endt_id              giex_expiry.policy_id%TYPE;
               v_exists_in_prev_id    VARCHAR2 (1);
               v_cnt_rec              NUMBER;
               v_temp_tsi             giex_old_group_peril.tsi_amt%TYPE;
               v_temp_prem            giex_old_group_peril.prem_amt%TYPE;
               v_temp_currency_tsi    giex_old_group_peril.orig_tsi_amt%TYPE;
               v_temp_currency_prem   giex_old_group_peril.currency_prem_amt%TYPE;
               v_temp_prem_rt         gipi_itmperil.prem_rt%TYPE;
               v_temp_currency_rt     gipi_witem.currency_rt%TYPE;
               v_old_temp_tsi         gipi_witem.tsi_amt%TYPE;
               v_old_temp_prem        gipi_witem.prem_amt%TYPE;
               v_mark_eff_date        gipi_wpolbas.eff_date%TYPE;
               v_mark_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
               v_currency_cd          gipi_item.currency_cd%TYPE;
               v_orig_tsi             giex_old_group_peril.orig_tsi_amt%TYPE; --joanne 050514, for orig_tsi_amt
            BEGIN
               -- get the round off parameter value
               BEGIN
                  SELECT DECODE (param_value_n,
                                 10, -1,
                                 100, -2,
                                 1000, -3,
                                 10000, -4,
                                 100000, -5,
                                 1000000, -6,
                                 9
                                )
                    INTO v_round_off
                    FROM giis_parameters
                   WHERE param_name = 'ROUND_OFF_PLACE';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_round_off := 9;
               END;

               v_apply_dep := NVL (giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N');
               -- get all policies and endorsements
               v_policy_id := NULL;
               v_endt_id := NULL;
               v_exists_in_prev_id := NULL;
               v_cnt_rec := 0;
               v_temp_currency_tsi := 0;
               v_temp_prem_rt := 0;
               v_temp_currency_rt := 0;
               v_temp_tsi := 0;
               v_temp_currency_prem := 0;
               v_temp_prem := 0;
               v_old_temp_tsi := 0;
               v_old_temp_prem := 0;
               v_currency_cd := NULL;

               FOR cur_policy IN (SELECT   policy_id, eff_date, endt_seq_no
                                      FROM gipi_polbasic
                                     WHERE line_cd = a2.line_cd
                                       AND subline_cd = a2.subline_cd
                                       AND iss_cd = a2.iss_cd
                                       AND issue_yy = a2.issue_yy
                                       AND pol_seq_no = a2.pol_seq_no
                                       AND renew_no = a2.renew_no
                                       --AND pol_flag IN ('1', '2', '3')
                                      AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                                        OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                                        OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                                       AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no)
                                       AND (   endt_seq_no = 0
                                            OR (    endt_seq_no > 0
                                                AND TRUNC
                                                       (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ) >=
                                                           TRUNC (expiry_date)
                                               )
                                           )
                                  ORDER BY eff_date, endt_seq_no)
               LOOP
                  IF v_policy_id IS NULL
                  THEN
                     v_policy_id := a2.policy_id;
                  END IF;

                  v_endt_id := cur_policy.policy_id;
                  v_mark_eff_date := cur_policy.eff_date;
                  v_mark_endt_seq_no := cur_policy.endt_seq_no;

                  -- query all the peril of the policy/endt per item
                  FOR cur_itmperil IN (SELECT   a.tsi_amt, a.prem_rt,
                                                a.prem_amt, a.item_no,
                                                a.peril_cd, b.currency_rt,
                                                a.line_cd, b.currency_cd
                                           FROM gipi_itmperil a, gipi_item b
                                          WHERE a.policy_id = v_endt_id
                                            AND a.policy_id = b.policy_id
                                            AND a.item_no = b.item_no
                                       ORDER BY a.item_no, a.peril_cd)
                  LOOP
                     v_exists_in_prev_id := 'N';
                     -- this variable will hold info whether the item/peril existed in previous policy/endt.
                     v_temp_currency_tsi := cur_itmperil.tsi_amt;
                     v_temp_prem_rt := cur_itmperil.prem_rt;
                     v_temp_currency_rt := NVL (cur_itmperil.currency_rt, 1);
                     v_temp_tsi := cur_itmperil.tsi_amt; /* v_temp_currency_rt;
                         joanne 042414, computation for converted amount should be last process*/
                     v_temp_currency_prem := cur_itmperil.prem_amt;
                     v_temp_prem :=
                                   cur_itmperil.prem_amt; /* v_temp_currency_rt;
                                   joanne 042414, computation for converted amount should be last process*/
                     v_old_temp_tsi := cur_itmperil.tsi_amt;
                     v_old_temp_prem := cur_itmperil.prem_amt;
                     v_currency_cd := cur_itmperil.currency_cd;

                     -- query all records in the policy/endt which contains the same item_no and peril_cd
                     FOR cur_all_perils IN
                        (SELECT   a.policy_id, a.item_no, a.peril_cd,
                                  a.tsi_amt, a.prem_rt, a.prem_amt,
                                  b.eff_date, b.endt_seq_no
                             FROM gipi_itmperil a, gipi_polbasic b
                            WHERE a.policy_id = b.policy_id
                              AND b.line_cd = a2.line_cd
                              AND b.subline_cd = a2.subline_cd
                              AND b.iss_cd = a2.iss_cd
                              AND b.issue_yy = a2.issue_yy
                              AND b.pol_seq_no = a2.pol_seq_no
                              AND b.renew_no = a2.renew_no
                              AND a.item_no = cur_itmperil.item_no
                              AND a.peril_cd = cur_itmperil.peril_cd
                              --AND b.pol_flag IN ('1', '2', '3')
                              AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                                OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                                OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                              AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no)
                              AND (   endt_seq_no = 0
                                   OR (    endt_seq_no > 0
                                       AND TRUNC (NVL (endt_expiry_date,
                                                       expiry_date
                                                      )
                                                 ) >= TRUNC (expiry_date)
                                      )
                                  )
                              AND b.policy_id <> v_endt_id
                         ORDER BY b.eff_date, b.endt_seq_no)
                     LOOP
                        -- if mas later than ung eff_date ng current na tsek na record kesa sa unang naretrieve ng query...it means ... meron ng nadaanana
                        -- na query before
                        IF     v_mark_eff_date > cur_all_perils.eff_date
                           AND v_mark_endt_seq_no > cur_all_perils.endt_seq_no
                        THEN
                           v_exists_in_prev_id := 'Y';
                           EXIT;
                        ELSE
                           -- pag di equal si endt_id kay cur_all_perils then add up and kunin ung prem_rt pag non-zero si tsi and prem_rt
                           v_temp_currency_tsi :=
                                 v_temp_currency_tsi + cur_all_perils.tsi_amt;
                          /* v_temp_tsi :=
                                v_temp_tsi
                              + (cur_all_perils.tsi_amt * v_temp_currency_rt
                                ); joanne 042414, computation for converted amount should be last process*/
                           v_temp_currency_prem :=
                                v_temp_currency_prem + cur_all_perils.prem_amt;
                           /*v_temp_prem :=
                                v_temp_prem
                              + (cur_all_perils.prem_amt * v_temp_currency_rt
                                ); joanne 042414, computation for converted amount should be last process*/

                           -- IF cur_all_perils.prem_rt > 0 -- replaced by robert SR 21666 03.04.16
                           -- THEN
                           IF v_temp_currency_tsi = 0 THEN 
                              v_temp_prem_rt := 0;
                           ELSE -- end of codes by robert SR 21666 03.04.16
                              v_temp_prem_rt := (v_temp_currency_prem/v_temp_currency_tsi)*100;--cur_all_perils.prem_rt; Gzelle 06232015 SR3921 should be based on annual premium and tsi amounts
                           END IF;

                           v_old_temp_tsi :=
                                       v_old_temp_tsi + cur_all_perils.tsi_amt;
                           v_old_temp_prem :=
                                     v_old_temp_prem + cur_all_perils.prem_amt;
                        END IF;
                     END LOOP;

                     v_orig_tsi := v_temp_currency_tsi * v_temp_currency_rt; --added by joanne 05292014, assign value to orig_tsi before applying depreciation rate

                     -- if di pa naexists/nacheck ng mga naunang queries/run ng loop....iadd/update ung giex_old_group_peril
                     IF v_exists_in_prev_id = 'N'
                     THEN
                        -- if cancelled na ung peril..then don't do anything
                        IF v_temp_currency_tsi > 0--v_temp_tsi > 0 modify by joanne 052114
                        THEN
                           -- if zero si prem_rt (which is most probably due to the reason n standard tariff rates applied sa knya and/or gumana sa knya ung minimum premium.
                           -- then recalculate ung prem_rt based on accumulated tsi/prem. Under GUC discussion pa ano ung final handling ng ganitong type of records.
                           IF v_temp_prem_rt = 0
                           THEN
                              /*v_temp_prem_rt :=
                                             (v_temp_prem / v_temp_tsi) * 100; joanne 042414 rate should be computed from orig currency*/
                              v_temp_prem_rt :=
                                             (v_temp_currency_prem / v_temp_currency_tsi) * 100;
                           END IF;

                           -- get the depreciation rate
                           /*IF v_apply_dep = 'Y'
                           THEN
                              FOR a IN (SELECT NVL (rate, 0) rate
                                          FROM giex_dep_perl
                                         WHERE line_cd = cur_itmperil.line_cd
                                           AND peril_cd =
                                                         cur_itmperil.peril_cd)
                              LOOP
                                IF a.rate <> 0 THEN
--                                     v_temp_tsi :=
--                                        ROUND ((  v_temp_tsi
--                                                - (v_temp_tsi * (a.rate / 100))
--                                               ),
--                                               v_round_off
--                                              ); joanne 042414, computation for converted amount should be last process
                                     v_temp_currency_tsi :=
                                        ROUND ((  v_temp_currency_tsi
                                                - (  v_temp_currency_tsi
                                                   * (a.rate / 100)
                                                  )
                                               ),
                                               v_round_off
                                              );
                                END IF;
                              END LOOP;
                           END IF;*/ --benjo 11.23.2016 SR-5278 comment out
                           
                           compute_depreciation_amounts(v_endt_id, cur_itmperil.item_no, cur_itmperil.line_cd, cur_itmperil.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 SR-5278

                           IF a2.line_cd <> GIISP.V('LINE_CODE_AC') THEN  --added by joanne 02.11.14, prevent zero renewal prem in group PA
                               v_temp_currency_prem :=
                                      v_temp_currency_tsi
                                      * (v_temp_prem_rt / 100);
                               --v_temp_prem := v_temp_tsi * (v_temp_prem_rt / 100); joanne 042414, computation for converted amount should be last process
                           END IF;

                           --added by joanne 042414, computatioin for converted amounts
                           v_temp_tsi := v_temp_currency_tsi * v_temp_currency_rt;
                           v_temp_prem := v_temp_currency_prem * v_temp_currency_rt;
                           --v_orig_tsi :=  v_old_temp_tsi * v_temp_currency_rt; comment by joanne 052914

                           -- check if nagexists n ung peril sa giex_old_group_peril.. pagnag_exists na update ung record , otherwise insert
                           SELECT COUNT (1)
                             INTO v_cnt_rec
                             FROM giex_old_group_peril
                            WHERE policy_id = v_policy_id
                              AND peril_cd = cur_itmperil.peril_cd;

                           -- if more than 0 ung cnt ng record sa giex_old_group_peril..update na lang
                           IF v_cnt_rec > 0
                           THEN
                              UPDATE giex_old_group_peril
                                 SET prem_amt = prem_amt + v_temp_prem,
                                     tsi_amt = tsi_amt + v_temp_tsi,
                                     currency_prem_amt =
                                          currency_prem_amt
                                        + v_temp_currency_prem,
                                     orig_tsi_amt =
                                            orig_tsi_amt + v_orig_tsi--v_temp_currency_tsi Gzelle 06232015 SR3919 (consistency in currency))
                               WHERE policy_id = a2.policy_id
                                 AND peril_cd = cur_itmperil.peril_cd;
                           ELSE
                              INSERT INTO giex_old_group_peril
                                          (policy_id,
                                           line_cd,
                                           peril_cd,
                                           prem_amt, tsi_amt,
                                           orig_tsi_amt,
                                           currency_prem_amt
                                          )
                                   VALUES (a2.policy_id,
                                           cur_itmperil.line_cd,
                                           cur_itmperil.peril_cd,
                                           v_temp_prem, v_temp_tsi,
                                           v_orig_tsi, --v_temp_currency_tsi, joanne 050514
                                           v_temp_currency_prem
                                          );
                           END IF;

                      /********* added by jongs to prevent ora-00001 10.08.2013 *******/
                           SELECT COUNT(1)
                             INTO v_cnt_itmperl
                             FROM giex_old_group_itmperil
                            WHERE policy_id = v_policy_id
                              AND peril_cd = cur_itmperil.peril_cd
                              AND item_no = cur_itmperil.item_no;

                           IF v_cnt_itmperl > 0 THEN

                               UPDATE giex_old_group_itmperil
                                  SET prem_rt = v_temp_prem_rt,
                                      tsi_amt = v_old_temp_tsi,
                                      prem_amt = v_old_temp_prem,
                                      ren_tsi_amt = v_temp_currency_tsi,
                                      ren_prem_amt = v_temp_currency_prem,
                                      currency_rt = v_temp_currency_rt,
                                      currency_cd = v_currency_cd
                                 WHERE policy_id = v_policy_id
                                  AND peril_cd = cur_itmperil.peril_cd
                                  AND item_no = cur_itmperil.item_no;
                           ELSE


                               INSERT INTO giex_old_group_itmperil
                                           (policy_id, line_cd,
                                            subline_cd, item_no,
                                            peril_cd,
                                            prem_rt, tsi_amt,
                                            prem_amt, ren_tsi_amt,
                                            ren_prem_amt,
                                            currency_rt, currency_cd
                                           )
                                    VALUES (a2.policy_id, a2.line_cd,
                                            a2.subline_cd, cur_itmperil.item_no,
                                            cur_itmperil.peril_cd,
                                            v_temp_prem_rt, v_old_temp_tsi,
                                            v_old_temp_prem, v_temp_currency_tsi,
                                            v_temp_currency_prem,
                                            v_temp_currency_rt, v_currency_cd
                                           );
                           END IF;
                           /*************   end jongs 10.08.2013   **************/
                        END IF;
                     END IF;
                  END LOOP;
               END LOOP;
            END;
            -- ============================ end jhing 07.20.2013 ===============================================================
            /*JOANNE consolidate all changes in process_expiring policies codes by mam jhing, 112813 end*/

            /*JOANNE consolidate all changes in process_expiring policies modification by edgar tax, 112813 start*/
			--start2
            --commented out edgar nobleza 07/25/2013
           /* v_ctr := 0;

			FOR a9 IN (
				  SELECT d.line_cd, d.tax_cd, e.tax_id, d.iss_cd, F.menu_line_cd,   -- 7/14/2010: F.menu_line_cd   2010-00090
						 e.tax_desc, e.rate rate, e.peril_sw,
						 tax_type, -- added by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure
						 tax_amount -- added by cherrie 12052012, to consolidate with the latest process_expiring_polices procedure
					FROM GIPI_POLBASIC b,
						 GIPI_INVOICE  C,
						 GIPI_INV_TAX  d,
						 GIIS_TAX_CHARGES e,
						 GIIS_LINE F                                          -- 7/14/2010: 2010-00090
				   WHERE b.line_cd         = a2.line_cd
					 AND b.subline_cd      = a2.subline_cd
					 AND b.iss_cd          = a2.iss_cd
					 AND b.issue_yy        = a2.issue_yy
					 AND b.pol_seq_no      = a2.pol_seq_no
					 AND b.renew_no        = a2.renew_no
					 AND b.line_cd           = F.line_cd                        -- 7/14/2010: 2010-00090
					 AND b.policy_id       = C.policy_id
					 AND d.prem_seq_no     = C.prem_seq_no
					 AND d.iss_cd          = b.iss_cd
					 AND d.tax_cd          = e.tax_cd
		   --         AND d.tax_id          = e.tax_id
					 AND d.iss_cd          = e.iss_cd
					 AND d.line_cd         = e.line_cd
					 AND NVL(e.expired_sw,'N') = 'N'
					 AND ADD_MONTHS(b.incept_date,12) BETWEEN eff_start_date AND eff_end_date
					 AND b.pol_flag        IN('1','2','3')
					 AND b.pack_policy_id IS NULL --A.R.C. 05.07.2007
					 AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
					 AND (b.endt_seq_no = 0 OR
						 (b.endt_seq_no > 0 AND
						 TRUNC(b.endt_expiry_date) >= TRUNC(b.expiry_date)))
				   GROUP BY d.line_cd, d.tax_cd, e.tax_id, d.iss_cd,e.tax_desc,e.rate,  --added by A.R.C. 03.07.2005
						  e.peril_sw, F.menu_line_cd                                  -- 7/14/2010: F.menu_line_cd    2010-00089
						  ,tax_type, -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
						  tax_amount -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
						  )
			  LOOP
				   /*start of consolidation rose 07152010 added the computation od doc stamps for PA*/
				   /*start of consolidation - cherrie 12052012, consolidate with the latest process_expiring_polices procedure*/
			/*	 IF a9.peril_sw = 'Y' THEN
				 	IF a9.tax_type = 'A' THEN  --FIXED AMOUNT
                    	v_dep_tax_amt := a9.tax_amount;
					ELSIF a9.tax_type = 'N' THEN --RANGE
                    	v_dep_tax_amt := 0;

                     	IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') THEN
                        	FOR gtr
                        	IN (SELECT tax_amount
                                  FROM giis_tax_range
                                 WHERE line_cd = a9.line_cd
                                   AND iss_cd = a9.iss_cd
                                   AND tax_cd = a9.tax_cd
                                   AND tax_id = a9.tax_id -- jhing 02.28.2012
                                   AND min_value <= v_total_ren_tsi
                                   AND max_value >= v_total_ren_tsi)
                        	LOOP
                           		v_dep_tax_amt := gtr.tax_amount;
                        	END LOOP;
                     	ELSE
                        	FOR gtr
                        	IN (SELECT tax_amount
                              	  FROM giis_tax_range
                             	 WHERE line_cd = a9.line_cd
                                   AND iss_cd = a9.iss_cd
                                   AND tax_cd = a9.tax_cd
                                   AND tax_id = a9.tax_id -- jhing 02.28.2012
                                   AND min_value <= v_total_ren_prm
                                   AND max_value >= v_total_ren_prm)
                        	LOOP
								v_dep_tax_amt := gtr.tax_amount;
                        	END LOOP;
                     	END IF;
					ELSE
						IF MOD(o_ren_prem_amt2,4) <> 0 AND a9.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
							/*Consolidate the changes in computation of docstamp - cherrie 12052012*/
							/* commented out by cherrie 09082012
							IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND /*v_param_doc = '2' rose07152010* v_param_pa_doc = '2' THEN               -- 7/14/2010: 2010-00089
								v_dep_tax_amt       := CEIL(o_ren_prem_amt2 /200) *(0.5);                                         -- 7/14/2010: 2010-00089
							ELSE                                                                                                                         -- 7/14/2010: 2010-00089
								v_dep_tax_amt      := CEIL(o_ren_prem_amt2 /4) *(0.5);
						    END IF;*/

							-- added by cherrie 09082012
							-- compute tax amount of doc_stamps based on compute_docstamp procedure
				/*			IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
							THEN                    --IF ACCIDENT / LIFE INSURANCE
							   IF v_param_pa_doc = 1
							   THEN -- COMPUTATION is based on Premium amount time tax rate
								  v_dep_tax_amt :=
									 (o_ren_prem_amt2 * a9.rate / 100);
							   ELSIF v_param_pa_doc = 2
							   THEN -- COMPUTATION IS 50cents for every 200 pesos of total premium
								  v_dep_tax_amt :=
									 CEIL (o_ren_prem_amt2 / 200) * (0.5);
							   ELSIF v_param_pa_doc = 3
							   THEN -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
								  BEGIN
									 SELECT   tax_amount
									   INTO   v_dep_tax_amt
									   FROM   giis_tax_range gtr
									  WHERE       1 = 1
											  AND gtr.line_cd = a9.line_cd
											  AND gtr.iss_cd = a9.iss_cd
											  AND tax_cd = giacp.n ('DOC_STAMPS')
											  AND v_total_ren_tsi BETWEEN min_value
																	  AND  max_value;
								  EXCEPTION
									 WHEN NO_DATA_FOUND
									 THEN
										RAISE_APPLICATION_ERROR (
										   -20002,
										   'NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).',
										   TRUE
										);
								  END;
							   END IF;
							ELSE
							   v_dep_tax_amt := CEIL (o_ren_prem_amt2 / 4) * (0.5);
							END IF;
						 	--end cherrie 09082012
							/*end of Consolidatation of changes in computation of docstamp - cherrie 12052012*/                                                                                                   -- 7/14/2010: 2010-00089
			/*			 ELSE
							v_dep_tax_amt      := o_ren_prem_amt2*(a9.rate/100);
						 END IF;

						 IF MOD(o_currency_prem_amt2,4) <> 0 AND a9.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
							IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND v_param_pa_doc = '2' THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
			/*				   v_currency_tax_amt := CEIL(o_currency_prem_amt2 /200) *(0.5);
							ELSE
							   v_currency_tax_amt := CEIL(o_currency_prem_amt2 /4) *(0.5);
							END IF;
						 ELSE
							v_currency_tax_amt := o_currency_prem_amt2*(a9.rate/100);
						 END IF;
					END IF;
				 ELSE
					IF a9.tax_type = 'A' THEN            --FIXED AMOUNT
                    	v_dep_tax_amt := a9.tax_amount;
					ELSIF a9.tax_type = 'N' THEN         --RANGE
                    	v_dep_tax_amt := 0;
                    	IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') THEN
                        	FOR gtr
                        	IN (SELECT   tax_amount
                                  FROM   giis_tax_range
                                 WHERE       line_cd = a9.line_cd
                                   AND iss_cd = a9.iss_cd
                                   AND tax_cd = a9.tax_cd
                                   AND tax_id = a9.tax_id -- jhing 02.28.2012
                                   AND min_value <= v_total_ren_tsi
                                   AND max_value >= v_total_ren_tsi)
							LOOP
							   v_dep_tax_amt := gtr.tax_amount;
							END LOOP;
                        ELSE
							FOR gtr
							IN (SELECT tax_amount
								  FROM giis_tax_range
								 WHERE line_cd = a9.line_cd
								   AND iss_cd = a9.iss_cd
								   AND tax_cd = a9.tax_cd
								   AND tax_id = a9.tax_id -- jhing 02.28.2012
								   AND min_value <= v_total_ren_prm
								   AND max_value >= v_total_ren_prm)
							LOOP
							   v_dep_tax_amt := gtr.tax_amount;
							END LOOP;
                     	END IF;
                    ELSE                        --RATE
					  IF MOD(v_a8_ren_prem_amt,4) <> 0 AND a9.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
					  	/*Consolidate the changes in computation of docstamp - cherrie 12052012*/
						/* commented out by cherrie 09082012
						IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND  v_param_pa_doc = '2' THEN   --v_param_doc = '2' rose07152010  -- 7/14/2010: 2010-00089
							v_dep_tax_amt       := CEIL(v_a8_ren_prem_amt /200) *(0.5);                      -- 7/14/2010: 2010-00089
						ELSE                                                                                        -- 7/14/2010: 2010-00089
							v_dep_tax_amt := CEIL(v_a8_ren_prem_amt /4) *(0.5);
						END IF;         -- 7/14/2010: 2010-00089
						*/
						-- added by cherrie 09082012
                        -- compute tax amount of doc_stamps based on compute_docstamp procedure
             /*           IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
                        THEN                    --IF ACCIDENT / LIFE INSURANCE
                           IF v_param_pa_doc = 1
                           THEN -- COMPUTATION is based on Premium amount time tax rate
                              v_dep_tax_amt :=
                                 (v_a8_ren_prem_amt * a9.rate / 100);
                           ELSIF v_param_pa_doc = 2
                           THEN -- COMPUTATION IS 50cents for every 200 pesos of total premium
                              v_dep_tax_amt :=
                                 CEIL (v_a8_ren_prem_amt / 200) * (0.5);
                           ELSIF v_param_pa_doc = 3
                           THEN -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
                              BEGIN
                                 SELECT   tax_amount
                                   INTO   v_dep_tax_amt
                                   FROM   giis_tax_range gtr
                                  WHERE       1 = 1
                                          AND gtr.line_cd = a9.line_cd
                                          AND gtr.iss_cd = a9.iss_cd
                                          AND tax_cd = giacp.n ('DOC_STAMPS')
                                          AND v_total_ren_tsi BETWEEN min_value
                                                                  AND  max_value;
                              EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    RAISE_APPLICATION_ERROR (
                                       -20002,
                                       'NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).',
                                       TRUE
                                    );
                              END;
                           END IF;
                        ELSE
                           v_dep_tax_amt :=
                              CEIL (v_a8_ren_prem_amt / 4) * (0.5);
                        END IF;
                     	--end cherrie 09082012
						/*end of Consolidation of changes in computation of docstamp - cherrie 12052012*/
			/*		  ELSE
						v_dep_tax_amt := v_a8_ren_prem_amt*(a9.rate/100);
					  END IF;

					  IF MOD(v_currency_prem_amt,4) <> 0 AND a9.tax_cd = v_doc_stamps AND v_param_doc = 'Y' THEN
						 IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND v_param_pa_doc = '2' THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
			/*				v_currency_tax_amt := CEIL(o_currency_prem_amt2 /200) *(0.5);
						 ELSE
							v_currency_tax_amt := CEIL(v_currency_prem_amt /4) *(0.5);
						 END IF;
					  ELSE
						 v_currency_tax_amt := v_currency_prem_amt*(a9.rate/100);
					  END IF;
				  END IF;
				END IF;
				/* end of consolidation - cherrie 12052012 */
				/*end of consolidation rose 07152010 added the computation of doc stamps for PA*/
			/*
				  BEGIN
					SELECT COUNT(*)
					  INTO v_ctr
					  FROM GIEX_OLD_GROUP_TAX
					 WHERE policy_id = a2.policy_id
					   AND line_cd = a9.line_cd
					   AND iss_cd = a9.iss_cd
					   AND tax_cd = a9.tax_cd
					   AND tax_id = a9.tax_id;
				  END;

				  IF v_ctr = 0 THEN
					   INSERT INTO GIEX_OLD_GROUP_TAX
										 (policy_id,    line_cd,     iss_cd,     tax_cd,
										 tax_id,       tax_desc,    tax_amt, currency_tax_amt)
							 VALUES (a2.policy_id, a9.line_cd,  a9.iss_cd,  a9.tax_cd,
										 a9.tax_id,    a9.tax_desc, v_dep_tax_amt, v_currency_tax_amt);
				  ELSE
					 UPDATE GIEX_OLD_GROUP_TAX
						SET tax_amt = v_dep_tax_amt + GIEX_OLD_GROUP_TAX.tax_amt,
							currency_tax_amt = v_currency_tax_amt + GIEX_OLD_GROUP_TAX.currency_tax_amt
					  WHERE policy_id = a2.policy_id
						AND line_cd = a9.line_cd
						AND iss_cd = a9.iss_cd
						AND tax_cd = a9.tax_cd
						AND tax_id = a9.tax_id;
				  END IF;

				  v_dep_tax_amt      := 0;
				  v_currency_tax_amt := 0;
			  END LOOP; */--ended comment out edgar nobleza 07/25/2013
              --end 2

          --============================================edgar nobleza 07/25/2013 new code for tax computation==============================================
            /*Modified by: Joanne, 042314, apply changes in tax from CS*/
            DECLARE
               v_count          NUMBER                                   := 0;
               v_vat_tag        giis_assured.vat_tag%TYPE;
               v_place_cd       gipi_polbasic.place_cd%TYPE;
               v_depr_tax_amt   giex_old_group_tax.tax_amt%TYPE          := 0;
               v_curr_tax_amt   giex_old_group_tax.currency_tax_amt%TYPE := 0;
               --joanne 042314, consolidate to cs
               v_currency_rt       giex_old_group_itmperil.currency_rt%TYPE := 1;
               gogi_currency_cd    giex_old_group_itmperil.currency_cd%TYPE;
               gogi_ren_tsi_amt    giex_old_group_itmperil.ren_tsi_amt%TYPE := 0;
               gogi_ren_prem_amt   giex_old_group_itmperil.ren_prem_amt%TYPE := 0;
               gogi_currency_rt    giex_old_group_itmperil.currency_rt%TYPE;
               --end joanne 042314, consolidate to cs
               --added by joanne 051514, to fixed issue regarding newly added fixed rate, zero rate taxes
               v_is_new             VARCHAR2(1);
               v_tax_type           giis_tax_charges.tax_type%TYPE;
               v_primary_sw         giis_tax_charges.primary_sw%TYPE;
               v_rate               giis_tax_charges.rate%TYPE;
               v_endt_tax           gipi_endttext.endt_tax%TYPE;
               v_cancelled          VARCHAR2(1);
               gogi_ren_tsi_amt2    giex_old_group_itmperil.ren_tsi_amt%TYPE := 0; --Dren 12.02.2015 SR-0020832 : Error in Doc Stamps Tax for PA
            BEGIN
               SELECT NVL (a.vat_tag, '3'), b.place_cd
                 INTO v_vat_tag, v_place_cd
                 FROM giis_assured a, gipi_polbasic b
                WHERE a.assd_no = b.assd_no AND b.policy_id = a2.policy_id;

               FOR gogi IN (SELECT currency_cd, currency_rt, ren_tsi_amt,
                                   ren_prem_amt
                              FROM giex_old_group_itmperil
                             WHERE policy_id = a2.policy_id)
               LOOP
                  gogi_currency_cd := gogi.currency_cd;
                  gogi_ren_tsi_amt := gogi_ren_tsi_amt + gogi.ren_tsi_amt;
                  gogi_ren_prem_amt := gogi_ren_prem_amt + gogi.ren_prem_amt;
                  gogi_currency_rt := gogi.currency_rt;
               END LOOP;

               FOR gogi2 IN (SELECT a.ren_tsi_amt --Dren 12.02.2015 SR-0020832 : Error in Doc Stamps Tax for PA - Start.
                               FROM giex_old_group_itmperil a, giis_peril b
                              WHERE a.policy_id = a2.policy_id
                                AND a.line_cd = b.line_cd
                                AND a.peril_cd = b.peril_cd
                                AND b.peril_type = 'B')                                    
               LOOP
                  gogi_ren_tsi_amt2 := gogi_ren_tsi_amt2 + gogi2.ren_tsi_amt;
               END LOOP; --Dren 12.02.2015 SR-0020832 : Error in Doc Stamps Tax for PA - End.

             FOR endt IN (SELECT endt_tax
                              FROM gipi_endttext
                             WHERE policy_id IN (
                                      SELECT policy_id
                                        FROM gipi_polbasic f
                                       WHERE f.line_cd = a2.line_cd
                                       AND f.subline_cd = a2.subline_cd
                                       AND f.iss_cd = a2.iss_cd
                                       AND f.issue_yy = a2.issue_yy
                                       AND f.pol_seq_no = a2.pol_seq_no
                                       AND f.renew_no = a2.renew_no))
              LOOP
                IF endt.endt_tax = 'Y' THEN
                    v_endt_tax := endt.endt_tax;
                    EXIT;
                END IF;
              END LOOP;

              FOR gpol IN
                 (SELECT   b.currency_cd, c.line_cd, c.tax_cd, d.tax_id,
                           c.iss_cd, e.menu_line_cd, f.expiry_date,
                           d.tax_desc, d.rate rate, d.peril_sw, tax_type,
                           tax_amount, d.expired_sw, 'N' is_new
                      FROM gipi_polbasic f,
                           --giex_old_group_itmperil a,
                           gipi_invoice b,
                           gipi_inv_tax c,
                           giis_tax_charges d,
                           giis_line e
                     WHERE f.line_cd = a2.line_cd
                       AND f.subline_cd = a2.subline_cd
                       AND f.iss_cd = a2.iss_cd
                       AND f.issue_yy = a2.issue_yy
                       AND f.pol_seq_no = a2.pol_seq_no
                       AND f.renew_no = a2.renew_no
                       --AND a.policy_id = f.policy_id
                       AND b.policy_id = f.policy_id
                       AND b.iss_cd = c.iss_cd
                       AND b.prem_seq_no = c.prem_seq_no
                       AND c.tax_cd = d.tax_cd
                       AND c.iss_cd = d.iss_cd
                       AND c.line_cd = d.line_cd
                       AND f.line_cd = e.line_cd
                       --AND NVL (d.expired_sw, 'N') = 'N'
                       AND (   NVL (d.expired_sw, 'N') = 'N'
                                      OR (    EXISTS (
                                                 SELECT '1'
                                                   FROM giis_tax_charges z
                                                  WHERE c.line_cd = z.line_cd
                                                    AND c.iss_cd = z.iss_cd
                                                    AND c.tax_cd = z.tax_cd
                                                    AND c.tax_id < z.tax_id
                                                    AND NVL (z.expired_sw,
                                                             'N') = 'N')
                                          AND NVL (d.expired_sw, 'N') = 'Y'
                                         )
                                     )
                       AND f.expiry_date BETWEEN eff_start_date
                                             AND eff_end_date
                       --joanne 02.11.14, replace code above consider summary parameter
                       AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                         OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                         OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                       AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no)
                       AND f.pack_policy_id IS NULL
                       AND (   f.endt_seq_no = 0
                            OR (    f.endt_seq_no > 0
                                AND TRUNC (f.endt_expiry_date) >=
                                                     TRUNC (f.expiry_date)
                               )
                           )
                       AND b.currency_cd = gogi_currency_cd
                  GROUP BY b.currency_cd,
                           c.line_cd,
                           c.tax_cd,
                           d.tax_id,
                           c.iss_cd,
                           d.tax_desc,
                           d.rate,
                           d.peril_sw,
                           e.menu_line_cd,
                           tax_type,
                           tax_amount,
                           f.expiry_date,
                           d.expired_sw
                    UNION
                    --*** union and code below added by jongs to consider other taxes maintained 02.10.2014***
                    SELECT   b.currency_cd, f.line_cd, d.tax_cd,
                             d.tax_id, d.iss_cd, e.menu_line_cd,
                             f.expiry_date, d.tax_desc, d.rate rate,
                             d.peril_sw, tax_type, tax_amount, d.expired_sw, 'Y' is_new
                        FROM gipi_polbasic f,
                             gipi_invoice b,
                             giis_tax_charges d,
                             giis_line e
                       WHERE f.line_cd = a2.line_cd
                         AND f.subline_cd = a2.subline_cd
                         AND f.iss_cd = a2.iss_cd
                         AND f.issue_yy = a2.issue_yy
                         AND f.pol_seq_no = a2.pol_seq_no
                         AND f.renew_no = a2.renew_no
                         AND f.policy_id = b.policy_id
                         AND f.line_cd = d.line_cd
                         AND f.line_cd = e.line_cd
                         AND f.iss_cd = d.iss_cd
                         AND NVL (d.expired_sw, 'N') = 'N'
                         AND d.primary_sw = 'Y'     --jongs 03.10.2014
                         AND f.expiry_date BETWEEN eff_start_date
                                               AND eff_end_date
                         --joanne 02.11.14, replace code above consider summary parameter
                         AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                           OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                           OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                         AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no)
                         AND f.pack_policy_id IS NULL
                         AND (   f.endt_seq_no = 0
                              OR (    f.endt_seq_no > 0
                                  AND TRUNC (f.endt_expiry_date) >=
                                                 TRUNC (f.expiry_date)
                                 )
                             )
                         AND b.currency_cd = gogi_currency_cd
                    GROUP BY b.currency_cd,
                             f.line_cd,
                             d.tax_cd,
                             d.tax_id,
                             d.iss_cd,
                             d.tax_desc,
                             d.rate,
                             d.peril_sw,
                             e.menu_line_cd,
                             tax_type,
                             tax_amount,
                             f.expiry_date,
                             d.expired_sw)
              LOOP
                v_currency_rt := gogi_currency_rt;
                v_is_new      := gpol.is_new; --joanne 051514

                  IF gpol.expired_sw = 'Y'
                  THEN
                     FOR k IN
                        (SELECT tax_id
                           FROM giis_tax_charges
                          WHERE line_cd = gpol.line_cd
                            AND iss_cd = gpol.iss_cd
                            AND tax_cd = gpol.tax_cd
                            AND NVL (expired_sw, 'N') = 'N'
                            AND gpol.expiry_date BETWEEN eff_start_date
                                                     AND eff_end_date)
                     LOOP
                        gpol.tax_id := k.tax_id;
                     END LOOP;
                  END IF;

                 FOR tax IN
                    (SELECT DISTINCT b.tax_cd tax_cd,
                                     NVL (NVL (c.rate, b.rate), 0) rate,
                                     b.tax_id tax_id,
                                     b.tax_type tax_type,
                                     b.tax_amount tax_amount,
                                     b.peril_sw peril_sw,
                                     b.tax_desc tax_desc,
                                     b.no_rate_tag,
                                     b.primary_sw
                                FROM giis_tax_peril a,
                                     giis_tax_charges b,
                                     giis_tax_issue_place c
                               WHERE b.line_cd = gpol.line_cd
                                 AND b.iss_cd(+) = gpol.iss_cd
                                 AND b.tax_cd = gpol.tax_cd
                                 AND b.tax_id = gpol.tax_id
                                 AND b.iss_cd = c.iss_cd(+)
                                 AND b.line_cd = c.line_cd(+)
                                 AND b.tax_cd = c.tax_cd(+)
                                 AND c.place_cd(+) = v_place_cd
                                 AND (   (    gpol.expiry_date
                                                 BETWEEN b.eff_start_date
                                                     AND b.eff_end_date
                                          AND NVL (b.issue_date_tag, 'N') =
                                                                       'N'
                                         )
                                      OR ( /*pol.issue_date*/     gpol.expiry_date
                                                                     BETWEEN b.eff_start_date
                                                                         AND b.eff_end_date
                                                              AND NVL
                                                                     (b.issue_date_tag,
                                                                      'N'
                                                                     ) =
                                                                       'Y'
                                         )
                                     ))
                 LOOP
                    --joanne 051514
                    v_tax_type      := tax.tax_type;
                    v_rate          := tax.rate;
                    v_primary_sw    := tax.primary_sw;
                    v_cancelled     := '';

                    IF v_endt_tax = 'Y' THEN
                        FOR cancl IN (SELECT SUM (b.tax_amt) tax_amt
                                       FROM gipi_invoice a,
                                            gipi_inv_tax b,
                                            gipi_polbasic c
                                      WHERE a.iss_cd = b.iss_cd
                                        AND a.prem_seq_no = b.prem_seq_no
                                        AND a.policy_id = c.policy_id
                                        AND c.line_cd =a2.line_cd
                                        AND c.subline_cd = a2.subline_cd
                                        AND c.iss_cd = a2.iss_cd
                                        AND c.issue_yy = a2.issue_yy
                                        AND c.pol_seq_no = a2.pol_seq_no
                                        AND c.renew_no = a2.renew_no
                                        AND b.tax_cd = tax.tax_cd
                                        AND (   c.endt_seq_no = 0
                                             OR (    c.endt_seq_no > 0
                                                 AND TRUNC (c.endt_expiry_date) >=
                                                         TRUNC (c.expiry_date)
                                                )
                                            ))
                        LOOP
                            IF cancl.tax_amt = 0 THEN
                                v_cancelled := 'Y';
                            END IF;
                        END LOOP;
                    END IF;

                    IF tax.tax_cd = giacp.n ('DOC_STAMPS')
                    THEN                           --docstamp computation
                       IF     tax.tax_type = 'N'
                          AND (   gpol.menu_line_cd = 'AC'
                               OR gpol.line_cd = 'AC'
                              )
                          AND giisp.v ('COMPUTE_PA_DOC_STAMPS') = '3'
                       THEN
                          FOR gtr IN
                             (SELECT tax_amount
                                FROM giis_tax_range
                               WHERE line_cd = gpol.line_cd
                                 AND iss_cd = gpol.iss_cd
                                 AND tax_cd = tax.tax_cd
                                 AND tax_id = tax.tax_id
                                 --AND (gogi_ren_tsi_amt * v_currency_rt --gogi.currency_rt
                                 AND (gogi_ren_tsi_amt2 * v_currency_rt --Dren 12.02.2015 SR-0020832 : Error in Doc Stamps Tax for PA
                                     ) BETWEEN min_value AND max_value)
                          LOOP
                             v_depr_tax_amt := gtr.tax_amount;
                             v_curr_tax_amt :=
                                        gtr.tax_amount / v_currency_rt; --gogi.currency_rt;
                          END LOOP;
                       ELSE
                          IF (   gpol.menu_line_cd = 'AC'
                              OR gpol.line_cd = 'AC'
                             )
                          THEN
                             IF giisp.v ('COMPUTE_PA_DOC_STAMPS') = '2'
                             THEN
                                v_depr_tax_amt :=
                                   CEIL    (  ( gogi_ren_prem_amt
                                        --(  (  (  gogi_ren_prem_amt     Gzelle 06232015 SR3917                                 
                                               --* gogi_currency_rt
                                              )
                                            / 200
                                           )
                                         * 0.5
                                         * gogi_currency_rt;
                                        --)* gogi_currency_rt;      Gzelle 06232015 SR3917                                         
                                v_curr_tax_amt :=
                                   --CEIL (((gogi_ren_prem_amt) / 200) * 0.5);      Gzelle 06232015 SR3917
                                   CEIL (gogi_ren_prem_amt / 200) * 0.5;
                             ELSIF  giisp.v ('COMPUTE_PA_DOC_STAMPS') = '1' THEN   --start Gzelle 07072015 SR3917 
                               IF tax.peril_sw = 'Y'
                               THEN
                                  FOR perl IN
                                     (SELECT SUM (a.ren_prem_amt) ren_prem_amt
                                        FROM giex_old_group_itmperil a, giis_tax_peril b
                                       WHERE a.line_cd = b.line_cd
                                         AND a.peril_cd = b.peril_cd
                                         AND a.policy_id = a2.policy_id
                                         AND b.tax_cd = tax.tax_cd
                                         AND b.line_cd = gpol.line_cd
                                         AND b.iss_cd = gpol.iss_cd
                                         AND b.tax_id = tax.tax_id)
                                  LOOP
                                     v_depr_tax_amt := (NVL(perl.ren_prem_amt,0) * (tax.rate / 100)) * gogi_currency_rt;
                                     v_curr_tax_amt := NVL(perl.ren_prem_amt,0) * (tax.rate / 100);
                                  END LOOP;
                               ELSE
                                  v_depr_tax_amt := (gogi_ren_prem_amt * (tax.rate / 100))* gogi_currency_rt;
                                  v_curr_tax_amt := gogi_ren_prem_amt * (tax.rate / 100);
                               END IF;                          --end Gzelle 07072015 SR3917
                             ELSE
                                IF giisp.v ('COMPUTE_OLD_DOC_STAMPS') =
                                                                      'Y'
                                THEN
                                   v_depr_tax_amt :=
                                      CEIL    (  (  gogi_ren_prem_amt
                                           --(  (  (  gogi_ren_prem_amt      Gzelle 06232015 SR3917
                                                  --* gogi_currency_rt
                                                 )
                                               / 200
                                              )
                                            * 0.5
                                            * gogi_currency_rt;
                                           --)* gogi_currency_rt;   Gzelle 06232015 SR3917
                                   v_curr_tax_amt :=
                                      CEIL   ((gogi_ren_prem_amt) / 200
                                           --(  ((gogi_ren_prem_amt) / 200   Gzelle 06232015 SR3917 
                                              )
                                            * 0.5;
                                           --);   Gzelle 06232015 SR3917
                                ELSE
                                   IF tax.peril_sw = 'Y'
                                   THEN
                                      FOR perl IN
                                         (SELECT SUM
                                                    (a.ren_prem_amt
                                                    ) ren_prem_amt
                                            FROM giex_old_group_itmperil a,
                                                 giis_tax_peril b
                                           WHERE a.line_cd = b.line_cd
                                             AND a.peril_cd = b.peril_cd
                                             AND a.policy_id =
                                                              a2.policy_id
                                             AND b.tax_cd = tax.tax_cd
                                             AND b.line_cd = gpol.line_cd
                                             AND b.iss_cd = gpol.iss_cd
                                             AND b.tax_id = tax.tax_id)
                                      LOOP
                                         v_depr_tax_amt :=
                                              ((  perl.ren_prem_amt
                                               --* gogi_currency_rt
                                              )
                                            * (tax.rate / 100))* gogi_currency_rt;
                                         v_curr_tax_amt :=
                                              perl.ren_prem_amt
                                            * (tax.rate / 100);
                                      END LOOP;
                                   ELSE
                                      v_depr_tax_amt :=
                                           ((  gogi_ren_prem_amt
                                            --* gogi_currency_rt
                                           )
                                         * (tax.rate / 100))* gogi_currency_rt;
                                      v_curr_tax_amt :=
                                           gogi_ren_prem_amt
                                         * (tax.rate / 100);
                                   END IF;
                                END IF;
                             END IF;
                          ELSE           --Non-PA computation of docstamps
                             IF giisp.v ('COMPUTE_OLD_DOC_STAMPS') = 'Y'
                             THEN
                                v_depr_tax_amt :=
                                   CEIL    (  (  gogi_ren_prem_amt
                                        --(  (  (  gogi_ren_prem_amt   Gzelle 06232015 SR3917
                                              -- * gogi_currency_rt
                                              )
                                            / 4
                                           )
                                         * 0.5
                                         * gogi_currency_rt;
                                        --)* gogi_currency_rt;  Gzelle 06232015 SR3917
                                v_curr_tax_amt :=
                                    --CEIL (((gogi_ren_prem_amt) / 4) * 0.5);   Gzelle 06232015 SR3917
                                    CEIL (gogi_ren_prem_amt / 4) * 0.5;
                             ELSE
                                IF tax.peril_sw = 'Y'
                                THEN
                                   FOR perl IN
                                      (SELECT SUM
                                                 (a.ren_prem_amt
                                                 ) ren_prem_amt
                                         FROM giex_old_group_itmperil a,
                                              giis_tax_peril b
                                        WHERE a.line_cd = b.line_cd
                                          AND a.peril_cd = b.peril_cd
                                          AND a.policy_id = a2.policy_id
                                          AND b.tax_cd = tax.tax_cd
                                          AND b.line_cd = gpol.line_cd
                                          AND b.iss_cd = gpol.iss_cd
                                          AND b.tax_id = tax.tax_id)
                                   LOOP
                                      v_depr_tax_amt :=
                                           ((  perl.ren_prem_amt
                                            --* gogi_currency_rt
                                           )
                                         * (tax.rate / 100))* gogi_currency_rt;
                                      v_curr_tax_amt :=
                                           perl.ren_prem_amt
                                         * (tax.rate / 100);
                                   END LOOP;
                                ELSE
                                   v_depr_tax_amt :=
                                        ((  gogi_ren_prem_amt
                                         --* gogi_currency_rt
                                        )
                                      * (tax.rate / 100))* gogi_currency_rt;
                                   v_curr_tax_amt :=
                                      gogi_ren_prem_amt
                                      * (tax.rate / 100);
                                END IF;
                             END IF;
                          END IF;
                       END IF;
                    ELSIF tax.tax_cd = giacp.n ('EVAT')
                    THEN                                --EVAT computation
                       IF v_vat_tag IN ('1', '2')
                       THEN
                          v_depr_tax_amt := 0;
                          v_curr_tax_amt := 0;
                       ELSE
                          IF tax.peril_sw = 'Y'
                          THEN
                             FOR perl IN
                                (SELECT SUM (a.ren_prem_amt)
                                                            ren_prem_amt
                                   FROM giex_old_group_itmperil a,
                                        giis_tax_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND a.policy_id = a2.policy_id
                                    AND b.tax_cd = tax.tax_cd
                                    AND b.line_cd = gpol.line_cd
                                    AND b.iss_cd = gpol.iss_cd
                                    AND b.tax_id = tax.tax_id)
                             LOOP
                                v_depr_tax_amt :=
                                    ( (perl.ren_prem_amt --* gogi_currency_rt
                                     )
                                   * (tax.rate / 100))* gogi_currency_rt;
                                v_curr_tax_amt :=
                                      perl.ren_prem_amt
                                      * (tax.rate / 100);
                             END LOOP;
                          ELSE
                             v_depr_tax_amt :=
                                  ((gogi_ren_prem_amt --* gogi_currency_rt
                                  )
                                * (tax.rate / 100))* gogi_currency_rt;
                             v_curr_tax_amt :=
                                      gogi_ren_prem_amt
                                      * (tax.rate / 100);
                          END IF;
                       END IF;
                    ELSE                          --other tax computations
                       IF tax.tax_type = 'A'
                       THEN
                          v_depr_tax_amt := tax.tax_amount;
                          v_curr_tax_amt := tax.tax_amount / v_currency_rt;
                       ELSIF tax.tax_type = 'N'
                       THEN
                          v_depr_tax_amt := 0;
                          v_curr_tax_amt := 0;

                          IF (   gpol.menu_line_cd = 'AC'
                              OR gpol.line_cd = 'AC'
                             )
                          THEN
                             FOR gtr IN
                                (SELECT tax_amount
                                   FROM giis_tax_range
                                  WHERE line_cd = gpol.line_cd
                                    AND iss_cd = gpol.iss_cd
                                    AND tax_cd = tax.tax_cd
                                    AND tax_id = tax.tax_id
                                    AND (  gogi_ren_tsi_amt
                                         * v_currency_rt --gogi.currency_rt
                                        ) BETWEEN min_value AND max_value)
                             LOOP
                                v_depr_tax_amt := gtr.tax_amount;
                                v_curr_tax_amt :=
                                        gtr.tax_amount / v_currency_rt /*gogi.currency_rt */;
                             END LOOP;
                          ELSE
                             FOR gtr IN
                                (SELECT tax_amount
                                   FROM giis_tax_range
                                  WHERE line_cd = gpol.line_cd
                                    AND iss_cd = gpol.iss_cd
                                    AND tax_cd = tax.tax_cd
                                    AND tax_id = tax.tax_id
                                    AND (  gogi_ren_prem_amt
                                         * v_currency_rt --gogi.currency_rt
                                        ) BETWEEN min_value AND max_value)
                             LOOP
                                v_depr_tax_amt := gtr.tax_amount;
                                v_curr_tax_amt :=
                                        gtr.tax_amount / v_currency_rt /*gogi.currency_rt */;
                             END LOOP;
                          END IF;
                       ELSE
                          IF tax.peril_sw = 'Y'
                          THEN
                             FOR perl IN
                                (SELECT SUM (a.ren_prem_amt)
                                                            ren_prem_amt
                                   FROM giex_old_group_itmperil a,
                                        giis_tax_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND a.policy_id = a2.policy_id
                                    AND b.tax_cd = tax.tax_cd
                                    AND b.line_cd = gpol.line_cd
                                    AND b.iss_cd = gpol.iss_cd
                                    AND b.tax_id = tax.tax_id)
                             LOOP
                                /** jongs 04.01.2014 */
                                 IF tax.tax_type = 'R' AND tax.rate = 0 AND tax.no_rate_tag='Y'
                                 THEN
                                    FOR t IN
                                       (SELECT SUM (b.tax_amt) tax_amt
                                          FROM gipi_invoice a,
                                               gipi_inv_tax b,
                                               gipi_polbasic c
                                         WHERE a.iss_cd = b.iss_cd
                                           AND a.prem_seq_no = b.prem_seq_no
                                           AND a.policy_id = c.policy_id
                                           AND c.line_cd = a2.line_cd
                                           AND c.subline_cd = a2.subline_cd
                                           AND c.iss_cd = a2.iss_cd
                                           AND c.issue_yy = a2.issue_yy
                                           AND c.pol_seq_no = a2.pol_seq_no
                                           AND c.renew_no = a2.renew_no
                                           AND b.tax_cd = tax.tax_cd
                                           --AND b.tax_id = tax.tax_id
                                           AND (   c.endt_seq_no = 0
                                                OR (    c.endt_seq_no > 0
                                                    AND TRUNC
                                                           (c.endt_expiry_date) >=
                                                           TRUNC
                                                                (c.expiry_date)
                                                   )
                                               ))
                                    LOOP
                                       v_depr_tax_amt :=
                                                 t.tax_amt * gogi_currency_rt;
                                       v_curr_tax_amt := t.tax_amt;
                                    END LOOP;
                                 /** end jongs 04.01.2014 */
                                 ELSE
                                    v_depr_tax_amt :=
                                         ((perl.ren_prem_amt --* gogi_currency_rt
                                         )
                                       * (tax.rate / 100))* gogi_currency_rt;
                                    v_curr_tax_amt :=
                                          perl.ren_prem_amt
                                          * (tax.rate / 100);
                                 END IF;
                             END LOOP;
                          ELSE
                            /** jongs 04.01.2014 */
                              IF tax.tax_type = 'R' AND tax.rate = 0 AND tax.no_rate_tag='Y'
                              THEN
                                 FOR t IN
                                    (SELECT SUM (b.tax_amt) tax_amt
                                       FROM gipi_invoice a,
                                            gipi_inv_tax b,
                                            gipi_polbasic c
                                      WHERE a.iss_cd = b.iss_cd
                                        AND a.prem_seq_no = b.prem_seq_no
                                        AND a.policy_id = c.policy_id
                                        AND c.line_cd = a2.line_cd
                                        AND c.subline_cd = a2.subline_cd
                                        AND c.iss_cd = a2.iss_cd
                                        AND c.issue_yy = a2.issue_yy
                                        AND c.pol_seq_no = a2.pol_seq_no
                                        AND c.renew_no = a2.renew_no
                                        AND b.tax_cd = tax.tax_cd
                                        --AND b.tax_id = tax.tax_id
                                        AND (   c.endt_seq_no = 0
                                             OR (    c.endt_seq_no > 0
                                                 AND TRUNC (c.endt_expiry_date) >=
                                                         TRUNC (c.expiry_date)
                                                )
                                            ))
                                 LOOP
                                    v_depr_tax_amt :=
                                                 t.tax_amt * gogi_currency_rt;
                                    v_curr_tax_amt := t.tax_amt;
                                 END LOOP;
                              /** jongs 04.01.2014 */
                              ELSE
                                 v_depr_tax_amt :=
                                      ((gogi_ren_prem_amt --* gogi_currency_rt
                                      )
                                    * (tax.rate / 100))* gogi_currency_rt;
                                 v_curr_tax_amt :=
                                          gogi_ren_prem_amt
                                          * (tax.rate / 100);
                              END IF;
                          END IF;
                       END IF;
                    END IF;

                    --inserting and updating
                    BEGIN
                       SELECT COUNT (*)
                         INTO v_count
                         FROM giex_old_group_tax
                        WHERE policy_id = a2.policy_id
                          AND line_cd = gpol.line_cd
                          AND iss_cd = gpol.iss_cd
                          AND tax_cd = tax.tax_cd
                          AND tax_id = tax.tax_id;
                    END;

                    IF v_count = 0
                    THEN
                        IF (tax.tax_cd = giacp.n ('EVAT') AND v_vat_tag = 1)
                        THEN
                           NULL;
                        ELSE
                           IF (      v_depr_tax_amt > 0
                                  OR v_curr_tax_amt > 0
                                  OR (    tax.tax_cd = giacp.n ('EVAT')
                                      AND v_vat_tag = 2
                                     )
                                  OR (    v_tax_type = 'R'
                                      AND v_rate = 0
                                      AND v_primary_sw = 'Y'
                                      AND v_is_new = 'Y'
                                     )
                                  OR (    tax.tax_cd = giacp.n ('DOC_STAMPS')   --start Gzelle 07082015 SR3917
                                      AND v_param_pa_doc = '1'
                                      AND v_primary_sw = 'Y'
                                     )                                          --end
                               )
                              AND NVL(v_cancelled,'N') = 'N'
                           THEN
                               INSERT INTO giex_old_group_tax
                                           (policy_id, line_cd,
                                            iss_cd, tax_cd, tax_id,
                                            tax_desc, tax_amt,
                                            currency_tax_amt
                                           )
                                    VALUES (a2.policy_id, gpol.line_cd,
                                            gpol.iss_cd, tax.tax_cd, tax.tax_id,
                                            tax.tax_desc, v_depr_tax_amt,
                                            v_curr_tax_amt
                                           );
                           END IF;
                        END IF;
                    ELSE
                       --IF tax.tax_type != 'A' THEN --added by joanne 03272014, so that fixed amt taxes will not sum up per peril
                       IF (tax.tax_cd = giacp.n ('EVAT') AND v_vat_tag = 1)
                        THEN
                           NULL;
                        ELSE
                           UPDATE giex_old_group_tax
                              SET tax_amt =
                                       v_depr_tax_amt
                                     /*+ NVL (giex_old_group_tax.tax_amt, 0)*/,
                                  currency_tax_amt =
                                       v_curr_tax_amt
                                     /*+ NVL
                                          (giex_old_group_tax.currency_tax_amt,
                                           0
                                          )*/
                            WHERE policy_id = a2.policy_id
                              AND line_cd = gpol.line_cd
                              AND iss_cd = gpol.iss_cd
                              AND tax_cd = tax.tax_cd
                              AND tax_id = tax.tax_id;
                       END IF;
                    END IF;

                    v_depr_tax_amt := 0;
                    v_curr_tax_amt := 0;
                 END LOOP;                                       --end tax
              END LOOP;                                  --end policy info
            --END LOOP;                        --end  giex_old_group_itmperil
            END;
            /*End by: Joanne, 042314, apply changes in tax from CS*/

            /*Added by; Joanne
            **Date: 043014
            **Desc: Update tax_amt in GIEX_EXPIRY base on amounts in giex_old_group_tax*/
            FOR tax IN (SELECT SUM(tax_amt) total_tax_amt
                            FROM giex_old_group_tax
                         WHERE policy_id = a2.policy_id )
            LOOP
                UPDATE giex_expiry
                    SET tax_amt = tax.total_tax_amt
                  WHERE policy_id = a2.policy_id;
            END LOOP;

            --============================================ end edgar nobleza 07/25/2013 ===========================================================
			/*JOANNE consolidate all changes in process_expiring policies modification by edgar tax, 112813 end*/

            /*JOANNE consolidate all changes in process_expiring policies modification by mam jhing depreciated amts, 112813 start*/
            -- jhing 07.20.2013 commented out....
            -- dapat ung depreciated amounts na ung titingnan ng giex_expiry ren_tsi amounts
            -- di na xa magquery sa gipi_itmperil
			/*   FOR a8x IN (
					SELECT SUM(A.prem_amt * C.currency_rt) prem_amt2,
						   SUM(A.tsi_amt * C.currency_rt) tsi_amt2,
						   A.line_cd, A.peril_cd,d.peril_type peril_type
					  FROM GIPI_ITMPERIL A,
						   GIPI_POLBASIC b,
						   GIPI_ITEM     C,
						   GIIS_PERIL d
					 WHERE b.line_cd         = a2.line_cd
					   AND b.subline_cd      = a2.subline_cd
					   AND b.iss_cd          = a2.iss_cd
					   AND b.issue_yy        = a2.issue_yy
					   AND b.pol_seq_no      = a2.pol_seq_no
					   AND b.renew_no        = a2.renew_no
					   AND d.peril_cd        = A.peril_cd
					   AND d.line_cd         = A.line_cd
					   AND A.policy_id       = b.policy_id
					   AND b.policy_id       = C.policy_id
					   AND A.policy_id       = b.policy_id
					   AND A.item_no         = C.item_no
					   AND b.pol_flag        IN('1','2','3')
					   AND b.pack_policy_id IS NULL
					   AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
					   AND ( b.endt_seq_no = 0
							 OR (b.endt_seq_no > 0
								 AND TRUNC(b.endt_expiry_date) >= TRUNC(b.expiry_date)))
					  GROUP BY A.peril_cd, A.line_cd, d.peril_type)
				LOOP
					o_prem_amt2     := a8x.prem_amt2;
					o_tsi_amt2      := a8x.tsi_amt2;

					IF a8x.peril_type = 'B' THEN
						v_total_dep_tsi  := NVL(v_total_dep_tsi,0) + o_tsi_amt2;
					END IF;

					v_total_dep_prm     := NVL(v_total_dep_prm,0) + o_prem_amt2;
				END LOOP;

			   UPDATE GIEX_EXPIRY
				  SET tsi_amt = v_total_dep_tsi,
					  prem_amt = v_total_dep_prm,
					  ren_tsi_amt = v_total_ren_tsi,
					  ren_prem_amt = v_total_ren_prm,
					  currency_prem_amt = v_total_currency_prm
				WHERE policy_id = a2.policy_id;
				*/
                -- jhing 07.2013 query renewal tsi / prem based on giex_old_group_itmperil
                v_total_renewal_tsi := 0;
                v_total_renewal_prem := 0;
                v_total_orig_tsi := 0;
                v_total_orig_prem := 0;
                v_total_currency_tsi1 := 0;
                v_total_currency_prem1 := 0;
                v_policy_orig_tsi := 0; --joanne 052914

                FOR cur_old_itmperil IN (SELECT a.prem_rt, a.tsi_amt, a.prem_amt,
                                                a.ren_tsi_amt, a.ren_prem_amt,
                                                a.currency_rt, b.peril_type
                                           FROM giex_old_group_itmperil a,
                                                giis_peril b
                                          WHERE a.line_cd = b.line_cd
                                            AND a.peril_cd = b.peril_cd
                                            AND a.policy_id = a2.policy_id)
                LOOP
                   IF cur_old_itmperil.peril_type = 'B'
                   THEN
                      v_total_renewal_tsi :=
                           v_total_renewal_tsi
                         + (  cur_old_itmperil.ren_tsi_amt
                            * cur_old_itmperil.currency_rt
                           );
                      v_total_orig_tsi :=
                           v_total_orig_tsi
                         + (cur_old_itmperil.tsi_amt
                            * cur_old_itmperil.currency_rt
                           );
                   --  v_total_currency_tsi1 := v_total_currency_tsi1 + cur_old_itmperil.tsi_amt ;
                   END IF;

                   v_total_renewal_prem :=
                        v_total_renewal_prem
                      + (  cur_old_itmperil.ren_prem_amt
                         * cur_old_itmperil.currency_rt
                        );
                   v_total_orig_prem :=
                        v_total_orig_prem
                      + (cur_old_itmperil.prem_amt * cur_old_itmperil.currency_rt
                        );
                   v_total_currency_prem1 :=
                                v_total_currency_prem1 + cur_old_itmperil.ren_prem_amt; --cur_old_itmperil.prem_amt; modified by joanne 052814
                END LOOP;

                --added by joanne 052914, to update orig_tsi_amt in GIEX_EXPIRY base from total amts in GIEX_OLD_GROUP_PERIL
                SELECT SUM(orig_tsi_amt)
                    INTO v_policy_orig_tsi
                   FROM giex_old_group_peril a,
                        giis_peril b
                      WHERE a.policy_id = a2.policy_id
                       AND a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.peril_type = 'B';

                UPDATE giex_expiry
                   SET tsi_amt = v_total_orig_tsi,
                       prem_amt = v_total_orig_prem,
                       ren_tsi_amt = v_total_renewal_tsi,
                       ren_prem_amt = v_total_renewal_prem,
                       currency_prem_amt = v_total_currency_prem1,
                       orig_tsi_amt = v_policy_orig_tsi --added by joanne 052914
                 WHERE policy_id = a2.policy_id;

                -- end jhing 07.20.2013 new code for updating giex_expiry renewal tsi , ren prem and original prem and tsi
                /*JOANNE consolidate all changes in process_expiring policies modification by mam jhing depreciated amts, 112813 end*/

                /*JOANNE consolidate all changes in process_expiring policies modification by edgar deductible, 112813 start*/
				/* start of consolidation; apply deductible enhancement - cherrie 12052012 */
				/* added by: udel
				** date: 06212011
				** uw-specs-2011-00026
				** if parameter include_deductible_expiry is set to y, it will check if
				** the deductible rate and amount are more than zero. if yes, the selected columns
				** will be inserted into giex_old_group_deductibles table.
				*/
				/*
                --commented out by Edgar Nobleza 7/25/2013
                IF NVL (giisp.v ('INCLUDE_DEDUCTIBLE_EXPIRY'), 'N') = 'Y'
					THEN
					   FOR ded_cur
					   IN (  SELECT A.item_no,
									A.peril_cd,
									A.ded_deductible_cd,
									b.line_cd,
									b.subline_cd,
									SUM (A.deductible_rt) deductible_rt,
									SUM (A.deductible_amt) deductible_amt
							   FROM gipi_deductibles A, gipi_polbasic b
							  WHERE 1 = 1
								AND b.policy_id = A.policy_id
								AND b.pol_flag IN ('1', '2', '3')
								AND b.pack_policy_id IS NULL
								AND NVL (b.reg_policy_sw, 'N') =
										DECODE (NVL (inc_special_sw, 'N'),
													'N', 'Y',
													NVL (b.reg_policy_sw, 'N'))
								AND (b.endt_seq_no = 0
									   OR (b.endt_seq_no > 0
										   AND TRUNC (b.endt_expiry_date) >=
													 TRUNC (b.expiry_date)))
								AND b.line_cd = a2.line_cd
								AND b.subline_cd = a2.subline_cd
								AND b.iss_cd = a2.iss_cd
								AND b.issue_yy = a2.issue_yy
								AND b.pol_seq_no = a2.pol_seq_no
								AND b.renew_no = a2.renew_no
						      GROUP BY A.item_no, A.peril_cd, A.ded_deductible_cd,
									  b.line_cd, b.subline_cd, b.eff_date, b.endt_seq_no
						      ORDER BY   b.eff_date DESC, b.endt_seq_no)
					   LOOP
						  IF ded_cur.deductible_rt >= 0 OR ded_cur.deductible_amt >= 0
						  THEN
							 INSERT INTO giex_old_group_deductibles ( policy_id,
														item_no, peril_cd, ded_deductible_cd,
														line_cd, subline_cd, deductible_rt, deductible_amt )
							   VALUES   (v_pol_id, ded_cur.item_no, ded_cur.peril_cd, ded_cur.ded_deductible_cd,
										 ded_cur.line_cd, ded_cur.subline_cd, ded_cur.deductible_rt,
										 ded_cur.deductible_amt);
						  END IF;
					   END LOOP;
					END IF;
				 /* end udel 06212011 */
				 /* end of consolidation - cherrie 12052012 */
                 --ended comment oout edgar nobleza 07/25/2013

           --=================================edgar nobleza 7/25/2013 new code for computing deductibles ==================================
            DECLARE
               v_tsi_amt          giex_old_group_itmperil.ren_tsi_amt%TYPE;
               v_itm_tsi_amt      giex_old_group_itmperil.ren_tsi_amt%TYPE;
               v_perl_tsi_amt     giex_old_group_itmperil.ren_tsi_amt%TYPE;
               v_ded_amt          giex_old_group_deductibles.deductible_amt%TYPE;
               v_deductible_amt   giex_old_group_deductibles.deductible_amt%TYPE;
            BEGIN
               IF NVL (giisp.v ('INCLUDE_DEDUCTIBLE_EXPIRY'), 'N') = 'Y'
               THEN
                  --comment out by joanne 052814, replace by code below, should only include basic peril
                  /*SELECT SUM (ren_tsi_amt)
                    INTO v_tsi_amt
                    FROM giex_old_group_itmperil
                   WHERE policy_id = a2.policy_id;*/
                  SELECT SUM (ren_tsi_amt * currency_rt)
                    --joanne 052914 added currency_rt
                    INTO v_tsi_amt
                    FROM giex_old_group_itmperil a,
                         giis_peril b
                      WHERE a.policy_id = a2.policy_id
                       AND a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.peril_type = 'B';

                  ---POLICY LEVEL computation of deductible amount-----
                  FOR pol IN (SELECT a.item_no item_no, a.peril_cd peril_cd,
                                     a.ded_line_cd, a.ded_subline_cd,
                                     a.ded_deductible_cd, b.deductible_rt,
                                     b.deductible_amt, b.ded_type, b.min_amt,
                                     b.max_amt, b.range_sw
                                FROM gipi_deductibles a,
                                     giis_deductible_desc b
                               WHERE a.ded_line_cd = b.line_cd
                                 AND a.ded_subline_cd = b.subline_cd
                                 AND a.ded_deductible_cd = b.deductible_cd
                                 --AND a.policy_id = a2.policy_id
                                 AND a.policy_id IN (SELECT policy_id
                                                      FROM gipi_polbasic
                                                     WHERE line_cd = a2.line_cd
                                                       AND subline_cd = a2.subline_cd
                                                       AND iss_cd = a2.iss_cd
                                                       AND issue_yy = a2.issue_yy
                                                       AND pol_seq_no = a2.pol_seq_no
                                                       AND renew_no = a2.renew_no
                                                       --AND pol_flag IN ('1', '2', '3')) --joanne
                                                       --joanne 02.11.14, replace code above consider summary parameter
                                                       AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                                                         OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                                                         OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                                                       AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no))
                                 AND a.item_no = 0
                                 AND a.peril_cd = 0)
                  LOOP
                     IF pol.ded_type = 'F'
                     THEN
                        v_deductible_amt := pol.deductible_amt;
                     ELSIF pol.ded_type = 'T'
                     THEN
                        v_ded_amt :=
                                v_tsi_amt
                                * (NVL (pol.deductible_rt, 0) / 100);

                        IF     pol.deductible_rt IS NOT NULL
                           AND pol.min_amt IS NOT NULL
                           AND pol.max_amt IS NOT NULL
                        THEN
                           IF pol.range_sw = 'H'
                           THEN
                              v_ded_amt := GREATEST (v_ded_amt, pol.min_amt);
                              v_deductible_amt :=
                                               LEAST (v_ded_amt, pol.max_amt);
                           ELSIF pol.range_sw = 'L'
                           THEN
                              v_ded_amt := LEAST (v_ded_amt, pol.min_amt);
                              v_deductible_amt :=
                                               LEAST (v_ded_amt, pol.max_amt);
                           ELSE
                              v_deductible_amt := pol.max_amt;
                           END IF;
                        ELSIF     pol.deductible_rt IS NOT NULL
                              AND pol.min_amt IS NOT NULL
                        THEN
                           v_deductible_amt :=
                                            GREATEST (v_ded_amt, pol.min_amt);
                        ELSIF     pol.deductible_rt IS NOT NULL
                              AND pol.max_amt IS NOT NULL
                        THEN
                           v_deductible_amt := LEAST (v_ded_amt, pol.max_amt);
                        ELSE
                           IF pol.deductible_rt IS NOT NULL
                           THEN
                              v_deductible_amt := v_ded_amt;
                           ELSIF pol.min_amt IS NOT NULL
                           THEN
                              v_deductible_amt := pol.min_amt;
                           ELSIF pol.max_amt IS NOT NULL
                           THEN
                              v_deductible_amt := pol.max_amt;
                           END IF;
                        END IF;
                     END IF;


                       /*** added by jongs to prevent ora-00001 10232013 ***/
                         SELECT COUNT(*)
                           INTO v_cnt_deducs
                           FROM giex_old_group_deductibles
                          WHERE policy_id = a2.policy_id
                            AND item_no = pol.item_no
                            AND peril_cd = pol.peril_cd
                            AND ded_deductible_cd = pol.ded_deductible_cd;
                      /*** end jongs 10232013 ***/

                     IF v_cnt_deducs = 0 THEN

                     INSERT INTO giex_old_group_deductibles
                                 (policy_id, item_no, peril_cd,
                                  ded_deductible_cd, line_cd,
                                  subline_cd, deductible_rt,
                                  deductible_amt
                                 )
                          VALUES (a2.policy_id, pol.item_no, pol.peril_cd,
                                  pol.ded_deductible_cd, pol.ded_line_cd,
                                  pol.ded_subline_cd, pol.deductible_rt,
                                  v_deductible_amt
                                 );
                     END IF;

                     v_cnt_deducs := 0;
                     v_deductible_amt := 0;
                     v_ded_amt := 0;
                  END LOOP;

                  ------- ITEM LEVEL computation of deductible amount------------
                  FOR item IN (SELECT   a.item_no,
                                        SUM (a.ren_tsi_amt * currency_rt) ren_tsi_amt
                                        --joanne 052914 added currency_rt
                                   FROM giex_old_group_itmperil a,
                                        giis_peril b
                                  WHERE a.policy_id = a2.policy_id
                                    AND a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND b.peril_type = 'B'
                               GROUP BY a.item_no
                               ORDER BY a.item_no)
                  LOOP
                     v_itm_tsi_amt := item.ren_tsi_amt;

                     FOR deduc IN (SELECT a.item_no, a.peril_cd,
                                          a.ded_line_cd, a.ded_subline_cd,
                                          a.ded_deductible_cd,
                                          b.deductible_rt, b.deductible_amt,
                                          b.ded_type, b.min_amt, b.max_amt,
                                          b.range_sw
                                     FROM gipi_deductibles a,
                                          giis_deductible_desc b
                                    WHERE a.ded_line_cd = b.line_cd
                                      AND a.ded_subline_cd = b.subline_cd
                                      AND a.ded_deductible_cd =
                                                               b.deductible_cd
                                      --AND a.policy_id = a2.policy_id
                                     AND a.policy_id IN (SELECT policy_id
                                                          FROM gipi_polbasic
                                                         WHERE line_cd = a2.line_cd
                                                           AND subline_cd = a2.subline_cd
                                                           AND iss_cd = a2.iss_cd
                                                           AND issue_yy = a2.issue_yy
                                                           AND pol_seq_no = a2.pol_seq_no
                                                           AND renew_no = a2.renew_no
                                                           --AND pol_flag IN ('1', '2', '3')) --joanne
                                                           --joanne 02.11.14, replace code above consider summary parameter
                                                           AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                                                             OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                                                             OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                                                           AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no))
                                      AND a.item_no = item.item_no
                                      AND a.peril_cd = 0)
                     LOOP
                        v_ded_amt :=
                             v_itm_tsi_amt
                           * (NVL (deduc.deductible_rt, 0) / 100);

                        IF deduc.ded_type = 'F'
                        THEN
                           v_deductible_amt := deduc.deductible_amt;
                        ELSIF deduc.ded_type = 'T'
                        THEN
                           IF     deduc.deductible_rt IS NOT NULL
                              AND deduc.min_amt IS NOT NULL
                              AND deduc.max_amt IS NOT NULL
                           THEN
                              IF deduc.range_sw = 'H'
                              THEN
                                 v_ded_amt :=
                                          GREATEST (v_ded_amt, deduc.min_amt);
                                 v_deductible_amt :=
                                             LEAST (v_ded_amt, deduc.max_amt);
                              ELSIF deduc.range_sw = 'L'
                              THEN
                                 v_ded_amt :=
                                             LEAST (v_ded_amt, deduc.min_amt);
                                 v_deductible_amt :=
                                             LEAST (v_ded_amt, deduc.max_amt);
                              ELSE
                                 v_deductible_amt := deduc.max_amt;
                              END IF;
                           ELSIF     deduc.deductible_rt IS NOT NULL
                                 AND deduc.min_amt IS NOT NULL
                           THEN
                              v_deductible_amt :=
                                          GREATEST (v_ded_amt, deduc.min_amt);
                           ELSIF     deduc.deductible_rt IS NOT NULL
                                 AND deduc.max_amt IS NOT NULL
                           THEN
                              v_deductible_amt :=
                                             LEAST (v_ded_amt, deduc.max_amt);
                           ELSE
                              IF deduc.deductible_rt IS NOT NULL
                              THEN
                                 v_deductible_amt := v_ded_amt;
                              ELSIF deduc.min_amt IS NOT NULL
                              THEN
                                 v_deductible_amt := deduc.min_amt;
                              ELSIF deduc.max_amt IS NOT NULL
                              THEN
                                 v_deductible_amt := deduc.max_amt;
                              END IF;
                           END IF;
                        ELSIF deduc.ded_type = 'L'
                        THEN
                           v_deductible_amt := NULL;
                        ELSIF deduc.ded_type = 'I'
                        THEN
                           v_deductible_amt := NULL;
                        END IF;

                       /*** added by jongs to prevent ora-00001 10232013 ***/
                         SELECT COUNT(*)
                           INTO v_cnt_deducs
                           FROM giex_old_group_deductibles
                          WHERE policy_id = a2.policy_id
                            AND item_no = deduc.item_no
                            AND peril_cd = deduc.peril_cd
                            AND ded_deductible_cd = deduc.ded_deductible_cd;
                      /*** end jongs 10232013 ***/


                      IF v_cnt_deducs = 0 THEN

                        INSERT INTO giex_old_group_deductibles
                                    (policy_id, item_no,
                                     peril_cd, ded_deductible_cd,
                                     line_cd, subline_cd,
                                     deductible_rt, deductible_amt
                                    )
                             VALUES (a2.policy_id, deduc.item_no,
                                     deduc.peril_cd, deduc.ded_deductible_cd,
                                     deduc.ded_line_cd, deduc.ded_subline_cd,
                                     deduc.deductible_rt, v_deductible_amt
                                    );
                       END IF;

                        v_cnt_deducs := 0;
                        v_deductible_amt := 0;
                        v_ded_amt := 0;
                     END LOOP;
                  END LOOP;

                  ----- PERIL LEVEL computation of deductibles------
                  FOR perl IN (SELECT   a.item_no, a.peril_cd,
                                    (a.ren_tsi_amt * currency_rt) ren_tsi_amt
                                    --joanne 052914 added currency_rt
                                   FROM giex_old_group_itmperil a
                                  WHERE a.policy_id = a2.policy_id
                               ORDER BY a.item_no, a.peril_cd)
                  LOOP
                     v_perl_tsi_amt := perl.ren_tsi_amt;

                     FOR deduct IN (SELECT a.item_no, a.ded_line_cd,
                                           a.ded_subline_cd,
                                           a.ded_deductible_cd,
                                           b.deductible_rt, b.deductible_amt,
                                           b.ded_type, b.min_amt, b.max_amt,
                                           b.range_sw, a.peril_cd
                                      FROM gipi_deductibles a,
                                           giis_deductible_desc b
                                     WHERE a.ded_line_cd = b.line_cd
                                       AND a.ded_subline_cd = b.subline_cd
                                       AND a.ded_deductible_cd =
                                                               b.deductible_cd
                                       --AND a.policy_id = a2.policy_id
                                     AND a.policy_id IN (SELECT policy_id
                                                          FROM gipi_polbasic
                                                         WHERE line_cd = a2.line_cd
                                                           AND subline_cd = a2.subline_cd
                                                           AND iss_cd = a2.iss_cd
                                                           AND issue_yy = a2.issue_yy
                                                           AND pol_seq_no = a2.pol_seq_no
                                                           AND renew_no = a2.renew_no
                                                           --AND pol_flag IN ('1', '2', '3')) --joanne
                                                           --joanne 02.11.14, replace code above consider summary parameter
                                                           AND (pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '1', pol_flag)
                                                             OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '2', pol_flag)
                                                             OR pol_flag = DECODE(p_def_is_pol_summ_sw, 'Y', '3', pol_flag))
                                                           AND endt_seq_no = DECODE(p_def_is_pol_summ_sw, 'N', 0 , endt_seq_no))
                                       AND a.item_no = perl.item_no
                                       AND a.peril_cd = perl.peril_cd)
                     LOOP
                        IF deduct.ded_type = 'F'
                        THEN
                           v_deductible_amt := deduct.deductible_amt;
                        ELSIF deduct.ded_type = 'T'
                        THEN
                           v_ded_amt :=
                                v_perl_tsi_amt
                              * (NVL (deduct.deductible_rt, 0) / 100);

                           IF     deduct.deductible_rt IS NOT NULL
                              AND deduct.min_amt IS NOT NULL
                              AND deduct.max_amt IS NOT NULL
                           THEN
                              IF deduct.range_sw = 'H'
                              THEN
                                 v_ded_amt :=
                                         GREATEST (v_ded_amt, deduct.min_amt);
                                 v_deductible_amt :=
                                            LEAST (v_ded_amt, deduct.max_amt);
                              ELSIF deduct.range_sw = 'L'
                              THEN
                                 v_ded_amt :=
                                            LEAST (v_ded_amt, deduct.min_amt);
                                 v_deductible_amt :=
                                            LEAST (v_ded_amt, deduct.max_amt);
                              ELSE
                                 v_deductible_amt := deduct.max_amt;
                              END IF;
                           ELSIF     deduct.deductible_rt IS NOT NULL
                                 AND deduct.min_amt IS NOT NULL
                           THEN
                              v_deductible_amt :=
                                         GREATEST (v_ded_amt, deduct.min_amt);
                           ELSIF     deduct.deductible_rt IS NOT NULL
                                 AND deduct.max_amt IS NOT NULL
                           THEN
                              v_deductible_amt :=
                                            LEAST (v_ded_amt, deduct.max_amt);
                           ELSE
                              IF deduct.deductible_rt IS NOT NULL
                              THEN
                                 v_deductible_amt := v_ded_amt;
                              ELSIF deduct.min_amt IS NOT NULL
                              THEN
                                 v_deductible_amt := deduct.min_amt;
                              ELSIF deduct.max_amt IS NOT NULL
                              THEN
                                 v_deductible_amt := deduct.max_amt;
                              END IF;
                           END IF;
                        ELSIF deduct.ded_type = 'L'
                        THEN
                           v_deductible_amt := NULL;
                        ELSIF deduct.ded_type = 'I'
                        THEN
                           v_deductible_amt := NULL;
                        END IF;


                       /*** added by jongs to prevent ora-00001 10232013 ***/
                         SELECT COUNT(*)
                           INTO v_cnt_deducs
                           FROM giex_old_group_deductibles
                          WHERE policy_id = a2.policy_id
                            AND item_no = deduct.item_no
                            AND peril_cd = deduct.peril_cd
                            AND ded_deductible_cd = deduct.ded_deductible_cd;
                      /*** end jongs 10232013 ***/

                      IF v_cnt_deducs = 0 THEN

                        INSERT INTO giex_old_group_deductibles
                                    (policy_id, item_no,
                                     peril_cd,
                                     ded_deductible_cd,
                                     line_cd,
                                     subline_cd,
                                     deductible_rt, deductible_amt
                                    )
                             VALUES (a2.policy_id, deduct.item_no,
                                     deduct.peril_cd,
                                     deduct.ded_deductible_cd,
                                     deduct.ded_line_cd,
                                     deduct.ded_subline_cd,
                                     deduct.deductible_rt, v_deductible_amt
                                    );
                       END IF;

                        v_cnt_deducs := 0;
                        v_deductible_amt := 0;
                        v_ded_amt := 0;
                     END LOOP;
                  END LOOP;
               END IF;
            END;
         --=================================ended edgar nobleza 7/25/2013 ================================================================
         /*JOANNE consolidate all changes in process_expiring policies modification by edgar deductible, 112813 end*/

		   END LOOP;

		   FOR m IN ( SELECT intrmdry_intm_no, NVL(b.policy_currency,'N') policy_currency
						FROM GIPI_COMM_INVOICE a, GIPI_INVOICE b
					   WHERE a.policy_id = v_pol_id
						 AND a.iss_cd = b.iss_cd
						 AND a.prem_seq_no = b.prem_seq_no
					   ORDER BY b.prem_seq_no DESC )
		   LOOP
			   UPDATE GIEX_EXPIRY
				  SET intm_no = m.intrmdry_intm_no,
					  policy_currency = m.policy_currency
				WHERE policy_id = v_pol_id;
			   EXIT;
		   END LOOP;
	END LOOP;
  END IF;
  DBMS_OUTPUT.PUT_LINE('ENDED PROCEDURE : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
END;
/



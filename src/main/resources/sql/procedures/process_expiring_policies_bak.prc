DROP PROCEDURE CPI.PROCESS_EXPIRING_POLICIES_BAK;

CREATE OR REPLACE PROCEDURE CPI.process_expiring_policies_BAK
  (p_intm_no              gipi_comm_invoice.intrmdry_intm_no%TYPE,
   p_fr_date              DATE,
   p_to_date              DATE,
   inc_special_sw         VARCHAR2 DEFAULT 'N',
   p_line_cd              giis_line.line_cd%TYPE,
   p_subline_cd           giis_subline.subline_cd%TYPE,
   p_iss_cd               giis_issource.iss_cd%TYPE,
   p_def_is_pol_summ_sw   giis_parameters.param_value_v%TYPE,
   p_def_same_polno_sw    giis_parameters.param_value_v%TYPE,
   p_plate_no			  gipi_vehicle.plate_no%TYPE,
   t_policy_id            IN OUT DBMS_SQL.NUMBER_TABLE,
   t_line_cd        	  IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_subline_cd     	  IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_iss_cd         	  IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_issue_yy       	  IN OUT DBMS_SQL.NUMBER_TABLE,
   t_pol_seq_no     	  IN OUT DBMS_SQL.NUMBER_TABLE,
   t_renew_no       	  IN OUT DBMS_SQL.NUMBER_TABLE,
   t_expiry_date    	  IN OUT DBMS_SQL.DATE_TABLE,
   t_incept_date    	  IN OUT DBMS_SQL.DATE_TABLE,
   t_assd_no        	  IN OUT DBMS_SQL.NUMBER_TABLE,
   t_auto_sw        	  IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_intm_no        	  IN OUT DBMS_SQL.NUMBER_TABLE)
IS
  /*Modified by Grace 04.24.2003
  **Remove the claim status 'CD' when checking for existing claims.*/
  /*Modified by Iris Borde 04.21.2003.
  **To check for policies already renewed using manual renew.*/
  cnt_ext    NUMBER  := 0;
/*  type date_varray is table of date index by binary_integer;
  type number_varray is table of number index by binary_integer;
  type string_varray is table of varchar2(100) index by binary_integer;
  t_policy_id      number_varray;
  t_line_cd        string_varray;
  t_subline_cd     string_varray;
  t_iss_cd         string_varray;
  t_issue_yy       number_varray;
  t_pol_seq_no     number_varray;
  t_renew_no       number_varray;
  t_expiry_date    date_varray;
  t_incept_date    date_varray;
  t_assd_no        number_varray;
  t_auto_sw        string_varray;
  t_intm_no        number_varray;*/
  /*julie - counter, cntr */
  counter          NUMBER:=1;
  cntr             NUMBER:=1;
  cnt              NUMBER:=1;
  v_count          NUMBER:=0;
  v_policy_no      VARCHAR2(100);     --variable to keep the record being processed
  v_policy_ids     VARCHAR2(32000);   --variable to keep the policy_ids
  v_expiry_sw	   VARCHAR2(1):='N';  --to identify if the policy already exists in giex_expiry.
  v_clm      	   VARCHAR2(1);
  v_bal      	   VARCHAR2(1);
  v_sw		       VARCHAR2(1):='N';
  v_intm_sw        VARCHAR2(1):='N';
  various      	   VARCHAR2(100);
  TO_DATE          DATE;
  fr_date          DATE;
  v_line_cd        gipi_polbasic.line_cd%TYPE;
  v_subline_cd     gipi_polbasic.subline_cd%TYPE;
  v_iss_cd         gipi_polbasic.iss_cd%TYPE;
  v_issue_yy       gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no       gipi_polbasic.renew_no%TYPE;
  v_back_stat      gipi_polbasic.back_stat%TYPE;   --new, to identify backward endorsement
  v_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE; --to check if original policy is already in giex_expiry
  v_expiry_date    gipi_polbasic.expiry_date%TYPE;
  v_incept_date    gipi_polbasic.incept_date%TYPE;
  v_eff_date       gipi_polbasic.eff_date%TYPE;
  v_assd_no        gipi_polbasic.assd_no%TYPE;
  v_ext_date 	   gipi_polbasic.expiry_date%TYPE  := SYSDATE;
  v_tsi       	   gipi_polbasic.tsi_amt%TYPE;
  v_prem      	   gipi_polbasic.prem_amt%TYPE;
  v_pol_id   	   gipi_polbasic.policy_id%TYPE;
  v_exp_date 	   gipi_polbasic.expiry_date%TYPE;
  v_inc_date 	   gipi_polbasic.incept_date%TYPE;
  v_spld_flag      gipi_polbasic.spld_flag%TYPE;
  v_expiry_tag	   gipi_polbasic.expiry_tag%TYPE;
  v_policy_id      gipi_polbasic.policy_id%TYPE;
  v_intm_no        gipi_comm_invoice.intrmdry_intm_no%TYPE;
  v_auto_sw        giex_expiry.auto_sw%TYPE;
  v_ren_flag  	   giex_expiry.renew_flag%TYPE;
  v_summ_sw   	   giex_expiry.summary_sw%TYPE;
  v_same_sw 	   giex_expiry.same_polno_sw%TYPE;
  v_reg_pol_sw 	   giex_expiry.reg_policy_sw%TYPE;  -- jenny vi lim 02092005
  v_renewal_id	   giex_expiry.renewal_id%TYPE; -- jenny vi lim 02102005
  v_tax       	   giex_expiry.tax_amt%TYPE;
  v_pol_tax   	   giex_expiry.tax_amt%TYPE;
  v_car_company    giex_expiry.car_company%TYPE;
  v_rate      	   gipi_item.currency_rt%TYPE;
  v_item_title 	   gipi_item.item_title%TYPE;
  v_color      	   gipi_vehicle.color%TYPE;
  v_motor_no   	   gipi_vehicle.motor_no%TYPE;
  v_model_year 	   gipi_vehicle.model_year%TYPE;
  v_make       	   gipi_vehicle.make%TYPE;
  v_serial_no  	   gipi_vehicle.serial_no%TYPE;
  v_plate_no   	   gipi_vehicle.plate_no%TYPE;
  v_item_no    	   gipi_vehicle.item_no%TYPE;
  v_line_mc    	   giis_line.line_cd%TYPE;
  v_line_fi    	   giis_line.line_cd%TYPE;
  v_loc_risk1  	   gipi_fireitem.loc_risk1%TYPE;
  v_loc_risk2  	   gipi_fireitem.loc_risk2%TYPE;
  v_loc_risk3  	   gipi_fireitem.loc_risk3%TYPE;
  o_line_cd   	   giex_expiry.line_cd%TYPE;
  o_peril_cd  	   giex_old_group_peril.peril_cd%TYPE;
  o_prem_amt2  	   giex_old_group_peril.prem_amt%TYPE;
  o_tsi_amt2   	   giex_old_group_peril.tsi_amt%TYPE;
  v_orig_tsi_exp   giex_expiry.tsi_amt%TYPE;
  v_orig_tsi_item  giex_expiry.tsi_amt%TYPE;
  v_orig_tsi_ngrp  giex_expiry.tsi_amt%TYPE;
  v_orig_tsi_ogrp  giex_expiry.tsi_amt%TYPE;
  v_orig_prm_ogrp  giex_expiry.prem_amt%TYPE;
  v_auto_dep	   VARCHAR2(2);
  v_dep_pct		   NUMBER;
  v_total_dep_tsi  giex_expiry.tsi_amt%TYPE := 0;
  v_total_dep_prm  giex_expiry.prem_amt%TYPE:= 0;
  v_dep_tax_amt    gipi_inv_tax.tax_amt%TYPE:= 0;
BEGIN
  -- rollie 20OCT2004
  -- for variables of depreciation
  v_auto_dep := giisp.v('AUTO_COMPUTE_MC_DEP');
  v_dep_pct  := giisp.n('MC_DEP_PCT');

  DBMS_OUTPUT.PUT_LINE('START PROCEDURE : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
  FOR a1 IN (
    SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
           a.renew_no, a.endt_seq_no,
	       a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no
	       policy_no, a.policy_id, a.eff_date eff_date, TRUNC(a.expiry_date)
	       expiry_date, a.assd_no, a.incept_date, NVL(a.spld_flag,'1')
	       spld_flag, a.expiry_tag, a.back_stat, a.reg_policy_sw
      FROM gipi_polbasic a,
           giis_subline b
     WHERE 1=1
       /*AND EXISTS (SELECT 'EXISTS IN GIPI_VEHICLE'
	   	   		     FROM gipi_vehicle gpv
				    WHERE 1 = 1
					  AND a.policy_id = gpv.policy_id
					  AND (gpv.plate_no LIKE '%'||p_plate_no
					   OR (NVL(gpv.plate_no,1) = NVL(gpv.plate_no,1) AND p_plate_no IS NULL))
					  )*/
	   and EXISTS (SELECT 1
	   	   		     FROM gipi_vehicle gpv
				    WHERE 1 = 1
					  AND a.policy_id = gpv.policy_id
					  AND gpv.plate_no LIKE '%'||p_plate_no
					union all
					select 1 from dual
					  )
	   AND a.line_cd    = b.line_cd
       AND a.subline_cd = b.subline_cd
       AND b.op_flag    = 'N'
       AND a.pol_flag IN ('1','2','3')
       AND a.iss_cd NOT IN ('RI','BB')
       AND NVL(a.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(a.reg_policy_sw,'Y'))
       /* by: julie
       ** date: april 30, 2002
       ** for optimization purposes

       and a.line_cd = nvl(p_line_cd, a.line_cd)
       and a.subline_cd = nvl(p_subline_cd, a.subline_cd)
       and a.iss_cd = nvl(p_iss_cd, a.iss_cd

       the script above was modified. the script below replaces the script above
       */
       AND a.line_cd LIKE p_line_cd||'%'
       AND a.subline_cd LIKE p_subline_cd||'%'
       AND a.iss_cd LIKE p_iss_cd||'%'
       /*added by Iris Bordey 04.21.2003
	   **To check for policies already renewed(using manual renew).*/
	   AND NOT EXISTS (SELECT '1'
      	                 FROM gipi_polbasic x,
      	                      gipi_polnrep  y
      	                WHERE 1=1
	                      AND x.policy_id  = y.old_policy_id
	                      AND x.line_cd    = a.line_cd
	                      AND x.subline_cd = a.subline_cd
	                      AND x.iss_cd     = a.iss_cd
	                      AND x.issue_yy   = a.issue_yy
	                      AND x.pol_seq_no = a.pol_seq_no
	                      AND x.renew_no   = a.renew_no)
       /* by: julie
       ** date: april 30, 2002
       ** added this select statement here in order to check whether a policy already exists
          in giex_expiry. a script similar to this was found at the latter part of this procedure
          but removed for optimizaiton purposes.
       */

       AND NOT EXISTS (SELECT '1'
	                     FROM giex_expiry c
		    			         WHERE a.policy_id = c.policy_id)
   UNION --bdarusin, untagged 080102
    SELECT 'XX','XX','XX',0,0,0,0,'XX',0,SYSDATE,SYSDATE,0 , SYSDATE , '1', 'N',0 ,'N' FROM dual  -- FOR THE LAST RECORD
  	ORDER BY 1,2,3,4,5,6,10 DESC, 7 DESC,11,12,9)
   -- if inc_special_sw = 'y' then a.reg_policy_sw = a.reg_policy_sw else a.reg_policy_sw = 'y'
  LOOP
   -- records to be fetched will be accumulated then processed when a new policy is encountered
   -- still processing the same policy or first record
   /*message('selecting record...'||counter,no_acknowledge);
                synchronize;
                cntr:=cntr + 1;*/
    IF v_policy_no IS NULL OR v_policy_no = a1.policy_no THEN

       IF a1.endt_seq_no = 0 THEN
          v_endt_seq_no := a1.endt_seq_no;
          v_policy_id   := a1.policy_id;
          -- removed to consider backward endorsement
          --      else
          --      	v_endt_seq_no := null;
          --        v_policy_id   := null;
       END IF;
       IF v_policy_no IS NULL THEN
          v_policy_ids  := a1.policy_id;
       ELSE
          v_policy_ids  := v_policy_ids ||','||a1.policy_id;
       END IF;
       v_line_cd    := a1.line_cd;
       v_subline_cd := a1.subline_cd;
       v_iss_cd 	:= a1.iss_cd;
       v_issue_yy   := a1.issue_yy;
       v_pol_seq_no := a1.pol_seq_no;
       v_renew_no   := a1.renew_no;
       v_back_stat  := a1.back_stat;
       v_reg_pol_sw := a1.reg_policy_sw; --jenny vi lim 02092005
       --this will assure that you will get the latest change
       --IF v_eff_date IS NULL THEN
       IF v_eff_date IS NULL
	      OR v_eff_date > a1.eff_date   --bdarusin 080102 for policies w/ changed
		  AND a1.endt_seq_no <> 0 THEN  --eff date (eg pol - feb 1, endt - jan 1)
	      v_eff_date  := a1.eff_date;
       END IF;
       --IF v_expiry_date IS NULL THEN
       IF v_expiry_date IS NULL
	      OR v_expiry_date > a1.expiry_date  --bdarusin
		  AND a1.endt_seq_no <> 0 THEN
          v_expiry_date  := a1.expiry_date;
       END IF;
       --IF v_incept_date IS NULL THEN
       IF v_incept_date IS NULL
	      OR v_incept_date > a1.incept_date  --bdarusin
		  AND a1.endt_seq_no <> 0 THEN
          v_incept_date  := a1.incept_date;
       END IF;

	   IF v_assd_no IS NULL THEN
          v_assd_no := a1.assd_no;
       END IF;
       IF v_auto_sw = 'Y' THEN
	        IF a1.endt_seq_no <> 0 THEN
	           v_auto_sw := 'N';
	        END IF;
       END IF;
       -- check if policy already exists in giex_expiry.
       /* by: julie
       ** date: april 30, 2002
       ** the script below was removed
            /*if v_expiry_sw = 'n' then
          for a2 in (select '1'
	                     from giex_expiry
		                  where policy_id  = a1.policy_id)
          loop
	          v_expiry_sw := 'y';


	          exit;
	        end loop;
       end if;

       and replaced by the script below in the first select statement above for
       optimization purposes.

        and not exists (select '1'
	                     from giex_expiry c
		    			         where a.policy_id = c.policy_id)
      */
       v_policy_no := a1.policy_no;
       -- transferred here by IOB 10.14.02
       v_spld_flag := NVL(a1.spld_flag,'1');
       v_expiry_tag:= NVL(a1.expiry_tag,'N');

       --processing new policy already
    ELSIF v_policy_no != a1.policy_no THEN
       -- first process the previous policy
       -- original policy was already expired
       IF NVL(v_endt_seq_no,1) != 0 AND v_back_stat <> 2 THEN
          NULL;
       ELSE
          IF TRUNC(v_expiry_date) >= TRUNC(p_fr_date) AND TRUNC(v_expiry_date) <= TRUNC(p_to_date) THEN
             v_intm_sw := 'N';
		     /*bdarusin, jan152003,returned the ff statements to include
			   renewal of policies without endts*/
			 --v_spld_flag := NVL(a1.spld_flag,'1'); --bdarusin, 072203
		     --v_expiry_tag:= NVL(a1.expiry_tag,'N');--bdarusin, 072203
             /*bdarusin, end of added statements*/
             -- expiry was done with a specific intm_no
             --:fblock.intm_no is not null then
             IF p_intm_no IS NOT NULL THEN
                v_intm_sw := 'Y';
                DECLARE
                  TYPE     cv_type IS REF CURSOR;
                  cv       cv_type;
                  retval   NUMBER :=0;
				/* the ff cursor declaration was commented out
				** bdarusin 080102 -> from here
				*/
                /* added by: julie
                ** date: april 23, 2002
                */
                 -- CURSOR cv IS
                 --  SELECT 1 FROM gipi_comm_invoice WHERE policy_id = v_policy_ids
                 --     AND intrmdry_intm_no = p_intm_no AND ROWNUM = 1 ;
				 -- to here <-  bdarusin**
                BEGIN
				  --the ff statement was untagged, to resolve ora-01722 encountered --bdarusin 080102
                  OPEN cv FOR
                    'SELECT 1 FROM GIPI_COMM_INVOICE WHERE POLICY_ID IN ('||v_policy_ids||') AND INTRMDRY_INTM_NO = :INTM AND ROWNUM = 1 '
                    USING p_intm_no;
                  LOOP
                    FETCH cv INTO retval;
                    EXIT WHEN cv%FOUND;
                  END LOOP;
                  CLOSE cv;
                  IF retval = 1 THEN
            	       v_intm_sw := 'N';
                  END IF;
                END;
             END IF;
             --
             IF v_intm_sw 	   = 'N' AND
                v_endt_seq_no = 0 AND
                v_policy_id IS NOT NULL AND
	            v_policy_no  != 'XX' AND
	            v_spld_flag  <> '2'  AND
	            v_expiry_tag  = 'N'  AND
	            v_expiry_sw   = 'N'  THEN       --include policy in expiry checking
                -- added by rbd to get the correct expiry date and inception date if policy has backward endt
                -- from here
                -- get the last endorsement sequence of the latest backward endt
                /* added by: julie
                ** date: april 23, 2002
                ** description: to inform the user of the number of policies that are
                                being processed.
                */
                DBMS_OUTPUT.PUT_LINE('PROCESSING RECORD : ' || TO_CHAR(counter));
                ---synchronize;
                counter:=counter + 1;
               /*
                message(v_line_cd||v_subline_cd||v_iss_cd||v_issue_yy||v_pol_seq_no||v_renew_no);
                message(v_line_cd||v_subline_cd||v_iss_cd||v_issue_yy||v_pol_seq_no||v_renew_no);
                */
                /*message(v_policy_no);
                message(v_policy_no);*/



                FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date
                             FROM gipi_polbasic b2501
                            WHERE b2501.line_cd    = v_line_cd
                              AND b2501.subline_cd = v_subline_cd
                              AND b2501.iss_cd     = v_iss_cd
                              AND b2501.issue_yy   = v_issue_yy
                              AND b2501.pol_seq_no = v_pol_seq_no
                              AND b2501.renew_no   = v_renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND NVL(b2501.back_stat,5) = 2
                            ORDER BY endt_seq_no DESC )
                LOOP
                  -- get the last endorsement sequence of the policy
                  FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date
                                FROM gipi_polbasic b2501
                               WHERE b2501.line_cd    = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd     = v_iss_cd
                                 AND b2501.issue_yy   = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no   = v_renew_no
                                 AND b2501.pol_flag   IN ('1','2','3')
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
                -- to here
                -- added by rbd to get the correct assured if policy has backward endt
                -- from here
                -- get the last endorsement sequence of the latest backward endt
                FOR z3 IN (SELECT endt_seq_no, assd_no
                             FROM gipi_polbasic b2501
                            WHERE b2501.line_cd    = v_line_cd
                              AND b2501.subline_cd = v_subline_cd
                              AND b2501.iss_cd     = v_iss_cd
                              AND b2501.issue_yy   = v_issue_yy
                              AND b2501.pol_seq_no = v_pol_seq_no
                              AND b2501.renew_no   = v_renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND assd_no IS NOT NULL
                              AND NVL(b2501.back_stat,5) = 2
                            ORDER BY endt_seq_no DESC )
                LOOP
                  -- get the last endorsement sequence of the policy
                  FOR z3a IN (SELECT endt_seq_no, eff_date, assd_no
                                FROM gipi_polbasic b2501
                               WHERE b2501.line_cd    = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd     = v_iss_cd
                                 AND b2501.issue_yy   = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no   = v_renew_no
                                 AND b2501.pol_flag   IN ('1','2','3')
                                 AND assd_no IS NOT NULL
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
                -- to here
                v_count := v_count + 1;
                t_policy_id(v_count)  := v_policy_id;
                t_line_cd(v_count)    := v_line_cd;
                t_subline_cd(v_count) := v_subline_cd;
                t_iss_cd(v_count) 	  := v_iss_cd;
                t_issue_yy(v_count)   := v_issue_yy;
                t_pol_seq_no(v_count) := v_pol_seq_no;
                t_renew_no(v_count)   := v_renew_no;
                t_expiry_date(v_count):= v_expiry_date;
                t_incept_date(v_count):= v_incept_date;
                t_assd_no(v_count)    := v_assd_no;
                t_intm_no(v_count)    := v_intm_no;
                t_auto_sw(v_count)    := v_auto_sw;
             END IF;
          END IF;  --trunc(v_expiry_date)
       END IF;
       --second initialize the variables to be used
       v_line_cd 	  := NULL;
       v_subline_cd 	  := NULL;
       v_iss_cd 	  	  := NULL;
       v_issue_yy 	  := NULL;
       v_pol_seq_no 	  := NULL;
       v_renew_no 	  := NULL;
       v_expiry_date  	  := NULL;
       v_incept_date  	  := NULL;
       v_assd_no 	  := NULL;
       v_policy_ids 	  := NULL;
       v_policy_id  	  := NULL;
       v_endt_seq_no 	  := NULL;
       v_spld_flag 	  := NULL;
       v_expiry_tag	  := NULL;
       v_auto_sw		  := 'Y';
       v_expiry_sw	  := 'N';
       v_eff_date          := NULL;
       --third insert data to the variables
       IF a1.endt_seq_no = 0 THEN
          v_endt_seq_no  := 0;
          v_policy_id 	:= a1.policy_id;
          -- removed to consider backward endorsement
          --      else
          --         v_endt_seq_no  := null;
          --         v_policy_id 	:= null;
       END IF;
       IF a1.endt_seq_no <> 0 THEN
	        v_auto_sw      := 'N';
       END IF;
       v_policy_ids 	:= a1.policy_id;
       v_line_cd  	:= a1.line_cd;
       v_subline_cd 	:= a1.subline_cd;
       v_iss_cd 		:= a1.iss_cd;
       v_issue_yy 	:= a1.issue_yy;
       v_pol_seq_no 	:= a1.pol_seq_no;
       v_renew_no 	:= a1.renew_no;
       --no need to check if null kc initialize na before hand
       v_expiry_date  	:= a1.expiry_date;
       v_incept_date  	:= a1.incept_date;
       v_assd_no 	:= a1.assd_no;
	   v_spld_flag := NVL(a1.spld_flag,'1'); --bdarusin, 072203
	   v_expiry_tag:= NVL(a1.expiry_tag,'N');--bdarusin, 072203
       /* by: julie
       ** date: april 30, 2002
       ** the script below was removed
            if v_expiry_sw = 'n' then
          for a2 in (select '1'
	                     from giex_expiry
		                  where policy_id  = a1.policy_id)
          loop
	          v_expiry_sw := 'y';


	          exit;
	        end loop;
       end if;

       and replaced by the script below in the first select statement above for
       optimization purposes.

        and not exists (select '1'
	                     from giex_expiry c
		    			         where a.policy_id = c.policy_id)
      */
       --fourth transfer policy_no to v_policy_no
       v_policy_no := a1.policy_no;
       v_reg_pol_sw := a1.reg_policy_sw; --jenny vi lim 02092005
    END IF;
  END LOOP; --(end of first loop)
/*  if t_policy_id.exists(1) then
    for indx in t_policy_id.first..t_policy_id.last loop
      insert into giex_temp (policy_id, intm_no, assd_no, incept_date, expiry_date, auto_sw)
	  values (t_policy_id(indx),t_intm_no(indx),t_assd_no(indx),t_incept_date(indx), t_expiry_date(indx), t_auto_sw(indx));
    end loop;
    dbms_output.put_line('total policies searched :  '||t_policy_id.count);
  end if;
  commit;*/
/*  for indx in t_policy_id.first..t_policy_id.last loop
    dbms_output.put_line(' policy_id :  '||t_policy_id(indx));
    dbms_output.put_line(' line_cd :  '||t_line_cd(indx));
    dbms_output.put_line(' subline_cd :  '||t_subline_cd(indx));
    dbms_output.put_line(' iss_cd :  '||t_iss_cd(indx));
    dbms_output.put_line(' issue_yy :  '||t_issue_yy(indx));
    dbms_output.put_line(' pol_seq_no :  '||t_pol_seq_no(indx));
    dbms_output.put_line(' renew_no :  '||t_renew_no(indx));
    dbms_output.put_line(' expiry_date :  '||t_expiry_date(indx));
    dbms_output.put_line(' incept_date :  '||t_incept_date(indx));
    dbms_output.put_line(' assd_no :  '||t_assd_no(indx));
  end loop;*/

 /* commented by: julie
 ** date: april 26, 2002
 ** description: the two loops below have been commented for optimization purposes


  for a in (select giisp.v('line_code_mc') cd
              from dual)
  loop
    v_line_mc    := a.cd;
    exit;
  end loop;
  for b in (select giisp.v('line_code_fi') cd
   	      from dual)
  loop
    v_line_fi    := b.cd;
    exit;
  end loop;*/

  /* added by: julie
  ** date: april 26, 2002
  ** description: the two assignment statements below have been added to replace
                  the two loops above
  */

  v_line_mc := giisp.v('LINE_CODE_MC');
  v_line_fi := giisp.v('LINE_CODE_FI');

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
       v_clm 	     := NULL;
       v_bal 	     := NULL;
       v_ren_flag   := '2';
       v_pol_id     := t_policy_id(a1);
       v_exp_date   := t_expiry_date(a1);
       v_assd_no    := t_assd_no(a1);
       v_intm_no    := t_intm_no(a1);
       v_inc_date   := t_incept_date(a1);
       v_auto_sw    := t_auto_sw(a1);
       FOR a2 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                         pol_seq_no, renew_no,auto_renew_flag,policy_id
                    FROM gipi_polbasic
                   WHERE policy_id = v_pol_id)
       LOOP
         FOR a3 IN (SELECT '1'
                      FROM gicl_claims
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
         FOR a4 IN (SELECT NVL(prem_amt,0) prem, NVL(tsi_amt,0) tsi
                      FROM gipi_polbasic
                     WHERE line_cd     = a2.line_cd
                       AND subline_cd  = a2.subline_cd
                       AND iss_cd      = a2.iss_cd
                       AND issue_yy    = a2.issue_yy
                       AND pol_seq_no  = a2.pol_seq_no
                       AND renew_no    = a2.renew_no
                       AND pol_flag IN ('1','2','3'))
         LOOP
           v_orig_tsi_exp  := NVL(v_orig_tsi_exp,0)  + a4.tsi;
           v_prem := NVL(v_prem,0) + a4.prem;
         END LOOP;
/*		 -- rollie 25-OCT-2004
		 -- for auto compute of TSI depreciation
		 -- look up on table giex_dep_perl
		 BEGIN
  		   SELECT 'Y'
			 INTO v_auto_dep
			 FROM GIEX_DEP_PERL
		    WHERE line_cd = a2.line_cd;
		 EXCEPTION
		   WHEN NO_DATA_FOUND THEN
			 v_auto_dep := 'N';
		   WHEN TOO_MANY_ROWS THEN
			 v_auto_dep := 'Y';
		 END;
		 IF a2.line_cd = v_line_mc AND v_auto_dep = 'Y' THEN
		    v_tsi := v_orig_tsi_exp - (v_orig_tsi_exp * v_dep_pct);
		 ELSE
		 	v_tsi := v_orig_tsi_exp;
		 END IF;*/

         FOR a5 IN (SELECT SUM(c.balance_amt_due) due
                      FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
                     WHERE a.line_cd     = a2.line_cd
                       AND a.subline_cd  = a2.subline_cd
                       AND a.iss_cd      = a2.iss_cd
                       AND a.issue_yy    = a2.issue_yy
                       AND a.pol_seq_no  = a2.pol_seq_no
                       AND a.renew_no    = a2.renew_no
                       AND a.pol_flag IN ('1','2','3')
                       AND a.policy_id = b.policy_id
                       AND b.iss_cd = c.iss_cd
                       AND b.prem_seq_no = c.prem_seq_no)
         LOOP
           IF a5.due <> 0 THEN
              v_bal := 'Y';
           END IF;
         END LOOP;
         v_tax := 0;
         v_pol_tax := 0;
         FOR a6 IN(SELECT SUM(NVL(tax_amt,0)) tax,
                          item_grp, a.policy_id
                     FROM gipi_polbasic a, gipi_invoice b
                    WHERE a.policy_id = b.policy_id
                      AND a.line_cd     = a2.line_cd
                      AND a.subline_cd  = a2.subline_cd
                      AND a.iss_cd      = a2.iss_cd
                      AND a.issue_yy    = a2.issue_yy
                      AND a.pol_seq_no  = a2.pol_seq_no
                      AND a.renew_no    = a2.renew_no
                      AND a.pol_flag IN ('1','2','3')
                    GROUP BY item_grp, a.policy_id)
         LOOP
           v_rate := 0;
           FOR a7 IN (SELECT currency_rt
                        FROM gipi_item
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
         FOR i IN (SELECT c.item_no, SUBSTR(c.item_title, 1,50) item_title
                     FROM gipi_polbasic a,
                          gipi_item c
                    WHERE a.line_cd = a2.line_cd
                      AND a.subline_cd = a2.subline_cd
                      AND a.iss_cd     = a2.iss_cd
                      AND a.issue_yy   = a2.issue_yy
                      AND a.pol_seq_no = a2.pol_seq_no
                      AND a.renew_no   = a2.renew_no
                      AND a.policy_id  = c.policy_id
                      AND a.pol_flag IN ('1','2','3')
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
                              b.item_no
                         FROM gipi_polbasic a,
                              gipi_fireitem  b,
                              gipi_item c
                        WHERE a.line_cd = a2.line_cd
                          AND a.subline_cd = a2.subline_cd
                          AND a.iss_cd     = a2.iss_cd
                          AND a.issue_yy   = a2.issue_yy
                          AND a.pol_seq_no = a2.pol_seq_no
                          AND a.renew_no   = a2.renew_no
                          AND a.policy_id  = b.policy_id
                          AND b.policy_id  = c.policy_id
                          AND b.item_no    = c.item_no
                          AND a.pol_flag IN ('1','2','3')
                        ORDER BY b.item_no, eff_date ASC)
            LOOP
              IF NVL(v_item_no, fi.item_no) = fi.item_no THEN
                 v_item_no := fi.item_no;
                 IF fi.loc_risk1 IS NOT NULL OR
              	    fi.loc_risk2 IS NOT NULL OR
               	    fi.loc_risk3 IS NOT NULL THEN
               	    v_loc_risk1 := fi.loc_risk1;
               	    v_loc_risk2 := fi.loc_risk2;
               	    v_loc_risk3 := fi.loc_risk3;
                 END IF;
              ELSIF NVL(v_item_no, fi.item_no) <> fi.item_no THEN
                 IF v_loc_risk1 IS NULL AND
                    v_loc_risk2 IS NULL AND
              	    v_loc_risk3 IS NULL THEN
              	    v_item_no := fi.item_no;
                    IF fi.loc_risk1 IS NOT NULL OR
                       fi.loc_risk2 IS NOT NULL OR
                       fi.loc_risk3 IS NOT NULL THEN
                       v_loc_risk1 := fi.loc_risk1;
                       v_loc_risk2 := fi.loc_risk2;
                       v_loc_risk3 := fi.loc_risk3;
                    END IF;
                 ELSIF NVL(v_loc_risk1, '%^&') <> NVL(fi.loc_risk1,'%^&') OR
                    NVL(v_loc_risk2, '%^&') <> NVL(fi.loc_risk2,'%^&') OR
                    NVL(v_loc_risk3, '%^&') <> NVL(fi.loc_risk3,'%^&') THEN
                    v_loc_risk1 := 'VARIOUS';
                    v_loc_risk2 := NULL;
                    v_loc_risk3 := NULL;
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
                              b.item_no
                         FROM gipi_polbasic a,
                              gipi_vehicle  b,
                              gipi_item     c,
                              giis_mc_car_company d
                        WHERE a.line_cd = a2.line_cd
                          AND a.subline_cd = a2.subline_cd
                          AND a.iss_cd     = a2.iss_cd
                          AND a.issue_yy   = a2.issue_yy
                          AND a.pol_seq_no = a2.pol_seq_no
                          AND a.renew_no   = a2.renew_no
                          AND a.policy_id  = b.policy_id
                          AND b.policy_id  = c.policy_id
                          AND b.item_no    = c.item_no
		                      AND b.car_company_cd = d.car_company_cd(+)
                          AND a.pol_flag IN ('1','2','3')
                        ORDER BY eff_date ASC)
            LOOP
              IF NVL(v_item_no, a9.item_no) = a9.item_no THEN
                 v_item_no     := a9.item_no;
                 v_color       := NVL(a9.color, v_color);
                 v_motor_no    := NVL(a9.motor_no,v_motor_no);
                 v_model_year  := NVL(a9.model_year,v_model_year);
                 v_make        := NVL(a9.make, v_make);
                 v_serial_no   := NVL(a9.serial_no,v_serial_no);
                 v_plate_no    := NVL(a9.plate_no,v_plate_no);
	               v_car_company := NVL(a9.car_company,v_car_company);
              ELSE
                 v_color       := 'VARIOUS';
                 v_motor_no    := 'VARIOUS';
                 v_model_year  := 'VAR.'   ;
                 v_make        := 'VARIOUS';
                 v_serial_no   := 'VARIOUS';
                 v_plate_no    := 'VARIOUS';
                 v_car_company := NULL     ;
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
         /* message(a2.line_cd||a2.subline_cd||a2.iss_cd||a2.issue_yy||a2.pol_seq_no||a2.renew_no);
          message(a2.line_cd||a2.subline_cd||a2.iss_cd||a2.issue_yy||a2.pol_seq_no||a2.renew_no);*/
         /* message('inserting record...'||counter,no_acknowledge);
                synchronize;
                cnt:=cnt + 1;      */
      DBMS_OUTPUT.PUT_LINE('GIEX EXPIRY - '||a2.policy_id||' - '||v_tsi);
	  /*Modified by Iris Bordey 08.29.2003
	  **Transferred end-if after insertion to all table affected by giex_expiry
	  **to resolve ora-02291 (parent key not found).
	  */
--      IF v_tsi != 0 THEN

	  /*Commented by A.R.C. 03.07.2005
	  **Transferred to after insertion to table giex_expiry
	  **to resolve ora-02291 (parent key not found).
	  */
		 /*v_total_dep_tsi := 0;
		 v_total_dep_prm := 0;
		 FOR a8 IN (
		   SELECT SUM(a.prem_amt * c.currency_rt) prem_amt2,
         	      SUM(a.tsi_amt * c.currency_rt) tsi_amt2,
                  a.line_cd, a.peril_cd,d.peril_type peril_type
             FROM gipi_itmperil a,
                  gipi_polbasic b,
                  gipi_item     c,
				  giis_peril	d
            WHERE b.line_cd         = a2.line_cd
              AND b.subline_cd      = a2.subline_cd
              AND b.iss_cd          = a2.iss_cd
              AND b.issue_yy        = a2.issue_yy
              AND b.pol_seq_no      = a2.pol_seq_no
              AND b.renew_no        = a2.renew_no
			  AND d.peril_cd		= a.peril_cd
			  AND d.line_cd			= a.line_cd
              AND a.policy_id       = b.policy_id
              AND b.policy_id       = c.policy_id
              AND a.policy_id       = b.policy_id
              AND a.item_no         = c.item_no
              AND b.pol_flag        IN('1','2','3')
              AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
            GROUP BY a.peril_cd, a.line_cd, d.peril_type)
         LOOP
           o_line_cd     := a8.line_cd;
           o_peril_cd    := a8.peril_cd;
           o_prem_amt2   := a8.prem_amt2;
           v_orig_tsi_ogrp := a8.tsi_amt2;
		   v_orig_prm_ogrp := a8.prem_amt2;
		   *//* rollie 25-OCT-2004
		   ** for auto compute of TSI depreciation
		   ** look up on table giex_dep_perl *//*
		   BEGIN
	  		 SELECT 'Y'
			   INTO v_auto_dep
			   FROM giex_dep_perl
			  WHERE line_cd  = a8.line_cd
				AND peril_cd = a8.peril_cd;
		   EXCEPTION
			 WHEN NO_DATA_FOUND THEN
				v_auto_dep := 'N';
			 WHEN TOO_MANY_ROWS THEN
			 	v_auto_dep := 'Y';
		   END;
		   IF a8.line_cd = v_line_mc AND v_auto_dep = 'Y' THEN
		      o_tsi_amt2  := v_orig_tsi_ogrp - (v_orig_tsi_ogrp * (v_dep_pct/100));
			  o_prem_amt2 := v_orig_prm_ogrp - (v_orig_prm_ogrp * (v_dep_pct/100));
		   ELSE
		 	  o_tsi_amt2  := v_orig_tsi_ogrp;
			  o_prem_amt2 := v_orig_prm_ogrp;
		   END IF;

		   IF a8.peril_type = 'B' THEN
			  v_total_dep_tsi := NVL(v_total_dep_tsi,0) + o_tsi_amt2;
    	   END IF;

		   v_total_dep_prm := NVL(v_total_dep_prm,0) + o_prem_amt2;

           INSERT INTO giex_old_group_peril
                     (policy_id,    line_cd,     peril_cd,     prem_amt,
				      tsi_amt,	  	orig_tsi_amt)
           VALUES (a2.policy_id, o_line_cd,   o_peril_cd,   o_prem_amt2,
				      o_tsi_amt2,	v_orig_tsi_ogrp );
         END LOOP;

		 FOR a9 IN (
		   SELECT --SUM(d.tax_amt * c.currency_rt) tax_amt2,
                  d.line_cd, d.tax_cd, d.tax_id, d.iss_cd,
                  e.tax_desc,d.rate rate
             FROM gipi_polbasic b,
                  gipi_invoice  c,
                  gipi_inv_tax  d,
                  giis_tax_charges e
             WHERE b.line_cd         = a2.line_cd
               AND b.subline_cd      = a2.subline_cd
               AND b.iss_cd          = a2.iss_cd
               AND b.issue_yy        = a2.issue_yy
               AND b.pol_seq_no      = a2.pol_seq_no
               AND b.renew_no        = a2.renew_no
               AND b.policy_id       = c.policy_id
               AND d.prem_seq_no     = c.prem_seq_no
               AND d.iss_cd          = b.iss_cd
               AND d.tax_cd          = e.tax_cd
               AND d.tax_id          = e.tax_id
               AND d.iss_cd          = e.iss_cd
               AND d.line_cd         = e.line_cd
               AND b.pol_flag        IN('1','2','3')
               AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
             --GROUP BY d.line_cd, d.tax_cd, d.tax_id, d.iss_cd,e.tax_desc,d.rate
			 )
         LOOP
		   -- rollie 09feb2005
		   -- compute depreciated tax_amt = dep_prem * tax_rate
		   v_dep_tax_amt := v_total_dep_prm*(a9.rate/100);
		   INSERT INTO giex_old_group_tax
                       (policy_id,    line_cd,     iss_cd,     tax_cd,
                       tax_id,       tax_desc,    tax_amt)
           VALUES (a2.policy_id, a9.line_cd,  a9.iss_cd,  a9.tax_cd,
                       a9.tax_id,    a9.tax_desc, v_dep_tax_amt);
		   v_dep_tax_amt := 0;
         END LOOP;*/
          v_renewal_id := TRANSLATE(a2.policy_id, '0123456789', 'ABCDGJMPTW');  -- jenny vi lim 02102005
		 INSERT INTO giex_expiry
                 (policy_id,    expiry_date,  line_cd,      subline_cd,
                  iss_cd,       issue_yy,     pol_seq_no,   renew_no,
                  claim_flag,   extract_user, extract_date, user_id,
                  last_update,  renew_flag,   auto_renew_flag,
                  --tsi_amt,      		      prem_amt,  --commented by A.R.C. 03.07.2005
				  balance_flag, incept_date,
                  assd_no,      same_polno_sw,update_flag,  summary_sw,
                  auto_sw,      tax_amt,      policy_tax_amt,
                  color,        motor_no,     model_year,   make,
                  serialno,     plate_no,     item_title,   loc_risk1,
                  loc_risk2,    loc_risk3,    intm_no,      car_company,
				  orig_tsi_amt, reg_policy_sw, renewal_id)
          VALUES (a2.policy_id, v_exp_date,   a2.line_cd,   a2.subline_cd,
                  a2.iss_cd,    a2.issue_yy,  a2.pol_seq_no,a2.renew_no,
                  v_clm,        USER,         v_ext_date,   USER,
                  SYSDATE,      v_ren_flag,   a2.auto_renew_flag,
                  --v_total_dep_tsi,        	  v_total_dep_prm,  --commented by A.R.C. 03.07.2005
				  v_bal,        v_inc_date,
                  v_assd_no,    v_same_sw,    'N',          v_summ_sw,
                  v_auto_sw,    v_tax,        v_pol_tax,
                  v_color,      v_motor_no,   v_model_year, v_make,
                  v_serial_no,  v_plate_no,   v_item_title, v_loc_risk1,
                  v_loc_risk2,  v_loc_risk3,  v_intm_no,    v_car_company,
				  v_orig_tsi_exp, v_reg_pol_sw, v_renewal_id );

	  /*Added by A.R.C. 03.07.2005
	  **To resolve ora-02291 (parent key not found).
	  */
		 v_total_dep_tsi := 0;
		 v_total_dep_prm := 0;
		 FOR a8 IN (
		   SELECT SUM(a.prem_amt * c.currency_rt) prem_amt2,
         	      SUM(a.tsi_amt * c.currency_rt) tsi_amt2,
                  a.line_cd, a.peril_cd,d.peril_type peril_type
             FROM gipi_itmperil a,
                  gipi_polbasic b,
                  gipi_item     c,
				  giis_peril	d
            WHERE b.line_cd         = a2.line_cd
              AND b.subline_cd      = a2.subline_cd
              AND b.iss_cd          = a2.iss_cd
              AND b.issue_yy        = a2.issue_yy
              AND b.pol_seq_no      = a2.pol_seq_no
              AND b.renew_no        = a2.renew_no
			  AND d.peril_cd		= a.peril_cd
			  AND d.line_cd			= a.line_cd
              AND a.policy_id       = b.policy_id
              AND b.policy_id       = c.policy_id
              AND a.policy_id       = b.policy_id
              AND a.item_no         = c.item_no
              AND b.pol_flag        IN('1','2','3')
              AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
            GROUP BY a.peril_cd, a.line_cd, d.peril_type)
         LOOP
           o_line_cd     := a8.line_cd;
           o_peril_cd    := a8.peril_cd;
           o_prem_amt2   := a8.prem_amt2;
           v_orig_tsi_ogrp := a8.tsi_amt2;
		   v_orig_prm_ogrp := a8.prem_amt2;
		   /* rollie 25-OCT-2004
		   ** FOR AUTO COMPUTE OF tsi depreciation
		   ** look up ON TABLE giex_dep_perl */
		   BEGIN
	  		 SELECT 'Y'
			   INTO v_auto_dep
			   FROM giex_dep_perl
			  WHERE line_cd  = a8.line_cd
				AND peril_cd = a8.peril_cd;
		   EXCEPTION
			 WHEN NO_DATA_FOUND THEN
				v_auto_dep := 'N';
			 WHEN TOO_MANY_ROWS THEN
			 	v_auto_dep := 'Y';
		   END;
		   IF a8.line_cd = v_line_mc AND v_auto_dep = 'Y' THEN
		      o_tsi_amt2  := v_orig_tsi_ogrp - (v_orig_tsi_ogrp * (v_dep_pct/100));
			  o_prem_amt2 := v_orig_prm_ogrp - (v_orig_prm_ogrp * (v_dep_pct/100));
		   ELSE
		 	  o_tsi_amt2  := v_orig_tsi_ogrp;
			  o_prem_amt2 := v_orig_prm_ogrp;
		   END IF;

		   IF a8.peril_type = 'B' THEN
			  v_total_dep_tsi := NVL(v_total_dep_tsi,0) + o_tsi_amt2;
    	   END IF;

		   v_total_dep_prm := NVL(v_total_dep_prm,0) + o_prem_amt2;

           INSERT INTO giex_old_group_peril
                     (policy_id,    line_cd,     peril_cd,     prem_amt,
				      tsi_amt,	  	orig_tsi_amt)
           VALUES (a2.policy_id, o_line_cd,   o_peril_cd,   o_prem_amt2,
				      o_tsi_amt2,	v_orig_tsi_ogrp );
         END LOOP;

		 FOR a9 IN (
		   SELECT --SUM(d.tax_amt * c.currency_rt) tax_amt2,
                  d.line_cd, d.tax_cd, d.tax_id, d.iss_cd,
                  e.tax_desc,d.rate rate
             FROM gipi_polbasic b,
                  gipi_invoice  c,
                  gipi_inv_tax  d,
                  giis_tax_charges e
             WHERE b.line_cd         = a2.line_cd
               AND b.subline_cd      = a2.subline_cd
               AND b.iss_cd          = a2.iss_cd
               AND b.issue_yy        = a2.issue_yy
               AND b.pol_seq_no      = a2.pol_seq_no
               AND b.renew_no        = a2.renew_no
               AND b.policy_id       = c.policy_id
               AND d.prem_seq_no     = c.prem_seq_no
               AND d.iss_cd          = b.iss_cd
               AND d.tax_cd          = e.tax_cd
               AND d.tax_id          = e.tax_id
               AND d.iss_cd          = e.iss_cd
               AND d.line_cd         = e.line_cd
               AND b.pol_flag        IN('1','2','3')
               AND NVL(b.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(b.reg_policy_sw,'Y'))
			 GROUP BY d.line_cd, d.tax_cd, d.tax_id, d.iss_cd,e.tax_desc,d.rate  --added by A.R.C. 03.07.2005
             --GROUP BY d.line_cd, d.tax_cd, d.tax_id, d.iss_cd,e.tax_desc,d.rate
			 )
         LOOP
		   -- rollie 09feb2005
		   -- compute depreciated tax_amt = dep_prem * tax_rate
		   v_dep_tax_amt := v_total_dep_prm*(a9.rate/100);
		   INSERT INTO giex_old_group_tax
                       (policy_id,    line_cd,     iss_cd,     tax_cd,
                       tax_id,       tax_desc,    tax_amt)
           VALUES (a2.policy_id, a9.line_cd,  a9.iss_cd,  a9.tax_cd,
                       a9.tax_id,    a9.tax_desc, v_dep_tax_amt);
		   v_dep_tax_amt := 0;
         END LOOP;
		 --added by A.R.C. 03.07.2005
		 UPDATE giex_expiry
            SET tsi_amt = v_total_dep_tsi,
			    prem_amt = v_total_dep_prm
          WHERE policy_id = a2.policy_id;

       END LOOP;
       FOR m IN ( SELECT intrmdry_intm_no
                    FROM gipi_comm_invoice
                   WHERE policy_id = v_pol_id ) LOOP
           UPDATE giex_expiry
              SET intm_no = m.intrmdry_intm_no
            WHERE policy_id = v_pol_id;
           EXIT;
       END LOOP;
     END LOOP;


  END IF;
  DBMS_OUTPUT.PUT_LINE('ENDED PROCEDURE : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
END;
/



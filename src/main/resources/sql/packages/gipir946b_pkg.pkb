CREATE OR REPLACE PACKAGE BODY CPI.gipir946b_pkg  
AS
   FUNCTION get_dt (
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_scope        NUMBER,
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE
   )
      --,p_peril_cd gipi_uwreports_peril_ext.peril_cd%type, p_intm_name)
   RETURN gipir946b_dt_tab PIPELINED
   IS
      rep              get_data_type;
      v_iss_name       VARCHAR2 (50);
      v_param_date     NUMBER (1);
      v_from_date      DATE;
      v_to_date        DATE;
      v_company_name   VARCHAR2 (150);
      v_address        VARCHAR2 (500);
      v_scope          NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_commission     NUMBER (20, 2);
   BEGIN
   
      --CF_ISS_HEADER
         IF p_iss_param = 1
         THEN
            rep.cf_iss_header := 'Crediting Branch';
         ELSIF p_iss_param = 2
         THEN
            rep.cf_iss_header := 'Issue Source';
         ELSE
            rep.cf_iss_header := ' ';
         END IF;

         --CF_HEADING3
         BEGIN
            SELECT DISTINCT param_date, from_date, TO_DATE
                       INTO v_param_date, v_from_date, v_to_date
                       FROM gipi_uwreports_peril_ext
                      WHERE user_id = p_user_id;

            IF v_param_date IN (1, 2, 4)
            THEN
               IF v_from_date = v_to_date
               THEN
                  rep.cf_heading :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
               ELSE
                  rep.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
                ELSE
               IF v_from_date = v_to_date
               THEN
                  rep.cf_heading :=
                        'For the month of '
                     || TO_CHAR (v_from_date, 'fmMonth, yyyy');
               ELSE
                  rep.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            END IF;
         END;   

         --CF_COMPANY
         BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';

            rep.cf_company := v_company_name;
         END;

         --CF_COMPANY_ADDRESS
         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';

            rep.cf_com_address := v_address;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
               rep.cf_com_address := v_address;
         END;

         --CF_BASED_ON
         BEGIN
            SELECT param_date
              INTO v_param_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id AND ROWNUM = 1;

            IF v_param_date = 1
            THEN
               v_based_on := 'Based on Issue Date';
            ELSIF v_param_date = 2
            THEN
               v_based_on := 'Based on Inception Date';
            ELSIF v_param_date = 3
            THEN
               v_based_on := 'Based on Booking month - year';
            ELSIF v_param_date = 4
            THEN
               v_based_on := 'Based on Acctg Entry Date';
            END IF;

            v_scope := p_scope;

            IF v_scope = 1
            THEN
               rep.cf_based_on := v_based_on || ' / ' || 'Policies Only';
            ELSIF v_scope = 2
            THEN
               rep.cf_based_on := v_based_on || ' / ' || 'Endorsements Only';
            ELSIF v_scope = 3
            THEN
               rep.cf_based_on :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
            END IF;
         END;
         
      FOR rec IN (SELECT DECODE (p_iss_param,1, cred_branch,iss_cd) iss_cd, 
                         line_cd, 
                         line_name, 
                         subline_cd, 
                         peril_cd,
                         peril_name, 
                         peril_type,
                         SUM(DECODE (peril_type, 'B', tsi_amt, 0)) tsi_basic,
                         SUM(tsi_amt) sumtsi, 
                         SUM (prem_amt) sumprem, 
                         (SELECT subline_name FROM giis_subline b
                          WHERE a.subline_cd = b.subline_cd
                          AND a.line_cd = b.line_cd) subline_name, SUM(a.commission_amt) commission_amt --Added by pjsantos 03/08/2017, for optimization GENQA 5912
                      FROM gipi_uwreports_peril_ext a
                     --WHERE user_id = USER
                     WHERE user_id = p_user_id
                    --AND iss_cd =NVL( p_iss_cd, iss_cd)
                       AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                              NVL (p_iss_cd,DECODE (p_iss_param,1, cred_branch,iss_cd ))
                       AND line_cd = NVL (p_line_cd, line_cd)
                       AND subline_cd = NVL (p_subline_cd, subline_cd)
                       AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                            OR (p_scope = 1 AND endt_seq_no = 0)
                            OR (p_scope = 2 AND endt_seq_no > 0)
                           )
                  GROUP BY DECODE (p_iss_param, 1, cred_branch, iss_cd),
                           line_cd,
                           line_name,
                           --subline_name,
                           --iss_name,
                           subline_cd,                
                           peril_cd,
                           peril_name,
                           peril_type
                  ORDER BY iss_cd, line_cd, subline_cd, peril_name)
      LOOP
         rep.iss_cd := rec.iss_cd;
         rep.line_cd := rec.line_cd;
         rep.line_name := rec.line_name;
         rep.subline_cd := rec.subline_cd;
         rep.subline_name := rec.subline_name;
         rep.peril_cd := rec.peril_cd;
         rep.peril_name := rec.peril_name;
         rep.peril_type := rec.peril_type;
         rep.sumtsi := rec.sumtsi;
         rep.sumprem := rec.sumprem;
         rep.tsi_basic := rec.tsi_basic;


        /* --CF_ISS_HEADER
         IF p_iss_param = 1
         THEN
            rep.cf_iss_header := 'Crediting Branch';
         ELSIF p_iss_param = 2
         THEN
            rep.cf_iss_header := 'Issue Source';
         ELSE
            rep.cf_iss_header := ' ';
         END IF;

         --CF_HEADING3
         BEGIN
            SELECT DISTINCT param_date, from_date, TO_DATE
                       INTO v_param_date, v_from_date, v_to_date
                       FROM gipi_uwreports_peril_ext
                      WHERE user_id = p_user_id;

            IF v_param_date IN (1, 2, 4)
            THEN
               IF v_from_date = v_to_date
               THEN
                  rep.cf_heading :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
               ELSE
                  rep.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
                ELSE
               IF v_from_date = v_to_date
               THEN
                  rep.cf_heading :=
                        'For the month of '
                     || TO_CHAR (v_from_date, 'fmMonth, yyyy');
               ELSE
                  rep.cf_heading :=
                        'For the period of '
                     || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                     || ' to '
                     || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
               END IF;
            END IF;
         END;   

         --CF_COMPANY
         BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';

            rep.cf_company := v_company_name;
         END;

         --CF_COMPANY_ADDRESS
         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';

            rep.cf_com_address := v_address;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
               rep.cf_com_address := v_address;
         END;

         --CF_BASED_ON
         BEGIN
            SELECT param_date
              INTO v_param_date
              FROM gipi_uwreports_peril_ext
             WHERE user_id = p_user_id AND ROWNUM = 1;

            IF v_param_date = 1
            THEN
               v_based_on := 'Based on Issue Date';
            ELSIF v_param_date = 2
            THEN
               v_based_on := 'Based on Inception Date';
            ELSIF v_param_date = 3
            THEN
               v_based_on := 'Based on Booking month - year';
            ELSIF v_param_date = 4
            THEN
               v_based_on := 'Based on Acctg Entry Date';
            END IF;

            v_scope := p_scope;

            IF v_scope = 1
            THEN
               rep.cf_based_on := v_based_on || ' / ' || 'Policies Only';
            ELSIF v_scope = 2
            THEN
               rep.cf_based_on := v_based_on || ' / ' || 'Endorsements Only';
            ELSIF v_scope = 3
            THEN
               rep.cf_based_on :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
            END IF;
         END;*/--Moved to top by pjsantos 03/02/2017, for optimization GENQA 5912
         
         
         
       	begin
  	    select iss_name
  	    into v_iss_name
        from giis_issource
        where iss_cd = rec.iss_cd;
        exception
	    when no_data_found or too_many_rows then
	    null;
        end;
        rep.iss_name :=  rec.iss_cd ||' - '||v_iss_name;
        rep.cf_new_commission := rec.commission_amt;--cpi.gipir946b_pkg.GET_CF_COMMISSION(rep.subline_cd, rep.line_cd, rep.iss_cd, rep.peril_cd, p_scope, p_iss_param, p_user_id); Added by pjsantos 03/08/2017, for optimization GENQA 5912


         PIPE ROW (rep);
      END LOOP;
   END;

   FUNCTION get_cf_commission (
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_peril_cd     gipi_uwreports_peril_ext.peril_cd%TYPE,
      p_scope        NUMBER,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE
   )
      RETURN NUMBER
is
        v_from_date DATE;
        v_to_date  DATE;
        v_fund_cd  giac_new_comm_inv.fund_cd%TYPE;
        v_branch_cd giac_new_comm_inv.branch_cd%TYPE;
	    v_commission	    number(20,2);
	    v_commission_amt	number(20,2);
	    v_comm_amt  	    number(20,2);
	    v_comm_rec_id			number;
	    v_min_comm_rec_id number;
	    found_flag				number(1) := 0 ; -- initializes to 0 meaning not found
begin
  
  SELECT DISTINCT to_date 
    INTO v_to_date
    FROM gipi_uwreports_peril_ext
   WHERE user_id = p_user_id;     
	
  FOR rc IN (SELECT b.iss_cd, b.prem_seq_no, b.policy_id, b.peril_cd, a.iss_cd a_iss_cd, e.currency_rt,
  									SUM(d.ri_comm_amt) ri_comm_amt, SUM(b.commission_amt) commission_amt
               FROM gipi_uwreports_peril_ext a,
                    gipi_comm_inv_peril b,
                    gipi_invperil d,
                    gipi_invoice e
	            WHERE a.policy_id = b.policy_id
	            AND a.intm_no = b.intrmdry_intm_no
                AND a.peril_cd  = b.peril_cd
                AND a.policy_id = e.policy_id
                AND e.iss_cd = d.iss_cd
                AND e.prem_seq_no = d.prem_seq_no
                AND a.user_id      = p_user_id
	            AND d.peril_cd = a.peril_cd       
			    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = p_iss_cd			 
                AND a.line_cd      = p_line_cd
                AND subline_cd = p_subline_cd
                AND a.peril_cd   = p_peril_cd                 
                AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                 OR  (p_scope=1 AND endt_seq_no=0)
                 OR  (p_scope=2 AND endt_seq_no>0)) 
           GROUP BY b.iss_cd, b.prem_seq_no, b.policy_id, b.peril_cd, a.iss_cd, e.currency_rt)  
   LOOP      	
   	  IF rc.a_iss_cd = 'RI' THEN
   	  	 v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
   	  ELSE
         v_commission_amt := rc.commission_amt;              
          FOR c1 IN (SELECT a.peril_cd, SUM(a.commission_amt) commission_amt
                       FROM GIAC_PREV_COMM_INV_PERIL a,
                         		GIAC_PREV_COMM_INV b
                      WHERE 1 = 1
					    					AND b.comm_rec_id = a.comm_rec_id
												AND b.intm_no = a.intm_no
												AND a.peril_cd = rc.peril_cd
                        AND a.comm_rec_id = (SELECT MIN(N.COMM_REC_ID)  
                                               FROM GIAC_NEW_COMM_INV_PERIL n, 
                                               			GIAC_NEW_COMM_INV c,
                                               			GIPI_INVOICE i
                                              WHERE n.iss_cd = i.iss_cd
                                              AND n.prem_seq_no = i.prem_seq_no 
                                              AND n.comm_rec_id = c.comm_rec_id
                                              AND n.iss_cd = c.iss_cd
                                              AND n.prem_seq_no = c.prem_seq_no
                                              AND n.iss_cd = rc.iss_cd
                                              AND n.prem_seq_no = rc.prem_seq_no
                                              AND n.peril_cd = rc.peril_cd
                                              AND n.tran_flag          = 'P'
                                              AND NVL(n.delete_sw,'N') = 'N'                                           
                                              AND c.acct_ent_date > i.acct_ent_date)                     
      								 AND acct_ent_date = v_to_date
      					  GROUP BY a.peril_cd)      								 
	      	LOOP             	
	           found_flag := 1;     
	               v_commission_amt := NVL(c1.commission_amt, 0);
	            EXIT;                 
	      	END LOOP;
              
        IF found_flag = 0 THEN
      /*
      **jeremy 06012010
      **added another for loop, for bills that has been modified
      **changed the intermediary after batch..
      **if not found in the first loop, then the second loop will check the record
      */
             FOR c1 IN (SELECT a.commission_amt
                       FROM GIAC_PREV_COMM_INV_PERIL a,
                         		GIAC_PREV_COMM_INV b
                      WHERE 1 = 1
					    					AND b.comm_rec_id = a.comm_rec_id
												AND b.intm_no = a.intm_no
												AND a.peril_cd = rc.peril_cd
                        AND a.comm_rec_id = (SELECT MIN(N.COMM_REC_ID)  
                                               FROM GIAC_NEW_COMM_INV_PERIL n, 
                                               			GIAC_NEW_COMM_INV c,
                                               			GIPI_INVOICE i
                                              WHERE n.iss_cd = i.iss_cd
                                              AND n.prem_seq_no = i.prem_seq_no 
                                              AND n.comm_rec_id = c.comm_rec_id
                                              AND n.iss_cd = c.iss_cd
                                              AND n.prem_seq_no = c.prem_seq_no
                                              AND n.iss_cd = rc.iss_cd
                                              AND n.prem_seq_no = rc.prem_seq_no
                                              AND n.peril_cd = rc.peril_cd
                                              AND n.tran_flag          = 'P'
                                              AND NVL(n.delete_sw,'N') = 'Y'                                            
                                              AND c.acct_ent_date > i.acct_ent_date)  
      								 AND acct_ent_date = v_to_date)      								 
      				LOOP              
                    v_commission_amt := NVL(c1.commission_amt, 0);
            	EXIT;                 
      				END LOOP;
          
        END IF;
   	  	 v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0);  	          
   	  END IF;	
   		v_commission := NVL(v_commission,0) + NVL(v_comm_amt,0);   		
   END LOOP;	      
   RETURN (v_commission);
end;
END gipir946b_pkg;
/



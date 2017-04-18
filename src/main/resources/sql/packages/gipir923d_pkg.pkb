CREATE OR REPLACE PACKAGE BODY CPI.gipir923d_pkg
AS
   FUNCTION get_dt (
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
     -- p_from_date    gipi_uwreports_ext.from_date%TYPE,
     -- p_to_date      gipi_uwreports_ext.TO_DATE%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN gipir923d_tab PIPELINED
   IS
      v_dt   get_data_type;
      v_param_date number(1);
      v_from_date date;
      v_to_date date;
      v_param_date2  number(1);
      v_based_on varchar2(100);
      v_scope number(1);
      
   BEGIN
      FOR rec IN
         (SELECT   TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'MM'), '13')
                             ) acctg_seq,
                   NVL (TO_CHAR (acct_ent_date, 'FMMONTH, RRRR'),
                        'NOT TAKEN UP'
                       ) acct_ent_date,
                   line_cd, subline_cd, iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_head,
                   issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                   endt_seq_no, get_policy_no (policy_id) policy_no,
                   issue_date, incept_date, expiry_date, total_tsi total_tsi,
                   total_prem total_prem, evatprem evatprem, lgt lgt,
                   doc_stamps doc_stamp, fst fst, other_taxes other_taxes,
                   (total_prem + evatprem + lgt + doc_stamps + fst
                    + other_taxes
                   ) "TOTAL CHARGES",
                   param_date, from_date, TO_DATE, SCOPE, user_id, policy_id,
                   assd_no
              FROM gipi_uwreports_ext gp
             WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, cred_branch, iss_cd)
                          )
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND p_scope = 3
               AND pol_flag = '4'
          UNION
          SELECT   TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'MM'), '13')
                             ) acctg_seq,
                   NVL (TO_CHAR (spld_acct_ent_date, 'FMMONTH, RRRR'),
                        'NOT TAKEN UP'
                       ) acct_ent_date,
                   line_cd, subline_cd, iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_head,
                   issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                   endt_seq_no, get_policy_no (policy_id) || '*' policy_no,
                   issue_date, incept_date, expiry_date,
                   -1 * total_tsi total_tsi, -1 * total_prem total_prem,
                   -1 * evatprem evatprem, -1 * lgt lgt,
                   -1 * doc_stamps doc_stamp, -1 * fst fst,
                   -1 * other_taxes other_taxes,
                     -1
                   * (total_prem + evatprem + lgt + doc_stamps + fst
                      + other_taxes
                     ) "TOTAL CHARGES",
                   param_date, from_date, TO_DATE, SCOPE, user_id, policy_id,
                   assd_no
              FROM gipi_uwreports_ext gp
             WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
               AND iss_cd = NVL (p_iss_cd, iss_cd)
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND p_scope = 3
               AND pol_flag = '4'
               AND spld_acct_ent_date IS NOT NULL
          ORDER BY acctg_seq,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no)
      LOOP
         v_dt.iss_cd := rec.iss_cd;
         v_dt.line_cd := rec.line_cd;
         v_dt.subline_cd := rec.subline_cd;
         v_dt.policy_id := rec.policy_id;
         v_dt.policy_no := rec.policy_no;
         v_dt.iss_cd_head := rec.iss_cd_head;
         v_dt.acctg_seq := rec.acctg_seq;
         v_dt.acct_ent_date := rec.acct_ent_date;
         v_dt.issue_yy := rec.issue_yy;
         v_dt.pol_seq_no := rec.pol_seq_no;
         v_dt.renew_no := rec.renew_no;
         v_dt.endt_iss_cd := rec.endt_iss_cd;
         v_dt.endt_yy := rec.endt_yy;
         v_dt.endt_seq_no := rec.endt_seq_no;
         v_dt.issue_date := rec.issue_date;
         v_dt.incept_date := rec.incept_date;
         v_dt.expiry_date := rec.expiry_date;
         v_dt.total_tsi := rec.total_tsi;
         v_dt.total_prem := rec.total_prem;
         v_dt.evatprem := rec.evatprem;
         v_dt.lgt := rec.lgt;
         v_dt.doc_stamp := rec.doc_stamp;
         v_dt.fst := rec.fst;
         v_dt.other_taxes := rec.other_taxes;
         v_dt.total_charges := rec."TOTAL CHARGES";
         v_dt.param_date := rec.param_date;
         v_dt.from_date := rec.from_date;
         v_dt.TO_DATE := rec.TO_DATE;
         v_dt.SCOPE := rec.SCOPE;
         v_dt.user_id := rec.user_id;
         v_dt.assd_no := rec.assd_no;
         
         begin
         select distinct param_date, from_date, to_date 
         into v_param_date, v_from_date, v_to_date
         from gipi_uwreports_ext 
         where user_id = p_user_id; -- marco - 02.05.2013 - changed from USER
  
         if v_param_date in (1,2,4) then
         if v_from_date = v_to_date then
  		 v_dt.cf_heading := 'For '||to_char(v_from_date,'fmMonth dd, yyyy');
    	 else 
  		 v_dt.cf_heading := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
  							||to_char(v_to_date,'fmMonth dd, yyyy');
    	 end if;
         else
    	 if TO_CHAR(v_from_date,'MMYYYY') = TO_CHAR(v_to_date,'MMYYYY') then
  		 v_dt.cf_heading := 'For the month of '||to_char(v_from_date,'fmMonth, yyyy');
    	 else 
  		 v_dt.cf_heading := 'For the period of '||to_char(v_from_date,'fmMonth, yyyy')||' to '
  							||to_char(v_to_date,'fmMonth, yyyy');
    	 end if;

        end if;
        
       end;
         
         begin
         select param_value_v
         into v_dt.cf_company
         from giis_parameters
         where UPPER(param_name) = 'COMPANY_NAME';
         end;
         
         begin
         select param_value_v
         into v_dt.cf_comaddress
         from giis_parameters 
         where param_name = 'COMPANY_ADDRESS';
        
          exception
          when no_data_found then null;
  
          end;
         
        begin
         select param_date
         into v_param_date2
         from gipi_uwreports_ext
         where user_id = p_user_id -- marco - 02.05.2013 - changed from USER
         and rownum = 1;
    
         if v_param_date = 1 then
       	 v_based_on := 'Based on Issue Date';
         elsif v_param_date = 2 then
         v_based_on := 'Based on Inception Date';
         elsif v_param_date = 3 then
    	 v_based_on := 'Based on Booking month - year';
         elsif v_param_date = 4 then
  	     v_based_on := 'Based on Acctg Entry Date';
         end if;
  
         v_scope:= P_SCOPE;
    
         if v_scope = 1 then
    	 v_dt.cf_based_on := v_based_on|| '/' ||'Policies Only';
         elsif v_scope = 2 then
  	     v_dt.cf_based_on := v_based_on|| '/' ||'Endorsements Only';
         elsif v_scope = 3 then
  	     v_dt.cf_based_on := v_based_on|| '/' ||'Policies and Endorsements';
         end if;  	
        
        end;
        
       begin
	    begin
  	    select iss_name
  	    into v_dt.cf_iss_name
        from giis_issource
        where iss_cd = v_dt.iss_cd_head;
         exception
	     when no_data_found or too_many_rows then
	     null;
         end;
        v_dt.cf_iss_name := v_dt.iss_cd_head||' - '||v_dt.cf_iss_name;  
       end;
       
       
       begin
        IF P_ISS_PARAM = 2 THEN
  	    v_dt.cf_iss_title := 'Issue Source     :';
        ELSE
  	    v_dt.cf_iss_title := 'Crediting Branch :';
         END IF;
  
       end;
         
       BEGIN
         FOR c IN (SELECT line_name 
              FROM giis_line
             WHERE line_cd = v_dt.line_cd)
         LOOP
           v_dt.cf_line_name := c.line_name;
         END LOOP;
       END;
       
       BEGIN
         FOR c IN (SELECT subline_name 
              FROM giis_subline
             WHERE subline_cd = v_dt.subline_cd
               AND line_cd = v_dt.line_cd)
         LOOP
           v_dt.cf_subline_name := c.subline_name;
         END LOOP;
       END;
       
       
       BEGIN
        FOR c IN (SELECT assd_name 
              FROM giis_assured
             WHERE assd_no = v_dt.assd_no)
        LOOP
         v_dt.cf_assd_name := c.assd_name;
        END LOOP;
       END;
       
         PIPE ROW (v_dt);
      END LOOP;

      RETURN;
   END;
END gipir923d_pkg;
/



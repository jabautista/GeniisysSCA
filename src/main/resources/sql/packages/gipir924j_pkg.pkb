CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924J_PKG
AS
    /*
    **  Created by   :  Steven Ramirez
    **  Date Created : 01.17.2012
    **  Reference By : GIPIR924J - List of Cancelled Policies
    */
	
	FUNCTION populate_gipir924j(  p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
								  p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
								  p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
								  p_iss_param    VARCHAR2,
								  p_scope     	 gipi_uwreports_ext.SCOPE%TYPE,
								  p_user_id 	 gipi_uwreports_ext.user_id%TYPE)
	RETURN report_tab PIPELINED
	AS
	  rep             	report_type;
	  v_param_date 		NUMBER(1);
	  v_from_date 		DATE;
	  v_to_date 		DATE;
	  v_heading3 		VARCHAR2(150);
	  v_company_name 	VARCHAR2(150);
	  v_based_on 		VARCHAR2(100);
  	  v_policy_label 	VARCHAR2(200);
	  v_address			VARCHAR2(500);
	  v_iss_name		GIIS_ISSOURCE.iss_name%TYPE;
	  v_param_v			VARCHAR2(1);
	BEGIN
		FOR i IN (SELECT line_cd,                                                 
						subline_cd,                                               
               			decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) iss_cd, 
					 	SUM(NVL(total_tsi,0)) total_si, 
               			SUM(NVL(total_prem,0)) total_prem,        
						SUM(NVL(evatprem,0)) evatprem,                                
						SUM(NVL(fst,0)) fst,
               			SUM(NVL(lgt,0)) lgt,                                 
						SUM(NVL(doc_stamps,0)) doc_stamps,        
						SUM(NVL(other_taxes,0)) other_taxes,    
						SUM(NVL(other_charges,0)) other_charges,
						SUM(NVL(total_prem,0))+SUM(NVL(evatprem,0))+SUM(NVL(fst,0)) + SUM(NVL(lgt,0))+SUM(NVL(doc_stamps,0))+SUM(NVL(other_taxes,0))+SUM(NVL(other_charges,0)) total, 
						COUNT(policy_id) pol_count,
						SUM(NVL(evatprem,0))+SUM(NVL(fst,0))+SUM(NVL(lgt,0))+SUM(NVL(doc_stamps,0))+SUM(NVL(other_taxes,0))+SUM(NVL(other_charges,0)) total_taxes
    				FROM gipi_uwreports_ext gp
						WHERE user_id = p_user_id
						AND decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,gp.cred_branch,gp.iss_cd))
						AND line_cd =NVL( p_line_cd, line_cd)
						AND subline_cd =NVL( p_subline_cd, subline_cd)
						AND p_scope=3 AND pol_flag='4' 
						/*AND endt_seq_no = (SELECT MAX(endt_seq_no)
															 FROM gipi_uwreports_ext a
														  WHERE 1=1
										AND a.line_cd    = gp.line_cd
																AND a.subline_cd = gp.subline_cd
																AND a.iss_cd     = gp.iss_cd
																AND issue_yy     = gp.issue_yy
										AND pol_seq_no   = gp.pol_seq_no
													AND a.renew_no   = gp.renew_no
										AND pol_flag     ='4')*/
														   GROUP BY line_cd,subline_cd,decode(p_iss_param,1,gp.cred_branch,gp.iss_cd)
														   ORDER BY decode(p_iss_param,1,gp.cred_branch,gp.iss_cd),line_cd,subline_cd)
		LOOP
			rep.line_cd              := i.line_cd;
		  	rep.subline_cd           := i.subline_cd;
		  	rep.iss_cd               := i.iss_cd;
		  	rep.total_si             := i.total_si;
		  	rep.total_prem           := i.total_prem;
		  	rep.evatprem             := i.evatprem;
		  	rep.fst                  := i.fst;
		  	rep.lgt                  := i.lgt;
		  	rep.doc_stamps           := i.doc_stamps;
		  	rep.other_taxes          := i.other_taxes;
		  	rep.other_charges        := i.other_charges;
		  	rep.total                := i.total;
		  	rep.pol_count            := i.pol_count;
		  	rep.total_taxes          := i.total_taxes;

			--for the cf_iss_name
			BEGIN
				SELECT iss_name
				  INTO v_iss_name
				  FROM giis_issource
				 WHERE iss_cd = i.iss_cd;
				EXCEPTION
				   WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
					 v_iss_name := '';
			END;
				rep.cf_iss_name :=i.iss_cd||' - '||v_iss_name;
				
			--for the cf_iss_title
			IF p_iss_param = 2 THEN
				rep.cf_iss_title := 'Issue Source     :';
			ELSE
				rep.cf_iss_title := 'Crediting Branch :';
			END IF;
			
			--for the cf_line_name
			FOR line IN(SELECT line_name
				   FROM giis_line 
				WHERE line_cd = i.line_cd)
			LOOP
				rep.cf_line_name := line.line_name;
			END LOOP; 
			
			--for the cf_subline_name
			FOR subline IN(SELECT subline_name
			   FROM giis_subline 
			WHERE line_cd = i.line_cd
			  AND subline_cd = i.subline_cd)
			LOOP
				rep.cf_subline_name := subline.subline_name;
			END LOOP;
			
			--for the cf_company
		  BEGIN
			  SELECT param_value_v
				 INTO v_company_name
				 FROM giis_parameters
				 WHERE UPPER(param_name) = 'COMPANY_NAME';
				 
			 EXCEPTION WHEN NO_DATA_FOUND THEN 
				 v_company_name := NULL;	
		  END;
		  rep.cf_company := v_company_name;
		  
		  --for the cf_company_address
		  BEGIN
			  SELECT param_value_v
				INTO v_address
				FROM giis_parameters 
			   WHERE param_name = 'COMPANY_ADDRESS';
			   
			EXCEPTION WHEN NO_DATA_FOUND THEN 
				v_address := NULL;
		 END;
			rep.cf_company_address := v_address;
			
			--for the cf_based_on
		  SELECT param_date
			INTO v_param_date
			FROM gipi_uwreports_ext
		   WHERE user_id = p_user_id
		   AND rownum = 1;
		  
		  IF v_param_date = 1 THEN
			 v_based_on := 'Based on Issue Date';
		  ELSIF v_param_date = 2 THEN
			 v_based_on := 'Based on Inception Date';
		  ELSIF v_param_date = 3 THEN
			 v_based_on := 'Based on Booking month - year';
		  ELSIF v_param_date = 4 THEN
			 v_based_on := 'Based on Acctg Entry Date';
		  END IF;
	
		  IF p_scope = 1 THEN
			 v_policy_label := v_based_on||' / '||'Policies Only';
		  ELSIF p_scope = 2 THEN
			 v_policy_label := v_based_on||' / '||'Endorsements Only';
		  ELSIF p_scope = 3 THEN
			 v_policy_label := v_based_on||' / '||'Policies and Endorsements';
		  END IF; 
		  rep.cf_based_on := v_policy_label;
			
			--for the cf_heading3 
		  SELECT DISTINCT param_date, from_date, to_date 
			INTO v_param_date, v_from_date, v_to_date
			FROM GIPI_UWREPORTS_EXT  
			WHERE user_id = p_user_id;
		  
		  IF v_param_date in (1,2,4) THEN
			IF v_from_date = v_to_date THEN
				v_heading3 := 'For '||to_char(v_from_date,'fmMonth dd, yyyy');
			ELSE 
				v_heading3 := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
									||to_char(v_to_date,'fmMonth dd, yyyy');
			END IF;
		  ELSE
			IF v_from_date = v_to_date THEN
				v_heading3 := 'For the month of '||to_char(v_from_date,'fmMonth, yyyy');
			ELSE 
				v_heading3 := 'For the period of '||to_char(v_from_date,'fmMonth, yyyy')||' to '
									||to_char(v_to_date,'fmMonth, yyyy');
			END IF;
		  END IF;	
		  rep.cf_heading3 := v_heading3;
		  
		  --for SHOW_TOTAL_TAXES condition
		  BEGIN
			  SELECT giacp.v ('SHOW_TOTAL_TAXES')
				INTO v_param_v
				FROM DUAL;
			  EXCEPTION WHEN NO_DATA_FOUND THEN 
					 v_param_v := 'N';	
		  END;
	      rep.param_v := v_param_v;
		  
		  PIPE ROW (rep);
		END LOOP;
	END populate_gipir924j;
	
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIPIS179_PKG
AS 
   FUNCTION get_gipis179_list(
      p_user_id         giex_rn_no.user_id%TYPE
   ) RETURN gipis179_tab PIPELINED AS
      v_list            gipis179_type;
      v_eff_date        gipi_polbasic.eff_date%TYPE; 
      v_dsp_line_cd     gipi_polbasic.line_cd%TYPE;
      v_dsp_subline_cd  gipi_polbasic.subline_cd%TYPE;
	   v_dsp_iss_cd      gipi_polbasic.iss_cd%TYPE;
	   v_dsp_issue_yy    gipi_polbasic.issue_yy%TYPE;
	   v_dsp_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
	   v_dsp_renew_no    gipi_polbasic.renew_no%TYPE;
      v_assd_no         giis_assured.assd_no%TYPE;
   BEGIN
      FOR i IN (SELECT * 
                  FROM giex_rn_no
                 WHERE check_user_per_iss_cd2(line_cd,iss_cd,'GIPIS179',p_user_id) = 1)
      LOOP
         v_list.with_renewal := 'N';
         
         FOR R IN (SELECT '1'
	                  FROM gipi_polnrep
	                 WHERE old_policy_id = i.policy_id)
	      LOOP
		      v_list.with_renewal := 'Y';
	         EXIT;
	      END LOOP;
         
         v_list.policy_number := get_policy_no(i.policy_id);
         FOR A IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
	                  FROM gipi_polbasic
	                 WHERE policy_id = i.policy_id) 
         LOOP
            v_dsp_line_cd    := a.line_cd;
            v_dsp_subline_cd := a.subline_cd;
            v_dsp_iss_cd     := a.iss_cd;
            v_dsp_issue_yy   := a.issue_yy;
            v_dsp_pol_seq_no := a.pol_seq_no;
            v_dsp_renew_no   := a.renew_no;            	 
            EXIT;
         END LOOP;    
         
         FOR pol IN (SELECT assd_no, eff_date
                       FROM gipi_polbasic
                      WHERE line_cd    = v_dsp_line_cd  
                        AND subline_cd = v_dsp_subline_cd  
                        AND iss_cd     = v_dsp_iss_cd  
                        AND issue_yy   = v_dsp_issue_yy
                        AND pol_seq_no = v_dsp_pol_seq_no    
                        AND renew_no   = v_dsp_renew_no  
                        AND assd_no IS NOT NULL
                      ORDER BY eff_date DESC) 
         LOOP
            v_assd_no  := pol.assd_no;	              
            v_eff_date := pol.eff_date;  
		      EXIT;
	      END LOOP;	  
         
         FOR Z3 IN (SELECT endt_seq_no, assd_no
                      FROM gipi_polbasic b2501
                     WHERE b2501.line_cd    = v_dsp_line_cd  
                       AND b2501.subline_cd = v_dsp_subline_cd  
                       AND b2501.iss_cd     = v_dsp_iss_cd  
                       AND b2501.issue_yy   = v_dsp_issue_yy 
                       AND b2501.pol_seq_no = v_dsp_pol_seq_no
                       AND b2501.renew_no   = v_dsp_renew_no  
                       AND b2501.pol_flag   IN ('1','2','3')
                       AND assd_no IS NOT NULL
                       AND nvl(b2501.back_stat,5) = 2
                     ORDER BY endt_seq_no DESC) 
         LOOP
            FOR Z3A IN (SELECT endt_seq_no, eff_date, assd_no
                          FROM gipi_polbasic b2501
                         WHERE b2501.line_cd    = v_dsp_line_cd  
                           AND b2501.subline_cd = v_dsp_subline_cd  
                           AND b2501.iss_cd     = v_dsp_iss_cd  
                           AND b2501.issue_yy   = v_dsp_issue_yy  
                           AND b2501.pol_seq_no = v_dsp_pol_seq_no  
                           AND b2501.renew_no   = v_dsp_renew_no  
                           AND b2501.pol_flag   IN ('1','2','3')
                           AND assd_no IS NOT NULL
                         ORDER BY endt_seq_no DESC) 
            LOOP
               IF Z3.endt_seq_no = Z3a.endt_seq_no THEN
                  v_assd_no  := Z3.assd_no;
               ELSE
                  IF Z3A.eff_date > v_eff_date THEN
                     v_assd_no  := Z3A.assd_no;  
                  ELSE
                     v_assd_no  := Z3.assd_no;  
                  END IF;
               END IF;
               EXIT;
            END LOOP;
            EXIT;
         END LOOP;
         
         FOR C IN (SELECT assd_name
                     FROM giis_assured 
                    WHERE assd_no = v_assd_no)
	      LOOP
	         v_list.assured := c.assd_name;	
	         EXIT;  
	      END LOOP;
         
         v_list.renewal_no := i.line_cd||'-'||i.iss_cd||'-'||TO_CHAR(i.rn_yy)||'-'||LTRIM(TO_CHAR(i.rn_seq_no, '0999999'));
         v_list.user_id := i.user_id;
         v_list.policy_id := i.policy_id;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_renewal_history_list(
      p_policy_id          giex_rn_no.policy_id%TYPE
   ) RETURN renewal_history_tab PIPELINED AS
      v_list               renewal_history_type;
   BEGIN
      FOR i IN (SELECT new_policy_id 
                  FROM gipi_polnrep
                 WHERE old_policy_id = p_policy_id)
      LOOP
         FOR pol IN (SELECT get_policy_no(policy_id) policy_number
                       FROM gipi_polbasic
                      WHERE policy_id = i.new_policy_id )
         LOOP
            v_list.policy_number := pol.policy_number;
            
            PIPE ROW(v_list);
         END LOOP;
      END LOOP;
   END;                           
END;
/



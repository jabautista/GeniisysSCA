CREATE OR REPLACE PACKAGE BODY CPI.GIACR277_PKG_CSV
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.020.2013
    **  Reference By : GIACR277_PKG - SCHEDULE ON MONTHLY COMMISION INCOME
    */
    FUNCTION matrix(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER,
        p_iss           VARCHAR2
    )
    RETURN matrix_tab PIPELINED
    AS v_rec matrix_type;
    BEGIN
      
            FOR a IN (
                        SELECT DISTINCT trty_acct_type FROM giac_comm_income_ext_v 
                            WHERE trty_acct_type IS NOT NULL
                        )
                        
            LOOP
            v_rec.trty_acct_type := a.trty_acct_type;
            v_rec.treaty_prem := 0.00; --start added by Kevin SR-18635 6-28-16
            v_rec.treaty_comm := 0.00;
            v_rec.total_prem := 0.00;
            v_rec.total_comm := 0.00;
            v_rec.total_treaty_prem := 0.00;
            v_rec.total_treaty_comm := 0.00;
            v_rec.iss_treaty_prem := 0.00;
            v_rec.iss_treaty_comm := 0.00;
            v_rec.line_treaty_prem1 := 0.00;
            v_rec.line_treaty_comm1 := 0.00;
            v_rec.line_treaty_prem := 0.00;
            v_rec.line_treaty_comm := 0.00; --end added by Kevin SR-18635 6-28-16
                FOR x IN (
                            SELECT line_cd,
                               DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,                                                
                               policy_id,                                                
                               peril_cd,                                              
                               nvl(treaty_prem,to_number(0.00)) treaty_prem, 
                               nvl(treaty_comm,to_number(0.00)) treaty_comm, 
                               trty_acct_type,
                               nvl(facul_prem,0.00) facul_prem,
                               nvl(facul_comm,0.00) facul_comm
                            FROM giac_comm_income_ext_v
                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                              AND line_cd = nvl(p_line_cd, line_cd)
                              AND user_id = p_user_id
                              AND policy_id = nvl(p_policy_id, policy_id)
                              AND peril_cd = nvl(p_peril_cd,peril_cd)
                              AND iss_cd = nvl(p_iss, iss_cd)
                              AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                            )
                 LOOP
                    IF a.trty_acct_type = x.trty_acct_type THEN
                        v_rec.treaty_prem := x.treaty_prem;
                        v_rec.treaty_comm := x.treaty_comm;
                    END IF;
                    
                    v_rec.line_cd := x.line_cd;
                    v_rec.iss_cd := x.iss_cd;
                    v_rec.policy_id := x.policy_id;
                    v_rec.peril_cd := x.peril_cd;
                    v_rec.trty_acct_type2 := x.trty_acct_type;
                    v_rec.facul_comm := x.facul_comm; --added by Kevin SR-18635
                    v_rec.facul_prem := x.facul_prem; --added by Kevin SR-18635
                     
                    FOR rec IN (SELECT trty_sname
					  FROM giis_ca_trty_type
					   WHERE ca_trty_type = a.trty_acct_type
                       )
                   LOOP
                    v_rec.trty_name := rec.trty_sname;
                    EXIT;
                   END LOOP; 
                   
                   FOR total_t_prem IN (
                                            SELECT line_cd,
                                            DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                 policy_id,
                                                 peril_cd,
                                                 nvl(facul_prem,to_number(0)) TOTAL_f_prem,
                                                 nvl(facul_comm,to_number(0)) TOTAL_f_comm,
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm,
                                                 nvl(facul_prem,to_number(0))+nvl(SUM(treaty_prem),to_number(0)) GRAND_TOTAL_PREM,
                                                 nvl(facul_comm,to_number(0))+ nvl(SUM(treaty_comm),to_number(0)) GRAND_TOTAL_COMM
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')
                                                 AND to_date(p_to, 'MM-DD-YYYY')
                                                 AND line_cd = nvl(x.line_cd,0)
                                                 AND iss_cd = nvl(x.iss_cd,0)
                                                 AND user_id = p_user_id
                                                 AND policy_id = nvl(x.policy_id,0)
                                                 AND peril_cd = nvl(x.peril_cd,0)
                                                 AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                                           GROUP BY line_cd,DECODE(p_iss_param, 1, cred_branch, iss_cd),policy_id,peril_cd,facul_prem,facul_comm
                                           
                                        )
                   LOOP
                    v_rec.total_prem := total_t_prem.GRAND_TOTAL_PREM;
                    v_rec.total_comm := total_t_prem.GRAND_TOTAL_COMM;
                   
                   END LOOP;
                    
                   FOR totals IN (
                                            SELECT line_cd,
                                            DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')                                        
                                                 AND to_date(p_to, 'MM-DD-YYYY')
                                                 AND trty_acct_type = a.trty_acct_type                                                
                                                 AND line_cd = p_line_cd
                                                 AND iss_cd = p_iss
                                                 AND user_id = p_user_id 
                                           GROUP BY DECODE(p_iss_param, 1, cred_branch, iss_cd),line_cd--,trty_acct_type
                 
                                )
                       LOOP              
                       
                        IF a.trty_acct_type = x.trty_acct_type THEN
                            v_rec.total_treaty_prem := totals.TOTAL_treaty_prem;
                            v_rec.total_treaty_comm := totals.TOTAL_treaty_comm;
                        ELSE 
                            null;
                        END IF;
                        EXIT;
                       END LOOP;
                       
                       FOR totals_iss IN (
                                            SELECT line_cd,
                                            DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')                                        
                                                 AND to_date(p_to, 'MM-DD-YYYY')                                            
                                                 AND line_cd = p_line_cd
                                                 AND iss_cd = p_iss
                                                 AND user_id = p_user_id 
                                           GROUP BY DECODE(p_iss_param, 1, cred_branch, iss_cd),line_cd
                       
                                        )
                       LOOP
                         v_rec.iss_treaty_prem := totals_iss.TOTAL_treaty_prem;
                         v_rec.iss_treaty_comm := totals_iss.TOTAL_treaty_comm;
                       END LOOP;
                       
                       FOR totals_line IN (
                                            SELECT line_cd,
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')                                        
                                                 AND to_date(p_to, 'MM-DD-YYYY')                                            
                                                 AND line_cd = p_line_cd
                                                 AND user_id =p_user_id
                                                 AND trty_acct_type = a.trty_acct_type
                                           GROUP BY line_cd
                                            )
                        LOOP
                            v_rec.line_treaty_prem := totals_line.TOTAL_treaty_prem;
                            v_rec.line_treaty_comm := totals_line.TOTAL_treaty_comm;
                        END LOOP;  
                        
                        FOR totals_line1 IN (
                                            SELECT line_cd,
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')                                        
                                                 AND to_date(p_to, 'MM-DD-YYYY')                                            
                                                 AND line_cd = p_line_cd
                                                 AND user_id =p_user_id
                                           GROUP BY line_cd
                                            )
                        LOOP
                            v_rec.line_treaty_prem1 := totals_line1.TOTAL_treaty_prem;
                            v_rec.line_treaty_comm1 := totals_line1.TOTAL_treaty_comm;
                        END LOOP;                  
                 END LOOP;  
                 
                 PIPE ROW(v_rec);  
            END LOOP;                          
    END matrix;                            
    FUNCTION CF_iss_tot_titleFormula(
    x_iss_param VARCHAR2,
    x_iss_cd    VARCHAR2,
    x_line_cd   VARCHAR2
    )
    return Char is
    BEGIN
        IF x_iss_param = 1 THEN
           RETURN('Totals per Crediting Branch ('||(x_iss_cd)||') per Line ('||(x_line_cd)||') :');
      ELSIF x_iss_param = 2 THEN
          RETURN('Totals per Issue Source ('||(x_iss_cd)||') per Line ('||(x_line_cd)||') :');
      ELSE 
         RETURN NULL;
      END IF;
   END;

    FUNCTION cf_iss_headerformula(
        p_iss_param VARCHAR2
    )
       RETURN CHAR
    IS
    BEGIN
       IF p_iss_param = 1
       THEN
          RETURN ('Crediting Branch :');
       ELSIF p_iss_param = 2
       THEN
          RETURN ('Issue Source     :');
       ELSE
          RETURN NULL;
       END IF;
    END;
 

    FUNCTION get_giacr277_record(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER
    )
    RETURN
            giacr277_tab PIPELINED
    IS 
            v_rec giacr277_type;
    BEGIN
    FOR i IN ( 
                SELECT DISTINCT peril_cd,
                                line_cd,
                               DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd, 
                               assd_no, 
                               policy_id, 
                               incept_date,
                               acct_ent_date,
                               nvl(to_number(total_prem_amt),0)total_prem_amt, 
                               nvl(to_number(nr_prem_amt),0)nr_prem_amt,
                               nvl(to_number(facul_prem),0)facul_prem, 
                               nvl(to_number(facul_comm),0)facul_comm
                      FROM giac_comm_income_ext_v
                      WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY') 
                                                                 AND to_date(p_to, 'MM-DD-YYYY')
                      AND line_cd = nvl(p_line_cd, line_cd)
                      AND user_id = p_user_id
                      AND policy_id = nvl(p_policy_id, policy_id)
                      AND peril_cd = nvl(p_peril_cd,peril_cd)
                      --AND (nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --remove by Kevin SR-18635
                      AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0 --added by Kevin SR-18635
                      order by line_cd,iss_cd,policy_id,peril_cd
                )
        LOOP
            v_rec.line_cd := i.line_cd;
            v_rec.iss_cd := i.iss_cd;
            v_rec.assd_no := i.assd_no;
            v_rec.policy_id := i.policy_id;
            v_rec.incept_date := i.incept_date;
            v_rec.acct_ent_date := i.acct_ent_date;
            v_rec.peril_cd := i.peril_cd;
            v_rec.total_prem_amt := i.total_prem_amt;
            v_rec.nr_prem_amt := i.nr_prem_amt; 
            v_rec.facul_prem := i.facul_prem;
            v_rec.facul_comm := i.facul_comm;
            v_rec.iss_header := cf_iss_headerformula(p_iss_param);
            v_rec.title_formula := CF_iss_tot_titleFormula(p_iss_param,i.iss_cd,i.line_cd);
          
            
              FOR rec IN (SELECT upper(param_value_v) param_value_v
  						  FROM giis_parameters
               WHERE param_name = 'COMPANY_NAME') 
              LOOP
                v_rec.comp_name := rec.param_value_v;
                EXIT;
              END LOOP;
              
              
              FOR rec IN (SELECT upper(param_value_v) address    		
    						FROM giis_parameters 
   						 WHERE param_name = 'COMPANY_ADDRESS')
              LOOP
                v_rec.address := rec.address;
                EXIT;
              END LOOP;
              
              IF p_from = p_to THEN
		            v_rec.from_to := 'For '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
	          ELSE	
  	                v_rec.from_to := 'For the period of '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR')||' to '||to_char(to_date(p_to, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
	          END IF;
              
              FOR rec IN (SELECT line_name
    						FROM giis_line
   						 WHERE line_cd  = i.line_cd)
              LOOP
                v_rec.line := i.line_cd||' - '||rec.line_name;
                EXIT;
              END LOOP;
    
              FOR rec IN (SELECT iss_name
     						FROM giis_issource
    					 WHERE iss_cd  = i.iss_cd)
              LOOP
                v_rec.iss_source := i.iss_cd||' - '||rec.iss_name;
                EXIT;
              END LOOP;
              
              FOR rec IN (SELECT assd_name 
         			  FROM giis_assured
        			 WHERE assd_no = i.assd_no)
              LOOP
                v_rec.assd_name := rec.assd_name;
                EXIT;
              END LOOP;
              
              FOR rec IN(SELECT    line_cd
             				|| '-'
             				|| subline_cd
             				|| '-'
             				|| iss_cd
             				|| '-'
             				|| ltrim (to_char (issue_yy, '09'))
             				|| '-'
             				|| ltrim (to_char (pol_seq_no, '0999999'))
             				|| '-'
             				|| ltrim (to_char (renew_no, '09'))
				            || decode (
				                   nvl (endt_seq_no, 0),
				                   0, '',
				                      ' / '
				                   || endt_iss_cd
				                   || '-'
				                   || ltrim (to_char (endt_yy, '09'))
				                   || '-'
				                   || ltrim (to_char (endt_seq_no, '9999999'))
				                ) POLICY
        				FROM gipi_polbasic
       				 WHERE policy_id = i.policy_id)
              LOOP
                v_rec.policy_no := rec.policy;
                EXIT;
              END LOOP;
              
       	      FOR rec IN (SELECT peril_name
     						FROM giis_peril 
    					 WHERE line_cd  = i.line_cd
      					 AND peril_cd = i.peril_cd)
              LOOP
                v_rec.peril_name := rec.peril_name;
                EXIT;
              END LOOP;

              v_rec.name_per_line := 'Totals per Line ('||(i.line_cd)||') :'; 
              
              FOR total IN (SELECT 
                                                 nvl(SUM(treaty_prem),to_number(0)) TOTAL_treaty_prem,
                                                 nvl(SUM(treaty_comm),to_number(0)) TOTAL_treaty_comm
                                            FROM giac_comm_income_ext_v
                                            WHERE acct_ent_date BETWEEN to_date(P_FROM, 'MM-DD-YYYY')
                                                 AND to_date(P_TO, 'MM-DD-YYYY')
                                                 AND line_cd = nvl(p_line_cd,line_cd)
                                                 AND user_id =P_USER_ID
                        AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                        )
               LOOP
                    v_rec.grand_total_prem := total.TOTAL_treaty_prem;
                    v_rec.grand_total_comm := total.TOTAL_treaty_comm;
               END LOOP;
               
        PIPE ROW(v_rec);
        END LOOP;
    END get_giacr277_record;
    
    FUNCTION get_grand_total( --added by Kevin for grand total column error SR-18635 6-1-2016
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2
    )
    RETURN grand_total_tab PIPELINED
    IS
        v_rec grand_total_type;
    BEGIN
        FOR a IN (
                    SELECT DISTINCT trty_acct_type FROM giac_comm_income_ext_v 
                    WHERE trty_acct_type IS NOT NULL
                 )
        LOOP
            v_rec.total_treaty_prem := 0.00;
            v_rec.total_treaty_comm := 0.00;
            v_rec.line_cd := p_line_cd;
            v_rec.trty_acct_type := a.trty_acct_type;
            FOR total IN (
                SELECT line_cd,trty_acct_type,nvl(SUM(treaty_prem),to_number(0)) total_treaty_prem,
                       nvl(SUM(treaty_comm),to_number(0)) total_treaty_comm
                FROM giac_comm_income_ext_v
                WHERE acct_ent_date BETWEEN to_date(p_from, 'MM-DD-YYYY')
                       AND to_date(p_to, 'MM-DD-YYYY')
                       AND line_cd = nvl(p_line_cd,line_cd)
                       AND user_id = p_user_id
                       AND trty_acct_type = a.trty_acct_type
                       AND (nvl(to_number(treaty_comm),0)+nvl(to_number(treaty_prem),0)+nvl(to_number(total_prem_amt),0)+nvl(to_number(nr_prem_amt),0)+nvl(to_number(facul_prem),0)+nvl(to_number(facul_comm),0)) <> 0
                GROUP BY line_cd,trty_acct_type
            )
            LOOP
                v_rec.line_cd := total.line_cd;
                v_rec.trty_acct_type := total.trty_acct_type;
                v_rec.total_treaty_prem := total.total_treaty_prem;
                v_rec.total_treaty_comm := total.total_treaty_comm;
            END LOOP;
            PIPE ROW(v_rec);
        END LOOP;
    END get_grand_total;
END;
/



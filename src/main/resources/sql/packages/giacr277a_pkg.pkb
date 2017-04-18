CREATE OR REPLACE PACKAGE BODY CPI.GIACR277A_pkg
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.023.2013
    **  Reference By : GIACR277_PKG - SCHEDULE OF RI COMMISSION INCOME (SUMMARY)
    */
    FUNCTION cf_iss_headerformula(
    p_iss_param VARCHAR2
    )
       RETURN CHAR
    IS
    BEGIN
       IF p_iss_param = 1
       THEN
          RETURN ('Crediting Branch');
       ELSIF p_iss_param = 2
       THEN
          RETURN ('Issue Source');
       ELSE
          RETURN NULL;
       END IF;
    END;
    FUNCTION main1 (
    p_iss_param VARCHAR2,
    p_from      VARCHAR2,
    p_to        VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user_id   VARCHAR2,
    p_iss       VARCHAR2
    ) 
    RETURN
        main1_tab PIPELINED
    AS
        v_rec main1_type;
    BEGIN
    
                      FOR a IN (
                      
            SELECT a.line_cd, 
                      a.iss_cd, 
                      a.total_prem_amt, 
                      a.nr_prem_amt
            FROM (SELECT line_cd, 
                             iss_cd,
                             SUM(total_prem_amt) total_prem_amt,
                             SUM(nr_prem_amt) nr_prem_amt,
                             SUM(facul_prem) facul_prem,
                             SUM(facul_comm) facul_comm
                    FROM (SELECT DISTINCT line_cd,
                                             DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                             total_prem_amt, 
                                             nr_prem_amt,
                                             facul_prem, 
                                             facul_comm
                                          FROM giac_comm_income_ext_summ_v
                                            WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                            AND TO_DATE(p_to, 'MM-DD-YYYY')
                                            AND line_cd = NVL(p_line_cd, line_cd)
                                            AND user_id = p_user_id)
                                          GROUP BY line_cd, iss_cd) a,
                        (SELECT line_cd,
                                            DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                            SUM(treaty_prem) treaty_prem , 
                                            SUM(treaty_comm) treaty_comm, 
                                            trty_acct_type
                                          FROM giac_comm_income_ext_summ_v
                                            WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                            AND TO_DATE(p_to, 'MM-DD-YYYY')
                                            AND line_cd = NVL(p_line_cd, line_cd)
                                            AND trty_acct_type IS NOT NULL
                                            AND user_id = p_user_id
                                            GROUP BY line_cd, DECODE(p_iss_param, 1, cred_branch, iss_cd),  trty_acct_type) b
       WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
               
        UNION

        SELECT line_cd, 
                       iss_cd,
                       SUM(total_prem_amt) total_prem_amt,
                       SUM(nr_prem_amt) nr_prem_amt
           FROM (SELECT DISTINCT line_cd,
                                      DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                      total_prem_amt, 
                                      nr_prem_amt,
                                      facul_prem, 
                                      facul_comm
                          FROM giac_comm_income_ext_summ_v
                       WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                             AND TO_DATE(p_to, 'MM-DD-YYYY')
                             AND line_cd = NVL(p_line_cd, line_cd)
                             AND user_id = p_user_id)
         GROUP BY line_cd, iss_cd                      
                      )
                      
           LOOP
            v_rec.main_line_cd := a.line_cd;
            v_rec.main_iss_cd := a.iss_cd;
            v_rec.main_total_prem_amt := a.total_prem_amt;
            v_rec.main_nr_prem_amt := a.nr_prem_amt;
            v_rec.iss_header := cf_iss_headerformula(p_iss_param);
            
             FOR x IN (SELECT iss_name
                             FROM giis_issource
                           WHERE iss_cd  = a.iss_cd)
                      LOOP
                        v_rec.iss_source := a.iss_cd||' - '||x.iss_name;
                        EXIT;
                      END LOOP;
                      
            v_rec.total_per_line_name := 'Totals per Line ('||(a.line_cd)||') :';
            
            FOR x IN (SELECT upper(param_value_v) param_value_v
  						  FROM giis_parameters
                       WHERE param_name = 'COMPANY_NAME') 
                       LOOP
                         v_rec.comp_name := x.param_value_v;
                         EXIT;
                       END LOOP;
                       
                      FOR x IN (SELECT upper(param_value_v) address    		
    					FROM giis_parameters 
   				      WHERE param_name = 'COMPANY_ADDRESS')
                      LOOP
                        v_rec.address := x.address;
                        EXIT;
                      END LOOP;
                      
                      IF p_from = p_to THEN
		                    v_rec.from_to := 'For '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
                      ELSE	
                            v_rec.from_to := 'For the period of '||to_char(to_date(p_from, 'MM-DD-RRRR'),'fmMonth DD, RRRR')||' to '||to_char(to_date(p_to, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
                      END IF;
                      
                	  FOR x IN (SELECT line_name
    						FROM giis_line
   						   WHERE line_cd  = a.line_cd)
                      LOOP
                        v_rec.line_cd1 := a.line_cd||' - '||x.line_name;
                        EXIT;
                      END LOOP;        
                      
                      
             PIPE ROW(v_rec);
             END LOOP;           

    END main1;
    

    FUNCTION get_giacr277A_record(
    p_iss_param VARCHAR2,
    p_from      VARCHAR2,
    p_to        VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user_id   VARCHAR2,
    p_iss       VARCHAR2
    ) 
    
    RETURN
        giacr277a_tab PIPELINED
    AS
        v_rec giacr277a_type;
    BEGIN
      FOR counter IN (
                SELECT DISTINCT trty_acct_type from giac_comm_income_ext_v
                WHERE trty_acct_type IS NOT NULL
                    )
      LOOP
        v_rec.trty_acct_type := counter.trty_acct_type;
            FOR i IN (
                        SELECT a.line_cd, 
                                  a.iss_cd, 
                                  a.total_prem_amt, 
                                  a.nr_prem_amt, 
                                  b.treaty_prem,
                                  b.treaty_comm, 
                                  b.trty_acct_type,
                                  a.facul_prem,
                                  a.facul_comm 
                      FROM (SELECT line_cd, 
                                                 iss_cd,
                                                 SUM(total_prem_amt) total_prem_amt,
                                                 SUM(nr_prem_amt) nr_prem_amt,
                                                 nvl(SUM(facul_prem),to_number(0)) facul_prem,
                                                 nvl(SUM(facul_comm), to_number(0)) facul_comm
                                      FROM (SELECT DISTINCT line_cd,
                                                                 DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                                 total_prem_amt, 
                                                                 nr_prem_amt,
                                                                 nvl((facul_prem),to_number(0)) facul_prem,
                                                                 nvl((facul_comm), to_number(0)) facul_comm
                                                     FROM giac_comm_income_ext_summ_v
                                                  WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                                        AND line_cd = NVL(p_line_cd, line_cd)
                                                        AND user_id = p_user_id)
                                     GROUP BY line_cd, iss_cd) a,
                                 (SELECT line_cd,
                                                DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                SUM(treaty_prem) treaty_prem , 
                                                SUM(treaty_comm) treaty_comm, 
                                                trty_acct_type
                                     FROM giac_comm_income_ext_summ_v
                                  WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND line_cd = NVL(p_line_cd, line_cd)
                                        AND trty_acct_type IS NOT NULL
                                        AND user_id = p_user_id
                                   GROUP BY line_cd, DECODE(p_iss_param, 1, cred_branch, iss_cd),  trty_acct_type) b
                    WHERE a.line_cd = b.line_cd
                          AND a.iss_cd = b.iss_cd
                          AND a.iss_cd = NVL(p_iss,a.iss_cd)
                          
                    UNION
                    SELECT line_cd, 
                                   iss_cd,
                                   SUM(total_prem_amt) total_prem_amt,
                                   SUM(nr_prem_amt) nr_prem_amt,
                                   NULL "treaty_prem",
                                   NULL "treaty_comm",
                                   NULL "trty_acct_type",
                                   nvl(SUM(facul_prem),to_number(0)) facul_prem,
                                   nvl(SUM(facul_comm), to_number(0)) facul_comm
                       FROM (SELECT DISTINCT line_cd,
                                                  DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                  total_prem_amt, 
                                                  nr_prem_amt,
                                                  nvl((facul_prem),to_number(0)) facul_prem,
                                                  nvl((facul_comm), to_number(0)) facul_comm
                                      FROM giac_comm_income_ext_summ_v
                                   WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                         AND TO_DATE(p_to, 'MM-DD-YYYY')
                                         AND line_cd = nvl(p_line_cd,line_cd)
                                         AND user_id = p_user_id
                                         )
                     GROUP BY line_cd, iss_cd

                )

      LOOP
      IF i.trty_acct_type = counter.trty_acct_type THEN
               v_rec.treaty_prem:=i.treaty_prem;
               v_rec.treaty_comm := i.treaty_comm;
               v_rec.facul_prem := i.facul_prem;
               v_rec.facul_comm := i.facul_comm; 

      END IF;
       v_rec.line_cd := p_line_cd;
       v_rec.iss_cd := p_iss;
       v_rec.total_prem_amt := i.total_prem_amt; 
       v_rec.nr_prem_amt:= i.nr_prem_amt;
       
       FOR rec IN (SELECT trty_sname
							  FROM giis_ca_trty_type
							 WHERE ca_trty_type = counter.trty_acct_type
                             )
        LOOP
            v_rec.trty_name := rec.trty_sname;
            EXIT;
        END LOOP;
        
        FOR rec IN (
                                     SELECT line_cd,
                                                DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                nvl(SUM(treaty_prem),to_number(0)) treaty_prem , 
                                                nvl(SUM(treaty_comm), to_number(0)) treaty_comm                                             
                                     FROM  giac_comm_income_ext_summ_v 
                                     WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND line_cd = NVL(p_line_cd,line_cd)
                                        AND user_id = p_user_id
                                        AND iss_cd = NVL(p_iss,iss_cd)
                                   GROUP BY line_cd,DECODE(p_iss_param, 1, cred_branch, iss_cd)
                                
        
                    )
        LOOP
            v_rec.total_detail_t_prem := rec.treaty_prem;
            v_rec.total_detail_t_comm := rec.treaty_comm;
        END LOOP;
        
        FOR rec IN (
                                      SELECT line_cd, 
                                                 iss_cd,
                                                 nvl(SUM(facul_prem),to_number(0)) facul_prem,
                                                 nvl(SUM(facul_comm),to_number(0)) facul_comm
                                      FROM (SELECT DISTINCT line_cd,
                                                                 DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                                 total_prem_amt, 
                                                                 nr_prem_amt,
                                                                 nvl(facul_prem, to_number(0)) facul_prem, 
                                                                 nvl(facul_comm,to_number(0)) facul_comm
                                                                 
                                                     FROM giac_comm_income_ext_summ_v
                                                  WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                                        AND line_cd = NVL(p_line_cd, line_cd)
                                                        AND user_id = p_user_id
                                                        AND iss_cd = NVL(p_iss,iss_cd))
                                                        
                                     GROUP BY line_cd, iss_cd
                                     
                    )
         LOOP
            v_rec.total_detail_f_prem := rec.facul_prem;
            v_rec.total_detail_f_comm := rec.facul_comm;
         END LOOP;           
         
         
         FOR rec IN (
                                    SELECT line_cd,trty_acct_type,
                                                
                                                nvl(SUM(treaty_prem),to_number(0)) treaty_prem , 
                                                nvl(SUM(treaty_comm), to_number(0)) treaty_comm                                             
                                     FROM  giac_comm_income_ext_summ_v 
                                     WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND line_cd = p_line_cd
                                        AND user_id = p_user_id
                                        AND trty_acct_type = counter.trty_acct_type
                                   GROUP BY line_cd,trty_acct_type
                                   
         )
         LOOP
            v_rec.per_line_t_prem := rec.treaty_prem;
            v_rec.per_line_t_comm := rec.treaty_comm;
         END LOOP;
         
         FOR rec IN (
            SELECT line_cd, 
                                                 nvl(SUM(facul_prem),to_number(0)) facul_prem,
                                                 nvl(SUM(facul_comm),to_number(0)) facul_comm
                                      FROM (SELECT DISTINCT line_cd,
                                                                 DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                                 total_prem_amt, 
                                                                 nr_prem_amt,
                                                                 nvl(facul_prem, to_number(0)) facul_prem, 
                                                                 nvl(facul_comm,to_number(0)) facul_comm
                                                                 
                                                     FROM giac_comm_income_ext_summ_v
                                                  WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                                        AND line_cd = NVL(p_line_cd, line_cd)
                                                        AND user_id = p_user_id)
                                     GROUP BY line_cd
         )
         LOOP
            v_rec.per_line_f_prem := rec.facul_prem;
            v_rec.per_line_f_comm := rec.facul_comm;
         END LOOP;
         
         FOR rec IN (
         SELECT line_cd,
                                                
                                                nvl(SUM(treaty_prem),to_number(0)) treaty_prem , 
                                                nvl(SUM(treaty_comm), to_number(0)) treaty_comm                                             
                                     FROM  giac_comm_income_ext_summ_v 
                                     WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND line_cd = p_line_cd
                                        AND user_id = p_user_id
                                   GROUP BY line_cd
         )
         LOOP
            v_rec.total_per_line_t_prem := rec.treaty_prem;
            v_Rec.total_per_line_t_comm := rec.treaty_comm;
         ENd LOOP;
         
         FOR rec IN (
         SELECT trty_acct_type,
                                                
                                                nvl(SUM(treaty_prem),to_number(0)) treaty_prem , 
                                                nvl(SUM(treaty_comm), to_number(0)) treaty_comm                                             
                                     FROM  giac_comm_income_ext_summ_v 
                                     WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND user_id = p_user_id
                                       AND line_cd = nvl(p_line_cd,line_cd)
                                        AND trty_acct_type = counter.trty_acct_type
                                        
                                   GROUP BY trty_acct_type
                                   )
         LOOP
            v_rec.grand_total_t_prem := rec.treaty_prem;
            v_rec.grand_total_t_comm := rec.treaty_comm;
         END LOOP;
         
         FOR rec IN (
         SELECT 
                                                 nvl(SUM(facul_prem),to_number(0)) facul_prem,
                                                 nvl(SUM(facul_comm),to_number(0)) facul_comm
                                      FROM (SELECT DISTINCT line_cd,
                                                                 DECODE(p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                                                                 total_prem_amt, 
                                                                 nr_prem_amt,
                                                                 nvl(facul_prem, to_number(0)) facul_prem, 
                                                                 nvl(facul_comm,to_number(0)) facul_comm
                                                                 
                                                     FROM giac_comm_income_ext_summ_v
                                                  WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                                        AND user_id = p_user_id

                                                        AND line_cd = nvl(p_line_cd,line_cd)))
                                                    
          LOOP
            v_rec.grand_total_f_prem := rec.facul_prem;
            v_rec.grand_total_f_comm := rec.facul_comm;
          END LOOP;
          
          FOR rec IN (
          SELECT                                              
                                                nvl(SUM(treaty_prem),to_number(0)) treaty_prem , 
                                                nvl(SUM(treaty_comm), to_number(0)) treaty_comm                                             
                                     FROM  giac_comm_income_ext_summ_v 
                                     WHERE acct_ent_date BETWEEN TO_DATE(p_from, 'MM-DD-YYYY') 
                                        AND TO_DATE(p_to, 'MM-DD-YYYY')
                                        AND user_id = p_user_id
                                        AND line_cd = nvl(p_line_cd,line_cd)
                                        )
          LOOP
            v_rec.grandtotal_t_prem := rec.treaty_prem;
            v_rec.grandtotal_t_comm := rec.treaty_comm;
          END LOOP;
        PIPE ROW(v_rec);
       END LOOP;
      END LOOP;
    END get_giacr277a_record;
    
END;
/



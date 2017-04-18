CREATE OR REPLACE PACKAGE BODY CPI.GIEX_BUSINESS_CON_PKG AS
   
   /**GIEXR110**/
   FUNCTION populate_giexr110_main(
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE
   )
      RETURN giexr110_main_tab PIPELINED AS
         v_details         giexr110_main_type;
   BEGIN
      FOR i IN(SELECT SUM(DECODE(a.user_id,USER,a.prem_amt,0)) pol_premium,
                      SUM(DECODE(a.user_id,USER,a.nop,0)) no_of_policy,
                      a.line_cd line_cd,
                      a.subline_cd subline_cd,
                      a.iss_cd iss_cd,
                      a.YEAR YEAR,
                      SUM(DECODE(a.user_id,USER,NVL(a.prem_renew_amt,0),0)) renew_prem,
                      SUM(DECODE(a.user_id,USER,NVL(a.prem_new_amt,0),0)) new_prem,
                      c.line_name line_name,
                      SUM(nop) sum_nop,
                      SUM(nnp) sum_nnp,
                      SUM(nrp) sum_nrp,
                      d.subline_name subline_name,
                      e.iss_name iss_name,
                      (SUM(DECODE(a.user_id,USER,NVL(a.prem_renew_amt,0),0))/DECODE(SUM(DECODE(a.user_id,USER,a.prem_amt,0)),0,NULL,SUM(DECODE(a.user_id,USER,a.prem_amt,0)))) pct_differ
                 FROM giex_ren_ratio a,
                      giis_line c,
                      giis_subline d,
                      giis_issource e
                WHERE 1 = 1
                  AND a.line_cd    = c.line_cd
                  AND a.line_cd    = d.line_cd
                  AND a.subline_cd = d.subline_cd
                  AND a.iss_cd     = e.iss_cd
                  AND a.iss_cd     = NVL(p_iss_cd,a.iss_cd)
                  AND a.line_cd    = NVL(p_line_cd,a.line_cd)
                  AND a.user_id     = USER
                GROUP BY a.line_cd,a.subline_cd,a.iss_cd,a.YEAR,c.line_name,
                         d.subline_name,e.iss_name)
      LOOP
         v_details.pol_premium  := i.pol_premium;
         v_details.no_of_policy := i.no_of_policy;
         v_details.line_cd      := i.line_cd;
         v_details.subline_cd   := i.subline_cd;
         v_details.iss_cd       := i.iss_cd;
         v_details.year         := i.year;
         v_details.renew_prem   := i.renew_prem;
         v_details.new_prem     := i.new_prem;
         v_details.iss_name     := i.iss_name;
         v_details.line_name    := i.line_name;
         v_details.subline_name := i.subline_name;
         v_details.sum_nop      := i.sum_nop;
         v_details.sum_nnp      := i.sum_nnp;
         v_details.sum_nrp      := i.sum_nrp;
         v_details.pct_differ   := NVL(i.pct_differ,0);
         
         FOR j IN(SELECT SUM(DECODE(user_id,USER,NVL(prem_renew_amt,0),0)) lcd_renew_prem,
                         SUM(DECODE(user_id,USER,prem_amt,0)) lcd_pol_premium
                    FROM giex_ren_ratio
                   WHERE line_cd = i.line_cd
                     AND year = i.year
                   GROUP BY line_cd)
         LOOP
            v_details.lcd_pol_premium := j.lcd_pol_premium;
            IF v_details.lcd_pol_premium = 0 THEN
               v_details.lcd_pct_diff := 0;
            ELSE
               v_details.lcd_pct_diff    := j.lcd_renew_prem/v_details.lcd_pol_premium;
            END IF;   
         END LOOP;
         
         FOR k IN(SELECT (NVL(SUM(prem_renew_amt),0)/DECODE(SUM(prem_amt),0,NULL,SUM(prem_amt))) premium_pct_differ
                    FROM giex_ren_ratio
                   WHERE user_id=USER
                     AND iss_cd = NVL(p_iss_cd, iss_cd)
                     AND line_cd = NVL(p_line_cd, line_cd)
                     --AND iss_cd = NVL(i.iss_cd,iss_cd)
                     --AND line_cd = NVL(i.line_cd,line_cd)
                     AND year = i.year  
                   GROUP BY iss_cd, year)
         LOOP
            v_details.icd_pct_differ := NVL(k.premium_pct_differ,0);
         END LOOP;
         
         FOR lmax IN(SELECT (NVL(SUM(DECODE(user_id,user, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,user, prem_amt,0)),0,NULL,SUM(DECODE(user_id,user, prem_amt,0)))) max_scd_pd
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                     AND year IN(SELECT MAX(year)
                                   FROM GIEX_REN_RATIO)
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
                   
         LOOP
            v_details.max_scd_pd := lmax.max_scd_pd;
         END LOOP;
                   
         FOR lmin IN(SELECT (NVL(SUM(DECODE(user_id,user, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,user, prem_amt,0)),0,NULL,SUM(DECODE(user_id,user, prem_amt,0)))) min_scd_pd
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                     AND year IN(SELECT MIN(year)
                                   FROM GIEX_REN_RATIO)
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
                   
         LOOP
            v_details.min_scd_pd := lmin.min_scd_pd;
         END LOOP;
         
         FOR l IN(SELECT (NVL(SUM(DECODE(user_id,user, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,user, prem_amt,0)),0,NULL,SUM(DECODE(user_id,user, prem_amt,0)))) scd_pct_differ
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
         
         LOOP
            IF NVL(v_details.max_scd_pd,0) > NVL(v_details.min_scd_pd,0) THEN
               v_details.scd_pct_differ := NVL(l.scd_pct_differ,0) - 0;
            ELSE
               v_details.scd_pct_differ := 0 - NVL(l.scd_pct_differ,0);
            END IF;   
         END LOOP; 
         
         --LINE_CD PCT DIFF :: LINE - PERCENTAGE INC/DEC
         FOR m IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_lcd_pd
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = i.line_cd
                     AND iss_cd  = i.iss_cd
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             		               WHERE user_id = USER)   
                   GROUP BY iss_cd,line_cd)
         LOOP
            v_details.min_lcd_pd := m.min_lcd_pd;
         END LOOP;
         
         FOR n IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_lcd_pd
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = i.line_cd
                     AND iss_cd  = i.iss_cd
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             		               WHERE user_id = USER)   
                   GROUP BY iss_cd,line_cd)
         LOOP
            v_details.max_lcd_pd := n.max_lcd_pd;
         END LOOP;
         
         v_details.line_pct_diff := v_details.max_lcd_pd - v_details.min_lcd_pd; 
         
         --ISS_CD PCT DIFF :: ISSUE SOURCE - PERCENTAGE INC/DEC
         FOR o IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_icd_pd
		            FROM giex_ren_ratio
		           WHERE user_id = USER		       
		             AND iss_cd = NVL(p_iss_cd,iss_cd)
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
           		                   WHERE user_id = USER)   		     
		           GROUP BY iss_cd)
         LOOP
            v_details.min_icd_pd := o.min_icd_pd;
         END LOOP;
         
         FOR p IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_icd_pd
		            FROM giex_ren_ratio
		           WHERE user_id = USER		       
		             AND iss_cd = NVL(p_iss_cd,iss_cd)
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
           		                   WHERE user_id = USER)   		     
	               GROUP BY iss_cd)
         LOOP
            v_details.max_icd_pd := p.max_icd_pd;
         END LOOP;
         
         v_details.iss_pct_diff := v_details.max_icd_pd - v_details.min_icd_pd;
         
         PIPE ROW(v_details);
      END LOOP;
   END;
   
   FUNCTION populate_giexr110_header
   
   RETURN giexr110_header_tab PIPELINED AS
      v_co_details         giexr110_header_type;
   
   BEGIN
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_NAME')
         LOOP
            v_co_details.company_name := i.param_value_v;
         END LOOP;
      END;
      
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
         LOOP
            v_co_details.company_address := i.param_value_v;
         END LOOP;
      END;
        
      PIPE ROW(v_co_details);
   END; 
   
   FUNCTION populate_giexr110_recap (
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE
   )
     RETURN giexr110_recap_tab PIPELINED AS
      v_recap           giexr110_recap_type;
      
   BEGIN
      FOR i IN(SELECT SUM(a.nop) sum_nop,
                      SUM(a.prem_amt) pol_premium,
                      SUM(a.nnp) sum_nnp,
                      SUM(a.nrp) sum_nrp,
                      SUM(a.prem_renew_amt) renew_prem,                               
	                  (NVL(SUM(a.prem_renew_amt),0)/DECODE(SUM(a.prem_amt),0,NULL,SUM(a.prem_amt))) pct_differ,
                      b.iss_name, a.year, a.iss_cd
                 FROM giex_ren_ratio a, giis_issource b
                WHERE 1 = 1 
                  AND a.user_id = USER
                  AND a.iss_cd = b.iss_cd 
                  AND a.line_cd = NVL(p_line_cd,a.line_cd)
                  AND a.iss_cd  = NVL(p_iss_cd,a.iss_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             				    WHERE user_id = USER)
                GROUP BY a.iss_cd, b.iss_name, a.year
                ORDER BY b.iss_name)
      LOOP
         v_recap.year        := i.year;
         v_recap.sum_nop     := i.sum_nop;
         v_recap.pol_premium := i.pol_premium;
         v_recap.sum_nnp     := i.sum_nnp;
         v_recap.sum_nrp     := i.sum_nrp;
         v_recap.renew_prem  := i.renew_prem;
         v_recap.pct_differ  := i.pct_differ;
         v_recap.iss_name    := i.iss_name;
         v_recap.iss_cd      := i.iss_cd;
         
         FOR j IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER)  
                   GROUP BY iss_cd)
                             	     
         LOOP
            v_recap.min_year_pct := j.min_year_pct;
         END LOOP;    
         
         FOR k IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER)  
                   GROUP BY iss_cd)		     		        
         LOOP
            v_recap.max_year_pct := k.max_year_pct;
         END LOOP;
         
         v_recap.iss_pct_diff := v_recap.max_year_pct - v_recap.min_year_pct; 
         
         FOR l IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) min_grand_pd
		            FROM giex_ren_ratio
		           WHERE user_id = USER		          
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER))      
         LOOP
            v_recap.min_grand_pd := l.min_grand_pd;
         END LOOP;
         
          FOR m IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) max_grand_pd
		            FROM giex_ren_ratio
		           WHERE user_id = USER		          
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER))	        
         LOOP
            v_recap.max_grand_pd := m.max_grand_pd;
         END LOOP;
         
         v_recap.grand_pct_diff := v_recap.max_grand_pd - v_recap.min_grand_pd;
         
         PIPE ROW(v_recap);
      END LOOP;
   END;
   
   FUNCTION populate_giexr110_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE
    )
      RETURN giexr110_grand_total_tab PIPELINED AS
         v_grand_total     giexr110_grand_total_type;
      
   BEGIN
      FOR i IN(SELECT SUM(prem_amt) grand_pol_premium,
                      YEAR,
                      SUM(prem_renew_amt) grand_renew_prem,
                      (NVL(SUM(prem_renew_amt),0)/DECODE(SUM(prem_amt),0,NULL,SUM(prem_amt))) grand_pct_differ,
                      SUM(nop) sum_nop,
                      SUM(nrp) sum_nrp,
	                  SUM(nnp) sum_nnp
                 FROM giex_ren_ratio
                WHERE user_id=USER
                  AND iss_cd = NVL(p_iss_cd,iss_cd)
                  AND line_cd = NVL(p_line_cd,line_cd)
                GROUP BY YEAR)
      LOOP
         v_grand_total.grand_pol_premium  := i.grand_pol_premium;
         v_grand_total.grand_renew_prem   := i.grand_renew_prem;
         v_grand_total.grand_pct_differ   := i.grand_pct_differ;
         v_grand_total.sum_nop            := i.sum_nop;
         v_grand_total.sum_nrp            := i.sum_nrp;
         v_grand_total.sum_nnp            := i.sum_nnp;
         v_grand_total.year               := i.year;
         
         FOR j IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_grand_pd
                 FROM giex_ren_ratio
                WHERE user_id = USER
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd  = NVL(p_iss_cd,iss_cd)
                  AND year IN (SELECT MIN(year) 
                                 FROM giex_ren_ratio
             			        WHERE user_id = USER))
         LOOP
            v_grand_total.min_grand_pd := j.min_grand_pd;
         END LOOP;
      
         FOR k IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_grand_pd
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd  = NVL(p_iss_cd,iss_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             			        WHERE user_id = USER))
         LOOP
            v_grand_total.max_grand_pd := k.max_grand_pd;
         END LOOP;
         
         v_grand_total.grand_pct_diff := v_grand_total.max_grand_pd - v_grand_total.min_grand_pd;
      
         PIPE ROW(v_grand_total);
      END LOOP;  
      
      
         /*IF v_grand_total.sum_nrp = 0 THEN
		    v_grand_total.grand_pct_renew := v_grand_total.sum_nrp/NULL;
	     ELSE
		    v_grand_total.grand_pct_renew := v_grand_total.sum_nrp/v_grand_total.sum_nop;
	     END IF;
         
         FOR j IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MIN(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = USER))
         LOOP
            v_grand_total.min_year_pct  := j.min_year_pct;   
         END LOOP;
         
         FOR k IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MAX(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = USER))
         LOOP
            v_grand_total.max_year_pct  := k.max_year_pct;
         END LOOP;
         
         v_grand_total.grand_pct_diff   := v_grand_total.max_year_pct - v_grand_total.min_year_pct;*/
         
         
         
                    
                
   END;
   /**GIEXR110**/
   /**GIEXR109**/
   FUNCTION populate_giexr109_main(
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_subline_cd      giex_ren_ratio.subline_cd%TYPE
   )
     RETURN giexr109_main_tab PIPELINED AS
      v_details         giexr109_main_type;
   BEGIN
   
      FOR i IN (SELECT a.line_name, a.line_cd, c.iss_cd, b.subline_cd,
                       b.subline_name, d.year, SUM(d.nop) no_of_policy, 
                       SUM(d.nrp) no_of_renewed,
                       NVL(SUM(d.nnp),0)    no_of_new, c.iss_name,
                       NVL(SUM(d.nrp)/DECODE(SUM(d.nop),0,NULL,SUM(d.nop)),0) pct_renew
                  FROM giis_line a,
                       giis_subline b,
                       giis_issource c,
                       giex_ren_ratio d
                 WHERE d.line_cd    = a.line_cd
                   AND d.line_cd    = b.line_cd
                   AND d.subline_cd = b.subline_cd
                   AND d.iss_cd     = c.iss_cd
                   AND d.iss_cd     = NVL(p_iss_cd,d.iss_cd)
                   AND d.line_cd    = NVL(p_line_cd,d.line_cd)
                   AND d.subline_cd = NVL(p_subline_cd,d.subline_cd)
                   AND d.user_id    = USER
                 GROUP BY a.line_name, a.line_cd, d.year, b.subline_name,
                          c.iss_name, c.iss_cd, b.subline_cd)
      LOOP
            v_details.line_name     := i.line_name;
            v_details.line_cd       := i.line_cd;
            v_details.iss_cd        := i.iss_cd;
            v_details.subline_cd    := i.subline_cd;
            v_details.subline_name  := i.subline_name;
            v_details.year          := i.year;
            v_details.no_of_policy  := i.no_of_policy;
            v_details.no_of_renewed := i.no_of_renewed;
            v_details.no_of_new     := i.no_of_new;
            v_details.iss_name      := i.iss_name;
            v_details.pct_renew     := i.pct_renew;
            
            FOR j IN (SELECT 
            NVL(SUM(nop),0) sum_nop,
	                         NVL(SUM(nrp),0) sum_nrp,
	                         NVL(SUM(nnp),0) sum_nnp,
                             YEAR,iss_cd
                        FROM giex_ren_ratio
                       WHERE 1=1
                         AND user_id=USER
                         AND line_cd = i.line_cd
                         AND iss_cd = i.iss_cd
                         AND subline_cd = i. subline_cd
                         AND year = i.year
                       GROUP BY YEAR,iss_cd, line_cd, subline_cd)
  
            LOOP
                v_details.sum_nop   := j.sum_nop;
                v_details.sum_nrp   := j.sum_nrp;
                v_details.sum_nnp   := j.sum_nnp;
            END LOOP; 
            
            FOR k IN (SELECT NVL(SUM(nop),0) g_sum_nop,
	                         NVL(SUM(nrp),0) g_sum_nrp,
	                         NVL(SUM(nnp),0) g_sum_nnp,
          	                 YEAR
                        FROM giex_ren_ratio
                       WHERE 1=1 
                         AND line_cd = NVL(p_line_cd,line_cd)
                         AND iss_cd = NVL(p_iss_cd,iss_cd)
                         AND subline_cd = NVL(p_subline_cd,subline_cd)
                         AND user_id=USER
                       GROUP BY YEAR)                       
  
            LOOP
                v_details.g_sum_nop   := k.g_sum_nop;
                v_details.g_sum_nrp   := k.g_sum_nrp;
                v_details.g_sum_nnp   := k.g_sum_nnp;
            END LOOP;
            
            FOR l IN(SELECT NVL(SUM(DECODE(user_id,user, NRP,0))/DECODE(SUM(DECODE(user_id,user, NOP,0)),0,NULL,SUM(DECODE(user_id,user, NOP,0))),0) pct_diff --modified by A.R.C. 12.20.2004
                       FROM giex_ren_ratio
                      WHERE 1 = 1
                        AND iss_cd = i.iss_cd
                        AND subline_cd = i.subline_cd
                        AND line_cd = i.line_cd
                        AND month <> 0
                      GROUP BY YEAR,subline_cd
                      ORDER BY year ASC)
     
            LOOP
                v_details.pct_diff    := l.pct_diff - 0;
            END LOOP;
            
            v_details.pct_renew_diff    := v_details.pct_diff - v_details.pct_renew;
            
            FOR m IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_lcd_pd --line cd pct diff - min year
                       FROM giex_ren_ratio
                      WHERE user_id = USER
                        AND line_cd = i.line_cd
                        AND iss_cd  = i.iss_cd
                        AND year IN (SELECT MIN(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = USER)
                                      GROUP BY iss_cd,line_cd)   
            LOOP
               v_details.min_lcd_pd := m.min_lcd_pd;
            END LOOP;
            
            FOR n IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_lcd_pd --line cd pct diff - max year
                       FROM giex_ren_ratio
                      WHERE user_id = USER
                        AND line_cd = i.line_cd
                        AND iss_cd  = i.iss_cd
                        AND year IN (SELECT MAX(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = USER)
                      GROUP BY iss_cd,line_cd)
                      
            LOOP
               v_details.max_lcd_pd := n.max_lcd_pd;
            END LOOP;
            
            v_details.lcd_pct_diff := v_details.max_lcd_pd - v_details.min_lcd_pd;
            
            FOR o IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_isd_pd --iss cd pct diff - min year
		               FROM giex_ren_ratio
		              WHERE user_id = USER
		                AND iss_cd  = i.iss_cd	
                        AND year IN (SELECT MIN(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = USER)	     
		              GROUP BY iss_cd)
            
            LOOP
               v_details.min_isd_pd := o.min_isd_pd;
            END LOOP;
            
            FOR p IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_isd_pd --iss cd pct diff - max year
		               FROM giex_ren_ratio
		              WHERE user_id = USER
		                AND iss_cd  = i.iss_cd	
                        AND year IN (SELECT MAX(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = USER)	     
		              GROUP BY iss_cd)
            
            LOOP
               v_details.max_isd_pd := p.max_isd_pd;
            END LOOP;
            
            v_details.icd_pct_diff  := v_details.max_isd_pd - v_details.min_isd_pd;
            
            FOR q IN(SELECT NVL(SUM(nop),0) sum_nop,
	                        NVL(SUM(nrp),0) sum_nrp,
                            YEAR, iss_cd, line_cd
                       FROM giex_ren_ratio
                      WHERE 1=1  
                        AND user_id=USER
                        AND line_cd = NVL(i.line_cd,line_cd)
                        AND iss_cd = NVL(i.iss_cd,iss_cd)
                        AND year = i.year
                      GROUP BY YEAR,iss_cd, line_cd)
                      
            LOOP
               v_details.sum_nop        := q.sum_nop;
               v_details.sum_nrp        := q.sum_nrp;
               IF v_details.sum_nop = 0 THEN
                  v_details.scd_pct_diff   := 0;
               ELSE
                  v_details.scd_pct_diff   := v_details.sum_nrp/v_details.sum_nop;
               END IF;
            END LOOP;
            
            FOR r IN(SELECT NVL(SUM(nop),0) sum_nop,
	                        NVL(SUM(nrp),0) sum_nrp,
                            YEAR, iss_cd
                       FROM giex_ren_ratio
                      WHERE 1=1  
                        AND user_id=USER
                        AND iss_cd = NVL(i.iss_cd,iss_cd)
                        AND year = i.year
                      GROUP BY YEAR,iss_cd)
                      
            LOOP
               v_details.sum_nop        := r.sum_nop;
               v_details.sum_nrp        := r.sum_nrp;
               IF v_details.sum_nop = 0 THEN
                  v_details.isd_pct_diff   := 0;
               ELSE
                  v_details.isd_pct_diff   := v_details.sum_nrp/v_details.sum_nop;
               END IF;
            END LOOP;
            
            PIPE ROW(v_details);
            
      END LOOP;
            
   END;
   
   FUNCTION populate_giexr109_header
   
   RETURN giexr109_header_tab PIPELINED AS
      v_co_details         giexr109_header_type;
   
   BEGIN
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_NAME')
         LOOP
            v_co_details.company_name := i.param_value_v;
         END LOOP;
      END;
      
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
         LOOP
            v_co_details.company_address := i.param_value_v;
         END LOOP;
      END;
        
      PIPE ROW(v_co_details);
   END; 
   
   FUNCTION populate_giexr109_recap (
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_subline_cd      giex_ren_ratio.subline_cd%TYPE
   )
     RETURN giexr109_recap_tab PIPELINED AS
      v_recap           giexr109_recap_type;
      
   BEGIN
      FOR i IN(SELECT SUM(a.nop) sum_nop, 
                      SUM(a.nnp) sum_nnp,
                      SUM(a.nrp) sum_nrp,
                      a.year, a.iss_cd, b.iss_name
                 FROM giex_ren_ratio a, giis_issource b
                WHERE 1 = 1 
                  AND a.user_id = USER
                  AND a.iss_cd = b.iss_cd 
                  AND a.line_cd = NVL(p_line_cd,a.line_cd)
                  AND a.iss_cd  = NVL(p_iss_cd,a.iss_cd)
                  AND a.subline_cd = NVL(p_subline_cd,a.subline_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             				    WHERE user_id = USER)
                GROUP BY a.iss_cd, b.iss_name, a.year
                ORDER BY b.iss_name)
      LOOP
         v_recap.year       := i.year;
         v_recap.iss_cd     := i.iss_cd;
         v_recap.iss_name   := i.iss_name;
         v_recap.sum_nop    := i.sum_nop;
         v_recap.sum_nnp    := i.sum_nnp;
         v_recap.sum_nrp    := i.sum_nrp;   
         
         FOR j IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER))        	     
         LOOP
            v_recap.min_year_pct := j.min_year_pct;
         END LOOP;    
         
         FOR k IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			    	   WHERE user_id = USER))		     		        
         LOOP
         v_recap.max_year_pct := k.max_year_pct;
         END LOOP;
         
         /****FOR GRAND TOTAL****/
         
         FOR l IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) g_min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = USER))        	     
         LOOP
            v_recap.g_min_year_pct := l.g_min_year_pct;
         END LOOP;    
         
         FOR m IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) g_max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = USER
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             				       WHERE user_id = USER))		     		        
         LOOP
         v_recap.g_max_year_pct := m.g_max_year_pct;
         END LOOP;
         
         v_recap.g_sum_pct_renew := (v_recap.g_max_year_pct - v_recap.g_min_year_pct);   
         
         v_recap.sum_pct_renew := (v_recap.max_year_pct - v_recap.min_year_pct);
         
         PIPE ROW(v_recap);
      END LOOP;
   END;
   
   FUNCTION populate_giexr109_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE
    )
      RETURN giexr109_grand_total_tab PIPELINED AS
         v_grand_total     giexr109_grand_total_type;
      
   BEGIN
      FOR i IN(SELECT NVL(SUM(nop),0) sum_nop,
                      NVL(SUM(nrp),0) sum_nrp,
                      NVL(SUM(nnp),0) sum_nnp,
                      YEAR
                 FROM giex_ren_ratio
                WHERE 1=1 
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd = NVL(p_iss_cd,iss_cd)
                  AND subline_cd = NVL(p_subline_cd,subline_cd)
                  AND user_id=USER
                GROUP BY YEAR)
      LOOP
         v_grand_total.sum_nop  := i.sum_nop;
         v_grand_total.sum_nrp  := i.sum_nrp;
         v_grand_total.sum_nnp  := i.sum_nnp;
         v_grand_total.year     := i.year;
         
         IF v_grand_total.sum_nrp = 0 THEN
		    v_grand_total.grand_pct_renew := v_grand_total.sum_nrp/NULL;
	     ELSE
		    v_grand_total.grand_pct_renew := v_grand_total.sum_nrp/v_grand_total.sum_nop;
	     END IF;
         
         FOR j IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MIN(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = USER))
         LOOP
            v_grand_total.min_year_pct  := j.min_year_pct;   
         END LOOP;
         
         FOR k IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = USER
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MAX(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = USER))
         LOOP
            v_grand_total.max_year_pct  := k.max_year_pct;
         END LOOP;
         
         v_grand_total.grand_pct_diff   := v_grand_total.max_year_pct - v_grand_total.min_year_pct;
         
         PIPE ROW(v_grand_total);
         
      END LOOP;                
                
   END;
   /**GIEXR109**/
END GIEX_BUSINESS_CON_PKG;
/



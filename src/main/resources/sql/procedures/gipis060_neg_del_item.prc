DROP PROCEDURE CPI.GIPIS060_NEG_DEL_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_NEG_DEL_ITEM (
	   p_par_id	  			IN  GIPI_WPOLBAS.par_id%TYPE,
	   p_item_no			IN  GIPI_WITEM.item_no%TYPE,
	   p_prem_amt			OUT GIPI_WITEM.prem_amt%TYPE,
	   p_tsi_amt			OUT GIPI_WITEM.tsi_amt%TYPE,
	   p_ann_prem_amt		OUT GIPI_WITEM.ann_prem_amt%TYPE,
	   p_ann_tsi_amt		OUT GIPI_WITEM.ann_tsi_amt%TYPE
	   )
 IS
   v_ann_tsi_amt  gipi_witmperl.ann_tsi_amt%TYPE;
   v_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE;
   v_tsi_amt  	  gipi_witmperl.tsi_amt%TYPE;
   v_prem_amt 	  gipi_witmperl.prem_amt%TYPE;
   v_prorate	  NUMBER;
   v_short_rt  	  NUMBER;
   v_comp_var  	  NUMBER;
BEGIN
  p_prem_amt := 0;
  p_tsi_amt := 0;
  p_ann_prem_amt := 0;
  p_ann_tsi_amt := 0;
  
  FOR b540 IN (
  	  SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date, prorate_flag,
	  		 comp_sw, endt_expiry_date, incept_date, expiry_date, short_rt_percent
	    FROM GIPI_WPOLBAS
	   WHERE par_id = p_par_id
   ) LOOP
	IF  b540.prorate_flag <> '2' THEN
  		/* pro-rated or short rate*/
      IF NVL(b540.comp_sw,'N') ='N' THEN
         v_comp_var  := 0;
      ELSIF NVL(b540.comp_sw,'N') ='Y' THEN
         v_comp_var  := 1;
      ELSE
         v_comp_var  := -1;
      END IF; 
      v_prorate  := TRUNC(b540.endt_expiry_date - b540.eff_date + v_comp_var) / check_duration(b540.incept_date,b540.expiry_date);     
      v_short_rt := NVL(b540.short_rt_percent,1)/100;
      
  	  FOR A1 IN (
		    SELECT b.line_cd, b.peril_cd, sum(b.tsi_amt) tsi_amt, sum(b.prem_amt) prem_amt
		      FROM gipi_itmperil b
		     WHERE EXISTS ( SELECT '1'
		                      FROM gipi_polbasic a
		                     WHERE a.line_cd     =  b540.line_cd
		                       AND a.iss_cd      =  b540.iss_cd
		                       AND a.subline_cd  =  b540.subline_cd
		                       AND a.issue_yy    =  b540.issue_yy
		                       AND a.pol_seq_no  =  b540.pol_seq_no
		                       AND a.renew_no    =  b540.renew_no
		                       AND a.pol_flag    IN ('1','2','3')
		                       AND TRUNC(a.eff_date) <= TRUNC(b540.eff_date)
		                       --AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  b540.eff_date
		                       AND a.policy_id = b.policy_id)
		       AND b.item_no = p_item_no
		     GROUP BY b.line_cd, b.peril_cd)
		  LOOP
		  	IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
				   BEGIN				   	 
     				 IF b540.prorate_flag = '1' THEN
     				 		v_prem_amt := a1.prem_amt* v_prorate;   
     				 		v_tsi_amt  := a1.tsi_amt * v_prorate;  				 		
     				 ELSE
     				 	  v_prem_amt := a1.prem_amt * v_short_rt;
     				 	  v_tsi_amt  := a1.tsi_amt  * v_short_rt;
     				 END IF;     				      				
     				 --msg_alert(a1.peril_cd||' '||a1.prem_amt||' '||v_prorate,'I',FALSE);
     				 IF TRUNC(b540.endt_expiry_date) <> TRUNC(b540.expiry_date) THEN
		     				v_ann_prem_amt := a1.prem_amt - v_prem_amt;
		     				v_ann_tsi_amt  := a1.tsi_amt  - v_tsi_amt;
     				 ELSE
     				 	  v_ann_prem_amt := 0;
		     				v_ann_tsi_amt  := 0;
		     				v_tsi_amt      := a1.tsi_amt;
		     				 --END IF;		     				 		     				 
     				 END IF;     				 
     				 --msg_alert(a1.peril_cd||' '||v_prem_amt||' '||v_tsi_amt||' '||v_ann_tsi_amt||' '||v_ann_prem_amt,'I',FALSE);pause;
		  		 END;	 		  		 	 
          
  				 INSERT INTO gipi_witmperl
			  	               (par_id ,      item_no,       line_cd ,      peril_cd,    discount_sw,
			                    prem_rt,      tsi_amt,       prem_amt,      ann_tsi_amt, ann_prem_amt,
			                    prt_flag,     rec_flag)                         
			          VALUES   (p_par_id, p_item_no, a1.line_cd,    a1.peril_cd, 'N',
			                    0,    			 -(v_tsi_amt), -(v_prem_amt),  	v_ann_tsi_amt, v_ann_prem_amt, 
			                    '1',          'D');				   				   
		    END IF;                    
		  END LOOP;
  ELSE
  	
  /* annual computation */
		  FOR A1 IN (
		    SELECT b.line_cd, b.peril_cd, sum(b.tsi_amt) tsi_amt, sum(b.prem_amt) prem_amt
		      FROM gipi_itmperil b
		     WHERE EXISTS ( SELECT '1'
		                      FROM gipi_polbasic a
		                     WHERE a.line_cd     =  b540.line_cd
		                       AND a.iss_cd      =  b540.iss_cd
		                       AND a.subline_cd  =  b540.subline_cd
		                       AND a.issue_yy    =  b540.issue_yy
		                       AND a.pol_seq_no  =  b540.pol_seq_no
		                       AND a.renew_no    =  b540.renew_no
		                       AND a.pol_flag    IN( '1','2','3')
		                       AND TRUNC(a.eff_date) <= TRUNC(b540.eff_date)
		                       --AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  b540.eff_date
		                       AND a.policy_id = b.policy_id)
		       AND b.item_no = p_item_no
		     GROUP BY b.line_cd, b.peril_cd)
		  LOOP
		  	IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
		  	   INSERT INTO gipi_witmperl
		  	               (par_id ,      item_no,       line_cd ,      peril_cd,    discount_sw,
		                    prem_rt,      tsi_amt,       prem_amt,      ann_tsi_amt, ann_prem_amt,
		                    prt_flag,     rec_flag)                         
		             VALUES(p_par_id, p_item_no, a1.line_cd,     a1.peril_cd, 'N',
		                    0,            -(a1.tsi_amt), -(a1.prem_amt), 0,            0, 
		                    '1',          'D');
		    END IF;                    
		  END LOOP;
  END IF;
    
  IF  b540.prorate_flag <> '2' AND TRUNC(b540.endt_expiry_date) <> TRUNC(b540.expiry_date) THEN
		  FOR A1 IN (
				    SELECT b.line_cd, SUM(DECODE(a.peril_type, 'B',b.tsi_amt,0)) tsi_amt, sum(b.prem_amt) prem_amt
				      FROM gipi_itmperil b, giis_peril a
				     WHERE EXISTS ( SELECT '1'
				                      FROM gipi_polbasic a
				                     WHERE a.line_cd     =  b540.line_cd
				                       AND a.iss_cd      =  b540.iss_cd
				                       AND a.subline_cd  =  b540.subline_cd
				                       AND a.issue_yy    =  b540.issue_yy
				                       AND a.pol_seq_no  =  b540.pol_seq_no
				                       AND a.renew_no    =  b540.renew_no
				                       AND a.pol_flag    IN( '1','2','3')
				                       AND TRUNC(a.eff_date) <= TRUNC(b540.eff_date)
				                       --AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  b540.eff_date
				                       AND a.policy_id = b.policy_id)
				       AND b.item_no 	= p_item_no
				       AND a.peril_cd = b.peril_cd
			     		 AND a.line_cd 	= b.line_cd
				     GROUP BY b.line_cd)
		  LOOP		     
			  FOR A IN(SELECT SUM(DECODE(b.peril_type, 'B',a.tsi_amt,0)) tsi, SUM(a.prem_amt) prem
			             FROM gipi_witmperl a, giis_peril b
			            WHERE a.par_id  = p_par_id
			              AND a.item_no = p_item_no
			              AND a.peril_cd = b.peril_cd
			              AND a.line_cd = b.line_cd)
			  LOOP
			  	p_prem_amt := a.prem;              
			  	p_tsi_amt  := a.tsi;
			  	p_ann_prem_amt := a1.prem_amt + a.prem;
			  	p_ann_tsi_amt  := a1.tsi_amt + a.tsi;
				
				UPDATE gipi_witem
		          SET prem_amt      = a.prem,
		              tsi_amt     = a.tsi,
		              ann_prem_amt  = a1.prem_amt + a.prem,
		              ann_tsi_amt = a1.tsi_amt + a.tsi
		          WHERE par_id = p_par_id
				    AND item_no = p_item_no; 
			  END LOOP; 	
		  END LOOP;
	ELSE
		  FOR A IN ( 
		    SELECT SUM(DECODE(b.peril_type, 'B',a.tsi_amt,0)) tsi, SUM(a.prem_amt) prem
			    FROM gipi_witmperl a, giis_peril b
			   WHERE a.par_id  = p_par_id
			     AND a.item_no = p_item_no
			     AND a.peril_cd = b.peril_cd
			     AND a.line_cd = b.line_cd)
			LOOP
				p_prem_amt := a.prem;              
			 	p_tsi_amt  := a.tsi;
			 	p_ann_prem_amt := 0;
			 	p_ann_tsi_amt  := 0;
				
				UPDATE gipi_witem
		          SET prem_amt      = a.prem,
		              tsi_amt     = a.tsi,
		              ann_prem_amt  = 0,
		              ann_tsi_amt = 0
		          WHERE par_id = p_par_id
				    AND item_no = p_item_no; 
			END LOOP; 	 	
	END IF;	
  END LOOP;
  
  COMMIT;
END;
/



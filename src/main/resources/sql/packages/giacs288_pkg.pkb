CREATE OR REPLACE PACKAGE BODY CPI.GIACS288_PKG AS

   FUNCTION get_bills_per_intermediary(
      p_intm_no           giis_intermediary.intm_no%TYPE,
      p_module_id         giis_modules.module_id%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_bill_number       VARCHAR2,
      p_policy_number     VARCHAR2,
      p_endt_number       VARCHAR2,
      p_assured           VARCHAR2,
      p_ref_pol_no        gipi_polbasic.ref_pol_no%TYPE
   )
     RETURN giacs288_tab PIPELINED
   IS
      v_row               giacs288_type;
      v_premium_amt       giac_direct_prem_collns.premium_amt%TYPE;
      v_tax_amt           giac_direct_prem_collns.tax_amt%TYPE;
      v_curr_rt			  gipi_invoice.currency_rt%TYPE;
      v_prem_amt		     gipi_invoice.prem_amt%TYPE;			
      v_share_per		     gipi_comm_invoice.share_percentage%TYPE;
              
      v_prem_pd           NUMBER(16, 2);
      v_prem_os           NUMBER(16, 2);
      v_comm_pd           NUMBER(16, 2);
      v_comm_os           NUMBER(16, 2);
      v_total_prem_pd     NUMBER(16, 2) := 0;
      v_total_prem_os     NUMBER(16, 2) := 0;
      v_total_comm_pd     NUMBER(16, 2) := 0;
      v_total_comm_os     NUMBER(16, 2) := 0;
   BEGIN
      FOR i IN(SELECT DISTINCT b.iss_cd, b.prem_seq_no, b.commission_amt
                 FROM gipi_polbasic gp,
                      giac_comm_invoice b,
                      gipi_parlist c,
                      giis_assured d
                WHERE gp.policy_id = b.policy_id
                  AND gp.pol_flag != '5'
                  AND gp.reg_policy_sw = 'Y'
                  AND c.par_id = gp.par_id
                  AND c.assd_no = d.assd_no
                  AND check_user_per_iss_cd_acctg2(NULL, gp.iss_cd, p_module_id, p_user_id) = 1
                  AND intrmdry_intm_no = p_intm_no
                  AND UPPER(b.iss_cd || '-' || LTRIM(TO_CHAR(b.prem_seq_no, '099999999999')))
                      LIKE UPPER(NVL(p_bill_number, b.iss_cd || '-' || LTRIM(TO_CHAR(b.prem_seq_no, '099999999999'))))
					   AND UPPER(gp.line_cd || '-' || gp.subline_cd || '-' || gp.iss_cd || '-' || LTRIM(TO_CHAR(gp.issue_yy, '09')) || '-' ||
                            LTRIM(TO_CHAR(gp.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(gp.renew_no, '09')))
                      LIKE UPPER(NVL(p_policy_number, gp.line_cd || '-' || gp.subline_cd || '-' || gp.iss_cd || '-' || LTRIM(TO_CHAR(gp.issue_yy, '09')) || '-' ||
                            LTRIM(TO_CHAR(gp.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(gp.renew_no, '09'))))    
	 				   AND UPPER(gp.endt_iss_cd || '-' || LTRIM(gp.endt_yy) || '-' || LTRIM(gp.endt_seq_no))
                      LIKE UPPER(NVL(p_endt_number, gp.endt_iss_cd || '-' || LTRIM(gp.endt_yy) || '-' || LTRIM(gp.endt_seq_no)))
					   AND UPPER(d.assd_no || ' - ' || d.assd_name) LIKE UPPER(NVL(p_assured, d.assd_no || ' - ' || d.assd_name)))
      LOOP
         v_prem_pd := 0;
         v_prem_os := 0;
         v_comm_pd := 0;
         v_comm_os := 0;
      
         FOR s IN(SELECT SUM(premium_amt) premium_amt,
                         SUM(tax_amt) tax_amt
                    FROM giac_direct_prem_collns a,
                         giac_acctrans c
                   WHERE b140_iss_cd = i.iss_cd  
                     AND b140_prem_seq_no = i.prem_seq_no
                     AND a.gacc_tran_id = c.tran_id
                     AND c.tran_flag <> 'D'
                     AND NOT EXISTS(SELECT 1
                                      FROM giac_acctrans gactran,
                                           giac_reversals grev
                                     WHERE gactran.tran_id = grev.reversing_tran_id
                                       AND grev.gacc_tran_id = a.gacc_tran_id
                                       AND gactran.tran_flag <> 'D'))
         LOOP
            v_premium_amt := s.premium_amt;        
            v_tax_amt := s.tax_amt;
         END LOOP;
            
         v_prem_pd := v_premium_amt + v_tax_amt;
         
			IF v_prem_pd IS NULL THEN
            v_prem_pd := 0.00;
			END IF;
            
         FOR k IN(SELECT a.currency_rt, a.prem_amt, a.tax_amt, b.share_percentage, b.intrmdry_intm_no
                    FROM gipi_invoice a,
                         gipi_comm_invoice b
                   WHERE b.intrmdry_intm_no = p_intm_no
                     AND a.iss_cd = i.iss_cd
                     AND a.iss_cd = b.iss_cd
                     AND a.prem_seq_no = i.prem_seq_no
                     AND a.prem_seq_no = b.prem_seq_no)    
         LOOP
            v_curr_rt := k.currency_rt;
            v_prem_amt := k.prem_amt;
            v_tax_amt := k.tax_amt;
            v_share_per := k.share_percentage;
         END LOOP;
            
         v_prem_os := ((v_prem_amt + v_tax_amt) * v_share_per /100 * v_curr_rt) - v_prem_pd;
            
         FOR m IN(SELECT SUM(comm_amt - wtax_amt + input_vat_amt) comm_amt
                    FROM giac_comm_payts gcpyt,
                         giac_acctrans gactran
                   WHERE gcpyt.iss_cd = i.iss_cd
                     AND gcpyt.prem_seq_no = i.prem_seq_no
                     AND gcpyt.gacc_tran_id = gactran.tran_id
                     AND gactran.tran_flag <> 'D'
                     AND NOT EXISTS(SELECT 1
                                      FROM giac_acctrans gactran,
                                           giac_reversals grev
                                     WHERE gactran.tran_id = grev.reversing_tran_id
                                       AND grev.gacc_tran_id = gcpyt.gacc_tran_id
                                       AND gactran.tran_flag <> 'D')) 
         LOOP
            v_comm_pd := m.comm_amt;
         END LOOP;
            
         IF v_comm_pd IS NULL THEN
            v_comm_pd := 0.00;
         END IF;
            
         IF v_comm_pd = 0.00 THEN
            v_comm_os := (i.commission_amt * v_curr_rt);	
		   ELSE
            FOR z IN (SELECT (NVL(a.commission_amt, 0) - (NVL(c.wtax_amt, 0) + (NVL(c.input_vat_paid, 0)))) net_comm
  	    				      FROM gipi_comm_invoice a,
                             giis_intermediary b,
                             (SELECT j.intm_no, j.iss_cd, j.prem_seq_no, SUM(j.comm_amt) comm_amt,
                                     SUM(j.wtax_amt) wtax_amt, SUM(j.input_vat_amt) input_vat_paid
		   							  FROM giac_comm_payts j,
                                     giac_acctrans k
		  						       WHERE j.gacc_tran_id = k.tran_id
		    						      AND k.tran_flag <> 'D'
		    						      AND NOT EXISTS(SELECT 1
                                                  FROM giac_reversals x,
                                                       giac_acctrans y
                                                 WHERE x.reversing_tran_id = y.tran_id
		    										            AND y.tran_flag <> 'D'
		    										            AND x.gacc_tran_id = j.gacc_tran_id)
	       						    GROUP BY j.intm_no, j.iss_cd, j.prem_seq_no) c
 	   					  WHERE a.intrmdry_intm_no = b.intm_no
	     				       AND a.iss_cd = c.iss_cd(+)
	     					    AND a.prem_seq_no = c.prem_seq_no(+)
	     					    AND a.intrmdry_intm_no = c.intm_no(+)
                         AND a.iss_cd = i.iss_cd
                         AND a.prem_seq_no = i.prem_seq_no
                         AND a.intrmdry_intm_no = p_intm_no)
            LOOP			
               v_comm_os := z.net_comm;
			   END LOOP;
         END IF;
            
         v_row.total_prem_pd := NVL(v_row.total_prem_pd, 0) + v_prem_pd; 
         v_row.total_prem_os := NVL(v_row.total_prem_os, 0) + v_prem_os;
         v_row.total_comm_pd := NVL(v_row.total_comm_pd, 0) + v_comm_pd;            
         v_row.total_comm_os := NVL(v_row.total_comm_os, 0) + v_comm_os;
      END LOOP;
        
      FOR i IN(SELECT DISTINCT b.premium_amt, b.commission_amt, b.intrmdry_intm_no, b.policy_id, b.iss_cd, b.prem_seq_no,
                      gp.pol_flag, gp.par_id, gp.ref_pol_no, gp.line_cd, gp.subline_cd, gp.iss_cd iss_cd_gp, gp.iss_cd dsp_iss_cd,
                      gp.issue_yy, gp.pol_seq_no, gp.renew_no, gp.endt_iss_cd, gp.endt_yy, gp.endt_seq_no, gp.endt_type, d.assd_no, d.assd_name
                 FROM gipi_polbasic gp,
                      giac_comm_invoice b,
                      gipi_parlist c,
                      giis_assured d
                WHERE gp.policy_id = b.policy_id
                  AND gp.pol_flag != '5'
                  AND gp.reg_policy_sw = 'Y'
                  AND c.par_id = gp.par_id
                  AND c.assd_no = d.assd_no
                  AND check_user_per_iss_cd_acctg2(NULL, gp.iss_cd, p_module_id, p_user_id) = 1
                  AND intrmdry_intm_no = p_intm_no
                  AND UPPER(NVL(ref_pol_no, '%')) LIKE UPPER(NVL(p_ref_pol_no, NVL(ref_pol_no, '%')))
                  AND UPPER(b.iss_cd || '-' || LTRIM(TO_CHAR(b.prem_seq_no, '099999999999')))
                      LIKE UPPER(NVL(p_bill_number, b.iss_cd || '-' || LTRIM(TO_CHAR(b.prem_seq_no, '099999999999'))))
					   AND UPPER(gp.line_cd || '-' || gp.subline_cd || '-' || gp.iss_cd || '-' || LTRIM(TO_CHAR(gp.issue_yy, '09')) || '-' ||
                      LTRIM(TO_CHAR(gp.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(gp.renew_no, '09')))
                      LIKE UPPER(NVL(p_policy_number, gp.line_cd || '-' || gp.subline_cd || '-' || gp.iss_cd || '-' || LTRIM(TO_CHAR(gp.issue_yy, '09')) || '-' ||
                      LTRIM(TO_CHAR(gp.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(gp.renew_no, '09'))))    
	 				   AND UPPER(gp.endt_iss_cd || '-' || LTRIM(gp.endt_yy) || '-' || LTRIM(gp.endt_seq_no))
                      LIKE UPPER(NVL(p_endt_number, gp.endt_iss_cd || '-' || LTRIM(gp.endt_yy) || '-' || LTRIM(gp.endt_seq_no)))
				      AND UPPER(d.assd_no || ' - ' || d.assd_name) LIKE UPPER(NVL(p_assured, d.assd_no || ' - ' || d.assd_name))
                ORDER BY gp.iss_cd)
      LOOP
         v_row.prem_pd := 0;
         v_row.prem_os := 0;
         v_row.comm_pd := 0;
         v_row.comm_os := 0;
            
         FOR s IN(SELECT SUM(premium_amt) premium_amt, SUM(tax_amt) tax_amt
			           FROM giac_direct_prem_collns a,
			                giac_acctrans c
			          WHERE b140_iss_cd = i.iss_cd
			            AND b140_prem_seq_no = i.prem_seq_no
			            AND a.gacc_tran_id = c.tran_id
			            AND c.tran_flag <> 'D'
			            AND NOT EXISTS(SELECT 1
			 						 	        FROM giac_acctrans gactran,
                                           giac_reversals grev
			 							       WHERE gactran.tran_id = grev.reversing_tran_id
			 						            AND grev.gacc_tran_id = a.gacc_tran_id
			 							         AND gactran.tran_flag <> 'D'))
         LOOP
            v_premium_amt := s.premium_amt;		
            v_tax_amt := s.tax_amt;
         END LOOP;
			
         v_row.prem_pd := v_premium_amt + v_tax_amt;
			IF v_row.prem_pd IS NULL THEN
            v_row.prem_pd := 0.00;
			END IF;
            
         FOR k IN(SELECT a.currency_rt, a.prem_amt, a.tax_amt, b.share_percentage, b.intrmdry_intm_no
			           FROM gipi_invoice a,
                         gipi_comm_invoice b
			          WHERE b.intrmdry_intm_no = p_intm_no
			            AND a.iss_cd = i.iss_cd
			            AND a.iss_cd = b.iss_cd
			            AND a.prem_seq_no = i.prem_seq_no
			            AND a.prem_seq_no = b.prem_seq_no)	
         LOOP
            v_curr_rt := k.currency_rt;
            v_prem_amt := k.prem_amt;
            v_tax_amt := k.tax_amt;
            v_share_per := k.share_percentage;
		   END LOOP;
            
         v_row.prem_os := ((v_prem_amt + v_tax_amt) * v_share_per /100 * v_curr_rt) - v_row.prem_pd;
            
         FOR m IN(SELECT SUM(comm_amt - wtax_amt + input_vat_amt) comm_amt      
			           FROM giac_comm_payts gcpyt,
                         giac_acctrans gactran
			          WHERE gcpyt.iss_cd = i.iss_cd
			            AND gcpyt.prem_seq_no = i.prem_seq_no
			            AND gcpyt.gacc_tran_id = gactran.tran_id
			            AND gactran.tran_flag <> 'D'
			            AND NOT EXISTS(SELECT 1
			                             FROM giac_acctrans gactran,
                                           giac_reversals grev
                                     WHERE gactran.tran_id = grev.reversing_tran_id
                                       AND grev.gacc_tran_id = gcpyt.gacc_tran_id
                                       AND gactran.tran_flag <> 'D')) 
         LOOP
            v_row.comm_pd := m.comm_amt;
		   END LOOP;
            
         IF v_row.comm_pd IS NULL THEN
            v_row.comm_pd := 0.00;
		   END IF;
            
         IF v_row.comm_pd = 0.00 then
            v_row.comm_os := (i.commission_amt * v_curr_rt);	
		   ELSE
            FOR z IN (SELECT (NVL(a.commission_amt, 0) - (NVL(c.wtax_amt, 0) + (NVL(c.input_vat_paid, 0)))) net_comm
  	    				      FROM gipi_comm_invoice a,
                             giis_intermediary b,
                             (SELECT j.intm_no, j.iss_cd, j.prem_seq_no, SUM(j.comm_amt) comm_amt,
                                     SUM(j.wtax_amt) wtax_amt, SUM(j.input_vat_amt) input_vat_paid
		   							  FROM giac_comm_payts j,
                                     giac_acctrans k
		  						       WHERE j.gacc_tran_id = k.tran_id
		    						      AND k.tran_flag <> 'D'
		    						      AND NOT EXISTS(SELECT 1
                                                  FROM giac_reversals x,
                                                       giac_acctrans y
                                                 WHERE x.reversing_tran_id = y.tran_id
		    										            AND y.tran_flag <> 'D'
		    										            AND x.gacc_tran_id = j.gacc_tran_id)
	       						    GROUP BY j.intm_no, j.iss_cd, j.prem_seq_no) c
 	   					  WHERE a.intrmdry_intm_no = b.intm_no
	     				       AND a.iss_cd = c.iss_cd(+)
	     					    AND a.prem_seq_no = c.prem_seq_no(+)
                         AND a.intrmdry_intm_no = c.intm_no(+)
                         AND a.iss_cd = i.iss_cd
                         AND a.prem_seq_no = i.prem_seq_no
                         AND a.intrmdry_intm_no = p_intm_no)
            LOOP			
               v_row.comm_os := z.net_comm;
            END LOOP;
         END IF;
            
         v_row.iss_cd := i.iss_cd;
         v_row.prem_seq_no := i.prem_seq_no;
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.pol_iss_cd := i.iss_cd_gp;
         v_row.issue_yy := i.issue_yy;
         v_row.pol_seq_no := i.pol_seq_no;
         v_row.renew_no := i.renew_no;
         v_row.endt_iss_cd := i.endt_iss_cd;
         v_row.endt_yy := i.endt_yy;
         v_row.endt_seq_no := i.endt_seq_no;
         v_row.endt_type := i.endt_type;
         v_row.ref_pol_no := i.ref_pol_no;
         v_row.assd_no := i.assd_no;
         v_row.assd_name := i.assd_name;
         v_row.bill_number := i.iss_cd || '-' || LTRIM(TO_CHAR(i.prem_seq_no, '099999999999'));
         v_row.policy_number := i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd_gp || '-' || LTRIM(TO_CHAR(i.issue_yy, '09')) || '-' ||
                                LTRIM(TO_CHAR(i.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(i.renew_no, '09'));
         v_row.endt_number := i.endt_iss_cd || '-' || LTRIM(i.endt_yy) || '-' || LTRIM(i.endt_seq_no);
         v_row.assured := i.assd_no || ' - ' || i.assd_name;
         PIPE ROW(v_row);
      END LOOP;
   END;

END GIACS288_PKG;
/



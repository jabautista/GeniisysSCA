DROP FUNCTION CPI.GET_GCOP_INV;

CREATE OR REPLACE FUNCTION CPI.get_gcop_inv(p_tran_type			   	   IN	  GIAC_COMM_PAYTS.tran_type%TYPE,
	   	  		  						 p_iss_cd				   IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
	   	  		  						 p_prem_seq_no  		   IN	  GIAC_COMM_PAYTS.prem_seq_no%TYPE,
										 p_intm_no				   IN	  GIAC_COMM_PAYTS.intm_no%TYPE,
										 p_intm_name			   IN	  GIIS_INTERMEDIARY.intm_name%TYPE,
										 p_var_v_from_sums		   IN 	  VARCHAR2,
										 p_keyword				   IN	  VARCHAR2,
                                         p_on_lov                  IN     VARCHAR2, -- added by shan 10.16.2014
                                         p_get_no_prem_payt        IN     VARCHAR2, -- added by shan 10.24.2014
                                         p_user_id                 IN     VARCHAR2) -- added by john 11.9.2015
RETURN GIAC_COMM_PAYTS_PKG.gcop_inv_tab PIPELINED
IS
  	v_gcop_inv							GIAC_COMM_PAYTS_PKG.gcop_inv_type;
    v_mc_access                         VARCHAR2(5) := check_user_override_function2(p_user_id, 'GIACS020', 'MC');
    v_au_access                         VARCHAR2(5) := check_user_override_function2(p_user_id, 'GIACS020', 'AU');
	
	CURSOR a IS
		SELECT a.gacc_tran_id, a.iss_cd, 
		       a.prem_seq_no , 
		       a.intrmdry_intm_no intm_no, 
		       d.intm_name,
               --added by steven 10.10.2014
--		       DECODE(giacp.v('NO_PREM_PAYT') , 'N', ROUND (  NVL (c.commission_amt, a.commission_amt)* e.premium_amt / b.prem_amt,2)- NVL (f.pd_comm, 0)
--                                                   , ROUND (  NVL (c.commission_amt, a.commission_amt),2)- NVL (f.pd_comm, 0)) comm_amt,--Vincent 07122006
               ROUND (  NVL (c.commission_amt, a.commission_amt)* e.premium_amt / b.prem_amt,2)- NVL (f.pd_comm, 0) comm_amt,
			   round((round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0)) * nvl(d.input_vat_rate,0)/100,2) invat_amt,--Vincent 07122006
		       --round(nvl(c.wholding_tax,a.wholding_tax)* e.premium_amt/b.prem_amt,2) - nvl(f.pd_wtax,0) wtax_amt--Vincent 07122006
               (round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0)) * d.wtax_rate/100 wtax_amt  --joanne 09.10.14, for sr 16760
		  FROM (SELECT iss_cd, prem_seq_no, intm_no, nvl(sum(comm_amt),0) pd_comm, nvl(sum(wtax_amt),0) pd_wtax, nvl(sum(input_vat_amt),0) pd_invat
              FROM giac_acctrans b,giac_comm_payts a 
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND NOT EXISTS(SELECT 'x' 
                                FROM giac_reversals cc, giac_acctrans dd 
                               WHERE cc.reversing_tran_id = dd.tran_id 
                                 AND dd.tran_flag <> 'D' 
                                 AND cc.gacc_tran_id = b.tran_id)
               AND a.iss_cd = nvl(p_iss_cd, a.iss_cd)
               AND a.prem_seq_no = nvl(p_prem_seq_no,a.prem_seq_no)
               AND a.intm_no = nvl(p_intm_no,a.intm_no)                  					                                  
             GROUP BY iss_cd, prem_seq_no, intm_no) f,
           (SELECT b140_iss_cd iss_cd, b140_prem_seq_no prem_seq_no, nvl(sum(a.premium_amt),0) premium_amt, null intm_no  -- added intm_no : shan 10.16.2014
		          FROM giac_acctrans b,
		               giac_direct_prem_collns a
		         WHERE NOT EXISTS(SELECT 'x' 
		                            FROM giac_reversals cc, giac_acctrans dd 
		                           WHERE cc.reversing_tran_id = dd.tran_id 
		                             AND dd.tran_flag <> 'D' 
		                             AND cc.gacc_tran_id = b.tran_id)
					     AND b.tran_flag <> 'D'
		           AND a.gacc_tran_id   = b.tran_id
               AND a.b140_iss_cd = nvl(p_iss_cd, a.b140_iss_cd)
               AND a.b140_prem_seq_no = nvl(p_prem_seq_no,a.b140_prem_seq_no)	           
		         GROUP BY b140_iss_cd, b140_prem_seq_no
		        HAVING nvl(sum(a.premium_amt),0) > 0
             UNION      -- added to retrieve Bill No without premium collection yet : shan 09.12.2014
            SELECT x.iss_cd, x.prem_seq_no, x.premium_amt, x.INTRMDRY_INTM_NO
              FROM gipi_comm_invoice x
             WHERE (SELECT decode(sum(nvl(a.premium_amt,0)),null,0,sum(nvl(a.premium_amt,0))) premium_amt
                      FROM giac_direct_prem_collns a, giac_acctrans b
                     WHERE b140_iss_cd      = x.iss_cd
                       AND b140_prem_seq_no = x.prem_seq_no
                       --AND 1 = DECODE(giacp.v('NO_PREM_PAYT'),'N',0,1) --added by steven 10.10.2014 -- commented by shan : 10.16.2014
                       AND a.gacc_tran_id = b.tran_id
                       AND a.gacc_tran_id not in (SELECT c.gacc_tran_id
                                                    FROM giac_reversals c,
                                                         giac_acctrans d
                                                   WHERE c.reversing_tran_id = d.tran_id 
                                                     AND d.tran_flag <> 'D')
                       AND b.tran_flag <> 'D') = 0
               AND NVL(x.premium_amt, 0) > 0
               AND x.iss_cd = nvl(p_iss_cd, x.iss_cd)
               AND x.prem_seq_no = nvl(p_prem_seq_no,x.prem_seq_no) 
               AND x.INTRMDRY_INTM_NO = nvl(p_intm_no, x.INTRMDRY_INTM_NO)
               AND ((p_on_lov = 'N'
                       AND EXISTS (SELECT 'X'
                                     FROM gipi_comm_inv_dtl
                                    WHERE iss_cd = x.iss_cd
                                      AND prem_seq_no = x.prem_seq_no
                                      AND nvl(commission_amt, 0) > 0
                                   HAVING COUNT(intrmdry_intm_no) > 1))
                   OR
                   (1 = DECODE(giacp.v('NO_PREM_PAYT'),'N',0,1)
                    AND NVL(p_get_no_prem_payt,'Y') = 'Y') --added default value by robert SR 19679 07.13.15
                   )) e,   
		  		 giis_intermediary d, 
		       gipi_comm_inv_dtl c, 
		       gipi_invoice b, 
		       gipi_comm_invoice a 
		 WHERE 1=1 
       AND round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0) 
           - (round(nvl(c.wholding_tax,a.wholding_tax)* e.premium_amt/b.prem_amt,2) - nvl(f.pd_wtax,0)) > 0 --Vincent 07122006
       AND round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0) > 0 --Vincent 07122006
	       AND d.intm_name LIKE nvl(p_intm_name, d.intm_name)
		   AND a.iss_cd = f.iss_cd(+)
		   AND a.prem_seq_no = f.prem_seq_no(+)
		   AND a.intrmdry_intm_no = f.intm_no(+)
		   AND b.iss_cd = e.iss_cd
		   AND b.prem_seq_no = e.prem_seq_no
		   AND d.intm_no = a.intrmdry_intm_no
		   AND a.iss_cd = b.iss_cd
		   AND a.prem_seq_no = b.prem_seq_no
		   AND a.iss_cd = c.iss_cd(+)
		   AND a.prem_seq_no = c.prem_seq_no(+)
		   AND a.intrmdry_intm_no = c.intrmdry_intm_no (+)
		   AND nvl(c.commission_amt,a.commission_amt) > 0              
		   AND a.iss_cd = nvl(p_iss_cd, a.iss_cd)
		   AND a.prem_seq_no = nvl(p_prem_seq_no,a.prem_seq_no)
		   AND a.intrmdry_intm_no = nvl(p_intm_no,a.intrmdry_intm_no)
           AND a.intrmdry_intm_no = NVL(e.intm_no, a.intrmdry_intm_no)   -- to display one record per iss_cd, prem_seq_no and intm_no : shan 10.16.2014
		   AND /*EXISTS (SELECT 1
	   	   		     FROM dual
					
	   	   		  	   )*/
		       (UPPER(d.intm_name) LIKE nvl('%'||UPPER(p_keyword)||'%', d.intm_name)
			   OR UPPER(a.iss_cd) LIKE nvl('%'||UPPER(p_keyword)||'%', a.iss_cd)
		       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
		       OR a.intrmdry_intm_no LIKE nvl('%'||p_keyword||'%', a.intrmdry_intm_no))
		 ORDER BY 1,2,3;

	CURSOR b IS
    SELECT a.gacc_tran_id, a.iss_cd, 
           a.prem_seq_no, 
           a.intm_no,
           d.intm_name, 
          /* -1 * nvl(sum(comm_amt),0) comm_amt,
           round(-1 * nvl(sum(comm_amt),0) * nvl(d.input_vat_rate,0)/100,2) invat_amt, --Vincent 07122006
           -1 * nvl(sum(wtax_amt),0) wtax_amt  */  -- replaced with codes below to display bill with multiple partial comm payments separately : shan 09.25.2014
           -1 * nvl(comm_amt,0) comm_amt,
           round(-1 * nvl(comm_amt,0) * nvl(d.input_vat_rate,0)/100,2) invat_amt, --Vincent 07122006
           -1 * nvl(wtax_amt,0) wtax_amt       
      FROM giis_intermediary d,
           gipi_comm_invoice c, 
           giac_acctrans b,
           giac_comm_payts a            
     WHERE 1=1
	   AND d.intm_name LIKE nvl(p_intm_name, d.intm_name)
       AND d.intm_no = a.intm_no
       AND a.iss_cd = c.iss_cd
       AND a.prem_seq_no = c.prem_seq_no
       AND a.intm_no = c.intrmdry_intm_no                  					                                  
       AND a.gacc_tran_id = b.tran_id
       AND b.tran_flag <> 'D'
       AND NOT EXISTS(SELECT 'x' 
                        FROM giac_reversals cc, giac_acctrans dd 
                       WHERE cc.reversing_tran_id = dd.tran_id 
                         AND dd.tran_flag <> 'D' 
                         AND cc.gacc_tran_id = b.tran_id)
       AND a.iss_cd LIKE nvl(p_iss_cd, a.iss_cd)
       AND a.prem_seq_no LIKE nvl(p_prem_seq_no,a.prem_seq_no)
       AND a.intm_no LIKE nvl(p_intm_no,a.intm_no)
       AND a.tran_type IN (1,2)
	   AND /*EXISTS (SELECT 1
	   	   		     FROM dual
					WHERE d.intm_name LIKE nvl('%'||p_keyword||'%', d.intm_name)
					   OR a.iss_cd LIKE nvl('%'||p_keyword||'%', a.iss_cd)
				       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
				       OR a.intm_no LIKE nvl('%'||p_keyword||'%', a.intm_no)
	   	   		  	   ) */
		   (UPPER(d.intm_name) LIKE nvl('%'||UPPER(p_keyword)||'%', d.intm_name)
		   OR UPPER(a.iss_cd) LIKE nvl('%'||UPPER(p_keyword)||'%', a.iss_cd)
	       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
	       OR a.intm_no LIKE nvl('%'||p_keyword||'%', a.intm_no))         					                                  
     /*GROUP BY a.iss_cd, a.prem_seq_no, a.intm_no, d.intm_name, nvl(d.input_vat_rate,0)     
    HAVING (nvl(sum(comm_amt),0) > 0 AND nvl(sum(comm_amt),0)-nvl(sum(wtax_amt),0) > 0)*/ -- replaced with codes below : shan 09.25.2014
          AND nvl(comm_amt, 0) > 0
          AND nvl(comm_amt, 0) - nvl(wtax_amt, 0) > 0
		 ORDER BY 1,2,3;
		     
	CURSOR c IS
		SELECT a.gacc_tran_id, a.iss_cd, 
		       a.prem_seq_no , 
		       a.intrmdry_intm_no intm_no, 
		       d.intm_name,
               --added by steven 10.10.2014
               DECODE(giacp.v('NO_PREM_PAYT') , 'N', ROUND (  NVL (c.commission_amt, a.commission_amt)* e.premium_amt / b.prem_amt,2)- NVL (f.pd_comm, 0)
                                                   , ROUND (  NVL (c.commission_amt, a.commission_amt),2)- NVL (f.pd_comm, 0)) comm_amt,
		       --round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0) comm_amt,--Vincent 07122006
		       round((round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0)) * nvl(d.input_vat_rate,0)/100,2) invat_amt,--Vincent 07122006
		       round(nvl(c.wholding_tax,a.wholding_tax) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_wtax,0) wtax_amt--Vincent 07122006
		  FROM (SELECT iss_cd, prem_seq_no, intm_no, nvl(sum(comm_amt),0) pd_comm, nvl(sum(wtax_amt),0) pd_wtax, nvl(sum(input_vat_amt),0) pd_invat
              FROM giac_acctrans b,giac_comm_payts a 
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND NOT EXISTS(SELECT 'x' 
                                FROM giac_reversals cc, giac_acctrans dd 
                               WHERE cc.reversing_tran_id = dd.tran_id 
                                 AND dd.tran_flag <> 'D' 
                                 AND cc.gacc_tran_id = b.tran_id)
               AND a.iss_cd = nvl(p_iss_cd, a.iss_cd)
               AND a.prem_seq_no = nvl(p_prem_seq_no,a.prem_seq_no)
               AND a.intm_no = nvl(p_intm_no,a.intm_no)                  					                                  
             GROUP BY iss_cd, prem_seq_no, intm_no) f,
           (SELECT b140_iss_cd iss_cd, b140_prem_seq_no prem_seq_no, nvl(sum(a.premium_amt),0) premium_amt
		          FROM giac_acctrans b,
		               giac_direct_prem_collns a
		         WHERE NOT EXISTS(SELECT 'x' 
		                            FROM giac_reversals cc, giac_acctrans dd 
		                           WHERE cc.reversing_tran_id = dd.tran_id 
		                             AND dd.tran_flag <> 'D' 
		                             AND cc.gacc_tran_id = b.tran_id)
					     AND b.tran_flag <> 'D'
		           AND a.gacc_tran_id   = b.tran_id
               AND a.b140_iss_cd = nvl(p_iss_cd, a.b140_iss_cd)
               AND a.b140_prem_seq_no = nvl(p_prem_seq_no,a.b140_prem_seq_no)	           
		         GROUP BY b140_iss_cd, b140_prem_seq_no
		        HAVING nvl(sum(a.premium_amt),0) < 0) e,   
		  		 giis_intermediary d, 
		       gipi_comm_inv_dtl c, 
		       gipi_invoice b, 
		       gipi_comm_invoice a 
		 WHERE 1=1 
	   AND d.intm_name LIKE nvl(p_intm_name, d.intm_name)
       AND round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0) 
           - (round(nvl(c.wholding_tax,a.wholding_tax)* e.premium_amt/b.prem_amt,2) - nvl(f.pd_wtax,0)) < 0 --Vincent 07122006
       AND round(nvl(c.commission_amt,a.commission_amt) * e.premium_amt/b.prem_amt,2) - nvl(f.pd_comm,0) < 0 --Vincent 07122006  
		   AND a.iss_cd = f.iss_cd(+)
		   AND a.prem_seq_no = f.prem_seq_no(+)
		   AND a.intrmdry_intm_no = f.intm_no(+)
		   AND b.iss_cd = e.iss_cd
		   AND b.prem_seq_no = e.prem_seq_no
		   AND d.intm_no = a.intrmdry_intm_no
		   AND a.iss_cd = b.iss_cd
		   AND a.prem_seq_no = b.prem_seq_no
		   AND a.iss_cd = c.iss_cd(+)
		   AND a.prem_seq_no = c.prem_seq_no(+)
		   AND a.intrmdry_intm_no = c.intrmdry_intm_no (+)
		   AND nvl(c.commission_amt,a.commission_amt) < 0              
		   AND a.iss_cd = nvl(p_iss_cd, a.iss_cd)
		   AND a.prem_seq_no = nvl(p_prem_seq_no,a.prem_seq_no)
		   AND a.intrmdry_intm_no = nvl(p_intm_no,a.intrmdry_intm_no)
		   AND /*EXISTS (SELECT 1
	   	   		     FROM dual
					WHERE d.intm_name LIKE nvl('%'||p_keyword||'%', d.intm_name)
					   OR a.iss_cd LIKE nvl('%'||p_keyword||'%', a.iss_cd)
				       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
				       OR a.intrmdry_intm_no LIKE nvl('%'||p_keyword||'%', a.intrmdry_intm_no)
	   	   		  	   ) */
			   (UPPER(d.intm_name) LIKE nvl('%'||UPPER(p_keyword)||'%', d.intm_name)
			   OR UPPER(a.iss_cd) LIKE nvl('%'||UPPER(p_keyword)||'%', a.iss_cd)
		       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
		       OR a.intrmdry_intm_no LIKE nvl('%'||p_keyword||'%', a.intrmdry_intm_no))
		 ORDER BY 1,2,3;
 
	CURSOR d IS
    SELECT a.gacc_tran_id, a.iss_cd, 
           a.prem_seq_no, 
           a.intm_no,
           d.intm_name, 
           /*-1 * nvl(sum(comm_amt),0) comm_amt, 
           -1 * nvl(sum(wtax_amt),0) wtax_amt, 
           round(-1 * nvl(sum(comm_amt),0) * nvl(d.input_vat_rate,0)/100,2) invat_amt --Vincent 07122006*/ -- replaced with codes below to display bill with multiple partial comm payments separately : shan 09.25.2014
           -1 * nvl(comm_amt,0) comm_amt, 
           -1 * nvl(wtax_amt,0) wtax_amt, 
           round(-1 * nvl(comm_amt,0) * nvl(d.input_vat_rate,0)/100,2) invat_amt 
      FROM giis_intermediary d,
           gipi_comm_invoice c, 
           giac_acctrans b,
           giac_comm_payts a            
     WHERE 1=1
       AND d.intm_name LIKE nvl(p_intm_name, d.intm_name)
       AND d.intm_no = a.intm_no
       AND a.iss_cd = c.iss_cd
       AND a.prem_seq_no = c.prem_seq_no
       AND a.intm_no = c.intrmdry_intm_no                                                                        
       AND a.gacc_tran_id = b.tran_id
       AND b.tran_flag <> 'D'
       AND NOT EXISTS(SELECT 'x' 
                        FROM giac_reversals cc, giac_acctrans dd 
                       WHERE cc.reversing_tran_id = dd.tran_id 
                         AND dd.tran_flag <> 'D' 
                         AND cc.gacc_tran_id = b.tran_id)
       AND a.iss_cd = nvl(p_iss_cd, a.iss_cd)
       AND a.prem_seq_no = nvl(p_prem_seq_no,a.prem_seq_no)
       AND a.intm_no = nvl(p_intm_no,a.intm_no)
       AND a.tran_type IN (3,4)
       AND /*EXISTS (SELECT 1
	   	   		     FROM dual
					WHERE d.intm_name LIKE nvl('%'||p_keyword||'%', d.intm_name)
					   OR a.iss_cd LIKE nvl('%'||p_keyword||'%', a.iss_cd)
				       OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
				       OR a.intm_no LIKE nvl('%'||p_keyword||'%', a.intm_no)
	   	   		  	   ) */
           (UPPER(d.intm_name) LIKE nvl('%'||UPPER(p_keyword)||'%', d.intm_name)
           OR UPPER(a.iss_cd) LIKE nvl('%'||UPPER(p_keyword)||'%', a.iss_cd)
           OR a.prem_seq_no LIKE nvl('%'||p_keyword||'%', a.prem_seq_no)
           OR a.intm_no LIKE nvl('%'||p_keyword||'%', a.intm_no))
     /*GROUP BY a.iss_cd, a.prem_seq_no, a.intm_no, d.intm_name, nvl(d.input_vat_rate,0)     
    HAVING (nvl(sum(comm_amt),0) < 0 AND nvl(sum(comm_amt),0)-nvl(sum(wtax_amt),0) < 0)*/ -- replaced with codes below : shan 09.25.2014
          AND nvl(comm_amt, 0) < 0 
          AND nvl(comm_amt,0)-nvl(wtax_amt,0) < 0
         ORDER BY 1,2,3;
         
    v_cur_rt        GIPI_INVOICE.CURRENCY_RT%TYPE;
    p_def_comm_amt      NUMBER;
    p_def_input_vat     NUMBER;
    p_var_max_input_vat NUMBER;
    p_var_clr_rec       VARCHAR2(1);
    p_var_message       VARCHAR2(150);
    
BEGIN
	IF nvl(p_var_v_from_sums, 'N') <> 'Y' THEN  
	  IF p_tran_type = 1 THEN
		FOR a_rec IN a
		 LOOP
            v_gcop_inv.bill_gacc_tran_id := a_rec.gacc_tran_id;  -- shan 10.02.2014
		 	v_gcop_inv.bill_no	   := a_rec.iss_cd || '-' || to_char(a_rec.prem_seq_no, 'FM000000000000');
		    v_gcop_inv.iss_cd      := a_rec.iss_cd;
	      	v_gcop_inv.prem_seq_no := a_rec.prem_seq_no;
	      	v_gcop_inv.intm_no     := a_rec.intm_no;
	      	v_gcop_inv.intm_name   := a_rec.intm_name;
	      	/*v_gcop_inv.comm_amt    := to_char(a_rec.comm_amt, '999999999990.99');
	      	v_gcop_inv.invat_amt   := to_char(a_rec.invat_amt, '999999999990.99');
	      	v_gcop_inv.wtax        := to_char(a_rec.wtax_amt, '999999999990.99'); 
	      	v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');*/
			v_gcop_inv.chk_tag_enable := 'Y';
            
            IF NVL(GIACP.v('NO_PREM_PAYT'),'N') = 'Y' AND v_au_access = 'TRUE' THEN --added condition by robert SR 19679 07.13.15
            GIAC_COMM_PAYTS_PKG.PARAM2_FULL_PREM_PAYT(a_rec.iss_cd, a_rec.prem_seq_no, a_rec.intm_no, v_gcop_inv.comm_amt, v_gcop_inv.wtax, v_gcop_inv.invat_amt,
                                                      p_def_comm_amt, p_def_input_vat, v_gcop_inv.ncomm_amt, p_var_max_input_vat, p_var_clr_rec, p_var_message);
			ELSE  --added condition by robert SR 19679 07.13.15
				v_gcop_inv.comm_amt    := to_char(a_rec.comm_amt, '999999999990.99');
				v_gcop_inv.invat_amt   := to_char(a_rec.invat_amt, '999999999990.99');
				v_gcop_inv.wtax        := to_char(a_rec.wtax_amt, '999999999990.99'); 
				v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');
			END IF; --end robert SR 19679 07.13.15
            v_gcop_inv.comm_amt    := to_char(v_gcop_inv.comm_amt, '999999999990.99');
	      	v_gcop_inv.invat_amt   := to_char(v_gcop_inv.invat_amt, '999999999990.99');
	      	v_gcop_inv.wtax        := to_char(v_gcop_inv.wtax, '999999999990.99'); 
	      	v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');
            
			PIPE ROW(v_gcop_inv);
		END LOOP;
	  ELSIF p_tran_type = 2 THEN
	    FOR b_rec IN b
	  	 LOOP
            v_gcop_inv.bill_gacc_tran_id := b_rec.gacc_tran_id;  -- shan 10.02.2014
		 	v_gcop_inv.bill_no	   := b_rec.iss_cd || '-' || to_char(b_rec.prem_seq_no, 'FM000000000000');
		    v_gcop_inv.iss_cd      := b_rec.iss_cd;
	      	v_gcop_inv.prem_seq_no := b_rec.prem_seq_no;
	      	v_gcop_inv.intm_no     := b_rec.intm_no;
	      	v_gcop_inv.intm_name   := b_rec.intm_name;
	      	v_gcop_inv.comm_amt    := to_char(b_rec.comm_amt, '999999999990.99');
	      	v_gcop_inv.invat_amt   := to_char(b_rec.invat_amt, '999999999990.99');
	      	v_gcop_inv.wtax        := to_char(b_rec.wtax_amt, '999999999990.99'); 
	      	v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');
			v_gcop_inv.chk_tag_enable := 'Y';
			
			PIPE ROW(v_gcop_inv);
	    END LOOP;  
	  ELSIF	p_tran_type = 3 THEN
	    FOR c_rec IN c
	     LOOP
            v_gcop_inv.bill_gacc_tran_id := c_rec.gacc_tran_id;  -- shan 10.02.2014
		 	v_gcop_inv.bill_no	   := c_rec.iss_cd || '-' || to_char(c_rec.prem_seq_no, 'FM000000000000');
		    v_gcop_inv.iss_cd      := c_rec.iss_cd;
	      	v_gcop_inv.prem_seq_no := c_rec.prem_seq_no;
	      	v_gcop_inv.intm_no     := c_rec.intm_no;
	      	v_gcop_inv.intm_name   := c_rec.intm_name;
	      	v_gcop_inv.comm_amt    := to_char(c_rec.comm_amt, '999999999990.99');
	      	v_gcop_inv.invat_amt   := to_char(c_rec.invat_amt, '999999999990.99');
	      	v_gcop_inv.wtax        := to_char(c_rec.wtax_amt, '999999999990.99'); 
	      	v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');
			v_gcop_inv.chk_tag_enable := 'Y';
			
			PIPE ROW(v_gcop_inv);
	    END LOOP;
	  ELSIF p_tran_type = 4 THEN
	    FOR d_rec IN d
	  	 LOOP
            v_gcop_inv.bill_gacc_tran_id := d_rec.gacc_tran_id;  -- shan 10.02.2014
		 	v_gcop_inv.bill_no	   := d_rec.iss_cd || '-' || to_char(d_rec.prem_seq_no, 'FM000000000000');
		    v_gcop_inv.iss_cd      := d_rec.iss_cd;
	      	v_gcop_inv.prem_seq_no := d_rec.prem_seq_no;
	      	v_gcop_inv.intm_no     := d_rec.intm_no;
	      	v_gcop_inv.intm_name   := d_rec.intm_name;
	      	v_gcop_inv.comm_amt    := to_char(d_rec.comm_amt, '999999999990.99');
	      	v_gcop_inv.invat_amt   := to_char(d_rec.invat_amt, '999999999990.99');
	      	v_gcop_inv.wtax        := to_char(d_rec.wtax_amt, '999999999990.99'); 
	      	v_gcop_inv.ncomm_amt   := to_char(v_gcop_inv.comm_amt + v_gcop_inv.invat_amt - v_gcop_inv.wtax, '999999999990.99');
			v_gcop_inv.chk_tag_enable := 'Y';
                 
			PIPE ROW(v_gcop_inv);
	    END LOOP;    
	  END IF;
	END IF;
END get_gcop_inv; 
/


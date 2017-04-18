CREATE OR REPLACE PACKAGE BODY CPI.giac_pdc_prem_colln_pkg
AS
   FUNCTION get_dated_checks_dtls (p_gacc_tran_id giac_direct_prem_collns.gacc_tran_id%type)
      RETURN giac_pdc_prem_colln_dtls_tab PIPELINED
   IS
      v_dated_checks   giac_pdc_prem_colln_dtls_type;
   BEGIN
      FOR i IN (SELECT pdc_id, transaction_type, iss_cd, prem_seq_no, inst_no, collection_amt, currency_cd, currency_rt, fcurrency_amt,
	  	  	   		   premium_amt, tax_amt, insert_tag
                  FROM giac_pdc_prem_colln
                 WHERE pdc_id IN (SELECT pdc_id
                                    FROM giac_apdc_payt_dtl
                                   WHERE gacc_tran_id = p_gacc_tran_id)
                   AND NOT EXISTS (
                          SELECT *
                            FROM giac_direct_prem_collns
                           WHERE gacc_tran_id = p_gacc_tran_id
                             AND b140_iss_cd = iss_cd
                             AND b140_prem_seq_no = prem_seq_no
                             AND inst_no = inst_no))
      LOOP
         v_dated_checks.pdc_id := i.pdc_id;
         v_dated_checks.transaction_type := i.transaction_type;
         v_dated_checks.iss_cd := i.iss_cd;
         v_dated_checks.prem_seq_no := i.prem_seq_no;
         v_dated_checks.inst_no := i.inst_no;
         v_dated_checks.collection_amt := i.collection_amt;
         v_dated_checks.currency_cd := i.currency_cd;
         v_dated_checks.currency_rt := i.currency_rt;
         v_dated_checks.fcurrency_amt := i.fcurrency_amt;
         v_dated_checks.premium_amt := i.premium_amt;
         v_dated_checks.tax_amt := i.tax_amt;
         v_dated_checks.insert_tag := i.insert_tag;
         PIPE ROW (v_dated_checks);
      END LOOP;

      RETURN;
   END get_dated_checks_dtls;
   
   /*
    **  Created by		: Angelo Pagaduan
	**  Date Created 	: 02.04.2011  
	**  Reference By 	: (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: gets post dated check dtls from giac_pdc_prem_colln using pdc_id
   */	  
   
   FUNCTION get_post_dated_checks_dtls(p_pdc_id giac_apdc_payt_dtl.pdc_id%TYPE)
      RETURN giac_pdc_premcolln_dtls_tab PIPELINED
   IS
   	  v_post_dated_checks	giac_pdc_premcolln_dtls_type;
   BEGIN
      FOR gpdc_prem IN (SELECT a.pdc_id,    a.transaction_type, a.iss_cd,       a.prem_seq_no, 
                               a.inst_no,   a.collection_amt,   a.currency_cd,  a.currency_rt, 
                               a.fcurrency_amt, a.premium_amt,  a.tax_amt,      a.insert_tag, 
                               a.last_update, g.rv_meaning tran_type_desc,
                               rtrim(d.line_cd) || '-' || rtrim(d.subline_cd) || '-' || rtrim(d.iss_cd) || 
                               '-' || ltrim(to_char(d.issue_yy, '09')) || '-' || ltrim(to_char(d.pol_seq_no, '0999999')) || 
                               decode(d.endt_seq_no,0,NULL, '-' ||d.endt_iss_cd ||'-'||ltrim(to_char(d.endt_yy, '09'))||
	   						   '-' ||ltrim(to_char(d.endt_seq_no)) || '-' || rtrim(d.endt_type))||'-'||
	   						   ltrim(to_char(d.renew_no, '09')) policy_no, f.assd_name
                            FROM giac_pdc_prem_colln a
                                ,giac_aging_soa_details b
                                ,gipi_invoice c
                                ,gipi_polbasic d
                                ,gipi_parlist e
                                ,giis_assured f
                                ,cg_ref_codes g
						WHERE a.pdc_id = p_pdc_id
                          AND g.rv_domain = 'GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE'
                          AND g.rv_low_value = a.transaction_type
                          AND c.prem_seq_no = a.prem_seq_no
                          AND b.iss_cd = a.iss_cd
                          AND b.prem_seq_no = a.prem_seq_no
                          AND b.inst_no = a.inst_no
                          AND c.prem_seq_no = b.prem_seq_no
                          AND c.iss_cd = b.iss_cd
                          AND d.policy_id = b.policy_id
                          AND e.par_id = d.par_id  
                          AND f.assd_no = e.assd_no)
	  LOOP
	      v_post_dated_checks.pdc_id  		   := gpdc_prem.pdc_id;
	  	  v_post_dated_checks.transaction_type := gpdc_prem.transaction_type;
		  v_post_dated_checks.iss_cd		   := gpdc_prem.iss_cd;
		  v_post_dated_checks.prem_seq_no	   := gpdc_prem.prem_seq_no;
		  v_post_dated_checks.inst_no		   := gpdc_prem.inst_no;
		  v_post_dated_checks.collection_amt   := gpdc_prem.collection_amt;
		  v_post_dated_checks.currency_cd	   := gpdc_prem.currency_cd;
		  v_post_dated_checks.currency_rt	   := gpdc_prem.currency_rt;
		  v_post_dated_checks.fcurrency_amt	   := gpdc_prem.fcurrency_amt;
		  v_post_dated_checks.premium_amt	   := gpdc_prem.premium_amt;
		  v_post_dated_checks.tax_amt		   := gpdc_prem.tax_amt;
		  v_post_dated_checks.insert_tag	   := gpdc_prem.insert_tag;
		  v_post_dated_checks.last_update	   := gpdc_prem.last_update;
          v_post_dated_checks.tran_type_desc   := gpdc_prem.tran_type_desc;
          v_post_dated_checks.policy_no         := gpdc_prem.policy_no;
          v_post_dated_checks.assd_name         := gpdc_prem.assd_name;
   		  PIPE ROW (v_post_dated_checks);
	  END LOOP;
	  RETURN;
   END get_post_dated_checks_dtls;


   
   /*
    **  Created by		: Andrew Robes
	**  Date Created 	: 11.22.2011  
	**  Reference By 	: (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: Function to retrieve pdc_prem_colln records based on a given pdc_id
   */	  
   
   FUNCTION get_pdc_prem_colln_listing(p_pdc_id giac_apdc_payt_dtl.pdc_id%TYPE)
      RETURN giac_pdc_premcolln_dtls_tab PIPELINED
   IS
   	  v_prem	giac_pdc_premcolln_dtls_type;
   BEGIN
      FOR gpdc_prem IN (SELECT a.pdc_id,    a.transaction_type, a.iss_cd,       a.prem_seq_no, 
                               a.inst_no,   a.collection_amt,   a.currency_cd,  a.currency_rt, 
                               a.fcurrency_amt, a.premium_amt,  a.tax_amt,      a.insert_tag, 
                               a.last_update, g.rv_meaning tran_type_desc,
                               rtrim(d.line_cd) || '-' || rtrim(d.subline_cd) || '-' || rtrim(d.iss_cd) || 
                               '-' || ltrim(to_char(d.issue_yy, '09')) || '-' || ltrim(to_char(d.pol_seq_no, '0999999')) || 
                               decode(d.endt_seq_no,0,NULL, '-' ||d.endt_iss_cd ||'-'||ltrim(to_char(d.endt_yy, '09'))||
	   						   '-' ||ltrim(to_char(d.endt_seq_no)) || '-' || rtrim(d.endt_type))||'-'||
	   						   ltrim(to_char(d.renew_no, '09')) policy_no, d.policy_id, f.assd_name, d.address1, d.address2, d.address3
                            FROM giac_pdc_prem_colln a
                                ,giac_aging_soa_details b
                                ,gipi_invoice c
                                ,gipi_polbasic d
                                ,gipi_parlist e
                                ,giis_assured f
                                ,cg_ref_codes g
						WHERE a.pdc_id = p_pdc_id
                          AND g.rv_domain = 'GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE'
                          AND g.rv_low_value = a.transaction_type
                          AND c.prem_seq_no = a.prem_seq_no
                          AND b.iss_cd = a.iss_cd
                          AND b.prem_seq_no = a.prem_seq_no
                          AND b.inst_no = a.inst_no
                          AND c.prem_seq_no = b.prem_seq_no
                          AND c.iss_cd = b.iss_cd
                          AND d.policy_id = b.policy_id
                          AND e.par_id = d.par_id  
                          AND f.assd_no = e.assd_no)
	  LOOP
	      v_prem.pdc_id  		   := gpdc_prem.pdc_id;
	  	  v_prem.transaction_type := gpdc_prem.transaction_type;
		  v_prem.iss_cd		   := gpdc_prem.iss_cd;
		  v_prem.prem_seq_no	   := gpdc_prem.prem_seq_no;
		  v_prem.inst_no		   := gpdc_prem.inst_no;
		  v_prem.collection_amt   := gpdc_prem.collection_amt;
		  v_prem.currency_cd	   := gpdc_prem.currency_cd;
		  v_prem.currency_rt	   := gpdc_prem.currency_rt;
		  v_prem.fcurrency_amt	   := gpdc_prem.fcurrency_amt;
		  v_prem.premium_amt	   := gpdc_prem.premium_amt;
		  v_prem.tax_amt		   := gpdc_prem.tax_amt;
		  v_prem.insert_tag	   := gpdc_prem.insert_tag;
		  v_prem.last_update	   := gpdc_prem.last_update;
          v_prem.tran_type_desc   := gpdc_prem.tran_type_desc;
          v_prem.policy_no         := gpdc_prem.policy_no;
          v_prem.assd_name         := gpdc_prem.assd_name;
          
   		  PIPE ROW (v_prem);
	  END LOOP;
	  RETURN;
   END get_pdc_prem_colln_listing;
   
   /*
    **  Created by		: Angelo Pagaduan
	**  Date Created 	: 02.04.2011  
	**  Reference By 	: (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: part of gpdc_prem.prem_seq_no when-validate-item program block
   */	
   
	PROCEDURE validate_prem_seq_no(
	    p_pdc_id		IN  GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_tran_type		IN	GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		p_iss_cd 		IN	GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no	IN	GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		v_inst_no		OUT GIPI_INSTALLMENT.inst_no%TYPE,
		v_inst_no_count	OUT NUMBER,
		v_tax_amt		OUT GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		v_premium_amt	OUT GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		v_colln_amt		OUT GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		v_assured_name	OUT GIIS_ASSURED.assd_name%TYPE,
		v_policy_no		OUT VARCHAR2,
		v_message		OUT VARCHAR2
	) 
	
	IS
	  v_count			NUMBER(4);
	  v_prem_i			VARCHAR2(100);
	  v_flag_i			GIPI_POLBASIC.pol_flag%TYPE;
	  v_balance			NUMBER;
	  v_tran_type  		GIAC_PDC_PREM_COLLN.transaction_type%TYPE;
	  v_iss_cd	  		GIAC_PDC_PREM_COLLN.iss_cd%TYPE;
	  v_prem_seq_no		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE;
	  v_installment_no	GIAC_PDC_PREM_COLLN.inst_no%TYPE;
	  v_pdc_id			GIAC_PDC_PREM_COLLN.pdc_id%TYPE;
	
	BEGIN
	  	 SELECT count(*)
		   INTO v_count
		   FROM GIPI_INSTALLMENT
		  WHERE iss_cd = p_iss_cd
		    AND prem_seq_no = p_prem_seq_no;

		 v_inst_no_count := v_count;
		 
		 IF (v_count = 1) THEN
		 	SELECT inst_no
			  INTO v_inst_no
			  FROM GIPI_INSTALLMENT
			 WHERE iss_cd = p_iss_cd
			   AND prem_seq_no = p_prem_seq_no;
		 ELSE
		    v_inst_no := 0;
	 	 END IF; -- get inst_no for given iss_cd and prem_seq_no; if inst_no > 1 return the number of inst_no
    	 
		 GIAC_PDC_PREM_COLLN_PKG.get_pdc_prem_colln_dtls(p_iss_cd, p_prem_seq_no, v_inst_no,
		 					v_premium_amt, v_tax_amt, v_colln_amt, v_assured_name, v_policy_no, v_balance);

		 FOR i IN (SELECT transaction_type, iss_cd, prem_seq_no, inst_no, pdc_id
		 	   	  	 FROM GIAC_PDC_PREM_COLLN
					WHERE transaction_type = p_tran_type
					  AND iss_cd = p_iss_cd
					  AND prem_seq_no = p_prem_seq_no
					  AND inst_no = v_inst_no
				  )	
		 LOOP
		 	 v_tran_type  		  := i.transaction_type;
			 v_iss_cd	  		  := i.iss_cd;
			 v_prem_seq_no		  := i.prem_seq_no;
			 v_installment_no	  := i.inst_no;
			 v_pdc_id			  := i.pdc_id;
			 
			 IF v_tran_type = p_tran_type AND v_iss_cd = v_iss_cd 
		        AND v_prem_seq_no = v_prem_seq_no AND v_inst_no = v_inst_no
				THEN
				  IF v_balance = 0 AND v_pdc_id <> p_pdc_id
				  THEN
				  	  v_inst_no := NULL;
					  v_message := 'Bill no. '|| p_iss_cd||'-'|| p_prem_seq_no||' is already settled.';
				  END IF;
			 END IF;
		 END LOOP;
									
    	 FOR c IN (SELECT a.iss_cd || '-' || a.prem_seq_no bill_no, b.pol_flag
		 	   	  	 FROM GIPI_INVOICE a,
					 	  GIPI_POLBASIC b
					WHERE a.policy_id = b.policy_id
					  AND a.prem_seq_no = p_prem_seq_no
					  AND a.iss_cd = p_iss_cd
		 	   	  )
		 LOOP
		 	 v_prem_i := c.bill_no;
			 v_flag_i := c.pol_flag;
			 
			 IF v_flag_i = '5' THEN
			 	v_inst_no := NULL;
				v_colln_amt := NULL;
			    v_message := 'This is a spoiled policy.';
			 ELSIF v_flag_i = '4' THEN
			 	v_message := 'This is a cancelled policy.';
			 END IF;
			 EXIT;
		 END LOOP;
		 
		 IF v_prem_i IS NULL THEN
		 	v_message := 'Bill no. does not exist in Gipi_invoice.';
		 END IF;
		 
		 IF v_message IS NULL THEN
		 	v_message := 'Valid';
		 END IF;

	END validate_prem_seq_no;
	
	PROCEDURE get_pdc_prem_colln_dtls(
	    p_iss_cd	  	IN	  	  GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no	IN	  	  GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no		IN OUT	  GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		v_prem_amt		OUT	      GIAC_PDC_PREM_COLLN.premium_amt%TYPE,  
		v_tax_amt		OUT	      GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		v_colln_amt		OUT	      GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		v_assd_name		OUT	      GIIS_ASSURED.assd_name%TYPE,
		v_policy_no		OUT	      VARCHAR2,
		v_bal_due		OUT		  NUMBER)
   	IS 
	   v_prem 				GIPI_INVOICE.prem_amt%TYPE;
	   v_tax				GIPI_INVOICE.tax_amt%TYPE;
	   v_total_amt			NUMBER(15, 2);
	   
	BEGIN
		 FOR b IN (SELECT prem_amt, tax_amt
		 	   	  	 FROM GIPI_INVOICE
					WHERE iss_cd = p_iss_cd
					  AND prem_seq_no = p_prem_seq_no
		 	   	  )
		 LOOP
		   v_prem := b.prem_amt;
		   v_tax := b.tax_amt;		
		   v_total_amt := v_prem + v_tax;
		 END LOOP;  
		 
		 FOR d IN (-- edited by d.alcantara, based on specs PCIC-7893
                    /*SELECT sum(nvl(collection_amt, 0)) colln_amt
		 	   	  	 FROM GIAC_PDC_PREM_COLLN
					WHERE iss_cd = p_iss_cd
					  AND prem_seq_no = p_prem_seq_no
					  AND inst_no = p_inst_no*/  
                      SELECT SUM(NVL(b.collection_amt, 0)) colln_amt
                        FROM giac_apdc_payt_dtl a, giac_pdc_prem_colln b
                       WHERE a.pdc_id = b.pdc_id
                         AND a.check_flag <> 'C'
                         AND b.iss_cd = p_iss_cd
                         AND b.prem_seq_no = p_prem_seq_no
		 	   	  )
		 LOOP
		 	 IF d.colln_amt IS NOT NULL THEN
			 	v_colln_amt := d.colln_amt;
			 ELSE
			 	v_colln_amt := 0;
			 END IF;
			 
			 v_bal_due := v_total_amt - v_colln_amt;
			 
			 IF v_bal_due <> 0 THEN
			 	v_colln_amt := v_bal_due;
			 END IF;
			 
			 v_prem_amt := v_prem;
			 v_tax_amt := v_tax;
			
		 END LOOP; -- gets colln_amt, premium_amt and tax_amt for given iss_cd and prem_seq_no
			 
		 FOR e IN (SELECT rtrim(c.line_cd) || '-' || rtrim(c.subline_cd) || '-' || rtrim(c.iss_cd) ||
		 	   	  		  	'-' || ltrim(to_char(c.issue_yy)) || '-' || ltrim(to_char(c.pol_seq_no)) ||
							decode(c.endt_seq_no, 0, NULL, '-' || c.endt_iss_cd || '-' || ltrim (to_char(c.endt_yy)) ||
							'-' || ltrim(to_char(c.endt_seq_no)) || '-' || rtrim(c.endt_type)) || '-' ||
							ltrim(to_char(c.renew_no)) policy_no, d.assd_name
					 FROM GIIS_ASSURED d, GIPI_PARLIST e, GIPI_POLBASIC c, GIPI_INVOICE b,
					      GIAC_AGING_SOA_DETAILS a
				    WHERE e.assd_no = d.assd_no
					  AND c.par_id = e.par_id
					  AND a.policy_id = c.policy_id
					  AND a.prem_seq_no = b.prem_seq_no
					  AND a.iss_cd = b.iss_cd
					  AND a.iss_cd = p_iss_cd
					  AND b.prem_seq_no = p_prem_seq_no
					  AND a.inst_no = p_inst_no
		 	   	  )
		 LOOP
		 	 v_assd_name := e.assd_name;
			 v_policy_no	:= e.policy_no;
		 END LOOP; -- gets assured name and policy no. for given iss_cd and prem_seq_no
	END get_pdc_prem_colln_dtls;
	
	PROCEDURE insert_pdc_prem_colln(
		p_pdc_id				 GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_transaction_type		 GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		p_iss_cd				 GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no			 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no				 GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		p_collection_amt		 GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		p_currency_cd			 GIAC_PDC_PREM_COLLN.currency_cd%TYPE,
		p_currency_rt			 GIAC_PDC_PREM_COLLN.currency_rt%TYPE,
		p_fcurrency_amt			 GIAC_PDC_PREM_COLLN.fcurrency_amt%TYPE,
		p_premium_amt			 GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		p_tax_amt				 GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		p_insert_tag			 GIAC_PDC_PREM_COLLN.insert_tag%TYPE
	)
	
	IS
	
	BEGIN
 	    INSERT 
		  INTO GIAC_PDC_PREM_COLLN(pdc_id, transaction_type, iss_cd, prem_seq_no, inst_no,
	          collection_amt, currency_cd, currency_rt, fcurrency_amt, user_id,
			  last_update, premium_amt, tax_amt, insert_tag)
	    VALUES (p_pdc_id, p_transaction_type, p_iss_cd, p_prem_seq_no, p_inst_no,
	          p_collection_amt, p_currency_cd, p_currency_rt, p_fcurrency_amt,
			  NVL(giis_users_pkg.app_user, USER), SYSDATE, p_premium_amt, p_tax_amt, p_insert_tag);
						 
	END insert_pdc_prem_colln;
	
	PROCEDURE update_pdc_prem_colln(
		p_pdc_id				 GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_transaction_type		 GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		p_iss_cd				 GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no			 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no				 GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		p_collection_amt		 GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		p_currency_cd			 GIAC_PDC_PREM_COLLN.currency_cd%TYPE,
		p_currency_rt			 GIAC_PDC_PREM_COLLN.currency_rt%TYPE,
		p_fcurrency_amt			 GIAC_PDC_PREM_COLLN.fcurrency_amt%TYPE,
		p_premium_amt			 GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		p_tax_amt				 GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		p_insert_tag			 GIAC_PDC_PREM_COLLN.insert_tag%TYPE,
		p_new_prem_seq_no		 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_new_transaction_type	 GIAC_PDC_PREM_COLLN.transaction_type%TYPE
	)
	
	IS
	
	BEGIN
		UPDATE GIAC_PDC_PREM_COLLN
		   SET prem_seq_no		  	= p_new_prem_seq_no,
		       transaction_type		= p_new_transaction_type,
  		 	   inst_no				= p_inst_no,
			   collection_amt		= p_collection_amt,
  			   currency_cd			= p_currency_cd,
			   currency_rt			= p_currency_rt,
			   fcurrency_amt		= p_fcurrency_amt,
			   user_id				= USER,
			   last_update			= SYSDATE,
			   premium_amt			= p_premium_amt,
			   tax_amt				= p_tax_amt,
			   insert_tag			= p_insert_tag
		 WHERE pdc_id 				= p_pdc_id
		   AND iss_cd				= p_iss_cd
		   AND prem_seq_no			= p_prem_seq_no
		   AND transaction_type		= p_transaction_type;
						 
	END update_pdc_prem_colln;
	
	/*
    **  Created by		: Angelo Pagaduan
	**  Date Created 	: 02.24.2011   
	**  Description 	: deletes record from pdc_prem_colln
   */	
	
	PROCEDURE delete_giac_pdc_prem_colln(
		 p_pdc_id			GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		 p_transaction_type GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		 p_iss_cd			GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		 p_prem_seq_no		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE
	)
	
	IS
	
	BEGIN
	
		 IF p_iss_cd IS NULL AND p_prem_seq_no IS NULL AND p_transaction_type IS NULL THEN
		 	DELETE
			  FROM giac_pdc_prem_colln
			 WHERE pdc_id = p_pdc_id;
		 ELSE
		 	DELETE
		      FROM giac_pdc_prem_colln
		     WHERE pdc_id = p_pdc_id
			   AND transaction_type = p_transaction_type
		       AND iss_cd = p_iss_cd
			   AND prem_seq_no = p_prem_seq_no;
		 END IF;
	
	END delete_giac_pdc_prem_colln;  
    
    
    /*
    **  Created by		: Andrew Robes
	**  Date Created 	: 11.29.2011
    **  Module Reference : (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: Procedure to delete pdc_prem_colln based on pdc_id, iss_cd and prem_seq_no
    */	    
	PROCEDURE del_giac_pdc_prem_colln(
		 p_pdc_id			GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		 p_iss_cd			GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		 p_prem_seq_no		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE
	)	
	IS	
	BEGIN
        DELETE
          FROM giac_pdc_prem_colln
         WHERE pdc_id = p_pdc_id
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no;	
	END del_giac_pdc_prem_colln;      
    
    /*
    **  Created by		: Andrew Robes
	**  Date Created 	: 11.17.2011
    **  Module Reference : (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: Inserts/updates giac_pdc_prem_colln records
    */	
    
    PROCEDURE set_giac_pdc_prem_colln(p_colln GIAC_PDC_PREM_COLLN%ROWTYPE)
    IS
    BEGIN
      MERGE INTO giac_pdc_prem_colln
      USING DUAL ON (pdc_id = p_colln.pdc_id
                 AND iss_cd = p_colln.iss_cd
                 AND prem_seq_no = p_colln.prem_seq_no
                 AND inst_no = p_colln.inst_no)
      WHEN NOT MATCHED THEN
        INSERT (pdc_id, transaction_type, iss_cd, prem_seq_no, inst_no,
	            collection_amt, currency_cd, currency_rt, fcurrency_amt, user_id,
			    last_update, premium_amt, tax_amt, insert_tag)
	    VALUES (p_colln.pdc_id, p_colln.transaction_type, p_colln.iss_cd, p_colln.prem_seq_no, p_colln.inst_no,
 	            p_colln.collection_amt, p_colln.currency_cd, p_colln.currency_rt, p_colln.fcurrency_amt,
			    NVL(giis_users_pkg.app_user, USER), SYSDATE, p_colln.premium_amt, p_colln.tax_amt, 'N')                
      WHEN MATCHED THEN
        UPDATE SET transaction_type		= p_colln.transaction_type,                   
                   collection_amt		= p_colln.collection_amt,
                   currency_cd			= p_colln.currency_cd,
                   currency_rt			= p_colln.currency_rt,
                   fcurrency_amt		= p_colln.fcurrency_amt,
                   user_id				= NVL(giis_users_pkg.app_user, USER),
                   last_update			= SYSDATE,
                   premium_amt			= p_colln.premium_amt,
                   tax_amt				= p_colln.tax_amt,
                   insert_tag			= p_colln.insert_tag;
    END set_giac_pdc_prem_colln; 
    
    /*
    **  Created by		: Andrew Robes
	**  Date Created 	: 11.23.2011
    **  Module Reference : (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: Procedure to retrieve the values needed when update button is pressed in the details portion of giacs090 module
    */	    
    PROCEDURE get_prem_colln_update_values(p_apdc_id      IN GIAC_APDC_PAYT.apdc_id%TYPE,
                                         p_pdc_id       IN GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
                                         p_iss_cd       IN GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
                                         p_prem_seq_no  IN GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
                                         p_update_flag  IN VARCHAR2, --benjo 10.25.2016 SR-5802
                                         p_payor        OUT VARCHAR2,
                                         p_address1     OUT GIPI_POLBASIC.address1%TYPE,
                                         p_address2     OUT GIPI_POLBASIC.address2%TYPE,
                                         p_address3     OUT GIPI_POLBASIC.address3%TYPE,
                                         p_intm_no      OUT GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
                                         p_intm_name    OUT GIIS_INTERMEDIARY.intm_name%TYPE,
                                         p_apdc_particulars OUT VARCHAR2,
                                         p_pdc_particulars  OUT VARCHAR2)
    IS
    	v_policy_id       GIPI_POLBASIC.policy_id%TYPE;
      	v_assd_name       GIAC_ORDER_OF_PAYTS.payor%TYPE;
      	v_assd_name2      GIAC_ORDER_OF_PAYTS.payor%TYPE;
    BEGIN
--        SELECT c.assd_name, b.address1, b.address2, b.address3, b.policy_id
--          INTO p_payor, p_address1, p_address2, p_address3, v_policy_id 
--          FROM gipi_invoice a
--              ,gipi_polbasic b
--              ,giis_assured c
--         WHERE a.prem_seq_no =  p_prem_seq_no
--           AND a.iss_cd = p_iss_cd
--           AND a.policy_id = b.policy_id
--           AND b.assd_no = c.assd_no;

        --replaced by john 6.7.2017
        FOR i IN (
              SELECT address1 add1, address2 add2, address3 add3, policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                FROM gipi_polbasic
               WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
                        (SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                                a.pol_seq_no, a.renew_no
                           FROM gipi_polbasic a
                          WHERE a.policy_id =
                                   (SELECT policy_id
                                      FROM gipi_invoice
                                     WHERE prem_seq_no = p_prem_seq_no
                                       AND iss_cd = p_iss_cd))
                 AND address1 IS NOT NULL
            ORDER BY endt_seq_no DESC
        )
        LOOP
            p_address1 := i.add1;
            p_address2 := i.add2;
            p_address3 := i.add3;
            v_policy_id := i.policy_id;
            
            p_payor := get_latest_assured_no2 (i.line_cd, i.subline_cd, i.iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no);
            

            FOR c IN (
                SELECT assd_name, assd_name2
                  FROM giis_assured
                 WHERE assd_no = p_payor
            )
            LOOP
                v_assd_name := c.assd_name;
                v_assd_name2 := c.assd_name2;

                IF v_assd_name2 IS NOT NULL THEN
                    p_payor := v_assd_name || v_assd_name2;
                ELSE
                    p_payor := v_assd_name;
                END IF;
            END LOOP;
        END LOOP;
        
           
        GIPI_COMM_INVOICE_PKG.GET_COMM_INVOICE_INTM(v_policy_id, p_intm_no, p_intm_name);
        
        /* benjo 10.25.2016 SR-5802 */
        IF NVL (p_update_flag, 'A') = 'I'
        THEN
          BEGIN
             SELECT intm_name, mail_addr1, mail_addr2, mail_addr3
               INTO p_payor, p_address1, p_address2, p_address3
               FROM giis_intermediary
              WHERE intm_no = p_intm_no;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
          END;
        END IF;
        /* end SR-5802 */
        
        p_apdc_particulars := giac_pdc_prem_colln_pkg.get_particulars_from_pdc_prem(p_apdc_id, null);
        p_pdc_particulars := giac_pdc_prem_colln_pkg.get_particulars_from_pdc_prem(p_apdc_id, p_pdc_id);
    END get_prem_colln_update_values;                                        
    
    
    /*
    **  Created by		: Andrew Robes
	**  Date Created 	: 11.24.2011
    **  Module Reference : (GIACS090 - Acknowledgment Receipt)   
	**  Description 	: Function to retrieve the particulars text needed when update button is pressed in the details portion of giacs090 module.
    **                    Returns particulars text containing the policy nos of a given apdc_id and pdc_id. 
    **                    Returns particulars text containing all policy nos of a given apdc_id when pdc_id is null    
    */	    
    FUNCTION get_particulars_from_pdc_prem(p_apdc_id IN GIAC_APDC_PAYT.apdc_id%TYPE,
                                           p_pdc_id  IN GIAC_APDC_PAYT_DTL.pdc_id%TYPE)
      RETURN VARCHAR2
    IS
      v_particulars VARCHAR2(2000);
      v_particulars_text VARCHAR2(200);
    BEGIN
      FOR i IN (
        SELECT    RTRIM (a.line_cd)
               || '-'
               || RTRIM (a.subline_cd)
               || '-'
               || RTRIM (a.iss_cd)
               || '-'
               || LTRIM (TO_CHAR (a.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
               || DECODE (a.endt_seq_no,
                          0, NULL,
                             '-'
                          || a.endt_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.endt_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                          || '-'
                          || RTRIM (a.endt_type)
                         )
               || '-'
               || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
               b.iss_cd || '-' || TO_CHAR(b.prem_seq_no,'fm099999999999') bill_no
          FROM gipi_polbasic a,
               gipi_invoice b,
               giac_apdc_payt c,
               giac_apdc_payt_dtl d,
               giac_pdc_prem_colln e
         WHERE c.apdc_id = p_apdc_id
           AND e.pdc_id = NVL(p_pdc_id, e.pdc_id)
           AND a.policy_id = b.policy_id
           AND b.prem_seq_no = e.prem_seq_no
           AND b.iss_cd = e.iss_cd
           AND c.apdc_id = d.apdc_id
           AND d.pdc_id = e.pdc_id)
      LOOP
        IF v_particulars IS NOT NULL THEN
          v_particulars := v_particulars || '/';
        END IF;
        
        --added to handle PREM_COLLN_PARTICULARS :: john dolon 6.7.2016
        IF NVL(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' THEN          
            v_particulars := v_particulars ||i.policy_no || '/' || i.bill_no;
        ELSIF NVL(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PN' THEN
            v_particulars := v_particulars ||i.policy_no;
        END IF;
        --v_particulars := v_particulars || i.policy_no;
      END LOOP;
      
      v_particulars_text := GIACP.V('OR_PARTICULARS_TEXT'); 
      
      IF v_particulars_text IS NOT NULL THEN        
	    v_particulars := v_particulars_text || ' ' || v_particulars;
	  END IF;
      
      RETURN v_particulars;
    END;
    
    /* benjo 11.08.2016 SR-5802 */
    FUNCTION get_ref_pol_no (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE;
   BEGIN
      FOR ref_pol_no IN (SELECT ref_pol_no
                           FROM gipi_polbasic
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no)
      LOOP
         v_ref_pol_no := ref_pol_no.ref_pol_no;
         EXIT;
      END LOOP;

      RETURN v_ref_pol_no;
   END;

   /* benjo 11.08.2016 SR-5802 */
   FUNCTION validate_policy (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_count     NUMBER         := 0;
      v_count2    NUMBER         := 0;
      v_message   VARCHAR2 (100) := 'SUCCESS';
   BEGIN
      FOR rec IN (SELECT 1
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no)
      LOOP
         v_count := v_count + 1;

         FOR rec2 IN (SELECT 1
                        FROM gipi_polbasic a,
                             gipi_invoice b,
                             giac_aging_soa_details c,
                             gipi_installment d
                       WHERE a.line_cd = p_line_cd
                         AND a.subline_cd = p_subline_cd
                         AND a.iss_cd = p_iss_cd
                         AND a.issue_yy = p_issue_yy
                         AND a.pol_seq_no = p_pol_seq_no
                         AND a.renew_no = p_renew_no
                         AND a.policy_id = b.policy_id
                         AND b.iss_cd = c.iss_cd
                         AND b.prem_seq_no = c.prem_seq_no
                         AND c.iss_cd = d.iss_cd
                         AND c.prem_seq_no = d.prem_seq_no
                         AND c.inst_no = d.inst_no
                         AND d.due_date <=
                                DECODE (p_check_due,
                                        'N', SYSDATE,
                                        d.due_date
                                       )
                         AND ABS (c.balance_amt_due) > 0)
         LOOP
            v_count2 := v_count2 + 1;
            EXIT;
         END LOOP;
      END LOOP;

      IF v_count = 0
      THEN
         FOR rec IN (SELECT 1
                       FROM gipi_pack_polbasic
                      WHERE line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                        AND iss_cd = p_iss_cd
                        AND issue_yy = p_issue_yy
                        AND pol_seq_no = p_pol_seq_no
                        AND renew_no = p_renew_no)
         LOOP
            v_count := v_count + 1;
            v_message := '3';

            FOR rec2 IN
               (SELECT 1
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giac_aging_soa_details c,
                       gipi_installment d
                 WHERE a.pack_policy_id IN (
                          SELECT pack_policy_id
                            FROM gipi_pack_polbasic
                           WHERE line_cd = p_line_cd
                             AND subline_cd = p_subline_cd
                             AND iss_cd = p_iss_cd
                             AND issue_yy = p_issue_yy
                             AND pol_seq_no = p_pol_seq_no
                             AND renew_no = p_renew_no)
                   AND a.policy_id = b.policy_id
                   AND b.iss_cd = c.iss_cd
                   AND b.prem_seq_no = c.prem_seq_no
                   AND c.iss_cd = d.iss_cd
                   AND c.prem_seq_no = d.prem_seq_no
                   AND c.inst_no = d.inst_no
                   AND d.due_date <=
                                DECODE (p_check_due,
                                        'N', SYSDATE,
                                        d.due_date
                                       )
                   AND ABS (c.balance_amt_due) > 0)
            LOOP
               v_count2 := v_count2 + 1;
               EXIT;
            END LOOP;
         END LOOP;
      END IF;

      IF v_count2 = 0
      THEN
         v_message := '2';
      END IF;

      IF v_count = 0
      THEN
         v_message := '1';
      END IF;

      RETURN v_message;
   END;

   /* benjo 11.08.2016 SR-5802 */
   FUNCTION get_policy_invoices (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN policy_invoices_tab PIPELINED
   IS
      v_rec            policy_invoices_type;
      v_rv_low_value   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT a.line_cd, a.subline_cd, d.iss_cd, d.prem_seq_no, d.inst_no, b.currency_cd,
                       b.currency_rt, c.balance_amt_due, c.prem_balance_due,
                       c.tax_balance_due, e.assd_name,
                          RTRIM (a.line_cd)
                       || '-'
                       || RTRIM (a.subline_cd)
                       || '-'
                       || RTRIM (a.iss_cd)
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                       || DECODE (a.endt_seq_no,
                                  0, NULL,
                                     '-'
                                  || a.endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                  || '-'
                                  || RTRIM (a.endt_type)
                                 )
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giac_aging_soa_details c,
                       gipi_installment d,
                       giis_assured e
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.policy_id = b.policy_id
                   AND b.iss_cd = c.iss_cd
                   AND b.prem_seq_no = c.prem_seq_no
                   AND c.iss_cd = d.iss_cd
                   AND c.prem_seq_no = d.prem_seq_no
                   AND c.inst_no = d.inst_no
                   AND c.a020_assd_no = e.assd_no
                   AND d.due_date <=
                                DECODE (p_check_due,
                                        'N', SYSDATE,
                                        d.due_date
                                       )
                   AND ABS (c.balance_amt_due) > 0)
      LOOP
         IF i.balance_amt_due > 0
         THEN
            v_rv_low_value := '1';
         ELSE
            v_rv_low_value := '3';
         END IF;

         v_rec.tran_type := v_rv_low_value;

         SELECT rv_meaning
           INTO v_rec.tran_type_desc
           FROM cg_ref_codes
          WHERE rv_low_value = v_rv_low_value
            AND rv_domain = 'GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE';

         SELECT currency_desc
           INTO v_rec.currency_desc
           FROM giis_currency
          WHERE main_currency_cd = i.currency_cd;

         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.inst_no := i.inst_no;
         v_rec.balance_amt_due := NVL (i.balance_amt_due, 0);
         v_rec.f_balance_amt_due :=
              NVL (i.balance_amt_due, 0)
            / NVL (i.currency_rt, giacp.n ('CURRENCY_CD'));
         v_rec.prem_balance_due := NVL (i.prem_balance_due, 0);
         v_rec.tax_balance_due := NVL (i.tax_balance_due, 0);
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_rt := i.currency_rt;
         v_rec.assd_name := i.assd_name;
         v_rec.policy_no := i.policy_no;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   /* benjo 11.08.2016 SR-5802 */
   FUNCTION get_pack_invoices_tg (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN policy_invoices_tab PIPELINED
   IS
      v_rec            policy_invoices_type;
      v_rv_low_value   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT a.line_cd, a.subline_cd, d.iss_cd, d.prem_seq_no, d.inst_no, b.currency_cd,
                       b.currency_rt, c.balance_amt_due, c.prem_balance_due,
                       c.tax_balance_due, e.assd_name,
                          RTRIM (a.line_cd)
                       || '-'
                       || RTRIM (a.subline_cd)
                       || '-'
                       || RTRIM (a.iss_cd)
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                       || DECODE (a.endt_seq_no,
                                  0, NULL,
                                     '-'
                                  || a.endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                  || '-'
                                  || RTRIM (a.endt_type)
                                 )
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giac_aging_soa_details c,
                       gipi_installment d,
                       giis_assured e
                 WHERE a.pack_policy_id IN (
                          SELECT pack_policy_id
                            FROM gipi_pack_polbasic
                           WHERE line_cd = p_line_cd
                             AND subline_cd = p_subline_cd
                             AND iss_cd = p_iss_cd
                             AND issue_yy = p_issue_yy
                             AND pol_seq_no = p_pol_seq_no
                             AND renew_no = p_renew_no)
                   AND a.policy_id = b.policy_id
                   AND b.iss_cd = c.iss_cd
                   AND b.prem_seq_no = c.prem_seq_no
                   AND c.iss_cd = d.iss_cd
                   AND c.prem_seq_no = d.prem_seq_no
                   AND c.inst_no = d.inst_no
                   AND c.a020_assd_no = e.assd_no
                   AND d.due_date <=
                                DECODE (p_check_due,
                                        'N', SYSDATE,
                                        d.due_date
                                       )
                   AND ABS (c.balance_amt_due) > 0)
      LOOP
         IF i.balance_amt_due > 0
         THEN
            v_rv_low_value := '1';
         ELSE
            v_rv_low_value := '3';
         END IF;

         v_rec.tran_type := v_rv_low_value;

         SELECT rv_meaning
           INTO v_rec.tran_type_desc
           FROM cg_ref_codes
          WHERE rv_low_value = v_rv_low_value
            AND rv_domain = 'GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE';

         SELECT currency_desc
           INTO v_rec.currency_desc
           FROM giis_currency
          WHERE main_currency_cd = i.currency_cd;
         
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.inst_no := i.inst_no;
         v_rec.balance_amt_due := NVL (i.balance_amt_due, 0);
         v_rec.f_balance_amt_due :=
              NVL (i.balance_amt_due, 0)
            / NVL (i.currency_rt, giacp.n ('CURRENCY_CD'));
         v_rec.prem_balance_due := NVL (i.prem_balance_due, 0);
         v_rec.tax_balance_due := NVL (i.tax_balance_due, 0);
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_rt := i.currency_rt;
         v_rec.assd_name := i.assd_name;
         v_rec.policy_no := i.policy_no;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END giac_pdc_prem_colln_pkg;
/
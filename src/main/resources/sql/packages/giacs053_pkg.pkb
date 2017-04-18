CREATE OR REPLACE PACKAGE BODY CPI.GIACS053_PKG
AS

    PROCEDURE populate_batch_or_temp_table(
        p_fund_cd            GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd          GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_called_by_upload   VARCHAR2,
        p_upload_query       VARCHAR2
    )
    IS
    BEGIN
        DELETE FROM GIAC_ORDER_OF_PAYTS_TEMP;
        
        INSERT INTO GIAC_ORDER_OF_PAYTS_TEMP
         VALUE (SELECT a.*, NULL, NULL, NULL
                  FROM TABLE(GIAC_ORDER_OF_PAYTS_PKG.get_batch_or_list(p_fund_cd, p_branch_cd, p_called_by_upload, p_upload_query)) a);
                  
        COMMIT;
    END;
    
    FUNCTION get_batch_or_list(
        p_or_date                   VARCHAR2,
        p_payor                     VARCHAR2,
        p_or_type                   VARCHAR2
    )
      RETURN batch_or_tab PIPELINED
    IS
        v_row                       batch_or_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE UPPER(payor) LIKE UPPER(NVL(p_payor, payor))
                    AND TO_CHAR(TRUNC(or_date), 'mm-dd-yyyy') = NVL(p_or_date, TO_CHAR(TRUNC(or_date), 'mm-dd-yyyy'))
                    AND NVL(or_type, 'X') = NVL(p_or_type, NVL(or_type, 'X'))
                  ORDER BY or_date, payor)
        LOOP
            v_row.gacc_tran_id := i.gacc_tran_id;
            v_row.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
            v_row.gibr_branch_cd := i.gibr_branch_cd;
            v_row.or_flag := i.or_flag;
            v_row.or_pref_suf := i.or_pref_suf;
            v_row.or_no := i.or_no;
            v_row.or_date := i.or_date;
            v_row.dsp_or_pref := i.dsp_or_pref;
            v_row.dsp_or_no := i.dsp_or_no;
            v_row.payor := i.payor;
            v_row.particulars := i.particulars;
            v_row.dsp_or_date := TO_CHAR(v_row.or_date, 'mm-dd-yyyy');
            v_row.generate_flag := i.generate_flag;
            v_row.printed_flag := i.printed_flag;
            v_row.nbt_repl_or_tag := 'N';
            
            FOR rec IN (SELECT 'X'
	                      FROM GIAC_OR_REL
	                     WHERE tran_id = i.gacc_tran_id) 
	        LOOP
	            v_row.nbt_repl_or_tag := 'Y';
                EXIT;
	        END LOOP;
            
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    PROCEDURE tag_all_ors(
        p_or_date           IN      VARCHAR2,
        p_payor             IN      VARCHAR2,
        p_message1          OUT     VARCHAR2,
        p_message2          OUT     VARCHAR2,
        p_message3          OUT     VARCHAR2
    )
    IS
        v_check_or                  VARCHAR2(1);
        v_message1                  VARCHAR2(500);
        v_message2                  VARCHAR2(500);
        v_message3                  VARCHAR2(500);
    BEGIN
        FOR i IN(SELECT gacc_tran_id
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE TO_CHAR(TRUNC(or_date), 'mm-dd-yyyy') = NVL(p_or_date, TO_CHAR(TRUNC(or_date), 'mm-dd-yyyy'))
                    AND UPPER(payor) LIKE UPPER(NVL(p_payor, payor))
                  ORDER BY or_date, payor)
        LOOP
            v_check_or := GIACS053_PKG.check_or(i.gacc_tran_id);
        
            UPDATE GIAC_ORDER_OF_PAYTS_TEMP
               SET generate_flag = 'Y'
             WHERE gacc_tran_id = i.gacc_tran_id
               AND v_check_or = 'Y';
             
            IF v_check_or = 'O' THEN
                p_message1 := 'Some records were not tagged because the O.R. collection amount is not equal to O.R. preview amount.'; 
            ELSIF v_check_or = 'A' THEN
                p_message2 := 'Some records were not tagged because the debit and credit amounts are not equal.';
            ELSIF v_check_or = 'T' THEN
                p_message3 := 'Some records were not tagged because they are either deleted/posted transactions.';
            END IF;
        END LOOP;
    END;
    
    PROCEDURE untag_all_ors
    IS
    BEGIN
        UPDATE GIAC_ORDER_OF_PAYTS_TEMP
           SET generate_flag = 'N',
               dsp_or_pref = NULL,
               dsp_or_no = NULL,
               or_type = NULL;
    END;
    
    FUNCTION check_or(
        p_gacc_tran_id      GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2
    IS
        v_or_amt            GIAC_ORDER_OF_PAYTS.gross_amt%TYPE := 0;
        v_op_text_amt       GIAC_OP_TEXT.item_amt%TYPE := 0;
        v_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0;
        v_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE := 0;
    BEGIN
        FOR rec1 IN(SELECT gross_tag,
                           NVL(DECODE(gross_tag, 'Y', gross_amt, 'N', collection_amt, gross_amt), 0) or_amount    
                      FROM GIAC_ORDER_OF_PAYTS
                     WHERE gacc_tran_id = p_gacc_tran_id)
	    LOOP
		    v_or_amt := rec1.or_amount;
        END LOOP;
        
        FOR rec2 IN(SELECT gacc_tran_id, SUM(item_amt) op_amt
                      FROM GIAC_OP_TEXT
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND NVL(or_print_tag,'Y') = 'Y' 
                     GROUP BY gacc_tran_id)
        LOOP
		    v_op_text_amt := rec2.op_amt;
	    END LOOP;
        
        IF v_or_amt = 0 THEN
            RETURN 'O';
	    ELSIF v_op_text_amt = 0 THEN
            RETURN 'O';
        ELSIF v_or_amt <> v_op_text_amt THEN
            RETURN 'O';
	    END IF;
        
        FOR rec3 IN(SELECT gacc_tran_id, SUM(NVL(debit_amt,0)) debit_amt, SUM(NVL(credit_amt,0)) credit_amt
			          FROM GIAC_ACCT_ENTRIES
		             WHERE gacc_tran_id = p_gacc_tran_id
		             GROUP BY gacc_tran_id)
	    LOOP
            v_debit_amt := rec3.debit_amt;
            v_credit_amt := rec3.credit_amt;
	    END LOOP;
        
        IF v_debit_amt = 0 AND v_credit_amt = 0 THEN
            RETURN 'A';
	    ELSIF v_debit_amt <> v_credit_amt THEN
            RETURN 'A';
	    END IF;
        
        FOR rec4 IN(SELECT tran_flag
	                  FROM GIAC_ACCTRANS
	                 WHERE tran_id = p_gacc_tran_id)
        LOOP
            IF rec4.tran_flag = 'P' THEN 
				RETURN 'T';
			ELSIF rec4.tran_flag = 'D' THEN
				RETURN 'T';
			END IF;
        END LOOP;
        
        RETURN 'Y';
    END;
    
    PROCEDURE validate_or(
        p_fund_cd           GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd         GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_pref           GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no             GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_or_type           GIAC_OR_PREF.or_type%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE
    )
    IS
        CURSOR giop IS
        SELECT or_pref_suf, or_no
          FROM GIAC_ORDER_OF_PAYTS
         WHERE or_no = p_or_no
           AND NVL(or_pref_suf,'-') = NVL(p_or_pref, NVL(or_pref_suf,'-'))
           AND gibr_branch_cd = p_branch_cd
           AND gibr_gfun_fund_cd = p_fund_cd;
           
        CURSOR giso IS
        SELECT '1'
          FROM GIAC_SPOILED_OR
         WHERE or_no = p_or_no
           AND NVL(or_pref,'-') = NVL(p_or_pref, NVL(or_pref,'-'))
           AND fund_cd = p_fund_cd
           AND branch_cd = p_branch_cd;
           
        v_or_pref           GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE;
        v_or_no             GIAC_DOC_SEQUENCE.doc_seq_no%TYPE;
        v_rv_meaning	    VARCHAR2(15);
        v_parm              GIAC_PARAMETERS.param_value_v%TYPE;
        v_user_cd           GIAC_DCB_USERS.cashier_cd%TYPE;
        v_min		 		GIAC_DOC_SEQUENCE_USER.min_seq_no%TYPE;
	    v_max		 		GIAC_DOC_SEQUENCE_USER.max_seq_no%TYPE;
        v_flag              VARCHAR2(1);
        v_exists            VARCHAR2(1);
    BEGIN
        OPEN giop;
        FETCH giop INTO v_or_pref, v_or_no;
       
        IF giop%FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This O.R. Number already exists.');
        ELSE
            BEGIN
                IF p_or_type = 'V' THEN
                    v_rv_meaning := 'VAT';
				ELSIF p_or_type = 'N' THEN
					v_rv_meaning := 'NON VAT';
				ELSE  
					v_rv_meaning := 'MISCELLANEOUS';
				END IF;
                
                FOR p IN (SELECT or_pref_suf
                            FROM GIAC_OR_PREF
                           WHERE branch_cd = p_branch_cd
                             AND or_type IN (SELECT rv_low_value
                                               FROM CG_REF_CODES
                                              WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                                AND UPPER(rv_meaning) = v_rv_meaning))
                LOOP
                    v_or_pref := p.or_pref_suf;
					EXIT;
                END LOOP;
                
                BEGIN 
                    SELECT cashier_cd
                      INTO v_user_cd
                      FROM GIAC_DCB_USERS
                     WHERE gibr_branch_cd = p_branch_cd
                       AND dcb_user_id = p_user_id;
                EXCEPTION
  		            WHEN NO_DATA_FOUND then
						v_user_cd := NULL;
						RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are not allowed to print an OR for this branch.');  		  
				END;
                
                BEGIN
	  	  	        SELECT param_value_v
	  	    	      INTO v_parm
	  	    	      FROM GIAC_PARAMETERS
	  	             WHERE param_name = 'OR_SEQ_PER_USER';
                EXCEPTION
	  			    WHEN NO_DATA_FOUND THEN
	  		  	        v_parm := 'N';
	  		    END;
                
                IF v_parm = 'Y' THEN
  	                BEGIN
  		                SELECT min_seq_no, max_seq_no
                          INTO v_min, v_max
                          FROM GIAC_DOC_SEQUENCE_USER
                         WHERE doc_code = 'OR'
                           AND branch_cd = p_branch_cd
                           AND user_cd = v_user_cd
                           AND doc_pref = v_or_pref
                           AND active_tag = 'Y';
  		    
                        v_flag := 'Y';
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							v_min := 1;
							v_max := 1;
							v_flag := 'N';
							RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No range of O.R. Number found for '||v_rv_meaning||' OR.');
  		            END;
                END IF;
                    
                IF p_or_no > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||v_rv_meaning||
                                                    ' O.R. number generated exceeds maximum sequence number for the booklet.');
                ELSE
                    OPEN giso;
                    FETCH giso INTO v_exists;
                        
                    IF giso%FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#An O.R. number generated is already spoiled.');
                    END IF;
                    CLOSE giso;
                END IF;
    		END;
        END IF;
        CLOSE giop;
    END;
    
    PROCEDURE save_generate_tag(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_generate_flag             VARCHAR2
    )
    IS
    BEGIN
        UPDATE GIAC_ORDER_OF_PAYTS_TEMP
           SET generate_flag = p_generate_flag
         WHERE gacc_tran_id = p_gacc_tran_id;
    END;
    
    PROCEDURE generate_or_numbers(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_one_or_seq                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_nonvat                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_pref                  GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,                
        p_vat_seq                   GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_non_vat_pref              GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_non_vat_seq               GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_other_pref                GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_other_seq                 GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
        v_or_type                   VARCHAR2(1);
        v_vat_seq                   GIAC_ORDER_OF_PAYTS.or_no%TYPE := p_vat_seq;
        v_non_vat_seq               GIAC_ORDER_OF_PAYTS.or_no%TYPE := p_non_vat_seq;
        v_other_seq                 GIAC_ORDER_OF_PAYTS.or_no%TYPE := p_other_seq;
        v_dsp_or_pref               GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE;
        v_dsp_or_no                 GIAC_ORDER_OF_PAYTS.or_no%TYPE;
    BEGIN
        FOR i IN(SELECT gacc_tran_id
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE generate_flag = 'Y'
                    AND NVL(printed_flag, 'N') <> 'Y'
                  ORDER BY or_date, payor)
        LOOP
            v_or_type := GIACS053_PKG.determine_or_type(p_fund_cd, i.gacc_tran_id, p_one_or_seq, p_vat_nonvat);
            
            IF v_or_type = 'V' THEN
                v_dsp_or_pref := p_vat_pref;
                v_dsp_or_no := v_vat_seq;
                v_vat_seq := v_vat_seq + 1;
            ELSIF v_or_type = 'N' THEN
                v_dsp_or_pref := p_non_vat_pref;
                v_dsp_or_no := v_non_vat_seq;
                v_non_vat_seq := v_non_vat_seq + 1;
            ELSIF v_or_type = 'M' THEN
                v_dsp_or_pref := p_other_pref;
                v_dsp_or_no := v_other_seq;
                v_other_seq := v_other_seq + 1;
            END IF;
            
            GIACS053_PKG.validate_or(p_fund_cd, p_branch_cd, v_dsp_or_pref, v_dsp_or_no, v_or_type, p_user_id);
            
            UPDATE GIAC_ORDER_OF_PAYTS_TEMP
               SET dsp_or_pref = v_dsp_or_pref,
                   dsp_or_no = v_dsp_or_no,
                   or_type = v_or_type
             WHERE gacc_tran_id = i.gacc_tran_id;
        END LOOP;
    END;

    FUNCTION determine_or_type(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_one_or_seq                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_nonvat                GIAC_PARAMETERS.param_value_v%TYPE
    )
      RETURN VARCHAR2
    IS
        v_or_type               GIAC_OR_PREF.or_type%TYPE;
    BEGIN
        IF p_one_or_seq = 'Y' THEN
            v_or_type := p_vat_nonvat;
        ELSE
            IF UPPER(NVL(GIACP.v('ISSUE_NONVAT_OAR'), 'N')) = 'Y' THEN
                IF GIACS053_PKG.check_premium_income_related(p_gacc_tran_id) THEN
                    v_or_type := 'V';
                ELSE
                    v_or_type := 'N';
                END IF;
            ELSE
                v_or_type := GIACS053_PKG.check_vat_nvat(p_fund_cd, p_gacc_tran_id);
            END IF;
        END IF;
        
        RETURN v_or_type;
    END;
    
    FUNCTION check_premium_income_related(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN BOOLEAN
    IS
    BEGIN
        FOR rec1 IN (SELECT 1
	                   FROM GIAC_DIRECT_PREM_COLLNS 
	                  WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
  	        RETURN TRUE;
        END LOOP;
        
        FOR rec1 IN (SELECT 1
	                   FROM GIAC_INWFACUL_PREM_COLLNS
	                  WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
  	        RETURN TRUE;
        END LOOP;
        
        FOR rec1 IN (SELECT 1
                       FROM GIAC_ACCT_ENTRIES
					  WHERE gacc_tran_id = p_gacc_tran_id
				        AND gl_acct_id = giacp.n('OUTPUT_VAT_DIRECT_GL'))
        LOOP
  	        RETURN TRUE;
        END LOOP;
        
        RETURN FALSE;
    END;
    
    FUNCTION check_vat_nvat(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,                 
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2
    IS
        v_exist 		            NUMBER;
	    v_tax_exist                 NUMBER;
	    v_tax_cd 		            GIAC_TAXES.tax_cd%TYPE;
    BEGIN
        FOR rec IN (SELECT 1 exist_1 
                      FROM GIAC_DIRECT_PREM_COLLNS
                     WHERE gacc_tran_id = p_gacc_tran_id
                     UNION									  	
                    SELECT 1 exist_1 
                      FROM GIAC_INWFACUL_PREM_COLLNS
                     WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
  	        v_exist := rec.exist_1;
  	        EXIT;
        END LOOP;
        
        IF v_exist IS NOT NULL THEN
            FOR tax_cd IN (SELECT param_value_n tax
                             FROM GIAC_PARAMETERS
                            WHERE param_name = 'EVAT')
            LOOP
                v_tax_cd := tax_cd.tax;
                EXIT;
            END LOOP;
            
            FOR tax IN (SELECT 1 tax
                          FROM GIAC_DIRECT_PREM_COLLNS a,
                               GIPI_INV_TAX b,
                               GIAC_TAXES c
                         WHERE a.b140_iss_cd = b.iss_cd 
                           AND a.b140_prem_seq_no = b.prem_seq_no  
                           AND b.tax_cd  = c.tax_cd
                           AND c.fund_cd = p_fund_cd                   
   			  			   AND a.gacc_tran_id = p_gacc_tran_id
                           AND c.tax_cd = v_tax_cd
                         UNION
                        SELECT 1 tax
                          FROM GIAC_INWFACUL_PREM_COLLNS a,
                               GIPI_INV_TAX b,
                               GIAC_TAXES c
                         WHERE a.b140_iss_cd = b.iss_cd 
                           AND a.b140_prem_seq_no = b.prem_seq_no  
                           AND b.tax_cd  = c.tax_cd
                           AND c.fund_cd = p_fund_cd
                           AND a.gacc_tran_id = p_gacc_tran_id
                           AND c.tax_cd = v_tax_cd)     
            LOOP
                v_tax_exist := tax.tax;
                EXIT;	
            END LOOP;
            
            IF v_tax_exist IS NOT NULL THEN
  	            RETURN('V');
            ELSE	        
    	        RETURN('N');
            END IF;
        ELSE
		    RETURN('N');
        END IF;
    END;
    
    FUNCTION get_batch_or_report_list(
        p_or_type                   VARCHAR2
    )
      RETURN batch_or_report_tab PIPELINED
    IS
        v_row                   batch_or_report_type;
    BEGIN
        FOR i IN(SELECT gacc_tran_id, dsp_or_pref, dsp_or_no
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE dsp_or_no IS NOT NULL
                    AND dsp_or_pref IS NOT NULL
                    AND generate_flag = 'Y'
                    AND NVL(printed_flag, 'N') <> 'Y'
                    AND NVL(or_type, '-') = p_or_type
                  ORDER BY or_date, payor)
        LOOP
            v_row.gacc_tran_id := i.gacc_tran_id;
            v_row.or_pref := i.dsp_or_pref;
            v_row.or_no := i.dsp_or_no;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    PROCEDURE process_printed_or(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE,
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
        v_or_pref                   GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE;
        v_or_no                     GIAC_ORDER_OF_PAYTS.or_no%TYPE;
        v_doc_name                  GIAC_DOC_SEQUENCE.doc_name%TYPE;
    BEGIN
        FOR i IN(SELECT gacc_tran_id, dsp_or_pref, dsp_or_no, or_flag, nbt_repl_or_tag
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE generate_flag = 'Y'
                    AND or_type = p_or_type
                    AND dsp_or_pref IS NOT NULL
                    AND dsp_or_no IS NOT NULL
                  ORDER BY or_date, payor)
        LOOP
            IF i.or_flag = 'N' AND i.dsp_or_no <= NVL(p_last_or_no, i.dsp_or_no) THEN
                
                GIACS053_PKG.ins_upd_giop(i.gacc_tran_id, i.dsp_or_pref, i.dsp_or_no, p_user_id);
                
				IF i.nbt_repl_or_tag = 'Y' THEN
				    BEGIN
                        UPDATE GIAC_OR_REL
                           SET new_or_pref_suf = i.dsp_or_pref,
                               new_or_no = i.dsp_or_no,
                               user_id = p_user_id,
                               last_update = SYSDATE
                         WHERE tran_id = i.gacc_tran_id;
                    END;
				END IF;
                					
				BEGIN
                    UPDATE GIAC_ORDER_OF_PAYTS_TEMP
                       SET or_flag = 'P',
                           printed_flag = 'Y'
                     WHERE gacc_tran_id = i.gacc_tran_id;
                END;
                
				IF NVL(GIACP.v('UPLOAD_IMPLEMENTATION_SW'), 'N') = 'Y' THEN
					EXEC_IMMEDIATE('BEGIN upload_dpc.upd_guf('||i.gacc_tran_id||'); END;');
				END IF;
                
                BEGIN
                    UPDATE GIAC_ACCTRANS
                       SET tran_flag = 'C'
                     WHERE tran_id = i.gacc_tran_id
                       AND tran_flag = 'O';
                END;
                
                v_or_pref := i.dsp_or_pref;
                v_or_no := i.dsp_or_no;
            END IF;
        END LOOP;
        
        IF p_or_type = 'V' THEN
            v_doc_name := 'VAT OR';
        ELSIF p_or_type = 'N' THEN
            v_doc_name := 'NON VAT OR';
        ELSIF p_or_type = 'M' THEN
            v_doc_name := 'MISC_OR';
        END IF;
        
        IF v_or_no IS NOT NULL THEN
            GIACS053_PKG.ins_upd_or(p_fund_cd, p_branch_cd, v_or_pref, v_or_no, v_doc_name, p_user_id);
        END IF;
    END;
    
    PROCEDURE ins_upd_giop(
        p_gacc_tran_id	            GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref  			        GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no    			        GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
        CURSOR giop IS
        SELECT or_no, NVL(with_pdc,'N'), NVL(or_flag, 'N')
          FROM GIAC_ORDER_OF_PAYTS
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        v_or_no                     GIAC_DOC_SEQUENCE.doc_seq_no%TYPE;
        v_with_pdc                  GIAC_ORDER_OF_PAYTS.with_pdc%TYPE;
        v_or_flag		            GIAC_ORDER_OF_PAYTS.or_flag%TYPE;
    BEGIN
        OPEN giop;
        
        FETCH giop
         INTO v_or_no,v_with_pdc, v_or_flag;
         
        IF giop%FOUND THEN
		    IF (v_or_no IS NULL) OR (v_or_no IS NOT NULL AND v_or_flag = 'N') THEN
			    UPDATE GIAC_ORDER_OF_PAYTS
				   SET or_pref_suf = p_or_pref,
					   or_no = p_or_no,
					   or_flag = 'P',
 	                   user_id = p_user_id,
 	                   last_update = SYSDATE
			     WHERE gacc_tran_id = p_gacc_tran_id;

                IF v_with_pdc = 'Y' THEN 
                    UPDATE GIAC_PDC_CHECKS
                       SET ref_no = p_or_pref ||'-'|| TO_CHAR(p_or_no)
                     WHERE gacc_tran_id = p_gacc_tran_id;
			    END IF; 
		    ELSE
			    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#The current transaction ID is already printed.');
		    END IF;
        END IF;
        
        CLOSE giop;
    END;
    
    PROCEDURE ins_upd_or(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_pref                   GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no                     GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_doc_name                  GIAC_DOC_SEQUENCE.doc_name%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
        CURSOR gion IS
        SELECT '1'
          FROM GIAC_DOC_SEQUENCE
         WHERE doc_name = p_doc_name
           AND NVL(doc_pref_suf, '-') = NVL(p_or_pref, NVL(doc_pref_suf, '-'))
           AND branch_cd = p_branch_cd
           AND fund_cd = p_fund_cd;

        v_exists                    VARCHAR2(1);
    BEGIN
        OPEN gion;
        
        FETCH gion
         INTO v_exists;
         
        IF gion%FOUND THEN
            UPDATE GIAC_DOC_SEQUENCE
               SET doc_seq_no = p_or_no,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE doc_name = p_doc_name
               AND NVL(doc_pref_suf, '-') = NVL(p_or_pref, NVL(doc_pref_suf, '-'))
               AND branch_cd = p_branch_cd
               AND fund_cd = p_fund_cd;
        ELSE
            INSERT INTO GIAC_DOC_SEQUENCE
      		       (fund_cd, branch_cd, doc_name, doc_seq_no, user_id, last_update, doc_pref_suf)
            VALUES (p_fund_cd, p_branch_cd, p_doc_name, p_or_no, p_user_id, SYSDATE, p_or_pref);
        END IF;
        
        CLOSE gion;
    END;
    
    FUNCTION check_last_printed_or(
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_last_or_printed           GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE
    )
      RETURN VARCHAR2
    IS
        v_valid				        VARCHAR2(1) := 'N';
        v_or_spoiled	            VARCHAR2(3000);
    BEGIN
        FOR i IN(SELECT gacc_tran_id, dsp_or_no, dsp_or_pref
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE generate_flag = 'Y'
                    AND or_type = p_or_type
                    AND dsp_or_pref IS NOT NULL
                    AND dsp_or_no IS NOT NULL
                  ORDER BY or_date, payor)
        LOOP
            IF p_last_or_no IS NULL OR i.dsp_or_no > p_last_or_no THEN
                v_or_spoiled := v_or_spoiled || i.dsp_or_pref || '-' || i.dsp_or_no || ',';
            END IF;
            
            IF p_last_or_no = i.dsp_or_no OR p_last_or_no IS NULL THEN
			    v_valid := 'Y';
		    END IF;
        END LOOP;
        
        IF v_valid = 'N' AND p_last_or_no IS NOT NULL THEN
    		RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Entered OR number does not exist in the generated OR numbers. Please re-enter a valid value.');
	    ELSE
            IF NVL(p_last_or_no, p_last_or_printed) > p_last_or_printed THEN
			    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Entered OR number was not printed. Please re-enter a valid value.');	
		    END IF;
        END IF;
        
        IF v_or_spoiled IS NOT NULL THEN
            v_or_spoiled := SUBSTR(v_or_spoiled, 0, LENGTH(v_or_spoiled)-1);
        END IF;
        
        RETURN v_or_spoiled;
    END;
    
    PROCEDURE spoil_batch_or(
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
    BEGIN
        FOR i IN(SELECT gacc_tran_id, dsp_or_no, dsp_or_pref
                   FROM GIAC_ORDER_OF_PAYTS_TEMP
                  WHERE generate_flag = 'Y'
                    AND (NVL(printed_flag, 'N') <> 'Y' OR or_flag = 'N')
                    AND or_type = p_or_type
                    AND dsp_or_pref IS NOT NULL
                    AND dsp_or_no IS NOT NULL
                    AND TO_NUMBER(dsp_or_no) > NVL(p_last_or_no, TO_NUMBER(dsp_or_no)-1)
                  ORDER BY or_date, payor)
        LOOP
            GIACS053_PKG.spoil_or_record(i.gacc_tran_id, i.dsp_or_pref, i.dsp_or_no, p_fund_cd, p_branch_cd, p_user_id);
        END LOOP;
    END;
    
    PROCEDURE spoil_or_record(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref                   GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_or_no                     GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    )
    IS
        v_tran_type                 GIAC_ACCTRANS.tran_flag%TYPE;
        v_dcb_flag                  GIAC_COLLN_BATCH.dcb_flag%TYPE;
        v_curr_cd                   GIAC_ORDER_OF_PAYTS.currency_cd%TYPE;
        v_gross_tag                 GIAC_ORDER_OF_PAYTS.gross_tag%TYPE;
        v_or_date                   GIAC_ORDER_OF_PAYTS.or_date%TYPE;
        v_coll_amt                  GIAC_ORDER_OF_PAYTS.collection_amt%TYPE;
        v_gross_amt                 GIAC_ORDER_OF_PAYTS.gross_amt%TYPE;
        v_or_tag                    GIAC_ORDER_OF_PAYTS.or_tag%TYPE;
    BEGIN
        BEGIN
            SELECT tran_flag
              INTO v_tran_type
              FROM GIAC_ACCTRANS
             WHERE tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Unable to locate tran flag of this OR.');
        END;
        
        IF v_tran_type IN ('O', 'C') THEN
            v_dcb_flag := GIACS053_PKG.get_or_dcb_flag(p_gacc_tran_id, p_fund_cd, p_branch_cd);
            
            IF v_dcb_flag = 'O' THEN
                BEGIN
                    FOR a1 IN (SELECT currency_cd, gross_tag,
                                      or_date, collection_amt,
                                      gross_amt, or_tag
                                 FROM GIAC_ORDER_OF_PAYTS
                                WHERE gacc_tran_id = p_gacc_tran_id) 
                    LOOP
                        v_curr_cd := a1.currency_cd;
                        v_gross_tag := a1.gross_tag;
                        v_or_date := a1.or_date;
                        v_coll_amt := a1.collection_amt;
                        v_gross_amt := a1.gross_amt;
                        v_or_tag := a1.or_tag;
                        EXIT;
                    END LOOP;
                    
                    IF v_or_date IS NULL THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#OR data not found in order_of_payts.');
                    END IF;
                    
                    INSERT INTO GIAC_SPOILED_OR
                           (or_pref, or_no, fund_cd, branch_cd, spoil_date, spoil_tag, tran_id, user_id, last_update, or_date) 
                    VALUES (p_or_pref, p_or_no, p_fund_cd, p_branch_cd, SYSDATE, 'S', p_gacc_tran_id, p_user_id, SYSDATE, v_or_date);
                    
                    IF SQL%FOUND THEN
                        IF v_tran_type = 'C' THEN
                            UPDATE GIAC_ACCTRANS
							   SET tran_flag = 'O'
							 WHERE tran_id = p_gacc_tran_id;
                             
                            IF SQL%FOUND THEN
                                UPDATE GIAC_ORDER_OF_PAYTS
								   SET or_pref_suf = NULL,
									   or_no = NULL,
									   or_flag = 'N',
				   	                   user_id = p_user_id,
				   	                   last_update = SYSDATE
								 WHERE gacc_tran_id = p_gacc_tran_id;
                                 
                                 UPDATE GIAC_ORDER_OF_PAYTS_TEMP
                                    SET dsp_or_pref = NULL,
									    dsp_or_no = NULL,
									    or_flag = 'N',
                                        printed_flag = 'N'
                                  WHERE gacc_tran_id = p_gacc_tran_id;                                      
                                 
                                IF SQL%NOTFOUND THEN
                                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil OR: Unable to update order_of_payts.');
                                END IF;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil OR: Unable to update acctrans.');
                            END IF;
                        ELSIF v_tran_type = 'O' THEN
                            UPDATE GIAC_ORDER_OF_PAYTS
							   SET or_pref_suf = NULL,
								   or_no = NULL,
								   or_flag = 'N',
								   user_id = p_user_id,
   	           			           last_update = SYSDATE
							 WHERE gacc_tran_id = p_gacc_tran_id;
                             
                            UPDATE GIAC_ORDER_OF_PAYTS_TEMP
                               SET dsp_or_pref = NULL,
                                   dsp_or_no = NULL,
                                   or_flag = 'N',
                                   printed_flag = 'N'
                             WHERE gacc_tran_id = p_gacc_tran_id;
							
                            IF SQL%NOTFOUND THEN
								RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil OR: Unable to update order_of_payts.');
							END IF;
                        END IF;
                    ELSE
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoil OR: Unable to insert into spoiled_or.');
                    END IF;
                END;
            ELSIF v_dcb_flag IN ('C', 'X') THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoiling not allowed. The DCB has already ' ||
                  'been closed/closed for printing. You may cancel this OR instead.');
            END IF;
            
            IF NVL(GIACP.v('UPLOAD_IMPLEMENTATION_SW'),'N') = 'Y' THEN
			    EXEC_IMMEDIATE('BEGIN upload_dpc.upd_guf('||p_gacc_tran_id||'); END;');
		    END IF;
        ELSIF v_tran_type = 'D' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoiling not allowed. This is a deleted transaction.');
        ELSIF v_tran_type = 'P' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Spoiling not allowed. This is a posted transaction.');
        END IF;
    END;
    
    FUNCTION get_or_dcb_flag(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE
    )
      RETURN VARCHAR2
    IS
        v_select_ctr NUMBER;
        v_or_date                   GIAC_ORDER_OF_PAYTS.or_date%TYPE;
        v_dcb_no                    GIAC_ORDER_OF_PAYTS.dcb_no%TYPE;
        v_dcb_flag                  GIAC_COLLN_BATCH.dcb_flag%TYPE;
    BEGIN
        v_select_ctr := 1;
        SELECT or_date, dcb_no
          INTO v_or_date, v_dcb_no
          FROM GIAC_ORDER_OF_PAYTS
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        v_select_ctr := 2;
        SELECT dcb_flag
          INTO v_dcb_flag
          FROM GIAC_COLLN_BATCH
	     WHERE fund_cd = p_fund_cd
           AND branch_cd = p_branch_cd
           AND dcb_year = TO_NUMBER(TO_CHAR(v_or_date, 'YYYY'))
           AND dcb_no = v_dcb_no;
           
        RETURN v_dcb_flag;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF v_select_ctr = 1 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#OR Date/DCB No. not found.');
            ELSIF v_select_ctr = 2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#DCB flag not found.');
            END IF;
    END;
    
    PROCEDURE get_batch_comm_slip_params(
        p_gacc_tran_id_list OUT     VARCHAR2,
        p_message_flag      OUT     VARCHAR2,
        p_or_count          OUT     NUMBER
    )
    IS
        
    BEGIN
        p_gacc_tran_id_list := '(';
        
        FOR i IN (SELECT gacc_tran_id, dsp_or_no
                    FROM GIAC_ORDER_OF_PAYTS_TEMP
                   WHERE generate_flag = 'Y'
                   ORDER BY or_date, payor)
        LOOP
            p_or_count := NVL(p_or_count, 0) + 1;
            
            IF i.dsp_or_no IS NULL THEN
                p_message_flag := 'Y';
            ELSE
                p_gacc_tran_id_list := p_gacc_tran_id_list || TO_CHAR(i.gacc_tran_id) || ',';
            END IF;
        END LOOP;
        
        p_gacc_tran_id_list := RTRIM(p_gacc_tran_id_list, ',') || ')';
    END;

END GIACS053_PKG;
/



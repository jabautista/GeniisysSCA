CREATE OR REPLACE PACKAGE BODY CPI.giacs045_pkg
AS
   FUNCTION get_document_cd_lov
      RETURN document_cd_tab PIPELINED
   IS
      v_list document_cd_type;
   BEGIN
      FOR i IN (SELECT DISTINCT document_cd
                           FROM giac_payt_requests
                          WHERE document_cd NOT IN (
                                   SELECT param_value_v
                                     FROM giac_parameters
                                    WHERE param_name IN
                                             ('CLM_PAYT_REQ_DOC', 'BATCH_CSR_DOC',
                                              'SPECIAL_CSR_DOC', 'FACUL_RI_PREM_PAYT_DOC',
                                              'COMM_PAYT_DOC')))
      LOOP
         v_list.document_cd := i.document_cd;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;                                           
   END get_document_cd_lov; 
   
   FUNCTION get_branch_cd_lov (
      p_user_id          VARCHAR2,
      p_document_cd_from VARCHAR2
   )
      RETURN branch_cd_tab PIPELINED
   IS
      v_list branch_cd_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.branch_cd, b.branch_name
                  FROM giac_payt_requests a, giac_branches b
                 WHERE a.document_cd = UPPER (p_document_cd_from)
                   AND a.branch_cd = b.branch_cd
                   AND a.branch_cd IN (
                          SELECT iss_cd
                            FROM giis_issource
                           WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS045', p_user_id ), 1, iss_cd, NULL)))
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         
         BEGIN
            SELECT line_cd_tag
              INTO v_list.line_cd_tag
              FROM giac_payt_req_docs
             WHERE document_cd = p_document_cd_from
               AND gibr_branch_cd = i.branch_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.line_cd_tag := 'N';       
         END;
         
         PIPE ROW(v_list);
      END LOOP;
      RETURN;                      
   END get_branch_cd_lov;
   
   FUNCTION get_branch_cd_lov2 (p_user_id VARCHAR2)
      RETURN branch_cd_tab PIPELINED
   IS
      v_list branch_cd_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd =
                          DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS045', p_user_id), 1, iss_cd, NULL)
                   AND online_sw = 'Y')
      LOOP
         v_list.branch_cd := i.iss_cd;
         v_list.branch_name := i.iss_name;
         PIPE ROW(v_list);
      END LOOP;           
      RETURN;     
   END get_branch_cd_lov2;     
   
   FUNCTION get_line_lov (
      p_document_cd_from VARCHAR2,
      p_branch_cd_from VARCHAR2
   )
      RETURN line_cd_tab PIPELINED
   IS
      v_list line_cd_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, a.line_name
                  FROM giis_line a, giac_payt_requests b
                 WHERE a.line_cd = b.line_cd
                   AND b.document_cd = UPPER (p_document_cd_from)
                   AND NVL (b.branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
                   AND b.doc_year IS NOT NULL
                   AND b.doc_mm IS NOT NULL)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW(v_list);
      END LOOP;                
      RETURN;
   END get_line_lov;   
   
   FUNCTION get_doc_year_lov (
      p_document_cd_from   VARCHAR2,
      p_branch_cd_from     VARCHAR2,
      p_line_cd_from       VARCHAR2
   )
      RETURN doc_year_tab PIPELINED
   IS
      v_list doc_year_type;
   BEGIN
      FOR i IN (SELECT DISTINCT doc_year, doc_mm
                  FROM giac_payt_requests
                 WHERE document_cd = UPPER (p_document_cd_from)
                   AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
                   AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd_from, '-')))
      LOOP
         v_list.doc_year := i.doc_year;
         v_list.doc_mm := i.doc_mm;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;                
   END get_doc_year_lov;
   
   FUNCTION get_doc_seq_no_lov (
      p_document_cd_from   VARCHAR2,
      p_branch_cd_from     VARCHAR2,
      p_line_cd_from       VARCHAR2,
      p_doc_year_from      VARCHAR2,
      p_doc_mm_from        VARCHAR2,
      p_doc_seq_no_from    VARCHAR2
   )
      RETURN doc_seq_no_tab PIPELINED
   IS
      v_list doc_seq_no_type;
   BEGIN
      FOR i IN (SELECT   a.doc_seq_no, b.particulars
                  FROM giac_payt_requests a, giac_payt_requests_dtl b
                 WHERE a.document_cd = NVL (p_document_cd_from, a.document_cd)
                   AND a.branch_cd = NVL (p_branch_cd_from, a.branch_cd)
                   AND NVL (a.line_cd, '-') = NVL (p_line_cd_from, '-')
                   AND a.doc_year = NVL (p_doc_year_from, a.doc_year)
                   AND a.doc_mm = NVL (p_doc_mm_from, a.doc_mm)
                   AND a.ref_id = b.gprq_ref_id
                   AND a.doc_seq_no = NVL(p_doc_seq_no_from, a.doc_seq_no)
              ORDER BY 1)
      LOOP      
         v_list.doc_seq_no := i.doc_seq_no;
         v_list.particulars := i.particulars;   
         PIPE ROW(v_list);
      END LOOP;
      RETURN;              
   END get_doc_seq_no_lov;
   
   PROCEDURE validate_request_no(
      p_document_cd_from   IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_from     IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_from       IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_from      IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_from        IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_from    IN       giac_payt_requests.doc_seq_no%TYPE,
      p_ref_id_from        OUT      giac_payt_requests.ref_id%TYPE,
      p_fund_cd_from       OUT      giac_payt_requests.fund_cd%TYPE,
      p_tran_id_from       OUT      giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_date_from     OUT      giac_acctrans.tran_date%TYPE,
      p_check              OUT      VARCHAR2
   )
   IS
   BEGIN
      BEGIN
        SELECT ref_id, fund_cd
          INTO p_ref_id_from, p_fund_cd_from
          FROM giac_payt_requests
         WHERE document_cd = UPPER (p_document_cd_from)
           AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
           AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd_from, '-'))
           AND NVL (doc_year, 0) = NVL (p_doc_year_from, 0)
           AND NVL (doc_mm, 0) = NVL (p_doc_mm_from, 0)
           AND doc_seq_no = p_doc_seq_no_from;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           --RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Please enter valid request number.');
           p_check := 'no data';
           RETURN;
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error Occured.');
      END;              
        
        BEGIN
           SELECT tran_id
             INTO p_tran_id_from
             FROM giac_payt_requests_dtl
            WHERE gprq_ref_id = p_ref_id_from; 
        EXCEPTION WHEN NO_DATA_FOUND THEN
           NULL;       
        END;
        
        BEGIN
           SELECT tran_date
             INTO p_tran_date_from
             FROM giac_acctrans
            WHERE tran_id = p_tran_id_from;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           NULL;       
        END; 
        
   END validate_request_no;
   
   PROCEDURE check_create_transaction (
      p_tran_date_from      IN    VARCHAR2,
      p_branch_cd_to        IN    VARCHAR2
   )
   IS
      v_param_value_v   giac_parameters.param_value_v%TYPE;
	  v_closed_tag      giac_tran_mm.closed_tag%TYPE;
	  v_mm              NUMBER(2);		
	  v_mm_c            VARCHAR2(20); 
	  v_yy              NUMBER(4);
   BEGIN
   
      FOR a IN (SELECT param_value_v
                  FROM giac_parameters
 			     WHERE param_name = 'ALLOW_TRAN_FOR_CLOSED_MONTH')
 	  LOOP
 	     v_param_value_v := a.param_value_v;
 	  END LOOP;
       
      v_mm := TO_NUMBER(TO_CHAR(TO_DATE(p_tran_date_from, 'MM-DD-YYYY'), 'MM'), '99');
      v_mm_c := TO_CHAR(TO_DATE(p_tran_date_from, 'MM-DD-YYYY'), 'Month'); 
      v_yy := TO_NUMBER(TO_CHAR(TO_DATE(p_tran_date_from, 'MM-DD-YYYY'), 'YYYY'), '9999');
      
      IF v_param_value_v = 'N' THEN
         FOR b IN (SELECT closed_tag
                     FROM giac_tran_mm
                    WHERE branch_cd = p_branch_cd_to
                      AND tran_yr   = v_yy
                      AND tran_mm   = v_mm)
         LOOP
            v_closed_tag := b.closed_tag;
         END LOOP;
         
         IF v_closed_tag = 'Y' THEN 
    	    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are no longer allowed to create a transaction for '||TRIM(v_mm_c)||' '||TRIM(v_yy)||'. This transaction is already closed.');
         ELSIF v_closed_tag = 'T' THEN
      	    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are no longer allowed to create a transaction for '||TRIM(v_mm_c)||' '||TRIM(v_yy)||'. This transaction is temporarily closed.');
         END IF;
      END IF;
      
   END check_create_transaction;
   
   PROCEDURE insert_into_acctrans (
      p_fund_cd_from     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd_from   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date_from   IN       VARCHAR2,
      p_user_id          IN       VARCHAR2,
      p_tran_id_acc      OUT      giac_taxes_wheld.gacc_tran_id%TYPE
   )
   IS
   BEGIN
      
      BEGIN
         SELECT acctran_tran_id_s.nextval
           INTO p_tran_id_acc
           FROM DUAL;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#ACCTTRAN_TRAN_ID sequence not found.');     
      END;
      
      BEGIN
         INSERT INTO giac_acctrans (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag,
                                    tran_class, user_id, last_update)
         VALUES (p_tran_id_acc, p_fund_cd_from, p_branch_cd_from, TO_DATE(p_tran_date_from, 'mm-dd-yyyy'), 'O', 'DV', p_user_id, SYSDATE);
      EXCEPTION WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error Occured.');
      END;
      
   END insert_into_acctrans;
   
   PROCEDURE copy_payment_request (
      p_document_cd_from   IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_from     IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_from       IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_from      IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_from        IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_from    IN       giac_payt_requests.doc_seq_no%TYPE,
      p_document_cd_to     IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_to       IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_to         IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_to        IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_to          IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_to      OUT      giac_payt_requests.doc_seq_no%TYPE,
      p_ref_id_from        IN       giac_payt_requests.ref_id%TYPE,
      p_ref_id_to          OUT      giac_payt_requests.ref_id%TYPE,
      p_tran_date_from     IN       VARCHAR2,
      p_user_id            IN       VARCHAR2,
      p_tran_id_acc        IN       giac_taxes_wheld.gacc_tran_id%TYPE
   )
   IS
      CURSOR cur1 IS
         SELECT gouc_ouc_id, ref_id, fund_cd, branch_cd, document_cd, request_date,
                line_cd, cpi_rec_no, cpi_branch_cd
           FROM giac_payt_requests
          WHERE document_cd = UPPER (p_document_cd_from)
            AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
            AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd_from, '-'))
            AND NVL (doc_year, 0) = NVL (p_doc_year_from, 0)
            AND NVL (doc_mm, 0) = NVL (p_doc_mm_from, 0)
            AND doc_seq_no = p_doc_seq_no_from;
            
      CURSOR cur2 IS
         SELECT req_dtl_no, gprq_ref_id, payee_class_cd, payee_cd, payee, currency_cd,
                payt_amt, tran_id, particulars, user_id, last_update, cpi_rec_no,
                cpi_branch_cd, cancel_by, cancel_date, dv_fcurrency_amt, currency_rt
           FROM giac_payt_requests_dtl
          WHERE gprq_ref_id = p_ref_id_from;                 
   BEGIN
      BEGIN
         SELECT gprq_ref_id_s.NEXTVAL
           INTO p_ref_id_to
           FROM DUAL;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No ref_id sequence in dual. Please contact system administrator about this');  
      END;
      
      --GIACS045_PKG.INSERT_INTO_ACCTRANS(p_fund_cd_from, p_branch_cd_from, p_tran_date_from, p_user_id);
      
      BEGIN
         FOR c1 IN cur1 LOOP
            INSERT INTO giac_payt_requests (gouc_ouc_id, ref_id, fund_cd, branch_cd, document_cd, request_date,
                                            line_cd, doc_year, doc_mm, user_id, last_update, create_by, cpi_rec_no,
                                            cpi_branch_cd, with_dv)
            VALUES (c1.gouc_ouc_id, p_ref_id_to, c1.fund_cd, p_branch_cd_to, p_document_cd_to, TO_DATE(p_tran_date_from, 'mm-dd-yyyy'), p_line_cd_to, p_doc_year_to,
                    p_doc_mm_to, p_user_id, sysdate, p_user_id, c1.cpi_rec_no, c1.cpi_branch_cd, 'N');                                   
         END LOOP;
      END;
      
      BEGIN
         FOR c2 IN cur2 LOOP
            INSERT INTO giac_payt_requests_dtl (req_dtl_no, gprq_ref_id, payee_class_cd, payt_req_flag, payee_cd,
                                                payee, currency_cd, payt_amt, tran_id, particulars, user_id,
                                                last_update, cpi_rec_no, cpi_branch_cd, cancel_by, cancel_date,
                                                dv_fcurrency_amt, currency_rt)
            VALUES (c2.req_dtl_no, p_ref_id_to, c2.payee_class_cd, 'N', c2.payee_cd, c2.payee, c2.currency_cd,	c2.payt_amt,
                    p_tran_id_acc, c2.particulars, p_user_id, sysdate, c2.cpi_rec_no, c2.cpi_branch_cd,	c2.cancel_by,
	                c2.cancel_date,	c2.dv_fcurrency_amt, c2.currency_rt);                                                
         END LOOP;
      END;
      
      BEGIN
         SELECT doc_seq_no
           INTO p_doc_seq_no_to
           FROM giac_payt_requests
          WHERE ref_id = p_ref_id_to; 
      END;
      
   END copy_payment_request;
   
   PROCEDURE copy_withholding (
      p_tran_id_from   IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc    IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id        IN   VARCHAR2
   )
   IS
      v_gl_acct_id  NUMBER;
      
      CURSOR cur1 IS
	     SELECT gacc_tran_id, gen_type, payee_class_cd, item_no, payee_cd,
                gwtx_whtax_id, income_amt, wholding_tax_amt, or_print_tag,remarks, 
                user_id, last_update, cpi_rec_no, cpi_branch_cd, sl_cd, sl_type_cd
           FROM GIAC_TAXES_WHELD
		  WHERE gacc_tran_id = p_tran_id_from;
   BEGIN       
     FOR c1 IN cur1
       LOOP
       
          --SELECT DISTINCT a.gl_acct_id
           SELECT COUNT(a.gl_acct_id)  -- Added by Sam 09.22.2015 : To Handle select result more than one record.
                     INTO v_gl_acct_id
                     FROM giac_acct_entries a, giac_chart_of_accts b
                    WHERE a.gl_acct_id = b.gl_acct_id
                      AND b.gl_acct_name LIKE ('%WITHHOLDING TAX%')
                      AND a.gacc_tran_id = p_tran_id_from;
                       
          --IF v_gl_acct_id IS NOT NULL
          IF v_gl_acct_id > 0
          THEN
             INSERT INTO giac_taxes_wheld
                         (gacc_tran_id, gen_type, payee_class_cd,
                          item_no, payee_cd, gwtx_whtax_id,
                          income_amt, wholding_tax_amt, or_print_tag,
                          remarks, user_id, last_update, cpi_rec_no,
                          cpi_branch_cd, sl_cd, sl_type_cd
                         )
                  VALUES (p_tran_id_acc, c1.gen_type, c1.payee_class_cd,
                          c1.item_no, c1.payee_cd, c1.gwtx_whtax_id,
                          c1.income_amt, c1.wholding_tax_amt, c1.or_print_tag,
                          c1.remarks, p_user_id, sysdate, c1.cpi_rec_no,
                          c1.cpi_branch_cd, c1.sl_cd, c1.sl_type_cd
                         );
          ELSE
             NULL;
          END IF;
       END LOOP;
   END copy_withholding;
   
   PROCEDURE copy_input_vat (
      p_tran_id_from   IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc    IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id        IN   VARCHAR2
   )
   IS
      v_gl_acct_id  NUMBER;
      
       CURSOR cur1
   IS
      SELECT gacc_tran_id, transaction_type, payee_no, payee_class_cd,
             reference_no, base_amt, input_vat_amt, gl_acct_id,
             vat_gl_acct_id, item_no, sl_cd, or_print_tag, remarks, user_id,
             last_update, cpi_rec_no, cpi_branch_cd, vat_sl_cd
        FROM giac_input_vat
       WHERE gacc_tran_id = p_tran_id_from;
       
       
   BEGIN
      FOR c1 IN cur1
       LOOP
          IF c1.vat_gl_acct_id IS NOT NULL
          THEN
             INSERT INTO giac_input_vat
                         (gacc_tran_id, transaction_type,
                          payee_no, payee_class_cd, reference_no,
                          base_amt, input_vat_amt, gl_acct_id,
                          vat_gl_acct_id, item_no, sl_cd,
                          or_print_tag, remarks, user_id, last_update,
                          cpi_rec_no, cpi_branch_cd, vat_sl_cd
                         )
                  VALUES (p_tran_id_acc, c1.transaction_type,
                          c1.payee_no, c1.payee_class_cd, c1.reference_no,
                          c1.base_amt, c1.input_vat_amt, c1.gl_acct_id,
                          c1.vat_gl_acct_id, c1.item_no, c1.sl_cd,
                          c1.or_print_tag, c1.remarks, p_user_id, sysdate,
                          c1.cpi_rec_no, c1.cpi_branch_cd, c1.vat_sl_cd
                         );
          ELSE
             NULL;
          END IF;
       END LOOP;   
   END copy_input_vat; 
   
   PROCEDURE copy_acctg_entries (
      p_acct_entry_id   IN   giac_acct_entries.acct_entry_id%TYPE,
      p_tran_id_from    IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc     IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_branch_cd_to    IN   giac_payt_requests.branch_cd%TYPE,
      p_user_id         IN   VARCHAR2
   )
   IS
      CURSOR cur2
       IS
          SELECT gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                 acct_entry_id, gl_acct_id, gl_acct_category, gl_control_acct,
                 gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                 gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd, debit_amt,
                 credit_amt, generation_type, sl_type_cd, sl_source_cd,
                 user_id last_update, remarks, cpi_rec_no, cpi_branch_cd
            FROM giac_acct_entries
           WHERE gacc_tran_id = p_tran_id_from
             AND acct_entry_id = p_acct_entry_id;
   
   BEGIN
      FOR c2 IN cur2
       LOOP
          INSERT INTO giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd,
                       gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                       gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, sl_cd, debit_amt, credit_amt,
                       generation_type, sl_type_cd, sl_source_cd, user_id,
                       last_update, remarks, cpi_rec_no, cpi_branch_cd
                      )
               VALUES (p_tran_id_acc, c2.gacc_gfun_fund_cd,
                       p_branch_cd_to, c2.acct_entry_id, c2.gl_acct_id,
                       c2.gl_acct_category, c2.gl_control_acct,
                       c2.gl_sub_acct_1, c2.gl_sub_acct_2, c2.gl_sub_acct_3,
                       c2.gl_sub_acct_4, c2.gl_sub_acct_5, c2.gl_sub_acct_6,
                       c2.gl_sub_acct_7, c2.sl_cd, c2.debit_amt, c2.credit_amt,
                       c2.generation_type, c2.sl_type_cd, c2.sl_source_cd, p_user_id,
                       sysdate, c2.remarks, c2.cpi_rec_no, c2.cpi_branch_cd
                      );
       END LOOP;
   END copy_acctg_entries;
   
   PROCEDURE copy_acctg_entries_looper (
      p_tran_id_from   IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_fund_cd_from   IN   giac_payt_requests.fund_cd%TYPE,
      p_branch_cd_from IN   giac_payt_requests.branch_cd%TYPE,
      p_branch_cd_to   IN   giac_payt_requests.branch_cd%TYPE,
      p_tran_id_acc    IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id        IN   VARCHAR2
   )
   IS
   v_gen_type_p    GIAC_MODULES.generation_type%type;   --added by steven 09.29.2014
   v_gen_type_l     GIAC_MODULES.generation_type%type;  --added by steven 09.29.2014
      CURSOR cur1 is
        SELECT generation_type, acct_entry_id
          FROM giac_acct_entries
         WHERE gacc_tran_id 	= p_tran_id_from
           AND gacc_gfun_fund_cd = p_fund_cd_from
           AND gacc_gibr_branch_cd  = p_branch_cd_from;
   
    BEGIN
       --added by steven 09.29.2014
       FOR i IN (SELECT generation_type
                   FROM giac_modules
                  WHERE module_name = 'GIACS022')
       LOOP
          v_gen_type_p := i.generation_type;
       END LOOP;

       FOR i IN (SELECT generation_type
                   FROM giac_modules
                  WHERE module_name = 'GIACS039')
       LOOP
          v_gen_type_l := i.generation_type;
       END LOOP;

       FOR c1 IN cur1
       LOOP
          IF UPPER (c1.generation_type) IN ('X',v_gen_type_p,v_gen_type_l)
          THEN
             giacs045_pkg.copy_acctg_entries (c1.acct_entry_id,
                                              p_tran_id_from,
                                              p_tran_id_acc,
                                              p_branch_cd_to,
                                              p_user_id
                                             );
          END IF;
       END LOOP;
    END copy_acctg_entries_looper;
   
   FUNCTION validate_document_cd (p_document_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(100);
   BEGIN
      BEGIN
       SELECT DISTINCT document_cd
         INTO v_check
         FROM giac_payt_requests
        WHERE document_cd = UPPER(p_document_cd)
          AND document_cd NOT IN (SELECT Param_value_v 
                                    FROM GIAC_PARAMETERS
                                   WHERE Param_name IN ('CLM_PAYT_REQ_DOC','BATCH_CSR_DOC','SPECIAL_CSR_DOC', 
																'FACUL_RI_PREM_PAYT_DOC','COMM_PAYT_DOC'));
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';
      END;
      
   RETURN v_check;                                                                       
      
   END validate_document_cd; 
   
   FUNCTION validate_branch_cd_from (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_branch_cd giac_branches.branch_cd%TYPE;
      v_check VARCHAR2(100);
   BEGIN   
      BEGIN
         SELECT DISTINCT branch_cd
           INTO v_branch_cd
           FROM giac_payt_requests
          WHERE document_cd = UPPER (p_document_cd)
            AND branch_cd = UPPER (p_branch_cd_from);
            
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';
         RETURN v_check;
      END;
      
       BEGIN
            SELECT line_cd_tag
              INTO v_check
              FROM giac_payt_req_docs
             WHERE document_cd = p_document_cd
               AND gibr_branch_cd = v_branch_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_check := 'N';       
       END;
      
      RETURN v_check;
   END validate_branch_cd_from;
   
   FUNCTION validate_line_cd (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(100);
   BEGIN   
      BEGIN
         SELECT DISTINCT line_cd
           INTO v_check
           FROM giac_payt_requests
          WHERE document_cd = UPPER (p_document_cd)
            AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
            AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd, '-'));
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';      
      END;
      RETURN v_check;
   END validate_line_cd;
   
   FUNCTION validate_doc_year (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2,
      p_doc_year         VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(100);
   BEGIN   
      BEGIN
         SELECT DISTINCT TO_CHAR(doc_year)
           INTO v_check
           FROM giac_payt_requests
          WHERE document_cd = UPPER (p_document_cd)
            AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
            AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd, '-'))
            AND NVL (doc_year, 0) = NVL (p_doc_year, 0);
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';      
      END;
      RETURN v_check;
   END validate_doc_year;
   
   FUNCTION validate_doc_mm (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(100);
   BEGIN   
      BEGIN
         SELECT DISTINCT TO_CHAR(doc_mm)
           INTO v_check
           FROM giac_payt_requests
          WHERE document_cd = UPPER (p_document_cd)
            AND NVL (branch_cd, '-') = UPPER (NVL (p_branch_cd_from, '-'))
            AND NVL (line_cd, '-') = UPPER (NVL (p_line_cd, '-'))
            AND NVL (doc_year, 0) = NVL (p_doc_year, 0)
            AND NVL (doc_mm, 0) = NVL (p_doc_mm, 0);
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';      
      END;
      RETURN v_check;
   END validate_doc_mm;
   
   FUNCTION validate_branch_cd_to (p_user_id VARCHAR2, p_branch_cd_to VARCHAR2)
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(100);
   BEGIN     
      BEGIN
         SELECT iss_cd
           INTO v_check
           FROM giis_issource
          WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS045', p_user_id), 1, iss_cd, NULL)
            AND online_sw = 'Y'
            AND iss_cd = p_branch_cd_to;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'no data';      
      END;
      RETURN v_check;
   END validate_branch_cd_to;         
   
END;
/

CREATE OR REPLACE PACKAGE BODY CPI.GIACS051_PKG
AS
    FUNCTION get_branch_cd_from_lov (
        p_user_id giis_users.user_id%TYPE
    )
        RETURN branch_cd_from_lov_tab PIPELINED
    IS
        v_list branch_cd_from_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.gibr_branch_cd, b.iss_name
                    FROM giac_acctrans a, giis_issource b
                   WHERE a.gibr_branch_cd = b.iss_cd
                     AND gibr_branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,gibr_branch_cd,'GIACS051', p_user_id),1,gibr_branch_cd,NULL)
                     AND tran_class = 'JV'
                     AND a.tran_flag IN ('C', 'P')) 
        LOOP
            v_list.gibr_branch_cd := i.gibr_branch_cd;
            v_list.iss_name := i.iss_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_branch_cd_from_lov;
    
    FUNCTION get_doc_year_lov (
        p_gibr_branch_cd VARCHAR2
    )
        RETURN doc_year_lov_tab PIPELINED
    IS
        v_list doc_year_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.tran_year doc_year, a.tran_month doc_mm
                    FROM giac_acctrans a
                   WHERE 1= 1
                     AND a.gibr_branch_cd = p_gibr_branch_cd
                     AND a.tran_class = 'JV'
                     AND a.tran_flag IN ('C', 'P')
                ORDER BY a.tran_year DESC, a.tran_month ASC)
        LOOP
            v_list.doc_year := i.doc_year;
            v_list.doc_mm := i.doc_mm;
            PIPE ROW(v_list);
        END LOOP;            
    END get_doc_year_lov;
    
    FUNCTION get_doc_seq_no_lov (
      p_gibr_branch_cd   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2,
      p_doc_seq_no       VARCHAR2
   )
      RETURN doc_seq_no_tab PIPELINED
    IS
        v_list doc_seq_no_type;
    BEGIN       
        FOR i IN (SELECT DISTINCT a.tran_seq_no doc_seq_no, a.particulars, a.tran_id,
                                  a.gfun_fund_cd, a.gibr_branch_cd, a.tran_seq_no, a.tran_date
                    FROM giac_acctrans a
                   WHERE a.tran_year = p_doc_year
                     AND a.tran_month = p_doc_mm
                     AND a.tran_seq_no = NVL(p_doc_seq_no, a.tran_seq_no)
                     AND a.gibr_branch_cd = p_gibr_branch_cd
                     AND a.tran_class = 'JV'
                     AND a.tran_flag IN ('C', 'P'))
    LOOP
        v_list.doc_seq_no := i.doc_seq_no;
        v_list.particulars := i.particulars;
        v_list.tran_id := i.tran_id;
        v_list.gfun_fund_cd := i.gfun_fund_cd;
        v_list.gibr_branch_cd := i.gibr_branch_cd;
        v_list.tran_seq_no := i.tran_seq_no;
        v_list.tran_date := i.tran_date;
        PIPE ROW(v_list);
    END LOOP;                     
    END get_doc_seq_no_lov;
    
    FUNCTION get_branch_cd_to_lov (
      p_user_id giis_users.user_id%TYPE
   )
      RETURN branch_cd_to_lov_tab PIPELINED
   IS
         v_list branch_cd_to_lov_type;
   BEGIN      
      FOR i IN (SELECT iss_cd,iss_name
                  FROM giis_issource
                  WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,iss_cd,'GIACS051', p_user_id),1,iss_cd,NULL) AND online_sw = 'Y')
      LOOP
        v_list.iss_cd := i.iss_cd;
        v_list.iss_name := i.iss_name;
        PIPE ROW(v_list);
      END LOOP;            
   END get_branch_cd_to_lov;
   
   FUNCTION check_create_transaction (
      p_tran_date VARCHAR2,
      p_branch_to VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_param_value_v			giac_parameters.param_value_v%TYPE;
	  v_closed_tag				giac_tran_mm.closed_tag%TYPE;
	  v_mm						NUMBER(2);
	  v_mm_c					VARCHAR2(20);
	  v_yy						NUMBER(4);
   BEGIN
      SELECT param_value_v
        INTO v_param_value_v   
        FROM giac_parameters
       WHERE param_name = 'ALLOW_TRAN_FOR_CLOSED_MONTH';
       
      v_mm := TO_NUMBER(TO_CHAR(TO_DATE(p_tran_date, 'mm-dd-yyyy'), 'MM'), '99');
      v_mm_c := TO_CHAR(TO_DATE(p_tran_date, 'mm-dd-yyyy'), 'Month'); 
      v_yy := TO_NUMBER(TO_CHAR(TO_DATE(p_tran_date, 'mm-dd-yyyy'), 'YYYY'), '9999');
      
      IF UPPER(v_param_value_v) = 'N' THEN
         SELECT closed_tag
           INTO v_closed_tag 
  		   FROM giac_tran_mm
          WHERE branch_cd = p_branch_to
            AND tran_yr   = v_yy
            AND tran_mm   = v_mm;
      END IF;
      
      RETURN v_closed_tag;    
       
   END check_create_transaction;
   
   PROCEDURE insert_into_acctrans (
      p_fund_cd_from        IN  VARCHAR2,
      p_branch_cd_to        IN  VARCHAR2,        
      p_tran_date_from      IN  VARCHAR2,  
      p_acctran_tran_id     OUT giac_acctrans.tran_id%TYPE,
      p_doc_year_from       IN  VARCHAR2,
      p_doc_mm_from         IN  VARCHAR2,
      p_doc_seq_no_from     IN  giac_acctrans.tran_seq_no%TYPE,
      p_branch_cd_from      IN  VARCHAR2,
      p_doc_year_to         IN  VARCHAR2,
      p_doc_mm_to           IN  VARCHAR2,
      p_user_id             IN  VARCHAR2
   )
   IS
      CURSOR fund IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_fund_cd_from;
          
      CURSOR branch IS
         SELECT '1'
         FROM giac_branches
         WHERE branch_cd = p_branch_cd_to;
         
      v_fund          VARCHAR2(1);
      v_branch        VARCHAR2(1); 
      v_tran_date     giac_acctrans.tran_date%TYPE;
      v_jv_no         NUMBER(8);  
      v_particulars   giac_acctrans.particulars%TYPE;
      v_jv_tran_tag   giac_acctrans.jv_tran_tag%TYPE;
      v_jv_tran_type  giac_acctrans.jv_tran_type%TYPE;
      v_sap_inc_tag		giac_acctrans.sap_inc_tag%TYPE := 'Y';
      v_create_by			giac_acctrans.create_by%TYPE := p_user_id;
      v_jv_tran_mm		giac_acctrans.jv_tran_mm%TYPE := TO_NUMBER(TO_CHAR(SYSDATE,'MM'));
      v_jv_tran_yy		giac_acctrans.jv_tran_yy%TYPE := TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'));
      v_tran_class_no giac_acctrans.tran_class_no%TYPE;
      v_tran_class		giac_acctrans.tran_class%TYPE := 'JV';       
   BEGIN
      OPEN fund;
      FETCH fund INTO v_fund;
      
      IF fund%NOTFOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid fund code.');
      ELSE
         OPEN branch;
         FETCH branch INTO v_branch;
         IF branch%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid branch code.');
         END IF;
         CLOSE branch;   
      END IF;
      CLOSE fund;
      
      v_tran_date := TO_DATE(p_tran_date_from, 'mm-dd-yyyy');
      
      BEGIN
         SELECT acctran_tran_id_s.nextval
           INTO p_acctran_tran_id
           FROM dual;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.');
      END;
      
      FOR c1 IN (SELECT particulars, jv_tran_tag, jv_tran_type
                   FROM giac_acctrans
                  WHERE NVL(tran_year, 0) 	= NVL(p_doc_year_from, 0)
                    AND NVL(tran_month, 0) 	= NVL(p_doc_mm_from, 0)
                    AND tran_seq_no 		= p_doc_seq_no_from
                    AND gibr_branch_cd = p_branch_cd_from
                    AND tran_class = 'JV')
      LOOP
   	     v_particulars := c1.particulars;
   	     v_jv_tran_tag := c1.jv_tran_tag;
   	     v_jv_tran_type:= c1.jv_tran_type;
      END LOOP;
      
      v_tran_class_no := giac_Sequence_Generation(p_fund_cd_from, p_branch_cd_to, v_tran_class, p_doc_year_to, p_doc_mm_to);
      
      BEGIN
         INSERT INTO giac_acctrans (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag,
            tran_class, particulars, user_id, last_update, tran_year,
            tran_month, jv_tran_tag, jv_tran_type, sap_inc_tag,
            create_by, tran_class_no, jv_pref_suff, jv_no,
            jv_tran_mm, jv_tran_yy)
         VALUES (p_acctran_tran_id, p_fund_cd_from, p_branch_cd_to, v_tran_date, 'O',
            'JV', v_particulars, p_user_id, SYSDATE, p_doc_year_to,
            p_doc_mm_to, v_jv_tran_tag, v_jv_tran_type, v_sap_inc_tag,
            v_create_by, v_tran_class_no, 'JV', v_tran_class_no,
            v_jv_tran_mm, v_jv_tran_yy);
      EXCEPTION WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Error in insert_into_acctrans');   
      END;
      
      
   END insert_into_acctrans;
   
   PROCEDURE copy_acctg_entries (
      p_acct_entry_id   VARCHAR2,
      p_tran_id_from    VARCHAR2,
      p_acct_tran_id    VARCHAR2,
      p_branch_cd_to    VARCHAR2,
      p_user_id         VARCHAR2
   )
   IS
      CURSOR cur2 IS
         SELECT gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
                gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,       
                gl_sub_acct_6, gl_sub_acct_7, sl_cd, debit_amt, credit_amt,          
                generation_type, sl_type_cd, sl_source_cd, user_id                
                last_update, remarks, cpi_rec_no, cpi_branch_cd
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_tran_id_from
            AND acct_entry_id = p_acct_entry_id;
   BEGIN
--   raise_application_error (-20001, p_user_id);
      FOR c2 IN cur2
      LOOP
         INSERT INTO giac_acct_entries (
                     gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, 
                     acct_entry_id, gl_acct_id, gl_acct_category, 
                     gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, 
                     gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,       
                     gl_sub_acct_6, gl_sub_acct_7, sl_cd, debit_amt, 
                     credit_amt, generation_type, sl_type_cd, sl_source_cd,
                     user_id, last_update, remarks, cpi_rec_no, 
                     cpi_branch_cd)
         VALUES (
                     p_acct_tran_id, c2.gacc_gfun_fund_cd, p_branch_cd_to,
                     c2.acct_entry_id, c2.gl_acct_id, c2.gl_acct_category,
                     c2.gl_control_acct, c2.gl_sub_acct_1, c2.gl_sub_acct_2,
                     c2.gl_sub_acct_3, c2.gl_sub_acct_4, c2.gl_sub_acct_5,
                     c2.gl_sub_acct_6, c2.gl_sub_acct_7, c2.sl_cd,
                     c2.debit_amt, c2.credit_amt, c2.generation_type,
                     c2.sl_type_cd, c2.sl_source_cd, p_user_id,
                     sysdate, c2.remarks, c2.cpi_rec_no, c2.cpi_branch_cd);
      END LOOP;
   END copy_acctg_entries;
   
   PROCEDURE copy_jv_looper (
      p_fund_cd         IN VARCHAR2,
      p_branch_cd_from  IN VARCHAR2,
      p_tran_id_from    IN VARCHAR2,
      p_acct_tran_id    IN VARCHAR2,
      p_branch_cd_to    IN VARCHAR2,
      p_user_id         IN VARCHAR2,
      p_doc_year_to     IN VARCHAR2,
      p_doc_mm_to       IN VARCHAR2,
      p_new_tran_no     OUT VARCHAR2 
   )
   IS
      v_jv_no GIAC_ACCTRANS.jv_no%TYPE;
   
      CURSOR cur1 IS
        SELECT generation_type, acct_entry_id
          FROM giac_acct_entries
         WHERE gacc_tran_id 	= p_tran_id_from
           AND gacc_gfun_fund_cd 	= p_fund_cd
           AND gacc_gibr_branch_cd 	= p_branch_cd_from;
   BEGIN
      FOR c1 IN cur1 LOOP
         IF UPPER(c1.generation_type) = 'X' THEN
            GIACS051_PKG.copy_acctg_entries(c1.acct_entry_id, p_tran_id_from, p_acct_tran_id, p_branch_cd_to, p_user_id);
         END IF;
      END LOOP;
      
      BEGIN
          SELECT jv_no
            INTO v_jv_no
            FROM giac_acctrans
           WHERE tran_id = p_acct_tran_id
             AND gfun_fund_cd = p_fund_cd
             AND gibr_branch_cd = p_branch_cd_to
             AND tran_year = p_doc_year_to
             AND tran_month = p_doc_mm_to;
      END;
      
      p_new_tran_no := p_branch_cd_to || ' - ' || TO_CHAR(p_doc_year_to) || ' - ' ||
                  LTRIM(TO_CHAR(p_doc_mm_to,'099999')) || ' with JV No. ' || v_jv_no;             
   END copy_jv_looper;
   
   FUNCTION validate_branch_cd_from (
      p_branch_cd_from VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(1000) := 'test';
   BEGIN
      BEGIN
         SELECT DISTINCT a.gibr_branch_cd
           INTO v_check
           FROM giac_acctrans a, giis_issource b
          WHERE UPPER(gibr_branch_cd) =  UPPER(p_branch_cd_from) 
            AND gibr_branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,gibr_branch_cd,'GIACS051', p_user_id),1,gibr_branch_cd,NULL)
            AND tran_class = 'JV'
            AND a.tran_flag IN ('C', 'P')
            AND a.gibr_branch_cd = b.iss_cd;
         
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'ERROR';
      END;
      
      RETURN v_check;                
   END validate_branch_cd_from;
   
   FUNCTION validate_doc_year (
      p_branch_cd_from   VARCHAR2,
      p_doc_year         VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(1000);
   BEGIN      
      BEGIN
         SELECT DISTINCT tran_year
           INTO v_check
           FROM giac_acctrans
          WHERE tran_year = p_doc_year 
            AND gibr_branch_cd = p_branch_cd_from
            AND tran_class = 'JV'
            AND tran_flag IN ('C', 'P');
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'ERROR';      
      END;
      RETURN v_check;
   END validate_doc_year;
   
   FUNCTION validate_doc_mm (
      p_branch_cd_from   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(1000);
   BEGIN
      BEGIN
         SELECT DISTINCT tran_month
           INTO v_check
           FROM giac_acctrans
          WHERE tran_month = p_doc_mm
            AND tran_year = p_doc_year 
            AND gibr_branch_cd = p_branch_cd_from
            AND tran_class = 'JV'
            AND tran_flag IN ('C', 'P');
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'ERROR';       
      END;   
      RETURN v_check;
   END validate_doc_mm;
   
   FUNCTION validate_branch_cd_to (
      p_branch_cd_to VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check VARCHAR2(1000);
   BEGIN
      BEGIN
         SELECT iss_cd || '#' || online_sw
           INTO v_check
           FROM giis_issource
          WHERE UPPER(iss_cd) = UPPER(p_branch_cd_to)
            AND iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,iss_cd,'GIACS051', p_user_id),1,iss_cd,NULL)
            AND online_sw IN ('N' , 'Y');
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_check := 'ERROR';
      END;
      RETURN v_check;   
   END validate_branch_cd_to;
   
   FUNCTION validate_doc_seq_no (
      p_gibr_branch_cd   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2,
      p_doc_seq_no       VARCHAR2
   )
      RETURN validate_doc_seq_no_tab PIPELINED
   IS
      v_list validate_doc_seq_no_type;
      v_count NUMBER(10);
   BEGIN
      BEGIN
        SELECT count(tran_seq_no)
          INTO v_count
          FROM giac_acctrans
         WHERE tran_year = p_doc_year
           AND tran_month = p_doc_mm
           AND tran_seq_no = p_doc_seq_no
           AND gibr_branch_cd = p_gibr_branch_cd
           AND tran_class = 'JV'
           AND tran_flag IN ('C', 'P');
      END;
      
      IF v_count > 1 OR v_count = 0 THEN
         v_list.rec_count := v_count;
         PIPE ROW(v_list);
      ELSE
         BEGIN
            FOR i IN (SELECT DISTINCT a.tran_seq_no doc_seq_no, a.particulars, a.tran_id,
                                  a.gfun_fund_cd, a.gibr_branch_cd, a.tran_seq_no, a.tran_date
                        FROM giac_acctrans a
                       WHERE a.tran_year = p_doc_year
                         AND a.tran_month = p_doc_mm
                        AND a.tran_seq_no = NVL(p_doc_seq_no, a.tran_seq_no)
                        AND a.gibr_branch_cd = p_gibr_branch_cd
                        AND a.tran_class = 'JV'
                        AND a.tran_flag IN ('C', 'P'))
            LOOP
               v_list.doc_seq_no := i.doc_seq_no;
               v_list.particulars := i.particulars;
               v_list.tran_id := i.tran_id;
               v_list.gfun_fund_cd := i.gfun_fund_cd;
               v_list.gibr_branch_cd := i.gibr_branch_cd;
               v_list.tran_seq_no := i.tran_seq_no;
               v_list.tran_date := i.tran_date;
               PIPE ROW(v_list);
            END LOOP; 
         END;   
      END IF;
   END validate_doc_seq_no;      
                        
END;
/



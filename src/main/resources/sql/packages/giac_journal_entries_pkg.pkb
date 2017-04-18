CREATE OR REPLACE PACKAGE BODY CPI.giac_journal_entries_pkg
AS

    FUNCTION get_journal_entry(
        p_tran_id giac_acctrans.tran_id%TYPE
    ) RETURN journal_entry_tab PIPELINED
    AS
      v_rec journal_entry_type;
    BEGIN
      FOR i IN
         (SELECT   a.tran_id, a.gfun_fund_cd, a.gibr_branch_cd, a.tran_year,
                   a.tran_month, a.tran_seq_no, a.tran_date, a.tran_flag,
                   a.jv_tran_tag, a.tran_class, a.tran_class_no,
                   a.jv_pref_suff, a.jv_no, a.create_by, a.ae_tag,
                   a.sap_inc_tag, a.upload_tag, a.particulars, a.user_id,
                   a.last_update, a.remarks, a.jv_tran_type, a.jv_tran_mm,
                   a.jv_tran_yy, a.ref_jv_no, b.branch_name, c.fund_desc,
                   c.grac_rac_cd, d.jv_tran_desc
              FROM giac_acctrans a,
                   giac_branches b,
                   giis_funds c,
                   giac_jv_trans d
             WHERE a.tran_id = p_tran_id
               AND a.tran_class = 'JV'
               AND b.branch_cd = a.gibr_branch_cd
               AND c.fund_cd = a.gfun_fund_cd
               AND d.jv_tran_cd(+) = a.jv_tran_type --nieko 03132017, SR 23985
      )
      LOOP
         v_rec.tran_id := i.tran_id;
         v_rec.gfun_fund_cd := i.gfun_fund_cd;
         v_rec.gibr_branch_cd := i.gibr_branch_cd;
         v_rec.tran_yy := i.tran_year;
         v_rec.tran_mm := i.tran_month;
         v_rec.tran_seq_no := i.tran_seq_no;
         v_rec.tran_date := i.tran_date;
         v_rec.tran_flag := i.tran_flag;
         v_rec.jv_tran_tag := i.jv_tran_tag;
         v_rec.tran_class := i.tran_class;
         v_rec.tran_class_no := i.tran_class_no;
         v_rec.jv_no := i.jv_no;
         v_rec.particulars := i.particulars;
         v_rec.user_id := i.user_id;
         v_rec.last_update := i.last_update;
         v_rec.remarks := i.remarks;
         v_rec.jv_tran_type := i.jv_tran_type;
         v_rec.jv_tran_desc := i.jv_tran_desc;
         v_rec.jv_tran_mm := i.jv_tran_mm;
         v_rec.jv_tran_yy := i.jv_tran_yy;
         v_rec.ref_jv_no := i.ref_jv_no;
         v_rec.jv_pref_suff := i.jv_pref_suff;
         v_rec.create_by := i.create_by;
         v_rec.ae_tag := i.ae_tag;
         v_rec.sap_inc_tag := i.sap_inc_tag;
         v_rec.upload_tag := i.upload_tag;

         BEGIN
            chk_char_ref_codes (i.tran_flag,
                                v_rec.mean_tran_flag,
                                'GIAC_ACCTRANS.TRAN_FLAG'
                               );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.mean_tran_flag := NULL;
         END;

         BEGIN
            chk_char_ref_codes (i.tran_class,
                                v_rec.mean_tran_class,
                                'GIAC_ACCTRANS.TRAN_CLASS'
                               );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.mean_tran_class := NULL;
         END;

         v_rec.branch_name := i.branch_name;
         v_rec.fund_desc := i.fund_desc;
         v_rec.grac_rac_cd := i.grac_rac_cd;
         PIPE ROW (v_rec);
      END LOOP;      
    END get_journal_entry;
    
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.19.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : for getting the Enter Journal Entries list
   */
   FUNCTION get_journal_entry_list (
       p_module_id 	    VARCHAR2,
       p_user_id	    GIIS_USERS.user_id%TYPE,
       p_fund_cd	    GIAC_ACCTRANS.gfun_fund_cd%TYPE,
       p_branch_cd	    GIAC_ACCTRANS.gibr_branch_cd%TYPE,
       p_branch_name    GIAC_BRANCHES.branch_name%TYPE,
       p_create_by      GIAC_ACCTRANS.create_by%TYPE,
       p_jv_no          GIAC_ACCTRANS.jv_no%TYPE,
       p_jv_pref_suff   GIAC_ACCTRANS.jv_pref_suff%TYPE,
       p_jv_tran_type   GIAC_ACCTRANS.jv_tran_type%TYPE,
       p_jv_tran_mm     GIAC_ACCTRANS.jv_tran_mm%TYPE,
       p_jv_tran_yy     GIAC_ACCTRANS.jv_tran_yy%TYPE,
       p_particulars    GIAC_ACCTRANS.particulars%TYPE,
       p_ref_jv_no      GIAC_ACCTRANS.ref_jv_no%TYPE,
       p_tran_date      VARCHAR2,
       p_tran_year      GIAC_ACCTRANS.tran_year%TYPE,
       p_tran_month     GIAC_ACCTRANS.tran_month%TYPE,
       p_tran_seq_no    GIAC_ACCTRANS.tran_seq_no%TYPE,
       p_filter_user_id GIAC_ACCTRANS.user_id%TYPE,
       p_tran_flag      GIAC_ACCTRANS.tran_flag%TYPE,
       p_order_by       VARCHAR2,
       p_asc_desc_flag  VARCHAR2, 
       p_from           NUMBER,
       p_to             NUMBER
   )
      RETURN journal_entry_tab PIPELINED
   AS
      v_user_id 	giis_users.user_id%TYPE := NULL;
      TYPE cur_type IS REF CURSOR;
      c cur_type;
      v_rec         journal_entry_type;
      v_sql         VARCHAR2(5000);   
   BEGIN
      FOR j IN (SELECT user_id
                  FROM giis_users
                 WHERE all_user_sw = 'N' AND user_id = p_user_id)
      LOOP
         v_user_id := p_user_id;
         EXIT;
      END LOOP;

    --nieko 03132017, SR 23985
    --removed AND a.jv_tran_type IS NOT NULL
    v_sql := 'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.* 
                                  FROM (
                                        SELECT a.tran_id, a.gfun_fund_cd, a.gibr_branch_cd, a.tran_year,
                                               a.tran_month, a.tran_seq_no, a.tran_date, a.tran_flag,
                                               a.jv_tran_tag, a.tran_class, a.tran_class_no,
                                               a.jv_pref_suff, a.jv_no, a.create_by, a.ae_tag,
                                               a.sap_inc_tag, a.upload_tag, a.particulars, a.user_id,
                                               a.last_update, a.remarks, a.jv_tran_type, a.jv_tran_mm,
                                               a.jv_tran_yy, a.ref_jv_no, b.branch_name
                                          FROM giac_acctrans a,
                                               giac_branches b
                                         WHERE a.tran_class = ''JV''
                                           AND b.branch_cd = a.gibr_branch_cd
                                           AND a.gibr_branch_cd IN (
                                                                   SELECT branch_cd
                                                                    FROM TABLE (security_access.get_branch_line (''AC'',
                                                                                                                 :p_module_id,
                                                                                                                 :p_user_id
                                                                                                                )
                                                                               ))                                       
                                      ';
                                 
      IF p_tran_flag IS NULL
      THEN
        v_sql := v_sql || ' AND a.tran_flag = ''O''';
      ELSE
        v_sql := v_sql || ' AND a.tran_flag = '''|| p_tran_flag||'''';
      END IF;                                

      IF v_user_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.user_id = '''||v_user_id||'''';
      END IF;
                                     
      IF p_filter_user_id IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.user_id) LIKE UPPER('''||p_filter_user_id||''')';
      END IF;

      IF p_fund_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.gfun_fund_cd) LIKE UPPER('''||p_fund_cd||''')';
      END IF;
                      
      IF p_branch_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.gibr_branch_cd) LIKE UPPER('''||p_branch_cd||''')';
      END IF;

      IF p_branch_name IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (b.branch_name) LIKE UPPER('''||p_branch_name||''')';
      END IF;

      IF p_create_by IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.create_by) LIKE UPPER('''||p_create_by||''')';
      END IF;

      IF p_jv_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.jv_no) LIKE UPPER('''||p_jv_no||''')';
      END IF;

      IF p_jv_pref_suff IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.jv_pref_suff) LIKE UPPER('''||p_jv_pref_suff||''')';
      END IF;

      IF p_jv_tran_type IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.jv_tran_type) LIKE UPPER('''||p_jv_tran_type||''')';
      END IF;

      IF p_jv_tran_mm IS NOT NULL
      THEN
        v_sql := v_sql || ' AND nvl(a.jv_tran_mm, a.tran_month) = '||p_jv_tran_mm; --nieko 03132017, SR 23985
      END IF;

      IF p_jv_tran_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND nvl(a.jv_tran_yy, a.tran_year) = '||p_jv_tran_yy; --nieko 03132017, SR 23985
      END IF;
      
      IF p_particulars IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(a.particulars) LIKE UPPER('''||p_particulars||''')';
      END IF;

      IF p_ref_jv_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(a.ref_jv_no) LIKE UPPER('''||p_ref_jv_no||''')';
      END IF;

      IF p_tran_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TO_CHAR(a.tran_date, ''MM-DD-YYYY'') = '''||p_tran_date||'''';
      END IF;

      IF p_tran_year IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.tran_year = '||p_tran_year;
      END IF;
      
      IF p_tran_month IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.tran_month = '||p_tran_month;
      END IF;

      IF p_tran_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.tran_seq_no = '||p_tran_seq_no;
      END IF;  
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'jvPrefSuff jvNo'
        THEN        
          v_sql := v_sql || ' ORDER BY a.jv_pref_suff '|| p_asc_desc_flag ||', a.jv_no ';
        ELSIF p_order_by = 'fundCd'
        THEN
          v_sql := v_sql || ' ORDER BY a.gfun_fund_cd ';
        ELSIF p_order_by = 'branchCd branchName'
        THEN
          v_sql := v_sql || ' ORDER BY a.gibr_branch_cd ';
        ELSIF p_order_by = 'tranYy tranMm tranSeqNo'
        THEN
          v_sql := v_sql || ' ORDER BY a.tran_year '|| p_asc_desc_flag ||', a.tran_month '|| p_asc_desc_flag ||', a.tran_seq_no ';
        ELSIF p_order_by = 'tranDate'
        THEN
          v_sql := v_sql || ' ORDER BY a.tran_date ';
        ELSIF p_order_by = 'jvTranType jvTranMm jvTranYy'
        THEN
          v_sql := v_sql || ' ORDER BY a.jv_tran_type '|| p_asc_desc_flag ||', a.jv_tran_yy '|| p_asc_desc_flag ||', a.jv_tran_yy ';
        ELSIF p_order_by = 'refJvNo'
        THEN
          v_sql := v_sql || ' ORDER BY a.ref_jv_no ';
        ELSIF p_order_by = 'particulars'
        THEN
          v_sql := v_sql || ' ORDER BY a.particulars ';
        ELSIF p_order_by = 'createBy'
        THEN
          v_sql := v_sql || ' ORDER BY a.create_by ';
        ELSIF p_order_by = 'filterUserId'
        THEN
          v_sql := v_sql || ' ORDER BY a.user_id ';
        END IF;

        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE
        v_sql := v_sql || ' ORDER BY a.tran_date DESC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;

      OPEN c FOR v_sql USING p_module_id, p_user_id;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.tran_id, 
                      v_rec.gfun_fund_cd, 
                      v_rec.gibr_branch_cd,
                      v_rec.tran_yy,
                      v_rec.tran_mm,
                      v_rec.tran_seq_no, 
                      v_rec.tran_date, 
                      v_rec.tran_flag, 
                      v_rec.jv_tran_tag, 
                      v_rec.tran_class,
                      v_rec.tran_class_no,
                      v_rec.jv_pref_suff,
                      v_rec.jv_no,
                      v_rec.create_by,
                      v_rec.ae_tag,
                      v_rec.sap_inc_tag,
                      v_rec.upload_tag,
                      v_rec.particulars,
                      v_rec.user_id,
                      v_rec.last_update,
                      v_rec.remarks,
                      v_rec.jv_tran_type,
                      v_rec.jv_tran_mm,
                      v_rec.jv_tran_yy,
                      v_rec.ref_jv_no,
                      v_rec.branch_name; 
         EXIT WHEN c%NOTFOUND;       
         
         BEGIN
            chk_char_ref_codes (v_rec.tran_flag,
                                v_rec.mean_tran_flag,
                                'GIAC_ACCTRANS.TRAN_FLAG'
                               );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.mean_tran_flag := NULL;
         END;    
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END;
   
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.20.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : when creating Journal Entries 
   */
   FUNCTION create_journal_entries (p_user_id giis_users.user_id%TYPE)
      RETURN journal_entry_tab PIPELINED
   AS
      v_entries          journal_entry_type;
      v_mean_tran_flag   VARCHAR2 (200);
   BEGIN
      v_entries.tran_class := 'JV';
      v_entries.last_update := SYSDATE;
      v_entries.user_id := p_user_id;
      v_entries.create_by := p_user_id;
      v_entries.tran_date := SYSDATE;
      v_entries.tran_mm := TO_NUMBER (TO_CHAR (SYSDATE, 'MM'));
      v_entries.tran_yy := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));

      SELECT SUBSTR (rv_meaning, 1, 8) rv_meaning
        INTO v_mean_tran_flag
        FROM cg_ref_codes
       WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG'
         AND SUBSTR (rv_low_value, 1, 1) = 'O';

      v_entries.tran_flag := 'O';
      v_entries.mean_tran_flag := v_mean_tran_flag;

      FOR c IN (SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_tag = 'NC')
      LOOP
         v_entries.jv_tran_type := c.jv_tran_cd;
         v_entries.jv_tran_desc := c.jv_tran_desc;
         EXIT;
      END LOOP;

      v_entries.jv_tran_mm := TO_NUMBER (TO_CHAR (SYSDATE, 'MM'));
      v_entries.jv_tran_yy := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));

      IF NVL (giacp.v ('SAP_INTEGRATION_SW'), 'N') = 'Y'
      THEN
         v_entries.sap_inc_tag := 'Y';
      ELSE
         v_entries.sap_inc_tag := 'N';
      END IF;
      
    BEGIN
        chk_char_ref_codes (v_entries.tran_class,
                            v_entries.mean_tran_class,
                            'GIAC_ACCTRANS.TRAN_CLASS'
                           );
     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
           v_entries.mean_tran_class := NULL;
     END;

      PIPE ROW (v_entries);
   END;

    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.21.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : use as a condition to enable or disable the OR Info button
   */
   FUNCTION check_or_info (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN VARCHAR2
   AS
      v_exist   NUMBER (9);
   BEGIN
      SELECT a.tran_id
        INTO v_exist
        FROM giac_acctrans a, giac_order_of_payts b
       WHERE a.tran_id = b.gacc_tran_id AND a.tran_id = p_tran_id;

      RETURN 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END;
   
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.03.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : use to set value for the objACGlobal.pBranchCd
   */
    FUNCTION get_p_branch_cd (p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2
   AS
      v_branch_cd   giis_user_grp_hdr.grp_iss_cd%TYPE;
   BEGIN
     SELECT b.grp_iss_cd
     INTO v_branch_cd
        FROM giis_users A, giis_user_grp_hdr b
        WHERE A.user_grp = b.user_grp 
            AND A.user_id = p_user_id;
      RETURN v_branch_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;
   
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.03.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : added as a condition to validate the Tran Date
   */
   FUNCTION get_closed_tag(p_fund_cd    giac_tran_mm.fund_cd%TYPE,
                           p_branch_cd  giac_tran_mm.branch_cd%TYPE,
  						   p_date       giac_acctrans.tran_date%TYPE)
    RETURN VARCHAR2 IS
               
    v_closed_tag  giac_tran_mm.closed_tag%TYPE;
                        
    BEGIN
      FOR a1 IN (SELECT closed_tag
                   FROM giac_tran_mm
                  WHERE fund_cd = p_fund_cd
                    AND branch_cd = p_branch_cd            
                    AND tran_yr = to_number(to_char(p_date, 'YYYY'))
                    AND tran_mm = to_number(to_char(p_date, 'MM'))) 
        LOOP
        v_closed_tag := a1.closed_tag;
        EXIT;
      END LOOP;          
           
      RETURN (v_closed_tag);
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.04.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : use as a condition when the Cancel button is click.
   */
   FUNCTION giacs003_check_comm_payts (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN VARCHAR2
   AS
    v_bill_nos  VARCHAR2(2000);
    v_ref_nos   VARCHAR2(2000);
    v_msg       VARCHAR2(2000) := '0';
   BEGIN
      FOR rec1 IN (SELECT DISTINCT gacc_tran_id, transaction_type, b140_iss_cd, b140_prem_seq_no
                        FROM giac_direct_prem_collns
                        WHERE gacc_tran_id      = p_tran_id
                            AND transaction_type IN (1,3)
                        ORDER BY 1,2,3,4)
                  LOOP
                      check_comm_payts(rec1.gacc_tran_id, rec1.b140_iss_cd, rec1.b140_prem_seq_no, v_bill_nos, v_ref_nos);
                          
                      IF v_bill_nos IS NOT NULL THEN
                          v_msg :='The commission of bill no. '||v_bill_nos||' was already settled. Please cancel the commission payment first before cancelling the J.V.'||CHR(13)||CHR(13)||
                                  'Reference No.: '||CHR(13)||
                                  v_ref_nos;
                      END IF;
                  END LOOP;
      RETURN v_msg;
   END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.25.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : for saving the record of the Enter Journal Entries
   */
    PROCEDURE set_giac_acctrans(p_tran_id			IN OUT VARCHAR2,
                                p_gfun_fund_cd	    IN VARCHAR2,
                                p_gibr_branch_cd	IN VARCHAR2,
                                p_tran_year		    IN NUMBER,
                                p_tran_month 		IN NUMBER,
                                p_tran_seq_no		IN NUMBER,
                                p_tran_date		    IN DATE,
                                p_tran_flag		    IN VARCHAR2,
                                p_jv_tran_tag		IN VARCHAR2,
                                p_tran_class		IN VARCHAR2,
                                --tran_class_no	GIAC_ACCTRANS.tran_class_no%TYPE,
                                --jv_no			GIAC_ACCTRANS.jv_no%TYPE,
                                p_particulars		IN VARCHAR2,
                                p_user_id			IN VARCHAR2,
                                --p_last_update		IN GIAC_ACCTRANS.last_update%TYPE,
                                p_remarks			IN VARCHAR2,
                                p_jv_tran_type	    IN VARCHAR2,
                                --jv_tran_desc	giac_jv_trans.jv_tran_desc%TYPE,
                                p_jv_tran_mm		IN NUMBER,
                                p_jv_tran_yy		IN NUMBER,
                                p_ref_jv_no		    IN VARCHAR2,
                                p_jv_pref_suff	    IN VARCHAR2,
                                p_create_by		    IN VARCHAR2,
                                p_ae_tag		    IN VARCHAR2,
                                p_sap_inc_tag		IN VARCHAR2,
                                p_upload_tag        IN VARCHAR2)
    AS
      v_count  NUMBER;
      v_giac_acctrans GIAC_ACCTRANS%ROWTYPE;
      v_exists  giac_acctrans.tran_id%TYPE;   --added by jeffdojello 02.26.2014
    BEGIN
      
	  giis_users_pkg.app_user := p_user_id; 
	  
     --------added by jeffdojello 02.26.2014--------
      BEGIN
          SELECT a.TRAN_ID
            INTO v_exists
            FROM giac_acctrans a
           WHERE a.tran_id    = p_tran_id;  
                      
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_giac_acctrans.tran_class_no := GIAC_SEQUENCE_GENERATION(p_gfun_fund_cd, p_gibr_branch_cd,
                 p_tran_class, p_tran_year, p_tran_month);

                v_giac_acctrans.jv_no := v_giac_acctrans.tran_class_no;
      END;
      ----------------------------------------------
      
      
      SELECT COUNT(*)
        INTO v_count
        FROM giis_funds
       WHERE fund_cd = p_gfun_fund_cd;
       
       IF v_count=0 THEN
        raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#A valid fund code must be entered.');
       END IF;
       SELECT COUNT(*)
        INTO v_count
        FROM giac_branches
       WHERE gfun_fund_cd = p_gfun_fund_cd
         AND branch_cd = p_gibr_branch_cd;

      IF v_count=0 THEN
         raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#A valid branch code must be entered.');
      END IF;
      
      v_giac_acctrans.JV_PREF_SUFF := 'JV';
      
        BEGIN
              IF (p_tran_id IS NULL) THEN
              DECLARE
                CURSOR C IS
                  SELECT  ACCTRAN_TRAN_ID_S.NEXTVAL
                  FROM    SYS.DUAL;
              BEGIN
                OPEN C;
                FETCH C
                INTO    v_giac_acctrans.tran_id;
                IF C%NOTFOUND THEN
                  raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#No row ACCTRAN_TRAN_ID_S in table SYS.DUAL.');
                END IF;
                CLOSE C;
              EXCEPTION
                WHEN OTHERS THEN
                  raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#Other errors were found.');
              END;
              END IF;
        END;
    v_giac_acctrans.last_update := SYSDATE;
    MERGE INTO giac_acctrans
         USING DUAL
         ON (tran_id = p_tran_id)
         WHEN NOT MATCHED THEN
            INSERT( tran_id,                        gfun_fund_cd,           gibr_branch_cd,   tran_year,        tran_month,
                    tran_seq_no,                    tran_date,              tran_flag,        jv_tran_tag,      tran_class,
                    tran_class_no,                  jv_no,                  particulars,      user_id,          last_update,
                    remarks,                        jv_tran_type,           jv_tran_mm,       jv_tran_yy,       ref_jv_no,
                    jv_pref_suff,                   create_by,              ae_tag,           sap_inc_tag,      upload_tag)  
            VALUES( v_giac_acctrans.tran_id,        p_gfun_fund_cd,         p_gibr_branch_cd, p_tran_year,      p_tran_month,
                    p_tran_seq_no,                  p_tran_date,            p_tran_flag,      p_jv_tran_tag,    p_tran_class,
                    v_giac_acctrans.tran_class_no,  v_giac_acctrans.jv_no,  p_particulars,    p_user_id,        v_giac_acctrans.last_update,
                    p_remarks,                      p_jv_tran_type,         p_jv_tran_mm,     p_jv_tran_yy,     p_ref_jv_no,
                    v_giac_acctrans.jv_pref_suff,   p_create_by,            p_ae_tag,         p_sap_inc_tag,    p_upload_tag)
         WHEN MATCHED THEN
             UPDATE
                SET gfun_fund_cd = p_gfun_fund_cd,
                    gibr_branch_cd = p_gibr_branch_cd,
                    tran_year = p_tran_year,
                    tran_month = p_tran_month,
                    tran_date = p_tran_date,
                    jv_tran_type = p_jv_tran_type,
                    jv_tran_mm = p_jv_tran_mm,
                    jv_tran_yy = p_jv_tran_yy,
                    ref_jv_no = p_ref_jv_no,
                    particulars = p_particulars,
                    remarks = p_remarks,
                    jv_tran_tag = p_jv_tran_tag,
                    sap_inc_tag = p_sap_inc_tag,
                    ae_tag = p_ae_tag,
                    user_id = p_user_id, --Modified by Jerome Bautista SR 4730 07.02.2015
                    create_by = p_create_by,
                    last_update = v_giac_acctrans.last_update
                ;
        IF (p_tran_id IS NULL) THEN
            p_tran_id := v_giac_acctrans.tran_id;  
        END IF;
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : Updates the record when the Cancel button is click.
   */
    PROCEDURE set_cancel_opt(p_tran_id			IN NUMBER,
                             p_gfun_fund_cd	    IN VARCHAR2,
                             p_gibr_branch_cd	IN VARCHAR2,
                             p_user_id          IN VARCHAR2,
                             p_jv_no            IN NUMBER,
                             p_msg              OUT VARCHAR2)
    AS
    v_dummy       NUMBER; 
    v_tran_id     giac_acctrans.tran_id%TYPE;
    BEGIN
      giis_users_pkg.app_user := p_user_id;
        UPDATE GIAC_ACCTRANS
        SET TRAN_FLAG = 'D'
            WHERE tran_id = p_tran_id;
        
        IF NVL(giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN                                                                           
                                  
                  BEGIN
                    SELECT count(*)
                      INTO v_dummy
                      FROM giac_advanced_payt
                     WHERE gacc_tran_id = p_tran_id
                       AND acct_ent_date IS NOT NULL;
                           
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_dummy := NULL;
               END;                                 
                             
                  IF v_dummy > 0 THEN
                                  
                       giac_journal_entries_pkg.insert_acctrans_cap(p_gfun_fund_cd,
                                                                    p_gibr_branch_cd,
                                                                    SYSDATE,
                                                                    'CAP',
                                                                    p_user_id,
                                                                    p_jv_no,
                                                                    v_tran_id);
                                                                                   
                     giac_journal_entries_pkg.aeg_parameters_rev(p_tran_id, 
                                                                 'GIACB005',
                                                                 p_gfun_fund_cd,
                                                                 p_gibr_branch_cd,
                                                                 v_tran_id,
                                                                 p_user_id);
               END IF;     
                            
            UPDATE giac_advanced_payt
               SET cancel_date      = SYSDATE, 
                   rev_gacc_tran_id = v_tran_id
             WHERE gacc_tran_id = p_tran_id;
        
            giac_journal_entries_pkg.delete_workflow_rec('CANCEL JV','GIACS003',p_user_id,p_tran_id);
            
            IF NVL(giacp.v('ENTER_PREPAID_COMM'),'N') = 'Y' THEN
                FOR a IN (SELECT 1
                    FROM giac_prepaid_comm
                        WHERE gacc_tran_id = p_tran_id
                            AND acct_ent_date IS NOT NULL)
                LOOP
                    giac_journal_entries_pkg.insert_acctrans_cap(p_gfun_fund_cd, 
                                                                 p_gibr_branch_cd,
                                                                 SYSDATE, 
                                                                 'PCC',
                                                                 p_user_id,
                                                                 p_jv_no,
                                                                 v_tran_id);
                    giac_journal_entries_pkg.aeg_parameters_rev(p_tran_id, 
                                                                'GIACB006',
                                                                 p_gfun_fund_cd,
                                                                 p_gibr_branch_cd,
                                                                 v_tran_id,
                                                                 p_user_id);
                    EXIT;
                END LOOP;
                                  
                UPDATE giac_prepaid_comm
                SET cancel_date      = SYSDATE,
                rev_gacc_tran_id = v_tran_id
                    WHERE gacc_tran_id     = p_tran_id;      
            END IF;
            
            p_msg := 'Journal Voucher (JV) cancellation procedure complete.';
                            
        END IF;    
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : Create records in acctrans. This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE insert_acctrans_cap(p_fund_cd         IN  giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                    p_branch_cd     IN  giac_order_of_payts.gibr_branch_cd%TYPE,
                                    p_rev_tran_date IN  giac_acctrans.tran_date%TYPE,
                                    p_tran_class    IN  giac_acctrans.tran_class%TYPE,
                                    p_user_id       IN  giis_users.user_id%TYPE,
                                    p_jv_no         IN  giac_acctrans.jv_no%TYPE,
                                    p_tran_id       OUT giac_acctrans.tran_id%TYPE) 
   IS 
      CURSOR c1 IS
        SELECT '1'
          FROM giis_funds
          WHERE fund_cd = p_fund_cd;

      CURSOR c2 IS 
        SELECT '2'
          FROM giac_branches
          WHERE branch_cd    = p_branch_cd
          AND gfun_fund_cd = p_fund_cd;

      v_c1             VARCHAR2(1);
      v_c2             VARCHAR2(1);
      v_tran_id        GIAC_ACCTRANS.tran_id%TYPE;
      v_last_update    GIAC_ACCTRANS.last_update%TYPE;
      v_user_id        GIAC_ACCTRANS.user_id%TYPE;
      v_closed_tag     GIAC_TRAN_MM.closed_tag%TYPE;
      v_tran_flag      giac_acctrans.tran_flag%TYPE;
      v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
      v_particulars    giac_acctrans.particulars%TYPE;
      v_tran_date      giac_acctrans.tran_date%TYPE;
      v_tran_year      giac_acctrans.tran_year%TYPE;
      v_tran_month     giac_acctrans.tran_month%TYPE; 
      v_tran_seq_no    GIAC_ACCTRANS.tran_seq_no%TYPE;
      
    BEGIN
    	
      OPEN c1;
      FETCH c1 INTO v_c1;  
        IF c1%NOTFOUND THEN
         raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#Invalid company code.');
        ELSE
          OPEN c2;
          FETCH c2 INTO  v_c2;  
            IF c2%NOTFOUND THEN
                raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#Invalid branch code.');
            END IF;
          CLOSE C2;
        END IF;
      CLOSE c1;
                
      -- If called by another form, display the corresponding OP 
      -- record of the current tran_id when the button OP Info is 
      -- pressed.
      
       BEGIN
          SELECT acctran_tran_id_s.nextval
            INTO p_tran_id
            FROM dual;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#ACCTRAN_TRAN_ID sequence not found.');
       END;
        
      v_user_id     := p_user_id;
      v_tran_date := p_rev_tran_date;
      v_tran_flag := 'C';
      v_user_id     := p_user_id;
      v_tran_year := TO_NUMBER(TO_CHAR(v_tran_date, 'YYYY'));
      v_tran_month := TO_NUMBER(TO_CHAR(v_tran_date, 'MM'));  
      v_tran_seq_no := giac_sequence_generation(
                                      p_fund_cd,
                                      p_branch_cd,
                                      'ACCTRAN_TRAN_SEQ_NO',
                                      v_tran_year,
                                      v_tran_month);
                                      
      v_tran_class_no := giac_sequence_generation(p_fund_cd,
                                                  p_branch_cd,
                                                  'REV',
                                                  0,
                                                  0);                                  
      
        v_particulars := 'Reversing entry of Premium deposit for JV' ||
                         TO_CHAR(p_jv_no) || '.';
              
      INSERT INTO giac_acctrans(tran_id, gfun_fund_cd, 
                                gibr_branch_cd, tran_date,
                                tran_flag, tran_class,
                                tran_class_no, particulars,
                                tran_year, tran_month, 
                                tran_seq_no, user_id, 
                                last_update)
       VALUES(p_tran_id, p_fund_cd,
              p_branch_cd, v_tran_date,
              v_tran_flag, p_tran_class,  --'CAP',  --replaced by jason 09032009 
              v_tran_class_no, v_particulars,
              v_tran_year, v_tran_month, 
              v_tran_seq_no, v_user_id, 
              v_last_update);
    END; 
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE AEG_Parameters_Rev(aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
                                 aeg_module_nm    GIAC_MODULES.module_name%TYPE,
                                 p_fund_cd        giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                 p_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
                                 p_tran_id        giac_acctrans.tran_id%TYPE,
                                 p_user_id        giis_users.user_id%TYPE) 
    AS
       v_module_id  giac_modules.module_id%TYPE;
       v_gen_type   giac_modules.generation_type%TYPE;
                                
      CURSOR colln_CUR IS 
                SELECT a.assd_no, b.line_cd,sum(premium_amt + tax_amt)coll_amt
                  FROM giac_advanced_payt a, gipi_polbasic b
                 WHERE gacc_tran_id = aeg_tran_id
                   AND a.policy_id = b.policy_id
                   AND a.acct_ent_date IS NOT NULL
              GROUP BY a.assd_no, b.line_cd;
      
      --jason 09022009: added the following cursor for the prepaid comm 
        CURSOR prep_comm_CUR IS
        SELECT a.intm_no, b.line_cd,
               SUM((a.comm_amt + a.input_vat_amt) - a.wtax_amt) net_comm
          FROM GIAC_PREPAID_COMM a, GIPI_POLBASIC b
         WHERE gacc_tran_id    = aeg_tran_id
           AND a.policy_id     = b.policy_id
           AND a.acct_ent_date IS NOT NULL
         GROUP BY a.intm_no, b.line_cd;

    BEGIN

      BEGIN
            SELECT module_id,
                 generation_type
            INTO  v_module_id,
                v_gen_type
            FROM giac_modules
            WHERE module_name  = aeg_module_nm; --'GIACB005'; --replaced by jason 09032009: used the existing parameter for the module name
        	
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#No data found in GIAC MODULES.');
      END;

      AEG_Delete_Entries_Rev(aeg_tran_id,v_gen_type);       
           
      IF aeg_module_nm = 'GIACB005' THEN     
        FOR COLLN_rec in COLLN_CUR LOOP
          giac_journal_entries_pkg.create_rev_entries(COLLN_rec.assd_no, 
                                                        COLLN_rec.coll_amt, 
                                                        COLLN_rec.line_cd, 
                                                        'GIACB005',
                                                        p_fund_cd,
                                                        p_branch_cd,
                                                        p_tran_id,
                                                        p_user_id) ;
        END LOOP;
        
      ELSIF aeg_module_nm = 'GIACB006' THEN  
        FOR comm_rec IN prep_comm_CUR LOOP
          giac_journal_entries_pkg.create_rev_entries(comm_rec.intm_no, 
                                                        comm_rec.net_comm, 
                                                        comm_rec.line_cd, 
                                                        'GIACB006',
                                                        p_fund_cd,
                                                        p_branch_cd,
                                                        p_tran_id,
                                                        p_user_id);
        END LOOP;

      END IF;         
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE create_rev_entries(p_assd_no          GIPI_POLBASIC.assd_no%TYPE,
                                 p_coll_amt             GIAC_COMM_PAYTS.comm_amt%TYPE,
                                 p_line_cd              giis_line.line_cd%TYPE,
                                 p_module_name          giac_modules.module_name%TYPE,
                                 p_fund_cd              giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                 p_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
                                 p_tran_id              giac_acctrans.tran_id%TYPE,
                                 p_user_id              giis_users.user_id%TYPE)
    IS
        x_intm_no       	GIIS_INTERMEDIARY.intm_no%TYPE;
        w_sl_cd         	GIAC_ACCT_ENTRIES.sl_cd%TYPE;
        y_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE;
        z_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE;

        V_GL_ACCT_CATEGORY  GIAC_ACCT_ENTRIES.GL_ACCT_CATEGORY%TYPE; 
        V_GL_CONTROL_ACCT   GIAC_ACCT_ENTRIES.GL_CONTROL_ACCT%TYPE;
        v_gl_sub_acct_1  	GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2  	GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        v_gl_sub_acct_3  	GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4  	GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5  	GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6  	GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7  	GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

        v_intm_type_level  	GIAC_MODULE_ENTRIES.INTM_TYPE_LEVEL%TYPE;
        v_LINE_DEPENDENCY_LEVEL   GIAC_MODULE_ENTRIES.LINE_DEPENDENCY_LEVEL%TYPE;
        v_dr_cr_tag         GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
        v_debit_amt   	GIAC_ACCT_ENTRIES.debit_amt%TYPE;
        v_credit_amt  	GIAC_ACCT_ENTRIES.credit_amt%TYPE;
        v_acct_entry_id 	GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
        v_gen_type      	GIAC_MODULES.generation_type%TYPE;
        v_gl_acct_id    	GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
        v_sl_type_cd    	GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;--07/31/99 JEANNETTE
        v_sl_type_cd2    	GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
        v_sl_type_cd3    	GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
        ws_line_cd	    	GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        v_gl_intm_no        GIAC_COMM_PAYTS.intm_no%TYPE;
        v_gl_assd_no        GIPI_POLBASIC.assd_no%TYPE;
        v_gl_acct_line_cd   GIIS_LINE.acct_line_cd%TYPE; 
        ws_acct_intm_cd     GIIS_INTM_TYPE.acct_intm_cd%TYPE;
        --v_gl_lsp            VARCHAR2;
        
    BEGIN 
        BEGIN 	--c1
            SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
                     NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                     NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0),
                       A.dr_cr_tag,B.generation_type,A.sl_type_cd,A.LINE_DEPENDENCY_LEVEL  
            INTO   V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
                     V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
                   V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7, V_INTM_TYPE_LEVEL,
                       v_dr_cr_tag,v_gen_type, v_sl_type_cd, v_LINE_DEPENDENCY_LEVEL  
            FROM  	GIAC_MODULE_ENTRIES A, GIAC_MODULES B
            WHERE 	B.module_name = p_module_name  --'GIACB005'   --replaced by jason 09032009
            AND   	A.item_no = 1
            AND   	B.module_id = A.module_id; 
       
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.');
        END;	--c2
     
        giac_journal_entries_pkg.aeg_check_chart_of_accts(v_gl_acct_category,
                                                            v_gl_control_acct,
                                                            v_gl_sub_acct_1, 
                                                            v_gl_sub_acct_2,
                                                            v_gl_sub_acct_3, 
                                                            v_gl_sub_acct_4,
                                                            v_gl_sub_acct_5, 
                                                            v_gl_sub_acct_6,
                                                            v_gl_sub_acct_7,
                                                            v_gl_acct_id);   

         IF  p_coll_amt > 0 THEN  		--3.1               
             
              IF v_dr_cr_tag = 'D' THEN
                v_debit_amt  := 0;
                v_credit_amt := p_coll_amt;
              ELSE
                v_debit_amt  := p_coll_amt;
                v_credit_amt := 0;
            END IF;  

         ELSIF p_coll_amt < 0 THEN
          
            IF v_dr_cr_tag = 'D' THEN
               v_debit_amt := p_coll_amt * -1;
               v_credit_amt := 0;
            ELSE
                 v_debit_amt  := 0;
               v_credit_amt := p_coll_amt * -1;
            END IF;    

         END IF;				--3.2

     
       giac_journal_entries_pkg.aeg_insert_update_entries_rev(v_gl_acct_category, 
                                                              v_gl_control_acct,
                                                              v_gl_sub_acct_1,
                                                              v_gl_sub_acct_2,
                                                              v_gl_sub_acct_3,
                                                              v_gl_sub_acct_4,
                                                              v_gl_sub_acct_5,
                                                              v_gl_sub_acct_6,
                                                              v_gl_sub_acct_7, 
                                                              v_sl_type_cd,
                                                              '1',
                                                              p_assd_no, 
                                                              v_gen_type, 
                                                              v_gl_acct_id, 
                                                              v_debit_amt, 
                                                              v_credit_amt,
                                                              p_fund_cd,
                                                              p_branch_cd,
                                                              p_tran_id,
                                                              p_user_id);

        BEGIN	--e1


            BEGIN
                     
                SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
                        NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                        NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.LINE_DEPENDENCY_LEVEL,0), A.dr_cr_tag,
                        B.generation_type 
                INTO   	V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
                        V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
                        V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_LINE_DEPENDENCY_LEVEL, v_dr_cr_tag,
                        v_gen_type
                FROM  GIAC_MODULE_ENTRIES A, GIAC_MODULES B
                WHERE B.module_name = p_module_name  --'GIACB005'   --replaced by jason 09032009
                AND   A.item_no     = 2
                AND   B.module_id   = A.module_id; 

               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.');
            END;	--e2

          
             IF v_LINE_DEPENDENCY_LEVEL != 0 THEN  	--2.1  
             
                    BEGIN	--d1
                        SELECT acct_line_cd
                            INTO ws_line_cd
                            FROM giis_line
                        WHERE line_cd = p_line_cd;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#No data found in giis_line.');
                    END;	--d2
             
                giac_journal_entries_pkg.aeg_check_level(v_LINE_DEPENDENCY_LEVEL , ws_line_cd,
                                                          v_gl_sub_acct_1         , v_gl_sub_acct_2,
                                                          v_gl_sub_acct_3         , v_gl_sub_acct_4,
                                                          v_gl_sub_acct_5         , v_gl_sub_acct_6,
                                                          v_gl_sub_acct_7);
              END IF;
          
                            	
            giac_journal_entries_pkg.aeg_check_chart_of_accts(	v_gl_acct_category,
                                                                v_gl_control_acct,
                                                                v_gl_sub_acct_1, 
                                                                v_gl_sub_acct_2,
                                                                v_gl_sub_acct_3, 
                                                                v_gl_sub_acct_4,
                                                                v_gl_sub_acct_5, 
                                                                v_gl_sub_acct_6,
                                                                v_gl_sub_acct_7,
                                                                v_gl_acct_id);   
                                     	

            IF  p_coll_amt > 0 THEN   	---- 4.1              

                IF v_dr_cr_tag = 'D' THEN
                    v_debit_amt  := 0;
                    v_credit_amt := p_coll_amt;
                ELSE
                    v_debit_amt  := p_coll_amt;
                    v_credit_amt := 0;
                END IF;  

            ELSIF p_coll_amt < 0 THEN

                IF v_dr_cr_tag = 'D' THEN
                    v_debit_amt  := p_coll_amt * -1;
                    v_credit_amt := 0;
                ELSE
                    v_debit_amt  := 0;
                    v_credit_amt := p_coll_amt * -1;
                END IF;

            END IF;		

            giac_journal_entries_pkg.aeg_insert_update_entries_rev(v_gl_acct_category, 
                                                                   v_gl_control_acct,
                                                                   v_gl_sub_acct_1,
                                                                   v_gl_sub_acct_2,
                                                                   v_gl_sub_acct_3,
                                                                   v_gl_sub_acct_4,
                                                                   v_gl_sub_acct_5,
                                                                   v_gl_sub_acct_6,
                                                                   v_gl_sub_acct_7,
                                                                   v_sl_type_cd,
                                                                   '1', 
                                                                   p_assd_no, 
                                                                   v_gen_type, 
                                                                   v_gl_acct_id, 
                                                                   v_debit_amt, 
                                                                   v_credit_amt,
                                                                   p_fund_cd,
                                                                   p_branch_cd,
                                                                   p_tran_id,
                                                                   p_user_id);  

          END;
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE aeg_check_chart_of_accts(cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                         cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                         cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                         cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                         cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                         cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                         cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                         cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                         cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                         cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE ) 
    IS

    BEGIN
      SELECT DISTINCT(gl_acct_id)
        INTO cca_gl_acct_id
        FROM giac_chart_of_accts
       WHERE gl_acct_category  = cca_gl_acct_category
         AND gl_control_acct   = cca_gl_control_acct
         AND gl_sub_acct_1     = cca_gl_sub_acct_1
         AND gl_sub_acct_2     = cca_gl_sub_acct_2
         AND gl_sub_acct_3     = cca_gl_sub_acct_3
         AND gl_sub_acct_4     = cca_gl_sub_acct_4
         AND gl_sub_acct_5     = cca_gl_sub_acct_5
         AND gl_sub_acct_6     = cca_gl_sub_acct_6
         AND gl_sub_acct_7     = cca_gl_sub_acct_7;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#GL account code '||to_char(cca_gl_acct_category)
                    ||'-'||to_char(cca_gl_control_acct,'09') 
                    ||'-'||to_char(cca_gl_sub_acct_1,'09')
                    ||'-'||to_char(cca_gl_sub_acct_2,'09')
                    ||'-'||to_char(cca_gl_sub_acct_3,'09')
                    ||'-'||to_char(cca_gl_sub_acct_4,'09')
                    ||'-'||to_char(cca_gl_sub_acct_5,'09')
                    ||'-'||to_char(cca_gl_sub_acct_6,'09')
                    ||'-'||to_char(cca_gl_sub_acct_7,'09')
                    ||' does not exist in Chart of Accounts (Giac_Acctrans).');
    END;
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE aeg_insert_update_entries_rev(iuae_gl_acct_category   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                             iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                             iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                             iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                             iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                             iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                             iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                             iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                             iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                             iuae_sl_type_cd	    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
                                             iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
                                             iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                                             iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
                                             iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                             iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                                             iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                                             p_fund_cd              giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                             p_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
                                             p_tran_id              giac_acctrans.tran_id%TYPE,
                                             p_user_id              giis_users.user_id%TYPE) 
    IS
      
     iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

     
    BEGIN
     
       SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
      --   AND sl_type_cd          = iuae_sl_type_cd /*comment-out by mbb*/
        AND NVL(sl_cd,1)         = NVL(iuae_sl_cd,1)
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = p_branch_cd
         AND gacc_gfun_fund_cd   = p_fund_cd
         AND gacc_tran_id        = p_tran_id;

        IF NVL(iuae_acct_entry_id,0) = 0 THEN

            iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

            INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                          gacc_gibr_branch_cd, acct_entry_id    ,
                                          gl_acct_id         , gl_acct_category ,
                                          gl_control_acct    , gl_sub_acct_1    ,
                                          gl_sub_acct_2      , gl_sub_acct_3    ,
                                          gl_sub_acct_4      , gl_sub_acct_5    ,
                                          gl_sub_acct_6      , gl_sub_acct_7    ,
                                          sl_type_cd         , sl_source_cd     ,
                                          sl_cd              , debit_amt        ,
                                          credit_amt         , generation_type  ,
                                          user_id            , last_update)
               VALUES (p_tran_id  , p_fund_cd,
                       p_branch_cd, iuae_acct_entry_id          ,
                       iuae_gl_acct_id               , iuae_gl_acct_category       ,
                       iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                       iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                       iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                       iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                       iuae_sl_type_cd               , '1'                         ,
                       iuae_sl_cd                    , iuae_debit_amt              ,
                       iuae_credit_amt               , iuae_generation_type        ,
                       p_user_id             , SYSDATE);
         
         ELSE
            UPDATE giac_acct_entries
               SET debit_amt  =  iuae_debit_amt + debit_amt,
                   credit_amt =  iuae_credit_amt + credit_amt 
             WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
               AND gl_sub_acct_2       = iuae_gl_sub_acct_2
               AND gl_sub_acct_3       = iuae_gl_sub_acct_3
               AND gl_sub_acct_4       = iuae_gl_sub_acct_4
               AND gl_sub_acct_5       = iuae_gl_sub_acct_5
               AND gl_sub_acct_6       = iuae_gl_sub_acct_6
               AND gl_sub_acct_7       = iuae_gl_sub_acct_7
             --  AND sl_type_cd          = iuae_sl_type_cd
               AND nvl(sl_cd,1)       =  nvl(iuae_sl_cd,1)
               AND generation_type     = iuae_generation_type
               AND gl_acct_id          = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = p_branch_cd
               AND gacc_gfun_fund_cd   = p_fund_cd
               AND gacc_tran_id        = p_tran_id;
          END IF;
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure determines the GL Account code that will handle the      *
   ** line number, intermediary number and old/new account code. This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE aeg_check_level(cl_level         IN NUMBER,
                              cl_value         IN NUMBER,
                              cl_sub_acct1 IN OUT NUMBER,
                              cl_sub_acct2 IN OUT NUMBER,
                              cl_sub_acct3 IN OUT NUMBER,
                              cl_sub_acct4 IN OUT NUMBER,
                              cl_sub_acct5 IN OUT NUMBER,
                              cl_sub_acct6 IN OUT NUMBER,
                              cl_sub_acct7 IN OUT NUMBER) IS
    BEGIN
    --msg_alert('AEG CHECK LEVEL...','I',FALSE);
      IF cl_level = 1 THEN
        cl_sub_acct1 := cl_value;
      ELSIF cl_level = 2 THEN
        cl_sub_acct2 := cl_value;
      ELSIF cl_level = 3 THEN
        cl_sub_acct3 := cl_value;
      ELSIF cl_level = 4 THEN
        cl_sub_acct4 := cl_value;
      ELSIF cl_level = 5 THEN
        cl_sub_acct5 := cl_value;
      ELSIF cl_level = 6 THEN
        cl_sub_acct6 := cl_value;
      ELSIF cl_level = 7 THEN
        cl_sub_acct7 := cl_value;
      END IF;
    END;

    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Cancel JV
   **  Description  : This procedure is use in GIAC_JOURNAL_ENTRIES_PKG. set_cancel_opt
   */
    PROCEDURE delete_workflow_rec(p_event_desc  IN VARCHAR2,
                                  p_module_id  IN VARCHAR2,
                                  p_user       IN VARCHAR2,
                                  p_col_value IN VARCHAR2) IS
      v_tran_id            gipi_user_events.tran_id%TYPE;                              
    BEGIN

      FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd 
                        FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                       WHERE 1=1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                         --AND b.userid = p_user
                       AND a.module_id = p_module_id
                       AND a.event_cd = d.event_cd
                       AND UPPER(d.event_desc) = UPPER(NVL(p_event_desc,d.event_desc)))
      LOOP
        FOR B_REC IN ( SELECT b.col_value, b.tran_id , b.event_col_cd, b.event_user_mod, b.switch, b.user_id
                           FROM gipi_user_events b 
                          WHERE b.event_user_mod = a_rec.event_user_mod 
                          AND b.event_col_cd = a_rec.event_col_cd )
          LOOP
            IF b_rec.col_value = p_col_value THEN
               BEGIN

               INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
                    VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, SYSDATE, p_user, '-'); 

               DELETE FROM gipi_user_events
                     WHERE event_user_mod = b_rec.event_user_mod
                       AND event_col_cd = b_rec.event_col_cd
                       AND tran_id = b_rec.tran_id;
                   
               END;
            ELSE	
              IF b_rec.switch = 'N' AND b_rec.user_id = p_user THEN
               UPDATE gipi_user_events
                  SET switch = 'Y'
                WHERE event_user_mod = b_rec.event_user_mod
                  AND event_col_cd = b_rec.event_col_cd
                  AND tran_id = b_rec.tran_id;
              END IF;    	   
            END IF;  
          END LOOP;
    	  
      END LOOP;
      
    END;
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.25.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : LOV for JV Tran Type
   */
    FUNCTION get_jv_tran_type_lov(p_jv_tran_tag      GIAC_ACCTRANS.jv_tran_tag%TYPE)
    RETURN jv_tran_type_lov_tab PIPELINED IS
	  v_list			jv_tran_type_lov_type;
	BEGIN
	  FOR i IN (SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_tag = p_jv_tran_tag)
	  LOOP
		v_list.jv_tran_cd		  := i.jv_tran_cd;
		v_list.jv_tran_desc		  := i.jv_tran_desc;
	    PIPE ROW(v_list);
	  END LOOP;
	END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : Use as condition in the function in the enterJournalEntries.jsp called printJV()
   */
    FUNCTION print_opt(p_tran_id	GIAC_ACCTRANS.tran_id%TYPE)
    RETURN print_opt_tab PIPELINED IS
    v_list  print_opt_type;
    BEGIN
        FOR a IN (SELECT SUM(debit_amt) debit_amt, SUM(credit_amt) credit_amt
                  FROM   giac_acct_entries
                  WHERE  gacc_tran_id = p_tran_id)      
        LOOP
            v_list.debit_amt  := a.debit_amt;
            v_list.credit_amt := a.credit_amt;
            PIPE ROW(v_list);
        EXIT;    
        END LOOP;
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : Use as condition in the function in the enterJournalEntries.jsp called showDetails()
   */   
    FUNCTION  get_detail_module(p_tran_id	GIAC_ACCTRANS.tran_id%TYPE) 
    RETURN VARCHAR2
    IS
        dummy NUMBER;
        v_module_id VARCHAR2(10);
    BEGIN
         BEGIN     
        SELECT  1
            INTO dummy
            FROM GIAC_PAYT_REQUESTS_DTL A,
                 GIAC_PAYT_REQUESTS B
                WHERE   A.GPRQ_REF_ID = B.REF_ID
                AND     A.TRAN_ID = p_tran_id; 
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#TRAN ID DOES NOT EXIST.');
         END;

         BEGIN
          SELECT 1
          INTO   dummy
          FROM GIAC_DISB_VOUCHERS 
          WHERE GACC_TRAN_ID = p_tran_id;
         EXCEPTION
          WHEN NO_DATA_FOUND THEN
               dummy := 0;
         END;
         
         IF dummy = 1 THEN
          v_module_id := 'DETAILS';
         ELSE
          v_module_id := 'DISB_REQ';
         END IF;
       RETURN v_module_id;
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : Use as condition in the function in the enterJournalEntries.jsp called showDVInfo()
   */  
   PROCEDURE show_dv_info(p_tran_id      IN NUMBER,
                          p_formcall    IN OUT VARCHAR2,
                          p_dv_tag      IN OUT VARCHAR2,
                          p_cancel_dv   IN OUT VARCHAR2,
                          p_ref_id      IN OUT VARCHAR2,
                          p_payt_request_menu IN OUT VARCHAR2,
                          p_cancel_req        IN OUT VARCHAR2) IS
        V_DV_TAG  VARCHAR2(1);                              
    BEGIN
        SELECT DV_TAG
        INTO   V_DV_TAG
            FROM GIAC_ACCTRANS A,GIAC_DISB_VOUCHERS B
                WHERE A.TRAN_ID = B.GACC_TRAN_ID
                    AND   B.GACC_TRAN_ID = p_tran_id;
            BEGIN
                IF V_DV_TAG = '*' THEN
                    p_dv_tag := 'M';
                ELSIF V_DV_TAG IS NULL THEN
                    p_dv_tag := NULL;
                    p_cancel_dv:='N';
                END IF;
                p_formcall:='GIACS002';
            END;
        /***TRAN_ID IN GIAC_ACCTRANS BUT NOT IN GIAC_DISB_VOUCHERS***/ 
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN    
                SELECT  B.REF_ID
                INTO    p_ref_id  
                    FROM    GIAC_PAYT_REQUESTS_DTL A,
                            GIAC_PAYT_REQUESTS B
                        WHERE   A.GPRQ_REF_ID = B.REF_ID
                            AND     A.TRAN_ID = p_tran_id;
                giac_journal_entries_pkg.get_payt_request_menu(p_tran_id,p_payt_request_menu,p_cancel_req);
                p_formcall := 'GIACS016';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --p_ref_id := 24093;
                --p_formcall := 'GIACS016';
               raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#TRAN ID DOES NOT EXIST.');
            END; 
    END;
    
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.05.2013
   **  Reference By : GIACS003 - Enter Journal Entries
   **  Description  : This procedure is use in show_dv_info
   */ 
    PROCEDURE get_payt_request_menu(p_tran_id           IN NUMBER,
                                    p_payt_request_menu OUT VARCHAR2,
                                    p_cancel_req        OUT VARCHAR2) 
    IS
    BEGIN
      SELECT c.param_name
      INTO   p_payt_request_menu
      FROM 	 giac_payt_requests_dtl a,
             giac_payt_requests b,
             giac_parameters  c,
             giac_acctrans d
      WHERE  a.tran_id = d.tran_id
      AND    a. tran_id  = p_tran_id
      AND    a.gprq_ref_id =b.ref_id
      AND    b.document_cd = c.param_value_v;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        p_payt_request_menu := null;
        p_cancel_req := 'N';
    END;

    /*
    ** Created by: John Daniel
    ** Date Created: 05.20.2016
    ** Referenced By: GIACS003 - Cancel JV
    ** Description: Used to check if JV selected can be canceled
    */
    FUNCTION validate_jv_cancel(p_tran_id   NUMBER) 
    RETURN VARCHAR2
    AS
        v_msg               VARCHAR2(2000) := 'Y'; --edited by MarkS 8.1.2016 SR-5580
        v_tran_type         GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE%TYPE := 0;
        v_iss_cd            GIAC_DIRECT_PREM_COLLNS.B140_ISS_CD%TYPE;
        v_prem_seq_no       GIAC_DIRECT_PREM_COLLNS.B140_PREM_SEQ_NO%TYPE;
        v_tran_id           GIAC_DIRECT_PREM_COLLNS.GACC_TRAN_ID%TYPE;
        v_exist             NUMBER;
        v_bill_nos          VARCHAR2(2000);
        v_ref_nos           VARCHAR2(2000);
        
    BEGIN
        FOR i IN (
            SELECT DISTINCT gacc_tran_id, b140_iss_cd, b140_prem_seq_no, transaction_type
            FROM GIAC_DIRECT_PREM_COLLNS --a, GIAC_ACCTRANS b
            WHERE gacc_tran_id = p_tran_id
            --AND a.gacc_tran_id = b.tran_id
            --AND b.tran_flag = 'C'
        )
        LOOP
            --v_bill_no := i.bill_no;
            v_iss_cd := i.b140_iss_cd;
            v_prem_seq_no := i.b140_prem_seq_no;
            v_tran_type := i.transaction_type;
            v_tran_id := i.gacc_tran_id;
        END LOOP;
        --edited by MarkS 8.1.2016 SR-5580
        IF v_iss_cd IS NOT NULL AND v_prem_seq_no IS NOT NULL
        THEN
          check_comm_payts2(v_tran_id,
                            v_iss_cd,
                            v_prem_seq_no,
                            v_bill_nos,
                            v_ref_nos,
                            v_exist);
                            
          IF v_exist = 1 THEN
              v_msg := 'Geniisys Exception#I#The commission of bill no. '||v_bill_nos||' was already settled. ' ||
                       '<br>Please cancel the commission payment first before cancelling the J.V.<br>'||
                       'Reference No./s: <br>'|| v_ref_nos;
          ELSIF v_exist = 2 THEN
              v_msg := 'Geniisys Exception#I#The commission of bill no. '||v_bill_nos||' was already reversed. ' ||
                       '<br>Please cancel the reversal first before cancelling the J.V.<br>'||
                       'Reference No./s: <br>'|| v_ref_nos;
          
          END IF;
        END IF;

        RETURN v_msg; 
    EXCEPTION
    	WHEN OTHERS THEN
    		v_msg := SQLERRM || 'in validate_jv_cancel';
            RETURN v_msg; 	
    END validate_jv_cancel; 
END;
/

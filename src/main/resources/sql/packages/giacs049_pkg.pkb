CREATE OR REPLACE PACKAGE BODY CPI.GIACS049_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   06.03.2013
     ** Referenced By:  GIACS049 - Update Check Number
     **/
     
    FUNCTION get_company_lov(
        p_keyword   VARCHAR2
    ) RETURN company_lov_tab PIPELINED
    AS
        lov     company_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.gibr_gfun_fund_cd, (SELECT fund_desc 
                                                          FROM giis_funds 
                                                         WHERE fund_cd = a.gibr_gfun_fund_cd) fund_desc  
                    FROM giac_disb_vouchers a, giac_chk_disbursement b 
                   WHERE 1 = 1 
                     AND a.gacc_tran_id = b.gacc_tran_id 
                     AND a.print_tag = 6 
                     AND b.check_stat = 2
                     AND UPPER(a.GIBR_GFUN_FUND_CD) LIKE UPPER(NVL(p_keyword ||'%', '%')) )
        LOOP
            lov.gibr_gfun_fund_cd   := i.gibr_gfun_fund_cd;
            lov.fund_desc           := i.fund_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_company_lov;
    
    
    FUNCTION get_branch_lov(
        p_keyword       VARCHAR2,
        p_user_id       giis_users.user_id%TYPE --steven 09.30.2014
    ) RETURN branch_lov_tab PIPELINED
    AS
        lov     branch_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT  a.gibr_branch_cd, (SELECT iss_name 
                                                        FROM giis_issource 
                                                       WHERE iss_cd = a.gibr_branch_cd) branch_name 
                    FROM giac_disb_vouchers a, giac_chk_disbursement b 
                   WHERE 1 = 1 
                     AND a.gacc_tran_id = b.gacc_tran_id 
                     AND a.print_tag = 6 
                     AND b.check_stat = 2
                     AND UPPER(a.gibr_branch_cd) LIKE UPPER(NVL(p_keyword ||'%', '%'))
                     AND (   EXISTS ( --added by steven 09.30.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = a.gibr_branch_cd
                             AND c.module_id = 'GIACS049'
                             AND a.user_id = b2.userid
                             AND d.userid = a.user_id
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                    OR EXISTS (
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_grp_dtl b2,
                                 giis_modules_tran c,
                                 giis_user_grp_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = a.gibr_branch_cd
                             AND c.module_id = 'GIACS049'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                   ))
        LOOP
            lov.gibr_branch_cd  := i.gibr_branch_cd;
            lov.branch_name     := i.branch_name;
        
            PIPE ROW(lov);
        END LOOP;
    END get_branch_lov;

    
    FUNCTION GET_DV_LIST(
        p_gibr_gfun_fund_cd     giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd        giac_disb_vouchers.GIBR_BRANCH_CD%type
    ) RETURN dv_list_tab PIPELINED
    AS
        rec     dv_list_type;
    BEGIN
        FOR i IN  ( SELECT DISTINCT a.gibr_gfun_fund_cd, (SELECT fund_desc 
                                                            FROM giis_funds 
                                                           WHERE fund_cd = a.gibr_gfun_fund_cd) fund_desc, 
                                    a.gibr_branch_cd, (SELECT iss_name 
                                                         FROM giis_issource 
                                                        WHERE iss_cd = a.gibr_branch_cd) branch_name 
                      FROM giac_disb_vouchers a, 
                           giac_chk_disbursement b 
                     WHERE 1 = 1 
                       AND a.gacc_tran_id = b.gacc_tran_id 
                       AND a.print_tag = 6 
                       AND b.check_stat LIKE '2' 
                       AND NVL(b.disb_mode,'C') ='C' 
                       AND a.GIBR_GFUN_FUND_CD = p_gibr_gfun_fund_cd
                       AND a.GIBR_BRANCH_CD = p_gibr_branch_cd )
        LOOP
            FOR j IN  ( SELECT a.gacc_tran_id, a.gibr_gfun_fund_cd, a.gibr_branch_cd, a.dv_pref, 
                               a.dv_no, b.check_date, c.document_cd, c.branch_cd, c.line_cd, 
                               c.doc_year, c.doc_mm, c.doc_seq_no, b.check_pref_suf, b.check_no, 
                               a.payee, a.particulars, b.user_id, b.last_update,
                               b.item_no --added by jeffdojello 12.16.2013 
                          FROM giac_disb_vouchers a, 
                               giac_chk_disbursement b, 
                               giac_payt_requests c 
                         WHERE 1 = 1 
                           AND a.gacc_tran_id = b.gacc_tran_id 
                           AND a.gprq_ref_id = c.ref_id 
                           AND a.print_tag = 6 
                           AND b.check_stat LIKE '2' 
                           AND NVL(b.disb_mode,'C') ='C' 
                           AND a.GIBR_GFUN_FUND_CD = i.gibr_gfun_fund_cd
                           AND a.GIBR_BRANCH_CD = i.gibr_branch_cd 
                         ORDER BY a.dv_pref, a.dv_no)
            LOOP
                rec.gacc_tran_id        := j.gacc_tran_id;
                rec.gibr_gfun_fund_cd   := j.gibr_gfun_fund_cd;
                rec.gibr_branch_cd      := j.gibr_branch_cd;
                rec.dv_pref             := j.dv_pref;
                rec.dv_no               := j.dv_no;
                rec.check_date          := j.check_date;
                rec.document_cd         := j.document_cd;
                rec.branch_cd           := j.branch_cd;
                rec.line_cd             := j.line_cd;
                rec.doc_year            := j.doc_year;
                rec.doc_mm              := j.doc_mm;
                rec.doc_seq_no          := j.doc_seq_no;
                rec.check_pref_suf      := j.check_pref_suf;
                rec.check_no            := j.check_no;
                rec.chk_no              := j.check_pref_suf || '-' || j.check_no;
                rec.payee               := j.payee;
                rec.particulars         := j.particulars;
                rec.user_id             := j.user_id;
                rec.last_update         := j.last_update;
                rec.dsp_last_update     := TO_CHAR(j.last_update, 'MM-DD-RRRR HH:MI:SS AM');
                rec.item_no             := j.item_no;       --added by jeffdojello 12.16.2013
                
                PIPE ROW(rec);
            END LOOP;
        END LOOP;
    END GET_DV_LIST;
    
    
    PROCEDURE VALIDATE_CHECK_PREF_SUF(
        p_gibr_gfun_fund_cd IN      giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      giac_disb_vouchers.GIBR_BRANCH_CD%type, 
        p_check_pref_suf    IN      giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_check_no          IN      giac_chk_disbursement.CHECK_NO%type
    )
    AS
        v_not_exist         BOOLEAN := TRUE;
        v_check_pref_suf    giac_chk_disbursement.CHECK_PREF_SUF%type;
        v_check_no          giac_chk_disbursement.CHECK_NO%type; 
    BEGIN
        FOR REC IN(SELECT '1' 
                     FROM giac_chk_disbursement
	                WHERE check_pref_suf = p_check_pref_suf )
	    LOOP
		    v_not_exist := FALSE;
	    END LOOP;
        
        IF v_not_exist THEN
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Check prefix does not exist.');
        ELSE 
            FOR i IN (SELECT 'X'
                         FROM giac_disb_vouchers a, 
                              giac_chk_disbursement b, 
                              giac_payt_requests c
                        WHERE 1 = 1
                          AND a.gacc_tran_id = b.gacc_tran_id
                          AND a.gprq_ref_id = c.ref_id
                          AND a.gibr_gfun_fund_cd = p_gibr_gfun_fund_cd
                          AND a.gibr_branch_cd = p_gibr_branch_cd
                          AND b.check_pref_suf = p_check_pref_suf
                          AND b.check_no = p_check_no)
            LOOP
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Record already exists with the same check_pref_suf and check_no.');
            END LOOP;
        END IF;
    END VALIDATE_CHECK_PREF_SUF;
    
    
    PROCEDURE VALIDATE_CHECK_NO(
        p_gibr_gfun_fund_cd IN      giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      giac_disb_vouchers.GIBR_BRANCH_CD%type,      
        p_check_pref_suf    IN OUT  giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_check_no          IN OUT  giac_chk_disbursement.CHECK_NO%type,
        p_chk_no            IN      VARCHAR2
    )
    AS
    BEGIN
        IF p_check_pref_suf||'-'||p_check_no <> p_chk_no THEN
            FOR i IN (SELECT b.check_pref_suf||'-'||b.check_no check_no
                        FROM giac_disb_vouchers a, 
                             giac_chk_disbursement b, 
                             giac_payt_requests c
                       WHERE 1 = 1
                         AND a.gacc_tran_id = b.gacc_tran_id
                         AND a.gprq_ref_id = c.ref_id
                         AND a.gibr_gfun_fund_cd = p_gibr_gfun_fund_cd
                         AND a.gibr_branch_cd = p_gibr_branch_cd)
            LOOP
                IF i.check_no = p_check_pref_suf||'-'||p_check_no THEN
                    p_check_pref_suf := SUBSTR(p_chk_no, 1,INSTR(p_chk_no,'-')-1);--nestor
                    p_check_no       := TO_NUMBER(SUBSTR(p_chk_no, INSTR(p_chk_no,'-')+1));--nestor
                    --msg_alert('Check no. already exists! Please change.','I',TRUE);
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Check no. already exists! Please change.');
                END IF;
            END LOOP;
                
            IF p_check_no IS NULL THEN
                p_check_no := SUBSTR(p_chk_no,INSTR(p_chk_no,'-')+1);
            END IF;
        END IF;
    END VALIDATE_CHECK_NO;
    
        
    PROCEDURE UPDATE_CHECK_NO(
        p_gibr_gfun_fund_cd IN  giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  giac_disb_vouchers.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  giac_chk_disbursement.GACC_TRAN_ID%type,
        p_check_pref_suf    IN  giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_item_no           IN  giac_chk_disbursement.ITEM_NO%type, --added by jeffdojello 12.16.2013
        p_check_no          IN  giac_chk_disbursement.CHECK_NO%type,
        p_chk_no            IN  VARCHAR2,
        p_msg               OUT VARCHAR2
    )
    AS
        vCSN    GIAC_CHECK_NO.check_seq_no%TYPE;
    BEGIN
        /* updates check_pref_suf and check_no */
        UPDATE giac_chk_disbursement
           SET check_pref_suf = p_check_pref_suf,
               check_no       = p_check_no,
               last_update    = SYSDATE,
               user_id        = GIIS_USERS_PKG.app_user
         WHERE gacc_tran_id = p_gacc_tran_id
           AND item_no = p_item_no; --added by jeffdojello 12.16.2013
         
         FOR i IN ( SELECT a.gibr_gfun_fund_cd, a.gibr_branch_cd, b.bank_cd, 
                           b.bank_acct_cd, b.check_pref_suf, MAX(b.check_no) max_check_no
                      FROM giac_disb_vouchers a, 
                           giac_chk_disbursement b, 
                           giac_payt_requests c
                     WHERE 1 = 1
                       AND a.gacc_tran_id = b.gacc_tran_id
                       AND a.gprq_ref_id = c.ref_id
                       AND a.print_tag = 6
                       AND b.check_stat = '2'
                       AND a.gibr_gfun_fund_cd = p_gibr_gfun_fund_cd
                       AND a.gibr_branch_cd = p_gibr_branch_cd
                     GROUP BY a.gibr_gfun_fund_cd, a.gibr_branch_cd, b.bank_cd, b.bank_acct_cd, b.check_pref_suf)
        LOOP
            /*SELECT check_seq_no
              INTO vCSN
              FROM giac_check_no
             WHERE fund_cd      = i.gibr_gfun_fund_cd
               AND branch_cd    = i.gibr_branch_cd
               AND bank_cd      = i.bank_cd
               AND bank_acct_cd = i.bank_acct_cd
               AND chk_prefix   = i.check_pref_suf;*/
               
            FOR j IN ( SELECT check_seq_no
                         FROM giac_check_no
                        WHERE fund_cd      = i.gibr_gfun_fund_cd
                          AND branch_cd    = i.gibr_branch_cd
                          AND bank_cd      = i.bank_cd
                          AND bank_acct_cd = i.bank_acct_cd
                          AND chk_prefix   = i.check_pref_suf) 
	        LOOP 
	  	        vCSN := j.check_seq_no;    
                        
	            IF i.max_check_no > vCSN THEN
                     UPDATE giac_check_no
                        SET check_seq_no = i.max_check_no
                    WHERE fund_cd      = i.gibr_gfun_fund_cd
                      AND branch_cd    = i.gibr_branch_cd
                      AND bank_cd      = i.bank_cd
                      AND bank_acct_cd = i.bank_acct_cd
                      AND chk_prefix   = i.check_pref_suf;
	            END IF;
	        END LOOP;
        END LOOP;
         
        p_msg := 'SUCCESS';
    END UPDATE_CHECK_NO;
    
    
    FUNCTION GET_CHECK_NO_HISTORY(
        p_gacc_tran_id      GIAC_CHECK_NO_HIST.GACC_TRAN_ID%TYPE
    ) RETURN chk_no_history_tab PIPELINED
    AS
        rep     chk_no_history_type;
    BEGIN   
        FOR i IN (SELECT a.gacc_tran_id, a.dv_pref, a.dv_no, b.old_check_pref, b.old_check_no, 
                         b.new_check_pref, b.new_check_no, b.user_id, b.last_update 
                    FROM giac_disb_vouchers a, 
                         giac_check_no_hist b 
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND a.GACC_TRAN_ID = p_gacc_tran_id 
                   ORDER BY b.last_update)
        LOOP
            rep.gacc_tran_id    := i.gacc_tran_id;
            rep.dv_pref         := i.dv_pref;
            rep.dv_no           := i.dv_no;
            rep.old_check_pref  := i.old_check_pref;
            rep.old_check_no    := i.old_check_no;
            rep.new_check_pref  := i.new_check_pref;
            rep.new_check_no    := i.new_check_no;
            rep.user_id         := i.user_id;
            rep.last_update     := i.last_update;
            rep.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-RRRR hh:MI:ss AM');
            
            PIPE ROW(rep);
        END LOOP;
    END GET_CHECK_NO_HISTORY;
    
END GIACS049_PKG;
/



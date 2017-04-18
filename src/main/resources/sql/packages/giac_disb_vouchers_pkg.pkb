CREATE OR REPLACE PACKAGE BODY CPI.giac_disb_vouchers_pkg
/******************************************************************************
   NAME:       GIAC_DISB_VOUCHERS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/19/2012   Irwin Tabisora   1. Created this package.
   2.0        4/11/2013   Kris Felipe      2. Added types/functions/procedures for GIACS002
   2.1        5/23/2016   John Daniel      3. Modified validation when cancelling a DV 
                          Marasigan
******************************************************************************/
AS
   FUNCTION get_giacs016_giac_disb (
      p_gprq_ref_id   giac_disb_vouchers.gprq_ref_id%TYPE
   )
      RETURN giacs016_giac_disb_tab PIPELINED
   IS
      v_disb   giacs016_giac_disb_type;
   BEGIN
      FOR i IN (SELECT dv_pref, dv_no, dv_print_date, dv_approved_by,
                       dv_flag, dv_created_by, dv_create_date, gacc_tran_id,
                       gprq_ref_id
                  FROM giac_disb_vouchers
                 WHERE gprq_ref_id = p_gprq_ref_id)
      LOOP
         v_disb.dv_pref := i.dv_pref;
         v_disb.dv_no := i.dv_no;
         v_disb.dv_print_date := i.dv_print_date;
         v_disb.dv_approved_by := i.dv_approved_by;
         v_disb.dv_flag := i.dv_flag;
         v_disb.dv_created_by := i.dv_created_by;
         v_disb.dv_create_date := i.dv_create_date;
         v_disb.gacc_tran_id := i.gacc_tran_id;
         v_disb.gprq_ref_id := i.gprq_ref_id;

         FOR a IN (SELECT SUBSTR (rv_meaning, 1, 21) dsp_meaning
                     FROM cg_ref_codes
                    WHERE rv_low_value = i.dv_flag
                      AND rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG')
         LOOP
            v_disb.dsp_dv_flag_mean := a.dsp_meaning;
            EXIT;
         END LOOP;

         PIPE ROW (v_disb);
      END LOOP;
   END;
   
   /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.12.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Gets the list of disbursement vouchers
  */
   FUNCTION get_disb_vouchers_list(
       p_fund_cd               GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
       p_branch_cd             GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
       p_user_id               giis_users.user_id%TYPE,
       p_dv_flag               GIAC_DISB_VOUCHERS.DV_FLAG%TYPE      -- shan 11.04.2014
   ) RETURN giac_disb_vouchers_tab2 PIPELINED
   IS
        v_disb              giac_disb_vouchers_type2;
   BEGIN
        FOR rec IN (SELECT gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                           gprq_ref_id, req_dtl_no, gouc_ouc_id, 
                           dv_date, ref_no, dv_pref, dv_no, dv_print_date,
                           dv_flag, print_tag, dv_tag, 
                           payee, payee_class_cd, payee_no,
                           currency_rt, currency_cd, dv_fcurrency_amt, dv_amt, 
                           particulars, 
                           dv_created_by, dv_create_date, dv_approved_by, dv_approve_date,
                           user_id, last_update
                      FROM giac_disb_vouchers
                     WHERE gibr_gfun_fund_cd = p_fund_cd
                       AND gibr_branch_cd = p_branch_cd
                       --AND check_user_per_iss_cd_acctg2 (NULL, gibr_branch_cd, 'GIACS002', p_user_id) = 1 -- Kris 08.29.2013 user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                       -- replacement for function above : shan 11.04.2014
                       AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS002'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = gibr_branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS002')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS002'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = gibr_branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS002')) = 1)
                       -- end of replacement : 11.04.2014
                       AND dv_flag = p_dv_flag -- shan 11.04.2014
                     ORDER BY dv_date DESC, last_update DESC)
        LOOP    
            v_disb.gacc_tran_id := rec.gacc_tran_id;
            v_disb.gibr_gfun_fund_cd := rec.gibr_gfun_fund_cd;
            v_disb.gibr_branch_cd := rec.gibr_branch_cd;
            v_disb.gprq_ref_id := rec.gprq_ref_id;
            v_disb.req_dtl_no := rec.req_dtl_no;
            v_disb.gouc_ouc_id := rec.gouc_ouc_id;
            v_disb.dv_date := rec.dv_date;
            v_disb.dv_date_str_sp := TO_CHAR(rec.dv_date, 'Month DD, yyyy');
            v_disb.dv_date_str := TO_CHAR(rec.dv_date, 'mm-dd-yyyy');
            v_disb.tran_no := TO_CHAR(rec.dv_date, 'yyyy') || '-' ||TO_CHAR(rec.dv_date, 'mm');
            v_disb.ref_no := rec.ref_no;
            v_disb.dv_pref := rec.dv_pref;
            v_disb.dv_no := rec.dv_no;
            v_disb.dv_print_date := rec.dv_print_date;
            v_disb.dv_flag := rec.dv_flag;
            v_disb.print_tag := rec.print_tag;
            v_disb.dv_tag := rec.dv_tag;            
            v_disb.payee := rec.payee;
            v_disb.payee_class_cd := rec.payee_class_cd;
            v_disb.payee_no := rec.payee_no;            
            v_disb.currency_rt := rec.currency_rt;
            v_disb.currency_cd := rec.currency_cd;
            v_disb.dv_fcurrency_amt := rec.dv_fcurrency_amt;
            v_disb.dv_amt := rec.dv_amt;            
            v_disb.particulars := rec.particulars;
            v_disb.dv_created_by := rec.dv_created_by;
            v_disb.dv_create_date := rec.dv_create_date;            
            v_disb.dv_approved_by := rec.dv_approved_by;
            v_disb.dv_approve_date := rec.dv_approve_date;
            v_disb.user_id := rec.user_id;
            v_disb.last_update := rec.last_update;
            v_disb.payt_req_no := get_request_no (rec.gprq_ref_id);  -- added by robert SR 5190 12.02.15
            PIPE ROW(v_disb);
        END LOOP;
        
   END get_disb_vouchers_list;
   
   /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.12.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Gets the disbursement voucher information
  */
   FUNCTION get_disb_voucher_info(
        p_gacc_tran_id      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_item_no           giac_chk_disbursement.item_no%TYPE,
        p_user_id           giac_disb_vouchers.user_id%TYPE
   ) RETURN giac_disb_vouchers_tab2 PIPELINED
   IS 
        v_disb              giac_disb_vouchers_type2;
        v_curr_value        VARCHAR2(1);
   BEGIN
        FOR rec IN (SELECT gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                           gprq_ref_id, req_dtl_no, gouc_ouc_id, 
                           dv_date, ref_no, dv_pref, dv_no, dv_print_date,
                           dv_flag, print_tag, dv_tag, 
                           payee, payee_class_cd, payee_no,
                           currency_rt, currency_cd, dv_fcurrency_amt, dv_amt, 
                           particulars, 
                           dv_created_by, dv_create_date, dv_approved_by, dv_approve_date,
                           user_id, last_update
                      FROM giac_disb_vouchers
                     WHERE gacc_tran_id = p_gacc_tran_id
                     ORDER BY last_update DESC)
        LOOP    
            v_disb.gacc_tran_id := rec.gacc_tran_id;
            v_disb.gibr_gfun_fund_cd := rec.gibr_gfun_fund_cd;
            v_disb.gibr_branch_cd := rec.gibr_branch_cd;
            v_disb.gprq_ref_id := rec.gprq_ref_id;
            v_disb.req_dtl_no := rec.req_dtl_no;
            v_disb.gouc_ouc_id := rec.gouc_ouc_id;
            v_disb.dv_date := rec.dv_date;
            v_disb.dv_date_str_sp := TO_CHAR(rec.dv_date, 'Month DD, yyyy');
            v_disb.dv_date_str := TO_CHAR(rec.dv_date, 'mm-dd-yyyy');
            v_disb.tran_no := TO_CHAR(rec.dv_date, 'yyyy') || '-' ||TO_CHAR(rec.dv_date, 'mm');
            v_disb.ref_no := rec.ref_no;
            v_disb.dv_pref := rec.dv_pref;
            v_disb.dv_no := rec.dv_no;
            v_disb.dv_print_date := rec.dv_print_date;
            v_disb.dv_flag := rec.dv_flag;
            v_disb.print_tag := rec.print_tag;
            v_disb.dv_tag := rec.dv_tag;            
            v_disb.payee := rec.payee;
            v_disb.payee_class_cd := rec.payee_class_cd;
            v_disb.payee_no := rec.payee_no;            
            v_disb.currency_rt := rec.currency_rt;
            v_disb.currency_cd := rec.currency_cd;
            v_disb.dv_fcurrency_amt := rec.dv_fcurrency_amt;
            v_disb.dv_amt := rec.dv_amt;            
            v_disb.particulars := rec.particulars;
            v_disb.dv_created_by := rec.dv_created_by;
            v_disb.dv_create_date := rec.dv_create_date;            
            v_disb.str_create_date := TO_CHAR(rec.dv_create_date, 'mm-dd-yyyy HH12:MI:SS AM');
            v_disb.dv_approved_by := rec.dv_approved_by;
            v_disb.dv_approve_date := rec.dv_approve_date;
            v_disb.str_approve_date := TO_CHAR(rec.dv_approve_date, 'mm-dd-yyyy HH12:MI:SS AM');
            v_disb.user_id := rec.user_id;
            v_disb.last_update := rec.last_update;
            v_disb.str_last_update := TO_CHAR(rec.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            
            -- post-query of GIDV
            BEGIN
                CHK_CHAR_REF_CODES(v_disb.dv_flag                      /* MOD: Value to be validated    */
                                   ,v_disb.dv_flag_mean              /* MOD: Domain meaning           */
                                   ,'GIAC_DISB_VOUCHERS.DV_FLAG');   /* IN : Reference codes domain   */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_disb.dv_flag_mean := NULL;
            WHEN OTHERS THEN NULL;
--              CGTE$OTHER_EXCEPTIONS;               
            END;
            
            DECLARE
                CURSOR C IS
                  SELECT A430.SHORT_NAME
                    FROM GIIS_CURRENCY A430
                  WHERE  A430.MAIN_CURRENCY_CD = rec.CURRENCY_CD;
            BEGIN
                OPEN C;
                FETCH C
                INTO   v_disb.foreign_currency;
                IF C%NOTFOUND THEN
                  RAISE NO_DATA_FOUND;
                END IF;
--                :GIDV.MIR_DSP_FSHORT_NAME := :GIDV.DSP_FSHORT_NAME;
                CLOSE C;
                BEGIN
                   SELECT giacp.v('DEFAULT_CURRENCY') 
                     INTO v_disb.local_currency
                     FROM dual; 
                     
--                   SELECT currency_rt
--                     INTO v_disb.local_currency_rt
--                     FROM giis_currency
--                    WHERE short_name = v_disb.local_currency;                  
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN NULL; --MSG_ALERT('No default currency.','I', FALSE);
                END;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL; --CGTE$OTHER_EXCEPTIONS;
            END;
            
            FOR c in (SELECT class_desc 
		                FROM giis_payee_class
		               WHERE payee_class_cd = rec.payee_class_cd) 
            LOOP
                v_disb.payee_class_desc := c.class_desc;
                EXIT;
            END LOOP;
            
            BEGIN
              BEGIN
                    SELECT fund_desc
                      INTO v_disb.fund_desc
                      FROM giis_funds
                     WHERE fund_cd = rec.gibr_gfun_fund_cd;
              EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
              END;
              BEGIN
                    SELECT branch_name
                      INTO v_disb.branch_name
                      FROM giac_branches
                     WHERE branch_cd    = rec.gibr_branch_cd
                       AND gfun_fund_cd = rec.gibr_gfun_fund_cd;
              EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
              END;

              v_disb.dsp_print_date := TO_CHAR(rec.dv_print_date, 'MM-DD-RRRR');
              v_disb.dsp_print_time := TO_CHAR(rec.dv_print_date, 'HH:MI AM');

            END;
            
            BEGIN
              SELECT gprq.document_cd,
                     gprq.branch_cd,
                     DECODE(gprq.line_cd, NULL, NULL, gprq.line_cd),
                     DECODE(gprq.doc_year, NULL, NULL, gprq.doc_year),
                     DECODE(gprq.doc_mm, NULL, NULL, gprq.doc_mm),
                     gprq.doc_seq_no 
                INTO v_disb.gprq_document_cd,
                     v_disb.gprq_branch_cd,
                     v_disb.gprq_line_cd,
                     v_disb.gprq_doc_year,
                     v_disb.gprq_doc_mm,
                     v_disb.gprq_doc_seq_no
                FROM giac_payt_requests gprq 
                     ,giac_payt_requests_dtl grqd 
               WHERE gprq.ref_id        = grqd.gprq_ref_id
                 AND gprq.ref_id        = rec.gprq_ref_id
                 AND grqd.req_dtl_no    = rec.req_dtl_no
                 AND gprq.fund_cd       = rec.gibr_gfun_fund_cd
                 AND gprq.branch_cd     = rec.gibr_branch_cd
                 AND grqd.tran_id       = rec.gacc_tran_id;
            EXCEPTION   
              WHEN NO_DATA_FOUND THEN
--                msg_alert('Error locating Payment Request No.', 'E', TRUE);
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Error locating Payment Request No.');
            END;
            
--            BEGIN  -- program unit: get_payt_req_numbering_scheme 
--              FOR a IN (SELECT line_cd_tag, yy_tag, mm_tag
--                          FROM giac_payt_req_docs
--                         WHERE gibr_gfun_fund_cd = rec.gibr_gfun_fund_cd
--                           AND gibr_branch_cd = rec.gibr_branch_cd
--                           AND document_cd = v_disb.gprq_document_cd) LOOP
--                v_disb.nbt_line_cd_tag := a.line_cd_tag;
--                v_disb.nbt_yy_tag := a.yy_tag; 
--                v_disb.nbt_mm_tag := a.mm_tag;
--                EXIT;
--              END LOOP;  
--            END;
            
            /*GIAC_PAYT_REQ_DOCS_PKG.get_payt_req_numbering_scheme(rec.gibr_gfun_fund_cd,
                                                                 rec.gibr_branch_cd,
                                                                 v_disb.gprq_document_cd,
                                                                 v_disb.nbt_line_cd_tag,
                                                                 v_disb.nbt_yy_tag,
                                                                 v_disb.nbt_mm_tag);*/
            SELECT line_cd_tag, yy_tag, mm_tag
              INTO v_disb.nbt_line_cd_tag, v_disb.nbt_yy_tag, v_disb.nbt_mm_tag
              FROM TABLE(GIAC_PAYT_REQ_DOCS_PKG.get_payt_req_numbering_scheme(rec.gibr_gfun_fund_cd,
                                                                              rec.gibr_branch_cd,
                                                                              v_disb.gprq_document_cd));
            
            SELECT (giac_disb_vouchers_pkg.get_print_tag_mean(rec.print_tag))
              INTO v_disb.print_tag_mean
              FROM dual;
                        
            /* End of post-query*/
            
            /* When-Button-Pressed Trigger: GIDV(Data Block Level)*/
            v_disb.clm_doc_cd := giacp.v('CLM_PAYT_REQ_DOC');
            v_disb.ri_doc_cd := giacp.v('FACUL_RI_PREM_PAYT_DOC');
            v_disb.comm_doc_cd := giacp.v('COMM_PAYT_DOC');
            v_disb.bcsr_doc_cd := giacp.v('BATCH_CSR_DOC');
            
            SELECT check_user_per_iss_cd_acctg2(null, v_disb.gibr_branch_cd, 'GIACS002', NVL(p_user_id, USER))
              INTO v_disb.check_user_tag
              FROM dual;
              
            DECLARE
                CURSOR C IS
                    SELECT GOUC.GIBR_GFUN_FUND_CD
                            ,GOUC.GIBR_BRANCH_CD
                            ,GOUC.OUC_CD
                            ,GOUC.OUC_NAME
                      FROM   GIAC_OUCS GOUC
                     WHERE  GOUC.OUC_ID = v_disb.GOUC_OUC_ID;
            BEGIN
                OPEN C;
                FETCH C
                 INTO v_disb.fund_cd2
                      ,v_disb.branch_cd2
                      ,v_disb.OUC_CD
                      ,v_disb.OUC_NAME;
                IF C%NOTFOUND THEN
                  RAISE NO_DATA_FOUND;
                END IF;
                CLOSE C;
            EXCEPTION
                WHEN no_data_found THEN
                    --msg_alert('No primary key row found for value in GOUC_OUC_ID', 'E',TRUE);
                    raise_application_error(-20001, 'Geniisys Exception#E#No primary key found for value in GOUC_OUC_ID.');
            END;

            v_disb.dv_approval := giac_validate_user_fn(nvl(p_user_id, USER), 'D2', 'GIACS002');
            
            PIPE ROW(v_disb);
            
        END LOOP;
   END get_disb_voucher_info;
   
   
   /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.12.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Gets the values from giac_parameters to initialize global variables
  */
  FUNCTION get_default_disb_info(
        p_fund_cd               GIAC_DISB_VOUCHERS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd             GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
        p_user_id               giis_users.user_id%TYPE
--        p_workflow_event_desc   VARCHAR2(2000),
--        p_workflow_col_value    
   ) RETURN giac_disb_vouchers_tab2 PIPELINED
  IS 
        v_default_disb      giac_disb_vouchers_type2;
        v_exists            varchar2(2) := 'N';
  BEGIN  
      -- 1. PRE-FORM 
      FOR c IN (SELECT b.grp_iss_cd
                  FROM giis_users A, giis_user_grp_hdr b
                 WHERE A.user_grp = b.user_grp 
                   AND A.user_id = p_user_id)
      LOOP
            v_default_disb.grp_iss_cd := c.grp_iss_cd;
            v_default_disb.user_id := p_user_id;
            v_default_disb.last_update := SYSDATE;
            v_default_disb.dv_created_by := p_user_id;
            v_default_disb.str_last_update := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
            v_default_disb.dv_create_date := SYSDATE;
            v_default_disb.str_create_date := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
            v_default_disb.dv_print_date := SYSDATE;
            v_default_disb.str_print_date := TO_CHAR(SYSDATE, 'mm-dd-yyyy');
            v_default_disb.str_print_time := TO_CHAR(SYSDATE, 'HH:MI AM');
            
            -- 2. WHEN-NEW-FORM-INSTANCE
            v_default_disb.gibr_branch_cd := nvl(P_BRANCH_CD, GIACP.V('BRANCH_CD'));
            v_default_disb.gibr_gfun_fund_cd := nvl(p_fund_cd, GIACP.V('FUND_CD'));
            --added by steven 09.25.2014
            BEGIN
               SELECT NVL(check_dv_print,GIACP.V('CHECK_DV_PRINT'))
                 INTO v_default_disb.check_dv_print
                 FROM giac_branches
                WHERE gfun_fund_cd = v_default_disb.gibr_gfun_fund_cd 
                    AND branch_cd = v_default_disb.gibr_branch_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_default_disb.check_dv_print := GIACP.V('CHECK_DV_PRINT');
            END;
            --v_default_disb.check_dv_print := nvl(v_default_disb.check_dv_print, GIACP.V('CHECK_DV_PRINT') );  -- program unit get_chk_dv_print --remove by steven 09.25.2014
            v_default_disb.update_payee_name := nvl(v_default_disb.update_payee_name, GIACP.V('UPDATE_PAYEE_NAME'));
    --      v_default_disb.allow_multi_check := nvl(v_default_disb.allow_multi_check, GIACP.V('MULTI_CHECK'));  
    
            BEGIN
                SELECT fund_desc
                  INTO v_default_disb.fund_desc
                  FROM giis_funds
                 WHERE fund_cd = v_default_disb.gibr_gfun_fund_cd;
            EXCEPTION
                WHEN no_data_found THEN NULL;
            END;
            
            BEGIN
                SELECT branch_name
                  INTO v_default_disb.branch_name
                  FROM giac_branches
                 WHERE branch_cd = v_default_disb.gibr_branch_cd
                   AND gfun_fund_cd = v_default_disb.gibr_gfun_fund_cd;
            EXCEPTION
                WHEN no_data_found THEN NULL;
            END;
            
            BEGIN
                SELECT giacp.v('DEFAULT_CURRENCY') 
                  INTO v_default_disb.local_currency
                  FROM dual;
            EXCEPTION
                WHEN no_data_found THEN NULL; 
            END ;
            
            BEGIN  -- Procedure GET_MULTI_CHECK
                SELECT (giacp.v('MULTI_CHECK'))
                  INTO v_default_disb.allow_multi_check
                  FROM dual;
             
            EXCEPTION
              WHEN no_data_found THEN
                  RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.INFO#Parameter MULTI_CHECK does not exists in GIAC_PARAMETERS.');          
            END;
           
            v_default_disb.dv_approval := giac_validate_user_fn(p_user_id, 'D2', 'GIACS002');
          
            /* When-New-Record-Instance Trigger (GIDV) */
            BEGIN -- set_approve_dv_button Program  Unit
                FOR i IN (      -- encapsulate in a FOR LOOP to prevent ORA-01422 : shan 08.01.2014
                  SELECT 1 approved_dv_tag
                    --INTO v_default_disb.approve_dv_tag
                    FROM GIAC_USER_FUNCTIONS A, GIAC_MODULES B
                   WHERE A.MODULE_ID = B.MODULE_ID
                     AND B.MODULE_NAME = 'GIACS002'
                     AND FUNCTION_CODE = 'D2'
                     AND A.USER_ID = p_user_id
                     AND VALID_TAG = 'Y'
                     AND SYSDATE > VALIDITY_DT
                     AND SYSDATE < NVL(TERMINATION_DT, SYSDATE+1))
                 LOOP
                    v_default_disb.approve_dv_tag := i.approved_dv_tag;
                 END LOOP;
            EXCEPTION
              WHEN no_data_found THEN NULL;
            END;
            
            v_default_disb.allow_tran_tag := NVL(giacp.v('ALLOW_TRAN_FOR_CLOSED_MONTH'),'Y');
            
            SELECT check_user_per_iss_cd_acctg2(null, v_default_disb.gibr_branch_cd, 'GIACS002', p_user_id)
              INTO v_default_disb.check_user_tag
              FROM dual;
            
            PIPE ROW(v_default_disb);            
      END LOOP;
      
  END get_default_disb_info;
  
  /* CGFK$CHK_GACC_GACC_GIBR_FK Progrma Unit */
  /* Validate foreign key value/query lookup data. */
  PROCEDURE chk_gacc_gacc_gibr_fk(
        p_fund_cd       IN OUT     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN OUT     giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_fund_desc     OUT        giis_funds.fund_desc%TYPE,
        p_branch_name   OUT        giac_branches.branch_name%TYPE
   ) IS
   
   BEGIN
        DECLARE
            CURSOR C IS
              SELECT GIBR.BRANCH_NAME
                    ,GIBR.GFUN_FUND_CD
                    ,GFUN.FUND_DESC
              FROM   GIAC_BRANCHES GIBR
                    ,GIIS_FUNDS GFUN
              WHERE  GIBR.BRANCH_CD = p_branch_cd
              AND    GFUN.FUND_CD = GIBR.GFUN_FUND_CD
              AND    GIBR.GFUN_FUND_CD = p_fund_cd;
            v_fund_cd giis_funds.fund_cd%TYPE;
        BEGIN
            OPEN C;
            FETCH C
            INTO p_branch_name,
                 p_fund_cd,
                 p_fund_desc;
            IF C%NOTFOUND THEN
--              RAISE NO_DATA_FOUND;
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#These fund and branch codes do not exist.');
            END IF;
        CLOSE C;
        
        EXCEPTION
            WHEN OTHERS THEN NULL;
--              CGTE$OTHER_EXCEPTIONS;
        END;
   END chk_gacc_gacc_gibr_fk;
   
   /* get_print_tag_mean Program Unit */
   /* Returns the meaning of print_tag */
   FUNCTION get_print_tag_mean(
        p_print_tag     IN      cg_ref_codes.rv_low_value%TYPE
   ) RETURN VARCHAR2 IS 
        v_meaning       cg_ref_codes.rv_low_value%TYPE;
   BEGIN
        BEGIN
            FOR a IN (SELECT SUBSTR(rv_meaning, 1, 39) print_tag_mean
                              FROM cg_ref_codes
                             WHERE rv_low_value = TO_CHAR(p_print_tag)
                               AND rv_domain = 'GIAC_DISB_VOUCHERS.PRINT_TAG') 
            LOOP
                v_meaning := a.print_tag_mean;
                EXIT;
            END LOOP;  
            
            RETURN v_meaning;
        END;      
   END get_print_tag_mean;
   
    -- if any of these (line_cd_tag, yy_tag, mm_tag) = 'Y' 
    -- then set their corresponding field/s (dsp_line_cd, dsp_year, 
    -- dsp_mm) to enterable and required. --replace '&' with 'and' to prevent prompting of parameter screen during script execution by MAC 11/06/2013.
--   PROCEDURE get_payt_req_numbering_scheme(  /* moved to GIAC_PAYT_REQ_DOCS_PKG */
--        p_fund_cd           IN OUT     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
--        p_branch_cd         IN OUT     giac_disb_vouchers.gibr_branch_cd%TYPE,
--        p_document_cd       IN OUT     giac_payt_requests.document_cd%TYPE,
--        p_nbt_line_cd_tag   OUT        giac_payt_req_docs.line_cd_tag%TYPE,
--        p_nbt_yy_tag        OUT        giac_payt_req_docs.yy_tag%TYPE,
--        p_nbt_mm_tag        OUT        giac_payt_req_docs.mm_tag%TYPE
--   ) IS   
--   BEGIN
--        FOR a IN (SELECT line_cd_tag, yy_tag, mm_tag
--                    FROM giac_payt_req_docs
--                   WHERE gibr_gfun_fund_cd = p_fund_cd
--                     AND gibr_branch_cd = p_branch_cd
--                     AND document_cd = p_document_cd) 
--        LOOP
--            p_nbt_line_cd_tag := a.line_cd_tag;
--            p_nbt_yy_tag := a.yy_tag; 
--            p_nbt_mm_tag := a.mm_tag;
--            EXIT;
--        END LOOP;  
--   END get_payt_req_numbering_scheme;
   
   PROCEDURE LKP_GIDV_GIDV_GOUC_FK(
        p_ouc_cd            IN        giac_oucs.ouc_cd%TYPE,
        p_ouc_name          IN        giac_oucs.ouc_name%TYPE,
        p_ouc_id            OUT       giac_oucs.ouc_id%TYPE--,
        --p_fund_cd           OUT       giac_oucs.gibr_gfun_fund_cd%TYPE,
        --p_branch_cd         OUT       giac_oucs.gibr_branch_cd%TYPE
   ) IS
   
   BEGIN
        IF (p_ouc_cd IS NOT NULL OR p_ouc_name IS NOT NULL) THEN
            DECLARE
                CURSOR C IS
                    SELECT GOUC.OUC_ID
                         -- ,GOUC.GIBR_GFUN_FUND_CD
                          --,GOUC.GIBR_BRANCH_CD
                     FROM GIAC_OUCS GOUC
                    WHERE GOUC.OUC_CD = p_ouc_cd
                      AND GOUC.OUC_NAME = p_ouc_name;
            BEGIN
                  OPEN C;
                  FETCH C
                  INTO   p_ouc_id;
                     --   ,p_fund_cd
                     --   ,p_branch_cd;
                        
                  IF C%NOTFOUND THEN
                    RAISE NO_DATA_FOUND;
                  END IF;
                  CLOSE C;
            EXCEPTION   
                WHEN OTHERS THEN NULL;
--                    CGTE$OTHER_EXCEPTIONS;
            END;
            
        ELSE
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Department Code must be entered.');
        END IF;
        
   END LKP_GIDV_GIDV_GOUC_FK;
   
   
   PROCEDURE generate_dv_no(
        p_fund_cd     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd   giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_doc_name    giac_doc_sequence.doc_name%TYPE,
        p_seq_fund_cd   OUT     giis_funds.fund_cd%TYPE,
        p_seq_branch_cd OUT     giac_branches.branch_cd%TYPE,
        p_dv_pref       OUT     giac_doc_sequence.doc_pref_suf%TYPE,
        p_dv_no         OUT     GIAC_DOC_SEQUENCE.DOC_SEQ_NO%TYPE,
        p_message       OUT     VARCHAR2
   ) --RETURN NUMBER
   IS
        v_dv_fund_cd                  VARCHAR2 (1);
        v_dv_branch_cd                VARCHAR2 (1);
        v_fund_cd                     giac_doc_sequence.fund_cd%TYPE;
        v_branch_cd                   giac_doc_sequence.branch_cd%TYPE;
        v_dv_pref					  giac_doc_sequence.doc_pref_suf%TYPE;----Vincent 053105: variable to hold pref from giac_parameters
   	
   BEGIN
        FOR a1 IN  (SELECT param_value_v
                      FROM giac_parameters
                     WHERE UPPER (param_name) = 'DV_PREF')
	    LOOP
            --:gidv.dv_pref := a1.param_value_v;--Vincent 053105: comment out, prefix should come from giac_doc_sequence
            v_dv_pref	:= a1.param_value_v;
            EXIT;
	    END LOOP;
        
        v_dv_fund_cd := giacp.v ('DV_FUND_CD');
	    v_dv_branch_cd := giacp.v ('DV_BRANCH_CD');
	    --Parameters used to check if fund_cd and/or branch_cd will be considered in generating dv_no
        --terrence 09022002 

        v_fund_cd := p_fund_cd;
        v_branch_cd := p_branch_cd;
    
        --IF :gidv.dv_pref IS NULL THEN --Vincent 053105: comment out
        IF v_dv_pref IS NULL THEN	--Vincent 053105
--            msg_alert ('DV Prefix parameter not found.', 'E', TRUE);
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#DV Prefix parameter not found.');
        ELSE
            BEGIN
                IF v_dv_fund_cd = 'N' THEN
                    SELECT fund_cd
                      INTO v_fund_cd
                      FROM giac_doc_sequence
                     WHERE doc_seq_no = (SELECT MAX (doc_seq_no)
                                           FROM giac_doc_sequence
                                          WHERE doc_name = p_doc_name)
                       AND ROWNUM = 1;
                END IF;

                IF v_dv_branch_cd = 'N' THEN
                    SELECT branch_cd	
                      INTO v_branch_cd
                      FROM giac_doc_sequence
                     WHERE doc_seq_no = (SELECT MAX (doc_seq_no)
                                           FROM giac_doc_sequence
                                          WHERE fund_cd = v_fund_cd
                                            AND doc_name = p_doc_name)
                       AND ROWNUM = 1;
                END IF;
    			
                p_seq_fund_cd := v_fund_cd;
                p_seq_branch_cd := v_branch_cd;

                --Vincent 053105: added select for dv_pref 
                BEGIN
                    SELECT doc_pref_suf
                      INTO p_dv_pref
                      FROM giac_doc_sequence
                     WHERE fund_cd = v_fund_cd
                       AND branch_cd = v_branch_cd
                       AND doc_name = p_doc_name;
                EXCEPTION
                    WHEN no_data_found THEN
                        p_message := 'No DV Prefix found in giac_doc_sequence.';
--                        msg_alert ('No DV Prefix found in giac_doc_sequence.', 'E', FALSE);
                END;		
                --*V*--	

                SELECT doc_seq_no
                  INTO p_dv_no
                  FROM giac_doc_sequence
                 WHERE fund_cd = v_fund_cd
                   AND branch_cd = v_branch_cd
                   AND doc_name = p_doc_name
                   AND NVL (doc_pref_suf, '-') = NVL (p_dv_pref, NVL (doc_pref_suf, '-'))
                   FOR UPDATE OF doc_seq_no;

                p_dv_no := p_dv_no + 1;
--                RETURN p_dv_no;
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_dv_pref := v_dv_pref;--Vincent 053105
                    p_dv_no := 1;
--                RETURN p_dv_no;
            END;
        END IF;
   END generate_dv_no;
   
   PROCEDURE validate_dv_no (
        p_dv_no             IN OUT        giac_disb_vouchers.dv_no%TYPE,
        p_dv_pref           IN OUT        giac_disb_vouchers.dv_pref%TYPE,
        p_fund_cd           IN OUT        giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd         IN OUT        giac_disb_vouchers.gibr_branch_cd%TYPE
   ) IS
        v_dv_exists         VARCHAR2(1);
   BEGIN
        SELECT '1'
          INTO v_dv_exists
          FROM giac_disb_vouchers
         WHERE dv_no = p_dv_no
           AND NVL(dv_pref, '-') = NVL(p_dv_pref, NVL(dv_pref, '-'))
           AND GIBR_GFUN_FUND_CD = p_fund_cd -- p_branch_cd ung nasa fmb
           AND GIBR_BRANCH_CD = p_branch_cd; --p_fund_cd ung nasa fmb;        

        IF v_dv_exists IS NOT NULL THEN
            p_dv_no := NULL;
            --RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#DV No. ' || p_dv_pref || '-' || TO_CHAR(p_dv_no) || ' already exists.');
--          MSG_ALERT('DV No. ' || :gidv.dv_pref || '-' ||  TO_CHAR(:gidv.dv_no) || ' already exists.', 'I', FALSE);
            SELECT MAX (dv_no) + 1      -- replacement for codes above : shan 11.24.2014
              INTO p_dv_no
              FROM giac_disb_vouchers
             WHERE GIBR_GFUN_FUND_CD = p_fund_cd
               AND gibr_branch_cd = p_branch_cd;
        END IF;
   EXCEPTION
        WHEN no_data_found THEN NULL;
        WHEN TOO_MANY_ROWS THEN
            p_dv_no := NULL;
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#This DV No. has too many rows.');
   
   END validate_dv_no;
   
   
   -- computes for and returns the credit/debit total amount.
   PROCEDURE val_acc_entr_bef_approving(
        p_gacc_tran_id              giac_acct_entries.gacc_tran_id%TYPE,
        p_total_amt         OUT     giac_disb_vouchers.dv_amt%TYPE
   ) IS
        v_exists      giac_acct_entries.gacc_tran_id%TYPE;
   BEGIN
        FOR a1 IN (SELECT gacc_tran_id
                     FROM giac_acct_entries
                    WHERE gacc_tran_id = p_gacc_tran_id) 
        LOOP
            v_exists := a1.gacc_tran_id;
            EXIT;
        END LOOP;
        
        IF v_exists IS NOT NULL THEN
            DECLARE
                v_sum_debit     NUMBER(30,2);
                v_sum_credit    NUMBER(30,2);
                v_tot_amt       giac_disb_vouchers.dv_amt%TYPE;
                v_message       VARCHAR2(150);
            BEGIN
                SELECT NVL(SUM(debit_amt),0), 
                       NVL(SUM(credit_amt),0)
                  INTO v_sum_debit, v_sum_credit
                  FROM giac_acct_entries
                 WHERE gacc_tran_id = p_gacc_tran_id;
             
                v_tot_amt := v_sum_debit - v_sum_credit;
                p_total_amt := v_tot_amt;
                
            EXCEPTION
                WHEN no_data_found THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#Approve DV: Credit/Debit amounts not found.');            
            END;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#Accounting entries not found.');
        END IF;
        
   END val_acc_entr_bef_approving;
   
   
   -- approves validated DV
   PROCEDURE approve_validated_dv(
        p_user_id                   IN      giac_disb_vouchers.user_id%TYPE,
        p_gacc_tran_id              IN      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_dv_flag                   IN OUT  giac_disb_vouchers.dv_flag%TYPE,
        p_dv_flag_mean              OUT     VARCHAR2,
        p_dv_approved_by            OUT     giac_disb_vouchers.dv_approved_by%TYPE,
        p_dv_approve_date           OUT     giac_disb_vouchers.dv_approve_date%TYPE,
        p_dv_approve_date_str       OUT     VARCHAR2
   ) IS
        v_new_dv_flag   giac_disb_vouchers.dv_flag%TYPE := p_dv_flag;
   BEGIN
   
         --/*A.R.C. 09.02.2005*/--
         -- to delete workflow records of accounting
         delete_workflow_rec('APPROVE DV','GIACS002',p_user_id,p_gacc_tran_id);
         --/*09.02.2005*/--           	
         p_dv_approved_by := p_user_id;
         p_dv_approve_date := SYSDATE;
         p_dv_approve_date_str := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
        --added this condition for allow dv printing before approving 
        --para di na mabago ung dv_flag nya n 'P' pag inapprove na at printed na ung DV.
        --lina 101406
            
        IF p_dv_flag != 'P' THEN
            v_new_dv_flag := 'A';
        END IF;
   
        UPDATE giac_disb_vouchers
           SET dv_approved_by = p_user_id,
               dv_approve_date = SYSDATE,
               dv_flag = v_new_dv_flag
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        p_dv_flag := v_new_dv_flag;
        BEGIN
            CHK_CHAR_REF_CODES(p_dv_flag                      /* MOD: Value to be validated    */
                               ,p_dv_flag_mean              /* MOD: Domain meaning           */
                               ,'GIAC_DISB_VOUCHERS.DV_FLAG');   /* IN : Reference codes domain   */
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_dv_flag_mean := NULL;
            WHEN OTHERS THEN NULL;
--              CGTE$OTHER_EXCEPTIONS;               
        END;
        
   END approve_validated_dv;
   
   
   PROCEDURE validate_insert(
       p_fund_cd            IN OUT  GIAC_DISB_VOUCHERS.gibr_gfun_fund_cd%TYPE,
       p_branch_cd          IN OUT  GIAC_DISB_VOUCHERS.gibr_branch_cd%TYPE,
       p_gacc_tran_id       IN OUT  GIAC_DISB_VOUCHERS.gacc_tran_id%TYPE,
       p_ouc_cd             IN OUT  GIAC_OUCS.ouc_cd%TYPE,
       p_ouc_name           IN OUT  GIAC_OUCS.ouc_name%TYPE,
       p_ouc_id             IN OUT  GIAC_OUCS.ouc_id%TYPE,
       p_global_dv_tag      IN      GIAC_DISB_VOUCHERS.dv_tag%TYPE,
       p_print_date         IN OUT  GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       p_check_dv_print     IN      giac_parameters.param_value_v%TYPE,
       p_calling_form       IN      VARCHAR2,
       p_str_print_date     OUT     VARCHAR2, --GIAC_DISB_VOUCHERS.dv_print_date%TYPE,
       p_dv_tag             OUT     GIAC_DISB_VOUCHERS.dv_tag%TYPE,
       p_seq_fund_cd        OUT     GIAC_PARAMETERS.param_value_v%TYPE,
       p_seq_branch_cd      OUT     GIAC_PARAMETERS.param_value_v%TYPE,
       p_dv_pref            OUT     giac_doc_sequence.doc_pref_suf%TYPE,
       p_dv_no              IN OUT     GIAC_DISB_VOUCHERS.dv_no%TYPE,
       p_message            OUT     VARCHAR2
   ) IS
        CURSOR c1 IS SELECT '1'
                       FROM giis_funds
                      WHERE fund_cd = p_fund_cd;

        CURSOR c2 IS SELECT '2'
                       FROM giac_branches
                      WHERE branch_cd    = p_branch_cd
                        AND gfun_fund_cd = p_fund_cd;

        v_fund_cd       VARCHAR2(1);
        v_branch_cd     VARCHAR2(1);
        v_dummy  	    VARCHAR2(1);
   BEGIN
        
                                    
        IF p_dv_no IS NOT NULL THEN  -- update only!
            /**************  PRE-UPDATE TRIGGER */
            BEGIN
                GIAC_DISB_VOUCHERS_PKG.lkp_gidv_gidv_gouc_fk(p_ouc_cd, p_ouc_name, p_ouc_id/*, p_fund_cd, p_branch_cd*/);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#This OUC Code, OUC Name does not exist.');
                WHEN OTHERS THEN NULL;
            END;
            
        ELSE   
            /**************  PRE-INSERT TRIGGER */
            /* Check values of fund_cd,branch_cd from acctrans */
            OPEN c1;
            
            FETCH c1 
             INTO v_fund_cd;
               
            IF c1%NOTFOUND THEN
    --            MSG_ALERT('Invalid value for Fund Code.','I',TRUE);
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#Invalid value for Fund Code.');
            ELSE
                  BEGIN
                    OPEN c2;
                    FETCH c2 
                     INTO v_branch_cd;  
                    
                    IF c2%NOTFOUND THEN
    --                    MSG_ALERT('Invalid value for Branch Code.','I',TRUE);
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#Invalid value for Branch Code.');
                    END IF;
                    
                    CLOSE C2;
                  END;
            END IF;
            
            CLOSE c1;
            
            /* check that the tran_id fetched from giac_payt_requests exists in giac_acctrans */
           IF p_calling_form = 'BANNER_SCREEN' THEN
                 BEGIN
                    SELECT 'x'
                      INTO v_dummy
                      FROM giac_acctrans
                     WHERE tran_id = p_gacc_tran_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
        --              msg_alert('GIDV Pre-insert: Tran id not found.', 'E', TRUE);
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#GIDV Pre-Insert: Tran ID not found!');
                END;
           END IF;
          
            /* Check that foreign key value exists in referenced table */
            BEGIN
                GIAC_DISB_VOUCHERS_PKG.lkp_gidv_gidv_gouc_fk(p_ouc_cd, p_ouc_name, p_ouc_id/*, p_fund_cd, p_branch_cd*/);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#This OUC Code, OUC Name does not exist.');
                WHEN OTHERS THEN NULL;
            END;
            
            -- generate a dv no. for either manual or sys-gen dv.
            GIAC_DISB_VOUCHERS_PKG.generate_dv_no(p_fund_cd, 
                                                  p_branch_cd, 
                                                  'DV_NO',
                                                  p_seq_fund_cd,
                                                  p_seq_branch_cd,
                                                  p_dv_pref,
                                                  p_dv_no,
                                                  p_message);
            
            --GIAC_DISB_VOUCHERS_PKG.validate_dv_no(p_dv_no, p_dv_pref, p_fund_cd, p_branch_cd);--mikel 05.18.2016; RSIC 22040
            
             /* Set DV Print Date */
             IF p_global_dv_tag IS NULL THEN 
                p_dv_tag := p_global_dv_tag;
                
                IF p_check_dv_print = '3' THEN
                    
                    p_str_print_date := TO_CHAR(p_print_date, 'MM-DD-YYYY') || ' ' || TO_CHAR(p_print_date, 'HH:MI: AM');
    --                p_print_date := TO_DATE(p_str_print_date, 'MM-DD-YYYY HH:MI AM');
                END IF;
             ELSIF p_global_dv_tag = 'M' THEN
            
                p_str_print_date := TO_CHAR(p_print_date, 'MM-DD-YYYY') || ' ' || TO_CHAR(p_print_date, 'HH:MI: AM');
                p_dv_tag := '*';
             END IF;  
             
             --mikel 05.18.2016;  RSIC 22040, update of doc sequence should be after insert of record not during update of record
             --moved from POST_INSERT proc     
             GIAC_DISB_VOUCHERS_PKG.update_giac_doc_sequence(p_fund_cd,
                                                            p_branch_cd,
                                                            'DV_NO',
                                                            p_dv_pref,
                                                            p_dv_no);
        
        END IF;
        
   END validate_insert;



   -- inserts/updates
   PROCEDURE set_disb_voucher(p_voucher       IN  OUT    giac_disb_vouchers%ROWTYPE) 
   IS   
   BEGIN
        MERGE INTO giac_disb_vouchers
        USING dual 
           ON (gacc_tran_id = p_voucher.gacc_tran_id)
         WHEN NOT MATCHED THEN
              INSERT (gacc_tran_id,     gibr_gfun_fund_cd,  gibr_branch_cd,
                      gouc_ouc_id,      gprq_ref_id,        req_dtl_no,
                      particulars,      dv_amt,             dv_created_by,
                      dv_create_date,   dv_flag,            payee,
                      currency_cd,      dv_date,            dv_no,
                      dv_print_date,    dv_approved_by,     dv_approve_date,
                      dv_tag,           dv_pref,            print_tag,
                      ref_no,           user_id,            last_update,
                      payee_no,         payee_class_cd,     dv_fcurrency_amt,
                      currency_rt,      replenished_tag)
                      
              VALUES (p_voucher.gacc_tran_id,       p_voucher.gibr_gfun_fund_cd,    p_voucher.gibr_branch_cd,
                      p_voucher.gouc_ouc_id,        p_voucher.gprq_ref_id,          p_voucher.req_dtl_no,
                      p_voucher.particulars,        p_voucher.dv_amt,               p_voucher.dv_created_by,
                      p_voucher.dv_create_date,     p_voucher.dv_flag,              p_voucher.payee,
                      p_voucher.currency_cd,        p_voucher.dv_date,              p_voucher.dv_no,
                      p_voucher.dv_print_date,      p_voucher.dv_approved_by,       p_voucher.dv_approve_date,
                      p_voucher.dv_tag,             p_voucher.dv_pref,              p_voucher.print_tag,
                      p_voucher.ref_no,             p_voucher.user_id,              p_voucher.last_update,
                      p_voucher.payee_no,           p_voucher.payee_class_cd,       p_voucher.dv_fcurrency_amt,
                      p_voucher.currency_rt,        p_voucher.replenished_tag)
         
         WHEN MATCHED THEN
              UPDATE 
              SET dv_flag = p_voucher.dv_flag,
                  payee = p_voucher.payee,
                  particulars = p_voucher.particulars, 
                  user_id = p_voucher.user_id,
                  dv_print_date = p_voucher.dv_print_date,
                  dv_approve_date = p_voucher.dv_approve_date, --TO_DATE(TO_CHAR(p_voucher.dv_approve_date, 'mm-dd-yyyy HH12:MI:SS AM'), 'mm-dd-yyyy HH12:MI:SS AM'),
                  last_update = SYSDATE; --p_voucher.last_update;
                  -- verify if what fields can be updated.
        
   END set_disb_voucher;
   
   -- post -insert trigger in gidv block
   PROCEDURE post_insert(
        p_fund_cd           IN          giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd         IN          giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_gacc_tran_id      IN          giac_disb_vouchers.gacc_tran_id%TYPE,
        p_dv_no             IN          giac_disb_vouchers.dv_no%TYPE,
        p_dv_pref           IN          giac_disb_vouchers.dv_pref%TYPE,
        p_dv_date           IN          giac_disb_vouchers.dv_date%TYPE,
        p_print_tag         IN          giac_disb_vouchers.print_tag%TYPE,
        p_ref_id            IN          giac_disb_vouchers.gprq_ref_id%TYPE,
        p_document_cd       IN          giac_payt_requests.document_cd%TYPE,
        p_line_cd           IN          giac_payt_requests.line_cd%TYPE,
        p_doc_year          IN          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            IN          giac_payt_requests.doc_mm%TYPE,
        p_doc_seq_no        IN          giac_payt_requests.doc_seq_no%TYPE,
        p_message           OUT         VARCHAR2,
        p_workflow_msgr     OUT         VARCHAR2
   )
   IS   
   BEGIN
   
        GIAC_ACCTRANS_PKG.update_acctrans_giacs002(p_dv_date, p_dv_no, p_gacc_tran_id);
        
         
        /*GIAC_DISB_VOUCHERS_PKG.update_giac_doc_sequence(p_fund_cd,
                                                        p_branch_cd,
                                                        'DV_NO',
                                                        p_dv_pref,
                                                        p_dv_no); */ --mikel 05.18.2016; RSIC 22040, update of doc sequence should be after insert of record not during update of record                                                    
                                                        
        BEGIN
          UPDATE giac_payt_requests 
             SET with_dv = 'Y'
           WHERE ref_id = p_ref_id;
             
          IF SQL%NOTFOUND THEN
--            msg_alert('Unable to update giac_payt_requests.', 'E', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.ERROR#Unable to update giac_payt_requests.');
          END IF;
        END;
        
        
        /** to delete workflow records of CSR to Accounting */
        BEGIN
            IF p_print_tag = 6 THEN
                FOR c1 IN (SELECT claim_id
                             FROM giac_direct_claim_payts a
                            WHERE 1 = 1
                              AND a.gacc_tran_id = p_gacc_tran_id)
                LOOP    
                    delete_workflow_rec3('CSR TO ACCOUNTING','GICLS032', NVL(giis_users_pkg.app_user, USER),c1.claim_id);
                END LOOP;	
                	
                FOR c1 IN (SELECT claim_id
                             FROM giac_inw_claim_payts a
                            WHERE 1 = 1
                              AND a.gacc_tran_id = p_gacc_tran_id)
                LOOP    
                    delete_workflow_rec3('CSR TO ACCOUNTING','GICLS032', NVL(giis_users_pkg.app_user, USER),c1.claim_id);  
                END LOOP;     
            END IF;	
        END;
        
        /** to delete workflow records of Create DV */
        --delete_workflow_rec('CREATE DV','GIACS016',USER,:GIDV.gprq_ref_id);  
        delete_workflow_rec3('CREATE DV','GIACS016', NVL(giis_users_pkg.app_user, USER), p_ref_id);
        
        /** to create workflow records of Approve DV */
        BEGIN 
          FOR c1 IN (SELECT b.userid, d.event_desc  
                       FROM giis_events_column c, 
                            giis_event_mod_users b, 
                            giis_event_modules a, 
                            giis_events d
                      WHERE 1 = 1
                        AND c.event_cd = a.event_cd
                        AND c.event_mod_cd = a.event_mod_cd
                        AND b.event_mod_cd = a.event_mod_cd
                        --AND b.userid <> USER  --A.R.C. 02.09.2006
                        AND b.passing_userid = NVL(giis_users_pkg.app_user, USER) --A.R.C. 02.06.2006
                        AND a.module_id = 'GIACS002'
                        AND a.event_cd = d.event_cd
                        AND UPPER(d.event_desc) = 'APPROVE DV')
          LOOP
--            CREATE_TRANSFER_WORKFLOW_REC('APPROVE DV',GET_APPLICATION_PROPERTY(CURRENT_FORM_NAME), c1.userid, :gidv.gacc_tran_id, c1.event_desc||' '||:gidv.dv_pref||'-'||LTRIM(TO_CHAR(:gidv.dv_no, '0999999999'))||' '||
--                                         :gidv.dsp_document_cd||'-'||:gidv.dsp_branch_cd||'-'||:gidv.dsp_line_cd||'-'||:gidv.dsp_doc_year||'-'||:gidv.dsp_doc_mm||'-'||:gidv.dsp_doc_seq_no);
            CREATE_TRANSFER_WORKFLOW_REC('APPROVE DV', 
                                         'GIACS002', 
                                         c1.userid, 
                                         p_gacc_tran_id, 
                                         c1.event_desc||' '||p_dv_pref||'-'||LTRIM(TO_CHAR(p_dv_no, '0999999999'))||' '||
                                                        p_document_cd||'-'||p_branch_cd||'-'||p_line_cd||'-'||p_doc_year||'-'||p_doc_mm||'-'||p_doc_seq_no,
                                         p_message,
                                         p_workflow_msgr,
                                         NVL(giis_users_pkg.app_user, USER));
          END LOOP;
        END; 

   END post_insert;
   
   
   PROCEDURE update_giac_doc_sequence(
        p_fund_cd    giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,  
        p_branch_cd  giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_doc_name   giac_doc_sequence.doc_name%TYPE,
        p_dv_pref    giac_doc_sequence.doc_pref_suf%TYPE,
        p_dv_no      giac_doc_sequence.doc_seq_no%TYPE
   )IS
   BEGIN
        UPDATE giac_doc_sequence
           SET doc_seq_no = p_dv_no,
               user_id = NVL(giis_users_pkg.app_user, USER),
               last_update = SYSDATE
         WHERE fund_cd = p_fund_cd
           AND branch_cd = p_branch_cd
           AND doc_name = p_doc_name
           AND NVL(doc_pref_suf, '-') = NVL(p_dv_pref, NVL(doc_pref_suf, '-'));
           
        IF SQL%NOTFOUND THEN
            INSERT INTO giac_doc_sequence
                   (fund_cd, branch_cd,
                    doc_name, doc_seq_no,
                    user_id, last_update,
                    doc_pref_suf)
            VALUES (p_fund_cd, p_branch_cd,
                    p_doc_name, p_dv_no, 
                    NVL(giis_users_pkg.app_user, USER), SYSDATE,
                    p_dv_pref);
              
            IF SQL%NOTFOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#Error updating giac_doc_sequence for dv_no.'); 
--                msg_alert('Error updating giac_doc_sequence for dv no.', 'E', TRUE);
            END IF;
        END IF;
   END update_giac_doc_sequence;
   
   /*    
   **    -- ACCOUNTING ENTRIES GENERATION PROCEDURES --
   **
   */   
   

    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  04.22.2013
    **  Reference By : (GIACS002 - Generate Disbursement Voucher)
    **  Description  : Executes the AEG_PARAMETERS program unit in POST-FORMS-COMMIT Trigger
    */ 
    PROCEDURE aeg_parameters_002(
        p_aeg_tran_id           GIAC_ACCTRANS.tran_id%TYPE,
        p_aeg_module_nm         GIAC_MODULES.module_name%TYPE,
        p_fund_cd               GIAC_ACCT_ENTRIES.GACC_GFUN_FUND_CD%TYPE,
        p_branch_cd             GIAC_ACCT_ENTRIES.GACC_GIBR_BRANCH_CD%TYPE
    ) IS
        CURSOR chk_disb IS
            SELECT bank_cd, bank_acct_cd, amount
              FROM giac_chk_disbursement
             WHERE gacc_tran_id = p_aeg_tran_id;
             
        v_variables_gen_type        giac_modules.generation_type%TYPE;
    BEGIN
        -- Step 1. get_generation_type
        SELECT GIAC_DISB_VOUCHERS_PKG.get_generation_type(p_aeg_module_nm)
          INTO v_variables_gen_type
          FROM dual;
          
        -- Step 2. delete existing acct_entries
        GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries(p_aeg_tran_id, v_variables_gen_type);
        
        -- Step 3. create acct_entries
        FOR chk_disb_rec IN chk_disb
        LOOP
            GIAC_DISB_VOUCHERS_PKG.aeg_create_acct_entries_002(chk_disb_rec.bank_cd,
                                                               chk_disb_rec.bank_acct_cd,
                                                               chk_disb_rec.amount,
                                                               v_variables_gen_type,
                                                               p_branch_cd,
                                                               p_fund_cd,
                                                               p_aeg_tran_id);
        END LOOP;
    
    END aeg_parameters_002;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  04.22.2013
    **  Reference By : (GIACS002 - Generate Disbursement Voucher)
    **  Description  : Executes the AEG_Create_Acct_Entries program unit in GIACS002
    */ 
    PROCEDURE aeg_create_acct_entries_002(
        p_aeg_bank_cd           giac_chk_disbursement.bank_cd%TYPE,
        p_aeg_bank_acct_cd      giac_chk_disbursement.bank_acct_cd%TYPE,
        p_aeg_amount            giac_chk_disbursement.amount%TYPE,
        p_aeg_gen_type          giac_acct_entries.generation_type%TYPE,
        p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
        p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
        p_gacc_tran_id          giac_acctrans.tran_id%TYPE
    ) IS
        v_gl_acct_id         GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
        v_sl_cd              giac_acct_entries.sl_cd%TYPE;  
        v_gl_acct_category   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
        v_gl_control_acct    GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
        v_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2      GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        v_gl_sub_acct_3      GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4      GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5      GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7      GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      
        v_debit_amt          GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0;
        v_credit_amt         GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
    
    BEGIN
        -- Populate the GL Account Code used in every transactions.
        BEGIN
            SELECT gl_acct_id, sl_cd
              INTO v_gl_acct_id, v_sl_cd
              FROM giac_bank_accounts
             WHERE bank_cd = p_aeg_bank_cd
               AND bank_acct_cd = p_aeg_bank_acct_cd;
               
        EXCEPTION
            WHEN no_data_found THEN
                --Msg_Alert('No data found in giac_bank_accounts.','E',true);
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#No data found in giac_bank_accounts.');
        END;
        
        
        -- check if the acctg code exists in GIAC_CHART_OF_ACCTS table.
        GIAC_DISB_VOUCHERS_PKG.check_chart_of_accts_002(v_gl_acct_id,       v_gl_acct_category,
                                                        v_gl_control_acct,  v_gl_sub_acct_1,
                                                        v_gl_sub_acct_2,    v_gl_sub_acct_3,
                                                        v_gl_sub_acct_4,    v_gl_sub_acct_5,
                                                        v_gl_sub_acct_6,    v_gl_sub_acct_7);
                                                        
        -- assign values to debit and credit amt.
        v_debit_amt := 0;
        v_credit_amt := p_aeg_amount;
        
        
        -- Check if the derived GL code exists in GIAC_ACCT_ENTRIES table
        -- for the same transaction id. Insert the record if it does not 
        -- exist, else update the existing record.
        -- reused the existing procedure
        GIAC_ACCT_ENTRIES_PKG.aeg_insert_update_acct_entries(p_gacc_branch_cd,      p_gacc_fund_cd,     p_gacc_tran_id,
                                                             v_gl_acct_category,    v_gl_control_acct,  v_gl_sub_acct_1,
                                                             v_gl_sub_acct_2,       v_gl_sub_acct_3,    v_gl_sub_acct_4,
                                                             v_gl_sub_acct_5,       v_gl_sub_acct_6,    v_gl_sub_acct_7,
                                                             v_sl_cd,               null,               null,
                                                             p_aeg_gen_type,        v_gl_acct_id,       v_debit_amt,
                                                             v_credit_amt);

                  
    
    END aeg_create_acct_entries_002;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  04.22.2013
    **  Reference By : (GIACS002 - Generate Disbursement Voucher)
    **  Description  : Executes the AEG_Check_Chart_Of_Accts program unit in GIACS002
    */ 
    PROCEDURE check_chart_of_accts_002(
        cca_gl_acct_id       IN     GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        cca_gl_acct_category IN OUT GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        cca_gl_control_acct  IN OUT GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        cca_gl_sub_acct_1    IN OUT giac_acct_entries.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3    IN OUT giac_acct_entries.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7    IN OUT GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE
    ) IS 
    
    BEGIN
      SELECT gl_acct_category,  gl_control_acct, 
             gl_sub_acct_1,     gl_sub_acct_2,
             gl_sub_acct_3,     gl_sub_acct_4,    
             gl_sub_acct_5,     gl_sub_acct_6,
             gl_sub_acct_7
        INTO cca_gl_acct_category,  cca_gl_control_acct,
             cca_gl_sub_acct_1,     cca_gl_sub_acct_2,  
             cca_gl_sub_acct_3,     cca_gl_sub_acct_4,
             cca_gl_sub_acct_5,     cca_gl_sub_acct_6,
             cca_gl_sub_acct_7
        FROM giac_chart_of_accts
       WHERE gl_acct_id = cca_gl_acct_id;
    
    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20001,'Geniisys Exception#E#GL account id ' || TO_CHAR(cca_gl_acct_id) || ' does not exist in giac_chart_of_accts.');
            
    END check_chart_of_accts_002;
 
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.22.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Executes the get_generation_type program unit
  */
  FUNCTION get_generation_type(p_module_name    giac_modules.module_name%TYPE) 
    RETURN VARCHAR 
  IS
       CURSOR gen_type IS
        SELECT generation_type
          FROM giac_modules
         WHERE module_name = p_module_name;
         
       v_gen_type       giac_modules.generation_type%TYPE;
  BEGIN
        OPEN gen_type;
        
        FETCH gen_type 
         INTO v_gen_type;

        IF gen_type%NOTFOUND THEN
          --msg_alert('Generation type not found.', 'E', TRUE);
          RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Generation Type not found.');
        END IF;
        
        CLOSE gen_type;  
        RETURN (v_gen_type);
  EXCEPTION 
        WHEN OTHERS THEN 
            RETURN NULL;   
  END get_generation_type;
   
  
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.23.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : To check if the DV being cancelled is an Outward Facul Premium Payment Request.
  **                  Executes IS_OFPPR function
  */
  FUNCTION is_ofppr(
        p_tran_id           giac_acctrans.tran_id%TYPE
  ) RETURN VARCHAR2
  IS
        v_document_cd       GIAC_PAYT_REQUESTS.document_cd%type;
  BEGIN
        SELECT b.document_cd
          INTO v_document_cd
          FROM giac_disb_vouchers a, giac_payt_requests b
         WHERE a.gprq_ref_id = b.ref_id 
           AND gacc_tran_id = p_tran_id;
        
       IF v_document_cd = 'OFPPR'
       THEN
          RETURN 'TRUE';
       ELSE
          RETURN 'FALSE';
       END IF;
       
  EXCEPTION 
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            RETURN 'FALSE';        
  END is_ofppr; 
  
  
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.23.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Verify the transaction of the OFPPR; 
  **              --if the CM is already Posted (tran_flag='P') do not allow cancellation of the DV.
  **              --if the CM is already Closed (tran_flag='C') verify the collection DTL
  **                  
  **              giac_cm_dm.gacc_tran_id=giac_acctrans.tran_id  (to get the tran_flag of the CM)
  **              giac_cm_dm.dv_tran_id = giac_disb_vouchers.gacc_tran_id (to get the record on DV for the CM
  */
 PROCEDURE verify_ofppr_trans (
        p_gacc_tran_id      IN      giac_disb_vouchers.gacc_tran_id%TYPE,
        p_memo_type         OUT     giac_cm_dm.memo_type%TYPE,
        p_memo_year         OUT     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no       OUT     giac_cm_dm.memo_seq_no%TYPE,
        p_exists            OUT     giac_cm_dm.dv_tran_id%TYPE
  )
  IS
--       v_exists        giac_cm_dm.dv_tran_id%TYPE;
       v_memo_type     giac_cm_dm.memo_type%TYPE;
       v_memo_year     giac_cm_dm.memo_year%TYPE;
       v_memo_seq_no   giac_cm_dm.memo_seq_no%TYPE;
       v_tran_flag     VARCHAR2 (1);
  BEGIN
        FOR rec IN (SELECT gacc_tran_id, dv_tran_id, memo_type, memo_year,
                           LPAD (memo_seq_no, 6, 0) memo_seq_no
                      FROM giac_cm_dm
                     WHERE (dv_tran_id = p_gacc_tran_id 
                                OR gacc_tran_id = p_gacc_tran_id)  -- OR condition added by Kris 05.29.2013 SR13001
                       AND memo_status = 'P')
        LOOP
          p_exists := rec.gacc_tran_id;
          v_memo_type := rec.memo_type;
          v_memo_year := rec.memo_year;
          v_memo_seq_no := rec.memo_seq_no;
          EXIT;
        END LOOP;
        
        IF p_exists IS NOT NULL THEN
            p_memo_type := v_memo_type;
            p_memo_year := v_memo_year;
            p_memo_seq_no := v_memo_seq_no;
        END IF;
        
  END verify_ofppr_trans;
  
  
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.23.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Check if the GACC_TRAN_ID/CM_TRAN_ID of the CM transaction exists in GIAC_COLLECTION_DTL.
  **                  Check value of TRAN_FLAG in GIAC_ACCTRANS, for the particular GACC_TRAN_ID in GIAC_ORDER_OF_PAYTS.
  */
  PROCEDURE check_collection_dtl(
        p_tran_id       IN      giac_cm_dm.dv_tran_id%TYPE,
        p_memo_type     OUT     giac_cm_dm.memo_type%TYPE,
        p_memo_year     OUT     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no   OUT     giac_cm_dm.memo_seq_no%TYPE,
        p_or_found      OUT     VARCHAR2,
        p_message       OUT     VARCHAR2
  ) IS
        v_or_pref_suf   giac_order_of_payts.or_pref_suf%TYPE;
        v_or_no         giac_order_of_payts.or_no%TYPE;
        v_or_found      VARCHAR2(5) := 'FALSE'; -- BOOLEAN                                := FALSE;
        v_memo_type     giac_cm_dm.memo_type%TYPE;
        v_memo_year     giac_cm_dm.memo_year%TYPE;
        v_memo_seq_no   giac_cm_dm.memo_seq_no%TYPE;
        alert_mess      VARCHAR2 (200);
  BEGIN
        FOR rec IN (SELECT or_pref_suf, or_no
                      FROM giac_collection_dtl a,
                           giac_order_of_payts b,
                           giac_acctrans c
                     WHERE a.gacc_tran_id = b.gacc_tran_id
                       AND b.gacc_tran_id = c.tran_id
                       AND c.tran_flag != 'D'
                       AND NOT EXISTS (SELECT 1
                                         FROM giac_acctrans d, giac_reversals e
                                        WHERE d.tran_id = e.gacc_tran_id
                                          AND d.tran_id = b.gacc_tran_id
                                          AND d.tran_flag != 'D')
                       AND a.cm_tran_id = p_tran_id)
        LOOP
          v_or_pref_suf := rec.or_pref_suf;
          v_or_no := rec.or_no;
          v_or_found := 'TRUE';
          EXIT;
        END LOOP;
        
        FOR rec2 IN (SELECT dv_tran_id, memo_type, memo_year,
                            LPAD (memo_seq_no, 6, 0) memo_seq_no
                       FROM giac_cm_dm
                      WHERE gacc_tran_id = p_tran_id 
                        AND memo_status = 'P')
        LOOP
          v_memo_type := rec2.memo_type;
          v_memo_year := rec2.memo_year;
          v_memo_seq_no := rec2.memo_seq_no;
          EXIT;
        END LOOP;
        
        IF v_or_found = 'TRUE' THEN
            alert_mess := 'This DV has related CM ('
                             || v_memo_type || '-' || v_memo_year || '-' || LPAD (v_memo_seq_no, 6, 0)
                             || ' and OR  '
                             || v_or_pref_suf || '-' || LPAD (v_or_no, 10, 0) || ').'
                             || CHR (13) || ' Cancel first the OR before cancelling the DV.';
        ELSE
            alert_mess := 'This DV and it''s related CM ( '
                             || v_memo_type || '-' || v_memo_year || '-' || v_memo_seq_no
                             || ' )' || ' will be tagged as cancelled.';
        END IF;
        
        p_or_found  := v_or_found;
        p_memo_type := v_memo_type;
        p_memo_year := v_memo_year;
        p_memo_seq_no := v_memo_seq_no;
        p_message := alert_mess;
        
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END check_collection_dtl;
  
  
  -- called  after verify_ofppr_trans
  PROCEDURE pre_cancel_dv(
        p_tran_id       IN     giac_cm_dm.dv_tran_id%TYPE,
        p_memo_type     IN     giac_cm_dm.memo_type%TYPE,
        p_memo_year     IN     giac_cm_dm.memo_year%TYPE,
        p_memo_seq_no   IN     giac_cm_dm.memo_seq_no%TYPE
  ) IS
  BEGIN
        UPDATE giac_payt_requests_dtl x
           SET payt_req_flag = 'X'
         WHERE EXISTS (SELECT 1
                         FROM giac_disb_vouchers b
                        WHERE gacc_tran_id = p_tran_id
                          AND b.gprq_ref_id = x.gprq_ref_id
                          AND b.req_dtl_no = x.req_dtl_no);

        UPDATE giac_cm_dm
           SET memo_status = 'C'
         WHERE dv_tran_id = p_tran_id
           AND memo_type = p_memo_type
           AND memo_year = p_memo_year
           AND memo_seq_no = p_memo_seq_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;       
  END pre_cancel_dv;
  
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.23.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Validation and cancellation of DV
  */
  PROCEDURE cancel_dv(
        p_fund_cd       IN     giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN     giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_dv_date       IN     giac_disb_vouchers.dv_date%TYPE,
        p_dv_flag       IN     giac_disb_vouchers.dv_flag%TYPE,
        p_dv_pref       IN     giac_disb_vouchers.dv_pref%TYPE,
        p_dv_no         IN     giac_disb_vouchers.dv_no%TYPE,
        p_tran_id       IN     giac_cm_dm.dv_tran_id%TYPE,
        p_dv_status     OUT    giac_disb_vouchers.dv_flag%TYPE,
        p_dv_status_mean    OUT VARCHAR2,
        p_last_update       OUT DATE,
        p_last_update_str   OUT VARCHAR2
        --p_variables_tran_id    giac_acct_entries.gacc_tran_id%TYPE
  ) IS
        v_cancel            VARCHAR2(1); --added by Jerome 11-18-2k5
        v_closed_tag        VARCHAR2(1); --added by Jerome 11-18-2k5
        v_bill_nos          VARCHAR2(2000); --added by Jayson 11.16.2011
        v_ref_nos           VARCHAR2(2000); --added by Jayson 11.16.2011
        v_cant_cont         BOOLEAN := FALSE; --added by Jayson 11.16.2011     
        v_tran_flag         giac_acctrans.tran_flag%TYPE;   
        v_dummy             NUMBER; -- Pia, 09.15.04
        v_variables_tran_id     giac_acctrans.tran_id%TYPE;
        v_exist             NUMBER;  --added by albert 11.20.2015 (SR 20114/20608)
        v_msg               VARCHAR2(1000);   --added by pjsantos 08/09/2016 (GENQA 5031)     
        v_msg2              VARCHAR2(1000);   --added by pjsantos 08/09/2016 (GENQA 5031)    
        v_or_sw             VARCHAR2(1):='N'; --added by pjsantos 08/09/2016 (GENQA 5031)    
  BEGIN
        -- START added by Jayson 11.16.2011 --
        FOR rec1 IN (SELECT DISTINCT gacc_tran_id, transaction_type, b140_iss_cd, b140_prem_seq_no
                       FROM giac_direct_prem_collns
                      WHERE gacc_tran_id      = p_tran_id
                        --AND transaction_type IN (1,3) --removed by John Daniel SR-5182
                      ORDER BY 1,2,3,4)
        LOOP
            /*check_comm_payts(rec1.gacc_tran_id, 
                             rec1.b140_iss_cd, 
                             rec1.b140_prem_seq_no, 
                             v_bill_nos, 
                             v_ref_nos);*/--commented by albert 11.20.2015; use check_comm_payts2 (SR 20114/20608)
            
            check_comm_payts2(rec1.gacc_tran_id,
                              rec1.b140_iss_cd,
                              rec1.b140_prem_seq_no,
                              v_bill_nos,
                              v_ref_nos,
                              v_exist);
      
--            IF v_bill_nos IS NOT NULL THEN
                /*msg_alert('The commission of bill no. '||v_bill_nos||' was already settled. Please cancel the commission payment first before cancelling the D.V.'||CHR(13)||CHR(13)||
                          'Reference No.: '||CHR(13)||
                          v_ref_nos,'I',FALSE);*/
                
--                v_bill_nos  := NULL;
--                v_ref_nos   := NULL;
--                v_cant_cont := TRUE;
--            END IF;  --commented by albert 11.20.2015; modified condition below

              IF v_exist = 1 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#The commission of bill no. '||v_bill_nos||' was already settled. ' ||
                                                'Please cancel the commission payment first before cancelling the D.V.'||CHR(13)||CHR(13)||
                                                'Reference No.: '||CHR(13)|| v_ref_nos);
              ELSIF v_exist = 2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#The commission of bill no. '||v_bill_nos||' was already reversed. ' ||
                                                'Please cancel the reversal first before cancelling the D.V.'||CHR(13)||CHR(13)||
                                                'Reference No.: '||CHR(13)|| v_ref_nos);
              END IF;
           
        END LOOP;
  
        /*IF v_cant_cont THEN
            --RAISE FORM_TRIGGER_FAILURE;
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#The commission of bill no. '||v_bill_nos||' was already settled. ' ||
                                            'Please cancel the commission payment first before cancelling the D.V.'||CHR(13)||CHR(13)||
                                            'Reference No.: '||CHR(13)|| v_ref_nos);
        END IF;*/--commented by albert 11.20.2015
        -- END added by Jayson 11.16.2011 --
        
        
        
        FOR x IN (SELECT param_value_v cancel_param
                    FROM giac_parameters 
                   WHERE param_name = 'ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH')
        LOOP
      	    v_cancel := x.cancel_param;
            EXIT;	
        END LOOP;	  
                  
        FOR y IN (SELECT closed_tag 
                    FROM giac_tran_mm 
                   WHERE fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd --totel--7/17/2007--binalik lng s dati --giacp.v('BRANCH_CD')--
                     AND tran_yr = TO_NUMBER(TO_CHAR(p_dv_date,'YYYY'))  --TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
                     AND tran_mm = TO_NUMBER(TO_CHAR(p_dv_date,'MM')))   --TO_NUMBER(TO_CHAR(SYSDATE,'MM')))
        LOOP
            v_closed_tag := y.closed_tag;
            EXIT;
        END LOOP;
        
        IF v_cancel = 'N' AND v_closed_tag = 'Y' THEN
    	    --msg_alert('You are no longer allowed to cancel this transaction. The transaction month is already closed.','I',FALSE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#You are no longer allowed to cancel this transaction. The transaction month is already closed.');
	    ELSIF v_cancel = 'N' AND v_closed_tag = 'T' THEN
	  	  --msg_alert('You are no longer allowed to cancel this transaction. The transaction month is temporarily closed.','I',FALSE);
          RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#You are no longer allowed to cancel this transaction. The transaction month is temporarily closed.');
        
        ELSE -- Continue Cancellation
         
            SELECT GIAC_ACCTRANS_PKG.get_tran_flag(p_tran_id) 
              INTO v_tran_flag
              FROM DUAL;
              
            IF v_tran_flag IN ('C', 'P', 'O') THEN
                --al_id   ALERT := FIND_ALERT('CANCEL_DV');
                
                IF v_tran_flag = 'P' THEN
                    IF p_dv_flag = 'C' THEN
                        --msg_alert('This DV has already been cancelled.', 'I', TRUE);
                        RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#This DV has already been cancelled.');
                    END IF;
                    
                    GIAC_DISB_VOUCHERS_PKG.cancel_dv1(p_fund_cd, p_branch_cd, p_dv_pref, p_dv_no, p_tran_id);
                    
                ELSIF v_tran_flag IN ('O', 'C') THEN
                    GIAC_DISB_VOUCHERS_PKG.cancel_dv2(p_tran_id);
                END IF;
                
                 /*Added by pjsantos 08/09/2016,GENQA 5031 Cancels RCM of DV if related RCM is not yet applied to OR,    
                  if an OR is applied then it will prompt the user of existing OR's to be cancelled first.*/           
                   FOR x IN (SELECT   a.gacc_tran_id, fund_cd, branch_cd, memo_type, memo_year,    
                                      memo_seq_no, memo_date    
                                 FROM giac_cm_dm a, giac_collection_dtl b    
                                WHERE a.dv_tran_id = p_tran_id    
                                  AND a.gacc_tran_id = b.cm_tran_id(+)    
                             ORDER BY b.gacc_tran_id)    
                   LOOP    
                      FOR y IN (SELECT   a.gacc_tran_id    
                                    FROM giac_order_of_payts a,    
                                         giac_collection_dtl b,    
                                         giac_acctrans c    
                                   WHERE a.gacc_tran_id = b.gacc_tran_id    
                                     AND b.cm_tran_id = x.gacc_tran_id    
                                     AND a.gacc_tran_id = c.tran_id    
                                     AND c.tran_flag <> 'D'     
                                     AND NOT EXISTS (    
                                            SELECT 'X'    
                                              FROM giac_reversals z, giac_acctrans y    
                                             WHERE z.reversing_tran_id = y.tran_id    
                                               AND y.tran_flag <> 'D'    
                                               AND z.gacc_tran_id = a.gacc_tran_id)    
                                ORDER BY get_ref_no(a.gacc_tran_id))    
                      LOOP    
                         v_or_sw := 'Y';    
   
                         IF INSTR (NVL (v_msg, '!@#$%'), get_ref_no (y.gacc_tran_id)) = 0    
                         THEN    
                            v_msg :=    
                                  v_msg    
                               || CASE    
                                     WHEN v_msg IS NULL    
                                        THEN get_ref_no (y.gacc_tran_id)    
                                     ELSE ', ' || get_ref_no (y.gacc_tran_id)    
                                  END;    
                         END IF;    
                      END LOOP;    
    
                      IF v_or_sw = 'N'    
                      THEN   
                         giac_cm_dm_pkg.cancel_cm_dm (x.gacc_tran_id,    
                                                      x.fund_cd,    
                                                      x.branch_cd,    
                                                      x.memo_type,    
                                                      x.memo_year,    
                                                      x.memo_seq_no,    
                                                      x.memo_date,    
                                                      USER,    
                                                      v_tran_flag,    
                                                      v_msg2    
                                                     );    
                      END IF;    
                   END LOOP;    
   
                   IF v_or_sw = 'Y'    
                   THEN    
                      raise_application_error    
                         (-20001,    
                             'Geniisys Exception#imgMessage.ERROR#OR for RI Commission has already been generated for binder paid by this DV.'    
                          || CHR (10)    
                          || 'The following OR''s must be cancelled before DV can be cancelled:'    
                          || CHR (10)    
                          || v_msg    
                         );     
                   END IF;    
                /*pjsantos end*/    
                
                /* the ff IF sttement is added as part of synchronization. Pia, 09.15.04 */
                --IF NVL(giisp.v('IMPLEMENTATION_SW'),'N') = 'P' THEN                	     	
             	IF NVL(giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN --Vincent 10/26/04
                    BEGIN
                       SELECT count(*)
                         INTO v_dummy
                         FROM giac_advanced_payt
                        WHERE gacc_tran_id = p_tran_id
                          AND acct_ent_date IS NOT NULL;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN NULL;
                    END;

                    IF v_dummy > 0 THEN
                       GIAC_DISB_VOUCHERS_PKG.Insert_acctrans_cap_002(p_fund_cd, p_branch_cd, SYSDATE, 'CAP', p_dv_pref, p_dv_no, v_variables_tran_id);	--jason 09022009
                       GIAC_DISB_VOUCHERS_PKG.AEG_Parameters_Rev_002(p_tran_id, 'GIACB005', p_fund_cd, p_branch_cd);
                    END IF;

                    ---msg_alert('gacc_tran_id' || to_char(variables.tran_id),'i',false);
                    UPDATE giac_advanced_payt
                       SET cancel_date      = SYSDATE,
                           rev_gacc_tran_id = v_variables_tran_id
                     WHERE gacc_tran_id     = p_tran_id; 
                    --FORMS_DDL('COMMIT');
                END IF; -- end of modification. Pia, 09.15.04
                
                -- START consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --
          	    --jason 09022009: generate PCC transaction and update the cancel_date of giac_prepaid_comm
                IF NVL(giacp.v('ENTER_PREPAID_COMM'),'N') = 'Y' THEN
                    FOR a IN (SELECT 1
                                FROM giac_prepaid_comm
                               WHERE gacc_tran_id = p_tran_id
                                 AND acct_ent_date IS NOT NULL)
                    LOOP
                        GIAC_DISB_VOUCHERS_PKG.Insert_acctrans_cap_002(p_fund_cd, p_branch_cd, SYSDATE, 'PCC', p_dv_pref, p_dv_no, v_variables_tran_id);	--jason 09022009
                        GIAC_DISB_VOUCHERS_PKG.AEG_Parameters_Rev_002(p_tran_id, 'GIACB006', p_fund_cd, p_branch_cd);
                        
                        --insert_acctrans_cap(:gidv.gibr_gfun_fund_cd, :gidv.gibr_branch_cd,SYSDATE, 'PCC');
                        --AEG_Parameters_Rev(:GLOBAL.cg$giop_gacc_tran_id, 'GIACB006');
                        EXIT;
                    END LOOP;
  	
                    UPDATE giac_prepaid_comm
                       SET cancel_date      = SYSDATE,
                           rev_gacc_tran_id = v_variables_tran_id
                     WHERE gacc_tran_id     = p_tran_id;      
    
                    --FORMS_DDL('COMMIT');
                END IF;
                
                p_last_update := SYSDATE;
                p_last_update_str := TO_CHAR(SYSDATE, 'mm-dd-yyyy HH12:MI:SS AM');
                p_dv_status := 'C';
                BEGIN
                    CHK_CHAR_REF_CODES(p_dv_status                      /* MOD: Value to be validated    */
                                       ,p_dv_status_mean              /* MOD: Domain meaning           */
                                       ,'GIAC_DISB_VOUCHERS.DV_FLAG');   /* IN : Reference codes domain   */
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_dv_status_mean := NULL;
                WHEN OTHERS THEN NULL;
    --              CGTE$OTHER_EXCEPTIONS;               
                END;
                
  				--jason 09022009: end of modification
       		    -- END consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --
            
            ELSIF v_tran_flag = 'D' THEN
                --msg_alert('Cancellation not allowed. This is ' || 'a deleted transaction.', 'E', TRUE);
                raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#Cancellation not allowed. This is a deleted transaction.');
            ELSE
                --msg_alert('Cancel DV: Invalid tran flag.', 'E', TRUE);
                raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#Cancel DV: Invalid tran flag.');
            END IF;
        
        END IF;
           
  END cancel_dv;
  
  
  PROCEDURE cancel_dv1(
         p_fund_cd                  IN      giac_acctrans.gfun_fund_cd%TYPE,
         p_branch_cd                IN      giac_acctrans.gibr_branch_cd%TYPE,
         p_dv_pref                  IN      giac_disb_vouchers.dv_pref%TYPE,
         p_dv_no                    IN      giac_disb_vouchers.dv_no%TYPE,
         p_tran_id                  IN      giac_disb_vouchers.gacc_tran_id%TYPE
         --v_variables_rev_tran_id    OUT     giac_acctrans.tran_id%TYPE
  ) IS
        CURSOR fund IS
            SELECT '1'
              FROM giis_funds
             WHERE fund_cd = p_fund_cd;

        CURSOR branch IS
            SELECT '1'
              FROM giac_branches
             WHERE branch_cd = p_branch_cd;
        
        v_fund          VARCHAR2(1);
        v_branch        VARCHAR2(1);
        v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
        v_tran_year     giac_acctrans.tran_year%TYPE;
        v_tran_month    giac_acctrans.tran_month%TYPE;
        v_tran_class_no giac_acctrans.tran_class_no%TYPE;
        v_particulars   giac_acctrans.particulars%TYPE;
        v_variables_rev_tran_id    giac_acctrans.tran_id%TYPE;
  BEGIN
  
        OPEN fund;        
        FETCH fund INTO v_fund;
        
        IF fund%NOTFOUND THEN
            --msg_alert('Invalid fund code.', 'I', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#Invalid fund code.');
        ELSE
            OPEN branch;
            FETCH branch INTO v_branch;
            
            IF branch%NOTFOUND THEN
                --msg_alert('Invalid branch code.', 'I', TRUE);
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#Invalid branch code.');
            END IF;
            CLOSE branch;
        END IF;
        
        CLOSE fund;
        
        BEGIN 
            SELECT acctran_tran_id_s.nextval
              INTO v_variables_rev_tran_id
              FROM dual;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.');  
              --msg_alert('ACCTRAN_TRAN_ID sequence not found.', 'E', TRUE);
        END;
        
        BEGIN
            SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
              INTO v_tran_year
              FROM DUAL;  
        END;
        
        BEGIN
            SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'MM'))
              INTO v_tran_month
              FROM DUAL;  
        END;  
        
        v_tran_seq_no := giac_sequence_generation(p_fund_cd,
                                                  p_branch_cd,
                                                  'ACCTRAN_TRAN_SEQ_NO',
                                                  v_tran_year,
                                                  v_tran_month);
                                                  
        v_tran_class_no := giac_sequence_generation(p_fund_cd,
                                                    p_branch_cd,
                                                    'REV',
                                                    0,
                                                    0);
                                                    
        IF p_dv_pref IS NULL THEN
            v_particulars := 'Reversing entry for cancelled DV No. ' || TO_CHAR(p_dv_no) || '.';
        ELSE
            v_particulars := 'Reversing entry for cancelled DV No. ' || p_dv_pref || '-' || TO_CHAR(p_dv_no) || '.';
        END IF;
        
        INSERT 
          INTO giac_acctrans
               (tran_id,                    gfun_fund_cd, 
                gibr_branch_cd,             tran_year,
                tran_month,                 tran_seq_no,
                tran_date,                  tran_flag,                             
                tran_class,                 tran_class_no,
                particulars,                user_id,
                last_update)
        VALUES (v_variables_rev_tran_id,    p_fund_cd,
                p_branch_cd,                v_tran_year, 
                v_tran_month,               v_tran_seq_no,
                SYSDATE,                    'C', 
                'REV',                      v_tran_class_no,
                v_particulars,              NVL(giis_users_pkg.app_user,USER),
                SYSDATE);
                
        IF SQL%NOTFOUND THEN
            --msg_alert('Cancel DV1: Unable to insert into acctrans.', 'E', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV1: Unable to insert into acctrans.');
        ELSE
        -----------------    1
            DECLARE
              CURSOR tr_closed IS
                SELECT acct_entry_id, gl_acct_id,
                       gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4, 
                       gl_sub_acct_5, gl_sub_acct_6, 
                       gl_sub_acct_7, sl_cd,
                       debit_amt, credit_amt,
                       generation_type, sl_type_cd
                  FROM giac_acct_entries
                  WHERE gacc_tran_id = p_tran_id;  
                    
              v_debit_amt        giac_acct_entries.debit_amt%TYPE;  
              v_credit_amt       giac_acct_entries.credit_amt%TYPE;  
              v_debit_amt2       giac_acct_entries.debit_amt%TYPE;  
              v_credit_amt2      giac_acct_entries.credit_amt%TYPE;  
              v_acct_entry_id    giac_acct_entries.acct_entry_id%TYPE;
            
            BEGIN
            
                FOR tr_closed_rec IN tr_closed LOOP
                    FOR entr_id in (SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
                                      FROM giac_acct_entries
                                     WHERE gacc_gibr_branch_cd          = p_branch_cd
                                       AND gacc_gfun_fund_cd            = p_fund_cd
                                       AND gacc_tran_id                 = v_variables_rev_tran_id            
                        --            AND gl_acct_id = tr_closed_rec.gl_acct_id									--totel--2/2/2007--repalaced by the ff. code
                                       AND NVL(gl_acct_id, gl_acct_id)  = tr_closed_rec.gl_acct_id  								 --for optimization purposes
                                       AND generation_type              = tr_closed_rec.generation_type
                                       AND NVL(sl_cd, 0)                = NVL(tr_closed_rec.sl_cd, NVL(sl_cd, 0))
                                       AND NVL(sl_type_cd, '-')         = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'))) 
                    LOOP
                      v_acct_entry_id := entr_id.acct_entry_id;
                      EXIT;
                    END LOOP;
                                
                    IF NVL(v_acct_entry_id,0) = 0 THEN
                        v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;
                           
                        INSERT 
                          INTO GIAC_ACCT_ENTRIES
                               (gacc_tran_id,                   gacc_gfun_fund_cd,
                                gacc_gibr_branch_cd,            gl_acct_id, 
                                 gl_acct_category,              gl_control_acct,
                                 gl_sub_acct_1,                 gl_sub_acct_2, 
                                 gl_sub_acct_3,                 gl_sub_acct_4, 
                                 gl_sub_acct_5,                 gl_sub_acct_6, 
                                 gl_sub_acct_7,                 sl_cd, 
                                 debit_amt,                     credit_amt, 
                                 generation_type,               sl_type_cd,
                                 user_id,                       last_update)
                        VALUES(v_variables_rev_tran_id,             p_fund_cd,
                               p_branch_cd,                         tr_closed_rec.gl_acct_id, 
                               tr_closed_rec.gl_acct_category,      tr_closed_rec.gl_control_acct, 
                               tr_closed_rec.gl_sub_acct_1,         tr_closed_rec.gl_sub_acct_2, 
                               tr_closed_rec.gl_sub_acct_3,         tr_closed_rec.gl_sub_acct_4,  
                               tr_closed_rec.gl_sub_acct_5,         tr_closed_rec.gl_sub_acct_6,  
                               tr_closed_rec.gl_sub_acct_7,         tr_closed_rec.sl_cd,
                               tr_closed_rec.credit_amt,            tr_closed_rec.debit_amt, 
                               tr_closed_rec.generation_type,       tr_closed_rec.sl_type_cd,
                               NVL(giis_users_pkg.app_user,USER),   SYSDATE);
                    ELSE
                      UPDATE giac_acct_entries
                         SET debit_amt  = debit_amt  + tr_closed_rec.credit_amt,
                             credit_amt = credit_amt + tr_closed_rec.debit_amt
                       WHERE generation_type        = tr_closed_rec.generation_type
                         AND gl_acct_id             = tr_closed_rec.gl_acct_id
                         AND gacc_gibr_branch_cd    = p_branch_cd
                         AND gacc_gfun_fund_cd      = p_fund_cd 
                         AND gacc_tran_id           = v_variables_rev_tran_id
                         AND NVL(sl_cd, 0)          = NVL(tr_closed_rec.sl_cd, 0)
                         AND NVL(sl_type_cd, '-')   = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'));
                    END IF; -- acct_entry_id = 0
                
                END LOOP;
            END;
            
            IF SQL%NOTFOUND THEN
                --FORMS_DDL('ROLLBACK');
                --msg_alert('Cancel DV: Unable to insert into acct entries.','E', TRUE);
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV: Unable to insert into acct entries.');
            ELSE
        ------------------  2
                INSERT 
                  INTO giac_reversals
                       (gacc_tran_id,   reversing_tran_id,          rev_corr_tag)
                VALUES (p_tran_id,      v_variables_rev_tran_id,    'R');
                
                IF SQL%NOTFOUND THEN
                    --FORMS_DDL('ROLLBACK');
                    --msg_alert('Cancel DV: Unable to insert into reversals.','E', TRUE);
                    RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV: Unable to insert into reversals.');
                ELSE
        ------------------  3
                    --/*A.R.C. 09.02.2005*/--
                    -- to delete workflow records of accounting
                     delete_workflow_rec('CANCEL DV', 'GIACS002', NVL(giis_users_pkg.app_user,USER), p_tran_id);
                    --/*09.02.2005*/--      
                        
                    UPDATE giac_disb_vouchers
                       SET dv_flag	 = 'C',
                           user_id = NVL(giis_users_pkg.app_user,USER),
                           last_update = SYSDATE
                     WHERE gacc_tran_id = p_tran_id;
                     
                     IF SQL%NOTFOUND THEN
                        --FORMS_DDL('ROLLBACK');
                        --msg_alert('Cancel DV: Unable to update disb_vouchers.', 'E', TRUE);
                        RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV: Unable to update disb_vouchers.');
                    ELSE
        ------------------  4
                        UPDATE giac_payt_requests_dtl
                           SET payt_req_flag = 'X',
                               user_id = USER,
                               last_update = SYSDATE,
                               cancel_date = SYSDATE,                          --:cg$ctrl.cgu$sysdate,
                               cancel_by = NVL(giis_users_pkg.app_user,USER)   --:cg$ctrl.cgu$user
                         WHERE tran_id = p_tran_id;
                         
                        IF SQL%NOTFOUND THEN
                            --FORMS_DDL('ROLLBACK');
                            --msg_alert('Cancel DV: Unable to update ' || 'giac_payt_requests_dtl.', 'E', TRUE);
                            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV: Unable to update giac_payt_requests_dtl.');
                        ELSE   
        ------------------  5
        --------------------------// 
                            DECLARE
                    --              CURSOR sp IS
                    --	        SELECT gacc_tran_id, item_no,
                    --                       bank_cd, bank_acct_cd,
                    --                       check_date, check_pref_suf,
                    --                       check_no,  check_stat,
                    --                       check_class, currency_cd,
                    --                       fcurrency_amt, currency_rt,
                    --                       amount, last_update
                    --                FROM giac_chk_disbursement
                    --                WHERE gacc_tran_id = :gidv.gacc_tran_id;
                                        
                                  v_selected_ctr    NUMBER := 0;
                                      
                            BEGIN
                                FOR sp IN (SELECT COUNT(*) kawnt
                                             FROM giac_chk_disbursement
                                            WHERE gacc_tran_id = p_tran_id) LOOP
                                    v_selected_ctr := sp.kawnt;
                                    EXIT;
                                END LOOP;
                                
                                --              FOR sp_rec IN sp LOOP
                                --                v_selected_ctr := v_selected_ctr + 1;
                                --                INSERT INTO giac_spoiled_check(
                                --                    gacc_tran_id, item_no,
                                --                    bank_cd, bank_acct_cd,
                                --                    check_date, check_no,
                                --                    check_stat, check_pref_suf,
                                --                    check_class, fcurrency_amt,
                                --                    currency_cd, currency_rt,
                                --                    amount, print_dt,
                                --                    user_id, last_update)
                                --                  VALUES(sp_rec.gacc_tran_id, sp_rec.item_no,
                                --                         sp_rec.bank_cd, sp_rec.bank_acct_cd,
                                --                         sp_rec.check_date,  sp_rec.check_no,
                                --                         sp_rec.check_stat, sp_rec.check_pref_suf,
                                --                         sp_rec.check_class, sp_rec.fcurrency_amt,
                                --                         sp_rec.currency_cd, sp_rec.currency_rt,
                                --                         sp_rec.amount, sp_rec.last_update,
                                --                         USER, SYSDATE);
                                --              END LOOP;
                                              
                                --              IF v_selected_ctr = 0 THEN
                                --                FORMS_DDL('COMMIT');
                                                                         
                                --                GO_BLOCK('gidv');
                                --                variables.just_cancelled := 'Y';
                                --                :GLOBAL.cancelled_dv := :gidv.gacc_tran_id;
                                --                SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 
                                --                                   'gacc_tran_id = :GLOBAL.cancelled_dv');
                                --                EXECUTE_QUERY;
                                --                SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
                                --                ERASE('GLOBAL.cancelled_dv');
                                --                variables.just_cancelled := 'N';
                                --              ELSIF v_selected_ctr > 0 THEN
                                --                IF SQL%NOTFOUND THEN
                                --                  FORMS_DDL('ROLLBACK');
                                --                  msg_alert('Cancel DV: Unable to insert ' ||
                                --                            'into spoiled check.', 'E', TRUE);
                                --                ELSE
                            
                                IF v_selected_ctr > 0 THEN
                                    UPDATE giac_chk_disbursement
                                       SET check_stat = '3',
                                           user_id = NVL(giis_users_pkg.app_user,USER),
                                           last_update = SYSDATE
                                     WHERE gacc_tran_id = p_tran_id;
                                                                     
                                    IF SQL%NOTFOUND THEN
                                        --FORMS_DDL('ROLLBACK');
                                        --msg_alert('Cancel DV: Unable to update ' ||'chk_disbursement.', 'E', TRUE);
                                        RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Cancel DV: Unable to update chk_disbursement.');
                                    ELSE 
                                        NULL;
                                      --FORMS_DDL('COMMIT');
                                                                                                                                  
                                      --GO_BLOCK('gidv');
                                      --variables.just_cancelled := 'Y';  -- used in pre-query
                                      --:GLOBAL.cancelled_dv := :gidv.gacc_tran_id;
                                      --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE,   'gacc_tran_id = :GLOBAL.cancelled_dv');
                                      --EXECUTE_QUERY;
                                      --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
                                      --ERASE('GLOBAL.cancelled_dv');
                                      --variables.just_cancelled := 'N';
                                    END IF;
                                    
                                ELSIF v_selected_ctr = 0 THEN
                                    NULL;
                                    --FORMS_DDL('COMMIT');
                                                                                                                                 
                                    --GO_BLOCK('gidv');
                                    --variables.just_cancelled := 'Y';  -- used in pre-query
                                    --:GLOBAL.cancelled_dv := :gidv.gacc_tran_id;
                                    --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE,  'gacc_tran_id = :GLOBAL.cancelled_dv');
                                    --EXECUTE_QUERY;
                                    --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
                                    --ERASE('GLOBAL.cancelled_dv');
                                    --variables.just_cancelled := 'N';
                                END IF;
                                
                            END;
                       
                        END IF; --- 5        
                    END IF; --- 4               
                END IF; -- 3
            END IF; --- 2        
        END IF; ----- 1
  
  END cancel_dv1;
  
  
  PROCEDURE cancel_dv2(
         p_tran_id                  IN      giac_disb_vouchers.gacc_tran_id%TYPE      
  ) IS
        v_exists   VARCHAR2(1);
  BEGIN
        --/*A.R.C. 09.02.2005*/--
        -- to delete workflow records of accounting
        delete_workflow_rec('CANCEL DV', 'GIACS002', NVL(giis_users_pkg.app_user,USER), p_tran_id);
        --/*09.02.2005*/-- 
        
        UPDATE giac_disb_vouchers
           SET dv_flag      = 'C',
               user_id      = NVL(giis_users_pkg.app_user,USER),
               last_update  = SYSDATE  
         WHERE gacc_tran_id = p_tran_id;
         
        --------------------- 1
        IF SQL%FOUND THEN
            UPDATE giac_payt_requests_dtl
               SET payt_req_flag    = 'X',
                   user_id          = NVL(giis_users_pkg.app_user,USER),
                   last_update      = SYSDATE,
                   cancel_date      = SYSDATE, -- :cg$ctrl.cgu$sysdate,
                   cancel_by        = NVL(giis_users_pkg.app_user,USER)  --:cg$ctrl.cgu$user      
             WHERE tran_id = p_tran_id;
       ---------------------  2    
            IF SQL%FOUND THEN
                UPDATE giac_acctrans
                   SET tran_flag = 'D'
                 WHERE tran_id = p_tran_id;
        
                IF SQL%FOUND THEN
       ----------// 3
                    DECLARE
                          CURSOR a1 IS
                            SELECT gacc_tran_id, item_no, check_stat
                              FROM giac_chk_disbursement
                              WHERE gacc_tran_id = p_tran_id;
                                      
                          v_selected_ctr    NUMBER := 0;
                    BEGIN
                           FOR a1_rec IN a1 
                           LOOP
                            v_selected_ctr := v_selected_ctr + 1;
                            UPDATE giac_chk_disbursement
                               SET check_stat   = DECODE(a1_rec.check_stat, '1', '1',
                                                                            '2', '3'),
                                   user_id      = NVL(giis_users_pkg.app_user,USER),
                                   last_update  = SYSDATE
                             WHERE gacc_tran_id = a1_rec.gacc_tran_id
                               AND item_no      = a1_rec.item_no;
                           END LOOP;
                                 
                          IF v_selected_ctr > 0 THEN
                                IF SQL%FOUND THEN
                                    NULL;
                                     --FORMS_DDL('COMMIT');
                                                                      
                                     --GO_BLOCK('gidv');
                                     --variables.just_cancelled := 'Y';
                                     --:GLOBAL.cancelled_dv := :gidv.gacc_tran_id;
                                     --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'gacc_tran_id = :GLOBAL.cancelled_dv');
                                     --EXECUTE_QUERY;
                                     --SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
                                     --ERASE('GLOBAL.cancelled_dv');    
                                     --variables.just_cancelled := 'N';            
                                ELSE
                                     --FORMS_DDL('ROLLBACK');
                                     --msg_alert('Unable to update chk_disbursement during ' || 'cancellation of DV with open/closed ' || 'tran_flag.', 'E', TRUE);
                                     RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Unable to update chk_disbursement during '|| 
                                                                    'cancellation of DV with open/closed tran_flag.');
                                END IF;
                          
                          ELSIF v_selected_ctr = 0 THEN
                            NULL;
                               /*FORMS_DDL('COMMIT');
                                                                    
                               GO_BLOCK('gidv');
                               variables.just_cancelled := 'Y';
                               :GLOBAL.cancelled_dv := :gidv.gacc_tran_id;
                               SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 
                                                  'gacc_tran_id = :GLOBAL.cancelled_dv');
                               EXECUTE_QUERY;
                               SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
                               ERASE('GLOBAL.cancelled_dv');    
                               variables.just_cancelled := 'N';*/
                          END IF;
                    END;
        -----------// 3
                ELSE
                    --FORMS_DDL('ROLLBACK');
                    --msg_alert('Unable to update acctrans during cancellation of ' ||'DV with open/closed tran_flag.', 'E', TRUE);
                    RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Unable to update acctrans during cancellation of DV with open/closed tran_flag.');
                END IF; 
                
            ELSE
                --FORMS_DDL('ROLLBACK');
                --msg_alert('Unable to update payt_requests_dtl during ' ||'cancellation of DV with open/closed tran_flag.','E', TRUE);
                RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Unable to update payt_requests_dtl during cancellation of DV with open/closed tran_flag.');
            END IF;    
        ----------- 2   
        ELSE
            --FORMS_DDL('ROLLBACK');
            --msg_alert('Unable to update disb_vouchers during ' ||'cancellation of DV with open/closed tran_flag.','E', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#Unable to update disb_vouchers during cancellation of DV with open/closed tran_flag.');
        END IF;  -----1
        
  END cancel_dv2;
  
  
  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.24.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Check values of fund_cd,branch_cd from acctrans
  */
  PROCEDURE insert_acctrans_cap_002 (
        p_fund_cd           GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,    -- vfund_cd
        p_branch_cd         GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,       -- vbranch_cd
        p_rev_tran_date     GIAC_ACCTRANS.tran_date%TYPE,
        p_tran_class		giac_acctrans.tran_class%TYPE,
        p_dv_pref           giac_disb_vouchers.dv_pref%TYPE,
        p_dv_no             giac_disb_vouchers.dv_no%TYPE,
        p_variable_tran_id  OUT     giac_acctrans.tran_id%TYPE
  ) IS
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
    --  v_booked_tag     giis_booking_month.booked_tag%TYPE;
      v_tran_flag      giac_acctrans.tran_flag%TYPE;
      v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
      v_particulars    giac_acctrans.particulars%TYPE;
      v_tran_date      giac_acctrans.tran_date%TYPE;
      v_tran_year      giac_acctrans.tran_year%TYPE;
      v_tran_month     giac_acctrans.tran_month%TYPE; 
      v_tran_seq_no    GIAC_ACCTRANS.tran_seq_no%TYPE;
      v_variables_tran_id    giac_acctrans.tran_id%TYPE;       
  BEGIN
        OPEN c1;
        FETCH c1 INTO v_c1;  
        
        IF c1%NOTFOUND THEN
          --Msg_Alert('Invalid company code.','I',TRUE);
          RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#Invalid company code.');
        ELSE
          OPEN c2;
          FETCH c2 INTO  v_c2;  
            IF c2%NOTFOUND THEN
              --Msg_Alert('Invalid branch code.','I',TRUE);
              RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#I#Invalid branch code.');
            END IF;
          CLOSE C2;
        END IF;
      CLOSE c1;
      
      -- If called by another form, display the corresponding OP 
      -- record of the current tran_id when the button OP Info is 
      -- pressed.
      
      BEGIN
          SELECT acctran_tran_id_s.nextval
            INTO v_variables_tran_id
            FROM dual;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --msg_alert('ACCTRAN_TRAN_ID sequence not found.','E', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.');
      END;
      
      p_variable_tran_id := v_variables_tran_id;
      
      v_user_id     := NVL(giis_users_pkg.app_user, USER);   --:CG$CTRL.cgu$user;
      v_tran_date   := p_rev_tran_date;
      ---v_tran_class_no := p_rev_tran_class_no;
      v_tran_flag   := 'C';
      v_tran_year   := TO_NUMBER(TO_CHAR(v_tran_date, 'YYYY'));
      v_tran_month  := TO_NUMBER(TO_CHAR(v_tran_date, 'MM'));  
      v_tran_seq_no := giac_sequence_generation(p_fund_cd,
                                                p_branch_cd,
                                                'ACCTRAN_TRAN_SEQ_NO',
                                                v_tran_year,
                                                v_tran_month);
      v_tran_class_no := giac_sequence_generation(p_fund_cd,
                                                  p_branch_cd,
                                                  'REV',
                                                  0,
                                                  0);         
      IF p_dv_pref IS NULL THEN
        v_particulars := 'Reversing entry of Premium deposit for cancelled DV No. ' || TO_CHAR(p_dv_no) || '.';
      ELSE
        v_particulars := 'Reversing entry of Premium deposit for cancelled DV No. ' || p_dv_pref || '-' || TO_CHAR(p_dv_no) || '.';
      END IF;        
      
      INSERT 
        INTO giac_acctrans
             (tran_id,              gfun_fund_cd, 
              gibr_branch_cd,       tran_date,
              tran_flag,            tran_class,
              tran_class_no,        particulars,
              tran_year,            tran_month, 
              tran_seq_no,          user_id, 
              last_update)
      VALUES (v_variables_tran_id,  p_fund_cd,
              p_branch_cd,          v_tran_date,
              v_tran_flag,          p_tran_class,  --'CAP',  --replaced by jason 09022009 
          										   --consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010
              v_tran_class_no,      v_particulars,
              v_tran_year,          v_tran_month, 
              v_tran_seq_no,        v_user_id, 
              v_last_update);
    
   --FORMS_DDL('COMMIT');       
  EXCEPTION
    WHEN OTHERS THEN NULL;                           
  END insert_acctrans_cap_002;
  
  
  PROCEDURE AEG_Parameters_Rev_002(
        p_aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
        p_aeg_module_nm    GIAC_MODULES.module_name%TYPE,
        p_fund_cd          giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
        p_branch_cd        giac_disb_vouchers.gibr_branch_cd%TYPE
  ) IS
        cursor colln_CUR is   
            SELECT a.assd_no, b.line_cd,sum(premium_amt + tax_amt)coll_amt
              FROM giac_advanced_payt a, gipi_polbasic b
             WHERE gacc_tran_id = p_aeg_tran_id
               AND a.policy_id = b.policy_id
               AND a.acct_ent_date is not null
          GROUP BY a.assd_no, b.line_cd;
          
      -- START consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --
      --jason 09022009: added the following cursor for the prepaid comm 
        CURSOR prep_comm_CUR IS
            SELECT a.intm_no, b.line_cd,
                   SUM((a.comm_amt + a.input_vat_amt) - a.wtax_amt) net_comm
              FROM GIAC_PREPAID_COMM a, GIPI_POLBASIC b
             WHERE gacc_tran_id    = p_aeg_tran_id
               AND a.policy_id     = b.policy_id
               AND a.acct_ent_date IS NOT NULL
             GROUP BY a.intm_no, b.line_cd;
      -- END consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --
      v_variables_module_id     giac_modules.module_id%TYPE;
      v_variables_gen_type      giac_modules.generation_type%TYPE;
  BEGIN
      BEGIN
            SELECT module_id,
                   generation_type
              INTO v_variables_module_id,
                   v_variables_gen_type
              FROM giac_modules
             WHERE module_name  = p_aeg_module_nm; --'GIACB005'; --replaced by jason 09022009: used the existing parameter for the module name
                                                   --consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010
      EXCEPTION
        WHEN no_data_found THEN
            --Msg_Alert('No data found in GIAC MODULES.', 'I', TRUE);
            raise_application_error(-20001,'Geniisys Exception#I#No data found in GIAC MODULES.');
      END;
      
      giac_acct_entries_pkg.AEG_Delete_Entries_Rev(p_aeg_tran_id, v_variables_gen_type);  --  use existing procedure in deleting accounting entries
      
      
      -- START consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --
      IF p_aeg_module_nm = 'GIACB005' THEN     
        FOR COLLN_rec in COLLN_CUR LOOP
            giac_disb_vouchers_pkg.create_rev_entries_002(COLLN_rec.assd_no,    COLLN_rec.coll_amt, COLLN_rec.line_cd, 
                                                          p_aeg_module_nm, --'GIACB005'
                                                          p_fund_cd,            p_branch_cd,        p_aeg_tran_id) ;
        END LOOP;
      
      ELSIF p_aeg_module_nm = 'GIACB006' THEN  --jason 09032009
        FOR comm_rec IN prep_comm_CUR LOOP
            giac_disb_vouchers_pkg.create_rev_entries_002(comm_rec.intm_no,     comm_rec.net_comm,  comm_rec.line_cd, 
                                                          p_aeg_module_nm, --'GIACB006'
                                                          p_fund_cd,            p_branch_cd,        p_aeg_tran_id);
        END LOOP;
      END IF;       
      -- END consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010 --    
  
  END AEG_Parameters_Rev_002;
  
  
  PROCEDURE create_rev_entries_002(
        p_assd_no     IN GIPI_POLBASIC.assd_no%TYPE,
        p_coll_amt    IN GIAC_COMM_PAYTS.comm_amt%TYPE,
        p_line_cd     IN giis_line.line_cd%TYPE,
        p_module_name IN giac_modules.module_name%TYPE,
        p_fund_cd     IN giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,   
        p_branch_cd   IN giac_disb_vouchers.gibr_branch_cd%TYPE,
        p_tran_id     IN giac_disb_vouchers.gacc_tran_id%TYPE
  ) IS
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
            SELECT A.GL_ACCT_CATEGORY,      A.GL_CONTROL_ACCT, 
                   NVL(A.GL_SUB_ACCT_1,0),  NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                   NVL(A.GL_SUB_ACCT_5,0),  NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0),
                   A.dr_cr_tag,             B.generation_type,      A.sl_type_cd,           A.LINE_DEPENDENCY_LEVEL  
              INTO V_GL_ACCT_CATEGORY,      V_GL_CONTROL_ACCT, 
                   V_GL_SUB_ACCT_1,         V_GL_SUB_ACCT_2,        V_GL_SUB_ACCT_3,        V_GL_SUB_ACCT_4, 
                   V_GL_SUB_ACCT_5,         V_GL_SUB_ACCT_6,        V_GL_SUB_ACCT_7,        V_INTM_TYPE_LEVEL,
                   v_dr_cr_tag,             v_gen_type,             v_sl_type_cd,           v_LINE_DEPENDENCY_LEVEL  
              FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
             WHERE B.module_name = p_module_name  --'GIACB005'   --replaced by jason 09032009
                                                  --consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010
               AND A.item_no = 1
               AND B.module_id = A.module_id;        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              --Msg_Alert('CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.','E',TRUE);
              raise_application_error(-20001, 'Geniisys Exception#E#CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.');
        END;	--c2
        
        
        GIAC_DISB_VOUCHERS_PKG.Check_Chart_Of_Accts_002(v_gl_acct_id,       v_gl_acct_category, v_gl_control_acct,
                                                        v_gl_sub_acct_1,    v_gl_sub_acct_2,    v_gl_sub_acct_3, 
                                                        v_gl_sub_acct_4,    v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                                        v_gl_sub_acct_7);   
                                                        
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
        
        giac_acct_entries_pkg.AEG_Insert_Update_Entries_rev(v_gl_acct_category, v_gl_control_acct,
                                                            v_gl_sub_acct_1,    v_gl_sub_acct_2,    v_gl_sub_acct_3,
                                                            v_gl_sub_acct_4,    v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                                            v_gl_sub_acct_7,    v_sl_type_cd,       '1',
                                                            p_assd_no,          v_gen_type,         v_gl_acct_id, 
                                                            v_debit_amt,        v_credit_amt,
                                                            p_fund_cd,          p_branch_cd,        p_tran_id);
                                                            
        BEGIN
            BEGIN
                SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
                       NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                       NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.LINE_DEPENDENCY_LEVEL,0), A.dr_cr_tag,
                       B.generation_type 
                  INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
                       V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
                       V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_LINE_DEPENDENCY_LEVEL, v_dr_cr_tag,
                       v_gen_type
                  FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
                 WHERE B.module_name = p_module_name  --'GIACB005'   --replaced by jason 09032009
                                                      --consolidated version 09.24.2009 with version 11.05.2009 by jayson 03.24.2010
                   AND A.item_no     = 2
                   AND B.module_id   = A.module_id; 

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    --Msg_Alert('COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.','E',TRUE);
                    raise_application_error(-20001,'Geniisys Exception#E#COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.');
            END;	--e2
            
            IF v_LINE_DEPENDENCY_LEVEL != 0 THEN  	--2.1  
                BEGIN	--d1
                    SELECT acct_line_cd
                      INTO ws_line_cd
                      FROM giis_line
                     WHERE line_cd = p_line_cd;
                EXCEPTION
                    WHEN no_data_found THEN 
                        raise_application_error(-20001,'Geniisys Exception#E#No data found in giis_line.');
                        --Msg_Alert('No data found in giis_line.','E',true);      
                END;	--d2
             
                giac_acct_entries_pkg.AEG_Check_Level(v_LINE_DEPENDENCY_LEVEL , ws_line_cd,
                                                      v_gl_sub_acct_1         , v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3         , v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5         , v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7);
            END IF; 
            
            GIAC_DISB_VOUCHERS_PKG.Check_Chart_Of_Accts_002(v_gl_acct_id,       v_gl_acct_category, v_gl_control_acct,
                                                            v_gl_sub_acct_1,    v_gl_sub_acct_2,    v_gl_sub_acct_3, 
                                                            v_gl_sub_acct_4,    v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                                            v_gl_sub_acct_7); 
                                                            
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
            
            giac_acct_entries_pkg.AEG_Insert_Update_Entries_rev(v_gl_acct_category, v_gl_control_acct,
                                                                v_gl_sub_acct_1,    v_gl_sub_acct_2,    v_gl_sub_acct_3,
                                                                v_gl_sub_acct_4,    v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                                                v_gl_sub_acct_7,    v_sl_type_cd,       '1',
                                                                p_assd_no,          v_gen_type,         v_gl_acct_id, 
                                                                v_debit_amt,        v_credit_amt,
                                                                p_fund_cd,          p_branch_cd,        p_tran_id);
        END;
                                
  
  END create_rev_entries_002;
  
  
  PROCEDURE val_acc_entr_bef_printing(
        p_gacc_tran_id          giac_disb_vouchers.gacc_tran_id%TYPE
  ) IS
        v_exists      giac_acct_entries.gacc_tran_id%TYPE;
        v_sum_debit   NUMBER(24,2);
        v_sum_credit  NUMBER(24,2);
        v_tot_amt     giac_disb_vouchers.dv_amt%TYPE;
  BEGIN
        FOR a1 IN (SELECT gacc_tran_id
                     FROM giac_acct_entries
                    WHERE gacc_tran_id = p_gacc_tran_id) 
        LOOP
            v_exists := a1.gacc_tran_id;
            EXIT;
        END LOOP;
        
        IF v_exists IS NULL THEN
            --msg_alert('Accounting entries not found.', 'E', TRUE);
            raise_application_error(-20001,'Geniisys Exception#imgMessage.ERROR#Accounting entries not found.');
        ELSE
            BEGIN  
              SELECT NVL(SUM(debit_amt),0), 
                     NVL(SUM(credit_amt),0)
                INTO v_sum_debit, v_sum_credit
                FROM giac_acct_entries
               WHERE gacc_tran_id = p_gacc_tran_id;
                    
              v_tot_amt := v_sum_debit - v_sum_credit;
                      
              IF NVL(v_tot_amt,0) <>  0 THEN
                --msg_alert('Accounting entries are ' ||'not balanced.', 'I', TRUE);
                raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#Accounting entries are not balanced.');
              END IF;
              
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                --msg_alert('Print check: Credit/debit amounts not found.','I', TRUE);
                raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#Print check: Credit/debit amounts not found.');
            END;
        END IF;
  END val_acc_entr_bef_printing; 
  
  
  PROCEDURE delete_wf_records(
        p_gacc_tran_id          giac_disb_vouchers.gacc_tran_id%TYPE
  ) IS
        v_print_tag  giac_disb_vouchers.print_tag%TYPE; 
  BEGIN
        FOR c1 IN (SELECT print_tag
                     FROM giac_disb_vouchers
                    WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
    	    v_print_tag := c1.print_tag;
        END LOOP;	
        
        IF v_print_tag=6 THEN
            FOR c1 IN (SELECT claim_id
                         FROM giac_direct_claim_payts a
	                    WHERE 1=1
	                      AND a.gacc_tran_id = p_gacc_tran_id)
            LOOP    
                delete_workflow_rec('CSR TO ACCOUNTING','GICLS032',nvl(giis_users_pkg.app_user, USER), c1.claim_id);  
            END LOOP;		
            
            FOR c1 IN (SELECT claim_id
	                     FROM giac_inw_claim_payts a
	                    WHERE 1=1
	                      AND a.gacc_tran_id = p_gacc_tran_id)
            LOOP    
                delete_workflow_rec('CSR TO ACCOUNTING','GICLS032',nvl(giis_users_pkg.app_user, USER),c1.claim_id);  
            END LOOP;   
            --FORMS_DDL('COMMIT');
	    END IF;
        
  END delete_wf_records;
  
  FUNCTION get_default_branch(
        p_user_id         giis_users.user_id%TYPE
  ) RETURN VARCHAR2
  IS
    v_default_branch        GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE;
  BEGIN
    FOR i IN(SELECT b.grp_iss_cd
               FROM giis_users A, giis_user_grp_hdr b
              WHERE A.user_grp = b.user_grp 
                AND A.user_id = p_user_id)
    LOOP
        v_default_branch := i.grp_iss_cd;
    END LOOP;
    
    RETURN (v_default_branch);
    
  EXCEPTION
    WHEN no_data_found THEN null;
  END get_default_branch;
  
  FUNCTION get_def_fund_lov RETURN fund_Cd_tab PIPELINED
  IS
    v_fund      fund_cd_type;
  BEGIN
  
    FOR rec IN (SELECT UPPER(param_value_v) fund_cd
                  FROM giac_parameters 
                 WHERE param_name = 'FUND_CD')
    LOOP
        FOR i IN(SELECT fund_desc
                   FROM giis_funds
                  WHERE fund_cd = rec.fund_cd)
        LOOP
            v_fund.fund_desc := i.fund_desc;
            EXIT;
        END LOOP;
        v_fund.fund_cd := rec.fund_Cd;
        
        PIPE ROW(v_fund);
    END LOOP;
    
  END get_def_fund_lov;
 
   -- end 04.11.2013 for GIACS002
END;
/

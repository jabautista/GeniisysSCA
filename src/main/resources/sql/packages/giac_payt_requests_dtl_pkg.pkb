CREATE OR REPLACE PACKAGE BODY CPI.giac_payt_requests_dtl_pkg
AS
   FUNCTION get_payt_req_dtl_list (
      p_claim_id    giac_inw_claim_payts.claim_id%TYPE,
      p_advice_id   giac_inw_claim_payts.advice_id%TYPE
   )
      RETURN giac_payt_req_dtl_tab PIPELINED
   AS
      v_req   giac_payt_req_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT    a.document_cd
                                        || '-'
                                        || a.branch_cd
                                        || '-'
                                        || a.line_cd
                                        || '-'
                                        || TO_CHAR (a.doc_year)
                                        || '-'
                                        || TO_CHAR (a.doc_mm)
                                        || '-'
                                        || LPAD (TO_CHAR (a.doc_seq_no),
                                                 6,
                                                 '0'
                                                ) csr_no,
                                        b.payee_class_cd, b.payee_cd, b.payee,
                                        b.payt_amt, a.ref_id, c.claim_id,
                                        c.advice_id, b.particulars,
                                        b.payt_req_flag
                                   FROM giac_payt_requests a,
                                        giac_payt_requests_dtl b,
                                        giac_direct_claim_payts c
                                  WHERE a.ref_id = b.gprq_ref_id
                                    AND b.tran_id = c.gacc_tran_id
                                    AND b.payt_req_flag <> 'X'
                        UNION
                        SELECT DISTINCT    a.document_cd
                                        || '-'
                                        || a.branch_cd
                                        || '-'
                                        || a.line_cd
                                        || '-'
                                        || TO_CHAR (a.doc_year)
                                        || '-'
                                        || TO_CHAR (a.doc_mm)
                                        || '-'
                                        || LPAD (TO_CHAR (a.doc_seq_no),
                                                 6,
                                                 '0'
                                                ) csr_no,
                                        b.payee_class_cd, b.payee_cd, b.payee,
                                        b.payt_amt, a.ref_id, c.claim_id,
                                        c.advice_id, b.particulars,
                                        b.payt_req_flag
                                   FROM giac_payt_requests a,
                                        giac_payt_requests_dtl b,
                                        giac_inw_claim_payts c
                                  WHERE a.ref_id = b.gprq_ref_id
                                    AND b.tran_id = c.gacc_tran_id
                                    AND payt_req_flag <> 'X')
                 WHERE claim_id = p_claim_id AND advice_id = p_advice_id)
      LOOP
         v_req.ref_id := i.ref_id;
         v_req.payee_class_cd := i.payee_class_cd;
         v_req.payee_cd := i.payee_cd;
         v_req.payee := i.payee;
         v_req.payt_amt := i.payt_amt;
         v_req.payt_req_flag := i.payt_req_flag;
         v_req.claim_id := i.claim_id;
         v_req.advice_id := i.advice_id;
         v_req.particulars := i.particulars;
         v_req.csr_no := i.csr_no;
         PIPE ROW (v_req);
      END LOOP;

      RETURN;
   END get_payt_req_dtl_list;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  05.30.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  :
   */
   FUNCTION get_giac_payt_requests_dtl (
      p_ref_id   giac_payt_requests_dtl.gprq_ref_id%TYPE
   )
      RETURN giac_payt_requests_dtl_tab2 PIPELINED
   IS
      v_list   giac_payt_requests_dtl_type2;
   BEGIN
      FOR i IN (SELECT a.req_dtl_no, a.gprq_ref_id, a.payee_class_cd,
                       a.payt_req_flag, a.payee_cd, a.payee, a.currency_cd,
                       a.payt_amt, a.tran_id, a.cpi_rec_no, a.cpi_branch_cd,
                       a.particulars, a.user_id, a.last_update, a.cancel_by,
                       a.cancel_date, a.dv_fcurrency_amt, a.currency_rt,
                       a.comm_tag, a.replenish_id
                  FROM giac_payt_requests_dtl a
                 WHERE a.gprq_ref_id = p_ref_id)
      LOOP
         v_list.req_dtl_no := i.req_dtl_no;
         v_list.gprq_ref_id := i.gprq_ref_id;
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.payt_req_flag := i.payt_req_flag;
         v_list.payee_cd := i.payee_cd;
         v_list.payee := i.payee;
         v_list.currency_cd := i.currency_cd;
         v_list.payt_amt := i.payt_amt;
         v_list.tran_id := i.tran_id;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.particulars := i.particulars;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.cancel_by := i.cancel_by;
         v_list.cancel_date := i.cancel_date;
         v_list.dv_fcurrency_amt := i.dv_fcurrency_amt;
         v_list.currency_rt := i.currency_rt;
         v_list.comm_tag := i.comm_tag;
         v_list.replenish_id := i.replenish_id;
		 v_LIST.str_last_update := to_char(i.last_update , 'mm-dd-yyyy hh:mi:ss AM');
         FOR a1 IN (SELECT a430.short_name
                      FROM giis_currency a430
                     WHERE a430.main_currency_cd = i.currency_cd)
         LOOP
            v_list.dsp_fshort_name := a1.short_name;
         END LOOP;

         FOR a2 IN (SELECT param_value_v
                      FROM giac_parameters
                     WHERE param_name LIKE 'DEFAULT_CURRENCY')
         LOOP
            v_list.dsp_short_name := a2.param_value_v;
         END LOOP;

         FOR a3 IN (SELECT SUBSTR (rv_meaning, 1, 9) rv_meaning
                      FROM cg_ref_codes
                     WHERE SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                       AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG')
         LOOP
            v_list.mean_payt_req_flag := a3.rv_meaning;
         END LOOP;

         FOR a4 IN (SELECT branch_cd||'-'||replenish_year||'-'||replenish_seq_no replenish_no,
                   replenishment_amt, replenish_id
              FROM giac_replenish_dv
             WHERE replenish_id = i.replenish_id)
         LOOP
            v_list.nbt_replenish_no := a4.replenish_no;
            --v_list.nbt_replenish_amt := a4.replenishment_amt; -- replaced with codes below : shan 10.09.2014
            
            SELECT SUM(amount)
              INTO v_list.nbt_replenish_amt
              FROM giac_replenish_dv_dtl
             WHERE replenish_id = a4.replenish_id
               AND include_tag = 'Y';
         END LOOP;
         
          
         FOR a1 IN (SELECT gacc_tran_id
                       FROM giac_acct_entries
                      WHERE gacc_tran_id = i.tran_id) LOOP
                       v_list.acct_ent_exist:= 'Y';
                      EXIT;
          END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_payt_request_dtl (
      p_payt_request_dtl   giac_payt_requests_dtl%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giac_payt_requests_dtl
         USING DUAL
         ON (    req_dtl_no = p_payt_request_dtl.req_dtl_no
             AND gprq_ref_id = p_payt_request_dtl.gprq_ref_id)
         WHEN NOT MATCHED THEN
            INSERT (req_dtl_no, gprq_ref_id, payee_class_cd, payee_cd, payee,
                    currency_cd, payt_amt, tran_id, particulars, user_id,
                    last_update, dv_fcurrency_amt, currency_rt,comm_tag, replenish_id)
            VALUES (p_payt_request_dtl.req_dtl_no,
                    p_payt_request_dtl.gprq_ref_id,
                    p_payt_request_dtl.payee_class_cd,
                    p_payt_request_dtl.payee_cd, p_payt_request_dtl.payee,
                    p_payt_request_dtl.currency_cd,
                    p_payt_request_dtl.payt_amt, p_payt_request_dtl.tran_id,
                    p_payt_request_dtl.particulars,
                    p_payt_request_dtl.user_id, SYSDATE,
                    p_payt_request_dtl.dv_fcurrency_amt,
                    p_payt_request_dtl.currency_rt,p_payt_request_dtl.comm_tag,p_payt_request_dtl.replenish_id)
         WHEN MATCHED THEN
            UPDATE
               SET payee_class_cd = p_payt_request_dtl.payee_class_cd,
                   payee_cd = p_payt_request_dtl.payee_cd,
                   payee = p_payt_request_dtl.payee,
                   currency_cd = p_payt_request_dtl.currency_cd,
                   payt_amt = p_payt_request_dtl.payt_amt,
                   tran_id = p_payt_request_dtl.tran_id,
                   particulars = p_payt_request_dtl.particulars,
                   user_id = p_payt_request_dtl.user_id,
                   last_update = SYSDATE,
                   dv_fcurrency_amt = p_payt_request_dtl.dv_fcurrency_amt,
                   currency_rt = p_payt_request_dtl.currency_rt, comm_tag = p_payt_request_dtl.comm_tag , replenish_id = p_payt_request_dtl.replenish_id
            ;
   END;
   
   PROCEDURE giacs016_grqd_pre_insert (
        p_ref_id giac_payt_requests.ref_id%TYPE,
      p_fund_cd     giac_payt_requests.fund_cd%TYPE,
      p_branch_cd   giac_payt_requests.branch_cd%TYPE,
       p_user_id           giac_payt_requests.user_id%TYPE,
       p_label varchar2,
      p_workflow_msg out varchar2,
      p_msg_alert out varchar2,
	   v_tran_id       OUT   giac_payt_requests_dtl.tran_id%TYPE
   )
   IS
   
   BEGIN
      giac_payt_requests_dtl_pkg.insert_into_acctrans (p_fund_cd,
                                               p_branch_cd,
                                               p_user_id,
                                               v_tran_id
                                              );

      -- to create workflow records of Close Request
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
                       --AND b.userid <> USER  --A.R.C.  02.08.2006
                       AND b.passing_userid = P_USER_ID
                       AND a.module_id = 'GIACS016'
                       AND a.event_cd = d.event_cd
                       AND UPPER (d.event_desc) = 'CLOSE REQUEST')
         LOOP
           CREATE_TRANSFER_WORKFLOW_REC('CLOSE REQUEST','GIACS016', c1.userid, p_ref_id, c1.event_desc||' '||p_label,p_msg_alert,p_workflow_msg, p_user_id);
           
         END LOOP;
      END;
   END;

   PROCEDURE insert_into_acctrans (
      p_fund_cd           giac_payt_requests.fund_cd%TYPE,
      p_branch_cd         giac_payt_requests.branch_cd%TYPE,
      p_user_id           giac_payt_requests.user_id%TYPE,
      v_tran_id       OUT   giac_payt_requests_dtl.tran_id%TYPE
   )
   IS
      CURSOR fund
      IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_fund_cd;

      CURSOR branch
      IS
         SELECT '1'
           FROM giac_branches
          WHERE branch_cd = p_branch_cd;

      v_fund        VARCHAR2 (1);
      v_branch      VARCHAR2 (1);
      v_tran_date   giac_acctrans.tran_date%TYPE;
   BEGIN
      OPEN fund;

      FETCH fund
       INTO v_fund;

      IF fund%NOTFOUND
      THEN
         raise_application_error
                   ('-20001',
                    'Invalid fund code. Contact your Database administrator.'
                   );
      ELSE
         OPEN branch;

         FETCH branch
          INTO v_branch;

         IF branch%NOTFOUND
         THEN
            raise_application_error
                 ('-20001',
                  'Invalid branch code. Contact your Database administrator.'
                 );
         END IF;

         CLOSE branch;
      END IF;

      CLOSE fund;

      BEGIN
         SELECT acctran_tran_id_s.NEXTVAL
           INTO v_tran_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               ('-20001',
                'ACCTRAN_TRAN_ID sequence not found. Contact your Database administrator.'
               );
      END;

      BEGIN
         INSERT INTO giac_acctrans
                     (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                      tran_flag, tran_class, user_id, last_update
                     )
              VALUES (v_tran_id, p_fund_cd, p_branch_cd, SYSDATE,
                      'O', 'DV', p_user_id, SYSDATE
                     );
      EXCEPTION
         WHEN OTHERS
         THEN
            -- CGTE$OTHER_EXCEPTIONS;
            NULL;
      END;
   END;
END giac_payt_requests_dtl_pkg;
/



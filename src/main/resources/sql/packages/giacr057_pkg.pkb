CREATE OR REPLACE PACKAGE BODY CPI.giacr057_pkg
AS
   FUNCTION get_giacr057_tab (
      p_branch_cd       VARCHAR2,
      p_document_cd     VARCHAR2,
      p_document_name   VARCHAR2,
      p_from_date       DATE,
      p_status          VARCHAR2,
      p_to_date         DATE,
      p_user_id         VARCHAR2
   )
      RETURN giacr057_tab PIPELINED
   IS
      v_list   giacr057_type;
   BEGIN
      SELECT param_value_v
        INTO v_list.company_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      FOR i IN
         (SELECT DISTINCT gprdoc.document_name,
                             gprdoc.document_cd
                          || '-'
                          || gpr.branch_cd
                          || '-'
                          || DECODE (gpr.line_cd,
                                     NULL, NULL,
                                     gpr.line_cd || '-'
                                    )
                          || gpr.doc_year
                          || '-'
                          || LPAD (gpr.doc_mm, 2, '0')         --Dean 08122011
                          || '-'
                          || LPAD (gpr.doc_seq_no, 6, '0') request_no,
                                                               --Dean 08122011
                          gpr.request_date request_date, gprdtl.payee,
                          gprdtl.particulars, gprdtl.payt_amt amount,
                             gprdtl.payt_req_flag
                          || ' - '
                          || crc.rv_meaning status,
                          gpr.branch_cd,
                          DECODE (gdv.dv_pref,
                                  NULL, NULL,
                                     gdv.dv_pref
                                  || '-'
                                  || LPAD (gdv.dv_no, 10, '0')
                                 ) dv_no,                      --Dean 08122011
                          DECODE (gcd.check_pref_suf,
                                  NULL, NULL,
                                  gcd.check_pref_suf || '-' || gcd.check_no
                                 ) check_no,                   --Dean 08122011
                          gb.branch_name
                     FROM giac_payt_req_docs gprdoc,
                          giac_payt_requests gpr,
                          giac_payt_requests_dtl gprdtl,
                          cg_ref_codes crc,
                          giac_disb_vouchers gdv,
                          giac_chk_disbursement gcd,
                          giac_branches gb
                    WHERE SUBSTR (rv_low_value, 1, 1) = gprdtl.payt_req_flag
                      AND gb.branch_cd = gpr.branch_cd
                      AND crc.rv_domain =
                                        'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
                      AND gpr.ref_id = gprdtl.gprq_ref_id
                      AND gpr.fund_cd = gprdoc.gibr_gfun_fund_cd
                      AND gpr.branch_cd = gprdoc.gibr_branch_cd
                      AND gpr.document_cd = gprdoc.document_cd
                      AND TRUNC (gpr.request_date) BETWEEN (p_from_date)
                                                       AND (p_to_date)
                      AND gprdoc.document_name =
                                   NVL (p_document_name, gprdoc.document_name)
                      AND gprdtl.payt_req_flag =
                                          NVL (p_status, gprdtl.payt_req_flag)
                      AND gprdoc.document_cd =
                                       NVL (p_document_cd, gprdoc.document_cd)
                      AND gpr.branch_cd = NVL (p_branch_cd, gpr.branch_cd)
                      --AND gprdtl.PAYT_REQ_FLAG != 'X'
                      --AND gpr.with_dv = 'N'
                      AND gprdtl.tran_id = gdv.gacc_tran_id(+)
                      AND gprdtl.tran_id = gcd.gacc_tran_id(+)
                      --add by nieko 5/25/2013 to filter per branch properly
                      --AND CHECK_USER_PER_ISS_CD_ACCTG(NULL,  GPR.BRANCH_CD, 'GIACS057' ) = 1
                      AND check_user_per_iss_cd_acctg2 (NULL,
                                                        gpr.branch_cd,
                                                        'GIACS057',
                                                        p_user_id
                                                       ) = 1
                 --add by nieko 5/25/2013 end
                 --ORDER BY   gprdoc.document_name Comment out by Jomar Diago 07092012
          ORDER BY        gpr.branch_cd,
                          gprdoc.document_name,
                             gprdoc.document_cd
                          || '-'
                          || gpr.branch_cd
                          || '-'
                          || DECODE (gpr.line_cd,
                                     NULL, NULL,
                                     gpr.line_cd || '-'
                                    )
                          || gpr.doc_year
                          || '-'
                          || LPAD (gpr.doc_mm, 2, '0')         --Dean 08122011
                          || '-'
                          || LPAD (gpr.doc_seq_no, 6, '0')
                                                          /*  gprdoc.document_cd
                                                           || '-'
                                                           || gpr.branch_cd
                                                           || '-'
                                                           || DECODE (gpr.line_cd, NULL, NULL, gpr.line_cd || '-')
                                                           || gpr.doc_year
                                                           || '-'
                                                           || LPAD (gpr.doc_mm, 2, '0')
                                                           || '-'
                                                           || LPAD (gpr.doc_seq_no, 6, '0'),
                                                           gprdoc.document_name               -- Added by Jomar Diago 07092012*/
         )
      LOOP
         v_list.document_name := i.document_name;
         v_list.request_no := i.request_no;
         v_list.request_date := i.request_date;
         v_list.payee := i.payee;
         v_list.particulars := i.particulars;
         v_list.amount := i.amount;
         v_list.status := i.status;
         v_list.branch_cd := i.branch_cd;
         v_list.dv_no := i.dv_no;
         v_list.check_no := i.check_no;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;
      
      PIPE ROW (v_list);

      RETURN;
   END get_giacr057_tab;

   FUNCTION get_giacr057_header
      RETURN giacr057_header_tab PIPELINED
   IS
      v_list   giacr057_header_type;
   BEGIN
      SELECT param_value_v
        INTO v_list.company_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      SELECT param_value_v
        INTO v_list.company_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      PIPE ROW (v_list);
      RETURN;
   END get_giacr057_header;
   
    -- marco - 12.15.2015 - RSIC SR 5220
    FUNCTION get_giacr057_csv(
        p_branch_cd         VARCHAR2,
        p_document_cd       VARCHAR2,
        p_document_name     VARCHAR2,
        p_from_date         DATE,
        p_status            VARCHAR2,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    )
      RETURN csv_tab PIPELINED
    IS
        rec                 VARCHAR2(32000);
        v_row               csv_type;
        v_company_name      giis_parameters.param_value_v%TYPE;
        v_check_no          VARCHAR2(1000);
    BEGIN
        v_row.rec := 'COMPANY FUND CODE, COMPANY NAME, BRANCH CODE, BRANCH NAME, DOCUMENT NAME, PAYMENT REQUEST NUMBER, REQUEST DATE, PARTICULARS, AMOUNT, STATUS, DV NUMBER, CHECK NUMBER';
        PIPE ROW(v_row);
                        
        BEGIN
            SELECT param_value_v
              INTO v_company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN OTHERS THEN
                v_company_name := NULL;
        END;
        
        FOR i IN(SELECT DISTINCT gprdoc.gibr_gfun_fund_cd, gprdoc.document_name,
                                 gprdoc.document_cd || '-' || gpr.branch_cd || '-' || DECODE(gpr.line_cd, NULL, NULL, gpr.line_cd || '-')
                                  || gpr.doc_year
                                  || '-'
                                  || LPAD(gpr.doc_mm, 2, '0')
                                  || '-'
                                  || LPAD(gpr.doc_seq_no, 6, '0') request_no,
                                 gpr.request_date request_date, gprdtl.payee,
                                 gprdtl.particulars, gprdtl.payt_amt amount,
                                 gprdtl.payt_req_flag || ' - ' || crc.rv_meaning status,
                                 gpr.branch_cd,
                                 DECODE(gdv.dv_pref, NULL, NULL, gdv.dv_pref || '-' || LPAD (gdv.dv_no, 10, '0')) dv_no,
                                 gb.branch_name, gdv.gacc_tran_id
                            FROM giac_payt_req_docs gprdoc,
                                 giac_payt_requests gpr,
                                 giac_payt_requests_dtl gprdtl,
                                 cg_ref_codes crc,
                                 giac_disb_vouchers gdv,
                                 giac_chk_disbursement gcd,
                                 giac_branches gb
                           WHERE SUBSTR (rv_low_value, 1, 1) = gprdtl.payt_req_flag
                             AND gb.branch_cd = gpr.branch_cd
                             AND crc.rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
                             AND gpr.ref_id = gprdtl.gprq_ref_id
                             AND gpr.fund_cd = gprdoc.gibr_gfun_fund_cd
                             AND gpr.branch_cd = gprdoc.gibr_branch_cd
                             AND gpr.document_cd = gprdoc.document_cd
                             AND TRUNC(gpr.request_date) BETWEEN(p_from_date) AND (p_to_date)
                             AND gprdoc.document_name = NVL(p_document_name, gprdoc.document_name)
                             AND gprdtl.payt_req_flag = NVL(p_status, gprdtl.payt_req_flag)
                             AND gprdoc.document_cd = NVL(p_document_cd, gprdoc.document_cd)
                             AND gpr.branch_cd = NVL(p_branch_cd, gpr.branch_cd)
                             AND gprdtl.tran_id = gdv.gacc_tran_id(+)
                             AND gprdtl.tran_id = gcd.gacc_tran_id(+)
                             AND check_user_per_iss_cd_acctg2 (NULL, gpr.branch_cd, 'GIACS057', p_user_id) = 1
                    ORDER BY gpr.branch_cd,
                             gprdoc.document_name,
                             gprdoc.document_cd || '-' || gpr.branch_cd || '-'
                             || DECODE (gpr.line_cd, NULL, NULL, gpr.line_cd || '-')
                             || gpr.doc_year
                             || '-'
                             || LPAD (gpr.doc_mm, 2, '0')
                             || '-'
                             || LPAD (gpr.doc_seq_no, 6, '0'))
        LOOP
            v_check_no := NULL;
            FOR a IN(SELECT DECODE (b.check_pref_suf, NULL, NULL, b.check_pref_suf || '-' || b.check_no) check_no
                       FROM giac_chk_disbursement b
                      WHERE b.gacc_tran_id = i.gacc_tran_id)
            LOOP
                IF v_check_no IS NULL THEN
                    v_check_no := a.check_no;
                ELSE
                    v_check_no := v_check_no || CHR(10) || CHR(10) || a.check_no;
                END IF;
            END LOOP;
        
            v_row.rec := i.gibr_gfun_fund_cd || ',"' || v_company_name || '",' || i.branch_cd || ',"' || i.branch_name || '","' || 
                         i.document_name || '","' || i.request_no || '",' || i.request_date || ',"' || REPLACE(i.particulars, '"', '""') || '",' || 
                         i.amount || ',"' || i.status || '","' || i.dv_no || '","' || v_check_no || '"';
            PIPE ROW(v_row);
        END LOOP;
    END;
   
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIAC_PAYT_REQUESTS_PKG
AS
   /*
   ** Modified By:       Udel Dela Cruz Jr.
   ** Date Modified:     04/25/2012
   ** Description:       Added parameter P_BRANCH_CD to functions
   **                      GET_CLM_PAYT_REQ_LISTING, GET_FACUL_PREM_PAYT_LISTING,
   **                      GET_COMM_PAYT_LISTING, GET_OTHER_PAYT_LISTING,
   **                      GET_CANCEL_REQ_LISTING.
   **                    To reuse code when querying records for other branches.
   */
   FUNCTION get_clm_payt_req_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED
   AS
      v_req          clm_payt_req_type;
      v_ouc_name     GIAC_OUCS.ouc_name%TYPE;
      v_status       CG_REF_CODES.rv_meaning%TYPE;
      v_request_no   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (  SELECT a.*,
                      b.gprq_ref_id,
                      b.payee,
                      b.particulars,
                      b.payt_req_flag
                 FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                WHERE --check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                      -- replacement for function above : shan 11.04.2014
                      ( (  SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS016'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = a.branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS016')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS016'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = a.branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS016')) = 1)
                      -- end of replacement codes : shan 11.04.2014
                  --AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id)) -- replaced with codes below : shan 02.25.2015                  
                      AND a.branch_cd = NVL(p_branch_cd,  (SELECT grp_iss_cd
                                                              FROM giis_users a,
                                                                   giis_user_grp_hdr b 
                                                             WHERE a.user_grp=b.user_grp
                                                               AND a.user_id= NVL(p_user_id, USER)
                                                               AND rownum = 1))
                      /*AND a.document_cd IN
                             (giacp.v ('CLM_PAYT_REQ_DOC'),
                              giacp.v ('BATCH_CSR_DOC'),
                              giacp.v ('SPECIAL_CSR_DOC'))*/  -- replaced with codes below : shan 02.25.2015                     
                      AND a.document_cd IN (SELECT param_value_v
                                              FROM GIAC_PARAMETERS
                                             WHERE param_name IN ('CLM_PAYT_REQ_DOC', 'BATCH_CSR_DOC', 'SPECIAL_CSR_DOC'))
                      AND a.ref_id = b.gprq_ref_id
                      AND UPPER (b.payee) LIKE UPPER (NVL (p_payee, b.payee))
                      AND TO_DATE (a.request_date) =
                             NVL (TO_DATE (p_request_date, 'mm-dd-yyyy'),
                                  TO_DATE (a.request_date))
                      AND UPPER (b.particulars) LIKE
                             UPPER (NVL (p_particulars, b.particulars))
                      AND UPPER (NVL (a.create_by, '*')) LIKE
                             UPPER (NVL (p_create_by, NVL (a.create_by, '*')))
                      AND b.payt_req_flag = p_payt_req_flag -- shan 11.04.2014
             ORDER BY a.request_date DESC, a.doc_seq_no DESC)
      LOOP
         v_request_no := get_request_no (i.ref_id);

         BEGIN
            SELECT ouc_name
              INTO v_ouc_name
              FROM GIAC_OUCS
             WHERE ouc_id = i.gouc_ouc_id;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 9)
              INTO v_status
              FROM cg_ref_codes
             WHERE     SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                   AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG';
         END;

         v_req.ref_id := i.ref_id;
         v_req.request_no := v_request_no;
         v_req.ouc_name := v_ouc_name;
         v_req.request_date := i.request_date;
         v_req.payee := i.payee;
         v_req.particulars := i.particulars;
         v_req.create_by := i.create_by;
         v_req.status := v_status;

         IF (    UPPER (v_status) LIKE UPPER (NVL (p_status, v_status))
             AND UPPER (v_request_no) LIKE
                    UPPER (NVL (p_request_no, v_request_no)))
         THEN
            PIPE ROW (v_req);
         END IF;
      END LOOP;
   END;

   FUNCTION get_facul_prem_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED
   AS
      v_req          clm_payt_req_type;
      v_ouc_name     GIAC_OUCS.ouc_name%TYPE;
      v_status       CG_REF_CODES.rv_meaning%TYPE;
      v_request_no   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (  SELECT a.*,
                      b.gprq_ref_id,
                      b.payee,
                      b.particulars,
                      b.payt_req_flag
                 FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                WHERE --check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                      -- replacement for function above : shan 11.04.2014
                      ( (  SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS016'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = a.branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS016')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS016'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = a.branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS016')) = 1)
                      -- end of replacement codes : shan 11.04.2014
                  AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id))
                      AND a.document_cd IN (giacp.v ('FACUL_RI_PREM_PAYT_DOC'))
                      AND a.ref_id = b.gprq_ref_id
                      AND UPPER (b.payee) LIKE UPPER (NVL (p_payee, b.payee))
                      AND TO_DATE (a.request_date) =
                             NVL (TO_DATE (p_request_date, 'mm-dd-yyyy'),
                                  TO_DATE (a.request_date))
                      AND UPPER (b.particulars) LIKE
                             UPPER (NVL (p_particulars, b.particulars))
                      AND UPPER (NVL (a.create_by, '*')) LIKE
                             UPPER (NVL (p_create_by, NVL (a.create_by, '*')))
                      AND b.payt_req_flag = p_payt_req_flag -- shan 11.04.2014
             ORDER BY a.request_date DESC, a.doc_seq_no DESC)
      LOOP
         v_request_no := get_request_no (i.ref_id);

         BEGIN
            SELECT ouc_name
              INTO v_ouc_name
              FROM GIAC_OUCS
             WHERE ouc_id = i.gouc_ouc_id;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 9)
              INTO v_status
              FROM cg_ref_codes
             WHERE     SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                   AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG';
         END;

         v_req.ref_id := i.ref_id;
         v_req.request_no := v_request_no;
         v_req.ouc_name := v_ouc_name;
         v_req.request_date := i.request_date;
         v_req.payee := i.payee;
         v_req.particulars := i.particulars;
         v_req.create_by := i.create_by;
         v_req.status := v_status;

         IF (    UPPER (v_status) LIKE UPPER (NVL (p_status, v_status))
             AND UPPER (v_request_no) LIKE
                    UPPER (NVL (p_request_no, v_request_no)))
         THEN
            PIPE ROW (v_req);
         END IF;
      END LOOP;
   END;

   FUNCTION get_comm_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED
   AS
      v_req          clm_payt_req_type;
      v_ouc_name     GIAC_OUCS.ouc_name%TYPE;
      v_status       CG_REF_CODES.rv_meaning%TYPE;
      v_request_no   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (  SELECT a.*,
                      b.gprq_ref_id,
                      b.payee,
                      b.particulars,
                      b.payt_req_flag
                 FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                WHERE --check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                      -- replacement for function above : shan 11.04.2014
                      ( (  SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS016'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = a.branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS016')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS016'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = a.branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS016')) = 1)
                      -- end of replacement codes : shan 11.04.2014
                  AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id))
                      AND a.document_cd IN (giacp.v ('COMM_PAYT_DOC'))
                      AND a.ref_id = b.gprq_ref_id
                      AND UPPER (b.payee) LIKE UPPER (NVL (p_payee, b.payee))
                      AND TO_DATE (a.request_date) =
                             NVL (TO_DATE (p_request_date, 'mm-dd-yyyy'),
                                  TO_DATE (a.request_date))
                      AND UPPER (b.particulars) LIKE
                             UPPER (NVL (p_particulars, b.particulars))
                      AND UPPER (NVL (a.create_by, '*')) LIKE
                             UPPER (NVL (p_create_by, NVL (a.create_by, '*')))
                      AND b.payt_req_flag = p_payt_req_flag -- shan 11.04.2014
             ORDER BY a.request_date DESC, a.doc_seq_no DESC)
      LOOP
         v_request_no := get_request_no (i.ref_id);

         BEGIN
            SELECT ouc_name
              INTO v_ouc_name
              FROM GIAC_OUCS
             WHERE ouc_id = i.gouc_ouc_id;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 9)
              INTO v_status
              FROM cg_ref_codes
             WHERE     SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                   AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG';
         END;

         v_req.ref_id := i.ref_id;
         v_req.request_no := v_request_no;
         v_req.ouc_name := v_ouc_name;
         v_req.request_date := i.request_date;
         v_req.payee := i.payee;
         v_req.particulars := i.particulars;
         v_req.create_by := i.create_by;
         v_req.status := v_status;

         IF (    UPPER (v_status) LIKE UPPER (NVL (p_status, v_status))
             AND UPPER (v_request_no) LIKE
                    UPPER (NVL (p_request_no, v_request_no)))
         THEN
            PIPE ROW (v_req);
         END IF;
      END LOOP;
   END;

   FUNCTION get_other_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED
   AS
      v_req          clm_payt_req_type;
      v_ouc_name     GIAC_OUCS.ouc_name%TYPE;
      v_status       CG_REF_CODES.rv_meaning%TYPE;
      v_request_no   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (  SELECT a.*,
                      b.gprq_ref_id,
                      b.payee,
                      b.particulars,
                      b.payt_req_flag
                 FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                WHERE --check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                      -- replacement for function above : shan 11.04.2014
                      ( (  SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS016'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = a.branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS016')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS016'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = a.branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS016')) = 1)
                      -- end of replacement codes : shan 11.04.2014
                  AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id))
                      AND NOT EXISTS
                                 (SELECT 1
                                    FROM GIAC_PARAMETERS
                                   WHERE     param_name IN
                                                ('CLM_PAYT_REQ_DOC',
                                                 'BATCH_CSR_DOC',
                                                 'SPECIAL_CSR_DOC',
                                                 'FACUL_RI_PREM_PAYT_DOC',
                                                 'COMM_PAYT_DOC')
                                         AND param_value_v = a.document_cd)
                      AND a.ref_id = b.gprq_ref_id
                      AND UPPER (b.payee) LIKE UPPER (NVL (p_payee, b.payee))
                      AND TO_DATE (a.request_date) =
                             NVL (TO_DATE (p_request_date, 'mm-dd-yyyy'),
                                  TO_DATE (a.request_date))
                      AND UPPER (b.particulars) LIKE
                             UPPER (NVL (p_particulars, b.particulars))
                      AND UPPER (NVL (a.create_by, '*')) LIKE
                             UPPER (NVL (p_create_by, NVL (a.create_by, '*')))
                      AND b.payt_req_flag = p_payt_req_flag -- shan 11.04.2014
             ORDER BY a.request_date DESC, a.doc_seq_no DESC)
      LOOP
         v_request_no := get_request_no (i.ref_id);

         BEGIN
            SELECT ouc_name
              INTO v_ouc_name
              FROM GIAC_OUCS
             WHERE ouc_id = i.gouc_ouc_id;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 9)
              INTO v_status
              FROM cg_ref_codes
             WHERE     SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                   AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG';
         END;

         v_req.ref_id := i.ref_id;
         v_req.request_no := v_request_no;
         v_req.ouc_name := v_ouc_name;
         v_req.request_date := i.request_date;
         v_req.payee := i.payee;
         v_req.particulars := i.particulars;
         v_req.create_by := i.create_by;
         v_req.status := v_status;

         IF (    UPPER (v_status) LIKE UPPER (NVL (p_status, v_status))
             AND UPPER (v_request_no) LIKE
                    UPPER (NVL (p_request_no, v_request_no)))
         THEN
            PIPE ROW (v_req);
         END IF;
      END LOOP;
   END;

   FUNCTION get_cancel_req_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED
   AS
      v_req          clm_payt_req_type;
      v_ouc_name     GIAC_OUCS.ouc_name%TYPE;
      v_status       CG_REF_CODES.rv_meaning%TYPE;
      v_request_no   VARCHAR2 (100);
   BEGIN
      FOR i
         IN (  SELECT a.*,
                      b.gprq_ref_id,
                      b.payee,
                      b.particulars,
                      b.payt_req_flag
                 FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                WHERE --check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                      -- replacement for function above : shan 11.04.2014
                      ( (  SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = p_user_id
                              AND module_id = 'GIACS016'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = p_user_id
                                                 AND b.iss_cd = a.branch_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS016')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS016'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = p_user_id
                                                                AND b.iss_cd = a.branch_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS016')) = 1)
                      -- end of replacement codes : shan 11.04.2014   
                  AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id))
                      AND a.ref_id IN (SELECT gprq_ref_id
                                         FROM GIAC_PAYT_REQUESTS_DTL
                                        WHERE payt_req_flag <> 'X')
                      AND a.ref_id = b.gprq_ref_id
                      AND UPPER (b.payee) LIKE UPPER (NVL (p_payee, b.payee))
                      AND TO_DATE (a.request_date) =
                             NVL (TO_DATE (p_request_date, 'mm-dd-yyyy'),
                                  TO_DATE (a.request_date))
                      AND UPPER (b.particulars) LIKE
                             UPPER (NVL (p_particulars, b.particulars))
                      AND UPPER (NVL (a.create_by, '*')) LIKE
                             UPPER (NVL (p_create_by, NVL (a.create_by, '*')))
                      AND b.payt_req_flag = p_payt_req_flag -- shan 11.04.2014
             ORDER BY a.request_date DESC, a.doc_seq_no DESC)
      LOOP
         v_request_no := get_request_no (i.ref_id);

         BEGIN
            SELECT ouc_name
              INTO v_ouc_name
              FROM GIAC_OUCS
             WHERE ouc_id = i.gouc_ouc_id;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 9)
              INTO v_status
              FROM cg_ref_codes
             WHERE     SUBSTR (rv_low_value, 1, 1) = i.payt_req_flag
                   AND rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG';
         END;

         v_req.ref_id := i.ref_id;
         v_req.request_no := v_request_no;
         v_req.ouc_name := v_ouc_name;
         v_req.request_date := i.request_date;
         v_req.payee := i.payee;
         v_req.particulars := i.particulars;
         v_req.create_by := i.create_by;
         v_req.status := v_status;

         IF (    UPPER (v_status) LIKE UPPER (NVL (p_status, v_status))
             AND UPPER (v_request_no) LIKE
                    UPPER (NVL (p_request_no, v_request_no)))
         THEN
            PIPE ROW (v_req);
         END IF;
      END LOOP;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  05.30.2012
   **  Reference By : (GIACS016 - Disbursement)
   **  Description  :
   */
   FUNCTION get_giac_payt_requests (p_ref_id GIAC_PAYT_REQUESTS.ref_id%TYPE)
      RETURN giac_payt_requests_tab
      PIPELINED
   IS
      v_list   giac_payt_requests_type;
   BEGIN
      FOR i IN (SELECT a.gouc_ouc_id,
                       a.ref_id,
                       a.fund_cd,
                       a.branch_cd,
                       a.document_cd,
                       a.doc_seq_no,
                       a.request_date,
                       a.line_cd,
                       a.doc_year,
                       a.doc_mm,
                       a.user_id,
                       a.last_update,
                       a.cpi_rec_no,
                       a.cpi_branch_cd,
                       a.with_dv,
                       a.create_by,
                       a.upload_tag,
                       a.rf_replenish_tag
                  FROM giac_payt_requests a
                 WHERE a.ref_id = p_ref_id)
      LOOP
         v_list.gouc_ouc_id := i.gouc_ouc_id;
         v_list.ref_id := i.ref_id;
         v_list.fund_cd := i.fund_cd;
         v_list.branch_cd := i.branch_cd;
         v_list.document_cd := i.document_cd;
         v_list.doc_seq_no := i.doc_seq_no;
         v_list.request_date := i.request_date;
         v_list.line_cd := i.line_cd;
         v_list.doc_year := i.doc_year;
         v_list.doc_mm := i.doc_mm;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.with_dv := i.with_dv;
         v_list.create_by := i.create_by;
         v_list.upload_tag := i.upload_tag;
         v_list.rf_replenish_tag := i.rf_replenish_tag;

         --POST-QUERY details
         FOR a1 IN (SELECT ouc_cd
                      FROM GIAC_OUCS
                     WHERE ouc_id = i.gouc_ouc_id)
         LOOP
            v_list.dsp_dept_cd := a1.ouc_cd;
         END LOOP;

         FOR a2 IN (SELECT A995.fund_desc
                      FROM giis_funds A995
                     WHERE A995.fund_cd = i.fund_cd)
         LOOP
            v_list.dsp_fund_desc := a2.fund_desc;
         END LOOP;

         FOR a3
            IN (SELECT branch_name
                  FROM giac_branches
                 WHERE     branch_cd = i.branch_cd
                       AND gfun_fund_cd = NVL (i.fund_cd, gfun_fund_cd))
         LOOP
            v_list.dsp_branch_name := a3.branch_name;
         END LOOP;

         FOR a4 IN (SELECT gouc.ouc_name
                      FROM giac_oucs gouc
                     WHERE gouc.ouc_id = i.gouc_ouc_id)
         LOOP
            v_list.dsp_ouc_name := a4.ouc_name;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_giac_payt_requests (
      p_giac_payt_requests giac_payt_requests%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_payt_requests
           USING DUAL
              ON (ref_id = p_giac_payt_requests.ref_id)
      WHEN NOT MATCHED
      THEN
         INSERT     (ref_id,
                     gouc_ouc_id,
                     fund_cd,
                     branch_cd,
                     document_cd,
                     request_date,
                     line_cd,
                     doc_year,
                     doc_mm,
                     user_id,
                     last_update,
                     with_dv,
                     create_by,
                     upload_tag,
                     rf_replenish_tag)
             VALUES (p_giac_payt_requests.ref_id,
                     p_giac_payt_requests.gouc_ouc_id,
                     p_giac_payt_requests.fund_cd,
                     p_giac_payt_requests.branch_cd,
                     p_giac_payt_requests.document_cd,
                     --SYSDATE,
					 p_giac_payt_requests.request_date,	-- RSIC SR-11259, copied from SR-16985 : shan 08.28.2015
                     p_giac_payt_requests.line_cd,
                     p_giac_payt_requests.doc_year,
                     p_giac_payt_requests.doc_mm,
                     p_giac_payt_requests.user_id,
                     SYSDATE,
                     p_giac_payt_requests.with_dv,
                     p_giac_payt_requests.create_by,
                     p_giac_payt_requests.upload_tag,
                     p_giac_payt_requests.rf_replenish_tag)
      WHEN MATCHED
      THEN
         UPDATE SET
            last_update = SYSDATE,
            rf_replenish_tag = p_giac_payt_requests.rf_replenish_tag;
   END;

   FUNCTION get_closed_tag (
      p_fund_cd        giac_tran_mm.fund_cd%TYPE,
      p_date        IN giac_acctrans.tran_date%TYPE,
      p_branch_cd      GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_closed_tag   VARCHAR2 (1);
   BEGIN
      FOR a1
         IN (SELECT closed_tag
               FROM giac_tran_mm
              WHERE     fund_cd = p_fund_cd
                    AND branch_cd = p_branch_cd --replacement for the commented where clause.
                    --to consider the branch of the transaction in the validation of the date being entered.
                    AND tran_yr = TO_NUMBER (TO_CHAR (p_date, 'YYYY'))
                    AND tran_mm = TO_NUMBER (TO_CHAR (p_date, 'MM')))
      LOOP
         v_closed_tag := a1.closed_tag;
         EXIT;
      END LOOP;

      RETURN v_closed_tag;
   END;

   PROCEDURE get_fund_branch_desc (
      p_fund_cd         giac_tran_mm.fund_cd%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE,
      fund_desc     OUT VARCHAR2,
      branch_name   OUT VARCHAR2)
   IS
      CURSOR C
      IS
         SELECT BRANCH_NAME
           FROM GIAC_BRANCHES
          WHERE     BRANCH_CD = p_branch_cd
                AND GFUN_FUND_CD = NVL (p_fund_cd, GFUN_FUND_CD);

      CURSOR f
      IS
         SELECT A995.FUND_DESC
           FROM GIIS_FUNDS A995
          WHERE A995.FUND_CD = p_fund_cd;
   BEGIN
      BEGIN
         SELECT BRANCH_NAME
           INTO branch_name
           FROM GIAC_BRANCHES
          WHERE     BRANCH_CD = p_branch_cd
                AND GFUN_FUND_CD = NVL (p_fund_cd, GFUN_FUND_CD);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT A995.FUND_DESC
           INTO fund_desc
           FROM GIIS_FUNDS A995
          WHERE A995.FUND_CD = p_fund_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END;

   FUNCTION POPULATE_CHK_TAGS (
      p_fund_cd        GIAC_PAYT_REQ_DOCS.GIBR_GFUN_FUND_CD%TYPE,
      p_branch_cd      GIAC_PAYT_REQ_DOCS.GIBR_BRANCH_CD%TYPE,
      p_document_cd    GIAC_PAYT_REQ_DOCS.document_cd%TYPE)
      RETURN POPULATE_CHK_TAGS_tab
      PIPELINED
   IS
      v_pop   POPULATE_CHK_TAGS_type;
   BEGIN
      FOR i
         IN (SELECT GPRD.DOCUMENT_NAME,
                    GPRD.LINE_CD_TAG,
                    GPRD.YY_TAG,
                    GPRD.MM_TAG
               FROM GIAC_PAYT_REQ_DOCS GPRD
              WHERE     GPRD.GIBR_GFUN_FUND_CD = p_FUND_CD
                    AND GPRD.GIBR_BRANCH_CD = p_BRANCH_CD
                    AND GPRD.DOCUMENT_CD = p_DOCUMENT_CD)
      LOOP
         v_pop.var_document_name := i.document_name;
         v_pop.var_LINE_CD_TAG := i.line_cd_tag;
         v_pop.var_yy_tag := i.YY_TAG;
         v_pop.var_mm_TAG := i.MM_TAG;
         PIPE ROW (v_pop);
      END LOOP;
   END;

   PROCEDURE close_disbursement_request (
      p_ref_id             GIAC_PAYT_REQUESTS.ref_id%TYPE,
      p_req_dtl_no         GIAC_PAYT_REQUESTS_dtl.req_dtl_no%TYPE,
	  p_tran_id         GIAC_PAYT_REQUESTS_dtl.tran_id%TYPE,
      p_user_id            giac_payt_requests.user_id%TYPE,
	  p_document_cd		 giac_payt_requests.document_cd%TYPE,
	  p_branch_cd           giac_payt_requests.branch_cd%TYPE,
	  p_line_cd         giac_payt_requests.line_cd%TYPE,
	  p_doc_year        giac_payt_requests.doc_year%TYPE,
	  p_doc_mm          giac_payt_requests.doc_mm%TYPE,
	  p_doc_seq_no          giac_payt_requests.doc_seq_no%TYPE,
      p_workflow_msg   OUT VARCHAR2,
      p_msg_alert      OUT VARCHAR2)
   IS
   BEGIN
      -- close request first
      BEGIN
         UPDATE GIAC_PAYT_REQUESTS
            SET last_update = SYSDATE, user_id = p_user_id
          WHERE ref_id = p_ref_id;
      END;

      BEGIN
         UPDATE giac_payt_requests_dtl
            SET payt_req_flag = 'C',
                last_update = SYSDATE,
                user_id = p_user_id
          WHERE gprq_ref_id = p_ref_id AND req_dtl_no = p_req_dtl_no;
      END;
	  
	  delete_workflow_rec('CLOSE REQUEST','GIACS016',p_user_id,p_ref_id);
	  
	  	BEGIN 
			  FOR c1 IN (SELECT b.userid, d.event_desc  
				             FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
				            WHERE 1=1
			                AND c.event_cd = a.event_cd
			                AND c.event_mod_cd = a.event_mod_cd
			                AND b.event_mod_cd = a.event_mod_cd
			                --AND b.userid <> USER  --A.R.C. 02.08.2006
			                AND b.passing_userid = USER  --A.R.C. 02.08.2006
			                AND a.module_id = 'GIACS016'
			                AND a.event_cd = d.event_cd
			                AND UPPER(d.event_desc) = 'CREATE DV')
			  LOOP
			    CREATE_TRANSFER_WORKFLOW_REC('CREATE DV','GIACS016', c1.userid, p_ref_id, c1.event_desc||' '||
			                                 p_document_cd||'-'||p_branch_cd||'-'||p_line_cd||'-'||p_doc_year||'-'||p_doc_mm||'-'||p_doc_seq_no,p_msg_alert,p_workflow_msg, p_user_id);
			  END LOOP;
			END; 
			
				IF nvl(giacp.v('UPLOAD_IMPLEMENTATION_SW'),'N') = 'Y' THEN
						exec_immediate('BEGIN upload_dpc.upd_guf_dv('||p_tran_id||'); END;');
				end if;
   END;
   
   
    PROCEDURE cancel_payment_request (
      p_ref_id     GIAC_PAYT_REQUESTS.ref_id%TYPE,
      p_tran_id    GIAC_PAYT_REQUESTS_dtl.tran_id%TYPE,
	  p_user_id            giac_payt_requests.user_id%TYPE)
	  
	  is
	  	
	begin
		UPDATE giac_payt_requests_dtl
    SET payt_req_flag = 'X',
        cancel_by     = p_user_id,
        cancel_date   = SYSDATE
    WHERE tran_id = p_tran_id;
	
	 delete_workflow_rec('CANCEL REQUEST','GIACS016',p_user_id,p_ref_id);
	 
	 IF SQL%FOUND THEN
		UPDATE giac_acctrans
		  SET tran_flag = 'D'
		  WHERE tran_id = p_tran_id;
	  
  else 
  	raise_application_error('-20001', 'Geniisys Exception#E#Unable to update payt_requests_dtl.');
  end if;
	end;
    
    
  /*
  **  Created by   : Marie Kris Felipe
  **  Date Created : 04.17.2013
  **  Reference By : GIACS002 - Generate Disbursement Voucher
  **  Description  :  Retrieves the list of line_cd specified in line_cd record_group
  */
  FUNCTION get_payt_line_cd_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE
   ) RETURN payt_line_cd_tab PIPELINED
   IS
        v_payt_line         payt_line_cd_type;
   BEGIN
        FOR rec IN (SELECT DISTINCT gprq.line_cd, 
                           a.line_name
                      FROM giac_payt_requests gprq,
                           giis_line a,
                           giac_payt_requests_dtl grqd
                     WHERE gprq.ref_id = grqd.gprq_ref_id
                       AND gprq.line_cd = a.line_cd
                       AND grqd.payt_req_flag = 'C'
                       AND gprq.branch_cd = p_branch_cd
                       AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                                NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                                               gidv.gacc_tran_id
                                          FROM giac_disb_vouchers gidv
                                         WHERE gidv.dv_flag NOT IN ('D', 'C')
                                           AND gidv.gprq_ref_id = gprq.ref_id
                                           AND gidv.req_dtl_no = grqd.req_dtl_no
                                           AND gidv.gacc_tran_id = grqd.tran_id)
                       AND gprq.fund_cd = p_fund_cd 
                       AND gprq.branch_cd =
                                DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                      gprq.branch_cd,
                                                                      p_module_id,
                                                                      p_user_id),
                                        1, gprq.branch_cd,
                                        NULL)
                       AND gprq.document_cd = p_document_cd)
        LOOP
            v_payt_line.line_cd := rec.line_cd;
            v_payt_line.line_name := rec.line_name;
            
            PIPE ROW(v_payt_line);
        END LOOP;
        
   END get_payt_line_cd_list;
   
   
   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.20.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  : Executes WHEN-VALIDATE-ITEM Trigger of DSP_LINE_CD 
   */
   PROCEDURE validate_payt_line_cd(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_line_cd_tag       giac_payt_req_docs.line_cd_tag%TYPE
   ) IS
        CURSOR line_cd IS
          SELECT gprq.line_cd
            FROM giac_payt_requests gprq,
                 giis_line a,
                 giac_payt_requests_dtl grqd
            WHERE gprq.ref_id = grqd.gprq_ref_id
            AND gprq.line_cd = a.line_cd
            AND grqd.payt_req_flag = 'C'
            AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                    NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no, gidv.gacc_tran_id
                              FROM giac_disb_vouchers gidv
                             WHERE gidv.dv_flag NOT IN ('D', 'C')
                             AND gidv.gprq_ref_id = gprq.ref_id
                             AND gidv.req_dtl_no = grqd.req_dtl_no
                             AND gidv.gacc_tran_id = grqd.tran_id)
            AND gprq.fund_cd = p_fund_cd
            AND gprq.branch_cd = p_branch_cd
            AND gprq.document_cd = p_document_cd
            AND gprq.line_cd = p_line_cd;
     
        dummy    giis_line.line_cd%TYPE;
   BEGIN
        OPEN line_cd;
        
        FETCH line_cd INTO dummy;
  
        IF line_cd%NOTFOUND THEN
            DECLARE
                v_exists   VARCHAR2(1) := 'N';
            BEGIN
                FOR a IN (SELECT line_cd
                            FROM giis_line
                           WHERE line_cd = p_line_cd) 
                LOOP
                    v_exists := 'Y';
                    EXIT;
                END LOOP;

                IF v_exists = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.INFO#There is no Payment Request that has these ' ||
                                                   'Document Code, Branch Code, and Line Code.');
                                                   
                ELSE
                    IF p_line_cd_tag = 'Y' THEN
                        RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.INFO#This is an invalid Line Code.');
--                        msg_alert('This is an invalid Line Code.', 'I', TRUE);
                    END IF;
                END IF;
            END;
        END IF;
        
        CLOSE line_cd;
   
   EXCEPTION 
        WHEN OTHERS THEN NULL;
   
   END validate_payt_line_cd;
   
   
  /*
  **  Created by   : Marie Kris Felipe
  **  Date Created : 04.17.2013
  **  Reference By : GIACS002 - Generate Disbursement Voucher
  **  Description  :  Retrieves the list of doc_year specified in doc_year record_group
  */
   FUNCTION get_doc_yy_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE
   ) RETURN giac_payt_requests_tab PIPELINED
   IS
        v_doc_yy        giac_payt_requests_type;
   BEGIN
        FOR rec IN (SELECT DISTINCT gprq.doc_year
                      FROM giac_payt_requests gprq, 
                           giac_payt_requests_dtl grqd
                     WHERE gprq.ref_id = grqd.gprq_ref_id
                       AND grqd.payt_req_flag = 'C'
                       AND gprq.branch_cd = p_branch_cd
                       AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                            NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                                           gidv.gacc_tran_id
                                      FROM giac_disb_vouchers gidv
                                     WHERE gidv.dv_flag NOT IN ('D', 'C')
                                       AND gidv.gprq_ref_id = gprq.ref_id
                                       AND gidv.req_dtl_no = grqd.req_dtl_no
                                       AND gidv.gacc_tran_id = grqd.tran_id)
                       AND gprq.fund_cd = p_fund_cd
                       AND gprq.branch_cd =
                                DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                      gprq.branch_cd,
                                                                      p_module_id,
                                                                      p_user_id),
                                        1, gprq.branch_cd,
                                        NULL)
                       AND gprq.document_cd = p_document_cd
                       AND NVL (gprq.line_cd, '-') = NVL (p_line_cd, '-'))
        LOOP
            v_doc_yy.doc_year := rec.doc_year;
        
            PIPE ROW(v_doc_yy);
        END LOOP;
        
   END get_doc_yy_list;
   
   
   /*
  **  Created by   : Marie Kris Felipe
  **  Date Created : 04.17.2013
  **  Reference By : GIACS002 - Generate Disbursement Voucher
  **  Description  : Retrieves the list of doc_mm specified in doc_mm record_group
  */
  FUNCTION get_doc_mm_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE
   ) RETURN giac_payt_requests_tab PIPELINED
   IS
        v_doc_mm        giac_payt_requests_type;
   BEGIN
        FOR rec IN (SELECT DISTINCT gprq.doc_mm
                      FROM giac_payt_requests gprq, giac_payt_requests_dtl grqd
                     WHERE gprq.ref_id = grqd.gprq_ref_id
                       AND grqd.payt_req_flag = 'C'
                       AND gprq.branch_cd = p_branch_cd
                       AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                                NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                                               gidv.gacc_tran_id
                                          FROM giac_disb_vouchers gidv
                                         WHERE gidv.dv_flag NOT IN ('D', 'C')
                                           AND gidv.gprq_ref_id = gprq.ref_id
                                           AND gidv.req_dtl_no = grqd.req_dtl_no
                                           AND gidv.gacc_tran_id = grqd.tran_id)
                       AND gprq.fund_cd = p_fund_cd
                       AND gprq.branch_cd =
                                DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                      gprq.branch_cd,
                                                                      p_module_id,
                                                                      p_user_id),
                                        1, gprq.branch_cd,
                                        NULL)
                       AND gprq.document_cd = p_document_cd
                       AND NVL (gprq.line_cd, '-') = NVL (p_line_cd, '-')
                       AND NVL (gprq.doc_year, 0) = NVL (p_doc_year, 0))
        LOOP
            v_doc_mm.doc_mm := rec.doc_mm;
        
            PIPE ROW(v_doc_mm);
        END LOOP;
        
   END get_doc_mm_list;
   
   /*
  **  Created by   : Marie Kris Felipe
  **  Date Created : 04.17.2013
  **  Reference By : GIACS002 - Generate Disbursement Voucher
  **  Description  : Retrieves the list of doc_seq_no specified in doc_seq_no record_group
  */
  FUNCTION get_doc_seq_no_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE
   ) RETURN payt_disb_tab PIPELINED
   IS
        v_doc_list          payt_disb_type;
   BEGIN
        FOR rec IN (SELECT DISTINCT gprq.doc_seq_no doc_seq_no, 
                           gprq.fund_cd fund_cd,
                           (   gprq.document_cd
                             || '-'
                             || gprq.branch_cd
                             || '-'
                             || DECODE (gprq.line_cd, NULL, NULL, gprq.line_cd || '-')
                             || DECODE (gprq.doc_year, NULL, NULL, gprq.doc_year || '-')
                             || DECODE (gprq.doc_mm, NULL, NULL, gprq.doc_mm || '-')
                             || gprq.doc_seq_no
                           ) payt_req_no,
                           gprd.document_name document_name, 
                           grqd.tran_id tran_id,
                           gprq.ref_id ref_id, 
                           grqd.req_dtl_no req_dtl_no,
                           gprq.request_date request_date, 
                           gprq.gouc_ouc_id gouc_ouc_id,
                           gouc.ouc_cd ouc_cd, 
                           gouc.ouc_name ouc_name,
                           grqd.payee_class_cd, 
                           gpc.class_desc, 
                           grqd.payee_cd,
                           grqd.payee payee, 
                           grqd.payt_amt payt_amt,
                           grqd.particulars particulars, 
                           grqd.currency_cd currency_cd,
                           gc.short_name currency_desc, 
                           grqd.dv_fcurrency_amt, 
                           grqd.currency_rt
                      FROM giac_payt_requests gprq,
                           giac_payt_requests_dtl grqd,
                           giac_payt_req_docs gprd,
                           giac_oucs gouc,
                           giis_payee_class gpc,
                           giis_currency gc
                     WHERE gprq.document_cd = gprd.document_cd
                       AND gprq.branch_cd = gprd.gibr_branch_cd
                       AND gprq.branch_cd =
                                DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                      gprq.branch_cd,
                                                                      p_module_id,
                                                                      p_user_id),
                                        1, gprq.branch_cd,
                                        NULL)
                       AND gc.main_currency_cd = grqd.currency_cd
                       AND gprq.gouc_ouc_id = gouc.ouc_id
                       AND gprq.ref_id = grqd.gprq_ref_id
                       AND grqd.payt_req_flag = 'C'
                       AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                                NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no,
                                               gidv.gacc_tran_id
                                          FROM giac_disb_vouchers gidv
                                         WHERE gidv.dv_flag NOT IN ('D', 'C')
                                           AND gidv.gprq_ref_id = gprq.ref_id
                                           AND gidv.req_dtl_no = grqd.req_dtl_no
                                           AND gidv.gacc_tran_id = grqd.tran_id)
                       AND gprq.fund_cd = p_fund_cd
                       AND gprq.branch_cd = p_branch_cd
                       AND gprq.document_cd = p_document_cd
                       AND NVL (gprq.line_cd, '-') = NVL (p_line_cd, '-')
                       AND NVL (gprq.doc_year, 0) = NVL (p_doc_year, 0)
                       AND NVL (gprq.doc_mm, 0) = NVL (p_doc_mm, 0)
                       AND grqd.payee_class_cd = gpc.payee_class_cd)
        LOOP
            v_doc_list.doc_seq_no := rec.doc_seq_no;
            v_doc_list.fund_cd := rec.fund_cd;
            v_doc_list.payt_req_no := rec.payt_req_no;
            v_doc_list.document_name := rec.document_name;
            v_doc_list.tran_id := rec.tran_id;
            v_doc_list.ref_id := rec.ref_id;
            v_doc_list.req_dtl_no := rec.req_dtl_no;
            v_doc_list.request_date := rec.request_date;
            v_doc_list.gouc_ouc_id := rec.gouc_ouc_id;
            v_doc_list.ouc_cd := rec.ouc_cd;
            v_doc_list.ouc_name := rec.ouc_name;
            v_doc_list.payee_class_cd := rec.payee_class_cd;
            v_doc_list.class_desc := rec.class_desc;
            v_doc_list.payee_cd := rec.payee_cd;
            v_doc_list.payee := rec.payee;
            v_doc_list.payt_amt := rec.payt_amt;
            v_doc_list.particulars := rec.particulars;
            v_doc_list.currency_cd := rec.currency_cd;
            v_doc_list.currency_desc := rec.currency_desc;
            v_doc_list.dv_fcurrency_amt := rec.dv_fcurrency_amt;
            v_doc_list.currency_rt := rec.currency_rt;
        
            PIPE ROW(v_doc_list);
        END LOOP;
   END get_doc_seq_no_list;
   
   
   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.20.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  : Executes when-validate-item trigger of dsp_doc_seq_no GIDV block
   */
   FUNCTION validate_doc_seq_no(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE,
        p_doc_seq_no        giac_payt_requests.doc_seq_no%TYPE
   ) RETURN payt_disb_tab PIPELINED
   IS
         CURSOR doc_seq_no IS
          SELECT gprq.doc_seq_no, 
                 grqd.tran_id,
                 gprq.ref_id,
                 grqd.req_dtl_no,
                 gprq.request_date,
                 gprq.gouc_ouc_id,
                 gouc.ouc_cd,
                 gouc.ouc_name,
                 grqd.payee,
                 grqd.payt_amt,
                 grqd.particulars,
                 grqd.currency_cd,
                 grqd.payee_class_cd,
                 grqd.payee_cd,
                 gpc.class_desc,
                 grqd.currency_rt,
                 grqd.dv_fcurrency_amt
            FROM giac_payt_requests gprq,
                 giac_payt_requests_dtl grqd,
                 giac_oucs gouc,
                 giis_payee_class gpc
           WHERE gpc.payee_class_cd = grqd.payee_class_cd 
	         AND gprq.gouc_ouc_id = gouc.ouc_id
             AND gprq.ref_id = grqd.gprq_ref_id
             AND grqd.payt_req_flag = 'C'
             AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                        NOT IN (SELECT gidv.gprq_ref_id, 
                                       gidv.req_dtl_no, 
                                       gidv.gacc_tran_id
                                  FROM giac_disb_vouchers gidv
                                 WHERE gidv.dv_flag NOT IN ('D', 'C')
                                   AND gidv.gprq_ref_id = gprq.ref_id
                                   AND gidv.req_dtl_no = grqd.req_dtl_no
                                   AND gidv.gacc_tran_id = grqd.tran_id)
             AND gprq.fund_cd = p_fund_cd
             AND gprq.branch_cd = p_branch_cd
             AND gprq.document_cd = p_document_cd
             AND NVL(gprq.line_cd, '-') = NVL(p_line_cd, '-')
             AND NVL(gprq.doc_year, 0) = NVL(p_doc_year, 0)
             AND NVL(gprq.doc_mm, 0) = NVL(p_doc_mm, 0)
             AND gprq.doc_seq_no = p_doc_seq_no;
        
        dummy    giac_payt_requests.doc_seq_no%TYPE;
        v_dv     payt_disb_type;   
   BEGIN
         OPEN doc_seq_no;
        
        FETCH doc_seq_no 
         INTO v_dv.doc_seq_no, --dummy,
              v_dv.tran_id,
              v_dv.ref_id,
              v_dv.req_dtl_no,
              v_dv.request_date,
              v_dv.gouc_ouc_id,
              v_dv.ouc_cd,
              v_dv.ouc_name,
              v_dv.payee,
              v_dv.payt_amt,
              v_dv.particulars,
              v_dv.currency_cd,	
			  v_dv.payee_class_cd,
			  v_dv.payee_cd,
			  v_dv.class_desc,
              v_dv.currency_rt,
              v_dv.dv_fcurrency_amt;
              
        IF doc_seq_no%NOTFOUND THEN
            DECLARE
                v_exists  VARCHAR2(1) := 'N';
            BEGIN
                FOR a IN (SELECT gidv.gprq_ref_id
                            FROM giac_disb_vouchers gidv,
                                 giac_payt_requests_dtl grqd,
                                 giac_payt_requests gprq
                           WHERE grqd.payt_req_flag = 'C'
                             AND gprq.ref_id = grqd.gprq_ref_id
                             AND gidv.dv_flag IN ('A', 'N', 'P')
                             AND gidv.gacc_tran_id = grqd.tran_id
                             AND gidv.req_dtl_no = grqd.req_dtl_no
                             AND gidv.gprq_ref_id = gprq.ref_id
                             AND gprq.branch_cd = p_branch_cd  --reymon 11112010, to include branch_cd in the filtering
                             AND gprq.document_cd = p_document_cd
                             AND NVL(gprq.line_cd, '-') = NVL(p_line_cd, '-')
                             AND NVL(gprq.doc_year, 0) = NVL(p_doc_year, 0)
                             AND NVL(gprq.doc_mm, 0) = NVL(p_doc_mm, 0)
                             AND gprq.doc_seq_no = p_doc_seq_no) 
                LOOP
                  v_exists := 'Y';
                  EXIT;
                END LOOP;
        
                IF v_exists = 'Y' THEN
--                  msg_alert('This Payment Request No. has an existing DV.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#This Payment Request No. has an existing DV.');
                ELSE
--                    msg_alert('This is an invalid Document Sequence No.', 'I', TRUE);
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#This is an invalid Document Sequence No.');
                END IF;
            END;
        
        ELSE    
            BEGIN
                SELECT short_name
                  INTO v_dv.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = v_dv.currency_cd;
            EXCEPTION 
                WHEN no_data_found THEN NULL;
            END;
            
        END IF;
        
        PIPE ROW(v_dv);
        CLOSE doc_seq_no;     
   
   EXCEPTION
        WHEN OTHERS THEN NULL;  
   END validate_doc_seq_no;
   
   
   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : 04.22.2013
   **  Reference By : GIACS002 - Generate Disbursement Voucher
   **  Description  : Executes when-validate-item trigger of dsp_doc_year GIDV block
   */
   PROCEDURE validate_doc_yy(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_nbt_yy_tag        giac_payt_req_docs.yy_tag%TYPE
   ) IS
        CURSOR doc_year IS
          SELECT gprq.doc_year
            FROM giac_payt_requests gprq,
                 giac_payt_requests_dtl grqd
           WHERE gprq.ref_id = grqd.gprq_ref_id
             AND grqd.payt_req_flag = 'C'
             AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                        NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no, gidv.gacc_tran_id
                                  FROM giac_disb_vouchers gidv
                                 WHERE gidv.dv_flag NOT IN ('D', 'C')
                                   AND gidv.gprq_ref_id = gprq.ref_id
                                   AND gidv.req_dtl_no = grqd.req_dtl_no
                                   AND gidv.gacc_tran_id = grqd.tran_id)
             AND gprq.fund_cd = p_fund_cd
             AND gprq.branch_cd = p_branch_cd
             AND gprq.document_cd = p_document_cd
             AND NVL(gprq.line_cd, '-') = NVL(p_line_cd, '-')
             AND gprq.doc_year = p_doc_year;
        
        dummy   giac_payt_requests.doc_year%TYPE;  
   BEGIN
        OPEN doc_year;
        FETCH doc_year 
         INTO dummy;

        IF doc_year%NOTFOUND THEN
          IF p_nbt_yy_tag = 'Y' THEN
            --msg_alert('Invalid Year for this Payment Request.', 'I', TRUE);
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.INFO#Invalid Year for this Payment Request.');
          END IF;
        END IF;
        
        CLOSE doc_year;
    
   EXCEPTION
        WHEN OTHERS THEN NULL;
   END validate_doc_yy;
   
   PROCEDURE validate_doc_mm(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE,
        p_nbt_mm_tag        giac_payt_req_docs.yy_tag%TYPE
   ) IS
        CURSOR doc_mm IS
          SELECT gprq.doc_mm
            FROM giac_payt_requests gprq,
                 giac_payt_requests_dtl grqd
           WHERE gprq.ref_id = grqd.gprq_ref_id
             AND grqd.payt_req_flag = 'C'
             AND (gprq.ref_id, grqd.req_dtl_no, grqd.tran_id) 
                        NOT IN (SELECT gidv.gprq_ref_id, gidv.req_dtl_no, gidv.gacc_tran_id
                                  FROM giac_disb_vouchers gidv
                                 WHERE gidv.dv_flag NOT IN ('D', 'C')
                                   AND gidv.gprq_ref_id = gprq.ref_id
                                   AND gidv.req_dtl_no = grqd.req_dtl_no
                                   AND gidv.gacc_tran_id = grqd.tran_id)
             AND gprq.fund_cd = p_fund_cd
             AND gprq.branch_cd = p_branch_cd
             AND gprq.document_cd = p_document_cd
             AND NVL(gprq.line_cd, '-') = NVL(p_line_cd, '-')
             AND NVL(gprq.doc_year, 0) = NVL(p_doc_year, 0)
             AND NVL(gprq.doc_mm, 0) = NVL(p_doc_mm, 0);

         dummy   giac_payt_requests.doc_mm%TYPE;
   BEGIN
        OPEN doc_mm;
        FETCH doc_mm INTO dummy;
     
        IF doc_mm%NOTFOUND THEN
          IF p_nbt_mm_tag = 'Y' THEN
            --msg_alert('Invalid Month for this Payment Request.', 'I', TRUE);
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#imgMessage.INFO#Invalid Month for this Payment Request.');
          END IF;
        END IF;
        
        CLOSE doc_mm;
   EXCEPTION
        WHEN OTHERS THEN NULL;
   END validate_doc_mm;
   
    
END GIAC_PAYT_REQUESTS_PKG;
/



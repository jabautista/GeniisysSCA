CREATE OR REPLACE PACKAGE BODY CPI.giis_currency_pkg
AS
   FUNCTION get_currency_list
      RETURN currency_list_tab
      PIPELINED
   IS
      v_currency   currency_list_type;
   BEGIN
      FOR i IN (SELECT main_currency_cd,
                       currency_desc,
                       currency_rt,
                       short_name
                  FROM giis_currency
                  ORDER BY currency_desc ASC)
      LOOP
         v_currency.main_currency_cd := i.main_currency_cd;
         v_currency.currency_desc := i.currency_desc;
         v_currency.currency_rt := i.currency_rt;
         v_currency.short_name := i.short_name;
         PIPE ROW (v_currency);
      END LOOP;

      RETURN;
   END get_currency_list;

   FUNCTION get_currency_by_premseqno (
      p_iss_cd         gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE)
      RETURN currency_list_tab
      PIPELINED
   IS
      v_currency   currency_list_type;
   BEGIN
      FOR i
         IN (SELECT b.currency_cd,
                    --modified by janet ang --took out "distinct" and placed "exit" below instead
                    b.currency_rt,
                    c.currency_desc,
                    c.short_name
               FROM gipi_invoice b, giis_currency c
              WHERE     b.currency_cd = c.main_currency_cd
                    AND b.iss_cd = p_iss_cd
                    AND b.prem_seq_no = p_prem_seq_no
                    AND ROWNUM = 1)
      LOOP
         v_currency.main_currency_cd := i.currency_cd;
         v_currency.currency_desc := i.currency_desc;
         v_currency.currency_rt := i.currency_rt;
         v_currency.short_name := i.short_name;
         PIPE ROW (v_currency);
      END LOOP;

      RETURN;
   END get_currency_by_premseqno;

   PROCEDURE get_currency_dtl (
      p_currency_cd            giis_currency.main_currency_cd%TYPE,
      p_main_currency_cd   OUT giis_currency.main_currency_cd%TYPE,
      p_currency_desc      OUT giis_currency.currency_desc%TYPE,
      p_currency_rt        OUT giis_currency.currency_rt%TYPE,
      p_short_name         OUT giis_currency.short_name%TYPE)
   IS
   BEGIN
      p_main_currency_cd := NULL;
      p_currency_desc := NULL;
      p_currency_rt := NULL;
      p_short_name := NULL;

      FOR i IN (SELECT main_currency_cd,
                       currency_desc,
                       currency_rt,
                       short_name
                  FROM giis_currency
                 WHERE main_currency_cd = p_currency_cd)
      LOOP
         p_main_currency_cd := i.main_currency_cd;
         p_currency_desc := i.currency_desc;
         p_currency_rt := i.currency_rt;
         p_short_name := i.short_name;
      END LOOP;
   END get_currency_dtl;

   FUNCTION get_default_currency
      RETURN default_currency_tab
      PIPELINED
   IS
      v_curr   default_currency_type;
   BEGIN
      FOR b1
         IN (SELECT main_currency_cd, currency_desc, currency_rt
               FROM giis_currency
              WHERE short_name = (SELECT param_value_v
                                    FROM giac_parameters
                                   WHERE param_name = 'DEFAULT_CURRENCY'))
      LOOP
         v_curr.currency_cd := b1.main_currency_cd;
         v_curr.currency_desc := b1.currency_desc;
         v_curr.currency_rate := b1.currency_rt;
         PIPE ROW (v_curr);
      END LOOP;

      RETURN;
   END get_default_currency;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 04.29.2010
   **  Reference By  : (POLICY DOCUMENTS)
   **  Description   : This function is used to retrieve the default currency description
   */
   FUNCTION get_default_currency2
      RETURN VARCHAR2
   IS
      v_default_currency   giis_currency.currency_desc%TYPE;
   BEGIN
      FOR a
         IN (SELECT currency_desc
               FROM giis_currency
              WHERE short_name IN (SELECT param_value_v
                                     FROM giac_parameters
                                    WHERE param_name = 'DEFAULT_CURRENCY'))
      LOOP
         v_default_currency := a.currency_desc;
         EXIT;
      END LOOP;

      RETURN v_default_currency;
   END get_default_currency2;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 04.14.2010
   **  Reference By  : (POLICY DOCUMENTS)
   **  Description   : This function is used to retrieve the short_name of a particular using its extract_id
   */
   FUNCTION get_item_short_name (
      p_extract_id IN gixx_invoice.extract_id%TYPE)
      RETURN VARCHAR
   IS
      v_short_name   VARCHAR2 (50);
   BEGIN
      IF gixx_invoice_pkg.get_policy_currency (p_extract_id) = 'Y'
      THEN
         FOR curr_rec
            IN (SELECT a.short_name currency_desc
                  FROM giis_currency a, gixx_invoice b
                 WHERE     a.main_currency_cd = b.currency_cd
                       AND b.extract_id = p_extract_id)
         LOOP
            v_short_name := curr_rec.currency_desc;
            EXIT;
         END LOOP;
      ELSE
         v_short_name := giisp.v ('PESO SHORT NAME');
      END IF;

      RETURN (v_short_name);
   END get_item_short_name;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 04.15.2010
   **  Reference By  : (POLICY DOCUMENTS)
   **  Description   : This function is used to retrieve the short_name of a particular
   **               using its extract_id and item_no
   */
   FUNCTION get_item_short_name2 (
      p_extract_id   IN gixx_invoice.extract_id%TYPE,
      p_item_no      IN gixx_item.item_no%TYPE)
      RETURN VARCHAR
   IS
      v_short_name   VARCHAR2 (50);
   BEGIN
      IF gixx_invoice_pkg.get_policy_currency (p_extract_id) = 'Y'
      THEN
         FOR curr_rec
            IN (SELECT a.short_name currency_desc
                  FROM giis_currency a, gixx_item b
                 WHERE     a.main_currency_cd = b.currency_cd
                       AND b.extract_id = p_extract_id
                       AND b.item_no = p_item_no)
         LOOP
            v_short_name := curr_rec.currency_desc;
            EXIT;
         END LOOP;
      ELSE
         v_short_name := giisp.v ('PESO SHORT NAME');
      END IF;

      RETURN (v_short_name);
   END get_item_short_name2;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 04.26.2010
   **  Reference By  : (POLICY DOCUMENTS)
   **  Description   : Returns short_name with the given currency_cd
   */
   FUNCTION get_pol_doc_short_name (
      p_currency_cd IN gixx_orig_invoice.currency_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_currency   giis_currency.short_name%TYPE;
   BEGIN
      FOR a IN (SELECT short_name
                  FROM giis_currency
                 WHERE main_currency_cd = p_currency_cd)
      LOOP
         v_currency := a.short_name;
      END LOOP;

      RETURN v_currency;
   END get_pol_doc_short_name;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 05.04.2010
   **  Reference By  : (Policy Documents)
   **  Description   : This function returns the currency description based on the extract_id
   */
   FUNCTION get_pol_doc_short_name2 (
      p_extract_id IN gixx_invoice.extract_id%TYPE)
      RETURN VARCHAR2
   IS
      v_currency_desc   giis_currency.currency_desc%TYPE;
   BEGIN
      FOR curr_rec
         IN (SELECT a.currency_desc currency_desc
               FROM giis_currency a, gixx_invoice b
              WHERE     a.main_currency_cd = b.currency_cd
                    AND b.extract_id = p_extract_id
                    AND b.policy_currency = 'Y')
      LOOP
         v_currency_desc := curr_rec.currency_desc;
         EXIT;
      END LOOP;

      IF v_currency_desc IS NULL
      THEN
         v_currency_desc := giis_currency_pkg.get_default_currency2;
      END IF;

      RETURN v_currency_desc;
   END get_pol_doc_short_name2;

   /* CREATED BY ANTHONY SANTOS SEPT 16, 2010
   *  GET CURRENCY DETAILS FOR TRANSBASIC INFO
   */
   FUNCTION get_trans_basic_currency_dtls (
      p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN currency_list_tab2
      PIPELINED
   IS
      v_curr   currency_list_type2;
   BEGIN
      FOR i
         IN (SELECT c.short_name currency_sname,
                    d.param_value_v f_currency_sname,
                    c.currency_rt curr_rt,
                    c.main_currency_cd,
                    c.currency_desc
               FROM giac_order_of_payts a,
                    giac_acctrans b,
                    giis_currency c,
                    giac_parameters d
              WHERE     a.gacc_tran_id = p_gacc_tran_id
                    AND b.tran_id = a.gacc_tran_id
                    AND a.currency_cd = c.main_currency_cd
                    AND d.param_name = 'DEFAULT_CURRENCY')
      LOOP
         v_curr.short_name := i.currency_sname;
         v_curr.currency_desc := i.f_currency_sname;
         v_curr.currency_rt := i.curr_rt;
         v_curr.main_currency_cd := i.main_currency_cd;
         v_curr.currency_desc2 := i.currency_desc;
         PIPE ROW (v_curr);
      END LOOP;

      RETURN;
   END;

   /*
    **  Created by   :  Jerome Orio
    **  Date Created :  10-28-2010
    **  Reference By : (GIACS009 - Ri Trans - Losses Recov from RI)
    **  Description  :  validate the currency code
    */
   PROCEDURE validate_currency_code (
      p_claim_id            IN     gicl_claims.claim_id%TYPE,
      p_collection_amt      IN     giac_loss_recoveries.collection_amt%TYPE,
      p_currency_cd         IN     giac_loss_recoveries.currency_cd%TYPE,
      p_convert_rate           OUT giac_loss_recoveries.convert_rate%TYPE,
      p_dsp_currency_desc      OUT giis_currency.currency_desc%TYPE,
      p_foreign_curr_amt       OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
      p_msg_alert              OUT VARCHAR2)
   IS
   BEGIN
      BEGIN
         SELECT A.CURRENCY_DESC, NVL (C.CURRENCY_RT, 0)
           INTO p_dsp_currency_desc, p_convert_rate
           FROM GIIS_CURRENCY A, GICL_CLAIMS B, GIAC_CURRENCY C
          WHERE     A.MAIN_CURRENCY_CD = C.MAIN_CURRENCY_CD
                AND C.MAIN_CURRENCY_CD = p_currency_cd
                AND B.CLAIM_ID = p_claim_id
                AND B.LOSS_DATE >= C.EFFECTIVITY_DATE
                AND (   C.INACTIVITY_DATE IS NULL
                     OR B.LOSS_DATE < C.INACTIVITY_DATE);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               SELECT A.CURRENCY_DESC, C.CURRENCY_RT
                 INTO p_dsp_currency_desc, p_convert_rate
                 FROM GIIS_CURRENCY A, GIAC_CURRENCY C
                WHERE     A.MAIN_CURRENCY_CD = C.MAIN_CURRENCY_CD
                      AND C.MAIN_CURRENCY_CD = p_currency_cd
                      AND C.INACTIVITY_DATE IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg_alert :=
                     'Error: Currency code not exist. Please contact your system administrator.';
                  RETURN;
               WHEN TOO_MANY_ROWS
               THEN
                  p_msg_alert :=
                     'Error: Too many rows. Please contact your system administrator.';
                  RETURN;
            END;
         WHEN TOO_MANY_ROWS
         THEN
            p_msg_alert :=
               'Error: Too many rows. Please contact your system administrator.';
            RETURN;
      END;

      p_foreign_curr_amt :=
         ROUND (NVL (p_collection_amt, 0) / NVL (p_convert_rate, 1), 2);
   END;

   FUNCTION get_currency_lov (p_keyword VARCHAR2)
      RETURN currency_list_tab
      PIPELINED
   IS
      v_currency   currency_list_type;
   BEGIN
      FOR i
         IN (SELECT main_currency_cd,
                    currency_desc,
                    currency_rt,
                    short_name
               FROM giis_currency
              WHERE (   main_currency_cd LIKE '%' || p_keyword || '%'
                     OR currency_desc LIKE '%' || p_keyword || '%'))
      LOOP
         v_currency.main_currency_cd := i.main_currency_cd;
         v_currency.currency_desc := i.currency_desc;
         v_currency.currency_rt := i.currency_rt;
         v_currency.short_name := i.short_name;
         PIPE ROW (v_currency);
      END LOOP;

      RETURN;
   END get_currency_lov;

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.29.2011
   **  Reference By  : (PACKAGE POLICY DOCUMENTS)
   **  Description   : This function is used to retrieve the short_name of a particular using its extract_id
   */
   FUNCTION get_pack_item_short_name (
      p_extract_id IN GIXX_PACK_INVOICE.extract_id%TYPE)
      RETURN VARCHAR
   IS
      v_short_name   VARCHAR2 (50);
   BEGIN
      IF GIXX_INVOICE_PKG.get_policy_currency (p_extract_id) = 'Y'
      THEN
         FOR curr_rec
            IN (SELECT a.short_name currency_desc
                  FROM GIIS_CURRENCY a, GIXX_PACK_INVOICE b
                 WHERE     a.main_currency_cd = b.currency_cd
                       AND b.extract_id = p_extract_id)
         LOOP
            v_short_name := curr_rec.currency_desc;
            EXIT;
         END LOOP;
      ELSE
         v_short_name := GIISP.v ('PESO SHORT NAME');
      END IF;

      RETURN (v_short_name);
   END get_pack_item_short_name;

   /*
   **  Created by   :  Emman
   **  Date Created :  04.06.2011
   **  Reference By : (GIACS035 - Close DCB)
   **  Description  : Retrieves CURRENCY lov
   */
   FUNCTION get_dcb_currency_lov (
      p_gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no            giac_acctrans.tran_class_no%TYPE,
      p_dcb_date          VARCHAR2,
      p_pay_mode          giac_dcb_bank_dep.pay_mode%TYPE,
      p_keyword           VARCHAR)
      RETURN dcb_currency_lov_tab
      PIPELINED
   IS
      v_curr_lov   dcb_currency_lov_type;
      v_dcb_date   DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      FOR i
         IN (SELECT DISTINCT
                    a430.short_name,
                    a430.currency_desc,
                    a430.main_currency_cd,
                    gicd.currency_rt currency_rt,
                    TO_CHAR (gicd.currency_rt, '900.000000000') curr_rt
               FROM giis_currency a430,
                    giac_order_of_payts giop,
                    giac_collection_dtl gicd
              WHERE     gicd.gacc_tran_id = giop.gacc_tran_id
                    AND (   (    giop.dcb_no = p_dcb_no
                             AND NVL (with_pdc, 'N') <> 'Y')
                         OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y'))
                    AND (   (    TRUNC (giop.or_date) = TRUNC (v_dcb_date)
                             AND NVL (with_pdc, 'N') <> 'Y')
                         OR (    TRUNC (gicd.due_dcb_date) =
                                    TRUNC (v_dcb_date)
                             AND with_pdc = 'Y'))
                    AND giop.gibr_branch_cd = p_gibr_branch_cd
                    AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                    AND gicd.pay_mode = p_pay_mode
                    AND gicd.currency_cd = a430.main_currency_cd
                    AND (   (giop.or_flag = 'P')
                         OR (    giop.or_flag = 'C'
                             AND NVL (
                                    TO_CHAR (giop.cancel_date, 'MM-DD-YYYY'),
                                    '-') <>
                                    TO_CHAR (giop.or_date, 'MM-DD-YYYY')))
                    AND (   UPPER (a430.short_name) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (a430.currency_desc) LIKE
                               '%' || UPPER (p_keyword) || '%'
                         OR UPPER (a430.main_currency_cd) LIKE
                               '%' || UPPER (p_keyword) || '%'))
      LOOP
         v_curr_lov.short_name := i.short_name;
         v_curr_lov.currency_desc := i.currency_desc;
         v_curr_lov.main_currency_cd := i.main_currency_cd;
         v_curr_lov.currency_rt := i.currency_rt;
         v_curr_lov.curr_rt := i.curr_rt;

         PIPE ROW (v_curr_lov);
      END LOOP;
   END get_dcb_currency_lov;

   /*
   **  Created by   :  Emman
   **  Date Created :  04.12.2011
   **  Reference By : (GIACS035 - Close DCB)
   **  Description  : Retrieves CURRENCY_SHORT_NAME lov
   */
   FUNCTION get_currency_lov_by_short_name (
      p_short_name GIIS_CURRENCY.short_name%TYPE)
      RETURN currency_list_tab
      PIPELINED
   IS
      v_curr   currency_list_type;
   BEGIN
      FOR i IN (SELECT main_currency_cd,
                       short_name,
                       currency_desc,
                       currency_rt
                  FROM giis_currency
                 WHERE short_name = p_short_name)
      LOOP
         v_curr.main_currency_cd := i.main_currency_cd;
         v_curr.short_name := i.short_name;
         v_curr.currency_desc := i.currency_desc;
         v_curr.currency_rt := i.currency_rt;

         PIPE ROW (v_curr);
      END LOOP;
   END get_currency_lov_by_short_name;

   FUNCTION get_currency_rt_by_shortname (
      p_short_name GIIS_CURRENCY.short_name%TYPE)
      RETURN GIIS_CURRENCY.currency_rt%TYPE
   IS
      v_rate   GIIS_CURRENCY.currency_rt%TYPE;
   BEGIN
      BEGIN
         SELECT currency_rt
           INTO v_rate
           FROM giis_currency
          WHERE short_name = p_short_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               '-20001',
                  'No default currency in GIIS_CURRENCY. Please check if '
               || p_short_name
               || ' is in GIIS_CURRENCY.');
      END;

      RETURN v_rate;
   END;
   
   FUNCTION get_giacs035currency_lov (
        p_module_id      giis_modules.module_id%TYPE,
        p_user_id        giis_users.user_id%TYPE,
        p_keyword        VARCHAR2,
        p_short_name     giis_currency.short_name%TYPE
    )
      RETURN giacs035_curr_tab PIPELINED
   IS
      v_rec  giacs035_curr_type;
      v_def_short_name giis_currency.short_name%TYPE;
   BEGIN
       FOR x IN(SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name LIKE 'DEFAULT_CURRENCY')
       LOOP
           v_def_short_name := x.param_value_v;
           EXIT;
       END LOOP;
       
       FOR i IN (SELECT main_currency_cd, short_name, currency_rt
             FROM giis_currency
            WHERE 1 = 1
              AND short_name = NVL(p_short_name, v_def_short_name)
              AND UPPER(short_name) LIKE '%' || UPPER(NVL(p_keyword, short_name)) || '%'
          ORDER BY 2)
       LOOP
            v_rec.short_name := i.short_name;
            v_rec.currency_rt := i.currency_rt;
            v_rec.currency_cd := i.main_currency_cd;

            PIPE ROW(v_rec);
       END LOOP;
   END get_giacs035currency_lov;
   FUNCTION GET_GIACS035_CURRENY_LOV( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_CURRENY_LOV - Start
        P_SEARCH                    VARCHAR2,
        P_GIBR_BRANCH_CD            GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE,
        P_GFUN_FUND_CD              GIAC_ORDER_OF_PAYTS.GIBR_GFUN_FUND_CD%TYPE,
        P_DSP_DCB_DATE              VARCHAR2, 
        P_PAY_MODE                  GIAC_COLLECTION_DTL.PAY_MODE%TYPE,
        P_DCB_NO                    GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE
   ) 
      RETURN GIACS035_CURRENY_LOV_TAB PIPELINED
   IS
      V_LIST GIACS035_CURRENY_LOV_TYPE;
   BEGIN
        FOR I IN (SELECT DISTINCT A.SHORT_NAME, A.CURRENCY_DESC, A.MAIN_CURRENCY_CD, TO_CHAR(C.CURRENCY_RT, '90.000000000') CURRENCY_RT
                    FROM GIIS_CURRENCY A, GIAC_ORDER_OF_PAYTS B, GIAC_COLLECTION_DTL C 
                   WHERE C.GACC_TRAN_ID = B.GACC_TRAN_ID 
                     AND ((B.DCB_NO = P_DCB_NO AND NVL(WITH_PDC,'N') <> 'Y') OR (C.DUE_DCB_NO = P_DCB_NO AND WITH_PDC = 'Y')) 
                     AND ((TRUNC(B.OR_DATE) = TO_DATE(P_DSP_DCB_DATE,'MM-DD-YYYY') AND NVL(WITH_PDC,'N') <> 'Y') OR (TRUNC(C.DUE_DCB_DATE) = TO_DATE(P_DSP_DCB_DATE,'MM-DD-YYYY') AND WITH_PDC = 'Y')) 
                     AND B.GIBR_BRANCH_CD = P_GIBR_BRANCH_CD
                     AND B.GIBR_GFUN_FUND_CD = P_GFUN_FUND_CD
                     AND C.PAY_MODE = P_PAY_MODE
                     AND C.CURRENCY_CD = A.MAIN_CURRENCY_CD 
                     AND ((B.OR_FLAG = 'P') OR (B.OR_FLAG = 'C' AND NVL(TO_CHAR(B.CANCEL_DATE, 'MM-DD-YYYY'), '-') <> TO_CHAR(B.OR_DATE, 'MM-DD-YYYY')))
                     AND A.SHORT_NAME LIKE UPPER(P_SEARCH)
        )
        LOOP
            V_LIST.SHORT_NAME               := I.SHORT_NAME;
            V_LIST.CURRENCY_DESC            := I.CURRENCY_DESC;
            V_LIST.MAIN_CURRENCY_CD         := I.MAIN_CURRENCY_CD;  
            V_LIST.CURRENCY_RT              := I.CURRENCY_RT;        
        
            PIPE ROW(V_LIST);
        END LOOP;        
        RETURN;   
   END;   -- dren 07.16.2015 : SR 0017729 - Added GIACS035_CURRENY_LOV - End      
   
END giis_currency_pkg;
/



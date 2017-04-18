CREATE OR REPLACE PACKAGE BODY CPI.cg_ref_codes_pkg
AS
   FUNCTION get_cg_ref_codes_list (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_codes   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 20) rv_low_value,
                         rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = p_rv_domain
                ORDER BY UPPER (rv_meaning))
      LOOP
         v_codes.rv_low_value := i.rv_low_value;
         v_codes.rv_meaning := i.rv_meaning;
         PIPE ROW (v_codes);
      END LOOP;

      RETURN;
   END get_cg_ref_codes_list;

   FUNCTION get_cg_ref_codes_list3 (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_codes   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 20) rv_low_value,
                         rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = p_rv_domain
                ORDER BY rv_low_value)
      LOOP
         v_codes.rv_low_value := i.rv_low_value;
         v_codes.rv_meaning := i.rv_meaning;
         PIPE ROW (v_codes);
      END LOOP;

      RETURN;
   END get_cg_ref_codes_list3;

   FUNCTION get_rv_meaning (p_rv_domain VARCHAR2, p_rv_low_value VARCHAR2)
      RETURN VARCHAR2
   IS
      v_rv_meaning   VARCHAR2 (100);
   BEGIN
      FOR cg IN (SELECT   UPPER (rv_meaning) rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = p_rv_domain
                      AND rv_low_value = p_rv_low_value
                 ORDER BY UPPER (rv_meaning))
      LOOP
         v_rv_meaning := cg.rv_meaning;
         EXIT;
      END LOOP;

      RETURN (v_rv_meaning);
   END get_rv_meaning;

   /* POLICY STATUS */
   FUNCTION get_policy_status_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_status   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 25) rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIPI_WPOLBAS.POL_FLAG'
                     AND rv_low_value != '4'
                     AND rv_low_value != '5'
                ORDER BY UPPER (rv_meaning))
      LOOP
         v_status.rv_low_value := i.rv_low_value;
         v_status.rv_meaning := i.rv_meaning;
         PIPE ROW (v_status);
      END LOOP;

      RETURN;
   END get_policy_status_list;

/********************************** FUNCTION 2************************************
  MODULE:  GIACS001
  RECORD GROUP NAME: PAYMENT_MODE
  BY: TONIO
***********************************************************************************/
   FUNCTION get_payment_mode_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_paymode   cg_ref_codes_list_type;
   BEGIN
      -- edited by d.alcantara, 02-16-2012, added IMPLEMENTATION_SW condition
      IF NVL (giisp.v ('IMPLEMENTATION_SW'), 'N') = 'Y'
      THEN
         FOR i IN (SELECT   rv_low_value rv_low_value, rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GIAC_COLLECTION_DTL.PAY_MODE'
                   ORDER BY rv_meaning ASC)
         LOOP
            v_paymode.rv_low_value := i.rv_low_value;
            v_paymode.rv_meaning := i.rv_meaning;
            PIPE ROW (v_paymode);
         END LOOP;
      ELSE
         FOR i IN (SELECT   rv_low_value rv_low_value, rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GIAC_COLLECTION_DTL.PAY_MODE'
                        AND rv_low_value <> 'PDC'
                   ORDER BY rv_meaning ASC)
         LOOP
            v_paymode.rv_low_value := i.rv_low_value;
            v_paymode.rv_meaning := i.rv_meaning;
            PIPE ROW (v_paymode);
         END LOOP;
      END IF;
   END get_payment_mode_list;

/********************************** FUNCTION 3************************************
  MODULE:  GIACS001
  RECORD GROUP NAME: CHECK_CLASS
  BY: TONIO 06/22/2010
***********************************************************************************/
   FUNCTION get_check_class_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT rv_low_value rv_low_value, rv_meaning rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_COLLECTION_DTL.CHECK_CLASS'
                   AND rv_low_value <> 'PDC')
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_check_class_list;

   /********************************** FUNCTION 3************************************
   MODULE:  GIACS026
   RECORD GROUP NAME: CGDV$GCBA_TRANSACTION_TYPE
   BY: TONIO 07/26/2010
   ***********************************************************************************/
   FUNCTION get_transaction_type_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 250) rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_BANK_COLLNS.TRANSACTION_TYPE'
                ORDER BY rv_low_value)
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_transaction_type_list;

       /********************************** FUNCTION 3************************************
   MODULE:  GIACS007
   RECORD GROUP NAME: CGDV$GCBA_TRANSACTION_TYPE
   BY: TONIO 08/5/2010
   ***********************************************************************************/
   FUNCTION get_transaction_type_listing (
      p_rvdomain   cg_ref_codes.rv_domain%TYPE
   )
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 250) rv_meaning --changed by steven 11.21.2014 to 250
                    FROM cg_ref_codes
                   WHERE rv_domain = p_rvdomain
                ORDER BY rv_low_value)
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_transaction_type_listing;

   /********************************** FUNCTION 7 ************************************
   MODULE:  GIACS009
   RECORD GROUP NAME: LOV_SHARE_TYPE
   BY: NIKNOK 10/21/2010
   ***********************************************************************************/
   FUNCTION get_cg_ref_codes_list2 (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_codes   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = p_rv_domain AND rv_low_value <> 1
                ORDER BY UPPER (rv_meaning))
      LOOP
         v_codes.rv_low_value := i.rv_low_value;
         v_codes.rv_meaning := i.rv_meaning;
         PIPE ROW (v_codes);
      END LOOP;

      RETURN;
   END;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 24, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Funtion to retrieve the cg_ref_codes ordered by rv_low_value
*/
   FUNCTION get_cg_ref_cd_ordby_val (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_codes   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = p_rv_domain
                ORDER BY rv_low_value)
      LOOP
         v_codes.rv_low_value := i.rv_low_value;
         v_codes.rv_meaning := i.rv_meaning;
         PIPE ROW (v_codes);
      END LOOP;

      RETURN;
   END get_cg_ref_cd_ordby_val;

   PROCEDURE cgdv$chk_char_ref_codes (
      p_value     IN OUT   VARCHAR2               /* Value to be validated  */
                                   ,
      p_meaning   IN OUT   VARCHAR2               /* Domain meaning         */
                                   ,
      p_domain    IN       VARCHAR2
   )
   IS                                             /* Reference codes domain */
      new_value    VARCHAR2 (240);
      curr_value   VARCHAR2 (240);
   BEGIN
      curr_value := p_value;

      IF (curr_value IS NOT NULL)
      THEN
         SELECT DECODE (rv_high_value, NULL, rv_low_value, curr_value),
                rv_meaning
           INTO new_value,
                p_meaning
           FROM cg_ref_codes
          WHERE (   (    rv_high_value IS NULL
                     AND curr_value IN (rv_low_value, rv_abbreviation)
                    )
                 OR (curr_value BETWEEN rv_low_value AND rv_high_value)
                )
            AND ROWNUM = 1
            AND rv_domain = p_domain;

         p_value := new_value;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_value := NULL;
   END;

   FUNCTION get_tran_flag_mean (p_tran_flag giac_acctrans.tran_flag%TYPE)
      RETURN VARCHAR2
   IS
      v_tran_flag_mean   cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      FOR a IN (SELECT RTRIM (rv_meaning) tran_flag_mean
                  FROM cg_ref_codes
                 WHERE rv_low_value = p_tran_flag
                   AND rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG')
      LOOP
         v_tran_flag_mean := a.tran_flag_mean;
         EXIT;
      END LOOP;

      RETURN (v_tran_flag_mean);
   END;

   FUNCTION get_dcb_pay_mode_list (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_order_of_payts.dcb_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_keyword          VARCHAR2
   )
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_paymode    cg_ref_codes_list_type;
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

      FOR i IN
         (SELECT DISTINCT gicd.pay_mode rv_low_value,
                          SUBSTR (cgrc.rv_meaning, 1, 12) rv_meaning
                     FROM cg_ref_codes cgrc,
                          giac_order_of_payts giop,
                          giac_collection_dtl gicd
                    WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                      AND (   (    giop.dcb_no = p_dcb_no
                               AND NVL (with_pdc, 'N') <> 'Y'
                              )
                           OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y'
                              )
                          )
                      AND (   (    TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                               AND NVL (with_pdc, 'N') <> 'Y'
                              )
                           OR (    TO_CHAR (gicd.due_dcb_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                               AND with_pdc = 'Y'
                              )
                          )
                      AND giop.gibr_branch_cd = p_gibr_branch_cd
                      AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                      AND (   (giop.or_flag = 'P')
                           OR (    giop.or_flag = 'C'
                               AND NVL (TO_CHAR (giop.cancel_date,
                                                 'MM-DD-YYYY'
                                                ),
                                        '-'
                                       ) <>
                                          TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                              )
                          )
                      AND gicd.pay_mode = cgrc.rv_low_value
                      AND cgrc.rv_domain = 'GIAC_DCB_BANK_DEP.PAY_MODE'
                      AND (   UPPER (gicd.pay_mode) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                           OR UPPER (SUBSTR (cgrc.rv_meaning, 1, 12)) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          ))
      LOOP
         v_paymode.rv_low_value := i.rv_low_value;
         v_paymode.rv_meaning := i.rv_meaning;
         PIPE ROW (v_paymode);
      END LOOP;
   END get_dcb_pay_mode_list;

   /********************************** FUNCTION 3************************************
     MODULE:  GIACS0035
     RECORD GROUP NAME: CHECK_CLASS
     BY: Emman 04/20/2011
   ***********************************************************************************/
   FUNCTION get_check_class_list2
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_COLLECTION_DTL.CHECK_CLASS')
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_check_class_list2;

   /*    Date        Author            Description
   **    ==========    ===============    ============================
   **    10.04.2011    mark jm            another version of get_rv_meaning (no upper case)
   */
   FUNCTION get_rv_meaning1 (
      p_rv_domain      IN   VARCHAR2,
      p_rv_low_value   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_rv_meaning   VARCHAR2 (100);
   BEGIN
      FOR cg IN (SELECT rv_meaning
                   FROM cg_ref_codes
                  WHERE rv_domain = p_rv_domain
                    AND rv_low_value = p_rv_low_value)
      LOOP
         v_rv_meaning := cg.rv_meaning;
         EXIT;
      END LOOP;

      RETURN (v_rv_meaning);
   END get_rv_meaning1;

       /*
   **  Created by   :  Marie Kris Felipe
   **  Date Created :  April 25, 2013
   **  Reference By : GIACS002 - Disbursement Voucher Information
   **  Description  : Funtion to retrieve the list of check class
   */
   FUNCTION get_check_class_list3
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 15) rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_CLASS'
                ORDER BY rv_low_value)
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_check_class_list3;

/*
**  Created by   :  Marie Kris Felipe
**  Date Created :  April 25, 2013
**  Reference By : GIACS002 - Disbursement Voucher Information
**  Description  : Funtion to retrieve the list of check stat
*/
   FUNCTION get_check_stat_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_checkclass   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 15) rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT'
                ORDER BY rv_low_value)
      LOOP
         v_checkclass.rv_meaning := i.rv_meaning;
         v_checkclass.rv_low_value := i.rv_low_value;
         PIPE ROW (v_checkclass);
      END LOOP;

      RETURN;
   END get_check_stat_list;

   FUNCTION validate_memo_type (p_memo_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_temp   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT rv_meaning
           INTO v_temp
           FROM TABLE
                   (cg_ref_codes_pkg.get_cg_ref_codes_list
                                                       ('GIAC_CM_DM.MEMO_TYPE')
                   )
          WHERE UPPER (p_memo_type) = UPPER (rv_low_value);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_temp := 'ERROR';
      END;

--
      RETURN v_temp;
   END validate_memo_type;

   FUNCTION fetch_status_list(p_keyword VARCHAR2)
      RETURN cg_ref_codes_list_tab PIPELINED
   AS
      lov   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
                     AND UPPER (rv_low_value) LIKE
                                   '%' || UPPER (NVL (p_keyword, rv_low_value))
                                   || '%'
                ORDER BY rv_low_value)
      LOOP
         lov.rv_low_value := i.rv_low_value;
         lov.rv_meaning := i.rv_meaning;
         PIPE ROW (lov);
      END LOOP;
   END fetch_status_list;

   FUNCTION get_giacs127_tran_class_list
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_list   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS')
      LOOP
         v_list.rv_low_value := i.rv_low_value;
         v_list.rv_meaning := i.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacs127_tran_class_list;

   FUNCTION validate_giacs127_tran_class (
      p_rv_low_value   VARCHAR2,
      p_chk_include    VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_check   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT rv_meaning
           INTO v_check
           FROM cg_ref_codes
          WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
            AND UPPER (rv_low_value) = UPPER (p_rv_low_value)
            AND DECODE (p_chk_include, 'true', 'X', rv_low_value) NOT IN
                                                                ('COL', 'DV');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_check := 'ERROR';
      END;

      RETURN v_check;
   END validate_giacs127_tran_class;

   FUNCTION get_giacs127_jv_tran
      RETURN giacs127_jv_tran_tab PIPELINED
   IS
      v_list   giacs127_jv_tran_type;
   BEGIN
      FOR i IN (SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans)
      LOOP
         v_list.jv_tran_cd := i.jv_tran_cd;
         v_list.jv_tran_desc := i.jv_tran_desc;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacs127_jv_tran;

   FUNCTION validate_giacs127_jv_tran (p_jv_tran_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_check   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT jv_tran_desc
           INTO v_check
           FROM giac_jv_trans
          WHERE UPPER (jv_tran_cd) = UPPER (p_jv_tran_cd);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_check := 'ERROR';
      END;

      RETURN v_check;
   END validate_giacs127_jv_tran;

   FUNCTION get_giacs060_tran_class
      RETURN giacs060_tran_class_tab PIPELINED
   IS
      v_list   giacs060_tran_class_type;
   BEGIN
      FOR i IN (SELECT SUBSTR (rv_low_value, 1, 3) tran_class,
                       SUBSTR (rv_meaning, 1, 50) description
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS')
      LOOP
         v_list.tran_class := i.tran_class;
         v_list.description := i.description;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacs060_tran_class;

   FUNCTION get_giacs601_transactions
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_list   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT *
                           FROM cg_ref_codes
                          WHERE rv_domain LIKE
                                          'GIAC_UPLOAD_FILE.TRANSACTION_TYPE'
                       ORDER BY rv_low_value)
      LOOP
         v_list.rv_meaning := i.rv_meaning;
         v_list.rv_low_value := i.rv_low_value;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacs601_transactions;

   FUNCTION get_giiss080_class_type_lov
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_list   cg_ref_codes_list_type;
   BEGIN
      FOR i IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                         SUBSTR (rv_meaning, 1, 8) rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_GEOG_CLASS.CLASS_TYPE'
                ORDER BY rv_low_value)
      LOOP
         v_list.rv_low_value := i.rv_low_value;
         v_list.rv_meaning := i.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;
   END get_giiss080_class_type_lov;
   
   FUNCTION get_giiss053_zone_grp_lov
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
    v_list  cg_ref_codes_list_type;
   BEGIN
   
    FOR rec IN (SELECT rv_low_value , rv_meaning 
                  FROM cg_ref_codes
                 WHERE rv_domain = 'ZONE_GROUP')
    LOOP
         v_list.rv_low_value := rec.rv_low_value;
         v_list.rv_meaning := rec.rv_meaning;
         PIPE ROW (v_list);
    END LOOP;
   
   END get_giiss053_zone_grp_lov;
   FUNCTION GET_GIACS605_TRANSACTION_LOV( -- Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Transaction
        P_SEARCH        VARCHAR2 
   ) 
      RETURN GIACS605_TRANSACTION_LOV_TAB PIPELINED
   IS
      V_LIST GIACS605_TRANSACTION_LOV_TYPE;
   BEGIN
        FOR I IN (
                SELECT RV_LOW_VALUE, RV_MEANING
                  FROM CG_REF_CODES
                 WHERE RV_DOMAIN ='GIAC_UPLOAD_FILE.TRANSACTION_TYPE'
                   AND RV_LOW_VALUE LIKE UPPER(P_SEARCH)  
              ORDER BY RV_LOW_VALUE   
        )
        LOOP
            V_LIST.RV_LOW_VALUE     := I.RV_LOW_VALUE;
            V_LIST.RV_MEANING       := I.RV_MEANING;   
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;   
   END;    
   FUNCTION GET_GIACS606_TRANSACTION_LOV( -- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Transaction
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS606_TRANSACTION_LOV_TAB PIPELINED
   IS
      V_LIST GIACS606_TRANSACTION_LOV_TYPE;
   BEGIN
        FOR I IN (
                SELECT RV_LOW_VALUE, RV_MEANING
                  FROM CG_REF_CODES
                 WHERE RV_DOMAIN ='GIAC_UPLOAD_FILE.TRANSACTION_TYPE'
                   AND RV_LOW_VALUE LIKE UPPER(P_SEARCH)  
              ORDER BY RV_LOW_VALUE   
        )
        LOOP
            V_LIST.RV_LOW_VALUE     := I.RV_LOW_VALUE;
            V_LIST.RV_MEANING       := I.RV_MEANING;   
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;   
   END;    
   FUNCTION GET_GIACS606_STATUS_LOV( -- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Status
        P_SEARCH                VARCHAR2,
        P_TRANSACTION_TYPE      GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE 
   ) 
      RETURN GIACS606_STATUS_LOV_TAB PIPELINED
   IS
      V_LIST    GIACS606_STATUS_LOV_TYPE;
      V_DOMAIN  CG_REF_CODES.RV_DOMAIN%TYPE;
   BEGIN
        IF P_TRANSACTION_TYPE IN (1,2,5) THEN
            IF P_TRANSACTION_TYPE = 1 THEN
                V_DOMAIN := 'GIAC_UPLOAD_PREM.PREM_CHK_FLAG';
                    
            ELSIF P_TRANSACTION_TYPE = 2 THEN
                V_DOMAIN := 'GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG';
                    
            ELSIF P_TRANSACTION_TYPE = 5 THEN
                V_DOMAIN := 'GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG';
                    
            ELSE
                V_DOMAIN := 'GIAC_UPLOAD_PREM.PREM_CHK_FLAG';
                    
            END IF;                   
           
            FOR I IN (
                    SELECT RV_LOW_VALUE, RV_MEANING
                      FROM CG_REF_CODES
                     WHERE RV_DOMAIN = V_DOMAIN
                       AND RV_LOW_VALUE LIKE UPPER(P_SEARCH)  
                  ORDER BY RV_LOW_VALUE   
            )
            LOOP
                V_LIST.RV_LOW_VALUE     := I.RV_LOW_VALUE;
                V_LIST.RV_MEANING       := I.RV_MEANING;   
                
                PIPE ROW(V_LIST);
            END LOOP;
                
            RETURN;            
        ELSE
            IF P_TRANSACTION_TYPE = 3 THEN
                V_DOMAIN := 'GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG';
                    
            ELSIF P_TRANSACTION_TYPE = 4 THEN
                V_DOMAIN := 'GIAC_UPLOAD_OUTFACUL_PREM.PREM_CHK_FLAG';

            ELSE
                V_DOMAIN := 'GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG';
                    
            END IF;                   
           
            FOR I IN (
                    SELECT RV_LOW_VALUE, RV_MEANING
                      FROM CG_REF_CODES
                     WHERE RV_DOMAIN = V_DOMAIN
                       AND RV_LOW_VALUE LIKE UPPER(P_SEARCH)  
                  ORDER BY RV_LOW_VALUE   
            )
            LOOP
                V_LIST.RV_LOW_VALUE     := I.RV_LOW_VALUE;
                V_LIST.RV_MEANING       := I.RV_MEANING;   
                
                PIPE ROW(V_LIST);
            END LOOP;
                
            RETURN;   
        END IF;
   END;              
   
   --added by carlo rubenecia 04.15.2016 SR 5490 --START
   FUNCTION get_code_list
        RETURN code_list_tab PIPELINED
    IS
        v_list  code_list_type;
    BEGIN
        FOR q IN(SELECT SUBSTR(RV_MEANING, 10) rv_meaning FROM CG_REF_CODES WHERE RV_DOMAIN = 'GIAC_ACCTRANS.TRAN_CLASS' 
                            AND RV_LOW_VALUE IN ('DGP', 'DPC', 'DCI', 'DCE'))
        LOOP
            v_list.rv_meaning := q.rv_meaning;
            PIPE ROW(v_list);
        END LOOP;
   END get_code_list;
   --added by carlo rubenecia 04.15.2016 SR 5490 --END   
   
END cg_ref_codes_pkg;
/

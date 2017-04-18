CREATE OR REPLACE PACKAGE BODY CPI.giacr235_pkg
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 03.11.2013
    **  Reference By : GIACR235_PKG - Listing per OR Status
    */
   FUNCTION get_details (
        P_OR_FLAG           giac_order_of_payts.or_flag%TYPE,
        P_ISS_CD            giis_issource.iss_cd%TYPE,
        P_FROM_DATE         DATE,
        P_TO_DATE           DATE,
        P_TRAN_FLAG         giac_acctrans.tran_flag%TYPE,
        P_USER_ID           giis_users.user_id%TYPE
   )
      RETURN get_details_tab PIPELINED
   IS
        v_detail            get_details_type;
        v_print  BOOLEAN := TRUE;   --added by Gzelle 08122014
   BEGIN
      v_detail.company_name    := giisp.v ('COMPANY_NAME');     --moved here by Gzelle 08122014
      v_detail.company_address := giisp.v ('COMPANY_ADDRESS');
      v_detail.rep_from_date   := TO_CHAR (p_from_date, 'fmMonth dd, yyyy');
      v_detail.rep_to_date     := TO_CHAR (p_to_date, 'fmMonth dd, yyyy');
      
      FOR i IN (SELECT   UPPER (rv_meaning) rv_meaning,
                            or_pref_suf
                         || ' '
                         || TO_CHAR (or_no, '0000000009') or_no,
                         TRUNC (or_date) or_date, cashier_cd cashier_cd,
                         LTRIM (payor) payor,
                         LTRIM (goop.particulars) particulars,
                         collection_amt amount_received, iss_name branch_name, iss_cd branch_cd
                    FROM giac_acctrans ga,
                         giac_order_of_payts goop,
                         giis_issource,
                         cg_ref_codes crc
                   WHERE goop.or_flag = crc.rv_low_value
                     AND goop.gacc_tran_id = ga.tran_id
                     AND iss_cd = goop.gibr_branch_cd
                     AND rv_low_value <> 'D'
                     AND crc.rv_domain = 'GIAC_ORDER_OF_PAYTS.OR_FLAG'
                     AND or_flag = NVL (p_or_flag, or_flag)
                     AND goop.gibr_branch_cd =
                                          NVL (p_iss_cd, goop.gibr_branch_cd)
                     AND TRUNC (or_date) BETWEEN p_from_date AND p_to_date
                     AND tran_flag = DECODE (p_or_flag, 'P', NVL (p_tran_flag, tran_flag), tran_flag)
                     AND check_user_per_iss_cd_acctg2 (NULL,  goop.gibr_branch_cd, 'GIACS235', p_user_id) = 1
                ORDER BY rv_meaning asc, branch_cd, --payor,--comment out by sherry GENQA SR# 5219 12.17.2015 
                or_no --desc --comment out by sherry GENQA SR# 5219 12.17.2015
                )
      LOOP
         v_print                  := FALSE;     --added by Gzelle 08122014
         v_detail.rv_meaning      := i.rv_meaning;
         v_detail.or_no           := i.or_no;
         v_detail.or_date         := TO_CHAR (i.or_date, 'MM-DD-RRRR');
         v_detail.cashier_cd      := i.cashier_cd;
         v_detail.payor           := i.payor;
         v_detail.particulars     := i.particulars;
         v_detail.amount_received := i.amount_received;
         v_detail.iss_name        := i.branch_name;
         v_detail.iss_cd          := i.branch_cd;
         PIPE ROW (v_detail);
      END LOOP;
      
      IF v_print        --added by Gzelle 08122014
      THEN
         v_detail.dummy := 'T';
         PIPE ROW (v_detail);
      END IF;

      RETURN;
   END get_details;
END giacr235_pkg;
/



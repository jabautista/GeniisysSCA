CREATE OR REPLACE PACKAGE BODY CPI.giac_acctrans_pkg
AS
   PROCEDURE set_giac_acctrans_dtl (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date        giac_acctrans.tran_date%TYPE,
      p_tran_flag        giac_acctrans.tran_flag%TYPE,
      p_tran_class       giac_acctrans.tran_class%TYPE,
      p_tran_class_no    giac_acctrans.tran_class_no%TYPE,
      p_particulars      giac_acctrans.particulars%TYPE,
      p_tran_year        giac_acctrans.tran_year%TYPE,
      p_tran_month       giac_acctrans.tran_month%TYPE,
      p_tran_seq_no      giac_acctrans.tran_seq_no%TYPE
   )
   IS
      v_tran_seq_no   NUMBER;
      v_tran_id       NUMBER;
   BEGIN
      /*  IF p_tran_id = 0
        THEN
           SELECT acctran_tran_id_s.NEXTVAL
             INTO v_tran_id
             FROM DUAL;


        END IF;*/
        
        -- changed condition in generating sequence number - christian 09.03.2012
        BEGIN
        SELECT 1 
          INTO v_tran_id
          FROM giac_acctrans
         WHERE tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tran_id := 0;
        END;

        IF (v_tran_id = 0) THEN
            v_tran_seq_no := giac_sequence_generation (p_gfun_fund_cd,
                                                       p_gibr_branch_cd,
                                                       'ACCTRAN_TRAN_SEQ_NO',
                                                       p_tran_year,
                                                       p_tran_month);
        END IF;

        
      MERGE INTO giac_acctrans
         USING DUAL
         ON (tran_id = p_tran_id)
         WHEN NOT MATCHED THEN
            INSERT (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                    tran_flag, tran_class, tran_class_no, particulars,
                    tran_year, tran_month, tran_seq_no, user_id, last_update)
            VALUES (p_tran_id, p_gfun_fund_cd, p_gibr_branch_cd,  NVL(p_tran_date, SYSDATE),
                    p_tran_flag, p_tran_class, p_tran_class_no, p_particulars,
                    p_tran_year, p_tran_month, v_tran_seq_no,
                    NVL (giis_users_pkg.app_user, USER), SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET gfun_fund_cd = p_gfun_fund_cd,
                   gibr_branch_cd = p_gibr_branch_cd, 
                   /*tran_date = SYSDATE, commented by: Nica 12.18.2012 tran_date must not be updated 
                                          to sysdate since it must be equal to the or date*/
                   tran_date = NVL(p_tran_date, tran_date),
                   tran_class = p_tran_class,
                                             --tran_flag = p_tran_flag commented by tonio May 18, 2011
                                             tran_class_no = p_tran_class_no,
                   particulars = p_particulars, tran_year = p_tran_year,
                   tran_month = p_tran_month, tran_seq_no = p_tran_seq_no,
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
            ;
   END;

   FUNCTION get_giac_acctrans (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE
   )
      RETURN giac_acctrans_tab PIPELINED
   IS
      v_giac_acctrans   giac_acctrans_type;
   BEGIN
      FOR i IN (SELECT a.tran_id, a.gfun_fund_cd, a.gibr_branch_cd,
                       a.tran_date, a.tran_flag, a.tran_class,
                       a.tran_class_no, a.particulars, a.tran_year,
                       a.tran_month, a.tran_seq_no
                  FROM giac_acctrans a
                 WHERE tran_id = p_tran_id
                   AND gfun_fund_cd = p_gfun_fund_cd
                   AND gibr_branch_cd = p_gibr_branch_cd)
      LOOP
         v_giac_acctrans.tran_id := i.tran_id;
         v_giac_acctrans.gfun_fund_cd := i.gfun_fund_cd;
         v_giac_acctrans.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_acctrans.tran_date := i.tran_date;
         v_giac_acctrans.tran_flag := i.tran_flag;
         v_giac_acctrans.tran_class := i.tran_class;
         v_giac_acctrans.tran_class_no := i.tran_class_no;
         v_giac_acctrans.particulars := i.particulars;
         v_giac_acctrans.tran_year := i.tran_year;
         v_giac_acctrans.tran_month := i.tran_month;
         v_giac_acctrans.tran_seq_no := i.tran_seq_no;
         PIPE ROW (v_giac_acctrans);
      END LOOP;
   END get_giac_acctrans;

   FUNCTION get_validation_params (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giac_acctrans_tab PIPELINED
   IS
      v_giac_acctrans   giac_acctrans_type;
   BEGIN
      BEGIN
         SELECT gfun_fund_cd, tran_flag,
                tran_date
           INTO v_giac_acctrans.gfun_fund_cd, v_giac_acctrans.tran_flag,
                v_giac_acctrans.tran_date
           FROM giac_acctrans
          WHERE tran_id = p_tran_id;

         PIPE ROW (v_giac_acctrans);
         RETURN;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END;

   FUNCTION get_tran_flag (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN VARCHAR2
   IS
      v_flag   VARCHAR2 (1);
   BEGIN
      SELECT tran_flag
        INTO v_flag
        FROM giac_acctrans
       WHERE tran_id = p_tran_id;

      RETURN v_flag;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_tran_flag;

   PROCEDURE upd_acc_giacs050 (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd   giac_acctrans.gibr_branch_cd%TYPE
   )
   IS
      v_auto_close   giac_parameters.param_value_v%TYPE;
      v_debit_amt    giac_acct_entries.debit_amt%TYPE;
      v_credit_amt   giac_acct_entries.credit_amt%TYPE;
   BEGIN
      /*
      **  Created by   :  d.alcantara
      **  Date Created :  03.15.2011
      **  Reference By : (GIACS050 - OR Printing)
      **  Description  : Updates the tran_flag of a record that
      **                   has been successfully printed.
      */
      FOR a IN (SELECT SUM (debit_amt) debit_amt, SUM (credit_amt)
                                                                  credit_amt
                  FROM giac_acct_entries
                 WHERE 1 = 1
                   AND gacc_tran_id = p_tran_id
                   AND gacc_gibr_branch_cd = p_branch_cd
                   AND gacc_gfun_fund_cd = p_fund_cd)
      LOOP
         v_debit_amt := a.debit_amt;
         v_credit_amt := a.credit_amt;
      END LOOP;

      IF     (v_debit_amt = v_credit_amt)
         AND (v_debit_amt <> 0 AND v_credit_amt <> 0)
      THEN
         FOR b IN (SELECT param_value_v
                     FROM giac_parameters
                    WHERE param_name = 'AUTO_CLOSE_OR')
         LOOP
            v_auto_close := b.param_value_v;
         END LOOP;

         IF v_auto_close = 'Y'
         THEN
            /* changed tran_flag to 'C' */
            UPDATE giac_acctrans
               SET tran_flag = 'C',
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
             WHERE tran_id = p_tran_id;
         END IF;
      END IF;
   END;
   
      /*
      **  Created by   :  Steven Ramirez
      **  Date Created :  02.26.2013
      **  Reference By : (GIACS050 - OR Printing)
      **  Description  : delete's the value of or_no and or_pref_suf when the printing is not successful
      */
   PROCEDURE del_acc_giacs050 (
      p_tran_id     giac_order_of_payts.gacc_tran_id%TYPE,
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE
   )
   IS
   BEGIN
      UPDATE giac_order_of_payts
         SET or_no = NULL,
             or_pref_suf = NULL
       WHERE gacc_tran_id = p_tran_id
         AND gibr_gfun_fund_cd = p_fund_cd
         AND gibr_branch_cd = p_branch_cd;
   END;
   
   FUNCTION get_dcb_list (
      p_branch_name   giac_branches.branch_name%TYPE,
      p_tran_date     VARCHAR2,
      p_dcb_no        VARCHAR2,
      p_dcb_flag      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN dcb_list_tab PIPELINED
   IS
      v_dcb_list      dcb_list_type;
      v_date_search   DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_date_search
      BEGIN
         v_date_search := TO_DATE (p_tran_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_date_search := NULL;
      END;

      IF v_date_search IS NULL
      THEN
         BEGIN
            v_date_search := TO_DATE (p_tran_date, 'RRRR-MM-DD');
         EXCEPTION
            WHEN OTHERS
            THEN
               v_date_search := NULL;
         END;
      END IF;

      FOR i IN
         (SELECT gacc.tran_id, gacc.gibr_branch_cd, gacc.gfun_fund_cd,
                   gibr.branch_name dsp_branch_name, gacc.tran_date,
                   gacc.tran_year || '-' || gacc.tran_class_no dcb_no, dcb_flag, rv_meaning dsp_dcb_flag
              FROM giac_acctrans gacc, giac_branches gibr, giac_colln_batch gcob, CG_REF_CODES cgrc
             WHERE gacc.gibr_branch_cd = gibr.branch_cd(+)
               AND gacc.tran_class = 'CDC'
               AND gcob.dcb_no = gacc.tran_class_no
               AND gcob.dcb_year = gacc.tran_year
               AND gcob.branch_cd = gacc.gibr_branch_cd
               AND gcob.fund_cd = gacc.gfun_fund_cd
               AND cgrc.rv_low_value = gcob.dcb_flag
               AND cgrc.rv_domain = 'GIAC_COLLN_BATCH.DCB_FLAG'
               AND UPPER (gibr.branch_name) LIKE
                         '%'
                      || NVL (p_branch_name, UPPER (gibr.branch_name))
                      || '%'
               AND TRUNC (gacc.tran_date) =
                                   NVL (v_date_search, TRUNC (gacc.tran_date))
               AND gacc.tran_year || '-' || gacc.tran_class_no LIKE
                         '%'
                      || NVL (p_dcb_no,
                              gacc.tran_year || '-' || gacc.tran_class_no
                             )
                      || '%'
               AND UPPER(cgrc.rv_meaning) LIKE
                         '%'
                      || NVL (UPPER(p_dcb_flag), UPPER (cgrc.rv_meaning))
                      || '%'
               AND ((SELECT access_tag
                          FROM giis_user_modules
                         WHERE userid = NVL (p_user_id, USER)
                           AND module_id = 'GIACS035'
                           AND tran_cd IN (
                                  SELECT b.tran_cd         
                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                   WHERE a.user_id = b.userid
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = gacc.gibr_branch_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS035')) = 1
                 OR (SELECT access_tag
                          FROM giis_user_grp_modules
                         WHERE module_id = 'GIACS035'
                           AND (user_grp, tran_cd) IN (
                                  SELECT a.user_grp, b.tran_cd
                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                   WHERE a.user_grp = b.user_grp
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = gacc.gibr_branch_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS035')) = 1
               )
          ORDER BY gacc.tran_date DESC)
      LOOP
         v_dcb_list.tran_id := i.tran_id;
         v_dcb_list.gibr_branch_cd := i.gibr_branch_cd;
         v_dcb_list.gfun_fund_cd := i.gfun_fund_cd;
         v_dcb_list.dsp_branch_name := i.dsp_branch_name;
         v_dcb_list.tran_date := i.tran_date;
         v_dcb_list.dcb_no := i.dcb_no;
         v_dcb_list.dcb_flag := i.dcb_flag;
         v_dcb_list.dsp_dcb_flag := i.dsp_dcb_flag;
         
         PIPE ROW (v_dcb_list);
      END LOOP;
   END get_dcb_list;

   FUNCTION get_giac_acctrans_dtl (p_gacc_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giac_acctrans_dtl_tab PIPELINED
   IS
      v_acctrans_dtl   giac_acctrans_dtl_type;
   BEGIN
      FOR i IN (SELECT gacc.tran_id, gacc.gfun_fund_cd, gfun.fund_desc,
                       gacc.gibr_branch_cd, gibr.branch_name, gacc.tran_date,
                       gacc.tran_flag, tran_class, tran_class_no,
                       gacc.particulars, tran_year, tran_month, tran_seq_no
                  FROM giac_acctrans gacc,
                       giac_branches gibr,
                       giis_funds gfun
                 WHERE gacc.tran_id = p_gacc_tran_id
                   AND gacc.gibr_branch_cd = gibr.branch_cd(+)
                   AND gacc.gfun_fund_cd = gfun.fund_cd(+))
      LOOP
         v_acctrans_dtl.tran_id := i.tran_id;
         v_acctrans_dtl.gfun_fund_cd := i.gfun_fund_cd;
         v_acctrans_dtl.fund_desc := i.fund_desc;
         v_acctrans_dtl.gibr_branch_cd := i.gibr_branch_cd;
         v_acctrans_dtl.branch_name := i.branch_name;
         v_acctrans_dtl.tran_date := i.tran_date;
         v_acctrans_dtl.tran_flag := i.tran_flag;
         v_acctrans_dtl.tran_class := i.tran_class;
         v_acctrans_dtl.tran_class_no := i.tran_class_no;
         v_acctrans_dtl.particulars := i.particulars;
         v_acctrans_dtl.tran_year := i.tran_year;
         v_acctrans_dtl.tran_month := i.tran_month;
         v_acctrans_dtl.tran_seq_no := i.tran_seq_no;
         --v_acctrans_dtl.dv_flag := null;

         FOR c IN (SELECT gcob.dcb_flag dcb_flag,
                          SUBSTR (cgrc.rv_meaning, 1, 19) rv_meaning,
                          gcob.tran_date --Deo [09.01.2016]: SR-5631
                     FROM giac_colln_batch gcob, cg_ref_codes cgrc
                    WHERE gcob.dcb_no = v_acctrans_dtl.tran_class_no
                      -- dsp_dcb_no
                      AND gcob.dcb_year = v_acctrans_dtl.tran_year
                      -- dsp_dcb_year
                      AND gcob.branch_cd = v_acctrans_dtl.gibr_branch_cd
                      AND gcob.fund_cd = v_acctrans_dtl.gfun_fund_cd
                      AND cgrc.rv_domain = 'GIAC_COLLN_BATCH.DCB_FLAG'
                      AND cgrc.rv_low_value = gcob.dcb_flag)
         LOOP
            v_acctrans_dtl.dcb_flag := c.dcb_flag;
            v_acctrans_dtl.mean_dcb_flag := c.rv_meaning;
            v_acctrans_dtl.dcb_date := c.tran_date; --Deo [09.01.2016]: SR-5631
            EXIT;
         END LOOP;

         FOR a IN (SELECT RTRIM (rv_meaning) tran_flag_mean
                     FROM cg_ref_codes
                    WHERE rv_low_value = v_acctrans_dtl.tran_flag
                      AND rv_domain = 'GIAC_ACCTRANS.TRAN_FLAG')
         LOOP
            v_acctrans_dtl.mean_tran_flag := a.tran_flag_mean;
            EXIT;
         END LOOP;
         
         BEGIN
            SELECT dv_flag
              INTO v_acctrans_dtl.dv_flag
              FROM giac_disb_vouchers
             WHERE gacc_tran_id = p_gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_acctrans_dtl.dv_flag := null;
         END;

         PIPE ROW (v_acctrans_dtl);
      END LOOP;
   END get_giac_acctrans_dtl;

   FUNCTION get_gicd_sum_list (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2
   )
      RETURN gicd_sum_list_tab PIPELINED
   IS
      v_gicd_sum   gicd_sum_list_type;
      v_exist      VARCHAR2 (1)                   := 'N';
      v_dcb_date   giac_acctrans.tran_date%TYPE;
   BEGIN
      -- convert dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      -- PM_SUM
      FOR i IN (SELECT   gicd.pay_mode pay_mode,
                         NVL (SUM (gicd.amount), 0) sum_amount,
                         a430.short_name short_name, a430.currency_desc,
                         NVL (SUM (gicd.fcurrency_amt), 0) sum_fc_amount,
                         gicd.currency_rt currency_rt
                    FROM giis_currency a430,
                         giac_order_of_payts giop,
                         giac_collection_dtl gicd
                   WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                     AND (   (    giop.dcb_no = p_dcb_no
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y')
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
                     AND gicd.currency_cd = a430.main_currency_cd
                     AND (   (giop.or_flag = 'P')
--                          OR (    giop.or_flag = 'C'
--                              AND NVL (TO_CHAR (giop.cancel_date,
--                                                'MM-DD-YYYY'),
--                                       '-'
--                                      ) <>
--                                          TO_CHAR (giop.or_date, 'MM-DD-YYYY')
--                             ) --marco - 02.18.2015 - comment out - FGIC SR 18063
                          OR (    giop.or_flag = 'C'
                              AND giop.cancel_dcb_no <> p_dcb_no
                              AND NVL (TO_CHAR (giop.cancel_date,
                                                'MM-DD-YYYY'),
                                       '-'
                                      ) = TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                             )
                         )
                     AND gicd.pay_mode NOT IN ('CMI', 'CW', 'RCM') -- also exclude RCM - Nica 06.15.2013 AC-SPECS-2012-155
                GROUP BY gicd.pay_mode,
                         a430.short_name,
                         a430.currency_desc,
                         gicd.currency_rt)
      LOOP
         v_gicd_sum.pay_mode := i.pay_mode;
         v_gicd_sum.sum_amount := i.sum_amount;
         v_gicd_sum.short_name := i.short_name;
         v_gicd_sum.currency_desc := i.currency_desc;
         v_gicd_sum.sum_fc_amount := i.sum_fc_amount;
         v_gicd_sum.currency_rt := i.currency_rt;
         v_exist := 'Y';
         PIPE ROW (v_gicd_sum);
      END LOOP;

      IF v_exist = 'N'
      THEN
         -- PDC_SUM
         FOR i IN (SELECT   gicd.pay_mode pay_mode,
                            NVL (SUM (gicd.amount), 0) sum_amount,
                            a430.short_name short_name, a430.currency_desc,
                            NVL (SUM (gicd.fcurrency_amt), 0) sum_fc_amount,
                            gicd.currency_rt currency_rt
                       FROM giis_currency a430,
                            giac_order_of_payts giop,
                            giac_collection_dtl gicd
                      WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                        AND TO_CHAR (gicd.due_dcb_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                        AND gicd.due_dcb_no = p_dcb_no
                        AND gicd.currency_cd = a430.main_currency_cd
                        AND gicd.pay_mode NOT IN ('CMI', 'CW', 'RCM') -- also exclude RCM - Nica 06.15.2013 AC-SPECS-2012-155
                   GROUP BY gicd.pay_mode,
                            a430.short_name,
                            a430.currency_desc,
                            gicd.currency_rt)
         LOOP
            v_gicd_sum.pay_mode := i.pay_mode;
            v_gicd_sum.sum_amount := i.sum_amount;
            v_gicd_sum.short_name := i.short_name;
            v_gicd_sum.currency_desc := i.currency_desc;
            v_gicd_sum.sum_fc_amount := i.sum_fc_amount;
            v_gicd_sum.currency_rt := i.currency_rt;
            v_exist := 'Y';
            PIPE ROW (v_gicd_sum);
         END LOOP;
      END IF;
   END get_gicd_sum_list;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE create_records_in_acctrans (
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_rev_tran_date             giac_acctrans.tran_date%TYPE,
      p_rev_tran_class_no         giac_acctrans.tran_class_no%TYPE,
      p_or_cancellation           VARCHAR2,
      p_or_date                   VARCHAR2,
      p_dcb_no                    giac_order_of_payts.dcb_no%TYPE,
      p_or_no                     giac_order_of_payts.or_no%TYPE,
      p_or_pref_suf               giac_order_of_payts.or_pref_suf%TYPE,
      p_acc_tran_id         OUT   giac_acctrans.tran_id%TYPE,
      p_calling_form              VARCHAR2,
      p_message             OUT   VARCHAR2
   )
   IS
      CURSOR c1
      IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_gibr_gfun_fund_cd;

      CURSOR c2
      IS
         SELECT '2'
           FROM giac_branches
          WHERE branch_cd = p_gibr_branch_cd
            AND gfun_fund_cd = p_gibr_gfun_fund_cd;

      v_c1              VARCHAR2 (1);
      v_c2              VARCHAR2 (1);
      v_tran_id         giac_acctrans.tran_id%TYPE;
      v_last_update     giac_acctrans.last_update%TYPE;
      v_user_id         giac_acctrans.user_id%TYPE;
      v_closed_tag      giac_tran_mm.closed_tag%TYPE;
      v_tran_flag       giac_acctrans.tran_flag%TYPE;
      v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
      v_particulars     giac_acctrans.particulars%TYPE;
      v_tran_date       giac_acctrans.tran_date%TYPE;
      v_tran_year       giac_acctrans.tran_year%TYPE;
      v_tran_month      giac_acctrans.tran_month%TYPE;
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
   BEGIN
      OPEN c1;

      FETCH c1
       INTO v_c1;

      IF c1%NOTFOUND
      THEN
         p_message := 'Invalid company code.';
      ELSE
         OPEN c2;

         FETCH c2
          INTO v_c2;

         IF c2%NOTFOUND
         THEN
            p_message := 'Invalid branch code.';
         END IF;

         CLOSE c2;
      END IF;

      CLOSE c1;

      v_last_update := SYSDATE;

      IF p_calling_form IN ('BANNER_SCREEN', 'GIACS156')
      THEN
         BEGIN
            SELECT acctran_tran_id_s.NEXTVAL
              INTO v_tran_id
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message := 'ACCTRAN_TRAN_ID sequence not found.';
         END;

         IF p_or_cancellation = 'N'
         THEN
            v_tran_date := p_or_date;
            v_tran_class_no := p_dcb_no;
            v_tran_flag := 'O';
            v_particulars := NULL;
            v_user_id := NVL (giis_users_pkg.app_user, USER);
         ELSIF p_or_cancellation = 'Y'
         THEN
            v_tran_date := p_rev_tran_date;
            v_tran_class_no := p_rev_tran_class_no;
            v_tran_flag := 'C';
            v_particulars :=
                  'To reverse entry for cancelled O.R. No.'
               || p_or_pref_suf
               || ' '
               || TO_CHAR (p_or_no)
               || '.';
            v_user_id := NVL (giis_users_pkg.app_user, USER);
         END IF;

         v_tran_year := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
         v_tran_month := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
         v_tran_seq_no :=
            giac_sequence_generation (p_gibr_gfun_fund_cd,
                                      p_gibr_branch_cd,
                                      'ACCTRAN_TRAN_SEQ_NO',
                                      v_tran_year,
                                      v_tran_month
                                     );

         INSERT INTO giac_acctrans
                     (tran_id, gfun_fund_cd, gibr_branch_cd,
                      tran_date, tran_flag, tran_class, tran_class_no,
                      particulars, tran_year, tran_month,
                      tran_seq_no, user_id, last_update
                     )
              VALUES (v_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd,
                      v_tran_date, v_tran_flag, 'COL', v_tran_class_no,
                      v_particulars, v_tran_year, v_tran_month,
                      v_tran_seq_no, v_user_id, v_last_update
                     );

         IF p_or_cancellation = 'Y'
         THEN
            p_acc_tran_id := v_tran_id;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END create_records_in_acctrans;

   PROCEDURE get_dcb_flag (
      p_gfun_fund_cd     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_year         IN       giac_acctrans.tran_year%TYPE,
      p_dcb_no           IN       NUMBER,
      p_dsp_dcb_flag     IN OUT   VARCHAR2,
      p_mean_dcb_flag    IN OUT   VARCHAR2
   )
   IS
   /*
   **  Created by   :  Emman
   **  Date Created :  04.01.2011
   **  Reference By : (GIACS035 - Close DCB)
   **  Description  : Executes GET_DCB_FLAG procedure, gets dsp_dcb_flag and mean_dcb_flag
   */
   BEGIN
      FOR c IN (SELECT gcob.dcb_flag dcb_flag,
                       SUBSTR (cgrc.rv_meaning, 1, 19) rv_meaning
                  FROM giac_colln_batch gcob, cg_ref_codes cgrc
                 WHERE gcob.dcb_no = p_dcb_no
                   AND gcob.dcb_year = p_dcb_year
                   AND gcob.branch_cd = p_gibr_branch_cd
                   AND gcob.fund_cd = p_gfun_fund_cd
                   AND cgrc.rv_domain = 'GIAC_COLLN_BATCH.DCB_FLAG'
                   AND cgrc.rv_low_value = gcob.dcb_flag)
      LOOP
         p_dsp_dcb_flag := c.dcb_flag;
         p_mean_dcb_flag := c.rv_meaning;
         EXIT;
      END LOOP;
   END get_dcb_flag;

   PROCEDURE validate_giacs035_dcb_no_1 (
      p_gfun_fund_cd              IN       giac_colln_batch.fund_cd%TYPE,
      p_gibr_branch_cd            IN       giac_colln_batch.branch_cd%TYPE,
      p_dcb_date                  IN       VARCHAR2,
      p_dcb_year                  IN       giac_colln_batch.dcb_year%TYPE,
      p_dcb_no                    IN       giac_colln_batch.dcb_no%TYPE,
      p_var_all_ors_r_cancelled   IN OUT   VARCHAR2,
      p_invalid_dcb_no            OUT      VARCHAR2
   )
   IS
      /*
      **  Created by   :  Emman
      **  Date Created :  03.31.2011
      **  Reference By : (GIACS035 - Close DCB)
      **  Description  : Validates the DCB_NO field
      */
      v_dcb_date   DATE;
   BEGIN
      p_invalid_dcb_no := 'N';

      -- check first if search key is in date format. if yes, store it to v_dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      /* VALIDATE_DCB_NO **/
      DECLARE
         v_exists   VARCHAR2 (1) := 'N';
      BEGIN
         FOR b IN
            (SELECT a.dcb_no
               FROM giac_colln_batch a
              WHERE a.dcb_no = p_dcb_no
                AND a.dcb_year = p_dcb_year
                AND a.branch_cd = p_gibr_branch_cd
                AND a.fund_cd = p_gfun_fund_cd
                AND a.dcb_flag IN ('O', 'X')
                AND a.dcb_no NOT IN (
                       SELECT gacc.tran_class_no
                         FROM giac_acctrans gacc
                        WHERE gacc.tran_class = 'CDC'
                          AND gacc.gfun_fund_cd = p_gfun_fund_cd
                          AND gacc.gibr_branch_cd = p_gibr_branch_cd
                          AND TO_CHAR (gacc.tran_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                          AND gacc.tran_year = p_dcb_year
                          AND gacc.tran_flag <> 'D'))
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'N'
         THEN
            p_invalid_dcb_no := 'Y';
            RETURN;
         END IF;
      END;

      /* end of VALIDATE_DCB_NO procedure **/

      /* CHECK_IF_ALL_ORs_R_CANCELLED **/
      DECLARE
         v_or_flag   VARCHAR2 (1);            --to store the selected or_flag
      BEGIN
         FOR a IN (SELECT or_flag
                     FROM giac_order_of_payts giop, giac_collection_dtl gcdl
                    WHERE 1 = 1
                      AND giop.gacc_tran_id = gcdl.gacc_tran_id
                      AND (   giop.dcb_no = p_dcb_no
                           OR (    gcdl.due_dcb_no = p_dcb_no
                               AND TRUNC (gcdl.due_dcb_date) = v_dcb_date
                              )
                          )
                      AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                      AND giop.gibr_branch_cd = p_gibr_branch_cd
                      AND giop.or_flag IS NOT NULL
                      AND (   TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                           OR TRUNC (gcdl.due_dcb_date) = v_dcb_date
                          )
                   MINUS
                   SELECT or_flag
                     FROM giac_order_of_payts giop, giac_collection_dtl gcdl
                    WHERE 1 = 1
                      AND giop.gacc_tran_id = gcdl.gacc_tran_id
                      AND giop.or_flag = 'C'
                      AND (   giop.dcb_no = p_dcb_no
                           OR (    gcdl.due_dcb_no = p_dcb_no
                               AND TRUNC (gcdl.due_dcb_date) = v_dcb_date
                              )
                          )
                      AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                      AND giop.gibr_branch_cd = p_gibr_branch_cd
                      AND (   TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                           OR TRUNC (gcdl.due_dcb_date) = v_dcb_date
                          ))
         LOOP
            v_or_flag := a.or_flag;
         END LOOP;

         IF v_or_flag IS NULL
         THEN
            p_var_all_ors_r_cancelled := 'Y';
         ELSE
            p_var_all_ors_r_cancelled := 'N';
         END IF;
      END validate_giacs035_dcb_no;
   /* end of CHECK_IF_ALL_ORs_R_CANCELLED **/
   END validate_giacs035_dcb_no_1;

   PROCEDURE validate_giacs035_dcb_no_2 (
      p_gfun_fund_cd              IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd            IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_date                  IN       VARCHAR2,
      p_dcb_year                  IN       giac_acctrans.tran_year%TYPE,
      p_dcb_no                    IN       NUMBER,
      p_dsp_dcb_flag              IN OUT   VARCHAR2,
      p_mean_dcb_flag             IN OUT   VARCHAR2,
      p_var_all_ors_r_cancelled   IN       VARCHAR2,
      p_one_unprinted_or          OUT      VARCHAR2,
      p_one_open_or               OUT      VARCHAR2,
      p_no_collection_amt         OUT      VARCHAR2,
      p_one_manual_or             OUT      VARCHAR2
   )
   IS
      /*
      **  Created by   :  Emman
      **  Date Created :  04.01.2011
      **  Reference By : (GIACS035 - Close DCB)
      **  Description  : Validates the DCB_NO field (part 2)
      */
      v_dcb_date   DATE;
   BEGIN
      p_one_unprinted_or := 'N';
      p_one_open_or := 'N';
      p_no_collection_amt := 'N';
      p_one_manual_or := 'N';

      -- check first if search key is in date format. if yes, store it to v_dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      /** CHECK_IF_WITH_NEW_OR */
      BEGIN
         FOR c IN (SELECT '1'
                     FROM giac_order_of_payts giop
                    WHERE giop.or_flag = 'N'
                      AND giop.dcb_no = p_dcb_no
                      AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                      AND giop.gibr_branch_cd = p_gibr_branch_cd
                      AND TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR'))
         LOOP
            p_one_unprinted_or := 'Y';
            EXIT;
         END LOOP;

         IF p_one_unprinted_or = 'Y'
         THEN
            --msg_alert('There is at least one unprinted OR record ' || 'for this DCB No.', 'I', TRUE);
            RETURN;
         END IF;
      END;

      /** end of CHECK_IF_WITH_NEW_OR */
      IF giac_parameters_pkg.v ('DCB_CHECK_OPEN_TRAN') = 'Y'
      THEN
         /** CHECK_IF_WITH_OPEN_TRAN */
         BEGIN
            FOR c IN (SELECT '8'
                        FROM giac_order_of_payts a, giac_acctrans b
                       WHERE 1 = 1
                         AND a.gacc_tran_id = b.tran_id
                         AND a.dcb_no = p_dcb_no
                         AND a.gibr_gfun_fund_cd = p_gfun_fund_cd
                         AND a.gibr_branch_cd = p_gibr_branch_cd
                         AND TO_CHAR (a.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
                         AND b.tran_flag = 'O')
            LOOP
               p_one_open_or := 'Y';
               EXIT;
            END LOOP;

            IF p_one_open_or = 'Y'
            THEN
               --msg_alert('There is at least one OPEN OR transaction.  Please close the accounting entries before closing this DCB','W',TRUE);
               RETURN;
            END IF;
         END;
      /** end of CHECK_IF_WITH_OPEN_TRAN*/
      END IF;

      IF p_var_all_ors_r_cancelled = 'N'
      THEN
         giac_acctrans_pkg.get_dcb_flag (p_gfun_fund_cd,
                                         p_gibr_branch_cd,
                                         p_dcb_year,
                                         p_dcb_no,
                                         p_dsp_dcb_flag,
                                         p_mean_dcb_flag
                                        );
      END IF;

      /** CHECK_IF_GICD_EXISTS */
      DECLARE
         v_sum       NUMBER       := 0;
         v_col_dtl   VARCHAR2 (1) := 'N';

         -- cursor for all transactions must have collection detail
         CURSOR amt1
         IS
            SELECT NVL (SUM (gicd.amount), 0) sum_amt
              FROM giac_order_of_payts giop, giac_collection_dtl gicd
             WHERE gicd.gacc_tran_id = giop.gacc_tran_id
               AND giop.dcb_no = p_dcb_no
               AND TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
               AND TO_NUMBER (TO_CHAR (giop.or_date, 'RRRR')) = p_dcb_year
               AND giop.gibr_branch_cd = p_gibr_branch_cd
               AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
               AND (   (giop.or_flag = 'P')
                    OR (    giop.or_flag = 'C'
                        AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-RRRR'),
                                 '-') <> TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                       )
                    OR (    giop.or_flag = 'C'
                        AND giop.cancel_dcb_no <> p_dcb_no
                        AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-RRRR'),
                                 '-') = TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                       )
                   );

         -- cursor to check if all manual ORs have collection detail
         CURSOR amt2
         IS
            SELECT COUNT (1) cnt
              FROM giac_order_of_payts giop
             WHERE 1 = 1
               AND giop.or_tag = '*'                         -- for manula ORs
               AND giop.dcb_no = p_dcb_no
               AND TO_CHAR (giop.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
               AND TO_NUMBER (TO_CHAR (giop.or_date, 'YYYY')) = p_dcb_year
               AND giop.gibr_branch_cd = p_gibr_branch_cd
               AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
               AND (   (giop.or_flag = 'P')
                    OR (    giop.or_flag = 'C'
                        AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-YYYY'),
                                 '-') <> TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                       )
                    OR (    giop.or_flag = 'C'
                        AND giop.cancel_dcb_no <> p_dcb_no
                        AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-YYYY'),
                                 '-') = TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                       )
                   )
               AND NOT EXISTS (SELECT 'x'
                                 FROM giac_collection_dtl gicd
                                WHERE gicd.gacc_tran_id = giop.gacc_tran_id);
      BEGIN
         FOR e IN amt1
         LOOP
            v_sum := e.sum_amt;
            EXIT;
         END LOOP;

         IF v_sum = 0
         THEN
            SELECT NVL (SUM (gicd.amount), 0) sum_amt
              INTO v_sum
              FROM giac_collection_dtl gicd
             WHERE TO_CHAR (due_dcb_date, 'MM-DD-RRRR') =
                                            TO_CHAR (v_dcb_date, 'MM-DD-RRRR')
               AND due_dcb_no = p_dcb_no;

            IF v_sum = 0
            THEN
               --msg_alert('No collection amount was specified ' || 'for this DCB No.', 'I', TRUE);
               p_no_collection_amt := 'Y';
               RETURN;
            END IF;
         END IF;

         --| this for manual OR's that has no collection detail
         FOR rec IN amt2
         LOOP
            IF rec.cnt > 0
            THEN
               v_col_dtl := 'Y';
            END IF;
         END LOOP;

         IF v_col_dtl = 'Y'
         THEN
            --msg_alert('At least one Manual O.R. has no '||
            --           'collection amount specified for this '||
            --           'DCB No.','I',TRUE);
            p_one_manual_or := 'Y';
            RETURN;
         END IF;
      END;
   /** end of CHECK_IF_GICD_EXISTS */
   END validate_giacs035_dcb_no_2;

   /*
   **  Created by   :  Emman
     **  Date Created :  04.01.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Check records in collection breakdown if existing
     */
   FUNCTION check_bank_in_or (
      p_gfun_fund_cd     IN   giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN   giac_acctrans.gibr_branch_cd%TYPE,
      p_dcb_year         IN   giac_acctrans.tran_year%TYPE,
      p_dcb_no           IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'Y';
   BEGIN
      BEGIN
         SELECT DISTINCT 'Y'
                    INTO v_exist
                    FROM giac_collection_dtl a, giac_order_of_payts b
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND b.gibr_gfun_fund_cd = p_gfun_fund_cd
                     AND b.gibr_branch_cd = p_gibr_branch_cd
                     AND TO_CHAR (b.or_date, 'YYYY') = p_dcb_year
                     AND b.dcb_no = p_dcb_no
                     AND a.dcb_bank_cd IS NOT NULL
                     AND a.dcb_bank_acct_cd IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END check_bank_in_or;

   /*
   **  Created by   :  Emman
     **  Date Created :  04.06.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Executes the PRE-TEXT-ITEM trigger of GDBD.amount
   **                   set value for :gdbd.amount equal from :gicd_sum.dsp_amount
     */
   FUNCTION get_gdbd_amt_pre_text_val (
      p_dcb_date   VARCHAR2,
      p_dcb_no     NUMBER,
      p_pay_mode   giac_dcb_bank_dep.pay_mode%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE
   IS
      --CA
      v_amt        giac_collection_dtl.amount%TYPE;
      v1_amt       giac_dcb_bank_dep.amount%TYPE;
      v2_amt       giac_collection_dtl.amount%TYPE;
      v3_amt       giac_collection_dtl.amount%TYPE;
      --CHK
      vc_amt       giac_collection_dtl.amount%TYPE;
      vc1_amt      giac_dcb_bank_dep.amount%TYPE;
      vc2_amt      giac_collection_dtl.amount%TYPE;
      vc3_amt      giac_collection_dtl.amount%TYPE;
      --CM
      vm_amt       giac_collection_dtl.amount%TYPE;
      vm1_amt      giac_dcb_bank_dep.amount%TYPE;
      vm2_amt      giac_collection_dtl.amount%TYPE;
      vm3_amt      giac_collection_dtl.amount%TYPE;
      --PDC
      vp_amt       giac_collection_dtl.amount%TYPE;
      vp1_amt      giac_dcb_bank_dep.amount%TYPE;
      vp2_amt      giac_collection_dtl.amount%TYPE;
      vp3_amt      giac_collection_dtl.amount%TYPE;
      v_gdbd_amt   giac_dcb_bank_dep.amount%TYPE     := NULL;
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

      IF p_pay_mode = 'CA'
      THEN
         FOR a IN (SELECT NVL (SUM (amount), 0) amount
                     FROM giac_collection_dtl
                    WHERE 1 = 1
                      AND TRUNC (due_dcb_date) = TRUNC (v_dcb_date)
                      AND due_dcb_no = p_dcb_no
                      AND pay_mode = 'CA')
         LOOP
            v_amt := a.amount;
         END LOOP;

         FOR a1 IN (SELECT NVL (SUM (amount), 0) amount
                      FROM giac_dcb_bank_dep
                     WHERE 1 = 1
                       AND dcb_no = p_dcb_no
                       AND TRUNC (dcb_date) = TRUNC (v_dcb_date)
                       AND pay_mode = 'CA')
         LOOP
            v1_amt := a1.amount;
            v2_amt := v_amt - v1_amt;
            v3_amt := v1_amt + v2_amt;
            v_gdbd_amt := v2_amt;
         END LOOP;
      ELSIF p_pay_mode = 'CHK'
      THEN
         FOR c IN (SELECT NVL (SUM (amount), 0) amount
                     FROM giac_collection_dtl
                    WHERE 1 = 1
                      AND TRUNC (due_dcb_date) = TRUNC (v_dcb_date)
                      AND due_dcb_no = p_dcb_no
                      AND pay_mode = 'CHK')
         LOOP
            vc_amt := c.amount;
         END LOOP;

         FOR c1 IN (SELECT NVL (SUM (amount), 0) amount
                      FROM giac_dcb_bank_dep
                     WHERE 1 = 1
                       AND dcb_no = p_dcb_no
                       AND TRUNC (dcb_date) = TRUNC (v_dcb_date)
                       AND pay_mode = 'CHK')
         LOOP
            vc1_amt := c1.amount;
            vc2_amt := vc_amt - vc1_amt;
            vc3_amt := vc1_amt + vc2_amt;
            v_gdbd_amt := vc2_amt;
         END LOOP;
      ELSIF p_pay_mode = 'CM'
      THEN
         FOR d IN (SELECT NVL (SUM (amount), 0) amount
                     FROM giac_collection_dtl
                    WHERE 1 = 1
                      AND TRUNC (due_dcb_date) = TRUNC (v_dcb_date)
                      AND due_dcb_no = p_dcb_no
                      AND pay_mode = 'CM')
         LOOP
            vm_amt := d.amount;
         END LOOP;

         FOR d1 IN (SELECT NVL (SUM (amount), 0) amount
                      FROM giac_dcb_bank_dep
                     WHERE 1 = 1
                       AND dcb_no = p_dcb_no
                       AND TRUNC (dcb_date) = TRUNC (v_dcb_date)
                       AND pay_mode = 'CM')
         LOOP
            vm1_amt := d1.amount;
            vm2_amt := vm_amt - vm1_amt;
            vm3_amt := vm1_amt + vm2_amt;
            v_gdbd_amt := vm2_amt;
         END LOOP;
      ELSIF p_pay_mode = 'PDC'
      THEN
         FOR e IN (SELECT NVL (SUM (amount), 0) amount
                     FROM giac_collection_dtl
                    WHERE 1 = 1
                      AND TRUNC (due_dcb_date) = TRUNC (v_dcb_date)
                      AND due_dcb_no = p_dcb_no
                      AND pay_mode = 'PDC')
         LOOP
            vp_amt := e.amount;
         END LOOP;

         FOR e1 IN (SELECT NVL (SUM (amount), 0) amount
                      FROM giac_dcb_bank_dep
                     WHERE 1 = 1
                       AND dcb_no = p_dcb_no
                       AND TRUNC (dcb_date) = TRUNC (v_dcb_date)
                       AND pay_mode = 'PDC')
         LOOP
            vp1_amt := e1.amount;
            vp2_amt := vp_amt - vp1_amt;
            vp3_amt := vp1_amt + vp2_amt;
            v_gdbd_amt := vp2_amt;
         END LOOP;
      END IF;

      RETURN v_gdbd_amt;
   END get_gdbd_amt_pre_text_val;

   /*
   **  Created by   :  Emman
     **  Date Created :  04.07.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Executes the WHEN_VALIDATE_ITEM trigger of GDBD.amount
   **                   and gets the value for :gdbd.amount equal to computed sum_amt
     */
   FUNCTION get_gdbd_amt_when_validate (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_dcb_year         NUMBER,
      p_pay_mode         giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd      giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt      giac_dcb_bank_dep.currency_rt%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE
   IS
      v_tot_amt_for_gicd_sum_rec   giac_dcb_bank_dep.amount%TYPE;
      v_dcb_date                   DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      FOR i IN (SELECT NVL (SUM (gicd.amount), 0) sum_amount
                  FROM giac_order_of_payts giop, giac_collection_dtl gicd
                 WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                   AND giop.dcb_no = p_dcb_no
                   AND TRUNC (giop.or_date) = TRUNC (v_dcb_date)
                   AND TO_NUMBER (TO_CHAR (giop.or_date, 'YYYY')) = p_dcb_year
                   AND giop.gibr_branch_cd = p_gibr_branch_cd
                   AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                   AND (   (giop.or_flag = 'P')
                        OR (    giop.or_flag = 'C'
                            AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-YYYY'),
                                     '-'
                                    ) <> TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                           )
                       )
                   AND gicd.pay_mode = p_pay_mode
                   AND gicd.currency_cd = p_currency_cd
                   AND gicd.currency_rt = p_currency_rt)
      LOOP
         v_tot_amt_for_gicd_sum_rec := i.sum_amount;
      END LOOP;

      RETURN v_tot_amt_for_gicd_sum_rec;
   END get_gdbd_amt_when_validate;

   /*
   **  Created by   :  Emman
     **  Date Created :  04.07.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Executes the WHEN_VALIDATE_ITEM trigger of GDBD.dsp_curr_sname
   **                   and gets the computed gicd_sum_rec
     */
   FUNCTION get_curr_sname_gicd_sum_rec (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_acctrans.tran_class_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_dcb_year         NUMBER,
      p_pay_mode         giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd      giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt      giac_dcb_bank_dep.currency_rt%TYPE
   )
      RETURN giac_dcb_bank_dep.amount%TYPE
   IS
      v_tot_amt_for_gicd_sum_rec   giac_dcb_bank_dep.amount%TYPE;
      v_dcb_date                   DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      FOR i IN (SELECT NVL (SUM (gicd.amount), 0) sum_amount
                  FROM giac_order_of_payts giop, giac_collection_dtl gicd
                 WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                   AND (   (    giop.dcb_no = p_dcb_no
                            AND NVL (with_pdc, 'N') <> 'Y'
                           )
                        OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y')
                       )
                   AND (   (    TRUNC (giop.or_date) = TRUNC (v_dcb_date)
                            AND NVL (with_pdc, 'N') <> 'Y'
                           )
                        OR (    TRUNC (gicd.due_dcb_date) = TRUNC (v_dcb_date)
                            AND with_pdc = 'Y'
                           )
                       )
                   AND giop.gibr_branch_cd = p_gibr_branch_cd
                   AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                   AND (   (giop.or_flag = 'P')
                        OR (    giop.or_flag = 'C'
                            AND NVL (TO_CHAR (giop.cancel_date, 'MM-DD-YYYY'),
                                     '-'
                                    ) <> TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                           )
                       )
                   AND gicd.pay_mode = p_pay_mode
                   AND NVL (gicd.currency_cd, gicd.currency_cd) =
                                                                 p_currency_cd
                   AND gicd.currency_rt = p_currency_rt)
      LOOP
         v_tot_amt_for_gicd_sum_rec := i.sum_amount;
      END LOOP;

      RETURN v_tot_amt_for_gicd_sum_rec;
   END get_curr_sname_gicd_sum_rec;

   /*
   **  Created by   :  Emman
     **  Date Created :  04.08.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Executes the WHEN_VALIDATE_ITEM trigger of GDBD.foreign_curr_amt
   **                   and gets the computed gicd_sum_rec for local and foreign currency amt
     */
   PROCEDURE get_tot_fc_amt_gicd_sum_rec (
      p_gibr_branch_cd                IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd                  IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no                        IN       giac_acctrans.tran_class_no%TYPE,
      p_dcb_date                      IN       VARCHAR2,
      p_dcb_year                      IN       NUMBER,
      p_pay_mode                      IN       giac_dcb_bank_dep.pay_mode%TYPE,
      p_currency_cd                   IN       giac_dcb_bank_dep.currency_cd%TYPE,
      p_currency_rt                   IN       giac_dcb_bank_dep.currency_rt%TYPE,
      p_tot_amt_for_gicd_sum_rec      IN OUT   giac_dcb_bank_dep.amount%TYPE,
      p_tot_fc_amt_for_gicd_sum_rec   IN OUT   giac_dcb_bank_dep.amount%TYPE
   )
   IS
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

      FOR i IN (SELECT   NVL (SUM (gicd.amount), 0) sum_amount,
                         NVL (SUM (gicd.fcurrency_amt), 0) fc_sum_amt
                    FROM giac_order_of_payts giop, giac_collection_dtl gicd
                   WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                     AND giop.dcb_no = p_dcb_no
                     AND TRUNC (giop.or_date) = p_dcb_date
                     AND TO_NUMBER (TO_CHAR (giop.or_date, 'YYYY')) =
                                                                    p_dcb_year
                     AND giop.gibr_branch_cd = p_gibr_branch_cd
                     AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd
                     AND (   (giop.or_flag = 'P')
                          OR (    giop.or_flag = 'C'
                              AND NVL (TO_CHAR (giop.cancel_date,
                                                'MM-DD-YYYY'),
                                       '-'
                                      ) <>
                                          TO_CHAR (giop.or_date, 'MM-DD-YYYY')
                             )
                         )
                     AND gicd.pay_mode = p_pay_mode
                     AND gicd.currency_cd = p_currency_cd
                     AND gicd.currency_rt = p_currency_rt
                GROUP BY gicd.amount)
      LOOP
         p_tot_amt_for_gicd_sum_rec := i.sum_amount;
         p_tot_fc_amt_for_gicd_sum_rec := i.fc_sum_amt;
      END LOOP;
   END get_tot_fc_amt_gicd_sum_rec;

   /*
   **  Created by   :  Emman
     **  Date Created :  05.05.2011
     **  Reference By : (GIACS035 - Close DCB)
     **  Description  : Calls LOV for GBDSD block
     */
   FUNCTION get_giacs035_gbdsd_lov (
      p_dcb_no      giac_dcb_bank_dep.dcb_no%TYPE,
      p_dcb_date    VARCHAR2,
      p_branch_cd   giac_dcb_bank_dep.branch_cd%TYPE,
      p_pay_mode    giac_dcb_bank_dep.pay_mode%TYPE
   )
      RETURN gbdsd_lov_tab PIPELINED
   IS
      v_gbdsd_lov   gbdsd_lov_type;
      v_dcb_date    giac_dcb_bank_dep.dcb_date%TYPE;
   BEGIN
      -- convert dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;

      IF p_pay_mode = 'CHK'
      THEN
         FOR i IN (SELECT a.gacc_tran_id, a.payor, a.or_no, a.or_pref_suf,
                          a.dcb_no, b.check_no, b.item_no, b.amount,
                          b.fcurrency_amt, b.currency_rt, b.bank_cd,
                          c.bank_sname, d.short_name, d.main_currency_cd,
                          c.bank_sname || ' - ' || b.check_no dsp_check_no,
                          a.or_pref_suf || ' - ' || a.or_no dsp_or_pref_suf
                     FROM giac_order_of_payts a,
                          giac_collection_dtl b,
                          giac_banks c,
                          giis_currency d
                    WHERE a.gacc_tran_id = b.gacc_tran_id
                      AND b.bank_cd = c.bank_cd
                      AND b.currency_cd = d.main_currency_cd
                      AND (a.dcb_no = p_dcb_no OR b.due_dcb_no = p_dcb_no)
                      AND NVL (b.due_dcb_date, TRUNC (a.or_date)) = v_dcb_date
                      AND a.gibr_branch_cd = p_branch_cd
                      AND (   (a.or_flag = 'P')
                           OR (    a.or_flag = 'C'
                               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'),
                                        '-'
                                       ) <> TO_CHAR (a.or_date, 'MM-DD-YYYY')
                              )
                           OR (    a.or_flag = 'C'
                               AND a.cancel_dcb_no <> p_dcb_no
                               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'),
                                        '-'
                                       ) = TO_CHAR (a.or_date, 'MM-DD-YYYY')
                              )
                          )
                      AND b.pay_mode = 'CHK'
                      AND b.check_no NOT IN (
                             SELECT e.check_no
                               FROM giac_bank_dep_slip_dtl e
                              WHERE a.payor = e.payor
                                AND a.or_no = e.or_no
                                AND a.or_pref_suf = e.or_pref
                                AND b.bank_cd = e.bank_cd
                                AND b.amount = e.amount
                                AND b.fcurrency_amt = e.foreign_curr_amt
                                AND d.main_currency_cd = e.currency_cd))
         LOOP
            v_gbdsd_lov.gacc_tran_id := i.gacc_tran_id;
            v_gbdsd_lov.payor := i.payor;
            v_gbdsd_lov.or_no := i.or_no;
            v_gbdsd_lov.or_pref_suf := i.or_pref_suf;
            v_gbdsd_lov.dcb_no := i.dcb_no;
            v_gbdsd_lov.check_no := i.check_no;
            v_gbdsd_lov.item_no := i.item_no;
            v_gbdsd_lov.amount := i.amount;
            v_gbdsd_lov.fcurrency_amt := i.fcurrency_amt;
            v_gbdsd_lov.currency_rt := i.currency_rt;
            v_gbdsd_lov.bank_cd := i.bank_cd;
            v_gbdsd_lov.bank_sname := i.bank_sname;
            v_gbdsd_lov.short_name := i.short_name;
            v_gbdsd_lov.main_currency_cd := i.main_currency_cd;
            v_gbdsd_lov.dsp_check_no := i.dsp_check_no;
            v_gbdsd_lov.dsp_or_pref_suf := i.dsp_or_pref_suf;
            PIPE ROW (v_gbdsd_lov);
         END LOOP;
      ELSIF p_pay_mode = 'PDC'
      THEN
         FOR i IN (SELECT a.gacc_tran_id, a.payor, a.or_no, a.or_pref_suf,
                          a.dcb_no, b.check_no, b.item_no, b.amount,
                          b.fcurrency_amt, b.currency_rt, b.bank_cd,
                          c.bank_sname, d.short_name, d.main_currency_cd,
                          c.bank_sname || ' - ' || b.check_no dsp_check_no,
                          a.or_pref_suf || ' - ' || a.or_no dsp_or_pref_suf
                     FROM giac_order_of_payts a,
                          giac_collection_dtl b,
                          giac_banks c,
                          giis_currency d
                    WHERE a.gacc_tran_id = b.gacc_tran_id
                      AND b.bank_cd = c.bank_cd
                      AND b.currency_cd = d.main_currency_cd
                      AND (a.dcb_no = p_dcb_no OR b.due_dcb_no = p_dcb_no)
                      AND b.due_dcb_date = v_dcb_date
                      AND a.gibr_branch_cd = p_branch_cd
                      AND (   (a.or_flag = 'P')
                           OR (    a.or_flag = 'C'
                               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'),
                                        '-'
                                       ) <> TO_CHAR (a.or_date, 'MM-DD-YYYY')
                              )
                           OR (    a.or_flag = 'C'
                               AND a.cancel_dcb_no <> p_dcb_no
                               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'),
                                        '-'
                                       ) = TO_CHAR (a.or_date, 'MM-DD-YYYY')
                              )
                          )
                      AND b.pay_mode = 'PDC'
                      AND b.check_no NOT IN (
                             SELECT e.check_no
                               FROM giac_bank_dep_slip_dtl e
                              WHERE a.payor = e.payor
                                AND a.or_no = e.or_no
                                AND a.or_pref_suf = e.or_pref
                                AND b.bank_cd = e.bank_cd
                                AND b.amount = e.amount
                                AND b.fcurrency_amt = e.foreign_curr_amt
                                AND d.main_currency_cd = e.currency_cd))
         LOOP
            v_gbdsd_lov.gacc_tran_id := i.gacc_tran_id;
            v_gbdsd_lov.payor := i.payor;
            v_gbdsd_lov.or_no := i.or_no;
            v_gbdsd_lov.or_pref_suf := i.or_pref_suf;
            v_gbdsd_lov.dcb_no := i.dcb_no;
            v_gbdsd_lov.check_no := i.check_no;
            v_gbdsd_lov.item_no := i.item_no;
            v_gbdsd_lov.amount := i.amount;
            v_gbdsd_lov.fcurrency_amt := i.fcurrency_amt;
            v_gbdsd_lov.currency_rt := i.currency_rt;
            v_gbdsd_lov.bank_cd := i.bank_cd;
            v_gbdsd_lov.bank_sname := i.bank_sname;
            v_gbdsd_lov.short_name := i.short_name;
            v_gbdsd_lov.main_currency_cd := i.main_currency_cd;
            v_gbdsd_lov.dsp_check_no := i.dsp_check_no;
            v_gbdsd_lov.dsp_or_pref_suf := i.dsp_or_pref_suf;
            PIPE ROW (v_gbdsd_lov);
         END LOOP;
      END IF;
   END get_giacs035_gbdsd_lov;

   PROCEDURE set_giac_acctrans (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date        giac_acctrans.tran_date%TYPE,
      p_tran_flag        giac_acctrans.tran_flag%TYPE,
      p_tran_class       giac_acctrans.tran_class%TYPE,
      p_tran_class_no    giac_acctrans.tran_class_no%TYPE,
      p_particulars      giac_acctrans.particulars%TYPE,
      p_tran_year        giac_acctrans.tran_year%TYPE,
      p_tran_month       giac_acctrans.tran_month%TYPE,
      p_tran_seq_no      giac_acctrans.tran_seq_no%TYPE,
      p_user_id          giac_acctrans.user_id%TYPE,
      p_last_update      giac_acctrans.last_update%TYPE
   )
   IS
   BEGIN
      MERGE INTO giac_acctrans
         USING DUAL
         ON (tran_id = p_tran_id)
         WHEN NOT MATCHED THEN
            INSERT (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                    tran_flag, tran_class, tran_class_no, particulars,
                    tran_year, tran_month, tran_seq_no, user_id, last_update)
            VALUES (p_tran_id, p_gfun_fund_cd, p_gibr_branch_cd, p_tran_date,
                    p_tran_flag, p_tran_class, p_tran_class_no,
                    p_particulars, p_tran_year, p_tran_month, p_tran_seq_no,
                    p_user_id, p_last_update)
         WHEN MATCHED THEN
            UPDATE
               SET gfun_fund_cd = p_gfun_fund_cd,
                   gibr_branch_cd = p_gibr_branch_cd,
                   tran_date = p_tran_date, tran_flag = p_tran_flag,
                   tran_class = p_tran_class,
                   tran_class_no = p_tran_class_no,
                   particulars = p_particulars, tran_year = p_tran_year,
                   tran_month = p_tran_month, tran_seq_no = p_tran_seq_no,
                   user_id = p_user_id, last_update = p_last_update
            ;
   END set_giac_acctrans;

   PROCEDURE del_giac_acctrans (p_tran_id giac_acctrans.tran_id%TYPE)
   IS
   BEGIN
      DELETE FROM giac_acctrans
            WHERE tran_id = p_tran_id;
   END del_giac_acctrans;

   /*
   ** Created By: D.Alcantara, 05/13/2011
   **
   */
   PROCEDURE set_acctrans_dcb_closing (
      p_tran_id         IN OUT   giac_acctrans.tran_id%TYPE,
      p_fund_cd         IN OUT   giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd       IN OUT   giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_year       IN OUT   giac_acctrans.tran_year%TYPE,
      p_tran_month      IN       giac_acctrans.tran_month%TYPE,
      p_tran_class_no   IN       giac_acctrans.tran_class_no%TYPE,
      p_particulars     IN       giac_acctrans.particulars%TYPE,
      p_tran_flag       IN OUT   giac_acctrans.tran_flag%TYPE,
      p_tran_class      IN       giac_acctrans.tran_class%TYPE,
      p_user_id         IN       giac_acctrans.user_id%TYPE,
      p_tran_date       IN OUT   VARCHAR2,
      p_mesg            OUT      VARCHAR2
   )
   IS
      v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
      v_tran_id       giac_acctrans.tran_id%TYPE;
   BEGIN
      p_mesg := 'Y';
      v_tran_id := p_tran_id;
      p_tran_date := TO_CHAR (SYSDATE, 'MM-DD-RRRR'); --Deo [09.01.2016]: tran_date should be sysdate (SR-5631)

      --Deo [03.03.2017]: add start (SR-5939)
      IF p_tran_id < 1
      THEN
         p_mesg :=
            check_dcb_flag (p_fund_cd,
                            p_branch_cd,
                            p_tran_year,
                            p_tran_class_no,
                            'S'
                           );
      END IF;   
      --Deo [03.03.2017]: add ends (SR-5939)
      
      IF p_tran_id < 1
         AND p_mesg = 'Y'  --Deo [03.03.2017]: SR-5939
      THEN
         BEGIN
            SELECT acctran_tran_id_s.NEXTVAL
              INTO p_tran_id
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_mesg := 'acctran_tran_id_s sequence not found.';
         END;
      END IF;

      IF p_mesg = 'Y'
      THEN
         IF v_tran_id < 1
         THEN
            v_tran_seq_no :=
               giac_sequence_generation (p_fund_cd,
                                         p_branch_cd,
                                         'ACCTRAN_TRAN_SEQ_NO',
                                         p_tran_year,
                                         p_tran_month
                                        );
         END IF;

         MERGE INTO giac_acctrans
            USING DUAL
            ON (tran_id = p_tran_id)
            WHEN NOT MATCHED THEN
               INSERT (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                       tran_flag, tran_class, tran_class_no, particulars,
                       tran_year, tran_month, tran_seq_no, user_id,
                       last_update)
               VALUES (p_tran_id, p_fund_cd, p_branch_cd,
                       TO_DATE (p_tran_date, 'MM-DD-RRRR'), p_tran_flag,
                       p_tran_class, p_tran_class_no, p_particulars,
                       p_tran_year, p_tran_month, v_tran_seq_no,
                       NVL (p_user_id, USER), SYSDATE)
            WHEN MATCHED THEN
               UPDATE
                  SET tran_flag = p_tran_flag, tran_class = p_tran_class,
                      tran_class_no = p_tran_class_no,
                      particulars = p_particulars, tran_year = p_tran_year,
                      tran_month = p_tran_month,
                      user_id = NVL (p_user_id, USER), last_update = SYSDATE
               ;
      END IF;
   END set_acctrans_dcb_closing;

   /*
   ** Created By: D.Alcantara, 05/20/2011
   **
   */
   FUNCTION get_giac_acctrans2 (
      p_tran_id          giac_acctrans.tran_id%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE
   )
      RETURN giac_acctrans_tab PIPELINED
   IS
      v_giac_acctrans   giac_acctrans_type;
   BEGIN
      FOR i IN (SELECT 1 ROWCOUNT, a.tran_id, a.gfun_fund_cd,
                       a.gibr_branch_cd, a.tran_date, a.tran_flag,
                       a.tran_class, a.tran_class_no, a.particulars,
                       a.tran_year, a.tran_month, a.tran_seq_no
                  FROM giac_acctrans a
                 WHERE tran_id = p_tran_id
                   AND gfun_fund_cd = p_gfun_fund_cd
                   AND gibr_branch_cd = p_gibr_branch_cd)
      LOOP
         v_giac_acctrans.tran_id := i.tran_id;
         v_giac_acctrans.gfun_fund_cd := i.gfun_fund_cd;
         v_giac_acctrans.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_acctrans.tran_date := i.tran_date;
         v_giac_acctrans.tran_flag := i.tran_flag;
         v_giac_acctrans.tran_class := i.tran_class;
         v_giac_acctrans.tran_class_no := i.tran_class_no;
         v_giac_acctrans.particulars := i.particulars;
         v_giac_acctrans.tran_year := i.tran_year;
         v_giac_acctrans.tran_month := i.tran_month;
         v_giac_acctrans.tran_seq_no := i.tran_seq_no;
         PIPE ROW (v_giac_acctrans);
      END LOOP;
   END get_giac_acctrans2;

   FUNCTION get_giacs086_acct_trans (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_branch_cd     giac_acctrans.gibr_branch_cd%TYPE,
      p_ref_no        VARCHAR,
      p_particulars   giac_acctrans.particulars%TYPE
   )
      RETURN giacs086_acct_trans_tab PIPELINED
   IS
      v_acct_trans   giacs086_acct_trans_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT c.batch_dv_id, c.tran_id, a.branch_cd,
                                           a.document_cd
                                        || '-'
                                        || a.branch_cd
                                        || '-'
                                        || TO_CHAR (a.doc_year)
                                        || '-'
                                        || TO_CHAR (a.doc_mm)
                                        || '-'
                                        || LPAD (TO_CHAR (a.doc_seq_no),
                                                 6,
                                                 '0'
                                                ) ref_no,
                                        b.particulars
                                   FROM giac_payt_requests a,
                                        giac_payt_requests_dtl b,
                                        giac_batch_dv c
                                  WHERE a.ref_id = b.gprq_ref_id
                                    AND b.tran_id = c.tran_id
                        UNION
                        SELECT DISTINCT b.batch_dv_id, b.jv_tran_id tran_id,
                                        a.gibr_branch_cd branch_cd,
                                           a.tran_class
                                        || '-'
                                        || a.gibr_branch_cd
                                        || '-'
                                        || TO_CHAR (a.tran_year)
                                        || '-'
                                        || TO_CHAR (a.tran_month)
                                        || '-'
                                        || LPAD (TO_CHAR (a.tran_seq_no),
                                                 6,
                                                 '0'
                                                ) ref_no,
                                        a.particulars
                                   FROM giac_acctrans a, giac_batch_dv_dtl b
                                  WHERE a.tran_id = b.jv_tran_id)
                 WHERE batch_dv_id = p_batch_dv_id
                   AND UPPER (branch_cd) LIKE
                                          UPPER (NVL (p_branch_cd, branch_cd))
                   AND UPPER (particulars) LIKE
                                      UPPER (NVL (p_particulars, particulars)))
      LOOP
         v_acct_trans.batch_dv_id := i.batch_dv_id;
         v_acct_trans.tran_id := i.tran_id;
         v_acct_trans.branch_cd := i.branch_cd;
         v_acct_trans.ref_no := i.ref_no;
         v_acct_trans.particulars := escape_value (i.particulars);
         PIPE ROW (v_acct_trans);
      END LOOP;
   END;
   
    /*
   ** Created By: D.Alcantara, 05/20/2011
   **  Date Created : 12.29.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   */
   FUNCTION get_tran_flag2 (
      p_acct_tran_id    GIAC_ACCTRANS.tran_id%TYPE
   ) RETURN VARCHAR2 IS
      v_tran_flag       GIAC_ACCTRANS.tran_flag%TYPE;
   BEGIN
      BEGIN
        SELECT tran_flag
          INTO v_tran_flag
          FROM giac_acctrans
         WHERE tran_id = p_acct_tran_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_tran_flag := NULL;
      END;
      
      RETURN v_tran_flag;
   END;

    /*
   ** Created By: D.Alcantara, 05/20/2011
   **  Date Created : 12.29.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   */   
   PROCEDURE update_tran_flag (
      p_tran_id    GIAC_ACCTRANS.tran_id%TYPE,
      p_tran_flag  GIAC_ACCTRANS.tran_flag%TYPE
   ) IS
   BEGIN
      UPDATE giac_acctrans
         SET tran_flag = p_tran_flag
       WHERE tran_id = p_tran_id;
   END update_tran_flag;
   
   /*
   ** Created By: D.Alcantara, 05/20/2011
   **  Date Created : 12.29.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   */ 
   PROCEDURE insert_into_acctrans_gicls055(
        p_fund_cd    IN  giac_acctrans.gfun_fund_cd%TYPE,
        p_branch_cd  IN  giac_acctrans.gibr_branch_cd%TYPE,
        p_user_id    IN  giis_users.user_id%TYPE,
        p_tran_id     OUT giac_acctrans.tran_id%TYPE,
        p_message    OUT VARCHAR2) IS

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

   BEGIN
      --p_message := 'SUCCESS';
      OPEN fund;
      FETCH fund INTO v_fund;
        IF fund%NOTFOUND THEN  
          p_message := 'Fund code is not found in GIIS_FUNDS.';
        ELSE
          OPEN branch;
          FETCH branch INTO v_branch;
            IF branch%NOTFOUND THEN
              p_message := 'Branch code is not found in GIAC_BRANCHES.';
            END IF;
          CLOSE branch;
        END IF;
      CLOSE fund;


      BEGIN
        SELECT acctran_tran_id_s.nextval
          INTO p_tran_id
          FROM dual;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN           
          p_message := 'ACCTRAN_TRAN_ID sequence not found.';
      END;
      
      v_tran_seq_no := giac_sequence_generation(p_fund_cd,
                                                p_branch_cd,
                                                'ACCTRAN_TRAN_SEQ_NO',
                            TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')),
                            TO_NUMBER(TO_CHAR(SYSDATE,'mm')));
      INSERT INTO giac_acctrans(tran_id,   gfun_fund_cd, gibr_branch_cd, 
                                tran_date, tran_flag,    tran_class,
                                tran_year, tran_month,   tran_seq_no,
                                user_id, last_update)
                         VALUES(p_tran_id, p_fund_cd, p_branch_cd, 
                                SYSDATE,          'C',       'LR',
                                TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 
                                TO_NUMBER(TO_CHAR(SYSDATE, 'MM')), 
                                v_tran_seq_no,             
                                nvl(p_user_id, USER), SYSDATE);
   END insert_into_acctrans_gicls055;
   
   /*
   **  Created By   : Robert Virrey
   **  Date Created : 01.17.2012
   **  Reference By : (GICLB001 - Batch O/S Takeup)
   */
   PROCEDURE insert_into_acctrans_giclb001(
      p_fund_cd    IN  giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd  IN  giac_acctrans.gibr_branch_cd%TYPE,
      p_dsp_date   IN  giac_acctrans.tran_date%TYPE,
      p_user_id    IN  giac_acctrans.user_id%TYPE,
      p_tran_id   OUT  giac_acctrans.tran_id%TYPE
    ) 
    IS

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

    BEGIN
      OPEN fund;
      FETCH fund INTO v_fund;
        IF fund%NOTFOUND THEN
          --lapse;               
          --msg_alert('Fund code is not found in GIIS_FUNDS.', 'I', TRUE);
          raise_application_error('-20001', 'Fund code is not found in GIIS_FUNDS.');
        ELSE
          OPEN branch;
          FETCH branch INTO v_branch;
            IF branch%NOTFOUND THEN
              --lapse;               
              --msg_alert('Branch code is not found in GIAC_BRANCHES.', 'I', TRUE);
              raise_application_error('-20001', 'Branch code is not found in GIAC_BRANCHES.');
            END IF;
          CLOSE branch;
        END IF;
      CLOSE fund;

      BEGIN
        SELECT acctran_tran_id_s.nextval
          INTO p_tran_id
          FROM dual;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          --lapse;               
          --msg_alert('ACCTRAN_TRAN_ID sequence not found.','E', TRUE);
          raise_application_error('-20001', 'ACCTRAN_TRAN_ID sequence not found.');
      END;
      
      v_tran_seq_no := giac_sequence_generation(p_fund_cd,
                                                p_branch_cd,
                                                'ACCTRAN_TRAN_SEQ_NO',
                                                to_number(to_char(p_dsp_date,'YYYY')),
                                                to_number(to_char(p_dsp_date,'MM')));
      INSERT INTO giac_acctrans(
        tran_id,          gfun_fund_cd,  gibr_branch_cd,  
        tran_date,        tran_flag,     tran_class,
        tran_seq_no,      user_id,       last_update,
        tran_year,        
        tran_month, 
        particulars)  --added by AlizaG. SR 5235
      VALUES(
        p_tran_id,        p_fund_cd,     p_branch_cd, 
        p_dsp_date,       'C',           'OL',
        v_tran_seq_no,    p_user_id,     SYSDATE,
        to_number(to_char(p_dsp_date,'YYYY')),
        to_number(to_char(p_dsp_date,'MM')),
        'Outstanding Losses Take-up for ' ||to_char(p_dsp_date,'fmMonth')||' '||to_char(p_dsp_date,'RRRR') --added by AlizaG. SR 5235
        );
    END insert_into_acctrans_giclb001;
    
   /*
   **  Created By   : Robert Virrey
   **  Date Created : 01.24.2012
   **  Reference By : (GICLB001 - Batch O/S Takeup)
   */ 
   FUNCTION get_tran_ids_for_printing (p_dsp_date     DATE)
   RETURN giac_acctrans_tab PIPELINED
   IS
      v_giac_acctrans   giac_acctrans_type;
   BEGIN
      FOR i IN ( SELECT max(tran_id) tran_id, gibr_branch_cd 
                   FROM giac_acctrans a
                  WHERE tran_year = to_number(to_char(p_dsp_date,'YYYY'))
                    AND tran_month = to_number(to_char(p_dsp_date,'MM'))
                    AND tran_class = 'OL'
                    AND tran_id IN (SELECT tran_id
                       FROM giac_acct_entries b, giac_chart_of_accts c
                      WHERE b.gacc_tran_id = a.tran_id AND b.gl_acct_id = c.gl_acct_id
                     HAVING SUM (b.debit_amt) > 0 OR SUM (b.credit_amt) > 0)
               GROUP BY gibr_branch_cd)
      LOOP
         v_giac_acctrans.tran_id        := i.tran_id;
         v_giac_acctrans.gibr_branch_cd := i.gibr_branch_cd;
         PIPE ROW (v_giac_acctrans);
      END LOOP;
   END get_tran_ids_for_printing;
   
   
   /*
   ** Created By: Marie Kris Felipe
   **  Date Created : 04.18.2013
   **  Reference By : (GIACS002 - Generate Disbursement Voucher)
   */ 
   PROCEDURE update_acctrans_giacs002(
        p_dv_date           giac_acctrans.tran_date%TYPE,
        p_dv_no             giac_acctrans.tran_class_no%TYPE,
        p_gacc_tran_id      giac_acctrans.tran_id%TYPE
   )
   IS   
   BEGIN
        UPDATE giac_acctrans
           SET tran_date = p_dv_date,
               tran_class_no = p_dv_no
         WHERE tran_id = p_gacc_tran_id;
         
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#imgMessage.ERROR#Unable to update giac_acctrans at post-insert gidv.');
        END IF;
   END update_acctrans_giacs002;
   
   /*
   ** Created By: Lara Beltran
   **  Date Created : 01.16.2014
   **  Reference By : (GICLS055 - Generate Accounting Entries)
   */ 
   FUNCTION get_gicls055_tran_dtl(
        p_acc_tran_id GIAC_ACCTRANS.tran_id%TYPE
   )RETURN gicls055_tran_dtl_tab PIPELINED
   IS
        v_acctrans gicls055_tran_dtl_type;

   BEGIN
        FOR a IN (SELECT gibr_branch_cd||'-'||tran_year||'-'|| tran_month||'-'|| tran_seq_no tran_no, tran_date
                  FROM giac_acctrans
                  WHERE tran_id = p_acc_tran_id)
        LOOP
            v_acctrans.tran_no := a.tran_no;
            v_acctrans.tran_date := a.tran_date;
            PIPE ROW (v_acctrans);
            EXIT;
        END LOOP;

   END get_gicls055_tran_dtl;
   
   FUNCTION get_dcb_list2 ( -- SR#18447; John Dolon; 05.25.2015
      p_branch_name   giac_branches.branch_name%TYPE,
      p_tran_date     VARCHAR2,
      p_dcb_no        VARCHAR2,
      p_dcb_flag      VARCHAR2,
      p_user_id       VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN dcb_list_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   dcb_list_type;
      v_sql   VARCHAR2(9000);
      
      v_date_search   DATE;
   BEGIN
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM ( SELECT gacc.tran_id, gacc.gibr_branch_cd, gacc.gfun_fund_cd,
                                       gibr.branch_name dsp_branch_name, /*gacc*/gcob.tran_date, /*Deo [09.01.2016]: replace gacc with gcob (SR-5631)*/
                                       gacc.tran_year || ''-'' || gacc.tran_class_no dcb_no, dcb_flag, rv_meaning dsp_dcb_flag
                                  FROM giac_acctrans gacc, giac_branches gibr, giac_colln_batch gcob, CG_REF_CODES cgrc
                                 WHERE gacc.gibr_branch_cd = gibr.branch_cd(+)
                                   AND gacc.tran_class = ''CDC''
                                   AND gcob.dcb_no = gacc.tran_class_no
                                   AND gcob.dcb_year = gacc.tran_year
                                   AND gcob.branch_cd = gacc.gibr_branch_cd
                                   AND gcob.fund_cd = gacc.gfun_fund_cd
                                   AND cgrc.rv_low_value = gcob.dcb_flag
                                   AND cgrc.rv_domain = ''GIAC_COLLN_BATCH.DCB_FLAG''
                                   AND ((SELECT access_tag
                                          FROM giis_user_modules
                                         WHERE userid = NVL (:p_user_id, USER)
                                           AND module_id = ''GIACS035''
                                           AND tran_cd IN (
                                                  SELECT b.tran_cd         
                                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                                   WHERE a.user_id = b.userid
                                                     AND a.user_id = NVL (:p_user_id, USER)
                                                     AND b.iss_cd = gacc.gibr_branch_cd
                                                     AND b.tran_cd = c.tran_cd
                                                     AND c.module_id = ''GIACS035'')) = 1
                                 OR (SELECT access_tag
                                          FROM giis_user_grp_modules
                                         WHERE module_id = ''GIACS035''
                                           AND (user_grp, tran_cd) IN (
                                                  SELECT a.user_grp, b.tran_cd
                                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                   WHERE a.user_grp = b.user_grp
                                                     AND a.user_id = NVL (:p_user_id, USER)
                                                     AND b.iss_cd = gacc.gibr_branch_cd
                                                     AND b.tran_cd = c.tran_cd
                                                     AND c.module_id = ''GIACS035'')) = 1
                               )';
                               
                               
        IF p_branch_name IS NOT NULL THEN
            v_sql := v_sql || ' AND UPPER (gibr.branch_name) LIKE UPPER(''' || p_branch_name || ''') ';
        END IF;
        
        IF p_tran_date IS NOT NULL THEN
            v_sql := v_sql || ' AND TRUNC (/*gacc*/gcob.tran_date) = TO_DATE (''' || p_tran_date || ''', ''MM-DD-YYYY'') '; /*Deo [09.01.2016]: replace gacc with gcob (SR-5631)*/
        END IF;
        
        IF p_dcb_no IS NOT NULL THEN
            v_sql := v_sql || ' AND gacc.tran_year || ''-'' || gacc.tran_class_no LIKE ''' || p_dcb_no ||'''';
        END IF;
        
        IF p_dcb_flag IS NOT NULL THEN
            v_sql := v_sql || ' AND UPPER(cgrc.rv_meaning) LIKE UPPER('''|| p_dcb_flag || ''') ';
        END IF;
        
      IF p_order_by IS NOT NULL THEN
        IF p_order_by = 'dspBranchName' THEN        
          v_sql := v_sql || ' ORDER BY dsp_branch_name ';
        ELSIF p_order_by = 'tranDate' THEN
          v_sql := v_sql || ' ORDER BY tran_date ';
        ELSIF p_order_by = 'dcbNo' THEN
          v_sql := v_sql || ' ORDER BY dcb_no ';
        ELSIF p_order_by = 'dcbFlag' THEN
          v_sql := v_sql || ' ORDER BY dsp_dcb_flag ';           
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC ';
        END IF; 
      END IF;
      
        v_sql := v_sql || ' )innersql ';      
        
        v_sql := v_sql || ') outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
        
      OPEN c FOR v_sql USING p_user_id, p_user_id, p_user_id;
        LOOP
         FETCH c INTO
              v_rec.count_,         
              v_rec.rownum_,   
              v_rec.tran_id,        
              v_rec.gibr_branch_cd, 
              v_rec.gfun_fund_cd,   
              v_rec.dsp_branch_name,
              v_rec.tran_date,
              v_rec.dcb_no,
              v_rec.dcb_flag,    
              v_rec.dsp_dcb_flag;
         
        EXIT WHEN c%NOTFOUND; 
        
        PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
        
        
   END get_dcb_list2;

   FUNCTION check_dcb_flag (  --Deo [03.03.2017]: SR-5939
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_year   giac_colln_batch.dcb_year%TYPE,
      p_dcb_no      giac_colln_batch.dcb_no%TYPE,
      p_type        VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_dcb_flag   giac_colln_batch.dcb_flag%TYPE;
      v_dcb_user   giac_colln_batch.user_id%TYPE;
      v_msg        VARCHAR2 (100)                   := 'Y';
   BEGIN
      FOR i IN (SELECT a.dcb_flag, a.user_id
                  FROM giac_colln_batch a
                 WHERE a.dcb_no = p_dcb_no
                   AND a.dcb_year = p_tran_year
                   AND a.fund_cd = p_fund_cd
                   AND a.branch_cd = p_branch_cd)
      LOOP
         v_dcb_flag := i.dcb_flag;
         v_dcb_user := i.user_id;
      END LOOP;

      IF v_dcb_flag = 'C'
      THEN
         v_msg := 'This DCB was already closed by ' || v_dcb_user || '.';
      ELSIF v_dcb_flag = 'T' AND p_type = 'S'
      THEN
         v_msg :=
               'This DCB is currently being closed by '
            || v_dcb_user
            || ', cannot close the same DCB at the same time.';
      ELSIF v_dcb_flag = 'X'
      THEN
         v_msg :=
               'Cannot proceed with the transaction, '
            || 'this DCB was closed for printing by '
            || v_dcb_user
            || '.';
      END IF;

      RETURN v_msg;
   END check_dcb_flag;
END giac_acctrans_pkg;
/


DROP PUBLIC SYNONYM GIAC_ACCTRANS_PKG;

CREATE PUBLIC SYNONYM GIAC_ACCTRANS_PKG FOR CPI.GIAC_ACCTRANS_PKG;


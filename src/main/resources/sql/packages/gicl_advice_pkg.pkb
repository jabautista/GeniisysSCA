CREATE OR REPLACE PACKAGE BODY CPI.gicl_advice_pkg
AS
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.06.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves list of records from gicl_advice which have the
   **                 same batch_csr_id as the parameter
   */
   FUNCTION get_gicl_advise_list (
      p_batch_csr_id    gicl_batch_csr.batch_csr_id%TYPE,
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         gicl_advice.line_cd%TYPE,
      p_iss_cd          gicl_advice.iss_cd%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_advice_year     gicl_advice.advice_year%TYPE,
      p_advice_seq_no   gicl_advice.advice_seq_no%TYPE,
      p_assd_name       VARCHAR2,
      p_loss_date       VARCHAR2,--gicl_claims.dsp_loss_date%TYPE, replaced by: Nica 05.10.2013
      p_advice_date     VARCHAR2,--gicl_advice.advice_date%TYPE,
      p_loss_desc       giis_loss_ctgry.loss_cat_des%TYPE,
      p_paid_amt        gicl_advice.paid_amt%TYPE,
      p_net_amt         gicl_advice.net_amt%TYPE,
      p_advice_amt      gicl_advice.advise_amt%TYPE,
      p_currency        giis_currency.currency_desc%TYPE,
      p_convert_rate    gicl_advice.convert_rate%TYPE
   )
      RETURN gicl_advice_tab PIPELINED
   AS
      v_advice   gicl_advice_type;
   BEGIN
      FOR i IN
         (SELECT   c015.batch_csr_id, c015.claim_id, c015.line_cd,
                   c015.iss_cd, c015.advice_year, c015.advice_seq_no,
                   c015.advice_id, c015.advice_flag, c015.apprvd_tag,
                      c015.line_cd
                   || '-'
                   || c015.iss_cd
                   || '-'
                   || c015.advice_year
                   || '-'
                   || TO_CHAR (c015.advice_seq_no, '000009') advice_no,
                      c003.line_cd
                   || '-'
                   || c003.subline_cd
                   || '-'
                   || c003.iss_cd
                   || '-'
                   || clm_yy
                   || '-'
                   || TO_CHAR (c003.clm_seq_no, '0000009') claim_no,
                      c003.line_cd
                   || '-'
                   || c003.subline_cd
                   || '-'
                   || c003.pol_iss_cd
                   || '-'
                   || issue_yy
                   || '-'
                   || TO_CHAR (c003.pol_seq_no, '0000009')
                   || '-'
                   || TO_CHAR (c003.renew_no, '09') policy_no,
                   c003.assd_no, c003.assured_name, c003.dsp_loss_date,
                   c015.advice_date, c015.paid_amt, c015.paid_fcurr_amt,
                   c015.net_amt, c015.net_fcurr_amt, c015.advise_amt,
                   c015.adv_fcurr_amt, c015.currency_cd, cur.currency_desc,
                   c015.convert_rate, c003.loss_cat_cd,
                   (SELECT loss_cat_des
                      FROM giis_loss_ctgry
                     WHERE loss_cat_cd = c003.loss_cat_cd
                       AND line_cd = c015.line_cd) loss_cat_des,
                   (SELECT clm_stat_desc
                      FROM giis_clm_stat
                     WHERE clm_stat_cd = c003.clm_stat_cd) dsp_clm_stat_desc,
                   c003.clm_stat_cd
              FROM gicl_advice c015, gicl_claims c003, giis_currency cur
             WHERE (   (c015.apprvd_tag = 'Y'
                        AND c015.batch_csr_id IS NOT NULL
                       )
                    OR (    NVL (c015.apprvd_tag, 'N') = 'N'
                        AND NVL (c015.advice_flag, 'Y') = 'Y'
                       )
                   )
               AND check_user_per_line2 (c015.line_cd,
                                         c015.iss_cd,
                                         p_module_id,
                                         p_user_id
                                        ) = 1
               AND c015.batch_csr_id = p_batch_csr_id
               AND c015.claim_id = c003.claim_id
               AND c015.currency_cd = cur.main_currency_cd
               AND UPPER (c015.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, c015.line_cd))
               AND UPPER (c015.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, c015.iss_cd))
               AND UPPER (c003.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, c003.subline_cd))
               AND UPPER (c015.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, c015.advice_year))
               AND UPPER (c015.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, c015.advice_seq_no))
               AND UPPER (NVL (c003.assured_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (c003.assured_name,
                                          NULL, '*',
                                          c003.assured_name
                                         )
                                 )
                            )       
               AND c015.paid_amt = NVL(p_paid_amt,c015.paid_amt)
               AND c015.net_amt = NVL(p_net_amt,c015.net_amt)
               AND c015.advise_amt = NVL(p_advice_amt,c015.advise_amt)
               AND TRUNC(c003.dsp_loss_date) = TRUNC(NVL(TO_DATE(p_loss_date, 'MM-DD-YYYY'), c003.dsp_loss_date))
               AND TRUNC(c015.advice_date) = TRUNC(NVL(TO_DATE(p_advice_date, 'MM-DD-YYYY'), c015.advice_date))  
          ORDER BY line_cd, iss_cd, advice_year, advice_seq_no)
      LOOP
         v_advice.batch_csr_id := i.batch_csr_id;
         v_advice.claim_id := i.claim_id;
         v_advice.line_cd := i.line_cd;
         v_advice.iss_cd := i.iss_cd;
         v_advice.advice_year := i.advice_year;
         v_advice.advice_seq_no := i.advice_seq_no;
         v_advice.advice_id := i.advice_id;
         v_advice.advice_flag := i.advice_flag;
         v_advice.apprvd_tag := i.apprvd_tag;
         v_advice.advice_no := i.advice_no;
         v_advice.claim_no := i.claim_no;
         v_advice.policy_no := i.policy_no;
         v_advice.assd_no := i.assd_no;
         v_advice.assured_name := i.assured_name;
         v_advice.dsp_loss_date := i.dsp_loss_date;
         v_advice.advice_date := i.advice_date;
         v_advice.paid_amt := i.paid_amt;
         v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
         v_advice.net_amt := i.net_amt;
         v_advice.net_fcurr_amt := i.net_fcurr_amt;
         v_advice.advise_amt := i.advise_amt;
         v_advice.adv_fcurr_amt := i.adv_fcurr_amt;
         v_advice.currency_cd := i.currency_cd;
         v_advice.currency_desc := i.currency_desc;
         v_advice.convert_rate := i.convert_rate;
         v_advice.dsp_loss_cat_des := i.loss_cat_des;
         v_advice.loss_cat_cd := i.loss_cat_cd;
         v_advice.clm_stat_cd := i.clm_stat_cd;
         v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
         PIPE ROW (v_advice);
      END LOOP;
   END get_gicl_advise_list;

    /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.07.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves list of records from gicl_advice which have the
   **                 null values of batch_csr_id
   */
   FUNCTION get_gicl_advise_list_2 (
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         gicl_advice.line_cd%TYPE,
      p_iss_cd          gicl_advice.iss_cd%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_advice_year     gicl_advice.advice_year%TYPE,
      p_advice_seq_no   gicl_advice.advice_seq_no%TYPE,
      p_assd_name       VARCHAR2,
      p_loss_date       VARCHAR2,--gicl_claims.dsp_loss_date%TYPE, replaced by: Nica 05.10.2013
      p_advice_date     VARCHAR2,--gicl_advice.advice_date%TYPE,
      p_loss_desc       giis_loss_ctgry.loss_cat_des%TYPE,
      p_paid_amt        gicl_advice.paid_amt%TYPE,
      p_net_amt         gicl_advice.net_amt%TYPE,
      p_advice_amt      gicl_advice.advise_amt%TYPE,
      p_currency        giis_currency.currency_desc%TYPE,
      p_convert_rate    gicl_advice.convert_rate%TYPE
   )
      RETURN gicl_advice_tab PIPELINED
   AS
      v_advice   gicl_advice_type;
   BEGIN
      FOR i IN
         (SELECT   c015.batch_csr_id, c015.claim_id, c015.line_cd,
                   c015.iss_cd, c015.advice_year, c015.advice_seq_no,
                   c015.advice_id, c015.advice_flag, c015.apprvd_tag,
                      c015.line_cd
                   || '-'
                   || c015.iss_cd
                   || '-'
                   || c015.advice_year
                   || '-'
                   || TO_CHAR (c015.advice_seq_no, '000009') advice_no,
                      c003.line_cd
                   || '-'
                   || c003.subline_cd
                   || '-'
                   || c003.iss_cd
                   || '-'
                   || clm_yy
                   || '-'
                   || TO_CHAR (c003.clm_seq_no, '0000009') claim_no,
                      c003.line_cd
                   || '-'
                   || c003.subline_cd
                   || '-'
                   || c003.pol_iss_cd
                   || '-'
                   || issue_yy
                   || '-'
                   || TO_CHAR (c003.pol_seq_no, '0000009')
                   || '-'
                   || TO_CHAR (c003.renew_no, '09') policy_no,
                   c003.assd_no, c003.assured_name, c003.dsp_loss_date,
                   c015.advice_date, c015.paid_amt, c015.paid_fcurr_amt,
                   c015.net_amt, c015.net_fcurr_amt, c015.advise_amt,
                   c015.adv_fcurr_amt, c015.currency_cd, cur.currency_desc,
                   c015.convert_rate, c003.loss_cat_cd,
                   (SELECT loss_cat_des
                      FROM giis_loss_ctgry
                     WHERE loss_cat_cd = c003.loss_cat_cd
                       AND line_cd = c015.line_cd) loss_cat_des,
                   (SELECT clm_stat_desc
                      FROM giis_clm_stat
                     WHERE clm_stat_cd = c003.clm_stat_cd) dsp_clm_stat_desc,
                   c003.clm_stat_cd
              FROM gicl_advice c015, gicl_claims c003, giis_currency cur
             WHERE c015.batch_csr_id IS NULL
               AND NVL (c015.apprvd_tag, 'N') = 'N'
               AND NVL (c015.advice_flag, 'Y') = 'Y'
               AND check_user_per_line2 (c015.line_cd,
                                         c015.iss_cd,
                                         p_module_id,
                                         p_user_id
                                        ) = 1
               AND c015.claim_id = c003.claim_id
               AND c015.currency_cd = cur.main_currency_cd
               AND UPPER (c015.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, c015.line_cd))
               AND UPPER (c015.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, c015.iss_cd))
               AND UPPER (c003.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, c003.subline_cd))
               AND UPPER (c015.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, c015.advice_year))
               AND UPPER (c015.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, c015.advice_seq_no))
               AND UPPER (NVL (c003.assured_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (c003.assured_name,
                                          NULL, '*',
                                          c003.assured_name
                                         )
                                 )
                            )
               AND c015.paid_amt = NVL(p_paid_amt,c015.paid_amt)
               AND c015.net_amt = NVL(p_net_amt,c015.net_amt)
               AND c015.advise_amt = NVL(p_advice_amt,c015.advise_amt)
               AND TRUNC(c003.dsp_loss_date) = TRUNC(NVL(TO_DATE(p_loss_date, 'MM-DD-YYYY'), c003.dsp_loss_date))
               AND TRUNC(c015.advice_date) = TRUNC(NVL(TO_DATE(p_advice_date, 'MM-DD-YYYY'), c015.advice_date))  
          ORDER BY line_cd, iss_cd, advice_year, advice_seq_no)
      LOOP
         v_advice.batch_csr_id := i.batch_csr_id;
         v_advice.claim_id := i.claim_id;
         v_advice.line_cd := i.line_cd;
         v_advice.iss_cd := i.iss_cd;
         v_advice.advice_year := i.advice_year;
         v_advice.advice_seq_no := i.advice_seq_no;
         v_advice.advice_id := i.advice_id;
         v_advice.advice_flag := i.advice_flag;
         v_advice.apprvd_tag := i.apprvd_tag;
         v_advice.advice_no := i.advice_no;
         v_advice.claim_no := i.claim_no;
         v_advice.policy_no := i.policy_no;
         v_advice.assd_no := i.assd_no;
         v_advice.assured_name := i.assured_name;
         v_advice.dsp_loss_date := i.dsp_loss_date;
         v_advice.advice_date := i.advice_date;
         v_advice.paid_amt := i.paid_amt;
         v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
         v_advice.net_amt := i.net_amt;
         v_advice.net_fcurr_amt := i.net_fcurr_amt;
         v_advice.advise_amt := i.advise_amt;
         v_advice.adv_fcurr_amt := i.adv_fcurr_amt;
         v_advice.currency_cd := i.currency_cd;
         v_advice.currency_desc := i.currency_desc;
         v_advice.convert_rate := i.convert_rate;
         v_advice.dsp_loss_cat_des := i.loss_cat_des;
         v_advice.loss_cat_cd := i.loss_cat_cd;
         v_advice.clm_stat_cd := i.clm_stat_cd;
         v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
         PIPE ROW (v_advice);
      END LOOP;
   END get_gicl_advise_list_2;

/*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  12.09.2011
   **  Reference By : (GIACS086 - Special Claim Settlement Request)
   **  Description  : Retrieves list of records from gicl_advice which have the
   **                 null values of batch_dv_id
   */
   FUNCTION get_giacs086_advise_list (
      p_batch_dv_id         gicl_advice.batch_dv_id%TYPE,
      p_payee_class_cd      giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd            giac_batch_dv.payee_cd%TYPE,
      p_module_id           VARCHAR2,
      p_user_id             giis_users.user_id%TYPE,
      p_assured_name        gicl_claims.assured_name%TYPE,
      p_dsp_clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      p_loss_date           VARCHAR2,
      p_dsp_loss_cat_des    giis_loss_ctgry.loss_cat_des%TYPE,
      p_dsp_payee_class     giis_payee_class.class_desc%TYPE,
      p_dsp_payee           VARCHAR2,
      p_currency_desc       giis_currency.currency_desc%TYPE,
      p_convert_rate        gicl_advice.convert_rate%TYPE,
       p_line_cd        gicl_advice.line_cd%TYPE,
        p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE
   )
      RETURN gicl_advice_tab PIPELINED
   IS
      v_advice   gicl_advice_type;
   BEGIN
      FOR i IN
         (SELECT a.*
            FROM (SELECT   a.line_cd, c.subline_cd, a.iss_cd, a.advice_year,
                           a.advice_seq_no, a.paid_amt paid_amt,
                           a.currency_cd,
                           DECODE (a.currency_cd,
                                   giacp.n ('CURRENCY_CD'), 1,
                                   a.convert_rate
                                  ) convert_rate,
                           a.advice_flag, a.user_id, a.last_update,
                           a.advice_id, a.claim_id, a.apprvd_tag,
                           a.batch_dv_id, a.paid_fcurr_amt, b.payee_cd,
                           b.payee_class_cd,                 /*b.payee_type,*/
                           DECODE (b.currency_cd,
                                   giacp.n ('CURRENCY_CD'), 1,
                                   a.convert_rate
                                  ) conv_rt,
                           
                           -- SUM (b.net_amt) net_amt, SUM (b.paid_amt)
                                  --                                   paid_amt2,
                           b.currency_cd loss_curr_cd, c.clm_stat_cd,
                           a.payee_remarks,
                              a.line_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || a.advice_year
                           || '-'
                           || TO_CHAR (a.advice_seq_no, '000009') advice_no,
                              c.line_cd
                           || '-'
                           || c.subline_cd
                           || '-'
                           || c.iss_cd
                           || '-'
                           || clm_yy
                           || '-'
                           || TO_CHAR (c.clm_seq_no, '0000009') claim_no,
                              c.line_cd
                           || '-'
                           || c.subline_cd
                           || '-'
                           || c.pol_iss_cd
                           || '-'
                           || issue_yy
                           || '-'
                           || TO_CHAR (c.pol_seq_no, '0000009')
                           || '-'
                           || TO_CHAR (c.renew_no, '09') policy_no,
                           c.assd_no, c.assured_name, c.dsp_loss_date,
                           a.advice_date, a.net_fcurr_amt, a.advise_amt,
                           cur.currency_desc, a.net_amt, c.loss_cat_cd,
                           (SELECT loss_cat_des
                              FROM giis_loss_ctgry
                             WHERE loss_cat_cd = c.loss_cat_cd
                               AND line_cd = a.line_cd) loss_cat_des,
                           (SELECT clm_stat_desc
                              FROM giis_clm_stat
                             WHERE clm_stat_cd =
                                              c.clm_stat_cd)
                                                            dsp_clm_stat_desc,
                           (SELECT class_desc
                              FROM giis_payee_class
                             WHERE payee_class_cd =
                                             b.payee_class_cd)
                                                              dsp_payee_class,
                           (SELECT    payee_last_name
                                   || DECODE (payee_first_name,
                                              NULL, '',
                                              ', '
                                             )
                                   || payee_first_name
                                   || DECODE (payee_middle_name,
                                              NULL, '',
                                              ' '
                                             )
                                   || payee_middle_name pname
                              FROM giis_payees a
                             WHERE a.payee_no = b.payee_cd
                               AND a.payee_class_cd = b.payee_class_cd)
                                                                    dsp_payee
                      FROM gicl_claims c,
                           gicl_advice a,
                           gicl_clm_loss_exp b,
                           giis_currency cur
                     WHERE c.claim_id = a.claim_id
                       AND a.advice_flag = 'Y'
                       AND a.claim_id = b.claim_id
                       AND a.advice_id = b.advice_id
                       AND batch_csr_id IS NULL
                       AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                         a.iss_cd,
                                                         p_module_id,
                                                         p_user_id
                                                        ) = 1
                       AND EXISTS (
                              SELECT 1
                                FROM gicl_acct_entries d
                               WHERE d.claim_id = a.claim_id
                                 AND d.advice_id = a.advice_id
                                 AND d.payee_class_cd = b.payee_class_cd
                                 AND d.payee_cd = b.payee_cd)
                       -- default where parameters
                       AND batch_dv_id = p_batch_dv_id
                       AND payee_class_cd = p_payee_class_cd
                       AND payee_cd = p_payee_cd
                       AND a.currency_cd = cur.main_currency_cd
                  GROUP BY a.line_cd,
                           a.iss_cd,
                           a.advice_year,
                           a.advice_seq_no,
                           a.paid_amt,
                           a.currency_cd,
                           DECODE (a.currency_cd,
                                   giacp.n ('CURRENCY_CD'), 1,
                                   a.convert_rate
                                  ),
                           a.advice_flag,
                           a.user_id,
                           a.last_update,
                           a.advice_id,
                           a.claim_id,
                           a.apprvd_tag,
                           a.batch_dv_id,
                           a.paid_fcurr_amt,
                           b.payee_cd,
                           b.payee_class_cd,                 /*b.payee_type,*/
                           DECODE (b.currency_cd,
                                   giacp.n ('CURRENCY_CD'), 1,
                                   a.convert_rate
                                  ),
                           b.currency_cd,
                           c.clm_stat_cd,
                           a.payee_remarks,
                           c.line_cd,
                           c.subline_cd,
                           c.pol_iss_cd,
                           issue_yy,
                           c.clm_seq_no,
                           c.iss_cd,
                           clm_yy,
                           c.pol_seq_no,
                           c.renew_no,
                           c.assd_no,
                           c.assured_name,
                           c.dsp_loss_date,
                           a.advice_date,
                           a.net_fcurr_amt,
                           a.advise_amt,
                           cur.currency_desc,
                           a.net_amt,
                           c.loss_cat_cd) a
           -- start of filters
          WHERE  UPPER (a.assured_name) LIKE
                                  UPPER (NVL (p_assured_name, a.assured_name))
             AND UPPER (a.dsp_clm_stat_desc) LIKE
                        UPPER (NVL (p_dsp_clm_stat_desc, a.dsp_clm_stat_desc))
             AND TRUNC (a.dsp_loss_date) =
                    TRUNC (NVL (TO_DATE (p_loss_date, 'MM-DD-YYYY'),
                                a.dsp_loss_date
                               )
                          )
             AND UPPER (a.loss_cat_des) LIKE
                              UPPER (NVL (p_dsp_loss_cat_des, a.loss_cat_des))
             AND UPPER (a.dsp_payee_class) LIKE
                            UPPER (NVL (p_dsp_payee_class, a.dsp_payee_class))
             AND UPPER (a.dsp_payee) LIKE
                                        UPPER (NVL (p_dsp_payee, a.dsp_payee))
             AND UPPER (a.currency_desc) LIKE
                                UPPER (NVL (p_currency_desc, a.currency_desc))
             AND UPPER (a.convert_rate) LIKE
                                  UPPER (NVL (p_convert_rate, a.convert_rate))
                                  AND UPPER (a.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, a.line_cd))
               AND UPPER (a.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, a.iss_cd))
               AND UPPER (a.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, a.subline_cd))
               AND UPPER (a.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, a.advice_year))
               AND UPPER (a.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, a.advice_seq_no))
                                  )
            
          
      LOOP
         v_advice.batch_dv_id := i.batch_dv_id;
         v_advice.claim_id := i.claim_id;
         v_advice.line_cd := i.line_cd;
         v_advice.iss_cd := i.iss_cd;
         v_advice.advice_year := i.advice_year;
         v_advice.advice_seq_no := i.advice_seq_no;
         v_advice.advice_id := i.advice_id;
         v_advice.advice_flag := i.advice_flag;
         v_advice.apprvd_tag := i.apprvd_tag;
         v_advice.advice_no := i.advice_no;
         v_advice.claim_no := i.claim_no;
         v_advice.policy_no := i.policy_no;
         v_advice.assd_no := i.assd_no;
         v_advice.assured_name := i.assured_name;
         v_advice.dsp_loss_date := i.dsp_loss_date;
         v_advice.advice_date := i.advice_date;
         v_advice.paid_amt := i.paid_amt;
         v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
         v_advice.net_amt := i.net_amt;
         v_advice.net_fcurr_amt := i.net_fcurr_amt;
         v_advice.advise_amt := i.advise_amt;
         v_advice.currency_cd := i.currency_cd;
         v_advice.currency_desc := i.currency_desc;
         v_advice.convert_rate := i.convert_rate;
         v_advice.dsp_loss_cat_des := i.loss_cat_des;
         v_advice.loss_cat_cd := i.loss_cat_cd;
         v_advice.clm_stat_cd := i.clm_stat_cd;
         v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
         v_advice.payee_class_cd := i.payee_class_cd;
         v_advice.payee_cd := i.payee_cd;
         v_advice.dsp_payee_class := i.dsp_payee_class;
         v_advice.conv_rt := i.conv_rt;
         v_advice.loss_curr_cd := i.loss_curr_cd;
         v_advice.dsp_payee := i.dsp_payee;
         v_advice.generate_sw := 'Y';
         v_advice.payee_remarks := i.payee_remarks;

         IF v_advice.currency_cd = giacp.n ('CURRENCY_CD')
         THEN
            v_advice.dsp_paid_amt := v_advice.paid_amt * v_advice.conv_rt;
            v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt * v_advice.conv_rt;
         ELSE
            IF v_advice.loss_curr_cd = giacp.n ('CURRENCY_CD')
            THEN
               v_advice.dsp_paid_amt := v_advice.paid_amt / v_advice.conv_rt;
               v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
            ELSE
               v_advice.dsp_paid_amt := v_advice.paid_amt;
               v_advice.dsp_paid_fcurr_amt := v_advice.paid_amt;
            END IF;
         END IF;
        
      v_advice.dsp_paid_amt := nvl (v_advice.dsp_paid_amt, 0);
         PIPE ROW (v_advice);
      END LOOP;
   END;

    /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  12.09.2011
   **  Reference By : (GIACS086 - Special Claim Settlement Request)
   **  Description  : Retrieves list of records from gicl_advice which have the
   **                 same batch_dv_id as the parameter
   */
   FUNCTION get_giacs086_advise_list2 (
      p_batch_dv_id         gicl_advice.batch_dv_id%TYPE,
      p_payee_class_cd      giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd            giac_batch_dv.payee_cd%TYPE,
      p_module_id           VARCHAR2,
      p_user_id             giis_users.user_id%TYPE,
      p_claim_id            gicl_claims.claim_id%TYPE,
      p_assured_name        gicl_claims.assured_name%TYPE,
      p_dsp_clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      p_loss_date           VARCHAR2,
      p_dsp_loss_cat_des    giis_loss_ctgry.loss_cat_des%TYPE,
      p_dsp_payee_class     giis_payee_class.class_desc%TYPE,
      p_dsp_payee           VARCHAR2,
      p_currency_desc       giis_currency.currency_desc%TYPE,
      p_convert_rate        gicl_advice.convert_rate%TYPE,
      p_condition           NUMBER,
       p_line_cd        gicl_advice.line_cd%TYPE,
        p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE
   )
      RETURN gicl_advice_tab PIPELINED
   IS
      v_advice   gicl_advice_type;
      v_total GICL_ADVICE.PAID_AMT%type;
   BEGIN
      IF p_condition = 1
      THEN                                     -- payee_class_cd as condition
         FOR i IN
            (SELECT a.*
               FROM (SELECT   a.line_cd, c.subline_cd, a.iss_cd, a.advice_year,
                              a.advice_seq_no, a.paid_amt paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) convert_rate,
                              a.advice_flag, a.user_id, a.last_update,
                              a.advice_id, a.claim_id, a.apprvd_tag,
                              a.batch_dv_id, a.paid_fcurr_amt, b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) conv_rt,
                              
                              -- SUM (b.net_amt) net_amt, SUM (b.paid_amt)
                                     --                                   paid_amt2,
                              b.currency_cd loss_curr_cd, c.clm_stat_cd,
                              a.payee_remarks,
                                 a.line_cd
                              || '-'
                              || a.iss_cd
                              || '-'
                              || a.advice_year
                              || '-'
                              || TO_CHAR (a.advice_seq_no, '000009')
                                                                    advice_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.iss_cd
                              || '-'
                              || clm_yy
                              || '-'
                              || TO_CHAR (c.clm_seq_no, '0000009') claim_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.pol_iss_cd
                              || '-'
                              || issue_yy
                              || '-'
                              || TO_CHAR (c.pol_seq_no, '0000009')
                              || '-'
                              || TO_CHAR (c.renew_no, '09') policy_no,
                              c.assd_no, c.assured_name, c.dsp_loss_date,
                              a.advice_date, a.net_fcurr_amt, a.advise_amt,
                              cur.currency_desc, a.net_amt, c.loss_cat_cd,
                              (SELECT loss_cat_des
                                 FROM giis_loss_ctgry
                                WHERE loss_cat_cd =
                                                   c.loss_cat_cd
                                  AND line_cd = a.line_cd) loss_cat_des,
                              (SELECT clm_stat_desc
                                 FROM giis_clm_stat
                                WHERE clm_stat_cd =
                                              c.clm_stat_cd)
                                                            dsp_clm_stat_desc,
                              (SELECT class_desc
                                 FROM giis_payee_class
                                WHERE payee_class_cd =
                                             b.payee_class_cd)
                                                              dsp_payee_class,
                              (SELECT    payee_last_name
                                      || DECODE (payee_first_name,
                                                 NULL, '',
                                                 ', '
                                                )
                                      || payee_first_name
                                      || DECODE (payee_middle_name,
                                                 NULL, '',
                                                 ' '
                                                )
                                      || payee_middle_name pname
                                 FROM giis_payees a
                                WHERE a.payee_no = b.payee_cd
                                  AND a.payee_class_cd = b.payee_class_cd)
                                                                    dsp_payee
                         FROM gicl_claims c,
                              gicl_advice a,
                              gicl_clm_loss_exp b,
                              giis_currency cur
                        WHERE c.claim_id = a.claim_id
                          AND a.advice_flag = 'Y'
                          AND a.claim_id = b.claim_id
                          AND a.advice_id = b.advice_id
                          AND batch_csr_id IS NULL
                          AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                            a.iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ) = 1
                          AND EXISTS (
                                 SELECT 1
                                   FROM gicl_acct_entries d
                                  WHERE d.claim_id = a.claim_id
                                    AND d.advice_id = a.advice_id
                                    AND d.payee_class_cd = b.payee_class_cd
                                    AND d.payee_cd = b.payee_cd)
                          AND a.batch_dv_id IS NULL
                          AND a.claim_id = NVL (p_claim_id, a.claim_id)
                          AND (a.apprvd_tag = 'N' OR a.apprvd_tag IS NULL)
                          AND a.claim_id IN (
                                 SELECT claim_id
                                   FROM gicl_claims
                                  WHERE clm_stat_cd NOT IN
                                                     ('CD', 'WD', 'CC', 'DN'))
                          AND a.currency_cd = cur.main_currency_cd
                     GROUP BY a.line_cd,
                              a.iss_cd,
                              a.advice_year,
                              a.advice_seq_no,
                              a.paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              a.advice_flag,
                              a.user_id,
                              a.last_update,
                              a.advice_id,
                              a.claim_id,
                              a.apprvd_tag,
                              a.batch_dv_id,
                              a.paid_fcurr_amt,
                              b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              b.currency_cd,
                              c.clm_stat_cd,
                              a.payee_remarks,
                              c.line_cd,
                              c.subline_cd,
                              c.pol_iss_cd,
                              issue_yy,
                              c.clm_seq_no,
                              c.iss_cd,
                              clm_yy,
                              c.pol_seq_no,
                              c.renew_no,
                              c.assd_no,
                              c.assured_name,
                              c.dsp_loss_date,
                              a.advice_date,
                              a.net_fcurr_amt,
                              a.advise_amt,
                              cur.currency_desc,
                              a.net_amt,
                              c.loss_cat_cd) a
              -- start of filters
             WHERE  UPPER (a.assured_name) LIKE
                                  UPPER (NVL (p_assured_name, a.assured_name))
                AND UPPER (a.dsp_clm_stat_desc) LIKE
                        UPPER (NVL (p_dsp_clm_stat_desc, a.dsp_clm_stat_desc))
                AND TRUNC (a.dsp_loss_date) =
                       TRUNC (NVL (TO_DATE (p_loss_date, 'MM-DD-YYYY'),
                                   a.dsp_loss_date
                                  )
                             )
                AND UPPER (a.loss_cat_des) LIKE
                              UPPER (NVL (p_dsp_loss_cat_des, a.loss_cat_des))
                AND UPPER (a.dsp_payee_class) LIKE
                            UPPER (NVL (p_dsp_payee_class, a.dsp_payee_class))
                AND UPPER (a.dsp_payee) LIKE
                                        UPPER (NVL (p_dsp_payee, a.dsp_payee))
                AND UPPER (a.currency_desc) LIKE
                                UPPER (NVL (p_currency_desc, a.currency_desc))
                AND UPPER (a.convert_rate) LIKE
                                  UPPER (NVL (p_convert_rate, a.convert_rate))
                                  AND UPPER (a.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, a.line_cd))
               AND UPPER (a.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, a.iss_cd))
               AND UPPER (a.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, a.subline_cd))
               AND UPPER (a.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, a.advice_year))
               AND UPPER (a.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, a.advice_seq_no))
                -- extra conditions
                AND a.payee_class_cd = p_payee_class_cd)
         LOOP
            v_advice.batch_dv_id := i.batch_dv_id;
            v_advice.claim_id := i.claim_id;
            v_advice.line_cd := i.line_cd;
            v_advice.iss_cd := i.iss_cd;
            v_advice.advice_year := i.advice_year;
            v_advice.advice_seq_no := i.advice_seq_no;
            v_advice.advice_id := i.advice_id;
            v_advice.advice_flag := i.advice_flag;
            v_advice.apprvd_tag := i.apprvd_tag;
            v_advice.advice_no := i.advice_no;
            v_advice.claim_no := i.claim_no;
            v_advice.policy_no := i.policy_no;
            v_advice.assd_no := i.assd_no;
            v_advice.assured_name := i.assured_name;
            v_advice.dsp_loss_date := i.dsp_loss_date;
            v_advice.advice_date := i.advice_date;
            v_advice.paid_amt := i.paid_amt;
            v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
            v_advice.net_amt := i.net_amt;
            v_advice.net_fcurr_amt := i.net_fcurr_amt;
            v_advice.advise_amt := i.advise_amt;
            v_advice.currency_cd := i.currency_cd;
            v_advice.currency_desc := i.currency_desc;
            v_advice.convert_rate := i.convert_rate;
            v_advice.dsp_loss_cat_des := i.loss_cat_des;
            v_advice.loss_cat_cd := i.loss_cat_cd;
            v_advice.clm_stat_cd := i.clm_stat_cd;
            v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
            v_advice.payee_class_cd := i.payee_class_cd;
            v_advice.payee_cd := i.payee_cd;
            v_advice.dsp_payee_class := i.dsp_payee_class;
            v_advice.conv_rt := i.conv_rt;
            v_advice.loss_curr_cd := i.loss_curr_cd;
            v_advice.dsp_payee := i.dsp_payee;
            v_advice.generate_sw := 'N';
            v_advice.payee_remarks := i.payee_remarks;

            IF v_advice.currency_cd = giacp.n ('CURRENCY_CD')
            THEN
               v_advice.dsp_paid_amt := v_advice.paid_amt * v_advice.conv_rt;
               v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt * v_advice.conv_rt;
            ELSE
               IF v_advice.loss_curr_cd = giacp.n ('CURRENCY_CD')
               THEN
                  v_advice.dsp_paid_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
                  v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
               ELSE
                  v_advice.dsp_paid_amt := v_advice.paid_amt;
                  v_advice.dsp_paid_fcurr_amt := v_advice.paid_amt;
               END IF;
            END IF;
            v_advice.dsp_paid_amt := nvl (v_advice.dsp_paid_amt, 0);
            
            --after the initial paid_amt is retrieve, a new query would be initiated for this option below
            FOR a IN -- this is from the RG in WHEN-CHECKBOX-CHANGED BLOCK:GICL_ADVICE
               (SELECT a.clm_loss_id,
                       DECODE
                          (a.currency_cd,
                           b.currency_cd, a.paid_amt,
                             a.paid_amt
                           * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                          ) paid_amt,                        -- marlo 07162010
                       DECODE
                           (a.currency_cd,
                            b.currency_cd, a.net_amt,
                              a.net_amt
                            * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                           ) net_amt,
                       a.payee_type                               --jen.090706
                  FROM gicl_clm_loss_exp a, gicl_advice b
                 WHERE a.advice_id = v_advice.advice_id
                   AND a.claim_id = v_advice.claim_id
                   AND a.payee_class_cd = v_advice.payee_class_cd
                   AND a.claim_id = b.claim_id
                   AND a.advice_id = b.advice_id)
            LOOP
               v_advice.paid_amt := a.paid_amt;
               v_advice.net_amt := a.net_amt;
               v_advice.clm_loss_id := a.clm_loss_id;
               v_advice.payee_type := a.payee_type;
            END LOOP;

            PIPE ROW (v_advice);
         END LOOP;
      ELSIF p_condition = 2
      THEN                         -- payee_class_cd and payee_cd as condition
         FOR i IN
            (SELECT a.*
               FROM (SELECT   a.line_cd,c.subline_cd, a.iss_cd, a.advice_year,
                              a.advice_seq_no, a.paid_amt paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) convert_rate,
                              a.advice_flag, a.user_id, a.last_update,
                              a.advice_id, a.claim_id, a.apprvd_tag,
                              a.batch_dv_id, a.paid_fcurr_amt, b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) conv_rt,
                              
                              -- SUM (b.net_amt) net_amt, SUM (b.paid_amt)
                                     --                                   paid_amt2,
                              b.currency_cd loss_curr_cd, c.clm_stat_cd,
                              a.payee_remarks,
                                 a.line_cd
                              || '-'
                              || a.iss_cd
                              || '-'
                              || a.advice_year
                              || '-'
                              || TO_CHAR (a.advice_seq_no, '000009')
                                                                    advice_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.iss_cd
                              || '-'
                              || clm_yy
                              || '-'
                              || TO_CHAR (c.clm_seq_no, '0000009') claim_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.pol_iss_cd
                              || '-'
                              || issue_yy
                              || '-'
                              || TO_CHAR (c.pol_seq_no, '0000009')
                              || '-'
                              || TO_CHAR (c.renew_no, '09') policy_no,
                              c.assd_no, c.assured_name, c.dsp_loss_date,
                              a.advice_date, a.net_fcurr_amt, a.advise_amt,
                              cur.currency_desc, a.net_amt, c.loss_cat_cd,
                              (SELECT loss_cat_des
                                 FROM giis_loss_ctgry
                                WHERE loss_cat_cd =
                                                   c.loss_cat_cd
                                  AND line_cd = a.line_cd) loss_cat_des,
                              (SELECT clm_stat_desc
                                 FROM giis_clm_stat
                                WHERE clm_stat_cd =
                                              c.clm_stat_cd)
                                                            dsp_clm_stat_desc,
                              (SELECT class_desc
                                 FROM giis_payee_class
                                WHERE payee_class_cd =
                                             b.payee_class_cd)
                                                              dsp_payee_class,
                              (SELECT    payee_last_name
                                      || DECODE (payee_first_name,
                                                 NULL, '',
                                                 ', '
                                                )
                                      || payee_first_name
                                      || DECODE (payee_middle_name,
                                                 NULL, '',
                                                 ' '
                                                )
                                      || payee_middle_name pname
                                 FROM giis_payees a
                                WHERE a.payee_no = b.payee_cd
                                  AND a.payee_class_cd = b.payee_class_cd)
                                                                    dsp_payee
                         FROM gicl_claims c,
                              gicl_advice a,
                              gicl_clm_loss_exp b,
                              giis_currency cur
                        WHERE c.claim_id = a.claim_id
                          AND a.advice_flag = 'Y'
                          AND a.claim_id = b.claim_id
                          AND a.advice_id = b.advice_id
                          AND batch_csr_id IS NULL
                          AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                            a.iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ) = 1
                          AND EXISTS (
                                 SELECT 1
                                   FROM gicl_acct_entries d
                                  WHERE d.claim_id = a.claim_id
                                    AND d.advice_id = a.advice_id
                                    AND d.payee_class_cd = b.payee_class_cd
                                    AND d.payee_cd = b.payee_cd)
                          AND a.batch_dv_id IS NULL
                          AND a.claim_id = NVL (p_claim_id, a.claim_id)
                          AND (a.apprvd_tag = 'N' OR a.apprvd_tag IS NULL)
                          AND a.claim_id IN (
                                 SELECT claim_id
                                   FROM gicl_claims
                                  WHERE clm_stat_cd NOT IN
                                                     ('CD', 'WD', 'CC', 'DN'))
                          AND a.currency_cd = cur.main_currency_cd
                     GROUP BY a.line_cd,
                              a.iss_cd,
                              a.advice_year,
                              a.advice_seq_no,
                              a.paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              a.advice_flag,
                              a.user_id,
                              a.last_update,
                              a.advice_id,
                              a.claim_id,
                              a.apprvd_tag,
                              a.batch_dv_id,
                              a.paid_fcurr_amt,
                              b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              b.currency_cd,
                              c.clm_stat_cd,
                              a.payee_remarks,
                              c.line_cd,
                              c.subline_cd,
                              c.pol_iss_cd,
                              issue_yy,
                              c.clm_seq_no,
                              c.iss_cd,
                              clm_yy,
                              c.pol_seq_no,
                              c.renew_no,
                              c.assd_no,
                              c.assured_name,
                              c.dsp_loss_date,
                              a.advice_date,
                              a.net_fcurr_amt,
                              a.advise_amt,
                              cur.currency_desc,
                              a.net_amt,
                              c.loss_cat_cd) a
              -- start of filters
             WHERE  UPPER (a.assured_name) LIKE
                                  UPPER (NVL (p_assured_name, a.assured_name))
                AND UPPER (a.dsp_clm_stat_desc) LIKE
                        UPPER (NVL (p_dsp_clm_stat_desc, a.dsp_clm_stat_desc))
                AND TRUNC (a.dsp_loss_date) =
                       TRUNC (NVL (TO_DATE (p_loss_date, 'MM-DD-YYYY'),
                                   a.dsp_loss_date
                                  )
                             )
                AND UPPER (a.loss_cat_des) LIKE
                              UPPER (NVL (p_dsp_loss_cat_des, a.loss_cat_des))
                AND UPPER (a.dsp_payee_class) LIKE
                            UPPER (NVL (p_dsp_payee_class, a.dsp_payee_class))
                AND UPPER (a.dsp_payee) LIKE
                                        UPPER (NVL (p_dsp_payee, a.dsp_payee))
                AND UPPER (a.currency_desc) LIKE
                                UPPER (NVL (p_currency_desc, a.currency_desc))
                AND UPPER (a.convert_rate) LIKE
                                  UPPER (NVL (p_convert_rate, a.convert_rate))
                                  AND UPPER (a.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, a.line_cd))
               AND UPPER (a.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, a.iss_cd))
               AND UPPER (a.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, a.subline_cd))
               AND UPPER (a.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, a.advice_year))
               AND UPPER (a.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, a.advice_seq_no))
                -- extra conditions
                AND a.payee_class_cd = a.payee_class_cd
                AND a.payee_cd = p_payee_cd)
         LOOP
            v_advice.batch_dv_id := i.batch_dv_id;
            v_advice.claim_id := i.claim_id;
            v_advice.line_cd := i.line_cd;
            v_advice.iss_cd := i.iss_cd;
            v_advice.advice_year := i.advice_year;
            v_advice.advice_seq_no := i.advice_seq_no;
            v_advice.advice_id := i.advice_id;
            v_advice.advice_flag := i.advice_flag;
            v_advice.apprvd_tag := i.apprvd_tag;
            v_advice.advice_no := i.advice_no;
            v_advice.claim_no := i.claim_no;
            v_advice.policy_no := i.policy_no;
            v_advice.assd_no := i.assd_no;
            v_advice.assured_name := i.assured_name;
            v_advice.dsp_loss_date := i.dsp_loss_date;
            v_advice.advice_date := i.advice_date;
            v_advice.paid_amt := i.paid_amt;
            v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
            v_advice.net_amt := i.net_amt;
            v_advice.net_fcurr_amt := i.net_fcurr_amt;
            v_advice.advise_amt := i.advise_amt;
            v_advice.currency_cd := i.currency_cd;
            v_advice.currency_desc := i.currency_desc;
            v_advice.convert_rate := i.convert_rate;
            v_advice.dsp_loss_cat_des := i.loss_cat_des;
            v_advice.loss_cat_cd := i.loss_cat_cd;
            v_advice.clm_stat_cd := i.clm_stat_cd;
            v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
            v_advice.payee_class_cd := i.payee_class_cd;
            v_advice.payee_cd := i.payee_cd;
            v_advice.dsp_payee_class := i.dsp_payee_class;
            v_advice.conv_rt := i.conv_rt;
            v_advice.loss_curr_cd := i.loss_curr_cd;
            v_advice.dsp_payee := i.dsp_payee;
            v_advice.generate_sw := 'N';
            v_advice.payee_remarks := i.payee_remarks;

            IF v_advice.currency_cd = giacp.n ('CURRENCY_CD')
            THEN
               v_advice.dsp_paid_amt := v_advice.paid_amt * v_advice.conv_rt;
               v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt * v_advice.conv_rt;
            ELSE
               IF v_advice.loss_curr_cd = giacp.n ('CURRENCY_CD')
               THEN
                  v_advice.dsp_paid_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
                  v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
               ELSE
                  v_advice.dsp_paid_amt := v_advice.paid_amt;
                  v_advice.dsp_paid_fcurr_amt := v_advice.paid_amt;
               END IF;
            END IF;
            v_advice.dsp_paid_amt := nvl (v_advice.dsp_paid_amt, 0);
            
            --after the initial paid_amt is retrieve, a new query would be initiated for this option below
           FOR a IN -- this is from the RG in WHEN-CHECKBOX-CHANGED BLOCK:GICL_ADVICE
               (SELECT a.clm_loss_id,
                       DECODE
                          (a.currency_cd,
                           b.currency_cd, a.paid_amt,
                             a.paid_amt
                           * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                          ) paid_amt,                        -- marlo 07162010
                       DECODE
                           (a.currency_cd,
                            b.currency_cd, a.net_amt,
                              a.net_amt
                            * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                           ) net_amt,
                       a.payee_type                               --jen.090706
                  FROM gicl_clm_loss_exp a, gicl_advice b
                 WHERE a.advice_id = v_advice.advice_id
                   AND a.claim_id = v_advice.claim_id
                   AND a.payee_class_cd = v_advice.payee_class_cd
                   AND a.claim_id = b.claim_id
                   AND a.advice_id = b.advice_id)
            LOOP
               v_advice.paid_amt := a.paid_amt;
               v_advice.net_amt := a.net_amt;
               v_advice.clm_loss_id := a.clm_loss_id;
               v_advice.payee_type := a.payee_type;
            END LOOP;

            PIPE ROW (v_advice);
         END LOOP;
      ELSE
         FOR i IN
            (SELECT a.*
               FROM (SELECT   a.line_cd, c.subline_cd,  a.iss_cd, a.advice_year,
                              a.advice_seq_no, a.paid_amt paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) convert_rate,
                              a.advice_flag, a.user_id, a.last_update,
                              a.advice_id, a.claim_id, a.apprvd_tag,
                              a.batch_dv_id, a.paid_fcurr_amt, b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ) conv_rt,
                              
                              -- SUM (b.net_amt) net_amt, SUM (b.paid_amt)
                                     --                                   paid_amt2,
                              b.currency_cd loss_curr_cd, c.clm_stat_cd,
                              a.payee_remarks,
                                 a.line_cd
                              || '-'
                              || a.iss_cd
                              || '-'
                              || a.advice_year
                              || '-'
                              || TO_CHAR (a.advice_seq_no, '000009')
                                                                    advice_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.iss_cd
                              || '-'
                              || clm_yy
                              || '-'
                              || TO_CHAR (c.clm_seq_no, '0000009') claim_no,
                                 c.line_cd
                              || '-'
                              || c.subline_cd
                              || '-'
                              || c.pol_iss_cd
                              || '-'
                              || issue_yy
                              || '-'
                              || TO_CHAR (c.pol_seq_no, '0000009')
                              || '-'
                              || TO_CHAR (c.renew_no, '09') policy_no,
                              c.assd_no, c.assured_name, c.dsp_loss_date,
                              a.advice_date, a.net_fcurr_amt, a.advise_amt,
                              cur.currency_desc, a.net_amt, c.loss_cat_cd,
                              (SELECT loss_cat_des
                                 FROM giis_loss_ctgry
                                WHERE loss_cat_cd =
                                                   c.loss_cat_cd
                                  AND line_cd = a.line_cd) loss_cat_des,
                              (SELECT clm_stat_desc
                                 FROM giis_clm_stat
                                WHERE clm_stat_cd =
                                              c.clm_stat_cd)
                                                            dsp_clm_stat_desc,
                              (SELECT class_desc
                                 FROM giis_payee_class
                                WHERE payee_class_cd =
                                             b.payee_class_cd)
                                                              dsp_payee_class,
                              (SELECT    payee_last_name
                                      || DECODE (payee_first_name,
                                                 NULL, '',
                                                 ', '
                                                )
                                      || payee_first_name
                                      || DECODE (payee_middle_name,
                                                 NULL, '',
                                                 ' '
                                                )
                                      || payee_middle_name pname
                                 FROM giis_payees a
                                WHERE a.payee_no = b.payee_cd
                                  AND a.payee_class_cd = b.payee_class_cd)
                                                                    dsp_payee
                         FROM gicl_claims c,
                              gicl_advice a,
                              gicl_clm_loss_exp b,
                              giis_currency cur
                        WHERE c.claim_id = a.claim_id
                          AND a.advice_flag = 'Y'
                          AND a.claim_id = b.claim_id
                          AND a.advice_id = b.advice_id
                          AND batch_csr_id IS NULL
                          AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                            a.iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ) = 1
                          AND EXISTS (
                                 SELECT 1
                                   FROM gicl_acct_entries d
                                  WHERE d.claim_id = a.claim_id
                                    AND d.advice_id = a.advice_id
                                    AND d.payee_class_cd = b.payee_class_cd
                                    AND d.payee_cd = b.payee_cd)
                          AND a.batch_dv_id IS NULL
                          AND a.claim_id = NVL (p_claim_id, a.claim_id)
                          AND (a.apprvd_tag = 'N' OR a.apprvd_tag IS NULL)
                          AND a.claim_id IN (
                                 SELECT claim_id
                                   FROM gicl_claims
                                  WHERE clm_stat_cd NOT IN
                                                     ('CD', 'WD', 'CC', 'DN'))
                          AND a.currency_cd = cur.main_currency_cd
                     GROUP BY a.line_cd,
                              a.iss_cd,
                              a.advice_year,
                              a.advice_seq_no,
                              a.paid_amt,
                              a.currency_cd,
                              DECODE (a.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              a.advice_flag,
                              a.user_id,
                              a.last_update,
                              a.advice_id,
                              a.claim_id,
                              a.apprvd_tag,
                              a.batch_dv_id,
                              a.paid_fcurr_amt,
                              b.payee_cd,
                              b.payee_class_cd,              /*b.payee_type,*/
                              DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      a.convert_rate
                                     ),
                              b.currency_cd,
                              c.clm_stat_cd,
                              a.payee_remarks,
                              c.line_cd,
                              c.subline_cd,
                              c.pol_iss_cd,
                              issue_yy,
                              c.clm_seq_no,
                              c.iss_cd,
                              clm_yy,
                              c.pol_seq_no,
                              c.renew_no,
                              c.assd_no,
                              c.assured_name,
                              c.dsp_loss_date,
                              a.advice_date,
                              a.net_fcurr_amt,
                              a.advise_amt,
                              cur.currency_desc,
                              a.net_amt,
                              c.loss_cat_cd) a
              -- start of filters
             WHERE  UPPER (a.assured_name) LIKE
                                  UPPER (NVL (p_assured_name, a.assured_name))
                AND UPPER (a.dsp_clm_stat_desc) LIKE
                        UPPER (NVL (p_dsp_clm_stat_desc, a.dsp_clm_stat_desc))
                AND TRUNC (a.dsp_loss_date) =
                       TRUNC (NVL (TO_DATE (p_loss_date, 'MM-DD-YYYY'),
                                   a.dsp_loss_date
                                  )
                             )
                AND UPPER (a.loss_cat_des) LIKE
                              UPPER (NVL (p_dsp_loss_cat_des, a.loss_cat_des))
                AND UPPER (a.dsp_payee_class) LIKE
                            UPPER (NVL (p_dsp_payee_class, a.dsp_payee_class))
                AND UPPER (a.dsp_payee) LIKE
                                        UPPER (NVL (p_dsp_payee, a.dsp_payee))
                AND UPPER (a.currency_desc) LIKE
                                UPPER (NVL (p_currency_desc, a.currency_desc))
                AND UPPER (a.convert_rate) LIKE
                                  UPPER (NVL (p_convert_rate, a.convert_rate))
                                  AND UPPER (a.line_cd) LIKE
                                         UPPER (NVL (p_line_cd, a.line_cd))
               AND UPPER (a.iss_cd) LIKE
                                           UPPER (NVL (p_iss_cd, a.iss_cd))
               AND UPPER (a.subline_cd) LIKE
                                   UPPER (NVL (p_subline_cd, a.subline_cd))
               AND UPPER (a.advice_year) LIKE
                                 UPPER (NVL (p_advice_year, a.advice_year))
               AND UPPER (a.advice_seq_no) LIKE
                             UPPER (NVL (p_advice_seq_no, a.advice_seq_no))
                                  )
         LOOP
            v_advice.batch_dv_id := i.batch_dv_id;
            v_advice.claim_id := i.claim_id;
            v_advice.line_cd := i.line_cd;
            v_advice.iss_cd := i.iss_cd;
            v_advice.advice_year := i.advice_year;
            v_advice.advice_seq_no := i.advice_seq_no;
            v_advice.advice_id := i.advice_id;
            v_advice.advice_flag := i.advice_flag;
            v_advice.apprvd_tag := i.apprvd_tag;
            v_advice.advice_no := i.advice_no;
            v_advice.claim_no := i.claim_no;
            v_advice.policy_no := i.policy_no;
            v_advice.assd_no := i.assd_no;
            v_advice.assured_name := i.assured_name;
            v_advice.dsp_loss_date := i.dsp_loss_date;
            v_advice.advice_date := i.advice_date;
            v_advice.paid_amt := i.paid_amt;
            v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
            v_advice.net_amt := i.net_amt;
            v_advice.net_fcurr_amt := i.net_fcurr_amt;
            v_advice.advise_amt := i.advise_amt;
            v_advice.currency_cd := i.currency_cd;
            v_advice.currency_desc := i.currency_desc;
            v_advice.convert_rate := i.convert_rate;
            v_advice.dsp_loss_cat_des := i.loss_cat_des;
            v_advice.loss_cat_cd := i.loss_cat_cd;
            v_advice.clm_stat_cd := i.clm_stat_cd;
            v_advice.dsp_clm_stat_desc := i.dsp_clm_stat_desc;
            v_advice.payee_class_cd := i.payee_class_cd;
            v_advice.payee_cd := i.payee_cd;
            v_advice.dsp_payee_class := i.dsp_payee_class;
            v_advice.conv_rt := i.conv_rt;
            v_advice.loss_curr_cd := i.loss_curr_cd;
            v_advice.dsp_payee := i.dsp_payee;
            v_advice.generate_sw := 'N';
            v_advice.payee_remarks := i.payee_remarks;

            --v_advice.clm_loss_id := i.clm_loss_id;
   
            IF v_advice.currency_cd = giacp.n ('CURRENCY_CD')
            THEN
    
               v_advice.dsp_paid_amt := (v_advice.paid_amt * v_advice.conv_rt);
               v_advice.dsp_paid_fcurr_amt :=
                                         (v_advice.paid_amt * v_advice.conv_rt);
                                    v_advice.dsp_paid_amt := v_advice.paid_amt;      
            ELSE
           
               IF v_advice.loss_curr_cd = giacp.n ('CURRENCY_CD')
               THEN
                  v_advice.dsp_paid_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
                  v_advice.dsp_paid_fcurr_amt :=
                                         v_advice.paid_amt / v_advice.conv_rt;
               ELSE
                  v_advice.dsp_paid_amt := v_advice.paid_amt;
                  v_advice.dsp_paid_fcurr_amt := v_advice.paid_amt;
               END IF;
            END IF;
            v_advice.dsp_paid_amt := nvl (v_advice.dsp_paid_amt, 0);
           
         
            --after the initial paid_amt is retrieve, a new query would be initiated for this option below 
            FOR a IN -- this is from the RG in WHEN-CHECKBOX-CHANGED BLOCK:GICL_ADVICE
               (SELECT a.clm_loss_id,
                       DECODE
                          (a.currency_cd,
                           b.currency_cd, a.paid_amt,
                             a.paid_amt
                           * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                          ) paid_amt,                        -- marlo 07162010
                       DECODE
                           (a.currency_cd,
                            b.currency_cd, a.net_amt,
                              a.net_amt
                            * NVL (b.orig_curr_rate /*a.currency_rate*/, 0)
                           ) net_amt,
                       a.payee_type                               --jen.090706
                  FROM gicl_clm_loss_exp a, gicl_advice b
                 WHERE a.advice_id = v_advice.advice_id
                   AND a.claim_id = v_advice.claim_id
                   AND a.payee_class_cd = v_advice.payee_class_cd
                   AND a.claim_id = b.claim_id
                   AND a.advice_id = b.advice_id)
            LOOP
               v_advice.paid_amt := a.paid_amt;
               v_advice.net_amt := a.net_amt;
               v_advice.clm_loss_id := a.clm_loss_id;
               v_advice.payee_type := a.payee_type;
            END LOOP;

            PIPE ROW (v_advice);
         END LOOP;
      END IF;
   END;

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.22.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves list of records from gicl_advice for approval of Batch CSR
   **
   */
   FUNCTION get_advice_list_for_approval (
      p_batch_csr_id   gicl_batch_csr.batch_csr_id%TYPE
   )
      RETURN gicl_advice_tab PIPELINED
   AS
      v_advice   gicl_advice_type;
   BEGIN
      FOR i IN (SELECT   b.claim_id, b.advice_id, a.payee_class_cd,
                         a.payee_cd
                    FROM gicl_clm_loss_exp a, gicl_advice b
                   WHERE a.advice_id = b.advice_id
                     AND b.batch_csr_id = p_batch_csr_id
                GROUP BY b.claim_id, b.advice_id, a.payee_class_cd,
                         a.payee_cd)
      LOOP
         v_advice.claim_id := i.claim_id;
         v_advice.advice_id := i.advice_id;
         v_advice.payee_class_cd := i.payee_class_cd;
         v_advice.payee_cd := i.payee_cd;
         PIPE ROW (v_advice);
      END LOOP;
   END;


   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  01.12.2012
   **  Reference By : (GICLS032 - Claim Advice)
   **  Description  : Retrieves list of records from gicl_advice for claim advice
   **
   */   
  FUNCTION get_gicls032_clm_advice_list(
    p_claim_id GICL_CLAIMS.claim_id%TYPE
  ) RETURN gicls032_advice_tab PIPELINED IS
    
    v_advice gicls032_advice_type;
  BEGIN
    FOR i IN(
        SELECT a.advice_id, a.claim_id, a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no, a.advice_date, a.advice_flag, 
               a.currency_cd, b.currency_desc, a.advise_amt, a.paid_amt, a.net_amt, a.adv_fcurr_amt, a.paid_fcurr_amt, a.net_fcurr_amt, 
               a.convert_rate, a.apprvd_tag, a.adv_fla_id,
               a.line_cd || '-' || a.iss_cd || '-' || a.advice_year || '-' || TRIM(TO_CHAR(a.advice_seq_no, '000009')) advice_no,
               a.remarks, a.payee_remarks, a.batch_csr_id, a.batch_dv_id    
          FROM GICL_ADVICE a
              ,giis_currency b
         WHERE a.claim_id = p_claim_id
           AND a.advice_flag = 'Y'
           AND b.main_currency_cd = a.currency_cd
         ORDER BY a.advice_id
      )
    LOOP
      v_advice.advice_id := i.advice_id;
      v_advice.claim_id := i.claim_id;
      v_advice.line_cd := i.line_cd;
      v_advice.iss_cd := i.iss_cd;
      v_advice.advice_year := i.advice_year;
      v_advice.advice_seq_no := i.advice_seq_no;
      v_advice.advice_date := i.advice_date;
      v_advice.advice_flag := i.advice_flag;
      v_advice.currency_cd := i.currency_cd;
      v_advice.currency_desc := i.currency_desc;
      v_advice.advise_amt := i.advise_amt;
      v_advice.paid_amt := i.paid_amt;
      v_advice.net_amt := i.net_amt;
      v_advice.adv_fcurr_amt := i.adv_fcurr_amt;
      v_advice.paid_fcurr_amt := i.paid_fcurr_amt;
      v_advice.net_fcurr_amt := i.net_fcurr_amt;
      v_advice.convert_rate := i.convert_rate;
      v_advice.advice_no := i.advice_no;
      v_advice.remarks := i.remarks;
      v_advice.payee_remarks := i.payee_remarks;
      v_advice.apprvd_tag := i.apprvd_tag;
      v_advice.adv_fla_id := i.adv_fla_id;
      v_advice.batch_csr_id := i.batch_csr_id;
      v_advice.batch_dv_id := i.batch_dv_id;
      
      IF i.batch_csr_id IS NOT NULL THEN
        v_advice.batch_no := 'BCSR No.: ' || gicl_batch_csr_pkg.get_bcsr_no(i.batch_csr_id);
      ELSIF i.batch_dv_id IS NOT NULL THEN
        v_advice.batch_no := 'SCSR No.: ' || giac_batch_dv_pkg.get_scsr_no(i.batch_dv_id);
      END IF;
      
      PIPE ROW(v_advice);
    END LOOP;
    RETURN;
  END get_gicls032_clm_advice_list;
  
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.08.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Checks if record exist in GICL_ADVICE
   **                  with the given claim id.
   */ 
   
    FUNCTION check_exist_gicl_advice
    (p_claim_id     IN   GICL_ADVICE.claim_id%TYPE)
     
     RETURN VARCHAR2 AS
     
     v_exist    VARCHAR2(1) := 'N';
     
    BEGIN
        FOR i IN (SELECT 1 FROM GICL_ADVICE     
                   WHERE claim_id = p_claim_id)
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        RETURN v_exist;
    END check_exist_gicl_advice;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.15.2012
    **  Reference By  : GICLS030 - Loss/Recovery History
    **  Description   : Gets the list of cancelled gicl_advice 
    **                  records with the given the claim_id
    */ 

    FUNCTION get_cancelled_gicl_advice_list(p_claim_id  GICL_ADVICE.claim_id%TYPE)
    RETURN cancelled_advice_tab PIPELINED AS

    v_cancel_adv        cancelled_advice_type;

    BEGIN
        FOR i IN(SELECT a.advice_id,     a.claim_id,         a.line_cd,      a.iss_cd, 
                        a.advice_year,   a.advice_seq_no,    a.user_id,      a.last_update,
                        a.line_cd
                       ||' - '
                       ||a.iss_cd
                       ||' - '
                       ||TO_CHAR(a.advice_year)
                       ||' - '
                       ||TO_CHAR(a.advice_seq_no,'00009') cancel_adv_no
                FROM GICL_ADVICE a
                WHERE a.claim_id = p_claim_id
                  AND a.advice_flag = 'N')
         LOOP
            v_cancel_adv.advice_id      := i.advice_id;          
            v_cancel_adv.claim_id       := i.claim_id;         
            v_cancel_adv.line_cd        := i.line_cd;        
            v_cancel_adv.iss_cd         := i.iss_cd;         
            v_cancel_adv.advice_year    := i.advice_year;   
            v_cancel_adv.advice_seq_no  := i.advice_seq_no;     
            v_cancel_adv.advice_no      := i.cancel_adv_no;     
            v_cancel_adv.user_id        := i.user_id;     
            v_cancel_adv.last_update    := i.last_update;
            
            PIPE ROW(v_cancel_adv);
                 
         END LOOP;
    END get_cancelled_gicl_advice_list;


   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  03.15.2012
   **  Reference By : (GICLS032 - Claim Advice)
   **  Description  : Updates the advice remarks
   **
   */     
  PROCEDURE update_remarks(
    p_claim_id  gicl_advice.claim_id%TYPE,
    p_advice_id gicl_advice.advice_id%TYPE,
    p_remarks   gicl_advice.remarks%TYPE
  ) IS
  BEGIN
    UPDATE gicl_advice
       SET remarks = p_remarks
     WHERE claim_id = p_claim_id
       AND advice_id = p_advice_id;        
  END update_remarks;     
    
  
  /*
   **  Created by   :  D.Alcantara
   **  Date Created :  03.22.2012
   **  Reference By : (GIACS017 -  Direct Claims Collections)
   **  Description  : 
   */
  FUNCTION get_advice_list_giacs017 (
     p_line_cd              GICL_ADVICE.line_cd%TYPE,
     p_iss_cd               GICL_ADVICE.iss_cd%TYPE,
     p_advice_year          GICL_ADVICE.advice_year%TYPE,
     p_advice_seq_no        GICL_ADVICE.advice_seq_no%TYPE,
     p_ri_iss_cd            GICL_ADVICE.iss_cd%TYPE,
     p_tran_type            GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
     p_module_id            GIIS_MODULES.module_id%TYPE,
     p_user_id              GIIS_USERS.user_id%TYPE
  ) RETURN giacs017_advice_list_tab PIPELINED IS
  
      v_claim           giacs017_advice_list_type;
  
      CURSOR a IS
        SELECT DISTINCT
                        gicl_advice.line_cd, gicl_advice.iss_cd, gicl_advice.advice_year, gicl_advice.advice_seq_no, 
                        gicl_advice.advice_id, gicl_advice.claim_id, (gicl_clm_loss_exp.paid_amt * gicl_clm_loss_exp.currency_rate) paid_amt,--added conversion reymon 04262013 
                        giis_payees.payee_last_name||' '||giis_payees.payee_first_name||' '||giis_payees.payee_middle_name payee_name,
                        gicl_clm_loss_exp.clm_loss_id, 
                        gicl_clm_loss_exp.payee_type, 
                        DECODE(gicl_clm_loss_exp.payee_type,'L','Loss','E','Expense') p_type, 
                        gicl_clm_loss_exp.payee_class_cd, 
                        gicl_clm_loss_exp.payee_cd,
                        gicl_clm_loss_exp.peril_cd,
                        (gicl_clm_loss_exp.net_amt * nvl(gicl_advice.convert_rate,1)) net_amt,
                        (NVL(gicl_clm_loss_exp.paid_amt * gicl_clm_loss_exp.currency_rate,0)*1) net_disb_amt, --added conversion reymon 04262013
                        giis_peril.peril_sname
            FROM gicl_advice,
                     giis_payees,
                     gicl_clm_loss_exp,
                     giis_peril	 			  
         WHERE NVL(gicl_advice.advice_flag,'Y') = 'Y' 
             AND NVL(gicl_advice.apprvd_tag,'N') = 'N' 
             AND gicl_advice.advice_id = gicl_clm_loss_exp.advice_id
             AND gicl_advice.claim_id = gicl_clm_loss_exp.claim_id
             AND giis_payees.payee_class_cd = gicl_clm_loss_exp.payee_class_cd
             AND giis_payees.payee_no = gicl_clm_loss_exp.payee_cd
             AND gicl_clm_loss_exp.peril_cd = giis_peril.peril_cd 
             AND giis_peril.line_cd = gicl_advice.line_cd
             AND gicl_clm_loss_exp.tran_id IS NULL
             AND gicl_advice.batch_csr_id IS NULL
             AND gicl_advice.batch_dv_id IS NULL
             AND gicl_advice.iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,gicl_advice.iss_cd, p_module_id, p_user_id),1,gicl_advice.iss_cd,NULL)
             AND gicl_advice.iss_cd != p_ri_iss_cd 
             AND gicl_advice.line_cd = nvl(p_line_cd, gicl_advice.line_cd)
             AND gicl_advice.iss_cd = nvl(p_iss_cd, gicl_advice.iss_cd)
             AND gicl_advice.advice_year = nvl(p_advice_year, gicl_advice.advice_year) 
             AND gicl_advice.advice_seq_no = nvl(p_advice_seq_no, gicl_advice.advice_seq_no) 
       ORDER BY gicl_advice.line_cd, gicl_advice.iss_cd, gicl_advice.advice_year, gicl_advice.advice_seq_no;
       
     CURSOR B IS
        SELECT DISTINCT
                        gicl_advice.line_cd, gicl_advice.iss_cd, gicl_advice.advice_year, gicl_advice.advice_seq_no, 
                        gicl_advice.advice_id, gicl_advice.claim_id, (gicl_clm_loss_exp.paid_amt * gicl_clm_loss_exp.currency_rate) paid_amt,--added conversion reymon 04262013 
                        giis_payees.payee_last_name||' '||giis_payees.payee_first_name||' '||giis_payees.payee_middle_name payee_name,
                        gicl_clm_loss_exp.clm_loss_id, 
                        gicl_clm_loss_exp.payee_type, 
                        DECODE(gicl_clm_loss_exp.payee_type,'L','Loss','E','Expense') p_type, 
                        gicl_clm_loss_exp.payee_class_cd, 
                        gicl_clm_loss_exp.payee_cd,
                        gicl_clm_loss_exp.peril_cd,
                        (gicl_clm_loss_exp.net_amt * nvl(gicl_advice.convert_rate,1))*-1 net_amt,
                        (NVL(gicl_clm_loss_exp.paid_amt * gicl_clm_loss_exp.currency_rate,0)*-1) net_disb_amt,--added comversoion reymon 04262013 
                        giis_peril.peril_sname
            FROM giis_payees, gicl_clm_loss_exp, gicl_advice, giis_peril
         WHERE gicl_clm_loss_exp.payee_cd = giis_payees.payee_no 
             AND gicl_clm_loss_exp.payee_class_cd = giis_payees.payee_class_cd
             AND gicl_advice.claim_id = gicl_clm_loss_exp.claim_id
             AND gicl_clm_loss_exp.advice_id = gicl_advice.advice_id
             AND gicl_clm_loss_exp.tran_id is not null 
             AND NOT EXISTS (SELECT '1' 
                                                 FROM giac_reversals x, giac_acctrans y 
                                                WHERE x.reversing_tran_id = y.tran_id 
                                            AND x.gacc_tran_id = gicl_clm_loss_exp.tran_id
                                                    AND y.tran_flag <> 'D') 
             AND gicl_clm_loss_exp.payee_cd = giis_payees.payee_no 
             AND gicl_clm_loss_exp.payee_class_cd = giis_payees.payee_class_cd 
             AND gicl_clm_loss_exp.peril_cd = giis_peril.peril_cd 
             AND giis_peril.line_cd = gicl_advice.line_cd
             AND giis_peril.line_cd = NVL(p_line_cd, giis_peril.line_cd)
             AND gicl_advice.batch_csr_id IS NULL
             AND gicl_advice.batch_dv_id IS NULL
             AND gicl_advice.iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,gicl_advice.iss_cd, p_module_id, p_user_id),1,gicl_advice.iss_cd,NULL) 
             AND gicl_advice.iss_cd != p_ri_iss_cd
             AND gicl_advice.line_cd = nvl(p_line_cd, gicl_advice.line_cd)
             AND gicl_advice.iss_cd = nvl(p_iss_cd, gicl_advice.iss_cd)
             AND gicl_advice.advice_year = nvl(p_advice_year, gicl_advice.advice_year) 
             AND gicl_advice.advice_seq_no = nvl(p_advice_seq_no, gicl_advice.advice_seq_no) 
         ORDER BY gicl_advice.line_cd, gicl_advice.iss_cd, gicl_advice.advice_year, gicl_advice.advice_seq_no;
  BEGIN

    IF p_tran_type = 1 THEN
		 FOR a_rec IN a LOOP
            v_claim.advice_id      			:= a_rec.advice_id;--added by reymon 04242013
            v_claim.iss_cd      			:= a_rec.iss_cd;
            v_claim.advice_year      	    := a_rec.advice_year;
            v_claim.line_cd     			:= a_rec.line_cd;
            v_claim.advice_seq_no    	    := a_rec.advice_seq_no;
            v_claim.paid_amt				:= a_rec.paid_amt;
            v_claim.dsp_payee				:= a_rec.payee_name;
            v_claim.dsp_p_type				:= a_rec.p_type;
            v_claim.payee_class_cd			:= a_rec.payee_class_cd;
            v_claim.peril_sname				:= a_rec.peril_sname;
            v_claim.net_amt					:= a_rec.net_amt;
            v_claim.net_disb_amt			:= a_rec.net_disb_amt;
            v_claim.payee_cd				:= a_rec.payee_cd;
            v_claim.claim_id				:= a_rec.claim_ID;
            v_claim.clm_loss_id				:= a_rec.clm_loss_id;
            v_claim.payee_type				:= a_rec.payee_type;
            v_claim.dsp_advice_no           := a_rec.line_cd||' - '||a_rec.iss_cd||' - '||
                                               a_rec.advice_year||' - '||TO_CHAR(a_rec.advice_seq_no, '00009');   		
			--next_record;	
            PIPE ROW(v_claim);
		 END LOOP;		
		 RETURN; 	
	ELSIF p_tran_type = 2 THEN
	   FOR b_rec IN b LOOP
		    v_claim.advice_id      			:= b_rec.advice_id;--added by reymon 04242013
            v_claim.iss_cd      			:= b_rec.iss_cd;
            v_claim.advice_year      	    := b_rec.advice_year;
            v_claim.line_cd     			:= b_rec.line_cd;
            v_claim.advice_seq_no    	    := b_rec.advice_seq_no;
            v_claim.paid_amt				:= b_rec.paid_amt;
            v_claim.dsp_payee				:= b_rec.payee_name;
            v_claim.dsp_p_type				:= b_rec.p_type;
            v_claim.payee_class_cd			:= b_rec.payee_class_cd;
            v_claim.peril_sname				:= b_rec.peril_sname;
            v_claim.net_amt					:= b_rec.net_amt;
            v_claim.net_disb_amt			:= b_rec.net_disb_amt;
            v_claim.payee_cd				:= b_rec.payee_cd;
            v_claim.claim_id				:= b_rec.claim_ID;
            v_claim.clm_loss_id				:= b_rec.clm_loss_id;
            v_claim.payee_type				:= b_rec.payee_type;
            v_claim.dsp_advice_no           := b_rec.line_cd||' - '||b_rec.iss_cd||' - '||
                                               b_rec.advice_year||' - '||TO_CHAR(b_rec.advice_seq_no, '00009');		   		
			--next_record;	
            PIPE ROW(v_claim);
			RETURN; 	
		 END LOOP;
	 END IF;
  END get_advice_list_giacs017;
    
  
  /*
   **  Created by   :  Andrew Robes
   **  Date Created :  03.23.2012
   **  Reference By : (GIACS032 - Generate Advice)
   **  Description  : Procedure to revert advice, called from gicls032_initialize
   */  
    PROCEDURE revert_advice (p_claim_id gicl_advice.claim_id%TYPE)
    IS
       v_advice   gicl_advice.advice_id%TYPE;
    BEGIN
       BEGIN
          SELECT MAX (advice_id)
            INTO v_advice
            FROM gicl_advice
           WHERE claim_id = p_claim_id;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             NULL;
       END;

       DELETE FROM gicl_advice
             WHERE advice_id = v_advice 
               AND claim_id = p_claim_id;

       UPDATE gicl_clm_loss_exp
          SET advice_id = NULL
        WHERE advice_id = v_advice 
          AND claim_id = p_claim_id;
          
    END revert_advice;  
 
   /*
   **  Created by   :  Marco Paolo Rebong
   **  Date Created :  03.29.2012
   **  Reference By : (GICLS033 - Final Loss Advice)
   **  Description  : Get Final Loss Advice List
   */  
    FUNCTION get_final_loss_advice_list(
        p_claim_id              GICL_CLAIMS.claim_id%TYPE
    )
    RETURN final_loss_advice_tab PIPELINED AS
        v_fla                   final_loss_advice_type;
    BEGIN
        FOR i IN(SELECT a.advice_id, a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no,
                        a.paid_amt, a.net_amt, a.advise_amt, a.currency_cd, a.adv_fla_id,
                        b.currency_desc,
                        a.line_cd||'-'||a.iss_cd||'-'||a.advice_year||'-'||LTRIM(TO_CHAR(a.advice_seq_no, '000009')) advice_no
                   FROM GICL_ADVICE a,
                        GIIS_CURRENCY b
                  WHERE a.claim_id = p_claim_id
                    AND a.currency_cd = b.main_currency_cd
                    AND a.advice_flag != 'N')
        LOOP
            v_fla.advice_id := i.advice_id;
            v_fla.advice_no := i.advice_no;
            v_fla.line_cd := i.line_cd;
            v_fla.iss_cd := i.iss_cd;
            v_fla.advice_year := i.advice_year;
            v_fla.advice_seq_no := i.advice_seq_no;
            v_fla.currency_cd := i.currency_cd;
            v_fla.currency_desc := i.currency_desc;
            v_fla.paid_amt := i.paid_amt;
            v_fla.net_amt := i.net_amt;
            v_fla.advise_amt := i.advise_amt;
            v_fla.adv_fla_id := i.adv_fla_id;
            BEGIN
                SELECT DISTINCT 'Y' exist
                  INTO v_fla.generate_sw
                  FROM gicl_advice          
                 WHERE claim_id = p_claim_id
                   AND advice_id = i.advice_id
                   AND adv_fla_id IS NOT NULL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_fla.generate_sw := 'N';
            END;
            PIPE ROW(v_fla);
        END LOOP;
    END;

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : March 30, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Checks if FLA is already generated
    */
    FUNCTION check_generated_fla(
        p_claim_id              GICL_ADVICE.claim_id%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE
    )
    RETURN VARCHAR2 AS
        v_exist                 VARCHAR2(1) := NULL;
    BEGIN
        SELECT DISTINCT 'Y' exist
          INTO v_exist
          FROM gicl_advice          
         WHERE claim_id = p_claim_id
           AND advice_id = p_advice_id
           AND adv_fla_id IS NOT NULL;
        RETURN v_exist;
    END;
	
	/*
    ** Created by    : Veronica V. Raymundo
    ** Created date  : April 1, 2013
    ** Referenced by : GICLS260 - Claim Information
    ** Description   : Gets the gicl_advice record for a particular loss expense history
    */
	
	FUNCTION get_gicls260_advice(
		p_claim_id              GICL_CLAIMS.claim_id%TYPE,
		p_iss_cd				GICL_CLAIMS.iss_cd%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE,
		p_clm_loss_id			GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
		p_hist_seq_no			GICL_CLM_LOSS_EXP.hist_seq_no%TYPE
	)
 	 RETURN gicls260_advice_tab PIPELINED AS
	
		v_advice			gicls260_advice_type;
		v_ri_cd				GIIS_PARAMETERS.param_value_v%TYPE;
		
	BEGIN
		
		BEGIN
		 	SELECT GIISP.v('ISS_CD_RI') ri 
		 	INTO v_ri_cd
		 	FROM dual;
		EXCEPTION
           WHEN NO_DATA_FOUND THEN
			 v_ri_cd := 'RI';
		END;
		
		IF p_iss_cd = v_ri_cd THEN
			 FOR i IN (SELECT DISTINCT a.document_cd||'-'||a.branch_cd||'-'||a.line_cd
							  ||TO_CHAR(a.doc_year)||'-'||TO_CHAR(a.doc_mm)||'-'
							  ||TO_CHAR(a.doc_seq_no) CSR_NO
						 FROM giac_payt_requests a, 
						      giac_payt_requests_dtl b, 
							  giac_inw_claim_payts c 
						WHERE a.ref_id = b.gprq_ref_id 
						  AND b.tran_id = c.gacc_tran_id
						  AND b.payt_req_flag <> 'X'     
						  AND claim_id = p_claim_id
						  AND advice_id = p_advice_id) 
			 LOOP
			   v_advice.csr_no := i.csr_no;
			 END LOOP;
		
		ELSIF p_iss_cd <> v_ri_cd THEN
			FOR i IN (SELECT DISTINCT a.document_cd||'-'||a.branch_cd||'-'||a.line_cd
							 ||'-'||TO_CHAR(a.doc_year)||'-'||TO_CHAR(a.doc_mm)||'-'
							 ||TO_CHAR(a.doc_seq_no) CSR_NO
						FROM giac_payt_requests a, 
						     giac_payt_requests_dtl b, 
							 giac_direct_claim_payts c 
					   WHERE a.ref_id = b.gprq_ref_id 
						 AND b.tran_id = c.gacc_tran_id
						 AND b.payt_req_flag <> 'X'     
						 AND claim_id = p_claim_id
						 AND ADVICE_ID = p_advice_id) 
			 LOOP
			   v_advice.csr_no := i.csr_no;
			 END LOOP;
		END IF;
		
		FOR i IN (SELECT a.claim_id, a.advice_id, a.line_cd,
		                 a.iss_cd, a.advice_year, a.advice_seq_no, 
						 a.user_id, a.last_update, 
		                 a.line_cd||' - '||a.iss_cd||' - '
		                 ||TO_CHAR(a.advice_year)||' - '
						 ||TO_CHAR(a.advice_seq_no) advice_no
              	   FROM gicl_advice a, gicl_clm_loss_exp b
             	  WHERE a.advice_id = b.advice_id 
               		AND a.claim_id = b.claim_id 
               		AND a.claim_id = p_claim_id
               		AND a.advice_id = p_advice_id
               		AND b.hist_seq_no = p_hist_seq_no
               		AND b.clm_loss_id = p_clm_loss_id)
	  LOOP
		v_advice.advice_no 		:= i.advice_no;
		v_advice.advice_id      := i.advice_id;     
        v_advice.claim_id       := i.advice_id;     
      	v_advice.line_cd        := i.line_cd;     
      	v_advice.iss_cd         := i.iss_cd;     
      	v_advice.advice_year    := i.advice_year;     
      	v_advice.advice_seq_no  := i.advice_seq_no;     
      	v_advice.user_id        := i.user_id;     
      	v_advice.last_update    := i.last_update;     
	  END LOOP;
	  
	  PIPE ROW(v_advice);
	  
	END get_gicls260_advice;				

END gicl_advice_pkg;
/



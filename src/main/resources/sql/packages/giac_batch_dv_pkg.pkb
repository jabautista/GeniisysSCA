CREATE OR REPLACE PACKAGE BODY CPI.giac_batch_dv_pkg
AS
   FUNCTION get_special_csr_listing (
      p_fund_cd           giac_batch_dv.fund_cd%TYPE,
      p_branch_cd         giac_batch_dv.branch_cd%TYPE,
      p_batch_year        giac_batch_dv.batch_year%TYPE,
      p_batch_mm          giac_batch_dv.batch_mm%TYPE,
      p_batch_seq_no      giac_batch_dv.batch_seq_no%TYPE,
      p_batch_date        VARCHAR2,
      p_user_id           VARCHAR2,
      p_dsp_payee_class   giis_payee_class.class_desc%TYPE,
      p_particulars       giac_batch_dv.particulars%TYPE,
      p_fcurr_amt         giac_batch_dv.fcurr_amt%TYPE,
      p_paid_amt          giac_batch_dv.paid_amt%TYPE,
      p_dsp_currency      VARCHAR2,
      p_claim_id          gicl_claims.claim_id%type
   )
      RETURN giac_batch_dv_tab PIPELINED
   IS
      v_batch       giac_batch_dv_type;
      v_branch_cd   VARCHAR2(50); --giis_user_grp_hdr.grp_iss_cd%TYPE;
      v_cnt         NUMBER                              := 0;
   BEGIN
      IF p_branch_cd IS NULL
      THEN
         BEGIN
            FOR rec IN (SELECT a.grp_iss_cd grp_iss_cd
                          FROM giis_user_grp_hdr a, giis_users b
                         WHERE a.user_grp = b.user_grp
                           AND b.user_id LIKE p_user_id)
            LOOP
               v_branch_cd := rec.grp_iss_cd;
            END LOOP;
         END;
      ELSE
         v_branch_cd := p_branch_cd;
      END IF;

      FOR i IN
         (SELECT a.*
            FROM (SELECT a.*,
                         (   a.fund_cd
                          || '-'
                          || a.branch_cd
                          || '-'
                          || a.batch_year
                          || '-'
                          || TO_CHAR (a.batch_mm, '09')
                          || '-'
                          || TO_CHAR (a.batch_seq_no, '0999999') --modified by carloR SR-5653 09.27.2016
                         ) batch_no,
                         (SELECT class_desc
                            FROM giis_payee_class
                           WHERE payee_class_cd =
                                             a.payee_class_cd)
                                                              dsp_payee_class,
                         (SELECT currency_desc
                            FROM giis_currency
                           WHERE main_currency_cd = 
                                                   a.currency_cd)
                                                                 dsp_currency
                    FROM giac_batch_dv a
                   WHERE batch_flag != 'X'
                     AND NOT EXISTS (
                             SELECT '1'
                               FROM giac_payt_requests_dtl
                              WHERE payt_req_flag = 'C'
                                    AND tran_id = a.tran_id)
                     AND EXISTS (SELECT *
                                   FROM giac_batch_dv_dtl b
                                  WHERE b.batch_dv_id = a.batch_dv_id
                                                                     AND b.claim_id = NVL (p_claim_id, b.claim_id)
                         )
                     AND check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, 'GIACS016', p_user_id) = 1 -- andrew 05.16.2013 - user access should be based on the maintained accessible branches, not only on the default grp_iss_cd
                     AND a.branch_cd = NVL(p_branch_cd, get_branch_cd_ho (p_user_id))                         
                         ) a
           -- filters starts here
           -- marco - 05.06.2013 - removed wildcard for filters and added UPPER
           WHERE UPPER(a.fund_cd) LIKE UPPER(NVL(p_fund_cd, a.fund_cd))
             AND UPPER(a.branch_cd) LIKE UPPER(NVL(p_branch_cd, a.branch_cd))
             AND a.batch_year LIKE NVL (p_batch_year, a.batch_year)
             AND a.batch_mm LIKE NVL (p_batch_mm, a.batch_mm)
             AND a.batch_seq_no LIKE NVL (p_batch_seq_no, a.batch_seq_no)
             AND TRUNC (a.batch_date) =
                    TRUNC (NVL (TO_DATE (p_batch_date, 'MM-DD-YYYY'),
                                a.batch_date
                               )
                          )
             AND UPPER(a.dsp_payee_class) LIKE UPPER(NVL(p_dsp_payee_class, a.dsp_payee_class))
             AND UPPER(NVL(a.particulars, '%')) LIKE UPPER(NVL(p_particulars, NVL(a.particulars, '%'))) --marco - 05.06.2013 - NVL for particulars
             AND a.fcurr_amt LIKE NVL (p_fcurr_amt, a.fcurr_amt) 
             AND a.paid_amt LIKE NVL (p_paid_amt, a.paid_amt)
             --AND UPPER(a.dsp_currency) LIKE UPPER(NVL(p_dsp_currency, a.dsp_currency)))
             AND UPPER(NVL(a.dsp_currency,1)) LIKE UPPER(NVL(p_dsp_currency, NVL(a.dsp_currency,1)))) -- bonok :: 05.11.2013 - to handle records in GIAC_BATCH_DV with no currency_cd 
      LOOP
         v_batch.batch_dv_id := i.batch_dv_id;
         v_batch.fund_cd := i.fund_cd;
         v_batch.branch_cd := i.branch_cd;
         v_batch.batch_year := i.batch_year;
         v_batch.batch_mm := i.batch_mm;
         v_batch.batch_seq_no := i.batch_seq_no;
         v_batch.batch_date := TO_CHAR (i.batch_date, 'MM-DD-YYYY');
         v_batch.batch_flag := i.batch_flag;
         v_batch.payee_class_cd := i.payee_class_cd;
         v_batch.payee_cd := i.payee_cd;
         --v_batch.particulars := escape_value (i.particulars); commented out and remove escape_value reymon 04292013
         v_batch.particulars := i.particulars;
         v_batch.tran_id := i.tran_id;
         v_batch.paid_amt := i.paid_amt;
         v_batch.fcurr_amt := i.fcurr_amt;
         v_batch.currency_cd := i.currency_cd;
         v_batch.convert_rate := i.convert_rate;
         v_batch.user_id := i.user_id;
         v_batch.last_update := i.last_update;
         --v_batch.payee_remarks := escape_value (i.payee_remarks); commented out and remove escape_value reymon 04292013
         v_batch.payee_remarks := i.payee_remarks;
         v_batch.batch_no := i.batch_no;
         v_batch.dsp_payee_class := i.dsp_payee_class;
         v_batch.dsp_currency := i.dsp_currency;

         FOR rec IN (SELECT    payee_last_name
                            || DECODE (payee_first_name, NULL, '', ', ')
                            || payee_first_name
                            || DECODE (payee_middle_name, NULL, '', ' ')
                            || payee_middle_name pname
                       FROM giis_payees a
                      WHERE a.payee_no = i.payee_cd
                        AND a.payee_class_cd = i.payee_class_cd)
         LOOP
            v_batch.dsp_payee := rec.pname;
         END LOOP;

         FOR cnt IN (SELECT COUNT (advice_id) adv
                       FROM gicl_advice
                      WHERE batch_dv_id = i.batch_dv_id)
         LOOP
            v_cnt := cnt.adv;
            EXIT;
         END LOOP;

         IF v_cnt <= giacp.n ('BCSR_PARTICULARS_LIMIT')
         THEN
            v_batch.print_dtl_sw := 'N';
         ELSE
            v_batch.print_dtl_sw := 'Y';
         END IF;

         /* FOR curr IN (SELECT currency_desc
                         FROM giis_currency
                        WHERE main_currency_cd = i.currency_cd)
          LOOP
             v_batch.dsp_currency := curr.currency_desc;
          END LOOP;*/
         PIPE ROW (v_batch);
      END LOOP;
   END;

   FUNCTION get_giac_batch_dv (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN giac_batch_dv_tab PIPELINED
   IS
      v_batch   giac_batch_dv_type;
      v_cnt     NUMBER             := 0;
   BEGIN
      FOR i IN (SELECT a.*,
                       (   a.fund_cd
                        || '-'
                        || a.branch_cd
                        || '-'
                        || a.batch_year
                        || '-'
                        || TO_CHAR (a.batch_mm, '09')
                        || '-'
                        || TO_CHAR (a.batch_seq_no, '0999999') --modified by carloR SR-5653 09.27.2016
                       ) batch_no,
                       (SELECT class_desc
                          FROM giis_payee_class
                         WHERE payee_class_cd =
                                             a.payee_class_cd)
                                                             dsp_payee_class,
                       (SELECT currency_desc
                          FROM giis_currency
                         WHERE main_currency_cd = a.currency_cd)
                                                                dsp_currency
                  FROM giac_batch_dv a
                 WHERE a.batch_dv_id = p_batch_dv_id)
      LOOP
         v_batch.batch_dv_id := i.batch_dv_id;
         v_batch.fund_cd := i.fund_cd;
         v_batch.branch_cd := i.branch_cd;
         v_batch.batch_year := i.batch_year;
         v_batch.batch_mm := i.batch_mm;
         v_batch.batch_seq_no := i.batch_seq_no;
         v_batch.batch_date := TO_CHAR (i.batch_date, 'MM-DD-YYYY');
         v_batch.batch_flag := i.batch_flag;
         v_batch.payee_class_cd := i.payee_class_cd;
         v_batch.payee_cd := i.payee_cd;
         v_batch.particulars := i.particulars;
         v_batch.tran_id := i.tran_id;
         v_batch.paid_amt := i.paid_amt;
         v_batch.fcurr_amt := i.fcurr_amt;
         v_batch.currency_cd := i.currency_cd;
         v_batch.convert_rate := i.convert_rate;
         v_batch.user_id := i.user_id;
         v_batch.last_update := i.last_update;
         v_batch.payee_remarks := i.payee_remarks;
         v_batch.batch_no := i.batch_no;
         v_batch.dsp_payee_class := i.dsp_payee_class;
         v_batch.dsp_currency := i.dsp_currency;

         FOR rec IN (SELECT    payee_last_name
                            || DECODE (payee_first_name, NULL, '', ', ')
                            || payee_first_name
                            || DECODE (payee_middle_name, NULL, '', ' ')
                            || payee_middle_name pname
                       FROM giis_payees a
                      WHERE a.payee_no = i.payee_cd
                        AND a.payee_class_cd = i.payee_class_cd)
         LOOP
            v_batch.dsp_payee := rec.pname;
         END LOOP;

         FOR cnt IN (SELECT COUNT (advice_id) adv
                       FROM gicl_advice
                      WHERE batch_dv_id = i.batch_dv_id)
         LOOP
            v_cnt := cnt.adv;
            EXIT;
         END LOOP;

         IF v_cnt <= giacp.n ('BCSR_PARTICULARS_LIMIT')
         THEN
            v_batch.print_dtl_sw := 'N';
         ELSE
            v_batch.print_dtl_sw := 'Y';
         END IF;

         /* FOR curr IN (SELECT currency_desc
                         FROM giis_currency
                        WHERE main_currency_cd = i.currency_cd)
          LOOP
             v_batch.dsp_currency := curr.currency_desc;
          END LOOP;*/
         PIPE ROW (v_batch);
      END LOOP;
   END;

   PROCEDURE set_giac_batch_dv (
      p_payee_class_cd    IN       giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd                   giac_batch_dv.payee_cd%TYPE,
      p_particulars                giac_batch_dv.particulars%TYPE,
      p_total_paid_amt             giac_batch_dv.paid_amt%TYPE,
      p_total_fcurr_amt            giac_batch_dv.fcurr_amt%TYPE,
      p_currency_cd                giac_batch_dv.currency_cd%TYPE,
      p_convert_rate               giac_batch_dv.convert_rate%TYPE,
      p_payee_ramarks              giac_batch_dv.payee_remarks%TYPE,
      p_iss_cd                     gicl_advice.iss_cd%TYPE,
      p_fund_cd                    giac_parameters.param_value_v%TYPE,
      p_batch_dv_id       OUT      giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert         OUT      VARCHAR2,
      p_document_cd       OUT      VARCHAR2,
      p_gouc_ouc_id       OUT      giac_oucs.ouc_id%TYPE,
      p_ref_id            OUT      giac_payt_requests.ref_id%TYPE,
      p_doc_year          OUT      giac_payt_requests.doc_year%TYPE,
      p_doc_mm            OUT      giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no        OUT      NUMBER
   )
   IS
      v_seq_no           NUMBER;
      v_branch_sl_type   giac_parameters.param_value_v%TYPE;
      v_gauge_divider    NUMBER;
   BEGIN
      -- BEGIN INITIALIZE
      p_doc_year := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));
      p_doc_mm := TO_NUMBER (TO_CHAR (SYSDATE, 'MM'));

      -- sequence
      FOR seq IN (SELECT batch_dv_id_s.NEXTVAL val1,
                         gprq_ref_id_s.NEXTVAL val2
                    FROM DUAL)
      LOOP
         p_batch_dv_id := seq.val1;
         p_ref_id := seq.val2;
         EXIT;
      END LOOP;

      -- max batch no
      FOR rec IN (SELECT MAX (batch_seq_no) batch_seq_no
                    FROM giac_batch_dv)
      LOOP
         v_seq_no := rec.batch_seq_no;
         EXIT;
      END LOOP;

      v_seq_no := NVL (v_seq_no, 0) + 1;

      -- ouc id (department)
      FOR rec IN (SELECT ouc_id
                    FROM giac_oucs
                   WHERE claim_tag = 'Y' AND gibr_branch_cd = p_iss_cd)
      LOOP
         p_gouc_ouc_id := rec.ouc_id;
         EXIT;
      END LOOP;

      -- document code
      FOR rec IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'SPECIAL_CSR_DOC')
      LOOP
         p_document_cd := rec.param_value_v;
         EXIT;
      END LOOP;

      p_doc_seq_no :=
         generate_doc_seq_no (p_fund_cd,
                              p_iss_cd,
                              p_document_cd,
                              p_doc_year,
                              p_doc_mm
                             );

      BEGIN
         SELECT param_value_v
           INTO v_branch_sl_type
           FROM giac_parameters
          WHERE param_name = 'BRANCH_SL_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert :=
                   'No existing BRANCH_SL_TYPE parameter on GIAC_PARAMETERS.';
            RETURN;
      END;

      -- END INITIALIZE
      v_gauge_divider := 1;

      -- insert values in giac_payt_requests
      --:gauge.FILE := 'Adding records in BATCH DV.';

      -- insert into giac_batch_dv
      INSERT INTO giac_batch_dv
                  (batch_dv_id, fund_cd, branch_cd, batch_year, batch_mm,
                   batch_seq_no, batch_date, batch_flag, payee_class_cd,
                   payee_cd, particulars, paid_amt,
                   fcurr_amt, currency_cd, convert_rate,
                   payee_remarks
                  )
           VALUES (p_batch_dv_id, p_fund_cd, p_iss_cd, p_doc_year, p_doc_mm,
                   v_seq_no, SYSDATE, 'N', p_payee_class_cd,
                   p_payee_cd, p_particulars, p_total_paid_amt,
                   p_total_fcurr_amt, p_currency_cd, p_convert_rate,
                   p_payee_ramarks
                  );
   END;

   PROCEDURE add_payment_request_details (
      p_particulars       IN OUT   VARCHAR2,
      p_batch_dv_id                giac_batch_dv.batch_dv_id%TYPE,
      p_user_id                    giac_batch_dv.user_id%TYPE,
      p_fund_cd                    giac_parameters.param_value_v%TYPE,
      p_iss_cd                     gicl_advice.iss_cd%TYPE,
      p_payee                      VARCHAR2,
      p_payee_cd                   giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd             giac_batch_dv.payee_class_cd%TYPE,
      p_payee_remarks              VARCHAR2,
      p_currency_cd                gicl_advice.currency_cd%TYPE,
      p_total_paid_amt             giac_batch_dv.paid_amt%TYPE,
      p_total_fcurr_amt            giac_batch_dv.fcurr_amt%TYPE,
      p_convert_rate               giac_batch_dv.convert_rate%TYPE,
      v_ref_id                     giac_payt_requests.ref_id%TYPE,
      v_dv_tran_id        OUT      giac_acctrans.tran_id%TYPE,
      v_jv_tran_id        OUT      giac_acctrans.tran_id%TYPE,
      v_ri_iss_cd         OUT      VARCHAR2,
      v_check             OUT      VARCHAR2
   )
   IS
/* the variables below are used in concatenation of advice/claim details
** with the particulars. Pia, 09.03.04 */
      v_particulars      VARCHAR2 (5000);
      -- extended length to determine no. of characters of particulars
      v_particulars1     giac_payt_requests_dtl.particulars%TYPE;
      v_particulars2     giac_payt_requests_dtl.particulars%TYPE;
      v_particulars3     giac_payt_requests_dtl.particulars%TYPE;
      v_particulars4     giac_payt_requests_dtl.particulars%TYPE;
      v_particulars5     VARCHAR2 (5000);
      v_particulars6     VARCHAR2 (500);
      v_length           NUMBER;              -- stores length of particulars
      v_dv_limit         giac_parameters.param_value_n%TYPE        := 0;
      v_dv_limit_recs   VARCHAR2(5000);
      -- advice/claim records w/c will be copied to particulars.
      v_dv_cnt           NUMBER                                    := 0;
      -- # of records approved.
      v_dv_limit_rec2    giac_payt_requests_dtl.particulars%TYPE; 
      -- advice/claim records WITH DETAILS w/c will be copied to particulars.
      v_length2          NUMBER; -- length of characters of records approved.
      v_attach           NUMBER                                    := 0;
      v_count2           NUMBER;
      v_payee_class      VARCHAR2 (100);
      v_payee_part       VARCHAR2 (1000);
      v_doc_number       gicl_loss_exp_bill.doc_number%TYPE;
      v_doc_type         VARCHAR2 (100);
      v_all6             VARCHAR2 (2000);
      -- v_tranid           giac_acctrans.tran_id%TYPE;
       --v_dv_tran_id       giac_acctrans.tran_id%TYPE;
      v_tran_seq_no      giac_acctrans.tran_seq_no%TYPE;
      v_branch_sl_type   VARCHAR2 (500);
      --v_jv_tran_id       giac_acctrans.tran_id%TYPE;
      payee_temp         giac_payt_requests_dtl.payee%TYPE;
      
      /* Added by: Jen 20121009 
      ** (1) used in checking if bcs already exists in giac_acctrans for the particular branch.
      ** (2) used to store particulars for bcs
      ** (3) used to store lenght of particlars in bcs to check if it will exceed column size */
      v_check2          VARCHAR2(1) := 'N'; 
      v_bcsParticulars  giac_acctrans.particulars%TYPE; 
      v_pSize           NUMBER:=0;
      --end jen.20121009
      --added alaiza 12012015 for particulars field adjustment
      v_unused   NUMBER;
      v_remain   NUMBER;
      v_rec      NUMBER;
      
      CURSOR cur_clm
      IS
         (SELECT a.claim_id ID,
                    RPAD (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'),
                          23,
                          ' '
                         )
                 || '  '
                 || RPAD (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.renew_no), 2, '0'),
                          25,
                          ' '
                         )
                 || RPAD (a.assured_name, 23) prt,
                 b.iss_cd
            FROM gicl_claims a, gicl_advice b, giac_batch_dv c
           WHERE c.batch_dv_id = p_batch_dv_id
             AND a.claim_id = b.claim_id
             AND b.batch_dv_id = c.batch_dv_id);
   BEGIN
      v_dv_limit := giacp.n ('BCSR_PARTICULARS_LIMIT');
      v_particulars1 := p_particulars;
      v_particulars3 := NULL;
      v_particulars5 := NULL;
      v_particulars4 := NULL;

      FOR rec IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'RI_ISS_CD')
      LOOP
         v_ri_iss_cd := rec.param_value_v;
      END LOOP;

      BEGIN
         SELECT param_value_v
           INTO v_branch_sl_type
           FROM giac_parameters
          WHERE param_name = 'BRANCH_SL_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                  ('-20001',
                   'No existing BRANCH_SL_TYPE parameter on GIAC_PARAMETERS.'
                  );
      END;

      FOR clm IN (SELECT a.claim_id ID,
                            RPAD (   a.line_cd
                                  || '-'
                                  || a.subline_cd
                                  || '-'
                                  || a.iss_cd
                                  || '-'
                                  || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                                  || '-'
                                  || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'),
                                  23
                                 )
-- modified by aaron sept 1, 2008... increased size of claim number displayed from 20 to 25...
                 --||'-'||LPAD(TO_CHAR(a.clm_seq_no),7,'0'),20,' ')
                         || '  '
                         || RPAD (   a.line_cd
                                  || '-'
                                  || a.subline_cd
                                  || '-'
                                  || a.pol_iss_cd
                                  || '-'
                                  || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                                  || '-'
                                  || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                                  || '-'
                                  || LPAD (TO_CHAR (a.renew_no), 2, '0'),
                                  25
                                 )
                         || RPAD (a.assured_name, 23) prt
                    FROM gicl_claims a, gicl_advice b, giac_batch_dv c
                   WHERE c.batch_dv_id = p_batch_dv_id
                     AND a.claim_id = b.claim_id
                     AND b.batch_dv_id = c.batch_dv_id)
      LOOP        
         
         v_particulars3 := clm.prt;

         FOR abc IN (SELECT DISTINCT TO_CHAR (c.intm_no) intm_no,
                                     UPPER (NVL (c.ref_intm_cd, ' ')) ref_cd
                                FROM gicl_claims a,
                                     gicl_intm_itmperil b,
                                     giis_intermediary c
                               WHERE a.claim_id = b.claim_id
                                 AND b.intm_no = c.intm_no
                                 AND a.claim_id = clm.ID)
         LOOP
            IF abc.ref_cd = ' '
            THEN
               v_particulars4 := abc.intm_no;
            ELSE
               v_particulars4 := abc.intm_no || '/' || abc.ref_cd;
            END IF;

            EXIT;
         END LOOP;

         --v_particulars5 := v_particulars3 || '  ' || v_particulars4 || CHR (10)
            -- vondanix 052313 to validate length since Particulars' max length is 2000
         IF NVL(LENGTH(v_particulars5),0) < 2000 THEN
             v_particulars5 := v_particulars3||'  '||v_particulars4||chr(10)||v_particulars5; 
         END IF;
         -- count number of records to be approved.
         v_dv_cnt := v_dv_cnt + 1;

         IF v_dv_limit != 0
         THEN
            -- get claim records if # of claim records <= bcsr particulars limit.
            IF v_dv_cnt <= v_dv_limit
            THEN         
               v_dv_limit_recs := v_particulars5;
            END IF;
         ELSE
            v_dv_limit_recs := v_particulars5;
         END IF;
      END LOOP;

      --BEGIN
      v_count2 := 0;

      FOR c IN (SELECT a.class_desc class_desc, b.payee_last_name last_name,
                       c.doc_number doc_num,
                       DECODE (c.doc_type, 1, 'INVOICE', 2, 'BILL') doc_type,
                       d.hist_seq_no,
                       c.bill_date        -- added bill_date by Marlo 06242010
                  FROM giis_payee_class a,
                       giis_payees b,
                       gicl_loss_exp_bill c,
                       gicl_clm_loss_exp d,
                       gicl_advice e,
                       giac_batch_dv f
                 WHERE a.payee_class_cd = c.payee_class_cd
                   AND a.payee_class_cd = b.payee_class_cd
                   AND b.payee_no = c.payee_cd
                   AND f.batch_dv_id = e.batch_dv_id
                   AND e.advice_id = d.advice_id
                   AND d.clm_loss_id = c.claim_loss_id
                   AND d.claim_id = c.claim_id
                   AND f.batch_dv_id = p_batch_dv_id)
      LOOP
         v_count2 := v_count2 + 1;
         v_payee_class := c.class_desc;
         v_payee_part := c.last_name;
         v_doc_number := c.doc_num;
         v_doc_type := c.doc_type;
         v_all6 :=
               v_payee_class
            || ' - '
            || v_payee_part
            || ' / '
            || v_doc_type
            || '-'
            || v_doc_number
            || ' / '
            || TO_CHAR (c.bill_date, 'MM-DD-RRRR');

         -- added bill_date by Marlo 06242010

         --msg_alert(v_count2||' v_count2', 'I', false);
         --msg_alert(v_all6||' v_all6', 'I', false);
         IF v_count2 = 1
         THEN
            v_particulars6 := 'PAYMENT FOR : ' || v_all6;
         ELSIF v_count2 > 1
         THEN
            --v_particulars6 :=v_particulars6 || CHR (10) || '                 '|| v_all6;
            -- vondanix 052313 to validate length since Particulars' max length is 2000
            IF NVL(LENGTH(v_particulars6), 0) < 2000 THEN
                v_particulars6 := v_particulars6||chr(10)||
                        '                 '||v_all6;
            END IF;         
         END IF;
      END LOOP;

      v_particulars2 :=
            RPAD ('Claim Number', 25)
         || RPAD ('Policy Number', 25)
         || RPAD ('Assured', 25)
         || RPAD ('Intermediary No.', 25);
         
    --modified by alaiza 12062015 for the adjustment of particulars field length             
      v_unused := 1000 - NVL(length(v_particulars1),0);
      v_remain := v_unused + 1000;  
      v_rec    :=  v_remain - (length( (' (SEE ATTACHED DETAILS)')));

      IF v_particulars1 IS NOT NULL
      THEN
         v_particulars :=
               v_particulars1
            || CHR (10)
            || CHR (10)
            || v_particulars2
            || CHR (10)
            || v_particulars5
            || v_particulars6;
     
         v_dv_limit_rec2 :=
              LENGTH(v_particulars1
            || CHR (10)
            || CHR (10)
            || v_particulars2
            || CHR (10) 
            || v_dv_limit_recs
            || v_particulars6);                          
           
          IF v_dv_limit_rec2 > 2000
           THEN              
                                                        
            p_particulars :=  v_particulars1 
                            || SUBSTR(CHR (10) 
                            || CHR (10) 
                            || v_particulars2
                            || CHR (10) 
                            || v_dv_limit_recs ,1, v_rec)
                            || ' (SEE ATTACHED DETAILS)';  
                              
          ELSE   
                         
            p_particulars := v_particulars1
                            || CHR (10)
                            || CHR (10)
                            || v_particulars2
                            || CHR (10) 
                            || v_dv_limit_recs
                            || v_particulars6;
          END IF; 
            
      ELSE
         v_particulars :=
                v_particulars2 || CHR (10) || v_particulars5
                || v_particulars6;
         v_dv_limit_rec2 :=
               v_particulars2 || CHR (10) || v_dv_limit_recs
               || v_particulars6;
               
         p_particulars := v_dv_limit_rec2;
      END IF;
--end      

      v_length2 := NVL (LENGTH (v_dv_limit_rec2), 0);
            
         /* v_print_dtl (determines if user will have to print the details report),
      ** will always be = Y if claim records to be approved > bcsr_particulars_limit AND/OR
      ** if length of (final) particulars > 2000. Pia, 08.27.04 */
      
      /*IF v_dv_cnt <= v_dv_limit
      THEN
         IF v_length2 > 2000
         THEN
            p_particulars :=
                  v_particulars1
               || ' (SEE ATTACHED DETAILS)'
               || CHR (10)
               || CHR (10)
               || v_particulars2
               || CHR (10)
               || v_dv_limit_recs;
         --msg_alert(:giac_batch_dv.nbt_particulars||' **', 'I', false);
         ELSIF v_length2 <= 2000
         THEN
--            msg_alert('length: '||to_char(v_length2), 'I', false);
            p_particulars := v_dv_limit_rec2;
         --msg_alert(:giac_batch_dv.nbt_particulars||' ***', 'I', false);
         END IF;
      ELSE
         --msg_alert('exceeded', 'I', false);
         p_particulars := v_particulars1 || ' (SEE ATTACHED DETAILS)';
      END IF;
      */   
      
      /*inserting DV record*/

      -- added seq for DV, czie,090508
      FOR seq IN (SELECT acctran_tran_id_s.NEXTVAL val
                    FROM DUAL)
      LOOP
         v_dv_tran_id := seq.val;
      END LOOP;

      -- added tran_seq_no fro DV, czie,090508
      --comment-out by steven 12.01.2014 base on cs version
      /*v_tran_seq_no :=
         giac_sequence_generation (p_fund_cd,
                                   p_iss_cd,
                                   'ACCTRAN_TRAN_SEQ_NO',
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')),
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'MM'))
                                  );*/

      INSERT INTO giac_acctrans
                  (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                   tran_flag, tran_class, 
                   --tran_year,tran_month, tran_seq_no, remove by steven 11.28.2014 base on CS version
                   --added tran_year, tran_month, tran_seq_no -czie,090508
                   particulars, user_id, last_update
                  )
           VALUES (v_dv_tran_id, p_fund_cd, p_iss_cd, SYSDATE,
                   'O', 'DV', 
                   --TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')),TO_NUMBER (TO_CHAR (SYSDATE, 'MM')), v_tran_seq_no, remove by steven 11.28.2014 base on CS version
                   p_particulars, p_user_id, SYSDATE
                  );

      --update records on giac_batch_dv
      UPDATE giac_batch_dv
         SET tran_id = v_dv_tran_id
       WHERE batch_dv_id = p_batch_dv_id;

      aeg_ins_updt_giac_acct_ent2 (v_dv_tran_id,
                                   p_iss_cd,
                                   v_ri_iss_cd,
                                   p_batch_dv_id,
                                   p_fund_cd,
                                   p_user_id
                                  );
      aeg_parameters (v_dv_tran_id,
                      p_batch_dv_id,
                      v_ri_iss_cd,
                      p_iss_cd,
                      p_iss_cd,
                      v_branch_sl_type,
                      p_fund_cd,
                      p_user_id
                     );

      -- begin filter for distinct iss_cd and not head office and reinsurance
       -- new sequence for acctran_tran_id per distinct iss_cd except head office and reinsurance

      /* inserting BCS record*/
      FOR i IN cur_clm
      LOOP
         /* Modified by Marlo
         ** 11/11/2009
         ** to filter records in the issue code of disbursement instead of 'HO'.*/--IF i.iss_cd <> 'HO' AND i.iss_cd <> 'RI' then --added to filter the 'HO' and 'RI' iss_cd
         IF i.iss_cd <> p_iss_cd AND i.iss_cd <> 'RI'
         THEN
            v_particulars3 := i.prt;

            FOR abc IN (SELECT DISTINCT TO_CHAR (c.intm_no) intm_no,
                                        UPPER (NVL (c.ref_intm_cd, ' ')
                                              ) ref_cd
                                   FROM gicl_claims a,
                                        gicl_intm_itmperil b,
                                        giis_intermediary c
                                  WHERE a.claim_id = b.claim_id
                                    AND b.intm_no = c.intm_no
                                    AND a.claim_id = i.ID)
            LOOP
               IF abc.ref_cd = ' '
               THEN
                  v_particulars4 := abc.intm_no;
               ELSE
                  v_particulars4 := abc.intm_no || '/' || abc.ref_cd;
               END IF;

               EXIT;
            END LOOP;
            
            --Jen.20121009 check if tran_id with the same claim iss_Cd exists in giac_acctrans before generating/inserting new record in table. 
           BEGIN
             SELECT 'Y', particulars
               INTO v_check2, v_bcsParticulars
               FROM giac_acctrans
              WHERE tran_id = v_jv_tran_id
                AND gibr_branch_cd = i.iss_cd;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               v_check2 := 'N'; --no records yet in giac_acctrans for the tran_id and iss_cd
           END;
           
           /*Added By: Jen.201201009
           ** Added checking of records in giac_acctrans table for the same tran_id and iss_cd, 
           ** If record already exist, module should not insert another record but instead append the
           ** particulars of the next claim.*/
           IF v_check2 = 'N' THEN

                FOR seq IN (SELECT acctran_tran_id_s.NEXTVAL val
                              FROM DUAL)
                LOOP
                   v_jv_tran_id := seq.val;
                END LOOP;
    
                /*v_tran_seq_no :=
                   giac_sequence_generation (p_fund_cd,
                                             i.iss_cd,
                                             'ACCTRAN_TRAN_SEQ_NO',
                                             TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')),
                                             TO_NUMBER (TO_CHAR (SYSDATE, 'MM'))
                                            );*/ --remove by steven 11.28.2014 base on CS version
    
                INSERT INTO giac_acctrans
                            (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                             tran_flag, tran_class, 
                             --tran_year, tran_month, tran_seq_no, --remove by steven 11.28.2014 base on CS version
                             user_id, last_update,
                             particulars
                            )                     --added particulars -czie,090508
                     VALUES (v_jv_tran_id, p_fund_cd, i.iss_cd, SYSDATE,
                             'O', 'BCS', 
                             --TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')), TO_NUMBER (TO_CHAR (SYSDATE, 'MM')), v_tran_seq_no, --remove by steven 11.28.2014 base on CS version
                             USER, SYSDATE,
                                v_particulars2
                             || CHR (10)
                             || v_particulars3
                             || v_particulars4
                            );
    
                --update records on giac_batch_dv_dtl
                UPDATE giac_batch_dv_dtl
                   SET jv_tran_id = v_jv_tran_id
                 WHERE batch_dv_id = p_batch_dv_id AND branch_cd = i.iss_cd;
    
                -- aeg_ins_updt_giac_acct_entries (v_jv_tran_id, i.iss_cd, NULL);
                aeg_ins_updt_giac_acct_ent2 (v_jv_tran_id,
                                             i.iss_cd,
                                             NULL,
                                             p_batch_dv_id,
                                             p_fund_cd,
                                             p_user_id
                                            );
                --aeg_parameters (v_jv_tran_id, i.iss_cd);
                aeg_parameters (v_jv_tran_id,
                                p_batch_dv_id,
                                v_ri_iss_cd,
                                i.iss_cd,
                                p_iss_cd,
                                v_branch_sl_type,
                                p_fund_cd,
                                p_user_id
                               );
            ELSIF v_check2 = 'Y' THEN
                --check size of possible particulars before update to avoid ora6502
                BEGIN
                  select nvl(length(v_bcsParticulars||chr(10)||v_particulars3||v_particulars4),0)
                    into v_pSize
                    from dual;
                END;
                
                IF v_pSize < 2000 THEN
                   UPDATE giac_acctrans
                      SET particulars = v_bcsParticulars||CHR(10)||v_particulars3||v_particulars4
                    WHERE tran_id = v_jv_tran_id;
                END IF;
            END IF; --end jen.20121009
         END IF;                                            --end of condition
      END LOOP;

           /* Added by Marlo
      ** 10212010
      ** To check if the BCS entry is balance
      */
      v_check := 'Y';

      FOR i IN (SELECT   1
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_batch_dv_dtl c
                   WHERE a.gacc_tran_id = b.tran_id
                     AND b.tran_flag = 'O'
                     AND b.tran_class = 'BCS'
                     AND a.gacc_tran_id = c.jv_tran_id
                     AND a.gacc_tran_id = v_jv_tran_id
                GROUP BY a.gacc_tran_id, c.batch_dv_id
                  HAVING SUM (credit_amt) != SUM (debit_amt))
      LOOP
         v_check := 'N';
         EXIT;
      END LOOP;

      -- end of modification 10212010

      -- tem
      -- insert record in giac_payt_requests_dtl
      INSERT INTO giac_payt_requests_dtl
                  (req_dtl_no, gprq_ref_id, tran_id, payee_class_cd,
                   payt_req_flag, payee_cd, payee,
                   particulars, currency_cd, payt_amt, user_id,
                   last_update, dv_fcurrency_amt, currency_rt
                  )
           VALUES (1, v_ref_id, v_dv_tran_id, p_payee_class_cd,
                   'N', p_payee_cd, p_payee || ' ' || p_payee_remarks,
                   p_particulars, p_currency_cd, p_total_paid_amt, USER,
                   SYSDATE, p_total_fcurr_amt, p_convert_rate
                  );

      UPDATE giac_batch_dv
         SET particulars = NVL (p_particulars, '-')
       WHERE batch_dv_id = p_batch_dv_id;
   END;

   PROCEDURE add_direct_claim_payments (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   )
   IS
      v_whold_tax   NUMBER (16, 2)                      := 0;
      v_input_vat   NUMBER (16, 2)                      := 0;
      v_other_tax   NUMBER (16, 2);
      v_mod_name    giac_modules.module_name%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_item_no     giac_taxes_wheld.item_no%TYPE;
      v_hasbcs      BOOLEAN                             := FALSE;
      v_tranid      giac_acctrans.tran_id%TYPE;
   BEGIN
      -- insert record in giac_direct_claim_payts
      FOR rec IN (SELECT (tax_amt * p_conv_rt) tax_amt, tax_type
                    FROM gicl_loss_exp_tax
                   WHERE claim_id = p_claim_id
                     AND clm_loss_id = p_clm_loss_id
                     AND tax_type IN ('W', 'I'))
      LOOP
         IF rec.tax_type = 'W'
         THEN
            v_whold_tax := rec.tax_amt;
         -- + v_whold_tax; comment out by jess 09232010
         ELSIF rec.tax_type = 'I'
         THEN
            v_input_vat := rec.tax_amt;
                               -- + v_input_vat; comment out by jess 09232010
         --ELSIF rec.tax_type = 'O' THEN
         --   v_other_tax    := rec.val1 + v_other_tax;
         END IF;
      END LOOP;

      IF p_iss_cd <> p_ri_iss_cd
      THEN
         INSERT INTO giac_direct_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      ELSE
         INSERT INTO giac_inw_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      END IF;

         --vbx_counter; comment out by Marlo 10212010 moved out of the loop.
      /*   IF i > (v_count * .7) AND v_half != 'Y'
         THEN
            --:gauge.FILE := 'Adding records in TAXES WITHHELD.';
            v_half := 'Y';
         END IF;*/
      FOR rec IN (SELECT   c.claim_id, c.advice_id, c.iss_cd, payee_cd,
                           payee_class_cd, b.tax_cd,
                           (SUM (NVL (b.base_amt, 0)) * p_conv_rt) base_amt,
                           (SUM (NVL (b.tax_amt, 0)) * p_conv_rt) tax_amt
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c
                     WHERE b.tax_type = 'W'
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = b.claim_id
                       AND c.advice_id = a.advice_id
                       AND c.advice_flag = 'Y'
                       AND c.apprvd_tag = 'Y'
                       AND c.claim_id = p_claim_id
                       AND c.advice_id = p_advice_id
                  GROUP BY c.claim_id,
                           c.advice_id,
                           c.iss_cd,
                           payee_cd,
                           payee_class_cd,
                           b.tax_cd)
      LOOP
         IF rec.iss_cd <> p_ri_iss_cd
         THEN
            v_mod_name := 'GIACS017';
         ELSE
            v_mod_name := 'GIACS018';
         END IF;

         BEGIN
            SELECT generation_type
              INTO v_gen_type
              FROM giac_modules
             WHERE module_name = v_mod_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                  (   'Generation type for '
                   || v_mod_name
                   || ' does not exist in GIAC_MODULES table.'
                  );
         END;

         v_item_no := nvl(v_item_no,0) + 1;

         --emcy da062805te
         IF v_hasbcs = TRUE
         THEN
            v_tranid := p_jv_tran_id;
         ELSE
            v_tranid := p_dv_tran_id;
         END IF;

         --end of revision
         INSERT INTO giac_taxes_wheld
                     (gacc_tran_id, claim_id, advice_id,
                      gen_type, payee_class_cd, item_no,
                      payee_cd, gwtx_whtax_id, income_amt, wholding_tax_amt,
                      user_id, last_update
                     )
              VALUES (v_tranid /*emcy 062805*/, rec.claim_id, rec.advice_id,
                      v_gen_type, rec.payee_class_cd, v_item_no,
                      rec.payee_cd, rec.tax_cd, rec.base_amt, rec.tax_amt,
                      USER, SYSDATE
                     );
      END LOOP;

      -- added by A.R.C. 06.28.2005
      FOR c1 IN (SELECT b.userid, d.event_desc
                   FROM giis_events_column c,
                        giis_event_mod_users b,
                        giis_event_modules a,
                        giis_events d
                  WHERE 1 = 1
                    AND c.event_cd = a.event_cd
                    AND c.event_mod_cd = a.event_mod_cd
                    AND b.event_mod_cd = a.event_mod_cd
                    --AND b.userid <> USER  --A.R.C. 02.01.2006
                    AND b.passing_userid = p_user_id       --A.R.C. 02.01.2006
                    AND a.module_id = 'GICLS032'
                    AND a.event_cd = d.event_cd
                    AND UPPER (d.event_desc) = 'CSR TO ACCOUNTING')
      LOOP
         create_transfer_workflow_rec ('CSR TO ACCOUNTING',
                                       'GICLS032',
                                       c1.userid,
                                       p_advice_id,
                                       '- CSR to Accounting',
                                       p_msg_alert,
                                       p_workflow_msgr,
                                       p_user_id
                                      );
      END LOOP;

        /* A.R.C. 08.13.2004
      ** to delete workflow records of Generate SCSR */
      delete_workflow_rec ('GENERATE SCSR', 'GICLS032', USER, p_claim_id);
   END;
   
   /*
    **  Created by     : Veronica V. Raymundo
    **  Date Created   : 11.28.2012
    **  Reference By   : GIACS086 - Special CSR
    **  Description    : Executes codes found in generate_ae program unit in GIACS086
    */
    
   PROCEDURE add_direct_claim_payments_2 (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_item_no          IN       NUMBER,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   )
   IS
      v_whold_tax   NUMBER (16, 2)                      := 0;
      v_input_vat   NUMBER (16, 2)                      := 0;
      v_other_tax   NUMBER (16, 2);
      v_mod_name    giac_modules.module_name%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_item_no     giac_taxes_wheld.item_no%TYPE;
      v_hasbcs      BOOLEAN                             := FALSE;
      v_tranid      giac_acctrans.tran_id%TYPE;
   BEGIN
      -- insert record in giac_direct_claim_payts
      FOR rec IN (SELECT (tax_amt * p_conv_rt) tax_amt, tax_type
                    FROM gicl_loss_exp_tax
                   WHERE claim_id = p_claim_id
                     AND clm_loss_id = p_clm_loss_id
                     AND tax_type IN ('W', 'I'))
      LOOP
         IF rec.tax_type = 'W'
         THEN
            v_whold_tax := rec.tax_amt;
         -- + v_whold_tax; comment out by jess 09232010
         ELSIF rec.tax_type = 'I'
         THEN
            v_input_vat := rec.tax_amt;
                               -- + v_input_vat; comment out by jess 09232010
         --ELSIF rec.tax_type = 'O' THEN
         --   v_other_tax    := rec.val1 + v_other_tax;
         END IF;
      END LOOP;

      IF p_iss_cd <> p_ri_iss_cd
      THEN
         INSERT INTO giac_direct_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      ELSE
         INSERT INTO giac_inw_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      END IF;

         --vbx_counter; comment out by Marlo 10212010 moved out of the loop.
      /*   IF i > (v_count * .7) AND v_half != 'Y'
         THEN
            --:gauge.FILE := 'Adding records in TAXES WITHHELD.';
            v_half := 'Y';
         END IF;*/
      FOR rec IN (SELECT   c.claim_id, c.advice_id, c.iss_cd, payee_cd,
                           payee_class_cd, b.tax_cd,
                           (SUM (NVL (b.base_amt, 0)) * p_conv_rt) base_amt,
                           (SUM (NVL (b.tax_amt, 0)) * p_conv_rt) tax_amt
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c
                     WHERE b.tax_type = 'W'
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = b.claim_id
                       AND c.advice_id = a.advice_id
                       AND c.advice_flag = 'Y'
                       AND c.apprvd_tag = 'Y'
                       AND c.claim_id = p_claim_id
                       AND c.advice_id = p_advice_id
                  GROUP BY c.claim_id,
                           c.advice_id,
                           c.iss_cd,
                           payee_cd,
                           payee_class_cd,
                           b.tax_cd)
      LOOP
         IF rec.iss_cd <> p_ri_iss_cd
         THEN
            v_mod_name := 'GIACS017';
         ELSE
            v_mod_name := 'GIACS018';
         END IF;

         BEGIN
            SELECT generation_type
              INTO v_gen_type
              FROM giac_modules
             WHERE module_name = v_mod_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                  (   'Generation type for '
                   || v_mod_name
                   || ' does not exist in GIAC_MODULES table.'
                  );
         END;

         v_item_no := nvl(v_item_no,0) + 1;

         --emcy da062805te
         IF v_hasbcs = TRUE
         THEN
            v_tranid := p_jv_tran_id;
         ELSE
            v_tranid := p_dv_tran_id;
         END IF;

         --end of revision
         INSERT INTO giac_taxes_wheld
                     (gacc_tran_id, claim_id, advice_id,
                      gen_type, payee_class_cd, item_no,
                      payee_cd, gwtx_whtax_id, income_amt, wholding_tax_amt,
                      user_id, last_update
                     )
              VALUES (v_tranid /*emcy 062805*/, rec.claim_id, rec.advice_id,
                      v_gen_type, rec.payee_class_cd, p_item_no, --v_item_no,
                      rec.payee_cd, rec.tax_cd, rec.base_amt, rec.tax_amt,
                      USER, SYSDATE
                     );
      END LOOP;

      -- added by A.R.C. 06.28.2005
      FOR c1 IN (SELECT b.userid, d.event_desc
                   FROM giis_events_column c,
                        giis_event_mod_users b,
                        giis_event_modules a,
                        giis_events d
                  WHERE 1 = 1
                    AND c.event_cd = a.event_cd
                    AND c.event_mod_cd = a.event_mod_cd
                    AND b.event_mod_cd = a.event_mod_cd
                    --AND b.userid <> USER  --A.R.C. 02.01.2006
                    AND b.passing_userid = p_user_id       --A.R.C. 02.01.2006
                    AND a.module_id = 'GICLS032'
                    AND a.event_cd = d.event_cd
                    AND UPPER (d.event_desc) = 'CSR TO ACCOUNTING')
      LOOP
         create_transfer_workflow_rec ('CSR TO ACCOUNTING',
                                       'GICLS032',
                                       c1.userid,
                                       p_advice_id,
                                       '- CSR to Accounting',
                                       p_msg_alert,
                                       p_workflow_msgr,
                                       p_user_id
                                      );
      END LOOP;

        /* A.R.C. 08.13.2004
      ** to delete workflow records of Generate SCSR */
      delete_workflow_rec ('GENERATE SCSR', 'GICLS032', USER, p_claim_id);
   END;
   
      /*
    **  Created by     : Reynante Manalad
    **  Date Created   : 8/28/2013
    **  Reference By   : GIACS086 QA findings-220
    **  Description    : Apply fix for multiple claims w/ withholding tax in 1 batch
    */
   
   PROCEDURE add_direct_claim_payments_3 (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_item_no          IN       NUMBER,
      p_batch_id         IN       giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   )
   IS
      v_whold_tax   NUMBER (16, 2)                      := 0;
      v_input_vat   NUMBER (16, 2)                      := 0;
      v_other_tax   NUMBER (16, 2);
      v_mod_name    giac_modules.module_name%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_item_no     giac_taxes_wheld.item_no%TYPE;
      v_hasbcs      BOOLEAN                             := FALSE;
      v_tranid      giac_acctrans.tran_id%TYPE;
      v_gacc_tran_id     giac_taxes_wheld.gacc_tran_id%TYPE; -- added by steven 12.01.2014
   BEGIN
      -- insert record in giac_direct_claim_payts
      --changed by steven 12.01.2014
      FOR rec IN (SELECT --(tax_amt * p_conv_rt) tax_amt, 
                        SUM(ROUND (a.tax_amt * b.currency_rate, 2)) tax_amt,
                        a.tax_type
                    FROM gicl_loss_exp_tax a, gicl_clm_loss_exp b
                   WHERE a.claim_id = p_claim_id
                     AND a.clm_loss_id = p_clm_loss_id
                     AND a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND a.tax_type IN ('W', 'I')
                   GROUP BY a.tax_type)
      --end 12.01.2014
      LOOP
         IF rec.tax_type = 'W'
         THEN
            v_whold_tax := rec.tax_amt;
         -- + v_whold_tax; comment out by jess 09232010
         ELSIF rec.tax_type = 'I'
         THEN
            v_input_vat := rec.tax_amt;
                               -- + v_input_vat; comment out by jess 09232010
         --ELSIF rec.tax_type = 'O' THEN
         --   v_other_tax    := rec.val1 + v_other_tax;
         END IF;
      END LOOP;

      IF p_iss_cd <> p_ri_iss_cd
      THEN
         INSERT INTO giac_direct_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      ELSE
         INSERT INTO giac_inw_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                                    --:gicl_advice.payee_type,
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,                                --v_val6,
                                     p_net_amt, SYSDATE, USER,
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      END IF;

         --vbx_counter; comment out by Marlo 10212010 moved out of the loop.
      /*   IF i > (v_count * .7) AND v_half != 'Y'
         THEN
            --:gauge.FILE := 'Adding records in TAXES WITHHELD.';
            v_half := 'Y';
         END IF;*/
      /*FOR rec IN (SELECT   c.claim_id, c.advice_id, c.iss_cd, payee_cd,
                           payee_class_cd, b.tax_cd,
                           (SUM (NVL (b.base_amt, 0)) * p_conv_rt) base_amt,
                           (SUM (NVL (b.tax_amt, 0)) * p_conv_rt) tax_amt,
                           d.jv_tran_id tran_id -- added by Nante 8.16.2013
                      FROM gicl_clm_loss_exp a,
                           gicl_loss_exp_tax b,
                           gicl_advice c,
                           giac_batch_dv_dtl d ---- added by Nante 8.16.2013 
                     WHERE b.tax_type = 'W'
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id = b.claim_id
                       AND c.advice_id = a.advice_id
                       AND c.advice_flag = 'Y'
                       AND c.apprvd_tag = 'Y'
                       AND c.claim_id = p_claim_id
                       AND c.advice_id = p_advice_id --uncomment to prevent ORA-00001 error in inserting records in GIAC_TAXES_WHELD by MAC 111/12/2013
                       AND c.advice_id = d.advice_id  ---- added by Nante 8.16.2013 
                       AND d.batch_dv_id = p_batch_id ---- added by Nante 8.16.2013 
                  GROUP BY c.claim_id,
                           c.advice_id,
                           c.iss_cd,
                           payee_cd,
                           payee_class_cd,
                           b.tax_cd,
                           d.jv_tran_id)---- added by Nante 8.16.2013 */
        --modified to retrieve policy issue code in order to check which generation type is going to use by MAC 03/11/2014.
        FOR rec IN (SELECT d.jv_tran_id tran_id, a.claim_id, a.advice_id, a.payee_cd,
                                     a.payee_class_cd, b.tax_cd, f.pol_iss_cd,
                                     SUM (ROUND (b.base_amt * a.currency_rate, 2)) base_amt, --convert base amount to local currency by MAC 10/22/2013
                                     SUM (ROUND (b.tax_amt * a.currency_rate, 2)) tax_amt --convert base amount to local currency by MAC 10/22/2013
                                FROM gicl_clm_loss_exp a, 
                                     gicl_loss_exp_tax b, 
                                     giac_batch_dv_dtl d, --get JV_TRAN_ID and insert it in GIAC_TAXES_WHELD by MAC 07/03/2013.
                                     gicl_claims f
                               WHERE b.tax_type = 'W'
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.claim_id = b.claim_id
                                 AND a.claim_id = f.claim_id
                                 AND b.claim_id = f.claim_id
                                 AND d.claim_id = f.claim_id
                                 AND EXISTS (
                                        SELECT 1
                                          FROM gicl_advice c
                                         WHERE c.advice_id = a.advice_id
                                           AND c.advice_flag = 'Y'
                                           AND c.apprvd_tag = 'Y'
                                           AND c.claim_id = p_claim_id
                                           AND c.advice_id = p_advice_id
                                           AND c.claim_id = d.claim_id
                                           AND c.advice_id = d.advice_id)
                                 AND EXISTS (SELECT 1 --added table to check if TRAN ID to be inserted is valid or not by MAC 10/25/2013.
                                               FROM giac_batch_dv e
                                              WHERE d.batch_dv_id = e.batch_dv_id AND e.batch_flag != 'X')
                            GROUP BY d.jv_tran_id,
                                     a.claim_id,
                                     a.advice_id,
                                     a.payee_cd,
                                     a.payee_class_cd,
                                     b.tax_cd,
                                     f.pol_iss_cd)
      LOOP
         IF rec.pol_iss_cd <> p_ri_iss_cd --use Policy Issue Code instead of Advice Issue Code in checking what generation type to use by MAC 03/11/2014.
         THEN
            v_mod_name := 'GIACS017';
         ELSE
            v_mod_name := 'GIACS018';
         END IF;

         BEGIN
            SELECT generation_type
              INTO v_gen_type
              FROM giac_modules
             WHERE module_name = v_mod_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                  (   'Generation type for '
                   || v_mod_name
                   || ' does not exist in GIAC_MODULES table.'
                  );
         END;

         v_item_no := nvl(v_item_no,0) + 1;

         --emcy da062805te
         /*comment out by MAC 07/03/2013
         IF v_hasbcs = TRUE
         THEN
            v_tranid := p_jv_tran_id;
         ELSE
            v_tranid := p_dv_tran_id;
         END IF;*/
         --commit;
         --end of revision
         IF p_iss_cd = rec.pol_iss_cd THEN --koks 8.15.14
            SELECT tran_id
              INTO v_gacc_tran_id
              FROM giac_batch_dv
             WHERE batch_dv_id = p_batch_id;
         ELSE
            v_gacc_tran_id := rec.tran_id;
         END IF; --koks 8.15.14
         
         INSERT INTO giac_taxes_wheld
                     (gacc_tran_id, claim_id, advice_id,
                      gen_type, payee_class_cd, item_no,
                      payee_cd, gwtx_whtax_id, income_amt, wholding_tax_amt,
                      user_id, last_update
                     )
              VALUES (v_gacc_tran_id, --added by steven 12.02.2014--NVL(rec.tran_id,v_tranid),   ---- added by Nante 8.16.2013 --added by Gzelle 11.20.2013 to handle if rec.tran_id is null 
                      --v_tranid /*emcy 062805*/,  
                      rec.claim_id, rec.advice_id,
                      v_gen_type, rec.payee_class_cd, v_item_no, --p_item_no, -- dren 06.25.2015 : SR 0004628 - MAKE ITEM_NO SEQUENTIAL
                      rec.payee_cd, rec.tax_cd, rec.base_amt, rec.tax_amt,
                      p_user_id, SYSDATE
                     );
      END LOOP;
      
      -- added by A.R.C. 06.28.2005
      FOR c1 IN (SELECT b.userid, d.event_desc  
                 FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                WHERE 1=1
                  AND c.event_cd = a.event_cd
                  AND c.event_mod_cd = a.event_mod_cd
                  AND b.event_mod_cd = a.event_mod_cd
                  --AND b.userid <> USER  --A.R.C. 02.01.2006
                  AND b.passing_userid = p_user_id  --A.R.C. 02.01.2006
                  AND a.module_id = 'GICLS032'
                  AND a.event_cd = d.event_cd
                  AND UPPER(d.event_desc) = 'CSR TO ACCOUNTING')
      LOOP
        CREATE_TRANSFER_WORKFLOW_REC('CSR TO ACCOUNTING','GICLS032',c1.userid,p_advice_id,'',p_msg_alert,p_workflow_msgr, p_user_id);
      END LOOP;

        /* A.R.C. 08.13.2004
      ** to delete workflow records of Generate SCSR */
      delete_workflow_rec ('GENERATE SCSR', 'GICLS032', p_user_id, p_claim_id);
   END;
   

   PROCEDURE cancel_giac_batch (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_tran_id       giac_batch_dv.tran_id%TYPE
   )
   IS
   BEGIN
      UPDATE giac_batch_dv
         SET batch_flag = 'X'
       WHERE batch_dv_id = p_batch_dv_id;

      UPDATE giac_acctrans
         SET tran_flag = 'D'
       WHERE tran_id = p_tran_id;

      UPDATE giac_payt_requests_dtl
         SET payt_req_flag = 'X'
       WHERE tran_id = p_tran_id;
   END;

   PROCEDURE giacs086_acct_ent_post_query (
      tran_id                giac_batch_dv.tran_id%TYPE,
      branch_cd              giac_batch_dv.branch_cd%TYPE,
      p_total_debit    OUT   NUMBER,
      p_total_credit   OUT   NUMBER
   )
   IS
   BEGIN
      FOR t IN (SELECT SUM (debit_amt) sum_debit, SUM (credit_amt)
                                                                  sum_credit
                  FROM giac_acct_entries
                 WHERE gacc_tran_id = tran_id
                   AND gacc_gibr_branch_cd = nvl(branch_cd, gacc_gibr_branch_cd))
      LOOP
         p_total_debit := NVL (t.sum_debit, 0);
         p_total_credit := NVL (t.sum_credit, 0);
      END LOOP;
   END;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.22.2012
   **  Reference By : (GICLS0032 - Generate Advice)
   **  Description  :  Function to retrieve the special csr no of advice
   **
   */
   FUNCTION get_scsr_no (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN VARCHAR2
   IS
      v_scsr_no   VARCHAR2 (500);
   BEGIN
      SELECT DISTINCT    a.document_cd
                      || '-'
                      || TO_CHAR (a.doc_year)
                      || '-'
                      || TO_CHAR (a.doc_mm)
                      || '-'
                      || TO_CHAR (a.doc_seq_no)
                 INTO v_scsr_no
                 FROM gicl_advice c,
                      giac_batch_dv b,
                      giac_payt_requests a,
                      giac_payt_requests_dtl d
                WHERE c.batch_dv_id = b.batch_dv_id
                  AND b.tran_id = d.tran_id
                  AND a.ref_id = d.gprq_ref_id
                  AND b.batch_dv_id = p_batch_dv_id;

      RETURN v_scsr_no;
   END;

   FUNCTION giac_batch_dv_giacs086 (
      p_claim_id   giac_batch_dv_dtl.claim_id%TYPE
   )
      RETURN giac_batch_dv_tab PIPELINED
   IS
      v_result   giac_batch_dv_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_batch_dv a
                 WHERE batch_flag != 'X'
                   AND NOT EXISTS (
                           SELECT '1'
                             FROM giac_payt_requests_dtl b
                            WHERE payt_req_flag = 'C'
                                  AND b.tran_id = a.tran_id)
                   AND EXISTS (
                          SELECT *
                            FROM giac_batch_dv_dtl c
                           WHERE c.batch_dv_id = a.batch_dv_id
                             AND c.claim_id = NVL (p_claim_id, c.claim_id))
                   AND check_user_per_iss_cd_acctg (NULL,
                                                    a.branch_cd,
                                                    'GIACS086'
                                                   ) <> 0)
      LOOP
         v_result.payee_class_cd := i.payee_class_cd;
         PIPE ROW (v_result);
      END LOOP;
   END;
   
   PROCEDURE validate_advice(
      p_advice_id gicl_advice.advice_id%TYPE,
      p_message OUT VARCHAR2
   ) 
   AS
     v_batch_dv_id gicl_advice.batch_dv_id%TYPE;
     v_advice_no VARCHAR2(50);
     v_batch_no VARCHAR2(100);
   BEGIN 
     FOR i IN (
       SELECT batch_dv_id
         FROM gicl_advice
        WHERE advice_id = p_advice_id
          AND batch_dv_id IS NOT NULL
     ) LOOP
       v_batch_dv_id := i.batch_dv_id;
     END LOOP;
     
     IF v_batch_dv_id IS NOT NULL THEN
          v_advice_no := GET_ADVICE_NUMBER(p_advice_id);
          
        SELECT (   a.fund_cd
                || '-'
                || a.branch_cd
                || '-'
                || a.batch_year
                || '-'
                || TO_CHAR (a.batch_mm, '09')
                || '-'
                || TO_CHAR (a.batch_seq_no, '09999')
               ) batch_no
          INTO v_batch_no
          FROM giac_batch_dv a
         WHERE a.batch_dv_id = v_batch_dv_id;
     
        raise_application_error(-20001, 'Geniisys Exception#E#Advice Number(s) '||v_advice_no||' is/are already included in Batch Number ' || v_batch_no || '.');
     END IF;
   END;
   
   PROCEDURE add_claim_payments (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_user_id          IN       VARCHAR2
   )
   IS
      v_whold_tax       NUMBER (16, 2)                      := 0;
      v_input_vat       NUMBER (16, 2)                      := 0;
   BEGIN
      FOR rec IN (SELECT --SUM(ROUND (a.tax_amt * b.currency_rate, 2)) tax_amt,
                         SUM(ROUND (NVL (a.tax_amt, 0) * p_conv_rt, 2)) tax_amt, --nieko 01192017, SR 5901
                         a.tax_type
                    FROM gicl_loss_exp_tax a, gicl_clm_loss_exp b
                   WHERE a.claim_id = p_claim_id
                     AND a.clm_loss_id = p_clm_loss_id
                     AND a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND a.tax_type IN ('W', 'I')
                   GROUP BY a.tax_type)
      LOOP
         IF rec.tax_type = 'W'
         THEN
            v_whold_tax := rec.tax_amt;
         ELSIF rec.tax_type = 'I'
         THEN
            v_input_vat := rec.tax_amt;
         END IF;
      END LOOP;

      IF p_iss_cd <> p_ri_iss_cd
      THEN
         INSERT INTO giac_direct_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,
                                     p_net_amt, SYSDATE, NVL(giis_users_pkg.app_user, p_user_id),
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      ELSE
         INSERT INTO giac_inw_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id,
                      advice_id, payee_cd, payee_class_cd,
                      payee_type, disbursement_amt, currency_cd,
                      convert_rate, foreign_curr_amt, last_update, user_id,
                      input_vat_amt, wholding_tax_amt, net_disb_amt
                     )
              VALUES (p_dv_tran_id, 1, p_claim_id, p_clm_loss_id,
                      p_advice_id, p_payee_cd, p_payee_class_cd,
                      p_payee_type, 
                      (              p_net_amt * p_conv_rt), p_currency_cd,
                      p_convert_rate,
                                     p_net_amt, SYSDATE, NVL(giis_users_pkg.app_user, p_user_id),
                      v_input_vat, v_whold_tax, (p_paid_amt * p_conv_rt)
                     );
      END IF;
   END;
   
   PROCEDURE insert_giac_taxes_wheld (
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_batch_id         IN       giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   ) IS
      v_mod_name    giac_modules.module_name%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_item_no     giac_taxes_wheld.item_no%TYPE;
      v_hasbcs      BOOLEAN                             := FALSE;
      v_tranid      giac_acctrans.tran_id%TYPE;
      v_gacc_tran_id     giac_taxes_wheld.gacc_tran_id%TYPE;
      
      v_local_currency     NUMBER  := giacp.n ('CURRENCY_CD'); --nieko 01192017, SR 5901
   BEGIN
      FOR rec IN (SELECT d.jv_tran_id tran_id, a.claim_id, a.advice_id, a.payee_cd,
                                     a.payee_class_cd, b.tax_cd, f.pol_iss_cd,
                                     --nieko 01192017, SR 5901
                                     --SUM (ROUND (b.base_amt * a.currency_rate, 2)) base_amt,
                                     --SUM (ROUND (b.tax_amt * a.currency_rate, 2)) tax_amt
                                     SUM (ROUND (b.base_amt * DECODE (a.currency_cd, v_local_currency, 1, NVL (e.orig_curr_rate, e.convert_rate)), 2)) base_amt,
                                     SUM (ROUND (b.tax_amt * DECODE (a.currency_cd, v_local_currency, 1, NVL (e.orig_curr_rate, e.convert_rate)), 2)) tax_amt
                                     --nieko 01192017, SR 5901 end
                                FROM gicl_clm_loss_exp a, 
                                     gicl_loss_exp_tax b, 
                                     giac_batch_dv_dtl d,
                                     gicl_claims f,
                                     gicl_advice e
                               WHERE b.tax_type = 'W'
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.claim_id = b.claim_id
                                 AND a.claim_id = f.claim_id
                                 AND b.claim_id = f.claim_id
                                 AND d.claim_id = f.claim_id
                                 AND a.advice_id = d.advice_id -- bonok :: 12.22.2015 :: UCPB SR 21147
                                 AND a.clm_loss_id = d.clm_loss_id -- bonok :: 12.22.2015 :: UCPB SR 21147
                                 AND a.claim_id = e.claim_id --nieko 01192017, SR 5901
                                 AND a.advice_id = e.advice_id --nieko 01192017, SR 5901
                                 AND EXISTS (
                                        SELECT 1
                                          FROM gicl_advice c
                                         WHERE c.advice_id = a.advice_id
                                           AND c.advice_flag = 'Y'
                                           AND c.apprvd_tag = 'Y'
                                           AND c.claim_id = p_claim_id
                                           AND c.advice_id = p_advice_id
                                           AND c.claim_id = d.claim_id
                                           AND c.advice_id = d.advice_id)
                                 AND EXISTS (SELECT 1
                                               FROM giac_batch_dv e
                                              WHERE d.batch_dv_id = e.batch_dv_id AND e.batch_flag != 'X')
                            GROUP BY d.jv_tran_id,
                                     a.claim_id,
                                     a.advice_id,
                                     a.payee_cd,
                                     a.payee_class_cd,
                                     b.tax_cd,
                                     f.pol_iss_cd)
      LOOP
         IF rec.pol_iss_cd <> p_ri_iss_cd
         THEN
            v_mod_name := 'GIACS017';
         ELSE
            v_mod_name := 'GIACS018';
         END IF;

         BEGIN
            SELECT generation_type
              INTO v_gen_type
              FROM giac_modules
             WHERE module_name = v_mod_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                  (   'Generation type for '
                   || v_mod_name
                   || ' does not exist in GIAC_MODULES table.'
                  );
         END;

         IF p_iss_cd = rec.pol_iss_cd THEN
            SELECT tran_id
              INTO v_gacc_tran_id
              FROM giac_batch_dv
             WHERE batch_dv_id = p_batch_id;
         ELSE
            v_gacc_tran_id := rec.tran_id;
         END IF;
         
         BEGIN
            SELECT MAX(NVL(item_no,0)) + 1
              INTO v_item_no
              FROM giac_taxes_wheld
             WHERE gacc_tran_id = v_gacc_tran_id
               AND payee_class_cd = rec.payee_class_cd
               AND payee_cd = rec.payee_cd;
         
            IF v_item_no IS NULL THEN
               v_item_no := 1;
            END IF;
         END;

         INSERT INTO giac_taxes_wheld
                     (gacc_tran_id, claim_id, advice_id,
                      gen_type, payee_class_cd, item_no,
                      payee_cd, gwtx_whtax_id, income_amt, wholding_tax_amt,
                      user_id, last_update
                     )
              VALUES (v_gacc_tran_id, rec.claim_id, rec.advice_id,
                      v_gen_type, rec.payee_class_cd, v_item_no, --p_item_no, -- dren 06.25.2015 : SR 0004628 - MAKE ITEM_NO SEQUENTIAL
                      rec.payee_cd, rec.tax_cd, rec.base_amt, rec.tax_amt,
                      p_user_id, SYSDATE
                     );
      END LOOP;
      
      FOR c1 IN (SELECT b.userid, d.event_desc  
                 FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                WHERE 1=1
                  AND c.event_cd = a.event_cd
                  AND c.event_mod_cd = a.event_mod_cd
                  AND b.event_mod_cd = a.event_mod_cd
                  AND b.passing_userid = p_user_id
                  AND a.module_id = 'GICLS032'
                  AND a.event_cd = d.event_cd
                  AND UPPER(d.event_desc) = 'CSR TO ACCOUNTING')
      LOOP
         CREATE_TRANSFER_WORKFLOW_REC('CSR TO ACCOUNTING', 'GICLS032', c1.userid, p_advice_id, '', p_msg_alert, p_workflow_msgr, p_user_id);
      END LOOP;

      delete_workflow_rec ('GENERATE SCSR', 'GICLS032', p_user_id, p_claim_id);
   END;
END;
/

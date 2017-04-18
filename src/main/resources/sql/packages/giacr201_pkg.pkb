CREATE OR REPLACE PACKAGE BODY CPI.giacr201_pkg
AS
   FUNCTION get_gl_acct_code (p_gacc_tran_id     VARCHAR2,
                              p_acct_entry_id    VARCHAR2)
      RETURN VARCHAR2
   IS
      v_gl_acct_code   VARCHAR2 (500);
   BEGIN
      SELECT    TO_CHAR (a.gl_acct_category)
             || '-'
             || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
             || '-'
             || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00'))
        INTO v_gl_acct_code
        FROM giac_acct_entries a
       WHERE     gacc_tran_id = p_gacc_tran_id
             AND acct_entry_id = p_acct_entry_id;

      RETURN v_gl_acct_code;
   END get_gl_acct_code;


   FUNCTION generate_giacr201 (p_branch_cd       VARCHAR2,
                               p_category        VARCHAR2,
                               p_fund_cd         VARCHAR2,
                               p_control         VARCHAR2,
                               p_from_date       VARCHAR2,
                               p_to_date         VARCHAR2,
                               p_tran_post       VARCHAR2,
                               p_sub1            VARCHAR2,
                               p_sub2            VARCHAR2,
                               p_sub3            VARCHAR2,
                               p_sub4            VARCHAR2,
                               p_sub5            VARCHAR2,
                               p_sub6            VARCHAR2,
                               p_sub7            VARCHAR2,
                               p_tran_flag       VARCHAR2,
                               p_tran_class      VARCHAR2,
                               p_beg_bal         VARCHAR2,
                               p_all_branches    VARCHAR2,
                               p_user_id       VARCHAR2,
                               p_module_id     VARCHAR2)
      RETURN giacr201_tab
      PIPELINED
   IS
      v_list               giacr201_type;
      v_1                  NUMBER;
      v_2                  NUMBER;
      v_3                  NUMBER;
      v_beg_deb_bal        NUMBER;           
      v_beg_cred_bal       NUMBER;           
      v_tot_debit_amt      NUMBER;           
      v_tot_credit_amt     NUMBER;            

      v_rec1               giacr201_type;
      v_tempTbl            giacr201_tab;
      v_beg_balance_flag   VARCHAR2 (1) := NVL (p_beg_bal, 'N');
      v_withCnt            VARCHAR2 (1);
      v_withTargetRec      VARCHAR2 (1);
      v_recPrinted         NUMBER ;
      v_branch_accessible  VARCHAR2 (2000); 

      TYPE tempRec IS RECORD
      (
         gacc_tran_id       giac_acctrans.tran_id%TYPE,
         gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
         gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
         gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
         gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
         gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
         gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
         gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
         gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
         gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
         tran_class         giac_acctrans.tran_class%TYPE,
         month_grp          VARCHAR2 (100),
         month_grp_seq      NUMBER,
         year_grp_seq       NUMBER,
         gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
         tot_debit_amt      NUMBER (16, 2),
         tot_credit_amt     NUMBER (16, 2),
         gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
         tran_date          giac_acctrans.tran_date%TYPE,
         posting_date       giac_acctrans.posting_date%TYPE,
         tran_flag          giac_acctrans.tran_flag%TYPE,
         particulars        giac_acctrans.particulars%TYPE,
         jv_ref_no          VARCHAR2 (10),
         jv_pref            giac_acctrans.jv_pref%TYPE,
         jv_seq_no          giac_acctrans.jv_seq_no%TYPE
      );

      TYPE tempRecTbl IS TABLE OF tempRec;

      v_tempTable          tempRecTbl;

      v_limit              NUMBER := 500;
      v_temp_indx          NUMBER := 0;

      TYPE v_totals_rec IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;


      v_gl_totals_indx     v_totals_rec;


      TYPE gl_beginning_bal_rec IS RECORD
      (
         gl_acct_id       giac_chart_of_accts.gl_acct_id%TYPE,
         beg_credit_amt   NUMBER (16, 2),
         beg_debit_amt    NUMBER (16, 2),
         beg_balance      NUMBER (16, 2)
      );

      TYPE gl_beginning_tbl IS TABLE OF gl_beginning_bal_rec;

      v_beg_bal_tbl        gl_beginning_tbl;

      v_company_name       giis_parameters.param_value_v%TYPE;
      v_company_address    giis_parameters.param_value_v%TYPE;
      v_company_tin        giis_parameters.param_value_v%TYPE; -- bonok :: 3.22.2017 :: SR 5964
		v_gen_version			giis_parameters.param_value_v%TYPE; -- bonok :: 3.22.2017 :: SR 5964


      CURSOR getAllRecords ( p_branches_withAcc VARCHAR2 ) 
      IS
           SELECT a.gacc_tran_id,
                  e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  b.tran_class,
                  DECODE (p_tran_post,
                          'T', TO_CHAR (b.tran_date, 'MM YYYY'),
                          'P', TO_CHAR (b.posting_date, 'MM YYYY'))
                     month_grp,
                  DECODE (p_tran_post,
                          'T', EXTRACT (MONTH FROM b.tran_date),
                          'P', EXTRACT (MONTH FROM b.posting_date))
                     month_grp_seq,
                  DECODE (p_tran_post,
                          'T', EXTRACT (YEAR FROM b.tran_date),
                          'P', EXTRACT (YEAR FROM b.posting_date))
                     year_grp_seq,
                  e.gl_acct_name,
                  SUM (NVL (a.debit_amt, 0)) tot_debit_amt,
                  SUM (NVL (a.credit_amt, 0)) tot_credit_amt,
                  e.gl_acct_id,
                  b.tran_date,
                  b.posting_date,
                  b.tran_flag,
                  b.particulars particulars,
                  LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                  b.jv_pref,
                  b.jv_seq_no
             FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts e
            WHERE     1 = 1
                  AND a.gacc_tran_id = b.tran_id
                  AND a.gl_acct_id = e.gl_acct_id
                  AND a.gacc_gibr_branch_cd =
                         DECODE (p_all_branches,
                                 'N', NVL (p_branch_cd, a.gacc_gibr_branch_cd),
                                 a.gacc_gibr_branch_cd)
                  AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 p_branches_withAcc)))               
                  AND a.gacc_gfun_fund_cd = p_fund_cd
                  AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
                  AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                  AND a.gl_sub_acct_1 = NVL (p_sub1, a.gl_sub_acct_1)
                  AND a.gl_sub_acct_2 = NVL (p_sub2, a.gl_sub_acct_2)
                  AND a.gl_sub_acct_3 = NVL (p_sub3, a.gl_sub_acct_3)
                  AND a.gl_sub_acct_4 = NVL (p_sub4, a.gl_sub_acct_4)
                  AND a.gl_sub_acct_5 = NVL (p_sub5, a.gl_sub_acct_5)
                  AND a.gl_sub_acct_6 = NVL (p_sub6, a.gl_sub_acct_6)
                  AND a.gl_sub_acct_7 = NVL (p_sub7, a.gl_sub_acct_7)
                  AND b.tran_class = NVL (p_tran_class, b.tran_class)
                  AND b.tran_flag <> 'D'
                  AND b.tran_flag NOT IN (p_tran_flag)
                  AND DECODE (p_tran_post,
                              'T', TRUNC (b.tran_date),
                              'P', TRUNC (b.posting_date),
                              TRUNC (b.tran_date)) BETWEEN TO_DATE (
                                                              p_from_date,
                                                              'mm-dd-yyyy')
                                                       AND TO_DATE (
                                                              p_to_date,
                                                              'mm-dd-yyyy')
         GROUP BY a.gacc_tran_id,
                  e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  e.gl_acct_id,
                  b.tran_date,
                  b.posting_date,
                  b.tran_class,
                  e.gl_acct_name,
                  b.tran_date,
                  b.posting_date,
                  b.tran_flag,
                  b.particulars,
                  b.jv_pref,
                  b.jv_seq_no,
                  b.tran_class_no
                  UNION
            SELECT DISTINCT NULL gacc_tran_id,
                            e.gl_acct_category,
                            e.gl_control_acct,
                            e.gl_sub_acct_1,
                            e.gl_sub_acct_2,
                            e.gl_sub_acct_3,
                            e.gl_sub_acct_4,
                            e.gl_sub_acct_5,
                            e.gl_sub_acct_6,
                            e.gl_sub_acct_7,
                            NULL tran_class,
                            NULL month_grp,
                            NULL month_grp_seq,
                            NULL year_grp_seq,
                            e.gl_acct_name,
                            0 tot_debit_amt,
                            0 tot_credit_amt,
                            e.gl_acct_id,
                            NULL tran_date,
                            NULL posting_date,
                            NULL tran_flag,
                            NULL particulars,
                            NULL jv_ref_no,
                            NULL jv_pref,
                            NULL jv_seq_no
              FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts e
             WHERE     1 = 1
                   AND 'Y' = p_beg_bal
                   AND a.gacc_tran_id = b.tran_id
                   AND a.gl_acct_id = e.gl_acct_id
                   AND TRUNC(b.posting_date) < TO_DATE (p_from_date,  'mm-dd-yyyy')
                   AND b.tran_flag = 'P'
                   AND a.gacc_gibr_branch_cd =
                          DECODE (p_all_branches,
                                  'N', NVL (p_branch_cd, a.gacc_gibr_branch_cd),
                                  a.gacc_gibr_branch_cd)
                   AND a.gacc_gibr_branch_cd IN
                                   (SELECT *
                                      FROM TABLE (
                                              SPLIT_COMMA_SEPARATED_STRING (p_branches_withAcc)))
                   AND a.gacc_gfun_fund_cd = p_fund_cd
                   AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
                   AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                   AND a.gl_sub_acct_1 = NVL (p_sub1, a.gl_sub_acct_1)
                   AND a.gl_sub_acct_2 = NVL (p_sub2, a.gl_sub_acct_2)
                   AND a.gl_sub_acct_3 = NVL (p_sub3, a.gl_sub_acct_3)
                   AND a.gl_sub_acct_4 = NVL (p_sub4, a.gl_sub_acct_4)
                   AND a.gl_sub_acct_5 = NVL (p_sub5, a.gl_sub_acct_5)
                   AND a.gl_sub_acct_6 = NVL (p_sub6, a.gl_sub_acct_6)
                   AND a.gl_sub_acct_7 = NVL (p_sub7, a.gl_sub_acct_7)
                   AND b.tran_class = NVL (p_tran_class, b.tran_class) ;

      PROCEDURE set_gl_acct_code (
         p_gl_acct_category   IN     giac_acct_entries.gl_acct_category%TYPE,
         p_gl_control_acct    IN     giac_acct_entries.gl_control_acct%TYPE,
         p_gl_sub_acct_1      IN     giac_acct_entries.gl_sub_acct_1%TYPE,
         p_gl_sub_acct_2      IN     giac_acct_entries.gl_sub_acct_2%TYPE,
         p_gl_sub_acct_3      IN     giac_acct_entries.gl_sub_acct_3%TYPE,
         p_gl_sub_acct_4      IN     giac_acct_entries.gl_sub_acct_4%TYPE,
         p_gl_sub_acct_5      IN     giac_acct_entries.gl_sub_acct_5%TYPE,
         p_gl_sub_acct_6      IN     giac_acct_entries.gl_sub_acct_6%TYPE,
         p_gl_sub_acct_7      IN     giac_acct_entries.gl_sub_acct_7%TYPE,
         p_gl_acct_code          OUT VARCHAR2)
      IS
         v_gl_acct_code   VARCHAR2 (100);
      BEGIN         

         v_gl_acct_code :=
               TO_CHAR (p_gl_acct_category)
            || '-'
            || LTRIM (TO_CHAR (p_gl_control_acct, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_1, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_2, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_3, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_4, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_5, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_6, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_7, '00'));



         p_gl_acct_code := v_gl_acct_code;
      END set_gl_acct_code;

      PROCEDURE set_otherDtlInfo (
         p_tran_id               giac_acctrans.tran_id%TYPE,
         p_particulars           giac_acctrans.particulars%TYPE,
         p_tran_class            giac_acctrans.tran_class%TYPE,
         p_ref_no            OUT VARCHAR2,
         p_name              OUT VARCHAR2,
         p_fin_particulars   OUT VARCHAR2)
      IS
         v_ref_no        VARCHAR2 (32767); --VARCHAR2(100), --edited by MarkS 04.12.2016
         v_col_ref_no    VARCHAR2 (100);
         v_name          VARCHAR2 (1000);
         v_particulars   VARCHAR2 (2000);
      BEGIN
         v_particulars := p_particulars;

         IF p_tran_class = 'COL'
         THEN
            FOR tb IN (SELECT or_pref_suf,
                              or_no,
                              particulars,
                              payor
                         FROM giac_order_of_payts a
                        WHERE a.gacc_tran_id = p_tran_id)
            LOOP
               v_col_ref_no :=
                  tb.or_pref_suf || ' ' || LPAD (TO_CHAR (tb.or_no), 10, '0');
               v_particulars := tb.particulars;
               v_name := tb.payor;
               EXIT;
            END LOOP;
         ELSIF p_tran_class = 'DV'
         THEN
            FOR tb IN (SELECT payee, particulars
                         FROM giac_disb_vouchers a
                        WHERE a.gacc_tran_id = p_tran_id)
            LOOP
               v_particulars := tb.particulars;
               v_name := tb.payee;
               EXIT;
            END LOOP;
         END IF;


         p_fin_particulars := v_particulars;
         p_name := v_name;

         v_ref_no :=
            GIACR201_PKG.get_cf_ref_no (p_tran_id,
                                        v_col_ref_no,
                                        p_tran_class);
         p_ref_no := v_ref_no;
      END set_otherDtlInfo;


      PROCEDURE getTotalsGLAcctID (
         p_gl_acct_id2          giac_chart_of_accts.gl_acct_id%TYPE,
         p_beg_debit_amt    OUT NUMBER,
         p_beg_credit_amt   OUT NUMBER,
         p_beg_balance      OUT NUMBER)
      IS
         v_cnt_temp         NUMBER := 0;
         v_debit_amt2       NUMBER (16, 2) := 0;
         v_credit_amt2      NUMBER (16, 2) := 0;
         v_balance2         NUMBER (16, 2) := 0;
         v_targetIndx       NUMBER := 0;
         v_rec_exists       VARCHAR2 (1) := 'N';
         v_max_collnCount   NUMBER := 100;
      BEGIN
         IF v_gl_totals_indx.EXISTS (p_gl_acct_id2)
         THEN
            v_rec_exists := 'Y';
            v_cnt_temp := v_beg_bal_tbl.COUNT;
         END IF;


         IF v_rec_exists = 'N' AND v_cnt_temp > v_max_collnCount
         THEN
            v_beg_bal_tbl.delete;
            v_temp_indx := 0;
            v_gl_totals_indx.delete;
         END IF;

         IF V_REC_EXISTS = 'N'
         THEN
            v_temp_indx := NVL (v_temp_indx, 0) + 1;
            v_beg_bal_tbl.EXTEND (1);
            v_gl_totals_indx (p_gl_acct_id2) := v_temp_indx;

            FOR ta01
               IN (  SELECT SUM (NVL (a.debit_amt, 0)) tot_debit_amt,
                            SUM (NVL (a.credit_amt, 0)) tot_credit_amt,
                            a.gl_acct_id
                       FROM giac_acct_entries a, giac_acctrans b
                      WHERE     a.gacc_tran_id = b.tran_id
                            AND a.gl_acct_id = P_gl_acct_id2
                            AND a.gacc_gibr_branch_cd =
                                   NVL (p_branch_cd, a.gacc_gibr_branch_cd)
                            AND a.gacc_gfun_fund_cd = p_fund_cd
                            AND a.gacc_gibr_branch_cd =
                                   DECODE (
                                      p_ALL_BRANCHES,
                                      'N', NVL (p_branch_cd,
                                                a.gacc_gibr_branch_cd),
                                      a.gacc_gibr_branch_cd)
                            AND b.posting_date <
                                   TO_DATE (p_from_date, 'mm-dd-yyyy')
                            AND b.tran_flag = 'P'
                   GROUP BY a.gl_acct_id)
            LOOP
               v_debit_amt2 := ta01.tot_debit_amt;
               v_credit_amt2 := ta01.tot_credit_amt;
               v_balance2 := ta01.tot_debit_amt - ta01.tot_credit_amt;


               v_beg_bal_tbl (v_temp_indx).gl_acct_id := p_gl_acct_id2;
               v_beg_bal_tbl (v_temp_indx).beg_credit_amt := v_credit_amt2;
               v_beg_bal_tbl (v_temp_indx).beg_debit_amt := v_debit_amt2;
               v_beg_bal_tbl (v_temp_indx).beg_balance := v_balance2;
               EXIT;
            END LOOP;
         ELSE
            v_targetIndx := v_gl_totals_indx (p_gl_acct_id2);
            v_debit_amt2 := v_beg_bal_tbl (v_targetIndx).beg_debit_amt;
            v_credit_amt2 := v_beg_bal_tbl (v_targetIndx).beg_credit_amt;
            v_balance2 := v_beg_bal_tbl (v_targetIndx).beg_balance;
         END IF;

         p_beg_debit_amt := v_debit_amt2;
         p_beg_credit_amt := v_credit_amt2;
         p_beg_balance := v_balance2;
      END getTotalsGLAcctID;

   BEGIN
      v_beg_bal_tbl := gl_beginning_tbl ();
      v_withTargetRec := 'N';
      v_recPrinted := 0 ; 

      v_company_name := giisp.v ('COMPANY_NAME');
      v_company_address := giisp.v ('COMPANY_ADDRESS');
      v_company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
      v_gen_version := giisp.v ('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id ); 
      
      IF v_branch_accessible IS NOT NULL THEN
        v_withTargetRec := 'Y';
      END IF; 
      
      IF v_withTargetRec = 'Y' THEN 


          OPEN getAllRecords ( v_branch_accessible ) ;

          LOOP
             FETCH getAllRecords
                BULK COLLECT INTO v_tempTable
                LIMIT v_limit;

             EXIT WHEN v_tempTable.COUNT = 0;

             FOR ctr IN 1 .. v_tempTable.COUNT
             LOOP
                v_list.tran_id :=
                   LPAD (TO_CHAR (v_tempTable (ctr).gacc_tran_id), 12, '0');


                v_list.month_grp :=
                   TO_CHAR (TO_DATE (v_tempTable (ctr).month_grp, 'MMYYYY'),
                            'fmMONTH YYYY');
                v_list.tran_class := v_tempTable (ctr).tran_class;
                v_list.month_grp_seq := v_tempTable (ctr).month_grp_seq;
                v_list.year_grp_seq := v_tempTable (ctr).year_grp_seq;
                v_list.tot_debit_amt := v_tempTable (ctr).tot_debit_amt;
                v_list.tot_credit_amt := v_tempTable (ctr).tot_credit_amt;
                v_list.tot_balance :=
                     NVL (v_tempTable (ctr).tot_debit_amt, 0)
                   - NVL (v_tempTable (ctr).tot_credit_amt, 0);

                set_gl_acct_code (v_tempTable (ctr).gl_acct_category,
                                  v_tempTable (ctr).gl_control_acct,
                                  v_tempTable (ctr).gl_sub_acct_1,
                                  v_tempTable (ctr).gl_sub_acct_2,
                                  v_tempTable (ctr).gl_sub_acct_3,
                                  v_tempTable (ctr).gl_sub_acct_4,
                                  v_tempTable (ctr).gl_sub_acct_5,
                                  v_tempTable (ctr).gl_sub_acct_6,
                                  v_tempTable (ctr).gl_sub_acct_7,
                                  v_list.gl_acct_code);


                set_otherDtlInfo (v_tempTable (ctr).gacc_tran_id,
                                  v_tempTable (ctr).particulars,
                                  v_tempTable (ctr).tran_class,
                                  v_list.ref_no,
                                  v_list.name,
                                  v_list.particulars);
                v_list.gl_acct_name := v_tempTable (ctr).gl_acct_name;

                -- jhing additional fields
                v_list.tran_date := v_tempTable (ctr).tran_date;
                v_list.posting_date := v_tempTable (ctr).posting_date;
                --            v_list.name := i.name;
                v_list.tran_flag := v_tempTable (ctr).tran_flag;
                v_list.jv_ref_no :=
                      v_tempTable (ctr).jv_pref
                   || ' '
                   || LPAD (TO_CHAR (v_tempTable (ctr).jv_seq_no), 12, '0');

                v_list.beg_deb_bal := 0;
                v_list.beg_cred_bal := 0;
                v_list.beg_bal := 0;

                IF NVL (v_beg_balance_flag, 'N') = 'Y'
                THEN
                   getTotalsGLAcctID (v_tempTable (ctr).gl_acct_id,
                                      v_list.beg_deb_bal,
                                      v_list.beg_cred_bal,
                                      v_list.beg_bal);
                END IF;


                v_list.company_name := v_company_name;
                v_list.company_address := v_company_address;
                v_list.company_tin := v_company_tin; -- bonok :: 3.22.2017 :: SR 5964
                v_list.gen_version := v_gen_version; -- bonok :: 3.22.2017 :: SR 5964
                v_list.from_date :=
                      TRIM (
                         TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month'))
                   || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
                v_list.TO_DATE :=
                      TRIM (TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month'))
                   || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');

                v_list.month_grp :=
                   TO_CHAR (TO_DATE (v_tempTable (ctr).month_grp, 'MMYYYY'),
                            'fmMONTH YYYY');
                            
                                        
                IF v_list.branch_name IS NULL AND p_branch_cd IS NOT NULL THEN
                    BEGIN
                       SELECT branch_name
                         INTO v_list.branch_name
                         FROM giac_branches
                        WHERE  branch_cd = p_branch_cd;
                       EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                             v_list.branch_name := NULL;    
                    END;
                END IF;               

                v_recPrinted := v_recPrinted + 1 ; 
                PIPE ROW (v_list);
             END LOOP;
          END LOOP;

          v_withCnt := 'N';

          IF v_beg_bal_tbl.COUNT > 0
          THEN
             v_withCnt := 'Y';
          END IF;

          IF v_withCnt = 'Y'
          THEN
             v_beg_bal_tbl.delete;
          END IF;

          v_withCnt := 'N';

          IF v_gl_totals_indx.COUNT > 0
          THEN
             v_withCnt := 'Y';
          END IF;


          IF v_withCnt = 'Y'
          THEN
             v_gl_totals_indx.delete;
          END IF;
      END IF;   
      
      
      IF  v_withTargetRec = 'N' OR v_recPrinted = 0 THEN 
        v_list.company_name := v_company_name;
        v_list.company_address := v_company_address;
        v_list.from_date :=
              TRIM (
                 TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month'))
           || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
        v_list.TO_DATE :=
              TRIM (TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month'))
           || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
           
        set_gl_acct_code (NVL(p_category,0),
                                  NVL(p_control,0),
                                  NVL(p_sub1,0),
                                  NVL(p_sub2,0),
                                  NVL(p_sub3,0),
                                  NVL(p_sub4,0),
                                  NVL(p_sub5,0),
                                  NVL(p_sub6,0),
                                  NVL(p_sub7,0),
                                  v_list.gl_acct_code);   
                                  
        IF p_category IS NOT NULL OR p_control IS NOT NULL THEN
            BEGIN
                SELECT gl_acct_name
                    INTO v_list.gl_acct_name
                    FROM giac_chart_of_accts 
                WHERE gl_acct_category = NVL(p_category,0)
                   AND gl_control_acct = NVL(p_control,0)
                   AND gl_sub_acct_1 =  NVL(p_sub1,0)
                   AND gl_sub_acct_2 =  NVL(p_sub2,0)
                   AND gl_sub_acct_3 =  NVL(p_sub3,0)
                   AND gl_sub_acct_4 =  NVL(p_sub4,0)
                   AND gl_sub_acct_5 =  NVL(p_sub5,0)
                   AND gl_sub_acct_6 =  NVL(p_sub6,0)
                   AND gl_sub_acct_7 =  NVL(p_sub7,0); 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_list.gl_acct_name := null;
            END;           
        
        END IF;                           
                   
        IF p_branch_cd IS NOT NULL THEN
            BEGIN
               SELECT branch_name
                 INTO v_list.branch_name
                 FROM giac_branches
                WHERE  branch_cd = p_branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_list.branch_name := NULL;    
            END;
        END IF;               

        PIPE ROW (v_list);
      END IF;  
   END generate_giacr201;

   PROCEDURE get_totals (p_branch_cd      IN     VARCHAR2,
                         p_fund_cd        IN     VARCHAR2,
                         p_tran_post      IN     VARCHAR2,
                         p_from_date      IN     VARCHAR2,
                         p_to_date        IN     VARCHAR2,
                         p_tran_flag      IN     VARCHAR2,
                         p_tran_class     IN     VARCHAR2,
                         p_gl_acct_code   IN     VARCHAR2,
                         tot_debit_amt       OUT NUMBER,
                         tot_credit_amt      OUT NUMBER,
                         tot_balance         OUT NUMBER)
   IS
   BEGIN
      SELECT SUM (a.debit_amt), SUM (a.credit_amt)
        INTO tot_debit_amt, tot_credit_amt
        FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts e
       WHERE     a.gacc_tran_id = b.tran_id
             AND a.gl_acct_id = e.gl_acct_id
             AND a.gacc_gibr_branch_cd =
                    NVL (p_branch_cd, a.gacc_gibr_branch_cd)
             AND a.gacc_gfun_fund_cd = p_fund_cd
             AND b.tran_class = NVL (p_tran_class, b.tran_class)
             AND b.tran_flag <> 'D'
             AND b.tran_flag NOT IN (p_tran_flag)
             AND DECODE (p_tran_post,
                         'T', TRUNC (b.tran_date),
                         'P', TRUNC (b.posting_date),
                         TRUNC (b.tran_date)) BETWEEN TO_DATE (p_from_date,
                                                               'mm/dd/yyyy')
                                                  AND TO_DATE (p_to_date,
                                                               'mm/dd/yyyy')
             AND GIACR201_PKG.get_gl_acct_code (a.gacc_tran_id,
                                                a.acct_entry_id) =
                    p_gl_acct_code;

      tot_balance := NVL (tot_debit_amt, 0) - NVL (tot_credit_amt, 0);
   END get_totals;

   FUNCTION get_giacr201_tran_date (p_branch_cd       VARCHAR2,
                                    p_fund_cd         VARCHAR2,
                                    p_tran_post       VARCHAR2,
                                    p_from_date       VARCHAR2,
                                    p_to_date         VARCHAR2,
                                    p_tran_flag       VARCHAR2,
                                    p_tran_class      VARCHAR2,
                                    p_gl_acct_code    VARCHAR2,
                                    p_month_grp       VARCHAR2)
      RETURN grp_tran_date_tab
      PIPELINED
   IS
      v_list   grp_tran_date_type;
   BEGIN
      FOR i
         IN (  SELECT DISTINCT TRUNC (b.tran_date) tran_date
                 FROM giac_acct_entries a, giac_acctrans b
                WHERE     a.gacc_tran_id = b.tran_id
                      AND a.gacc_gibr_branch_cd =
                             NVL (p_branch_cd, a.gacc_gibr_branch_cd)
                      AND a.gacc_gfun_fund_cd = p_fund_cd
                      AND b.tran_class = NVL (p_tran_class, b.tran_class)
                      AND b.tran_flag <> 'D'
                      AND b.tran_flag NOT IN (p_tran_flag)
                      AND DECODE (p_tran_post,
                                  'T', TRUNC (b.tran_date),
                                  'P', TRUNC (b.posting_date),
                                  TRUNC (b.tran_date)) BETWEEN TO_DATE (
                                                                  p_from_date,
                                                                  'mm/dd/yyyy')
                                                           AND TO_DATE (
                                                                  p_to_date,
                                                                  'mm/dd/yyyy')
                      AND GIACR201_PKG.get_gl_acct_code (a.gacc_tran_id,
                                                         a.acct_entry_id) =
                             p_gl_acct_code
                      AND DECODE (
                             p_tran_post,
                             'T', TO_CHAR (
                                     TO_DATE (TO_CHAR (tran_date, 'MM YYYY'),
                                              'MMYYYY'),
                                     'fmMONTH YYYY'),
                             'P', TO_CHAR (
                                     TO_DATE (
                                        TO_CHAR (posting_date, 'MM YYYY'),
                                        'MMYYYY'),
                                     'fmMONTH YYYY'),
                             TO_CHAR (
                                TO_DATE (TO_CHAR (tran_date, 'MM YYYY'),
                                         'MMYYYY'),
                                'fmMONTH YYYY')) =
                             TO_CHAR (TO_DATE (p_month_grp, 'MMYYYY'),
                                      'fmMONTH YYYY')            --p_month_grp
             ORDER BY tran_date)
      LOOP
         v_list.tran_date := i.tran_date;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr201_tran_date;

   FUNCTION get_giacr201_details (p_branch_cd       VARCHAR2,
                                  p_fund_cd         VARCHAR2,
                                  p_tran_post       VARCHAR2,
                                  p_from_date       VARCHAR2,
                                  p_to_date         VARCHAR2,
                                  p_tran_flag       VARCHAR2,
                                  p_tran_class      VARCHAR2,
                                  p_gl_acct_code    VARCHAR2,
                                  p_month_grp       VARCHAR2,
                                  p_tran_date       VARCHAR2)
      RETURN giacr201_details_tab
      PIPELINED
   IS
      v_list   giacr201_details_type;
   BEGIN
      --   raise_application_error (-20001,'tran_date ' || p_tran_date);

      FOR i
         IN (  SELECT DISTINCT
                      LPAD (a.gacc_tran_id, 12, 0) gacc_tran_id, --a.acct_entry_id,
                      TRUNC (b.posting_date) posting_date,
                      DECODE (b.tran_class,  'COL', c.payor,  'DV', d.payee)
                         name,
                      DECODE (b.tran_class,
                              'COL', c.particulars,
                              'DV', d.particulars,
                              'JV', b.particulars,
                              b.particulars)
                         particulars,
                      b.tran_flag,
                      LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                      c.or_pref_suf || ' ' || LPAD (TO_CHAR (c.or_no), 10, '0')
                         col_ref_no,
                      b.jv_pref,
                      b.jv_seq_no                   -- added by gab 09.14.2015
                 FROM giac_acct_entries a,
                      giac_acctrans b,
                      giac_order_of_payts c,
                      giac_disb_vouchers d
                WHERE     a.gacc_tran_id = b.tran_id
                      AND a.gacc_tran_id = c.gacc_tran_id(+)
                      AND a.gacc_tran_id = d.gacc_tran_id(+)
                      AND GIACR201_PKG.get_gl_acct_code (a.gacc_tran_id,
                                                         a.acct_entry_id) =
                             p_gl_acct_code
                      AND b.tran_class = NVL (p_tran_class, b.tran_class) --vondanix 12.7.15
                      AND DECODE (
                             p_tran_post,
                             'T', TO_CHAR (
                                     TO_DATE (TO_CHAR (tran_date, 'MM YYYY'),
                                              'MMYYYY'),
                                     'fmMONTH YYYY'),
                             'P', TO_CHAR (
                                     TO_DATE (
                                        TO_CHAR (posting_date, 'MM YYYY'),
                                        'MMYYYY'),
                                     'fmMONTH YYYY'),
                             TO_CHAR (
                                TO_DATE (TO_CHAR (tran_date, 'MM YYYY'),
                                         'MMYYYY'),
                                'fmMONTH YYYY')) =
                             TO_CHAR (TO_DATE (p_month_grp, 'MMYYYY'),
                                      'fmMONTH YYYY')            --p_month_grp
                      AND TRUNC (b.tran_date) =
                             TO_DATE (p_tran_date, 'MM/DD/YYYY') --vondanix 10.26.2015
             ORDER BY 1,
                      2,
                      3,
                      4,
                      5,
                      6,
                      7)
      LOOP
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.posting_date := i.posting_date;
         v_list.name := i.name;
         v_list.particulars := i.particulars;
         v_list.tran_flag := i.tran_flag;
         v_list.jv_ref_no := i.jv_ref_no;
         v_list.col_ref_no := i.col_ref_no;
         v_list.cf_ref_no :=
            GIACR201_PKG.get_cf_ref_no (i.gacc_tran_id,
                                        i.col_ref_no,
                                        p_tran_class);
         v_list.jv_ref_no_2 :=
            i.jv_pref || ' ' || LPAD (TO_CHAR (i.jv_seq_no), 12, '0'); -- added by gab 09.14.2015

         PIPE ROW (v_list);
      END LOOP;
   END get_giacr201_details;

   FUNCTION get_cf_ref_no (p_tran_id       VARCHAR2,
                           p_col_ref_no    VARCHAR2,
                           p_tran_class    VARCHAR2)
      RETURN VARCHAR2
   IS
      v_ref_no      VARCHAR2 (1000);
      v_ctr         NUMBER (3) := 0;
      v_exist_rev   NUMBER := 0;
   BEGIN
      BEGIN
         SELECT 1
           INTO v_exist_rev
           FROM GIAC_REVERSALS
          WHERE REVERSING_TRAN_ID = p_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist_rev := 0;
      END;

      IF v_exist_rev = 1
      THEN
         BEGIN
            SELECT    'REV-'
                   || tran_year
                   || '-'
                   || tran_month
                   || '-'
                   || tran_seq_no
              INTO v_ref_no
              FROM giac_acctrans
             WHERE tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ref_no := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               v_ref_no := v_ref_no;
         END;
      ELSE
         IF p_tran_class = 'COL'
         THEN
            RETURN (p_col_ref_no );
         ELSIF p_tran_class = 'DV'
         THEN
            BEGIN
               SELECT    a.dv_pref
                      || '-'
                      || LPAD (TO_CHAR (a.dv_no), 10, '0')
                      || '/'
                      || b.check_pref_suf
                      || '-'
                      || LPAD (TO_CHAR (b.check_no), 10, '0')
                 INTO v_ref_no
                 FROM giac_disb_vouchers a, giac_chk_disbursement b
                WHERE     b.check_stat = 2
                      AND a.gacc_tran_id = b.gacc_tran_id
                      AND a.gacc_tran_id = p_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT    document_cd
                         || '-'
                         || branch_cd
                         || '-'
                         || LPAD (TO_CHAR (doc_year), 4, '0')
                         || '-'
                         || LPAD (TO_CHAR (doc_mm), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (doc_seq_no), 6, '0')
                    INTO v_ref_no
                    FROM giac_payt_requests a, giac_payt_requests_dtl b
                   WHERE a.ref_id = b.gprq_ref_id AND tran_id = p_tran_id;
               WHEN TOO_MANY_ROWS
               THEN
                  FOR X
                     IN (SELECT    a.dv_pref
                                || '-'
                                || LPAD (TO_CHAR (a.dv_no), 10, '0')
                                || '/'
                                || b.check_pref_suf
                                || '-'
                                || LPAD (TO_CHAR (b.check_no), 10, '0')
                                   REFNO
                           FROM giac_disb_vouchers a, giac_chk_disbursement b
                          WHERE     b.check_stat = 2
                                AND a.gacc_tran_id = b.gacc_tran_id
                                AND a.gacc_tran_id = p_tran_id order by REFNO DESC) --Edited By MarkS 06.21.2016
                  LOOP
                     v_ctr := v_ctr + 1;

                     IF v_ctr >= 1 -- IF v_ctr > 1 --Edited By MarkS 04.25.2016 
                     THEN
                        v_ref_no := X.REFNO || CHR (10) || v_ref_no; --Edited By MarkS 06.21.2016
                     END IF;
                  END LOOP;
            END;
         ELSIF p_tran_class = 'JV'
         THEN
            BEGIN
               SELECT    DECODE (ref_jv_no, NULL, NULL, ref_jv_no || ' / ')
                      || tran_year
                      || '-'
                      || tran_month
                      || '-'
                      || tran_seq_no
                      || ' / '
                      || jv_pref_suff
                      || '-'
                      || LPAD (TO_CHAR (jv_no), 6, '0')
                 INTO v_ref_no
                 FROM giac_acctrans
                WHERE tran_id = p_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_no := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_ref_no := v_ref_no;
            END;
         ELSE
            v_ref_no := CPI.get_ref_no (p_tran_id);
         END IF;
      END IF;

      RETURN (v_ref_no );
   END get_cf_ref_no;

   FUNCTION get_giacr201_amounts (
      p_tran_post       VARCHAR2,
      p_tran_class      VARCHAR2,
      p_gl_acct_code    VARCHAR2,
      p_month_grp       VARCHAR2,
      p_tran_date       VARCHAR2,
      p_gacc_tran_id    giac_acct_entries.gacc_tran_id%TYPE)
      RETURN giacr201_amounts_tab
      PIPELINED
   IS
      v_list   giacr201_amounts_type;
   BEGIN
      FOR i
         IN (  SELECT a.debit_amt, a.credit_amt
                 FROM giac_acct_entries a,
                      giac_acctrans b,
                      giac_order_of_payts c,
                      giac_disb_vouchers d
                WHERE     a.gacc_tran_id = b.tran_id
                      AND a.gacc_tran_id = c.gacc_tran_id(+)
                      AND a.gacc_tran_id = d.gacc_tran_id(+)
                      AND GIACR201_PKG.get_gl_acct_code (a.gacc_tran_id,
                                                         a.acct_entry_id) =
                             p_gl_acct_code
                      AND DECODE (
                             p_tran_post,
                             'T', TO_CHAR (
                                     TO_DATE (
                                        TO_CHAR (TRUNC (tran_date), 'MM YYYY'),
                                        'MMYYYY'),
                                     'fmMONTH YYYY'),
                             'P', TO_CHAR (
                                     TO_DATE (
                                        TO_CHAR (TRUNC (posting_date),
                                                 'MM YYYY'),
                                        'MMYYYY'),
                                     'fmMONTH YYYY'),
                             TO_CHAR (
                                TO_DATE (
                                   TO_CHAR (TRUNC (tran_date), 'MM YYYY'),
                                   'MMYYYY'),
                                'fmMONTH YYYY')) =
                             TO_CHAR (TO_DATE (p_month_grp, 'MMYYYY'),
                                      'fmMONTH YYYY')            --p_month_grp
                      AND b.tran_class = NVL (p_tran_class, b.tran_class)
                      AND TRUNC (b.tran_date) =
                             TO_DATE (p_tran_date, 'MM/DD/YYYY') --vondanix 10.26.2015
                      AND a.gacc_tran_id = p_gacc_tran_id
             ORDER BY b.tran_id,
                      b.posting_date,
                      DECODE (b.tran_class,  'COL', c.payor,  'DV', d.payee),
                      DECODE (b.tran_class,
                              'COL', c.particulars,
                              'DV', d.particulars,
                              'JV', b.particulars,
                              b.particulars),
                      b.tran_flag,
                      LPAD (TO_CHAR (b.tran_class_no), 10, '0'),
                         c.or_pref_suf
                      || ' '
                      || LPAD (TO_CHAR (c.or_no), 10, '0'),
                      1,
                      2)
      LOOP
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         v_list.balance := NVL (i.debit_amt, 0) - NVL (i.credit_amt, 0);
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr201_amounts;
END;
/
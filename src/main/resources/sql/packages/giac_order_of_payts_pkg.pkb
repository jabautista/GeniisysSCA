CREATE OR REPLACE PACKAGE BODY CPI.giac_order_of_payts_pkg
AS
   PROCEDURE set_giac_order_of_payts (
      v_gacc_tran_id        IN OUT   giac_order_of_payts.gacc_tran_id%TYPE,
      v_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      v_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      v_payor                        giac_order_of_payts.payor%TYPE,
      v_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      v_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
      v_address_1                    giac_order_of_payts.address_1%TYPE,
      v_address_2                    giac_order_of_payts.address_2%TYPE,
      v_address_3                    giac_order_of_payts.address_3%TYPE,
      v_particulars                  giac_order_of_payts.particulars%TYPE,
      v_or_tag                       giac_order_of_payts.or_tag%TYPE,
      v_or_date                      giac_order_of_payts.or_date%TYPE,
      v_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      v_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      v_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      v_or_flag                      giac_order_of_payts.or_flag%TYPE,
      v_op_flag                      giac_order_of_payts.op_flag%TYPE,
      v_currcd                       giac_order_of_payts.currency_cd%TYPE,
      v_intmno                       giac_order_of_payts.intm_no%TYPE,
      v_tinno                        giac_order_of_payts.tin%TYPE,
      v_uploadtag                    giac_order_of_payts.upload_tag%TYPE,
      v_remitdate                    giac_order_of_payts.remit_date%TYPE,
      v_provreceiptno                giac_order_of_payts.prov_receipt_no%TYPE,
      v_or_no                        giac_order_of_payts.or_no%TYPE,
      v_or_pref_suf                  giac_order_of_payts.or_pref_suf%TYPE,
      v_ri_comm_tag                  giac_order_of_payts.ri_comm_tag%TYPE -- added by: Nica 06.14.2013 AC-SPECS-2012-155
   )
   
   IS
      v_count_exist       NUMBER(12)   := 0; --john 10.28.2014
      v_new_curr_rt       NUMBER(12,9) := 1; --john 10.28.2014
      v_new_foreign_amt   NUMBER(12,2) := 0; --john 10.28.2014
	  
	  TYPE v_giac_op_text_tab IS TABLE OF giac_op_text%ROWTYPE;  --john 2.17.2015
      new_v_tab   v_giac_op_text_tab := v_giac_op_text_tab();    --john 2.17.2015
      v_count     NUMBER := 1; --john 2.17.2015
      v_check     NUMBER := 0; --john 2.17.2015
   BEGIN
      IF v_gacc_tran_id = 0
      THEN
         SELECT acctran_tran_id_s.NEXTVAL
           INTO v_gacc_tran_id
           FROM DUAL;
      END IF;

      MERGE INTO giac_order_of_payts
         USING DUAL
         ON (gacc_tran_id = v_gacc_tran_id)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd, payor,
                    collection_amt, cashier_cd, address_1, address_2,
                    address_3, particulars, or_tag, or_date, dcb_no,
                    gross_amt, gross_tag, user_id, last_update, or_flag,
                    op_flag, currency_cd, intm_no, tin, upload_tag,
                    remit_date, prov_receipt_no, or_no, or_pref_suf, ri_comm_tag)
            VALUES (v_gacc_tran_id, v_gibr_gfun_fund_cd, v_gibr_branch_cd,
                    v_payor, v_collection_amt, v_cashier_cd, v_address_1,
                    v_address_2, v_address_3, v_particulars, v_or_tag,
                    v_or_date, v_dcb_no, v_gross_amt, v_gross_tag, NVL (giis_users_pkg.app_user, USER),
                    SYSDATE, v_or_flag, v_op_flag, v_currcd, v_intmno,
                    v_tinno, v_uploadtag, v_remitdate, v_provreceiptno, v_or_no, v_or_pref_suf, v_ri_comm_tag)
         WHEN MATCHED THEN
            UPDATE
               SET gibr_gfun_fund_cd = v_gibr_gfun_fund_cd,
                   gibr_branch_cd = v_gibr_branch_cd, payor = v_payor,
                   collection_amt = v_collection_amt,
                   cashier_cd = v_cashier_cd, address_1 = v_address_1,
                   address_2 = v_address_2, address_3 = v_address_3,
                   particulars = v_particulars, or_tag = v_or_tag,
                   or_date = v_or_date, dcb_no = v_dcb_no,
                   gross_amt = v_gross_amt, gross_tag = v_gross_tag,
                   user_id = NVL (giis_users_pkg.app_user, USER), last_update = SYSDATE, --or_flag = v_or_flag,
                   op_flag = v_op_flag, currency_cd = v_currcd,
                   intm_no = v_intmno, tin = v_tinno,
                   upload_tag = v_uploadtag, remit_date = v_remitdate,
                   prov_receipt_no = v_provreceiptno,
                   ri_comm_tag = v_ri_comm_tag
                   , or_pref_suf = v_or_pref_suf, or_no = v_or_no --Deo [02.16.2017]: SR-5932
            ;
        
       --added by john 10.28.2014 - to update displayed values on OR preview when currency is updated in GIACS001    
        /*BEGIN
            SELECT COUNT (1)
              INTO v_count_exist
              FROM giac_op_text
             WHERE gacc_tran_id = v_gacc_tran_id;
             
            SELECT currency_rt
              INTO v_new_curr_rt 
              FROM giis_currency
             WHERE main_currency_cd = v_currcd;
             
             IF v_count_exist > 0 THEN
                FOR i IN(
                    SELECT *
                      FROM giac_op_text
                     WHERE gacc_tran_id = v_gacc_tran_id
                )
                LOOP
                     v_new_foreign_amt := ROUND(i.item_amt / v_new_curr_rt, 2);
                     
                     BEGIN
                        UPDATE giac_op_text
                           SET currency_cd = v_currcd,
                               foreign_curr_amt = v_new_foreign_amt
                         WHERE gacc_tran_id = i.gacc_tran_id
                           AND item_gen_type = i.item_gen_type
                           AND item_seq_no = i.item_seq_no;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                     END;
                END LOOP;
             END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
		
		--added by john 2.17.2015 --merge records with same item_text on giac_op_text
        BEGIN
            FOR i IN (
                SELECT *
                  FROM giac_op_text
                  WHERE gacc_tran_id = v_gacc_tran_id
            )
            LOOP
                FOR j IN (
                    SELECT *
                      FROM giac_op_text
                      WHERE gacc_tran_id = v_gacc_tran_id
                )
                LOOP
                    IF i.item_text = j.item_text AND i.item_seq_no != j.item_seq_no THEN
                        i.item_amt          := i.item_amt + j.item_amt;
                        i.foreign_curr_amt  := i.foreign_curr_amt + j.foreign_curr_amt;
                        i.user_id           := nvl (giis_users_pkg.app_user, user);
                        i.last_update       := sysdate;
                    END IF;
                END LOOP;
                
                
                IF v_count != 1 THEN
                    FOR k IN 1..new_v_tab.COUNT
                    LOOP
                        v_check := 0;
                        IF new_v_tab(k).item_text = i.item_text THEN
                            v_check := 1;
                            EXIT;
                        END IF;
                        
                    END LOOP;
                    
                    IF v_check != 1 THEN
                        new_v_tab.EXTEND;
                        i.item_seq_no   := v_count;
                        i.print_seq_no  := v_count;
                        new_v_tab(v_count) := i;
                        v_count := v_count + 1;
                    END IF;
                ELSE
                    new_v_tab.EXTEND;
                    i.item_seq_no   := v_count;
                    i.print_seq_no  := v_count;
                    new_v_tab(v_count) := i;
                    v_count := v_count + 1;
                END IF;
            END LOOP;
        END;
        
        -- john 2.17.2015 --reinsert merged records in GIAC_OP_TEXT
        DELETE FROM GIAC_OP_TEXT
        WHERE GACC_TRAN_ID = v_gacc_tran_id;
        
        FORALL i IN 1..new_v_tab.COUNT
        INSERT INTO GIAC_OP_TEXT VALUES new_v_tab(i); */
   END set_giac_order_of_payts;

   FUNCTION get_cancelled_or_details (
      p_or_pref_suf   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no         giac_order_of_payts.or_no%TYPE
   )
      RETURN giac_order_of_payts_tab PIPELINED
   IS
      v_cancelleddtls   giac_order_of_payts_type;
      v_gacc_tranid     giac_order_of_payts.gacc_tran_id%TYPE;
   BEGIN
      BEGIN
         SELECT gacc_tran_id
           INTO v_gacc_tranid
           FROM giac_order_of_payts
          WHERE or_flag = 'C'
            AND NVL (or_pref_suf, '-') =
                                   NVL (p_or_pref_suf, NVL (or_pref_suf, '-'))
            AND or_no = p_or_no;

         IF SQL%FOUND
         THEN
            FOR i IN (SELECT payor, address_1, address_2, address_3, or_date,
                             or_tag, particulars, tin, gacc_tran_id
                        FROM giac_order_of_payts
                       WHERE gacc_tran_id = v_gacc_tranid)
            LOOP
               v_cancelleddtls.payor := i.payor;
               v_cancelleddtls.address_1 := i.address_1;
               v_cancelleddtls.address_2 := i.address_2;
               v_cancelleddtls.address_3 := i.address_3;
               v_cancelleddtls.or_date := i.or_date;
               v_cancelleddtls.or_tag := i.or_tag;
               v_cancelleddtls.particulars := i.particulars;
               v_cancelleddtls.tin := i.tin;
               v_cancelleddtls.gacc_tran_id := i.gacc_tran_id;
               PIPE ROW (v_cancelleddtls);
            END LOOP;

            RETURN;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END;

   FUNCTION get_giac_order_of_payts_dtl (
      p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_order_of_payts_dtl_tab PIPELINED
   IS
      v_giac_order_of_payts_dtl   giac_order_of_payts_dtl_type;
   BEGIN
      FOR i IN (SELECT DISTINCT A.gacc_tran_id,
                                   TO_CHAR (b.tran_year)
                                || '-'
                                || TO_CHAR (b.tran_month, '09')
                                || '-'
                                || TO_CHAR (b.tran_seq_no, '000009') tran_no,
                                A.gibr_gfun_fund_cd, A.gibr_branch_cd,
                                A.op_no, A.op_date, A.op_flag, A.op_tag,
                                A.or_no, TRUNC (A.or_date) or_date,
                                A.or_flag, A.payor, A.gross_amt,
                                A.collection_amt, A.currency_cd, A.gross_tag,
                                A.address_1, A.address_2, A.address_3,
                                A.particulars, a.ri_comm_tag                             --,
                           --c.short_name currency_sname,
                           --d.param_value_v f_currency_sname,
                           --c.currency_rt
                FROM            giac_order_of_payts A,
                                giac_acctrans b,
                                giis_currency c,
                                giac_parameters d    --, GIAC_COLLECTION_DTL e
                          WHERE A.gacc_tran_id = p_tran_id
                            AND b.tran_id = p_tran_id
                            --AND e.gacc_tran_id = p_tran_id
                            AND A.currency_cd = c.main_currency_cd(+)
                            AND d.param_name = 'DEFAULT_CURRENCY')
      LOOP
         v_giac_order_of_payts_dtl.gacc_tran_id := i.gacc_tran_id;
         v_giac_order_of_payts_dtl.tran_no := i.tran_no;
         v_giac_order_of_payts_dtl.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_giac_order_of_payts_dtl.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_order_of_payts_dtl.op_no := i.op_no;
         v_giac_order_of_payts_dtl.op_date := i.op_date;
         v_giac_order_of_payts_dtl.op_flag := i.op_flag;
         v_giac_order_of_payts_dtl.op_tag := i.op_tag;
         v_giac_order_of_payts_dtl.or_no := i.or_no;
         v_giac_order_of_payts_dtl.or_date := i.or_date;
         v_giac_order_of_payts_dtl.or_date := i.or_date;
         v_giac_order_of_payts_dtl.or_flag := i.or_flag;
         v_giac_order_of_payts_dtl.payor := i.payor;
         v_giac_order_of_payts_dtl.collection_amt := i.collection_amt;
         v_giac_order_of_payts_dtl.gross_amt := i.gross_amt;
         v_giac_order_of_payts_dtl.currency_cd := i.currency_cd;
         v_giac_order_of_payts_dtl.gross_tag := i.gross_tag;
         v_giac_order_of_payts_dtl.address_1 := i.address_1;
         v_giac_order_of_payts_dtl.address_2 := i.address_2;
         v_giac_order_of_payts_dtl.address_3 := i.address_3;
         v_giac_order_of_payts_dtl.particulars := i.particulars;
         v_giac_order_of_payts_dtl.ri_comm_tag := i.ri_comm_tag;
         --v_giac_order_of_payts_dtl.currency_sname := i.currency_sname;
         --v_giac_order_of_payts_dtl.f_currency_sname := i.f_currency_sname;
         PIPE ROW (v_giac_order_of_payts_dtl);
      END LOOP;

      RETURN;
   END get_giac_order_of_payts_dtl;

   FUNCTION get_or_tag (p_workf_col_value NUMBER)
      RETURN VARCHAR2
   IS
      v_or_tag   giac_order_of_payts.or_tag%TYPE;
   BEGIN
      BEGIN
         SELECT or_tag
           INTO v_or_tag
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_workf_col_value;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_or_tag := NULL;
      END;

      RETURN v_or_tag;
   END get_or_tag;

   FUNCTION get_or_list (
      p_search_key   VARCHAR2,
      p_fund_cd      giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd    giac_order_of_payts.gibr_branch_cd%TYPE
   )
      RETURN or_list_tab PIPELINED
   IS
      v_or_list       or_list_type;
      v_date_search   DATE;
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_date_search
      BEGIN
         v_date_search := TO_DATE (p_search_key, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_date_search := NULL;
      END;
       
      FOR or_list IN
         (SELECT   A.dcb_no || '-' || A.cashier_cd dcb_no,
                   A.or_pref_suf || '-' || A.or_no or_no, A.or_date,
                   cg_ref_codes_pkg.get_rv_meaning
                                       ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                        A.or_flag
                                       ) status,
                   A.payor,
                   c.bank_name || '/' || d.bank_acct_no dcb_bank_acct,
                   A.gacc_tran_id, b.item_no, A.gibr_branch_cd,
                   A.gibr_gfun_fund_cd, A.or_tag, A.or_flag, A.op_tag,
                   A.with_pdc
              FROM giac_order_of_payts A,
                   giac_collection_dtl b,
                   giac_banks c,
                   giac_bank_accounts d
             WHERE A.gacc_tran_id = b.gacc_tran_id
               AND c.bank_cd = b.dcb_bank_cd
               AND b.dcb_bank_cd = d.bank_cd
               AND d.bank_acct_cd = b.dcb_bank_acct_cd
               AND op_no IS NULL
               -- AND or_tag IS NULL
               AND gibr_gfun_fund_cd = NVL (p_fund_cd, gibr_gfun_fund_cd)
               AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
               AND (   (UPPER (A.dcb_no || '-' || A.cashier_cd) LIKE
                                                    '%' || p_search_key || '%'
                       )
                    OR (UPPER (A.or_pref_suf || '-' || A.or_no) LIKE
                                                    '%' || p_search_key || '%'
                       )
                    OR (UPPER
                           (cg_ref_codes_pkg.get_rv_meaning
                                               ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                                A.or_flag
                                               )
                           ) LIKE '%' || p_search_key || '%'
                       )
                    OR (UPPER (A.payor) LIKE '%' || p_search_key || '%')
                    OR (UPPER (c.bank_name || '/' || d.bank_acct_no) LIKE
                                                    '%' || p_search_key || '%'
                       )
                    OR (A.or_date = NVL (v_date_search, A.or_date))
                   )
          ORDER BY or_date DESC, dcb_no, A.payor)
      LOOP
         v_or_list.dcb_no := or_list.dcb_no;
         v_or_list.or_no := or_list.or_no;
         v_or_list.or_date := or_list.or_date;
         v_or_list.status := or_list.status;
         v_or_list.payor := or_list.payor;
         v_or_list.dcb_bank_acct := or_list.dcb_bank_acct;
         v_or_list.item_no := or_list.item_no;
         v_or_list.gacc_tran_id := or_list.gacc_tran_id;
         v_or_list.gibr_branch_cd := or_list.gibr_branch_cd;
         v_or_list.gibr_gfun_fund_cd := or_list.gibr_gfun_fund_cd;
         v_or_list.or_tag := or_list.or_tag;
         v_or_list.or_flag := or_list.or_flag;
         v_or_list.op_tag := or_list.op_tag;
         v_or_list.with_pdc := or_list.with_pdc;
         PIPE ROW (v_or_list);
      END LOOP;
   END get_or_list;

   FUNCTION get_or_list2 (
      p_fund_cd             giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd           giac_order_of_payts.gibr_branch_cd%TYPE,
      p_dcb_no              VARCHAR2,
      p_or_no               VARCHAR2,
      p_payor               giac_order_of_payts.payor%TYPE,
      p_status              VARCHAR2,
      p_or_date             VARCHAR2, 
      p_last_update         VARCHAR2, -- Added by Jerome Bautista 11.02.2015 SR 20144
      p_cashier             giac_order_of_payts.user_id%TYPE,
      p_user_id             giac_order_of_payts.user_id%TYPE, 
      p_cancel_or           VARCHAR2,
      p_or_tag              VARCHAR2,       --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      p_order_by            VARCHAR2,       --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      p_asc_desc_flag       VARCHAR2,       --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      p_first_row           NUMBER,         --mikel 01.22.2014
      p_last_row            NUMBER          --mikel 11.05.2014
   )
      RETURN or_list_tab PIPELINED
   IS
      v_or_list       or_list_type;
      v_date_search   DATE;
      v_date_search2  DATE; --for last_update
      v_all_user_sw      GIIS_USERS.all_user_sw%TYPE; --removed := 'N' by christian 04.30.2012
      v_or_flag         varchar2(2);
      v_max_or_no     giac_order_of_payts.or_no%TYPE; --mikel 11.05.2014
      TYPE cur_type IS REF CURSOR;      --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      c        cur_type;                --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
      v_sql    VARCHAR2(32767);         --added by pjsantos @pcic 09/26/2016, for optimization GENQA 5687
   BEGIN
      -- check first if search key is in date format. if yes, store it to v_date_search
      BEGIN
         v_date_search := TO_DATE (p_or_date, 'MM-DD-RRRR');
         v_date_search2 := TO_DATE(p_last_update, 'MM-DD-RRRR'); -- Added by Jerome Bautista 11.03.2015 SR 20144
      EXCEPTION
         WHEN OTHERS
         THEN
            v_date_search := NULL;
            v_date_search2 := NULL; -- Added by Jerome Bautista 11.03.2015 SR 20144
      END;

      IF v_date_search IS NULL
      THEN
         BEGIN
            v_date_search := TO_DATE (p_or_date, 'RRRR-MM-DD');
         EXCEPTION
            WHEN OTHERS
            THEN
               v_date_search := NULL;
         END;
      END IF;
      
      IF v_date_search2 IS NULL -- Added by Jerome Bautista 11.03.2015
      THEN
         BEGIN
            v_date_search2 := TO_DATE (p_last_update, 'RRRR-MM-DD');
         EXCEPTION
            WHEN OTHERS
            THEN
               v_date_search2 := NULL;
         END;
      END IF;
      
      FOR i IN (SELECT all_user_sw
                         FROM giis_users
                 WHERE user_id = p_user_id)
      LOOP
            v_all_user_sw := i.all_user_sw;
      END LOOP;
      
      --11/15/2013 added by MJ, will check p_status' value
      IF p_status IS NULL THEN
         v_or_flag := '%';
      ELSE
         v_or_flag := SUBSTR(UPPER(p_status),1,1);
      END IF;
      
      /*--mikel 11.05.2014
      v_max_or_no := p_last_row;
       
      IF p_last_row = 0 THEN
         SELECT COUNT(1)
           INTO v_max_or_no
           FROM giac_order_of_payts
          WHERE gibr_gfun_fund_cd = p_fund_cd 
            AND gibr_branch_cd = p_branch_cd;
      END IF;*/ --comment out by mikel 01.22.2015; no use 

--      FOR or_list IN
--         (SELECT *
--             FROM (SELECT ROWNUM rownum_, a.*
--                     FROM ( --mikel 11.05.2014; optimization
--                     SELECT   /*+FIRST_ROWS(10) */ --11/15/2013 Added by MJ for optimization
--                    /*A.dcb_no || '-' || A.cashier_cd dcb_no,
--                   A.or_pref_suf || '-' || A.or_no or_no, A.or_date,
--                   cg_ref_codes_pkg.get_rv_meaning
--                                       ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
--                                        A.or_flag
--                                       ) status, */  --11/15/2013 commented by MJ for optimization
--                   A.dcb_no, A.cashier_cd,
--                   A.or_pref_suf, A.or_no, A.or_date, a.or_flag status, --11/15/2013 Added by MJ for optimization
--                   A.payor, A.gacc_tran_id, A.gibr_branch_cd,
--                   A.gibr_gfun_fund_cd, A.or_tag, A.or_flag, A.op_tag,
--                   A.with_pdc, b.dcb_user_id, 
--                   a.user_id, a.last_update -- added by: Nica 06.15.2012
--              FROM giac_order_of_payts A,
--                   giac_dcb_users b
--             WHERE A.gibr_branch_cd = b.gibr_branch_cd
--               AND A.gibr_gfun_fund_cd = b.gibr_fund_cd
----               AND A.cashier_cd = b.cashier_cd  commented out by christian 04.30.2012
--               --AND b.dcb_user_id = DECODE(v_all_user_sw, 'Y', b.dcb_user_id, p_user_id) --11/15/2013 Commented by MJ for optimization
--               AND b.dcb_user_id LIKE DECODE(v_all_user_sw, 'Y', '%', p_user_id) --11/15/2013 Added by MJ for optimization
--               AND b.dcb_user_id = a.user_id  --added by d.alcantara, for filtering using cashier
--               AND A.op_no IS NULL
--               --AND A.OR_FLAG in ('N','R','P','C') --added by christian 04.30.2012 --11/15/2013 Modified by MJ, removed  D
--               AND A.or_flag LIKE v_or_flag --11/15/2013 added by MJ for optimization
--               AND A.gibr_gfun_fund_cd = p_fund_cd
--               AND A.gibr_branch_cd = p_branch_cd
--               AND A.or_pref_suf || '-' || A.or_no LIKE
--                                NVL (p_or_no, A.or_pref_suf || '-' || A.or_no)
--               /*AND A.payor LIKE NVL (p_payor, A.payor)
--               AND A.user_id LIKE NVL (p_cashier, A.user_id)*/ --11/15/2013 Commented by MJ for optimization
--               --11/
--               --AND A.or_pref_suf LIKE  NVL (SUBSTR(p_or_no,1,LENGTH(p_or_no)-INSTR(p_or_no,'-',1,2)-1), '%') --11/15/2013 Modified by MJ for optimization
--               --AND A.or_no LIKE NVL(SUBSTR(p_or_no,INSTR(p_or_no,'-',1,2)+1,LENGTH(p_or_no)),'%')  --11/15/2013 Modified by MJ for optimization
--               AND A.payor LIKE NVL (p_payor, '%')  --11/15/2013 Added by MJ for optimization, changed A.payor to '%'
--               AND A.user_id LIKE NVL (p_cashier, '%') --11/15/2013 Added by MJ for optimization, changed A.user_id to '%'
--               /* AND UPPER
--                      (NVL
--                          (cg_ref_codes_pkg.get_rv_meaning
--                                               ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
--                                                A.or_flag
--                                               ),
--                           'NULL'
--                          )
--                      ) LIKE
--                      NVL
--                         (UPPER (p_status)
--                          UPPER
--                             (NVL
--                                 (cg_ref_codes_pkg.get_rv_meaning
--                                               ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
--                                                A.or_flag
--                                               ),
--                                  'NULL'
--                                 )
--                             )
--                         )*/ --11/15/2013 Commented by MJ for optimization
--               --AND TRUNC (A.or_date) = NVL (v_date_search, TRUNC (A.or_date)) --11/15/2013 Commented by MJ for optimization
--               AND A.or_date BETWEEN TRUNC(NVL (v_date_search, A.or_date)) AND TRUNC(NVL (v_date_search, A.or_date)) + .99999 --11/15/2013 Added by MJ for optimization              
--               --AND op_no IS NULL                                                        -- andrew - 02.14.2012 - moved these conditions above to optimize this query : (9384 records, from 32 secs to 1 sec)
--               --AND A.gibr_gfun_fund_cd = NVL (p_fund_cd, A.gibr_gfun_fund_cd)
--               --AND A.gibr_branch_cd = NVL (p_branch_cd, A.gibr_branch_cd)
--               --AND A.dcb_no || '-' || A.cashier_cd LIKE NVL (p_dcb_no, A.dcb_no || '-' || A.cashier_cd) --11/15/2013 Commented by MJ for optimization
--               AND A.dcb_no LIKE NVL(SUBSTR(p_dcb_no,1,3), '%') --11/15/2013 Added by MJ for optimization 
--               AND A.cashier_cd LIKE NVL(SUBSTR(p_dcb_no,INSTR(p_dcb_no,'-')+1,3), '%') --11/15/2013 Added by MJ for optimization 
--               --AND UPPER(cg_ref_codes_pkg.get_rv_meaning('GIAC_ORDER_OF_PAYTS.OR_FLAG', A.or_flag)) <> DECODE(NVL(p_cancel_or,'N'), 'Y', 'CANCELLED', 'a')--used 'a' as tag to compare if filter will not be applied --11/12/2013 Commented by MJ for optimization
--               --AND b.dcb_user_id = DECODE(v_all_user_sw, 'Y', b.dcb_user_id, p_user_id) -- andrew - 02.14.2012 - moved this condition above to optimize this query: (9384 records, from 32 secs to 1 sec)
--          ORDER BY or_date DESC, dcb_no, A.payor) a)
--            WHERE rownum_ <= v_max_or_no) --mikel 11.05.2014; optimization
--      LOOP

        /* mikel 01.22.2015; optimization purposes - SR 4000
        ** comment out the code above and replaced by codes below for readability
        ** 1. this will display the records and the total number of rows in one query
        ** 2. display other branch OR when all user switch is tagged 
        */
       /* FOR or_list IN
        (
            SELECT mainsql.*
              FROM (SELECT yeah.*, ROW_NUMBER () OVER (ORDER BY 1) ROW_NUMBER,
                           COUNT (1) OVER () row_count
                      FROM (SELECT jm.*
                              FROM (SELECT ROWNUM rownum_, a.*
                                      FROM (SELECT   *//*+FIRST_ROWS(10) */
                                                   /*  a.dcb_no, a.cashier_cd,
                                                     a.or_pref_suf, a.or_no, a.or_date,
                                                     a.or_flag status, a.payor,
                                                     a.gacc_tran_id, a.gibr_branch_cd,
                                                     a.gibr_gfun_fund_cd, a.or_tag,
                                                     a.or_flag, a.op_tag, a.with_pdc,
                                                     b.dcb_user_id, a.user_id,
                                                     a.last_update
                                                FROM giac_order_of_payts a,
                                                     giac_dcb_users b
                                               WHERE a.gibr_branch_cd = b.gibr_branch_cd
                                                 AND a.gibr_gfun_fund_cd = b.gibr_fund_cd
                                                 AND b.dcb_user_id LIKE DECODE (v_all_user_sw, 'Y', '%', p_user_id)
                                                 --AND b.dcb_user_id = a.user_id removed by robert SR 21843 03.10.16
                                                 AND b.cashier_cd = a.cashier_cd -- added by robert SR 21843 03.10.16
                                                 AND a.op_no IS NULL
                                                 AND a.or_flag LIKE v_or_flag
                                                 AND a.gibr_gfun_fund_cd = p_fund_cd
                                                 AND a.gibr_branch_cd = p_branch_cd--DECODE (v_all_user_sw, 'Y', a.gibr_branch_cd, p_branch_cd) --mikel 02.13.2015; display per branch
                                                 AND EXISTS (SELECT 'X' --mikel 02.13.2015; check branch access
                                                               FROM TABLE (security_access.get_branch_line ('AC', 'GIACS001', p_user_id))
                                                              WHERE branch_cd = a.gibr_branch_cd )
                                                 AND a.or_pref_suf || '-' || a.or_no LIKE NVL (p_or_no, a.or_pref_suf || '-' || a.or_no)
                                                 AND a.payor LIKE NVL (p_payor, '%')
                                                 AND a.user_id LIKE NVL (p_cashier, '%')
                                                 AND a.or_date BETWEEN TRUNC (NVL (v_date_search, a.or_date))
                                                                AND   TRUNC (NVL (v_date_search, a.or_date)) + .99999
                                                 AND a.last_update BETWEEN TRUNC (NVL (v_date_search2, a.last_update)) -- Added by Jerome Bautista 11.03.2015 SR 20144
                                                                AND   TRUNC (NVL (v_date_search2, a.last_update)) + .99999
                                                 AND a.dcb_no LIKE NVL (SUBSTR (p_dcb_no, 1, 3), '%')
                                                 AND a.cashier_cd LIKE NVL (SUBSTR (p_dcb_no, INSTR (p_dcb_no, '-') + 1, 3), '%')
                                            ORDER BY or_date DESC, dcb_no, a.payor) a) jm) yeah) mainsql
           --  WHERE rownum_ BETWEEN p_first_row AND p_last_row  --commented out by gab 10.27.2015
           )
             --end mikel 01.22.2015
        LOOP
         --v_or_list.dcb_no                  := or_list.dcb_no; 
         v_or_list.dcb_no                  := or_list.dcb_no || '-' || or_list.cashier_cd; --11/15/2013 Added by MJ for optimization
         --v_or_list.or_no                   := or_list.or_no;
         v_or_list.or_no                   := or_list.or_pref_suf || '-' || or_list.or_no; --11/15/2013 Added by MJ for optimization
         v_or_list.or_date                 := or_list.or_date;
         --v_or_list.status                  := or_list.status;
         v_or_list.status                  := cg_ref_codes_pkg.get_rv_meaning
                                               ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                                or_list.status
                                               ); --11/15/2013 Added by MJ for optimization
         v_or_list.payor                   := or_list.payor;
         v_or_list.dcb_bank_acct           := NULL;
         v_or_list.item_no                 := NULL;
         v_or_list.gacc_tran_id            := or_list.gacc_tran_id;
         v_or_list.gibr_branch_cd          := or_list.gibr_branch_cd;
         v_or_list.gibr_gfun_fund_cd       := or_list.gibr_gfun_fund_cd;
         v_or_list.or_tag                  := or_list.or_tag;
         v_or_list.or_flag                 := or_list.or_flag;
         v_or_list.op_tag                  := or_list.op_tag;
         v_or_list.with_pdc                := or_list.with_pdc;
         v_or_list.dcb_user_id             := or_list.dcb_user_id;
         v_or_list.user_id                 := or_list.user_id;
         v_or_list.last_update             := or_list.last_update;
         v_or_list.count_                  := or_list.row_count; --mikel 01.22.2015

         IF or_list.or_tag = '*'
         THEN
            v_or_list.or_tag_lbl := '*';
         ELSE
            v_or_list.or_tag_lbl := '';
         END IF;
         
         

         PIPE ROW (v_or_list);
      END LOOP;*/--comment out by pjsantos 09/26/2016, replaced by codes below for optimization, GENQA 5687
      
      v_sql := v_sql || 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM ((SELECT         
                                                     a.dcb_no || ''-'' ||  a.cashier_cd dcb_no,
                                                     a.or_pref_suf || ''-'' || a.or_no or_no, a.or_date,
                                                     DECODE(a.or_flag,''C'', ''Cancelled'', ''D'', ''Deleted'', ''P'', ''Printed'', ''R'', ''Replaced'') status, 
                                                     a.payor,
                                                     a.gacc_tran_id, a.gibr_branch_cd,
                                                     a.gibr_gfun_fund_cd, a.or_tag, 
                                                     a.or_flag, a.op_tag, a.with_pdc,
                                                     b.dcb_user_id, a.user_id,
                                                     a.last_update,
                                                     DECODE(a.or_tag, ''*'',''*'','''') or_tag_lbl,
                                                     NULL dcb_bank_acct,
                                                     NULL item_no
                                                FROM giac_order_of_payts a,
                                                     giac_dcb_users b
                                               WHERE a.gibr_branch_cd = b.gibr_branch_cd
                                                 AND a.gibr_gfun_fund_cd = b.gibr_fund_cd
                                                 AND b.dcb_user_id LIKE DECODE (:v_all_user_sw, ''Y'', ''%'', :p_user_id)
                                                 AND b.cashier_cd = a.cashier_cd 
                                                 AND a.op_no IS NULL
                                                 AND a.or_flag LIKE :v_or_flag
                                                 AND a.gibr_gfun_fund_cd = :p_fund_cd
                                                 AND a.gibr_branch_cd = :p_branch_cd
                                                 AND EXISTS (SELECT ''X''
                                                               FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS001'', :p_user_id))
                                                              WHERE branch_cd = :p_branch_cd)
                                                 AND a.or_pref_suf || ''-'' || a.or_no LIKE NVL (:p_or_no, a.or_pref_suf || ''-'' || a.or_no)
                                                 AND a.payor LIKE NVL (:p_payor, ''%'')
                                                 AND b.dcb_user_id LIKE NVL (:p_cashier, ''%'')
                                                 AND a.or_date BETWEEN TRUNC (NVL (:v_date_search, a.or_date))
                                                                AND   TRUNC (NVL (:v_date_search, a.or_date)) + .99999
                                                 AND a.last_update BETWEEN TRUNC (NVL (:v_date_search2, a.last_update))
                                                                AND   TRUNC (NVL (:v_date_search2, a.last_update)) + .99999
                                                 AND a.dcb_no LIKE NVL (SUBSTR (:p_dcb_no, 1, 3), ''%'')
                                                 AND a.cashier_cd LIKE NVL (SUBSTR (:p_dcb_no, INSTR (:p_dcb_no, ''-'') + 1, 3), ''%'')';
   
    IF    p_or_tag = 'G' 
      THEN
        v_sql := v_sql || ' AND or_tag IS NULL'; --modified by pjsantos 10/05/2016, GENQA 5732, changed from or_tag_lbl to or_tag
    ELSIF p_or_tag = 'M'                             
      THEN
        v_sql := v_sql || ' AND or_tag = ''*'''; --modified by pjsantos 10/05/2016, GENQA 5732, changed from or_tag_lbl to or_tag
    END IF;                      
                                  

     IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'dcbNo'
         THEN        
          v_sql := v_sql || ' ORDER BY TO_NUMBER(REPLACE(dcb_no, ''-'', '''')) ';
        ELSIF  p_order_by = 'orNo'
         THEN         
          v_sql := v_sql || ' ORDER BY or_no ';
        ELSIF  p_order_by = 'payor' 
         THEN
          v_sql := v_sql || ' ORDER BY payor ';
        ELSIF  p_order_by = 'dcbBankAcct'
         THEN
          v_sql := v_sql || ' ORDER BY dcb_bank_acct '; 
        ELSIF  p_order_by = 'orStatus'
         THEN
          v_sql := v_sql || ' ORDER BY status ';       
        ELSIF  p_order_by = 'orDate'
         THEN
          v_sql := v_sql || ' ORDER BY or_date ';    
        ELSIF  p_order_by = 'dcbUserId'
         THEN
          v_sql := v_sql || ' ORDER BY dcb_user_id ';  
        ELSIF  p_order_by = 'userId'
         THEN
          v_sql := v_sql || ' ORDER BY user_id ';   
        ELSIF  p_order_by = 'lastUpdate'
         THEN
          v_sql := v_sql || ' ORDER BY last_update ';  
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
        
        v_sql := v_sql || ', or_date DESC, dcb_no, a.payor';
     ELSE
        v_sql := v_sql || ' ORDER BY  or_date DESC, dcb_no, a.payor';
    END IF;    
    
    v_sql := v_sql || ')) innersql) outersql) mainsql WHERE rownum_ BETWEEN :p_first_row AND :p_last_row';  

    OPEN c FOR v_sql USING  v_all_user_sw, p_user_id, v_or_flag, p_fund_cd,
                            p_branch_cd, p_user_id, p_branch_cd, p_or_no, p_payor, p_cashier, v_date_search,
                            v_date_search, v_date_search2, v_date_search2, p_dcb_no, 
                            p_dcb_no, p_dcb_no, p_first_row, p_last_row;

      LOOP
      FETCH c INTO 
        v_or_list.count_,
        v_or_list.rownum_,
        v_or_list.dcb_no,
        v_or_list.or_no,
        v_or_list.or_date,
        v_or_list.status,
        v_or_list.payor,
        v_or_list.gacc_tran_id,
        v_or_list.gibr_branch_cd,
        v_or_list.gibr_gfun_fund_cd,
        v_or_list.or_tag,
        v_or_list.or_flag,
        v_or_list.op_tag, 
        v_or_list.with_pdc,
        v_or_list.dcb_user_id,
        v_or_list.user_id,
        v_or_list.last_update,
        v_or_list.or_tag_lbl,
        v_or_list.dcb_bank_acct,
        v_or_list.item_no;
         EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_or_list);
      END LOOP;      
      CLOSE c;   
      RETURN;  
   END get_or_list2;
   
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.15.2012
    **  Reference By  : OR Listing
    **  Description   : Gets the list of OR for Accounting which includes
    **                    user_id and last_update columns 
    */ 
    
    FUNCTION get_or_list3 (
          p_fund_cd       GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
          p_branch_cd     GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
          p_dcb_no        VARCHAR2,
          p_or_no         VARCHAR2,
          p_payor         GIAC_ORDER_OF_PAYTS.payor%TYPE,
          p_status        VARCHAR2,
          p_or_date       VARCHAR2,
          p_cashier       GIAC_DCB_USERS.dcb_user_id%TYPE,
          p_last_user     GIAC_ORDER_OF_PAYTS.user_id%TYPE,
          p_app_user_id   GIIS_USERS.user_id%TYPE,
          p_cancel_or     VARCHAR2
       )
          RETURN or_list_tab PIPELINED
       IS
          v_or_list       or_list_type;
          v_date_search   DATE;
          v_all_user_sw   GIIS_USERS.all_user_sw%TYPE;
           
       BEGIN
      
          -- check first if search key is in date format. if yes, store it to v_date_search
          BEGIN
             v_date_search := TO_DATE (p_or_date, 'MM-DD-RRRR');
          EXCEPTION
             WHEN OTHERS
             THEN
                v_date_search := NULL;
          END;
    
          IF v_date_search IS NULL
          THEN
             BEGIN
                v_date_search := TO_DATE (p_or_date, 'RRRR-MM-DD');
             EXCEPTION
                WHEN OTHERS
                THEN
                   v_date_search := NULL;
             END;
          END IF;
          
          FOR i IN (SELECT all_user_sw
                      FROM GIIS_USERS
                     WHERE user_id = p_app_user_id)
          LOOP
                v_all_user_sw := i.all_user_sw;
          END LOOP;
          --   --/* removed Upper
          FOR or_list IN
             (SELECT   A.dcb_no || '-' || A.cashier_cd dcb_no,
                       A.or_pref_suf || '-' || A.or_no or_no, A.or_date,
                       CG_REF_CODES_PKG.GET_RV_MEANING
                                           ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                            A.or_flag
                                           ) status,
                       A.payor, A.gacc_tran_id, A.gibr_branch_cd,
                       A.gibr_gfun_fund_cd, A.or_tag, A.or_flag, A.op_tag,
                       A.with_pdc, b.dcb_user_id, a.user_id, a.last_update 
                  FROM GIAC_ORDER_OF_PAYTS A,
                       GIAC_DCB_USERS b
                 WHERE A.gibr_branch_cd = b.gibr_branch_cd
                   AND A.gibr_gfun_fund_cd = b.gibr_fund_cd
                   AND A.cashier_cd = b.cashier_cd
                   AND b.dcb_user_id = DECODE(v_all_user_sw, 'Y', b.dcb_user_id, p_app_user_id)
                   AND op_no IS NULL
                   AND or_flag IN ('N', 'C','R','P','D')
                    AND A.gibr_gfun_fund_cd = p_fund_cd  --/*
                   AND A.gibr_branch_cd = p_branch_cd  --/*
                   AND (A.or_pref_suf || '-' || A.or_no) LIKE
                                    (NVL (p_or_no, A.or_pref_suf || '-' || A.or_no))  --/*
                   AND (A.payor) LIKE (NVL (p_payor, A.payor))  --/*
                   AND UPPER(b.dcb_user_id) LIKE UPPER(NVL (p_cashier, b.dcb_user_id))
                   AND UPPER(A.user_id) LIKE UPPER(NVL (p_last_user, A.user_id))  --/*
                   AND UPPER
                          (NVL
                              (CG_REF_CODES_PKG.GET_RV_MEANING
                                                   ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                                    A.or_flag
                                                   ),
                               'NULL'
                              )
                          ) LIKE
                          NVL
                             (UPPER (p_status),
                              UPPER
                                 (NVL
                                     (CG_REF_CODES_PKG.GET_RV_MEANING
                                                   ('GIAC_ORDER_OF_PAYTS.OR_FLAG',
                                                    A.or_flag
                                                   ),
                                      'NULL'
                                     )
                                 )
                             )
                   AND TRUNC (A.or_date) = NVL (v_date_search, TRUNC (A.or_date))               
                   AND UPPER(A.dcb_no || '-' || A.cashier_cd) LIKE
                                   UPPER(NVL (p_dcb_no, A.dcb_no || '-' || A.cashier_cd))
                   AND UPPER(CG_REF_CODES_PKG.GET_RV_MEANING('GIAC_ORDER_OF_PAYTS.OR_FLAG', A.or_flag)) <> DECODE(NVL(p_cancel_or,'N'), 'Y', 'CANCELLED', 'a')
                ORDER BY or_date DESC, dcb_no, A.payor)
          
          LOOP
             v_or_list.dcb_no                  := or_list.dcb_no;
             v_or_list.or_no                   := or_list.or_no;
             v_or_list.or_date                 := or_list.or_date;
             v_or_list.status                  := or_list.status;
             v_or_list.payor                   := or_list.payor;
             v_or_list.dcb_bank_acct           := NULL;
             v_or_list.item_no                 := NULL;
             v_or_list.gacc_tran_id            := or_list.gacc_tran_id;
             v_or_list.gibr_branch_cd          := or_list.gibr_branch_cd;
             v_or_list.gibr_gfun_fund_cd       := or_list.gibr_gfun_fund_cd;
             v_or_list.or_tag                  := or_list.or_tag;
             v_or_list.or_flag                 := or_list.or_flag;
             v_or_list.op_tag                  := or_list.op_tag;
             v_or_list.with_pdc                := or_list.with_pdc;
             v_or_list.dcb_user_id             := or_list.dcb_user_id;
             v_or_list.user_id                 := or_list.user_id;
             v_or_list.last_update             := or_list.last_update;
    
             IF or_list.or_tag = '*'
             THEN
                v_or_list.or_tag_lbl := '*';
             ELSE
                v_or_list.or_tag_lbl := '';
             END IF;
    
             PIPE ROW (v_or_list);
          END LOOP;
   END get_or_list3;

   FUNCTION get_giac_or_dtl (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN giac_or_dtl_tab PIPELINED
   IS
      v_giac_or_dtl   giac_or_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_giac_or_dtl.gacc_tran_id := i.gacc_tran_id;
         v_giac_or_dtl.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_giac_or_dtl.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_or_dtl.op_no := i.op_no;
         v_giac_or_dtl.op_date := i.op_date;
         v_giac_or_dtl.op_flag := i.op_flag;
         v_giac_or_dtl.or_no := i.or_no;
         v_giac_or_dtl.or_date := i.or_date;
         v_giac_or_dtl.or_tag := i.or_tag;
         v_giac_or_dtl.or_flag := i.or_flag;
         v_giac_or_dtl.dcb_no := i.dcb_no;
         v_giac_or_dtl.payor := i.payor;
         v_giac_or_dtl.collection_amt := i.collection_amt;
         v_giac_or_dtl.gross_amt := i.gross_amt;
         v_giac_or_dtl.cashier_cd := i.cashier_cd;
         v_giac_or_dtl.currency_cd := i.currency_cd;
         v_giac_or_dtl.or_pref_suf := i.or_pref_suf;
         v_giac_or_dtl.gross_tag := i.gross_tag;
         v_giac_or_dtl.address_1 := i.address_1;
         v_giac_or_dtl.address_2 := i.address_2;
         v_giac_or_dtl.address_3 := i.address_3;
         v_giac_or_dtl.particulars := i.particulars;
         v_giac_or_dtl.remit_date := i.remit_date;
         v_giac_or_dtl.prov_receipt_no := i.prov_receipt_no;
         v_giac_or_dtl.intm_no := i.intm_no;
         v_giac_or_dtl.upload_tag := i.upload_tag;
         v_giac_or_dtl.cancel_date := i.cancel_date;
         v_giac_or_dtl.cancel_dcb_no := i.cancel_dcb_no;
         v_giac_or_dtl.or_cancel_tag := i.or_cancel_tag;
         v_giac_or_dtl.with_pdc := i.with_pdc;
         v_giac_or_dtl.tin := i.tin;
         v_giac_or_dtl.ri_comm_tag := i.ri_comm_tag; -- added by: Nica 06.14.2013 AC-SPECS-2012-155
         PIPE ROW (v_giac_or_dtl);
      END LOOP;

      RETURN;
   END get_giac_or_dtl;

   PROCEDURE check_or_flag (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
   IS
      v_check_flag   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT or_flag
           INTO v_check_flag
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20000, 'NO DATA IN GIAC_ORDER_PAYTS');
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error (-20000,
                                     'TOO MANY ROWS IN GIAC_ORDER_PAYTS'
                                    );
         WHEN OTHERS
         THEN
            raise_application_error
                          (-20000,
                           'UNHANDLED ERROR IN WHEN NEW FOR INSTANCE TRIGGER'
                          );
      END;
   END check_or_flag;

   -- edited bt d.alcantara, 05112012, for ac-specs-2012-011
   PROCEDURE update_giac_order_of_payts (
        p_gacc_tran_id            giac_acctrans.tran_id%TYPE,
        p_prem_seq_no             giac_aging_soa_details.prem_seq_no%TYPE,
        p_iss_cd                  giac_aging_soa_details.iss_cd%TYPE,
        p_transaction_type          giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no                  giac_direct_prem_collns.inst_no%TYPE,
        p_premium_amt              giac_direct_prem_collns.premium_amt%TYPE,
        p_tax_amt                  giac_direct_prem_collns.tax_amt%TYPE,
        p_tran_source             VARCHAR2,
        p_module_name             giac_modules.module_name%TYPE,
        p_msg_alert      OUT      VARCHAR2,
        p_workflow_msg   OUT      VARCHAR2,
        --p_user_id                 VARCHAR2, alfie 04/26/2011
        p_or_part_sw     IN OUT   VARCHAR2
    )
    IS
        v_premium_amt NUMBER := 0; --added by alfie 01/25/2012
        v_prem_due NUMBER := 0;
        v_tax_amt NUMBER := 0;
        v_tax_due NUMBER := 0;
        
        v_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE;
        v_max_bills         NUMBER                                         := 5;
        -- max number of policies to be printed
        v_totbill           NUMBER (5);
        v_totpol            NUMBER (5);
        v_or_no             giac_order_of_payts.or_no%TYPE;
        v_or_flag           giac_order_of_payts.or_flag%TYPE;
        v_or_tag            giac_order_of_payts.or_tag%TYPE;
        v_or_intm_no        giac_order_of_payts.intm_no%TYPE;
        v_or_particulars    giac_order_of_payts.particulars%TYPE;
        v_particulars       giac_order_of_payts.particulars%TYPE;
        v_intm_no           giac_order_of_payts.intm_no%TYPE;
        v_max_colln_intm    giis_intermediary.intm_no%TYPE;
        v_iss_cd            giac_direct_prem_collns.b140_iss_cd%TYPE;
        v_prem_seq_no       giac_direct_prem_collns.b140_prem_seq_no%TYPE;
        v_max_colln_amt     giac_direct_prem_collns.collection_amt%TYPE;
        v_bills             NUMBER                                         := 0;
        v_policy_no         VARCHAR2 (30);
        
        v_tax_diff          NUMBER(19,9) := 0;
        v_tax_adjustment    giac_direct_prem_collns.tax_amt%TYPE        := 0;
        v_tax_adjusted      NUMBER(1) := 0;    
        v_new_local_amt     GIAC_OP_TEXT.item_amt%TYPE                  := 0;    
        
        v_new_prem_amt        giac_direct_prem_collns.premium_amt%TYPE    := 0;
        v_new_tax_amt        giac_direct_prem_collns.tax_amt%TYPE        := 0;
        
    BEGIN
        v_new_prem_amt  := p_premium_amt;
        v_new_tax_amt   := p_tax_amt;
        
        IF p_prem_seq_no IS NOT NULL AND p_transaction_type IN (1,3) THEN
            SELECT SUM(premium_amt), SUM(tax_amt)
              INTO v_premium_amt, v_tax_amt
              FROM giac_direct_prem_collns a, giac_acctrans b
             WHERE a.gacc_tran_id != p_gacc_tran_id
               AND NOT EXISTS(SELECT 'X'
                          FROM giac_reversals c,
                               giac_acctrans  d
                         WHERE c.reversing_tran_id = d.tran_id
                           AND d.tran_flag != 'D'
                           AND c.gacc_tran_id = a.gacc_tran_id)
               AND a.gacc_tran_id = b.tran_id
               AND b.tran_flag   != 'D'
               AND b140_prem_seq_no = p_prem_seq_no
               AND b140_iss_cd = p_iss_cd
               AND inst_no = p_inst_no;
          
            IF v_premium_amt IS NULL THEN
                v_premium_amt := 0;
            END IF;
            
            IF v_tax_amt IS NULL THEN
                v_tax_amt := 0;
            END IF;
             
            SELECT ROUND(a.prem_amt * b.currency_rt,2), ROUND(a.tax_amt * b.currency_rt,2)
              INTO v_prem_due, v_tax_due
              FROM gipi_installment a, gipi_invoice b
             WHERE a.iss_cd = p_iss_cd
               AND a.prem_seq_no = p_prem_seq_no
               AND inst_no = p_inst_no
               AND b.iss_cd = a.iss_cd
               AND b.prem_seq_no = a.prem_seq_no;
            -- mga pinadagdag ni boss jm, 08-14-2012, minsan daw kasi nagkakaroon din daw ng discrepancy dahil sa conversion ng foreign currency dito   
            v_tax_diff := (ABS(v_tax_due) - ABS(v_tax_amt)) - ABS(p_tax_amt);   
               
            IF ABS((ABS(v_prem_due) - ABS(v_premium_amt)) - ABS(p_premium_amt)) = 0.01 AND ABS(v_tax_diff) = 0.01 THEN
                -- adjust yung prem tax dito
                
                FOR i IN (
                    SELECT * FROM giac_tax_collns a
                     WHERE a.gacc_tran_id = p_gacc_tran_id
                       AND a.transaction_type = p_transaction_type
                       AND a.b160_iss_cd = p_iss_cd
                       AND a.b160_prem_seq_no = p_prem_seq_no
                       AND a.b160_tax_cd = (
                           SELECT b.tax_cd
                             FROM gipi_inv_tax b,
                                  giis_tax_charges c,
                                  gipi_invoice d,
                                  gipi_polbasic e
                            WHERE b.iss_cd = p_iss_cd
                              AND b.prem_seq_no = p_prem_seq_no
                               AND b.tax_cd = c.tax_cd
                               AND b.line_cd = c.line_cd
                               AND b.iss_cd = c.iss_cd
                               AND d.prem_seq_no = b.prem_seq_no
                               AND c.iss_cd = d.iss_cd  --added condition by robert 05.08.2013 sr 12987
                               AND d.policy_id = e.policy_id
                               AND e.eff_date BETWEEN c.eff_start_date AND c.eff_end_date
                               AND c.tax_cd = GIACP.n('LGT'))
                ) LOOP
                    /*IF SIGN(v_tax_diff) = -1 THEN
                        v_tax_adjustment := ROUND(-0.01*v_currency_rt, 2);
                    ELSIF SIGN(v_tax_diff) = 1 THEN
                        v_tax_adjustment := ROUND(0.01*v_currency_rt, 2);
                    v_new_local_amt := ROUND((i.tax_amt+v_tax_adjustment), 2);*/
                    v_new_local_amt := i.tax_amt + v_tax_diff;
                    
                    UPDATE giac_tax_collns 
                       SET TAX_AMT = v_new_local_amt,
                           LAST_UPDATE = SYSDATE
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND b160_iss_cd = i.b160_iss_cd
                       AND b160_prem_seq_no = i.b160_prem_seq_no
                       AND b160_tax_cd = i.b160_tax_cd
                       AND inst_no = i.inst_no;
                   
                    
                    v_tax_adjusted := 1;
                    
                    EXIT;
                END LOOP;
                
                IF v_tax_adjusted = 1 THEN
                    v_new_tax_amt   := ROUND(p_tax_amt-v_tax_diff, 2);
                    v_new_prem_amt  := ROUND(p_premium_amt+v_tax_diff, 2);
                    
                    UPDATE giac_direct_prem_collns
                       SET premium_amt  = v_new_prem_amt,
                           tax_amt      = v_new_tax_amt
                     WHERE b140_prem_seq_no = p_prem_seq_no
                       AND b140_iss_cd = p_iss_cd
                       AND inst_no = p_inst_no
                       AND gacc_tran_id = p_gacc_tran_id;
                    
                    v_tax_adjusted := 1;
                END IF;
                
                /*IF v_tax_adjusted <> 1 THEN
                    raise_application_error
                            (-20006,
                             'Geniisys Exception#I#There is an overpayment in '||p_iss_cd||'-'||p_prem_seq_no||'-'||p_inst_no||
                             ' due to conversion of currency. Please if the taxes and amounts are correct.'
                            );
                END IF;*/  --comment lang daw muna tong message
            END IF;
             -- end ng mga pinadagdag ni boss jm
            --            IF (SIGN((ABS(v_prem_due) - ABS(v_premium_amt)) - ABS(v_new_prem_amt)) = -1 
--                     OR SIGN((ABS(v_tax_due) - ABS(v_tax_amt)) - ABS(v_new_tax_amt)) = -1) 
--                     AND v_tax_adjusted <> 1 THEN
--                /*p_msg_alert :=       'Collection for invoice '||:gdpc.b140_iss_cd||'-'||:gdpc.b140_prem_seq_no||'-'||:gdpc.inst_no||
--                      ' cannot be processed. There is an overpayment on premium/tax found.';*/
--                raise_application_error
--                            (-20006,
--                             'Geniisys Exception#I#Collection for invoice '||p_iss_cd||'-'||p_prem_seq_no||'-'||p_inst_no||
--                             ' cannot be processed. There is an overpayment on premium/tax found.'
--                            );
--            END IF;
        END IF;

      /** to create workflow records of Premium Payments */
      FOR c1 IN (SELECT SUM (balance_amt_due) balance_amt_due
                   FROM giac_aging_soa_details
                  WHERE prem_seq_no = p_prem_seq_no AND iss_cd = p_iss_cd)
      LOOP
         v_balance_amt_due := c1.balance_amt_due;
      END LOOP;

      IF v_balance_amt_due = 0
      THEN
         FOR c1 IN (SELECT claim_id
                      FROM gicl_claims c, gipi_polbasic b, gipi_invoice A
                     WHERE 1 = 1
                       AND c.line_cd = b.line_cd
                       AND c.subline_cd = b.subline_cd
                       AND c.pol_iss_cd = b.iss_cd
                       AND c.issue_yy = b.issue_yy
                       AND c.pol_seq_no = b.pol_seq_no
                       AND c.renew_no = b.renew_no
                       AND b.policy_id = A.policy_id
                       AND A.prem_seq_no = p_prem_seq_no
                       AND A.iss_cd = p_iss_cd)
         LOOP
            FOR c2 IN (SELECT b.userid, d.event_desc
                         FROM giis_events_column c,
                              giis_event_mod_users b,
                              giis_event_modules A,
                              giis_events d
                        WHERE 1 = 1
                          AND c.event_cd = A.event_cd
                          AND c.event_mod_cd = A.event_mod_cd
                          AND b.event_mod_cd = A.event_mod_cd
                          AND b.passing_userid = NVL(giis_users_pkg.app_user,USER)
                          AND A.module_id = 'GIACS007'
                          AND A.event_cd = d.event_cd
                          AND UPPER (d.event_desc) = 'PREMIUM PAYMENTS')
            LOOP
               create_transfer_workflow_rec ('PREMIUM PAYMENTS',
                                             p_module_name,
                                             c2.userid,
                                             c1.claim_id,
                                                c2.event_desc
                                             || ' '
                                             || get_clm_no (c1.claim_id),
                                             p_msg_alert,
                                             p_workflow_msg,
                                             giis_users_pkg.app_user
                                             --p_user_id alfie 04/26/2011
                                            );
            END LOOP;
         END LOOP;
      END IF;

      BEGIN
         SELECT COUNT (*)
           INTO v_bills
           FROM giac_direct_prem_collns
          WHERE gacc_tran_id = p_gacc_tran_id;
      END;

      FOR giop IN (SELECT or_no, or_flag, or_tag, intm_no, particulars
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_or_no := giop.or_no;
         v_or_flag := giop.or_flag;
         v_or_tag := giop.or_tag;
         v_or_intm_no := giop.intm_no;
         v_or_particulars := giop.particulars;
      END LOOP;

      FOR bill IN (SELECT b140_iss_cd, b140_prem_seq_no
                     FROM giac_direct_prem_collns
                    WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         IF     (v_or_no IS NULL AND v_or_flag = 'N')
            AND (v_or_particulars IS NULL)
         THEN
            IF v_bills > 0
            THEN
               FOR bill_row IN 1 .. v_bills
               LOOP
                  v_policy_no := NULL;

                  FOR pol IN (SELECT b250.line_cd, b250.subline_cd,
                                     b250.iss_cd, b250.issue_yy,
                                     b250.pol_seq_no, b250.renew_no
                                FROM gipi_polbasic b250, gipi_invoice b140
                               WHERE b140.policy_id = b250.policy_id
                                 AND b140.iss_cd = bill.b140_iss_cd
                                 AND b140.prem_seq_no = bill.b140_prem_seq_no)
                  LOOP
                     v_policy_no :=
                           pol.line_cd
                        || '-'
                        || pol.subline_cd
                        || '-'
                        || pol.iss_cd
                        || '-'
                        || TO_CHAR (pol.issue_yy)
                        || '-'
                        || TO_CHAR (pol.pol_seq_no)
                        || '-'
                        || TO_CHAR (pol.renew_no);
                  END LOOP;                                      -- end of pol

                  IF (v_policy_no IS NOT NULL)
                  THEN
                     IF v_totpol = 1
                     THEN
                        v_particulars := v_policy_no;
                     ELSE
                        v_particulars :=
                                        v_particulars || ' / ' || v_policy_no;
                     END IF;
                  END IF;                    -- end of v_policy_no is not null
               END LOOP;                                    -- end of bill_row

               IF v_totpol > v_max_bills
               THEN
                  v_particulars := 'VARIOUS POLICIES';
               END IF;

               /* update particulars in giac_order_of_payts with the generated particulars */
               IF (p_or_part_sw <> 'X')
               THEN
                  -- update particulars in giac_order_of_payts if collections exists
                  IF v_bills > 0
                  THEN
                     UPDATE giac_order_of_payts
                        SET particulars = v_particulars
                      WHERE gacc_tran_id = p_gacc_tran_id;
                  ELSE    -- set particulars to NULL when no collection exists
                     UPDATE giac_order_of_payts
                        SET particulars = NULL
                      WHERE gacc_tran_id = p_gacc_tran_id;
                  END IF;

                  -- Use 'O' if or particulars is from giacs007 and 'X' if from giacs001
                  p_or_part_sw := 'O';
               END IF;                      -- end of global.or_particulars_sw
            END IF;                                      -- end of v_bills > 0
         END IF;               -- end of (v_or_no IS NULL AND v_or_flag = 'N')

         IF (v_or_no IS NULL AND v_or_flag = 'N') AND (v_or_intm_no IS NULL)
         THEN
            /*
            /* generate particulars if there are bills. */
            /* Determine the bill no with the greatest collection amt, then, get the intermediary in
            ** gipi_comm_invoice and update the intm_no in giac_order_of_payts with queried intm_no */
            IF v_bills > 0
            THEN
               BEGIN
                  SELECT i.intrmdry_intm_no
                    INTO v_intm_no
                    FROM (SELECT intrmdry_intm_no
                            FROM gipi_comm_invoice
                           WHERE iss_cd = bill.b140_iss_cd
                             AND prem_seq_no = bill.b140_prem_seq_no
                          UNION
                          -- get the intm_no of the endt's mother policy, for endt of tax
                          SELECT c.intrmdry_intm_no
                            FROM gipi_polbasic A,
                                 gipi_polbasic b,
                                 gipi_comm_invoice c
                           WHERE b.policy_id = c.policy_id
                             AND A.line_cd = b.line_cd
                             AND A.subline_cd = b.subline_cd
                             AND A.iss_cd = b.iss_cd
                             AND A.issue_yy = b.issue_yy
                             AND A.pol_seq_no = b.pol_seq_no
                             AND A.renew_no = b.renew_no
                             AND A.endt_seq_no <> 0
                             AND b.endt_seq_no = 0
                             AND A.policy_id IN (
                                    SELECT policy_id
                                      FROM gipi_invoice
                                     WHERE iss_cd = bill.b140_iss_cd
                                       AND prem_seq_no = bill.b140_prem_seq_no)) i;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     raise_application_error
                            (-20006,
                             'Geniisys Exception#I#Error retrieving intm_no in gipi_comm_invoice.'
                            );
                  WHEN TOO_MANY_ROWS
                  THEN
                     NULL;
               END;

               IF v_bills > 0
               THEN
                  UPDATE giac_order_of_payts
                     SET intm_no = v_intm_no
                   WHERE gacc_tran_id = p_gacc_tran_id;
               ELSE
                  UPDATE giac_order_of_payts
                     SET intm_no = NULL
                   WHERE gacc_tran_id = p_gacc_tran_id;
               END IF;                                  -- end of v_or_intm_no
            END IF;                                --  end of v_bills > 0 THEN
         END IF;               -- end of (v_or_no IS NULL AND v_or_flag = 'N')
      END LOOP;
    END update_giac_order_of_payts;

   FUNCTION get_giac_or_rep (                     --Added by Alfred 03/04/2011
      p_or_pref   VARCHAR2,
      p_or_no     VARCHAR2,
      p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_or_tab PIPELINED
   IS
      v_giac_or   giac_or_type;
   BEGIN
      FOR i IN
         (SELECT gop.gacc_tran_id, gop.gibr_gfun_fund_cd, gop.gibr_branch_cd,
                 gop.payor, TO_CHAR (gop.or_date, 'MM-DD-RRRR') or_date,
                 DECODE (gop.gross_tag,
                         'Y', gop.gross_amt,
                         gop.collection_amt
                        ) op_collection_amt,
                 NVL (gop.currency_cd, 1) currency_cd, gop.gross_tag,
                 gop.intm_no, gop.prov_receipt_no,
                 DECODE (gop.or_no,
                         NULL, p_or_pref
                          || '-'
                          || LTRIM (TO_CHAR (p_or_no, '0999999999')),
                            gop.or_pref_suf
                         || '-'
                         || LTRIM (TO_CHAR (gop.or_no, '0999999999'))
                        ) or_no,
                 gop.cashier_cd, gop.particulars, gop.dcb_no,
                    gop.address_1
                 || ' '
                 || gop.address_2
                 || ' '
                 || gop.address_3 address,
                 gop.with_pdc, SYSDATE, gop.tin, gc.short_name,
                 (   A.line_cd
                  || '-'
                  || A.subline_cd
                  || '-'
                  || A.iss_cd
                  || '-'
                  || A.clm_yy
                  || '-'
                  || A.clm_seq_no
                 ) claim_no,
                 A.assured_name,
                    TO_CHAR (A.dsp_loss_date, 'DD/MM/RRRR')
                 || ' (d/m/y)' loss_date,
                 (   c.line_cd
                  || '-'
                  || c.iss_cd
                  || '-'
                  || c.rec_year
                  || '-'
                  || c.rec_seq_no
                 ) recovery_no,
                 or_flag, gop.or_pref_suf,
                 /*(SELECT DISTINCT NVL(d.or_print_tag,'Y')
                    FROM giac_op_text d
                   WHERE d.gacc_tran_id = p_tran_id) or_print_tag,*/ -- bonok :: 10.04.2012
                   (NVL (cf_tot_collns (p_tran_id), 0))
                 - (  (  NVL (cf_giot_prem (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_lgt (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_fst (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_evat (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_prem_tax (p_tran_id,
                                                v_giac_or.currency_cd
                                               ),
                              0
                             )
                       + NVL (cf_giot_doc (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                      )
                    - (  NVL (cf_giot_ri_comm (p_tran_id,
                                               v_giac_or.currency_cd
                                              ),
                              0
                             )
                       + NVL (cf_giot_vat_comm (p_tran_id,
                                                v_giac_or.currency_cd
                                               ),
                              0
                             )
                      )
                   )
                 + (NVL (cf_giot_fst (p_tran_id, v_giac_or.currency_cd), 0))
                                                              cf_giot_others
            FROM giac_order_of_payts gop,
                 giis_currency gc,
                 gicl_claims A,
                 giac_loss_recoveries b,
                 gicl_clm_recovery c
           WHERE gop.currency_cd = gc.main_currency_cd
             AND A.claim_id(+) = b.claim_id
             AND gop.gacc_tran_id = b.gacc_tran_id(+)
             AND b.recovery_id = c.recovery_id(+)
             AND gop.gacc_tran_id = NVL (p_tran_id, gop.gacc_tran_id))
      LOOP
         v_giac_or.gacc_tran_id := i.gacc_tran_id;
         v_giac_or.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_giac_or.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_or.payor := i.payor;
         v_giac_or.or_date := TO_DATE (i.or_date, 'MM-DD-YYYY');
         v_giac_or.op_collection_amt := i.op_collection_amt;
         v_giac_or.currency_cd := i.currency_cd;
         v_giac_or.gross_tag := i.gross_tag;
         v_giac_or.intm_no := i.intm_no;
         v_giac_or.prov_receipt_no := i.prov_receipt_no;
         v_giac_or.or_no := i.or_no;
         v_giac_or.cashier_cd := i.cashier_cd;
         v_giac_or.particulars := i.particulars;
         v_giac_or.dcb_no := i.dcb_no;
         v_giac_or.address := i.address;
         v_giac_or.with_pdc := i.with_pdc;
         v_giac_or.tin := i.tin;
         v_giac_or.short_name := i.short_name;
         v_giac_or.claim_no := i.claim_no;
         v_giac_or.assured_name := i.assured_name;
         v_giac_or.loss_date := i.loss_date;
         v_giac_or.recovery_no := i.recovery_no;
         v_giac_or.or_flag := i.or_flag;
         v_giac_or.or_pref_suf := i.or_pref_suf;
         --v_giac_or.or_print_tag := i.or_print_tag;
         v_giac_or.cf_giot_others := i.cf_giot_others;
         v_giac_or.cf_giot_prem :=
                              cf_giot_prem (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_doc :=
                               cf_giot_doc (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_lgt :=
                               cf_giot_lgt (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_ri_comm :=
                           cf_giot_ri_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_vat_comm :=
                          cf_giot_vat_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_prem_tax :=
                          cf_giot_prem_tax (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_evat :=
                              cf_giot_evat (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_tot_collns := cf_tot_collns (p_tran_id);
         v_giac_or.cf_giot_fst :=
                               cf_giot_fst (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_or_type :=
            cf_or_type (v_giac_or.or_pref_suf,
                        v_giac_or.gibr_gfun_fund_cd,
                        v_giac_or.gibr_branch_cd
                       );
         v_giac_or.check_ri_comm := check_ri_comm (p_tran_id);
         v_giac_or.check_item_text := check_item_text (p_tran_id);
         PIPE ROW (v_giac_or);
      END LOOP;

      RETURN;
   END get_giac_or_rep;

   PROCEDURE ins_upd_giop_giacs050 (
      p_gacc_tran_id   IN       giac_op_text.gacc_tran_id%TYPE,
      p_branch_cd      IN       giac_or_pref.branch_cd%TYPE,
      p_fund_cd        IN       giac_or_pref.fund_cd%TYPE,
      p_or_pref        IN       giac_doc_sequence.doc_pref_suf%TYPE,
      p_or_no          IN       giac_doc_sequence.doc_seq_no%TYPE,
      p_user_id        IN       giac_dcb_users.user_id%TYPE,
      p_result         OUT      VARCHAR2
   )
   IS
      CURSOR giop
      IS
         SELECT or_pref_suf, or_no, NVL (with_pdc, 'N')
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_gacc_tran_id
            AND gibr_gfun_fund_cd = p_fund_cd
            AND gibr_branch_cd = p_branch_cd;

      v_or_pref      giac_doc_sequence.doc_pref_suf%TYPE;
      v_or_no        giac_doc_sequence.doc_seq_no%TYPE;
      v_with_pdc     giac_order_of_payts.with_pdc%TYPE;
      v_or_pref_no   VARCHAR2 (15);
   BEGIN
      GIIS_USERS_PKG.app_user := NVL(p_user_id, USER); 
   
      p_result := 'Y';

      OPEN giop;

      FETCH giop
       INTO v_or_pref, v_or_no, v_with_pdc;

      IF giop%FOUND
      THEN
         IF v_or_no IS NULL
         THEN
            UPDATE giac_order_of_payts
               SET or_pref_suf = p_or_pref,
                   or_no = p_or_no,
                   or_flag = 'P',
                   user_id = NVL (p_user_id, USER),
                   last_update = SYSDATE
             --or_date = sysdate
            WHERE  gacc_tran_id = p_gacc_tran_id
               AND gibr_gfun_fund_cd = p_fund_cd
               AND gibr_branch_cd = p_branch_cd;

            IF v_with_pdc = 'Y'
            THEN
               UPDATE giac_pdc_checks
                  SET ref_no = p_or_pref || '-' || TO_CHAR (p_or_no)
                WHERE gacc_tran_id = p_gacc_tran_id;
            END IF;

            UPDATE giac_or_rel
               SET new_or_pref_suf = p_or_pref,
                   new_or_no = p_or_no,
                   user_id = NVL (p_user_id, USER),
                   last_update = SYSDATE
             WHERE tran_id = p_gacc_tran_id;
         ELSE
            p_result := 'N';
         END IF;
      END IF;

      -- / / / /
      IF p_result = 'Y'
      THEN
         UPDATE giac_or_rel
            SET new_or_pref_suf = p_or_pref,
                new_or_no = p_or_no,
                user_id = NVL (p_user_id, USER),
                last_update = SYSDATE
          WHERE tran_id = p_gacc_tran_id;
      END IF;
   END ins_upd_giop_giacs050;

   PROCEDURE insert_into_order_of_payts (
      p_fund_cd          giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd        giac_order_of_payts.gibr_branch_cd%TYPE,
      p_dcb_no           giac_order_of_payts.dcb_no%TYPE,
      p_or_pref_suf      giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no            giac_order_of_payts.or_no%TYPE,
      p_acc_tran_id      giac_acctrans.tran_id%TYPE,
      p_payor            giac_order_of_payts.payor%TYPE,
      p_collection_amt   giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd       giac_order_of_payts.cashier_cd%TYPE,
      p_or_tag           giac_order_of_payts.or_tag%TYPE,
      p_gross_amt        giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag        giac_order_of_payts.gross_tag%TYPE
   )
   IS
      v_particulars   giac_order_of_payts.particulars%TYPE;
   BEGIN
      v_particulars :=
            'Reversing entry for cancelled OR No.'
         || p_or_pref_suf
         || ' '
         || TO_CHAR (p_or_no)
         || '.';

      INSERT INTO giac_order_of_payts
                  (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd, payor,
                   user_id, last_update,
                   collection_amt, cashier_cd, particulars, or_tag,
                   or_date, dcb_no, gross_amt, gross_tag, or_cancel_tag
                  )
           VALUES (p_acc_tran_id, p_fund_cd, p_branch_cd, p_payor,
                   NVL (giis_users_pkg.app_user, USER), SYSDATE,
                   p_collection_amt, p_cashier_cd, v_particulars, p_or_tag,
                   SYSDATE, p_dcb_no, p_gross_amt, p_gross_tag, 'Y'
                  );
   END insert_into_order_of_payts;

   PROCEDURE update_gacc_giop_tables (
      p_gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      p_dcb_no              giac_order_of_payts.dcb_no%TYPE,
      p_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date             VARCHAR2
   )
   IS
      v_dcb_tran_date   giac_order_of_payts.cancel_date%TYPE;
      tran_for_update   giac_acctrans.tran_id%TYPE;
   BEGIN
      v_dcb_tran_date :=
         get_or_dcb_tran_date (p_or_date,
                               p_gibr_gfun_fund_cd,
                               p_gibr_branch_cd,
                               p_dcb_no
                              );
      tran_for_update := p_gacc_tran_id;

      UPDATE giac_acctrans
         SET tran_flag = 'D'
       WHERE tran_id = tran_for_update;

      UPDATE giac_order_of_payts
         SET or_flag = 'C',
             user_id = NVL (giis_users_pkg.app_user, USER),
             last_update = SYSDATE,
             cancel_date = v_dcb_tran_date,
             cancel_dcb_no = p_dcb_no
       WHERE gacc_tran_id = tran_for_update;

      delete_workflow_rec ('CANCEL OR',
                           'GIACS001',
                           NVL (giis_users_pkg.app_user, USER),
                           tran_for_update
                          );
   END update_gacc_giop_tables;

   PROCEDURE process_spoil_or (
      p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
      p_but_label           IN       VARCHAR2,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
      p_or_tag              IN       giac_order_of_payts.or_tag%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date                      VARCHAR2,
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_calling_form                 VARCHAR2,
      p_module_name                  VARCHAR2,
      p_or_cancellation              VARCHAR2,
      p_payor                        giac_order_of_payts.payor%TYPE,
      p_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
      p_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      p_item_no                      giac_module_entries.item_no%TYPE,
      p_message             OUT      VARCHAR2
   )
   IS
        v_opctr          NUMBER          := 0;
        v_y_totctr       NUMBER;
        v_x_totctr       NUMBER;
        v_y_spoilctr     NUMBER;
        v_x_spoilctr     NUMBER;
        --v_tran_id_msg1   VARCHAR2 (2000);
        --v_tran_id_msg2   VARCHAR2 (2000);
        v_tran_id_msg    VARCHAR2(2000);
        v_cancel_flag    VARCHAR2 (1);
        v_cancel         VARCHAR2 (1);
        v_closed_tag     VARCHAR2 (1);
        
        v_cont           VARCHAR2(1) := 'Y';
        v_total_comm         NUMBER := 0;       
        v_bill_no                 VARCHAR2(2000);
        
        --added based on SR 8409 in c.s.
        v_module_id1         GIAC_MODULES.module_id%TYPE;
        --v_gen_type        GIAC_MODULES.generation_type%TYPE;
        v_gl_acct_category NUMBER;
        v_gl_control_acct  NUMBER;
        v_gl_sub_acct_1    NUMBER;
        v_gl_sub_acct_2    NUMBER;
        v_gl_sub_acct_3    NUMBER;
        v_gl_sub_acct_4    NUMBER;
        v_gl_sub_acct_5    NUMBER; 
        v_gl_sub_acct_6    NUMBER;
        v_gl_sub_acct_7    NUMBER;
        v_gl_acct_id       NUMBER;
        V_INTM_TYPE_LEVEL  NUMBER;
        v_dr_cr_tag        VARCHAR2(3);
        v_gen_type        VARCHAR2(5);
        v_sl_type_cd       VARCHAR2(3); 
        v_LINE_DEPENDENCY_LEVEL NUMBER; 

        ws_line_cd NUMBER;
        v_module_id2 NUMBER;
        v_generation_type VARCHAR2(10);
   BEGIN
      SELECT COUNT (*)
        INTO v_opctr
        FROM giac_order_of_payts
       WHERE gacc_tran_id = p_gacc_tran_id
         AND gacc_tran_id IN (SELECT gacc_tran_id
                                FROM giac_direct_prem_collns);

      IF v_opctr > 0
      THEN
         check_commission (p_gacc_tran_id, v_cancel_flag);

         IF v_cancel_flag != 'Y'
         THEN
            FOR y IN (SELECT DISTINCT b140_iss_cd, b140_prem_seq_no
                                 FROM giac_direct_prem_collns
                                WHERE gacc_tran_id = p_gacc_tran_id)
            LOOP
                SELECT NVL (SUM (comm_amt), 0) total_comm
                  INTO v_total_comm
                    FROM giac_comm_payts
                  WHERE iss_cd = y.b140_iss_cd
                      AND prem_seq_no = y.b140_prem_seq_no
                      AND gacc_tran_id != p_gacc_tran_id;
                   
                IF v_total_comm <> 0 THEN
                    v_bill_no := y.b140_iss_cd||' - '||LPAD(y.b140_prem_seq_no,12,0);
                    
                    FOR x IN (SELECT gacc_tran_id
                                          FROM giac_acctrans gac, giac_comm_payts gcp
                                          WHERE tran_flag != 'D'
                                            AND gcp.iss_cd = y.b140_iss_cd
                                            AND gcp.prem_seq_no = y.b140_prem_seq_no
                                           AND gac.tran_id = gcp.gacc_tran_id
                                           AND NOT EXISTS (
                                                    SELECT 'X'
                                                      FROM giac_reversals c, giac_acctrans d
                                                     WHERE c.reversing_tran_id = d.tran_id
                                                       AND d.tran_flag != 'D'
                                                       AND c.gacc_tran_id = gac.tran_id)
                                             AND GAC.TRAN_ID!= p_gacc_tran_id) 
                    LOOP--APRIL 04072011
                      v_tran_id_msg := v_tran_id_msg||Get_Ref_No(x.GACC_TRAN_ID)||CHR(13);
                      v_cont := 'N';
                    END LOOP; /** FOR x **/ 
                
                    IF v_cont = 'N' THEN
                        p_message := 'The commission of bill no. '||v_bill_no||' was already settled. Please cancel the commission payment first before cancelling the O.R.'
                                     ||CHR(13)||CHR(13)||
                                     'Reference No.: '||CHR(13)
                                     || v_tran_id_msg;
                    END IF;    
                    
                END IF;
            END LOOP; /** FOR y **/    
            
            /*IF v_cont = 'N' THEN
                  RAISE FORM_TRIGGER_FAILURE;
            END IF;*/
         END IF; /** IF :parameter.cancel_flag != 'Y' **/
         
      END IF; /** IF v_opctr > 0 **/         

      IF p_but_label = 'Spoil OR'
      THEN
         IF p_or_flag = 'P'
         THEN
            IF p_or_tag IS NULL
            THEN
               giac_order_of_payts_pkg.spoil_or (p_gacc_tran_id,
                                                 p_or_pref_suf,
                                                 p_or_no,
                                                 p_gibr_gfun_fund_cd,
                                                 p_gibr_branch_cd,
                                                 p_or_date,
                                                 p_dcb_no,
                                                 p_or_flag,
                                                 p_message
                                                );

               UPDATE giac_order_of_payts
                  SET or_pref_suf = p_or_pref_suf,
                      or_no = p_or_no,
                      or_flag = p_or_flag
                WHERE gacc_tran_id = p_gacc_tran_id;
            ELSE
               p_message := 'Spoiling of a manual O.R. is not allowed.';
            END IF;
         ELSIF p_or_flag = 'N'
         THEN
            p_message := 'This O.R. has not yet been printed.';
         ELSIF p_or_flag = 'C'
         THEN
            p_message := 'This O.R. has already been cancelled.';
         ELSIF p_or_flag = 'R'
         THEN
            p_message := 'This O.R. has already been cancelled and replaced.';
         ELSIF p_or_flag = 'D'
         THEN
            p_message := 'This O.R. has already been deleted.';
         ELSE
            p_message := 'Spoiling not allowed.';
         END IF;
      ELSE --cancel or
        -- added validations based on SR8409 in c.s.
        -- added by d.alcantara, 02102012
        IF NVL(giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN
            BEGIN
                SELECT module_id, generation_type
                  INTO v_module_id1, v_gen_type
                  FROM giac_modules
                 WHERE module_name = 'GIACB005';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_message := 'No GIACB005 in GIAC_MODULES';
                RETURN;
            END;
            
            BEGIN
                SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
                   NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                   NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0),
                     A.dr_cr_tag,B.generation_type,A.sl_type_cd,A.LINE_DEPENDENCY_LEVEL  
                  INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
                       V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
                       V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7, V_INTM_TYPE_LEVEL,
                       v_dr_cr_tag,v_gen_type, v_sl_type_cd, v_LINE_DEPENDENCY_LEVEL  
                 FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
                WHERE B.module_name = 'GIACB005'
                  AND A.item_no = 1
                  AND B.module_id = A.module_id; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_message := 'CREATE_REV_ENTRIES - 
                                  No data found for GIACB005 in GIAC_MODULE_ENTRIES.  Item No 1.';
                    RETURN;
            END;
        
            --AEG_Check_Chart_Of_Accts2(
            GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(
                                     v_gl_acct_category,v_gl_control_acct,
                                     v_gl_sub_acct_1, v_gl_sub_acct_2,
                                     v_gl_sub_acct_3, v_gl_sub_acct_4,
                                     v_gl_sub_acct_5, v_gl_sub_acct_6,
                                     v_gl_sub_acct_7,v_gl_acct_id,p_message);   
            IF p_message IS NOT NULL THEN
                RETURN;
            END IF;                   
                                 
            BEGIN
         
                SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
                       NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
                       NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.LINE_DEPENDENCY_LEVEL,0), A.dr_cr_tag,
                       B.generation_type 
                  INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
                       V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
                       V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_LINE_DEPENDENCY_LEVEL, v_dr_cr_tag,
                       v_gen_type
                  FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
                 WHERE B.module_name = 'GIACB005'
                   AND A.item_no     = 2
                   AND B.module_id   = A.module_id; 

            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_message := 'COMM PAYABLE PROC - 
                           No data found in GIAC_MODULE_ENTRIES.  Item No = 2.';
                RETURN;           
            END;
      
            IF v_LINE_DEPENDENCY_LEVEL != 0 THEN

                FOR col IN (
                  SELECT a.assd_no, b.line_cd,
                         SUM(premium_amt + tax_amt)coll_amt
                    FROM giac_advanced_payt a, gipi_polbasic b
                   WHERE gacc_tran_id    = p_gacc_tran_id
                     AND a.policy_id     = b.policy_id
                     AND a.acct_ent_date IS NOT NULL
                   GROUP BY a.assd_no, b.line_cd )
                 LOOP
                     BEGIN
                     SELECT acct_line_cd
                       INTO ws_line_cd
                       FROM giis_line
                      WHERE line_cd = col.line_cd;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN  
                        p_message := 'No data found in giis_line.';   
                   END;

                   AEG_Check_Level(v_LINE_DEPENDENCY_LEVEL , ws_line_cd,
                                         v_gl_sub_acct_1         , v_gl_sub_acct_2,
                                         v_gl_sub_acct_3         , v_gl_sub_acct_4,
                                         v_gl_sub_acct_5         , v_gl_sub_acct_6,
                                   v_gl_sub_acct_7);
                        
                   --AEG_Check_Chart_Of_Accts2(v_gl_acct_category,v_gl_control_acct,
                   GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(
                                             v_gl_acct_category,v_gl_control_acct,
                                             v_gl_sub_acct_1, v_gl_sub_acct_2,
                                             v_gl_sub_acct_3, v_gl_sub_acct_4,
                                             v_gl_sub_acct_5, v_gl_sub_acct_6,
                                             v_gl_sub_acct_7,v_gl_acct_id, p_message);
                                             
                   IF p_message IS NOT NULL THEN
                       RETURN;
                   END IF; 
                END LOOP; 
            END IF;
        END IF;             
        --get_dcb_no(:gior.gibr_gfun_fund_cd, :gior.gibr_branch_cd);

        FOR id IN (SELECT module_id, generation_type
                     FROM giac_modules
                    WHERE UPPER(module_name) = p_module_name) 
        LOOP
          v_module_id2:= id.module_id;
          v_generation_type := id.generation_type;
          EXIT;
        END LOOP;
/*          --commented 08/10/12, hindi na kailangan ivalidate ang giac_module_entries
            --para sa GIACS001, ayon kay sir jm
        IF v_module_id2 IS NULL THEN
          p_message := 'Cancel OR: Module ID not found.';
          RETURN;
        ELSE
          FOR mod_entr IN (
               SELECT gime.gl_acct_category, gime.gl_control_acct,
                      gime.gl_sub_acct_1, gime.gl_sub_acct_2,
                      gime.gl_sub_acct_3, gime.gl_sub_acct_4,
                      gime.gl_sub_acct_5, gime.gl_sub_acct_6,
                      gime.gl_sub_acct_7, gime.sl_type_cd,
                      gcoa.gl_acct_id
                 FROM giac_chart_of_accts gcoa,
                      giac_modules gimod,
                      giac_module_entries gime
                WHERE gcoa.gl_control_acct = gime.gl_control_acct
                  AND gcoa.gl_sub_acct_1 = gime.gl_sub_acct_1
                  AND gcoa.gl_sub_acct_2 = gime.gl_sub_acct_2
                  AND gcoa.gl_sub_acct_3 = gime.gl_sub_acct_3
                  AND gcoa.gl_sub_acct_4 = gime.gl_sub_acct_4
                  AND gcoa.gl_sub_acct_5 = gime.gl_sub_acct_5
                  AND gcoa.gl_sub_acct_6 = gime.gl_sub_acct_6
                  AND gcoa.gl_sub_acct_7 = gime.gl_sub_acct_7
                  AND gcoa.leaf_tag = 'Y'
                  AND gime.item_no = p_item_no
                  AND gimod.module_id = gime.module_id
                  AND gime.module_id = v_module_id2) 
          LOOP
            v_gl_acct_id := mod_entr.gl_acct_id;
            EXIT;
          END LOOP;

          IF v_gl_acct_id IS NULL THEN
            p_message := 'Cancel OR: Error locating GL acct in ' ||
                      'module_entries/chart_of_accts.';
            RETURN;
          END IF;
        END IF;*/
        --
        IF get_tran_flag(p_gacc_tran_id) = 'D' THEN
            p_message := 'Cancellation not allowed. This is a deleted ' ||
                    'transaction.';
            RETURN;
        END IF;
        -- end of added code based on SR8409
        
         FOR x IN (SELECT param_value_v cancel_param
                     FROM giac_parameters
                    WHERE param_name = 'ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH')
         LOOP
            v_cancel := x.cancel_param;
            EXIT;
         END LOOP;

         FOR y IN (SELECT closed_tag
                     FROM giac_tran_mm
                    WHERE fund_cd = p_gibr_gfun_fund_cd
                      AND branch_cd = p_gibr_branch_cd
                      AND tran_yr =
                             TO_NUMBER (TO_CHAR (TO_DATE (p_or_date,
                                                          'MM-DD-YYYY'
                                                         ),
                                                 'YYYY'
                                                )
                                       )
                      AND tran_mm =
                             TO_NUMBER (TO_CHAR (TO_DATE (p_or_date,
                                                          'MM-DD-YYYY'
                                                         ),
                                                 'MM'
                                                )
                                       ))
         LOOP
            v_closed_tag := y.closed_tag;
            EXIT;
         END LOOP;

         IF v_cancel = 'N' AND v_closed_tag = 'Y'
         THEN
            p_message :=
               'You are no longer allowed to cancel this transaction. The transaction month is already closed.';
         ELSIF v_cancel = 'N' AND v_closed_tag = 'T'
         THEN
            p_message :=
               'You are no longer allowed to cancel this transaction. The transaction month is temporarily closed.';
         ELSE    
                                     -- Continue Cancellation
                                     
            IF p_or_flag = 'N' OR p_or_flag = 'P'
            THEN
               IF p_or_flag = 'N'
               THEN
                  giac_order_of_payts_pkg.cancel_or (p_dcb_no,
                                                     p_gacc_tran_id,
                                                     p_gibr_gfun_fund_cd,
                                                     p_gibr_branch_cd,
                                                     p_or_pref_suf,
                                                     p_or_no,
                                                     p_or_date,
                                                     p_message,
                                                     p_calling_form,
                                                     p_module_name,
                                                     p_or_cancellation,
                                                     p_payor,
                                                     p_collection_amt,
                                                     p_cashier_cd,
                                                     p_or_tag,
                                                     p_gross_amt,
                                                     p_gross_tag,
                                                     p_item_no,
                                                     p_or_flag
                                                    );
               ELSIF p_or_flag = 'P'
               THEN
               null;
                
                  giac_order_of_payts_pkg.cancel_or (p_dcb_no,
                                                     p_gacc_tran_id,
                                                     p_gibr_gfun_fund_cd,
                                                     p_gibr_branch_cd,
                                                     p_or_pref_suf,
                                                     p_or_no,
                                                     p_or_date,
                                                     p_message,
                                                     p_calling_form,
                                                     p_module_name,
                                                     p_or_cancellation,
                                                     p_payor,
                                                     p_collection_amt,
                                                     p_cashier_cd,
                                                     p_or_tag,
                                                     p_gross_amt,
                                                     p_gross_tag,
                                                     p_item_no,
                                                     p_or_flag
                                                    ); 
               ELSIF p_or_flag = 'C'
               THEN
                  p_message := 'This O.R. has already been cancelled.';
               ELSIF p_or_flag = 'R'
               THEN
                  p_message :=
                         'This O.R. has already been cancelled and replaced.';
               ELSIF p_or_flag = 'D'
               THEN
                  p_message := 'This O.R. has already been deleted.';
               ELSE
                  p_message := 'Cancellation not allowed.';
               END IF;
            --ELSE
             -- p_message := 'Spoil_Cancel_OR_But: Invalid label.';
            END IF;
         END IF;
      END IF;
   END process_spoil_or;

   PROCEDURE spoil_or (
      p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_date                      VARCHAR2,
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
      p_message             OUT      VARCHAR2
   )
   IS
      v_tran_flag   giac_acctrans.tran_flag%TYPE;
   BEGIN
      FOR T IN (SELECT tran_flag
                  FROM giac_acctrans
                 WHERE tran_id = p_gacc_tran_id)
      LOOP
         v_tran_flag := T.tran_flag;
      END LOOP;

      IF v_tran_flag IN ('O', 'C')
      THEN
         DECLARE
            v_dcb_flag   giac_colln_batch.dcb_flag%TYPE;
         BEGIN
            BEGIN
               SELECT dcb_flag
                 INTO v_dcb_flag
                 FROM giac_colln_batch
                WHERE fund_cd = p_gibr_gfun_fund_cd
                  AND branch_cd = p_gibr_branch_cd
                  AND dcb_year =
                         TO_NUMBER (TO_CHAR (TO_DATE (p_or_date, 'mm-dd-yyyy'),
                                             'YYYY'
                                            )
                                   )
                  AND dcb_no = p_dcb_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_dcb_flag := 'O';
            END;

            IF v_dcb_flag IN ('O', 'X')
            THEN
               BEGIN
                  --/*A.R.C. 08.29.2005*/--
                  -- to delete workflow records of accounting
                  delete_workflow_rec ('SPOIL OR',
                                       'GIACS001',
                                       NVL (giis_users_pkg.app_user, USER),
                                       p_gacc_tran_id
                                      );

                  --/*08.29.2005*/--
                  INSERT INTO giac_spoiled_or
                              (or_pref, or_no, fund_cd,
                               branch_cd, spoil_date, spoil_tag,
                               tran_id,
                               user_id, last_update,
                               or_date
                              )
                       VALUES (p_or_pref_suf, p_or_no, p_gibr_gfun_fund_cd,
                               p_gibr_branch_cd, SYSDATE, 'S',
                               p_gacc_tran_id,
                               NVL (giis_users_pkg.app_user, USER), SYSDATE,
                               TO_DATE (p_or_date, 'mm-dd-yyyy')
                              );

                  IF SQL%FOUND
                  THEN
                     p_or_pref_suf := NULL;
                     p_or_no := NULL;
                     p_or_flag := 'N';

                     --p_user_id := NVL(giis_users_pkg.app_user, USER);
                     --p_last_update := SYSDATE;
                     IF v_tran_flag = 'C'
                     THEN
                        UPDATE giac_acctrans
                           SET tran_flag = 'O'
                         WHERE tran_id = p_gacc_tran_id;

                        IF SQL%NOTFOUND
                        THEN
                           ROLLBACK;
                           p_message :=
                                       'Spoil OR: Unable to update acctrans.';
                        END IF;
                     END IF;
                  /*
                     IF nvl(giacp.v('UPLOAD_IMPLEMENTATION_SW'),'N') = 'Y' THEN --Vincent 05092006
                        exec_immediate('BEGIN upload_dpc.upd_guf('||:gior.gacc_tran_id||'); END;');--Vincent 08222006
                        forms_ddl('COMMIT');--Vincent 08222006
                     END IF;
                  */
                  ELSE
                     p_message :=
                                'Spoil OR: Unable to insert into spoiled_or.';
                  END IF;
               END;
            ELSIF v_dcb_flag IN ('T', 'C')
            THEN
               p_message :=
                     'Spoiling not allowed. The DCB No. has '
                  || 'already been closed/temporarily closed. You '
                  || 'may cancel this O.R. instead.';
            END IF;
         END;
      ELSIF v_tran_flag = 'D'
      THEN
         p_message := 'Spoiling not allowed. This is a deleted transaction.';
      ELSIF v_tran_flag = 'P'
      THEN
         p_message := 'Spoiling not allowed. This is a posted transaction.';
      END IF;
   END spoil_or;

   PROCEDURE cancel_or (
      p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
      p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_or_date                      VARCHAR2,
      p_message             OUT      VARCHAR2,
      p_calling_form                 VARCHAR2,
      p_module_name                  VARCHAR2,
      p_or_cancellation              VARCHAR2,
      p_payor                        giac_order_of_payts.payor%TYPE,
      p_collection_amt               giac_order_of_payts.collection_amt%TYPE,
      p_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
      p_or_tag                       giac_order_of_payts.or_tag%TYPE,
      p_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
      p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
      p_item_no                      giac_module_entries.item_no%TYPE,
      p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE
   )
   IS
      v_tran_flag       giac_acctrans.tran_flag%TYPE;
      v_dcb_flag        giac_colln_batch.dcb_flag%TYPE;
      v_tran_date       giac_colln_batch.tran_date%TYPE;
      v_cancel_date     giac_order_of_payts.cancel_date%TYPE;
      v_cancel_dcb_no   giac_order_of_payts.cancel_dcb_no%TYPE;
      v_dcb_no          giac_order_of_payts.dcb_no%TYPE;
      v_module_id       giac_modules.module_id%TYPE;
      v_tran_id         giac_acctrans.tran_id%TYPE;
      v_gen_type        giac_modules.generation_type%TYPE;
      v_mess_txt        VARCHAR2 (256)
         :=    'DCB No. '
            || TO_CHAR (p_dcb_no, 'fm099999')
            || ' is '
            || 'Temporarily Closed. Before cancelling this '
            || 'O.R., please check with the person closing '
            || 'the DCB to ensure that the bank deposit '
            || 'tallies with the collection. Continue '
            || 'cancellation?';
      v_dummy           NUMBER                                   := 0;
   BEGIN
      IF NVL (giacp.v ('ENTER_ADVANCED_PAYT'), 'N') = 'Y'
      THEN
         BEGIN
            SELECT COUNT (*)
              INTO v_dummy
              FROM giac_advanced_payt
             WHERE gacc_tran_id = p_gacc_tran_id AND acct_ent_date IS NOT NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
         IF v_dummy > 0
         THEN
            giac_acct_entries_pkg.insert_acctrans_cap (p_gibr_gfun_fund_cd,
                                                       p_gibr_branch_cd,
                                                       SYSDATE,
                                                       v_cancel_dcb_no,
                                                       p_or_pref_suf,
                                                       p_or_no,
                                                       v_tran_id,
                                                       p_message
                                                      );
            giac_acct_entries_pkg.aeg_parameters_rev (p_gacc_tran_id,
                                                      'GIACB005',
                                                      v_tran_id,
                                                      p_gibr_gfun_fund_cd,
                                                      p_gibr_branch_cd,
                                                      p_message
                                                     );
         END IF;

         UPDATE giac_advanced_payt
            SET cancel_date = SYSDATE,
                rev_gacc_tran_id = v_tran_id
          WHERE gacc_tran_id = p_gacc_tran_id;
      --FORMS_DDL ('COMMIT');
      END IF;

      v_tran_flag := get_tran_flag (p_gacc_tran_id);

      UPDATE giac_pdc_checks
         SET check_flag = 'C',
             user_id = NVL (giis_users_pkg.app_user, USER),
             last_update = SYSDATE
       WHERE gacc_tran_id = p_gacc_tran_id;

      IF v_tran_flag = 'P'
      THEN
         v_dcb_flag :=
            get_dcb_flag (p_dcb_no,
                          p_gibr_gfun_fund_cd,
                          p_gibr_branch_cd,
                          p_or_date
                         );             

         IF UPPER (v_dcb_flag) = 'C'
         THEN
            get_dcb_no (p_gibr_gfun_fund_cd,
                        p_gibr_branch_cd,
                        v_dcb_no,
                        v_tran_date,
                        p_message
                       );
            v_cancel_date := SYSDATE/*v_tran_date*/;
            v_cancel_dcb_no := v_dcb_no; 
            IF p_message IS NOT NULL THEN
                RETURN;
            END IF;
         ELSIF UPPER (v_dcb_flag) IN ('O', 'T', 'X')
         THEN
            v_cancel_date := SYSDATE;
               /*get_or_dcb_tran_date (p_or_date,
                                     p_gibr_gfun_fund_cd,
                                     p_gibr_branch_cd,
                                     p_dcb_no
                                    );*/
            v_cancel_dcb_no := p_dcb_no;
         END IF;

         BEGIN
            UPDATE giac_comm_slip_ext
               SET comm_slip_tag = 'C'
             WHERE gacc_tran_id = p_gacc_tran_id;

            UPDATE giac_order_of_payts
               SET or_flag = 'C',
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE,
                   cancel_date = NVL(v_cancel_date, SYSDATE),
                   cancel_dcb_no = v_cancel_dcb_no
             WHERE gacc_tran_id = p_gacc_tran_id;

            IF SQL%FOUND
            THEN
               p_or_flag := 'C';
               delete_workflow_rec ('CANCEL OR',
                                    'GIACS001',
                                    NVL (giis_users_pkg.app_user, USER),
                                    p_gacc_tran_id
                                   );
               giac_acctrans_pkg.create_records_in_acctrans
                                                         (p_gibr_gfun_fund_cd,
                                                          p_gibr_branch_cd,
                                                          v_cancel_date,
                                                          v_cancel_dcb_no,
                                                          p_or_cancellation,
                                                          p_or_date,
                                                          p_dcb_no,
                                                          p_or_no,
                                                          p_or_pref_suf,
                                                          v_tran_id,
                                                          p_calling_form,
                                                          p_message
                                                         );
               giac_reversals_pkg.insert_into_reversals (p_gacc_tran_id,
                                                         v_tran_id,
                                                         p_message
                                                        );
               giac_order_of_payts_pkg.insert_into_order_of_payts
                                                         (p_gibr_gfun_fund_cd,
                                                          p_gibr_branch_cd,
                                                          v_cancel_dcb_no,
                                                          p_or_pref_suf,
                                                          p_or_no,
                                                          v_tran_id,
                                                          p_payor,
                                                          p_collection_amt,
                                                          p_cashier_cd,
                                                          p_or_tag,
                                                          p_gross_amt,
                                                          p_gross_tag
                                                         );
               giac_acct_entries_pkg.insert_into_acct_entries
                                                         (p_gacc_tran_id,
                                                          p_gibr_gfun_fund_cd,
                                                          p_gibr_branch_cd,
                                                          v_tran_id,
                                                          p_item_no,
                                                          p_module_name,
                                                          p_message
                                                         );
            ELSE
               p_message :=
                     'Cancel OR: Error locating the tran_id of this '
                  || 'record.';
            END IF;
         END;
      ELSIF v_tran_flag = 'D'
      THEN
         p_message :=
             'Cancellation not allowed. This is a deleted ' || 'transaction.';
      ELSE
         v_dcb_flag :=
            get_dcb_flag (p_dcb_no,
                          p_gibr_gfun_fund_cd,
                          p_gibr_branch_cd,
                          p_or_date
                         );

         IF UPPER (v_dcb_flag) = 'C'
         THEN
            get_dcb_no (p_gibr_gfun_fund_cd,
                        p_gibr_branch_cd,
                        v_dcb_no,
                        v_tran_date,
                        p_message
                       );
            v_cancel_date := SYSDATE/*NVL(v_tran_date, SYSDATE)*/;
            v_cancel_dcb_no := v_dcb_no;

            BEGIN
               UPDATE giac_comm_slip_ext
                  SET comm_slip_tag = 'C'
                WHERE gacc_tran_id = p_gacc_tran_id;

               UPDATE giac_order_of_payts
                  SET or_flag = 'C',
                      user_id = NVL (giis_users_pkg.app_user, USER),
                      last_update = SYSDATE,
                      cancel_date = v_cancel_date,
                      cancel_dcb_no = v_cancel_dcb_no
                WHERE gacc_tran_id = p_gacc_tran_id;

               IF SQL%FOUND
               THEN
                  p_or_flag := 'C';
                  giac_order_of_payts_pkg.update_gacc_giop_tables
                                                        (p_gacc_tran_id,
                                                         p_dcb_no,
                                                         p_gibr_gfun_fund_cd,
                                                         p_gibr_branch_cd,
                                                         p_or_date
                                                        );
               ELSE
                  p_message :=
                        'Cancel OR: Error locating the tran_id of this '
                     || 'record.';
               END IF;
            END;
         ELSIF UPPER (v_dcb_flag) IN ('O', 'X')
         THEN
            giac_order_of_payts_pkg.update_gacc_giop_tables
                                                        (p_gacc_tran_id,
                                                         p_dcb_no,
                                                         p_gibr_gfun_fund_cd,
                                                         p_gibr_branch_cd,
                                                         p_or_date
                                                        );

            UPDATE giac_comm_slip_ext
               SET comm_slip_tag = 'C'
             WHERE gacc_tran_id = p_gacc_tran_id;
         ELSIF UPPER (v_dcb_flag) = 'T'
         THEN
            giac_order_of_payts_pkg.update_gacc_giop_tables
                                                        (p_gacc_tran_id,
                                                         p_dcb_no,
                                                         p_gibr_gfun_fund_cd,
                                                         p_gibr_branch_cd,
                                                         p_or_date
                                                        );
         END IF;
         
         UPDATE giac_order_of_payts 
            SET cancel_date = SYSDATE
          WHERE gacc_tran_id = p_gacc_tran_id;
          
      END IF;
   END;

   FUNCTION get_credit_memo_dtls (
      p_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE
   )
      RETURN giac_credit_memo_tab PIPELINED
   IS
   v_credit_memo giac_credit_memo_type;
   BEGIN
      FOR i IN (SELECT      b.memo_type
                         || '-'
                         || b.memo_year
                         || '-'
                         || b.memo_seq_no cm_no,
                         b.memo_date, (b.amount - d.fcurrency_amt) amount,
                         b.currency_cd, b.currency_rt,
                         (b.local_amt - d.amount) local_amt, c.short_name,
                         b.gacc_tran_id cm_tran_id
                    FROM giac_acctrans A,
                         giac_cm_dm b,
                         giis_currency c,
                         (SELECT   cm_tran_id, SUM (x.amount) amount,
                                   SUM (x.fcurrency_amt) fcurrency_amt
                              FROM giac_order_of_payts y,
                                   giac_collection_dtl x
                             WHERE x.gacc_tran_id = y.gacc_tran_id
                               AND y.or_flag NOT IN ('C', 'R')
                               AND x.cm_tran_id IS NOT NULL
                               AND x.cm_tran_id > 0
                               AND x.pay_mode = 'CMI'
                          GROUP BY cm_tran_id) d
                   WHERE A.tran_id = b.gacc_tran_id
                     AND b.currency_cd = c.main_currency_cd
                     AND b.memo_type = 'CM'
                     AND A.tran_flag IN ('C', 'P')
                     AND b.memo_status <> 'C'
                     AND b.fund_cd = p_fund_cd
                     AND d.cm_tran_id = b.gacc_tran_id
                     AND (   (b.local_amt - d.amount) <> 0
                          OR (b.amount - d.fcurrency_amt) <> 0
                         )
                UNION
                SELECT      b.memo_type
                         || '-'
                         || b.memo_year
                         || '-'
                         || b.memo_seq_no cm_no,
                         b.memo_date, b.amount, b.currency_cd, b.currency_rt,
                         b.local_amt, c.short_name, b.gacc_tran_id cm_tran_id
                    FROM giac_acctrans A, giac_cm_dm b, giis_currency c
                   WHERE A.tran_id = b.gacc_tran_id
                     AND b.currency_cd = c.main_currency_cd
                     AND b.memo_type = 'CM'
                     AND A.tran_flag IN ('C', 'P')
                     AND b.memo_status <> 'C'
                     AND b.fund_cd = p_fund_cd
                     AND b.gacc_tran_id > 0
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_order_of_payts y,
                                   giac_collection_dtl x
                             WHERE x.gacc_tran_id = y.gacc_tran_id
                               AND y.or_flag NOT IN ('C', 'R')
                               AND x.cm_tran_id = A.tran_id
                               AND x.pay_mode = 'CMI')
                ORDER BY cm_no DESC, memo_date DESC)
      LOOP
         v_credit_memo.cm_no := i.cm_no;
         v_credit_memo.memo_date := i.memo_date;
         v_credit_memo.amount  := i.amount;
         v_credit_memo.currency_cd := i.currency_cd;
         v_credit_memo.currency_rt := i.currency_rt;
         v_credit_memo.local_amt  := i.local_amt;
         v_credit_memo.short_name := i.short_name;
         v_credit_memo.cm_tran_id := i.cm_tran_id;
         PIPE ROW(v_credit_memo);
      END LOOP;
   END get_credit_memo_dtls;
   
   FUNCTION get_credit_memo_dtls_list (
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_memo_type   giac_cm_dm.memo_type%TYPE,
      p_pay_mode    giac_collection_dtl.pay_mode%TYPE
   )
      RETURN giac_credit_memo_tab PIPELINED
   IS
   v_credit_memo giac_credit_memo_type;
   BEGIN
      FOR i IN (SELECT      b.memo_type
                         || '-'
                         || b.memo_year
                         || '-'
                         || b.memo_seq_no cm_no,
                         b.memo_date, (b.amount - d.fcurrency_amt) amount,
                         (b.amount - d.fcurrency_amt) fc_amount,
                         b.currency_cd, b.currency_rt,
                         (b.local_amt - d.amount) local_amt, c.short_name,
                         b.gacc_tran_id cm_tran_id
                    FROM giac_acctrans A,
                         giac_cm_dm b,
                         giis_currency c,
                         (SELECT   cm_tran_id, SUM (x.amount) amount,
                                   SUM (x.fcurrency_amt) fcurrency_amt
                              FROM giac_order_of_payts y,
                                   giac_collection_dtl x
                             WHERE x.gacc_tran_id = y.gacc_tran_id
                               AND y.or_flag NOT IN ('C', 'R')
                               AND x.cm_tran_id IS NOT NULL
                               AND x.cm_tran_id > 0
                               AND x.pay_mode = p_pay_mode
                          GROUP BY cm_tran_id) d
                   WHERE A.tran_id = b.gacc_tran_id
                     AND b.currency_cd = c.main_currency_cd
                     AND b.memo_type = p_memo_type
                     AND A.tran_flag IN ('C', 'P')
                     AND b.memo_status <> 'C'
                     AND b.fund_cd = p_fund_cd
                     AND d.cm_tran_id = b.gacc_tran_id
                     AND (   (b.local_amt - d.amount) <> 0
                          OR (b.amount - d.fcurrency_amt) <> 0
                         )
                UNION
                SELECT      b.memo_type
                         || '-'
                         || b.memo_year
                         || '-'
                         || b.memo_seq_no cm_no,
                         b.memo_date, b.amount,b.amount fc_amount, b.currency_cd, b.currency_rt,
                         b.local_amt, c.short_name, b.gacc_tran_id cm_tran_id
                    FROM giac_acctrans A, giac_cm_dm b, giis_currency c
                   WHERE A.tran_id = b.gacc_tran_id
                     AND b.currency_cd = c.main_currency_cd
                     AND b.memo_type = p_memo_type
                     AND A.tran_flag IN ('C', 'P')
                     AND b.memo_status <> 'C'
                     AND b.fund_cd = p_fund_cd
                     AND b.gacc_tran_id > 0
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_order_of_payts y,
                                   giac_collection_dtl x
                             WHERE x.gacc_tran_id = y.gacc_tran_id
                               AND y.or_flag NOT IN ('C', 'R')
                               AND x.cm_tran_id = A.tran_id
                               AND x.pay_mode = p_pay_mode)
                ORDER BY cm_no DESC, memo_date DESC)
      LOOP
         v_credit_memo.cm_no := i.cm_no;
         v_credit_memo.memo_date := i.memo_date;
         v_credit_memo.amount  := i.amount;
         v_credit_memo.fc_amount  := i.fc_amount;
         v_credit_memo.currency_cd := i.currency_cd;
         v_credit_memo.currency_rt := i.currency_rt;
         v_credit_memo.local_amt  := i.local_amt;
         v_credit_memo.short_name := i.short_name;
         v_credit_memo.cm_tran_id := i.cm_tran_id;
         PIPE ROW(v_credit_memo);
      END LOOP;
   END get_credit_memo_dtls_list;
   
   /*
   ** Created By:       D.Alcantara
   ** Date Created:     04/11/2011
   ** Reference By:     GIACS333, DCB No. Maintenance
   ** Description:      
   */
   FUNCTION check_attached_OR(
       p_dcb_no     GIAC_ORDER_OF_PAYTS.dcb_no%TYPE,
       p_fund_cd    GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
       p_branch_cd  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
       p_tran_date  GIAC_ORDER_OF_PAYTS.or_date%TYPE     
   ) RETURN VARCHAR2 IS
        v_dummy     VARCHAR2(1);
   BEGIN
     BEGIN
     SELECT 'Y'
      INTO v_dummy  
      FROM giac_order_of_payts b
     WHERE ROWNUM = 1
       AND b.dcb_no = p_dcb_no 
       AND b.gibr_gfun_fund_cd = p_fund_cd 
       AND b.gibr_branch_cd = p_branch_cd 
       AND to_char(b.or_date, 'dd-Mon-yyyy') = to_char(p_tran_date, 'dd-Mon-yyyy');
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_dummy := 'N';
     END;
     RETURN v_dummy;
   END check_attached_OR;
/* Formatted on 2011/05/05 18:32 (Formatter Plus v4.8.8) */

FUNCTION get_or_ucpbgen (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
   RETURN giac_or_ucpbgen_tab PIPELINED
IS
   v_get_or   giac_or_ucpbgen_type;
BEGIN
   FOR i IN (SELECT gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd, payor,
                    TO_CHAR (or_date, 'fmMONTH DD, RRRR') or_date,
                    DECODE (gross_tag,
                            'Y', gross_amt,
                            collection_amt
                           ) op_collection_amt,
                    NVL (currency_cd, giacp.n ('CURRENCY_CD')) currency_cd,
                    short_name, gross_tag, intm_no, prov_receipt_no,
                       or_pref_suf
                    || '-'
                    || LTRIM (TO_CHAR (or_no, '0999999999')) or_no,
                    cashier_cd, particulars, dcb_no,
                    address_1 || ' ' || address_2 || ' ' || address_3
                                                                     address,
                    tin
               FROM giac_order_of_payts A, giis_currency b
              WHERE A.currency_cd = b.main_currency_cd
                AND gacc_tran_id = NVL (p_tran_id, gacc_tran_id))
   LOOP
      v_get_or.or_date := i.or_date;
      v_get_or.op_collection_amt := i.op_collection_amt;
      v_get_or.payor := i.payor;
      v_get_or.address := i.address;
      v_get_or.tin := i.tin;
      v_get_or.particulars := i.particulars;
      v_get_or.intm_no := i.intm_no;
      v_get_or.prov_receipt_no := i.prov_receipt_no;
      v_get_or.short_name := i.short_name;
      v_get_or.currency_cd := i.currency_cd;
      v_get_or.bir_permit_no := 'BIR PERMIT NO. '||giacp.v('BIR_PERMIT_NO'); --belle 10042012

      FOR A IN (SELECT intm_name
                  FROM giis_intermediary
                 WHERE intm_no = i.intm_no)
      LOOP
         v_get_or.intm_name := A.intm_name;
         exit;
      END LOOP;

      FOR b IN (SELECT print_name
                  FROM giac_dcb_users
                 WHERE gibr_fund_cd = i.gibr_gfun_fund_cd
                   AND gibr_branch_cd = i.gibr_branch_cd
                   AND cashier_cd = i.cashier_cd)
      LOOP
         v_get_or.print_name := b.print_name;
         exit;
      END LOOP;
      
      v_get_or.vat_type := gipi_inv_tax_pkg.get_vat_type(p_tran_id);
      v_get_or.total_premium := giac_op_text_pkg.get_total_premium(p_tran_id, i.currency_cd);
      
       FOR c IN (SELECT SUM(DECODE(currency_cd,giacp.n('CURRENCY_CD'),
                                   NVL(amount,0),NVL(fcurrency_amt,0))) tax_amt -- edited by Jayson 08.10.2011, added decode to check foreign currency amount
                  FROM giac_collection_dtl
                 WHERE gacc_tran_id = NVL(p_tran_id, gacc_tran_id)
                   AND pay_mode = 'CW')
        LOOP
            v_get_or.grand_total := i.op_collection_amt - nvl(c.tax_amt,0);
        END LOOP;

      PIPE ROW (v_get_or);
      exit;
   END LOOP;

   RETURN;
END get_or_ucpbgen; 

FUNCTION validate_or_no(
      p_or_pref  giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no    giac_order_of_payts.or_no%TYPE,
   p_fund_cd giac_order_of_payts.GIBR_GFUN_FUND_CD%type,
   p_branch_cd giac_order_of_payts.GIBR_BRANCH_CD%type) RETURN VARCHAR2 IS

  CURSOR a1 
  IS
     SELECT '1' 
       FROM giac_order_of_payts
      WHERE or_no = p_or_no
        AND or_pref_suf = p_or_pref
        AND gibr_branch_cd = p_branch_cd
        AND gibr_gfun_fund_cd = p_fund_cd;
             
  CURSOR a2 
  IS
     SELECT '1'
       FROM giac_spoiled_or
      WHERE or_no = p_or_no
        AND or_pref= p_or_pref
        AND branch_cd = p_branch_cd
        AND fund_cd = p_fund_cd;

  v_exists  VARCHAR2(1);
  v_message VARCHAR2(1000);

BEGIN
  OPEN a1;
  FETCH a1 INTO v_exists;
     IF v_exists IS NOT NULL 
     THEN
        v_message := 'OR No. ' || p_or_pref || ' - ' || TO_CHAR(p_or_no) || ' already exists.';
     ELSE
        OPEN a2;
        FETCH a2 INTO v_exists;
           IF v_exists IS NOT NULL 
           THEN
              v_message := 'OR No. ' || p_or_pref || ' - ' || TO_CHAR(p_or_no) || ' has been spoiled.';
           END IF;
        CLOSE a2;
     END IF;
  CLOSE a1;
  
  RETURN v_message;
EXCEPTION
  WHEN OTHERS THEN
    null;
END validate_or_no;

    /*
   ** Created By:       D.Alcantara
   ** Date Created:     07/17/2012
   ** Reference By:     GIACS050
   ** Description:      debugs
   */
    PROCEDURE giacs050_ins_upd_GIOP(
        p_gacc_tran_id  IN  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_branch_cd     IN  giac_order_of_payts.gibr_branch_cd%TYPE,
        p_fund_cd       IN  giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
        p_or_pref          IN  giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no            IN  giac_doc_sequence.doc_seq_no%TYPE,
        p_edit_or_no    IN  VARCHAR2
    ) IS

      CURSOR giop IS
        SELECT or_pref_suf, or_no,NVL(with_pdc,'N')
          FROM giac_order_of_payts
         WHERE gacc_tran_id      = p_gacc_tran_id
           AND gibr_gfun_fund_cd = p_fund_cd
           AND gibr_branch_cd    = P_branch_cd;

      v_or_pref    giac_doc_sequence.doc_pref_suf%TYPE;
      v_or_no      giac_doc_sequence.doc_seq_no%TYPE;
      v_with_pdc   giac_order_of_payts.with_pdc%TYPE;
      v_or_pref_no VARCHAR2(15);
    BEGIN
        OPEN giop;
            FETCH giop INTO v_or_pref, v_or_no,v_with_pdc;
        IF giop%FOUND THEN  --if(a)
            IF p_edit_or_no = 'Y' THEN -- Queenie 8/31/11          
                IF v_or_no IS NULL THEN

                    UPDATE giac_order_of_payts
                       SET or_pref_suf = p_or_pref,
                           or_no = p_or_no,
                           or_flag = 'P',
                           user_id = NVL(giis_users_pkg.app_user, USER),--Vincent 08252006
                           last_update = SYSDATE--Vincent 08252006
                           --or_date = sysdate
                     WHERE gacc_tran_id      = p_gacc_tran_id
                       AND gibr_gfun_fund_cd = p_fund_cd
                       AND gibr_branch_cd    = p_branch_cd;


                    IF v_with_pdc = 'Y' 
                    THEN 
                        UPDATE giac_pdc_checks
                           SET ref_no = p_or_pref ||'-'|| to_char(p_or_no)
                         WHERE gacc_tran_id =  p_gacc_tran_id;
                    END IF; 

                ELSE
                    --Msg_Alert('The current transaction ID is already printed.', 'E', TRUE);
                    raise_application_error(-20001, 'Geniisys Exception#I#The current transaction ID is already printed. ');
                END IF;
            ELSIF p_edit_or_no = 'N'/* and variables.v_or_flag_p = 'Y'*/ THEN -- variables.v_or_flag_p is useless :p         
                IF v_or_no IS NOT NULL THEN

                    UPDATE giac_order_of_payts
                       SET or_pref_suf = p_or_pref,
                           or_no = p_or_no,
                           or_flag = 'P',
                           user_id = NVL(giis_users_pkg.app_user, USER),--Vincent 08252006
                           last_update = SYSDATE--Vincent 08252006
                           --or_date = sysdate
                     WHERE gacc_tran_id      = p_gacc_tran_id
                       AND gibr_gfun_fund_cd = p_fund_cd
                       AND gibr_branch_cd    = p_branch_cd;


                    IF v_with_pdc = 'Y' THEN 

                        UPDATE giac_pdc_checks
                           SET ref_no = p_or_pref ||'-'|| to_char(p_or_no)
                         WHERE gacc_tran_id =  p_gacc_tran_id;

                    END IF; 
                END IF;
            END IF;
        END IF;
      CLOSE giop;
    END giacs050_ins_upd_GIOP;
    
    /*
   ** Created By:       D.Alcantara
   ** Date Created:     06/17/2012
   ** Reference By:     GIACS050
   ** Description:      debugs
   */
    PROCEDURE upd_gorr_giacs050 (
        p_gacc_tran_id  IN  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref          IN  giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no            IN  giac_doc_sequence.doc_seq_no%TYPE
    ) IS
    BEGIN
        UPDATE giac_or_rel
           SET new_or_pref_suf = p_or_pref,
              new_or_no = p_or_no,
              user_id = NVL(giis_users_pkg.app_user, USER),
              last_update = SYSDATE
         WHERE tran_id = p_gacc_tran_id;
    END upd_gorr_giacs050;    
    
   /*
   ** Created By:   Andrew Robes
   ** Date Created: 3.20.2013
   ** Reference By: GIACS001
   ** Description:  update the collection_amt and gross_amt based on the total amount from giac_collection_dtl
   */
    PROCEDURE update_colln_amt_gross_amt(p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
    IS
      v_collection_amt giac_order_of_payts.collection_amt%TYPE;
      v_gross_amt      giac_order_of_payts.gross_amt%TYPE;
    BEGIN
--      SELECT SUM(amount), SUM(gross_amt)
--        INTO v_collection_amt, v_gross_amt
--        FROM giac_collection_dtl
--       WHERE gacc_tran_id = p_gacc_tran_id;

--        modified codes above by robert 04.11.2013
        SELECT SUM (DECODE (currency_cd,giacp.n ('CURRENCY_CD'), NVL (amount, 0),NVL (fcurrency_amt, 0))),
               SUM (DECODE (currency_cd,giacp.n ('CURRENCY_CD'), NVL (gross_amt, 0),NVL (fc_gross_amt, 0)))
          INTO v_collection_amt,
               v_gross_amt
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_gacc_tran_id;
    
      UPDATE giac_order_of_payts
         SET collection_amt = v_collection_amt,
             gross_amt = v_gross_amt
       WHERE gacc_tran_id = p_gacc_tran_id;       
    END;
    
    FUNCTION get_batch_or_list(
        p_fund_cd            GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd          GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_called_by_upload   VARCHAR2,
        p_upload_query       VARCHAR2
    )
      RETURN batch_or_tab PIPELINED
    IS
        TYPE cur_typ IS REF CURSOR;
        v_row                batch_or_type;
        c                    cur_typ;
        v_query              VARCHAR(32000);
    BEGIN
        v_query := 'SELECT gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd, 
                           or_flag, or_pref_suf, or_no, or_date, payor, particulars  
                      FROM GIAC_ORDER_OF_PAYTS 
                     WHERE gibr_gfun_fund_cd = ''' || p_fund_cd || '''' || 
                     ' AND gibr_branch_cd = ''' || p_branch_cd || '''' ||
                     ' AND or_flag = ''N''' ||
                     ' AND or_no IS NULL ' ||
                     ' AND or_pref_suf IS NULL ' ||
                     ' AND (('''||p_called_by_upload||''' = ''Y'' AND upload_tag = ''Y'' AND gacc_tran_id IN ('/*''*/||p_upload_query||/*''*/')) ' || --Deo [10.06.2016]: removed excess single quoutes to fix ORA-00907
                     ' OR '''||p_called_by_upload||''' = ''N'')' ||
                     ' ORDER BY or_date, payor';
        
        OPEN c FOR v_query;
        
        LOOP
            FETCH c
             INTO v_row.gacc_tran_id, v_row.gibr_gfun_fund_cd, v_row.gibr_branch_cd,
                  v_row.or_flag, v_row.or_pref_suf, v_row.or_no, v_row.or_date, v_row.payor,
                  v_row.particulars;
                  
            v_row.dsp_or_date := TO_CHAR(v_row.or_date, 'mm-dd-yyyy');
          
            EXIT WHEN c%NOTFOUND;
            PIPE ROW (v_row);
        END LOOP;
      
        CLOSE c;
    END;
    
    FUNCTION check_or(
        p_gacc_tran_id      GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2
    IS
        v_or_amt            GIAC_ORDER_OF_PAYTS.gross_amt%TYPE := 0;
        v_op_text_amt       GIAC_OP_TEXT.item_amt%TYPE := 0;
        v_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0;
        v_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE := 0;
    BEGIN
        FOR rec1 IN(SELECT gross_tag,
                           NVL(DECODE(gross_tag, 'Y', gross_amt, 'N', collection_amt, gross_amt), 0) or_amount    
                      FROM GIAC_ORDER_OF_PAYTS
                     WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
            v_or_amt := rec1.or_amount;
        END LOOP;
        
        FOR rec2 IN(SELECT gacc_tran_id, SUM(item_amt) op_amt
                      FROM GIAC_OP_TEXT
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND NVL(or_print_tag,'Y') = 'Y' 
                     GROUP BY gacc_tran_id)
        LOOP
            v_op_text_amt := rec2.op_amt;
        END LOOP;
        
        IF v_or_amt = 0 THEN
            RETURN 'O.R. has zero collection amount.';
        ELSIF v_op_text_amt = 0 THEN
            RETURN 'O.R. preview has zero amount.';
        ELSIF v_or_amt <> v_op_text_amt THEN
            RETURN 'O.R. collection amount is not equal to O.R. preview amount.';
        END IF;
        
        FOR rec3 IN(SELECT gacc_tran_id, SUM(NVL(debit_amt,0)) debit_amt, SUM(NVL(credit_amt,0)) credit_amt
                      FROM GIAC_ACCT_ENTRIES
                     WHERE gacc_tran_id = p_gacc_tran_id
                     GROUP BY gacc_tran_id)
        LOOP
            v_debit_amt := rec3.debit_amt;
            v_credit_amt := rec3.credit_amt;
        END LOOP;
        
        IF v_debit_amt = 0 AND v_credit_amt = 0 THEN
            RETURN 'Zero debit and credit amounts.';
        ELSIF v_debit_amt <> v_credit_amt THEN
            RETURN 'Debit and credit amounts are not equal.';
        END IF;
        
        FOR rec4 IN(SELECT tran_flag
                      FROM giac_acctrans
                     WHERE tran_id = p_gacc_tran_id)
        LOOP
            IF rec4.tran_flag = 'P' THEN 
                RETURN 'This is a posted transaction.';
            ELSIF rec4.tran_flag = 'D' THEN
                RETURN 'This is a deleted transaction.';
            END IF;
        END LOOP;
        
        RETURN 'Y';
    END;
    
    PROCEDURE get_default_vat_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_vat_seq       OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_vat_or_pref   OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    )
    IS
        v_or_pref            GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE;
        v_user_cd            GIAC_DCB_USERS.cashier_cd%TYPE;
        v_min                 GIAC_DOC_SEQUENCE_USER.min_seq_no%TYPE;
        v_max                 GIAC_DOC_SEQUENCE_USER.max_seq_no%TYPE;
        v_or_no              GIAC_DOC_SEQUENCE.doc_seq_no%TYPE;    
        v_flag               VARCHAR2(1);
        v_or_seq_per_user   GIAC_PARAMETERS.param_value_v%TYPE;

        CURSOR chk_spoil (v_spoil NUMBER) IS
               SELECT or_no
                 FROM GIAC_SPOILED_OR
                WHERE or_no >= v_spoil
                  AND nvl(or_pref,'-') = nvl(v_or_pref, nvl(or_pref,'-'))
                  AND fund_cd = p_fund_cd                 
                  AND branch_cd = p_branch_cd
                ORDER BY or_no;
    BEGIN
        FOR p IN(SELECT or_pref_suf
                   FROM GIAC_OR_PREF
                  WHERE branch_cd = p_branch_cd
                    AND or_type IN(SELECT rv_low_value
                                     FROM CG_REF_CODES
                                    WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                      AND rv_meaning = 'VAT'))
        LOOP
            v_or_pref := p.or_pref_suf;
            EXIT;
        END LOOP;
        
        BEGIN
            SELECT param_value_v
              INTO v_or_seq_per_user
              FROM GIAC_PARAMETERS
             WHERE param_name = 'OR_SEQ_PER_USER';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_or_seq_per_user := 'N';
        END;
        
        BEGIN 
            SELECT cashier_cd
              INTO v_user_cd
              FROM GIAC_DCB_USERS
             WHERE gibr_branch_cd = p_branch_cd
               AND gibr_fund_cd = p_fund_cd
               AND dcb_user_id = p_user_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_user_cd := NULL;
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are not allowed to access this module');
        END;
        
        IF v_or_seq_per_user = 'Y' THEN
            BEGIN
                SELECT min_seq_no, max_seq_no
                  INTO v_min, v_max
                  FROM GIAC_DOC_SEQUENCE_USER
                 WHERE doc_code = 'OR'
                   AND branch_cd = p_branch_cd
                   AND user_cd = v_user_cd
                   AND doc_pref = v_or_pref                   
                   AND active_tag = 'Y';
                  
                v_flag := 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_min := 1;
                    v_max := 1;
                    v_flag := 'N';
                    RAISE_APPLICATION_ERROR(20001, 'Geniisys Exception#E#No range of O.R. Number found for VAT OR.');
            END;
        
            BEGIN
                SELECT NVL(MAX(or_no)+1,v_min)
                  INTO p_vat_seq
                  FROM GIAC_ORDER_OF_PAYTS
                 WHERE gibr_gfun_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND NVL(or_pref_suf, '-') = NVL(v_or_pref, NVL(or_pref_suf,'-'))
                   AND or_no BETWEEN v_min AND v_max;
                                    
                IF p_vat_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. Number exceeds maximum sequence number for the booklet.');
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_vat_seq := v_min;
            END;
            
            FOR i IN chk_spoil (p_vat_seq)
            LOOP
                IF i.or_no = p_vat_seq THEN
                    p_vat_seq := p_vat_seq + 1;
                END IF;
                
                IF p_vat_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. Number exceeds maximum sequence number for the booklet.');
                END IF;
            END LOOP;
            
            p_vat_or_pref := v_or_pref;
        ELSE
            BEGIN
                SELECT doc_seq_no
                  INTO v_or_no
                  FROM GIAC_DOC_SEQUENCE
                 WHERE fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND NVL(doc_pref_suf, '-') = nvl(v_or_pref, nvl(doc_pref_suf,'-'))
                   AND doc_name = 'VAT OR';
             
                p_vat_seq := v_or_no + 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_vat_seq := 1;
            END;
            
            FOR i IN chk_spoil(p_vat_seq)
            LOOP
                IF i.or_no = p_vat_seq THEN
                    p_vat_seq := p_vat_seq + 1;
                END IF;
            END LOOP;
        
            p_vat_or_pref := v_or_pref;
        END IF;
    END;
    
    PROCEDURE get_default_non_vat_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_nvat_seq      OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_nvat_or_pref  OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    )
    IS
        v_or_pref           GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE;
        v_user_cd           GIAC_DCB_USERS.cashier_cd%TYPE;
        v_min                 GIAC_DOC_SEQUENCE_USER.min_seq_no%TYPE;
        v_max                 GIAC_DOC_SEQUENCE_USER.max_seq_no%TYPE;
        v_or_no             GIAC_DOC_SEQUENCE.doc_seq_no%TYPE;    
        v_flag               VARCHAR2(1);
        v_or_seq_per_user   GIAC_PARAMETERS.param_value_v%TYPE;
      
        CURSOR chk_spoil(v_spoil NUMBER) IS
               SELECT or_no
                  FROM GIAC_SPOILED_OR
                WHERE or_no >= v_spoil
                  AND NVL(or_pref,'-') = NVL(v_or_pref, NVL(or_pref,'-'))
                  AND fund_cd = p_fund_cd                 
                  AND branch_cd = p_branch_cd
                ORDER BY or_no;
    BEGIN
        FOR p IN(SELECT or_pref_suf
                   FROM GIAC_OR_PREF
                  WHERE branch_cd = p_branch_cd
                    AND or_type IN (SELECT rv_low_value
                                      FROM CG_REF_CODES
                                     WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                       AND UPPER(rv_meaning) = 'NON VAT'))
        LOOP
              v_or_pref := p.or_pref_suf;
            EXIT;
        END LOOP;
        
        BEGIN 
             SELECT cashier_cd
               INTO v_user_cd
               FROM GIAC_DCB_USERS
             WHERE gibr_branch_cd = p_branch_cd
                 AND dcb_user_id = p_user_id;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 v_user_cd := NULL;
                 RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are not allowed to access this module');            
        END;
        
        BEGIN
            SELECT param_value_v
              INTO v_or_seq_per_user
              FROM GIAC_PARAMETERS
             WHERE param_name = 'OR_SEQ_PER_USER';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_or_seq_per_user := 'N';
        END;
        
        IF v_or_seq_per_user = 'Y' THEN
            BEGIN
                SELECT min_seq_no, max_seq_no
                  INTO v_min, v_max
                  FROM GIAC_DOC_SEQUENCE_USER
                 WHERE doc_code = 'OR'
                   AND branch_cd = p_branch_cd
                   AND user_cd = v_user_cd
                   AND doc_pref = v_or_pref
                   AND active_tag = 'Y';

                v_flag := 'Y';
            EXCEPTION
                  WHEN no_data_found THEN
                    v_min := 1;
                    v_max := 1;
                    v_flag := 'N';
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No range of O.R. Number found for NON VAT OR.');
            END;
            
            BEGIN
                SELECT NVL(MAX(or_no)+1,v_min)
                  INTO p_nvat_seq
                  FROM GIAC_ORDER_OF_PAYTS
                 WHERE gibr_gfun_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND nvl(or_pref_suf, '-') = nvl(v_or_pref, nvl(or_pref_suf,'-'))
                   AND or_no BETWEEN v_min AND v_max;

                IF p_nvat_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. exceeds maximum sequence number for the booklet.');
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_nvat_seq := v_min;
            END;
            
            FOR i IN chk_spoil (p_nvat_seq) LOOP
                IF i.or_no = p_nvat_seq THEN
                    p_nvat_seq := p_nvat_seq + 1;
                END IF;
                
                IF p_nvat_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. Number exceeds maximum sequence number for the booklet.');
                END IF;
            END LOOP;
            
            p_nvat_or_pref := v_or_pref;
        ELSE
            BEGIN
                SELECT doc_seq_no
                  INTO v_or_no
                  FROM GIAC_DOC_SEQUENCE
                 WHERE fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND NVL(doc_pref_suf, '-') = NVL(v_or_pref, NVL(doc_pref_suf,'-'))
                   AND doc_name = 'NON VAT OR';
                   
                p_nvat_or_pref := v_or_pref;
                p_nvat_seq := v_or_no + 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN         
                    p_nvat_seq := 1;
            END;
        
            FOR i IN chk_spoil(p_nvat_seq)
            LOOP
                IF i.or_no = p_nvat_seq THEN
                    p_nvat_seq := p_nvat_seq + 1;
                END IF;
            END LOOP;
                 
            p_nvat_or_pref := v_or_pref;
        END IF;
    END;
    
    PROCEDURE get_default_other_or(
        p_fund_cd       IN  GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd     IN  GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id       IN  GIIS_USERS.user_id%TYPE,
        p_other_seq     OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_other_or_pref OUT GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE
    )
    IS
        v_or_pref            GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE;
        v_user_cd            GIAC_DCB_USERS.cashier_cd%TYPE;
        v_min                 GIAC_DOC_SEQUENCE_USER.min_seq_no%TYPE;
        v_max                 GIAC_DOC_SEQUENCE_USER.max_seq_no%TYPE;
        v_or_no              GIAC_DOC_SEQUENCE.doc_seq_no%TYPE;    
        v_flag               VARCHAR2(1);
        v_or_seq_per_user   GIAC_PARAMETERS.param_value_v%TYPE;

        CURSOR chk_spoil(v_spoil NUMBER) IS
               SELECT or_no
                 FROM GIAC_SPOILED_OR
                WHERE or_no >= v_spoil
                  AND NVL(or_pref,'-') = NVL(v_or_pref, NVL(or_pref,'-'))
                  AND fund_cd = p_fund_cd                 
                  AND branch_cd = p_branch_cd
                ORDER BY or_no;
    BEGIN
        FOR p IN(SELECT or_pref_suf
                   FROM GIAC_OR_PREF
                  WHERE branch_cd = p_branch_cd
                    AND or_type IN(SELECT rv_low_value
                                     FROM cg_ref_codes
                                    WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                      AND UPPER(rv_meaning) = 'MISCELLANEOUS'))
        LOOP
              v_or_pref := p.or_pref_suf;
            EXIT;
        END LOOP;       
        
        IF v_or_pref IS NULL THEN
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#There is no maintained Miscellaneous OR Prefix for branch '||p_branch_cd||
                                              '. Please maintain a prefix in the OR Prefix Maintainance module first.');
        END IF;
        
        BEGIN 
             SELECT cashier_cd
               INTO v_user_cd
               FROM GIAC_DCB_USERS
             WHERE gibr_branch_cd = p_branch_cd
                 AND dcb_user_id = p_user_id;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 v_user_cd := NULL;
                 RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are not allowed to access this module');            
        END;
        
        BEGIN
            SELECT param_value_v
              INTO v_or_seq_per_user
              FROM GIAC_PARAMETERS
             WHERE param_name = 'OR_SEQ_PER_USER';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_or_seq_per_user := 'N';
        END;
        
        IF v_or_seq_per_user = 'Y' THEN
            BEGIN
                SELECT min_seq_no, max_seq_no
                  INTO v_min, v_max
                  FROM GIAC_DOC_SEQUENCE_USER
                 WHERE doc_code = 'OR'
                   AND branch_cd = p_branch_cd
                     AND user_cd = v_user_cd
                    AND doc_pref = v_or_pref                   
                   AND active_tag = 'Y';
              
                v_flag := 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_min := 1;
                    v_max := 1;
                    v_flag := 'N';
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No range of O.R. Number found for Miscellaneous OR.');
            END;
            
            BEGIN
                SELECT NVL(MAX(or_no)+1,v_min)
                  INTO p_other_seq
                  FROM GIAC_ORDER_OF_PAYTS
                 WHERE gibr_gfun_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND NVL(or_pref_suf, '-') = NVL(v_or_pref, NVL(or_pref_suf,'-'))
                   AND or_no BETWEEN v_min AND v_max;
        
                IF p_other_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. Number exceeds maximum sequence number for the booklet.');
                END IF;
               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_other_seq := v_min;
               END;
        
            FOR i IN chk_spoil(p_other_seq) LOOP
                 IF i.or_no = p_other_seq THEN
                    p_other_seq := p_other_seq + 1;
                END IF;
                
                IF p_other_seq > v_max and v_flag = 'Y' THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#O.R. Number exceeds maximum sequence number for the booklet.');
                END IF;
            END LOOP;     
                     
            p_other_or_pref := v_or_pref;
        ELSE
            BEGIN
                SELECT doc_seq_no
                  INTO v_or_no
                  FROM GIAC_DOC_SEQUENCE
                 WHERE fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND NVL(doc_pref_suf, '-') = NVL(v_or_pref, NVL(doc_pref_suf,'-'))
                   AND UPPER(doc_name) = 'MISC_OR';
             
                p_other_seq := v_or_no + 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_other_seq := 1;
            END;
        
            FOR i IN chk_spoil(p_other_seq) LOOP
                IF i.or_no = p_other_seq THEN
                    p_other_seq := p_other_seq + 1;
                END IF;
            END LOOP;

            p_other_or_pref := v_or_pref;
        END IF;
    END;
    
   FUNCTION check_apdc_payt_dtl(
      p_gacc_tran_id       GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists             VARCHAR2(1) := 'N';
   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM GIAC_APDC_PAYT_DTL
       WHERE gacc_tran_id = p_gacc_tran_id
         AND ROWNUM = 1;
         
      RETURN v_exists;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN v_exists;
   END;
   
   FUNCTION get_cancelled_or_list(
        p_user_id            VARCHAR2
   )
   RETURN cancelled_or_tab PIPELINED
   IS
        v_list cancelled_or_type;
   BEGIN
        FOR i IN(
            SELECT or_pref_suf,or_no, payor, particulars, 
                   address_1, address_2, address_3, or_date,
                   or_tag, tin, gacc_tran_id
              FROM GIAC_ORDER_OF_PAYTS a 
             WHERE or_flag = 'C'
               AND or_no IS NOT NULL
               AND ((SELECT access_tag
                      FROM giis_user_modules
                     WHERE userid = NVL (p_user_id, USER)   
                       AND module_id = 'GIACS001'
                       AND tran_cd IN (
                              SELECT b.tran_cd         
                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                               WHERE a.user_id = b.userid
                                 AND a.user_id = NVL (p_user_id, USER)
                                 AND b.iss_cd = a.gibr_branch_cd
                                 AND b.tran_cd = c.tran_cd
                                 AND c.module_id = 'GIACS001')) = 1
                 OR (SELECT access_tag
                      FROM giis_user_grp_modules
                     WHERE module_id = 'GIACS001'
                       AND (user_grp, tran_cd) IN (
                              SELECT a.user_grp, b.tran_cd
                                FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                               WHERE a.user_grp = b.user_grp
                                 AND a.user_id = NVL (p_user_id, USER)
                                 AND b.iss_cd = a.gibr_branch_cd
                                 AND b.tran_cd = c.tran_cd
                                 AND c.module_id = 'GIACS001')) = 1
               )
               AND NOT EXISTS (SELECT '1'
                                 FROM GIAC_OR_REL b
                                WHERE b.old_tran_id = a.gacc_tran_id)
        )
        LOOP
            v_list.or_pref_suf  := i.or_pref_suf;
            v_list.or_no        := i.or_no;      
            v_list.payor        := i.payor;      
            v_list.particulars  := i.particulars;
            v_list.address_1    := i.address_1;
            v_list.address_2    := i.address_2; 
            v_list.address_3    := i.address_3; 
            v_list.or_date      := i.or_date;  
            v_list.or_tag       := i.or_tag;    
            v_list.tin          := i.tin;   
            v_list.gacc_tran_id := i.gacc_tran_id;  
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;                    
   END; 
   
   FUNCTION get_cncl_colln_breakdown(
        p_gacc_tran_id      VARCHAR2
   )
   RETURN cncl_colln_breakdown_tab PIPELINED
   IS
        v_list      cncl_colln_breakdown_type;
   BEGIN
        FOR x IN (
            SELECT item_no, pay_mode, bank_cd, check_class, check_no, check_date, amount,
                   currency_cd, currency_rt, fcurrency_amt, dcb_bank_cd, dcb_bank_acct_cd,
                   gross_amt, commission_amt, vat_amt, 
                   fc_gross_amt, fc_comm_amt, fc_tax_amt
              FROM giac_collection_dtl
             WHERE gacc_tran_id = p_gacc_tran_id
        )
        LOOP     
            v_list.item_no           := x.item_no;         
            v_list.pay_mode          := x.pay_mode;
            v_list.bank_cd           := x.bank_cd;         
            v_list.check_class       := x.check_class;     
            v_list.check_no          := x.check_no;        
            v_list.check_date        := x.check_date;      
            v_list.amount            := x.amount;          
            v_list.currency_cd       := x.currency_cd;
            v_list.currency_rt       := x.currency_rt;
            v_list.fcurrency_amt     := x.fcurrency_amt;   
            v_list.dcb_bank_cd       := x.dcb_bank_cd;       
            v_list.dcb_bank_acct_cd  := x.dcb_bank_acct_cd;
            v_list.gross_amt         := x.gross_amt;     
            v_list.commission_amt    := x.commission_amt;
            v_list.vat_amt           := x.vat_amt;       
            v_list.fc_gross_amt      := x.fc_gross_amt;  
            v_list.fc_comm_amt       := x.fc_comm_amt;    
            v_list.fc_tax_amt        := x.fc_tax_amt;    
                                                   
            FOR i IN(SELECT bank_sname
                    FROM giac_banks
                   WHERE bank_cd = x.bank_cd)
            LOOP
                    v_list.bank_sname := i.bank_sname; 
            END LOOP;
                            
            FOR f IN(SELECT short_name
                    FROM giis_currency
                   WHERE main_currency_cd = x.currency_cd)
            LOOP
                    v_list.short_name := f.short_name; 
            END LOOP;
            PIPE ROW(v_list);
        END LOOP;
    
    RETURN;
   END;
   
   
   FUNCTION get_giac_or_rel(
        p_gacc_tran_id      VARCHAR2
   )
   RETURN giac_or_rel_tab PIPELINED
   IS
        v_list  giac_or_rel%ROWTYPE;
   BEGIN
        FOR t IN(
            SELECT * FROM GIAC_OR_REL
             WHERE tran_id = p_gacc_tran_id
                OR old_tran_id = p_gacc_tran_id -- Added by Jerome Bautista 11.25.2015 SR 20817
        )
        LOOP
            v_list.tran_id          := t.tran_id;        
            v_list.new_or_date      := t.new_or_date;    
            v_list.old_tran_id      := t.old_tran_id;    
            v_list.old_or_no        := t.old_or_no;      
            v_list.old_or_date      := t.old_or_date;    
            v_list.new_or_pref_suf  := t.new_or_pref_suf;
            v_list.new_or_no        := t.new_or_no;      
            v_list.new_or_tag       := t.new_or_tag;     
            v_list.old_or_pref_suf  := t.old_or_pref_suf;
            v_list.old_or_tag       := t.old_or_tag;     
            v_list.user_id          := t.user_id;        
            v_list.last_update      := t.last_update;    
                
            PIPE ROW(v_list);
        END LOOP;
        RETURN;        
   END;
   
   PROCEDURE save_giac_or_rel(
        p_tran_id           giac_or_rel.tran_id%TYPE,       
        p_new_or_tag        giac_or_rel.new_or_tag%TYPE,     
        p_old_tran_id       giac_or_rel.old_tran_id%TYPE,   
        p_old_or_date       giac_or_rel.old_or_date%TYPE,    
        p_old_or_pref_suf   giac_or_rel.old_or_pref_suf%TYPE,
        p_old_or_no         giac_or_rel.old_or_no%TYPE,      
        p_old_or_tag        giac_or_rel.old_or_tag%TYPE,     
        p_user_id           giac_or_rel.user_id%TYPE        
   )
   IS
        v_gacc_tran_id      giac_or_rel.tran_id%TYPE;
   BEGIN
      IF p_tran_id = 0 THEN
         SELECT acctran_tran_id_s.NEXTVAL
           INTO v_gacc_tran_id
           FROM DUAL;
      ELSE
        v_gacc_tran_id := p_tran_id;
      END IF;
      
      UPDATE giac_order_of_payts
         SET or_flag = 'R'
       WHERE gacc_tran_id = p_old_tran_id;

      MERGE INTO giac_or_rel
         USING DUAL
         ON (tran_id = v_gacc_tran_id)
         WHEN NOT MATCHED THEN
            INSERT (tran_id, new_or_date, old_tran_id, old_or_no,
                old_or_date, new_or_tag,
                old_or_pref_suf, old_or_tag, user_id, last_update --Removed new_or_pref_suf and new_or_no columns. - Jerome Bautista 11.26.2015 SR 20817
            )
            VALUES (v_gacc_tran_id, SYSDATE, p_old_tran_id, p_old_or_no,
                p_old_or_date, p_new_or_tag, --Removed new_or_pref_suf and new_or_no values. - Jerome Bautista 11.26.2015 SR 20817
                p_old_or_pref_suf, p_old_or_tag, p_user_id, SYSDATE
            )
         WHEN MATCHED THEN
            UPDATE
               SET new_or_date      = SYSDATE,
                   old_tran_id      = p_old_tran_id,
                   old_or_no        = p_old_or_no,
                   old_or_date      = p_old_or_date,
                   --new_or_pref_suf  = '', -- Commented out by Jerome Bautista 11.26.2015 SR 20817
                   --new_or_no        = '', -- Commented out by Jerome Bautista 11.26.2015 SR 20817
                   new_or_tag       = p_new_or_tag,
                   old_or_pref_suf  = p_old_or_pref_suf,
                   old_or_tag       = p_old_or_tag,
                   user_id          = p_user_id,
                   last_update      = SYSDATE
            ;
   END;
    
END giac_order_of_payts_pkg; 
/


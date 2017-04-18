CREATE OR REPLACE PACKAGE BODY CPI.giac_collection_dtl_pkg
AS
   PROCEDURE set_giac_collection_dtl (
      v_gacc_tran_id     giac_collection_dtl.gacc_tran_id%TYPE,
      v_item_no          giac_collection_dtl.item_no%TYPE,
      v_currency_cd      giac_collection_dtl.currency_cd%TYPE,
      v_currency_rt      giac_collection_dtl.currency_rt%TYPE,
      v_pay_mode         giac_collection_dtl.pay_mode%TYPE,
      v_amount           giac_collection_dtl.amount%TYPE,
      v_check_date       giac_collection_dtl.check_date%TYPE,
      v_check_no         giac_collection_dtl.check_no%TYPE,
      v_particulars      giac_collection_dtl.particulars%TYPE,
      v_bank_cd          giac_collection_dtl.bank_cd%TYPE,
      v_check_class      giac_collection_dtl.check_class%TYPE,
      v_fcurrency_amt    giac_collection_dtl.fcurrency_amt%TYPE,
      v_gross_amt        giac_collection_dtl.gross_amt%TYPE,
      v_commission_amt   giac_collection_dtl.commission_amt%TYPE,
      v_vat_amt          giac_collection_dtl.vat_amt%TYPE,
      v_fc_gross_amt     giac_collection_dtl.fc_gross_amt%TYPE,
      v_fc_comm_amt      giac_collection_dtl.fc_comm_amt%TYPE,
      v_fc_tax_amt       giac_collection_dtl.fc_tax_amt%TYPE,
      v_dcb_bank_cd      giac_collection_dtl.dcb_bank_cd%TYPE,
      v_dcb_bank_acct_cd giac_collection_dtl.dcb_bank_acct_cd%TYPE,
      v_due_dcb_no       giac_collection_dtl.due_dcb_no%TYPE,
      v_due_dcb_date     giac_collection_dtl.due_dcb_date%TYPE,
      v_cm_tran_id       giac_collection_dtl.cm_tran_id%TYPE  -- added by: Nica 05.15.2013 AC-SPECS-2012-155 
   )
   IS
      v_chk   VARCHAR2 (3) := v_check_class;
   BEGIN
        --comment out by john dolon 09.15.2014
      /*BEGIN
         IF v_check_class IS NULL OR v_check_class = '-'
         THEN
            SELECT param_value_v
              INTO v_chk
              FROM giac_parameters
             WHERE param_name = 'DEFAULT_CHECK_CLASS';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;*/

      MERGE INTO giac_collection_dtl
         USING DUAL
         ON (gacc_tran_id = v_gacc_tran_id AND item_no = v_item_no)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, item_no, currency_cd, currency_rt, pay_mode,
                    amount, check_date, check_no, particulars, bank_cd,
                    check_class, fcurrency_amt, gross_amt, commission_amt,
                    vat_amt, fc_gross_amt, fc_comm_amt, fc_tax_amt, dcb_bank_cd, 
                    dcb_bank_acct_cd, user_id, last_update, due_dcb_no,
                    due_dcb_date, cm_tran_id) -- cm_tran_id added by: Nica 05.15.2013 AC-SPECS-2012-155 
            VALUES (v_gacc_tran_id, v_item_no, v_currency_cd, v_currency_rt,
                    v_pay_mode, v_amount, v_check_date, v_check_no,
                    v_particulars, v_bank_cd, v_chk, v_fcurrency_amt,
                    v_gross_amt, v_commission_amt, v_vat_amt, v_fc_gross_amt,
                    v_fc_comm_amt, v_fc_tax_amt, v_dcb_bank_cd, v_dcb_bank_acct_cd, NVL (giis_users_pkg.app_user, USER), SYSDATE,v_due_dcb_no,
                    v_due_dcb_date, v_cm_tran_id)
         WHEN MATCHED THEN
            UPDATE
               SET currency_cd = v_currency_cd, currency_rt = v_currency_rt,
                   pay_mode = v_pay_mode, amount = v_amount,
                   check_date = v_check_date, check_no = v_check_no,
                   particulars = v_particulars, bank_cd = v_bank_cd,
                   check_class = v_chk, fcurrency_amt = v_fcurrency_amt,
                   gross_amt = v_gross_amt, commission_amt = v_commission_amt,
                   vat_amt = v_vat_amt, fc_gross_amt = v_fc_gross_amt,
                   fc_comm_amt = v_fc_comm_amt, fc_tax_amt = v_fc_tax_amt, dcb_bank_cd = v_dcb_bank_cd,
                   dcb_bank_acct_cd = v_dcb_bank_acct_cd, user_id = NVL (giis_users_pkg.app_user, USER), last_update = SYSDATE,
                   due_dcb_no = v_due_dcb_no,due_dcb_date =v_due_dcb_date,
                   cm_tran_id = v_cm_tran_id 
            ;
   END set_giac_collection_dtl;
   
   PROCEDURE delete_giac_collection_dtl(
          v_gacc_tran_id        giac_collection_dtl.gacc_tran_id%TYPE,
       v_item_no                giac_collection_dtl.item_no%TYPE
   )
   IS
      v_pay_mode    giac_collection_dtl.pay_mode%type; --mikel 09.09.2015; FGIC 20143
   BEGIN
      --start mikel 09.09.2015; FGIC 20143
      BEGIN
        SELECT DISTINCT pay_mode
          INTO v_pay_mode
          FROM giac_collection_dtl
         WHERE gacc_tran_id = v_gacc_tran_id;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            NULL;
        WHEN NO_DATA_FOUND THEN
            NULL;
      END;
      
      IF v_pay_mode = 'RCM' THEN               
          DELETE FROM GIAC_OP_TEXT
                WHERE gacc_tran_id = v_gacc_tran_id;
                  --AND item_gen_type = v_gen_type;
      END IF;
      --end mikel 

      DELETE FROM giac_collection_dtl
      WHERE gacc_tran_id = v_gacc_tran_id
      AND item_no = v_item_no;
   END delete_giac_collection_dtl;
   
   /*
  **  Created by   :  Emman
  **  Date Created :  July 22, 2010
  **  Reference By : (GIACS 004)
  **  Description  : Retrives GIAC Colleciton Dtl of specified transaction ID
  **                      Add other columns when needed 
  */  
   FUNCTION get_giac_collection_dtl (
         p_tran_id      giac_collection_dtl.gacc_tran_id%TYPE
   ) RETURN giac_collection_dtl_tab PIPELINED
   IS
        v_collection_dtl             giac_collection_dtl_type;
   BEGIN
      FOR i IN (
       SELECT SUM (NVL (fc_gross_amt, (gross_amt / currency_rt))) fc_gross_amt, --replaced by john 7.3.2015 --SUM(NVL((gross_amt/currency_rt),fc_gross_amt)) fc_gross_amt,
          SUM (NVL (fcurrency_amt, (amount / currency_rt))) fcurrency_amt, --replaced by john 7.21.2015 --SUM (amount / currency_rt) fcurrency_amt,
          NVL (SUM (gross_amt), 0) gross_amt, NVL (SUM (amount), 0) amount
         FROM giac_collection_dtl
        WHERE gacc_tran_id = p_tran_id
        GROUP BY gacc_tran_id
     )
     LOOP
        v_collection_dtl.fc_gross_amt       := i.fc_gross_amt;
        v_collection_dtl.fcurrency_amt      := i.fcurrency_amt;
        v_collection_dtl.gross_amt          := i.gross_amt;
        v_collection_dtl.amount             := i.amount;
        PIPE ROW (v_collection_dtl);
     END LOOP;
   END get_giac_collection_dtl;
   
   
    
  /*
  **  Created by   :  dennis
  **  Date Created :  Sept. 14, 2010
  **  Reference    :  GIACS001
  **  Description  :  Retrives GIAC Collection Details of specified gaccTranID 
  */ 
   
   FUNCTION get_giac_colln_dtl (
         p_tran_id      giac_collection_dtl.gacc_tran_id%TYPE
   ) RETURN giac_colln_dtl_tab PIPELINED
   IS
        v_colln_dtl             giac_colln_dtl_type;
   BEGIN
     FOR i IN (SELECT DISTINCT item_no item_num, A.*, d.short_name,
                    (SELECT DISTINCT y.bank_name
                        FROM    giac_collection_dtl  x,
                                giac_banks           y
                       WHERE    y.bank_cd = A.bank_cd
                       AND      x.item_no = A.item_no
                       AND      A.gacc_tran_id = p_tran_id) bank_name,
                    (SELECT DISTINCT y.bank_name
                        FROM    giac_collection_dtl  x,
                                giac_banks           y
                       WHERE    y.bank_cd = A.dcb_bank_cd
                       AND      x.item_no = A.item_no
                       AND      A.gacc_tran_id = p_tran_id) dcb_bank_name
              FROM giac_collection_dtl  A,
                   giac_banks           b,
                   giac_bank_accounts   c,
                   giis_currency        d
             WHERE A.gacc_tran_id = p_tran_id
               AND A.dcb_bank_cd = c.bank_cd(+) -- added (+) to handle records with no dcb_bank_cd or dcb_bank_acct_cd
               AND A.dcb_bank_acct_cd = c.bank_acct_cd(+) -- Nica 06.15.2013
               AND d.main_currency_cd = A.currency_cd
             ORDER BY item_num)
     LOOP
         IF i.pay_mode = 'PDC' THEN
            BEGIN
                SELECT item_id
                  INTO v_colln_dtl.item_id
                  FROM giac_pdc_checks
                 WHERE gacc_tran_id = p_tran_id
                   AND bank_cd = i.bank_cd
                   AND check_no = i.check_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_colln_dtl.item_id := '';
            END;
        END IF;
        v_colln_dtl.item_no               := i.item_no;
        v_colln_dtl.currency_cd         := i.currency_cd;
        v_colln_dtl.currency_rt            := i.currency_rt;
        v_colln_dtl.pay_mode            := i.pay_mode;
        v_colln_dtl.amount                := i.amount;
        v_colln_dtl.check_date            := i.check_date;
        v_colln_dtl.check_no            := i.check_no;
        v_colln_dtl.particulars            := i.particulars;
        v_colln_dtl.bank_cd                := i.bank_cd;
        v_colln_dtl.check_class            := i.check_class;
        v_colln_dtl.fcurrency_amt       := i.fcurrency_amt;
        v_colln_dtl.gross_amt            := i.gross_amt;
        v_colln_dtl.intm_no                := i.intm_no;
        v_colln_dtl.commission_amt      := i.commission_amt;
        v_colln_dtl.vat_amt                := i.vat_amt;
        v_colln_dtl.fc_gross_amt        := i.fc_gross_amt;
        v_colln_dtl.fc_comm_amt            := i.fc_comm_amt;
        v_colln_dtl.fc_tax_amt            := i.fc_tax_amt;
        v_colln_dtl.bank_name            := i.bank_name;
        v_colln_dtl.dcb_bank_name       := i.dcb_bank_name;
        v_colln_dtl.currency            := i.short_name;
        v_colln_dtl.dcb_bank_cd            := i.dcb_bank_cd;
        v_colln_dtl.dcb_bank_acct_cd    := i.dcb_bank_acct_cd;
        v_colln_dtl.cm_tran_id          := i.cm_tran_id;
        v_colln_dtl.pdc_id              := i.pdc_id; --added by john 6.3.2015
        PIPE ROW (v_colln_dtl);
     END LOOP;
   END get_giac_colln_dtl;
   
   
   FUNCTION get_giac_collection_dtl_rep (   --Added by Alfred 03/04/2011
      p_cp_check_title         giac_collection_dtl.check_no%TYPE,
      p_cp_credit_title         giac_collection_dtl.check_no%TYPE,
      p_gross_tag               GIAC_ORDER_OF_PAYTS.GROSS_TAG%TYPE,
      p_cp_sum                  varchar2,
      p_tran_id                   giac_collection_dtl.gacc_tran_id%TYPE
   )
      RETURN giac_colln_dtl_rep_tab PIPELINED
      IS
      v_giac_collection_dtl     giac_colln_dtl_rep_type;
      BEGIN
            
         BEGIN
            
            FOR i IN (SELECT A.gacc_tran_id, 
                                      A.bank_cd, 
                                      DECODE(A.PAY_MODE,     'CA', ' ', 
                                      'CHK', DECODE(p_cp_check_title, 'Y', 'Various Check', Check_no),                           
                                      'PDC', DECODE('N', 'Y', 'Various CHECK',Check_no),
                                      'CM',  DECODE(p_cp_credit_title,'Y', 'Various C.M.', 'CREDIT MEMO'),
                                      'CMI',check_no 
                                      ) check_no,
                                      A.check_date ,
                                      DECODE(p_gross_tag, 'Y', DECODE(NVL(A.currency_cd,1), 1, A.gross_amt, 
                                      A.fc_gross_amt),DECODE(NVL(A.currency_cd,1),1, A.amount, A.fcurrency_amt))  amount,
                                      A.pay_mode,
                                      A.amount net_amount,
                                      A.commission_amt
                            FROM giac_collection_dtl  A, giac_banks b
                          WHERE p_cp_sum = 'N' 
                              AND A.gacc_tran_id = NVL(p_tran_id, A.gacc_tran_id)
                              --AND A.bank_cd = b.bank_cd
                          ORDER BY  A.pay_mode)
                          

          LOOP
             v_giac_collection_dtl.gacc_tran_id := i.gacc_tran_id;
             v_giac_collection_dtl.bank_cd := i.bank_cd;
             v_giac_collection_dtl.bank_name := GIAC_BANKS_DETAILS_PKG.cf_bank_snameformula(i.bank_cd, i.pay_mode);
             v_giac_collection_dtl.check_no := i.check_no;
             v_giac_collection_dtl.check_date := i.check_date;
             v_giac_collection_dtl.gross_amt := i.amount;
             v_giac_collection_dtl.pay_mode := i.pay_mode;
             v_giac_collection_dtl.amount := i.net_amount;
             v_giac_collection_dtl.commission_amt := i.commission_amt;
             v_giac_collection_dtl.COUNT_PAYMODE_CHK := COUNT_PAYMODE_CHK(P_TRAN_ID);         
          END LOOP;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
                IF v_giac_collection_dtl.pay_mode = 'CA' THEN
                     v_giac_collection_dtl.bank_name := 'CASH';    
                ELSIF v_giac_collection_dtl.pay_mode = 'CMI' THEN
                     v_giac_collection_dtl.bank_name := 'CREDIT MEMO (I)';
                ELSE
                  v_giac_collection_dtl.bank_name := NULL;
                END IF;    
      
      END;
      PIPE ROW (v_giac_collection_dtl);
      RETURN;
   END get_giac_collection_dtl_rep;
   
   PROCEDURE insert_giac_pdc_checks(
        p_rec   giac_pdc_checks%ROWTYPE
   )
   IS
        v_item_id       NUMBER(8);
   BEGIN
        MERGE INTO giac_pdc_checks
         USING DUAL
         ON (item_id = p_rec.item_id)
         WHEN NOT MATCHED THEN
             INSERT (item_id, gacc_tran_id, bank_cd,
                     check_no, check_date, amount,
                     currency_cd, currency_rt, fcurrency_amt,
                     user_id, last_update, particulars, item_no,
                     ref_no, check_flag, gfun_fund_cd, gibr_branch_cd
                    )
             VALUES (PDC_ITEM_ID_S.nextval, p_rec.gacc_tran_id, p_rec.bank_cd,
                     p_rec.check_no, p_rec.check_date, p_rec.amount,
                     p_rec.currency_cd, p_rec.currency_rt, p_rec.fcurrency_amt,
                     p_rec.user_id, SYSDATE, p_rec.particulars, p_rec.item_no,
                     p_rec.ref_no, 'N', p_rec.gfun_fund_cd, p_rec.gibr_branch_cd
                    )
         WHEN MATCHED THEN
            UPDATE
               SET bank_cd = p_rec.bank_cd, check_no = p_rec.check_no,
                   check_date = p_rec.check_date, amount = p_rec.amount,
                   currency_cd = p_rec.currency_cd, currency_rt = p_rec.currency_rt, 
                   fcurrency_amt = p_rec.fcurrency_amt, user_id = p_rec.user_id, 
                   last_update = SYSDATE, particulars = p_rec.particulars, 
                   item_no = p_rec.item_no, ref_no = p_rec.ref_no, 
                   gfun_fund_cd = p_rec.gfun_fund_cd, gibr_branch_cd = p_rec.gibr_branch_cd;
                   
   END;      
   
   PROCEDURE delete_giac_pdc_checks(
         p_item_id        giac_pdc_checks.item_id%TYPE
   )
   IS
   BEGIN
        DELETE FROM giac_pdc_checks
          WHERE item_id = p_item_id;
          
   END delete_giac_pdc_checks;
   FUNCTION GET_GIACS035_PAY_MODE_LOV( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_PAY_MODE_LOV - Start
        P_SEARCH                    VARCHAR2,
        P_GIBR_BRANCH_CD            GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE,
        P_GFUN_FUND_CD              GIAC_ORDER_OF_PAYTS.GIBR_GFUN_FUND_CD%TYPE,
        P_DSP_DCB_DATE              VARCHAR2,
        P_DCB_NO                    GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE
   ) 
      RETURN GIACS035_PAY_MODE_LOV_TAB PIPELINED
   IS
      V_LIST GIACS035_PAY_MODE_LOV_TYPE;
   BEGIN
        FOR I IN (SELECT DISTINCT C.PAY_MODE, A.RV_MEANING
                    FROM CG_REF_CODES A, GIAC_ORDER_OF_PAYTS B, GIAC_COLLECTION_DTL C 
                   WHERE C.GACC_TRAN_ID = B.GACC_TRAN_ID 
                     AND ((B.DCB_NO = P_DCB_NO AND NVL(WITH_PDC,'N') <> 'Y') OR (C.DUE_DCB_NO = P_DCB_NO AND WITH_PDC = 'Y'))                      
                     AND ((TO_CHAR(B.OR_DATE,'MM-DD-RRRR') = TO_CHAR(TO_DATE(P_DSP_DCB_DATE,'MM-DD-RRRR'),'MM-DD-RRRR') AND NVL(WITH_PDC,'N') <> 'Y') OR (TO_CHAR(C.DUE_DCB_DATE,'MM-DD-RRRR') = TO_CHAR(TO_DATE(P_DSP_DCB_DATE,'MM-DD-RRRR'),'MM-DD-RRRR') AND WITH_PDC = 'Y')) 
                     AND B.GIBR_BRANCH_CD = P_GIBR_BRANCH_CD
                     AND B.GIBR_GFUN_FUND_CD = P_GFUN_FUND_CD
                     AND ((B.OR_FLAG = 'P') OR (B.OR_FLAG = 'C' AND NVL(TO_CHAR(B.CANCEL_DATE, 'MM-DD-YYYY'), '-') <> TO_CHAR(B.OR_DATE, 'MM-DD-YYYY'))) 
                     AND C.PAY_MODE = A.RV_LOW_VALUE 
                     AND A.RV_DOMAIN = 'GIAC_DCB_BANK_DEP.PAY_MODE'
                     AND C.PAY_MODE LIKE UPPER(P_SEARCH)
        )
        LOOP
            V_LIST.PAY_MODE               := I.PAY_MODE;
            V_LIST.RV_MEANING             := I.RV_MEANING;      
        
            PIPE ROW(V_LIST);
        END LOOP;        
        RETURN;   
   END;  -- dren 07.16.2015 : SR 0017729 - Added GIACS035_PAY_MODE_LOV - End     
   
END giac_collection_dtl_pkg;
/
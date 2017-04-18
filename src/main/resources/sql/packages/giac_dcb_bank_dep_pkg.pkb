CREATE OR REPLACE PACKAGE BODY CPI.giac_dcb_bank_dep_pkg
AS

  FUNCTION get_gdbd_list(p_gacc_tran_id            GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE)
    RETURN gdbd_list_tab PIPELINED
  IS
    v_gdbd_list             gdbd_list_type;
  BEGIN
    FOR i IN (SELECT gdbd.gacc_tran_id, gdbd.fund_cd, gdbd.branch_cd, gdbd.dcb_year,
                   gdbd.dcb_no, gdbd.dcb_date, gdbd.item_no, gdbd.bank_cd,
                   gdbd.bank_acct_cd, gdbd.bank_cd || '-' || gdbd.bank_acct_cd bank_acct,
                   gdbd.pay_mode, gdbd.amount, gdbd.currency_cd,
                   gcur.short_name dsp_curr_sname, gdbd.foreign_curr_amt,
                   gdbd.currency_rt, gdbd.old_dep_amt, gdbd.adj_amt,
                   gbnk.bank_name dsp_bank_name, gbac.bank_acct_no dsp_bank_acct_no,
                   gdbd.remarks
              FROM GIAC_DCB_BANK_DEP gdbd, GIIS_CURRENCY gcur, GIAC_BANKS gbnk, GIAC_BANK_ACCOUNTS gbac
             WHERE gdbd.gacc_tran_id = p_gacc_tran_id
               AND gdbd.currency_cd = gcur.main_currency_cd (+)
               AND gdbd.bank_cd = gbnk.bank_cd (+)
               AND gdbd.bank_cd = gbac.bank_cd (+)
               AND gdbd.bank_acct_cd = gbac.bank_acct_cd (+))
    LOOP
       v_gdbd_list.gacc_tran_id                       := i.gacc_tran_id;
       v_gdbd_list.fund_cd                        := i.fund_cd;
       v_gdbd_list.branch_cd                    := i.branch_cd;
       v_gdbd_list.dcb_year                        := i.dcb_year;
       v_gdbd_list.dcb_no                        := i.dcb_no;
       v_gdbd_list.dcb_date                        := i.dcb_date;
       v_gdbd_list.item_no                        := i.item_no;
       v_gdbd_list.bank_cd                        := i.bank_cd;
       v_gdbd_list.bank_acct_cd                    := i.bank_acct_cd;
       v_gdbd_list.bank_acct                    := i.bank_acct;
       v_gdbd_list.pay_mode                        := i.pay_mode;
       v_gdbd_list.amount                        := i.amount;
       v_gdbd_list.currency_cd                    := i.currency_cd;
       v_gdbd_list.dsp_curr_sname                := i.dsp_curr_sname;
       v_gdbd_list.foreign_curr_amt                := i.foreign_curr_amt;
       v_gdbd_list.currency_rt                    := i.currency_rt;
       v_gdbd_list.old_dep_amt                    := i.old_dep_amt;
       v_gdbd_list.adj_amt                        := i.adj_amt;
       v_gdbd_list.dsp_bank_name                := i.dsp_bank_name;
       v_gdbd_list.dsp_bank_acct_no                := i.dsp_bank_acct_no;
       v_gdbd_list.remarks                        := i.remarks;
    
       PIPE ROW (v_gdbd_list);
    END LOOP;
  END get_gdbd_list;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  04.04.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Executes POPULATE_GDBD procedure and fetches the records for GDBD block
  */
  FUNCTION populate_giacs035_gdbd(p_gibr_branch_cd        GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                                       p_gfun_fund_cd            GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                                     p_dcb_year                GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                     p_dcb_no                GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                     p_dcb_date                VARCHAR2)
    RETURN gdbd_list_tab PIPELINED
  IS
      v_exists     VARCHAR2(1) := 'N';
      v_item_no    NUMBER := 1;
      v_dcb_date   DATE;
      v_gdbd_list  gdbd_list_type;
  BEGIN
      -- convert dcb_date
      BEGIN
         v_dcb_date := TO_DATE (p_dcb_date, 'MM-DD-RRRR');
      EXCEPTION
         WHEN OTHERS
         THEN
            v_dcb_date := NULL;
      END;
      
      /** pm_sum */
      FOR i IN (SELECT p_gfun_fund_cd fund_cd, p_gibr_branch_cd branch_cd, p_dcb_year dcb_year,
                          p_dcb_no dcb_no, v_dcb_date dcb_date, gicd.dcb_bank_cd bank_cd,
                          gicd.dcb_bank_acct_cd bank_acct_cd, gicd.dcb_bank_cd || '-' || gicd.dcb_bank_acct_cd bank_acct,
                       gicd.pay_mode, nvl(sum(gicd.amount), 0) amount, gicd.currency_cd,
                          a430.short_name dsp_curr_sname, nvl(sum(gicd.fcurrency_amt), 0) foreign_curr_amt,
                          gicd.currency_rt
          FROM giis_currency a430, giac_collection_dtl gicd, giac_order_of_payts giop
         WHERE gicd.gacc_tran_id = giop.gacc_tran_id
           AND ((giop.dcb_no = p_dcb_no    AND nvl(with_pdc,'N') <> 'Y') 
                  OR 
                (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y'))            
           AND ((to_char(giop.or_date,'MM-DD-RRRR') = to_char(v_dcb_date,'MM-DD-RRRR') AND nvl(with_pdc,'N') <> 'Y')
                    OR 
                (to_char(gicd.due_dcb_date,'MM-DD-RRRR') = to_char(v_dcb_date,'MM-DD-RRRR') AND with_pdc = 'Y'))            
           AND giop.gibr_branch_cd = p_gibr_branch_cd
           AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd 
           AND gicd.currency_cd = a430.main_currency_cd
           AND ((giop.or_flag = 'P') --OR (giop.or_flag = 'C' AND nvl(to_char(giop.cancel_date, 'MM-DD-YYYY'), '-') <> to_char(giop.or_date, 'MM-DD-YYYY')) --marco - 02.20.2015 - comment out FGIC SR 18063 
                OR
                (giop.or_flag = 'C' AND giop.cancel_dcb_no <> p_dcb_no AND nvl(to_char(giop.cancel_date, 'MM-DD-YYYY'), '-') = to_char(giop.or_date, 'MM-DD-YYYY')))
             AND gicd.pay_mode NOT IN ('CMI','CW', 'RCM') -- RCM added by: Nica 06.15.2013 AC-SPECS-2012-155  
         GROUP BY gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd, gicd.pay_mode,
               a430.short_name, gicd.currency_rt, gicd.currency_cd
         ORDER BY gicd.pay_mode, gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd)
         
      LOOP
          v_gdbd_list.item_no                         := v_item_no;
          v_gdbd_list.bank_cd                        := i.bank_cd;
        v_gdbd_list.bank_acct_cd                    := i.bank_acct_cd;
        v_gdbd_list.pay_mode                        := i.pay_mode;
        v_gdbd_list.amount                            := i.amount;
        v_gdbd_list.old_dep_amt                    := i.amount;
        v_gdbd_list.currency_cd                    := i.currency_cd;  
        v_gdbd_list.currency_rt                    := i.currency_rt; 
        v_gdbd_list.dsp_curr_sname                    := i.dsp_curr_sname; 
        v_gdbd_list.foreign_curr_amt                := i.foreign_curr_amt;
        v_gdbd_list.fund_cd                           := i.fund_cd;
        v_gdbd_list.branch_cd                       := i.branch_cd;
        v_gdbd_list.dcb_year                       := i.dcb_year;
        v_gdbd_list.dcb_no                           := i.dcb_no;
        v_gdbd_list.dcb_date                       := i.dcb_date;
        v_gdbd_list.bank_acct                       := i.bank_acct;
        v_gdbd_list.adj_amt                           := 0;
        
    
          v_item_no := v_item_no + 1;
        v_exists :='Y';
        
        --emsy 08092012
         FOR j IN (SELECT a.bank_name bank_name, b.bank_acct_no bank_acct_no
                     FROM giac_banks a, giac_bank_accounts b
                    where a.bank_cd = i.bank_cd
                      and b.bank_acct_cd = i.bank_acct_cd )
         LOOP
           v_gdbd_list.dsp_bank_name    := j.bank_name;
           v_gdbd_list.dsp_bank_acct_no := j.bank_acct_no;
         END LOOP;
        PIPE ROW(v_gdbd_list); -- robert 9.24.2012
      END LOOP;
        
      IF v_exists = 'N' THEN
        /** pdc_sum */
           FOR i IN (SELECT p_gfun_fund_cd fund_cd, p_gibr_branch_cd branch_cd, p_dcb_year dcb_year,
                          p_dcb_no dcb_no, v_dcb_date dcb_date, gicd.dcb_bank_cd bank_cd,
                          gicd.dcb_bank_acct_cd bank_acct_cd, gicd.dcb_bank_cd || '-' || gicd.dcb_bank_acct_cd bank_acct,
                       gicd.pay_mode, nvl(sum(gicd.amount), 0) amount, gicd.currency_cd,
                          a430.short_name dsp_curr_sname, nvl(sum(gicd.fcurrency_amt), 0) foreign_curr_amt,
                          gicd.currency_rt
                FROM giis_currency a430, 
                     giac_collection_dtl gicd,
                     giac_order_of_payts giop
               WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                 AND to_char(gicd.due_dcb_date,'MM-DD-RRRR') = to_char(v_dcb_date,'MM-DD-RRRR')
                     AND gicd.due_dcb_no = p_dcb_no 
                 AND gicd.currency_cd = a430.main_currency_cd
                     AND gicd.pay_mode NOT IN ('CMI','CW', 'RCM') -- RCM added by: Nica 06.15.2013 AC-SPECS-2012-155 
               GROUP BY gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd, gicd.pay_mode,
                        a430.short_name, gicd.currency_rt, gicd.currency_cd
               ORDER BY gicd.pay_mode, gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd)
        LOOP
              v_gdbd_list.item_no                           := v_item_no;
              v_gdbd_list.bank_cd                        := i.bank_cd;
            v_gdbd_list.bank_acct_cd                    := i.bank_acct_cd;
            v_gdbd_list.pay_mode                        := i.pay_mode;
            v_gdbd_list.amount                            := i.amount;
            v_gdbd_list.old_dep_amt                    := i.amount;
            v_gdbd_list.currency_cd                    := i.currency_cd;  
            v_gdbd_list.currency_rt                    := i.currency_rt; 
            v_gdbd_list.dsp_curr_sname                    := i.dsp_curr_sname; 
            v_gdbd_list.foreign_curr_amt                := i.foreign_curr_amt;
            v_gdbd_list.fund_cd                           := i.fund_cd;
            v_gdbd_list.branch_cd                       := i.branch_cd;
            v_gdbd_list.dcb_year                       := i.dcb_year;
            v_gdbd_list.dcb_no                           := i.dcb_no;
            v_gdbd_list.dcb_date                       := i.dcb_date;
            v_gdbd_list.bank_acct                       := i.bank_acct;
            v_gdbd_list.adj_amt                           := 0;
    
              v_item_no := v_item_no + 1;
            
            --emsy 08092012
             FOR j IN (SELECT a.bank_name bank_name, b.bank_acct_no bank_acct_no
                         FROM giac_banks a, giac_bank_accounts b
                        where a.bank_cd = i.bank_cd
                          and b.bank_acct_cd = i.bank_acct_cd)
             LOOP
               v_gdbd_list.dsp_bank_name    := j.bank_name;
               v_gdbd_list.dsp_bank_acct_no := j.bank_acct_no;
             END LOOP;
            
            PIPE ROW(v_gdbd_list);
        END LOOP;        
      END IF;
  END populate_giacs035_gdbd;
  
  PROCEDURE set_giac_dcb_bank_dep(p_gacc_tran_id                    GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
                                   p_fund_cd                     GIAC_DCB_BANK_DEP.fund_cd%TYPE,
                                   p_branch_cd                     GIAC_DCB_BANK_DEP.branch_cd%TYPE,
                                   p_dcb_year                     GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                   p_dcb_no                         GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                   p_dcb_date                     GIAC_DCB_BANK_DEP.dcb_date%TYPE,
                                   p_item_no                     GIAC_DCB_BANK_DEP.item_no%TYPE,
                                   p_bank_cd                     GIAC_DCB_BANK_DEP.bank_cd%TYPE,
                                   p_bank_acct_cd                 GIAC_DCB_BANK_DEP.bank_acct_cd%TYPE,
                                   p_pay_mode                     GIAC_DCB_BANK_DEP.pay_mode%TYPE,
                                   p_amount                         GIAC_DCB_BANK_DEP.amount%TYPE,
                                   p_currency_cd                 GIAC_DCB_BANK_DEP.currency_cd%TYPE,
                                   p_foreign_curr_amt             GIAC_DCB_BANK_DEP.foreign_curr_amt%TYPE,
                                   p_currency_rt                 GIAC_DCB_BANK_DEP.currency_rt%TYPE,
                                   p_old_dep_amt                 GIAC_DCB_BANK_DEP.old_dep_amt%TYPE,
                                   p_adj_amt                     GIAC_DCB_BANK_DEP.adj_amt%TYPE,
                                   p_remarks                     GIAC_DCB_BANK_DEP.remarks%TYPE,
                                   p_user_id                     GIAC_DCB_BANK_DEP.user_id%TYPE,
                                   p_last_update                 GIAC_DCB_BANK_DEP.last_update%TYPE)
  IS
  BEGIN
         MERGE INTO GIAC_DCB_BANK_DEP
       USING DUAL ON (gacc_tran_id                    = p_gacc_tran_id
                  AND fund_cd                     = p_fund_cd
                  AND branch_cd                     = p_branch_cd
                  AND dcb_year                     = p_dcb_year
                  AND dcb_no                     = p_dcb_no
                  AND item_no                     = p_item_no)
       WHEN NOT MATCHED THEN
               INSERT (gacc_tran_id, fund_cd,         branch_cd,   dcb_year,
                    dcb_no,         dcb_date,     item_no,        bank_cd,
                    bank_acct_cd, pay_mode,     amount,        currency_cd,
                    foreign_curr_amt, currency_rt, old_dep_amt, adj_amt,
                    remarks, user_id, last_update)
            VALUES (p_gacc_tran_id, p_fund_cd,         p_branch_cd,   p_dcb_year,
                    p_dcb_no,         p_dcb_date,     p_item_no,        p_bank_cd,
                    p_bank_acct_cd, p_pay_mode,     p_amount,        p_currency_cd,
                    p_foreign_curr_amt, p_currency_rt, p_old_dep_amt, p_adj_amt,
                    p_remarks, p_user_id, p_last_update)
       WHEN MATCHED THEN
               UPDATE SET dcb_date                     = p_dcb_date,
                       bank_cd                     = p_bank_cd,
                       bank_acct_cd                 = p_bank_acct_cd,
                       pay_mode                     = p_pay_mode,
                       amount                     = p_amount,
                       currency_cd                 = p_currency_cd,
                       foreign_curr_amt             = p_foreign_curr_amt,
                       currency_rt                 = p_currency_rt,
                       old_dep_amt                 = p_old_dep_amt,
                       adj_amt                     = p_adj_amt,
                       remarks                     = p_remarks,
                       user_id                     = p_user_id,
                       last_update                 = p_last_update;
  END set_giac_dcb_bank_dep;
  
  PROCEDURE del_giac_dcb_bank_dep(p_gacc_tran_id                    GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
                                   p_fund_cd                     GIAC_DCB_BANK_DEP.fund_cd%TYPE,
                                   p_branch_cd                     GIAC_DCB_BANK_DEP.branch_cd%TYPE,
                                   p_dcb_year                     GIAC_DCB_BANK_DEP.dcb_year%TYPE,
                                   p_dcb_no                         GIAC_DCB_BANK_DEP.dcb_no%TYPE,
                                   p_item_no                     GIAC_DCB_BANK_DEP.item_no%TYPE)
  IS
  BEGIN
         DELETE GIAC_DCB_BANK_DEP
        WHERE gacc_tran_id       = p_gacc_tran_id
          AND fund_cd           = p_fund_cd
          AND branch_cd           = p_branch_cd
          AND dcb_year           = p_dcb_year
          AND dcb_no           = p_dcb_no
          AND item_no           = p_item_no;
  END del_giac_dcb_bank_dep;
  
  FUNCTION get_giacs281_bank_acct_lov
     RETURN giacs281_bank_acct_lov_tab PIPELINED
  IS
     v_list giacs281_bank_acct_lov_type;
  BEGIN
     FOR i IN (SELECT DISTINCT b.bank_acct_cd, c.bank_sname,
                      b.bank_acct_type || '-' || b.bank_acct_no bank_acct,
                      b.branch_cd
                 FROM giac_dcb_bank_dep a, giac_bank_accounts b, giac_banks c
                WHERE a.bank_cd = b.bank_cd
                  AND a.bank_acct_cd = b.bank_acct_cd
                  AND a.bank_cd = c.bank_cd
                  AND b.bank_cd = c.bank_cd)
     LOOP
        v_list.bank_acct_cd := i.bank_acct_cd;
        v_list.bank_sname := i.bank_sname;
        v_list.bank_acct := i.bank_acct;
        v_list.branch_cd := i.branch_cd;
        PIPE ROW(v_list);
     END LOOP;             
  END get_giacs281_bank_acct_lov;
  
  FUNCTION validate_giacs281_bank_acct (
     p_bank_acct_cd giac_bank_accounts.bank_acct_cd%TYPE
  )
     RETURN VARCHAR2
  IS
     v_temp VARCHAR2(500);
  BEGIN
     BEGIN
        SELECT DISTINCT 
               b.bank_acct_type || '-' || b.bank_acct_no
          INTO v_temp
          FROM giac_dcb_bank_dep a, giac_bank_accounts b, giac_banks c
         WHERE a.bank_cd = b.bank_cd
           AND a.bank_acct_cd = b.bank_acct_cd
           AND a.bank_cd = c.bank_cd
           AND b.bank_cd = c.bank_cd
           AND b.bank_acct_cd = p_bank_acct_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_temp := 'ERROR';    
     END;
     
     RETURN v_temp;
  END;
  
  FUNCTION get_giacs035_bank_lov( --SR#18447; John Dolon; 05.25.2015
    p_find_text         VARCHAR2,
    p_order_by          VARCHAR2,
    p_asc_desc_flag     VARCHAR2,
    p_from              NUMBER,
    p_to                NUMBER
  )
    RETURN bank_lov_tab PIPELINED
  IS
    TYPE cur_type IS REF CURSOR;
    c                   cur_type;
    v_rec               bank_lov_type;
    v_sql               VARCHAR2(10000);
  BEGIN
    v_sql := 'SELECT mainsql.*
                FROM (SELECT COUNT(1) OVER() count_, outersql.*
                        FROM (SELECT ROWNUM rownum_, innersql.*
                                FROM (SELECT DISTINCT gbac.bank_cd, gban.bank_name
                                        FROM GIAC_BANK_ACCOUNTS gbac,
                                             GIAC_BANKS gban
                                       WHERE gbac.bank_cd = gban.bank_cd
                                         AND gbac.bank_account_flag = ''A''
                                         AND gbac.opening_date < SYSDATE
                                         AND NVL(gbac.closing_date, SYSDATE + 1) > SYSDATE ';
                                         
    IF p_find_text IS NOT NULL THEN
        v_sql := v_sql || ' AND (UPPER(gbac.bank_cd) LIKE UPPER(''' || p_find_text || ''')' ||
                           ' OR UPPER(gban.bank_name) LIKE UPPER(''' || p_find_text || '''))'; 
    END IF;
                                         
    v_sql := v_sql || ' ORDER BY 2) innersql';
                                       
    IF p_order_by IS NOT NULL THEN
        IF p_order_by = 'bankCd' THEN
            v_sql := v_sql || ' ORDER BY bank_cd ';
        ELSIF p_order_by = 'bankName' THEN
            v_sql := v_sql || ' ORDER BY bank_name ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF;
    END IF;
                                       
    v_sql := v_sql || ' ) outersql) mainsql WHERE rownum_ BETWEEN ' || p_from  || ' AND ' || p_to;
    
    OPEN c FOR v_sql;
    LOOP
        FETCH c
         INTO v_rec.count_,
              v_rec.rownum_,
              v_rec.bank_cd,
              v_rec.bank_name;                            
        EXIT WHEN c%NOTFOUND;  
        
        PIPE ROW(v_rec);
    END LOOP;
    
    CLOSE c;
  END;
  
    --marco - 02.20.2015
    PROCEDURE refresh_dcb(
        p_gacc_tran_id          giac_dcb_bank_dep.gacc_tran_id%TYPE,
        p_gibr_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
        p_gfun_fund_cd            giac_acctrans.gfun_fund_cd%TYPE,
        p_dcb_year                giac_dcb_bank_dep.dcb_year%TYPE,
        p_dcb_no                giac_dcb_bank_dep.dcb_no%TYPE,
        p_dcb_date                VARCHAR2,
        p_user_id               giac_dcb_bank_dep.user_id%TYPE,
        p_module_name           GIAC_MODULES.module_name%TYPE   -- dren 08.03.2015 : SR 0017729 - Additional parameter for Refresh DC        
    )
    IS
        v_exists                VARCHAR2(1) := 'N';
        v_item_no               NUMBER := 1;
        v_dcb_date              DATE;
        v_gdbd_list             gdbd_list_type;
        v_gen_type              giac_modules.generation_type%TYPE;  -- dren 08.03.2015 : SR 0017729
    BEGIN
        BEGIN
            v_dcb_date := TO_DATE(p_dcb_date, 'MM-DD-RRRR');
        EXCEPTION
            WHEN OTHERS THEN
                v_dcb_date := NULL;
        END;
    
        DELETE FROM giac_dcb_bank_dep
         WHERE gacc_tran_id = p_gacc_tran_id;
        
        FOR i IN(SELECT p_gfun_fund_cd fund_cd, p_gibr_branch_cd branch_cd, p_dcb_year dcb_year,
                            p_dcb_no dcb_no, v_dcb_date dcb_date, gicd.dcb_bank_cd bank_cd,
                           gicd.dcb_bank_acct_cd bank_acct_cd, gicd.dcb_bank_cd || '-' || gicd.dcb_bank_acct_cd bank_acct,
                        gicd.pay_mode, NVL(SUM(gicd.amount), 0) amount, gicd.currency_cd,
                           a430.short_name dsp_curr_sname, NVL(SUM(gicd.fcurrency_amt), 0) foreign_curr_amt,
                           gicd.currency_rt
                   FROM GIIS_CURRENCY a430,
                        GIAC_COLLECTION_DTL gicd,
                        GIAC_ORDER_OF_PAYTS giop
                  WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                    AND ((giop.dcb_no = p_dcb_no AND NVL(with_pdc,'N') <> 'Y') 
                     OR (gicd.due_dcb_no = p_dcb_no AND with_pdc = 'Y'))            
                    AND ((TO_CHAR(giop.or_date,'MM-DD-RRRR') = TO_CHAR(v_dcb_date,'MM-DD-RRRR') AND NVL(with_pdc,'N') <> 'Y')
                     OR (TO_CHAR(gicd.due_dcb_date,'MM-DD-RRRR') = TO_CHAR(v_dcb_date,'MM-DD-RRRR') AND with_pdc = 'Y'))            
                    AND giop.gibr_branch_cd = p_gibr_branch_cd
                    AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd 
                    AND gicd.currency_cd = a430.main_currency_cd
                    AND ((giop.or_flag = 'P') 
                     OR (giop.or_flag = 'C' AND giop.cancel_dcb_no <> p_dcb_no AND NVL(TO_CHAR(giop.cancel_date, 'MM-DD-YYYY'), '-') = TO_CHAR(giop.or_date, 'MM-DD-YYYY')))
                    AND gicd.pay_mode NOT IN ('CMI','CW', 'RCM')  
                  GROUP BY gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd, gicd.pay_mode,
                        a430.short_name, gicd.currency_rt, gicd.currency_cd
                  ORDER BY gicd.pay_mode, gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd)
        LOOP
            v_gdbd_list := NULL;
            v_gdbd_list.item_no := v_item_no;
            v_gdbd_list.bank_cd := i.bank_cd;
            v_gdbd_list.bank_acct_cd := i.bank_acct_cd;
            v_gdbd_list.pay_mode := i.pay_mode;
            v_gdbd_list.amount := i.amount;
            v_gdbd_list.old_dep_amt := i.amount;
            v_gdbd_list.currency_cd := i.currency_cd;  
            v_gdbd_list.currency_rt := i.currency_rt; 
            v_gdbd_list.dsp_curr_sname := i.dsp_curr_sname; 
            v_gdbd_list.foreign_curr_amt := i.foreign_curr_amt;
            v_gdbd_list.fund_cd := i.fund_cd;
            v_gdbd_list.branch_cd := i.branch_cd;
            v_gdbd_list.dcb_year := i.dcb_year;
            v_gdbd_list.dcb_no := i.dcb_no;
            v_gdbd_list.dcb_date := i.dcb_date;
            v_gdbd_list.bank_acct := i.bank_acct;
            v_gdbd_list.adj_amt := 0;
            v_item_no := v_item_no + 1;
            v_exists :='Y';
        
            FOR j IN(SELECT a.bank_name bank_name, b.bank_acct_no bank_acct_no
                       FROM giac_banks a,
                            giac_bank_accounts b
                      WHERE a.bank_cd = i.bank_cd
                        AND b.bank_cd = i.bank_cd
                        AND b.bank_acct_cd = i.bank_acct_cd
                        AND a.bank_cd = b.bank_cd)
            LOOP
                v_gdbd_list.dsp_bank_name := j.bank_name;
                v_gdbd_list.dsp_bank_acct_no := j.bank_acct_no;
            END LOOP;
            
            INSERT INTO giac_dcb_bank_dep
                   (gacc_tran_id, fund_cd, branch_cd, dcb_year,
                   dcb_no, dcb_date, item_no, bank_cd,
                   bank_acct_cd, pay_mode,    amount, currency_cd,
                   foreign_curr_amt, currency_rt, old_dep_amt, adj_amt,
                   remarks, user_id, last_update)
            VALUES (p_gacc_tran_id, v_gdbd_list.fund_cd, v_gdbd_list.branch_cd, v_gdbd_list.dcb_year,
                   v_gdbd_list.dcb_no, v_gdbd_list.dcb_date, v_gdbd_list.item_no, v_gdbd_list.bank_cd,
                   v_gdbd_list.bank_acct_cd, v_gdbd_list.pay_mode, v_gdbd_list.amount, v_gdbd_list.currency_cd,
                   v_gdbd_list.foreign_curr_amt, v_gdbd_list.currency_rt, v_gdbd_list.old_dep_amt, 0,
                   NULL, p_user_id, SYSDATE);
        END LOOP;
        
        IF v_exists = 'N' THEN
            FOR i IN(SELECT p_gfun_fund_cd fund_cd, p_gibr_branch_cd branch_cd, p_dcb_year dcb_year,
                            p_dcb_no dcb_no, v_dcb_date dcb_date, gicd.dcb_bank_cd bank_cd,
                            gicd.dcb_bank_acct_cd bank_acct_cd, gicd.dcb_bank_cd || '-' || gicd.dcb_bank_acct_cd bank_acct,
                            gicd.pay_mode, NVL(SUM(gicd.amount), 0) amount, gicd.currency_cd,
                            a430.short_name dsp_curr_sname, NVL(SUM(gicd.fcurrency_amt), 0) foreign_curr_amt,
                            gicd.currency_rt
                       FROM giis_currency a430, 
                            giac_collection_dtl gicd,
                            giac_order_of_payts giop
                      WHERE gicd.gacc_tran_id = giop.gacc_tran_id
                        AND TO_CHAR(gicd.due_dcb_date,'MM-DD-RRRR') = TO_CHAR(v_dcb_date,'MM-DD-RRRR')
                        AND gicd.due_dcb_no = p_dcb_no 
                        AND gicd.currency_cd = a430.main_currency_cd
                        AND gicd.pay_mode NOT IN ('CMI','CW', 'RCM') 
                      GROUP BY gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd, gicd.pay_mode,
                            a430.short_name, gicd.currency_rt, gicd.currency_cd
                      ORDER BY gicd.pay_mode, gicd.dcb_bank_cd, gicd.dcb_bank_acct_cd)
            LOOP
                v_gdbd_list := NULL;
                v_gdbd_list.item_no := v_item_no;
                v_gdbd_list.bank_cd := i.bank_cd;
                v_gdbd_list.bank_acct_cd := i.bank_acct_cd;
                v_gdbd_list.pay_mode := i.pay_mode;
                v_gdbd_list.amount := i.amount;
                v_gdbd_list.old_dep_amt := i.amount;
                v_gdbd_list.currency_cd := i.currency_cd;  
                v_gdbd_list.currency_rt := i.currency_rt; 
                v_gdbd_list.dsp_curr_sname := i.dsp_curr_sname; 
                v_gdbd_list.foreign_curr_amt := i.foreign_curr_amt;
                v_gdbd_list.fund_cd := i.fund_cd;
                v_gdbd_list.branch_cd := i.branch_cd;
                v_gdbd_list.dcb_year := i.dcb_year;
                v_gdbd_list.dcb_no := i.dcb_no;
                v_gdbd_list.dcb_date := i.dcb_date;
                v_gdbd_list.bank_acct := i.bank_acct;
                v_gdbd_list.adj_amt := 0;
                  v_item_no := v_item_no + 1;
            
                FOR j IN (SELECT a.bank_name bank_name, b.bank_acct_no bank_acct_no
                            FROM giac_banks a,
                                 giac_bank_accounts b
                           WHERE a.bank_cd = i.bank_cd
                             AND b.bank_cd = i.bank_cd
                             AND b.bank_acct_cd = i.bank_acct_cd
                             AND a.bank_cd = b.bank_cd)
                LOOP
                    v_gdbd_list.dsp_bank_name := j.bank_name;
                    v_gdbd_list.dsp_bank_acct_no := j.bank_acct_no;
                END LOOP;
            
                INSERT INTO giac_dcb_bank_dep
                       (gacc_tran_id, fund_cd, branch_cd, dcb_year,
                       dcb_no, dcb_date, item_no, bank_cd,
                       bank_acct_cd, pay_mode,    amount, currency_cd,
                       foreign_curr_amt, currency_rt, old_dep_amt, adj_amt,
                       remarks, user_id, last_update)
                VALUES (p_gacc_tran_id, v_gdbd_list.fund_cd, v_gdbd_list.branch_cd, v_gdbd_list.dcb_year,
                       v_gdbd_list.dcb_no, v_gdbd_list.dcb_date, v_gdbd_list.item_no, v_gdbd_list.bank_cd,
                       v_gdbd_list.bank_acct_cd, v_gdbd_list.pay_mode, v_gdbd_list.amount, v_gdbd_list.currency_cd,
                       v_gdbd_list.foreign_curr_amt, v_gdbd_list.currency_rt, v_gdbd_list.old_dep_amt, 0,
                       NULL, p_user_id, SYSDATE);
            END LOOP;        
        END IF;
        
        SELECT generation_type -- dren 08.03.2015 : SR 0017729 - Delete Accounting Entries - Start
          INTO v_gen_type
          FROM giac_modules
          WHERE module_name = p_module_name;   
          
        GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type); -- dren 08.03.2015 : SR 0017729 - Delete Accounting Entries - End            
        
    END;
    
END giac_dcb_bank_dep_pkg;
/


DROP PUBLIC SYNONYM GIAC_DCB_BANK_DEP_PKG;

CREATE PUBLIC SYNONYM GIAC_DCB_BANK_DEP_PKG FOR CPI.GIAC_DCB_BANK_DEP_PKG;



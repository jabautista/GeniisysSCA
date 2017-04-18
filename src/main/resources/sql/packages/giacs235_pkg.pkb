CREATE OR REPLACE PACKAGE BODY CPI.GIACS235_PKG AS
    /*
   **  Created by   : Lara Beltran
   **  Modified By  : Kenneth L. 03.01.2013
   **  Reference By : (GIACS235- OR Status)
   */
    FUNCTION get_list_or_status (
        P_FUND_CD       giis_funds.fund_cd%TYPE,
        P_BRANCH_CD     giac_branches.branch_cd%TYPE,
        P_STATUS        giac_order_of_payts.or_flag%TYPE,
        P_OR_DATE       VARCHAR2,
        P_DCB_NO        giac_order_of_payts.DCB_NO%TYPE,        -- start SR-4722 : shan 06.29.2015
        P_OR_NO         VARCHAR2,
        P_PAYOR         giac_order_of_payts.PAYOR%TYPE,
        P_PARTICULARS   giac_order_of_payts.PARTICULARS%TYPE,   -- carlo 8/12/2015 SR19275
        P_CASHIER       VARCHAR2,
        P_RV_MEANING    cg_ref_codes.RV_MEANING%TYPE,
        p_order_by      VARCHAR2,
        p_asc_desc_flag VARCHAR2,
        p_row_from      NUMBER,
        p_row_to        NUMBER,                                 -- end SR-4722 : shan 06.29.2015
        p_user_id       giac_order_of_payts.user_id%TYPE DEFAULT NULL        --added by MarkS SR5694 10.26.2016 optimization 
    )
       RETURN acc_list_or_status_tab PIPELINED
    IS
       v_list   acc_list_or_status_type;
       
        TYPE cur_type IS REF CURSOR;
        c                 cur_type;
        v_sql             VARCHAR2(32767);
        v_all_user_sw      GIIS_USERS.all_user_sw%TYPE;         --added by MarkS SR5694 10.26.2016 optimization 
              
    BEGIN
       /*FOR i IN (SELECT   goop.dcb_no,
                          goop.or_pref_suf || '-' || goop.or_no or_no,
                          TRUNC (goop.or_date) or_date, goop.payor,
                          goop.cashier_cd || ' - ' || goop.user_id cashier_cd,
                          crc.rv_meaning, goop.particulars, goop.user_id,
                          goop.last_update, goop.gacc_tran_id tran_id,
                          goop.or_pref_suf or_pref, goop.or_no or_pref_no, goop.or_flag
                     FROM giac_order_of_payts goop, cg_ref_codes crc
                    WHERE goop.user_id IN (
                             SELECT DISTINCT gdu.dcb_user_id
                                        FROM giac_dcb_users gdu,
                                             giac_branches gb,
                                             giac_order_of_payts goop
                                       WHERE goop.cashier_cd = gdu.cashier_cd
                                         AND gdu.gibr_branch_cd = gb.branch_cd
                                         AND gdu.gibr_fund_cd = gb.gfun_fund_cd)
                      AND crc.rv_low_value = goop.or_flag
                      AND crc.rv_domain = 'GIAC_ORDER_OF_PAYTS.OR_FLAG'
                      AND goop.gibr_gfun_fund_cd LIKE p_fund_cd
                      AND goop.gibr_branch_cd LIKE p_branch_cd
                      AND goop.or_flag LIKE NVL (p_status, goop.or_flag)
                      AND or_date LIKE NVL (TO_DATE (p_or, 'mm-dd-yyyy'), or_date)
                 ORDER BY goop.dcb_no)
       LOOP
          v_list.dcb_no         := i.dcb_no;
          v_list.or_no          := i.or_no;
          v_list.payor          := i.payor;
          v_list.cashier_cd     := i.cashier_cd;
          v_list.or_date        := TO_CHAR (i.or_date, 'mm-dd-yyyy');
          v_list.particulars    := i.particulars;
          v_list.user_id        := i.user_id;
          v_list.last_update    := TO_CHAR (i.last_update, 'mm-dd-yyyy hh:mi:ss AM');
          v_list.rv_meaning     := i.rv_meaning;
          v_list.tran_id        := i.tran_id;
          v_list.or_pref        := i.or_pref;
          v_list.or_pref_no     := i.or_pref_no;
          v_list.rv_low_value   := i.or_flag;
          PIPE ROW (v_list);
       END LOOP;
       
       RETURN;*/ -- replaced with codes below ::: SR-4722 : shan 06.29.2015
        FOR i IN (SELECT all_user_sw
                         FROM giis_users
                 WHERE user_id = p_user_id)
        LOOP
            v_all_user_sw := i.all_user_sw;
        END LOOP;
         v_sql := 'SELECT mainsql.*
                     FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT   goop.dcb_no,
                                              goop.or_pref_suf || ''-'' || goop.or_no or_no,
                                              TO_CHAR (TRUNC (goop.or_date), ''mm-dd-yyyy'') or_date, goop.payor,
                                              goop.cashier_cd || '' - '' || goop.user_id cashier_cd,
                                              crc.rv_meaning, goop.particulars, goop.user_id,
                                              TO_CHAR (goop.last_update, ''mm-dd-yyyy hh:mi:ss AM'') last_update, goop.gacc_tran_id tran_id,
                                              goop.or_pref_suf or_pref, goop.or_no or_pref_no, goop.or_flag
                                         FROM giac_order_of_payts goop, cg_ref_codes crc
                                        WHERE crc.rv_low_value = goop.or_flag
                                          AND goop.user_id LIKE DECODE ('''||v_all_user_sw||''', ''Y'', ''%'', '''||p_user_id||''')
                                          AND crc.rv_domain = ''GIAC_ORDER_OF_PAYTS.OR_FLAG'' ';
            v_sql := v_sql ||            'AND goop.gibr_gfun_fund_cd LIKE '''||p_fund_cd||''' ';
         
         IF p_branch_cd IS NOT NULL THEN
            v_sql := v_sql ||            'AND goop.gibr_branch_cd LIKE '''||p_branch_cd||''' ';
         END IF;
            
         IF p_status IS NOT NULL THEN
            v_sql := v_sql ||            'AND goop.or_flag LIKE NVL ('''||p_status||''', goop.or_flag) ';
         END IF;
         
         IF p_or_date IS NOT NULL THEN
            v_sql := v_sql ||            'AND or_date LIKE NVL (TO_DATE ('''||p_or_date||''', ''mm-dd-yyyy''), or_date) ';
         END IF;
         
         IF p_dcb_no IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(dcb_no) LIKE UPPER(NVL('''||p_dcb_no||''', dcb_no)) ';
         END IF;
         
         IF p_or_no IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(goop.or_pref_suf || ''-'' || goop.or_no) LIKE UPPER(NVL('''||p_or_no||''', goop.or_pref_suf || ''-'' || goop.or_no)) ';
         END IF;
         
         IF p_payor IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(payor) LIKE UPPER(NVL('''||p_payor||''', payor)) ';
         END IF;
         
         IF p_particulars IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(goop.particulars) LIKE UPPER(NVL('''||p_particulars||''', particulars)) ';
         END IF;
         
         IF p_cashier IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(goop.cashier_cd || '' - '' || goop.user_id) LIKE UPPER(NVL('''||p_cashier||''', goop.cashier_cd || '' - '' || goop.user_id)) ';
         END IF;
         
         IF p_rv_meaning IS NOT NULL THEN
            v_sql := v_sql ||            'AND UPPER(rv_meaning) LIKE UPPER(NVL('''||p_rv_meaning||''', rv_meaning)) ';
         END IF;
        
        IF p_order_by IS NOT NULL THEN
            IF p_order_by = 'dcbNo' THEN
                v_sql := v_sql || ' ORDER BY dcb_no ';
            ELSIF p_order_by = 'orNo' THEN
                v_sql := v_sql || ' ORDER BY or_no ';
            ELSIF p_order_by = 'orDate' THEN
                v_sql := v_sql || ' ORDER BY or_date ';
            ELSIF p_order_by = 'payor' THEN
                v_sql := v_sql || ' ORDER BY payor ';
            ELSIF p_order_by = 'particulars' THEN
                v_sql := v_sql || ' ORDER BY particulars ';  -- carlo 8/12/2015 SR19275
            ELSIF p_order_by = 'cashierCd' THEN
                v_sql := v_sql || ' ORDER BY cashier_cd ';
            ELSIF p_order_by = 'rvMeaning' THEN
                v_sql := v_sql || ' ORDER BY rv_meaning ';
            END IF;
                    
            IF p_asc_desc_flag IS NOT NULL THEN
                v_sql := v_sql || p_asc_desc_flag;
            ELSE 
                v_sql := v_sql || ' ASC ';
            END IF;
        ELSE
            v_sql := v_sql || ' ORDER BY goop.dcb_no ';
        END IF;
                    
        v_sql := v_sql || '       )innersql
                                ) outersql
                             ) mainsql
                        WHERE rownum_ BETWEEN '|| p_row_from ||' AND NVL(''' || p_row_to || ''', count_)';
    
        OPEN c FOR v_sql; 
        LOOP    
            FETCH c INTO
                v_list.count_,            
                v_list.rownum_,
                v_list.dcb_no,
                v_list.or_no,
                v_list.or_date,
                v_list.payor,
                v_list.cashier_cd,
                v_list.rv_meaning,
                v_list.particulars,
                v_list.user_id,
                v_list.last_update,
                v_list.tran_id,
                v_list.or_pref,
                v_list.or_pref_no,
                v_list.rv_low_value;
                    
            EXIT WHEN c%NOTFOUND;  
            PIPE ROW (v_list);
        END LOOP;      
      
        CLOSE c;
    END get_list_or_status;
    
    FUNCTION get_list_or_history (P_TRAN_ID giac_or_stat_hist.gacc_tran_id%TYPE)
       RETURN acc_list_or_history_tab PIPELINED
    IS
       v_list   acc_list_or_history_type;
    BEGIN
       FOR i IN (SELECT a.or_flag, b.rv_meaning, a.user_id, a.last_update   
                   FROM giac_or_stat_hist a, cg_ref_codes b
                  WHERE gacc_tran_id = P_TRAN_ID
                    AND a.or_flag = b.rv_low_value
                    AND b.rv_domain = 'GIAC_ORDER_OF_PAYTS.OR_FLAG')
       LOOP
          v_list.or_flag        := i.or_flag;
          v_list.user_id        := i.user_id;
          v_list.last_update    := TO_CHAR (i.last_update, 'mm-dd-yyyy hh:mi:ss AM');
          v_list.rv_meaning     := i.rv_meaning;
          PIPE ROW (v_list);
       END LOOP;

       RETURN;
    END get_list_or_history;

    FUNCTION get_all_or_status (P_STATUS cg_ref_codes.rv_meaning%TYPE)
       RETURN all_or_status_tab PIPELINED
    IS
       v_stat   all_or_status_type;
    BEGIN
       FOR i IN (SELECT * 
                   FROM (SELECT UPPER(rv_low_value) rv_low_value, UPPER(rv_meaning) rv_meaning
                   FROM cg_ref_codes
                  WHERE rv_domain = 'GIAC_ORDER_OF_PAYTS.OR_FLAG'
                    AND rv_low_value <> 'D'
                  UNION ALL
                 SELECT 'ALL', 'ALL'
                   FROM DUAL)
                  WHERE UPPER (rv_meaning) LIKE UPPER (NVL (p_status, '%')))
       LOOP
          v_stat.rv_meaning := i.rv_meaning;
          v_stat.rv_low_value := i.rv_low_value;
          PIPE ROW (v_stat);
       END LOOP;
    END;
    
END;
/

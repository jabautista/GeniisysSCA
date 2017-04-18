CREATE OR REPLACE PACKAGE BODY CPI.GIACS070_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   08.22.2013
     ** Referenced By:  GIACS070 - View Journal Entries
     **/
     
    FUNCTION when_new_form_instance
        RETURN VARCHAR2
    AS
        v_with_op   giac_parameters.PARAM_VALUE_V%type := null;
        CURSOR chk_op 
        IS
           SELECT param_value_v
             FROM giac_parameters
            WHERE param_name = 'WITH_OP';
    BEGIN
        OPEN chk_op;
        FETCH chk_op INTO v_with_op;
        IF chk_op%FOUND THEN
           /*IF :GLOBAL.with_op = 'Y' 
           THEN
              :GLOBAL.op_req_tag := 'Y';
              :GLOBAL.op_tag := 'S';
              :GLOBAL.or_tag := NULL;
           ELSE
              :GLOBAL.op_req_tag := 'N';
              :GLOBAL.op_tag := NULL;
              :GLOBAL.or_tag := 'S';
              Set_Item_Property('GACC.OP_INFO_BUTTON', LABEL, 'OR Info');
           END IF;*/
           null;
        ELSE
           RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#No record found for param_name WITH_OP in GIAC_PARAMETERS.');
        END IF;
        
        RETURN v_with_op;
    END when_new_form_instance;
           
    
    /* CGFK$CHK_GACC_GACC_GIBR_FK in CS */
    PROCEDURE CHK_GACC_GACC_GIBR_FK(
        p_field_level       IN  BOOLEAN,        /* Is the trigger item level? */
        p_gibr_branch_cd    IN  GIAC_ACCTRANS.GIBR_BRANCH_CD%type,
        p_fund_desc         OUT GIIS_FUNDS.FUND_DESC%type,
        p_grac_rac_cd       OUT GIIS_FUNDS.GRAC_RAC_CD%type,
        p_branch_name       OUT GIAC_BRANCHES.BRANCH_NAME%type
    )/* Validate foreign key value/query lookup data. */
    AS
    BEGIN
        DECLARE
            CURSOR C IS
              SELECT GIBR.BRANCH_NAME
                    ,GFUN.FUND_DESC
                    ,GFUN.GRAC_RAC_CD
              FROM   GIAC_BRANCHES GIBR
                    ,GIIS_FUNDS GFUN
              WHERE  GIBR.BRANCH_CD = P_GIBR_BRANCH_CD
              AND    GFUN.FUND_CD = GIBR.GFUN_FUND_CD;
        BEGIN
            OPEN C;
            FETCH C
             INTO P_BRANCH_NAME
                  ,P_FUND_DESC 
                  ,P_GRAC_RAC_CD;
            IF C%NOTFOUND THEN
              RAISE NO_DATA_FOUND;
            END IF;
            CLOSE C;
          EXCEPTION
            WHEN OTHERS THEN
              NULL; --CGTE$OTHER_EXCEPTIONS;
          END;
    END CHK_GACC_GACC_GIBR_FK;
    
    FUNCTION get_journal_entries_list(
        p_gfun_fund_cd      GIAC_ACCTRANS.GFUN_FUND_CD%type,
        p_gibr_branch_cd    GIAC_ACCTRANS.GIBR_BRANCH_CD%type,
        p_user_id           VARCHAR2,
        /*Modified by pjsantos 12/01/2016, for optimization GENQA 5868*/
        p_tran_yy           VARCHAR2,
        p_tran_mm           VARCHAR2,
        p_tran_seq_no       VARCHAR2, 
        p_str_tran_date     VARCHAR2, 
        p_posting_date      VARCHAR2,
        p_tran_class        VARCHAR2,
        p_tran_flag         VARCHAR2,
        p_order_by          VARCHAR2,      
        p_asc_desc_flag     VARCHAR2,      
        p_first_row         NUMBER,        
        p_last_row          NUMBER
    ) RETURN journal_entries_tab PIPELINED
    AS
        res     journal_entries_type;
        TYPE cur_type IS REF CURSOR;      
        c        cur_type;                
        v_sql    VARCHAR2(32767);   
    BEGIN
/*        FOR i IN (
        SELECT * 
                    FROM GIAC_ACCTRANS
                   WHERE gfun_fund_cd = p_gfun_fund_cd --NVL(p_gfun_fund_cd,gfun_fund_cd) 
                     AND gibr_branch_cd = NVL(p_gibr_branch_cd,gibr_branch_cd) 
                     AND gibr_branch_cd in (SELECT ISS_CD 
                                              FROM GIIS_ISSOURCE
                                              WHERE iss_cd=DECODE(check_user_per_iss_cd_acctg2(null,iss_cd,'GIACS070', p_user_id),1,iss_cd,NULL)
                                           ) 
                   ORDER BY tran_date desc)*/
         v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT *
                                    FROM  (SELECT   tran_id             ,
                                                    gfun_fund_cd        ,
                                                    (SELECT  GFUN.FUND_DESC
                                                       FROM  GIAC_BRANCHES GIBR
                                                            ,GIIS_FUNDS GFUN
                                                      WHERE  GIBR.BRANCH_CD = a.GIBR_BRANCH_CD
                                                      AND    GFUN.FUND_CD = GIBR.GFUN_FUND_CD) fund_desc,
                                                    (SELECT  GFUN.GRAC_RAC_CD
                                                       FROM  GIAC_BRANCHES GIBR
                                                            ,GIIS_FUNDS GFUN
                                                      WHERE  GIBR.BRANCH_CD = a.GIBR_BRANCH_CD
                                                      AND    GFUN.FUND_CD = GIBR.GFUN_FUND_CD) grac_rac_cd,
                                                    gibr_branch_cd      ,
                                                    (SELECT  GIBR.BRANCH_NAME
                                                       FROM  GIAC_BRANCHES GIBR
                                                            ,GIIS_FUNDS GFUN
                                                      WHERE  GIBR.BRANCH_CD = a.GIBR_BRANCH_CD
                                                      AND    GFUN.FUND_CD = GIBR.GFUN_FUND_CD) branch_name,
                                                    tran_year           ,
                                                    tran_month          ,
                                                    tran_seq_no         , 
                                                    tran_date           ,
                                                    (SELECT  DECODE(rv_high_value, NULL, rv_low_value, a.tran_class)                                                              
                                                       FROM  CG_REF_CODES
                                                      WHERE  ((rv_high_value IS NULL AND a.tran_class IN  (rv_low_value, rv_abbreviation))
                                                              OR (a.tran_class BETWEEN  rv_low_value AND rv_high_value))
                                                        AND  ROWNUM = 1
                                                        AND  rv_domain = ''GIAC_ACCTRANS.TRAN_CLASS'')tran_class,
                                                    tran_class_no       ,
                                                    (SELECT  rv_meaning                                                              
                                                       FROM  CG_REF_CODES
                                                      WHERE  ((rv_high_value IS NULL AND a.tran_class IN  (rv_low_value, rv_abbreviation))
                                                              OR (a.tran_class BETWEEN  rv_low_value AND rv_high_value))
                                                        AND  ROWNUM = 1
                                                        AND  rv_domain = ''GIAC_ACCTRANS.TRAN_CLASS'') mean_tran_class,
                                                    posting_date        ,
                                                    (SELECT  DECODE(rv_high_value, NULL, rv_low_value, a.tran_flag)                                                              
                                                       FROM  CG_REF_CODES
                                                      WHERE  ((rv_high_value IS NULL AND a.tran_flag IN  (rv_low_value, rv_abbreviation))
                                                              OR (a.tran_flag BETWEEN  rv_low_value AND rv_high_value))
                                                        AND  ROWNUM = 1
                                                        AND  rv_domain = ''GIAC_ACCTRANS.TRAN_FLAG'') tran_flag,           
                                                    (SELECT  rv_meaning                                                              
                                                       FROM  CG_REF_CODES
                                                      WHERE  ((rv_high_value IS NULL AND a.tran_flag IN  (rv_low_value, rv_abbreviation))
                                                              OR (a.tran_flag BETWEEN  rv_low_value AND rv_high_value))
                                                        AND  ROWNUM = 1
                                                        AND  rv_domain = ''GIAC_ACCTRANS.TRAN_FLAG'') mean_tran_flag,
                                                    jv_no               ,
                                                    jv_pref_suff        ,
                                                    particulars         ,
                                                    user_id             ,
                                                    TO_CHAR(last_update, ''MM-DD-RRRR HH:MI:SS AM'')  last_update      
                                             FROM GIAC_ACCTRANS a
                                            WHERE gfun_fund_cd = '''||p_gfun_fund_cd||''' 
                                              AND EXISTS (SELECT ''X''
                                                            FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS070'','''||p_user_id||'''))
                                                           WHERE branch_cd = a.gibr_branch_cd ) ';
                                              IF p_gibr_branch_cd IS NOT NULL
                                                THEN
                                                    v_sql := v_sql ||' AND a.gibr_branch_cd = '''||p_gibr_branch_cd||''' ';
                                              END IF;
                                             
            IF p_tran_yy IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND tran_year = '''||p_tran_yy||''' ';
            END IF;
            IF p_tran_mm IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND tran_month = '''|| p_tran_mm||''' ';
            END IF;
            IF p_tran_seq_no IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND tran_seq_no = '''||p_tran_seq_no||''' ';
            END IF;
            IF p_str_tran_date IS NOT NULL 
                THEN
                 v_sql := v_sql || ' AND TRUNC(tran_date) = '''||p_str_tran_date||''' ';
            END IF;
            IF p_posting_date IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND TRUNC(posting_date) = '''||p_posting_date||''' ';
            END IF;
            IF p_tran_class IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(tran_class) = '''||p_tran_class||''' ';
            END IF;
            IF p_tran_flag IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(tran_flag) = '''||UPPER(p_tran_flag)||''' ';
            END IF;
          
              IF p_order_by IS NOT NULL
                  THEN
                    IF p_order_by = 'tranYy tranMm tranSeqNo'
                     THEN     
                        IF  NVL(p_asc_desc_flag, 'ASC') = 'ASC'
                            THEN     
                                v_sql := v_sql || ' ORDER BY tran_year ASC, tran_month ASC, tran_seq_no ';
                        ELSE
                                v_sql := v_sql || ' ORDER BY tran_year DESC, tran_month DESC, tran_seq_no ';
                        END IF;
                    ELSIF  p_order_by = 'strTrandate'
                     THEN
                      v_sql := v_sql || ' ORDER BY tran_date ';
                    ELSIF  p_order_by = 'postingDate'
                     THEN
                      v_sql := v_sql || ' ORDER BY posting_date ';
                    ELSIF  p_order_by = 'tranClass meanTranClass'
                     THEN
                         IF  NVL(p_asc_desc_flag, 'ASC') = 'ASC'
                            THEN 
                                v_sql := v_sql || ' ORDER BY tran_class ASC, mean_tran_class '; 
                         ELSE
                                v_sql := v_sql || ' ORDER BY tran_class DESC, mean_tran_class '; 
                         END IF;
                    ELSIF  p_order_by = 'tranFlag meanTranFlag'
                     THEN
                         IF  NVL(p_asc_desc_flag, 'ASC') = 'ASC'
                            THEN 
                                v_sql := v_sql || ' ORDER BY tran_flag ASC, mean_tran_flag '; 
                         ELSE
                                v_sql := v_sql || ' ORDER BY tran_flag DESC, mean_tran_flag '; 
                         END IF;
                    END IF;
                    
                    IF p_asc_desc_flag IS NOT NULL
                    THEN
                       v_sql := v_sql || p_asc_desc_flag;
                    ELSE
                       v_sql := v_sql || ' ASC '; 
                    END IF;                   
                 ELSE
                       v_sql := v_sql || ' ORDER BY tran_date DESC ';
                 END IF;
            
            v_sql := v_sql || ' )) innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
        OPEN c FOR v_sql;
            LOOP
                FETCH c INTO
                    res.count_              ,
                    res.rownum_             ,
                    res.tran_id             ,
                    res.gfun_fund_cd        ,
                    res.fund_desc           ,
                    res.grac_rac_cd         ,
                    res.gibr_branch_cd      ,
                    res.branch_name         ,
                    res.tran_year           ,
                    res.tran_month          ,
                    res.tran_seq_no         ,
                    res.tran_date           ,
                    res.tran_class          ,
                    res.tran_class_no       ,
                    res.mean_tran_class     ,
                    res.posting_date        ,
                    res.tran_flag           ,
                    res.mean_tran_flag      ,
                    res.jv_no               ,
                    res.jv_pref_suff        ,
                    res.particulars         ,
                    res.user_id             ,
                    res.last_update         ;
                    /*res.tran_id         := i.tran_id;
                    res.gfun_fund_cd    := i.gfun_fund_cd;
                    res.gibr_branch_cd  := i.gibr_branch_cd;
                    res.tran_year       := i.tran_year;
                    res.tran_month      := i.tran_month;
                    res.tran_seq_no     := i.tran_seq_no;
                    res.tran_date       := i.tran_date;
                    res.tran_class      := i.tran_class;
                    res.tran_class_no   := i.tran_class_no;
                    res.posting_date    := i.posting_date;
                    res.tran_flag       := i.tran_flag;
                    res.jv_no           := i.jv_no;
                    res.jv_pref_suff    := i.jv_pref_suff;
                    res.particulars     := i.particulars;
                    res.user_id         := i.user_id;
                    res.last_update     := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM'); 
                    
                    --:GACC POST-QUERY trigger
                    BEGIN
                        CHK_CHAR_REF_CODES(res.tran_flag, res.mean_tran_flag, 'GIAC_ACCTRANS.TRAN_FLAG');
                    EXCEPTION
                        WHEN no_data_found THEN
                            res.mean_tran_flag := null;
                    END;
                    
                    BEGIN
                        CHK_CHAR_REF_CODES(res.tran_class, res.mean_tran_class, 'GIAC_ACCTRANS.TRAN_CLASS');
                    EXCEPTION
                        WHEN no_data_found THEN
                            res.mean_tran_class := null;
                    END;
                 
                    BEGIN
                        CHK_GACC_GACC_GIBR_FK(TRUE, i.gibr_branch_cd, res.fund_desc, res.grac_rac_cd, res.branch_name);
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;    */       
            
           EXIT WHEN c%NOTFOUND;              
         PIPE ROW (res);
      END LOOP;      
     CLOSE c;            
    RETURN; 
    --pjsantos end
   END get_journal_entries_list;

    
    FUNCTION chk_payt_req_dtl(
        p_tran_id   GIAC_ACCTRANS.TRAN_ID%type 
    ) RETURN NUMBER
    AS
        v_dummy     NUMBER(1);
    BEGIN
        Begin 	
            SELECT 1
              INTO v_dummy
              FROM GIAC_PAYT_REQUESTS_DTL A,
                   GIAC_PAYT_REQUESTS B
             WHERE A.GPRQ_REF_ID = B.REF_ID
               AND A.TRAN_ID = P_TRAN_ID; 
        Exception
            when no_data_found then
                /*message('TRAN ID DOES NOT EXIST.',acknowledge);
                message('ok');
                clear_message;
                raise form_trigger_failure;*/
                NULL;
        End;
        
        begin
            SELECT 1
              INTO v_dummy
              FROM GIAC_DISB_VOUCHERS 
             WHERE GACC_TRAN_ID = P_TRAN_ID;
        exception
  	        when no_data_found then
     	        v_dummy := 0;
        end;
        
        RETURN (v_dummy);
    END chk_payt_req_dtl;
    
    
    PROCEDURE get_payt_request_menu(
        p_tran_id       IN      GIAC_ACCTRANS.TRAN_ID%type,
        p_payt_req_menu OUT     VARCHAR2,
        p_document_cd   OUT     VARCHAR2,
        p_cancel_req    OUT     VARCHAR2
    )
    AS
    BEGIN
        select c.param_name, b.DOCUMENT_CD
          into  p_payt_req_menu, p_document_cd  --shan: added document_cd
          from  giac_payt_requests_dtl a,
                giac_payt_requests b,
                giac_parameters  c,
                giac_acctrans d
         where  a.tran_id = d.tran_id
           and  a. tran_id  = p_tran_id
           and  a.gprq_ref_id =b.ref_id
           and  b.document_cd = c.param_value_v;
    EXCEPTION
        when no_data_found then
            p_payt_req_menu := null;
            p_cancel_req := 'N';
    END get_payt_request_menu;
    
    
    PROCEDURE get_dv_info( 
        p_tran_id       IN      GIAC_ACCTRANS.TRAN_ID%type,
        p_gacc_tran_id  OUT     GIAC_ACCTRANS.TRAN_ID%type,
        p_dv_tag        OUT     VARCHAR2,
        p_cancel_dv     OUT     VARCHAR2,
        p_formcall      OUT     VARCHAR2,
        p_gprq_ref_id   OUT     giac_payt_requests_dtl.GPRQ_REF_ID%type,
        p_payt_req_menu OUT     VARCHAR2,
        p_document_cd   OUT     VARCHAR2,
        p_cancel_req    OUT     VARCHAR2
    )
    AS
        V_DV_TAG  VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT DV_TAG
              INTO V_DV_TAG
              FROM GIAC_ACCTRANS A,GIAC_DISB_VOUCHERS B
             WHERE A.TRAN_ID = B.GACC_TRAN_ID
               AND B.GACC_TRAN_ID = P_TRAN_ID;
               
            BEGIN
                IF V_DV_TAG = '*' THEN
                    P_DV_TAG := 'M';
                ELSIF V_DV_TAG IS NULL THEN
                    P_DV_TAG := NULL;
                    P_CANCEL_DV:='N';
                END IF;
                
               P_FORMCALL:='GIACS002';
            END;
            
            p_gacc_tran_id := p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT  A.TRAN_ID
                      INTO  P_GACC_TRAN_ID  
                      FROM  GIAC_PAYT_REQUESTS_DTL A,
                            GIAC_PAYT_REQUESTS B
                     WHERE  A.GPRQ_REF_ID = B.REF_ID
                       AND  A.TRAN_ID = P_TRAN_ID;
                       
                    SELECT a.gprq_ref_id
                      INTO p_gprq_ref_id
                      FROM giac_payt_requests_dtl a,
                           giac_payt_requests b,
                           giac_acctrans c
                     WHERE a.tran_id = c.tran_id
                       AND a.tran_id  = p_tran_id
                       AND a.gprq_ref_id =b.ref_id;

                    GET_PAYT_REQUEST_MENU(p_tran_id, p_payt_req_menu, p_document_cd, p_cancel_req);
                    P_FORMCALL := 'GIACS016';
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#TRAN_ID DOES NOT EXIST.');
                END;
        END;
    END get_dv_info;
    
END GIACS070_PKG;
/



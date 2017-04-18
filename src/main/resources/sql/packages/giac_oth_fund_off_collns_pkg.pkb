CREATE OR REPLACE PACKAGE BODY CPI.giac_oth_fund_off_collns_pkg AS

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 14, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Function returns records from giac_oth_fund_off_collns 
**                   with gacc_tran_id as its parameter
*/  

FUNCTION get_oth_fund_off_collns (p_gacc_tran_id   GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE)

RETURN giac_oth_fund_off_collns_tab PIPELINED IS
    
    gofc_type       giac_oth_fund_off_collns_type;
    
    BEGIN
        FOR i IN (SELECT gacc_tran_id, gofc_gibr_gfun_fund_cd, 
                         gibr_branch_cd, item_no, 
                         transaction_type, collection_amt, 
                         gofc_gacc_tran_id, gibr_gfun_fund_cd,    
                         gofc_gibr_branch_cd, gofc_item_no, 
                         or_print_tag, particulars,
                         user_id, last_update
                  FROM giac_oth_fund_off_collns
                  WHERE gacc_tran_id = p_gacc_tran_id
                  ORDER BY item_no)
        
        LOOP
            gofc_type.gacc_tran_id              :=      i.gacc_tran_id;
            gofc_type.gofc_gibr_gfun_fund_cd    :=      i.gofc_gibr_gfun_fund_cd;
            gofc_type.gibr_branch_cd            :=      i.gibr_branch_cd;
            gofc_type.item_no                   :=      i.item_no;
            gofc_type.transaction_type          :=      i.transaction_type;
            gofc_type.collection_amt            :=      i.collection_amt;
            gofc_type.gofc_gacc_tran_id         :=      i.gofc_gacc_tran_id;
            gofc_type.gibr_gfun_fund_cd         :=      i.gibr_gfun_fund_cd;
            gofc_type.gofc_gibr_branch_cd       :=      i.gofc_gibr_branch_cd;
            gofc_type.gofc_item_no              :=      i.gofc_item_no;
            gofc_type.or_print_tag              :=      i.or_print_tag;
            gofc_type.particulars               :=      i.particulars;
            gofc_type.user_id                   :=      i.user_id;
            gofc_type.last_update               :=      i.last_update;
            gofc_type.old_tran_no               :=      NULL; -- used to reset the values of gofc_type.old_tran_no
            gofc_type.tran_year                 :=      NULL;
            gofc_type.tran_month                :=      NULL;
            gofc_type.tran_seq_no               :=      NULL;            
            gofc_type.gofc_gibr_branch_name     :=      NULL;
                        
            BEGIN
                SELECT  SUBSTR(rv_meaning,1,25)  rv_meaning
                INTO    gofc_type.transaction_type_desc
                FROM    CG_REF_CODES
                WHERE   rv_domain = 'GIAC_OTH_FUND_OFF_COLLNS.TRANSACTION_TYPE'
                AND rv_low_value = i.transaction_type;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            BEGIN
                SELECT branch_name
                INTO   gofc_type.gibr_branch_name
                FROM giac_branches
                WHERE branch_cd = i.gibr_branch_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;               
            
            BEGIN
                SELECT branch_name
                INTO gofc_type.gofc_gibr_branch_name
                FROM giac_branches
                WHERE branch_cd = i.gofc_gibr_branch_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            BEGIN
                SELECT tran_year ||'-'||TO_CHAR(tran_month,'09')||
                       '-'||TO_CHAR(tran_seq_no, '09999') old_tran_no,
                       tran_year, tran_month, tran_seq_no
                INTO gofc_type.old_tran_no, gofc_type.tran_year,
                     gofc_type.tran_month, gofc_type.tran_seq_no
                FROM GIAC_ACCTRANS
                WHERE tran_id = i.gofc_gacc_tran_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
                
            PIPE ROW(gofc_type);
            
        END LOOP; 
    
    END get_oth_fund_off_collns;
    
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 14, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Function returns list of valid fund_cds and branches
**                   
*/  
    
FUNCTION get_gofc_gibr_gfun_fund_list   (p_module    GIAC_MODULES.module_name%TYPE,
                                         p_user_id   GIIS_USERS.user_id%TYPE)

RETURN gofc_gibr_gfun_fund_tab PIPELINED IS
        
     v_fund                  gofc_gibr_gfun_fund_type;
     
     BEGIN
        FOR f IN (SELECT gibr.gfun_fund_cd  gibr_gfun_fund_cd
                        ,gibr.branch_cd  gibr_branch_cd
                        ,gfun.fund_desc  fund_desc
                        ,gibr.branch_name  branch_name
                         FROM   giac_branches gibr
                               ,giis_funds gfun
                         WHERE  gfun.fund_cd = gibr.gfun_fund_cd
                         AND gibr.branch_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(NULL,gibr.branch_cd,p_module, p_user_id),1,gibr.branch_cd,NULL))
       LOOP
            v_fund.gibr_gfun_fund_cd    :=      f.gibr_gfun_fund_cd;
            v_fund.gibr_branch_cd       :=      f.gibr_branch_cd;
            v_fund.fund_desc            :=      f.fund_desc;
            v_fund.branch_name          :=      f.branch_name;          
            PIPE ROW(v_fund);
       END LOOP;
            
     END get_gofc_gibr_gfun_fund_list;
     
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 14, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Function returns list of valid transaction nos.
**                   
*/ 
     
FUNCTION get_old_tran_no_list (p_keyword    VARCHAR2)
    RETURN gofc_gacc_tab PIPELINED IS 
    
    v_tran_no           gofc_gacc_type;
    
    BEGIN
        FOR i IN (  SELECT gofc1.gibr_gfun_fund_cd gofc_gibr_gfun_fund_cd, 
                           gofc1.gibr_branch_cd gofc_gibr_branch_cd, 
                           gacc.tran_year tran_year, 
                           gacc.tran_month tran_month, 
                           gacc.tran_seq_no tran_seq_no,
                           gacc.tran_year ||'-'|| TO_CHAR(gacc.tran_month, '09')|| 
                           '-'|| TO_CHAR(gacc.tran_seq_no, '09999') old_tran_no,
                           gofc1.item_no gofc_item_no, 
                           gofc1.gacc_tran_id gacc_tran_id, 
                           gacc.gfun_fund_cd gfun_fund_cd, 
                           gacc.gibr_branch_cd gibr_branch_cd, 
                           gacc.tran_date tran_date, 
                           gacc.tran_flag tran_flag, 
                           gacc.tran_class tran_class, 
                           gacc.tran_class_no tran_class_no, 
                           gacc.jv_no jv_no, 
                           gofc1.gofc_gacc_tran_id gofc_gacc_tran_id 
                    FROM GIAC_OTH_FUND_OFF_COLLNS gofc1, 
                         GIAC_ACCTRANS gacc 
                    WHERE gacc.tran_id = gofc1.gacc_tran_id 
                    AND gofc1.transaction_type = 1 
                    AND gacc.tran_id NOT IN (SELECT c.gacc_tran_id 
                                             FROM GIAC_REVERSALS c)
                    AND (UPPER(gofc1.gibr_gfun_fund_cd) LIKE '%'|| UPPER(p_keyword) ||'%' OR
                         UPPER(gofc1.gibr_branch_cd) LIKE '%'|| UPPER(p_keyword) ||'%' OR
                         UPPER(gacc.tran_year) LIKE '%'|| UPPER(p_keyword) ||'%' OR
                         UPPER(gacc.tran_month) LIKE '%'|| UPPER(p_keyword) ||'%' OR
                         UPPER(gacc.tran_seq_no) LIKE '%'|| UPPER(p_keyword) ||'%' OR
                         UPPER(gofc1.item_no) LIKE '%'|| UPPER(p_keyword) ||'%'                            
                         ) 
                    ORDER BY gofc1.gofc_gibr_gfun_fund_cd, 
                             gofc1.gibr_branch_cd, 
                             gacc.tran_year, 
                             gacc.tran_month, 
                             gacc.tran_seq_no, 
                             gofc1.item_no)
       
        LOOP
            v_tran_no.gofc_gibr_gfun_fund_cd    :=    i.gofc_gibr_gfun_fund_cd;
            v_tran_no.gofc_gibr_branch_cd       :=    i.gofc_gibr_branch_cd;
            v_tran_no.tran_year                 :=    i.tran_year;
            v_tran_no.tran_month                :=    i.tran_month;
            v_tran_no.tran_seq_no               :=    i.tran_seq_no;
            v_tran_no.old_tran_no               :=    i.old_tran_no;
            v_tran_no.item_no                   :=    i.gofc_item_no;
            v_tran_no.gacc_tran_id              :=    i.gacc_tran_id;
            v_tran_no.gfun_fund_cd              :=    i.gfun_fund_cd;
            v_tran_no.gibr_branch_cd            :=    i.gibr_branch_cd;
            v_tran_no.tran_date                 :=    i.tran_date;
            v_tran_no.tran_flag                 :=    i.tran_flag;
            v_tran_no.tran_class                :=    i.tran_class;
            v_tran_no.tran_class_no             :=    i.tran_class_no;
            v_tran_no.jv_no                     :=    i.jv_no;
            v_tran_no.gofc_gacc_tran_id         :=    i.gofc_gacc_tran_id;
            
            BEGIN
                SELECT fund_desc
                INTO v_tran_no.gofc_gibr_gfun_fund_desc
                FROM GIIS_FUNDS
                WHERE fund_cd = i.gofc_gibr_gfun_fund_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            BEGIN
                SELECT branch_name
                INTO v_tran_no.gofc_gibr_branch_name
                FROM GIAC_BRANCHES
                WHERE branch_cd = i.gofc_gibr_branch_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            PIPE ROW (v_tran_no);
            
        END LOOP;
    END get_old_tran_no_list;
    
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure gets the default collection amount for a given
**                   transaction no, gibr_gfun_fund_cd, gibr_branch_cd, and item_no
*/  

PROCEDURE get_default_amount
    (p_tran_year                IN       GIAC_ACCTRANS.tran_year%TYPE,
     p_tran_month               IN       GIAC_ACCTRANS.tran_month%TYPE,
     p_tran_seq_no              IN       GIAC_ACCTRANS.tran_seq_no%TYPE,
     p_gofc_gibr_gfun_fund_cd   IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
     p_gofc_gibr_branch_cd      IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
     p_gofc_item_no             IN       GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
     p_gacc_tran_id             OUT      GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
     p_default_colln_amt        OUT      GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE, 
     p_message                  OUT      VARCHAR2)
     
    IS

    v_default_colln_amt        GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE;
    v_collection_amt        GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE;
    v_old_colln_amt            GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE;
    v_tran_id                GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE;

BEGIN
    p_message := 'SUCCESS';
    
    BEGIN
        CHECK_OLD_ITEM (p_tran_year, p_tran_month, p_tran_seq_no,  p_gofc_gibr_gfun_fund_cd,
                        p_gofc_gibr_branch_cd, p_gofc_item_no, v_tran_id, v_old_colln_amt, p_message);
    END;
    
    BEGIN
        --Gets the sum of previously reclassified/refund amount for the item 
        SELECT SUM(a.collection_amt)
          INTO v_collection_amt
          FROM giac_oth_fund_off_collns a ,giac_acctrans b
         WHERE b.tran_id                = a.gofc_gacc_tran_id
           AND transaction_type         = 2
           AND b.tran_year              = p_tran_year
           AND b.tran_month             = p_tran_month
           AND b.tran_seq_no            = p_tran_seq_no
           AND a.gofc_gibr_gfun_fund_cd = p_gofc_gibr_gfun_fund_cd
           AND a.gofc_gibr_branch_cd    = p_gofc_gibr_branch_cd
           AND a.gofc_item_no           = p_gofc_item_no 
           AND b.tran_flag              <>'D'
           AND a.gofc_gacc_tran_id      = v_tran_id
           AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                   FROM giac_reversals c);

           v_default_colln_amt := v_old_colln_amt - NVL(abs(v_collection_amt),0);
           
           IF v_default_colln_amt = 0 THEN
              p_message := 'This bill has been fully refunded.';
           END IF;
        
           p_default_colln_amt := (v_default_colln_amt) * -1;
           p_gacc_tran_id      := v_tran_id;
    END;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    
  END;
  
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure validates the deletion of the record if permitted    
**                   by checking the existence of rows in related tables.                    
*/ 

PROCEDURE chk_giac_oth_fund_off_col(
   p_check_both        IN       BOOLEAN       
  ,p_gibr_branch_cd    IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE      
  ,p_gibr_gfun_fund_cd IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE      
  ,p_item_no           IN       GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE       
  ,p_gacc_tran_id      IN       GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE
  ,p_message           OUT      VARCHAR2) 
  
   IS  

  cg$dummy VARCHAR2(1);
    
BEGIN
  
  IF (p_check_both) THEN
    
    /* deletion of giac_oth_fund_off_collns prevented if giac_oth_fund 
      foreign key(s): gofc_gofc_fk */
      
    DECLARE
      CURSOR C IS
        SELECT  '1'
        FROM    giac_oth_fund_off_collns gofc
        WHERE   (gofc.gofc_gibr_branch_cd = p_gibr_branch_cd OR 
                (gofc.gofc_gibr_branch_cd IS NULL AND    
                 p_gibr_branch_cd IS NULL ))
        AND     (gofc.gofc_gibr_gfun_fund_cd = p_gibr_gfun_fund_cd OR 
                (gofc.gofc_gibr_gfun_fund_cd IS NULL AND    
                 p_gibr_gfun_fund_cd IS NULL ))
        AND     (gofc.gofc_item_no = p_item_no OR 
                (gofc.gofc_item_no IS NULL AND    
                 p_item_no IS NULL ))
        AND     (gofc.gofc_gacc_tran_id = p_gacc_tran_id OR 
                (gofc.gofc_gacc_tran_id IS NULL AND    
                 p_gacc_tran_id IS NULL ));
    BEGIN
      p_message := 'SUCCESS';
      
      OPEN C;
      FETCH C
      INTO    cg$dummy;
      
      IF C%FOUND THEN
        p_message := 'Delete not allowed. A refund transaction exists for this record.';
      END IF;
      CLOSE C;
      
    END;
  END IF;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure insert/update records in GIAC_OTH_FUND_OFF_COLLNS table   
**                                      
*/ 

PROCEDURE set_giac_oth_fund_off_collns
(p_gacc_tran_id                GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
 p_gibr_gfun_fund_cd        GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
 p_gibr_branch_cd            GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
 p_item_no                    GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
 p_tran_type                GIAC_OTH_FUND_OFF_COLLNS.transaction_type%TYPE,
 p_colln_amt                GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE,
 p_gofc_gacc_tran_id        GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE,
 p_gofc_gibr_gfun_fund_cd    GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_gfun_fund_cd%TYPE,
 p_gofc_gibr_branch_cd        GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_branch_cd%TYPE,
 p_gofc_item_no                GIAC_OTH_FUND_OFF_COLLNS.gofc_item_no%TYPE,
 p_or_print_tag                GIAC_OTH_FUND_OFF_COLLNS.or_print_tag%TYPE,
 p_particulars                GIAC_OTH_FUND_OFF_COLLNS.particulars%TYPE)
 
 IS
 
 BEGIN
    MERGE INTO GIAC_OTH_FUND_OFF_COLLNS
    USING DUAL ON (gacc_tran_id         = p_gacc_tran_id
               AND gibr_gfun_fund_cd    = p_gibr_gfun_fund_cd
               AND gibr_branch_cd        = p_gibr_branch_cd
               AND item_no                = p_item_no)
               
    WHEN NOT MATCHED THEN
        INSERT (gacc_tran_id,            gibr_gfun_fund_cd,             gibr_branch_cd, 
                item_no,                transaction_type,            collection_amt,
                gofc_gacc_tran_id,        gofc_gibr_gfun_fund_cd,        gofc_gibr_branch_cd,
                gofc_item_no,            or_print_tag,                particulars,
                user_id,                last_update)
        VALUES (p_gacc_tran_id,            p_gibr_gfun_fund_cd,        p_gibr_branch_cd,
                p_item_no,                p_tran_type,                p_colln_amt,
                p_gofc_gacc_tran_id,    p_gofc_gibr_gfun_fund_cd,    p_gofc_gibr_branch_cd,
                p_gofc_item_no,            p_or_print_tag,                p_particulars,
                NVL(giis_users_pkg.app_user, USER),                    SYSDATE)
    WHEN MATCHED THEN
        
        UPDATE SET  transaction_type         = p_tran_type,
                    collection_amt             = p_colln_amt,
                    gofc_gacc_tran_id        = p_gofc_gacc_tran_id,
                    gofc_gibr_gfun_fund_cd     = p_gofc_gibr_gfun_fund_cd,
                    gofc_gibr_branch_cd        = p_gofc_gibr_branch_cd,
                    gofc_item_no            = p_gofc_item_no,
                    or_print_tag            = p_or_print_tag,
                    particulars                = p_particulars,
                    user_id                    = NVL(giis_users_pkg.app_user, USER),
                    last_update                = SYSDATE;
                    
 END set_giac_oth_fund_off_collns;
 
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure delete records in GIAC_OTH_FUND_OFF_COLLNS table   
**                                      
*/ 
 
PROCEDURE del_giac_oth_fund_off_collns
(p_gacc_tran_id                GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
 p_gibr_gfun_fund_cd        GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
 p_gibr_branch_cd            GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
 p_item_no                    GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE)
 
 IS
 
BEGIN
    DELETE 
    FROM GIAC_OTH_FUND_OFF_COLLNS
    WHERE gacc_tran_id        = p_gacc_tran_id
      AND gibr_gfun_fund_cd    = p_gibr_gfun_fund_cd
      AND gibr_branch_cd    = p_gibr_branch_cd
      AND item_no            = p_item_no;
    
END del_giac_oth_fund_off_collns;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure executes post_forms_commit trigger in GIACS012  
**                                      
*/ 

PROCEDURE post_forms_commit_giacs012(
p_gacc_tran_id                GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
p_tran_source                VARCHAR2,
p_or_flag                    VARCHAR2)

IS

BEGIN
  IF p_tran_source IN ('OP', 'OR') THEN
        IF p_or_flag = 'P' THEN
          NULL;
        ELSE
          update_giac_op_text_giac012(p_gacc_tran_id);
        END IF;

  ELSIF  p_tran_source = 'DV' THEN
  
     update_giac_dv_text(p_gacc_tran_id);
  
  END IF;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure updates either debit_amt or credit_amt depending on
**                   the value of the collection amount
*/  
    
    PROCEDURE update_acct_entries 
    (p_gacc_branch_cd        GIAC_ACCTRANS.gibr_branch_cd%TYPE,
     p_gacc_fund_cd          GIAC_ACCTRANS.gfun_fund_cd%TYPE,
     p_gacc_tran_id          GIAC_ACCTRANS.tran_id%TYPE,
     p_collection_amt         GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE,
     uae_gl_acct_category       GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     uae_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     uae_gl_sub_acct_1          GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     uae_gl_sub_acct_2          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     uae_gl_sub_acct_3          GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     uae_gl_sub_acct_4          GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     uae_gl_sub_acct_5          GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     uae_gl_sub_acct_6          GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     uae_gl_sub_acct_7          GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE) 
IS
    
BEGIN
    IF p_collection_amt < 0 THEN
         UPDATE giac_acct_entries
         SET debit_amt = debit_amt + ABS(p_collection_amt)
         WHERE gacc_gibr_branch_cd =  p_gacc_branch_cd
           AND gacc_gfun_fund_cd   =  p_gacc_fund_cd 
           AND gacc_tran_id        =  p_gacc_tran_id
           AND gl_acct_category       =  uae_gl_acct_category      
           AND gl_control_acct        =  uae_gl_control_acct           
           AND gl_sub_acct_1       =  uae_gl_sub_acct_1     
           AND gl_sub_acct_2       =  uae_gl_sub_acct_2     
           AND gl_sub_acct_3       =  uae_gl_sub_acct_3     
           AND gl_sub_acct_4       =  uae_gl_sub_acct_4     
           AND gl_sub_acct_5       =  uae_gl_sub_acct_5          
           AND gl_sub_acct_6       =  uae_gl_sub_acct_6          
           AND gl_sub_acct_7       =  uae_gl_sub_acct_7;     

    ELSIF p_collection_amt > 0 THEN
         UPDATE giac_acct_entries
         SET credit_amt = credit_amt + ABS(p_collection_amt) 
         WHERE gacc_gibr_branch_cd =  p_gacc_branch_cd
           AND gacc_gfun_fund_cd   =  p_gacc_fund_cd
           AND gacc_tran_id        =  p_gacc_tran_id
           AND gl_acct_category       =  uae_gl_acct_category      
           AND gl_control_acct        =  uae_gl_control_acct           
           AND gl_sub_acct_1       =  uae_gl_sub_acct_1     
           AND gl_sub_acct_2       =  uae_gl_sub_acct_2     
           AND gl_sub_acct_3       =  uae_gl_sub_acct_3     
           AND gl_sub_acct_4       =  uae_gl_sub_acct_4     
           AND gl_sub_acct_5       =  uae_gl_sub_acct_5          
           AND gl_sub_acct_6       =  uae_gl_sub_acct_6          
           AND gl_sub_acct_7       =  uae_gl_sub_acct_7;     

        END IF;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  This procedure determines whether the records will be updated or inserted  
**                   in GIAC_ACCT_ENTRIES.
*/ 
        
   PROCEDURE aeg_ins_upd_acct_entr_giacs012
    (p_gacc_gibr_branch_cd         GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
     p_gacc_gfun_fund_cd        GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
     p_global_gibr_branch_cd      GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
     p_global_gfun_fund_cd          GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
     p_gacc_tran_id                GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
     iuae_gl_acct_category      GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     iuae_gl_control_acct       GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     iuae_gl_sub_acct_1         GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     iuae_gl_sub_acct_2         GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     iuae_gl_sub_acct_3         GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     iuae_gl_sub_acct_4         GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     iuae_gl_sub_acct_5         GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     iuae_gl_sub_acct_6         GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     iuae_gl_sub_acct_7         GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     iuae_sl_cd                 GIAC_ACCT_ENTRIES.sl_cd%TYPE,
     iuae_generation_type       GIAC_ACCT_ENTRIES.generation_type%TYPE,
     iuae_gl_acct_id            GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     iuae_debit_amt             GIAC_ACCT_ENTRIES.debit_amt%TYPE,
     iuae_credit_amt            GIAC_ACCT_ENTRIES.credit_amt%TYPE) 
IS
      
     iuae_acct_entry_id         GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;

BEGIN
    BEGIN
      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_global_gibr_branch_cd
         AND gacc_gfun_fund_cd   = p_global_gfun_fund_cd
         AND gacc_tran_id        = p_gacc_tran_id
         AND gl_acct_category    = iuae_gl_acct_category
         AND gl_control_acct     = iuae_gl_control_acct
         AND gl_sub_acct_1       = iuae_gl_sub_acct_1     
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2  
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3  
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4  
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5  
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6  
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7;

      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
        INSERT into GIAC_ACCT_ENTRIES(gacc_tran_id           , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd    , acct_entry_id    ,
                                      gl_acct_id             , gl_acct_category,
                                      gl_control_acct        , gl_sub_acct_1,
                                      gl_sub_acct_2          , gl_sub_acct_3,
                                      gl_sub_acct_4          , gl_sub_acct_5,
                                      gl_sub_acct_6          , gl_sub_acct_7,
                                      sl_cd                     , debit_amt,
                                      credit_amt             , generation_type,
                                      user_id                , last_update)
           VALUES ( p_gacc_tran_id               , p_gacc_gfun_fund_cd,  
                   p_gacc_gibr_branch_cd         , iuae_acct_entry_id,
                   iuae_gl_acct_id               , iuae_gl_acct_category,
                   iuae_gl_control_acct          , iuae_gl_sub_acct_1,
                   iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3,
                   iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5,
                   iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7,
                   iuae_sl_cd                      , iuae_debit_amt,
                   iuae_credit_amt               , iuae_generation_type,
                   NVL(giis_users_pkg.app_user, USER)                              , SYSDATE);
    
          ELSE
            UPDATE giac_acct_entries
               SET debit_amt  = debit_amt  + iuae_debit_amt,
                   credit_amt = credit_amt + iuae_credit_amt
             WHERE generation_type     = iuae_generation_type
               AND gl_acct_id          = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = p_global_gibr_branch_cd
               AND gacc_gfun_fund_cd   = p_global_gfun_fund_cd
               AND gacc_tran_id        = p_gacc_tran_id;

         END IF;
    END;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  This procedure handles the creation of accounting entries per transaction.
**                   
*/ 
PROCEDURE aeg_create_acct_entr_giacs012
  (p_gacc_gibr_branch_cd        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
   p_gacc_gfun_fund_cd            GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
   p_global_gibr_branch_cd      GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
   p_global_gfun_fund_cd          GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
   p_gacc_tran_id                GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
   aeg_module_id                GIAC_MODULE_ENTRIES.module_id%TYPE,
   aeg_item_no                  GIAC_MODULE_ENTRIES.item_no%TYPE,
   aeg_acct_amt                 GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
   aeg_gen_type                 GIAC_ACCT_ENTRIES.generation_type%TYPE,
   p_message          OUT        VARCHAR2) IS

  ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
  ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
  ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
  ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
  ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
  ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
  ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
  ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
  ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
  ws_line_cd                       GIIS_LINE.line_cd%TYPE;
  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
  ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
  ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
  ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
  ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
  ws_sl_cd                              GIAC_ACCT_ENTRIES.sl_cd%TYPE; 

  BEGIN

  /**************************************************************************
  *                                                                         *
  * Populate the GL Account Code used in every transactions.                *
  *                                                                         *
  **************************************************************************/

      BEGIN
        p_message := 'SUCCESS';
        SELECT gl_acct_category,    gl_control_acct,
               gl_sub_acct_1   ,    gl_sub_acct_2  ,
               gl_sub_acct_3   ,    gl_sub_acct_4  ,
               gl_sub_acct_5   ,    gl_sub_acct_6  ,
               gl_sub_acct_7   ,    pol_type_tag   ,
               intm_type_level ,    old_new_acct_level,
               dr_cr_tag       ,    line_dependency_level
          INTO ws_gl_acct_category, ws_gl_control_acct,
               ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
               ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
               ws_gl_sub_acct_7   , ws_pol_type_tag   ,
               ws_intm_type_level , ws_old_new_acct_level,
               ws_dr_cr_tag       , ws_line_dep_level
          FROM giac_module_entries
         WHERE module_id = aeg_module_id
           AND item_no   = 1

        FOR UPDATE of gl_sub_acct_1;
      EXCEPTION
        WHEN no_data_found THEN
          p_message := 'No data found in giac_module_entries.';
      END;

  /**************************************************************************
  *                                                                         *
  * Validate the  ACCT_BRANCH_CD value which indicates the segment of the   *
  * GL account code that holds the branch code.                             *
  *                                                                         *
  **************************************************************************/

    SELECT acct_branch_cd
      INTO ws_sl_cd
      FROM giac_branches
     WHERE GFUN_FUND_CD = p_gacc_gfun_fund_cd
       AND BRANCH_CD    = p_gacc_gibr_branch_cd;    

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/

    GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts
                            (ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                             ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                             ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                             ws_gl_acct_id        , p_message);

  /****************************************************************************
  *                                                                           *
  * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
  * debit-credit tag to determine whether the positive amount will be debited *
  * or credited.                                                              *
  *                                                                           *
  ****************************************************************************/

    IF ws_dr_cr_tag = 'D' THEN
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      ELSE
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      END IF;
    ELSE
      IF aeg_acct_amt > 0 THEN
        ws_debit_amt  := 0;
        ws_credit_amt := ABS(aeg_acct_amt);
      ELSE
        ws_debit_amt  := ABS(aeg_acct_amt);
        ws_credit_amt := 0;
      END IF;
    END IF;
  /****************************************************************************
  *                                                                           *
  * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
  * same transaction id.  Insert the record if it does not exists else update *
  * the existing record.                                                      *
  *                                                                           *
  ****************************************************************************/

   GIAC_OTH_FUND_OFF_COLLNS_PKG.aeg_ins_upd_acct_entr_giacs012(
                                  p_gacc_gibr_branch_cd     , p_gacc_gfun_fund_cd  , 
                                  p_global_gibr_branch_cd   , p_global_gfun_fund_cd , p_gacc_tran_id       ,        
                                  ws_gl_acct_category       , ws_gl_control_acct    , ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2          , ws_gl_sub_acct_3      , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5          , ws_gl_sub_acct_6      , ws_gl_sub_acct_7,
                                  ws_sl_cd                  , aeg_gen_type          , ws_gl_acct_id   ,        
                                  ws_debit_amt              , ws_credit_amt);
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure executes post_forms_commit trigger in GIACS012  
**                                      
*/ 

PROCEDURE aeg_parameters
   (p_global_gibr_branch_cd      GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
    p_global_gfun_fund_cd          GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
    p_gacc_tran_id              GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_module_name               GIAC_MODULES.module_name%TYPE,
    p_message           OUT     VARCHAR2) IS
   
    v_module_id                 GIAC_MODULES.module_id%TYPE;        
    v_gen_type                  GIAC_MODULES.generation_type%TYPE;
    v_credit_amt                GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    v_debit_amt                 GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_dummy                     VARCHAR2(1);
    
    CURSOR C IS
        SELECT gacc_tran_id, gibr_branch_cd, item_no, 
               collection_amt, gibr_gfun_fund_cd                      
        FROM GIAC_OTH_FUND_OFF_COLLNS
        WHERE gacc_tran_id = p_gacc_tran_id;

           
BEGIN
    p_message := 'SUCCESS';
  BEGIN    
    SELECT module_id,
           generation_type
      INTO v_module_id,
           v_gen_type
      FROM giac_modules
     WHERE module_name  = p_module_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_message := 'No data found in GIAC MODULES.';
  END;
  
   /*
   ** Call the deletion of accounting entry procedure.
   */
          
    GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type);

    /*
    ** Call the accounting entry generation procedure.
    */
  BEGIN  
    FOR GL_rec IN(SELECT gl_acct_category, gl_control_acct,
                         gl_sub_acct_1   , gl_sub_acct_2  ,
                         gl_sub_acct_3   , gl_sub_acct_4  ,
                         gl_sub_acct_5   , gl_sub_acct_6  ,
                         gl_sub_acct_7   , pol_type_tag   ,
                         intm_type_level , old_new_acct_level,
                         dr_cr_tag       , line_dependency_level
                  FROM giac_module_entries
                  WHERE module_id = v_module_id
                  AND item_no   = 1)
        LOOP
            FOR C_rec IN C
                LOOP    
                    BEGIN
                     SELECT 'x', credit_amt, debit_amt
                     INTO v_dummy, v_credit_amt, v_debit_amt
                     FROM GIAC_ACCT_ENTRIES
                     WHERE gacc_gibr_branch_cd =  C_rec.gibr_branch_cd
                       AND gacc_gfun_fund_cd   =  C_rec.gibr_gfun_fund_cd
                       AND gacc_tran_id        =  p_gacc_tran_id
                       AND gl_acct_category    =  gl_rec.gl_acct_category    
                       AND gl_control_acct     =  gl_rec.gl_control_acct        
                       AND gl_sub_acct_1       =  gl_rec.gl_sub_acct_1       
                       AND gl_sub_acct_2       =  gl_rec.gl_sub_acct_2       
                       AND gl_sub_acct_3       =  gl_rec.gl_sub_acct_3       
                       AND gl_sub_acct_4       =  gl_rec.gl_sub_acct_4       
                       AND gl_sub_acct_5       =  gl_rec.gl_sub_acct_5       
                       AND gl_sub_acct_6       =  gl_rec.gl_sub_acct_6       
                       AND gl_sub_acct_7       =  gl_rec.gl_sub_acct_7;
                                        
                     GIAC_OTH_FUND_OFF_COLLNS_PKG.update_acct_entries(
                                C_rec.gibr_branch_cd    ,C_rec.gibr_gfun_fund_cd,
                                p_gacc_tran_id          ,C_rec.collection_amt,
                                GL_REC.GL_ACCT_CATEGORY ,GL_REC.GL_CONTROL_ACCT, 
                                GL_REC.GL_SUB_ACCT_1    ,GL_REC.GL_SUB_ACCT_2,
                                GL_REC.GL_SUB_ACCT_3    ,GL_REC.GL_SUB_ACCT_4,
                                GL_REC.GL_SUB_ACCT_5    ,GL_REC.GL_SUB_ACCT_6,
                                GL_REC.GL_SUB_ACCT_7);  

                  EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                         GIAC_OTH_FUND_OFF_COLLNS_PKG.aeg_create_acct_entr_giacs012
                                (C_rec.gibr_branch_cd,      C_rec.gibr_gfun_fund_cd,
                                 p_global_gibr_branch_cd,   p_global_gfun_fund_cd,
                                 p_gacc_tran_id,            v_module_id,
                                 C_rec.item_no,             C_rec.collection_amt,
                                 v_gen_type,                p_message);
                  END;
              END LOOP;
        END LOOP;
    
  END;
  
END;            
    
END GIAC_OTH_FUND_OFF_COLLNS_PKG;
/



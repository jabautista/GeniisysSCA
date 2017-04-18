DROP PROCEDURE CPI.CHK_GOFC_GOFC_GOFC_FK;

CREATE OR REPLACE PROCEDURE CPI.chk_gofc_gofc_gofc_fk(
   p_gofc_gibr_gfun_fund_cd  IN     GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
   p_gofc_gibr_branch_cd     IN     GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
   p_gofc_item_no            IN     GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
   p_gofc_gacc_tran_id       IN     GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE,
   p_msg_alert               OUT    VARCHAR2) 
   
   IS 

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 12.29.2010
**  Reference By     : GIACS012 - Collection From Other Offices
**  Description 	: This procedure checks if the fund_cd and branch_cd exist
**                    for refund/reclassification purposes.
*/ 
   
   v_gofc_gacc_tran_id          GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE;
   v_gfun_fund_cd               GIAC_ACCTRANS.gfun_fund_cd%TYPE;
   v_gibr_branch_cd             GIAC_ACCTRANS.gibr_branch_cd%TYPE;
   v_tran_year                  GIAC_ACCTRANS.tran_year%TYPE;
   v_tran_month                 GIAC_ACCTRANS.tran_month%TYPE;
   v_tran_seq_no                GIAC_ACCTRANS.tran_seq_no%TYPE;
   v_tran_date                  GIAC_ACCTRANS.tran_date%TYPE;
   v_tran_flag                  GIAC_ACCTRANS.tran_flag%TYPE;
   v_tran_class                 GIAC_ACCTRANS.tran_class%TYPE;
   v_tran_class_no              GIAC_ACCTRANS.tran_class_no%TYPE;
   v_jv_no                      GIAC_ACCTRANS.jv_no%TYPE;

BEGIN
    p_msg_alert := 'SUCCESS';
    
    DECLARE
      CURSOR C IS
        SELECT gofc1.gofc_gacc_tran_id
              ,gacc.gfun_fund_cd
              ,gacc.gibr_branch_cd
              ,gacc.tran_year
              ,gacc.tran_month
              ,gacc.tran_seq_no
              ,gacc.tran_date
              ,gacc.tran_flag
              ,gacc.tran_class
              ,gacc.tran_class_no
              ,gacc.jv_no
        FROM   GIAC_OTH_FUND_OFF_COLLNS gofc1
              ,GIAC_ACCTRANS gacc
        WHERE  (gofc1.gibr_branch_cd = p_gofc_gibr_branch_cd OR 
               (gofc1.gibr_branch_cd IS NULL AND    
                p_gofc_gibr_branch_cd IS NULL ))
        AND    (gofc1.gibr_gfun_fund_cd = p_gofc_gibr_gfun_fund_cd
        OR 
               (gofc1.gibr_gfun_fund_cd IS NULL AND    
                p_gofc_gibr_gfun_fund_cd IS NULL ))
        AND    (gofc1.item_no = p_gofc_item_no OR 
               (gofc1.item_no IS NULL AND    
                p_gofc_item_no IS NULL ))
        AND    (gofc1.gacc_tran_id = p_gofc_gacc_tran_id OR 
               (gofc1.gacc_tran_id IS NULL AND    
                p_gofc_gacc_tran_id IS NULL ))
        AND     transaction_type = 1
        AND    gacc.tran_id = gofc1.gacc_tran_id;
    BEGIN
      OPEN C;
      FETCH C
      INTO   v_gofc_gacc_tran_id
            ,v_gfun_fund_cd
            ,v_gibr_branch_cd
            ,v_tran_year
            ,v_tran_month
            ,v_tran_seq_no
            ,v_tran_date
            ,v_tran_flag
            ,v_tran_class
            ,v_tran_class_no
            ,v_jv_no;
      
      IF C%NOTFOUND THEN
        p_msg_alert := 'This Old Branch Cd, Old Fund Cd, Old Item No. does not exist';
                
      END IF;
      CLOSE C;
    END;
  
END;
/



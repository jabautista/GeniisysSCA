DROP PROCEDURE CPI.CHECK_OLD_ITEM;

CREATE OR REPLACE PROCEDURE CPI.CHECK_OLD_ITEM 
    (p_tran_year                IN       GIAC_ACCTRANS.tran_year%TYPE,
     p_tran_month               IN       GIAC_ACCTRANS.tran_month%TYPE,
     p_tran_seq_no              IN       GIAC_ACCTRANS.tran_seq_no%TYPE,
     p_gofc_gibr_gfun_fund_cd   IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
     p_gofc_gibr_branch_cd      IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
     p_gofc_item_no             IN       GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
     p_tran_id                  OUT      GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
     p_collection_amt           OUT      GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE, 
     p_message                  OUT      VARCHAR2)
 
IS

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 12.21.2010
**  Reference By     : GIACS012 - Collection From Other Offices
**  Description 	: This procedure checks if the old_item_no exist and 
**                    gets the collection_amt of the item being reclassified/refund	
*/
    v_count                      NUMBER;
    v_tran_id                    GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE;
    v_old_collection_amt         GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE;
    
    
BEGIN
     p_message     := 'SUCCESS';
     
     SELECT COUNT(a.item_no)
       INTO v_count
       FROM giac_oth_fund_off_collns a
           ,giac_acctrans b
      WHERE b.tran_id           = a.gacc_tran_id
        AND transaction_type    = 1
        AND b.tran_year         =  p_tran_year
        AND b.tran_month        =  p_tran_month
        AND b.tran_seq_no       =  p_tran_seq_no
        AND a.gibr_gfun_fund_cd =  p_gofc_gibr_gfun_fund_cd
        AND a.gibr_branch_cd    =  p_gofc_gibr_branch_cd
        AND a.item_no           =  p_gofc_item_no
        AND b.tran_flag         <>'D'
        AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                  FROM giac_reversals c);
     
     IF v_count>0 THEN        
        BEGIN
          --Gets the collection_amt of the item being reclassified/refund

          SELECT a.collection_amt,a.gacc_tran_id
            INTO v_old_collection_amt,v_tran_id
            FROM giac_oth_fund_off_collns a
                ,giac_acctrans b
           WHERE b.tran_id           = a.gacc_tran_id
             AND transaction_type    = 1
             AND b.tran_year         = p_tran_year
             AND b.tran_month        = p_tran_month
             AND b.tran_seq_no       = p_tran_seq_no
             AND a.gibr_gfun_fund_cd = p_gofc_gibr_gfun_fund_cd
             AND a.gibr_branch_cd    = p_gofc_gibr_branch_cd
             AND a.item_no           = p_gofc_item_no
             AND b.tran_flag         <>'D'
             AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                     FROM giac_reversals c); 
                                     
            p_collection_amt    :=  v_old_collection_amt;
            p_tran_id           :=  v_tran_id;
            
        END;
     ELSE
        p_message := 'No old item found.';
        
     END IF;
                             
  END;
/



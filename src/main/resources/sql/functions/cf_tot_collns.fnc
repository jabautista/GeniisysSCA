DROP FUNCTION CPI.CF_TOT_COLLNS;

CREATE OR REPLACE FUNCTION CPI.CF_TOT_COLLNS(  --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE
       )  
     RETURN Number IS
         v_collns                NUMBER;
         v_dexist                varchar2(1);
         v_iexist                 varchar2(1);
         v_tag                    varchar2(1);
         v_gross                 number;
         v_net                    number;
         v_currency            number;
         v_fcurr_net           number;
         v_fcurr_gross        number;
  
     BEGIN
          FOR rec IN (SELECT b.GROSS_TAG tag, sum(A.gross_amt) gross, sum(A.amount) net, 
                                        A.currency_cd currency_cd, sum(A.fcurrency_amt) fcurr_net, 
                                        sum(A.fc_gross_amt) fcurr_gross
                              FROM giac_collection_dtl A, giac_order_of_payts b
                            WHERE A.gacc_tran_id = b.gacc_tran_id
                                AND A.gacc_tran_id = NVL(P_TRAN_ID, A.gacc_tran_id)
                            GROUP BY b.GROSS_TAG, A.currency_cd)
                            
          LOOP
               v_tag                 :=    rec.tag;
               v_gross             :=    rec.gross;
               v_net                 :=    rec.net;
               v_currency         :=    rec.currency_cd;
               v_fcurr_net        :=    rec.fcurr_net;
               v_fcurr_gross     :=    rec.fcurr_gross;
          END LOOP;

             IF v_currency = 1 THEN
             IF v_tag = 'Y' THEN
                 v_collns := v_gross;
             ELSE
                 v_collns := v_net;
              END IF;
         RETURN (v_collns);
              ELSE
             IF v_tag = 'Y' THEN
                 v_collns := v_fcurr_gross;
             ELSE
                 v_collns := v_fcurr_net;
               END IF;
         RETURN (v_collns);
         END IF;

     END;
/



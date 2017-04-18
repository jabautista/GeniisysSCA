DROP PROCEDURE CPI.SPOIL_PRINTED_OR;

CREATE OR REPLACE PROCEDURE CPI.SPOIL_PRINTED_OR(
        p_gacc_tran_id  IN GIAC_OP_TEXT.gacc_tran_id%TYPE,
        p_branch_cd     IN GIAC_OR_PREF.branch_cd%TYPE,
        p_fund_cd       IN GIAC_OR_PREF.fund_cd%TYPE,
        p_or_pref       IN giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no         IN giac_doc_sequence.doc_seq_no%TYPE,
        p_user_id       IN GIAC_DCB_USERS.user_id%TYPE,
        p_mesg          OUT VARCHAR2 
      ) IS
      
       v_dcb_flag   giac_colln_batch.dcb_flag%TYPE;   
       v_tran_flag  giac_acctrans.tran_flag%TYPE;
BEGIN
      /*
  **  Created by	: d.alcantara
  **  Date Created 	: 03.15.2011
  **  Reference By 	: (GIACS050 - OR PRINTING)
  **  Description 	: Spoils an OR
  */
    p_mesg := 'N';

    FOR t IN (SELECT tran_flag
               FROM giac_acctrans
              WHERE tran_id = p_gacc_tran_id)
    LOOP
      v_tran_flag := t.tran_flag;
    END LOOP;
        
    IF v_tran_flag IN ('O', 'C') 
    THEN
      
     BEGIN
            BEGIN
                SELECT tran_flag
                INTO v_dcb_flag
                FROM giac_acctrans
                WHERE tran_id = p_gacc_tran_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_dcb_flag := '';
            END;
            
            IF v_dcb_flag = 'O' 
            THEN
               DECLARE
                 v_curr_cd     giac_order_of_payts.currency_cd%TYPE;
                 v_gross_tag   giac_order_of_payts.gross_tag%TYPE;
                 v_or_date     giac_order_of_payts.or_date%TYPE;
                 v_coll_amt    giac_order_of_payts.collection_amt%TYPE;
                 v_gross_amt   giac_order_of_payts.gross_amt%TYPE;
                 v_or_tag      giac_order_of_payts.or_tag%TYPE;
               BEGIN
                  FOR a1 IN (SELECT currency_cd, gross_tag,
                                    or_date, collection_amt,
                                    gross_amt, or_tag
                               FROM giac_order_of_payts
                              WHERE gacc_tran_id = p_gacc_tran_id) 
                  LOOP
                     v_curr_cd   := a1.currency_cd;
                     v_gross_tag := a1.gross_tag;
                     v_or_date   := a1.or_date;
                     v_coll_amt  := a1.collection_amt;
                     v_gross_amt := a1.gross_amt;
                     v_or_tag    := a1.or_tag;
                     EXIT;
                 END LOOP a1;
                    
                 IF v_or_date IS NULL 
                 THEN
                    p_mesg := 'OR data not found in order_of_payts.';
                 END IF;
                     
                 INSERT INTO giac_spoiled_or(
                      or_pref, or_no, 
                      fund_cd, branch_cd,
                      spoil_date, spoil_tag,
                      tran_id, user_id, 
                      last_update, or_date) 
                VALUES(p_or_pref, p_or_no,
                       p_fund_cd, p_branch_cd,
                       SYSDATE, 'S',
                       p_gacc_tran_id, nvl(p_user_id, USER), 
                       SYSDATE, v_or_date);
                  p_mesg := 'Y';
                 IF SQL%FOUND 
                 THEN
                    IF v_tran_flag = 'C' 
                    THEN  
                       /* turns back transaction status to OPEN */
                       UPDATE giac_acctrans
                          SET tran_flag = 'O'
                        WHERE tran_id = p_gacc_tran_id;
                      IF SQL%FOUND 
                      THEN
                         UPDATE giac_order_of_payts
                            SET or_pref_suf = NULL,
                                or_no       = NULL,
                                or_flag     = 'N',
                                user_id     = nvl(p_user_id, USER),
                                last_update = SYSDATE
                          WHERE gacc_tran_id = p_gacc_tran_id;
                   
                      ELSE
                          p_mesg := 'Spoil OR: Unable to update acctrans.';
                      END IF;
                   /* transaction is still open */  
                   ELSIF v_tran_flag = 'O' 
                   THEN
                      UPDATE giac_order_of_payts
                         SET or_pref_suf = NULL,
                             or_no       = NULL,
                             or_flag     = 'N',
                             user_id     = nvl(p_user_id, USER),
                             last_update = SYSDATE                        
                       WHERE gacc_tran_id = p_gacc_tran_id;
                   /*   IF SQL%FOUND 
                      THEN
                         :GLOBAL.IS_OR_PRINTED := 'N';
                         FORMS_DDL('COMMIT');
                         DO_KEY('EXIT_FORM');
                      ELSE
                         FORMS_DDL('ROLLBACK');
                         msg_alert('Spoil OR: Unable to update order_of_payts.',
                                   'E',TRUE);
                      END IF;*/
                     
                   END IF;
                ELSE
                 --  msg_alert('Spoil OR: Unable to insert into spoiled_or.','E',TRUE);
                  p_mesg := 'Spoil OR: Unable to insert into spoiled_or.';
                END IF;
            END;           

            ELSIF v_dcb_flag IN ('C', 'X') 
            THEN
            /*   msg_alert('Spoiling not allowed. The DCB has already ' ||
                         'been closed/closed for printing. You may ' ||
                         'cancel this OR instead.', 'E', TRUE);*/
               p_mesg := 'Spoiling not allowed. The DCB has already been closed/closed for printing. You may cancel this OR instead.';          
                       
          END IF;
        
      END;
         
    ELSIF v_tran_flag = 'D' THEN
         p_mesg := 'Spoiling not allowed. This is a deleted transaction.';
    ELSIF v_tran_flag = 'P' THEN
         p_mesg := 'Spoiling not allowed. This is a posted transaction.';
    END IF;
END SPOIL_PRINTED_OR;
/



DROP PROCEDURE CPI.INSERT_INTO_GIAC_PAYT_REQUESTS;

CREATE OR REPLACE PROCEDURE CPI.insert_into_giac_payt_requests
    (p_fund_cd   IN  GICL_BATCH_CSR.fund_cd%TYPE,
     p_iss_cd    IN  GICL_BATCH_CSR.iss_cd%TYPE,
     p_user_id   IN  GIIS_USERS.user_id%TYPE,
     p_ref_id    OUT GIAC_PAYT_REQUESTS.ref_id%TYPE,
     p_msg_alert OUT VARCHAR2) IS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes insert_into_giac_payt_requests program unit in GICLS043
   **                 
   */

    v_doc_year       GIAC_PAYT_REQ_SEQ.payt_year%TYPE;
    v_doc_mm         GIAC_PAYT_REQ_SEQ.payt_mm%TYPE;
    v_document_cd     GIAC_PAYT_REQUESTS.document_cd%TYPE;
    v_gouc_ouc_id    GIAC_OUCS.ouc_id%TYPE;
    v_doc_seq_no     NUMBER;
    v_yy_tag         GIAC_PAYT_REQ_DOCS.yy_tag%TYPE;
    v_mm_tag         GIAC_PAYT_REQ_DOCS.mm_tag%TYPE;

 BEGIN
      v_doc_year := TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'));    
      v_doc_mm   := TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));
     
      BEGIN
        SELECT gprq_ref_id_s.NEXTVAL
          INTO p_ref_id 
          FROM dual;
        
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
                         
          p_msg_alert := 'GPRQ_REF_ID_S sequence does not exist. Please contact your ' ||
                         'system administrator.'; 
      END;
      
      
      FOR a1 IN (SELECT ouc_id
                   FROM GIAC_OUCS
                  WHERE claim_tag = 'Y'
                    AND gibr_branch_cd = p_iss_cd) 
      LOOP
        v_gouc_ouc_id := a1.ouc_id;
        EXIT;
      END LOOP;                  
     
      IF v_gouc_ouc_id IS NULL THEN    
        p_msg_alert := 'No department tagged for CSR in GIAC_OUCS';
        RETURN;    --Halley 11.5.13
      END IF;          

     
      FOR a3 IN (SELECT param_value_v
                   FROM giac_parameters
                  WHERE param_name = 'BATCH_CSR_DOC') LOOP
        v_document_cd := a3.param_value_v;
        EXIT;
      END LOOP;
       
      IF v_document_cd IS NULL THEN             
         p_msg_alert := 'BATCH_CSR_DOC is not found in GIAC_PARAMETERS.';
         RETURN;    --Halley 11.5.13
      END IF; 

      v_doc_seq_no := generate_doc_seq_no(p_fund_cd,
                                          p_iss_cd,
                                          v_document_cd,
                                          v_doc_year,
                                          v_doc_mm);

      IF v_doc_seq_no IS NULL THEN               
         p_msg_alert := 'Document sequence number is not found';
         RETURN;    --Halley 11.5.13
      END IF; 
      
      GET_NUMBERING_SCHEME(p_fund_cd, p_iss_cd, v_document_cd, v_yy_tag, v_mm_tag, p_msg_alert);

      
      INSERT INTO GIAC_PAYT_REQUESTS
              (gouc_ouc_id, ref_id, fund_cd, request_date,
               branch_cd, document_cd, doc_year, doc_mm, doc_seq_no,
               user_id,last_update, with_dv, create_by)
      VALUES(v_gouc_ouc_id, p_ref_id, p_fund_cd, SYSDATE,
             p_iss_cd, v_document_cd, v_doc_year,
             v_doc_mm, v_doc_seq_no,
             p_user_id, SYSDATE, 'N', p_user_id);

      IF SQL%NOTFOUND THEN
                            
        p_msg_alert := 'Cannot insert into GIAC_PAYT_REQUESTS table.' ||
                       'Please contact your system administrator.';      
      END IF; 

 END insert_into_giac_payt_requests;
/



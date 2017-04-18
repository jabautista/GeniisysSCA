CREATE OR REPLACE PACKAGE BODY CPI.GICL_BATCH_CSR_PKG
AS
    /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.06.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves list of records from GICL_BATCH_CSR
   **                 
   */
   
   FUNCTION get_gicl_batch_csr_list (p_module_id        VARCHAR2,
                                     p_user_id          GIIS_USERS.user_id%TYPE,
                                     p_fund_cd          GICL_BATCH_CSR.fund_cd%TYPE,
                                     p_iss_cd           GICL_BATCH_CSR.iss_cd%TYPE,
                                     p_batch_year       GICL_BATCH_CSR.batch_year%TYPE,
                                     p_batch_seq_no     GICL_BATCH_CSR.batch_seq_no%TYPE,
                                     p_particulars      GICL_BATCH_CSR.particulars%TYPE,
                                     p_payee_class      VARCHAR2,
                                     p_payee_cd         GICL_BATCH_CSR.payee_cd%TYPE,
                                     p_payee_name       VARCHAR2,
                                     p_paid_amt         GICL_BATCH_CSR.paid_amt%TYPE,
                                     p_net_amt          GICL_BATCH_CSR.net_amt%TYPE,
                                     p_advise_amt       GICL_BATCH_CSR.advise_amt%TYPE,
                                     p_currency_desc    GIIS_CURRENCY.currency_desc%TYPE,
                                     p_convert_rate     GICL_BATCH_CSR.convert_rate%TYPE,
                                     p_processor        GICL_BATCH_CSR.user_id%TYPE)
                                     
    RETURN gicl_batch_csr_tab PIPELINED AS
    
    v_batch_csr         gicl_batch_csr_type;
    
    BEGIN
        FOR i IN (  SELECT A.batch_csr_id,   A.fund_cd,        A.iss_cd,
                           A.batch_year,     A.batch_seq_no,   A.particulars,
                           A.payee_class_cd, D.class_desc,     A.payee_cd,  
                           RTRIM(LTRIM( B.payee_first_name || ' ' ||
                                        B.payee_middle_name || ' ' || B.payee_last_name)) payee_name,
                           A.paid_amt,       A.net_amt,        A.advise_amt,
                           A.currency_cd,    C.currency_desc,  A.convert_rate,   
                           A.user_id,        A.last_update,    A.batch_flag, 
                           A.ref_id,         A.req_dtl_no,     A.tran_id, 
                           A.net_fcurr_amt,  A.paid_fcurr_amt, A.adv_fcurr_amt,
                           A.fund_cd 
                           || ' - ' 
                           || A.iss_cd 
                           || ' - ' 
                           || A.batch_year
                           || ' - '
                           || TO_CHAR(A.batch_seq_no, '0000009') batch_csr_no 
                    FROM GICL_BATCH_CSR A, 
                         GIIS_PAYEES B, 
                         GIIS_CURRENCY C,
                         GIIS_PAYEE_CLASS D
                    WHERE batch_flag != 'D'
                    AND check_user_per_iss_cd2(null, A.iss_cd, p_module_id, p_user_id)=1
                    AND B.payee_class_cd = A.payee_class_cd
                    AND D.payee_class_cd = A.payee_class_cd
                    AND B.payee_no = A.payee_cd
                    AND C.main_currency_cd = A.currency_cd
                    AND UPPER(A.fund_cd) LIKE UPPER(NVL(p_fund_cd, A.fund_cd))
                    AND UPPER(A.iss_cd) LIKE UPPER(NVL(p_iss_cd, A.iss_cd))
                    AND UPPER(A.batch_year) LIKE UPPER(NVL(p_batch_year, A.batch_year))
                    AND UPPER(A.batch_seq_no) LIKE UPPER(NVL(p_batch_seq_no, A.batch_seq_no))
                    AND UPPER(A.particulars) LIKE UPPER(NVL(p_particulars, A.particulars))
                    AND UPPER(D.class_desc) LIKE UPPER(NVL(p_payee_class, D.class_desc))
                    AND UPPER(A.payee_cd) LIKE UPPER(NVL(p_payee_cd, A.payee_cd))
                    AND UPPER(RTRIM(LTRIM( B.payee_first_name || ' ' ||
                              B.payee_middle_name || ' ' || B.payee_last_name))) LIKE UPPER(NVL(p_payee_name, RTRIM(LTRIM( B.payee_first_name || ' ' ||
                                                                                                               B.payee_middle_name || ' ' || B.payee_last_name))))
                    AND UPPER(A.paid_amt) LIKE UPPER(NVL(p_paid_amt, A.paid_amt))
                    AND UPPER(A.net_amt) LIKE UPPER(NVL(p_net_amt, A.net_amt))
                    AND UPPER(A.advise_amt) LIKE UPPER(NVL(p_advise_amt, A.advise_amt))
                    AND UPPER(A.convert_rate) LIKE UPPER(NVL(p_convert_rate, A.convert_rate))
                    AND UPPER(C.currency_desc) LIKE UPPER(NVL(p_currency_desc, C.currency_desc))
                    AND UPPER(A.user_id) LIKE UPPER(NVL(p_processor, A.user_id))
                    ORDER BY A.fund_cd 
                           || ' - ' 
                           || A.iss_cd 
                           || ' - ' 
                           || A.batch_year
                           || ' - '
                           || TO_CHAR(A.batch_seq_no, '0000009'))
                    
        LOOP
            v_batch_csr.batch_csr_id      := i.batch_csr_id;
            v_batch_csr.fund_cd           := i.fund_cd;  
            v_batch_csr.iss_cd            := i.iss_cd;  
            v_batch_csr.batch_year        := i.batch_year;  
            v_batch_csr.batch_seq_no      := i.batch_seq_no;  
            v_batch_csr.particulars       := i.particulars; 
            v_batch_csr.payee_class_cd    := i.payee_class_cd;
            v_batch_csr.payee_class_desc  := i.class_desc;
            v_batch_csr.payee_cd          := i.payee_cd;  
            v_batch_csr.payee_name        := i.payee_name; 
            v_batch_csr.paid_amt          := i.paid_amt;  
            v_batch_csr.net_amt           := i.net_amt; 
            v_batch_csr.advise_amt        := i.advise_amt;  
            v_batch_csr.currency_cd       := i.currency_cd; 
            v_batch_csr.currency_desc     := i.currency_desc;  
            v_batch_csr.convert_rate      := i.convert_rate;  
            v_batch_csr.user_id           := i.user_id;  
            v_batch_csr.last_update       := i.last_update;  
            v_batch_csr.batch_flag        := i.batch_flag;  
            v_batch_csr.ref_id            := i.ref_id;  
            v_batch_csr.req_dtl_no        := i.req_dtl_no;  
            v_batch_csr.tran_id           := i.tran_id ;  
            v_batch_csr.net_fcurr_amt     := i.net_fcurr_amt;  
            v_batch_csr.paid_fcurr_amt    := i.paid_fcurr_amt;  
            v_batch_csr.adv_fcurr_amt     := i.adv_fcurr_amt;  
            v_batch_csr.batch_csr_no      := i.batch_csr_no;  
            
            PIPE ROW(v_batch_csr);            
        END LOOP;
    END get_gicl_batch_csr_list;
    
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.08.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves record from GICL_BATCH_CSR with the given batch_csr_id
   **                 
   */
   
    FUNCTION get_gicl_batch_csr (p_batch_csr_id GICL_BATCH_CSR.batch_csr_id%TYPE,
                                 p_module_id    VARCHAR2,
                                 p_user_id      GIIS_USERS.user_id%TYPE)
                                     
    RETURN gicl_batch_csr_tab PIPELINED AS
    
    v_batch_csr         gicl_batch_csr_type;
    
    BEGIN
        FOR i IN (  SELECT A.batch_csr_id,   A.fund_cd,        A.iss_cd,
                           A.batch_year,     A.batch_seq_no,   A.particulars,
                           A.payee_class_cd, D.class_desc,     A.payee_cd,  
                           RTRIM(LTRIM( B.payee_first_name || ' ' ||
                                        B.payee_middle_name || ' ' || B.payee_last_name)) payee_name,
                           A.paid_amt,       A.net_amt,        A.advise_amt,
                           A.currency_cd,    C.currency_desc,  A.convert_rate, A.clm_dtl_sw,  
                           A.user_id,        A.last_update,    A.batch_flag, 
                           A.ref_id,         A.req_dtl_no,     A.tran_id, 
                           A.net_fcurr_amt,  A.paid_fcurr_amt, A.adv_fcurr_amt,
                           (NVL(A.paid_amt, 0)* NVL(A.convert_rate, 0)) loss_amt,
                           A.fund_cd 
                           || ' - ' 
                           || A.iss_cd 
                           || ' - ' 
                           || A.batch_year
                           || ' - '
                           || TO_CHAR(A.batch_seq_no, '0000009') batch_csr_no 
                    FROM GICL_BATCH_CSR A, 
                         GIIS_PAYEES B, 
                         GIIS_CURRENCY C,
                         GIIS_PAYEE_CLASS D
                    WHERE batch_flag != 'D'
                    AND check_user_per_iss_cd2(null, A.iss_cd, p_module_id, p_user_id)=1
                    AND A.batch_csr_id = p_batch_csr_id
                    AND B.payee_class_cd = A.payee_class_cd
                    AND D.payee_class_cd = A.payee_class_cd
                    AND B.payee_no = A.payee_cd
                    AND C.main_currency_cd = A.currency_cd)
                    
        LOOP
            v_batch_csr.batch_csr_id      := i.batch_csr_id;
            v_batch_csr.fund_cd           := i.fund_cd;  
            v_batch_csr.iss_cd            := i.iss_cd;  
            v_batch_csr.batch_year        := i.batch_year;  
            v_batch_csr.batch_seq_no      := i.batch_seq_no;  
            v_batch_csr.particulars       := i.particulars; 
            v_batch_csr.payee_class_cd    := i.payee_class_cd;
            v_batch_csr.payee_class_desc  := i.class_desc;  
            v_batch_csr.payee_cd          := i.payee_cd;  
            v_batch_csr.payee_name        := i.payee_name; 
            v_batch_csr.paid_amt          := i.paid_amt;  
            v_batch_csr.net_amt           := i.net_amt; 
            v_batch_csr.advise_amt        := i.advise_amt;  
            v_batch_csr.currency_cd       := i.currency_cd; 
            v_batch_csr.currency_desc     := i.currency_desc;  
            v_batch_csr.convert_rate      := i.convert_rate;
            v_batch_csr.clm_dtl_sw        := i.clm_dtl_sw;  
            v_batch_csr.user_id           := i.user_id;  
            v_batch_csr.last_update       := i.last_update;  
            v_batch_csr.batch_flag        := i.batch_flag;  
            v_batch_csr.ref_id            := i.ref_id;  
            v_batch_csr.req_dtl_no        := i.req_dtl_no;  
            v_batch_csr.tran_id           := i.tran_id ;  
            v_batch_csr.net_fcurr_amt     := i.net_fcurr_amt;  
            v_batch_csr.paid_fcurr_amt    := i.paid_fcurr_amt;  
            v_batch_csr.adv_fcurr_amt     := i.adv_fcurr_amt;  
            v_batch_csr.batch_csr_no      := i.batch_csr_no;  
            v_batch_csr.loss_amt          := i.loss_amt; 
            PIPE ROW(v_batch_csr);            
        END LOOP;
    END get_gicl_batch_csr;
    
    
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.15.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Insert or update record from GICL_BATCH_CSR
   **                 
   */
    
    PROCEDURE set_gicl_batch_csr(p_batch_csr_id     IN     GICL_BATCH_CSR.batch_csr_id%TYPE,
                                 p_fund_cd          IN     GICL_BATCH_CSR.fund_cd%TYPE,
                                 p_iss_cd           IN     GICL_BATCH_CSR.iss_cd%TYPE,
                                 p_batch_year       IN     GICL_BATCH_CSR.batch_year%TYPE,
                                 p_batch_seq_no     IN     GICL_BATCH_CSR.batch_seq_no%TYPE,
                                 p_particulars      IN     GICL_BATCH_CSR.particulars%TYPE,
                                 p_payee_class_cd   IN     GICL_BATCH_CSR.payee_class_cd%TYPE,
                                 p_payee_cd         IN     GICL_BATCH_CSR.payee_cd%TYPE,
                                 p_paid_amt         IN     GICL_BATCH_CSR.paid_amt%TYPE,
                                 p_net_amt          IN     GICL_BATCH_CSR.net_amt%TYPE,
                                 p_advise_amt       IN     GICL_BATCH_CSR.advise_amt%TYPE,
                                 p_currency_cd      IN     GICL_BATCH_CSR.currency_cd%TYPE,
                                 p_convert_rate     IN     GICL_BATCH_CSR.convert_rate%TYPE,
                                 p_user_id          IN     GICL_BATCH_CSR.user_id%TYPE,
                                 p_batch_flag       IN     GICL_BATCH_CSR.batch_flag%TYPE,
                                 p_net_fcurr_amt    IN     GICL_BATCH_CSR.net_fcurr_amt%TYPE,
                                 p_paid_fcurr_amt   IN     GICL_BATCH_CSR.paid_fcurr_amt%TYPE,
                                 p_adv_fcurr_amt    IN     GICL_BATCH_CSR.adv_fcurr_amt%TYPE)
    AS
                                                          
    BEGIN

        MERGE INTO GICL_BATCH_CSR
          USING DUAL ON (batch_csr_id = p_batch_csr_id)
        WHEN NOT MATCHED THEN
            INSERT (batch_csr_id,	fund_cd,	      iss_cd,		    batch_year,	      batch_seq_no, 	
                    particulars,    payee_class_cd,	  payee_cd,	        paid_amt,	      net_amt,		  
                    advise_amt,	    currency_cd,      convert_rate,	    user_id,	      last_update,
                    batch_flag,	    net_fcurr_amt,	  paid_fcurr_amt,   adv_fcurr_amt)
            
            VALUES (p_batch_csr_id,	p_fund_cd,		  p_iss_cd,		    p_batch_year,	  p_batch_seq_no, 	
                    p_particulars,  p_payee_class_cd, p_payee_cd,		p_paid_amt,		  p_net_amt,		  
                    p_advise_amt,	p_currency_cd,    p_convert_rate,	p_user_id,		  SYSDATE,
                    p_batch_flag,	p_net_fcurr_amt,  p_paid_fcurr_amt,	p_adv_fcurr_amt)
         WHEN MATCHED THEN
            UPDATE SET payee_class_cd = p_payee_class_cd,
                       payee_cd       = p_payee_cd,
                       particulars    = p_particulars,
                       user_id        = p_user_id,
                       last_update    = SYSDATE; 
        
    END set_gicl_batch_csr;
    
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.15.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes a part of GENERATE_BATCH_NUMBER program unit
   **                 found in GICLS043
   */
    
    PROCEDURE generate_batch_number_a(p_iss_cd        IN      GICL_BATCH_CSR.iss_cd%TYPE,
                                      p_user_id       IN      GIIS_USERS.user_id%TYPE,
                                      p_fund_cd       IN OUT  GICL_BATCH_CSR.fund_cd%TYPE,
                                      p_batch_year    IN OUT  GICL_BATCH_CSR.batch_year%TYPE,
                                      p_batch_seq_no  IN OUT  GICL_BATCH_CSR.batch_seq_no%TYPE,
                                      p_batch_csr_id  IN OUT  GICL_BATCH_CSR.batch_csr_id%TYPE)                               
    AS 
        v_dummy         NUMBER;
        v_fund_cd       GICL_BATCH_CSR.fund_cd%TYPE;
        v_batch_year    GICL_BATCH_CSR_SEQ.batch_year%TYPE DEFAULT TO_CHAR(SYSDATE, 'YYYY');
        v_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE;
        v_batch_seq_no  GICL_BATCH_CSR.batch_seq_no%TYPE;

    BEGIN
        
       BEGIN
          SELECT param_value_v
            INTO v_fund_cd
            FROM giac_parameters
            WHERE param_name = 'FUND_CD';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
          raise_application_error(-200001,'Fund code is not found in GIAC_PARAMETERS table.');        
       END;
       
       GET_BATCH_SEQ_NO(v_fund_cd, p_iss_cd, v_batch_year, p_user_id, v_batch_seq_no);
       
       BEGIN
        SELECT 1
          INTO v_dummy
          FROM all_objects 
         WHERE object_type LIKE 'SEQUENCE'
           AND object_name LIKE 'BATCH_CSR_ID_S';
          
          BEGIN
            SELECT batch_csr_id_s.NEXTVAL
              INTO v_batch_csr_id
              FROM dual;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                raise_application_error(-200002,'No next value for BATCH_CSR_ID_S sequence.');
          END; 
           
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-200003,'Batch_csr_id_s sequence does not exist.');
       END;
       
       p_fund_cd      := v_fund_cd;
       p_batch_year   := v_batch_year;
       p_batch_seq_no := v_batch_seq_no;
       p_batch_csr_id := v_batch_csr_id;
       
    END generate_batch_number_a;
    
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.15.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes a part of GENERATE_BATCH_NUMBER program unit
   **                 found in GICLS043
   */
    
    PROCEDURE generate_batch_number_b(p_batch_csr_id    IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                                      p_claim_id        IN  GICL_CLAIMS.claim_id%TYPE,
                                      p_advice_id       IN  GICL_ADVICE.advice_id%TYPE,
                                      p_line_cd         IN  GICL_ADVICE.line_cd%TYPE,
                                      p_iss_cd          IN  GICL_ADVICE.iss_cd%TYPE,
                                      p_advice_year     IN  GICL_ADVICE.advice_year%TYPE,
                                      p_advice_seq_no   IN  GICL_ADVICE.advice_seq_no%TYPE,
                                      p_user_id         IN  GIIS_USERS.user_id%TYPE,
                                      p_msg_alert       OUT VARCHAR2, 
                                      p_workflow_msgr   OUT VARCHAR2)
    AS 
        v_info  VARCHAR2(500);
                                      
    BEGIN

        UPDATE GICL_ACCT_ENTRIES
        SET batch_csr_id = p_batch_csr_id
        WHERE claim_id  = p_claim_id
          AND advice_id = p_advice_id;
                   
         FOR c1 IN (SELECT b.userid, d.event_desc  
                      FROM GIIS_EVENTS_COLUMN c, GIIS_EVENT_MOD_USERS b, GIIS_EVENT_MODULES a, GIIS_EVENTS d
                     WHERE 1=1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       --AND b.userid <> USER  --A.R.C. 02.01.2006
                       AND b.passing_userid = p_user_id  --A.R.C. 02.01.2006
                       AND a.module_id = 'GICLS032'
                       AND a.event_cd = d.event_cd
                       AND UPPER(d.event_desc) = 'CSR TO ACCOUNTING')
         LOOP
           v_info := ' CSR to Accounting '||p_line_cd||'-'|| p_iss_cd|| '-'|| p_advice_year|| '-'|| p_advice_seq_no;
           
           CREATE_TRANSFER_WORKFLOW_REC3('CSR TO ACCOUNTING','GICLS032',c1.userid, p_advice_id, v_info, p_msg_alert, p_workflow_msgr, p_user_id);
           
         END LOOP;
         
    END generate_batch_number_b;
    
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.16.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  :  Cancel Batch Csr
   **                 
   */
    
    PROCEDURE cancel_batch_csr(p_batch_csr_id      GICL_BATCH_CSR.batch_csr_id%TYPE,
                               p_advice_id         GICL_ADVICE.advice_id%TYPE,
                               p_claim_id          GICL_ADVICE.claim_id%TYPE,
                               p_user_id           GIIS_USERS.user_id%TYPE) 
    AS
        db_date          DATE;
    BEGIN
      BEGIN
        SELECT SYSDATE
          INTO db_date
          FROM dual;
      EXCEPTION 
          WHEN NO_DATA_FOUND THEN
          raise_application_error(-200001,'Database date is not found in dual. Please contact your DBA.'); 
      END;
      
      INSERT INTO GICL_DEL_BCSR(batch_csr_id, advice_id, 
                                user_id, last_update)
      VALUES(p_batch_csr_id, p_advice_id,
             p_user_id, db_date);
             
      UPDATE GICL_BATCH_CSR
        SET batch_flag = 'D'
      WHERE batch_csr_id = p_batch_csr_id;
      
      UPDATE GICL_ADVICE
        SET batch_csr_id = NULL,
            apprvd_tag   = 'N'
      WHERE batch_csr_id = p_batch_csr_id
        AND advice_id    = p_advice_id;
        
      UPDATE GICL_ACCT_ENTRIES
         SET batch_csr_id = null
      WHERE claim_id  = p_claim_id
        AND advice_id = p_advice_id
        AND batch_csr_id = p_batch_csr_id;
      
    END cancel_batch_csr;
    
    /*
    **  Created by   :  Veronica V. Raymundo
    **  Date Created :  12.20.2011
    **  Reference By : (GICLS043 - Batch Claim Settlement Request)
    **  Description  :  Executes post_query trigger of Block C024 in GICLS043
    **                 
    */

    PROCEDURE gicls043_c027_post_query(p_ref_id       IN    GICL_BATCH_CSR.ref_id%TYPE,
                                       p_advice_id    IN    GICL_ADVICE.advice_id%TYPE,
                                       p_claim_id     IN    GICL_ADVICE.claim_id%TYPE,
                                       p_claim_no     OUT   VARCHAR2,
                                       p_advice_no    OUT   VARCHAR2,
                                       p_request_no   OUT   VARCHAR2,
                                       p_total_debit  OUT   NUMBER,
                                       p_total_credit OUT   NUMBER) 
    AS

    BEGIN
        IF p_ref_id IS NOT NULL THEN 
             FOR v IN (SELECT document_cd, branch_cd, 
                              doc_year, doc_mm, doc_seq_no
                         FROM GIAC_PAYT_REQUESTS 
                        WHERE ref_id = p_ref_id)
             LOOP
                p_request_no := v.document_cd || '-' ||v.branch_cd || '-' ||LTRIM(TO_CHAR(v.doc_year,'9999')) ||'-' ||LTRIM(TO_CHAR(v.doc_mm,'09')) || '-' ||LTRIM(TO_CHAR(v.doc_seq_no,'09999999'));
             END LOOP;
        ELSE
            p_request_no := null;
        END IF;

        p_claim_no := GET_CLAIM_NUMBER(p_claim_id);   

        BEGIN
            FOR i IN(SELECT line_cd, iss_cd, advice_year, 
                            advice_seq_no 
                     FROM GICL_ADVICE
                    WHERE advice_id = p_advice_id
                    AND claim_id = p_claim_id)
            LOOP
                p_advice_no := i.line_cd ||'-'||i.iss_cd||'-'||LTRIM(TO_CHAR(i.advice_year,'9999'))||'-'||LTRIM(TO_CHAR(i.advice_seq_no,'000009'));
            END LOOP;
        END;

        BEGIN 
            SELECT SUM(debit_amt), SUM(credit_amt)
              INTO p_total_debit, p_total_credit
              FROM GICL_ACCT_ENTRIES
             WHERE claim_id = p_claim_id
               AND advice_id = p_advice_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_total_debit := null;
              p_total_credit := null; 
        END;
    END gicls043_c027_post_query;
    
    
    PROCEDURE update_approved_batch_csr(p_batch_csr_id     IN     GICL_BATCH_CSR.batch_csr_id%TYPE,
                                        p_payee_class_cd   IN     GICL_BATCH_CSR.payee_class_cd%TYPE,
                                        p_payee_cd         IN     GICL_BATCH_CSR.payee_cd%TYPE,
                                        p_particulars      IN     GICL_BATCH_CSR.particulars%TYPE,
                                        p_user_id          IN     GICL_BATCH_CSR.user_id%TYPE,
                                        p_tran_id          IN     GICL_BATCH_CSR.tran_id%TYPE,
                                        p_req_dtl_no       IN     GICL_BATCH_CSR.req_dtl_no%TYPE,
                                        p_batch_tag        IN     GICL_BATCH_CSR.batch_flag%TYPE,
                                        p_ref_id           IN     GICL_BATCH_CSR.ref_id%TYPE)
    AS
    
    BEGIN
        UPDATE GICL_BATCH_CSR
        SET batch_csr_id    = p_batch_csr_id,     
            payee_class_cd  = p_payee_class_cd,   
            payee_cd        = p_payee_cd,        
            particulars     = p_particulars,
            user_id         = p_user_id,
            tran_id         = p_tran_id,
            req_dtl_no      = p_req_dtl_no,
            batch_flag      = p_batch_tag,
            ref_id          = p_ref_id
        WHERE batch_csr_id = p_batch_csr_id;
    END;
    
    /*
    **  Created by   :  Veronica V. Raymundo
    **  Date Created :  01.10.2012
    **  Reference By : (GICLS043 - Batch Claim Settlement Request)
    **  Description  :  Get the report id to be printed in GICLS043
    **                 
    */
    
    FUNCTION get_bcsr_report_id(p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                                p_iss_cd       IN  GICL_BATCH_CSR.iss_cd%TYPE)
     RETURN VARCHAR2 AS
     
     v_report_id  VARCHAR2(10);
     v_cnt        NUMBER := 0;
     
     BEGIN
        IF p_iss_cd != 'RI' THEN
             SELECT COUNT(d.tran_id)
               INTO v_cnt
              FROM GIAC_DIRECT_CLAIM_PAYTS a, 
                   GIAC_PAYT_REQUESTS_DTL b, 
                   GICL_ADVICE c, 
                   GICL_BATCH_CSR d
             WHERE a.claim_id = c.claim_id
               AND a.advice_id = c.advice_id
               AND a.gacc_tran_id = b.tran_id
               AND c.batch_csr_id = d.batch_csr_id
               AND c.batch_csr_id = p_batch_csr_id
               AND b.payt_req_flag <> 'X';

        ELSE
             SELECT COUNT(d.tran_id)
               INTO v_cnt
              FROM GIAC_INW_CLAIM_PAYTS a, 
                   GIAC_PAYT_REQUESTS_DTL b, 
                   GICL_ADVICE c, 
                   GICL_BATCH_CSR d
             WHERE a.claim_id = c.claim_id
               AND a.advice_id = c.advice_id
               AND a.gacc_tran_id = b.tran_id
               AND c.batch_csr_id = d.batch_csr_id
               AND c.batch_csr_id = p_batch_csr_id
               AND b.payt_req_flag <> 'X';
        END IF;
        
        IF v_cnt <> 0  THEN
            v_report_id := 'GICLR044';
        ELSIF v_cnt = 0 THEN
            v_report_id := 'GICLR043';
        END IF;
        
        RETURN(v_report_id);
     
     END;
     
    /*
    **  Created by   :  Andrew Robes
    **  Date Created :  3.22.2012
    **  Reference By : (GICLS0032 - Generate Advice)
    **  Description  :  Function to retrieve the batch csr no of advice
    **                 
    */
    FUNCTION get_bcsr_no (p_batch_csr_id gicl_batch_csr.batch_csr_id%TYPE)
       RETURN VARCHAR2
    IS
       v_bcsr_no   VARCHAR2 (500);
    BEGIN
       SELECT DISTINCT a.document_cd || '-' || TO_CHAR (a.doc_year) || '-' || TO_CHAR (a.doc_mm) || '-' || TO_CHAR (a.doc_seq_no)
                  INTO v_bcsr_no
                  FROM gicl_advice c, gicl_batch_csr b, giac_payt_requests a
                 WHERE c.batch_csr_id = b.batch_csr_id 
                   AND b.ref_id = a.ref_id (+) 
                   AND b.batch_csr_id = p_batch_csr_id;
       
       IF v_bcsr_no IS NOT NULL THEN
          RETURN v_bcsr_no;
       ELSE 
          RETURN NULL;
       END IF;
       
    END;     
    
    /*
   **  Created by   :  D.Alcantara
   **  Date Created :  04.12.2012
   **  Reference By : (GIACS017 -  Direct Claims Collections)
   */
    FUNCTION get_batch_claim_list (
        p_tran_type            GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
        p_line_cd              GICL_ADVICE.line_cd%TYPE,
        p_iss_cd               GICL_ADVICE.iss_cd%TYPE,
        p_advice_year          GICL_ADVICE.advice_year%TYPE,
        p_advice_seq_no        GICL_ADVICE.advice_seq_no%TYPE,
        p_ri_iss_cd            GICL_ADVICE.iss_cd%TYPE,
        p_module_id            GIIS_MODULES.module_id%TYPE,
        p_user_id              GIIS_USERS.user_id%TYPE  
    ) RETURN batch_claim_list_tab PIPELINED IS
        v_batch                 batch_claim_list_type;
        
        CURSOR a IS
           SELECT DISTINCT
                  gicl_batch_csr.fund_cd, 
                  gicl_batch_csr.iss_cd,
                  gicl_batch_csr.batch_year,
                  gicl_batch_csr.batch_seq_no,
                  (gicl_batch_csr.paid_amt * gicl_batch_csr.convert_rate) paid_amt,--added conversion reymon 04292013
                  DECODE(giis_payees.payee_first_name, NULL, 
                   giis_payees.payee_last_name,
                   giis_payees.payee_last_name||','||
                       giis_payees.payee_first_name||' '||
                       giis_payees.payee_middle_name) payee, 
                  gicl_batch_csr.batch_csr_id, 
                  gicl_batch_csr.payee_class_cd,
                  gicl_batch_csr.payee_cd 
             FROM gicl_advice, 
                  gicl_batch_csr,
                  giis_payees,
                  gicl_clm_loss_exp
            WHERE gicl_advice.advice_flag = 'Y' 
              AND NVL(gicl_advice.apprvd_tag,'N') = 'N' 
              AND NVL(gicl_batch_csr.batch_flag,'N') = 'N'
              AND gicl_batch_csr.batch_csr_id = gicl_advice.batch_csr_id
              AND gicl_batch_csr.payee_cd = giis_payees.payee_no 
              AND gicl_batch_csr.payee_class_cd = giis_payees.payee_class_cd 
              AND gicl_clm_loss_exp.claim_id = gicl_advice.claim_id 
              AND gicl_clm_loss_exp.advice_id = gicl_advice.advice_id		
              AND gicl_advice.iss_cd = DECODE(
                              check_user_per_iss_cd_acctg2(NULL,gicl_advice.iss_cd,p_module_id,p_user_id),
                              1,gicl_advice.iss_cd,NULL)
              AND gicl_advice.iss_cd != NVL(p_ri_iss_cd, 'RI')
              AND gicl_advice.line_cd = NVL(p_line_cd, gicl_advice.line_cd)
              AND gicl_advice.iss_cd = NVL(p_iss_cd, gicl_advice.iss_cd)
              AND gicl_advice.advice_year = NVL(p_advice_year, gicl_advice.advice_year)
              AND gicl_advice.advice_seq_no = NVL(p_advice_seq_no, gicl_advice.advice_seq_no);
               
       CURSOR B IS
          SELECT DISTINCT
                gicl_batch_csr.BATCH_CSR_ID,
                gicl_batch_csr.fund_cd, gicl_batch_csr.ISS_CD, gicl_batch_csr.BATCH_YEAR, gicl_batch_csr.BATCH_SEQ_NO,
                (gicl_clm_loss_exp.paid_amt * gicl_clm_loss_exp.currency_rate) paid_amt, --added conversion reymon 04292013
                giis_payees.payee_last_name||' '||giis_payees.payee_first_name||' '||giis_payees.payee_middle_name payee_name,
                gicl_clm_loss_exp.clm_loss_id, 
                gicl_clm_loss_exp.payee_type, 
                decode(gicl_clm_loss_exp.payee_type,'L','Loss','E','Expense') p_type, 
                gicl_batch_csr.payee_class_cd, 
                gicl_batch_csr.payee_cd,
                gicl_clm_loss_exp.peril_cd,
                (gicl_clm_loss_exp.net_amt * nvl(gicl_advice.convert_rate,1)) net_amt,
                (NVL(gicl_clm_loss_exp.paid_amt,0)*1) net_disb_amt, 
                giis_peril.peril_sname
           FROM giis_payees, 
                        gicl_clm_loss_exp, 
                        gicl_advice,
                        giis_peril, 
                        gicl_batch_csr
          WHERE gicl_clm_loss_exp.payee_cd = giis_payees.payee_no 
            AND gicl_clm_loss_exp.payee_class_cd = giis_payees.payee_class_cd
                AND gicl_advice.claim_id = gicl_clm_loss_exp.claim_id
                AND gicl_clm_loss_exp.advice_id = gicl_advice.advice_id
                AND gicl_clm_loss_exp.tran_id IS NOT NULL 
                AND NOT EXISTS (SELECT '1' 
                                                    FROM giac_reversals x, giac_acctrans y 
                                                 WHERE x.reversing_tran_id = y.tran_id 
                                                     AND x.gacc_tran_id = gicl_clm_loss_exp.tran_id 
                                                     AND y.tran_flag <> 'D') 
                AND gicl_batch_csr.payee_cd = giis_payees.payee_no 
                AND gicl_batch_csr.payee_class_cd = giis_payees.payee_class_cd 
                AND gicl_clm_loss_exp.peril_cd = giis_peril.peril_cd 
                AND giis_peril.line_cd = gicl_advice.line_cd
                AND giis_peril.line_cd = nvl(p_line_cd, giis_peril.line_cd)
                AND gicl_batch_csr.batch_csr_id = gicl_advice.batch_csr_id
                AND NVL(gicl_batch_csr.batch_flag,'N') = 'N'
                AND gicl_advice.iss_cd = DECODE(
                                check_user_per_iss_cd_acctg2(NULL,gicl_advice.iss_cd,p_module_id,p_user_id),
                                1,gicl_advice.iss_cd,NULL) 
                AND gicl_advice.iss_cd != NVL(p_ri_iss_cd, 'RI')
                AND gicl_advice.line_cd = nvl(p_line_cd, gicl_advice.line_cd)
                AND gicl_advice.iss_cd = nvl(p_iss_cd, gicl_advice.iss_cd)
                AND gicl_advice.advice_year = nvl(p_advice_year, gicl_advice.advice_year) 
                AND gicl_advice.advice_seq_no = nvl(p_advice_seq_no, gicl_advice.advice_seq_no) 
            ORDER BY gicl_batch_csr.fund_cd, gicl_batch_csr.iss_cd, gicl_batch_csr.batch_year, gicl_batch_csr.batch_seq_no;
    BEGIN
        IF p_tran_type = 1 THEN
 
            FOR a_rec IN a LOOP
                v_batch.batch_iss_cd      		:= a_rec.iss_cd;
                v_batch.batch_year      		:= a_rec.batch_year;
                v_batch.batch_fund_cd     		:= a_rec.fund_cd;
                v_batch.batch_seq_no    		:= a_rec.batch_seq_no;
                v_batch.batch_paid_amt			:= a_rec.paid_amt;
                v_batch.dsp_batch_payee         := a_rec.payee;
                v_batch.dsp_payee_class_cd		:= a_rec.payee_class_cd;
                v_batch.dsp_payee_cd			:= a_rec.payee_cd;
                v_batch.batch_csr_id			:= a_rec.batch_csr_id;
                v_batch.batch_number            := a_rec.fund_cd||'-'||a_rec.iss_cd||'-'||
                                                   a_rec.batch_year||'-'||TO_CHAR(a_rec.batch_seq_no, '000009');
                PIPE ROW(v_batch);   		  	
            END LOOP;	
            		 
        ELSIF p_tran_type = 2 THEN

            FOR b_rec IN b LOOP
            
                v_batch.batch_iss_cd      		:= b_rec.iss_cd;
                v_batch.batch_year      		:= b_rec.batch_year;
                v_batch.batch_fund_cd     		:= b_rec.fund_cd;
                v_batch.batch_seq_no    		:= b_rec.batch_seq_no;
                v_batch.batch_paid_amt			:= b_rec.paid_amt;
                v_batch.dsp_batch_payee         := b_rec.payee_name;
                v_batch.dsp_payee_class_cd		:= b_rec.payee_class_cd;
                v_batch.dsp_payee_cd			:= b_rec.payee_cd;
                v_batch.batch_csr_id			:= b_rec.batch_csr_id;
                v_batch.batch_number            := b_rec.fund_cd||'-'||b_rec.iss_cd||'-'||
                                                   b_rec.batch_year||'-'||TO_CHAR(b_rec.batch_seq_no, '000009');
            	PIPE ROW(v_batch);   	
            END LOOP;			
        END IF;		
    END get_batch_claim_list;     
END;
/



DROP FUNCTION CPI.GET_PAYMENT_REQUEST_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Payment_Request_No (p_tran_id IN GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE)
                  RETURN VARCHAR2 AS
/* created by judyann 02282008
** used in sorting records by request number
** Udel 10162012 Added decode function on LINE_CD to prevent displaying trailing
**    dash if line_cd is null. 
*/
 CURSOR r (p_tran_id IN GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE) IS

     SELECT document_cd||'-'||branch_cd||'-'||decode(line_cd, null, null, line_cd||'-')||
         LTRIM(TO_CHAR(doc_year,'0999'))||'-'||LTRIM(TO_CHAR(doc_mm,'09'))||'-'||
   LTRIM(TO_CHAR(doc_seq_no, '099999')) request
       FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
      WHERE a.ref_id = b.gprq_ref_id 
     AND b.tran_id = p_tran_id;

     p_request_no  VARCHAR2(100);

 BEGIN
   OPEN r (p_tran_id);
   FETCH r INTO p_request_no;
   IF r%FOUND THEN
     CLOSE r;
     RETURN p_request_no;
   ELSE
     CLOSE r;
     RETURN NULL;
   END IF;
 END;
/



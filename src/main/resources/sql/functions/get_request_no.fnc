DROP FUNCTION CPI.GET_REQUEST_NO;

CREATE OR REPLACE FUNCTION CPI.get_request_no (p_ref_id IN giac_payt_requests.ref_id%TYPE)
                  RETURN VARCHAR2 AS
/* created by judyann 01172003
** used in sorting records by request number
*/
 CURSOR r (p_ref_id IN giac_payt_requests.ref_id%TYPE) IS

     SELECT document_cd||'-'||branch_cd||'-'||line_cd||'-'||
	        LTRIM(TO_CHAR(doc_year,'0999'))||'-'||LTRIM(TO_CHAR(doc_mm,'09'))||'-'||
			LTRIM(TO_CHAR(doc_seq_no, '000009')) request
       FROM giac_payt_requests
      WHERE ref_id = p_ref_id;

     p_request_no  VARCHAR2(100);

 BEGIN
   OPEN r (p_ref_id);
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



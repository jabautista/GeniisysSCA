DROP PROCEDURE CPI.GIACS016_DR_DETAILS_POST_QUERY;

CREATE OR REPLACE PROCEDURE CPI.GIACS016_DR_DETAILS_POST_QUERY(
  p_tran_id giac_acctrans.tran_id%TYPE,
  p_document_cd giac_payt_requests.document_cd%TYPE,
  p_branch_cd giac_payt_requests.branch_cd%TYPE,
  p_line_cd giac_payt_requests.line_cd%TYPE,
  p_doc_year giac_payt_requests.doc_year%TYPE,
  p_doc_mm giac_payt_requests.doc_mm%TYPE,
  p_doc_seq_no giac_payt_requests.doc_seq_no%TYPE,
  p_payt_req_flag GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,
  p_dsp_tran_no OUT VARCHAR2,
  p_dsp_req_no  OUT VARCHAR2,
  p_dsp_payt_req_mean OUT VARCHAR2
)
AS 
BEGIN
    -- for tran no
    BEGIN
      SELECT TO_CHAR(tran_year)|| '-' || 
             TO_CHAR(tran_month, '09') || '-' ||
             TO_CHAR(tran_seq_no, '000009')
        INTO p_dsp_tran_no
        FROM giac_acctrans
       WHERE tran_id = p_tran_id;
    EXCEPTION
      WHEN no_data_found THEN
        --raise_application_error('-20001','Geniisys Exception#E#Error locating tran no in post-query.');
        p_dsp_tran_no := '--'; -- set value of tran_no to "--" if no record is retrieved from giac_acctrans, patterned with CS
    END;


    -- for payment request no
    BEGIN
      SELECT document_cd || '-' ||
             branch_cd || '-' ||
             DECODE(line_cd, NULL,
                             NULL,
                             line_cd || '-') ||
             DECODE(TO_CHAR(doc_year), NULL,
                                       NULL,
                                       TO_CHAR(doc_year) || '-') ||
             DECODE(TO_CHAR(doc_mm), NULL,
                                     NULL,
                                     TO_CHAR(doc_mm) || '-') ||
             TO_CHAR(doc_seq_no)
        INTO p_dsp_req_no
        FROM giac_payt_requests
        WHERE document_cd = p_document_cd
        AND branch_cd = p_branch_cd
        AND NVL(line_cd,'-') = NVL(p_line_cd, NVL(line_cd, '-'))
        AND NVL(doc_year,0) = NVL(p_doc_year, NVL(doc_year,0))
        AND NVL(doc_mm,0) = NVL(p_doc_mm, NVL(doc_mm,0))
        AND doc_seq_no = p_doc_seq_no;
    EXCEPTION
      WHEN no_data_found THEN
        --raise_application_error('-20001','Geniisys Exception#E#Error locating payt req no in post-query.');
        p_dsp_tran_no := '--'; -- tran_no will be set to "--" for now if no record found in giac_acctrans, same with CS
    END;


    -- for payment request status
    BEGIN
      SELECT SUBSTR(rv_meaning,1,10)
        INTO p_dsp_payt_req_mean
        FROM cg_ref_codes
        WHERE rv_domain = 'GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG'
        AND rv_low_value = p_payt_req_flag;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error('-20001','Geniisys Exception#E#Error locating payt_req_flag mean in post-query.');
    END;
END;
/



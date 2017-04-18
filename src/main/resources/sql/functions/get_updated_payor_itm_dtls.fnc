DROP FUNCTION CPI.GET_UPDATED_PAYOR_ITM_DTLS;

CREATE OR REPLACE FUNCTION CPI.get_updated_payor_itm_dtls(p_tran_id giac_order_of_payts.gacc_tran_id%TYPE,
                                                      p_policy_id gipi_polbasic.policy_id%TYPE) RETURN VARCHAR2
IS
  v_msg VARCHAR2(2000);
  v_gacc_tran_id    giac_order_of_payts.gacc_tran_id%TYPE;
  v_intm_no         giis_intermediary.intm_no%TYPE;
  v_line_cd         gipi_polbasic.line_cd%TYPE;
  v_subline_cd      gipi_polbasic.subline_cd%TYPE;
  v_iss_cd          gipi_polbasic.iss_cd%TYPE;
  v_issue_yy        gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no        gipi_polbasic.renew_no%TYPE;
  v_mail            VARCHAR2(2000);
BEGIN 
   SELECT gacc_tran_id, intm_no,                              /*PARTICULARS,*/
          address_1 || ' ' || address_2 || ' ' || address_3 mail_add
     INTO v_gacc_tran_id, v_intm_no,                        /*A_PARTICULARS,*/
          v_mail
     FROM giac_order_of_payts
    WHERE gacc_tran_id = p_tran_id;

   --issa
   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
          renew_no
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
          v_renew_no
     FROM gipi_polbasic
    WHERE policy_id = p_policy_id;

	--added by robert
     IF v_mail IS NOT NULL THEN
        v_mail := ', ' || v_mail;
     END IF;

   v_msg :=
      (/*A_PARTICULARS*/ v_line_cd
       || '-'
       || v_subline_cd
       || '-'
       || v_iss_cd
       || '-'
       || LPAD (v_issue_yy, 2, '0')
       || '-'
       || LPAD (v_pol_seq_no, 7, '0')
       || '-'
       || LPAD (v_renew_no, 2, '0')
--     || ', '
       || v_mail
       || ', '
       || TO_CHAR (v_intm_no)
      ); 

RETURN (v_msg);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  RETURN '-';
END;
/



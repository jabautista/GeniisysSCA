DROP FUNCTION CPI.BILLS_SETTLED;

CREATE OR REPLACE FUNCTION CPI.bills_settled(
    p_nbt_due       VARCHAR2,
    p_line_cd       gipi_pack_polbasic.line_cd%TYPE,
    p_subline_cd    gipi_pack_polbasic.subline_cd%TYPE,
    p_iss_cd        gipi_pack_polbasic.iss_cd%TYPE,
    p_issue_yy      gipi_pack_polbasic.issue_yy%TYPE,
    p_pol_seq_no    gipi_pack_polbasic.pol_seq_no%TYPE,
    p_renew_no      gipi_pack_polbasic.renew_no%TYPE
)
RETURN VARCHAR2
IS
     v_settled           VARCHAR2(5);
BEGIN
   v_settled := 'TRUE';       --added by totel--8/7/2006--initial value

   IF p_nbt_due = 'Y'
   THEN
      FOR y IN
         (SELECT a.line_cd, a.subline_cd, b.iss_cd, b.prem_seq_no, b.inst_no,
                 b.balance_amt_due
            FROM gipi_polbasic a,
                 giac_aging_soa_details b,
                 gipi_pack_polbasic c,
                 gipi_invoice d,
                 gipi_installment e
           WHERE d.policy_id = a.policy_id
             AND a.pack_policy_id = c.pack_policy_id
             AND d.iss_cd = e.iss_cd
             AND d.prem_seq_no = e.prem_seq_no
             AND e.iss_cd = b.iss_cd
             AND e.prem_seq_no = b.prem_seq_no
             AND e.inst_no = b.inst_no
             AND c.pack_policy_id IN (
                    SELECT pack_policy_id
                      FROM gipi_pack_polbasic
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no)
             AND b.balance_amt_due > 0)
--added by totel--8/1/2006--pra nde n sya makita s invoice canvas pag na-settle n sya s GDPC block a.k.a. 'Direct Premium Collection'
      LOOP
         v_settled := 'FALSE';               --added by totel--8/7/2006
         EXIT;                                     --added by totel--8/8/2006
      END LOOP;
   ELSIF p_nbt_due = 'N'
   THEN
      FOR n IN
         (SELECT a.line_cd, a.subline_cd, b.iss_cd, b.prem_seq_no, b.inst_no,
                 b.balance_amt_due
            FROM gipi_polbasic a,
                 giac_aging_soa_details b,
                 gipi_pack_polbasic c,
                 gipi_invoice d,
                 gipi_installment e
           WHERE d.policy_id = a.policy_id
             AND a.pack_policy_id = c.pack_policy_id
             AND d.iss_cd = e.iss_cd
             AND d.prem_seq_no = e.prem_seq_no
             AND e.iss_cd = b.iss_cd
             AND e.prem_seq_no = b.prem_seq_no
             AND e.inst_no = b.inst_no
             AND c.pack_policy_id IN (
                    SELECT pack_policy_id
                      FROM gipi_pack_polbasic
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no)
             AND e.due_date <= SYSDATE
             AND b.balance_amt_due > 0)
--added by totel--8/1/2006--pra nde n sya makita s invoice canvas pag na-settle n sya s GDPC block a.k.a. 'Direct Premium Collection'
      LOOP
         v_settled := 'FALSE';               --added by totel--8/7/2006
         EXIT;                                     --added by totel--8/8/2006
      END LOOP;
   END IF;
   RETURN (v_settled);
END;
/



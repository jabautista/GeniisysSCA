DROP PROCEDURE CPI.GICLS032_PROCESS_ADVISE_HDR;

CREATE OR REPLACE PROCEDURE CPI.gicls032_process_advise_hdr (
   p_claim_id               gicl_claims.claim_id%TYPE,
   p_advice_id        OUT   gicl_advice.advice_id%TYPE,
   p_net_amt                gicl_advice.net_amt%TYPE,
   p_paid_amt               gicl_advice.paid_amt%TYPE,
   p_advise_amt             gicl_advice.advise_amt%TYPE,
   p_net_fcurr_amt          gicl_advice.net_fcurr_amt%TYPE,
   p_paid_fcurr_amt         gicl_advice.paid_fcurr_amt%TYPE,
   p_adv_fcurr_amt          gicl_advice.adv_fcurr_amt%TYPE,
   p_currency_cd            gicl_advice.currency_cd%TYPE,
   p_convert_rate           gicl_advice.convert_rate%TYPE,
   p_orig_curr_cd           gicl_advice.orig_curr_cd%TYPE,
   p_orig_curr_rate         gicl_advice.orig_curr_rate%TYPE,
   p_remarks                gicl_advice.remarks%TYPE,
   p_payee_remarks          gicl_advice.payee_remarks%TYPE
)
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - process_advise_hdr
  */

   v_line_cd         giis_line.line_cd%TYPE;
   v_iss_cd          giis_issource.iss_cd%TYPE;
   v_advice_year     gicl_advice.advice_year%TYPE;
   v_advice_seq_no   gicl_advice.advice_seq_no%TYPE;
   v_net_fcurr_amt   gicl_advice.net_fcurr_amt%TYPE;
   v_paid_fcurr_amt  gicl_advice.paid_fcurr_amt%TYPE;
   v_adv_fcurr_amt   gicl_advice.adv_fcurr_amt%TYPE;
BEGIN
   SELECT line_cd, iss_cd
     INTO v_line_cd, v_iss_cd
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   SELECT claims_advice_id_s.NEXTVAL advice_id
     INTO p_advice_id
     FROM DUAL;

   SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
     INTO v_advice_year
     FROM DUAL;

   SELECT NVL (MAX (advice_seq_no) + 1, 1)
     INTO v_advice_seq_no
     FROM gicl_advice
    WHERE line_cd = v_line_cd;

   IF p_currency_cd <> giacp.n('CURRENCY_CD') THEN
     v_net_fcurr_amt  := p_net_amt * p_convert_rate;
     v_paid_fcurr_amt := p_paid_amt * p_convert_rate;
     v_adv_fcurr_amt  := p_advise_amt * p_convert_rate;
   ELSE 
     v_net_fcurr_amt  := p_net_fcurr_amt;
     v_paid_fcurr_amt := p_paid_fcurr_amt;
     v_adv_fcurr_amt  := p_adv_fcurr_amt;
   END IF;

   INSERT INTO gicl_advice
               (iss_cd, claim_id, line_cd, advice_id, advice_year, advice_seq_no, advice_flag, advice_date, apprvd_tag, net_amt,
                paid_amt, advise_amt, net_fcurr_amt, paid_fcurr_amt, adv_fcurr_amt, currency_cd, convert_rate,
                orig_curr_cd, orig_curr_rate, remarks, payee_remarks
               )
        VALUES (v_iss_cd, p_claim_id, v_line_cd, p_advice_id, v_advice_year, v_advice_seq_no, 'Y', SYSDATE, 'N', p_net_amt,
                p_paid_amt, p_advise_amt, v_net_fcurr_amt, v_paid_fcurr_amt, v_adv_fcurr_amt, p_currency_cd, p_convert_rate,
                p_orig_curr_cd, p_orig_curr_rate, p_remarks, p_payee_remarks
               );
END;
/



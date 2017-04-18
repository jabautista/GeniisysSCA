DROP FUNCTION CPI.GET_INC_TAG_FOR_ADV_PREM_PAYTS;

CREATE OR REPLACE FUNCTION CPI.get_inc_tag_for_adv_prem_payts
  (p_gacc_tran_id     IN    GIAC_DIRECT_PREM_COLLNS.gacc_tran_id%TYPE,
   p_b140_iss_cd      IN    GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
   p_b140_prem_seq_no IN    GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE) 

   RETURN VARCHAR2 AS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  08.13.2012
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description  : For automatic tagging of inc_tag for 
   **                 advanced premium payments
   */  

   v_tag         VARCHAR2(1);
   v_tran_date   GIAC_ACCTRANS.tran_date%TYPE;           
        
   BEGIN
      v_tag := 'N';
      
      BEGIN
        
        SELECT tran_date
          INTO v_tran_date
          FROM GIAC_ACCTRANS
         WHERE tran_id = p_gacc_tran_id;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN          
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Transaction does not exist.');
      END;

      FOR t IN (
        SELECT 'x' tag
          FROM GIPI_POLBASIC a, GIPI_INVOICE b
         WHERE a.policy_id = b.policy_id
           AND b.iss_cd = p_b140_iss_cd
           AND b.prem_seq_no = p_b140_prem_seq_no      
           AND TO_DATE('01-'||TO_CHAR(TO_DATE(b.multi_booking_mm,'MON'),'MON')||'-'||
               TO_CHAR(TO_DATE(b.multi_booking_yy,'YYYY'),'YYYY'),'DD-MON-YYYY') > v_tran_date)           
      LOOP
        IF t.tag IS NOT NULL AND NVL(giacp.v('ENTER_ADVANCED_PAYT'),'N') = 'Y' THEN --added reymon 09172013
             v_tag := 'Y';
             EXIT;
        END IF;         
      END LOOP;
      
      RETURN v_tag;

   END;
/



DROP PROCEDURE CPI.GICLS032_CHECK_TSI;

CREATE OR REPLACE PROCEDURE CPI.gicls032_check_tsi (
   p_claim_id            gicl_item_peril.claim_id%TYPE,
   p_item_no             gicl_item_peril.item_no%TYPE,
   p_peril_cd            gicl_item_peril.peril_cd%TYPE,
   p_selected_clm_loss   VARCHAR2
)
IS
   v_tsi          gicl_item_peril.ann_tsi_amt%TYPE;
   v_paid         gicl_clm_loss_exp.paid_amt%TYPE;
   v_net          gicl_clm_loss_exp.net_amt%TYPE;
   v_advise       gicl_clm_loss_exp.advise_amt%TYPE;
   v_adv_paid     gicl_clm_loss_exp.paid_amt%TYPE;
   v_adv_net      gicl_clm_loss_exp.net_amt%TYPE;
   v_adv_advise   gicl_clm_loss_exp.advise_amt%TYPE;
   v_loss         gicl_clm_loss_exp.net_amt%TYPE;
   v_clm_loss_id         VARCHAR2 (5);
   v_selected_clm_loss   VARCHAR2 (1000);
BEGIN
   FOR t IN (SELECT ann_tsi_amt
               FROM gicl_item_peril
              WHERE claim_id = p_claim_id AND item_no = p_item_no AND peril_cd = p_peril_cd)
   LOOP
      v_tsi := t.ann_tsi_amt;
   END LOOP;

   FOR p IN (SELECT SUM (a.paid_amt) paid, SUM (a.net_amt) net, SUM (a.advise_amt) ADVISE
               FROM gicl_clm_loss_exp a, gicl_advice b
              WHERE a.claim_id = b.claim_id
                AND a.advice_id = b.advice_id
                AND a.claim_id = p_claim_id
                AND a.item_no = p_item_no
                AND a.peril_cd = p_peril_cd
                AND a.payee_type = 'L')
   LOOP
      v_paid := p.paid;
      v_net := p.net;
      v_advise := p.ADVISE;
   END LOOP;

   v_adv_paid := 0;
   v_adv_net := 0;
   v_adv_advise := 0;
   
   v_selected_clm_loss := p_selected_clm_loss;
   
   FOR i IN (SELECT item_no, peril_cd, payee_type, clm_loss_id, paid_amt, net_amt, advise_amt
               FROM gicl_clm_loss_exp
              WHERE claim_id = p_claim_id AND advice_id IS NULL)
   LOOP
      v_clm_loss_id := '#' || i.clm_loss_id || '#';

      IF INSTR (v_selected_clm_loss, v_clm_loss_id) != 0
      THEN
         IF i.item_no = p_item_no AND i.peril_cd = p_peril_cd AND i.payee_type = 'L'
         THEN
            v_adv_paid := v_adv_paid + i.paid_amt;
            v_adv_net := v_adv_net + i.net_amt;
            v_adv_advise := v_adv_advise + i.advise_amt;
         END IF;

         SELECT LTRIM (RTRIM (REPLACE (v_selected_clm_loss, v_clm_loss_id), ','), ',')
           INTO v_selected_clm_loss
           FROM DUAL;
      END IF;
   END LOOP;

   v_loss := NVL (v_net, 0) + NVL (v_adv_net, 0);

   IF v_loss > v_tsi
   THEN
      raise_application_error
         (-20001,
          'Geniisys Exception#CONFIRM_TSI#Generating an advice for this item-peril would already exceed the TSI of the policy. Would you like to continue?'
         );
   END IF;
END;
/



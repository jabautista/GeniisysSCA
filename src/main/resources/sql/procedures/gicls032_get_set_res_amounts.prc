DROP PROCEDURE CPI.GICLS032_GET_SET_RES_AMOUNTS;

CREATE OR REPLACE PROCEDURE CPI.gicls032_get_set_res_amounts (
   p_claim_id         gicl_clm_loss_exp.claim_id%TYPE,
   p_advice_id        gicl_clm_loss_exp.advice_id%TYPE,
   p_selected_clm_loss IN VARCHAR2,
   v_loss_set_amt   OUT   NUMBER,
   v_exp_set_amt    OUT   NUMBER,
   v_loss_res_amt   OUT   NUMBER,
   v_exp_res_amt    OUT   NUMBER 
)
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - get_set_res_amounts
  */

   --added variable by MAGeamoga 08/23/2011
   v_net_amt1             NUMBER;
   v_net_amt2             NUMBER;
   v_clm_loss_id          VARCHAR2 (50);
   --added variable by MAGeamoga 09/14/2011
   v_final_loss_set_amt   NUMBER        := 0;
   v_final_exp_set_amt    NUMBER        := 0;
   v_final_loss_res_amt   NUMBER        := 0;
   v_final_exp_res_amt    NUMBER        := 0;
   v_get_res_amount       BOOLEAN       := FALSE;
   v_grouped_item_no      gicl_clm_loss_exp.grouped_item_no%TYPE;
   
   v_selected_clm_loss    VARCHAR2(1000);
BEGIN
   v_selected_clm_loss := p_selected_clm_loss;

   FOR i IN(
      SELECT grouped_item_no
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id
         AND NVL(advice_id, 0) = NVL(p_advice_id, 0))
   LOOP
     v_grouped_item_no := i.grouped_item_no; 
     EXIT;
   END LOOP;


--added an outer loop that will get all the peril_cd of the all the item_no MAGeamoga 09/14/2011
   FOR x IN (SELECT   item_no, peril_cd
                 FROM gicl_clm_loss_exp
                WHERE NVL (dist_sw, 'N') = 'Y'
                  AND claim_id = p_claim_id
                  AND item_no IN (SELECT DISTINCT (item_no)
                                             FROM gicl_clm_loss_exp
                                            WHERE NVL (dist_sw, 'N') = 'Y' 
                                              AND claim_id = p_claim_id 
                                              AND grouped_item_no = 0)
                  AND grouped_item_no = v_grouped_item_no
             GROUP BY item_no, peril_cd)
   LOOP
--get the sum of the amounts of approved advice and the current advice
      BEGIN
         v_loss_set_amt := 0;
         v_exp_set_amt := 0;

         --SELECT SUM(decode(payee_type, 'L', paid_amt, 0)), SUM(decode(payee_type, 'E', paid_amt, 0)) --modified by MAGeamoga 08/17/2011
         --added condition by MAGeamoga 08/17/2011
         IF p_advice_id IS NOT NULL
         THEN                                                                                    --this is for APPROVE CSR button
            BEGIN                                        --modified by MAGeamoga 09/14/2011 put select statement in a pl/sql code
--               SELECT   SUM (DECODE (payee_type, 'L', net_amt, 0)),
--                        SUM (DECODE (payee_type, 'E', net_amt, 0))                              --modified by MAGeamoga 08/17/2011
               SELECT   SUM (DECODE (payee_type, 'L', net_amt * currency_rate, 0)), -- bonok :: 8.18.2014
                        SUM (DECODE (payee_type, 'E', net_amt * currency_rate, 0)) -- bonok :: 8.18.2014
                   INTO v_loss_set_amt,
                        v_exp_set_amt
                   FROM gicl_clm_loss_exp a
                  WHERE NVL (dist_sw, 'N') = 'Y'
                    AND EXISTS (
                           SELECT 1
                             FROM gicl_advice
                            WHERE claim_id = a.claim_id
                              AND advice_id = a.advice_id
                              AND (advice_flag = 'Y' AND advice_id = p_advice_id))
                                                                          --modified by MAGeamoga 09/14/2011 changed 'or' to 'and'
                    --and (apprvd_tag = 'Y' or advice_id = p_advice_id))comment out by MAGeamoga 09/08/2011
                    AND claim_id = p_claim_id
                    AND item_no = x.item_no                     --modified by MAGeamoga 09/14/2011. Instead of using :c011.item_no
                    AND peril_cd = x.peril_cd                  --modified by MAGeamoga 09/14/2011. Instead of using :c011.peril_cd
                    AND grouped_item_no = v_grouped_item_no
               GROUP BY item_no, peril_cd, grouped_item_no;

               v_get_res_amount := TRUE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_get_res_amount := FALSE;
            END;
         ELSE                                                 --this is for GENERATE ADVICE button created by MAGeamoga 08/23/2011
            FOR i IN (SELECT clm_loss_id
                        FROM gicl_clm_loss_exp
                       WHERE NVL (dist_sw, 'N') = 'Y'
                         AND claim_id = p_claim_id
                         AND item_no = x.item_no                --modified by MAGeamoga 09/14/2011. Instead of using :c011.item_no
                         AND peril_cd = x.peril_cd             --modified by MAGeamoga 09/14/2011. Instead of using :c011.peril_cd
                         AND grouped_item_no = v_grouped_item_no)
            LOOP
               v_clm_loss_id := '#' || i.clm_loss_id || '#';

               IF INSTR (v_selected_clm_loss, v_clm_loss_id) != 0
               THEN
--                  SELECT   SUM (DECODE (payee_type, 'L', net_amt, 0)), SUM (DECODE (payee_type, 'E', net_amt, 0))
                  SELECT   SUM (DECODE (payee_type, 'L', net_amt * currency_rate, 0)), SUM (DECODE (payee_type, 'E', net_amt * currency_rate, 0)) -- bonok :: 08.18.2014
                      INTO v_net_amt1, v_net_amt2
                      FROM gicl_clm_loss_exp
                     WHERE NVL (dist_sw, 'N') = 'Y'
                       AND claim_id = p_claim_id
                       AND item_no = x.item_no                  --modified by MAGeamoga 09/14/2011. Instead of using :c011.item_no
                       AND peril_cd = x.peril_cd               --modified by MAGeamoga 09/14/2011. Instead of using :c011.peril_cd
                       AND grouped_item_no = v_grouped_item_no
                       AND clm_loss_id = i.clm_loss_id
                       AND advice_id IS NULL                                             --added condition by MAGeamoga 09/14/2011
                  GROUP BY item_no, peril_cd, grouped_item_no;

                  v_loss_set_amt := v_loss_set_amt + v_net_amt1;
                  v_exp_set_amt := v_exp_set_amt + v_net_amt2;

                  --added by MAGeamoga 09/14/2011.
                  SELECT LTRIM (RTRIM (REPLACE (v_selected_clm_loss, v_clm_loss_id), ','), ',')
                    INTO v_selected_clm_loss
                    FROM DUAL;

                  v_get_res_amount := TRUE;
               END IF;
            END LOOP;
            
            --added query by MAGeamgoa 09/08/2011 to get the net_amt of the current claim id with advice id
            IF v_get_res_amount
            THEN                                                                                   --added by MAGeamoga 09/14/2011
               FOR i IN (SELECT   --SUM (DECODE (payee_type, 'L', net_amt, 0)) v_net_amt1,
                                  --SUM (DECODE (payee_type, 'E', net_amt, 0)) v_net_amt2
                                  SUM (DECODE (payee_type, 'L', net_amt * currency_rate, 0)) v_net_amt1, -- bonok :: 8.18.2014
                                  SUM (DECODE (payee_type, 'E', net_amt * currency_rate, 0)) v_net_amt2 -- bonok :: 8.18.2014
                             FROM gicl_clm_loss_exp a
                            WHERE NVL (dist_sw, 'N') = 'Y'
                              AND claim_id = p_claim_id
                              AND item_no = x.item_no           --modified by MAGeamoga 09/14/2011. Instead of using :c011.item_no
                              AND peril_cd = x.peril_cd        --modified by MAGeamoga 09/14/2011. Instead of using :c011.peril_cd
                              AND grouped_item_no = v_grouped_item_no
                              AND advice_id IS NOT NULL
                              AND NOT EXISTS (SELECT 1 --added condition to select only records not yet final by MAC 04/22/2014.
                                                FROM gicl_clm_res_hist b
                                               WHERE b.claim_id = a.claim_id
                                                 AND b.clm_loss_id = a.clm_loss_id
                                                 AND b.advice_id = a.advice_id
                                                 AND NVL (cancel_tag, 'N') = 'N')
                         GROUP BY item_no, peril_cd, grouped_item_no)
               LOOP
                  v_loss_set_amt := v_loss_set_amt + NVL (i.v_net_amt1, 0);
                  v_exp_set_amt := v_exp_set_amt + NVL (i.v_net_amt2, 0);
               END LOOP;
               
               --select all final claim payments by MAC 04/22/2014.
               FOR i IN (SELECT --SUM (NVL (a.losses_paid, 0)) v_net_amt1,
                               --SUM (NVL (a.expenses_paid, 0)) v_net_amt2
                               SUM (NVL (a.losses_paid * a.convert_rate, 0)) v_net_amt1, -- bonok :: 8.18.2014
                               SUM (NVL (a.expenses_paid * a.convert_rate, 0)) v_net_amt2 -- bonok :: 8.18.2014
                          FROM gicl_clm_res_hist a
                         WHERE a.tran_id IS NOT NULL 
                           AND NVL (a.cancel_tag, 'N') = 'N'
                           AND a.claim_id = p_claim_id
                           AND a.item_no = x.item_no         
                           AND a.peril_cd = x.peril_cd    
                           AND a.grouped_item_no = v_grouped_item_no
                         GROUP BY a.claim_id, a.item_no, a.peril_cd, a.grouped_item_no)
               LOOP
                  v_loss_set_amt := v_loss_set_amt + NVL (i.v_net_amt1, 0);
                  v_exp_set_amt := v_exp_set_amt + NVL (i.v_net_amt2, 0);
               END LOOP;
            END IF;
         END IF;                                                                     --end of modification by MAGeamoga 08/17/2011
      EXCEPTION
         WHEN OTHERS
         THEN
            v_loss_set_amt := 0;
            v_exp_set_amt := 0;
      END;

      --added by MAGeamoga 09/14/2011
      v_loss_res_amt := 0;
      v_exp_res_amt := 0;

      BEGIN
         IF v_get_res_amount
         THEN                                                                           --added condition by MAGeamoga 09/14/2011
            --SELECT NVL (loss_reserve, 0), NVL (expense_reserve, 0)
            SELECT NVL (loss_reserve * convert_rate, 0), NVL (expense_reserve * convert_rate, 0) -- bonok :: 8.18.2014
              INTO v_loss_res_amt, v_exp_res_amt
              FROM gicl_clm_res_hist
             WHERE NVL (dist_sw, 'N') = 'Y'
               AND claim_id = p_claim_id
               AND item_no = x.item_no                          --modified by MAGeamoga 09/14/2011. Instead of using :c011.item_no
               AND peril_cd = x.peril_cd                       --modified by MAGeamoga 09/14/2011. Instead of using :c011.peril_cd
               AND grouped_item_no = v_grouped_item_no;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_loss_res_amt := 0;
            v_exp_res_amt := 0;
      END;

      --added by MAGeamoga 09/14/2011
      IF v_loss_set_amt > v_loss_res_amt OR v_exp_set_amt > v_exp_res_amt
      THEN
         RETURN;
      END IF;

      v_get_res_amount := FALSE;
      IF v_selected_clm_loss IS NULL AND p_advice_id IS NULL THEN
        RETURN;
      END IF;
   END LOOP;                                                                       --end of the outer loop by MAGeamoga 09/14/2011
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giclr543_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.13.2013
     **  Reference By : GICLR543
     **  Description  : Reported Claims per Intermediary
     */
   FUNCTION cf_company_name
      RETURN VARCHAR2
   IS
      ws_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_company := NULL;
      END;

      RETURN (ws_company);
   END;

   FUNCTION cf_company_address
      RETURN VARCHAR2
   IS
      ws_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_address := NULL;
      END;

      RETURN (ws_address);
   END;

   FUNCTION cf_titleformula (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('REPORTED CLAIMS PER INTERMEDIARY - LOSSES');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('REPORTED CLAIMS PER INTERMEDIARY - EXPENSES');
      ELSE
         RETURN ('REPORTED CLAIMS PER INTERMEDIARY');
      END IF;
   END;

   FUNCTION cf_dateformula (p_start_dt DATE, p_end_dt DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'from '
              || TO_CHAR (p_start_dt, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_end_dt, 'fmMonth DD, YYYY')
             );
   END;

   FUNCTION intm_descformula (p_intm_type VARCHAR2)
      RETURN CHAR
   IS
      des   VARCHAR2 (50);
   BEGIN
      FOR i IN (SELECT intm_desc
                  FROM giis_intm_type
                 WHERE intm_type = p_intm_type)
      LOOP
         des := i.intm_desc;
      END LOOP;

      RETURN (p_intm_type || '-' || des);
   END;

   FUNCTION cf_assured_name (p_assd_no NUMBER)
      RETURN VARCHAR2
   IS
      v_assured   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN (SELECT assd_name
                  FROM giis_assured
                 WHERE assd_no = p_assd_no)
      LOOP
         v_assured := i.assd_name;
      END LOOP;

      RETURN (v_assured);
   END;

   FUNCTION cf_clm_stat (p_clm_stat_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_clm_stat   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      FOR i IN (SELECT clm_stat_desc
                  FROM giis_clm_stat
                 WHERE clm_stat_cd = p_clm_stat_cd)
      LOOP
         v_clm_stat := i.clm_stat_desc;
      END LOOP;

      RETURN (v_clm_stat);
   END;

   FUNCTION cf_clm_amtformula (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('Loss Amount');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('Expense Amount');
      ELSE
         RETURN ('Claim Amount');
      END IF;
   END;

   FUNCTION parent_loss_amount (
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_loss_exp      VARCHAR2
   )
      RETURN NUMBER
   IS
      v_loss_amt   gicl_clm_res_hist.loss_reserve%TYPE;
      v_exist      VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_loss_amt := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'L'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;         END;

         BEGIN
            SELECT SUM (DECODE (NVL (cancel_tag, 'N'),
                                'N', DECODE (tran_id,
                                             NULL, DECODE
                                                       (p_loss_exp,
                                                        'E', NVL
                                                             (  convert_rate
                                                              * expense_reserve,
                                                              0
                                                             ),
                                                        NVL (  convert_rate
                                                             * loss_reserve,
                                                             0
                                                            )
                                                       ),
                                             DECODE (p_loss_exp,
                                                     'E', NVL (  convert_rate
                                                               * expenses_paid,
                                                               0
                                                              ),
                                                     NVL (  convert_rate
                                                          * losses_paid,
                                                          0
                                                         )
                                                    )
                                            ),
                                DECODE (p_loss_exp,
                                        'E', NVL (  convert_rate
                                                  * expense_reserve,
                                                  0
                                                 ),
                                        NVL (convert_rate * loss_reserve, 0)
                                       )
                               )
                       )
              INTO v_loss_amt
              FROM gicl_clm_res_hist
             WHERE claim_id = p_claim_id
               AND peril_cd = p_peril_cd
               AND NVL (dist_sw, '!') =
                               DECODE (v_exist,
                                       NULL, 'Y',
                                       NVL (dist_sw, '!')
                                      )
               AND NVL (tran_id, -1) = DECODE (v_exist, 'x', tran_id, -1);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_loss_amt := 0;
         END;

         IF v_loss_amt IS NULL
         THEN
            RETURN (0);
         END IF;
      END IF;

      RETURN (v_loss_amt);
   END;

   FUNCTION parent_exp_amount (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_exp_amt   gicl_clm_res_hist.expense_reserve%TYPE;
      v_exist     VARCHAR2 (1);
   BEGIN
            
     IF    p_loss_exp NOT IN ('LE', 'E')
         OR (   p_clm_stat_cd = 'CC'
             OR p_clm_stat_cd = 'DN'
             OR p_clm_stat_cd = 'WD'
            )
      THEN
         v_exp_amt := NULL;         
      ELSE
         BEGIN
         
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'E'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         BEGIN
            SELECT SUM (DECODE (NVL (cancel_tag, 'N'),
                                'N', DECODE (tran_id,
                                             NULL, NVL (  convert_rate
                                                        * expense_reserve,
                                                        0
                                                       ),
                                             NVL (convert_rate * expenses_paid,
                                                  0
                                                 )
                                            ),
                                NVL (convert_rate * expense_reserve, 0)
                               )
                       )
              INTO v_exp_amt
              FROM gicl_clm_res_hist
             WHERE claim_id = p_claim_id
               AND peril_cd = p_peril_cd
               AND NVL (dist_sw, '!') =
                               DECODE (v_exist,
                                       NULL, 'Y',
                                       NVL (dist_sw, '!')
                                      )
               AND NVL (tran_id, -1) = DECODE (v_exist, 'x', tran_id, -1);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exp_amt := 0;
         END;

         IF v_exp_amt IS NULL
         THEN
            RETURN (0);
         END IF;
      END IF;
        
      RETURN (v_exp_amt);
    
   END;

   FUNCTION parent_retention (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_net_ret   gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist     VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_net_ret := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'L' 
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            FOR p IN (SELECT NVL (SUM (c.convert_rate * shr_le_net_amt),
                                  0
                                 ) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = 1
                         AND a.payee_type = DECODE (p_loss_exp,
                                                    'E', 'E',
                                                    'L'
                                                   ))
            LOOP
               v_net_ret := p.paid;
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                     'E', NVL (SUM (  b.convert_rate
                                                    * a.shr_exp_res_amt
                                                   ),
                                               0
                                              ),
                                     NVL (SUM (  b.convert_rate
                                               * a.shr_loss_res_amt
                                              ),
                                          0
                                         )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = 1)
            LOOP
               v_net_ret := r.reserve;
            END LOOP;
         END IF;
      END IF;

      RETURN (v_net_ret);
   END;

   FUNCTION parent_exp_retention (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_net_ret   gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist     VARCHAR2 (1);
   BEGIN
      IF    p_loss_exp <> 'LE'
         OR (   p_clm_stat_cd = 'CC'
             OR p_clm_stat_cd = 'DN'
             OR p_clm_stat_cd = 'WD'
            )
      THEN
         v_net_ret := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'E'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            SELECT NVL (SUM (c.convert_rate * shr_le_net_amt), 0) paid
              INTO v_net_ret
              FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_advice c
             WHERE a.claim_id = b.claim_id
               AND a.clm_loss_id = b.clm_loss_id
               AND a.claim_id = c.claim_id
               AND a.advice_id = c.advice_id
               AND b.claim_id = p_claim_id
               AND b.peril_cd = p_peril_cd
               AND a.tran_id IS NOT NULL
               AND NVL (b.negate_tag, 'N') = 'N'
               AND b.share_type = 1
               AND a.payee_type = 'E';
         ELSE
            SELECT NVL (SUM (b.convert_rate * a.shr_exp_res_amt), 0) reserve
              INTO v_net_ret
              FROM gicl_reserve_ds a, gicl_clm_res_hist b
             WHERE a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.dist_sw = 'Y'
               AND a.claim_id = p_claim_id
               AND a.peril_cd = p_peril_cd
               AND NVL (a.negate_tag, 'N') = 'N'
               AND a.share_type = 1;
         END IF;
      END IF;

      RETURN (v_net_ret);
   END;

   FUNCTION parent_treaty (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_trty       gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist      VARCHAR2 (1);
      v_shr_type   NUMBER;
   BEGIN
      SELECT param_value_v
        INTO v_shr_type
        FROM giac_parameters
       WHERE param_name = 'TRTY_SHARE_TYPE';

      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_trty := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'L'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            FOR p IN (SELECT NVL (SUM (c.convert_rate * shr_le_net_amt),
                                  0
                                 ) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = v_shr_type
                         AND a.payee_type = DECODE (p_loss_exp,
                                                    'E', 'E',
                                                    'L'
                                                   ))
            LOOP
               v_trty := p.paid;
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                     'E', NVL (SUM (  b.convert_rate
                                                    * a.shr_exp_res_amt
                                                   ),
                                               0
                                              ),
                                     NVL (SUM (  b.convert_rate
                                               * a.shr_loss_res_amt
                                              ),
                                          0
                                         )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = v_shr_type)
            LOOP
               v_trty := r.reserve;
            END LOOP;
         END IF;
      END IF;

      RETURN (v_trty);
   END;

   FUNCTION parent_exp_treaty (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_trty    gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist   VARCHAR2 (1);
   BEGIN
      IF    p_loss_exp <> 'LE'
         OR (   p_clm_stat_cd = 'CC'
             OR p_clm_stat_cd = 'DN'
             OR p_clm_stat_cd = 'WD'
            )
      THEN
         v_trty := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'E'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            SELECT NVL (SUM (c.convert_rate * shr_le_net_amt), 0) paid
              INTO v_trty
              FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_advice c
             WHERE a.claim_id = b.claim_id
               AND a.clm_loss_id = b.clm_loss_id
               AND a.claim_id = c.claim_id
               AND a.advice_id = c.advice_id
               AND b.claim_id = p_claim_id
               AND b.peril_cd = p_peril_cd
               AND a.tran_id IS NOT NULL
               AND NVL (b.negate_tag, 'N') = 'N'
               AND b.share_type = giacp.v ('TRTY_SHARE_TYPE')
               AND a.payee_type = 'E';
         ELSE
            SELECT NVL (SUM (b.convert_rate * a.shr_exp_res_amt), 0) reserve
              INTO v_trty
              FROM gicl_reserve_ds a, gicl_clm_res_hist b
             WHERE a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.dist_sw = 'Y'
               AND a.claim_id = p_claim_id
               AND a.peril_cd = p_peril_cd
               AND NVL (a.negate_tag, 'N') = 'N'
               AND a.share_type = giacp.v ('TRTY_SHARE_TYPE');
         END IF;
      END IF;

      RETURN (v_trty);
   END;

   FUNCTION parent_xol (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_xol        gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist      VARCHAR2 (1);
      v_shr_type   NUMBER;
   BEGIN
      SELECT param_value_v
        INTO v_shr_type
        FROM giac_parameters
       WHERE param_name = 'XOL_TRTY_SHARE_TYPE';

      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_xol := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'L'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            FOR p IN (SELECT NVL (SUM (c.convert_rate * shr_le_net_amt),
                                  0
                                 ) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = v_shr_type
                         AND a.payee_type = DECODE (p_loss_exp,
                                                    'E', 'E',
                                                    'L'
                                                   ))
            LOOP
               v_xol := p.paid;
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                     'E', NVL (SUM (  b.convert_rate
                                                    * a.shr_exp_res_amt
                                                   ),
                                               0
                                              ),
                                     NVL (SUM (  b.convert_rate
                                               * a.shr_loss_res_amt
                                              ),
                                          0
                                         )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = v_shr_type)
            LOOP
               v_xol := r.reserve;
            END LOOP;
         END IF;
      END IF;

      RETURN (v_xol);
   END;

   FUNCTION parent_exp_xol (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_xol     gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist   VARCHAR2 (1);
   BEGIN
      IF    p_loss_exp <> 'LE'
         OR (   p_clm_stat_cd = 'CC'
             OR p_clm_stat_cd = 'DN'
             OR p_clm_stat_cd = 'WD'
            )
      THEN
         v_xol := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'E'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;         END;

         IF v_exist IS NOT NULL
         THEN
            FOR p IN (SELECT NVL (SUM (c.convert_rate * shr_le_net_amt),
                                  0
                                 ) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                         AND a.payee_type = 'E')
            LOOP
               v_xol := p.paid;
            END LOOP;
         ELSE
            FOR r IN (SELECT NVL (SUM (b.convert_rate * a.shr_exp_res_amt),
                                  0
                                 ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE'))
            LOOP
               v_xol := r.reserve;
            END LOOP;
         END IF;
      END IF;

      RETURN (v_xol);
   END;

   FUNCTION parent_facultative (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_facul   gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist   VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_facul := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'L'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            FOR p IN (SELECT NVL (SUM (c.convert_rate * shr_le_net_amt),
                                  0
                                 ) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND b.claim_id = p_claim_id
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                         AND a.payee_type = DECODE (p_loss_exp,
                                                    'E', 'E',
                                                    'L'
                                                   ))
            LOOP
               v_facul := p.paid;
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                     'E', NVL (SUM (  b.convert_rate
                                                    * a.shr_exp_res_amt
                                                   ),
                                               0
                                              ),
                                     NVL (SUM (  b.convert_rate
                                               * a.shr_loss_res_amt
                                              ),
                                          0
                                         )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = giacp.v ('FACUL_SHARE_TYPE'))
            LOOP
               v_facul := r.reserve;
            END LOOP;
         END IF;
      END IF;

      RETURN (v_facul);
   END;

   FUNCTION parent_exp_facultative (
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER
   )
      RETURN NUMBER
   IS
      v_facul   gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist   VARCHAR2 (1);
   BEGIN
      IF    p_loss_exp <> 'LE'
         OR (   p_clm_stat_cd = 'CC'
             OR p_clm_stat_cd = 'DN'
             OR p_clm_stat_cd = 'WD'
            )
      THEN
         v_facul := NULL;
      ELSE
         BEGIN
         /*  replaced by codes below SR 22237 Aliza G.
              SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist 
                      WHERE tran_id IS NOT NULL
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND claim_id = p_claim_id
                        AND peril_cd = p_peril_cd
          */ 
          SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = 'E'  
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;

         IF v_exist IS NOT NULL
         THEN
            SELECT NVL (SUM (c.convert_rate * shr_le_net_amt), 0) paid
              INTO v_facul
              FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_advice c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND a.advice_id = c.advice_id
               AND a.clm_loss_id = b.clm_loss_id
               AND b.claim_id = p_claim_id
               AND b.peril_cd = p_peril_cd
               AND a.tran_id IS NOT NULL
               AND NVL (b.negate_tag, 'N') = 'N'
               AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
               AND a.payee_type = 'E';
         ELSE
            SELECT NVL (SUM (b.convert_rate * a.shr_exp_res_amt), 0) reserve
              INTO v_facul
              FROM gicl_reserve_ds a, gicl_clm_res_hist b
             WHERE a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.dist_sw = 'Y'
               AND a.claim_id = p_claim_id
               AND a.peril_cd = p_peril_cd
               AND NVL (a.negate_tag, 'N') = 'N'
               AND a.share_type = giacp.v ('FACUL_SHARE_TYPE');
         END IF;
      END IF;

      RETURN (v_facul);
   END;

   FUNCTION get_parent_record (
      p_start_dt       DATE,
      p_end_dt         DATE,
      p_intm_no        VARCHAR2,
      p_intermediary   VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_intm_type      VARCHAR2,
      p_subagent       VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN parent_record_tab PIPELINED
   IS
      v_rec   parent_record_type;
      v_print BOOLEAN := TRUE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;
      v_rec.title := cf_titleformula (p_loss_exp);
      v_rec.cf_date := cf_dateformula (p_start_dt, p_end_dt);
      v_rec.cf_clm_amt := cf_clm_amtformula (p_loss_exp);

      FOR i IN
         (SELECT   a.line_cd, a.iss_cd,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                   a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                   a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                   a.renew_no, a.assd_no, b.intrmdry_intm_no parent_no,
                   b.intm_name parent_name, b.intm_type, a.claim_id,
                   a.clm_stat_cd, a.old_stat_cd, a.close_date
              FROM gicl_claims a, gicl_basic_intm_v1 b
             WHERE b.intm_type = NVL (p_intm_type, b.intm_type)
               AND b.intrmdry_intm_no IN (
                      SELECT DISTINCT DECODE (NVL (p_subagent, 1),
                                              1, NVL (parent_intm_no,
                                                      intrmdry_intm_no
                                                     ),
                                              0, intrmdry_intm_no
                                             )
                                 FROM gicl_basic_intm_v1
                                WHERE parent_intm_no =
                                             NVL (p_intm_no, intrmdry_intm_no)
                                   OR (       intrmdry_intm_no =
                                                 NVL (p_intm_no,
                                                      intrmdry_intm_no
                                                     )
                                          AND parent_intm_no IS NOT NULL
                                       OR     intrmdry_intm_no =
                                                 NVL (p_intm_no,
                                                      intrmdry_intm_no
                                                     )
                                          AND parent_intm_no IS NULL
                                      ))
               AND a.claim_id = b.claim_id
               AND TRUNC (a.clm_file_date) BETWEEN NVL (p_start_dt,
                                                        a.clm_file_date
                                                       )
                                               AND NVL (p_end_dt,
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          GROUP BY b.intm_type,
                   a.line_cd,
                   a.iss_cd,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')),
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09')),
                   a.dsp_loss_date,
                   a.clm_file_date,
                   a.pol_eff_date,
                   a.subline_cd,
                   a.pol_iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.assd_no,
                   b.intrmdry_intm_no,
                   b.intm_name,
                   a.claim_id,
                   a.clm_stat_cd,
                   a.old_stat_cd,
                   a.close_date
          ORDER BY    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_print := FALSE;
         v_rec.line_cd := i.line_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.claim_no := i.claim_no;
         v_rec.policy_no := i.policy_no;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.pol_eff_date := i.pol_eff_date;
         v_rec.subline_cd := i.subline_cd;
         v_rec.pol_iss_cd := i.pol_iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.assd_no := i.assd_no;
         v_rec.parent_no := i.parent_no;
         v_rec.parent_name := i.parent_name;
         v_rec.intm_type := i.intm_type;
         v_rec.claim_id := i.claim_id;
         v_rec.clm_stat_cd := i.clm_stat_cd;
         v_rec.old_stat_cd := i.old_stat_cd;
         v_rec.close_date := i.close_date;
         v_rec.intm_desc := intm_descformula (i.intm_type);
         v_rec.cf_parent :=
                          (TO_CHAR (i.parent_no) || ' - ' || (i.parent_name)
                          );
         v_rec.assd_name := cf_assured_name (i.assd_no);
         v_rec.status := cf_clm_stat (i.clm_stat_cd);
         PIPE ROW (v_rec);
      END LOOP;
      IF v_print THEN
        v_rec.v_print := 'TRUE';
        PIPE ROW (v_rec);
      END IF;
   END get_parent_record;

   FUNCTION get_claims_record (
      p_start_dt       DATE,
      p_end_dt         DATE,
      p_intm_no        VARCHAR2,
      p_intermediary   VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_intm_type      VARCHAR2,
      p_subagent       VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN claims_record_tab PIPELINED
   IS
      v_rec   claims_record_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.iss_cd,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                    claim_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assd_no,
                         b.intrmdry_intm_no parent_no,
                         b.intm_name parent_name,
                         DECODE (p_subagent,
                                 1, parent_intm_no,
                                 0, NULL
                                ) parent_intm_no,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         a.close_date
                    FROM gicl_claims a, gicl_basic_intm_v1 b
                   WHERE a.claim_id = b.claim_id
                     AND parent_intm_no = NVL(p_intm_no, parent_intm_no) 
                     AND TRUNC (a.clm_file_date) BETWEEN NVL (p_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (p_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND b.intrmdry_intm_no =
                                           NVL (p_intm_no, b.intrmdry_intm_no)
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                GROUP BY b.intm_type,
                         parent_intm_no,
                         a.line_cd,
                         a.iss_cd,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')),
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.dsp_loss_date,
                         a.clm_file_date,
                         a.pol_eff_date,
                         a.subline_cd,
                         a.pol_iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         a.assd_no,
                         b.intrmdry_intm_no,
                         b.intm_name,
                         a.claim_id,
                         a.clm_stat_cd,
                         a.old_stat_cd,
                         a.close_date
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.claim_no := i.claim_no;
         v_rec.policy_no := i.policy_no;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.pol_eff_date := i.pol_eff_date;
         v_rec.subline_cd := i.subline_cd;
         v_rec.pol_iss_cd := i.pol_iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.assd_no := i.assd_no;
         v_rec.parent_no := i.parent_no;
         v_rec.parent_name := i.parent_name;
         v_rec.parent_intm_no := i.parent_intm_no;
         v_rec.claim_id := i.claim_id;
         v_rec.clm_stat_cd := i.clm_stat_cd;
         v_rec.old_stat_cd := i.old_stat_cd;
         v_rec.close_date := i.close_date;
         v_rec.sub_name :=
                          (TO_CHAR (i.parent_no) || ' - ' || (i.parent_name)
                          );
         v_rec.assd_name := cf_assured_name (i.assd_no);
         v_rec.status := cf_clm_stat (i.clm_stat_cd);
         PIPE ROW (v_rec);
      END LOOP;
   END get_claims_record;
   
   FUNCTION get_peril_record (
      p_line_cd       VARCHAR2,
      p_claim_id      NUMBER,
      p_clm_stat_cd   VARCHAR2,
      p_loss_exp      VARCHAR2
   )
      RETURN peril_record_tab PIPELINED
   IS
      v_rec   peril_record_type;
   BEGIN
      FOR i IN (SELECT DISTINCT c.peril_cd, c.peril_sname, b.claim_id,
                                c.line_cd
                           FROM gicl_item_peril b, giis_peril c
                          WHERE b.peril_cd = c.peril_cd
                            AND c.line_cd = NVL (p_line_cd, c.line_cd)
                            AND b.claim_id = NVL (p_claim_id, b.claim_id))
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.claim_id := i.claim_id;
         v_rec.line_cd := i.line_cd;
         v_rec.parent_loss_amt :=
            parent_loss_amount (p_clm_stat_cd,
                                p_claim_id,
                                i.peril_cd,
                                p_loss_exp
                               );
         v_rec.parent_exp_amt :=
            parent_exp_amount (p_loss_exp,
                               p_clm_stat_cd,
                               p_claim_id,
                               i.peril_cd
                              );
         v_rec.parent_retention :=
            parent_retention (p_loss_exp,
                              p_clm_stat_cd,
                              p_claim_id,
                              i.peril_cd
                             );
         v_rec.parent_exp_retention :=
            parent_exp_retention (p_loss_exp,
                                  p_clm_stat_cd,
                                  p_claim_id,
                                  i.peril_cd
                                 );
         v_rec.parent_treaty :=
             parent_treaty (p_loss_exp, p_clm_stat_cd, p_claim_id, i.peril_cd);
         v_rec.parent_exp_treaty :=
            parent_exp_treaty (p_loss_exp,
                               p_clm_stat_cd,
                               p_claim_id,
                               i.peril_cd
                              );
         v_rec.parent_xol :=
                parent_xol (p_loss_exp, p_clm_stat_cd, p_claim_id, i.peril_cd);
         v_rec.parent_exp_xol :=
            parent_exp_xol (p_loss_exp, p_clm_stat_cd, p_claim_id, i.peril_cd);
         v_rec.parent_facultative :=
            parent_facultative (p_loss_exp,
                                p_clm_stat_cd,
                                p_claim_id,
                                i.peril_cd
                               );
         v_rec.parent_exp_facultative :=
            parent_exp_facultative (p_loss_exp,
                                    p_clm_stat_cd,
                                    p_claim_id,
                                    i.peril_cd
                                   );
         PIPE ROW (v_rec);
      END LOOP;
   END get_peril_record;
END giclr543_pkg;
/

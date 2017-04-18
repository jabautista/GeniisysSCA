CREATE OR REPLACE PACKAGE BODY CPI.giac_op_text_pkg
AS
   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT on GIACS026
   */
   PROCEDURE update_giac_op_text (
      p_gacc_tran_id    giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE,
      p_user_id            giis_users.user_id%TYPE
   )
   IS
      CURSOR c
      IS
        SELECT a.gacc_tran_id,
                  SUM(NVL(a.collection_amt, 0)) item_amt,
               a.b140_iss_cd ||'-'|| TO_CHAR (a.b140_prem_seq_no, 'FM099999999999')||'-'||TO_CHAR(a.inst_no, 'FM09') bill_no,
               'Premium Deposit' item_text,
                  a.currency_cd,
                  SUM(NVL(a.foreign_curr_amt, 0)) foreign_curr_amt
            FROM giac_prem_deposit a
          WHERE gacc_tran_id = p_gacc_tran_id
          GROUP BY a.gacc_tran_id,
                  a.b140_iss_cd ||'-'|| TO_CHAR (a.b140_prem_seq_no, 'FM099999999999')||'-'||TO_CHAR(a.inst_no, 'FM09'),
                  a.currency_cd;
         /* Commented and changed by reymon 01182013 
            Applied by bonok :: 01.21.2013
         SELECT DISTINCT a.gacc_tran_id, a.collection_amt item_amt,
                            a.b140_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                                                     bill_no,
                         a.user_id, a.last_update,
                         'Premium Deposit' item_text, a.currency_cd,
                         a.foreign_curr_amt
                    FROM giac_prem_deposit a
                   WHERE gacc_tran_id = p_gacc_tran_id;*/

      v_seq_no   giac_op_text.item_seq_no%TYPE   := 1;
   BEGIN
      /* Remove first whatever records in giac_op_text. */
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = p_item_gen_type;

      FOR c_rec IN c
      LOOP
        INSERT INTO giac_op_text
                       (gacc_tran_id, item_gen_type, item_seq_no, 
                     item_amt, user_id, last_update, /*line,*/
                     bill_no, item_text, print_seq_no, currency_cd, foreign_curr_amt)
                VALUES (c_rec.gacc_tran_id, p_item_gen_type, v_seq_no, 
                     c_rec.item_amt, /*c_rec.user_id, c_rec.last_update,*/ p_user_id, SYSDATE, /*c_rec.line_cd,*/
                     c_rec.bill_no, c_rec.item_text, v_seq_no, c_rec.currency_cd, c_rec.foreign_curr_amt);
          /* Commented and changed by reymon 01182013 
           Applied by bonok :: 01.21.2013
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_gen_type, item_seq_no,
                      item_amt, user_id, last_update,
                      bill_no, item_text, print_seq_no,
                      currency_cd, foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, p_item_gen_type, v_seq_no,
                      c_rec.item_amt, c_rec.user_id, c_rec.last_update,
                      c_rec.bill_no, c_rec.item_text, v_seq_no,
                      c_rec.currency_cd, c_rec.foreign_curr_amt
                     );*/

         v_seq_no := v_seq_no + 1;
      END LOOP;
   END update_giac_op_text;

    /*
   **  Created by   :  Emman
   **  Date Created :  09.30.2010
   **  Reference By : (GIACS020 - Comm Payts)
   **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT on GIACS020
   */
   PROCEDURE update_giac_op_text_giacs020 (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT   SUM (((a.comm_amt + a.input_vat_amt - a.wtax_amt) * (-1))
                      ) item_amt,
                  SUM ((  (a.comm_amt + a.input_vat_amt - a.wtax_amt)
                        / NVL (a.convert_rate, 1)
                        * (-1)
                       )
                      ) foreign_curr_amt,
                  NVL (a.currency_cd, 1) currency_cd
             FROM giac_comm_payts a, gipi_invoice b, gipi_polbasic c
            WHERE a.iss_cd = b.iss_cd
              AND a.prem_seq_no = b.prem_seq_no
              AND b.iss_cd = c.iss_cd
              AND b.policy_id = c.policy_id
              AND gacc_tran_id = p_gacc_tran_id
              AND a.print_tag = 'Y'
         GROUP BY a.currency_cd;

      ws_seq_no            giac_op_text.item_seq_no%TYPE              := 1;
      ws_gen_type          VARCHAR2 (1)                               := 'N';
      v_or_curr_cd         giac_order_of_payts.currency_cd%TYPE;
      --stores the currency_cd in the O.R.
      v_def_curr_cd        giac_order_of_payts.currency_cd%TYPE
                                           := NVL (giacp.n ('CURRENCY_CD'), 1);
      --stores the default currency_cd
      v_currency_cd        giac_direct_prem_collns.currency_cd%TYPE;
      --stores currency_cd to be inserted
      v_foreign_curr_amt   giac_op_text.foreign_curr_amt%TYPE;
   --stores the foreign currency amt to be inserted
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = ws_gen_type;

      FOR b1 IN (SELECT currency_cd
                   FROM giac_order_of_payts
                  WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_or_curr_cd := b1.currency_cd;
         EXIT;
      END LOOP;

      FOR c_rec IN c
      LOOP
         IF v_or_curr_cd = v_def_curr_cd
         THEN
            v_foreign_curr_amt := c_rec.item_amt;
            v_currency_cd := v_def_curr_cd;
         ELSE
            v_foreign_curr_amt := c_rec.foreign_curr_amt;
            v_currency_cd := c_rec.currency_cd;
         END IF;

         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, item_gen_type, item_text,
                      item_amt, user_id,
                      last_update, print_seq_no, currency_cd, foreign_curr_amt
                     )
              VALUES (p_gacc_tran_id, ws_seq_no, ws_gen_type, 'COMMISSION',
                      c_rec.item_amt, NVL (giis_users_pkg.app_user, USER),
                      SYSDATE, ws_seq_no, v_currency_cd, v_foreign_curr_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END update_giac_op_text_giacs020;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.08.2010
   **  Reference By : (GIACS008 - Inwar Facul Prem Collns)
   **  Description  : delete records in GIAC_OP_TEXT
   */
   PROCEDURE del_giac_op_text (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_item_gen_type   giac_op_text.item_gen_type%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = p_item_gen_type;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.08.2010
   **  Reference By : (GIACS008 - Inwar Facul Prem Collns)
   **  Description  : delete records in GIAC_OP_TEXT
   */
   PROCEDURE del_giac_op_text2 (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_item_gen_type   giac_op_text.item_gen_type%TYPE
   )
   IS
   BEGIN
      DELETE      giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND NVL (item_amt, 0) = 0
              AND SUBSTR (item_text, 1, 9) <> ('PREMIUM (')
              AND item_gen_type = p_item_gen_type;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.15.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : delete records in GIAC_OP_TEXT
   */
   PROCEDURE del_giac_op_text3 (
      p_gacc_tran_id    giac_op_text.gacc_tran_id%TYPE,
      p_item_seq_no     giac_op_text.item_seq_no%TYPE,
      p_item_gen_type   giac_op_text.item_gen_type%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_seq_no = p_item_seq_no
              AND item_gen_type = p_item_gen_type;
   END;

   /*
   **  Created by   :  Anthony Santos
   **  Date Created :  10.12.2010
   **  Reference By : (GIACS007 )
   **  Description  : gen_op_text
   */
   PROCEDURE gen_op_text (
      p_tran_source                  VARCHAR2,
      p_or_flag                      VARCHAR2,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name                  giac_modules.module_name%TYPE,
      p_iss_cd                  IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no             IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                      giac_comm_payts.inst_no%TYPE,
      p_tran_type                    giac_comm_payts.tran_type%TYPE,
      p_prem_amt                     giac_direct_prem_collns.premium_amt%TYPE,
      p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giacs007_record_count        NUMBER,
      p_prem_vatable                 giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt                 giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated                 giac_direct_prem_collns.prem_zero_rated%TYPE
   )
   IS
      v_continue   BOOLEAN := TRUE;
   BEGIN
      IF p_tran_source = 'DV'
      THEN
         giac_op_text_pkg.update_giac_dv_text (p_giop_gacc_tran_id,
                                               p_module_name
                                              );
      ELSIF p_tran_source IN ('OP', 'OR')
      THEN
         IF p_or_flag = 'P'
         THEN
            NULL;
         ELSE
            IF NVL (giacp.v ('TAX_ALLOCATION'), 'Y') = 'Y'
            THEN
               giac_op_text_pkg.update_giac_op_text_y
                                                     (p_giop_gacc_tran_id,
                                                      p_iss_cd,
                                                      p_prem_seq_no,
                                                      p_inst_no,
                                                      p_tran_type,
                                                      p_module_name,
                                                      p_prem_amt,
                                                      p_giop_gacc_fund_cd,
                                                      p_giacs007_record_count,
                                                      p_prem_vatable,
                                                      p_prem_vat_exempt,
                                                      p_prem_zero_rated
                                                     );
            ELSE
               giac_op_text_pkg.update_giac_op_text_n (p_giop_gacc_tran_id,
                                                       p_iss_cd,
                                                       p_prem_seq_no,
                                                       p_inst_no,
                                                       p_tran_type,
                                                       p_prem_amt,
                                                       p_module_name,
                                                       p_giop_gacc_fund_cd
                                                      );
            END IF;
         END IF;
      END IF;
   END gen_op_text;

   /*
    **  Created by   :  Anthony Santos
    **  Date Created :  10.12.2010
    **  Reference By : (GIACS007 )
    **  Description  : update_giac_op_text_y
    */
   PROCEDURE update_giac_op_text_y (
      p_giop_gacc_tran_id        giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_iss_cd              IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                  giac_comm_payts.inst_no%TYPE,
      p_tran_type                giac_comm_payts.tran_type%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_prem_amt                 giac_direct_prem_collns.premium_amt%TYPE,
      p_giop_gacc_fund_cd        giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_total_records            NUMBER,                   -- alfie: 03-15-2011
      p_prem_vatable             giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt             giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated             giac_direct_prem_collns.prem_zero_rated%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT DISTINCT a.collection_amt, a.premium_amt, b.currency_cd,
                         b.currency_rt, a.tax_amt
                    FROM giac_direct_prem_collns a,
                         gipi_invoice b,
                         gipi_polbasic c
                   WHERE a.b140_iss_cd = b.iss_cd
                     AND a.b140_prem_seq_no = b.prem_seq_no
                     AND b.iss_cd = c.iss_cd
                     AND b.policy_id = c.policy_id
                     AND gacc_tran_id = p_giop_gacc_tran_id
                     AND a.b140_iss_cd = p_iss_cd
                     AND a.b140_prem_seq_no = p_prem_seq_no
                     AND a.inst_no = p_inst_no;

      v_coll_amt            NUMBER (14, 2)                              := 0;
      v_prem_amt            NUMBER (14, 2)                              := 0;
      v_tax_amt             NUMBER (14, 2)                              := 0;
      v_tax_cd              giac_tax_collns.b160_tax_cd%TYPE;
      v_exist               VARCHAR2 (1);
      v_cursor_exist        BOOLEAN;
      v_gen_type            giac_modules.generation_type%TYPE;
      --p_seq_no number:= 3;
      v_continue            BOOLEAN                                    := TRUE;
      v_currency_rt         giac_direct_prem_collns.convert_rate%TYPE;
      v_currency_cd         giac_direct_prem_collns.currency_cd%TYPE;
      v_zero_prem_op_text   VARCHAR2 (2);
      v_seq_no              giac_op_text.item_seq_no%TYPE;
   BEGIN
      v_seq_no := 0;

      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                               (-20005,
                                'This module does not exist in giac_modules.'
                               );
      END;

      BEGIN
         SELECT currency_rt, main_currency_cd
           INTO v_currency_rt, v_currency_cd
           FROM giis_currency
          WHERE main_currency_cd = (SELECT currency_cd
                                      FROM giac_order_of_payts
                                     WHERE gacc_tran_id = p_giop_gacc_tran_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      
--COMMENTED BY TONIO May 13, 2011 Created new procedure for this--
/*
      BEGIN
         DELETE      giac_op_text
               WHERE gacc_tran_id = p_giop_gacc_tran_id
                 AND item_gen_type = v_gen_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20005,
                                     'No records found in Giac_Op_Text.'
                                    );
      END;
*/
      IF p_tran_type IS NULL
      THEN
         NULL;
      ELSE
         v_seq_no := 3;
         v_zero_prem_op_text := 'Y';
         v_cursor_exist := FALSE;
--COMMENTED BY TONIO May 13, 2011 Removed loop and condition--
         --IF p_total_records > 0 THEN
           --FOR i in 1..p_total_records LOOP
         FOR c_rec IN c
         LOOP
            giac_op_text_pkg.check_op_text_insert_y (c_rec.premium_amt,
                                                     c_rec.currency_cd,
                                                     c_rec.currency_rt,
                                                     p_iss_cd,
                                                     p_prem_seq_no,
                                                     p_giop_gacc_tran_id,
                                                     p_inst_no,
                                                     p_giop_gacc_fund_cd,
                                                     v_zero_prem_op_text,
                                                     v_seq_no,
                                                     p_module_name,
                                                     v_gen_type,
                                                     p_prem_vatable,
                                                     p_prem_vat_exempt,
                                                     p_prem_zero_rated
                                                    );
            v_cursor_exist := TRUE;
         END LOOP;

         IF NOT v_cursor_exist
         THEN

            giac_op_text_pkg.check_op_text_insert_y (p_prem_amt,
                                                     v_currency_cd,
                                                     v_currency_rt,
                                                     p_iss_cd,
                                                     p_prem_seq_no,
                                                     p_giop_gacc_tran_id,
                                                     p_inst_no,
                                                     p_giop_gacc_fund_cd,
                                                     v_zero_prem_op_text,
                                                     v_seq_no,
                                                     p_module_name,
                                                     v_gen_type,
                                                     p_prem_vatable,
                                                     p_prem_vat_exempt,
                                                     p_prem_zero_rated
                                                    );
         END IF;

           --END LOOP;
         --END IF;
         v_zero_prem_op_text := 'N';

         /*
         ** delete from giac_op_text
         ** where item_amt = 0
         */
         /*
         BEGIN
            --null;
            
            DELETE      giac_op_text
                  WHERE gacc_tran_id = p_giop_gacc_tran_id
                    AND NVL (item_amt, 0) = 0
                    AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (
                                                               SELECT tax_cd
                                                                 FROM giac_taxes)
                    AND SUBSTR (item_text, 1, 9) <> 'PREMIUM ('
                    --v--
                    AND item_gen_type = v_gen_type;

            IF SQL%FOUND
            THEN
               NULL;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                      (-20005,
                       'No records found in Giac_Op_Text where item_amt = 0.'
                      );
         END;*/
         
         --COMMENTED BY TONIO May 13, 2011 Created new procedure for this--
             /*
         BEGIN
         null;
            /*

            UPDATE giac_op_text
               SET item_text =
                            SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
             WHERE gacc_tran_id = p_giop_gacc_tran_id
               AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd
                                                               FROM giac_taxes)
               AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
               AND item_gen_type = v_gen_type;
               
            IF SQL%FOUND
            THEN
               NULL;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  (-20005,
                   'No records found in Giac_Op_Text where item_text = Taxes.'
                  );
         END;*/
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   /*
       raise_application_error
                            (-20005,
                             'Error occured during update of Giac_Op_Text.'
                            );*/
   END update_giac_op_text_y;

    /*
   **  Created by   :  Anthony Santos
   **  Date Created :  10.12.2010
   **  Reference By : (GIACS007 )
   **  Description  : check_op_text_insert_y
   */
   PROCEDURE check_op_text_insert_y (
      p_premium_amt         IN       NUMBER,
      p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
      p_iss_cd              IN       giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN       giac_comm_payts.prem_seq_no%TYPE,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_inst_no                      giac_comm_payts.inst_no%TYPE,
      p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_zero_prem_op_text   IN OUT   VARCHAR2,
      p_seq_no              IN OUT   NUMBER,
      p_module_name                  giac_modules.module_name%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE,
      p_prem_vatable        IN         giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt        IN         giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated        IN         giac_direct_prem_collns.prem_zero_rated%TYPE
   )
   IS
      v_exist             VARCHAR2 (1);
      n_seq_no            NUMBER (2);
      v_tax_name          VARCHAR2 (100);
      v_tax_cd            NUMBER (2);
      v_sub_tax_amt       NUMBER (14, 2);
      v_count             NUMBER                                      := 0;
      v_check_name        VARCHAR2 (100)                           := 'GRACE';
                      --modified by alfie, from VARCHAR2(20) to VARCHAR2(100)
      v_no                NUMBER                                      := 1;
      v_currency_cd       giac_direct_prem_collns.currency_cd%TYPE;
      v_convert_rate      giac_direct_prem_collns.convert_rate%TYPE;
      v_prem_type         VARCHAR2 (1)                                := 'E';
      v_prem_text         VARCHAR2 (25);
      v_or_curr_cd        giac_order_of_payts.currency_cd%TYPE;
      v_def_curr_cd       giac_order_of_payts.currency_cd%TYPE
                                          := NVL (giacp.n ('CURRENCY_CD'), 1);
      v_inv_tax_amt       gipi_inv_tax.tax_amt%TYPE;
      v_inv_tax_rt        gipi_inv_tax.rate%TYPE;
      v_inv_prem_amt      gipi_invoice.prem_amt%TYPE;
      v_tax_colln_amt     giac_tax_collns.tax_amt%TYPE;
      v_premium_amt       gipi_invoice.prem_amt%TYPE;
      v_exempt_prem_amt   gipi_invoice.prem_amt%TYPE;
      v_init_prem_text    VARCHAR2 (25);
      v_curr_item_amt     giac_op_text.item_amt%TYPE;
      v_been_inserted      BOOLEAN := FALSE;
      v_spcl_bill         VARCHAR2(1) := 'N';
      --added by reymon 08162013
      v_peril_sw          giis_tax_charges.peril_sw%TYPE;
      v_evat_amt          giac_tax_collns.tax_amt%TYPE;
      v_rec               NUMBER := 0; --john 2.12.15
      
   BEGIN
      v_premium_amt := p_premium_amt;

      BEGIN
         SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
                c.tax_amt inv_tax_amt, c.rate inv_tax_rt,
                b.prem_amt inv_prem_amt,
                d.peril_sw --reymon 08162013
           INTO v_prem_type,
                v_inv_tax_amt, v_inv_tax_rt,
                v_inv_prem_amt,
                v_peril_sw --reymon 08162013
           FROM gipi_invoice b, gipi_inv_tax c,
                giis_tax_charges d --reymon 08162013
          WHERE b.iss_cd = c.iss_cd
            AND b.prem_seq_no = c.prem_seq_no
            AND c.iss_cd = d.iss_cd --reymon 08162013
            AND c.line_cd = d.line_cd --reymon 08162013
            AND c.tax_cd = d.tax_cd --reymon 08162013
            AND d.expired_sw = 'N'
            AND c.tax_cd = giacp.n ('EVAT')
            AND c.iss_cd = p_iss_cd
            AND c.prem_seq_no = p_prem_seq_no;

      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF v_prem_type = 'V'
      THEN
         v_prem_text := 'PREMIUM (VATABLE)';
         n_seq_no := 1;
         --Separate the vatable and vat-exempt premiums
         --for cases where the evat is peril dependent. Note the 1 peso variance, as per Ms. J.
         --If the difference is <= 1 then all the amt should be for the vatable premium

         /*commented out and changed by reymon 08162013
         IF   ABS (  v_inv_prem_amt
                   - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2)
                  )
            * p_convert_rate > 1
         THEN*/
         IF v_peril_sw = 'Y' AND p_premium_amt <> 0 THEN
            BEGIN
               SELECT NVL (tax_amt, 0)
                 INTO v_tax_colln_amt
                 FROM giac_tax_collns
                WHERE gacc_tran_id = p_giop_gacc_tran_id
                  AND b160_iss_cd = p_iss_cd
                  AND b160_prem_seq_no = p_prem_seq_no
                  AND inst_no = p_inst_no
                  AND b160_tax_cd = giacp.n ('EVAT');

            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_tax_colln_amt := 0;
            END;

            IF v_tax_colln_amt <> 0
            THEN
               v_premium_amt :=
                              --ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2); --mikel 09.11.2015; comment outto avoid zero divide error
                              p_prem_vatable; --mikel 09.11.2015; UCBGEN 20211
               v_exempt_prem_amt := p_premium_amt - v_premium_amt;

               IF ABS (v_exempt_prem_amt) <= 1
               THEN
                  v_premium_amt := p_premium_amt;
                  v_exempt_prem_amt := NULL;
               END IF;
            END IF;
         END IF;
      ELSIF v_prem_type = 'Z'
      THEN
         v_prem_text := 'PREMIUM (ZERO-RATED)';
         n_seq_no := 2;
      ELSE
         v_prem_text := 'PREMIUM (VAT-EXEMPT)';
         n_seq_no := 3;
      END IF;

    --added by reymon 08162013 for proper particulars when evat is zero
      BEGIN
            SELECT SUM(NVL(tax_amt, 0)) evat_amt
              INTO v_evat_amt
              FROM giac_tax_collns e
             WHERE e.gacc_tran_id = p_giop_gacc_tran_id
               AND e.b160_tax_cd = giacp.n ('EVAT')
               AND EXISTS (SELECT 'X'
                             FROM gipi_polbasic d, gipi_invoice c
                            WHERE d.policy_id = c.policy_id
                              AND c.iss_cd = e.b160_iss_cd
                              AND c.prem_seq_no = e.b160_prem_seq_no
                              AND EXISTS (SELECT 'X'
                                            FROM gipi_polbasic a, gipi_invoice b
                                           WHERE a.policy_id = b.policy_id
                                             AND a.line_cd = d.line_cd
                                             AND a.subline_cd = d.subline_cd
                                             AND a.iss_cd = d.iss_cd
                                             AND a.issue_yy = d.issue_yy
                                             AND a.pol_seq_no = d.pol_seq_no
                                             AND b.iss_cd = p_iss_cd
                                             AND b.prem_seq_no = p_prem_seq_no))
            HAVING COUNT(e.b160_prem_seq_no) > 1;
        IF v_evat_amt = 0 THEN
            SELECT DECODE(a.vat_tag, 3, 1, 2, 2, 1, 3, 1) n_seq_no,
                       DECODE(a.vat_tag, 3, 'PREMIUM (VATABLE)',
                                         2, 'PREMIUM (ZERO-RATED)',
                                         1, 'PREMIUM (VAT-EXEMPT)', 'PREMIUM (VATABLE)') prem_text
                  INTO n_seq_no, v_prem_text
                  FROM giis_assured a, gipi_polbasic b, gipi_invoice c
                 WHERE a.assd_no = b.assd_no
                   AND b.policy_id = c.policy_id
                   AND c.iss_cd = p_iss_cd
                   AND c.prem_seq_no = p_prem_seq_no;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
      END;
      --end 08162013

      --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
      --should also be in the default  currency regardless of what currency_cd is in the invoice
      FOR b1 IN (SELECT currency_cd
                   FROM giac_order_of_payts
                  WHERE gacc_tran_id = p_giop_gacc_tran_id)
      LOOP
         v_or_curr_cd := b1.currency_cd;
         EXIT;
      END LOOP;

      IF v_or_curr_cd = v_def_curr_cd
      THEN
         v_convert_rate := 1;
         v_currency_cd := v_def_curr_cd;
      --added by john 2.9.2015
      ELSIF v_or_curr_cd is not null
      THEN
        SELECT main_currency_cd, currency_rt
          INTO v_currency_cd, v_convert_rate
          FROM giis_currency
         WHERE main_currency_cd = v_or_curr_cd;
      ELSE
         v_convert_rate := p_convert_rate;
         v_currency_cd := p_currency_cd;
      END IF;

      --insert the zero amts for the three types of premium
      IF p_zero_prem_op_text = 'Y'
      THEN
           --added by john dolon 2.12.2015
          SELECT NVL(MAX(item_seq_no),0)
            INTO v_rec
            FROM giac_op_text
           WHERE gacc_tran_id = p_giop_gacc_tran_id
             AND item_gen_type = p_gen_type;
             
         FOR rec IN 1 .. 3
         LOOP
            IF rec = 1
            THEN
               v_init_prem_text := 'PREMIUM (VATABLE)';
            ELSIF rec = 2
            THEN
               v_init_prem_text := 'PREMIUM (ZERO-RATED)';
            ELSE
               v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
            END IF;
            
            v_rec := v_rec + 1;

            giac_op_text_pkg.check_op_text_insert_prem_y (v_rec,
                                                          0,
                                                          v_init_prem_text,
                                                          v_currency_cd,
                                                          v_convert_rate,
                                                          p_giop_gacc_tran_id,
                                                          p_module_name,
                                                          p_gen_type
                                                         );
            p_zero_prem_op_text := 'N';
         END LOOP;
      END IF;
      -- parehas lang ata ang check_op_text_insert_prem_y at giac_op_text_pkg.check_op_text_insert_prem_y :)
     -- IF p_prem_vatable + p_prem_vat_exempt = 0 THEN --robert
         IF NVL(p_prem_vatable,0) + NVL(p_prem_vat_exempt,0) = 0 THEN
          IF n_seq_no = 2 THEN
                IF NVL(p_prem_zero_rated,0) = 0 THEN --robert
                    --GIAC_OP_TEXT_PKG.check_op_text_insert_prem_y(n_seq_no,v_premium_amt,v_prem_text,v_currency_cd,v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
                    check_op_text_insert_prem_y(n_seq_no,v_premium_amt,v_prem_text,v_currency_cd,v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
                ELSE
                    check_op_text_insert_prem_y(n_seq_no, p_prem_zero_rated, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
                END IF;
          ELSE
                check_op_text_insert_prem_y(n_seq_no,v_premium_amt,v_prem_text,v_currency_cd,v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
          END IF;
      ELSE 
          check_op_text_insert_prem_y(n_seq_no, p_prem_vatable, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
      END IF;
      
      --check_op_text_insert_prem_y (n_seq_no, v_premium_amt, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
/*      giac_op_text_pkg.check_op_text_insert_prem_y (n_seq_no,
                                                    v_premium_amt,
                                                    v_prem_text,
                                                    v_currency_cd,
                                                    v_convert_rate,
                                                    p_giop_gacc_tran_id,
                                                    p_module_name,
                                                    p_gen_type
                                                   );*/

      --insert the vat-exempt premium
      IF NVL (v_exempt_prem_amt, 0) <> 0
      THEN
         v_prem_text := 'PREMIUM (VAT-EXEMPT)';
         n_seq_no := 3;
        /* giac_op_text_pkg.check_op_text_insert_prem_y (n_seq_no,
                                                       v_exempt_prem_amt,
                                                       v_prem_text,
                                                       v_currency_cd,
                                                       v_convert_rate,
                                                       p_giop_gacc_tran_id,
                                                       p_module_name,
                                                       p_gen_type
                                                      );*/
          IF NVL(p_prem_vatable,0) + 
               NVL(p_prem_vat_exempt,0) = 0  /*+ :gdpc.prem_zero_rated = 0*/ THEN
          
               check_op_text_insert_prem_y(n_seq_no,v_exempt_prem_amt,v_prem_text,v_currency_cd,v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
          
          ELSE
                 check_op_text_insert_prem_y(n_seq_no, p_prem_vat_exempt, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
          
          END IF;
      
          v_been_inserted := TRUE;
                                                
      END IF;
      
      IF NVL(p_prem_vatable,0) + 
             NVL(p_prem_vat_exempt,0) != 0 --+ :gdpc.prem_zero_rated != 0
            AND v_been_inserted = FALSE THEN
            v_prem_text := 'PREMIUM (VAT-EXEMPT)'; 
            n_seq_no := 3;
            
            --check_op_text_insert_prem_y(n_seq_no, p_prem_vat_exempt, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
--            BEGIN
--               SELECT 'Y'
--                 INTO v_spcl_bill
--                 FROM gipi_inst_bakup_sr
--                WHERE iss_cd = p_iss_cd
--                  AND prem_seq_no = p_prem_seq_no;
--            EXCEPTION WHEN no_data_found THEN
--                       NULL;
--            END; --test mikel
               
--            IF v_spcl_bill = 'N' then --test mikel
               --check_op_text_insert_prem_y(n_seq_no, p_prem_vat_exempt, v_prem_text, v_currency_cd, v_convert_rate);
               check_op_text_insert_prem_y(n_seq_no, p_prem_vat_exempt, v_prem_text, v_currency_cd, v_convert_rate, p_giop_gacc_tran_id, p_module_name, p_gen_type);
--            END IF;
      END IF;    

      --FORMS_DDL('COMMIT');
      BEGIN

         FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt,
                            a.currency_cd, a.convert_rate
                       FROM giac_direct_prem_collns a,
                            giac_tax_collns b,
                            giac_taxes c
                      WHERE b.gacc_tran_id = p_giop_gacc_tran_id
                        AND a.gacc_tran_id = b.gacc_tran_id
                        AND a.b140_iss_cd = b.b160_iss_cd
                        AND a.b140_prem_seq_no = b.b160_prem_seq_no
                        AND a.inst_no = b.inst_no
                        AND c.fund_cd = p_giop_gacc_fund_cd
                        AND b.b160_iss_cd = p_iss_cd
                        AND b.b160_prem_seq_no = p_prem_seq_no
                        AND b.inst_no = p_inst_no
                        AND b.b160_tax_cd = c.tax_cd)
         LOOP
            v_count := v_count + 1;
            v_tax_cd := tax.b160_tax_cd;
            v_tax_name := tax.tax_name;
            v_sub_tax_amt := tax.tax_amt;

            --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
            --should also be in the default  currency regardless of what currency_cd is in the invoice
            IF v_or_curr_cd = v_def_curr_cd
            THEN
               v_convert_rate := 1;
               v_currency_cd := v_def_curr_cd;
            ELSIF v_or_curr_cd IS NULL THEN --updated by john 3.13.2015
               v_convert_rate := tax.convert_rate;
               v_currency_cd := tax.currency_cd;
            END IF;

            IF v_tax_cd != giacp.n ('EVAT')
            THEN
               v_no := v_no + 1;
            END IF;

            IF v_check_name = v_tax_name
            THEN
               EXIT;
            END IF;

            IF v_count = 1
            THEN
               v_check_name := v_tax_name;
            END IF;

           /*DBMS_OUTPUT.put_line (   'other taxes: taxCD: '
                                  || v_tax_cd
                                  || ' taxName: '
                                  || v_tax_name
                                  || ' v_sub_tax_amt: '
                                  || v_sub_tax_amt
                                  || ' v_currency_cd: '
                                  || v_currency_cd
                                  || ' v_convert_rate: '
                                  || v_convert_rate
                                  || ' p_seq_no: '
                                  || p_seq_no
                                 );*/
                                 
            --giac_op_text_pkg.check_op_text_2_y (v_tax_cd,                     
            check_op_text_2_y (v_tax_cd,
                                v_tax_name,
                                v_sub_tax_amt,
                                v_currency_cd,
                                v_convert_rate,
                                p_giop_gacc_tran_id,
                                p_gen_type,
                                p_seq_no
                               );
         END LOOP;
      END;
   END check_op_text_insert_y;

/*
  **  Created by   :  Anthony Santos
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS007 )
  **  Description  : update_giac_dv_text
  */
   PROCEDURE update_giac_dv_text (
      p_giop_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name         giac_modules.module_name%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT DISTINCT a.gacc_tran_id, a.collection_amt item_amt,
                            a.b140_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                                                     bill_no,
                         a.user_id, a.last_update, c.line_cd,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '09999999'))
                         || DECODE (NVL (c.endt_seq_no, 0),
                                    0, '',
                                       '-'
                                    || c.endt_iss_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (c.endt_yy, '09'))
                                    || '-'
                                    || LTRIM (TO_CHAR (c.endt_seq_no,
                                                       '099999')
                                             )
                                   ) item_text
                    FROM giac_direct_prem_collns a,
                         gipi_invoice b,
                         gipi_polbasic c
                   WHERE a.b140_iss_cd = b.iss_cd
                     AND a.b140_prem_seq_no = b.prem_seq_no
                     AND b.policy_id = c.policy_id
                     AND gacc_tran_id = p_giop_gacc_tran_id;

      v_seq_no      giac_dv_text.item_seq_no%TYPE       := 1;
      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (20005, 'No data found in GIAC MODULES.');
      END;

      /* Remove first whatever records in giac_op_text. */
      DELETE FROM giac_dv_text
            WHERE gacc_tran_id = p_giop_gacc_tran_id
              AND item_gen_type = v_gen_type;

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_dv_text
                     (gacc_tran_id, item_gen_type, item_seq_no,
                      item_amt, user_id,
                      last_update, line, bill_no,
                      item_text
                     )
              VALUES (c_rec.gacc_tran_id, v_gen_type, v_seq_no,
                      (c_rec.item_amt * -1
                      ), c_rec.user_id,
                      c_rec.last_update, c_rec.line_cd, c_rec.bill_no,
                      c_rec.item_text
                     );

         v_seq_no := v_seq_no + 1;
      END LOOP;
   END update_giac_dv_text;

/*
  **  Created by   :  Anthony Santos
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS007 )
  **  Description  : check_op_text_insert_prem_y
  */
   PROCEDURE check_op_text_insert_prem_y (
      p_seq_no              NUMBER,
      p_premium_amt         gipi_invoice.prem_amt%TYPE,
      p_prem_text           VARCHAR2,
      p_currency_cd         giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        giac_direct_prem_collns.convert_rate%TYPE,
      p_giop_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name         giac_modules.module_name%TYPE,
      p_gen_type            giac_modules.generation_type%TYPE
   )
   IS
      v_exist         NUMBER;
      v_item_amt      NUMBER;
      v_foreign_amt   NUMBER;
   BEGIN
      SELECT item_amt
        INTO v_exist
        FROM giac_op_text
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND item_gen_type = p_gen_type
         AND item_text = p_prem_text
         AND currency_cd = p_currency_cd; --john 2.12.2015
         
         DBMS_OUTPUT.PUT_LINE('v_exist amount: ' || v_exist);

      SELECT NVL (item_amt, 0) + NVL (p_premium_amt, 0) item_amt,
               NVL (foreign_curr_amt, 0)
             + NVL (p_premium_amt / p_convert_rate, 0) forr_amt
        INTO v_item_amt,
             v_foreign_amt
        FROM giac_op_text
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND item_gen_type = p_gen_type
         AND item_text = p_prem_text
         AND currency_cd = p_currency_cd; --john 2.12.2015

      UPDATE giac_op_text
         SET item_amt = NVL (item_amt, 0) + NVL (p_premium_amt, 0),
             foreign_curr_amt =
                  NVL (foreign_curr_amt, 0)
                + NVL (p_premium_amt / p_convert_rate, 0)
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND item_text = p_prem_text
         AND item_gen_type = p_gen_type
         AND currency_cd = p_currency_cd; --john 2.12.2015
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_gen_type, item_seq_no,
                      item_amt, item_text, print_seq_no, currency_cd,
                      user_id, last_update,
                      foreign_curr_amt
                     )
              VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no,
                      p_premium_amt, p_prem_text, p_seq_no, p_currency_cd,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE,
                      p_premium_amt / p_convert_rate
                     );
   END check_op_text_insert_prem_y;

    /*
   **  Created by   :  Anthony Santos
   **  Date Created :  10.12.2010
   **  Reference By : (GIACS007 )
   **  Description  : check_op_text_2_y
   */
   PROCEDURE check_op_text_2_y (
      v_b160_tax_cd                  NUMBER,
      v_tax_name                     VARCHAR2,
      v_tax_amt                      NUMBER,
      v_currency_cd                  NUMBER,
      v_convert_rate                 NUMBER,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_gen_type                     giac_modules.generation_type%TYPE,
      p_seq_no              IN OUT   NUMBER
   )
   IS
      v_exist   VARCHAR2 (1);
      v_count number:=0;
   BEGIN
   
           DBMS_OUTPUT.PUT_LINE('p_giop_gacc_tran_id: ' || p_giop_gacc_tran_id || ' v_b160_tax_cd: ' || v_b160_tax_cd || ' v_currency_cd: ' || v_currency_cd);
        
        --BEGIN
        
              select count(*) into v_count from giac_op_text where gacc_tran_id = p_giop_gacc_tran_id;
              DBMS_OUTPUT.PUT_LINE('v_count: ' || v_count);
        
            UPDATE giac_op_text
                SET item_amt = NVL (item_amt, 0) + NVL (v_tax_amt, 0),
                    foreign_curr_amt =
                         NVL (foreign_curr_amt, 0)
                       + NVL (v_tax_amt / v_convert_rate, 0)
              WHERE gacc_tran_id = p_giop_gacc_tran_id
                --AND item_gen_type = p_gen_type
                --AND item_text = v_tax_name;
                AND SUBSTR (item_text, 1, 5) =
                          LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (v_currency_cd, '09'));
             
             IF SQL%NOTFOUND THEN
                  DBMS_OUTPUT.PUT_LINE('NOT MATCHED');
                --p_seq_no := v_count + 1;
                DBMS_OUTPUT.PUT_LINE('NOT MATCHED2' || ' p_giop_gacc_tran_id: ' || p_giop_gacc_tran_id || ' p_gen_type: ' || p_gen_type || ' p_seq_no: ' || p_seq_no || ' v_tax_amt: ' || v_tax_amt || ' taxName: ' || LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (v_currency_cd, '09'))
                            || '-'
                            || v_tax_name || ' forAmmt: ' ||  v_tax_amt / v_convert_rate);
                INSERT INTO giac_op_text 
                           (gacc_tran_id, item_gen_type, item_seq_no,
                            item_amt,
                            item_text,
                            print_seq_no, currency_cd,
                            user_id, last_update,
                            foreign_curr_amt
                           )
                    VALUES (p_giop_gacc_tran_id, p_gen_type, v_count + 1,
                            v_tax_amt,
                            --v_tax_name,
                            
                              LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (v_currency_cd, '09'))
                            || '-'
                            || v_tax_name,
                            v_count + 1, v_currency_cd,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE,
                            v_tax_amt / v_convert_rate
                           );
                    DBMS_OUTPUT.PUT_LINE('INSERTED');       
             END IF;    
             
             FOR i IN (SELECT item_text, item_seq_no, currency_cd  from giac_op_text where gacc_tran_id = p_giop_gacc_tran_id)loop
                  DBMS_OUTPUT.PUT_LINE('item_text: ' || i.item_text || ' item_seq_no: ' || i.item_seq_no || ' currency_cd: ' || i.currency_cd);
                 
             end loop;
        -- END;       
                                                   
      /*  
      BEGIN
         SELECT 'X'
           INTO v_exist
           FROM giac_op_text
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND item_gen_type = p_gen_type
            AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (v_currency_cd, '09'));
          DBMS_OUTPUT.PUT_LINE('V EXIST: ' || v_exist || ' taxCD: ' || LTRIM (TO_CHAR (v_b160_tax_cd, '09')) || ' v_currency_cd: ' || LTRIM (TO_CHAR (v_currency_cd, '09')));           

         UPDATE giac_op_text
            SET item_amt = NVL (item_amt, 0) + NVL (v_tax_amt, 0),
                foreign_curr_amt =
                     NVL (foreign_curr_amt, 0)
                   + NVL (v_tax_amt / v_convert_rate, 0)
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND item_gen_type = p_gen_type
            AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (v_currency_cd, '09'));
                   DBMS_OUTPUT.PUT_LINE('Record updated');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               p_seq_no := p_seq_no + 1;

               INSERT INTO giac_op_text
                           (gacc_tran_id, item_gen_type, item_seq_no,
                            item_amt,
                            item_text,
                            print_seq_no, currency_cd,
                            user_id, last_update,
                            foreign_curr_amt
                           )
                    VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no,
                            v_tax_amt,
                               LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (v_currency_cd, '09'))
                            || '-'
                            || v_tax_name,
                            p_seq_no, v_currency_cd,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE,
                            v_tax_amt / v_convert_rate
                           );
                           DBMS_OUTPUT.PUT_LINE('inserted desc: ' || LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (v_currency_cd, '09'))
                            || '-'
                            || v_tax_name);
            END;
      END;*/
   END check_op_text_2_y;

/*
  **  Created by   :  Anthony Santos
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS007 )
  **  Description  : update_giac_op_text_n
  */
   PROCEDURE update_giac_op_text_n (
      p_giop_gacc_tran_id        giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_iss_cd              IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no         IN   giac_comm_payts.prem_seq_no%TYPE,
      p_inst_no                  giac_comm_payts.inst_no%TYPE,
      p_tran_type                giac_comm_payts.tran_type%TYPE,
      p_prem_amt                 giac_direct_prem_collns.premium_amt%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_giop_gacc_fund_cd        giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT                                                    --DISTINCT
                  a.b140_iss_cd, a.b140_prem_seq_no,
                  SUM (a.collection_amt) collection_amt,
                  SUM (a.premium_amt) premium_amt, b.currency_cd,
                  b.currency_rt, SUM (a.tax_amt) tax_amt
             FROM giac_direct_prem_collns a, gipi_invoice b, gipi_polbasic c
            WHERE a.b140_iss_cd = b.iss_cd
              AND a.b140_prem_seq_no = b.prem_seq_no
              --AND B.iss_cd           = C.iss_cd
              AND b.policy_id = c.policy_id
              AND gacc_tran_id = p_giop_gacc_tran_id
              AND a.b140_iss_cd = p_iss_cd
              AND a.b140_prem_seq_no = p_prem_seq_no
              AND a.inst_no = p_inst_no
         GROUP BY a.b140_iss_cd,
                  a.b140_prem_seq_no,
                  b.currency_cd,
                  b.currency_rt;

      p_seq_no         giac_op_text.item_seq_no%TYPE               := 0;
      vl_lt            NUMBER;
      v_counter        NUMBER                                      := 1;
      v_coll_amt       NUMBER (14, 2)                              := 0;
      v_prem_amt       NUMBER (14, 2)                              := 0;
      v_tax_amt        NUMBER (14, 2)                              := 0;
      v_tax_cd         giac_tax_collns.b160_tax_cd%TYPE;
      v_exist          VARCHAR2 (1);
      v_cursor_exist   BOOLEAN;
      v_gen_type       giac_modules.generation_type%TYPE;
      v_currency_rt    giac_direct_prem_collns.convert_rate%TYPE;
      v_currency_cd    giac_direct_prem_collns.currency_cd%TYPE;
   BEGIN
      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                               (20005,
                                'This module does not exist in giac_modules.'
                               );
      END;

      BEGIN
         SELECT currency_rt, main_currency_cd
           INTO v_currency_rt, v_currency_cd
           FROM giis_currency
          WHERE main_currency_cd = (SELECT currency_cd
                                      FROM giac_order_of_payts
                                     WHERE gacc_tran_id = p_giop_gacc_tran_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /*Remove first whatever records in giac_op_text.**/
      DELETE      giac_op_text
            WHERE gacc_tran_id = p_giop_gacc_tran_id
              AND item_gen_type = v_gen_type;

      IF p_tran_type IS NULL
      THEN
         NULL;
      ELSE
         v_cursor_exist := FALSE;

         FOR c_rec IN c
         LOOP
            -- creation of op_text record is per transaction basis
            giac_op_text_pkg.check_op_text_insert_n (c_rec.premium_amt,
                                                     c_rec.b140_iss_cd,
                                                     c_rec.b140_prem_seq_no,
                                                     p_inst_no,
                                                     p_giop_gacc_fund_cd,
                                                     p_giop_gacc_tran_id,
                                                     c_rec.currency_cd,
                                                     c_rec.currency_rt,
                                                     v_gen_type
                                                    );
            v_cursor_exist := TRUE;
         END LOOP;

         IF NOT v_cursor_exist
         THEN
            giac_op_text_pkg.check_op_text_insert_n (p_prem_amt,
                                                     p_iss_cd,
                                                     p_prem_seq_no,
                                                     p_inst_no,
                                                     p_giop_gacc_fund_cd,
                                                     p_giop_gacc_tran_id,
                                                     v_currency_cd,
                                                     v_currency_rt,
                                                     v_gen_type
                                                    );
         END IF;

         /*
         ** delete from giac_op_text
         ** where item_amt = 0
         */
         DELETE      giac_op_text
               WHERE gacc_tran_id = p_giop_gacc_tran_id
                 AND NVL (item_amt, 0) = 0
                 AND item_gen_type = v_gen_type;

         /*
         ** update giac_op_text
         ** where item_text = Taxes
         */
         UPDATE giac_op_text
            SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd
                                                            FROM giac_taxes
                                                           WHERE tax_cd <> 1)
            AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
            AND item_gen_type = v_gen_type;
      END IF;
   END update_giac_op_text_n;

/*
  **  Created by   :  Anthony Santos
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS007 )
  **  Description  : check_op_text_insert_n
  */
   PROCEDURE check_op_text_insert_n (
      p_premium_amt         IN       NUMBER,
      p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                      giac_comm_payts.inst_no%TYPE,
      p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE
   )
   IS
      v_exist          VARCHAR2 (1);
      n_seq_no         NUMBER (2)                                  := 0;
      v_tax_name       VARCHAR2 (100);
      v_tax_cd         NUMBER (2);
      v_sub_tax_amt    NUMBER (14, 2);
      v_count          NUMBER                                      := 0;
      v_check_name     VARCHAR2 (100)                              := 'GRACE';
      v_no             NUMBER                                      := 0;
      v_currency_cd    giac_direct_prem_collns.currency_cd%TYPE;
      v_convert_rate   giac_direct_prem_collns.convert_rate%TYPE;
      v_column_no      giac_taxes.column_no%TYPE;
      v_seq            NUMBER;
      v_seq_no         NUMBER;
   BEGIN
      BEGIN
         SELECT 'X'
           INTO v_exist
           FROM giac_op_text
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND item_gen_type = p_gen_type
            AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
            AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);

         UPDATE giac_op_text
            SET item_amt = NVL (p_premium_amt, 0) + NVL (item_amt, 0),
                foreign_curr_amt =
                     NVL (p_premium_amt / p_convert_rate, 0)
                   + NVL (foreign_curr_amt, 0),
                column_no = 1
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
            AND item_gen_type = p_gen_type
            AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_seq_no := v_seq_no + 1;
            v_seq := v_seq_no;

            BEGIN
               INSERT INTO giac_op_text
                           (gacc_tran_id, item_gen_type, item_seq_no,
                            item_amt, item_text,
                            bill_no,
                            print_seq_no, currency_cd,
                            user_id, last_update,
                            foreign_curr_amt, column_no
                           )
                    VALUES (p_giop_gacc_tran_id, p_gen_type, v_seq,
                            p_premium_amt, 'PREMIUM',
                            p_iss_cd || '-' || TO_CHAR (p_prem_seq_no),
                            v_seq, p_currency_cd,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE,
                            p_premium_amt / p_convert_rate, 1
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            --p_msg_alert := SQLERRM;
            END;
      END;

      BEGIN
         FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt,
                            a.currency_cd, a.convert_rate, c.column_no
                       FROM giac_direct_prem_collns a,
                            giac_tax_collns b,
                            giac_taxes c
                      WHERE 1 = 1
                        AND a.b140_iss_cd = b.b160_iss_cd
                        AND a.b140_prem_seq_no = b.b160_prem_seq_no
                        AND a.gacc_tran_id = b.gacc_tran_id
                        AND a.inst_no = b.inst_no
                        AND b.b160_tax_cd = c.tax_cd
                        AND b.fund_cd = c.fund_cd
                        AND c.fund_cd = p_giop_gacc_fund_cd
                        AND b.gacc_tran_id = p_giop_gacc_tran_id
                        AND b.b160_iss_cd = p_iss_cd
                        AND b.b160_prem_seq_no = p_prem_seq_no
                        AND b.inst_no = p_inst_no)
         LOOP
            v_count := v_count + 1;
            v_tax_cd := tax.b160_tax_cd;
            v_tax_name := tax.tax_name;
            v_sub_tax_amt := tax.tax_amt;
            v_convert_rate := tax.convert_rate;
            v_currency_cd := tax.currency_cd;
            v_column_no := tax.column_no;

            IF v_tax_name != 'EVAT'
            THEN
               v_no := v_no + 1;
            END IF;

            IF v_check_name = v_tax_name
            THEN
               EXIT;
            END IF;

            IF v_count = 1
            THEN
               v_check_name := v_tax_name;
            END IF;
            
            IF NVL(giacp.v('SEPARATE_PREMIUM_AND_VAT'),'N') = 'N' THEN 
               giac_op_text_pkg.check_op_text_2_n (v_tax_cd,
                                                v_tax_name,
                                                v_sub_tax_amt,
                                                v_currency_cd,
                                                v_convert_rate,
                                                p_iss_cd,
                                                p_prem_seq_no,
                                                v_column_no,
                                                v_no,
                                                v_seq,
                                                p_giop_gacc_tran_id,
                                                p_gen_type);
            ELSIF NVL(giacp.v('SEPARATE_PREMIUM_AND_VAT'),'N') = 'Y' THEN  
                giac_op_text_pkg.check_op_text_2b_n(v_tax_cd, v_tax_name,    v_sub_tax_amt, v_currency_cd,
                                              v_convert_rate, p_iss_cd, p_prem_seq_no, v_column_no,   v_no, v_seq,
                                              p_giop_gacc_tran_id,
                                                p_gen_type);
            END IF;                                   

            
         END LOOP;
      END;
   END check_op_text_insert_n;

/*
  **  Created by   :  Anthony Santos
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS007 )
  **  Description  : check_op_text_2_n
  */
   PROCEDURE check_op_text_2_n (
      p_b160_tax_cd                  NUMBER,
      p_tax_name                     VARCHAR2,
      p_tax_amt                      NUMBER,
      p_currency_cd                  NUMBER,
      p_convert_rate                 NUMBER,
      p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_column_no           IN       giac_taxes.column_no%TYPE,
      p_seq_no              OUT      NUMBER,
      p_sq                  IN       NUMBER,
      p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_gen_type            IN OUT   giac_modules.generation_type%TYPE
   )
   IS
      v_exist     VARCHAR2 (1);
      v_seq_no1   NUMBER;
   BEGIN
      BEGIN
         SELECT 'X'
           INTO v_exist
           FROM giac_op_text
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (p_currency_cd, '09'))
            AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);

         IF p_b160_tax_cd <> 1
         THEN
            UPDATE giac_op_text
               SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                   foreign_curr_amt =
                        NVL (foreign_curr_amt, 0)
                      + NVL (p_tax_amt / p_convert_rate, 0)
             WHERE gacc_tran_id = p_giop_gacc_tran_id
               AND item_gen_type = p_gen_type
               AND SUBSTR (item_text, 1, 5) =
                         LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (p_currency_cd, '09'))
               AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
         ELSE
            UPDATE giac_op_text
               SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                   foreign_curr_amt =
                        NVL (foreign_curr_amt, 0)
                      + NVL (p_tax_amt / p_convert_rate, 0)
             WHERE gacc_tran_id = p_giop_gacc_tran_id
               AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
               AND item_gen_type = p_gen_type
               AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               IF (p_b160_tax_cd = 1)
               THEN
                  UPDATE giac_op_text
                     SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                         foreign_curr_amt =
                              NVL (foreign_curr_amt, 0)
                            + NVL (p_tax_amt / p_convert_rate, 0)
                   WHERE gacc_tran_id = p_giop_gacc_tran_id
                     AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
                     AND item_gen_type = p_gen_type
                     AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
               ELSE
                  p_seq_no := p_sq + p_seq_no;

                  INSERT INTO giac_op_text
                              (gacc_tran_id, item_gen_type, item_seq_no,
                               item_amt,
                               item_text,
                               bill_no,
                               print_seq_no, currency_cd,
                               user_id, last_update,
                               foreign_curr_amt, column_no
                              )
                       VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no,
                               p_tax_amt,
                                  LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (p_currency_cd, '09'))
                               || '-'
                               || p_tax_name,
                               p_iss_cd || '-' || TO_CHAR (p_prem_seq_no),
                               p_seq_no, p_currency_cd,
                               NVL (giis_users_pkg.app_user, USER), SYSDATE,
                               p_tax_amt / p_convert_rate, p_column_no
                              );
               END IF;
            END;
      END;
   END check_op_text_2_n;

   /*
    **  Created by   :  Emman
    **  Date Created :  10.19.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT on GIACS040
    */
   PROCEDURE update_giac_op_text_giacs040 (
      p_gacc_tran_id   giac_ovride_comm_payts.gacc_tran_id%TYPE
   )
   IS
   BEGIN
      DECLARE
         CURSOR c
         IS
            SELECT DISTINCT a.gacc_tran_id, a.user_id, a.last_update,
                            c.line_cd,
                            ((a.comm_amt - a.wtax_amt) * (-1)) drv_comm_amt,
                               a.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (a.prem_seq_no, '09999999'))
                                                                     bill_no,
                               c.line_cd
                            || '-'
                            || c.subline_cd
                            || '-'
                            || c.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (c.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (c.pol_seq_no, '09999999'))
                            || DECODE (NVL (c.endt_seq_no, 0),
                                       0, '',
                                          '-'
                                       || c.endt_iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (c.endt_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (c.endt_seq_no,
                                                          '099999'
                                                         )
                                                )
                                      ) item_text,
                            a.currency_cd, a.foreign_curr_amt
                       FROM giac_ovride_comm_payts a,
                            gipi_invoice b,
                            gipi_polbasic c
                      WHERE a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
                        AND b.iss_cd = c.iss_cd
                        AND b.policy_id = c.policy_id
                        AND gacc_tran_id = p_gacc_tran_id;

         ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
         ws_gen_type   VARCHAR2 (1)                    := 'N';
      BEGIN
         DELETE FROM giac_op_text
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND item_gen_type = ws_gen_type;

         FOR c_rec IN c
         LOOP
            INSERT INTO giac_op_text
                        (gacc_tran_id, item_seq_no, item_gen_type,
                         item_text, item_amt, user_id,
                         last_update, line, bill_no,
                         print_seq_no, currency_cd, foreign_curr_amt
                        )
                 VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type,
                         c_rec.item_text, c_rec.drv_comm_amt, c_rec.user_id,
                         c_rec.last_update, c_rec.line_cd, c_rec.bill_no,
                         ws_seq_no, c_rec.currency_cd, c_rec.foreign_curr_amt
                        );

            ws_seq_no := ws_seq_no + 1;
         END LOOP;
      END;
   END update_giac_op_text_giacs040;

   /*
    **  Created by   :  Emman
    **  Date Created :  10.29.2010
    **  Reference By : (GIACS018 - Facul Claim Payts)
    **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT on GIACS018
    */
   PROCEDURE update_giac_op_text_giacs018 (
      p_gacc_tran_id      giac_inw_claim_payts.gacc_tran_id%TYPE,
      p_var_module_name   giac_modules.module_name%TYPE
   )
   IS
      ws_seq_no     NUMBER (2);
      ws_gen_type   VARCHAR2 (1);

      CURSOR c
      IS
         SELECT a.gacc_tran_id, a.user_id, a.last_update, b.line_cd,
                (a.disbursement_amt * -1) item_amt,
                   'CLAIM NUMBER : '
                || b.line_cd
                || '-'
                || b.subline_cd
                || '-'
                || b.iss_cd
                || '-'
                || TO_CHAR (b.clm_yy, '99')
                || '-'
                || TO_CHAR (b.clm_seq_no, '099999')
                || ' / POLICY NUMBER : '
                || c.line_cd
                || '-'
                || c.subline_cd
                || '-'
                || c.iss_cd
                || '-'
                || TO_CHAR (c.issue_yy, '99')
                || '-'
                || TO_CHAR (c.pol_seq_no, '0999999')
                || '-'
                || TO_CHAR (c.renew_no, '09')
                || ' / LOSS DATE : '
                || TO_CHAR (b.loss_date, 'MON DD, YYYY')
                || ' -- '
                || d.exp_desc text,
                a.currency_cd, a.foreign_curr_amt
           FROM giac_inw_claim_payts a,
                gicl_claims b,
                gipi_polbasic c,
                giis_expense d
          WHERE a.gacc_tran_id = p_gacc_tran_id AND a.claim_id = b.claim_id;
   BEGIN
      ws_seq_no := 0;

      SELECT generation_type
        INTO ws_gen_type
        FROM giac_modules
       WHERE module_id = (SELECT module_id
                            FROM giac_modules
                           WHERE module_name = p_var_module_name);

      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
                  AND item_gen_type = ws_gen_type;

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, item_gen_type,
                      item_text, item_amt, user_id,
                      last_update, line, print_seq_no,
                      currency_cd, foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type,
                      c_rec.text, c_rec.item_amt, c_rec.user_id,
                      c_rec.last_update, c_rec.line_cd, ws_seq_no,
                      c_rec.currency_cd, c_rec.foreign_curr_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END update_giac_op_text_giacs018;

   /*
    **  Created by   :  Jerome Orio
    **  Date Created :  11.30.2010
    **  Reference By : (GIACS025 - OR Preview)
    **  Description  : get giac_op_text reocrds
    */
   FUNCTION get_giac_op_text (p_gacc_tran_id giac_op_text.gacc_tran_id%TYPE)
      RETURN giac_op_text_tab PIPELINED
   IS
      v_list   giac_op_text_type;
   BEGIN
      FOR i IN (SELECT   a.gacc_tran_id, a.item_seq_no, a.print_seq_no,
                         a.item_amt, a.item_gen_type, a.item_text,
                         a.currency_cd, a.line, a.bill_no, a.or_print_tag,
                         a.foreign_curr_amt, a.user_id, a.last_update,
                         a.cpi_rec_no, a.cpi_branch_cd, a.column_no,
                         b.short_name
                    FROM giac_op_text a, giis_currency b
                   WHERE a.gacc_tran_id = p_gacc_tran_id
                     AND b.main_currency_cd(+) = a.currency_cd
                ORDER BY a.print_seq_no, a.item_seq_no, a.item_gen_type)
      LOOP
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.item_seq_no := i.item_seq_no;
         v_list.print_seq_no := i.print_seq_no;
         v_list.item_amt := i.item_amt;
         v_list.item_gen_type := i.item_gen_type;
         v_list.item_text := i.item_text;
         v_list.currency_cd := i.currency_cd;
         v_list.line := i.line;
         v_list.bill_no := i.bill_no;
         v_list.or_print_tag := i.or_print_tag;
         v_list.foreign_curr_amt := i.foreign_curr_amt;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.column_no := i.column_no;
         v_list.dsp_curr_sname := i.short_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  12.06.2010
   **  Reference By : (GIACS022 - Other Trans Withholding Tax)
   **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT on GIACS022
   */
   PROCEDURE update_giac_op_text_giacs022 (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT   a.gacc_tran_id, a.user_id, a.last_update, a.item_no,
                  a.wholding_tax_amt item_amt,
                  NVL (a.remarks,
                       (   LTRIM (TO_CHAR (b.whtax_code, '09'))
                        || '-'
                        || RTRIM (b.whtax_desc)
                        || ' / '
                        || LTRIM (TO_CHAR (c.payee_no, '099999'))
                        || '-'
                        || RTRIM (c.payee_last_name)
                        || ', '
                        || RTRIM (c.payee_first_name)
                        || ' '
                        || RTRIM (c.payee_middle_name)
                       )
                      ) item_text
             FROM giac_taxes_wheld a, giac_wholding_taxes b, giis_payees c
            WHERE a.gwtx_whtax_id = b.whtax_id
              AND a.payee_cd = c.payee_no
              AND a.payee_class_cd = c.payee_class_cd
              AND gacc_tran_id = p_gacc_tran_id
              AND gen_type = (SELECT generation_type --added by john 2.25.2015
                                 FROM giac_modules
                                WHERE module_name = 'GIACS022')
         ORDER BY a.item_no;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1)                    := 'P';
   BEGIN
      DECLARE
         v_test   giac_parameters.param_value_n%TYPE;
      BEGIN
            --added by john 2.25.2015
            SELECT generation_type
              INTO ws_gen_type
              FROM giac_modules
             WHERE module_name = 'GIACS022';
             
         DELETE FROM giac_op_text
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND item_gen_type = ws_gen_type;

         SELECT param_value_n
           INTO v_test
           FROM giac_parameters
          WHERE param_name = 'CURRENCY_CD';

         FOR c_rec IN c
         LOOP
            INSERT INTO giac_op_text
                        (gacc_tran_id, item_seq_no, item_gen_type,
                         item_text, item_amt, user_id,
                         last_update, print_seq_no, currency_cd,
                         foreign_curr_amt
                        )
                 VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type,
                         c_rec.item_text, c_rec.item_amt, c_rec.user_id,
                         c_rec.last_update, ws_seq_no, v_test,
                         c_rec.item_amt
                        );

            ws_seq_no := ws_seq_no + 1;
         END LOOP;
      END;
   END update_giac_op_text_giacs022;

     /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.14.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : when-new-forms-ins trigger
   */
   FUNCTION when_new_forms_ins_giacs025 (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN when_new_forms_giacs025_tab PIPELINED
   IS
      v_new   when_new_forms_giacs025_type;
   BEGIN
      FOR o IN (SELECT 'X' printed
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_gacc_tran_id
                   --AND or_no is not null
                   AND (or_flag IN ('P', 'C','R') OR (or_cancel_tag = 'Y'))) --'R' Added by Jerome Bautista 11.20.2015 SR 20817
      LOOP
         v_new.dummy := o.printed;
      END LOOP;

      IF v_new.dummy IS NULL
      THEN
         FOR r IN (SELECT '1' unprinted
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND or_no IS NULL
                      AND or_flag = 'N')
         LOOP
            v_new.unprinted := r.unprinted;
         END LOOP;
      END IF;

      FOR a1 IN (SELECT param_value_n
                   FROM giac_parameters
                  WHERE UPPER (param_name) = 'CURRENCY_CD')
      LOOP
         v_new.def_curr_cd := a1.param_value_n;
         EXIT;
      END LOOP;

      FOR b1 IN (SELECT currency_cd
                   FROM giac_order_of_payts
                  WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_new.curr_cd := b1.currency_cd;
         EXIT;
      END LOOP;

      FOR c1 IN (SELECT short_name
                   FROM giis_currency
                  WHERE main_currency_cd = v_new.curr_cd)
      LOOP
         v_new.curr_sname := c1.short_name;
         EXIT;
      END LOOP;

      FOR d1 IN (SELECT generation_type
                   FROM giac_modules
                  WHERE module_name = 'GIACS025')
      LOOP
         v_new.item_gen_type := d1.generation_type;
         EXIT;
      END LOOP;

      FOR d1 IN (SELECT generation_type
                   FROM giac_modules
                  WHERE module_name = 'GIACS001')
      LOOP
         v_new.item_gen_type_giacs001 := d1.generation_type;
         EXIT;
      END LOOP;

      BEGIN
         SELECT DECODE (gross_tag,
                        'Y', gross_amt,
                        'N', collection_amt,
                        gross_amt
                       )
           INTO v_new.op_amount
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_new.op_amount := 0;
      END;
      
      BEGIN
        SELECT SUM(a.gross_amt / b.currency_rt) exact_currency
          INTO v_new.exact_amount
          FROM giac_collection_dtl a, giis_currency b
        WHERE a.currency_cd = b.main_currency_cd
              AND a.gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_new.exact_amount := 0;
      END;
      -- edited by d.alcantara, edited default rate to the one used in giac_collection_dtl, 08-31-2012
      /*BEGIN
        SELECT currency_rt 
          INTO v_new.curr_rt
          FROM giis_currency
        WHERE main_currency_cd = v_new.curr_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_new.curr_rt := 1;
      END;*/
      v_new.curr_rt := 1;  --default
      FOR i IN (
            SELECT currency_rt FROM giac_collection_dtl
             WHERE gacc_tran_id = p_gacc_tran_id
        ) LOOP
            v_new.curr_rt := i.currency_rt;
            EXIT;
        END LOOP;
      
      PIPE ROW (v_new);
      RETURN;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.15.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : insert records on GIAC_OP_TEXT
   */
   PROCEDURE set_giac_op_text (
      p_gacc_tran_id       giac_op_text.gacc_tran_id%TYPE,
      p_item_seq_no        giac_op_text.item_seq_no%TYPE,
      p_print_seq_no       giac_op_text.print_seq_no%TYPE,
      p_item_amt           giac_op_text.item_amt%TYPE,
      p_item_gen_type      giac_op_text.item_gen_type%TYPE,
      p_item_text          giac_op_text.item_text%TYPE,
      p_currency_cd        giac_op_text.currency_cd%TYPE,
      p_line               giac_op_text.line%TYPE,
      p_bill_no            giac_op_text.bill_no%TYPE,
      p_or_print_tag       giac_op_text.or_print_tag%TYPE,
      p_foreign_curr_amt   giac_op_text.foreign_curr_amt%TYPE,
      p_user_id            giac_op_text.user_id%TYPE,
      p_last_update        giac_op_text.last_update%TYPE,
      p_cpi_rec_no         giac_op_text.cpi_rec_no%TYPE,
      p_cpi_branch_cd      giac_op_text.cpi_branch_cd%TYPE,
      p_column_no          giac_op_text.column_no%TYPE
   )
   IS
   BEGIN
      MERGE INTO giac_op_text
         USING DUAL
         ON (    gacc_tran_id = p_gacc_tran_id
             AND item_seq_no = p_item_seq_no
             AND item_gen_type = p_item_gen_type)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
                    item_gen_type, item_text, currency_cd, line, bill_no,
                    or_print_tag, foreign_curr_amt, user_id, last_update,
                    cpi_rec_no, cpi_branch_cd, column_no)
            VALUES (p_gacc_tran_id, p_item_seq_no, p_print_seq_no, p_item_amt,
                    p_item_gen_type, p_item_text, p_currency_cd, p_line,
                    p_bill_no, p_or_print_tag, p_foreign_curr_amt, p_user_id,
                    SYSDATE, p_cpi_rec_no, p_cpi_branch_cd, p_column_no)
         WHEN MATCHED THEN
            UPDATE
               SET print_seq_no = p_print_seq_no, item_amt = p_item_amt,
                   item_text = p_item_text, currency_cd = p_currency_cd,
                   line = p_line, bill_no = p_bill_no,
                   or_print_tag = p_or_print_tag,
                   foreign_curr_amt = p_foreign_curr_amt, user_id = p_user_id,
                   last_update = SYSDATE, cpi_rec_no = p_cpi_rec_no,
                   cpi_branch_cd = p_cpi_branch_cd, column_no = p_column_no
            ;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.15.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : generate particulars on OR Preview
   */
   FUNCTION generate_particulars (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
   )
      RETURN giac_op_text_tab PIPELINED
   IS
      v_list               giac_op_text_type;
      v_exist              VARCHAR2 (1);
      v_particulars        giac_order_of_payts.particulars%TYPE;
      v_generation_type    giac_modules.generation_type%TYPE;
      v_gross_tag          giac_order_of_payts.gross_tag%TYPE;
      v_item_seq_no        giac_op_text.item_seq_no%TYPE            := 0;
      v_gross_amt          giac_collection_dtl.gross_amt%TYPE;
      v_amount             giac_collection_dtl.amount%TYPE;
      v_fc_gross_amt       giac_collection_dtl.fc_gross_amt%TYPE;
      v_fcurrency_amt      giac_collection_dtl.fcurrency_amt%TYPE;
      v_currency_cd        giac_collection_dtl.currency_cd%TYPE;
      v_foreign_curr_amt   giac_collection_dtl.fcurrency_amt%TYPE;
   BEGIN
      SELECT generation_type
        INTO v_generation_type
        FROM giac_modules
       WHERE module_name = 'GIACS001';

       /*
       **delete first items generated from giacs001
       */
      --move this on JSP -- jerome orio
      /*DELETE FROM giac_op_text
       WHERE item_gen_type = v_generation_type
         AND gacc_tran_id = :GLOBAL.CG$GIOP_GACC_TRAN_ID;*/

      /*
      **insert items
      */
      SELECT particulars, gross_tag
        INTO v_particulars, v_gross_tag
        FROM giac_order_of_payts
       WHERE gacc_tran_id = p_gacc_tran_id;

      IF v_particulars IS NULL
      THEN
         --msg_alert('No particulars found','E',FALSE);
         NULL;
      ELSE
         FOR rec IN (SELECT DISTINCT currency_cd
                                FROM giac_collection_dtl
                               WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_item_seq_no := v_item_seq_no + 1;

            SELECT SUM (gross_amt), SUM (amount), SUM (fc_gross_amt),
                   SUM (fcurrency_amt)
              INTO v_gross_amt, v_amount, v_fc_gross_amt,
                   v_fcurrency_amt
              FROM giac_collection_dtl
             WHERE currency_cd = rec.currency_cd
               AND gacc_tran_id = p_gacc_tran_id;

            IF v_gross_tag = 'Y'
            THEN
               IF rec.currency_cd = 1
               THEN
                  /*INSERT INTO giac_op_text
                               (gacc_tran_id,  item_gen_type,  item_seq_no,
                                item_text,     line,           bill_no,
                                item_amt,      user_id,        last_update,
                                or_print_tag,  print_seq_no,   currency_cd,
                                foreign_curr_amt, column_no
                               )
                        VALUES (:GLOBAL.cg$giop_gacc_tran_id, v_generation_type, v_item_seq_no,
                                v_particulars,     NULL,           NULL,
                                v_gross_amt,       USER,           SYSDATE,
                                NULL,              v_item_seq_no,  rec.currency_cd,
                                v_fc_gross_amt,    NULL
                               );*/
                  v_list.gacc_tran_id := p_gacc_tran_id;
                  v_list.item_seq_no := v_item_seq_no;
                  v_list.print_seq_no := v_item_seq_no;
                  v_list.item_amt := v_gross_amt;
                  v_list.item_gen_type := v_generation_type;
                  v_list.item_text := v_particulars;
                  v_list.currency_cd := rec.currency_cd;
                  v_list.line := NULL;
                  v_list.bill_no := NULL;
                  v_list.or_print_tag := NULL;
                  v_list.foreign_curr_amt := v_fc_gross_amt;
                  v_list.user_id := USER;
                  v_list.last_update := SYSDATE;
                  v_list.column_no := NULL;

                  FOR sname IN (SELECT short_name
                                  FROM giis_currency
                                 WHERE main_currency_cd = rec.currency_cd)
                  LOOP
                     v_list.dsp_curr_sname := sname.short_name;
                     EXIT;
                  END LOOP;

                  PIPE ROW (v_list);
               ELSE
                  /*INSERT INTO giac_op_text
                              (gacc_tran_id,      item_gen_type,  item_seq_no,
                               item_text,         line,           bill_no,
                               item_amt,          user_id,        last_update,
                               or_print_tag,      print_seq_no,   currency_cd,
                               foreign_curr_amt,  column_no
                              )
                       VALUES (:GLOBAL.cg$giop_gacc_tran_id, v_generation_type, v_item_seq_no,
                               v_particulars,     NULL,           NULL,
                               v_fc_gross_amt,    USER,           SYSDATE,
                               NULL,              v_item_seq_no,  rec.currency_cd,
                               v_fc_gross_amt,    NULL
                              );*/
                  v_list.gacc_tran_id := p_gacc_tran_id;
                  v_list.item_seq_no := v_item_seq_no;
                  v_list.print_seq_no := v_item_seq_no;
                  v_list.item_amt := v_gross_amt;
                  v_list.item_gen_type := v_generation_type;
                  v_list.item_text := v_particulars;
                  v_list.currency_cd := rec.currency_cd;
                  v_list.line := NULL;
                  v_list.bill_no := NULL;
                  v_list.or_print_tag := NULL;
                  v_list.foreign_curr_amt := v_fc_gross_amt;
                  v_list.user_id := USER;
                  v_list.last_update := SYSDATE;
                  v_list.column_no := NULL;

                  FOR sname IN (SELECT short_name
                                  FROM giis_currency
                                 WHERE main_currency_cd = rec.currency_cd)
                  LOOP
                     v_list.dsp_curr_sname := sname.short_name;
                     EXIT;
                  END LOOP;

                  PIPE ROW (v_list);
               END IF;
            ELSE
               IF rec.currency_cd = 1
               THEN
                  /*INSERT INTO giac_op_text
                              (gacc_tran_id, item_gen_type, item_seq_no,
                               item_text, line, bill_no, item_amt, user_id, last_update,
                               or_print_tag, print_seq_no, currency_cd, foreign_curr_amt,
                               column_no
                              )
                       VALUES (:GLOBAL.cg$giop_gacc_tran_id, v_generation_type, v_item_seq_no,
                               v_particulars, NULL, NULL, v_amount, USER, SYSDATE,
                               NULL, v_item_seq_no, rec.currency_cd, v_fcurrency_amt,
                               NULL
                              );*/
                  v_list.gacc_tran_id := p_gacc_tran_id;
                  v_list.item_seq_no := v_item_seq_no;
                  v_list.print_seq_no := v_item_seq_no;
                  v_list.item_amt := v_amount;
                  v_list.item_gen_type := v_generation_type;
                  v_list.item_text := v_particulars;
                  v_list.currency_cd := rec.currency_cd;
                  v_list.line := NULL;
                  v_list.bill_no := NULL;
                  v_list.or_print_tag := NULL;
                  v_list.foreign_curr_amt := v_fcurrency_amt;
                  v_list.user_id := USER;
                  v_list.last_update := SYSDATE;
                  v_list.column_no := NULL;

                  FOR sname IN (SELECT short_name
                                  FROM giis_currency
                                 WHERE main_currency_cd = rec.currency_cd)
                  LOOP
                     v_list.dsp_curr_sname := sname.short_name;
                     EXIT;
                  END LOOP;

                  PIPE ROW (v_list);
               ELSE
                  /*INSERT INTO giac_op_text
                              (gacc_tran_id, item_gen_type, item_seq_no,
                               item_text, line, bill_no, item_amt, user_id, last_update,
                               or_print_tag, print_seq_no, currency_cd, foreign_curr_amt,
                               column_no
                              )
                       VALUES (:GLOBAL.cg$giop_gacc_tran_id, v_generation_type, v_item_seq_no,
                               v_particulars, NULL, NULL, v_fcurrency_amt, USER, SYSDATE,
                               NULL, v_item_seq_no, rec.currency_cd, v_fcurrency_amt,
                               NULL
                              );*/
                  v_list.gacc_tran_id := p_gacc_tran_id;
                  v_list.item_seq_no := v_item_seq_no;
                  v_list.print_seq_no := v_item_seq_no;
                  v_list.item_amt := v_fcurrency_amt;
                  v_list.item_gen_type := v_generation_type;
                  v_list.item_text := v_particulars;
                  v_list.currency_cd := rec.currency_cd;
                  v_list.line := NULL;
                  v_list.bill_no := NULL;
                  v_list.or_print_tag := NULL;
                  v_list.foreign_curr_amt := v_fcurrency_amt;
                  v_list.user_id := USER;
                  v_list.last_update := SYSDATE;
                  v_list.column_no := NULL;

                  FOR sname IN (SELECT short_name
                                  FROM giis_currency
                                 WHERE main_currency_cd = rec.currency_cd)
                  LOOP
                     v_list.dsp_curr_sname := sname.short_name;
                     EXIT;
                  END LOOP;

                  PIPE ROW (v_list);
               END IF;
            END IF;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN;
   END;

     /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.17.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : check_op_text_2_y program unit
   */
   PROCEDURE check_op_text_2_y (
      v_b160_tax_cd    NUMBER,
      v_tax_name       VARCHAR2,
      v_tax_amt        NUMBER,
      v_currency_cd    NUMBER,
      v_convert_rate   NUMBER,
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE
   )
   IS
      v_exist           VARCHAR2 (1);
      v_item_gen_type   giac_modules.generation_type%TYPE;
      v_n_seq_no        NUMBER;
   BEGIN
      FOR i IN (SELECT generation_type
                  FROM giac_modules
                 WHERE module_name = 'GIACS025')
      LOOP
         v_item_gen_type := i.generation_type;
         EXIT;
      END LOOP;

      BEGIN
        FOR i IN(
            SELECT 'X'
               --INTO v_exist
               FROM giac_op_text
              WHERE gacc_tran_id = p_gacc_tran_id
                AND item_text = v_tax_name
                  /*AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (v_currency_cd, '09'));*/
        )
        loop
            v_exist := 'X';
            EXIT;
        end loop;

         UPDATE giac_op_text
            SET item_amt = NVL (item_amt, 0) + NVL (v_tax_amt, 0),
                foreign_curr_amt =
                     NVL (foreign_curr_amt, 0)
                   + NVL (v_tax_amt / v_convert_rate, 0)
          WHERE gacc_tran_id = p_gacc_tran_id
            AND item_gen_type = v_item_gen_type
            AND item_text = v_tax_name;
            /*AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (v_currency_cd, '09'));*/
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            SELECT MAX (item_seq_no)
              INTO v_n_seq_no
              FROM giac_op_text
             WHERE gacc_tran_id = p_gacc_tran_id;
             
            BEGIN
               v_n_seq_no := v_n_seq_no + 1;

               INSERT INTO giac_op_text
                           (gacc_tran_id, item_gen_type, item_seq_no,
                            item_amt,
                            item_text,
                            print_seq_no, currency_cd,
                            user_id, last_update,
                            foreign_curr_amt
                           )
                    VALUES (p_gacc_tran_id, 'X', v_n_seq_no,
                            v_tax_amt,
                               LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (v_currency_cd, '09'))
                            || '-'
                            || v_tax_name,
                            v_n_seq_no, v_currency_cd,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE,
                            v_tax_amt / v_convert_rate
                           );
            END;
      END;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.17.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : insert_giac_op_text program unit
   */
   PROCEDURE insert_giac_op_text (
      p_tran_id        IN   NUMBER,
      p_fund_cd        IN   VARCHAR2,
      p_iss_cd         IN   VARCHAR2,
      p_prem_seq_no    IN   NUMBER,
      p_inst_no        IN   NUMBER,
      p_gacc_tran_id   IN   giac_op_text.gacc_tran_id%TYPE
   )
   IS
      v_count          NUMBER                                      := 0;
      v_tax_cd         NUMBER;
      v_tax_name       VARCHAR2 (100);
      v_sub_tax_amt    NUMBER;
      v_currency_cd    giac_direct_prem_collns.currency_cd%TYPE;
      v_convert_rate   giac_direct_prem_collns.convert_rate%TYPE;
      v_or_curr_cd     giac_order_of_payts.currency_cd%TYPE;
      --Vincent 02092006: stores the currency_cd in the O.R.
      v_def_curr_cd    giac_order_of_payts.currency_cd%TYPE
                                          := NVL (giacp.n ('CURRENCY_CD'), 1);
      --Vincent 02092006: stores the default currency_cd
      v_evat           NUMBER;
      v_no             NUMBER;
      v_check_name     VARCHAR2 (100);
   BEGIN
      FOR b1 IN (SELECT currency_cd
                   FROM giac_order_of_payts
                  WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_or_curr_cd := b1.currency_cd;
         EXIT;
      END LOOP;

      v_evat := giacp.n ('EVAT');

      FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd,
                         a.convert_rate
                    FROM giac_direct_prem_collns a,
                         giac_tax_collns b,
                         giac_taxes c
                   WHERE b.gacc_tran_id = p_tran_id
                     AND a.gacc_tran_id = b.gacc_tran_id
                     AND a.b140_iss_cd = b.b160_iss_cd
                     AND a.b140_prem_seq_no = b.b160_prem_seq_no
                     AND a.inst_no = b.inst_no
                     AND c.fund_cd = p_fund_cd
                     AND b.b160_iss_cd = p_iss_cd
                     AND b.b160_prem_seq_no = p_prem_seq_no
                     AND b.inst_no = p_inst_no
                     AND b.b160_tax_cd = c.tax_cd)
      LOOP
         v_count := v_count + 1;
         v_tax_cd := tax.b160_tax_cd;
         v_tax_name := tax.tax_name;
         v_sub_tax_amt := tax.tax_amt;

         --Vincent 02092006
         --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
         --should also be in the default  currency regardless of what currency_cd is in the invoice
         IF v_or_curr_cd = v_def_curr_cd
         THEN
            v_convert_rate := 1;
            v_currency_cd := v_def_curr_cd;
         ELSE
            v_convert_rate := tax.convert_rate;
            v_currency_cd := tax.currency_cd;
         END IF;

         --v--
         IF v_tax_cd != v_evat
         THEN
            v_no := v_no + 1;
         END IF;

         IF v_check_name = v_tax_name
         THEN
            EXIT;
         END IF;

         IF v_count = 1
         THEN
            v_check_name := v_tax_name;
         END IF;

         check_op_text_2_y (v_tax_cd,
                            v_tax_name,
                            v_sub_tax_amt,
                            v_currency_cd,
                            v_convert_rate,
                            p_gacc_tran_id
                           );
      END LOOP;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.17.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : check_insert_tax_collns program unit
   */
   PROCEDURE check_insert_tax_collns (
      p_gacc_tran_id   IN       giac_tax_collns.gacc_tran_id%TYPE,
      p_msg_alert      OUT      VARCHAR2
   )
   IS
      CURSOR tax_rec
      IS
         SELECT SUM (tax_amt)
           FROM giac_tax_collns
          WHERE gacc_tran_id = p_gacc_tran_id;

      CURSOR prem_colln_tax
      IS
         SELECT SUM (tax_amt)
           FROM giac_direct_prem_collns
          WHERE gacc_tran_id = p_gacc_tran_id;

      CURSOR evat_param
      IS
         SELECT param_value_n
           FROM giac_parameters
          WHERE param_name LIKE 'EVAT';

      CURSOR module_id_gen_type
      IS
         SELECT module_id, generation_type
           FROM giac_modules
          WHERE module_name = 'GIACS007';
    
      --applied the fix to prevent multiple insertion of EVAT entry in GIAC_ACCT_ENTRIES
      CURSOR evat_cur (v_evat IN NUMBER)
      IS
         SELECT   SUM (tax_amt) tax_amt, b160_iss_cd, b160_prem_seq_no,
                  gfun_fund_cd, gibr_branch_cd
             FROM giac_tax_collns a, giac_acctrans b
            WHERE a.gacc_tran_id = b.tran_id
              AND gacc_tran_id = p_gacc_tran_id
              AND b160_tax_cd = v_evat
            AND NOT EXISTS (SELECT '1'  --alfie 07052010 :start
                              FROM giac_acct_entries c,
                                   giac_module_entries d
                                WHERE d.item_no = 6
                                   AND c.gl_acct_category = d.gl_acct_category
                                   AND c.gl_control_acct = d.gl_control_acct
                                   AND c.gl_sub_acct_1 = d.gl_sub_acct_1
                                   AND c.gl_sub_acct_2 = d.gl_sub_acct_2
                                   AND c.gl_sub_acct_3 = d.gl_sub_acct_3
                                   AND c.gl_sub_acct_4 = d.gl_sub_acct_4
                                   AND c.gl_sub_acct_5 = d.gl_sub_acct_5
                                   AND c.gl_sub_acct_6 = d.gl_sub_acct_6
                                   AND c.gl_sub_acct_7 = d.gl_sub_acct_7
                                   AND c.gacc_tran_id  = b.tran_id
                                   AND module_id = (SELECT module_id 
                                                      FROM giac_modules
                                                         WHERE module_name = 'GIACS007')) --alfie 07052010 :end
          GROUP BY b160_iss_cd, b160_prem_seq_no, gfun_fund_cd, gibr_branch_cd
             HAVING SUM(NVL(tax_amt,0)) <> 0; --Vincent 03062006: added so as not to generate 0 amt acct entries

      --Vincent 03062006: added so as not to generate 0 amt acct entries
      gtc_tot_tax_colln     NUMBER                                     := 0;
      gtc_bill_tax_colln    NUMBER                                     := 0;
      gdpc_tax_amt          NUMBER                                     := 0;
      v_exist               VARCHAR2 (1);
      v_message             VARCHAR2 (200);
      v_evat                NUMBER;
      v_module_id           NUMBER;
      v_gen_type            VARCHAR2 (1);
      v_giac_tax_collns_cur giac_tax_collns_pkg.rc_giac_tax_collns_cur;
   BEGIN
      --  msg_alert(:GLOBAL.CG$GIOP_GACC_TRAN_ID,'I',false);
      OPEN tax_rec;

      FETCH tax_rec
       INTO gtc_tot_tax_colln;

      CLOSE tax_rec;

      OPEN prem_colln_tax;

      FETCH prem_colln_tax
       INTO gdpc_tax_amt;

      CLOSE prem_colln_tax;

      OPEN evat_param;

      FETCH evat_param
       INTO v_evat;

      CLOSE evat_param;

      OPEN module_id_gen_type;

      FETCH module_id_gen_type
       INTO v_module_id, v_gen_type;

      CLOSE module_id_gen_type;

      IF NVL (gtc_tot_tax_colln, 0) != NVL (gdpc_tax_amt, 0)
      THEN
         /*FOR a IN (SELECT transaction_type, b140_iss_cd, b140_prem_seq_no,
                          premium_amt, tax_amt, collection_amt, inst_no,
                          gfun_fund_cd, a.prem_vat_exempt, a.rev_gacc_tran_id
                     FROM giac_direct_prem_collns a, giac_acctrans b
                    WHERE a.gacc_tran_id = b.tran_id
                      AND gacc_tran_id = p_gacc_tran_id)
         LOOP
            BEGIN
               SELECT SUM (tax_amt)
                 INTO gtc_bill_tax_colln
                 FROM giac_tax_collns
                WHERE b160_iss_cd = a.b140_iss_cd
                  AND b160_prem_seq_no = a.b140_prem_seq_no
                  AND inst_no = a.inst_no
                  AND gacc_tran_id = p_gacc_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_exist := 'N';
                  gtc_bill_tax_colln := 0;
            END;*/ -- replaced by: Nica 06.15.2013 - based on AC-SPECS-2012-155
            
        FOR a IN (SELECT gacc_tran_id, transaction_type, b140_iss_cd, b140_prem_seq_no, inst_no,
                         gfun_fund_cd, collection_amt, premium_amt, tax_amt, prem_vat_exempt, rev_gacc_tran_id
                    FROM giac_direct_prem_collns a, giac_acctrans b
                   WHERE a.gacc_tran_id = b.tran_id
                     AND gacc_tran_id = p_gacc_tran_id)
        LOOP

            IF NVL (a.tax_amt, 0) IS NOT NULL
               AND NVL (gtc_bill_tax_colln, 0) = 0
            THEN
               IF a.transaction_type = 1
               THEN
                  /*tax_default_value_type1 (p_gacc_tran_id,
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           --user,
                                           --sysdate,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.premium_amt,
                                           a.collection_amt,
                                           a.premium_amt,
                                           a.tax_amt,
                                           a.prem_vat_exempt,
                                           v_dummy
                                          );*/ -- replaced by: Nica 06.15.2013 - based on AC-SPECS-2012-155
                                          
                  tax_default_value_type1(a.gacc_tran_id,
                                          a.transaction_type,
                                          a.b140_iss_cd,
                                          a.b140_prem_seq_no,
                                          a.inst_no,
                                          a.gfun_fund_cd,
                                          a.premium_amt,
                                          a.collection_amt,
                                          a.premium_amt,
                                          a.tax_amt,
                                          a.prem_vat_exempt,
                                          v_giac_tax_collns_cur);
                                          
               ELSIF a.transaction_type = 2
               THEN
                  /*tax_default_value_type2 (p_gacc_tran_id,
                                           a.rev_gacc_tran_id,             
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           --user,
                                           --sysdate,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.premium_amt,
                                           a.collection_amt,
                                           a.premium_amt,
                                           a.tax_amt,
                                           a.prem_vat_exempt,
                                           v_dummy
                                          );*/ -- replaced by: Nica 06.15.2013 - based on AC-SPECS-2012-155
                                          
                  reverse_tran_type_1_or_3(a.gacc_tran_id,
                                           a.rev_gacc_tran_id,
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.collection_amt,
                                           a.prem_vat_exempt,
                                           v_giac_tax_collns_cur); 
               ELSIF a.transaction_type = 3
               THEN
                  /*tax_default_value_type3 (p_gacc_tran_id,
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           a.tax_amt,
                                           --user,
                                           --sysdate,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.premium_amt,
                                           a.collection_amt,
                                           a.premium_amt,
                                           a.prem_vat_exempt,
                                           v_dummy
                                          );*/
                    -- edited by d.alcantara, edited order of parameters, 10.09.2012
                    /*tax_default_value_type3 (p_gacc_tran_id,
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.premium_amt,
                                           a.collection_amt,
                                           a.premium_amt,
                                           a.tax_amt,
                                           a.prem_vat_exempt,
                                           v_dummy
                                          );*/ -- replaced by: Nica 06.15.2013 - based on AC-SPECS-2012-155
                                          
                    tax_default_value_type3(a.gacc_tran_id,
                                            a.transaction_type,
                                            a.b140_iss_cd,
                                            a.b140_prem_seq_no,
                                            a.inst_no,
                                            a.gfun_fund_cd,
                                            a.premium_amt,
                                            a.collection_amt,
                                            a.premium_amt,
                                            a.tax_amt,
                                            a.prem_vat_exempt,
                                            v_giac_tax_collns_cur); 
               ELSIF a.transaction_type = 4
               THEN
                  /*tax_default_value_type4 (p_gacc_tran_id,
                                           a.rev_gacc_tran_id,  -- temporary lang muna
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           a.tax_amt,
                                           --user,
                                           --sysdate,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.premium_amt,
                                           a.collection_amt,
                                           a.premium_amt,
                                           a.prem_vat_exempt,
                                           v_dummy
                                          );*/ -- replaced by: Nica 06.15.2013 - based on AC-SPECS-2012-155
                                          
                  reverse_tran_type_1_or_3(a.gacc_tran_id,
                                           a.rev_gacc_tran_id,
                                           a.transaction_type,
                                           a.b140_iss_cd,
                                           a.b140_prem_seq_no,
                                           a.inst_no,
                                           a.gfun_fund_cd,
                                           a.collection_amt,
                                           a.prem_vat_exempt,
                                           v_giac_tax_collns_cur); 
               END IF;

               insert_giac_op_text (p_gacc_tran_id,
                                    a.gfun_fund_cd,
                                    a.b140_iss_cd,
                                    a.b140_prem_seq_no,
                                    a.inst_no,
                                    p_gacc_tran_id
                                   );
            END IF;
         END LOOP;

         ------
         --insert acctg entries for inserted records
         FOR evat_rec IN evat_cur (v_evat)
         LOOP
            IF NVL (giacp.v ('OUTPUT_VAT_COLLN_ENTRY'), 'N') = 'Y'
            THEN
               /*item_no 7 - deferred input vat*/
               giac_acct_entries_pkg.bpc_aeg_create_acct_entries_y
                                                    (NULL,
                                                     v_module_id,
                                                     7,
                                                     evat_rec.tax_amt,
                                                     v_gen_type,
                                                     v_message,
                                                     p_gacc_tran_id,
                                                     evat_rec.gibr_branch_cd,
                                                     evat_rec.gfun_fund_cd
                                                    );

               IF v_message IS NOT NULL
               THEN
                  p_msg_alert := v_message;
                  RETURN;
               END IF;

               /* item_no 6 - output vat payable*/
               giac_acct_entries_pkg.bpc_aeg_create_acct_entries_y
                                                     (NULL,
                                                      v_module_id,
                                                      6,
                                                      evat_rec.tax_amt,
                                                      v_gen_type,
                                                      v_message,
                                                      p_gacc_tran_id,
                                                      evat_rec.gibr_branch_cd,
                                                      evat_rec.gfun_fund_cd
                                                     );

               IF v_message IS NOT NULL
               THEN
                  p_msg_alert := v_message;
                  RETURN;
               END IF;
            END IF;
         END LOOP;
      ------
      --forms_ddl('commit');
      END IF;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.29.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : get max seq no
   */
   PROCEDURE gen_seq_nos_or_prev (
      p_gacc_tran_id    IN       giac_op_text.gacc_tran_id%TYPE,
      p_item_gen_type   IN       giac_op_text.item_gen_type%TYPE,
      p_start_row       IN       VARCHAR2,
      p_end_row         IN       VARCHAR2,
      p_print_seq_no    OUT      giac_op_text.print_seq_no%TYPE,
      p_item_seq_no     OUT      giac_op_text.item_seq_no%TYPE
   )
   IS
   BEGIN
      SELECT /*+ NO_CPU_COSTING */
             NVL (MAX (print_seq_no), 0) print_seq_no
        INTO p_print_seq_no
        FROM (SELECT ROWNUM rownum_, a.print_seq_no
                FROM (SELECT print_seq_no
                        FROM TABLE
                                (giac_op_text_pkg.get_giac_op_text
                                                               (p_gacc_tran_id)
                                )) a)
       WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row;

      SELECT /*+ NO_CPU_COSTING */
             NVL (MAX (item_seq_no), 0) item_seq_no
        INTO p_item_seq_no
        FROM (SELECT ROWNUM rownum_, a.item_seq_no, a.item_gen_type
                FROM (SELECT item_seq_no, item_gen_type
                        FROM TABLE
                                (giac_op_text_pkg.get_giac_op_text
                                                               (p_gacc_tran_id)
                                )) a)
       WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
         AND item_gen_type = p_item_gen_type;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.29.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : check print_seq_no if exist
   */
   FUNCTION check_print_seq_no_or_prev (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE,
      p_print_seq_no   giac_op_text.print_seq_no%TYPE,
      p_start_row      VARCHAR2,
      p_end_row        VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT /*+ NO_CPU_COSTING */
                'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.print_seq_no print_seq_no
                   FROM (SELECT print_seq_no
                           FROM TABLE
                                   (giac_op_text_pkg.get_giac_op_text
                                                               (p_gacc_tran_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND print_seq_no = p_print_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  12.29.2010
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : get all sum amounts
   */
   PROCEDURE sum_amounts_or_prev (
      p_gacc_tran_id   IN       giac_op_text.gacc_tran_id%TYPE,
      p_start_row      IN       VARCHAR2,
      p_end_row        IN       VARCHAR2,
      p_sum_item_amt   OUT      VARCHAR2,
      p_sum_fc_amt     OUT      VARCHAR2,
      p_sum_print1     OUT      VARCHAR2,
      p_sum_print2     OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT /*+ NO_CPU_COSTING */
             NVL (SUM (item_amt), 0) sum_item_amt,
             NVL (SUM (foreign_curr_amt), 0) sum_fc_amt,
             NVL (SUM (DECODE (NVL (or_print_tag, 'Y'),
                               'Y', item_amt,
                               'N', 0,
                               item_amt
                              )
                      ),
                  0
                 ) sum_print1,
             NVL (SUM (DECODE (NVL (or_print_tag, 'Y'),
                               'Y', foreign_curr_amt,
                               'N', 0,
                               foreign_curr_amt
                              )
                      ),
                  0
                 ) sum_print2
        INTO p_sum_item_amt,
             p_sum_fc_amt,
             p_sum_print1,
             p_sum_print2
        FROM (SELECT ROWNUM rownum_, a.*
                FROM (SELECT item_amt, foreign_curr_amt, or_print_tag
                        FROM TABLE
                                (giac_op_text_pkg.get_giac_op_text
                                                               (p_gacc_tran_id)
                                )) a)
       WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row;
   END;

    /*
   **  Created by   :  Anthony Santos
   **  Date Created :  1.3.2011
   **  Reference By : (GIACS014
   **
   */
   PROCEDURE update_op_text_giacs014 (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT DISTINCT b.gacc_tran_id, b.user_id, b.last_update, b.item_no,
                         b.collection_amt item_amt,
                         (   DECODE (b.transaction_type,
                                     1, 'Collection ',
                                     2, 'Refund '
                                    )
                          || ' / '
                          || LTRIM (TO_CHAR (b.gl_acct_category, '9'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09'))
                          || ' '
                          || c.gl_acct_sname
                         ) item_text
                    FROM giac_acctrans a,
                         giac_unidentified_collns b,
                         giac_chart_of_accts c
                   WHERE a.tran_id = b.gacc_tran_id
                     AND b.gl_acct_category = c.gl_acct_category
                     AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                     AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                     AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                     AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                     AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                     AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                     AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                     AND b.gl_control_acct = c.gl_control_acct
                     AND b.gacc_tran_id = p_gacc_tran_id
                     AND a.tran_flag <> 'D'
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM giac_acctrans d, giac_reversals e
                             WHERE d.tran_id = e.reversing_tran_id
                               AND e.gacc_tran_id = a.tran_id
                               AND d.tran_flag <> 'D')
                ORDER BY b.item_no;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1);                                   -- := 'H';
      curr_cd       NUMBER (2);
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = p_item_gen_type;

      SELECT param_value_n
        INTO curr_cd
        FROM giac_parameters
       WHERE param_name = 'CURRENCY_CD';

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, print_seq_no,
                      item_amt, item_gen_type, item_text,
                      user_id, last_update, currency_cd,
                      foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_seq_no,
                      c_rec.item_amt, p_item_gen_type, c_rec.item_text,
                      c_rec.user_id, c_rec.last_update, curr_cd,
                      c_rec.item_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  01.03.2011
   **  Reference By : (GIACS025 - OR Preview)
   **  Description  : validate before printing
   */
   PROCEDURE validate_print_op_giacs025 (
      p_gacc_tran_id   IN       giac_op_text.gacc_tran_id%TYPE,
      p_curr_cd        IN       giis_currency.main_currency_cd%TYPE,
      p_curr_sname     IN       giis_currency.short_name%TYPE,
      p_msg_1          OUT      VARCHAR2,
      p_msg_2          OUT      VARCHAR2,
      p_msg_3          OUT      VARCHAR2
   )
   IS
      v_exist       NUMBER (1)                                := 0;
      v_gross_tag   giac_order_of_payts.gross_tag%TYPE;
      v_op_amount   giac_order_of_payts.collection_amt%TYPE;
   BEGIN
      FOR a IN (SELECT *
                  FROM giac_op_text
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         IF a.currency_cd <> p_curr_cd
         THEN
            IF (a.or_print_tag = 'Y' OR a.or_print_tag IS NULL)
            THEN
               v_exist := v_exist + 1;
            END IF;
         END IF;

         IF a.line = 'PA'
         THEN
            p_msg_3 :=
                  'Make sure that the Non-VAT OR is inserted in the printer.';
         END IF;
      END LOOP;

      IF v_exist > 0
      THEN
         p_msg_1 :=
               'Records having currencies other than '
            || p_curr_sname
            || ' will be untagged.';

         UPDATE giac_op_text
            SET or_print_tag = 'N'
          WHERE gacc_tran_id = p_gacc_tran_id AND currency_cd <> p_curr_cd;
      END IF;

      BEGIN
         SELECT gross_tag,
                DECODE (gross_tag,
                        'Y', gross_amt,
                        'N', collection_amt,
                        gross_amt
                       )
           INTO v_gross_tag,
                v_op_amount
           FROM giac_order_of_payts
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_2 := 'Gross tag not found in order_of_payts.';
      END;
   END;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE upd_giac_op_text_giacs019 (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT DISTINCT gfpp.gacc_tran_id,
                         (-1 * gfpp.disbursement_amt) item_amt,
                         (   b.line_cd
                          || '-'
                          || LTRIM (TO_CHAR (b.binder_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.binder_seq_no, '09999'))
                          || ' / '
                          || TO_CHAR (b.binder_date, 'DD-MON-YYYY')
                         ) item_text,
                         gfpp.user_id, gfpp.last_update, b.line_cd,
                         gfpp.currency_cd,
                         -1 * (gfpp.foreign_curr_amt) "FOR_CURR_AMT"
                    FROM giac_outfacul_prem_payts gfpp, giri_binder b
                   WHERE gfpp.gacc_tran_id = p_gacc_tran_id
                     AND gfpp.d010_fnl_binder_id = b.fnl_binder_id
                     AND gfpp.a180_ri_cd = b.ri_cd;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1)                    := 'M';
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = ws_gen_type;

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, print_seq_no,
                      item_amt, item_gen_type, item_text,
                      user_id, last_update, line,
                      currency_cd, foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_seq_no,
                      c_rec.item_amt, ws_gen_type, c_rec.item_text,
                      c_rec.user_id, c_rec.last_update, c_rec.line_cd,
                      c_rec.currency_cd, c_rec.for_curr_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END upd_giac_op_text_giacs019;

/*
**  Created by      : Queenie Santos
**  Date Created  :   May 9, 2011
**  Reference By  :   GIACS050
**
*/
   FUNCTION get_total_premium (
      p_tran_id       giac_order_of_payts.gacc_tran_id%TYPE,
      p_currency_cd   giac_parameters.param_name%TYPE
   )
      RETURN NUMBER
   IS
      v_premium_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT b.item_text,
                         DECODE (NVL (p_currency_cd, giacp.n ('CURRENCY_CD')),
                                 giacp.n ('CURRENCY_CD'), b.item_amt,
                                 b.foreign_curr_amt
                                ) item_amt
                    FROM giac_op_text b
                   WHERE b.gacc_tran_id = NVL (p_tran_id, b.gacc_tran_id)
                     AND NVL (b.or_print_tag, 'Y') = 'Y'
                     AND UPPER (b.item_text) LIKE '%PREMIUM%'
                     AND b.item_gen_type <> 'X')
      LOOP
         IF UPPER (rec.item_text) LIKE '%VATABLE%'
         THEN
            v_premium_amt := NVL (v_premium_amt, 0) + rec.item_amt;
         ELSIF UPPER (rec.item_text) LIKE '%ZERO%'
         THEN
            v_premium_amt := NVL (v_premium_amt, 0) + rec.item_amt;
         ELSIF UPPER (rec.item_text) LIKE '%EXEMPT%'
         THEN
            v_premium_amt := NVL (v_premium_amt, 0) + rec.item_amt;
         END IF;
      END LOOP;

      RETURN v_premium_amt;
   END get_total_premium;

   PROCEDURE del_giac_op_text4 (
      p_gacc_tran_id   giac_op_text.gacc_tran_id%TYPE,
      p_module_name    giac_modules.module_name%TYPE
   )
   IS
      v_gen_type   giac_modules.generation_type%TYPE;
   BEGIN
      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      DELETE      giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id AND item_gen_type = v_gen_type;
   END del_giac_op_text4;

   PROCEDURE update_giac_op_text_giacs007 (
      p_gacc_tran_id  giac_order_of_payts.gacc_tran_id%TYPE,    
      p_module_name   giac_modules.module_name%TYPE
   )
   IS
      v_gen_type   giac_modules.generation_type%TYPE;
   BEGIN
      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      
      DELETE      giac_op_text
                  WHERE gacc_tran_id = p_gacc_tran_id
                    AND NVL (item_amt, 0) = 0
                    AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (
                                                               SELECT tax_cd
                                                                 FROM giac_taxes)
                    AND SUBSTR (item_text, 1, 9) <> 'PREMIUM ('
                    --v--
                    AND item_gen_type = v_gen_type;

      UPDATE giac_op_text
         SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
       WHERE gacc_tran_id = p_gacc_tran_id
         AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd
                                                         FROM giac_taxes)
         AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
         AND item_gen_type = v_gen_type;
   END;
   
    /*
    **  Created by      : D.Alcantara
    **  Date Created  :   March 18, 2011
    **  Reference By  :   GIACS017
    */
   PROCEDURE update_giac_op_text_giacs017 (
      p_gacc_tran_id      giac_inw_claim_payts.gacc_tran_id%TYPE,
      p_var_module_name   giac_modules.module_name%TYPE
   ) IS
      ws_seq_no     NUMBER (2);
      ws_gen_type   VARCHAR2 (1);

      CURSOR c
          IS
            SELECT     A.GACC_TRAN_ID, 
                A.USER_ID, 
                A.LAST_UPDATE, 
                B.LINE_CD, (A.DISBURSEMENT_AMT * -1) ITEM_AMT, 
                'CLAIM NUMBER : '||B.LINE_CD||'-'||B.SUBLINE_CD||'-'||B.ISS_CD||'-'||TO_CHAR(B.CLM_YY,'99')||'-'||TO_CHAR(B.CLM_SEQ_NO,'099999')||
                    ' / POLICY NUMBER : '||C.LINE_CD||'-'||C.SUBLINE_CD||'-'||C.ISS_CD||'-'||TO_CHAR(C.ISSUE_YY,'99')||'-'||TO_CHAR(C.POL_SEQ_NO,'0999999')||'-'||TO_CHAR(C.RENEW_NO,'09')||
                    ' / LOSS DATE : '||TO_CHAR(B.LOSS_DATE,'MON DD, YYYY')||
                    ' -- '|| D.EXP_DESC TEXT,
                A.CURRENCY_CD,
                A.FOREIGN_CURR_AMT        
              FROM GIAC_DIRECT_CLAIM_PAYTS A,
                   GICL_CLAIMS B,
                   GIPI_POLBASIC C,
                   GIIS_EXPENSE D
             WHERE A.GACC_TRAN_ID  = p_gacc_tran_id AND
                   A.CLAIM_ID = B.CLAIM_ID;
   BEGIN
      ws_seq_no := 0;

      SELECT generation_type
        INTO ws_gen_type
        FROM giac_modules
       WHERE module_id = (SELECT module_id
                            FROM giac_modules
                           WHERE module_name = p_var_module_name);

      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
                  AND item_gen_type = ws_gen_type;

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, item_gen_type,
                      item_text, item_amt, user_id,
                      last_update, line, print_seq_no,
                      currency_cd, foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type,
                      c_rec.text, c_rec.item_amt, c_rec.user_id,
                      c_rec.last_update, c_rec.line_cd, ws_seq_no,
                      c_rec.currency_cd, c_rec.foreign_curr_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END update_giac_op_text_giacs017;
   
   FUNCTION get_giac_op_text_listing (
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE,
        p_print_seq_no      GIAC_OP_TEXT.print_seq_no%TYPE,
        p_item_gen_type     GIAC_OP_TEXT.item_gen_type%TYPE,
        p_line              GIAC_OP_TEXT.line%TYPE,
        p_item_text         GIAC_OP_TEXT.item_text%TYPE,
        p_column_no         GIAC_OP_TEXT.column_no%TYPE,
        p_bill_no           GIAC_OP_TEXT.bill_no%TYPE,
        p_item_amt          GIAC_OP_TEXT.item_amt%TYPE,
        p_dsp_curr_sname    GIIS_CURRENCY.short_name%TYPE,
        p_foreign_curr_amt  GIAC_OP_TEXT.foreign_curr_amt%TYPE
   )
      RETURN giac_op_text_tab PIPELINED
   IS
      v_list   giac_op_text_type;
   BEGIN
      FOR i IN (SELECT   a.gacc_tran_id, a.item_seq_no, a.print_seq_no,
                         a.item_amt, a.item_gen_type, a.item_text,
                         a.currency_cd, a.line, a.bill_no, a.or_print_tag,
                         a.foreign_curr_amt, a.user_id, a.last_update,
                         a.cpi_rec_no, a.cpi_branch_cd, a.column_no,
                         b.short_name
                    FROM giac_op_text a, giis_currency b
                   WHERE a.gacc_tran_id = p_gacc_tran_id
                     AND b.main_currency_cd(+) = a.currency_cd
                     AND a.print_seq_no = NVL(p_print_seq_no, a.print_seq_no)
                     AND UPPER(a.item_gen_type) LIKE UPPER(NVL(p_item_gen_type, a.item_gen_type))
                     AND ((a.line IS NULL AND p_line IS NULL) OR UPPER(a.line) LIKE UPPER(NVL(p_line, a.line)))
                     AND UPPER(a.item_text) LIKE UPPER(NVL(p_item_text, a.item_text))
                     AND ((a.column_no IS NULL AND p_column_no IS NULL) OR a.column_no = NVL(p_column_no, a.column_no))
                     AND ((a.bill_no IS NULL AND p_bill_no IS NULL) OR UPPER(a.bill_no) LIKE UPPER(NVL(p_bill_no, a.bill_no)))
                     AND a.item_amt = NVL(p_item_amt, a.item_amt)
                     AND UPPER(b.short_name) LIKE UPPER(NVL(p_dsp_curr_sname, b.short_name))
                     AND ((a.foreign_curr_amt IS NULL AND p_foreign_curr_amt IS NULL) OR a.foreign_curr_amt = NVL(p_foreign_curr_amt, a.foreign_curr_amt))
                ORDER BY a.print_seq_no, a.item_seq_no, a.item_gen_type)
      LOOP
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.item_seq_no := i.item_seq_no;
         v_list.print_seq_no := i.print_seq_no;
         v_list.item_amt := i.item_amt;
         v_list.item_gen_type := i.item_gen_type;
         v_list.item_text := i.item_text;
         v_list.currency_cd := i.currency_cd;
         v_list.line := i.line;
         v_list.bill_no := i.bill_no;
         v_list.or_print_tag := i.or_print_tag;
         v_list.foreign_curr_amt := i.foreign_curr_amt;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.column_no := i.column_no;
         v_list.dsp_curr_sname := i.short_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giac_op_text_print_seq_nos(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    RETURN print_seq_no_tab PIPELINED AS
        v_list              print_seq_no_type;
    BEGIN
        FOR i IN(SELECT print_seq_no
                   FROM GIAC_OP_TEXT
                  WHERE gacc_tran_id = p_gacc_tran_id
                  ORDER BY print_seq_no)
        LOOP
            v_list.print_seq_no := i.print_seq_no;
            PIPE ROW(v_list);
        END LOOP;        
    END;
    
    FUNCTION get_giac_op_text_item_seq_nos(
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    RETURN item_seq_no_tab PIPELINED AS
        v_list          item_seq_no_type;
    BEGIN
        FOR i IN(SELECT item_seq_no
                   FROM GIAC_OP_TEXT
                  WHERE gacc_tran_id = p_gacc_tran_id
                    AND item_gen_type = 'X'
                  ORDER BY item_seq_no)
        LOOP
            v_list.item_seq_no := i.item_seq_no;
            PIPE ROW(v_list);
        END LOOP;          
    END;
    
    /*
    **  Created by      : D.Alcantara
    **  Date Created  :   July 24, 2012
    **  Reference By  :   GIACS025
    **                  - used for adjusting the last non-zero op text record 
    **                  in case there is a 0.01 difference due to currency conversion
    */
    PROCEDURE adjust_op_text_on_discrep (
        p_gacc_tran_id      GIAC_OP_TEXT.gacc_tran_id%TYPE
    ) IS
        v_diff              NUMBER(20,9) := 0;
        v_displayed_diff    NUMBER(12,2) := 0;
        v_op_amount         NUMBER(12,2) := 0;
        v_exact_amount      NUMBER(24,9) := 0;
        v_foreign_sum       NUMBER(17,2) := 0;
        v_currency_rt       NUMBER(12,9);
        v_currency_cd       GIAC_COLLECTION_DTL.currency_cd%TYPE;
        v_new_forgn_amt     GIAC_OP_TEXT.foreign_curr_amt%TYPE;
        v_new_local_amt     GIAC_OP_TEXT.item_amt%TYPE;
        v_gross_tag         GIAC_ORDER_OF_PAYTS.gross_tag%TYPE;
        v_updated           NUMBER(1) := 0;
        v_item_seq_no       GIAC_OP_TEXT.item_seq_no%TYPE := 0;
        v_print_seq_no      GIAC_OP_TEXT.print_seq_no%TYPE := 0;
        v_item_gen_type     GIAC_OP_TEXT.item_gen_type%TYPE := 'X';
    BEGIN
        BEGIN
            SELECT DECODE (gross_tag,
                        'Y', gross_amt,
                        'N', collection_amt,
                        gross_amt
                       ), gross_tag
              INTO v_op_amount, v_gross_tag
              FROM giac_order_of_payts
             WHERE gacc_tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_op_amount := 0;
                v_gross_tag := 'Y';
        END;
        
        IF v_op_amount = 0 THEN
            FOR i IN (SELECT SUM(fc_gross_amt) fc_gross_amt, SUM(fcurrency_amt) fcurrency_amt,
                    NVL(SUM(gross_amt), 0) gross_amt, NVL(SUM(amount),0) amount
                        FROM giac_collection_dtl
                       WHERE gacc_tran_id = p_gacc_tran_id
                       GROUP BY gacc_tran_id)
            LOOP
                IF v_gross_tag = 'Y' THEN
                    v_op_amount := i.fc_gross_amt;
                ELSE
                    v_op_amount := i.fcurrency_amt;
                END IF;
                EXIT;
            END LOOP;
        END IF;
      
        FOR i IN (
            SELECT currency_rt, currency_cd FROM giac_collection_dtl
             WHERE gacc_tran_id = p_gacc_tran_id
        ) LOOP
            v_currency_rt := i.currency_rt;
            v_currency_cd := i.currency_cd;
            EXIT;
        END LOOP;
      
        BEGIN
            SELECT SUM(a.item_amt/b.currency_rt) exact_sum, SUM(a.foreign_curr_amt) foreign_sum
             INTO v_exact_amount, v_foreign_sum
              FROM giac_collection_dtl b, 
                   giac_op_text a
             WHERE b.gacc_Tran_id = p_gacc_tran_id
               AND a.gacc_tran_id = b.gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exact_amount := 0;
                v_currency_rt := 1;
        END;
      
        v_diff :=  v_op_amount - v_exact_amount;
        v_displayed_diff := v_op_amount - v_foreign_sum;
        --DBMS_OUTPUT.PUT_LINE(v_diff||'='||v_op_amount||'-'||v_exact_amount);
        --DBMS_OUTPUT.PUT_LINE(v_displayed_diff||'='||v_op_amount||'-'||v_foreign_sum);
        IF ABS(v_diff) > 0 AND ABS(v_diff) <= 0.01 THEN
            FOR i IN (
                 SELECT * FROM giac_op_text
                  WHERE gacc_tran_id = p_gacc_tran_id
                    AND item_text = (SELECT c.tax_desc
                                       FROM giac_tax_collns a,
                                            gipi_inv_tax b,
                                            giis_tax_charges c,
                                            gipi_invoice d,
                                            gipi_polbasic e
                                      WHERE a.gacc_tran_id = p_gacc_tran_id
                                        AND b.tax_cd = a.b160_tax_cd
                                        AND a.b160_iss_cd = b.iss_cd
                                        AND a.b160_prem_seq_no = b.prem_seq_no
                                        AND b.tax_cd = c.tax_cd
                                        AND b.line_cd = c.line_cd
                                        AND b.iss_cd = c.iss_cd
                                        AND d.iss_cd = b.iss_cd
                                        AND d.prem_seq_no = b.prem_seq_no
                                        AND d.policy_id = e.policy_id
                                        AND e.eff_date BETWEEN c.eff_start_date AND c.eff_end_date
                                        AND c.tax_cd = GIACP.n('LGT'))
            ) LOOP
                IF i.foreign_curr_amt != 0 THEN
                    IF SIGN(v_displayed_diff) = -1 THEN
                        v_new_forgn_amt := i.foreign_curr_amt-0.01;
                    ELSIF SIGN(v_displayed_diff) = 1 THEN
                        v_new_forgn_amt := i.foreign_curr_amt+0.01;
                    END IF;
                    v_new_local_amt := ROUND((v_new_forgn_amt*v_currency_rt), 2);
                    --DBMS_OUTPUT.PUT_LINE('LGT: '||v_new_forgn_amt);
                    --DBMS_OUTPUT.PUT_LINE('LGT: '||v_new_local_amt);
                    
                    --update the amounts
                    UPDATE giac_op_text 
                       SET foreign_curr_amt = NVL(v_new_forgn_amt, i.foreign_curr_amt),
                           item_amt = NVL(v_new_local_amt, i.item_amt)
                     WHERE gacc_tran_id = i.gacc_tran_id
                       AND item_seq_no = i.item_seq_no;
                       
                    v_updated := 1;
                       
                    EXIT;
                END IF;
            END LOOP;

            IF v_updated = 0 THEN
                BEGIN
                    SELECT MAX(item_seq_no)+1 item_seq_no, MAX(print_seq_no)+1 print_seq_no
                      INTO v_item_seq_no, v_print_seq_no
                      FROM giac_op_text
                     WHERE gacc_tran_id = p_gacc_tran_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;
                /*
                FOR j IN (
                    SELECT item_gen_type FROM giac_op_text
                     WHERE gacc_tran_id = p_gacc_tran_id
                ) LOOP
                    IF j.item_gen_type != 'A' THEN
                        v_item_gen_type := 'X';
                        EXIT;
                    END IF;
                END LOOP;*/
                
                IF SIGN(v_displayed_diff) = 1 THEN
                    v_new_forgn_amt := 0.01;
                ELSIF SIGN(v_displayed_diff) = -1 THEN
                    v_new_forgn_amt := -0.01;
                END IF;
                v_new_local_amt := ROUND((v_new_forgn_amt*v_currency_rt), 2);
                --DBMS_OUTPUT.PUT_LINE('No LGT(p): '||v_new_forgn_amt);
                --DBMS_OUTPUT.PUT_LINE('No LGT(f): '||v_new_local_amt);
                
                INSERT INTO giac_op_text(
                             gacc_tran_id, item_seq_no, print_seq_no, item_amt, 
                             item_gen_type, item_text, currency_cd, foreign_curr_amt, 
                             user_id, last_update)
                     VALUES (p_gacc_tran_id, v_item_seq_no, v_print_seq_no, v_new_local_amt,
                             v_item_gen_type, 'OTHERS', v_currency_cd, v_new_forgn_amt,
                             NVL(GIIS_USERS_PKG.app_user, USER), SYSDATE);
            END IF;
            --rollback;
        END IF;
      
    END adjust_op_text_on_discrep;

    /*
    **  Created by      : D.Alcantara
    **  Date Created  :   Aug. 30, 2012
    **  Reference By  :   GIACS007
    */
    PROCEDURE check_op_text_2b_n(p_b160_tax_cd            NUMBER,
                                p_tax_name        VARCHAR2,
                                p_tax_amt            NUMBER,
                                p_currency_cd     NUMBER,
                                p_convert_rate    NUMBER,
                                p_iss_cd          IN giac_direct_prem_collns.b140_iss_cd%TYPE,
                                p_prem_seq_no     IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
                                p_column_no       IN giac_taxes.column_no%TYPE,
                                p_seq_no              OUT      NUMBER,
                                p_sq                  IN       NUMBER,
                                p_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
                                p_gen_type            IN OUT   giac_modules.generation_type%TYPE) IS

      v_exist    VARCHAR2(1);
      v_seq_no1  NUMBER;

    BEGIN
      BEGIN
        SELECT 'X'
          INTO v_exist
          FROM giac_op_text
         WHERE gacc_tran_id = p_gacc_tran_id
           AND item_text = p_tax_name
           AND bill_no = p_iss_cd||'-'||to_char(p_prem_seq_no);

                UPDATE giac_op_text
                     SET item_amt = nvl(item_amt,0) + nvl(p_tax_amt,0),  
                             foreign_curr_amt = nvl(foreign_curr_amt,0) + nvl(p_tax_amt/p_convert_rate,0)
                 WHERE gacc_tran_id= p_gacc_tran_id
             AND item_gen_type = p_gen_type

             AND item_text = p_tax_name
                 AND bill_no = p_iss_cd||'-'||to_char(p_prem_seq_no);

      EXCEPTION
        WHEN no_data_found THEN
                BEGIN
            p_seq_no := p_sq + p_seq_no;     
            INSERT INTO giac_op_text
              (gacc_tran_id  ,item_gen_type  ,item_seq_no     ,item_amt ,
               item_text     ,bill_no        ,print_seq_no    ,currency_cd,
               user_id       ,last_update    ,foreign_curr_amt,column_no) --added by neil 10/29/99
            VALUES 
              (p_gacc_tran_id, p_gen_type, p_seq_no, p_tax_amt,
               --ltrim(to_char(p_b160_tax_cd,'09'))||'-'||ltrim(to_char(p_currency_cd,'09'))||'-'||p_tax_name,
               p_tax_name,
               p_iss_cd||'-'||TO_CHAR(p_prem_seq_no), p_seq_no, p_currency_cd,
               NVL (giis_users_pkg.app_user, USER) ,SYSDATE ,p_tax_amt/p_convert_rate, p_column_no);        
          END;
      END;                          
      
    END check_op_text_2b_n;
    
    FUNCTION validate_balance_acct_entries(p_gacc_tran_id    giac_direct_prem_collns.gacc_tran_id%TYPE)
        RETURN VARCHAR2
    IS
        v_debit     giac_acct_entries.debit_amt%TYPE;
        v_credit    giac_acct_entries.credit_amt%TYPE;
        v_result    VARCHAR2(5);
    BEGIN
        SELECT SUM (debit_amt), SUM (credit_amt)
          INTO v_debit, v_credit
          FROM giac_acct_entries
         WHERE gacc_tran_id = p_gacc_tran_id;
                 
         IF v_debit = v_credit
         THEN
           v_result := 'TRUE';
         ELSE
           v_result := 'FALSE';
         END IF;
        
        RETURN v_result; 
    END;

   /*
   **  Created by   :  Robert John Virrey
   **  Date Created :  04.05.2013
   **  Reference By : (GIACS007 )
   **  Description  : revised gen_op_text, to prevent error in or_preview
   */
   PROCEDURE gen_op_text_giacs007 (
      p_tran_source                 VARCHAR2,
      p_or_flag                     VARCHAR2,
      p_gacc_tran_id                giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
      v_continue            BOOLEAN := TRUE;
      v_iss_cd              giac_comm_payts.iss_cd%TYPE;
      v_prem_seq_no         giac_comm_payts.prem_seq_no%TYPE;
      v_inst_no             giac_comm_payts.inst_no%TYPE;
      v_tran_type           giac_comm_payts.tran_type%TYPE;
      v_prem_amt            giac_direct_prem_collns.premium_amt%TYPE;
      v_prem_vatable        giac_direct_prem_collns.prem_vatable%TYPE;
      v_prem_vat_exempt        giac_direct_prem_collns.prem_vat_exempt%TYPE;
      v_prem_zero_rated        giac_direct_prem_collns.prem_zero_rated%TYPE;
      v_giacs007_record_count        NUMBER;
   BEGIN
   
        SELECT COUNT (*)
          INTO v_giacs007_record_count
          FROM giac_direct_prem_collns
         WHERE gacc_tran_id = p_gacc_tran_id;     
   
         FOR i IN (SELECT *
          FROM giac_direct_prem_collns
         WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_iss_cd              := i.b140_iss_cd;
            v_prem_seq_no         := i.b140_prem_seq_no;
            v_inst_no             := i.inst_no;
            v_tran_type           := i.transaction_type;
            v_prem_amt            := i.premium_amt;
            v_prem_vatable          := i.prem_vatable;
            v_prem_vat_exempt      := i.prem_vat_exempt;
            v_prem_zero_rated      := i.prem_zero_rated;
            
            IF p_tran_source = 'DV'
              THEN
                 giac_op_text_pkg.update_giac_dv_text (p_gacc_tran_id,
                                                       p_module_name
                                                      );
              ELSIF p_tran_source IN ('OP', 'OR')
              THEN
                 IF p_or_flag = 'P'
                 THEN
                    NULL;
                 ELSE
                    IF NVL (giacp.v ('TAX_ALLOCATION'), 'Y') = 'Y'
                    THEN
                       giac_op_text_pkg.update_giac_op_text_y
                                                             (p_gacc_tran_id,
                                                              v_iss_cd,
                                                              v_prem_seq_no,
                                                              v_inst_no,
                                                              v_tran_type,
                                                              p_module_name,
                                                              v_prem_amt,
                                                              p_giop_gacc_fund_cd,
                                                              v_giacs007_record_count,
                                                              v_prem_vatable,
                                                              v_prem_vat_exempt,
                                                              v_prem_zero_rated
                                                             );
                    ELSE
                       giac_op_text_pkg.update_giac_op_text_n (p_gacc_tran_id,
                                                               v_iss_cd,
                                                               v_prem_seq_no,
                                                               v_inst_no,
                                                               v_tran_type,
                                                               v_prem_amt,
                                                               p_module_name,
                                                               p_giop_gacc_fund_cd
                                                              );
                    END IF;
                 END IF;
              END IF;
         END LOOP;
   
   END gen_op_text_giacs007;
   
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.08.2013
    **  Reference By: GIACS021
    **  Description: update_giac_op_text program unit
    */
    PROCEDURE update_giac_op_text_giacs021(
        p_gacc_tran_id              GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    IS
        CURSOR op_rec IS 
            SELECT a.gacc_tran_id ,   
                   a.fund_cd||'-'||a.branch_cd||'-'||TO_CHAR(a.tax_cd)||'-'||TO_CHAR(a.item_no)||'-'||b.tax_name text,
                   DECODE(a.transaction_type,1,a.tax_amt * -1, 2, a.tax_amt * -1) dec_tax_amt,  
                   a.user_id,
                   a.last_update
              FROM GIAC_TAX_PAYMENTS a,
                   GIAC_TAXES b
             WHERE a.tax_cd = b.tax_cd
               AND a.fund_cd = b.fund_cd
               AND a.gacc_tran_id = p_gacc_tran_id;
               
        ws_seq_no                   GIAC_OP_TEXT.item_seq_no%TYPE := 1;
        ws_gen_type                 GIAC_OP_TEXT.item_gen_type%TYPE;
        curr_cd                        NUMBER(2);
    BEGIN
        SELECT generation_type
          INTO ws_gen_type
          FROM GIAC_MODULES
         WHERE module_name  = 'GIACS021';
         
        SELECT param_value_n
          INTO curr_cd
          FROM GIAC_PARAMETERS
         WHERE param_name = 'CURRENCY_CD';

        DELETE FROM GIAC_OP_TEXT
         WHERE gacc_tran_id  = p_gacc_tran_id
           AND item_gen_type = ws_gen_type;
           
        FOR ins_op IN op_rec LOOP
            INSERT INTO GIAC_OP_TEXT
                   (gacc_tran_id, item_gen_type, item_seq_no, item_text, 
                    item_amt, user_id, last_update, print_seq_no,
                    currency_cd, foreign_curr_amt)
            VALUES (ins_op.gacc_tran_id, ws_gen_type, ws_seq_no, ins_op.text,
                    ins_op.dec_tax_amt, ins_op.user_id, ins_op.last_update, ws_seq_no,
                    curr_cd, ins_op.dec_tax_amt);
            ws_seq_no := ws_seq_no + 1;
        END LOOP;
    END;
    
    PROCEDURE adj_doc_stamps_in_giacs025(
        p_gacc_tran_id  GIAC_OP_TEXT.gacc_tran_id%TYPE
    )
    IS
        v_op_amount         NUMBER(12,2) := 0;
        v_gross_tag         GIAC_ORDER_OF_PAYTS.gross_tag%TYPE;
        v_currency_cd       GIAC_COLLECTION_DTL.currency_cd%TYPE;
        v_currency_rt       NUMBER(12,9);
        v_exact_amount      NUMBER(24,9) := 0;
        v_foreign_sum       NUMBER(17,2) := 0;
        v_diff              NUMBER(20,9) := 0;
        v_displayed_diff    NUMBER(12,2) := 0;
        v_new_forgn_amt     GIAC_OP_TEXT.foreign_curr_amt%TYPE;
        v_new_local_amt     GIAC_OP_TEXT.item_amt%TYPE;
        v_updated           NUMBER(1) := 0;
        v_item_seq_no       GIAC_OP_TEXT.item_seq_no%TYPE := 0;
        v_print_seq_no      GIAC_OP_TEXT.print_seq_no%TYPE := 0;
        v_item_gen_type     GIAC_OP_TEXT.item_gen_type%TYPE := 'X';
        v_sum_item_amt          NUMBER := 0;
        v_sum_foreign_curr_amt  NUMBER := 0;
        v_sum_gross_amt         NUMBER := 0;
        v_sum_fcurrency_amt     NUMBER := 0;
        v_comm_gen_type       giac_modules.generation_type%TYPE; --mikel; 7.28.2015; SR#4147
    BEGIN
        BEGIN
            SELECT gross_tag, currency_cd
              INTO v_gross_tag, v_currency_cd
              FROM giac_order_of_payts
             WHERE gacc_tran_id = p_gacc_tran_id;
                       
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_gross_tag := 'Y';
                v_currency_cd := giacp.v('CURRENCY_CD');
        END;
        
        --mikel; 7.28.2015; SR#4147
       SELECT generation_type
         INTO v_comm_gen_type
         FROM giac_modules
        WHERE module_name = 'GIACS020';
                    
        BEGIN
            SELECT SUM (item_amt), SUM (foreign_curr_amt)
              INTO v_sum_item_amt, v_sum_foreign_curr_amt
              FROM giac_op_text
             WHERE gacc_tran_id = p_gacc_tran_id 
               AND item_gen_type != 'X'
               AND item_gen_type != DECODE(v_gross_tag, 'Y', v_comm_gen_type, 'X'); --mikel; 7.28.2015; SR#4147
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_sum_item_amt := 0;
                v_sum_foreign_curr_amt := 0;
        END;
                       
        BEGIN
            SELECT SUM (gross_amt), --SUM (fcurrency_amt)
                   SUM(DECODE(v_gross_tag, 'Y', fc_gross_amt, fcurrency_amt)) --mikel; 7.28.2015; SR#4147
              INTO v_sum_gross_amt, v_sum_fcurrency_amt
              FROM giac_collection_dtl
             WHERE gacc_tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_sum_gross_amt := 0;
                v_sum_fcurrency_amt := 0;
        END;
                    
        --IF v_sum_item_amt = v_sum_gross_amt THEN --mikel; 7.28.2015; SR#4147
            v_diff := v_sum_fcurrency_amt - v_sum_foreign_curr_amt;
            
            v_updated := 0;
                
            IF ABS(v_diff) > 0 AND ABS(v_diff) <= GIACP.N('OR_DOC_STAMPS_ADJ') THEN
                FOR i IN(
                    SELECT *
                      FROM giac_op_text
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND item_text = (SELECT tax_name
                                          FROM giac_taxes
                                         WHERE tax_cd = giacp.n ('DOC_STAMPS'))
                )
                LOOP
                    IF i.foreign_curr_amt != 0 THEN
                        v_new_forgn_amt := (i.foreign_curr_amt + v_diff);
                    END IF;
                                
                    UPDATE giac_op_text
                       SET foreign_curr_amt = NVL (v_new_forgn_amt, i.foreign_curr_amt)
                     WHERE gacc_tran_id = i.gacc_tran_id 
                       AND item_seq_no = i.item_seq_no;
                                   
                    v_updated := 1;
                END LOOP;
                            
                IF v_updated = 0 THEN
                    FOR i IN(
                         SELECT *
                           FROM giac_op_text
                          WHERE gacc_tran_id = p_gacc_tran_id
                            AND item_gen_type != 'X'
                            AND foreign_curr_amt != 0
                          ORDER BY item_seq_no, item_gen_type --mikel; 7.28.2015; SR#4147
                    )
                    LOOP
                        UPDATE giac_op_text
                           SET foreign_curr_amt = (i.foreign_curr_amt + v_diff)
                         WHERE gacc_tran_id = i.gacc_tran_id 
                           AND item_seq_no = i.item_seq_no
                           AND item_gen_type = i.item_gen_type;
                           
                       EXIT;
                    END LOOP;
                END IF;
                            
            END IF;
                        
        --END IF;
            
        COMMIT;
    END;
    
    PROCEDURE recompute_op_text (
       p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
    )
    IS
       v_tot_lcolln_amt      giac_collection_dtl.gross_amt%TYPE;
       v_item_amt            NUMBER;
       v_ratio               NUMBER;
       v_opt_foreign_amt     giac_op_text.foreign_curr_amt%TYPE;
       v_colln_foreign_amt   giac_collection_dtl.fc_gross_amt%TYPE;
       v_discrep             giac_op_text.foreign_curr_amt%TYPE;
       v_exist               VARCHAR2(1) := 'N';
       v_gross_tag           giac_order_of_payts.gross_tag%TYPE;
       v_or_flag             giac_order_of_payts.or_flag%TYPE;
       v_comm_gen_type       giac_modules.generation_type%TYPE; --mikel; 7.28.2015; SR#4147
       v_tot_comm_amt        giac_collection_dtl.commission_amt%TYPE; --mikel; 7.28.2015; SR#4147
       v_currency_cd         giac_collection_dtl.currency_cd%TYPE; --john; 7.30.2015; SR#4147
    BEGIN
        
       --mikel; 7.28.2015; SR#4147
       SELECT generation_type
         INTO v_comm_gen_type
         FROM giac_modules
        WHERE module_name = 'GIACS020';
       
       SELECT SUM (commission_amt + vat_amt)
          INTO v_tot_comm_amt
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_tran_id;
       --end --mikel; 7.28.2015; SR#4147  
            
       BEGIN
        SELECT gross_tag
          INTO v_gross_tag
          FROM giac_order_of_payts
         WHERE gacc_tran_id = p_tran_id;
       
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_gross_tag := 'Y';
       END;
         
       --IF v_gross_tag = 'Y' THEN --mikel; 7.28.2015; SR#4147
        SELECT SUM (gross_amt)
          INTO v_tot_lcolln_amt
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_tran_id;
       
       /*ELSE
        SELECT SUM (amount)
          INTO v_tot_lcolln_amt
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_tran_id;
       END IF;
       */--mikel; 7.28.2015; SR#4147
       
       --john; 7.30.2015; SR#4147
       BEGIN
            SELECT DISTINCT currency_cd
              INTO v_currency_cd
              FROM giac_collection_dtl
             WHERE gacc_tran_id = p_tran_id;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_currency_cd := giacp.n ('CURRENCY_CD');
       END;

        
       FOR opt IN (SELECT   item_seq_no, item_amt, foreign_curr_amt, item_gen_type
                       FROM giac_op_text
                      WHERE gacc_tran_id = p_tran_id 
                        AND item_gen_type != 'X'
                   ORDER BY item_seq_no)
       LOOP
          v_item_amt := 0;
          
          --IF v_gross_tag = 'Y' THEN --mikel; 7.28.2015; SR#4147
             FOR coln IN (  
                  SELECT currency_rt, gross_amt
                    FROM giac_collection_dtl
                   WHERE gacc_tran_id = p_tran_id
                ORDER BY item_no
              )
              LOOP
                 v_ratio := coln.gross_amt / v_tot_lcolln_amt;
                 v_item_amt :=
                           v_item_amt
                           + ((opt.item_amt / coln.currency_rt) * v_ratio);
                 v_exist := 'Y';                   
              END LOOP;
           
          /*ELSE
            FOR coln IN (  
                  SELECT currency_rt, amount
                    FROM giac_collection_dtl
                   WHERE gacc_tran_id = p_tran_id
                ORDER BY item_no
              )
              LOOP
                 v_ratio := coln.amount / v_tot_lcolln_amt;
                 v_item_amt :=
                           v_item_amt
                           + ((opt.item_amt / coln.currency_rt) * v_ratio);
                 v_exist := 'Y';                   
              END LOOP;
          END IF;*/ --mikel; 7.28.2015; SR#4147

          --mikel; 7.28.2015; SR#4147
          IF opt.item_gen_type = v_comm_gen_type AND v_tot_comm_amt != 0 THEN
            v_exist := 'N';
          END IF;
          --end mikel; 7.28.2015; SR#4147
            
          IF v_exist = 'Y' THEN
            UPDATE giac_op_text
               SET foreign_curr_amt = v_item_amt,
                   currency_cd = v_currency_cd
             WHERE gacc_tran_id = p_tran_id 
               AND item_seq_no = opt.item_seq_no
               AND item_gen_type = opt.item_gen_type;
          END IF;
       END LOOP;
       
       --mikel; 7.28.2015; SR#4147
       IF v_tot_comm_amt != 0 THEN
           FOR opt2 IN (SELECT   item_seq_no, item_amt, foreign_curr_amt, item_gen_type
                          FROM giac_op_text
                         WHERE gacc_tran_id = p_tran_id 
                           AND item_gen_type = v_comm_gen_type
                      ORDER BY item_seq_no)
           LOOP
              v_item_amt := 0;
              
                 FOR coln IN (  
                      SELECT currency_rt, (commission_amt + vat_amt) commm
                        FROM giac_collection_dtl
                       WHERE gacc_tran_id = p_tran_id
                         AND (commission_amt != 0 or vat_amt != 0)
                    ORDER BY item_no
                  )
                  LOOP
                     v_ratio := coln.commm / v_tot_comm_amt;
                     v_item_amt :=
                               v_item_amt
                               + ((opt2.item_amt / coln.currency_rt) * v_ratio);
                     v_exist := 'Y';                   
                  END LOOP;
              
              
              IF v_exist = 'Y' THEN
                UPDATE giac_op_text
                   SET foreign_curr_amt = v_item_amt,
                       currency_cd = v_currency_cd
                 WHERE gacc_tran_id = p_tran_id 
                   AND item_seq_no = opt2.item_seq_no
                   AND item_gen_type = opt2.item_gen_type;
              END IF;
           END LOOP;
       END IF;
       --end mikel
       
       giac_op_text_pkg.adj_doc_stamps_in_giacs025(p_tran_id);

       /*SELECT SUM (foreign_curr_amt)
         INTO v_opt_foreign_amt
         FROM giac_op_text
        WHERE gacc_tran_id = p_tran_id AND item_gen_type != 'X';

       SELECT SUM (fc_gross_amt)
         INTO v_colln_foreign_amt
         FROM giac_collection_dtl
        WHERE gacc_tran_id = p_tran_id;

       IF v_colln_foreign_amt != 0 AND v_opt_foreign_amt != 0
       THEN
          v_discrep := v_colln_foreign_amt - v_opt_foreign_amt;
       END IF;

       IF ABS(v_discrep) <= 0.03
       THEN
          FOR adj IN (SELECT   item_seq_no
                          FROM giac_op_text
                         WHERE gacc_tran_id = p_tran_id
                           AND foreign_curr_amt != 0
                           AND item_gen_type != 'X'
                      ORDER BY item_seq_no)
          LOOP
             UPDATE giac_op_text
                SET foreign_curr_amt = foreign_curr_amt + v_discrep
              WHERE gacc_tran_id = p_tran_id AND item_seq_no = adj.item_seq_no;

             EXIT;
          END LOOP;
       END IF;*/

       COMMIT;
    END; 
    
    PROCEDURE validate_before_recompute(
       p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
    )
    IS
        v_or_flag   giac_order_of_payts.or_flag%TYPE;
        v_tran_flag giac_acctrans.tran_flag%TYPE;
    BEGIN
        BEGIN
            SELECT or_flag
              INTO v_or_flag
              FROM GIAC_ORDER_OF_PAYTS
             WHERE gacc_tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_or_flag := 'N';
        END;
        
        BEGIN
            SELECT tran_flag
              INTO v_tran_flag
              FROM GIAC_ACCTRANS
             WHERE tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tran_flag := 'O';
        END;
        
        IF giacp.v('VALIDATE_OR_ACCTG_ENTRIES') = 'N' THEN
            IF v_or_flag = 'N' OR v_or_flag = 'P' THEN
                IF v_tran_flag = 'O' THEN
                    giac_op_text_pkg.recompute_op_text(p_tran_id);
                END IF;
            END IF;
        END IF;
        
        IF giacp.v('VALIDATE_OR_ACCTG_ENTRIES') = 'Y' THEN
            IF v_or_flag = 'N' THEN
                IF v_tran_flag = 'O' THEN
                    giac_op_text_pkg.recompute_op_text(p_tran_id);
                END IF;
            END IF;
        END IF;
        
    END;
    
--    IF VALIDATE_OR_ACCTG_ENTRIES = N
--        IF OR STATUS (OR_FLAG) = N / P
--            IF TRAN_FLAG = O
--                RECOMPUTE
--            
--    IF VALIDATE_OR_ACCTG_ENTRIES = Y
--        IF OR STATUS (OR_FLAG) = N
--            IF TRAN_FLAG = O
--                RECOMPUTE   
--                            
--    IF VALIDATE_OR_ACCTG_ENTRIES = N
--        IF OR STATUS (OR_FLAG) = N
--            IF TRAN_FLAG = C / D / P
--                NO RECOMPUTE
--                
--    IF VALIDATE_OR_ACCTG_ENTRIES = Y
--        IF OR STATUS (OR_FLAG) = P
--            IF TRAN_FLAG = C
--                NO RECOMPUTE  
    
END giac_op_text_pkg;
/


DROP PUBLIC SYNONYM GIAC_OP_TEXT_PKG;

CREATE PUBLIC SYNONYM GIAC_OP_TEXT_PKG FOR CPI.GIAC_OP_TEXT_PKG;
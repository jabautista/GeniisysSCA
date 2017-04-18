DROP PROCEDURE CPI.CREATE_REV_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.create_rev_entries (
   p_assd_no             IN       gipi_polbasic.assd_no%TYPE,
   p_coll_amt            IN       giac_comm_payts.comm_amt%TYPE,
   p_line_cd             IN       giis_line.line_cd%TYPE,
   p_sl_cd                        giac_acct_entries.sl_cd%TYPE,
   p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
   p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
   p_acc_tran_id                  giac_acctrans.tran_id%TYPE,
   p_message             OUT      VARCHAR2
)
IS
   x_intm_no                 giis_intermediary.intm_no%TYPE;
   w_sl_cd                   giac_acct_entries.sl_cd%TYPE;
   y_sl_cd                   giac_acct_entries.sl_cd%TYPE;
   z_sl_cd                   giac_acct_entries.sl_cd%TYPE;
   v_gl_acct_category        giac_acct_entries.gl_acct_category%TYPE;
   v_gl_control_acct         giac_acct_entries.gl_control_acct%TYPE;
   v_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
   v_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
   v_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
   v_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
   v_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
   v_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
   v_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
   v_intm_type_level         giac_module_entries.intm_type_level%TYPE;
   v_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
   v_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
   v_debit_amt               giac_acct_entries.debit_amt%TYPE;
   v_credit_amt              giac_acct_entries.credit_amt%TYPE;
   v_acct_entry_id           giac_acct_entries.acct_entry_id%TYPE;
   v_gen_type                giac_modules.generation_type%TYPE;
   v_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
   v_sl_type_cd              giac_module_entries.sl_type_cd%TYPE;
   v_sl_type_cd2             giac_module_entries.sl_type_cd%TYPE;
   v_sl_type_cd3             giac_module_entries.sl_type_cd%TYPE;
   ws_line_cd                giac_acct_entries.gl_sub_acct_6%TYPE;
   v_gl_intm_no              giac_comm_payts.intm_no%TYPE;
   v_gl_assd_no              gipi_polbasic.assd_no%TYPE;
   v_gl_acct_line_cd         giis_line.acct_line_cd%TYPE;
   ws_acct_intm_cd           giis_intm_type.acct_intm_cd%TYPE;
BEGIN
   BEGIN
      SELECT a.gl_acct_category, a.gl_control_acct,
             NVL (a.gl_sub_acct_1, 0), NVL (a.gl_sub_acct_2, 0),
             NVL (a.gl_sub_acct_3, 0), NVL (a.gl_sub_acct_4, 0),
             NVL (a.gl_sub_acct_5, 0), NVL (a.gl_sub_acct_6, 0),
             NVL (a.gl_sub_acct_7, 0), NVL (a.intm_type_level, 0),
             a.dr_cr_tag, b.generation_type, a.sl_type_cd,
             a.line_dependency_level
        INTO v_gl_acct_category, v_gl_control_acct,
             v_gl_sub_acct_1, v_gl_sub_acct_2,
             v_gl_sub_acct_3, v_gl_sub_acct_4,
             v_gl_sub_acct_5, v_gl_sub_acct_6,
             v_gl_sub_acct_7, v_intm_type_level,
             v_dr_cr_tag, v_gen_type, v_sl_type_cd,
             v_line_dependency_level
        FROM giac_module_entries a, giac_modules b
       WHERE b.module_name = 'GIACB005'
         AND a.item_no = 1
         AND b.module_id = a.module_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message :=
            'CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.';
   END;

   giac_acct_entries_pkg.aeg_check_chart_of_accts (v_gl_acct_category,
                                                   v_gl_control_acct,
                                                   v_gl_sub_acct_1,
                                                   v_gl_sub_acct_2,
                                                   v_gl_sub_acct_3,
                                                   v_gl_sub_acct_4,
                                                   v_gl_sub_acct_5,
                                                   v_gl_sub_acct_6,
                                                   v_gl_sub_acct_7,
                                                   v_gl_acct_id,
                                                   p_message
                                                  );

   IF p_coll_amt > 0
   THEN
      IF v_dr_cr_tag = 'D'
      THEN
         v_debit_amt := 0;
         v_credit_amt := p_coll_amt;
      ELSE
         v_debit_amt := p_coll_amt;
         v_credit_amt := 0;
      END IF;
   ELSIF p_coll_amt < 0
   THEN
      IF v_dr_cr_tag = 'D'
      THEN
         v_debit_amt := p_coll_amt * -1;
         v_credit_amt := 0;
      ELSE
         v_debit_amt := 0;
         v_credit_amt := p_coll_amt * -1;
      END IF;
   END IF;

   giac_acct_entries_pkg.insert_update_acct_entries
                                                (v_gl_acct_category,
                                                 v_gl_control_acct,
                                                 v_gl_sub_acct_1,
                                                 v_gl_sub_acct_2,
                                                 v_gl_sub_acct_3,
                                                 v_gl_sub_acct_4,
                                                 v_gl_sub_acct_5,
                                                 v_gl_sub_acct_6,
                                                 v_gl_sub_acct_7,
                                                 p_sl_cd,
                                                 v_sl_type_cd,
                                                 v_gen_type,
                                                 v_gl_acct_id,
                                                 v_debit_amt,
                                                 v_credit_amt,
                                                 p_gibr_branch_cd,
                                                 p_gibr_gfun_fund_cd,
                                                 p_gacc_tran_id,
                                                 NVL (giis_users_pkg.app_user,
                                                      USER
                                                     )
                                                );

   BEGIN
      BEGIN
         SELECT a.gl_acct_category, a.gl_control_acct,
                NVL (a.gl_sub_acct_1, 0), NVL (a.gl_sub_acct_2, 0),
                NVL (a.gl_sub_acct_3, 0), NVL (a.gl_sub_acct_4, 0),
                NVL (a.gl_sub_acct_5, 0), NVL (a.gl_sub_acct_6, 0),
                NVL (a.gl_sub_acct_7, 0), a.sl_type_cd,
                NVL (a.line_dependency_level, 0), a.dr_cr_tag,
                b.generation_type
           INTO v_gl_acct_category, v_gl_control_acct,
                v_gl_sub_acct_1, v_gl_sub_acct_2,
                v_gl_sub_acct_3, v_gl_sub_acct_4,
                v_gl_sub_acct_5, v_gl_sub_acct_6,
                v_gl_sub_acct_7, v_sl_type_cd,
                v_line_dependency_level, v_dr_cr_tag,
                v_gen_type
           FROM giac_module_entries a, giac_modules b
          WHERE b.module_name = 'GIACB005'
            AND a.item_no = 2
            AND b.module_id = a.module_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
               'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.';
      END;

      IF v_line_dependency_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = p_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message := 'No data found in giis_line.';
         END;

         giac_acct_entries_pkg.aeg_check_level (v_line_dependency_level,
                                                ws_line_cd,
                                                v_gl_sub_acct_1,
                                                v_gl_sub_acct_2,
                                                v_gl_sub_acct_3,
                                                v_gl_sub_acct_4,
                                                v_gl_sub_acct_5,
                                                v_gl_sub_acct_6,
                                                v_gl_sub_acct_7
                                               );
      END IF;

      giac_acct_entries_pkg.aeg_check_chart_of_accts (v_gl_acct_category,
                                                      v_gl_control_acct,
                                                      v_gl_sub_acct_1,
                                                      v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5,
                                                      v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,
                                                      v_gl_acct_id,
                                                      p_message
                                                     );

      IF p_coll_amt > 0
      THEN
         IF v_dr_cr_tag = 'D'
         THEN
            v_debit_amt := 0;
            v_credit_amt := p_coll_amt;
         ELSE
            v_debit_amt := p_coll_amt;
            v_credit_amt := 0;
         END IF;
      ELSIF p_coll_amt < 0
      THEN
         IF v_dr_cr_tag = 'D'
         THEN
            v_debit_amt := p_coll_amt * -1;
            v_credit_amt := 0;
         ELSE
            v_debit_amt := 0;
            v_credit_amt := p_coll_amt * -1;
         END IF;
      END IF;

      aeg_insert_update_entries_rev (v_gl_acct_category,
                                     v_gl_control_acct,
                                     v_gl_sub_acct_1,
                                     v_gl_sub_acct_2,
                                     v_gl_sub_acct_3,
                                     v_gl_sub_acct_4,
                                     v_gl_sub_acct_5,
                                     v_gl_sub_acct_6,
                                     v_gl_sub_acct_7,
                                     v_sl_type_cd,
                                     '1',
                                     p_assd_no,
                                     v_gen_type,
                                     v_gl_acct_id,
                                     v_debit_amt,
                                     v_credit_amt,
                                     p_gibr_gfun_fund_cd,
                                     p_gibr_branch_cd,
									 p_acc_tran_id
                                    );
   END;
END;
/



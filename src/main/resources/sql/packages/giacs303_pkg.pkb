CREATE OR REPLACE PACKAGE BODY CPI.giacs303_pkg
AS
   PROCEDURE new_form_instance (
      p_fund_cd              OUT   giis_funds.fund_cd%TYPE,
      p_fund_desc            OUT   giis_funds.fund_desc%TYPE,
      p_sap_integration_sw   OUT   giac_parameters.param_value_v%TYPE
   )
   AS
   BEGIN
      SELECT fund_cd, fund_desc
        INTO p_fund_cd, p_fund_desc
        FROM giis_funds
       WHERE ROWNUM = 1;

      SELECT giacp.v ('SAP_INTEGRATION_SW')
        INTO p_sap_integration_sw
        FROM DUAL;
   END;

   FUNCTION get_branch_list (
      p_gfun_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_acct_branch_cd          giac_branches.acct_branch_cd%TYPE,
      p_branch_name      giac_branches.branch_name%TYPE,
      p_comp_code        giac_branches.comp_cd%TYPE,
      p_check_dv_print   cg_ref_codes.rv_meaning%TYPE
      )RETURN branch_tab PIPELINED
   AS
      v_rec   branch_type;
   BEGIN
      FOR i IN (SELECT   a.gfun_fund_cd, a.branch_cd, a.branch_name, a.acct_branch_cd, a.comp_cd,
                         a.check_dv_print, d.rv_meaning dsp_check_dv_print, a.bank_cd, b.bank_name,
                         a.bank_acct_cd, c.bank_acct_no, a.bir_permit, a.branch_tin, a.address1,
                         a.address2, a.address3, a.tel_no, a.remarks, a.user_id, a.last_update
                    FROM giac_branches a, giac_banks b, giac_bank_accounts c, cg_ref_codes d
                   WHERE a.bank_cd = b.bank_cd(+)
                     AND a.bank_acct_cd = c.bank_acct_cd(+)
                     AND a.gfun_fund_cd = p_gfun_fund_cd 
                     AND d.rv_domain(+) = 'GIAC_BRANCHES.CHECK_DV_PRINT'
                     AND d.rv_low_value(+) = a.check_dv_print
                     AND UPPER(a.branch_cd) LIKE UPPER(NVL(p_branch_cd, '%'))
                     AND a.acct_branch_cd = NVL(p_acct_branch_cd, a.acct_branch_cd)
                     AND UPPER(a.branch_name) LIKE UPPER(NVL(p_branch_name, '%'))
                     AND UPPER(NVL(a.comp_cd, '%')) LIKE UPPER(NVL(p_comp_code, '%'))
                     AND UPPER(NVL(d.rv_meaning, '%')) LIKE UPPER(NVL(p_check_dv_print, '%'))
                ORDER BY a.branch_cd ASC)
      LOOP
         v_rec.gfun_fund_cd := i.gfun_fund_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.branch_name := i.branch_name;
         v_rec.acct_branch_cd := i.acct_branch_cd;
         v_rec.comp_cd := i.comp_cd;
         v_rec.check_dv_print := i.check_dv_print;
         v_rec.dsp_check_dv_print := i.dsp_check_dv_print;
         v_rec.bank_cd := i.bank_cd;
         v_rec.dsp_bank_name := i.bank_name;
         v_rec.bank_acct_cd := i.bank_acct_cd;
         v_rec.dsp_bank_acct_no := i.bank_acct_no;
         v_rec.bir_permit := i.bir_permit;
         v_rec.branch_tin := i.branch_tin;
         v_rec.address1 := i.address1;
         v_rec.address2 := i.address2;
         v_rec.address3 := i.address3;
         v_rec.tel_no := i.tel_no;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_bank_lov (p_find_text VARCHAR2)
      RETURN bank_lov_tab PIPELINED
   AS
      v_rec   bank_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gbac.bank_cd, gban.bank_name
                           FROM giac_bank_accounts gbac, giac_banks gban
                          WHERE gbac.bank_cd = gban.bank_cd
                            AND gbac.bank_account_flag = 'A'
                            AND gbac.opening_date < SYSDATE
                            AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                            AND (   UPPER (gbac.bank_cd) LIKE UPPER (NVL (p_find_text, '%'))
                                 OR UPPER (gban.bank_name) LIKE UPPER (NVL (p_find_text, '%'))
                                )
                       ORDER BY 2)
      LOOP
         v_rec.bank_cd := i.bank_cd;
         v_rec.bank_name := i.bank_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_bank_acct_lov (p_bank_cd giac_bank_accounts.bank_cd%TYPE, p_find_text VARCHAR2)
      RETURN bank_acct_lov_tab PIPELINED
   AS
      v_rec   bank_acct_lov_type;
   BEGIN
      FOR i IN (SELECT   gbac.bank_acct_cd, gbac.bank_acct_no, gbac.bank_acct_type, gbac.branch_cd
                    FROM giac_bank_accounts gbac
                   WHERE gbac.bank_account_flag = 'A'
                     AND gbac.bank_cd = p_bank_cd
                     AND gbac.opening_date < SYSDATE
                     AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                     AND (   UPPER (gbac.bank_acct_cd) LIKE UPPER (NVL (p_find_text, '%'))
                          OR UPPER (gbac.bank_acct_no) LIKE UPPER (NVL (p_find_text, '%'))
                         )
                ORDER BY 1)
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.bank_acct_cd := i.bank_acct_cd;
         v_rec.bank_acct_no := i.bank_acct_no;
         v_rec.bank_acct_type := i.bank_acct_type;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_check_dv_print_lov (p_find_text VARCHAR2)
      RETURN check_dv_print_lov_tab PIPELINED
   AS
      v_rec   check_dv_print_lov_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_BRANCHES.CHECK_DV_PRINT'
                   AND (   UPPER (rv_low_value) LIKE UPPER (NVL (p_find_text, '%'))
                        OR UPPER (rv_meaning) LIKE UPPER (NVL (p_find_text, '%'))
                       ))
      LOOP
         v_rec.rv_low_value := i.rv_low_value;
         v_rec.rv_meaning := i.rv_meaning;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE update_branch (
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_bank_cd          giac_branches.bank_cd%TYPE,
      p_bank_acct_cd     giac_branches.bank_acct_cd%TYPE,
      p_bir_permit       giac_branches.bir_permit%TYPE,
      p_check_dv_print   giac_branches.check_dv_print%TYPE,
      p_comp_cd          giac_branches.comp_cd%TYPE,
      p_remarks          giac_branches.remarks%TYPE
   )
   IS
   BEGIN
      UPDATE giac_branches
         SET bank_cd = p_bank_cd,
             bank_acct_cd = p_bank_acct_cd,
             bir_permit = p_bir_permit,
             check_dv_print = p_check_dv_print,
             comp_cd = p_comp_cd,
             remarks = p_remarks
       WHERE gfun_fund_cd = p_fund_cd AND branch_cd = p_branch_cd;
   END;

   PROCEDURE val_delete_branch (
      p_check_both     IN   BOOLEAN,
      p_branch_cd      IN   VARCHAR2,
      p_gfun_fund_cd   IN   VARCHAR2
   )
   IS                                                         /* Item value                       */
                           /* Validate that the deletion of the record is permitted    */
                           /* by checking for the existence of rows in related tables. */
      v_exists   VARCHAR2 (1);                                                         /* (null) */
   BEGIN
      IF (p_check_both)
      THEN
         /* Deletion of GIAC_BRANCHES prevented if GIAC_WHOLDING_TAXES reco */
         /* Foreign key(s): GWTX_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_wholding_taxes gwtx
                       WHERE gwtx.gibr_branch_cd = p_branch_cd
                         AND gwtx.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_WHOLDING_TAXES exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_PAYT_REQ_DOCS recor */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_payt_req_docs gprd
                       WHERE gprd.gibr_branch_cd = p_branch_cd
                         AND gprd.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_PAYT_REQ_DOCS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_OUCS records exist */
         /* Foreign key(s): GOUC_GIBR_FK                                   */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_oucs gouc
                       WHERE gouc.gibr_branch_cd = p_branch_cd
                         AND gouc.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_OUCS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_OTH_FUND_OFF_COLLNS */
         /* Foreign key(s): GOFC_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_oth_fund_off_collns gofc
                       WHERE gofc.gibr_branch_cd = p_branch_cd
                         AND gofc.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete General Ins while dependent Giac Oth Fund Off Collns exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_ORDER_OF_PAYTS reco */
         /* Foreign key(s): GIOP_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_order_of_payts giop
                       WHERE giop.gibr_branch_cd = p_branch_cd
                         AND giop.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_ORDER_OF_PAYTS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_DISB_VOUCHERS recor */
         /* Foreign key(s): GIDV_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_disb_vouchers gidv
                       WHERE gidv.gibr_branch_cd = p_branch_cd
                         AND gidv.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_DISB_VOUCHERS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_DUE_TO_FROM_BRANCHE */
         /* Foreign key(s): GBRT_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_due_to_from_branches gbrt
                       WHERE gbrt.gibr_branch_cd = p_branch_cd
                         AND gbrt.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete General In while dependent GI - Due To From Branches exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_AGING_PARAMETERS re */
         /* Foreign key(s): GAGP_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_aging_parameters gagp
                       WHERE gagp.gibr_branch_cd = p_branch_cd
                         AND gagp.gibr_gfun_fund_cd = p_gfun_fund_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_AGING_PARAMETERS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;

         /* Deletion of GIAC_BRANCHES prevented if GIAC_ACCTRANS records ex */
         /* Foreign key(s): GACC_GIBR_FK                                    */
         BEGIN
            FOR i IN (SELECT '1'
                        FROM giac_acctrans gacc
                       WHERE gacc.gibr_branch_cd = p_branch_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Cannot delete GIAC_BRANCHES while dependent GIAC_ACCTRANS exists'
                  );
            END IF;
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               raise_application_error (-20001, 'Geniisys Exception#E#An exception occured.');
         END;
      END IF;
   END;
END;
/



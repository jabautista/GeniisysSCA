DROP PROCEDURE CPI.CANCEL_OR;

CREATE OR REPLACE PROCEDURE CPI.cancel_or (
   p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
   p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
   p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
   p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
   p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
   p_or_date                      VARCHAR2,
   p_message             OUT      VARCHAR2,
   p_calling_form                 VARCHAR2,
   p_module_name                  VARCHAR2,
   p_or_cancellation              VARCHAR2,
   p_payor                        giac_order_of_payts.payor%TYPE,
   p_collection_amt               giac_order_of_payts.collection_amt%TYPE,
   p_cashier_cd                   giac_order_of_payts.cashier_cd%TYPE,
   p_or_tag                       giac_order_of_payts.or_tag%TYPE,
   p_gross_amt                    giac_order_of_payts.gross_amt%TYPE,
   p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
   p_item_no                      giac_module_entries.item_no%TYPE,
   p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE
)
IS
   v_tran_flag       giac_acctrans.tran_flag%TYPE;
   v_dcb_flag        giac_colln_batch.dcb_flag%TYPE;
   v_tran_date       giac_colln_batch.tran_date%TYPE;
   v_cancel_date     giac_order_of_payts.cancel_date%TYPE;
   v_cancel_dcb_no   giac_order_of_payts.cancel_dcb_no%TYPE;
   v_dcb_no          giac_order_of_payts.dcb_no%TYPE;
   v_module_id       giac_modules.module_id%TYPE;
   v_tran_id         giac_acctrans.tran_id%TYPE;
   v_gen_type        giac_modules.generation_type%TYPE;
   v_mess_txt        VARCHAR2 (256)
      :=    'DCB No. '
         || TO_CHAR (p_dcb_no, 'fm099999')
         || ' is '
         || 'Temporarily Closed. Before cancelling this '
         || 'O.R., please check with the person closing '
         || 'the DCB to ensure that the bank deposit '
         || 'tallies with the collection. Continue '
         || 'cancellation?';
   v_dummy           NUMBER                                   := 0;
BEGIN
   IF NVL (giacp.v ('ENTER_ADVANCED_PAYT'), 'N') = 'Y'
   THEN
      BEGIN
         SELECT COUNT (*)
           INTO v_dummy
           FROM giac_advanced_payt
          WHERE gacc_tran_id = p_gacc_tran_id AND acct_ent_date IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF v_dummy > 0
      THEN
         insert_acctrans_cap (p_gibr_gfun_fund_cd,
                              p_gibr_branch_cd,
                              SYSDATE,
                              v_cancel_dcb_no,
                              p_or_pref_suf,
                              p_or_no,
                              v_tran_id,
                              p_message
                             );
         aeg_parameters_rev (p_gacc_tran_id,
                             'GIACB005',
                             v_tran_id,
                             p_gibr_gfun_fund_cd,
                             p_gibr_branch_cd,
                             p_message
                            );
      END IF;

      UPDATE giac_advanced_payt
         SET cancel_date = SYSDATE,
             rev_gacc_tran_id = v_tran_id
       WHERE gacc_tran_id = p_gacc_tran_id;
   --FORMS_DDL ('COMMIT');
   END IF;

   v_tran_flag := get_tran_flag (p_gacc_tran_id);

   UPDATE giac_pdc_checks
      SET check_flag = 'C',
          user_id = NVL (giis_users_pkg.app_user, USER),
          last_update = SYSDATE
    WHERE gacc_tran_id = p_gacc_tran_id;

   IF v_tran_flag = 'P'
   THEN
      v_dcb_flag :=
         get_dcb_flag (p_dcb_no,
                       p_gibr_gfun_fund_cd,
                       p_gibr_branch_cd,
                       p_or_date
                      );

      IF UPPER (v_dcb_flag) = 'C'
      THEN
         get_dcb_no (p_gibr_gfun_fund_cd,
                     p_gibr_branch_cd,
                     v_dcb_no,
                     v_tran_date,
                     p_message
                    );
         v_cancel_date := v_tran_date;
         v_cancel_dcb_no := v_dcb_no;
      ELSIF UPPER (v_dcb_flag) IN ('O', 'T', 'X')
      THEN
         v_cancel_date :=
            get_or_dcb_tran_date (p_or_date,
                                  p_gibr_gfun_fund_cd,
                                  p_gibr_branch_cd,
                                  p_dcb_no
                                 );
         v_cancel_dcb_no := p_dcb_no;
      END IF;

      BEGIN
         UPDATE giac_comm_slip_ext
            SET comm_slip_tag = 'C'
          WHERE gacc_tran_id = p_gacc_tran_id;

         UPDATE giac_order_of_payts
            SET or_flag = 'C',
                user_id = NVL (giis_users_pkg.app_user, USER),
                last_update = SYSDATE,
                cancel_date = v_cancel_date,
                cancel_dcb_no = v_cancel_dcb_no
          WHERE gacc_tran_id = p_gacc_tran_id;

         IF SQL%FOUND
         THEN
		 	p_or_flag := 'C';	
            delete_workflow_rec ('CANCEL OR',
                                 'GIACS001',
                                 NVL (giis_users_pkg.app_user, USER),
                                 p_gacc_tran_id
                                );
            create_records_in_acctrans (p_gibr_gfun_fund_cd,
                                        p_gibr_branch_cd,
                                        v_cancel_date,
                                        v_cancel_dcb_no,
                                        p_or_cancellation,
                                        p_or_date,
                                        p_dcb_no,
                                        p_or_no,
                                        p_or_pref_suf,
                                        v_tran_id,
                                        p_calling_form,
                                        p_message
                                       );
            insert_into_reversals (p_gacc_tran_id, v_tran_id, p_message);
            insert_into_order_of_payts (p_gibr_gfun_fund_cd,
                                        p_gibr_branch_cd,
                                        v_cancel_dcb_no,
                                        p_or_pref_suf,
                                        p_or_no,
                                        v_tran_id,
                                        p_payor,
                                        p_collection_amt,
                                        p_cashier_cd,
                                        p_or_tag,
                                        p_gross_amt,
                                        p_gross_tag
                                       );
            insert_into_acct_entries (p_gacc_tran_id,
                                      p_gibr_gfun_fund_cd,
                                      p_gibr_branch_cd,
                                      v_tran_id,
                                      p_item_no,
                                      p_module_name,
                                      p_message
                                     );
									 
								 
         /*******   importante
            FORMS_DDL ('COMMIT');
            SET_BLOCK_PROPERTY ('gior',
                                default_where,
                                'gacc_tran_id = :GLOBAL.canc_tran_id'
                               );
            EXECUTE_QUERY;
            SET_BLOCK_PROPERTY ('gior',
                                default_where,
                                'or_flag IN (''N'', ''P'') '
                               );
            variables.tran_id := NULL;
            variables.dcb_tran_date := NULL;
            variables.dcb_no := NULL;
            ERASE ('GLOBAL.canc_tran_id');
         *******/
         ELSE
            p_message :=
                'Cancel OR: Error locating the tran_id of this ' || 'record.';
         END IF;
      END;
   ELSIF v_tran_flag = 'D'
   THEN
      p_message :=
             'Cancellation not allowed. This is a deleted ' || 'transaction.';
   ELSE
      v_dcb_flag :=
         get_dcb_flag (p_dcb_no,
                       p_gibr_gfun_fund_cd,
                       p_gibr_branch_cd,
                       p_or_date
                      );

      IF UPPER (v_dcb_flag) = 'C'
      THEN
         get_dcb_no (p_gibr_gfun_fund_cd,
                     p_gibr_branch_cd,
                     v_dcb_no,
                     v_tran_date,
                     p_message
                    );
         v_cancel_date := v_tran_date;
         v_cancel_dcb_no := v_dcb_no;

         BEGIN
            UPDATE giac_comm_slip_ext
               SET comm_slip_tag = 'C'
             WHERE gacc_tran_id = p_gacc_tran_id;

            UPDATE giac_order_of_payts
               SET or_flag = 'C',
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE,
                   cancel_date = v_cancel_date,
                   cancel_dcb_no = v_cancel_dcb_no
             WHERE gacc_tran_id = p_gacc_tran_id;
			 
			

            IF SQL%FOUND
            THEN
			p_or_flag := 'C';	
               update_gacc_giop_tables (p_gacc_tran_id,
                                        p_dcb_no,
                                        p_gibr_gfun_fund_cd,
                                        p_gibr_branch_cd,
                                        p_or_date
                                       );
            /*************************walapa
               FORMS_DDL ('COMMIT');
               SET_BLOCK_PROPERTY ('gior',
                                   default_where,
                                   'gacc_tran_id = :GLOBAL.canc_tran_id'
                                  );
               EXECUTE_QUERY;
               SET_BLOCK_PROPERTY ('gior',
                                   default_where,
                                   'or_flag IN (''N'', ''P'') '
                                  );
               variables.tran_id := NULL;
               variables.dcb_tran_date := NULL;
               variables.dcb_no := NULL;
               ERASE ('GLOBAL.canc_tran_id');
            ******************************/
            ELSE
               p_message :=
                     'Cancel OR: Error locating the tran_id of this '
                  || 'record.';
            END IF;
         END;
      ELSIF UPPER (v_dcb_flag) IN ('O', 'X')
      THEN
         update_gacc_giop_tables (p_gacc_tran_id,
                                  p_dcb_no,
                                  p_gibr_gfun_fund_cd,
                                  p_gibr_branch_cd,
                                  p_or_date
                                 );

         UPDATE giac_comm_slip_ext
            SET comm_slip_tag = 'C'
          WHERE gacc_tran_id = p_gacc_tran_id;
      /****************** wla pa
        FORMS_DDL ('COMMIT');
        SET_BLOCK_PROPERTY ('gior',
                            default_where,
                            'gacc_tran_id = :GLOBAL.canc_tran_id'
                           );
        EXECUTE_QUERY;
        SET_BLOCK_PROPERTY ('gior',
                            default_where,
                            'or_flag IN (''N'', ''P'') '
                           );
        ERASE ('GLOBAL.canc_tran_id');
      ************************/
      ELSIF UPPER (v_dcb_flag) = 'T'
      THEN
         --SET_ALERT_PROPERTY (al_id, alert_message_text, v_mess_txt);

         --IF SHOW_ALERT (al_id) = alert_button1
         --THEN
         update_gacc_giop_tables (p_gacc_tran_id,
                                  p_dcb_no,
                                  p_gibr_gfun_fund_cd,
                                  p_gibr_branch_cd,
                                  p_or_date
                                 );
         --FORMS_DDL ('COMMIT');
         --SET_BLOCK_PROPERTY ('gior',
         --                    default_where,
         --                    'gacc_tran_id = :GLOBAL.canc_tran_id'
         --                   );
         --EXECUTE_QUERY;
         --SET_BLOCK_PROPERTY ('gior',
          --                   default_where,
          --                   'or_flag IN (''N'', ''P'') '
          --                  );
         --ERASE ('GLOBAL.canc_tran_id');
      --END IF;
      END IF;
   END IF;
END;
/



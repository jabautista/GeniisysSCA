DROP PROCEDURE CPI.AEG_CREATE_ACCT_ENTRIES_N;

CREATE OR REPLACE PROCEDURE CPI.aeg_create_acct_entries_n (
   aeg_sl_cd                     giac_acct_entries.sl_cd%TYPE,
   aeg_module_id                 giac_module_entries.module_id%TYPE,
   aeg_item_no                   giac_module_entries.item_no%TYPE,
   aeg_iss_cd                    giac_direct_prem_collns.b140_iss_cd%TYPE,
   aeg_bill_no                   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   aeg_line_cd                   giis_line.line_cd%TYPE,
   aeg_type_cd                   gipi_polbasic.type_cd%TYPE,
   aeg_acct_amt                  giac_direct_prem_collns.collection_amt%TYPE,
   aeg_gen_type                  giac_acct_entries.generation_type%TYPE,
   p_msg_alert             OUT   VARCHAR2,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE
)
IS
   ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
   ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
   ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
   ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
   ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
   ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
   ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
   ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
   ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
   ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
   ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
   ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
   ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
   ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
   ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
   ws_line_cd              giis_line.line_cd%TYPE;
--  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
   ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
   ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
   pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
   pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
   pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
   pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
   pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
   pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
   pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
   ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
   ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
   ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
   ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
                                                           --Vincent 05182006
   v_old_iss_cd            VARCHAR2 (3);
BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);
--msg_alert(to_char(aeg_bill_no)||'--'||to_char(aeg_acct_amt),'I',FALSE);

   /**************************************************************************
   *                                                                         *
   * Populate the GL Account Code used in every transactions.                *
   *                                                                         *
   **************************************************************************/
   BEGIN
   dbms_output.put_line('here 2.1');
      SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
             gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
             gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
             pol_type_tag, NVL (intm_type_level, 0),
             NVL (old_new_acct_level, 0), dr_cr_tag,
             NVL (line_dependency_level, 0), sl_type_cd     --Vincent 05182006
        INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
             ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
             ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
             ws_pol_type_tag, ws_intm_type_level,
             ws_old_new_acct_level, ws_dr_cr_tag,
             ws_line_dep_level, ws_sl_type_cd               --Vincent 05182006
        FROM giac_module_entries
       WHERE module_id = aeg_module_id AND item_no = aeg_item_no;
   --FOR UPDATE of gl_sub_acct_1; --Vincent 01302007: comment out, temporary @FGIC user locks
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert := 'No data found in giac_module_entries.';
   END;

   /**************************************************************************
   *                                                                         *
   * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
   * GL account code that holds the intermediary type.                       *
   *                                                                         *
   **************************************************************************/
   IF ws_intm_type_level != 0
   THEN
   dbms_output.put_line('here 2.2');
      BEGIN
         SELECT DISTINCT (c.acct_intm_cd)
                    INTO ws_acct_intm_cd
                    FROM gipi_comm_invoice a,
                         giis_intermediary b,
                         giis_intm_type c
                   WHERE a.intrmdry_intm_no = b.intm_no
                     AND b.intm_type = c.intm_type
                     AND a.iss_cd = aeg_iss_cd
                     AND a.prem_seq_no = aeg_bill_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'No data found in giis_intm_type.';
      END;
	  dbms_output.put_line('here 2.3');
      aeg_check_level_n (ws_intm_type_level,
                         ws_acct_intm_cd,
                         ws_gl_sub_acct_1,
                         ws_gl_sub_acct_2,
                         ws_gl_sub_acct_3,
                         ws_gl_sub_acct_4,
                         ws_gl_sub_acct_5,
                         ws_gl_sub_acct_6,
                         ws_gl_sub_acct_7
                        );
   END IF;

   /**************************************************************************
   *                                                                         *
   * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
   * the GL account code that holds the line number.                         *
   *                                                                         *
   **************************************************************************/
   IF ws_line_dep_level != 0
   THEN
   dbms_output.put_line('here 2.4');
      BEGIN
         SELECT acct_line_cd
           INTO ws_line_cd
           FROM giis_line
          WHERE line_cd = aeg_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'No data found in giis_line.';
      END;
dbms_output.put_line('here 2.5');
      aeg_check_level_n (ws_line_dep_level,
                         ws_line_cd,
                         ws_gl_sub_acct_1,
                         ws_gl_sub_acct_2,
                         ws_gl_sub_acct_3,
                         ws_gl_sub_acct_4,
                         ws_gl_sub_acct_5,
                         ws_gl_sub_acct_6,
                         ws_gl_sub_acct_7
                        );
   END IF;

   /**************************************************************************
   *                                                                         *
   * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
   * the GL account code that holds the old and new account values.          *
   *                                                                         *
   **************************************************************************/
   IF ws_old_new_acct_level != 0
   THEN
   dbms_output.put_line('here 2.6');
      BEGIN
         BEGIN
            SELECT param_value_v
              INTO v_old_iss_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ISS_CD';
         END;

         BEGIN
		 dbms_output.put_line('here 2.7');
            SELECT param_value_n
              INTO ws_old_acct_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ACCT_CD';
         END;

         BEGIN
		 dbms_output.put_line('here 2.8');
            SELECT param_value_n
              INTO ws_new_acct_cd
              FROM giac_parameters
             WHERE param_name = 'NEW_ACCT_CD';
         END;

         IF aeg_iss_cd = v_old_iss_cd
         THEN
		 	 dbms_output.put_line('here 2.9');
            aeg_check_level_n (ws_old_new_acct_level,
                               ws_old_acct_cd,
                               ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2,
                               ws_gl_sub_acct_3,
                               ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5,
                               ws_gl_sub_acct_6,
                               ws_gl_sub_acct_7
                              );
         ELSE
		 dbms_output.put_line('here 2.10');
            aeg_check_level_n (ws_old_new_acct_level,
                               ws_new_acct_cd,
                               ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2,
                               ws_gl_sub_acct_3,
                               ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5,
                               ws_gl_sub_acct_6,
                               ws_gl_sub_acct_7
                              );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'No data found in giac_parameters.';
      END;
   END IF;

   /**************************************************************************
   *                                                                         *
   * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
   * segments will be attached to this GL account.                           *
   *                                                                         *
   **************************************************************************/
   IF ws_pol_type_tag = 'Y'
   THEN
   dbms_output.put_line('here 2.11');
      BEGIN
         SELECT NVL (gl_sub_acct_1, 0), NVL (gl_sub_acct_2, 0),
                NVL (gl_sub_acct_3, 0), NVL (gl_sub_acct_4, 0),
                NVL (gl_sub_acct_5, 0), NVL (gl_sub_acct_6, 0),
                NVL (gl_sub_acct_7, 0)
           INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                pt_gl_sub_acct_7
           FROM giac_policy_type_entries
          WHERE line_cd = aeg_line_cd AND type_cd = aeg_type_cd;

         IF pt_gl_sub_acct_1 != 0
         THEN
            ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
         END IF;

         IF pt_gl_sub_acct_2 != 0
         THEN
            ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
         END IF;

         IF pt_gl_sub_acct_3 != 0
         THEN
            ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
         END IF;

         IF pt_gl_sub_acct_4 != 0
         THEN
            ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
         END IF;

         IF pt_gl_sub_acct_5 != 0
         THEN
            ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
         END IF;

         IF pt_gl_sub_acct_6 != 0
         THEN
            ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
         END IF;

         IF pt_gl_sub_acct_7 != 0
         THEN
            ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'No data found in giac_policy_type_entries.';
      END;
   END IF;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/
--msg_alert(to_char(aeg_bill_no)||'--'||to_char(aeg_acct_amt)||'--'||to_char(ws_gl_sub_acct_1),'I',FALSE);
   dbms_output.put_line('here 2.12');
   aeg_check_chart_of_accts_n (ws_gl_acct_category,
                               ws_gl_control_acct,
                               ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2,
                               ws_gl_sub_acct_3,
                               ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5,
                               ws_gl_sub_acct_6,
                               ws_gl_sub_acct_7,
                               ws_gl_acct_id,
                               p_msg_alert
                              );

   /****************************************************************************
   *                                                                           *
   * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *

   * debit-credit tag to determine whether the positive amount will be debited *
   * or credited.                                                              *
   *                                                                           *
   ****************************************************************************/
   IF ws_dr_cr_tag = 'D'
   THEN
    dbms_output.put_line('here 2.13');
      IF aeg_acct_amt > 0
      THEN
         ws_debit_amt := ABS (aeg_acct_amt);
         ws_credit_amt := 0;
      ELSE
         ws_debit_amt := 0;
         ws_credit_amt := ABS (aeg_acct_amt);
      END IF;
   ELSE
   dbms_output.put_line('here 2.14');
      IF aeg_acct_amt > 0
      THEN
         ws_debit_amt := 0;
         ws_credit_amt := ABS (aeg_acct_amt);
      ELSE
         ws_debit_amt := ABS (aeg_acct_amt);
         ws_credit_amt := 0;
      END IF;
   END IF;

   /****************************************************************************
   *                                                                           *
   * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
   * same transaction id.  Insert the record if it does not exists else update *
   * the existing record.                                                      *
   *                                                                           *
   ****************************************************************************/
   dbms_output.put_line('here 2.15');
   aeg_insert_update_acct_n
                         (ws_gl_acct_category,
                          ws_gl_control_acct,
                          ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2,
                          ws_gl_sub_acct_3,
                          ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5,
                          ws_gl_sub_acct_6,
                          ws_gl_sub_acct_7,
                          aeg_sl_cd,
                          ws_sl_type_cd,
                          aeg_gen_type,
                          ws_gl_acct_id,
                          ws_debit_amt,
                          ws_credit_amt,
                          aeg_bill_no,
                          p_giop_gacc_branch_cd,
                          p_giop_gacc_fund_cd,
                          p_giop_gacc_tran_id
                         );
END;
/



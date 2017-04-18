DROP PROCEDURE CPI.UPDATE_GIAC_ORDER_OF_PAYTS;

CREATE OR REPLACE PROCEDURE CPI.update_giac_order_of_payts (
   p_gacc_tran_id              giac_acctrans.tran_id%TYPE,
   p_prem_seq_no               giac_aging_soa_details.prem_seq_no%TYPE,
   p_iss_cd                    giac_aging_soa_details.iss_cd%TYPE,
   p_tran_source               VARCHAR2,
   p_module_id                giac_modules.module_id%TYPE,
   p_msg_alert        OUT      VARCHAR2,
   p_workflow_msg     OUT      VARCHAR2,
   p_user_id                   VARCHAR2,
   p_or_part_sw   IN OUT   VARCHAR2
)
IS
   v_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE;
   v_max_bills         NUMBER                                          := 5;
   -- max number of policies to be printed
   v_totbill           NUMBER (5);
   v_totpol            NUMBER (5);
   v_or_no             giac_order_of_payts.or_no%TYPE;
   v_or_flag           giac_order_of_payts.or_flag%TYPE;
   v_or_tag            giac_order_of_payts.or_tag%TYPE;
   v_or_intm_no        giac_order_of_payts.intm_no%TYPE;
   v_or_particulars    giac_order_of_payts.particulars%TYPE;
   v_particulars       giac_order_of_payts.particulars%TYPE;
   v_intm_no           giac_order_of_payts.intm_no%TYPE;
   v_max_colln_intm    giis_intermediary.intm_no%TYPE;
   v_iss_cd            giac_direct_prem_collns.b140_iss_cd%TYPE;
   v_prem_seq_no       giac_direct_prem_collns.b140_prem_seq_no%TYPE;
   v_max_colln_amt     giac_direct_prem_collns.collection_amt%TYPE;
   v_bills             NUMBER                                          := 0;
   v_policy_no         VARCHAR2 (30);
BEGIN
   /** to create workflow records of Premium Payments */
   FOR c1 IN (SELECT SUM (balance_amt_due) balance_amt_due
                FROM giac_aging_soa_details
               WHERE prem_seq_no = p_prem_seq_no AND iss_cd = p_iss_cd)
   LOOP
      v_balance_amt_due := c1.balance_amt_due;
   END LOOP;

   dbms_output.put_line('balance amt due: ' || v_balance_amt_due);
   IF v_balance_amt_due = 0
   THEN
      FOR c1 IN (SELECT claim_id
                   FROM gicl_claims c, gipi_polbasic b, gipi_invoice a
                  WHERE 1 = 1
                    AND c.line_cd = b.line_cd
                    AND c.subline_cd = b.subline_cd
                    AND c.pol_iss_cd = b.iss_cd
                    AND c.issue_yy = b.issue_yy
                    AND c.pol_seq_no = b.pol_seq_no
                    AND c.renew_no = b.renew_no
                    AND b.policy_id = a.policy_id
                    AND a.prem_seq_no = p_prem_seq_no
                    AND a.iss_cd = p_iss_cd)
      LOOP
         FOR c2 IN (SELECT b.userid, d.event_desc
                      FROM giis_events_column c,
                           giis_event_mod_users b,
                           giis_event_modules a,
                           giis_events d
                     WHERE 1 = 1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       AND b.passing_userid = NVL(giis_users_pkg.app_user, USER)         
                       AND a.module_id = 'GIACS007'
                       AND a.event_cd = d.event_cd
                       AND UPPER (d.event_desc) = 'PREMIUM PAYMENTS')
         LOOP
            create_transfer_workflow_rec ('PREMIUM PAYMENTS',
                                          p_module_id,
                                          c2.userid,
                                          c1.claim_id,
                                             c2.event_desc
                                          || ' '
                                          || get_clm_no (c1.claim_id),
                                          p_msg_alert,
                                          p_workflow_msg,
                                          p_user_id
                                         );
         END LOOP;
      END LOOP;
   END IF;

   BEGIN
      SELECT COUNT (*)
        INTO v_bills
        FROM giac_direct_prem_collns
       WHERE gacc_tran_id = p_gacc_tran_id;
   END;
   
   dbms_output.put_line('bills count: ' || v_bills);

   FOR giop IN (SELECT or_no, or_flag, or_tag, intm_no, particulars
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_gacc_tran_id)
   LOOP
      v_or_no := giop.or_no;
      v_or_flag := giop.or_flag;
      v_or_tag := giop.or_tag;
      v_or_intm_no := giop.intm_no;
      v_or_particulars := giop.particulars;
	  dbms_output.put_line('v_or_particulars: ' || v_or_particulars || ' v_or_no: ' || v_or_no || ' v_or_flag: ' || v_or_flag || ' v_or_tag: ' || v_or_tag || ' v_or_intm_no: ' || v_or_intm_no);
   END LOOP;

   FOR bill IN (SELECT b140_iss_cd, b140_prem_seq_no
                  FROM giac_direct_prem_collns
                 WHERE gacc_tran_id = p_gacc_tran_id)
   LOOP
      IF     (v_or_no IS NULL AND v_or_flag = 'N')
         AND (v_or_particulars IS NULL)
      THEN
         IF v_bills > 0
         THEN
            FOR bill_row IN 1 .. v_bills
            LOOP
               v_policy_no := NULL;

               FOR pol IN (SELECT b250.line_cd, b250.subline_cd, b250.iss_cd,
                                  b250.issue_yy, b250.pol_seq_no,
                                  b250.renew_no
                             FROM gipi_polbasic b250, gipi_invoice b140
                            WHERE b140.policy_id = b250.policy_id
                              AND b140.iss_cd = bill.b140_iss_cd
                              AND b140.prem_seq_no = bill.b140_prem_seq_no)
               LOOP
                  v_policy_no :=
                        pol.line_cd
                     || '-'
                     || pol.subline_cd
                     || '-'
                     || pol.iss_cd
                     || '-'
                     || TO_CHAR (pol.issue_yy)
                     || '-'
                     || TO_CHAR (pol.pol_seq_no)
                     || '-'
                     || TO_CHAR (pol.renew_no);
               END LOOP;                                         -- end of pol

               IF (v_policy_no IS NOT NULL)
               THEN
                  IF v_totpol = 1
                  THEN
                     v_particulars := v_policy_no;
                  ELSE
                     v_particulars := v_particulars || ' / ' || v_policy_no;
                  END IF;
               END IF;                       -- end of v_policy_no is not null
            END LOOP;                                       -- end of bill_row

            IF v_totpol > v_max_bills
            THEN
               v_particulars := 'VARIOUS POLICIES';
            END IF;

            /* update particulars in giac_order_of_payts with the generated particulars */
            IF (p_or_part_sw <> 'X')
            THEN
               -- update particulars in giac_order_of_payts if collections exists
               IF v_bills > 0
               THEN
			   	   dbms_output.put_line('1');
                  UPDATE giac_order_of_payts
                     SET particulars = v_particulars
                   WHERE gacc_tran_id = p_gacc_tran_id;
               ELSE       -- set particulars to NULL when no collection exists
			   dbms_output.put_line('2');
                  UPDATE giac_order_of_payts
                     SET particulars = NULL
                   WHERE gacc_tran_id = p_gacc_tran_id;
               END IF;

               -- Use 'O' if or particulars is from giacs007 and 'X' if from giacs001
               p_or_part_sw := 'O';
            END IF;                         -- end of global.or_particulars_sw
         END IF;                                         -- end of v_bills > 0
      END IF;                  -- end of (v_or_no IS NULL AND v_or_flag = 'N')

      IF (v_or_no IS NULL AND v_or_flag = 'N') AND (v_or_intm_no IS NULL)
      THEN
         /*
         /* generate particulars if there are bills. */
         /* Determine the bill no with the greatest collection amt, then, get the intermediary in
         ** gipi_comm_invoice and update the intm_no in giac_order_of_payts with queried intm_no */
         IF v_bills > 0
         THEN
            BEGIN
               SELECT i.intrmdry_intm_no
                 INTO v_intm_no
                 FROM (SELECT intrmdry_intm_no
                         FROM gipi_comm_invoice
                        WHERE iss_cd = bill.b140_iss_cd
                          AND prem_seq_no = bill.b140_prem_seq_no
                       UNION
                       -- get the intm_no of the endt's mother policy, for endt of tax
                       SELECT c.intrmdry_intm_no
                         FROM gipi_polbasic a,
                              gipi_polbasic b,
                              gipi_comm_invoice c
                        WHERE b.policy_id = c.policy_id
                          AND a.line_cd = b.line_cd
                          AND a.subline_cd = b.subline_cd
                          AND a.iss_cd = b.iss_cd
                          AND a.issue_yy = b.issue_yy
                          AND a.pol_seq_no = b.pol_seq_no
                          AND a.renew_no = b.renew_no
                          AND a.endt_seq_no <> 0
                          AND b.endt_seq_no = 0
                          AND a.policy_id IN (
                                 SELECT policy_id
                                   FROM gipi_invoice
                                  WHERE iss_cd = bill.b140_iss_cd
                                    AND prem_seq_no = bill.b140_prem_seq_no)) i;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg_alert :=
                             'Error retrieving intm_no in gipi_comm_invoice.';
               WHEN TOO_MANY_ROWS
               THEN
                  NULL;
            END;

            IF v_bills > 0
            THEN
				dbms_output.put_line('3');
               UPDATE giac_order_of_payts
                  SET intm_no = v_intm_no
                WHERE gacc_tran_id = p_gacc_tran_id;
            ELSE
			dbms_output.put_line('4');
               UPDATE giac_order_of_payts
                  SET intm_no = NULL
                WHERE gacc_tran_id = p_gacc_tran_id;
            END IF;                                     -- end of v_or_intm_no
         END IF;                                   --  end of v_bills > 0 THEN
      END IF;                  -- end of (v_or_no IS NULL AND v_or_flag = 'N')
   END LOOP;
-- updates particulars and intm_no in giacs001
--update_giac_order_of_payts;
END;
/



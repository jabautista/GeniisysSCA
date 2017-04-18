CREATE OR REPLACE PACKAGE BODY CPI.giacs408_pkg
AS
   FUNCTION populate_bill_information ( 
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_user_id       giis_users.user_id%TYPE   
   )
      RETURN bill_info_list_tab PIPELINED
   IS 
      v_bill_no_list   bill_info_list_type;
      v_switch         VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT a.line_cd, a.subline_cd,
                b.assd_no, c.assd_name,
                   get_policy_no(a.policy_id) policy_no
           INTO v_bill_no_list.nbt_line_cd, v_bill_no_list.nbt_subline_cd,
                v_bill_no_list.nbt_assd_no, v_bill_no_list.dsp_assd_name,
                v_bill_no_list.dsp_policy_no
           FROM gipi_polbasic a, gipi_parlist b, giis_assured c
          WHERE 1 = 1
            AND a.policy_id = p_policy_id
            AND a.par_id = b.par_id
            AND b.assd_no = c.assd_no(+);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_bill_no_list.nbt_line_cd := '';
            v_bill_no_list.nbt_subline_cd := '';
            v_bill_no_list.nbt_assd_no := '';
            v_bill_no_list.dsp_assd_name := '';
            v_bill_no_list.dsp_policy_no := '';
      END;

      BEGIN
         SELECT NVL (SUM (a.comm_amt), 0) comm_amt
           INTO v_bill_no_list.v_comm_amt
           FROM giac_comm_payts a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND a.iss_cd = p_iss_cd
            AND a.prem_seq_no = p_prem_seq_no
            AND NOT EXISTS (
                   SELECT c.gacc_tran_id
                     FROM giac_reversals c, giac_acctrans d
                    WHERE c.reversing_tran_id = d.tran_id
                      AND d.tran_flag <> 'D'
                      AND c.gacc_tran_id = a.gacc_tran_id)
            AND b.tran_flag <> 'D';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_bill_no_list.v_comm_amt := 0;
      END;
      
      select bancassurance_sw
        into v_switch
        from gipi_polbasic
       where policy_id = p_policy_id;
      
      v_bill_no_list.banca_dtls_btn := 'FALSE';
      IF NVL(Giisp.v('ORA2010_SW'),'N') = 'Y' THEN
          IF v_switch = 'Y' THEN
            v_bill_no_list.banca_dtls_btn := 'TRUE';
          ELSE 
            v_bill_no_list.banca_dtls_btn := 'FALSE';
          END IF;
      END IF;              
            
      FOR i IN (
          SELECT a.tran_no, a.tran_date, a.tran_flag, rv_meaning dsp_tran_flag
            FROM giac_new_comm_inv a,
                 cg_ref_codes b
           WHERE a.iss_cd = p_iss_cd
             AND a.prem_seq_no = p_prem_seq_no
             AND b.rv_domain = 'GIAC_NEW_COMM_INV.TRAN_FLAG'
             AND b.rv_low_value = a.tran_flag
             AND tran_flag = 'U' AND NVL(delete_sw,'N') = 'N' --added by steven 10.17.2014
        ORDER BY a.tran_no DESC
      ) 
      LOOP
        v_bill_no_list.tran_no := i.tran_no;
        v_bill_no_list.tran_date := TO_CHAR(i.tran_date, 'MM-DD-YYYY HH:MM:SS AM');
        v_bill_no_list.tran_flag := i.tran_flag;
        v_bill_no_list.dsp_tran_flag := UPPER(i.dsp_tran_flag);
        EXIT;
      END LOOP;
      
      PIPE ROW (v_bill_no_list);
   END;

   FUNCTION populate_invoice_comm_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN invoice_comm_list_tab PIPELINED
   IS
      v_inv_comm   invoice_comm_list_type;
   BEGIN
      FOR i IN (SELECT intm_no, share_percentage, premium_amt,
                       commission_amt, wholding_tax, tran_no, remarks,
                       tran_date, delete_sw, comm_rec_id, user_id,
                       post_date, tran_flag, posted_by, fund_cd, branch_cd,
                       iss_cd, prem_seq_no, policy_id
                  FROM giac_new_comm_inv
                 WHERE 1 = 1
                   AND iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                ORDER BY tran_flag DESC, tran_date DESC)
      LOOP
         v_inv_comm.intm_no := i.intm_no;
         v_inv_comm.share_percentage := i.share_percentage;
         v_inv_comm.premium_amt := i.premium_amt;
         v_inv_comm.commission_amt := i.commission_amt;
         v_inv_comm.wholding_tax := i.wholding_tax;
         v_inv_comm.tran_no := i.tran_no;
         v_inv_comm.remarks := i.remarks;
         v_inv_comm.tran_date := i.tran_date;
         v_inv_comm.delete_sw := i.delete_sw;
         v_inv_comm.comm_rec_id := i.comm_rec_id;
         v_inv_comm.user_id := i.user_id;
         v_inv_comm.post_date := i.post_date;
         v_inv_comm.tran_flag := i.tran_flag;
         v_inv_comm.posted_by := i.posted_by;
         v_inv_comm.fund_cd := i.fund_cd;
         v_inv_comm.branch_cd := i.branch_cd;
         v_inv_comm.iss_cd := i.iss_cd;
         v_inv_comm.prem_seq_no := i.prem_seq_no;
         v_inv_comm.policy_id   := i.policy_id;

         -- GNCI post-query
         BEGIN
            SELECT intm_name, NVL (wtax_rate, 0.0) / 100.0
              INTO v_inv_comm.dsp_intm_name, v_inv_comm.nbt_wtax_rate
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
--            EXCEPTION
--                  WHEN NO_DATA_FOUND THEN
                   -- msg_alert('No record of intermediary in Giis_Intermediary.','I',FALSE);
         END;

         BEGIN
            SELECT UPPER (rv_meaning)
              INTO v_inv_comm.dsp_tran_flag
              FROM cg_ref_codes
             WHERE rv_domain IN ('GIAC_NEW_COMM_INV.TRAN_FLAG')
               AND rv_low_value = i.tran_flag;
--            EXCEPTION
--              WHEN NO_DATA_FOUND THEN
               -- msg_alert('No data found in CG_REF_CODES for giac_new_comm_inv.tran_flag','I',TRUE);
         END;

         BEGIN                                  -- populate :gnci.prnt_intmdry
            SELECT a100.intm_name
              INTO v_inv_comm.prnt_intmdry
              FROM giis_intermediary a100
             WHERE a100.intm_no = (SELECT b100.parent_intm_no
                                     FROM giis_intermediary b100
                                    WHERE b100.intm_no = i.intm_no);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN
                  SELECT a100.intm_name
                    INTO v_inv_comm.prnt_intmdry
                    FROM giis_intermediary a100
                   WHERE a100.intm_no = i.intm_no;
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_inv_comm.prnt_intmdry := '';
               END;
         END;

         v_inv_comm.nbt_original_share := i.share_percentage;
         v_inv_comm.nbt_netcomm_amt := NVL (i.commission_amt, 0) - NVL (i.wholding_tax, 0);
         PIPE ROW (v_inv_comm);
      END LOOP;
   END;

   FUNCTION populate_peril_info (
      p_fund_cd       giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd     giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id   giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_intm_no       giac_new_comm_inv_peril.intm_no%TYPE,
      p_line_cd       giis_line.line_cd%TYPE
   )
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT premium_amt, commission_rt, commission_amt,
                       wholding_tax, comm_rec_id, intm_no, iss_cd,
                       prem_seq_no, peril_cd, tran_date, tran_no, tran_flag,
                       comm_peril_id, delete_sw, fund_cd, branch_cd
                  FROM giac_new_comm_inv_peril
                 WHERE 1 = 1
                   AND fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND comm_rec_id = p_comm_rec_id
                   AND intm_no = p_intm_no
                   AND NVL(delete_sw, 'N') != 'Y')
      LOOP
         v_peril.premium_amt := i.premium_amt;
         v_peril.commission_rt := TRIM(TO_CHAR(i.commission_rt, '990.9999999'));
         v_peril.commission_amt := i.commission_amt;
         v_peril.wholding_tax := i.wholding_tax;
         v_peril.comm_rec_id := i.comm_rec_id; 
         v_peril.intm_no := i.intm_no;
         v_peril.iss_cd := i.iss_cd;
         v_peril.prem_seq_no := i.prem_seq_no;
         v_peril.peril_cd := i.peril_cd;
         v_peril.tran_date := i.tran_date;
         v_peril.tran_no := i.tran_no;
         v_peril.tran_flag := i.tran_flag;
         v_peril.comm_peril_id := i.comm_peril_id;
         v_peril.delete_sw := i.delete_sw;
         v_peril.fund_cd := i.fund_cd;
         v_peril.branch_cd := i.branch_cd;
         v_peril.dsp_peril_name := get_peril_name (p_line_cd, i.peril_cd);
         v_peril.dsp_netcomm_amt := NVL (i.commission_amt, 0) - NVL (i.wholding_tax, 0);
         PIPE ROW (v_peril);
      END LOOP;
   END;

   FUNCTION validate_giacs408_bill_no (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN bill_no_list_tab PIPELINED
   IS
      v_bill_no_list   bill_no_list_type;
   BEGIN
      FOR i IN (SELECT b140.iss_cd, b140.prem_seq_no, b140.policy_id,
                       b140.prem_amt
                  FROM gipi_invoice b140
                 WHERE b140.iss_cd != (SELECT param_value_v
                                         FROM giac_parameters
                                        WHERE param_name LIKE ('RI_ISS_CD'))
                   AND b140.iss_cd =
                          DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                               b140.iss_cd,
                                                               'GIACS408',
                                                               p_user_id
                                                              ),
                                  1, b140.iss_cd,
                                  NULL
                                 )
                   AND b140.iss_cd = p_iss_cd
                   AND b140.prem_seq_no = p_prem_seq_no)
      LOOP
         v_bill_no_list.iss_cd := i.iss_cd;
         v_bill_no_list.prem_seq_no := i.prem_seq_no;
         v_bill_no_list.policy_id := i.policy_id;
         v_bill_no_list.prem_amt := i.prem_amt;
         PIPE ROW (v_bill_no_list);
      END LOOP;
   END;

   PROCEDURE chk_bill_no_onselect (
      p_iss_cd        IN       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   IN       gipi_invoice.prem_seq_no%TYPE,
      v_pol_flag      OUT      gipi_polbasic.pol_flag%TYPE,
      v_prem_amt      OUT      gipi_invoice.prem_amt%TYPE,
      v_comm_amt      OUT      giac_comm_payts.comm_amt%TYPE,
      v_exist1        OUT      VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT a.pol_flag, b.prem_amt
           INTO v_pol_flag, v_prem_amt
           FROM gipi_polbasic a, gipi_invoice b
          WHERE a.policy_id = b.policy_id
            AND (a.pol_flag IN ('4', '5') OR b.prem_amt = 0)
            AND b.iss_cd = p_iss_cd
            AND b.prem_seq_no = p_prem_seq_no;

         v_exist1 := '0';

         IF v_prem_amt = 0
         THEN
            BEGIN
-- added by judyann 11032006; allow modification of commission for policies with net premium = 0 (having +/- premiums in gipi_comm_inv_peril)
               SELECT DISTINCT '1'
                          INTO v_exist1
                          FROM gipi_comm_inv_peril
                         WHERE premium_amt <> 0
                           AND iss_cd = p_iss_cd
                           AND prem_seq_no = p_prem_seq_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_exist1 := '0';
            END;
         /*IF v_exist1 IS NULL THEN
            msg_alert('Premium amount is zero. Please select another Bill.','E', TRUE);
         END IF;*/
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT NVL (SUM (a.comm_amt), 0) comm_amt
           INTO v_comm_amt
           FROM giac_comm_payts a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND a.iss_cd = p_iss_cd
            AND a.prem_seq_no = p_prem_seq_no
            AND NOT EXISTS (
                   SELECT c.gacc_tran_id
                     FROM giac_reversals c, giac_acctrans d
                    WHERE c.reversing_tran_id = d.tran_id
                      AND d.tran_flag <> 'D'
                      AND c.gacc_tran_id = a.gacc_tran_id)
            AND b.tran_flag <> 'D';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_comm_amt := 0;
      END;
   END;

   PROCEDURE query_gnci_gncp (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_fund_cd       VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   )
   IS
      /* Populate base table 'GNCI' and 'GNCP' with records
      ** from GIPI_COMM_INVOICE and GIPI_COMM_INV_PERIL which are
      ** not yet existing on these tables.
      */
      v_new_comm_rec_id   giac_new_comm_inv.comm_rec_id%TYPE;
      v_peril_id          giac_new_comm_inv_peril.comm_peril_id%TYPE;
      v_record_exist      VARCHAR2 (1);
      v_passed            VARCHAR2 (2)                                 := 'N';
      v_tran_no           NUMBER (8);
   --  v_gnci_exist       VARCHAR2(1);
   BEGIN
      FOR cur2 IN (SELECT a.intrmdry_intm_no
                         ,a.iss_cd
                         ,a.policy_id
                         ,a.prem_seq_no
                         ,a.share_percentage
                         ,a.premium_amt
                         ,a.commission_amt
                         ,a.wholding_tax
                         ,a.gacc_tran_id 
                         ,a.parent_intm_no
                         ,DECODE (NVL (gint.lic_tag, 'N'),	--added by steven 11.17.2014 base on CS version
									                 'N', gint.parent_intm_no,
									              gint.intm_no
									             ) new_parent_intm_no
                     FROM gipi_comm_invoice a, giis_intermediary gint --added by steven 11.17.2014 base on CS version
                    WHERE a.iss_cd = p_iss_cd
                      AND a.prem_seq_no = p_prem_seq_no
                      AND a.intrmdry_intm_no = gint.intm_no --added by steven 11.17.2014 base on CS version
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_new_comm_inv b
                              WHERE b.iss_cd = a.iss_cd
                                AND b.prem_seq_no = a.prem_seq_no
                                AND fund_cd = p_fund_cd
                                AND branch_cd = p_branch_cd
                                AND b.tran_flag = 'U'
                                AND NVL (b.delete_sw, 'N') = 'N'))
      LOOP
         IF v_passed = 'N'
         THEN
            BEGIN
               SELECT comm_rec_id_seq.NEXTVAL
                 INTO v_new_comm_rec_id
                 FROM SYS.DUAL;

               /*--SELECT max(comm_rec_id)+1
               SELECT NVL (MAX (comm_rec_id), 0) + 1 -- Added by Jomar Diago 09202012
                 INTO v_new_comm_rec_id
                 FROM giac_new_comm_inv;*/ -- Udel 01222013 commented out, used sequence COMM_REQ_ID_SEQ instead to avoid duplicate id
               v_passed := 'Y';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                            (-20001,
                             'Geniisys Exception#I#No sequence comm_rec_id_seq found in sys.dual.'
                            );
            END;

            v_tran_no :=
               giac_sequence_generation (p_fund_cd,
                                         p_branch_cd,
                                         'NEW_COMM_INV_TRAN_NO',
                                         TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')),
                                         TO_NUMBER (TO_CHAR (SYSDATE, 'MM'))
                                        );
         END IF;

         BEGIN
            -- populate Giac_New_Comm_Inv with Gipi_Comm_Invoice
            INSERT INTO giac_new_comm_inv
                        (comm_rec_id, intm_no,
                         iss_cd, policy_id, prem_seq_no,
                         share_percentage, premium_amt,
                         commission_amt, wholding_tax, tran_date,
                         tran_flag, user_id, tran_no, fund_cd, branch_cd,
                         parent_intm_no, create_date) --added by steven 10.17.2014
                 VALUES (v_new_comm_rec_id, cur2.intrmdry_intm_no,
                         cur2.iss_cd, cur2.policy_id, cur2.prem_seq_no,
                         cur2.share_percentage, cur2.premium_amt,
                         cur2.commission_amt, cur2.wholding_tax, SYSDATE,
                         'U', p_user_id, v_tran_no, p_fund_cd, p_branch_cd,
  /*cur2.parent_intm_no*/cur2.new_parent_intm_no, SYSDATE); --added by steven 10.17.2014  --change by steven 11.17.2014 base on CS version;cur2.new_parent_intm_no

            -- Populate GIAC_PREV_COMM_INV. This table serves as
            -- storage for old records coming from GIPI_COMM_INV.
            INSERT INTO giac_prev_comm_inv
                        (comm_rec_id, intm_no,
                         share_percentage, premium_amt,
                         commission_amt, wholding_tax, tran_flag,
                         tran_no, prev_gacc_tran_id, fund_cd, branch_cd,
                         iss_cd, prem_seq_no, parent_intm_no)--added by steven 10.17.2014
                 VALUES (v_new_comm_rec_id, cur2.intrmdry_intm_no,
                         cur2.share_percentage, cur2.premium_amt,
                         cur2.commission_amt, cur2.wholding_tax, 'U',
                         v_tran_no, cur2.gacc_tran_id, p_fund_cd, p_branch_cd,
                         cur2.iss_cd, cur2.prem_seq_no, cur2.parent_intm_no);--added by steven 10.17.2014

            -- Populate GIAC_PREV_PARENT_COMM_INV. This table serves as
            -- storage for old records coming from GIAC_PARENT_COMM_INV.
            FOR c6 IN
               (SELECT a.intm_no, a.chld_intm_no, a.iss_cd, a.prem_seq_no,
                       a.premium_amt, a.commission_amt, a.wholding_tax,
                       a.tran_id
                  FROM giac_parent_comm_invoice a
                 WHERE NOT EXISTS (
                          SELECT 'X'
                            FROM giac_prev_parent_comm_inv b
                           WHERE b.iss_cd = a.iss_cd
                             AND b.prem_seq_no = a.prem_seq_no
                             AND b.intm_no = a.intm_no
                             AND b.chld_intm_no = a.chld_intm_no
                             AND fund_cd = p_fund_cd
                             AND branch_cd = p_branch_cd
                             AND b.comm_rec_id = v_new_comm_rec_id
                             AND b.chld_intm_no = cur2.intrmdry_intm_no)
                   AND a.iss_cd = p_iss_cd
                   AND a.prem_seq_no = p_prem_seq_no
                   AND a.chld_intm_no = cur2.intrmdry_intm_no)
            LOOP
               INSERT INTO giac_prev_parent_comm_inv
                           (comm_rec_id, intm_no, chld_intm_no,
                            iss_cd, prem_seq_no, premium_amt,
                            commission_amt, wholding_tax, user_id,
                            last_update, prev_gacc_tran_id, fund_cd,
                            branch_cd
                           )
                    VALUES (v_new_comm_rec_id, c6.intm_no, c6.chld_intm_no,
                            c6.iss_cd, c6.prem_seq_no, c6.premium_amt,
                            c6.commission_amt, c6.wholding_tax, p_user_id,
                            SYSDATE, c6.tran_id, p_fund_cd,
                            p_branch_cd
                           );
            END LOOP;                                        -- end of c6 loop

            --msg_alert('policy_id: ' ||to_char(:b140.policy_id) ,'I',false);
            FOR c3 IN (SELECT a.intrmdry_intm_no, a.iss_cd, a.policy_id,
                              a.prem_seq_no, a.peril_cd, a.premium_amt,
                              a.commission_amt, a.commission_rt,
                              a.wholding_tax
                         FROM gipi_comm_inv_peril a
                        WHERE a.policy_id = p_policy_id
                          AND a.iss_cd = cur2.iss_cd
                          AND a.prem_seq_no = cur2.prem_seq_no
                          AND a.intrmdry_intm_no = cur2.intrmdry_intm_no
                          AND NOT EXISTS (
                                 SELECT 'X'
                                   FROM giac_new_comm_inv_peril b
                                  WHERE b.iss_cd = a.iss_cd
                                    AND b.prem_seq_no = a.prem_seq_no
                                    AND fund_cd = p_fund_cd
                                    AND branch_cd = p_branch_cd
                                    AND b.intm_no = cur2.intrmdry_intm_no
                                    AND b.tran_flag = 'U'
                                    AND b.delete_sw = 'N'
                                    AND NVL (b.delete_sw, 'N') = 'N'))
            LOOP
               BEGIN
                  SELECT comm_peril_id.NEXTVAL
                    INTO v_peril_id
                    FROM SYS.DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     raise_application_error
                              (-20001,
                               'Geniisys Exception#I#No sequence comm_peril_id found in sys.dual.'
                              );
               END;

               --msg_alert('insert peril: '||to_char(v_peril_id),'I',FALSE);
               INSERT INTO giac_new_comm_inv_peril
                           (comm_rec_id, comm_peril_id,
                            intm_no, iss_cd, prem_seq_no,
                            peril_cd, premium_amt, commission_amt,
                            commission_rt, wholding_tax, tran_date,
                            tran_flag, tran_no, fund_cd, branch_cd
                           )
                    VALUES (v_new_comm_rec_id, v_peril_id,
                            c3.intrmdry_intm_no, c3.iss_cd, c3.prem_seq_no,
                            c3.peril_cd, c3.premium_amt, c3.commission_amt,
                            c3.commission_rt, c3.wholding_tax, SYSDATE,
                            'U', v_tran_no, p_fund_cd, p_branch_cd
                           );

               -- Populate GIAC_PREV_COMM_INV_PERIL. This table serves as
               -- storage for old records coming from GIPI_COMM_INV_PERIL.
               INSERT INTO giac_prev_comm_inv_peril
                           (comm_rec_id, comm_peril_id,
                            intm_no, peril_cd, premium_amt,
                            commission_amt, commission_rt,
                            wholding_tax, tran_flag, tran_no, fund_cd,
                            branch_cd
                           )
                    VALUES (v_new_comm_rec_id, v_peril_id,
                            c3.intrmdry_intm_no, c3.peril_cd, c3.premium_amt,
                            c3.commission_amt, c3.commission_rt,
                            c3.wholding_tax, 'U', v_tran_no, p_fund_cd,
                            p_branch_cd
                           );

               -- Populate GIAC_PREV_PAREN_COMM_INVPRL. This table serves as
               -- storage for old records coming from GIAC_PARENT_COMM_INVPRL.
               FOR c7 IN
                  (SELECT a.intm_no, a.chld_intm_no, a.iss_cd, a.prem_seq_no,
                          a.peril_cd, a.premium_amt, a.commission_amt,
                          a.commission_rt, a.wholding_tax, a.tran_id
                     FROM giac_parent_comm_invprl a
                    WHERE NOT EXISTS (
                             SELECT 'X'
                               FROM giac_prev_parent_comm_invprl b
                              WHERE b.iss_cd = a.iss_cd
                                AND b.prem_seq_no = a.prem_seq_no
                                AND b.chld_intm_no = a.chld_intm_no
                                AND b.intm_no = a.intm_no
                                AND b.peril_cd = a.peril_cd
                                AND fund_cd = p_fund_cd
                                AND branch_cd = p_branch_cd
                                AND b.chld_intm_no = c3.intrmdry_intm_no
                                AND b.comm_rec_id = v_new_comm_rec_id
                                AND b.comm_peril_id = v_peril_id
                                AND b.peril_cd = c3.peril_cd)
                      AND a.iss_cd = p_iss_cd
                      AND a.prem_seq_no = p_prem_seq_no
                      AND NVL (a.chld_intm_no, a.chld_intm_no) =
                                    c3.intrmdry_intm_no
                                                       -- optimization purpose
                      AND NVL (a.peril_cd, a.peril_cd) =
                                            c3.peril_cd
                                                       -- optimization purpose
                      AND a.intm_no >= 0)              -- optimization purpose
               LOOP
                  --msg_alert('prev parent peril','I',FALSE);
                  INSERT INTO giac_prev_parent_comm_invprl
                              (comm_rec_id, comm_peril_id, intm_no,
                               chld_intm_no, iss_cd, prem_seq_no,
                               peril_cd, premium_amt,
                               commission_rt, commission_amt,
                               wholding_tax, user_id, last_update,
                               fund_cd, branch_cd
                              )
                       VALUES (v_new_comm_rec_id, v_peril_id, c7.intm_no,
                               c7.chld_intm_no, c7.iss_cd, c7.prem_seq_no,
                               c7.peril_cd, c7.premium_amt,
                               c7.commission_rt, c7.commission_amt,
                               c7.wholding_tax, p_user_id, SYSDATE,
                               p_fund_cd, p_branch_cd
                              );
               END LOOP c7;                                       -- end of c7
            END LOOP c3;                                          -- end of c3
         END;
      END LOOP cur2;                                            -- end if cur2
   END;

   PROCEDURE check_bancassurance (
      p_iss_cd        IN       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   IN       gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       IN       giis_intermediary.intm_no%TYPE,
      v_banc_sw       IN OUT   gipi_polbasic.bancassurance_sw%TYPE,
      v_banc_type     IN OUT   gipi_polbasic.banc_type_cd%TYPE,
      v_fixed_tag     IN OUT   giis_banc_type_dtl.fixed_tag%TYPE,
      v_intm_type     IN OUT   giis_banc_type_dtl.intm_type%TYPE,
      v_intm_cnt      OUT      NUMBER
   )
   IS
   BEGIN
      BEGIN
         SELECT DISTINCT bancassurance_sw, banc_type_cd
                    INTO v_banc_sw, v_banc_type
                    FROM gipi_polbasic a, gipi_invoice b
                   WHERE a.policy_id = b.policy_id
                     AND b.iss_cd = p_iss_cd
                     AND b.prem_seq_no = p_prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_banc_sw := NULL;
            v_banc_type := NULL;
      END;

      BEGIN
         SELECT NVL (a.fixed_tag, 'N') fixed_tag, a.intm_type
           INTO v_fixed_tag, v_intm_type
           FROM giis_banc_type_dtl a, giis_intermediary b
          WHERE a.intm_type = b.intm_type
            AND a.banc_type_cd = v_banc_type
            AND b.intm_no = p_intm_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_fixed_tag := 'N';
            v_intm_type := NULL;
      END;

      BEGIN
         SELECT COUNT (*)
           INTO v_intm_cnt
           FROM giis_intermediary
          WHERE intm_type = v_intm_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_intm_cnt := 0;
      END;
   END;

   PROCEDURE validate_inv_comm_share (
      p_fund_cd            IN       giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd          IN       giac_new_comm_inv.branch_cd%TYPE,
      p_comm_rec_id        IN       giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_no            IN       giac_new_comm_inv.intm_no%TYPE,
      p_prem_seq_no        IN       giac_new_comm_inv.prem_seq_no%TYPE,
      p_iss_cd             IN       giac_new_comm_inv.iss_cd%TYPE,
      p_current_tot_share  IN       NUMBER,
      p_share_percentage   IN OUT   giac_new_comm_inv.share_percentage%TYPE,
      v_message            OUT      VARCHAR2
   )
   IS
      v_sum_share_percentage  giac_new_comm_inv.share_percentage%TYPE;
      v_old_share_percentage  giac_new_comm_inv.share_percentage%TYPE;
      v_share_percentage      giis_banc_type_dtl.share_percentage%TYPE;
      v_banc_sw                  gipi_polbasic.bancassurance_sw%TYPE;   -- if policy is bancassurance
      v_banc_type              gipi_polbasic.banc_type_cd%TYPE;       -- type of bancassurance  
      v_fixed_tag              giis_banc_type_dtl.fixed_tag%TYPE;     -- if intermediary cannot be changed
      v_intm_type              giis_banc_type_dtl.intm_type%TYPE ;    -- intm type of the original intermediary
      v_intm_cnt              NUMBER;

   BEGIN
      IF NVL (giisp.v ('ORA2010_SW'), 'N') = 'Y'
      THEN
         GIACS408_PKG.check_bancassurance(p_iss_cd, p_prem_seq_no, p_intm_no, v_banc_sw, v_banc_type, v_fixed_tag, v_intm_type, v_intm_cnt);

         IF (v_banc_sw = 'N' OR v_banc_sw IS NULL)
         THEN
            BEGIN
               SELECT share_percentage
                 INTO v_old_share_percentage
                 FROM giac_new_comm_inv
                WHERE fund_cd = p_fund_cd
                  AND branch_cd = p_branch_cd
                  AND comm_rec_id = p_comm_rec_id
                  AND intm_no = p_intm_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_old_share_percentage := 0;
            END;

            /*SELECT NVL (SUM (share_percentage), 0) - v_old_share_percentage
              INTO v_sum_share_percentage
              FROM giac_new_comm_inv
             WHERE prem_seq_no = p_prem_seq_no
               AND iss_cd = p_iss_cd
               AND branch_cd = p_branch_cd
               AND fund_cd = p_fund_cd
               AND NVL (delete_sw, 'N') = 'N'
               AND tran_flag = 'U';*/ -- replaced with codes below, to compute correctly if there are changes not yet saved : shan 02.09.2015
            
            v_sum_share_percentage := p_current_tot_share;   
                        
            IF v_sum_share_percentage + p_share_percentage > 100
            THEN
               v_message := 'Sum of Share Percentage cannot exceed 100%.';
               p_share_percentage  := null;
            END IF;
         ELSE
            SELECT share_percentage
              INTO v_share_percentage
              FROM giis_banc_type_dtl
             WHERE intm_type = v_intm_type
               AND banc_type_cd = v_banc_type;

            IF p_share_percentage != v_share_percentage
            THEN
              v_message := 'Share Percentage should be equal to'
                          || ' '
                          || v_share_percentage
                          || '%.';
               p_share_percentage := v_share_percentage;
            END IF;
         END IF;
      END IF;
   END; --validate_inv_comm_sharepercenatge 
   
   FUNCTION get_invoice_comm_history (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN inv_comm_history_list_tab PIPELINED
   IS
      v_list   inv_comm_history_list_type;
   BEGIN
      FOR i IN (SELECT b.iss_cd, b.prem_seq_no, a.intm_no, a.commission_amt, a.wholding_tax,
                       b.intm_no intm_no2, b.commission_amt commission_amt2,
                       b.wholding_tax wholding_tax2, b.tran_flag tran_flag2,
                       b.delete_sw delete_sw2, b.post_date post_date2,
                       b.posted_by posted_by2, b.user_id user_id2
                  FROM giac_prev_comm_inv a, 
                       giac_new_comm_inv b
                 WHERE a.comm_rec_id = b.comm_rec_id
                   AND b.iss_cd = p_iss_cd--AND a.iss_cd = p_iss_cd --added alias to prevent ORA-00918 by MAC 11/06/2013 --koks 3.25.14 chage a.iss_Cd to b.iss_cd
                   AND b.prem_seq_no = p_prem_seq_no)--AND a.prem_seq_no = p_prem_seq_no) --added alias to prevent ORA-00918 by MAC 11/06/2013 --koks 3.25.14
      LOOP
         v_list.iss_cd          := i.iss_cd;
         v_list.prem_seq_no     := i.prem_seq_no;
         v_list.intm_no         := i.intm_no;
         v_list.commission_amt  := i.commission_amt;
         v_list.wholding_tax    := i.wholding_tax;
         v_list.intm_no2        := i.intm_no2;
         v_list.commission_amt2 := i.commission_amt2;
         v_list.wholding_tax2   := i.wholding_tax2;
         v_list.tran_flag2      := i.tran_flag2;
         v_list.delete_sw2      := i.delete_sw2;
         v_list.post_date2      := i.post_date2;
         v_list.posted_by2      := i.posted_by2;
         v_list.user_id2        := i.user_id2;
         
         SELECT intm_name
              INTO v_list.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
             
         SELECT intm_name
              INTO v_list.intm_name2
              FROM giis_intermediary
             WHERE intm_no = i.intm_no2;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   FUNCTION get_obj_insert_update_invperl (
      p_record_status  VARCHAR2,
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE,
      p_prem_amt       gipi_invoice.prem_amt%TYPE,  --b140.prem_amt
      p_premium_amt    giac_new_comm_inv.PREMIUM_AMT%TYPE, --gnci.premium_amt
      --p_wtax_rate      giis_intermediary.wtax_rate%TYPE, --gnci.nbt_wtax_rate
      p_intm_no        giac_new_comm_inv.INTM_NO%TYPE, --:gnci.intm_no
      --p_commission_rt  giac_new_comm_inv_peril.commission_rt%TYPE --for update only
      p_policy_id      gipi_polbasic.policy_id%TYPE
   )
      RETURN obj_insert_update_invperl_tab PIPELINED
   IS
      gncp                  obj_insert_update_invperl_type;
      v_percent             NUMBER;
   BEGIN   
      IF p_record_status = 0 THEN --for insert of new record
          FOR inv IN (SELECT a.peril_cd, a.prem_amt, b.peril_name
                        FROM gipi_invperil a,
                             giis_peril    b 
                       WHERE b.peril_cd    = a.peril_cd
                         AND b.line_cd     = p_line_cd
                         AND iss_cd        = p_iss_cd
                         AND prem_seq_no   = p_prem_seq_no)
          LOOP
             SELECT comm_peril_id.NEXTVAL 
               INTO gncp.comm_peril_id
               FROM DUAL;
             v_percent            := inv.prem_amt / p_prem_amt; --:b140.prem_amt
             gncp.peril_cd        := inv.peril_cd;
             gncp.dsp_peril_name  := inv.peril_name; 
             gncp.premium_amt     := ROUND(p_premium_amt * v_percent,2); --gnci.premium_amt
             --gncp.commission_rt   := get_intm_rate(p_intm_no, p_line_cd, p_iss_cd, inv.peril_cd);
             gncp.commission_rt   := get_intm_rate_giacs408(inv.peril_cd, p_intm_no, p_line_cd, p_subline_cd, p_iss_cd, p_policy_id);
             --gncp.commission_amt  := ROUND(gncp.premium_amt * (gncp.commission_rt / 100), 2);
             --gncp.wholding_tax    := ROUND(gncp.commission_amt * p_wtax_rate); --gnci.nbt_wtax_rate
             PIPE ROW (gncp);     
          END LOOP;
          
      ELSE  --for update record
          FOR inv IN (SELECT a.peril_cd, a.prem_amt, b.peril_name
                        FROM gipi_invperil a,
                             giis_peril    b 
                       WHERE b.peril_cd    = a.peril_cd
                         AND b.line_cd     = p_line_cd
                         AND iss_cd        = p_iss_cd
                         AND prem_seq_no   = p_prem_seq_no)
          LOOP
             v_percent            := inv.prem_amt / p_prem_amt; --:b140.prem_amt
             gncp.peril_cd        := inv.peril_cd;
             gncp.dsp_peril_name  := inv.peril_name; 
             gncp.premium_amt     := ROUND(p_premium_amt * v_percent, 2); --gnci.premium_amt
             --gncp.commission_amt  := ROUND(gncp.premium_amt * (p_commission_rt / 100), 2);
             --gncp.wholding_tax    := ROUND(gncp.commission_amt * p_wtax_rate, 2); --gnci.nbt_wtax_rate
             PIPE ROW (gncp);                   
          END LOOP;
      END IF;
   END;
   
   FUNCTION get_giacs408_intm_lov(
      p_iss_cd         gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE,
      p_fund_cd        giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd      giac_new_comm_inv.branch_cd%TYPE
   )
      RETURN giacs408_intm_lov_tab PIPELINED
   IS
      v_banc_sw                  gipi_polbasic.bancassurance_sw%TYPE;   -- if policy is bancassurance
      v_banc_type              gipi_polbasic.banc_type_cd%TYPE;       -- type of bancassurance  
      v_fixed_tag              giis_banc_type_dtl.fixed_tag%TYPE;     -- if intermediary cannot be changed
      v_intm_type              giis_banc_type_dtl.intm_type%TYPE ;    -- intm type of the original intermediary
      v_intm_cnt              NUMBER;
      v_lov_id                VARCHAR2 (100);
      v_stmnt_str             VARCHAR2 (3000); 
      p_intm_type             VARCHAR2 (3000); 
      v_list                  giacs408_intm_lov_type;
      p_comm_rec_no           NUMBER := null;
   BEGIN
      IF NVL(GIISP.V('ORA2010_SW'),'N') = 'Y' THEN   -- specific enh
        check_bancassurance(p_iss_cd, p_prem_seq_no, null, v_banc_sw, v_banc_type, v_fixed_tag, v_intm_type, v_intm_cnt);
        IF (v_banc_sw = 'N' OR v_banc_sw IS NULL) THEN
            v_lov_id := 'CGFK$GNCI_INTM_NO';   -- for ordinary policy
          
        ELSIF v_banc_sw = 'Y' THEN
            p_intm_type := null;
              FOR I IN (SELECT ''''||b.intm_type||'''' intm_type 
                          FROM GIAC_NEW_COMM_INV a,GIIS_INTERMEDIARY b
                       WHERE a.iss_cd =  p_iss_cd--'AN'
                         AND a.prem_seq_no = p_prem_seq_no--435
                         AND a.intm_no = b.intm_no
                         AND b.intm_type  NOT IN (SELECT DISTINCT Get_Intm_Type(a.intm_no)intm_type 
                                                    FROM GIAC_NEW_COMM_INV a
                                                   WHERE delete_sw ='N'
                                                     AND a.tran_flag ='U'
                                                     AND a.iss_cd = p_iss_cd
                                                     AND a.prem_seq_no = p_prem_seq_no)
                                                     AND intm_type IN (SELECT intm_type FROM GIIS_BANC_TYPE_DTL
                                                                        WHERE fixed_tag ='N'
                                                                          AND a.tran_flag ='U'
                                                                          AND banc_type_cd = v_banc_type))
            LOOP
                IF     p_intm_type IS NULL THEN
                    p_intm_type:=I.INTM_TYPE;
                ELSE
                    p_intm_type:= p_intm_type||','||I.INTM_TYPE;
                END IF;
                EXIT;
            END LOOP;   
            
            v_lov_id := 'BANC_INTM_RG';        -- for bancassurance policy*/                
                  
        END IF;  
      ELSE
            v_lov_id := 'CGFK$GNCI_INTM_NO';      
      END IF; 
      
      IF v_lov_id = 'BANC_INTM_RG' THEN
        FOR i IN(SELECT a.intm_no intm_no, a.intm_name dsp_intm_name,
                        a.intm_type dsp_intm_type
                   FROM giis_intermediary a
                  WHERE INSTR (p_intm_type, a.intm_type, 1) > 0
               ORDER BY a.intm_name)
        LOOP
            v_list.intm_no := i.intm_no;
            v_list.dsp_intm_name := i.dsp_intm_name;
            v_list.dsp_intm_type := i.dsp_intm_type;
            
            BEGIN
                SELECT intm_name,
                       NVL(wtax_rate, 0.0) / 100.0
                  INTO v_list.dsp_intm_name,
                       v_list.nbt_wtax_rate
                  FROM giis_intermediary
                 WHERE intm_no = v_list.intm_no;
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    raise_application_error(-20001,'Geniisys Exception#I#Intermediary No. does not exist in Giis_Intermediary.');
            END;

            BEGIN -- populate :gnci.prnt_intmdry
              SELECT a100.intm_name
                INTO v_list.prnt_intmdry
                FROM giis_intermediary a100
               WHERE a100.intm_no = (SELECT b100.parent_intm_no
                                         FROM giis_intermediary b100
                                        WHERE b100.intm_no = v_list.intm_no);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_list.prnt_intmdry := v_list.dsp_intm_name;
            END; -- populate :gnci.prnt_intmdry 
            PIPE ROW(v_list);
        END LOOP;
              
      ELSIF v_lov_id = 'CGFK$GNCI_INTM_NO' THEN
        
        FOR i IN(SELECT a.intm_no intm_no, a.intm_name dsp_intm_name,
                        a.intm_type dsp_intm_type
                   FROM giis_intermediary a
                  WHERE NOT EXISTS (SELECT 'X'
                                      FROM giac_new_comm_inv b
                                     WHERE b.intm_no = a.intm_no
                                       AND comm_rec_id = p_comm_rec_no
                                       AND fund_cd = p_fund_cd
                                       AND branch_cd = p_branch_cd))
        LOOP
            v_list.intm_no := i.intm_no;
            v_list.dsp_intm_name := i.dsp_intm_name;
            v_list.dsp_intm_type := i.dsp_intm_type;
            
            BEGIN
                SELECT intm_name,
                       NVL(wtax_rate, 0.0) / 100.0
                  INTO v_list.dsp_intm_name,
                       v_list.nbt_wtax_rate
                  FROM giis_intermediary
                 WHERE intm_no = v_list.intm_no;
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    raise_application_error(-20001,'Geniisys Exception#I#Intermediary No. does not exist in Giis_Intermediary.');
            END;

            BEGIN -- populate :gnci.prnt_intmdry
              SELECT a100.intm_name
                INTO v_list.prnt_intmdry
                FROM giis_intermediary a100
               WHERE a100.intm_no = (SELECT b100.parent_intm_no
                                         FROM giis_intermediary b100
                                        WHERE b100.intm_no = v_list.intm_no);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_list.prnt_intmdry := v_list.dsp_intm_name;
            END; -- populate :gnci.prnt_intmdry 
            PIPE ROW(v_list);
        END LOOP; 
      END IF;
        
       
   END;
   
   PROCEDURE validate_peril_commission_rt(
      p_fund_cd         IN      GIAC_NEW_COMM_INV_PERIL.fund_cd%TYPE,
      p_branch_cd       IN      GIAC_NEW_COMM_INV_PERIL.branch_cd%TYPE,
      p_comm_rec_id     IN      GIAC_NEW_COMM_INV_PERIL.comm_rec_id%TYPE,
      p_intm_no         IN      GIAC_NEW_COMM_INV_PERIL.intm_no%TYPE,
      p_comm_peril_id   IN      GIAC_NEW_COMM_INV_PERIL.comm_peril_id%TYPE,
      p_comm_paid       IN      VARCHAR2,
      p_commission_rt   IN OUT  GIAC_NEW_COMM_INV_PERIL.commission_rt%TYPE,
      p_message         OUT     VARCHAR2,
      p_line_cd         IN      giis_line.line_cd%TYPE,   --Deo [03.07.2017]: add start (SR-5944)
      p_subline_cd      IN      giis_subline.subline_cd%TYPE,
      p_iss_cd          IN      giis_issource.iss_cd%TYPE,
      p_peril_cd        IN      giis_peril.peril_cd%TYPE  --Deo [03.07.2017]: add ends (SR-5944)
   )
   IS
      v_comm_rate   giac_new_comm_inv_peril.commission_rt%type := 0;
      --Deo [03.07.2017]: add starts (SR-5944)
      v_parent_intm_no        giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag               giis_intermediary.lic_tag%TYPE;
      v_special_rate          giis_intermediary.special_rate%TYPE;
      v_intm_type             giis_intermediary.intm_type%TYPE;
      v_override_comm_rate    giis_spl_override_rt.comm_rate%TYPE;
      v_special_comm_rate     giis_intm_special_rate.rate%TYPE;
      v_intm_type_comm_rate   giis_intmdry_type_rt.comm_rate%TYPE;
      v_override_tag          giis_intm_special_rate.override_tag%TYPE;
      --Deo [03.07.2017]: add ends (SR-5944)
   BEGIN
       FOR get_rt IN (SELECT commission_rt 
                        --FROM giac_new_comm_inv_peril
                        FROM giac_prev_comm_inv_peril --added by steven 11.05.2014
                       WHERE fund_cd        = p_fund_cd
                         AND branch_cd      = p_branch_cd
                         AND comm_rec_id    = p_comm_rec_id
                         AND intm_no        = p_intm_no
                         AND comm_peril_id  = p_comm_peril_id)
      LOOP
        v_comm_rate := get_rt.commission_rt;
      END LOOP;    
     
--      IF :gncp.commission_rt < 0.0 OR :gncp.commission_rt > 100.0 THEN
--        msg_alert('You entered an invalid rate. Please try again.','I',TRUE);
      IF p_comm_paid = 'Y' AND p_commission_rt < v_comm_rate THEN
         p_commission_rt := v_comm_rate;
         p_message := 'New rate for invoice with existing commission payment transactions must not be less than the original rate.';
      END IF;
      
      --Deo [03.07.2017]: add starts (SR-5944)
      IF p_message IS NULL
      THEN
         SELECT parent_intm_no, lic_tag, special_rate, intm_type
           INTO v_parent_intm_no, v_lic_tag, v_special_rate, v_intm_type
           FROM giis_intermediary
          WHERE intm_no = p_intm_no;

         IF v_lic_tag = 'N'
         THEN
            BEGIN
               SELECT comm_rate
                 INTO v_override_comm_rate
                 FROM giis_spl_override_rt
                WHERE intm_no = v_parent_intm_no
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND peril_cd = p_peril_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_override_comm_rate := NULL;
            END;
         END IF;

         IF v_special_rate = 'Y'
         THEN
            BEGIN
               SELECT rate, override_tag
                 INTO v_special_comm_rate, v_override_tag
                 FROM giis_intm_special_rate
                WHERE intm_no = p_intm_no
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND peril_cd = p_peril_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_special_comm_rate := NULL;
                  v_override_tag := NULL;
            END;
         END IF;

         IF v_special_comm_rate IS NULL
         THEN
            BEGIN
               SELECT comm_rate
                 INTO v_intm_type_comm_rate
                 FROM giis_intmdry_type_rt
                WHERE intm_type = v_intm_type
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND peril_cd = p_peril_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_intm_type_comm_rate := NULL;
            END;
         END IF;

         IF v_lic_tag = 'Y'
         THEN
            IF     v_special_rate = 'Y'
               AND p_commission_rt <
                              NVL (v_special_comm_rate, v_intm_type_comm_rate)
            THEN
               p_message :=
                     'Commission Rate is lower than the Computed Commission Rate of '
                  || NVL (v_special_comm_rate, v_intm_type_comm_rate)
                  || '%.';
            ELSIF v_special_rate = 'N' AND p_commission_rt < v_intm_type_comm_rate
            THEN
               p_message :=
                     'Commission Rate is lower than the Computed Commission Rate of '
                  || v_intm_type_comm_rate
                  || '%.';
            END IF;
         ELSIF v_lic_tag = 'N'
         THEN
            IF     v_special_rate = 'Y'
               AND v_override_tag = 'Y'
               AND p_commission_rt < v_override_comm_rate
            THEN
               p_message :=
                     'Error#Commission Rate is lower than the Overriding Commission Rate of '
                  || v_override_comm_rate
                  || '%.';
            ELSIF     v_special_rate = 'Y'
                  AND NVL (v_override_tag, 'N') != 'Y'
                  AND p_commission_rt <
                              NVL (v_special_comm_rate, v_intm_type_comm_rate)
            THEN
               p_message :=
                     'Commission Rate is lower than the Computed Commission Rate of '
                  || NVL (v_special_comm_rate, v_intm_type_comm_rate)
                  || '%.';
            ELSIF     v_special_rate = 'Y'
                  AND v_override_tag = 'Y'
                  AND p_commission_rt <
                                 (v_special_comm_rate + v_override_comm_rate
                                 )
            THEN
               p_message :=
                     'Commission Rate is lower than the Computed Commission Rate of '
                  || (v_special_comm_rate + v_override_comm_rate)
                  || '%.';
            ELSIF v_special_rate = 'N' AND p_commission_rt < v_intm_type_comm_rate
            THEN
               p_message :=
                     'Commission Rate is lower than the Computed Commission Rate of '
                  || v_intm_type_comm_rate
                  || '%.';
            END IF;
         END IF;
      END IF;
      --Deo [03.07.2017]: add ends (SR-5944)
   END;
   
   FUNCTION RECOMPUTE_COMM_RATE(
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_policy_id       gipi_invoice.policy_id%TYPE,
      p_intm_no         giac_new_comm_inv_peril.intm_no%TYPE, 
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_peril_cd        giac_new_comm_inv_peril.peril_cd%TYPE   
   )
      RETURN NUMBER
   IS
      v_banc_sw            gipi_polbasic.bancassurance_sw%TYPE;
      v_commission_rt   giac_new_comm_inv_peril.commission_rt%TYPE;
   BEGIN
        BEGIN
          SELECT DISTINCT bancassurance_sw
            INTO v_banc_sw
            FROM gipi_polbasic a, gipi_invoice b 
           WHERE a.policy_id = b.policy_id
             AND b.iss_cd = p_iss_cd
             AND b.prem_seq_no = p_prem_seq_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_banc_sw := NULL;
        END;
      
        IF v_banc_sw ='Y' THEN  
           SELECT rate INTO v_commission_rt FROM giis_banc_type
            WHERE banc_type_cd = (SELECT banc_type_cd FROM gipi_polbasic
                                   WHERE policy_id = p_policy_id);
        ELSE
          v_commission_rt   := get_intm_rate_giacs408(p_peril_cd, p_intm_no, p_line_cd, p_subline_cd, p_iss_cd, p_policy_id);
        END IF; 
        
        RETURN v_commission_rt;
   END RECOMPUTE_COMM_RATE; 
   
   FUNCTION RECOMPUTE_WTAX_RATE(
      p_intm_no       giac_new_comm_inv_peril.intm_no%TYPE
   )
      RETURN NUMBER
   IS
      v_wtax_rate     NUMBER(7,5); --change by steven 11.04.2014--giis_intermediary.wtax_rate%TYPE,
   BEGIN
      BEGIN
        SELECT NVL(wtax_rate, 0.0) / 100.0
          INTO v_wtax_rate
          FROM giis_intermediary
         WHERE intm_no = p_intm_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#I#No record of intermediary in Giis_Intermediary.');
      END;
      RETURN v_wtax_rate;
   END RECOMPUTE_WTAX_RATE;
  
  PROCEDURE CANCEL_INVOICE_COMMISSION(
    p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
    p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
    p_branch_cd             giac_new_comm_inv.branch_cd%TYPE
  )
  IS
  
  BEGIN
    UPDATE giac_new_comm_inv
     SET tran_flag   = 'C'
   WHERE 1=1 --iss_cd      = :b140.iss_cd 
     AND comm_rec_id = p_comm_rec_id --prem_seq_no = :b140.prem_seq_no
     AND fund_cd     = p_fund_cd
     AND branch_cd   = p_branch_cd;
 
  UPDATE giac_new_comm_inv_peril
     SET tran_flag   = 'C'
   WHERE 1=1 --iss_cd      = :b140.iss_cd 
     AND comm_rec_id = p_comm_rec_id --prem_seq_no = :b140.prem_seq_no
     AND fund_cd     = p_fund_cd
     AND branch_cd   = p_branch_cd;

  UPDATE giac_prev_comm_inv
     SET tran_flag   = 'C'
   WHERE 1 = 1
     AND comm_rec_id = p_comm_rec_id
     AND fund_cd     = p_fund_cd
     AND branch_cd   = p_branch_cd;

  UPDATE giac_prev_comm_inv_peril
     SET tran_flag = 'C'
   WHERE 1 = 1
     AND comm_rec_id = p_comm_rec_id
     AND fund_cd     = p_fund_cd
     AND branch_cd   = p_branch_cd;
  END;
  
  PROCEDURE UPDATE_COMM_INVOICE(
    p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
    p_branch_cd             giac_new_comm_inv.branch_cd%TYPE,
    p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
    p_intm_no               giac_new_comm_inv.intm_no%TYPE,
    p_iss_cd                giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no           giac_new_comm_inv.prem_seq_no%TYPE,
    p_policy_id             giac_new_comm_inv.policy_id%TYPE,
    p_share_percentage      giac_new_comm_inv.share_percentage%TYPE,
    p_premium_amt           giac_new_comm_inv.premium_amt%TYPE,
    p_commission_amt        giac_new_comm_inv.commission_amt%TYPE,
    p_wholding_tax          giac_new_comm_inv.wholding_tax%TYPE,
    p_tran_date             giac_new_comm_inv.tran_date%TYPE,
    p_tran_flag             giac_new_comm_inv.tran_flag%TYPE,
    p_tran_no               giac_new_comm_inv.tran_no%TYPE,
    p_delete_sw             giac_new_comm_inv.delete_sw%TYPE,
    p_remarks               giac_new_comm_inv.remarks%TYPE,
    p_user_id               giac_new_comm_inv.user_id%TYPE
  )
  IS
    v_posted_tran           giac_new_comm_inv.tran_no%TYPE;             --nieko 07272016 KB 3753, SR 22780
    v_share_pct             giac_new_comm_inv.share_percentage%TYPE;    --nieko 07272016 KB 3753, SR 22780
  BEGIN
       --nieko 07272016 KB 3753, SR 22780
       BEGIN
            SELECT COUNT (*)
              INTO v_posted_tran
              FROM giac_new_comm_inv
             WHERE fund_cd = p_fund_cd
               AND branch_cd = p_branch_cd
               AND tran_no = p_tran_no
               AND comm_rec_id = p_comm_rec_id
               AND tran_flag = 'P';
               
             IF v_posted_tran > 0 THEN
                raise_application_error(-20001,'Geniisys Exception#I#Modify commission transaction number already posted.');   
             END IF;
       END;
       --nieko 07272016 end
  
       MERGE INTO giac_new_comm_inv
          USING DUAL
          ON (    1 = 1
              AND fund_cd = p_fund_cd
              AND branch_cd = p_branch_cd
              AND comm_rec_id = p_comm_rec_id
              AND intm_no = p_intm_no)
          WHEN NOT MATCHED THEN
             INSERT (fund_cd, branch_cd, comm_rec_id, intm_no, iss_cd,
                     prem_seq_no, policy_id, share_percentage, premium_amt,
                     commission_amt, wholding_tax, tran_date, tran_flag, tran_no,
                     delete_sw, remarks, user_id, create_date)--added by steven 10.21.2014
             VALUES (p_fund_cd, p_branch_cd, p_comm_rec_id, p_intm_no, p_iss_cd,
                     p_prem_seq_no, p_policy_id, p_share_percentage,p_premium_amt,
                     p_commission_amt, p_wholding_tax, SYSDATE,p_tran_flag, p_tran_no, 
                     'N', p_remarks, p_user_id, SYSDATE) --added by steven 10.21.2014
          WHEN MATCHED THEN
             UPDATE
                SET share_percentage = p_share_percentage,
                    premium_amt = p_premium_amt, 
                    commission_amt = p_commission_amt,
                    wholding_tax = p_wholding_tax, delete_sw = 'N',
                    remarks = p_remarks, user_id = p_user_id,
                    create_date = SYSDATE --added by steven 10.21.2014
             ;
  END;
  
  PROCEDURE UPDATE_COMM_INVOICE_PERIL(
    p_fund_cd               giac_new_comm_inv_peril.fund_cd%TYPE,
    p_branch_cd             giac_new_comm_inv_peril.branch_cd%TYPE,
    p_comm_rec_id           giac_new_comm_inv_peril.comm_rec_id%TYPE,
    p_intm_no               giac_new_comm_inv_peril.intm_no%TYPE,
    p_comm_peril_id         giac_new_comm_inv_peril.comm_peril_id%TYPE,
    p_premium_amt           giac_new_comm_inv_peril.premium_amt%TYPE,
    p_commission_rt         giac_new_comm_inv_peril.commission_rt%TYPE,
    p_commission_amt        giac_new_comm_inv_peril.commission_amt%TYPE,
    p_wholding_tax          giac_new_comm_inv_peril.wholding_tax%TYPE,
    p_delete_sw             giac_new_comm_inv_peril.delete_sw%TYPE,
    p_tran_no               giac_new_comm_inv_peril.tran_no%TYPE,
    p_tran_flag             giac_new_comm_inv_peril.tran_flag%TYPE,
    p_peril_cd              giac_new_comm_inv_peril.peril_cd%TYPE,
    p_prem_seq_no           giac_new_comm_inv_peril.prem_seq_no%TYPE,
    p_iss_cd                giac_new_comm_inv_peril.iss_cd%TYPE
  )
  IS
     v_tran_date DATE;
   BEGIN
      SELECT tran_date
        INTO v_tran_date
        FROM giac_new_comm_inv
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND intm_no       = p_intm_no;

      MERGE INTO giac_new_comm_inv_peril
         USING DUAL
            ON (1=1
                AND fund_cd       = p_fund_cd
                AND branch_cd     = p_branch_cd
                AND comm_rec_id   = p_comm_rec_id
                AND intm_no       = p_intm_no
                AND comm_peril_id = p_comm_peril_id)
         WHEN NOT MATCHED THEN
            INSERT(fund_cd, branch_cd, comm_rec_id, intm_no, comm_peril_id,
                   iss_cd, prem_seq_no, peril_cd, premium_amt, commission_amt,
                   commission_rt, wholding_tax, tran_date, tran_flag,
                   delete_sw, tran_no)
            VALUES(p_fund_cd, p_branch_cd, p_comm_rec_id, p_intm_no, p_comm_peril_id,
                   p_iss_cd, p_prem_seq_no, p_peril_cd, p_premium_amt, p_commission_amt,
                   p_commission_rt, p_wholding_tax, v_tran_date, p_tran_flag,
                   p_delete_sw, p_tran_no)
         WHEN MATCHED THEN
            UPDATE
               SET premium_amt = p_premium_amt,
                   commission_amt = p_commission_amt,
                   commission_rt = p_commission_rt,
                   wholding_tax = p_wholding_tax,
                   tran_date = v_tran_date,
                   tran_flag = p_tran_flag,
                   delete_sw = p_delete_sw,
                   tran_no = p_tran_no;
  END;
  
  PROCEDURE KEY_COMMIT_GIACS408(
    p_iss_cd       gipi_invoice.iss_cd%TYPE,
    p_prem_seq_no  gipi_invoice.prem_seq_no%TYPE,
    p_fund_cd      giac_prev_comm_inv.fund_cd%TYPE,
    p_branch_cd    giac_prev_comm_inv.branch_cd%TYPE
  )
  IS
    v_acct_date     giac_prev_comm_inv.acct_ent_date%TYPE; 
  
  BEGIN
      FOR i in (SELECT b.acct_ent_date acct
                  FROM gipi_polbasic a, gipi_invoice b
                 WHERE a.policy_id   = b.policy_id
                   AND a.iss_cd      = b.iss_cd
                   AND b.iss_cd      = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no)
      LOOP
        v_acct_date := i.acct;
      END LOOP;
      
      UPDATE giac_prev_comm_inv
         SET acct_ent_date = v_acct_date
       WHERE fund_cd     = p_fund_cd
         AND branch_cd   = p_branch_cd
         AND comm_rec_id IN (SELECT comm_rec_id 
                               FROM giac_new_comm_inv a
                              WHERE a.iss_cd      = p_iss_cd
                                AND a.prem_seq_no = p_prem_seq_no
                                AND fund_cd       = p_fund_cd
                                AND branch_cd     = p_branch_cd);  
  END;
  
  PROCEDURE CHECK_INV_PAYT(
    p_iss_cd         IN     giac_comm_payts.iss_cd%TYPE,   
    p_prem_seq_no    IN     giac_comm_payts.prem_seq_no%TYPE,
    p_intm_no        IN     giac_comm_payts.intm_no%TYPE,
    p_message        OUT    VARCHAR2
  )
  IS
    v_comm_amt  NUMBER := 0;
  BEGIN
    BEGIN
        SELECT NVL(SUM(a.comm_amt),0) comm_amt
            INTO v_comm_amt
            FROM giac_comm_payts a,
                 giac_acctrans b
         WHERE 1 = 1
             AND a.gacc_tran_id = b.tran_id
             AND a.iss_cd       = p_iss_cd
             AND a.prem_seq_no  = p_prem_seq_no
             AND a.intm_no = p_intm_no  --added by mikel 10.16.2012; checking of payments should be per intermediary   
         AND NOT EXISTS(SELECT c.gacc_tran_id
                          FROM giac_reversals c,
                               giac_acctrans  d
                         WHERE c.reversing_tran_id = d.tran_id
                           AND d.tran_flag <> 'D'
                           AND c.gacc_tran_id = a.gacc_tran_id)  
         AND b.tran_flag <> 'D';

        IF v_comm_amt <> 0 THEN      
            p_message := 'Modification of intermediary is not allowed. Commission payment transaction(s) already exists for this invoice.';
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            p_message := NULL;                    
    END;   
  END;
  
  PROCEDURE CHECK_RECORD(
    p_iss_cd        IN      GIPI_INVOICE.iss_cd%TYPE,    
    p_prem_seq_no   IN      GIPI_INVOICE.prem_seq_no%TYPE,
    v_allow_coi     OUT     VARCHAR2,
    v_record        OUT     VARCHAR2
  ) 
  IS
    --v_record VARCHAR2(100);
  
  BEGIN           
      FOR rec IN (SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd ||'-'||a.clm_yy ||'-'|| a.clm_seq_no claims
                    FROM GICL_CLAIMS a, GIPI_POLBASIC b, GIPI_INVOICE c
                   WHERE 1=1
                     AND b.LINE_CD = a.LINE_CD
                     AND b.SUBLINE_CD = a.SUBLINE_CD
                     AND b.ISS_CD = a.ISS_CD
                     AND b.ISSUE_YY = a.ISSUE_YY
                     AND b.POL_SEQ_NO = a.POL_SEQ_NO
                     AND b.RENEW_NO = a.RENEW_NO
                     AND b.POLICY_ID = c.POLICY_ID
                     AND c.ISS_CD = P_ISS_CD
                     AND c.PREM_SEQ_NO = P_PREM_SEQ_NO 
                     AND a.CLM_STAT_CD NOT IN ('CD','CC','DN','WD'))                
      LOOP
        v_record := rec.claims;
      END LOOP;

      IF v_record is not null  THEN  
        v_allow_coi := giacp.v('ALLOW_COI_ON_POLICY_W_CLAIM');        
      END IF;
  END;
  
  PROCEDURE KEY_DEL_REC_GIACS408(
    p_iss_cd             IN       giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no        IN       giac_new_comm_inv.prem_seq_no%TYPE,
    p_intm_no            IN       giac_new_comm_inv.intm_no%TYPE,
    v_message            OUT      VARCHAR2
  )
  IS
    v_banc_sw              gipi_polbasic.bancassurance_sw%TYPE;   -- if policy is bancassurance
    v_banc_type              gipi_polbasic.banc_type_cd%TYPE;       -- type of bancassurance  
    v_fixed_tag              giis_banc_type_dtl.fixed_tag%TYPE;     -- if intermediary cannot be changed
    v_intm_type              giis_banc_type_dtl.intm_type%TYPE ;    -- intm type of the original intermediary
    v_intm_cnt            NUMBER;

      
  BEGIN
    IF NVL(Giisp.v('ORA2010_SW'),'N') = 'Y' THEN  
          GIACS408_PKG.check_bancassurance(p_iss_cd, p_prem_seq_no, p_intm_no, v_banc_sw, v_banc_type, v_fixed_tag, v_intm_type, v_intm_cnt);
          --:parameter.p_intm_type := v_intm_type;

        IF v_banc_sw ='Y' then
              v_message := 'Intermediary cannot be changed. Please click on Bancassurance Details button';
          END IF;
        
          IF v_fixed_tag = 'Y' THEN
                v_message := 'Intermediary cannot be changed.  Intermediary is fixed for this bancassurance policy.';
          ELSIF v_fixed_tag = 'N' AND v_intm_cnt = 1 THEN
               v_message := 'This type of intermediary has only one record.';
          --ELSIF variables.v_fixed_tag = 'N' THEN       
           --delete_sw := 'Y';
          END IF;
    --ELSE
        --delete_sw := 'Y';
      END IF;
  END;
  
  FUNCTION get_giis_banc_type(
     p_policy_id            gipi_polbasic.policy_id%TYPE
  )
     RETURN giis_banc_type_tab PIPELINED
  IS
     v_list   giis_banc_type_type;
  BEGIN
      FOR i IN (SELECT banc_type_cd, banc_type_desc, rate, user_id, last_update
                  FROM GIIS_BANC_TYPE
                 WHERE banc_type_cd in (SELECT banc_type_cd 
                                          FROM gipi_polbasic 
                                         WHERE policy_id = p_policy_id))
      LOOP
         v_list.banc_type_cd    := i.banc_type_cd;
         v_list.banc_type_desc  := i.banc_type_desc;
         v_list.rate            := i.rate;
         v_list.user_id         := i.user_id;
         v_list.last_update     := i.last_update;
         
         PIPE ROW (v_list);
      END LOOP;
  END;
  
  FUNCTION get_giis_banc_type_dtl(
     p_policy_id         gipi_polbasic.policy_id%TYPE,
     p_v_mod_btyp        VARCHAR2,
     p_iss_cd            giac_new_comm_inv.iss_cd%TYPE,
     p_prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE
  )
     RETURN giis_banc_type_dtl_tab PIPELINED
  IS
     v_list   giis_banc_type_dtl_type;
  BEGIN
      FOR i IN (SELECT banc_type_cd, item_no, intm_no,
                       intm_type, share_percentage, remarks, user_id,
                       last_update, fixed_tag
                  FROM GIIS_BANC_TYPE_DTL
                 WHERE banc_type_cd = (SELECT banc_type_cd
                                         FROM gipi_polbasic
                                        WHERE policy_id = p_policy_id))
      LOOP
         v_list.banc_type_cd        := i.banc_type_cd;
         v_list.item_no             := i.item_no;
         v_list.intm_no             := i.intm_no;
         v_list.intm_type           := i.intm_type;
         v_list.share_percentage    := i.share_percentage;
         v_list.remarks             := i.remarks;
         v_list.user_id             := i.user_id;
         v_list.last_update         := i.last_update;
         v_list.fixed_tag           := i.fixed_tag;
         
         IF i.intm_no IS NOT NULL THEN
            SELECT intm_name
              INTO v_list.nbt_intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         ELSE
            IF p_v_mod_btyp ='N' THEN
               FOR c IN (SELECT a.intm_no, b.intm_name
                           FROM giac_new_comm_inv a,giis_intermediary b
                          WHERE a.iss_cd = p_iss_cd
                            AND prem_seq_no = p_prem_seq_no
                            AND tran_flag ='U'
                            AND delete_sw ='N'
                            AND a.intm_no = b.intm_no
                            AND b.intm_type = i.intm_type)
               LOOP
                  v_list.intm_no := c.intm_no;
                  v_list.nbt_intm_name := c.intm_name;
               END LOOP;
            END IF;
         END IF;
         
         PIPE ROW (v_list);
      END LOOP;
  END;
  
  FUNCTION get_giis_banc_type_dtl2(
     p_banc_type_cd      giis_banc_type_dtl.banc_type_cd%TYPE,
     p_v_mod_btyp        VARCHAR2,
     p_iss_cd            giac_new_comm_inv.iss_cd%TYPE,
     p_prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE
  )
     RETURN giis_banc_type_dtl_tab PIPELINED
  IS
     v_list   giis_banc_type_dtl_type;
  BEGIN  
      FOR i IN (SELECT banc_type_cd, item_no, intm_no,
                       intm_type, share_percentage, remarks, user_id,
                       last_update, fixed_tag
                  FROM GIIS_BANC_TYPE_DTL
                 WHERE banc_type_cd = p_banc_type_cd)
      LOOP
         v_list.banc_type_cd        := i.banc_type_cd;
         v_list.item_no             := i.item_no;
         v_list.intm_no             := i.intm_no;
         v_list.intm_type           := i.intm_type;
         v_list.share_percentage    := i.share_percentage;
         v_list.remarks             := i.remarks;
         v_list.user_id             := i.user_id;
         v_list.last_update         := i.last_update;
         v_list.fixed_tag           := i.fixed_tag;
         
         IF i.intm_no IS NOT NULL THEN
            SELECT intm_name
              INTO v_list.nbt_intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         ELSE
            IF p_v_mod_btyp ='N' THEN
               FOR c IN (SELECT a.intm_no, b.intm_name
                           FROM giac_new_comm_inv a,giis_intermediary b
                          WHERE a.iss_cd = p_iss_cd
                            AND prem_seq_no = p_prem_seq_no
                            AND tran_flag ='U'
                            AND delete_sw ='N'
                            AND a.intm_no = b.intm_no
                            AND b.intm_type = i.intm_type)
               LOOP
                  v_list.intm_no := c.intm_no;
                  v_list.nbt_intm_name := c.intm_name;
               END LOOP;
            END IF;
         END IF;
         
         PIPE ROW (v_list);
      END LOOP;
  END;
  
  PROCEDURE GIACS408_POST_CHANGES(
    p_fund_cd       giac_new_comm_inv.fund_cd%TYPE,
    p_branch_cd     giac_new_comm_inv.branch_cd%TYPE,
    p_iss_cd        giac_new_comm_inv.iss_cd%TYPE,
    p_prem_seq_no   giac_new_comm_inv.prem_seq_no%TYPE,
    p_comm_rec_id   giac_new_comm_inv.comm_rec_id%TYPE,
    p_user_id       giac_new_comm_inv.posted_by%TYPE,
    p_intm_no       giis_intermediary.intm_no%TYPE
  )
  IS
  var_policy_id         giac_new_comm_inv.policy_id%TYPE;
  v_exists              VARCHAR2(1);
  v_debit_amt           giac_acct_entries.debit_amt%TYPE;
  v_credit_amt          giac_acct_entries.credit_amt%TYPE;
  v_pcv_exist            varchar2(1);
  
  v_comm_acct_gen       VARCHAR2(300);
  v_prev_gacc_tran_id   gipi_comm_invoice.gacc_tran_id%TYPE;
  v_gacc_tran_id        gipi_comm_invoice.gacc_tran_id%TYPE;
  v_rev_gacc_tran_id    giac_acctrans.tran_id%TYPE;
  v_new_gacc_tran_id    giac_acctrans.tran_id%TYPE;     --added by steven 11.17.2014
  v_comm_amt            giac_comm_payts.comm_amt%TYPE;  --added by steven 10.15.2014
  v_acct_ent_date       giac_new_comm_inv.acct_ent_date%TYPE;   --added by steven 11.04.2014
  v_inv_acct_date   giac_new_comm_inv.acct_ent_date%TYPE;       --added by steven 11.17.2014
  v_increase            VARCHAR2(1) := 'N';
  BEGIN
     GIIS_USERS_PKG.app_user := p_user_id; --added by steven 11.17.2014
     SELECT NVL (SUM (a.comm_amt), 0) comm_amt
         INTO v_comm_amt
         FROM giac_comm_payts a, giac_acctrans b
        WHERE 1 = 1
          AND a.gacc_tran_id = b.tran_id
          AND a.iss_cd = p_iss_cd
          AND a.prem_seq_no = p_prem_seq_no
       /*AND a.intm_no =:gnci.intm_no*/--commented by albert 07102014; checking of payments upon posting should be per bill
          --added by mikel 10.16.2012; checking of payments should be per intermediary
          AND NOT EXISTS (
                 SELECT c.gacc_tran_id
                   FROM giac_reversals c, giac_acctrans d
                  WHERE c.reversing_tran_id = d.tran_id
                    AND d.tran_flag <> 'D'
                    AND c.gacc_tran_id = a.gacc_tran_id)
          --AND b.tran_flag <> 'D'; --commented by albert 07012014; replaced by codes below
          AND (   (a.tran_type IN (1, 3) AND b.tran_flag <> 'D')
               OR (a.tran_type IN (2, 4) AND b.tran_flag IN ('C', 'P')));--only check for comm payment reversals that are closed or posted
      
      --added by joanne, 10.29.2014, to validate if commission amount is increase
      FOR newcomm IN (SELECT commission_amt, intm_no, iss_cd, prem_seq_no,
                             comm_rec_id, fund_cd, branch_cd
                        FROM giac_new_comm_inv
                       WHERE iss_cd = p_iss_cd 
                       AND prem_seq_no = p_prem_seq_no)
      LOOP 
            FOR prevcomm IN (SELECT commission_amt
                              FROM giac_prev_comm_inv
                             WHERE iss_cd = newcomm.iss_cd 
                                AND prem_seq_no = newcomm.prem_seq_no
                                AND intm_no = newcomm.intm_no
                                AND comm_rec_id = newcomm.comm_rec_id
                                AND fund_cd = newcomm.fund_cd
                                AND branch_cd = newcomm.branch_cd)
          LOOP 
              IF newcomm.commission_amt > prevcomm.commission_amt THEN
                  v_increase := 'Y';    
                  EXIT;
              END IF;    
          END LOOP;     
	  END LOOP;

      IF v_comm_amt <> 0 AND v_increase = 'N' --joanne 10.29.2014 added v_increase
      THEN
            raise_application_error(-20001,'Geniisys Exception#E#Posting of changes is not allowed. Commission payment transaction(s) already exists for this invoice.'); 
      END IF;
       
      FOR spoiled IN 
        (SELECT 'x'
           FROM gipi_polbasic a, gipi_invoice b
          WHERE a.policy_id   = b.policy_id
            AND a.iss_cd      = b.iss_cd
            AND a.pol_flag    = '5'
            AND b.iss_cd      = p_iss_cd
            AND b.prem_seq_no = p_prem_seq_no)
      LOOP
        raise_application_error(-20001,'Geniisys Exception#I#Posting is not allowed. Policy is already spoiled.');       
      END LOOP;
        
      FOR chksum IN 
        (SELECT NVL(SUM(share_percentage),0) sum_percentage
           FROM giac_new_comm_inv
          WHERE NVL(delete_sw,'N') = 'N'
            AND tran_flag          = 'U'
            AND fund_cd            = p_fund_cd
            AND branch_cd          = p_branch_cd
            AND iss_cd             = p_iss_cd
            AND prem_seq_no        = p_prem_seq_no)
      LOOP
        IF chksum.sum_percentage <> 100 THEN
          raise_application_error(-20001,'Geniisys Exception#I#Posting not allowed. Total Share Percentage is not equal to 100%.');
        END IF;
      END LOOP;

      v_comm_acct_gen := giacp.v('COMM_ACCT_GEN');

      IF v_comm_acct_gen IS NULL THEN
         raise_application_error(-20001,'Geniisys Exception#I#No data found in GIAC_PARAMETERS for COMM_ACCT_GEN (accounting generation type).');
      END IF;
      
      -- validation to check if comm_amt in giac_new_comm_inv is equal to the sum of comm_amt in giac_new_comm_inv_peril. if not, update giac_new_comm_inv
      FOR newcomm IN (SELECT * 
                        FROM giac_new_comm_inv
                       WHERE iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND comm_rec_id = p_comm_rec_id
                         AND intm_no = p_intm_no)
      LOOP
            FOR newcommperil IN (SELECT SUM(commission_amt) total_comm_amt
                                   FROM giac_new_comm_inv_peril
                                  WHERE fund_cd = newcomm.fund_cd
                                    AND branch_cd = newcomm.branch_cd
                                    AND comm_rec_id = newcomm.comm_rec_id
                                    AND intm_no = newcomm.intm_no)
            LOOP
                IF newcomm.commission_amt <> newcommperil.total_comm_amt THEN
                    GIACS408_PKG.UPDATE_COMM_TABLES(p_iss_cd, p_prem_seq_no, p_comm_rec_id, p_intm_no);
                END IF;
            END LOOP;
      END LOOP;
      
      FOR prevcomm IN (SELECT * 
                        FROM giac_prev_comm_inv
                       WHERE iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND comm_rec_id = p_comm_rec_id
                         AND intm_no = p_intm_no)
      LOOP
            FOR prevcommperil IN (SELECT SUM(commission_amt) total_comm_amt
                                   FROM giac_prev_comm_inv_peril
                                  WHERE fund_cd = prevcomm.fund_cd
                                    AND branch_cd = prevcomm.branch_cd
                                    AND comm_rec_id = prevcomm.comm_rec_id
                                    AND intm_no = prevcomm.intm_no)
            LOOP
                IF prevcomm.commission_amt <> prevcommperil.total_comm_amt THEN
                    GIACS408_PKG.UPDATE_COMM_TABLES(p_iss_cd, p_prem_seq_no, p_comm_rec_id, p_intm_no);
                END IF;
            END LOOP;
      END LOOP;
      -- end of validation : shan 03.12.2015
      
      
      --added by steven 10.15.2014
      -- get previous gacc_tran_id
      BEGIN
         SELECT NVL (gacc_tran_id, 0)
           INTO v_prev_gacc_tran_id
           FROM gipi_comm_invoice
          WHERE iss_cd = p_iss_cd
            AND prem_seq_no = p_prem_seq_no
            AND intrmdry_intm_no >= 0             
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
     
     --move by steven 10.15.2014
      IF v_prev_gacc_tran_id > 1 THEN
         /* if '1' complete acct generation, '2' commission only */
         IF v_comm_acct_gen IN ('1','2') THEN
            /* generate reversal entries */ 
            giacs408_pkg.reversal_gl_accts(p_iss_cd, p_prem_seq_no, p_fund_cd, p_branch_cd, v_comm_acct_gen, v_rev_gacc_tran_id);
            giacs408_pkg.process_unbalance_accts(p_iss_cd, p_prem_seq_no, v_rev_gacc_tran_id, p_fund_cd);
         ELSIF v_comm_acct_gen IN ('3') THEN
            NULL;   
         END IF;
      END IF;
      
      /* Check accounting entries if debit and credit is equal */
      SELECT NVL(SUM(debit_amt),0), NVL(SUM(credit_amt),0)
        INTO v_debit_amt, v_credit_amt
        FROM giac_acct_entries 
       WHERE gacc_tran_id = v_rev_gacc_tran_id;
       
      IF v_debit_amt <> v_credit_amt THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'     -- set to open so that user can edit accounting entries.
          WHERE tran_id = v_rev_gacc_tran_id;
          
         raise_application_error(-20005,'Geniisys Exception#I#The sum of debit is not equal to the sum of credit. Please verify Accounting Entries.');
      END IF;

      DELETE giac_parent_comm_invprl
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;
                                
      DELETE giac_parent_comm_invoice
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

      DELETE FROM gipi_comm_inv_peril
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

      DELETE FROM gipi_comm_invoice
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

      --added by A.R.C. 07.21.2005
      DELETE FROM gipi_comm_inv_dtl
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

      -- insert into gipi_comm_invoice the new records.
      FOR gpcinv IN  
        (SELECT a.intm_no,     a.iss_cd,         a.policy_id,    a.prem_seq_no, a.share_percentage,
                a.premium_amt, a.commission_amt, a.wholding_tax, a.comm_rec_id,
                a.tran_no, b.parent_intm_no --added alias to prevent ORA-00918 by MAC 11/06/2013
           FROM giac_new_comm_inv a, giis_intermediary b
          WHERE NVL(delete_sw, 'N') = 'N'
            AND tran_flag           = 'U'
            AND a.intm_no           = b.intm_no
            AND a.fund_cd             = p_fund_cd
            AND a.branch_cd           = p_branch_cd
            AND a.iss_cd              = p_iss_cd
            AND a.prem_seq_no         = p_prem_seq_no)
      LOOP
        var_policy_id := gpcinv.policy_id;

        INSERT INTO gipi_comm_invoice
          (intrmdry_intm_no,        iss_cd,             policy_id,             prem_seq_no,
           share_percentage,        premium_amt,        commission_amt,
           wholding_tax,            parent_intm_no)
        VALUES 
          (gpcinv.intm_no,          gpcinv.iss_cd,      gpcinv.policy_id,      gpcinv.prem_seq_no,
           gpcinv.share_percentage, gpcinv.premium_amt, gpcinv.commission_amt,
           gpcinv.wholding_tax,     nvl(gpcinv.parent_intm_no, gpcinv.intm_no));--Vincent 090105: added nvl

        --Vincent 090105: added IF stmnt so that insert in gipi_comm_inv_dtl will only be done if 
        --the intm_no <> parent_intm_no
        IF gpcinv.intm_no <> nvl(gpcinv.parent_intm_no, gpcinv.intm_no) THEN
          --added by A.R.C. 07.21.2005
          giacs408_pkg.POPULATE_GIPI_COMM_INV_DTL(p_fund_cd, p_branch_cd, gpcinv.intm_no, gpcinv.iss_cd, gpcinv.policy_id, gpcinv.prem_seq_no,
                                     gpcinv.share_percentage, gpcinv.parent_intm_no);
        END IF;

        UPDATE giac_prev_parent_comm_inv
           SET gacc_tran_id = v_rev_gacc_tran_id
         WHERE chld_intm_no = gpcinv.intm_no 
           AND comm_rec_id  = gpcinv.comm_rec_id;

      END LOOP gpcinv;

      -- insert into gipi_comm_inv_peril
      FOR gperil IN  
        (SELECT intm_no, iss_cd, prem_seq_no,   peril_cd, premium_amt,
                commission_amt,  commission_rt, wholding_tax,
                comm_peril_id,   comm_rec_id,   tran_no
           FROM giac_new_comm_inv_peril
          WHERE NVL (delete_sw, 'N') = 'N'
            AND tran_flag            = 'U'
            AND fund_cd              = p_fund_cd --variables
            AND branch_cd            = p_branch_cd
            AND iss_cd               = p_iss_cd --:b140
            AND prem_seq_no          = p_prem_seq_no)
      LOOP
         MERGE INTO gipi_comm_inv_peril
         USING DUAL
            ON (iss_cd = gperil.iss_cd
                AND prem_seq_no = gperil.prem_seq_no
                AND intrmdry_intm_no = gperil.intm_no
                AND peril_cd = gperil.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (intrmdry_intm_no, iss_cd, prem_seq_no, policy_id,
                    peril_cd, premium_amt, commission_amt,
                    commission_rt, wholding_tax)
            VALUES (gperil.intm_no, gperil.iss_cd, gperil.prem_seq_no, var_policy_id,
                    gperil.peril_cd, gperil.premium_amt, gperil.commission_amt,
                    gperil.commission_rt, gperil.wholding_tax)
         WHEN MATCHED THEN
            UPDATE
               SET policy_id = var_policy_id, 
                   premium_amt = gperil.premium_amt, 
                   commission_amt = gperil.commission_amt, 
                   commission_rt = gperil.commission_rt, 
                   wholding_tax = gperil.wholding_tax;
      END LOOP gperil;
      
      BEGIN
        IF v_prev_gacc_tran_id > 1 THEN --  the first if
           IF v_comm_acct_gen IN ('1', '2') THEN -- comm_acct_gen
              /* generate new entries */
              giacs408_pkg.get_gl_accts_not_reversal(p_iss_cd, p_prem_seq_no, p_fund_cd, p_branch_cd, v_comm_acct_gen,v_new_gacc_tran_id);
              giacs408_pkg.process_unbalance_accts(p_iss_cd, p_prem_seq_no, v_new_gacc_tran_id, p_fund_cd);
              UPDATE gipi_comm_invoice
                 SET gacc_tran_id = v_new_gacc_tran_id
               WHERE iss_cd       = p_iss_cd --:b140
                 AND prem_seq_no  = p_prem_seq_no;
                 
              UPDATE giac_prev_comm_inv
                 SET gacc_tran_id = v_rev_gacc_tran_id
               WHERE comm_rec_id IN (SELECT comm_rec_id
                                       FROM giac_new_comm_inv a
                                      WHERE a.iss_cd = p_iss_cd --:b140.
                                        AND a.prem_seq_no = p_prem_seq_no
                                        AND fund_cd = p_fund_cd
                                        AND branch_cd = p_branch_cd
                                        --- and nvl(a.delete_sw, 'N') = 'N'
                                        AND a.tran_flag = 'U')
                 AND fund_cd           = p_fund_cd --variables.
                 AND branch_cd         = p_branch_cd
                 AND prev_gacc_tran_id = v_prev_gacc_tran_id;
                 
              UPDATE giac_parent_comm_invoice
                 SET tran_id     = v_new_gacc_tran_id
               WHERE iss_cd      = p_iss_cd --b140
                 AND prem_seq_no = p_prem_seq_no;
                 
              UPDATE giac_parent_comm_invprl
                 SET tran_id     = v_new_gacc_tran_id
               WHERE iss_cd      = p_iss_cd 
                 AND prem_seq_no = p_prem_seq_no;
                 
           ELSIF v_comm_acct_gen IN ('3') THEN
              BEGIN -- in ('3') begin
                UPDATE gipi_comm_invoice
                   SET gacc_tran_id = v_prev_gacc_tran_id
                 WHERE iss_cd       = p_iss_cd  --:b140.
                   AND prem_seq_no  = p_prem_seq_no;
     
                UPDATE giac_prev_comm_inv
                   SET gacc_tran_id = v_prev_gacc_tran_id
                 WHERE comm_rec_id IN (SELECT comm_rec_id
                                         FROM giac_new_comm_inv a
                                        WHERE a.iss_cd      = p_iss_cd --b140
                                          AND a.prem_seq_no = p_prem_seq_no
                                          AND fund_cd       = p_fund_cd --variables
                                          AND branch_cd     = p_branch_cd
                                          --- and nvl(a.delete_sw, 'N') = 'N'
                                          AND a.tran_flag   = 'U')
                   AND prev_gacc_tran_id = v_prev_gacc_tran_id;
     
                UPDATE giac_parent_comm_invoice
                   SET tran_id     = v_prev_gacc_tran_id
                 WHERE iss_cd      = p_iss_cd --:b140.
                   AND prem_seq_no = p_prem_seq_no;
     
                UPDATE giac_parent_comm_invprl
                   SET tran_id     = v_prev_gacc_tran_id
                 WHERE iss_cd      = p_iss_cd  --:b140.
                   AND prem_seq_no = p_prem_seq_no;
              END; -- in ('3') end
           END IF; -- comm_acct_gen
        END IF; -- the first if
      END;

      -- set tran_flag = 'P'
      UPDATE giac_new_comm_inv
         SET tran_flag = 'P'
       WHERE iss_cd      = p_iss_cd 
         AND prem_seq_no = p_prem_seq_no
         AND fund_cd     = p_fund_cd 
         AND branch_cd   = p_branch_cd
         AND tran_flag   = 'U';
      
      UPDATE giac_new_comm_inv_peril
         SET tran_flag = 'P'
       WHERE iss_cd       = p_iss_cd 
         AND prem_seq_no  = p_prem_seq_no
         AND fund_cd      = p_fund_cd 
         AND branch_cd     = p_branch_cd
         AND tran_flag    = 'U';
      
      UPDATE giac_prev_comm_inv
         SET tran_flag = 'P'
       WHERE comm_rec_id = p_comm_rec_id 
         AND fund_cd     = p_fund_cd 
         AND branch_cd   = p_branch_cd;
      
      UPDATE giac_prev_comm_inv_peril
         SET tran_flag = 'P'
       WHERE comm_rec_id = p_comm_rec_id 
         AND fund_cd     = p_fund_cd 
         AND branch_cd   = p_branch_cd;
      
      UPDATE giac_new_comm_inv
         SET post_date = SYSDATE,
             posted_by = p_user_id,
             create_date = SYSDATE --added by steven 10.15.2014
       WHERE comm_rec_id = p_comm_rec_id 
         AND fund_cd     = p_fund_cd 
         AND branch_cd   = p_branch_cd 
         AND iss_cd      = p_iss_cd 
         AND prem_seq_no = p_prem_seq_no; 
         
      --added by steven 10.15.2014
      /* commented-out by steven 11.17.2014 base on CS version
      DECLARE
         v_parent_intm_no   giis_intermediary.parent_intm_no%TYPE;
         v_lic_tag          giis_intermediary.lic_tag%TYPE;
      BEGIN
         SELECT b100.parent_intm_no, lic_tag
           INTO v_parent_intm_no, v_lic_tag
           FROM giis_intermediary b100
          WHERE b100.intm_no = p_intm_no;

         IF v_parent_intm_no IS NULL AND v_lic_tag = 'Y'
         THEN
            UPDATE giac_new_comm_inv
               SET parent_intm_no = p_intm_no
             WHERE comm_rec_id = p_comm_rec_id;

            UPDATE gipi_comm_invoice
               SET parent_intm_no = p_intm_no
             WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
         ELSE
            UPDATE giac_new_comm_inv
               SET parent_intm_no = v_parent_intm_no
             WHERE comm_rec_id = p_comm_rec_id;

            UPDATE gipi_comm_invoice
               SET parent_intm_no = v_parent_intm_no
             WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
         END IF;
      END;
      -- end
      */

      BEGIN
        SELECT 'x'
          INTO v_exists
          FROM gipi_comm_invoice
         WHERE iss_cd      = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND ROWNUM      = 1;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          raise_application_error(-20002, 'Geniisys Exception#I#No records in Commission Invoice Table. Save and post changes again.');
      END;
        
        
    /*lina 12122005    
    ** to insert in giac_parent_comm_voucher when modification made is from licensed to unlicensed
    */
      BEGIN
          FOR pcv IN (SELECT '1' exist        
                        FROM GIAC_PARENT_COMM_VOUCHER
                       WHERE iss_cd = p_iss_cd --:gnci.
                         AND prem_seq_no = p_prem_seq_no) --:gnci.
        LOOP
          v_pcv_exist := pcv.exist;
        END LOOP;   -- added by judyann 08092007; only new records for bills with no parent comm voucher records will be created
        
        IF v_pcv_exist IS NOT NULL
         THEN
            DELETE FROM giac_parent_comm_voucher
                  WHERE iss_cd = p_iss_cd
                    AND prem_seq_no = p_prem_seq_no;
         END IF;
        
       FOR rec IN (SELECT DISTINCT c.gfun_fund_cd,
                          c.gibr_branch_cd,
                          d.policy_id,
                          f.assd_no,
                          DECODE( e.endt_seq_no, 0,
                          SUBSTR(e.line_cd ||'-'|| e.subline_cd||'-'|| e.iss_cd||'-'||
                          TO_CHAR( e.issue_yy)||'-'|| TO_CHAR( e.pol_seq_no,'fm0000000' )||'-'||
                          TO_CHAR( e.renew_no, 'fm00' ) , 1,37),
                          SUBSTR( e.line_cd ||'-'|| e.subline_cd||'-'|| e.iss_cd||'-'||
                          TO_CHAR( e.issue_yy)||'-'|| TO_CHAR( e.pol_seq_no , 'fm0000000' ) ||'-'|| e.endt_iss_cd
                          ||'-'|| TO_CHAR( e.endt_yy) ||'-'||TO_CHAR( e.endt_seq_no, 'fm000000' )||'-'||
                          TO_CHAR( e.renew_no, 'fm00' ), 1,37)) policy_no,
                          a.intm_no,
                          a.chld_intm_no,
                          a.iss_cd,
                          a.prem_seq_no,
                          a.commission_amt,
                          c.tran_date,
                          c.tran_class,
                          c.tran_class_no,
                          b.inst_no,
                          b.gacc_tran_id,
                          b.tax_amt,
                          b.transaction_type,
                          b.collection_amt,
                          b.premium_amt,
                         (d.prem_amt + NVL(other_charges,0) + NVL(notarial_fee,0)) * d.currency_rt prem,
                          b.premium_amt / ((d.prem_amt + NVL(other_charges,0) + NVL(notarial_fee,0)) * d.currency_rt) ratio,
                          a.commission_amt * ( b.premium_amt / ((d.prem_amt + NVL(other_charges,0) + NVL(notarial_fee,0)) * d.currency_rt)) comm,
                          a.wholding_tax * (   b.premium_amt / ((d.prem_amt + NVL(other_charges,0) + NVL(notarial_fee,0)) * d.currency_rt)) wholding_tax
                     FROM GIAC_PARENT_COMM_INVOICE a,
                          GIAC_DIRECT_PREM_COLLNS b,
                          GIAC_ACCTRANS c,
                          GIPI_INVOICE  d,
                          GIPI_POLBASIC e,
                          GIPI_PARLIST  f
                    WHERE a.iss_cd = b.b140_iss_cd
                      AND a.prem_seq_no = b.b140_prem_seq_no
                      AND b.gacc_tran_id = c.tran_id
                      AND a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND d.policy_id = e.policy_id
                      AND e.par_id = f.par_id 
                        AND b.b140_iss_cd = p_iss_cd 
                        AND b.b140_prem_seq_no = p_prem_seq_no 
                        AND c.tran_flag <> 'D'
                                  AND NOT EXISTS (SELECT '1'
                                                    FROM GIAC_REVERSALS x, 
                                                           GIAC_ACCTRANS y
                                                     WHERE x.reversing_tran_id = y.tran_id
                                                             AND x.gacc_tran_id = b.gacc_tran_id
                                                             AND y.tran_flag <> 'D'))  -- judyann 09252007; consider only valid transactions (premium collections)
       LOOP
         INSERT INTO GIAC_PARENT_COMM_VOUCHER
                     (gfun_fund_cd     ,gibr_branch_cd    ,gacc_tran_id      ,policy_id         ,
                      policy_no         ,intm_no           ,iss_cd            ,prem_seq_no       ,
                      inst_no           ,commission_amt    ,transaction_type  ,collection_amt    ,
                      premium_amt       ,tax_amt           ,tran_date         ,tran_class        ,
                      tran_class_no     ,total_prem        ,ratio             ,commission_due    ,
                      print_tag         ,print_date        ,chld_intm_no      ,input_vat         ,
                      advances          ,withholding_tax   ,assd_no           ,ocv_pref_suf      ,
                      cancel_tag)
              VALUES (rec.gfun_fund_cd ,rec.gibr_branch_cd,rec.gacc_tran_id ,rec.policy_id     ,
                      rec.policy_no    ,rec.intm_no       ,p_iss_cd   ,p_prem_seq_no   ,
                      rec.inst_no      ,rec.commission_amt,rec.transaction_type,rec.collection_amt,
                      rec.premium_amt ,rec.tax_amt     ,rec.tran_date      ,rec.tran_class    ,
                      rec.tran_class_no,rec.prem          ,rec.ratio         ,rec.comm          ,
                      'N'              ,NULL              ,rec.chld_intm_no  ,0                 ,
                      0                ,rec.wholding_tax  ,rec.assd_no       ,NULL              ,
                      'N');
       END LOOP;
      END;

    /*
    ** emcy da060905te
    */
      /*BEGIN  
          UPDATE giac_new_comm_inv
             SET acct_ent_date = LAST_DAY(SYSDATE)
           WHERE iss_cd          = :b140.iss_cd
             AND prem_seq_no = :b140.prem_seq_no;
      END;*/--Vincent 081705: comment out, replaced below
    /**end of revision**/

      --Vincent 081705: acct_ent_date of giac_new_comm_inv should only be 
      --updated if policy of the bill is already booked (taken up in Batch Production). 
          
      /* modified by judyann 04182008; considered acct_ent_date in gipi_invoice;
      ** this is due to Long-Term Policy enhancement */  
      
      BEGIN  
        FOR rec IN (SELECT b.acct_ent_date
                       FROM gipi_polbasic a, gipi_invoice b
                      WHERE a.policy_id = b.policy_id
                        --AND a.acct_ent_date IS NOT NULL
                        AND b.acct_ent_date IS NOT NULL
                        AND b.iss_cd = p_iss_cd
                        AND b.prem_seq_no = p_prem_seq_no)
        LOOP                
             SELECT ADD_MONTHS (TO_DATE (TO_CHAR (MAX (tran_date), 'MM-YYYY'),
                                        'MM-YYYY'
                                       ),
                               1
                              ) acct_ent_date
              INTO v_acct_ent_date
              FROM giac_acctrans
             WHERE tran_class = 'PRD';
             
             v_inv_acct_date := rec.acct_ent_date;
          END LOOP; 
          
          UPDATE giac_new_comm_inv
            SET acct_ent_date = v_acct_ent_date,
                gacc_tran_id = v_new_gacc_tran_id
          WHERE comm_rec_id = p_comm_rec_id
            AND fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd
            AND iss_cd = p_iss_cd
            AND prem_seq_no = p_prem_seq_no;  
            
         /** added so that giac_prev_comm_inv acct_ent_date will be updated if bill is already taken up upon posting of changes*/
         UPDATE giac_prev_comm_inv
            SET acct_ent_date = v_inv_acct_date
          WHERE comm_rec_id = p_comm_rec_id
            AND fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd;
      END;
  END;
  
  PROCEDURE reversal_gl_accts (
      p_iss_cd             gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      p_fund_cd            giac_prev_comm_inv.fund_cd%TYPE,
      p_branch_cd          giac_prev_comm_inv.branch_cd%TYPE, 
      v_comm_acct_gen      IN OUT VARCHAR2,
      v_rev_gacc_tran_id   OUT  giac_acctrans.tran_id%TYPE
    )
    IS
      v_gacc_tran_id        giac_acctrans.tran_id%TYPE;
      --v_rev_gacc_tran_id    giac_acctrans.tran_id%TYPE;
      v_tran_class          giac_acctrans.tran_class%TYPE;
      v_is_it_reversal      BOOLEAN;
      v_particulars         giac_acctrans.particulars%TYPE;
      
      v_acct_subline_cd   giis_subline.acct_subline_cd%type;
      v_acct_line_cd      GIIS_LINE.acct_line_cd%type;
      v_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%type;
      v_acct_intm_cd      giis_intm_type.acct_intm_cd%type;
     
    BEGIN
    /*  SELECT max(jv_no)+1
        INTO variables.jv_no         
        FROM giac_acctrans;
    */

      SELECT acctran_tran_id_s.nextval
        INTO v_gacc_tran_id 
        FROM DUAL;

      v_rev_gacc_tran_id := v_gacc_tran_id;
      v_tran_class       := 'MR';  
      v_is_it_reversal   := TRUE;    

      FOR rec IN 
        (SELECT a.line_cd,  a.subline_cd,    c.assd_no,
                a.iss_cd,   b.prem_seq_no
           FROM gipi_polbasic a, gipi_invoice  b, gipi_parlist c
          WHERE a.policy_id   = b.policy_id
            AND a.par_id      = c.par_id
            AND b.iss_cd      = p_iss_cd
            AND b.prem_seq_no = p_prem_seq_no) 
      LOOP
        v_particulars := 'REVERSAL ACCT ENTRIES FOR '||rec.iss_cd||'-'||to_char(rec.prem_seq_no);

        v_acct_intm_cd := giacs408_pkg.get_rev_acct_intm_cd(p_iss_cd, p_prem_seq_no);

        giacs408_pkg.get_br_ln_subln(p_fund_cd, rec.iss_cd, rec.line_cd, rec.subline_cd, rec.assd_no,
                        v_branch_cd ,v_acct_line_cd , v_acct_subline_cd );            
         
        giacs408_pkg.insert_giac_acctrans(p_fund_cd, v_branch_cd, v_gacc_tran_id, v_tran_class, v_particulars);    

        IF v_comm_acct_gen = '1'  THEN -- complete accounting generation
           giacs408_pkg.bae_gross_premiums(rec.iss_cd, rec.prem_seq_no, v_branch_cd ,v_acct_line_cd 
                              ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd);
                              
           giacs408_pkg.bae_premiums_receivable(rec.iss_cd, rec.prem_seq_no, v_branch_cd ,v_acct_line_cd 
                                   ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );
                                   
           giacs408_pkg.bae_commissions_payable(rec.iss_cd, rec.prem_seq_no, v_branch_cd ,v_acct_line_cd 
                                    ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd);
                                   
           giacs408_pkg.bae_commissions_expense(rec.iss_cd, rec.prem_seq_no,  v_branch_cd ,v_acct_line_cd 
                                   ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd, p_branch_cd);
                                   
           giacs408_pkg.bae_miscellaneous_income(rec.iss_cd, rec.prem_seq_no,  v_branch_cd ,v_acct_line_cd 
                                    ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );
                                    
           giacs408_pkg.bae_taxes_payable(rec.iss_cd, rec.prem_seq_no, v_branch_cd ,v_acct_line_cd 
                             ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );
        ELSIF v_comm_acct_gen = '2'  THEN --  commission take up only
           giacs408_pkg.bae_commissions_payable(rec.iss_cd, rec.prem_seq_no, v_branch_cd ,v_acct_line_cd 
                                   ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );
           giacs408_pkg.bae_commissions_expense(rec.iss_cd, rec.prem_seq_no,  v_branch_cd ,v_acct_line_cd 
                                   ,v_acct_subline_cd, v_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd, p_branch_cd);
        END IF;
      END LOOP rec;
    END reversal_gl_accts;
    
    PROCEDURE bae_gross_premiums (bgp_iss_cd            IN   gipi_invoice.iss_cd%TYPE,
                                  bgp_prem_seq_no       IN   gipi_invoice.prem_seq_no%TYPE,
                                  bgp_branch_cd         IN   giac_branches.branch_cd%TYPE,
                                  bgp_acct_line_cd      IN   giis_subline.acct_subline_cd%TYPE,
                                  bgp_acct_subline_cd   IN   giis_line.acct_line_cd%TYPE,
                                  bgp_acct_intm_cd      IN   giis_intm_type.acct_intm_cd%TYPE,
                                  v_is_it_reversal      IN   BOOLEAN,
                                  v_gacc_tran_id        IN   giac_acctrans.tran_id%TYPE,
                                  p_fund_cd             IN   giac_prev_comm_inv.fund_cd%TYPE)
    IS
      var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
      var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
      var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
      var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
      var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
      var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
      var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
      var_acct_line_cd            giis_line.acct_line_cd%TYPE;
      var_gslt_sl_type_cd         giac_chart_of_accts.gslt_sl_type_cd%TYPE;
      var_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
      counter                     NUMBER                                         := 0;
    BEGIN
      /**********************************************************
      * Get the GL account codes for gross premiums 
      ************************************************************/
      BEGIN
        SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
               gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
               gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
               intm_type_level, line_dependency_level,
               old_new_acct_level, dr_cr_tag
          INTO var_gl_acct_category, var_gl_control_acct, var_gl_sub_acct_1,
               var_gl_sub_acct_2, var_gl_sub_acct_3, var_gl_sub_acct_4,
               var_gl_sub_acct_5, var_gl_sub_acct_6, var_gl_sub_acct_7,
               var_intm_type_level, var_line_dependency_level,
               var_old_new_acct_level, var_dr_cr_tag
          FROM giac_module_entries a, giac_modules b
         WHERE a.module_id = b.module_id
           AND module_name = 'GIACS408'
           AND item_no = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table.');
      END;

       
      /***********************************************
      * Get the fund code from giac_parameters
      ***********************************************/

      IF v_is_it_reversal = FALSE THEN
         giacs408_pkg.entries_for_gross_premiums(
             var_gl_acct_category,
             var_gl_control_acct,
             var_gl_sub_acct_1,
             var_gl_sub_acct_2,
             var_gl_sub_acct_3,
             var_gl_sub_acct_4,
             var_gl_sub_acct_5,
             var_gl_sub_acct_6,
             var_gl_sub_acct_7,
             var_intm_type_level,
             var_line_dependency_level,
             var_dr_cr_tag,
             bgp_iss_cd,
             bgp_prem_seq_no,
             bgp_branch_cd,
             bgp_acct_line_cd,
             bgp_acct_subline_cd,
             bgp_acct_intm_cd,
             v_gacc_tran_id,
             p_fund_cd);
      ELSIF v_is_it_reversal = TRUE THEN
         giacs408_pkg.rev_entries_for_gross_premiums(
             var_gl_acct_category,
             var_gl_control_acct,
             var_gl_sub_acct_1,
             var_gl_sub_acct_2,
             var_gl_sub_acct_3,
             var_gl_sub_acct_4,
             var_gl_sub_acct_5,
             var_gl_sub_acct_6,
             var_gl_sub_acct_7,
             var_intm_type_level,
             var_line_dependency_level,
             var_dr_cr_tag,
             bgp_iss_cd,
             bgp_prem_seq_no,
             bgp_branch_cd,
             bgp_acct_line_cd,
             bgp_acct_subline_cd,
             bgp_acct_intm_cd, 
             v_gacc_tran_id,
             p_fund_cd
             );
       END IF;

    END;
    
    PROCEDURE BAE_PREMIUMS_RECEIVABLE (
      bgr_iss_cd            IN GIPI_INVOICE.iss_cd%type,
      bgr_prem_seq_no        IN GIPI_INVOICE.prem_seq_no%type,
      bpr_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
      bpr_acct_line_cd      IN giis_subline.acct_subline_cd%type,    
      bpr_acct_subline_cd   IN GIIS_LINE.acct_line_cd%type      ,
      bpr_acct_intm_cd      IN giis_intm_type.acct_intm_cd%type,
      v_is_it_reversal      IN BOOLEAN,
      v_gacc_tran_id        IN giac_acctrans.tran_id%TYPE,
      p_fund_cd             IN giac_prev_comm_inv.fund_cd%TYPE
      )
    IS   
    var_gl_acct_category           giac_module_entries.gl_acct_category%type;
    var_gl_control_acct         giac_module_entries.gl_control_acct%type;
    var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
    var_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%type;
    var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
    var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
    var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
    var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
    var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
    var_intm_type_level         giac_module_entries.intm_type_level%type;
    var_line_dependency_level      giac_module_entries.line_dependency_level%type;
    var_old_new_acct_level         giac_module_entries.old_new_acct_level%type;
    var_dr_cr_tag                  giac_module_entries.dr_cr_tag%type;

    var_gslt_sl_type_cd            giac_chart_of_accts.gslt_sl_type_cd%type;
    v_prem_rec_gross_tag        GIAC_PARAMETERS.param_value_v%type;

    BEGIN
    --msg_alert(' BAE PREMUMS RECESVALE','I', FALSE);

      v_prem_rec_gross_tag := giacp.v('PREM_REC_GROSS_TAG');

      IF v_prem_rec_gross_tag IS NULL THEN
         raise_application_error(-20001,'Geniisys Exception#I#PREM_REC_GROSS_TAG not found in giac_parameters.');
      END IF;

       IF v_prem_rec_gross_tag = 'Y' THEN
        SELECT  gl_acct_category   ,  gl_control_acct   ,
            gl_sub_acct_1      ,  gl_sub_acct_2     ,
            gl_sub_acct_3      ,  gl_sub_acct_4     ,
            gl_sub_acct_5      ,  gl_sub_acct_6     ,
            gl_sub_acct_7      ,  intm_type_level   ,
            line_dependency_level  ,
                old_new_acct_level ,  dr_cr_tag         
          INTO  var_gl_acct_category,  var_gl_control_acct, 
            var_gl_sub_acct_1   , var_gl_sub_acct_2,
            var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
            var_gl_sub_acct_5   , var_gl_sub_acct_6,
            var_gl_sub_acct_7   ,  var_intm_type_level, 
            var_line_dependency_level  ,
                var_old_new_acct_level ,  var_dr_cr_tag   
          FROM  giac_module_entries a, giac_modules b
         WHERE  a.module_id = b.module_id
           AND  module_name = 'GIACS408'
           AND  item_no = 2;
        
       ELSIF v_prem_rec_gross_tag = 'N' THEN

            SELECT  gl_acct_category   ,  gl_control_acct   ,
                    gl_sub_acct_1      ,  gl_sub_acct_2     ,
                    gl_sub_acct_3      ,  gl_sub_acct_4     ,
                    gl_sub_acct_5      ,  gl_sub_acct_6     ,
                    gl_sub_acct_7      ,  intm_type_level   ,
                    line_dependency_level  ,
                    old_new_acct_level ,  dr_cr_tag         
              INTO  var_gl_acct_category,  var_gl_control_acct, 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   ,  var_intm_type_level, 
                    var_line_dependency_level  ,
                    var_old_new_acct_level ,  var_dr_cr_tag   
              FROM  giac_module_entries a, giac_modules b
             WHERE  a.module_id = b.module_id
               AND  module_name = 'GIACS408'
               AND  item_no = 3;
       END IF;
        

    /**
    ***  Sl Type was initialized to '0'
    ***  
    **/

    var_gslt_sl_type_cd := '0';


        IF v_is_it_reversal = FALSE THEN
              giacs408_pkg.ENTRIES_FOR_PREMIUM_RECEIVABLE (var_gl_acct_category,  var_gl_control_acct   ,  
                              var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                              var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                              var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                              var_gl_sub_acct_7   ,  var_intm_type_level   , 
                              var_line_dependency_level             ,        
                              var_dr_cr_tag       ,  
                              bgr_iss_cd          ,    bgr_prem_seq_no       ,
                              bpr_branch_cd       , bpr_acct_line_cd       , 
                              bpr_acct_subline_cd , bpr_acct_intm_cd,
                              v_prem_rec_gross_tag, v_gacc_tran_id, 
                              p_fund_cd);    
        ELSIF v_is_it_reversal = TRUE THEN
              giacs408_pkg.REV_ENTRIES_FOR_PREMIUM_RECEIV (var_gl_acct_category,  var_gl_control_acct   ,  
                              var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                              var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                              var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                              var_gl_sub_acct_7   ,  var_intm_type_level   , 
                              var_line_dependency_level             ,        
                              var_dr_cr_tag       ,  
                              bgr_iss_cd          ,    bgr_prem_seq_no       ,
                              bpr_branch_cd       ,  bpr_acct_line_cd, 
                              bpr_acct_subline_cd , bpr_acct_intm_cd,
                              v_prem_rec_gross_tag, v_gacc_tran_id, 
                              p_fund_cd);    

        END IF;
    END;
    
    PROCEDURE bae_commissions_payable (
      bcp_iss_cd            IN   gipi_invoice.iss_cd%TYPE,
      bcp_prem_seq_no       IN   gipi_invoice.prem_seq_no%TYPE,
      bcp_branch_cd         IN   giac_branches.branch_cd%TYPE,
      bcp_acct_line_cd      IN   giis_subline.acct_subline_cd%TYPE,
      bcp_acct_subline_cd   IN   giis_line.acct_line_cd%TYPE,
      bcp_acct_intm_cd      IN   giis_intm_type.acct_intm_cd%TYPE,
      v_is_it_reversal      IN   BOOLEAN,
      v_gacc_tran_id        IN   GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd             IN   GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
      )
    IS
      var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
      var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
      var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
      var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
      var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
      var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
      var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
      var_acct_line_cd            giis_line.acct_line_cd%TYPE;
      var_gslt_sl_type_cd         giac_chart_of_accts.gslt_sl_type_cd%TYPE;
      var_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
    BEGIN
      /**********************************************************
      *  Get the GL account codes for gross premiums
      ***********************************************************/
      BEGIN
        SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
               gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
               gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
               intm_type_level, line_dependency_level,
               old_new_acct_level, dr_cr_tag
          INTO var_gl_acct_category, var_gl_control_acct, var_gl_sub_acct_1,
               var_gl_sub_acct_2, var_gl_sub_acct_3, var_gl_sub_acct_4,
               var_gl_sub_acct_5, var_gl_sub_acct_6, var_gl_sub_acct_7,
               var_intm_type_level, var_line_dependency_level,
               var_old_new_acct_level, var_dr_cr_tag
          FROM giac_module_entries a, giac_modules b
         WHERE a.module_id = b.module_id
           AND module_name = 'GIACS408'
           AND item_no = 5;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table. ');
      END;

      IF v_is_it_reversal = FALSE THEN
         giacs408_pkg.entries_for_commission_payable (var_gl_acct_category,
                                         var_gl_control_acct,
                                         var_gl_sub_acct_1,
                                         var_gl_sub_acct_2,
                                         var_gl_sub_acct_3,
                                         var_gl_sub_acct_4,
                                         var_gl_sub_acct_5,
                                         var_gl_sub_acct_6,
                                         var_gl_sub_acct_7,
                                         var_intm_type_level,
                                         var_line_dependency_level,
                                         var_dr_cr_tag,
                                         bcp_iss_cd,
                                         bcp_prem_seq_no,
                                         bcp_branch_cd,
                                         bcp_acct_line_cd,
                                         bcp_acct_subline_cd,
                                         bcp_acct_intm_cd,
                                         v_gacc_tran_id,
                                         p_fund_cd );
      ELSIF v_is_it_reversal = TRUE THEN
        giacs408_pkg.rev_entries_for_commission_pay (var_gl_acct_category,
                                        var_gl_control_acct,
                                        var_gl_sub_acct_1,
                                        var_gl_sub_acct_2,
                                        var_gl_sub_acct_3,
                                        var_gl_sub_acct_4,
                                        var_gl_sub_acct_5,
                                        var_gl_sub_acct_6,
                                        var_gl_sub_acct_7,
                                        var_intm_type_level,
                                        var_line_dependency_level,
                                        var_dr_cr_tag,
                                        bcp_iss_cd,
                                        bcp_prem_seq_no,
                                        bcp_branch_cd,
                                        bcp_acct_line_cd,
                                        bcp_acct_subline_cd,
                                        bcp_acct_intm_cd,
                                        v_gacc_tran_id,
                                        p_fund_cd);
      END IF;
    END;
    
    PROCEDURE BAE_COMMISSIONS_EXPENSE  (
        bce_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        bce_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        bce_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        bce_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        bce_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        bce_acct_intm_cd        IN  giis_intm_type.acct_intm_cd%type,
        v_is_it_reversal        IN BOOLEAN,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_branch_cd             IN giac_new_comm_inv.branch_cd%TYPE
    ) 
    IS   
    var_gl_acct_category           giac_module_entries.gl_acct_category%type;
    var_gl_control_acct         giac_module_entries.gl_control_acct%type;
    var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
    var_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%type;
    var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
    var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
    var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
    var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
    var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
    var_intm_type_level         giac_module_entries.intm_type_level%type;
    var_line_dependency_level      giac_module_entries.line_dependency_level%type;
    var_old_new_acct_level         giac_module_entries.old_new_acct_level%type;
    var_dr_cr_tag                  giac_module_entries.dr_cr_tag%type;

    var_acct_line_cd            giis_line.acct_line_cd%type;
    var_gslt_sl_type_cd            giac_chart_of_accts.gslt_sl_type_cd%type;
    var_gl_acct_id              giac_chart_of_accts.gl_acct_id%type;

    BEGIN
      BEGIN
        SELECT  gl_acct_category   ,  gl_control_acct   ,
                gl_sub_acct_1      ,  gl_sub_acct_2     ,
                gl_sub_acct_3      ,  gl_sub_acct_4     ,
                gl_sub_acct_5      ,  gl_sub_acct_6     ,
                gl_sub_acct_7      ,  intm_type_level   ,
                line_dependency_level  ,
                old_new_acct_level ,  dr_cr_tag         
          INTO  var_gl_acct_category,  var_gl_control_acct, 
                var_gl_sub_acct_1   , var_gl_sub_acct_2,
                var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
                var_gl_sub_acct_5   , var_gl_sub_acct_6,
                var_gl_sub_acct_7   ,  var_intm_type_level, 
                var_line_dependency_level  ,
                var_old_new_acct_level ,  var_dr_cr_tag   
          FROM  giac_module_entries a, giac_modules b
         WHERE  a.module_id = b.module_id
           AND  module_name = 'GIACS408'
           AND  item_no = 6;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          raise_application_error(-20001,'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table. ');
      END;         

      IF v_is_it_reversal = FALSE THEN
         giacs408_pkg.ENTRIES_FOR_COMMISSION_EXPENSE (var_gl_acct_category, var_gl_control_acct   ,  
                                        var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                                        var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                                        var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                                        var_gl_sub_acct_7   ,  var_intm_type_level   , 
                                        var_line_dependency_level  ,
                                        var_dr_cr_tag       ,  
                                        bce_iss_cd            ,  bce_prem_seq_no    ,
                                        bce_branch_cd       ,  bce_acct_line_cd       , 
                                        bce_acct_subline_cd ,  bce_acct_intm_cd,
                                        v_gacc_tran_id,        p_fund_cd,
                                        p_branch_cd);    
      ELSIF v_is_it_reversal = TRUE THEN --awt v_intm_sl_type_cd
        giacs408_pkg.REV_ENTRIES_FOR_COMMISSION_EXP (var_gl_acct_category,  var_gl_control_acct   ,  
                                        var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                                        var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                                        var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                                        var_gl_sub_acct_7   ,  var_intm_type_level   , 
                                        var_line_dependency_level  ,
                                        var_dr_cr_tag       ,  
                                        bce_iss_cd            ,  bce_prem_seq_no    ,
                                        bce_branch_cd       ,  bce_acct_line_cd       , 
                                        bce_acct_subline_cd ,  bce_acct_intm_cd,
                                        v_gacc_tran_id,        p_fund_cd);    
      END IF;
    END;
    
    PROCEDURE BAE_MISCELLANEOUS_INCOME(
        bce_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        bce_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        bce_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        bce_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        bce_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        bce_acct_intm_cd        IN  giis_intm_type.acct_intm_cd%type,
        v_is_it_reversal        IN BOOLEAN,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    ) --v_intm_sl_type_cd awt
    IS   

    var_gl_acct_category           giac_module_entries.gl_acct_category%type;
    var_gl_control_acct         giac_module_entries.gl_control_acct%type;
    var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
    var_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%type;
    var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
    var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
    var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
    var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
    var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
    var_intm_type_level         giac_module_entries.intm_type_level%type;
    var_line_dependency_level      giac_module_entries.line_dependency_level%type;
    var_old_new_acct_level         giac_module_entries.old_new_acct_level%type;
    var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
    
    var_acct_line_cd            giis_line.acct_line_cd%type;
    var_gslt_sl_type_cd        giac_chart_of_accts.gslt_sl_type_cd%type;
    var_gl_acct_id          giac_chart_of_accts.gl_acct_id%type;
    
    v_intm_sl_type_cd      GIAC_ACCT_ENTRIES.sl_cd%type;
    BEGIN

    --msg_alert(' BAE MISCELLANEOUS EXPENSE ','I', FALSE);

    /**************************************************************************

        Get the GL account codes for MISCELLANEOUS INCOME/OTHER CHARGES

    **************************************************************************/
      
       BEGIN
        SELECT  gl_acct_category   ,  gl_control_acct   ,
            gl_sub_acct_1      ,  gl_sub_acct_2     ,
            gl_sub_acct_3      ,  gl_sub_acct_4     ,
            gl_sub_acct_5      ,  gl_sub_acct_6     ,
            gl_sub_acct_7      ,  intm_type_level   ,
            line_dependency_level  ,
                old_new_acct_level ,  dr_cr_tag         
          INTO  var_gl_acct_category,  var_gl_control_acct, 
            var_gl_sub_acct_1   , var_gl_sub_acct_2,
            var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
            var_gl_sub_acct_5   , var_gl_sub_acct_6,
            var_gl_sub_acct_7   ,  var_intm_type_level, 
            var_line_dependency_level  ,
                var_old_new_acct_level ,  var_dr_cr_tag   
          FROM  giac_module_entries a, giac_modules b
         WHERE  a.module_id = b.module_id
           AND  module_name = 'GIACS408'
           AND  item_no = 4;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table.');
       END;         



        IF v_is_it_reversal = FALSE THEN
            giacs408_pkg.ENTRIES_FOR_MISC_INC (var_gl_acct_category,  var_gl_control_acct   ,  
                          var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                          var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                          var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                          var_gl_sub_acct_7   ,  var_intm_type_level   , 
                          var_line_dependency_level  ,
                          var_dr_cr_tag       ,  
                          bce_iss_cd      ,    bce_prem_seq_no    ,
                          bce_branch_cd       ,  bce_acct_line_cd       , 
                          bce_acct_subline_cd ,  bce_acct_intm_cd,
                          v_intm_sl_type_cd,
                          v_gacc_tran_id, p_fund_cd);    
        ELSIF v_is_it_reversal = TRUE THEN
            giacs408_pkg.REV_ENTRIES_FOR_MISC_INC (var_gl_acct_category,  var_gl_control_acct   ,  
                          var_gl_sub_acct_1   ,  var_gl_sub_acct_2     ,
                          var_gl_sub_acct_3   ,  var_gl_sub_acct_4     ,
                          var_gl_sub_acct_5   ,  var_gl_sub_acct_6     ,
                          var_gl_sub_acct_7   ,  var_intm_type_level   , 
                          var_line_dependency_level  ,
                          var_dr_cr_tag       ,  
                          bce_iss_cd      ,    bce_prem_seq_no    ,
                          bce_branch_cd       ,  bce_acct_line_cd       , 
                          bce_acct_subline_cd ,  bce_acct_intm_cd ,
                          v_intm_sl_type_cd,
                          v_gacc_tran_id    , p_fund_cd);    
        END IF;
    END;
    
    PROCEDURE BAE_TAXES_PAYABLE (
        bpr_iss_cd            IN GIPI_INVOICE.iss_cd%type,
        bpr_prem_seq_no        IN GIPI_INVOICE.prem_seq_no%type,
        bpr_branch_cd        IN GIAC_BRANCHES.branch_cd%type     ,
        bpr_acct_line_cd      IN giis_subline.acct_subline_cd%type,    
        bpr_acct_subline_cd IN GIIS_LINE.acct_line_cd%type      ,
        bpr_acct_intm_cd    IN giis_intm_type.acct_intm_cd%type,
        v_is_it_reversal    IN BOOLEAN,
        v_gacc_tran_id      IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd           IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    ) 
    IS
      
      var_gl_acct_category       giac_acct_entries.gl_acct_category%type;
      var_gl_control_acct         giac_acct_entries.gl_control_acct%type;
      var_gl_acct_id         giac_acct_entries.gl_acct_id%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
      var_credit_amt        giac_acct_entries.credit_amt%type;
      var_debit_amt            giac_acct_entries.debit_amt%type;
      var_sl_cd                    giac_acct_entries.sl_cd%type;
      var_branch_cd              giac_acct_entries.gacc_gibr_branch_cd%type;
      var_tax_amt                    gipi_inv_tax.tax_amt%type;
      var_sl_source_cd              giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
      var_sl_type_cd                giac_acct_entries.sl_type_cd%type;
      v_sc_okay              boolean:=FALSE;
    BEGIN
      --del msg_alert('bae_taxes_payable ', 'I',false);
      var_dr_cr_tag := 'C';

      if v_sc_okay = TRUE then
        FOR REC IN
         (SELECT b.b160_tax_cd tax_cd, b.tax_amt
            FROM giac_tax_collns b, giac_acctrans e
           WHERE b.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                              FROM giac_reversals c, giac_acctrans d
                                             WHERE c.reversing_tran_id = d.tran_id
                                                AND d.tran_flag <> 'D')
                 AND b.gacc_tran_id = e.tran_id
                 AND e.tran_flag <> 'D'
             AND b.b160_iss_cd       = bpr_iss_cd
             AND b.b160_prem_seq_no  = bpr_prem_seq_no )
            LOOP
            SELECT  gl_acct_category   ,  gl_control_acct   ,
                gl_sub_acct_1      ,  gl_sub_acct_2     ,
                gl_sub_acct_3      ,  gl_sub_acct_4     ,
                gl_sub_acct_5      ,  gl_sub_acct_6     ,
                gl_sub_acct_7      ,  gl_acct_id
              INTO  var_gl_acct_category,  var_gl_control_acct, 
                var_gl_sub_acct_1   , var_gl_sub_acct_2,
                var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                var_gl_sub_acct_5   , var_gl_sub_acct_6,
                var_gl_sub_acct_7   , var_gl_acct_id
              FROM giac_taxes
             WHERE fund_cd = p_fund_cd
               AND tax_cd = REC.tax_cd;
        
            var_tax_amt := nvl(REC.tax_amt,0);

           IF v_is_it_reversal = FALSE THEN
             GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_credit_amt, var_debit_amt);    
            ELSIF v_is_it_reversal = TRUE THEN        -- For Negative Inclusion
             GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_debit_amt, var_credit_amt);    
           END IF;

             var_sl_cd := REC.tax_cd;
    --msg_alert('1', 'E', false);
             giacs408_pkg.BAE_Insert_Update_Acct_Entries(var_gl_acct_category, var_gl_control_acct  ,
                                                          var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                          var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                          var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                          var_gl_sub_acct_7   , var_sl_cd            ,
                                                          var_gl_acct_id      , bpr_branch_cd        ,
                                                          var_credit_amt      , var_debit_amt        ,
                                                          var_sl_type_cd      , var_sl_source_cd,
                                                          v_gacc_tran_id      , p_fund_cd);         
    --msg_alert('2', 'E', false);

        END LOOP;
      
      else
        FOR REC IN
         (SELECT b.tax_cd, b.tax_amt, a.currency_rt
            FROM gipi_invoice a, gipi_inv_tax b
           WHERE a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND a.iss_cd  = bpr_iss_cd
             AND a.prem_seq_no = bpr_prem_seq_no ) 
        LOOP
      
            SELECT  gl_acct_category   ,  gl_control_acct   ,
                gl_sub_acct_1      ,  gl_sub_acct_2     ,
                gl_sub_acct_3      ,  gl_sub_acct_4     ,
                gl_sub_acct_5      ,  gl_sub_acct_6     ,
                gl_sub_acct_7      ,  gl_acct_id
              INTO  var_gl_acct_category,  var_gl_control_acct, 
                var_gl_sub_acct_1   , var_gl_sub_acct_2,
                var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                var_gl_sub_acct_5   , var_gl_sub_acct_6,
                var_gl_sub_acct_7   , var_gl_acct_id
              FROM giac_taxes
             WHERE fund_cd = p_fund_cd
               AND tax_cd = REC.tax_cd;
        
            var_tax_amt := nvl(REC.tax_amt,0) * nvl(REC.currency_rt,0); 

           IF v_is_it_REVERSAL = FALSE THEN
             GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_credit_amt, var_debit_amt);    
           ELSIF v_is_it_reversal = TRUE THEN        -- For Negative Inclusion
             GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_debit_amt, var_credit_amt);    
           END IF;

         var_sl_cd := REC.tax_cd;

         giacs408_pkg.BAE_Insert_Update_Acct_Entries(var_gl_acct_category, var_gl_control_acct  ,
                                                      var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                      var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                      var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                      var_gl_sub_acct_7   , var_sl_cd            ,
                                                      var_gl_acct_id      , bpr_branch_cd        ,
                                                      var_credit_amt      , var_debit_amt        ,
                                                      var_sl_type_cd      , var_sl_source_cd,
                                                      v_gacc_tran_id      , p_fund_cd);         


        END LOOP;
      end if;
    END;
-------------------------------------------------------------------------------ENDBAE   
    PROCEDURE ENTRIES_FOR_GROSS_PREMIUMS(
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN giac_acctrans.tran_id%TYPE,
        p_fund_cd               IN giac_prev_comm_inv.fund_cd%TYPE
    )
    IS        
        var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
        var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
        var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
        var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
        var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
        var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
        var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
        var_share_percentage   gipi_comm_invoice.share_percentage%type;
        var_intm_no               gipi_comm_invoice.intrmdry_intm_no%type;
        var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;
        var_gl_acct_id         GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
        var_sl_type_cd         GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    
        var_acct_subline_cd    giis_subline.acct_subline_cd%type;
        var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
        var_sl_cd              giac_acct_entries.sl_cd%type;
        var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;
        var_credit_amt         giac_acct_entries.credit_amt%type;
        var_debit_amt            giac_acct_entries.debit_amt%type;
        var_prem_amt           NUMBER(12,2);
        var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
        
        --VARIABLES
        v_ln_subln             giac_sl_types.sl_type_cd%type:= '5';
        v_ln_subln_prl         giac_sl_types.sl_type_cd%type:= '6';
        v_intm_sl_type_cd      GIAC_ACCT_ENTRIES.sl_cd%type;
        v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
        v_sc_prem               gipi_invoice.prem_amt%type;
        v_sc_ratio              gipi_comm_invoice.share_percentage%type:=0;

    BEGIN
         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     


         IF efg_line_dependency_level  != 0 THEN
            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd , 
                            var_gl_sub_acct_1   , var_gl_sub_acct_2,
                            var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                            var_gl_sub_acct_5   , var_gl_sub_acct_6,
                            var_gl_sub_acct_7 );

         END IF;

         IF efg_intm_type_level  != 0 THEN
        
            v_intm_sl_type_cd := var_acct_intm_cd ;

            BAE_Check_Level(efg_intm_type_level , efg_acct_intm_cd  , 
                            var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                            var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                            var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                            var_gl_sub_acct_7   );
         END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                                   var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                   var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                   var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                   var_gl_sub_acct_7   , var_gl_acct_id     ,
                                   var_sl_type_cd);

        IF var_sl_type_cd     = v_ln_subln_prl    then   --'6' THEN
            FOR REC IN(    SELECT peril_cd , a.prem_amt, b.currency_rt
                          FROM gipi_invperil a, gipi_invoice b
                         WHERE a.iss_cd      = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND a.iss_cd = efg_iss_cd
                           AND a.prem_seq_no = efg_prem_seq_no )
            LOOP

              var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);

              IF v_sc_okay then --FALSE 
                 var_prem_amt := var_prem_amt * v_sc_ratio;
              END IF; 
                               
              /*var_sl_cd := to_number(to_char(efg_acct_line_cd,'00')||
                        ltrim(to_char(efg_acct_subline_cd,'00'))||
                        ltrim(to_char(REC.peril_cd,'00')));*/ --comment out by steven 12.10.2014 base on CS version
                        
              var_sl_cd := (efg_acct_line_cd *  100000) + --added by steven 12.10.2014
				           (efg_acct_subline_cd * 1000) +
				           REC.peril_cd;
                   
              GET_DRCR_AMT(efg_drcr_tag, var_prem_amt , var_credit_amt, var_debit_amt);    

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                           var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                           var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                           var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                           var_gl_sub_acct_7   , var_sl_cd            ,
                                                           var_gl_acct_id      , efg_branch_cd        ,
                                                           var_credit_amt      , var_debit_amt        ,
                                                           var_sl_type_cd      , var_sl_source_cd     ,
                                                           v_gacc_tran_id      , p_fund_cd);         

            END LOOP;
        
        ELSIF var_sl_type_cd = v_ln_subln THEN       --'5' THEN

           FOR REC IN(
            SELECT prem_amt, currency_rt
              FROM gipi_invoice
             WHERE iss_cd = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
           LOOP

           var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);
                       
           IF v_sc_okay then
             var_prem_amt := v_sc_prem;
           END IF; 
                         
           GET_DRCR_AMT(efg_drcr_tag, var_prem_amt, var_credit_amt, var_debit_amt);    
                       
           var_sl_cd := to_number(to_char(efg_acct_line_cd,'00')||
                     ltrim(to_char(efg_acct_subline_cd,'00'))||'00');
                      
           giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                        var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                        var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                        var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                        var_gl_sub_acct_7   , var_sl_cd            ,
                                                        var_gl_acct_id      , efg_branch_cd        ,
                                                        var_credit_amt      , var_debit_amt        ,
                                                        var_sl_type_cd      , var_sl_source_cd,
                                                        v_gacc_tran_id      , p_fund_cd );         

           END     LOOP;

        ELSIF var_sl_type_cd IS NULL THEN

           FOR REC IN(
            SELECT prem_amt, currency_rt
              FROM gipi_invoice
             WHERE iss_cd = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
           LOOP

               var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);
                       
                       if v_sc_okay then
                         var_prem_amt := v_sc_prem;
                       end if; 
                         
               GET_DRCR_AMT(efg_drcr_tag, var_prem_amt, var_credit_amt, var_debit_amt);    
                       
               var_sl_cd := NULL;
                      
               giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , efg_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd     ,
                                                         v_gacc_tran_id      , p_fund_cd);         

           END     LOOP;           
               
            ELSE  
               raise_application_error(-20001,'Geniisys Exception#I#S.L. Type is line, subline. ');
          END IF;
    END;
    
    PROCEDURE REV_ENTRIES_FOR_GROSS_PREMIUMS(
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE        
    )--v_intm_sl_type_cd awt
    IS        

    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no               gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id         GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd         GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_prem_amt            gipi_invperil.prem_amt%type;
    var_prem_amt           NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    
    v_ln_subln             giac_sl_types.sl_type_cd%type:= '5';
    v_ln_subln_prl         giac_sl_types.sl_type_cd%type:= '6';
    v_intm_sl_type_cd      GIAC_ACCT_ENTRIES.sl_cd%type;
    v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_prem_paid         gipi_invoice.prem_amt%type;
    v_sc_ratio             gipi_comm_invoice.share_percentage%type:=0;

    BEGIN
         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     


         IF efg_line_dependency_level  != 0 THEN
            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd , 
                            var_gl_sub_acct_1   , var_gl_sub_acct_2,
                            var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                            var_gl_sub_acct_5   , var_gl_sub_acct_6,
                            var_gl_sub_acct_7   );

         END IF;

         IF efg_intm_type_level  != 0 THEN        
            v_intm_sl_type_cd := var_acct_intm_cd ; --vars

            BAE_Check_Level(efg_intm_type_level          , efg_acct_intm_cd  , 
                            var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                            var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                            var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                            var_gl_sub_acct_7   );

         END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                                   var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                   var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                   var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                   var_gl_sub_acct_7   , var_gl_acct_id     ,
                                   var_sl_type_cd       );

        IF var_sl_type_cd     = v_ln_subln_prl then  --'6' THEN --vars
            FOR REC IN(    SELECT peril_cd , a.prem_amt, b.currency_rt
                  FROM gipi_invperil a, gipi_invoice b
                 WHERE a.iss_cd      = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.iss_cd = efg_iss_cd
                   AND a.prem_seq_no = efg_prem_seq_no )
            LOOP

               var_prem_amt := 0;
               if nvl(rec.prem_amt,0) != 0 then
                 var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);
               end if;

               if v_sc_okay then
                 var_prem_amt := var_prem_amt * v_sc_ratio;
               end if; 
                               
               /*var_sl_cd := to_number(to_char(efg_acct_line_cd,'00')||
                            ltrim(to_char(efg_acct_subline_cd,'00'))||
                            ltrim(to_char(REC.peril_cd,'00')));*/ --comment-out by steven 12.10.2014 base on CS version
               var_sl_cd := (efg_acct_line_cd * 100000)   + --added by steven 12.10.2014
			                (efg_acct_subline_cd *  1000) +
			                REC.peril_cd;              
                   
               GET_DRCR_AMT(efg_drcr_tag, var_prem_amt , var_debit_amt, var_credit_amt );    

               giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                          var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                          var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                          var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                          var_gl_sub_acct_7   , var_sl_cd            ,
                                                          var_gl_acct_id      , efg_branch_cd        ,
                                                          var_credit_amt      , var_debit_amt        ,
                                                          var_sl_type_cd      , var_sl_source_cd     ,
                                                          v_gacc_tran_id      , p_fund_cd);         
            END LOOP;
        
        ELSIF var_sl_type_cd   = v_ln_subln then  --'5' THEN

           FOR REC IN(
            SELECT prem_amt, currency_rt
              FROM gipi_invoice
             WHERE iss_cd = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
           LOOP

               IF nvl(rec.prem_amt,0) != 0 then
                  var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);
               END IF;      

               IF v_sc_okay then
                 var_prem_amt := v_sc_prem_paid; --variables.sc_prem;
               END IF; 
                         
              GET_DRCR_AMT(efg_drcr_tag, var_prem_amt, var_debit_amt, var_credit_amt );    

              var_sl_cd := to_number(to_char(efg_acct_line_cd,'00')||
                         ltrim(to_char(efg_acct_subline_cd,'00'))||'00');

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , efg_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd    ,
                                                         v_gacc_tran_id      , p_fund_cd);         

           END     LOOP;

        ELSIF var_sl_type_cd IS NULL THEN

           FOR REC IN(
            SELECT prem_amt, currency_rt
              FROM gipi_invoice
             WHERE iss_cd = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
           LOOP

                       if nvl(rec.prem_amt,0) != 0 then
                 var_prem_amt := nvl(REC.prem_amt,0) * nvl(REC.currency_rt,1);
                       end if;      

                       if v_sc_okay then
                         var_prem_amt := v_sc_prem_paid; --variables.sc_prem;
                       end if; 
                         
                      GET_DRCR_AMT(efg_drcr_tag, var_prem_amt, var_debit_amt, var_credit_amt );    

                var_sl_cd := NULL;

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , efg_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd     ,
                                                         v_gacc_tran_id      , p_fund_cd);         

           END     LOOP;

            ELSE  
               raise_application_error(-20001,'Geniisys Exception#I#S.L. Type is line, subline. ');
          END IF;
    END;
    
    PROCEDURE ENTRIES_FOR_PREMIUM_RECEIVABLE (
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type       ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    )
    IS        

    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no               gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id         GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd         GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_comm_amt            gipi_comm_inv_peril.commission_amt%type;
    var_comm_amt           NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    
    v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_prem_recv         gipi_invoice.prem_amt%type;
    v_sc_prem               gipi_invoice.prem_amt%type;
    v_assd_no        GIPI_POLBASIC.assd_no%type; 
    BEGIN

         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     

         IF efg_line_dependency_level  != 0 THEN
            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd ,     
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;


         IF efg_intm_type_level  != 0 THEN
        
            BAE_Check_Level(efg_intm_type_level , efg_acct_intm_cd        , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );


        IF v_prem_rec_gross_tag = 'Y' THEN
          IF var_sl_type_cd = '1' THEN
               
            FOR REC IN( SELECT nvl(prem_amt,0) + nvl(tax_amt,0)+ 
                               nvl(other_charges,0) + nvl(notarial_fee,0) tot_amt, 
                               currency_rt
                          FROM gipi_invoice
                         WHERE iss_cd    = efg_iss_cd
                           AND prem_seq_no = efg_prem_seq_no) 
            LOOP
               var_comm_amt := nvl(REC.tot_amt,0) * nvl(REC.currency_rt,0);
                       
               IF v_sc_okay then --vars
                 var_comm_amt := v_sc_prem_recv;
               END IF;  
                               
               GET_DRCR_AMT(efg_drcr_tag, var_comm_amt, var_credit_amt, var_debit_amt);    

               var_sl_cd  := v_assd_no; --vars
               
               giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , efg_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd,
                                                         v_gacc_tran_id      , p_fund_cd);         

            END LOOP;
        
          ELSE
            raise_application_error(-20001,'Geniisys Exception#I#SL Type Code is not assured.');
          END IF;
        
        ELSIF  v_prem_rec_gross_tag = 'N' THEN
        
            IF var_sl_type_cd = '1' THEN
                FOR REC IN(SELECT nvl(prem_amt,0) premium_amt, currency_rt
                         FROM gipi_invoice
                        WHERE iss_cd    = efg_iss_cd
                          AND prem_seq_no = efg_prem_seq_no) 
                LOOP

                   var_comm_amt := nvl(REC.premium_amt,0) * nvl(REC.currency_rt,0);
                                      
                   IF v_sc_okay then --ariables.
                     var_comm_amt := v_sc_prem; --ariables.
                   END IF;  
                                    
                   GET_DRCR_AMT(efg_drcr_tag, var_comm_amt , var_credit_amt, var_debit_amt);    

                   var_sl_cd  := v_assd_no;
                   
                   giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , efg_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);    

                END LOOP;     
            ELSE
                raise_application_error(-20001,'Geniisys Exception#I#SL Type Code is not assured. ');
            END IF;
        END IF;
    END;
    
    PROCEDURE REV_ENTRIES_FOR_PREMIUM_RECEIV (
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type       ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    ) 
    IS
    
    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no           gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;
    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    
    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;
    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;
    --var_comm_amt            gipi_comm_inv_peril.commission_amt%type;
    var_comm_amt           gipi_comm_inv_peril.commission_amt%type;
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    v_sc_okay              boolean:=FALSE; --from -variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_prem_recv         gipi_invoice.prem_amt%type;
    v_assd_no               GIPI_POLBASIC.assd_no%type ; 
    
    BEGIN
         
         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     

         IF efg_line_dependency_level  != 0 THEN
            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd ,     
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;


         IF efg_intm_type_level  != 0 THEN
        
            BAE_Check_Level(efg_intm_type_level , efg_acct_intm_cd        , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );


        IF v_prem_rec_gross_tag = 'Y' THEN
            
            IF var_sl_type_cd = '1' THEN
                FOR REC IN(
                        SELECT nvl(prem_amt,0) + nvl(tax_amt,0)+ 
                                       nvl(other_charges,0) + nvl(notarial_fee,0) tot_amt, 
                                       currency_rt
                          FROM gipi_invoice
                         WHERE iss_cd    = efg_iss_cd
                           AND prem_seq_no = efg_prem_seq_no) 
                LOOP

                   IF nvl(rec.tot_amt,0) != 0 THEN
                        var_comm_amt := nvl(REC.tot_amt,0) * nvl(REC.currency_rt,1);
                   END IF;

                   IF v_sc_okay then --vars
                        var_comm_amt := v_sc_prem_recv;
                   END IF;
                                          
                   GET_DRCR_AMT(efg_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                   var_sl_cd  := v_assd_no; --vars wala nmng value sa fmb :-/
                   giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                                 var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                                 var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                                 var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                                 var_gl_sub_acct_7   , var_sl_cd            ,
                                                                 var_gl_acct_id      , efg_branch_cd        ,
                                                                 var_credit_amt      , var_debit_amt        ,
                                                                 var_sl_type_cd      , var_sl_source_cd,
                                                                 v_gacc_tran_id      , p_fund_cd);         

                END LOOP;
            ELSE
                raise_application_error(-20001,'Geniisys Exception#I#SL Type Code is not assured. ');
            END IF;

        ELSIF  v_prem_rec_gross_tag = 'N' THEN
            IF var_sl_type_cd = '1' THEN
                FOR REC IN(SELECT nvl(prem_amt,0) premium_amt, currency_rt
                         FROM gipi_invoice
                        WHERE iss_cd    = efg_iss_cd
                          AND prem_seq_no = efg_prem_seq_no) 
                LOOP

                   if nvl(rec.premium_amt,0) != 0 then
                      var_comm_amt := nvl(REC.premium_amt,0) * nvl(REC.currency_rt,1);
                   end if;
             
                   if v_sc_okay then
                      var_comm_amt := v_sc_prem_recv;  --variables.sc_prem;
                   end if;
                               
                   GET_DRCR_AMT(efg_drcr_tag, var_comm_amt , var_debit_amt, var_credit_amt);    

                   var_sl_cd  := v_assd_no; --variables
                   
                   giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                                var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                                var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                                var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                                var_gl_sub_acct_7   , var_sl_cd            ,
                                                                var_gl_acct_id      , efg_branch_cd        ,
                                                                var_credit_amt      , var_debit_amt        ,
                                                                var_sl_type_cd      , var_sl_source_cd,
                                                                v_gacc_tran_id      , p_fund_cd);    


                END LOOP;     
            ELSE
                raise_application_error(-20001,'Geniisys Exception#I#SL Type Code is not assured. ');
            END IF;
        END IF;
    END;
    
    PROCEDURE entries_for_commission_payable (
      ecp_gl_acct_category        IN   giac_module_entries.gl_acct_category%TYPE,
      ecp_gl_control_acct         IN   giac_module_entries.gl_control_acct%TYPE,
      ecp_gl_sub_acct_1           IN   giac_module_entries.gl_sub_acct_1%TYPE,
      ecp_gl_sub_acct_2           IN   giac_module_entries.gl_sub_acct_2%TYPE,
      ecp_gl_sub_acct_3           IN   giac_module_entries.gl_sub_acct_3%TYPE,
      ecp_gl_sub_acct_4           IN   giac_module_entries.gl_sub_acct_4%TYPE,
      ecp_gl_sub_acct_5           IN   giac_module_entries.gl_sub_acct_5%TYPE,
      ecp_gl_sub_acct_6           IN   giac_module_entries.gl_sub_acct_6%TYPE,
      ecp_gl_sub_acct_7           IN   giac_module_entries.gl_sub_acct_7%TYPE,
      ecp_intm_type_level         IN   giac_module_entries.intm_type_level%TYPE,
      ecp_line_dependency_level   IN   giac_module_entries.line_dependency_level%TYPE,
      ecp_drcr_tag                IN   giac_module_entries.dr_cr_tag%TYPE,
      ecp_iss_cd                  IN   gipi_invoice.iss_cd%TYPE,
      ecp_prem_seq_no             IN   gipi_invoice.prem_seq_no%TYPE,
      ecp_branch_cd               IN   giac_branches.branch_cd%TYPE,
      ecp_acct_line_cd            IN   giis_subline.acct_subline_cd%TYPE,
      ecp_acct_subline_cd         IN   giis_line.acct_line_cd%TYPE,
      ecp_acct_intm_cd            IN   giis_intm_type.acct_intm_cd%TYPE,
      v_gacc_tran_id              IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd                   IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE)
    IS
      var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
      var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
      var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
      var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
      var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
      var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
      var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
      var_share_percentage   gipi_comm_invoice.share_percentage%TYPE;
      var_intm_no            gipi_comm_invoice.intrmdry_intm_no%TYPE;
      var_acct_intm_cd       giis_intm_type.acct_intm_cd%TYPE;
      var_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
      var_sl_type_cd         giac_chart_of_accts.gslt_sl_type_cd%TYPE;
      var_acct_subline_cd    giis_subline.acct_subline_cd%TYPE;
      var_acct_line_cd       giis_line.acct_line_cd%TYPE;
      var_sl_cd              giac_acct_entries.sl_cd%TYPE;
      var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%TYPE;
      var_credit_amt         giac_acct_entries.credit_amt%TYPE;
      var_debit_amt          giac_acct_entries.debit_amt%TYPE;
    --var_comm_amt           gipi_comm_inv_peril.commission_amt%type;
      var_comm_amt           NUMBER (12, 2);
      var_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE          := '1'; -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
      v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
      v_sc_ratio             gipi_comm_invoice.share_percentage%type:=0;
    BEGIN
      var_gl_sub_acct_1 := ecp_gl_sub_acct_1;
      var_gl_sub_acct_2 := ecp_gl_sub_acct_2;
      var_gl_sub_acct_3 := ecp_gl_sub_acct_3;
      var_gl_sub_acct_4 := ecp_gl_sub_acct_4;
      var_gl_sub_acct_5 := ecp_gl_sub_acct_5;
      var_gl_sub_acct_6 := ecp_gl_sub_acct_6;
      var_gl_sub_acct_7 := ecp_gl_sub_acct_7;

      IF ecp_line_dependency_level != 0 THEN
         bae_check_level (ecp_line_dependency_level,
                          ecp_acct_line_cd,
                          var_gl_sub_acct_1,
                          var_gl_sub_acct_2,
                          var_gl_sub_acct_3,
                          var_gl_sub_acct_4,
                          var_gl_sub_acct_5,
                          var_gl_sub_acct_6,
                          var_gl_sub_acct_7);
      END IF;

      /**
      *** Intermediary Code was determined in ENTRIES FOR GROSS COMMISISION
      **/
      IF ecp_intm_type_level != 0 THEN
         bae_check_level (ecp_intm_type_level,
                          ecp_acct_intm_cd,
                          var_gl_sub_acct_1,
                          var_gl_sub_acct_2,
                          var_gl_sub_acct_3,
                          var_gl_sub_acct_4,
                          var_gl_sub_acct_5,
                          var_gl_sub_acct_6,
                          var_gl_sub_acct_7);
      END IF;

      bae_check_chart_of_accts (ecp_gl_acct_category,
                                ecp_gl_control_acct,
                                var_gl_sub_acct_1,
                                var_gl_sub_acct_2,
                                var_gl_sub_acct_3,
                                var_gl_sub_acct_4,
                                var_gl_sub_acct_5,
                                var_gl_sub_acct_6,
                                var_gl_sub_acct_7,
                                var_gl_acct_id,
                                var_sl_type_cd);

      IF var_sl_type_cd = '3' THEN
        FOR REC IN (
                 SELECT sum( nvl(a.commission_amt,0) ) comm_amt, 
                                b.currency_rt, a.intrmdry_intm_no intm_no,
                                a.parent_intm_no --added by reymon 07172013
              FROM gipi_comm_invoice a, gipi_invoice b 
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd      = ecp_iss_cd
               AND a.prem_seq_no = ecp_prem_seq_no
             GROUP BY b.currency_rt, a.intrmdry_intm_no, a.parent_intm_no) --added by reymon 07172013
        LOOP
          var_comm_amt := 0;

          IF nvl(rec.comm_amt,0) != 0 THEN
            var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
          END IF;
              
          IF v_sc_okay THEN
            var_comm_amt := var_comm_amt * v_sc_ratio;
          END IF;
              
          GET_DRCR_AMT(ecp_drcr_tag, var_comm_amt, var_credit_amt ,var_debit_amt);    

          --var_sl_cd   := variables.v_parent_intm_no;   --REC.intm_no;
          --var_sl_cd   := REC.intm_no; commented out and changed below by reymon 07172013
          var_sl_cd   := NVL(rec.parent_intm_no, rec.intm_no);

          giacs408_pkg.BAE_Insert_Update_Acct_Entries(ecp_gl_acct_category, ecp_gl_control_acct  ,
                                                        var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                        var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                        var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                        var_gl_sub_acct_7   , var_sl_cd            ,
                                                        var_gl_acct_id      , ecp_branch_cd        ,
                                                        var_credit_amt      , var_debit_amt        ,
                                                        var_sl_type_cd      , var_sl_source_cd,
                                                        v_gacc_tran_id      , p_fund_cd);         
        END LOOP;

            -- for overriding commission
        /*
	    ** Commented out by reymon 07172013
	    ** AC-SPECS-2013-081
        FOR REC IN ( 
                 SELECT sum(a.commission_amt) comm_amt, 
                                b.currency_rt, a.intm_no
              FROM giac_parent_comm_invoice a, gipi_invoice b 
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd      = ecp_iss_cd
               AND a.prem_seq_no = ecp_prem_seq_no
             GROUP BY b.currency_rt, a.intm_no)
        LOOP

          var_comm_amt := 0;
          if nvl(rec.comm_amt,0) != 0 then
            var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
          end if;
              
          if v_sc_okay then --ariables.
            var_comm_amt := var_comm_amt* v_sc_ratio; --ariables.
          end if;
              
          GET_DRCR_AMT(ecp_drcr_tag, var_comm_amt, var_credit_amt ,var_debit_amt);    

          --var_sl_cd   := variables.v_parent_intm_no;   --REC.intm_no;
          var_sl_cd   := REC.intm_no;

          giacs408_pkg.BAE_Insert_Update_Acct_Entries(ecp_gl_acct_category, ecp_gl_control_acct  ,
                                                     var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                     var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                     var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                     var_gl_sub_acct_7   , var_sl_cd            ,
                                                     var_gl_acct_id      , ecp_branch_cd        ,
                                                     var_credit_amt      , var_debit_amt        ,
                                                     var_sl_type_cd      , var_sl_source_cd,
                                                     v_gacc_tran_id      , p_fund_cd);         
        END LOOP;*/

      ELSE
        raise_application_error(-20001,'Geniisys Exception#I#SL type code != 3 ');
      END IF;
    END;
    
    PROCEDURE REV_ENTRIES_FOR_COMMISSION_PAY(
        ecp_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ecp_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ecp_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ecp_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ecp_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ecp_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ecp_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ecp_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ecp_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ecp_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ecp_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ecp_drcr_tag            IN giac_module_entries.dr_cr_tag%type       ,
        ecp_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        ecp_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        ecp_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        ecp_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        ecp_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ecp_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    ) 
    IS
    
    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no               gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_comm_amt            gipi_comm_inv_peril.commission_amt%type;
    var_comm_amt           NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_ratio             gipi_comm_invoice.share_percentage%type:=0; 
    BEGIN
      

         var_gl_sub_acct_1 := ecp_gl_sub_acct_1;     
         var_gl_sub_acct_2 := ecp_gl_sub_acct_2;     
         var_gl_sub_acct_3 := ecp_gl_sub_acct_3;     
         var_gl_sub_acct_4 := ecp_gl_sub_acct_4;     
         var_gl_sub_acct_5 := ecp_gl_sub_acct_5;     
         var_gl_sub_acct_6 := ecp_gl_sub_acct_6;     
         var_gl_sub_acct_7 := ecp_gl_sub_acct_7;     

         IF ecp_line_dependency_level  != 0 THEN


            BAE_Check_Level(ecp_line_dependency_level, ecp_acct_line_cd , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

    /**
    *** Intermediary Code was determined in ENTRIES FOR GROSS COMMISISION
    **/

        IF ecp_intm_type_level  != 0 THEN

            BAE_Check_Level(ecp_intm_type_level , ecp_acct_intm_cd , 
            var_gl_sub_acct_1   , var_gl_sub_acct_2,
            var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
            var_gl_sub_acct_5   , var_gl_sub_acct_6,
            var_gl_sub_acct_7   );

        END IF;


         BAE_Check_Chart_Of_Accts( ecp_gl_acct_category, ecp_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );


         IF var_sl_type_cd = '3' THEN
            FOR REC IN (
                     SELECT sum( nvl(a.commission_amt,0) ) comm_amt, 
                                    b.currency_rt, a.intrmdry_intm_no intm_no,
                                    a.parent_intm_no --added by steven 12.10.2014 base on CS version
                  FROM gipi_comm_invoice a, gipi_invoice b 
                 WHERE a.iss_cd      = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.iss_cd      = ecp_iss_cd
                   AND a.prem_seq_no = ecp_prem_seq_no
                 GROUP BY b.currency_rt, a.intrmdry_intm_no, a.parent_intm_no) --added by reymon 07172013
            LOOP
              var_comm_amt := 0;

              if nvl(rec.comm_amt,0) != 0 then
                var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
              end if;
              
              if v_sc_okay then
                var_comm_amt := var_comm_amt * v_sc_ratio;
              end if;
              
              GET_DRCR_AMT(ecp_drcr_tag, var_comm_amt, var_debit_amt ,var_credit_amt);    

              --var_sl_cd   := REC.intm_no;
              var_sl_cd   := NVL(rec.parent_intm_no, rec.intm_no); --added by steven 12.11.2014 base on CS version

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(ecp_gl_acct_category, ecp_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , ecp_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd,
                                                         v_gacc_tran_id     , p_fund_cd);         
            END LOOP;

            -- for overriding commission
            /*
	        ** Commented out by reymon 07172013
	        ** AC-SPECS-2013-081
            FOR REC IN ( 
                     SELECT sum(a.commission_amt) comm_amt, 
                                    b.currency_rt, a.intm_no
                  FROM giac_parent_comm_invoice a, gipi_invoice b 
                 WHERE a.iss_cd      = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.iss_cd      = ecp_iss_cd
                   AND a.prem_seq_no = ecp_prem_seq_no
                 GROUP BY b.currency_rt, a.intm_no)
            LOOP

              var_comm_amt := 0;
              if nvl(rec.comm_amt,0) != 0 then
                var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
              end if;
                  
              if v_sc_okay then
                var_comm_amt := var_comm_amt * v_sc_ratio;
              end if;
                  
              GET_DRCR_AMT(ecp_drcr_tag, var_comm_amt, var_debit_amt ,var_credit_amt);    

              --var_sl_cd   := variables.v_parent_intm_no;   --REC.intm_no;
              var_sl_cd   := REC.intm_no;

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(ecp_gl_acct_category, ecp_gl_control_acct  ,
                                                           var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                           var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                           var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                           var_gl_sub_acct_7   , var_sl_cd            ,
                                                           var_gl_acct_id      , ecp_branch_cd        ,
                                                           var_credit_amt      , var_debit_amt        ,
                                                           var_sl_type_cd      , var_sl_source_cd,
                                                           v_gacc_tran_id     , p_fund_cd);         
            END LOOP;*/
         ELSE
           raise_application_error(-20001,'Geniisys Exception#I#SL type code != 3 ');
         END IF;
    END;
    
    PROCEDURE ENTRIES_FOR_COMMISSION_EXPENSE(
        ece_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ece_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ece_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ece_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ece_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ece_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ece_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ece_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ece_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ece_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ece_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ece_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        ece_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        ece_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        ece_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        ece_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        ece_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ece_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_branch_cd             IN giac_new_comm_inv.branch_cd%TYPE
    )
    IS
    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no           gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_comm_amt            gipi_comm_inv_peril.commission_amt%type;
    var_comm_amt        NUMBER(12,2);
    var_comm_amt2        NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_ratio             gipi_comm_invoice.share_percentage%type:=0;
    BEGIN
      
      var_gl_sub_acct_1 := ece_gl_sub_acct_1;     
      var_gl_sub_acct_2 := ece_gl_sub_acct_2;     
      var_gl_sub_acct_3 := ece_gl_sub_acct_3;     
      var_gl_sub_acct_4 := ece_gl_sub_acct_4;     
      var_gl_sub_acct_5 := ece_gl_sub_acct_5;     
      var_gl_sub_acct_6 := ece_gl_sub_acct_6;     
      var_gl_sub_acct_7 := ece_gl_sub_acct_7;     

      IF ece_line_dependency_level  != 0 THEN
      
         BAE_Check_Level(ece_line_dependency_level, ece_acct_line_cd ,
                         var_gl_sub_acct_1   , var_gl_sub_acct_2,
                         var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                         var_gl_sub_acct_5   , var_gl_sub_acct_6,
                         var_gl_sub_acct_7   );
      
      END IF;
      
      IF ece_intm_type_level  != 0 THEN
          
        BAE_Check_Level(ece_intm_type_level , ece_acct_intm_cd       , 
                        var_gl_sub_acct_1   , var_gl_sub_acct_2,
                        var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                        var_gl_sub_acct_5   , var_gl_sub_acct_6,
                        var_gl_sub_acct_7   );
      
      END IF;
      
      BAE_Check_Chart_Of_Accts(ece_gl_acct_category, ece_gl_control_acct, 
                               var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                               var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                               var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                               var_gl_sub_acct_7   , var_gl_acct_id     ,
                               var_sl_type_cd       );
      
      IF var_sl_type_cd  = '6' THEN
           
        FOR REC IN(SELECT b.commission_amt comm_amt, b.peril_cd, a.currency_rt,
                          b.comm_rec_id, b.intm_no intm_no, b.comm_peril_id 
                     FROM gipi_invoice a, giac_new_comm_inv_peril b
                    WHERE a.iss_cd      = b.iss_cd
                      AND a.prem_seq_no =  b.prem_seq_no
                      AND b.tran_flag   = 'U'
                      and nvl(b.delete_sw, 'N') = 'N' 
                      AND a.iss_cd      = ece_iss_cd
                      and b.fund_cd = p_fund_cd
                      and b.branch_cd = p_branch_cd
                      AND a.prem_seq_no = ece_prem_seq_no)
        LOOP
          var_comm_amt := 0;
          
          /*
          ** Commented out by reymon 07172013
		  ** AC-SPECS-2013-081
          for rec2 in (select sum(commission_amt) comm_amt
                         from giac_parent_comm_invprl
                        where chld_intm_no  = rec.intm_no
                          and peril_cd      = rec.peril_cd
                          and iss_cd        = ece_iss_cd
                          and prem_seq_no   = ece_prem_seq_no)
          loop
            var_comm_amt := nvl(rec2.comm_amt,0); 
          end loop;*/
         
          var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,0);
          
          if v_sc_okay then
            var_comm_amt := var_comm_amt*v_sc_ratio;
          end if;
          
          --vondanix 08132014 : consolidation of ver. 07/04/2014 and 07/10/2014       
          /*var_sl_cd := to_number(to_char(ece_acct_line_cd ,'00')||
                       ltrim(to_char(ece_acct_subline_cd  ,'00'))||
                       ltrim(to_char(REC.peril_cd,'00')));*/ --comment out by steven 12.10.2014 base on CS version
          var_sl_cd := (ece_acct_line_cd * 100000) + --added by steven 12.10.2014
                       (ece_acct_subline_cd * 1000) +
                       REC.peril_cd;            
          
          GET_DRCR_AMT(ece_drcr_tag, var_comm_amt , var_credit_amt, var_debit_amt);    
           
          giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                         var_gl_acct_id      , ece_branch_cd        ,
                                         var_credit_amt      , var_debit_amt        ,
                                         var_sl_type_cd      , var_sl_source_cd,
                                         v_gacc_tran_id, p_fund_cd);         
        END LOOP;
             
      ELSIF var_sl_type_cd   = '5' THEN
      
        FOR REC IN(SELECT commission_amt comm_amt, a.currency_rt,
                          b.intm_no, b.comm_rec_id 
                     FROM gipi_invoice a, giac_new_comm_inv b
                    WHERE a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.tran_flag   = 'U'
                      AND nvl(b.delete_sw, 'N') = 'N' 
                      and b.fund_cd = p_fund_cd
                      and b.branch_cd = p_branch_cd
                      AND a.iss_cd         = ece_iss_cd
                      AND a.prem_seq_no = ece_prem_seq_no)
        LOOP
          var_comm_amt := 0;
          
          /*
          ** Commented out by reymon 07172013
	      ** AC-SPECS-2013-081
          for rec2 in (select sum(commission_amt) comm_amt
                         from giac_parent_comm_invoice
                        where chld_intm_no  = rec.intm_no
                          and iss_cd        = ece_iss_cd
                          and prem_seq_no   = ece_prem_seq_no)
          loop
            var_comm_amt := nvl(rec2.comm_amt,0); 
          end loop;*/
          
          var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,0);
           
          if v_sc_okay then
            var_comm_amt := var_comm_amt*v_sc_ratio;
          end if;
            
          GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_credit_amt, var_debit_amt);    
           
          var_sl_cd := to_number(to_char(ece_acct_line_cd,'00')||
                   ltrim(to_char(ece_acct_subline_cd,'00'))||'00');
          
          giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                         var_gl_acct_id      , ece_branch_cd        ,
                                         var_credit_amt      , var_debit_amt        ,
                                         var_sl_type_cd      , var_sl_source_cd,
                                         v_gacc_tran_id, p_fund_cd);         
              
        END LOOP;
        
      ELSIF var_sl_type_cd   = '3' THEN

           FOR REC IN(SELECT sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt, 
                                 b.intrmdry_intm_no intm_no,
                                 b.parent_intm_no --Added by reymon 07172013
              FROM gipi_invoice a, gipi_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no
                     group by a.currency_rt, b.intrmdry_intm_no, b.parent_intm_no)--added by reymon 07172013
               LOOP
                  var_comm_amt := 0;
    /*
                  for rec2 in (select sum(commission_amt) comm_amt
                                 from giac_parent_comm_invoice
                                where chld_intm_no = rec.intm_no
                                  and iss_cd       = ece_iss_cd
                                  and prem_seq_no  = ece_prem_seq_no)
                  loop
                    var_comm_amt := nvl(rec2.comm_amt,0); 
                  end loop;                     
    */
                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_credit_amt, var_debit_amt);    

                  var_sl_cd := rec.intm_no;

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;
               /* for overriding commission */
           /*
	       ** Commented out by reymon 07172013
	 	   ** AC-SPECS-2013-081
           FOR REC IN(
                     SELECT  sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt, 
                                 b.intm_no
              FROM gipi_invoice a, giac_parent_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no 
                     group by a.currency_rt, b.intm_no)
               LOOP
                  var_comm_amt := 0;
                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(rec.currency_rt,1) ;
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_credit_amt, var_debit_amt);    

                  var_sl_cd := rec.intm_no;

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;*/

      ELSIF var_sl_type_cd IS NULL THEN       
        FOR REC IN(SELECT commission_amt comm_amt, a.currency_rt,
                          b.intm_no, b.comm_rec_id 
                     FROM gipi_invoice a, giac_new_comm_inv b
                    WHERE a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.tran_flag   = 'U'
                      AND nvl(b.delete_sw, 'N') = 'N' 
                      and b.fund_cd = p_fund_cd
                      and b.branch_cd = p_branch_cd
                      AND a.iss_cd         = ece_iss_cd
                      AND a.prem_seq_no = ece_prem_seq_no)
        LOOP
          var_comm_amt := 0;
          /*
          ** Commented out by reymon 07172013
		  ** AC-SPECS-2013-081
          for rec2 in (select sum(commission_amt) comm_amt
                         from giac_parent_comm_invoice
                        where chld_intm_no  = rec.intm_no
                          and iss_cd        = ece_iss_cd
                          and prem_seq_no   = ece_prem_seq_no)
          loop
            var_comm_amt := nvl(rec2.comm_amt,0); 
          end loop;*/
          
          var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,0);
           
          if v_sc_okay then
            var_comm_amt := var_comm_amt*v_sc_ratio;
          end if;
            
          GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_credit_amt, var_debit_amt);    
           
          var_sl_cd := NULL;
          
          giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                     var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                     var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                     var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                     var_gl_sub_acct_7   , var_sl_cd            ,
                                                     var_gl_acct_id      , ece_branch_cd        ,
                                                     var_credit_amt      , var_debit_amt        ,
                                                     var_sl_type_cd      , var_sl_source_cd     ,
                                                     v_gacc_tran_id      , p_fund_cd);         
              
        END LOOP;
                       
      ELSE  
        raise_application_error(-20001,'Geniisys Exception#I#S.L. Type is not in line, subline. ');
      END IF;
    END;
    
    PROCEDURE REV_ENTRIES_FOR_COMMISSION_EXP(
        ece_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        ece_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        ece_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        ece_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        ece_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        ece_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        ece_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        ece_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        ece_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        ece_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        ece_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        ece_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        ece_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        ece_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        ece_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        ece_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        ece_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        ece_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE   
    ) 
    IS

    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no           gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;
    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    
    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;
    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;
    var_comm_amt        NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    
    v_sc_okay              boolean:=FALSE; --from variables walang ibang nagset ng value sa kanya sa fmb :-/
    v_sc_ratio             gipi_comm_invoice.share_percentage%type:=0;
     
    BEGIN
      
         var_gl_sub_acct_1 := ece_gl_sub_acct_1;     
         var_gl_sub_acct_2 := ece_gl_sub_acct_2;     
         var_gl_sub_acct_3 := ece_gl_sub_acct_3;     
         var_gl_sub_acct_4 := ece_gl_sub_acct_4;     
         var_gl_sub_acct_5 := ece_gl_sub_acct_5;     
         var_gl_sub_acct_6 := ece_gl_sub_acct_6;     
         var_gl_sub_acct_7 := ece_gl_sub_acct_7;     

         IF ece_line_dependency_level  != 0 THEN


            BAE_Check_Level(ece_line_dependency_level, ece_acct_line_cd ,
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

         IF ece_intm_type_level  != 0 THEN
        
        BAE_Check_Level(ece_intm_type_level , ece_acct_intm_cd       , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;


         BAE_Check_Chart_Of_Accts( ece_gl_acct_category, ece_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );

        IF var_sl_type_cd     = '6' THEN
            FOR REC IN(    SELECT sum(nvl(b.commission_amt,0)) comm_amt, b.peril_cd, 
                                   a.currency_rt --, b.intrmdry_intm_no intm_no
                  FROM gipi_invoice a, gipi_comm_inv_peril b
                 WHERE a.iss_cd      = b.iss_cd
                   AND a.prem_seq_no =  b.prem_seq_no
                           AND a.iss_cd         = ece_iss_cd
                   AND a.prem_seq_no = ece_prem_seq_no
                            group by b.peril_cd, a.currency_rt )
                LOOP
                  var_comm_amt := 0;

                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  /*var_sl_cd := to_number(to_char(ece_acct_line_cd ,'00')||
                               ltrim(to_char(ece_acct_subline_cd  ,'00'))||
                               ltrim(to_char(REC.peril_cd,'00')));*/ --comment out by steven 12.10.2014
                  var_sl_cd := (ece_acct_line_cd * 100000) + --added by steven 12.10.2014
                               (ece_acct_subline_cd * 1000)+
                               REC.peril_cd;            

                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt , var_debit_amt, var_credit_amt);    

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;
               /*  for overriding commission */
             /*
  	        ** Commented out by reymon 07172013
			** AC-SPECS-2013-081
            FOR REC IN(    
                   SELECT sum(nvl(b.commission_amt,0)) comm_amt, b.peril_cd, 
                                   a.currency_rt --, b.intrmdry_intm_no intm_no
                  FROM gipi_invoice a, giac_parent_comm_invprl b
                 WHERE a.iss_cd      = b.iss_cd
                   AND a.prem_seq_no =  b.prem_seq_no
                           AND a.iss_cd         = ece_iss_cd
                   AND a.prem_seq_no = ece_prem_seq_no
                             group by b.peril_cd, a.currency_rt)
                LOOP
                  var_comm_amt := 0;

                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  var_sl_cd := to_number(to_char(ece_acct_line_cd ,'00')||
                               ltrim(to_char(ece_acct_subline_cd  ,'00'))||
                               ltrim(to_char(REC.peril_cd,'00')));

                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt , var_debit_amt, var_credit_amt);    

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                               var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                               var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                               var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                               var_gl_sub_acct_7   , var_sl_cd            ,
                                                               var_gl_acct_id      , ece_branch_cd        ,
                                                               var_credit_amt      , var_debit_amt        ,
                                                               var_sl_type_cd      , var_sl_source_cd,
                                                               v_gacc_tran_id      , p_fund_cd);         

               END LOOP;*/

        
        ELSIF var_sl_type_cd   = '5' THEN

           FOR REC IN(SELECT sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt 
                                 --b.intrmdry_intm_no intm_no
              FROM gipi_invoice a, gipi_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no
                     group by a.currency_rt)
               LOOP
                  var_comm_amt := 0;
    /*
                  for rec2 in (select sum(commission_amt) comm_amt
                                 from giac_parent_comm_invoice
                                where chld_intm_no = rec.intm_no
                                  and iss_cd       = ece_iss_cd
                                  and prem_seq_no  = ece_prem_seq_no)
                  loop
                    var_comm_amt := nvl(rec2.comm_amt,0); 
                  end loop;                     
    */
                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                  var_sl_cd := to_number(to_char(ece_acct_line_cd,'00')||
                               ltrim(to_char(ece_acct_subline_cd,'00'))||'00');

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;
               /* for overriding commission */
           /*
	       ** Commented out by reymon 07172013
		   ** AC-SPECS-2013-081
           FOR REC IN(
                     SELECT  sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt 
                                 --b.intrmdry_intm_no intm_no
              FROM gipi_invoice a, giac_parent_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no 
                     group by a.currency_rt)
               LOOP
                  var_comm_amt := 0;
                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(rec.currency_rt,1) ;
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                  var_sl_cd := to_number(to_char(ece_acct_line_cd,'00')||
                               ltrim(to_char(ece_acct_subline_cd,'00'))||'00');

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd     ,
                                                             v_gacc_tran_id      , p_fund_cd);         

        END LOOP;*/

        ELSIF var_sl_type_cd   = '3' THEN

           FOR REC IN(SELECT sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt, 
                                 b.intrmdry_intm_no intm_no,
                                 b.parent_intm_no --added by reymon 07172013
              FROM gipi_invoice a, gipi_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no
                     group by a.currency_rt, b.intrmdry_intm_no, b.parent_intm_no) --added by reymon 07172013
               LOOP
                  var_comm_amt := 0;

                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                  --var_sl_cd := rec.intm_no; commented out and changed below by reymon 07172013
                  var_sl_cd := NVL(rec.parent_intm_no, rec.intm_no);

                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd     ,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;
               /* for overriding commission */

           /*
	       ** Commented out by reymon 07172013
		   ** AC-SPECS-2013-081
           FOR REC IN(
                     SELECT  sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt, 
                                 b.intm_no
              FROM gipi_invoice a, giac_parent_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no 
                     group by a.currency_rt, b.intm_no)
         LOOP
              var_comm_amt := 0;
              if nvl(rec.comm_amt,0) != 0 then
                var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(rec.currency_rt,1) ;
              end if;
                      
              if v_sc_okay then
                var_comm_amt := var_comm_amt*v_sc_ratio;
              end if;
                      
              GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

              var_sl_cd := rec.intm_no;

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                         var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                         var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                         var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                         var_gl_sub_acct_7   , var_sl_cd            ,
                                                         var_gl_acct_id      , ece_branch_cd        ,
                                                         var_credit_amt      , var_debit_amt        ,
                                                         var_sl_type_cd      , var_sl_source_cd,
                                                         v_gacc_tran_id      , p_fund_cd);         

         END LOOP;*/

       ELSIF var_sl_type_cd IS NULL THEN      

           FOR REC IN(SELECT sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt 
                                 --b.intrmdry_intm_no intm_no
              FROM gipi_invoice a, gipi_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no
                     group by a.currency_rt)
               LOOP
                  var_comm_amt := 0;

                  IF nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(REC.currency_rt,1);
                  END IF;
                  
                  IF v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  END IF;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                  var_sl_cd := NULL;
                  
                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id      , p_fund_cd);         

               END LOOP;
               /* for overriding commission */

           /*
	       ** Commented out by reymon 07172013
		   ** AC-SPECS-2013-081
           FOR REC IN(
                     SELECT  sum(nvl(b.commission_amt,0)) comm_amt, a.currency_rt 
                                 --b.intrmdry_intm_no intm_no
              FROM gipi_invoice a, giac_parent_comm_invoice b
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd         = ece_iss_cd
               AND a.prem_seq_no = ece_prem_seq_no 
                     group by a.currency_rt)
               LOOP
                  var_comm_amt := 0;
                  if nvl(rec.comm_amt,0) != 0 then
                    var_comm_amt := (nvl(var_comm_amt,0) + nvl(REC.comm_amt,0)) * nvl(rec.currency_rt,1) ;
                  end if;
                  
                  if v_sc_okay then
                    var_comm_amt := var_comm_amt*v_sc_ratio;
                  end if;
                  
                  GET_DRCR_AMT(ece_drcr_tag, var_comm_amt, var_debit_amt, var_credit_amt);    

                  var_sl_cd := NULL;
                  
                  giacs408_pkg.BAE_Insert_Update_Acct_Entries(ece_gl_acct_category, ece_gl_control_acct  ,
                                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                                             var_gl_acct_id      , ece_branch_cd        ,
                                                             var_credit_amt      , var_debit_amt        ,
                                                             var_sl_type_cd      , var_sl_source_cd,
                                                             v_gacc_tran_id, p_fund_cd);         

               END LOOP;*/

      ELSE  
         raise_application_error(-20001,'Geniisys Exception#I#S.L. Type is not in line, subline. ');
      END IF;
    END;
    
    PROCEDURE ENTRIES_FOR_MISC_INC (
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_intm_sl_type_cd       OUT GIAC_ACCT_ENTRIES.sl_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    )
    IS        

    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no               gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_prem_amt            gipi_invperil.prem_amt%type;
    var_prem_amt           NUMBER(12,2);
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES;

    v_sc_okay              boolean:=FALSE;
    v_sc_other             gipi_invoice.other_charges%type;
    BEGIN

         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     


         IF efg_line_dependency_level  != 0 THEN


            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

         IF efg_intm_type_level  != 0 THEN
        
          v_intm_sl_type_cd := var_acct_intm_cd ;

            BAE_Check_Level(efg_intm_type_level          , efg_acct_intm_cd  , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                    var_gl_sub_acct_7   );

          END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );

         FOR REC IN(SELECT (nvl(other_charges,0) + nvl(notarial_fee,0))*currency_rt other_charges
              FROM gipi_invoice 
                     WHERE iss_cd      = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
         loop
           var_prem_amt := rec.other_charges;
           
           if v_sc_okay then
             var_prem_amt := v_sc_other;
           end if;
            
    --       var_sl_cd := 0;                

           GET_DRCR_AMT(efg_drcr_tag, var_prem_amt , var_credit_amt, var_debit_amt);    

           giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                      var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                      var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                      var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                      var_gl_sub_acct_7   , var_sl_cd            ,
                                                      var_gl_acct_id      , efg_branch_cd        ,
                                                      var_credit_amt      , var_debit_amt        ,
                                                      var_sl_type_cd      , var_sl_source_cd,
                                                      v_gacc_tran_id      , p_fund_cd);         

         END LOOP;
    END;
    
    PROCEDURE REV_ENTRIES_FOR_MISC_INC (
        efg_gl_acct_category    IN giac_module_entries.gl_acct_category%type,
        efg_gl_control_acct     IN giac_module_entries.gl_control_acct%type , 
        efg_gl_sub_acct_1       IN giac_module_entries.gl_sub_acct_1%type   ,   
        efg_gl_sub_acct_2       IN giac_module_entries.gl_sub_acct_2%type   ,
        efg_gl_sub_acct_3       IN giac_module_entries.gl_sub_acct_3%type   , 
        efg_gl_sub_acct_4       IN giac_module_entries.gl_sub_acct_4%type   ,
        efg_gl_sub_acct_5       IN giac_module_entries.gl_sub_acct_5%type   , 
        efg_gl_sub_acct_6       IN giac_module_entries.gl_sub_acct_6%type   ,
        efg_gl_sub_acct_7       IN giac_module_entries.gl_sub_acct_7%type   ,
        efg_intm_type_level     IN giac_module_entries.intm_type_level%type , 
        efg_line_dependency_level  IN giac_module_entries.line_dependency_level%type,
        efg_drcr_tag            IN giac_module_entries.dr_cr_tag%type        ,
        efg_iss_cd                IN GIPI_INVOICE.iss_cd%type,
        efg_prem_seq_no            IN GIPI_INVOICE.prem_seq_no%type,
        efg_branch_cd            IN GIAC_BRANCHES.branch_cd%type     ,
        efg_acct_line_cd          IN giis_subline.acct_subline_cd%type,    
        efg_acct_subline_cd     IN GIIS_LINE.acct_line_cd%type      ,
        efg_acct_intm_cd        IN giis_intm_type.acct_intm_cd%type,
        v_intm_sl_type_cd       OUT GIAC_ACCT_ENTRIES.sl_cd%type,
        v_gacc_tran_id          IN GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    )
    IS        

    var_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type ;   
    var_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type ;
    var_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type ; 
    var_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type ;
    var_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type ; 
    var_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type ;
    var_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type ;
    var_share_percentage   gipi_comm_invoice.share_percentage%type;
    var_intm_no           gipi_comm_invoice.intrmdry_intm_no%type;
    var_acct_intm_cd       giis_intm_type.acct_intm_cd%type;

    var_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    var_sl_type_cd        GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;    

    var_acct_subline_cd    giis_subline.acct_subline_cd%type;
    var_acct_line_cd       GIIS_LINE.acct_line_cd%type;
    var_sl_cd              giac_acct_entries.sl_cd%type;
    var_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%type;

    var_credit_amt         giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;

    --var_prem_amt            gipi_invperil.prem_amt%type;
    var_prem_amt           gipi_invperil.prem_amt%type;
    var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
    v_sc_okay              boolean:=FALSE;
    v_sc_other             gipi_invoice.other_charges%type;
    v_sc_not_fee           gipi_invoice.notarial_fee%type;
    BEGIN
         var_gl_sub_acct_1 := efg_gl_sub_acct_1;     
         var_gl_sub_acct_2 := efg_gl_sub_acct_2;     
         var_gl_sub_acct_3 := efg_gl_sub_acct_3;     
         var_gl_sub_acct_4 := efg_gl_sub_acct_4;     
         var_gl_sub_acct_5 := efg_gl_sub_acct_5;     
         var_gl_sub_acct_6 := efg_gl_sub_acct_6;     
         var_gl_sub_acct_7 := efg_gl_sub_acct_7;     


         IF efg_line_dependency_level  != 0 THEN


            BAE_Check_Level(efg_line_dependency_level, efg_acct_line_cd , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6,
                    var_gl_sub_acct_7   );

         END IF;

         IF efg_intm_type_level  != 0 THEN
        
          v_intm_sl_type_cd := var_acct_intm_cd ;

            BAE_Check_Level(efg_intm_type_level          , efg_acct_intm_cd  , 
                    var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                    var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                    var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                    var_gl_sub_acct_7   );

          END IF;

         BAE_Check_Chart_Of_Accts( efg_gl_acct_category, efg_gl_control_acct, 
                       var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                       var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                       var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                       var_gl_sub_acct_7   , var_gl_acct_id     ,
                       var_sl_type_cd       );


         FOR REC IN(SELECT (nvl(other_charges,0) + nvl(notarial_fee,0))*currency_rt other_charges
              FROM gipi_invoice 
             WHERE iss_cd      = efg_iss_cd
               AND prem_seq_no = efg_prem_seq_no )
         loop
           var_prem_amt := rec.other_charges;
           
           if v_sc_okay then
             var_prem_amt := v_sc_other + v_sc_not_fee;
           end if;
                   
           GET_DRCR_AMT(efg_drcr_tag, var_prem_amt , var_debit_amt, var_credit_amt );    

           giacs408_pkg.BAE_Insert_Update_Acct_Entries(efg_gl_acct_category, efg_gl_control_acct  ,
                                                      var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                                      var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                                      var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                                      var_gl_sub_acct_7   , var_sl_cd            ,
                                                      var_gl_acct_id      , efg_branch_cd        ,
                                                      var_credit_amt      , var_debit_amt        ,
                                                      var_sl_type_cd      , var_sl_source_cd,
                                                      v_gacc_tran_id      , p_fund_cd);         

         END LOOP;
    END;
    
--------------------------------------------------------------------------------------------------------------------------ENDTRIES
    PROCEDURE BAE_Insert_Update_Acct_Entries (
        iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE        ,
        iuae_gl_acct_id        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE ,
        iuae_branch_cd         GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%type,
        iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%type,
        iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%type,
        iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type,     
        iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%type,
        v_gacc_tran_id         GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_fund_cd              GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
    ) 
    IS
          
         iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;
         var_count_row             NUMBER := 0;
    BEGIN

      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND nvl(sl_cd,'0')      = nvl(iuae_sl_cd,'0')
         AND sl_cd                 = iuae_sl_cd
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = iuae_branch_cd
         AND gacc_gfun_fund_cd   = p_fund_cd --global
         AND gacc_tran_id        = v_gacc_tran_id; --variables


      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

        var_count_row   := nvl(var_count_row,0)   + 1;
        --message('Please wait... generating Accounting Entries ', no_acknowledge);
        --SYNCHRONIZE;


        INSERT into GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd, acct_entry_id    ,
                                      gl_acct_id         , gl_acct_category ,
                                      gl_control_acct    , gl_sub_acct_1    ,
                                      gl_sub_acct_2      , gl_sub_acct_3    ,
                                      gl_sub_acct_4      , gl_sub_acct_5    ,
                                      gl_sub_acct_6      , gl_sub_acct_7    ,
                                      sl_cd              , debit_amt        ,
                                      credit_amt         , user_id          ,
                                      last_update        , sl_type_cd       ,
                                      sl_source_cd         )
           VALUES (v_gacc_tran_id                , p_fund_cd, --variables -- global
                   iuae_branch_cd                , iuae_acct_entry_id          ,
                   iuae_gl_acct_id               , iuae_gl_acct_category       ,
                   iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                   iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                   iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                   iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                   iuae_sl_cd                    , nvl(iuae_debit_amt,0)       ,
                   nvl(iuae_credit_amt,0)        , GIIS_USERS_PKG.app_user     , --change by steven 11.17.2014
               SYSDATE                       , iuae_sl_type_cd             ,
                   iuae_sl_source_cd);

      ELSE

        UPDATE giac_acct_entries
           SET debit_amt  = debit_amt  + nvl(iuae_debit_amt,0)      ,
               credit_amt = credit_amt + nvl(iuae_credit_amt,0)              
         WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
           AND gl_sub_acct_2       = iuae_gl_sub_acct_2
           AND gl_sub_acct_3       = iuae_gl_sub_acct_3
           AND gl_sub_acct_4       = iuae_gl_sub_acct_4
           AND gl_sub_acct_5       = iuae_gl_sub_acct_5
           AND gl_sub_acct_6       = iuae_gl_sub_acct_6
           AND gl_sub_acct_7       = iuae_gl_sub_acct_7
           AND nvl(sl_cd,'0')      = nvl(iuae_sl_cd,'0')
           AND gl_acct_id          = iuae_gl_acct_id
           AND gacc_gibr_branch_cd = iuae_branch_cd
           AND gacc_gfun_fund_cd   = p_fund_cd --:GLOBAL.
           AND gacc_tran_id        = v_gacc_tran_id; --variables.
      END IF;
    END;

    FUNCTION get_rev_acct_intm_cd(
      p_iss_cd                   gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no              gipi_invoice.prem_seq_no%TYPE
    )    
     RETURN NUMBER IS
      v_share_percentage         gipi_comm_invoice.share_percentage%TYPE;
      v_intm_no                  gipi_comm_invoice.intrmdry_intm_no%TYPE;
      v_parent_intm_no           giis_intermediary.parent_intm_no%TYPE;
      v_intm_type                giis_intm_type.intm_type%TYPE;
      v_acct_intm_cd             giis_intm_type.acct_intm_cd%TYPE;
      v_lic_tag                  giis_intermediary.lic_tag%TYPE;
      var_lic_tag                giis_intermediary.lic_tag%TYPE:='N';
      var_intm_type              giis_intm_type.intm_type%TYPE;
      var_intm_no                gipi_comm_invoice.intrmdry_intm_no%TYPE;
      var_parent_intm_no         giis_intermediary.parent_intm_no%TYPE;
    BEGIN
      BEGIN
        SELECT MAX(share_percentage)
          INTO v_share_percentage
          FROM gipi_comm_invoice
         WHERE iss_cd      = p_iss_cd --:b140.
           AND prem_seq_no = p_prem_seq_no;
           
        IF v_share_percentage IS NOT NULL THEN
           BEGIN
             SELECT MIN(intrmdry_intm_no)
               INTO v_intm_no
               FROM gipi_comm_invoice
              WHERE share_percentage = v_share_percentage
                AND iss_cd      = p_iss_cd
                AND prem_seq_no = p_prem_seq_no;
               
             IF v_intm_no IS NULL THEN
                raise_application_error(-20001, 'Geniisys Exception#I#NO INTERMEDIARY FOUND FOR THIS BILL.');
             END IF;            
        
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 raise_application_error(-20001,'Geniisys Exception#I#NO INTERMEDIARY FOUND FOR THIS BILL.');
           END;
               
        ELSE
           raise_application_error(-20001, 'Geniisys Exception#I#NO SHARE PERCENTAGE FOUND FOR THIS BILL.');
        END IF;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,'Geniisys Exception#I#NO SHARE PERCENTAGE FOUND FOR THIS BILL.');
      END;
         
      BEGIN
        SELECT parent_intm_no, intm_type, NVL(lic_tag,'N')
          INTO v_parent_intm_no, v_intm_type, v_lic_tag
          FROM giis_intermediary
         WHERE intm_no = v_intm_no;
          
        IF v_lic_tag  = 'Y' THEN
           v_parent_intm_no := v_intm_no;
        ELSIF v_lic_tag  = 'N' THEN
           IF v_parent_intm_no IS NULL THEN
              v_parent_intm_no := v_intm_no;
           ELSE   -- check for the nearest licensed parent intm no --
              var_lic_tag := v_lic_tag;
               
              WHILE var_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL 
              LOOP
                BEGIN
                  SELECT intm_no,
                         parent_intm_no,
                         intm_type,
                         lic_tag
                    INTO var_intm_no,
                         var_parent_intm_no,
                         var_intm_type,
                         var_lic_tag
                    FROM giis_intermediary
                   WHERE intm_no = v_parent_intm_no;
                 
                  v_parent_intm_no := var_parent_intm_no;
                  v_intm_type      := var_intm_type;
                  v_lic_tag        := var_lic_tag;
                   
                  IF var_parent_intm_no IS NULL THEN
                     v_parent_intm_no := var_intm_no;
                     EXIT;
                  ELSE
                     var_lic_tag := 'N';
                  END IF;
                  
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      raise_application_error(-20001, 'Geniisys Exception#I#'||TO_CHAR(v_parent_intm_no)||' HAS NO_DATA_FOUND IN GIIS INTERMEDIARY');
                      v_parent_intm_no := var_intm_no;
                      EXIT;
                END;
              END LOOP;

                      
           END IF; -- v_parent_intm_no is not null
        END IF;    -- lic_tag
        
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#I#INTERMEDIARY ' || TO_CHAR(v_intm_no)|| ' HAS NO RECORD IN GIIS_INTERMEDIARY.');
      END;
         
      BEGIN
        SELECT acct_intm_cd
          INTO v_acct_intm_cd
          FROM giis_intm_type
         WHERE intm_type = v_intm_type;
          
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error(-20001, 'Geniisys Exception#I#'||v_intm_type||' HAS NO RECORD IN GIIS_INTM_TYPE.');
      END;
       
    --  variables.intm_code := v_acct_intm_cd;
    --  variables.v_parent_intm_no := v_parent_intm_no;

      RETURN v_acct_intm_cd;
    END;

    PROCEDURE get_br_ln_subln (
       p_fund_cd              IN        giac_branches.gfun_fund_cd%TYPE,
       p_gbls_iss_cd          IN          gipi_polbasic.iss_cd%TYPE,
       p_gbls_line_cd         IN          gipi_polbasic.line_cd%TYPE,
       p_gbls_subline_cd      IN          gipi_polbasic.subline_cd%TYPE,
       p_gbls_assd_no          IN          gipi_polbasic.assd_no%TYPE,
       p_branch_cd            IN OUT    giac_acct_entries.gacc_gibr_branch_cd%TYPE,
       p_acct_line_cd         IN OUT    giis_line.acct_line_cd%TYPE,
       p_acct_subline_cd      IN OUT       giis_subline.acct_subline_cd%TYPE
    ) 
    IS
    BEGIN
      BEGIN
        SELECT b.branch_cd
          INTO p_branch_cd
          FROM giac_branches b, giis_issource c
         WHERE b.acct_branch_cd = c.acct_iss_cd   
           AND b.gfun_fund_cd   = p_fund_cd
           AND b.branch_cd      = p_gbls_iss_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#I#No Data Found in GIAC_BRANCHES.');
      END;

      BEGIN
        SELECT acct_line_cd
          INTO p_acct_line_cd     
          FROM giis_line b
         WHERE line_cd = p_gbls_line_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN 
            raise_application_error(-20001, 'Geniisys Exception#I#No Data Found in Giis_line. ');
      END;

      BEGIN
        SELECT acct_subline_cd
          INTO p_acct_subline_cd    
          FROM giis_subline
         WHERE line_cd    = p_gbls_line_cd
           AND subline_cd = p_gbls_subline_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#I#No Data Found in Giis_Subline. ');        
      END;
    END;

    PROCEDURE insert_giac_acctrans (
      p_fund_cd            IN      giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd          IN      giac_acctrans.gibr_branch_cd%TYPE,
      v_gacc_tran_id       IN OUT  giac_acctrans.tran_id%TYPE,
      v_tran_class         IN      giac_acctrans.tran_class%TYPE,
      v_particulars        IN      giac_acctrans.particulars%type
    ) 
    IS
      v_year              NUMBER;
      v_month            NUMBER;
      v_tran_id         giac_acctrans.tran_id%type := 0;

      v_tran_seq_no     giac_acctrans.tran_seq_no%type;
      v_tran_class_no   giac_acctrans.tran_class_no%type;

      v_jv_no            giac_acctrans.jv_no%type;
      v_tran_flag         GIAC_ACCTRANS.tran_flag%type := 'C'; --from variables spec

    BEGIN

      v_year   :=  TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      v_month  :=  TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));


      BEGIN
        SELECT DISTINCT tran_id
          INTO v_tran_id
          FROM giac_acctrans
         WHERE gfun_fund_cd   = p_fund_cd
           AND gibr_branch_cd = p_branch_cd
           AND tran_year      = v_year
           AND tran_month     = v_month
           AND tran_class     = v_tran_class
           AND tran_id           = v_gacc_tran_id;

        v_gacc_tran_id := v_tran_id;

      EXCEPTION 
          WHEN NO_DATA_FOUND THEN
           BEGIN
            v_tran_seq_no   := giac_sequence_generation(p_fund_cd , --global
                                                        p_branch_cd,
                                                        'TRAN_SEQ_NO',
                                                        v_year,
                                                        v_month);
            v_tran_class_no := giac_sequence_generation(p_fund_cd, 
                                                        p_branch_cd,
                                                        v_tran_class,
                                                        v_year,
                                                        0);
              INSERT INTO giac_acctrans
                (tran_id,           gfun_fund_cd,      gibr_branch_cd, 
                 tran_year,         tran_month,        tran_seq_no,
                 tran_date,         tran_flag,         tran_class,
                 tran_class_no,     jv_no,             particulars,
                 user_id ,          last_update)
              VALUES
                (v_gacc_tran_id,    p_fund_cd,      p_branch_cd,
                 v_year,            v_month,        v_tran_seq_no, 
                 SYSDATE,           v_tran_flag,    v_tran_class,
                 v_tran_class_no,   v_jv_no,        v_particulars,
                 GIIS_USERS_PKG.app_user, SYSDATE); --change by steven 11.17.2014

           END;
      END;
    END;

    PROCEDURE process_unbalance_accts (
      p_iss_cd             gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      v_gacc_tran_id  IN   GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
      p_fund_cd       IN   giac_acctrans.gfun_fund_cd%TYPE  
    )
    IS

    var_gl_acct_category           giac_module_entries.gl_acct_category%type;
    var_gl_control_acct         giac_module_entries.gl_control_acct%type;
    var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
    var_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%type;
    var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
    var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
    var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
    var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
    var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
    var_intm_type_level         giac_module_entries.intm_type_level%type;
    var_line_dependency_level      giac_module_entries.line_dependency_level%type;
    var_old_new_acct_level         giac_module_entries.old_new_acct_level%type;
    var_dr_cr_tag                  giac_module_entries.dr_cr_tag%type;
    var_gslt_sl_type_cd            giac_chart_of_accts.gslt_sl_type_cd%type;
    var_gl_acct_id              giac_chart_of_accts.gl_acct_id%type;
          
      var_policy_id      GIPI_POLBASIC.policy_id%type;
      var_line_cd        GIPI_POLBASIC.line_cd%type;
      var_subline_cd     GIPI_POLBASIC.subline_cd%type;
      var_iss_cd         GIPI_POLBASIC.iss_cd%type;
      var_issue_yy       GIPI_POLBASIC.issue_yy%type;
      var_pol_seq_no     GIPI_POLBASIC.pol_seq_no%type;
      var_endt_iss_cd     GIPI_POLBASIC.endt_iss_cd%type;
      var_endt_yy         GIPI_POLBASIC.endt_yy%type;
      var_endt_seq_no     GIPI_POLBASIC.endt_seq_no%type;
      var_incept_date     GIPI_POLBASIC.incept_date%type;
      var_issue_date      GIPI_POLBASIC.issue_date%type;
      var_count_row       number  := 0;
      var_acct_subline_cd   giis_subline.acct_subline_cd%type;
      var_acct_line_cd      GIIS_LINE.acct_line_cd%type;
      var_sl_cd             giac_acct_entries.sl_cd%type;
      var_sl_type_cd        giac_acct_entries.sl_type_cd%type;
      var_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%type;
      var_acct_intm_cd      giis_intm_type.acct_intm_cd%type;
      v_amt                 number(12,2);
      var_credit_amt        number(12,2);
      var_debit_amt         number(12,2); 
      var_sl_source_cd       giac_acct_entries.sl_source_cd%type:= '1';  -- 1, from GIIS_SL_LISTS; 2, from GIIS_PAYEES
      
      v_intm_sl_type_cd      GIAC_ACCT_ENTRIES.sl_cd%type;   
    BEGIN
      select sum(debit_amt - credit_amt) diff
       into v_amt
       from giac_acct_entries
      where gacc_tran_id = v_gacc_tran_id;
          
      if abs(v_amt) <= 1 then
        if v_amt > 0 then
          var_credit_amt := ABS(v_amt);
          var_debit_amt  := 0;
          FOR REC IN ( SELECT c.line_cd,
                              c.subline_cd,
                              c.assd_no,
                              a.intrmdry_intm_no,
                              a.iss_cd,
                              a.prem_seq_no,   
                              a.premium_amt,                  
                      a.commission_amt,
                              a.wholding_tax  
                 FROM gipi_comm_invoice a,
                      gipi_invoice b,
                      gipi_polbasic c
                    WHERE a.iss_cd = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND c.policy_id = b.policy_id
                  AND a.iss_cd = p_iss_cd
                  AND a.prem_seq_no = p_prem_seq_no)
          loop
            begin
              var_acct_intm_cd := giacs408_pkg.get_rev_acct_intm_cd(p_iss_cd, p_prem_seq_no);
              giacs408_pkg.GET_BR_LN_SUBLN(p_fund_cd, REC.iss_cd, REC.line_cd, REC.subline_cd, REC.assd_no,
                               var_branch_cd ,var_acct_line_cd , var_acct_subline_cd );
                  
              BEGIN
                SELECT  gl_acct_category   ,  gl_control_acct   ,
                        gl_sub_acct_1      ,  gl_sub_acct_2     ,
                        gl_sub_acct_3      ,  gl_sub_acct_4     ,
                        gl_sub_acct_5      ,  gl_sub_acct_6     ,
                        gl_sub_acct_7      ,  intm_type_level   ,
                        line_dependency_level  ,
                        old_new_acct_level ,  dr_cr_tag         
                  INTO  var_gl_acct_category,  var_gl_control_acct, 
                        var_gl_sub_acct_1   , var_gl_sub_acct_2,
                        var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
                        var_gl_sub_acct_5   , var_gl_sub_acct_6,
                        var_gl_sub_acct_7   ,  var_intm_type_level, 
                        var_line_dependency_level  ,
                        var_old_new_acct_level ,  var_dr_cr_tag   
                  FROM  giac_module_entries a, giac_modules b
                 WHERE  a.module_id = b.module_id
                   AND  module_name = 'GIACS408'
                   AND  item_no = 4;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  raise_application_error(-20001, 'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table. ');
              END;         
                  
              IF var_line_dependency_level  != 0 THEN
                BAE_Check_Level(var_line_dependency_level, var_acct_line_cd , 
                                var_gl_sub_acct_1   , var_gl_sub_acct_2,
                                var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                var_gl_sub_acct_5   , var_gl_sub_acct_6,
                                var_gl_sub_acct_7   );
              END IF;
                  
              IF var_intm_type_level  != 0 THEN
                v_intm_sl_type_cd := var_acct_intm_cd ;
                BAE_Check_Level(var_intm_type_level , var_acct_intm_cd  , 
                                var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                                var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                                var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                                var_gl_sub_acct_7   );
              END IF;
                  
              BAE_Check_Chart_Of_Accts( var_gl_acct_category, var_gl_control_acct, 
                                        var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                        var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                        var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                        var_gl_sub_acct_7   , var_gl_acct_id     ,
                                        var_sl_type_cd       );
                   
              giacs408_pkg.BAE_Insert_Update_Acct_Entries(var_gl_acct_category, var_gl_control_acct  ,
                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                             var_gl_acct_id      , var_branch_cd        ,
                                             var_credit_amt      , var_debit_amt        ,
                                             var_sl_type_cd      , var_sl_source_cd     ,
                                             v_gacc_tran_id      , p_fund_cd); --change by steven 11.14.2014
            end;
            exit;
          end loop; 
        elsif v_amt < 0 then
          var_credit_amt := 0;
          var_debit_amt  := ABS(v_amt);
          FOR REC IN ( SELECT c.line_cd,
                              c.subline_cd,
                              c.assd_no,
                              a.intrmdry_intm_no,
                              a.iss_cd,
                              a.prem_seq_no,   
                              a.premium_amt,                  
                      a.commission_amt,
                              a.wholding_tax  
                 FROM gipi_comm_invoice a,
                      gipi_invoice b,
                      gipi_polbasic c
                    WHERE a.iss_cd = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND c.policy_id = b.policy_id
                  AND a.iss_cd = p_iss_cd
                  AND a.prem_seq_no = p_prem_seq_no)
          loop
            begin
              var_acct_intm_cd := giacs408_pkg.get_rev_acct_intm_cd(p_iss_cd, p_prem_seq_no);
              giacs408_pkg.GET_BR_LN_SUBLN(p_fund_cd, REC.iss_cd, REC.line_cd, REC.subline_cd, REC.assd_no,
                               var_branch_cd ,var_acct_line_cd , var_acct_subline_cd );
                  
              BEGIN
                SELECT  gl_acct_category   ,  gl_control_acct   ,
                        gl_sub_acct_1      ,  gl_sub_acct_2     ,
                        gl_sub_acct_3      ,  gl_sub_acct_4     ,
                        gl_sub_acct_5      ,  gl_sub_acct_6     ,
                        gl_sub_acct_7      ,  intm_type_level   ,
                        line_dependency_level  ,
                        old_new_acct_level ,  dr_cr_tag         
                  INTO  var_gl_acct_category,  var_gl_control_acct, 
                        var_gl_sub_acct_1   , var_gl_sub_acct_2,
                        var_gl_sub_acct_3   ,  var_gl_sub_acct_4  ,
                        var_gl_sub_acct_5   , var_gl_sub_acct_6,
                        var_gl_sub_acct_7   ,  var_intm_type_level, 
                        var_line_dependency_level  ,
                        var_old_new_acct_level ,  var_dr_cr_tag   
                  FROM  giac_module_entries a, giac_modules b
                 WHERE  a.module_id = b.module_id
                   AND  module_name = 'GIACS408'
                   AND  item_no = 4;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  raise_application_error(-20001, 'Geniisys Exception#I#No Data on GIAC_MODULE_ENTRIES table.');
              END;         
                  
              IF var_line_dependency_level  != 0 THEN
                BAE_Check_Level(var_line_dependency_level, var_acct_line_cd , 
                                var_gl_sub_acct_1   , var_gl_sub_acct_2,
                                var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                var_gl_sub_acct_5   , var_gl_sub_acct_6,
                                var_gl_sub_acct_7   );
              END IF;
                  
              IF var_intm_type_level  != 0 THEN
                v_intm_sl_type_cd := var_acct_intm_cd ;
                BAE_Check_Level(var_intm_type_level , var_acct_intm_cd  , 
                                var_gl_sub_acct_1   , var_gl_sub_acct_2 ,
                                var_gl_sub_acct_3   , var_gl_sub_acct_4 ,
                                var_gl_sub_acct_5   , var_gl_sub_acct_6 ,
                                var_gl_sub_acct_7   );
              END IF;
                  
              BAE_Check_Chart_Of_Accts( var_gl_acct_category, var_gl_control_acct, 
                                        var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                        var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                        var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                        var_gl_sub_acct_7   , var_gl_acct_id     ,
                                        var_sl_type_cd       );

              giacs408_pkg.BAE_Insert_Update_Acct_Entries(var_gl_acct_category, var_gl_control_acct  ,
                                             var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                             var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                             var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                             var_gl_sub_acct_7   , var_sl_cd            ,
                                             var_gl_acct_id      , var_branch_cd        ,
                                             var_credit_amt      , var_debit_amt        ,
                                             var_sl_type_cd      , var_sl_source_cd     ,
                                             v_gacc_tran_id      , p_fund_cd); --change by steven 11.14.2014
            end;
            exit;
          end loop; 
        end if;
      end if;
    END;
    
    PROCEDURE POPULATE_GIPI_COMM_INV_DTL(
    p_fund_cd           gipi_invoice.iss_cd%TYPE,
    p_branch_cd         giac_new_comm_inv_peril.branch_cd%TYPE,
    p_intm_no           gipi_comm_invoice.intrmdry_intm_no%TYPE,          
    p_iss_cd            gipi_comm_invoice.iss_cd%TYPE,      
    p_policy_id         gipi_comm_invoice.policy_id%TYPE,      
    p_prem_seq_no       gipi_comm_invoice.prem_seq_no%TYPE,
    p_share_percentage  gipi_comm_invoice.share_percentage%TYPE, 
    p_parent_intm_no    gipi_comm_invoice.parent_intm_no%TYPE
  ) 
    IS
      v_wtax_rate             giis_intermediary.wtax_rate%TYPE;
      v_premium_amt           gipi_comm_inv_dtl.premium_amt%type := 0;  
      v_commission_amt        gipi_comm_inv_dtl.commission_amt%type := 0;
      v_wholding_tax          gipi_comm_inv_dtl.wholding_tax%type := 0;
      v_net_commission        gipi_comm_inv_dtl.commission_amt%type := 0;
      v_total_premium_amt     gipi_comm_inv_dtl.premium_amt%type := 0;  
      v_total_commission_amt  gipi_comm_inv_dtl.commission_amt%type := 0;
      v_total_wholding_tax    gipi_comm_inv_dtl.wholding_tax%type := 0;

    BEGIN
        
      BEGIN
        SELECT NVL(wtax_rate, 0)/100
          INTO v_wtax_rate
          FROM giis_intermediary
         WHERE intm_no = p_intm_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_wtax_rate := 0;
      END;
        
      FOR gperil IN (SELECT peril_cd, premium_amt, commission_amt
                       FROM giac_new_comm_inv_peril
                      WHERE NVL (delete_sw, 'N') = 'N'
                        AND tran_flag            = 'U'
                        AND fund_cd              = p_fund_cd
                        AND branch_cd            = p_branch_cd
                        AND iss_cd               = p_iss_cd
                        AND prem_seq_no          = p_prem_seq_no
                        AND intm_no              = p_intm_no --Vincent 083105: added to fix amounts inserted
                        )
      LOOP
        v_premium_amt    := NVL(gperil.premium_amt,0);
        
          IF gperil.commission_amt = 0 THEN   -- judyann 02222008 
             v_commission_amt := 0;           -- no more computation to be done; comm amt for parent intm should be zero when comm amt for child intm is 0 
          ELSE
           v_commission_amt := (nvl(gperil.commission_amt,0)-(NVL(gperil.premium_amt,0) * (GET_ADJUST_INTRMDRY_RATE(p_intm_no, p_policy_id, gperil.peril_cd)/100)));
        END IF;
           
        --v_wholding_tax := ROUND (NVL (v_commission_amt, 0),2) * NVL (v_wtax_rate, 0) / 100;
        v_wholding_tax := ROUND (NVL (v_commission_amt, 0),2) * NVL (v_wtax_rate, 0); --issa 07.27.2005; computation for wholding tax, no need to divide the v_wtax_rate by 100 again            
          v_total_premium_amt := NVL(v_total_premium_amt,0) + v_premium_amt;
          v_total_commission_amt := NVL(v_total_commission_amt,0) + v_commission_amt;
          v_total_wholding_tax := NVL(v_total_wholding_tax,0) + v_wholding_tax;       
      END LOOP gperil;    

      INSERT INTO gipi_comm_inv_dtl
          (intrmdry_intm_no,        iss_cd,             policy_id,             prem_seq_no,
           share_percentage,        premium_amt,        commission_amt,
           wholding_tax,            parent_intm_no)
        VALUES 
          (p_intm_no,                      p_iss_cd,                   p_policy_id,                  p_prem_seq_no,
           p_share_percentage,             v_total_premium_amt, v_total_commission_amt,
           v_total_wholding_tax,    p_parent_intm_no);   

    END;
    
    PROCEDURE get_gl_accts_NOT_reversal(
      p_iss_cd                  gipi_comm_invoice.iss_cd%TYPE,      
      p_prem_seq_no             gipi_comm_invoice.prem_seq_no%TYPE,
      p_fund_cd                 gipi_invoice.iss_cd%TYPE,
      p_branch_cd               giac_new_comm_inv.branch_cd%TYPE,
      v_comm_acct_gen           VARCHAR2,
      v_new_gacc_tran_id   OUT  giac_acctrans.tran_id%TYPE
    )
    IS

    var_policy_id           GIPI_POLBASIC.policy_id%type;
    var_line_cd             GIPI_POLBASIC.line_cd%type;
    var_subline_cd          GIPI_POLBASIC.subline_cd%type;
    var_iss_cd              GIPI_POLBASIC.iss_cd%type;
    var_issue_yy            GIPI_POLBASIC.issue_yy%type;
    var_pol_seq_no          GIPI_POLBASIC.pol_seq_no%type;
    var_endt_iss_cd         GIPI_POLBASIC.endt_iss_cd%type;
    var_endt_yy             GIPI_POLBASIC.endt_yy%type;
    var_endt_seq_no         GIPI_POLBASIC.endt_seq_no%type;
    var_incept_date         GIPI_POLBASIC.incept_date%type;
    var_issue_date          GIPI_POLBASIC.issue_date%type;
    var_count_row           number  := 0;

    var_acct_subline_cd     giis_subline.acct_subline_cd%type;
    var_acct_line_cd        GIIS_LINE.acct_line_cd%type;
    var_sl_cd               giac_acct_entries.sl_cd%type;
    var_branch_cd           giac_acct_entries.gacc_gibr_branch_cd%type;
    var_acct_intm_cd        giis_intm_type.acct_intm_cd%type;
    
    v_gacc_tran_id          GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE;
    v_tran_class            GIAC_ACCTRANS.tran_class%type ;
    v_IS_IT_REVERSAL        BOOLEAN;
    v_particulars           GIAC_ACCTRANS.particulars%type;
    BEGIN

         /*
         **    SELECT max(jv_no)
         **      INTO variables.jv_no         
         **      FROM giac_acctrans;
         */

        SELECT acctran_tran_id_s.nextval
          INTO v_gacc_tran_id 
          FROM DUAL;

        v_new_gacc_tran_id := v_gacc_tran_id;
        v_tran_class       := 'MC';  
        v_IS_IT_REVERSAL   := FALSE;    

       FOR REC IN (    
                    SELECT distinct b.line_cd,     
                           b.subline_cd,
                           c.assd_no
              FROM giac_new_comm_inv a,
                           gipi_polbasic b,
                           gipi_parlist c
            WHERE a.policy_id = b.policy_id
                      and b.par_id = c.par_id
                      AND NVL(a.delete_sw, 'N') = 'N'
                      AND a.tran_flag = 'U' 
                      and a.fund_cd = p_fund_cd --variables
                      and a.branch_cd = p_branch_cd
              AND a.iss_cd = p_iss_cd --b140
              AND a.prem_seq_no = p_prem_seq_no) 
       loop

          v_particulars := 'TAKE-UP OF CHANGES TO BILL '||p_iss_cd||'-'||to_char(p_prem_seq_no); --b140

          var_acct_intm_cd := giacs408_pkg.get_acct_intm_cd(p_iss_cd, p_prem_seq_no);

          giacs408_pkg.GET_BR_LN_SUBLN(p_fund_cd, p_iss_cd, REC.line_cd, REC.subline_cd, REC.assd_no,
                    var_branch_cd ,var_acct_line_cd , var_acct_subline_cd );            

          giacs408_pkg.insert_giac_acctrans(p_fund_cd, var_branch_cd, v_gacc_tran_id, v_tran_class, v_particulars);    

          IF v_comm_acct_gen = '1'
          THEN
             giacs408_pkg.BAE_GROSS_PREMIUMS( p_iss_cd, p_prem_seq_no, var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );

             giacs408_pkg.BAE_PREMIUMS_RECEIVABLE( p_iss_cd, p_prem_seq_no, var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );

             giacs408_pkg.BAE_COMMISSIONS_PAYABLE( p_iss_cd, p_prem_seq_no, var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );

             giacs408_pkg.BAE_COMMISSIONS_EXPENSE( p_iss_cd, p_prem_seq_no,  var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd, p_branch_cd);
                     
             giacs408_pkg.BAE_MISCELLANEOUS_INCOME( p_iss_cd, p_prem_seq_no,  var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );
                    
             giacs408_pkg.BAE_TAXES_PAYABLE( p_iss_cd, p_prem_seq_no, var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd,  v_is_it_reversal, v_gacc_tran_id, p_fund_cd );

          elsif v_comm_acct_gen = '2'
          then

             giacs408_pkg.BAE_COMMISSIONS_PAYABLE( p_iss_cd, p_prem_seq_no, var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd );

             giacs408_pkg.BAE_COMMISSIONS_EXPENSE( p_iss_cd, p_prem_seq_no,  var_branch_cd ,var_acct_line_cd 
                        ,var_acct_subline_cd, var_acct_intm_cd, v_is_it_reversal, v_gacc_tran_id, p_fund_cd, p_branch_cd );
           
          end if;
             
       END LOOP;

    end;
    
    FUNCTION GET_acct_intm_cd(
       p_iss_cd     gipi_invoice.iss_cd%TYPE,
       p_prem_seq_no gipi_invoice.prem_seq_no%TYPE
    ) 
    RETURN NUMBER IS
      
       V_SHARE_PERCENTAGE         GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE;
       V_INTM_NO                  GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
       V_PARENT_INTM_NO           GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
       V_INTM_TYPE                GIIS_INTM_TYPE.INTM_TYPE%TYPE;
       V_ACCT_INTM_CD             GIIS_INTM_TYPE.ACCT_INTM_CD%TYPE;
       V_LIC_TAG                  GIIS_INTERMEDIARY.LIC_TAG%TYPE;
       VAR_LIC_TAG                GIIS_INTERMEDIARY.LIC_TAG%TYPE:='N';
       VAR_INTM_TYPE              GIIS_INTM_TYPE.INTM_TYPE%TYPE;
       VAR_INTM_NO                GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
       VAR_PARENT_INTM_NO         GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
       
       v_intm_code         GIIS_INTM_TYPE.acct_intm_cd%type;
    BEGIN
       BEGIN
         SELECT MAX(SHARE_PERCENTAGE)
           INTO V_SHARE_PERCENTAGE
           FROM GIPI_COMM_INVOICE
          WHERE iss_cd      = P_ISS_CD
            AND prem_seq_NO = P_PREM_SEQ_NO;
           
         IF V_SHARE_PERCENTAGE IS NOT NULL THEN
           BEGIN
             SELECT min(intrmdry_intm_no)
               INTO v_intm_no
               FROM gipi_comm_invoice
              WHERE share_percentage = v_share_percentage
                AND ISS_CD      = P_ISS_CD
                AND PREM_SEQ_NO = P_PREM_SEQ_NO;
               
             IF V_INTM_NO IS NULL THEN
               raise_application_error(-20001,'Geniisys Exception#I#NO INTERMEDIARY FOUND FOR THIS BILL. ');
             END IF;            
           EXCEPTION
             when no_data_found then
               raise_application_error(-20001,'Geniisys Exception#I#NO INTERMEDIARY FOUND FOR THIS BILL. ');
           END;
               
         ELSE
           raise_application_error(-20001,'Geniisys Exception#I#NO SHARE PERCENTAGE FOUND FOR THIS BILL.');
         END IF;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           raise_application_error(-20001,'Geniisys Exception#I#NO SHARE PERCENTAGE FOUND FOR THIS BILL.');
       END;
       
       BEGIN
         SELECT PARENT_INTM_NO, INTM_TYPE, nvl(LIC_TAG,'N')
           INTO V_PARENT_INTM_NO, V_INTM_TYPE, V_LIC_TAG
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO = V_INTM_NO;
          
         IF V_LIC_TAG  = 'Y' THEN
           V_PARENT_INTM_NO := V_INTM_NO;
         ELSIF V_LIC_TAG  = 'N' THEN
           IF V_PARENT_INTM_NO IS NULL THEN
             V_PARENT_INTM_NO := V_INTM_NO;
           ELSE  -- check for the nearest licensed parent intm no --
             var_lic_tag := v_lic_tag;
               
             while var_lic_tag = 'N' and v_parent_intm_no is not null loop
               begin
                 select intm_no,
                        parent_intm_no,
                        intm_type,
                        lic_tag
                   into var_intm_no,
                        var_parent_intm_no,
                        var_intm_type,
                        var_lic_tag
                   from giis_intermediary
                  where intm_no = v_parent_intm_no;
                 
                 v_parent_intm_no := var_parent_intm_no;
                 v_intm_type      := var_intm_type;
                 v_lic_tag        := var_lic_tag;
                   
                 IF VAR_PARENT_INTM_NO IS NULL THEN
                   v_parent_intm_no := var_intm_no;
                   EXIT;
                 ELSE
                   var_lic_tag := 'N';
                 END IF;
               exception
                 when no_data_found then
                   raise_application_error(-20001,'Geniisys Exception#I#'||TO_Char(v_parent_intm_no)||' HAS NO_DATA_FOUND IN GIIS INTERMEDIARY');
                   v_parent_intm_no := var_intm_no;
                   EXIT;
               end;
             end loop;
           END IF;
         END IF;
       EXCEPTION 
         WHEN NO_DATA_FOUND THEN
           raise_application_error(-20001,'Geniisys Exception#I#INTERMEDIARY ' || TO_CHAR(V_INTM_NO)|| ' HAS NO RECORD IN GIIS_INTERMEDIARY.');
       END;
         
       BEGIN
         SELECT ACCT_INTM_CD
           INTO V_ACCT_INTM_CD
           FROM GIIS_INTM_TYPE
          WHERE INTM_TYPE = V_INTM_TYPE;
          
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           raise_application_error(-20001,'Geniisys Exception#I#'||V_INTM_TYPE||' HAS NO RECORD IN GIIS_INTM_TYPE.');
       END;
       
       v_intm_code := V_ACCT_INTM_CD;
       v_parent_intm_no := v_parent_intm_no;
       RETURN v_intm_code;
    END;
    
   FUNCTION recompute_comm_rate_giacs408(
      p_fund_cd       giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd     giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id   giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_intm_no       giac_new_comm_inv_peril.intm_no%TYPE, 
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_wtax_rate     NUMBER      
   )
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
      v_banc_sw VARCHAR2(1);
   BEGIN
      FOR i IN (SELECT * 
                  FROM TABLE (giacs408_pkg.populate_peril_info(p_fund_cd, p_branch_cd, p_comm_rec_id, p_intm_no, p_line_cd)))
      LOOP
         v_peril.premium_amt := i.premium_amt;
         v_peril.wholding_tax := i.wholding_tax;
         v_peril.comm_rec_id := i.comm_rec_id;
         v_peril.intm_no := i.intm_no;
         v_peril.iss_cd := i.iss_cd;
         v_peril.prem_seq_no := i.prem_seq_no;
         v_peril.peril_cd := i.peril_cd;
         v_peril.tran_date := i.tran_date;
         v_peril.tran_no := i.tran_no;
         v_peril.tran_flag := i.tran_flag;
         v_peril.comm_peril_id := i.comm_peril_id;
         v_peril.delete_sw := i.delete_sw;
         v_peril.fund_cd := i.fund_cd;
         v_peril.branch_cd := i.branch_cd;
         v_peril.dsp_peril_name := get_peril_name (p_line_cd, i.peril_cd);
         
         BEGIN
            SELECT DISTINCT bancassurance_sw
              INTO v_banc_sw
              FROM gipi_polbasic a, gipi_invoice b 
             WHERE a.policy_id = b.policy_id
               AND b.iss_cd = p_iss_cd
               AND b.prem_seq_no = p_prem_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_banc_sw := NULL;
         END;
         
         IF v_banc_sw ='Y' THEN
            SELECT rate 
              INTO v_peril.commission_rt 
              FROM giis_banc_type
             WHERE banc_type_cd = (SELECT banc_type_cd 
                                     FROM gipi_polbasic
                                    WHERE policy_id = p_policy_id);
         ELSE
            v_peril.commission_rt := get_intm_rate_giacs408(i.peril_cd, i.intm_no, p_line_cd, p_subline_cd, p_iss_cd, p_policy_id);
         END IF;
         
         v_peril.commission_amt  := ROUND(v_peril.premium_amt * (v_peril.commission_rt / 100),2);
         v_peril.wholding_tax    := ROUND(v_peril.commission_amt * p_wtax_rate, 2);
         v_peril.dsp_netcomm_amt := v_peril.commission_amt - v_peril.wholding_tax;
         
--         FOR j IN (SELECT SUM(premium_amt) tot_premium_amt, SUM(commission_amt) tot_commission_amt, SUM(wholding_tax) tot_wholding_tax, SUM(dsp_netcomm_amt) tot_netcomm_amt 
--                     FROM TABLE (giacs408_pkg.populate_peril_info(p_fund_cd, p_branch_cd, p_comm_rec_id, p_intm_no, p_line_cd)))
--         LOOP
--            v_peril.tot_premium_amt := j.tot_premium_amt;
--            v_peril.tot_commission_amt := j.tot_commission_amt;
--            v_peril.tot_wholding_tax := j.tot_wholding_tax;
--            v_peril.tot_netcomm_amt := j.tot_netcomm_amt;
--         END LOOP;
         
         PIPE ROW (v_peril);
      END LOOP;
   END;         
    
   FUNCTION get_intm_rate_giacs408(
      p_peril_cd        giis_intm_special_rate.peril_cd%TYPE,
      p_intm_no         giis_intm_special_rate.intm_no%TYPE,
      p_nbt_line_cd     giis_intm_special_rate.line_cd%TYPE,
      p_nbt_subline_cd  giis_intm_special_rate.subline_cd%TYPE,
      p_iss_cd          giis_intm_special_rate.iss_cd%TYPE,
      p_policy_id       gipi_polbasic.policy_id%TYPE
   ) RETURN NUMBER IS
      v_sp_rt           giis_intermediary.special_rate%TYPE;
      v_intm_type       giis_intermediary.intm_type%TYPE;  
      v_rate            gipi_comm_inv_peril.commission_rt%TYPE := 0;
   BEGIN
      SELECT special_rate, intm_type
        INTO v_sp_rt, v_intm_type
        FROM giis_intermediary
       WHERE intm_no = p_intm_no;
       
      IF v_sp_rt = 'Y' THEN
         BEGIN  
            SELECT rate
              INTO v_rate
              FROM giis_intm_special_rate
             WHERE intm_no    = p_intm_no
               AND line_cd    = p_nbt_line_cd
               AND iss_cd     = p_iss_cd
               AND subline_cd = p_nbt_subline_cd
               AND peril_cd   = p_peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN   
                  SELECT comm_rate
                    INTO v_rate
                    FROM giis_intmdry_type_rt
                   WHERE intm_type  = v_intm_type
                     AND line_cd    = p_nbt_line_cd
                     AND iss_cd     = p_iss_cd
                     AND subline_cd = p_nbt_subline_cd    
                     AND peril_cd   = p_peril_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN   
                        BEGIN
                           SELECT intm_comm_rt
                             INTO v_rate
                             FROM giis_peril
                            WHERE line_cd   = p_nbt_line_cd
                              AND peril_cd  = p_peril_cd;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              v_rate := 0;
                        END;
                     END;     
                END;   
         END;   
      ELSE   -- special_rate = 'N'
         BEGIN   
            SELECT comm_rate
              INTO v_rate
              FROM giis_intmdry_type_rt
             WHERE intm_type  = v_intm_type
               AND line_cd    = p_nbt_line_cd
               AND iss_cd     = p_iss_cd
               AND subline_cd = p_nbt_subline_cd
               AND peril_cd   = p_peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN  
                  BEGIN
                     SELECT intm_comm_rt
                       INTO v_rate
                       FROM giis_peril
                      WHERE line_cd   = p_nbt_line_cd
                        AND peril_cd  = p_peril_cd;
                  EXCEPTION 
                     WHEN NO_DATA_FOUND THEN
                        v_rate := 0;
                  END;
               END;   
         END;   
      END IF;-- specal_rate
      v_rate := NVL(v_rate, 0) + get_adjust_intrmdry_rate(p_intm_no, p_policy_id, p_peril_cd);
      
      RETURN(v_rate);
   END get_intm_rate_giacs408;
   
   FUNCTION get_giis_banc_type_lov   
   RETURN giis_banc_type_lov_tab PIPELINED IS
      res                 giis_banc_type_lov_type;
   BEGIN
      FOR i IN (SELECT banc_type_cd, banc_type_desc, rate
                  FROM giis_banc_type)
      LOOP
         res.banc_type_cd := i.banc_type_cd;
         res.banc_type_desc := i.banc_type_desc;
         res.rate := i.rate;
         
         PIPE ROW(res);
      END LOOP;
   END get_giis_banc_type_lov;
   
   FUNCTION get_banc_intm_lov (
      p_param_intm_type     giis_intermediary.intm_type%TYPE
   ) RETURN banc_intm_lov_tab PIPELINED IS
      res                   banc_intm_lov_type;
   BEGIN
      FOR i IN (SELECT a.intm_no, a.intm_name, a.intm_type
                  FROM giis_intermediary a
                 WHERE INSTR(p_param_intm_type, a.intm_type, 1) > 0
                 ORDER BY a.intm_name)
      LOOP
         res.intm_no := i.intm_no;
         res.intm_name := i.intm_name;
         res.intm_type := i.intm_type;
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   PROCEDURE check_bancassurance (
      p_iss_cd              IN  gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         IN  gipi_invoice.prem_seq_no%TYPE,
      p_intm_no             IN  giis_intermediary.intm_no%TYPE,
      v_banc_sw             OUT gipi_polbasic.bancassurance_sw%TYPE,
      v_banc_type           OUT gipi_polbasic.banc_type_cd%TYPE,
      v_fixed_tag           OUT giis_banc_type_dtl.fixed_tag%TYPE,
      v_intm_type           OUT giis_banc_type_dtl.intm_type%TYPE,
      v_intm_cnt            OUT NUMBER,
      p_v_mod_btyp          IN  VARCHAR2,
      v_param_intm_type     OUT VARCHAR2,
      v_ityp                OUT VARCHAR2,
      p_comm_rec_id         IN  giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_type           IN  giis_banc_type_dtl.intm_type%TYPE,
      p_nbt_banc_type_cd    IN  giis_banc_type_dtl.banc_type_cd%TYPE    
   ) IS
   BEGIN
      BEGIN
         SELECT DISTINCT bancassurance_sw, banc_type_cd
           INTO v_banc_sw, v_banc_type
           FROM gipi_polbasic a, gipi_invoice b 
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = p_iss_cd
            AND b.prem_seq_no = p_prem_seq_no;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_banc_sw := NULL;
              v_banc_type := NULL; 
      END;
         
      BEGIN
         SELECT NVL(a.fixed_tag,'N') fixed_tag, a.intm_type
           INTO v_fixed_tag, v_intm_type
           FROM giis_banc_type_dtl a, giis_intermediary b
          WHERE a.intm_type = b.intm_type
            AND a.banc_type_cd = v_banc_type
            AND b.intm_no = p_intm_no;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_fixed_tag := 'N';
              v_intm_type := NULL;
      END;
  
      BEGIN
         SELECT COUNT(*)
           INTO v_intm_cnt
           FROM giis_intermediary
          WHERE intm_type = v_intm_type;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_intm_cnt := 0;
      END;    
      
      IF v_banc_sw = 'Y' THEN
         v_param_intm_type := NULL;
         IF p_v_mod_btyp = 'N' THEN
            BEGIN
              SELECT DISTINCT ''''||b.intm_type||'''' intm_type
                INTO v_ityp
                FROM giac_new_comm_inv a, giis_intermediary b
               WHERE a.iss_cd = p_iss_cd
                 AND a.prem_seq_no = p_prem_seq_no
                 AND a.intm_no = b.intm_no
                 AND comm_rec_id = p_comm_rec_id
                 AND b.intm_type NOT IN (SELECT DISTINCT get_intm_type(a.intm_no) intm_type 
                                           FROM giac_new_comm_inv a
                                          WHERE delete_sw ='N'
                                            AND tran_flag = 'U'
                                            AND a.iss_cd = p_iss_cd
                                            AND a.prem_seq_no = p_prem_seq_no)
                 AND intm_type IN (SELECT intm_type 
                                     FROM giis_banc_type_dtl
                                    WHERE fixed_tag ='N'
                                      AND banc_type_cd = v_banc_type
                                      AND intm_type = p_intm_type);--:BANCA_B.intm_type
            EXCEPTION
               WHEN no_data_found THEN v_ityp := NULL;
            END;
         ELSIF p_v_mod_btyp = 'Y' THEN
            SELECT ''''||intm_type||'''' intm_type 
              INTO v_ityp
              FROM giis_banc_type_dtl
             WHERE fixed_tag ='N'
               AND banc_type_cd = p_nbt_banc_type_cd--:BANCA.nbt_banc_type_cd
               AND intm_type = p_intm_type;--:BANCA_B.intm_type;
         END IF;
      END IF;          
   END;
   
   PROCEDURE ins_inv_tab (
      p_user_id                     giis_users.user_id%TYPE,
      p_b140_prem_amt               gipi_invoice.prem_amt%TYPE,
      p_banca_b_share_percentage    giis_banc_type_dtl.share_percentage%TYPE,
      p_banca_b_nbt_intm_no         giis_intermediary.intm_no%TYPE,
      p_b140_nbt_line_cd            giis_peril.line_cd%TYPE,
      p_b140_iss_cd                 gipi_invperil.iss_cd%TYPE,
      p_b140_prem_seq_no            gipi_invperil.prem_seq_no%TYPE,
      p_banca_nbt_banc_type_cd      giis_banc_type.banc_type_cd%TYPE,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_b140_policy_id              giac_new_comm_inv.policy_id%TYPE
   ) IS
         v_max                    NUMBER;
      v_tran_no             NUMBER;
      v_cnt                 NUMBER := 0;
      v_dup                 VARCHAR2(1) := 'N';
      v_cpid                NUMBER(9);
      v_wtax_rt             NUMBER(16,2);
      v_iprem_amt           NUMBER(16,2);
      v_pprem_amt           NUMBER(16,2);
      v_comm_rt             NUMBER(16,7);
      v_comm_amt            NUMBER(16,2) := 0;
      v_wtax                NUMBER(16,2) := 0;
      v_nc_amt              NUMBER(16,2) := 0;
      v_icomm_amt           NUMBER(16,2) := 0;
      v_iwtax               NUMBER(16,2) := 0;
      v_inc_amt             NUMBER(16,2) := 0;
      v_pct                 NUMBER;
   BEGIN
      SELECT MAX(comm_rec_id)+1
        INTO v_max
        FROM giac_new_comm_inv;
   
      v_iprem_amt := ROUND(p_b140_prem_amt * (p_banca_b_share_percentage/100), 2);
         
      IF v_iprem_amt = 0 THEN
         RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#I#Cannot compute amounts. Share of premium is equal to zero.');
      END IF;
      
      BEGIN
         SELECT NVL(wtax_rate, 0.0) / 100.0
           INTO v_wtax_rt
           FROM giis_intermediary
          WHERE intm_no = p_banca_b_nbt_intm_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#No record of intermediary in Giis_Intermediary.');
      END;
      
      FOR inv IN (SELECT a.peril_cd, a.prem_amt, b.peril_name
                    FROM gipi_invperil a, giis_peril b 
                   WHERE b.peril_cd  = a.peril_cd
                     AND b.line_cd   = p_b140_nbt_line_cd
                     AND iss_cd      = p_b140_iss_cd
                     AND prem_seq_no = p_b140_prem_seq_no)
      LOOP
         SELECT comm_peril_id.NEXTVAL 
           INTO v_cpid
           FROM DUAL;
       
         SELECT rate
           INTO v_comm_rt
           FROM giis_banc_type
          WHERE banc_type_cd = p_banca_nbt_banc_type_cd;
         
         v_pct         := inv.prem_amt / p_b140_prem_amt;   
         v_pprem_amt   := ROUND(v_iprem_amt * v_pct,2);
         v_comm_amt    := ROUND(v_pprem_amt * (v_comm_rt / 100), 2);
         v_wtax        := ROUND(v_comm_amt * v_wtax_rt);
         v_nc_amt      := v_comm_amt - v_wtax;
         
         INSERT INTO giac_new_comm_inv_peril
                    (comm_rec_id,          comm_peril_id,        intm_no,
                     iss_cd,               prem_seq_no,          peril_cd,
                     premium_amt,          commission_amt,       commission_rt,
                     wholding_tax,         tran_date,            tran_flag, 
                     tran_no,              fund_cd,              branch_cd)
              VALUES(v_max,                inv.peril_cd,         p_banca_b_nbt_intm_no,
                     p_b140_iss_cd,        p_b140_prem_seq_no,   inv.peril_cd,
                     v_pprem_amt,          v_comm_amt,           v_comm_rt,
                     v_wtax,               SYSDATE,              'U', 
                     v_tran_no,            p_fund_cd,            p_branch_cd);
                     
         v_icomm_amt     := v_icomm_amt + v_comm_amt;
         v_iwtax         := v_iwtax + v_wtax;
         v_inc_amt       := v_icomm_amt - v_iwtax;
      END LOOP;
      
      INSERT INTO giac_new_comm_inv  
                 (comm_rec_id,          intm_no,                iss_cd,
                  policy_id,            prem_seq_no,            share_percentage,
                  premium_amt,          commission_amt,         wholding_tax,     
                  tran_date,            tran_flag,              user_id,      
                  tran_no,              fund_cd,                branch_cd)
           VALUES(v_max,                  p_banca_b_nbt_intm_no,    p_b140_iss_cd,
                  p_b140_policy_id,     p_b140_prem_seq_no,     p_banca_b_share_percentage,
                  v_iprem_amt,          v_icomm_amt,            v_iwtax,
                  SYSDATE,              'U',                    p_user_id, 
                  v_tran_no,            p_fund_cd,              p_branch_cd);
   END ins_inv_tab;
   
   PROCEDURE apply_banc_assurance (
      p_v_mod_btyp                  VARCHAR2,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_banca_nbt_banc_type_cd      gipi_polbasic.banc_type_cd%TYPE,
      p_gnci_policy_id              gipi_polbasic.policy_id%TYPE,
      p_b140_iss_cd                 gipi_invperil.iss_cd%TYPE,
      p_b140_prem_seq_no            gipi_invperil.prem_seq_no%TYPE
   ) IS
      v_max                 NUMBER;
      v_tran_no             NUMBER;     
   BEGIN   
      IF p_v_mod_btyp = 'Y' THEN
         SELECT MAX(comm_rec_id)+1
           INTO v_max
           FROM giac_new_comm_inv;

         v_tran_no := giac_sequence_generation(p_fund_cd,p_branch_cd,'NEW_COMM_INV_TRAN_NO',TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),TO_NUMBER(TO_CHAR(SYSDATE,'MM')));
         
         UPDATE gipi_polbasic
            SET banc_type_cd = p_banca_nbt_banc_type_cd
          WHERE policy_id = p_gnci_policy_id;
          
         UPDATE giac_new_comm_inv
            SET delete_sw   = 'Y'
          WHERE iss_cd      = p_b140_iss_cd
            AND prem_seq_no = p_b140_prem_seq_no
            AND comm_rec_id < v_max;
       
         UPDATE giac_new_comm_inv_peril
            SET delete_sw   = 'Y'
          WHERE iss_cd      = p_b140_iss_cd
            AND prem_seq_no = p_b140_prem_seq_no
            AND comm_rec_id < v_max;
            
         UPDATE giac_new_comm_inv
            SET delete_sw   = 'Y'
          WHERE iss_cd      = p_b140_iss_cd
            AND prem_seq_no = p_b140_prem_seq_no
            AND comm_rec_id < v_max;
           
         UPDATE giac_new_comm_inv_peril
            SET delete_sw   = 'Y'
          WHERE iss_cd      = p_b140_iss_cd
            AND prem_seq_no = p_b140_prem_seq_no
            AND comm_rec_id < v_max;
      ELSE
         BEGIN
            SELECT DISTINCT comm_rec_id, tran_no
              INTO v_max, v_tran_no
              FROM giac_new_comm_inv
             WHERE iss_cd      = p_b140_iss_cd
               AND prem_seq_no = p_b140_prem_seq_no
               AND delete_sw   = 'N'
               AND comm_rec_id = (SELECT MAX(comm_rec_id) 
                                    FROM giac_new_comm_inv
                                   WHERE iss_cd      = p_b140_iss_cd
                                     AND prem_seq_no = p_b140_prem_seq_no);
         EXCEPTION
               WHEN too_many_rows THEN
                  NULL;
          END;
      END IF;
   END apply_banc_assurance;
   
   PROCEDURE apply_banc_assurance_n (
      p_b140_iss_cd                 giac_new_comm_inv.iss_cd%TYPE,
      p_b140_prem_seq_no            giac_new_comm_inv.prem_seq_no%TYPE,
      p_banca_b_nbt_intm_no         giac_new_comm_inv.intm_no%TYPE,
      p_banca_b_mod_tag             VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_b140_prem_amt               gipi_invoice.prem_amt%TYPE,
      p_banca_b_share_percentage    giis_banc_type_dtl.share_percentage%TYPE,      
      p_b140_nbt_line_cd            giis_peril.line_cd%TYPE,
      p_banca_nbt_banc_type_cd      giis_banc_type.banc_type_cd%TYPE,
      p_fund_cd                     giac_new_comm_inv_peril.fund_cd%TYPE,                      
      p_branch_cd                   giac_new_comm_inv_peril.branch_cd%TYPE,
      p_b140_policy_id              giac_new_comm_inv.policy_id%TYPE
   ) IS
      v_dup         VARCHAR2(1) := 'N';
   BEGIN
      FOR inv IN (SELECT intm_no 
                    FROM giac_new_comm_inv
                   WHERE iss_cd = p_b140_iss_cd 
                     AND prem_seq_no = p_b140_prem_seq_no
                     AND delete_sw = 'Y'
                     AND intm_no = p_banca_b_nbt_intm_no
                     AND comm_rec_id = (SELECT MAX(comm_rec_id) 
                                          FROM giac_new_comm_inv
                                         WHERE iss_cd = p_b140_iss_cd
                                           AND prem_seq_no = p_b140_prem_seq_no))
      LOOP
            v_dup := 'Y';
      END LOOP;
       
      IF p_banca_b_mod_tag = 'Y' THEN
         IF v_dup = 'N' THEN--insert new record for the same comm_rec_id
            ins_inv_tab(p_user_id,p_b140_prem_amt,p_banca_b_share_percentage,p_banca_b_nbt_intm_no,p_b140_nbt_line_cd,p_b140_iss_cd,p_b140_prem_seq_no,
                        p_banca_nbt_banc_type_cd,p_fund_cd,p_branch_cd,p_b140_policy_id);
         ELSIF v_dup = 'Y' THEN--update delete_sw of the existing record
              UPDATE giac_new_comm_inv
                 SET delete_sw = 'N'
               WHERE iss_cd = p_b140_iss_cd 
               AND prem_seq_no = p_b140_prem_seq_no
                 AND intm_no = p_banca_b_nbt_intm_no
               AND comm_rec_id = (SELECT MAX(comm_rec_id) 
                                    FROM giac_new_comm_inv
                                   WHERE iss_cd = p_b140_iss_cd
                                    AND prem_seq_no = p_b140_prem_seq_no);
              UPDATE giac_new_comm_inv_peril
                 SET delete_sw = 'N'
               WHERE iss_cd = p_b140_iss_cd 
               AND prem_seq_no = p_b140_prem_seq_no
                 AND intm_no = p_banca_b_nbt_intm_no
               AND comm_rec_id = (SELECT MAX(comm_rec_id) 
                                    FROM giac_new_comm_inv
                                   WHERE iss_cd = p_b140_iss_cd
                                     AND prem_seq_no = p_b140_prem_seq_no);
         END IF;
      END IF;
   END apply_banc_assurance_n;
   
   PROCEDURE recompute_comm_rate_giacs408(
      p_line_cd                 IN      giis_intm_special_rate.line_cd%TYPE, 
      p_subline_cd              IN      giis_intm_special_rate.subline_cd%TYPE,
      p_b140_iss_cd             IN      gipi_invoice.iss_cd%TYPE,
      p_b140_prem_seq_no        IN      gipi_invoice.prem_seq_no%TYPE,
      p_b140_policy_id          IN      gipi_invoice.policy_id%TYPE,
      p_gncp_peril_cd           IN      giac_new_comm_inv_peril.peril_cd%TYPE,
      p_gncp_intm_no            IN      giac_new_comm_inv_peril.intm_no%TYPE,
      p_gncp_commission_rt      OUT     giis_banc_type.rate%TYPE,
      p_gncp_commission_amt     OUT     giac_new_comm_inv_peril.commission_amt%TYPE,
      p_gncp_premium_amt        IN OUT  giac_new_comm_inv_peril.premium_amt%TYPE,
      p_gncp_wholding_tax       OUT     giac_new_comm_inv_peril.premium_amt%TYPE,
      p_gnci_nbt_wtax_rate      IN      giis_intermediary.wtax_rate%TYPE,
      p_gncp_dsp_netcomm_amt    OUT     giac_new_comm_inv_peril.commission_amt%TYPE
   ) IS
      v_banc_sw     VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT DISTINCT bancassurance_sw
           INTO v_banc_sw
           FROM gipi_polbasic a, gipi_invoice b 
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = p_b140_iss_cd
            AND b.prem_seq_no = p_b140_prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_banc_sw := NULL;
      END;
         
      IF v_banc_sw ='Y' THEN
         SELECT rate 
           INTO p_gncp_commission_rt 
           FROM giis_banc_type
          WHERE banc_type_cd = (SELECT banc_type_cd 
                                  FROM gipi_polbasic
                                 WHERE policy_id = p_b140_policy_id);
      ELSE
         p_gncp_commission_rt := get_intm_rate_giacs408(p_gncp_peril_cd, p_gncp_intm_no, p_line_cd, p_subline_cd, p_b140_iss_cd, p_b140_policy_id);
      END IF;
         
      p_gncp_commission_amt  := ROUND(p_gncp_premium_amt * (p_gncp_commission_rt / 100),2);
      p_gncp_wholding_tax    := ROUND(p_gncp_commission_amt * p_gnci_nbt_wtax_rate, 2);
      p_gncp_dsp_netcomm_amt := p_gncp_commission_amt - p_gncp_wholding_tax;
         
--         FOR j IN (SELECT SUM(premium_amt) tot_premium_amt, SUM(commission_amt) tot_commission_amt, SUM(wholding_tax) tot_wholding_tax, SUM(dsp_netcomm_amt) tot_netcomm_amt 
--                     FROM TABLE (giacs408_pkg.populate_peril_info(p_fund_cd, p_branch_cd, p_comm_rec_id, p_intm_no, p_line_cd)))
--         LOOP
--            v_peril.tot_premium_amt := j.tot_premium_amt;
--            v_peril.tot_commission_amt := j.tot_commission_amt;
--            v_peril.tot_wholding_tax := j.tot_wholding_tax;
--            v_peril.tot_netcomm_amt := j.tot_netcomm_amt;
--         END LOOP;
   END;
   
   PROCEDURE delete_comm_invoice(
      p_fund_cd               giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd             giac_new_comm_inv.branch_cd%TYPE,
      p_comm_rec_id           giac_new_comm_inv.comm_rec_id%TYPE,
      p_intm_no               giac_new_comm_inv.intm_no%TYPE
   ) IS
   BEGIN
      UPDATE giac_new_comm_inv
         SET delete_sw     = 'Y'
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND intm_no       = p_intm_no;
         
      UPDATE giac_new_comm_inv_peril --added by steven 11.24.2014
         SET delete_sw     = 'Y'
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND intm_no       = p_intm_no;
         
      -- bonok :: 10.18.2013 :: SR 247 - GENQA - to resolve ORA-02292
      /*DELETE FROM giac_prev_comm_inv_peril
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND intm_no       = p_intm_no;
         
      DELETE FROM giac_prev_parent_comm_invprl
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND chld_intm_no  = p_intm_no;
      
      DELETE FROM giac_new_comm_inv_peril
       WHERE fund_cd       = p_fund_cd
         AND branch_cd     = p_branch_cd
         AND comm_rec_id   = p_comm_rec_id
         AND intm_no       = p_intm_no;*/
   END;
   
   FUNCTION recompute_comm_rate_list (
      p_fund_cd         giac_new_comm_inv_peril.fund_cd%TYPE,
      p_branch_cd       giac_new_comm_inv_peril.branch_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv_peril.comm_rec_id%TYPE,
      p_intm_no         giac_new_comm_inv_peril.intm_no%TYPE,
      p_line_cd         giis_line.line_cd%TYPE,
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE
   )
      RETURN peril_list_tab PIPELINED
   IS
      v_peril           peril_list_type;
      v_banc_sw         gipi_polbasic.bancassurance_sw%TYPE;
      v_policy_id       gipi_polbasic.policy_id%TYPE;
      v_subline_cd      gipi_polbasic.subline_cd%TYPE;
      v_commission_rt   giis_banc_type.rate%TYPE;
      v_nbt_wtax_rate   giis_intermediary.wtax_rate%TYPE;
   BEGIN
      BEGIN
         SELECT DISTINCT a.bancassurance_sw, a.policy_id, a.subline_cd 
           INTO v_banc_sw, v_policy_id, v_subline_cd
           FROM gipi_polbasic a, gipi_invoice b 
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = p_iss_cd
            AND b.prem_seq_no = p_prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
          v_banc_sw := NULL;
      END;
      
      IF v_banc_sw = 'Y' THEN
         SELECT rate 
           INTO v_commission_rt 
           FROM giis_banc_type
          WHERE banc_type_cd = (SELECT banc_type_cd 
                                  FROM gipi_polbasic
                                 WHERE policy_id = v_policy_id);
      END IF; 
   
      FOR i IN (SELECT premium_amt, commission_rt, commission_amt,
                       wholding_tax, comm_rec_id, intm_no, iss_cd,
                       prem_seq_no, peril_cd, tran_date, tran_no, tran_flag,
                       comm_peril_id, delete_sw, fund_cd, branch_cd
                  FROM giac_new_comm_inv_peril
                 WHERE 1 = 1
                   AND fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND comm_rec_id = p_comm_rec_id
                   AND intm_no = p_intm_no)
      LOOP
         v_peril.premium_amt := i.premium_amt;
         v_peril.comm_rec_id := i.comm_rec_id; 
         v_peril.intm_no := i.intm_no;
         v_peril.iss_cd := i.iss_cd;
         v_peril.prem_seq_no := i.prem_seq_no;
         v_peril.peril_cd := i.peril_cd;
         v_peril.tran_date := i.tran_date;
         v_peril.tran_no := i.tran_no;
         v_peril.tran_flag := i.tran_flag;
         v_peril.comm_peril_id := i.comm_peril_id;
         v_peril.delete_sw := i.delete_sw;
         v_peril.fund_cd := i.fund_cd;
         v_peril.branch_cd := i.branch_cd;
         v_peril.dsp_peril_name := get_peril_name (p_line_cd, i.peril_cd);
         
         IF v_banc_sw != 'Y' OR v_banc_sw IS NULL THEN
            v_commission_rt := get_intm_rate_giacs408(i.peril_cd, i.intm_no, p_line_cd, v_subline_cd, p_iss_cd, v_policy_id);
         END IF;
         
         v_peril.commission_rt := TRIM(TO_CHAR(v_commission_rt, '990.9999999'));
         
         SELECT NVL(wtax_rate, 0.0) / 100.0
           INTO v_nbt_wtax_rate
           FROM giis_intermediary
          WHERE intm_no = i.intm_no;
         
         v_peril.commission_amt  := ROUND(v_peril.premium_amt * (v_peril.commission_rt / 100),2);
         v_peril.wholding_tax    := ROUND(v_peril.commission_amt * v_nbt_wtax_rate, 2);
         v_peril.dsp_netcomm_amt := v_peril.commission_amt - v_peril.wholding_tax;
         
         v_peril.record_status   := '1';
         
         PIPE ROW (v_peril);
      END LOOP;
   END;
   --added by steven 10.21.2014
    PROCEDURE get_adjusted_prem_amt (
       p_iss_cd                      gipi_invoice.iss_cd%TYPE,
       p_prem_seq_no                 gipi_invoice.prem_seq_no%TYPE,
       p_intm_no                     giac_new_comm_inv.intm_no%TYPE,
       p_share_percentage            giac_new_comm_inv.share_percentage%TYPE,
       p_policy_id                   gipi_polbasic.policy_id%TYPE,
       p_premium_amt        IN OUT   giac_new_comm_inv.premium_amt%TYPE
    )
    IS
       v_sum_share_percentage   giac_new_comm_inv.share_percentage%TYPE;
       v_sum_premium_amt        giac_new_comm_inv.premium_amt%TYPE;
       v_prem_amt               gipi_polbasic.prem_amt%TYPE;
       v_currency_rt            gipi_invoice.currency_rt%TYPE;
    BEGIN
       FOR i IN (SELECT SUM (share_percentage) share_percentage,
                        SUM (premium_amt) premium_amt
                   FROM giac_new_comm_inv
                  WHERE iss_cd = p_iss_cd
                    AND prem_seq_no = p_prem_seq_no
                    AND intm_no <> p_intm_no
                    AND tran_flag = 'U' 
                    AND NVL (delete_sw, 'N') = 'N')
       LOOP
          v_sum_share_percentage := i.share_percentage + p_share_percentage;
          v_sum_premium_amt := i.premium_amt;
          EXIT;
       END LOOP;

       SELECT prem_amt
         INTO v_prem_amt
         FROM gipi_polbasic
        WHERE policy_id = p_policy_id;
        
       SELECT currency_rt
         INTO v_currency_rt
         FROM gipi_invoice
        WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

       IF v_sum_share_percentage = 100
       THEN
          p_premium_amt := (v_prem_amt/v_currency_rt) - v_sum_premium_amt;
       END IF;
    END;
    
    PROCEDURE update_comm_tables(
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_comm_rec_id     giac_new_comm_inv.COMM_REC_ID%TYPE,
      p_intm_no         giac_new_comm_inv.INTM_NO%TYPE
    )
    AS
    BEGIN
        --update previous commission tables
        FOR mr IN ( SELECT a.comm_rec_id, a.intm_no,
                           SUM (a.commission_amt) commission_amt,
                           SUM (a.wholding_tax) wholding_tax
                      FROM giac_prev_comm_inv_peril a,
                           giac_prev_comm_inv b
                     WHERE a.comm_rec_id = b.comm_rec_id
                       AND a.intm_no = b.intm_no
                       AND b.iss_cd = p_iss_cd             
                       AND b.prem_seq_no = p_prem_seq_no
                       AND b.comm_rec_id = p_comm_rec_id
                       AND b.INTM_NO = p_intm_no
                  GROUP BY a.comm_rec_id, a.intm_no)
        LOOP
          UPDATE giac_prev_comm_inv
             SET commission_amt = mr.commission_amt,
                 wholding_tax   = mr.wholding_tax
           WHERE comm_rec_id    = mr.comm_rec_id 
             AND intm_no        = mr.intm_no;
        END LOOP;
        --end prev comm

        --update new commission tables
        FOR mc IN ( SELECT comm_rec_id, intm_no,
                           SUM (commission_amt) commission_amt,
                           SUM (wholding_tax) wholding_tax
                      FROM giac_new_comm_inv_peril
                     WHERE iss_cd = p_iss_cd 
                       AND prem_seq_no = p_prem_seq_no
                       AND comm_rec_id = p_comm_rec_id
                       AND INTM_NO = p_intm_no
                  GROUP BY comm_rec_id, intm_no)
        LOOP
          UPDATE giac_new_comm_inv
             SET commission_amt = mc.commission_amt,
                 wholding_tax   = mc.wholding_tax
           WHERE comm_rec_id    = mc.comm_rec_id 
             AND intm_no        = mc.intm_no;
        END LOOP;
        --end new comm
		
		--update main commission tables
        FOR inv IN ( SELECT iss_cd, prem_seq_no,
                            SUM (commission_amt) commission_amt,
                            SUM (wholding_tax) wholding_tax
                       FROM gipi_comm_inv_peril
                      WHERE iss_cd = p_iss_cd 
                        AND prem_seq_no = p_prem_seq_no
                   GROUP BY iss_cd, prem_seq_no)
        LOOP
          UPDATE gipi_comm_invoice
             SET commission_amt = inv.commission_amt,
                 wholding_tax = inv.wholding_tax
           WHERE iss_cd = inv.iss_cd 
             AND prem_seq_no = inv.prem_seq_no;
        END LOOP;
        --end comm invoice 
    END update_comm_tables;
   
END giacs408_pkg;
/



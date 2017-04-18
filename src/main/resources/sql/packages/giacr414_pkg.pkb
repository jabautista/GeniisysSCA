CREATE OR REPLACE PACKAGE BODY CPI.giacr414_pkg 
AS
   FUNCTION get_giacr414_dtls ( 
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_post_tran_sw   VARCHAR2,
      p_report_id      VARCHAR2,
      p_from           VARCHAR2,
      p_to             VARCHAR2,
      p_user_id        GIIS_USERS.user_id%TYPE --marco - 07.23.2014 - added parameter
   )
      RETURN get_giacr414_tab PIPELINED
   IS
      v_list       get_giacr414_type;
      v_assd_no    NUMBER;
      v_par_id     NUMBER;
      v_line_cd    VARCHAR2 (5);
      v_peril_cd   gipi_comm_inv_peril.peril_cd%TYPE;
      v_exists     VARCHAR2(1) := 'N';
   BEGIN
      --marco - 07.23.2014 - moved outside for loop; to display header if no records are found
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_address := giisp.v ('COMPANY_ADDRESS');
      v_list.cf_from_to :=
               'For the period of '
            || TO_CHAR (TO_DATE (p_from, 'mm/dd/yyyy'), 'fmMonth DD, RRRR')
            || ' to '
            || TO_CHAR (TO_DATE (p_to, 'mm/dd/yyyy'), 'fmMonth DD, RRRR');
      v_list.cf_same_from_to := TO_CHAR (TO_DATE (p_to, 'mm/dd/yyyy'), 'fmMonth DD, RRRR');
   
      FOR i IN (SELECT   b.iss_cd || '-'
                         || LPAD (b.prem_seq_no, 12, 0) inv_no,
                         or_pref_suf || '-' || LPAD (or_no, 10, 0) or_no,
                         input_vat_amt, comm_amt, b.intm_no, a.gacc_tran_id, 
                         a.or_date, b.iss_cd, b.prem_seq_no --added columns by robert SR 5227 02.26.16 
                    FROM giac_order_of_payts a,
                         giac_comm_payts b,
                         giac_acctrans c
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = c.tran_id
                     AND or_flag = 'P'
                     AND a.gibr_branch_cd =
                                           NVL (p_branch_cd, a.gibr_branch_cd)
                     /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                      a.gibr_branch_cd,
                                                      p_module_id,
                                                      p_user_id
                                                     ) = 1*/ --Comment out by pjsantos 11/24/2016, for optimization GENQA 5851
                     AND TRUNC (tran_date) BETWEEN TO_DATE (p_from,
                                                            'MM-DD-YYYY'
                                                           )
                                               AND TO_DATE (p_to,
                                                            'MM-DD-YYYY')
                     /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                      b.iss_cd,
                                                      p_module_id,
                                                      p_user_id
                                                     ) = 1*/ --Comment out by pjsantos 11/24/2016, replaced by codes below for optimization GENQA 5851
                    AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = a.gibr_branch_cd)
                ORDER BY b.iss_cd, b.prem_seq_no)--Added by Carlo Rubenecia SR5354  04.29.2016
      LOOP
         v_exists := 'Y';
         v_list.invoice_no := i.inv_no;
         v_list.or_no := i.or_no;
         v_list.input_vat := i.input_vat_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.or_date := TO_CHAR (i.or_date, 'MM-DD-YYYY'); --added or_date by robert SR 5227 02.04.16
         BEGIN
            FOR chu IN (SELECT gci.policy_id, gci.premium_amt, gci.commission_amt --added premium_amt, commission_amt by pjsantos 11/24/2016, for optimization GENQA 5851
                          FROM gipi_comm_invoice gci
                         WHERE /*iss_cd || '-' || LPAD (prem_seq_no, 12, 0) =
                                                                     i.inv_no
                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                            iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ) = 1*/ --Removed by pjsantos 11/24/2016, checking of security is already handled in main loop, for optimization GENQA 5851
                               gci.iss_cd      = i.iss_cd
                           AND gci.prem_seq_no = i.prem_seq_no)
            LOOP
               v_list.policy_id := chu.policy_id;
               /*Moved here by pjsantos 11/24/2016, for optimization GENQA 5851*/
               v_list.policy_no := get_policy_no (chu.policy_id); 
               v_list.premium   := chu.premium_amt;
               v_list.invoice_comm_amt := chu.commission_amt;
               --pjsantos end
               BEGIN
                /*  FOR ctr1 IN (SELECT par_id
                                 FROM gipi_polbasic
                                WHERE policy_id = chu.policy_id)
                  LOOP
                     v_par_id := ctr1.par_id;

                     FOR ctr2 IN (SELECT assd_no
                                    FROM gipi_parlist
                                   WHERE par_id = v_par_id)
                     LOOP
                        v_assd_no := ctr2.assd_no;

                        FOR ctr3 IN (SELECT assd_name
                                       FROM giis_assured
                                      WHERE assd_no = v_assd_no)
                        LOOP
                           v_list.assd_name := ctr3.assd_name;
                        END LOOP;
                     END LOOP;
                  END LOOP;*/--Replaced by code below by pjsantos 11/24/2016, for optimization GENQA 5851     
                     SELECT a.assd_name
                       INTO v_list.assd_name
                       FROM giis_assured a, 
                            gipi_polbasic b, 
                            gipi_parlist c
                      WHERE a.assd_no   = c.assd_no
                        AND b.par_id    = c.par_id
                        AND b.policy_id = chu.policy_id;  
                     EXCEPTION 
                           WHEN NO_DATA_FOUND
                            THEN      
                              v_list.assd_name := NULL;                              
               END;

               /*BEGIN
                  FOR rec IN
                     (SELECT get_policy_no (chu.policy_id) v_policy_no
                        FROM DUAL)
                  LOOP
                     v_list.policy_no := rec.v_policy_no;
                  END LOOP;
               END;

               BEGIN
                  FOR rec IN (SELECT premium_amt
                                FROM gipi_comm_invoice
                               WHERE policy_id = chu.policy_id)
                  LOOP
                     v_list.premium := rec.premium_amt;
                  END LOOP;
               END;*/ --Moved code above in loop chu by pjsantos 11/24/2016, for optimization GENQA 5851  

               BEGIN
                  /*FOR ctr1 IN (SELECT line_cd
                                 FROM gipi_polbasic
                                WHERE policy_id = chu.policy_id)
                  LOOP
                     v_line_cd := ctr1.line_cd;

                     FOR ctr2 IN (SELECT peril_cd
                                    FROM gipi_comm_inv_peril
                                   WHERE    iss_cd
                                         || '-'
                                         || LPAD (prem_seq_no, 12, 0) =
                                                                      i.inv_no)
                     LOOP
                        v_peril_cd := ctr2.peril_cd;

                        FOR ctr3 IN (SELECT peril_sname
                                       FROM giis_peril
                                      WHERE peril_cd = v_peril_cd
                                        AND line_cd = v_line_cd)
                        LOOP
                           v_list.peril := ctr3.peril_sname;
                        END LOOP;
                     END LOOP;
                  END LOOP;*/--Replaced by code below by pjsantos 11/24/2016, for optimization GENQA 5851
                  SELECT a.peril_sname
                    INTO v_list.peril
                    FROM giis_peril a,
                         gipi_comm_inv_peril b,
                         gipi_polbasic c
                   WHERE a.peril_cd = b.peril_cd
                     AND a.line_cd  = c.line_cd
                     AND b.iss_cd   = i.iss_cd
                     AND b.prem_seq_no = i.prem_seq_no
                     AND c.policy_id   = chu.policy_id
                     AND ROWNUM = 1
                ORDER BY b.prem_seq_no DESC;
                  EXCEPTION
                        WHEN NO_DATA_FOUND
                         THEN
                            v_list.peril := NULL;                    
               END;

               /*BEGIN
                  FOR rec IN (SELECT commission_amt
                                FROM gipi_comm_invoice
                               WHERE policy_id = chu.policy_id)
                  LOOP
                     v_list.invoice_comm_amt := rec.commission_amt;
                  END LOOP;
                END;*/--Moved code above in loop chu by pjsantos 11/24/2016, for optimization GENQA 5851                
            END LOOP;
         END;

         BEGIN
            v_list.cv_no := null; --added by robert SR 5227 02.04.16
            FOR rec IN (SELECT DECODE (d.comm_slip_pref || '-'
                                       || d.comm_slip_no,
                                       '-', NULL,
                                          d.comm_slip_pref
                                       || '-'
                                       || TO_CHAR (d.comm_slip_no,
                                                   'FM099999999999'
                                                  )
                                      ) cv_no 
                          FROM giac_comm_slip_ext d
                         WHERE d.gacc_tran_id = i.gacc_tran_id 
                           --added condition by robert SR 5227 02.26.16
                           AND d.iss_cd = i.iss_cd
                           AND d.prem_seq_no = i.prem_seq_no
                           AND d.intm_no = i.intm_no)
            LOOP
               v_list.cv_no := rec.cv_no;
            END LOOP;
         END;

         BEGIN
            FOR ctr1 IN (SELECT intm_type || '-' || intm_no AGENT
                           FROM giis_intermediary
                          WHERE intm_no = i.intm_no)
            LOOP
               v_list.AGENT := ctr1.AGENT;
            END LOOP;
         END;

         BEGIN
            FOR t IN (SELECT UPPER (a.report_title), c.label, d.signatory,
                             d.designation
                        FROM giis_reports a,
                             giac_documents b,
                             giac_rep_signatory c,
                             giis_signatory_names d
                       WHERE UPPER (a.report_id) = UPPER (p_report_id)
                         AND a.report_id = b.report_id
                         AND b.report_no = c.report_no
                         AND c.signatory_id = d.signatory_id)
            LOOP
               v_list.cf_label := t.label;
               v_list.signatory := t.signatory;
               v_list.designation := t.designation;
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      -- marco - 07.23.2014
      IF v_exists = 'N' THEN
         PIPE ROW(v_list);
      END IF;

      RETURN;
   END get_giacr414_dtls;
END;
/



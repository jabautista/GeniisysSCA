CREATE OR REPLACE PACKAGE BODY CPI.giclr201a_pkg
AS
    FUNCTION get_giclr_201_a_report (
          p_date_sw         VARCHAR2,
          p_from_date       VARCHAR2,
          p_to_date         VARCHAR2,
          p_iss_cd          VARCHAR2,
          p_line_cd         VARCHAR2,
          p_rec_type_cd     VARCHAR2,
          p_user_id         VARCHAR2
    ) RETURN report_tab PIPELINED
    IS
        v_list        report_type;
        v_print       BOOLEAN := false;
    BEGIN        
        v_list.company_name := giisp.v ('COMPANY_NAME');
        v_list.company_address := giisp.v ('COMPANY_ADDRESS');
        
        BEGIN
            v_list.date_title := 'SCHEDULE OF SALVAGE RECOVERIES';
        END;

        BEGIN
            v_list.date_coverage := 'For the period of '||TO_CHAR (TO_DATE(p_from_date,'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                                    ' to '||TO_CHAR(TO_DATE(p_to_date,'mm-dd-yyyy'),'fmMonth DD, YYYY');
        END;
        
        FOR i IN (SELECT DISTINCT a.claim_id, b.recovery_id, a.line_cd, a.iss_cd,
                         a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' || LTRIM (TO_CHAR (a.clm_yy, '09'))
                            || '-' || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                         a.line_cd || '-' || a.subline_cd || '-' || a.pol_iss_cd || '-' || LTRIM (TO_CHAR (a.issue_yy, '09'))
                            || '-' || LTRIM (TO_CHAR (a.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         a.assd_no, a.dsp_loss_date, a.clm_file_date, b.rec_type_cd,
                         b.cancel_tag, b.recoverable_amt, c.payor_class_cd, c.payor_cd,
                         b.recovered_amt recovery_rec_amt,
                         c.recovered_amt payor_rec_amt, d.acct_tran_id, d.tran_date
                    FROM gicl_claims a,
                         gicl_clm_recovery b,
                         gicl_recovery_payor c,
                         gicl_recovery_payt d,
                         gicl_recovery_ds e
                   WHERE a.claim_id = b.claim_id
                     AND b.claim_id = c.claim_id
                     AND b.recovery_id = c.recovery_id
                     AND c.recovery_id = e.recovery_id
                     AND c.claim_id = d.claim_id(+)
                     AND c.recovery_id = d.recovery_id(+)
                     AND c.payor_class_cd = d.payor_class_cd(+)
                     AND c.payor_cd = d.payor_cd(+)
                     AND upper(a.user_id) = upper(p_user_id)
                     AND NVL (d.cancel_tag, 'N') = 'N'
                     AND b.rec_type_cd = giacp.v ('SALVAGE_RECOVERY_TYPE_CD')
                     AND DECODE (p_date_sw, 1, TRUNC (a.loss_date),
                                            2, TRUNC (a.clm_file_date),
                                            3, TRUNC (d.tran_date)
                                ) BETWEEN (TO_DATE(p_from_date,'mm-dd-yyyy')) AND (TO_DATE(p_to_date,'mm-dd-yyyy'))
                     AND a.line_cd = NVL (p_line_cd, DECODE (check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS201', UPPER(p_user_id) ),
                                                                1, a.line_cd,
                                                                0, ''
                                                            )
                                          )
                     AND a.iss_cd = NVL (p_iss_cd, DECODE (check_user_per_iss_cd2 (NULL, a.iss_cd, 'GICLS201', UPPER(p_user_id) ),
                                                                1, a.iss_cd,
                                                                0, ''
                                                           )
                                        )
                     AND b.rec_type_cd = NVL (p_rec_type_cd, b.rec_type_cd)
        )
        LOOP
            v_print := TRUE;
            v_list.print_details := 'Y';
            v_list.rec_type_cd := i.rec_type_cd;
            v_list.line_cd := i.line_cd;
            v_list.claim_id := i.claim_id;
            v_list.payor_cd := i.payor_cd;
            v_list.payor_class_cd := i.payor_class_cd;
            v_list.acct_tran_id := i.acct_tran_id;
            v_list.recovery_id := i.recovery_id;
            v_list.claim_no := i.claim_no;
            v_list.assd_no := i.assd_no;
            /*v_list.company_name := giisp.v ('COMPANY_NAME');        -- moved outside the loop : shan 01.22.2014
            v_list.company_address := giisp.v ('COMPANY_ADDRESS'); */
            v_list.recoverable_amt := i.recoverable_amt;
                 
            BEGIN
                SELECT assd_name
                  INTO v_list.assd_name
                  FROM giis_assured
                 WHERE assd_no = i.assd_no;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   v_list.assd_name := NULL;
            END;
                 
            /*  moved outside the loop : shan 01.22.2014
            BEGIN
              v_list.date_title := 'SCHEDULE OF SALVAGE RECOVERIES';
            END;

            BEGIN
              v_list.date_coverage := 'For the period of '||TO_CHAR (TO_DATE(p_from_date,'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                      ' to '||TO_CHAR(TO_DATE(p_to_date,'mm-dd-yyyy'),'fmMonth DD, YYYY');
            END;*/
                
            BEGIN
              FOR a IN (SELECT DISTINCT shr_recovery_amt
                          FROM gicl_recovery_ds a, gicl_recovery_payt b
                         WHERE a.recovery_id = b.recovery_id
                           AND a.recovery_payt_id = b.recovery_payt_id
                           AND a.share_type = 1
                           AND a.negate_tag is null
                           AND b.claim_id = i.claim_id
                           AND b.acct_tran_id = i.acct_tran_id
                           AND a.recovery_id = i.recovery_id
                            OR a.negate_tag = 'N' )
                LOOP
                    v_list.net_retention := a.shr_recovery_amt;
                END LOOP;
            END;
                
            BEGIN
             FOR a IN (SELECT DISTINCT shr_recovery_amt
                          FROM gicl_recovery_ds a, gicl_recovery_payt b
                         WHERE a.recovery_id = b.recovery_id
                           AND a.recovery_payt_id = b.recovery_payt_id
                           AND a.share_type = 3
                           AND a.negate_tag is null
                           AND b.claim_id = i.claim_id
                           AND b.acct_tran_id = i.acct_tran_id
                           AND a.recovery_id = i.recovery_id
                            OR a.negate_tag = 'N' )
                LOOP
                     v_list.facultative := a.shr_recovery_amt;
                 END LOOP;
            END;
                
            BEGIN
               FOR a IN (SELECT DISTINCT shr_recovery_amt
                          FROM gicl_recovery_ds a, gicl_recovery_payt b
                         WHERE a.recovery_id = b.recovery_id
                           AND a.recovery_payt_id = b.recovery_payt_id
                           AND a.share_type = 2
                           AND a.negate_tag is null
                           AND b.claim_id = i.claim_id
                           AND b.acct_tran_id = i.acct_tran_id
                           AND a.recovery_id = i.recovery_id
                            OR a.negate_tag = 'N' )
                 LOOP
                     v_list.treaty := a.shr_recovery_amt;
                 END LOOP;
            END;
                 
            BEGIN
               FOR a IN (SELECT DISTINCT shr_recovery_amt
                          FROM gicl_recovery_ds a, gicl_recovery_payt b
                         WHERE a.recovery_id = b.recovery_id
                           AND a.recovery_payt_id = b.recovery_payt_id
                           AND a.share_type = 4
                           AND a.negate_tag is null
                           AND b.claim_id = i.claim_id
                           AND b.acct_tran_id = i.acct_tran_id
                           AND a.recovery_id = i.recovery_id
                            OR a.negate_tag = 'N' )
                 LOOP
                     v_list.xol := a.shr_recovery_amt;
                 END LOOP;
            END;
                     
            PIPE ROW (v_list);
                 
        END LOOP;

        IF v_print = FALSE THEN
            v_list.print_details :='N';
            PIPE ROW(v_list);
        END IF;
        
        RETURN;
    END get_giclr_201_a_report;
   
   FUNCTION get_giclr_201_a_details_report (
      p_claim_id         NUMBER,
      p_acct_tran_id     VARCHAR2
   )
      RETURN giclr201a_tab PIPELINED
      IS
      v_list        giclr201a_type;
      
   BEGIN
      FOR i IN (SELECT DISTINCT b.intm_no, b.intm_name
  				  FROM gicl_intm_itmperil a, giis_intermediary b
  			     WHERE a.intm_no = b.intm_no
  				   AND a.claim_id = p_claim_id)
      LOOP
         v_list.intm_name := i.intm_name;
         
            BEGIN
               FOR t IN (SELECT tran_class, tran_class_no
                           FROM giac_acctrans
                          WHERE tran_id = p_acct_tran_id)
               LOOP
                  IF t.tran_class = 'COL'
                  THEN
                     FOR c IN (SELECT or_pref_suf, or_no
                                 FROM giac_order_of_payts
                                WHERE gacc_tran_id = p_acct_tran_id)
                     LOOP
                        IF c.or_no IS NOT NULL
                        THEN
                           v_list.ref_no :=
                                 c.or_pref_suf
                              || '-'
                              || LTRIM (TO_CHAR (c.or_no, '0999999999'));
                        ELSE
                           v_list.ref_no := NULL;
                        END IF;
                     END LOOP;
                  ELSIF t.tran_class = 'DV'
                  THEN
                     FOR r IN (SELECT document_cd, branch_cd, line_cd, doc_year, doc_mm,
                                      doc_seq_no
                                 FROM giac_payt_requests a, giac_payt_requests_dtl b
                                WHERE a.ref_id = b.gprq_ref_id
                                  AND b.tran_id = p_acct_tran_id)
                     LOOP
                        v_list.ref_no :=
                              r.document_cd
                           || '-'
                           || r.branch_cd
                           || '-'
                           || r.line_cd
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_year, '0999'))
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_mm, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (r.doc_seq_no, '099999'));

                        FOR d IN (SELECT dv_pref, dv_no
                                    FROM giac_disb_vouchers
                                   WHERE gacc_tran_id = p_acct_tran_id)
                        LOOP
                           IF d.dv_no IS NOT NULL
                           THEN
                              v_list.ref_no :=
                                    d.dv_pref
                                 || '-'
                                 || LTRIM (TO_CHAR (d.dv_no, '0999999999'));
                           ELSE
                              v_list.ref_no := NULL;
                           END IF;
                        END LOOP;
                     END LOOP;
                  ELSIF t.tran_class = 'JV'
                  THEN
                     IF t.tran_class_no IS NOT NULL
                     THEN
                        v_list.ref_no :=
                              t.tran_class
                           || '-'
                           || LTRIM (TO_CHAR (t.tran_class_no, '0999999999'));
                     ELSE
                        v_list.ref_no := NULL;
                     END IF;
                  END IF;
               END LOOP;
            END;
            
         PIPE ROW (v_list);
         
      END LOOP;

      RETURN;
   END get_giclr_201_a_details_report;
   
   FUNCTION get_giclr_201_a_2_report (
      p_payor_cd          GICL_RECOVERY_PAYOR.PAYOR_CD%TYPE,
      p_payor_class_cd    GICL_RECOVERY_PAYOR.PAYOR_CLASS_CD%TYPE
   )
      RETURN giclr201a_2tab PIPELINED
      IS
      v_list        giclr201a_2type;
      
   BEGIN
      FOR i IN (SELECT payee_last_name||decode(payee_first_name,NULL,NULL,
                   ', '||payee_first_name)||decode(payee_middle_name,NULL,NULL,
                   ' '||substr(payee_middle_name,1,1)||'.') payor
              FROM giis_payees
             WHERE payee_class_cd = p_payor_class_cd
               AND payee_no = p_payor_cd)
      LOOP
         v_list.payor := i.payor;
         
         PIPE ROW (v_list);
         
      END LOOP;

      RETURN;
   END get_giclr_201_a_2_report;
   
   FUNCTION get_giclr_201_a_3_report (
      p_claim_id         NUMBER,
      p_recovery_id      NUMBER,
      p_acct_tran_id     NUMBER
   )
      RETURN giclr201a_3tab PIPELINED
      IS
      v_list        giclr201a_3type;
      
   BEGIN
      FOR i IN (SELECT recoverable_amt
                FROM gicl_clm_recovery
               WHERE claim_id = p_claim_id
                 AND recovery_id = p_recovery_id)
      LOOP
         v_list.recoverable_amt := i.recoverable_amt;
         
        BEGIN
          FOR a IN (SELECT DISTINCT shr_recovery_amt
                      FROM gicl_recovery_ds a, gicl_recovery_payt b
                     WHERE a.recovery_id = b.recovery_id
                       AND a.recovery_payt_id = b.recovery_payt_id
                       AND a.share_type = 1
                       AND a.negate_tag is null
                       AND b.claim_id = p_claim_id
                       AND b.acct_tran_id = p_acct_tran_id
                       AND a.recovery_id = p_recovery_id
                       OR a.negate_tag = 'N' )
            LOOP
                v_list.net_retention := a.shr_recovery_amt;
            END LOOP;
        END;
        
        BEGIN
          FOR a IN (SELECT DISTINCT shr_recovery_amt
                      FROM gicl_recovery_ds a, gicl_recovery_payt b
                     WHERE a.recovery_id = b.recovery_id
                       AND a.recovery_payt_id = b.recovery_payt_id
                       AND a.share_type = 3
                       AND a.negate_tag is null
                       AND b.claim_id = p_claim_id
                       AND b.acct_tran_id = p_acct_tran_id
                       AND a.recovery_id = p_recovery_id
                       OR a.negate_tag = 'N' )
            LOOP
                v_list.facultative := a.shr_recovery_amt;
            END LOOP;
        END;
        
        BEGIN
          FOR a IN (SELECT DISTINCT shr_recovery_amt
                     FROM gicl_recovery_ds a, gicl_recovery_payt b
                    WHERE a.recovery_id = b.recovery_id
                      AND a.recovery_payt_id = b.recovery_payt_id
                      AND a.share_type = 2
                      AND a.negate_tag is null
                      AND b.claim_id = p_claim_id
                      AND b.acct_tran_id = p_acct_tran_id
                      AND a.recovery_id = p_recovery_id
                      OR a.negate_tag = 'N' )
            LOOP
                v_list.treaty := a.shr_recovery_amt;
            END LOOP;
        END;
        
        BEGIN
          FOR a IN (SELECT DISTINCT shr_recovery_amt
                     FROM gicl_recovery_ds a, gicl_recovery_payt b
                    WHERE a.recovery_id = b.recovery_id
                      AND a.recovery_payt_id = b.recovery_payt_id
                      AND a.share_type = 4
                      AND a.negate_tag is null
                      AND b.claim_id = p_claim_id
                      AND b.acct_tran_id = p_acct_tran_id
                      AND a.recovery_id = p_recovery_id
                      OR a.negate_tag = 'N' )
            LOOP
                v_list.xol := a.shr_recovery_amt;
            END LOOP;
        END;
         
         PIPE ROW (v_list);
         
      END LOOP;

      RETURN;
   END get_giclr_201_a_3_report;
   
   FUNCTION get_giclr_201_a_treaty_report (
      p_line_cd        VARCHAR2,
      p_rec_type_cd    VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2
   )
      RETURN giclr201a_treaty_tab PIPELINED
   IS
      v_list        giclr201a_treaty_type;
      
   BEGIN
      FOR i IN (SELECT SUM (a.shr_recovery_amt) trty_dist, b.trty_name, a.line_cd, d.rec_type_cd
                        FROM gicl_recovery_ds a,
                             giis_dist_share b,
                             gicl_recovery_payt c,
                             gicl_clm_recovery d
                       WHERE a.line_cd = b.line_cd
                         AND b.line_cd = d.line_cd
                         AND a.grp_seq_no = b.share_cd
                         AND a.recovery_id = c.recovery_id
                         AND c.recovery_id = d.recovery_id
                         AND a.recovery_payt_id = c.recovery_payt_id
                         AND a.share_type = b.share_type
                         AND a.share_type = 2
                         AND a.negate_tag IS NULL
                         AND b.trty_name = 'FACULTATIVE'
                         AND a.line_cd = p_line_cd
                         AND a.line_cd = 'MC'
                         AND d.rec_type_cd = NVL (p_rec_type_cd, giacp.v ('SALVAGE_RECOVERY_TYPE_CD'))
                         AND d.rec_type_cd = 'SP'
                         AND c.tran_date BETWEEN TO_DATE(p_from_date, 'MM-dd-YYYY') AND TO_DATE(p_to_date, 'MM-dd_YYYY')
        GROUP BY a.line_cd, b.trty_name, d.rec_type_cd)
      LOOP
         v_list.trty_name := i.trty_name;
         v_list.trty_dist := i.trty_dist;
      
         PIPE ROW (v_list);
         
      END LOOP;

      RETURN;
   END get_giclr_201_a_treaty_report;
END;
/



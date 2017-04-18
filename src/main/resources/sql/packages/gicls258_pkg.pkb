CREATE OR REPLACE PACKAGE BODY CPI.GICLS258_PKG AS
     FUNCTION get_clm_list_per_recovery_type (
          p_user_id VARCHAR2,
          p_rec_type_cd VARCHAR2,
          p_search_by_opt    VARCHAR2,
          p_date_as_of       VARCHAR2,
          p_date_from        VARCHAR2,
          p_date_to          VARCHAR2,
          p_recovery_no      VARCHAR2,
          p_payor_class      VARCHAR2,
          p_payor_name       VARCHAR2,
          p_clm_file_date    VARCHAR2,
          p_loss_date        VARCHAR2
        ) RETURN clm_list_per_recovery_tab PIPELINED 
        IS
          v_list clm_list_per_recovery_type;
        BEGIN
          FOR i IN (
              SELECT a.claim_id, a.line_cd, b.recovery_id,-- get_recovery_no(b.recovery_id) recovery_no --commented by MarkS 11.18.2016 SR5845 optimization
                (b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.rec_year,'0999'))||'-'||LTRIM(TO_CHAR(b.rec_seq_no, '009'))) recovery_no --added by MarkS 11.18.2016 SR5845 optimization
              , (d.payee_last_name||' '||d.payee_first_name||' '|| d.payee_middle_name) payor_name, --added by MarkS 11.18.2016 SR5845 optimization
                     e.class_desc payor_class, a.clm_file_date, a.dsp_loss_date, 
                     a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'
                     ||LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no,
                     f.clm_stat_desc claim_status, g.assd_name, (a.line_cd||'-'|| a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no, '0000009'))) claim_no --added by MarkS 11.18.2016 SR5845 optimization
                FROM gicl_claims a, gicl_clm_recovery b, gicl_recovery_payor c, giis_payee_class e,
                     giis_clm_stat f, giis_assured g, giis_payees d
--                    (SELECT payee_last_name||' '||payee_first_name||' '||payee_middle_name payor_name,
--                            payee_no, payee_class_cd 
--                         FROM giis_payees) d        --commented out by MarkS 11.18.2016 SR5845 optimization                                   
              WHERE a.claim_id = b.claim_id
                AND a.claim_id = c.claim_id
                AND b.recovery_id = c.recovery_id   
                AND c.payor_cd     = d.payee_no
                AND c.payor_class_cd = d.payee_class_cd 
                AND c.payor_class_cd = e.payee_class_cd
                AND a.clm_stat_cd = f.clm_stat_cd
                AND a.assd_no = g.assd_no 
                AND b.rec_type_cd =  p_rec_type_cd
                AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS258',p_user_id))
                            WHERE LINE_CD= a.line_cd and BRANCH_CD = a.iss_cd) --added by MarkS 11.18.2016 SR5845 optimization
--                AND a.claim_id IN (SELECT claim_id
--                                    FROM gicl_claims
--                                   WHERE check_user_per_line2 (a.line_cd,a.iss_cd,'GICLS258',p_user_id) = 1) --commented out by MarkS 11.18.2016 SR5845 optimization 
                AND UPPER((b.line_cd||'-'
                                    ||b.iss_cd||'-'
                                    ||LTRIM(TO_CHAR(b.rec_year,'0999'))
                                    ||'-'||LTRIM(TO_CHAR(b.rec_seq_no, '009')))) 
                                        LIKE UPPER(NVL(p_recovery_no, (b.line_cd||'-'||b.iss_cd||'-'
                                                                                ||LTRIM(TO_CHAR(b.rec_year,'0999'))
                                                                                ||'-'||LTRIM(TO_CHAR(b.rec_seq_no, '009'))))) --edited by MarkS 11.18.2016 SR5845 optimization
                AND UPPER(e.class_desc) LIKE UPPER(NVL(p_payor_class, e.class_desc))
                AND UPPER((d.payee_last_name||' '||d.payee_first_name||' '|| d.payee_middle_name)) LIKE UPPER(NVL(p_payor_name, (d.payee_last_name||' '||d.payee_first_name||' '|| d.payee_middle_name)))
                AND TRUNC(a.clm_file_date) = NVL(TO_DATE(p_clm_file_date, 'mm-dd-yyyy'), TRUNC(a.clm_file_date))
                AND TRUNC(a.dsp_loss_date) = NVL(TO_DATE(p_loss_date, 'mm-dd-yyyy'), TRUNC(a.dsp_loss_date))                   
                AND (   (    (DECODE (p_search_by_opt,
                                     'lossDate', TRUNC (a.dsp_loss_date),
                                     'fileDate', TRUNC (a.clm_file_date)
                                    ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                            )
                        AND (DECODE (p_search_by_opt,
                                     'lossDate', TRUNC (a.dsp_loss_date),
                                     'fileDate', TRUNC (a.clm_file_date)
                                    ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                            )
                       )
                    OR (DECODE (p_search_by_opt,
                                'lossDate', TRUNC (a.dsp_loss_date),
                                'fileDate', TRUNC (a.clm_file_date)
                               ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                       )
                   )                   
                ORDER BY recovery_no                                              
          )
          LOOP
            v_list.claim_id := i.claim_id;
            v_list.line_cd := i.line_cd;
            v_list.recovery_id := i.recovery_id;
            v_list.recovery_no := i.recovery_no;
            v_list.payor_name := i.payor_name;
            v_list.payor_class := i.payor_class;
            v_list.clm_file_date := i.clm_file_date;
            v_list.loss_date := i.dsp_loss_date;
            v_list.claim_no := i.claim_no;
            v_list.policy_no := i.policy_no;
            v_list.assd_name := i.assd_name;
            v_list.claim_status := i.claim_status;
            BEGIN
              SELECT COUNT(*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
              WHERE claim_id = i.claim_id;
              END;
            PIPE ROW(v_list);
          END LOOP;
          
          RETURN;
        
        END get_clm_list_per_recovery_type;
        
   FUNCTION get_recovery_details (
   p_claim_id gicl_clm_recovery.claim_id%TYPE,
   p_line_cd  gicl_claims.line_cd%TYPE,
   p_recovery_id gicl_clm_recovery.recovery_id%TYPE
   )
      RETURN recovery_details_tab PIPELINED
   IS
      v_list   recovery_details_type;
   BEGIN
      FOR i IN (SELECT   a.recovery_id, a.claim_id, a.line_cd, a.rec_year,
                         a.rec_seq_no, a.rec_type_cd, a.recoverable_amt,
                         a.recovered_amt, a.tp_item_desc, a.plate_no,
                         a.currency_cd, a.convert_rate, a.lawyer_class_cd,
                         a.lawyer_cd, a.cpi_rec_no, a.cpi_branch_cd,
                         a.user_id, a.last_update, a.cancel_tag, a.iss_cd,
                         a.rec_file_date, a.demand_letter_date,
                         a.demand_letter_date2, a.demand_letter_date3,
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,
                         a.case_no, a.court
                    FROM gicl_clm_recovery a
                   WHERE a.claim_id = p_claim_id
                     AND a.line_cd = p_line_cd
                     AND a.recovery_id = p_recovery_id
                ORDER BY line_cd, rec_year, rec_seq_no)
      LOOP
         v_list.recovery_id := i.recovery_id;
         v_list.recovery_no := get_recovery_no (i.recovery_id);
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;
         v_list.plate_no := i.plate_no;
         v_list.tp_item_desc := i.tp_item_desc;

         BEGIN
            SELECT    payee_first_name
                   || ' '
                   || payee_middle_name
                   || ' '
                   || payee_last_name
              INTO v_list.lawyer
              FROM giis_payees
             WHERE payee_no = i.lawyer_cd
               AND payee_class_cd = i.lawyer_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.lawyer := NULL;
         END;

         BEGIN
            IF i.cancel_tag IS NULL
            THEN
               v_list.status := 'IN PROGRESS';
            ELSIF i.cancel_tag = 'CD'
            THEN
               v_list.status := 'CLOSED';
            ELSIF i.cancel_tag = 'CC'
            THEN
               v_list.status := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO'
            THEN
               v_list.status := 'WRITTEN OFF';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_recovery_details;

   FUNCTION get_payor_details (
      p_claim_id      gicl_recovery_payor.claim_id%TYPE,
      p_recovery_id   gicl_recovery_payor.recovery_id%TYPE
   )
      RETURN payor_details_tab PIPELINED
   IS
      v_list   payor_details_type;
   BEGIN
      FOR i IN (SELECT payor_class_cd, payor_cd, recovered_amt
                  FROM gicl_recovery_payor
                 WHERE claim_id = p_claim_id AND recovery_id = p_recovery_id)
      LOOP
         v_list.recovered_amt := i.recovered_amt;

         BEGIN
            SELECT class_desc
              INTO v_list.class_desc
              FROM giis_payee_class
             WHERE payee_class_cd = i.payor_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.class_desc := NULL;
         END;

         BEGIN
            SELECT    payee_last_name
                   || ' '
                   || payee_first_name
                   || ' '
                   || payee_middle_name payee_name
              INTO v_list.payor
              FROM giis_payees
             WHERE payee_no = i.payor_cd AND payee_class_cd = i.payor_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.payor := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_payor_details;

   FUNCTION get_history (p_recovery_id gicl_rec_hist.recovery_id%TYPE)
      RETURN history_tab PIPELINED
   IS
      v_list   history_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_rec_hist
                 WHERE recovery_id = p_recovery_id)
      LOOP
         v_list.rec_hist_no := i.rec_hist_no;
         v_list.rec_stat_cd := i.rec_stat_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');

         BEGIN
            SELECT rec_stat_desc
              INTO v_list.rec_stat_desc
              FROM giis_recovery_status
             WHERE rec_stat_cd = i.rec_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.rec_stat_desc := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_history;     
END;
/

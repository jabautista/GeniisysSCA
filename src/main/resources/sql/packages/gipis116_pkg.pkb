CREATE OR REPLACE PACKAGE BODY CPI.GIPIS116_PKG
AS
    FUNCTION get_engine_series (p_series_cd VARCHAR2)
       RETURN VARCHAR2
    IS
       engine_series   VARCHAR2 (100);
    BEGIN
       FOR i IN (SELECT engine_series
                   FROM giis_mc_eng_series
                  WHERE series_cd = p_series_cd)
       LOOP
          engine_series := i.engine_series;
          EXIT;
       END LOOP;

       RETURN engine_series;
    END;

    FUNCTION get_type_body (p_type_of_body_cd VARCHAR2)
       RETURN VARCHAR2
    IS
       type_of_body   VARCHAR2 (100);
    BEGIN
       FOR k IN (SELECT type_of_body
                   FROM giis_type_of_body
                  WHERE type_of_body_cd = p_type_of_body_cd)
       LOOP
          type_of_body := k.type_of_body;
          EXIT;
       END LOOP;

       RETURN type_of_body;
    END;
             
    FUNCTION get_basic_color (p_basic_color_cd VARCHAR2)
       RETURN VARCHAR2
    IS
       basic_color   VARCHAR2 (100);
    BEGIN
       FOR n IN (SELECT basic_color
                   FROM giis_mc_color
                  WHERE basic_color_cd = p_basic_color_cd)
       LOOP
          basic_color := n.basic_color;
       END LOOP;

       RETURN basic_color;
    END;
      
   FUNCTION get_motor_car_inquiry_records (
      p_cred_branch   gipi_polbasic.cred_branch%TYPE,
      p_search_by     NUMBER,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2,
      p_policy_id     VARCHAR2, -- Added by Apollo Cruz 7.14.2014
      p_item_no       VARCHAR2  -- will be used when called in GIPIS100
   )
      RETURN motor_car_inquiry_tab PIPELINED
   IS
      v_record   motor_car_inquiry_type;
      v_paid     VARCHAR2 (100);
      v_claim    VARCHAR2 (100);
      v_search_by    NUMBER;
      v_as_of_date   VARCHAR2(100);
   BEGIN
   
   IF p_search_by IS NULL AND p_as_of_date IS NULL AND p_from_date IS NULL and p_to_date IS NULL
     AND p_policy_id IS NULL AND p_item_no IS NULL THEN
      RETURN;
   END IF;
      
      IF p_policy_id IS NOT NULL THEN
         BEGIN
            v_search_by := 1;
            
            SELECT TO_CHAR ((incept_date), 'MM-DD-YYYY')
              INTO v_as_of_date
              FROM gipi_polbasic
             WHERE policy_id = p_policy_id;
         END;
      ELSE
         v_search_by := p_search_by;
         v_as_of_date := p_as_of_date;
      END IF;      
      
      FOR i IN (SELECT   a.plate_no, a.assignee, a.model_year, a.make,
                         a.mot_type, a.repair_lim, a.color, a.coc_seq_no,
                         a.serial_no, a.motor_no, a.policy_id, a.item_no,
                         a.subline_cd, a.subline_type_cd, a.acquired_from,
                         a.series_cd, a.type_of_body_cd, a.basic_color_cd,
                         a.mv_file_no, a.coc_serial_no, a.coc_yy,
                         a.car_company_cd, a.no_of_pass, b.assd_no, b.cred_branch
                    FROM gipi_vehicle a, gipi_polbasic b
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = NVL(p_policy_id, a.policy_id)
                     AND a.item_no = NVL(p_item_no, a.item_no)
                     AND b.cred_branch = NVL (p_cred_branch, b.cred_branch)
                     AND (   (    DECODE (v_search_by,
                                          1, TRUNC (b.incept_date),
                                          2, TRUNC (b.eff_date),
                                          3, TRUNC (b.issue_date)
                                         ) >=
                                           TO_DATE (p_from_date, 'MM-DD-YYYY')
                              AND (DECODE (v_search_by,
                                           1, TRUNC (b.incept_date),
                                           2, TRUNC (b.eff_date),
                                           3, TRUNC (b.issue_date)
                                          ) <=
                                             TO_DATE (p_to_date, 'MM-DD-YYYY')
                                  )
                             )
                          OR (DECODE (v_search_by,
                                      1, TRUNC (b.incept_date),
                                      2, TRUNC (b.eff_date),
                                      3, TRUNC (b.issue_date)
                                     ) <= TO_DATE (v_as_of_date, 'MM-DD-YYYY')
                             )
                         )
                     AND check_user_per_line2 (b.line_cd, b.cred_branch, 'GIPIS116', p_user_id) = 1
                     AND check_user_per_iss_cd2 (b.line_cd, b.cred_branch, 'GIPIS116', p_user_id) = 1
                ORDER BY plate_no, policy_id DESC)
      LOOP
         v_record.plate_no := i.plate_no;
         v_record.assignee := i.assignee;
         v_record.model_year := i.model_year;
         v_record.make := i.make;
         v_record.mot_type := i.mot_type;
         v_record.repair_lim := i.repair_lim;
         v_record.color := i.color;
         v_record.coc_seq_no := i.coc_seq_no;
         v_record.serial_no := i.serial_no;
         v_record.motor_no := i.motor_no;
         v_record.policy_id := i.policy_id;
         v_record.item_no := i.item_no;
         v_record.subline_cd := i.subline_cd;
         v_record.subline_type_cd := i.subline_type_cd;
         v_record.acquired_from := i.acquired_from;
         v_record.series_cd := i.series_cd;
         v_record.type_of_body_cd := i.type_of_body_cd;
         v_record.basic_color_cd := i.basic_color_cd;
         v_record.mv_file_no := i.mv_file_no;
         v_record.coc_serial_no := i.coc_serial_no;
         v_record.coc_yy := i.coc_yy;
         v_record.car_company_cd := i.car_company_cd;
         v_record.no_of_pass := i.no_of_pass;
         v_record.cred_branch := i.cred_branch;
         v_record.dsp_engine_series := get_engine_series(i.series_cd);
         v_record.dsp_type_of_body := get_type_body(i.type_of_body_cd);
         v_record.dsp_basic_color := get_basic_color(i.basic_color_cd);
        
--         FOR j IN (SELECT engine_series
--                     FROM giis_mc_eng_series
--                    WHERE series_cd = i.series_cd)
--         LOOP
--            v_record.dsp_engine_series := j.engine_series;
--            exit;
--         END LOOP;
--         

--         FOR k IN (SELECT type_of_body
--                     FROM giis_type_of_body
--                    WHERE type_of_body_cd = i.type_of_body_cd)
--         LOOP
--            v_record.dsp_type_of_body := k.type_of_body;
--            EXIT;
--         END LOOP;

         FOR l IN (SELECT subline_type_desc
                     FROM giis_mc_subline_type
                    WHERE subline_type_cd = i.subline_type_cd)
         LOOP
            v_record.dsp_subline_type := l.subline_type_desc;
            EXIT;
         END LOOP;

         FOR m IN (SELECT motor_type_desc
                     FROM giis_motortype
                    WHERE type_cd = i.mot_type AND subline_cd = i.subline_cd)
         LOOP
            v_record.dsp_mot_type_desc := m.motor_type_desc;
            EXIT;
         END LOOP;

--         FOR n IN (SELECT basic_color
--                     FROM giis_mc_color
--                    WHERE basic_color_cd = i.basic_color_cd)
--         LOOP
--            v_record.dsp_basic_color := n.basic_color;
--         END LOOP;

         FOR o IN (SELECT car_company
                     FROM giis_mc_car_company
                    WHERE car_company_cd = i.car_company_cd)
         LOOP
            v_record.dsp_car_company := o.car_company;
            EXIT;
         END LOOP;

         FOR p IN (SELECT incept_date, eff_date, issue_date
                     FROM gipi_polbasic
                    WHERE policy_id = i.policy_id)
         LOOP
            v_record.nbt_incept_date := p.incept_date;
            v_record.nbt_eff_date := p.eff_date;
            v_record.nbt_issue_date := p.issue_date;
            EXIT;
         END LOOP;

         FOR q IN (SELECT endt_iss_cd, endt_yy, endt_seq_no
                     FROM gipi_polbasic
                    WHERE policy_id = i.policy_id)
         LOOP
            IF q.endt_seq_no <> 0
            THEN
               v_record.endt_no :=
                     q.endt_iss_cd
                  || '-'
                  || TO_CHAR (q.endt_yy, '09')
                  || '-'
                  || TO_CHAR (q.endt_seq_no, '000009');
            ELSE
               v_record.endt_no := '';         
            END IF;

            EXIT;
         END LOOP;

         FOR r IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = i.assd_no)
         LOOP
            v_record.assured := r.assd_name;
            EXIT;
         END LOOP;

         IF v_record.assured IS NULL
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#This policy has no assured, please contact your database administrator.'
               );
         END IF;

         FOR s IN (SELECT SUM (b.balance_amt_due) balance_amt_due
                     FROM gipi_invoice a, giac_aging_soa_details b
                    WHERE a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND a.policy_id = i.policy_id)
         LOOP
            v_paid := s.balance_amt_due;
            EXIT;
         END LOOP;

         IF v_paid = 0
         THEN
            v_record.paid_tag := 'Y';
         ELSE
            v_record.paid_tag := 'N';
         END IF;

         FOR t IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no
                     FROM gipi_polbasic
                    WHERE policy_id = i.policy_id)
         LOOP
            v_record.claim_tag := 'N';
            FOR u IN (SELECT clm_setl_date
                        FROM gicl_claims
                       WHERE line_cd = t.line_cd
                         AND subline_cd = t.subline_cd
                         AND iss_cd = t.iss_cd
                         AND issue_yy = t.issue_yy
                         AND pol_seq_no = t.pol_seq_no)
            LOOP
               v_claim := u.clm_setl_date;
               v_record.claim_tag := 'Y';
               EXIT;
            END LOOP;

            EXIT;
         END LOOP;

--         IF v_claim IS NULL
--         THEN
--            v_record.claim_tag := 'N';
--         END IF;

         BEGIN
            SELECT item_title, from_date,
                   TO_DATE, ann_prem_amt,
                   ann_tsi_amt
              INTO v_record.item_title, v_record.from_date,
                   v_record.TO_DATE, v_record.ann_prem_amt,
                   v_record.ann_tsi_amt
              FROM gipi_item
             WHERE policy_id = i.policy_id AND item_no = i.item_no;
         END;

         v_record.policy_no := get_policy_no (i.policy_id);
        PIPE ROW (v_record);
      END LOOP;
      
         
          
      RETURN;
   END get_motor_car_inquiry_records;
END GIPIS116_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.claim_reports_docs_pkg
AS
   FUNCTION get_claim_doc_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_attention        VARCHAR2,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_call_out         VARCHAR2,
      p_beginning_text   VARCHAR2,
      p_ending_text      VARCHAR2
   )
      RETURN acknow_call_letter_tab PIPELINED
   IS
      v_det        acknow_call_letter_type;
      ctr          NUMBER                  := 0;
      v_body       VARCHAR2 (32767);
      v_doc_desc   VARCHAR2 (32767);
   BEGIN
      v_det.intm := CHR(10)||LTRIM(p_attention); -- added by: Nica 11.29.2012 to equate intm to p_atttention value --added by steven 02.08.2013; 'CHR(10)'
      
      FOR i IN (SELECT DISTINCT UPPER (intm_name) intm_name,
                                DECODE (mail_addr3,
                                        NULL, DECODE (mail_addr2,
                                                      NULL, mail_addr1,
                                                         mail_addr1
                                                      || CHR (10)
                                                      || mail_addr2
                                                     ),
                                           mail_addr1
                                        || CHR (10)
                                        || mail_addr2
                                        || CHR (10)
                                        || mail_addr3
                                       ) addr
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE claim_id = p_claim_id
                            AND a.intm_no = b.intm_no)
      LOOP
         IF p_attention IS NOT NULL AND TRIM(p_attention) <> ' ' --added by steven 03.27.2014
         THEN             --with contact person, sent to is intm and address.
            v_det.intm := CHR(10)||LTRIM(p_attention); -- added by: Nica 11.29.2012  --added by steven 02.08.2013; 'CHR(10)'
			v_det.send_to := LTRIM(i.intm_name) || CHR (10) || LTRIM(i.addr);
         ELSE  -- if without contact person, intm is intm, sent to is address.
            v_det.intm := CHR(10)||'c/o ' || LTRIM(i.intm_name);
            v_det.send_to := LTRIM(i.addr);
         END IF;
      END LOOP;

      FOR i IN (SELECT DECODE (last_name,
                               NULL, assd_name,
                                  first_name
                               || ' '
                               || middle_initial
                               || '. '
                               || last_name
                              ) assd_name,
                       DECODE (last_name,
                               NULL, 'Sir',
                               DECODE (designation,
                                       NULL, 'Sir',
                                       designation || ' ' || last_name
                                      )
                              ) des
                  FROM giis_assured a
                 WHERE EXISTS (
                           SELECT 1
                             FROM gicl_claims
                            WHERE assd_no = a.assd_no
                                  AND claim_id = p_claim_id))
      LOOP
         v_det.assured_name := UPPER (LTRIM(i.assd_name));
         v_det.des := INITCAP (NVL (i.des, '_______'));
      END LOOP;

      FOR a IN (SELECT label, signatory, designation
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND a.report_no IN (
                          SELECT report_no
                            FROM giac_documents b
                           WHERE report_id = 'GICLR011'
                             AND b.line_cd = p_line_cd
                             AND b.branch_cd = p_iss_cd))
      LOOP
         v_det.closing := a.label;
         v_det.signatory := INITCAP(a.signatory);
         v_det.designation := a.designation;
      END LOOP;

      --if no signatory for line, then get signatory for all lines and branches.
      IF     v_det.closing IS NULL
         AND v_det.signatory IS NULL
         AND v_det.designation IS NULL
      THEN
         FOR a IN (SELECT label, signatory, designation
                     FROM giac_rep_signatory a, giis_signatory_names b
                    WHERE a.signatory_id = b.signatory_id
                      AND a.report_no IN (
                             SELECT report_no
                               FROM giac_documents b
                              WHERE report_id = 'GICLR011'
                                AND b.line_cd IS NULL
                                AND b.branch_cd IS NULL))
         LOOP
            v_det.closing := a.label;
            v_det.signatory := INITCAP(a.signatory);
            v_det.designation := a.designation;
         END LOOP;
      END IF;

      --for item title and plate number
      IF p_line_cd = 'MC' OR p_line_cd = giisp.v ('LINE_CD_MC')
      THEN
         FOR i IN (SELECT plate_no
                     FROM gicl_motor_car_dtl
                    WHERE claim_id = p_claim_id)
         LOOP
            v_det.plate_no := i.plate_no;
         END LOOP;

         BEGIN
            SELECT DECODE (model_year,
                           NULL, car_company,
                           model_year || ' ' || car_company
                          )
              INTO v_det.item_title
              FROM gicl_motor_car_dtl a, giis_mc_car_company b
             WHERE claim_id = p_claim_id
               AND a.motcar_comp_cd = b.car_company_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_det.item_title := NULL;
         END;

         BEGIN
            SELECT make
              INTO v_det.make
              FROM giis_mc_make a, gicl_motor_car_dtl b
             WHERE a.make_cd = b.make_cd AND claim_id = p_claim_id
             and a.car_company_cd = b.motcar_comp_cd ;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_det.make := NULL;
         END;

         IF v_det.make IS NOT NULL
         THEN
            IF v_det.item_title IS NOT NULL
            THEN
               v_det.item_title := v_det.item_title || ' ' || v_det.make;
            ELSE
               v_det.item_title := v_det.make;
            END IF;
         END IF;

         IF v_det.item_title IS NOT NULL
         THEN
            IF v_det.plate_no IS NOT NULL
            THEN
               v_det.item_title :=
                          v_det.item_title || ' / ' || UPPER (v_det.plate_no);
            END IF;

            v_det.lbl := 'Insured Vehicle/Plate No.';
            v_det.c   := ':';
            v_det.val := v_det.item_title;
         END IF;
      END IF;

      --for policy no, item/plate, loss date, mortgagee
      FOR i IN (SELECT mortg_name
                  FROM gicl_mortgagee a, giis_mortgagee b
                 WHERE claim_id = p_claim_id
                 AND a.iss_cd = b.iss_cd -- additional condition added by: Nica 11.29.2012 
                 AND a.mortg_cd = b.mortg_cd)
      LOOP
         IF ctr = 0
         THEN
            IF v_det.lbl IS NOT NULL
            THEN
               v_det.lbl := v_det.lbl || CHR (10) || 'Mortgagee';
               v_det.c := v_det.c || CHR (10) || ':';
            ELSE
               v_det.lbl := 'Mortgagee';
			   v_det.c   := ':';
            END IF;
         END IF;

         IF v_det.val IS NOT NULL
         THEN
            v_det.val := v_det.val || CHR (10) || i.mortg_name;
         ELSE
            v_det.val := i.mortg_name;
         END IF;

         ctr := ctr + 1;
      END LOOP;

      --body
      FOR i IN (SELECT clm_doc_desc
                  FROM gicl_clm_docs a, gicl_reqd_docs b
                 WHERE doc_cmpltd_dt IS NULL
                   AND claim_id = p_claim_id
                   AND a.line_cd = b.line_cd
                   AND a.subline_cd = b.subline_cd
                   AND a.clm_doc_cd = b.clm_doc_cd)
      LOOP
         v_doc_desc :=
                 v_doc_desc || '___ ' || i.clm_doc_desc || CHR (10)
                 || CHR (9);
      END LOOP;

      IF p_call_out = 'Y'
      THEN
         IF     (p_beginning_text IS NOT NULL OR p_beginning_text <> ' ')
            AND (p_ending_text IS NOT NULL OR p_ending_text <> ' ')
         THEN
            v_body :=
                  p_beginning_text
               || CHR (10)
               || CHR (10)
               || CHR (9)
               || NVL (v_doc_desc, ' ')
               || CHR (10)
               || CHR (10)
               || p_ending_text;
         ELSIF (p_beginning_text IS NOT NULL OR p_beginning_text <> ' ')
         THEN
            v_body :=
                  p_beginning_text
               || CHR (10)
               || CHR (10)
               || CHR (9)
               || NVL (v_doc_desc, ' ');
         ELSIF (p_ending_text IS NOT NULL OR p_ending_text <> ' ')
         THEN
            v_body :=
                  p_ending_text --p_beginning_text replaced by: Nica 11.29.2012
               || CHR (10)
               || CHR (10)
               || CHR (9)
               || NVL (v_doc_desc, ' ');
         END IF;
      ELSE
         IF     (p_beginning_text IS NOT NULL OR p_beginning_text <> ' ')
            AND (p_ending_text IS NOT NULL OR p_ending_text <> ' ')
         THEN
            v_body := p_beginning_text || CHR (10) || CHR (10)
                      || p_ending_text;
         ELSIF (p_beginning_text IS NOT NULL OR p_beginning_text <> ' ')
         THEN
            v_body := p_beginning_text;
         ELSIF (p_ending_text IS NOT NULL OR p_ending_text <> ' ')
         THEN
            v_body := p_ending_text;
         END IF;
      END IF;

      v_det.body_text := v_body;
	  
	  FOR i IN (SELECT TO_CHAR(loss_date, 'fmMonth dd, YYYY') loss_date
	  			 FROM GICL_CLAIMS
				 WHERE claim_id = p_claim_id)
	  LOOP
	  	v_det.loss_date := i.loss_date;
  	  END LOOP;
	  
      PIPE ROW (v_det);
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giis_tax_issue_place_pkg
AS
   /********************************** FUNCTION 1 ************************************
     MODULE: GIPIS026
     RECORD GROUP NAME: TAX_ISSUE_PLACE
   ***********************************************************************************/
   FUNCTION get_tax_issue_place_list (
      p_line_cd    giis_tax_charges.line_cd%TYPE,
      p_iss_cd     giis_tax_charges.iss_cd%TYPE,
      p_par_id     gipi_wpolbas.par_id%TYPE,
      p_item_grp   gipi_witem.item_grp%TYPE,
      p_takeup_seq_no gipi_winv_tax.takeup_seq_no%TYPE /* added by jhing 11.09.2014 */
   )
      RETURN tax_list_tab PIPELINED
   IS
      v_tax           tax_list_type;
      v_place_cd      VARCHAR2 (4);
      v_line_cd       gipi_wpolbas.line_cd%TYPE;
      v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
      v_tax_type      giis_tax_charges.tax_type%TYPE;
      v_tax_amount    giis_tax_charges.tax_amount%TYPE;
      --added by steven 07.22.2014
      v_exist         VARCHAR2 (1);
      v_issue_date    gipi_wpolbas.issue_date%TYPE;
      v_eff_date      gipi_wpolbas.eff_date%TYPE;
      v_incept_date   gipi_wpolbas.incept_date%TYPE;
      v_vat_tag       giis_assured.vat_tag%TYPE;
      v_evat_cd       NUMBER                             := giacp.n ('EVAT');
      v_docstamps_cd  giac_parameters.param_value_n%TYPE := giacp.n('DOC_STAMPS'); 
      v_allow_neg_dst giis_parameters.param_value_v%TYPE := NVL (giisp.v ('ALLOW_NEGATIVE_DST'), 'Y')  ; 
      v_sum_premium   gipi_winvoice.prem_amt%TYPE ;
   BEGIN
      --belle 08.16.2012
      FOR i IN (SELECT eff_date, incept_date, issue_date,
                       NVL (vat_tag, 3) vat_tag
                  FROM gipi_wpolbas a, giis_assured b
                 WHERE a.assd_no = b.assd_no AND par_id = p_par_id)
      LOOP
         v_issue_date := i.issue_date;
         v_eff_date := i.eff_date;
         v_incept_date := i.incept_date;
         v_vat_tag := i.vat_tag;
      END LOOP;

      --end belle
      FOR m IN (SELECT place_cd, line_cd, iss_cd
                  FROM gipi_wpolbas b540
                 WHERE b540.par_id = p_par_id)
      LOOP
         v_place_cd := m.place_cd;
         v_line_cd := m.line_cd;
         v_iss_cd := m.iss_cd;
      END LOOP;
      

      -- jhing 11.10.2014 queried total prem amount per item group.( Do not include takeup_seq_no in the condition)      
      v_sum_premium := 0 ; 
      FOR itmgrp IN (SELECT SUM(nvl(a.prem_amt,0)) prem_amt
            FROM gipi_witmperl a, gipi_witem b 
                WHERE a.par_id = p_par_id
                    AND a.par_id = b.par_id
                    AND a.item_no = b.item_no
                    AND b.item_grp = p_item_grp )
      LOOP
        v_sum_premium := itmgrp.prem_amt;
      END LOOP;
      
      
      FOR i IN (
/*SELECT DISTINCT a.tax_cd, a.line_cd, a.iss_cd, NVL(b.rate, a.rate) rate, a.tax_id,
       a.tax_desc, a.peril_sw, a.allocation_tag, a.primary_sw, a.no_rate_tag
  FROM GIIS_TAX_ISSUE_PLACE b, GIIS_TAX_CHARGES a
 WHERE a.line_cd     = v_line_cd--p_line_cd
   AND a.iss_cd   = v_iss_cd--p_iss_cd
     AND b.line_cd  (+)= a.line_cd
   AND b.iss_cd   (+)= a.iss_cd
     AND b.tax_cd   (+)= a.tax_cd
     AND b.place_cd (+)= v_place_cd
     AND a.pol_endt_sw IN ('B','P')
  --AND a.primary_sw = 'N'
  AND a.expired_sw = 'N'
     AND ((a.eff_start_date <= (SELECT NVL(eff_date, incept_date)
                                  FROM GIPI_WPOLBAS
                                WHERE par_id = p_par_id)
                   AND NVL(a.issue_date_tag,'N') = 'N')
                OR (a.eff_start_date <= (SELECT issue_date
                                                                FROM GIPI_WPOLBAS
                                                            WHERE par_id = p_par_id)
                         AND NVL(a.issue_date_tag,'N') = 'Y'))*/
                SELECT DISTINCT a230.tax_cd, a230.line_cd, a230.iss_cd,
                                NVL (a.rate, a230.rate) rate, a230.tax_id,
                                a230.tax_desc, a230.peril_sw,
                                a230.allocation_tag, a230.primary_sw,
                                a230.no_rate_tag, a230.takeup_alloc_tag
                           FROM giis_tax_issue_place a, giis_tax_charges a230
                          WHERE a230.line_cd = v_line_cd
                            AND a230.iss_cd = v_iss_cd
                            AND a.line_cd(+) = a230.line_cd
                            AND a.iss_cd(+) = a230.iss_cd
                            AND a.tax_cd(+) = a230.tax_cd
                            AND a.place_cd(+) = v_place_cd
                            AND a230.pol_endt_sw IN ('B', 'P')
                            /*AND (   (    a230.eff_start_date <=
                                            (SELECT NVL (eff_date, incept_date)
                                               FROM gipi_wpolbas
                                              WHERE par_id = p_par_id)
                                     AND a230.eff_end_date > =  (SELECT NVL (eff_date, incept_date)
                                               FROM gipi_wpolbas
                                              WHERE par_id = p_par_id)
                                     AND NVL (a230.issue_date_tag, 'N') = 'N'
                                     )

                                 OR (    a230.eff_start_date <=
                                            (SELECT issue_date
                                               FROM gipi_wpolbas
                                              WHERE par_id = p_par_id)
                                     AND NVL (a230.issue_date_tag, 'N') = 'Y')) */--belle 08.16.2012 replaced by codes below
                            AND (   (    a230.eff_start_date <=
                                               NVL (v_eff_date, v_incept_date)
                                     AND a230.eff_end_date >=
                                               NVL (v_eff_date, v_incept_date)
                                     AND NVL (a230.issue_date_tag, 'N') = 'N'
                                    )
                                 OR (    a230.eff_start_date <= v_issue_date
                                     AND a230.eff_end_date >= v_issue_date
                                     AND NVL (a230.issue_date_tag, 'N') = 'Y'
                                    )
                                )
                            AND NVL(a230.expired_sw,'N') = 'N'  -- jhing 11.09.2014 added NVL
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM gipi_winv_tax z
                                    WHERE z.tax_cd = a230.tax_cd
                                      AND z.par_id = p_par_id
                                      AND z.item_grp = p_item_grp
                                      AND z.takeup_seq_no = p_takeup_seq_no) --added by steven 08.01.2014  -- jhing 11.09.2014 added takeup_seq_no
                       --end belle 08.16.2012
                ORDER BY        tax_cd)
      LOOP
         -- belle 08.16.2012 disallow adding of VAT record if asured was tagged as VAT Exempt
         IF v_vat_tag = 1
         THEN
            IF v_evat_cd <> i.tax_cd
            THEN
               v_tax.tax_cd := i.tax_cd;
               v_tax.line_cd := i.line_cd;
               v_tax.iss_cd := i.iss_cd;
               v_tax.tax_desc := i.tax_desc;
               v_tax.rate := i.rate;
               v_tax.peril_sw := i.peril_sw;
               v_tax.tax_id := i.tax_id;
               v_tax.allocation_tag := i.allocation_tag;
               v_tax.primary_sw := i.primary_sw;
               v_tax.no_rate_tag := i.no_rate_tag;
               v_tax_type := '';
               v_tax.takeup_alloc_tag := i.takeup_alloc_tag; -- jhing 11.09.2014 

               FOR c IN (SELECT peril_sw, tax_type, tax_amount
                           FROM giis_tax_charges
                          WHERE iss_cd = i.iss_cd
                            AND line_cd = i.line_cd
                            AND tax_cd = i.tax_cd
                            AND tax_id = i.tax_id /* -- jhing 11.08.2014 added tax_id*/)
               LOOP
                  v_tax_type := c.tax_type;
                  v_tax_amount := c.tax_amount;
               END LOOP;

               IF v_tax_type = 'A'
               THEN
                  v_tax.rate := 0;
                  v_tax.temp_tax_amt := v_tax_amount;
               END IF;

               v_tax.tax_type := v_tax_type;

               --added by steven 07.22.2014 base on RSICSIT test case
               IF v_tax_type = 'R' AND v_tax.primary_sw = 'N' AND v_tax.peril_sw = 'Y'
               THEN
                  v_exist := 'N';

                  FOR item IN (SELECT b.peril_cd
                                 FROM gipi_witem a, gipi_witmperl b
                                WHERE a.par_id = p_par_id
                                  AND a.item_grp = p_item_grp
                                  AND a.item_no = b.item_no
                                  AND a.par_id = b.par_id)
                  LOOP
                     FOR peril IN (SELECT '1'
                                     FROM giis_tax_peril
                                    WHERE iss_cd = p_iss_cd
                                      AND line_cd = p_line_cd
                                      AND tax_cd = v_tax.tax_cd
                                      AND tax_id = v_tax.tax_id  /* jhing 11.08.2014 */
                                      AND peril_cd = item.peril_cd)
                     LOOP
                        v_exist := 'Y';
                        EXIT;
                     END LOOP;
                  END LOOP;
               ELSE
                  v_exist := 'Y';
               END IF;

               -- jhing 11.18.2014 added code to restrict display of DST for negative premium 
               IF i.tax_cd = v_docstamps_cd AND v_sum_premium < 0 AND v_allow_neg_dst = 'N' THEN
                    v_exist := 'N'; 
               END IF; 


               IF v_exist = 'Y'
               THEN
                  PIPE ROW (v_tax);
               END IF;
            END IF;
         ELSE                                                      --end belle
            v_tax.tax_cd := i.tax_cd;
            v_tax.line_cd := i.line_cd;
            v_tax.iss_cd := i.iss_cd;
            v_tax.tax_desc := i.tax_desc;
            v_tax.rate := i.rate;
            v_tax.peril_sw := i.peril_sw;
            v_tax.tax_id := i.tax_id;
            v_tax.allocation_tag := i.allocation_tag;
            v_tax.primary_sw := i.primary_sw;   --for checking required taxes
            v_tax.no_rate_tag := i.no_rate_tag;
            v_tax_type := '';
            v_tax.takeup_alloc_tag := i.takeup_alloc_tag; -- jhing 11.09.2014 

            FOR c IN (SELECT peril_sw, tax_type, tax_amount
                        FROM giis_tax_charges
                       WHERE iss_cd = i.iss_cd
                         AND line_cd = i.line_cd
                         AND tax_cd = i.tax_cd
                         AND tax_id = i.tax_id /* jhing 11.08.2014 */ )
            LOOP
               --  v_peril_sw   := c.peril_sw;
               v_tax_type := c.tax_type;
               v_tax_amount := c.tax_amount;
            END LOOP;

            IF v_tax_type = 'A'
            THEN
               v_tax.rate := 0;
               v_tax.temp_tax_amt := v_tax_amount;
            END IF;

            v_tax.tax_type := v_tax_type;
            --added by steven 07.22.2014 base on RSICSIT test case
            IF v_tax_type = 'R' AND v_tax.primary_sw = 'N' AND v_tax.peril_sw = 'Y'
            THEN
               v_exist := 'N';
               FOR item IN (SELECT b.peril_cd
                              FROM gipi_witem a, gipi_witmperl b
                             WHERE a.par_id = p_par_id
                               AND a.item_grp = p_item_grp
                               AND a.item_no = b.item_no
                               AND a.par_id = b.par_id)
               LOOP
                  FOR peril IN (SELECT '1'
                                  FROM giis_tax_peril
                                 WHERE iss_cd = p_iss_cd
                                   AND line_cd = p_line_cd
                                   AND tax_cd = v_tax.tax_cd
                                   AND tax_id = v_tax.tax_id /* jhing 11.08.2014 */ 
                                   AND peril_cd = item.peril_cd)
                  LOOP
                     v_exist := 'Y';
                     EXIT;
                  END LOOP;
               END LOOP;
            ELSE
               v_exist := 'Y';
            END IF;
            
            
            -- jhing 11.10.2014 added code to restrict display of DST for negative premium 
            IF i.tax_cd = v_docstamps_cd AND v_sum_premium < 0 AND v_allow_neg_dst = 'N' THEN
                v_exist := 'N'; 
            END IF; 

            IF v_exist = 'Y'
            THEN
               PIPE ROW (v_tax);
            END IF;
         END IF;
      END LOOP;

      RETURN;
   END get_tax_issue_place_list;
END giis_tax_issue_place_pkg;
/



DROP PROCEDURE CPI.GIACS090_BREAKDOWN;

CREATE OR REPLACE PROCEDURE CPI.GIACS090_BREAKDOWN(
  p_transaction_type GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
  p_iss_cd          GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
  p_prem_seq_no     GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
  p_inst_no         GIAC_PDC_PREM_COLLN.inst_no%TYPE,
  p_collection_amt  IN OUT GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
  p_premium_amt     OUT GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
  p_tax_amt         OUT GIAC_PDC_PREM_COLLN.tax_amt%TYPE)
IS
   v_count            NUMBER;
   v_param_value_n    NUMBER;
   v_prem             NUMBER;
   v_tax              NUMBER;
   v_total_bill       NUMBER;
   v_othertax_colln   NUMBER;
   v_vat_colln        NUMBER;
   v_prem_colln       NUMBER;
   v_other_tax        NUMBER;
   v_vat              NUMBER;
   v_otax_bal         NUMBER;
   v_vat_bal          NUMBER;
   v_check_amt        NUMBER;
   v_pdc_tax_colln    NUMBER;
   v_pdc_colln_amt    NUMBER;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM gipi_installment
    WHERE iss_cd = p_iss_cd 
      AND prem_seq_no = p_prem_seq_no;

   SELECT param_value_n
     INTO v_param_value_n
     FROM giac_parameters
    WHERE param_name = 'EVAT';

   FOR a IN (SELECT prem_amt, tax_amt
               FROM gipi_invoice
              WHERE iss_cd = p_iss_cd 
                AND prem_seq_no = p_prem_seq_no)
   LOOP
      v_prem := a.prem_amt;
      v_tax := a.tax_amt;
      v_total_bill := v_prem + v_tax;
   END LOOP;                                                                                                                   
   --a

   FOR b IN (SELECT NVL (SUM (tax_amt), 0) tax_amt
               FROM giac_tax_collns
              WHERE b160_iss_cd = p_iss_cd
                AND b160_prem_seq_no = p_prem_seq_no
                AND transaction_type = p_transaction_type
                AND b160_tax_cd <> v_param_value_n)
   LOOP
      v_othertax_colln := b.tax_amt;
   END LOOP;                                                                                                                   
   --b

   FOR c IN (SELECT SUM (tax_amt) vat_amt
               FROM giac_tax_collns
              WHERE b160_iss_cd = p_iss_cd
                AND b160_prem_seq_no = p_prem_seq_no
                AND transaction_type = p_transaction_type
                AND b160_tax_cd = v_param_value_n)
   LOOP
      v_vat_colln := c.vat_amt;
   END LOOP;                                                                                                                   
   --c

   FOR d IN (SELECT SUM (premium_amt) premium_amt
               FROM giac_direct_prem_collns
              WHERE b140_iss_cd = p_iss_cd 
                AND b140_prem_seq_no = p_prem_seq_no 
                AND transaction_type = p_transaction_type)
   LOOP
      v_prem_colln := d.premium_amt;
   END LOOP;                                                                                                                   
   --d

   FOR e IN (SELECT NVL (SUM (tax_amt), 0) tax_amt
               FROM gipi_inv_tax
              WHERE iss_cd = p_iss_cd 
                AND prem_seq_no = p_prem_seq_no 
                AND tax_cd <> v_param_value_n)
   LOOP
      v_other_tax := e.tax_amt;
   END LOOP;                                                                                                                   
   --e

   FOR f IN (SELECT NVL (SUM (premium_amt), 0) premium_amt, NVL (SUM (tax_amt), 0) tax_amt,
                    NVL (SUM (collection_amt), 0) collection_amt
               FROM giac_pdc_prem_colln
              WHERE iss_cd = p_iss_cd 
                AND prem_seq_no = p_prem_seq_no)
   LOOP
      v_pdc_tax_colln := f.tax_amt;
      v_pdc_colln_amt := f.collection_amt;
   END LOOP;                                                                                                                   
   --f
   
   --marco - 11.05.2014 - added to select values when giac_pdc_prem_colln record is not yet saved
   IF v_pdc_tax_colln = 0 AND v_pdc_colln_amt = 0 THEN
      FOR f IN(SELECT prem_balance_due premium_amt, tax_balance_due tax_amt
                 FROM giac_aging_soa_details
                WHERE iss_cd = p_iss_cd
                  AND prem_seq_no = p_prem_seq_no
                  AND inst_no = p_inst_no
                  AND balance_amt_due > 0)
      LOOP
         v_pdc_tax_colln := f.tax_amt;
         v_pdc_colln_amt := f.premium_amt;
      END LOOP;
   END IF;
   
   FOR g IN (SELECT SUM (tax_amt) tax_amt
               FROM gipi_inv_tax
              WHERE iss_cd = p_iss_cd 
                AND prem_seq_no = p_prem_seq_no 
                AND tax_cd = v_param_value_n)
   LOOP
      v_vat := g.tax_amt;
      v_otax_bal := v_other_tax - v_othertax_colln;
      v_vat_bal := v_vat - v_vat_colln;
   END LOOP;                                                                                                                   
   --g

   FOR h IN (SELECT NVL (SUM (a.check_amt), 0) check_amt
               FROM giac_apdc_payt_dtl a
                  , giac_pdc_prem_colln b
              WHERE a.pdc_id = b.pdc_id 
                AND a.check_flag = 'A' 
                AND b.iss_cd = p_iss_cd 
                AND b.prem_seq_no = p_prem_seq_no)
   LOOP
      v_check_amt := h.check_amt;
   END LOOP;                                                                                                                   
   --h

   IF v_count = 1
   THEN
      IF v_total_bill = p_collection_amt
      THEN                                                                                        
      --no payment in DIRECT OR and PDC
         p_premium_amt := v_prem;
         p_tax_amt := v_tax;
      --with payment in OR but no payment in PDC
      ELSIF v_total_bill <> p_collection_amt AND v_othertax_colln <> 0 AND v_pdc_colln_amt = 0
      THEN
         IF v_othertax_colln = v_other_tax
         THEN                                                                                
         --taxes other than vat is fully paid
            p_premium_amt := ROUND ((p_collection_amt / 1.12), 2);
            p_tax_amt := ROUND ((p_collection_amt / 1.12) * .12, 2);
         ELSIF v_othertax_colln < v_other_tax
         THEN
            IF v_otax_bal <= p_collection_amt
            THEN
               p_premium_amt := ROUND (((p_collection_amt - v_otax_bal) / 1.12), 2);
               p_tax_amt := ROUND ((((p_collection_amt - v_otax_bal) / 1.12) * .12), 2) + v_otax_bal;
            ELSE
               p_tax_amt := p_collection_amt;
               p_premium_amt := 0;
            END IF;
         END IF;
      --with payment in OR and PDC
      ELSIF v_total_bill <> p_collection_amt AND v_pdc_colln_amt <> 0 AND v_othertax_colln <> 0
      THEN
         IF     v_othertax_colln + v_pdc_tax_colln < v_other_tax
            AND p_collection_amt = v_other_tax - (v_othertax_colln + v_pdc_tax_colln)
         THEN                                                                             
         --taxes other than vat is not fully paid
            p_premium_amt := 0;
            p_tax_amt := ROUND ((((p_collection_amt - (v_other_tax - (v_othertax_colln + v_pdc_tax_colln))) / 1.12) * .12), 2)
                                    + (v_other_tax - (v_othertax_colln + v_pdc_tax_colln));
         ELSIF     v_othertax_colln + v_pdc_tax_colln < v_other_tax
               AND p_collection_amt > v_other_tax - (v_othertax_colln + v_pdc_tax_colln)
         THEN
            p_premium_amt := ROUND (((p_collection_amt - (v_other_tax - (v_othertax_colln + v_pdc_tax_colln))) / 1.12), 2);
            p_tax_amt := ROUND ((((p_collection_amt - (v_other_tax - (v_othertax_colln + v_pdc_tax_colln))) / 1.12) * .12), 2)
                                    + (v_other_tax - (v_othertax_colln + v_pdc_tax_colln));
         ELSIF     v_othertax_colln + v_pdc_tax_colln >= v_other_tax
               AND p_collection_amt > v_other_tax - (v_othertax_colln + v_pdc_tax_colln)
         THEN                                                                                 
         --taxes other than vat is fully paid
            p_premium_amt := ROUND ((p_collection_amt / 1.12), 2);
            p_tax_amt := ROUND (((p_collection_amt / 1.12) * .12), 2);
         END IF;
      --no payment in OR and PDC, payment is not equal to total bill
      ELSIF v_total_bill <> p_collection_amt AND v_othertax_colln = 0 AND v_pdc_tax_colln = 0
      THEN
         IF v_other_tax >= p_collection_amt
         THEN                                                               
         --collection amount is less than taxes other than vat
            p_tax_amt := p_collection_amt;
            p_premium_amt := 0;
         ELSE                                                             
         --collection amount is greater than taxes other than vat
            p_premium_amt := ROUND (((p_collection_amt - v_otax_bal) / 1.12), 2);
            p_tax_amt := ROUND ((((p_collection_amt - v_otax_bal) / 1.12) * .12), 2) + v_otax_bal;
         END IF;
      --no payment in OR but w/ payment in PDC
      ELSIF v_total_bill <> p_collection_amt AND v_othertax_colln = 0 AND v_pdc_tax_colln <> 0
      THEN
         IF v_other_tax > v_pdc_tax_colln
         THEN
            p_premium_amt := ROUND (((p_collection_amt - (v_other_tax - v_pdc_tax_colln)) / 1.12), 2);
            p_tax_amt := ROUND ((((p_collection_amt - (v_other_tax - v_pdc_tax_colln)) / 1.12) * .12), 2) + (v_other_tax - v_pdc_tax_colln);
         ELSIF v_other_tax <= v_pdc_tax_colln
         THEN
            p_premium_amt := ROUND ((p_collection_amt / 1.12), 2);
            p_tax_amt := ROUND (((p_collection_amt / 1.12) * .12), 2);
         END IF;
      END IF;                                                                                                       
      --v_total_bill
   ELSE                                                        
   --v_count
      FOR i IN (SELECT prem_amt, tax_amt
                  FROM gipi_installment
                 WHERE iss_cd = p_iss_cd 
                   AND prem_seq_no = p_prem_seq_no 
                   AND inst_no = p_inst_no)
      LOOP
         p_premium_amt := i.prem_amt;
         p_tax_amt := i.tax_amt;
      END LOOP;
      -- i
   END IF;                                                                                                               
   
   --marco - 11.05.2014
   p_premium_amt := NVL(p_premium_amt, 0);
   p_tax_amt := NVL(p_tax_amt, 0);
   
   --v_count
END GIACS090_BREAKDOWN;
/



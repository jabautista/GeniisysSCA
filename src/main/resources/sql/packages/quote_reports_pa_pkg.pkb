CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_PA_PKG AS

/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/19/2011   Windell Valle    Created this package.
   1.1        6/3/2011    Bhev Quetua      Added statement to convert amts
******************************************************************************/

----* GET QUOTE DETAILS
  FUNCTION get_quote_details_pa_ucpb(p_quote_id NUMBER)
  RETURN quote_pa_details_tab PIPELINED IS

  v_ucpb quote_pa_details_type;

  BEGIN
    FOR A IN (SELECT
              DISTINCT
                       quote_id,
                       A.line_cd,
                       A.subline_cd, E.subline_name,
                       A.iss_cd,
                       user_name, line_name,
                       A.line_cd||'-'||A.subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||LTRIM(to_char(quotation_no,'0000009'))||'-'||LTRIM(to_char(proposal_no,'09')) quoteno,
                       nvl(decode(c.assd_name2,NULL,c.assd_name,c.assd_name||' '||c.assd_name2), A.assd_name) assd_name,
                       HEADER,footer,
                       incept_date,expiry_date,
                       incept_tag,expiry_tag,
                       accept_dt,
                       valid_date,
                       address1, address2, address3,
                       decode(address3,NULL,decode(address2,NULL,address1,address1||chr(10)||Address2),
                                        decode(address2,NULL,address1,address1||chr(10)||Address2)||chr(10)||address3) address,
                       A.remarks--,
                       --A.prem_amt   -- bmq
                 FROM  gipi_quote A, giis_line b, giis_assured c, giis_users d, giis_subline E
                WHERE  A.quote_id = p_quote_id
                  AND  A.line_cd  = b.line_cd
                  AND  A.assd_no  = c.assd_no(+)
                  AND  A.user_id  = d.user_id
                  AND  A.line_cd  = E.line_cd
                  AND  A.line_cd  = b.line_cd
                  AND  A.subline_cd  = E.subline_cd
            )
  LOOP
      v_ucpb.assd_name          := A.assd_name;
      v_ucpb.assd_add1          := A.address1;
      v_ucpb.assd_add2          := A.address2;
      v_ucpb.assd_add3          := A.address3;
      v_ucpb.address            := A.address;
      v_ucpb.loc_add            := A.address;
      v_ucpb.HEADER             := A.HEADER;
      v_ucpb.footer             := A.footer;
      v_ucpb.accept_dt          := TO_CHAR(A.accept_dt, 'fmMonth DD, YYYY');
      v_ucpb.valid              := TO_CHAR(A.valid_date, 'fmMonth DD, YYYY');
      v_ucpb.incept             := TO_CHAR(A.incept_date, 'fmMonth DD, YYYY');
      v_ucpb.expiry             := TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY');
      v_ucpb.line_cd            := A.line_cd;
      v_ucpb.subline_cd         := A.subline_cd;
      v_ucpb.line_name          := A.line_name;
      v_ucpb.subline_name       := A.subline_name;
      v_ucpb.iss_cd             := A.iss_cd;
      v_ucpb.remarks            := A.remarks;

      -- added by grace 09.08.2011
      -- to handle cases where the prem_amt in GIPI_QUOTE is NULL
      FOR B IN (SELECT SUM(prem_amt) prem_amt
                  FROM gipi_quote_itmperil
                 WHERE quote_id = p_quote_id )
      LOOP
        v_ucpb.prem_amt           := B.prem_amt;
        EXIT;
      END LOOP;

      BEGIN
        SELECT param_value_v
          INTO v_ucpb.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

  END LOOP;
    PIPE ROW(v_ucpb);
    RETURN;
  END get_quote_details_pa_ucpb;
 ----* GET QUOTE DETAILS

 ----* GET SIGNATORY
  FUNCTION get_accident_signatory(p_quote_id NUMBER, p_iss_cd VARCHAR2)
  RETURN accident_signatory_tab PIPELINED IS
    v_sig    accident_signatory_type;
    v_line   gipi_quote.line_cd%TYPE;
  BEGIN
    FOR A IN (SELECT line_cd
                FROM gipi_quote
               WHERE quote_id = p_quote_id)
    LOOP
      v_line := A.line_cd;
    END LOOP;

     FOR sig IN (SELECT SIGNATORY,DESIGNATION
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE NVL(A.REPORT_ID,'PA_QUOTE') = 'PA_QUOTE'
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd  --
                       AND nvl(A.line_cd,v_line)= v_line          --
                       AND current_signatory_sw = 'Y'
                       AND A.signatory_id = b.signatory_id )
      LOOP
          v_sig.sig_name := sig.signatory;
          v_sig.sig_des := sig.designation;
      END LOOP;
    PIPE ROW(v_sig);
    RETURN;
  END;
 ----* GET SIGNATORY

  ----/* GET ITEMS
 FUNCTION get_quote_items_pa_ucpb(p_quote_id NUMBER)
 RETURN quote_pa_items_tab PIPELINED IS
 v_items    quote_pa_items_type;
 BEGIN
   FOR i IN (    SELECT
               DISTINCT  d.item_no,
                         d.item_title
                   FROM  gipi_quote_itmperil A, gipi_quote b, giis_peril c, gipi_quote_item d
                  WHERE  A.QUOTE_ID = b.QUOTE_ID
                    AND  b.LINE_CD  = c.LINE_CD
                    AND  A.PERIL_CD = c.PERIL_CD
                    AND  A.quote_id = d.quote_id
                    AND  A.quote_id = p_quote_id
               ORDER BY  d.item_no)
   LOOP
         v_items.item_no    := i.item_no;
         v_items.item_title := i.item_title;
   PIPE ROW(v_items);
   END LOOP;

    RETURN;
 END ;
 ----* GET ITEMS

   ----/* GET PERILS
 FUNCTION get_quote_perils_pa_ucpb(p_quote_id NUMBER, p_item_no NUMBER)
 RETURN quote_pa_perils_tab PIPELINED IS
 v_peril    quote_pa_perils_type;
 BEGIN
   FOR P IN (  SELECT DISTINCT d.item_no,
                      c.peril_cd,
                      nvl(c.peril_lname, c.peril_name) peril_name,
                      initcap(E.short_name) short_name,
                      A.tsi_amt,
                      A.prem_amt
                   FROM gipi_quote_itmperil A, gipi_quote b, giis_peril c, gipi_quote_item d, giis_currency E
                  WHERE A.quote_id = b.quote_id
                    AND b.line_cd  = c.line_cd
                    AND A.peril_cd = c.peril_cd
                    AND A.quote_id = d.quote_id
                    AND A.quote_id = p_quote_id
                    AND A.item_no  = d.item_no
                    AND d.item_no  = p_item_no
                    AND d.currency_cd = E.main_currency_cd
               ORDER BY item_no, peril_name)
   LOOP
          v_peril.peril_name := P.peril_name;
          v_peril.short_name := P.short_name;
          v_peril.tsi_amt    := P.tsi_amt;
          v_peril.prem_amt   := P.prem_amt;
   PIPE ROW(v_peril);
   END LOOP;

    RETURN;
 END ;
 ----* GET PERILS

 ----/* GET CLAUSES
 FUNCTION get_quote_clauses_pa_ucpb(p_quote_id NUMBER)
 RETURN quote_pa_clauses_tab PIPELINED IS
 v_clauses    quote_pa_clauses_type;
 BEGIN
   FOR c IN (  SELECT   wc_title
                 FROM gipi_quote_wc A
                WHERE A.quote_id = p_quote_id
             ORDER BY print_seq_no)
   LOOP
         v_clauses.wc_title    := c.wc_title;

   PIPE ROW(v_clauses);
   END LOOP;

    RETURN;
 END ;
 ----* GET CLAUSES

  ----/* GET TAX
 FUNCTION get_quote_tax_pa_ucpb(p_quote_id NUMBER)
 RETURN quote_pa_tax_tab PIPELINED IS
 v_tax    quote_pa_tax_type;
 BEGIN
    -- SELECT DISTINCT INDIVIDUAL TAXES
   FOR rec IN (  SELECT b.tax_desc,
                     ROUND(SUM(A.tax_amt * c.currency_rt),2) tax_amt,           -- bmq
                     ROUND(SUM(c.prem_amt * c.currency_rt),2) prem_amt,         -- bmq
                     --E.short_name,
                     SEQUENCE
                 FROM gipi_quote_invtax A, giis_tax_charges b, gipi_quote_invoice c, gipi_quote d--, giis_currency E
                WHERE b.line_cd = d.line_cd
                  AND b.tax_cd = A.tax_cd
                  AND b.iss_cd = c.iss_cd
                  AND A.iss_cd = c.iss_cd
                  AND A.quote_inv_no = c.quote_inv_no
                  AND NVL (b.expired_sw, 'N') = 'N'
                  AND c.quote_id = p_quote_id
                  AND c.quote_id = d.quote_id
                  --AND c.currency_cd = E.main_currency_cd
                GROUP BY c.quote_id, b.tax_desc, SEQUENCE
             ORDER BY SEQUENCE, tax_desc)
   LOOP
         v_tax.tax_desc   := rec.tax_desc;
         v_tax.tax_amt    := rec.tax_amt;
         v_tax.prem_amt   := rec.prem_amt;
         -- v_tax.short_name := rec.short_name;
         SELECT initcap(short_name) INTO v_tax.short_name
            FROM giis_currency
            WHERE currency_rt = 1 AND ROWNUM = 1;
   PIPE ROW(v_tax);
   END LOOP;



    RETURN;
 END ;
 ----* GET TAX

END QUOTE_REPORTS_PA_PKG;
/



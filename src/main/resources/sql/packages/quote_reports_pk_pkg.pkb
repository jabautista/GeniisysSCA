CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_PK_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_PK_PKG
   PURPOSE:    For Package Quotes (Report)

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/7/2011    Windell Valle    Created this package.
******************************************************************************/


/*****************ADDED*BY*WINDELL***********04*07*2011**************UCPB***********/
/*   Added by    : Windell Valle
**   Date Created: April 07, 2011
**   Last Revised: April 12, 2011
**   Description : UCPB Package Quote
**   Client(s)   : UCPB,...
*/
   -- MAIN DETAILS -- start
   FUNCTION get_quote_details_ucpb (p_quote_id NUMBER)
      RETURN quote_pk_details_ucpb_tab PIPELINED
   IS
      v_details   pk_quote_details_ucpb_type;
   BEGIN
      FOR a IN (    select pack_quote_id quote_id,a.line_cd,a.iss_cd,user_name,
                   line_name,
                   a.line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||LTRIM(to_char(quotation_no,'0000009'))||'-'||LTRIM(to_char(proposal_no,'09')) quoteno,
                   nvl(decode(c.assd_name2,null,c.assd_name,c.assd_name||' '||c.assd_name2), a.assd_name) assd_name,
                   header,footer,
                   incept_date,expiry_date,
                   incept_tag,expiry_tag,
                   valid_date,
                   acct_of_cd,acct_of_cd_sw,
                   decode(address3,null,decode(address2,null,address1,address1||chr(10)||Address2),
                                        decode(address2,null,address1,address1||chr(10)||Address2)||chr(10)||address3) address,
                   a.remarks,
                   a.bank_ref_no
              from gipi_pack_quote a, giis_line b, giis_assured c, giis_users d
             where pack_quote_id = NVL(p_quote_id, pack_quote_id)
               and a.line_cd = b.line_cd
               and a.assd_no = c.assd_no(+)
               and a.user_id = d.user_id
               and a.line_cd = b.line_cd)
      LOOP
         v_details.quote_id := a.quote_id;
         v_details.line_name := a.line_name;
         v_details.quote_no := a.quoteno;
         v_details.assd := a.assd_name;
         v_details.header := a.header;
         v_details.footer := a.footer;
         v_details.incept := a.incept_date;
         v_details.expiry := a.expiry_date;
         v_details.valid := TO_CHAR (a.valid_date, 'fmMonth DD, YYYY');
         v_details.acct_of_cd := a.acct_of_cd;
         v_details.acct_of_cd_sw := a.acct_of_cd_sw;
         v_details.address := a.address;
         v_details.remarks := a.remarks;
         v_details.line_cd := a.line_cd;
         v_details.iss_cd := a.iss_cd;
         v_details.user_name := a.user_name;
         v_details.bank_ref_no := NVL(a.bank_ref_no,' ');

         IF a.expiry_tag is null or a.expiry_tag = 'N' THEN
            v_details.expiry := to_char(a.expiry_date,'fmMonth DD, RRRR');
         ELSE
            v_details.expiry := 'T.B.A';
         END IF;

         IF a.incept_tag is null or a.incept_tag = 'N' THEN
            v_details.incept := to_char(a.incept_date,'fmMonth DD, RRRR');
         ELSE
            v_details.incept := 'T.B.A';
         END IF;
            v_details.duration:= v_details.incept ||' to '|| v_details.expiry;

         BEGIN
            SELECT PARAM_VALUE_V
                   INTO  v_details.logo_file
                   FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'LOGO_FILE';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         null;
         END;

         FOR h IN (SELECT DISTINCT mortg_name
                              FROM gipi_quote_mortgagee a, giis_mortgagee b
                             WHERE a.mortg_cd = b.mortg_cd
                               AND quote_id = p_quote_id)
         LOOP
            v_details.mortgagee := h.mortg_name;
         END LOOP;

         FOR sig IN (SELECT signatory, designation
                       FROM giis_signatory a, giis_signatory_names b
                      WHERE NVL (a.report_id, 'PK_QUOTE') = 'PK_QUOTE'
                        AND NVL (a.iss_cd, v_details.iss_cd) = v_details.iss_cd
                        AND NVL (a.line_cd, v_details.line_cd) = v_details.line_cd
                        AND current_signatory_sw = 'Y'
                        AND a.signatory_id = b.signatory_id)
         LOOP
            v_details.sig_name := sig.signatory;
            v_details.sig_des := sig.designation;
         END LOOP;

         PIPE ROW (v_details);
      END LOOP;

      RETURN;
   END get_quote_details_ucpb;
   -- MAIN DETAILS -- end


   -- PERIL DETAILS -- start
   FUNCTION get_peril_details_ucpb (p_quote_id NUMBER)
      RETURN peril_pk_details_tab PIPELINED
   IS
      v_peril   pk_peril_details_ucpb_type;
   BEGIN
      FOR f IN (SELECT DISTINCT DECODE (a.comp_rem,
                                        NULL, peril_name,
                                           peril_name
                                        || CHR (10)
                                        || CHR (9)
                                        || a.comp_rem
                                       ) peril_name,
                                peril_name peril, a.comp_rem remarks,
                                c.SEQUENCE
                           FROM gipi_quote_itmperil a,
                                gipi_quote b,
                                giis_peril c
                          WHERE a.quote_id = NVL(p_quote_id,a.quote_id)
                            AND a.quote_id = b.quote_id
                            AND b.line_cd = c.line_cd
                            AND a.peril_cd = c.peril_cd
                       ORDER BY c.SEQUENCE, peril_name)
      LOOP
         v_peril.peril := f.peril;
         v_peril.peril_remarks := f.remarks;
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_peril_details_ucpb;
   -- PERIL DETAILS -- end


   -- DEDUCTIBLES DETAILS -- start
   FUNCTION get_deductible_details_ucpb (p_quote_id NUMBER)
      RETURN deductible_pk_details_tab PIPELINED
   IS
      v_deduct   pk_deduct_details_ucpb_type;
   BEGIN
      FOR g IN (SELECT DISTINCT deductible_text
                           FROM gipi_quote_deductibles
                          WHERE quote_id = p_quote_id)
      LOOP
         v_deduct.deductible_text := g.deductible_text;
         PIPE ROW (v_deduct);
      END LOOP;
      RETURN;
   END get_deductible_details_ucpb;
  -- DEDUCTIBLES DETAILS -- end


   -- OTHER DETAILS -- start
   FUNCTION get_item_details_ucpb (p_quote_id NUMBER)
      RETURN item_pk_details_tab PIPELINED
   IS
      v_item   pk_item_details_ucpb_type;
   BEGIN
      FOR d IN (SELECT LTRIM (TO_CHAR (item_no, '99990')) item_no,
                       item_title, item_desc,
                          short_name
                       || LTRIM (TO_CHAR (tsi_amt, '9,999,999,999,999,999.99'))
                                                                     tsi_amt
                  FROM gipi_quote_item a, giis_currency b
                 WHERE quote_id = p_quote_id
                   AND a.currency_cd = b.main_currency_cd)
      LOOP
         v_item.item :=
               d.item_no
            || '-'
            || d.item_title
            || '            '
            || '('
            || d.tsi_amt
            || ')';
         v_item.detail :=
               d.item_no
            || '-'
            || d.item_title
            || '            '
            || '('
            || d.tsi_amt
            || ')';
         v_item.item_desc := d.item_desc;
         PIPE ROW (v_item);
      END LOOP;
      RETURN;
   END get_item_details_ucpb;
   -- OTHER DETAILS -- end


   -- WARRANTY CLAUSE / INSURING CONDITIONS -- start
   FUNCTION get_wc_details_ucpb (p_quote_id NUMBER)
      RETURN wc_pk_details_tab PIPELINED
   IS
      v_warrcla   pk_wc_details_ucpb_type;
   BEGIN
      FOR wc IN (SELECT DISTINCT DECODE (wc_title2,
                                  NULL, wc_title,
                                  wc_title || ' ' || wc_title2
                                 ) title, print_seq_no
                     FROM gipi_quote_wc
                    WHERE quote_id = p_quote_id
                 ORDER BY print_seq_no, title)
      LOOP
         v_warrcla.warrcla := wc.title;
         PIPE ROW (v_warrcla);
      END LOOP;

      RETURN;
   END get_wc_details_ucpb;
   -- WARRANTY CLAUSE / INSURING CONDITIONS -- end


   -- PREMIUM DETAILS -- start
   FUNCTION get_premium_details_ucpb (p_quote_id NUMBER)
      RETURN premium_pk_details_tab PIPELINED
   IS
      v_prem   pk_premium_details_ucpb_type;
   BEGIN
      FOR i IN
         (SELECT b.line_cd, a.iss_cd, a.quote_inv_no, a.prem_amt,
                 LTRIM (TO_CHAR (NVL ((a.prem_amt + a.tax_amt), 0),
                                 '9,999,999,999,999,999.99'
                                )
                       ) total_amt_due
            FROM gipi_quote_invoice a, gipi_quote b
           WHERE a.quote_id = p_quote_id AND a.quote_id = b.quote_id)
      LOOP
         v_prem.premium :=
                     LTRIM (TO_CHAR (i.prem_amt, '9,999,999,999,999,999.99'));
         v_prem.tot_amt := i.total_amt_due;

         FOR j IN
            (SELECT   tax_desc,
                      LTRIM (TO_CHAR (tax_amt, '9,999,999,999,999,990.90')
                            ) tax_amt,
                      SEQUENCE
                 FROM gipi_quote_invtax a, giis_tax_charges b
                WHERE b.line_cd = i.line_cd
                  AND b.tax_cd = a.tax_cd
                  AND b.iss_cd = a.iss_cd
                  AND a.iss_cd = i.iss_cd
                  AND a.quote_inv_no = i.quote_inv_no
                  AND NVL (b.expired_sw, 'N') = 'N'
             ORDER BY SEQUENCE, tax_desc)
         LOOP
            v_prem.tax_desc := j.tax_desc;
            v_prem.tax_amt := j.tax_amt;
         END LOOP;

         PIPE ROW (v_prem);
      END LOOP;

      RETURN;
   END;
   -- PREMIUM DETAILS -- end

/*****************ADDED*BY*WINDELL***********04*07*2011**************UCPB***********/
END QUOTE_REPORTS_PK_PKG;
/



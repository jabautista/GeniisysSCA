CREATE OR REPLACE PACKAGE BODY CPI.POPULATE_EN_QUOTE_PKG AS

/******************************************************************************
   NAME:       POPULATE_EN_QUOTE_PKG - GIIMM006
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012    Nikko           1. Created this package.
******************************************************************************/


FUNCTION populate_engineering_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                        p_attn_position VARCHAR2,
                                        p_designation   VARCHAR2)
  RETURN quote_en_tab PIPELINED IS
  v_quote           quote_en_type;
  v_prem_amt_temp   NUMBER(16,2);

  BEGIN
    FOR d IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no,
                     a.assd_name assd_name, a.address1, a.address2, a.address3,
               TO_CHAR(a.incept_date, 'fmMonth DD, YYYY') incept_date,
               TO_CHAR(a.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                       a.header, a.footer,a.line_cd,a.subline_cd
              FROM gipi_quote a
               WHERE quote_id = p_quote_id)
      LOOP
        v_quote.quote_num        := d.quote_no;
        v_quote.assd_name        := d.assd_name;
        v_quote.assd_add1        := d.address1;
        v_quote.assd_add2        := d.address2;
        v_quote.assd_add3        := d.address3;
        v_quote.incept           := d.incept_date;
        v_quote.expiry           := d.expiry_date;
        v_quote.header           := d.header;
        v_quote.footer           := d.footer;
        v_quote.line_cd          := d.line_cd;
        v_quote.subline_cd       := d.subline_cd;

        --get business and site
        FOR q IN (SELECT contract_proj_buss_title business, site_location site
                    FROM gipi_quote_en_item
                      WHERE quote_id = p_quote_id
                      AND contract_proj_buss_title IS NOT NULL)
       LOOP
         v_quote.business := q.business;
         v_quote.site := q.site;
       END LOOP;

       --get premium
       FOR n IN (SELECT TO_CHAR(SUM(prem_amt * currency_rate), '999,999,999,999.99') prem_amt,
    						    SUM(prem_amt * currency_rate) prem_amt1
  				  FROM gipi_quote_item
 				  WHERE quote_id = p_quote_id)
 	   LOOP
 	     v_quote.prem_amt	:= n.prem_amt;
 		 v_prem_amt_temp    := n.prem_amt1;
 	   END LOOP;
       --get tax
       FOR o IN (SELECT a.quote_id, SUM(DISTINCT b.tax_amt * a.currency_rt) tax
                 FROM gipi_quote_invoice a,
                      gipi_quote_invtax b,
                      gipi_quote_item c,
                      gipi_quote d
                 WHERE c.currency_cd = a.currency_cd
                   AND a.quote_id = p_quote_id
                   AND a.quote_inv_no = b.quote_inv_no
                   AND a.quote_id = c.quote_id
                   AND a.quote_id = d.quote_id
                   AND b.iss_cd = a.iss_cd
                 GROUP BY  a.quote_id)
       LOOP
         v_quote.tax	:= o.tax;
       END LOOP;

       v_quote.tot_prem       := TO_CHAR(v_prem_amt_temp + v_quote.tax, '999,999,999,999.99');
       v_quote.attn_position  := INITCAP(p_attn_position);
       v_quote.designation    := INITCAP(p_designation);
      PIPE ROW(v_quote);
      END LOOP;
  END populate_engineering_quotation;

FUNCTION get_en_quote_item_title(p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN quote_en_item_title_tab PIPELINED IS
  v_quote     quote_en_item_title_type;

  BEGIN
     --get wrd_item/insured
     FOR f IN (SELECT item_title
                FROM gipi_quote_item
                 WHERE quote_id = p_quote_id)
     LOOP
       v_quote.item_title := f.item_title;
       PIPE ROW(v_quote);
     END LOOP;
     RETURN;
  END get_en_quote_item_title;

FUNCTION get_en_quote_itmperil(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                               p_line_cd GIPI_QUOTE.line_cd%TYPE)

  RETURN quote_en_itmperil_tab PIPELINED IS
  v_quote quote_en_itmperil_type;

  BEGIN
    FOR j IN (SELECT c.peril_lname, TO_CHAR(SUM(a.tsi_amt * b.currency_rate), '999,999,999,999.99') tsi_amt
                  FROM gipi_quote_itmperil a,
                     gipi_quote_item b,
                     giis_peril c
               WHERE a.quote_id = p_quote_id
                 AND a.quote_id = b.quote_id
                 AND a.item_no = b.item_no
                 AND c.line_cd = p_line_cd
                 AND a.peril_cd = c.peril_cd
            GROUP BY c.peril_lname)
    LOOP
      v_quote.peril_name  := j.peril_lname;
      v_quote.tsi_amt     := j.tsi_amt;

      PIPE ROW(v_quote);

    END LOOP;
    RETURN;
  END get_en_quote_itmperil;

FUNCTION get_en_quote_invtax(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                             p_line_cd GIPI_QUOTE.line_cd%TYPE)
  RETURN quote_en_invtax_tab PIPELINED IS
  v_quote   quote_en_invtax_type;

  BEGIN
    FOR k IN (SELECT b.tax_cd, e.tax_desc, TO_CHAR(SUM(DISTINCT b.tax_amt), '999,999,999,999.99') tax_amt
               FROM gipi_quote_invoice a,
                    gipi_quote_invtax b,
                    gipi_quote_item c,
                    gipi_quote d,
					giis_tax_charges e
               WHERE c.currency_cd = a.currency_cd
                 AND d.quote_id = p_quote_id
                 AND a.quote_inv_no = b.quote_inv_no
                 AND a.quote_id = c.quote_id
                 AND a.quote_id = d.quote_id
                 AND b.iss_cd = a.iss_cd
                 AND b.iss_cd = e.iss_cd
                 AND b.line_cd = e.line_cd
                 AND b.tax_cd = e.tax_cd
				 AND e.line_cd = p_line_cd
                GROUP BY  b.tax_cd, e.tax_desc)
    LOOP
      v_quote.tax_desc := k.tax_desc;
      v_quote.tax_amt  := k.tax_amt;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_en_quote_invtax;

FUNCTION get_en_quote_deduc(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                            p_line_cd GIPI_QUOTE.line_cd%TYPE,
                            p_subline_cd GIPI_QUOTE.subline_cd%TYPE)
  RETURN quote_en_deductible_tab PIPELINED IS
  v_quote quote_en_deductible_type;

  BEGIN
    FOR p IN (SELECT b.deductible_title ded_title,
                     a.deductible_text,
                     a.deductible_amt ded_amt,
                     a.deductible_rt ded_rate
              FROM gipi_quote_deductibles a,
                   giis_deductible_desc b
 			  WHERE quote_id = p_quote_id
                AND line_cd = p_line_cd
                AND subline_cd = p_subline_cd
                AND a.ded_deductible_cd = b.deductible_cd)
    LOOP
   	  v_quote.title :=  p.ded_title;
   	  v_quote.rate  :=  p.ded_rate;
      v_quote.amt   :=  TO_CHAR(p.ded_amt, '999,999,999.99');

      IF p.deductible_text = NULL THEN
        v_quote.text := ' ';
      ELSE
    	v_quote.text := ' - '||p.deductible_text;
      END IF;

      IF v_quote.rate IS NULL THEN
        v_quote.deduct := (v_quote.amt);
      ELSE
        v_quote.deduct := (v_quote.rate||'%');
      END IF;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_en_quote_deduc;

FUNCTION get_en_quote_wc(p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN quote_en_wc_tab PIPELINED IS
  v_quote  quote_en_wc_type;

  BEGIN
    FOR i IN (SELECT wc_title, print_sw
              FROM gipi_quote_wc
                WHERE quote_id = p_quote_id
              ORDER BY    print_seq_no)
    LOOP
      v_quote.wc_title  :=  i.wc_title;

         FOR j IN (SELECT a.wc_text01 wc_text1a,
                        a.wc_text02 wc_text2a,
                        a.wc_text03 wc_text3a,
                        a.wc_text04 wc_text4a,
                        a.wc_text05 wc_text5a,
                        a.wc_text06 wc_text6a,
                        a.wc_text07 wc_text7a,
                        a.wc_text08 wc_text8a,
                        a.wc_text09 wc_text9a,
                        a.wc_text10 wc_text10a,
                        a.wc_text11 wc_text11a,
                        a.wc_text12 wc_text12a,
                        a.wc_text13 wc_text13a,
                        a.wc_text14 wc_text14a,
                        a.wc_text15 wc_text15a,
                        a.wc_text16 wc_text16a,
                        a.wc_text17 wc_text17a,
                        b.wc_text01 wc_text1,
                        b.wc_text02 wc_text2,
                        b.wc_text03 wc_text3,
                        b.wc_text04 wc_text4,
                        b.wc_text05 wc_text5,
                        b.wc_text06 wc_text6,
                        b.wc_text07 wc_text7,
                        b.wc_text08 wc_text8,
                        b.wc_text09 wc_text9,
                        b.wc_text10 wc_text10,
                        b.wc_text11 wc_text11,
                        b.wc_text12 wc_text12,
                        b.wc_text13 wc_text13,
                        b.wc_text14 wc_text14,
                        b.wc_text15 wc_text15,
                        b.wc_text16 wc_text16,
                        b.wc_text17 wc_text17,
                        b.print_sw,
                        b.change_tag
                   FROM giis_warrcla a,
                        gipi_quote_wc b
                  WHERE b.quote_id = p_quote_id
                    AND a.line_cd = 'EN'
                    AND a.line_cd = b.line_cd
                    AND a.main_wc_cd = b.wc_cd
                    AND b.print_sw = 'Y'
                    AND b.wc_title = v_quote.wc_title
                  ORDER BY b.print_seq_no)
            LOOP

                IF j.change_tag = 'N' THEN
                  v_quote.wc_text := j.wc_text1a ||
                                  j.wc_text2a ||
                                  j.wc_text3a ||
                                  j.wc_text4a ||
                                  j.wc_text5a ||
                                  j.wc_text6a ||
                                  j.wc_text7a ||
                                  j.wc_text8a ||
                                  j.wc_text9a ||
                                  j.wc_text10a ||
                                  j.wc_text11a ||
                                  j.wc_text12a ||
                                  j.wc_text13a ||
                                  j.wc_text14a ||
                                  j.wc_text15a ||
                                  j.wc_text16a ||
                                  j.wc_text17a;
             ELSE
               v_quote.wc_text := j.wc_text1 ||
                                  j.wc_text2 ||
                                  j.wc_text3 ||
                                  j.wc_text4 ||
                                  j.wc_text5 ||
                                  j.wc_text6 ||
                                  j.wc_text7 ||
                                  j.wc_text8 ||
                                  j.wc_text9 ||
                                  j.wc_text11 ||
                                  j.wc_text12 ||
                                  j.wc_text13 ||
                                  j.wc_text14 ||
                                  j.wc_text15 ||
                                  j.wc_text16 ||
                                  j.wc_text17;
             END IF;
          END LOOP;
        PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_en_quote_wc;


END POPULATE_EN_QUOTE_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.POPULATE_AC_QUOTE_PKG AS

/******************************************************************************
   NAME:       POPULATE_AC_QUOTE_PKG - GIIMM006
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012    Nikko           1. Created this package.
******************************************************************************/


FUNCTION populate_accident_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                      p_attn_position VARCHAR2,
                                      p_designation VARCHAR2)
  RETURN quote_accident_tab PIPELINED IS

  v_quote    quote_accident_type;
  v_prem_amt_temp    NUMBER(16,2);

  BEGIN

    --get assured
    FOR a IN (SELECT DISTINCT a.assd_name assd_name, a.address1, a.address2, a.address3,
                a.address1||' '||a.address2||' '||a.address3 address,
                TO_CHAR(a.incept_date, 'fmMonth DD, YYYY') incept_date,
                TO_CHAR(a.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                a.header, a.footer,a.line_cd,a.user_id
                FROM gipi_quote a
                WHERE quote_id = p_quote_id)
     LOOP
       v_quote.assd_name        := a.assd_name;
       v_quote.assd_add1        := a.address1;
       v_quote.assd_add2        := a.address2;
       v_quote.assd_add3        := a.address3;
       v_quote.address            := a.address;
       v_quote.incept            := a.incept_date;
       v_quote.expiry            := a.expiry_date;
       v_quote.header            := a.header;
       v_quote.footer            := a.footer;
       v_quote.line_cd          := a.line_cd;

       --retrieve subline_name
       FOR a IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                     FROM gipi_quote
                    WHERE quote_id = p_quote_id)
       LOOP
         v_quote.quote_num := a.quote_no;
       END LOOP;


       --get the premium amount
           FOR e IN (SELECT TO_CHAR(SUM(prem_amt * currency_rate), '999,999,999,999.99') prem_amt,
                                    SUM(prem_amt * currency_rate) prem_amt1
                     FROM gipi_quote_item
                    WHERE quote_id = p_quote_id)
         LOOP
              v_quote.prem_amt := NVL(e.prem_amt,0);
             v_prem_amt_temp  := NVL(e.prem_amt1,0);
         END LOOP;


        --get the total premium amount
         FOR h IN (SELECT a.quote_id, SUM(DISTINCT b.tax_amt * a.currency_rt) tax
                   FROM gipi_quote_invoice a,
                        gipi_quote_invtax b,
                        gipi_quote_item c,
                        gipi_quote d
                   WHERE c.currency_cd = a.currency_cd
                     AND d.quote_id = p_quote_id
                     AND a.quote_inv_no = b.quote_inv_no
                     AND a.quote_id = c.quote_id
                     AND a.quote_id = d.quote_id
                     AND b.iss_cd = a.iss_cd
                   GROUP BY  a.quote_id)
         LOOP
           v_quote.tot_tax := NVL(h.tax,0);
           v_quote.tot_prem := TO_CHAR(v_quote.tot_tax + v_prem_amt_temp, '999,999,999,999.99');
         END LOOP;

       v_quote.attn_position    :=INITCAP(p_attn_position);
       v_quote.designation      :=INITCAP(p_designation);
       PIPE ROW(v_quote);

     END LOOP;
     RETURN;
  END populate_accident_quotation;

FUNCTION populate_pa_quote_item(p_quote_id GIPI_QUOTE.quote_id%TYPE)

  RETURN quote_accident_item_tab PIPELINED IS
  v_quote     quote_accident_item_type;

  BEGIN
    FOR c IN (SELECT no_of_persons, destination, position
              FROM gipi_quote_ac_item a,
                   giis_position b
              WHERE a.position_cd = b.position_cd
              AND quote_id = p_quote_id)
     LOOP
       v_quote.no_person := c.no_of_persons;
       v_quote.position := c.position;
       v_quote.destination := c.destination;

    END LOOP;
      PIPE ROW(v_quote); --just gets the last record
    RETURN;
  END populate_pa_quote_item;


FUNCTION get_pa_quote_itmperil(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                    p_line_cd GIIS_PERIL.line_cd%TYPE)

  RETURN quote_pa_itmperil_tab PIPELINED IS
  v_quote    quote_pa_itmperil_type;

  BEGIN
    FOR d IN (SELECT c.peril_lname, to_char(SUM(a.tsi_amt), '999,999,999,999.90') tsi
              FROM gipi_quote_itmperil a,
                   gipi_quote_item b,
                   giis_peril c
              WHERE a.quote_id = p_quote_id
              AND a.item_no = b.item_no
              AND a.quote_id = b.quote_id
              AND a.peril_cd = c.peril_cd
              AND c.line_cd = p_line_cd
              GROUP BY c.peril_lname)
    LOOP
      v_quote.peril_title := d.peril_lname;
      v_quote.tsi_amt     := d.tsi;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_pa_quote_itmperil;

FUNCTION populate_pa_quote_invtax(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                       p_line_cd GIIS_PERIL.line_cd%TYPE)

  RETURN quote_pa_invtax_tab PIPELINED IS
  v_quote   quote_pa_invtax_type;

  BEGIN
    FOR f IN (SELECT b.tax_cd, e.tax_desc, TO_CHAR(SUM(DISTINCT b.tax_amt), '999,999,999,999.99') tax_amt
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
      v_quote.tax_desc := f.tax_desc;
      v_quote.tax_amt  := f.tax_amt;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END populate_pa_quote_invtax;

FUNCTION populate_pa_quote_wc(p_quote_id GIPI_QUOTE.quote_id%TYPE)

  RETURN quote_accident_wc_tab PIPELINED IS
  v_wc     quote_accident_wc_type;

  BEGIN
    FOR i IN (SELECT wc_title, print_sw
              FROM gipi_quote_wc
                WHERE quote_id = p_quote_id
              ORDER BY    print_seq_no)
    LOOP
      v_wc.wc_title  :=  i.wc_title;
     -- IF i.print_sw = 'Y' THEN

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
                    AND a.line_cd = 'PA'
                    AND a.line_cd = b.line_cd
                    AND a.main_wc_cd = b.wc_cd
                    AND b.print_sw = 'Y'
                    AND b.wc_title = v_wc.wc_title
                  ORDER BY b.print_seq_no)
            LOOP

                IF j.change_tag = 'N' THEN
                  v_wc.wc_text := j.wc_text1a ||
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
               v_wc.wc_text := j.wc_text1 ||
                               j.wc_text2 ||
                               j.wc_text3 ||
                               j.wc_text4 ||
                               j.wc_text5 ||
                               j.wc_text6 ||
                               j.wc_text7 ||
                               j.wc_text8 ||
                               j.wc_text9 ||
                               j.wc_text10 ||
                               j.wc_text11 ||
                               j.wc_text12 ||
                               j.wc_text13 ||
                               j.wc_text14 ||
                               j.wc_text15 ||
                               j.wc_text16 ||
                               j.wc_text17;
             END IF;
          END LOOP;
        PIPE ROW(v_wc);
     -- END IF;
    END LOOP;
    RETURN;
  END populate_pa_quote_wc;



END POPULATE_AC_QUOTE_PKG;
/



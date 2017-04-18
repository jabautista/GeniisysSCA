CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_EN_PKG AS
/******************************************************************************
  NAME:       QUOTE_REPORTS_EN_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/1/2010             1. Created this package.
******************************************************************************/

  FUNCTION get_en_quote_details (p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN en_quote_details_tab PIPELINED IS

      v_en_quote_detail     en_quote_details_type;
      v_tot_prem            GIPI_QUOTE_ITMPERIL.prem_amt%TYPE;
      v_tot_tax             GIPI_INV_TAX.tax_amt%TYPE;
      v_tot_tsi             GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE;

  BEGIN
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
              TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
              TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
              TO_CHAR(A.accept_dt, 'fmMonth DD, YYYY') accept_date,
              A.remarks, A.HEADER, A.footer,
              to_char(A.valid_date,'fmMM/DD/YYYY') valid_date,              ---------------------------
              A.line_cd,A.iss_cd, (A.expiry_date - A.incept_date) duration  ---added by gino 5.13.11---
                FROM gipi_quote A
               WHERE quote_id = p_quote_id)

     LOOP

           v_en_quote_detail.assd_name        := A.assd_name;
           v_en_quote_detail.assd_add1        := A.address1;
           v_en_quote_detail.assd_add2        := A.address2;
           v_en_quote_detail.assd_add3        := A.address3;
           v_en_quote_detail.incept        := A.incept_date;
           v_en_quote_detail.expiry        := A.expiry_date;
        v_en_quote_detail.accept_dt     := A.accept_date;
        v_en_quote_detail.end_remarks   := A.remarks;
           v_en_quote_detail.HEADER        := A.HEADER;
           v_en_quote_detail.footer        := A.footer;
        v_en_quote_detail.valid_date    := A.valid_date;
        v_en_quote_detail.line_cd    := A.line_cd;
        v_en_quote_detail.iss_cd    := A.iss_cd;
        v_en_quote_detail.duration    := A.duration;

      --TO GET AGENT NAME
      FOR b IN (SELECT intm_name agent
                   FROM giis_intermediary intm, gipi_quote_invoice inv
                   WHERE quote_id = p_quote_id
                   AND intm.intm_no = inv.intm_no)
       LOOP

        IF b.agent IS NOT NULL THEN
            v_en_quote_detail.agent_name := 'Agent: ' || b.agent;
        ELSE
          v_en_quote_detail.agent_name := ' ';
        END IF;

       END LOOP;


      FOR rec IN (SELECT param_value_v doc
           FROM giis_parameters
          WHERE param_name = 'ENGINEERING_QUOTE')

       LOOP
           v_en_quote_detail.doc_name := SUBSTR(RTRIM(LTRIM(rec.doc)), 1, LENGTH(RTRIM(LTRIM(rec.doc)))-4);
      END LOOP;

     --TO GET QUOTE NUMBER
      FOR d IN (SELECT subline_cd, line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
           FROM gipi_quote A
          WHERE quote_id = p_quote_id)

      LOOP
        v_en_quote_detail.quote_num        := d.quote_no;
        v_en_quote_detail.subline_cd    := d.subline_cd;
      END LOOP;

      --TO GET SUBLINE NAME
      FOR f IN (SELECT subline_name
                FROM giis_subline
               WHERE line_cd = 'EN'
                 AND subline_cd = v_en_quote_detail.subline_cd)
      LOOP
        v_en_quote_detail.subline_name   := f.subline_name;
      END LOOP;

     --TO GET ITEM NUMBER
     FOR f IN (SELECT item_no
          FROM gipi_quote_item
         WHERE quote_id = p_quote_id)

     LOOP

       v_en_quote_detail.item_no      := f.item_no;
     END LOOP;

     --TO GET TOTAL PREMIUM
     BEGIN

       SELECT SUM(prem_amt * currency_rate) prem_amt1
           INTO v_tot_prem
             FROM gipi_quote_item
           WHERE quote_id = p_quote_id;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
     END;

     --TO GET TOTAL TSI
     BEGIN

       SELECT SUM(TSI_amt * currency_rate) tsi_amt1
           INTO v_tot_TSI
             FROM gipi_quote_item
           WHERE quote_id = p_quote_id;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
     END;

     --TO GET TOTAL
     BEGIN

       SELECT SUM(DISTINCT b.tax_amt * A.currency_rt) tax
         INTO v_tot_tax
         FROM gipi_quote_invoice A,
              gipi_quote_invtax b,
              gipi_quote_item c,
              gipi_quote d
        WHERE c.currency_cd  = A.currency_cd
          AND d.quote_id     = p_quote_id
          AND A.quote_inv_no = b.quote_inv_no
          AND d.quote_id     = c.quote_id
          AND A.quote_id     = d.quote_id
          AND b.iss_cd       = A.iss_cd
     GROUP BY A.quote_id;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
     END;

      v_en_quote_detail.prem_amt1         := NVL(v_tot_prem,0);
      v_en_quote_detail.tax              := NVL(v_tot_tax, 0);
      v_en_quote_detail.tot_amt           := NVL(v_tot_prem, 0) + NVL(v_tot_tax, 0);
      v_en_quote_detail.tsi_amt1        := NVL(v_tot_tsi, 0);


       BEGIN
            SELECT PARAM_VALUE_V
                INTO v_en_quote_detail.logo_file
                FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'LOGO_FILE';
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           NULL;
       END;
     --get signatory
     FOR G IN (SELECT signatory, designation---------------------gino 5.13.11--
                 FROM giis_signatory A, giis_signatory_names b
                WHERE 1 = 1
                  AND NVL (A.iss_cd, v_en_quote_detail.iss_cd) = v_en_quote_detail.iss_cd
                  AND current_signatory_sw = 'Y'
                  AND A.signatory_id = b.signatory_id
                  AND A.line_cd = v_en_quote_detail.line_cd)
     LOOP
        v_en_quote_detail.signatory := G.signatory;
        v_en_quote_detail.designation := G.designation;
     END LOOP;                               -----------------end gino 5.13.11--


      PIPE ROW(v_en_quote_detail);

    END LOOP;

      RETURN;

    END;

  --TO GET ITEM
  FUNCTION get_en_quote_item (p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN en_quote_item_tab PIPELINED IS

    v_en_quote_item en_quote_details_type;

  BEGIN

    FOR f IN (SELECT item_no, initcap(item_title) item_title, item_no||' - '||item_title item,
                     b.short_name
                FROM gipi_quote_item A,
                     giis_currency b
               WHERE A.currency_cd = b.main_currency_cd
                 AND quote_id = p_quote_id)

     LOOP
       v_en_quote_item.item_title   := f.item_title;
       v_en_quote_item.item_no      := f.item_no;
       v_en_quote_item.item         := f.item;
       v_en_quote_item.short_name   := f.short_name;

       FOR E IN (SELECT c.peril_name, c.peril_lname,
                        TO_CHAR(/*SUM*/(A.tsi_amt * b.currency_rate), '999,999,999,999.99') tsi_amt, 'Item' xitem
                   FROM gipi_quote_itmperil A,
                        gipi_quote_item b,
                        giis_peril c
                  WHERE A.quote_id = p_quote_id
                    AND A.quote_id = b.quote_id
                    AND A.item_no = b.item_no
                    AND A.item_no = v_en_quote_item.item_no
                    AND c.line_cd = 'EN'
                    AND A.peril_cd = c.peril_cd
                  --GROUP BY c.peril_name
                  ORDER BY A.item_no, c.peril_name)


        LOOP
          v_en_quote_item.peril1      := E.peril_lname;
          v_en_quote_item.peril       := E.peril_name;
          v_en_quote_item.tsi         := E.tsi_amt;
          --v_en_quote_item.dash        := e.short_name;
          --v_en_quote_item.xitem     := e.xitem;

        END LOOP;

        PIPE ROW(v_en_quote_item);

     END LOOP;

     RETURN;

  END;

  --TO GET PROJECT AND LOCATION
  FUNCTION get_en_quote_business (p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN en_quote_business_tab PIPELINED IS

    v_en_quote_business en_quote_details_type;

  BEGIN

    FOR q IN (SELECT contract_proj_buss_title business, site_location site
        FROM gipi_quote_en_item
       WHERE quote_id = p_quote_id
         AND contract_proj_buss_title IS NOT NULL)

    LOOP
      v_en_quote_business.business := q.business;
      v_en_quote_business.site := q.site;
      PIPE ROW (v_en_quote_business);
    END LOOP;

     RETURN;

  END;

  --TO GET PERIL AND TSI
  FUNCTION get_en_quote_item_peril (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_item_no GIPI_QUOTE_ITEM.item_no%TYPE)
  RETURN en_quote_item_peril_tab PIPELINED IS

    v_en_quote_item_peril en_quote_details_type;

  BEGIN

    FOR E IN (SELECT c.peril_name, c.peril_lname,
              TO_CHAR(/*SUM*/(A.tsi_amt * b.currency_rate), '999,999,999,999.99') tsi_amt, 'Item' xitem
         FROM gipi_quote_itmperil A,
              gipi_quote_item b,
              giis_peril c
        WHERE A.quote_id = p_quote_id
          AND A.quote_id = b.quote_id
          AND A.item_no = b.item_no
          AND A.item_no = p_item_no
          AND c.line_cd = 'EN'
          AND A.peril_cd = c.peril_cd
        --GROUP BY c.peril_name
     ORDER BY A.item_no, c.peril_name)


       LOOP
      v_en_quote_item_peril.peril1      := E.peril_lname;
         v_en_quote_item_peril.peril       := E.peril_name;
         v_en_quote_item_peril.tsi         := E.tsi_amt;
      --v_en_quote_item_peril.dash        := e.short_name;
      --v_en_quote_item_peril.xitem     := e.xitem;
      PIPE ROW (v_en_quote_item_peril);
    END LOOP;

     RETURN;

  END;

  --TO GET ITEM (CIC)
  FUNCTION get_en_quote_item_cic (p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN en_quote_item_cic_tab PIPELINED IS

    v_en_quote_item_cic en_quote_details_type;

  BEGIN

    FOR f IN (SELECT item_no, initcap(item_title) item_title, item_no||' - '||item_title item
          FROM gipi_quote_item
         WHERE quote_id = p_quote_id)

     LOOP
       v_en_quote_item_cic.item_title   := f.item_title;
       v_en_quote_item_cic.item_no      := f.item_no;
       v_en_quote_item_cic.item         := f.item;

           FOR E IN(SELECT 'Item ' xitem,
                A.item_no item_no,
                LTRIM(TO_CHAR((A.tsi_amt * b.currency_rate),'999,999,999,999.99')) tsi_amt,
                NVL(peril_lname,peril_name) peril,
                initcap(peril_name) peril_name,
                short_name
           FROM gipi_quote_itmperil A,
                gipi_quote_item b,
                giis_peril c,
                gipi_quote d,
                giis_currency E
          WHERE A.quote_id = b.quote_id
            AND b.quote_id = d.quote_id
            AND A.item_no = v_en_quote_item_cic.item_no
            AND b.item_no = v_en_quote_item_cic.item_no
            AND A.item_no = b.item_no
            AND A.peril_cd = c.peril_cd
            AND c.line_cd = d.line_cd
            AND b.currency_cd = E.main_currency_cd
            AND A.quote_id = p_quote_id
       ORDER BY A.item_no,peril_name)

       LOOP

         v_en_quote_item_cic.n := E.xitem||' '||E.item_no;
         v_en_quote_item_cic.peril := E.peril;

        IF v_en_quote_item_cic.itemno IS NOT NULL THEN

          IF E.item_no <> v_en_quote_item_cic.M THEN
            v_en_quote_item_cic.itemno  := v_en_quote_item_cic.n||'      '||E.peril;
          ELSE
            v_en_quote_item_cic.itemno  := E.peril;
          END IF;

        ELSE
          v_en_quote_item_cic.itemno  := v_en_quote_item_cic.n||'      '||E.peril;
        END IF;

        IF v_en_quote_item_cic.tsi IS NOT NULL THEN
          v_en_quote_item_cic.tsi := E.tsi_amt;
        ELSE
          v_en_quote_item_cic.tsi := E.tsi_amt;
        END IF;

        v_en_quote_item_cic.M      := E.item_no;
        v_en_quote_item_cic.dash    := E.short_name;

       END LOOP;

        BEGIN
            SELECT PARAM_VALUE_V
              INTO v_en_quote_item_cic.logo_file
                FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'LOGO_FILE';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;

        PIPE ROW(v_en_quote_item_cic);

     END LOOP;

     RETURN;

  END;

 --TO GET PERIL AND TSI (CIC)
 FUNCTION get_en_quote_peril_cic (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_item_no GIPI_QUOTE_ITEM.item_no%TYPE)
 RETURN en_quote_peril_cic_tab PIPELINED IS

   v_en_quote_peril_cic     en_quote_details_type;

 BEGIN

   FOR E IN(SELECT 'Item ' xitem,
            A.item_no item_no,
            LTRIM(TO_CHAR((A.tsi_amt * b.currency_rate),'999,999,999,999.99')) tsi_amt,
            NVL(peril_lname,peril_name) peril,
            initcap(peril_name) peril_name,
            short_name
       FROM gipi_quote_itmperil A,
            gipi_quote_item b,
            giis_peril c,
            gipi_quote d,
            giis_currency E
      WHERE A.quote_id = b.quote_id
        AND b.quote_id = d.quote_id
        AND A.item_no = b.item_no
        AND A.item_no = p_item_no
        AND A.peril_cd = c.peril_cd
        AND c.line_cd = d.line_cd
        AND b.currency_cd = E.main_currency_cd
        AND A.quote_id = p_quote_id
   ORDER BY A.item_no,peril_name)

     LOOP

       v_en_quote_peril_cic.n       := E.xitem||' '||E.item_no;
       v_en_quote_peril_cic.peril   := E.peril;
       v_en_quote_peril_cic.M       := E.item_no;

        IF v_en_quote_peril_cic.itemno IS NOT NULL THEN

          IF E.item_no <> v_en_quote_peril_cic.M THEN
            v_en_quote_peril_cic.itemno  := v_en_quote_peril_cic.n||'      '||E.peril;
          ELSE
            v_en_quote_peril_cic.itemno  := E.peril;
          END IF;

        ELSE
          v_en_quote_peril_cic.itemno  := v_en_quote_peril_cic.n||'      '||E.peril;
        END IF;

        IF v_en_quote_peril_cic.tsi IS NOT NULL THEN
          v_en_quote_peril_cic.tsi := E.tsi_amt;
        ELSE
          v_en_quote_peril_cic.tsi := E.tsi_amt;
        END IF;


        v_en_quote_peril_cic.dash    := E.short_name;

        PIPE ROW(v_en_quote_peril_cic);

     END LOOP;

       RETURN;

 END;


  --TO GET PERIL (SEICI)
  FUNCTION get_en_quote_peril_seici (p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN en_quote_peril_seici_tab PIPELINED IS

    v_en_quote_peril_seici      en_quote_details_type;

  BEGIN

    FOR f IN (SELECT c.peril_name, LTRIM(TO_CHAR((A.tsi_amt * b.currency_rate),'999,999,999,999.99')) tsi_amt,
             initcap(c.peril_lname) peril_lname, initcap(d.short_name) short_name
        FROM gipi_quote_itmperil A,
             gipi_quote_item b,
             giis_peril c,
             giis_currency d
       WHERE A.quote_id = p_quote_id
         AND b.currency_cd = d.main_currency_cd
         AND A.item_no = b.item_no
         AND A.quote_id = b.quote_id
         AND A.peril_cd = c.peril_cd
         AND c.line_cd = 'EN')

     LOOP

       v_en_quote_peril_seici.peril     := f.peril_name;
       v_en_quote_peril_seici.peril1    := f.peril_lname;
       v_en_quote_peril_seici.tsi       := f.tsi_amt;
       v_en_quote_peril_seici.dash      := f.short_name;

       PIPE ROW (v_en_quote_peril_seici);

     END LOOP;

     RETURN;

 END;

  --TO GET TAXES
  FUNCTION get_en_quote_tax (p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN en_quote_tax_tab PIPELINED IS

    v_en_quote_tax      en_quote_details_type;

  BEGIN

   FOR K IN (SELECT b.tax_cd, E.tax_desc, TO_CHAR(SUM(DISTINCT b.tax_amt * A.currency_rt), '999,999,999,999.99') tax_amt
        FROM gipi_quote_invoice A,
             gipi_quote_invtax b,
             gipi_quote_item c,
             gipi_quote d,
             giis_tax_charges E
       WHERE c.currency_cd = A.currency_cd
         AND d.quote_id = p_quote_id
         AND A.quote_inv_no = b.quote_inv_no
         AND A.quote_id = c.quote_id
         AND A.quote_id = d.quote_id
         AND b.iss_cd = A.iss_cd
         AND b.iss_cd = E.iss_cd
         AND b.line_cd = E.line_cd
         AND b.tax_cd = E.tax_cd
         AND E.line_cd = 'EN'
    GROUP BY b.tax_cd, E.tax_desc)

    LOOP
      v_en_quote_tax.tax_cd  := K.tax_cd;
      v_en_quote_tax.taxes   := K.tax_desc;
      v_en_quote_tax.tax_amt := NVL(K.tax_amt,0);
      PIPE ROW (v_en_quote_tax);
    END LOOP;

      RETURN;

  END;

  --TO GET DEDUCTIBLES
  FUNCTION get_en_quote_deductible (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_subline_cd GIPI_QUOTE.subline_cd%TYPE)
  RETURN en_quote_deductible_tab PIPELINED IS

    v_en_quote_deductible   en_quote_details_type;

  BEGIN

    FOR P IN (SELECT b.deductible_title ded_title,
                 A.deductible_text,
              A.deductible_amt ded_amt,
              A.deductible_rt ded_rate
         FROM gipi_quote_deductibles A,
             giis_deductible_desc b
         WHERE quote_id = p_quote_id
          AND line_cd = 'EN'
          AND subline_cd = p_subline_cd
          AND A.ded_deductible_cd = b.deductible_cd)

   LOOP
     v_en_quote_deductible.ded_title := P.ded_title;
        v_en_quote_deductible.ded_rt    := P.ded_rate;
     v_en_quote_deductible.ded_amt   := TO_CHAR(P.ded_amt, '999,999,999.99');
     --v_en_quote_deductible.ded_txt   := p.deductible_text;

     IF P.deductible_text IS NULL THEN
       v_en_quote_deductible.ded_txt := ' ';
     ELSE
       v_en_quote_deductible.ded_txt := ' - '||P.deductible_text;
     END IF;

     IF v_en_quote_deductible.ded_rt IS NULL THEN
       v_en_quote_deductible.deduct := 'PHP  ' || (v_en_quote_deductible.ded_amt);
     ELSE
       v_en_quote_deductible.deduct := (v_en_quote_deductible.ded_rt||'%');
     END IF;

     PIPE ROW (v_en_quote_deductible);

   END LOOP;

     RETURN;

  END;

  --TO GET WARRANTY TITLE
  FUNCTION get_en_quote_warranty (p_quote_id gipi_quote.quote_id%TYPE)
     RETURN en_quote_warranty_tab PIPELINED
  IS
     v_en_quote_warranty   en_quote_details_type;
  BEGIN
     FOR warr IN (SELECT   A.wc_title, A.print_sw, a.wc_cd
                      FROM gipi_quote_wc A,
                           giis_warrcla b             ---5.13.11--added giis_warrcla---
                     WHERE quote_id = p_quote_id         --linked gipi_quote_wc--
                       AND A.line_cd = b.line_cd           --to  giis_warrcla--
                       AND b.main_wc_cd = A.wc_cd            --added by gino--
                  ORDER BY print_seq_no)
     LOOP
        v_en_quote_warranty.warranty := warr.wc_title;
        v_en_quote_warranty.warranty_cd := warr.wc_cd;
     --v_en_quote_warranty.print_sw := warr.print_sw;
        PIPE ROW (v_en_quote_warranty);--gino
     END LOOP;

     --PIPE ROW (v_en_quote_warranty);--gino quoted out moved above
     RETURN;
  END;

  --TO GET WARRANTY TEXT
  FUNCTION get_en_quote_warranty_text (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_warranty GIPI_QUOTE_WC.wc_title%TYPE)
  RETURN en_quote_warranty_text_tab PIPELINED IS

    v_en       en_quote_details_type;

  BEGIN

    FOR warr1 IN (SELECT A.wc_text01 wc_text1a,
                   A.wc_text02 wc_text2a,
                   A.wc_text03 wc_text3a,
                   A.wc_text04 wc_text4a,
                   A.wc_text05 wc_text5a,
                   A.wc_text06 wc_text6a,
                   A.wc_text07 wc_text7a,
                   A.wc_text08 wc_text8a,
                   A.wc_text09 wc_text9a,
                   A.wc_text10 wc_text10a,
                   A.wc_text11 wc_text11a,
                   A.wc_text12 wc_text12a,
                   A.wc_text13 wc_text13a,
                   A.wc_text14 wc_text14a,
                   A.wc_text15 wc_text15a,
                   A.wc_text16 wc_text16a,
                   A.wc_text17 wc_text17a,
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
                   A.print_sw,
                   b.change_tag
                   --b.wc_title
              FROM giis_warrcla A,
                   gipi_quote_wc b
             WHERE b.quote_id   = p_quote_id
               AND A.line_cd    = 'EN'
               AND A.line_cd    = b.line_cd
               AND A.main_wc_cd = b.wc_cd
               AND b.print_sw   = 'Y'
               AND b.wc_title   = p_warranty
          ORDER BY b.print_seq_no)
    LOOP

      IF warr1.change_tag   = 'N' THEN
        v_en.warranty_text := warr1.wc_text1a ||
                              warr1.wc_text2a ||
                              warr1.wc_text3a ||
                              warr1.wc_text4a ||
                              warr1.wc_text5a ||
                              warr1.wc_text6a ||
                              warr1.wc_text7a ||
                              warr1.wc_text8a ||
                              warr1.wc_text9a ||
                              warr1.wc_text10a ||
                              warr1.wc_text11a ||
                              warr1.wc_text12a ||
                              warr1.wc_text13a ||
                              warr1.wc_text14a ||
                              warr1.wc_text15a ||
                              warr1.wc_text16a ||
                              warr1.wc_text17a;
      ELSE
        v_en.warranty_text := warr1.wc_text1 ||
                              warr1.wc_text2 ||
                              warr1.wc_text3 ||
                              warr1.wc_text4 ||
                              warr1.wc_text5 ||
                              warr1.wc_text6 ||
                              warr1.wc_text7 ||
                              warr1.wc_text8 ||
                              warr1.wc_text9 ||
                              warr1.wc_text10 ||
                              warr1.wc_text11 ||
                              warr1.wc_text12 ||
                              warr1.wc_text13 ||
                              warr1.wc_text14 ||
                              warr1.wc_text15 ||
                              warr1.wc_text16 ||
                              warr1.wc_text17;
      END IF;

    END LOOP;

      PIPE ROW(v_en);
      RETURN;
  END;

END QUOTE_REPORTS_EN_PKG;
/



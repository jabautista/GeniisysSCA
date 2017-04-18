CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_MC_PKG AS

  FUNCTION get_mc_quote(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                             p_attn_name        VARCHAR2,
                        p_attn_position    VARCHAR2,
                        p_signatory        VARCHAR2,
                        p_designation    VARCHAR2) 
    RETURN quote_mc_tab PIPELINED IS
    
    v_quote                         quote_mc_type;
    v_title                          varchar2(30)            := ' ';
    v_end_remarks                  varchar2(25)            := ' ';
    v_tot_prem_amt                  GIPI_QUOTE_ITMPERIL.PREM_AMT%TYPE;
    v_tot_tax_amt                  GIPI_INV_TAX.TAX_AMT%TYPE;
    v_tot_tsi_seici                  GIPI_QUOTE_ITMPERIL.TSI_AMT%TYPE;
    v_tot_prem_seici              GIPI_QUOTE_ITMPERIL.PREM_AMT%TYPE;
    
  BEGIN
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                     A.HEADER, A.footer, A.line_cd, A.iss_cd,
                     TO_CHAR(A.accept_dt, 'fmMonth DD, YYYY') accept_date,
                      TO_CHAR(A.incept_date,'fmMonth DD, YYYY') incept_date, 
                      TO_CHAR(A.expiry_date,'fmMonth DD, YYYY') expiry_date,
                     A.incept_tag, 
                     A.expiry_tag,
                     A.remarks, A.subline_cd
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_quote.assd_name          := A.assd_name;
      v_quote.assd_add1        := A.address1;
      v_quote.assd_add2        := A.address2;
      v_quote.assd_add3        := A.address3;
      v_quote.incept        := A.incept_date;
      v_quote.expiry        := A.expiry_date;
      v_quote.HEADER         := A.HEADER; 
      v_quote.footer        := A.footer;
      v_quote.today           := TO_CHAR(SYSDATE,'fmMonth DD, YYYY');
      v_quote.line_cd        := A.line_cd;
      v_quote.iss_cd        := A.iss_cd;
      v_quote.accept_date    := A.accept_date;
      v_quote.incept_tag    := A.incept_tag;
      v_quote.expiry_tag    := A.expiry_tag;
      v_quote.remarks        := A.remarks;
      
      --retrieves the subline_name
      BEGIN
        SELECT subline_name
          INTO v_quote.subline_name
          FROM giis_subline
         WHERE subline_cd = A.subline_cd
           AND line_cd = A.line_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      --retrieves the quote number
      FOR o IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                  FROM gipi_quote
                    WHERE quote_id = p_quote_id)
      LOOP
          v_quote.quote_num := o.quote_no;
      END LOOP;
      
      --retrieves the deductibles amt
      FOR f IN (SELECT SUM(deductible_amt) ded_amt
                  FROM gipi_quote_deductibles
                 WHERE quote_id = p_quote_id)
      LOOP
        v_quote.deductible := f.ded_amt;
      END LOOP;
    
      --total premium amount 
      BEGIN 
        SELECT SUM(A.prem_amt) prem_amt
          INTO v_tot_prem_amt
            FROM giis_peril b,
                 gipi_quote_itmperil A,
                  gipi_quote c,
                  gipi_quote_item d      
          WHERE A.peril_cd = b.peril_cd
            AND A.quote_id = c.quote_id
              AND A.quote_id = p_quote_id
              AND b.line_cd  = c.line_cd
              AND A.item_no = d.item_no
              AND A.quote_id = d.quote_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      --total taxes 
      BEGIN 
        SELECT SUM(DISTINCT b.tax_amt * A.currency_rt) tax
          INTO v_tot_tax_amt
          FROM gipi_quote_invoice A,
               gipi_quote_invtax b,
               gipi_quote_item c,
               gipi_quote d
         WHERE c.currency_cd = A.currency_cd
           AND d.quote_id = p_quote_id 
           AND A.quote_inv_no = b.quote_inv_no 
           AND d.quote_id = c.quote_id 
           AND A.quote_id = d.quote_id 
           AND b.iss_cd = A.iss_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      --for SEICI only
      BEGIN
        SELECT SUM(nvl(A.tsi_amt, 0)) tsi_total, SUM(nvl(A.prem_amt, 0)) prem_total
          INTO v_tot_tsi_seici, v_tot_prem_seici
          FROM gipi_quote_itmperil A, giis_peril b
         WHERE A.quote_id = p_quote_id
           AND A.peril_cd = b.peril_cd
           AND b.line_cd = 'MC';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      BEGIN
        SELECT DISTINCT SUM(nvl(A.tax_amt, 0))+nvl(prem_amt, 0) net_due
          INTO v_quote.net_due_seici
          FROM gipi_quote_invtax A, gipi_quote_invoice b
         WHERE 1=1
           AND b.quote_id = p_quote_id
           AND A.quote_inv_no = b.quote_inv_no
           AND A.iss_cd = b.iss_cd
         GROUP BY prem_amt;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
		WHEN TOO_MANY_ROWS THEN NULL;
      END;
      
      FOR cur IN (SELECT INITCAP(b.short_name) short_name 
                    INTO v_quote.currency
                    FROM gipi_quote_invoice A, 
                         giis_currency b
                   WHERE 1=1
                     AND A.currency_cd = b.main_currency_cd
                        AND A.quote_id = p_quote_id)
      LOOP
        v_quote.currency := cur.short_name;
      END LOOP;
      
      BEGIN
        SELECT DISTINCT E.short_name
          INTO v_quote.short_name
          FROM gipi_quote_itmperil A,
                gipi_quote_item d,
                  giis_currency E      
         WHERE d.currency_cd = E.main_currency_cd
           AND A.item_no = d.item_no
              AND A.quote_id = d.quote_id
              AND A.quote_id = p_quote_id
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_quote.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      v_quote.prem_amt              := NVL(v_tot_prem_amt,0);
      v_quote.tax_amt              := NVL(v_tot_tax_amt, 0);
      v_quote.tot_prem              := NVL(v_tot_prem_amt, 0);-- + NVL(v_tot_tax_amt, 0);
      v_quote.attn_name          := INITCAP(p_attn_name);
      v_quote.attn_position      := INITCAP(p_attn_position);
      v_quote.signatory          := INITCAP(p_signatory);
      v_quote.designation          := INITCAP(p_designation);
      v_quote.tsi_amt_seici         := NVL(v_tot_tsi_seici, 0);
      v_quote.prem_amt_seici     := NVL(v_tot_prem_seici, 0);
    
      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_mc_quote;
  
  FUNCTION get_mc_quote_item(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_item_tab PIPELINED IS
    v_item quote_mc_item_type;
    v_peril_exists VARCHAR2(1) := 'N';
  BEGIN
    FOR i IN (SELECT A.item_title item_title, A.item_no, A.coverage_cd, ROWNUM
                FROM gipi_quote_item A,
                     giis_currency b
               WHERE quote_id = p_quote_id
                 AND A.currency_cd = b.main_currency_cd)
    LOOP
      v_item.item_title := i.item_title;
      v_item.item_no     := i.item_no;
      v_item.row_num     := i.ROWNUM;
      
      BEGIN
        SELECT A.plate_no, A.serial_no, A.motor_no, A.color
          INTO v_item.plate_no, v_item.serial_no, v_item.motor_no, v_item.color           
          FROM gipi_quote_item_mc A,
               gipi_quote_item b
         WHERE A.quote_id = p_quote_id
           AND A.quote_id = b.quote_id
           AND A.item_no = b.item_no
           AND b.item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          v_item.plate_no := NULL;
          v_item.serial_no:= NULL; 
          v_item.motor_no := NULL;
          v_item.color       := NULL;
      END;
      
      BEGIN
        SELECT DISTINCT NVL(model_year||' '||make,item_title)
          INTO v_item.item_title_make
            FROM GIPI_QUOTE_ITEM_MC A,
                    gipi_quote_item b
          WHERE A.item_no = b.item_no
              AND A.quote_id = b.quote_id
              AND b.quote_id = p_quote_id
           AND A.item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      BEGIN
        SELECT /*model_year||' '||car_company||' '||make*/ A.make, b.car_company, A.model_year
          INTO v_item.make, v_item.car_company, v_item.model_year
          FROM gipi_quote_item_mc A, giis_mc_car_company b
         WHERE A.car_company_cd = b.car_company_cd
           AND quote_id = p_quote_id
           AND item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      BEGIN
        SELECT coverage_desc
          INTO v_item.coverage_desc
          FROM giis_coverage
         WHERE coverage_cd = i.coverage_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      BEGIN
        SELECT c.motor_type_desc
          INTO v_item.motor_type_desc
          FROM gipi_quote_item_mc b, giis_motortype c
         WHERE 1=1
           AND b.subline_cd = c.subline_cd
           AND b.mot_type = c.type_cd
           AND b.quote_id = p_quote_id
           AND item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      BEGIN
        SELECT DISTINCT subline_type_desc
          INTO v_item.subline_type_desc
           FROM gipi_quote_item_mc A, giis_mc_subline_type b, gipi_quote c
         WHERE A.subline_type_cd = b.subline_type_cd
           AND A.quote_id = c.quote_id
           AND b.subline_cd = c.subline_cd
           AND A.quote_id = p_quote_id
           AND item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
      /*BEGIN
        SELECT NVL(A.deductible_amt, 0), NVL(a1.towing, 0),  nvl(A.deductible_amt, 0) + nvl(a1.towing, 0)
          INTO v_item.ded_amt, v_item.towing, v_item.repair_limit
          FROM gipi_quote_deductibles A, gipi_quote_item_mc a1, gipi_quote_item b, gipi_quote c 
         WHERE A.quote_id = p_quote_id
           AND A.item_no = b.item_no
           AND A.item_no = i.item_no
           AND A.quote_id = b.quote_id
           AND b.quote_id = c.quote_id
           AND A.quote_id = a1.quote_id 
           AND A.item_no = a1.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          NULL;
      END;*/ -- replace by: Nica 10.18.2011
      
      FOR c IN (SELECT NVL(A.deductible_amt, 0) ded_amt, NVL(a1.towing, 0) towing,  
                (NVL(A.deductible_amt, 0) + NVL(a1.towing, 0)) repair_limit
                    FROM gipi_quote_deductibles A, gipi_quote_item_mc a1, gipi_quote_item b, gipi_quote c 
                WHERE A.quote_id = p_quote_id
                AND A.item_no = b.item_no
                AND A.item_no = i.item_no
                AND A.quote_id = b.quote_id
                AND b.quote_id = c.quote_id
                AND A.quote_id = a1.quote_id 
                AND A.item_no = a1.item_no)
      LOOP
        v_item.ded_amt      := c.ded_amt;
        v_item.towing       := c.towing; 
        v_item.repair_limit := c.repair_limit;
      END LOOP;
      
      
      --to check if peril exists for an item
      BEGIN
        SELECT DISTINCT 'Y'
          INTO v_item.itemperil_exists
          FROM gipi_quote_itmperil
         WHERE quote_id = p_quote_id
           AND item_no = i.item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          v_item.itemperil_exists := 'N';
      END;
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
  END get_mc_quote_item;
  
  FUNCTION get_mc_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED IS
    v_itmperl quote_mc_itemperil_type;
  BEGIN
    FOR i IN (SELECT A.item_no, 
                       b.peril_name  peril_name, 
                     b.peril_lname peril_lname,
                     SUM(A.prem_amt * d.currency_rate) prem_amt,
                     SUM(A.tsi_amt * d.currency_rate) tsi_amt
                FROM giis_peril b,
                     gipi_quote_itmperil A,
                        gipi_quote c,
                        gipi_quote_item d
               WHERE A.peril_cd = b.peril_cd
                 AND A.quote_id = c.quote_id
                    AND A.quote_id = P_QUOTE_ID
                    AND b.line_cd  = c.line_cd
                    AND A.item_no = d.item_no
                    AND A.quote_id = d.quote_id
                GROUP BY b.peril_name, b.peril_lname, A.item_no
                ORDER BY b.peril_name)
    LOOP
      v_itmperl.item_no                  := i.item_no;
      v_itmperl.peril_name               := i.peril_name;
      v_itmperl.peril_lname              := i.peril_lname;
      v_itmperl.prem_amt                 := i.prem_amt;
      v_itmperl.tsi_amt                  := i.tsi_amt;
      PIPE ROW(v_itmperl);
    END LOOP;
    RETURN; 
  END get_mc_quote_itemperil;
  
  FUNCTION get_mc_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                       p_item_no            GIPI_QUOTE_ITMPERIL.item_no%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED IS
    v_itmperl quote_mc_itemperil_type;
  BEGIN
    FOR i IN (SELECT A.item_no, 
                       b.peril_name  peril_name, 
                     b.peril_lname peril_lname,
                     E.short_name,
                     SUM(A.prem_amt * d.currency_rate) prem_amt,
                     SUM(A.tsi_amt * d.currency_rate) tsi_amt
                FROM giis_peril b,
                     gipi_quote_itmperil A,
                        gipi_quote c,
                        gipi_quote_item d,
                     giis_currency E
               WHERE A.peril_cd = b.peril_cd
                 AND A.quote_id = c.quote_id
                    AND A.quote_id = P_QUOTE_ID
                    AND b.line_cd  = c.line_cd
                    AND A.item_no = d.item_no
                 AND A.item_no = NVL(p_item_no, A.item_no)
                    AND A.quote_id = d.quote_id
                 AND d.currency_cd = E.main_currency_cd
                GROUP BY b.peril_name, b.peril_lname, A.item_no, E.short_name
                ORDER BY b.peril_name)
    LOOP
      v_itmperl.item_no                 := i.item_no;
      v_itmperl.peril_name             := i.peril_name;
      v_itmperl.peril_lname             := i.peril_lname;
      v_itmperl.prem_amt             := i.prem_amt;
      v_itmperl.tsi_amt                  := i.tsi_amt;
      v_itmperl.short_name             := i.short_name;
      PIPE ROW(v_itmperl);
    END LOOP;
    RETURN; 
  END get_mc_quote_itemperil;
  
  FUNCTION get_mc_quote_itemperil_seici(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED IS
    v_itmperl quote_mc_itemperil_type;
  BEGIN
    FOR i IN (SELECT b.peril_name, nvl(A.tsi_amt,0) tsi_amt, nvl(A.prem_amt,0) prem_amt
                FROM gipi_quote_itmperil A, giis_peril b
               WHERE 1=1
                 AND A.quote_id = p_quote_id
                 AND A.peril_cd = b.peril_cd
                 AND b.line_cd  = 'MC'
               ORDER BY SEQUENCE)
    LOOP
      v_itmperl.peril_name          := i.peril_name;
      v_itmperl.tsi_amt          := i.tsi_amt;
      v_itmperl.prem_amt          := i.prem_amt;
      PIPE ROW(v_itmperl);
    END LOOP;
    RETURN;
  END get_mc_quote_itemperil_seici;
  
  FUNCTION get_quote_wc(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_wc_tab PIPELINED IS
    v_wc   quote_wc_type;
  BEGIN
    FOR i IN (SELECT wc_title, print_sw, ROWNUM
                FROM gipi_quote_wc
               WHERE quote_id = p_quote_id
               ORDER BY    print_seq_no)
    LOOP
      IF i.print_sw = 'Y' THEN
        v_wc.wc_title := i.wc_title;
        v_wc.row_num  := i.ROWNUM;
        FOR j IN (SELECT A.wc_text01 wc_text1a,
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
                         b.print_sw,
                         b.change_tag
                    FROM giis_warrcla A,
                            gipi_quote_wc b
                   WHERE b.quote_id = p_quote_id
                     AND A.line_cd = 'MC'
                     AND A.line_cd = b.line_cd
                     AND A.main_wc_cd = b.wc_cd
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
      END IF;
      PIPE ROW(v_wc);
    END LOOP;
    RETURN;
  END get_quote_wc;
  
  FUNCTION get_mc_quote_invtax(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_invtax_tab PIPELINED IS
    v_tax  quote_invtax_type;
  BEGIN
    FOR i IN (SELECT b.tax_cd, E.tax_desc, SUM(DISTINCT b.tax_amt) tax_amt
                FROM gipi_quote_invoice A,
                     gipi_quote_invtax b,
                        gipi_quote_item c,
                        gipi_quote d,
                        giis_tax_charges E
                WHERE c.currency_cd = A.currency_cd
                 AND d.quote_id = P_QUOTE_ID
                    AND A.quote_inv_no = b.quote_inv_no
                    AND A.quote_id = c.quote_id
                    AND A.quote_id = d.quote_id
                    AND b.iss_cd = A.iss_cd
                    AND b.iss_cd = E.iss_cd
                    AND b.line_cd = E.line_cd
                    AND b.tax_cd = E.tax_cd
                    AND E.line_cd = 'MC'
               GROUP BY  b.tax_cd, E.tax_desc)
    LOOP
      v_tax.tax_cd      := i.tax_cd;
      v_tax.tax_desc := i.tax_desc;
      v_tax.tax_amt  := i.tax_amt;
      PIPE ROW(v_tax);
    END LOOP;
    RETURN;
  END get_mc_quote_invtax;
  
  FUNCTION get_mc_quote_invtax_seici(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                     p_iss_cd        GIPI_QUOTE.iss_cd%TYPE)
    RETURN quote_invtax_tab PIPELINED IS
    v_tax  quote_invtax_type;
  BEGIN
    FOR i IN (SELECT DISTINCT nvl(A.tax_amt, 0) tax_amt, c.tax_desc,c.tax_cd
                FROM gipi_quote_invtax A, gipi_quote_invoice b, giis_tax_charges c
               WHERE 1=1
                 AND b.quote_id = p_quote_id
                 AND A.quote_inv_no = b.quote_inv_no
                 AND A.tax_cd = c.tax_cd
                 AND c.iss_cd = p_iss_cd
                 AND c.line_cd = 'MC'
                 AND A.iss_cd = b.iss_cd
                 AND A.line_cd = c.line_cd
               ORDER BY  c.tax_cd)
    LOOP
      v_tax.tax_cd      := i.tax_cd;
      v_tax.tax_desc := i.tax_desc;
      v_tax.tax_amt  := i.tax_amt;
      PIPE ROW(v_tax);
    END LOOP;
    RETURN;
  END get_mc_quote_invtax_seici;
  
  FUNCTION get_mc_quote_deductibles(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_deductibles_tab PIPELINED IS
    v_ded  quote_deductibles_type;
    v_count number:=0;
  BEGIN
    FOR i IN (SELECT deductible_text, 
                     deductible_amt
                FROM gipi_quote_deductibles
               WHERE quote_id = p_quote_id)
    LOOP
      v_count:=v_count+1;
      v_ded.deductible_text      := i.deductible_text;
      v_ded.deductible_amt      := i.deductible_amt;
    END LOOP;
      IF v_count=0 THEN
        v_ded.deductible_text      := '_______________';
        v_ded.deductible_amt      := 0;      
      END IF;
      PIPE ROW(v_ded);
    RETURN;
  END get_mc_quote_deductibles;
  
  FUNCTION get_mc_quote_signatory(p_line_cd VARCHAR2, p_iss_cd VARCHAR2)------------------------------------------gino 5.9.11
  RETURN mc_quote_signatory_tab PIPELINED IS
      v_sig    mc_quote_signatory_type;
      v_count number:=0;
  BEGIN
  
     FOR sig IN (SELECT SIGNATORY,DESIGNATION
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE 1=1
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd
                       AND current_signatory_sw = 'Y'     
                       AND A.signatory_id = b.signatory_id 
                       AND A.line_cd = p_line_cd
                       )
      LOOP
          v_count:=v_count+1;
          v_sig.sig_name := sig.signatory;
          v_sig.sig_des := sig.designation; 
             
      END LOOP;
      IF v_count=0 THEN
          v_sig.sig_name := '____________';
          v_sig.sig_des :=  '____________';
      END IF;  
    PIPE ROW(v_sig);
    RETURN;    
  END;--------------------------------------------------------------end gino 5.9.11
 
  FUNCTION get_mc_quote_itemperil_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                        p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_itmperil_ucpb_tab PIPELINED IS
    v_itmperl        quote_mc_itmperil_ucpb_type;
    v_kalakbay       giis_parameters.param_value_n%TYPE;
    v_auto_pa        giis_parameters.param_value_n%TYPE;
    v_o_tax_amt      gipi_quote_invtax.tax_amt%TYPE := 0;
    v_opt1_tax_amt   gipi_quote_invtax.tax_amt%TYPE := 0; 
	v_the_same  VARCHAR2(1); --added by steven 1.24.2013
	v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
  BEGIN
    FOR A IN (SELECT A.param_value_n kalakbay_peril,
                     b.param_value_n auto_pa_peril
                FROM GIIS_PARAMETERS A,
                     GIIS_PARAMETERS b
               WHERE A.param_name = 'KALAKBAY_PERIL_CD'
                 AND b.param_name = 'AUTO_PA_PERIL_CD')
    LOOP     
      v_kalakbay := A.kalakbay_peril;
      v_auto_pa  := A.auto_pa_peril;                
    END LOOP;
	
	 --added by steven 1.24.2013; to check if it has different currency 
	 FOR j IN (SELECT c.short_name 
                 FROM gipi_quote_item A, giis_currency c
                WHERE A.quote_id = p_quote_id
                  AND A.currency_cd = c.main_currency_cd)
		 LOOP
		 	IF v_short_name_temp is NULL THEN
				v_short_name_temp := j.short_name;
				v_the_same := 'Y';
			ELSE
				IF v_short_name_temp = j.short_name THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					v_short_name_temp := 'PHP';
					v_the_same := 'N';
					EXIT;
				END IF;
			END IF;
	 END LOOP;
  
    FOR i IN (SELECT c.currency_rate,b.peril_lname, nvl(A.tsi_amt,0) tsi_amt, nvl(A.prem_amt,0) prem_amt, --added by steven 1.24.2013; currency_rate,
                     decode(A.peril_cd, v_auto_pa, 0, A.prem_amt) opt1_prem,    
                     d.short_name  
                FROM gipi_quote_itmperil A, 
                     giis_peril b,
                     gipi_quote_item c,
                     giis_currency d
               WHERE 1=1
                 AND c.quote_id = p_quote_id
                 AND A.peril_cd = b.peril_cd
                 AND A.line_cd  = b.line_cd
                 AND A.quote_id = c.quote_id
                 AND c.currency_cd = d.main_currency_cd
                 AND A.item_no = c.item_no
                 AND c.item_no = p_item_no
                 AND A.peril_cd NOT IN (v_kalakbay)
               ORDER BY SEQUENCE)
    LOOP
      v_o_tax_amt                   := 0;
      v_opt1_tax_amt                := 0;
      v_itmperl.peril_name          := i.peril_lname;
      --v_itmperl.tsi_amt             := i.tsi_amt;
      --v_itmperl.prem_amt            := i.prem_amt;
      v_itmperl.short_name          := v_short_name_temp;
      --v_itmperl.opt1_prem           := i.opt1_prem;     
	  
	  IF v_the_same = 'N' THEN --added by steven 1.24.2013
	  	v_itmperl.tsi_amt             := i.tsi_amt * i.currency_rate;
		 v_itmperl.prem_amt            := i.prem_amt * i.currency_rate;
		 v_itmperl.opt1_prem           := i.opt1_prem * i.currency_rate;
	  ELSE
		v_itmperl.tsi_amt             := i.tsi_amt;
		 v_itmperl.prem_amt            := i.prem_amt;
		 v_itmperl.opt1_prem           := i.opt1_prem; 
	  END IF;
      PIPE ROW(v_itmperl);
    END LOOP;
    RETURN;
  END get_mc_quote_itemperil_ucpb;
 
  FUNCTION get_mc_quote_kalakbay_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                       p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_kalakbay_ucpb_tab PIPELINED IS
    v_itmperl     quote_mc_kalakbay_ucpb_type;
    v_kalakbay    giis_parameters.param_value_n%TYPE;
    
  BEGIN
    FOR A IN (SELECT A.param_value_n kalakbay_peril
                FROM GIIS_PARAMETERS A
               WHERE A.param_name = 'KALAKBAY_PERIL_CD')
    LOOP     
      v_kalakbay := A.kalakbay_peril;     
    END LOOP;
    
    FOR i IN (SELECT b.peril_lname, A.comp_rem
                FROM gipi_quote_itmperil A, 
                     giis_peril b
               WHERE 1=1
                 AND A.quote_id = p_quote_id
                 AND A.peril_cd = b.peril_cd
                 AND A.line_cd  = b.line_cd
                 AND A.item_no =  p_item_no
                 AND A.peril_cd IN (v_kalakbay))
    LOOP
      v_itmperl.peril_name        := i.peril_lname;
      v_itmperl.comp_rem          := i.comp_rem;
            
      PIPE ROW(v_itmperl);          
    END LOOP;
    
     
    RETURN;             

  END get_mc_quote_kalakbay_ucpb;
  
  FUNCTION get_mc_quote_autopa_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                     p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_autopa_ucpb_tab PIPELINED IS
    v_itmperl     quote_mc_autopa_ucpb_type;
    v_autopa      giis_parameters.param_value_n%TYPE;
   
    
  BEGIN
    FOR A IN (SELECT A.param_value_n autopa_peril
                FROM GIIS_PARAMETERS A
               WHERE A.param_name = 'AUTO_PA_PERIL_CD')
    LOOP     
      v_autopa := A.autopa_peril;     
    END LOOP;
    
    FOR i IN (SELECT b.peril_lname, to_char(decode(c.no_of_pass, NULL, A.tsi_amt, (A.tsi_amt/c.no_of_pass)),'999,999,999.99') tsi_per_pass,
                     to_char(decode(c.no_of_pass, NULL, '',(decode(c.no_of_pass, NULL, A.tsi_amt*.10, (A.tsi_amt/c.no_of_pass)) * .10)),'999,999.99') tsi_med_exp,
                     decode(no_of_pass, NULL,'____', no_of_pass) no_of_pass  
                FROM gipi_quote_itmperil A, 
                     giis_peril b,
                     gipi_quote_item_mc c
               WHERE 1=1
                 AND A.quote_id = c.quote_id(+)
                 AND A.item_no  = c.item_no(+)
                 AND A.quote_id = p_quote_id
                 AND A.peril_cd = b.peril_cd
                 AND A.line_cd  = b.line_cd
                 AND A.item_no =  p_item_no
                 AND A.peril_cd IN (v_autopa))
    LOOP
     
      v_itmperl.peril_name        := i.peril_lname;
      v_itmperl.tsi_per_pass      := i.tsi_per_pass;
      v_itmperl.tsi_med_exp       := i.tsi_med_exp;
      v_itmperl.no_of_pass        := i.no_of_pass; --* Added by Windell ON May 17, 2011 
                 
      PIPE ROW(v_itmperl); 
    END LOOP;
     
    RETURN;
  END get_mc_quote_autopa_ucpb;
  
  FUNCTION get_mc_invtax_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                               p_item_no         GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_invtax_ucpb_tab PIPELINED IS
    
    v_invtax         quote_mc_invtax_ucpb_type;
    v_kalakbay       giis_parameters.param_value_n%TYPE;
    v_auto_pa        giis_parameters.param_value_n%TYPE;
    v_tax_amt        gipi_quote_invtax.tax_amt%TYPE := 0;
    v_opt1_tax_amt   gipi_quote_invtax.tax_amt%TYPE := 0;
	v_the_same  	 VARCHAR2(1); --added by steven 1.24.2013
	v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
     
  BEGIN
    FOR A IN (SELECT A.param_value_n kalakbay_peril,
                     b.param_value_n auto_pa_peril
                FROM GIIS_PARAMETERS A,
                     GIIS_PARAMETERS b
               WHERE A.param_name = 'KALAKBAY_PERIL_CD'
                 AND b.param_name = 'AUTO_PA_PERIL_CD')
    LOOP     
      v_kalakbay := A.kalakbay_peril;
      v_auto_pa  := A.auto_pa_peril;                
    END LOOP;
	
	--added by steven 1.24.2013; to check if it has different currency 
	 FOR j IN (SELECT c.short_name 
                 FROM gipi_quote_item A, giis_currency c
                WHERE A.quote_id = p_quote_id
                  AND A.currency_cd = c.main_currency_cd)
		 LOOP
		 	IF v_short_name_temp is NULL THEN
				v_short_name_temp := j.short_name;
				v_the_same := 'Y';
			ELSE
				IF v_short_name_temp = j.short_name THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					v_short_name_temp := 'PHP';
					v_the_same := 'N';
					EXIT;
				END IF;
			END IF;
	 END LOOP;
  
  	--added by steven for the currency rate
	BEGIN
		SELECT currency_rate
		   INTO v_invtax.currency_rate
		   FROM gipi_quote_item
		   WHERE quote_id = p_quote_id
			 AND item_no = p_item_no;
		 EXCEPTION
		 	WHEN NO_DATA_FOUND THEN
				v_invtax.currency_rate := 1;
	END;
    FOR i IN (SELECT SUM(nvl(A.prem_amt,0)) prem_amt, (c.rate/100) rate ,
                     SUM(decode(A.peril_cd, 8, 0, A.prem_amt)) opt1_prem, C.TAX_CD    
                FROM gipi_quote_itmperil A, 
                     gipi_quote_invoice b,
                     gipi_quote_invtax c    
               WHERE 1=1
                 AND A.quote_id = p_quote_id
                 AND A.item_no = p_item_no
                 AND A.peril_cd NOT IN (v_kalakbay)
                 AND A.quote_id = b.quote_id
                 AND b.iss_cd = c.iss_cd
                 AND b.quote_inv_no = c.quote_inv_no       
               GROUP BY c.rate, C.TAX_CD)    
    LOOP
    IF I.TAX_CD = GIACP.N('DOC_STAMPS') AND GIISP.V('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN
    
      v_tax_amt        := v_tax_amt + (CEIL(I.PREM_AMT/4) * 0.5);
      v_opt1_tax_amt   := v_opt1_tax_amt + (CEIL(i.opt1_prem/4) * 0.5);   
    ELSE
      v_tax_amt        := v_tax_amt + (i.prem_amt * i.rate);
      v_opt1_tax_amt   := v_opt1_tax_amt + (i.opt1_prem * i.rate);  
    END IF;
      
    END LOOP;
	v_invtax.the_same := v_the_same;
	IF v_the_same = 'N' THEN
		v_invtax.tax_amt   := v_tax_amt * v_invtax.currency_rate;
      	v_invtax.opt1_tax  := v_opt1_tax_amt * v_invtax.currency_rate;
	ELSE
		v_invtax.tax_amt   := v_tax_amt;
      	v_invtax.opt1_tax  := v_opt1_tax_amt;
	END IF;
      PIPE ROW(v_invtax);
    RETURN;
  END get_mc_invtax_ucpb;

END QUOTE_REPORTS_MC_PKG;
/



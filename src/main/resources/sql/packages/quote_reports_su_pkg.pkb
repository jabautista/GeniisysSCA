CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_SU_PKG AS

  FUNCTION get_su_quote(p_quote_id      GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_su_tab PIPELINED
    IS
    v_quote     quote_su_type;
  BEGIN
    FOR i IN (SELECT A.assd_name assd_name,
                     A.address1 assd_add1,
                     A.address2 assd_add2,
                     A.address3 assd_add3,
                     NVL(A.HEADER, GIIS_DOCUMENT_PKG.get_doc_text('BOND_HEADER')) HEADER,
                     A.footer,
                     decode(A.incept_tag,'Y','TBA',TO_CHAR(A.incept_date, 'fmMonth DD, YYYY')) incept_dt,
                     decode(A.expiry_tag,'Y','TBA',TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY')) expiry_dt,
                     c.short_name,
                     A.tsi_amt,
                     A.prem_amt,
                     SUM(A.prem_amt) total_premium,
                     A.incept_tag,
                     A.expiry_tag, d.subline_name,
                     A.line_cd||'-'||A.subline_cd||'-'||A.iss_cd||'-'||A.quotation_yy||'-'||A.quotation_no||'-'||A.proposal_no quote_no,
                     accept_dt,--* Added by Windell; April 25, 2011; For UCPB
                     a.incept_date,
                     a.expiry_date,
                     e.tax_amt
                FROM gipi_quote A,
                     gipi_quote_item b,
                     giis_currency c,
                     giis_subline d,
                     gipi_quote_invoice e
               WHERE A.quote_id = b.quote_id(+)
                 AND A.quote_id = e.quote_id(+)
                 AND b.currency_cd = c.main_currency_cd(+)
                 AND A.quote_id = p_quote_id
                 AND d.line_cd = A.line_cd
                 AND d.subline_cd = A.subline_cd
               GROUP BY A.assd_name,A.address1,A.address2, A.address3,A.HEADER, A.footer,
                     decode(A.incept_tag,'Y','TBA',TO_CHAR(A.incept_date, 'fmMonth DD, YYYY')),
                     decode(A.expiry_tag,'Y','TBA',TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY')),
                     c.short_name, A.tsi_amt, A.prem_amt, A.incept_tag, A.expiry_tag, d.subline_name,
                     A.line_cd, A.subline_cd, A.iss_cd, A.quotation_yy, A.quotation_no, A.proposal_no,
                     accept_dt,--* Added by Windell; April 25, 2011; For UCPB
                     a.incept_date, a.expiry_date,e.tax_amt)
    LOOP
      v_quote.quote_no            :=i.quote_no;
      v_quote.assd_name           :=i.assd_name;
      v_quote.assd_add1           :=i.assd_add1;
      v_quote.assd_add2           :=i.assd_add2;
      v_quote.assd_add3           :=i.assd_add3;
      v_quote.expiry_dt           :=i.expiry_dt;
      v_quote.expiry_tag          :=i.expiry_tag;
      v_quote.footer              :=i.footer;
      v_quote.HEADER              :=i.HEADER;
      v_quote.incept_dt           :=i.incept_dt;
      v_quote.incept_tag          :=i.incept_tag;
      v_quote.prem_amt            :=i.prem_amt;
      v_quote.short_name          :=i.short_name;
      v_quote.subline_name        :=i.subline_name;
      v_quote.today               :=to_char(sysdate,'MM.DD.YY');
      v_quote.total_premium       :=i.total_premium;
      v_quote.tsi_amt             :=i.tsi_amt;
      v_quote.user_id             :=USER;
      v_quote.tsi_amt_str         :=NVL( TO_CHAR (i.tsi_amt, '9,999,999,999,999,990.90'), ' ');       --* Added by Windell; April 25, 2011; For UCPB
      v_quote.total_premium_str   :=NVL( TO_CHAR (i.total_premium, '9,999,999,999,999,990.90'), ' '); --* Added by Windell; April 25, 2011; For UCPB
      v_quote.accept_dt           :=TO_CHAR(i.accept_dt, 'fmMonth DD, YYYY'); --* Added by Windell; April 25, 2011; For UCPB
      v_quote.tax_amt              :=i.tax_amt;      
      v_quote.period              := GET_PERIOD_YEAR_MONTH(i.incept_date, i.expiry_date);
      --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_quote.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      --obligee
      BEGIN
        SELECT obligee_name,bond_dtl
          INTO v_quote.obligee_name, v_quote.bond_dtl
           FROM giis_obligee A,
                gipi_quote_bond_basic b
          WHERE b.quote_id = p_quote_id
            AND A.obligee_no = b.obligee_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_su_quote;
  
  FUNCTION get_su_quote_ucpb(p_quote_id      GIPI_QUOTE.quote_id%TYPE) --added by steven 01.25.2013 for UCPB
    RETURN quote_su_tab PIPELINED
    IS
    v_quote             quote_su_type;
    v_the_same           VARCHAR2(1); --added by steven 1.24.2013
    v_short_name_temp     VARCHAR2(10) := NULL; --added by steven 1.24.2013
    v_tsi_amt             gipi_quote_item.tsi_amt%TYPE := 0; --added by steven 1.24.2013
    v_prem_amt             gipi_quote_item.prem_amt%TYPE := 0; --added by steven 1.24.2013
    v_tax_amt             gipi_quote_invoice.tax_amt%TYPE := 0; --added by steven 1.24.2013
    
  BEGIN
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
    FOR i IN (SELECT A.assd_name assd_name,
                     A.address1 assd_add1,
                     A.address2 assd_add2,
                     A.address3 assd_add3,
                     NVL(A.HEADER, GIIS_DOCUMENT_PKG.get_doc_text('BOND_HEADER')) HEADER,
                     A.footer,
                     decode(A.incept_tag,'Y','TBA',TO_CHAR(A.incept_date, 'fmMonth DD, YYYY')) incept_dt,
                     decode(A.expiry_tag,'Y','TBA',TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY')) expiry_dt,
                     A.incept_tag,
                     A.expiry_tag, d.subline_name,
                     A.line_cd||'-'||A.subline_cd||'-'||A.iss_cd||'-'||A.quotation_yy||'-'||A.quotation_no||'-'||A.proposal_no quote_no,
                     accept_dt,
                     a.incept_date,
                     a.expiry_date
                FROM gipi_quote A,
                     giis_subline d
               WHERE A.quote_id = p_quote_id
                 AND d.subline_cd = A.subline_cd)
    LOOP
      v_quote.quote_no            :=i.quote_no;
      v_quote.assd_name           :=i.assd_name;
      v_quote.assd_add1           :=i.assd_add1;
      v_quote.assd_add2           :=i.assd_add2;
      v_quote.assd_add3           :=i.assd_add3;
      v_quote.expiry_dt           :=i.expiry_dt;
      v_quote.expiry_tag          :=i.expiry_tag;
      v_quote.footer              :=i.footer;
      v_quote.HEADER              :=i.HEADER;
      v_quote.incept_dt           :=i.incept_dt;
      v_quote.incept_tag          :=i.incept_tag;
      --v_quote.prem_amt            :=i.prem_amt;
      --v_quote.short_name          :=i.short_name;
      v_quote.subline_name        :=i.subline_name;
      v_quote.today               :=to_char(sysdate,'MM.DD.YY');
      --v_quote.total_premium       :=i.total_premium;
      --v_quote.tsi_amt             :=i.tsi_amt;
      v_quote.user_id             :=USER;
      v_quote.accept_dt           :=TO_CHAR(i.accept_dt, 'fmMonth DD, YYYY'); --* Added by Windell; April 25, 2011; For UCPB
     -- v_quote.tax_amt              :=i.tax_amt;      
      v_quote.period              := GET_PERIOD_YEAR_MONTH(i.incept_date, i.expiry_date);
      --tsi_amt and prem_amt
      FOR item IN (SELECT SUM(a.tsi_amt) tsi_amt,
                        SUM(a.prem_amt) prem_amt,
                        a.currency_rate
                    FROM gipi_quote_item a
                        WHERE a.quote_id = p_quote_id
                        GROUP BY a.currency_rate)
      LOOP
          IF v_the_same = 'N' THEN
            v_tsi_amt := v_tsi_amt + (item.tsi_amt * item.currency_rate);
            v_prem_amt := v_prem_amt + (item.prem_amt * item.currency_rate);
        ELSE
            v_tsi_amt := v_tsi_amt + item.tsi_amt;
            v_prem_amt := v_prem_amt + item.prem_amt;
        END IF;
      END LOOP;
      v_quote.prem_amt            := v_prem_amt;
      v_quote.short_name          := v_short_name_temp;
      v_quote.tsi_amt             := v_tsi_amt;
      
      --for tax_amt
      FOR tax IN (SELECT tax_amt,currency_rt
                     FROM gipi_quote_invoice
                          WHERE quote_id = p_quote_id)
      LOOP
          IF v_the_same = 'N' THEN
            v_tax_amt := v_tax_amt + (tax.tax_amt * tax.currency_rt);
        ELSE
            v_tax_amt := v_tax_amt + tax.tax_amt;
        END IF;
      END LOOP;
      v_quote.tax_amt := v_tax_amt;
      
      --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_quote.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      --obligee
      BEGIN
        SELECT obligee_name,bond_dtl
          INTO v_quote.obligee_name, v_quote.bond_dtl
           FROM giis_obligee A,
                gipi_quote_bond_basic b
          WHERE b.quote_id = p_quote_id
            AND A.obligee_no = b.obligee_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_su_quote_ucpb;
  
  FUNCTION get_su_quote_philfire(p_quote_id      GIPI_QUOTE.quote_id%TYPE) --added by gelo 02.07.2013 for PHILFIRE
    RETURN quote_su_tab_philfire PIPELINED
    IS
    v_quote             quote_su_type_philfire;
    v_the_same           VARCHAR2(1); 
    v_short_name_temp     VARCHAR2(10) := NULL; 
    v_tsi_amt             gipi_quote_item.tsi_amt%TYPE := 0; 
    v_prem_amt             gipi_quote_item.prem_amt%TYPE := 0; 
    v_tax_amt             gipi_quote_invoice.tax_amt%TYPE := 0; 
    
  BEGIN
      
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
                    v_short_name_temp := j.short_name;
                    v_the_same := 'N';
                    EXIT;
                END IF;
            END IF;
     END LOOP;
    FOR i IN (SELECT A.assd_name assd_name,
                     NVL(A.address1, ' ') assd_add1,
                     NVL(A.address2, ' ') assd_add2,
                     NVL(A.address3, ' ') assd_add3,
                     NVL(A.HEADER, GIIS_DOCUMENT_PKG.get_doc_text('BOND_HEADER')) HEADER,
                     A.footer,
                     decode(A.incept_tag,'Y','TBA',TO_CHAR(A.incept_date, 'fmMonth DD, YYYY')) incept_dt,
                     decode(A.expiry_tag,'Y','TBA',TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY')) expiry_dt,
                     A.incept_tag,
                     A.expiry_tag, d.subline_name,
                     get_quotation_no(a.quote_id) quote_no,
                     accept_dt,
                     a.incept_date,
                     a.expiry_date
                FROM gipi_quote A,
                     giis_subline d
               WHERE A.quote_id = p_quote_id
                 AND d.subline_cd = A.subline_cd)
    LOOP
      v_quote.quote_no            :=i.quote_no;
      v_quote.assd_name           :=i.assd_name;
      v_quote.assd_add1           :=i.assd_add1;
      v_quote.assd_add2           :=i.assd_add2;
      v_quote.assd_add3           :=i.assd_add3;
      v_quote.expiry_dt           :=i.expiry_dt;
      v_quote.expiry_tag          :=i.expiry_tag;
      v_quote.footer              :=i.footer;
      v_quote.HEADER              :=i.HEADER;
      v_quote.incept_dt           :=i.incept_dt;
      v_quote.incept_tag          :=i.incept_tag;
      v_quote.subline_name        :=i.subline_name;
      v_quote.today               :=to_char(sysdate,'fmMonth DD, YYYY');
      v_quote.user_id             :=USER;
      v_quote.accept_dt           :=TO_CHAR(i.accept_dt, 'fmMonth DD, YYYY'); 
      v_quote.period              := GET_PERIOD_YEAR_MONTH(i.incept_date, i.expiry_date);
      
      --tsi_amt and prem_amt
      FOR item IN (SELECT SUM(a.tsi_amt) tsi_amt,
                        SUM(a.prem_amt) prem_amt,
                        a.currency_rate
                    FROM gipi_quote_item a
                        WHERE a.quote_id = p_quote_id
                        GROUP BY a.currency_rate)
      LOOP
          IF v_the_same = 'N' THEN
            v_tsi_amt := v_tsi_amt + (item.tsi_amt);
            v_prem_amt := v_prem_amt + (item.prem_amt);
        ELSE
            v_tsi_amt := v_tsi_amt + item.tsi_amt;
            v_prem_amt := v_prem_amt + item.prem_amt;
        END IF;
      END LOOP;
      v_quote.prem_amt            := v_prem_amt;
      v_quote.short_name          := v_short_name_temp;
      v_quote.tsi_amt             := v_tsi_amt;
      
      --for tax_amt
      FOR tax IN (SELECT tax_amt,currency_rt
                     FROM gipi_quote_invoice
                          WHERE quote_id = p_quote_id)
      LOOP
          IF v_the_same = 'N' THEN
            v_tax_amt := v_tax_amt + (tax.tax_amt);
        ELSE
            v_tax_amt := v_tax_amt + tax.tax_amt;
        END IF;
      END LOOP;
      v_quote.tax_amt := v_tax_amt;
      
      --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_quote.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      --obligee
      BEGIN
        SELECT obligee_name,bond_dtl
          INTO v_quote.obligee_name, v_quote.bond_dtl
           FROM giis_obligee A,
                gipi_quote_bond_basic b
          WHERE b.quote_id = p_quote_id
            AND A.obligee_no = b.obligee_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

      PIPE ROW(v_quote);
    END LOOP;
    RETURN;
  END get_su_quote_philfire;
  
END QUOTE_REPORTS_SU_PKG;
/



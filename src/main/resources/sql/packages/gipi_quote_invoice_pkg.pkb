CREATE OR REPLACE PACKAGE BODY CPI.GIPI_QUOTE_INVOICE_PKG AS

    FUNCTION get_giimm002_invoice_dtls(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE,
        p_currency_cd       GIPI_QUOTE_INVOICE.currency_cd%TYPE
    )
    RETURN giimm002_invoice_tab PIPELINED AS
        v_invoice           giimm002_invoice_type;
        v_tax_amt           NUMBER(16, 2);
        v_line_cd           GIPI_QUOTE.line_cd%TYPE;
    BEGIN
        BEGIN
            SELECT line_cd
              INTO v_line_cd
              FROM GIPI_QUOTE
             WHERE quote_id = p_quote_id;
        END;

        FOR i IN(SELECT *
                   FROM GIPI_QUOTE_INVOICE a
                  WHERE quote_id = p_quote_id
                    AND currency_cd = p_currency_cd)
        LOOP
            v_invoice.quote_id := i.quote_id;
            v_invoice.iss_cd := i.iss_cd;
            v_invoice.quote_inv_no := i.quote_inv_no;
            v_invoice.currency_cd := i.currency_cd;
            v_invoice.currency_rt := i.currency_rt;
            v_invoice.prem_amt := i.prem_amt;

            BEGIN
                SELECT SUM(tax_amt)
                  INTO v_tax_amt
                  FROM GIPI_QUOTE_INVTAX
                 WHERE quote_inv_no = i.quote_inv_no
                   AND iss_cd = i.iss_cd
                   AND line_cd = v_line_cd;
            END;

            v_invoice.tax_amt := v_tax_amt;
            v_invoice.amount_due := i.prem_amt + v_tax_amt;

            IF i.intm_no IS NULL THEN
                v_invoice.intm_no := GIPI_QUOTE_INVOICE_PKG.get_default_intermediary(p_quote_id);
            ELSE
                v_invoice.intm_no := i.intm_no;
            END IF;

            BEGIN
                SELECT a.intm_name
                  INTO v_invoice.intm_name
                  FROM GIIS_INTERMEDIARY a
                 WHERE a.intm_no = v_invoice.intm_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_invoice.intm_name := NULL;
            END;

            BEGIN
                SELECT b.currency_desc
                  INTO v_invoice.currency_desc
                  FROM GIIS_CURRENCY b
                 WHERE b.main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_invoice.currency_desc := NULL;
            END;

            PIPE ROW(v_invoice);
        END LOOP;
    END;

    PROCEDURE update_gipi_quote_invoice_intm(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE,
        p_quote_inv_no      GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
        p_intm_no           GIPI_QUOTE_INVOICE.intm_no%TYPE
    )
    IS
    BEGIN
        UPDATE GIPI_QUOTE_INVOICE
           SET intm_no = p_intm_no
         WHERE quote_id = p_quote_id
           AND quote_inv_no = p_quote_inv_no;
    END;

    FUNCTION get_default_intermediary(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE
    )
    RETURN NUMBER
    IS
        v_intm_no           GIIS_ASSURED_INTM.intm_no%TYPE;
    BEGIN
        FOR a IN (SELECT line_cd, assd_no
                    FROM GIPI_QUOTE
                   WHERE quote_id = p_quote_id)
        LOOP
            FOR intm IN (SELECT intm_no
                           FROM GIIS_ASSURED_INTM
                          WHERE line_cd = a.line_cd
                            AND assd_no = a.assd_no)
            LOOP
                v_intm_no := intm.intm_no;
                EXIT;
            END LOOP;
        END LOOP;
        RETURN v_intm_no;
    END;

END GIPI_QUOTE_INVOICE_PKG;
/



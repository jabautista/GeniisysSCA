CREATE OR REPLACE PACKAGE CPI.GIPI_QUOTE_INVOICE_PKG AS

    TYPE gipi_quote_invoice_type IS RECORD(
        quote_id            GIPI_QUOTE_INVOICE.quote_id%TYPE,
        iss_cd              GIPI_QUOTE_INVOICE.iss_cd%TYPE,
        quote_inv_no        GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
        currency_cd         GIPI_QUOTE_INVOICE.currency_cd%TYPE,
        currenct_rt         GIPI_QUOTE_INVOICE.currency_rt%TYPE,
        prem_amt            GIPI_QUOTE_INVOICE.prem_amt%TYPE,
        tax_amt             GIPI_QUOTE_INVOICE.tax_amt%TYPE,
        intm_no             GIPI_QUOTE_INVOICE.intm_no%TYPE
    );
    TYPE gipi_quote_invoice_tab IS TABLE OF gipi_quote_invoice_type;
    
    TYPE giimm002_invoice_type IS RECORD(
        quote_id            GIPI_QUOTE_INVOICE.quote_id%TYPE,
        iss_cd              GIPI_QUOTE_INVOICE.iss_cd%TYPE,
        quote_inv_no        GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
        currency_cd         GIPI_QUOTE_INVOICE.currency_cd%TYPE,
        currency_rt         GIPI_QUOTE_INVOICE.currency_rt%TYPE,
        prem_amt            GIPI_QUOTE_INVOICE.prem_amt%TYPE,
        tax_amt             GIPI_QUOTE_INVOICE.tax_amt%TYPE,
        intm_no             GIPI_QUOTE_INVOICE.intm_no%TYPE,
        amount_due          NUMBER(16,2),
        currency_desc       GIIS_CURRENCY.currency_desc%TYPE,
        intm_name           GIIS_INTERMEDIARY.intm_name%TYPE
    );
    TYPE giimm002_invoice_tab IS TABLE OF giimm002_invoice_type;
    
    FUNCTION get_giimm002_invoice_dtls(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE,
        p_currency_cd       GIPI_QUOTE_INVOICE.currency_cd%TYPE
    )
    RETURN giimm002_invoice_tab PIPELINED;
    
    PROCEDURE update_gipi_quote_invoice_intm(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE,
        p_quote_inv_no      GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
        p_intm_no           GIPI_QUOTE_INVOICE.intm_no%TYPE
    );
    
    FUNCTION get_default_intermediary(
        p_quote_id          GIPI_QUOTE_INVOICE.quote_id%TYPE
    )
    RETURN NUMBER;
    
END GIPI_QUOTE_INVOICE_PKG;
/



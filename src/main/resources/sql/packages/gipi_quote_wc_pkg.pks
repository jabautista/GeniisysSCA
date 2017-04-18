CREATE OR REPLACE PACKAGE CPI.GIPI_QUOTE_WC_PKG AS

    TYPE gipi_quote_wc_type IS RECORD(
        quote_id            GIPI_QUOTE_WC.quote_id%TYPE,
        line_cd             GIPI_QUOTE_WC.line_cd%TYPE,
        wc_cd               GIPI_QUOTE_WC.wc_cd%TYPE,
        print_seq_no        GIPI_QUOTE_WC.print_seq_no%TYPE,
        wc_title            GIPI_QUOTE_WC.wc_title%TYPE,
        wc_text01           GIPI_QUOTE_WC.wc_text01%TYPE,
        wc_text02           GIPI_QUOTE_WC.wc_text02%TYPE,
        wc_text03           GIPI_QUOTE_WC.wc_text03%TYPE,
        wc_text04           GIPI_QUOTE_WC.wc_text04%TYPE,
        wc_text05           GIPI_QUOTE_WC.wc_text05%TYPE,
        wc_text06           GIPI_QUOTE_WC.wc_text06%TYPE,
        wc_text07           GIPI_QUOTE_WC.wc_text07%TYPE,
        wc_text08           GIPI_QUOTE_WC.wc_text08%TYPE,
        wc_text09           GIPI_QUOTE_WC.wc_text09%TYPE,
        wc_text10           GIPI_QUOTE_WC.wc_text10%TYPE,
        wc_text11           GIPI_QUOTE_WC.wc_text11%TYPE,
        wc_text12           GIPI_QUOTE_WC.wc_text12%TYPE,
        wc_text13           GIPI_QUOTE_WC.wc_text13%TYPE,
        wc_text14           GIPI_QUOTE_WC.wc_text14%TYPE,
        wc_text15           GIPI_QUOTE_WC.wc_text15%TYPE,
        wc_text16           GIPI_QUOTE_WC.wc_text16%TYPE,
        wc_text17           GIPI_QUOTE_WC.wc_text17%TYPE,
        wc_remarks          GIPI_QUOTE_WC.wc_remarks%TYPE,
        print_sw            GIPI_QUOTE_WC.print_sw%TYPE,
        change_tag          GIPI_QUOTE_WC.change_tag%TYPE,
        user_id             GIPI_QUOTE_WC.user_id%TYPE,
        last_update         GIPI_QUOTE_WC.last_update%TYPE,
        wc_title2           GIPI_QUOTE_WC.wc_title2%TYPE,
        swc_seq_no          GIPI_QUOTE_WC.swc_seq_no%TYPE
    );
    TYPE gipi_quote_wc_tab IS TABLE OF gipi_quote_wc_type;
    
    PROCEDURE set_giimm002_warranties(
        p_quote_id          GIPI_QUOTE_WC.quote_id%TYPE,
        p_line_cd           GIPI_QUOTE_WC.line_cd%TYPE,
        p_peril_cd          GIIS_PERIL.peril_cd%TYPE
    );
    
END GIPI_QUOTE_WC_PKG;
/



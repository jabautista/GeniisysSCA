CREATE OR REPLACE PACKAGE BODY CPI.GIPI_QUOTE_WC_PKG AS

    PROCEDURE set_giimm002_warranties(
        p_quote_id          GIPI_QUOTE_WC.quote_id%TYPE,
        p_line_cd           GIPI_QUOTE_WC.line_cd%TYPE,
        p_peril_cd          GIIS_PERIL.peril_cd%TYPE
    )
    IS
        v_print_seq_no      GIPI_QUOTE_WC.print_seq_no%TYPE;
    BEGIN
        FOR i IN(SELECT b.main_wc_cd, c.wc_title, c.print_sw, c.remarks,
                        c.wc_text01, c.wc_text02, c.wc_text03, c.wc_text04, c.wc_text05,
                        c.wc_text06, c.wc_text07, c.wc_text08, c.wc_text09, c.wc_text10,
                        c.wc_text11, c.wc_text12, c.wc_text13, c.wc_text14, c.wc_text15,
                        c.wc_text16, c.wc_text17
                   FROM GIIS_PERIL a,
                        GIIS_PERIL_CLAUSES b,
                        GIIS_WARRCLA c
                  WHERE a.peril_cd = b.peril_cd
                    AND a.line_cd = b.line_cd
                    AND a.line_cd = c.line_cd
                    AND b.main_wc_cd = c.main_wc_cd
                    AND a.line_cd = p_line_cd
                    AND a.peril_cd = p_peril_cd)
        LOOP
            BEGIN
                SELECT NVL(MAX(print_seq_no), 0) + 1
                  INTO v_print_seq_no
                  FROM GIPI_QUOTE_WC
                 WHERE quote_id = p_quote_id
                   AND line_cd = p_line_cd;
            END;

            INSERT INTO GIPI_QUOTE_WC(quote_id, line_cd, wc_cd, wc_title, print_seq_no, print_sw, wc_remarks)
--                                      wc_text01, wc_text02, wc_text03, wc_text04, wc_text05,
--                                      wc_text06, wc_text07, wc_text08, wc_text09, wc_text10,
--                                      wc_text11, wc_text12, wc_text13, wc_text14, wc_text15,
--                                      wc_text16, wc_text17)
                 VALUES(p_quote_id, p_line_cd, i.main_wc_cd, i.wc_title, v_print_seq_no, i.print_sw, i.remarks);
--                        i.wc_text01, i.wc_text02, i.wc_text03, i.wc_text04, i.wc_text05,
--                        i.wc_text06, i.wc_text07, i.wc_text08, i.wc_text09, i.wc_text10,
--                        i.wc_text11, i.wc_text12, i.wc_text13, i.wc_text14, i.wc_text15,
--                        i.wc_text16, i.wc_text17);
        END LOOP;
    END;

END GIPI_QUOTE_WC_PKG;
/



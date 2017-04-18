CREATE OR REPLACE PACKAGE BODY CPI.GIPI_QUOTE_INVTAX_PKG AS

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 7, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function returns details of invoice tax under a Package Quotation
*/

  FUNCTION get_gipi_quote_invtax(p_quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
                                 p_iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE)
  RETURN gipi_quote_invtax_tab PIPELINED

  AS

  v_quote_invtax            gipi_quote_invtax_type;

  BEGIN

    FOR i IN (SELECT a.line_cd, a.iss_cd, a.quote_inv_no, a.tax_cd,
                     a.tax_id, a.tax_amt, a.rate, a.fixed_tax_allocation,
                     a.item_grp, a.tax_allocation, b.tax_desc, b.primary_sw
              FROM GIPI_QUOTE_INVTAX a,
                   GIIS_TAX_CHARGES b
              WHERE a.tax_cd  = b.tax_cd
                AND a.line_cd = b.line_cd
                AND a.iss_cd  = b.iss_cd
                AND a.tax_id  = b.tax_id
                AND a.quote_inv_no = p_quote_inv_no
                AND a.iss_cd = p_iss_cd)

    LOOP
        v_quote_invtax.line_cd          := i.line_cd;
        v_quote_invtax.iss_cd           := i.iss_cd;
        v_quote_invtax.quote_inv_no     := i.quote_inv_no;
        v_quote_invtax.tax_cd           := i.tax_cd;
        v_quote_invtax.tax_id           := i.tax_id;
        v_quote_invtax.tax_amt          := i.tax_amt;
        v_quote_invtax.rate             := i.rate;
        v_quote_invtax.fixed_tax_alloc  := i.fixed_tax_allocation;
        v_quote_invtax.item_grp         := i.item_grp;
        v_quote_invtax.tax_allocation   := i.tax_allocation;
        v_quote_invtax.tax_desc         := i.tax_desc;
        v_quote_invtax.primary_sw       := i.primary_sw;

        PIPE ROW (v_quote_invtax);

    END LOOP;

  END get_gipi_quote_invtax;

  FUNCTION get_gipi_quote_invtax2(p_quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
                                  p_iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE,
                                  p_tax_amt                GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                  p_tax_desc               GIIS_TAX_CHARGES.tax_desc%TYPE)
    RETURN gipi_quote_invtax_tab2 PIPELINED AS
    v_quote_invtax            gipi_quote_invtax_type2;
  BEGIN

    FOR i IN (SELECT a.line_cd, a.iss_cd, a.quote_inv_no, a.tax_cd,
                     a.tax_id, a.tax_amt, a.rate, a.fixed_tax_allocation,
                     a.item_grp, a.tax_allocation, b.tax_desc, b.primary_sw,
                     b.peril_sw, b.no_rate_tag
              FROM GIPI_QUOTE_INVTAX a,
                   GIIS_TAX_CHARGES b
              WHERE a.tax_cd  = b.tax_cd
                AND a.line_cd = b.line_cd
                AND a.iss_cd  = b.iss_cd
                AND a.tax_id  = b.tax_id
                AND a.quote_inv_no = p_quote_inv_no
                AND a.iss_cd = p_iss_cd
                AND NVL(a.tax_amt, 0) = DECODE(a.tax_amt, NULL, 0, NVL(p_tax_amt, a.tax_amt)) -- marco - 08.31.2012
                AND UPPER(b.tax_desc) LIKE UPPER(NVL(p_tax_desc, b.tax_desc)))
    LOOP
        v_quote_invtax.line_cd          := i.line_cd;
        v_quote_invtax.iss_cd           := i.iss_cd;
        v_quote_invtax.quote_inv_no     := i.quote_inv_no;
        v_quote_invtax.tax_cd           := i.tax_cd;
        v_quote_invtax.tax_id           := i.tax_id;
        v_quote_invtax.tax_amt          := NVL(i.tax_amt, 0);
        v_quote_invtax.rate             := NVL(i.rate, 0);
        v_quote_invtax.fixed_tax_alloc  := i.fixed_tax_allocation;
        v_quote_invtax.item_grp         := i.item_grp;
        v_quote_invtax.tax_allocation   := i.tax_allocation;
        v_quote_invtax.tax_desc         := i.tax_desc;
        v_quote_invtax.primary_sw       := i.primary_sw;
        v_quote_invtax.peril_sw         := i.peril_sw;
        v_quote_invtax.no_rate_tag      := i.no_rate_tag;

        PIPE ROW (v_quote_invtax);
    END LOOP;

  END get_gipi_quote_invtax2;

/*
**  Created by    : Marco Paolo Rebong
**  Date Created  : May 18, 2012
**  Reference By  : GIIMM002
**  Description   : for saving tax charges (new tablegrid layout)
*/
  PROCEDURE set_gipi_quote_invtax(
    p_quote_id              GIPI_QUOTE.quote_id%TYPE,
    p_quote_inv_no          GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
    p_line_cd               GIPI_QUOTE_INVTAX.line_cd%TYPE,
    p_iss_cd                GIPI_QUOTE_INVTAX.iss_cd%TYPE,
    p_tax_cd                GIPI_QUOTE_INVTAX.tax_cd%TYPE,
    p_tax_amt               GIPI_QUOTE_INVTAX.tax_amt%TYPE,
    p_tax_id                GIPI_QUOTE_INVTAX.tax_id%TYPE,
    p_rate                  GIPI_QUOTE_INVTAX.rate%TYPE,
    p_item_grp              GIPI_QUOTE_INVTAX.item_grp%TYPE,
    p_fixed_tax_allocation  GIPI_QUOTE_INVTAX.fixed_tax_allocation%TYPE,
    p_tax_allocation        GIPI_QUOTE_INVTAX.tax_allocation%TYPE
  )
  IS
    v_tax_amt               GIPI_QUOTE_INVOICE.tax_amt%TYPE := 0;
  BEGIN
    MERGE INTO GIPI_QUOTE_INVTAX

    USING dual
       ON (iss_cd = p_iss_cd
      AND line_cd = p_line_cd
      AND quote_inv_no = p_quote_inv_no
      AND tax_cd = p_tax_cd
      AND tax_id = p_tax_id) -- marco - 09.21.2012

     WHEN NOT MATCHED THEN
   INSERT (quote_inv_no, line_cd, iss_cd, tax_cd, tax_amt, tax_id, rate, item_grp, fixed_tax_allocation, tax_allocation)
   VALUES (p_quote_inv_no, p_line_cd, p_iss_cd, p_tax_cd, p_tax_amt, p_tax_id, p_rate, p_item_grp, p_fixed_tax_allocation, p_tax_allocation)

     WHEN MATCHED THEN
   UPDATE
      SET tax_amt              = p_tax_amt,
          rate                 = p_rate,
          item_grp             = p_item_grp,
          fixed_tax_allocation = p_fixed_tax_allocation,
          tax_allocation       = p_tax_allocation;

    FOR i IN(SELECT tax_amt
               FROM GIPI_QUOTE_INVTAX
              WHERE line_cd = p_line_cd
                AND iss_cd = p_iss_cd
                AND quote_inv_no = p_quote_inv_no)
    LOOP
      v_tax_amt := NVL(v_tax_amt, 0) + NVL(i.tax_amt, 0);
    END LOOP;

    UPDATE GIPI_QUOTE_INVOICE
       SET tax_amt = v_tax_amt
     WHERE iss_cd = p_iss_cd
       AND quote_inv_no = p_quote_inv_no
       AND quote_id = p_quote_id;
  END;

/*
**  Created by    : Marco Paolo Rebong
**  Date Created  : May 18, 2012
**  Reference By  : GIIMM002
**  Description   : for deleting tax charges (new tablegrid layout)
*/
  PROCEDURE delete_gipi_quote_invtax(
    p_quote_inv_no          GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
    p_line_cd               GIPI_QUOTE_INVTAX.line_cd%TYPE,
    p_iss_cd                GIPI_QUOTE_INVTAX.iss_cd%TYPE,
    p_tax_cd                GIPI_QUOTE_INVTAX.tax_cd%TYPE,
    p_tax_id                GIPI_QUOTE_INVTAX.tax_id%TYPE
  )
  IS
  BEGIN
    DELETE
      FROM GIPI_QUOTE_INVTAX
     WHERE quote_inv_no = p_quote_inv_no
       AND line_cd = p_line_cd
       AND iss_cd = p_iss_cd
       AND tax_cd = p_tax_cd
       AND tax_id = p_tax_id; -- marco - 09.21.2012
  END;

END GIPI_QUOTE_INVTAX_PKG;
/



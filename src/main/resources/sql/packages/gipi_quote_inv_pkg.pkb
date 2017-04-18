CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Inv_Pkg AS

  FUNCTION get_gipi_quote_invoice(  p_quote_id     GIPI_QUOTE.quote_id%TYPE,
                                         p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE)
    RETURN gipi_quote_invoice_tab PIPELINED IS

    v_gipi_quote_invoice    gipi_quote_invoice_type;
  BEGIN
         FOR i IN (
              SELECT  A.quote_id, A.quote_inv_no, A.iss_cd, A.currency_cd,
                   A.currency_rt, A.prem_amt, A.intm_no, A.tax_amt,
                   --(A.prem_amt + A.tax_amt) amount_due,
                   b.currency_desc
            FROM   GIPI_QUOTE_INVOICE A,
                   GIIS_CURRENCY b
            WHERE  A.quote_id = p_quote_id
              AND  A.iss_cd = p_iss_cd
              AND  A.currency_cd = b.main_currency_cd)
        LOOP
            v_gipi_quote_invoice.quote_id        := i.quote_id;
             v_gipi_quote_invoice.quote_inv_no   := i.quote_inv_no;
            v_gipi_quote_invoice.iss_cd            := i.iss_cd;
            v_gipi_quote_invoice.currency_cd    := i.currency_cd;
            v_gipi_quote_invoice.currency_desc  := i.currency_desc;
            v_gipi_quote_invoice.currency_rt    := i.currency_rt;
            v_gipi_quote_invoice.tax_amt        := i.tax_amt;
            v_gipi_quote_invoice.prem_amt        := i.prem_amt;
            v_gipi_quote_invoice.intm_no        := i.intm_no;
            --v_gipi_quote_invoice.amount_due        := i.amount_due;
            PIPE ROW (v_gipi_quote_invoice);
        END LOOP;
    RETURN;
  END;

  FUNCTION get_gipi_quote_inv (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_inv_tab PIPELINED  IS

    v_gipi_quote_inv      gipi_quote_inv_type;

  BEGIN
    FOR i IN (
      SELECT A.quote_id,    A.quote_inv_no, A.iss_cd||' - '||A.quote_inv_no inv_no,     A.currency_cd,    e.currency_desc,
             A.currency_rt, A.prem_amt,      A.intm_no,                 d.intm_name,      A.tax_amt tot_tax_amt,
             b.tax_cd,      c.tax_desc,      b.tax_amt,                 (A.prem_amt+A.tax_amt) amount_due,
             c.tax_id,      c.rate
        FROM GIPI_QUOTE_INVOICE A,
             GIPI_QUOTE_INVTAX b,
                GIIS_TAX_CHARGES c,
                GIIS_INTERMEDIARY d,
                GIIS_CURRENCY e
       WHERE A.iss_cd = b.iss_cd
         AND A.quote_inv_no = b.quote_inv_no
         AND b.line_cd = c.line_cd
         AND b.iss_cd = c.iss_cd
         AND b.tax_cd = c.tax_cd
         AND b.tax_id = c.tax_id
         AND A.intm_no = d.intm_no(+)
         AND A.currency_cd = e.main_currency_cd
         AND A.quote_id = v_quote_id)
    LOOP
      v_gipi_quote_inv.quote_id         := i.quote_id;
      v_gipi_quote_inv.quote_inv_no     := i.quote_inv_no;
      v_gipi_quote_inv.inv_no           := i.inv_no;
      v_gipi_quote_inv.currency_cd      := i.currency_cd;
      v_gipi_quote_inv.currency_desc    := i.currency_desc;
      v_gipi_quote_inv.currency_rt      := i.currency_rt;
      v_gipi_quote_inv.prem_amt         := i.prem_amt;
      v_gipi_quote_inv.intm_no          := i.intm_no;
      v_gipi_quote_inv.intm_name        := i.intm_name;
      v_gipi_quote_inv.tot_tax_amt      := i.tot_tax_amt;
        v_gipi_quote_inv.tax_cd           := i.tax_cd;
        v_gipi_quote_inv.tax_desc         := i.tax_desc;
        v_gipi_quote_inv.tax_amt          := i.tax_amt;
      v_gipi_quote_inv.amount_due       := i.amount_due;
       v_gipi_quote_inv.tax_id           := i.tax_id;
      v_gipi_quote_inv.rate               := i.rate;
      PIPE ROW (v_gipi_quote_inv);
    END LOOP;
    RETURN;
  END get_gipi_quote_inv;

  PROCEDURE set_gipi_quote_inv (p_gipi_quote_inv       IN       gipi_quote_inv_type,
                                p_iss_cd               IN       giis_issource.iss_cd%TYPE )
  IS

    v_max_quote_inv_no   GIPI_QUOTE_INVTAX.quote_inv_no%TYPE;

  BEGIN

/*     MERGE INTO GIPI_QUOTE_INVOICE
     USING dual ON (quote_id = p_gipi_quote_inv.quote_id
                   AND iss_cd = p_iss_cd
                    AND quote_inv_no = p_gipi_quote_inv.quote_inv_no)
     WHEN NOT MATCHED THEN*/
         INSERT INTO GIPI_QUOTE_INVOICE( quote_id,   iss_cd,    quote_inv_no,         currency_cd,      currency_rt,
                  prem_amt,   intm_no,   tax_amt )
         VALUES ( p_gipi_quote_inv.quote_id,     p_iss_cd,                p_gipi_quote_inv.quote_inv_no,      p_gipi_quote_inv.currency_cd,
                  p_gipi_quote_inv.currency_rt,  p_gipi_quote_inv.prem_amt,  p_gipi_quote_inv.intm_no,          p_gipi_quote_inv.tax_amt);
/*     WHEN MATCHED THEN
         UPDATE SET  currency_cd   = p_gipi_quote_inv.currency_cd,     currency_rt   = p_gipi_quote_inv.currency_rt,
                     prem_amt      = p_gipi_quote_inv.prem_amt,         intm_no       = p_gipi_quote_inv.intm_no,
                     tax_amt       = p_gipi_quote_inv.tax_amt; */
  END set_gipi_quote_inv;



  PROCEDURE set_gipi_quote_inv2 (p_quote_id          IN GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                p_quote_inv_no      IN OUT GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
                                p_currency_cd       IN GIPI_QUOTE_INVOICE.currency_cd%TYPE,
                                p_currency_rt       IN GIPI_QUOTE_INVOICE.currency_rt%TYPE,
                                p_prem_amt            IN GIPI_QUOTE_INVOICE.prem_amt%TYPE,
                                p_intm_no             IN GIPI_QUOTE_INVOICE.intm_no%TYPE,
                                p_tax_amt             IN GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                p_iss_cd          IN GIIS_ISSOURCE.iss_cd%TYPE)
  IS
    v_max_quote_inv_no   GIPI_QUOTE_INVTAX.quote_inv_no%TYPE;
  BEGIN

     MERGE INTO GIPI_QUOTE_INVOICE
            USING dual ON (    quote_id     = p_quote_id AND
                                   quote_inv_no = p_quote_inv_no/* AND
                            /*iss_cd     = p_iss_cd AND
                            currency_cd     = p_currency_cd /*AND
                            currency_rt     = p_currency_rt*/)
     WHEN NOT MATCHED THEN
          INSERT (quote_id, iss_cd, quote_inv_no, currency_cd, currency_rt, prem_amt, intm_no, tax_amt )
          VALUES(p_quote_id, p_iss_cd, p_quote_inv_no, p_currency_cd, p_currency_rt, p_prem_amt, p_intm_no, p_tax_amt)
     WHEN MATCHED THEN
           UPDATE SET intm_no = p_intm_no,
                        tax_amt = p_tax_amt,
                     prem_amt= p_prem_amt;

     /*        ORIGINAL
     INSERT INTO GIPI_QUOTE_INVOICE(quote_id, iss_cd, quote_inv_no, currency_cd, currency_rt, prem_amt, intm_no, tax_amt )
         VALUES(p_quote_id,     p_iss_cd,                p_quote_inv_no,      p_currency_cd,
                  p_currency_rt, p_prem_amt, p_intm_no, p_tax_amt)*/

     FOR i IN (
         SELECT quote_inv_no
           INTO p_quote_inv_no
           FROM GIPI_QUOTE_INVOICE
          WHERE quote_id    = p_quote_id
              AND    iss_cd            = p_iss_cd
            AND currency_cd = p_currency_cd
            AND currency_rt = p_currency_rt)
    LOOP
        p_quote_inv_no := i.quote_inv_no;
    EXIT;
    END LOOP;

  END set_gipi_quote_inv2;


  PROCEDURE set_gipi_quote_invtax (p_gipi_quote_invtax IN GIPI_QUOTE_INVTAX%ROWTYPE)
  IS

  BEGIN

       MERGE INTO GIPI_QUOTE_INVTAX
     USING dual ON ( iss_cd       = p_gipi_quote_invtax.iss_cd
                     AND quote_inv_no = p_gipi_quote_invtax.quote_inv_no
                     AND tax_cd       = p_gipi_quote_invtax.tax_cd)
     WHEN NOT MATCHED THEN
         INSERT ( line_cd,                        iss_cd,                                       quote_inv_no,
                  tax_cd,                         tax_id,                                       tax_amt,
                   rate,                           fixed_tax_allocation,                         item_grp,
                  tax_allocation )
         VALUES ( p_gipi_quote_invtax.line_cd,    p_gipi_quote_invtax.iss_cd,                   p_gipi_quote_invtax.quote_inv_no,
                  p_gipi_quote_invtax.tax_cd,     p_gipi_quote_invtax.tax_id,                   p_gipi_quote_invtax.tax_amt,
                   p_gipi_quote_invtax.rate,       p_gipi_quote_invtax.fixed_tax_allocation,     p_gipi_quote_invtax.item_grp,
                  p_gipi_quote_invtax.tax_allocation)
     WHEN MATCHED THEN
         UPDATE SET  line_cd               = p_gipi_quote_invtax.line_cd,
                     tax_id                = p_gipi_quote_invtax.tax_id,
                     tax_amt               = p_gipi_quote_invtax.tax_amt,
                     rate                  = p_gipi_quote_invtax.rate,
                     fixed_tax_allocation  = p_gipi_quote_invtax.fixed_tax_allocation,
                     item_grp              = p_gipi_quote_invtax.item_grp,
                      tax_allocation           = p_gipi_quote_invtax.tax_allocation;
  END set_gipi_quote_invtax;

  PROCEDURE Del_Gipi_Quote_Inv (p_quote_id       GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                p_quote_inv_no   GIPI_QUOTE_INVOICE.quote_inv_no%TYPE) IS

  BEGIN

    DELETE FROM GIPI_QUOTE_INVTAX
     WHERE quote_inv_no = p_quote_inv_no;

    DELETE FROM GIPI_QUOTE_INVOICE
     WHERE quote_id = p_quote_id
       AND quote_inv_no = p_quote_inv_no;

  END del_gipi_quote_inv;


/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 7, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function returns details of invoice under a Package Quotation
*/

  FUNCTION get_gipi_quote_inv_for_pack(p_pack_quote_id     GIPI_QUOTE.pack_quote_id%TYPE)

    RETURN gipi_quote_invoice_tab PIPELINED IS

    v_gipi_quote_invoice    gipi_quote_invoice_type;
  BEGIN
       FOR i IN (
           SELECT  A.quote_id, A.quote_inv_no, A.iss_cd, A.currency_cd,
                   A.currency_rt, A.prem_amt, A.intm_no, A.tax_amt,
                   b.currency_desc
            FROM   GIPI_QUOTE_INVOICE A,
                   GIIS_CURRENCY b
            WHERE  A.quote_id IN (SELECT quote_id
                                  FROM GIPI_QUOTE
                                  WHERE pack_quote_id = p_pack_quote_id)
              AND  A.currency_cd = b.main_currency_cd)
        LOOP
            v_gipi_quote_invoice.quote_id        := i.quote_id;
            v_gipi_quote_invoice.quote_inv_no   := i.quote_inv_no;
            v_gipi_quote_invoice.iss_cd            := i.iss_cd;
            v_gipi_quote_invoice.currency_cd    := i.currency_cd;
            v_gipi_quote_invoice.currency_desc  := i.currency_desc;
            v_gipi_quote_invoice.currency_rt    := i.currency_rt;
            v_gipi_quote_invoice.tax_amt        := i.tax_amt;
            v_gipi_quote_invoice.prem_amt        := i.prem_amt;
            v_gipi_quote_invoice.intm_no        := i.intm_no;
            PIPE ROW (v_gipi_quote_invoice);
        END LOOP;
    RETURN;
  END;

 /*
  ** Retrieves latest quote_inv_no of specified iss_cd; creates a new entry in GIIS_QUOTE_INV_SEQ
  ** AUTHOR:    rencela
  ** CREATED:   2011/06/13
  ** LAST EDIT: 2011/06/14
  */
  FUNCTION get_gipi_quote_invseq (p_iss_cd   GIPI_QUOTE.iss_cd%TYPE)
    RETURN GIIS_QUOTE_INV_SEQ.QUOTE_INV_NO%TYPE IS
    v_inv_seq              GIIS_QUOTE_INV_SEQ.quote_inv_no%TYPE;
  BEGIN
    /*BEGIN*/
        SELECT QUOTE_INV_NO
          INTO v_inv_seq
          FROM GIIS_QUOTE_INV_SEQ
         WHERE iss_cd = p_iss_cd;
    /*EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO GIIS_QUOTE_INV_SEQ(iss_cd, quote_inv_no)
            VALUES (p_iss_cd, 1);
        RETURN 1;
    END;*/
    RETURN v_inv_seq;
  END get_gipi_quote_invseq;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 9, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Updates details of invoice under a Package Quotation
*/

  PROCEDURE update_gipi_quote_inv (p_quote_id        GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                   p_quote_inv_no    GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
                                   p_prem_amt          GIPI_QUOTE_INVOICE.prem_amt%TYPE,
                                   p_intm_no           GIPI_QUOTE_INVOICE.intm_no%TYPE,
                                   p_tax_amt           GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                   p_iss_cd         GIPI_QUOTE_INVTAX.iss_cd%TYPE)
  AS

  BEGIN
    UPDATE GIPI_QUOTE_INVOICE
       SET  intm_no = p_intm_no,
            tax_amt = p_tax_amt,
            prem_amt= p_prem_amt
    WHERE quote_id = p_quote_id
      AND quote_inv_no = p_quote_inv_no
      AND iss_cd = p_iss_cd;
  END;

END Gipi_Quote_Inv_Pkg;
/



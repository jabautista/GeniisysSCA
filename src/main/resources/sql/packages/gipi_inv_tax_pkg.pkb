CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Inv_Tax_Pkg
AS
   /*
    **  Created by        : Queenie Santos
    **  Date Created     : 05.09.2011
    **  Reference By     : (GIACS050 - OR PRINTING CALLING FORM)
    **  Description     : Determine tax type
    */
    FUNCTION get_vat_type (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
       RETURN VARCHAR2
    IS
       v_vat_amt   NUMBER       := 0;
       v_vatable   VARCHAR2 (1) := 'N';
    BEGIN
       FOR z IN (SELECT b140_iss_cd, b140_prem_seq_no
                   FROM giac_direct_prem_collns
                  WHERE gacc_tran_id = p_tran_id)
       LOOP
          FOR y IN (SELECT tax_amt
                      FROM gipi_inv_tax
                     WHERE iss_cd = z.b140_iss_cd
                       AND prem_seq_no = z.b140_prem_seq_no
                       AND tax_cd = giacp.n ('EVAT'))
          LOOP
             v_vatable := 'Y';
             v_vat_amt := v_vat_amt + y.tax_amt;
          END LOOP;
       END LOOP;

       IF v_vatable = 'N'
       THEN
          RETURN 'VAT EXEMPT SALES';
       ELSIF v_vatable = 'Y'
       THEN
          IF v_vat_amt = 0
          THEN
             RETURN 'ZERO RATED SALES';
          ELSE
             RETURN ' ';
          END IF;
       END IF;
    END get_vat_type;

    PROCEDURE update_for_change_payment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE   
    ) IS
    BEGIN
        UPDATE gipi_inv_tax
           SET fixed_tax_allocation = 'N'
         WHERE tax_cd = GIACP.N('EVAT')
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no;  
    END update_for_change_payment;
    
    
    /*
    **  Created by        : MArie Kris Felipe
    **  Date Created     : 09.10.2013
    **  Reference By     : (GIPIS137 - View Invoice Information)
    **  Description     : Gets list of invoice taxes
    */
    FUNCTION get_invoice_tax_list(
        p_iss_cd        GIPI_INV_TAX.iss_cd%TYPE,
        p_prem_seq_no   GIPI_INV_TAX.prem_seq_no%TYPE,
        p_item_grp      GIPI_INV_TAX.item_grp%TYPE
    ) RETURN invoice_tax_tab PIPELINED
    IS
        v_tax       invoice_tax_type;
    BEGIN
    
        FOR rec IN (SELECT tax_cd, line_cd, item_grp, tax_id, iss_cd, tax_amt, prem_seq_no
                      FROM GIPI_INV_TAX
                     WHERE iss_cd       = p_iss_cd
                       AND prem_seq_no  = p_prem_seq_no
                       AND item_grp     = p_item_grp)
        LOOP
            v_tax.iss_Cd := rec.iss_cd;
            v_tax.line_cd := rec.line_cd;
            v_tax.item_grp := rec.item_grp;
            v_tax.tax_id := rec.tax_id;
            v_tax.tax_cd := rec.tax_cd;
            v_tax.tax_amt := rec.tax_amt;
            v_tax.prem_seq_no := rec.prem_seq_no;
            
            FOR A1 IN (SELECT A230.TAX_DESC
                         FROM GIIS_TAX_CHARGES A230
                        WHERE A230.LINE_CD = rec.LINE_CD
                          AND A230.TAX_CD  = rec.TAX_CD
                          AND A230.TAX_ID  = rec.TAX_ID
                          AND A230.ISS_CD  = rec.ISS_CD)
            LOOP
                v_tax.TAX_DESC := A1.TAX_DESC;
                EXIT;
            END LOOP; 
            
            PIPE ROW(v_tax);
        END LOOP;
    
    END get_invoice_tax_list;

END Gipi_Inv_Tax_Pkg;
/



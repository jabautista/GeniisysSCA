CREATE OR REPLACE PACKAGE BODY CPI.POPULATE_SU_QUOTE_PKG AS
/******************************************************************************
   NAME:       POPULATE_SU_QUOTE_PKG
   PURPOSE:
   MODULE:     GIIMM006

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012   Christian        1. Created this package.
******************************************************************************/
FUNCTION populate_bonds_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_position VARCHAR2, p_designation VARCHAR2)
  RETURN su_quote_tab PIPELINED IS

  v_su_quote    su_quote_type;
  v_tot_tax_amt GIPI_INV_TAX.TAX_AMT%TYPE;

  BEGIN
    FOR a IN (SELECT assd_name assd_name,
                     address1 assd_add1,
                     address2 assd_add2,
                     address3 assd_add3,
                     header,
                     footer,
                     TO_CHAR(incept_date, 'fmMonth DD, YYYY') incept_dt,
                     TO_CHAR(expiry_date, 'fmMonth DD, YYYY') expiry_dt,
                     TO_CHAR(SUM(tsi_amt), '999,999,999,999.99') tsi,
                     TO_CHAR(SUM(prem_amt), '999,999,999,999.99') prem_amt,
                     sum(prem_amt) prem,
                     user_id,
                     line_cd,
                     subline_cd
                FROM gipi_quote
               WHERE quote_id = p_quote_id
            GROUP BY assd_name, address1, address2, address3, incept_date, expiry_date, header, footer, user_id, line_cd, subline_cd)

      LOOP
          v_su_quote.assd_name     := a.assd_name;
          v_su_quote.assd_add1     := a.assd_add1;
          v_su_quote.assd_add2     := a.assd_add2;
          v_su_quote.assd_add3     := a.assd_add3;
          v_su_quote.incept        := a.incept_dt;
          v_su_quote.expiry        := a.expiry_dt;
          v_su_quote.bond_amt      := a.tsi;
          v_su_quote.premium       := a.prem_amt;
          v_su_quote.prem_amt      := a.prem;
          v_su_quote.header        := a.header;
          v_su_quote.footer        := a.footer;
          v_su_quote.user_id       := a.user_id;
          v_su_quote.line_cd       := a.line_cd;
          v_su_quote.subline_cd    := a.subline_cd;

       --obligee
       FOR b IN (SELECT obligee_name
                   FROM giis_obligee a,
                        gipi_quote_bond_basic b
                  WHERE b.quote_id = p_quote_id
                    AND a.obligee_no = b.obligee_no)
        LOOP
          v_su_quote.obligee := b.obligee_name;
        END LOOP;

       --principal
       FOR c IN (SELECT prin_signor
                   FROM giis_prin_signtry a,
                        gipi_quote b
                  WHERE b.quote_id = p_quote_id
 	                AND a.assd_no = b.assd_no)
 	   LOOP
 	 	 v_su_quote.principal := c.prin_signor;
 	   END LOOP;

       --quote number
       FOR i IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
	               FROM gipi_quote
	              WHERE quote_id = p_quote_id)
	   LOOP
	 	 v_su_quote.quote_no := i.quote_no;
	   END LOOP;

       --total premium
       BEGIN
         SELECT SUM(b.tax_amt * a.currency_rt) tax
           INTO v_tot_tax_amt
           FROM gipi_quote_invoice a,
                gipi_quote_invtax b,
                gipi_quote_item c,
                gipi_quote d
          WHERE c.currency_cd = a.currency_cd
            AND d.quote_id = p_quote_id
            AND a.quote_inv_no = b.quote_inv_no
            AND a.quote_id = c.quote_id
            AND a.quote_id = d.quote_id
            AND b.iss_cd = a.iss_cd;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;

       v_su_quote.total_amt   := NVL(v_tot_tax_amt, 0) + NVL(v_su_quote.prem_amt, 0);
       v_su_quote.position    := INITCAP(p_position);
       v_su_quote.designation := INITCAP(p_designation);

       PIPE ROW(v_su_quote);
 	 END LOOP;

  END;

FUNCTION get_su_quote_tax(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_line_cd GIPI_QUOTE.line_cd%TYPE)
  RETURN su_quote_tax_tab PIPELINED IS

  v_su_quote_tax su_quote_tax_type;

  BEGIN

    FOR e IN (SELECT b.tax_cd, e.tax_desc, TO_CHAR(SUM(DISTINCT b.tax_amt), '999,999,999,999.99') tax_amt
                FROM gipi_quote_invoice a,
                     gipi_quote_invtax b,
                     gipi_quote_item c,
                     gipi_quote d,
				  	 giis_tax_charges e
               WHERE c.currency_cd = a.currency_cd
                 AND d.quote_id = p_quote_id
                 AND a.quote_inv_no = b.quote_inv_no
                 AND a.quote_id = c.quote_id
                 AND a.quote_id = d.quote_id
                 AND b.iss_cd = a.iss_cd
                 AND b.iss_cd = e.iss_cd
                 AND b.line_cd = e.line_cd
                 AND b.tax_cd = e.tax_cd
				 AND e.line_cd = p_line_cd
            GROUP BY b.tax_cd, e.tax_desc)

    LOOP
      v_su_quote_tax.tax_cd   := e.tax_cd;
      v_su_quote_tax.tax_desc := e.tax_desc;
   	  v_su_quote_tax.tax_amt  := e.tax_amt;

      PIPE ROW(v_su_quote_tax);
    END LOOP;

    RETURN;
  END;

END POPULATE_SU_QUOTE_PKG;
/



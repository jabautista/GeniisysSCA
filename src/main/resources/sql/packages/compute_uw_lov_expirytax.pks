CREATE OR REPLACE PACKAGE CPI.compute_uw_LOV_expirytax AS

FUNCTION compute_tax (p_policy_id NUMBER,
                      p_iss_cd VARCHAR2,
                      p_line_cd VARCHAR2,
                      p_tax_cd number,
                      p_tax_id number,
                      p_item_no number)

RETURN NUMBER;

/*
** get_tax_range: created by Edgar Nobleza
*/
FUNCTION get_tax_range (p_amount NUMBER,
                        p_currency_rt NUMBER,
                        p_line_cd VARCHAR2,
                        p_iss_cd VARCHAR2,
                        p_tax_cd NUMBER,
                        p_tax_id NUMBER)
RETURN NUMBER;

END;
/



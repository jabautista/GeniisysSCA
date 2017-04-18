CREATE OR REPLACE PACKAGE CPI.COMPUTE_UWTaxesExpiry AS

FUNCTION recompute_prem_amt (p_policy_id NUMBER,
                             p_tax_cd NUMBER,
                             p_tax_id NUMBER,
                             p_line_cd VARCHAR2,
                             p_iss_cd VARCHAR2)
RETURN NUMBER;   

FUNCTION get_tax_range (p_amount NUMBER,        -- FUNCTION EDGAR
                        p_currency_rt NUMBER,
                        p_line_cd VARCHAR2,
                        p_iss_cd VARCHAR2,
                        p_tax_cd NUMBER,
                        p_tax_id NUMBER)
RETURN NUMBER;

PROCEDURE compute_old_group_tax (p_from_month    VARCHAR2,
                                 p_to_month      VARCHAR2,
                                 p_from_year     NUMBER,
                                 p_to_year       NUMBER,
                                 p_from_date     DATE,
                                 p_to_date       DATE,
                                 p_line_cd       VARCHAR2,
                                 p_subline_cd    VARCHAR2,
                                 p_iss_cd        VARCHAR2,
                                 p_issue_yy      NUMBER,
                                 p_pol_seq_no    NUMBER,
                                 p_renew_no      NUMBER);
                       
PROCEDURE compute_new_group_tax (p_policy_id     NUMBER,
                                 p_line_cd       VARCHAR2,
                                 p_subline_cd    VARCHAR2,
                                 p_iss_cd        VARCHAR2,
                                 p_item_no       NUMBER,
                                 p_peril_cd      NUMBER);    

/*Created by: Joanne
**Date: 011314
**Desc: populate expiry tax for GENWEB*/
PROCEDURE compute_new_group_tax2 (p_policy_id     NUMBER,
                                 p_line_cd       VARCHAR2,
                                 p_subline_cd    VARCHAR2,
                                 p_iss_cd        VARCHAR2);   

END;
/

DROP PACKAGE CPI.COMPUTE_UWTAXESEXPIRY;

CREATE OR REPLACE PACKAGE CPI.gipi_polbasic_discount_pkg AS

/**
* Rey Jadlocon 
* 08-09-2011
* policy discount/surcharge
**/
TYPE policy_discount_surcharge_type IS RECORD(
    sequence                    GIPI_POLBASIC_DISCOUNT.SEQUENCE%TYPE,
    disc_amt                    GIPI_POLBASIC_DISCOUNT.DISC_AMT%TYPE,
    disc_rt                     GIPI_POLBASIC_DISCOUNT.DISC_RT%TYPE,
    surcharge_amt               GIPI_POLBASIC_DISCOUNT.SURCHARGE_AMT%TYPE,
    surcharge_rt                GIPI_POLBASIC_DISCOUNT.SURCHARGE_RT%TYPE,
    net_prem_amt                GIPI_POLBASIC_DISCOUNT.NET_PREM_AMT%TYPE,
    net_gross_tag               GIPI_POLBASIC_DISCOUNT.NET_GROSS_TAG%TYPE,
    remarks                     GIPI_POLBASIC_DISCOUNT.REMARKS%TYPE
    );
    
    TYPE policy_discount_surcharge_tab IS TABLE OF policy_discount_surcharge_type;
    
FUNCTION get_policy_discount_surcharge(p_policy_id      gipi_polbasic.policy_id%TYPE)
                RETURN policy_discount_surcharge_tab PIPELINED;

END gipi_polbasic_discount_pkg;
/



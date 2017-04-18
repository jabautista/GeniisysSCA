CREATE OR REPLACE PACKAGE CPI.GIPI_ITEM_DISCOUNT_PKG AS

/**
* Rey Jadlocon
* 08-09-2011
* item discount surcharge
**/
TYPE item_discount_surcharge_type IS RECORD(
    sequence                    GIPI_ITEM_DISCOUNT.SEQUENCE%TYPE,
    item_no                     GIPI_ITEM_DISCOUNT.ITEM_NO%TYPE,
    disc_amt                    GIPI_ITEM_DISCOUNT.DISC_AMT%TYPE,
    disc_rt                     GIPI_ITEM_DISCOUNT.DISC_RT%TYPE,
    surcharge_amt               GIPI_ITEM_DISCOUNT.SURCHARGE_AMT%TYPE,
    surcharge_rt                GIPI_ITEM_DISCOUNT.SURCHARGE_RT%TYPE,
    net_prem_amt                GIPI_ITEM_DISCOUNT.NET_PREM_AMT%TYPE,
    net_gross_tag               GIPI_ITEM_DISCOUNT.NET_GROSS_TAG%TYPE,
    remarks                     GIPI_ITEM_DISCOUNT.REMARKS%TYPE
    );
    
    TYPE item_discount_surcharge_tab IS TABLE OF item_discount_surcharge_type; 
    
FUNCTION get_item_discount_surcharge(p_policy_id      gipi_polbasic.policy_id%TYPE)
            RETURN item_discount_surcharge_tab PIPELINED;

END GIPI_ITEM_DISCOUNT_PKG;
/



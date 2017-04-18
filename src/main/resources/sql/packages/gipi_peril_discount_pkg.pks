CREATE OR REPLACE PACKAGE CPI.GIPI_PERIL_DISCOUNT_PKG AS

/**
* Rey Jadlocon
* 08-09-2011
* peril discount surcharge
**/
TYPE peril_discount_surcharge_type IS RECORD(
    sequence                    gipi_peril_discount.SEQUENCE%TYPE,
    item_no                     gipi_peril_discount.ITEM_NO%TYPE,
    peril_name                  GIIS_PERIL.PERIL_NAME%TYPE,
    disc_amt                    gipi_peril_discount.DISC_AMT%TYPE,
    disc_rt                     gipi_peril_discount.DISC_RT%TYPE,
    surcharge_amt               gipi_peril_discount.SURCHARGE_AMT%TYPE,
    surcharge_rt                gipi_peril_discount.SURCHARGE_RT%TYPE,
    net_prem_amt                gipi_peril_discount.NET_PREM_AMT%TYPE,
    net_gross_tag               gipi_peril_discount.NET_GROSS_TAG%TYPE,
    remarks                     gipi_peril_discount.REMARKS%TYPE
    );
    
    TYPE peril_discount_surcharge_tab IS TABLE OF peril_discount_surcharge_type; 
    
FUNCTION get_peril_discount_surcharge(p_policy_id      gipi_polbasic.policy_id%TYPE)
            RETURN peril_discount_surcharge_tab PIPELINED;

END GIPI_PERIL_DISCOUNT_PKG;
/



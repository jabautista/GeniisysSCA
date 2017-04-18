CREATE OR REPLACE PACKAGE BODY CPI.gipi_polbasic_discount_pkg AS

/**
* Rey Jadlocon
* 08-09-2011
* policy discount/surcharge
**/
FUNCTION get_policy_discount_surcharge(p_policy_id      gipi_polbasic.policy_id%TYPE)
                RETURN policy_discount_surcharge_tab PIPELINED
              IS
                v_policy_discount_surcharge policy_discount_surcharge_type;
           BEGIN
                FOR i IN (SELECT *
                            FROM (SELECT A.SEQUENCE, A.DISC_AMT,A.DISC_RT,A.SURCHARGE_AMT,A.SURCHARGE_RT,
                                         A.NET_PREM_AMT,A.NET_GROSS_TAG,A.REMARKS
                                    FROM gipi_polbasic_discount a, gipi_polbasic b
                                   WHERE a.policy_id = b.policy_id
                                     AND a.policy_id = p_policy_id))
          LOOP
              v_policy_discount_surcharge.sequence           := i.sequence;
              v_policy_discount_surcharge.disc_amt           := i.disc_amt;
              v_policy_discount_surcharge.disc_rt            := i.disc_rt;
              v_policy_discount_surcharge.surcharge_amt      := i.surcharge_amt;
              v_policy_discount_surcharge.surcharge_rt       := i.surcharge_rt;
              v_policy_discount_surcharge.net_prem_amt       := i.net_prem_amt;
              v_policy_discount_surcharge.net_gross_tag      := i.net_gross_tag;
              v_policy_discount_surcharge.remarks            := i.remarks;
              PIPE ROW(v_policy_discount_surcharge);
          END LOOP

        RETURN;
    END get_policy_discount_surcharge;

END gipi_polbasic_discount_pkg;
/



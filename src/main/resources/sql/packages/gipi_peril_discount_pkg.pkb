CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PERIL_DISCOUNT_PKG AS

/**
* Rey Jadlocon
* 08-09-2011
* peril discount surcharge
**/
FUNCTION get_peril_discount_surcharge(p_policy_id      gipi_polbasic.policy_id%TYPE)
            RETURN peril_discount_surcharge_tab PIPELINED
          IS
            v_peril_discount_surcharge peril_discount_surcharge_type;
       BEGIN
            FOR i IN (SELECT *
                        FROM (SELECT a.SEQUENCE, a.item_no, c.peril_name, a.disc_amt, a.disc_rt,
                                     a.surcharge_amt, a.surcharge_rt, a.net_prem_amt,
                                     a.net_gross_tag, a.remarks
                                FROM gipi_peril_discount a, gipi_polbasic b, giis_peril c
                               WHERE a.policy_id = b.policy_id
                                 AND a.peril_cd = c.peril_cd
                                 AND b.line_cd  = c.line_cd
                                 AND a.level_tag = '1'
                                 AND a.policy_id = p_policy_id))
            LOOP
              v_peril_discount_surcharge.sequence           := i.sequence;
              v_peril_discount_surcharge.item_no            := i.item_no;
              v_peril_discount_surcharge.peril_name         := i.peril_name;
              v_peril_discount_surcharge.disc_amt           := i.disc_amt;
              v_peril_discount_surcharge.disc_rt            := i.disc_rt;
              v_peril_discount_surcharge.surcharge_amt      := i.surcharge_amt;
              v_peril_discount_surcharge.surcharge_rt       := i.surcharge_rt;
              v_peril_discount_surcharge.net_prem_amt       := i.net_prem_amt;
              v_peril_discount_surcharge.net_gross_tag      := i.net_gross_tag;
              v_peril_discount_surcharge.remarks            := i.remarks;
              PIPE ROW(v_peril_discount_surcharge);
          END LOOP
          
        RETURN;
     END get_peril_discount_surcharge;

END GIPI_PERIL_DISCOUNT_PKG;
/



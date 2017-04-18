CREATE OR REPLACE PACKAGE BODY CPI.gipi_itmperil_beneficiary_pkg AS

    /*
    **    Created by:     Moses Calma
    **    Date Created:   06.29.2011
    **    Used in:        GIPIS 100 - View Policy Information
    **    Description:    return record of item_peril beneficiaries gven policy_id,item_no and grouped_item_no
    */
    FUNCTION get_itmperil_beneficiaries (
       p_policy_id         gipi_itmperil_beneficiary.policy_id%TYPE,
       p_item_no           gipi_itmperil_beneficiary.item_no%TYPE,
       p_grouped_item_no   gipi_itmperil_beneficiary.grouped_item_no%TYPE
    )
       RETURN itmperil_beneficiary_tab PIPELINED
    IS
       v_itmperil_beneficiary   itmperil_beneficiary_type;
    BEGIN
       FOR i IN (SELECT policy_id, item_no, grouped_item_no, line_cd, peril_cd, tsi_amt
                   FROM gipi_itmperil_beneficiary
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no)
       LOOP

          v_itmperil_beneficiary.policy_id        := i.policy_id;
          v_itmperil_beneficiary.item_no          := i.item_no;
          v_itmperil_beneficiary.grouped_item_no  := i.grouped_item_no;
          v_itmperil_beneficiary.line_cd          := i.line_cd;
          v_itmperil_beneficiary.peril_cd         := i.peril_cd;
          v_itmperil_beneficiary.tsi_amt          := i.tsi_amt;

          BEGIN

            SELECT peril_name
              INTO v_itmperil_beneficiary.peril_name
              FROM giis_peril
             WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_itmperil_beneficiary.peril_name := '';

          END;

          PIPE ROW (v_itmperil_beneficiary);
       END LOOP;
    END get_itmperil_beneficiaries;

END gipi_itmperil_beneficiary_pkg;
/



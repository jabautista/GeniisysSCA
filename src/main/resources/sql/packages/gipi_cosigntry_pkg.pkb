CREATE OR REPLACE PACKAGE BODY CPI.gipi_cosigntry_pkg
AS
   /*
   **  Created by      : Niknok Orio
   **  Date Created    : 11.15.2011
   **  Reference By    : (GICLS010 - Claims Basic Info - Bond Policy Date)
   **  Description     :
   */
    FUNCTION get_gipi_cosigntry(p_policy_id     gipi_cosigntry.policy_id%TYPE)
    RETURN gipi_cosigntry_tab PIPELINED IS
      v_list        gipi_cosigntry_type;
    BEGIN
        FOR i IN(SELECT a.cosign_name, b.cosign_id, b.policy_id
                   FROM giis_cosignor_res a,
                        gipi_cosigntry b
                  WHERE a.cosign_id(+) = b.cosign_id
                    AND b.policy_id = p_policy_id)
        LOOP
          v_list.dsp_cosign_name    := i.cosign_name;
          v_list.cosign_id          := i.cosign_id;
          v_list.policy_id          := i.policy_id;
          PIPE ROW(v_list);
        END LOOP;
      RETURN;
    END;

END gipi_cosigntry_pkg;
/



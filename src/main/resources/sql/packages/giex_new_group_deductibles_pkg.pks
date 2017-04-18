CREATE OR REPLACE PACKAGE CPI.giex_new_group_deductibles_pkg
AS
   TYPE new_group_deductibles_type IS RECORD (
        policy_id               giex_new_group_deductibles.policy_id%TYPE,
        item_no                 giex_new_group_deductibles.item_no%TYPE,
        peril_cd                giex_new_group_deductibles.peril_cd%TYPE,
        ded_deductible_cd       giex_new_group_deductibles.ded_deductible_cd%TYPE,
        line_cd                 giex_new_group_deductibles.line_cd%TYPE,
        subline_cd              giex_new_group_deductibles.subline_cd%TYPE,
        deductible_rt           giex_new_group_deductibles.deductible_rt%TYPE,
        deductible_amt          giex_new_group_deductibles.deductible_amt%TYPE,
        deductible_local_amt    giex_new_group_deductibles.deductible_amt%TYPE, --added by joanne 06.05.14
        ----------------------------
        dsp_peril_name          giis_peril.peril_name%TYPE,
        deductible_text         giis_deductible_desc.deductible_text%TYPE,
        ded_type                giis_deductible_desc.ded_type%TYPE,
        item_title         gipi_item.item_title%TYPE, -- added by andrew - 12.10.2012
        deductible_title   giis_deductible_desc.deductible_title%TYPE -- added by andrew - 12.10.2012
   );

   TYPE new_group_deductibles_tab IS TABLE OF new_group_deductibles_type;

    FUNCTION populate_deductibles (p_policy_id   giex_new_group_tax.policy_id%TYPE)
    RETURN new_group_deductibles_tab PIPELINED;

    PROCEDURE set_deductibles_dtls (
        p_policy_id             giex_new_group_deductibles.policy_id%TYPE,
        p_item_no               giex_new_group_deductibles.item_no%TYPE,
        p_peril_cd              giex_new_group_deductibles.peril_cd%TYPE,
        p_ded_deductible_cd     giex_new_group_deductibles.ded_deductible_cd%TYPE,
        p_line_cd               giex_new_group_deductibles.line_cd%TYPE,
        p_subline_cd            giex_new_group_deductibles.subline_cd%TYPE,
        p_deductible_rt         giex_new_group_deductibles.deductible_rt%TYPE,
        p_deductible_amt        giex_new_group_deductibles.deductible_amt%TYPE
    );

    PROCEDURE ins_new_group_deductibles(p_policy_id giex_new_group_deductibles.policy_id%TYPE);

    FUNCTION val_if_deductible_exists(
      p_policy_id             giex_new_group_deductibles.policy_id%TYPE,
      p_item_no               giex_new_group_deductibles.item_no%TYPE,
      p_peril_cd              giex_new_group_deductibles.peril_cd%TYPE,
      p_ded_deductible_cd     giex_new_group_deductibles.ded_deductible_cd%TYPE)
    RETURN NUMBER;

    /*Added by Joanne, 112513, delete ded in table giex_new_group_deductibles*/
    PROCEDURE delete_deductibles (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE,
       p_item_no     giex_new_group_deductibles.item_no%TYPE,
       p_peril_cd    giex_new_group_deductibles.peril_cd%TYPE
    ); --joanne 112513

   /*Added by Joanne
   **Date: 041514
   **Desc: To recompute and update % TSI deductibles during save*/
   PROCEDURE update_deductibles (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
   );

    /*Added by Joanne
   **Date: 041514
   **Desc: To check if policy have % TSI deductibles*/
    FUNCTION count_tsi_ded (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
    )
    RETURN NUMBER;

    /*Added by Joanne
   **Date: 06.06.14
   **Desc: To get policy currency*/
    FUNCTION get_deductible_currency (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
    )
    RETURN NUMBER;
END;
/



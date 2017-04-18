CREATE OR REPLACE PACKAGE CPI.GICL_ADVS_FLA_TYPE_PKG AS

    TYPE gicl_advs_fla_type2 IS RECORD(
        claim_id            GICL_ADVS_FLA_TYPE.claim_id%TYPE,
        grp_seq_no          GICL_ADVS_FLA_TYPE.grp_seq_no%TYPE,
        fla_id              GICL_ADVS_FLA_TYPE.fla_id%TYPE,
        payee_type          GICL_ADVS_FLA_TYPE.payee_type%TYPE,
        loss_shr_amt        GICL_ADVS_FLA_TYPE.loss_shr_amt%TYPE,
        exp_shr_amt         GICL_ADVS_FLA_TYPE.exp_shr_amt%TYPE
    );
    TYPE gicl_advs_fla_type_tab IS TABLE OF gicl_advs_fla_type2;

    PROCEDURE populate_advs_fla_type(
        p_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE
    );

END GICL_ADVS_FLA_TYPE_PKG;
/



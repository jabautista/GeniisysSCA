CREATE OR REPLACE PACKAGE CPI.GICL_ADVS_FLA_PKG AS

     TYPE advs_fla_type IS RECORD(
        fla_id                  GICL_ADVS_FLA.fla_id%TYPE,
        claim_id                GICL_ADVS_FLA.claim_id%TYPE,
        grp_seq_no              GICL_ADVS_FLA.grp_seq_no%TYPE,
        ri_cd                   GICL_ADVS_FLA.ri_cd%TYPE,
        line_cd                 GICL_ADVS_FLA.line_cd%TYPE,
        la_yy                   GICL_ADVS_FLA.la_yy%TYPE,
        fla_seq_no              GICL_ADVS_FLA.fla_seq_no%TYPE,
        user_id                 GICL_ADVS_FLA.user_id%TYPE,
        last_update             GICL_ADVS_FLA.last_update%TYPE,
        fla_date                GICL_ADVS_FLA.fla_date%TYPE,
        paid_shr_amt            GICL_ADVS_FLA.paid_shr_amt%TYPE,
        net_shr_amt             GICL_ADVS_FLA.net_shr_amt%TYPE,
        adv_shr_amt             GICL_ADVS_FLA.adv_shr_amt%TYPE,
        fla_title               GICL_ADVS_FLA.fla_title%TYPE,
        fla_header              GICL_ADVS_FLA.fla_header%TYPE,
        fla_footer              GICL_ADVS_FLA.fla_footer%TYPE,
        share_type              GICL_ADVS_FLA.share_type%TYPE,
        print_sw                GICL_ADVS_FLA.print_sw%TYPE,
        cancel_tag              GICL_ADVS_FLA.cancel_tag%TYPE,
        adv_fla_id              GICL_ADVS_FLA.adv_fla_id%TYPE,
        acct_trty_type          GICL_ADVS_FLA.acct_trty_type%TYPE,
        cpi_rec_no              GICL_ADVS_FLA.cpi_rec_no%TYPE,
        cpi_branch_cd           GICL_ADVS_FLA.cpi_branch_cd%TYPE,
        loss_shr_amt            GICL_ADVS_FLA.loss_shr_amt%TYPE,
        exp_shr_amt             GICL_ADVS_FLA.exp_shr_amt%TYPE
    );
    TYPE advs_fla_tab IS TABLE OF advs_fla_type;
    
    TYPE fla_dtls_type IS RECORD(
        claim_id                GICL_ADVS_FLA.claim_id%TYPE,
        fla_id                  GICL_ADVS_FLA.fla_id%TYPE,
        fla_no                  VARCHAR2(100),
        print_sw                VARCHAR2(10),
        line_cd                 GICL_ADVS_FLA.line_cd%TYPE,
        la_yy                   GICL_ADVS_FLA.la_yy%TYPE,
        fla_seq_no              GICL_ADVS_FLA.fla_seq_no%TYPE,
        paid_shr_amt            GICL_ADVS_FLA.paid_shr_amt%TYPE,
        net_shr_amt             GICL_ADVS_FLA.net_shr_amt%TYPE,
        adv_shr_amt             GICL_ADVS_FLA.adv_shr_amt%TYPE,
        fla_title               GICL_ADVS_FLA.fla_title%TYPE,
        fla_header              GICL_ADVS_FLA.fla_header%TYPE,
        fla_footer              GICL_ADVS_FLA.fla_footer%TYPE,
        ri_cd                   GICL_ADVS_FLA.ri_cd%TYPE,
        adv_fla_id              GICL_ADVS_FLA.adv_fla_id%TYPE,
        ri_name                 GIIS_REINSURER.ri_name%TYPE,
        dsp_ri_name             VARCHAR2(1000),
        share_type              GICL_ADVS_FLA.share_type%TYPE,
        grp_seq_no              GICL_ADVS_FLA.grp_seq_no%TYPE
    );
    TYPE fla_dtls_tab IS TABLE OF fla_dtls_type;
    
    FUNCTION get_fla_dtls(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_grp_seq_no            GICL_ADVS_FLA.grp_seq_no%TYPE,
        p_share_type            GICL_ADVS_FLA.share_type%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE
    )
    RETURN fla_dtls_tab PIPELINED;
 
    PROCEDURE generate_fla(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE,
        p_line_cd           GICL_CLAIMS.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE
    );
    
    FUNCTION get_adv_fla_id
      RETURN NUMBER;
    
    PROCEDURE clm_fla_grp1(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd           GICL_ADVS_FLA.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_vadvice           VARCHAR2
    );
    
    PROCEDURE clm_fla_grp1a(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd           GICL_ADVS_FLA.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_vadvice           VARCHAR2
    );
    
    FUNCTION get_acct_trty_type(
        p_claim_id          NUMBER,
        p_share_type        NUMBER,
        p_grp_seq_no        NUMBER,
        p_prnt_ri_cd        NUMBER
    )
    RETURN NUMBER;
    
    PROCEDURE cancel_fla(
        p_claim_id      IN      GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE,
        p_share_type    IN      GICL_ADVS_FLA.share_type%TYPE,
        p_adv_fla_id    IN      GICL_ADVS_FLA.adv_fla_id%TYPE,
        p_message       OUT     VARCHAR2
    );
    
    FUNCTION check_gen(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd               GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy                 GICL_ADVS_FLA.la_yy%TYPE,
        p_fla_seq_no            GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_ri_cd                 GICL_ADVS_FLA.ri_cd%TYPE
    )
    RETURN VARCHAR2;
    
    PROCEDURE update_fla(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_grp_seq_no            GICL_ADVS_FLA.grp_seq_no%TYPE,
        p_share_type            GICL_ADVS_FLA.share_type%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE,
        p_fla_seq_no            GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_fla_title             GICL_ADVS_FLA.fla_title%TYPE,
        p_fla_header            GICL_ADVS_FLA.fla_header%TYPE,
        p_fla_footer            GICL_ADVS_FLA.fla_footer%TYPE
    );
  
    FUNCTION validate_pd_fla(
        p_user_id       IN      GIIS_USERS.user_id%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE,
        p_fla_seq_no    IN      GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_ri_cd         IN      GICL_ADVS_FLA.ri_cd%TYPE,
        p_override      IN      VARCHAR2
    )
    RETURN VARCHAR2;
    
    PROCEDURE update_fla_print_sw(
        p_claim_id      IN      GICL_ADVS_FLA.claim_id%TYPE,
        p_share_type    IN      GICL_ADVS_FLA.share_type%TYPE,
        p_ri_cd         IN      GICL_ADVS_FLA.ri_cd%TYPE,
        p_fla_seq_no    IN      GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE
    );
    
    -- added by Kris for GICLS050 [Print PLA/FLA]
    PROCEDURE tag_fla_as_printed(
        p_fla   gicl_advs_fla%ROWTYPE
    );

END GICL_ADVS_FLA_PKG;
/



CREATE OR REPLACE PACKAGE CPI.GICLR258_PKG
    /* 
    **  Created by        : bonok
    **  Date Created      : 03.07.2013
    **  Reference By      : GICLR258 - CLAIM LISTING PER RECOVERY TYPE
    */
AS
    TYPE giclr258_type IS RECORD(
        rec_type            VARCHAR2(60),
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        assured_name        gicl_claims.assured_name%TYPE,
        dsp_loss_date       gicl_claims.dsp_loss_date%TYPE,
        clm_file_date       gicl_claims.clm_file_date%TYPE,
        rec_no              VARCHAR2(20),
        rec_status          VARCHAR2(50),
        recoverable_amt     gicl_clm_recovery.recoverable_amt%TYPE,
        recovered_amt       gicl_clm_recovery.recovered_amt%TYPE,
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        date_type           VARCHAR(150)
    );
    
    TYPE giclr258_tab IS TABLE OF giclr258_type;
    
    FUNCTION get_giclr258_details(
        p_rec_type_cd       giis_recovery_type.rec_type_cd%TYPE,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_user_id           VARCHAR2 -- added by: Nica 5.27.2013
    ) RETURN giclr258_tab PIPELINED;
END GICLR258_PKG;
/



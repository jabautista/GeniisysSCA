CREATE OR REPLACE PACKAGE CPI.CSV_CLM_LISTING_PER_USER AS
    TYPE giclr271_rec_type IS RECORD ( policy_number    VARCHAR2(30),
                                       assured_name     gicl_claims.assured_name%TYPE,
                                       claim_number     VARCHAR2(26),
                                       dsp_loss_date    VARCHAR2(10),
                                       clm_file_date    VARCHAR2(10),
                                       entry_date       VARCHAR2(10),
                                       clm_stat_desc    giis_clm_stat.clm_stat_desc%TYPE,
                                       loss_dtls        gicl_claims.loss_dtls%TYPE,
                                       loss_res_amt     gicl_claims.loss_res_amt%TYPE,
                                       loss_pd_amt      gicl_claims.loss_pd_amt%TYPE,
                                       exp_res_amt      gicl_claims.exp_res_amt%TYPE,
                                       exp_pd_amt       gicl_claims.exp_pd_amt%TYPE,
                                       in_hou_adj       gicl_claims.in_hou_adj%TYPE
                                     );
    TYPE giclr271_type IS TABLE OF giclr271_rec_type;

    FUNCTION CSV_GICLR271 ( p_as_of_date    DATE,
                            p_from_date     DATE,
                            p_to_date       DATE,
                            p_search_type   VARCHAR2,
                            p_in_hou_adj    gicl_claims.in_hou_adj%TYPE
                          )
    RETURN giclr271_type PIPELINED;
END;
/



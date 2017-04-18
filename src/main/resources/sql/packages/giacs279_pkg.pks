CREATE OR REPLACE PACKAGE CPI.GIACS279_PKG
AS

    PROCEDURE get_initial_values(
        p_user          IN OUT  giac_lossrec_soa_ext_param.USER_ID%type,
        p_extract_date  OUT     giac_lossrec_soa_ext_param.EXTRACT_DATE%type,
        p_as_of_date    OUT     VARCHAR2,
        p_cut_off_date  OUT     VARCHAR2,
        p_ri_cd         OUT     giac_lossrec_soa_ext_param.RI_CD%type,
        p_line_cd       OUT     giac_lossrec_soa_ext_param.LINE_CD%type,
        p_clm_payt_tag  OUT     giac_lossrec_soa_ext_param.CLM_PAYT_TAG%type,
        p_ri_name       OUT     giis_reinsurer.RI_NAME%type,
        p_line_name     OUT     giis_line.LINE_NAME%type
    );    
    
    PROCEDURE check_dates(
        p_user          IN  giac_loss_rec_soa_ext.USER_ID%type,
        p_btn           IN  VARCHAR2,
        p_as_of_date    OUT VARCHAR2,
        p_cut_off_date  OUT VARCHAR2
    );
    
    PROCEDURE extract_table_old( --benjo 12.04.2015 UCPBGEN-SR-20083 replaced from EXTRACT_TABLE -> EXTRACT_TABLE_OLD
        p_as_of_date        IN  gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      IN  giac_acctrans.TRAN_DATE%type,
        p_ri_cd             IN  giis_reinsurer.RI_CD%type,
        p_line_cd           IN  giis_line.LINE_CD%type,
        p_payee_type        IN  gicl_advs_fla_type.PAYEE_TYPE%type,
        p_chk_claims        IN  VARCHAR2,
        p_chk_aging         IN  VARCHAR2,
        p_user              IN  giac_loss_rec_soa_ext.USER_ID%type,
        p_msg               OUT VARCHAR2
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table(
        p_as_of_date        IN  gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      IN  giac_acctrans.TRAN_DATE%type,
        p_ri_cd             IN  giis_reinsurer.RI_CD%type,
        p_line_cd           IN  giis_line.LINE_CD%type,
        p_payee_type        IN  gicl_advs_fla_type.PAYEE_TYPE%type,
        p_chk_claims        IN  VARCHAR2,
        p_chk_aging         IN  VARCHAR2,
        p_fc_param          IN  VARCHAR2,
        p_tp_param          IN  VARCHAR2,
        p_user              IN  giac_loss_rec_soa_ext.USER_ID%type,
        p_msg               OUT VARCHAR2
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ft(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_fp(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ct(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_cp(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ft_nc(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_fp_nc(
        p_as_of_date        gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      giac_acctrans.TRAN_DATE%type,
        p_ri_cd             giis_reinsurer.RI_CD%type,
        p_line_cd           giis_line.LINE_CD%type,
        p_payee_type        gicl_advs_fla_type.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    );
END GIACS279_PKG;
/



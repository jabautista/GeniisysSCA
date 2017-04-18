CREATE OR REPLACE PACKAGE CPI.gicl_no_claim_pkg
AS

    TYPE no_claim_listing_type IS RECORD (
        no_claim_id     gicl_no_claim.no_claim_id%TYPE,     
        no_claim_no     VARCHAR2(50),
        policy_no       VARCHAR2(50),
        assd_name       gicl_no_claim.assd_name%TYPE,
        eff_date        gicl_no_claim.eff_date%TYPE,
        expiry_date     gicl_no_claim.expiry_date%TYPE
    );

    TYPE no_claim_listing_tab IS TABLE OF no_claim_listing_type;
    
    TYPE gicl_no_claim_type IS RECORD (
        no_claim_id     gicl_no_claim.no_claim_id%TYPE,
        line_cd         gicl_no_claim.line_cd%TYPE,
        subline_cd      gicl_no_claim.subline_cd%TYPE,
        iss_cd          gicl_no_claim.iss_cd%TYPE,
        issue_yy        gicl_no_claim.issue_yy%TYPE,
        pol_seq_no      gicl_no_claim.pol_seq_no%TYPE,
        renew_no        gicl_no_claim.renew_no%TYPE,
        item_no         gicl_no_claim.item_no%TYPE,
        assd_no         gicl_no_claim.assd_no%TYPE,
        assd_name       gicl_no_claim.assd_name%TYPE,
        eff_date        gicl_no_claim.eff_date%TYPE,
        expiry_date     gicl_no_claim.expiry_date%TYPE,
        nc_issue_date   gicl_no_claim.nc_issue_date%TYPE,
        nc_type_cd      gicl_no_claim.nc_type_cd%TYPE,
        model_year      gicl_no_claim.model_year%TYPE,
        make_cd         gicl_no_claim.make_cd%TYPE,
        item_title      gicl_no_claim.item_title%TYPE,
        motor_no        gicl_no_claim.motor_no%TYPE,
        serial_no       gicl_no_claim.serial_no%TYPE,
        plate_no        gicl_no_claim.plate_no%TYPE,
        basic_color_cd  gicl_no_claim.basic_color_cd%TYPE,
        color_cd        gicl_no_claim.color_cd%TYPE,
        amount          gicl_no_claim.amount%TYPE,
        cpi_rec_no      gicl_no_claim.cpi_rec_no%TYPE,
        cpi_branch_cd   gicl_no_claim.cpi_branch_cd%TYPE,
        user_id         gicl_no_claim.user_id%TYPE,
        last_update     gicl_no_claim.last_update%TYPE,
        print_tag       gicl_no_claim.print_tag%TYPE,
        location        gicl_no_claim.location%TYPE,
        nc_loss_date    gicl_no_claim.nc_loss_date%TYPE,
        cancel_tag      gicl_no_claim.cancel_tag%TYPE,
        nc_seq_no       gicl_no_claim.nc_seq_no%TYPE,
        nc_iss_cd       gicl_no_claim.nc_iss_cd%TYPE,
        nc_issue_yy     gicl_no_claim.nc_issue_yy%TYPE,
        remarks         gicl_no_claim.remarks%TYPE,
        motcar_comp_cd  gicl_no_claim.motcar_comp_cd%TYPE,
        car_company     giis_mc_car_company.car_company%TYPE,
        make            giis_mc_make.make%TYPE,
        basic_color     giis_mc_color.basic_color%TYPE,
        color           giis_mc_color.color%TYPE,
        no_claim_no     VARCHAR2(50),
        policy_no       VARCHAR2(50),
        menu_line_cd    giis_line.menu_line_cd%TYPE,
        line_cd_mc      giis_parameters.param_value_v%TYPE
    );
    
    TYPE gicl_no_claim_tab IS TABLE OF gicl_no_claim_type;
              
    PROCEDURE check_no_claim(
        p_line_cd                    IN     GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd                 IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd                 IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy                   IN     GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no                 IN     GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no                   IN     GIPI_POLBASIC.renew_no%TYPE, 
        p_dsp_loss_date              IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_time                       IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_msg_alert                 OUT     VARCHAR2
        );
        
    FUNCTION get_no_claim_listing(
        p_assd_name     gicl_no_claim.assd_name%TYPE,
        p_nc_iss_cd     gicl_no_claim.nc_iss_cd%TYPE,
        p_nc_issue_yy   gicl_no_claim.nc_issue_yy%TYPE,
        p_nc_seq_no     gicl_no_claim.nc_seq_no%TYPE,
        p_line_cd       gicl_no_claim.line_cd%TYPE,
        p_subline_cd    gicl_no_claim.subline_cd%TYPE,
        p_iss_cd        gicl_no_claim.iss_cd%TYPE,
        p_issue_yy      gicl_no_claim.issue_yy%TYPE,
        p_pol_seq_no    gicl_no_claim.pol_seq_no%TYPE,
        p_renew_no      gicl_no_claim.renew_no%TYPE,
		p_user_id       GIIS_USERS.user_NAME%TYPE --added by steven 11.16.2012
    )
    RETURN no_claim_listing_tab PIPELINED;
    
    FUNCTION get_no_claim_details(
        p_no_claim_id   gicl_no_claim.no_claim_id%TYPE
    )
    RETURN gicl_no_claim_tab PIPELINED;
    
    PROCEDURE get_details_gicls026(
        p_line_cd       IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no      IN gipi_polbasic.renew_no%TYPE,
        p_nc_loss_date  IN gipi_polbasic.eff_date%TYPE,
        p_assd_no      OUT gipi_polbasic.assd_no%TYPE,
        p_assd_name    OUT giis_assured.assd_name%TYPE,
        p_expiry_date  OUT VARCHAR2,
        p_eff_date     OUT VARCHAR2       
    );
    
    PROCEDURE insert_new_record_gicls026(
        p_line_cd            IN   GICL_NO_CLAIM.line_cd%TYPE,
        p_subline_cd         IN   GICL_NO_CLAIM.subline_cd%TYPE, 
        p_iss_cd             IN   GICL_NO_CLAIM.iss_cd%TYPE, 
        p_issue_yy           IN   GICL_NO_CLAIM.issue_yy%TYPE, 
        p_pol_seq_no         IN   GICL_NO_CLAIM.pol_seq_no%TYPE,
        p_renew_no           IN   GICL_NO_CLAIM.renew_no%TYPE, 
        p_item_no            IN   GICL_NO_CLAIM.item_no%TYPE, 
        p_assd_no            IN   GICL_NO_CLAIM.assd_no%TYPE, 
        p_assd_name          IN   GICL_NO_CLAIM.assd_name%TYPE, 
        p_eff_date           IN   GICL_NO_CLAIM.eff_date%TYPE, 
        p_expiry_date        IN   GICL_NO_CLAIM.expiry_date%TYPE,
        p_model_year         IN   GICL_NO_CLAIM.model_year%TYPE, 
        p_make_cd            IN   GICL_NO_CLAIM.make_cd%TYPE, 
        p_item_title         IN   GICL_NO_CLAIM.item_title%TYPE, 
        p_motor_no           IN   GICL_NO_CLAIM.motor_no%TYPE,
        p_serial_no          IN   GICL_NO_CLAIM.serial_no%TYPE, 
        p_plate_no           IN   GICL_NO_CLAIM.plate_no%TYPE, 
        p_basic_color_cd     IN   GICL_NO_CLAIM.basic_color_cd%TYPE, 
        p_color_cd           IN   GICL_NO_CLAIM.color_cd%TYPE, 
        p_amount             IN   GICL_NO_CLAIM.amount%TYPE, 
        p_user_id            IN   GICL_NO_CLAIM.user_id%TYPE, 
        p_location           IN   GICL_NO_CLAIM.location%TYPE, 
        --p_nc_loss_date       IN   GICL_NO_CLAIM.nc_loss_date%TYPE, 
        p_nc_loss_date       IN   VARCHAR2,
        p_cancel_tag         IN   GICL_NO_CLAIM.cancel_tag%TYPE, 
        p_remarks            IN   GICL_NO_CLAIM.remarks%TYPE, 
        p_motcar_comp_cd     IN   GICL_NO_CLAIM.motcar_comp_cd%TYPE,
        v_no_claim_id       OUT   GICL_NO_CLAIM.no_claim_id%TYPE,
        p_msg               OUT   VARCHAR2
    );
    
    PROCEDURE get_signatory(
        p_report_id     IN giac_documents.report_id%TYPE,
        p_iss_cd        IN giac_documents.branch_cd%TYPE,
        p_line_cd       IN giac_documents.line_cd%TYPE,
        p_msg          OUT VARCHAR2
    );
        
END gicl_no_claim_pkg;
/



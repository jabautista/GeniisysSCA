CREATE OR REPLACE PACKAGE CPI.GICL_NO_CLAIM_MULTI_PKG
AS
/**
* Rey Jadlocon
* 09-12-2011
**/
FUNCTION get_no_clm_id
   RETURN NUMBER;
  
 TYPE get_no_claim_multi_yy_type IS RECORD(
        no_claim_no                         VARCHAR2(50),
        plate_no                            gicl_no_claim_multi.plate_no%TYPE,
        motor_no                            gicl_no_claim_multi.motor_no%TYPE,
        serial_no                           gicl_no_claim_multi.serial_no%TYPE,
        assd_no                             gicl_no_claim_multi.assd_no%TYPE,
        no_claim_id                         gicl_no_claim_multi.no_claim_id%TYPE,
        nc_iss_cd                           gicl_no_claim_multi.nc_iss_cd%TYPE,
        make_cd                             gicl_no_claim_multi.make_cd%TYPE,
        assd_name                           giis_assured.assd_name%TYPE,
        car_company                         giis_mc_car_company.car_company%TYPE,
        make                                VARCHAR2(100),--gipi_vehicle.make%TYPE,
        basic_color_cd                      giis_mc_color.basic_color_cd%TYPE,
        color_cd                            giis_mc_color.color_cd%TYPE,
        remarks                             gicl_no_claim_multi.remarks%TYPE,
        basic_color                         giis_mc_color.basic_color%TYPE,
        color                               giis_mc_color.color%TYPE,
        user_id                             gicl_no_claim_multi.user_id%TYPE,
        last_update                         VARCHAR2(50),
        model_year                          NUMBER,
        cancel_tag                          VARCHAR2(1),
        iss_cd                                VARCHAR2(10),
        issue_yy                            NUMBER,
        nc_seq_no                            NUMBER,
        motcar_comp_cd                        VARCHAR2(100),
        issue_date                            DATE,
        claim_id                            NUMBER,
        no_issue_date                        DATE,
        nc_issue_date                        DATE,
        nc_issue_yy                            NUMBER
        
        );
        
     
  TYPE get_no_claim_multi_yy_tab IS TABLE OF get_no_claim_multi_yy_type;

 FUNCTION get_no_claim_multi_yy(p_user_id VARCHAR2)
        RETURN get_no_claim_multi_yy_tab PIPELINED;
        
/**
* Rey Jadlocon
* 14-12-2011
**/
FUNCTION get_no_claim_details_multi_yy(p_no_claim_id          gicl_no_claim_multi.no_claim_id%TYPE)
        RETURN get_no_claim_multi_yy_tab PIPELINED;

/**
* Rey Jadlocon
* 15-12-2011
**/

    TYPE get_color_basic_color_type IS RECORD(
            basic_color             giis_mc_color.basic_color%TYPE,
            color                   giis_mc_color.color%TYPE);
    TYPE get_color_basic_color_tab IS TABLE OF get_color_basic_color_type;
   
   
FUNCTION get_color_basic_color(p_basic_color_cd          giis_mc_color.basic_color_cd%TYPE,
                               p_color_cd                giis_mc_color.color_cd%TYPE)
        RETURN get_color_basic_color_tab PIPELINED;
        
/**
* Rey Jadlocon
* 15-12-2011
**/

TYPE no_claim_policy_list_type IS RECORD(
            policy_no           VARCHAR2(100),
            policy_id           gipi_polbasic.policy_id%TYPE,
            plate_no            gipi_vehicle.plate_no%TYPE,
            line_cd             gipi_polbasic.line_cd%TYPE,
            subline_cd          gipi_polbasic.subline_cd%TYPE,
            iss_cd              gipi_polbasic.iss_cd%TYPE,
            issue_yy            gipi_polbasic.issue_yy%TYPE,
            pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
            renew_no            gipi_polbasic.renew_no%TYPE,
            eff_date            gipi_polbasic.eff_date%TYPE,
            expiry_date         gipi_polbasic.expiry_date%TYPE,
            incept_date         gipi_polbasic.incept_date%TYPE,
            ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
            nbt_line_cd         gipi_parlist.line_cd%TYPE,
            nbt_iss_cd          gipi_parlist.iss_cd%TYPE,
            par_yy              gipi_parlist.par_yy%TYPE,
            par_seq_no          gipi_parlist.par_seq_no%TYPE,
            quote_seq_no        gipi_parlist.quote_seq_no%TYPE,
            issue_date          date,
            assd_name           varchar2(100),
            mean_pol_flag       varchar2(100),
            line_cd_rn          varchar2(100),
            iss_cd_rn           varchar2(100),
            rn_yy               giex_rn_no.rn_yy%TYPE,
            rn_seq_no           giex_rn_no.rn_seq_no%TYPE,
            cred_branch         varchar2(100),
            pack_pol_no         varchar2(100),
            menu_line_cd        varchar2(100),
            line_cd_mc          varchar2(100),
			str_incept_date     varchar2(20), -- added string variation 7.30.2012
			str_expiry_date     varchar2(20)
			
			);
          
   TYPE no_claim_policy_list_tab IS TABLE OF no_claim_policy_list_type;
   
   FUNCTION get_claim_multi_policy_list(p_plate_no             gicl_no_claim_multi.plate_no%TYPE,
   										p_serial_no      gicl_no_claim_multi.serial_no%TYPE,
                                        p_motor_no       gicl_no_claim_multi.motor_no%TYPE,
                                        p_user_id              giis_users.user_id%TYPE)
        RETURN no_claim_policy_list_tab PIPELINED;
        
  
        
   
/**
* Rey Jadlocon
* 19-12-2011
**/        
PROCEDURE insert_in_gicl_cnc_dtl(p_plate_no             gipi_vehicle.plate_no%TYPE,
                                 p_no_claim_id          gicl_no_claim_multi.no_claim_id%TYPE);
                               
/**
* Rey Jadlocon
* 20-12-2011
**/
TYPE assd_lov_type IS RECORD(
        assd_no         giis_assured.assd_no%TYPE,
        assd_name       giis_assured.assd_name%TYPE);

    TYPE assd_lov_tab IS TABLE OF assd_lov_type;
    
       
FUNCTION get_assd_lov(p_find_text           varchar2,
					  p_module_id           GIIS_MODULES.module_id%TYPE,
                      p_user_id             GIIS_USERS.user_NAME%TYPE)
            RETURN  assd_lov_tab  PIPELINED;
            
/**
* Rey Jadlocon
* 20-12-2011
**/
  TYPE plate_grp_lov_type IS RECORD(
        plate_no            gipi_vehicle.plate_no%TYPE,
        serial_no           gipi_vehicle.serial_no%TYPE,
        motor_no            gipi_vehicle.motor_no%TYPE);
 TYPE plate_grp_lov_tab IS TABLE OF plate_grp_lov_type;
 
FUNCTION get_plate_grp_lov(p_assd_no        giis_assured.assd_no%TYPE)
        RETURN plate_grp_lov_tab PIPELINED;
        
/**
* Rey Jadlocon
* 22-12-2011
**/
TYPE get_user_last_update_type IS RECORD(
        user_id             gicl_no_claim.user_id%TYPE,
        last_update         gicl_no_claim.last_update%TYPE
  );
  TYPE get_user_last_update_tab IS TABLE OF get_user_last_update_type;
  
  FUNCTION get_user_last_update(p_no_claim_id         gicl_no_claim_multi.no_claim_id%TYPE)
        RETURN get_user_last_update_tab PIPELINED;
        
/**
* Rey Jadlocon
* 29-12-2011
**/
FUNCTION GEN_NC_NO(P_NC_ISS_CD          GICL_NO_CLAIM.NC_ISS_CD%TYPE,
                   P_NC_ISSUE_YY        GICL_NO_CLAIM.NC_ISSUE_YY%TYPE)
    RETURN NUMBER;
     
/**
* Rey Jadlocon
* 01-03-2012
**/
TYPE get_no_claim_multi_yy_type2 IS RECORD(
        car_company_cd            gipi_vehicle.car_company_cd%TYPE,
        make_cd                   gipi_vehicle.make_cd%TYPE,
        car_company               giis_mc_car_company.car_company%TYPE,
        model_year                gipi_vehicle.model_year%TYPE,
        make                      gipi_vehicle.make%TYPE,
        basic_color_cd            gipi_vehicle.basic_color_cd%TYPE,
        color_cd                  gipi_vehicle.color_cd%TYPE,
        color                     gipi_vehicle.color%TYPE,
        assd_no                   gicl_no_claim_multi.assd_no%TYPE,
        serial_no                 gicl_no_claim_multi.serial_no%TYPE,
        motor_no                  gipi_vehicle.motor_no%TYPE,
        message                   VARCHAR2(100),
        basic_color               giis_mc_color.basic_color%TYPE,
        assd_name                 giis_assured.assd_name%TYPE ,
        plate_no                  gipi_vehicle.plate_no%TYPE
        
                );
   TYPE get_no_claim_multi_yy_tab2 IS TABLE OF get_no_claim_multi_yy_type2;

 
 
 FUNCTION populate_noclmmultiyy_details(p_assd_no            gicl_no_claim_multi.assd_no%TYPE,
                           p_plate_no           gicl_no_claim_multi.plate_no%TYPE,
                           p_serial_no          gicl_no_claim_multi.serial_no%TYPE,
                           p_motor_no           gicl_no_claim_multi.motor_no%TYPE)
                    RETURN get_no_claim_multi_yy_tab2 PIPELINED;
                           
/**
* Rey Jadlocon
* 01-03-2012
**/         
TYPE block_gpb_details_type IS RECORD(
        policy_id               gipi_polbasic.policy_id%TYPE,
        plate_no                gipi_vehicle.plate_no%TYPE,
        line_cd                 gipi_polbasic.line_cd%TYPE,
        subline_cd              gipi_polbasic.subline_cd%TYPE,
        iss_cd                  gipi_polbasic.iss_cd%TYPE,
        issue_yy                gipi_polbasic.issue_yy%TYPE,
        pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
        renew_no                gipi_polbasic.renew_no%TYPE,
        eff_date                gipi_polbasic.eff_date%TYPE,
        expiry_date             gipi_polbasic.expiry_date%TYPE);
    
    TYPE block_gpb_details_tab IS TABLE OF block_gpb_details_type;


FUNCTION get_block_gpb_details(p_assd_no            gicl_no_claim_multi.assd_no%TYPE,
                               p_plate_no           gicl_no_claim_multi.plate_no%TYPE)
               RETURN block_gpb_details_tab PIPELINED;     
               
/**
* Rey Jadlocon
* 01-03-2012
**/         
FUNCTION on_key_commit(p_assd_no               gicl_no_claim_multi.assd_no%TYPE,
                        p_plate_no              gicl_no_claim_multi.plate_no%TYPE,
                        p_serial_no             gicl_no_claim_multi.serial_no%TYPE,
                        p_motor_no              gicl_no_claim_multi.motor_no%TYPE)
RETURN VARCHAR2;                 

/**
* Rey Jadlocon
* 01-03-2012
**/
--FUNCTION get_populate_noclmmultiyy_dtl(p_assd_no            gicl_no_claim_multi.assd_no%TYPE,
--                           p_plate_no           gicl_no_claim_multi.plate_no%TYPE,
--                           p_serial_no          gicl_no_claim_multi.serial_no%TYPE,
--                           p_motor_no           gicl_no_claim_multi.motor_no%TYPE)
--        RETURN get_no_claim_multi_yy_tab2 PIPELINED;
        
/**
* Rey Jadlocon
* 01-04-2012
**/        
FUNCTION get_param_value
        RETURN VARCHAR2;
        
/**
* Rey Jadlocon
* 01-06-2012
**/       
TYPE add_dtls_type IS RECORD(
        nc_iss_cd               giac_parameters.param_value_v%TYPE,
        nc_issue_date           DATE,
        nc_last_update          DATE,
        nc_no_claim_id          NUMBER,
        nc_issue_yy             NUMBER,
        nc_seq_no               NUMBER,
        nc_no_claim_no          VARCHAR2(500));
        
     TYPE add_dtls_tab IS TABLE OF add_dtls_type;
     
   FUNCTION get_additional_dtls
    RETURN add_dtls_tab PIPELINED;
    
/**
* Rey Jadlocon
* 01-10-2012
**/
PROCEDURE set_gicl_no_claim_multi(p_no_claim_id             NUMBER, 
                                p_nc_iss_cd                       VARCHAR2,   
                                p_nc_issue_yy                     NUMBER, 
                                p_nc_seq_no                       NUMBER,   
                                p_assd_no                         NUMBER, 
                                p_no_issue_date                   date,   
                                p_motor_no                        VARCHAR2,  
                                p_serial_no                       VARCHAR2,   
                                p_plate_no                        VARCHAR2,  
                                p_model_year                      VARCHAR2,
                                p_make_cd                         NUMBER, 
                                p_motcar_comp_cd                  NUMBER,
                                p_basic_color_cd                  VARCHAR2,                   
                                p_color_cd                        NUMBER,  
                                p_cancel_tag                      VARCHAR2,
                                p_remarks                         VARCHAR2, 
                                p_cpi_rec_no                      NUMBER,
                                p_cpi_branch_cd                   VARCHAR2,   
                                p_user_id                         VARCHAR2);

/**
* Rey Jadlocon
* 05-04-2012
**/
TYPE update_details_type IS RECORD(
          no_claim_no                         VARCHAR2(50),
        plate_no                            gicl_no_claim_multi.plate_no%TYPE,
        motor_no                            gicl_no_claim_multi.motor_no%TYPE,
        serial_no                           gicl_no_claim_multi.serial_no%TYPE,
        assd_no                             gicl_no_claim_multi.assd_no%TYPE,
        no_claim_id                         gicl_no_claim_multi.no_claim_id%TYPE,
        nc_iss_cd                           gicl_no_claim_multi.nc_iss_cd%TYPE,
        make_cd                             gicl_no_claim_multi.make_cd%TYPE,
        assd_name                           giis_assured.assd_name%TYPE,
        car_company                         giis_mc_car_company.car_company%TYPE,
        make                                gipi_vehicle.make%TYPE,
        basic_color_cd                      giis_mc_color.basic_color_cd%TYPE,
        color_cd                            giis_mc_color.color_cd%TYPE,
        remarks                             gicl_no_claim_multi.remarks%TYPE,
        basic_color                         giis_mc_color.basic_color%TYPE,
        color                               giis_mc_color.color%TYPE,
        user_id                             gicl_no_claim_multi.user_id%TYPE,
        last_update                         VARCHAR2(50),
        model_year                          NUMBER,
        cancel_tag                          VARCHAR2(1),
        iss_cd                                VARCHAR2(10),
        issue_yy                            NUMBER,
        nc_seq_no                            NUMBER,
        motcar_comp_cd                        VARCHAR2(100),
        issue_date                            DATE,
        claim_id                            NUMBER,
        no_issue_date                        DATE,
        nc_issue_date                        DATE,
        nc_issue_yy                            NUMBER,
        nc_last_update                        DATE);
    TYPE update_details_tab IS TABLE OF update_details_type;
    
FUNCTION get_update_details(p_no_claim_id            NUMBER)
         RETURN update_details_tab PIPELINED;
		 
FUNCTION GET_POL_LIST_BY_PLATE_NO(P_PLATE_NO gicl_no_claim_multi.PLATE_NO%TYPE) 
	RETURN 	no_claim_policy_list_tab PIPELINED;	 
   
   FUNCTION get_policy_count(p_plate_no   gicl_no_claim_multi.plate_no%TYPE)
   RETURN NUMBER;
END GICL_NO_CLAIM_MULTI_PKG;
/



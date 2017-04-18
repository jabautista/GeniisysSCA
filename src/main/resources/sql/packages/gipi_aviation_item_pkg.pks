CREATE OR REPLACE PACKAGE CPI.Gipi_Aviation_Item_Pkg
AS

    TYPE gipi_aviation_type IS RECORD(
         vessel_cd                GIPI_AVIATION_ITEM.vessel_cd%TYPE,
         total_fly_time          GIPI_AVIATION_ITEM.total_fly_time%TYPE,
         qualification             GIPI_AVIATION_ITEM.qualification%TYPE,
         purpose                 GIPI_AVIATION_ITEM.purpose%TYPE,
         geog_limit                GIPI_AVIATION_ITEM.geog_limit%TYPE,
         deduct_text             GIPI_AVIATION_ITEM.deduct_text%TYPE,
         rec_flag                 GIPI_AVIATION_ITEM.rec_flag%TYPE,
         fixed_wing                GIPI_AVIATION_ITEM.fixed_wing%TYPE,
         rotor                    GIPI_AVIATION_ITEM.rotor%TYPE,
         prev_util_hrs            GIPI_AVIATION_ITEM.prev_util_hrs%TYPE,
         est_util_hrs            GIPI_AVIATION_ITEM.est_util_hrs%TYPE,
         policy_id              GIPI_AVIATION_ITEM.policy_id%TYPE,
         item_no                GIPI_AVIATION_ITEM.item_no%TYPE,
         air_desc            giis_air_type.air_desc%TYPE
        );

    TYPE gipi_aviation_tab IS TABLE OF gipi_aviation_type;

    FUNCTION get_gipi_aviation_item (
        p_policy_id     GIPI_AVIATION_ITEM.policy_id%TYPE,
        p_item_no       GIPI_AVIATION_ITEM.item_no%TYPE)
    RETURN gipi_aviation_tab PIPELINED;

  TYPE aviation_item_info_type IS RECORD(
    
    policy_id           gipi_aviation_item.policy_id%TYPE,
    item_no             gipi_aviation_item.item_no%TYPE,
    vessel_cd           gipi_aviation_item.vessel_cd%TYPE,
    geog_limit          gipi_aviation_item.geog_limit%TYPE,
    qualification       gipi_aviation_item.qualification%TYPE,
    total_fly_time      gipi_aviation_item.total_fly_time%TYPE,
    prev_util_hrs       gipi_aviation_item.prev_util_hrs%TYPE,
    est_util_hrs        gipi_aviation_item.est_util_hrs%TYPE,
    deduct_text         gipi_aviation_item.deduct_text%TYPE,
    purpose             gipi_aviation_item.purpose%TYPE,
    
    vessel_name         giis_vessel.vessel_name%TYPE,
    air_desc            giis_air_type.air_desc%TYPE,
    item_title          gipi_item.item_title%TYPE,
    rpc_no              giis_vessel.rpc_no%TYPE
    
    
  );
    
  TYPE aviation_item_info_tab IS TABLE OF aviation_item_info_type;

  FUNCTION get_aviation_item_info(
     p_policy_id   gipi_aviation_item.policy_id%TYPE,
     p_item_no     gipi_aviation_item.item_no%TYPE
  )
     RETURN aviation_item_info_tab PIPELINED;
     
END;
/



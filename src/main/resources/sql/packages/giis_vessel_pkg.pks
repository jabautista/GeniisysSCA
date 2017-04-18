CREATE OR REPLACE PACKAGE CPI.GIIS_VESSEL_PKG AS

  TYPE marine_hull_type is RECORD(
         VESSEL_CD         GIIS_VESSEL.vessel_cd%TYPE,
         VESSEL_NAME       GIIS_VESSEL.vessel_name%TYPE,
         VESSEL_FLAG       GIIS_VESSEL.vessel_flag%TYPE,
         VESSEL_OLD_NAME   GIIS_VESSEL.vessel_old_name%TYPE,
         VESTYPE_CD        GIIS_VESSEL.vestype_cd%TYPE,
         VESTYPE_DESC      GIIS_VESTYPE.vestype_desc%TYPE,
         PROPEL_SW         VARCHAR2(50),--GIIS_VESSEL.propel_sw%TYPE,
         HULL_TYPE_CD      GIIS_VESSEL.hull_type_cd%TYPE,
         HULL_DESC         GIIS_HULL_TYPE.hull_desc%TYPE,
         GROSS_TON         GIIS_VESSEL.gross_ton%TYPE,
         YEAR_BUILT        GIIS_VESSEL.year_built%TYPE,
         VESS_CLASS_CD     GIIS_VESSEL.vess_class_cd%TYPE,
         VESS_CLASS_DESC   GIIS_VESS_CLASS.vess_class_desc%TYPE,
         REG_OWNER         GIIS_VESSEL.reg_owner%TYPE,
         REG_PLACE         GIIS_VESSEL.reg_place%TYPE,
   NO_CREW      GIIS_VESSEL.no_crew%TYPE,
   NET_TON     GIIS_VESSEL.net_ton%TYPE,
   DEADWEIGHT     GIIS_VESSEL.deadweight%TYPE,
   CREW_NAT     GIIS_VESSEL.crew_nat%TYPE,
   VESSEL_BREADTH    GIIS_VESSEL.vessel_breadth%TYPE,
   VESSEL_DEPTH      GIIS_VESSEL.vessel_depth%TYPE,
   VESSEL_LENGTH    GIIS_VESSEL.vessel_length%TYPE,
   DRY_PLACE     GIIS_VESSEL.dry_place%TYPE,
   DRY_DATE     GIIS_VESSEL.dry_date%TYPE,
   ENDORSED_TAG    VARCHAR2(1)
  );

  TYPE marine_hull_tab IS TABLE OF marine_hull_type;

  TYPE pol_doc_vessel_type IS RECORD(
         vessel_vessel_cd      GIIS_VESSEL.vessel_cd%TYPE,
         vessel_vessel_name    VARCHAR2(200),
         vessel_serial_no      GIIS_VESSEL.serial_no%TYPE,
   vessel_motor_no      GIIS_VESSEL.motor_no%TYPE,
         vessel_plate_no       GIIS_VESSEL.plate_no%TYPE,
   vessel_vestype_cd     GIIS_VESSEL.vestype_cd%TYPE
         );

  TYPE pol_doc_vessel_tab IS TABLE OF pol_doc_vessel_type;

  TYPE air_vessel_list_type IS RECORD(
      vessel_cd      GIIS_VESSEL.vessel_cd%TYPE,
    vessel_name      GIIS_VESSEL.vessel_name%TYPE,
    rpc_no       GIIS_VESSEL.rpc_no%TYPE,
    vessel_flag      GIIS_VESSEL.vessel_flag%TYPE,
    air_desc       GIIS_AIR_TYPE.air_desc%TYPE,
    vessel_old_name     GIIS_VESSEL.vessel_old_name%TYPE,
    air_type_cd      GIIS_AIR_TYPE.air_type_cd%TYPE,
    no_pass       GIIS_VESSEL.no_pass%TYPE
  );

  TYPE air_vessel_list_tab IS TABLE OF air_vessel_list_type;

  TYPE giis_vessel_type IS RECORD(
         vessel_cd             GIIS_VESSEL.vessel_cd%TYPE,
         vessel_name        GIIS_VESSEL.vessel_name%TYPE,
         vessel_flag     GIIS_VESSEL.vessel_flag%TYPE,
   vessel_serial_no      GIIS_VESSEL.serial_no%TYPE,
   vessel_motor_no      GIIS_VESSEL.motor_no%TYPE,
   vessel_plate_no       GIIS_VESSEL.plate_no%TYPE,
   vessel_old_name       GIIS_VESSEL.vessel_old_name%TYPE,
   vessel_rpc_no      GIIS_VESSEL.rpc_no%TYPE,
   vessel_air_type_cd    GIIS_VESSEL.air_type_cd%TYPE,
         vessel_air_desc       giis_air_type.air_desc%TYPE,
   vessel_no_pass     GIIS_VESSEL.no_pass%TYPE,
   vessel_type     VARCHAR2(10));

  TYPE giis_vessel_tab IS TABLE OF giis_vessel_type;

  FUNCTION get_pol_doc_vessel(p_vessel_cd    GIIS_VESSEL.vessel_cd%TYPE)
    RETURN pol_doc_vessel_tab PIPELINED;

 
  TYPE vessel_list_type IS RECORD(
         vessel_cd             GIIS_VESSEL.vessel_cd%TYPE,
         vessel_name        GIIS_VESSEL.vessel_name%TYPE,
         vessel_flag     GIIS_VESSEL.vessel_flag%TYPE,
         vessel_type     VARCHAR2(10));

  TYPE vessel_list_tab IS TABLE OF vessel_list_type;

  FUNCTION get_vessel_list
    RETURN vessel_list_tab PIPELINED;

  FUNCTION get_marine_hull_list2(p_line_cd       gipi_wpolbas.line_cd%TYPE,
         p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
         p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
         p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
         p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
         p_renew_no      gipi_wpolbas.renew_no%TYPE)
    RETURN marine_hull_tab PIPELINED;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS006
  RECORD GROUP NAME: CGFK$B340_DSP_VESSEL_NAME
  CREATED BY: Jerome Orio 04-15-2010
***********************************************************************************/

  FUNCTION get_vessel_list2(p_par_id    gipi_wves_air.par_id%TYPE,
               p_geog_cd      giis_geog_class.geog_cd%TYPE)
    RETURN giis_vessel_tab PIPELINED;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS006
  RECORD GROUP NAME: CARRIER
  CREATED BY: Jerome Orio 04-20-2010
***********************************************************************************/

  FUNCTION get_vessel_carrier_list(p_par_id    gipi_wves_air.par_id%TYPE)
    RETURN giis_vessel_tab PIPELINED;

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS019
  RECORD GROUP NAME: CGFK$B950_DSP_VESSEL_NAME
  CREATED BY: Jerome Orio 04-26-2010
***********************************************************************************/

  FUNCTION get_vessel_list3(p_par_id    gipi_waviation_item.par_id%TYPE)
    RETURN giis_vessel_tab PIPELINED;

/********************************** FUNCTION 5 ************************************
  MODULE: GIPIS019
  RECORD GROUP NAME: CGFK$B950_DSP_VESSEL_NAME2
  CREATED BY: Jerome Orio 04-26-2010
***********************************************************************************/

  FUNCTION get_vessel_list4
    RETURN giis_vessel_tab PIPELINED;


  FUNCTION get_marine_hull_list--p_vessel_cd       GIIS_VESSEL.vessel_cd%TYPE)
    RETURN marine_hull_tab PIPELINED;

/********************************** FUNCTION 6 ************************************
  MODULE: GIIMM02
  RECORD GROUP NAME: AVIATION
  CREATED BY: Roy Encela 06-22-2010
***********************************************************************************/

  FUNCTION get_air_vessel_list
    RETURN air_vessel_list_tab PIPELINED;


/********************************** FUNCTION 7 ************************************
  MODULE: GIIMM02
  RECORD GROUP NAME: VESSEL
  CREATED BY: Roy Encela 06-22-2010
***********************************************************************************/
  FUNCTION get_quote_vessel_list(p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN giis_vessel_tab/*vessel_list_tab*/ PIPELINED;


  FUNCTION get_carrier_list (p_par_id  GIPI_POLBASIC.par_id%TYPE
                             --p_geog_cd GIIS_GEOG_CLASS.geog_cd%TYPE
                             )
    RETURN vessel_list_tab PIPELINED;

  FUNCTION validate_vessel (
         p_line_cd       gipi_wpolbas.line_cd%TYPE,
         p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
         p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
         p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
         p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
         p_renew_no      gipi_wpolbas.renew_no%TYPE,
         p_vessel_name   giis_vessel.vessel_name%TYPE
         )
    RETURN VARCHAR2;
/**
* Rey Jadlocon
* 08.18.2011
* carrier list
**/
TYPE get_carrie_list_type IS RECORD(
    vessel_cd       GIIS_VESSEL.VESSEL_CD%TYPE,
    vessel_name     GIIS_VESSEL.VESSEL_NAME%TYPE
    );
    TYPE get_carrie_list_tab IS TABLE OF get_carrie_list_type;
    
FUNCTION get_carrie_list(p_policy_id        gipi_cargo.policy_id%TYPE)
         RETURN  get_carrie_list_tab PIPELINED;
         
    FUNCTION get_vessel_carrier_list_tg(
        p_par_id IN gipi_wves_air.par_id%TYPE,
        p_vessel_name IN giis_vessel.vessel_name%TYPE)
    RETURN giis_vessel_tab PIPELINED;
    
    FUNCTION get_marine_hull_vessel_tg(
        p_par_id IN gipi_witem.par_id%TYPE,
        p_item_no IN gipi_witem.item_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN marine_hull_tab PIPELINED;
    
    
    FUNCTION get_vessel_list5(p_find_text IN VARCHAR2)
    RETURN giis_vessel_tab PIPELINED;
/**
* Patrick Cruz
* 02.24.2012
* carrier LOV list
**/
    FUNCTION get_aviation_vessel_tg(p_find_text IN VARCHAR2)
    RETURN giis_vessel_tab PIPELINED;
    
    FUNCTION get_aviation_lov
     RETURN air_vessel_list_tab PIPELINED;
     
    FUNCTION get_aviation_lov2(
      p_find_text       VARCHAR2
    )
     RETURN air_vessel_list_tab PIPELINED;
     
    FUNCTION get_marine_hull_lov
     RETURN marine_hull_tab PIPELINED;

END GIIS_VESSEL_PKG;
/



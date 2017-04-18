CREATE OR REPLACE PACKAGE CPI.gicls268_pkg
AS
   TYPE clm_list_per_plate_no_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      assd_no               giis_assured.assd_no%TYPE,
      item_no               gicl_motor_car_dtl.item_no%TYPE,
      item_title            gicl_motor_car_dtl.item_title%TYPE,
      plate_no              gicl_motor_car_dtl.plate_no%TYPE,
      loss_reserve          gicl_clm_reserve.loss_reserve%TYPE,
      losses_paid           gicl_clm_reserve.losses_paid%TYPE,
      expense_reserve       gicl_clm_reserve.expense_reserve%TYPE,
      expenses_paid         gicl_clm_reserve.expenses_paid%TYPE,
      assured_name          giis_assured.assd_name%TYPE,
      claim_no              VARCHAR2 (30),
      policy_no             VARCHAR2 (30),
      recovery_sw           VARCHAR2 (1),
      adverse_party         VARCHAR2 (1),
      third_party           VARCHAR2 (1),
      loss_date             gicl_claims.loss_date%TYPE,
      clm_file_date         gicl_claims.clm_file_date%TYPE,
      tot_loss_reserve      VARCHAR (50),
      tot_losses_paid       VARCHAR (50),
      tot_expense_reserve   VARCHAR (50),
      tot_expenses_paid     VARCHAR (50),
      vehicle_info_count    NUMBER (10),
      recovery_det_count    NUMBER (10),
      vehicle_type          NUMBER (1),
      subline_cd            VARCHAR (10)
   );

   TYPE clm_list_per_plate_no_tab IS TABLE OF clm_list_per_plate_no_type;

   FUNCTION get_gicls268_query (
      p_user_id    giis_users.user_id%TYPE,
      p_plate_no   gicl_mc_tp_dtl.plate_no%TYPE
   )
      RETURN clm_list_per_plate_no_tab PIPELINED;

   FUNCTION get_clm_list_per_plate_no (
      p_user_id    giis_users.user_id%TYPE,
      p_plate_no   gicl_mc_tp_dtl.plate_no%TYPE,
      p_search_by_opt     VARCHAR2,
      p_date_as_of        VARCHAR2,
      p_date_to           VARCHAR2,
      p_date_from         VARCHAR2
   )
      RETURN clm_list_per_plate_no_tab PIPELINED;

   TYPE plate_type IS RECORD (
      plate_no   gicl_motor_car_dtl.plate_no%TYPE
   );

   TYPE plate_tab IS TABLE OF plate_type;

   FUNCTION get_plate_no_gicls628
      RETURN plate_tab PIPELINED;

   TYPE vehicle_info_type IS RECORD (
      model_year        VARCHAR2 (4),
      motor_no          gicl_motor_car_dtl.motor_no%TYPE, --VARCHAR2 (25),  modified by Kris 07.02.2014 for MAC SR 16047
      serial_no         VARCHAR2 (25),
      mot_type          NUMBER (2),
      other_info        VARCHAR2 (2000),
      basic_color_cd    VARCHAR2 (7),
      color_cd          NUMBER (12),
      car_company_cd    NUMBER (6),
      make_cd           NUMBER (12),
      drvr_name         VARCHAR2 (100),
      drvr_occ_cd       VARCHAR2 (6),
      drvr_occ          VARCHAR(100),
      drvr_age          NUMBER (3),
      drvr_sex          VARCHAR2 (1),
      motor_type_desc   VARCHAR2 (100),
      color             VARCHAR (100),
      basic_color       VARCHAR (100),
      car_company       VARCHAR (100),
      make              VARCHAR (100),
      series_cd  VARCHAR(100),
      engine_series VARCHAR2(100)
   );

   TYPE vehicle_info_tab IS TABLE OF vehicle_info_type;

   FUNCTION get_vehicle_info (
      p_vehicle_type   NUMBER,
      p_claim_id       NUMBER,
      p_subline_cd     VARCHAR2
   )
      RETURN vehicle_info_tab PIPELINED;
END;
/



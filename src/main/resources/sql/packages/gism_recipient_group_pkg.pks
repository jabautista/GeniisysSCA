CREATE OR REPLACE PACKAGE CPI.GISM_RECIPIENT_GROUP_PKG
AS

   TYPE recipient_group_type IS RECORD(
      group_cd                   GISM_RECIPIENT_GROUP.group_cd%TYPE,
      group_name                 GISM_RECIPIENT_GROUP.group_name%TYPE                       
   );
   TYPE recipient_group_tab IS TABLE OF recipient_group_type;
   
   TYPE recipient_type IS RECORD(
      group_cd                   GISM_RECIPIENT_GROUP.group_cd%TYPE,
      group_name                 GISM_RECIPIENT_GROUP.group_name%TYPE,
      recipient                  VARCHAR2(500),
      cellphone_no               VARCHAR2(40),
      pk_column_value            GISM_MESSAGES_SENT_DTL.pk_column_value%TYPE
   );
   TYPE recipient_tab IS TABLE OF recipient_type;
   
   FUNCTION get_gisms004_group_lov
     RETURN recipient_group_tab PIPELINED;
     
   FUNCTION get_gisms004_recipient_lov(
      p_group_cd                 GISM_RECIPIENT_GROUP.group_cd%TYPE,
      p_bday_sw                  GISM_MESSAGES_SENT.bday_sw%TYPE,
      p_from_date                DATE,
      p_to_date                  DATE,
      p_default                  VARCHAR2,
      p_globe                    VARCHAR2,
      p_smart                    VARCHAR2,
      p_sun                      VARCHAR2
   )
     RETURN recipient_tab PIPELINED;
     
   PROCEDURE create_select(
      p_select          IN OUT   VARCHAR2,
      p_name_column     IN       VARCHAR2,
      p_cp_column       IN       VARCHAR2,
      p_globe_column    IN       VARCHAR2,
      p_smart_column    IN       VARCHAR2,
      p_sun_column      IN       VARCHAR2,
      p_default         IN       VARCHAR2,
      p_globe           IN       VARCHAR2,
      p_smart           IN       VARCHAR2,
      p_sun             IN       VARCHAR2,
      p_pk_column       IN       VARCHAR2
   );

END;
/



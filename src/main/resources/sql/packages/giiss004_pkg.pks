CREATE OR REPLACE PACKAGE CPI.GIISS004_PKG
AS
   TYPE rec_type IS RECORD (
      iss_cd            GIIS_ISSOURCE.ISS_CD%type,
      acct_iss_cd       GIIS_ISSOURCE.ACCT_ISS_CD%type,
      iss_grp           GIIS_ISSOURCE.ISS_GRP%type,
      iss_name          GIIS_ISSOURCE.ISS_NAME%type,
      region_cd         GIIS_ISSOURCE.REGION_CD%type,
      region_desc       GIIS_REGION.REGION_DESC%type,       
      claim_branch_cd   GIIS_ISSOURCE.CLAIM_BRANCH_CD%type,
      city              GIIS_ISSOURCE.CITY%type,
      address1          GIIS_ISSOURCE.ADDRESS1%type,
      address2          GIIS_ISSOURCE.ADDRESS2%type,
      address3          GIIS_ISSOURCE.ADDRESS3%type,
      branch_tin_cd     GIIS_ISSOURCE.BRANCH_TIN_CD%type,
      branch_website    GIIS_ISSOURCE.BRANCH_WEBSITE%type,
      tel_no            GIIS_ISSOURCE.TEL_NO%type,
      branch_fax_no     GIIS_ISSOURCE.BRANCH_FAX_NO%type,
      online_sw         GIIS_ISSOURCE.ONLINE_SW%type,
      cred_br_tag       GIIS_ISSOURCE.CRED_BR_TAG%type,
      claim_tag         GIIS_ISSOURCE.CLAIM_TAG%type,
      gen_invc_sw       GIIS_ISSOURCE.GEN_INVC_SW%type,
      ho_tag            GIIS_ISSOURCE.HO_TAG%type,
      active_tag        GIIS_ISSOURCE.ACTIVE_TAG%type,
      remarks           GIIS_ISSOURCE.REMARKS%type,
      user_id           GIIS_ISSOURCE.USER_ID%type,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_iss_cd            GIIS_ISSOURCE.ISS_CD%type,
      p_acct_iss_cd       GIIS_ISSOURCE.ACCT_ISS_CD%type,
      p_iss_name          GIIS_ISSOURCE.ISS_NAME%type,  
      p_online_sw         GIIS_ISSOURCE.ONLINE_SW%type,
      p_cred_br_tag       GIIS_ISSOURCE.CRED_BR_TAG%type,
      p_claim_tag         GIIS_ISSOURCE.CLAIM_TAG%type,
      p_gen_invc_sw       GIIS_ISSOURCE.GEN_INVC_SW%type,
      p_ho_tag            GIIS_ISSOURCE.HO_TAG%type,
      p_active_tag        GIIS_ISSOURCE.ACTIVE_TAG%type
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec GIIS_ISSOURCE%ROWTYPE);

   PROCEDURE del_rec (p_iss_cd  GIIS_ISSOURCE.ISS_CD%type);

   PROCEDURE val_del_rec(
      p_iss_cd          GIIS_ISSOURCE.iss_cd%TYPE,
      p_iss_grp         GIIS_GRP_ISSOURCE.ISS_GRP%type
   );
   
   PROCEDURE val_add_rec(
        p_iss_cd        GIIS_ISSOURCE.ISS_CD%type,
        p_acct_iss_cd   GIIS_ISSOURCE.ACCT_ISS_CD%type
   );   
   
   TYPE place_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE_PLACE.ISS_CD%type,
        place_cd                GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        orig_place_cd           GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        place                   GIIS_ISSOURCE_PLACE.PLACE%type,
        update_delete_allowed   VARCHAR2(1)
   );
   
   TYPE place_tab IS TABLE OF place_type;
   
   FUNCTION get_issource_place_list(
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        p_place       GIIS_ISSOURCE_PLACE.PLACE%type
   ) RETURN place_tab PIPELINED;
   
   PROCEDURE set_place_rec (p_rec  GIIS_ISSOURCE_PLACE%ROWTYPE);

   PROCEDURE del_place_rec (
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type
   );

   PROCEDURE val_del_place_rec (
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type
   );
   
   PROCEDURE val_add_place_rec(
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        p_place       GIIS_ISSOURCE_PLACE.PLACE%type
   );
   
   FUNCTION get_acct_iss_cd_list
     RETURN VARCHAR2;
   
END GIISS004_PKG;
/



CREATE OR REPLACE PACKAGE CPI.giiss014_pkg
AS
   TYPE industry_group_type IS RECORD (
      ind_grp_cd   giis_industry_group.ind_grp_cd%TYPE,
      ind_grp_nm   giis_industry_group.ind_grp_nm%TYPE
   );

   TYPE industry_group_tab IS TABLE OF industry_group_type;

   FUNCTION get_industry_group_lov
      RETURN industry_group_tab PIPELINED;

   TYPE giiss014_industry_type IS RECORD (
      industry_cd   giis_industry.industry_cd%TYPE,
      industry_nm   giis_industry.industry_nm%TYPE,
      ind_grp_cd    giis_industry.ind_grp_cd%TYPE,
      remarks       giis_industry.remarks%TYPE,
      user_id       giis_industry.user_id%TYPE,
      last_update   VARCHAR2(50)
   );

   TYPE giiss014_industry_tab IS TABLE OF giiss014_industry_type;

   FUNCTION get_giiss014_industry_list (p_ind_grp_cd VARCHAR2)
      RETURN giiss014_industry_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_industry%ROWTYPE);

   PROCEDURE del_rec (p_industry_cd VARCHAR2);

   PROCEDURE val_del_rec (p_industry_cd giis_industry.industry_cd%TYPE);

   PROCEDURE val_add_rec (p_industry_nm giis_industry.industry_nm%TYPE);

   PROCEDURE val_updated_rec (
      p_industry_cd   VARCHAR2,
      p_industry_nm   VARCHAR2
   );
END;
/



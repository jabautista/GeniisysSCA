CREATE OR REPLACE PACKAGE CPI.giiss205_pkg
AS
   TYPE rec_type IS RECORD (
      ind_grp_cd    giis_industry_group.ind_grp_cd%TYPE,
      ind_grp_nm    giis_industry_group.ind_grp_nm%TYPE,
      remarks       giis_industry_group.remarks%TYPE,
      user_id       giis_industry_group.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_ind_grp_cd   giis_industry_group.ind_grp_cd%TYPE,
      p_ind_grp_nm   giis_industry_group.ind_grp_nm%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_ind_grp_cd   giis_industry_group.ind_grp_cd%TYPE,
      p_ind_grp_nm   giis_industry_group.ind_grp_nm%TYPE
   );

   PROCEDURE val_del_rec (p_ind_grp_cd giis_industry_group.ind_grp_cd%TYPE);

   PROCEDURE set_rec (p_rec giis_industry_group%ROWTYPE);

   PROCEDURE del_rec (p_ind_grp_cd giis_industry_group.ind_grp_cd%TYPE);
END;
/



CREATE OR REPLACE PACKAGE CPI.LTO2 AS
 PROCEDURE MAIN_LTO2(
    v_date      varchar2,             --  by year/by date
    v_lto       varchar2,             --  lto / nlto
    v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
    v_iss_cd    varchar2,             --  ri business included/excluded
    v_zone      varchar2,             -- T/F
    v_zone_type varchar2,             --  C/O/P/B
    v_year      number,                -- year
    v_user      varchar2,             -- user
    v_sys       date);                -- last update date
 PROCEDURE LTO_BY_AD(
   v_date      varchar2,
   v_basis     varchar2,
   v_year      number,
   v_zone      varchar2,
   v_zone_type varchar2,
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
PROCEDURE LTO_BY_BD(
   v_date      varchar2,
   v_basis     varchar2,
   v_year      number,
   v_zone      varchar2,
   v_zone_type varchar2,
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
END;
/



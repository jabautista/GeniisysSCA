CREATE OR REPLACE PACKAGE CPI.LTO AS
 PROCEDURE MAIN_LTO(
    v_date      varchar2,             --  by year/by date
    v_lto       varchar2,             --  lto / nlto
    v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
    v_iss_cd    varchar2,             --  ri business included/excluded
    v_zone      varchar2,             -- T/F
    v_zone_type varchar2,             --  C/O/P/B
    v_date_from date,                 -- from date
    v_date_to   date,                 -- to date
    v_user      varchar2,             -- user
    v_sys       date);                -- last update date
 PROCEDURE LTO_BD_AD(
   v_date      varchar2,
   v_basis     varchar2,
   v_date_from date,
   v_date_to   date,
   v_zone      varchar2,
   v_zone_type varchar2,
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
 PROCEDURE LTO_BD_BD(
   v_date      varchar2,
   v_basis     varchar2,
   v_date_from date,
   v_date_to   date,
   v_zone      varchar2,
   v_zone_type varchar2,
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
END;
/



CREATE OR REPLACE PACKAGE CPI.NLTO AS
 PROCEDURE MAIN_NLTO(
    v_date      varchar2,             --  by year/by date
    v_lto       varchar2,             --  lto / nlto
    v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
    v_iss_cd    varchar2,             --  ri business included/excluded
    v_zone      varchar2,             --  T/F
    v_zone_type number,               --  1/2
    v_date_from date,
    v_date_to   date,
    v_user      varchar2,
    v_sys       date);
 PROCEDURE NLTO_BD_AD(
   v_basis     varchar2,
   v_date_from date,
   v_date_to   date,
   v_zone      VARCHAR2,              --T/F
   v_zone_type NUMBER,                --LUZON/WITHIN MANILA  COVERAGE
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
 PROCEDURE NLTO_BD_BD(
   v_basis     varchar2,
   v_date_from date,
   v_date_to   date,
   v_zone      VARCHAR2,              --T/F
   v_zone_type NUMBER,                --LUZON/WITHIN MANILA  COVERAGE
   v_iss_cd    varchar2,
   v_user      varchar2,
   v_sys       date);
END;
/



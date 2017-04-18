CREATE OR REPLACE PACKAGE CPI.NLTO2 AS
 PROCEDURE MAIN_NLTO2(
     v_date      varchar2,
     v_lto       varchar2,             --  lto / nlto
     v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
     v_iss_cd    varchar2,             --  ri business included/excluded
     v_zone      varchar2,
     v_zone_type NUMBER,
     v_year      number,
     v_user      varchar2,
     v_sys       date);
 PROCEDURE NLTO_BY_AD(
     v_basis     varchar2,
     v_year      number,
     v_zone       varchar2,
     v_zone_type   number,
     v_iss_cd      varchar2,
     v_user        varchar2,
     v_sys         date);
 PROCEDURE NLTO_BY_BD(
     v_year      number,
     v_zone       varchar2,
     v_zone_type   number,
     v_iss_cd      varchar2,
     v_user        varchar2,
     v_sys         date);
END;
/



CREATE OR REPLACE PACKAGE CPI.gk IS
  /* Created by: JOHN AREM B. PEREZ
  ** Created on: 20020303
  **  Package title: gLOBAL kONSTANTS
  ** Logic: This package header contains gLOBAL kONSTANTS
  **   Hardcoding of values and magic numbers/strings
  **  should only be done at this level AND in this package.
  */
  k_ac_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_AC');
  k_av_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_AV');
  k_ca_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_CA');
  k_en_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_EN');
  k_fi_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_FI');
  k_mc_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_MC');
  k_mh_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_MH');
  k_mn_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_MN');
  k_su_line_cd CONSTANT VARCHAR2(100):= giisp.v('LINE_CODE_SU');
  FUNCTION ac RETURN VARCHAR2;
  FUNCTION av RETURN VARCHAR2;
  FUNCTION ca RETURN VARCHAR2;
  FUNCTION en RETURN VARCHAR2;
  FUNCTION fi RETURN VARCHAR2;
  FUNCTION mc RETURN VARCHAR2;
  FUNCTION mh RETURN VARCHAR2;
  FUNCTION mn RETURN VARCHAR2;
  FUNCTION su RETURN VARCHAR2;
END;
/



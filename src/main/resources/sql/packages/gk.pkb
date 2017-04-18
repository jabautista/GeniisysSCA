CREATE OR REPLACE PACKAGE BODY CPI.gk IS
  /* Created by: JOHN AREM B. PEREZ
  ** Created on: 20020303
  **  Package title: gLOBAL kONSTANTS
  ** Logic: This package header contains gLOBAL kONSTANTS
  **   Hardcoding of values and magic numbers/strings
  **  should only be done at this level AND in this package.
  */
   FUNCTION ac RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_ac_line_cd);
  END;
  FUNCTION av RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_av_line_cd);
  END;
  FUNCTION ca RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_ca_line_cd);
  END;
  FUNCTION en RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_en_line_cd);
  END;
  FUNCTION fi RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_fi_line_cd);
  END;
  FUNCTION mc RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_mc_line_cd);
  END;
  FUNCTION mh RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_mh_line_cd);
  END;
  FUNCTION mn RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_mn_line_cd);
  END;
  FUNCTION su RETURN VARCHAR2
  IS
   /* Created by: JOHN AREM B. PEREZ
   ** Created on: 20020303
   ** Usage: Function that returns the line code
   ** as specified in giis_parameters via gk constants.
   */
  BEGIN
     RETURN(k_su_line_cd);
  END;
END gk;
/



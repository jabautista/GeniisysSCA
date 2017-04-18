DROP FUNCTION CPI.GET_GL_ACCT_NAME_2;

CREATE OR REPLACE FUNCTION CPI.GET_GL_ACCT_NAME_2
        (p_gl_acct_category   GIAC_CHART_OF_ACCTS.gl_acct_category%TYPE,
         p_gl_control_acct    GIAC_CHART_OF_ACCTS.gl_control_acct%TYPE,
         p_gl_sub_acct_1      GIAC_CHART_OF_ACCTS.gl_sub_acct_1%TYPE, 
         p_gl_sub_acct_2      GIAC_CHART_OF_ACCTS.gl_sub_acct_2%TYPE,
         p_gl_sub_acct_3      GIAC_CHART_OF_ACCTS.gl_sub_acct_3%TYPE,
         p_gl_sub_acct_4      GIAC_CHART_OF_ACCTS.gl_sub_acct_4%TYPE,
         p_gl_sub_acct_5      GIAC_CHART_OF_ACCTS.gl_sub_acct_5%TYPE,
         p_gl_sub_acct_6      GIAC_CHART_OF_ACCTS.gl_sub_acct_6%TYPE,
         p_gl_sub_acct_7      GIAC_CHART_OF_ACCTS.gl_sub_acct_7%TYPE,
         p_sl_type_cd         GIAC_SL_LISTS.sl_type_cd%TYPE,
         p_sl_cd              GIAC_SL_LISTS.sl_cd%TYPE)
         
RETURN VARCHAR2 AS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.19.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Gets the gl_acct_name from GIAC_CHART_OF_ACCTS
   **                 
   */

    v_sl_name           GIAC_SL_LISTS.sl_name%TYPE;
    v_acct_name         GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE;
    nbt_gl_acct_name    VARCHAR2(500);
                                         
BEGIN

     BEGIN 
        SELECT gl_acct_name
          INTO v_acct_name
          FROM GIAC_CHART_OF_ACCTS
         WHERE gl_sub_acct_7    = p_gl_sub_acct_7 
           AND gl_sub_acct_6    = p_gl_sub_acct_6 
           AND gl_sub_acct_5    = p_gl_sub_acct_5 
           AND gl_sub_acct_4    = p_gl_sub_acct_4 
           AND gl_sub_acct_3    = p_gl_sub_acct_3 
           AND gl_sub_acct_2    = p_gl_sub_acct_2 
           AND gl_sub_acct_1    = p_gl_sub_acct_1 
           AND gl_control_acct  = p_gl_control_acct
           AND gl_acct_category = p_gl_acct_category;
     EXCEPTION 
      WHEN NO_DATA_FOUND THEN
        v_acct_name := NULL;
     END;

     BEGIN
        SELECT sl_name
          INTO v_sl_name
          FROM GIAC_SL_LISTS
         WHERE sl_type_cd = p_sl_type_cd
           AND sl_cd      = p_sl_cd;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_sl_name := NULL;
     END;
     
     IF v_sl_name IS NOT NULL THEN
        nbt_gl_acct_name := v_acct_name || '  /  [SL - ' || 
                            LTRIM(v_sl_name) || ' ]';
     ELSE
        nbt_gl_acct_name := RTRIM(v_acct_name);
     END IF;
     
     RETURN nbt_gl_acct_name;
    
END;
/



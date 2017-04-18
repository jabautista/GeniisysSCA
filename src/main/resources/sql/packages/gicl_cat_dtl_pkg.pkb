CREATE OR REPLACE PACKAGE BODY CPI.gicl_cat_dtl_pkg
IS
   FUNCTION get_cat_dtls 
      RETURN gicl_cat_dtl_tab PIPELINED
   IS
   v_cat  gicl_cat_dtl_type;
   BEGIN
      FOR i IN (SELECT   catastrophic_cd, catastrophic_desc
                    FROM gicl_cat_dtl
                ORDER BY catastrophic_cd)
      LOOP
         v_cat.catastrophic_cd := i.catastrophic_cd;
         v_cat.catastrophic_desc := i.catastrophic_desc;
         PIPE ROW (v_cat);
      END LOOP;
   END get_cat_dtls;

   FUNCTION get_cat_dtl_by_cat_cd
    (p_catastrophic_cd      GICL_CLAIMS.catastrophic_cd%TYPE,
     p_line_cd              GICL_CLAIMS.line_cd%TYPE) 
    RETURN gicl_cat_dtl_tab PIPELINED IS

    v_cat  gicl_cat_dtl_type;

   BEGIN
      FOR i IN (SELECT catastrophic_cd, catastrophic_desc
                  FROM GICL_CAT_DTL
                 WHERE catastrophic_cd = p_catastrophic_cd
                   AND NVL(line_cd, p_line_cd) = p_line_cd)
      LOOP
         v_cat.catastrophic_cd := i.catastrophic_cd;
         v_cat.catastrophic_desc := i.catastrophic_desc;
         PIPE ROW (v_cat);
         EXIT;
      END LOOP;
      
   END get_cat_dtl_by_cat_cd;
   
END gicl_cat_dtl_pkg;
/



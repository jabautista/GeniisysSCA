DROP FUNCTION CPI.VALIDATE_DELETE_LINE;

CREATE OR REPLACE FUNCTION CPI.validate_delete_line (p_line_cd VARCHAR2)
   RETURN VARCHAR2
IS
   v_line_cd     VARCHAR2 (30);
   v_line_cd2    VARCHAR2 (30);
   v_line_cd3    VARCHAR2 (30);
   v_line_cd4    VARCHAR2 (30);
   v_line_cd5    VARCHAR2 (30);
   v_line_cd6    VARCHAR2 (30);
   v_line_cd7    VARCHAR2 (30);
   v_line_cd8    VARCHAR2 (30);
   v_line_cd9    VARCHAR2 (30);
   v_line_cd10   VARCHAR2 (30);
   v_line_cd11   VARCHAR2 (30);
BEGIN
   SELECT (SELECT   UPPER ('gipi_wpolbas')
               FROM gipi_wpolbas b540
              WHERE LOWER (b540.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) a,
          (SELECT   UPPER ('giis_warrcla')
               FROM giis_warrcla a280
              WHERE LOWER (a280.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) b,
          (SELECT   UPPER ('giis_tax_charges')
               FROM giis_tax_charges a230
              WHERE LOWER (a230.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) c,
          (SELECT   UPPER ('giis_subline')
               FROM giis_subline a210
              WHERE LOWER (a210.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) d,
          (SELECT   UPPER ('gipi_polbasic')
               FROM gipi_polbasic b250
              WHERE LOWER (b250.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) e,
          (SELECT   UPPER ('giis_peril')
               FROM giis_peril a170
              WHERE LOWER (a170.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) f,
          (SELECT   UPPER ('gipi_parlist')
               FROM gipi_parlist b240
              WHERE LOWER (b240.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) g,
          (SELECT   UPPER ('giis_outreaty')
               FROM giis_outreaty a160
              WHERE LOWER (a160.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) h,
          (SELECT   UPPER ('giis_intreaty')
               FROM giis_intreaty a590
              WHERE LOWER (a590.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) i,
          (SELECT   UPPER ('gicl_claims')
               FROM gicl_claims e030
              WHERE LOWER (e030.line_cd) LIKE LOWER (p_line_cd)
           GROUP BY line_cd) j,
          (SELECT   UPPER ('giis_dist_share')
               FROM giis_dist_share
              WHERE LOWER (line_cd) LIKE LOWER (p_line_cd)
                AND share_cd NOT IN ('1', '999')
           GROUP BY line_cd) k
     INTO v_line_cd,
          v_line_cd2,
          v_line_cd3,
          v_line_cd4,
          v_line_cd5,
          v_line_cd6,
          v_line_cd7,
          v_line_cd8,
          v_line_cd9,
          v_line_cd10,
          v_line_cd11
     FROM DUAL;

   IF v_line_cd IS NOT NULL
   THEN
      RETURN v_line_cd;
   END IF;

   IF v_line_cd2 IS NOT NULL
   THEN
      RETURN v_line_cd2;
   END IF;

   IF v_line_cd3 IS NOT NULL
   THEN
      RETURN v_line_cd3;
   END IF;

   IF v_line_cd4 IS NOT NULL
   THEN
      RETURN v_line_cd4;
   END IF;

   IF v_line_cd5 IS NOT NULL
   THEN
      RETURN v_line_cd5;
   END IF;

   IF v_line_cd6 IS NOT NULL
   THEN
      RETURN v_line_cd6;
   END IF;

   IF v_line_cd7 IS NOT NULL
   THEN
      RETURN v_line_cd7;
   END IF;

   IF v_line_cd8 IS NOT NULL
   THEN
      RETURN v_line_cd8;
   END IF;

   IF v_line_cd9 IS NOT NULL
   THEN
      RETURN v_line_cd9;
   END IF;

   IF v_line_cd10 IS NOT NULL
   THEN
      RETURN v_line_cd10;
   END IF;

   IF v_line_cd11 IS NOT NULL
   THEN
      RETURN v_line_cd11;
   END IF;

   RETURN '1';
END;
/



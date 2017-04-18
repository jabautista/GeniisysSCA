CREATE OR REPLACE PACKAGE BODY CPI.giiss014_pkg
AS
   FUNCTION get_industry_group_lov
      RETURN industry_group_tab PIPELINED
   IS
      v_list   industry_group_type;
   BEGIN
      FOR i IN (SELECT   ind_grp_cd, ind_grp_nm
                    FROM giis_industry_group
                ORDER BY ind_grp_cd)
      LOOP
         v_list.ind_grp_cd := i.ind_grp_cd;
         v_list.ind_grp_nm := i.ind_grp_nm;
         PIPE ROW (v_list);
      END LOOP;
   END get_industry_group_lov;

   FUNCTION get_giiss014_industry_list (p_ind_grp_cd VARCHAR2)
      RETURN giiss014_industry_tab PIPELINED
   IS
      v_list   giiss014_industry_type;
   BEGIN
      FOR i IN (SELECT   industry_cd, industry_nm, ind_grp_cd, remarks,
                         user_id, last_update
                    FROM giis_industry
                   WHERE ind_grp_cd = p_ind_grp_cd
                ORDER BY industry_cd)
      LOOP
         v_list.industry_cd := i.industry_cd;
         v_list.industry_nm := i.industry_nm;
         v_list.ind_grp_cd := i.ind_grp_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         --v_list.last_update := i.last_update;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_list);
      END LOOP;
   END get_giiss014_industry_list;
   
   PROCEDURE set_rec (p_rec giis_industry%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_industry
         USING DUAL
         ON (industry_cd = p_rec.industry_cd)
         WHEN NOT MATCHED THEN
            INSERT (industry_cd, industry_nm, remarks, user_id, last_update, ind_grp_cd)
            VALUES (industry_industry_cd_s.NEXTVAL, p_rec.industry_nm, p_rec.remarks,
                    p_rec.user_id, SYSDATE, p_rec.ind_grp_cd)
         WHEN MATCHED THEN
            UPDATE
               SET industry_nm = p_rec.industry_nm, 
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_industry_cd VARCHAR2)
   AS
   BEGIN
      DELETE FROM giis_industry
            WHERE industry_cd = p_industry_cd;
   END;

   PROCEDURE val_del_rec (p_industry_cd giis_industry.industry_cd%TYPE)
   AS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
   
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM giis_assured
           WHERE industry_cd = p_industry_cd
              AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exist := 'N';        
      END;
      
       
      IF v_exist = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INDUSTRY while dependent record(s) in GIIS_ASSURED exists.');
      END IF;
             
   END;

   PROCEDURE val_add_rec (p_industry_nm giis_industry.industry_nm%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_industry
                 WHERE UPPER(industry_nm) = UPPER(p_industry_nm))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same industry_nm.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_updated_rec (
      p_industry_cd   VARCHAR2,
      p_industry_nm   VARCHAR2
   )
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_industry
                 WHERE industry_cd <> p_industry_cd 
                   AND UPPER(industry_nm) = UPPER(p_industry_nm))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same industry_nm.'
                                 );
      END IF;
   END;
   
END;
/



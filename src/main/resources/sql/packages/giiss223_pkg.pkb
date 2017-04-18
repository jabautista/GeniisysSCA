CREATE OR REPLACE PACKAGE BODY CPI.GIISS223_PKG
    AS
/*
**  Created by   :  Dren Niebres
**  Date Created :  06.09.2016
**  Reference By : (GIISS223 - Maintenance - Motor Car Fair Market Value)
*/
   FUNCTION get_mc_fmv_source_list(
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN mc_fmv_source_list_tab PIPELINED
   IS
      v_mc  mc_fmv_source_list_type;
   BEGIN
      FOR i IN (SELECT A.CAR_COMPANY, A.CAR_COMPANY_CD, B.MAKE, B.MAKE_CD, C.ENGINE_SERIES, C.SERIES_CD
                  FROM GIIS_MC_CAR_COMPANY A, GIIS_MC_MAKE B, GIIS_MC_ENG_SERIES C
                 WHERE A.CAR_COMPANY_CD = B.CAR_COMPANY_CD 
                   AND A.CAR_COMPANY_CD = C.CAR_COMPANY_CD
                   AND B.MAKE_CD = C.MAKE_CD 
                   AND CHECK_USER_PER_ISS_CD2(null, null, 'GIISS223', p_user_id) = 1
              ORDER BY A.CAR_COMPANY)
      LOOP
         v_mc.car_company      := i.CAR_COMPANY;
         v_mc.car_company_cd   := i.CAR_COMPANY_CD;       
         v_mc.make             := i.MAKE;          
         v_mc.make_cd          := i.MAKE_CD;          
         v_mc.engine_series    := i.ENGINE_SERIES;
         v_mc.series_cd        := i.SERIES_CD;               
         PIPE ROW (v_mc);
      END LOOP;
   END get_mc_fmv_source_list;
   FUNCTION get_mc_fmv_list (
      p_car_company_cd  IN  GIIS_MC_FMV.car_company_cd%TYPE,
      p_make_cd         IN  GIIS_MC_FMV.make_cd%TYPE,
      p_series_cd       IN  GIIS_MC_FMV.series_cd%TYPE  
   )
      RETURN mc_fmv_maintenance_tab PIPELINED
   IS
      v_fmv   mc_fmv_maintenance_type;
   BEGIN
      FOR i IN (SELECT   car_company_cd, make_cd, series_cd, model_year,
                         hist_no, eff_date, fmv_value, fmv_value_min,
                         fmv_value_max, delete_sw, user_id,
                         TO_CHAR (last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
                    FROM GIIS_MC_FMV
                   WHERE car_company_cd = p_car_company_cd
                     AND make_cd = p_make_cd
                     AND series_cd = p_series_cd
                ORDER BY hist_no desc, last_update DESC)
      LOOP
         v_fmv.car_company_cd         := i.car_company_cd;
         v_fmv.make_cd                := i.make_cd;
         v_fmv.series_cd              := i.series_cd;
         v_fmv.model_year             := i.model_year;
         v_fmv.hist_no                := i.hist_no;
         v_fmv.eff_date               := TO_CHAR (i.eff_date, 'YYYY-MM-DD');
         v_fmv.fmv_value              := i.fmv_value;
         v_fmv.fmv_value_min          := i.fmv_value_min;
         v_fmv.fmv_value_max          := i.fmv_value_max;
         v_fmv.delete_sw              := i.delete_sw;
         v_fmv.user_id                := i.user_id;
         v_fmv.last_update            := i.last_update;
         
          BEGIN
            SELECT MAX (c.HIST_NO) + 1 HIST_NO
              INTO v_fmv.max_sequence
              FROM GIIS_MC_FMV c
             WHERE car_company_cd = p_car_company_cd
               AND make_cd = p_make_cd
               AND series_cd = p_series_cd;           
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                v_fmv.max_sequence := 1;
          END;       
          
          IF v_fmv.max_sequence IS NULL
          THEN v_fmv.max_sequence := 1; 
          END IF;                
          
          BEGIN
            SELECT TO_CHAR (MAX (eff_date)+1, 'YYYY-MM-DD') last_eff_date
              INTO v_fmv.last_eff_date
              FROM GIIS_MC_FMV c
             WHERE car_company_cd = p_car_company_cd
               AND make_cd = p_make_cd
               AND series_cd = p_series_cd
               AND delete_sw = 'N';
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                v_fmv.last_eff_date := '';
          END;          
         
         PIPE ROW (v_fmv);
      END LOOP;
   END get_mc_fmv_list;
   FUNCTION get_model_year_lov (p_keyword VARCHAR2)
      RETURN model_year_lov_tab PIPELINED
   IS
      v_list   model_year_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM (SELECT TO_CHAR(to_number(to_char(sysdate,'YYYY')) -level+1) model_year
                          FROM DUAL
                       connect by level <=to_number(to_char(sysdate,'YYYY'))- TO_CHAR(SYSDATE - 732, 'YYYY')) A
                  WHERE model_year = NVL(p_keyword,model_year))

      LOOP
         v_list.model_year := i.model_year;
         PIPE ROW (v_list);
      END LOOP;
   END;
   PROCEDURE set_giis_fmv ( 
      p_fmv    GIIS_MC_FMV%ROWTYPE
   )
   IS
      v_fmv        VARCHAR2(2);
   BEGIN
      SELECT (SELECT '1' 
                FROM GIIS_MC_FMV
               WHERE car_company_cd = p_fmv.car_company_cd
                 AND make_cd = p_fmv.make_cd
                 AND series_cd = p_fmv.series_cd
                 AND hist_no = p_fmv.hist_no
                 AND delete_sw = 'N')
      INTO v_fmv
      FROM DUAL;   
   
      IF v_fmv = '1'
        THEN
            UPDATE GIIS_MC_FMV
                SET delete_sw           = 'Y',
                    user_id             = p_fmv.user_id
              WHERE car_company_cd = p_fmv.car_company_cd
                AND make_cd = p_fmv.make_cd
                AND series_cd = p_fmv.series_cd
                AND hist_no = p_fmv.hist_no
                AND delete_sw = 'N';
      ELSE
        INSERT INTO GIIS_MC_FMV
                    (car_company_cd, make_cd, series_cd, model_year, hist_no, 
                     eff_date, fmv_value, fmv_value_min, fmv_value_max, delete_sw, user_id)
             VALUES (p_fmv.car_company_cd, p_fmv.make_cd, p_fmv.series_cd, p_fmv.model_year, 
                     p_fmv.hist_no, p_fmv.eff_date, p_fmv.fmv_value, p_fmv.fmv_value_min, 
                     p_fmv.fmv_value_max, p_fmv.delete_sw, p_fmv.user_id);
      END IF;
   END set_giis_fmv;
END GIISS223_PKG;
/
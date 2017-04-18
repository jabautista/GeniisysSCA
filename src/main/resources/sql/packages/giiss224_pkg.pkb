CREATE OR REPLACE PACKAGE BODY CPI.GIISS224_PKG
    AS
/*
**  Created by   :  Dren Niebres
**  Date Created :  08.02.2016
**  Reference By : (GIISS224 - Maintenance - Motor Car Depraciation Rate)
*/
   FUNCTION get_mc_dep_rate_list(
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN mc_dep_rate_list_tab PIPELINED
   IS
      v_mc  mc_dep_rate_list_type;
   BEGIN     
      FOR i IN (SELECT A.ID, A.CAR_COMPANY_CD, B.CAR_COMPANY, A.MAKE_CD, C.MAKE, A.MODEL_YEAR, A.SERIES_CD, D.ENGINE_SERIES, A.LINE_CD, A.SUBLINE_CD, 
                       F.SUBLINE_NAME,A.SUBLINE_TYPE_CD, G.SUBLINE_TYPE_DESC, A.RATE, A.DELETE_SW, A.USER_ID, A.LAST_UPDATE
                  FROM GIIS_MC_DEP_RATE A, GIIS_MC_CAR_COMPANY B, GIIS_MC_MAKE C, GIIS_MC_ENG_SERIES D, GIIS_LINE E, GIIS_SUBLINE F, GIIS_MC_SUBLINE_TYPE G
                 WHERE A.CAR_COMPANY_CD = B.CAR_COMPANY_CD               
                   AND A.MAKE_CD = C.MAKE_CD(+)
                   AND A.CAR_COMPANY_CD = C.CAR_COMPANY_CD(+)
                   AND A.SERIES_CD = D.SERIES_CD(+)
                   AND A.CAR_COMPANY_CD = D.CAR_COMPANY_CD(+)
                   AND A.MAKE_CD = D.MAKE_CD(+)
                   AND A.LINE_CD = E.LINE_CD(+)
                   AND A.LINE_CD = F.LINE_CD(+)
                   AND A.SUBLINE_CD = F.SUBLINE_CD(+)                   
                   AND A.SUBLINE_CD = G.SUBLINE_CD(+)                                      
                   AND A.SUBLINE_TYPE_CD = G.SUBLINE_TYPE_CD(+)  
                   AND A.DELETE_SW = 'N'
                   AND CHECK_USER_PER_ISS_CD2(null, null, 'GIISS224', p_user_id) = 1
              ORDER BY A.ID DESC)
      LOOP
         v_mc.id               := i.ID;
         v_mc.car_company_cd   := i.CAR_COMPANY_CD;
         v_mc.car_company      := i.CAR_COMPANY;       
         v_mc.make_cd          := i.MAKE_CD; 
         v_mc.make             := i.MAKE;     
         v_mc.model_year       := i.MODEL_YEAR;
         v_mc.series_cd        := i.SERIES_CD;             
         v_mc.engine_series    := i.ENGINE_SERIES;
         v_mc.line_cd          := i.LINE_CD;                       
         v_mc.subline_cd       := i.SUBLINE_CD;
         v_mc.subline_name     := i.SUBLINE_NAME;    
         v_mc.subline_type_cd  := i.SUBLINE_TYPE_CD;
         v_mc.subline_type     := i.SUBLINE_TYPE_DESC;
         v_mc.rate             := i.RATE;
         v_mc.delete_sw        := i.DELETE_SW;
         v_mc.user_id          := i.USER_ID;
         v_mc.last_update      := TO_CHAR (i.LAST_UPDATE, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW (v_mc);
      END LOOP;
   END get_mc_dep_rate_list;
   FUNCTION get_car_company_lov (p_keyword VARCHAR2)
      RETURN car_company_lov_tab PIPELINED
   IS
      v_list   car_company_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM GIIS_MC_CAR_COMPANY
                 WHERE car_company LIKE NVL(UPPER(p_keyword),car_company)
                    OR car_company_cd LIKE NVL(p_keyword,car_company_cd)                 
              ORDER BY car_company_cd)

      LOOP
         v_list.car_company_cd := i.car_company_cd;
         v_list.car_company    := i.car_company;
         PIPE ROW (v_list);
      END LOOP;
   END;   
   FUNCTION get_make_lov (p_keyword VARCHAR2,
                          p_car_company_cd      GIIS_MC_DEP_RATE.car_company_cd%TYPE)
      RETURN make_lov_tab PIPELINED
   IS
      v_list   make_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM GIIS_MC_MAKE
                 WHERE (make LIKE NVL(UPPER(p_keyword),make) OR make_cd LIKE NVL(UPPER(p_keyword),make_cd))
                   AND car_company_cd = p_car_company_cd
              ORDER BY make_cd)

      LOOP
         v_list.make_cd       := i.make_cd;
         v_list.make          := i.make;
         v_list.subline_cd    := i.subline_cd;
         PIPE ROW (v_list);
      END LOOP;
   END;      
   FUNCTION get_engine_lov (p_keyword VARCHAR2,
                            p_car_company_cd      GIIS_MC_DEP_RATE.car_company_cd%TYPE,
                            p_make_cd             GIIS_MC_DEP_RATE.make_cd%TYPE)
      RETURN engine_lov_tab PIPELINED
   IS
      v_list   engine_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM GIIS_MC_ENG_SERIES
                 WHERE (engine_series LIKE NVL(UPPER(p_keyword),engine_series) OR series_cd LIKE NVL(UPPER(p_keyword),series_cd))
                   AND car_company_cd = p_car_company_cd
                   AND make_cd = p_make_cd
              ORDER BY series_cd)

      LOOP
         v_list.series_cd       := i.series_cd;
         v_list.engine_series   := i.engine_series;
         PIPE ROW (v_list);
      END LOOP;
   END;     
   FUNCTION get_subline_lov (p_keyword VARCHAR2,
                             p_line_cd             GIIS_MC_DEP_PERIL.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED
   IS
      v_list   subline_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM GIIS_SUBLINE
                 WHERE (subline_cd LIKE NVL(UPPER(p_keyword),subline_cd) OR subline_name LIKE NVL(UPPER(p_keyword),subline_name))
                   AND line_cd = p_line_cd
              ORDER BY subline_cd, subline_name)

      LOOP
         v_list.subline_cd       := i.subline_cd;
         v_list.subline_name     := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;
   END;     
   FUNCTION get_subline_type_lov (p_keyword VARCHAR2,
                                  p_subline_cd          GIIS_MC_DEP_RATE.subline_type_cd%TYPE)
      RETURN subline_type_lov_tab PIPELINED
   IS
      v_list   subline_type_lov_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM GIIS_MC_SUBLINE_TYPE
                 WHERE (subline_type_desc LIKE NVL(UPPER(p_keyword),subline_type_desc) OR subline_type_cd LIKE NVL(UPPER(p_keyword),subline_type_cd))
                   AND subline_cd = p_subline_cd
              ORDER BY subline_cd, subline_type_cd)

      LOOP
         v_list.subline_type_cd     := i.subline_type_cd;
         v_list.subline_type        := i.subline_type_desc;
         PIPE ROW (v_list);
      END LOOP;
   END;     
   FUNCTION get_model_year_list
      RETURN model_year_list_tab PIPELINED
   IS
      v_list   model_year_list_type;
      
   BEGIN   
      FOR i IN (SELECT * 
                  FROM (SELECT TO_CHAR(to_number(to_char(sysdate,'YYYY')) -level+1) model_year
                          FROM DUAL
                       connect by level <= (SELECT (SYSDATE - TO_DATE('01-01-1990', 'MM-DD-YYYY')) /365.4 + 1
                                              FROM DUAL)))

      LOOP
         v_list.model_year := i.model_year;
         PIPE ROW (v_list);
      END LOOP;
   END;      
   PROCEDURE set_giis_mcdr ( 
      p_mcdr    GIIS_MC_DEP_RATE%ROWTYPE
   )
   IS
      v_mcdr        VARCHAR2(2);
      v_id          GIIS_MC_DEP_RATE.ID%TYPE;
   BEGIN
   
      SELECT (SELECT '1' 
                FROM GIIS_MC_DEP_RATE
               WHERE id = p_mcdr.id)
        INTO v_mcdr
        FROM DUAL;   
   
      IF v_mcdr = '1'
        THEN
            UPDATE GIIS_MC_DEP_RATE
                SET id                  = p_mcdr.id,
                    car_company_cd      = p_mcdr.car_company_cd,
                    make_cd             = p_mcdr.make_cd,
                    series_cd           = p_mcdr.series_cd,
                    model_year          = p_mcdr.model_year,
                    line_cd             = p_mcdr.line_cd,
                    subline_cd          = p_mcdr.subline_cd,
                    subline_type_cd     = p_mcdr.subline_type_cd,
                    rate                = p_mcdr.rate,
                    delete_sw           = p_mcdr.delete_sw,
                    user_id             = p_mcdr.user_id
              WHERE id = p_mcdr.id;
      ELSE
      
        SELECT MC_DEP_RATE_ID_S.NEXTVAL
          INTO v_id
          FROM DUAL;   
      
        INSERT INTO GIIS_MC_DEP_RATE
                    (id,car_company_cd, make_cd, series_cd, model_year, line_cd, subline_cd, subline_type_cd, rate, delete_sw, user_id)
             VALUES (v_id, p_mcdr.car_company_cd, p_mcdr.make_cd, p_mcdr.series_cd, p_mcdr.model_year, p_mcdr.line_cd,
                     p_mcdr.subline_cd, p_mcdr.subline_type_cd, p_mcdr.rate, p_mcdr.delete_sw, p_mcdr.user_id);
      END IF;
   END set_giis_mcdr;
   FUNCTION validate_add_mc_dep_rate_rec (
        p_id                        GIIS_MC_DEP_RATE.id%TYPE,
        p_car_company_cd            GIIS_MC_DEP_RATE.car_company_cd%TYPE,
	    p_make_cd	                GIIS_MC_DEP_RATE.make_cd%TYPE,
        p_series_cd	                GIIS_MC_DEP_RATE.series_cd%TYPE,   
        p_model_year	            GIIS_MC_DEP_RATE.model_year%TYPE,
        p_line_cd	                GIIS_MC_DEP_RATE.line_cd%TYPE,
        p_subline_cd	            GIIS_MC_DEP_RATE.subline_cd%TYPE,
        p_subline_type_cd	        GIIS_MC_DEP_RATE.subline_type_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_mcdr                     VARCHAR2(2);
      v_query                    VARCHAR2(1000);
      v_p_make_cd                VARCHAR2(100);
      v_p_series_cd              VARCHAR2(100);
      v_p_model_year             VARCHAR2(100);
      v_p_line_cd                VARCHAR2(100);
      v_p_subline_cd             VARCHAR2(100);            
      v_p_subline_type_cd        VARCHAR2(100);
   
   BEGIN
   
       IF p_make_cd IS NULL THEN
          v_p_make_cd := ' AND MAKE_CD IS NULL';
       ELSE
          v_p_make_cd := ' AND MAKE_CD = ' || p_make_cd;
       END IF;       
       
       IF p_series_cd IS NULL THEN
          v_p_series_cd := ' AND SERIES_CD IS NULL';
       ELSE
          v_p_series_cd := ' AND SERIES_CD = ' || p_series_cd;
       END IF;  
       
       IF p_model_year IS NULL THEN
          v_p_model_year := ' AND MODEL_YEAR IS NULL';
       ELSE
          v_p_model_year := ' AND MODEL_YEAR = ' || p_model_year;
       END IF;  
       
       IF p_line_cd IS NULL THEN
          v_p_line_cd := ' AND LINE_CD IS NULL';
       ELSE
          v_p_line_cd := ' AND LINE_CD = ' || '''' || p_line_cd || '''';
       END IF;
       
       IF p_subline_cd IS NULL THEN
          v_p_subline_cd := ' AND SUBLINE_CD IS NULL';
       ELSE
          v_p_subline_cd := ' AND SUBLINE_CD = ' || '''' || p_subline_cd || '''';
       END IF;                      
       
       IF p_subline_type_cd IS NULL THEN
          v_p_subline_type_cd := ' AND SUBLINE_TYPE_CD IS NULL';
       ELSE
          v_p_subline_type_cd := ' AND SUBLINE_TYPE_CD = ' || '''' || p_subline_type_cd || '''';
       END IF;                        
   
       IF p_id IS NULL THEN
           v_query := 'SELECT COUNT(*) FROM GIIS_MC_DEP_RATE' 
                       || ' WHERE CAR_COMPANY_CD = ' || p_car_company_cd
                       || v_p_make_cd
                       || v_p_series_cd
                       || v_p_model_year
                       || v_p_line_cd  
                       || v_p_subline_cd                                                
                       || v_p_subline_type_cd                   
                       || ' AND DELETE_SW = ''N''';
       ELSE
           v_query := 'SELECT COUNT(*) FROM GIIS_MC_DEP_RATE' 
                       || ' WHERE CAR_COMPANY_CD = ' || p_car_company_cd
                       || v_p_make_cd
                       || v_p_series_cd
                       || v_p_model_year
                       || v_p_line_cd  
                       || v_p_subline_cd                         
                       || v_p_subline_type_cd                   
                       || ' AND DELETE_SW = ''N'''   
                       || ' AND ID != ' || p_id;
       END IF;                
                 
       EXECUTE IMMEDIATE v_query         
         INTO v_mcdr;
       RETURN v_mcdr;

       IF v_mcdr IS NOT NULL
       THEN
         RETURN v_mcdr;
       END IF;
  
       RETURN '0';           
   END validate_add_mc_dep_rate_rec;  
   FUNCTION get_mc_dep_rate_peril(
      p_id                          GIIS_MC_DEP_PERIL.id%TYPE,
      p_line_cd                     GIIS_MC_DEP_PERIL.line_cd%TYPE
   )
      RETURN mc_dep_rate_peril_tab PIPELINED
   IS
      v_peril  mc_dep_rate_peril_type;
   BEGIN
      FOR i IN (SELECT A.ID, A.LINE_CD, A.PERIL_CD, B.PERIL_NAME, A.USER_ID, A.LAST_UPDATE
                  FROM GIIS_MC_DEP_PERIL A, GIIS_PERIL B
                 WHERE A.PERIL_CD = B.PERIL_CD
                   AND B.LINE_CD = p_line_cd 
                   AND A.ID = p_id
              ORDER BY A.ID, A.LINE_CD, A.PERIL_CD)
      LOOP
         v_peril.id               := i.ID;
         v_peril.line_cd          := i.LINE_CD;
         v_peril.peril_cd         := i.PERIL_CD;
         v_peril.peril_name       := i.PERIL_NAME;
         v_peril.user_id          := i.USER_ID;
         v_peril.last_update      := i.LAST_UPDATE;
         
         PIPE ROW (v_peril);
      END LOOP;
   END get_mc_dep_rate_peril;     
   FUNCTION get_line_cd_lov (p_keyword VARCHAR2,
                             p_user_id     giis_users.user_id%TYPE)
      RETURN line_cd_lov_tab PIPELINED
   IS
      v_list   line_cd_lov_type;
      
   BEGIN   
      FOR i IN (SELECT LINE_CD, LINE_NAME
                  FROM GIIS_LINE
                 WHERE CHECK_USER_PER_ISS_CD2('MC', null, 'GIISS224', p_user_id) = 1
                   AND (LINE_CD = 'MC' OR MENU_LINE_CD = 'MC')
                   AND (LINE_CD LIKE NVL(UPPER(p_keyword),LINE_CD) OR LINE_NAME LIKE NVL(UPPER(p_keyword),LINE_NAME))
              ORDER BY LINE_CD)

      LOOP
         v_list.line_cd       := i.line_cd;
         v_list.line_name     := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END;      
   FUNCTION get_peril_name_lov (
        p_keyword VARCHAR2,
        p_line_cd                   GIIS_MC_DEP_PERIL.line_cd%TYPE
   )
      RETURN peril_name_lov_tab PIPELINED
   IS
      v_list   peril_name_lov_type;
      
   BEGIN   
      FOR i IN (SELECT PERIL_CD, PERIL_NAME
                  FROM GIIS_PERIL
                 WHERE (PERIL_NAME LIKE NVL(UPPER(p_keyword), PERIL_NAME) OR PERIL_CD LIKE NVL(UPPER(p_keyword), PERIL_CD))
                   AND LINE_CD = p_line_cd
              ORDER BY PERIL_CD)

      LOOP
         v_list.peril_cd       := i.peril_cd;
         v_list.peril_name     := i.peril_name;
         PIPE ROW (v_list);
      END LOOP;
   END;     
   PROCEDURE delete_peril_dep_rate (
        p_id                        GIIS_MC_DEP_PERIL.id%TYPE,
        p_line_cd                   GIIS_MC_DEP_PERIL.line_cd%TYPE,
        p_peril_cd                  GIIS_MC_DEP_PERIL.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE GIIS_MC_DEP_PERIL
       WHERE id = p_id
         AND line_cd = p_line_cd 
         AND peril_cd = p_peril_cd;
   END delete_peril_dep_rate;   
   PROCEDURE set_peril_dep_rate (
        p_peril_dep    GIIS_MC_DEP_PERIL%ROWTYPE
   )
   IS
        v_exists        VARCHAR2 (1);

   BEGIN
   
      SELECT (SELECT '1' 
                FROM GIIS_MC_DEP_PERIL
               WHERE id = p_peril_dep.id
                 AND peril_cd = p_peril_dep.peril_cd)
        INTO v_exists
        FROM DUAL;   
        
      IF v_exists is null
        THEN 

          INSERT INTO GIIS_MC_DEP_PERIL (id, line_cd, peril_cd, user_id)
               VALUES (p_peril_dep.id, p_peril_dep.line_cd, p_peril_dep.peril_cd, p_peril_dep.user_id);
      END IF;
      
   END set_peril_dep_rate; 
   FUNCTION validate_peril_rec (
        p_id                      GIIS_MC_DEP_PERIL.id%TYPE
   ) 
        RETURN VARCHAR2   
   IS
        v_mcperil                 VARCHAR2(2);
   
   BEGIN
        SELECT DISTINCT 1
          INTO v_mcperil
          FROM GIIS_MC_DEP_PERIL          
         WHERE id = p_id;
   
        RETURN v_mcperil;
   END validate_peril_rec;
   PROCEDURE delete_peril_rec (
        p_id                        GIIS_MC_DEP_PERIL.id%TYPE
   )
   IS
   BEGIN   
      DELETE GIIS_MC_DEP_PERIL
       WHERE id = p_id;
       
      COMMIT;
   END delete_peril_rec;     
      
END GIISS224_PKG;
/
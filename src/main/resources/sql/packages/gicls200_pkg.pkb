CREATE OR REPLACE PACKAGE BODY CPI.GICLS200_PKG
AS

    PROCEDURE get_def_values_for_user(
        p_user_id           IN  giis_users.user_id%TYPE,
        p_as_of_date        OUT VARCHAR2,
        p_os_date_opt       OUT GICL_OS_PD_CLM_EXTR.os_date_opt%TYPE,
        p_pd_date_opt       OUT GICL_OS_PD_CLM_EXTR.pd_date_opt%TYPE,
        p_cat_cd            OUT GICL_OS_PD_CLM_EXTR.p_cat_cd%TYPE,
        p_cat_desc          OUT GICL_CAT_DTL.CATASTROPHIC_DESC%TYPE,
        p_line              OUT GICL_OS_PD_CLM_EXTR.p_line%TYPE,
        p_line_name         OUT giis_line.line_name%TYPE,
        p_iss_cd            OUT GICL_OS_PD_CLM_EXTR.p_iss_cd%TYPE,
        p_iss_name          OUT giis_issource.iss_name%TYPE,
        p_loc               OUT GICL_OS_PD_CLM_EXTR.p_loc%TYPE,
        p_location_desc     OUT VARCHAR2,
        p_loss_cat_cd       OUT GICL_OS_PD_CLM_EXTR.p_loss_cat_cd%TYPE,
        p_loss_cat_desc     OUT GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,
        p_ri_cd             OUT giis_reinsurer.ri_cd%TYPE,
        p_ri_name           OUT giis_reinsurer.ri_name%TYPE
    ) IS
    
    BEGIN
    
        FOR i IN (SELECT DISTINCT AS_OF_DATE,
                         NVL(OS_DATE_OPT, 1) os_date_opt,
                         NVL(PD_DATE_OPT, 1) pd_date_opt,
                         P_CAT_CD,
                         P_LINE,
                         P_ISS_CD,
                         P_LOC,
                         P_LOSS_CAT_CD
                FROM GICL_OS_PD_CLM_EXTR
             WHERE USER_ID = p_user_id)
        LOOP
            p_as_of_date    := TO_CHAR(i.as_of_date, 'mm-dd-yyyy');
            p_os_date_opt   := i.os_date_opt;
            p_pd_date_opt   := i.pd_date_opt;
            p_cat_cd        := i.p_cat_cd;
            p_line          := i.p_line;
            p_iss_cd        := i.p_iss_cd;
            p_loc           := i.p_loc;
            p_loss_cat_cd   := i.p_loss_cat_cd;
        END LOOP;
        
        BEGIN
            SELECT catastrophic_desc
              INTO p_cat_desc
              FROM gicl_cat_dtl
             WHERE catastrophic_cd = p_cat_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_cat_desc := NULL;
        END;
        
        BEGIN
            SELECT line_name
              INTO p_line_name
              FROM giis_line
             WHERE line_cd = p_line;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_line_name := NULL;
        END;
        
        BEGIN
            SELECT iss_name
              INTO p_iss_name
              FROM giis_issource
             WHERE iss_cd = p_iss_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_iss_name := NULL;
        END;
        
        BEGIN
            SELECT b.city||', '||a.province_desc
              INTO p_location_desc
              FROM giis_province a, giis_city b
             WHERE a.province_cd = b.province_cd
               AND a.province_cd||'-'||b.city_cd = p_loc;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_location_desc := NULL;
        END;
        
        BEGIN
            SELECT loss_cat_des
              INTO p_loss_cat_desc
              FROM giis_loss_ctgry
             WHERE line_cd      = p_line
               AND loss_cat_cd  = p_loss_cat_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_loss_cat_desc := NULL;
        END;
        
        BEGIN
            SELECT ri_name
              INTO p_ri_name
              FROM giis_reinsurer
             WHERE ri_cd = p_ri_cd; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_ri_name := NULL;
        END;
        
    END get_def_values_for_user;
    
    
    PROCEDURE validate_bef_print(
        p_user_id       IN  giis_users.user_id%TYPE,
        p_session_id    OUT gicl_os_pd_clm_extr.session_id%TYPE,
        p_ext_date      OUT VARCHAR2
    ) IS
        v_ext_date      DATE;
    BEGIN
    
        FOR i IN (SELECT MAX(session_id) session_id
  				    FROM gicl_os_pd_clm_extr 
  				   WHERE user_id = p_user_id)
        LOOP
            p_session_id := i.session_id;
        END LOOP;
        
        IF p_session_id > 0 THEN
            SELECT MAX(last_update)
			  INTO v_ext_date
			  FROM gicl_os_pd_clm_extr 
		     WHERE session_id = p_session_id;
             
           IF TRUNC(v_ext_date) <> TRUNC(sysdate) THEN
                p_ext_date := TO_CHAR(v_ext_date, 'dd-MON-yyyy'); 
           END IF;
            
        END IF;
       
    END validate_bef_print;
    
    FUNCTION get_gicls200_line_list (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd line_cd, line_name line_name
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                        p_pol_iss_cd,
                                                        p_module_id,
                                                        p_user_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 )
                  AND (   UPPER (line_cd) LIKE UPPER (NVL (p_keyword, '%'))
                       OR UPPER (line_name) LIKE UPPER (NVL (p_keyword, '%'))
                   )
                ORDER BY line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;
      
   END get_gicls200_line_list;
   
   FUNCTION get_gicls200_branch_list (
      p_line_cd      giis_line.line_cd%TYPE,
      p_user_id      VARCHAR2,
      p_module_id    giis_user_grp_modules.module_id%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN issue_source_list_tab PIPELINED
   IS
      v_iss   issue_source_list_type;
   BEGIN
      FOR i IN (  SELECT iss_cd, iss_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd2 (p_line_cd,
                                                 iss_cd,
                                                 p_module_id,
                                                 p_user_id) = 1
                     AND (   UPPER (iss_cd) LIKE UPPER (NVL (p_keyword, '%'))
                          OR UPPER (iss_name) LIKE UPPER (NVL (p_keyword, '%'))
                         )
                   ORDER BY iss_cd)
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;

      RETURN;
   END get_gicls200_branch_list;
    
END GICLS200_PKG;
/



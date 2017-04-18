CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PARAMETERS_PKG AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 12, 2010
**  Reference By : (GGIPI_PARLIST_PKG)
**  Description  : Checks recent param_value for param name with auto-assign flag.   
*/ 
 /* FUNCTION get_param_value 
    RETURN VARCHAR2 IS
  BEGIN
    FOR C IN(
      SELECT PARAM_VALUE_V
        FROM giis_parameters
       WHERE param_name  = 'AUTOMATIC_PAR_ASSIGNMENT_FLAG')
    LOOP
      RETURN C.PARAM_VALUE_V;    
      EXIT;
    END LOOP;
  END;
  */
  FUNCTION check_param_by_iss_cd(p_iss_cd    GIIS_PARAMETERS.param_name%TYPE)
    RETURN VARCHAR2 IS
    is_exists VARCHAR2(1):= 'N';
  BEGIN
    FOR A IN (
       SELECT  1
         FROM  giis_parameters
        WHERE  param_name    =  p_iss_cd
          AND  param_value_v =  'RI') 
    LOOP
       is_exists := 'Y';
       EXIT;
    END LOOP;
    RETURN is_exists;
  END;
  
  FUNCTION get_param_by_iss_cd(p_iss_cd    GIIS_PARAMETERS.param_name%TYPE)
    RETURN VARCHAR2 IS
    v_param VARCHAR2(4) := '';
  BEGIN
    FOR A IN (
       SELECT param_name  
         FROM giis_parameters
        WHERE param_value_v = 'RI'
          AND param_name    = p_iss_cd) 
    LOOP
       v_param := A.param_name;
       EXIT;
    END LOOP;
    RETURN v_param;
  END;
  
 --functions from giisp
    
 FUNCTION v (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  RETURN VARCHAR2
   IS 
    CURSOR get_v (var_param_name GIIS_PARAMETERS.param_name%TYPE)
     IS
       SELECT param_value_v
         FROM GIIS_PARAMETERS
          WHERE param_name  = var_param_name;
        var_return GIIS_PARAMETERS.param_value_v%TYPE := NULL;
   BEGIN
     OPEN get_v(var_param_name);
       FETCH get_v INTO var_return;
     CLOSE get_v;
   RETURN(VAR_RETURN);
 END v;
 
 FUNCTION d (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  RETURN DATE
   IS
    CURSOR get_d (var_param_name GIIS_PARAMETERS.param_name%TYPE)
   IS
     SELECT param_value_d
       FROM GIIS_PARAMETERS
      WHERE param_name = var_param_name;
   var_return GIIS_PARAMETERS.param_value_d%TYPE := NULL;
  BEGIN
    OPEN get_d(var_param_name);
      FETCH get_d INTO var_return;
    CLOSE get_d;
   RETURN(var_return);
 END d;
 
FUNCTION n (var_param_name GIIS_PARAMETERS.param_name%TYPE)
  RETURN NUMBER
   IS
    CURSOR get_n (var_param_name GIIS_PARAMETERS.param_name%TYPE)
     IS
      SELECT param_value_n
       FROM GIIS_PARAMETERS
       WHERE param_name = var_param_name;
     var_return  GIIS_PARAMETERS.param_value_n%TYPE := NULL;
  BEGIN
    OPEN get_n(var_param_name);
       FETCH get_n INTO var_return;
    CLOSE get_n;
   RETURN(var_return);
 END n;
 
FUNCTION get_parameter_values(var_param_name GIIS_PARAMETERS.param_name%TYPE)
  RETURN giis_parameters_tab PIPELINED
IS
  v_giis_parameters           giis_parameters_type;
BEGIN
     FOR i IN (SELECT param_type, param_value_v, param_name, param_value_n, param_value_d, param_length
                     FROM GIIS_PARAMETERS
                WHERE param_name LIKE var_param_name)
     LOOP
          v_giis_parameters.param_type                       := i.param_type;
         v_giis_parameters.param_value_v                  := i.param_value_v;
         v_giis_parameters.param_name                       := i.param_name;
         v_giis_parameters.param_value_n                  := i.param_value_n;
         v_giis_parameters.param_value_d                  := i.param_value_d;
         v_giis_parameters.param_length                  := i.param_length;
         
         PIPE ROW(v_giis_parameters);
     END LOOP;
     
     RETURN;
END;
  
/*
** Created by    : Menandro Robes
** Created date  : October 04, 2010
** Referenced by : 
** Description   : Retrieves the line codes
*/

  FUNCTION get_giis_parameters_lines RETURN giis_parameters_lines_tab PIPELINED
  IS
    v_lines giis_parameters_lines_type;
  BEGIN
    FOR i IN (
      SELECT A.PARAM_VALUE_V AC,
             B.PARAM_VALUE_V AV,
             C.PARAM_VALUE_V CA,
             D.PARAM_VALUE_V EN,
             E.PARAM_VALUE_V FI,
             F.PARAM_VALUE_V MC,
             G.PARAM_VALUE_V MH, 
             H.PARAM_VALUE_V MN,
             I.PARAM_VALUE_V SU,
             J.PARAM_VALUE_V PK,
             K.PARAM_VALUE_V MD
        FROM GIIS_PARAMETERS A, 
             GIIS_PARAMETERS B,
             GIIS_PARAMETERS C, 
             GIIS_PARAMETERS D,
             GIIS_PARAMETERS E, 
             GIIS_PARAMETERS F,
             GIIS_PARAMETERS G, 
             GIIS_PARAMETERS H,
             GIIS_PARAMETERS I, 
             GIIS_PARAMETERS J,
             GIIS_PARAMETERS K
       WHERE A.PARAM_NAME LIKE 'LINE_CODE_AC' AND           
             B.PARAM_NAME LIKE 'LINE_CODE_AV' AND
             C.PARAM_NAME LIKE 'LINE_CODE_CA' AND
             D.PARAM_NAME LIKE 'LINE_CODE_EN' AND
             E.PARAM_NAME LIKE 'LINE_CODE_FI' AND
             F.PARAM_NAME LIKE 'LINE_CODE_MC' AND
             G.PARAM_NAME LIKE 'LINE_CODE_MH' AND
             H.PARAM_NAME LIKE 'LINE_CODE_MN' AND
             I.PARAM_NAME LIKE 'LINE_CODE_SU' AND
             J.PARAM_NAME LIKE 'LINE_CODE_PK' AND
             K.PARAM_NAME LIKE 'LINE_CODE_MD')
    LOOP
        v_lines.ac := i.ac;
        v_lines.av := i.av;
        v_lines.ca := i.ca;
        v_lines.en := i.en;
        v_lines.fi := i.fi;
        v_lines.mc := i.mc;
        v_lines.mh := i.mh;
        v_lines.mn := i.mn;
        v_lines.su := i.su;
        v_lines.pk := i.pk;
        v_lines.md := i.md;
      PIPE ROW(v_lines);
    END LOOP;
    RETURN;
  END get_giis_parameters_lines;

/*
** Created by    : Menandro Robes
** Created date  : June 16, 2011
** Referenced by : 
** Description   : Retrieves the context parameters needed when geniisys web starts up
*/

  FUNCTION get_context_parameters RETURN context_parameters_tab PIPELINED
  IS
    v_params context_parameters_type;
  BEGIN
    FOR i IN (
      SELECT GIIS_PARAMETERS_PKG.V('CLIENT_BANNER') client_banner
            ,GIIS_PARAMETERS_PKG.N('PWD_LIFE_TIME') password_expiry
            ,GIIS_PARAMETERS_PKG.N('NO_OF_LOGIN_TRIES') no_of_login_tries
            ,GIIS_PARAMETERS_PKG.V('DEFAULT_COLOR') default_color
            ,GIIS_PARAMETERS_PKG.V('ENABLE_MAC_VALIDATION') enable_mac_validation
            ,GIIS_PARAMETERS_PKG.V('ENABLE_CON_LOGIN_VALIDATION') enable_con_login_validation
            ,GIIS_PARAMETERS_PKG.N('NO_OF_APP_PER_USER') no_of_app_per_user
            ,GIIS_PARAMETERS_PKG.V('ENABLE_DETAILED_EXCEPTION_MESSAGE') enable_detailed_exception_msg
            ,GIIS_PARAMETERS_PKG.V('ENABLE_BROWSER_VALIDATION') enable_browser_validation
            ,GIIS_PARAMETERS_PKG.V('DEFAULT_LANGUAGE') default_language
            ,GIIS_PARAMETERS_PKG.V('ENABLE_EMAIL_NOTIFICATION') enable_email_notification
			,GIIS_PARAMETERS_PKG.V('ENDT_BASIC_INFO_SW') endt_basic_info_sw
			,GIIS_PARAMETERS_PKG.V('ITEM_TABLEGRID_SW') item_tablegrid_sw
			,GIIS_PARAMETERS_PKG.V('AD_HOC_URL') ad_hoc_url
            ,GIIS_PARAMETERS_PKG.N('SESSION_TIMEOUT') session_timeout
            ,GIIS_PARAMETERS_PKG.N('NEW_PASSWORD_VALIDITY') new_password_validity
            ,GIIS_PARAMETERS_PKG.V('TEXT_EDITOR_FONT') text_editor_font
        FROM DUAL)
    LOOP
      v_params.password_expiry           	 := i.password_expiry;
      v_params.no_of_login_tries        	 := i.no_of_login_tries;
      v_params.client_banner            	 := i.client_banner;
      v_params.default_color                 := i.default_color;
      v_params.enable_mac_validation    	 := i.enable_mac_validation;
      v_params.enable_con_login_validation 	 := i.enable_con_login_validation;
      v_params.no_of_app_per_user       	 := i.no_of_app_per_user;
      v_params.enable_detailed_exception_msg := i.enable_detailed_exception_msg;
      v_params.enable_browser_validation 	 := i.enable_browser_validation;
      v_params.default_language          	 := i.default_language;
      v_params.enable_email_notification 	 := i.enable_email_notification;
	  v_params.endt_basic_info_sw 			 := i.endt_basic_info_sw;
	  v_params.item_tablegrid_sw 			 := i.item_tablegrid_sw;
	  v_params.ad_hoc_url					 := i.ad_hoc_url;
      v_params.session_timeout			     := i.session_timeout;
      v_params.new_password_validity 		 := i.new_password_validity;
      v_params.text_editor_font			     := i.text_editor_font;
      PIPE ROW(v_params);
    END LOOP;
    RETURN;
  END get_context_parameters;
  
    /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : updates giis_parameters based on the maximum pre_binder_id inserted in giri_wfrps_ri
    */
    PROCEDURE UPDATE_GIIS_PARAMETERS
    IS
      v_pre_binder_id		giri_wfrps_ri.pre_binder_id%type;  
      v_fnl_binder_id		giri_wfrps_ri.pre_binder_id%type;  
    BEGIN
      --check max binder from giri_wfrps_ri
      SELECT max(pre_binder_id)
        INTO v_pre_binder_id
        FROM giri_wfrps_ri;
      --check max binder from giri_frps_ri
      SELECT max(fnl_binder_id)
        INTO v_fnl_binder_id
        FROM giri_frps_ri;
       if v_pre_binder_id < v_fnl_binder_id then
          v_pre_binder_id := v_fnl_binder_id;
       end if;

      UPDATE giis_parameters
         SET param_value_n = v_pre_binder_id
       WHERE param_name like 'BINDER_ID';
    END UPDATE_GIIS_PARAMETERS;
    
    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 09.12.2011
    **  Reference By    : (GIEXS001 - Extract Expiring Policies)
    */
    PROCEDURE initialize_parameters(
        p_inc_special_sw     OUT giis_parameters.param_value_v%TYPE,
        p_def_is_pol_summ_sw OUT giis_parameters.param_value_v%TYPE,
        p_def_same_polno_sw  OUT giis_parameters.param_value_v%TYPE,
        p_other_branch_renewal OUT giis_parameters.param_value_v%TYPE)
    IS
    BEGIN
      FOR A IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'EXPIRY_INCLUDE_SPECIAL_POLICY') 
      LOOP
         p_inc_special_sw := a.param_value_v;
         EXIT;
      END LOOP;    
                
      FOR B IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'EXPIRY_DEFAULT_IS_POL_SUMMARY') 
      LOOP
         p_def_is_pol_summ_sw := b.param_value_v;
         EXIT;
      END LOOP;  
                             
      FOR C IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'EXPIRY_SAME_POLICY') 
      LOOP
         p_def_same_polno_sw := c.param_value_v;
         EXIT;
      END LOOP;
      
      BEGIN
          SELECT param_value_v
            INTO p_other_branch_renewal
            FROM giis_parameters
           WHERE param_name = 'ALLOW_OTHER_BRANCH_RENEWAL';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         p_other_branch_renewal := NULL;      
      END;                         
    END initialize_parameters;
    
    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 09.19.2011
    **  Reference By    : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description     : Initializes the date format
    */
    PROCEDURE initialize_date_formats(
      p_date_format         OUT giis_parameters.param_value_v%TYPE,
      p_lc_mn               OUT giis_parameters.param_value_v%TYPE,
      p_lc_pa               OUT giis_parameters.param_value_v%TYPE,
      p_slc_tr              OUT giis_parameters.param_value_v%TYPE,
      p_override            OUT giis_parameters.param_value_v%TYPE, 
      p_require_nr_reason   OUT giis_parameters.param_value_v%TYPE
    ) 
    IS
    BEGIN
      SELECT param_value_v 
        INTO p_date_format
        FROM giis_parameters 
       WHERE param_name = 'DATE_FORMAT';
       
       FOR i IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name LIKE 'OVERRIDE_RENEWAL')
        LOOP
            p_override := i.param_value_v;
        END LOOP;


        FOR a IN(SELECT param_value_v
                   FROM giis_parameters
                  WHERE param_name LIKE 'REQUIRE_NON_RENEW_REASON')
        LOOP
            p_require_nr_reason :=    a.param_value_v; 
        END LOOP;
       
       FOR A1 IN (SELECT  a.param_value_v  a_param_value_v,
                          b.param_value_v  b_param_value_v,
                          c.param_value_v  c_param_value_v
                    FROM  giis_parameters a,
                          giis_parameters b,
                          giis_parameters c
                   WHERE  a.param_name LIKE 'MARINE CARGO LINE CODE'
                     AND  b.param_name LIKE 'PERSONAL ACCIDENT'
                     AND  c.param_name LIKE 'GENERAL TRAVEL') 
       LOOP
          p_lc_mn  := a1.a_param_value_v;
          p_lc_pa  := a1.b_param_value_v;
          p_slc_tr := a1.c_param_value_v;
          EXIT;
       END LOOP;
    END initialize_date_formats;

    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 09.19.2011
    **  Reference By    : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description     : Initializes the global line codes
    */
    PROCEDURE initialize_line_cd(
        p_msg       OUT VARCHAR2,
        p_line_ac   OUT giis_parameters.param_value_v%TYPE,
        p_line_av   OUT giis_parameters.param_value_v%TYPE,
        p_line_ca   OUT giis_parameters.param_value_v%TYPE,
        p_line_en   OUT giis_parameters.param_value_v%TYPE,
        p_line_fi   OUT giis_parameters.param_value_v%TYPE,
        p_line_mc   OUT giis_parameters.param_value_v%TYPE,
        p_line_mh   OUT giis_parameters.param_value_v%TYPE,
        p_line_mn   OUT giis_parameters.param_value_v%TYPE,
        p_line_su   OUT giis_parameters.param_value_v%TYPE,
        p_v_iss_ri  OUT giis_parameters.param_value_v%TYPE
    ) 
    IS
      v_switch    varchar2(1) := 'N';
    BEGIN
       FOR L IN (
          SELECT a.param_value_v A, b.param_value_v B, c.param_value_v C,
                 d.param_value_v D, e.param_value_v E, f.param_value_v F,
                 g.param_value_v G, h.param_value_v H, i.param_value_v I,
                 j.param_value_v J
            FROM giis_parameters a, giis_parameters b, giis_parameters c,
                 giis_parameters d, giis_parameters e, giis_parameters f,
                 giis_parameters g, giis_parameters h, giis_parameters i,
                 giis_parameters j
           WHERE a.param_name = 'LINE_CODE_AC'
             AND b.param_name = 'LINE_CODE_AV'
             AND c.param_name = 'LINE_CODE_CA'
             AND d.param_name = 'LINE_CODE_EN'
             AND e.param_name = 'LINE_CODE_FI'
             AND f.param_name = 'LINE_CODE_MC'
             AND g.param_name = 'LINE_CODE_MH'
             AND h.param_name = 'LINE_CODE_MN'
             AND i.param_name = 'LINE_CODE_SU'
             AND j.param_name = 'ISS_CD_RI')
       LOOP
          p_line_ac  := l.a;
          p_line_av  := l.b;
          p_line_ca  := l.c;
          p_line_en  := l.d;
          p_line_fi  := l.e;
          p_line_mc  := l.f;
          p_line_mh  := l.g;
          p_line_mn  := l.h;
          p_line_su  := l.i;
          p_v_iss_ri := l.j;
          v_switch   := 'Y';
       END LOOP;
       
       IF v_switch = 'N' THEN
          BEGIN
             p_msg := 'No data found in the parameter maintenance table. '||
                       'Will now use default values for lines ...';
             p_line_ac   := 'AC';
             p_line_av   := 'AV';
             p_line_ca   := 'CA';
             p_line_en   := 'EN';
             p_line_fi   := 'FI'; 
             p_line_mc   := 'MC';
             p_line_mh   := 'MH';
             p_line_mn   := 'MN';
             p_line_su   := 'SU';
             p_v_iss_ri  := 'RI' ;
          END;
       END IF;
      
    END initialize_line_cd;

    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 09.19.2011
    **  Reference By    : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description     : Initializes the global subline codes
    */
    PROCEDURE initialize_subline_cd(
        p_msg           OUT VARCHAR2,
        p_subline_car   OUT giis_parameters.param_value_v%TYPE,
        p_subline_ear   OUT giis_parameters.param_value_v%TYPE,
        p_subline_mbi   OUT giis_parameters.param_value_v%TYPE,
        p_subline_mlop  OUT giis_parameters.param_value_v%TYPE,
        p_subline_dos   OUT giis_parameters.param_value_v%TYPE,
        p_subline_bpv   OUT giis_parameters.param_value_v%TYPE,
        p_subline_eei   OUT giis_parameters.param_value_v%TYPE,
        p_subline_pcp   OUT giis_parameters.param_value_v%TYPE,
        p_subline_op    OUT giis_parameters.param_value_v%TYPE,
        p_subline_bbi   OUT giis_parameters.param_value_v%TYPE,
        p_subline_mop   OUT giis_parameters.param_value_v%TYPE,
        p_subline_mrn   OUT giis_parameters.param_value_v%TYPE,
        p_subline_oth   OUT giis_parameters.param_value_v%TYPE,
        p_subline_open  OUT giis_subline.subline_cd%TYPE,
        p_vessel_cd     OUT giis_parameters.param_value_v%TYPE
    ) 
    IS
      v_switch    varchar2(1) := 'N';
      v_exist     varchar2(1) := 'N';
    BEGIN
       FOR L IN (
          SELECT a.param_value_v A, b.param_value_v B, c.param_value_v C,
                 d.param_value_v D, e.param_value_v E, f.param_value_v F,
                 g.param_value_v G, h.param_value_v H, i.param_value_v I,
                 j.param_value_v J, k.param_value_v K, l.param_value_v L
            FROM giis_parameters a, giis_parameters b, giis_parameters c,
                 giis_parameters d, giis_parameters e, giis_parameters f,
                 giis_parameters g, giis_parameters h, giis_parameters i,
                 giis_parameters j, giis_parameters k, giis_parameters l
           WHERE a.param_name = 'CONTRACTOR_ALL_RISK'
             AND b.param_name = 'ERECTION_ALL_RISK'
             AND c.param_name = 'MACHINERY_BREAKDOWN_INSURANCE'
             AND d.param_name = 'MACHINERY_LOSS_OF_PROFIT'
             AND e.param_name = 'DETERIORATION_OF_STOCKS'
             AND f.param_name = 'BOILER_AND_PRESSURE_VESSEL'
             AND g.param_name = 'ELECTRONIC_EQUIPMENT'
             AND h.param_name = 'PRINCIPAL_CONTROL_POLICY'
             AND i.param_name = 'OPEN_POLICY'
             AND j.param_name = 'BANKERS BLANKET INSURANCE'
             AND k.param_name = 'SUBLINE_MN_MOP'
             AND l.param_name = 'MN_SUBLINE_MRN')
       LOOP
          p_subline_car  := l.a;
          p_subline_ear  := l.b;
          p_subline_mbi  := l.c;
          p_subline_mlop := l.d;
          p_subline_dos  := l.e;
          p_subline_bpv  := l.f;
          p_subline_eei  := l.g;
          p_subline_pcp  := l.h;
          p_subline_op   := l.i;
          p_subline_bbi  := l.j;
          p_subline_mop  := l.k;
          p_subline_mrn  := l.l;
          v_switch       := 'Y';
       END LOOP;
       
       IF v_switch = 'N' THEN
          BEGIN
             p_msg := 'No data found in the parameter maintenance table. '||
                       'Will now use default values..';
             p_subline_car   := 'CAR';
             p_subline_ear   := 'EAR';
             p_subline_mbi   := 'MBI';
             p_subline_mlop  := 'MLOP';
             p_subline_dos   := 'DOS';
             p_subline_bpv   := 'BPV'; 
             p_subline_eei   := 'EEI';
             p_subline_pcp   := 'PCP';
             p_subline_op    := 'OP';
             p_subline_oth   := 'OTH';
             p_subline_mrn   := 'MRN';
          END;
       END IF;

       FOR op IN (
          SELECT subline_cd
            FROM giis_subline
           WHERE open_policy_sw = 'Y')
       LOOP
         v_exist                := 'Y';
         p_subline_open := op.subline_cd;
       END LOOP;
     
       IF v_exist = 'N' THEN
         p_subline_open := 'MRN';
       END IF;    

       FOR det_cd IN (
         SELECT param_value_v
           FROM giis_parameters
          WHERE param_name = 'VESSEL_CD_MULTI')
       LOOP
          p_vessel_cd := det_cd.param_value_v;
       END LOOP;

    END initialize_subline_cd;
	
	--added get_engg_subline_name by robert SR 4945 09.10.15
	FUNCTION get_engg_subline_name(
       p_subline_cd        giis_parameters.param_value_v%TYPE
    ) RETURN VARCHAR2 AS
       v_subline_name      giis_parameters.param_name%TYPE;
    BEGIN
       FOR i IN
          (SELECT   param_name
               FROM giis_parameters
              WHERE remarks LIKE '%ENGINEERING_SUBLINE_VALIDATION%'
                AND UPPER (p_subline_cd) IN (
                         SELECT UPPER (COLUMN_VALUE)
                           FROM TABLE (split_comma_separated_string (param_value_v)
                                      ))
           ORDER BY param_name)
       LOOP
          v_subline_name := i.param_name;
          EXIT;
       END LOOP; 
       
       RETURN v_subline_name;
    END;

END GIIS_PARAMETERS_PKG;
/



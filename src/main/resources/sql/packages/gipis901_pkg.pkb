CREATE OR REPLACE PACKAGE BODY CPI.GIPIS901_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   09.03.2013
     ** Referenced By:  GIPIS901 - Generate Statistical Reports
     **/
     
    FUNCTION get_mn_subline_lov
        RETURN subline_tab PIPELINED
    AS
        lov     subline_type;
    BEGIN
        FOR i IN (select subline_name, subline_cd, line_cd 
                    from giis_subline 
                   where line_cd in (giisp.v('LINE_CODE_MN'),
                         giisp.v('LINE_CODE_MH')) 
                   order by line_cd, subline_cd, subline_name)
        LOOP
            lov.line_cd         := i.line_cd;
            lov.subline_cd      := i.subline_cd;
            lov.subline_name    := i.subline_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_mn_subline_lov;
    
    
    FUNCTION get_mn_vessel_lov
        RETURN vessel_tab PIPELINED
    AS
        lov     vessel_type;
    BEGIN
        FOR i IN (select vessel_name, vessel_cd 
                    from giis_vessel 
                   order by vessel_cd,vessel_name)
        LOOP
            lov.vessel_cd   := i.vessel_cd;
            lov.vessel_name := i.vessel_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_mn_vessel_lov;
    
    
    FUNCTION populate_gixx071(
        p_subline           GIIS_SUBLINE.SUBLINE_NAME%type,
        p_vessel            GIIS_VESSEL.VESSEL_NAME%type,
        p_from_date         DATE,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    ) RETURN NUMBER
    AS
        CURSOR EXTRACT IS
            (SELECT B250.POLICY_ID ,B250.SUBLINE_CD ,A210.SUBLINE_NAME ,A1160.VESSEL_CD ,A1160.VESSEL_NAME ,
                    B250.LINE_CD||'-'||B250.SUBLINE_CD||'-'||B250.ISS_CD||'-'|| LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))||'-'||
                     LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(B250.RENEW_NO,'09'))  POLICY_NO,
                    B250.ASSD_NO ,A020.ASSD_NAME ,A160.SHARE_CD ,A160.TRTY_NAME
                    ,SUM((NVL(C130.DIST_TSI,0)  * NVL(B340.CURRENCY_RT,0)))  DIST_TSI
                    ,SUM((NVL(C130.DIST_PREM,0) * NVL(B340.CURRENCY_RT,0)))  DIST_PREM            
               FROM GIPI_POLBASIC      B250
                    ,GIPI_ITEM          B340
                    ,GIUW_POL_DIST      C080
                    ,GIUW_POLICYDS      C110
                    ,GIUW_POLICYDS_DTL  C130
                    ,GIPI_CARGO         B090
                    ,GIIS_ASSURED          A020
                    ,GIIS_VESSEL        A1160
                    ,GIIS_SUBLINE       A210
                    ,GIIS_DIST_SHARE     A160
              WHERE  --B250.LINE_CD = 'MN'
                    B250.LINE_CD = GIISP.V('LINE_CODE_MN')    --8/11/2011 bmq
                AND NOT EXISTS (SELECT 1
                                  FROM GIIS_PARAMETERS
                                 WHERE PARAM_NAME LIKE 'ACCTG_ISS_CD_G%'
                                   AND PARAM_VALUE_V = B250.ISS_CD )
                AND A210.LINE_CD     = B250.LINE_CD
                AND A210.SUBLINE_CD  = B250.SUBLINE_CD
                AND B250.ASSD_NO     = A020.ASSD_NO 
                AND B250.POLICY_ID   = C080.POLICY_ID
                AND C080.POLICY_ID   = B340.POLICY_ID
                AND B340.POLICY_ID   = B090.POLICY_ID
                AND B340.ITEM_NO     = B090.ITEM_NO
                AND B090.VESSEL_CD   = A1160.VESSEL_CD
                AND C080.DIST_NO     = C110.DIST_NO
                AND C110.DIST_NO     = C130.DIST_NO
                AND C110.DIST_SEQ_NO = C130.DIST_SEQ_NO
                AND C130.LINE_CD     = A160.LINE_CD
                AND C130.SHARE_CD    = A160.SHARE_CD
                AND B250.DIST_FLAG   = '3'
                AND TRUNC(B250.EFF_DATE) BETWEEN 
                       NVL(TRUNC(p_from_date), TRUNC(B250.EFF_DATE)) 
                       AND NVL(TRUNC(p_to_date), TRUNC(B250.EFF_DATE))
                AND UPPER(A1160.VESSEL_NAME) = UPPER(NVL(P_VESSEL,A1160.VESSEL_NAME))
                AND UPPER(A210.SUBLINE_NAME) = UPPER(NVL(P_SUBLINE,A210.SUBLINE_NAME))
                AND B250.ACCT_ENT_DATE IS NOT NULL
                AND check_user_per_line2(B250.line_cd, B250.iss_cd, 'GIPIS901', p_user_id) = 1
                AND check_user_per_iss_cd2(B250.line_cd, B250.iss_cd, 'GIPIS901', p_user_id) = 1
              GROUP BY B250.POLICY_ID ,B250.SUBLINE_CD ,A210.SUBLINE_NAME ,A1160.VESSEL_CD ,A1160.VESSEL_NAME ,B250.LINE_CD
                    ,B250.SUBLINE_CD ,B250.ISS_CD ,LTRIM(TO_CHAR(B250.ISSUE_YY,'09')) ,LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))
                    ,LTRIM(TO_CHAR(B250.RENEW_NO,'09')) ,B250.ASSD_NO ,A020.ASSD_NAME
                    ,A160.SHARE_CD ,A160.TRTY_NAME
                    );
                    
        v_extract_id        NUMBER;
    BEGIN
        select nvl(max(extract_id),0) + 1
          into v_extract_id
          from gixx_mrn_vessel_stat;
          
        FOR EXT IN EXTRACT 
        LOOP
            INSERT INTO GIXX_MRN_VESSEL_STAT (EXTRACT_ID ,POLICY_ID ,SUBLINE_CD ,SUBLINE_NAME
                                              ,VESSEL_CD ,VESSEL_NAME ,POLICY_NO ,ASSD_NO 
	                                          ,ASSD_NAME ,SHARE_CD ,TRTY_NAME ,DIST_TSI
                                              ,DIST_PREM ,USER_ID ,RUNDATE )
                                      VALUES (V_EXTRACT_ID ,EXT.POLICY_ID ,EXT.SUBLINE_CD ,EXT.SUBLINE_NAME
                                              ,EXT.VESSEL_CD ,EXT.VESSEL_NAME ,EXT.POLICY_NO ,EXT.ASSD_NO
                                              ,EXT.ASSD_NAME ,EXT.SHARE_CD ,EXT.TRTY_NAME ,EXT.DIST_TSI
                                              ,EXT.DIST_PREM ,P_USER_ID ,SYSDATE );

            --  check the number of records processed
            --v_rec_count := v_rec_count + 1;
            --message(to_char(v_rec_count)||' records processed... please wait...',NO_ACKNOWLEDGE);
            --synchronize;

        END LOOP;
        
        RETURN (v_extract_id);
    END populate_gixx071;
    
    
    FUNCTION populate_gixx072(
        p_subline           GIIS_SUBLINE.SUBLINE_NAME%type,
        p_cargo_class_cd    GIIS_CARGO_CLASS.CARGO_CLASS_CD%type,
        p_from_date         DATE,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    ) RETURN NUMBER
    AS
        CURSOR EXTRACT IS 
           ( SELECT B250.POLICY_ID, B250.SUBLINE_CD, A210.SUBLINE_NAME, A100.CARGO_CLASS_CD, A100.CARGO_CLASS_DESC,
                    B250.LINE_CD||'-'|| B250.SUBLINE_CD||'-'||  B250.ISS_CD||'-'|| LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))||'-'||
                        LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'|| LTRIM(TO_CHAR(B250.RENEW_NO,'09'))   POLICY_NO,
                    B250.ASSD_NO, A220.ASSD_NAME, A160.SHARE_CD, A160.TRTY_NAME,
                    SUM((NVL(C130.DIST_TSI,0)  * NVL(B340.CURRENCY_RT,0)))  DIST_TSI,
                    SUM((NVL(C130.DIST_PREM,0) * NVL(B340.CURRENCY_RT,0)))  DIST_PREM
               FROM GIPI_POLBASIC 	B250,
                    GIPI_ITEM           B340,
                    GIUW_POL_DIST 	C080,
                    GIUW_POLICYDS 	C110,
                    GIUW_POLICYDS_DTL 	C130,
                    GIIS_ASSURED 	A220,
                    GIIS_CARGO_CLASS 	A100,
                    GIIS_SUBLINE 	A210,
                    GIIS_DIST_SHARE 	A160,
                    GIPI_CARGO  	B090
              WHERE --B250.LINE_CD = 'MN'
                    B250.LINE_CD = GIISP.V('LINE_CODE_MN')	--8/11/2011 bmq
                AND B250.ISS_CD NOT IN ( SELECT PARAM_VALUE_V
                                           FROM GIIS_PARAMETERS
                                          WHERE PARAM_NAME LIKE 'ACCTG_ISS_CD_G%') 
                AND A210.LINE_CD	= B250.LINE_CD
                AND A210.SUBLINE_CD	= B250.SUBLINE_CD
                AND B250.ASSD_NO	= A220.ASSD_NO
                AND B250.POLICY_ID	= C080.POLICY_ID
                AND C080.POLICY_ID      = B340.POLICY_ID
                AND B340.POLICY_ID      = B090.POLICY_ID
                AND B340.ITEM_NO        = B090.ITEM_NO
                AND B090.CARGO_CLASS_CD	= A100.CARGO_CLASS_CD           
                AND C080.DIST_NO	= C110.DIST_NO
                AND C110.DIST_NO	= C130.DIST_NO
                AND C110.DIST_SEQ_NO    = C130.DIST_SEQ_NO
                AND C130.LINE_CD        = A160.LINE_CD
                AND C130.SHARE_CD       = A160.SHARE_CD
                AND B250.DIST_FLAG	= '3'
                AND TRUNC(B250.EFF_DATE) BETWEEN TRUNC(p_from_date)
                        AND TRUNC(p_to_date)
                AND A100.CARGO_CLASS_CD	= NVL(P_CARGO_CLASS_CD, A100.CARGO_CLASS_CD)
                AND UPPER(A210.SUBLINE_NAME)= UPPER(NVL(P_SUBLINE, A210.SUBLINE_NAME))
                AND B250.ACCT_ENT_DATE IS NOT NULL
                AND check_user_per_line2(B250.line_cd, B250.iss_cd, 'GIPIS901', p_user_id) = 1
                AND check_user_per_iss_cd2(B250.line_cd, B250.iss_cd, 'GIPIS901', p_user_id) = 1
              GROUP BY B250.POLICY_ID, B250.SUBLINE_CD, A210.SUBLINE_NAME, A100.CARGO_CLASS_CD, A100.CARGO_CLASS_DESC,
                       B250.LINE_CD||'-'|| B250.SUBLINE_CD||'-'|| B250.ISS_CD||'-'|| LTRIM(TO_CHAR(B250.ISSUE_YY,'09'))||'-'||
                            LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999'))||'-'|| LTRIM(TO_CHAR(B250.RENEW_NO,'09')),
                       B250.ASSD_NO, A220.ASSD_NAME, A160.SHARE_CD, A160.TRTY_NAME);
        
        v_extract_id        NUMBER;
    BEGIN
        select nvl(max(extract_id),0) + 1
          into v_extract_id
          from gixx_mrn_cargo_stat;

        FOR EXT IN EXTRACT 
        LOOP
            INSERT INTO GIXX_MRN_CARGO_STAT ( EXTRACT_ID, SUBLINE_CD, SUBLINE_NAME, CARGO_CLASS_CD,	
                                              CARGO_CLASS_DESC, POLICY_ID, POLICY_NO, ASSD_NO,
                                              ASSD_NAME, SHARE_CD, TRTY_NAME, DIST_TSI, 
                                              DIST_PREM, USER_ID, RUNDATE)
                                     VALUES ( V_EXTRACT_ID ,EXT.SUBLINE_CD ,EXT.SUBLINE_NAME ,EXT.CARGO_CLASS_CD
                                              ,EXT.CARGO_CLASS_DESC ,EXT.POLICY_ID ,EXT.POLICY_NO ,EXT.ASSD_NO
                                              ,EXT.ASSD_NAME ,EXT.SHARE_CD ,EXT.TRTY_NAME ,EXT.DIST_TSI
                                              ,EXT.DIST_PREM ,P_USER_ID ,SYSDATE );

            --v_rec_count := v_rec_count + 1;
            --message(to_char(v_rec_count)||' records processed... please wait...',NO_ACKNOWLEDGE);
            --synchronize;
     
        END LOOP;
        
        RETURN (v_extract_id);
    END populate_gixx072;
    
    
    PROCEDURE GET_REC_CNT_STAT_TAB(
        p_stat_choice    IN  VARCHAR2,
        p_subline        IN  GIIS_SUBLINE.SUBLINE_NAME%type,
        p_vessel         IN  GIIS_VESSEL.VESSEL_NAME%type,
        p_cargo_class_cd IN  GIIS_CARGO_CLASS.CARGO_CLASS_CD%type,
        p_from_date      IN  VARCHAR2,
        p_to_date        IN  VARCHAR2,
        p_user_id        IN  VARCHAR2,
        p_extract_id    OUT  NUMBER,
        p_rec_cnt       OUT  NUMBER
    ) 
    AS
    BEGIN
        IF p_stat_choice = 'V' THEN
            DELETE FROM GIXX_MRN_VESSEL_STAT;
            
            p_extract_id := POPULATE_GIXX071(p_subline, p_vessel, TO_DATE(p_from_date, 'MM-DD-RRRR'), TO_DATE(p_to_date, 'MM-DD-RRRR'), p_user_id);
            
		    SELECT COUNT(1) 
              INTO p_rec_cnt
        	  FROM gixx_mrn_cargo_stat
			 WHERE extract_id = p_extract_id;
             
        ELSIF p_stat_choice = 'C' THEN
            DELETE FROM GIXX_MRN_CARGO_STAT;
            
            p_extract_id := POPULATE_GIXX072(p_subline, p_cargo_class_cd, TO_DATE(p_from_date, 'MM-DD-RRRR'), TO_DATE(p_to_date, 'MM-DD-RRRR'), p_user_id);
            
            -- added condition to check for the number of records and display message when count = 0
            SELECT COUNT(1) 
              INTO p_rec_cnt
        	  FROM gixx_mrn_cargo_stat
			 WHERE extract_id = p_extract_id;
        END IF;
    END GET_REC_CNT_STAT_TAB;


    PROCEDURE extract_records_motor_stat(
        p_motor_stat_type   IN  VARCHAR2,
        p_zone_type         IN  VARCHAR2,
        p_date_param        IN  VARCHAR2,
        p_print_type        IN  VARCHAR2,
        p_date_type         IN  VARCHAR2,
        p_v_iss_cd          IN  VARCHAR2,
        p_date_from         IN  VARCHAR2,
        p_date_to           IN  VARCHAR2,
        p_year              IN  VARCHAR2,
        p_user              IN  VARCHAR2,
        p_msg               OUT VARCHAR2
    )
    AS
        v_ctr   NUMBER := 0;
    BEGIN
        giis_users_pkg.app_user := p_user;
    
        IF P_MOTOR_STAT_TYPE = 'LTO' AND P_DATE_PARAM  = 'BD' THEN
            LTO_FROMTO.EXTRACT(p_date_type,	 p_v_iss_cd, p_zone_type,
                               TO_DATE(p_date_from, 'MM-DD-RRRR'), TO_DATE(p_date_to, 'MM-DD-RRRR'));
        --else if 'yearly of nlto
        ELSIF P_MOTOR_STAT_TYPE = 'NLTO' AND P_DATE_PARAM  = 'BD' THEN
  	        --msg_alert('nlto_fromto.extract', 'I',false);
            NLTO_FROMTO.EXTRACT(p_date_type, p_v_iss_cd, TO_NUMBER(p_zone_type),
                                TO_DATE(p_date_from, 'MM-DD-RRRR'), TO_DATE(p_date_to, 'MM-DD-RRRR'));  
        --else if 'yearly' of LTO
        ELSIF P_MOTOR_STAT_TYPE = 'LTO' AND P_DATE_PARAM  = 'BY' THEN
            --msg_alert('lto_yearly.extract', 'I',false);
            LTO_YEARLY.EXTRACT(p_date_type,	 p_v_iss_cd, p_zone_type, TO_NUMBER(p_year));  
        ELSE
            NLTO_YEARLY.EXTRACT(p_date_type, TO_NUMBER(p_year), p_v_iss_cd, TO_NUMBER(p_zone_type));  
        END IF;
	
        --count the number of records that was extracted
	    IF P_MOTOR_STAT_TYPE = 'LTO' AND P_PRINT_TYPE = 'P' THEN
            FOR A IN (SELECT COUNT(*) cnt
                        FROM gixx_lto_stat
                       WHERE 1=1
                         AND user_id = P_USER
                         AND (outside_mla_cnt != 0 
                          OR mla_cnt != 0))
            LOOP
                v_ctr := a.cnt;
            END LOOP;
	    ELSIF P_MOTOR_STAT_TYPE = 'LTO' AND P_PRINT_TYPE = 'L' THEN
            FOR A IN (SELECT COUNT(*) cnt
                        FROM gixx_lto_claim_stat
                       WHERE 1=1
                         AND user_id = P_USER
                         AND (outside_mla_cnt != 0 
                          OR mla_clm_cnt != 0))
            LOOP
                v_ctr := a.cnt;
            END LOOP;	 	
	    ELSIF P_MOTOR_STAT_TYPE = 'NLTO' AND P_PRINT_TYPE = 'P' THEN
            FOR A IN (SELECT COUNT(*) cnt
                        FROM gixx_nlto_stat
                       WHERE 1=1
                         AND user_id = P_USER
                         AND (pc_count != 0 
                          OR cv_count != 0
                          OR mc_count != 0))
            LOOP
                v_ctr := a.cnt;
            END LOOP;
	    ELSIF P_MOTOR_STAT_TYPE = 'NLTO' AND P_PRINT_TYPE = 'L' THEN
            FOR A IN (SELECT COUNT(*) cnt
                        FROM gixx_nlto_claim_stat
                       WHERE 1=1
                         AND user_id = P_USER
                         AND (pc_clm_count != 0 
                          OR cv_clm_count != 0
                          OR mc_clm_count != 0))
            LOOP
                v_ctr := a.cnt;
            END LOOP;
	    END IF;
        
        COMMIT;
        
        p_msg := 'Extraction successfully complete. ' || v_ctr || ' record(s) processed.';
        
    END extract_records_motor_stat;
    
    
     FUNCTION chk_existing_record_motor_stat(
        p_motor_stat_type   VARCHAR2,
        p_print_type        VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_exist     VARCHAR2(1) := 'N';
    BEGIN
        IF p_print_type = 'L' THEN
            IF p_motor_stat_type = 'NLTO' THEN
                FOR REC IN (SELECT '1'
                              FROM gixx_nlto_claim_stat
                             WHERE user_id = p_user_id
                               AND (pc_clm_count != 0
                                OR cv_clm_count != 0
                                OR mc_clm_count != 0))
                LOOP
                    v_exist := 'Y';
                    EXIT;
                END LOOP;
            ELSIF p_motor_stat_type = 'LTO' THEN
                FOR rec IN (SELECT '1'
                              FROM gixx_lto_claim_stat
                             WHERE user_id = p_user_id
                               AND (mla_clm_cnt != 0 
                                OR outside_mla_cnt != 0))
                LOOP
                    v_exist := 'Y';
                    EXIT;
                END LOOP;
            END IF;
        ELSIF p_print_type = 'P' THEN
            IF p_motor_stat_type = 'NLTO' THEN
              FOR REC IN (SELECT '1'
                            FROM gixx_nlto_stat
                           WHERE user_id = p_user_id
                             AND (pc_count != 0
                              OR cv_count != 0
                              OR mc_count != 0))
                LOOP
                    v_exist := 'Y';
                    EXIT;
                END LOOP;
            ELSIF p_motor_stat_type = 'LTO' THEN
                FOR rec IN (SELECT '1' 
                              FROM gixx_lto_stat
                             WHERE user_id = p_user_id
                               AND (mla_cnt != 0 
                                OR outside_mla_cnt != 0))
                LOOP
                    v_exist := 'Y';
                    EXIT;
                END LOOP;
            END IF;   --end if for motor_stat.type...           
        END IF;
        
        RETURN (v_exist);
    END chk_existing_record_motor_stat;
    
    
    PROCEDURE extract_fire_stat(
        p_fire_stat     IN  VARCHAR2,
        p_date_rb       IN  VARCHAR2,    
        p_date          IN  VARCHAR2,
        p_date_from     IN  VARCHAR2,
        p_date_to       IN  VARCHAR2,
        p_as_of_date    IN  VARCHAR2,
        p_bus_cd        IN  NUMBER,
        p_zone          IN  VARCHAR2,
        p_zone_type     IN  VARCHAR2,
        p_risk_cnt      IN  VARCHAR2,
        p_incl_endt     IN  VARCHAR2,
        p_incl_exp      IN  VARCHAR2,
        p_peril_type    IN  VARCHAR2,
        p_user          IN  VARCHAR2,
        p_cnt           OUT NUMBER
    )
    AS
        v_datefrom      DATE := TO_DATE(p_date_from, 'MM-DD-RRRR');
        v_dateto        DATE := TO_DATE(p_date_to, 'MM-DD-RRRR');
        v_as_of         DATE := TO_DATE(p_as_of_date, 'MM-DD-RRRR');
        v_ctr           NUMBER;
    BEGIN
        IF p_date_rb = '1' THEN
            BEGIN 
                /*Determines what kind of statistical report will be extracted (either by zone or by tariff) */
                IF p_fire_stat = 'by_zone' THEN 
                    /*p_zone_fromto_dtl.extract(v_datefrom, v_dateto, p_date, p_bus_cd, p_zone, p_zone_type,
                                              p_incl_endt,p_incl_exp, p_peril_type, p_user); 8?--added p_user : edgar 03/09/2015                    
          
                    /*p_zone_fromto.extract(v_datefrom, v_dateto, p_date, p_bus_cd, p_zone, p_zone_type,
                                          p_incl_endt,p_incl_exp, p_peril_type, p_risk_cnt, p_user); */-- aaron include_endt   --added p_user : edgar 03/09/2015
                    
                    p_zone_fromto_dtl.extract2(v_datefrom, v_dateto, p_date, p_bus_cd, p_zone, p_zone_type,
                                              p_incl_endt,p_incl_exp, p_peril_type, p_user); --edgar 03/13/2015   
                      /*message('Extraction successfully completed',no_acknowledge);
                      synchronize;
                      cursor_normal;   */               
                    
                      /* -- comment out by aaron 030509
                     -- IF :fire_stat.rep_type = 1 THEN --fire stat
                              SELECT count(*)
                            INTO v_ctr
                            FROM gipi_firestat_extract
                               WHERE (no_of_risk <> 0 or
                                  no_of_risk is null) 
                             AND share_tsi_amt <> 0
                             AND share_prem_amt  <> 0
                             AND as_of_sw = 'N'
                             AND user_id = USER;*/
                     --  ELSIF :fire_stat.rep_type = 2 THEN --commitment  accumltn summary
                      /*SELECT count(*)
                        INTO v_ctr
                        FROM (SELECT DISTINCT policy_id
                                FROM gipi_firestat_extract_dtl
                               WHERE share_tsi_amt <> 0
                                 AND share_prem_amt  <> 0
                                 AND as_of_sw = 'N'
                                 AND user_id = P_USER
                                 AND zone_type = p_zone_type ); */
                                 
                       SELECT COUNT (DISTINCT line_cd
                                       || '-'
                                       || subline_cd
                                       || '-'
                                       || iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (issue_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                       || '-'
                                       || LTRIM (TO_CHAR (renew_no, '09'))
                                     ) cnt
                            INTO v_ctr         
                          FROM gipi_firestat_extract_dtl
                         WHERE 1 = 1 AND as_of_sw = 'N' AND user_id = p_user
                               AND zone_type = p_zone_type
                        HAVING SUM (NVL (share_tsi_amt, 0)) <> 0 ; 
                          
                                 
                    -- END IF;
                     
                ELSIF p_fire_stat = 'by_tariff' THEN  
                    /*p_tariff_fromto_dtl.extract(v_datefrom, v_dateto, p_bus_cd, p_zone, p_zone_type, 
                                                p_date, p_incl_endt, p_peril_type, p_incl_exp, p_user); --edgar 03/09//2015
              
                  
                    p_tariff_fromto.extract(v_datefrom, v_dateto, p_bus_cd, p_zone, p_zone_type, p_date, p_user); --edgar 03/09//2015  */
                    
                    p_zone_fromto_dtl.extract2(v_datefrom, v_dateto, p_date, p_bus_cd, p_zone, p_zone_type,
                                              p_incl_endt,p_incl_exp, p_peril_type, p_user); --edgar 03/13/2015    
                  
                      /*message('Extraction successfully completed',no_acknowledge);
                      synchronize;
                      cursor_normal;         */  
                                 
                      /*SELECT count(*)
                        INTO v_ctr
                       FROM /*gixx_firestat_summary*/ --gipi_firestat_extract_dtl --edgar 03/13/2015
                       /*WHERE 1=1
                         AND share_tsi_amt <> 0         --edgar 03/13/2015
                         AND share_prem_amt  <> 0      --edgar 03/13/2015
                           AND as_of_sw = 'N'
                           AND zone_type = p_zone_type 
                         AND user_id = P_USER;  */
                        SELECT COUNT (DISTINCT line_cd
                                       || '-'
                                       || subline_cd
                                       || '-'
                                       || iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (issue_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                       || '-'
                                       || LTRIM (TO_CHAR (renew_no, '09'))
                                     ) cnt
                            INTO v_ctr         
                          FROM gipi_firestat_extract_dtl
                         WHERE 1 = 1 AND as_of_sw = 'N' AND user_id = p_user
                               AND zone_type = p_zone_type
                        HAVING SUM (NVL (share_tsi_amt, 0)) <> 0 ;      
                END IF;
            END;
        ELSIF p_date_rb = '2' THEN
            BEGIN 
                IF p_fire_stat = 'by_zone' THEN                           
                   /*msg_alert('p_zone_asof.extract','I',false);
                   msg_alert('variables.v_as_of'||' '||variables.v_as_of,'I',FALSE);
                   MSG_ALERT('variables.p_bus_cd'||' '||variables.p_bus_cd,'I',FALSE);
                    MSG_ALERT('variables.p_zone'||' '||variables.p_zone,'I',FALSE);
                    MSG_ALERT('variables.v_dsp_zone'||' '||variables.v_dsp_zone,'I',FALSE);*/
                     
                    --     p_zone_asof.extract(variables.v_as_of, variables.p_bus_cd,
                    --          variables.p_zone,variables.v_dsp_zone);                       
                        
                            /*  pause;                                                        
                        msg_alert('p_zone_asof_dtl.extract','I',false);                      */
                            

                    p_zone_asof_dtl.extract2(v_as_of, p_bus_cd, p_zone, p_zone_type, p_incl_endt, p_incl_exp, p_peril_type, p_user);--edgar 02/23/2015
              
                   -- p_zone_asof.extract(v_as_of, p_bus_cd, p_zone, p_zone_type, p_incl_endt, p_incl_exp, p_peril_type, p_risk_cnt, p_user);--edgar 02/23/2015  -- jhing 03.19.2015 commented out 
             
                      /*message('Extraction successfully completed',no_acknowledge);
                      synchronize;
                      cursor_normal;  */              
                          
                      -- comment out by aaron 030509
                      /*IF :fire_stat.rep_type = 1 THEN --fire stat      
                              SELECT count(*)
                            INTO v_ctr
                            FROM gipi_firestat_extract
                               WHERE (no_of_risk <> 0 OR
                              no_of_risk IS NULL) 
                             AND share_tsi_amt <> 0
                             AND share_prem_amt  <> 0
                             AND as_of_sw = 'Y'
                             AND user_id = USER; */
                      --added by erin,062105 
                            --    ELSIF :fire_stat.rep_type = 2 THEN --commitment  accumltn summary  comment out by aaron 030509
                    /*SELECT count(*)
                      INTO v_ctr
                      FROM (SELECT DISTINCT policy_id
                              FROM gipi_firestat_extract_dtl
                             WHERE share_tsi_amt <> 0
                               AND share_prem_amt  <> 0
                               AND as_of_sw = 'Y'
                               AND zone_type = p_zone_type
                               AND user_id = P_USER); */
                         SELECT COUNT (DISTINCT line_cd
                                       || '-'
                                       || subline_cd
                                       || '-'
                                       || iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (issue_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                       || '-'
                                       || LTRIM (TO_CHAR (renew_no, '09'))
                                     ) cnt
                            INTO v_ctr         
                          FROM gipi_firestat_extract_dtl
                         WHERE 1 = 1 AND as_of_sw = 'Y' AND user_id = p_user
                               AND zone_type = p_zone_type
                        HAVING SUM (NVL (share_tsi_amt, 0)) <> 0 ;    
                               
                 -- END IF;  -- aaron 030509
                ELSIF p_fire_stat = 'by_tariff' THEN
                    BEGIN              
                        --    p_tariff_asof.extract(variables.v_as_of, variables.p_bus_cd,
                        --    variables.p_zone,variables.v_dsp_zone);

                      --  p_tariff_asof_dtl.extract(v_as_of, p_bus_cd, p_zone, p_zone_type, p_incl_endt, p_incl_exp, p_peril_type, p_user);--edgar 03/09/2015
                                    
                                    
                      --  p_tariff_asof.extract(v_as_of, p_bus_cd, p_zone ,p_zone_type, p_user);--edgar 03/09/2015
                      
                      
                        p_zone_asof_dtl.extract2(v_as_of, p_bus_cd, p_zone, p_zone_type, p_incl_endt, p_incl_exp, p_peril_type, p_user);-- jhing 03.19.2015 
  
                                    
                        /*   message('Extraction successfully completed',no_acknowledge);
                          synchronize;
                          cursor_normal; */
                              
                       /* SELECT count(*)
                          INTO v_ctr
                          FROM gixx_firestat_summary
                         WHERE 1=1
                           AND tsi_amt <> 0
                           AND prem_amt  <> 0
                           AND as_of_sw = 'Y'
                           AND user_id = P_USER; */ -- commented out jhing 03.21.2015
                       SELECT COUNT (DISTINCT line_cd
                                       || '-'
                                       || subline_cd
                                       || '-'
                                       || iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (issue_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                       || '-'
                                       || LTRIM (TO_CHAR (renew_no, '09'))
                                     ) cnt
                            INTO v_ctr         
                          FROM gipi_firestat_extract_dtl
                         WHERE 1 = 1 AND as_of_sw = 'Y' AND user_id = p_user
                               AND zone_type = p_zone_type
                        HAVING SUM (NVL (share_tsi_amt, 0)) <> 0 ;    
                           
                    END;
                END IF;
            END;
        END IF;
        
        p_cnt := v_ctr;

    END extract_fire_stat;
    

    FUNCTION populate_fire_tariff_master(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%TYPE--VARCHAR2 
    ) RETURN fire_tariff_master_tab PIPELINED
    AS
        rec     fire_tariff_master_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM giis_tariff
                   WHERE tarf_cd in (select distinct tarf_cd 
	                                    from /*gixx_firestat_summary_dtl*/ gipi_firestat_extract_dtl -- jhing 03.19.2015 
	                                   where user_id = P_USER_ID
	                                     and as_of_sw = p_as_of_sw
                                         and zone_type = p_zone_type 
                                         ) )
        LOOP            
            rec.tarf_cd     := i.tarf_cd;
            rec.tarf_desc   := i.tarf_desc;
            
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_tariff_master;
    
    
    FUNCTION populate_fire_tariff_detail(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_tarf_cd       gixx_firestat_summary_dtl.TARF_CD%type,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%TYPE--VARCHAR2 
    ) RETURN fire_tariff_detail_tab PIPELINED
    AS
        rec     fire_tariff_detail_type;
    BEGIN
        FOR i IN (SELECT DISTINCT assd_no, /*SUM(tsi_amt)*/ SUM(NVL(share_tsi_amt, 0 )) tsi_amt, /*SUM(prem_amt)*/ SUM(NVL(share_prem_amt, 0 )) prem_amt, tarf_cd, /*as_of_sw,*/ user_id, 
                         line_cd||' - '||subline_cd||' - '||iss_cd||' - '||LTRIM(TO_CHAR(issue_yy,'00'))||' - '
                              ||LTRIM(TO_CHAR(pol_seq_no,'0000000'))||' - '||LTRIM(TO_CHAR(renew_no,'00')) policy_no,
                         line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no 
                    FROM /*GIXX_FIRESTAT_SUMMARY_DTL */ gipi_firestat_extract_dtl -- jhing 03.19.2015 changed table reference 
                   WHERE tarf_cd = p_tarf_cd
                     AND user_id = P_USER_ID 
	                 AND as_of_sw = p_as_of_sw
                     AND zone_type = p_zone_type 
                   GROUP BY assd_no, tarf_cd, line_cd, subline_cd, iss_cd,
                            issue_yy, pol_seq_no, renew_no, user_id
                   ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no )
        LOOP
            rec.assd_no     := i.assd_no;
            rec.tsi_amt     := i.tsi_amt;
            rec.prem_amt    := i.prem_amt;
            rec.tarf_cd     := i.tarf_cd;
            rec.policy_no   := i.policy_no;
            /*rec.as_of_sw    := i.as_of_sw;
            rec.line_cd     := i.line_cd;
            rec.subline_cd  := i.subline_cd;
            rec.iss_cd      := i.iss_cd;
            rec.issue_yy    := i.issue_yy;
            rec.pol_seq_no  := i.pol_seq_no;
            rec.renew_no    := i.renew_no;*/
            rec.user_id     := i.user_id;
            
            BEGIN
                FOR a IN (SELECT assd_name|| ' ' || assd_name2 assd_name    -- jhing 03.19.2015 added space before concatenating assd_name and assd_name2 
	                        FROM giis_assured
	                       WHERE assd_no = i.assd_no)
	            LOOP
		            rec.assd_name := a.assd_name;
	            END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.assd_name := null;
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_tariff_detail;
    
    
    FUNCTION populate_fire_zone_master(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_line_cd_fi    VARCHAR2 ,
        p_zone_type     VARCHAR2
    ) RETURN fire_zone_master_tab PIPELINED
    AS
        rec     fire_zone_master_type;
    BEGIN    
       
        FOR i IN (SELECT line_cd , share_cd, SUM(share_tsi_amt) share_tsi_amt, SUM(share_prem_amt) share_prem_amt,as_of_sw,user_id  -- jhing 03.19.2015 added line_cd
                    FROM GIPI_FIRESTAT_EXTRACT_DTL 
                   WHERE user_id = P_USER_ID
                     AND as_of_sw = p_as_of_sw
                     AND zone_type = p_zone_type -- jhing 03.19.2015 
                   GROUP BY line_cd, share_cd,as_of_sw,user_id)
        LOOP
            rec.share_cd        := i.share_cd;
            rec.share_tsi_amt   := i.share_tsi_amt;
            rec.share_prem_amt  := i.share_prem_amt;
            rec.as_of_sw        := i.as_of_sw;
            rec.line_cd         := i.line_cd ; 
            
            BEGIN
                FOR a IN (SELECT distinct trty_name
                            FROM giis_dist_share
                           WHERE share_cd = i.share_cd
                             --AND line_cd  = 'FI'
                             AND line_cd = /*p_line_cd_fi*/ i.line_cd )
	            LOOP
		            rec.share_name := a.trty_name;
	            END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.share_name := null;
            END;
            
            BEGIN --added edgar for line name 03/20/2015
                FOR a IN (SELECT line_name
                            FROM giis_line
                           WHERE line_cd = i.line_cd )
	            LOOP
		            rec.line_name := a.line_name;
	            END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.share_name := null;
            END;      
        
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_zone_master;
    
    
     FUNCTION populate_fire_zone_detail(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_line_cd_fi    VARCHAR2,
        p_share_cd      gipi_firestat_zone_dtl_v.SHARE_CD%type,
        p_line_cd       gipi_firestat_extract_dtl.line_cd%type ,
        p_zone_type     gipi_firestat_extract_dtl.zone_type%TYPE--VARCHAR2 
    ) RETURN fire_zone_detail_tab PIPELINED
    AS
        rec     fire_zone_detail_type;
    BEGIN
        FOR i IN (/*SELECT * 
                    FROM gipi_firestat_zone_dtl_v
                   WHERE user_id = P_USER_ID 
	                 AND as_of_sw = p_as_of_sw
                     AND share_cd = p_share_cd
                   ORDER BY policy_no    -- jhing 03.20.2015 revised query*/
                  SELECT   b.assd_name assd_name,
                        a.line_cd
                     || ' - '
                     || a.subline_cd
                     || ' - '
                     || a.iss_cd
                     || ' - '
                     || LTRIM (TO_CHAR (a.issue_yy, '00'))
                     || ' - '
                     || LTRIM (TO_CHAR (a.pol_seq_no, '0000000'))
                     || ' - '
                     || LTRIM (TO_CHAR (a.renew_no, '00')) policy_no,
                     SUM (NVL (a.share_tsi_amt, 0)) share_tsi_amt,
                     SUM (NVL (a.share_prem_amt, 0)) share_prem_amt, a.as_of_sw,
                     a.user_id, a.line_cd, a.share_cd
                FROM gipi_firestat_extract_dtl a, giis_assured b
               WHERE 1 = 1
                 AND a.user_id = p_user_id
                 AND a.as_of_sw = p_as_of_sw
                 AND a.line_cd = p_line_cd
                 AND a.share_cd = p_share_cd
                 AND a.zone_type = p_zone_type
                 AND a.assd_no = b.assd_no
            GROUP BY a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.as_of_sw,
                     a.user_id,
                     a.share_cd,
                     b.assd_name
            ORDER BY a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no  )
        LOOP
            rec.share_cd        := i.share_cd;
            rec.assd_name       := i.assd_name;
            rec.policy_no       := i.policy_no;
            rec.share_tsi_amt   := i.share_tsi_amt;
            rec.share_prem_amt  := i.share_prem_amt;
            rec.as_of_sw        := i.as_of_sw;
            rec.user_id         := i.user_id;
            rec.line_cd         := i.line_cd ;
            
            BEGIN
                FOR a IN (SELECT trty_name
                            FROM giis_dist_share
                           WHERE share_cd = i.share_cd
                             --AND line_cd  = 'FI'
                             --AND line_cd = p_line_cd_fi  -- jhing 03.20.2015 replaced with:
                             AND line_cd = i.line_cd  )
	            LOOP
		            rec.share_name := a.trty_name;
	            END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.share_name := null;
            END; 
            
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_zone_detail;
    
    
    FUNCTION populate_fire_com_accum_master
        RETURN fire_com_accum_master_tab PIPELINED
    AS
        rec     fire_com_accum_master_type;
    BEGIN
        FOR i IN  ( /*SELECT DISTINCT c.zone_grp, f.share_cd, 'TOTAL '||DECODE(UPPER(e.rv_meaning),'TREATY',UPPER(d.rv_meaning),UPPER(e.rv_meaning)) dist_share 
                      FROM (SELECT rv_meaning, rv_low_value 
                              FROM CG_REF_CODES 
                             WHERE rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') d, 
                           (SELECT rv_meaning, rv_low_value 
                              FROM CG_REF_CODES 
                             WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE') e, 
                           (SELECT DISTINCT NVL(zone_grp,2) zone_grp, a.flood_zone zone_no 
                              FROM giis_flood_zone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,1,1,NULL) = 1 
                               AND b.zone_no = a.flood_zone 
                             UNION 
                            SELECT DISTINCT NVL(zone_grp,2) zone_grp, a.typhoon_zone zone_no 
                              FROM giis_typhoon_zone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,2,2,NULL) = 2 
                               AND b.zone_no = a.typhoon_zone 
                             UNION 
                            SELECT DISTINCT NVL(zone_grp,2) zone_grp, a.eq_zone zone_no 
                              FROM giis_eqzone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,3,3,NULL) = 3 
                               AND b.zone_no = a.eq_zone) c, 
                           giis_dist_share f, 
                           gipi_polbasic a, 
                           gipi_firestat_extract_dtl b 
                     WHERE 1=1 
                       AND f.line_cd = a.line_cd 
                       AND f.share_cd = b.share_cd 
                       AND f.share_type = e.rv_low_value 
                       AND NVL(f.acct_trty_type,0) = DECODE(f.acct_trty_type,NVL(f.acct_trty_type,0),d.rv_low_value,0)
                       AND c.zone_no = b.zone_no 
                       AND a.policy_id = b.policy_id 
                     ORDER BY c.zone_grp, f.share_cd*/ --commented out and replaced with codes below : edgar 03/20/2015
            SELECT DISTINCT c.zone_grp, f.share_cd,
                               'TOTAL '
                            || DECODE (UPPER (e.rv_meaning),
                                       'TREATY', UPPER (d.rv_meaning),
                                       UPPER (e.rv_meaning)
                                      ) dist_share, f.share_type, NVL(f.acct_trty_type,0) acct_trty_type 
                       FROM (SELECT rv_meaning, rv_low_value
                               FROM cg_ref_codes
                              WHERE rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') d,
                            (SELECT rv_meaning, rv_low_value
                               FROM cg_ref_codes
                              WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE') e,
                            (SELECT DISTINCT NVL (zone_grp, 2) zone_grp,
                                             NVL (a.flood_zone, 0) zone_no
                                        FROM giis_flood_zone a,
                                             gipi_firestat_extract_dtl b
                                       WHERE DECODE (b.zone_type, 1, 1, NULL) = 1
                                         AND b.zone_no = a.flood_zone(+)
                             UNION
                             SELECT DISTINCT NVL (zone_grp, 2) zone_grp,
                                             NVL (a.typhoon_zone, 0) zone_no
                                        FROM giis_typhoon_zone a,
                                             gipi_firestat_extract_dtl b
                                       WHERE DECODE (b.zone_type, 2, 2, NULL) = 2
                                         AND b.zone_no = a.typhoon_zone(+)
                             UNION
                             SELECT DISTINCT NVL (zone_grp, 2) zone_grp,
                                             NVL (a.eq_zone, 0) zone_no
                                        FROM giis_eqzone a, gipi_firestat_extract_dtl b
                                       WHERE DECODE (b.zone_type, 3, 3, NULL) = 3
                                         AND b.zone_no = a.eq_zone(+)) c,
                            giis_dist_share f,
                            gipi_firestat_extract_dtl b
                      WHERE 1 = 1
                        AND f.line_cd = b.line_cd
                        AND f.share_cd = b.share_cd
                        AND f.share_type = e.rv_low_value
                        AND NVL (f.acct_trty_type, 0) =
                               DECODE (f.acct_trty_type,
                                       NVL (f.acct_trty_type, 0), d.rv_low_value,
                                       0
                                      )
                        AND c.zone_no = NVL (b.zone_no, 0)
                   ORDER BY c.zone_grp, f.share_cd)
        LOOP
            rec.zone_group  := i.zone_grp;
            rec.share_cd    := i.share_cd;
            rec.dist_share  := i.dist_share;
            rec.share_type  := i.share_type; --edgar 03/20/2015
            rec.acct_trty_type   := i.acct_trty_type ; --edgar 03/20/2015
            
            IF i.zone_grp = '1' THEN
                rec.nbt_zone_grp := 'A';
            ELSIF i.zone_grp = '2' THEN
                rec.nbt_zone_grp := 'B';
            END IF;
            
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_com_accum_master;
    
    
    FUNCTION populate_fire_com_accum_detail(
        p_zone          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_zone_grp      giis_eqzone.ZONE_GRP%type,
        p_nbt_zone_grp  VARCHAR2,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%type,
        p_share_cd      gipi_firestat_extract_dtl.SHARE_CD%type,
        p_user_id       gipi_firestat_extract_dtl.USER_ID%type
    ) RETURN fire_com_accum_detail_tab PIPELINED
    AS
        rec      fire_com_accum_detail_type;
    BEGIN/*modified query for no zone_no in gipi_firestat_extract_dtl table : edgar 03/20/2015*/
        FOR i IN  ( SELECT DISTINCT c.zone_grp, b.as_of_sw,b.zone_no, b.share_cd, /*b.policy_id,*/ b.zone_type, 
                           a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, 
                           a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'|| LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))
                                ||'-'|| LTRIM(TO_CHAR(a.renew_no, '09')) policy_no 
                      FROM (SELECT DISTINCT NVL(zone_grp,'2') zone_grp, NVL(a.flood_zone,0) zone_no --edgar 03/20/2015
                              FROM giis_flood_zone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,1,1,NULL) = 1 
                               AND b.zone_no = a.flood_zone(+)--edgar 03/20/2015
                             UNION 
                            SELECT DISTINCT NVL(zone_grp,'2') zone_grp, NVL(a.typhoon_zone,0) zone_no --edgar 03/20/2015
                              FROM giis_typhoon_zone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,2,2,NULL) = 2 
                               AND b.zone_no = a.typhoon_zone(+) --edgar 03/20/2015
                             UNION 
                            SELECT DISTINCT NVL(zone_grp,'2') zone_grp, NVL(a.eq_zone,0) zone_no --edgar 03/20/2015
                              FROM giis_eqzone a, gipi_firestat_extract_dtl b 
                             WHERE DECODE(b.zone_type,3,3,NULL) = 3 
                               AND b.zone_no = a.eq_zone(+)) c, --edgar 03/20/2015
                           gipi_polbasic a, 
                           gipi_firestat_extract_dtl b 
                     WHERE a.policy_id = b.policy_id 
                       AND NVL(b.zone_no,0) = c.zone_no --edgar 03/20/2015
                       AND b.user_id = P_USER_ID
                       AND as_of_sw = p_as_of_sw
                       AND zone_type = p_zone_type
                       AND share_cd = p_share_cd
                       AND zone_grp = p_zone_grp)
        LOOP
            rec.zone_group      := i.zone_grp;
            rec.zone_type       := i.zone_type;
            rec.zone_no         := i.zone_no;
            rec.share_cd        := i.share_cd;
            rec.as_of_sw        := i.as_of_sw;
            rec.policy_no       := i.policy_no;
            rec.line_cd         := i.line_cd;
            rec.subline_cd      := i.subline_cd;
            rec.iss_cd          := i.iss_cd;
            rec.issue_yy        := i.issue_yy;
            rec.pol_seq_no      := i.pol_seq_no;
            rec.renew_no        := i.renew_no;
            
            fire_com_accum_dtl_post_query(p_zone, p_as_of_sw, p_nbt_zone_grp, i.zone_no, i.share_cd, i.line_cd, 
                                          i.subline_cd, i.iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no, p_user_id,
                                          rec.tsi_amt_b, rec.prem_amt_b, rec.tsi_amt_c, rec.prem_amt_c,
                                          rec.tsi_amt_l, rec.prem_amt_l);
            
            PIPE ROW(rec);
        END LOOP;
    END populate_fire_com_accum_detail;
    
    
    PROCEDURE fire_com_accum_dtl_post_query(
        p_zone              IN  VARCHAR2,
        p_as_of_sw          IN  VARCHAR2,
        p_nbt_zone_grp      IN  VARCHAR2,
        p_zone_no           IN  gipi_firestat_extract_dtl.ZONE_NO%type,
        p_share_cd          IN  gipi_firestat_extract_dtl.SHARE_CD%type,
        p_line_cd           IN  gipi_polbasic.LINE_CD%type,
        p_subline_cd        IN  gipi_polbasic.SUBLINE_CD%type,
        p_iss_cd            IN  gipi_polbasic.ISS_CD%type,
        p_issue_yy          IN  gipi_polbasic.ISSUE_YY%type,
        p_pol_seq_no        IN  gipi_polbasic.POL_SEQ_NO%type,
        p_renew_no          IN  gipi_polbasic.RENEW_NO%type,  
        p_user_id           IN  VARCHAR2, 
        p_sum_tsi_amt_b     OUT NUMBER,  
        p_sum_prem_amt_b    OUT NUMBER,  
        p_sum_tsi_amt_c     OUT NUMBER,  
        p_sum_prem_amt_c    OUT NUMBER,  
        p_sum_tsi_amt_l     OUT NUMBER,  
        p_sum_prem_amt_l    OUT NUMBER
    )
    AS
    BEGIN
        p_sum_tsi_amt_b     := NULL;
        p_sum_prem_amt_b    := NULL;
        p_sum_tsi_amt_c     := NULL;
        p_sum_prem_amt_c    := NULL;
        p_sum_tsi_amt_l     := NULL;
        p_sum_prem_amt_l    := NULL;
        
        IF UPPER(p_zone) = 'FLOOD' THEN
            FOR A IN (SELECT SUM(share_tsi_amt) share_tsi_amt, 
                             SUM(share_prem_amt) share_prem_amt, 
                             c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no/*policy_id*/, share_cd, fi_item_grp
                        FROM gipi_polbasic c, gipi_firestat_extract_dtl a--, giis_flood_zone b  -- aaron
                        --FROM gipi_firestat_extract_dtl a, giis_flood_zone b
                       WHERE 1=1--b.flood_zone = a.zone_no
                         AND exists (select 1
                                       from giis_flood_zone
                                      where flood_zone = a.zone_no
                                        and decode(zone_grp,'1','A','B')=NVL(p_nbt_zone_grp,'B') )
                         --a.zone_no  = b.flood_zone
                         --A.R.C. 04.17.2007
                         --add zone_no and as_of_sw filter for same policy with different zone_no and as_of_sw
                         AND c.policy_id = a.policy_id --aaron
                         AND a.zone_no = p_zone_no  
                         AND a.as_of_sw = p_as_of_sw
                         AND c.line_cd = p_line_cd
                         AND c.subline_cd = p_subline_cd
                         AND c.iss_cd = p_iss_cd
                         AND c.issue_yy = p_issue_yy
                         AND c.pol_seq_no = p_pol_seq_no
                         AND c.renew_no = p_renew_no
                         --AND a.policy_id  = :commit_accum_dtl_a.policy_id
                         AND share_cd   = p_share_cd 
                         --A.R.C. 04.16.2007
                         --add nvl for zone_grp
                         --AND decode(b.zone_grp,'1','A','B') = :commit_accum_mstr_b.nbt_zone_grp
                         --AND decode(b.zone_grp,'1','A','B') = NVL(:commit_accum_mstr_b.nbt_zone_grp,'B')  
                         AND a.user_id = p_user_id 
                      GROUP BY c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no, share_cd, fi_item_grp)
            LOOP    
                IF a.fi_item_grp = 'B' THEN
                    p_sum_tsi_amt_b := a.share_tsi_amt;
                    p_sum_prem_amt_b := a.share_prem_amt;           
                ELSIF a.fi_item_grp = 'C' THEN
                    p_sum_tsi_amt_c := a.share_tsi_amt;
                    p_sum_prem_amt_c := a.share_prem_amt;              
                ELSIF a.fi_item_grp = 'L' THEN
                    p_sum_tsi_amt_l := a.share_tsi_amt;
                    p_sum_prem_amt_l := a.share_prem_amt;              
                END IF;
            END LOOP;
            
        ELSIF UPPER(p_zone) = 'TYPHOON' THEN
            FOR A IN (SELECT SUM(share_tsi_amt) share_tsi_amt, 
                             SUM(share_prem_amt) share_prem_amt, 
                             c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no,/*policy_id,*/ share_cd, fi_item_grp
                        FROM gipi_polbasic c, gipi_firestat_extract_dtl a--, giis_typhoon_zone b
                        --FROM gipi_firestat_extract_dtl a, giis_typhoon_zone b
                       WHERE 1=1--b.typhoon_zone = a.zone_no 
                         AND exists (select 1
                                       from giis_typhoon_zone
                                      where typhoon_zone = a.zone_no
                                        and decode(zone_grp,'1','A','B')=NVL(p_nbt_zone_grp,'B') )
                         --a.zone_no  = b.typhoon_zone
                         --A.R.C. 04.17.2007
                         --add zone_no and as_of_sw filter for same policy with different zone_no and as_of_sw
                         AND c.policy_id = a.policy_id -- aaron
                         AND a.zone_no = p_zone_no  
                         AND a.as_of_sw = p_as_of_sw
                         AND c.line_cd = p_line_cd
                         AND c.subline_cd = p_subline_cd
                         AND c.iss_cd = p_iss_cd
                         AND c.issue_yy = p_issue_yy
                         AND c.pol_seq_no = p_pol_seq_no
                         AND c.renew_no = p_renew_no
                         --AND policy_id  = :commit_accum_dtl_a.policy_id  --aaron
                         AND share_cd   = p_share_cd 
                         --A.R.C. 04.16.2007
                         --add nvl for zone_grp
                         --AND decode(b.zone_grp,'1','A','B') = :commit_accum_mstr_b.nbt_zone_grp
                         --AND decode(b.zone_grp,'1','A','B') = NVL(:commit_accum_mstr_b.nbt_zone_grp,'B')  
                         AND a.user_id = p_user_id
                       GROUP BY c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no, /*policy_id,*/ share_cd, fi_item_grp  )
            LOOP    
                IF a.fi_item_grp = 'B' THEN
                    p_sum_tsi_amt_b := a.share_tsi_amt;
                    p_sum_prem_amt_b := a.share_prem_amt;           
                ELSIF a.fi_item_grp = 'C' THEN
                    p_sum_tsi_amt_c := a.share_tsi_amt;
                    p_sum_prem_amt_c := a.share_prem_amt;              
                ELSIF a.fi_item_grp = 'L' THEN
                    p_sum_tsi_amt_l := a.share_tsi_amt;
                    p_sum_prem_amt_l := a.share_prem_amt;              
                END IF;
            END LOOP;
        ELSIF UPPER(p_zone) = 'EARTHQUAKE' THEN
    	   
           /*message('d2:');	message('d2');*/	   
          /* message('.'||:commit_accum_mstr_b.nbt_zone_grp||'.'||:commit_accum_dtl_a.share_cd); 
           message('.'||:commit_accum_mstr_b.nbt_zone_grp||'.'||:commit_accum_dtl_a.share_cd);	   */
            FOR A IN (SELECT SUM(share_tsi_amt) share_tsi_amt, 
                             SUM(share_prem_amt) share_prem_amt, 
                             c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no, /*policy_id,*/ share_cd, fi_item_grp
                        FROM gipi_polbasic c, gipi_firestat_extract_dtl a--, giis_eqzone b
                       WHERE 1=1--b.eq_zone = a.zone_no 
                          AND exists (select 1
                                       from giis_eqzone
                                      where eq_zone = a.zone_no
                                        and decode(zone_grp,'1','A','B')=NVL(p_nbt_zone_grp,'B') )
                        --a.zone_no  = b.eq_zone
                         --A.R.C. 04.17.2007
                         --add zone_no and as_of_sw filter for same policy with different zone_no and as_of_sw
                         AND a.policy_id = c.policy_id
                         AND a.zone_no = p_zone_no  
                         AND a.as_of_sw = p_as_of_sw
                         AND c.line_cd = p_line_cd
                         AND c.subline_cd = p_subline_cd
                         AND c.iss_cd = p_iss_cd
                         AND c.issue_yy = p_issue_yy
                         AND c.pol_seq_no = p_pol_seq_no
                         AND c.renew_no = p_renew_no
                         --AND policy_id  = :commit_accum_dtl_a.policy_id --aaron
                         AND share_cd   = p_share_cd 
                         --AND decode(b.zone_grp,'1','A','B') = :commit_accum_mstr_b.nbt_zone_grp
                         --A.R.C. 04.16.2007
                         --add nvl for zone_grp
                        --  AND decode(b.zone_grp,'1','A','B') = NVL(:commit_accum_mstr_b.nbt_zone_grp,'B')  
                         AND a.user_id = p_user_id
                       GROUP BY c.line_cd, c.subline_cd, c.iss_cd,c.issue_yy,c.pol_seq_no, c.renew_no/*policy_id*/, share_cd, fi_item_grp  )
            LOOP    
                IF a.fi_item_grp = 'B' THEN	     		
                    p_sum_tsi_amt_b := a.share_tsi_amt;
                    p_sum_prem_amt_b := a.share_prem_amt;           
                ELSIF a.fi_item_grp = 'C' THEN
                    p_sum_tsi_amt_c := a.share_tsi_amt;
                    p_sum_prem_amt_c := a.share_prem_amt;              
                ELSIF a.fi_item_grp = 'L' THEN
                    p_sum_tsi_amt_l := a.share_tsi_amt;
                    p_sum_prem_amt_l := a.share_prem_amt;              
                END IF;
            END LOOP;
        END IF;  
    END fire_com_accum_dtl_post_query;
    
    
    FUNCTION get_risk_line_lov(
        p_cred_branch       giis_issource.ISS_CD%type,
        p_user_id           giis_line.USER_ID%type
    ) RETURN risk_line_lov_tab PIPELINED
    AS
        lov     risk_line_lov_type;
    BEGIN
        FOR i IN (select line_name, line_cd, nvl(menu_line_cd,line_cd) menu_line --Gzelle 07292015 SR4136,4196,4285,4271
                    from giis_line 
                   where line_cd = DECODE(check_user_per_line2(line_cd, p_cred_branch, 'GIPIS901', p_user_id),1,line_cd,NULL)
                     and pack_pol_flag <> 'Y' --Gzelle 04132015
                   order by line_cd,line_name)
        LOOP
            lov.line_cd     := i.line_cd;
            lov.line_name   := i.line_name;
            lov.menu_line_cd := i.menu_line;     --Gzelle 07292015 SR4136,4196,4285,4271
            PIPE ROW(lov);
        END LOOP;
    END get_risk_line_lov;
    
    
    FUNCTION get_risk_iss_lov(
        p_line_cd       giis_line.LINE_CD%type,
        p_user_id       giis_line.USER_ID%type
    ) RETURN risk_iss_lov_tab PIPELINED
    AS
        lov     risk_iss_lov_type;
    BEGIN
        FOR i IN (SELECT iss_name, iss_cd
                    FROM giis_issource
                   WHERE user_id = DECODE(check_user_per_iss_cd2(p_line_cd,iss_cd, 'GIPIS901', p_user_id),1,user_id,NULL)
                   order by iss_cd,iss_name)
        LOOP
            lov.iss_cd     := i.iss_cd;
            lov.iss_name   := i.iss_name;
            
            PIPE ROW(lov);
        END LOOP;    
    END get_risk_iss_lov;
    
    
    FUNCTION populate_risk_profile_master(
        p_ctrl_line_cd  gipi_risk_profile.LINE_CD%type,
        p_iss_cd        giis_issource.ISS_CD%type,
        p_user_id       gipi_risk_profile.USER_ID%type
    ) RETURN risk_profile_master_tab PIPELINED
    AS
        rec     risk_profile_master_type;
    BEGIN
        FOR i IN  ( SELECT DISTINCT line_cd, subline_cd, date_from, date_to, user_id, all_line_tag,
                           param_date, NVL(inc_endt,'N') inc_endt, NVL(inc_expired,'N') inc_expired, cred_branch_param --Gzelle 07292015 SR4136,4196,4285,4271
                      FROM gipi_risk_profile
                     WHERE user_id = p_user_id
                       AND tarf_cd IS NULL      --Gzelle 07292015 SR4136,4196,4285,4271
                       AND peril_cd IS NULL     --Gzelle 07292015 SR4136,4196,4285,4271
                     ORDER BY line_cd)
        LOOP
            rec.line_cd         := i.line_cd;
            rec.subline_cd      := i.subline_cd;
            rec.date_from       := i.date_from;
            rec.date_to         := i.date_to;
            rec.all_line_tag    := i.all_line_tag;
            rec.user_id         := i.user_id;
            rec.param_date      := i.param_date;    --start - Gzelle 03252015
            rec.inc_endt        := i.inc_endt;
            rec.inc_expired     := i.inc_expired;
            rec.cred_branch_param := i.cred_branch_param;   
            rec.iss_cd          := i.cred_branch_param;--end - Gzelle 03252015
            
            BEGIN 
                SELECT line_name, nvl(menu_line_cd,line_cd) --Gzelle 07292015 SR4136,4196,4285,4271
                  INTO rec.line_name, rec.menu_line_cd      --Gzelle 07292015 SR4136,4196,4285,4271
                  FROM giis_line
                 WHERE line_cd = i.line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  rec.line_name := ' ';
            END;
            
            IF rec.line_name IS NOT NULL THEN
               BEGIN
                    SELECT subline_name
                      INTO rec.subline_name
                      FROM giis_subline
                     WHERE subline_cd = i.subline_cd
                       AND line_cd = i.line_cd;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        rec.subline_name := ' ';
               END; 
               
                BEGIN
                    SELECT iss_name
  		              INTO rec.iss_name
			          FROM giis_issource
			         WHERE user_id = DECODE(check_user_per_iss_cd2(p_ctrl_line_cd,null,'GIPIS901', p_user_id),1,user_id,NULL)
					   AND iss_cd = i.cred_branch_param;--p_iss_cd; Gzelle 03252015
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        rec.iss_name := null;
                END;
            END IF;
            
            PIPE ROW(rec);
        END LOOP;
    END populate_risk_profile_master;
    
    
    FUNCTION populate_risk_profile_detail(
        p_line_cd         gipi_risk_profile.LINE_CD%type,
        p_subline_cd      gipi_risk_profile.SUBLINE_CD%type,
        p_date_from       VARCHAR2,
        p_date_to         VARCHAR2,
        p_all_line_tag    gipi_risk_profile.ALL_LINE_TAG%type,
        p_user_id         gipi_risk_profile.USER_ID%type
    ) RETURN risk_profile_detail_tab PIPELINED
    AS
        rec     risk_profile_detail_type;
    BEGIN
        FOR i IN  (   SELECT *                      --start Gzelle 07292015 SR4136,4196,4285,4271
                        FROM gipi_risk_profile
                       WHERE user_id = p_user_id
                         AND (   (    line_cd NOT IN (
                                         SELECT line_cd
                                           FROM giis_line
                                          WHERE pack_pol_flag <> 'Y'
                                            AND (   (    menu_line_cd IS NULL
                                                     AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                          OR line_cd = giisp.v ('LINE_CODE_MC')
                                                         )
                                                    )
                                                 OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                ))
                                  AND peril_cd IS NULL
                                 )
                              OR (    line_cd IN (
                                         SELECT line_cd
                                           FROM giis_line
                                          WHERE pack_pol_flag <> 'Y'
                                            AND (   (    menu_line_cd IS NULL
                                                     AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                          OR line_cd = giisp.v ('LINE_CODE_MC')
                                                         )
                                                    )
                                                 OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                ))
                                  AND tarf_cd IS NULL
                                  AND peril_cd IS NULL
                                 )
                             )
                         AND line_cd = p_line_cd
                         AND (subline_cd = NVL (p_subline_cd, subline_cd) OR subline_cd IS NULL)
                         --AND TRUNC(date_from) = TRUNC(TO_DATE(p_date_from, 'MM-DD-RRRR'))   Gzelle 03302015
                         --AND TRUNC(date_to) = TRUNC(TO_DATE(p_date_to, 'MM-DD-RRRR'))   Gzelle 03302015
                         AND all_line_tag = p_all_line_tag
                         ----
                         AND range_from IS NOT NULL
                         AND range_to IS NOT NULL
                    ORDER BY line_cd, range_from)
        LOOP
        
            IF p_subline_cd = NVL(i.subline_cd,'null') THEN
                rec.line_cd         := i.line_cd;
                rec.subline_cd      := i.subline_cd;
                rec.date_from       := i.date_from;
                rec.date_to         := i.date_to;
                rec.range_from      := i.range_from;
                rec.range_to        := i.range_to;
                rec.policy_cnt      := i.policy_count;
                rec.net_retention   := i.net_retention;
                rec.quota_share     := i.quota_share;
                rec.treaty          := i.treaty;
                rec.facultative     := i.facultative;  
                rec.all_line_tag    := i.all_line_tag;
                rec.user_id         := i.user_id;
            	
                --Gzelle 03302015
                BEGIN
                    SELECT COUNT (line_cd) rec_count, MIN (range_from), MAX (range_to)
                      INTO rec.rec_count, rec.min_range_from, rec.max_range_to
                      FROM gipi_risk_profile                         
                     WHERE line_cd = p_line_cd
                       AND (subline_cd = NVL(p_subline_cd, subline_cd)
                             OR subline_cd IS NULL)
                       AND all_line_tag = p_all_line_tag
                       AND user_id = p_user_id;
                END;
            	
                PIPE ROW(rec);
            END IF;     --Gzelle 07292015 SR4136,4196,4285,4271
        END LOOP;
    END populate_risk_profile_detail;
    
    
    FUNCTION GET_TREATY_COUNT(
        P_LINE           gipi_risk_profile.line_cd%TYPE,
        P_STARTING_DATE  gipi_risk_profile.date_from%TYPE,
        P_ENDING_DATE    gipi_risk_profile.date_to%TYPE, 
        P_BY_TARF        gipi_risk_profile.tarf_cd%TYPE,
        P_USER           gipi_risk_profile.user_id%TYPE
    ) RETURN NUMBER
    AS
        v_cnt       NUMBER := 0;
    BEGIN
        SELECT count(treaty_name)
          INTO v_cnt
          FROM (SELECT DISTINCT TREATY_NAME, treaty_num
                  FROM (SELECT TRTY_NAME TREATY_NAME, RANGE_FROM, RANGE_TO, 1 TREATY_NUM  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                     UNION ALL
                        SELECT TRTY2_NAME, RANGE_FROM, RANGE_TO, 2  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                     UNION ALL			 
						SELECT TRTY3_NAME, RANGE_FROM, RANGE_TO, 3
					  	  FROM  GIPI_RISK_PROFILE  
						 WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
					 UNION ALL			 
						SELECT TRTY4_NAME, RANGE_FROM, RANGE_TO, 4  
					  	  FROM  GIPI_RISK_PROFILE  
						 WHERE LINE_CD = NVL(P_LINE,LINE_CD)
						   AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
						   AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
						   AND USER_ID = P_USER
						   AND SUBLINE_CD IS NULL
						   AND ALL_LINE_TAG = 'Y'
						   AND (NVL(P_BY_TARF,'N') <> 'Y'
						    OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
					 UNION ALL
                        SELECT TRTY5_NAME, RANGE_FROM, RANGE_TO, 5  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                     UNION ALL
                        SELECT TRTY6_NAME, RANGE_FROM, RANGE_TO, 6  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                     UNION ALL
                        SELECT TRTY7_NAME, RANGE_FROM, RANGE_TO, 7  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                     UNION ALL
                        SELECT TRTY8_NAME, RANGE_FROM, RANGE_TO, 8  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
					 UNION ALL
                        SELECT TRTY9_NAME, RANGE_FROM, RANGE_TO, 9  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
					 UNION ALL
                        SELECT TRTY10_NAME, RANGE_FROM, RANGE_TO, 10  
                          FROM  GIPI_RISK_PROFILE  
                         WHERE LINE_CD = NVL(P_LINE,LINE_CD)
                           AND TRUNC(DATE_FROM) = TRUNC(TO_DATE(P_STARTING_DATE))
                           AND TRUNC(DATE_TO) = TRUNC(TO_DATE(P_ENDING_DATE))
                           AND USER_ID = P_USER
                           AND SUBLINE_CD IS NULL
                           AND ALL_LINE_TAG = 'Y'
                           AND (NVL(P_BY_TARF,'N') <> 'Y'
                            OR (NVL(P_BY_TARF,'N') = 'Y' AND TARF_CD IS NOT NULL))
                             )
                 WHERE treaty_name IS NOT NULL);
        
        RETURN (v_cnt);
    END GET_TREATY_COUNT;
    
    
    PROCEDURE extract_risk_profile(
        p_line_cd         IN    gipi_risk_profile.LINE_CD%type,
        p_subline_cd      IN    gipi_risk_profile.SUBLINE_CD%type,
        p_date_from       IN    gipi_risk_profile.DATE_FROM%type,
        p_date_to         IN    gipi_risk_profile.DATE_TO%type,
        p_all_line_tag    IN    gipi_risk_profile.ALL_LINE_TAG%type,
        p_paramdate       IN    VARCHAR2,
        p_by_tarf         IN    VARCHAR2,
        p_cred_branch     IN    VARCHAR2,
        p_incl_endt       IN    VARCHAR2,
        p_incl_exp        IN    VARCHAR2,
        p_user_id         IN    gipi_risk_profile.USER_ID%type
    )
    AS
	    v_exist     boolean;
    BEGIN
        IF p_all_line_tag <> 'R' THEN
            p_risk_profile.extract_risk_profile (p_user_id, p_line_cd, p_subline_cd, p_date_from, 
                                                 p_date_to, p_paramdate, p_all_line_tag,
                                                 NVL(p_by_tarf,'N'), p_cred_branch/*:risk_profile1.cred_branch*/,  -- aaron 031809
                                                 p_incl_exp, p_incl_endt,
                                                 v_exist );
        ELSE
            p_risk_profile_item.extract_risk_profile_item (p_user_id, p_line_cd, p_subline_cd, p_date_from, 
                                                           p_date_to, p_paramdate, p_all_line_tag,
                                                           NVL(p_by_tarf,'N'), p_cred_branch/*:risk_profile1.cred_branch*/,  -- aaron 031809
                                                           p_incl_exp, p_incl_endt,
                                                           v_exist ); 
        END IF;
    END extract_risk_profile;
--start Gzelle 07292015 SR4136,4196,4285,4271
    PROCEDURE del_extracted_records(
        p_line_cd           IN  gipi_risk_profile.line_cd%TYPE,
        p_subline_cd        IN  gipi_risk_profile.subline_cd%TYPE,
        p_all_line_tag      IN  gipi_risk_profile.all_line_tag%TYPE,
        p_user_id           IN  gipi_risk_profile.user_id%TYPE
    )    
    AS  
        v_tarf   VARCHAR2(1) := 'O';
        v_peril  VARCHAR2(1) := 'O';
    BEGIN
        IF p_subline_cd IS NULL
        THEN
            BEGIN
            SELECT 'X'
              INTO v_tarf
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd IS NULL
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND tarf_cd IS NOT NULL
               AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tarf := 'O';
            END;

            BEGIN
            SELECT 'X'
              INTO v_peril
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd IS NULL
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND peril_cd IS NOT NULL
               AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_peril := 'O';
            END;              
            
            IF v_tarf = 'X' THEN
                DELETE gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd IS NULL
                   AND user_id = p_user_id
                   AND all_line_tag = p_all_line_tag
                   AND tarf_cd IS NOT NULL;            
            END IF;

            IF v_peril = 'X' THEN
                DELETE gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd IS NULL
                   AND user_id = p_user_id
                   AND all_line_tag = p_all_line_tag
                   AND peril_cd IS NOT NULL;            
            END IF;            
            
        ELSE
            BEGIN
            SELECT 'X'
              INTO v_tarf
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND tarf_cd IS NOT NULL
               AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tarf := 'O';
            END;

            BEGIN
            SELECT 'X'
              INTO v_peril
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND peril_cd IS NOT NULL
               AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_peril := 'O';
            END;                       
            
            IF v_tarf = 'X' THEN
                DELETE gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND user_id = p_user_id
                   AND all_line_tag = p_all_line_tag
                   AND tarf_cd IS NOT NULL;            
            END IF;   
            
            IF v_peril = 'X' THEN
                DELETE gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND user_id = p_user_id
                   AND all_line_tag = p_all_line_tag
                   AND peril_cd IS NOT NULL;            
            END IF;                       
        END IF;
    END;      
    
    PROCEDURE risk_update_add(
        p_line_cd           IN  gipi_risk_profile.LINE_CD%type,
        p_subline_cd        IN  gipi_risk_profile.SUBLINE_CD%type,
        p_date_from         IN  gipi_risk_profile.DATE_FROM%type,
        p_date_to           IN  gipi_risk_profile.DATE_TO%type,
        p_all_line_tag      IN  gipi_risk_profile.ALL_LINE_TAG%type,
        p_user_id           IN  gipi_risk_profile.USER_ID%type,
        p_prev_line_cd      IN  gipi_risk_profile.LINE_CD%type,
        p_prev_subline_cd   IN  gipi_risk_profile.SUBLINE_CD%type,
        p_param_date        IN  gipi_risk_profile.PARAM_DATE%type,
        p_inc_endt          IN  gipi_risk_profile.INC_ENDT%type,
        p_inc_expired       IN  gipi_risk_profile.INC_EXPIRED%type,
        p_cred_branch_param IN  gipi_risk_profile.CRED_BRANCH_PARAM%type,
        p_prev_all_line_tag IN  VARCHAR2,
        p_user_response   IN  VARCHAR2   
    )
    AS
        TYPE v_prev_tab IS TABLE OF gipi_risk_profile%ROWTYPE;
        TYPE v_item_prev_tab IS TABLE OF gipi_risk_profile_item%ROWTYPE;
       
        v_temp_list_prev           v_prev_tab;
        v_temp_list_item_prev      v_item_prev_tab;
        v_retain                   VARCHAR2(1) := 'N';
    BEGIN
        IF p_prev_line_cd IS NOT NULL THEN
            IF p_prev_subline_cd IS NOT NULL THEN

                SELECT *
                BULK COLLECT INTO v_temp_list_prev
                  FROM gipi_risk_profile                         
                     WHERE line_cd = p_prev_line_cd
                       AND subline_cd = p_prev_subline_cd
                       AND all_line_tag = p_prev_all_line_tag
                       AND user_id = p_user_id;         
                 
                 IF p_subline_cd IS NOT NULL
                 THEN       
                     IF v_temp_list_prev IS NOT NULL THEN
                        FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                        LOOP
                            INSERT INTO gipi_risk_profile
                                        (line_cd        , subline_Cd    , user_id       , 
                                         range_from     , range_to      , policy_count  , 
                                         net_retention  , quota_share   , treaty        , 
                                         facultative    , date_from     , date_to       , 
                                         all_line_tag   , param_date    , inc_endt      ,
                                         inc_expired    , cred_branch_param, 
                                         tarf_cd        , peril_cd)
                                 VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                         v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                         v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                         v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                         p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                         p_inc_expired                        , p_cred_branch_param,
                                         v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                        END LOOP;
                     END IF; 
                 ELSIF p_subline_cd IS NULL
                 THEN
                    IF p_all_line_tag IN ('Y','R','P') THEN
                        IF p_all_line_tag = 'R' THEN
                            SELECT *
                            BULK COLLECT INTO v_temp_list_item_prev
                              FROM gipi_risk_profile_item                     
                                 WHERE line_cd = p_prev_line_cd
                                   AND subline_cd = p_prev_subline_cd
                                   AND all_line_tag = p_prev_all_line_tag
                                   AND user_id = p_user_id;
                        END IF;
                        
                        IF p_line_cd IS NOT NULL THEN
                            IF v_temp_list_prev IS NOT NULL THEN
                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , policy_count  , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param,
                                                 tarf_cd        , peril_cd)
                                         VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                 p_inc_expired                        , p_cred_branch_param,
                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                END LOOP;
                            END IF; 
                                                                 
                            IF p_all_line_tag = 'R' THEN
                                IF v_temp_list_prev IS NOT NULL THEN
                                    FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                    LOOP
                                        INSERT INTO gipi_risk_profile_item
                                                    (line_cd        , subline_Cd    , user_id       , 
                                                     range_from     , range_to      , risk_count    , 
                                                     net_retention  , quota_share   , treaty        , 
                                                     facultative    , date_from     , date_to       , 
                                                     all_line_tag   , param_date    , inc_endt      ,
                                                     inc_expired    , cred_branch_param)
                                             VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                                     v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                     v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                     v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                     p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                     p_inc_expired                        , p_cred_branch_param);
                                    END LOOP;                                                                                                                                     
                                END IF;                             
                            END IF;                         
                        ELSE
                            IF NVL(p_user_response,'Update') = 'Update' THEN   
                                IF p_user_response = 'Update' THEN
                                 DELETE FROM gipi_risk_profile
                                       WHERE subline_cd = p_prev_subline_cd
                                         AND line_cd = p_prev_line_cd                 
                                         AND all_line_tag = p_prev_all_line_tag
                                         AND user_id = p_user_id;
                                END IF;                             
                               
                                IF p_all_line_tag = 'R' THEN
                                
                                    IF p_user_response = 'Update' THEN
                                     DELETE FROM gipi_risk_profile_item
                                           WHERE subline_cd IS NULL                  
                                             AND all_line_tag = p_all_line_tag
                                             AND user_id = p_user_id;
                                    END IF;                                 
                                
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y'
                                                   AND (   (    menu_line_cd IS NULL
                                                            AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                                 OR line_cd = giisp.v ('LINE_CODE_MC')
                                                                )
                                                           )
                                                        OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                       ))
                                    LOOP 
                                        IF v_temp_list_prev IS NOT NULL THEN
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param,
                                                             tarf_cd        , peril_cd)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param,
                                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                            END LOOP;
                                            
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile_item
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , risk_count    , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param);
                                            END LOOP;                                 
                                        END IF;
                                        
                                        del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);  
                                    END LOOP;                             
                                ELSIF p_all_line_tag = 'Y' THEN
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y' )
                                    LOOP 
                                        IF v_temp_list_prev IS NOT NULL THEN
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param,
                                                             tarf_cd        , peril_cd)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param,
                                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                            END LOOP;
                                        END IF; 
                                        
                                        del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                      
                                    END LOOP;
                                ELSE
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y' )
                                    LOOP 
                                        FOR b IN (SELECT subline_cd
                                                     FROM giis_subline
                                                    WHERE line_cd = glp.line_cd) 
                                        LOOP
                                            IF v_temp_list_prev IS NOT NULL THEN
                                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                LOOP
                                                    INSERT INTO gipi_risk_profile
                                                                (line_cd        , subline_Cd    , user_id       , 
                                                                 range_from     , range_to      , policy_count  , 
                                                                 net_retention  , quota_share   , treaty        , 
                                                                 facultative    , date_from     , date_to       , 
                                                                 all_line_tag   , param_date    , inc_endt      ,
                                                                 inc_expired    , cred_branch_param,
                                                                 tarf_cd        , peril_cd)
                                                         VALUES (glp.line_cd                          , b.subline_cd                      , p_user_id                        , 
                                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                 p_inc_expired                        , p_cred_branch_param,
                                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                                END LOOP;
                                            END IF;
                                            del_extracted_records(glp.line_cd, b.subline_cd, p_all_line_tag, p_user_id);    
                                        END LOOP;
                                    END LOOP;                                                            
                                END IF;
                            ELSIF NVL(p_user_response,'Update') = 'Retain' THEN
                                IF p_all_line_tag = 'R' THEN
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y'
                                                   AND (   (    menu_line_cd IS NULL
                                                            AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                                 OR line_cd = giisp.v ('LINE_CODE_MC')
                                                                )
                                                           )
                                                        OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                       ))
                                    LOOP 
                                        FOR x IN (SELECT 'Y' retain_rec
                                                    FROM gipi_risk_profile
                                                   WHERE line_cd = glp.line_cd
                                                     AND subline_cd IS NULL
                                                     AND all_line_tag = p_all_line_tag
                                                     AND user_id = p_user_id)
                                        LOOP
                                            v_retain := x.retain_rec;
                                            
                                        END LOOP;
                                        
                                        IF v_retain = 'Y'
                                        THEN 
                                            v_retain := 'N';
                                        ELSE 
                                            IF v_temp_list_prev IS NOT NULL THEN
                                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                LOOP
                                                    INSERT INTO gipi_risk_profile
                                                                (line_cd        , subline_Cd    , user_id       , 
                                                                 range_from     , range_to      , policy_count  , 
                                                                 net_retention  , quota_share   , treaty        , 
                                                                 facultative    , date_from     , date_to       , 
                                                                 all_line_tag   , param_date    , inc_endt      ,
                                                                 inc_expired    , cred_branch_param,
                                                                 tarf_cd        , peril_cd)
                                                         VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                 p_inc_expired                        , p_cred_branch_param,
                                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                                END LOOP;
                                                
                                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                LOOP
                                                    INSERT INTO gipi_risk_profile_item
                                                                (line_cd        , subline_Cd    , user_id       , 
                                                                 range_from     , range_to      , risk_count    , 
                                                                 net_retention  , quota_share   , treaty        , 
                                                                 facultative    , date_from     , date_to       , 
                                                                 all_line_tag   , param_date    , inc_endt      ,
                                                                 inc_expired    , cred_branch_param)
                                                         VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                 p_inc_expired                        , p_cred_branch_param);
                                                END LOOP;                                 
                                            END IF;  
                                            del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                                 
                                        END IF;
                                    END LOOP;
                                ELSIF p_all_line_tag = 'Y' THEN
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y' )
                                    LOOP 
                                        FOR x IN (SELECT 'Y' retain_rec
                                                    FROM gipi_risk_profile
                                                   WHERE line_cd = glp.line_cd
                                                     AND subline_cd IS NULL
                                                     AND all_line_tag = p_all_line_tag
                                                     AND user_id = p_user_id)
                                        LOOP
                                            v_retain := x.retain_rec;
                                            
                                        END LOOP;
                                        
                                        IF v_retain = 'Y'
                                        THEN 
                                            v_retain := 'N';
                                        ELSE 
                                            IF v_temp_list_prev IS NOT NULL THEN
                                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                LOOP
                                                    INSERT INTO gipi_risk_profile
                                                                (line_cd        , subline_Cd    , user_id       , 
                                                                 range_from     , range_to      , policy_count  , 
                                                                 net_retention  , quota_share   , treaty        , 
                                                                 facultative    , date_from     , date_to       , 
                                                                 all_line_tag   , param_date    , inc_endt      ,
                                                                 inc_expired    , cred_branch_param,
                                                                 tarf_cd        , peril_cd)
                                                         VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                 p_inc_expired                        , p_cred_branch_param,
                                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                                END LOOP;
                                            END IF;
                                            del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                                    
                                        END IF;                            
                                    END LOOP;
                                ELSE
                                    FOR glp IN (SELECT line_cd
                                                  FROM giis_line
                                                 WHERE pack_pol_flag <> 'Y' )
                                    LOOP 
                                        FOR b IN (SELECT subline_cd
                                                     FROM giis_subline
                                                    WHERE line_cd = glp.line_cd) 
                                        LOOP
                                            FOR x IN (SELECT 'Y' retain_rec
                                                        FROM gipi_risk_profile
                                                       WHERE line_cd = glp.line_cd
                                                         AND subline_cd IS NULL
                                                         AND all_line_tag = p_all_line_tag
                                                         AND user_id = p_user_id)
                                            LOOP
                                                v_retain := x.retain_rec;
                                                
                                            END LOOP;
                                            
                                            IF v_retain = 'Y'
                                            THEN 
                                                v_retain := 'N';
                                            ELSE 
                                                IF v_temp_list_prev IS NOT NULL THEN
                                                    FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                    LOOP
                                                        INSERT INTO gipi_risk_profile
                                                                    (line_cd        , subline_Cd    , user_id       , 
                                                                     range_from     , range_to      , policy_count  , 
                                                                     net_retention  , quota_share   , treaty        , 
                                                                     facultative    , date_from     , date_to       , 
                                                                     all_line_tag   , param_date    , inc_endt      ,
                                                                     inc_expired    , cred_branch_param,
                                                                     tarf_cd        , peril_cd)
                                                             VALUES (glp.line_cd                          , b.subline_cd                      , p_user_id                        , 
                                                                     v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                     v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                     v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                     p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                     p_inc_expired                        , p_cred_branch_param,
                                                                     v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                                    END LOOP;
                                                END IF;
                                                del_extracted_records(glp.line_cd, b.subline_cd, p_all_line_tag, p_user_id);                                    
                                            END IF;                                  
                                        END LOOP;
                                    END LOOP;                                                               
                                END IF;                            
                            END IF;
                        END IF;                        
                     
                    ELSIF p_all_line_tag IN ('N') THEN
                        IF NVL(p_user_response,'Update') = 'Update'
                        THEN
                            DELETE FROM gipi_risk_profile                         
                                  WHERE line_cd = p_prev_line_cd
                                    AND subline_cd = p_prev_subline_cd
                                    AND all_line_tag = p_prev_all_line_tag
                                    AND user_id = p_user_id;  
                                                                           
                            FOR b IN(SELECT subline_cd
                                       FROM giis_subline
                                      WHERE line_cd = p_line_cd)
                            LOOP
                                IF v_temp_list_prev IS NOT NULL THEN
                                    FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                    LOOP
                                        INSERT INTO gipi_risk_profile
                                                    (line_cd        , subline_Cd    , user_id       , 
                                                     range_from     , range_to      , policy_count  , 
                                                     net_retention  , quota_share   , treaty        , 
                                                     facultative    , date_from     , date_to       , 
                                                     all_line_tag   , param_date    , inc_endt      ,
                                                     inc_expired    , cred_branch_param,
                                                     tarf_cd        , peril_cd)
                                             VALUES (p_line_cd                            , b.subline_cd                      , p_user_id                        , 
                                                     v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                     v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                     v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                     p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                     p_inc_expired                        , p_cred_branch_param,
                                                     v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                    END LOOP;
                                END IF; 
                                
                                del_extracted_records(p_line_cd, b.subline_cd, p_all_line_tag, p_user_id);  
                            END LOOP;
                        ELSIF NVL(p_user_response,'Update') = 'Retain'
                        THEN
                            FOR B IN(SELECT subline_cd
                                       FROM giis_subline
                                      WHERE line_cd = p_line_cd)
                            LOOP
                                FOR x IN (SELECT *
                                            FROM gipi_risk_profile
                                           WHERE line_cd = p_line_cd
                                             AND subline_cd = b.subline_cd
                                             AND all_line_tag = p_all_line_tag
                                             AND user_id = p_user_id)
                                LOOP
                                    v_retain := 'Y';
                                END LOOP;
                                
                                IF v_retain = 'Y'
                                THEN
                                    v_retain := 'N';
                                ELSE
                                    IF v_temp_list_prev IS NOT NULL THEN
                                        FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                        LOOP
                                            INSERT INTO gipi_risk_profile
                                                        (line_cd        , subline_Cd    , user_id       , 
                                                         range_from     , range_to      , policy_count  , 
                                                         net_retention  , quota_share   , treaty        , 
                                                         facultative    , date_from     , date_to       , 
                                                         all_line_tag   , param_date    , inc_endt      ,
                                                         inc_expired    , cred_branch_param,
                                                         tarf_cd        , peril_cd)
                                                 VALUES (p_line_cd                            , b.subline_cd                      , p_user_id                        , 
                                                         v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                         v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                         v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                         p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                         p_inc_expired                        , p_cred_branch_param,
                                                         v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                        END LOOP;
                                    END IF;  
                                    del_extracted_records(p_line_cd, b.subline_cd, p_all_line_tag, p_user_id);                               
                                END IF;                            
                            END LOOP;                            
                        END IF;
                    END IF;                                                         
                 END IF;

            ELSIF p_prev_subline_cd IS NULL THEN

                SELECT *    
                BULK COLLECT INTO v_temp_list_prev
                  FROM gipi_risk_profile                         
                     WHERE line_cd = p_prev_line_cd
                       AND subline_cd IS NULL
                       AND all_line_tag = p_prev_all_line_tag
                       AND user_id = p_user_id;
                           
                IF p_line_cd IS NOT NULL
                THEN
                    IF p_all_line_tag IN ('Y','R') THEN
                        IF p_prev_all_line_tag = 'R' THEN
                            SELECT *
                            BULK COLLECT INTO v_temp_list_item_prev
                              FROM gipi_risk_profile_item                     
                                 WHERE line_cd = p_prev_line_cd
                                   AND subline_cd IS NULL
                                   AND all_line_tag = p_prev_all_line_tag
                                   AND user_id = p_user_id;
                        END IF;
                        
                        IF v_temp_list_prev IS NOT NULL THEN
                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                            LOOP
                                INSERT INTO gipi_risk_profile
                                            (line_cd        , subline_Cd    , user_id       , 
                                             range_from     , range_to      , policy_count  , 
                                             net_retention  , quota_share   , treaty        , 
                                             facultative    , date_from     , date_to       , 
                                             all_line_tag   , param_date    , inc_endt      ,
                                             inc_expired    , cred_branch_param,
                                             tarf_cd        , peril_cd)
                                     VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                             p_inc_expired                        , p_cred_branch_param,
                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                            END LOOP;
                        END IF; 
                                                             
                        IF p_prev_all_line_tag = 'R' THEN
                            IF v_temp_list_prev IS NOT NULL THEN
                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile_item
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , risk_count    , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param)
                                         VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                 p_inc_expired                        , p_cred_branch_param);
                                END LOOP;
                            END IF;
                        ELSIF p_all_line_tag = 'R' THEN
                            IF v_temp_list_prev IS NOT NULL THEN
                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile_item
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , risk_count    , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param)
                                         VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                 p_inc_expired                        , p_cred_branch_param);
                                END LOOP;
                            END IF;                                                       
                        END IF;       
                     
                    ELSIF p_all_line_tag IN ('N','P') THEN
                        IF p_subline_cd IS NULL AND p_all_line_tag = 'N' THEN
                            FOR b IN(SELECT subline_cd
                                       FROM giis_subline
                                      WHERE line_cd = p_line_cd)
                            LOOP
                                IF v_temp_list_prev IS NOT NULL THEN
                                    FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                    LOOP
                                        INSERT INTO gipi_risk_profile
                                                    (line_cd        , subline_Cd    , user_id       , 
                                                     range_from     , range_to      , policy_count  , 
                                                     net_retention  , quota_share   , treaty        , 
                                                     facultative    , date_from     , date_to       , 
                                                     all_line_tag   , param_date    , inc_endt      ,
                                                     inc_expired    , cred_branch_param,
                                                     tarf_cd        , peril_cd)
                                             VALUES (p_line_cd                            , b.subline_cd                      , p_user_id                        , 
                                                     v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                     v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                     v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                     p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                     p_inc_expired                        , p_cred_branch_param,
                                                     v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                    END LOOP;
                                END IF; 
                                
                                del_extracted_records(p_line_cd, b.subline_cd, p_all_line_tag, p_user_id);  
                            END LOOP;
                        ELSE
                            IF v_temp_list_prev IS NOT NULL THEN
                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , policy_count  , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param,
                                                 tarf_cd        , peril_cd)
                                         VALUES (p_line_cd                            , p_subline_cd                      , p_user_id                        , 
                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                 p_inc_expired                        , p_cred_branch_param,
                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                END LOOP;
                            END IF;                         
                        END IF;
                    END IF;                
                ELSIF p_line_cd IS NULL
                THEN
                    SELECT *    
                    BULK COLLECT INTO v_temp_list_prev
                      FROM gipi_risk_profile                         
                         WHERE line_cd = p_prev_line_cd
                           AND subline_cd IS NULL
                           AND all_line_tag = p_prev_all_line_tag
                           AND user_id = p_user_id;         
                     
                    IF p_all_line_tag IN ('Y','R') THEN
                        IF NVL(p_user_response,'Update') = 'Update'              
                        THEN
                            IF p_user_response = 'Update' THEN
                             DELETE FROM gipi_risk_profile
                                   WHERE subline_cd IS NULL                  
                                     AND all_line_tag = p_all_line_tag
                                     AND user_id = p_user_id;
                            END IF;         
                            
                            IF p_all_line_tag = 'R' THEN
                            
                                IF p_user_response = 'Update' THEN
                                 DELETE FROM gipi_risk_profile_item
                                       WHERE subline_cd IS NULL
                                         AND all_line_tag = p_all_line_tag
                                         AND user_id = p_user_id;
                                END IF;                            
                                
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y'
                                               AND (   (    menu_line_cd IS NULL
                                                        AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                             OR line_cd = giisp.v ('LINE_CODE_MC')
                                                            )
                                                       )
                                                    OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                   ))
                                LOOP 
                                    IF v_temp_list_prev IS NOT NULL THEN
                                        FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                        LOOP
                                            INSERT INTO gipi_risk_profile
                                                        (line_cd        , subline_Cd    , user_id       , 
                                                         range_from     , range_to      , policy_count  , 
                                                         net_retention  , quota_share   , treaty        , 
                                                         facultative    , date_from     , date_to       , 
                                                         all_line_tag   , param_date    , inc_endt      ,
                                                         inc_expired    , cred_branch_param,
                                                         tarf_cd        , peril_cd)
                                                 VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                         v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                         v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                         v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                         p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                         p_inc_expired                        , p_cred_branch_param,
                                                         v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                        END LOOP;
                                        
                                        FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                        LOOP
                                            INSERT INTO gipi_risk_profile_item
                                                        (line_cd        , subline_Cd    , user_id       , 
                                                         range_from     , range_to      , risk_count    , 
                                                         net_retention  , quota_share   , treaty        , 
                                                         facultative    , date_from     , date_to       , 
                                                         all_line_tag   , param_date    , inc_endt      ,
                                                         inc_expired    , cred_branch_param)
                                                 VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                         v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                         v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                         v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                         p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                         p_inc_expired                        , p_cred_branch_param);
                                        END LOOP;                                 
                                    END IF;
                                    
                                    del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);  
                                END LOOP;   
                            ELSE
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y' )
                                LOOP 
                                    IF v_temp_list_prev IS NOT NULL THEN
                                        FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                        LOOP
                                            INSERT INTO gipi_risk_profile
                                                        (line_cd        , subline_Cd    , user_id       , 
                                                         range_from     , range_to      , policy_count  , 
                                                         net_retention  , quota_share   , treaty        , 
                                                         facultative    , date_from     , date_to       , 
                                                         all_line_tag   , param_date    , inc_endt      ,
                                                         inc_expired    , cred_branch_param,
                                                         tarf_cd        , peril_cd)
                                                 VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                         v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                         v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                         v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                         p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                         p_inc_expired                        , p_cred_branch_param,
                                                         v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                        END LOOP;
                                    END IF; 
                                    del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                      
                                END LOOP;                                                                                      
                            END IF;                                    
                        ELSIF NVL(p_user_response,'Update') = 'Retain'
                        THEN

                            IF p_all_line_tag = 'R' THEN
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y'
                                               AND (   (    menu_line_cd IS NULL
                                                        AND (   line_cd = giisp.v ('LINE_CODE_FI')
                                                             OR line_cd = giisp.v ('LINE_CODE_MC')
                                                            )
                                                       )
                                                    OR (menu_line_cd = 'FI' OR menu_line_cd = 'MC')
                                                   ))
                                LOOP 
                                    FOR x IN (SELECT 'Y' retain_rec
                                                FROM gipi_risk_profile
                                               WHERE line_cd = glp.line_cd
                                                 AND subline_cd IS NULL
                                                 AND all_line_tag = p_all_line_tag
                                                 AND user_id = p_user_id)
                                    LOOP
                                        v_retain := x.retain_rec;
                                        
                                    END LOOP;
                                    
                                    IF v_retain = 'Y'
                                    THEN 
                                        v_retain := 'N';
                                    ELSE 
                                        IF v_temp_list_prev IS NOT NULL THEN
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param,
                                                             tarf_cd        , peril_cd)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param,
                                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                            END LOOP;
                                            
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile_item
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , risk_count    , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param);
                                            END LOOP;                                 
                                        END IF; 
                                        del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                                  
                                    END IF;
                                END LOOP;
                            ELSE
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y' )
                                LOOP 
                                    FOR x IN (SELECT 'Y' retain_rec
                                                FROM gipi_risk_profile
                                               WHERE line_cd = glp.line_cd
                                                 AND subline_cd IS NULL
                                                 AND all_line_tag = p_all_line_tag
                                                 AND user_id = p_user_id)
                                    LOOP
                                        v_retain := x.retain_rec;
                                        
                                    END LOOP;
                                    
                                    IF v_retain = 'Y'
                                    THEN 
                                        v_retain := 'N';
                                    ELSE 
                                        IF v_temp_list_prev IS NOT NULL THEN
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param,
                                                             tarf_cd        , peril_cd)
                                                     VALUES (glp.line_cd                          , p_subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param,
                                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                            END LOOP;
                                        END IF;
                                        del_extracted_records(glp.line_cd, p_subline_cd, p_all_line_tag, p_user_id);                                    
                                    END IF;                            
                                END LOOP;                              
                            END IF;
                        END IF;
                    ELSIF p_all_line_tag IN ('N','P') THEN
                        IF (p_all_line_tag = 'P' AND p_line_cd IS NULL AND p_subline_cd IS NULL) OR (p_all_line_tag = 'N') THEN
                            IF NVL(p_user_response,'Update') = 'Update'              
                            THEN
                                 DELETE FROM gipi_risk_profile
                                       WHERE line_cd = p_prev_line_cd
                                         AND subline_cd IS NULL                  
                                         AND all_line_tag = p_prev_all_line_tag
                                         AND user_id = p_user_id;
                        
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y' )
                                LOOP 
                                    FOR b IN (SELECT subline_cd
                                                 FROM giis_subline
                                                WHERE line_cd = glp.line_cd) 
                                    LOOP
                                        IF v_temp_list_prev IS NOT NULL THEN
                                            FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param,
                                                             tarf_cd        , peril_cd)
                                                     VALUES (glp.line_cd                          , b.subline_cd                      , p_user_id                        , 
                                                             v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                             v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                             v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                             p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                             p_inc_expired                        , p_cred_branch_param,
                                                             v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                            END LOOP;
                                        END IF;
                                        del_extracted_records(glp.line_cd, b.subline_cd, p_all_line_tag, p_user_id);    
                                    END LOOP;
                                END LOOP;
                            ELSIF NVL(p_user_response,'Update') = 'Retain'
                            THEN
                                FOR glp IN (SELECT line_cd
                                              FROM giis_line
                                             WHERE pack_pol_flag <> 'Y' )
                                LOOP 
                                    FOR b IN (SELECT subline_cd
                                                 FROM giis_subline
                                                WHERE line_cd = glp.line_cd) 
                                    LOOP
                                        FOR x IN (SELECT 'Y' retain_rec
                                                    FROM gipi_risk_profile
                                                   WHERE line_cd = glp.line_cd
                                                     AND subline_cd IS NULL
                                                     AND all_line_tag = p_all_line_tag
                                                     AND user_id = p_user_id)
                                        LOOP
                                            v_retain := x.retain_rec;
                                            
                                        END LOOP;
                                        
                                        IF v_retain = 'Y'
                                        THEN 
                                            v_retain := 'N';
                                        ELSE 
                                            IF v_temp_list_prev IS NOT NULL THEN
                                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                                LOOP
                                                    INSERT INTO gipi_risk_profile
                                                                (line_cd        , subline_Cd    , user_id       , 
                                                                 range_from     , range_to      , policy_count  , 
                                                                 net_retention  , quota_share   , treaty        , 
                                                                 facultative    , date_from     , date_to       , 
                                                                 all_line_tag   , param_date    , inc_endt      ,
                                                                 inc_expired    , cred_branch_param,
                                                                 tarf_cd        , peril_cd)
                                                         VALUES (glp.line_cd                          , b.subline_cd                      , p_user_id                        , 
                                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                                 p_inc_expired                        , p_cred_branch_param,
                                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                                END LOOP;
                                            END IF;
                                            del_extracted_records(glp.line_cd, b.subline_cd, p_all_line_tag, p_user_id);                                    
                                        END IF;                                  
                                    END LOOP;
                                END LOOP;                        
                            END IF;
                        ELSIF (p_all_line_tag = 'P' AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL) THEN
                            IF v_temp_list_prev IS NOT NULL THEN
                                FOR x IN  v_temp_list_prev.FIRST..v_temp_list_prev.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , policy_count  , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param,
                                                 tarf_cd        , peril_cd)
                                         VALUES (p_line_cd                            , p_subline_cd                     , p_user_id                        , 
                                                 v_temp_list_prev (x).range_from      , v_temp_list_prev (x).range_to     , v_temp_list_prev (x).policy_count, 
                                                 v_temp_list_prev (x).net_retention   , v_temp_list_prev (x).quota_share  , v_temp_list_prev (x).treaty      , 
                                                 v_temp_list_prev (x).facultative     , p_date_from                       , p_date_to                        , 
                                                 p_all_line_tag                       , p_param_date                      , p_inc_endt                       ,
                                                 p_inc_expired                        , p_cred_branch_param,
                                                 v_temp_list_prev (x).tarf_cd         , v_temp_list_prev (x).peril_cd);
                                END LOOP;
                            END IF;
                            del_extracted_records(p_line_cd, p_subline_cd, p_all_line_tag, p_user_id);  --end Gzelle 07292015 SR4136,4196,4285,4271                         
                        END IF; 
                    END IF;                
                END IF;
            END IF;
        END IF;        
    END;
    
    
    PROCEDURE risk_save(
        p_line_cd           IN  gipi_risk_profile.LINE_CD%type,
        p_line_name         IN  VARCHAR2,
        p_subline_cd        IN  gipi_risk_profile.SUBLINE_CD%type,
        p_subline_name      IN  VARCHAR2,
        p_date_from         IN  gipi_risk_profile.DATE_FROM%type,
        p_date_to           IN  gipi_risk_profile.DATE_TO%type,
        p_range_from        IN  gipi_risk_profile.RANGE_FROM%type,
        p_range_to          IN  gipi_risk_profile.RANGE_TO%type,
        p_all_line_tag      IN  gipi_risk_profile.ALL_LINE_TAG%type,
        p_user_id           IN  gipi_risk_profile.USER_ID%type,
        p_record_status     IN  NUMBER,
        p_prev_line_cd      IN  gipi_risk_profile.LINE_CD%type,
        p_prev_subline_cd   IN  gipi_risk_profile.SUBLINE_CD%type,
        p_param_date        IN  gipi_risk_profile.PARAM_DATE%type,    -- start Gzelle 03232015
        p_inc_endt          IN  gipi_risk_profile.INC_ENDT%type,
        p_inc_expired       IN  gipi_risk_profile.INC_EXPIRED%type,
        p_cred_branch_param IN  gipi_risk_profile.CRED_BRANCH_PARAM%type, --end Gzelle 03232015
        p_user_response     IN  VARCHAR2,    --Gzelle 04012015
        p_prev_all_line_tag IN  VARCHAR2,     --Gzelle 04072015
        p_is_add_from_update IN  VARCHAR2     --Gzelle 04072015
    )
    AS
        v_line        giis_line.line_cd%TYPE;        -- storage for line_cd selected from giis_line.
        v_line_cd     giis_line.line_cd%TYPE;       ---------- used to get the line_cd from
                                                    -- giis_line equal to the dsp_line_name.
        v_sline_cd    giis_subline.subline_cd%TYPE; ---- used to get the subline_cd from 
                                                    -- giis_line equal to the dsp_subline_name.      
      	TYPE v_tab IS TABLE OF gipi_risk_profile%ROWTYPE; --Gzelle 03232015
      	TYPE v_tab_item IS TABLE OF gipi_risk_profile_item%ROWTYPE; --Gzelle 03262015

      	v_temp_list           v_tab;  --Gzelle 03232015
      	v_temp_list_item      v_tab_item;  --Gzelle 03262015
      	v_retain              VARCHAR2(4) := 'N';
        
    BEGIN
	    /* commented out by Gzelle - replaced with codes below */
        /*IF p_line_cd IS NOT NULL THEN
            /*FOR A IN (SELECT line_cd
                        FROM giis_line
                       WHERE line_name = p_line_name)
            LOOP  
                v_line := a.line_cd;
                EXIT;
            END LOOP;*/
           -- v_line := p_line_cd;
             
            --IF p_subline_cd IS NOT NULL THEN
                /*FOR B IN(SELECT subline_cd
                           FROM giis_subline
                          WHERE line_cd = v_line
                            AND subline_name = p_subline_name)
                LOOP
                    v_sline_cd := b.subline_cd;
                    EXIT;
                END LOOP;*/
                
                --v_sline_cd := p_subline_cd;
                
                /*IF p_record_status IS NULL THEN     -- to prevent delete if record is newly added 
                    DELETE FROM gipi_risk_profile
                     WHERE line_cd = v_line        
                       AND subline_cd = v_sline_cd                   
                       AND all_line_tag = p_all_line_tag
                       AND user_id = P_USER_ID;
                END IF;
                
                IF p_range_from IS NULL AND p_range_to IS NULL THEN     -- new record
                    INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                  policy_count, net_retention,quota_share,treaty, facultative,
                                                  date_from,date_to, all_line_tag)

                                          VALUES (v_line, v_sline_cd, p_user_id, null, null,
                                                  0, 0, 0, 0, 0,
                                                  p_date_from,p_date_to, p_all_line_tag);
                                          
                ELSE   -- existing record
                    INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                  policy_count, net_retention,quota_share,treaty, facultative,
                                                  date_from,date_to, all_line_tag)

                                          VALUES (v_line, v_sline_cd, p_user_id, p_range_from, p_range_to,
                                                  0, 0, 0, 0, 0,
                                                  p_date_from,p_date_to, p_all_line_tag);
                END IF;
                                               
            ELSIF p_subline_cd IS NULL THEN
                IF p_all_line_tag IN ('Y','P','R') THEN                
                    IF p_record_status IS NULL THEN     -- to prevent delete if record is newly added 
                        DELETE FROM gipi_risk_profile
                         WHERE line_cd = v_line        
                           AND subline_cd is null
                           AND all_line_tag = p_all_line_tag
                           AND user_id = P_USER_ID;
                    END IF;
                    
                    IF p_all_line_tag = 'R' THEN
                        IF p_record_status IS NULL  THEN     -- to prevent delete if record is newly added 
                            DELETE FROM gipi_risk_profile_item
                             WHERE line_cd = v_line        
                               AND subline_cd is null
                               AND all_line_tag = p_all_line_tag
                               AND user_id = P_USER_ID;  
                            
                             commit;
                        END IF;
                        --clear_message; 
                    END IF;
                    
                    --LOOP
                    IF p_range_from IS NULL AND p_range_to IS NULL THEN
                        INSERT INTO gipi_risk_profile(line_cd, subline_Cd, user_id, range_from, range_to,
                                                      policy_count, net_retention, quota_share, treaty, facultative,
                                                      date_from,date_to, all_line_tag)
                                               VALUES (v_line, null, p_user_id, null, null,
                                                       0, 0, 0, 0, 0,
                                                       p_date_from, p_date_to, p_all_line_tag);
                  
                        IF p_all_line_tag = 'R' THEN
                              INSERT INTO gipi_risk_profile_item(line_cd,subline_Cd, user_id, range_from, range_to,
                                                                 risk_count, net_retention, quota_share, treaty, facultative,
                                                                 date_from, date_to, all_line_tag)
                                                         VALUES (v_line, null,p_user_id, null, null,
                                                                 0, 0, 0, 0, 0,
                                                                 p_date_from,p_date_to, p_all_line_tag);
                        END IF;
                                              
                    ELSE 
                        INSERT INTO gipi_risk_profile(line_cd, subline_Cd, user_id, range_from, range_to,
                                                      policy_count, net_retention, quota_share, treaty, facultative,
                                                      date_from,date_to, all_line_tag)
                                               VALUES (v_line, null, p_user_id, p_range_from, p_range_to,
                                                       0, 0, 0, 0, 0,
                                                       p_date_from, p_date_to, p_all_line_tag);
                  
                        IF p_all_line_tag = 'R' THEN
                              INSERT INTO gipi_risk_profile_item(line_cd,subline_Cd, user_id, range_from, range_to,
                                                                 risk_count, net_retention, quota_share, treaty, facultative,
                                                                 date_from, date_to, all_line_tag)
                                                         VALUES (v_line, null,p_user_id, p_range_from, p_range_to,
                                                                 0, 0, 0, 0, 0,
                                                                 p_date_from,p_date_to, p_all_line_tag);
                        END IF;
                
                        --COMMIT;   
                    END IF;          
                    --END LOOP;
                 
                ELSIF p_all_line_tag = 'N' THEN
                    IF p_record_status IS NULL THEN     -- to prevent delete if record is newly added 
                        DELETE FROM gipi_risk_profile
                         WHERE line_cd = v_line        
                           AND all_line_tag = 'N'
                           AND user_id = P_USER_ID;
                    END IF;
                
                    FOR B IN(SELECT subline_cd
                               FROM giis_subline
                              WHERE line_cd = v_line)
                    LOOP
                        IF p_range_from IS NULL AND p_range_to IS NULL THEN     -- new record
                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from, range_to,
                                                          policy_count, net_retention, quota_share,treaty, facultative,
                                                          date_from,date_to, all_line_tag)
                                                  VALUES (v_line, b.subline_cd, p_user_id,null, null,
                                                          0, 0, 0, 0, 0,
                                                          p_date_from,p_date_to, p_all_line_tag); 
                                                  
                        ELSE   -- existing record
                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from, range_to,
                                                          policy_count, net_retention, quota_share,treaty, facultative,
                                                          date_from,date_to, all_line_tag)
                                                  VALUES (v_line, b.subline_cd, p_user_id, p_range_from, p_range_to,
                                                          0, 0, 0, 0, 0,
                                                          p_date_from,p_date_to, p_all_line_tag); 
                        END IF;
                    END LOOP;
                END IF;
            END IF;
            
        ELSIF p_line_cd IS NULL THEN
            IF p_all_line_tag = 'Y' THEN
                -- Apollo Cruz 10.21.2014  
                -- transfered deleting of previous reocords to allow inserting of range for newly added risk
                --IF p_record_status IS NULL THEN
--                    DELETE FROM gipi_risk_profile
--                     WHERE user_id = p_user_id
--                       AND all_line_tag = 'Y'; 
                --END IF;
                   
                FOR glp IN (SELECT line_cd
                              FROM giis_line)
                LOOP 
                    IF p_range_from IS NULL AND p_range_to IS NULL THEN     -- new record
                        INSERT INTO gipi_risk_profile(line_cd, user_id, range_from, range_to, 
                                                      policy_count, net_retention,quota_share,treaty, facultative,
                                                      date_from,date_to, all_line_tag)
                                              VALUES (glp.line_cd, p_user_id ,null, null, 
                                                      0, 0, 0, 0, 0,
                                                      p_date_from, p_date_to, p_all_line_tag);
                                                  
                    ELSE  -- existing record
                        INSERT INTO gipi_risk_profile(line_cd, user_id, range_from, range_to, policy_count,
                                                      net_retention,quota_share,treaty, facultative,
                                                      date_from,date_to, all_line_tag)
                                              VALUES (glp.line_cd, p_user_id ,p_range_from,
                                                      p_range_to, 0, 0, 0, 0, 0,
                                                      p_date_from, p_date_to, p_all_line_tag);
                    END IF;
                  
                END LOOP; 
            ELSIF p_all_line_tag IN ('N','P') THEN 
               -- Apollo Cruz 10.21.2014  
               -- transfered deleting of previous reocords to allow inserting of range for newly added risk               
               --IF p_record_status IS NULL THEN
--                    DELETE FROM gipi_risk_profile
--                     WHERE user_id = p_user_id
--                       AND all_line_tag = 'N'; 
                --END IF;
                   
                FOR glp IN (SELECT line_cd
                               FROM giis_line)
                LOOP 
                    FOR b IN (SELECT subline_cd
                                 FROM giis_subline
                                WHERE line_cd = glp.line_cd) 
                    LOOP
                        IF p_range_from IS NULL AND p_range_to IS NULL THEN     -- new record
                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from, range_to, 
                                                          policy_count, net_retention ,quota_share, treaty,
                                                          facultative, date_from, date_to, all_line_tag)
                                                  VALUES (glp.line_cd, b.subline_cd, p_user_id, null, 
                                                          null, 0, 0, 0, 0, 0,
                                                          p_date_from, p_date_to, p_all_line_tag);
                                                      
                        ELSE  -- existing record
                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from, range_to, 
                                                          policy_count, net_retention ,quota_share, treaty,
                                                          facultative, date_from, date_to, all_line_tag)
                                                  VALUES (glp.line_cd, b.subline_cd, p_user_id, p_range_from, 
                                                          p_range_to, 0, 0, 0, 0, 0,
                                                          p_date_from, p_date_to, p_all_line_tag);
                        END IF;
                    END LOOP;
                END LOOP;  
            END IF;
        END IF;*/
		--start Gzelle
        del_extracted_records(p_line_cd, p_subline_cd, p_all_line_tag, p_user_id);  -- Gzelle 07292015 SR4136,4196,4285,4271 
        IF p_is_add_from_update = 'Y'
        THEN
            risk_update_add(p_line_cd, p_subline_cd, p_date_from, p_date_to, p_all_line_tag, p_user_id, p_prev_line_cd, 
                            p_prev_subline_cd, p_param_date, p_inc_endt, p_inc_expired, p_cred_branch_param, p_prev_all_line_tag, 
                            p_user_response);
        ELSE
            IF p_line_cd IS NOT NULL THEN
                v_line := p_line_cd;
                IF p_subline_cd IS NOT NULL THEN
                    v_sline_cd := p_subline_cd;

                    SELECT *    --Gzelle 03232015
                    BULK COLLECT INTO v_temp_list
                      FROM gipi_risk_profile                         
                         WHERE line_cd = p_line_cd
                           AND subline_cd = p_subline_cd
                           AND all_line_tag = p_all_line_tag
                           AND user_id = p_user_id;     

                    IF p_record_status IS NULL THEN
                         DELETE FROM gipi_risk_profile       --Gzelle 03232015
                             WHERE line_cd = p_line_cd
                               AND subline_cd = p_subline_cd
                               AND all_line_tag = p_all_line_tag
                               AND user_id = p_user_id;                               
                    END IF;    
                        
                    IF p_range_from IS NULL AND p_range_to IS NULL THEN
                         IF v_temp_list IS NOT NULL THEN
                            FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                            LOOP
                                INSERT INTO gipi_risk_profile
                                            (line_cd        , subline_Cd    , user_id       , 
                                             range_from     , range_to      , policy_count  , 
                                             net_retention  , quota_share   , treaty        , 
                                             facultative    , date_from     , date_to       , 
                                             all_line_tag   , param_date    , inc_endt      ,
                                             inc_expired    , cred_branch_param)
                                     VALUES (v_temp_list (c).line_cd         , v_temp_list (c).subline_Cd   , v_temp_list (c).user_id     , 
                                             v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                             v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                             v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                             v_temp_list (c).all_line_tag    , p_param_date               , p_inc_endt                  ,
                                             p_inc_expired                   , p_cred_branch_param);
                            END LOOP;
                         END IF;  
                    ELSE
                        INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                      policy_count, net_retention,quota_share,treaty, facultative,
                                                      date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                      inc_expired, cred_branch_param)
                                              VALUES (v_line, v_sline_cd, p_user_id, p_range_from, p_range_to,
                                                      0, 0, 0, 0, 0,
                                                      p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                      p_inc_expired, p_cred_branch_param);                    
                    END IF;
                                            
                ELSIF p_subline_cd IS NULL THEN

                    SELECT *    --Gzelle 03232015
                    BULK COLLECT INTO v_temp_list
                      FROM gipi_risk_profile                         
                         WHERE line_cd = p_line_cd
                           AND subline_cd IS NULL
                           AND all_line_tag = p_all_line_tag
                           AND user_id = p_user_id;
                
                    IF p_all_line_tag IN ('Y','R','P') THEN   -- Gzelle 07292015 SR4136,4196,4285,4271              
                        IF p_record_status IS NULL THEN
                             DELETE FROM gipi_risk_profile
                                 WHERE line_cd = p_line_cd
                                   AND subline_cd IS NULL
                                   AND all_line_tag = p_all_line_tag
                                   AND user_id = p_user_id;                             
                        END IF;
                        
                        IF p_all_line_tag = 'R' THEN
                        
                            SELECT *    --Gzelle 03262015
                            BULK COLLECT INTO v_temp_list_item
                              FROM gipi_risk_profile_item                     
                                 WHERE line_cd = p_line_cd
                                   AND subline_cd IS NULL
                                   AND all_line_tag = p_all_line_tag
                                   AND user_id = p_user_id;
                        
                            IF p_record_status IS NULL  THEN
                                 DELETE FROM gipi_risk_profile_item
                                     WHERE line_cd = p_line_cd
                                       AND subline_cd IS NULL
                                       AND all_line_tag = p_all_line_tag
                                       AND user_id = p_user_id;                            
                            END IF; -- Gzelle 07292015 SR4136,4196,4285,4271 
                        END IF;
                        
                        IF p_range_from IS NULL AND p_range_to IS NULL THEN
                             IF v_temp_list IS NOT NULL THEN
                                FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                                LOOP
                                    INSERT INTO gipi_risk_profile
                                                (line_cd        , subline_Cd    , user_id       , 
                                                 range_from     , range_to      , policy_count  , 
                                                 net_retention  , quota_share   , treaty        , 
                                                 facultative    , date_from     , date_to       , 
                                                 all_line_tag   , param_date    , inc_endt      ,
                                                 inc_expired    , cred_branch_param)
                                         VALUES (v_temp_list (c).line_cd         , v_temp_list (c).subline_Cd   , v_temp_list (c).user_id     , 
                                                 v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                                 v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                                 v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                                 v_temp_list (c).all_line_tag    , p_param_date                 , p_inc_endt                  ,
                                                 p_inc_expired                   , p_cred_branch_param);
                                END LOOP;
                             END IF;  
                                     
                             IF p_all_line_tag = 'R' THEN
                                 IF v_temp_list IS NOT NULL THEN
                                    FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                                    LOOP
                                        INSERT INTO gipi_risk_profile_item
                                                    (line_cd        , subline_Cd    , user_id       , 
                                                     range_from     , range_to      , risk_count    , 
                                                     net_retention  , quota_share   , treaty        , 
                                                     facultative    , date_from     , date_to       , 
                                                     all_line_tag   , param_date    , inc_endt      ,
                                                     inc_expired    , cred_branch_param)
                                             VALUES (v_temp_list (c).line_cd         , v_temp_list (c).subline_Cd   , v_temp_list (c).user_id     , 
                                                     v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                                     v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                                     v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                                     v_temp_list (c).all_line_tag    , p_param_date                 , p_inc_endt                  ,
                                                     p_inc_expired                   , p_cred_branch_param);
                                    END LOOP;
                                 END IF;                              
                             END IF;
                        ELSE 
                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                          policy_count, net_retention,quota_share,treaty, facultative,
                                                          date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                          inc_expired, cred_branch_param)
                                                  VALUES (p_line_cd, p_subline_cd, p_user_id, p_range_from, p_range_to,
                                                          0, 0, 0, 0, 0,
                                                          p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                          p_inc_expired, p_cred_branch_param);                    
                      
                            IF p_all_line_tag = 'R' THEN
                                  INSERT INTO gipi_risk_profile_item(line_cd,subline_Cd, user_id, range_from, range_to,
                                                                     risk_count, net_retention, quota_share, treaty, facultative,
                                                                     date_from, date_to, all_line_tag, param_date, inc_endt, 
                                                                     inc_expired, cred_branch_param)
                                                             VALUES (p_line_cd, null,p_user_id, p_range_from, p_range_to,
                                                                     0, 0, 0, 0, 0,
                                                                     p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                                     p_inc_expired, p_cred_branch_param); 
                            END IF;
                        END IF;          
                     
                    ELSIF p_all_line_tag IN ('N') THEN  -- Gzelle 07292015 SR4136,4196,4285,4271 
                        IF NVL(p_user_response,'Update') = 'Update'
                        THEN
                            IF p_record_status IS NULL THEN
                                 DELETE FROM gipi_risk_profile
                                     WHERE line_cd = p_line_cd
                                       AND all_line_tag = p_all_line_tag
                                       AND user_id = p_user_id;                            
                            END IF;                                    
                        
                            FOR B IN(SELECT subline_cd
                                       FROM giis_subline
                                      WHERE line_cd = p_line_cd)
                            LOOP
                                IF p_range_from IS NULL AND p_range_to IS NULL THEN
                                     IF v_temp_list IS NOT NULL THEN
                                        FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                                        LOOP
                                            INSERT INTO gipi_risk_profile
                                                        (line_cd        , subline_Cd    , user_id       , 
                                                         range_from     , range_to      , policy_count  , 
                                                         net_retention  , quota_share   , treaty        , 
                                                         facultative    , date_from     , date_to       , 
                                                         all_line_tag   , param_date    , inc_endt      ,
                                                         inc_expired    , cred_branch_param)
                                                 VALUES (v_temp_list (c).line_cd         , b.subline_cd                 , v_temp_list (c).user_id     , 
                                                         v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                                         v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                                         v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                                         v_temp_list (c).all_line_tag    , p_param_date                 , p_inc_endt                  ,
                                                         p_inc_expired                   , p_cred_branch_param);
                                        END LOOP;
                                     END IF;                                                   
                                ELSE
                                        INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                                      policy_count, net_retention,quota_share,treaty, facultative,
                                                                      date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                                      inc_expired, cred_branch_param)
                                                              VALUES (v_line, b.subline_cd, p_user_id, p_range_from, p_range_to,
                                                                      0, 0, 0, 0, 0,
                                                                      p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                                      p_inc_expired, p_cred_branch_param);                    
                                END IF;
                            END LOOP;
                        ELSIF NVL(p_user_response,'Update') = 'Retain'
                        THEN
                            FOR B IN(SELECT subline_cd
                                       FROM giis_subline
                                      WHERE line_cd = p_line_cd)
                            LOOP
                                FOR x IN (SELECT *
                                            FROM gipi_risk_profile
                                           WHERE line_cd = p_line_cd
                                             AND subline_cd = b.subline_cd
                                             AND all_line_tag = p_all_line_tag
                                             AND user_id = p_user_id)
                                LOOP
                                    v_retain := 'Y';
                                END LOOP;
                                
                                IF v_retain = 'Y'
                                THEN
                                    v_retain := 'N';
                                ELSE
                                    INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                                  policy_count, net_retention,quota_share,treaty, facultative,
                                                                  date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                                  inc_expired, cred_branch_param)
                                                          VALUES (v_line, b.subline_cd, p_user_id, p_range_from, p_range_to,
                                                                  0, 0, 0, 0, 0,
                                                                  p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                                  p_inc_expired, p_cred_branch_param);                                 
                                END IF;                            
                            END LOOP;                        
                        END IF;
                    END IF;
                END IF;
                
            ELSIF p_line_cd IS NULL THEN
                IF p_all_line_tag IN ('Y','R') THEN
                    IF NVL(p_user_response,'Update') = 'Update'
                    THEN
                        FOR glp IN (SELECT line_cd
                                      FROM giis_line
                                     WHERE pack_pol_flag <> 'Y')
                        LOOP 
                            IF p_range_from IS NULL AND p_range_to IS NULL THEN
                                 IF v_temp_list IS NOT NULL THEN
                                    FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                                    LOOP
                                        INSERT INTO gipi_risk_profile
                                                    (line_cd        , subline_Cd    , user_id       , 
                                                     range_from     , range_to      , policy_count  , 
                                                     net_retention  , quota_share   , treaty        , 
                                                     facultative    , date_from     , date_to       , 
                                                     all_line_tag   , param_date    , inc_endt      ,
                                                     inc_expired    , cred_branch_param)
                                             VALUES (v_temp_list (c).line_cd         , v_temp_list (c).subline_Cd   , v_temp_list (c).user_id     , 
                                                     v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                                     v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                                     v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                                     v_temp_list (c).all_line_tag    , p_param_date               , p_inc_endt                  ,
                                                     p_inc_expired                   , p_cred_branch_param);
                                    END LOOP;
                                 END IF;                                                       
                            ELSE
                                    INSERT INTO gipi_risk_profile(line_cd, user_id, range_from ,range_to,
                                                                  policy_count, net_retention,quota_share,treaty, facultative,
                                                                  date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                                  inc_expired, cred_branch_param)
                                                          VALUES (glp.line_cd, p_user_id, p_range_from, p_range_to,
                                                                  0, 0, 0, 0, 0,
                                                                  p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,  -- start Gzelle 07292015 SR4136,4196,4285,4271 
                                                                  p_inc_expired, p_cred_branch_param);                    
                            END IF;                    
                        END LOOP;
                    ELSIF NVL(TRIM(p_user_response),'Update') = 'Retain'
                    THEN
                        FOR glp IN (SELECT line_cd
                                      FROM giis_line
                                     WHERE pack_pol_flag <> 'Y')
                        LOOP 
                            FOR x IN (SELECT 'Y' retain_rec
                                        FROM gipi_risk_profile
                                       WHERE line_cd = glp.line_cd
                                         AND subline_cd IS NULL
                                         AND all_line_tag = p_all_line_tag
                                         AND user_id = p_user_id)
                            LOOP
                                v_retain := x.retain_rec;
                                
                            END LOOP;
                            
                            IF v_retain = 'Y'
                            THEN 
                                v_retain := 'N';
                            ELSE 
                                INSERT INTO gipi_risk_profile(line_cd, user_id, range_from ,range_to,
                                                              policy_count, net_retention,quota_share,treaty, facultative,
                                                              date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                              inc_expired, cred_branch_param)
                                                      VALUES (glp.line_cd, p_user_id, p_range_from, p_range_to,
                                                              0, 0, 0, 0, 0,
                                                              p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                              p_inc_expired, p_cred_branch_param);                                     
                            END IF;                           
                        END LOOP;
                    END IF;
                ELSIF p_all_line_tag IN ('N','P') THEN 
                    IF (p_all_line_tag = 'P' AND p_line_cd IS NULL AND p_subline_cd IS NULL) OR (p_all_line_tag = 'N') THEN
                        IF NVL(p_user_response,'Update') = 'Update'
                        THEN
                            FOR glp IN (SELECT line_cd
                                          FROM giis_line
                                         WHERE pack_pol_flag <> 'Y')
                            LOOP 
                                FOR b IN (SELECT subline_cd
                                             FROM giis_subline
                                            WHERE line_cd = glp.line_cd) 
                                LOOP
                                    IF p_range_from IS NULL AND p_range_to IS NULL THEN
                                         IF v_temp_list IS NOT NULL THEN
                                            FOR c IN  v_temp_list.FIRST..v_temp_list.LAST
                                            LOOP
                                                INSERT INTO gipi_risk_profile
                                                            (line_cd        , subline_Cd    , user_id       , 
                                                             range_from     , range_to      , policy_count  , 
                                                             net_retention  , quota_share   , treaty        , 
                                                             facultative    , date_from     , date_to       , 
                                                             all_line_tag   , param_date    , inc_endt      ,
                                                             inc_expired    , cred_branch_param)
                                                     VALUES (v_temp_list (c).line_cd         , v_temp_list (c).subline_Cd   , v_temp_list (c).user_id     , 
                                                             v_temp_list (c).range_from      , v_temp_list (c).range_to     , v_temp_list (c).policy_count, 
                                                             v_temp_list (c).net_retention   , v_temp_list (c).quota_share  , v_temp_list (c).treaty      , 
                                                             v_temp_list (c).facultative     , p_date_from                  , p_date_to                   , 
                                                             v_temp_list (c).all_line_tag    , p_param_date               , p_inc_endt                  ,
                                                             p_inc_expired                   , p_cred_branch_param);
                                            END LOOP;
                                         END IF;                                                            
                                    ELSE
                                            INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                                          policy_count, net_retention,quota_share,treaty, facultative,
                                                                          date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                                          inc_expired, cred_branch_param)
                                                                  VALUES (glp.line_cd, b.subline_cd, p_user_id, p_range_from, p_range_to,
                                                                          0, 0, 0, 0, 0,
                                                                          p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                                          p_inc_expired, p_cred_branch_param);                    
                                    END IF;
                                END LOOP;
                            END LOOP;
                        ELSIF NVL(p_user_response,'Update') = 'Retain'
                        THEN
                            FOR glp IN (SELECT line_cd
                                          FROM giis_line
                                         WHERE pack_pol_flag <> 'Y')
                            LOOP 
                                FOR b IN (SELECT subline_cd
                                             FROM giis_subline
                                            WHERE line_cd = glp.line_cd) 
                                LOOP
                                    FOR x IN (SELECT *
                                                FROM gipi_risk_profile
                                               WHERE line_cd = glp.line_cd
                                                 AND subline_cd = b.subline_cd
                                                 AND all_line_tag = p_all_line_tag
                                                 AND user_id = p_user_id)
                                    LOOP
                                        v_retain := 'Y';
                                    END LOOP;
                                    
                                    IF v_retain = 'Y'
                                    THEN
                                        v_retain := 'N';
                                    ELSE
                                        INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                                      policy_count, net_retention,quota_share,treaty, facultative,
                                                                      date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                                      inc_expired, cred_branch_param)
                                                              VALUES (glp.line_cd, b.subline_cd, p_user_id, p_range_from, p_range_to,
                                                                      0, 0, 0, 0, 0,
                                                                      p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                                      p_inc_expired, p_cred_branch_param);                                  
                                    END IF;
                                END LOOP;
                            END LOOP;                                        
                        END IF; 
                    ELSIF (p_all_line_tag = 'P' AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL) THEN
                        INSERT INTO gipi_risk_profile(line_cd, subline_cd, user_id, range_from ,range_to,
                                                      policy_count, net_retention,quota_share,treaty, facultative,
                                                      date_from,date_to, all_line_tag, param_date, inc_endt, 
                                                      inc_expired, cred_branch_param)
                                              VALUES (p_line_cd, p_subline_cd, p_user_id, p_range_from, p_range_to,
                                                      0, 0, 0, 0, 0,
                                                      p_date_from,p_date_to, p_all_line_tag, p_param_date, p_inc_endt,
                                                      p_inc_expired, p_cred_branch_param);   
                    END IF;     -- Gzelle 07292015 SR4136,4196,4285,4271 
                END IF;
            END IF;        
        END IF;

        DECLARE
        v_dtl   VARCHAR2(1) := 'Y';
        v_item  VARCHAR2(1) := 'Y';
        
        BEGIN
            BEGIN
                SELECT 'X'
                  INTO v_dtl
                  FROM gipi_risk_profile_dtl
                 WHERE line_cd = p_line_cd
                    AND NVL(subline_cd,'1') = DECODE(p_subline_cd, NULL ,NVL(subline_cd,'1') , p_subline_cd)
                   AND all_line_tag = p_all_line_tag
                   AND user_id = p_user_id
                   AND rownum = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl := 'Y';             
            END;               

            BEGIN
            SELECT 'X'
              INTO v_item
              FROM gipi_polrisk_item_ext   -- Gzelle 07292015 SR4136,4196,4285,4271 
             WHERE line_cd = p_line_cd
               AND user_id = p_user_id     -- Gzelle 07292015 SR4136,4196,4285,4271 
               AND rownum = 1; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_item := 'Y';             
            END;                 
            
            IF v_dtl = 'X'
            THEN
                DELETE gipi_risk_profile_dtl
                 WHERE line_cd = p_line_cd
                    AND NVL(subline_cd,'1') = DECODE(p_subline_cd, NULL ,NVL(subline_cd,'1') , p_subline_cd)
                   AND all_line_tag = p_all_line_tag
                   AND user_id = p_user_id;
                -- start Gzelle 07292015 SR4136,4196,4285,4271    
                UPDATE gipi_risk_profile
                   SET policy_count = 0, net_retention = 0, quota_share = 0, treaty = 0, facultative = 0,
                       treaty_tsi = NULL, treaty2_tsi = NULL, treaty3_tsi = NULL, treaty4_tsi = NULL, treaty5_tsi = NULL,
                       treaty6_tsi = NULL, treaty7_tsi = NULL, treaty8_tsi = NULL, treaty9_tsi = NULL, treaty10_tsi = NULL,
                       treaty_prem = NULL, treaty2_prem = NULL, treaty3_prem = NULL, treaty4_prem = NULL, treaty5_prem = NULL,
                       treaty6_prem = NULL, treaty7_prem = NULL, treaty8_prem = NULL, treaty9_prem = NULL, treaty10_prem = NULL,
                       net_retention_tsi = NULL, facultative_tsi = NULL, quota_share_tsi = NULL, sec_net_retention_tsi = NULL, 
                       sec_net_retention_prem = NULL, net_retention_cnt = NULL, facultative_cnt = NULL, claim_count = NULL,
                       treaty_cnt = NULL, treaty2_cnt = NULL, treaty3_cnt = NULL, treaty4_cnt = NULL, treaty5_cnt = NULL, 
                       treaty6_cnt = NULL, treaty7_cnt = NULL, treaty8_cnt = NULL, treaty9_cnt = NULL, treaty10_cnt = NULL, 
                       quota_share_cnt = NULL, sec_net_retention_cnt = NULL, peril_tsi = NULL, peril_prem = NULL,
                       trty_name = NULL, trty2_name = NULL, trty3_name = NULL, trty4_name = NULL, trty5_name = NULL,
                       trty6_name = NULL, trty7_name = NULL, trty8_name = NULL, trty9_name = NULL, trty10_name = NULL
                 WHERE line_cd = p_line_cd
                   AND NVL(subline_cd,'1') = DECODE(p_subline_cd, NULL ,NVL(subline_cd,'1') , p_subline_cd)
                   AND all_line_tag = p_all_line_tag
                   AND user_id = p_user_id; --end Gzelle 07292015 SR4136,4196,4285,4271    
            END IF;             
            
            IF v_item = 'X'
            THEN
                DELETE gipi_polrisk_item_ext    --Gzelle 07292015 SR4136,4196,4285,4271    
                 WHERE line_cd = p_line_cd
                   AND user_id = p_user_id;     --Gzelle 07292015 SR4136,4196,4285,4271                
            END IF;                 
        END;
        del_extracted_records(p_line_cd, p_subline_cd, p_all_line_tag, p_user_id); --Gzelle 07292015 SR4136,4196,4285,4271          
    END risk_save;
    
    --Apollo Cruz 10.21.2014
    PROCEDURE delete_risk_profile_prev_recs (
       p_all_line_tag   VARCHAR2,
       p_user_id        VARCHAR2
    )
    IS 
    BEGIN
       DELETE FROM gipi_risk_profile
        WHERE user_id = p_user_id
          AND all_line_tag = DECODE(p_all_line_tag, 'Y', 'Y', 'N', 'N', 'P', 'N', 'Y');
    END delete_risk_profile_prev_recs;
    
    PROCEDURE check_fire_stat (
       p_fire_stat    IN       VARCHAR2,
       p_date_rb      IN       VARCHAR2,
       p_date         IN       VARCHAR2,
       p_date_from    IN       VARCHAR2,
       p_date_to      IN       VARCHAR2,
       p_as_of_date   IN       VARCHAR2,
       p_bus_cd       IN       NUMBER,
       p_zone         IN       VARCHAR2,
       p_zone_type    IN       VARCHAR2,
       p_risk_cnt     IN       VARCHAR2,
       p_incl_endt    IN       VARCHAR2,
       p_incl_exp     IN       VARCHAR2,
       p_peril_type   IN       VARCHAR2,
       p_user         IN       VARCHAR2,
       p_cnt          OUT      NUMBER
    )
    AS
       v_datefrom   DATE   := TRUNC (TO_DATE (p_date_from, 'MM-DD-RRRR'));
       v_dateto     DATE   := TRUNC (TO_DATE (p_date_to, 'MM-DD-RRRR'));
       v_as_of      DATE   := TRUNC (TO_DATE (p_as_of_date, 'MM-DD-RRRR'));
       v_ctr        NUMBER;
    BEGIN
       IF p_date_rb = '1'
       THEN
          BEGIN
             SELECT COUNT (DISTINCT line_cd
                            || '-'
                            || subline_cd
                            || '-'
                            || iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (renew_no, '09'))
                          ) cnt
               INTO v_ctr
               FROM gipi_firestat_extract_dtl
              WHERE zone_type = p_zone_type
                AND as_of_sw = 'N'
                AND TRUNC (date_from) = v_datefrom
                AND TRUNC (date_to) = v_dateto
                AND user_id = p_user
                AND param_date = p_date
                AND inc_null_zone = p_zone
                AND inc_expired = p_incl_exp
                AND inc_endt = p_incl_endt
                AND param_iss_cd = p_bus_cd
                AND param_peril = p_peril_type
             HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_ctr := 0;
          END;
       ELSIF p_date_rb = '2'
       THEN
          BEGIN
             SELECT COUNT (DISTINCT line_cd
                            || '-'
                            || subline_cd
                            || '-'
                            || iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (renew_no, '09'))
                          ) cnt
               INTO v_ctr
               FROM gipi_firestat_extract_dtl
              WHERE zone_type = p_zone_type
                AND as_of_sw = 'Y'
                AND TRUNC (as_of_date) = p_as_of_date
                AND user_id = p_user
                AND inc_null_zone = p_zone
                AND inc_expired = p_incl_exp
                AND inc_endt = p_incl_endt
                AND param_iss_cd = p_bus_cd
                AND param_peril = p_peril_type
             HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_ctr := 0;             
          END;
       END IF;

       p_cnt := v_ctr;
    END check_fire_stat;
    
    --Gzelle 03262015
    PROCEDURE val_before_save(
        p_line_cd           IN  gipi_risk_profile.line_cd%TYPE,
        p_subline_cd        IN  gipi_risk_profile.subline_cd%TYPE,
        p_all_line_tag      IN  gipi_risk_profile.all_line_tag%TYPE,
        p_user_id           IN  gipi_risk_profile.user_id%TYPE,
        p_msg               OUT VARCHAR2
    )    
    AS  
        v_res   VARCHAR2(1) := 'O';
    BEGIN
        IF p_line_cd IS NULL
        THEN
            IF p_all_line_tag IN ('Y','R')
            THEN
                FOR l IN (SELECT line_cd
                            FROM giis_line
                           WHERE pack_pol_flag <> 'Y')
                LOOP
                    FOR x IN ( SELECT 'X' rec_exists
                                 FROM gipi_risk_profile
                                WHERE line_cd = l.line_cd
                                  AND subline_cd IS NULL
                                  AND all_line_tag = p_all_line_tag
                                  AND user_id = NVL(p_user_id,USER))
                    LOOP
                        v_res := x.rec_exists;
                        IF x.rec_exists = 'X'
                        THEN
                           EXIT;
                        END IF;
                    END LOOP;
                END LOOP;             
            ELSIF p_all_line_tag IN ('N','P')
            THEN
                FOR l IN (SELECT line_cd
                            FROM giis_line
                           WHERE pack_pol_flag <> 'Y')
                LOOP 
                    FOR b IN (SELECT subline_cd
                                FROM giis_subline
                               WHERE line_cd = l.line_cd) 
                    LOOP
                        FOR x IN ( SELECT 'X' rec_exists
                                     FROM gipi_risk_profile
                                    WHERE line_cd = l.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND all_line_tag = p_all_line_tag
                                      AND user_id = NVL(p_user_id,USER))
                        LOOP
                            v_res := x.rec_exists;
                            IF x.rec_exists = 'X'
                            THEN
                                EXIT;
                            END IF;
                        END LOOP;                
                    END LOOP;
                END LOOP;             
            END IF;
        ELSIF p_line_cd IS NOT NULL THEN    --Gzelle 07292015 SR4136,4196,4285,4271
            IF p_subline_cd IS NULL THEN
                IF p_all_line_tag IN ('Y','R','P') THEN --Gzelle 07292015 SR4136,4196,4285,4271
                    SELECT 'X'
                      INTO v_res
                      FROM gipi_risk_profile
                     WHERE line_cd = p_line_cd
                       AND subline_cd IS NULL
                       AND all_line_tag = p_all_line_tag
                       AND user_id = NVL(p_user_id,USER)
                       AND rownum = 1;                
                ELSIF p_all_line_tag IN ('N') THEN  --Gzelle 07292015 SR4136,4196,4285,4271
                    FOR b IN (SELECT subline_cd
                                FROM giis_subline
                               WHERE line_cd = p_line_cd) 
                    LOOP
                        FOR x IN ( SELECT 'X' rec_exists
                                     FROM gipi_risk_profile
                                    WHERE line_cd = p_line_cd
                                      AND subline_cd = b.subline_cd
                                      AND all_line_tag = p_all_line_tag
                                      AND user_id = NVL(p_user_id,USER))
                        LOOP
                            v_res := x.rec_exists;
                            IF x.rec_exists = 'X'
                            THEN
                                EXIT;
                            END IF;
                        END LOOP;                
                    END LOOP;                  
                END IF;                
            ELSE
                SELECT 'X'
                  INTO v_res
                  FROM gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND all_line_tag = p_all_line_tag
                   AND user_id = NVL(p_user_id,USER)
                   AND rownum = 1;                            
            END IF;                    
        END IF;
        p_msg := v_res;
    END;

    --Gzelle 04072015
    PROCEDURE val_add_upd_rec(
        p_line_cd           IN  gipi_risk_profile.line_cd%TYPE,
        p_subline_cd        IN  gipi_risk_profile.subline_cd%TYPE,
        p_all_line_tag      IN  gipi_risk_profile.all_line_tag%TYPE,
        p_user_id           IN  gipi_risk_profile.user_id%TYPE,
        p_msg               OUT VARCHAR2
    )    
    AS  
        v_res   VARCHAR2(1) := 'O';
    BEGIN
        IF p_subline_cd IS NULL
        THEN
            BEGIN
            SELECT 'X'
              INTO v_res
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd IS NULL
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND rownum = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_res := 'O';
            END;         
        ELSE
            BEGIN
            SELECT 'X'
              INTO v_res
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND user_id = p_user_id
               AND all_line_tag = p_all_line_tag
               AND rownum = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_res := 'O';
            END;         
        END IF;
        p_msg := v_res;
    END;    
END GIPIS901_PKG;
/



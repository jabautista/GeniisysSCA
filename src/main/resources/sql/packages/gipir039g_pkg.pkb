CREATE OR REPLACE PACKAGE BODY CPI.GIPIR039G_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.25.2013
     ** Referenced By:  GIPIR039G -  COMMITMENT AND ACCUMULATION SUMMARY-TOTAL FACULTATIVE
     **/
    
    
    FUNCTION populate_main_report(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2
    ) RETURN main_report_tab PIPELINED
    AS
        TYPE cur_typ IS REF CURSOR;        
        TYPE cur_typ2 IS REF CURSOR;
        
        rep         main_report_type;
        v_print     boolean := false;
        custom      cur_typ;
        custom2     cur_typ2;
        v_column    VARCHAR2 (50);
        v_table     VARCHAR2 (50);
        v_query     VARCHAR (10000);
        v_query2    VARCHAR (10000);
        v_zone_grp  giis_flood_zone.zone_grp%TYPE;
        v_zone_no   GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type;
        v_zone_group GIIS_FLOOD_ZONE.ZONE_GRP%type;
        v_policy_id GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO rep.company_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         END;

         BEGIN
            SELECT param_value_v
              INTO rep.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;
         
         IF p_zone_type = 1 THEN
            rep.title := 'Flood Accumulation Limit Summary';
         ELSIF p_zone_type = 2 THEN     
            rep.title := 'Typhoon Accumulation Limit Summary';
         ELSIF p_zone_type = 3 THEN
            rep.title := 'Earthquake Accumulation Limit Summary';
         ELSIF p_zone_type = 4 THEN
            rep.title := 'Fire Accumulation Limit Summary';
         ELSE
            rep.title := 'Typhoon and Flood Accumulation Limit Summary';
         END IF;
         
         IF p_date = '1' THEN
            rep.header := 'From '||to_char(TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY')||' To '
                            ||to_char(TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
         ELSE
            rep.header := 'As of '||to_char(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
         END IF;    
         
         IF p_zone_type = 1 THEN
             v_column := 'FLOOD_ZONE';
             v_table := 'GIIS_FLOOD_ZONE';
         ELSIF p_zone_type = 2 THEN
             v_column := 'TYPHOON_ZONE';
             v_table := 'GIIS_TYPHOON_ZONE';
         ELSE
             v_column := 'EQ_ZONE';
             v_table := 'GIIS_EQZONE';
         END IF;
         
         /** main query **/
         v_query := 'SELECT a.line_cd||''-''||a.subline_cd||''-''||a.iss_cd||''-''||LTRIM(TO_CHAR(a.issue_yy, ''09''))
                                ||''-''||LTRIM(TO_CHAR(a.pol_seq_no, ''0000009''))
                                ||''-''||LTRIM(TO_CHAR(a.renew_no, ''09'')) policy_no1,
                           b.zone_no, b.zone_type, c.zone_grp zone_grp1, b.policy_id,c.zone_grp
                      FROM gipi_polbasic a, 
                           GIPI_FIRESTAT_EXTRACT_DTL b,'
                           || v_table || ' c,
                           giis_dist_share d
                     WHERE a.policy_id = b.policy_id
                       AND b.zone_type = ''' || p_zone_type ||
                      ''' AND b.zone_no = ' || v_column || 
                      ' AND b.share_cd = d.share_cd
                       AND d.share_cd = 999   
                       AND d.share_type = 3   
                       AND a.line_cd = d.line_cd
                       AND b.as_of_sw = ''' ||  p_as_of_sw ||  
                      ''' AND b.user_id = ''' || p_USER_id ||
                      ''' AND b.fi_item_grp IS NOT NULL
                       AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GIPIS901'',''' || p_user_id || ''') = 1 
                     GROUP BY a.line_cd,  a.subline_cd, a.iss_cd, a.issue_yy, 
                              a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                              c.zone_grp, b.policy_id
                     ORDER BY c.zone_grp';      
                       
         OPEN custom FOR v_query;
                   
         
         LOOP
            FETCH custom
             INTO rep.policy_no, rep.zone_no, rep.zone_type,
                  rep.zone_grp1, rep.policy_id, rep.zone_grp;
            
            rep.print_details   := 'Y';
            v_print             := true;
            
            IF rep.zone_grp = 1 THEN
                rep.cf_zone_grp := 'Zone A';
            ELSE
                rep.cf_zone_grp := 'Zone B';
            END IF;
            
            IF rep.policy_id IS NULL THEN
                v_print := false;
            END IF;
            
            /** Q_1 matrix query **/
            v_query2 := 'SELECT DISTINCT a.policy_id, b.zone_grp, a.zone_no, SUM(share_tsi_amt) Total_tsi, SUM( share_prem_amt) Total_prem
                          FROM GIPI_FIRESTAT_EXTRACT_DTL a, ' || 
                               v_table || ' b, 
                               giis_dist_share c, 
                               gipi_polbasic d
                         WHERE a.zone_no = ' || v_column || 
                           ' AND fi_item_grp IS NOT NULL
                           AND a.user_id =''' || p_USER_id ||
                           ''' AND a.share_cd = c.share_cd
                           AND c.share_cd = 999   
                           AND c.share_type = 3   
                        /*code below is added by Ladz 03262013*/
                           AND d.policy_id = a.policy_id
                           and c.line_cd = ''FI''
                        /*code below is added by Ladz 03262013*/
                           AND check_user_per_iss_cd2(d.line_cd, d.iss_cd, ''GIPIS901'', ''' || p_user_id || ''') = 1
                           AND a.policy_id = ''' || rep.policy_id ||
                       ''' AND a.zone_no = ''' || rep.zone_no ||
                    ''' GROUP BY a.policy_id,b.zone_grp, a.zone_no';
            
            OPEN custom2 FOR v_query2;
            
            LOOP
                FETCH custom2
                  INTO v_policy_id, v_zone_group, v_zone_no,
                       rep.total_tsi, rep.total_prem;
                        
                EXIT WHEN custom2%NOTFOUND;
                
            END LOOP;
         
            EXIT WHEN custom%NOTFOUND;
            
            PIPE ROW(rep);            
         END LOOP;
         
         CLOSE custom;            
         
         IF v_print = false THEN
            rep.print_details   := 'N';
            PIPE ROW(rep);
         END IF;
         
    END populate_main_report; 
    
    
    FUNCTION CF_BLDG_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        cnt             NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'B';
    BEGIN
        IF p_zone_type = 1 THEN          
            FOR a IN (SELECT 1
                         FROM gipi_polbasic a, 
                              GIPI_FIRESTAT_EXTRACT_DTL b,
                              GIIS_FLOOD_ZONE c,
                              GIIS_DIST_SHARE d
                        WHERE a.policy_id = b.policy_id
                          AND b.zone_type = p_zone_type
                          AND b.zone_no = FLOOD_ZONE
                          AND b.as_of_sw = p_as_of_sw
                          AND d.share_cd = b.share_cd
                          AND d.line_cd = a.line_cd
                          AND d.share_cd = 999    
                          AND d.share_type = 3    
                          AND b.user_id = P_USER_ID
                          AND b.fi_item_grp IS NOT NULL
                          AND b.fi_item_grp = v_fi_item_grp
                          /*added by Ladz 03262013*/     
                          AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', p_user_id) = 1
                        GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, 
                                 a.pol_seq_no,  a.renew_no, b.zone_no, b.zone_type,
                                 c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;         

        ELSIF p_zone_type = 2 THEN            
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_TYPHOON_ZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = TYPHOON_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/     
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1
                       GROUP BY a.line_cd, a.subline_cd, a.iss_cd,  a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;                         
        ELSE        
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_EQZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = EQ_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1
                       GROUP BY a.line_cd,  a.subline_cd,  a.iss_cd, a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;					 	
        END IF;	
        	  
        RETURN(cnt);
    END CF_BLDG_POL_CNT;
    
    
    FUNCTION CF_CONTENT_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        cnt             NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'C';
    BEGIN
        IF p_zone_type = 1 THEN          
            FOR a IN (SELECT 1
                         FROM gipi_polbasic a, 
                              GIPI_FIRESTAT_EXTRACT_DTL b,
                              GIIS_FLOOD_ZONE c,
                              GIIS_DIST_SHARE d
                        WHERE a.policy_id = b.policy_id
                          AND b.zone_type = p_zone_type
                          AND b.zone_no = FLOOD_ZONE
                          AND b.as_of_sw = p_as_of_sw
                          AND d.share_cd = b.share_cd
                          AND d.line_cd = a.line_cd
                          AND d.share_cd = 999    
                          AND d.share_type = 3    
                          AND b.user_id = P_USER_ID
                          AND b.fi_item_grp IS NOT NULL
                          AND b.fi_item_grp = v_fi_item_grp
                          /*added by Ladz 03262013*/     
                          AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', p_user_id) = 1
                        GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, 
                                 a.pol_seq_no,  a.renew_no, b.zone_no, b.zone_type,
                                 c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;         

        ELSIF p_zone_type = 2 THEN            
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_TYPHOON_ZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = TYPHOON_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/     
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1
                       GROUP BY a.line_cd, a.subline_cd, a.iss_cd,  a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;                         
        ELSE        
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_EQZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = EQ_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1
                       GROUP BY a.line_cd,  a.subline_cd,  a.iss_cd, a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;					 	
        END IF;	
        	  
        RETURN(cnt);
    END CF_CONTENT_POL_CNT;
    
    
    FUNCTION CF_LOSS_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        cnt             NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'L';
    BEGIN
        IF p_zone_type = 1 THEN          
            FOR a IN (SELECT 1
                         FROM gipi_polbasic a, 
                              GIPI_FIRESTAT_EXTRACT_DTL b,
                              GIIS_FLOOD_ZONE c,
                              GIIS_DIST_SHARE d
                        WHERE a.policy_id = b.policy_id
                          AND b.zone_type = p_zone_type
                          AND b.zone_no = FLOOD_ZONE
                          AND b.as_of_sw = p_as_of_sw
                          AND d.share_cd = b.share_cd
                          AND d.line_cd = a.line_cd
                          AND d.share_cd = 999    
                          AND d.share_type = 3    
                          AND b.user_id = P_USER_ID
                          AND b.fi_item_grp IS NOT NULL
                          AND b.fi_item_grp = v_fi_item_grp
                          /*added by Ladz 03262013*/     
                          AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', p_user_id) = 1
                        GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, 
                                 a.pol_seq_no,  a.renew_no, b.zone_no, b.zone_type,
                                 c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;         

        ELSIF p_zone_type = 2 THEN            
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_TYPHOON_ZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = TYPHOON_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/     
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1
                       GROUP BY a.line_cd, a.subline_cd, a.iss_cd,  a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;                         
        ELSE        
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_EQZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = EQ_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         AND b.fi_item_grp = v_fi_item_grp
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1
                       GROUP BY a.line_cd,  a.subline_cd,  a.iss_cd, a.issue_yy, 
                                a.pol_seq_no, a.renew_no, b.zone_no, b.zone_type,
                                c.zone_grp, b.policy_id
                       ORDER BY c.zone_grp) 
            LOOP
                cnt := cnt + 1;
            END LOOP;					 	
        END IF;	
        	  
        RETURN(cnt);
    END CF_LOSS_POL_CNT;
    
    
    FUNCTION CF_BLDG_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        tsi_amt         NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'B';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_tsi_amt)
			  INTO tsi_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(tsi_amt);
    END CF_BLDG_TSI_AMT;
    
    
    FUNCTION CF_CONTENT_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        tsi_amt         NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'C';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_tsi_amt)
			  INTO tsi_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999  
   			   AND d.share_type = 3 
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(tsi_amt);
    END CF_CONTENT_TSI_AMT;
    
    
    FUNCTION CF_LOSS_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        tsi_amt         NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'L';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_tsi_amt)
			  INTO tsi_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3  
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(tsi_amt);
    END CF_LOSS_TSI_AMT;
    
    
    FUNCTION CF_BLDG_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        prem_amt        NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'B';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_prem_amt)
			  INTO PREM_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(prem_amt);
    END CF_BLDG_PREM_AMT;
    
    
    FUNCTION CF_CONTENT_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        prem_amt        NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'C';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_prem_amt)
			  INTO prem_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(prem_amt);
    END CF_CONTENT_PREM_AMT;
    
    
    FUNCTION CF_LOSS_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        prem_amt        NUMBER := 0;
        v_fi_item_grp   VARCHAR2(1) := 'L';
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_prem_amt)
			  INTO prem_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL
			   AND b.fi_item_grp = v_fi_item_grp	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3  
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3  
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               AND b.fi_item_grp = v_fi_item_grp
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(prem_amt);
    END CF_LOSS_PREM_AMT;
    
    
    FUNCTION CF_GRND_BLDG_POL_CNT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        cnt NUMBER := 0;
    BEGIN
        IF p_zone_type = 1 THEN		
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_FLOOD_ZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = FLOOD_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1 
                       GROUP BY b.policy_id,fi_item_grp	
                             ) 
            LOOP
                cnt := cnt + 1;
            END LOOP;
            
        ELSIF	p_zone_type = 2 THEN    		
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_TYPHOON_ZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = TYPHOON_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1 							 
                       GROUP BY b.policy_id,fi_item_grp	) 
            LOOP
                cnt := cnt + 1;
            END LOOP;					 	
        ELSE		
            FOR a IN (SELECT 1
                        FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_EQZONE c,
                             GIIS_DIST_SHARE d
                       WHERE a.policy_id = b.policy_id
                         AND b.zone_type = p_zone_type
                         AND b.zone_no = EQ_ZONE
                         AND b.as_of_sw = p_as_of_sw
                         AND d.share_cd = b.share_cd
                         AND d.line_cd = a.line_cd
                         AND d.share_cd = 999 
                         AND d.share_type = 3 
                         AND b.user_id = P_USER_ID
                         AND b.fi_item_grp IS NOT NULL
                         /*added by Ladz 03262013*/	 
                         AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1 							 
                       GROUP BY b.policy_id,fi_item_grp	) 
            LOOP
                cnt := cnt + 1;
            END LOOP;					 	
        END IF;		  
        
	    return(cnt);
    END CF_GRND_BLDG_POL_CNT;
    
    
    FUNCTION CF_GRND_BLDG_TSI_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        tsi_amt     NUMBER := 0;
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_tsi_amt)
			  INTO tsi_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3  
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(tsi_amt);
    END CF_GRND_BLDG_TSI_AMT;
    
    
    FUNCTION CF_GRND_BLDG_PREM_AMT(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2    
    ) RETURN NUMBER
    AS
        prem_amt    NUMBER := 0;
    BEGIN
        IF p_zone_type = 1 THEN		
		    SELECT SUM(share_prem_amt)
			  INTO prem_amt
			  FROM gipi_polbasic a, 
			       GIPI_FIRESTAT_EXTRACT_DTL b,
			       GIIS_FLOOD_ZONE c,
			       GIIS_DIST_SHARE d
			 WHERE a.policy_id = b.policy_id
     		   AND b.zone_type = p_zone_type
			   AND b.zone_no = FLOOD_ZONE
			   AND b.as_of_sw = p_as_of_sw
			   AND d.share_cd = b.share_cd
			   AND d.line_cd = a.line_cd
			   AND d.share_cd = 999   
   			   AND d.share_type = 3   
			   AND b.user_id = P_USER_ID
		       AND b.fi_item_grp IS NOT NULL	
			  /*added by Ladz 03262013*/	 
			   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901', P_USER_ID) = 1;					 
        ELSIF p_zone_type = 2 THEN    		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_TYPHOON_ZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = TYPHOON_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL	
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;					 
        ELSE		
            SELECT SUM(share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, 
                   GIPI_FIRESTAT_EXTRACT_DTL b,
                   GIIS_EQZONE c,
                   GIIS_DIST_SHARE d
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = EQ_ZONE
               AND b.as_of_sw = p_as_of_sw
               AND d.share_cd = b.share_cd
               AND d.line_cd = a.line_cd
               AND d.share_cd = 999   
               AND d.share_type = 3   
               AND b.user_id = P_USER_ID
               AND b.fi_item_grp IS NOT NULL
               /*added by Ladz 03262013*/	 
               AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GIPIS901',P_USER_ID) = 1;						 
        END IF;		  
        
        return(prem_amt);
    END CF_GRND_BLDG_PREM_AMT;
    
    
    FUNCTION populate_recap(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,  
        p_user_id       VARCHAR2
    ) RETURN recap_tab PIPELINED
    AS
        rep     recap_type;
    BEGIN
         rep.cf_bldg_pol_cnt        := CF_BLDG_POL_CNT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_bldg_tsi_amt        := CF_BLDG_TSI_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_bldg_prem_amt       := CF_BLDG_PREM_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_content_pol_cnt     := CF_CONTENT_POL_CNT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_content_tsi_amt     := CF_CONTENT_TSI_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_content_prem_amt    := CF_CONTENT_PREM_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_loss_pol_cnt        := CF_LOSS_POL_CNT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_loss_tsi_amt        := CF_LOSS_TSI_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_loss_prem_amt       := CF_LOSS_PREM_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_grnd_bldg_pol_cnt   := CF_GRND_BLDG_POL_CNT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_grnd_bldg_tsi_amt   := CF_GRND_BLDG_TSI_AMT(p_zone_type, p_as_of_sw, p_user_id);
         rep.cf_grnd_bldg_prem_amt  := CF_GRND_BLDG_PREM_AMT(p_zone_type, p_as_of_sw, p_user_id);
         
         PIPE ROW(rep);
    END populate_recap;
    
    
    FUNCTION get_matrix_title(
        p_user_id   VARCHAR2
    ) RETURN matrix_title_tab PIPELINED
    AS
        rep     matrix_title_type;
    BEGIN
        FOR i IN  ( SELECT DISTINCT fi_item_grp dummy_cd, DECODE(fi_item_grp,'B','BUILDING','C','CONTENT','L','LOSS') fi_item_grp
                      FROM GIPI_FIRESTAT_EXTRACT_DTL a, gipi_polbasic b /*table added by Ladz 03262013*/
                     WHERE a.policy_id = b.policy_id /*added by Ladz 03262013*/
                       AND fi_item_grp IS NOT NULL
                       AND a.user_id = p_USER_id
                       AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GIPIS901', p_user_id) = 1 /*added by Ladz 03262013*/
                     ORDER BY fi_item_grp)
        LOOP
            rep.dummy_cd    := i.dummy_cd;
            rep.fi_item_grp := i.fi_item_grp;
            
            PIPE ROW(rep);
        END LOOP;
    END get_matrix_title;
    
    
    FUNCTION populate_matrix_details(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2,
        p_policy_id     GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type,
        p_zone_no       GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type
    ) RETURN matrix_details_tab PIPELINED
    AS
        TYPE cur_typ IS REF CURSOR;
         
        rep             matrix_details_type;
        custom          cur_typ;
        v_column        VARCHAR2 (50);
        v_table         VARCHAR2 (50);
        v_query         VARCHAR (10000);
        v_zone_grp      giis_flood_zone.zone_grp%TYPE;
        v_zone_no       GIPI_FIRESTAT_EXTRACT_DTL.ZONE_NO%type;
        v_policy_id     GIPI_FIRESTAT_EXTRACT_DTL.POLICY_ID%type;
        v_fi_item_grp   VARCHAR2(50);
    BEGIN
        IF p_zone_type = 1 THEN
             v_column := 'FLOOD_ZONE';
             v_table := 'GIIS_FLOOD_ZONE';
        ELSIF p_zone_type = 2 THEN
             v_column := 'TYPHOON_ZONE';
             v_table := 'GIIS_TYPHOON_ZONE';
        ELSE
             v_column := 'EQ_ZONE';
             v_table := 'GIIS_EQZONE';
        END IF;
         
        FOR i IN (SELECT DISTINCT policy_id, zone_grp, zone_no, zone_type,
                                  policy_no
                    FROM TABLE(GIPIR039G_PKG.POPULATE_MAIN_REPORT(p_zone_type, p_date, p_as_of_sw, 
                                                                  p_from_date, p_to_date, p_as_of_date, 
                                                                  p_user_id)) 
                   WHERE policy_id = p_policy_id
                     AND zone_no = p_zone_no)
        LOOP
            rep.policy_id := i.policy_id;
            rep.zone_grp := i.zone_grp;
            rep.zone_no := i.zone_no;
            rep.zone_type := i.zone_type;
            rep.policy_no := i.policy_no;
            
            FOR j IN (SELECT * 
                        FROM TABLE(GIPIR039G_PKG.GET_MATRIX_TITLE(p_user_id)) )
            LOOP
                rep.dummy_cd        := j.dummy_cd;
                rep.fi_item_grp     := j.fi_item_grp;
                
                v_query := 'SELECT DISTINCT b.zone_grp, a.zone_no, a.policy_id,a.fi_item_grp,
                                            SUM(share_tsi_amt) share_tsi, SUM(share_prem_amt) share_prem
                             FROM GIPI_FIRESTAT_EXTRACT_DTL a,'
                                  || v_table || ' b, 
                                  gipi_polbasic c ' ||
                             'WHERE a.zone_no = ' || v_column ||  
                              ' AND fi_item_grp IS NOT NULL
                              AND a.user_id = ''' || p_USER_id ||  
                              ''' AND A.share_cd = 999   
                               AND c.policy_id = a.policy_id                               
                               AND a.policy_id = ''' || i.policy_id ||  
                              ''' AND a.zone_no = ''' || i.zone_no ||  
                              ''' AND b.zone_grp = ''' || i.zone_grp || 
                              ''' AND a.fi_item_grp = ''' || j.fi_item_grp ||
                            ''' AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, ''GIPIS901'',''' || p_user_id ||''') = 1 /*added by Ladz 03262013*/
                              GROUP BY b.zone_grp, a.zone_no, a.policy_id,a.fi_item_grp';
                
                OPEN custom FOR v_query;
                
                LOOP
                    FETCH custom
                     INTO v_zone_grp, v_zone_no, v_policy_id, v_fi_item_grp,
                          rep.share_tsi, rep.share_prem;
                    
                    EXIT WHEN custom%NOTFOUND;
                    PIPE ROW(rep);
                END LOOP;
            END LOOP;
        END LOOP;
    END populate_matrix_details;
    
    
    FUNCTION get_matrix_subtotal(
        p_zone_type     VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2,
        p_zone_grp      GIIS_FLOOD_ZONE.ZONE_GRP%type
    ) RETURN matrix_subtotal_tab PIPELINED
    AS
        TYPE cur_typ IS REF CURSOR;
         
        rep             matrix_subtotal_type;
        custom          cur_typ;
        v_column        VARCHAR2 (50);
        v_table         VARCHAR2 (50);
        v_query         VARCHAR (10000);
    BEGIN
        IF p_zone_type = 1 THEN
             v_column := 'FLOOD_ZONE';
             v_table := 'GIIS_FLOOD_ZONE';
        ELSIF p_zone_type = 2 THEN
             v_column := 'TYPHOON_ZONE';
             v_table := 'GIIS_TYPHOON_ZONE';
        ELSE
             v_column := 'EQ_ZONE';
             v_table := 'GIIS_EQZONE';
        END IF;
        
        FOR i IN (SELECT DISTINCT zone_grp
                    FROM TABLE(GIPIR039G_PKG.POPULATE_MAIN_REPORT(p_zone_type, p_date, p_as_of_sw, 
                                                                  p_from_date, p_to_date, p_as_of_date, 
                                                                  p_user_id)) 
                   WHERE zone_grp = p_zone_grp)
        LOOP
            v_query := 'SELECT c.zone_grp,  b.fi_item_grp, SUM(share_tsi_amt) share_tsi_amt, SUM(share_prem_amt) share_prem_amt
                          FROM gipi_polbasic a, 
                               GIPI_FIRESTAT_EXTRACT_DTL b,' ||
                               v_table || ' c,
                               giis_dist_share d
                         WHERE a.policy_id = b.policy_id
                           AND b.zone_type = ''' || p_zone_type || '''
                           AND b.zone_no = ' || v_column || '''
                           AND b.share_cd = d.share_cd
                           AND d.share_cd = 999   
                           AND d.share_type = 3   
                           AND a.line_cd = d.line_cd
                           AND b.as_of_sw = ''' || p_as_of_sw || ''' 
                           AND b.user_id = ''' || P_USER_ID || '''
                            AND b.fi_item_grp IS NOT NULL
                           AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GIPIS901'',''' || P_USER_ID || ''') = 1 /*added by Ladz 03262013*/
                           AND c.zone_grp = ''' || i.zone_grp || '''
                         GROUP BY c.zone_grp, b.fi_item_grp
                         ORDER BY c.zone_grp';
            
            OPEN custom FOR v_query;
            
            LOOP
                FETCH custom
                 INTO rep.zone_grp, rep.fi_item_grp,
                      rep.zone_tot_tsi, rep.zone_tot_prem;
                 
                 
                EXIT WHEN custom%NOTFOUND;
                
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
    END get_matrix_subtotal;
    
    
    FUNCTION get_matrix_total(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,   
        p_user_id       VARCHAR2
    ) RETURN matrix_total_tab PIPELINED
    AS
        TYPE cur_typ IS REF CURSOR;
         
        rep             matrix_total_type;
        custom          cur_typ;
        v_column        VARCHAR2 (50);
        v_table         VARCHAR2 (50);
        v_query         VARCHAR (10000);
    BEGIN
        IF p_zone_type = 1 THEN
             v_column := 'FLOOD_ZONE';
             v_table := 'GIIS_FLOOD_ZONE';
        ELSIF p_zone_type = 2 THEN
             v_column := 'TYPHOON_ZONE';
             v_table := 'GIIS_TYPHOON_ZONE';
        ELSE
             v_column := 'EQ_ZONE';
             v_table := 'GIIS_EQZONE';
        END IF;
        
        v_query := 'SELECT SUM(share_tsi_amt), SUM(share_prem_amt)
                      FROM gipi_polbasic a, 
                           GIPI_FIRESTAT_EXTRACT_DTL b, ' ||
                           v_table || ' c,
                           GIIS_DIST_SHARE d
                     WHERE a.policy_id = b.policy_id
                       AND b.zone_type = ''' || p_zone_type || '''
                       AND b.zone_no = ' || v_column || ' 
                       AND b.share_cd = d.share_cd
                       AND d.share_cd = 999   
                       AND d.share_type = 3   
                       AND a.line_cd = d.line_cd
                       AND b.as_of_sw = ''' || p_as_of_sw || ''' 
                       AND b.user_id = ''' || p_USER_id || ''' 
                       AND b.fi_item_grp IS NOT NULL
                       AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GIPIS901'',''' ||p_USER_id || ''') = 1 /*added by Ladz 03262013*/
                     GROUP BY  b.zone_type, fi_item_grp
                     ORDER BY fi_item_grp';
            
        OPEN custom FOR v_query;
            
        LOOP
            FETCH custom
             INTO rep.zone_grnd_tot_tsi, rep.zone_grnd_tot_prem;
                 
                 
            EXIT WHEN custom%NOTFOUND;
                
            PIPE ROW(rep);
        END LOOP;
    
    END get_matrix_total;

END GIPIR039G_PKG;
/



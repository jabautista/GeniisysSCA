CREATE OR REPLACE PACKAGE BODY CPI.GIPIS213_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   10.18.2013
     ** Referenced By:  GIPIS213 - Cover Note Inquiry
     **/
     
    FUNCTION get_parlist_listing(
        p_date_type         VARCHAR2,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    ) RETURN parlist_tab PIPELINED
    AS
        TYPE cur_typ IS REF CURSOR;
        
        rec         parlist_type;
        custom      cur_typ;
        v_query     VARCHAR2(13767);
    BEGIN       
        v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                      FROM GIPI_PARLIST 
                     WHERE PAR_ID IS NULL';
                              
        IF p_date_type = '1' THEN       -- as of
            IF p_search_by = '1' /*OR p_search_by IS NULL*/ THEN   -- incept
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE TRUNC(INCEPT_DATE) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE TRUNC(INCEPT_DATE) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) )
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '2' THEN -- expiry
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE TRUNC(EXPIRY_DATE) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE TRUNC(EXPIRY_DATE) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) ) 
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '3' THEN -- cn printed
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE TRUNC(CN_DATE_PRINTED) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE TRUNC(CN_DATE_PRINTED) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) ) 
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '4' THEN -- cn expiry
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE TRUNC(COVERNOTE_EXPIRY) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                                WHERE (CN_DATE_PRINTED + CN_NO_OF_DAYS) <= nvl(TO_DATE( ''' || P_AS_OF_DATE || ''', ''MM-DD-RRRR''),SYSDATE) )  
                               AND par_status not in (98,99)';
            END IF;
            
        ELSIF p_date_type = '2' THEN    -- from
            IF p_search_by = '1' /*OR p_search_by IS NULL*/ THEN   -- incept
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE (TRUNC(INCEPT_DATE) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(INCEPT_DATE) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR'')) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE (TRUNC(INCEPT_DATE) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(INCEPT_DATE) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR'')) ) 
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '2' THEN -- expiry
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE (TRUNC(EXPIRY_DATE) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(EXPIRY_DATE) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR''))
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE (TRUNC(EXPIRY_DATE) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(EXPIRY_DATE) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR'')) )
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '3' THEN -- cn printed
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE (TRUNC(CN_DATE_PRINTED) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(CN_DATE_PRINTED) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR''))
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE (TRUNC(CN_DATE_PRINTED) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND TRUNC(CN_DATE_PRINTED) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR'')) )
                               AND par_status not in (98,99)';
            ELSIF p_search_by = '4' THEN -- cn expiry
                v_query := 'SELECT par_id, line_cd, iss_cd, par_yy, par_seq_no, par_status, assd_no, underwriter
                              FROM GIPI_PARLIST 
                             WHERE PAR_ID IN (SELECT PAR_ID 
                                                FROM GIPI_WPOLBAS 
                                               WHERE (TRUNC(COVERNOTE_EXPIRY) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'')
                                                      AND TRUNC(COVERNOTE_EXPIRY) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR'')) 
                                               UNION ALL 
                                              SELECT PAR_ID 
                                                FROM GIPI_POLBASIC 
                                               WHERE ((CN_DATE_PRINTED + CN_NO_OF_DAYS) >= TO_DATE(''' || P_FROM_DATE || ''', ''MM-DD-RRRR'') 
                                                      AND (CN_DATE_PRINTED + CN_NO_OF_DAYS) <= TO_DATE(''' || P_TO_DATE || ''', ''MM-DD-RRRR''))) 
                               AND par_status not in (98,99)';
            END IF;
        END IF;
        
        
        OPEN custom FOR v_query;
        
        LOOP
            FETCH custom
             INTO rec.par_id, rec.line_cd, rec.iss_cd, rec.par_yy, rec.par_seq_no, rec.par_status, rec.assd_no, rec.underwriter;
             
            rec.par_number      := rec.line_cd||'-'||rec.iss_cd||'-'||LTRIM(TO_CHAR(rec.par_yy, '09'))||'-'|| LTRIM(TO_CHAR(rec.par_seq_no, '099999'));
            rec.assd_name       := NULL;
            rec.address         := NULL;
            rec.cn_date_printed := NULL;
            rec.cn_expiry_date  := NULL;
            rec.prem_amt        := NULL;
            rec.incept_date     := NULL;
            rec.expiry_date     := NULL;
            rec.policy_no       := NULL;
            
            FOR a IN (select assd_name, mail_addr1||' '||mail_addr2||' '||mail_addr3 addr 
                        from giis_Assured 
                       where assd_no = rec.assd_no) 
            LOOP
                rec.assd_name   := a.assd_name;
                rec.address     := a.addr;
                EXIT;
            END LOOP;              
            
            IF rec.par_status = 10 THEN
                for b in (select cn_Date_Printed, cn_no_of_days, prem_amt, incept_date, expiry_date
	                        from gipi_Polbasic
	                       where par_id = rec.par_id)
	            loop 
                    rec.cn_date_printed := b.cn_date_Printed;
                    rec.cn_expiry_date  := (b.cn_date_printed + b.cn_no_of_days);
                    rec.prem_amt        := b.prem_amt;
                    rec.incept_date     := b.incept_date;
                    rec.expiry_date     := b.expiry_date;
                    exit;
                end loop;
                
                for d in (select endt_seq_no 
                            from gipi_polbasic
                           where par_id = rec.par_id)
                loop
                    if d.endt_seq_no = 0 then
                        for e in (select line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(issue_YY, '09'))||'-'||
                                         LTRIM(TO_CHAR(Pol_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(renew_NO, '09'))  policy_no
                                    from gipi_polbasic
                                   where par_id = rec.par_id)
                        loop
                            rec.policy_no := e. policy_no;
                            exit;
                        end loop;
                    else
                        for f in (select line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(issue_YY, '09'))||'-'||
                                         LTRIM(TO_CHAR(Pol_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(renew_NO, '09')) ||' / '||
                                         endt_iss_cd||'-'||LTRIM(TO_CHAR(endt_YY, '09'))||'-'||LTRIM(TO_CHAR(endt_SEQ_NO, '099999')) policy_no
                                    from gipi_polbasic
                                   where par_id = rec.par_id)
                         loop
                            rec.policy_no := f. policy_no;
                            exit;
                         end loop;
                    end if;       
                end loop;      
            ELSE
                for c in (select cn_Date_Printed, covernote_expiry, prem_amt, incept_date, expiry_date 
	        	            from gipi_wPolbas
	                       where par_id = rec.par_id)
                loop 
                    rec.cn_date_printed := c.cn_date_Printed;
                    rec.cn_expiry_date  := c.covernote_Expiry;
                    rec.prem_amt        := c.prem_amt;
                    rec.incept_date     := c.incept_date;
                    rec.expiry_date     := c.expiry_Date;
                    exit;
                end loop;
            END IF;
                    
        
            EXIT WHEN custom%NOTFOUND;
            
            PIPE ROW(rec);
        END LOOP;
        
        
    END get_parlist_listing;

END GIPIS213_PKG;
/



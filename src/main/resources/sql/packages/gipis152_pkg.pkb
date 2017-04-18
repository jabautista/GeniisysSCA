CREATE OR REPLACE PACKAGE BODY CPI.GIPIS152_PKG
AS

    FUNCTION get_user_listing(
        p_app_user       giis_users.user_id%TYPE
    )
        RETURN user_tab PIPELINED
    IS
        v_user  user_type;
    BEGIN
        FOR i IN(SELECT active_flag, comm_update_tag, all_user_sw, mgr_sw, user_id, user_name, user_grp, 
                        last_user_id, TO_CHAR(last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update, remarks
                   FROM giis_users a520
                  WHERE EXISTS (SELECT 1 
                                  FROM giis_user_grp_hdr 
                                 WHERE user_grp = a520.user_grp 
                                   AND check_user_per_iss_cd2(NULL, grp_iss_cd, 'GIPIS152', p_app_user) = 1)
               ORDER BY user_id, user_name, user_grp)
        LOOP    
            v_user.active_flag      := i.active_flag;
            v_user.comm_update_tag  := i.comm_update_tag;
            v_user.all_user_sw      := i.all_user_sw;
            v_user.mgr_sw           := i.mgr_sw;
            v_user.user_id          := i.user_id;
            v_user.user_name        := i.user_name;
            v_user.user_grp         := i.user_grp;
            v_user.last_user_id     := i.last_user_id;
            v_user.last_update      := i.last_update;
            v_user.remarks          := i.remarks;
            BEGIN
                SELECT user_grp_desc, grp_iss_cd
                  INTO v_user.user_grp_desc, v_user.grp_iss_cd
                  FROM giis_user_grp_hdr
                 WHERE user_grp = i.user_grp;
            END;
            PIPE ROW(v_user);
        END LOOP;
    END get_user_listing;

    FUNCTION get_tran_list(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN tran_tab PIPELINED
    IS
        v_tran tran_type;
    BEGIN
        FOR i IN(SELECT tran_cd, userid
                   FROM giis_user_tran
                  WHERE userid = p_user_id)
        LOOP
            v_tran.tran_cd := i.tran_cd;
            v_tran.tran_hdr_user_id := i.userid;
            BEGIN
                SELECT tran_desc
                  INTO v_tran.tran_desc
                  FROM giis_transaction
                 WHERE tran_cd = i.tran_cd;
            END;                
            v_tran.inc_all_tag := 'Y';
            FOR b IN (SELECT DISTINCT a.module_id
					    FROM giis_modules a, giis_modules_tran b
					   WHERE a.module_id = b.module_id
					     AND b.tran_cd = i.tran_cd
				    	 AND NOT EXISTS (SELECT module_id
						                     FROM giis_user_modules
											WHERE userid = i.userid
											  AND tran_cd = i.tran_cd
											  AND module_id IN (a.module_id))) 
            LOOP
                v_tran.inc_all_tag := 'N';
            END LOOP;						
            PIPE ROW(v_tran);
        END LOOP;
    END get_tran_list;
        
    FUNCTION get_tran_iss(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN iss_tab PIPELINED
    IS
        v_  iss_type;
    BEGIN
        FOR i IN(SELECT iss_cd
                   FROM giis_user_iss_cd
                  WHERE userid = p_user_id
                    AND tran_cd = p_tran_cd)
        LOOP
            v_.iss_cd := i.iss_cd;
            BEGIN
                SELECT iss_name
                  INTO v_.iss_name
                  FROM giis_issource
                 WHERE iss_cd = i.iss_cd;
            END;
            PIPE ROW(v_);
        END LOOP;
    END get_tran_iss;
        
    FUNCTION get_tran_line(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE
    )
         RETURN line_tab PIPELINED
    IS
        v_  line_type;
    BEGIN
        FOR i IN(SELECT line_cd
                   FROM giis_user_line
                  WHERE userid = p_user_id
                    AND tran_cd = p_tran_cd
                    AND iss_cd = p_iss_cd)
        LOOP
            v_.line_cd := i.line_cd;
            BEGIN
                SELECT line_name
                  INTO v_.line_name
                  FROM giis_line
                 WHERE line_cd = i.line_cd; 
            END;
            PIPE ROW(v_);
        END LOOP;
    END get_tran_line;         
    
    FUNCTION get_module_list(
        p_user_id       giis_users.user_id%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN modules_tab PIPELINED
    IS
        v_  modules_type;
    BEGIN
        FOR i IN(SELECT module_id
                   FROM giis_modules_tran
                  WHERE tran_cd = p_tran_cd)
        LOOP
            v_.module_id := i.module_id;
            FOR B IN (SELECT module_id, module_desc
                        FROM giis_modules
                       WHERE module_id = i.module_id)
            LOOP
                FOR a IN (SELECT gum.userid, gum.module_id, gum.user_id, TO_CHAR(gum.last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update, 
                                 gum.access_tag, gum.remarks, cg.rv_meaning
                            FROM giis_user_modules gum, cg_ref_codes cg
                           WHERE userid  = p_user_id
                             AND module_id = B.module_id
                             AND tran_cd = p_tran_cd
                             AND cg.rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
                             AND cg.rv_low_value = gum.access_tag) 
                LOOP
                    v_.mod_header_user_id   := a.userid;
                    v_.inc_tag              := 'Y';
                    v_.access_tag           := a.access_tag;
                    v_.access_tag_desc      := a.rv_meaning;
                    v_.mod_remarks          := a.remarks;
                    v_.mod_user_id          := a.user_id;        
                    v_.mod_last_update      := a.last_update;    
                END LOOP;             		  
                v_.module_desc     := b.module_desc;
             END LOOP;
            PIPE ROW(v_);
        END LOOP;
    END get_module_list;        
    
    FUNCTION get_tran_grp(
        p_user_grp        giis_users.user_grp%TYPE
    )
        RETURN grp_tran_tab PIPELINED
    IS
        v_  grp_tran_type;
    BEGIN
        FOR i IN(SELECT a.tran_cd, a.user_grp
                   FROM giis_user_grp_tran a
                  WHERE user_grp = p_user_grp
               ORDER BY (SELECT tran_desc
	                       FROM giis_transaction
	                      WHERE tran_cd = a.tran_cd),a.tran_cd)
        LOOP
            v_.tran_user_grp := i.user_grp;
            v_.tran_cd_grp   := i.tran_cd;
           
            BEGIN
                SELECT tran_desc
                  INTO v_.tran_desc_grp
                  FROM giis_transaction
                 WHERE tran_cd = i.tran_cd;
            END;
            PIPE ROW(v_);
        END LOOP;
    END get_tran_grp;        
    
    
    FUNCTION get_iss_grp(
        p_user_grp      giis_user_grp_tran.user_grp%TYPE,      
        p_tran_cd       giis_user_grp_tran.tran_cd%TYPE
    )
        RETURN grp_iss_tab PIPELINED
    IS
        v_  grp_iss_type;
    BEGIN
        FOR i IN(SELECT user_grp, iss_cd, tran_cd
                   FROM giis_user_grp_dtl
                  WHERE user_grp = p_user_grp 
                    AND tran_cd = p_tran_cd)
        LOOP
            v_.iss_user_grp    := i.user_grp;
            v_.iss_tran_cd_grp := i.tran_cd;
            v_.iss_cd_grp      := i.iss_cd;
            BEGIN
                SELECT iss_name
                  INTO v_.iss_name_grp
                  FROM giis_issource
                 WHERE iss_cd = i.iss_cd;
            END;
            PIPE ROW(v_);
        END LOOP;
    END get_iss_grp;        
    
    FUNCTION get_line_grp(
        p_user_grp      giis_user_grp_dtl.user_grp%TYPE,
        p_tran_cd       giis_user_grp_dtl.tran_cd%TYPE,
        p_iss_cd        giis_user_grp_dtl.iss_cd%TYPE
    )
        RETURN grp_line_tab PIPELINED
    IS
        v_  grp_line_type;
    BEGIN
        FOR i IN(SELECT line_cd, user_grp, tran_cd
                   FROM giis_user_grp_line
                  WHERE user_grp = p_user_grp 
                    AND tran_cd = p_tran_cd 
                    AND iss_cd = p_iss_cd)
        LOOP
            v_.line_cd_grp      := i.line_cd;
            v_.line_tran_cd_grp := i.tran_cd;
            v_.line_user_grp    := i.user_grp;
            BEGIN
                SELECT line_name, acct_line_cd
                  INTO v_.line_name_grp, v_.acct_line_cd_grp
                  FROM giis_line
                 WHERE line_cd = i.line_cd; 
            END;
            PIPE ROW(v_);
        END LOOP;
    END get_line_grp; 

    FUNCTION get_module_list_grp(
        p_user_grp      giis_user_grp_dtl.user_grp%TYPE,
        p_tran_cd       giis_user_tran.tran_cd%TYPE
    )
        RETURN modules_grp_tab PIPELINED
    IS
        v_  modules_grp_type;
    BEGIN
        FOR i IN(SELECT module_id
                   FROM giis_modules_tran
                  WHERE tran_cd = p_tran_cd)
        LOOP
            v_.module_id_grp := i.module_id;
            FOR B IN (SELECT module_id, module_desc
                        FROM giis_modules
                       WHERE module_id = i.module_id)
            LOOP
                FOR a IN (SELECT user_grp, module_id, user_id, last_update, remarks, access_tag
                              FROM GIIS_USER_GRP_MODULES
                             WHERE user_grp  = p_user_grp
                               AND module_id = b.module_id
                               AND tran_cd   = p_tran_cd)
                LOOP
                    v_.access_tag_grp  := a.access_tag;    
                    FOR c IN (SELECT rv_meaning
                                FROM cg_ref_codes
                               WHERE rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
                                 AND rv_low_value = a.access_tag)
                    LOOP
                        v_.access_tag_desc_grp := c.rv_meaning;
                    END LOOP;             	
                    v_.inc_tag_grp := 'Y';
                END LOOP;             		
                v_.module_desc_grp := b.module_desc;  
            END LOOP;
            PIPE ROW(v_);
        END LOOP;
    
    END get_module_list_grp;

    FUNCTION get_history_list(
        p_user_id      giis_users.user_id%TYPE
    )
        RETURN hist_tab PIPELINED
    IS
        v_  hist_type;
    BEGIN
        FOR i IN(SELECT userid, hist_id, old_user_grp, new_user_grp, 
                        TO_CHAR(last_update,'DD-MON-YYYY HH:MM:SS AM') last_update
                   FROM giis_user_grp_hist
                  WHERE userid = p_user_id)
        LOOP
            v_.hist_user_id     := i.userid;
            v_.hist_id          := i.hist_id;
            v_.old_user_grp     := i.old_user_grp;
            v_.new_user_grp     := i.new_user_grp;
            v_.hist_last_update := i.last_update;
            
            FOR a IN (SELECT user_grp, user_grp_desc 
                        FROM giis_user_grp_hdr)
            LOOP
                IF a.user_grp = i.old_user_grp THEN
                     v_.old_user_grp_desc := a.user_grp_desc;
                END IF;
                
                IF a.user_grp = i.new_user_grp THEN	              	
                     v_.new_user_grp_desc := a.user_grp_desc;
                END IF;
            END LOOP; 
            PIPE ROW(v_);
        END LOOP;
    END get_history_list;    
         
END GIPIS152_PKG;
/



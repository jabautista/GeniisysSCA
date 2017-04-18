CREATE OR REPLACE PACKAGE BODY CPI.GICLS182_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.26.2013
     ** Referenced By:  GICLS182 - Reserved/Advice Approval Limit Maintenance
     **/
     
    FUNCTION get_user_lov
        RETURN user_lov_tab PIPELINED
    AS
        lov     user_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_USERS
                   WHERE (check_user_access2('GICLS032',user_id) =1
                      OR check_user_access2('GICLS024',user_id) =1)
                     AND active_flag = 'Y'
                   ORDER BY user_id)
        LOOP
            lov.user_id     := i.user_id;
            lov.user_name   := i.user_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_user_lov;


    FUNCTION get_iss_lov(
        p_user_id   VARCHAR2
    ) RETURN iss_lov_tab PIPELINED
    AS
        lov     iss_lov_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM GIIS_ISSOURCE
                   --WHERE check_user_per_iss_cd2 (null, iss_cd, 'GICLS182', p_user_id) = 1)
                   WHERE check_user_per_iss_cd2 (null, iss_cd, 'GICLS032', p_user_id) = 1 --MODIFIED BY MJ FABROA 2014-10-31
                      OR check_user_per_iss_cd2 (null, iss_cd, 'GICLS024', p_user_id) = 1)

        LOOP
            lov.iss_cd      := i.iss_cd;
            lov.iss_name    := i.iss_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_iss_lov;
    
    
    FUNCTION get_rec_list(
        p_adv_user          GICL_ADV_LINE_AMT.ADV_USER%type,
        p_iss_cd            GICL_ADV_LINE_AMT.ISS_CD%type,
        p_app_user          VARCHAR2
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR h IN (SELECT *
                    FROM GIIS_LINE
                   --WHERE check_user_per_iss_cd2 (line_cd, p_iss_cd, 'GICLS182', p_app_user) = 1 --marco - 12.17.2014 - replaced with lines below
                   WHERE (check_user_per_iss_cd2 (line_cd, p_iss_cd, 'GICLS032', p_adv_user) = 1
                      OR check_user_per_iss_cd2 (line_cd, p_iss_cd, 'GICLS024', p_adv_user) = 1)
                     AND p_iss_cd IS NOT NULL
                   ORDER BY line_cd )
        LOOP
            rec.line_cd     := h.line_cd;
            rec.line_name   := h.line_name;
            
            BEGIN
                SELECT adv_user, iss_cd, all_amt_sw, range_to, all_res_amt_sw, res_range_to, user_id, TO_CHAR (last_update, 'MM-DD-YYYY HH:MI:SS AM')
                  INTO rec.adv_user, rec.iss_cd, rec.all_amt_sw, rec.range_to, rec.all_res_amt_sw, rec.res_range_to, rec.user_id, rec.last_update
                  FROM GICL_ADV_LINE_AMT
                 WHERE 1=1
                   AND adv_user = p_adv_user
                   AND iss_cd = p_iss_cd
                   AND line_cd = h.line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.adv_user        := null;
                    rec.iss_cd          := null;
                    rec.all_amt_sw      := null;
                    rec.range_to        := null;
                    rec.all_res_amt_sw  := null;
                    rec.res_range_to    := null;
                    rec.user_id         := null;
                    rec.last_update     := null;
            END;
           
            PIPE ROW(rec);
            
        END LOOP;
        
        /*FOR i IN (SELECT *
                    FROM GICL_ADV_LINE_AMT
                   WHERE adv_user = p_adv_user
                     AND iss_cd = p_iss_cd)
        LOOP
            rec.line_cd         := i.line_cd;
            rec.adv_user        := i.adv_user;
            rec.iss_cd          := i.iss_cd;
            rec.all_amt_sw      := i.all_amt_sw;
            rec.range_to        := i.range_to;
            rec.all_res_amt_sw  := i.all_res_amt_sw;
            rec.res_range_to    := i.res_range_to;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            SELECT line_name
              INTO rec.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
            
            PIPE ROW(rec);
        END LOOP;*/
    END get_rec_list;
    
    
    PROCEDURE set_rec (p_rec GICL_ADV_LINE_AMT%ROWTYPE)
    IS
    BEGIN
        MERGE INTO GICL_ADV_LINE_AMT
        USING DUAL
           ON (adv_user = p_rec.adv_user
               AND iss_cd = p_rec.iss_cd
               AND line_cd = p_rec.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (adv_user, iss_cd, line_cd, all_amt_sw, range_to, all_res_amt_sw, res_range_to, user_id, last_update)
            VALUES (p_rec.adv_user, p_rec.iss_cd, p_rec.line_cd, p_rec.all_amt_sw, p_rec.range_to, p_rec.all_res_amt_sw, 
                    p_rec.res_range_to, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET all_amt_sw       = p_rec.all_amt_sw,
                   range_to         = p_rec.range_to,
                   all_res_amt_sw   = p_rec.all_res_amt_sw, 
                   res_range_to     = p_rec.res_range_to, 
				   user_id          = p_rec.user_id, 
				   last_update       = SYSDATE
         ;
    END;
    
END GICLS182_PKG;
/



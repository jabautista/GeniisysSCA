CREATE OR REPLACE PACKAGE BODY CPI.GICL_ENGINEERING_DTL_PKG
AS

    /*
    **  Created by    : emman
    **  Date Created  : 09.06.2011
    **  Reference By  : (GICLS021 - Engineering Item Information)
    **  Description   : Gets the list of GICL_ENGINEERING_DTL records of specified claim id
    */
    FUNCTION get_gicl_engineering_dtl_list(p_claim_id       GICL_ENGINEERING_DTL.claim_id%TYPE)
      RETURN gicl_engineering_dtl_tab PIPELINED
    IS
        v_list      gicl_engineering_dtl_type;
    BEGIN
        FOR i IN (SELECT a.claim_id,    a.item_no,      a.item_title,       a.item_desc,
                         a.item_desc2,  a.currency_cd,  a.currency_rate,    a.region_cd,
                         a.province_cd, a.loss_date,    c.currency_desc,    b.region_desc,
                         d.province_desc
                    FROM GICL_ENGINEERING_DTL a, GIIS_REGION b, GIIS_CURRENCY c, GIIS_PROVINCE d
                   WHERE a.claim_id         = p_claim_id
                     AND a.currency_cd      = c.main_currency_cd (+)
                     AND a.region_cd        = b.region_cd (+)
                     AND a.region_cd        = d.region_cd (+)
                     AND a.province_cd      = d.province_cd (+))
        LOOP
            v_list.claim_id                 := i.claim_id;
            v_list.item_no                  := i.item_no;
            v_list.item_title               := i.item_title;
            v_list.item_desc                := i.item_desc;
            v_list.item_desc2               := i.item_desc2;
            v_list.currency_cd              := i.currency_cd;
            v_list.dsp_curr_desc            := i.currency_desc;
            v_list.currency_rate            := i.currency_rate;
            v_list.region_cd                := i.region_cd;
            v_list.dsp_region               := i.region_desc;
            v_list.province_cd              := i.province_cd;
            v_list.dsp_province             := i.province_desc;
            v_list.loss_date                := i.loss_date;
            v_list.loss_date_char           := TO_CHAR(i.loss_date, 'MM-DD-YYYY HH:MI AM'); 
            
            FOR c IN (SELECT DISTINCT item_title
                        FROM gipi_item
                       WHERE item_no = i.item_no 
                         AND policy_id IN (SELECT DISTINCT a.policy_id
                                             FROM gipi_polbasic a, gicl_claims b
                                            WHERE b.claim_id = p_claim_id
                                              AND a.line_cd = b.line_cd
                                              AND a.subline_cd = b.subline_cd
                                              AND a.pol_seq_no = b.pol_seq_no
                                              AND a.iss_cd = b.pol_iss_cd
                                              AND a.issue_yy = b.issue_yy
                                              AND a.renew_no = b.renew_no))
            LOOP
                v_list.dsp_item_title           := c.item_title;
            END LOOP;
            
            SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(v_list.item_no, v_list.claim_id)
              INTO v_list.gicl_item_peril_exist
              FROM dual;
              
             gicl_item_peril_pkg.validate_peril_reserve(v_list.item_no, 
                                                        v_list.claim_id, 
                                                        0, --belle grouped item no 02.13.2012
                                                        v_list.gicl_item_peril_msg);
        
            PIPE ROW(v_list);
        END LOOP;
    END get_gicl_engineering_dtl_list;
    
    /*
    **  Created by    : emman
    **  Date Created  : 09.06.2011
    **  Reference By  : (GICLS021 - Engineering Item Information)
    **  Description   : Loads all required items and records for Engineering Item Info page
    */
    PROCEDURE load_gicls021_items(p_claim_id                IN     GICL_ENGINEERING_DTL.claim_id%TYPE,
                                  p_control_claim_number       OUT VARCHAR2,
                                  p_control_policy_number      OUT VARCHAR2,
                                  p_control_dsp_line_cd        OUT GICL_CLAIMS.line_cd%TYPE,
                                  p_control_dsp_subline_cd     OUT GICL_CLAIMS.subline_cd%TYPE,
                                  p_control_dsp_iss_cd         OUT GICL_CLAIMS.iss_cd%TYPE,
                                  p_control_dsp_issue_yy       OUT GICL_CLAIMS.issue_yy%TYPE,
                                  p_control_dsp_pol_seq_no     OUT GICL_CLAIMS.pol_seq_no%TYPE,
                                  p_control_dsp_renew_no       OUT GICL_CLAIMS.renew_no%TYPE,
                                  p_control_dsp_pol_iss_cd     OUT GICL_CLAIMS.pol_iss_cd%TYPE,
                                  p_control_dsp_loss_date      OUT GICL_CLAIMS.dsp_loss_date%TYPE,
                                  p_control_loss_date          OUT GICL_CLAIMS.loss_date%TYPE,
                                  p_control_assured            OUT GICL_CLAIMS.assured_name%TYPE,
                                  p_control_loss_ctgry         OUT VARCHAR2,
                                  p_ctrl_expiry_date           OUT GICL_CLAIMS.expiry_date%TYPE,
                                  p_control_pol_eff_date       OUT GICL_CLAIMS.pol_eff_date%TYPE,
                                  p_control_claim_id           OUT GICL_CLAIMS.claim_id%TYPE,
                                  p_control_clm_stat_desc      OUT GIIS_CLM_STAT.clm_stat_desc%TYPE,
                                  p_control_loss_cat_cd        OUT GICL_CLAIMS.loss_cat_cd%TYPE,
                                  p_control_cat_peril_cd       OUT GIIS_LOSS_CTGRY.peril_cd%TYPE,
                                  p_max_record_allowed         OUT NUMBER)
    IS
    BEGIN
        -- load GICL_ENGINEERING_DTL records
        /*OPEN p_c034_list FOR
             SELECT * FROM TABLE(GICL_ENGINEERING_DTL_PKG.get_gicl_engineering_dtl_list(p_claim_id));*/
             
        -- load CONTROL items
        SELECT a.line_cd ||'-' || subline_cd ||'-'|| iss_cd ||'-'|| ltrim(to_char(clm_yy,'00')) ||'-'|| ltrim(to_char(clm_seq_no,'0000009')),
               a.line_cd ||'-' || subline_cd ||'-'|| pol_iss_cd ||'-'|| ltrim(to_char(issue_yy,'00')) ||'-'|| ltrim(to_char(pol_seq_no,'0000009'))  ||'-'||
                     ltrim(to_char(renew_no,'00')),
               a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy,
               a.pol_seq_no, a.renew_no, a.pol_iss_cd,
               a.dsp_loss_date, a.loss_date, a.assured_name,
               b.loss_cat_cd ||'-'|| b.loss_cat_des,
               a.expiry_date,
               a.pol_eff_date, a.claim_id, c.clm_stat_desc,
               a.loss_cat_cd, b.peril_cd
          INTO p_control_claim_number, p_control_policy_number,
               p_control_dsp_line_cd, p_control_dsp_subline_cd, p_control_dsp_iss_cd, 
               p_control_dsp_issue_yy, p_control_dsp_pol_seq_no, p_control_dsp_renew_no, 
               p_control_dsp_pol_iss_cd,
               p_control_dsp_loss_date, p_control_loss_date, p_control_assured,
               p_control_loss_ctgry,
               p_ctrl_expiry_date,
               p_control_pol_eff_date, p_control_claim_id, p_control_clm_stat_desc,
               p_control_loss_cat_cd,p_control_cat_peril_cd
          FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
         WHERE a.loss_cat_cd = b.loss_cat_cd
           AND a.clm_stat_cd = c.clm_stat_cd
           AND a.line_cd	= b.line_cd
           AND a.claim_id 	= p_claim_id;
           
        -- get maximum allowable record
        p_max_record_allowed := 0;
        
        FOR item IN (SELECT DISTINCT (b.item_no) item_no 
                       FROM gipi_polbasic a, gipi_item b 
                      WHERE a.line_cd = p_control_dsp_line_cd 
                        AND a.subline_cd = p_control_dsp_subline_cd 
                        AND a.iss_cd = p_control_dsp_iss_cd 
                        AND a.issue_yy = p_control_dsp_issue_yy 
                        AND a.pol_seq_no = p_control_dsp_pol_seq_no 
                        AND a.renew_no = p_control_dsp_renew_no 
                        AND a.pol_flag in ('1','2','3', 'X') 
                        AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_control_pol_eff_date, a.eff_date )) 
                                  <= TRUNC(p_control_loss_date)
                        AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date,p_ctrl_expiry_date,a.endt_expiry_date)) >= TRUNC(p_control_loss_date)
                        AND a.policy_id = b.policy_id)
        LOOP
            p_max_record_allowed := p_max_record_allowed + 1;
        END LOOP;
        
    END load_gicls021_items;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.29.2011   
    **  Reference By : (GICLS021 - Claims Engineering Item Information)
    **  Description  : insert/update records in gicl_engineering_dtl table 
    */    
    PROCEDURE set_gicl_engineering_dtl(
        p_claim_id          GICL_ENGINEERING_DTL.claim_id%TYPE,
        p_item_no           GICL_ENGINEERING_DTL.item_no%TYPE,
        p_currency_cd       GICL_ENGINEERING_DTL.currency_cd%TYPE,
        p_item_title        GICL_ENGINEERING_DTL.item_title%TYPE,
        p_item_desc         GICL_ENGINEERING_DTL.item_desc%TYPE,
        p_item_desc2        GICL_ENGINEERING_DTL.item_desc2%TYPE,
        p_cpi_rec_no        GICL_ENGINEERING_DTL.cpi_rec_no%TYPE,
        p_cpi_branch_cd     GICL_ENGINEERING_DTL.cpi_branch_cd%TYPE,
        p_region_cd         GICL_ENGINEERING_DTL.region_cd%TYPE,
        p_province_cd       GICL_ENGINEERING_DTL.province_cd%TYPE,
        p_currency_rate     GICL_ENGINEERING_DTL.currency_rate%TYPE
        ) IS
      v_loss_date             gicl_claims.dsp_loss_date%TYPE;
    BEGIN
        FOR date IN (SELECT dsp_loss_date
		               FROM gicl_claims
		              WHERE claim_id = p_claim_id) LOOP
          v_loss_date := date.dsp_loss_date;
        END LOOP;
    
        MERGE INTO gicl_engineering_dtl
             USING dual
                ON (claim_id = p_claim_id
               AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT(claim_id, item_no, currency_cd, user_id,
                   last_update, item_title, item_desc, item_desc2,
                   cpi_rec_no, cpi_branch_cd, loss_date, region_cd,
                   province_cd, currency_rate)
            VALUES(p_claim_id, p_item_no, p_currency_cd, giis_users_pkg.app_user,
                   sysdate, p_item_title, p_item_desc, p_item_desc2,
                   p_cpi_rec_no, p_cpi_branch_cd, v_loss_date, p_region_cd,
                   p_province_cd, p_currency_rate)
        WHEN MATCHED THEN
            UPDATE 
               SET  currency_cd           = p_currency_cd,
                    user_id               = giis_users_pkg.app_user,
                    last_update           = sysdate,
                    item_title            = p_item_title,
                    item_desc             = p_item_desc,
                    item_desc2            = p_item_desc2,
                    cpi_rec_no            = p_cpi_rec_no,
                    cpi_branch_cd         = p_cpi_branch_cd,
                    loss_date             = v_loss_date,
                    region_cd             = p_region_cd,
                    province_cd           = p_province_cd,
                    currency_rate         = p_currency_rate;                    
    END;
    
   /*
   **  Created by    : Emman
   **  Date Created  : 09.29.2011
   **  Reference By  : (GICLS021 - Claim Engineering Item Information)
   **  Description   :  delete record in gicl_engineering_dtl 
   */  
    PROCEDURE del_gicl_engineering_dtl(
        p_claim_id      gicl_engineering_dtl.claim_id%TYPE,
        p_item_no       gicl_engineering_dtl.item_no%TYPE
        ) IS
    BEGIN
        DELETE FROM gicl_engineering_dtl
         WHERE claim_id = p_claim_id 
           AND item_no  = p_item_no;
    END;
    
    /*
    **  Created by    : Emman
    **  Date Created  : 09.30.2011
    **  Reference By  : (GICLS021 - Engineering Item Information)
    **  Description   : Execute extract_engr_data
    */  
    PROCEDURE extract_engr_data(
            p_line_cd               gipi_polbasic.line_cd%TYPE,
            p_subline_cd            gipi_polbasic.subline_cd%TYPE,
            p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
            p_issue_yy              gipi_polbasic.issue_yy%TYPE,
            p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
            p_renew_no              gipi_polbasic.renew_no%TYPE,
            p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
            p_expiry_date           gipi_polbasic.expiry_date%TYPE,
            p_loss_date             gipi_polbasic.expiry_date%TYPE,
            p_item_no               gipi_item.item_no%TYPE,
            p_claim_id              gicl_claims.claim_id%type,
            c034            IN OUT  gicl_engineering_dtl_pkg.gicl_engineering_dtl_type
            ) IS
      v_currency_cd         gipi_item.currency_cd%TYPE;
      v_currency_desc       giis_currency.currency_desc%TYPE;
      v_currency_rt         gipi_item.currency_rt%TYPE;
      v_region_cd           gipi_location.region_cd%TYPE;
      v_region_desc         giis_region.region_desc%TYPE;
      v_province_cd         gipi_location.province_cd%TYPE;
      v_province_desc       giis_province.province_desc%TYPE;
      v_max_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE  := 0;
      v_item_desc           gipi_item.item_desc%TYPE;
      v_item_desc2          gipi_item.item_desc2%TYPE;
      v_item_title          gipi_item.item_title%TYPE;
    BEGIN
    -------------------------------------------------
    --first get info. from policy and all valid endt.
    -------------------------------------------------
    FOR c1 IN (
      SELECT nvl(endt_seq_no,0) endt_seq_no, c.currency_cd, e.currency_desc, d.region_cd, d.province_cd,
             c.item_desc, c.item_desc2, c.currency_rt  
      FROM  gipi_polbasic b, gipi_item c, gipi_location d, giis_currency e 
      WHERE --p_claim_id = p_claim_id AND
            p_line_cd = b.line_cd 
        AND p_subline_cd = b.subline_cd 
        AND p_pol_iss_cd = b.iss_cd 
        AND c.item_no = p_item_no 
        AND p_issue_yy = b.issue_yy 
        AND p_pol_seq_no = b.pol_seq_no 
        AND p_renew_no = b.renew_no 
        AND b.policy_id = c.policy_id 
        AND c.currency_cd = e.main_currency_cd 
        AND c.policy_id = d.policy_id(+)
        AND c.item_no = d.item_no(+)
        AND b.pol_flag IN ('1','2','3','X')
        AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date), p_pol_eff_date, b.eff_date )) 
            <= TRUNC(p_loss_date)
        --AND TRUNC(b.eff_date)   <= p_loss_date
        AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
            b.expiry_date,p_expiry_date,b.endt_expiry_date))  
             >= TRUNC(p_loss_date)
       ORDER BY eff_date ASC) LOOP
      v_max_endt_seq_no := nvl(c1.endt_seq_no,0);
      v_currency_cd      := NVL(c1.currency_cd, v_currency_cd);
      v_currency_desc     := NVL(c1.currency_desc, v_currency_desc);
      v_currency_rt      := NVL(c1.currency_rt, v_currency_rt);
      v_region_cd          := NVL(c1.region_cd, v_region_cd);
      v_province_cd      := NVL(c1.province_cd, v_province_cd);
      v_item_desc         := NVL(c1.item_desc, v_item_desc);
      v_item_desc2          := NVL(c1.item_desc2, v_item_desc2);
    END LOOP;

    ------------------------------
    --get info from backward endt.
    ------------------------------

    FOR c2 IN (
      SELECT c.currency_cd, e.currency_desc, c.currency_rt, d.region_cd, d.province_cd, c.item_desc, c.item_desc2  
      FROM  gipi_polbasic b, gipi_item c, gipi_location d, giis_currency e 
      WHERE --p_claim_id = p_claim_id AND
            p_line_cd = b.line_cd 
        AND p_subline_cd = b.subline_cd 
        AND p_pol_iss_cd = b.iss_cd 
        AND c.item_no = p_item_no 
        AND p_issue_yy = b.issue_yy 
        AND p_pol_seq_no = b.pol_seq_no 
        AND p_renew_no = b.renew_no 
        AND b.policy_id = c.policy_id 
        AND c.currency_cd = e.main_currency_cd 
        AND c.policy_id = d.policy_id(+)
        AND c.item_no = d.item_no(+)
        AND NVL(b.back_stat,5) = 2
        AND b.pol_flag IN ('1','2','3','X')
        AND endt_seq_no > v_max_endt_seq_no
        --AND TRUNC(b.eff_date)   <= p_loss_date
        AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date), p_pol_eff_date, b.eff_date )) 
            <= TRUNC(p_loss_date)
        AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
            b.expiry_date,p_expiry_date,b.endt_expiry_date))  
            >= TRUNC(p_loss_date)
      ORDER BY endt_seq_no ASC) LOOP
      v_currency_cd     := NVL(c2.currency_cd, v_currency_cd);
      v_currency_desc    := NVL(c2.currency_desc, v_currency_desc);
      v_currency_rt     := NVL(c2.currency_rt, v_currency_rt);
      v_region_cd          := NVL(c2.region_cd, v_region_cd);
      v_province_cd      := NVL(c2.province_cd, v_province_cd);
      v_item_desc         := NVL(c2.item_desc, v_item_desc);
      v_item_desc2          := NVL(c2.item_desc2, v_item_desc2);

    END LOOP;
    FOR c IN (SELECT DISTINCT item_title FROM gipi_item
           WHERE item_no = p_item_no 
                 AND policy_id IN (SELECT DISTINCT a.policy_id
                     FROM gipi_polbasic a, gicl_claims b
                    WHERE b.claim_id = p_claim_id AND
                          a.line_cd = b.line_cd
                      AND a.subline_cd = b.subline_cd
                      AND a.pol_seq_no = b.pol_seq_no
                      AND a.iss_cd = b.pol_iss_cd
                      AND a.issue_yy = b.issue_yy
                      AND a.renew_no = b.renew_no)) LOOP
             v_item_title := c.item_title;
    END LOOP;

    FOR c IN (select region_desc
                from giis_region
               where region_cd = v_region_cd) LOOP
        v_region_desc := c.region_desc;
    END LOOP;


    FOR c IN (select province_desc
                from giis_province
               where region_cd = v_region_cd
                 and province_cd = v_province_cd) LOOP
        v_province_desc := c.province_desc;
    END LOOP;

    c034.item_no                 := p_item_no;
    c034.item_title              := v_item_title;
    c034.dsp_item_title          := v_item_title;
    c034.item_desc               := v_item_desc;
    c034.item_desc2              := v_item_desc2;
    c034.currency_cd             := v_currency_cd;
    c034.dsp_curr_desc           := v_currency_desc;
    c034.currency_rate           := v_currency_rt;
    c034.region_cd               := v_region_cd;
    c034.dsp_region              := v_region_desc;
    c034.province_cd             := v_province_cd;
    c034.dsp_province            := v_province_desc;
    c034.loss_date               := p_loss_date;

    END;
    
   /*
   **  Created by    : Emman
   **  Date Created  : 09.30.2011
   **  Reference By  : (GICLS021 - Engineering Item Information)
   **  Description   : Get the gicl_engineering_dtls per claim number 
   */  
    FUNCTION get_gicl_engineering_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
          p_claim_id              gicl_claims.claim_id%type)
    RETURN gicl_engineering_dtl_tab PIPELINED IS
      c034            gicl_engineering_dtl_type;
    BEGIN                          
        GICL_ENGINEERING_DTL_PKG.extract_engr_data(p_line_cd, p_subline_cd, p_pol_iss_cd, 
                          p_issue_yy, p_pol_seq_no, p_renew_no, 
                          p_pol_eff_date, p_expiry_date, p_loss_date, 
                          p_item_no,p_claim_id, c034);
        
        PIPE ROW(c034);                                        
    RETURN;
    END;
    
   /*
   **  Created by   :  Emman
   **  Date Created :  09.30.2011   
   **  Reference By : (GICLS021 - Claims Engineering Item Information)
   **  Description  : check item_no if exist
   */
    FUNCTION check_engineering_item_no (
        p_claim_id        gicl_engineering_dtl.claim_id%TYPE,
        p_item_no         gicl_engineering_dtl.item_no%TYPE,
        p_start_row       VARCHAR2,
        p_end_row         VARCHAR2
    ) 
    RETURN VARCHAR2 IS
        v_exist   VARCHAR2 (1);
    BEGIN
        BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_engineering_dtl_pkg.get_gicl_engineering_dtl_list(p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_exist := 'N';
        END;
        RETURN v_exist;
    END;
    
    /*
   **  Created by    : Emman
   **  Date Created  : 09.30.2011
   **  Reference By  : (GICLS021 - Engineering Item Information)
   **  Description   : validate item no. 
   */     
    PROCEDURE validate_gicl_engineering_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        p_claim_id              gicl_fire_dtl.claim_id%TYPE,
        p_from                  VARCHAR2,
        p_to                    VARCHAR2,
        c014                OUT GICL_ENGINEERING_DTL_PKG.gicl_engineering_dtl_cur,
        p_item_exist        OUT NUMBER,
        p_override_fl       OUT VARCHAR2,
        p_tloss_fl          OUT VARCHAR2,
        p_item_exist2       OUT VARCHAR2
        ) IS
    BEGIN
        SELECT gicl_engineering_dtl_pkg.check_engineering_item_no(p_claim_id,p_item_no, p_from, p_to) 
          INTO p_item_exist2
          FROM dual;
    
        SELECT Giac_Validate_User_Fn(giis_users_pkg.app_user, 'TL', 'GICLS021')
          INTO p_override_fl
          FROM dual;
        
        SELECT GIPI_ITEM_PKG.check_existing_item(
			    p_line_cd, p_subline_cd, p_pol_iss_cd, 
				p_issue_yy, p_pol_seq_no, p_renew_no, 
				p_pol_eff_date, p_expiry_date, p_loss_date,
                p_item_no
				) 
          INTO p_item_exist      
		  FROM dual;
    
        SELECT Check_Total_Loss_Settlement2(
                    0, NULL, p_item_no, 
                    p_line_cd, p_subline_cd, p_pol_iss_cd,
                    p_issue_yy, p_pol_seq_no, p_renew_no, 
                    p_loss_date, p_pol_eff_date, p_expiry_date)
          INTO p_tloss_fl          
          FROM dual;           

        OPEN c014 FOR
            SELECT * 
              FROM TABLE(GICL_ENGINEERING_DTL_PKG.get_gicl_engineering_dtl(
                            p_line_cd, p_subline_cd, p_pol_iss_cd, 
                            p_issue_yy, p_pol_seq_no, p_renew_no,
                            p_pol_eff_date, p_expiry_date, p_loss_date, 
                            p_incept_date, p_item_no,p_claim_id)
                        );
    END;

END GICL_ENGINEERING_DTL_PKG;
/



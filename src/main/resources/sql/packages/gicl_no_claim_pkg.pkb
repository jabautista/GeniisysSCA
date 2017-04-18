CREATE OR REPLACE PACKAGE BODY CPI.gicl_no_claim_pkg
AS
    
   /**
    **  Created by      : Niknok Orio 
    **  Date Created    : 10.19.2011 
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  check_no_claim program unit       
    **/ 
    PROCEDURE check_no_claim(
        p_line_cd                    IN     GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd                 IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd                 IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy                   IN     GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no                 IN     GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no                   IN     GIPI_POLBASIC.renew_no%TYPE, 
        p_dsp_loss_date              IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_time                       IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_msg_alert                 OUT     VARCHAR2
        ) IS
      v_clmid            NUMBER;
      v_alert            NUMBER;
      EXISTING_CLAIM    VARCHAR2(200);
    BEGIN
      IF p_time IS NOT NULL THEN
         FOR i IN (SELECT nc_iss_cd || ' -' || to_char(nc_issue_yy,'0009') || ' -' || 
                          to_char(nc_seq_no,'0999999') clm_no, no_claim_id
                     FROM gicl_no_claim
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND issue_yy = to_number(p_issue_yy)
                      AND pol_seq_no = to_number(p_pol_seq_no)
                      AND renew_no = to_number(p_renew_no)
                      AND to_char(nc_loss_date, 'MM-DD-RRRR') = to_char(p_dsp_loss_date,'MM-DD-RRRR')
                      AND to_char(nc_loss_date,'HH:MI AM') = to_char(p_time, 'HH:MI AM')) 
         LOOP
             v_clmiD := i.no_claim_id;
             EXISTING_CLAIM := i.clm_no;
         END LOOP;
         
         IF v_clmid IS NOT NULL THEN 
            p_msg_alert := 'NO-CLAIM Number '||EXISTING_CLAIM||' exists for this policy. Do you want to continue?'; 
         END IF;
         
      ELSIF p_time IS NULL THEN
         FOR i IN (SELECT nc_iss_cd || ' -' || to_char(nc_issue_yy,'0009') || ' -' || 
                          to_char(nc_seq_no,'0999999') clm_no, no_claim_id
                     FROM gicl_no_claim
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND issue_yy = to_number(p_issue_yy)
                      AND pol_seq_no = to_number(p_pol_seq_no)
                      AND renew_no = to_number(p_renew_no)
                      AND to_char(nc_loss_date, 'MM-DD-RRRR') = to_char(p_dsp_loss_date,'MM-DD-RRRR'))
         LOOP
             v_clmid := i.no_claim_id;
             EXISTING_CLAIM := i.clm_no;
         END LOOP;
         
         IF v_clmid IS NOT NULL THEN 
            p_msg_alert := 'NO-CLAIM Number '||EXISTING_CLAIM||' exists for this policy. Do you want to continue?'; 
         END IF;
      END IF; 
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.08.2011 
    **  Reference By    : (GICLS026 - No Claim Listing)
    **  Description     :  retrieves no claim listing      
    */ 
    FUNCTION get_no_claim_listing(
        p_assd_name     gicl_no_claim.assd_name%TYPE,
        p_nc_iss_cd     gicl_no_claim.nc_iss_cd%TYPE,
        p_nc_issue_yy   gicl_no_claim.nc_issue_yy%TYPE,
        p_nc_seq_no     gicl_no_claim.nc_seq_no%TYPE,
        p_line_cd       gicl_no_claim.line_cd%TYPE,
        p_subline_cd    gicl_no_claim.subline_cd%TYPE,
        p_iss_cd        gicl_no_claim.iss_cd%TYPE,
        p_issue_yy      gicl_no_claim.issue_yy%TYPE,
        p_pol_seq_no    gicl_no_claim.pol_seq_no%TYPE,
        p_renew_no      gicl_no_claim.renew_no%TYPE,
		p_user_id       GIIS_USERS.user_NAME%TYPE --added by steven 11.16.2012
    )
    RETURN no_claim_listing_tab PIPELINED
    IS
        v_no_claim      no_claim_listing_type;
    BEGIN
        FOR a IN (SELECT no_claim_id, nc_iss_cd||' - '||TO_CHAR(nc_issue_yy,'0009')||
               ' - '||TO_CHAR(nc_seq_no,'0999999') no_claim_no, line_cd||' - '||subline_cd||
               ' - '||iss_cd||' - '||TO_CHAR(issue_yy,'09')||' - '||TO_CHAR(pol_seq_no,'0999999')||
               ' - '||TO_CHAR(renew_no,'09') policy_no, assd_name, eff_date, expiry_date
                    FROM gicl_no_claim
                  WHERE CHECK_USER_PER_ISS_CD2(line_cd,iss_cd,'GICLS026',p_user_id) = 1 --added by steven 11.15.2012 base on SR 0011277
                     AND UPPER (assd_name) LIKE UPPER (NVL (p_assd_name, assd_name))    -- changed = to LIKE shan 10.11.2013
                     AND UPPER (nc_iss_cd) LIKE UPPER (NVL (p_nc_iss_cd, nc_iss_cd))    -- changed = to LIKE shan 10.11.2013
                     AND nc_issue_yy = NVL (p_nc_issue_yy, nc_issue_yy)
                     AND nc_seq_no = NVL (p_nc_seq_no, nc_seq_no)
                     AND UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, line_cd))          -- changed = to LIKE shan 10.11.2013
                     AND UPPER (subline_cd) LIKE UPPER (NVL (p_subline_cd, subline_cd)) -- changed = to LIKE shan 10.11.2013
                     AND UPPER (iss_cd) LIKE UPPER (NVL (p_iss_cd, iss_cd))             -- changed = to LIKE shan 10.11.2013
                     AND issue_yy = NVL (p_issue_yy, issue_yy)
                     AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                     AND renew_no = NVL (p_renew_no, renew_no))
        LOOP
          v_no_claim.no_claim_id    := a.no_claim_id;  
          v_no_claim.no_claim_no    := a.no_claim_no;
          v_no_claim.policy_no      := a.policy_no;
          v_no_claim.assd_name      := a.assd_name;
          v_no_claim.eff_date       := a.eff_date;
          v_no_claim.expiry_date    := a.expiry_date;
          PIPE ROW (v_no_claim);
        END LOOP;
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.12.2011 
    **  Reference By    : (GICLS026 - No Claim Listing)
    **  Description     :  retrieves no claim certificate details      
    */ 
    FUNCTION get_no_claim_details(
        p_no_claim_id   gicl_no_claim.no_claim_id%TYPE
    )
    RETURN gicl_no_claim_tab PIPELINED
    IS
        v_no_claim      gicl_no_claim_type;
    BEGIN
        FOR a IN (SELECT * FROM gicl_no_claim
                   WHERE no_claim_id = p_no_claim_id)
        LOOP
          v_no_claim.no_claim_id    := a.no_claim_id;
          v_no_claim.line_cd        := a.line_cd;
          v_no_claim.subline_cd     := a.subline_cd;
          v_no_claim.iss_cd         := a.iss_cd;
          v_no_claim.issue_yy       := a.issue_yy;
          v_no_claim.pol_seq_no     := a.pol_seq_no;
          v_no_claim.renew_no       := a.renew_no;
          v_no_claim.item_no        := a.item_no;
          v_no_claim.assd_no        := a.assd_no;
          v_no_claim.assd_name      := a.assd_name;
          v_no_claim.eff_date       := a.eff_date;
          v_no_claim.expiry_date    := a.expiry_date;
          v_no_claim.nc_issue_date  := a.nc_issue_date;
          v_no_claim.nc_type_cd     := a.nc_type_cd;
          v_no_claim.model_year     := a.model_year;
          v_no_claim.make_cd        := a.make_cd;
          v_no_claim.item_title     := a.item_title;
          v_no_claim.motor_no       := a.motor_no;
          v_no_claim.serial_no      := a.serial_no;
          v_no_claim.plate_no       := a.plate_no;
          v_no_claim.basic_color_cd := a.basic_color_cd;
          v_no_claim.color_cd       := a.color_cd;
          v_no_claim.amount         := a.amount;
          v_no_claim.cpi_rec_no     := a.cpi_rec_no;
          v_no_claim.cpi_branch_cd  := a.cpi_branch_cd;
          v_no_claim.user_id        := a.user_id;
          v_no_claim.last_update    := a.last_update;
          v_no_claim.print_tag      := a.print_tag;
          v_no_claim.location       := a.location;
          v_no_claim.nc_loss_date   := a.nc_loss_date;
          v_no_claim.cancel_tag     := a.cancel_tag;
          v_no_claim.nc_seq_no      := a.nc_seq_no;
          v_no_claim.nc_iss_cd      := a.nc_iss_cd;
          v_no_claim.nc_issue_yy    := a.nc_issue_yy;
          v_no_claim.remarks        := a.remarks;
          v_no_claim.motcar_comp_cd := a.motcar_comp_cd;
          v_no_claim.no_claim_no    := a.nc_iss_cd||' - '||TO_CHAR(a.nc_issue_yy,'0009')||' - '||TO_CHAR(a.nc_seq_no,'0999999');
          v_no_claim.policy_no      := a.line_cd||' - '||a.subline_cd||' - '||a.iss_cd||' - '||TO_CHAR(a.issue_yy,'09')||' - '||
                                       TO_CHAR(a.pol_seq_no,'0999999')||' - '||TO_CHAR(a.renew_no,'09');
          v_no_claim.line_cd_mc     := giisp.v('LINE_CODE_MC');
          
           BEGIN
            SELECT a.car_company, b.make
              INTO v_no_claim.car_company, v_no_claim.make
              FROM giis_mc_car_company a, giis_mc_make b 
             WHERE a.car_company_cd = b.car_company_cd
               AND a.car_company_cd = a.motcar_comp_cd
               AND b.make_cd        = a.make_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;

          BEGIN
            SELECT c.basic_color, c.color
              INTO v_no_claim.basic_color, v_no_claim.color
              FROM giis_mc_color c 
             WHERE c.basic_color_cd = a.basic_color_cd
               AND c.color_cd       = a.color_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
          
          BEGIN
            SELECT menu_line_cd 
              INTO v_no_claim.menu_line_cd
              FROM giis_line
             WHERE line_cd = a.line_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
            
          PIPE ROW (v_no_claim);
        END LOOP;
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.13.2011 
    **  Reference By    : (GICLS026 - No Claim Listing)
    **  Description     :  get_details program unit      
    */ 
    PROCEDURE get_details_gicls026(
        p_line_cd       IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no      IN gipi_polbasic.renew_no%TYPE,
        p_nc_loss_date  IN gipi_polbasic.eff_date%TYPE,
        p_assd_no      OUT gipi_polbasic.assd_no%TYPE,
        p_assd_name    OUT giis_assured.assd_name%TYPE,
        p_expiry_date  OUT VARCHAR2,
        p_eff_date     OUT VARCHAR2       
    )
    IS
        v_assd_no           gipi_polbasic.assd_no%TYPE;
        v_assd_name         giis_assured.assd_name%TYPE;
        v_incept_date       gipi_polbasic.incept_date%TYPE;
        v_expiry_date       gipi_polbasic.expiry_date%TYPE;
        v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE;
    BEGIN
      --get_assured(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no);
      BEGIN
        SELECT b.assd_no,a.assd_name
          INTO v_assd_no,v_assd_name
          FROM gipi_polbasic b,giis_assured a
         WHERE b.assd_no         = a.assd_no
           AND b.renew_no        = p_renew_no
           AND b.pol_seq_no      = p_pol_seq_no
           AND b.issue_yy        = p_issue_yy
           AND b.iss_cd          = p_iss_cd
           AND b.subline_cd      = p_subline_cd
           AND b.line_cd         = p_line_cd
           AND b.eff_date        = (SELECT MAX(c.eff_date)
                                      FROM gipi_polbasic c
                                     WHERE c.renew_no        = b.renew_no
                                       AND c.pol_seq_no      = b.pol_seq_no
                                       AND c.issue_yy        = b.issue_yy
                                       AND c.iss_cd          = b.iss_cd
                                       AND c.subline_cd      = b.subline_cd
                                       AND c.line_cd         = b.line_cd
                                       AND c.assd_no IS NOT NULL);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      --get_inc_date; -- get effectivity (incept) date
      BEGIN
        -- get first the effectivity date of the policy
          FOR A1 IN
            (SELECT incept_date
               FROM gipi_polbasic
              WHERE line_cd    = p_line_cd
                AND subline_cd = p_subline_cd
                AND iss_cd     = p_iss_cd
                AND issue_yy   = p_issue_yy
                AND pol_seq_no = p_pol_seq_no
                AND renew_no   = p_renew_no
                AND pol_flag IN ('1','2','3','X')
                AND NVL(endt_seq_no,0) = 0)
          LOOP
            v_incept_date  := a1.incept_date;
            EXIT;
          END LOOP;
          -- then check and retrieve for any change of incept in case there is
          -- endorsement of incept date
          FOR B1 IN
            (SELECT incept_date, endt_seq_no
               FROM gipi_polbasic
              WHERE line_cd            = p_line_cd
                AND subline_cd         = p_subline_cd
                AND iss_cd             = p_iss_cd
                AND issue_yy           = p_issue_yy
                AND pol_seq_no         = p_pol_seq_no
                AND renew_no           = p_renew_no
                AND pol_flag           IN ('1','2','3','X')
                AND eff_date           <= NVL(p_nc_loss_date,sysdate)
                AND NVL(endt_seq_no,0) > 0
                AND incept_date        <> v_incept_date
                AND expiry_date         = endt_expiry_date
              ORDER BY eff_date DESC, endt_seq_no DESC)
          LOOP
            v_incept_date := b1.incept_date;
            --check for change in expiry using backward endt.
            FOR C IN
              (SELECT incept_date
                 FROM gipi_polbasic
                WHERE line_cd              = p_line_cd
                  AND subline_cd           = p_subline_cd
                  AND iss_cd               = p_iss_cd
                  AND issue_yy             = p_issue_yy
                  AND pol_seq_no           = p_pol_seq_no
                  AND renew_no             = p_renew_no
                  AND pol_flag             IN ('1','2','3','X')
                  AND eff_date             <= NVL(p_nc_loss_date,sysdate)
                  AND NVL(endt_seq_no,0)   > 0
                  AND incept_date          <> b1.incept_date
                  AND expiry_date          = endt_expiry_date
                  AND NVL(back_stat,5)     = 2
                  AND NVL(endt_seq_no,0)   > b1.endt_seq_no
                ORDER BY endt_seq_no DESC)
            LOOP
              v_incept_date := c.incept_date;
              EXIT;
            END LOOP;
            EXIT;
          END LOOP;
      END;
        
      --get_exp_date; -- get expiry date
      BEGIN
        -- get first the expiry_date of the policy
          FOR p IN
            (SELECT expiry_date
               FROM gipi_polbasic
              WHERE line_cd    = p_line_cd
                AND subline_cd = p_subline_cd
                AND iss_cd     = p_iss_cd
                AND issue_yy   = p_issue_yy
                AND pol_seq_no = p_pol_seq_no
                AND renew_no   = p_renew_no
                AND pol_flag   IN ('1','2','3','X')
                AND NVL(endt_seq_no,0) = 0)
          LOOP
            v_expiry_date := p.expiry_date;
            -- then check and retrieve for any change of expiry in case there is
            -- endorsement of expiry date
            FOR i IN
              (SELECT expiry_date, endt_seq_no
                 FROM gipi_polbasic
                WHERE line_cd            = p_line_cd
                  AND subline_cd         = p_subline_cd
                  AND iss_cd             = p_iss_cd
                  AND issue_yy           = p_issue_yy
                  AND pol_seq_no         = p_pol_seq_no
                  AND renew_no           = p_renew_no
                  AND pol_flag           IN ('1','2','3','X')
                  AND eff_date           <= NVL(p_nc_loss_date, SYSDATE)
                  AND NVL(endt_seq_no,0) > 0
                  AND expiry_date        <> p.expiry_date
                  AND expiry_date        = endt_expiry_date
                ORDER BY eff_date DESC)
            LOOP
              v_expiry_date := i.expiry_date;
              v_max_endt_seq := i.endt_seq_no;
              --check if changes again occured in expiry date
              FOR c IN
                (SELECT expiry_date, endt_seq_no
                   FROM gipi_polbasic
                  WHERE line_cd            = p_line_cd
                    AND subline_cd         = p_subline_cd
                    AND iss_cd             = p_iss_cd
                    AND issue_yy           = p_issue_yy
                    AND pol_seq_no         = p_pol_seq_no
                    AND renew_no           = p_renew_no
                    AND pol_flag           IN ('1','2','3','X')
                    AND eff_date           <= NVL(p_nc_loss_date, SYSDATE)
                    AND NVL(endt_seq_no,0) > i.endt_seq_no
                    AND expiry_date        <> p.expiry_date
                    AND expiry_date        = endt_expiry_date
                  ORDER BY eff_date DESC)
              LOOP
                v_expiry_date := c.expiry_date;
                v_max_endt_seq := c.endt_seq_no;
                EXIT;
              END LOOP; 
             --check for change in expiry using backward endt.
              FOR s IN
                (SELECT expiry_date
                   FROM gipi_polbasic
                  WHERE line_cd            = p_line_cd
                    AND subline_cd         = p_subline_cd
                    AND iss_cd             = p_iss_cd
                    AND issue_yy           = p_issue_yy
                    AND pol_seq_no         = p_pol_seq_no
                    AND renew_no           = p_renew_no
                    AND pol_flag           IN ('1','2','3','X')
                    AND eff_date           <= NVL(p_nc_loss_date, SYSDATE)
                    AND NVL(endt_seq_no,0) > 0
                    AND expiry_date        <> p.expiry_date
                    AND expiry_date        = endt_expiry_date
                    AND NVL(back_stat,5)   = 2
                    AND NVL(endt_seq_no,0) > v_max_endt_seq
                  ORDER BY endt_seq_no DESC)
              LOOP
                v_expiry_date := s.expiry_date;
                EXIT;
              END LOOP;
              EXIT;
            END LOOP;
          END LOOP;
      END;
          p_assd_no      := v_assd_no;
          p_assd_name    := v_assd_name;
          p_expiry_date  := TO_CHAR(v_expiry_date,'MM-DD-YYYY  HH24:MI:SS');
          p_eff_date     := TO_CHAR(v_incept_date,'MM-DD-YYYY  HH24:MI:SS');
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.16.2011 
    **  Reference By    : (GICLS026 - No Claim Listing)
    **  Description     : insert new gicl_no_claim record      
    */ 
    PROCEDURE insert_new_record_gicls026(
        p_line_cd            IN   GICL_NO_CLAIM.line_cd%TYPE,
        p_subline_cd         IN   GICL_NO_CLAIM.subline_cd%TYPE, 
        p_iss_cd             IN   GICL_NO_CLAIM.iss_cd%TYPE, 
        p_issue_yy           IN   GICL_NO_CLAIM.issue_yy%TYPE, 
        p_pol_seq_no         IN   GICL_NO_CLAIM.pol_seq_no%TYPE,
        p_renew_no           IN   GICL_NO_CLAIM.renew_no%TYPE, 
        p_item_no            IN   GICL_NO_CLAIM.item_no%TYPE, 
        p_assd_no            IN   GICL_NO_CLAIM.assd_no%TYPE, 
        p_assd_name          IN   GICL_NO_CLAIM.assd_name%TYPE, 
        p_eff_date           IN   GICL_NO_CLAIM.eff_date%TYPE, 
        p_expiry_date        IN   GICL_NO_CLAIM.expiry_date%TYPE,
        p_model_year         IN   GICL_NO_CLAIM.model_year%TYPE, 
        p_make_cd            IN   GICL_NO_CLAIM.make_cd%TYPE, 
        p_item_title         IN   GICL_NO_CLAIM.item_title%TYPE, 
        p_motor_no           IN   GICL_NO_CLAIM.motor_no%TYPE,
        p_serial_no          IN   GICL_NO_CLAIM.serial_no%TYPE, 
        p_plate_no           IN   GICL_NO_CLAIM.plate_no%TYPE, 
        p_basic_color_cd     IN   GICL_NO_CLAIM.basic_color_cd%TYPE, 
        p_color_cd           IN   GICL_NO_CLAIM.color_cd%TYPE, 
        p_amount             IN   GICL_NO_CLAIM.amount%TYPE, 
        p_user_id            IN   GICL_NO_CLAIM.user_id%TYPE, 
        p_location           IN   GICL_NO_CLAIM.location%TYPE, 
        --p_nc_loss_date       IN   GICL_NO_CLAIM.nc_loss_date%TYPE, 
        p_nc_loss_date       IN   VARCHAR2,
        p_cancel_tag         IN   GICL_NO_CLAIM.cancel_tag%TYPE, 
        p_remarks            IN   GICL_NO_CLAIM.remarks%TYPE, 
        p_motcar_comp_cd     IN   GICL_NO_CLAIM.motcar_comp_cd%TYPE,
        v_no_claim_id       OUT   GICL_NO_CLAIM.no_claim_id%TYPE,
        p_msg               OUT   VARCHAR2
    )
    IS
        v_nc_iss_cd     GICL_NO_CLAIM.nc_iss_cd%TYPE;
        v_nc_issue_yy   GICL_NO_CLAIM.nc_issue_yy%TYPE  := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
        v_nc_seq_no     GICL_NO_CLAIM.nc_seq_no%TYPE;
        v_iss_cd_ho     GIIS_ISSOURCE.iss_cd%TYPE;
        v_incept_date   GICL_NO_CLAIM.eff_date%TYPE;
        v_expiry_date   GICL_NO_CLAIM.expiry_date%TYPE;
        v_max_endt_seq  GIPI_POLBASIC.endt_seq_no%TYPE;
        v_nc_loss_date  GICL_NO_CLAIM.nc_loss_date%TYPE;
    BEGIN
    
        BEGIN
            SELECT NVL(MAX(NVL(NO_CLAIM_ID,0)),0) + 1
              INTO v_no_claim_id
              FROM GICL_NO_CLAIM;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_no_claim_id := 1;
        END;
        
        FOR get_value IN(
                SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'ISS_CD_HO')
        LOOP
            v_iss_cd_ho := get_value.param_value_v;
        END LOOP;
        IF v_iss_cd_ho IS NULL THEN
            p_msg := 'Parameter ISS_CD_HO is not existing in table giis_parameters.';
            RETURN;   
        END IF;    
    
        IF p_iss_cd = 'RI' THEN 
             v_nc_iss_cd := p_iss_cd;
        ELSE
          IF GIACP.V('USE_BRANCH_CODE') ='Y' THEN
             SELECT param_value_v
               INTO v_nc_iss_cd
               FROM giac_parameters
              WHERE param_name = 'BRANCH_CD';
          ELSE 
             IF GIACP.V('BRANCH_CD') = v_iss_cd_ho THEN
                FOR get_claim_cd IN(
                     SELECT NVL(claim_branch_cd, iss_cd) branch_cd
                       FROM giis_issource
                      WHERE iss_cd = p_iss_cd)
                LOOP
                  v_nc_iss_cd := get_claim_cd.branch_cd;
                END LOOP;
             ELSE
               v_nc_iss_cd := p_iss_cd;
             END IF; 
          END IF;
        END IF;
          
        BEGIN
            SELECT NVL(MAX(nvl(NC_SEQ_NO,0)),0) + 1
              INTO v_nc_seq_no
              FROM GICL_NO_CLAIM
             WHERE NC_ISS_CD   = v_nc_iss_cd
               AND NC_ISSUE_YY = v_nc_issue_yy;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_nc_seq_no := 1;
        END;
        
        BEGIN
            FOR A1 IN(SELECT incept_date
                        FROM GIPI_POLBASIC
                       WHERE line_cd = p_line_cd
                         AND subline_cd = p_subline_cd
                         AND iss_cd = p_iss_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         AND pol_flag IN ('1','2','3','X')
                         AND NVL(endt_seq_no,0) = 0)
            LOOP
                v_incept_date := A1.incept_date;
                EXIT;
            END LOOP;
            
            FOR B1 IN(SELECT incept_date, endt_seq_no
                        FROM GIPI_POLBASIC
                       WHERE line_cd = p_line_cd
                         AND subline_cd = p_subline_cd
                         AND iss_cd = p_iss_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         AND pol_flag IN ('1','2','3','X')
                         AND eff_date <= SYSDATE
                         AND NVL(endt_seq_no,0) > 0
                         AND incept_date <> v_incept_date
                         AND expiry_date = endt_expiry_date
                       ORDER BY eff_date DESC, endt_seq_no DESC)
            LOOP
                v_incept_date := B1.incept_date;
                FOR C IN(SELECT incept_date
                           FROM GIPI_POLBASIC
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no
                            AND pol_flag IN ('1','2','3','X')
                            AND eff_date <= SYSDATE
                            AND NVL(endt_seq_no,0) > 0
                            AND incept_date <> B1.incept_date
                            AND expiry_date = endt_expiry_date
                            AND NVL(back_stat,5) = 2
                            AND NVL(endt_seq_no,0) > B1.endt_seq_no
                         ORDER BY endt_seq_no DESC)
                LOOP
                    v_incept_date := c.incept_date;
                    EXIT;
                END LOOP;
                EXIT;
            END LOOP;
        END;
        
        BEGIN
            FOR p IN(SELECT expiry_date
                       FROM GIPI_POLBASIC
                      WHERE line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                        AND iss_cd = p_iss_cd
                        AND issue_yy = p_issue_yy
                        AND pol_seq_no = p_pol_seq_no
                        AND renew_no = p_renew_no
                        AND pol_flag IN ('1','2','3','X')
                        AND NVL(endt_seq_no,0) = 0)
            LOOP
                v_expiry_date := p.expiry_date;
                FOR i IN(SELECT expiry_date, endt_seq_no
                           FROM GIPI_POLBASIC
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no
                            AND pol_flag IN ('1','2','3','X')
                            AND eff_date <= SYSDATE
                            AND NVL(endt_seq_no,0) > 0
                            AND expiry_date <> p.expiry_date
                            AND expiry_date = endt_expiry_date
                          ORDER BY eff_date DESC)
                LOOP
                    v_expiry_date := i.expiry_date;
                    v_max_endt_seq := i.endt_seq_no;
                    FOR c IN(SELECT expiry_date, endt_seq_no
                               FROM GIPI_POLBASIC
                              WHERE line_cd = p_line_cd
                                AND subline_cd = p_subline_cd
                                AND iss_cd = p_iss_cd
                                AND issue_yy = p_issue_yy
                                AND pol_seq_no = p_pol_seq_no
                                AND renew_no = p_renew_no
                                AND pol_flag IN ('1','2','3','X')
                                AND eff_date <= SYSDATE
                                AND NVL(endt_seq_no,0) > i.endt_seq_no
                                AND expiry_date <> p.expiry_date
                                AND expiry_date = endt_expiry_date
                              ORDER BY eff_date DESC)
                    LOOP
                        v_expiry_date := c.expiry_date;
                        v_max_endt_seq := c.endt_seq_no;
                        EXIT;
                    END LOOP;
                     
                    FOR s IN(SELECT expiry_date
                               FROM GIPI_POLBASIC
                              WHERE line_cd = p_line_cd
                                AND subline_cd = p_subline_cd
                                AND iss_cd = p_iss_cd
                                AND issue_yy = p_issue_yy
                                AND pol_seq_no = p_pol_seq_no
                                AND renew_no = p_renew_no
                                AND pol_flag IN ('1','2','3','X')
                                AND eff_date <= SYSDATE
                                AND NVL(endt_seq_no,0) > 0
                                AND expiry_date <> p.expiry_date
                                AND expiry_date = endt_expiry_date
                                AND NVL(back_stat,5) = 2
                                AND NVL(endt_seq_no,0) > v_max_endt_seq
                              ORDER BY endt_seq_no DESC)
                    LOOP
                        v_expiry_date := s.expiry_date;
                        EXIT;
                    END LOOP;
                    EXIT;
                END LOOP;
            END LOOP;
        END;
		
        BEGIN
            SELECT TO_DATE(p_nc_loss_date, 'MM-DD-YYYY HH:MI AM')
              INTO v_nc_loss_date
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        
        INSERT INTO gicl_no_claim(no_claim_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                                  renew_no, item_no, assd_no, assd_name, eff_date, expiry_date, 
                                  nc_issue_date, model_year, make_cd, item_title, motor_no,
                                  serial_no, plate_no, basic_color_cd, color_cd, amount, user_id, 
                                  last_update, location, nc_loss_date, cancel_tag, nc_seq_no, nc_iss_cd,
                                  nc_issue_yy, remarks, motcar_comp_cd)
                           VALUES(v_no_claim_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
                                  p_renew_no, p_item_no, p_assd_no, p_assd_name, v_incept_date, v_expiry_date, 
                                  SYSDATE, p_model_year, p_make_cd, p_item_title, p_motor_no,
                                  p_serial_no, p_plate_no, p_basic_color_cd, p_color_cd, p_amount, p_user_id, 
                                  SYSDATE, p_location, v_nc_loss_date, p_cancel_tag, v_nc_seq_no, v_nc_iss_cd,
                                  v_nc_issue_yy, p_remarks, p_motcar_comp_cd);
    END;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.28.2011 
    **  Reference By    : (GICLS026 - No Claim Listing)
    **  Description     : determine the signatory      
    */ 
    PROCEDURE get_signatory(
        p_report_id     IN giac_documents.report_id%TYPE,
        p_iss_cd        IN giac_documents.branch_cd%TYPE,
        p_line_cd       IN giac_documents.line_cd%TYPE,
        p_msg          OUT VARCHAR2
    )
    IS
        v_signatory       giis_signatory_names.signatory%TYPE;
    BEGIN
        FOR z IN (SELECT b.item_no, b.label, c.signatory, c.designation
                      FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                     WHERE a.report_no    = b.report_no
                       AND b.signatory_id = c.signatory_id
                       AND a.report_id    = p_report_id
                       AND a.branch_cd    = p_iss_cd--IS NULL
                       AND a.line_cd      = p_line_cd--IS NULL
                     ORDER BY b.item_no ASC)
        LOOP
            v_signatory   := z.signatory;
            EXIT;
        END LOOP;            
        
        IF v_signatory IS NULL THEN
            FOR z IN (SELECT b.item_no, b.label, c.signatory, c.designation
                          FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                         WHERE a.report_no    = b.report_no
                           AND b.signatory_id = c.signatory_id
                           AND a.report_id    = p_report_id
                           AND a.branch_cd    = p_iss_cd
                           AND a.line_cd     IS NULL
                         ORDER BY b.item_no ASC)
            LOOP
                v_signatory   := z.signatory;
                EXIT;
            END LOOP;            
        END IF;
        
        IF v_signatory IS NULL THEN
            FOR z IN (SELECT b.item_no, b.label, c.signatory, c.designation
                          FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                         WHERE a.report_no    = b.report_no
                           AND b.signatory_id = c.signatory_id
                           AND a.report_id    = p_report_id
                           AND a.branch_cd   IS NULL
                           AND a.line_cd      = p_line_cd
                         ORDER BY b.item_no ASC)
            LOOP
                v_signatory   := z.signatory;
                EXIT;
            END LOOP;            
        END IF;
        
        IF v_signatory IS NULL THEN
            FOR z IN (SELECT b.item_no, b.label, c.signatory, c.designation
                          FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                         WHERE a.report_no    = b.report_no
                           AND b.signatory_id = c.signatory_id
                           AND a.report_id    = p_report_id
                           AND a.branch_cd   IS NULL
                           AND a.line_cd     IS NULL
                         ORDER BY b.item_no ASC)
            LOOP
                v_signatory   := z.signatory;
                EXIT;
            END LOOP;            
        END IF;
        
        IF v_signatory IS NULL THEN
		    p_msg := 'No signatories maintained in GICLS181 for report id '||p_report_id||'.';		
	    END IF;	
    END;

END gicl_no_claim_pkg;
/



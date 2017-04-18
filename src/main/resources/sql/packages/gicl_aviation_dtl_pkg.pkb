CREATE OR REPLACE PACKAGE BODY CPI.gicl_aviation_dtl_pkg
AS
   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  10.05.2011
   **  Reference By : (GICLS020- Claims Aviation Item Information)
   **  Description  : Retrieves the Aviation Item Info
   */
   FUNCTION get_aviation_dtl_item (p_claim_id gicl_cargo_dtl.claim_id%TYPE)
      RETURN gicl_aviation_dtl_tab PIPELINED
   IS
      v_item   gicl_aviation_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_aviation_dtl
                 WHERE claim_id = p_claim_id)
      LOOP
         v_item.claim_id := i.claim_id;
         v_item.item_no := i.item_no;
         v_item.user_id := i.user_id;
         v_item.item_title := i.item_title;
         v_item.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY HH:MI AM'); -- added time : shan 04.15.2014
         v_item.currency_cd := i.currency_cd;
         v_item.last_update := i.last_update;
         v_item.cpi_rec_no := i.cpi_rec_no;
         v_item.cpi_branch_cd := i.cpi_branch_cd;
         v_item.vessel_cd := i.vessel_cd;
         v_item.total_fly_time := i.total_fly_time;
         v_item.qualification := i.qualification;
         v_item.purpose := i.purpose;
         v_item.geog_limit := i.geog_limit;
         v_item.deduct_text := i.deduct_text;
         v_item.rec_flag := i.rec_flag;
         v_item.fixed_wing := i.fixed_wing;
         v_item.rotor := i.rotor;
         v_item.prev_util_hrs := i.prev_util_hrs;
         v_item.est_util_hrs := i.est_util_hrs;
         v_item.currency_rate := i.currency_rate;

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_item.item_desc, v_item.item_desc2
              FROM gicl_clm_item
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND item_no = v_item.item_no
               AND grouped_item_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item.item_desc := NULL;
               v_item.item_desc2 := NULL;
         END;

         BEGIN
            SELECT a.vessel_name, a.rpc_no,
                   b.air_desc
              INTO v_item.dsp_vessel_name, v_item.dsp_rpc_no,
                   v_item.dsp_air_type
              FROM giis_vessel a, giis_air_type b
             WHERE a.air_type_cd = b.air_type_cd
               AND a.vessel_cd = v_item.vessel_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item.dsp_vessel_name := NULL;
               v_item.dsp_rpc_no := NULL;
               v_item.dsp_air_type := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               v_item.dsp_vessel_name := NULL;
               v_item.dsp_rpc_no := NULL;
               v_item.dsp_air_type := NULL;
         END;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_item.currency_cd)
         LOOP
            v_item.dsp_currency_desc := c.currency_desc;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (v_item.item_no,
                                                               v_item.claim_id
                                                              )
           INTO v_item.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (v_item.item_no,
                                                             v_item.claim_id
                                                            )
           INTO v_item.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve
                                                   (v_item.item_no,
                                                    v_item.claim_id,
                                                    0, --belle grouped item no 02.13.2012
                                                    v_item.gicl_item_peril_msg
                                                   );
         PIPE ROW (v_item);
      END LOOP;
   END;

      /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  10.11.11
   **  Reference By : (GICLS020- Claims Aviatiojn Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_aviation_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_incept_date             gipi_polbasic.incept_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_claim_id                gicl_aviation_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c033             IN OUT   gicl_aviation_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE
   )
   IS
   BEGIN
      SELECT gicl_aviation_dtl_pkg.check_aviation_item_no (p_claim_id,
                                                           p_item_no,
                                                           p_from,
                                                           p_to
                                                          )
        INTO p_item_exist2
        FROM DUAL;

      SELECT giac_validate_user_fn (giis_users_pkg.app_user, 'TL', 'GICLS015')
        INTO p_override_fl
        FROM DUAL;

      SELECT gipi_item_pkg.check_existing_item (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_pol_eff_date,
                                                p_expiry_date,
                                                p_loss_date,
                                                p_item_no
                                               )
        INTO p_item_exist
        FROM DUAL;

      SELECT check_total_loss_settlement2 (0,
                                           NULL,
                                           p_item_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           p_pol_eff_date,
                                           p_expiry_date
                                          )
        INTO p_tloss_fl
        FROM DUAL;
        
        OPEN c033 FOR
         SELECT *
           FROM TABLE
                   (gicl_aviation_dtl_pkg.extract_latest_avdata
                                                              (p_line_cd,
                                                               p_subline_cd,
                                                               p_pol_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_pol_eff_date,
                                                               p_expiry_date,
                                                               p_loss_date,
                                                               p_item_no
                                                              )
                   );
   END;

   FUNCTION check_aviation_item_no (
      p_claim_id    gicl_aviation_dtl.claim_id%TYPE,
      p_item_no     gicl_aviation_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_aviation_dtl_pkg.get_aviation_dtl_item
                                                                   (p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;

   FUNCTION extract_latest_avdata (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN gicl_aviation_dtl_tab PIPELINED
   IS
      v_item             gicl_aviation_dtl_type;
      v_item_desc        gicl_clm_item.item_desc%TYPE;
      v_item_desc2       gicl_clm_item.item_desc2%TYPE;
      v_endt_seq_no      gipi_polbasic.endt_seq_no%TYPE;
      v_item_title       gicl_aviation_dtl.item_title%TYPE;
      v_currency_cd      gicl_aviation_dtl.currency_cd%TYPE;
      v_currency_rate    gicl_aviation_dtl.currency_rate%TYPE;
      v_total_fly_time   gicl_aviation_dtl.total_fly_time%TYPE;
      v_purpose          gicl_aviation_dtl.purpose%TYPE;
      v_deduct_text      gicl_aviation_dtl.deduct_text%TYPE;
      v_prev_util_hrs    gicl_aviation_dtl.prev_util_hrs%TYPE;
      v_est_util_hrs     gicl_aviation_dtl.est_util_hrs%TYPE;
      v_qualification    gicl_aviation_dtl.qualification%TYPE;
      v_geog_limit       gicl_aviation_dtl.geog_limit%TYPE;
      v_vessel_cd        gicl_aviation_dtl.vessel_cd%TYPE;
      v_rec_flag         gicl_aviation_dtl.rec_flag%TYPE;
      v_fixed_wing       gicl_aviation_dtl.fixed_wing%TYPE;
      v_rotor            gicl_aviation_dtl.rotor%TYPE;
   BEGIN
      FOR v1 IN (SELECT   b.item_desc, b.item_desc2, endt_seq_no,
                          b.item_title, b.currency_cd, b.currency_rt,
                          c.total_fly_time, c.purpose, c.deduct_text,
                          c.prev_util_hrs, c.est_util_hrs, c.qualification,
                          c.geog_limit, c.vessel_cd, c.rec_flag,
                          c.fixed_wing, c.rotor
                     FROM gipi_polbasic a, gipi_item b, gipi_aviation_item c
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (a.eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= TRUNC (p_loss_date)
                      --AND TRUNC(a.eff_date)   <= :control.loss_date
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= TRUNC (p_loss_date)
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                 ORDER BY eff_date ASC)
      LOOP
         --v_item_desc :=  nvl(v_item_desc,v1.item_desc); -- adrel 07062007
         --v_item_desc2 :=  nvl(v_item_desc2,v1.item_desc2); -- adrel 07062007
         v_item_desc := NVL (v1.item_desc, v_item_desc);
         v_item_desc2 := NVL (v1.item_desc2, v_item_desc2);
         v_endt_seq_no := v1.endt_seq_no;
         v_item_title := v1.item_title;
         v_currency_cd := v1.currency_cd;
         v_currency_rate := v1.currency_rt;
         v_total_fly_time := v1.total_fly_time;
         v_purpose := v1.purpose;
         v_deduct_text := v1.deduct_text;
         v_prev_util_hrs := v1.prev_util_hrs;
         v_est_util_hrs := v1.est_util_hrs;
         v_qualification := v1.qualification;
         v_geog_limit := v1.geog_limit;
         v_vessel_cd := v1.vessel_cd;
         v_rec_flag := v1.rec_flag;
         v_fixed_wing := v1.fixed_wing;
         v_rotor := v1.rotor;
      END LOOP;

      FOR v2 IN (SELECT   b.item_desc, b.item_desc2, b.item_title,
                          b.currency_cd, b.currency_rt, c.total_fly_time,
                          c.purpose, c.deduct_text, c.prev_util_hrs,
                          c.est_util_hrs, c.qualification, c.geog_limit,
                          c.vessel_cd, c.rec_flag, c.fixed_wing, c.rotor
                     FROM gipi_polbasic a, gipi_item b, gipi_aviation_item c
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND NVL (a.back_stat, 5) = 2
                      AND endt_seq_no > v_endt_seq_no
                      --AND TRUNC(a.eff_date)   <= :control.loss_date
                      AND TRUNC (DECODE (TRUNC (a.eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= TRUNC (p_loss_date)
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= TRUNC (p_loss_date)
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                 ORDER BY eff_date ASC)
      LOOP
         v_item_desc := NVL (v_item_desc, v2.item_desc);
         v_item_desc2 := NVL (v_item_desc2, v2.item_desc2);
         v_item_title := NVL (v_item_title, v2.item_title);
         v_currency_cd := NVL (v_currency_cd, v2.currency_cd);
         v_currency_rate := NVL (v_currency_rate, v2.currency_rt);
         v_total_fly_time := NVL (v_total_fly_time, v2.total_fly_time);
         v_purpose := NVL (v_purpose, v2.purpose);
         v_deduct_text := NVL (v_deduct_text, v2.deduct_text);
         v_prev_util_hrs := NVL (v_prev_util_hrs, v2.prev_util_hrs);
         v_est_util_hrs := NVL (v_est_util_hrs, v2.est_util_hrs);
         v_qualification := NVL (v_qualification, v2.qualification);
         v_geog_limit := NVL (v_geog_limit, v2.geog_limit);
         v_vessel_cd := NVL (v_vessel_cd, v2.vessel_cd);
         v_rec_flag := NVL (v_rec_flag, v2.rec_flag);
         v_fixed_wing := NVL (v_fixed_wing, v2.fixed_wing);
         v_rotor := NVL (v_rotor, v2.rotor);
      END LOOP;
      v_item.item_no := p_item_no;
      v_item.item_desc := v_item_desc;
      v_item.item_desc2 := v_item_desc2;
      v_item.item_title := v_item_title;
      v_item.currency_cd := v_currency_cd;
      v_item.currency_rate := v_currency_rate;
      v_item.total_fly_time := v_total_fly_time;
      v_item.purpose := v_purpose;
      v_item.deduct_text := v_deduct_text;
      v_item.prev_util_hrs := v_prev_util_hrs;
      v_item.est_util_hrs := v_est_util_hrs;
      v_item.qualification := v_qualification;
      v_item.geog_limit := v_geog_limit;
      v_item.vessel_cd := v_vessel_cd;
      v_item.rec_flag := v_rec_flag;
      v_item.fixed_wing := v_fixed_wing;
      v_item.rotor := v_rotor;

      --get currency desc
      FOR v IN (SELECT currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = v_item.currency_cd)
      LOOP
         v_item.dsp_currency_desc := v.currency_desc;
         EXIT;
      END LOOP;

      --get vessel_name,rpc_no
      FOR v IN (SELECT a.vessel_name, a.rpc_no, b.air_desc
                  FROM giis_vessel a, giis_air_type b
                 WHERE a.vessel_cd = v_item.vessel_cd
                   AND a.air_type_cd = b.air_type_cd)
      LOOP
         v_item.dsp_vessel_name := v.vessel_name;
         v_item.dsp_rpc_no := v.rpc_no;
         v_item.dsp_air_type := v.air_desc;
      END LOOP;

      PIPE ROW (v_item);
   END;
   
   PROCEDURE set_gicl_aviation_dtl (
      p_claim_id         gicl_aviation_dtl.claim_id%TYPE,
      p_item_no          gicl_aviation_dtl.item_no%TYPE,
      p_item_title       gicl_aviation_dtl.item_title%TYPE,
      p_cpi_rec_no       gicl_aviation_dtl.cpi_rec_no%TYPE,
      p_cpi_branch_cd    gicl_aviation_dtl.cpi_branch_cd%TYPE,
      p_currency_cd      gicl_aviation_dtl.currency_cd%TYPE,
      p_currency_rate     gicl_aviation_dtl.currency_rate%TYPE,
      p_vessel_cd        gicl_aviation_dtl.vessel_cd%TYPE,
      p_total_fly_time   gicl_aviation_dtl.total_fly_time%TYPE,
      p_qualification    gicl_aviation_dtl.qualification%TYPE,
      p_purpose          gicl_aviation_dtl.purpose%TYPE,
      p_geog_limit       gicl_aviation_dtl.geog_limit%TYPE,
      p_deduct_text      gicl_aviation_dtl.deduct_text%TYPE,
      p_rec_flag         gicl_aviation_dtl.rec_flag%TYPE,
      p_fixed_wing       gicl_aviation_dtl.fixed_wing%TYPE,
      p_rotor            gicl_aviation_dtl.rotor%TYPE,
      p_prev_util_hrs    gicl_aviation_dtl.prev_util_hrs%TYPE,
      p_est_util_hrs     gicl_aviation_dtl.est_util_hrs%TYPE
   )
   
   is
    v_loss_date             gicl_claims.dsp_loss_date%TYPE;
   begin
    FOR date IN (SELECT dsp_loss_date
		               FROM gicl_claims
		              WHERE claim_id = p_claim_id) LOOP
          v_loss_date := date.dsp_loss_date;
        END LOOP;
        
               
        
         MERGE INTO gicl_aviation_dtl
         USING DUAL
         ON (claim_id = p_claim_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, item_no, item_title, vessel_cd,
                    total_fly_time, qualification, purpose, geog_limit,
                    deduct_text, rec_flag, fixed_wing, rotor,
                    prev_util_hrs, est_util_hrs,loss_date,
                    currency_cd,currency_rate,
                    user_id,last_update,cpi_rec_no,cpi_branch_cd)
                    values(
                    p_claim_id, p_item_no, p_item_title, p_vessel_cd,
                    p_total_fly_time, p_qualification, p_purpose, p_geog_limit,
                    p_deduct_text, p_rec_flag, p_fixed_wing, p_rotor,
                    p_prev_util_hrs, p_est_util_hrs,v_loss_date,
                    p_currency_cd,p_currency_rate,
                    giis_users_pkg.app_user,sysdate,p_cpi_rec_no,p_cpi_branch_cd
                    )
          when matched then 
          update set
                  item_title = p_item_title, vessel_cd =p_vessel_cd,
                    total_fly_time=p_total_fly_time, qualification=p_qualification, purpose=p_purpose, geog_limit=p_geog_limit,
                    deduct_text = p_deduct_text, rec_flag =p_rec_flag, fixed_wing=p_fixed_wing, rotor=p_rotor,
                    prev_util_hrs =p_prev_util_hrs, est_util_hrs =P_est_util_hrs,loss_date = v_loss_date,
                    currency_cd=p_currency_cd,currency_rate =p_currency_rate,
                    user_id = giis_users_pkg.app_user,last_update = sysdate ,cpi_rec_no =p_cpi_rec_no,cpi_branch_cd =p_cpi_branch_cd; 
   end;
   
   
   PROCEDURE del_gicl_aviation_dtl (
      p_claim_id   gicl_aviation_dtl.claim_id%TYPE,
      p_item_no    gicl_aviation_dtl.item_no%TYPE
   )
   is
   
   begin
   DELETE FROM gicl_aviation_dtl
            WHERE claim_id = p_claim_id AND item_no = p_item_no;
   end;
END;
/



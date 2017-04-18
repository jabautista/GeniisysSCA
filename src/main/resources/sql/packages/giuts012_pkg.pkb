CREATE OR REPLACE PACKAGE BODY CPI.giuts012_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created : 08.15.2013
   ** Referenced by : GIUTS012 - Update Binder Status
   */
   FUNCTION get_giuts012_dtls (
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE,
      p_ri_cd           giri_binder.ri_cd%TYPE
   )
      RETURN giuts012_dtls_tab PIPELINED
   IS
      v_list        giuts012_dtls_type;
      v_where       VARCHAR2 (5000);
      v_affecting   VARCHAR2 (1) := 'N'; -- Dren 10.06.2015 SR 0020187 : Added variable
   BEGIN
      FOR i IN
         (SELECT    line_cd
                 || '-'
                 || binder_yy
                 || '-'
                 || LPAD (binder_seq_no, 6, 0) binder_no,
                 line_cd, binder_yy,
                 LPAD (binder_seq_no, 6, 0) dsp_binder_seq_no, binder_seq_no,
                 binder_date, ri_cd, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                 confirm_no, confirm_date, released_by, release_date,
                 fnl_binder_id, bndr_stat_cd, policy_id -- Dren 10.06.2015 SR 0020187 : Added policy for non-affecting endorsement query
            FROM giri_binder
           WHERE 1 = 1
             AND UPPER (ri_cd) LIKE UPPER (NVL (p_ri_cd, ri_cd))
             --AND UPPER (binder_seq_no) LIKE UPPER (NVL (p_binder_seq_no, binder_seq_no))
             AND UPPER (binder_yy) LIKE UPPER (NVL (p_binder_yy, binder_yy))
             AND UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, line_cd))
             AND check_user_per_line2 (line_cd, iss_cd, 'GIUTS012', p_user_id) =
                                                                             1
             AND check_user_per_iss_cd2 (line_cd,
                                         iss_cd,
                                         'GIUTS012',
                                         p_user_id
                                        ) = 1
             AND reverse_date IS NULL --edgar 11/20/2014 : to exclude reverse/replaced binders
           ORDER BY binder_no)
      LOOP
         v_list.nbt_bndr_stat_desc := NULL;
         v_list.fnl_binder_id := i.fnl_binder_id;
         v_list.binder_no := i.binder_no;
         v_list.line_cd := i.line_cd;
         v_list.binder_yy := i.binder_yy;
         v_list.dsp_binder_seq_no := i.dsp_binder_seq_no;
         v_list.binder_seq_no := i.binder_seq_no;
         v_list.binder_date := i.binder_date;
         v_list.ri_cd := i.ri_cd;
         v_list.ri_shr_pct := i.ri_shr_pct;
         v_list.ri_tsi_amt := i.ri_tsi_amt;
         v_list.ri_prem_amt := i.ri_prem_amt;
         v_list.confirm_no := i.confirm_no;
         v_list.confirm_date := i.confirm_date;
         v_list.released_by := i.released_by;
         v_list.release_date := i.release_date;
         v_list.bndr_stat_cd := i.bndr_stat_cd;

         FOR a IN (SELECT bndr_stat_desc
                     FROM giis_binder_status
                    WHERE bndr_stat_cd = i.bndr_stat_cd)
         LOOP
            v_list.nbt_bndr_stat_desc := a.bndr_stat_desc;
            EXIT;
         END LOOP;

         BEGIN
            SELECT a1801.ri_sname
              INTO v_list.dsp_ri_sname
              FROM giis_reinsurer a1801
             WHERE a1801.ri_cd = i.ri_cd;
         END;
         
         BEGIN -- Dren 10.06.2015 SR 0020187 : Insert value to variable - Start
            FOR A IN (SELECT 1
                        FROM giri_frps_ri
                       WHERE fnl_binder_id  = i.fnl_binder_id)
            LOOP
                v_affecting := 'Y';
            END LOOP;
         END; -- Dren 10.06.2015 SR 0020187 : Insert value to variable - End         
         

         IF v_affecting = 'Y' -- Dren 10.06.2015 SR 0020187 : Modified select to separate affecting and non-affecting endorsement - Start
         THEN
             FOR c1_rec IN (SELECT b245.line_cd, b245.subline_cd, b245.iss_cd,
                                   b245.issue_yy,
                                   LPAD (b245.pol_seq_no, 6, 0) pol_seq_no,
                                   b245.renew_no, b245.endt_iss_cd, b245.endt_yy,
                                   b245.endt_seq_no endt_seq_no_c,
                                   LPAD (b245.endt_seq_no, 6, 0) endt_seq_no,
                                   d045.frps_yy,
                                   LPAD (d045.frps_seq_no, 6, 0) frps_seq_no,
                                   b245.eff_date, b245.expiry_date,
                                   d045.ri_accept_by, d045.ri_as_no,
                                   d045.ri_accept_date, b245.policy_id
                              FROM giri_binder d005,
                                   giri_frps_ri d045,
                                   giri_distfrps d020,
                                   giuw_pol_dist c060,
                                   gipi_polbasic b245
                             WHERE d005.fnl_binder_id = d045.fnl_binder_id
                               AND d045.line_cd = d020.line_cd
                               AND d045.frps_yy = d020.frps_yy
                               AND d045.frps_seq_no = d020.frps_seq_no
                               AND d020.dist_no = c060.dist_no
                               AND c060.policy_id = b245.policy_id
                               AND d005.fnl_binder_id = i.fnl_binder_id
                               AND d005.reverse_date IS NULL)--edgar 11/20/2014 : to exclude reverse/replaced binders
             LOOP
                v_list.policy_no := get_policy_no (c1_rec.policy_id);
                v_list.dsp_line_cd := c1_rec.line_cd;
                v_list.dsp_subline_cd := c1_rec.subline_cd;
                v_list.dsp_iss_cd := c1_rec.iss_cd;
                v_list.dsp_issue_yy := c1_rec.issue_yy;
                v_list.dsp_pol_seq_no := c1_rec.pol_seq_no;
                v_list.dsp_renew_no := c1_rec.renew_no;
                v_list.dsp_endt_iss_cd := c1_rec.endt_iss_cd;
                v_list.dsp_endt_yy := c1_rec.endt_yy;
                v_list.dsp_endt_seq_no := c1_rec.endt_seq_no;
                v_list.dsp_frps_line_cd := c1_rec.line_cd;
                v_list.dsp_frps_yy := c1_rec.frps_yy;
                v_list.dsp_frps_seq_no := c1_rec.frps_seq_no;
                v_list.dsp_ri_accept_by := c1_rec.ri_accept_by;
                v_list.dsp_ri_as_no := c1_rec.ri_as_no;
                v_list.dsp_ri_accept_date := c1_rec.ri_accept_date;
                v_list.dsp_eff_date := c1_rec.eff_date;
                v_list.dsp_expiry_date := c1_rec.expiry_date;

                IF c1_rec.endt_seq_no_c = 0 OR NULL
                THEN
                   v_list.dsp_endt_iss_cd := NULL;
                   v_list.dsp_endt_yy := NULL;
                   v_list.dsp_endt_seq_no := NULL;
                END IF;
             END LOOP;
             
             v_affecting := 'N';
             
             FOR assd IN (SELECT a035.assd_name
                            FROM giri_binder d005,
                                 giri_frps_ri d045,
                                 giri_distfrps d020,
                                 giuw_pol_dist c060,
                                 gipi_polbasic b245,
                                 giis_assured a035
                           WHERE d005.fnl_binder_id = d045.fnl_binder_id
                             AND d045.line_cd = d020.line_cd
                             AND d045.frps_yy = d020.frps_yy
                             AND d045.frps_seq_no = d020.frps_seq_no
                             AND d020.dist_no = c060.dist_no
                             AND c060.policy_id = b245.policy_id
                             AND b245.assd_no = a035.assd_no
                             AND d005.fnl_binder_id = i.fnl_binder_id
                             AND check_user_per_line2 (d045.line_cd,
                                                       b245.iss_cd,
                                                       'GIUTS012',
                                                       p_user_id
                                                      ) = 1
                             AND d005.reverse_date IS NULL)--edgar 11/20/2014 : to exclude reverse/replaced binders
             LOOP
                v_list.dsp_assd_name := assd.assd_name;
             END LOOP; 
                         
         ELSE
             FOR c1_rec IN ( SELECT b245.line_cd
                                    ,b245.subline_cd
                                    ,b245.iss_cd
                                    ,b245.issue_yy
                                    ,b245.pol_seq_no
                                    ,b245.renew_no
                                    ,b245.endt_iss_cd
                                    ,b245.endt_yy
                                    ,b245.endt_seq_no
                                    ,a035.assd_name   
                                    ,b245.eff_date
                                    ,b245.expiry_date    	
                               FROM gipi_polbasic b245,
                                    giis_assured a035
                              WHERE b245.policy_id = i.policy_id
                                AND b245.assd_no   = a035.assd_no)
              LOOP
                v_list.policy_no := get_policy_no (i.policy_id);
                v_list.dsp_line_cd := c1_rec.line_cd;
                v_list.dsp_subline_cd := c1_rec.subline_cd;
                v_list.dsp_iss_cd := c1_rec.iss_cd;
                v_list.dsp_issue_yy := c1_rec.issue_yy;
                v_list.dsp_pol_seq_no := c1_rec.pol_seq_no;
                v_list.dsp_renew_no := c1_rec.renew_no;
                v_list.dsp_endt_iss_cd := c1_rec.endt_iss_cd;
                v_list.dsp_endt_yy := c1_rec.endt_yy;
                v_list.dsp_endt_seq_no := c1_rec.endt_seq_no;
                v_list.dsp_frps_line_cd := c1_rec.line_cd;
                v_list.dsp_eff_date := c1_rec.eff_date;
                v_list.dsp_expiry_date := c1_rec.expiry_date;
                v_list.dsp_assd_name := c1_rec.assd_name;
                v_list.dsp_frps_yy := NULL;
                v_list.dsp_frps_seq_no := NULL;
                v_list.dsp_ri_accept_by := NULL;
                v_list.dsp_ri_as_no := NULL;
                v_list.dsp_ri_accept_date := NULL;                

                IF c1_rec.endt_seq_no = 0 OR NULL
                THEN
                   v_list.dsp_endt_iss_cd := NULL;
                   v_list.dsp_endt_yy := NULL;
                   v_list.dsp_endt_seq_no := NULL;
                END IF;
              END LOOP;
         END IF; -- Dren 10.06.2015 SR 0020187 : Modified select to separate affecting and non-affecting endorsement - End   	                      

         FOR a IN (SELECT bndr_stat_desc
                     FROM giis_binder_status
                    WHERE bndr_stat_cd = i.bndr_stat_cd)
         LOOP
            v_list.nbt_bndr_stat_desc := a.bndr_stat_desc;
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giuts012_dtls;

   FUNCTION get_status_lov
      RETURN giuts012_binder_stat_tab PIPELINED
   IS
      v_list   giuts012_binder_stat_type;
   BEGIN
      FOR i IN (SELECT bndr_stat_cd, bndr_stat_desc
                  FROM giis_binder_status
                 WHERE bndr_tag = 'M')--added condition edgar 12/03/2014
      LOOP
         v_list.bndr_stat_cd := i.bndr_stat_cd;
         v_list.bndr_stat_desc := i.bndr_stat_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_status_lov;

   PROCEDURE update_binder_status (
      p_user_id         IN       giis_users.user_id%TYPE,
      p_confirm_no      IN       giri_binder.confirm_no%TYPE,
      p_confirm_date    IN       giri_binder.confirm_date%TYPE,
      p_released_by     IN       giri_binder.released_by%TYPE,
      p_release_date    IN       giri_binder.release_date%TYPE,
      p_fnl_binder_id   IN       giri_binder.fnl_binder_id%TYPE,
      p_status          IN       giis_binder_status.bndr_stat_desc%TYPE,
      p_bndr_status     OUT      giis_binder_status.bndr_stat_desc%TYPE
   )
   AS
      v_bndr_stat_cd   giri_binder.bndr_stat_cd%TYPE;
      v_bndr_tag       giis_binder_status.bndr_tag%TYPE;
   BEGIN
      giis_users_pkg.app_user := NVL(p_user_id, USER); -- added by jdiago 07.30.2014
      /*edgar 12/03/2014*/
        BEGIN
           FOR bndr IN (SELECT bndr_stat_cd, bndr_tag
                          FROM giis_binder_status
                         WHERE bndr_stat_desc = p_status)
           LOOP
              v_bndr_stat_cd := bndr.bndr_stat_cd;
              v_bndr_tag := bndr.bndr_tag;
           END LOOP;
        END;
      /*edgar 12/03/2014*/
      IF (v_bndr_stat_cd IS NOT NULL AND v_bndr_stat_cd IN ('UR','CN','RL')) OR v_bndr_stat_cd IS NULL THEN
          IF     p_confirm_no IS NULL
             AND p_confirm_date IS NULL
             AND p_released_by IS NULL
             AND p_release_date IS NULL
          THEN
             /*SELECT bndr_stat_cd
              --INTO v_bndr_stat_cd
              --FROM giis_binder_status
             --WHERE bndr_stat_desc = p_status;*/ -- commented out edgar 11/25/2014
             v_bndr_stat_cd := 'UR'; --edgar 11/25/2014
          ELSE
             IF p_confirm_no IS NOT NULL AND p_confirm_date IS NOT NULL
             THEN
                v_bndr_stat_cd := 'CN';
             ELSIF p_released_by IS NOT NULL AND p_release_date IS NOT NULL
             THEN
                v_bndr_stat_cd := 'RL';
             ELSIF p_confirm_no IS NOT NULL AND p_released_by IS NOT NULL
             THEN
                v_bndr_stat_cd := 'CN';
             ELSIF     p_confirm_no IS NULL
                   AND p_released_by IS NULL
                   AND p_release_date IS NULL
             THEN
                v_bndr_stat_cd := 'UR';
             END IF;
          END IF;
      
      /*SELECT bndr_stat_desc
        INTO p_bndr_status
        FROM giis_binder_status
       WHERE bndr_stat_cd = v_bndr_stat_cd;*/--commented out edgar 12/03/2014
      /*edgar 12/03/2014*/
        BEGIN
           SELECT bndr_stat_desc
             INTO p_bndr_status
             FROM giis_binder_status
            WHERE bndr_stat_cd = v_bndr_stat_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              IF v_bndr_stat_cd = 'UR'
              THEN
                 INSERT INTO giis_binder_status
                             (bndr_stat_cd, bndr_stat_desc, bndr_tag, remarks,
                              user_id, last_update
                             )
                      VALUES ('UR', 'UNRELEASED', 'S', '',
                              giis_users_pkg.app_user, SYSDATE
                             );
              ELSIF v_bndr_stat_cd = 'RL'
              THEN
                 INSERT INTO giis_binder_status
                             (bndr_stat_cd, bndr_stat_desc, bndr_tag, remarks,
                              user_id, last_update
                             )
                      VALUES ('RL', 'RELEASED', 'S', '',
                              giis_users_pkg.app_user, SYSDATE
                             );
              ELSIF v_bndr_stat_cd = 'CN'
              THEN
                 INSERT INTO giis_binder_status
                             (bndr_stat_cd, bndr_stat_desc, bndr_tag, remarks,
                              user_id, last_update
                             )
                      VALUES ('CN', 'CONFIRMED', 'S', '',
                              giis_users_pkg.app_user, SYSDATE
                             );
              END IF;

              SELECT bndr_stat_desc
                INTO p_bndr_status
                FROM giis_binder_status
               WHERE bndr_stat_cd = v_bndr_stat_cd;
        END;
      END IF;
      /*edgar 12/03/2014*/
      UPDATE giri_binder
         SET confirm_no = p_confirm_no,
             confirm_date = p_confirm_date,
             released_by = p_released_by,
             release_date = p_release_date,
             bndr_stat_cd = v_bndr_stat_cd,
             user_id = p_user_id -- added by jdiago 07.30.2014
       WHERE fnl_binder_id = p_fnl_binder_id;
   END update_binder_status;
END;
/



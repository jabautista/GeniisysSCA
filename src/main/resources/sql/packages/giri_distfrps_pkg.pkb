CREATE OR REPLACE PACKAGE BODY CPI.giri_distfrps_pkg
AS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (SET_LIMIT_INTO_GIPI_WITMPERL)
**  Description  : Procedure to delete distfrps record.
*/
   PROCEDURE del_giri_distfrps (
      p_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE,
                                          --frps_seq_no to limit the deletion
      p_frps_yy       IN   giri_distfrps.frps_yy%TYPE
   )                                          --frps_yy to limit the deletion
   IS
   BEGIN
      DELETE      giri_distfrps
            WHERE frps_seq_no = p_frps_seq_no AND frps_yy = p_frps_yy;
   END del_giri_distfrps;

/*
**  Created by   :  Jerome Orio
**  Date Created :  March 28, 2011
**  Reference By : GIUWS004 Preliminary One-Risk Dist
**  Description  :
*/
   FUNCTION check_dist_flag (
      p_dist_no       giri_distfrps.dist_no%TYPE,
      p_dist_seq_no   giri_distfrps.dist_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_count   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM giri_distfrps
       WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      RETURN v_count;
   END;

   /*
   **  Created by        : Mark JM
   **  Date Created    : 03.31.2011
   **  Reference By    : (GIUWS003 - Preliminary Peril Distribution)
   **  Description     : Retrieve records on giri_distfrps based on the given parameter
   */
   FUNCTION get_giri_distfrps (p_dist_no IN giri_distfrps.dist_no%TYPE)
      RETURN giri_distfrps_tab PIPELINED
   IS
      v_giri_distfrps   giri_distfrps_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.frps_yy, a.frps_seq_no, a.dist_no,
                       a.dist_seq_no, a.tsi_amt, a.tot_fac_spct,
                       a.tot_fac_tsi, a.prem_amt, a.tot_fac_prem, a.ri_flag,
                       a.currency_cd, a.currency_rt, a.create_date,
                       a.user_id, a.prem_warr_sw, a.claims_coop_sw,
                       a.claims_control_sw, a.loc_voy_unit, a.op_sw,
                       a.op_group_no, a.op_frps_yy, a.op_frps_seq_no,
                       a.cpi_rec_no, a.cpi_branch_cd, a.tot_fac_spct2,
                       a.arc_ext_data
                  FROM giri_distfrps a
                 WHERE a.dist_no = p_dist_no)
      LOOP
         v_giri_distfrps.line_cd := i.line_cd;
         v_giri_distfrps.frps_yy := i.frps_yy;
         v_giri_distfrps.frps_seq_no := i.frps_seq_no;
         v_giri_distfrps.dist_no := i.dist_no;
         v_giri_distfrps.dist_seq_no := i.dist_seq_no;
         v_giri_distfrps.tsi_amt := i.tsi_amt;
         v_giri_distfrps.tot_fac_spct := i.tot_fac_spct;
         v_giri_distfrps.tot_fac_tsi := i.tot_fac_tsi;
         v_giri_distfrps.prem_amt := i.prem_amt;
         v_giri_distfrps.tot_fac_prem := i.tot_fac_prem;
         v_giri_distfrps.ri_flag := i.ri_flag;
         v_giri_distfrps.currency_cd := i.currency_cd;
         v_giri_distfrps.currency_rt := i.currency_rt;
         v_giri_distfrps.create_date := i.create_date;
         v_giri_distfrps.user_id := i.user_id;
         v_giri_distfrps.prem_warr_sw := i.prem_warr_sw;
         v_giri_distfrps.claims_coop_sw := i.claims_coop_sw;
         v_giri_distfrps.claims_control_sw := i.claims_control_sw;
         v_giri_distfrps.loc_voy_unit := i.loc_voy_unit;
         v_giri_distfrps.op_sw := i.op_sw;
         v_giri_distfrps.op_group_no := i.op_group_no;
         v_giri_distfrps.op_frps_yy := i.op_frps_yy;
         v_giri_distfrps.op_frps_seq_no := i.op_frps_seq_no;
         v_giri_distfrps.cpi_rec_no := i.cpi_rec_no;
         v_giri_distfrps.cpi_branch_cd := i.cpi_branch_cd;
         v_giri_distfrps.tot_fac_spct2 := i.tot_fac_spct2;
         v_giri_distfrps.arc_ext_data := i.arc_ext_data;
         PIPE ROW (v_giri_distfrps);
      END LOOP;

      RETURN;
   END get_giri_distfrps;

   /*
   **  Created by   :  Belle Bebing
   **  Date Created :  June 16, 2011
   **  Reference By : GIRIS006 -FRPS Listing
   **  Description  :
   */
   FUNCTION get_giri_frpslist (
      p_user_id       giis_users.user_id%TYPE,
      p_module_id     giis_user_grp_modules.module_id%TYPE,
      p_line_cd       gipi_parlist.line_cd%TYPE,
      p_frps_yy       giri_distfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps.frps_seq_no%TYPE,
      p_iss_cd        gipi_parlist.iss_cd%TYPE,
      p_par_yy        gipi_parlist.par_yy%TYPE,
      p_par_seq_no    gipi_parlist.par_seq_no%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
	  p_assd_name     giis_assured.assd_name%TYPE,
	  p_dist_no       giri_distfrps.dist_no%TYPE     
   )
      RETURN giri_distfrps_tab PIPELINED
   IS
      v_frpslist   giri_distfrps_type;
   BEGIN
      FOR i IN
         (SELECT   par_id, line_cd, frps_yy, frps_seq_no,
                      line_cd
                   || '-'
                   || TO_CHAR (frps_yy, '09')
                   || '-'
                   || TO_CHAR (frps_seq_no, '00000009') frps_no,
                   iss_cd, par_yy, par_seq_no, quote_seq_no,
                      line_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || TO_CHAR (par_yy, '09')
                   || '-'
                   || TO_CHAR (par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (quote_seq_no, '09') par_no,
                   endt_iss_cd, endt_yy, endt_seq_no,
                      endt_iss_cd
                   || DECODE(endt_yy, NULL , '', '-'
                   || TO_CHAR (endt_yy, '09'))
                   || DECODE(endt_seq_no, NULL , '','-'
                   || TO_CHAR (endt_seq_no, '000009')) endt_no, -- modified by: Nica 05.22.2012
                   assd_name, eff_date, expiry_date, dist_no, dist_seq_no,
                   tsi_amt, tot_fac_tsi, currency_desc, dist_flag, prem_amt,
                   tot_fac_prem, par_policy_id, subline_cd, issue_yy,
                   pol_seq_no, renew_no
              FROM giri_distfrps_wdistfrps_v
             WHERE check_user_per_iss_cd2 (line_cd, iss_cd, p_module_id, p_user_id) = 1
               AND line_cd LIKE (p_line_cd)
			   AND UPPER(assd_name) LIKE UPPER(NVL(p_assd_name, assd_name))
			   AND dist_no = (NVL(p_dist_no, dist_no))
               AND frps_yy = NVL (p_frps_yy, frps_yy)
               AND frps_seq_no = NVL (p_frps_seq_no, frps_seq_no)
               AND iss_cd LIKE  UPPER(NVL (p_iss_cd, iss_cd))
               AND par_yy = NVL (p_par_yy, par_yy)
               AND par_seq_no = NVL (p_par_seq_no, par_seq_no)
               AND NVL(endt_yy, 0) = NVL(p_endt_yy, NVL(endt_yy, 0))
               AND NVL(endt_seq_no, 0) = NVL (p_endt_seq_no, NVL(endt_seq_no, 0))
               AND subline_cd LIKE UPPER(DECODE(p_subline_cd, null,subline_cd,DECODE(pol_seq_no,null,null,p_subline_cd) ))
               AND issue_yy = DECODE(p_issue_yy, null,issue_yy,DECODE(pol_seq_no,null,null,p_issue_yy) )                 
               AND NVL(pol_seq_no, 0) = NVL(p_pol_seq_no, NVL(pol_seq_no, 0))
               AND par_id NOT IN (SELECT par_id --added edgar to exclude cancelled and deleted PARS
                                    FROM gipi_parlist 
                                   WHERE par_status IN (98, 99))
          ORDER BY frps_no)
      LOOP
         BEGIN
            SELECT rv_meaning
              INTO v_frpslist.dist_desc
              FROM cg_ref_codes
             WHERE rv_domain = 'GIUW_POL_DIST.DIST_FLAG'
               AND rv_low_value = i.dist_flag;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
       
         FOR a IN (SELECT NVL (dist_spct1, 0) dist_spct1
                        FROM giuw_wpolicyds_dtl
                       WHERE dist_no = i.dist_no 
                         AND dist_seq_no = i.dist_seq_no)
            LOOP
                IF a.dist_spct1 > 0 THEN 
                    v_frpslist.dist_by_tsi_prem := 1;
                    EXIT;
				/*Added By Rod*/
				ELSE
					v_frpslist.dist_by_tsi_prem := 0;
					EXIT;
                END IF;
            END LOOP;

         BEGIN
            SELECT b.par_type, c.reg_policy_sw
              INTO v_frpslist.par_type, v_frpslist.reg_policy_sw
              FROM gipi_parlist b, gipi_wpolbas c
             WHERE b.par_id = c.par_id AND b.par_id = i.par_id
            UNION
            SELECT b.par_type, c.reg_policy_sw
              FROM gipi_parlist b, gipi_polbasic c
             WHERE b.par_id = c.par_id AND c.par_id = i.par_id;

            IF v_frpslist.par_type = 'P'
            THEN
               v_frpslist.endt_no := '';
            ELSE
               v_frpslist.endt_no := i.endt_no;
            END IF;

            IF v_frpslist.reg_policy_sw = 'Y'
            THEN
               v_frpslist.spcl_pol_tag := 1;
            ELSE
               v_frpslist.spcl_pol_tag := 2;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         v_frpslist.par_id := i.par_id;
         v_frpslist.line_cd := i.line_cd;
         v_frpslist.frps_yy := i.frps_yy;
         v_frpslist.frps_seq_no := i.frps_seq_no;
         v_frpslist.frps_no := i.frps_no;
         v_frpslist.iss_cd := i.iss_cd;
         v_frpslist.par_yy := i.par_yy;
         v_frpslist.par_seq_no := i.par_seq_no;
         v_frpslist.quote_seq_no := i.quote_seq_no;
         v_frpslist.par_no := i.par_no;
         v_frpslist.endt_iss_cd := i.endt_iss_cd;
         v_frpslist.endt_yy := i.endt_yy;
         v_frpslist.endt_seq_no := i.endt_seq_no;
         v_frpslist.policy_no := get_policy_no_giris006 (i.dist_no);
         v_frpslist.assd_name := i.assd_name;
         v_frpslist.pack_pol_no :=
            get_pack_pol_no_giris006 (i.line_cd,
                                      i.iss_cd,
                                      i.par_yy,
                                      i.par_seq_no,
                                      i.quote_seq_no
                                     );
         v_frpslist.eff_date := i.eff_date;
         v_frpslist.expiry_date := i.expiry_date;
         v_frpslist.dist_no := i.dist_no;
         v_frpslist.dist_seq_no := i.dist_seq_no;
         v_frpslist.tsi_amt := i.tsi_amt;
         v_frpslist.tot_fac_tsi := i.tot_fac_tsi;
         v_frpslist.curr_desc := i.currency_desc;
         v_frpslist.dist_flag := i.dist_flag;
         v_frpslist.prem_amt := i.prem_amt;
         v_frpslist.tot_fac_prem := i.tot_fac_prem;
         v_frpslist.subline_cd := i.subline_cd;
         v_frpslist.issue_yy := i.issue_yy;
         v_frpslist.pol_seq_no := i.pol_seq_no;
         v_frpslist.ref_pol_no := get_ref_pol_no_GIRIS006(i.line_cd,i.iss_cd,i.par_yy,i.par_seq_no,i.quote_seq_no);
         v_frpslist.renew_no  := i.renew_no;
         PIPE ROW (v_frpslist);
      END LOOP;

      RETURN;
   END get_giri_frpslist;

       /*
   **  Created by       : Anthony Santos
   **  Date Created     : 06.29.2011
   **  Reference By     : (GIRIS026- Post FRPS
   **
   */
   PROCEDURE create_giri_distfrps_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   )
   IS
      CURSOR distfrps_area
      IS
         SELECT t1.line_cd, frps_yy, frps_seq_no, op_group_no, op_frps_yy,
                op_frps_seq_no, t1.dist_no, dist_seq_no, t1.tsi_amt,
                tot_fac_spct, tot_fac_tsi, t1.prem_amt, tot_fac_prem,
                loc_voy_unit, op_sw, ri_flag, currency_cd, currency_rt,
                t1.create_date, t1.user_id, prem_warr_sw, claims_coop_sw,
                claims_control_sw, tot_fac_spct2
           FROM giri_wdistfrps t1
          WHERE t1.line_cd = p_line_cd
            AND t1.frps_yy = p_frps_yy
            AND t1.frps_seq_no = p_frps_seq_no;
   BEGIN
      FOR c1_rec IN distfrps_area
      LOOP
         INSERT INTO giri_distfrps
                     (line_cd, frps_yy, frps_seq_no,
                      op_group_no, op_frps_yy,
                      op_frps_seq_no, dist_no,
                      dist_seq_no, tsi_amt,
                      tot_fac_spct, tot_fac_tsi,
                      prem_amt, tot_fac_prem,
                      loc_voy_unit, op_sw, ri_flag,
                      currency_cd, currency_rt,
                      create_date, user_id,
                      prem_warr_sw, claims_coop_sw,
                      claims_control_sw, tot_fac_spct2
                     )
              VALUES (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
                      c1_rec.op_group_no, c1_rec.op_frps_yy,
                      c1_rec.op_frps_seq_no, c1_rec.dist_no,
                      c1_rec.dist_seq_no, c1_rec.tsi_amt,
                      c1_rec.tot_fac_spct, c1_rec.tot_fac_tsi,
                      c1_rec.prem_amt, c1_rec.tot_fac_prem,
                      c1_rec.loc_voy_unit, c1_rec.op_sw, c1_rec.ri_flag,
                      c1_rec.currency_cd, c1_rec.currency_rt,
                      c1_rec.create_date, c1_rec.user_id,
                      c1_rec.prem_warr_sw, c1_rec.claims_coop_sw,
                      c1_rec.claims_control_sw, c1_rec.tot_fac_spct2
                     );
      END LOOP;
   END create_giri_distfrps_giris026;

   /*
     **  Created by       : Anthony Santos
     **  Date Created     : 06.29.2011
     **  Reference By     : (GIRIS026- Post FRPS
     **
     */
   PROCEDURE update_flag_giris026 (
      p_line_cd             giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy             giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no         giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no             giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no         giri_distfrps_wdistfrps_v.dist_seq_no%TYPE,
      p_param         OUT   VARCHAR2
   )
   IS
      v_policy_id     giuw_pol_dist.policy_id%TYPE;
      v_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE;
      v_pol           giuw_pol_dist.policy_id%TYPE;
   BEGIN
      --:gauge.file := 'Updating giri_distfrps.';
      --vbx_counter;
      FOR a IN (SELECT policy_id
                  FROM giuw_pol_dist
                 WHERE dist_no = p_dist_no)
      LOOP
         v_pol := a.policy_id;
         EXIT;
      END LOOP;

      UPDATE giri_distfrps
         SET ri_flag = '2',
             user_id = NVL(GIIS_USERS_PKG.APP_USER, USER),
             create_date = SYSDATE
       WHERE line_cd = p_line_cd
         AND frps_yy = p_frps_yy
         AND frps_seq_no = p_frps_seq_no;

      BEGIN
         SELECT COUNT (frps_seq_no)
           INTO v_frps_seq_no
           FROM giri_wdistfrps
          WHERE dist_no = p_dist_no AND dist_seq_no != p_dist_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR a IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'AUTO_PRINT_BINDERS')
      LOOP
         p_param := a.param_value_v;
         EXIT;
      END LOOP;

      /*
      IF var3.param = 'Y' THEN
           null;
         --SET_ITEM_PROPERTY ('post_button.cancel', LABEL, 'Exit');
      ELSE
              null;
         --SET_ITEM_PROPERTY ('post_button.post', LABEL, 'Print');
         --SET_ITEM_PROPERTY ('post_button.cancel', LABEL, 'Exit');
      END IF;   */
      IF v_frps_seq_no IS NULL OR v_frps_seq_no = 0
      THEN
         IF v_pol IS NULL
         THEN
            UPDATE giuw_pol_dist
               SET auto_dist = 'Y',
                   user_id = USER,
                   last_upd_date = SYSDATE
             WHERE dist_no = p_dist_no;
         --vbx_counter;
         ELSE
            --:gauge.file := 'Updating gipi_polbasic.';
            --vbx_counter;
            UPDATE giuw_pol_dist
               SET dist_flag = '3',
                   post_date = SYSDATE,
                   user_id = USER,
                   last_upd_date = SYSDATE
             WHERE dist_no = p_dist_no;

            SELECT policy_id
              INTO v_policy_id
              FROM giuw_pol_dist
             WHERE dist_no = p_dist_no;

            UPDATE gipi_polbasic
               SET dist_flag = '3',
                   user_id = USER,
                   last_upd_date = SYSDATE
             WHERE policy_id = v_policy_id;
             
             GIUW_POL_DIST_FINAL_PKG.DELETE_DIST_WORKING_TABLES_017(p_dist_no);     -- to delete records in working dist tables once all binders have been posted : shan 07.15.2014
         END IF;
       /*
         IF nvl(var3.param,'N') = 'N' THEN
         null;
            --SET_ITEM_PROPERTY ('POST_BUTTON.POST', ENABLED, PROPERTY_TRUE);
         ELSE
         null;
               --SET_ITEM_PROPERTY ('POST_BUTTON.POST', ENABLED, PROPERTY_FALSE);
         END IF;
      ELSE
      null;
         --SET_ITEM_PROPERTY ('POST_BUTTON.POST', ENABLED, PROPERTY_FALSE);*/
      END IF;
   --:gauge.file := 'Updating giuw_pol_dist.';
   --vbx_counter;
   END;

   FUNCTION get_giri_frpslist2 (
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN giri_distfrps_tab PIPELINED
   IS
      v_frpslist   giri_distfrps_type;
   BEGIN
      FOR i IN (SELECT   par_id, line_cd, frps_yy, frps_seq_no,
                            line_cd
                         || '-'
                         || TO_CHAR (frps_yy, '09')
                         || '-'
                         || TO_CHAR (frps_seq_no, '00000009') frps_no,
                         iss_cd, par_yy, par_seq_no, quote_seq_no,
                            line_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || TO_CHAR (par_yy, '09')
                         || '-'
                         || TO_CHAR (par_seq_no, '000009')
                         || '-'
                         || TO_CHAR (quote_seq_no, '09') par_no,
                         endt_iss_cd, endt_yy, endt_seq_no,
                            endt_iss_cd
                         || '-'
                         || TO_CHAR (endt_yy, '09')
                         || '-'
                         || TO_CHAR (endt_seq_no, '000009') endt_no,
                         assd_name, eff_date, expiry_date, dist_no, renew_no, 
                         dist_seq_no, tsi_amt, tot_fac_tsi, currency_desc,
                         dist_flag, prem_amt, tot_fac_prem, par_policy_id,
                         subline_cd, issue_yy, pol_seq_no
                    FROM giri_distfrps_wdistfrps_v
                   WHERE check_user_per_iss_cd (line_cd, iss_cd, p_module_id) =
                                                                            1
                ORDER BY frps_no)
      LOOP
         BEGIN
            SELECT rv_meaning
              INTO v_frpslist.dist_desc
              FROM cg_ref_codes
             WHERE rv_domain = 'GIUW_POL_DIST.DIST_FLAG'
               AND rv_low_value = i.dist_flag;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT par_type
              INTO v_frpslist.par_type
              FROM gipi_parlist
             WHERE par_id = i.par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         v_frpslist.par_id := i.par_id;
         v_frpslist.line_cd := i.line_cd;
         v_frpslist.frps_yy := i.frps_yy;
         v_frpslist.frps_seq_no := i.frps_seq_no;
         v_frpslist.frps_no := i.frps_no;
         v_frpslist.iss_cd := i.iss_cd;
         v_frpslist.par_yy := i.par_yy;
         v_frpslist.par_seq_no := i.par_seq_no;
         v_frpslist.quote_seq_no := i.quote_seq_no;
         v_frpslist.par_no := i.par_no;
         v_frpslist.endt_iss_cd := i.endt_iss_cd;
         v_frpslist.endt_yy := i.endt_yy;
         v_frpslist.endt_seq_no := i.endt_seq_no;
         v_frpslist.policy_no := get_policy_no (i.par_policy_id);
         v_frpslist.assd_name := i.assd_name;
         v_frpslist.pack_pol_no := get_pack_policy_no (i.par_policy_id);
         v_frpslist.eff_date := i.eff_date;
         v_frpslist.expiry_date := i.expiry_date;
         v_frpslist.dist_no := i.dist_no;
         v_frpslist.dist_seq_no := i.dist_seq_no;
         v_frpslist.tsi_amt := i.tsi_amt;
         v_frpslist.tot_fac_tsi := i.tot_fac_tsi;
         v_frpslist.tot_fac_prem := i.tot_fac_prem;
         v_frpslist.curr_desc := i.currency_desc;
         v_frpslist.dist_flag := i.dist_flag;
         v_frpslist.prem_amt := i.prem_amt;
         v_frpslist.renew_no := i.renew_no;
         v_frpslist.subline_cd := i.subline_cd;
         v_frpslist.issue_yy := i.issue_yy;
         v_frpslist.pol_seq_no := i.pol_seq_no;
         PIPE ROW (v_frpslist);
      END LOOP;

      RETURN;
   END get_giri_frpslist2;

/*
**  Created by   :  Belle Bebing
**  Date Created :  June 30, 2011
**  Reference By : GIRIS006 -FRPS Listing
**  Description  :
*/
   FUNCTION get_pack_pol_no_giris006 (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_pack_pol_no   VARCHAR2 (50) := NULL;
   BEGIN
      FOR a IN (SELECT par_status, par_id
                  FROM gipi_parlist
                 WHERE line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND par_yy = p_par_yy
                   AND par_seq_no = p_par_seq_no
                   AND quote_seq_no = p_quote_seq_no)
      LOOP
         IF a.par_status = 10
         THEN
            FOR c1 IN (SELECT pack_policy_id
                         FROM gipi_polbasic
                        WHERE par_id = a.par_id)
            LOOP
               FOR c2 IN (SELECT    line_cd
                                 || '-'
                                 || subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || TO_CHAR (issue_yy, '09')
                                 || '-'
                                 || TO_CHAR (pol_seq_no, '000009')
                                 || '-'
                                 || TO_CHAR (renew_no, '09') pack_pol_no
                            FROM gipi_pack_polbasic
                           WHERE pack_policy_id = c1.pack_policy_id)
               LOOP
                  v_pack_pol_no := c2.pack_pol_no;
               END LOOP;
            END LOOP;
         ELSE
            FOR c1 IN (SELECT pack_par_id
                         FROM gipi_wpolbas
                        WHERE par_id = a.par_id)
            LOOP
               FOR c2 IN (SELECT    line_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || TO_CHAR (par_yy, '09')
                                 || '-'
                                 || TO_CHAR (par_seq_no, '000009')
                                                                 pack_par_no
                            FROM gipi_pack_parlist
                           WHERE pack_par_id = c1.pack_par_id)
               LOOP
                  v_pack_pol_no := c2.pack_par_no;
               END LOOP;
            END LOOP;
         END IF;
      END LOOP;

      RETURN (v_pack_pol_no);
   END get_pack_pol_no_giris006;

   FUNCTION get_ref_pol_no_giris006 (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ref_pol_no   VARCHAR2 (50) := NULL;
   BEGIN
      FOR a IN (SELECT par_status, par_id
                  FROM gipi_parlist
                 WHERE line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND par_yy = p_par_yy
                   AND par_seq_no = p_par_seq_no
                   AND quote_seq_no = p_quote_seq_no)
      LOOP
         IF a.par_status = 10
         THEN
            FOR c1 IN (SELECT ref_pol_no
                         FROM gipi_polbasic
                        WHERE par_id = a.par_id)
            LOOP
               v_ref_pol_no := c1.ref_pol_no;
            END LOOP;
         ELSE
            FOR c1 IN (SELECT ref_pol_no
                         FROM gipi_wpolbas
                        WHERE par_id = a.par_id)
            LOOP
               v_ref_pol_no := c1.ref_pol_no;
            END LOOP;
         END IF;
      END LOOP;

      RETURN (v_ref_pol_no);
   END get_ref_pol_no_giris006;

   FUNCTION get_policy_no_giris006 (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN VARCHAR2
   IS
      v_policy_no   VARCHAR2 (50);
   BEGIN
      FOR i IN (SELECT    t1.line_cd
                       || '-'
                       || t1.subline_cd
                       || '-'
                       || t1.iss_cd
                       || '-'
                       ||LTRIM (TO_CHAR(t1.issue_yy,'09')) --change by steven 03/03/2013 base on SR 0012282
                       ||'-'
                       ||LTRIM (TO_CHAR(t1.pol_seq_no,'0000009'))
                       ||'-'
                       ||LTRIM (TO_CHAR(t1.renew_no,'09')) policy_no
                  FROM gipi_polbasic t1, giuw_pol_dist t2, gipi_parlist t3
                 WHERE t1.par_id = t3.par_id
                   AND t1.policy_id = t2.policy_id
                   AND t2.dist_no = p_dist_no
                UNION
                SELECT    t1.line_cd
                       || '-'
                       || t1.subline_cd
                       || '-'
                       || t1.iss_cd
                       || '-'
                       ||LTRIM (TO_CHAR(t1.issue_yy,'09')) --change by steven 03/03/2013 base on SR 0012282
                       ||'-'
                       ||LTRIM (TO_CHAR(t1.pol_seq_no,'0000009'))
                       ||'-'
                       ||LTRIM (TO_CHAR(t1.renew_no,'09')) policy_no
                  FROM gipi_wpolbas t1, giuw_pol_dist t2, gipi_parlist t3
                 WHERE t1.par_id = t3.par_id
                   AND t1.par_id = t2.par_id
                   AND t3.par_type = 'E'
                   AND t2.dist_no = p_dist_no)
      LOOP
         v_policy_no := NVL (i.policy_no, NULL);
      END LOOP;

      RETURN (v_policy_no);
   END get_policy_no_giris006;

   PROCEDURE complete_ri_posting (
      p_line_cd               giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_subline_cd            giri_distfrps_wdistfrps_v.subline_cd%TYPE,
      p_iss_cd                giri_distfrps_wdistfrps_v.iss_cd%TYPE,
      p_issue_yy              giri_distfrps_wdistfrps_v.issue_yy%TYPE,
      p_pol_seq_no            giri_distfrps_wdistfrps_v.pol_seq_no%TYPE,
      p_renew_no              giri_distfrps_wdistfrps_v.renew_no%TYPE,
      p_frps_yy               giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no           giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no               giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no           giri_distfrps_wdistfrps_v.dist_seq_no%TYPE,
      p_param           OUT   VARCHAR2
   )
   IS
   BEGIN
      FOR a IN (SELECT policy_id, par_id
                  FROM giuw_pol_dist
                 WHERE dist_no = p_dist_no)
      LOOP
         delete_workflow_rec (NULL, 'GIUWS003', NVL(GIIS_USERS_PKG.APP_USER, USER), a.par_id);
         delete_workflow_rec (NULL, 'GIUWS004', NVL(GIIS_USERS_PKG.APP_USER, USER), a.par_id);
         delete_workflow_rec (NULL, 'GIUWS012', NVL(GIIS_USERS_PKG.APP_USER, USER), a.policy_id);

         FOR c1 IN (SELECT claim_id
                      FROM gicl_claims b, gipi_polbasic c
                     WHERE 1 = 1
                       AND b.line_cd = c.line_cd
                       AND b.subline_cd = c.subline_cd
                       AND b.iss_cd = c.iss_cd
                       AND b.issue_yy = c.issue_yy
                       AND b.pol_seq_no = c.pol_seq_no
                       AND b.renew_no = c.renew_no
                       AND c.policy_id = a.policy_id)
         LOOP
            delete_workflow_rec ('UNDISTRIBUTED POLICIES AWAITING CLAIMS',
                                 'GICLS010',
                                 NVL(GIIS_USERS_PKG.APP_USER, USER),
                                 c1.claim_id
                                );
         END LOOP;
      END LOOP;

      giri_distfrps_pkg.update_flag_giris026 (p_line_cd,
                                              p_frps_yy,
                                              p_frps_seq_no,
                                              p_dist_no,
                                              p_dist_seq_no,
                                              p_param
                                             );

      --COMMIT;
      --CLEAR_MESSAGE;
      --:gauge.comment := NULL;
      --:gauge.file := 'Posting complete.';
/*
**UPDATE EXISTING CLAIMS WITH DISTRUBUTED RESERVE FOR THIS POLICY
*/
      DECLARE
         v_reverse_date   DATE;
         v_reverse         VARCHAR2(1) := 'N';
      BEGIN
         /*SELECT reverse_date
           INTO v_reverse_date
           FROM giri_binder
          WHERE fnl_binder_id IN (
                   SELECT fnl_binder_id
                     FROM giri_frps_ri
                    WHERE (frps_seq_no, frps_yy, line_cd) IN (
                             SELECT frps_seq_no, frps_yy, line_cd
                               FROM giri_distfrps
                              WHERE (dist_no, dist_seq_no) IN (
                                       SELECT dist_no, dist_seq_no
                                         FROM giuw_itemperilds
                                        WHERE dist_no = 61310
                                          AND dist_seq_no = 1)));*/
         -- bonok :: 10.17.2013 :: SR 473 - GENQA
         FOR i IN (SELECT reverse_date
                     FROM giri_binder
                    WHERE fnl_binder_id IN (
                             SELECT fnl_binder_id
                               FROM giri_frps_ri
                              WHERE (frps_seq_no, frps_yy, line_cd) IN (
                                       SELECT frps_seq_no, frps_yy, line_cd
                                         FROM giri_distfrps
                                        WHERE (dist_no, dist_seq_no) IN (
                                                 SELECT dist_no, dist_seq_no
                                                   FROM giuw_itemperilds
                                                  WHERE dist_no = p_dist_no
                                                    AND dist_seq_no = p_dist_seq_no))))
         LOOP
            v_reverse := 'Y';
            EXIT;
         END LOOP;

         --IF v_reverse_date IS NOT NULL -- bonok :: 10.17.2013 :: SR 473 - GENQA
         IF v_reverse = 'Y'
         THEN
            UPDATE gicl_clm_reserve
               SET redist_sw = 'Y'
             WHERE (claim_id, item_no, peril_cd) IN (
                      SELECT claim_id, item_no, peril_cd
                        FROM gicl_clm_res_hist
                       WHERE claim_id IN (
                                SELECT claim_id
                                  FROM gicl_claims
                                 WHERE line_cd = p_line_cd
                                   AND subline_cd = p_subline_cd
                                   AND pol_iss_cd = p_iss_cd
                                   AND issue_yy = p_issue_yy
                                   AND pol_seq_no = p_pol_seq_no
                                   AND renew_no = p_renew_no)
                         AND dist_sw = 'Y')
               AND (item_no, peril_cd) IN (
                      SELECT item_no, peril_cd
                        FROM giuw_itemperilds
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = p_dist_seq_no);
         ELSE
            UPDATE gicl_clm_reserve
               SET redist_sw = ''
             WHERE (claim_id, item_no, peril_cd) IN (
                      SELECT claim_id, item_no, peril_cd
                        FROM gicl_clm_res_hist
                       WHERE claim_id IN (
                                SELECT claim_id
                                  FROM gicl_claims
                                 WHERE line_cd = p_line_cd
                                   AND subline_cd = p_subline_cd
                                   AND pol_iss_cd = p_iss_cd
                                   AND issue_yy = p_issue_yy
                                   AND pol_seq_no = p_pol_seq_no
                                   AND renew_no = p_renew_no)
                         AND dist_sw = 'Y')
               AND (item_no, peril_cd) IN (
                      SELECT item_no, peril_cd
                        FROM giuw_itemperilds
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = p_dist_seq_no);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END complete_ri_posting;
   
   /*
   **  Created by   :  Robert Virrey
   **  Date Created :  August 11, 2011
   **  Reference By : GIUTS004 - Reverse Binder
   **  Description  :
   */
    FUNCTION get_giri_frpslist3 (
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )      
      RETURN giri_distfrps_tab PIPELINED
   IS
      v_frpslist   giri_distfrps_type;
   BEGIN
/* Commented out by MJ for consolidation 01022013   
      FOR i IN (SELECT a.line_cd, a.frps_yy, a.frps_seq_no,									--[START] Optimized by MJ 11/28/2012
                       a.line_cd || '-' || 
                            TO_CHAR (a.frps_yy, '09') || '-' || 
                            TO_CHAR (a.frps_seq_no, '00000009') frps_no, 
                       a.dist_no, a.dist_seq_no, a.tsi_amt,
                       a.tot_fac_spct, a.tot_fac_tsi, a.prem_amt,
                       a.tot_fac_prem, a.ri_flag, a.user_id, 
                       d.line_cd || '-' || d.subline_cd || '-' || d.iss_cd || '-' || 
                            LTRIM(TO_CHAR(d.issue_yy,'09')) || '-' || 
                            LTRIM(TO_CHAR(d.pol_seq_no,'0999999'))  || '-' || 
                            LTRIM(TO_CHAR(d.renew_no,'09')) policy,
                       d.endt_iss_cd || ' - ' ||
                            LTRIM(TO_CHAR(d.endt_yy,'09')) || ' - ' ||
                            LTRIM(TO_CHAR(d.endt_seq_no,'099999')) endorsement,
						d.assd_no	
          FROM giri_distfrps a, gipi_polbasic d, giuw_pol_dist b 
                 WHERE a.ri_flag = '2'
                   AND d.policy_id   = b.policy_id
                   AND b.dist_no     = a.dist_no
                   AND EXISTS (SELECT 1 
                                 FROM gipi_polbasic 
                                WHERE line_cd = DECODE(check_user_per_line(d.line_cd,d.iss_cd,p_module_id),1,d.line_cd)
                                 AND iss_cd = DECODE(check_user_per_iss_cd(d.line_cd,d.iss_cd,p_module_id),1,d.iss_cd))							  
								  )
*/
      FOR i IN (SELECT a.line_cd, a.frps_yy, a.frps_seq_no,
                       a.line_cd || '-' || 
                       TO_CHAR (a.frps_yy, '09') || '-' || 
                       TO_CHAR (a.frps_seq_no, '00000009') frps_no, 
                       a.dist_no, a.dist_seq_no, a.tsi_amt,
                       a.tot_fac_spct, a.tot_fac_tsi, a.prem_amt,
                       a.tot_fac_prem, a.ri_flag, a.user_id
                  FROM giri_distfrps a
                 WHERE a.ri_flag = '2'
                   AND EXISTS (SELECT 1
                                 FROM gipi_polbasic d, giuw_pol_dist b, giri_distfrps c
                                WHERE d.policy_id   = b.policy_id
                                  AND b.dist_no     = c.dist_no
                                  AND c.line_cd     = a.line_cd
                                  AND c.frps_yy     = a.frps_yy
                                  AND c.frps_seq_no = a.frps_seq_no
                                  AND d.pol_flag <> '5' -- marco - 12.07.2012 - to exclude spoiled policies
                                  AND d.line_cd     = DECODE(check_user_per_line(d.line_cd,d.iss_cd,p_module_id),1,d.line_cd)
                                  AND d.iss_cd      = DECODE(check_user_per_iss_cd(d.line_cd,d.iss_cd,p_module_id),1,d.iss_cd)))
								  
      LOOP
         BEGIN
             SELECT a.line_cd || '-' ||
                    a.subline_cd || '-' ||
                    a.iss_cd || '-' ||
                    LTRIM(TO_CHAR(a.issue_yy,'09')) || '-' ||
                    LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))  || '-' ||
                    LTRIM(TO_CHAR(a.renew_no,'09')) policy
               INTO v_frpslist.policy_no
               FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c
              WHERE a.policy_id   = b.policy_id
                AND b.dist_no     = c.dist_no
                AND c.line_cd     = i.line_cd
                AND c.frps_yy     = i.frps_yy
                AND c.frps_seq_no = i.frps_seq_no;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
               NULL;
         END;
         
         BEGIN
             SELECT a.endt_iss_cd || ' - ' ||
                    LTRIM(TO_CHAR(a.endt_yy,'09')) || ' - ' ||
                    LTRIM(TO_CHAR(a.endt_seq_no,'099999')) endorsement
               INTO v_frpslist.endt_no
               FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c
              WHERE a.policy_id   = b.policy_id
                AND b.dist_no     = c.dist_no
                AND c.line_cd     = i.line_cd
                AND c.frps_yy     = i.frps_yy
                AND c.frps_seq_no = i.frps_seq_no;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
               NULL;
         END;
         
         BEGIN
         SELECT a.assd_name
           INTO v_frpslist.assd_name
           FROM giis_assured a, gipi_polbasic b, giuw_pol_dist c,
                giri_distfrps d
          WHERE a.assd_no     = b.assd_no
            AND b.policy_id   = c.policy_id
            AND c.dist_no     = d.dist_no
            AND d.line_cd     = i.line_cd
            AND d.frps_yy     = i.frps_yy
            AND d.frps_seq_no = i.frps_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              SELECT a.assd_name
                INTO v_frpslist.assd_name
                FROM giis_assured a, gipi_parlist b, giuw_pol_dist c,
                     giri_distfrps d
               WHERE a.assd_no     = b.assd_no
                 AND b.par_id      = c.par_id
                 AND c.dist_no     = d.dist_no
                 AND d.line_cd     = i.line_cd
                 AND d.frps_yy     = i.frps_yy
                 AND d.frps_seq_no = i.frps_seq_no;
         END;

         v_frpslist.line_cd         := i.line_cd;
         v_frpslist.frps_yy         := i.frps_yy;
         v_frpslist.frps_seq_no     := i.frps_seq_no;
         v_frpslist.frps_no         := i.frps_no;
         v_frpslist.ri_flag         := i.ri_flag;
         v_frpslist.dist_no         := i.dist_no;
         
         PIPE ROW (v_frpslist);
      END LOOP;

      RETURN;
   END get_giri_frpslist3;
   
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  December 10, 2012
   **  Reference By : GIUTS004 - Reverse Binder
   **  Description  :
   */
    FUNCTION get_giri_frpslist4 (
      p_user_id       GIIS_USERS.user_id%TYPE,
      p_module_id     GIIS_USER_GRP_MODULES.module_id%TYPE,
      p_line_cd       GIPI_PARLIST.line_cd%TYPE,
      p_frps_yy       GIRI_DISTFRPS.frps_yy%TYPE,
      p_frps_seq_no   GIRI_DISTFRPS.frps_seq_no%TYPE
   )      
      RETURN giri_distfrps_tab PIPELINED
   IS
      v_frpslist   giri_distfrps_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.frps_yy, a.frps_seq_no,
                       a.line_cd || '-' || 
                       LTRIM(TO_CHAR (a.frps_yy, '09')) || '-' || 
                       LTRIM(TO_CHAR (a.frps_seq_no, '00000009')) frps_no, 
                       a.dist_no, a.dist_seq_no, a.tsi_amt,
                       a.tot_fac_spct, a.tot_fac_tsi, a.prem_amt,
                       a.tot_fac_prem, a.ri_flag, a.user_id
                  FROM giri_distfrps a
                 WHERE a.ri_flag = '2'
                   AND UPPER(a.line_cd)  = UPPER(NVL(p_line_cd, a.line_cd))
                   AND a.frps_yy         = NVL(p_frps_yy, a.frps_yy)
                   AND a.frps_seq_no     = NVL(p_frps_seq_no, a.frps_seq_no)
                   AND EXISTS (SELECT 1
                                 FROM GIPI_POLBASIC d, 
                                      GIUW_POL_DIST b, 
                                      GIRI_DISTFRPS c
                                WHERE d.policy_id   = b.policy_id
                                  AND b.dist_no     = c.dist_no
                                  AND c.line_cd     = a.line_cd
                                  AND c.frps_yy     = a.frps_yy
                                  AND c.frps_seq_no = a.frps_seq_no
                                  AND d.pol_flag <> '5'
                                  AND check_user_per_line2 (d.line_cd, d.iss_cd, p_module_id, p_user_id) = 1
                                  AND Check_User_Per_Iss_Cd2 (d.line_cd,
                                          d.iss_cd,
                                          p_module_id, 
                                          p_user_id) = 1
                                  ))
      LOOP
         BEGIN
             SELECT a.line_cd || '-' ||
                    a.subline_cd || '-' ||
                    a.iss_cd || '-' ||
                    LTRIM(TO_CHAR(a.issue_yy,'09')) || '-' ||
                    LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))  || '-' ||
                    LTRIM(TO_CHAR(a.renew_no,'09')) policy
               INTO v_frpslist.policy_no
               FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c
              WHERE a.policy_id   = b.policy_id
                AND b.dist_no     = c.dist_no
                AND c.line_cd     = i.line_cd
                AND c.frps_yy     = i.frps_yy
                AND c.frps_seq_no = i.frps_seq_no;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
               NULL;
         END;
         
         BEGIN
             SELECT DECODE(NVL(a.endt_seq_no, 0),
                           0, NULL, 
                           a.endt_iss_cd || '-' || LTRIM(TO_CHAR(a.endt_yy,'09')) || '-' || LTRIM(TO_CHAR(a.endt_seq_no,'099999'))
                        ) endorsement
               INTO v_frpslist.endt_no
               FROM gipi_polbasic a, giuw_pol_dist b, giri_distfrps c
              WHERE a.policy_id   = b.policy_id
                AND b.dist_no     = c.dist_no
                AND c.line_cd     = i.line_cd
                AND c.frps_yy     = i.frps_yy
                AND c.frps_seq_no = i.frps_seq_no;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
               NULL;
         END;
         
         BEGIN
         SELECT a.assd_name
           INTO v_frpslist.assd_name
           FROM giis_assured a, gipi_polbasic b, giuw_pol_dist c,
                giri_distfrps d
          WHERE a.assd_no     = b.assd_no
            AND b.policy_id   = c.policy_id
            AND c.dist_no     = d.dist_no
            AND d.line_cd     = i.line_cd
            AND d.frps_yy     = i.frps_yy
            AND d.frps_seq_no = i.frps_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              SELECT a.assd_name
                INTO v_frpslist.assd_name
                FROM giis_assured a, gipi_parlist b, giuw_pol_dist c,
                     giri_distfrps d
               WHERE a.assd_no     = b.assd_no
                 AND b.par_id      = c.par_id
                 AND c.dist_no     = d.dist_no
                 AND d.line_cd     = i.line_cd
                 AND d.frps_yy     = i.frps_yy
                 AND d.frps_seq_no = i.frps_seq_no;
         END;

         v_frpslist.line_cd         := i.line_cd;
         v_frpslist.frps_yy         := i.frps_yy;
         v_frpslist.frps_seq_no     := i.frps_seq_no;
         v_frpslist.frps_no         := i.frps_no;
         v_frpslist.ri_flag         := i.ri_flag;
         v_frpslist.dist_no         := i.dist_no;
         
         PIPE ROW (v_frpslist);
      END LOOP;

      RETURN;
   END get_giri_frpslist4;
   
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Set the ri_flag of GIRI_DISTFRPS to '3' which means reversed.
     */
    PROCEDURE update_distfrps (
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_dist_no       IN giuw_pol_dist.dist_no%TYPE
    )
    IS
    BEGIN
      giri_wfrps_peril_grp_pkg.copy_frps_peril_grp(p_line_cd, p_frps_yy, p_frps_seq_no);
      UPDATE giri_distfrps
         SET ri_flag     = '3'
       WHERE line_cd     = p_line_cd
         AND frps_yy     = p_frps_yy
         AND frps_seq_no = p_frps_seq_no;
         
      UPDATE giuw_pol_dist
         SET dist_flag = '2'
       WHERE dist_no = p_dist_no; 
      
      FOR A1 IN
          ( SELECT policy_id
              FROM giuw_pol_dist
             WHERE dist_no = p_dist_no
          ) LOOP   
          UPDATE gipi_polbasic
             SET dist_flag = '2'
           WHERE policy_id = a1.policy_id;
          EXIT;
      END LOOP;  
    END update_distfrps;
   
    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    CHECK_FOR_RI_RECORDS program unit  
    **/   
    PROCEDURE CHECK_FOR_RI_RECORDS(
        p_dist_no       giri_distfrps.dist_no%TYPE,
        p_ri_sw     OUT VARCHAR2
        ) IS
    BEGIN
      p_ri_sw := 'N';
      FOR A IN(SELECT dist_seq_no
                 FROM giuw_policyds
                WHERE dist_no = p_dist_no)
      LOOP
        FOR B IN(SELECT '1'
                   FROM giri_distfrps
                  WHERE dist_no = p_dist_no
                    AND dist_seq_no = a.dist_seq_no)
        LOOP
            p_ri_sw := 'Y';
        END LOOP;
        IF p_ri_sw = 'Y' THEN
          EXIT;
        END IF;
      END LOOP;  
    END;
    
    /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : The procedure CREATE_GIRI_DISTFRPS 
    */
    PROCEDURE CREATE_GIRI_DISTFRPS_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                    p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                    p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      CURSOR distfrps_area IS
        SELECT T1.line_cd, frps_yy, frps_seq_no,
               op_group_no, op_frps_yy, op_frps_seq_no,          
               T1.dist_no, dist_seq_no, T1.tsi_amt,                
               tot_fac_spct, tot_fac_tsi, T1.prem_amt,               
               tot_fac_prem, loc_voy_unit, op_sw,                  
               ri_flag, currency_cd, currency_rt,  
               T1.create_date, T1.user_id, prem_warr_sw, 
               claims_coop_sw, claims_control_sw
          FROM giri_wdistfrps T1
         WHERE T1.line_cd     = p_line_cd
           AND T1.frps_yy     = p_frps_yy
           AND T1.frps_seq_no = p_frps_seq_no;

    BEGIN
      FOR c1_rec IN distfrps_area LOOP
        INSERT INTO giri_distfrps  
          (line_cd, frps_yy, frps_seq_no,           
           op_group_no, op_frps_yy, op_frps_seq_no,          
           dist_no, dist_seq_no, tsi_amt,               
           tot_fac_spct, tot_fac_tsi, prem_amt,               
           tot_fac_prem, loc_voy_unit, op_sw,                  
           ri_flag, currency_cd, currency_rt,  
           create_date, user_id, prem_warr_sw, 
           claims_coop_sw, claims_control_sw)
        VALUES
          (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
           c1_rec.op_group_no, c1_rec.op_frps_yy, c1_rec.op_frps_seq_no,          
           c1_rec.dist_no, c1_rec.dist_seq_no, c1_rec.tsi_amt,                
           c1_rec.tot_fac_spct, c1_rec.tot_fac_tsi, c1_rec.prem_amt,               
           c1_rec.tot_fac_prem, c1_rec.loc_voy_unit, c1_rec.op_sw,                  
           c1_rec.ri_flag, c1_rec.currency_cd, c1_rec.currency_rt,  
           c1_rec.create_date, c1_rec.user_id, c1_rec.prem_warr_sw, 
           c1_rec.claims_coop_sw, c1_rec.claims_control_sw);
      END LOOP;
    END CREATE_GIRI_DISTFRPS_GIUTS021;

END giri_distfrps_pkg;
/



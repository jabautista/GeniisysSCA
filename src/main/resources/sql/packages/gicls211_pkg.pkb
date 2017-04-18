CREATE OR REPLACE PACKAGE BODY CPI.GICLS211_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 09.02.2013
   **  Reference By      : GICLS211 - LOSS PROFILE
   **
   */
AS
   FUNCTION when_new_form_instance
     RETURN gicls211_param_tab PIPELINED
   AS
      line_en		   VARCHAR2(4); 
      cur_exist		VARCHAR2(1) := 'N';
      v_row          gicls211_param_type;
   BEGIN
      FOR c1 IN (SELECT param_value_v
                   FROM giis_parameters
                  WHERE param_name = 'EN')
      LOOP
         cur_exist := 'Y';
         line_en := c1.param_value_v;
      END LOOP;
      
      IF cur_exist = 'N' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No such parameter as ''EN'' in system parameters.  Please do the necessary actions or contact your DBA.');
      END IF;
      
      cur_exist := 'N';
      
      FOR c1 IN (SELECT c.line_name
                   FROM giis_line c
                  WHERE c.line_cd = line_en)
      LOOP
         cur_exist := 'Y';
      END LOOP;
      
      
      v_row.line_cd_mc := giisp.v('LINE_CODE_MC');
      v_row.line_cd_fi := giisp.v('LINE_CODE_FI');
      v_row.cur_exist := cur_exist;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_risk_profile_list(
      p_user_id             giis_users.user_id%TYPE,
      p_module_id           giis_modules.module_id%TYPE
   ) RETURN risk_profile_tab PIPELINED AS
      res                   risk_profile_type;
   BEGIN
      FOR i IN (SELECT DISTINCT line_cd, subline_cd, user_id 
                  FROM gicl_loss_profile
                 WHERE user_id = p_user_id 
                   AND line_cd = DECODE(check_user_per_line2(line_cd, NULL, p_module_id, p_user_id), 1, line_cd, NULL)
                 ORDER BY line_cd, NVL(subline_cd, '1'))
      LOOP
         res.line_cd := i.line_cd;
         res.subline_cd := i.subline_cd;
         res.user_id := i.user_id;
         
         res.dsp_line_name := NULL;
         FOR c IN(SELECT line_name
                    FROM giis_line
                   WHERE line_cd = i.line_cd)
         LOOP
            res.dsp_line_name := c.line_name;
            EXIT;
         END LOOP;
          
         FOR c IN (SELECT date_from, date_to, range_from, range_to, loss_date_from, loss_date_to
                     FROM gicl_loss_profile
                    WHERE line_cd = i.line_cd
                      AND user_id = p_user_id
                      AND NVL(subline_cd, '%') LIKE NVL(i.subline_cd, NVL(subline_cd, '%')))
         LOOP   
            res.date_from := TO_CHAR(c.date_from, 'mm-dd-yyyy');
            res.date_to := TO_CHAR(c.date_to, 'mm-dd-yyyy');
            res.loss_date_from := TO_CHAR(c.loss_date_from, 'mm-dd-yyyy');
            res.loss_date_to := TO_CHAR(c.loss_date_to, 'mm-dd-yyyy');
         END LOOP;
         
         res.dsp_subline_name := NULL;
         FOR c IN (SELECT subline_name
                     FROM giis_subline
                    WHERE subline_cd = i.subline_cd
                      ANd line_cd    = i.line_cd)             
         LOOP
            res.dsp_subline_name := c.subline_name;
            EXIT;
         END LOOP;
         
         IF res.dsp_line_name IS NOT NULL THEN
            FOR c1 IN (SELECT line_cd
                         FROM giis_line
                        WHERE line_name = res.dsp_line_name)
            LOOP
               res.cur_exist := 'Y';
               res.cg$ctrl_line_cd := c1.line_cd;
            END LOOP;
         ELSE 
            res.cg$ctrl_line_cd := NULL;		
         END IF;
         
         res.no_of_range := NULL;
         FOR c IN (SELECT COUNT(1) no_of_range
                     FROM TABLE(gicls211_pkg.get_range_list(i.line_cd, i.subline_cd, p_user_id, NVL(p_module_id, 'GICLS211'))))
         LOOP
            res.no_of_range := c.no_of_range;
            EXIT;
         END LOOP;
         
         res.gicls212_access := check_user_per_line2(i.line_cd, NULL, 'GICLS212', p_user_id);
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   FUNCTION get_range_list(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      p_user_id             gicl_loss_profile.user_id%TYPE,
      p_module_id           giis_modules.module_id%TYPE
   ) RETURN range_tab PIPELINED AS
      res                   range_type;
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, range_from, range_to, user_id
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line_cd
                   AND (subline_cd = p_subline_cd OR (subline_cd IS NULL AND p_subline_cd IS NULL))
                   AND user_id = p_user_id
                   AND check_user_per_line2(line_cd, NULL, p_module_id, p_user_id) = 1
                 ORDER BY line_cd, range_from)
      LOOP
         res.line_cd := i.line_cd;
         res.subline_cd := i.subline_cd;
         res.range_from := i.range_from;
         res.range_to := i.range_to;
         res.user_id := i.user_id;
        
         PIPE ROW(res);
      END LOOP;
   END;
   
   FUNCTION get_subline_lov(
      p_line_cd             giis_subline.line_cd%TYPE,
      p_module_id           giis_modules.module_id%TYPE,
      p_user_id             giis_users.user_id%TYPE
   ) RETURN subline_lov_tab PIPELINED AS
      res                   subline_lov_type;
   BEGIN
      FOR i IN (SELECT a.subline_name, a.subline_cd, a.line_cd 
                  FROM giis_subline a 
                 WHERE a.line_cd = NVL(p_line_cd, a.line_cd) 
                   AND check_user_per_iss_cd2(a.line_cd, NULL, p_module_id, p_user_id) = 1
                 ORDER BY a.subline_name)
      LOOP
         res.subline_cd := i.subline_cd;
         res.subline_name := i.subline_name;
         res.line_cd := i.line_cd;
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   PROCEDURE delete_profile_line_subline(
      p_user_id             IN giis_users.user_id%TYPE,
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_dsp_subline_name    IN giis_subline.subline_name%TYPE,
      p_type                IN VARCHAR2,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          OUT gicl_loss_profile.subline_cd%TYPE
   ) AS
      v_line                giis_line.line_cd%TYPE;
      v_sline_cd            giis_subline.subline_cd%TYPE; 
   BEGIN
      IF p_type = 'line_subline' THEN
         FOR A IN (SELECT line_cd
                     FROM giis_line
                    WHERE line_name = p_dsp_line_name)
         LOOP  
            v_line := a.line_cd;
         END LOOP;
         
         FOR B IN(SELECT subline_cd
                    FROM giis_subline
                   WHERE line_cd = v_line
                     AND subline_name = p_dsp_subline_name)
         LOOP
            v_sline_cd := b.subline_cd;
         END LOOP;
         
         DELETE FROM gicl_loss_profile
          WHERE line_cd    = v_line
            AND subline_cd = v_sline_cd;
      
      ELSIF p_type = 'all_line_subline' THEN
         DELETE FROM gicl_loss_profile
          WHERE user_id = p_user_id
            AND subline_cd IS NOT NULL;
      END IF;
         
      p_line_cd := v_line;
      p_subline_cd := v_sline_cd;
   END;
   
   PROCEDURE save_line_subline_range(
      p_user_id             IN giis_users.user_id%TYPE,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_type                IN VARCHAR2
   ) AS
   BEGIN
--   raise_application_error (-20001, p_date_from||' - '||    p_date_to);
      IF p_type = 'line_subline' THEN
         INSERT INTO gicl_loss_profile
               (line_cd,			subline_cd,			user_id,
                range_from,		    range_to,			policy_count,
                net_retention,	    quota_share,	    treaty,		
                facultative,		date_from,			date_to,	
                loss_date_from,	    loss_date_to)

         VALUES(p_line_cd,			p_subline_cd,		p_user_id,
                p_range_from,	    p_range_to,         0,
	            0,				    0,				    0,
	            0,				    p_date_from,        p_date_to, 
                NVL(p_loss_date_from, p_date_from),     NVL(p_loss_date_to, p_date_to));
      ELSIF p_type = 'all_line_subline' THEN
         FOR a IN (SELECT line_cd
                     FROM giis_line)
         LOOP
            FOR b IN (SELECT subline_cd
		                FROM giis_subline
	 	               WHERE line_cd = a.line_cd)
            LOOP
               INSERT INTO gicl_loss_profile
                     (line_cd,		    subline_cd,	    user_id,
                      range_from,		range_to,		policy_count,
                      net_retention,	quota_share,    treaty,
                      facultative,		date_from,	    date_to,
                      loss_date_from,   loss_date_to)

               VALUES(a.line_cd,	    b.subline_cd,	p_user_id,
	                  p_range_from,     p_range_to,	    0,
	                  0,			    0,				0,	
	                  0,		        p_date_from,    p_date_to, 
                      NVL(p_loss_date_from, p_date_from), NVL(p_loss_date_to, p_date_to));
            END LOOP;
         END LOOP;
      ELSIF p_type = 'line' THEN
         INSERT INTO gicl_loss_profile
               (line_cd,		subline_cd,	    user_id,
                range_from,		range_to,		policy_count,
                net_retention,  quota_share,    treaty,		
                facultative,	date_from,		date_to,	
                loss_date_from, loss_date_to)
         VALUES(p_line_cd,      p_subline_cd,	p_user_id,
                p_range_from,   p_range_to,	    0,
	            0,              0,              0,
	            0,              p_date_from,    p_date_to, 
                NVL(p_loss_date_from, p_date_from), NVL(p_loss_date_to, p_date_to));  
      END IF;
   END;
   
   PROCEDURE delete_profile_line(
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE
   ) AS
      v_line                giis_line.line_cd%TYPE; 
   BEGIN
      FOR A IN (SELECT line_cd
                  FROM giis_line
                 WHERE line_name = p_dsp_line_name)
      LOOP  
         v_line := a.line_cd;
      END LOOP;

      DELETE FROM gicl_loss_profile
       WHERE line_cd = v_line
         AND subline_cd IS NULL;
         
      p_line_cd := v_line;
   END;
   
   PROCEDURE delete_line_and_subline(
      p_user_id             IN giis_users.user_id%TYPE,
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE
   ) AS
      v_line                giis_line.line_cd%TYPE;
   BEGIN
      FOR A IN (SELECT line_cd
                  FROM giis_line
                 WHERE line_name = p_dsp_line_name)
      LOOP  
         v_line := a.line_cd;
      END LOOP;

      DELETE FROM gicl_loss_profile
       WHERE user_id = p_user_id
         AND line_cd = v_line; 
      
      p_line_cd := v_line;
   END;
   
   PROCEDURE save_line_and_subline_range(
      p_user_id             IN giis_users.user_id%TYPE,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE
   ) AS
      v_sline_cd            giis_subline.subline_cd%TYPE;
   BEGIN
      FOR b IN (SELECT subline_cd 
	              FROM giis_subline
                 WHERE line_cd = p_line_cd)
      LOOP
         v_sline_cd := b.subline_cd;
         
         INSERT INTO gicl_loss_profile
               (line_cd,		subline_cd,	    user_id,
                range_from,		range_to,		policy_count,
                net_retention,	quota_share,    treaty,
                facultative,	date_from,	    date_to,
                loss_date_from, loss_date_to)
         VALUES(p_line_cd,		v_sline_cd,	    p_user_id,
                p_range_from,   p_range_to,		0,
		        0,              0,              0,
		        0,              p_date_from,    p_date_to, 
        	    NVL(p_loss_date_from, p_date_from), NVL(p_loss_date_to, p_date_to)); 
      END LOOP;
   END;
   
   PROCEDURE delete_all_line(
      p_user_id             IN giis_users.user_id%TYPE
   ) AS
   BEGIN
      DELETE FROM gicl_loss_profile
       WHERE user_id = p_user_id
         AND subline_cd IS NULL;
   END;
   
   PROCEDURE save_all_line(
      p_user_id             IN giis_users.user_id%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE
   ) AS
      v_line                giis_line.line_cd%TYPE;
   BEGIN
      FOR a IN (SELECT line_cd
                  FROM giis_line)
      LOOP
         v_line := a.line_cd;
         
         INSERT INTO gicl_loss_profile(line_cd,		   subline_cd,	user_id,
                                       range_from,	   range_to,	policy_count,
                                       net_retention,  quota_share, treaty,
                                       facultative,	   date_from,	date_to,
                                       loss_date_from, loss_date_to)
         VALUES(a.line_cd,      NULL,		    p_user_id,
                p_range_from,   p_range_to,     0,
	            0,			    0,				0,
	            0,	 			p_date_from,    p_date_to, 
                NVL(p_loss_date_from, p_date_from), NVL(p_loss_date_to, p_date_to));
      END LOOP;
   END;
   
   PROCEDURE extract_loss_profile(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_extract_by_rg       IN NUMBER,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   ) AS
   BEGIN
      IF p_extract_by_rg = 1 THEN      
         loss_profile_extract_tsi(p_user_id, p_param_date, p_claim_date, p_line_cd, p_subline_cd, p_date_from, p_date_to, p_loss_date_from, p_loss_date_to,
                                  p_e_type, p_var_ext, p_message);
      ELSE
         loss_profile_extract_loss_amt(p_user_id, p_param_date, p_claim_date, p_line_cd, p_subline_cd, p_date_from, p_date_to,
                                       p_loss_date_from, p_loss_date_to, p_e_type, p_var_ext, p_message);
      END IF;
   END;
   
   PROCEDURE loss_profile_extract_tsi(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   ) AS
      TYPE treaty_type IS TABLE OF gicl_loss_profile.treaty%TYPE INDEX BY BINARY_INTEGER;
      v_treaty              treaty_type;
      v_update              VARCHAR2(32000); 
      v_treatyx             gicl_loss_profile.treaty%TYPE;
      v_policy_count        NUMBER := 0;                            
      rec_counter           NUMBER := 0;
      v_tsi_amt             gipi_polbasic.tsi_amt%TYPE := 0;
      v_acct_trty_type      giis_dist_share.acct_trty_type%TYPE;
      v_range_from          gicl_loss_profile.range_from%TYPE;
      v_range_to            gicl_loss_profile.range_to%TYPE;
      v_net_retention       gicl_loss_profile.net_retention%TYPE;
      v_quota_share         gicl_loss_profile.quota_share%TYPE;  
      v_facultative         gicl_loss_profile.facultative%TYPE; 
      v_rec_net_retention   gicl_loss_profile.net_retention%TYPE;
      v_quota_share2        gicl_loss_profile.quota_share%TYPE;
      v_rec_treaty          gicl_loss_profile.treaty%TYPE;
      v_rec_treaty1         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty2         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty3         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty4         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty5         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty6         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty7         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty8         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty9         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty10        gicl_loss_profile.treaty%TYPE;
      v_rec_facultative     gicl_loss_profile.facultative%TYPE; 
      v_exist               VARCHAR2(1) := 'N';
      v_chk_ext             NUMBER := 0;
      v_xol                 gicl_loss_profile.xol_treaty%TYPE;
      v_param_value_v       giac_parameters.param_value_v%TYPE;
      v_count               NUMBER(4);
      v_value0              NUMBER(16,2) := 0;
      v_value00              NUMBER(16,2) := 0;
      v_value1              NUMBER(4);     
      v_index                 NUMBER(2) := 0;
                                                        
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_param_value_v
           FROM giac_parameters
          WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
      EXCEPTION
         WHEN no_data_found THEN
            v_param_value_v := null;
      END;
      
      IF p_e_type = 1 THEN
         gicls211_pkg.get_loss_ext(p_claim_date, p_loss_date_from, p_loss_date_to, p_line_cd, p_subline_cd, p_user_id);
         gicls211_pkg.get_loss_ext2(p_param_date, p_date_from, p_date_to, p_line_cd, p_subline_cd, p_user_id);
      ELSIF p_e_type = 2 THEN
         IF p_line_cd = 'MC' THEN
            gicls211_pkg.get_loss_ext_motor(p_claim_date, p_loss_date_from, p_loss_date_to,p_line_cd, p_subline_cd, p_user_id);
            gicls211_pkg.get_loss_ext2_motor(p_param_date, p_date_from, p_date_to, p_line_cd, p_subline_cd, p_user_id);
         ELSIF p_line_cd = 'FI' THEN
            gicls211_pkg.get_loss_ext_fire(p_claim_date, p_loss_date_from, p_loss_date_to,p_line_cd, p_subline_cd, p_user_id);
            gicls211_pkg.get_loss_ext2_fire(p_param_date, p_date_from, p_date_to, p_line_cd, p_subline_cd, p_user_id);
         END IF;
      ELSIF p_e_type = 3 THEN
         gicls211_pkg.get_loss_ext_peril(p_claim_date, p_loss_date_from, p_loss_date_to,p_line_cd, p_subline_cd, p_user_id);
         gicls211_pkg.get_loss_ext2_peril(p_param_date, p_date_from, p_date_to, p_line_cd, p_subline_cd, p_user_id);
      END IF;
  
      FOR A IN (SELECT 1
                  FROM gicl_loss_profile
                 WHERE user_id = p_user_id) 
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exist = 'Y' THEN       
         BEGIN
            FOR RNG IN (SELECT range_from, range_to, line_cd, subline_cd
                          FROM gicl_loss_profile 
                         WHERE line_cd              = NVL(p_line_cd, line_cd)
                           AND NVL(subline_cd, '1') = NVL(p_subline_cd, '1')
                           AND user_id              = p_user_id)
            LOOP
               --initialize variables
               v_range_from    := rng.range_from;
               v_range_to      := rng.range_to; 
               v_net_retention := 0;
               v_quota_share   := 0;
               v_treatyx       := 0;
               v_facultative   := 0;
               v_policy_count  := 0;
               v_tsi_amt       := 0;
               v_xol	       := 0;
               v_index         := 0; -- mgm 12.15.2015 SR 5174 refresh the treaty index for every new range
               --GRP_CREATE('TREATY');

               FOR tsi IN (SELECT tsi_amt,  cnt_clm, tsi.line_cd, tsi.subline_cd, tsi.pol_iss_cd, tsi.issue_yy, tsi.pol_seq_no, tsi.renew_no
                             FROM gicl_loss_profile_ext2 tsi, gicl_loss_profile_ext clm 
                            WHERE 1 = 1
                              AND tsi.line_cd              = p_line_cd
                              AND tsi.line_cd              = clm.line_cd
                              AND NVL(tsi.subline_cd, '1') = NVL(p_subline_cd, NVL(tsi.subline_cd, '1'))
                              AND tsi.subline_cd           = clm.subline_cd
                              AND tsi.pol_iss_cd           = clm.pol_iss_cd
                              AND tsi.issue_yy             = clm.issue_yy
                              AND tsi.pol_seq_no           = clm.pol_seq_no
                              AND tsi.renew_no             = clm.renew_no
                              AND tsi.tsi_amt              >= v_range_from
                              AND tsi.tsi_amt              <= v_range_to)
               LOOP  
                  v_tsi_amt   := NVL(v_tsi_amt,0) + NVL(tsi.tsi_amt,0);
                  rec_counter := rec_counter + 1;
                  v_chk_ext   := 1;
                  v_policy_count := NVL(v_policy_count,0) + tsi.cnt_clm;

                  /* extraction of data from net retention, facultative and treaty*/
                  FOR a IN (SELECT c018.grp_seq_no, c018.share_type, SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) loss
                              FROM gicl_claims       c003,
                                   gicl_clm_res_hist c017,
                                   gicl_reserve_ds   c018
                             WHERE 1=1
                               AND c003.line_cd          = tsi.line_cd
                               AND c003.subline_cd       = tsi.subline_cd
                               AND c003.pol_iss_cd       = tsi.pol_iss_cd
                               AND c003.issue_yy         = tsi.issue_yy
                               AND c003.pol_seq_no       = tsi.pol_seq_no
                               AND c003.renew_no         = tsi.renew_no
                               AND c003.claim_id         = c017.claim_id
                               AND c017.claim_id         = c018.claim_id
                               AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                               AND NVL(c017.dist_sw,'N') = 'Y'
                               AND c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
                               AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                       'LD', TRUNC(c003.loss_date),SYSDATE) >=Trunc(p_loss_date_from)   
                               AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                       'LD', TRUNC(c003.loss_date),SYSDATE) <=Trunc(p_loss_date_to)
                             GROUP BY c018.grp_seq_no,c018.share_type)
                  LOOP   
                     IF a.share_type = '1' THEN
                        v_net_retention := NVL(v_net_retention,0) + NVL(a.loss,0);
                     ELSIF a.share_type = '3' THEN
                        v_facultative := NVL(v_facultative,0) + NVL(a.loss,0);
                     ELSIF a.share_type = '2' THEN
                        v_treatyx := NVL(v_treatyx,0) + NVL(a.loss,0);                
                        --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
                        
                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(a.grp_seq_no, a.loss);
                     ELSIF a.share_type = v_param_value_v THEN
                        v_xol := NVL(v_xol,0) + NVL(a.loss,0);  
                              
                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(a.grp_seq_no, a.loss);
            
                     END IF;
                      
                  END LOOP;                   
               
                  FOR b IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_le_net_amt,0)) loss, c003.claim_id
                              FROM gicl_claims       c003,
                                   gicl_clm_res_hist c017,
                                   gicl_clm_loss_exp c016, 
                                   gicl_loss_exp_ds   c018   	                              
                             WHERE c003.line_cd          = tsi.line_cd
                               AND c003.subline_cd       = tsi.subline_cd
                               AND c003.pol_iss_cd       = tsi.pol_iss_cd
                               AND c003.issue_yy         = tsi.issue_yy
                               AND c003.pol_seq_no       = tsi.pol_seq_no
                               AND c003.renew_no         = tsi.renew_no
                               AND c003.claim_id         = c017.claim_id
                               AND NVL(c017.cancel_tag,'N') = 'N'
                               AND c017.tran_id IS NOT NULL
                               AND c003.clm_stat_cd = 'CD'
                               AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                       'LD', TRUNC(c003.loss_date),SYSDATE)>=TRUNC(p_loss_date_from)   
                               AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                       'LD', TRUNC(c003.loss_date),SYSDATE)<=TRUNC(p_loss_date_to)
                               AND c016.claim_id = c017.claim_id
                               AND c016.tran_id  = c017.tran_id
                               AND c016.item_no  = c017.item_no
                               AND c016.peril_cd = c017.peril_cd
                               AND c018.claim_id = c016.claim_id     
                               AND c018.clm_loss_id = c016.clm_loss_id     
                               AND nvl(c018.negate_tag, 'N') = 'N'     
                             GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type, c003.claim_id)
                  LOOP
                     IF b.share_type = '1' THEN
                        v_net_retention := NVL(v_net_retention,0) + NVL(b.loss,0);
                     ELSIF b.share_type = '3' THEN
                        v_facultative := NVL(v_facultative,0) + NVL(b.loss,0);
                     ELSIF b.share_type = '2' THEN
                        v_treatyx := NVL(v_treatyx,0) + NVL(b.loss,0);                 
                        --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                         
                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(b.grp_seq_no, b.loss);
                     ELSIF b.share_type = v_param_value_v THEN
                        v_xol := NVL(v_xol,0) + NVL(b.loss,0);                 
                         --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');

                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(b.grp_seq_no, b.loss);
                     END IF;
                  END LOOP;                            

                  --FOR RECOVERY
                  --extract data for net retention, facultative and treaty
                  FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                         FROM gicl_claims        c003,
                                              gicl_recovery_payt c017,
                                              gicl_recovery_ds   c018
                                        WHERE c003.line_cd          = tsi.line_cd
                                          AND c003.subline_cd       = tsi.subline_cd
                                          AND c003.pol_iss_cd       = tsi.pol_iss_cd
                                          AND c003.issue_yy         = tsi.issue_yy
                                          AND c003.pol_seq_no       = tsi.pol_seq_no
                                          AND c003.renew_no         = tsi.renew_no
                                          AND c003.claim_id         = c017.claim_id
                                          AND NVL(c017.cancel_tag,'N') = 'N'
                                          AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                                  'LD', TRUNC(c003.loss_date),SYSDATE)>=TRUNC(p_loss_date_from)   
                                          AND DECODE(p_claim_date,'FD', TRUNC(c003.clm_file_date),
                                                                  'LD', TRUNC(c003.loss_date),SYSDATE)<=TRUNC(p_loss_date_to)
                                          AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                          AND c017.claim_id = c003.claim_id
                                          AND c017.recovery_id = c018.recovery_id
                                          AND c017.recovery_payt_id = c018.recovery_payt_id
                                          AND nvl(c018.negate_tag, 'N') = 'N'     
                                        GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
                  LOOP
                     IF get_recovery.share_type = '1' THEN
                        v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
                     ELSIF get_recovery.share_type = '3' THEN
                        v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
                     ELSIF get_recovery.share_type = '2' THEN
                        v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);                
                        --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');

                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);
                     ELSIF get_recovery.share_type = v_param_value_v THEN
                        v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);                
                        --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');

                        INSERT INTO gicls211_treaty_temp
                              (treaty_cd, treaty)
                        VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);
                     END IF;
                  END LOOP;                                
               END LOOP;  

               SELECT count(treaty_cd) 
                 INTO v_count
                 FROM gicls211_treaty_temp;
   
               IF v_count > 0 THEN                   
                  FOR query_cur IN (SELECT SUM(treaty) treaty, treaty_cd
                                      FROM gicls211_treaty_temp
                                     GROUP BY treaty_cd)
                  LOOP
                     v_index := v_index + 1;
                     v_update  := 'UPDATE gicl_loss_profile
                                      SET policy_count               = NVL('||''''||v_policy_count||''''||',policy_count),
                                          total_tsi_amt              = NVL('||''''||v_tsi_amt||''''||',total_tsi_amt),
                                          net_retention              = NVL('||''''||v_net_retention||''''||',net_retention),
                                          quota_share                = NVL('||''''||v_quota_share||''''||',quota_share),
                                          treaty'||v_index||'_loss   = NVL('||''''||query_cur.treaty||''''||', treaty'||v_index||'_loss),
                                          treaty'||v_index||'_cd     = NVL('||''''||query_cur.treaty_cd||''''||', treaty'||v_index||'_cd),
                                          treaty                     = NVL('||''''||v_treatyx||''''||',treaty),																	 
                                          facultative                = NVL('||''''||v_facultative||''''||',facultative),
                                          xol_treaty	               = NVL('||''''||v_xol||''''||',xol_treaty)    
                                    WHERE line_cd                    = '||''''||rng.line_cd||''''||'							       
                                      AND NVL(subline_cd, '||''''||'1'||''''||') = NVL('||''''||RNG.subline_CD||''''||', '||''''||'1'||''''||')
                                      AND range_from                 = '||''''||rng.range_from||''''||'
                                      AND range_to                   = '||''''||rng.range_to||''''||'
                                      AND user_id                    = '||''''||p_user_id||''''||'';
                            EXEC_IMMEDIATE(v_update);	
                  END LOOP;
               ELSE
                  UPDATE gicl_loss_profile
                     SET policy_count  = NVL(v_policy_count,policy_count),
                         total_tsi_amt = NVL(v_tsi_amt,total_tsi_amt),
                         net_retention = NVL(v_net_retention,net_retention),
                         quota_share   = NVL(v_quota_share,quota_share),
                         treaty        = NVL(v_treatyx,treaty),              
                         facultative   = NVL(v_facultative,facultative),
                         xol_treaty		= NVL(v_xol,xol_treaty)
                   WHERE line_cd              = rng.line_cd
                     AND NVL(subline_cd, '1') = NVL(rng.subline_cd, '1')
                     AND range_from           = rng.range_from
                     AND range_to             = rng.range_to
                     AND user_id              = p_user_id;	
               END IF;	
            END LOOP;
             
            IF v_chk_ext != 1 THEN
               p_var_ext := 'N';
               p_message := 'Extraction finished. No records extracted.';
            ELSE
               p_var_ext := 'Y';
               p_message := 'Extraction finished. ' || rec_counter || ' records extracted.';        
            END IF;
             
         END;
      ELSE
         p_var_ext := 'N';
         p_message := 'Extraction finished. No records extracted.';
      END IF;
   END;

   PROCEDURE get_loss_ext(
      p_loss_sw  IN VARCHAR2,
      p_loss_fr  IN DATE,
      p_loss_to  IN DATE,
      p_line_cd  IN VARCHAR2,
      p_subline  IN VARCHAR2,
      p_user_id  IN giis_users.user_id%TYPE
   ) AS
      TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
      TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
      vv_cnt_clm               cnt_clm_tab;
      vv_line_cd               line_cd_tab;
      vv_subline_cd            subline_cd_tab;
      vv_pol_iss_cd            pol_iss_cd_tab;
      vv_issue_yy              issue_yy_tab;
      vv_pol_seq_no            pol_seq_no_tab;
      vv_renew_no              renew_no_tab;
   BEGIN
      DELETE FROM GICL_LOSS_PROFILE_EXT;

      SELECT COUNT(c003.claim_id) cnt_clm, c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no
        BULK COLLECT INTO
             vv_cnt_clm, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy, vv_pol_seq_no, vv_renew_no
        FROM gicl_claims c003
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >= TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <= TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline, c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd, c003.pol_iss_cd, 'GICLS211', p_user_id) = 1
       GROUP BY c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no;
      
       IF SQL%FOUND THEN
          FORALL i IN vv_line_cd.first..vv_line_cd.last
             INSERT INTO GICL_LOSS_PROFILE_EXT
                   (cnt_clm,       line_cd,         subline_cd,
                    pol_iss_cd,     issue_yy,    pol_seq_no,
                    renew_no)
             VALUES(vv_cnt_clm(i),      vv_line_cd(i),      vv_subline_cd(i),
                    vv_pol_iss_cd(i),   vv_issue_yy(i),     vv_pol_seq_no(i),
                    vv_renew_no(i));
--          COMMIT;
       END IF;
   END get_loss_ext;
   
   PROCEDURE get_loss_ext2(
      p_pol_sw      IN VARCHAR2,
      p_date_fr     IN DATE,
      p_date_to     IN DATE,
      p_line_cd     IN VARCHAR2,
      p_subline     IN VARCHAR2,
      p_user_id     IN giis_users.user_id%TYPE
   ) AS
      TYPE tsi_amt_tab          IS TABLE OF gicl_loss_profile_ext2.tsi_amt%TYPE;
      TYPE line_cd_tab          IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab       IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab       IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab         IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab       IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab         IS TABLE OF gicl_claims.renew_no%TYPE;
      vv_tsi_amt                tsi_amt_tab;
      vv_line_cd                line_cd_tab;
      vv_subline_cd             subline_cd_tab;
      vv_pol_iss_cd             pol_iss_cd_tab;
      vv_issue_yy               issue_yy_tab;
      vv_pol_seq_no             pol_seq_no_tab;
      vv_renew_no               renew_no_tab;
   BEGIN   
      DELETE FROM gicl_loss_profile_ext2;

      SELECT SUM(NVL(b250.tsi_amt,0)) tsi_amt, b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no
        BULK COLLECT INTO
             vv_tsi_amt, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy, vv_pol_seq_no, vv_renew_no
        FROM gipi_polbasic b250
       WHERE 1 = 1
         AND b250.line_cd    = p_line_cd
         AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
         AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                             'ED',TRUNC(b250.eff_date),
                             'AD',TRUNC(b250.acct_ent_date),
                             'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
         AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                             'ED',TRUNC(b250.eff_date),
                             'AD',TRUNC(b250.acct_ent_date),
                             'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to)
         AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1)) > TRUNC(p_date_to)
         AND pol_flag IN ('1','2','3','X')
         AND dist_flag      = '3'
         AND EXISTS (SELECT 1
                       FROM gicl_loss_profile_ext B
                      WHERE B250.LINE_CD = B.LINE_CD
                        AND B250.SUBLINE_CD = B.SUBLINE_cD
                        AND B250.ISS_CD = B.POL_ISS_CD
                        AND B250.ISSUE_YY = B.ISSUE_YY
                        AND B250.POL_SEQ_NO = B.POL_SEQ_NO
                        AND B250.RENEW_NO = B.RENEW_NO)
         AND (b250.endt_seq_no = 0
               OR (b250.endt_seq_no <> 0
              AND EXISTS (SELECT 1
                            FROM gipi_polbasic c
                           WHERE b250.line_cd = c.line_cd
                             AND b250.subline_cd = c.subline_cd
                             AND b250.iss_cd = c.iss_cd
                             AND b250.issue_yy = c.issue_yy
                             AND b250.pol_seq_no = c.pol_seq_no
                             AND b250.renew_no = c.renew_no
                             AND b250.endt_seq_no = 0
                             AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                                 'ED',TRUNC(c.eff_date),
                                                 'AD',TRUNC(c.acct_ent_date),
                                                 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
                             AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                                 'ED',TRUNC(c.eff_date),
                                                 'AD',TRUNC(c.acct_ent_date),
                                                 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to))))
         AND check_user_per_iss_cd2(p_line_cd,b250.iss_cd,'GICLS211', p_user_id) = 1
       GROUP BY b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no;

       
      IF SQL%FOUND THEN
         FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO gicl_loss_profile_ext2
                  (tsi_amt,         line_cd,        subline_cd,
                   pol_iss_cd,      issue_yy,       pol_seq_no,
                   renew_no)
            VALUES(vv_tsi_amt(i),       vv_line_cd(i),      vv_subline_cd(i),
                   vv_pol_iss_cd(i),    vv_issue_yy(i),     vv_pol_seq_no(i),
                   vv_renew_no(i));
--         COMMIT;
      END IF;
   END get_loss_ext2;
   
   FUNCTION get_profile_extract_tsi(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      v_loss_sw             VARCHAR2,
      v_loss_fr             DATE,
      v_loss_to             DATE,
      p_user_id             gicl_loss_profile.user_id%TYPE
   ) RETURN get_profile_extract_tsi_tab PIPELINED AS
      TYPE treaty_type IS TABLE OF gicl_loss_profile.treaty%type INDEX BY BINARY_INTEGER;
      v_treaty              treaty_type;
      v_update	            VARCHAR2(32000); 
      v_treatyx             gicl_loss_profile.treaty%TYPE;
      v_policy_count        NUMBER := 0;							
      rec_counter           NUMBER := 0;
      v_tsi_amt        	    gipi_polbasic.tsi_amt%TYPE := 0;
      v_acct_trty_type 	    giis_dist_share.acct_trty_type%TYPE;
      v_range_from     	    gicl_loss_profile.range_from%TYPE;
      v_range_to       	    gicl_loss_profile.range_to%TYPE;
      v_net_retention  	    gicl_loss_profile.net_retention%TYPE;
      v_quota_share    	    gicl_loss_profile.quota_share%TYPE;  
      v_facultative    	    gicl_loss_profile.facultative%TYPE; 
      v_rec_net_retention 	gicl_loss_profile.net_retention%TYPE;
      v_quota_share2    	gicl_loss_profile.quota_share%TYPE;
      v_rec_treaty         	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty1        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty2        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty3        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty4        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty5        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty6        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty7        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty8        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty9        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty10       	gicl_loss_profile.treaty%TYPE;
      v_rec_facultative    	gicl_loss_profile.facultative%TYPE; 
      v_exist          	    VARCHAR2(1) := 'N';
      v_chk_ext             NUMBER := 0;
      v_xol		         	gicl_loss_profile.xol_treaty%TYPE;
      v_param_value_v   	giac_parameters.param_value_v%TYPE;
      res                   get_profile_extract_tsi_type;
      v_value0              NUMBER(10);
   BEGIN
      res.grp_count   := 0;   
   
      FOR RNG IN (SELECT range_from, range_to, line_cd, subline_cd
                    FROM gicl_loss_profile 
                   WHERE line_cd              = NVL(p_line_cd, line_cd)
                     AND NVL(subline_cd, '1') = NVL(p_subline_cd, '1')
                     AND user_id              = p_user_id)
      LOOP
         v_range_from    := rng.range_from;
         v_range_to      := rng.range_to; 
         v_net_retention := 0;
         v_quota_share   := 0;
         v_treatyx       := 0;
         v_facultative   := 0;
         v_policy_count  := 0;
         v_tsi_amt       := 0;
         v_xol			 := 0;
         --GRP_CREATE('TREATY');
         

         FOR tsi IN (SELECT tsi_amt,  cnt_clm, tsi.line_cd, tsi.subline_cd, tsi.pol_iss_cd, tsi.issue_yy, tsi.pol_seq_no, tsi.renew_no
                       FROM gicl_loss_profile_ext2 tsi, gicl_loss_profile_ext clm 
                      WHERE 1 = 1
       	                AND tsi.line_cd              = p_line_cd
                        AND tsi.line_cd              = clm.line_cd
                        AND NVL(tsi.subline_cd, '1') = NVL(p_subline_cd, NVL(tsi.subline_cd, '1'))
      	                AND tsi.subline_cd           = clm.subline_cd
	                    AND tsi.pol_iss_cd           = clm.pol_iss_cd
      	                AND tsi.issue_yy             = clm.issue_yy
      	                AND tsi.pol_seq_no           = clm.pol_seq_no
      	                AND tsi.renew_no             = clm.renew_no
	                    AND tsi.tsi_amt              >= v_range_from
                        AND tsi.tsi_amt              <= v_range_to)
         LOOP  
	        v_tsi_amt   := NVL(v_tsi_amt,0) + NVL(tsi.tsi_amt,0);
            rec_counter := rec_counter + 1;
            res.chk_ext := 1;
            v_policy_count := NVL(v_policy_count,0) + tsi.cnt_clm;
           
            FOR a IN (SELECT c018.grp_seq_no, c018.share_type, SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) loss
                        FROM gicl_claims       c003,
                             gicl_clm_res_hist c017,
                             gicl_reserve_ds   c018
      	               WHERE 1=1
		                 AND c003.line_cd          = tsi.line_cd
                         AND c003.subline_cd       = tsi.subline_cd
                         AND c003.pol_iss_cd       = tsi.pol_iss_cd
                         AND c003.issue_yy         = tsi.issue_yy
                         AND c003.pol_seq_no       = tsi.pol_seq_no
                         AND c003.renew_no         = tsi.renew_no
                         AND c003.claim_id         = c017.claim_id
                         AND c017.claim_id         = c018.claim_id
                         AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                         AND NVL(c017.dist_sw,'N') = 'Y'
                         AND c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
                         AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                              'LD', TRUNC(c003.loss_date),SYSDATE) >= TRUNC(v_loss_fr)   
                         AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                              'LD', TRUNC(c003.loss_date),SYSDATE) <= TRUNC(v_loss_to)
				       GROUP BY c018.grp_seq_no,c018.share_type)
            LOOP   
               IF a.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) + NVL(a.loss,0);
		       ELSIF a.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(a.loss,0);
           	   ELSIF a.share_type = '2' THEN
                  v_treatyx := NVL(v_treatyx,0) + NVL(a.loss,0);     
                  res.value0 := NVL(res.value0,0) + NVL(a.loss,0);
                  v_value0 := NVL(v_value0, 0) + NVL(a.loss,0);
                  res.value1 := NVL(a.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1; 
                  --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
               ELSIF a.share_type = v_param_value_v THEN
                  v_xol := NVL(v_xol,0) + NVL(a.loss,0);   
                  res.value0 := NVL(res.value0,0) + NVL(a.loss,0);
                  v_value0 := NVL(v_value0, 0) + NVL(a.loss,0);
                  res.value1 := NVL(a.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;             
                  --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
		       END IF;
            END LOOP;

            FOR b IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_le_net_amt,0)) loss, c003.claim_id
                        FROM gicl_claims       c003,
                             gicl_clm_res_hist c017,
                             gicl_clm_loss_exp c016, 
                             gicl_loss_exp_ds   c018                              
                       WHERE c003.line_cd          = tsi.line_cd
                         AND c003.subline_cd       = tsi.subline_cd
                         AND c003.pol_iss_cd       = tsi.pol_iss_cd
                         AND c003.issue_yy         = tsi.issue_yy
                         AND c003.pol_seq_no       = tsi.pol_seq_no
                         AND c003.renew_no         = tsi.renew_no
                         AND c003.claim_id         = c017.claim_id
                         AND NVL(c017.cancel_tag,'N') = 'N'
                         AND c017.tran_id IS NOT NULL
                         AND c003.clm_stat_cd = 'CD'
                         AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                              'LD', TRUNC(c003.loss_date),SYSDATE) >= TRUNC(v_loss_fr)   
                         AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                              'LD', TRUNC(c003.loss_date),SYSDATE) <= TRUNC(v_loss_to)
                         AND c016.claim_id = c017.claim_id
                         AND c016.tran_id  = c017.tran_id
                         AND c016.item_no  = c017.item_no
                         AND c016.peril_cd = c017.peril_cd
                         AND c018.claim_id = c016.claim_id     
                         AND c018.clm_loss_id = c016.clm_loss_id     
                         AND NVL(c018.negate_tag, 'N') = 'N'     
                       GROUP BY c018.grp_seq_no, c018.acct_trty_type, c018.share_type, c003.claim_id)
            LOOP
         	   IF b.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) + NVL(b.loss,0);
               ELSIF b.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(b.loss,0);
	           ELSIF b.share_type = '2' THEN
                  v_treatyx := NVL(v_treatyx,0) + NVL(b.loss,0);                 
                  --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(b.loss,0);
                  v_value0 := NVL(v_value0, 0) + NVL(b.loss,0);
                  res.value1 := NVL(b.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;
               ELSIF b.share_type = v_param_value_v THEN
                  v_xol := NVL(v_xol,0) + NVL(b.loss,0);                 
                  --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(b.loss,0);
                  v_value0 := NVL(v_value0, 0) + NVL(b.loss,0);
                  res.value1 :=    NVL(b.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;
	           END IF;
            END LOOP;                            

            FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                   FROM gicl_claims        c003,
                                        gicl_recovery_payt c017,
                                        gicl_recovery_ds   c018
                                  WHERE c003.line_cd          = tsi.line_cd
                                    AND c003.subline_cd       = tsi.subline_cd
                                    AND c003.pol_iss_cd       = tsi.pol_iss_cd
                                    AND c003.issue_yy         = tsi.issue_yy
                                    AND c003.pol_seq_no       = tsi.pol_seq_no
                                    AND c003.renew_no         = tsi.renew_no
                                    AND c003.claim_id         = c017.claim_id
                                    AND NVL(c017.cancel_tag,'N') = 'N'
                                    AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                                         'LD', TRUNC(c003.loss_date),SYSDATE) >= TRUNC(v_loss_fr)   
                                    AND DECODE(v_loss_sw,'FD', TRUNC(c003.clm_file_date),
                                                         'LD', TRUNC(c003.loss_date),SYSDATE) <= TRUNC(v_loss_to)
                                    AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                    AND c017.claim_id = c003.claim_id
                                    AND c017.recovery_id = c018.recovery_id
                                    AND c017.recovery_payt_id = c018.recovery_payt_id
                                    AND nvl(c018.negate_tag, 'N') = 'N'     
                                  GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
            LOOP
	           IF get_recovery.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '2' THEN
                  v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);                
                  --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  v_value0 := NVL(v_value0, 0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 :=    NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;
               ELSIF get_recovery.share_type = v_param_value_v THEN
                  v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);                
                  --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  v_value0 := NVL(v_value0, 0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 := NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;
	           END IF;
            END LOOP;                            
         END LOOP; 
         
         res.grp_count := res.grp_count + 1;
         res.value0 := v_value0;
         res.policy_count := v_policy_count;
         res.net_retention := v_net_retention;
         res.tsi_amt := v_tsi_amt;
         res.net_retention := v_net_retention;
         res.quota_share := v_quota_share;
         res.treatyx := v_treatyx;
         res.facultative := v_facultative;
         res.xol := v_xol;
         res.chk_ext := v_chk_ext;
         res.line_cd := rng.line_cd;
         res.subline_cd := rng.subline_cd;
         res.range_from := rng.range_from;
         res.range_to := rng.range_to;
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   PROCEDURE get_loss_ext_motor(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
      TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
      TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE;
      vv_cnt_clm               cnt_clm_tab;
      vv_line_cd         line_cd_tab;
      vv_subline_cd         subline_cd_tab;
      vv_pol_iss_cd         pol_iss_cd_tab;
      vv_issue_yy         issue_yy_tab;
      vv_pol_seq_no         pol_seq_no_tab;
      vv_renew_no         renew_no_tab;
      vv_item_no         item_no_tab;
   BEGIN
      DELETE FROM gicl_loss_profile_ext;
      
      SELECT COUNT(c003.claim_id) cnt_clm, c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no, c002.item_no
        BULK COLLECT INTO vv_cnt_clm, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy, vv_pol_seq_no, vv_renew_no, vv_item_no
        FROM gicl_claims c003, gicl_item_peril c002, gicl_motor_car_dtl c001
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
         AND c003.claim_id = c002.claim_id
         AND c003.claim_id = c001.claim_id
         AND c002.item_no  = c001.item_no
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date), 'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date), 'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd, c003.pol_iss_cd, 'GICLS211', p_user_id) = 1
       GROUP BY c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no, c002.item_no;
  
      IF SQL%FOUND THEN
         FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO gicl_loss_profile_ext
                  (cnt_clm,    line_cd,  subline_cd,
                   pol_iss_cd, issue_yy, pol_seq_no,
                   renew_no,   item_no)
            VALUES(vv_cnt_clm(i),    vv_line_cd(i),   vv_subline_cd(i),
                   vv_pol_iss_cd(i), vv_issue_yy(i),  vv_pol_seq_no(i),
                   vv_renew_no(i),   vv_item_no(i));   
      END IF;
   END;
   
   PROCEDURE get_loss_ext2_motor(
      p_pol_sw              IN VARCHAR2,
      p_date_fr             IN DATE,
      p_date_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE tsi_amt_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
      TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
      TYPE item_no_tab         IS TABLE OF gipi_item.item_no%TYPE;
      vv_tsi_amt               tsi_amt_tab;
      vv_line_cd     line_cd_tab;
      vv_subline_cd     subline_cd_tab;
      vv_pol_iss_cd     pol_iss_cd_tab;
      vv_issue_yy     issue_yy_tab;
      vv_pol_seq_no     pol_seq_no_tab;  
      vv_renew_no     renew_no_tab;
      vv_item_no     item_no_tab;
   BEGIN
      DELETE FROM gicl_loss_profile_ext2;

      SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1)) tsi_amt, b250.line_cd, b250.subline_cd, 
             b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no, c250.item_no
        BULK COLLECT INTO vv_tsi_amt, vv_line_cd, vv_subline_cd, 
             vv_pol_iss_cd, vv_issue_yy, vv_pol_seq_no, vv_renew_no, vv_item_no
        FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250
       WHERE 1 = 1
         AND b250.policy_id  = d250.policy_id
         AND d250.policy_id  = c250.policy_id
         AND d250.item_no  = c250.item_no
         AND b250.line_cd    = p_line_cd
         AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
         AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                             'ED',TRUNC(b250.eff_date),
                             'AD',TRUNC(b250.acct_ent_date),
                             'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
         AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                             'ED',TRUNC(b250.eff_date),
                             'AD',TRUNC(b250.acct_ent_date),
                             'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to)
         AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1)) > TRUNC(p_date_to)
         AND POL_FLAG IN ('1','2','3','X')
         AND DIST_FLAG      = '3'
         AND EXISTS (SELECT 1
                       FROM GICL_LOSS_PROFILE_EXT B
                      WHERE B250.LINE_CD = B.LINE_CD
                        AND B250.SUBLINE_CD = B.SUBLINE_cD
                        AND B250.ISS_CD = B.POL_ISS_CD
                        AND B250.ISSUE_YY = B.ISSUE_YY
                        AND B250.POL_SEQ_NO = B.POL_SEQ_NO
                        AND B250.RENEW_NO = B.RENEW_NO)
         AND (b250.endt_seq_no = 0
               OR (b250.endt_seq_no <> 0
              AND EXISTS (SELECT 1
                            FROM gipi_polbasic c
                           WHERE b250.line_cd = c.line_cd
                             AND b250.subline_cd = c.subline_cd
                             AND b250.iss_cd = c.iss_cd
                             AND b250.issue_yy = c.issue_yy
                             AND b250.pol_seq_no = c.pol_seq_no
                             AND b250.renew_no = c.renew_no
                             AND b250.endt_seq_no = 0
                             AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                                 'ED',TRUNC(c.eff_date),
                                                 'AD',TRUNC(c.acct_ent_date),
                                                 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
                             AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                                 'ED',TRUNC(c.eff_date),
                                                 'AD',TRUNC(c.acct_ent_date),
                                                 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to))))
         AND check_user_per_iss_cd2(p_line_cd,b250.iss_cd,'GICLS211', p_user_id) = 1
       GROUP BY b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no, c250.item_no;

      IF SQL%FOUND THEN
         FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO GICL_LOSS_PROFILE_EXT2
                  (tsi_amt,     line_cd,        subline_cd,
                   pol_iss_cd,  issue_yy,       pol_seq_no,
                   renew_no,    item_no)
            VALUES(vv_tsi_amt(i),       vv_line_cd(i),      vv_subline_cd(i),
                   vv_pol_iss_cd(i),    vv_issue_yy(i),     vv_pol_seq_no(i),
                   vv_renew_no(i),      vv_item_no(i));
      END IF;
   END;
   
   PROCEDURE get_loss_ext_fire(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
      TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
      TYPE risk_cd_tab         IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;
      TYPE block_id_tab        IS TABLE OF GIIS_RISKS.block_id%TYPE; 
      vv_cnt_clm                cnt_clm_tab;
      vv_line_cd                line_cd_tab;
      vv_subline_cd             subline_cd_tab;
      vv_pol_iss_cd             pol_iss_cd_tab;
      vv_issue_yy               issue_yy_tab;
      vv_pol_seq_no             pol_seq_no_tab;
      vv_renew_no               renew_no_tab;
      vv_risk_cd                risk_cd_tab;
      vv_block_id               block_id_tab; 
   BEGIN
      DELETE FROM gicl_loss_profile_ext;
      
      SELECT COUNT(c003.claim_id) cnt_clm, c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy,
             c003.pol_seq_no, c003.renew_no, c001.block_id, c001.risk_cd
        BULK COLLECT INTO vv_cnt_clm, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy, vv_pol_seq_no,
             vv_renew_no, vv_block_id, vv_risk_cd
        FROM gicl_claims c003,  
             gicl_fire_dtl c001
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
         AND c003.claim_id = c001.claim_id
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1
       GROUP BY c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no,
             c001.block_id, c001.risk_cd;

      IF SQL%FOUND THEN
         FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO gicl_loss_profile_ext
                  (cnt_clm,     line_cd,    subline_cd,
                   pol_iss_cd,  issue_yy,   pol_seq_no,
                   renew_no,    block_id,   risk_cd)
            VALUES(vv_cnt_clm(i),    vv_line_cd(i),   vv_subline_cd(i),
                   vv_pol_iss_cd(i), vv_issue_yy(i),  vv_pol_seq_no(i),
                   vv_renew_no(i),   vv_block_id(i),  vv_risk_cd(i));
      END IF;
   END;
   
   PROCEDURE get_loss_ext2_fire(
      p_pol_sw              	IN VARCHAR2,
      p_date_fr             	IN DATE,
      p_date_to             	IN DATE,
      p_line_cd             	IN VARCHAR2,
      p_subline             	IN VARCHAR2,
      p_user_id             	IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE tsi_amt_tab         	IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
	  TYPE line_cd_tab         	IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      	IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      	IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        	IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      	IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        	IS TABLE OF gicl_claims.renew_no%TYPE;  
      TYPE risk_cd_tab         	IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;  
      TYPE block_id_tab        	IS TABLE OF GIIS_RISKS.block_id%TYPE; --pau 02/20/07 
      vv_tsi_amt               	tsi_amt_tab;
      vv_line_cd     			line_cd_tab;
      vv_subline_cd     		subline_cd_tab;
      vv_pol_iss_cd     		pol_iss_cd_tab;
      vv_issue_yy     			issue_yy_tab;
      vv_pol_seq_no     		pol_seq_no_tab;  
      vv_renew_no     			renew_no_tab;
      --vv_peril_cd     		peril_cd_tab;
      --vv_item_no     			item_no_tab;
      vv_risk_cd     			risk_cd_tab;
      vv_block_id     			block_id_tab; --pau 02/20/07 
   BEGIN
      DELETE FROM gicl_loss_profile_ext2;

      SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1)) tsi_amt, b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, 
			 b250.pol_seq_no, b250.renew_no, e250.block_id, e250.risk_cd
        BULK COLLECT INTO vv_tsi_amt, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy,
			 vv_pol_seq_no, vv_renew_no, vv_block_id, vv_risk_cd
		FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250, gicl_fire_dtl e250
	   WHERE 1 = 1
		 AND b250.policy_id  = d250.policy_id
		 AND d250.policy_id  = c250.policy_id
		 AND b250.line_cd    = p_line_cd
		 AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
		 AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
							 'ED',TRUNC(b250.eff_date),
							 'AD',TRUNC(b250.acct_ent_date),
							 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
		 AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
							 'ED',TRUNC(b250.eff_date),
							 'AD',TRUNC(b250.acct_ent_date),
							 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to)
		 AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1)) > TRUNC(p_date_to)
		 AND POL_FLAG IN ('1','2','3','X')
		 AND DIST_FLAG      = '3'
		 AND EXISTS (SELECT 1
					   FROM GICL_LOSS_PROFILE_EXT B
					  WHERE B250.LINE_CD = B.LINE_CD
						AND B250.SUBLINE_CD = B.SUBLINE_cD
						AND B250.ISS_CD = B.POL_ISS_CD
						AND B250.ISSUE_YY = B.ISSUE_YY
						AND B250.POL_SEQ_NO = B.POL_SEQ_NO
						AND B250.RENEW_NO = B.RENEW_NO)
		 AND e250.claim_id IN (SELECT claim_id
								 FROM gicl_claims
								WHERE B250.LINE_CD = gicl_claims.LINE_CD
								  AND B250.SUBLINE_CD = gicl_claims.SUBLINE_cD
								  AND B250.ISS_CD = gicl_claims.POL_ISS_CD
								  AND B250.ISSUE_YY = gicl_claims.ISSUE_YY
								  AND B250.POL_SEQ_NO = gicl_claims.POL_SEQ_NO
								  AND B250.RENEW_NO = gicl_claims.RENEW_NO)
		 AND (b250.endt_seq_no = 0
			   OR (b250.endt_seq_no <> 0
			  AND EXISTS (SELECT 1
							FROM gipi_polbasic c
						   WHERE b250.line_cd = c.line_cd
							 AND b250.subline_cd = c.subline_cd
							 AND b250.iss_cd = c.iss_cd
							 AND b250.issue_yy = c.issue_yy
							 AND b250.pol_seq_no = c.pol_seq_no
							 AND b250.renew_no = c.renew_no
							 AND b250.endt_seq_no = 0
							 AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
												 'ED',TRUNC(c.eff_date),
												 'AD',TRUNC(c.acct_ent_date),
												 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
							 AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
												 'ED',TRUNC(c.eff_date),
												 'AD',TRUNC(c.acct_ent_date),
												 'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to))))
		 AND check_user_per_iss_cd2(p_line_cd,b250.iss_cd,'GICLS211', p_user_id) = 1  --sherwin 092107     
	   GROUP BY b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no, e250.block_id, e250.risk_cd;
	   
      IF SQL%FOUND THEN
         FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO gicl_loss_profile_ext2
				  (tsi_amt,  	line_cd,    subline_cd,
				   pol_iss_cd,  issue_yy,   pol_seq_no,
				   renew_no,    block_id,	risk_cd)
			VALUES(vv_tsi_amt(i),  		vv_line_cd(i),   	vv_subline_cd(i),
				   vv_pol_iss_cd(i),   	vv_issue_yy(i),   	vv_pol_seq_no(i),
				   vv_renew_no(i),     	vv_block_id(i),		vv_risk_cd(i));
  
	  END IF;
   END;
   
   PROCEDURE get_loss_ext_peril(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
      TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
      TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
      TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
      TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
      TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
      TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
      TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE; 
      vv_cnt_clm               cnt_clm_tab;
      vv_line_cd         line_cd_tab;
      vv_subline_cd         subline_cd_tab;
      vv_pol_iss_cd         pol_iss_cd_tab;
      vv_issue_yy         issue_yy_tab;
      vv_pol_seq_no         pol_seq_no_tab;
      vv_renew_no         renew_no_tab;
      vv_peril_cd         peril_cd_tab;
   BEGIN
      DELETE FROM gicl_loss_profile_ext;

      SELECT COUNT(c003.claim_id) cnt_clm, c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy,
			 c003.pol_seq_no, c003.renew_no, c002.peril_cd
		BULK COLLECT INTO vv_cnt_clm, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy,
			 vv_pol_seq_no, vv_renew_no, vv_peril_cd
        FROM gicl_claims c003, gicl_item_peril c002
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
		 AND c003.claim_id = c002.claim_id 
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >= TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <= TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
		 AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1  --sherwin 092107
	   GROUP BY c003.line_cd, c003.subline_cd, c003.pol_iss_cd, c003.issue_yy, c003.pol_seq_no, c003.renew_no,c002.peril_cd;
  
   IF SQL%FOUND THEN
      FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO gicl_loss_profile_ext 
               (cnt_clm,       	line_cd,   	subline_cd,
				pol_iss_cd,  	issue_yy,   pol_seq_no,
				renew_no,       peril_cd)
		 VALUES(vv_cnt_clm(i),  	vv_line_cd(i),   	vv_subline_cd(i),
				vv_pol_iss_cd(i),   vv_issue_yy(i),   	vv_pol_seq_no(i),
				vv_renew_no(i),     vv_peril_cd(i));        
   END IF;
END;

   PROCEDURE get_loss_ext2_peril(
      p_pol_sw              	IN VARCHAR2,
      p_date_fr             	IN DATE,
      p_date_to             	IN DATE,
      p_line_cd             	IN VARCHAR2,
      p_subline             	IN VARCHAR2,
      p_user_id             	IN gicl_loss_profile.user_id%TYPE
   )  AS
      TYPE tsi_amt_tab         	IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
	  TYPE line_cd_tab         	IS TABLE OF gicl_claims.line_cd%TYPE;
	  TYPE subline_cd_tab      	IS TABLE OF gicl_claims.subline_cd%TYPE;
	  TYPE pol_iss_cd_tab      	IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
	  TYPE issue_yy_tab        	IS TABLE OF gicl_claims.issue_yy%TYPE;
	  TYPE pol_seq_no_tab      	IS TABLE OF gicl_claims.pol_seq_no%TYPE;
	  TYPE renew_no_tab        	IS TABLE OF gicl_claims.renew_no%TYPE;
	  TYPE peril_cd_tab        	IS TABLE OF giis_peril.peril_cd%TYPE;
	  TYPE tarf_cd_tab         	IS TABLE OF giis_tariff.tarf_cd%TYPE;
	  vv_tsi_amt               	tsi_amt_tab;
	  vv_line_cd     			line_cd_tab;
	  vv_subline_cd     		subline_cd_tab;
	  vv_pol_iss_cd     		pol_iss_cd_tab;
	  vv_issue_yy     			issue_yy_tab;
	  vv_pol_seq_no     		pol_seq_no_tab;
	  vv_renew_no     			renew_no_tab;
	  vv_peril_cd         		peril_cd_tab;
BEGIN
   DELETE FROM gicl_loss_profile_ext2;
  
   SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1))  tsi_amt, b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, 
		  b250.pol_seq_no, b250.renew_no, c250.peril_cd
     BULK COLLECT INTO vv_tsi_amt, vv_line_cd, vv_subline_cd, vv_pol_iss_cd, vv_issue_yy, 
		  vv_pol_seq_no, vv_renew_no, vv_peril_cd
     FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250
    WHERE 1 = 1
      AND b250.policy_id  = d250.policy_id
	  AND d250.policy_id  = c250.policy_id
	  AND d250.item_no  = c250.item_no
      AND b250.line_cd    = p_line_cd
      AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
      AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                          'ED',TRUNC(b250.eff_date),
                          'AD',TRUNC(b250.acct_ent_date),
                          'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
      AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                          'ED',TRUNC(b250.eff_date),
                          'AD',TRUNC(b250.acct_ent_date),
                          'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to)
      AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1)) > TRUNC(p_date_to)
      AND POL_FLAG IN ('1','2','3','X')
      AND DIST_FLAG      = '3'
      AND EXISTS (SELECT 1
					FROM GICL_LOSS_PROFILE_EXT B
				   WHERE B250.LINE_CD = B.LINE_CD
					 AND B250.SUBLINE_CD = B.SUBLINE_cD
                     AND B250.ISS_CD = B.POL_ISS_CD
                     AND B250.ISSUE_YY = B.ISSUE_YY
					 AND B250.POL_SEQ_NO = B.POL_SEQ_NO
					 AND B250.RENEW_NO = B.RENEW_NO
					 AND C250.PERIL_CD = B.PERIL_CD)
      AND (b250.endt_seq_no = 0
            OR (b250.endt_seq_no <> 0
           AND EXISTS (SELECT 1
                         FROM gipi_polbasic c
                        WHERE b250.line_cd = c.line_cd
                          AND b250.subline_cd = c.subline_cd
						  AND b250.iss_cd = c.iss_cd
						  AND b250.issue_yy = c.issue_yy
						  AND b250.pol_seq_no = c.pol_seq_no
						  AND b250.renew_no = c.renew_no
						  AND b250.endt_seq_no = 0
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) >= TRUNC(p_date_fr)
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE) <= TRUNC(p_date_to))))
      AND check_user_per_iss_cd2(p_line_cd,b250.iss_cd,'GICLS211', p_user_id) = 1  --sherwin 092107
    GROUP BY b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no, c250.peril_cd;

   IF SQL%FOUND THEN
      FORALL i IN vv_line_cd.first..vv_line_cd.last
         INSERT INTO gicl_loss_profile_ext2
               (tsi_amt,      	line_cd,    	subline_cd,
				pol_iss_cd, 	issue_yy,    	pol_seq_no,
				renew_no,       peril_cd)
		 VALUES(vv_tsi_amt(i),   	vv_line_cd(i),		vv_subline_cd(i),
				vv_pol_iss_cd(i),   vv_issue_yy(i),   	vv_pol_seq_no(i),
				vv_renew_no(i),     vv_peril_cd(i));
   END IF;
END;

   PROCEDURE loss_profile_extract_loss_amt(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   ) AS 
      TYPE treaty_type IS TABLE OF gicl_loss_profile.treaty%type INDEX BY BINARY_INTEGER;
	   v_treaty                treaty_type;
      v_update	               VARCHAR2(32000); 
      v_treatyx               gicl_loss_profile.treaty%TYPE;
      v_claim_count           NUMBER := 0;							
      rec_counter             NUMBER := 0;
      v_tsi_amt        	      gipi_polbasic.tsi_amt%TYPE := 0;
      v_acct_trty_type 	      giis_dist_share.acct_trty_type%TYPE;
      v_range_from     	      gicl_loss_profile.range_from%TYPE;
      v_range_to       	      gicl_loss_profile.range_to%TYPE;
      v_net_retention  	      gicl_loss_profile.net_retention%TYPE;
      v_quota_share    	      gicl_loss_profile.quota_share%TYPE;
      v_facultative    	      gicl_loss_profile.facultative%TYPE; 
      v_rec_net_retention 	   gicl_loss_profile.net_retention%TYPE;
      v_quota_share2    	   gicl_loss_profile.quota_share%TYPE;
      v_rec_treaty         	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty1        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty2        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty3        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty4        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty5        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty6        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty7        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty8        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty9        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty10       	gicl_loss_profile.treaty%TYPE;
      v_rec_facultative    	gicl_loss_profile.facultative%TYPE; 
      v_exist          	      VARCHAR2(1) := 'N';
      v_chk_ext               NUMBER := 0; 
      v_xol		         	   gicl_loss_profile.xol_treaty%TYPE;
      v_param_value_v   	   giac_parameters.param_value_v%TYPE; --kim 08/05/04 
      v_count                 NUMBER(4);
      v_index                 NUMBER(2) := 0;
   BEGIN
      IF p_e_type = 1 THEN
         get_loss_ext3(p_claim_date, p_loss_date_from, p_loss_date_to, p_line_cd, p_subline_cd, p_user_id);
      ELSIF p_e_type = 2 THEN
         IF p_line_cd = 'MC' THEN
    	    get_loss_ext3_motor(p_claim_date, p_loss_date_from, p_loss_date_to, p_line_cd, p_subline_cd, p_user_id);
         ELSIF p_line_cd = 'FI' THEN
    	    get_loss_ext3_fire(p_claim_date, p_loss_date_from, p_loss_date_to, p_line_cd, p_subline_cd, p_user_id); 	
         END IF;
      ELSIF p_e_type = 3 THEN
         get_loss_ext3_peril(p_claim_date, p_loss_date_from, p_loss_date_to, p_line_cd, p_subline_cd, p_user_id);
      END IF;
	  
	   FOR A IN (SELECT 1
				      FROM gicl_loss_profile
				     WHERE user_id = p_user_id) 
	   LOOP
         v_exist := 'Y';
	   END LOOP;
  
	   BEGIN
  	      SELECT param_value_v
    	     INTO v_param_value_v
    	     FROM giac_parameters
   	    WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
      EXCEPTION
     	   WHEN no_data_found THEN
       	   v_param_value_v := null;
 	   END;
	  
	   IF v_exist = 'Y' THEN
         FOR RNG IN (SELECT range_from, range_to, line_cd, subline_cd
                       FROM gicl_loss_profile 
                      WHERE line_cd              = NVL(p_line_cd, line_cd)
                        AND NVL(subline_cd, '1') = NVL(p_subline_cd, '1')
	                     AND user_id              = p_user_id)
         LOOP
            --initialize variables
            v_range_from    := rng.range_from;
            v_range_to      := rng.range_to; 
            v_net_retention := 0;
            v_quota_share   := 0; 
            v_treatyx       := 0;       
            v_facultative   := 0;
            v_claim_count   := 0;
            v_tsi_amt       := 0;
            v_xol	    := 0;
            v_index         := 0; -- mgm 12.15.2015 SR 5174 refresh the treaty index for every new range
            --GRP_CREATE('TREATY');
            
            FOR clm IN (SELECT claim_id
                          FROM gicl_loss_profile_ext3
                         WHERE 1 = 1
	                        AND loss_amt >= v_range_from
                           AND loss_amt <= v_range_to
                           AND close_sw = 'N')
            LOOP  
	            rec_counter := rec_counter + 1;
               v_chk_ext := 1;
               v_claim_count := NVL(v_claim_count,0) + 1;
               /* extraction of data from net retention, facultative and treaty*/
               
               FOR a IN (SELECT c018.grp_seq_no, c018.share_type, SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) loss
                           FROM gicl_clm_res_hist c017,
                                gicl_reserve_ds   c018
	                       WHERE 1=1
	                         AND c017.claim_id         = clm.claim_id
                            AND c017.claim_id         = c018.claim_id
                            AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                            AND NVL(c017.dist_sw,'N') = 'Y'                
			                 GROUP BY c018.grp_seq_no,c018.share_type)
               LOOP         	 
                  IF a.share_type = '1' THEN 
                     v_net_retention := NVL(v_net_retention,0) + NVL(a.loss,0);
		            ELSIF a.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(a.loss,0);
		            ELSIF a.share_type = '2' THEN
                     v_treatyx := NVL(v_treatyx,0) + NVL(a.loss,0);
                     --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
                     
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(a.grp_seq_no, a.loss);              
                  ELSIF a.share_type = v_param_value_v then --for xol treaty
                     v_xol := NVL(v_xol,0) + NVL(a.loss,0);
                     --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(a.grp_seq_no, a.loss);              
		            END IF;
               END LOOP;
               
               --FOR RECOVERY
               --extract data for net retention, facultative and treaty
               FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                      FROM gicl_claims        c003,
                                           gicl_recovery_payt c017,
                                           gicl_recovery_ds   c018
                                     WHERE c003.claim_id             = clm.claim_id               
                                       AND NVL(c017.cancel_tag,'N')  = 'N'
                                       AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                       AND c017.claim_id             = c003.claim_id
                                       AND c017.recovery_id          = c018.recovery_id
                                       AND c017.recovery_payt_id     = c018.recovery_payt_id
                                       AND NVL(c018.negate_tag, 'N') = 'N'     
                                     GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
               LOOP
	               IF get_recovery.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
                  ELSIF get_recovery.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
                  ELSIF get_recovery.share_type = '2' THEN
                     --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');  
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);
                                            		
                     v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);              
                  ELSIF get_recovery.share_type = v_param_value_v THEN -- for XOL treaty
                     v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);
                     --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');    
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);                     		
                  END IF;
               END LOOP;	         
            END LOOP;  
            
            FOR clm2 IN (SELECT claim_id
                           FROM gicl_loss_profile_ext3
                          WHERE 1 = 1
                            AND loss_amt >= v_range_from
                            AND loss_amt <= v_range_to
                            AND close_sw = 'Y')
            LOOP  
	            rec_counter := rec_counter + 1;
               v_chk_ext := 1;
               v_claim_count := NVL(v_claim_count,0) + 1;	         
               
               --FOR CLOSE CLAIMS                               
               --extract data for net retention, facultative and treaty
               FOR b IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_le_net_amt,0)) loss
                           FROM gicl_clm_res_hist c017,
                                gicl_clm_loss_exp c016, 
                                gicl_loss_exp_ds   c018
	                       WHERE c017.claim_id             = clm2.claim_id
                            AND NVL(c017.cancel_tag,'N')  = 'N'
                            AND c017.tran_id              IS NOT NULL
                            AND c016.claim_id             = c017.claim_id
                            AND c016.tran_id              = c017.tran_id
                            AND c016.item_no              = c017.item_no
                            AND c016.peril_cd             = c017.peril_cd
                            AND c018.claim_id             = c016.claim_id     
                            AND c018.clm_loss_id          = c016.clm_loss_id     
                            AND nvl(c018.negate_tag, 'N') = 'N'     
                          GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
               LOOP
                  IF b.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(b.loss,0);
                  ELSIF b.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(b.loss,0);
                  ELSIF b.share_type = '2' THEN
                     --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(b.grp_seq_no, b.loss);   
                     
                     v_treatyx := NVL(v_treatyx,0) + NVL(b.loss,0);              
                  ELSIF b.share_type = v_param_value_v then --for xol treaty
                     v_xol := NVL(v_xol,0) + NVL(b.loss,0);
                     --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                     
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(b.grp_seq_no, b.loss); 
                  END IF;
               END LOOP;                            
         
               --FOR RECOVERY
               --extract data for net retention, facultative and treaty
               FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                      FROM gicl_claims        c003,
                                           gicl_recovery_payt c017,
                                           gicl_recovery_ds   c018
                                     WHERE c003.claim_id             = clm2.claim_id               
                                       AND NVL(c017.cancel_tag,'N')  = 'N'
                                       AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                       AND c017.claim_id             = c003.claim_id
                                       AND c017.recovery_id          = c018.recovery_id
                                       AND c017.recovery_payt_id = c018.recovery_payt_id
                                       AND NVL(c018.negate_tag, 'N') = 'N'     
                                     GROUP BY c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
               LOOP
                  IF get_recovery.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
                  ELSIF get_recovery.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
                  ELSIF get_recovery.share_type = '2' THEN
                     --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');  
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);
                              		
                     v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);              
                  ELSIF get_recovery.share_type = v_param_value_v THEN -- for XOL treaty
                     v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);
                     --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');
                     INSERT INTO gicls211_treaty_temp
                           (treaty_cd, treaty)
                     VALUES(get_recovery.grp_seq_no, get_recovery.recovered_amt * -1);
                  END IF;
               END LOOP;	          
            END LOOP;  
       
            SELECT count(treaty_cd)
              INTO v_count
              FROM gicls211_treaty_temp;

			   IF v_count > 0 THEN
					FOR query_cur IN (SELECT SUM(treaty) treaty, treaty_cd 
                                   FROM gicls211_treaty_temp
                                  GROUP BY treaty_cd)
               LOOP
                  v_index := v_index + 1;
						v_update  := 'UPDATE gicl_loss_profile
						   	           SET policy_count               = NVL('||''''||v_claim_count||''''||',policy_count),
								               total_tsi_amt              = NVL('||''''||v_tsi_amt||''''||',total_tsi_amt),
								               net_retention              = NVL('||''''||v_net_retention||''''||',net_retention),
								               quota_share                = NVL('||''''||v_quota_share||''''||',quota_share),
								               treaty                     = NVL('||''''||v_treatyx||''''||',treaty),
													treaty'||v_index||'_loss = NVL('||''''||query_cur.treaty||''''||', treaty'||v_index||'_loss),
													treaty'||v_index||'_cd   = NVL('||''''||query_cur.treaty_cd||''''||', treaty'||v_index||'_cd),
													facultative                = NVL('||''''||v_facultative||''''||',facultative),
				                           xol_treaty		              = NVL('||''''||v_xol||''''||',xol_treaty)
										   WHERE line_cd                    = '||''''||rng.line_cd||''''||'							       
										     AND NVL(subline_cd, '||'1'||') = NVL('||''''||rng.subline_cd||''''||', '||'1'||')
										     AND range_from                 = '||''''||rng.range_from||''''||'
										     AND range_to                   = '||''''||rng.range_to||''''||'
										     AND user_id                    = '||''''||p_user_id||''''||'';
						EXEC_IMMEDIATE(v_update);
					END LOOP;
				ELSE	
               UPDATE gicl_loss_profile
                  SET policy_count  = NVL(v_claim_count,policy_count),
                      total_tsi_amt = NVL(v_tsi_amt,total_tsi_amt),
                      net_retention = NVL(v_net_retention,net_retention),
                      quota_share   = NVL(v_quota_share,quota_share),
                      treaty        = NVL(v_treatyx,treaty),									 
                      facultative   = NVL(v_facultative,facultative),
                      xol_treaty		= NVL(v_xol,xol_treaty)
                WHERE line_cd       = rng.line_cd							       
                  AND NVL(subline_cd, '1') = NVL(RNG.subline_CD, '1')
                  AND range_from           = rng.range_from
                  AND range_to             = rng.range_to
                  AND user_id              = p_user_id;
               
				END IF;
		       
         END LOOP; -- end rng
     
         IF v_chk_ext != 1 THEN
     	      p_var_ext := 'N';
            p_message := 'Extraction finished. No records extracted.';
         ELSE
   	        p_var_ext := 'Y';
            p_message := 'Extraction finished. ' || rec_counter || ' records extracted.';
	      END IF;
      ELSE
         p_var_ext := 'N';
         p_message := 'Extraction finished. No records extracted.';
      END IF;
   END;
   
   FUNCTION get_loss_profile_loss_amt(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      v_loss_sw             VARCHAR2,
      v_loss_fr             DATE,
      v_loss_to             DATE,
      p_user_id             gicl_loss_profile.user_id%TYPE
   ) RETURN get_loss_amt_tab PIPELINED AS
      res                   get_loss_amt_type;
      TYPE treaty_type IS TABLE OF gicl_loss_profile.treaty%type INDEX BY BINARY_INTEGER;
      v_treaty              treaty_type;
      v_update	            VARCHAR2(32000); 
      v_treatyx             gicl_loss_profile.treaty%TYPE;                                          
      v_claim_count         NUMBER := 0;							
      rec_counter           NUMBER := 0;
      v_tsi_amt        	    gipi_polbasic.tsi_amt%TYPE := 0;
      v_acct_trty_type 	    giis_dist_share.acct_trty_type%TYPE;
      v_range_from     	    gicl_loss_profile.range_from%TYPE;
      v_range_to       	    gicl_loss_profile.range_to%TYPE;
      v_net_retention  	    gicl_loss_profile.net_retention%TYPE;
      v_quota_share    	    gicl_loss_profile.quota_share%TYPE;  
      v_facultative    	    gicl_loss_profile.facultative%TYPE; 
      v_rec_net_retention 	gicl_loss_profile.net_retention%TYPE;
      v_quota_share2    	gicl_loss_profile.quota_share%TYPE;
      v_rec_treaty         	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty1        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty2        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty3        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty4        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty5        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty6        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty7        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty8        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty9        	gicl_loss_profile.treaty%TYPE;
      v_rec_treaty10       	gicl_loss_profile.treaty%TYPE;
      v_rec_facultative    	gicl_loss_profile.facultative%TYPE; 
      v_exist          	    VARCHAR2(1) := 'N';
      v_chk_ext             NUMBER := 0;
      v_xol		         	gicl_loss_profile.xol_treaty%TYPE;
      v_param_value_v   	giac_parameters.param_value_v%TYPE;
   BEGIN
      FOR RNG IN (SELECT range_from, range_to, line_cd, subline_cd
                    FROM gicl_loss_profile 
                   WHERE line_cd              = NVL(p_line_cd, line_cd)
                     AND NVL(subline_cd, '1') = NVL(p_subline_cd, '1')
	                 AND user_id              = p_user_id)
      LOOP
         v_range_from    := rng.range_from;
         v_range_to      := rng.range_to; 
         v_net_retention := 0;
         v_quota_share   := 0;
         v_treatyx       := 0;       
         v_facultative   := 0;
         v_claim_count   := 0;
         v_tsi_amt       := 0;
         v_xol			 := 0;
         --GRP_CREATE('TREATY');
         res.grp_count   := 0;
         FOR clm IN (SELECT claim_id
                       FROM gicl_loss_profile_ext3
                      WHERE 1 = 1
	                    AND loss_amt >= v_range_from
                        AND loss_amt <= v_range_to
                        AND close_sw = 'N')
         LOOP  
	        rec_counter := rec_counter + 1;
            v_chk_ext := 1;
            v_claim_count := NVL(v_claim_count,0) + 1;
         
            FOR a IN (SELECT c018.grp_seq_no, c018.share_type, SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) loss
                        FROM gicl_clm_res_hist c017,
                             gicl_reserve_ds   c018
	                   WHERE 1=1
	                     AND c017.claim_id         = clm.claim_id
                         AND c017.claim_id         = c018.claim_id
                         AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                         AND NVL(c017.dist_sw,'N') = 'Y'                
			           GROUP BY c018.grp_seq_no,c018.share_type)
            LOOP         	 
               IF a.share_type = '1' THEN 
                  v_net_retention := NVL(v_net_retention,0) + NVL(a.loss,0);
		       ELSIF a.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(a.loss,0);
		       ELSIF a.share_type = '2' THEN
                  v_treatyx := NVL(v_treatyx,0) + NVL(a.loss,0);
               --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(a.loss,0);
                  res.value1 := NVL(a.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;               
               ELSIF a.share_type = v_param_value_v THEN
                  v_xol := NVL(v_xol,0) + NVL(a.loss,0);
               --GRP_UPDATE('TREATY',NVL(a.grp_seq_no,0),NVL(a.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(a.loss,0);
                  res.value1 := NVL(a.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;               
		       END IF;
            END LOOP;
         
            FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                   FROM gicl_claims        c003,
                                        gicl_recovery_payt c017,
                                        gicl_recovery_ds   c018
                                  WHERE c003.claim_id             = clm.claim_id               
                                    AND NVL(c017.cancel_tag,'N')  = 'N'
                                    AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                    AND c017.claim_id             = c003.claim_id
                                    AND c017.recovery_id          = c018.recovery_id
                                    AND c017.recovery_payt_id     = c018.recovery_payt_id
                                    AND nvl(c018.negate_tag, 'N') = 'N'     
                                  GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
            LOOP
	           IF get_recovery.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '2' THEN
           		  --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');      
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 := NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;                    		
                  v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);              
               ELSIF get_recovery.share_type = v_param_value_v THEN
                  v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);
                  --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 := NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;                    	               		
	           END IF;
            END LOOP;	         
         END LOOP;  
       
         FOR clm2 IN (SELECT claim_id
                        FROM gicl_loss_profile_ext3
                       WHERE 1 = 1
	                     AND loss_amt >= v_range_from
                         AND loss_amt <= v_range_to
                         AND close_sw = 'Y')
         LOOP  
	        rec_counter := rec_counter + 1;
            v_chk_ext := 1;
            v_claim_count := NVL(v_claim_count,0) + 1;	                                        

            FOR b IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_le_net_amt,0)) loss
                        FROM gicl_clm_res_hist c017,
                             gicl_clm_loss_exp c016, 
                             gicl_loss_exp_ds   c018
	                   WHERE c017.claim_id             = clm2.claim_id
                         AND NVL(c017.cancel_tag,'N')  = 'N'
                         AND c017.tran_id              IS NOT NULL
                         AND c016.claim_id             = c017.claim_id
                         AND c016.tran_id              = c017.tran_id
                         AND c016.item_no              = c017.item_no
                         AND c016.peril_cd             = c017.peril_cd
                         AND c018.claim_id             = c016.claim_id     
                         AND c018.clm_loss_id          = c016.clm_loss_id     
                         AND nvl(c018.negate_tag, 'N') = 'N'     
                       GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
            LOOP
      	       IF b.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) + NVL(b.loss,0);
               ELSIF b.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(b.loss,0);
               ELSIF b.share_type = '2' THEN
                  --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(b.loss,0);
                  res.value1 := NVL(b.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;  
                  v_treatyx := NVL(v_treatyx,0) + NVL(b.loss,0);              
               ELSIF b.share_type = v_param_value_v then --for xol treaty
                  v_xol := NVL(v_xol,0) + NVL(b.loss,0);
                  --GRP_UPDATE('TREATY',NVL(b.grp_seq_no,0),NVL(b.loss,0),'Y');
                  res.value0 := NVL(res.value0,0) + NVL(b.loss,0);
                  res.value1 := NVL(b.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;  
	           END IF;
            END LOOP;                            
         
            FOR get_recovery IN (SELECT c018.grp_seq_no, c018.acct_trty_type, c018.share_type, SUM(NVL(c018.shr_recovery_amt,0)) recovered_amt
                                   FROM gicl_claims        c003,
                                        gicl_recovery_payt c017,
                                        gicl_recovery_ds   c018
                                  WHERE c003.claim_id             = clm2.claim_id               
                                    AND NVL(c017.cancel_tag,'N')  = 'N'
                                    AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                                    AND c017.claim_id             = c003.claim_id
                                    AND c017.recovery_id          = c018.recovery_id
                                    AND c017.recovery_payt_id     = c018.recovery_payt_id
                                    AND nvl(c018.negate_tag, 'N') = 'N'     
                                  GROUP BY  c018.grp_seq_no, c018.acct_trty_type, c018.share_type)
            LOOP
	           IF get_recovery.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) - NVL(get_recovery.recovered_amt,0);
               ELSIF get_recovery.share_type = '2' THEN
           	      --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');  
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 := NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;       		
                  v_treatyx := NVL(v_treatyx,0) - NVL(get_recovery.recovered_amt,0);              
               ELSIF get_recovery.share_type = v_param_value_v THEN -- for XOL treaty
                  v_xol := NVL(v_xol,0) - NVL(get_recovery.recovered_amt,0);
                  --GRP_UPDATE('TREATY',NVL(get_recovery.grp_seq_no,0),NVL(get_recovery.recovered_amt,0),'N');
                  res.value0 := NVL(res.value0,0) - NVL(get_recovery.recovered_amt,0);
                  res.value1 := NVL(get_recovery.grp_seq_no,0);
                  res.grp_count := res.grp_count + 1;
	           END IF;
            END LOOP;	          
         END LOOP;
         
         res.net_retention := v_net_retention;
         res.tsi_amt := v_tsi_amt;
         res.net_retention := v_net_retention;
         res.quota_share := v_quota_share;
         res.treatyx := v_treatyx;
         res.facultative := v_facultative;
         res.xol := v_xol;
         res.chk_ext := v_chk_ext;
         res.line_cd := rng.line_cd;
         res.subline_cd := rng.subline_cd;
         res.range_from := rng.range_from;
         res.range_to := rng.range_to;
         res.claim_count := v_claim_count;
         
      END LOOP;
   END;
   
   PROCEDURE get_loss_ext3(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
      TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
      vv_claim_id  claim_id_tab;
      vv_loss_amt           loss_amt_tab;
   BEGIN
      DELETE FROM GICL_LOSS_PROFILE_EXT3;
  
      SELECT C003.claim_id,(NVL(loss_res_amt,0) + NVL(exp_res_amt,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT
        BULK COLLECT INTO vv_claim_id, vv_loss_amt
        FROM gicl_claims c003,
            (SELECT claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year, SUM(NVL(c017.recovered_amt,0)) recovered_amt
               FROM gicl_recovery_payt c017
              WHERE NVL(c017.cancel_tag,'N') = 'N'
              GROUP BY claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
         AND c003.claim_id         = c017B.claim_id(+)
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1;
         
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3
                  (claim_id,        loss_amt,       close_sw)
            VALUES(vv_claim_id(i),  vv_loss_amt(i),'N');

         vv_claim_id.DELETE;
         vv_loss_amt.DELETE;
      END IF;
      
      SELECT C003.claim_id,(NVL(loss_pd_amt,0) + NVL(exp_pd_amt,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT
        BULK COLLECT INTO vv_claim_id, vv_loss_amt
        FROM gicl_claims c003,
            (SELECT claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year, SUM(NVL(c017.recovered_amt,0)) recovered_amt
               FROM gicl_recovery_payt c017
              WHERE NVL(c017.cancel_tag,'N') = 'N'
              GROUP BY claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B
       WHERE c003.clm_stat_cd ='CD'
         AND c003.claim_id         = c017B.claim_id(+)
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1;
  
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3
                  (claim_id,        loss_amt,       close_sw)
            VALUES(vv_claim_id(i),  vv_loss_amt(i),'Y');
      END IF;
   END;
   
   PROCEDURE get_loss_ext3_motor(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
     TYPE claim_id_tab        IS TABLE OF gicl_claims.claim_id%TYPE;
     TYPE loss_amt_tab        IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
     TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE;
     vv_claim_id              claim_id_tab;
     vv_loss_amt              loss_amt_tab;
     vv_item_no               item_no_tab;
   BEGIN
      DELETE FROM GICL_LOSS_PROFILE_EXT3;

      SELECT C003.claim_id,SUM(NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0)) loss_amt, c003.item_no
        BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_item_no
        FROM (SELECT c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                     SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
                FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
               WHERE NVL(c017.cancel_tag,'N') = 'N'
               GROUP BY c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
             (SELECT A.claim_id, c.loss_reserve, c.expense_reserve, b.item_no, A.clm_stat_cd, b.close_flag, c.dist_sw,
                     A.loss_date, A.clm_file_date, A.line_cd, A.subline_cd, A.pol_iss_cd
                FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c
               WHERE A.claim_id = b.claim_id
                 AND b.claim_id = c.claim_id
                 AND b.item_no = c.item_no) c003
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
         AND c003.claim_id         = c017B.claim_id(+)
         AND c003.item_no         = c017B.item_no(+)
         AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
         AND NVL(c003.dist_sw,'N') = 'Y'
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1
       GROUP BY C003.claim_id, c003.item_no;
  
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id, loss_amt, close_sw, item_no)         
            VALUES (vv_claim_id(i),  vv_loss_amt(i), 'N', vv_item_no(i)); 

            vv_claim_id.DELETE;
            vv_loss_amt.DELETE;
            vv_item_no.DELETE; 
      END IF;
      
      SELECT C003.claim_id, SUM(NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0)) loss_amt, c003.item_no
        BULK COLLECT INTO vv_claim_id, vv_loss_amt,vv_item_no
        FROM (SELECT c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                     SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
                FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
               WHERE NVL(c017.cancel_tag,'N') = 'N'
               GROUP BY c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
             (SELECT A.claim_id, b.losses_paid, b.expenses_paid, b.item_no, A.clm_stat_cd, b.tran_id, b.cancel_tag,
                     A.loss_date, A.clm_file_date, A.line_cd, A.subline_cd, A.pol_iss_cd
                FROM gicl_claims A, gicl_clm_res_hist b
               WHERE A.claim_id = b.claim_id) c003
       WHERE c003.clm_stat_cd ='CD'
         AND c003.claim_id         = c017B.claim_id(+)
         AND c003.item_no          = c017B.item_no(+)
         AND c003.tran_id IS NOT NULL
         AND NVL(c003.cancel_tag, 'N') = 'N'
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                             'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_Id) = 1
       GROUP BY c003.claim_id, c003.item_no;
     
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw, item_no)         
            VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y', vv_item_no(i));   
         
      END IF;
   END;

   PROCEDURE get_loss_ext3_fire(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE claim_id_tab          IS TABLE OF gicl_claims.claim_id%TYPE;
      TYPE loss_amt_tab          IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
      TYPE item_no_tab           IS TABLE OF gicl_item_peril.item_no%TYPE;
      TYPE peril_cd_tab          IS TABLE OF gicl_item_peril.peril_cd%TYPE;
      TYPE block_id_tab          IS TABLE OF GIIS_RISKS.block_id%TYPE; --pau 02/20/07 
      TYPE risk_cd_tab           IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;
      vv_claim_id                claim_id_tab;
      vv_loss_amt                loss_amt_tab;
      vv_item_no                 item_no_tab;
      vv_peril_cd                peril_cd_tab;
      vv_block_id                block_id_tab; --pau 02/20/07 
      vv_risk_cd                 risk_cd_tab;
   BEGIN
      DELETE FROM GICL_LOSS_PROFILE_EXT3;
  
     SELECT C003.claim_id,SUM((NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0))) loss_amt, c003.block_id, c003.risk_cd
       BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_block_id, vv_risk_cd
       FROM (SELECT c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                    SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
               FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, GICL_FIRE_DTL c019
              WHERE NVL(c017.cancel_tag,'N') = 'N'
                AND c018.claim_id = c019.claim_id
              GROUP BY c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
            (SELECT A.claim_id, c.loss_reserve, c.expense_reserve, d.block_id, d.risk_cd, A.clm_stat_cd, b.close_flag, c.dist_sw,
                    A.loss_date, A.clm_file_date, A.line_cd, A.subline_cd, A.pol_iss_cd
               FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c, GICL_FIRE_DTL d
              WHERE A.claim_id = b.claim_id
                AND b.claim_id = c.claim_id
                AND c.claim_id = d.claim_id) c003
      WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
        AND c003.claim_id         = c017B.claim_id(+)
        AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
        AND NVL(c003.dist_sw,'N') = 'Y'
        AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                           'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
        AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                             'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
        AND c003.claim_id >= 0
        AND c003.line_cd = p_line_cd
        AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
        AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1  --sherwin 092107
      GROUP BY C003.claim_id, c003.block_id, c003.risk_cd;
     
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3(claim_id,        loss_amt,       close_sw,   block_id,   risk_cd)
            VALUES (vv_claim_id(i),  vv_loss_amt(i), 'N', vv_block_id(i), vv_risk_cd(i));
            vv_claim_id.DELETE;
            vv_loss_amt.DELETE;
            vv_block_id.DELETE;
            vv_risk_cd.DELETE;
      END IF;
      
      SELECT C003.claim_id,SUM((NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0))) LOSS_AMT, c003.block_id, c003.risk_cd
        BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_block_id, vv_risk_cd
        FROM(SELECT c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                    SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
               FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, GICL_FIRE_DTL c019
              WHERE NVL(c017.cancel_tag,'N') = 'N'
                AND c018.claim_id = c019.claim_id
              GROUP BY c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
            (SELECT A.claim_id, c.losses_paid, c.expenses_paid, d.block_id, d.risk_cd, A.clm_stat_cd, c.tran_id, c.cancel_tag,
                    A.loss_date, A.clm_file_date, A.line_cd, A.subline_cd, A.pol_iss_cd
               FROM gicl_claims A, gicl_clm_res_hist c, GICL_FIRE_DTL d
              WHERE A.claim_id = c.claim_id
                AND c.claim_id = d.claim_id) c003
       WHERE c003.clm_stat_cd ='CD'
         AND c003.claim_id         = c017B.claim_id(+)
         AND c003.tran_id IS NOT NULL
         AND NVL(c003.cancel_tag, 'N') = 'N'
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211', p_user_id) = 1  --sherwin 092107
       GROUP BY c003.claim_id, c003.block_id, c003.risk_cd;
     
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw,   block_id,  risk_cd)
            VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y', vv_block_id(i), vv_risk_cd(i));
      END IF;
   END;

   PROCEDURE get_loss_ext3_peril(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   ) AS
      TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
      TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
      TYPE peril_cd_tab         IS TABLE OF gicl_item_peril.peril_cd%TYPE;
      vv_claim_id    claim_id_tab;
      vv_loss_amt            loss_amt_tab;
      vv_peril_cd    peril_cd_tab;
   BEGIN
      DELETE FROM GICL_LOSS_PROFILE_EXT3;
  
      SELECT C003.claim_id,SUM((NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0))) LOSS_AMT, c003.peril_cd
        BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_peril_cd
        FROM(SELECT c018.claim_id, c018.peril_cd peril_cd,TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                    SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
               FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
              WHERE NVL(c017.cancel_tag,'N') = 'N'
              GROUP BY c018.claim_id, c018.peril_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
            (SELECT A.claim_id, c.loss_reserve, c.expense_reserve, b.peril_cd, A.clm_stat_cd, b.close_flag,
                    c.dist_sw, A.clm_file_date, A.loss_date, A.line_cd, A.subline_cd, A.pol_iss_cd
               FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c
              WHERE A.claim_id = b.claim_id
                AND b.claim_id = c.claim_id
                AND b.peril_cd = c.peril_cd) c003
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
         AND c003.claim_id         = c017B.claim_id(+)
         AND c003.peril_cd         = c017B.peril_cd(+)
         AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
         AND NVL(c003.dist_sw,'N') = 'Y'
         AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211',p_user_id) = 1  --sherwin 092107
       GROUP BY C003.claim_id, c003.peril_cd;
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw, peril_cd)
            VALUES (vv_claim_id(i),  vv_loss_amt(i),'N', vv_peril_cd(i));
      
            vv_claim_id.DELETE;
            vv_loss_amt.DELETE;
            vv_peril_cd.DELETE;
      END IF;
  
      SELECT C003.claim_id,SUM (NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT, c003.peril_cd
        BULK COLLECT INTO vv_claim_id, vv_loss_amt,vv_peril_cd
        FROM(SELECT c018.claim_id, c018.peril_cd,TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
                    SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
               FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
              WHERE NVL(c017.cancel_tag,'N') = 'N'
              GROUP BY c018.claim_id, c018.peril_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
            (SELECT A.claim_id, b.losses_paid, b.expenses_paid, b.peril_cd, A.clm_stat_cd, b.tran_id,
                    b.cancel_tag, A.loss_date lossdate, A.clm_file_date, A.loss_date, A.line_cd, A.subline_cd, A.pol_iss_cd
               FROM gicl_claims A, gicl_clm_res_hist b
              WHERE A.claim_id = b.claim_id) c003
       WHERE c003.clm_stat_cd ='CD'
         AND c003.claim_id         = c017B.claim_id(+)
         AND c003.peril_cd         = c017B.peril_cd(+)
         AND c003.tran_id IS NOT NULL
         AND NVL(c003.cancel_tag, 'N') = 'N'
         AND TO_NUMBER(TO_CHAR(c003.lossdate,'YYYY'))= C017B.TRAN_YEAR(+)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.lossdate),SYSDATE) >=TRUNC(p_loss_fr)
         AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                              'LD', TRUNC(c003.lossdate),SYSDATE) <=TRUNC(p_loss_to)
         AND c003.claim_id >= 0
         AND c003.line_cd = p_line_cd
         AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
         AND check_user_per_iss_cd2(p_line_cd,c003.pol_iss_cd,'GICLS211',p_user_id) = 1  --sherwin 092107
       GROUP BY c003.claim_id, c003.peril_cd;
  
      IF SQL%FOUND THEN
         FORALL i IN vv_claim_id.first..vv_claim_id.last
            INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw,  peril_cd)
            VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y',       vv_peril_cd(i));   
      END IF;
   END;
   
   PROCEDURE validate_range(
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_old_from              gicl_loss_profile.range_from%TYPE,
      p_old_to                gicl_loss_profile.range_to%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT range_from, range_to
                 FROM TABLE(gicls211_pkg.get_range_list(p_line_cd, p_subline_cd, p_user_id, 'GICLS211'))
                WHERE (range_from <> p_old_from OR p_old_from IS NULL)
                  AND (range_to <> p_old_to OR p_old_to IS NULL))
      LOOP
         IF p_range_from <= i.range_from AND p_range_to >= i.range_from THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Sum Insured Range must not be within the existing range.');
         END IF;
         
         IF p_range_from <= i.range_to AND p_range_to >= i.range_to THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Sum Insured Range must not be within the existing range.');
         END IF;
      
         IF p_range_from BETWEEN i.range_from AND i.range_to THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Sum Insured Range must not be within the existing range.');
         END IF;
         
         IF p_range_to BETWEEN i.range_from AND i.range_to THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Sum Insured Range must not be within the existing range.');
         END IF;
      END LOOP;
   END;
   
   PROCEDURE delete_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
   BEGIN
      DELETE
        FROM gicl_loss_profile
       WHERE line_cd = p_rec.line_cd
         AND (subline_cd = p_rec.subline_cd
          OR (p_rec.subline_cd IS NULL AND subline_cd IS NULL))
         AND user_id = p_rec.user_id;
   END;
   
   PROCEDURE delete_loss_profile_range(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
   BEGIN
      DELETE
        FROM gicl_loss_profile
       WHERE line_cd = p_rec.line_cd
         AND (subline_cd = p_rec.subline_cd
          OR (p_rec.subline_cd IS NULL AND subline_cd IS NULL))
         AND user_id = p_rec.user_id
         AND range_from = p_rec.range_from
         AND range_to = p_rec.range_to;
   END;
   
   PROCEDURE set_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE,
      p_type                  VARCHAR2
   )
   IS
   BEGIN
      IF p_type = 'lineSubline' THEN
         gicls211_pkg.set_line_subline(p_rec);
      ELSIF p_type = 'byLine' THEN
         gicls211_pkg.set_by_line(p_rec);
      ELSIF p_type = 'byLineAndSubline' THEN
         gicls211_pkg.set_by_line_subline(p_rec);
      ELSIF p_type = 'allLines' THEN  
         gicls211_pkg.set_all_lines(p_rec);
      ELSIF p_type = 'allSubLines' THEN
         gicls211_pkg.set_all_sublines(p_rec);
      END IF;
   END;
   
   PROCEDURE set_line_subline(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT 1
                 FROM gicl_loss_profile
                WHERE line_cd = p_rec.line_cd
                  AND subline_cd = p_rec.subline_cd
                  AND user_id = p_rec.user_id
                  AND range_from = p_rec.range_from
                  AND range_to = p_rec.range_to)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists <> 'Y' THEN
         INSERT
           INTO gicl_loss_profile
                (line_cd, subline_cd, user_id, range_from, range_to,
                 policy_count, net_retention, quota_share, treaty,
                 facultative, date_from, date_to, loss_date_from, loss_date_to)
         VALUES (p_rec.line_cd, p_rec.subline_cd, p_rec.user_id, p_rec.range_from, p_rec.range_to,
                 0, 0, 0, 0, 0,p_rec.date_from, p_rec.date_to, p_rec.loss_date_from, p_rec.loss_date_to);
      END IF;
   END;
   
   PROCEDURE set_by_line(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT 1
                 FROM gicl_loss_profile
                WHERE line_cd = p_rec.line_cd
                  AND subline_cd IS NULL
                  AND user_id = p_rec.user_id
                  AND range_from = p_rec.range_from
                  AND range_to = p_rec.range_to)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
   
      IF v_exists <> 'Y' THEN
         INSERT
           INTO gicl_loss_profile
                (line_cd, subline_cd, user_id, range_from, range_to,
                 policy_count, net_retention, quota_share, treaty,
                 facultative, date_from, date_to, loss_date_from, loss_date_to)
         VALUES (p_rec.line_cd, NULL, p_rec.user_id, p_rec.range_from, p_rec.range_to,
                 0, 0, 0, 0, 0,p_rec.date_from, p_rec.date_to, p_rec.loss_date_from, p_rec.loss_date_to);
      END IF;
   END;
   
   PROCEDURE set_by_line_subline(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT subline_cd
                 FROM giis_subline
                WHERE line_cd = p_rec.line_cd)
      LOOP
         v_exists := 'N';
         FOR a IN(SELECT 1
                    FROM gicl_loss_profile
                   WHERE line_cd = p_rec.line_cd
                     AND subline_cd = i.subline_cd
                     AND user_id = p_rec.user_id
                     AND range_from = p_rec.range_from
                     AND range_to = p_rec.range_to)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
      
         IF v_exists <> 'Y' THEN
            INSERT
              INTO gicl_loss_profile
                   (line_cd, subline_cd, user_id, range_from, range_to,
                    policy_count, net_retention, quota_share, treaty,
                    facultative, date_from, date_to, loss_date_from, loss_date_to)
            VALUES (p_rec.line_cd, i.subline_cd, p_rec.user_id, p_rec.range_from, p_rec.range_to,
                    0, 0, 0, 0, 0,p_rec.date_from, p_rec.date_to, p_rec.loss_date_from, p_rec.loss_date_to);
         END IF;
      END LOOP;
   END;
   
   PROCEDURE set_all_lines(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN   
      FOR i IN(SELECT line_cd
                 FROM giis_line)
      LOOP
         v_exists := 'N';
         FOR a IN(SELECT 1
                    FROM gicl_loss_profile
                   WHERE line_cd = i.line_cd
                     AND subline_cd IS NULL
                     AND user_id = p_rec.user_id
                     AND range_from = p_rec.range_from
                     AND range_to = p_rec.range_to)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
      
         IF v_exists <> 'Y' THEN
            INSERT
              INTO gicl_loss_profile
                   (line_cd, subline_cd, user_id, range_from, range_to,
                    policy_count, net_retention, quota_share, treaty,
                    facultative, date_from, date_to, loss_date_from, loss_date_to)
            VALUES (i.line_cd, NULL, p_rec.user_id, p_rec.range_from, p_rec.range_to,
                    0, 0, 0, 0, 0,p_rec.date_from, p_rec.date_to, p_rec.loss_date_from, p_rec.loss_date_to);
         END IF;
      END LOOP;
   END;
   
   PROCEDURE set_all_sublines(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN   
      FOR i IN(SELECT line_cd
                 FROM giis_line)
      LOOP
         FOR a IN(SELECT b.subline_cd
                    FROM giis_subline b
                   WHERE b.line_cd = i.line_cd)
         LOOP
            v_exists := 'N';
            FOR b IN(SELECT 1
                       FROM gicl_loss_profile
                      WHERE line_cd = i.line_cd
                        AND subline_cd = a.subline_cd
                        AND user_id = p_rec.user_id
                        AND range_from = p_rec.range_from
                        AND range_to = p_rec.range_to)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;
         
            IF v_exists <> 'Y' THEN
               INSERT
                 INTO gicl_loss_profile
                      (line_cd, subline_cd, user_id, range_from, range_to,
                       policy_count, net_retention, quota_share, treaty,
                       facultative, date_from, date_to, loss_date_from, loss_date_to)
               VALUES (i.line_cd, a.subline_cd, p_rec.user_id, p_rec.range_from, p_rec.range_to,
                       0, 0, 0, 0, 0,p_rec.date_from, p_rec.date_to, p_rec.loss_date_from, p_rec.loss_date_to);
            END IF;
         END LOOP;
      END LOOP;
   END;
   
   PROCEDURE update_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE
   )
   IS
   BEGIN
      UPDATE gicl_loss_profile
         SET date_from = p_rec.date_from,
             date_to = p_rec.date_to,
             loss_date_from = p_rec.loss_date_from,
             loss_date_to = p_rec.loss_date_to
       WHERE user_id = p_rec.user_id
         AND line_cd = p_rec.line_cd
         AND (subline_cd = p_rec.subline_cd
          OR (p_rec.subline_cd IS NULL AND subline_cd IS NULL));
   END;
   
   PROCEDURE update_loss_profile_range(
      p_rec                   gicl_loss_profile%ROWTYPE,
      p_old_from              gicl_loss_profile.range_from%TYPE,
      p_old_to                gicl_loss_profile.range_to%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_loss_profile
         SET range_from = p_rec.range_from,
             range_to = p_rec.range_to
       WHERE line_cd = p_rec.line_cd
         AND ((subline_cd = p_rec.subline_cd) OR (p_rec.subline_cd IS NULL AND subline_cd IS NULL))
         AND user_id = p_rec.user_id
         AND range_from = p_old_from
         AND range_to = p_old_to;
   END;

END GICLS211_PKG;
/



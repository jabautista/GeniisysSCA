CREATE OR REPLACE PACKAGE BODY CPI.GIRI_DISTFRPS_WDISTFRPS_V_PKG
AS
FUNCTION  get_wdistfrps_v_dtls (
   	    p_line_cd GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
   		p_frps_yy GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
	    p_frps_seq_no GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE
   ) RETURN giri_distfrps_wdistfrps_v_tab PIPELINED
   IS
   v_distfrps giri_distfrps_wdistfrps_v_type;
   BEGIN
     FOR i IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, frps_yy, frps_seq_no, dist_no, dist_seq_no, par_policy_id 
	 	   	   FROM GIRI_DISTFRPS_WDISTFRPS_V
			   WHERE line_cd = NVL(p_line_cd,line_cd) AND frps_yy = NVL(p_frps_yy,frps_yy) AND frps_seq_no = NVL(p_frps_seq_no,frps_seq_no)
			   ) LOOP
			v_distfrps.line_cd := i.line_cd;
			v_distfrps.subline_cd := i.subline_cd;
			v_distfrps.iss_cd := i.iss_cd;
			v_distfrps.issue_yy := i.issue_yy;
			v_distfrps.pol_seq_no := i.pol_seq_no;
			v_distfrps.renew_no := i.renew_no;
			v_distfrps.frps_yy := i.frps_yy;
			v_distfrps.frps_seq_no := i.frps_seq_no;
			v_distfrps.dist_no := i.dist_no;
			v_distfrps.dist_seq_no := i.dist_seq_no;
			v_distfrps.par_policy_id := i.par_policy_id;
			PIPE ROW(v_distfrps);   
	 END LOOP;
   END;
   
/*
    **  Created by       : Jerome Orio 
    **  Date Created     : 06.23.2011   
    **  Reference By     : (GIRIS001- Create RI Placement)  
    **  Description      : Select function for V100 block. 
    */
    FUNCTION get_giri_distfrps_wdistfrps_v(
        p_line_cd           giri_wdistfrps.line_cd%TYPE,
        p_frps_yy           giri_wdistfrps.frps_yy%TYPE,
        p_frps_seq_no       giri_wdistfrps.frps_seq_no%TYPE,
        p_module            VARCHAR2,
        p_user_id           giis_users.user_id%TYPE
        )
    RETURN giri_distfrps_wdistfrps_v_tab2 PIPELINED IS
      v_list        giri_distfrps_wdistfrps_v_typ2;
    BEGIN
        FOR i IN(SELECT par_policy_id,      par_id,         line_cd,
                        frps_yy,            frps_seq_no,    iss_cd,
                        par_yy,             par_seq_no,     quote_seq_no,
                        subline_cd,         issue_yy,       pol_seq_no,
                        renew_no,           endt_iss_cd,    endt_yy,    
                        endt_seq_no,        assd_name,      eff_date,
                        expiry_date,        dist_no,        dist_seq_no,
                        tot_fac_spct,       tsi_amt,        tot_fac_tsi,
                        prem_amt,           tot_fac_prem,   currency_desc,
                        dist_flag,          prem_warr_sw,   create_date,
                        user_id,            endt_type,      ri_flag,
                        incept_date,        op_group_no,    tot_fac_spct2
                   FROM giri_distfrps_wdistfrps_v
                  WHERE line_cd = NVL (p_line_cd, line_cd)
                    AND frps_yy = NVL (p_frps_yy, frps_yy)
                    AND frps_seq_no = NVL (p_frps_seq_no, frps_seq_no)
                    AND check_user_per_line2 (line_cd, NULL, p_module, p_user_id) = 1
                    AND check_user_per_iss_cd2(line_cd, iss_cd, p_module, p_user_id) = 1)   -- added by shan 08.14.2014
        LOOP
            v_list.par_policy_id        := i.par_policy_id;
            v_list.par_id               := i.par_id;
            v_list.line_cd              := i.line_cd;
            v_list.frps_yy              := i.frps_yy;
            v_list.frps_seq_no          := i.frps_seq_no;
            v_list.iss_cd               := i.iss_cd;
            v_list.par_yy               := i.par_yy;
            v_list.par_seq_no           := i.par_seq_no;
            v_list.quote_seq_no         := i.quote_seq_no;
            v_list.subline_cd           := i.subline_cd;
            v_list.issue_yy             := i.issue_yy;
            v_list.pol_seq_no           := i.pol_seq_no;
            v_list.renew_no             := i.renew_no;
            v_list.endt_iss_cd          := i.endt_iss_cd;
            v_list.endt_yy              := i.endt_yy;
            v_list.endt_seq_no          := i.endt_seq_no;
            v_list.assd_name            := i.assd_name;
            v_list.eff_date             := i.eff_date;
            v_list.expiry_date          := i.expiry_date;
            v_list.dist_no              := i.dist_no;
            v_list.dist_seq_no          := i.dist_seq_no;
            v_list.tot_fac_spct         := i.tot_fac_spct;
            v_list.tsi_amt              := i.tsi_amt;
            v_list.tot_fac_tsi          := i.tot_fac_tsi;
            v_list.prem_amt             := i.prem_amt;
            v_list.tot_fac_prem         := i.tot_fac_prem;
            v_list.currency_desc        := i.currency_desc;
            v_list.dist_flag            := i.dist_flag;
            v_list.prem_warr_sw         := i.prem_warr_sw;
            v_list.create_date          := i.create_date;
            v_list.user_id              := i.user_id;
            v_list.endt_type            := i.endt_type;
            v_list.ri_flag              := i.ri_flag;
            v_list.incept_date          := i.incept_date;
            v_list.op_group_no          := i.op_group_no;
            v_list.tot_fac_spct2        := i.tot_fac_spct2;
            
            SELECT GIRI_WFRPS_RI_PKG.count_giri_wfrps_ri(v_list.line_cd, v_list.frps_yy, v_list.frps_seq_no)
              INTO v_list.giri_wfrps_ri_count
              FROM dual;
    
            v_list.ri_btn := '';
            FOR A1 IN(SELECT policy_id
                        FROM giuw_pol_dist 
                       WHERE dist_no = v_list.dist_no)LOOP 
              FOR A2 IN(SELECT '1'
                          FROM giuw_pol_dist
                         WHERE policy_id = A1.policy_id
                           AND negate_date is not null)LOOP
                  IF v_list.ri_flag != '3' THEN
                     v_list.ri_btn := 'Y';
                  END IF;
                  EXIT;
              END LOOP;
            EXIT;
            END LOOP;
                        
            IF v_list.line_cd IS NOT NULL AND v_list.frps_yy IS NOT NULL AND v_list.frps_seq_no IS NOT NULL THEN
              FOR A3 IN (SELECT tot_fac_spct2
                           FROM giri_distfrps_wdistfrps_v
                          WHERE line_cd = v_list.line_cd
                            AND frps_yy = v_list.frps_yy
                            AND frps_seq_no = v_list.frps_seq_no)
              LOOP
                IF A3.tot_fac_spct2 IS NOT NULL THEN
                   v_list.tot_fac_spct2 := A3.tot_fac_spct2;
                ELSE
                   v_list.tot_fac_spct2 := v_list.tot_fac_spct;
                END IF;
                EXIT;
              END LOOP;
            END IF; 
    
            v_list.dist_by_tsi_prem := '';
            FOR V IN (SELECT NVL (dist_spct1, 0) dist_spct1
                        FROM giuw_wpolicyds_dtl
                       WHERE dist_no = v_list.dist_no 
                         AND dist_seq_no = v_list.dist_seq_no)
            LOOP
                IF V.dist_spct1 > 0 THEN 
                    v_list.dist_by_tsi_prem := 'Y';
                    EXIT;
                END IF;
            END LOOP;
    
            PIPE ROW(v_list);
        END LOOP;
      RETURN;           
    END;
    
END GIRI_DISTFRPS_WDISTFRPS_V_PKG;
/



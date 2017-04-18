CREATE OR REPLACE PACKAGE BODY CPI.GIRIS015_PKG AS

    FUNCTION get_policy_frps(
        p_line_cd               GIRI_DISTFRPS_V.line_cd%TYPE,
        p_subline_cd            GIRI_DISTFRPS_V.subline_cd%TYPE,
        p_iss_cd                GIRI_DISTFRPS_V.iss_cd%TYPE,
        p_issue_yy              GIRI_DISTFRPS_V.issue_yy%TYPE,
        p_pol_seq_no            GIRI_DISTFRPS_V.pol_seq_no%TYPE,
        p_renew_no              GIRI_DISTFRPS_V.renew_no%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
      RETURN policy_frps_tab PIPELINED
    IS
        v_row                   policy_frps_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIRI_DISTFRPS_V
                  WHERE line_cd LIKE UPPER(p_line_cd)
                    AND subline_cd LIKE UPPER(NVL(p_subline_cd, '%'))
                    AND iss_cd LIKE UPPER(NVL(p_iss_cd, '%'))
                    AND issue_yy = NVL(p_issue_yy, issue_yy)
                    AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                    AND renew_no = NVL(p_renew_no, renew_no)
                    AND check_user_per_line2(line_cd, iss_cd, 'GIRIS015', p_user_id) = 1
                    AND check_user_per_iss_cd2(line_cd, iss_cd, 'GIRIS015', p_user_id) = 1
                  ORDER BY endt_iss_cd,endt_yy,endt_seq_no,frps_yy,frps_seq_no)
        LOOP
            v_row.line_cd := i.line_cd;
            v_row.subline_cd := i.subline_cd;
            v_row.iss_cd := i.iss_cd;
            v_row.issue_yy := i.issue_yy;
            v_row.pol_seq_no := i.pol_seq_no;
            v_row.renew_no := i.renew_no;
            v_row.assured := i.assured;
            v_row.eff_date := TO_CHAR(i.eff_date, 'mm-dd-yyyy');
            v_row.tot_fac_spct := i.tot_fac_spct;
            v_row.tot_fac_spct2 := i.tot_fac_spct2;
            v_row.tot_fac_tsi := i.tot_fac_tsi;
            v_row.tot_fac_prem := i.tot_fac_prem;
            v_row.endt_iss_cd := i.endt_iss_cd;
            v_row.endt_yy := i.endt_yy;
            v_row.endt_seq_no := i.endt_seq_no;
            v_row.frps_yy := i.frps_yy;
            v_row.frps_seq_no := i.frps_seq_no;
            v_row.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
            v_row.tsi_amt2 := i.tsi_amt2;
            v_row.prem_amt := i.prem_amt;
            v_row.frps_number := i.line_cd || '-' || i.frps_yy || '-' || LTRIM(TO_CHAR(i.frps_seq_no, '09999999'));
            --v_row.policy_number := i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd || '-' || LTRIM(TO_CHAR(i.issue_yy, '09')) || '-'|| 
            --                        LTRIM(TO_CHAR(i.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(i.renew_no, '09'));
			v_row.policy_number := get_policy_no(i.policy_id);
            v_row.dist_no := i.dist_no;         -- benjo 07.20.2015 UCPBGEN-SR-19626
            v_row.dist_seq_no := i.dist_seq_no; -- benjo 07.20.2015 UCPBGEN-SR-19626
            
            FOR c IN(SELECT SUM(ri_comm_amt) ri_comm_amt,
                            SUM(ri_prem_vat) ri_prem_vat,
                            SUM(ri_comm_vat) ri_comm_vat,
                            SUM(DECODE(local_foreign_sw, 'L', 0, ri_wholding_vat)) ri_wholding_vat,
                            SUM((NVL(ri_prem_amt,0) + NVL(ri_prem_vat,0)- NVL(prem_tax,0)) -
                                (NVL(ri_comm_amt,0) + NVL(ri_comm_vat,0) + ri_wholding_vat)) ri_net_due,
                            local_foreign_sw
                       FROM GIRI_BINDER_V
	                  WHERE line_cd = i.line_cd
	                    AND frps_yy = i.frps_yy 
                        AND frps_seq_no = i.frps_seq_no
                        AND reverse_sw != 'Y'
                      GROUP BY local_foreign_sw)
            LOOP
                v_row.facul_prem_vat := c.ri_prem_vat;
                v_row.facul_comm := c.ri_comm_amt;
                v_row.facul_comm_vat := c.ri_comm_vat;
                
                IF c.local_foreign_sw = 'L' THEN
      	            v_row.facul_wholding_vat := 0;
                ELSE	 
      	            v_row.facul_wholding_vat := c.ri_wholding_vat * -1;
                END IF;
                v_row.facul_net_due := c.ri_net_due;
                EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
        END LOOP;
    END;

    FUNCTION get_ri_placements(
        p_line_cd               GIRI_BINDER.line_cd%TYPE,
        p_frps_yy               GIRI_DISTFRPS.frps_yy%TYPE,
        p_frps_seq_no           GIRI_DISTFRPS.frps_seq_no%TYPE
    )
      RETURN ri_placements_tab PIPELINED
    IS
        v_row                   ri_placements_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIRI_BINDER_V
                  WHERE line_cd = p_line_cd
                    AND frps_yy = p_frps_yy
                    AND frps_seq_no = p_frps_seq_no)
        LOOP
            v_row.line_cd := i.line_cd;
            v_row.frps_yy := i.frps_yy;
            v_row.frps_seq_no := i.frps_seq_no;
            v_row.ri_sname := i.ri_sname;
            v_row.ri_shr_pct := i.ri_shr_pct;
            v_row.ri_tsi_amt := i.ri_tsi_amt;
            v_row.ri_prem_amt := i.ri_prem_amt;
            v_row.ri_prem_vat := i.ri_prem_vat;
            v_row.prem_tax := i.prem_tax;
            v_row.ri_comm_amt := i.ri_comm_amt;
            v_row.ri_comm_vat := i.ri_comm_vat;
            v_row.ri_wholding_vat := i.ri_wholding_vat;
            v_row.ri_comm_rt := i.ri_comm_rt;
            v_row.binder_yy := i.binder_yy;
            v_row.binder_seq_no := i.binder_seq_no;
            v_row.fnl_binder_id := i.fnl_binder_id;
            
            IF i.reverse_sw = 'Y' THEN
                v_row.reverse_sw := 'REVERSED';
            ELSE
                v_row.reverse_sw := 'NOT REVERSED';
            END IF;
            
            /*IF i.local_foreign_sw != 'L' THEN
		        v_row.net_due := (NVL(i.ri_prem_amt,0) + NVL(i.ri_prem_vat,0)) - (NVL(i.ri_comm_amt,0) + NVL(i.ri_comm_amt,0))
                                    - NVL(i.prem_tax,0) - NVL(i.ri_wholding_vat,0);
	         ELSE
		        v_row.net_due := (NVL(i.ri_prem_amt,0) + NVL(i.ri_prem_vat,0)) - (NVL(i.ri_comm_amt,0) + NVL(i.ri_comm_amt,0))
                                    - NVL(i.prem_tax,0);
            END IF;*/
            -- apollo cruz 09.21.2015 sr#20277
            IF i.local_foreign_sw != 'L' THEN
		        v_row.net_due := (NVL(i.ri_prem_amt,0) + NVL(i.ri_prem_vat,0)) - (NVL(i.ri_comm_amt,0))
                                    - NVL(i.prem_tax,0) - NVL(i.ri_comm_vat, 0) - NVL(i.ri_wholding_vat,0);
	         ELSE
		        v_row.net_due := (NVL(i.ri_prem_amt,0) + NVL(i.ri_prem_vat,0)) - (NVL(i.ri_comm_amt,0))
                                    - NVL(i.prem_tax,0) - NVL(i.ri_comm_vat, 0);
            END IF;
            v_row.binder_number := i.line_cd || '-' || TRIM(TO_CHAR(i.binder_yy,'09')) || '-' || TRIM(TO_CHAR(i.binder_seq_no, '099999'));
            
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION check_binder_access(
      p_line_cd                  GIRI_BINDER.line_cd%TYPE,
      p_binder_yy                GIRI_BINDER.binder_yy%TYPE,
      p_binder_seq_no            GIRI_BINDER.binder_seq_no%TYPE,
      p_user_id                  GIIS_USERS.user_id%TYPE
   )
     RETURN VARCHAR2
   IS
      result                     VARCHAR2(1);
   BEGIN
      FOR i IN(SELECT 1
                 FROM GIRI_BINDER_POLBASIC_V
                WHERE UPPER(line_cd) = UPPER(p_line_cd)
                  AND binder_yy = p_binder_yy
                  AND binder_seq_no = p_binder_seq_no
                  AND line_cd = DECODE(check_user_per_line2(line_cd, iss_cd, 'GIRIS016', p_user_id), 1, line_cd, NULL)
                  AND iss_cd = DECODE(check_user_per_iss_cd2(line_cd, iss_cd, 'GIRIS016', p_user_id), 1, iss_cd, NULL))
      LOOP
         RETURN 'Y';
      END LOOP;
      
      raise_application_error(-20001, 'Geniisys Exception#I#You are not allowed to access this module.');
   END;
    
    /* benjo 07.20.2015 UCPBGEN-SR-19626 */
    PROCEDURE check_ri_placements_access (
       p_line_cd   IN   VARCHAR2,
       p_iss_cd    IN   VARCHAR2,
       p_user_id   IN   VARCHAR2
    )
    IS
       v_exists   NUMBER := 0;
    BEGIN
       SELECT check_user_per_iss_cd2 (p_line_cd, p_iss_cd, 'GIRIS015', p_user_id)
         INTO v_exists
         FROM DUAL;

       IF v_exists <> 1
       THEN
          raise_application_error (-20001, 'Geniisys Exception#I#You are not allowed to access this module.');
       END IF;
    END;
END GIRIS015_PKG;
/



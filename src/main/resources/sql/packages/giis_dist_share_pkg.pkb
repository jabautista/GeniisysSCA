CREATE OR REPLACE PACKAGE BODY CPI.giis_dist_share_pkg
AS
    /*
    **  Created by      : Jerome Orio  
    **  Date Created    : 03.21.2011   
    **  Reference By    : (GIUWS004 - Preliminary One-Risk Distribution)   
    **  Description     : TREATY_Y record group 
    */
    FUNCTION get_dist_treaty_list(
        p_par_id                gipi_wpolbas.par_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
        v_line_cd               gipi_polbasic.line_cd%TYPE;
        v_nbt_subline_cd        gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_nbt_issue_yy          gipi_polbasic.issue_yy%TYPE;
        v_nbt_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
        v_nbt_renew_no          gipi_polbasic.renew_no%TYPE;
        v_nbt_eff_date          gipi_polbasic.expiry_date%TYPE;
        v_nbt_incept_date       gipi_polbasic.INCEPT_DATE%TYPE;--added edgar 06/09/2014
        v_par_type              gipi_parlist.PAR_TYPE%TYPE;--added edgar 06/09/2014
    BEGIN
        SELECT a.line_cd, a.subline_cd, a.iss_cd,
               a.issue_yy, a.pol_seq_no, a.renew_no,
               a.eff_date, a.incept_date, b.par_type --added incept date and par_type edgar 06/09/2014
          INTO v_line_cd, v_nbt_subline_cd, v_iss_cd,
               v_nbt_issue_yy, v_nbt_pol_seq_no, v_nbt_renew_no,
               v_nbt_eff_date, v_nbt_incept_date, v_par_type --added variable for incept date and par_type edgar 06/09/2014 
          FROM gipi_wpolbas a, gipi_parlist b --added table for getting par_type edgar 06/09/2014 
         WHERE a.par_id = p_par_id
           AND a.par_id = b.par_id; --added condition edgar 06/09/2014   
         /*EXCEPTION --bonok 11.27.2012
            WHEN NO_DATA_FOUND THEN
                SELECT line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no,
                       eff_date
                  INTO v_line_cd, v_nbt_subline_cd, v_iss_cd,
                       v_nbt_issue_yy, v_nbt_pol_seq_no, v_nbt_renew_no,
                       v_nbt_eff_date     
                  FROM gipi_polbasic
                 WHERE par_id = p_par_id;*/   
         /*Modified into IF condition to address issue on treaty LOV for distribution permanent solution : Edgar 06/09/2014
         **For Policy : Treaty LOV will display portfolio type treaty records whose effectivity term encapsulates the PAR's 
         effectivity date; and natural expiry treaty records whose effectivity encapsulates the PAR's incept date
         **For Endorsement : Treaty LOV will display the combination of natural expiry treaty records used in the original policy, 
         and portfolio treaty records whose effectivity term encapsulates the endorsement's effectivity date, 
         and natural expiry treaty records whose effectivity encapsulates the PAR's incept date*/    
         IF v_par_type = 'P' THEN   
            FOR i IN(SELECT trty_cd, trty_name, trty_yy, line_cd, share_cd, share_type, eff_date,
                            expiry_date 
                       FROM giis_dist_share
                      --WHERE TRUNC(v_nbt_incept_date) BETWEEN TRUNC (eff_date) AND TRUNC (expiry_date)  -- Commented out and replaced by - Jerome Bautista 05.03.2016 SR 22165
                      WHERE ( TRUNC(v_nbt_incept_date) BETWEEN TRUNC (eff_date) 
                        AND TRUNC (expiry_date) OR (TRUNC(v_nbt_incept_date) <= TRUNC (eff_date) AND TRUNC(v_nbt_incept_date) <= TRUNC (expiry_date)))
                        AND NVL(prtfolio_sw,'N') = 'N'
                        AND share_type = '2'
                        AND line_cd = NVL (p_nbt_line_cd, v_line_cd)
                     UNION
                     SELECT trty_cd, trty_name, trty_yy, line_cd, share_cd, share_type, eff_date,
                            expiry_date 
                       FROM giis_dist_share
                      --WHERE TRUNC(v_nbt_eff_date) BETWEEN TRUNC (eff_date) AND TRUNC (expiry_date)  -- Commented out and replaced by - Jerome Bautista 05.03.2016 SR 22165
                      WHERE ( TRUNC(v_nbt_eff_date) BETWEEN TRUNC (eff_date) 
                        AND TRUNC (expiry_date) OR (TRUNC(v_nbt_eff_date) <= TRUNC (eff_date) AND TRUNC(v_nbt_eff_date) <= TRUNC (expiry_date)))
                        AND NVL(prtfolio_sw,'N') = 'P'
                        AND share_type = '2'
                        AND line_cd = NVL (p_nbt_line_cd, v_line_cd))
            LOOP
                v_list.trty_cd          := i.trty_cd;
                v_list.trty_name        := i.trty_name;
                v_list.trty_yy          := i.trty_yy;
                v_list.line_cd          := i.line_cd;
                v_list.share_cd         := i.share_cd;
                v_list.share_type       := i.share_type; 
                v_list.eff_date         := i.eff_date;
                v_list.expiry_date      := i.expiry_date;
            PIPE ROW(v_list);
            END LOOP;                
         ELSIF v_par_type = 'E' THEN              
            FOR i IN(SELECT trty_cd, trty_name, trty_yy, line_cd, share_cd, share_type, eff_date,
                            expiry_date 
                       FROM giis_dist_share
                      --WHERE TRUNC (expiry_date) >= TRUNC(v_nbt_eff_date) -- edited by d.alcantara, 12-06-2011, added TRUC to fix error in SR --commented out edgar replaced code below 06/09/2014
                      WHERE TRUNC(v_nbt_eff_date) BETWEEN TRUNC (eff_date) AND TRUNC (expiry_date) --edgar 06/09/2014 --Modified by Jerome Bautista changed v_nbt_incept_date to v_nbt_eff_date 09.17.2015 SR 20350
                        AND NVL(prtfolio_sw,'N') = 'N' --edgar 06/09/2014
                        AND share_type = '2'
                        AND line_cd = NVL (p_nbt_line_cd, v_line_cd)
                     UNION
                     SELECT trty_cd, trty_name, trty_yy, line_cd, share_cd, share_type, eff_date,
                            expiry_date 
                       FROM giis_dist_share
                      WHERE TRUNC(v_nbt_eff_date) BETWEEN TRUNC (eff_date) AND TRUNC (expiry_date) 
                        AND NVL(prtfolio_sw,'N') = 'P'
                        AND share_type = '2'
                        AND line_cd = NVL (p_nbt_line_cd, v_line_cd)
                     UNION
                     SELECT a.trty_cd trty_cd, a.trty_name trty_name, a.trty_yy trty_yy,
                            a.line_cd line_cd, a.share_cd share_cd, a.share_type share_type,
                            a.eff_date eff_date, a.expiry_date expiry_date
                       FROM giis_dist_share a,
                            giuw_policyds_dtl b,
                            gipi_polbasic c,
                            giuw_pol_dist d
                      WHERE c.policy_id = d.policy_id
                        AND b.dist_no = d.dist_no
                        AND a.line_cd = c.line_cd
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND NVL (a.prtfolio_sw, 'N') = 'N'
                        AND share_type = '2'
                        AND c.line_cd = v_line_cd
                        AND c.subline_cd = v_nbt_subline_cd
                        AND c.iss_cd = v_iss_cd
                        AND c.issue_yy = v_nbt_issue_yy
                        AND c.pol_seq_no = v_nbt_pol_seq_no
                        AND c.renew_no = v_nbt_renew_no)
--                        AND c.endt_seq_no = 0)    --commented out by gab 02.05.2016
            LOOP
                v_list.trty_cd          := i.trty_cd;
                v_list.trty_name        := i.trty_name;
                v_list.trty_yy          := i.trty_yy;
                v_list.line_cd          := i.line_cd;
                v_list.share_cd         := i.share_cd;
                v_list.share_type       := i.share_type; 
                v_list.eff_date         := i.eff_date;
                v_list.expiry_date      := i.expiry_date;
            PIPE ROW(v_list);
            END LOOP;
         END IF;
         /*end of modification edgar 06/09/2014*/
    RETURN;
    END;
    /*
    **  Created by      : Jerome Orio  
    **  Date Created    : 03.21.2011   
    **  Reference By    : (GIUWS004 - Preliminary One-Risk Distribution)   
    **  Description     : TREATY_N record group 
    */    
    FUNCTION get_dist_share_list(
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_line_cd               gipi_wpolbas.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
    BEGIN
        FOR i IN(SELECT trty_cd, trty_name, line_cd, share_cd, share_type
                   FROM giis_dist_share
                  WHERE line_cd = NVL (p_nbt_line_cd, p_line_cd)
                    AND share_type IN ('1', '3')
                  ORDER BY share_cd)
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
     /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 16, 2011
    **  Reference By : GIUWS015 - Batch Distribution
    **  Description  : TREATY_Y record group 
    */
    FUNCTION get_dist_treaty_list2(p_line_cd      IN    GIPI_POLBASIC.line_cd%TYPE,
                                   p_subline_cd   IN    GIPI_POLBASIC.subline_cd%TYPE,
                                   p_iss_cd       IN    GIPI_POLBASIC.iss_cd%TYPE,
                                   p_issue_yy     IN    GIPI_POLBASIC.issue_yy%TYPE,
                                   p_pol_seq_no   IN    GIPI_POLBASIC.pol_seq_no%TYPE,
                                   p_renew_no     IN    GIPI_POLBASIC.renew_no%TYPE)
    RETURN dist_share_list_tab PIPELINED IS 
     v_list                  dist_share_list_type;
    BEGIN
        FOR i IN ( SELECT a160.trty_cd trty_cd, a160.trty_name trty_name,
                          a160.trty_yy trty_yy, a160.line_cd line_cd, 
                          a160.share_cd share_cd, a160.share_type share_type  
                     FROM GIIS_DIST_SHARE a160 
                    WHERE a160.trty_sw='Y' 
                      AND a160.line_cd= p_line_cd
                      AND a160.share_type = 2
                    UNION 
                    SELECT a.trty_cd trty_cd, a.trty_name trty_name, 
                           a.trty_yy trty_yy, a.line_cd line_cd, 
                           a.share_cd share_cd, a.share_type share_type
                      FROM GIIS_DIST_SHARE a, GIUW_POLICYDS_DTL b, GIPI_POLBASIC c, 
                           GIUW_POL_DIST d
                     WHERE c.policy_id = d.policy_id
                       AND b.dist_no = d.dist_no
                       AND a.line_cd = c.line_cd
                       AND a.line_cd = b.line_cd
                       AND a.share_cd = b.share_cd  
                       AND NVL(a.prtfolio_sw,'N') = 'N'
                       AND share_type = '2'  
                       AND c.line_cd = p_line_cd
                       AND c.subline_cd = p_subline_cd 
                       AND c.iss_cd = p_iss_cd
                       AND c.issue_yy = p_issue_yy
                       AND c.pol_seq_no = p_pol_seq_no
                       AND c.renew_no = p_renew_no
                       AND c.endt_seq_no = 0)
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.trty_yy          := i.trty_yy;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type;
            PIPE ROW(v_list);
        END LOOP;
    END;
    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 16, 2011
    **  Reference By : GIUWS015 - Batch Distribution
    **  Description  : TREATY_N record group 
    */
    FUNCTION get_dist_share_list2(p_line_cd      IN       GIIS_DIST_SHARE.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
    BEGIN
        FOR i IN(SELECT a160.trty_cd trty_cd, a160.trty_name trty_name, 
                        a160.line_cd line_cd, a160.share_cd share_cd, a160.share_type   
                  FROM GIIS_DIST_SHARE a160
                 WHERE a160.trty_sw='N' 
                   AND a160.line_cd= p_line_cd
                  ORDER BY share_cd)
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  04.11.2012
   **  Reference By : (GICLS024 - Claim Reserve)
   **  Description  : Procedure to update the dist share of peril
   **
   */    
    PROCEDURE gicls024_update_xol (
      p_claim_id gicl_claims.claim_id%TYPE, 
      p_peril_cd gicl_item_peril.peril_cd%TYPE)
    IS
      v_loss_date gicl_claims.loss_date%TYPE;
      v_line_cd   gicl_claims.line_cd%TYPE;
      v_xol_share_type giac_parameters.param_value_v%TYPE := giacp.v ('XOL_TRTY_SHARE_TYPE');
    BEGIN
      SELECT line_cd, loss_date
        INTO v_line_cd, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;
       FOR get_share IN                                                 ----------------------------------------------------------19a
          (SELECT a.share_cd
             FROM giis_dist_share a, giis_trty_peril b
            WHERE a.line_cd = b.line_cd
              AND a.share_cd = b.trty_seq_no
              AND a.share_type = v_xol_share_type
              AND TRUNC (a.eff_date) <= TRUNC (v_loss_date)
              AND TRUNC (a.expiry_date) >= TRUNC (v_loss_date)
              AND b.peril_cd = p_peril_cd
              AND a.line_cd = v_line_cd)
       LOOP                                                   ---------------------------------------------------------------------19b
          FOR update_xol_trty IN                                                --------------------------------------------------20a
             (SELECT SUM ((NVL (a.shr_loss_res_amt, 0) * b.convert_rate) + (NVL (shr_exp_res_amt, 0) * b.convert_rate)) ret_amt
                FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
               WHERE NVL (a.negate_tag, 'N') = 'N'
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND a.claim_id = c.claim_id
                 AND a.item_no = c.item_no
                 AND a.peril_cd = c.peril_cd
                 AND a.grouped_item_no = c.grouped_item_no                                                    -- added by gmi 02/28/06
                 AND NVL (c.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                 AND a.grp_seq_no = get_share.share_cd
                 AND a.line_cd = v_line_cd)
          LOOP                                                     ----------------------------------------------------------------20b
             UPDATE giis_dist_share
                SET xol_reserve_amount = update_xol_trty.ret_amt
              WHERE share_cd = get_share.share_cd 
                AND line_cd = v_line_cd;
          END LOOP;                                                ----------------------------------------------------------------20c
       END LOOP;
    END;
    /*
    **  Created by      : Andrew Robes  
    **  Date Created    : 05.17.2012   
    **  Reference By    : (GIUWS013 - Distribution by Group)   
    **  Description     : TREATY_Y record group 
    */
    FUNCTION get_giuws013_dist_treaty_lov(
        p_policy_id             gipi_polbasic.policy_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
        v_line_cd               gipi_polbasic.line_cd%TYPE;
        v_subline_cd        gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_issue_yy          gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no          gipi_polbasic.renew_no%TYPE;
        v_eff_date          gipi_polbasic.expiry_date%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, iss_cd,
               issue_yy, pol_seq_no, renew_no,
               eff_date
          INTO v_line_cd, v_subline_cd, v_iss_cd,
               v_issue_yy, v_pol_seq_no, v_renew_no,
               v_eff_date     
          FROM gipi_polbasic
         WHERE policy_id = p_policy_id;
        FOR i IN (
          SELECT * FROM 
              (SELECT trty_cd, trty_name, trty_yy, a.line_cd, a.share_cd, a.share_type, a.eff_date, a.expiry_date
                      FROM giis_dist_share a, gipi_polbasic b
                     WHERE TRUNC(DECODE(NVL (prtfolio_sw, 'N'), 'N',v_eff_date, 'P',b.eff_date)) BETWEEN TRUNC(a.eff_date) AND TRUNC(a.expiry_date) --Modified by Jerome Bautista 09.23.2015 SR 20350
                       AND share_type = '2'
                       AND a.line_cd = v_line_cd
                       --AND b.policy_id = p_policy_id
                       AND b.line_cd = v_line_cd
                       AND b.subline_cd = v_subline_cd
                       AND b.iss_cd = v_iss_cd
                       AND b.issue_yy = v_issue_yy
                       AND b.pol_seq_no = v_pol_seq_no
                       AND b.renew_no = v_renew_no
                   --    AND b.endt_seq_no = 0 /*Modified by GCMIRALLES 09.24.2015 SR 20350*/
                    UNION
                    SELECT a.trty_cd trty_cd, a.trty_name trty_name, a.trty_yy trty_yy, a.line_cd line_cd, a.share_cd share_cd,
                           a.share_type share_type, a.eff_date eff_date, a.expiry_date expiry_date
                      FROM giis_dist_share a, giuw_policyds_dtl b, gipi_polbasic c, giuw_pol_dist d
                     WHERE TRUNC(DECODE(NVL (prtfolio_sw, 'N'), 'N',v_eff_date, 'P',c.eff_date)) BETWEEN TRUNC(a.eff_date) AND TRUNC(a.expiry_date) --Modified by Jerome Bautista 09.23.2015 SR 20350
                       AND c.policy_id = d.policy_id
                       AND b.dist_no = d.dist_no
                       AND a.line_cd = c.line_cd
                       AND a.line_cd = b.line_cd
                       AND a.share_cd = b.share_cd
                       AND NVL (a.prtfolio_sw, 'N') = 'N'
                       AND share_type = '2'
                       AND c.line_cd = v_line_cd
                       AND c.subline_cd = v_subline_cd
                       AND c.iss_cd = v_iss_cd
                       AND c.issue_yy = v_issue_yy
                       AND c.pol_seq_no = v_pol_seq_no
                       AND c.renew_no = v_renew_no
                       AND c.endt_seq_no = 0)
                WHERE trty_cd LIKE NVL(p_find_text, '%')
                     OR trty_name LIKE NVL(p_find_text, '%')
                     OR line_cd LIKE NVL(p_find_text, '%')
          )
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.trty_yy          := i.trty_yy;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type; 
            v_list.eff_date         := i.eff_date;
            v_list.expiry_date      := i.expiry_date;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;    
    /*
    **  Created by      : Andrew Robes  
    **  Date Created    : 05.17.2012   
    **  Reference By    : (GIUWS013 - Distribution by Group)   
    **  Description     : TREATY_N record group 
    */
    FUNCTION get_giuws013_dist_share_lov(
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_line_cd               gipi_wpolbas.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
    BEGIN
        FOR i IN(SELECT trty_cd, trty_name, line_cd, share_cd, share_type
                   FROM giis_dist_share
                  WHERE line_cd = NVL (p_nbt_line_cd, p_line_cd)
                    AND share_type IN ('1', '3')
                    AND (trty_cd LIKE NVL(p_find_text, '%')
                     OR trty_name LIKE NVL(p_find_text, '%')
                     OR line_cd LIKE NVL(p_find_text, '%'))
                  ORDER BY share_cd)
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
   /*
    **  Created by      : Veronica V. Raymundo 
    **  Date Created    : 05.18.2012   
    **  Reference By    : (GIUWS016 - Distribution by TSI/Prem (Group))   
    **  Description     : TREATY_Y record group 
    */
    FUNCTION get_giuws016_dist_treaty_lov(
        p_policy_id             gipi_polbasic.policy_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
        v_line_cd               GIPI_POLBASIC.line_cd%TYPE;
        v_subline_cd            GIPI_POLBASIC.subline_cd%TYPE;
        v_iss_cd                GIPI_POLBASIC.iss_cd%TYPE;
        v_issue_yy              GIPI_POLBASIC.issue_yy%TYPE;
        v_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE;
        v_renew_no              GIPI_POLBASIC.renew_no%TYPE;
        v_eff_date              GIPI_POLBASIC.expiry_date%TYPE;
      v_incept_date           GIPI_POLBASIC.incept_date%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, iss_cd,
               issue_yy, pol_seq_no, renew_no,
               eff_date, incept_date
          INTO v_line_cd, v_subline_cd, v_iss_cd,
               v_issue_yy, v_pol_seq_no, v_renew_no,
               v_eff_date, v_incept_date 
          FROM gipi_polbasic
         WHERE policy_id = p_policy_id;
        FOR i IN (
          SELECT * FROM 
              (SELECT trty_cd, trty_name, trty_yy, line_cd, 
                      share_cd, share_type, eff_date, expiry_date 
                 FROM GIIS_DIST_SHARE 
                WHERE TRUNC(DECODE(NVL(prtfolio_sw, 'N'), 'N', v_eff_date, v_eff_date)) BETWEEN TRUNC(eff_date) AND TRUNC(expiry_date) --added by john 6.13.2014 --Modified by Jerome Bautista 09.23.2015 SR 20350 
                  AND share_type = '2'
                  AND line_cd = NVL(p_nbt_line_cd, v_line_cd)  
                UNION
                SELECT a.trty_cd, a.trty_name, a.trty_yy, a.line_cd, 
                       a.share_cd, a.share_type, a.eff_date, a.expiry_date  
                  FROM GIIS_DIST_SHARE a, 
                       GIUW_POLICYDS_DTL b, 
                       GIPI_POLBASIC c, 
                       GIUW_POL_DIST d
                 WHERE c.policy_id = d.policy_id
                   AND b.dist_no = d.dist_no
                   AND a.line_cd = c.line_cd
                   AND a.line_cd = b.line_cd
                   AND a.share_cd = b.share_cd  
                   AND NVL(a.prtfolio_sw,'N') = 'N'
                   AND share_type = '2'  
                   AND c.line_cd = v_line_cd
                   AND c.subline_cd = v_subline_cd 
                   AND c.iss_cd = v_iss_cd
                   AND c.issue_yy = v_issue_yy
                   AND c.pol_seq_no = v_pol_seq_no
                   AND c.renew_no = v_renew_no
                   )--AND c.endt_seq_no = 0)    commented out by Gzelle 11232015 SR20572
                WHERE UPPER(trty_cd) LIKE NVL(UPPER(p_find_text), '%')
                   OR UPPER(trty_name) LIKE NVL(UPPER(p_find_text), '%')
                   OR UPPER(line_cd) LIKE NVL(UPPER(p_find_text), '%')
          )
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.trty_yy          := i.trty_yy;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type; 
            v_list.eff_date         := i.eff_date;
            v_list.expiry_date      := i.expiry_date;
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
    END;    
    /*
    **  Created by      : Veronica V. Raymundo 
    **  Date Created    : 05.18.2012   
    **  Reference By    : (GIUWS016 - Distribution by TSI/Prem (Group))   
    **  Description     : TREATY_N record group 
    */
    FUNCTION get_giuws016_dist_share_lov(
        p_nbt_line_cd           GIUW_WPOLICYDS_DTL.line_cd%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_find_text             VARCHAR2)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
    BEGIN
        FOR i IN(SELECT trty_cd, trty_name, line_cd, 
                        share_cd, share_type
                   FROM GIIS_DIST_SHARE
                  WHERE line_cd = NVL (p_nbt_line_cd, p_line_cd)
                    AND share_type NOT IN ('2', '4') --added by cherrie 12.27.2013 
                    --AND share_type != '2' 
                    --AND trty_name = 'FACULTATIVE'
                    AND (UPPER(share_cd) LIKE NVL(UPPER(p_find_text), '%')
                     OR UPPER(trty_name) LIKE NVL(UPPER(p_find_text), '%')
                     OR UPPER(line_cd) LIKE NVL(UPPER(p_find_text), '%'))
                  ORDER BY share_cd)
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type;
            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;   
    /*
    **  Created by      : Bonok 
    **  Date Created    : 11.27.2012   
    **  Reference By    : (GIUWS012 - PERIL DISTRIBUTION)   
    **  Description     : same as get_dist_treaty_list but variables are retrieved from gipi_polbasic instead of gipi_wpolbas  
    */
    FUNCTION get_dist_treaty_list3(
        p_par_id                gipi_wpolbas.par_id%TYPE,
        p_nbt_line_cd           giuw_wpolicyds_dtl.line_cd%TYPE)
    RETURN dist_share_list_tab PIPELINED IS
        v_list                  dist_share_list_type;
        v_line_cd               gipi_polbasic.line_cd%TYPE;
        v_nbt_subline_cd        gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_nbt_issue_yy          gipi_polbasic.issue_yy%TYPE;
        v_nbt_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
        v_nbt_renew_no          gipi_polbasic.renew_no%TYPE;
        v_nbt_eff_date          gipi_polbasic.expiry_date%TYPE;
        v_nbt_incept_date       gipi_polbasic.expiry_date%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, iss_cd,
               issue_yy, pol_seq_no, renew_no,
               eff_date, incept_date
          INTO v_line_cd, v_nbt_subline_cd, v_iss_cd,
               v_nbt_issue_yy, v_nbt_pol_seq_no, v_nbt_renew_no,
               v_nbt_eff_date, v_nbt_incept_date     
          FROM gipi_polbasic
         WHERE par_id = p_par_id;                 
        FOR i IN(SELECT trty_cd, trty_name, trty_yy, line_cd, share_cd, share_type, eff_date,
                        expiry_date
                   FROM giis_dist_share
                  --WHERE TRUNC (expiry_date) >= TRUNC(v_nbt_eff_date) -- edited by d.alcantara, 12-06-2011, added TRUC to fix error in SR 
                  --marco - 06.10.2014 - consider incept_date for Natural Expiry and eff_date for Portfolio 
                  WHERE TRUNC(DECODE(NVL(prtfolio_sw, 'N'), 'N', v_nbt_eff_date, v_nbt_eff_date)) BETWEEN TRUNC(eff_date) AND TRUNC(expiry_date) --Modified by Jerome Bautista 09.23.2015 SR 20350
                    AND share_type = '2'
                    AND line_cd = NVL (p_nbt_line_cd, v_line_cd)
                 UNION
                 SELECT a.trty_cd trty_cd, a.trty_name trty_name, a.trty_yy trty_yy,
                        a.line_cd line_cd, a.share_cd share_cd, a.share_type share_type,
                        a.eff_date eff_date, a.expiry_date expiry_date
                   FROM giis_dist_share a,
                        giuw_policyds_dtl b,
                        gipi_polbasic c,
                        giuw_pol_dist d
                  WHERE c.policy_id = d.policy_id
                    AND b.dist_no = d.dist_no
                    AND a.line_cd = c.line_cd
                    AND a.line_cd = b.line_cd
                    AND a.share_cd = b.share_cd
                    AND NVL (a.prtfolio_sw, 'N') = 'N'
                    AND share_type = '2'
                    AND c.line_cd = v_line_cd
                    AND c.subline_cd = v_nbt_subline_cd
                    AND c.iss_cd = v_iss_cd
                    AND c.issue_yy = v_nbt_issue_yy
                    AND c.pol_seq_no = v_nbt_pol_seq_no
                    AND c.renew_no = v_nbt_renew_no
                    ) --AND c.endt_seq_no = 0) commented out by Gzelle 11202015 SR20572
        LOOP
            v_list.trty_cd          := i.trty_cd;
            v_list.trty_name        := i.trty_name;
            v_list.trty_yy          := i.trty_yy;
            v_list.line_cd          := i.line_cd;
            v_list.share_cd         := i.share_cd;
            v_list.share_type       := i.share_type; 
            v_list.eff_date         := i.eff_date;
            v_list.expiry_date      := i.expiry_date;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END; 
   /*
   ** Created by    : Halley Pates
   ** Date Created  : October 17, 2012
   ** Reference By  : (GIIS060 -  Distribution Share Maintenance)
   ** Description   : Distribution Share List based on line_cd
   */    
   FUNCTION get_giis060_dist_share_list (p_line_cd giis_line.line_cd%TYPE, p_share_type giis_dist_share.share_type%TYPE)
      RETURN dist_share_list_tab PIPELINED
   IS
      v_list   dist_share_list_type;
   BEGIN
      FOR i IN (SELECT   line_cd, share_cd, trty_name, remarks, user_id, last_update, trty_yy, trty_sw
                    FROM giis_dist_share
                   WHERE line_cd = p_line_cd AND share_type = p_share_type
                ORDER BY share_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.share_cd := i.share_cd;
         v_list.trty_name := i.trty_name;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.str_last_update := 
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM'); --steven 11.18.2013
         v_list.trty_yy := i.trty_yy;
         v_list.trty_sw := i.trty_sw;
         PIPE ROW (v_list);
      END LOOP;
      RETURN;
   END get_giis060_dist_share_list;
   /*
   ** Created by    : Halley Pates
   ** Date Created  : October 24, 2012
   ** Reference By  : (GIIS060 - Distribution Share Maintenance)
   ** Description   : Checks if share_cd exists for GIIS060
   */   
   PROCEDURE chk_share_exists (p_line_cd IN giis_line.line_cd%TYPE, p_share_cd IN giis_dist_share.share_cd%TYPE, p_exists OUT giis_line.line_cd%TYPE)
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_dist_share
          WHERE line_cd = p_line_cd AND share_cd = p_share_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_exists := 'N';
      END;
      p_exists := v_exists;
   END chk_share_exists;
    /*
    ** Created by    : Halley Pates
    ** Date Created  : October 24, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   : Distribution Share insert and update for GIIS060
    */
   PROCEDURE set_giis060_dist_share (
      p_line_cd       IN   giis_dist_share.line_cd%TYPE,
      p_share_cd      IN   giis_dist_share.share_cd%TYPE,
      p_share_type    IN   giis_dist_share.share_type%TYPE,
      p_trty_name     IN   giis_dist_share.trty_name%TYPE,
      p_remarks       IN   giis_dist_share.remarks%TYPE,
      p_user_id       IN   giis_dist_share.user_id%TYPE,
      p_last_update   IN   giis_dist_share.last_update%TYPE,
      p_trty_yy       IN   giis_dist_share.trty_yy%TYPE,
      p_trty_sw       IN   giis_dist_share.trty_sw%TYPE
   )
   IS
      p_exists          giis_line.line_cd%TYPE;
      v_eff_date        giis_dist_share.eff_date%TYPE;
      v_expiry_date     giis_dist_share.expiry_date%TYPE;
   BEGIN
      giis_dist_share_pkg.chk_share_exists (p_line_cd, p_share_cd, p_exists);
      IF p_exists = 'Y' THEN
         UPDATE giis_dist_share
            SET trty_name = p_trty_name,
                remarks = p_remarks,
                user_id = p_user_id,
                last_update = p_last_update
          WHERE line_cd = p_line_cd AND share_cd = p_share_cd;
      ELSE
         v_eff_date := TO_DATE('01-01-1999', 'MM-DD-YYYY');
         v_expiry_date := TO_DATE('12-31-1999', 'MM-DD-YYYY');
         INSERT INTO giis_dist_share
                     (line_cd, share_cd, share_type, trty_name, remarks, user_id, last_update, trty_yy, trty_sw, eff_date, expiry_date
                     )
              VALUES (p_line_cd, p_share_cd, p_share_type, p_trty_name, p_remarks, p_user_id, p_last_update, p_trty_yy, p_trty_sw, v_eff_date, v_expiry_date
                     );
      END IF;
   END set_giis060_dist_share;
   /*
   ** Created by    : Halley Pates
   ** Date Created  : October 25, 2012
   ** Reference By  : (GIIS060 - Distribution Share Maintenance)
   ** Description   : delete row/s from table for GIIS060
   */
   PROCEDURE delete_dist_share (p_line_cd giis_line.line_cd%TYPE, p_share_type giis_dist_share.share_type%TYPE, p_share_cd giis_dist_share.share_cd%TYPE)
   IS
   BEGIN
      DELETE FROM giis_dist_share
            WHERE line_cd = p_line_cd AND share_type = p_share_type AND share_cd = p_share_cd;
   END delete_dist_share;
    /*
    ** Created by    : Halley Pates
    ** Date Created  : October 25, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   : Validates that the deletion of the record is permitted
    **                 by checking for the existence of rows in related tables.
    */
    FUNCTION chk_giis_dist_share (p_line_cd IN giis_line.line_cd%TYPE, p_share_cd IN giis_dist_share.share_cd%TYPE)
        RETURN VARCHAR2
    IS
        v_exists      VARCHAR2 (1);
        v_table_name  VARCHAR2 (100);
    BEGIN
        BEGIN
            SELECT DISTINCT 'Y', 'GIUW_WPOLICYDS_DTL'
                       INTO v_exists, v_table_name
                       FROM giuw_wpolicyds_dtl c140
                      WHERE c140.line_cd = p_line_cd AND c140.share_cd = p_share_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_exists := 'N';
        END;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIUW_WPERILDS_DTL'
                         INTO v_exists, v_table_name
                         FROM giuw_wperilds_dtl c120
                        WHERE c120.line_cd = p_line_cd AND c120.share_cd = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIUW_WITEMDS_DTL'
                         INTO v_exists, v_table_name
                         FROM giuw_witemds_dtl c100
                        WHERE c100.line_cd = p_line_cd AND c100.share_cd = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIIS_TRTY_PERIL'
                         INTO v_exists, v_table_name
                         FROM giis_trty_peril a640
                        WHERE a640.line_cd = p_line_cd AND a640.trty_seq_no = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIIS_TRTY_PANEL'
                         INTO v_exists, v_table_name
                         FROM giis_trty_panel a630
                        WHERE a630.line_cd = p_line_cd AND a630.trty_seq_no = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIUW_POLICYDS_DTL'
                         INTO v_exists, v_table_name
                         FROM giuw_policyds_dtl c070
                        WHERE c070.line_cd = p_line_cd AND c070.share_cd = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIUW_PERILDS_DTL'
                         INTO v_exists, v_table_name
                         FROM giuw_perilds_dtl c050
                        WHERE c050.line_cd = p_line_cd AND c050.share_cd = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        IF v_exists = 'N' THEN 
           BEGIN
              SELECT DISTINCT 'Y', 'GIUW_ITEMDS_DTL'
                         INTO v_exists, v_table_name
                         FROM giuw_itemds_dtl c030
                        WHERE c030.line_cd = p_line_cd AND c030.share_cd = p_share_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;
        /*IF v_exists = 'N' THEN    commented out by Gzelle 02102015 - GIIS_DIST_SHARE is the maintenance table
           BEGIN
              SELECT DISTINCT 'X', 'GIIS_DIST_SHARE'
                         INTO v_exists, v_table_name
                         FROM giis_dist_share a160
                        WHERE a160.line_cd = p_line_cd AND a160.share_cd = p_share_cd AND a160.share_cd IN (1, 999);
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_exists := 'N';
           END;
        END IF;*/
       RETURN v_exists||v_table_name;
    END chk_giis_dist_share;
   /*
    ** Created by    : Halley Pates
    ** Date Created  : October 30, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   : Validates that addition of share_cd and trty_name are unique.
    */
    PROCEDURE validate_add_dist_share (
        p_line_cd      IN       giis_line.line_cd%TYPE,
        p_share_cd     IN       giis_dist_share.share_cd%TYPE,
        p_trty_name    IN OUT   giis_dist_share.trty_name%TYPE,
        p_share_type   IN OUT   giis_dist_share.share_type%TYPE,
        p_exists       OUT      VARCHAR2,
        p_msg          OUT      VARCHAR2
    )
    IS
    BEGIN
       BEGIN
          SELECT 'Y'
            INTO p_exists
            FROM giis_dist_share
           WHERE line_cd = p_line_cd 
             AND share_cd = p_share_cd
             --AND share_type = p_share_type; -- rai 07-12-2016 SR 22709
             AND share_type in (2, 4); -- added to consider XOL layer rai 07-12-2016 SR 22709
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             p_exists := 'N';
       END;
    IF p_exists = 'N'
    THEN
      BEGIN
         SELECT 'X'
           INTO p_exists
           FROM giis_dist_share
          WHERE line_cd = p_line_cd AND trty_name = p_trty_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_exists := 'N';
      END;
   END IF;
    IF p_exists = 'N' THEN
        IF p_share_cd = '1' THEN
             IF p_trty_name NOT LIKE '%NET%RETENTION%' OR (p_trty_name LIKE '%NET%RETENTION%' AND p_share_type != '1') THEN
                p_msg := 'NR';
                p_trty_name := 'NET RETENTION';
             END IF;
             IF p_share_type != '1' THEN
                p_share_type := '1';
             END IF;
        ELSIF p_share_cd = '999' THEN
             IF p_trty_name NOT LIKE '%FACULTATIVE%' OR (p_trty_name LIKE '%FACULTATIVE%' AND p_share_type != '3') THEN
                p_msg := 'F';
                p_trty_name := 'FACULTATIVE';
             END IF;
             IF p_share_type != '3' THEN
                p_share_type := '3';
             END IF;
        ELSE
             IF p_trty_name LIKE '%FACULTATIVE%' THEN
                p_msg := 'FACULTATIVE';
             END IF;
             IF p_trty_name LIKE '%NET%RETENTION%' THEN
                p_msg := 'NET RETENTION';
             END IF;
          END IF;       
       END IF;
    END validate_add_dist_share;
    /*
    ** Created by    :  Halley Pates
    ** Date Created  :  November 6, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   : Validates update of share_cd and trty_name.
    */ 
    PROCEDURE validate_update_dist_share (
       p_line_cd        IN       giis_line.line_cd%TYPE,
       p_share_cd       IN       giis_dist_share.share_cd%TYPE,
       p_trty_name      IN OUT   giis_dist_share.trty_name%TYPE,
       p_share_type     IN OUT   giis_dist_share.share_type%TYPE,
       p_exists         OUT      VARCHAR2,
       p_msg            OUT      VARCHAR2
    )
    IS
        v_trty_name giis_dist_share.trty_name%TYPE;
    BEGIN
          BEGIN
             SELECT 'Y'
               INTO p_exists
               FROM giis_dist_share
              WHERE line_cd = p_line_cd 
                AND share_cd = p_share_cd
                AND trty_name = p_trty_name;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_exists := 'N';
          END;
          IF p_exists = 'N' THEN
            BEGIN
                SELECT DISTINCT 'X'
                  INTO p_exists
                  FROM giis_dist_share
                 WHERE line_cd = p_line_cd
                   AND trty_name = p_trty_name;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 p_exists := 'N';
            END;
          END IF;
           IF p_exists IN ('Y', 'X', 'N') THEN
              IF p_share_cd = '1' THEN
                 IF p_trty_name NOT LIKE '%NET%RETENTION%' THEN
                    p_msg := 'NR';
                    p_trty_name := 'NET RETENTION';
                 END IF;
                 IF p_share_type != '1' THEN
                    p_share_type := '1';
                 END IF;
              ELSIF p_share_cd = '999' THEN
                 IF p_trty_name NOT LIKE '%FACULTATIVE%' THEN
                    p_msg := 'F';
                    p_trty_name := 'FACULTATIVE';
                 END IF;
                 IF p_share_type != '3' THEN
                    p_share_type := '3';
                 END IF;
              ELSE
                 IF p_trty_name LIKE '%FACULTATIVE%' THEN
                    p_msg := 'FACULTATIVE';
                 ELSIF p_trty_name LIKE '%NET%RETENTION%' THEN
                    p_msg := 'NET RETENTION';
                 END IF;          
              END IF;       
           END IF;
    END validate_update_dist_share;   
    /*
    ** Created by    :  Marie Kris Felipe
    ** Date Created  :  September 26, 2013
    ** Reference By  : (GIACS220 - Quarterly Treaty Summary Statement)
    ** Description   : Gets the list of treaties.
    */ 
    FUNCTION get_dist_share_list3
        RETURN dist_share_list_tab2 PIPELINED
    IS
        v_dist          dist_share_list_type2;
    BEGIN
        FOR rec IN (SELECT share_type, line_cd, trty_yy, share_cd, trty_name
                      FROM giis_dist_share
                     WHERE share_type = 2)
        LOOP
            v_dist.line_cd          := rec.line_Cd;
            v_dist.trty_yy          := rec.trty_yy;
            v_dist.share_Cd         := rec.share_cd;
            v_dist.share_type       := rec.share_type;
            v_dist.trty_name        := rec.trty_name;
            v_dist.main_proc_year   := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
            BEGIN
                SELECT TO_CHAR(TO_DATE(TO_CHAR(SYSDATE,'MM'),'mm'), 'Q') 
                  INTO v_dist.main_proc_qtr
                  FROM dual;
                SELECT TO_CHAR(TO_DATE(TO_CHAR(SYSDATE,'MM'),'mm'), 'Qth')
                  INTO v_dist.main_proc_qtr_str
                  FROM dual;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dist.main_proc_qtr := NULL;
                    v_dist.main_proc_qtr_str := NULL;
            END; 
            BEGIN 
                SELECT line_name
                  INTO v_dist.line_name
                  FROM giis_line
                 WHERE line_Cd = rec.line_cd;            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dist.line_name := NULL;
            END;
            PIPE ROW(v_dist);
        END LOOP;
    END get_dist_share_list3;
END;
/



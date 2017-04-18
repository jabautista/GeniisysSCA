CREATE OR REPLACE PACKAGE BODY CPI.giri_binder_pkg
AS 
   FUNCTION get_breakdown_amts (
      p_ri_cd              giri_binder.ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
      p_disbursement_amt   giac_outfacul_prem_payts.disbursement_amt%TYPE
   )
      RETURN giri_binder_amts_tab PIPELINED
   IS
      v_prem_amt        NUMBER                := 0;
      v_prem_vat        NUMBER                := 0;
      v_comm_amt        NUMBER                := 0;
      v_comm_vat        NUMBER                := 0;
      v_wholding_vat    NUMBER                := 0;
      v_disb_rt         NUMBER;
      v_disb_amt_diff   NUMBER                := 0;
      v_message         VARCHAR2 (32767);
      v_disbursement    giri_binder_amts_type;
   BEGIN
      IF p_disbursement_amt IS NOT NULL
      THEN
         v_prem_amt := 0;
         v_prem_vat := 0;
         v_comm_amt := 0;
         v_comm_vat := 0;
         v_wholding_vat := 0;

         FOR rec IN (SELECT a.fnl_binder_id,
                            NVL (a.ri_prem_amt, 0)
                            * c.currency_rt ri_prem_amt,
                            NVL (a.ri_prem_vat, 0)
                            * c.currency_rt ri_prem_vat,
                            NVL (a.ri_comm_amt, 0)
                            * c.currency_rt ri_comm_amt,
                            NVL (a.ri_comm_vat, 0)
                            * c.currency_rt ri_comm_vat,
                              NVL (a.ri_wholding_vat, 0)
                            * c.currency_rt ri_wholding_vat
                       FROM giri_frps_ri b,
                           -- giuw_pol_dist d,  -- commented, based on 11.24.2014 04:44 PM version : shan 04.06.2014
                            giri_distfrps c,
                            giri_binder a
                      WHERE a.fnl_binder_id = b.fnl_binder_id
                        AND b.line_cd = c.line_cd
                        AND b.frps_yy = c.frps_yy
                        AND b.frps_seq_no = c.frps_seq_no
						AND check_reused_binder(a.fnl_binder_id,c.dist_no) <> 1 -- added by robert to exclude reused binders SR 19893 07.22.15
                        --AND d.dist_no = c.dist_no -- commented, based on 11.24.2014 04:44 PM version : shan 04.06.2014
                        --AND d.dist_flag NOT IN (4, 5) -- commented, based on 11.24.2014 04:44 PM version : shan 04.06.2014
                        AND a.binder_yy = p_binder_yy
                        AND a.line_cd = p_line_cd
                        AND a.binder_seq_no = p_binder_seq_no
                        AND a.ri_cd = p_ri_cd)
         LOOP
            v_disb_rt :=
                 p_disbursement_amt
               / (  (rec.ri_prem_amt + rec.ri_prem_vat)
                  - (rec.ri_comm_amt + rec.ri_comm_vat + rec.ri_wholding_vat
                    )
                 );
            v_prem_amt := rec.ri_prem_amt * v_disb_rt;
            v_prem_vat := rec.ri_prem_vat * v_disb_rt;
            v_comm_amt := rec.ri_comm_amt * v_disb_rt;
            v_comm_vat := rec.ri_comm_vat * v_disb_rt;
            v_wholding_vat := rec.ri_wholding_vat * v_disb_rt;
            v_disb_amt_diff :=
                 p_disbursement_amt
               - (  (v_prem_amt + v_prem_vat)
                  - (v_comm_amt + v_comm_vat + v_wholding_vat)
                 );

            IF ABS (v_disb_amt_diff) > 0.01
            THEN
               v_message :=
                   'Discrepancy in rounding off of amounts > 0.01 was found!';
            ELSIF SIGN (v_disb_amt_diff) IN (1, -1)
            THEN
               IF v_prem_vat <> 0
               THEN
                  v_prem_vat := v_prem_vat + v_disb_amt_diff;
               ELSE
                  IF SIGN (v_prem_vat + v_disb_amt_diff) <> SIGN (v_prem_amt)
                  THEN
                     v_comm_amt := v_comm_amt - v_disb_amt_diff;
                  ELSE
                     v_prem_vat := v_prem_vat + v_disb_amt_diff;
                  END IF;
               END IF;
            END IF;

            v_disbursement.ri_prem_amt := v_prem_amt;
            v_disbursement.ri_prem_vat := v_prem_vat;
            v_disbursement.ri_comm_amt := v_comm_amt;
            v_disbursement.ri_comm_vat := v_comm_vat;
            v_disbursement.ri_wholding_vat := v_wholding_vat;
            v_disbursement.MESSAGE := v_message;
            PIPE ROW (v_disbursement);
         END LOOP;
      END IF;
   END get_breakdown_amts;

   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  07-05-2011
   **  Reference By : GIRIS002 - Enter RI Acceptance
   **  Description  :
   */
   PROCEDURE create_binders_giris002 (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giri_wbinder_peril
            WHERE pre_binder_id IN (
                     SELECT pre_binder_id
                       FROM giri_wfrps_ri
                      WHERE line_cd = p_line_cd
                        AND frps_yy = p_frps_yy
                        AND frps_seq_no = p_frps_seq_no);

      DELETE FROM giri_wbinder
            WHERE pre_binder_id IN (
                     SELECT pre_binder_id
                       FROM giri_wfrps_ri
                      WHERE line_cd = p_line_cd
                        AND frps_yy = p_frps_yy
                        AND frps_seq_no = p_frps_seq_no);
   END create_binders_giris002;

   /*
   **  Created by   :  Anthony Santos
   **  Date Created :  07-05-2011
   **  Reference By : GIRIS026
   */
   FUNCTION get_posted_dtls_giris026 (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN giri_binder_posted_dtls_tab PIPELINED
   IS
      v_binder   giri_binder_posted_dtls_type;
   BEGIN
      FOR i IN (SELECT ri_cd, fnl_binder_id
                  FROM giri_frps_ri
                 WHERE line_cd = p_line_cd
                   AND frps_yy = p_frps_yy
                   AND frps_seq_no = p_frps_seq_no
                   AND reverse_sw = 'N')
      LOOP
         FOR a2 IN (SELECT line_cd, binder_yy, binder_seq_no, binder_date,
                           fnl_binder_id, ref_binder_no
                      FROM giri_binder
                     WHERE fnl_binder_id = i.fnl_binder_id)
         LOOP
            FOR a1 IN (SELECT ri_name
                         FROM giis_reinsurer
                        WHERE ri_cd = i.ri_cd)
            LOOP
               v_binder.ri_name := a1.ri_name;
               EXIT;
            END LOOP;

            v_binder.binder_no :=
               (   a2.line_cd
                || ' - '
                || TO_CHAR (a2.binder_yy, '09')
                || ' - '
                || TO_CHAR (a2.binder_seq_no, '09999')
               );
            v_binder.binder_date := a2.binder_date;
            v_binder.ref_binder_no := a2.ref_binder_no;
            v_binder.fnl_binder_id := a2.fnl_binder_id;
            PIPE ROW (v_binder);
         END LOOP;
      END LOOP;
   END get_posted_dtls_giris026;

   PROCEDURE update_giri_binder_giris026 (
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_binder_date     giri_binder.binder_date%TYPE,
      p_ref_binder_no   giri_binder.ref_binder_no%TYPE
   )
   IS
   BEGIN
      UPDATE giri_binder
         SET binder_date = p_binder_date,
             ref_binder_no = p_ref_binder_no
       WHERE fnl_binder_id = p_fnl_binder_id;
   END;

/*
    **  Created by        : Anthony Santos
    **  Date Created     : 07.20.2011
    **  Reference By     : (GIUWS013- One Risk Policy)
    */
   PROCEDURE update_reverse_date_giuws013 (
      p_dist_no_old   IN   giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   )
   IS
   BEGIN
      FOR c1 IN (SELECT line_cd, frps_yy, frps_seq_no
                   FROM giri_distfrps
                  WHERE dist_seq_no = p_dist_seq_no
                    AND dist_no = p_dist_no_old)
      LOOP
         FOR c2 IN (SELECT fnl_binder_id
                      FROM giri_frps_ri
                     WHERE line_cd = c1.line_cd
                       AND frps_yy = c1.frps_yy
                       AND frps_seq_no = c1.frps_seq_no)
         LOOP
            UPDATE giri_binder
               SET reverse_date = SYSDATE
             WHERE fnl_binder_id = c2.fnl_binder_id;
         END LOOP;
      END LOOP;
   END update_reverse_date_giuws013;
   /*
    **  Created by        : Anthony Santos
    **  Date Created     : 07.21.2011
    **  Reference By     : (GIUWS013- One Risk Policy)
    */
   
   PROCEDURE update_binder_flag_sw(
                p_dist_no_old   IN   giuw_wpolicyds.dist_no%TYPE,
             p_dist_seq_no   IN   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   )
   IS
   BEGIN
            FOR c IN (SELECT line_cd, frps_yy , frps_seq_no
                      FROM giri_distfrps
                     WHERE dist_seq_no = p_dist_seq_no
                       AND dist_no     = p_dist_no_old)
                  LOOP
            FOR c2 IN (SELECT fnl_binder_id
                         FROM giri_frps_ri
                        WHERE line_cd     = c.line_cd
                          AND frps_yy     = c.frps_yy
                          AND frps_seq_no = c.frps_seq_no)
            LOOP
              UPDATE giri_binder
                 SET replaced_flag = 'Y'
                        WHERE fnl_binder_id = c2.fnl_binder_id;
       
                      UPDATE giri_frps_ri
                          SET reverse_sw  = 'Y'
                        WHERE fnl_binder_id = c2.fnl_binder_id;
                    END LOOP;
                  END LOOP;
   END update_binder_flag_sw;
   
  /*
   **  Created by   :  Belle Bebing
   **  Date Created :  07.27.2011
   **  Description  :  This function will check if posted binder already exist.
   */
   FUNCTION check_binder_exists (p_par_id    GIPI_WPOLBAS.par_id%TYPE)
    RETURN VARCHAR2 IS
    v_exist     VARCHAR2(1);

    BEGIN
        FOR i IN (SELECT count(*) count
                    FROM GIPI_WPOLBAS a, GIUW_POL_DIST b, GIRI_DISTFRPS c, GIRI_FRPS_RI d, GIRI_BINDER e
                   WHERE a.par_id = b.par_id
                     AND b.dist_no = c.dist_no
                     AND c.line_cd = d.line_cd
                     AND c.frps_yy = d.frps_yy
                     AND c.frps_seq_no = d.frps_seq_no
                     AND d.fnl_binder_id = e.fnl_binder_id
                     AND a.par_id = p_par_id)
        LOOP
            IF i.count > 0 THEN
                v_exist := 'Y';
            END IF;
        END LOOP;
        
        RETURN v_exist;
    END check_binder_exists;
    
    /*
   **  Created by   :  Belle Bebing
   **  Date Created :  07.27.2011
   **  Description  :  Updates reverse_sw in GIRI_FRPS_RI and reverse_date in GIRI_BINDER
   **                  when changes are made in peril information when binder/s are already posted.
   */
    PROCEDURE UPDATE_REV_SWITCH_REV_DATE (p_par_id    GIPI_WPOLBAS.par_id%TYPE) IS
    BEGIN
         FOR i IN (SELECT e.fnl_binder_id
                    FROM GIPI_WPOLBAS a, GIUW_POL_DIST b, GIRI_DISTFRPS c, GIRI_FRPS_RI d, GIRI_BINDER e
                   WHERE a.par_id = b.par_id
                     AND b.dist_no = c.dist_no
                     AND c.line_cd = d.line_cd
                     AND c.frps_yy = d.frps_yy
                     AND c.frps_seq_no = d.frps_seq_no
                     AND d.fnl_binder_id = e.fnl_binder_id
                     AND a.par_id = p_par_id)
        LOOP
           UPDATE GIRI_FRPS_RI
              SET reverse_sw = 'Y'
            WHERE fnl_binder_id = i.fnl_binder_id;
            
           UPDATE GIRI_BINDER
              SET reverse_date = SYSDATE
            WHERE fnl_binder_id = i.fnl_binder_id;  
        END LOOP;
    END;
    
    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 2, 2011
    **  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
    **  Description  : Update replaced_flag of giri_binder
    */

    PROCEDURE UPDATE_GIRI_BINDER_GIUWS016 (p_dist_no IN  GIUW_POL_DIST.dist_no%TYPE,
                                           p_par_id  IN  GIUW_POL_DIST.par_id%TYPE) IS
      
      v_facul_exist    VARCHAR2(1) := 'N';
      v_par_id         GIUW_POL_DIST.par_id%TYPE;
      
    BEGIN
      --to check if record has no facul share
      FOR pol IN (SELECT 'X'
                    FROM GIUW_POLICYDS_DTL a,
                         GIIS_DIST_SHARE   b
                   WHERE 1=1
                     AND a.line_cd     = b.line_cd
                     AND a.share_cd    = b.share_cd
                     AND b.share_type  = '3' --indicates facul share
                     AND a.dist_no     = p_dist_no)
       LOOP
            v_facul_exist := 'Y';
            EXIT;
       END LOOP;
       --populate replaced flag of giri_binder if v_facul_exist = 'N'
       IF v_facul_exist = 'N' THEN
             FOR v IN(SELECT d.fnl_binder_id
                               FROM GIUW_POL_DIST a, GIRI_DISTFRPS b, 
                                    GIRI_FRPS_RI c, GIRI_BINDER d
                              WHERE a.dist_no       = b.dist_no
                                AND b.line_cd       = c.line_cd
                                AND b.frps_yy       = c.frps_yy
                                AND b.frps_seq_no   = c.frps_seq_no
                                AND c.fnl_binder_id = d.fnl_binder_id 
                                AND a.par_id        = p_par_id
                                AND a.negate_date  IN (SELECT MAX(z.negate_date)
                                                       FROM GIUW_POL_DIST z
                                                       WHERE z.par_id = p_par_id))
                LOOP
              UPDATE GIRI_BINDER
                    SET replaced_flag = 'Y'
               WHERE fnl_binder_id = v.fnl_binder_id
                 AND reverse_date IS NOT NULL;
          END LOOP;
       END IF;
    END;
    
    /*
    **  Created by       : emman
    **  Date Created     : 08.16.2011
    **  Reference By     : (GIUWS021- Redistribution)
    **  Description:     : Updates table GIRI_BINDER of the negated
    **                      distribution record signifying that the
    **                      binder released has been reversed.
    */
    PROCEDURE UPDATE_REVERSE_DATE_GIUTS021(p_dist_no_old    IN giuw_wpolicyds.dist_no%TYPE,
                                  p_dist_seq_no    IN giuw_wpolicyds_dtl.dist_seq_no%TYPE)
    IS
    BEGIN
      FOR c1 IN (SELECT frps_yy , frps_seq_no
                   FROM giri_distfrps
                  WHERE dist_seq_no = p_dist_seq_no
                    AND dist_no     = p_dist_no_old)
      LOOP
        FOR c2 IN (SELECT fnl_binder_id
                     FROM giri_frps_ri
                    WHERE frps_yy     = c1.frps_yy
                      AND frps_seq_no = c1.frps_seq_no)
        LOOP
          UPDATE giri_binder
             SET reverse_date  = SYSDATE
           WHERE fnl_binder_id = c2.fnl_binder_id;
          EXIT;
        END LOOP;
        EXIT;
      END LOOP;
    END UPDATE_REVERSE_DATE_GIUTS021;
    
    PROCEDURE UPDATE_PRINTED_BINDER_DATE_CNT(p_fnl_binder_id IN giri_binder.fnl_binder_id%TYPE)
    IS
    BEGIN
      UPDATE giri_binder
         SET bndr_print_date = SYSDATE,
            bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
       WHERE fnl_binder_id = p_fnl_binder_id;
      UPDATE giri_frps_ri
         SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
       WHERE fnl_binder_id = p_fnl_binder_id;
    END UPDATE_PRINTED_BINDER_DATE_CNT;
    
   FUNCTION get_fnl_binder_id (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN get_fnl_binder_id_tab PIPELINED
   IS
      v_binder_id     get_fnl_binder_id_type;
   BEGIN
      FOR i IN (SELECT fnl_binder_id
		  FROM giri_frps_ri
		 WHERE line_cd = p_line_cd
		   AND frps_yy = p_frps_yy
		   AND frps_seq_no = p_frps_seq_no
		   AND reverse_sw = 'N')
      LOOP
         v_binder_id.fnl_binder_id := i.fnl_binder_id;
         PIPE ROW (v_binder_id);
      END LOOP;
   END get_fnl_binder_id;

   FUNCTION get_binder_details (
      p_dist_no     giri_distfrps.dist_no%TYPE
   )
      RETURN get_binder_details_tab PIPELINED
   IS
      v_binder_details    get_binder_details_type;
   BEGIN
      FOR i IN (SELECT T1.line_cd, T1.binder_yy, T1.binder_seq_no, T1.fnl_binder_id
       	  FROM giri_binder T1
              ,giri_frps_ri T2
              ,giri_distfrps T3
     	 WHERE T1.fnl_binder_id = T2.fnl_binder_id
	       AND T2.line_cd       = T3.line_cd
	       AND T2.frps_yy       = T3.frps_yy
 	       AND T2.frps_seq_no   = T3.frps_seq_no
               AND T3.dist_no   = p_dist_no
	       AND T2.reverse_sw    = 'N')
      LOOP
         v_binder_details.line_cd := i.line_cd;
         v_binder_details.binder_yy := i.binder_yy;
         v_binder_details.binder_seq_no := i.binder_seq_no;
         v_binder_details.fnl_binder_id := i.fnl_binder_id;
         PIPE ROW (v_binder_details);
      END LOOP;
   END get_binder_details;
   
   /*
   **  Created by   : Marco Paolo Rebong
   **  Date Created : April 23, 2013
   **  Reference By : GIPIS090
   **  Description  : get binders based on policy_id
   */
   FUNCTION get_binders(
      p_policy_id   GIRI_BINDER.policy_id%TYPE
   )
     RETURN get_binder_details_tab PIPELINED
   IS
      v_binder      get_binder_details_type;
   BEGIN
      FOR i IN(SELECT T1.line_cd, T1.binder_yy, T1.binder_seq_no, T1.fnl_binder_id
                 FROM GIRI_BINDER T1,
                      GIRI_FRPS_RI T2,
                      GIRI_DISTFRPS T3,
                      GIUW_POL_DIST T4,
                      GIPI_POLBASIC T5
                WHERE T1.fnl_binder_id = T2.fnl_binder_id
                  AND T2.line_cd = T3.line_cd
                  AND T2.frps_yy = T3.frps_yy
                  AND T2.frps_seq_no = T3.frps_seq_no
                  AND T3.dist_no = T4.dist_no
                  AND T4.policy_id = T5.policy_id
                  AND T5.policy_id = p_policy_id
                  AND T4.dist_flag = '3'
                  AND T2.reverse_sw = 'N')
      LOOP
        v_binder.line_cd := i.line_cd;
        v_binder.binder_yy := i.binder_yy;
        v_binder.binder_seq_no := i.binder_seq_no;
        v_binder.fnl_binder_id := i.fnl_binder_id;
        PIPE ROW(v_binder);
      END LOOP;
   END;
   
   FUNCTION check_binder_exist (
      p_policy_id     NUMBER,
      p_dist_no       NUMBER
   )
      RETURN VARCHAR
   IS
      v_exist VARCHAR2(1) := '0';
   BEGIN
      SELECT '1'
        INTO v_exist
        FROM giri_frps_ri a, giri_binder b, giri_distfrps c, giuw_pol_dist d
       WHERE rownum = 1
         AND a.fnl_binder_id = b.fnl_binder_id
         AND a.line_cd = c.line_cd
         AND a.frps_yy = c.frps_yy
         AND a.frps_seq_no = c.frps_seq_no
         AND c.dist_no = d.dist_no
         AND d.policy_id = p_policy_id
         AND d.dist_no = p_dist_no;

      RETURN v_exist;
   END;

END giri_binder_pkg;
/



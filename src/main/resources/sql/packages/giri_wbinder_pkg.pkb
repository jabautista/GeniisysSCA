CREATE OR REPLACE PACKAGE BODY CPI.GIRI_WBINDER_PKG
AS
   /*
   **  Created by  : Mark JM
   **  Date Created  : 02.17.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description  : Contains the Insert / Update / Delete procedure of the table
   */

   PROCEDURE del_giri_wbinder (
      p_pre_binder_id GIRI_WBINDER.pre_binder_id%TYPE)
   IS
   BEGIN
      DELETE GIRI_WBINDER
       WHERE pre_binder_id = p_pre_binder_id;
   END del_giri_wbinder;

   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  07-05-2011
   **  Reference By : GIRIS002 - Enter RI Acceptance
   **  Description  :
   */
   PROCEDURE create_wbinder_giris002 (
       p_line_cd         IN     giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy         IN     giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no     IN     giri_wfrps_ri.frps_seq_no%TYPE,
      p_user_id         IN     giis_users.user_id%TYPE,
      p_ri_prem_vat_o      OUT VARCHAR2,
      p_subline_cd      IN    varchar2,
      p_iss_cd          IN   varchar2,
      p_par_yy          IN    number,
      p_par_seq_no      IN    number,
      p_pol_seq_no      IN     number,
      p_renew_no        IN     number,
      p_issue_yy        IN     number,
      P_ri_PREM_VAT_NEW    IN     NUMBER,
	  status in varchar2)
   IS
      v_binder_seq_no    giri_wbinder.binder_seq_no%TYPE;
      v_binder_date      giri_wbinder.binder_date%TYPE;
      v_binder_yy        giri_wbinder.binder_yy%TYPE;
      v_ri_prem_vat      giri_wbinder.ri_prem_vat%TYPE;
      v_dummy            VARCHAR2 (2);
      v_binder_seq_no2   NUMBER;

      CURSOR wbinder_area
      IS
         SELECT pre_binder_id,
                T1.line_cd,
                T1.ri_cd,
                ri_tsi_amt,
                ri_shr_pct,
                ri_prem_amt,
                ri_comm_rt,
                ri_comm_amt,
                prem_tax,
                T3.eff_date,
                T3.expiry_date,
                attention,
                T3.policy_id,
                T2.iss_cd,
                T1.ri_comm_vat,
                /*annabelle 01.03.06*/
                (ri_prem_amt * T4.input_vat_rate) / 100 ri_prem_vat,
                NVL (T1.ri_prem_vat, 0) ri_prem_vat_o --issa09.03.2007 to get old ri_prem_vat--modified by Vj 052808
           --(ri_comm_amt * T4.input_vat_rate)/100 ri_comm_vat2
           FROM giri_wfrps_ri T1,
                giri_distfrps_wdistfrps_v T2,
                giuw_pol_dist T3,
                giis_reinsurer T4
          WHERE     T1.line_cd = T2.line_cd
                AND T1.frps_yy = T2.frps_yy
                AND T1.frps_seq_no = T2.frps_seq_no
                AND T2.dist_no = T3.dist_no
                AND T1.ri_cd = T4.ri_cd
                AND T1.line_cd = p_line_cd
                AND T1.frps_yy = p_frps_yy
                AND T1.frps_seq_no = p_frps_seq_no
                AND NOT EXISTS
                           (SELECT '1'
                              FROM giri_frps_ri a
                             WHERE     a.line_cd = p_line_cd
                                   AND a.frps_yy = p_frps_yy
                                   AND a.frps_seq_no = p_frps_seq_no
                                   AND a.fnl_binder_id = pre_binder_id)
                AND NOT EXISTS
                           (SELECT T5.fnl_binder_id
                              FROM giri_distfrps T6, giri_frps_ri T5
                             WHERE     T5.frps_yy = T6.frps_yy
                                   AND T5.frps_seq_no = T6.frps_seq_no
                                   AND T5.line_cd = T6.line_cd
                                   AND T5.fnl_binder_id = T1.pre_binder_id
                                   AND T5.reverse_sw = 'N'
                                   AND T6.dist_no != T2.dist_no
                                   AND EXISTS
                                          (SELECT '1'
                                             FROM giuw_pol_dist T7
                                            WHERE     T7.negate_date
                                                         IS NOT NULL
                                                  AND T7.dist_no = T6.dist_no));
   BEGIN
      v_binder_seq_no := 1;

      BEGIN
         SELECT SYSDATE, TO_NUMBER (TO_CHAR (SYSDATE, 'YY'))
           INTO v_binder_date, v_binder_yy
           FROM DUAL;

         BEGIN
            SELECT fbndr_seq_no + 1
              INTO v_binder_seq_no
              FROM giis_fbndr_seq -- giis_pbndr_seq - wrong table used - irwin 11-26-2012
             WHERE line_cd = p_line_cd AND fbndr_yy = v_binder_yy;

            /* 8/25/2011 - bmq added statement below to avoid ORA-0001 */
            SELECT NVL (MAX (binder_seq_no), 0) + 1
              INTO v_binder_seq_no2
              FROM giri_wbinder
             WHERE line_cd = p_line_cd AND binder_yy = v_binder_yy;

            IF v_binder_seq_no2 > v_binder_seq_no
            THEN
               v_binder_seq_no := v_binder_seq_no2;
            END IF;
         /* END 8/25/2011 */
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;                                        --roset, 2/16/2011
         --made into comment by roset, pbndr_seq will no longer be used, bec of issue regarding skipping binder_seq_no
         /*INSERT INTO giis_pbndr_seq
           (line_cd, fbndr_yy,    fbndr_seq_no,
            user_id, last_update, remarks)
         VALUES
           (:v100.line_cd,     v_binder_yy,   1,
            USER, v_binder_date, 'printing of prelim. binder');*/
         END;
      END;

      p_ri_prem_vat_o := 'N';

      FOR c1_rec IN wbinder_area
      LOOP
         v_ri_prem_vat := c1_rec.ri_prem_vat;
         p_ri_prem_vat_o := TO_CHAR (c1_rec.ri_prem_vat_o, '99999.99');

         FOR c2
            IN (SELECT 1
                  FROM giri_wfrps_ri
                 WHERE     line_cd = p_line_cd
                       AND frps_yy = p_frps_yy
                       AND frps_seq_no = p_frps_seq_no
                       AND NVL (ri_prem_vat, 0) = 0)
         LOOP
            --ADJUST_PREM_VAT(v_ri_prem_vat,c1_rec.ri_cd);
            ADJUST_PREM_VAT_GIRIS002 (v_ri_prem_vat,
                                      c1_rec.ri_cd,
                                      p_ri_prem_vat_o,
                                      P_LINE_CD,
                                      p_subline_cd,
                                      p_iss_cd,
                                      p_par_yy,
                                      p_par_seq_no,
                                      p_pol_seq_no,
                                      p_renew_no,
                                      p_issue_yy,
                                      P_ri_PREM_VAT_NEW, STATUS);
         END LOOP;

         INSERT INTO giri_wbinder (pre_binder_id,
                                   line_cd,
                                   binder_yy,
                                   binder_seq_no,
                                   ri_cd,
                                   ri_tsi_amt,
                                   ri_shr_pct,
                                   ri_prem_amt,
                                   ri_comm_rt,
                                   ri_comm_amt,
                                   prem_tax,
                                   eff_date,
                                   expiry_date,
                                   binder_date,
                                   attention,
                                   create_binder_date,
                                   policy_id,
                                   iss_cd,
                                   ri_prem_vat,
                                   ri_comm_vat)
              VALUES (c1_rec.pre_binder_id,
                      c1_rec.line_cd,
                      v_binder_yy,
                      v_binder_seq_no,
                      c1_rec.ri_cd,
                      c1_rec.ri_tsi_amt,
                      c1_rec.ri_shr_pct,
                      c1_rec.ri_prem_amt,
                      c1_rec.ri_comm_rt,
                      c1_rec.ri_comm_amt,
                      c1_rec.prem_tax,
                      c1_rec.eff_date,
                      c1_rec.expiry_date,
                      v_binder_date,
                      c1_rec.attention,
                      SYSDATE,
                      c1_rec.policy_id,
                      c1_rec.iss_cd,
                      v_ri_prem_vat,
                      c1_rec.ri_comm_vat);

         v_binder_seq_no := v_binder_seq_no + 1;
      END LOOP;
   --this part made into comment by roset,no need to update giis_pbndr_seq since binder_seq_no is based on giis_fbndr_seq , 2/14/2011
   /*
        UPDATE giis_pbndr_seq
           SET fbndr_seq_no = v_binder_seq_no-1
         WHERE line_cd      = p_line_cd
           AND fbndr_yy     = v_binder_yy;*/

   END create_wbinder_giris002;

   FUNCTION check_giri_wbinder_exist (
      p_pre_binder_id giri_wbinder.pre_binder_id%TYPE)
      RETURN NUMBER
   IS
      v_ctr   NUMBER := 0;
   BEGIN
      FOR ctr IN (SELECT pre_binder_id
                    FROM giri_wbinder
                   WHERE pre_binder_id = p_pre_binder_id)
      LOOP
         v_ctr := 1;
      END LOOP;

      RETURN v_ctr;
   END check_giri_wbinder_exist;

   /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 08.12.2011
    **  Reference By     : (GIUTS004- Reverse Binder)
    **  Description      : Copy data from GIRI_BINDER to GIRI_WBINDER
    **                     for records not tagged for reversal.
    */
   PROCEDURE copy_binder (
      p_line_cd         IN giri_frps_ri.line_cd%TYPE,
      p_frps_yy         IN giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no     IN giri_frps_ri.frps_seq_no%TYPE,
      p_fnl_binder_id   IN giri_frps_ri.fnl_binder_id%TYPE,
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE)
   IS
      v_policy_id   giuw_pol_dist.policy_id%TYPE;
      v_iss_cd      gipi_polbasic.iss_cd%TYPE;

      CURSOR binder
      IS
         SELECT a.fnl_binder_id,
                a.line_cd,
                a.binder_yy,
                a.binder_seq_no,
                a.ri_cd,
                a.ri_tsi_amt,
                a.ri_shr_pct,
                a.ri_prem_amt,
                a.ri_comm_rt,
                a.ri_comm_amt,
                a.prem_tax,
                a.eff_date,
                a.expiry_date,
                a.binder_date,
                a.attention,
                a.confirm_no,
                a.confirm_date,
                a.reverse_date,
                a.acc_ent_date,
                a.acc_rev_date,
                --added other columns by j.diago 09.17.2014 : par_id not included for the mean time
                a.create_binder_date, a.ri_prem_vat, a.ri_comm_vat--, a.par_id
           FROM giri_binder a, giri_frps_ri b
          WHERE     a.fnl_binder_id = b.fnl_binder_id
                AND b.line_cd = p_line_cd
                AND b.frps_yy = p_frps_yy
                AND b.frps_seq_no = p_frps_seq_no
                AND a.fnl_binder_id = p_fnl_binder_id;
   BEGIN
      FOR c1_rec IN binder
      LOOP
         FOR pol
            IN (SELECT b.policy_id, b.iss_cd
                  FROM giuw_pol_dist a, gipi_polbasic b
                 WHERE dist_no = p_dist_no AND a.policy_id = b.policy_id)
         LOOP
            v_policy_id := pol.policy_id;
            v_iss_cd := pol.iss_cd;
            EXIT;
         END LOOP;

         INSERT INTO giri_wbinder (pre_binder_id,
                                   line_cd,
                                   binder_yy,
                                   binder_seq_no,
                                   ri_cd,
                                   ri_tsi_amt,
                                   ri_shr_pct,
                                   ri_prem_amt,
                                   ri_comm_rt,
                                   ri_comm_amt,
                                   prem_tax,
                                   eff_date,
                                   expiry_date,
                                   binder_date,
                                   attention,
                                   confirm_no,
                                   confirm_date,
                                   reverse_date,
                                   policy_id,
                                   iss_cd,
                                   create_binder_date, ri_prem_vat, ri_comm_vat
                                   --,par_id
                                   )
              VALUES (c1_rec.fnl_binder_id,
                      c1_rec.line_cd,
                      c1_rec.binder_yy,
                      c1_rec.binder_seq_no,
                      c1_rec.ri_cd,
                      c1_rec.ri_tsi_amt,
                      c1_rec.ri_shr_pct,
                      c1_rec.ri_prem_amt,
                      c1_rec.ri_comm_rt,
                      c1_rec.ri_comm_amt,
                      c1_rec.prem_tax,
                      c1_rec.eff_date,
                      c1_rec.expiry_date,
                      c1_rec.binder_date,
                      c1_rec.attention,
                      c1_rec.confirm_no,
                      c1_rec.confirm_date,
                      NULL,
                      v_policy_id,
                      v_iss_cd,
                      c1_rec.create_binder_date, c1_rec.ri_prem_vat, c1_rec.ri_comm_vat
                      --c1_rec.par_id
                      );
      END LOOP;
   END copy_binder;
END GIRI_WBINDER_PKG;
/



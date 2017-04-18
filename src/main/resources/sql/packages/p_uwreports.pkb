CREATE OR REPLACE PACKAGE BODY CPI.p_uwreports
/* author     : terrence to
** desciption : this package will hold all the procedures and functions that will
**              handle the extraction for uwreports (gipis901a) module. 
**
*/
AS
   /*
   **  Created by:  Jason 8/1/2008
   **  Description: Retrieve the commission amount
   */
   /*  Modified by: Jhing Factor  **
   **  Modified on: 02.06.2013
   **  Modifications: modified the queries from POP_UWREPORTS_DIST_EXT
   **/
   FUNCTION get_comm_amt (
      p_prem_seq_no   NUMBER,
      p_iss_cd        VARCHAR2,
      p_scope         NUMBER,                                 -- aaron 061009
      p_param_date    NUMBER,
      p_from_date     DATE,
      p_to_date       DATE,
      p_policy_id     NUMBER
   )
      RETURN NUMBER
   IS
      v_commission        NUMBER (20, 2);
      v_commission_amt    NUMBER (20, 2);
      v_commission_amt1   NUMBER (20, 2) := 0;    -- added by jeremy 11302010
      v_comm_amt          NUMBER (20, 2);
      v_comm_tot          NUMBER (20, 2) := 0;
      found_flag          NUMBER (1)     := 0;    -- added by jeremy 11302010
   BEGIN
      DBMS_OUTPUT.put_line ('1 ' || v_comm_tot);

      FOR rc IN
         (SELECT         -- b.intrmdry_intm_no,  commented by jeremy 11302010
                   b.iss_cd, b.prem_seq_no, SUM (c.ri_comm_amt) ri_comm_amt,
                   c.currency_rt, SUM (b.commission_amt) commission_amt,
                   
                   --SUM(DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) comm_amt
                   a.issue_date, a.eff_date, c.acct_ent_date,
                   a.spld_acct_ent_date, c.multi_booking_mm,
                   c.multi_booking_yy, a.cancel_date,
                   a.endt_seq_no                -- added adrel09032009 pnbgen
              FROM gipi_comm_invoice b, gipi_invoice c, gipi_polbasic a
             WHERE b.iss_cd = c.iss_cd
               AND a.policy_id = b.policy_id
               AND a.policy_id = p_policy_id
               AND b.prem_seq_no = c.prem_seq_no
               AND p_uwreports.check_date_policy
                       (p_scope,
                        p_param_date,
                        p_from_date,
                        p_to_date,
                        a.issue_date,
                        a.eff_date,
                        --gpd.acct_ent_date, --aaron 010609
                        c.acct_ent_date,                               --glyza
                        a.spld_acct_ent_date,
                        --gp.booking_mth,
                        --gp.booking_year,
                        c.multi_booking_mm,                            --glyza
                        c.multi_booking_yy,                            --glyza
                        a.cancel_date,
                                      --issa01.23.2008 to consider cancel_date
                        a.endt_seq_no
                       ) = 1     -- to consider if policies only or endts only
          GROUP BY b.iss_cd,
                   b.prem_seq_no,
                   c.currency_rt,
                   a.issue_date,
                   a.eff_date,
                   c.acct_ent_date,
                   a.spld_acct_ent_date,
                   c.multi_booking_mm,
                   c.multi_booking_yy,
                   a.cancel_date,
                   a.endt_seq_no)
      LOOP
         v_commission := 0;

         IF (rc.ri_comm_amt * rc.currency_rt) = 0
         THEN
            DBMS_OUTPUT.put_line ('x');
            v_commission_amt := rc.commission_amt;

            IF p_uwreports.check_date_policy (p_scope,
                                              p_param_date,
                                              p_from_date,
                                              p_to_date,
                                              rc.issue_date,
                                              rc.eff_date,
                                              rc.acct_ent_date,
                                              rc.spld_acct_ent_date,
                                              rc.multi_booking_mm,
                                              rc.multi_booking_yy,
                                              rc.cancel_date,
                                              rc.endt_seq_no
                                             ) = 1
            THEN                             -- ADREL 09032009 ADDED CONDITION
               FOR c1 IN
                  (SELECT commission_amt
                     FROM giac_prev_comm_inv
                    WHERE    /*fund_cd = v_fund_cd
                          AND branch_cd = v_branch_cd --jason 11/9/2007: comment out as instructed by Ms Juday
                          AND*/ comm_rec_id =
                             (SELECT MIN
                                        (comm_rec_id)
-- modified to retrieve amt in prev comm (included giac_new_comm_inv loop in where clause here)  adrel090309
                                FROM giac_new_comm_inv n, gipi_invoice i
                               WHERE n.iss_cd = i.iss_cd
                                 AND n.prem_seq_no = i.prem_seq_no
                                 AND n.iss_cd = rc.iss_cd
                                 AND n.prem_seq_no = rc.prem_seq_no
                                 AND n.tran_flag = 'P'
                                 AND NVL (n.delete_sw, 'N') = 'N'
                                 --AND n.intm_no = rc.intrmdry_intm_no commented by jeremy 11302010 for records wherein intm was changed thru modify comm
                                 AND n.acct_ent_date >= i.acct_ent_date)
             -- judyann 10082009; modification is done after take-up of policy
                      --  AND intm_no = rc.intrmdry_intm_no commented by jeremy 11302010
                      AND acct_ent_date BETWEEN p_from_date AND p_to_date)
                 -- judyann 10082009; policy is booked within the given period
               LOOP
                  /* commented by jeremy 11302010
                  v_commission_amt := c1.commission_amt;
                  EXIT;
                  */
                  -- replaced by statements below
                  -- start
                  found_flag := 1;
                  v_commission_amt1 := v_commission_amt1 + c1.commission_amt;
               -- end jeremy 11302010
               END LOOP;
            END IF;
       -- END CHECKING IF P_Uwreports.Check_Date_Policy = 1  -- ADREL 09032009

            -- v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0); commented by jeremy 11302010
            -- replaced by statements below
            -- start jeremy 11302010
            IF found_flag = 1
            THEN
               /* found_flag 1 means bill has been modified and taken up comm amount will be extracted and not the new commission */
               v_comm_amt := NVL (v_commission_amt1 * rc.currency_rt, 0);
            ELSE
               /* meaning commission amount in gipi_comm_invoice will be extracted */
               v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
            END IF;
         -- end jeremy 11302010
         ELSE
            v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
         END IF;

         v_commission := NVL (v_commission, 0) + v_comm_amt;
         v_comm_tot := v_comm_tot + v_commission;
      END LOOP;

      RETURN (v_comm_tot);
   --commision amount is zero if the for loop statement is not executed
   --RETURN 0;
   END get_comm_amt;

   FUNCTION check_date_dist_peril 
                                  /** rollie 02/18/04
                                  *** date parameter of the last endorsement of policy
                                  *** must not be within the date given, else it will
                                  *** be exluded
                                  *** NOTE: policy with pol_flag = '4' only
                                  **/
   (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_param_date   NUMBER,
      p_from_date    DATE,
      p_to_date      DATE
   )
      RETURN NUMBER
   IS
      v_check_date   NUMBER (1) := 0;
   BEGIN
      FOR a IN (SELECT a.issue_date issue_date, a.eff_date eff_date,
                       
                       --A.booking_mth   booking_month,
                       --A.booking_year  booking_year,
                       --A.acct_ent_date acct_ent_date,
                       /*convert_month (*/
                       c.multi_booking_mm /*)*/ booking_month,            --i
                       c.multi_booking_yy booking_year,                   --i
                                                       c.acct_ent_date,   --i
                       b.acct_neg_date acct_neg_date
                  FROM gipi_polbasic a, giuw_pol_dist b, gipi_invoice c
                 WHERE a.policy_id = b.policy_id
                   AND a.policy_id = c.policy_id                           --i
                   AND NVL (b.takeup_seq_no, 1) = c.takeup_seq_no
                   AND a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.endt_seq_no =
                          (SELECT MAX (c.endt_seq_no)
                             FROM gipi_polbasic c
                            WHERE c.line_cd = p_line_cd
                              AND c.subline_cd = p_subline_cd
                              AND c.iss_cd = p_iss_cd
                              AND c.issue_yy = p_issue_yy
                              AND c.pol_seq_no = p_pol_seq_no
                              AND c.renew_no = p_renew_no))
      LOOP
         IF p_param_date = 1
         THEN                                          ---based on issue_date
            IF TRUNC (a.issue_date) NOT BETWEEN p_from_date AND p_to_date
            THEN
               v_check_date := 1;
            END IF;
         ELSIF p_param_date = 2
         THEN                                           --based on incept_date
            IF TRUNC (a.eff_date) NOT BETWEEN p_from_date AND p_to_date
            THEN
               v_check_date := 1;
            END IF;
         ELSIF p_param_date = 3
         THEN                                        --based on booking mth/yr
            --dbms_output.put_line(A.booking_month);
            IF LAST_DAY (TO_DATE (   a.booking_month
                                  || ','
                                  || TO_CHAR (a.booking_year),
                                  'FMMONTH,YYYY'
                                 )
                        ) NOT BETWEEN LAST_DAY (p_from_date)
                                  AND LAST_DAY (p_to_date)
            THEN
               v_check_date := 1;
            END IF;
         ELSIF p_param_date = 4
         THEN                                         --based on acct_ent_date
            IF (   TRUNC (a.acct_ent_date) NOT BETWEEN p_from_date AND p_to_date
                OR NVL (TRUNC (a.acct_neg_date), p_to_date + 1) NOT
                      BETWEEN p_from_date
                          AND p_to_date
               )
            THEN
               v_check_date := 1;
            END IF;
         END IF;
      END LOOP;

      RETURN (v_check_date);
   END;                                   --end function check_date_dist_peril

   FUNCTION check_date_policy 
                              /** rollie 19july2004
                              *** get the dates of certain policy
                              **/
   (
      p_scope           NUMBER,
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE,
      p_issue_date      DATE,
      p_eff_date        DATE,
      p_acct_ent_date   DATE,
      p_spld_acct       DATE,
      p_booking_mth     gipi_polbasic.booking_mth%TYPE,
      p_booking_year    gipi_polbasic.booking_year%TYPE,
      p_cancel_date     gipi_polbasic.cancel_date%TYPE,
--issa01.23.2008 added cancel date to consider p_scope = 3 (cancellation policies)
      p_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE
   )                                   --to consider policies only/ endts only
      RETURN NUMBER
   IS
      v_check_date   NUMBER (1) := 0;
   BEGIN
      IF p_param_date = 1
      THEN                                             ---based on issue_date
         IF TRUNC (p_issue_date) BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 2
      THEN                                              --based on incept_date
         IF TRUNC (p_eff_date) BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 3
      THEN                                           --based on booking mth/yr
         DBMS_OUTPUT.put_line ('x ' || p_booking_mth);

         IF LAST_DAY (TO_DATE (p_booking_mth || ','
                               || TO_CHAR (p_booking_year),
                               'FMMONTH,YYYY'
                              )
                     ) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
         THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL
      THEN                                            --based on acct_ent_date
         IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date
         THEN
            IF p_scope = 5
            THEN
               IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
               THEN
                  --AND p_spld_acct IS NOT NULL /*and p_scope=5*/ THEN  --comment out by belle 01282011
                  v_check_date := 0;
               ELSE                                       --all except spolied
                  v_check_date := 1;
               END IF;
            --added by belle 01282011
            ELSIF p_scope = 4
            THEN
               IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
               THEN                                                 --spoiled
                  v_check_date := 1;
               ELSE
                  v_check_date := 0;
               END IF;
            -- end belle
            ELSIF p_scope = 3
            THEN              --issa01.23.2008, to consider cancelled policies
               IF TRUNC (p_cancel_date) BETWEEN p_from_date AND p_to_date
               THEN
                  v_check_date := 1;
               ELSE
                  v_check_date := 0;
               END IF;
            ELSIF p_scope = 2
            THEN                               --to consider endorsements only
               IF p_endt_seq_no > 0
               THEN
                  v_check_date := 1;
               ELSE
                  v_check_date := 0;
               END IF;
            ELSIF p_scope = 1
            THEN                                   --to consider policies only
               IF p_endt_seq_no = 0
               THEN
                  v_check_date := 1;
               ELSE
                  v_check_date := 0;
               END IF;                                             -- end issa
            ELSE                   --for scope that is NULL : jason 11/18/2008
               v_check_date := 1;
            END IF;
         --added by belle 01282011
         ELSE
            IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
            THEN                                                    --spoiled
               IF p_scope = 4
               THEN                                                   --april
                  v_check_date := 1;
               ELSE
                  v_check_date := 0;
               END IF;                                                 --april
            END IF;
         --belle

         /**ELSIF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date THEN --spoiled  -- belle 01282011 replaced by above codes
           IF p_scope = 4 THEN
             v_check_date := 1;
           ELSE
             v_check_Date := 0;
           END IF; --**/ --belle
         END IF;
      END IF;

      RETURN (v_check_date);
   END;                                       --end function check_date_policy

   FUNCTION check_date 
                       /* rollie 06jan2006
                          verify if cancel date of latest endt was not between date parameters
                          else exluded
                       */
   (
      p_scope        NUMBER,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_param_date   NUMBER,
      p_from_date    DATE,
      p_to_date      DATE
   )
      RETURN NUMBER
   IS
      v_check_date   NUMBER (1) := 1;
   BEGIN
      FOR a IN (SELECT                       /*a.issue_date issue_date,
                                       a.eff_date   eff_date,
                                   a.booking_mth booking_month,
                                   a.booking_year booking_year,
                                   a.acct_ent_date acct_ent_date,
                                   a.spld_acct_ent_date spld_acct_ent_date,*/
                       a.cancel_date
                  FROM gipi_polbasic a
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND endt_seq_no IN (
                          SELECT MAX (endt_seq_no)
                            FROM gipi_polbasic b
                           WHERE a.line_cd = b.line_cd
                             AND a.subline_cd = b.subline_cd
                             AND a.iss_cd = b.iss_cd
                             AND a.issue_yy = b.issue_yy
                             AND a.pol_seq_no = b.pol_seq_no
                             AND a.renew_no = b.renew_no))
      LOOP
         IF a.cancel_date BETWEEN p_from_date AND p_to_date
         THEN
            v_check_date := 0;
         END IF;

         /*
         IF p_param_date = 1 THEN ---based on issue_date
            IF trunc(a.issue_date) NOT BETWEEN p_from_date AND p_to_date THEN
              v_check_date := 1;
            END IF;
          ELSIF p_param_date = 2 THEN --based on incept_date
            IF trunc(a.eff_date) NOT BETWEEN p_from_date AND p_to_date THEN
              v_check_date := 1;
            END IF;
          ELSIF p_param_date = 3 THEN --based on booking mth/yr
            IF last_day ( to_date ( a.booking_month || ',' || to_char (a.booking_year),'FMMONTH,YYYY'))
              NOT BETWEEN last_day (p_from_date) AND last_day (p_to_date) THEN
                v_check_date := 1;
            END IF;
          ELSIF p_param_date = 4 THEN --based on acct_ent_date
            IF (trunc (a.acct_ent_date) NOT BETWEEN p_from_date AND p_to_date
              OR nvl (trunc (a.spld_acct_ent_date), p_to_date + 1)
              NOT BETWEEN p_from_date AND p_to_date) THEN
                v_check_date := 1;
            END IF;
          END IF;*/
         EXIT;
      END LOOP;

      RETURN (v_check_date);
   END;                                              --end function check_date

/*  FUNCTION check_date_cancel
    /** rollie 02/18/04
    *** date parameter of the last endorsement of policy
    *** must be within the date given, else it will
    *** be exluded
    *** note: policy with pol_flag = '4' only
    **/
/*   (p_cancel_date  DATE,
    p_param_date NUMBER,
    p_from_date DATE,
    p_to_date     DATE)
    RETURN NUMBER IS
      v_check_date NUMBER(1) := 0;

  BEGIN
    IF p_cancel_date IS NULL THEN
      RETURN (v_check_date);
    END;
*/
/*  FUNCTION check_date_param
   (
  BEGIN

  END; --end function check_date_param
*/
   PROCEDURE pol_taxes
   IS
      v_evat         giac_parameters.param_value_v%TYPE;
      v_5prem_tax    giac_parameters.param_value_v%TYPE;
      v_fst          giac_parameters.param_value_v%TYPE;
      v_lgt          giac_parameters.param_value_v%TYPE;
      v_doc_stamps   giac_parameters.param_value_v%TYPE;
   BEGIN
      v_evat := giacp.n ('EVAT');
      v_5prem_tax := giacp.n ('5PREM_TAX');
      v_fst := giacp.n ('FST');
      v_lgt := giacp.n ('LGT');
      v_doc_stamps := giacp.n ('DOC_STAMPS');
      -- for evat
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) evat,
                         giv.policy_id policy_id
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd IN (v_5prem_tax, v_evat)
                GROUP BY giv.policy_id) evat
         ON (evat.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.evatprem = evat.evat + NVL (gpp.evatprem, 0)
         WHEN NOT MATCHED THEN
            INSERT (evatprem, policy_id)
            VALUES (evat.evat, evat.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'EVAT01');
 -- for 5evat_prem
/*    MERGE INTO gipi_uwreports_ext gpp USING
      (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) evat,
              giv.policy_id policy_id
         FROM gipi_inv_tax git,
       gipi_invoice giv,
     gipi_uwreports_ext gpp
        WHERE 1 = 1
          AND giv.item_grp    = git.item_grp
          AND giv.iss_cd      = git.iss_cd
          AND giv.prem_seq_no = git.prem_seq_no
          AND git.tax_cd      >= 0
       AND giv.policy_id   = gpp.policy_id
       AND gpp.user_id     = USER
          AND git.tax_cd      = Giacp.n ('EVAT')
     GROUP BY giv.policy_id) evat
         ON (evat.policy_id=gpp.policy_id)
         WHEN MATCHED THEN UPDATE
          SET gpp.evatprem = evat.evat + NVL(gpp.evatprem,0)
         WHEN NOT MATCHED THEN
       INSERT (evatprem,policy_id)
       VALUES (evat.evat,evat.policy_id);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'EVAT02');
*/
    -- for fst
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) fst,
                         giv.policy_id policy_id
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_fst
                GROUP BY giv.policy_id) fst
         ON (fst.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.fst = fst.fst + NVL (gpp.fst, 0)
         WHEN NOT MATCHED THEN
            INSERT (fst, policy_id)
            VALUES (fst.fst, fst.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'FST');
      --for lgt
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) lgt,
                         giv.policy_id policy_id
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_lgt
                GROUP BY giv.policy_id) lgt
         ON (lgt.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.lgt = lgt.lgt + NVL (gpp.lgt, 0)
         WHEN NOT MATCHED THEN
            INSERT (lgt, policy_id)
            VALUES (lgt.lgt, lgt.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'LGT');
      -- other charges
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (giv.other_charges * giv.currency_rt, 0)
                             ) other_charges,
                         giv.policy_id policy_id
                    FROM gipi_invoice giv, gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                GROUP BY giv.policy_id) goc
         ON (goc.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.other_charges =
                                goc.other_charges + NVL (gpp.other_charges, 0)
         WHEN NOT MATCHED THEN
            INSERT (other_charges, policy_id)
            VALUES (goc.other_charges, goc.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OT');
      -- other taxes
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)
                             ) other_taxes,
                         giv.policy_id policy_id
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd NOT IN
                            (v_evat, v_doc_stamps, v_fst, v_lgt, v_5prem_tax)
                GROUP BY giv.policy_id) got
         ON (got.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.other_taxes =
                                    got.other_taxes + NVL (gpp.other_taxes, 0)
         WHEN NOT MATCHED THEN
            INSERT (other_taxes, policy_id)
            VALUES (got.other_taxes, got.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OC');
      -- doc stamps
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt, 0) * NVL (giv.currency_rt, 0)
                             ) doc_stamps,
                         giv.policy_id
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.item_grp = git.item_grp
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_doc_stamps
                GROUP BY giv.policy_id) doc
         ON (doc.policy_id = gpp.policy_id)
         WHEN MATCHED THEN
            UPDATE
               SET gpp.doc_stamps = doc.doc_stamps + NVL (gpp.doc_stamps, 0)
         WHEN NOT MATCHED THEN
            INSERT (doc_stamps, policy_id)
            VALUES (doc.doc_stamps, doc.policy_id);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'DOC');
   END;                                              --end procedure pol_taxes

   PROCEDURE pol_taxes2 (
      p_item_grp             gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
      p_policy_id            gipi_invoice.policy_id%TYPE,
      p_scope           IN   NUMBER,                           -- aaron 061009
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE
   )
   IS
      v_evat         giac_parameters.param_value_v%TYPE;
      v_5prem_tax    giac_parameters.param_value_v%TYPE;
      v_fst          giac_parameters.param_value_v%TYPE;
      v_lgt          giac_parameters.param_value_v%TYPE;
      v_doc_stamps   giac_parameters.param_value_v%TYPE;
      v_layout       NUMBER;                               --jason 07/31/2008
   BEGIN
      v_evat := giacp.n ('EVAT');
      v_5prem_tax := giacp.n ('5PREM_TAX');
      v_fst := giacp.n ('FST');
      v_lgt := giacp.n ('LGT');
      v_doc_stamps := giacp.n ('DOC_STAMPS');
      v_layout := giisp.n ('PROD_REPORT_EXTRACT');          --jason 7/31/2008
      -- for evat
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) evat,
                         giv.policy_id policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt --added by jason
                                                            ,
                         gpp.user_id                       --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd IN (v_5prem_tax, v_evat)
                     AND NVL (giv.takeup_seq_no, 1) =
                                              NVL (p_takeup_seq_no, 1)
                                                                      -- aaron
                     --AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) evat
         ON (evat.policy_id = gpp.policy_id AND evat.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.evatprem = evat.evat + NVL (gpp.evatprem, 0),
                   gpp.comm_amt = evat.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (evatprem, policy_id, comm_amt)
            VALUES (evat.evat, evat.policy_id, evat.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'EVAT01');
      -- for fst
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) fst,
                         giv.policy_id policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt  --added by jason
                                                            ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_fst
-------------
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     -- AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
----------------
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) fst
         ON (fst.policy_id = gpp.policy_id AND fst.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.fst = fst.fst + NVL (gpp.fst, 0),
                   gpp.comm_amt = fst.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (fst, policy_id, comm_amt)
            VALUES (fst.fst, fst.policy_id, fst.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'FST');
      --for lgt
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)) lgt,
                         giv.policy_id policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt  --added by jason
                                                            ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_lgt
                     ----------
                     AND NVL (giv.takeup_seq_no, 1) =
                                               NVL (p_takeup_seq_no, 1)
                                                                       --aaron
                     --AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
                ---------
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) lgt
         ON (lgt.policy_id = gpp.policy_id AND lgt.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.lgt = lgt.lgt + NVL (gpp.lgt, 0),
                   gpp.comm_amt = lgt.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (lgt, policy_id, comm_amt)
            VALUES (lgt.lgt, lgt.policy_id, lgt.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'LGT');
      -- other charges
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (giv.other_charges * giv.currency_rt, 0)
                             ) other_charges,
                         giv.policy_id policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt  --added by jason
                                                            ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_invoice giv, gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
-------------
                     AND NVL (giv.takeup_seq_no, 1) =
                                              NVL (p_takeup_seq_no, 1)
                                                                      -- aaron
                     --AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
---------------
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) goc
         ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.other_charges =
                                goc.other_charges + NVL (gpp.other_charges, 0),
                   gpp.comm_amt = goc.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (other_charges, policy_id, comm_amt)
            VALUES (goc.other_charges, goc.policy_id, goc.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OT');
      -- other taxes
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt * giv.currency_rt, 0)
                             ) other_taxes,
                         giv.policy_id policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt  --added by jason
                                                            ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE 1 = 1
                     AND giv.item_grp = git.item_grp
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd NOT IN
                            (v_evat, v_doc_stamps, v_fst, v_lgt, v_5prem_tax)
-----------------
                     AND NVL (giv.takeup_seq_no, 1) =
                                              NVL (p_takeup_seq_no, 1)
                                                                      -- aaron
                     --  AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
-----------------
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) got
         ON (got.policy_id = gpp.policy_id AND got.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.other_taxes =
                                    got.other_taxes + NVL (gpp.other_taxes, 0),
                   gpp.comm_amt = got.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (other_taxes, policy_id, comm_amt)
            VALUES (got.other_taxes, got.policy_id, got.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'OC');
      -- doc stamps
      MERGE INTO gipi_uwreports_ext gpp
         USING (SELECT   SUM (NVL (git.tax_amt, 0) * NVL (giv.currency_rt, 0)
                             ) doc_stamps,
                         giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ) comm_amt  --added by jason
                                                            ,
                         gpp.user_id                        --jason 10/17/2008
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_uwreports_ext gpp
                   WHERE giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.tax_cd >= 0
                     AND giv.item_grp = git.item_grp
                     AND giv.policy_id = gpp.policy_id
                     AND gpp.user_id = USER
                     AND git.tax_cd = v_doc_stamps
                     ----------
                     AND NVL (giv.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1)
                     --AND giv.takeup_seq_no  = p_takeup_seq_no
                     AND giv.item_grp = p_item_grp
                     AND giv.policy_id = p_policy_id
-----------
                GROUP BY giv.policy_id,
                         p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                   giv.iss_cd,
                                                   p_scope,
                                                   p_param_date,
                                                   p_from_date,
                                                   p_to_date,
                                                   p_policy_id
                                                  ),
                         gpp.user_id) doc
         ON (doc.policy_id = gpp.policy_id AND doc.user_id = gpp.user_id)
                                                            --jason 10/17/2008
         WHEN MATCHED THEN
            UPDATE
               SET gpp.doc_stamps = doc.doc_stamps + NVL (gpp.doc_stamps, 0),
                   gpp.comm_amt = doc.comm_amt
         WHEN NOT MATCHED THEN
            INSERT (doc_stamps, policy_id, comm_amt)
            VALUES (doc.doc_stamps, doc.policy_id, doc.comm_amt);
      COMMIT;
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'DOC');

      --**jason 07/31/2008 start**--
      IF v_layout = 2
      THEN
         FOR j IN (SELECT a.tax_cd
                     FROM gipi_inv_tax a, gipi_invoice b
                    WHERE a.prem_seq_no = b.prem_seq_no
                      AND a.iss_cd = b.iss_cd                --lems 06.19.2009
                      AND b.policy_id = p_policy_id
                      AND b.item_grp = p_item_grp
                      AND NVL (b.takeup_seq_no, 1) = NVL (p_takeup_seq_no, 1))
                                                            -- aaron added nvl
         LOOP
            DBMS_OUTPUT.put_line (   j.tax_cd
                                  || '/'
                                  || p_takeup_seq_no
                                  || '/'
                                  || p_item_grp
                                  || '/'
                                  || p_policy_id
                                 );
            do_ddl
               (   'MERGE INTO GIPI_UWREPORTS_EXT gpp USING'
                || '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'
                || '           giv.policy_id, p_uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                || p_scope
                || ', '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || ') comm_amt'
                || '          ,gpp.user_id'
                || '      FROM GIPI_INV_TAX git,'
                || '           GIPI_INVOICE giv,'
                || '           GIPI_UWREPORTS_EXT gpp'
                || '     WHERE giv.iss_cd       = git.iss_cd'
                || '       AND giv.prem_seq_no  = git.prem_seq_no'
                || '       AND git.tax_cd       >= 0'
                || '       AND giv.item_grp     = git.item_grp'
                || '       AND giv.policy_id    = gpp.policy_id'
                || '       AND gpp.user_id      = USER'
                || '       AND git.tax_cd       = '
                || j.tax_cd
                || '       AND NVL(giv.takeup_seq_no,1)  = '
                || NVL (p_takeup_seq_no, 1)
                || '       AND giv.item_grp    = '
                || p_item_grp
                || '       AND giv.policy_id = '
                || p_policy_id
                || '     GROUP BY giv.policy_id, p_uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                || p_scope
                || ', '
                || p_param_date
                || ', '''
                || p_from_date
                || ''', '''
                || p_to_date
                || ''', '
                || p_policy_id
                || '),gpp.user_id) subq'
                || '        ON (subq.policy_id = gpp.policy_id '
                || '            AND subq.user_id = gpp.user_id )'
                || '      WHEN MATCHED THEN UPDATE'
                || '        SET gpp.tax'
                || j.tax_cd
                || ' = subq.tax_amt + NVL(gpp.tax'
                || j.tax_cd
                || ',0)'
                || '           ,gpp.comm_amt = subq.comm_amt'
                || '      WHEN NOT MATCHED THEN'
                || '        INSERT (tax'
                || j.tax_cd
                || ',policy_id, comm_amt)'
                || '        VALUES (subq.tax_amt,subq.policy_id, subq.comm_amt)'
               );
            COMMIT;
         END LOOP;

         -- other charges
         MERGE INTO gipi_uwreports_ext gpp
            USING (SELECT   SUM (NVL (giv.other_charges * giv.currency_rt, 0)
                                ) other_charges,
                            giv.policy_id policy_id,
                            p_uwreports.get_comm_amt
                                                   (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_scope,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    p_policy_id
                                                   ) comm_amt,
                            gpp.user_id                     --jason 10/17/2008
                       FROM gipi_invoice giv, gipi_uwreports_ext gpp
                      WHERE 1 = 1
                        AND giv.policy_id = gpp.policy_id
                        AND gpp.user_id = USER
                        AND NVL (giv.takeup_seq_no, 1) =
                                                      NVL (p_takeup_seq_no, 1)
                        --AND giv.takeup_seq_no  = p_takeup_seq_no
                        AND giv.item_grp = p_item_grp
                        AND giv.policy_id = p_policy_id
                   GROUP BY giv.policy_id,
                            p_uwreports.get_comm_amt (giv.prem_seq_no,
                                                      giv.iss_cd,
                                                      p_scope,
                                                      p_param_date,
                                                      p_from_date,
                                                      p_to_date,
                                                      p_policy_id
                                                     ),
                            gpp.user_id) goc
            ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id)
            WHEN MATCHED THEN
               UPDATE
                  SET gpp.other_charges =
                                goc.other_charges + NVL (gpp.other_charges, 0),
                      gpp.comm_amt = goc.comm_amt
            WHEN NOT MATCHED THEN
               INSERT (other_charges, policy_id, comm_amt)
               VALUES (goc.other_charges, goc.policy_id, goc.comm_amt);
         COMMIT;
      --**jason 07/31/2008 end**--
      END IF;
   END;                                             --end procedure pol_taxes2

   PROCEDURE pol_gixx_pol_prod (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2,
      p_nonaff_endt   IN   VARCHAR2,             --param added rachelle 061808
      p_reinstated    IN   VARCHAR2
   )                                               --param added abie 08262011
   AS
      TYPE v_assd_tin_tab IS TABLE OF giis_assured.assd_tin%TYPE;

      TYPE v_no_tin_reason_tab IS TABLE OF giis_assured.no_tin_reason%TYPE;

      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

--    TYPE v_prem_amt_tab         IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;

      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_cancel_date_tab IS TABLE OF gipi_polbasic.cancel_date%TYPE;

      TYPE v_cancel_data_tab IS TABLE OF gipi_uwreports_ext.cancel_data%TYPE;

      v_assd_tin             v_assd_tin_tab;
      v_no_tin_reason        v_no_tin_reason_tab;
      v_assd_no              v_assd_no_tab;
      v_policy_id            v_policy_id_tab;
      v_issue_date           v_issue_date_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_iss_cd               v_iss_cd_tab;
      v_issue_yy             v_issue_yy_tab;
      v_pol_seq_no           v_pol_seq_no_tab;
      v_renew_no             v_renew_no_tab;
      v_endt_iss_cd          v_endt_iss_cd_tab;
      v_endt_yy              v_endt_yy_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_incept_date          v_incept_date_tab;
      v_expiry_date          v_expiry_date_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_dist_flag            v_dist_flag_tab;
      v_spld_date            v_spld_date_tab;
      v_pol_flag             v_pol_flag_tab;
      v_cred_branch          v_cred_branch_tab;
      v_cancel_date          v_cancel_date_tab;
      v_cancel_data          v_cancel_data_tab;
   BEGIN
/*comment out giuw_pol_dist and get the premium_amt from gipi_invoice by april dated 07042011*/
      SELECT   /*+INDEX (GP POLBASIC_U1) */
               a.assd_no, gs.assd_tin, gs.no_tin_reason,
               gp.policy_id gp_policy_id, gp.issue_date gp_issue_date,
               gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
               gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
               gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
               gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
               gp.endt_seq_no gp_endt_seq_no, gp.incept_date gp_incept_date,
               gp.expiry_date gp_expiry_date,
                                                 --gp.tsi_amt gp_tsi_amt,
                                                 --gp.prem_amt gp_prem_amt,
                                             -- SUM(gpd.tsi_amt) gp_tsi_amt, --glyza
                                                -- SUM(gpd.prem_amt) gp_prem_amt, --glyza
                                             gp.tsi_amt gp_tsi_amt,    --april
               SUM ((gi.prem_amt * gi.currency_rt)) gp_prem_amt,       --april
               NVL (gi.acct_ent_date, gp.acct_ent_date),
                                              --i -- aaron 010609 --vcm 100709
               -- gpd.acct_ent_date, -- aaron 0101609
                     --gp.acct_ent_date gp_acct_ent_date,
               gp.spld_acct_ent_date gp_spld_acct_ent_date,
               gp.dist_flag dist_flag, gp.spld_date gp_spld_date,
               gp.pol_flag gp_pol_flag, gp.cred_branch gp_cred_branch,
               gp.cancel_date,
               DECODE (gp.pol_flag,
                       '4', p_uwreports.check_date_dist_peril (gp.line_cd,
                                                               gp.subline_cd,
                                                               gp.iss_cd,
                                                               gp.issue_yy,
                                                               gp.pol_seq_no,
                                                               gp.renew_no,
                                                               p_param_date,
                                                               p_from_date,
                                                               p_to_date
                                                              ),
                       1
                      )
      BULK COLLECT INTO v_assd_no, v_assd_tin, v_no_tin_reason,
               v_policy_id, v_issue_date,
               v_line_cd, v_subline_cd,
               v_iss_cd, v_issue_yy,
               v_pol_seq_no, v_renew_no,
               v_endt_iss_cd, v_endt_yy,
               v_endt_seq_no, v_incept_date,
               v_expiry_date, v_tsi_amt,
               v_prem_amt,
               v_acct_ent_date,
               v_spld_acct_ent_date,
               v_dist_flag, v_spld_date,
               v_pol_flag, v_cred_branch,
               v_cancel_date,
               v_cancel_data
          FROM gipi_parlist a,
               gipi_polbasic gp,
               gipi_invoice gi,                                            --i
               --GIUW_POL_DIST gpd,
               giis_assured gs
         WHERE a.par_id = gp.par_id
           AND p_uwreports.check_date_policy
                      (p_scope,
                       p_param_date,
                       p_from_date,
                       p_to_date,
                       gp.issue_date,
                       gp.eff_date,
                       --gpd.acct_ent_date, --aaron 010609
                       NVL (gi.acct_ent_date, gp.acct_ent_date),
                                                           --glyza --vcm100709
                       --gp.spld_acct_ent_date,
                       NVL (gi.spoiled_acct_ent_date, gp.spld_acct_ent_date),
                                                                       --aaron
                       --gp.booking_mth,
                       --gp.booking_year,
                       gi.multi_booking_mm,                            --glyza
                       gi.multi_booking_yy,                            --glyza
                       gp.cancel_date,
                                      --issa01.23.2008 to consider cancel_date
                       gp.endt_seq_no
                      ) = 1      -- to consider if policies only or endts only
           AND gi.policy_id = gp.policy_id                                 --i
           --AND NVL (gp.endt_type, 'A') = 'A'
           AND NVL (gp.endt_type, 'A') =
                  DECODE
                     (p_nonaff_endt,
                      'N', 'A',
                      NVL (gp.endt_type, 'A')
                     )
                   --rachelle 061808 extract affecting and non-affecting endts
           AND gp.reg_policy_sw =
                               DECODE (p_special_pol,
                                       'Y', reg_policy_sw,
                                       'Y'
                                      )
           AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
           AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
           AND DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                  NVL (p_iss_cd,
                       DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd)
                      )
              --AND gp.policy_id     = gpd.policy_id comment out by april 07042011
              --AND NVL(gi.takeup_seq_no,1) = NVL(gpd.takeup_seq_no,1) --gly comment out by april 07042011
              --AND NVL(gi.item_grp,1)      = NVL(gpd.item_grp,1) --gly comment out by april 07042011
           --AND gpd.dist_flag <> DECODE(gp.pol_flag,'5',5,4)--vj 120109 comment out by april 07042011
           -- AND gpd.dist_flag <> 5 comment out by april 07042011
           AND gs.assd_no = a.assd_no                 -- added by aaron 012609
           --AND NVL(GP.REINSTATE_TAG,'N') = NVL(p_reinstated, 'N') -- abie 08262011
           AND NVL (gp.reinstate_tag, 'N') =
                  DECODE (p_reinstated,
                          NULL, NVL (gp.reinstate_tag, 'N'),
                          p_reinstated
                         )                                 --mikel 02.05.2013;
      GROUP BY a.assd_no,
               gs.assd_tin,
               gs.no_tin_reason,
               gp.policy_id,
               gp.issue_date,
               gp.line_cd,
               gp.subline_cd,
               gp.iss_cd,
               gp.issue_yy,
               gp.pol_seq_no,
               gp.renew_no,
               gp.endt_iss_cd,
               gp.endt_yy,
               gp.endt_seq_no,
               gp.incept_date,
               gp.expiry_date,
               -- gpd.acct_ent_date, -- aaron 010609
               NVL (gi.acct_ent_date, gp.acct_ent_date),       --i --vcm100709
               gp.spld_acct_ent_date,
               gp.dist_flag,
               gp.spld_date,
               gp.pol_flag,
               gp.cred_branch,
               gp.cancel_date,
               DECODE (gp.pol_flag,
                       '4', p_uwreports.check_date_dist_peril (gp.line_cd,
                                                               gp.subline_cd,
                                                               gp.iss_cd,
                                                               gp.issue_yy,
                                                               gp.pol_seq_no,
                                                               gp.renew_no,
                                                               p_param_date,
                                                               p_from_date,
                                                               p_to_date
                                                              ),
                       1
                      ),
               gp.tsi_amt;                          --,added by april 07042011

      --gp.tsi_amt, gp.prem_amt;
      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_ext
                        (assd_no, policy_id,
                         issue_date, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date, expiry_date,
                         total_tsi, total_prem, from_date,
                         TO_DATE, SCOPE, user_id, acct_ent_date,
                         spld_acct_ent_date, dist_flag,
                         spld_date, pol_flag, param_date,
                         evatprem, fst, lgt, doc_stamps, other_taxes,
                         other_charges, cred_branch, cred_branch_param,
                         special_pol_param, cancel_date,
                         cancel_data, tin,
                         no_tin_reason
                        )
                 VALUES (v_assd_no (cnt), v_policy_id (cnt),
                         v_issue_date (cnt), v_line_cd (cnt),
                         v_subline_cd (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         v_incept_date (cnt), v_expiry_date (cnt),
                         v_tsi_amt (cnt), v_prem_amt (cnt), p_from_date,
                         p_to_date, p_scope, USER, v_acct_ent_date (cnt),
                         v_spld_acct_ent_date (cnt), v_dist_flag (cnt),
                         v_spld_date (cnt), v_pol_flag (cnt), p_param_date,
                         0, 0, 0, 0, 0,
                         0, v_cred_branch (cnt), p_parameter,
                         p_special_pol, v_cancel_date (cnt),
                         v_cancel_data (cnt), v_assd_tin (cnt),
                         v_no_tin_reason (cnt)
                        );
         COMMIT;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'MAIN');
   END;                                          --procedure pol_gixx_pol_prod

   PROCEDURE pop_uwreports_dist_ext (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_param        IN   NUMBER
   )
   AS
/* Modified by:     Jhing
** Modified on:     01.19.2013 - 02.19.2013
** Modifications :  commented out old cursor in retrieving distribution data ; instead of using subqueries in a main query to
**                  retrieve information amounts, separate FOR Loops were created to get distribution share for net retention
**                  , facultative and treaty to be able to easily capture and manage conditions when accounting entry date is used
**                  as date parameter. In the former version, accounting entry date is not used as filtering condition in retrieving
**                  distribution amounts.
**
**
*/
--type array is table of varchar2(3000) index by binary_integer;
      TYPE policy_id_tab IS TABLE OF gipi_uwreports_dist_ext.policy_id%TYPE;

      TYPE branch_cd_tab IS TABLE OF gipi_uwreports_dist_ext.branch_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF gipi_uwreports_dist_ext.line_cd%TYPE;

      TYPE prem_amt_tab IS TABLE OF gipi_uwreports_dist_ext.prem_amt%TYPE;

      TYPE vat_amt_tab IS TABLE OF gipi_uwreports_ext.evatprem%TYPE;

      TYPE lgt_amt_tab IS TABLE OF gipi_uwreports_ext.lgt%TYPE;

      TYPE dst_amt_tab IS TABLE OF gipi_uwreports_ext.doc_stamps%TYPE;

      TYPE fst_amt_tab IS TABLE OF gipi_uwreports_ext.fst%TYPE;

--TYPE pt_amt_tab            IS TABLE OF GIPI_UWREPORTS_DIST_EXT.PT_AMT%TYPE;
      TYPE oth_tax_amt_tab IS TABLE OF gipi_uwreports_ext.other_charges%TYPE;

      TYPE retention_tab IS TABLE OF gipi_uwreports_dist_ext.RETENTION%TYPE;

      TYPE facultative_tab IS TABLE OF gipi_uwreports_dist_ext.facultative%TYPE;

      TYPE ri_comm_tab IS TABLE OF gipi_uwreports_dist_ext.ri_comm%TYPE;

      TYPE ri_comm_vat_tab IS TABLE OF gipi_uwreports_dist_ext.ri_comm_vat%TYPE;

      TYPE treaty_tab IS TABLE OF gipi_uwreports_dist_ext.treaty%TYPE;

      TYPE trty_ri_comm_tab IS TABLE OF gipi_uwreports_dist_ext.trty_ri_comm%TYPE;

      TYPE trty_ri_comm_vat_tab IS TABLE OF gipi_uwreports_dist_ext.trty_ri_comm_vat%TYPE;

      TYPE from_date_tab IS TABLE OF DATE;

      TYPE to_date_tab IS TABLE OF DATE;

      TYPE user_tab IS TABLE OF gipi_uwreports_dist_ext.user_id%TYPE;

      TYPE last_update_tab IS TABLE OF gipi_uwreports_dist_ext.last_update%TYPE;

      v_policy_id          policy_id_tab;
      v_branch_cd          branch_cd_tab;
      v_line_cd            line_cd_tab;
      v_prem_amt           prem_amt_tab;
      v_vat_amt            vat_amt_tab;
      v_lgt_amt            lgt_amt_tab;
      v_dst_amt            dst_amt_tab;
      v_fst_amt            fst_amt_tab;
--v_pt_amt                 pt_amt_tab;
      v_oth_tax_amt        oth_tax_amt_tab;
      v_retention          retention_tab;
      v_facultative        facultative_tab;
      v_ri_comm            ri_comm_tab;
      v_ri_comm_vat        ri_comm_vat_tab;
      v_treaty             treaty_tab;
      v_trty_ri_comm       trty_ri_comm_tab;
      v_trty_ri_comm_vat   trty_ri_comm_vat_tab;
      v_from_date          from_date_tab;
      v_to_date            to_date_tab;
      v_user_id            user_tab;
      v_last_update        last_update_tab;
/*
v_vat_cd    NUMBER(2)   := GIISP.N('VAT');
v_lgt_cd    NUMBER(2)   := GIISP.N('LGT');
v_dst_cd    NUMBER(2)  := GIISP.N('DST');
v_fst_cd    NUMBER(2)   := GIISP.N('FST');
v_pt_cd    NUMBER(2)    := GIISP.N('PT');
*/
      v_ret_cd             NUMBER               := giisp.n ('NET_RETENTION');
      v_fac_cd             NUMBER               := giisp.n ('FACULTATIVE');

--  jhing 02.06.2013 commented out complete block. Query to populate fields should be modified.
--CURSOR dist_rec IS
--        SELECT  extA.policy_id, extA.branch, extA.line_cd
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extA.total_prem,0),0)) prem_amt
--                    /*, extB.prem_amt       remove tax_charges refer to GIPI_UWREPORTS_EXT
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.vat), 0)) VAT
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.lgt), 0)) LGT
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.dst), 0)) DST
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.fst), 0)) FST
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.pt), 0)) PT
--                    , SUM(NVL(DECODE(extA.spld_date,NULL, extC.other), 0)) OTHER        */
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.net_ret_prem,0),0)) net_ret_prem
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.ri_prem_amt,0),0)) ri_prem_amt
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.ri_comm_amt,0),0)) ri_comm_amt
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.ri_comm_vat,0),0)) ri_comm_vat
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.treaty_prem,0),0)) treaty_prem
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.trty_ri_comm,0),0)) trty_ri_comm
--                    , SUM(DECODE(DECODE(P_SCOPE,4,NULL,extA.spld_date),NULL,NVL(extB.trty_ri_comm_vat,0),0)) trty_ri_comm_vat
--                    , p_from_date, p_to_date, p_user, sysdate
--                FROM (SELECT DISTINCT ext.policy_id
--                                , DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) branch
--                                , ext.line_cd, ext.spld_date, ext.total_prem
--                                , ext.pol_flag --adpascual 08.17.2012
--                            FROM gipi_uwreports_ext  ext
--                        WHERE 1=1
--                            AND ext.from_date = p_from_date
--                            AND ext.to_date = p_to_date
--                            AND ext.user_id = user
--                            AND DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) =  NVL(p_iss_cd, DECODE(p_param, 1, ext.cred_branch, ext.iss_cd))
--                            AND ext.line_cd = NVL(p_line_cd, ext.line_cd)
--                            AND ext.subline_cd = NVL(p_subline_cd, ext.subline_cd)
--                            ) extA
--                    -- DISTRIBUTION
--                    , (SELECT distA.policy_id policy_id2, inv.iss_cd, distC.line_cd
--                            , SUM(NVL(distC.retention, 0) * inv.currency_rt) net_ret_prem
--                            , SUM(NVL(distC.treaty_prem, 0) * inv.currency_rt) treaty_prem
--                            , SUM(NVL(distC.treaty_prem, 0)*distC.trty_comm_rt/100) trty_ri_comm
--                            , SUM(NVL(distC.treaty_prem, 0)*distC.trty_vat_rt/100) trty_ri_comm_vat
--                            , NVL(distB.ri_prem_amt, 0) * inv.currency_rt ri_prem_amt
--                            , NVL(distB.ri_comm_amt, 0) * inv.currency_rt ri_comm_amt
--                            , NVL(distB.ri_comm_vat, 0) * inv.currency_rt ri_comm_vat
--                            --, NVL(inv.prem_amt, 0) * inv.currency_rt prem_amt
--                            , distA.dist_flag --adpascual 08.17.2012
--                        FROM giuw_pol_dist distA
--                            , gipi_invoice inv
--                            -- FACULTATIVE
--                            , (SELECT x.dist_no, SUM(NVL(z.ri_prem_amt, 0)) ri_prem_amt, SUM(NVL(z.ri_comm_amt, 0)) ri_comm_amt, SUM(NVL(z.ri_comm_vat, 0)) ri_comm_vat
--                                    FROM giri_distfrps x, giri_frps_ri y, giri_binder z
--                                  WHERE x.line_cd = y.line_cd
--                                      AND x.frps_yy = y.frps_yy
--                                      AND x.frps_seq_no = y.frps_seq_no
--                                      AND y.line_cd = z.line_cd
--                                      AND y.fnl_binder_id = z.fnl_binder_id
--                                      -- CONSIDER REVERSED BINDERS
--                                      /*  AND (z.reverse_date > p_to_date OR z.reverse_date is NULL)
--                                      AND (z.binder_date <= p_to_date)    */
--                                      -- CONSIDER ACCT_ENT_DATE when p_param_date = 4
--                                         AND z.reverse_date IS NULL
--                                         AND NVL(y.reverse_sw, 'N') = 'N'
----                                      AND NVL(z.acc_ent_date, sysdate) between DECODE(p_param_date, 4, p_from_date, NVL(z.acc_ent_date, sysdate)) AND DECODE(p_param_date, 4, p_to_date, NVL(z.acc_ent_date, sysdate))
----                                      AND (p_param_date = 4 AND z.acc_rev_date > p_to_date OR (z.acc_rev_date IS NULL AND z.reverse_date IS NULL))
--                                      -- WHEN P_PARAM_DATE <> 4 THEN GET LATEST APPLIED BINDER
--                                      --------------------AND (p_param_date <> 4 AND z.reverse_date IS NULL)
--                                   GROUP BY x.dist_no) distB
--                            -- TREATY and RETENTION
--                            , (SELECT a.dist_no, a.share_cd, a.line_cd
--                                        , DECODE(a.share_cd, v_fac_cd, 0, v_ret_cd, 0, a.dist_prem) treaty_prem
--                                        , DECODE(a.share_cd, v_ret_cd, a.dist_prem, 0) retention
--                                        , b.trty_comm_rt, b.trty_vat_rt
--                                    FROM giuw_policyds_dtl a
--                                        ,(SELECT j.line_cd, j.trty_yy, j.share_cd, AVG(NVL(ri_comm_rt, 0)) trty_comm_rt, AVG(NVL(input_vat_rate, 0)) trty_vat_rt
--                                                FROM giis_dist_share j, giis_trty_panel k, giis_reinsurer m
--                                             WHERE j.line_cd = k.line_cd
--                                                AND j.trty_yy = k.trty_yy
--                                                AND j.share_cd = k.trty_seq_no
--                                                AND k.ri_cd = m.ri_cd
--                                                AND NVL(trty_sw, 'N') = 'Y'
--                                               GROUP BY j.share_cd, j.line_cd, j.trty_yy) b
--                                    WHERE 1=1
--                                        AND a.share_cd = b.share_cd(+)
--                                        AND a.line_cd = b.line_cd(+)) distC
--                        WHERE  1=1
--                            AND distA.policy_id = inv.policy_id
--                            -- CONSIDER LATEST POSTED DISTRIBUTION WHEN P_PARAM_DATE NOT 4
--                            ---------------------------------AND (p_param_date <> 4 AND distA.dist_flag = 3)
--                            -- CONDITION WHEN P_PARAM_DATE = 4
----                            AND distA.acct_ent_date between DECODE(p_param_date, 4, p_from_date, distA.acct_ent_date) AND DECODE(p_param_date, 4, p_to_date, distA.acct_ent_date)
----                            AND (p_param_date = 4 AND distA.acct_neg_date > p_to_date OR distA.acct_neg_date IS NULL)
--                            --AND (distA.acct_neg_date between DECODE(p_param_date, 4, p_from_date, distA.acct_neg_date) AND DECODE(p_param_date, 4, p_to_date, distA.acct_neg_date) OR distA.acct_neg_date IS NULL)
--                            AND distA.dist_no = distB.dist_no(+)
--                            AND distA.dist_no = distC.dist_no(+)
--                            --DISTA.DIST_FLAG ='3' adpascual 08.16.2012
--                        GROUP BY distA.policy_id, distA.prem_amt, distB.ri_prem_amt, distB.ri_comm_amt, distB.ri_comm_vat, inv.currency_rt, inv.iss_cd, distC.line_cd
--                                 , distA.dist_flag --adpascual 08172012
--                        ) extB
--                        /*, (SELECT Y.POLICY_ID, SUM(DECODE(TAX_CD, V_DST_CD, X.TAX_AMT * Y.CURRENCY_RT, 0)) DST
--                                , SUM(DECODE(TAX_CD, V_VAT_CD, X.TAX_AMT * Y.CURRENCY_RT, 0)) VAT
--                                , SUM(DECODE(TAX_CD, V_LGT_CD, X.TAX_AMT * Y.CURRENCY_RT, 0)) LGT
--                                , SUM(DECODE(TAX_CD, V_FST_CD, X.TAX_AMT * Y.CURRENCY_RT, 0)) FST
--                                , SUM(DECODE(TAX_CD, V_PT_CD, X.TAX_AMT * Y.CURRENCY_RT, 0)) PT
--                                , SUM(DECODE(TAX_CD, V_VAT_CD, 0
--                                                                    , V_DST_CD, 0
--                                                                    , V_LGT_CD, 0
--                                                                    , V_FST_CD, 0
--                                                                    , V_PT_CD, 0
--                                                                    , X.TAX_AMT * Y.CURRENCY_RT)) OTHER
--                            FROM GIPI_INV_TAX X, GIPI_INVOICE Y
--                            WHERE X.PREM_SEQ_NO = Y.PREM_SEQ_NO
--                                AND X.ISS_CD = Y.ISS_CD
--                            GROUP BY Y.POLICY_ID) extC      */
--                WHERE extA.policy_id = extB.policy_id2
--                    --AND extA.policy_id = extC.policy_id
--                    --AND extB.policy_id2 = extC.policy_id
--                    AND extB.dist_flag <> DECODE(extA.pol_flag, '5', 5, 4) --adpascual 08.17.2012
--                GROUP BY extA.policy_id, extA.branch, extA.line_cd, extA.spld_date--, p_from_date, p_to_date, p_user, sysdate
--                ORDER BY extA.branch, extA.line_cd;

      -- jhing 02.06.2013 modified cursor ; distribution data will be in separate queries inside loop
      CURSOR dist_rec
      IS
         SELECT ext.policy_id,
                DECODE (p_param, 1, ext.cred_branch, ext.iss_cd) branch,
                ext.line_cd, ext.total_prem, 0 net_retention, 0 ri_prem_amt,
                0 ri_comm_amt, 0 ri_comm_vat, 0 treaty_prem,
                0 treaty_ri_comm, 0 treaty_ri_comm_vat, p_from_date,
                p_to_date, p_user, SYSDATE
           FROM gipi_uwreports_ext ext
          WHERE 1 = 1
            AND ext.user_id = USER
            AND DECODE (p_param, 1, ext.cred_branch, ext.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_param, 1, ext.cred_branch, ext.iss_cd)
                       )
            AND ext.line_cd = NVL (p_line_cd, ext.line_cd)
            AND ext.subline_cd = NVL (p_subline_cd, ext.subline_cd);
   BEGIN
      DELETE FROM gipi_uwreports_dist_ext
            WHERE user_id = p_user;

--    OPEN dist_rec;
--    LOOP
--    FETCH dist_rec BULK COLLECT
--        INTO v_policy_id, v_branch_cd, v_line_cd, v_prem_amt
--            --, v_vat_amt, v_lgt_amt, v_dst_amt, v_fst_amt, v_pt_amt, v_oth_tax_amt
--            , v_retention
--            , v_facultative, v_ri_comm, v_ri_comm_vat
--            , v_treaty, v_trty_ri_comm, v_trty_ri_comm_vat
--            , v_from_date, v_to_date, v_user_id, v_last_update LIMIT 10000 ;

      --    jhing 02.06.2013 revised query to store data into collection
      SELECT ext.policy_id,
             DECODE (p_param, 1, ext.cred_branch, ext.iss_cd) branch,
             ext.line_cd, ext.total_prem, 0 net_retention, 0 ri_prem_amt,
             0 ri_comm_amt, 0 ri_comm_vat, 0 treaty_prem, 0 treaty_ri_comm,
             0 treaty_ri_comm_vat, p_from_date, p_to_date, p_user,
             SYSDATE
      BULK COLLECT INTO v_policy_id,
             v_branch_cd,
             v_line_cd, v_prem_amt, v_retention, v_facultative,
             v_ri_comm, v_ri_comm_vat, v_treaty, v_trty_ri_comm,
             v_trty_ri_comm_vat, v_from_date, v_to_date, v_user_id,
             v_last_update
        FROM gipi_uwreports_ext ext
       WHERE 1 = 1
         AND ext.user_id = USER
         AND DECODE (p_param, 1, ext.cred_branch, ext.iss_cd) =
                NVL (p_iss_cd,
                     DECODE (p_param, 1, ext.cred_branch, ext.iss_cd)
                    )
         AND ext.line_cd = NVL (p_line_cd, ext.line_cd)
         AND ext.subline_cd = NVL (p_subline_cd, ext.subline_cd)
         AND (DECODE (p_param_date, 4, 1, 0) = 1 OR ext.dist_flag = '3');

      IF SQL%FOUND
      THEN
         FOR i IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            --  jhing 02.06.2013 added separate queries for distribution amounts
            v_retention (i) := 0;

            --  query the net retention share
            FOR cur_p IN
               (SELECT NVL
                          (  a.dist_prem
                           * NVL (c.currency_rt, 1)
                           * DECODE
                                (p_param_date,
                                 4, (CASE
                                      WHEN (    TRUNC (b.acct_ent_date)
                                                   BETWEEN p_from_date
                                                       AND p_to_date
                                            AND TRUNC (b.acct_neg_date)
                                                   BETWEEN p_from_date
                                                       AND p_to_date
                                           )
                                         THEN 0
                                      WHEN TRUNC (b.acct_ent_date)
                                             BETWEEN p_from_date
                                                 AND p_to_date
                                         THEN 1
                                      ELSE -1
                                   END
                                  ),
                                 1
                                ),
                           0
                          ) dist_prem
                  FROM giuw_itemds_dtl a,
                       giuw_pol_dist b,
                       gipi_item c,
                       gipi_polbasic d,
                       gipi_invoice e
                 WHERE a.dist_no = b.dist_no
                   AND b.policy_id = c.policy_id
                   AND b.policy_id = d.policy_id
                   AND d.policy_id = e.policy_id
                   AND NVL (b.item_grp, 1) = NVL (e.item_grp, 1)
                   AND NVL (b.takeup_seq_no, 1) = NVL (e.takeup_seq_no, 1)
                   AND (   DECODE (p_param_date, 1, 0, 1) = 1
                        OR TRUNC (d.issue_date) BETWEEN p_from_date AND p_to_date
                       )
                   AND (   DECODE (p_param_date, 2, 0, 1) = 1
                        OR TRUNC (d.eff_date) BETWEEN p_from_date AND p_to_date
                       )
                   AND (   DECODE (p_param_date, 3, 0, 1) = 1
                        OR LAST_DAY (TO_DATE (   e.multi_booking_mm
                                              || ','
                                              || TO_CHAR (e.multi_booking_yy),
                                              'FMMONTH,YYYY'
                                             )
                                    ) BETWEEN LAST_DAY (p_from_date)
                                          AND LAST_DAY (p_to_date)
                       )
                   AND a.item_no = c.item_no
                   AND a.share_cd = v_ret_cd
                   AND b.policy_id = v_policy_id (i)
                   AND (DECODE (p_param_date, 4, 1, 0) = 1
                        OR b.dist_flag = '3'
                       )
                   AND (   DECODE (p_param_date, 4, 0, 1) = 1
                        OR TRUNC (b.acct_ent_date) BETWEEN p_from_date
                                                       AND p_to_date
                       ))
            LOOP
               v_retention (i) := v_retention (i) + cur_p.dist_prem;
            END LOOP;

            --  query the facultative share ...
            FOR curx IN
               (SELECT   pp.policy_id, SUM (pp.ri_prem_amt) ri_prem_amt,
                         SUM (pp.ri_comm_amt) ri_comm_amt,
                         SUM (pp.ri_comm_vat) ri_comm_vat
                    FROM (SELECT w.policy_id, x.dist_no, z.ri_prem_amt,
                                 z.ri_comm_amt, z.ri_comm_vat
                            FROM giri_distfrps x,
                                 giri_frps_ri y,
                                 giri_binder z,
                                 giuw_pol_dist w,
                                 gipi_polbasic m,
                                 gipi_invoice n
                           WHERE x.line_cd = y.line_cd
                             AND x.frps_yy = y.frps_yy
                             AND x.frps_seq_no = y.frps_seq_no
                             AND y.line_cd = z.line_cd
                             AND y.fnl_binder_id = z.fnl_binder_id
                             AND x.dist_no = w.dist_no
                             AND w.policy_id = m.policy_id
                             AND m.policy_id = n.policy_id
                             AND NVL (w.item_grp, 1) = NVL (n.item_grp, 1)
                             AND NVL (w.takeup_seq_no, 1) =
                                                      NVL (n.takeup_seq_no, 1)
                             AND (   m.pol_flag != '5'
                                  OR DECODE (p_param_date, 4, 1, 0) = 1
                                 )
                             AND (   DECODE (p_param_date, 1, 0, 1) = 1
                                  OR TRUNC (m.issue_date) BETWEEN p_from_date
                                                              AND p_to_date
                                 )
                             AND (   DECODE (p_param_date, 2, 0, 1) = 1
                                  OR TRUNC (m.eff_date) BETWEEN p_from_date
                                                            AND p_to_date
                                 )
                             AND (   DECODE (p_param_date, 3, 0, 1) = 1
                                  OR LAST_DAY
                                        (TO_DATE (   n.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (n.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from_date)
                                              AND LAST_DAY (p_to_date)
                                 )
                             AND (   DECODE (p_param_date, 4, 1, 0) = 1
                                  OR (    w.dist_flag = '3'
                                      AND w.negate_date IS NULL
                                      AND z.reverse_date IS NULL
                                     )
                                 )                         -- jhing 01.19.2013
                             AND (   DECODE (p_param_date, 4, 0, 1) = 1
                                  OR (   (    TRUNC (w.acct_ent_date)
                                                 BETWEEN p_from_date
                                                     AND p_to_date
                                          AND TRUNC (z.acc_ent_date)
                                                 BETWEEN p_from_date
                                                     AND p_to_date
                                         )
                                      OR (    TRUNC (w.acct_ent_date) <=
                                                                   p_from_date
                                          AND TRUNC (z.acc_ent_date)
                                                 BETWEEN p_from_date
                                                     AND p_to_date
                                         )
                                     /*OR (    TRUNC (z.acc_ent_date) <= p_from_date
                                         AND TRUNC (w.acct_ent_date) BETWEEN p_from_date
                                                                         AND p_to_date
                                        )*/ --comment out by mikel 03.01.2013
                                     )
                                 )
                          UNION ALL
/* for binder reversal or distribution negation effective only for acct ent date parameter */
                          SELECT w.policy_id, x.dist_no,
                                 (  z.ri_prem_amt
                                  * DECODE (p_scope,
                                            4, DECODE (m.pol_flag, '5', 1, -1),
                                            -1
                                           )
                                 ) ri_prem_amt,
                                 (  z.ri_comm_amt
                                  * DECODE (p_scope,
                                            4, DECODE (m.pol_flag, '5', 1, -1),
                                            -1
                                           )
                                 ) ri_comm_amt,
                                 (  z.ri_comm_vat
                                  * DECODE (p_scope,
                                            4, DECODE (m.pol_flag, '5', 1, -1),
                                            -1
                                           )
                                 ) ri_comm_vat
                            FROM giri_distfrps x,
                                 giri_frps_ri y,
                                 giri_binder z,
                                 giuw_pol_dist w,
                                 gipi_polbasic m,
                                 gipi_invoice n
                           WHERE x.line_cd = y.line_cd
                             AND x.frps_yy = y.frps_yy
                             AND x.frps_seq_no = y.frps_seq_no
                             AND y.line_cd = z.line_cd
                             AND y.fnl_binder_id = z.fnl_binder_id
                             AND x.dist_no = w.dist_no
                             AND w.policy_id = m.policy_id
                             AND m.policy_id = n.policy_id
                             AND NVL (w.item_grp, 1) = NVL (n.item_grp, 1)
                             AND DECODE (p_param_date, 4, 1, 0) =
                                                          1
                                                           -- jhing 01.19.2013
                             AND (   (    TRUNC (w.acct_neg_date)
                                             BETWEEN p_from_date
                                                 AND p_to_date
                                      AND TRUNC (z.acc_rev_date)
                                             BETWEEN p_from_date
                                                 AND p_to_date
                                     )
                                  OR (    w.acct_neg_date IS NULL
                                      AND TRUNC (w.acct_ent_date) <=
                                                                   p_from_date
                                      AND TRUNC (z.acc_rev_date)
                                             BETWEEN p_from_date
                                                 AND p_to_date
                                     )
                                 /*OR (    TRUNC (z.acc_ent_date) <= p_from_date
                                     AND TRUNC (w.acct_neg_date) BETWEEN p_from_date
                                                                     AND p_to_date
                                    )*/ --comment out by mikel 03.01.2013
                                 )) pp
                   WHERE pp.policy_id = v_policy_id (i)
                GROUP BY pp.policy_id)
            LOOP
               v_facultative (i) := curx.ri_prem_amt;
               v_ri_comm (i) := curx.ri_comm_amt;
               v_ri_comm_vat (i) := curx.ri_comm_vat;
            END LOOP;

            -- jhing 02.06.2013 query the treaty distribution share
            -- if parameter is acct_entry_date, data should be retrieved on giac_treaty_cession table, otherwise , use the maintenance to compute comm_amt , comm_vat
            IF p_param_date = 4
            THEN
               FOR cury IN
                  (SELECT   policy_id,
                                      /*SUM (premium_amt * DECODE (take_up_type, 'N', -1, 1)) premium_amt,
                                      SUM (commission_amt * DECODE (take_up_type, 'N', -1, 1)
                                          ) commission_amt,
                                      SUM (comm_vat * DECODE (take_up_type, 'N', -1, 1)) comm_vat*/ --comment out by mikel 03.01.2013
                                      SUM (premium_amt) premium_amt,
                            SUM (commission_amt) commission_amt,
                            SUM (comm_vat) comm_vat
                       FROM giac_treaty_cessions gtc
                      WHERE TRUNC (acct_ent_date) BETWEEN p_from_date
                                                      AND p_to_date
                        AND policy_id = v_policy_id (i)
                   GROUP BY policy_id)
               LOOP
                  v_treaty (i) := cury.premium_amt;
                  v_trty_ri_comm (i) := cury.commission_amt;
                  v_trty_ri_comm_vat (i) := cury.comm_vat;
               END LOOP;
            ELSE
               -- if parameter is not acctng entry date, select the latest effective data (distributed)
               FOR curb IN
                  (SELECT   a.policy_id,
                            SUM (  (  (g.trty_shr_pct / 100)
                                    * NVL (e.dist_prem, 0)
                                   )
                                 * NVL (b.currency_rt, 1)
                                ) premium_amt,
                            SUM ((  (  (g.trty_shr_pct / 100)
                                     * NVL (e.dist_prem, 0)
                                    )
                                  * NVL (b.currency_rt, 1)
                                  * (NVL (h.trty_com_rt, 0) / 100)
                                 )
                                ) commission_amt,
                            NVL
                               (DECODE
                                   (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                                    'Y', (DECODE
                                             (NVL
                                                 (giacp.v
                                                       ('GEN_COMM_VAT_FOREIGN'),
                                                  'Y'
                                                 ),
                                              'N', (DECODE
                                                       (i.local_foreign_sw,
                                                        'L', (  (SUM
                                                                    (((  (  (  g.trty_shr_pct
                                                                             / 100
                                                                            )
                                                                          * NVL
                                                                               (e.dist_prem,
                                                                                0
                                                                               )
                                                                         )
                                                                       * NVL
                                                                            (b.currency_rt,
                                                                             1
                                                                            )
                                                                       * (  NVL
                                                                               (h.trty_com_rt,
                                                                                0
                                                                               )
                                                                          / 100
                                                                         )
                                                                      )
                                                                     )
                                                                    )
                                                                )
                                                              * (  i.input_vat_rate
                                                                 / 100
                                                                )
                                                         ),
                                                        0
                                                       )
                                               ),
                                              (  (SUM (((  (  (  g.trty_shr_pct
                                                               / 100
                                                              )
                                                            * NVL
                                                                 (e.dist_prem,
                                                                  0
                                                                 )
                                                           )
                                                         * NVL (b.currency_rt,
                                                                1
                                                               )
                                                         * (  NVL
                                                                 (h.trty_com_rt,
                                                                  0
                                                                 )
                                                            / 100
                                                           )
                                                        )
                                                       )
                                                      )
                                                 )
                                               * (i.input_vat_rate / 100)
                                              )
                                             )
                                     ),
                                    0
                                   ),
                                0
                               ) comm_vat
                       FROM gipi_polbasic a,
                            gipi_item b,
                            giuw_pol_dist c,
                            giuw_itemds d,
                            giuw_itemperilds_dtl e,
                            giis_dist_share f,
                            giis_trty_panel g,
                            giis_trty_peril h,
                            giis_reinsurer i,
                            gipi_polbasic j,
                            gipi_invoice k
                      WHERE a.policy_id = b.policy_id
                        AND a.policy_id = c.policy_id
                        AND c.dist_no = d.dist_no
                        AND b.item_no = d.item_no
                        AND d.dist_no = e.dist_no
                        AND d.item_no = e.item_no
                        AND c.policy_id = j.policy_id
                        AND j.policy_id = k.policy_id
                        AND NVL (c.item_grp, 1) = NVL (k.item_grp, 1)
                        AND NVL (c.takeup_seq_no, 1) =
                                                      NVL (k.takeup_seq_no, 1)
                        AND (   DECODE (p_param_date, 1, 0, 1) = 1
                             OR TRUNC (j.issue_date) BETWEEN p_from_date
                                                         AND p_to_date
                            )
                        AND (   DECODE (p_param_date, 2, 0, 1) = 1
                             OR TRUNC (j.eff_date) BETWEEN p_from_date
                                                       AND p_to_date
                            )
                        AND (   DECODE (p_param_date, 3, 0, 1) = 1
                             OR LAST_DAY
                                        (TO_DATE (   k.multi_booking_mm
                                                  || ','
                                                  || TO_CHAR
                                                           (k.multi_booking_yy),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN LAST_DAY (p_from_date)
                                              AND LAST_DAY (p_to_date)
                            )
                        AND e.line_cd = f.line_cd
                        AND e.share_cd = f.share_cd
                        AND f.share_type = 2
                        AND f.line_cd = g.line_cd
                        AND f.share_cd = g.trty_seq_no
                        AND f.trty_yy = g.trty_yy
                        AND e.line_cd = h.line_cd(+)
                        AND e.share_cd = h.trty_seq_no(+)
                        AND e.peril_cd = h.peril_cd(+)
                        AND g.ri_cd = i.ri_cd
                        AND c.dist_flag = '3'
                        AND a.policy_id = v_policy_id (i)
                   GROUP BY a.policy_id, i.local_foreign_sw, i.input_vat_rate)
               LOOP
                  v_treaty (i) := v_treaty (i) + curb.premium_amt;
                  v_trty_ri_comm (i) :=
                                      v_trty_ri_comm (i)
                                      + curb.commission_amt;
                  v_trty_ri_comm_vat (i) :=
                                        v_trty_ri_comm_vat (i)
                                        + curb.comm_vat;
               END LOOP;
            END IF;

            --        end 02.06.2013
            INSERT INTO cpi.gipi_uwreports_dist_ext
                        (policy_id, branch_cd, line_cd,
                         prem_amt
                                 --, VAT_AMT, LGT_AMT, DST_AMT, FST_AMT, PT_AMT, OTHER_TAX_AMT
            ,            RETENTION, facultative,
                         ri_comm, ri_comm_vat, treaty,
                         trty_ri_comm, trty_ri_comm_vat,
                         from_date, TO_DATE, user_id,
                         last_update
                        )
                 VALUES (v_policy_id (i), v_branch_cd (i), v_line_cd (i),
                         v_prem_amt (i)
                                       --, v_vat_amt(i), v_lgt_amt(i), v_dst_amt(i), v_fst_amt(i), v_pt_amt(i), v_oth_tax_amt(i)
            ,            v_retention (i), v_facultative (i),
                         v_ri_comm (i), v_ri_comm_vat (i), v_treaty (i),
                         v_trty_ri_comm (i), v_trty_ri_comm_vat (i),
                         v_from_date (i), v_to_date (i), v_user_id (i),
                         v_last_update (i)
                        );
         END LOOP;
       --  EXIT WHEN dist_rec%NOTFOUND;   -- commented out jhing 02.06.2013
      --   CLOSE dist_rec;  -- commented out jhing 02.06.2013
        -- END LOOP;   -- commented out jhing 02.06.2013
      END IF;
   END;

   PROCEDURE pop_uwreports_dist_ext2 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_param        IN   NUMBER
   )
   /* created by    : Mikel
   ** date         : 11.12.2013
   ** description :
   */
   AS
      v_ri_iss_cd   VARCHAR2 (2) := giacp.v ('RI_ISS_CD');
   BEGIN
      DELETE FROM gipi_uwreports_dist_ext
            WHERE user_id = p_user;

      FOR rec IN (SELECT e.policy_id, f.cred_branch, f.line_cd, e.prem_amt,
                         e.comm_amt, e.retention_prem, e.facultative_prem,
                         e.ri_comm, e.ri_comm_vat, e.treaty_prem,
                         e.trty_comm, e.trty_comm_vat
                    FROM (SELECT c.policy_id, c.prem_amt, c.comm_amt,
                                 c.retention_prem, c.facultative_prem,
                                 c.ri_comm, c.ri_comm_vat, c.treaty_prem,
                                 d.trty_comm, d.trty_comm_vat
                            FROM (SELECT NVL (a.policy_id,
                                              b.policy_id
                                             ) policy_id,
                                         a.prem_amt, a.comm_amt,
                                         a.retention_prem, a.treaty_prem,
                                         a.facultative_prem, b.ri_comm,
                                         b.ri_comm_vat
                                    FROM (SELECT   NVL
                                                      (v.policy_id,
                                                       w.policy_id
                                                      ) policy_id,
                                                   v.prem_amt, v.comm_amt,
                                                   SUM
                                                      (DECODE
                                                             (w.share_type,
                                                              1, NVL
                                                                   (w.net_ret,
                                                                    0
                                                                   ),
                                                              0
                                                             )
                                                      ) retention_prem,
                                                   SUM
                                                      (DECODE (w.share_type,
                                                               2, NVL
                                                                    (w.treaty,
                                                                     0
                                                                    ),
                                                               0
                                                              )
                                                      ) treaty_prem,
                                                   SUM
                                                      (DECODE (w.share_type,
                                                               3, NVL
                                                                     (w.facul,
                                                                      0
                                                                     ),
                                                               0
                                                              )
                                                      ) facultative_prem
                                              FROM (SELECT a.policy_id,
                                                           NVL
                                                              (a.total_prem,
                                                               0
                                                              ) prem_amt,
                                                           DECODE
                                                              (a.iss_cd,
                                                               v_ri_iss_cd, b.ri_comm_amt,
                                                               NVL
                                                                  (a.comm_amt,
                                                                   0
                                                                  )
                                                              ) comm_amt
                                                      FROM gipi_uwreports_ext_cons a,
                                                           gipi_uwreports_inw_ri_ext b
                                                     WHERE 1 = 1
                                                       AND a.policy_id = b.policy_id(+)
                                                       AND a.user_id = b.user_id(+)
                                                       AND a.user_id = p_user) v
                                                   FULL OUTER JOIN
                                                   (SELECT   policy_id,
                                                             share_type,
                                                             SUM
                                                                (NVL
                                                                    (nr_dist_prem,
                                                                     0
                                                                    )
                                                                ) net_ret,
                                                             SUM
                                                                (NVL
                                                                    (tr_dist_prem,
                                                                     0
                                                                    )
                                                                ) treaty,
                                                             SUM
                                                                (NVL
                                                                    (fa_dist_prem,
                                                                     0
                                                                    )
                                                                ) facul
                                                        FROM gipi_uwreports_dist_peril_ext
                                                       WHERE user_id = p_user
                                                    GROUP BY policy_id,
                                                             share_type) w
                                                   ON v.policy_id =
                                                                   w.policy_id
                                          GROUP BY NVL (v.policy_id,
                                                        w.policy_id
                                                       ),
                                                   v.prem_amt,
                                                   v.comm_amt) a
                                         FULL OUTER JOIN
                                         (SELECT   policy_id,
                                                   SUM (ri_comm_amt) ri_comm,
                                                   SUM
                                                      (ri_comm_vat
                                                      ) ri_comm_vat
                                              FROM gipi_uwreports_ri_ext
                                             WHERE user_id = p_user
                                          GROUP BY policy_id) b
                                         ON a.policy_id = b.policy_id
                                         ) c
                                 FULL OUTER JOIN
                                 (SELECT   policy_id,
                                           SUM (commission_amt) trty_comm,
                                           SUM (comm_vat) trty_comm_vat
                                      FROM giac_treaty_cessions
                                     WHERE acct_ent_date = p_to_date
                                  GROUP BY policy_id) d
                                 ON c.policy_id = d.policy_id
                                 ) e,
                         gipi_polbasic f
                   WHERE e.policy_id = f.policy_id
                     AND f.cred_branch LIKE NVL (p_iss_cd, '%')
                     AND f.line_cd LIKE NVL (p_line_cd, '%')
                     AND f.subline_cd LIKE NVL (p_subline_cd, '%'))
      LOOP
         INSERT INTO cpi.gipi_uwreports_dist_ext
                     (policy_id, branch_cd, line_cd,
                      prem_amt, RETENTION,
                      facultative, ri_comm, ri_comm_vat,
                      treaty, trty_ri_comm, trty_ri_comm_vat,
                      from_date, TO_DATE, user_id, last_update, comm
                     )
              VALUES (rec.policy_id, rec.cred_branch, rec.line_cd,
                      rec.prem_amt, rec.retention_prem,
                      rec.facultative_prem, rec.ri_comm, rec.ri_comm_vat,
                      rec.treaty_prem, rec.trty_comm, rec.trty_comm_vat,
                      p_from_date, p_to_date, p_user, SYSDATE, rec.comm_amt
                     );
      END LOOP;
   END;

   PROCEDURE extract_tab1 (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2,
      p_nonaff_endt   IN   VARCHAR2              --param added rachelle 061808
                                   ,
      p_reinstated    IN   VARCHAR2
   )                                              --param added, abie 08262011
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE total_tsi_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE total_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE spld_date_tab IS TABLE OF gipi_polbasic.spld_date%TYPE;

      TYPE pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      vv_policy_id            policy_id_tab;
      vv_total_tsi            total_tsi_tab;
      vv_total_prem           total_prem_tab;
      vv_acct_ent_date        acct_ent_date_tab;
      vv_spld_acct_ent_date   spld_acct_ent_date_tab;
      vv_spld_date            spld_date_tab;
      vv_pol_flag             pol_flag_tab;
      v_multiplier            NUMBER                 := 1;
      v_count                 NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START');

      DELETE FROM gipi_uwreports_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 1 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (1, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, NULL, NULL, USER, SYSDATE,
                   NULL
                  );

      COMMIT;
      p_uwreports.pol_gixx_pol_prod (p_scope,
                                     p_param_date,
                                     p_from_date,
                                     p_to_date,
                                     p_iss_cd,
                                     p_line_cd,
                                     p_subline_cd,
                                     p_user,
                                     p_parameter,
                                     p_special_pol,
                                     p_nonaff_endt               --param added
                                                  ,
                                     p_reinstated
                                    );            --param added, abie 08262011

      SELECT COUNT (policy_id)
        INTO v_count
        FROM gipi_uwreports_ext
       WHERE user_id = USER;

      IF v_count > 0
      THEN
         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS'));

         FOR x IN
            (SELECT a.policy_id, b.item_grp, b.takeup_seq_no
               FROM gipi_uwreports_ext a, gipi_invoice b, gipi_polbasic c
              WHERE a.policy_id = b.policy_id
                AND c.policy_id = a.policy_id
                AND (c.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1)
                AND (   TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                     OR DECODE (p_param_date, 1, 0, 1) = 1
                    )
                AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                     OR DECODE (p_param_date, 2, 0, 1) = 1
                    )
                AND (   LAST_DAY
                           (TO_DATE
                               (
                                   --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                                   --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
                                   NVL (b.multi_booking_mm, c.booking_mth)
                                || ','
                                || TO_CHAR (NVL (b.multi_booking_yy,
                                                 c.booking_year
                                                )
                                           ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                                'FMMONTH,YYYY'
                               )
                           ) BETWEEN LAST_DAY (p_from_date)
                                 AND LAST_DAY (p_to_date)
                     OR DECODE (p_param_date, 3, 0, 1) = 1
                    )
                AND (   (DECODE
                            (p_scope,
                             4, TRUNC (NVL (b.spoiled_acct_ent_date,
                                            c.spld_acct_ent_date
                                           )
                                      ),
--to include spoiled policies in the extraction/select output if scope is spoiled policies
                             TRUNC (NVL (b.acct_ent_date, c.acct_ent_date))
                            ) /*vcm 100709*/ BETWEEN p_from_date AND p_to_date
                        )                         --modified by alfie 04052010
                     OR DECODE (p_param_date, 4, 0, 1) = 1
                    )
                AND a.user_id = USER               --added by jason 10/17/2008
                                    )
         LOOP
            p_uwreports.pol_taxes2 (x.item_grp,
                                    x.takeup_seq_no,
                                    x.policy_id,
                                    p_scope,
                                    p_param_date,
                                    p_from_date,
                                    p_to_date
                                   );                          --abie 08152011
         END LOOP;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 2');

      IF v_count <> 0 AND p_param_date = 4
      THEN
         SELECT policy_id, total_tsi, total_prem, acct_ent_date,
                spld_acct_ent_date, spld_date, pol_flag
         BULK COLLECT INTO vv_policy_id, vv_total_tsi, vv_total_prem, vv_acct_ent_date,
                vv_spld_acct_ent_date, vv_spld_date, vv_pol_flag
           FROM gipi_uwreports_ext
          WHERE user_id = USER;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 3');

         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            IF     (vv_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
               AND (vv_spld_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
            THEN
               vv_total_tsi (idx) := 0;
               vv_total_prem (idx) := 0;
            ELSIF     vv_spld_date (idx) BETWEEN p_from_date AND p_to_date
                  AND vv_pol_flag (idx) = '5'
            THEN
               --issa10.02.2007 should not be multiplied to (-1), get value as is from table
               vv_total_tsi (idx) := vv_total_tsi (idx);
               vv_total_prem (idx) := vv_total_prem (idx);
            --issa10.02.2007 to prevent discrepancy in gipir923 and gipir923e
               /*vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
               vv_total_prem(idx) := vv_total_prem(idx) * (-1);*/
            END IF;

            vv_spld_date (idx) := NULL;
         END LOOP;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 4');
         FORALL upd IN vv_policy_id.FIRST .. vv_policy_id.LAST
            UPDATE gipi_uwreports_ext
               SET total_tsi = vv_total_tsi (upd),
                   total_prem = vv_total_prem (upd),
                   spld_date = vv_spld_date (upd)
             WHERE policy_id = vv_policy_id (upd) AND user_id = USER;
--   END LOOP;
         COMMIT;
      END IF;

      --P_UWREPORTS.POP_UWREPORTS_DIST_EXT(p_scope, p_param_date, p_from_date, p_to_date, p_iss_cd, p_line_cd, p_subline_cd, p_user, p_parameter);
      p_uwreports.pop_uwreports_dist_ext2 (p_scope,
                                           p_param_date,
                                           p_from_date,
                                           p_to_date,
                                           p_iss_cd,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_user,
                                           p_parameter
                                          );                --mikel 11.12.2013
      p_uwreports.copy_tab1 (p_scope,
                             p_param_date,
                             p_from_date,
                             p_to_date,
                             p_user
                            );                              --mikel 11.12.2013
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 5');
      COMMIT;
   END;                                           --end procedure extract_tab1

   PROCEDURE extract_tab2 (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2
   )
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (150);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_share_cd_tab IS TABLE OF giuw_perilds_dtl.share_cd%TYPE;

      TYPE v_share_type_tab IS TABLE OF giis_dist_share.share_type%TYPE;

      TYPE v_trty_name_tab IS TABLE OF giis_dist_share.trty_name%TYPE;

      TYPE v_trty_yy_tab IS TABLE OF giis_dist_share.trty_yy%TYPE;

      TYPE v_dist_no_tab IS TABLE OF giuw_perilds_dtl.dist_no%TYPE;

      TYPE v_dist_seq_no_tab IS TABLE OF giuw_perilds_dtl.dist_seq_no%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giuw_perilds_dtl.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_nr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_nr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_nr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_tr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_tr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_tr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_fa_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_fa_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_fa_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_currency_rt_tab IS TABLE OF gipi_invoice.currency_rt%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF giuw_pol_dist.acct_ent_date%TYPE;

      TYPE v_acct_neg_date_tab IS TABLE OF giuw_pol_dist.acct_neg_date%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      v_cred_branch     v_cred_branch_tab;
      v_policy_id       v_policy_id_tab;
      v_policy_no       v_policy_no_tab;
      v_line_cd         v_line_cd_tab;
      v_subline_cd      v_subline_cd_tab;
      v_share_cd        v_share_cd_tab;
      v_share_type      v_share_type_tab;
      v_trty_name       v_trty_name_tab;
      v_trty_yy         v_trty_yy_tab;
      v_dist_no         v_dist_no_tab;
      v_dist_seq_no     v_dist_seq_no_tab;
      v_peril_cd        v_peril_cd_tab;
      v_peril_type      v_peril_type_tab;
      v_nr_dist_tsi     v_nr_dist_tsi_tab;
      v_nr_dist_prem    v_nr_dist_prem_tab;
      v_nr_dist_spct    v_nr_dist_spct_tab;
      v_tr_dist_tsi     v_tr_dist_tsi_tab;
      v_tr_dist_prem    v_tr_dist_prem_tab;
      v_tr_dist_spct    v_tr_dist_spct_tab;
      v_fa_dist_tsi     v_fa_dist_tsi_tab;
      v_fa_dist_prem    v_fa_dist_prem_tab;
      v_fa_dist_spct    v_fa_dist_spct_tab;
      v_currency_rt     v_currency_rt_tab;
      v_endt_seq_no     v_endt_seq_no_tab;
      v_iss_cd          v_iss_cd_tab;
      v_issue_yy        v_issue_yy_tab;
      v_pol_seq_no      v_pol_seq_no_tab;
      v_renew_no        v_renew_no_tab;
      v_endt_iss_cd     v_endt_iss_cd_tab;
      v_endt_yy         v_endt_yy_tab;
      v_acct_ent_date   v_acct_ent_date_tab;
      v_acct_neg_date   v_acct_neg_date_tab;
      v_multiplier      NUMBER              := 1;
   BEGIN
      DELETE FROM gipi_uwreports_dist_peril_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 2 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (2, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, NULL, NULL, USER, SYSDATE,
                   NULL
                  );

      COMMIT;

      SELECT DISTINCT b.policy_id,            /*Get_Policy_No (b.policy_id) */
                         b.line_cd
                      || '-'
                      || b.subline_cd
                      || '-'
                      || b.iss_cd
                      || '-'
                      || LTRIM (TO_CHAR (b.issue_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                      || '-'
                      || LTRIM (TO_CHAR (b.renew_no, '09'))
                      || DECODE (NVL (b.endt_seq_no, 0),
                                 0, '',
                                    ' / '
                                 || b.endt_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (b.endt_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.endt_seq_no, '9999999'))
                                ) policy_no,
                      g.line_cd, b.subline_cd, g.share_cd, f.share_type,
                      f.trty_name, f.trty_yy, g.dist_no, g.dist_seq_no,
                      g.peril_cd, h.peril_type,
                        DECODE (f.share_type, '1', NVL (g.dist_tsi, 0))
                      * e.currency_rt nr_dist_tsi,
                        DECODE (f.share_type, '1', NVL (g.dist_prem, 0))
                      * e.currency_rt nr_dist_prem,
                      DECODE (f.share_type, '1', g.dist_spct) nr_dist_spct,
                        DECODE (f.share_type, '2', NVL (g.dist_tsi, 0))
                      * e.currency_rt tr_dist_tsi,
                        DECODE (f.share_type, '2', NVL (g.dist_prem, 0))
                      * e.currency_rt tr_dist_prem,
                      DECODE (f.share_type, '2', g.dist_spct) tr_dist_spct,
                        DECODE (f.share_type, '3', NVL (g.dist_tsi, 0))
                      * e.currency_rt fa_dist_tsi,
                        DECODE (f.share_type, '3', NVL (g.dist_prem, 0))
                      * e.currency_rt fa_dist_prem,
                      DECODE (f.share_type, '3', g.dist_spct) fa_dist_spct,
                      e.currency_rt, b.endt_seq_no, b.iss_cd, b.issue_yy,
                      b.pol_seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy,
                      /*A.acct_ent_date,*/
                      a.acct_ent_date, a.acct_neg_date, b.cred_branch
      BULK COLLECT INTO v_policy_id,
                      v_policy_no,
                      v_line_cd, v_subline_cd, v_share_cd, v_share_type,
                      v_trty_name, v_trty_yy, v_dist_no, v_dist_seq_no,
                      v_peril_cd, v_peril_type,
                      v_nr_dist_tsi,
                      v_nr_dist_prem,
                      v_nr_dist_spct,
                      v_tr_dist_tsi,
                      v_tr_dist_prem,
                      v_tr_dist_spct,
                      v_fa_dist_tsi,
                      v_fa_dist_prem,
                      v_fa_dist_spct,
                      v_currency_rt, v_endt_seq_no, v_iss_cd, v_issue_yy,
                      v_pol_seq_no, v_renew_no, v_endt_iss_cd, v_endt_yy,
                      v_acct_ent_date, v_acct_neg_date, v_cred_branch
                 FROM gipi_polbasic b,
                      giuw_pol_dist a,
                      giuw_perilds_dtl g,
                      gipi_invoice e,
                      giis_dist_share f,
                      giis_peril h
                WHERE 1 = 1
                  AND a.policy_id = b.policy_id
                  AND g.dist_no = a.dist_no
                  AND a.policy_id = e.policy_id
                  AND b.reg_policy_sw =
                             DECODE (p_special_pol,
                                     'Y', b.reg_policy_sw,
                                     'Y'
                                    )
                  AND NVL (b.line_cd, b.line_cd) = f.line_cd
                  AND NVL (b.line_cd, b.line_cd) = f.line_cd
                  AND NVL (b.line_cd, b.line_cd) = f.line_cd
                  AND b.line_cd >= '%'
                  AND b.subline_cd >= '%'
                  AND g.share_cd = f.share_cd
                  AND g.share_cd = f.share_cd
                  AND g.peril_cd = h.peril_cd
                  AND g.line_cd = h.line_cd
                  AND (b.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1
                      )
                  AND NVL (b.endt_type, 'A') = 'A'
                  AND (   (a.dist_flag = 3 AND b.dist_flag = 3)
                       OR p_param_date = 4
                      )
-------------------------------------
                  AND (   TRUNC (b.issue_date) BETWEEN p_from_date AND p_to_date
                       OR DECODE (p_param_date, 1, 0, 1) = 1
                      )
                  AND (   TRUNC (b.eff_date) BETWEEN p_from_date AND p_to_date
                       OR DECODE (p_param_date, 2, 0, 1) = 1
                      )
                  AND (   LAST_DAY
                             (TO_DATE
                                 (
                                     --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                                     --e.multi_booking_mm || ',' || TO_CHAR (e.multi_booking_yy),--glyza
                                     NVL (e.multi_booking_mm, b.booking_mth)
                                  || ','
                                  || TO_CHAR (NVL (e.multi_booking_yy,
                                                   b.booking_year
                                                  )
                                             ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                                  'FMMONTH,YYYY'
                                 )
                             ) BETWEEN LAST_DAY (p_from_date)
                                   AND LAST_DAY (p_to_date)
                       OR DECODE (p_param_date, 3, 0, 1) = 1
                      )
                  /*AND (   (   TRUNC (e.acct_ent_date) BETWEEN p_from_date AND p_to_date
                                 OR ((TRUNC (A.acct_neg_date) BETWEEN p_from_date AND p_to_date)*/--comment by VJ ; source of acct ent date should be pol_dist
                  AND (   (   TRUNC (a.acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                           OR (    (TRUNC (a.acct_neg_date) BETWEEN p_from_date
                                                                AND p_to_date
                                   )
                               AND p_param_date = 4
                              )
                          )
                       OR DECODE (p_param_date, 4, 0, 1) = 1
                      )
-------------------------------------------------------------
    /*AND (   (    p_param_date = 3
        AND LAST_DAY ( Convert_Booking_My (b.booking_mth, b.booking_year)) >= p_from_date)
        OR (p_param_date <> 3))
    AND (   (    p_param_date = 3
        AND Convert_Booking_My (b.booking_mth, b.booking_year) <= p_to_date)
        OR (p_param_date <> 3))
    AND (   (    TRUNC ( DECODE ( p_param_date,
                               1, b.issue_date,
                            2, b.eff_date,
                            4, A.acct_ent_date,
                            p_from_date + 1)) >= p_from_date
        AND TRUNC ( DECODE ( p_param_date,
                          1, b.issue_date,
                          2, b.eff_date,
                          4, A.acct_ent_date,
                          p_to_date - 1)) <= p_to_date)
        OR (    A.acct_neg_date >= p_from_date
        AND A.acct_neg_date <= p_to_date
        AND p_param_date = 4)) */
  ----------------------------------------------
    /*AND DECODE(b.pol_flag,'4',Check_Date_Dist_Peril(b.line_cd,
                                b.subline_cd, b.iss_cd,
                      b.issue_yy,b.pol_seq_no,
                      b.renew_no,p_param_date,
                      p_from_date,p_to_date),1) = 1*/
                  AND b.line_cd = NVL (p_line_cd, b.line_cd)
                  --AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
                  AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
                  AND DECODE (p_parameter, 1, b.cred_branch, b.iss_cd) =
                         NVL (p_iss_cd,
                              DECODE (p_parameter,
                                      1, b.cred_branch,
                                      b.iss_cd
                                     )
                             )
                  /* added glyza 05.29.08*/
                  AND NVL (a.item_grp, 1) = NVL (e.item_grp, 1)
                  AND NVL (a.takeup_seq_no, 1) = NVL (e.takeup_seq_no, 1);

-----------------------
      IF v_policy_id.EXISTS (1)
      THEN
--    if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4
               THEN
                  IF     TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                     AND TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := -1;
                  END IF;

                  v_nr_dist_tsi (idx) := v_nr_dist_tsi (idx) * v_multiplier;
                  v_nr_dist_prem (idx) := v_nr_dist_prem (idx) * v_multiplier;
                  v_tr_dist_tsi (idx) := v_tr_dist_tsi (idx) * v_multiplier;
                  v_tr_dist_prem (idx) := v_tr_dist_prem (idx) * v_multiplier;
                  v_fa_dist_tsi (idx) := v_fa_dist_tsi (idx) * v_multiplier;
                  v_fa_dist_prem (idx) := v_fa_dist_prem (idx) * v_multiplier;
               END IF;
            END;
         END LOOP;                              -- for idx in 1 .. v_pol_count
      END IF;                                       --if v_policy_id.exists(1)

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_dist_peril_ext
                        (policy_id, policy_no,
                         line_cd, subline_cd,
                         share_cd, share_type,
                         dist_no, dist_seq_no,
                         trty_name, trty_yy, from_date1,
                         to_date1, peril_cd, peril_type,
                         nr_dist_tsi, nr_dist_prem,
                         nr_dist_spct, tr_dist_tsi,
                         tr_dist_prem, tr_dist_spct,
                         fa_dist_tsi, fa_dist_prem,
                         fa_dist_spct, currency_rt,
                         endt_seq_no, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, user_id, SCOPE, param_date,
                         cred_branch
                        )
                 VALUES (v_policy_id (cnt), v_policy_no (cnt),
                         v_line_cd (cnt), v_subline_cd (cnt),
                         v_share_cd (cnt), v_share_type (cnt),
                         v_dist_no (cnt), v_dist_seq_no (cnt),
                         v_trty_name (cnt), v_trty_yy (cnt), p_from_date,
                         p_to_date, v_peril_cd (cnt), v_peril_type (cnt),
                         v_nr_dist_tsi (cnt), v_nr_dist_prem (cnt),
                         v_nr_dist_spct (cnt), v_tr_dist_tsi (cnt),
                         v_tr_dist_prem (cnt), v_tr_dist_spct (cnt),
                         v_fa_dist_tsi (cnt), v_fa_dist_prem (cnt),
                         v_fa_dist_spct (cnt), v_currency_rt (cnt),
                         v_endt_seq_no (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), p_user, p_scope, p_param_date,
                         v_cred_branch (cnt)
                        );
      END IF;                                            --end of if sql%found

      COMMIT;
   END;                                                        --extract tab 2

   PROCEDURE extract_tab3 (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2
   )
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;

      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (200);

      TYPE v_binder_no_tab IS TABLE OF VARCHAR2 (200);

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_ri_tsi_amt_tab IS TABLE OF giri_binder.ri_tsi_amt%TYPE;

      TYPE v_ri_prem_amt_tab IS TABLE OF giri_binder.ri_prem_amt%TYPE;

      TYPE v_ri_comm_amt_tab IS TABLE OF giri_binder.ri_comm_amt%TYPE;

      TYPE v_ri_sname_tab IS TABLE OF giis_reinsurer.ri_sname%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF giri_binder.acc_ent_date%TYPE;

      --TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
      TYPE v_acct_rev_date_tab IS TABLE OF giri_binder.acc_rev_date%TYPE;

      TYPE v_ri_cd_tab IS TABLE OF giis_reinsurer.ri_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_ri_prem_vat_tab IS TABLE OF giri_binder.ri_prem_vat%TYPE;

      TYPE v_ri_comm_vat_tab IS TABLE OF giri_binder.ri_comm_vat%TYPE;

      TYPE v_ri_wholding_vat_tab IS TABLE OF giri_binder.ri_wholding_vat%TYPE;

      TYPE v_prem_tax_tab IS TABLE OF giri_frps_ri.prem_tax%TYPE;
                                                               --Added by Lem

      TYPE v_dist_no_tab IS TABLE OF giuw_pol_dist.dist_no%TYPE;
                                                          -- jhing 01.19.2013

      TYPE v_frps_line_cd_tab IS TABLE OF giri_distfrps.line_cd%TYPE;
                                                          -- jhing 19.12.2013

      TYPE v_frps_yy_tab IS TABLE OF giri_distfrps.frps_yy%TYPE;
                                                          -- jhing 01.19.2013

      TYPE v_frps_seq_no_tab IS TABLE OF giri_distfrps.frps_seq_no%TYPE;
                                                          -- jhing 01.19.2013

      TYPE v_acct_neg_date_tab IS TABLE OF giuw_pol_dist.acct_neg_date%TYPE;
                                                          -- jhing 01.21.2013

      v_cred_branch       v_cred_branch_tab;
      v_line_cd           v_line_cd_tab;
      v_subline_cd        v_subline_cd_tab;
      v_iss_cd            v_iss_cd_tab;
      v_line_name         v_line_name_tab;
      v_subline_name      v_subline_name_tab;
      v_policy_no         v_policy_no_tab;
      v_binder_no         v_binder_no_tab;
      v_assd_name         v_assd_name_tab;
      v_policy_id         v_policy_id_tab;
      v_incept_date       v_incept_date_tab;
      v_expiry_date       v_expiry_date_tab;
      v_tsi_amt           v_tsi_amt_tab;
      v_prem_amt          v_prem_amt_tab;
      v_ri_tsi_amt        v_ri_tsi_amt_tab;
      v_ri_prem_amt       v_ri_prem_amt_tab;
      v_ri_comm_amt       v_ri_comm_amt_tab;
      v_ri_sname          v_ri_sname_tab;
      v_acct_ent_date     v_acct_ent_date_tab;
      --v_spld_acct_ent_date       v_spld_acct_ent_date_tab;
      v_acct_rev_date     v_acct_rev_date_tab;
      v_ri_cd             v_ri_cd_tab;
      v_endt_seq_no       v_endt_seq_no_tab;
      v_multiplier        NUMBER                := 1;
      v_ri_prem_vat       v_ri_prem_vat_tab;
      v_ri_comm_vat       v_ri_comm_vat_tab;
      v_ri_wholding_vat   v_ri_wholding_vat_tab;
      v_prem_tax          v_prem_tax_tab;                      --Added by Lem
      v_dist_no           v_dist_no_tab;                  -- Jhing 01.19.2013
      v_frps_line_cd      v_frps_line_cd_tab;             -- jhing 01.19.2013
      v_frps_yy           v_frps_yy_tab;                  -- jhing 01.19.2013
      v_frps_seq_no       v_frps_seq_no_tab;              -- jhing 01.19.2013
      v_acct_neg_date     v_acct_neg_date_tab;            -- jhing 01.21.2013
   BEGIN
      DELETE FROM gipi_uwreports_ri_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 3 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (3, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, NULL, NULL, USER, SYSDATE,
                   NULL
                  );

      COMMIT;

      BEGIN
         SELECT b250.line_cd, b250.subline_cd, b250.iss_cd, a120.line_name,
                a130.subline_name, get_policy_no (b250.policy_id) policy_no,
                   b250.line_cd
                || '-'
                || LTRIM (TO_CHAR (d005.binder_yy, '09'))
                || '-'
                || LTRIM
                      (TO_CHAR
                          (d005.binder_seq_no,
                           '09999' /* '099999' -- REPLACED WITH '09999' to synch with max binder_seq_no length/size and to ensure complete binder nos are displayed*/
                          )
                      ) binder_no,
                a020.assd_name, b250.policy_id,
                TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
                TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
                d060.tsi_amt * d060.currency_rt sum_insured,
                d060.prem_amt * d060.currency_rt,
                d005.ri_tsi_amt * d060.currency_rt amt_accepted,
                d005.ri_prem_amt * d060.currency_rt prem_accepted,
                NVL (d005.ri_comm_amt * d060.currency_rt, 0) ri_comm_amt,
                a140.ri_sname ri_short_name,
                                            --b250.acct_ent_date, b250.spld_acct_ent_date, --gracey 04-22-05
                                            d005.acc_ent_date,
                d005.acc_rev_date, d005.ri_cd, b250.endt_seq_no,
                b250.cred_branch, d005.ri_prem_vat * d060.currency_rt,
                d005.ri_comm_vat * d060.currency_rt,
                d005.ri_wholding_vat * d060.currency_rt,
                NVL (d070.prem_tax * d060.currency_rt, 0) prem_tax
                                                                --Added by Lem
                                                                  ,
                c080.dist_no
-- jhing 01.19.2013 -- added this column since sum insured for summary report GIPIR930 is always zero since this field has null values in the ext table (GIPI_UWREPORTS_RI_EXT )
                            ,
                d070.line_cd                               -- jhing 01.19.2013
                            ,
                d070.frps_yy                               -- jhing 01.19.2013
                            ,
                d070.frps_seq_no                           -- jhing 01.19.2013
         BULK COLLECT INTO v_line_cd, v_subline_cd, v_iss_cd, v_line_name,
                v_subline_name, v_policy_no,
                v_binder_no,
                v_assd_name, v_policy_id,
                v_incept_date,
                v_expiry_date,
                v_tsi_amt,
                v_prem_amt,
                v_ri_tsi_amt,
                v_ri_prem_amt,
                v_ri_comm_amt,
                v_ri_sname, v_acct_ent_date,
                v_acct_rev_date, v_ri_cd, v_endt_seq_no,
                v_cred_branch, v_ri_prem_vat,
                v_ri_comm_vat,
                v_ri_wholding_vat,
                v_prem_tax                                      --Added by Lem
                          ,
                v_dist_no                                  -- jhing 01.19.2013
                         ,
                v_frps_line_cd                             -- jhing 01.19.2013
                              ,
                v_frps_yy                                  -- jhing 01.19.2013
                         ,
                v_frps_seq_no                              -- jhing 01.19.2013
           FROM gipi_polbasic b250,
                giuw_pol_dist c080,
                giri_distfrps d060,
                giri_frps_ri d070,
                gipi_parlist b240,
                giri_binder d005,
                giis_line a120,
                giis_subline a130,
                giis_assured a020,
                giis_reinsurer a140,
                gipi_invoice gi                                        --glyza
          WHERE d060.line_cd >= '%'
            -- AND C080.DIST_FLAG = '3'--VJPS 060112  -- jhing 01.19.2013 commented out and replaced with:
            AND (DECODE (p_param_date, 4, 1, 0) = 1 OR c080.dist_flag = '3'
                )                                          -- jhing 01.19.2013
            -- glyza 05.29.08-----------------
            AND gi.policy_id = b250.policy_id
            AND NVL (c080.item_grp, 1) = NVL (gi.item_grp, 1)
            AND NVL (c080.takeup_seq_no, 1) = NVL (gi.takeup_seq_no, 1)
-------------------
            AND b250.reg_policy_sw =
                          DECODE (p_special_pol,
                                  'Y', b250.reg_policy_sw,
                                  'Y'
                                 )
            AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
            AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
            AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
            AND NVL (a120.line_cd, a120.line_cd) =
                                              NVL (b250.line_cd, b250.line_cd)
            AND NVL (b250.line_cd, b250.line_cd) =
                                              NVL (a130.line_cd, a130.line_cd)
            AND NVL (b250.subline_cd, b250.subline_cd) =
                                        NVL (a130.subline_cd, a130.subline_cd)
            AND (b250.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1)
            AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                 OR DECODE (p_param_date, 1, 0, 1) = 1
                )
            AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                 OR DECODE (p_param_date, 2, 0, 1) = 1
                )
            AND (   LAST_DAY
                       (TO_DATE
                           (
                               --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                               --gi.multi_booking_mm || ',' || TO_CHAR (gi.multi_booking_yy),
                               NVL (gi.multi_booking_mm, b250.booking_mth)
                            || ','
                            || TO_CHAR (NVL (gi.multi_booking_yy,
                                             b250.booking_year
                                            )
                                       ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                            'FMMONTH,YYYY'
                           )
                       ) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY
                                                                    (p_to_date)
                 OR DECODE (p_param_date, 3, 0, 1) = 1
                )
-- made into comment by grace 03.11.05
-- causes discrepancies as to compare with the distribution register
/*         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date AND p_to_date
              OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND d005.reverse_date IS NULL*/
/*       AND ((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date
                 OR NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
                   BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date) OR
            (d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
              OR DECODE (p_param_date, 4, 0, 1) = 1) */
/*  judyann 10052007; separated SELECT statement for reversed binders/negated distribution */
         /*AND ((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
         OR DECODE (p_param_date, 4, 0, 1) = 1)*/
  /* ----------------- commented out by jhing 01.19.2013 */--
--/*comment by VJP 07292011 replaced by conditions below; this will handle binder reversal with no dist negation*/
--         AND ((((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date)
--              OR DECODE (p_param_date, 4, 0, 1) = 1)
--         AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
--         OR DECODE (p_param_date, 4, 0, 1) = 1))
--         OR  (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
--         OR DECODE (p_param_date, 4, 0, 1) = 1))
-- end of revision by grace
/* revised condition - jhing 01.19.2013 */
            AND (   DECODE (p_param_date, 4, 1, 0) = 1
                 OR ((c080.negate_date IS NULL AND d005.reverse_date IS NULL
                     )
                    )                          --- for non-acct_ent_date param
                )
            AND (   DECODE (p_param_date, 4, 0, 1) = 1
                 OR (   (    TRUNC (c080.acct_ent_date) BETWEEN p_from_date
                                                            AND p_to_date
                         AND TRUNC (d005.acc_ent_date) BETWEEN p_from_date
                                                           AND p_to_date
                        )
                     OR (    TRUNC (c080.acct_ent_date) <= p_from_date
                         AND TRUNC (d005.acc_ent_date) BETWEEN p_from_date
                                                           AND p_to_date
                        )
---RCD  07.24.2013
             /*OR (    TRUNC (d005.acc_ent_date) <=  p_from_date
                  AND TRUNC (c080.acct_ent_date) BETWEEN p_from_date
                                                    AND p_to_date
                )*/--commented out by albert 10242013
---RCD 07.24.2013
                    )
                )
            /* ---------------- end of revised condition jhing */
            AND DECODE (b250.pol_flag,
                        '4', p_uwreports.check_date_dist_peril
                                                             (b250.line_cd,
                                                              b250.subline_cd,
                                                              b250.iss_cd,
                                                              b250.issue_yy,
                                                              b250.pol_seq_no,
                                                              b250.renew_no,
                                                              p_param_date,
                                                              p_from_date,
                                                              p_to_date
                                                             ),
                        1
                       ) = 1
            AND b240.assd_no = a020.assd_no
            AND d005.ri_cd = a140.ri_cd
            AND c080.dist_no = d060.dist_no
            AND b250.par_id = b240.par_id
            AND c080.policy_id = b250.policy_id
            AND d070.fnl_binder_id = d005.fnl_binder_id
            AND NVL (b250.endt_type, 'A') = 'A'
            --AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
            AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
            AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
            --AND b250.iss_cd            = NVL (p_iss_cd, b250.iss_cd);
            AND DECODE (p_parameter, 1, b250.cred_branch, b250.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_parameter,
                                1, b250.cred_branch,
                                b250.iss_cd
                               )
                       );

-- jhing commented out; values should not be set to zero when the posted and reversal are printed on the same report (based on parameter)
--      IF v_policy_id.EXISTS (1) THEN
--   --if sql%found then
--        FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
--        LOOP
--          BEGIN
--            IF p_param_date = 4 THEN
--              IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
--                AND TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := 0;
--              ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := 1;
--              ELSIF TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := -1;
--              END IF;

         --           v_tsi_amt (idx)         := v_tsi_amt (idx) * v_multiplier;
--              v_prem_amt (idx)        := v_prem_amt (idx) * v_multiplier;
--              v_ri_tsi_amt (idx)      := v_ri_tsi_amt (idx) * v_multiplier;
--              v_ri_prem_amt (idx)     := v_ri_prem_amt (idx) * v_multiplier;
--              v_ri_comm_amt (idx)     := v_ri_comm_amt (idx) * v_multiplier;
--          v_ri_prem_vat (idx)     := v_ri_prem_vat (idx) * v_multiplier;
--          v_ri_comm_vat (idx)     := v_ri_comm_vat (idx) * v_multiplier;
--          v_ri_wholding_vat (idx) := v_ri_wholding_vat (idx) * v_multiplier;
--            v_prem_tax (idx)  := v_prem_tax (idx) * v_multiplier;  --Lem
--            END IF;
--          END;
--        END LOOP; -- for idx in 1 .. v_pol_count
--      END IF; --if v_policy_id.exists(1)
         IF SQL%FOUND
         THEN
            FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
/*
dbms_output.put_line('assd_name-'||v_assd_name (cnt));
dbms_output.put_line('LINE_CD-'||v_line_cd (cnt));
dbms_output.put_line('SUBLINE_CD-'||v_subline_cd (cnt));
dbms_output.put_line('ISS_CD-'||v_iss_cd (cnt));
dbms_output.put_line('LINE_NAME-'||v_line_name (cnt));
dbms_output.put_line('SUBLINE_NAME-'||v_subline_name (cnt));
dbms_output.put_line('POLICY_NO-'||v_policy_no (cnt));
dbms_output.put_line('BINDER_NO-'||v_binder_no (cnt));
dbms_output.put_line('TOTAL_SI-'||v_tsi_amt (cnt));
dbms_output.put_line('TOTAL_PROM-'||v_prem_amt (cnt));
dbms_output.put_line('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
dbms_output.put_line('SHARE_PREM-'||v_ri_prem_amt (cnt));
dbms_output.put_line('COMM_AMT-'||v_ri_comm_amt (cnt));
dbms_output.put_line('NET_DUE-'||nvl (v_ri_prem_amt (cnt), 0)
                         - nvl (v_ri_comm_amt (cnt), 0));
dbms_output.put_line('SHORT_NAME-'||v_ri_sname (cnt));
dbms_output.put_line('RI_CD-'||v_ri_cd (cnt));
dbms_output.put_line('POLICY_CD-'||v_policy_cd (cnt));
dbms_output.put_line('PARAM_DATE-'||p_param_date);
dbms_output.put_line('FROM_DATE-'||p_from_date);
dbms_output.put_line('TO_DATE-'||p_to_date);
dbms_output.put_line('USER_ID-'||p_user);*/
               INSERT INTO gipi_uwreports_ri_ext
                           (assd_name, line_cd,
                            subline_cd, iss_cd,
                            incept_date,
                            expiry_date,
                            line_name, subline_name,
                            policy_no, binder_no,
                            total_si, total_prem,
                            sum_reinsured, share_premium,
                            ri_comm_amt,
                            net_due,
                            ri_short_name, ri_cd,
                            policy_id, param_date, from_date,
                            TO_DATE, SCOPE, user_id, endt_seq_no,
                            cred_branch, ri_prem_vat,
                            ri_comm_vat, ri_wholding_vat,
                            ri_premium_tax, dist_no,
                            frps_line_cd, frps_yy,
                            frps_seq_no /*jhing 01.19.2013 added dist_no, frps_line_cd, frps_yy, frps_seq_no */
                           )                                             --Lem
                    VALUES (v_assd_name (cnt), v_line_cd (cnt),
                            v_subline_cd (cnt), v_iss_cd (cnt),
                            TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                            TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                            v_line_name (cnt), v_subline_name (cnt),
                            v_policy_no (cnt), v_binder_no (cnt),
                            v_tsi_amt (cnt), v_prem_amt (cnt),
                            v_ri_tsi_amt (cnt), v_ri_prem_amt (cnt),
                            v_ri_comm_amt (cnt),
                              (  NVL (v_ri_prem_amt (cnt), 0)
                               + NVL (v_ri_prem_vat (cnt), 0)
                              )
                            - (  NVL (v_ri_comm_amt (cnt), 0)
                               + NVL (v_ri_comm_vat (cnt), 0)
                               + NVL (v_ri_wholding_vat (cnt), 0)
                              ),
                            v_ri_sname (cnt), v_ri_cd (cnt),
                            v_policy_id (cnt), p_param_date, p_from_date,
                            p_to_date, p_scope, p_user, v_endt_seq_no (cnt),
                            v_cred_branch (cnt), v_ri_prem_vat (cnt),
                            v_ri_comm_vat (cnt), v_ri_wholding_vat (cnt),
                            v_prem_tax (cnt), v_dist_no (cnt),
                            v_frps_line_cd (cnt), v_frps_yy (cnt),
                            v_frps_seq_no
                               (cnt) /*jhing 01.19.2013 added v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt)*/
                           );                                            --Lem
            COMMIT;
         END IF;                                         --end of if sql%found
      END;

      BEGIN
/* judyann 10052007; separated SELECT statement for reversed binders/negated distribution */
         SELECT DISTINCT b250.line_cd, b250.subline_cd, b250.iss_cd,
                         a120.line_name,
                                        /*vjpsalud added distinct 10/08/2012*/
                                        a130.subline_name,
                         get_policy_no (b250.policy_id) policy_no,
                            b250.line_cd
                         || '-'
                         || LTRIM (TO_CHAR (d005.binder_yy, '09'))
                         || '-'
                         || LTRIM
                               (TO_CHAR
                                   (d005.binder_seq_no,
                                    '09999' /* jhing 01.19.2013 modified from '099999' */
                                   )
                               ) binder_no,
                         a020.assd_name, b250.policy_id,
                         TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
                         TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
                         d060.tsi_amt * d060.currency_rt sum_insured,
                         d060.prem_amt * d060.currency_rt,
                         d005.ri_tsi_amt * d060.currency_rt amt_accepted,
                         d005.ri_prem_amt * d060.currency_rt prem_accepted,
                         NVL (d005.ri_comm_amt * d060.currency_rt, 0)
                                                                  ri_comm_amt,
                         a140.ri_sname ri_short_name,
                                                     --b250.acct_ent_date, b250.spld_acct_ent_date, --gracey 04-22-05
                                                     d005.acc_ent_date,
                         d005.acc_rev_date, d005.ri_cd, b250.endt_seq_no,
                         b250.cred_branch,
                         d005.ri_prem_vat * d060.currency_rt,
                         d005.ri_comm_vat * d060.currency_rt,
                         d005.ri_wholding_vat * d060.currency_rt,
                         NVL (d070.prem_tax * d060.currency_rt, 0) prem_tax
                                                                         --Lem
                                                                           ,
                         c080.dist_no
-- jhing 01.19.2013 -- added this column since sum insured for summary report GIPIR930 is always zero since this field has null values in the ext table (GIPI_UWREPORTS_RI_EXT )
                                     ,
                         d070.line_cd                      -- jhing 01.19.2013
                                     ,
                         d070.frps_yy                      -- jhing 01.19.2013
                                     ,
                         d070.frps_seq_no                  -- jhing 01.19.2013
                                         ,
                         c080.acct_neg_date                -- jhing 01.21.2013
         BULK COLLECT INTO v_line_cd, v_subline_cd, v_iss_cd,
                         v_line_name, v_subline_name,
                         v_policy_no,
                         v_binder_no,
                         v_assd_name, v_policy_id,
                         v_incept_date,
                         v_expiry_date,
                         v_tsi_amt,
                         v_prem_amt,
                         v_ri_tsi_amt,
                         v_ri_prem_amt,
                         v_ri_comm_amt,
                         v_ri_sname, v_acct_ent_date,
                         v_acct_rev_date, v_ri_cd, v_endt_seq_no,
                         v_cred_branch,
                         v_ri_prem_vat,
                         v_ri_comm_vat,
                         v_ri_wholding_vat,
                         v_prem_tax                                      --Lem
                                   ,
                         v_dist_no                         -- jhing 01.19.2013
                                  ,
                         v_frps_line_cd                    -- jhing 01.19.2013
                                       ,
                         v_frps_yy                         -- jhing 01.19.2013
                                  ,
                         v_frps_seq_no                     -- jhing 01.19.2013
                                      ,
                         v_acct_neg_date
                    FROM gipi_polbasic b250,
                         giuw_pol_dist c080,
                         giri_distfrps d060,
                         giri_frps_ri d070,
                         gipi_parlist b240,
                         giri_binder d005,
                         giis_line a120,
                         giis_subline a130,
                         giis_assured a020,
                         giis_reinsurer a140,
                         gipi_invoice gi                      --glyza 05.29.08
                   WHERE d060.line_cd >= '%'
                     -- glyza 05.29.08-----------------
                     AND gi.policy_id = b250.policy_id
                     AND DECODE (p_param_date, 4, 1, 0) =
                            1
-- jhing 01.19.2013 ; to ensure this query is only applicable when param_date = acct_ent_date
                     AND NVL (c080.item_grp, 1) = NVL (gi.item_grp, 1)
                     AND NVL (c080.takeup_seq_no, 1) =
                                                     NVL (gi.takeup_seq_no, 1)
-------------------
                     AND b250.reg_policy_sw =
                            DECODE (p_special_pol,
                                    'Y', b250.reg_policy_sw,
                                    'Y'
                                   )
                     AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
                     AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
                     AND NVL (d060.frps_seq_no, d060.frps_seq_no) =
                                                              d070.frps_seq_no
                     AND NVL (a120.line_cd, a120.line_cd) =
                                              NVL (b250.line_cd, b250.line_cd)
                     AND NVL (b250.line_cd, b250.line_cd) =
                                              NVL (a130.line_cd, a130.line_cd)
                     AND NVL (b250.subline_cd, b250.subline_cd) =
                                        NVL (a130.subline_cd, a130.subline_cd)
                     AND (   b250.pol_flag != '5'
                          OR DECODE (p_param_date, 4, 1, 0) = 1
                         )
                     AND (   TRUNC (b250.issue_date) BETWEEN p_from_date
                                                         AND p_to_date
                          OR DECODE (p_param_date, 1, 0, 1) = 1
                         )
                     AND (   TRUNC (b250.eff_date) BETWEEN p_from_date
                                                       AND p_to_date
                          OR DECODE (p_param_date, 2, 0, 1) = 1
                         )
                     AND (   LAST_DAY
                                (TO_DATE
                                    (
                                        --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                                        --gi.multi_booking_mm || ',' || TO_CHAR(gi.multi_booking_yy), --glyza 05.29.08
                                        NVL (gi.multi_booking_mm,
                                             b250.booking_mth
                                            )
                                     || ','
                                     || TO_CHAR (NVL (gi.multi_booking_yy,
                                                      b250.booking_year
                                                     )
                                                ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                                     'FMMONTH,YYYY'
                                    )
                                ) BETWEEN LAST_DAY (p_from_date)
                                      AND LAST_DAY (p_to_date)
                          OR DECODE (p_param_date, 3, 0, 1) = 1
                         )
-- made into comment by grace 03.11.05
-- causes discrepancies as to compare with the distribution register
/*         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND d005.reverse_date IS NULL*/
/*         AND ((NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
                        BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         and(((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
              OR DECODE (p_param_date, 4, 0, 1) = 1)*/
 ------------------ jhing commented out 01.19.2013 --------------------------------------
--/*comment by VJP 07292011 replaced by conditions below; this will handle binder reversal with no dist negation*/
--         AND ((((NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
--                        BETWEEN p_from_date AND p_to_date)
--              OR DECODE (p_param_date, 4, 0, 1) = 1)
--         and(((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
--              OR DECODE (p_param_date, 4, 0, 1) = 1))
--         or (((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
--              OR DECODE (p_param_date, 4, 0, 1) = 1))
---- end of revision by grace
/* revised condition - jhing 01.19.2013 */
                     AND (   (    TRUNC (c080.acct_neg_date) BETWEEN p_from_date
                                                                 AND p_to_date
                              AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                                AND p_to_date
                             )
                          OR (    c080.acct_neg_date IS NULL
                              AND TRUNC (c080.acct_ent_date) <= p_from_date
                              AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                                AND p_to_date
                             )
                          OR (    TRUNC (d005.acc_ent_date) <= p_from_date
                              AND TRUNC (c080.acct_neg_date) BETWEEN p_from_date
                                                                 AND p_to_date
                              /*Added by: Joanne
                              **Date: 05242013
                              **Description: To only include binder under negated dist.that was reversed on the same cut-off date*/
                              AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                                AND p_to_date
                             --end of modification by Joanne
                             )
                         )
                     /* ---------------- end of revised condition jhing */
                     AND DECODE
                            (b250.pol_flag,
                             '4', p_uwreports.check_date_dist_peril
                                                             (b250.line_cd,
                                                              b250.subline_cd,
                                                              b250.iss_cd,
                                                              b250.issue_yy,
                                                              b250.pol_seq_no,
                                                              b250.renew_no,
                                                              p_param_date,
                                                              p_from_date,
                                                              p_to_date
                                                             ),
                             1
                            ) = 1
                     AND b240.assd_no = a020.assd_no
                     AND d005.ri_cd = a140.ri_cd
                     AND c080.dist_no = d060.dist_no
                     AND b250.par_id = b240.par_id
                     AND c080.policy_id = b250.policy_id
                     AND d070.fnl_binder_id = d005.fnl_binder_id
                     AND NVL (b250.endt_type, 'A') = 'A'
                     --AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
                     AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
                     AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
                     --AND b250.iss_cd               = NVL (p_iss_cd, b250.iss_cd);
                     AND DECODE (p_parameter,
                                 1, b250.cred_branch,
                                 b250.iss_cd
                                ) =
                            NVL (p_iss_cd,
                                 DECODE (p_parameter,
                                         1, b250.cred_branch,
                                         b250.iss_cd
                                        )
                                );

         IF v_policy_id.EXISTS (1)
         THEN
            --if sql%found then
            FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
            LOOP
               BEGIN
                  IF p_param_date = 4
                  THEN
            /* -- jhing commented out; values will be automatically be multiplied to negative value since this query is for reversals */
--              IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
--                AND TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := 0;
--              ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := 1;
--              ELSIF TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
--                  v_multiplier := -1;
--              END IF;
                     v_multiplier := -1;                  -- jhing 01.19.2013

                     IF     v_acct_neg_date (idx) IS NOT NULL
                        AND TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                              AND p_to_date
                     THEN               -- jhing 01.21.2013 added if condition
                        v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                                            -- jhing 01.21.2013 commented out
                        v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
                                            -- jhing 01.21.2013 commented out
                     END IF;

                     v_ri_tsi_amt (idx) := v_ri_tsi_amt (idx) * v_multiplier;
                     v_ri_prem_amt (idx) := v_ri_prem_amt (idx) * v_multiplier;
                     v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier;
                     v_ri_prem_vat (idx) := v_ri_prem_vat (idx) * v_multiplier;
                     v_ri_comm_vat (idx) := v_ri_comm_vat (idx) * v_multiplier;
                     v_ri_wholding_vat (idx) :=
                                         v_ri_wholding_vat (idx)
                                         * v_multiplier;
                     v_prem_tax (idx) := v_prem_tax (idx) * v_multiplier;
                                                                         --Lem
                  END IF;
               END;
            END LOOP;                           -- for idx in 1 .. v_pol_count
         END IF;                                    --if v_policy_id.exists(1)

         IF SQL%FOUND
         THEN
            FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
/*
dbms_output.put_line('assd_name-'||v_assd_name (cnt));
dbms_output.put_line('LINE_CD-'||v_line_cd (cnt));
dbms_output.put_line('SUBLINE_CD-'||v_subline_cd (cnt));
dbms_output.put_line('ISS_CD-'||v_iss_cd (cnt));
dbms_output.put_line('LINE_NAME-'||v_line_name (cnt));
dbms_output.put_line('SUBLINE_NAME-'||v_subline_name (cnt));
dbms_output.put_line('POLICY_NO-'||v_policy_no (cnt));
dbms_output.put_line('BINDER_NO-'||v_binder_no (cnt));
dbms_output.put_line('TOTAL_SI-'||v_tsi_amt (cnt));
dbms_output.put_line('TOTAL_PROM-'||v_prem_amt (cnt));
dbms_output.put_line('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
dbms_output.put_line('SHARE_PREM-'||v_ri_prem_amt (cnt));
dbms_output.put_line('COMM_AMT-'||v_ri_comm_amt (cnt));
dbms_output.put_line('NET_DUE-'||nvl (v_ri_prem_amt (cnt), 0)
                         - nvl (v_ri_comm_amt (cnt), 0));
dbms_output.put_line('SHORT_NAME-'||v_ri_sname (cnt));
dbms_output.put_line('RI_CD-'||v_ri_cd (cnt));
dbms_output.put_line('POLICY_CD-'||v_policy_cd (cnt));
dbms_output.put_line('PARAM_DATE-'||p_param_date);
dbms_output.put_line('FROM_DATE-'||p_from_date);
dbms_output.put_line('TO_DATE-'||p_to_date);
dbms_output.put_line('USER_ID-'||p_user);*/
               INSERT INTO gipi_uwreports_ri_ext
                           (assd_name, line_cd,
                            subline_cd, iss_cd,
                            incept_date,
                            expiry_date,
                            line_name, subline_name,
                            policy_no, binder_no,
                            total_si, total_prem,
                            sum_reinsured, share_premium,
                            ri_comm_amt,
                            net_due,
                            ri_short_name, ri_cd,
                            policy_id, param_date, from_date,
                            TO_DATE, SCOPE, user_id, endt_seq_no,
                            cred_branch, ri_prem_vat,
                            ri_comm_vat, ri_wholding_vat,
                            ri_premium_tax, dist_no,
                            frps_line_cd, frps_yy,
                            frps_seq_no /*jhing 01.19.2013 added dist_no, frps_line_cd, frps_yy, frps_seq_no */
                           )                                             --Lem
                    VALUES (v_assd_name (cnt), v_line_cd (cnt),
                            v_subline_cd (cnt), v_iss_cd (cnt),
                            TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                            TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                            v_line_name (cnt), v_subline_name (cnt),
                            v_policy_no (cnt), v_binder_no (cnt),
                            v_tsi_amt (cnt), v_prem_amt (cnt),
                            v_ri_tsi_amt (cnt), v_ri_prem_amt (cnt),
                            v_ri_comm_amt (cnt),
                              (  NVL (v_ri_prem_amt (cnt), 0)
                               + NVL (v_ri_prem_vat (cnt), 0)
                              )
                            - (  NVL (v_ri_comm_amt (cnt), 0)
                               + NVL (v_ri_comm_vat (cnt), 0)
                               + NVL (v_ri_wholding_vat (cnt), 0)
                              ),
                            v_ri_sname (cnt), v_ri_cd (cnt),
                            v_policy_id (cnt), p_param_date, p_from_date,
                            p_to_date, p_scope, p_user, v_endt_seq_no (cnt),
                            v_cred_branch (cnt), v_ri_prem_vat (cnt),
                            v_ri_comm_vat (cnt), v_ri_wholding_vat (cnt),
                            v_prem_tax (cnt), v_dist_no (cnt),
                            v_frps_line_cd (cnt), v_frps_yy (cnt),
                            v_frps_seq_no
                               (cnt) /*jhing 01.19.2013 added v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt)*/
                           );                                 --Lem 07/07/2008
            COMMIT;
         END IF;                                         --end of if sql%found
      END;
   END;                                                        --extract tab 3

   PROCEDURE extract_tab4 (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2
   )
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_uwreports_peril_ext.prem_amt%TYPE;
                                                              -- aaron 102609

      --TYPE v_prem_amt_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE; -- aaron 102609
      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;

      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      v_cred_branch          v_cred_branch_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_line_name            v_line_name_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_peril_sname          v_peril_sname_tab;
      v_peril_name           v_peril_name_tab;
      v_intm_name            v_intm_name_tab;
      v_peril_cd             v_peril_cd_tab;
      v_peril_type           v_peril_type_tab;
      v_intm_no              v_intm_no_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_policy_id            v_policy_id_tab;
      v_iss_cd               v_iss_cd_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_multiplier           NUMBER                   := 1;
   BEGIN
      DELETE FROM gipi_uwreports_peril_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 4 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (4, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, NULL, NULL, USER, SYSDATE,
                   NULL
                  );

      COMMIT;

      SELECT   b250.line_cd, b250.subline_cd, a100.line_name,
               SUM (  NVL (b300.share_percentage, 0)
                    / 100
                    * NVL (b400.tsi_amt * b140.currency_rt, 0)
                   ) tsi_amt,
               SUM (  NVL (b300.share_percentage, 0)
                    / 100
                    * NVL (b400.prem_amt, 0)
                    * b140.currency_rt
                   ) prem_amt,
               a300.peril_sname, a300.peril_name, a400.intm_name,
               a300.peril_cd, a300.peril_type, a400.intm_no,
               b140.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
               --b250.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
               b250.iss_cd, b250.endt_seq_no, b250.cred_branch
      BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name,
               v_tsi_amt,
               v_prem_amt,
               v_peril_sname, v_peril_name, v_intm_name,
               v_peril_cd, v_peril_type, v_intm_no,
               v_acct_ent_date, v_spld_acct_ent_date, v_policy_id,
               v_iss_cd, v_endt_seq_no, v_cred_branch
          FROM gipi_polbasic b250,
               gipi_invoice b140,
               gipi_comm_invoice b300,
               gipi_invperil b400,
               giis_line a100,
               giis_peril a300,
               giis_intermediary a400
         WHERE NVL (b300.intrmdry_intm_no, b300.intrmdry_intm_no) =
                                              NVL (a400.intm_no, a400.intm_no)
           AND b250.reg_policy_sw =
                          DECODE (p_special_pol,
                                  'Y', b250.reg_policy_sw,
                                  'Y'
                                 )
           AND NVL (b400.peril_cd, b400.peril_cd) =
                                            NVL (a300.peril_cd, a300.peril_cd)
           AND NVL (a300.line_cd, a300.line_cd) =
                                              NVL (b250.line_cd, b250.line_cd)
           AND (b250.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1)
           --AND (b250.dist_flag = '3'  or decode(v_param_date,4,1,0) = 1)
           AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 1, 0, 1) = 1
               )
           AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 2, 0, 1) = 1
               )
           AND (   LAST_DAY
                      (TO_DATE
                          (
                              --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                              --b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
                              NVL (b140.multi_booking_mm, b250.booking_mth)
                           || ','
                           || TO_CHAR (NVL (b140.multi_booking_yy,
                                            b250.booking_year
                                           )
                                      ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                           'FMMONTH,YYYY'
                          )
                      ) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                OR DECODE (p_param_date, 3, 0, 1) = 1
               )
           AND (   (   TRUNC (NVL (b140.acct_ent_date, b250.acct_ent_date))
                          BETWEEN p_from_date
                              AND p_to_date           --nvl added by VJ 120109
                    OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                          BETWEEN p_from_date
                              AND p_to_date
                   )
                OR DECODE (p_param_date, 4, 0, 1) = 1
               )
    /* AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
                                     b250.line_cd,
                         b250.subline_cd,
                      b250.iss_cd,
                      b250.issue_yy,
                      b250.pol_seq_no,
                      b250.renew_no,
                      p_param_date,
                      p_from_date,
                      p_to_date),1) = 1 */     --feb 1
--     AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
           AND b250.line_cd = a100.line_cd
           AND b250.line_cd = a100.line_cd
           --AND b300.iss_cd = b400.iss_cd  --- msj 12.20.06
           --AND b300.prem_seq_no = b400.prem_seq_no --ms j 12.20.06
           AND b250.policy_id =
                  b140.policy_id
                       --- added gipi_invoice 12.20.06 ms j to get currency_rt
           AND b140.iss_cd = b300.iss_cd
           AND b140.prem_seq_no = b300.prem_seq_no
           AND b140.iss_cd = b400.iss_cd
           AND b140.prem_seq_no = b400.prem_seq_no
           AND b250.policy_id =
                  b300.policy_id
                       --- added gipi_invoice 12.20.06 ms j to get currency_rt
           AND NVL (b250.endt_type, 'A') = 'A'
           AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
           AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
           AND b250.iss_cd <> giacp.v ('RI_ISS_CD')
           --AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
           AND DECODE (p_parameter, 1, b250.cred_branch, b250.iss_cd) =
                  NVL (p_iss_cd,
                       DECODE (p_parameter, 1, b250.cred_branch, b250.iss_cd)
                      )
      GROUP BY b250.line_cd,
               b250.subline_cd,
               a100.line_name,
               a300.peril_sname,
               a300.peril_name,
               a400.intm_name,
               a300.peril_cd,
               a300.peril_type,
               a400.intm_no,
               --b250.acct_ent_date,
               b140.acct_ent_date,                                     --glyza
               b250.spld_acct_ent_date,
               b250.policy_id,
               b250.iss_cd,
               b250.endt_seq_no,
               b250.cred_branch;

      IF v_policy_id.EXISTS (1)
      THEN
         --if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4
               THEN
                  IF     TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                     AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                                AND p_to_date
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date
                  THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP;                              -- for idx in 1 .. v_pol_count
      END IF;                                       --if v_policy_id.exists(1)

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd, subline_cd,
                         iss_cd, line_name, tsi_amt,
                         prem_amt, policy_id,
                         peril_cd, peril_sname,
                         peril_name, peril_type,
                         intm_no, intm_name, param_date,
                         from_date, TO_DATE, SCOPE, user_id,
                         endt_seq_no, cred_branch
                        )
                 VALUES (v_line_cd (cnt), v_subline_cd (cnt),
                         v_iss_cd (cnt), v_line_name (cnt), v_tsi_amt (cnt),
                         v_prem_amt (cnt), v_policy_id (cnt),
                         v_peril_cd (cnt), v_peril_sname (cnt),
                         v_peril_name (cnt), v_peril_type (cnt),
                         v_intm_no (cnt), v_intm_name (cnt), p_param_date,
                         p_from_date, p_to_date, p_scope, p_user,
                         v_endt_seq_no (cnt), v_cred_branch (cnt)
                        );
         COMMIT;
      END IF;                                            --end of if sql%found
   END;                                                 --extract tab 4 direct

   PROCEDURE extract_tab4_ri (
      p_scope         IN   NUMBER,
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2
   )
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;

      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      v_cred_branch          v_cred_branch_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_line_name            v_line_name_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_peril_sname          v_peril_sname_tab;
      v_peril_name           v_peril_name_tab;
      v_intm_name            v_intm_name_tab;
      v_peril_cd             v_peril_cd_tab;
      v_peril_type           v_peril_type_tab;
      v_intm_no              v_intm_no_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_policy_id            v_policy_id_tab;
      v_iss_cd               v_iss_cd_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_multiplier           NUMBER                   := 1;
   BEGIN
      SELECT b250.line_cd, b250.subline_cd, a100.line_name,
             b400.tsi_amt * b140.currency_rt,
             b400.prem_amt * b140.currency_rt, a300.peril_sname,
             a300.peril_name, NULL, a300.peril_cd, a300.peril_type, NULL,
             b140.acct_ent_date,                         --b250.acct_ent_date,
                                b250.spld_acct_ent_date, b250.policy_id,
             b250.iss_cd, b250.endt_seq_no, b250.cred_branch
      BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name,
             v_tsi_amt,
             v_prem_amt, v_peril_sname,
             v_peril_name, v_intm_name, v_peril_cd, v_peril_type, v_intm_no,
             v_acct_ent_date, v_spld_acct_ent_date, v_policy_id,
             v_iss_cd, v_endt_seq_no, v_cred_branch
        FROM gipi_polbasic b250,
             gipi_invoice b140,
             gipi_invperil b400,
             giis_line a100,
             giis_peril a300
       WHERE 1 = 1
         AND b250.reg_policy_sw =
                          DECODE (p_special_pol,
                                  'Y', b250.reg_policy_sw,
                                  'Y'
                                 )
         AND (b250.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1
             )
         AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1
             )
         AND (   LAST_DAY
                    (TO_DATE
                        (
                                    --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                            --b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
                            NVL (b140.multi_booking_mm, b250.booking_mth)
                         || ','
                         || TO_CHAR (NVL (b140.multi_booking_yy,
                                          b250.booking_year
                                         )
                                    ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                         'FMMONTH,YYYY'
                        )
                    ) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1
             )
         AND (   (   TRUNC (b140.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL
                        (TRUNC (b140.spoiled_acct_ent_date), p_to_date + 1)
                                -- aaron used gipi invoice instead of polbasic
                        BETWEEN p_from_date
                            AND p_to_date
                 )
              OR DECODE (p_param_date, 4, 0, 1) = 1
             )
         AND DECODE (b250.pol_flag,
                     '4', check_date (p_scope,
                                      b250.line_cd,
                                      b250.subline_cd,
                                      b250.iss_cd,
                                      b250.issue_yy,
                                      b250.pol_seq_no,
                                      b250.renew_no,
                                      p_param_date,
                                      p_from_date,
                                      p_to_date
                                     ),
                     1
                    ) = 1
         AND b400.peril_cd = a300.peril_cd
         AND a300.line_cd = b250.line_cd
         AND b250.line_cd = a100.line_cd
         AND b250.policy_id =
                b140.policy_id
                       --- added gipi_invoice 12.20.06 ms j to get currency_rt
         AND b140.iss_cd = b400.iss_cd
         AND b140.prem_seq_no =
                b400.prem_seq_no
                       --- added gipi_invoice 12.20.06 ms j to get currency_rt
         --         and b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
         AND NVL (b250.endt_type, 'A') = 'A'
         AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
         AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
         AND b250.iss_cd = giacp.v ('RI_ISS_CD')
         AND b250.cred_branch = NVL (p_iss_cd, b250.cred_branch);

      IF v_policy_id.EXISTS (1)
      THEN
         --if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4
               THEN
                  IF     TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                     AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                                AND p_to_date
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date
                  THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP;                              -- for idx in 1 .. v_pol_count
      END IF;                                       --if v_policy_id.exists(1)

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd, subline_cd,
                         iss_cd, line_name, tsi_amt,
                         prem_amt, policy_id,
                         peril_cd, peril_sname,
                         peril_name, peril_type,
                         intm_no, intm_name, param_date,
                         from_date, TO_DATE, SCOPE, user_id,
                         endt_seq_no, cred_branch
                        )
                 VALUES (v_line_cd (cnt), v_subline_cd (cnt),
                         v_iss_cd (cnt), v_line_name (cnt), v_tsi_amt (cnt),
                         v_prem_amt (cnt), v_policy_id (cnt),
                         v_peril_cd (cnt), v_peril_sname (cnt),
                         v_peril_name (cnt), v_peril_type (cnt),
                         v_intm_no (cnt), v_intm_name (cnt), p_param_date,
                         p_from_date, p_to_date, p_scope, p_user,
                         v_endt_seq_no (cnt), v_cred_branch (cnt)
                        );
         COMMIT;
      END IF;                                           -- end of if sql%found
   END;                                                     --extract tab 4 ri

   PROCEDURE extract_tab5 (
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_scope         IN   NUMBER,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_assd          IN   NUMBER,
      p_intm          IN   NUMBER,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2,
      p_intm_type     IN   VARCHAR2
   )                                                                     --jen
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_evatprem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_fst_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_lgt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_doc_stamps_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_taxes_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_charges_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_intm_type_tab IS TABLE OF giis_intermediary.intm_type%TYPE;
                                                                        --jen

      TYPE v_premium_share_amt_tab IS TABLE OF gipi_comm_invoice.premium_amt%TYPE;
                                                             -- rose 09222009

      v_cred_branch          v_cred_branch_tab;
      v_policy_id            v_policy_id_tab;
      v_assd_name            v_assd_name_tab;
      v_issue_date           v_issue_date_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_iss_cd               v_iss_cd_tab;
      v_issue_yy             v_issue_yy_tab;
      v_pol_seq_no           v_pol_seq_no_tab;
      v_renew_no             v_renew_no_tab;
      v_endt_iss_cd          v_endt_iss_cd_tab;
      v_endt_yy              v_endt_yy_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_incept_date          v_incept_date_tab;
      v_expiry_date          v_expiry_date_tab;
      v_line_name            v_line_name_tab;
      v_subline_name         v_subline_name_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_intm_name            v_intm_name_tab;
      v_assd_no              v_assd_no_tab;
      v_intm_no              v_intm_no_tab;
      v_evatprem             v_evatprem_tab;
      v_fst                  v_fst_tab;
      v_lgt                  v_lgt_tab;
      v_doc_stamps           v_doc_stamps_tab;
      v_other_taxes          v_other_taxes_tab;
      v_other_charges        v_other_charges_tab;
      v_multiplier           NUMBER                   := 1;
      v_intm_type            v_intm_type_tab;                           --jen
      v_prem_share_amt       v_premium_share_amt_tab;         --rose 09222009
      --lems 06.08.2009
      v_count                NUMBER;
      v_layout               NUMBER        := giisp.n ('PROD_REPORT_EXTRACT');
   BEGIN
      DELETE FROM gipi_uwreports_intm_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 5 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (5, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, p_assd, p_intm, USER, SYSDATE,
                   NULL
                  );

      COMMIT;

      SELECT DISTINCT gp.policy_id gp_policy_id, ga.assd_name ga_assd_name,
                      TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
                      gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
                      gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
                      gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
                      gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
                      gp.endt_seq_no gp_endt_seq_no,
                      TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
                      TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
                      gl.line_name gl_line_name,
                      gs.subline_name gs_subline_name,
                      --gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
                      SUM (gp.tsi_amt) gp_tsi_amt,
                      SUM (c.prem_amt * c.currency_rt) gp_prem_amt,    --glyza
                      --  SUM(gpd.tsi_amt) gp_tsi_amt, SUM(gpd.prem_amt) gp_prem_amt, --glyza  -- comment out by aaron 102609
                      c.acct_ent_date,
                      --gp.acct_ent_date gp_acct_ent_date,
                      gp.spld_acct_ent_date gp_spld_acct_ent_date,
                      b.intm_name gp_intm_name, a.assd_no,
                      gci.intrmdry_intm_no intm_no, NULL, NULL, NULL, NULL,
                      NULL, NULL, gp.cred_branch,
                      b.intm_type                                        --jen
                                 ,
                      SUM (gci.premium_amt) gci_premium_amt             --rose
      BULK COLLECT INTO v_policy_id, v_assd_name,
                      v_issue_date,
                      v_line_cd, v_subline_cd,
                      v_iss_cd, v_issue_yy,
                      v_pol_seq_no, v_renew_no,
                      v_endt_iss_cd, v_endt_yy,
                      v_endt_seq_no,
                      v_incept_date,
                      v_expiry_date,
                      v_line_name,
                      v_subline_name,
                      v_tsi_amt,
                      v_prem_amt,
                      v_acct_ent_date,
                      v_spld_acct_ent_date,
                      v_intm_name, v_assd_no,
                      v_intm_no, v_evatprem, v_fst, v_lgt, v_doc_stamps,
                      v_other_taxes, v_other_charges, v_cred_branch,
                      v_intm_type,
                      v_prem_share_amt
                 FROM gipi_polbasic gp,
                      gipi_parlist a,
                      giis_line gl,
                      giis_subline gs,
                      giis_issource gi,
                      giis_assured ga,
                      gipi_comm_invoice gci,
                      giis_intermediary b,
                      gipi_invoice c                                       --,
                -- GIUW_POL_DIST gpd --gly  -- comment out by aaron 102609
      WHERE           1 = 1
                  AND c.policy_id = gp.policy_id                           --i
                  AND gp.reg_policy_sw =
                            DECODE (p_special_pol,
                                    'Y', gp.reg_policy_sw,
                                    'Y'
                                   )
                  AND gci.intrmdry_intm_no =
                                            NVL (p_intm, gci.intrmdry_intm_no)
                  AND ga.assd_no = NVL (p_assd, ga.assd_no)
                  AND (gp.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) =
                                                                             1
                      )
                  AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
                       OR DECODE (p_param_date, 1, 0, 1) = 1
                      )
                  AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
                       OR DECODE (p_param_date, 2, 0, 1) = 1
                      )
                  AND (   LAST_DAY
                             (TO_DATE
                                 (
                                     --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                                     NVL (c.multi_booking_mm, gp.booking_mth)
                                  || ','
                                  || TO_CHAR (NVL (c.multi_booking_yy,
                                                   gp.booking_year
                                                  )
                                             ),
                        --glyza; added nvl by VJ 111909 to resolve ora-01843--
                                  'FMMONTH,YYYY'
                                 )
                             ) BETWEEN LAST_DAY (p_from_date)
                                   AND LAST_DAY (p_to_date)
                       OR DECODE (p_param_date, 3, 0, 1) = 1
                      )
                  AND (   (   TRUNC (c.acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                           OR NVL (TRUNC (gp.spld_acct_ent_date),
                                   p_to_date + 1
                                  ) BETWEEN p_from_date AND p_to_date
                          )
                       OR DECODE (p_param_date, 4, 0, 1) = 1
                      )
/* AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
                 gp.line_cd,
                  gp.subline_cd,
              gp.iss_cd,
              gp.issue_yy,
              gp.pol_seq_no,
              gp.renew_no,
              p_param_date,
              p_from_date,
              p_to_date),1) = 1 */   --feb 1
                  AND gp.line_cd = gl.line_cd
                  AND gci.intrmdry_intm_no >= 0
                  AND gp.policy_id = gci.policy_id
                  AND b.intm_no = gci.intrmdry_intm_no
                  AND a.par_id = gp.par_id
                  AND gp.subline_cd = gs.subline_cd
                  AND gl.line_cd = gs.line_cd
                  AND ga.assd_no = a.assd_no
                  AND gp.iss_cd = gi.iss_cd
                  --AND gp.reg_policy_sw        = decode(p_special_pol,'Y',gp.reg_policy_sw,'Y')
                  AND NVL (gp.endt_type, 'A') = 'A'
                  AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
                  AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
                  AND gp.iss_cd <> giacp.v ('RI_ISS_CD')
                  --AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd)
                  AND DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                         NVL (p_iss_cd,
                              DECODE (p_parameter,
                                      1, gp.cred_branch,
                                      gp.iss_cd
                                     )
                             )
                  AND b.intm_type = NVL (p_intm_type, b.intm_type)       --jen
                  --glyza 05.30.08--
                  AND c.prem_seq_no = gci.prem_seq_no
             --  AND gpd.POLICY_ID= gp.policy_id
             --  AND NVL(gpd.takeup_seq_no,1) = NVL(c.takeup_seq_no,1)
             --  AND NVL(gpd.item_grp,1) = NVL(c.item_grp,1) --
      GROUP BY        gp.policy_id,
                      ga.assd_name,
                      gp.issue_date,
                      gp.line_cd,
                      gp.subline_cd,
                      gp.iss_cd,
                      gp.issue_yy,
                      gp.pol_seq_no,
                      gp.renew_no,
                      gp.endt_iss_cd,
                      gp.endt_yy,
                      gp.endt_seq_no,
                      gp.incept_date,
                      gp.expiry_date,
                      gl.line_name,
                      gs.subline_name,
                      c.acct_ent_date,
                      gp.spld_acct_ent_date,
                      b.intm_name,
                      a.assd_no,
                      gci.intrmdry_intm_no,
                      gp.cred_branch,
                      b.intm_type;

--------------------------------gly
      IF v_policy_id.EXISTS (1)
      THEN
         --if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4
               THEN
                  IF     TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                     AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                                AND p_to_date
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date
                  THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_evat
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND (   git.tax_cd = giacp.n ('EVAT')
                              OR git.tax_cd = giacp.n ('5PREM_TAX')
                             )
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_evatprem (idx) := NVL (c.gparam_evat, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt
                                 ) gparam_prem_tax
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('FST')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_fst (idx) := NVL (c.gparam_prem_tax, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_lgt
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('LGT')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_lgt (idx) := NVL (c.gparam_lgt, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt
                                 ) gparam_doc_stamps
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('DOC_STAMPS')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_doc_stamps (idx) :=
                                   NVL (c.gparam_doc_stamps, 0)
                                   * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR d IN
               (SELECT SUM (NVL (git.tax_amt, 0) * giv.currency_rt
                           ) git_otax_amt
                  FROM gipi_inv_tax git, gipi_invoice giv
                 WHERE giv.iss_cd = git.iss_cd
                   AND giv.prem_seq_no = git.prem_seq_no
                   AND giv.policy_id = v_policy_id (idx)
                   AND NOT EXISTS (
                          SELECT gp.param_value_n
                            FROM giac_parameters gp
                           WHERE gp.param_name IN
                                    ('EVAT', '5PREM_TAX', 'LGT', 'DOC_STAMPS',
                                     'FST')
                             AND gp.param_value_n = git.tax_cd))
            LOOP
               v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
            END LOOP;                                            -- for d in..

            FOR e IN (SELECT SUM (NVL (giv.other_charges, 0) * giv.currency_rt
                                 ) giv_otax_amt
                        FROM gipi_invoice giv
                       WHERE giv.policy_id = v_policy_id (idx))
            LOOP
               v_other_charges (idx) := NVL (e.giv_otax_amt, 0)
                                        * v_multiplier;
            END LOOP;                                            --for e in...
         END LOOP;                              -- for idx in 1 .. v_pol_count
      END IF;                                       --if v_policy_id.exists(1)

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_intm_ext
                        (assd_name, line_cd,
                         line_name, subline_cd,
                         subline_name, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date,
                         expiry_date,
                         total_tsi, total_prem,
                         evatprem, fst, lgt,
                         doc_stamps, other_taxes,
                         other_charges, param_date, from_date,
                         TO_DATE, SCOPE, user_id, policy_id,
                         intm_name, assd_no,
                         intm_no,
                         issue_date,
                         cred_branch, intm_type,
                         prem_share_amt /*rose*/
                        )                                                --jen
                 VALUES (v_assd_name (cnt), v_line_cd (cnt),
                         v_line_name (cnt), v_subline_cd (cnt),
                         v_subline_name (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_tsi_amt (cnt), v_prem_amt (cnt),
                         v_evatprem (cnt), v_fst (cnt), v_lgt (cnt),
                         v_doc_stamps (cnt), v_other_taxes (cnt),
                         v_other_charges (cnt), p_param_date, p_from_date,
                         p_to_date, p_scope, p_user, v_policy_id (cnt),
                         v_intm_name (cnt), v_assd_no (cnt),
                         v_intm_no (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
                         v_cred_branch (cnt), v_intm_type (cnt),
                         v_prem_share_amt (cnt) /*rose*/
                        );                                              --jen)

         --lems 06.08.2009 START
         SELECT COUNT (policy_id)
           INTO v_count
           FROM gipi_uwreports_intm_ext
          WHERE user_id = USER;

         IF v_count > 0
         THEN
            DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS'));

            FOR x IN
               (SELECT a.policy_id, NVL (b.item_grp, 1) item_grp,
                       NVL (b.takeup_seq_no, 1) takeup_seq_no
                                              --lems for verification with VJ
                  FROM gipi_uwreports_intm_ext a,
                       gipi_invoice b,
                       gipi_polbasic c
                 WHERE a.policy_id = b.policy_id
                   AND c.policy_id = a.policy_id
                   AND (c.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) =
                                                                             1
                       )
                   AND (   TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 1, 0, 1) = 1
                       )
                   AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 2, 0, 1) = 1
                       )
                   AND (   LAST_DAY
                              (TO_DATE
                                  (
                                      --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                                      --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
                                      NVL (b.multi_booking_mm, c.booking_mth)
                                   || ','
                                   || TO_CHAR (NVL (b.multi_booking_yy,
                                                    c.booking_year
                                                   )
                                              ),
                                 --added nvl by jess 111909 to avoid ora-01843
                                   'FMMONTH,YYYY'
                                  )
                              ) BETWEEN LAST_DAY (p_from_date)
                                    AND LAST_DAY (p_to_date)
                        OR DECODE (p_param_date, 3, 0, 1) = 1
                       )
                   AND (   (TRUNC (c.acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                           )
                        OR DECODE (p_param_date, 4, 0, 1) = 1
                       )
                   AND NVL (TRUNC (c.spld_acct_ent_date), p_to_date + 1) NOT
                          BETWEEN p_from_date
                              AND p_to_date    --lems for verification with VJ
                   AND a.user_id = USER)
            LOOP
               --P_Uwreports.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id);
               IF v_layout = 2
               THEN
                  FOR j IN
                     (SELECT a.tax_cd
                        FROM gipi_inv_tax a, gipi_invoice b
                       WHERE a.prem_seq_no = b.prem_seq_no
                         AND a.iss_cd = b.iss_cd
                         AND b.policy_id = x.policy_id
                         AND NVL (b.item_grp, 1) = x.item_grp
                         AND NVL (b.takeup_seq_no, 1) = x.takeup_seq_no)
                                               --lems for verification with VJ
                  LOOP
                     DBMS_OUTPUT.put_line (   j.tax_cd
                                           || '/'
                                           || x.takeup_seq_no
                                           || '/'
                                           || x.item_grp
                                           || '/'
                                           || x.policy_id
                                          );
                     do_ddl
                        (   'MERGE INTO GIPI_UWREPORTS_INTM_EXT gpp USING'
                         || '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'
                         || '           giv.policy_id, P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                         || p_scope
                         || ', '
                         || p_param_date
                         || ', '''
                         || p_from_date
                         || ''', '''
                         || p_to_date
                         || ''', '
                         || x.policy_id
                         || ') comm_amt'
                         || '          ,gpp.user_id'
                         || '          FROM GIPI_INV_TAX git,'
                         || '           GIPI_INVOICE giv,'
                         || '           GIPI_UWREPORTS_INTM_EXT gpp'
                         || '     WHERE giv.iss_cd       = git.iss_cd'
                         || '       AND giv.prem_seq_no  = git.prem_seq_no'
                         || '       AND git.tax_cd       >= 0'
                         || '       AND giv.item_grp     = git.item_grp'
                         || '       AND giv.policy_id    = gpp.policy_id'
                         || '       AND gpp.user_id      = USER'
                         || '       AND git.tax_cd       = '
                         || j.tax_cd
                         || '       AND NVL(giv.takeup_seq_no,1)  = '
                         || x.takeup_seq_no
                         || '       AND NVL(giv.item_grp,1)    = '
                         || x.item_grp
                         || '       AND giv.policy_id = '
                         || x.policy_id
                         || '     GROUP BY giv.policy_id, P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '
                         || p_scope
                         || ', '
                         || p_param_date
                         || ', '''
                         || p_from_date
                         || ''', '''
                         || p_to_date
                         || ''', '
                         || x.policy_id
                         || '),gpp.user_id) subq'
                         || '        ON (subq.policy_id = gpp.policy_id '
                         || '            AND subq.user_id = gpp.user_id )'
                         || '      WHEN MATCHED THEN UPDATE'
                         || '        SET gpp.tax'
                         || j.tax_cd
                         || ' = subq.tax_amt + NVL(gpp.tax'
                         || j.tax_cd
                         || ',0)'
                         || '           ,gpp.comm_amt = subq.comm_amt'
                         || '      WHEN NOT MATCHED THEN'
                         || '        INSERT (tax'
                         || j.tax_cd
                         || ',policy_id, comm_amt)'
                         || '        VALUES (subq.tax_amt,subq.policy_id, subq.comm_amt)'
                        );                     --lems for verification with VJ
                  --COMMIT;
                  END LOOP;

                  --other charges
                  MERGE INTO gipi_uwreports_intm_ext gpp
                     USING (SELECT   SUM
                                        (NVL (  giv.other_charges
                                              * giv.currency_rt,
                                              0
                                             )
                                        ) other_charges,
                                     giv.policy_id policy_id,
                                     p_uwreports.get_comm_amt
                                                   (giv.prem_seq_no,
                                                    giv.iss_cd,
                                                    p_scope,
                                                    p_param_date,
                                                    p_from_date,
                                                    p_to_date,
                                                    giv.policy_id
                                                   ) comm_amt,
                                     gpp.user_id
                                FROM gipi_invoice giv,
                                     gipi_uwreports_intm_ext gpp
                               WHERE 1 = 1
                                 AND giv.policy_id = gpp.policy_id
                                 AND gpp.user_id = USER
                                 AND giv.takeup_seq_no = x.takeup_seq_no
                                 AND giv.item_grp = x.item_grp
                                 AND giv.policy_id = x.policy_id
                            GROUP BY giv.policy_id,
                                     p_uwreports.get_comm_amt
                                                             (giv.prem_seq_no,
                                                              giv.iss_cd,
                                                              p_scope,
                                                              p_param_date,
                                                              p_from_date,
                                                              p_to_date,
                                                              giv.policy_id
                                                             ),
                                     gpp.user_id) goc
                     ON (    goc.policy_id = gpp.policy_id
                         AND goc.user_id = gpp.user_id)
                     WHEN MATCHED THEN
                        UPDATE
                           SET gpp.other_charges =
                                    goc.other_charges
                                  + NVL (gpp.other_charges, 0),
                               gpp.comm_amt = goc.comm_amt
                     WHEN NOT MATCHED THEN
                        INSERT (other_charges, policy_id, comm_amt)
                        VALUES (goc.other_charges, goc.policy_id,
                                goc.comm_amt);
               --COMMIT;
               END IF;
            END LOOP;
         END IF;

         --lems 06.08.2009 END
         COMMIT;
      END IF;                                            --end of if sql%found
   END;                                                        --extract tab 5

   PROCEDURE extract_tab8 (
      p_param_date    IN   NUMBER,
      p_from_date     IN   DATE,
      p_to_date       IN   DATE,
      p_scope         IN   NUMBER,
      p_iss_cd        IN   VARCHAR2,
      p_line_cd       IN   VARCHAR2,
      p_subline_cd    IN   VARCHAR2,
      p_user          IN   VARCHAR2,
      p_ri            IN   NUMBER,
      p_parameter     IN   NUMBER,
      p_special_pol   IN   VARCHAR2
   )
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_evatprem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_fst_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_lgt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_doc_stamps_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_taxes_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_charges_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_ri_name_tab IS TABLE OF giis_reinsurer.ri_name%TYPE;

      TYPE v_ri_cd_tab IS TABLE OF giri_inpolbas.ri_cd%TYPE;

      TYPE v_input_vat_rate_tab IS TABLE OF giis_reinsurer.input_vat_rate%TYPE;

      -- aaron 061109 for long term
      TYPE v_ri_comm_amt_tab IS TABLE OF gipi_invoice.ri_comm_amt%TYPE;

      TYPE v_ri_comm_vat_tab IS TABLE OF gipi_invoice.ri_comm_vat%TYPE;

      -- aaron 061109 for long term
      v_cred_branch          v_cred_branch_tab;
      v_policy_id            v_policy_id_tab;
      v_assd_name            v_assd_name_tab;
      v_issue_date           v_issue_date_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_iss_cd               v_iss_cd_tab;
      v_issue_yy             v_issue_yy_tab;
      v_pol_seq_no           v_pol_seq_no_tab;
      v_renew_no             v_renew_no_tab;
      v_endt_iss_cd          v_endt_iss_cd_tab;
      v_endt_yy              v_endt_yy_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_incept_date          v_incept_date_tab;
      v_expiry_date          v_expiry_date_tab;
      v_line_name            v_line_name_tab;
      v_subline_name         v_subline_name_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_intm_name            v_intm_name_tab;
      v_assd_no              v_assd_no_tab;
      v_intm_no              v_intm_no_tab;
      v_evatprem             v_evatprem_tab;
      v_fst                  v_fst_tab;
      v_lgt                  v_lgt_tab;
      v_doc_stamps           v_doc_stamps_tab;
      v_other_taxes          v_other_taxes_tab;
      v_other_charges        v_other_charges_tab;
      v_multiplier           NUMBER                   := 1;
      v_ri_name              v_ri_name_tab;
      v_ri_cd                v_ri_cd_tab;
      v_input_vat_rate       v_input_vat_rate_tab;
      -- aaron 061109 for long term
      v_ri_comm_amt          v_ri_comm_amt_tab;
      v_ri_comm_vat          v_ri_comm_vat_tab;
      -- aaron 061109 for long term

      --lems 05.21.2009
      v_count                NUMBER;
      v_layout               NUMBER        := giisp.n ('PROD_REPORT_EXTRACT');
   BEGIN
      DELETE FROM gipi_uwreports_inw_ri_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
         ** to store user's parameter in a table*/
      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 8 AND user_id = USER;

      INSERT INTO gipi_uwreports_param
                  (tab_number, SCOPE, param_date, from_date, TO_DATE,
                   iss_cd, line_cd, subline_cd, iss_param,
                   special_pol, assd_no, intm_no, user_id, last_extract,
                   ri_cd
                  )
           VALUES (8, p_scope, p_param_date, p_from_date, p_to_date,
                   p_iss_cd, p_line_cd, p_subline_cd, p_parameter,
                   p_special_pol, NULL, NULL, USER, SYSDATE,
                   p_ri
                  );

      COMMIT;

      SELECT   gp.policy_id gp_policy_id,
               TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
               gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
               gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
               gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
               gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
               gp.endt_seq_no gp_endt_seq_no,
               TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
               TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
               gl.line_name gl_line_name, gs.subline_name gs_subline_name,
               --gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
               --SUM(gpd.tsi_amt) gp_tsi_amt,
               gp.tsi_amt gp_tsi_amt,
                       -- added by VJ 082009; --added currency rt by VJ 120109
               -- SUM(gp.prem_amt) gp_prem_amt, --gly
               SUM (gi.prem_amt * gi.currency_rt) gp_prem_amt,
                                     --aaron; --added currency rt by VJ 120109
               NVL (gi.acct_ent_date, gp.acct_ent_date),         --vcm 100709,
               --gp.acct_ent_date gp_acct_ent_date,
               gp.spld_acct_ent_date gp_spld_acct_ent_date, NULL, NULL, NULL,
               NULL, NULL, NULL, gr.ri_name gr_ri_name,
               c.ri_cd ri_cd, NVL (gp.cred_branch, gp.iss_cd) cred_branch,
               gr.input_vat_rate input_vat_rate,
               -- aaron 061109 for long term
               gi.ri_comm_amt * gi.currency_rt ri_comm_amt,
                                              --added currency rt by VJ 120109
               gi.ri_comm_vat * gi.currency_rt ri_comm_vat
                                              --added currency rt by VJ 120109
      -- aaron 061109 for long term
      BULK COLLECT INTO v_policy_id,
               v_issue_date,
               v_line_cd, v_subline_cd,
               v_iss_cd, v_issue_yy,
               v_pol_seq_no, v_renew_no,
               v_endt_iss_cd, v_endt_yy,
               v_endt_seq_no,
               v_incept_date,
               v_expiry_date,
               v_line_name, v_subline_name,
               v_tsi_amt,
               v_prem_amt,
               v_acct_ent_date,
               v_spld_acct_ent_date, v_evatprem, v_fst, v_lgt,
               v_doc_stamps, v_other_taxes, v_other_charges, v_ri_name,
               v_ri_cd, v_cred_branch,
               v_input_vat_rate,
               -- aaron 061109 for long term
               v_ri_comm_amt,
               v_ri_comm_vat
          -- aaron 061109 for long term
      FROM     gipi_polbasic gp,
               giis_line gl,
               giis_subline gs,
               giis_reinsurer gr,
               giri_inpolbas c,
               gipi_invoice gi
         --,GIUW_POL_DIST gpd --glyza --comment by VJ 082009
      WHERE    1 = 1
           AND gp.policy_id = c.policy_id
           AND gi.policy_id = gp.policy_id                                 --i
           AND gp.line_cd = gl.line_cd
           AND gp.subline_cd = gs.subline_cd
           AND gp.line_cd = gs.line_cd
           AND gr.ri_cd = c.ri_cd
            --comment conditions below, VJ 082009--
           /* --------glyza 05.30.08--------
            AND gpd.policy_id = gp.policy_id
            AND NVL(gpd.item_grp,1) = NVL(gi.item_grp,1)
            AND NVL(gpd.takeup_seq_no,1) = NVL(gi.takeup_seq_no,1)
            ------------------------------*/
           AND gp.reg_policy_sw =
                            DECODE (p_special_pol,
                                    'Y', gp.reg_policy_sw,
                                    'Y'
                                   )
           --AND gp.reg_policy_sw        = decode(p_special_pol,'Y',gp.reg_policy_sw,'Y')
           AND NVL (gp.endt_type, 'A') = 'A'
           AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
           AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
           AND gp.iss_cd = 'RI'
           AND c.ri_cd = NVL (p_ri, c.ri_cd)
           AND (gp.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) = 1)
           AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 1, 0, 1) = 1
               )
           AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 2, 0, 1) = 1
               )
           AND (   LAST_DAY
                      (TO_DATE
                          (
                                     --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                              --gi.multi_booking_mm || ',' || TO_CHAR (gi.multi_booking_yy),
                              NVL (gi.multi_booking_mm, gp.booking_mth)
                           || ','
                           || TO_CHAR (NVL (gi.multi_booking_yy,
                                            gp.booking_year
                                           )
                                      ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                           'FMMONTH,YYYY'
                          )
                      ) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                OR DECODE (p_param_date, 3, 0, 1) = 1
               )
           AND (   (   TRUNC (NVL (gi.acct_ent_date, gp.acct_ent_date)) /*vcm 100709*/
                          BETWEEN p_from_date
                              AND p_to_date
                    OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                          BETWEEN p_from_date
                              AND p_to_date
                   )
                OR DECODE (p_param_date, 4, 0, 1) = 1
               )
      -----glyza 05.30.08 add group by clause---
      GROUP BY gp.policy_id,
               gp.issue_date,
               gp.line_cd,
               gp.subline_cd,
               gp.iss_cd,
               gp.issue_yy,
               gp.pol_seq_no,
               gp.renew_no,
               gp.endt_iss_cd,
               gp.endt_yy,
               gp.endt_seq_no,
               gp.incept_date,
               gp.expiry_date,
               gl.line_name,
               gs.subline_name,
               NVL (gi.acct_ent_date, gp.acct_ent_date), /*vcm 100709*/
               gp.spld_acct_ent_date,
               gr.ri_name,
               c.ri_cd,
               gp.cred_branch,
               input_vat_rate,
               gi.ri_comm_amt * gi.currency_rt,
               gi.ri_comm_vat * gi.currency_rt,
               gp.tsi_amt /*gp.tsi_amt*gi.currency_rt*/;
--altered by pjsantos 01/29/2014 altered gp.tsi_amt*gi.currency_rt with gp.tsi_amt, to correct printing of amounts in GIPIR928B-- aaro added ri com amm 061109, vj added tsi_amt 082009

      /*AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
                        gp.line_cd,
                        gp.subline_cd,
                       gp.iss_cd,
                       gp.issue_yy,
                       gp.pol_seq_no,
                       gp.renew_no,
                       p_param_date,
                       p_from_date,
                       p_to_date),1) = 1*/--; --comment by VJ 090307 as per Ms.J.Dela Cruz'z Advice.. :D --
      IF v_policy_id.EXISTS (1)
      THEN
         --if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4
               THEN
                  IF     TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                           AND p_to_date
                     AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                                AND p_to_date
                  THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date
                  THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date
                  THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
                  /*added by VJ and April para sa FPAC Dec EOM*/
                  v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier;
                  v_ri_comm_vat (idx) := v_ri_comm_vat (idx) * v_multiplier;
               END IF;
            END;

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_evat
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND (   git.tax_cd = giacp.n ('EVAT')
                              OR git.tax_cd = giacp.n ('5PREM_TAX')
                             )
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_evatprem (idx) := NVL (c.gparam_evat, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt
                                 ) gparam_prem_tax
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('FST')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_fst (idx) := NVL (c.gparam_prem_tax, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_lgt
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('LGT')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_lgt (idx) := NVL (c.gparam_lgt, 0) * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR c IN (SELECT SUM (git.tax_amt * giv.currency_rt
                                 ) gparam_doc_stamps
                        FROM gipi_inv_tax git, gipi_invoice giv
                       WHERE giv.iss_cd = git.iss_cd
                         AND giv.prem_seq_no = git.prem_seq_no
                         AND git.tax_cd >= 0
                         AND giv.item_grp = git.item_grp
                         AND git.tax_cd = giacp.n ('DOC_STAMPS')
                         AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_doc_stamps (idx) :=
                                   NVL (c.gparam_doc_stamps, 0)
                                   * v_multiplier;
            END LOOP;                                           -- for c in...

            FOR d IN
               (SELECT SUM (NVL (git.tax_amt, 0) * giv.currency_rt
                           ) git_otax_amt
                  FROM gipi_inv_tax git, gipi_invoice giv
                 WHERE giv.iss_cd = git.iss_cd
                   AND giv.prem_seq_no = git.prem_seq_no
                   AND giv.policy_id = v_policy_id (idx)
                   AND NOT EXISTS (
                          SELECT gp.param_value_n
                            FROM giac_parameters gp
                           WHERE gp.param_name IN
                                    ('EVAT', '5PREM_TAX', 'LGT', 'DOC_STAMPS',
                                     'FST')
                             AND gp.param_value_n = git.tax_cd))
            LOOP
               v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
            END LOOP;                                            -- for d in..

            FOR e IN (SELECT SUM (NVL (giv.other_charges, 0) * giv.currency_rt
                                 ) giv_otax_amt
                        FROM gipi_invoice giv
                       WHERE giv.policy_id = v_policy_id (idx))
            LOOP
               v_other_charges (idx) := NVL (e.giv_otax_amt, 0)
                                        * v_multiplier;
            END LOOP;                                            --for e in...
         END LOOP;                              -- for idx in 1 .. v_pol_count
      END IF;                                       --if v_policy_id.exists(1)

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_inw_ri_ext
                        (ri_cd, ri_name, line_cd,
                         line_name, subline_cd,
                         subline_name, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date,
                         expiry_date,
                         total_tsi, total_prem,
                         evatprem, fst, lgt,
                         doc_stamps, other_taxes,
                         other_charges, param_date, from_date,
                         TO_DATE, SCOPE, user_id, policy_id,
                         issue_date,
                         cred_branch, input_vat_rate,
                         ri_comm_amt, ri_comm_vat
                        )                        -- aaron 061109 for long term
                 VALUES (v_ri_cd (cnt), v_ri_name (cnt), v_line_cd (cnt),
                         v_line_name (cnt), v_subline_cd (cnt),
                         v_subline_name (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_tsi_amt (cnt), v_prem_amt (cnt),
                         v_evatprem (cnt), v_fst (cnt), v_lgt (cnt),
                         v_doc_stamps (cnt), v_other_taxes (cnt),
                         v_other_charges (cnt), p_param_date, p_from_date,
                         p_to_date, p_scope, p_user, v_policy_id (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
                         v_cred_branch (cnt), v_input_vat_rate (cnt),
                         v_ri_comm_amt (cnt), v_ri_comm_vat (cnt)
                        );                       -- aaron 061109 for long term

         --lems 05.21.2009 START
         SELECT COUNT (policy_id)
           INTO v_count
           FROM gipi_uwreports_inw_ri_ext
          WHERE user_id = USER;

         IF v_count > 0
         THEN
            DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS'));

            FOR x IN
               (SELECT a.policy_id, b.item_grp, b.takeup_seq_no
                  FROM gipi_uwreports_inw_ri_ext a,
                       gipi_invoice b,
                       gipi_polbasic c
                 WHERE a.policy_id = b.policy_id
                   AND c.policy_id = a.policy_id
                   AND (c.pol_flag != '5' OR DECODE (p_param_date, 4, 1, 0) =
                                                                             1
                       )
                   AND (   TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 1, 0, 1) = 1
                       )
                   AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 2, 0, 1) = 1
                       )
                   AND (   LAST_DAY
                              (TO_DATE
                                  (
                                      --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                                      --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
                                      NVL (b.multi_booking_mm, c.booking_mth)
                                   || ','
                                   || TO_CHAR (NVL (b.multi_booking_yy,
                                                    c.booking_year
                                                   )
                                              ),
                            -- added nvl by Jess 112009 to resolve ora-01843--
                                   'FMMONTH,YYYY'
                                  )
                              ) BETWEEN LAST_DAY (p_from_date)
                                    AND LAST_DAY (p_to_date)
                        OR DECODE (p_param_date, 3, 0, 1) = 1
                       )
                   AND (   (TRUNC (c.acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                           )
                        OR DECODE (p_param_date, 4, 0, 1) = 1
                       )
                   AND a.user_id = USER)
            LOOP
               --P_Uwreports.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id);
               IF v_layout = 2
               THEN
                  FOR j IN (SELECT a.tax_cd
                              FROM gipi_inv_tax a, gipi_invoice b
                             WHERE a.prem_seq_no = b.prem_seq_no
                               AND a.iss_cd = b.iss_cd
                               AND b.policy_id = x.policy_id
                               AND b.item_grp = x.item_grp
                               AND b.takeup_seq_no = x.takeup_seq_no)
                  LOOP
                     DBMS_OUTPUT.put_line (   j.tax_cd
                                           || '/'
                                           || x.takeup_seq_no
                                           || '/'
                                           || x.item_grp
                                           || '/'
                                           || x.policy_id
                                          );
                     do_ddl
                        (   'MERGE INTO GIPI_UWREPORTS_INW_RI_EXT gpp USING'
                         || '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'
                         || '           giv.policy_id, '
                         ||
--lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||') comm_amt'||
                            '           gpp.user_id'
                         || '          FROM GIPI_INV_TAX git,'
                         || '           GIPI_INVOICE giv,'
                         || '           GIPI_UWREPORTS_INW_RI_EXT gpp'
                         || '     WHERE giv.iss_cd       = git.iss_cd'
                         || '       AND giv.prem_seq_no  = git.prem_seq_no'
                         || '       AND git.tax_cd       >= 0'
                         || '       AND giv.item_grp     = git.item_grp'
                         || '       AND giv.policy_id    = gpp.policy_id'
                         || '       AND gpp.user_id      = USER'
                         || '       AND git.tax_cd       = '
                         || j.tax_cd
                         || '       AND giv.takeup_seq_no  = '
                         || x.takeup_seq_no
                         || '       AND giv.item_grp    = '
                         || x.item_grp
                         || '       AND giv.policy_id = '
                         || x.policy_id
                         || '     GROUP BY giv.policy_id, '
                         ||
--lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||')',
                            'gpp.user_id) subq'
                         || '        ON (subq.policy_id = gpp.policy_id '
                         || '            AND subq.user_id = gpp.user_id )'
                         || '      WHEN MATCHED THEN UPDATE'
                         || '        SET gpp.tax'
                         || j.tax_cd
                         || ' = subq.tax_amt + NVL(gpp.tax'
                         || j.tax_cd
                         || ',0)'
                         || 
                            --lems 07.09.2009 '           ,gpp.comm_amt = subq.comm_amt'||
                            '      WHEN NOT MATCHED THEN'
                         || '        INSERT (tax'
                         || j.tax_cd
                         || ',policy_id)'
                         ||                   --lems 07.09.2009 , comm_amt)'||
                            '        VALUES (subq.tax_amt,subq.policy_id)'
                        );               --lems 07.09.2009 , subq.comm_amt)');
                  --COMMIT;
                  END LOOP;

                  --other charges
                  MERGE INTO gipi_uwreports_inw_ri_ext gpp
                     USING (SELECT   SUM
                                        (NVL (  giv.other_charges
                                              * giv.currency_rt,
                                              0
                                             )
                                        ) other_charges,
                                     giv.policy_id policy_id
--lems 07.09.2009 , P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id) comm_amt
                                                            ,
                                     gpp.user_id
                                FROM gipi_invoice giv,
                                     gipi_uwreports_inw_ri_ext gpp
                               WHERE 1 = 1
                                 AND giv.policy_id = gpp.policy_id
                                 AND gpp.user_id = USER
                                 AND giv.takeup_seq_no = x.takeup_seq_no
                                 AND giv.item_grp = x.item_grp
                                 AND giv.policy_id = x.policy_id
                            GROUP BY giv.policy_id,
--lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id),
                                                   gpp.user_id) goc
                     ON (    goc.policy_id = gpp.policy_id
                         AND goc.user_id = gpp.user_id)
                     WHEN MATCHED THEN
                        UPDATE
                           SET gpp.other_charges =
                                    goc.other_charges
                                  + NVL (gpp.other_charges, 0)
                     --lems 07.03.2009 ,gpp.comm_amt = goc.comm_amt
                  WHEN NOT MATCHED THEN
                        INSERT (other_charges, policy_id)
                                                  --lems 07.03.2009, comm_amt)
                        VALUES (goc.other_charges, goc.policy_id);
                                             --lems 07.03.2009  goc.comm_amt);
               --COMMIT;
               END IF;
            END LOOP;
         END IF;

         --lems 05.21.2009 END
         COMMIT;
      END IF;                                            --end of if sql%found
   END;                                                        --extract tab 8

-- JHING 08/05/2011
-- ---Prodedure added by Anthony Santos Feb 2 2010 -------
--  PROCEDURE EDST
--   (p_scope        IN   NUMBER,
--    p_param_date   IN   NUMBER,
--    p_from_date    IN   DATE,
--    p_to_date      IN   DATE,
--    p_iss_cd       IN   VARCHAR2,
--    p_line_cd      IN   VARCHAR2,
--    p_subline_cd   IN   VARCHAR2,
--    p_user         IN   VARCHAR2,
--    p_parameter    IN   NUMBER,
--    p_special_pol  IN   VARCHAR2,
--    p_nonaff_endt  IN   VARCHAR2,
-- p_inc_negative IN   VARCHAR2) --param added rachelle 061808
--  AS
--    TYPE policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
--    TYPE total_tsi_tab          IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
--    TYPE total_prem_tab         IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
--    TYPE acct_ent_date_tab      IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
--    TYPE spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
--    TYPE spld_date_tab          IS TABLE OF GIPI_POLBASIC.spld_date%TYPE;
--    TYPE pol_flag_tab       IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
--    vv_policy_id         policy_id_tab;
--    vv_total_tsi         total_tsi_tab;
--    vv_total_prem         total_prem_tab;
--    vv_acct_ent_date       acct_ent_date_tab;
--    vv_spld_acct_ent_date     spld_acct_ent_date_tab;
--    vv_spld_date         spld_date_tab;
--    vv_pol_flag         pol_flag_tab;
--    v_multiplier                NUMBER := 1;
--    v_count          NUMBER;

   --  BEGIN
--    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START');
--    DELETE FROM GIPI_UWREPORTS_EXT
--          WHERE user_id = p_user;

   --    /* rollie 03JAN2004
--    ** to store user's parameter in a table*/
--    DELETE FROM GIPI_UWREPORTS_PARAM
--          WHERE tab_number  = 1
--            AND user_id     = USER;

   --    INSERT INTO GIPI_UWREPORTS_PARAM
--  (TAB_NUMBER, SCOPE,       PARAM_DATE, FROM_DATE,
--      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
--      ISS_PARAM,  SPECIAL_POL, ASSD_NO,    INTM_NO,
--      USER_ID,    LAST_EXTRACT,RI_CD )
--    VALUES
--     ( 1,      p_scope,    p_param_date,    p_from_date,
--      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
--      p_parameter, p_special_pol, NULL,      NULL,
--      USER,   SYSDATE,       NULL);

   --    COMMIT;

   -- IF p_inc_negative = 'Y' THEN
--    P_Uwreports.pol_gixx_pol_prod(p_scope,
--                   p_param_date,
--                   p_from_date,
--                   p_to_date,
--                   p_iss_cd,
--                   p_line_cd,
--                   p_subline_cd,
--                   p_user,
--                   p_parameter ,
--                   p_special_pol,
--                   p_nonaff_endt
--                   p_reinsated); --param added
--  ELSE
--    P_Uwreports.pol_gixx_pol_prod_bir(p_scope,
--                   p_param_date,
--                   p_from_date,
--                   p_to_date,
--                   p_iss_cd,
--                   p_line_cd,
--                   p_subline_cd,
--                   p_user,
--                   p_parameter ,
--                   p_special_pol,
--                   p_nonaff_endt,
--                p_inc_negative); --param added
-- END IF;

   --    SELECT COUNT(policy_id)
--      INTO v_count
--      FROM GIPI_UWREPORTS_EXT
--     WHERE user_id=USER;

   -- IF v_count > 0 THEN
--      DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
--   FOR x IN
--    (  SELECT  a.policy_id, b.item_grp ,b.takeup_seq_no
--            FROM GIPI_UWREPORTS_EXT a, GIPI_INVOICE b, GIPI_POLBASIC c
--           WHERE a.policy_id = b.policy_id
--             AND c.policy_id = a.policy_id
--             AND (   c.pol_flag != '5'
--                  OR DECODE (p_param_date, 4, 1, 0) = 1)
--             AND (   TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
--                  OR DECODE (p_param_date, 1, 0, 1) = 1)
--             AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
--                  OR DECODE (p_param_date, 2, 0, 1) = 1)
--             AND (   LAST_DAY (
--                    TO_DATE (
--                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
--                       --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
--         NVL(b.multi_booking_mm,c.booking_mth) || ',' || TO_CHAR (NVL(b.multi_booking_yy,c.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--
--                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
--                             AND LAST_DAY (p_to_date)
--                  OR DECODE (p_param_date, 3, 0, 1) = 1)
--             AND ((TRUNC(NVL(b.acct_ent_date,c.acct_ent_date))/*vcm 100709*/ BETWEEN p_from_date AND p_to_date)
--                  OR DECODE (p_param_date, 4, 0, 1) = 1)
--    AND a.user_id = USER --added by jason 10/17/2008
-- ) LOOP
--        P_Uwreports.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id, p_scope,p_param_date,p_from_date,p_to_date);
--   END LOOP;
--    END IF;

   --    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 2');

   -- IF v_count <> 0 AND p_param_date = 4 THEN
--      SELECT policy_id,
--             total_tsi,
--             total_prem,
--             acct_ent_date,
--             spld_acct_ent_date,
--             spld_date,
--             pol_flag
--        BULK COLLECT INTO
--             vv_policy_id,
--             vv_total_tsi,
--       vv_total_prem,
--       vv_acct_ent_date,
--       vv_spld_acct_ent_date,
--       vv_spld_date,
--       vv_pol_flag
--        FROM GIPI_UWREPORTS_EXT
--       WHERE user_id=USER;

   -- DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 3');

   --    FOR idx IN vv_policy_id.FIRST..vv_policy_id.LAST LOOP
--      IF (vv_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date)
--        AND (vv_spld_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date) THEN
--          vv_total_tsi(idx)  := 0;
--        vv_total_prem(idx) := 0;
--      ELSIF vv_spld_date(idx) BETWEEN p_from_date AND p_to_date
--        AND vv_pol_flag(idx) = '5' THEN
--      --issa10.02.2007 should not be multiplied to (-1), get value as is from table
--        vv_total_tsi(idx)  := vv_total_tsi(idx);
--        vv_total_prem(idx) := vv_total_prem(idx);
--     --issa10.02.2007 to prevent discrepancy in gipir923 and gipir923e
--        /*vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
--        vv_total_prem(idx) := vv_total_prem(idx) * (-1);*/
--      END IF;
--      vv_spld_date(idx) := NULL;
--    END LOOP;
-- DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 4');

   --    FORALL upd IN vv_policy_id.FIRST..vv_policy_id.LAST
--      UPDATE GIPI_UWREPORTS_EXT
--         SET total_tsi  = vv_total_tsi(upd),
--             total_prem = vv_total_prem(upd),
--             spld_date  = vv_spld_date(upd)
--       WHERE policy_id  = vv_policy_id(upd)
--         AND user_id    = USER;
----   END LOOP;
--      COMMIT;
--    END IF;
--    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 5');

   --    COMMIT;
--  END; --end procedure EDST

   ---Prodedure added by Alvin Tumlos 05.26.2010---
   PROCEDURE edst (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_parameter    IN   NUMBER
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE total_tsi_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE total_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE spld_date_tab IS TABLE OF gipi_polbasic.spld_date%TYPE;

      TYPE pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;

      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_cred_branch_param_tab IS TABLE OF edst_ext.cred_branch_param%TYPE;

      v_assd_no               v_assd_no_tab;
      v_policy_id             v_policy_id_tab;
      v_issue_date            v_issue_date_tab;
      v_line_cd               v_line_cd_tab;
      v_subline_cd            v_subline_cd_tab;
      v_iss_cd                v_iss_cd_tab;
      v_issue_yy              v_issue_yy_tab;
      v_pol_seq_no            v_pol_seq_no_tab;
      v_renew_no              v_renew_no_tab;
      v_endt_iss_cd           v_endt_iss_cd_tab;
      v_endt_yy               v_endt_yy_tab;
      v_endt_seq_no           v_endt_seq_no_tab;
      v_incept_date           v_incept_date_tab;
      v_expiry_date           v_expiry_date_tab;
      v_tsi_amt               v_tsi_amt_tab;
      v_prem_amt              v_prem_amt_tab;
      v_acct_ent_date         v_acct_ent_date_tab;
      v_spld_acct_ent_date    v_spld_acct_ent_date_tab;
      v_dist_flag             v_dist_flag_tab;
      v_spld_date             v_spld_date_tab;
      v_pol_flag              v_pol_flag_tab;
      v_cred_branch           v_cred_branch_tab;
      v_cred_branch_param     v_cred_branch_param_tab;
      vv_policy_id            policy_id_tab;
      vv_total_tsi            total_tsi_tab;
      vv_total_prem           total_prem_tab;
      vv_acct_ent_date        acct_ent_date_tab;
      vv_spld_acct_ent_date   spld_acct_ent_date_tab;
      vv_spld_date            spld_date_tab;
      vv_pol_flag             pol_flag_tab;
      v_multiplier            NUMBER                   := 1;
      v_count                 NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START');

      DELETE FROM edst_ext
            WHERE user_id = p_user;

      /* rollie 03JAN2004
      ** to store user's parameter in a table*/
      DELETE FROM edst_param
            WHERE user_id = USER;

      INSERT INTO edst_param
                  (SCOPE, param_date, from_date, TO_DATE, iss_cd,
                   line_cd, subline_cd, iss_param, user_id, last_extract
                  )
           VALUES (p_scope, p_param_date, p_from_date, p_to_date, p_iss_cd,
                   p_line_cd, p_subline_cd, p_parameter, USER, SYSDATE
                  );

      COMMIT;

      SELECT a.assd_no, gp.policy_id gp_policy_id,
             gp.issue_date /*TO_CHAR (gp.issue_date, 'MM-DD-YYYY') */
                                                                gp_issue_date,
             gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             gp.incept_date /*TO_CHAR (gp.incept_date, 'MM-DD-YYYY') */
                                                               gp_incept_date,
             gp.expiry_date /*TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') */
                                                               gp_expiry_date,
             gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
             gp.acct_ent_date /*TO_CHAR (gp.acct_ent_date, 'MM-DD-YYYY')*/
                                                             gp_acct_ent_date,
             gp.spld_acct_ent_date /*TO_CHAR (gp.spld_acct_ent_date, 'MM-DD-YYYY') */
                                                        gp_spld_acct_ent_date,
             gp.dist_flag dist_flag,
             gp.spld_date /*TO_CHAR (gp.spld_date, 'MM-DD-YYYY')*/
                                                                 gp_spld_date,
             gp.pol_flag gp_pol_flag, gp.cred_branch
      BULK COLLECT INTO v_assd_no, v_policy_id,
             v_issue_date,
             v_line_cd, v_subline_cd,
             v_iss_cd, v_issue_yy,
             v_pol_seq_no, v_renew_no,
             v_endt_iss_cd, v_endt_yy,
             v_endt_seq_no,
             v_incept_date,
             v_expiry_date,
             v_tsi_amt, v_prem_amt,
             v_acct_ent_date,
             v_spld_acct_ent_date,
             v_dist_flag,
             v_spld_date,
             v_pol_flag, v_cred_branch
        FROM gipi_polbasic gp,
             gipi_parlist a,
             giis_line gl,
             giis_subline gs                             --, GIUW_POL_DIST gpd
       --vin 7.1.2010 added tables giis_line and giis_subline to consider the edst_sw as requested by the GUC Members
      WHERE  a.par_id = gp.par_id
         AND NVL (gp.endt_type, 'A') = 'A'
         AND DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                NVL (p_iss_cd,
                     DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd)
                    )
         AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
         AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
         AND ((   TRUNC (gp.acct_ent_date) BETWEEN p_from_date AND p_to_date
               OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                     BETWEEN p_from_date
                         AND p_to_date
              )
             )
         AND gl.line_cd = gp.line_cd                           -- vin 7.1.2010
         AND gs.line_cd = gp.line_cd                                         --
         AND gs.subline_cd = gp.subline_cd                                   --
         AND NVL (gl.edst_sw, 'N') =
                'N'
                -- edst_sw which is maintained is now considered in extraction
         AND NVL (gs.edst_sw, 'N') = 'N';  --  as requested by the GUC Members

      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO edst_ext                   --GIPI_UWREPORTS_EXT alvin
                        (assd_no, policy_id,
                         issue_date, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date, expiry_date,
                         total_tsi, total_prem, from_date,
                         to_date1, SCOPE, user_id, acct_ent_date,
                         spld_acct_ent_date, dist_flag,
                         spld_date, pol_flag, param_date,
                         cred_branch, cred_branch_param, last_extract
                        )
                 VALUES (v_assd_no (cnt), v_policy_id (cnt),
                         v_issue_date (cnt), v_line_cd (cnt),
                         v_subline_cd (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         v_incept_date (cnt), v_expiry_date (cnt),
                         v_tsi_amt (cnt), v_prem_amt (cnt), p_from_date,
                         p_to_date, p_scope, USER, v_acct_ent_date (cnt),
                         v_spld_acct_ent_date (cnt), v_dist_flag (cnt),
                         v_spld_date (cnt), v_pol_flag (cnt), p_param_date,
                         v_cred_branch (cnt), p_parameter, SYSDATE
                        );
         COMMIT;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'MAIN');

      SELECT COUNT (policy_id)
        INTO v_count
        FROM edst_ext
       WHERE user_id = USER;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 2');

      IF v_count <> 0
      THEN
         SELECT policy_id, total_tsi, total_prem, acct_ent_date,
                spld_acct_ent_date, spld_date, pol_flag
         BULK COLLECT INTO vv_policy_id, vv_total_tsi, vv_total_prem, vv_acct_ent_date,
                vv_spld_acct_ent_date, vv_spld_date, vv_pol_flag
           FROM edst_ext                                  --GIPI_UWREPORTS_EXT
          WHERE user_id = USER;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 3');

         FOR idx IN vv_policy_id.FIRST .. vv_policy_id.LAST
         LOOP
            IF     (vv_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
               AND (vv_spld_acct_ent_date (idx) BETWEEN p_from_date AND p_to_date
                   )
            THEN
               vv_total_tsi (idx) := 0;
               vv_total_prem (idx) := 0;
            ELSIF     vv_spld_date (idx) BETWEEN p_from_date AND p_to_date
                  AND vv_pol_flag (idx) = '5'
            THEN
               --issa10.02.2007 should not be multiplied to (-1), get value as is from table
               vv_total_tsi (idx) := vv_total_tsi (idx);
               vv_total_prem (idx) := vv_total_prem (idx);
            --issa10.02.2007 to prevent discrepancy in gipir923 and gipir923e
               /*vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
               vv_total_prem(idx) := vv_total_prem(idx) * (-1);*/
            END IF;

            vv_spld_date (idx) := NULL;
         END LOOP;

         DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 4');
         FORALL upd IN vv_policy_id.FIRST .. vv_policy_id.LAST
            UPDATE edst_ext                               --GIPI_UWREPORTS_EXT
               SET total_tsi = vv_total_tsi (upd),
                   total_prem = vv_total_prem (upd),
                   spld_date = vv_spld_date (upd)
             WHERE policy_id = vv_policy_id (upd) AND user_id = USER;
--   END LOOP;
         COMMIT;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'START 5');
      COMMIT;
   END;                                                   --end procedure EDST

   ---Prodedure added by Anthony Santos Feb 2 2010 -------
   PROCEDURE pol_gixx_pol_prod_bir (
      p_scope          IN   NUMBER,
      p_param_date     IN   NUMBER,
      p_from_date      IN   DATE,
      p_to_date        IN   DATE,
      p_iss_cd         IN   VARCHAR2,
      p_line_cd        IN   VARCHAR2,
      p_subline_cd     IN   VARCHAR2,
      p_user           IN   VARCHAR2,
      p_parameter      IN   NUMBER,
      p_special_pol    IN   VARCHAR2,
      p_nonaff_endt    IN   VARCHAR2,
      p_inc_negative   IN   VARCHAR2
   )                                             --param added rachelle 061808
   AS
      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_assd_tin_tab IS TABLE OF giis_assured.assd_tin%TYPE;
                                                --anthony santo feb 2, 2010--

      TYPE v_no_tin_reason_tab IS TABLE OF giis_assured.no_tin_reason%TYPE;
                                                --anthony santo feb 2, 2010--

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;

      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;

      TYPE v_cancel_date_tab IS TABLE OF gipi_polbasic.cancel_date%TYPE;

      TYPE v_cancel_data_tab IS TABLE OF gipi_uwreports_ext.cancel_data%TYPE;

      v_no_tin_reason        v_no_tin_reason_tab;
                                            --added by anthony santos 02-2-10
      v_assd_tin             v_assd_tin_tab;
      v_assd_no              v_assd_no_tab;
      v_policy_id            v_policy_id_tab;
      v_issue_date           v_issue_date_tab;
      v_line_cd              v_line_cd_tab;
      v_subline_cd           v_subline_cd_tab;
      v_iss_cd               v_iss_cd_tab;
      v_issue_yy             v_issue_yy_tab;
      v_pol_seq_no           v_pol_seq_no_tab;
      v_renew_no             v_renew_no_tab;
      v_endt_iss_cd          v_endt_iss_cd_tab;
      v_endt_yy              v_endt_yy_tab;
      v_endt_seq_no          v_endt_seq_no_tab;
      v_incept_date          v_incept_date_tab;
      v_expiry_date          v_expiry_date_tab;
      v_tsi_amt              v_tsi_amt_tab;
      v_prem_amt             v_prem_amt_tab;
      v_acct_ent_date        v_acct_ent_date_tab;
      v_spld_acct_ent_date   v_spld_acct_ent_date_tab;
      v_dist_flag            v_dist_flag_tab;
      v_spld_date            v_spld_date_tab;
      v_pol_flag             v_pol_flag_tab;
      v_cred_branch          v_cred_branch_tab;
      v_cancel_date          v_cancel_date_tab;
      v_cancel_data          v_cancel_data_tab;
   BEGIN
      SELECT   /*+INDEX (GP POLBASIC_U1) */
               gs.assd_no, gs.assd_tin, gs.no_tin_reason,
               gp.policy_id gp_policy_id, gp.issue_date gp_issue_date,
               gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
               gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
               gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
               gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
               gp.endt_seq_no gp_endt_seq_no, gp.incept_date gp_incept_date,
               gp.expiry_date gp_expiry_date,
                                             --gp.tsi_amt gp_tsi_amt,
                                             --gp.prem_amt gp_prem_amt,
                                             SUM (gpd.tsi_amt) gp_tsi_amt,
                                                                       --glyza
               SUM (gpd.prem_amt) gp_prem_amt,                         --glyza
               NVL (gi.acct_ent_date, gp.acct_ent_date),
                                              --i -- aaron 010609 --vcm 100709
               -- gpd.acct_ent_date, -- aaron 0101609
                     --gp.acct_ent_date gp_acct_ent_date,
               gp.spld_acct_ent_date gp_spld_acct_ent_date,
               gp.dist_flag dist_flag, gp.spld_date gp_spld_date,
               gp.pol_flag gp_pol_flag, gp.cred_branch gp_cred_branch,
               gp.cancel_date,
               DECODE (gp.pol_flag,
                       '4', p_uwreports.check_date_dist_peril (gp.line_cd,
                                                               gp.subline_cd,
                                                               gp.iss_cd,
                                                               gp.issue_yy,
                                                               gp.pol_seq_no,
                                                               gp.renew_no,
                                                               p_param_date,
                                                               p_from_date,
                                                               p_to_date
                                                              ),
                       1
                      )
      BULK COLLECT INTO v_assd_no, v_assd_tin, v_no_tin_reason,
               v_policy_id, v_issue_date,
               v_line_cd, v_subline_cd,
               v_iss_cd, v_issue_yy,
               v_pol_seq_no, v_renew_no,
               v_endt_iss_cd, v_endt_yy,
               v_endt_seq_no, v_incept_date,
               v_expiry_date, v_tsi_amt,
               v_prem_amt,
               v_acct_ent_date,
               v_spld_acct_ent_date,
               v_dist_flag, v_spld_date,
               v_pol_flag, v_cred_branch,
               v_cancel_date,
               v_cancel_data
          FROM gipi_parlist a,
               gipi_polbasic gp,
               gipi_invoice gi,                                            --i
               giuw_pol_dist gpd,
               giis_assured gs
         WHERE a.par_id = gp.par_id
           AND p_uwreports.check_date_policy
                      (p_scope,
                       p_param_date,
                       p_from_date,
                       p_to_date,
                       gp.issue_date,
                       gp.eff_date,
                       --gpd.acct_ent_date, --aaron 010609
                       NVL (gi.acct_ent_date, gp.acct_ent_date),
                                                           --glyza --vcm100709
                       --gp.spld_acct_ent_date,
                       NVL (gi.spoiled_acct_ent_date, gp.spld_acct_ent_date),
                                                                       --aaron
                       --gp.booking_mth,
                       --gp.booking_year,
                       gi.multi_booking_mm,                            --glyza
                       gi.multi_booking_yy,                            --glyza
                       gp.cancel_date,
                                      --issa01.23.2008 to consider cancel_date
                       gp.endt_seq_no
                      ) = 1      -- to consider if policies only or endts only
           AND gi.policy_id = gp.policy_id                                 --i
           --AND NVL (gp.endt_type, 'A') = 'A'
           AND NVL (gp.endt_type, 'A') =
                  DECODE
                     (p_nonaff_endt,
                      'N', 'A',
                      NVL (gp.endt_type, 'A')
                     )
                   --rachelle 061808 extract affecting and non-affecting endts
           AND gp.reg_policy_sw =
                               DECODE (p_special_pol,
                                       'Y', reg_policy_sw,
                                       'Y'
                                      )
           AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
           AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
           AND DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                  NVL (p_iss_cd,
                       DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd)
                      )
           AND gp.policy_id = gpd.policy_id
           AND NVL (gi.takeup_seq_no, 1) = NVL (gpd.takeup_seq_no, 1)    --gly
           AND NVL (gi.item_grp, 1) = NVL (gpd.item_grp, 1)              --gly
           AND gpd.dist_flag <> DECODE (gp.pol_flag, '5', 5, 4)    --vj 120109
           AND gpd.dist_flag <> 5                     -- added by aaron 012609
           AND gs.assd_no = a.assd_no       --added by anthony santos 02-02-10
        HAVING SUM (gp.prem_amt) >= 0       --added by anthony santos 02-02-10
      GROUP BY gs.assd_tin,
               gs.no_tin_reason,
               gs.assd_no,
               gp.policy_id,
               gp.issue_date,
               gp.line_cd,
               gp.subline_cd,
               gp.iss_cd,
               gp.issue_yy,
               gp.pol_seq_no,
               gp.renew_no,
               gp.endt_iss_cd,
               gp.endt_yy,
               gp.endt_seq_no,
               gp.incept_date,
               gp.expiry_date,
               -- gpd.acct_ent_date, -- aaron 010609
               NVL (gi.acct_ent_date, gp.acct_ent_date),       --i --vcm100709
               gp.spld_acct_ent_date,
               gp.dist_flag,
               gp.spld_date,
               gp.pol_flag,
               gp.cred_branch,
               gp.cancel_date,
               DECODE (gp.pol_flag,
                       '4', p_uwreports.check_date_dist_peril (gp.line_cd,
                                                               gp.subline_cd,
                                                               gp.iss_cd,
                                                               gp.issue_yy,
                                                               gp.pol_seq_no,
                                                               gp.renew_no,
                                                               p_param_date,
                                                               p_from_date,
                                                               p_to_date
                                                              ),
                       1
                      );                                                   --,

      --gp.tsi_amt, gp.prem_amt;
      IF SQL%FOUND
      THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_ext
                        (assd_no, policy_id,
                         issue_date, line_cd,
                         subline_cd, iss_cd,
                         issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no,
                         incept_date, expiry_date,
                         total_tsi, total_prem, from_date,
                         TO_DATE, SCOPE, user_id, acct_ent_date,
                         spld_acct_ent_date, dist_flag,
                         spld_date, pol_flag, param_date,
                         evatprem, fst, lgt, doc_stamps, other_taxes,
                         other_charges, cred_branch, cred_branch_param,
                         special_pol_param, cancel_date,
                         cancel_data, tin,
                         no_tin_reason
                        )
                 VALUES (v_assd_no (cnt), v_policy_id (cnt),
                         v_issue_date (cnt), v_line_cd (cnt),
                         v_subline_cd (cnt), v_iss_cd (cnt),
                         v_issue_yy (cnt), v_pol_seq_no (cnt),
                         v_renew_no (cnt), v_endt_iss_cd (cnt),
                         v_endt_yy (cnt), v_endt_seq_no (cnt),
                         v_incept_date (cnt), v_expiry_date (cnt),
                         v_tsi_amt (cnt), v_prem_amt (cnt), p_from_date,
                         p_to_date, p_scope, USER, v_acct_ent_date (cnt),
                         v_spld_acct_ent_date (cnt), v_dist_flag (cnt),
                         v_spld_date (cnt), v_pol_flag (cnt), p_param_date,
                         0, 0, 0, 0, 0,
                         0, v_cred_branch (cnt), p_parameter,
                         p_special_pol, v_cancel_date (cnt),
                         v_cancel_data (cnt), v_assd_tin (cnt),
                         v_no_tin_reason (cnt)
                        );
         COMMIT;
      END IF;

      DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS') || 'MAIN');
   END;                                      --procedure pol_gixx_pol_prod_BIR

   PROCEDURE copy_tab1 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_user         IN   VARCHAR2
   )
   /* created by    : Mikel
   ** date         : 11.12.2013
   ** description :
   */
   AS
   BEGIN
      DELETE FROM gipi_uwreports_ext_cons
            WHERE user_id = p_user AND SCOPE = p_scope;

      IF p_scope = 4
      THEN
         INSERT INTO cpi.gipi_uwreports_ext_cons
                     (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                      renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                      incept_date, expiry_date, total_tsi, total_prem,
                      evatprem, fst, lgt, doc_stamps, other_taxes,
                      other_charges, param_date, from_date, TO_DATE, SCOPE,
                      user_id, policy_id, assd_no, issue_date, dist_flag,
                      spld_date, acct_ent_date, spld_acct_ent_date, pol_flag,
                      cred_branch, cancel_data, cred_branch_param,
                      special_pol_param, cancel_date, comm_amt,
                      no_tin_reason, tin, tax1, tax2, tax3, tax4, tax5, tax6,
                      tax7, tax8, tax9, tax10, tax11, tax12, tax13, tax14,
                      tax15)
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                   renew_no, endt_iss_cd, endt_yy, endt_seq_no, incept_date,
                   expiry_date, total_tsi * -1, total_prem * -1,
                   evatprem * -1, fst * -1, lgt * -1, doc_stamps * -1,
                   other_taxes * -1, other_charges * -1, param_date,
                   from_date, TO_DATE, SCOPE, user_id, policy_id, assd_no,
                   issue_date, dist_flag, spld_date, acct_ent_date,
                   spld_acct_ent_date, pol_flag, cred_branch, cancel_data,
                   cred_branch_param, special_pol_param, cancel_date,
                   comm_amt * -1, no_tin_reason, tin, tax1, tax2, tax3, tax4,
                   tax5, tax6, tax7, tax8, tax9, tax10, tax11, tax12, tax13,
                   tax14, tax15
              FROM gipi_uwreports_ext
             WHERE user_id = p_user AND SCOPE = p_scope;
      ELSE
         INSERT INTO cpi.gipi_uwreports_ext_cons
                     (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                      renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                      incept_date, expiry_date, total_tsi, total_prem,
                      evatprem, fst, lgt, doc_stamps, other_taxes,
                      other_charges, param_date, from_date, TO_DATE, SCOPE,
                      user_id, policy_id, assd_no, issue_date, dist_flag,
                      spld_date, acct_ent_date, spld_acct_ent_date, pol_flag,
                      cred_branch, cancel_data, cred_branch_param,
                      special_pol_param, cancel_date, comm_amt,
                      no_tin_reason, tin, tax1, tax2, tax3, tax4, tax5, tax6,
                      tax7, tax8, tax9, tax10, tax11, tax12, tax13, tax14,
                      tax15)
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                      renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                      incept_date, expiry_date, total_tsi, total_prem,
                      evatprem, fst, lgt, doc_stamps, other_taxes,
                      other_charges, param_date, from_date, TO_DATE, SCOPE,
                      user_id, policy_id, assd_no, issue_date, dist_flag,
                      spld_date, acct_ent_date, spld_acct_ent_date, pol_flag,
                      cred_branch, cancel_data, cred_branch_param,
                      special_pol_param, cancel_date, comm_amt,
                      no_tin_reason, tin, tax1, tax2, tax3, tax4, tax5, tax6,
                      tax7, tax8, tax9, tax10, tax11, tax12, tax13, tax14,
                      tax15
              FROM gipi_uwreports_ext
             WHERE user_id = p_user AND SCOPE = p_scope;
      END IF;
   END;
END p_uwreports;
/



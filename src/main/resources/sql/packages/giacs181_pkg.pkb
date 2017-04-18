CREATE OR REPLACE PACKAGE BODY CPI.giacs181_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.18.2013
   **  Reference By : GIACS181- Schedule of Premiums Ceded to Facultative RI
   **  Description  :
   */
   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                ORDER BY 1, 2)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED
   IS
      v_rec   ri_lov_type;
   BEGIN
      FOR i IN (SELECT   ri_cd, ri_name
                    FROM giis_reinsurer
                ORDER BY 1, 2)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION validate_print (p_from_date VARCHAR2, p_until_date VARCHAR2)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT DISTINCT from_date, TO_DATE
                           FROM giac_dueto_ext
                          WHERE from_date =
                                          TO_DATE (p_from_date, 'MM-DD-YYYY')
                            AND TO_DATE = TO_DATE (p_until_date, 'MM-DD-YYYY'))
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END;

   FUNCTION get_giac_dueto_ext_params
      RETURN giac_dueto_ext_tab PIPELINED
   IS
      v_rec   giac_dueto_ext_type;
   BEGIN
      FOR i IN (SELECT from_date, TO_DATE
                  FROM giac_dueto_ext)
      LOOP
         v_rec.from_date := TO_CHAR (i.from_date, 'MM-DD-YYYY');
         v_rec.TO_DATE := TO_CHAR (i.TO_DATE, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
         EXIT;
      END LOOP;
   END;

   PROCEDURE extract_to_table (
      p_from_date          DATE,
      p_until_date         DATE,
      p_user_id            giis_users.user_id%TYPE,
      p_exist        OUT   VARCHAR2
   )
   IS
      ctr           NUMBER                               := 0;
      v_ri_prem     NUMBER;
      v_ri_comm     NUMBER;
      v_fund_cd     giac_parameters.param_value_v%TYPE;
      v_branch_cd   giac_parameters.param_value_v%TYPE;
      v_cnt         NUMBER                               := 0;
   BEGIN
      DELETE FROM giac_dueto_ext;

      SELECT param_value_v
        INTO v_fund_cd
        FROM giac_parameters
       WHERE param_name = 'FUND_CD';

      SELECT param_value_v
        INTO v_branch_cd
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';

      --DELETE FROM GIAC_DUETO_EXT;
      FOR k IN
         (SELECT i.assd_no, j.assd_name,
                 (NVL (e.ri_prem_vat, 0) * NVL (d.currency_rt, 1)
                 ) ri_prem_vat,
                 (NVL (e.ri_comm_vat, 0) * NVL (d.currency_rt, 1)
                 ) ri_comm_vat,
                 (NVL (e.ri_wholding_vat, 0) * NVL (d.currency_rt, 1)
                 ) ri_wholding_vat,
                 e.ri_cd,
                 (NVL (e.prem_tax, 0) * NVL (d.currency_rt, 1)) prem_tax,
                 h.ri_name, e.line_cd, e.binder_yy, e.binder_seq_no,
                 e.binder_date, e.fnl_binder_id,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                  || DECODE (NVL (a.endt_seq_no, 0),
                             0, NULL,
                                '-'
                             || a.endt_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                             || a.endt_type
                            )
                 ) policy_no,
                 a.policy_id, acc_ent_date booking_date,
                 
                 /*ROUND(NVL(d.currency_rt,1),2) curr_rt commented by vercel*/
                 NVL (d.currency_rt, 1) curr_rt,
                 (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 1)
                 ) amt_insured,
                 (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 1)
                 ) ri_prem_amt,
                 (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 1)
                 ) ri_comm_amt, 'P' tag
            FROM gipi_polbasic a,
                 giuw_pol_dist b,
                 giri_frps_ri c,
                 giri_distfrps d,
                 giri_binder e,
                 giis_currency g,
                 giis_reinsurer h,
                 gipi_parlist i,
                 giis_assured j
           WHERE a.policy_id = b.policy_id
             AND a.reg_policy_sw != 'N'
             --issa, 03.07.2005; to exclude special policies
             AND d.dist_no = b.dist_no
             AND c.line_cd = d.line_cd
             AND c.frps_yy = d.frps_yy
             AND c.frps_seq_no = d.frps_seq_no
             AND c.fnl_binder_id = e.fnl_binder_id
             AND d.currency_cd = g.main_currency_cd
             AND e.ri_cd = h.ri_cd
             AND a.par_id = i.par_id
             AND i.assd_no = j.assd_no
             AND a.assd_no > 0            --issa, 03.09.2005, for optimization
             AND check_user_per_iss_cd_acctg2 (NULL,
                                               a.iss_cd,
                                               'GIACS181',
                                               p_user_id
                                              ) = 1
             -- added by mildred -- security 03.18.2013
             AND (   (e.acc_ent_date BETWEEN p_from_date AND p_until_date
                     )         --AND used OR instead of AND by jeremy 08032010
                  --OR (b.acct_ent_date BETWEEN p_from_date AND p_until_date) --mikel 11.23.2015; UCPBGEN 20878
                 )                                      --ms.grace, 03.15.2005
          UNION
          SELECT i.assd_no, j.assd_name,
                 ((-1) * (NVL (e.ri_prem_vat, 0) * NVL (d.currency_rt, 1))
                 ) ri_prem_vat,
                 ((-1) * (NVL (e.ri_comm_vat, 0) * NVL (d.currency_rt, 1))
                 ) ri_comm_vat,
                 ((-1) * (NVL (e.ri_wholding_vat, 0) * NVL (d.currency_rt, 1))
                 ) ri_wholding_vat,
                 e.ri_cd,
                 ((-1) * (NVL (e.prem_tax, 0) * NVL (d.currency_rt, 1))
                 ) prem_tax,
                 h.ri_name, e.line_cd, e.binder_yy, e.binder_seq_no,
                 e.binder_date, e.fnl_binder_id,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                  || DECODE (NVL (a.endt_seq_no, 0),
                             0, NULL,
                                '-'
                             || a.endt_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                             || a.endt_type
                            )
                 ) policy_no,
                 a.policy_id, acc_rev_date booking_date,
                 
                 /*ROUND(NVL(d.currency_rt,1),2) curr_rt, commented by vercel*/
                 NVL (d.currency_rt, 1) curr_rt,
                 ((-1) * (NVL (e.ri_tsi_amt, 0) * NVL (d.currency_rt, 1))
                 ) amt_insured,
                 ((-1) * (NVL (e.ri_prem_amt, 0) * NVL (d.currency_rt, 1))
                 ) ri_prem_amt,
                 ((-1) * (NVL (e.ri_comm_amt, 0) * NVL (d.currency_rt, 1))
                 ) ri_comm_amt,
                 'N' tag
            FROM gipi_polbasic a,
                 giuw_pol_dist b,
                 giri_frps_ri c,
                 giri_distfrps d,
                 giri_binder e,
                 giis_currency g,
                 giis_reinsurer h,
                 gipi_parlist i,
                 giis_assured j
           WHERE a.policy_id = b.policy_id
             AND a.reg_policy_sw != 'N'
             --issa, 03.07.2005; to exclude special policies
             AND d.dist_no = b.dist_no
             AND c.line_cd = d.line_cd
             AND c.frps_yy = d.frps_yy
             AND c.frps_seq_no = d.frps_seq_no
             AND c.fnl_binder_id = e.fnl_binder_id
             AND d.currency_cd = g.main_currency_cd
             AND e.ri_cd = h.ri_cd
             AND a.par_id = i.par_id
             AND i.assd_no = j.assd_no
             AND a.assd_no > 0            --issa, 03.09.2005, for optimization
             AND check_user_per_iss_cd_acctg2 (NULL,
                                               a.iss_cd,
                                               'GIACS181',
                                               p_user_id
                                              ) = 1
             -- added by mildred -- security 03.18.2013
             AND (   (e.acc_rev_date BETWEEN p_from_date AND p_until_date
                     )        --AND used OR instead of AND by april 06/03/2010
                  --OR (b.acct_neg_date BETWEEN p_from_date AND p_until_date) --mikel 11.23.2015; UCPBGEN 20878
                 ))
      LOOP
         v_cnt := v_cnt + 1;

         IF k.tag = 'P'
         THEN
            /*GET THE SUMMED AMOUNT IN GIRI_BINDER_PERIL FOR POSITIVE ZEROGRAVITYFEB2000*/
            FOR m IN (SELECT   ROUND (NVL (SUM (a.ri_prem_amt * k.curr_rt), 0),
                                      2
                                     ) ri_prem,
                               ROUND (NVL (SUM (a.ri_comm_amt * k.curr_rt), 0),
                                      2
                                     ) ri_comm
                          FROM giri_binder_peril a, giri_binder b
                         WHERE a.fnl_binder_id = b.fnl_binder_id
                           AND a.fnl_binder_id = k.fnl_binder_id
                      GROUP BY a.fnl_binder_id)
            LOOP
               v_ri_prem := m.ri_prem;
               v_ri_comm := m.ri_comm;
               EXIT;
            END LOOP;
         ELSIF k.tag = 'N'
         THEN
            /*GET THE SUMMED AMOUNT IN GIRI_BINDER_PERIL FOR NEGATIVE ZEROGRAVITYFEB2000*/
            FOR n IN (SELECT   ROUND (  NVL (SUM (a.ri_prem_amt * k.curr_rt),
                                             0
                                            )
                                      * (-1),
                                      2
                                     ) ri_prem,
                               ROUND (  NVL (SUM (a.ri_comm_amt * k.curr_rt),
                                             0
                                            )
                                      * (-1),
                                      2
                                     ) ri_comm
                          FROM giri_binder_peril a, giri_binder b
                         WHERE a.fnl_binder_id = b.fnl_binder_id
                           AND a.fnl_binder_id = k.fnl_binder_id
                      GROUP BY a.fnl_binder_id)
            LOOP
               v_ri_prem := n.ri_prem;
               v_ri_comm := n.ri_comm;
               EXIT;
            END LOOP;
         ELSE
            raise_application_error
               (-20001,
                'Geniisys Exception#E#UNHANDLED VALUE IN PROGRAM UNIT EXTRACT_TO_TABLE.'
               );
         END IF;

         INSERT INTO giac_dueto_ext
                     (assd_no, assd_name, fund_cd, branch_cd,
                      ri_cd, ri_name, policy_id, policy_no,
                      fnl_binder_id, line_cd, binder_yy,
                      binder_seq_no, binder_date, booking_date,
                      amt_insured, ri_prem_amt, ri_comm_amt, from_date,
                      TO_DATE, prem_vat, comm_vat,
                      wholding_vat, prem_tax
                     )
              VALUES (k.assd_no, k.assd_name, v_fund_cd, v_branch_cd,
                      k.ri_cd, k.ri_name, k.policy_id, k.policy_no,
                      k.fnl_binder_id, k.line_cd, k.binder_yy,
                      k.binder_seq_no, k.binder_date, k.booking_date,
                      k.amt_insured, v_ri_prem, v_ri_comm, p_from_date,
                      p_until_date, k.ri_prem_vat, k.ri_comm_vat,
                      k.ri_wholding_vat, k.prem_tax
                     );
      /*BEGIN ANIMATION ZERO GRAVITYAUGUST2000*/
      /*begin
        VARIABLES.v_dbase_WIDTH := get_item_property('dbase_anim',WIDTH);
        VARIABLES.v_dbase_X_pos  := get_item_property('dbase_anim',X_pos);
        VARIABLES.V_ORIG_DBASE_XPOS := VARIABLES.v_dbase_X_pos;
        if VARIABLES.v_dbase_WIDTH >= 175 then
            set_item_property('dbase_anim',WIDTH,175);
            set_item_property('dbase_anim',X_POS,VARIABLES.V_ORIG_DBASE_XPOS);
        else
           set_item_property('dbase_anim',WIDTH,VARIABLES.v_dbase_WIDTH + VARIABLES.INCREMENT);
           --set_item_property('dbase_anim',X_pos,VARIABLES.v_dbase_X_pos - VARIABLES.INCREMENT);
           --SET_ITEM_PROPERTY('ANIM_1',displayed,property_true);
        */
             /*IF VARIABLES.V_ANIM_XPOS >= 350 THEN
              VARIABLES.V_ANIM_XPOS := 250;
           END IF;*/
           --SET_ITEM_PROPERTY('ANIM_1',X_POS,VARIABLES.v_anim_xpos + 7);
           --set_item_property('xtrak_anim',y_pos,VARIABLES.v_xtrak_y_pos - VARIABLES.INCREMENT);
           --set_item_property('xtrak_anim',height,VARIABLES.v_xtrak_height + VARIABLES.INCREMENT);
        /*end if;
      end;
      */
      END LOOP;

      p_exist := TO_CHAR (v_cnt);
   END;
END;
/



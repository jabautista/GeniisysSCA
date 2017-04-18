CREATE OR REPLACE PACKAGE BODY CPI.girir035_pkg
AS
   /** Created By:     Steven Ramirez
    ** Date Created:   07.14.2014
    ** Referenced By:  GIRIR035 - GROUP BINDER
    **/
   FUNCTION get_report_header (
      p_line_cd         giri_group_binder.line_cd%TYPE,
      p_binder_yy       giri_group_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_group_binder.binder_seq_no%TYPE
   )
      RETURN report_details_tab PIPELINED
   AS
      rep          report_details_type;
      status_v     VARCHAR2 (7);
      object_v     VARCHAR2 (12);
      object_v2    VARCHAR2 (12);
      v_pol_flag   VARCHAR2 (1);
      v_par_type   VARCHAR2 (1);
      v_dist_no    VARCHAR2 (100);
      v_dist       VARCHAR2 (19);
      v_count      NUMBER (5)          := 0;
      v_frps_no    VARCHAR2 (100);
      v_frps       VARCHAR2 (19);
      v_net_due    NUMBER := 0; --edgar 12/03/2014
      v_total_due  NUMBER := 0; --edgar 12/03/2014
   BEGIN
      rep.company_name := giisp.v ('COMPANY_NAME');
      rep.company_address := giisp.v ('COMPANY_ADDRESS');

      FOR i IN
         (SELECT DISTINCT UPPER (a150.line_name) line_name,
                             'FACULTATIVE REINSURANCE BINDER NUMBER '
                          || d0107.line_cd
                          || '-'
                          || LTRIM (TO_CHAR (d0107.binder_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (d0107.binder_seq_no, '09999'))
                          || '*' binder_no,
                             'FACULTATIVE REINSURANCE ALTERATION BINDER NUMBER '
                          || d0107.line_cd
                          || '-'
                          || LTRIM (TO_CHAR (d0107.binder_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (d0107.binder_seq_no, '09999'))
                          || '*' binder_number,
                             LTRIM
                                 (TO_CHAR (d0107.ri_tsi_amt,
                                           '99,999,999,999,990.99'
                                          )
                                 )
                          || '  ('
                          || LTRIM (TO_CHAR (d0107.ri_shr_pct, '990.9999'))
                          || '%)' your_share,
                          NVL (d0107.prem_tax, 0) prem_tax4,
                          d0107.binder_date binder_date5,
                          a18011.ri_name ri_name,
                          a18011.bill_address1 bill_address11,
                          a18011.bill_address2 bill_address22,
                          a18011.bill_address3 bill_address33,
                          a18011.attention,
                          DECODE (b240.par_type,
                                  'E', b240.assd_no,
                                  b2504.assd_no
                                 ) assd_no,
                             b2504.line_cd
                          || '-'
                          || b2504.subline_cd
                          || '-'
                          || b2504.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (b2504.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b2504.pol_seq_no, '0999999'))
                                                                   policy_no,
                             b2504.endt_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (b2504.endt_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b2504.endt_seq_no, '099999'))
                                                                     endt_no,
                             TO_CHAR (b2504.eff_date,
                                      'Mon. DD, YYYY')
                          || ' to '
                          || DECODE (b2504.endt_expiry_date,
                                     NULL, TO_CHAR (b2504.expiry_date,
                                                    'Mon. DD, YYYY'
                                                   ),
                                     TO_CHAR (b2504.endt_expiry_date,
                                              'Mon. DD, YYYY'
                                             )
                                    ) ri_term1, --edgar 12/03/2014
                          DECODE(B2504.incept_tag, 'Y', 'TBA', TO_CHAR(grbndr.eff_date, 'Mon. DD, YYYY')) || ' to '  || DECODE(B2504.expiry_tag, 'Y', 'TBA', TO_CHAR(grbndr.EXPIRY_DATE, 'Mon. DD, YYYY'))  ri_term, --edgar 12/03/2014
                             c100.short_name
                          || ' '
                          || LTRIM (TO_CHAR (SUM (d06010.tsi_amt),
                                             '99,999,999,999,990.99'
                                            )
                                   ) sum_insured,
                          b2504.endt_seq_no endt_seq_no2,
                          d0107.bndr_remarks1, d0107.bndr_remarks2,
                          d0107.bndr_remarks3,
                          d0107.master_bndr_id master_bndr_id2,
                          b2504.policy_id, b2504.par_id, endt_seq_no,
                          endt_yy, endt_iss_cd, subline_cd, b2504.line_cd,
                          c0803.dist_no, d0809.reverse_sw,
                          SUM (NVL (d0809.other_charges, 0)) other_charges,
                          '*' || b2504.user_id || '*' user_id,
                          a18011.local_foreign_sw, d0107.reverse_date
                     FROM giri_group_binder d0107,
                          giis_reinsurer a18011,
                          giis_line a150,
                          giri_frps_ri d0809,
                          giri_distfrps d06010,
                          giuw_pol_dist c0803,
                          gipi_polbasic b2504,
                          giis_currency c100,
                          gipi_parlist b240
                          ,giri_binder grbndr --edgar 12/03/2014
                    WHERE b240.par_id = b2504.par_id
                      AND a18011.ri_cd = d0107.ri_cd
                      AND d0107.line_cd = a150.line_cd
                      AND d06010.frps_seq_no = d0809.frps_seq_no
                      AND c0803.dist_no = d06010.dist_no
                      AND b2504.policy_id = c0803.policy_id
                      AND d06010.currency_cd = c100.main_currency_cd
                      AND d06010.line_cd = d0809.line_cd
                      AND d06010.frps_yy = d0809.frps_yy
                      AND d0107.master_bndr_id = d0809.master_bndr_id
                      AND DECODE (d0107.reverse_date,
                                  NULL, 2,
                                  d06010.ri_flag
                                 ) = d06010.ri_flag
                      AND d0107.line_cd = p_line_cd
                      AND d0107.binder_yy = p_binder_yy
                      AND d0107.binder_seq_no = p_binder_seq_no
                      AND d0809.fnl_binder_id = grbndr.fnl_binder_id
                 GROUP BY a150.line_name,
                          d0107.line_cd,
                          d0107.binder_yy,
                          d0107.binder_seq_no,
                          d0107.ri_tsi_amt,
                          d0107.ri_shr_pct,
                          d0107.prem_tax,
                          d0107.binder_date,
                          a18011.ri_name,
                          a18011.bill_address1,
                          a18011.bill_address2,
                          a18011.bill_address3,
                          a18011.attention,
                          b240.par_type,
                          b240.assd_no,
                          b2504.assd_no,
                          b2504.line_cd,
                          b2504.subline_cd,
                          b2504.iss_cd,
                          b2504.issue_yy,
                          b2504.pol_seq_no,
                          b2504.endt_iss_cd,
                          b2504.endt_yy,
                          b2504.endt_seq_no,
                          b2504.eff_date,
                          b2504.endt_expiry_date,
                          b2504.expiry_date,
                          d0107.master_bndr_id,
                          b2504.policy_id,
                          b2504.par_id,
                          b2504.user_id,
                          d0809.reverse_sw,
                          c100.short_name,
                          c0803.dist_no,
                          d0107.bndr_remarks1,
                          d0107.bndr_remarks2,
                          d0107.bndr_remarks3,
                          a18011.local_foreign_sw,
                          d0107.reverse_date
                          --added fields edgar 12/03/2014
                          ,B2504.incept_tag,
                          B2504.expiry_tag,
                          grbndr.eff_date,
                          grbndr.expiry_date)
      LOOP
         rep.line_name := i.line_name;
         rep.binder_no := i.binder_no;
         rep.binder_number := i.binder_number;
         rep.your_share := i.your_share;
         rep.binder_date5 := i.binder_date5;
         rep.ri_name := i.ri_name;
         rep.bill_address11 := i.bill_address11;
         rep.bill_address22 := i.bill_address22;
         rep.bill_address33 := i.bill_address33;
         rep.attention := i.attention;
         rep.assd_no := i.assd_no;
         rep.policy_no := i.policy_no;
         rep.endt_no := i.endt_no;
         rep.ri_term := i.ri_term;
         rep.sum_insured := i.sum_insured;
         rep.endt_seq_no2 := i.endt_seq_no2;
         rep.bndr_remarks1 := i.bndr_remarks1;
         rep.bndr_remarks2 := i.bndr_remarks2;
         rep.bndr_remarks3 := i.bndr_remarks3;
         rep.master_bndr_id2 := i.master_bndr_id2;
         rep.policy_id := i.policy_id;
         rep.par_id := i.par_id;
         rep.endt_seq_no := i.endt_seq_no;
         rep.endt_yy := i.endt_yy;
         rep.endt_iss_cd := i.endt_iss_cd;
         rep.subline_cd := i.subline_cd;
         rep.line_cd := i.line_cd;
         rep.dist_no := i.dist_no;
         rep.reverse_sw := i.reverse_sw;
         rep.other_charges := i.other_charges;
         rep.user_id := i.user_id;
         rep.local_foreign_sw := i.local_foreign_sw;
         rep.reverse_date := i.reverse_date;

         IF i.reverse_sw = 'Y'
         THEN
            rep.prem_tax4 := i.prem_tax4 * (-1);
         ELSE
            rep.prem_tax4 := i.prem_tax4;
         END IF;

         BEGIN
            BEGIN
               SELECT pol_flag
                 INTO v_pol_flag
                 FROM gipi_polbasic
                WHERE policy_id = i.policy_id;

               SELECT par_type
                 INTO v_par_type
                 FROM gipi_parlist
                WHERE par_id = i.par_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF    (v_pol_flag = '1')
               OR (v_pol_flag = '2')
               OR (v_pol_flag = '3')
               OR (v_pol_flag = '5')
            THEN
               IF i.endt_seq_no2 > 0
               THEN
                  status_v := 'ENDORSE';
               ELSIF i.endt_seq_no2 = 0
               THEN
                  status_v := 'ISSUE';
               END IF;
            ELSIF (v_pol_flag = '4')
            THEN
               status_v := 'cancel';
            END IF;

            IF (v_par_type = 'P')
            THEN
               object_v := 'Policy';
            ELSIF (v_par_type = 'E')
            THEN
               object_v := 'Policy';
            END IF;

            IF (v_pol_flag = '2')
            THEN
               object_v2 := 'renewal,';
            ELSE
               IF (v_par_type = 'P')
               THEN
                  object_v2 := 'POLICY,';
               ELSIF (v_par_type = 'E')
               THEN
                  object_v2 := 'ENDORSEMENT,';
               END IF;
            END IF;

            rep.first_paragraph :=
                  'Kindly '
               || status_v
               || ' your Reinsurance '
               || object_v
               || ' in accordance with our '
               || object_v2
               || ' copy(ies) of which is(are) attached herewith.';
         END;

         FOR c IN (SELECT assd_name assd_name
                     FROM giis_assured
                    WHERE assd_no = i.assd_no)
         LOOP
            rep.assd_name := c.assd_name;
         END LOOP;

         BEGIN
            SELECT    t1.line_cd
                   || '-'
                   || LTRIM (op_subline_cd)
                   || '-'
                   || LTRIM (op_iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (op_pol_seqno, '0999999'))
              INTO rep.mop_policy_no
              FROM gipi_open_policy t1, gipi_polbasic t2
             WHERE t2.policy_id = i.policy_id AND t1.policy_id = t2.policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.mop_policy_no := NULL;
         END;

         IF i.endt_seq_no != 0
         THEN
            rep.endt_no_2 :=
                  i.endt_iss_cd
               || '-'
               || LTRIM (RTRIM (TO_CHAR (i.endt_yy, '09')))
               || '-'
               || LTRIM (RTRIM (TO_CHAR (i.endt_seq_no, '099999')));
         ELSE
            rep.endt_no_2 := NULL;
         END IF;

         FOR a IN (SELECT property
                     FROM gipi_invoice
                    WHERE policy_id = i.policy_id)
         LOOP
            rep.property := a.property;
         END LOOP;

         FOR a IN (SELECT    LTRIM (TO_CHAR (d06010.dist_no, '09999999')
                                   )
                          || '-'
                          || LTRIM (TO_CHAR (d06010.dist_seq_no, '09999'))
                                                                        ds_no
                     FROM giri_distfrps d06010
                    WHERE d06010.dist_no = i.dist_no)
         LOOP
            v_count := v_count + 1;
            v_dist := a.ds_no;

            IF v_count = 1
            THEN
               v_dist_no := v_dist;
            ELSIF v_count > 4
            THEN
               v_dist_no := 'Various';
               EXIT;
            ELSE
               v_dist_no := v_dist_no || ', ' || v_dist;
            END IF;
         END LOOP;
          /* edgar 12/02/2014*/
          FOR j IN (SELECT   t3.master_bndr_id, SUM (t4.prem_amt) tot_gross_prem
                        FROM giri_frps_ri t3, giri_frps_peril_grp t4
                       WHERE t3.master_bndr_id = i.master_bndr_id2
                         AND t3.line_cd = t4.line_cd
                         AND t3.frps_yy = t4.frps_yy
                         AND t3.frps_seq_no = t4.frps_seq_no
                    GROUP BY t3.master_bndr_id)
          LOOP
            rep.total_gross_prem := j.tot_gross_prem;
          END LOOP;
          /* edgar 12/02/2014*/
         rep.dsp_dist_no := v_dist_no;
         v_count := 0;

         FOR a IN (SELECT    LTRIM (TO_CHAR (d06010.frps_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (d06010.frps_seq_no, '099999'))
                          || '/'
                          || LTRIM (TO_CHAR (d06010.op_group_no, '099999'))
                                                                      frps_no
                     FROM giri_distfrps d06010
                    WHERE d06010.dist_no = i.dist_no)
         LOOP
            v_count := v_count + 1;
            v_frps := a.frps_no;

            IF v_count = 1
            THEN
               v_frps_no := v_frps;
            ELSIF v_count > 4
            THEN
               v_frps_no := 'Various';
               EXIT;
            ELSE
               v_frps_no := v_frps_no || ', ' || v_frps;
            END IF;
         END LOOP;
         
         rep.dsp_frps_no := v_frps_no;

         FOR j IN (SELECT   t1.peril_seq_no, t1.peril_cd, --edgar 12/02/2014
                            SUM (NVL (t1.ri_prem_amt, 0)) ri_prem_amt,
                            ROUND (AVG (NVL (t1.ri_comm_rt, 0)),
                                   2) ri_comm_rt,
                            SUM (NVL (t1.ri_comm_amt, 0)) ri_comm_amt,
                            SUM ((  NVL (t1.ri_prem_amt, 0)
                                  - NVL (t1.ri_comm_amt, 0)
                                 )
                                ) less_ri_comm_amt,
                            t1.master_bndr_id master_bndr_id3, t2.ri_prem_vat,
                            t2.ri_comm_vat,
                            (NVL (t2.ri_wholding_vat, 0) * (-1)
                            ) ri_wholding_vat
                       FROM giri_group_binder_peril t1, giri_group_binder t2
                      WHERE t2.master_bndr_id = i.master_bndr_id2
                        AND t1.master_bndr_id = t2.master_bndr_id
                   GROUP BY t1.master_bndr_id,
                            t1.peril_seq_no,
                            t1.peril_cd, --edgar 12/02/2014
                            t2.ri_prem_vat,
                            t2.ri_comm_vat,
                            t2.ri_wholding_vat)
         LOOP
            rep.peril_seq_no := j.peril_seq_no;
            rep.peril_cd := j.peril_cd; --edgar 12/02/2014
            --rep.ri_comm_rt := j.ri_comm_rt; --edgar 12/02/2014 : replaced with codes below
            IF j.ri_prem_amt !=0 THEN
                rep.ri_comm_rt := (j.ri_comm_amt / j.ri_prem_amt)*100;
            ELSE
                rep.ri_comm_rt := 0;
            END IF;
            rep.master_bndr_id3 := j.master_bndr_id3;

            IF i.reverse_sw = 'Y'
            THEN
               rep.ri_prem_amt := j.ri_prem_amt * (-1);
               rep.ri_comm_amt := j.ri_comm_amt * (-1);
               rep.less_ri_comm_amt := j.less_ri_comm_amt * (-1);
            ELSE
               rep.ri_prem_amt := j.ri_prem_amt;
               rep.ri_comm_amt := j.ri_comm_amt;
               rep.less_ri_comm_amt := j.less_ri_comm_amt;
            END IF;

            IF i.reverse_sw = 'Y' OR i.reverse_date IS NOT NULL
            THEN
               rep.less_ri_comm_vat :=
                        (NVL (j.ri_prem_vat, 0) - NVL (j.ri_comm_vat, 0)
                        )
                      * (-1);
               rep.ri_wholding_vat := j.ri_wholding_vat * (-1);
               rep.ri_prem_vat := j.ri_prem_vat * (-1);
               rep.ri_comm_vat := j.ri_comm_vat * (-1);
            ELSE
               rep.less_ri_comm_vat :=
                               NVL (j.ri_prem_vat, 0)
                               - NVL (j.ri_comm_vat, 0);
               rep.ri_wholding_vat := j.ri_wholding_vat;
               rep.ri_prem_vat := j.ri_prem_vat;
               rep.ri_comm_vat := j.ri_comm_vat;
            END IF;

            /*IF NVL (i.local_foreign_sw, 'X') = 'L'
            THEN
               IF i.reverse_sw = 'Y' OR i.reverse_date IS NOT NULL
               THEN
                  rep.net_due :=
                       (  NVL (j.less_ri_comm_amt, 0)
                        - NVL (i.prem_tax4, 0)
                        + NVL (i.other_charges, 0)
                       )
                     + (rep.less_ri_comm_vat * -1);
               ELSE
                  rep.net_due :=
                       (  NVL (j.less_ri_comm_amt, 0)
                        - NVL (i.prem_tax4, 0)
                        + NVL (i.other_charges, 0)
                       )
                     + rep.less_ri_comm_vat;
               END IF;
            ELSE
               rep.net_due :=
                    (  NVL (j.less_ri_comm_amt, 0)
                     - NVL (i.prem_tax4, 0)
                     + NVL (i.other_charges, 0)
                     + rep.ri_wholding_vat
                    )
                  + rep.less_ri_comm_vat;
            END IF;*/ --commented out edgar 12/03/2014
            /*edgar 12/03/2014*/
            v_total_due := 0;
            FOR j1 IN (SELECT   t1.peril_seq_no, t1.peril_cd,
                            SUM (NVL (t1.ri_prem_amt, 0)) ri_prem_amt,
                            ROUND (AVG (NVL (t1.ri_comm_rt, 0)),
                                   2) ri_comm_rt,
                            SUM (NVL (t1.ri_comm_amt, 0)) ri_comm_amt,
                            SUM ((  NVL (t1.ri_prem_amt, 0)
                                  - NVL (t1.ri_comm_amt, 0)
                                 )
                                ) less_ri_comm_amt,
                            t1.master_bndr_id master_bndr_id3, t2.ri_prem_vat,
                            t2.ri_comm_vat,
                            (NVL (t2.ri_wholding_vat, 0) * (-1)
                            ) ri_wholding_vat
                       FROM giri_group_binder_peril t1, giri_group_binder t2
                      WHERE t2.master_bndr_id = i.master_bndr_id2
                        AND t1.master_bndr_id = t2.master_bndr_id
                   GROUP BY t1.master_bndr_id,
                            t1.peril_seq_no,
                            t1.peril_cd,
                            t2.ri_prem_vat,
                            t2.ri_comm_vat,
                            t2.ri_wholding_vat)
            LOOP
            v_total_due := v_total_due + j1.less_ri_comm_amt;
            END LOOP;
            
            IF NVL (i.local_foreign_sw, 'X') = 'L'
            THEN
               IF i.reverse_sw = 'Y' OR i.reverse_date IS NOT NULL
               THEN
                  rep.net_due :=
                       (  NVL (v_total_due, 0)
                        - NVL (i.prem_tax4, 0)
                        + NVL (i.other_charges, 0)
                       )
                     + (rep.less_ri_comm_vat * -1);
               ELSE
                  rep.net_due :=
                       (  NVL (v_total_due, 0)
                        - NVL (i.prem_tax4, 0)
                        + NVL (i.other_charges, 0)
                       )
                     + rep.less_ri_comm_vat;
               END IF;
            ELSE
               rep.net_due :=
                    (  NVL (v_total_due, 0)
                     - NVL (i.prem_tax4, 0)
                     + NVL (i.other_charges, 0)
                     + rep.ri_wholding_vat
                    )
                  + rep.less_ri_comm_vat;
            END IF;                  
         /*edgar 12/03/2014*/
            PIPE ROW (rep);
         END LOOP;
      END LOOP;
   END;

   FUNCTION get_report_dtl (
      p_master_bndr_id   giri_group_binder.master_bndr_id%TYPE,
      p_peril_seq_no     giri_frps_peril_grp.peril_seq_no%TYPE, 
      p_peril_cd         giri_group_binder_peril.peril_cd%TYPE, --edgar 12/02/2014
      p_reverse_sw       giri_frps_ri.reverse_sw%TYPE
   )
      RETURN report_details_tab PIPELINED
   AS
      rep   report_details_type;
   BEGIN
      FOR k IN (SELECT   t3.master_bndr_id, t4.peril_seq_no, t4.peril_cd, t4.peril_title, --added peril_cd edgar 12/02/2014
                         SUM (t4.prem_amt) gross_prem
                    FROM giri_frps_ri t3, giri_frps_peril_grp t4
                   WHERE t3.master_bndr_id = p_master_bndr_id
                     --AND t4.peril_seq_no = p_peril_seq_no  --edgar 12/02/2014
                     AND t4.peril_cd = p_peril_cd --edgar 12/02/2014
                     AND t3.line_cd = t4.line_cd
                     AND t3.frps_yy = t4.frps_yy
                     AND t3.frps_seq_no = t4.frps_seq_no
                GROUP BY t3.master_bndr_id, t4.peril_seq_no, t4.peril_cd, t4.peril_title) --added peril_cd edgar 12/02/2014
      LOOP
         rep.master_bndr_id := k.master_bndr_id;
         rep.peril_seq_no := k.peril_seq_no;
         rep.peril_title := k.peril_title;

         IF p_reverse_sw = 'Y'
         THEN
            rep.gross_prem := k.gross_prem * (-1);
         ELSE
            rep.gross_prem := k.gross_prem;
         END IF;

         PIPE ROW (rep);
      END LOOP;
   END;
END girir035_pkg;
/



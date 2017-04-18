CREATE OR REPLACE PACKAGE BODY CPI.giclr207d_pkg
AS
   /*
   **  Created by   :  Steven Ramirez
   **  Date Created : 02.24.2014
   **  Reference By : GICLR207D_PKG - OUTSTANDING LOSS DETAILS
   **  Life is about courage and going into the unknown. Same with this report.
   */
   FUNCTION get_giclr207d_details (p_tran_id NUMBER)
      RETURN giclr207d_tab PIPELINED
   IS
      v_rec          giclr207d_type;
      v_query        VARCHAR2 (10000);
      v_ctr_limit    NUMBER (1);
      v_total_cols   NUMBER (10);
      v_total_loop   NUMBER (10);
      v_date         DATE;
      v_exist        VARCHAR2 (1)     := 'N';
      v_exist_trty   VARCHAR2 (1);
      v_exist_ri     VARCHAR2 (1);

      TYPE v_type IS RECORD (
         claim_id           gicl_claims.claim_id%TYPE,
         assured_name       VARCHAR2 (500),
         policy_no          VARCHAR2 (300),
         claim_no           VARCHAR2 (300),
         pol_eff_date       DATE,
         loss_date          DATE,
         clm_file_date      DATE,
         item_no            NUMBER (9),
         peril_cd           NUMBER (5),
         line_cd            gicl_claims.line_cd%TYPE,
         subline_cd         gicl_claims.subline_cd%TYPE,
         os_loss            NUMBER (16, 2),
         expiry_date        DATE,
         ann_tsi_amt        NUMBER (16, 2),
         col_header1        VARCHAR2 (50),
         sum_col_header1    VARCHAR2 (50),
         ri_cd1             VARCHAR2 (50),
         sum_ri_cd1         VARCHAR2 (50),
         ri_cd_header1      VARCHAR2 (50),
         col_header2        VARCHAR2 (50),
         sum_col_header2    VARCHAR2 (50),
         ri_cd2             VARCHAR2 (50),
         sum_ri_cd2         VARCHAR2 (50),
         ri_cd_header2      VARCHAR2 (50),
         col_header3        VARCHAR2 (50),
         sum_col_header3    VARCHAR2 (50),
         ri_cd3             VARCHAR2 (50),
         sum_ri_cd3         VARCHAR2 (50),
         ri_cd_header3      VARCHAR2 (50),
         col_header4        VARCHAR2 (50),
         sum_col_header4    VARCHAR2 (50),
         ri_cd4             VARCHAR2 (50),
         sum_ri_cd4         VARCHAR2 (50),
         ri_cd_header4      VARCHAR2 (50),
         col_header5        VARCHAR2 (50),
         sum_col_header5    VARCHAR2 (50),
         ri_cd5             VARCHAR2 (50),
         sum_ri_cd5         VARCHAR2 (50),
         ri_cd_header5      VARCHAR2 (50),
         col_header6        VARCHAR2 (50),
         sum_col_header6    VARCHAR2 (50),
         ri_cd6             VARCHAR2 (50),
         sum_ri_cd6         VARCHAR2 (50),
         ri_cd_header6      VARCHAR2 (50),
         col_header7        VARCHAR2 (50),
         sum_col_header7    VARCHAR2 (50),
         ri_cd7             VARCHAR2 (50),
         sum_ri_cd7         VARCHAR2 (50),
         ri_cd_header7      VARCHAR2 (50),
         col_header8        VARCHAR2 (50),
         sum_col_header8    VARCHAR2 (50),
         ri_cd8             VARCHAR2 (50),
         sum_ri_cd8         VARCHAR2 (50),
         ri_cd_header8      VARCHAR2 (50),
         col_header9        VARCHAR2 (50),
         sum_col_header9    VARCHAR2 (50),
         ri_cd9             VARCHAR2 (50),
         sum_ri_cd9         VARCHAR2 (50),
         ri_cd_header9      VARCHAR2 (50),
         col_header10       VARCHAR2 (50),
         sum_col_header10   VARCHAR2 (50),
         ri_cd10            VARCHAR2 (50),
         sum_ri_cd10        VARCHAR2 (50),
         ri_cd_header10     VARCHAR2 (50),
         col_header11       VARCHAR2 (50),
         sum_col_header11   VARCHAR2 (50),
         ri_cd11            VARCHAR2 (50),
         sum_ri_cd11        VARCHAR2 (50),
         ri_cd_header11     VARCHAR2 (50),
         col_header12       VARCHAR2 (50),
         sum_col_header12   VARCHAR2 (50),
         ri_cd12            VARCHAR2 (50),
         sum_ri_cd12        VARCHAR2 (50),
         ri_cd_header12     VARCHAR2 (50),
         col_header13       VARCHAR2 (50),
         sum_col_header13   VARCHAR2 (50),
         ri_cd13            VARCHAR2 (50),
         sum_ri_cd13        VARCHAR2 (50),
         ri_cd_header13     VARCHAR2 (50),
         col_header14       VARCHAR2 (50),
         sum_col_header14   VARCHAR2 (50),
         ri_cd14            VARCHAR2 (50),
         sum_ri_cd14        VARCHAR2 (50),
         ri_cd_header14     VARCHAR2 (50),
         col_header15       VARCHAR2 (50),
         sum_col_header15   VARCHAR2 (50),
         ri_cd15            VARCHAR2 (50),
         sum_ri_cd15        VARCHAR2 (50),
         ri_cd_header15     VARCHAR2 (50),
         col_header16       VARCHAR2 (50),
         sum_col_header16   VARCHAR2 (50),
         ri_cd16            VARCHAR2 (50),
         sum_ri_cd16        VARCHAR2 (50),
         ri_cd_header16     VARCHAR2 (50),
         col_header17       VARCHAR2 (50),
         sum_col_header17   VARCHAR2 (50),
         ri_cd17            VARCHAR2 (50),
         sum_ri_cd17        VARCHAR2 (50),
         ri_cd_header17     VARCHAR2 (50),
         col_header18       VARCHAR2 (50),
         sum_col_header18   VARCHAR2 (50),
         ri_cd18            VARCHAR2 (50),
         sum_ri_cd18        VARCHAR2 (50),
         ri_cd_header18     VARCHAR2 (50),
         col_header19       VARCHAR2 (50),
         sum_col_header19   VARCHAR2 (50),
         ri_cd19            VARCHAR2 (50),
         sum_ri_cd19        VARCHAR2 (50),
         ri_cd_header19     VARCHAR2 (50),
         col_header20       VARCHAR2 (50),
         sum_col_header20   VARCHAR2 (50),
         ri_cd20            VARCHAR2 (50),
         sum_ri_cd20        VARCHAR2 (50),
         ri_cd_header20     VARCHAR2 (50)
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk    v_tab;
   BEGIN
      v_rec.comp_name := giacp.v ('COMPANY_NAME');
      v_rec.comp_add := giacp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT DISTINCT LAST_DAY (TO_DATE (   TO_CHAR (tran_month)
                                            || '-15'
                                            || '-'
                                            || TO_CHAR (tran_year),
                                            'MM-DD-YYYY'
                                           )
                                  )
                    INTO v_date
                    FROM giac_acctrans
                   WHERE tran_id = p_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.as_of_date := NULL;
      END;

      v_rec.as_of_date := 'As of ' || TO_CHAR (v_date, 'fmMonth dd, YYYY');

      BEGIN
         SELECT report_title
           INTO v_rec.rep_title
           FROM giis_reports
          WHERE report_id = 'GICLR207D';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.rep_title := NULL;
      END;

      FOR prime IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.claim_id
                               FROM gicl_claims a, gicl_take_up_hist b
                              WHERE b.acct_tran_id = p_tran_id
                                AND a.claim_id = b.claim_id
                                AND os_loss > 0
                           ORDER BY a.line_cd, a.subline_cd)
      LOOP
         v_query :=
            'SELECT DISTINCT a.claim_id, a.assured_name,
                   a.line_cd
                || ''-''
                || a.subline_cd
                || ''-''
                || a.pol_iss_cd
                || ''-''
                || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                || ''-''
                || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                || ''-''
                || LTRIM (TO_CHAR (a.renew_no, ''09'')) policy_no,
                   a.line_cd
                || ''-''
                || a.subline_cd
                || ''-''
                || a.iss_cd
                || ''-''
                || LTRIM (TO_CHAR (a.clm_yy, ''09''))
                || ''-''
                || LTRIM (TO_CHAR (a.clm_seq_no, ''0999999'')) claim_no,
                a.pol_eff_date, a.loss_date, a.clm_file_date, b.item_no,
                b.peril_cd, a.line_cd, a.subline_cd, b.os_loss, a.expiry_date,
                h.ann_tsi_amt';
         v_ctr_limit := 0;
         v_total_cols := 0;

         BEGIN
            SELECT line_name
              INTO v_rec.line_name
              FROM giis_line
             WHERE line_cd = prime.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_rec.subline_name
              FROM giis_subline
             WHERE line_cd = prime.line_cd AND subline_cd = prime.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.subline_name := NULL;
         END;

         FOR head IN (SELECT DISTINCT a.acct_tran_id, a.share_type,
                                      a.grp_seq_no, a.line_cd, b.subline_cd,
                                      c.trty_name
                                 FROM gicl_reserve_ds_xtr a,
                                      gicl_claims b,
                                      giis_dist_share c
                                WHERE acct_tran_id = p_tran_id
                                  AND a.claim_id = b.claim_id
                                  AND b.line_cd = prime.line_cd
                                  AND b.subline_cd = prime.subline_cd
                                  AND c.line_cd = b.line_cd
                                  AND c.share_type = a.share_type
                                  AND c.share_cd = a.grp_seq_no
                             ORDER BY grp_seq_no)
         LOOP
            v_ctr_limit := v_ctr_limit + 1;
            v_total_cols := v_total_cols + 1;
            v_query :=
                  v_query
               || ', '''
               || head.trty_name
               || ''' col_header'
               || v_total_cols;
            v_exist_trty := 'N';

            FOR trty IN
               (SELECT DISTINCT a.claim_id, a.acct_tran_id, a.share_type,
                                a.grp_seq_no, a.line_cd, a.item_no,
                                a.peril_cd,
                                NVL (a.shr_loss_res_amt, 0) ds_loss_res_amt,
                                a.clm_res_hist_id, a.clm_dist_no
                           FROM gicl_reserve_ds_xtr a
                          WHERE a.acct_tran_id = p_tran_id
                            AND a.claim_id = prime.claim_id
                            AND a.share_type = head.share_type
                            AND a.grp_seq_no = head.grp_seq_no)
            LOOP
               v_exist_trty := 'Y';
               v_query :=
                     v_query
                  || ', '''
                  || trty.ds_loss_res_amt
                  || ''' sum_col_header'
                  || v_total_cols;
               EXIT;
            END LOOP;

            IF v_exist_trty = 'N'
            THEN
               v_query := v_query || ', NULL sum_col_header' || v_total_cols;
            END IF;

            v_exist_ri := 'N';

            FOR ri IN (SELECT a.ri_cd,
                              NVL (a.shr_loss_res_amt, 0) rids_loss_res_amt,
                              b.ri_sname
                         FROM gicl_reserve_rids_xtr a, giis_reinsurer b
                        WHERE 1 = 1
                          AND a.acct_tran_id = p_tran_id
                          AND a.grp_seq_no = 999
                          AND a.ri_cd = b.ri_cd
                          AND a.claim_id = prime.claim_id
                          AND a.grp_seq_no = head.grp_seq_no)
            LOOP
               v_exist_ri := 'Y';
               v_query :=
                     v_query
                  || ', '''
                  || ri.ri_cd
                  || ''' ri_cd'
                  || v_total_cols
                  || ', '''
                  || ri.rids_loss_res_amt
                  || ''' sum_ri_cd'
                  || v_total_cols
                  || ', '''
                  || ri.ri_sname
                  || ''' ri_cd_header'
                  || v_total_cols;
               EXIT;
            END LOOP;

            IF v_exist_ri = 'N'
            THEN
               v_query :=
                     v_query
                  || ', NULL ri_cd'
                  || v_total_cols
                  || ', NULL sum_ri_cd'
                  || v_total_cols
                  || ', NULL ri_cd_header'
                  || v_total_cols;
            END IF;

            IF v_ctr_limit = 4
            THEN
               v_ctr_limit := 0;
            END IF;
         END LOOP;

         IF v_ctr_limit > 0
         THEN
            FOR i IN 1 .. 4 - v_ctr_limit
            LOOP
               v_total_cols := v_total_cols + 1;
               v_query := v_query || ', NULL col_header' || v_total_cols;
               v_query := v_query || ', NULL sum_col_header' || v_total_cols;
               v_query :=
                     v_query
                  || ', NULL ri_cd'
                  || v_total_cols
                  || ', NULL sum_ri_cd'
                  || v_total_cols
                  || ', NULL ri_cd_header'
                  || v_total_cols;
            END LOOP;
         END IF;

         v_total_loop := (20 - v_total_cols) / 4;

         IF v_total_cols < 20
         THEN
            FOR com1 IN 1 .. v_total_loop
            LOOP
               FOR com2 IN 1 .. 4
               LOOP
                  v_total_cols := v_total_cols + 1;
                  v_query := v_query || ', NULL col_header' || v_total_cols;
                  v_query :=
                           v_query || ', NULL sum_col_header' || v_total_cols;
                  v_query :=
                        v_query
                     || ', NULL ri_cd'
                     || v_total_cols
                     || ', NULL sum_ri_cd'
                     || v_total_cols
                     || ', NULL ri_cd_header'
                     || v_total_cols;
               END LOOP;
            END LOOP;
         END IF;

         v_query :=
               v_query
            || ' FROM gicl_claims a,
                                        gicl_take_up_hist b,
                                        gicl_reserve_ds_xtr f,
                                        gicl_intm_itmperil d,
                                        giis_intermediary e,
                                        giis_reinsurer g,
                                        gicl_item_peril h
                                  WHERE b.acct_tran_id = '''
            || p_tran_id
            || ''''
            || ' AND a.claim_id = '''
            || prime.claim_id
            || ''''
            || ' AND a.claim_id = b.claim_id
                                    AND f.claim_id = d.claim_id(+)
                                    AND f.item_no = d.item_no(+)
                                    AND f.peril_cd = d.peril_cd(+)
                                    AND d.intm_no = e.intm_no(+)
                                    AND b.claim_id = f.claim_id(+)
                                    AND b.item_no = f.item_no(+)
                                    AND b.peril_cd = f.peril_cd(+)
                                    AND b.acct_tran_id = f.acct_tran_id(+)
                                    AND os_loss > 0
                                    AND h.claim_id = a.claim_id
                                    AND h.item_no = b.item_no
                                    AND h.peril_cd = b.peril_cd
                                    AND a.line_cd = '''
            || prime.line_cd
            || ''''
            || ' AND a.subline_cd = '''
            || prime.subline_cd
            || ''''
            || ' ORDER BY    a.line_cd
                                        || ''-''
                                        || a.subline_cd
                                        || ''-''
                                        || a.iss_cd
                                        || ''-''
                                        || LTRIM (TO_CHAR (a.clm_yy, ''09''))
                                        || ''-''
                                        || LTRIM (TO_CHAR (a.clm_seq_no, ''0999999''))';

         EXECUTE IMMEDIATE v_query
         BULK COLLECT INTO v_list_bulk;

         IF v_list_bulk.LAST > 0
         THEN
            FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
            LOOP
               v_exist := 'Y';
               v_rec.exist := 'Y';
               v_rec.orig_subline_cd := v_list_bulk (i).subline_cd;
               v_rec.line_cd := v_list_bulk (i).line_cd;
               v_rec.subline_cd := v_list_bulk (i).subline_cd;
               v_rec.claim_id := v_list_bulk (i).claim_id;
               v_rec.assured_name := v_list_bulk (i).assured_name;
               v_rec.policy_no := v_list_bulk (i).policy_no;
               v_rec.claim_no := v_list_bulk (i).claim_no;
               v_rec.pol_eff_date := v_list_bulk (i).pol_eff_date;
               v_rec.loss_date := v_list_bulk (i).loss_date;
               v_rec.clm_file_date := v_list_bulk (i).clm_file_date;
               v_rec.expiry_date := v_list_bulk (i).expiry_date;
               v_rec.item_no := v_list_bulk (i).item_no;
               v_rec.peril_cd := v_list_bulk (i).peril_cd;
               v_rec.os_loss := v_list_bulk (i).os_loss;
               v_rec.orig_os_loss := v_list_bulk (i).os_loss;
               v_rec.ann_tsi_amt := v_list_bulk (i).ann_tsi_amt;
               v_rec.col_header1 := v_list_bulk (i).col_header1;
               v_rec.sum_col_header1 := v_list_bulk (i).sum_col_header1;
               v_rec.col_header2 := v_list_bulk (i).col_header2;
               v_rec.sum_col_header2 := v_list_bulk (i).sum_col_header2;
               v_rec.col_header3 := v_list_bulk (i).col_header3;
               v_rec.sum_col_header3 := v_list_bulk (i).sum_col_header3;
               v_rec.col_header4 := v_list_bulk (i).col_header4;
               v_rec.sum_col_header4 := v_list_bulk (i).sum_col_header4;
               v_rec.ri_cd1 := v_list_bulk (i).ri_cd1;
               v_rec.ri_cd2 := v_list_bulk (i).ri_cd2;
               v_rec.ri_cd3 := v_list_bulk (i).ri_cd3;
               v_rec.ri_cd4 := v_list_bulk (i).ri_cd4;
               v_rec.sum_ri_cd1 := v_list_bulk (i).sum_ri_cd1;
               v_rec.sum_ri_cd2 := v_list_bulk (i).sum_ri_cd2;
               v_rec.sum_ri_cd3 := v_list_bulk (i).sum_ri_cd3;
               v_rec.sum_ri_cd4 := v_list_bulk (i).sum_ri_cd4;
               v_rec.ri_cd_header1 := v_list_bulk (i).ri_cd_header1;
               v_rec.ri_cd_header2 := v_list_bulk (i).ri_cd_header2;
               v_rec.ri_cd_header3 := v_list_bulk (i).ri_cd_header3;
               v_rec.ri_cd_header4 := v_list_bulk (i).ri_cd_header4;

               BEGIN
                  SELECT item_title
                    INTO v_rec.item_title
                    FROM gicl_clm_item
                   WHERE claim_id = v_list_bulk (i).claim_id
                     AND item_no = v_list_bulk (i).item_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_rec.item_title := NULL;
               END;

               BEGIN
                  SELECT peril_name
                    INTO v_rec.peril_name
                    FROM giis_peril
                   WHERE line_cd = v_list_bulk (i).line_cd
                     AND peril_cd = v_list_bulk (i).peril_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_rec.peril_name := NULL;
               END;

               v_rec.intm :=
                  giclr207d_pkg.cf_intm_ri (v_list_bulk (i).claim_id,
                                            v_list_bulk (i).peril_cd,
                                            v_list_bulk (i).item_no
                                           );
               PIPE ROW (v_rec);
               v_rec.orig_os_loss := NULL;

               IF 5 - v_total_loop >= 2
               THEN
                  v_rec.line_cd := v_list_bulk (i).line_cd || '';
                  v_rec.subline_cd := v_list_bulk (i).subline_cd || '_1';
                  v_rec.col_header1 := v_list_bulk (i).col_header5;
                  v_rec.sum_col_header1 := v_list_bulk (i).sum_col_header5;
                  v_rec.col_header2 := v_list_bulk (i).col_header6;
                  v_rec.sum_col_header2 := v_list_bulk (i).sum_col_header6;
                  v_rec.col_header3 := v_list_bulk (i).col_header7;
                  v_rec.sum_col_header3 := v_list_bulk (i).sum_col_header7;
                  v_rec.col_header4 := v_list_bulk (i).col_header8;
                  v_rec.sum_col_header4 := v_list_bulk (i).sum_col_header8;
                  v_rec.ri_cd1 := v_list_bulk (i).ri_cd5;
                  v_rec.ri_cd2 := v_list_bulk (i).ri_cd6;
                  v_rec.ri_cd3 := v_list_bulk (i).ri_cd7;
                  v_rec.ri_cd4 := v_list_bulk (i).ri_cd8;
                  v_rec.sum_ri_cd1 := v_list_bulk (i).sum_ri_cd5;
                  v_rec.sum_ri_cd2 := v_list_bulk (i).sum_ri_cd6;
                  v_rec.sum_ri_cd3 := v_list_bulk (i).sum_ri_cd7;
                  v_rec.sum_ri_cd4 := v_list_bulk (i).sum_ri_cd8;
                  v_rec.ri_cd_header1 := v_list_bulk (i).ri_cd_header5;
                  v_rec.ri_cd_header2 := v_list_bulk (i).ri_cd_header6;
                  v_rec.ri_cd_header3 := v_list_bulk (i).ri_cd_header7;
                  v_rec.ri_cd_header4 := v_list_bulk (i).ri_cd_header8;
                  PIPE ROW (v_rec);
               END IF;

               IF 5 - v_total_loop >= 3
               THEN
                  v_rec.line_cd := v_list_bulk (i).line_cd || '';
                  v_rec.subline_cd := v_list_bulk (i).subline_cd || '_2';
                  v_rec.col_header1 := v_list_bulk (i).col_header9;
                  v_rec.sum_col_header1 := v_list_bulk (i).sum_col_header9;
                  v_rec.col_header2 := v_list_bulk (i).col_header10;
                  v_rec.sum_col_header2 := v_list_bulk (i).sum_col_header10;
                  v_rec.col_header3 := v_list_bulk (i).col_header11;
                  v_rec.sum_col_header3 := v_list_bulk (i).sum_col_header11;
                  v_rec.col_header4 := v_list_bulk (i).col_header12;
                  v_rec.sum_col_header4 := v_list_bulk (i).sum_col_header12;
                  v_rec.ri_cd1 := v_list_bulk (i).ri_cd9;
                  v_rec.ri_cd2 := v_list_bulk (i).ri_cd10;
                  v_rec.ri_cd3 := v_list_bulk (i).ri_cd11;
                  v_rec.ri_cd4 := v_list_bulk (i).ri_cd12;
                  v_rec.sum_ri_cd1 := v_list_bulk (i).sum_ri_cd9;
                  v_rec.sum_ri_cd2 := v_list_bulk (i).sum_ri_cd10;
                  v_rec.sum_ri_cd3 := v_list_bulk (i).sum_ri_cd11;
                  v_rec.sum_ri_cd4 := v_list_bulk (i).sum_ri_cd12;
                  v_rec.ri_cd_header1 := v_list_bulk (i).ri_cd_header9;
                  v_rec.ri_cd_header2 := v_list_bulk (i).ri_cd_header10;
                  v_rec.ri_cd_header3 := v_list_bulk (i).ri_cd_header11;
                  v_rec.ri_cd_header4 := v_list_bulk (i).ri_cd_header12;
                  PIPE ROW (v_rec);
               END IF;

               IF 5 - v_total_loop >= 4
               THEN
                  v_rec.line_cd := v_list_bulk (i).line_cd || '';
                  v_rec.subline_cd := v_list_bulk (i).subline_cd || '_3';
                  v_rec.col_header1 := v_list_bulk (i).col_header13;
                  v_rec.sum_col_header1 := v_list_bulk (i).sum_col_header13;
                  v_rec.col_header2 := v_list_bulk (i).col_header14;
                  v_rec.sum_col_header2 := v_list_bulk (i).sum_col_header14;
                  v_rec.col_header3 := v_list_bulk (i).col_header15;
                  v_rec.sum_col_header3 := v_list_bulk (i).sum_col_header15;
                  v_rec.col_header4 := v_list_bulk (i).col_header16;
                  v_rec.sum_col_header4 := v_list_bulk (i).sum_col_header16;
                  v_rec.ri_cd1 := v_list_bulk (i).ri_cd13;
                  v_rec.ri_cd2 := v_list_bulk (i).ri_cd14;
                  v_rec.ri_cd3 := v_list_bulk (i).ri_cd15;
                  v_rec.ri_cd4 := v_list_bulk (i).ri_cd16;
                  v_rec.sum_ri_cd1 := v_list_bulk (i).sum_ri_cd13;
                  v_rec.sum_ri_cd2 := v_list_bulk (i).sum_ri_cd14;
                  v_rec.sum_ri_cd3 := v_list_bulk (i).sum_ri_cd15;
                  v_rec.sum_ri_cd4 := v_list_bulk (i).sum_ri_cd16;
                  v_rec.ri_cd_header1 := v_list_bulk (i).ri_cd_header13;
                  v_rec.ri_cd_header2 := v_list_bulk (i).ri_cd_header14;
                  v_rec.ri_cd_header3 := v_list_bulk (i).ri_cd_header15;
                  v_rec.ri_cd_header4 := v_list_bulk (i).ri_cd_header16;
                  PIPE ROW (v_rec);
               END IF;

               IF 5 - v_total_loop >= 5
               THEN
                  v_rec.line_cd := v_list_bulk (i).line_cd || '';
                  v_rec.subline_cd := v_list_bulk (i).subline_cd || '_4';
                  v_rec.col_header1 := v_list_bulk (i).col_header17;
                  v_rec.sum_col_header1 := v_list_bulk (i).sum_col_header17;
                  v_rec.col_header2 := v_list_bulk (i).col_header18;
                  v_rec.sum_col_header2 := v_list_bulk (i).sum_col_header18;
                  v_rec.col_header3 := v_list_bulk (i).col_header19;
                  v_rec.sum_col_header3 := v_list_bulk (i).sum_col_header19;
                  v_rec.col_header4 := v_list_bulk (i).col_header20;
                  v_rec.sum_col_header4 := v_list_bulk (i).sum_col_header20;
                  v_rec.ri_cd1 := v_list_bulk (i).ri_cd17;
                  v_rec.ri_cd2 := v_list_bulk (i).ri_cd18;
                  v_rec.ri_cd3 := v_list_bulk (i).ri_cd19;
                  v_rec.ri_cd4 := v_list_bulk (i).ri_cd20;
                  v_rec.sum_ri_cd1 := v_list_bulk (i).sum_ri_cd17;
                  v_rec.sum_ri_cd2 := v_list_bulk (i).sum_ri_cd18;
                  v_rec.sum_ri_cd3 := v_list_bulk (i).sum_ri_cd19;
                  v_rec.sum_ri_cd4 := v_list_bulk (i).sum_ri_cd20;
                  v_rec.ri_cd_header1 := v_list_bulk (i).ri_cd_header17;
                  v_rec.ri_cd_header2 := v_list_bulk (i).ri_cd_header18;
                  v_rec.ri_cd_header3 := v_list_bulk (i).ri_cd_header19;
                  v_rec.ri_cd_header4 := v_list_bulk (i).ri_cd_header20;
                  PIPE ROW (v_rec);
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;

   FUNCTION cf_intm_ri (
      p_claim_id   gicl_claims.claim_id%TYPE,
      p_peril_cd   gicl_intm_itmperil.peril_cd%TYPE,
      p_item_no    gicl_intm_itmperil.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_intm_name     giis_intermediary.intm_name%TYPE;
      v_intm_no       gicl_intm_itmperil.intm_no%TYPE;
      v_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE;
      v_ri_cd         gicl_claims.ri_cd%TYPE;
      v_ri_name       giis_reinsurer.ri_name%TYPE;
      v_intm          VARCHAR2 (300)                       := NULL;
   BEGIN
      FOR i IN (SELECT a.pol_iss_cd
                  FROM gicl_claims a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_pol_iss_cd := i.pol_iss_cd;
      END LOOP;

      IF v_pol_iss_cd = 'RI'
      THEN
         FOR k IN (SELECT g.ri_name, a.ri_cd
                     FROM gicl_claims a, giis_reinsurer g
                    WHERE a.claim_id = p_claim_id AND a.ri_cd = g.ri_cd(+))
         LOOP
            v_intm := (TO_CHAR (k.ri_cd) || CHR (10) || (k.ri_name));
         END LOOP;
      ELSE
         FOR j IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                     FROM gicl_intm_itmperil a, giis_intermediary b
                    WHERE a.intm_no = b.intm_no
                      AND a.claim_id = p_claim_id
                      AND a.peril_cd = p_peril_cd
                      AND a.item_no = p_item_no)
         LOOP
            v_intm :=
                  TO_CHAR (j.intm_no)
               || '/'
               || j.ref_intm_cd
               || CHR (10)
               || j.intm_name
               || CHR (10)
               || '                    '
               || v_intm;
         END LOOP;
      END IF;

      RETURN (v_intm);
   END;

   FUNCTION get_summary (
      p_tran_id      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN giclr207d_summary_tab PIPELINED
   AS
      v_rec   giclr207d_summary_type;
   BEGIN
      FOR i IN (SELECT   SUM (shr_loss_res_amt) ri_loss_amt, share_ri,
                         line_cd6, grp_seq_no4, ri_cd3
                    FROM (SELECT DISTINCT a.acct_tran_id acct_tran_id,
                                          a.grp_seq_no grp_seq_no4,
                                          a.line_cd line_cd6, a.ri_cd ri_cd3,
                                          c.trty_shr_pct share_ri,
                                          b.subline_cd subline_cd6,
                                          a.shr_loss_res_amt
                                     FROM gicl_reserve_rids_xtr a,
                                          gicl_claims b,
                                          giis_trty_panel c
                                    WHERE a.acct_tran_id = p_tran_id
                                      AND a.grp_seq_no <> 999
                                      AND a.shr_loss_res_amt > 0
                                      AND a.line_cd = c.line_cd
                                      AND a.line_cd = p_line_cd
                                      AND b.subline_cd = p_subline_cd
                                      AND a.grp_seq_no = c.trty_seq_no
                                      AND a.ri_cd = c.ri_cd
                                 ORDER BY grp_seq_no4, line_cd6)
                GROUP BY grp_seq_no4, line_cd6, ri_cd3, share_ri
                ORDER BY grp_seq_no4, line_cd6, ri_cd3, share_ri)
      LOOP
         v_rec.share_ri := i.share_ri;
         v_rec.ri_loss_amt := i.ri_loss_amt;

         SELECT trty_name
           INTO v_rec.trty_name
           FROM giis_dist_share
          WHERE share_cd = i.grp_seq_no4 AND line_cd = i.line_cd6;

         SELECT ri_sname
           INTO v_rec.ri_name
           FROM giis_reinsurer
          WHERE ri_cd = i.ri_cd3;

         PIPE ROW (v_rec);
      END LOOP;
   END get_summary;
END;
/



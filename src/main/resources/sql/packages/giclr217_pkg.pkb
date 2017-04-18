CREATE OR REPLACE PACKAGE BODY CPI.giclr217_pkg
AS
   FUNCTION get_giclr217_title (p_extract NUMBER)
      RETURN CHAR
   IS
      --v_addl  VARCHAR2(200);
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR217')
      LOOP
         v_addl := rpt.title;
      END LOOP;

      IF NVL (v_addl, '1') != '1'
      THEN
         IF p_extract = 1
         THEN
            v_addl :=
                   v_addl || CHR (10)
                   || '(BASED ON TOTAL SUM INSURED AMOUNT)';
         ELSE
            v_addl := v_addl || CHR (10) || '(BASED ON LOSS AMOUNT)';
         END IF;
      ELSE
         v_addl := ' ';
      END IF;

      RETURN (UPPER (v_addl));
   END get_giclr217_title;

   FUNCTION get_giclr217_heading (
      p_extract          NUMBER,
      p_param_date       VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_claim_date       VARCHAR2
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_param_date
                   || ' from '
                   || TO_CHAR (p_starting_date, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_ending_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSE
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      END IF;

      RETURN (v_date);
   END get_giclr217_heading;

   FUNCTION get_giclr217_heading2 (
      p_extract          NUMBER,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_claim_date       VARCHAR2
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSE
         v_date := NULL;
      END IF;

      RETURN (v_date);
   END get_giclr217_heading2;

   FUNCTION get_giclr217_line_name (p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      --v_line_name varchar2(20);
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd;

      RETURN (v_line_name);
   END get_giclr217_line_name;

   FUNCTION get_giclr217_record (
       p_claim_date       VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract          NUMBER,
      p_line             VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_param_date       VARCHAR2,
      p_starting_date    VARCHAR2,
      p_subline          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN giclr217_tab PIPELINED
   IS
      v_list             giclr217_type;
      v_not_exist        BOOLEAN       := TRUE;
      v_starting_date    DATE        := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_ending_date      DATE      := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_loss_date_from   DATE     := TO_DATE (p_loss_date_from, 'MM/DD/YYYY');
      v_loss_date_to     DATE       := TO_DATE (p_loss_date_to, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.title := get_giclr217_title (p_extract);
      v_list.starting_date :=
               TO_CHAR (TO_DATE (p_starting_date, 'mm-dd-yyyy'), 'dd-MON-yy');
      v_list.ending_date :=
                 TO_CHAR (TO_DATE (p_ending_date, 'mm-dd-yyyy'), 'dd-MON-yy');
      v_list.heading :=
         get_giclr217_heading (p_extract,
                               p_param_date,
                               v_starting_date,
                               v_ending_date,
                               v_loss_date_from,
                               v_loss_date_to,
                               p_claim_date
                              );
      v_list.heading2 :=
         get_giclr217_heading2 (p_extract,
                                v_loss_date_from,
                                v_loss_date_to,
                                p_claim_date
                               );

      FOR i IN (SELECT   c001.range_from, c001.range_to, c001.line_cd,
                         c001.peril_cd,
                         SUM (NVL (c001.sum_insured, 0)) sum_insured,
                         SUM (NVL (c002.loss, 0)) loss, c003.cnt_clm,
                         c004.peril_name
                    FROM giis_peril c004,
                         (SELECT   SUM (cnt_clm) cnt_clm, line_cd, subline_cd,
                                   peril_cd
                              FROM gicl_loss_profile_ext
                          GROUP BY line_cd, subline_cd, peril_cd) c003,
                         (SELECT   b.range_from, b.range_to, a.line_cd,
                                   a.subline_cd, a.pol_iss_cd, a.issue_yy,
                                   a.pol_seq_no, a.renew_no, a.peril_cd,
                                   SUM (a.tsi_amt) sum_insured
                              FROM gicl_loss_profile_ext2 a,
                                   gicl_loss_profile b
                             WHERE b.line_cd = NVL (p_line, b.line_cd)
                               AND b.user_id = UPPER (p_user)
                               AND NVL (b.subline_cd, '***') =NVL (p_subline, '***')
                               --AND b.subline_cd =
                               --                  NVL (p_subline, b.subline_cd)
                               --ALAIZA
                               AND a.tsi_amt BETWEEN b.range_from AND b.range_to
                          GROUP BY b.range_from,
                                   b.range_to,
                                   a.line_cd,
                                   a.subline_cd,
                                   a.pol_iss_cd,
                                   a.issue_yy,
                                   a.pol_seq_no,
                                   a.renew_no,
                                   a.peril_cd) c001,
                         (SELECT   SUM (a.loss_amt) loss, a.peril_cd,
                                   b.line_cd, b.subline_cd, b.pol_iss_cd,
                                   b.issue_yy, b.pol_seq_no, b.renew_no,
                                   c.range_from, c.range_to
                              FROM gicl_loss_profile_ext3 a,
                                   gicl_claims b,
                                   gicl_loss_profile c
                             WHERE a.claim_id = b.claim_id
                               AND c.line_cd = NVL (p_line, b.line_cd)
                               AND c.user_id = UPPER (p_user)
                               AND NVL (c.subline_cd, '***') = NVL (p_subline, '***')
                               --AND c.subline_cd =
                               --                  NVL (p_subline, c.subline_cd)
                               --ALAIZA
                               AND a.loss_amt BETWEEN c.range_from AND c.range_to
                          GROUP BY a.peril_cd,
                                   b.line_cd,
                                   b.subline_cd,
                                   b.pol_iss_cd,
                                   b.issue_yy,
                                   b.pol_seq_no,
                                   b.renew_no,
                                   c.range_from,
                                   c.range_to) c002
                   WHERE c001.range_from = c002.range_from(+)
                     AND c001.range_to = c002.range_to(+)
                     AND c001.line_cd = c002.line_cd(+)
                     AND c001.subline_cd = c002.subline_cd(+)
                     AND c001.peril_cd = c002.peril_cd(+)
                     AND c003.line_cd = c001.line_cd
                     AND c003.subline_cd = c001.subline_cd
                     AND c003.peril_cd = c001.peril_cd
                     AND c004.line_cd = c001.line_cd
                     AND c004.peril_cd = c001.peril_cd
                GROUP BY c001.range_from,
                         c001.range_to,
                         c001.line_cd,
                         c001.subline_cd,
                         c001.peril_cd,
                         c003.cnt_clm,
                         c004.peril_name)
      LOOP
         v_not_exist := FALSE;
         v_list.range_from := i.range_from;
         v_list.range_to := i.range_to;
         v_list.line_cd := i.line_cd;
         v_list.peril_cd := i.peril_cd;
         v_list.sum_insured := i.sum_insured;
         v_list.loss := i.loss;
         v_list.cnt_clm := i.cnt_clm;
         v_list.peril_name := i.peril_name;
         v_list.line_name := get_giclr217_line_name (i.line_cd);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr217_record;
END;
/



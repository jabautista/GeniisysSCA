CREATE OR REPLACE PACKAGE BODY CPI.covernote_pkg
AS
/********************************** FUNCTION 1 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B240_POLICY_INFORMATION
***********************************************************************************/
   FUNCTION get_policy_info (p_par_id gipi_parlist.par_id%TYPE)
        -- p_days     NUMBER
      --)
   RETURN policy_info_tab PIPELINED
   IS
      v_policy_info   policy_info_type;
   BEGIN
      FOR i IN
         (SELECT b240.line_cd line_cd1,
                 TO_CHAR (SYSDATE, 'FmMonth DD, YYYY') line_cd8,
                 b240.par_id par_id,
                 (   b240.line_cd
                  || '-'
                  || b240.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (b240.par_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (b240.par_seq_no, '099999'))
                  || '-'
                  || LTRIM (TO_CHAR (b240.quote_seq_no, '09'))
                 ) line_cd7,
                 (a020.designation || a020.assd_name || ' ' || a020.assd_name2
                 ) assd_name1,
                 b540.address1 address1, b540.address2 address2,
                 b540.address3 address3, a150.line_name line_name,
                 a210.subline_name subline_name,
                 b540.incept_date incept_date,
                 (DECODE (TO_CHAR (b540.incept_date, 'HH:MI:SS AM'),
                          '12:00:00 AM', '12:00:00 MN',
                          '12:00:00 PM', '12:00:00 NOON',
                          TO_CHAR (b540.incept_date, 'HH:MI:SS AM')
                         )
                 ) incept_time                              --yvette,05182005
                              ,
                 b540.expiry_date expiry_date,
                 (DECODE (TO_CHAR (b540.expiry_date, 'HH:MI:SS AM'),
                          '12:00:00 AM', '12:00:00 MN',
                          '12:00:00 PM', '12:00:00 NOON',
                          TO_CHAR (b540.expiry_date, 'HH:MI:SS AM')
                         )
                 ) expiry_time                              --yvette,05182005
                              ,
                 b540.ref_pol_no ref_pol_no
--ging,06292005
                 ,
                 (DECODE (TO_CHAR (TO_DATE (a210.subline_time, 'SSSSS'),
                                   'HH:MI AM'
                                  ),
                          '12:00 AM', '12:00 AM',
                          '12:00 PM', '12:00 noon',
                          TO_CHAR (TO_DATE (a210.subline_time, 'SSSSS'),
                                   'HH:MI AM'
                                  )
                         )
                 ) subline_time                           --nestor 03/03/2010
                               ,
                 a020.assd_no assd_no,
                 (DECODE (b540.label_tag,
                          NULL, 'In Account Of',
                          'Y', 'Leased To',
                          'In Account Of'
                         )
                 ) label_tag,
                 a020.assd_name assd_name, b540.acct_of_cd acct_of_cd,
                 b540.covernote_expiry covernote_expiry
            FROM gipi_parlist b240,
                 gipi_wpolbas b540,
                 giis_assured a020,
                 giis_line a150,
                 giis_subline a210
           WHERE b240.par_id = TO_NUMBER (p_par_id)
             AND b240.par_id = b540.par_id
             AND a210.line_cd = b540.line_cd
             AND a210.subline_cd = b540.subline_cd
             AND a020.assd_no = b540.assd_no
             AND a150.line_cd = b540.line_cd)
      LOOP
         v_policy_info.line_cd1 := i.line_cd1;
         v_policy_info.line_cd8 := i.line_cd8;
         v_policy_info.par_id := i.par_id;
         v_policy_info.line_cd7 := i.line_cd7;
         v_policy_info.assd_name1 := i.assd_name1;
         v_policy_info.address1 := i.address1;
         v_policy_info.address2 := i.address2;
         v_policy_info.address3 := i.address3;
         v_policy_info.line_name := i.line_name;
         v_policy_info.subline_name := i.subline_name;
         v_policy_info.incept_date := i.incept_date;
         v_policy_info.incept_time := i.incept_time;
         v_policy_info.expiry_date := i.expiry_date;
         v_policy_info.expiry_time := i.expiry_time;
         v_policy_info.ref_pol_no := i.ref_pol_no;
         v_policy_info.subline_time := i.subline_time;
         v_policy_info.assd_no := i.assd_no;
         v_policy_info.label_tag := i.label_tag;
         v_policy_info.acct_of_cd := i.acct_of_cd;
         v_policy_info.covernote_expiry := i.covernote_expiry;
         PIPE ROW (v_policy_info);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_assd_name (p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE)
      RETURN CHAR
   IS
      v_name   VARCHAR2 (550);                  --v 070708; replace 60 to 550
   BEGIN
      FOR g IN (SELECT b.assd_name
                  FROM gipi_wpolbas a, giis_assured b
                 WHERE a.acct_of_cd = b.assd_no
                   AND a.acct_of_cd = p_acct_of_cd
                   AND b.assd_no = p_acct_of_cd)
      LOOP
         v_name := g.assd_name;
      END LOOP;

      RETURN (v_name);
   END;

   FUNCTION get_label_tag (p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE)
      RETURN CHAR
   IS
      v_label   VARCHAR2 (2);
   BEGIN
      FOR a IN (SELECT b.label_tag
                  FROM gipi_wpolbas b, giis_assured c
                 WHERE b.acct_of_cd = c.assd_no
                   AND b.acct_of_cd = p_acct_of_cd)
      LOOP
         v_label := a.label_tag;
      END LOOP;

      RETURN (v_label);
   END;

   FUNCTION get_expiry_date (
      p_incept_date   IN   gipi_wpolbas.incept_date%TYPE,
      p_incept_time        VARCHAR2
   )
      RETURN CHAR
   IS
      v_expiry   CHAR (50);
   BEGIN
      v_expiry :=
           TO_CHAR (p_incept_date, 'fmMonth DD, YYYY') || ' '
           || p_incept_time;
      --to_char(:INCEPT_DATE, 'HH:MI:SS PM');
      RETURN (v_expiry);
   END;

   FUNCTION get_expiry_date_1 (
      p_incept_date   IN   gipi_wpolbas.incept_date%TYPE,
      p_days               NUMBER,
      p_expiry_time        VARCHAR2
   )
      RETURN CHAR
   IS
      v_expiry2   DATE;
      v_expiry    CHAR (50);
   BEGIN
      v_expiry2 := p_incept_date + NVL (p_days, 30);
      v_expiry :=
               TO_CHAR (v_expiry2, 'fmMonth DD, YYYY') || ' '
               || p_expiry_time;
      --  to_char(v_expiry2, 'HH:MI:SS AM');
      RETURN (v_expiry);
   END;

   FUNCTION get_grand_prem (cp_totalprem NUMBER, cs_1 NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      RETURN (NVL (cp_totalprem, 0) + NVL (cs_1, 0));
   END;

   FUNCTION get_header_text
      RETURN CHAR
   IS
   BEGIN
      FOR a IN (SELECT text
                  FROM giis_document
                 WHERE title = 'DOCUMENT_HEADER' AND report_id = 'GIPIR919')
      LOOP
         RETURN (a.text);
      END LOOP;

      RETURN (NULL);
   END;

   FUNCTION get_days (p_days NUMBER)
      RETURN CHAR
   IS
      v_spell   VARCHAR2 (32767);
   BEGIN
      FOR a IN (SELECT    INITCAP (dh_util.spell (NVL (p_days, 30)))
                       || '('
                       || NVL (p_days, 30)
                       || ')' spell
                  FROM DUAL)
      LOOP
         v_spell := a.spell;
      END LOOP;

      IF NVL (p_days, 30) > 1
      THEN
         v_spell := v_spell || ' days';
      ELSE
         v_spell := v_spell || ' day';
      END IF;

      RETURN v_spell;
   END;

   FUNCTION get_footnote (cf_days VARCHAR2)
      RETURN CHAR
   IS
      v_footnote   VARCHAR2 (32767);
   BEGIN
--start of modification: jason 06/13/2008
      SELECT SUBSTR (text, 1, 18) || cf_days || ' ' || SUBSTR (text, 19)
        INTO v_footnote
        FROM giis_document
       WHERE title = 'COVERNOTE_VALIDITY' AND report_id = 'GIPIR919';

      RETURN (v_footnote);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
--end of modification: jason
         v_footnote :=
               '(Not valid beyond '
            || cf_days
            || ' from the date of inception unless '
            || 'extended or renewed in accordance with Section 52 of the Insurance Code.)';
         RETURN (v_footnote);
   END;

   FUNCTION get_expiry_date_2 (
      p_line_cd        IN       gipi_wpolbas.line_cd%TYPE,
      p_incept_date    IN       gipi_wpolbas.incept_date%TYPE,
      p_days                    NUMBER,
      p_subline_time   OUT      giis_subline.subline_time%TYPE
   )
      RETURN CHAR
   IS
      v_expiry2   DATE;
      v_expiry    VARCHAR2 (50);
      v_line2     VARCHAR2 (2);
   BEGIN
      FOR g IN (SELECT line_cd
                  FROM gipi_wpolbas
                 WHERE line_cd = p_line_cd)
      LOOP
         v_line2 := g.line_cd;
      END LOOP;

      v_expiry2 := p_incept_date + NVL (p_days, 30);
      v_expiry := TO_CHAR (v_expiry2, 'fmMonth DD, YYYY');
      RETURN (v_expiry || ' ' || p_subline_time);
   END;

   FUNCTION get_incept_date (
      p_line_cd        IN       gipi_wpolbas.line_cd%TYPE,
      p_incept_date    OUT      gipi_wpolbas.incept_date%TYPE,
      p_subline_time   OUT      giis_subline.subline_time%TYPE
   )
      RETURN CHAR
   IS
      v_line   VARCHAR2 (2);
   BEGIN
      FOR g IN (SELECT line_cd
                  FROM gipi_wpolbas
                 WHERE line_cd = p_line_cd)
      LOOP
         v_line := g.line_cd;
      END LOOP;

      IF v_line = 'FI' OR v_line = 'MN'
      THEN
         --RETURN (to_char(:INCEPT_DATE, 'fmMonth DD, YYYY')||' '||'04:00:00 PM'); nestor 03/03/2010 to display correct time
         RETURN (   TO_CHAR (p_incept_date, 'fmMonth DD, YYYY')
                 || ' '
                 || p_subline_time
                );
      ELSE
         --RETURN (to_char(:INCEPT_DATE, 'fmMonth DD, YYYY')||' '||'12:00:00 MN');nestor 03/03/2010 to display correct time
         RETURN (   TO_CHAR (p_incept_date, 'fmMonth DD, YYYY')
                 || ' '
                 || p_subline_time
                );
      END IF;
   END;

   FUNCTION cg$cf_b2402_fmla
      RETURN NUMBER
   IS
   BEGIN
      RETURN (1);
   END;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B570_WARRRANTIES_AND_CLAUSES
***********************************************************************************/
   FUNCTION get_warranties_clauses (p_par_id gipi_wpolwc.par_id%TYPE)
      RETURN warranties_clauses_tab PIPELINED
   IS
      v_warranties_clauses   warranties_clauses_type;
   BEGIN
      FOR i IN (SELECT   b570.par_id par_id, b570.wc_title wc_title
                    FROM gipi_wpolwc b570
                   WHERE par_id = p_par_id
                ORDER BY b570.print_seq_no)
      LOOP
         v_warranties_clauses.par_id := i.par_id;
         v_warranties_clauses.wc_title := i.wc_title;
         PIPE ROW (v_warranties_clauses);
      END LOOP;

      RETURN;
   END;

   FUNCTION cg$cf_b5702_fmla
      RETURN NUMBER
   IS
   BEGIN
      RETURN (1);
   END;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B490_PERILS
***********************************************************************************/
   FUNCTION get_peril_info (p_par_id gipi_witmperl.par_id%TYPE)
      RETURN peril_info_tab PIPELINED
   IS
      v_peril_info   peril_info_type;
   BEGIN
      FOR i IN (SELECT /*DISTINCT*/ a170.peril_name peril_name, -- added DISTINCT by mjcustodio 08162011
                       b490.item_no item_no, --comment by mjcustodio 08162011
                       b490.par_id par_id,
                       a170.peril_type peril_type, b490.tsi_amt tsi_amt,
                       b490.prem_amt prem_amt, b480.currency_rt currency_rt,
                       b480.item_title, b480.currency_cd,
                       b500.policy_currency
                  FROM gipi_witmperl b490,
                       gipi_witem b480,
                       giis_peril a170,
                       gipi_winvoice b500
                 WHERE b490.par_id = p_par_id
                   AND b490.par_id = b480.par_id
                   AND b490.item_no = b480.item_no
                   AND a170.line_cd = b490.line_cd
                   AND a170.peril_cd = b490.peril_cd
                   AND b500.par_id = b480.par_id
                   ORDER BY a170.peril_name) -- added by mjcustodio 08152011
      LOOP
         v_peril_info.par_id := i.par_id;
         v_peril_info.item_no := i.item_no; -- comment by mjcustodio 08162011
         v_peril_info.peril_name := i.peril_name;
         v_peril_info.peril_type := i.peril_type;
         v_peril_info.tsi_amt := i.tsi_amt;
         v_peril_info.prem_amt := i.prem_amt;
         v_peril_info.currency_cd := i.currency_cd;
         v_peril_info.policy_currency := i.policy_currency;
         PIPE ROW (v_peril_info);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_tsi_spell (
      p_currency_cd   IN   gipi_witem.currency_cd%TYPE,
      cf_total_tsi    IN   NUMBER
   )
      RETURN CHAR
   IS
      v_currency_desc   VARCHAR2 (30);--VARCHAR2 (20); ralphsantiago SR-23569 12192016
      v_tsi             VARCHAR2 (400);
      v_tsi_amt         VARCHAR2 (400);
      v_short_name      giis_currency.short_name%TYPE;
      v_short_name2     giis_currency.short_name%TYPE;
   BEGIN
      FOR c IN (SELECT currency_desc, short_name
                  FROM giis_currency
                 WHERE main_currency_cd = p_currency_cd)
      LOOP
         v_short_name := c.short_name;
         v_currency_desc := 'IN ' || c.currency_desc;
         EXIT;
      END LOOP;

      IF LTRIM ((cf_total_tsi - TRUNC (cf_total_tsi)) * 100) <> 0
      THEN
         FOR b IN (SELECT UPPER (   dh_util.spell (TRUNC (cf_total_tsi))
                                 || ' AND '
                                 || LTRIM (  (  cf_total_tsi
                                              - TRUNC (cf_total_tsi)
                                             )
                                           * 100
                                          )
                                 || '/100 '
                                ) tsi
                     FROM DUAL)
         LOOP
            v_tsi := b.tsi;
         END LOOP;

         v_tsi_amt :=
            LTRIM (   v_tsi
                   || v_currency_desc
                   || ' ('
                   || v_short_name
                   || ' '
                   || TO_CHAR (cf_total_tsi, 'fm99,999,999,999,990.00')
                   || ')'
                  );                              --marion 07162009 for PNBGen
      ELSE
         FOR b IN (SELECT UPPER (dh_util.spell (TRUNC (cf_total_tsi))) tsi
                     FROM DUAL)
         LOOP
            v_tsi := b.tsi;
         END LOOP;

         v_tsi_amt :=
            LTRIM (   v_tsi
                   || ' '
                   || v_currency_desc
                   || ' ('
                   || v_short_name
                   || ' '
                   || TO_CHAR (cf_total_tsi, 'fm99,999,999,999,990.00')
                   || ')'
                  );                              --marion 07162009 for PNBGen
      END IF;

      RETURN (v_tsi_amt);
   END;

   FUNCTION get_total_prem (cp_totalprem OUT NUMBER, cs_totalprem NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      cp_totalprem := NVL (cs_totalprem, 0);
      RETURN (cp_totalprem);
   END;

   FUNCTION get_total_tsi (p_par_id IN gipi_witmperl.par_id%TYPE)
      RETURN NUMBER
   IS
      v_tot_tsi   gipi_witmperl.tsi_amt%TYPE;
   BEGIN
      FOR i IN (SELECT SUM (b490.tsi_amt) tsi_amt
                  FROM gipi_witmperl b490, gipi_witem b480, giis_peril a170
                 WHERE b490.par_id = b480.par_id
                   AND b490.item_no = b480.item_no
                   AND a170.line_cd = b490.line_cd
                   AND a170.peril_cd = b490.peril_cd
                   AND b490.par_id = p_par_id
                   AND a170.peril_type = 'B')
      LOOP
         v_tot_tsi := i.tsi_amt;
      END LOOP;

      RETURN (v_tot_tsi);
   END;

   FUNCTION get_total_tsi_1 (
      p_peril_type   IN   giis_peril.peril_type%TYPE,
      cs_tsiamt           NUMBER
   )
      RETURN NUMBER
   IS
   BEGIN
      IF p_peril_type = 'A'
      THEN
         RETURN (0);
      ELSE
         RETURN (cs_tsiamt);
      END IF;

      RETURN NULL;
   END;

   FUNCTION cg$cf_b4902_fmla
      RETURN NUMBER
   IS
   BEGIN
      RETURN (1);
   END;

   FUNCTION get_prem_curr (
      p_policy_currency   IN       gipi_winvoice.policy_currency%TYPE,
      p_prem_amt          IN         gipi_witmperl.prem_amt%TYPE,
      p_currency_rt       IN       gipi_witem.currency_rt%TYPE
   )
      RETURN NUMBER
   IS
   BEGIN
      IF NVL (p_policy_currency, 'Y') = 'Y'
      THEN
         RETURN (NVL (p_prem_amt, 0));
      ELSE
         RETURN (NVL (p_prem_amt, 0) * p_currency_rt);
      END IF;
   END;

   FUNCTION get_tsi_curr (
      p_policy_currency   IN      gipi_winvoice.policy_currency%TYPE,
      p_tsi_amt           IN      gipi_witmperl.tsi_amt%TYPE,
      p_currency_rt       IN      gipi_witem.currency_rt%TYPE
   )
      RETURN NUMBER
   IS
   BEGIN
      IF NVL (p_policy_currency, 'Y') = 'Y'
      THEN
         RETURN (NVL (p_tsi_amt, 0));
      ELSE
         RETURN (p_tsi_amt * p_currency_rt);
      END IF;
   END;

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B350_DEDUCTIONS
***********************************************************************************/
   FUNCTION get_deductibles (p_par_id gipi_wdeductibles.par_id%TYPE)
      RETURN deductibles_tab PIPELINED
   IS
      v_deductibles   deductibles_type;
   BEGIN
      FOR i IN (SELECT b350.par_id par_id, b350.item_no item_no,
                       a060.deductible_title deductible_title
                  FROM gipi_wdeductibles b350, giis_deductible_desc a060
                 WHERE a060.deductible_cd = b350.ded_deductible_cd
                   AND a060.line_cd = b350.ded_line_cd
                   AND a060.subline_cd = b350.ded_subline_cd
                   AND b350.par_id = p_par_id)
      LOOP
         v_deductibles.par_id := i.par_id;
         v_deductibles.item_no := i.item_no;
         v_deductibles.deductible_title := i.deductible_title;
         PIPE ROW (v_deductibles);
      END LOOP;

      RETURN;
   END;

   FUNCTION cg$cf_b3502_fmla
      RETURN NUMBER
   IS
   BEGIN
      RETURN (1);
   END;

   FUNCTION get_ded_count (
      v_ded_count                NUMBER,
     -- cp_dedcount          IN   NUMBER,
      p_deductible_title   IN   giis_deductible_desc.deductible_title%TYPE
   )
      RETURN VARCHAR2
   IS
   cp_dedcount giis_deductible_desc.deductible_title%TYPE;
   BEGIN
      IF v_ded_count = 1
      THEN
         cp_dedcount := p_deductible_title;
         RETURN (p_deductible_title);
      ELSE
         cp_dedcount := 'various';
         RETURN ('various');
      END IF;

      RETURN NULL;
   END;

/********************************** FUNCTION 5 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B450_TAX_CHARGES
***********************************************************************************/
   FUNCTION get_tax_charges (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN tax_charges_tab PIPELINED
   IS
      v_tax_charges   tax_charges_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b450.par_id par_id, a230.tax_desc tax_desc,
                                b470.tax_amt tax_amt, b470.item_grp
                           FROM gipi_winvoice b450,
                                gipi_winv_tax b470,
                                giis_tax_charges a230,
                                gipi_wpolbas b
                          WHERE b470.par_id = b450.par_id
                            AND b470.item_grp = b450.item_grp
                            AND a230.tax_cd = b470.tax_cd
                            AND a230.line_cd = b470.line_cd
                            AND a230.iss_cd = b470.iss_cd
/*rose 03182009 add table gipi_wpolbas and the necessary conditions*/
                            AND b.par_id = b450.par_id
                            AND b.eff_date BETWEEN a230.eff_start_date
                                               AND a230.eff_end_date
                            AND b450.par_id = p_par_id
                            ORDER BY a230.tax_desc) --- added by mjcustodio 08182011
      LOOP
         v_tax_charges.par_id := i.par_id;
         v_tax_charges.tax_desc := i.tax_desc;
         v_tax_charges.tax_amt := i.tax_amt;
         v_tax_charges.item_grp := i.item_grp;
         PIPE ROW (v_tax_charges);
      END LOOP;

      RETURN;
   END;

   FUNCTION cg$cf_b4502_fmla
      RETURN NUMBER
   IS
   BEGIN
      RETURN (1);
   END;

   FUNCTION get_tax (cp_tax OUT NUMBER, cs_totaltax NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      cp_tax := NVL (cs_totaltax, 0);
      RETURN (cp_tax);
   END;

/********************************** FUNCTION 6 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME:
***********************************************************************************/
   FUNCTION get_agent_code (p_par_id IN gipi_wcomm_invoices.par_id%TYPE)
      RETURN VARCHAR2
   IS
      v_intm_no   VARCHAR2 (2000);
      v_name_sw   VARCHAR2 (1);
      v_parent    VARCHAR2 (300);
   BEGIN
      FOR a IN (SELECT text
                  FROM giis_document
                 WHERE title = 'PRINT_INTM_NAME'
                   AND UPPER (report_id) = 'GIPIR919')
      LOOP
         v_name_sw := a.text;
         EXIT;
      END LOOP;

      FOR c IN (SELECT DISTINCT DECODE (a.parent_intm_no,
                                        NULL, NULL,
                                        TO_CHAR (a.parent_intm_no) || '/'
                                       ) PARENT,
                                TO_CHAR (a.intm_no) intm_name,
                                a.intm_name intm_name2, a.parent_intm_no
                           FROM giis_intermediary a, gipi_wcomm_invoices d
                          WHERE d.par_id = p_par_id
                            AND a.intm_no = d.intrmdry_intm_no)
      --order by intm_name)
      LOOP
         IF v_name_sw = 'Y'
         THEN
            v_parent := NULL;

            FOR b IN (SELECT intm_name || '/' NAME
                        FROM giis_intermediary
                       WHERE intm_no = c.parent_intm_no)
            LOOP
               v_parent := b.NAME;
               EXIT;
            END LOOP;

            IF v_intm_no IS NULL
            THEN
               v_intm_no := v_parent || c.intm_name2;
            ELSE
               v_intm_no := v_intm_no || ', ' || v_parent || c.intm_name2;
            END IF;
         ELSE
            IF v_intm_no IS NULL
            THEN
               v_intm_no := c.PARENT || c.intm_name;
            ELSE
               v_intm_no := v_intm_no || ', ' || c.PARENT || c.intm_name;
            END IF;
         END IF;
      END LOOP;

      RETURN (v_intm_no);
   END;

   FUNCTION get_company_name
      RETURN VARCHAR2
   IS
      v_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
   END;

   FUNCTION get_signatory (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2
   IS
      v_signatory   giis_signatory_names.signatory%TYPE;
      v_line_cd     giis_line.line_cd%TYPE;
      v_iss_cd      giis_signatory.iss_cd%TYPE;
   BEGIN
      SELECT line_cd, iss_cd
        INTO v_line_cd, v_iss_cd
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a IN (SELECT a.signatory
                  FROM giis_signatory_names a, giis_signatory b
                 WHERE a.signatory_id = b.signatory_id
                   AND line_cd = v_line_cd
                   AND iss_cd = v_iss_cd                              --yvette
                   AND current_signatory_sw = 'Y')
      LOOP
         v_signatory := a.signatory;
         EXIT;
      END LOOP;

      RETURN (v_signatory);
   END;

   FUNCTION get_position (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2
   IS
      v_designation   giis_signatory_names.designation%TYPE;
      v_line_cd       giis_line.line_cd%TYPE;
   BEGIN
      SELECT line_cd
        INTO v_line_cd
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a IN (SELECT a.designation
                  FROM giis_signatory_names a, giis_signatory b
                 WHERE a.signatory_id = b.signatory_id
                   AND line_cd = v_line_cd
                   AND current_signatory_sw = 'Y')
      LOOP
         v_designation := a.designation;
         EXIT;
      END LOOP;

      RETURN (v_designation);
   END;

   FUNCTION get_item_title (p_par_id IN gipi_witem.par_id%TYPE)
      RETURN CHAR
   IS
      v_title   gipi_item.item_title%TYPE;
   BEGIN
      v_title := NULL;

      FOR a IN (SELECT item_title
                  FROM gipi_witem
                 WHERE par_id = p_par_id)
      LOOP
         IF v_title IS NULL
         THEN
            v_title := a.item_title;
         ELSE
            v_title := 'VARIOUS';
            EXIT;
         END IF;
      END LOOP;

      RETURN (v_title);
   END;

   FUNCTION get_item_desc (p_par_id IN gipi_witem.par_id%TYPE)
      RETURN CHAR
   IS
      v_desc   gipi_witem.item_desc%TYPE;
   BEGIN
      v_desc := NULL;

      FOR a IN (SELECT item_desc
                  FROM gipi_witem
                 WHERE par_id = p_par_id)
      LOOP
         IF v_desc IS NULL
         THEN
            v_desc := a.item_desc;
         ELSE
            v_desc := 'VARIOUS';
            EXIT;
         END IF;
      END LOOP;

      RETURN (v_desc);
   END;

   FUNCTION get_location (p_par_id IN gipi_wfireitm.par_id%TYPE)
      RETURN CHAR
   IS
      v_loc   VARCHAR2 (300);
   BEGIN
      v_loc := NULL;

      FOR a IN (SELECT (loc_risk1 || loc_risk2 || loc_risk3) LOCATION
                  FROM gipi_wfireitm
                 WHERE par_id = p_par_id)
      LOOP
         IF v_loc IS NULL
         THEN
            v_loc := a.LOCATION;
         ELSE
            v_loc := 'VARIOUS';
            EXIT;
         END IF;
      END LOOP;

      RETURN (v_loc);
   END;

   FUNCTION get_user
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (USER);
   END;
END covernote_pkg;
--/
/



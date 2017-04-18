CREATE OR REPLACE PACKAGE BODY cpi.csv_paid_prem_intm_assd 
AS
   /* Created by: Nestor 05/06/2010, Generate CSV in GIACS286 - PAID PREMIUM PER INTERMEDIARY/ASSURED REPORT */

   FUNCTION csv_giacr286 (
      p_intm_no          gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
      p_cut_off_param    VARCHAR2,
      p_from_date        DATE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_to_date          DATE,
      p_user_id          VARCHAR2     -- jhing added p_user_id GENQA 5298,5299
                                 )
      RETURN giacr286_type
      PIPELINED
   AS
      v_giacr286   giacr286_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT gpcv.branch_cd || ' - ' || giss.iss_name branch,
                      gpol.line_cd || ' - ' || glin.line_name line,
                         gci.intrmdry_intm_no
                      || DECODE(gint.ref_intm_cd, NULL, ' ' , ' - '
                      || gint.ref_intm_cd )
                      || ' - '                      -- jhing added handling for null ref_intm_cd to prevent display of intm_no - - intm_name value
                      || gint.intm_name
                         intm,
                      DECODE (p_cut_off_param,
                              '1', gpcv.tran_date,
                              gpcv.posting_date)
                         ref_date,
                      gpcv.ref_no ref_no,
                         gpol.line_cd
                      || '-'
                      || gpol.subline_cd
                      || '-'
                      || gpol.iss_cd
                      || '-'
                      || LTRIM (TO_CHAR (gpol.issue_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                      || '-'
                      || LTRIM (TO_CHAR (gpol.renew_no, '09'))
                      || DECODE (
                            NVL (gpol.endt_seq_no, 0),
                            0, '',
                               ' / '
                            || gpol.endt_iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (gpol.endt_seq_no, '9999999')))
                         policy_no,
                      gass.assd_name assd_name,
                      gpol.incept_date,
                      gci.iss_cd || '-' || TO_CHAR (gci.prem_seq_no, '099999999999') bill_no,  -- jhing GENQA 5298 added formatting 
                      gci.iss_cd,
                      gci.prem_seq_no,
                      gpcv.collection_amt * gci.share_percentage / 100 coll_amt,
                      gpcv.premium_amt * gci.share_percentage / 100 prem_amt,
                      gpcv.tax_amt * gci.share_percentage / 100 tax_amt,
                      gpcv.tran_id ,
                      gint.intm_no,
                      gint.intm_name,
                      gint.ref_intm_cd
                 FROM giis_assured gass,
                      giis_intermediary gint,
                      giis_line glin,
                      giis_issource giss,
                      gipi_parlist gpar,
                      gipi_polbasic gpol,
                      gipi_comm_invoice gci,
                      giac_premium_colln_v gpcv
                WHERE     1 = 1
                      AND gpar.assd_no = gass.assd_no
                      AND gci.intrmdry_intm_no = gint.intm_no
                      AND gpol.line_cd = glin.line_cd
                      AND gpcv.branch_cd = giss.iss_cd
                      AND gpar.par_id = gpol.par_id
                      AND gpol.policy_id = gci.policy_id
                      AND gci.iss_cd = gpcv.iss_cd
                      AND gci.prem_seq_no = gpcv.prem_seq_no
                      AND gci.intrmdry_intm_no =
                             NVL (p_intm_no, gci.intrmdry_intm_no)
                      AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                      AND gpcv.branch_cd = NVL (p_branch_cd, gpcv.branch_cd)
                      -- AND check_user_per_iss_cd_acctg(NULL, gpcv.branch_cd, 'GIACS286') = 1 --added by reymon 07272012  -- jhing GENQA 5298,5299  commented out and replaced function which uses p_user_id
                      AND NOT EXISTS (
                             SELECT 1 from gipi_endttext tx01
                                                WHERE tx01.policy_id = gpol.policy_id
                                                     AND NVL(tx01.endt_tax,'N') = 'Y'
                      ) 
                      AND EXISTS
                             (SELECT 'X'
                                FROM TABLE (
                                        security_access.get_branch_line (
                                           'AC',
                                           'GIACS286',
                                           p_user_id))
                               WHERE branch_cd = gpcv.branch_cd)
                      AND DECODE (p_cut_off_param,
                                  '1', gpcv.tran_date,
                                  gpcv.posting_date) BETWEEN p_from_date
                                                         AND p_to_date
             UNION ALL 
         SELECT gacc.gibr_branch_cd || ' - ' || giss.iss_name iss_cd1,
                         gpol.line_cd || ' - ' || glin.line_name line,
                            gci.intrmdry_intm_no
                         || DECODE (gint.ref_intm_cd, NULL, ' ', ' - ' || gint.ref_intm_cd)
                         || ' - '
                         || gint.intm_name
                            intm,
                         DECODE (p_cut_off_param, 1, gacc.tran_date, gacc.posting_date)
                            ref_date,
                         get_ref_no (gacc.tran_id) ref_no,
                            gpol.line_cd
                         || '-'
                         || gpol.subline_cd
                         || '-'
                         || gpol.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (gpol.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (gpol.renew_no, '09'))
                         || DECODE (
                               NVL (gpol.endt_seq_no, 0),
                               0, '',
                                  ' / '
                               || gpol.endt_iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gpol.endt_seq_no, '9999999')))
                            policy_no,
                         gass.assd_name,
                         gpol.incept_date,
                         gpinv.iss_cd || '-' || TO_CHAR(gpinv.prem_seq_no, '099999999999') bill_no,
                         gpinv.iss_cd,
                         gpinv.prem_seq_no,
                         SUM (NVL (gpcv.collection_amt * gci.share_percentage / 100, 0))
                            collection_amt,
                         SUM (NVL (gpcv.premium_amt * gci.share_percentage / 100, 0))
                            premium_amt,
                         SUM (NVL (gpcv.tax_amt * gci.share_percentage / 100, 0)) tax_amt,
                         gacc.tran_id,
                         gint.intm_no,
                         gint.intm_name,
                         gint.ref_intm_cd
                    FROM giis_assured gass,
                         giis_intermediary gint,
                         giis_line glin,
                         giis_issource giss,
                         gipi_parlist gpar,
                         gipi_polbasic gpol,
                         gipi_endttext gendt,
                         (SELECT b.line_cd,
                                 b.subline_cd,
                                 b.iss_cd,
                                 b.issue_yy,
                                 b.pol_seq_no,
                                 b.renew_no,
                                 b.endt_seq_no,
                                 a.intrmdry_intm_no,
                                 a.share_percentage
                            FROM gipi_comm_invoice a, gipi_polbasic b, gipi_invoice c
                           WHERE     a.policy_id = b.policy_id
                                 AND b.endt_seq_no = 0
                                 AND b.policy_id = c.policy_id
                                 AND a.iss_cd = c.iss_cd
                                 AND a.prem_seq_no = c.prem_seq_no
                                 AND NVL (c.item_grp, 1) = 1
                                 AND NVL (c.takeup_seq_no, 1) = 1) gci,
                         giac_direct_prem_collns gpcv,
                         gipi_invoice gpinv,
                         giac_acctrans gacc
                   WHERE     1 = 1
                         AND gendt.policy_id = gpol.policy_id
                         AND NVL (gendt.endt_tax, 'N') = 'Y'
                         AND gpol.policy_id = gpinv.policy_id
                         AND gpinv.iss_cd = gpcv.b140_iss_cd
                         AND gpinv.prem_seq_no = gpcv.b140_prem_seq_no
                         AND gpar.assd_no = gass.assd_no
                         AND gpol.line_cd = glin.line_cd
                         AND gacc.gibr_branch_cd = giss.iss_cd
                         AND gpar.par_id = gpol.par_id
                         AND gci.line_cd = gpol.line_cd
                         AND gci.subline_cd = gpol.subline_cd
                         AND gci.iss_cd = gpol.iss_cd
                         AND gci.issue_yy = gpol.issue_yy
                         AND gci.pol_seq_no = gpol.pol_seq_no
                         AND gci.renew_no = gpol.renew_no
                         AND gpcv.gacc_tran_id = gacc.tran_id
                         AND gacc.tran_flag <> 'D'
                         AND NOT EXISTS
                                    (SELECT 'X'
                                       FROM giac_reversals x, giac_acctrans y
                                      WHERE     x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag <> 'D'
                                            AND x.gacc_tran_id = gpcv.gacc_tran_id
                                            -- if parameter is posting date, consider posting date of transaction
                                            AND (   (    y.posting_date BETWEEN p_from_date
                                                                            AND p_to_date
                                                     AND DECODE (p_cut_off_param, '1', 0, 1) =
                                                            1)
                                                 OR (DECODE (p_cut_off_param, '1', 1, 0) = 1)))
                         AND gci.intrmdry_intm_no = NVL (p_intm_no, gci.intrmdry_intm_no)
                         AND gint.intm_no = gci.intrmdry_intm_no
                         AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                         AND gacc.gibr_branch_cd = NVL (p_branch_cd, gacc.gibr_branch_cd)
                         AND DECODE (p_cut_off_param, 1, TRUNC(gacc.tran_date), TRUNC(gacc.posting_date)) BETWEEN p_from_date
                                                                                                 AND p_to_date
                         AND EXISTS
                                (SELECT 'X'
                                   FROM TABLE (
                                           security_access.get_branch_line ('AC',
                                                                            'GIACS286',
                                                                            p_user_id))
                                  WHERE branch_cd = gacc.gibr_branch_cd)
                GROUP BY gacc.gibr_branch_cd,
                         giss.iss_name,
                         gpol.line_cd,
                         gpol.subline_cd,
                         gpol.iss_cd,
                         gpol.issue_yy,
                         gpol.pol_seq_no,
                         gpol.renew_no,
                         gpol.endt_yy,
                         gpol.endt_seq_no,
                         gpinv.iss_cd,
                         gpinv.prem_seq_no,
                         glin.line_name,
                         gci.intrmdry_intm_no,
                         gint.ref_intm_cd,
                         gint.intm_name,
                         gacc.tran_id,
                         gacc.tran_date,
                         gacc.posting_date,
                         gpol.endt_iss_cd,
                         gass.assd_name,
                         gpol.incept_date,
                         gint.intm_no,
                         gint.intm_name,
                         gint.ref_intm_cd                                                            
             ORDER BY branch,line,intm,bill_no,tran_id)
      LOOP
         v_giacr286.branch := rec.branch;
         v_giacr286.line := rec.line;
--         v_giacr286.intm := rec.intm;
         v_giacr286.intm_no := rec.intm_no;
         v_giacr286.intm_name := rec.intm_name;
         v_giacr286.ref_intm_cd := rec.ref_intm_cd;
         v_giacr286.ref_date := rec.ref_date;
        -- v_giacr286.ref_no := rec.ref_no;  -- jhing GENQA 5298,5299
         v_giacr286.ref_no := get_ref_no (rec.tran_id) ;
         v_giacr286.policy_no := rec.policy_no;
         v_giacr286.assd_name := rec.assd_name;
         v_giacr286.incept_date := rec.incept_date;
         v_giacr286.bill_no := rec.bill_no;
         v_giacr286.coll_amt := rec.coll_amt;
         v_giacr286.prem_amt := rec.prem_amt;
         v_giacr286.tax_amt := rec.tax_amt;

         PIPE ROW (v_giacr286);
      END LOOP;

      RETURN;
   END csv_giacr286;

   FUNCTION csv_giacr287_old (
      p_assd_no          giis_assured.assd_no%TYPE,
      p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
      p_cut_off_param    VARCHAR2,
      p_from_date        DATE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_to_date          DATE,
      p_user_id          VARCHAR2     -- jhing added p_user_id GENQA 5298,5299
                                 )
      RETURN giacr287_type
      PIPELINED
   AS
      v_giacr287   giacr287_rec_type;
   BEGIN
      FOR rec
         IN (  SELECT gpcv.branch_cd || ' - ' || giss.iss_name branch,
                      gpol.line_cd || ' - ' || glin.line_name line,
                      gass.assd_no || ' - ' || gass.assd_name assd,
                      gass.assd_no assd_no,
                      DECODE (p_cut_off_param,
                              '1', gpcv.posting_date,
                              gpcv.tran_date)
                         prem_ref_date,
                      gpcv.ref_no prem_ref_no,
                      get_policy_no (gpol.policy_id) policy_no,
                      gint.intm_name intm_name,
                      gpol.incept_date incept_date,
                      gciv.iss_cd || '-' || gciv.prem_seq_no bill_no,
                      gpcv.collection_amt * gciv.share_percentage / 100
                         coll_amt,
                      gpcv.premium_amt * gciv.share_percentage / 100 prem_amt,
                      gpcv.tax_amt * gciv.share_percentage / 100 tax_amt,
                      DECODE (p_cut_off_param,
                              '1', gcpv.posting_date,
                              gcpv.tran_date)
                         comm_ref_date,
                      gcpv.comm_ref_no comm_ref_no,
                      gcpv.comm_amt comm_amt,
                      gcpv.wtax_amt wtax_amt
                 FROM giis_assured gass,
                      giac_premium_colln_v gpcv,
                      gipi_polbasic gpol,
                      giis_intermediary gint,
                      gipi_comm_invoice gciv,
                      giac_comm_paid_v gcpv,
                      giis_issource giss,
                      giis_line glin
                WHERE     1 = 1
                      AND gass.assd_no = NVL (p_assd_no, gass.assd_no)
                      AND gass.assd_no = gpol.assd_no
                      AND gciv.intrmdry_intm_no = gint.intm_no
                      AND gint.intm_no = gcpv.intm_no
                      AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                      AND gpol.line_cd = glin.line_cd
                      AND gpcv.branch_cd = NVL (p_branch_cd, gpcv.branch_cd)
                      -- AND check_user_per_iss_cd_acctg(NULL, gpcv.branch_cd, 'GIACS286') = 1 --added by reymon 07272012
                      AND EXISTS
                             (SELECT 'X'
                                FROM TABLE (
                                        security_access.get_branch_line (
                                           'AC',
                                           'GIACS286',
                                           p_user_id))
                               WHERE branch_cd = gpcv.branch_cd)
                      AND gpol.policy_id = gciv.policy_id
                      AND gciv.prem_seq_no = gpcv.prem_seq_no
                      AND gpcv.prem_seq_no = gcpv.prem_seq_no
                      AND gciv.iss_cd = gpcv.iss_cd
                      AND gpcv.iss_cd = gint.iss_cd
                      AND gint.iss_cd = gcpv.iss_cd
                      AND gpcv.branch_cd = giss.iss_cd
                      AND gcpv.gacc_tran_id = gpcv.tran_id
                      AND DECODE (p_cut_off_param,
                                  '1', gpcv.tran_date,
                                  gpcv.posting_date) BETWEEN p_from_date
                                                         AND p_to_date
             ORDER BY gass.assd_no, line)
      LOOP
         v_giacr287.branch := rec.branch;
         v_giacr287.line := rec.line;
         v_giacr287.assured := rec.assd;
         v_giacr287.prem_ref_date := rec.prem_ref_date;
         v_giacr287.prem_ref_no := rec.prem_ref_no;
         v_giacr287.policy_no := rec.policy_no;
         v_giacr287.intm_name := rec.intm_name;
         v_giacr287.incept_date := rec.incept_date;
         v_giacr287.bill_no := rec.bill_no;
         v_giacr287.coll_amt := rec.coll_amt;
         v_giacr287.prem_amt := rec.prem_amt;
         v_giacr287.tax_amt := rec.tax_amt;
         v_giacr287.comm_ref_date := rec.comm_ref_date;
         v_giacr287.comm_ref_no := rec.comm_ref_no;
         v_giacr287.comm_amt_pd := rec.comm_amt;
         v_giacr287.tax_comm_amt_pd := rec.wtax_amt;

         PIPE ROW (v_giacr287);
      END LOOP;

      RETURN;
   END csv_giacr287_old;

   -- jhing new CSV to address Testing Finding GENQA 5298,5299
   FUNCTION csv_giacr287 (p_assd_no          giis_assured.assd_no%TYPE,
                          p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
                          p_cut_off_param    VARCHAR2,
                          p_from_date        DATE,
                          p_line_cd          gipi_polbasic.line_cd%TYPE,
                          p_to_date          DATE,
                          p_user_id          VARCHAR2)
      RETURN giacr287_type2
      PIPELINED
   AS
      v_giacr287            giacr287_rec_type2;

      TYPE premcollectionrec IS RECORD
      (
         gacc_tran_id     giac_acctrans.tran_id%TYPE,
         collection_amt   NUMBER (20, 2),
         premium_amt      NUMBER (20, 2),
         tax_amt          NUMBER (20, 2),
         branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
         tran_date        giac_acctrans.tran_date%TYPE,
         posting_date     giac_acctrans.posting_date%TYPE
      );

      TYPE v_tab_premcolln IS TABLE OF premcollectionrec;


      TYPE commpaytscolln IS RECORD
      (
         gacc_tran_id    giac_comm_payts.gacc_tran_id%TYPE,
         comm_amt        NUMBER (20, 2),
         wtax_amt        NUMBER (20, 2),
         input_vat_amt   NUMBER (20, 2),
         branch_cd       giac_acctrans.gibr_branch_cd%TYPE,
         tran_date        giac_acctrans.tran_date%TYPE,
         posting_date     giac_acctrans.posting_date%TYPE
      );

      TYPE v_tab_commpaytscolln IS TABLE OF commpaytscolln;


      v_premcolln           v_tab_premcolln;
      v_commcolln           v_tab_commpaytscolln;



      v_cnt_prem_payts      NUMBER;
      v_cnt_comm_payts      NUMBER;
      v_last_intm           giis_intermediary.intm_no%TYPE;
      v_cnt_intm            NUMBER;
      v_last_indx           NUMBER;
      v_branch_accessible   VARCHAR2 (2000);
      v_branch_directprem   VARCHAR2 (2000);
      v_branch_commpayt     VARCHAR2 (2000);


      CURSOR invrecords (
         p_branches_withacc VARCHAR2)
      IS
         WITH inv001
              AS (  SELECT /*+ materialize */
                          gass.assd_no assd_no,
                           get_policy_no (gpol.policy_id) policy_no,
                           gpol.incept_date incept_date,
                           gass.assd_name,
                           glin.line_name,
                           glin.line_cd,
                           ginv.iss_cd,
                           ginv.iss_cd || '-' || TO_CHAR (ginv.prem_seq_no, '099999999999') bill_no,
                           ginv.prem_seq_no,
                           gpol.subline_cd,
                           gpol.issue_yy,
                           gpol.pol_seq_no,
                           gpol.renew_no,
                           gpol.endt_seq_no,
                           gcomm.intrmdry_intm_no intm_no,
                           gcomm.share_percentage,
                           gintm.intm_name
                      FROM giis_assured gass,
                           gipi_polbasic gpol,
                           giis_line glin,
                           gipi_invoice ginv,
                           gipi_comm_invoice gcomm,
                           giis_intermediary gintm
                     WHERE     1 = 1
                           AND gass.assd_no = NVL (p_assd_no, gass.assd_no)
                           AND gass.assd_no = gpol.assd_no
                           AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                           AND gpol.line_cd = glin.line_cd
                           AND gpol.policy_id = ginv.policy_id
                           AND ginv.iss_cd = gcomm.iss_cd
                           AND ginv.prem_seq_no = gcomm.prem_seq_no
                           AND gcomm.intrmdry_intm_no = gintm.intm_no
                           AND NOT EXISTS (
                                SELECT 1 from gipi_endttext tx01
                                    WHERE tx01.policy_id = gpol.policy_id
                                         AND NVL(tx01.endt_tax,'N') = 'Y'
                           )
                  /*ORDER BY gass.assd_no,
                           glin.line_cd,
                           gpol.subline_cd,
                           ginv.iss_cd,
                           gpol.issue_yy,
                           gpol.pol_seq_no,
                           gpol.renew_no,
                           gpol.endt_seq_no,
                           ginv.prem_seq_no,
                           gcomm.intrmdry_intm_no*/
                  UNION
                    SELECT /*+ materialize */
                          gass.assd_no assd_no,
                           get_policy_no (gpol.policy_id) policy_no,
                           gpol.incept_date incept_date,
                           gass.assd_name,
                           glin.line_name,
                           glin.line_cd,
                           ginv.iss_cd,
                           ginv.iss_cd || '-' || TO_CHAR (ginv.prem_seq_no, '099999999999') bill_no,
                           ginv.prem_seq_no,
                           gpol.subline_cd,
                           gpol.issue_yy,
                           gpol.pol_seq_no,
                           gpol.renew_no,
                           gpol.endt_seq_no,
                           gcomm.intrmdry_intm_no intm_no,
                           gcomm.share_percentage,
                           gintm.intm_name
                      FROM giis_assured gass,
                           gipi_polbasic gpol,
                           giis_line glin,
                           gipi_invoice ginv,
                           (SELECT b.line_cd,
                                   b.subline_cd,
                                   b.iss_cd,
                                   b.issue_yy,
                                   b.pol_seq_no,
                                   b.renew_no,
                                   b.endt_seq_no,
                                   a.intrmdry_intm_no,
                                   a.share_percentage
                              FROM gipi_comm_invoice a, gipi_polbasic b, gipi_invoice c 
                             WHERE a.policy_id = b.policy_id AND b.endt_seq_no = 0
                                   AND b.policy_id = c.policy_id
                                   AND a.iss_cd = c.iss_cd
                                   AND a.prem_seq_no = c.prem_seq_no
                                   AND NVL(c.item_grp,1) = 1 
                                   AND NVL(c.takeup_seq_no,1) = 1 ) gcomm,
                           giis_intermediary gintm,
                           gipi_endttext gendt
                     WHERE     1 = 1
                           AND gpol.policy_id = gendt.policy_id
                           AND NVL (gendt.endt_tax, 'N') = 'Y'
                           AND gass.assd_no = NVL (p_assd_no, gass.assd_no)
                           AND gass.assd_no = gpol.assd_no
                           AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                           AND gpol.line_cd = glin.line_cd
                           AND gpol.policy_id = ginv.policy_id
                           AND gpol.line_cd = gcomm.line_cd
                           AND gpol.subline_cd = gcomm.subline_cd
                           AND gpol.iss_cd = gcomm.iss_cd
                           AND gpol.issue_yy = gcomm.issue_yy
                           AND gpol.pol_seq_no = gcomm.pol_seq_no
                           AND gpol.renew_no = gcomm.renew_no
                           AND gcomm.intrmdry_intm_no = gintm.intm_no               
                           )
         SELECT *
           FROM inv001
          WHERE EXISTS
                   (SELECT 1
                      FROM giac_direct_prem_collns ab, giac_acctrans ac
                     WHERE     ab.gacc_tran_id = ac.tran_id
                           AND DECODE (p_cut_off_param,
                                       '1', TRUNC (ac.tran_date),
                                       TRUNC (ac.posting_date)) BETWEEN p_from_date
                                                                    AND p_to_date
                           AND ac.tran_flag != 'D'
                           AND ab.b140_iss_cd = inv001.iss_cd
                           AND ab.b140_prem_seq_no = inv001.prem_seq_no
                           AND ac.gibr_branch_cd =
                                  NVL (p_branch_cd, ac.gibr_branch_cd)
                           AND ac.gibr_branch_cd IN
                                  (SELECT *
                                     FROM TABLE (
                                             split_comma_separated_string (
                                                p_branches_withacc)))
                           AND NOT EXISTS
                                      (SELECT 'X'
                                         FROM giac_reversals x,
                                              giac_acctrans y
                                        WHERE     x.reversing_tran_id =
                                                     y.tran_id
                                              AND y.tran_flag <> 'D'
                                              AND x.gacc_tran_id =
                                                     ab.gacc_tran_id
                                         -- if parameter is posting date, consider posting date of transaction  
                                           AND (   (    y.posting_date BETWEEN p_from_date
                                                                           AND p_to_date
                                                    AND DECODE (
                                                           p_cut_off_param,
                                                           '1', 0,
                                                           1) = 1)
                                                OR (DECODE (p_cut_off_param,
                                                            '1', 1,
                                                            0) = 1))          
                                                   )  ) 
                            ORDER BY inv001.iss_cd, inv001.prem_seq_no, inv001.intm_no , inv001.bill_no;


      CURSOR getdirectprembranch (
         p_branches_withacc    VARCHAR2,
         p_iss_cd              gipi_invoice.iss_cd%TYPE,
         p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE)
      IS
         SELECT DISTINCT ac.gibr_branch_cd branch_cd
           FROM giac_direct_prem_collns ab, giac_acctrans ac
          WHERE     ab.gacc_tran_id = ac.tran_id
                AND DECODE (p_cut_off_param,
                            '1', TRUNC (ac.tran_date),
                            TRUNC (ac.posting_date)) BETWEEN p_from_date
                                                         AND p_to_date
                AND ac.tran_flag != 'D'
                AND ab.b140_iss_cd = p_iss_cd
                AND ab.b140_prem_seq_no = p_prem_seq_no
                AND ac.gibr_branch_cd = NVL (p_branch_cd, ac.gibr_branch_cd)
                AND ac.gibr_branch_cd IN
                       (SELECT *
                          FROM TABLE (
                                  split_comma_separated_string (
                                     p_branches_withacc)))
                AND NOT EXISTS
                           (SELECT 'X'
                              FROM giac_reversals x, giac_acctrans y
                             WHERE     x.reversing_tran_id = y.tran_id
                                   AND y.tran_flag <> 'D'
                                   AND x.gacc_tran_id = ab.gacc_tran_id
                              -- if parameter is posting date, consider posting date of transaction  
                                           AND (   (    y.posting_date BETWEEN p_from_date
                                                                           AND p_to_date
                                                    AND DECODE (
                                                           p_cut_off_param,
                                                           '1', 0,
                                                           1) = 1)
                                                OR (DECODE (p_cut_off_param,
                                                            '1', 1,
                                                            0) = 1))               
                                   );

   BEGIN
      v_premcolln := v_tab_premcolln ();
      v_commcolln := v_tab_commpaytscolln ();
      v_cnt_prem_payts := 0;
      v_cnt_comm_payts := 0;
      v_branch_accessible :=
         csv_paid_prem_intm_assd.get_branch_withaccess ('GIACS286',
                                                        p_user_id);



      FOR rec IN invrecords (v_branch_accessible)
      LOOP
         v_branch_directprem := NULL;

         v_giacr287.assured := rec.assd_name;
         v_giacr287.assd_no := rec.assd_no;
         v_giacr287.line_cd := rec.line_cd;
         v_giacr287.line_name := rec.line_name;
         v_giacr287.policy_no := rec.policy_no;
         v_giacr287.intm_name := rec.intm_name;
         v_giacr287.incept_date := TRUNC (rec.incept_date);
         v_giacr287.bill_no :=
            rec.iss_cd || '-' || TO_CHAR (rec.prem_seq_no, '099999999999');

         -- retrieve intermediary details for adjustment

         FOR curbranch
            IN getdirectprembranch (v_branch_accessible,
                                    rec.iss_cd,
                                    rec.prem_seq_no)
         LOOP
            IF v_branch_directprem IS NULL
            THEN
               v_branch_directprem :=
                  NVL (v_branch_directprem, '') || curbranch.branch_cd;
            ELSE
               v_branch_directprem :=
                  NVL (v_branch_directprem, ',') || curbranch.branch_cd;
            END IF;

            v_cnt_prem_payts := 0;
            v_cnt_comm_payts := 0;

            IF v_cnt_prem_payts > 0
            THEN
               v_premcolln.delete;
            END IF;


            IF v_cnt_comm_payts > 0
            THEN
               v_commcolln.delete;
            END IF;



              -- query premium collections
              SELECT ab.gacc_tran_id,
                     SUM (NVL (ab.collection_amt, 0)) collection_amt,
                     SUM (NVL (ab.premium_amt, 0)) premium_amt,
                     SUM (NVL (ab.tax_amt, 0)) tax_amt,
                     ac.gibr_branch_cd,
                     ac.tran_date, ac.posting_date
                BULK COLLECT INTO v_premcolln
                FROM giac_direct_prem_collns ab, giac_acctrans ac
               WHERE     ab.gacc_tran_id = ac.tran_id
                     AND DECODE (p_cut_off_param,
                                 '1', TRUNC (ac.tran_date),
                                 TRUNC (ac.posting_date)) BETWEEN p_from_date
                                                              AND p_to_date
                     AND ac.tran_flag != 'D'
                     AND ab.b140_iss_cd = rec.iss_cd
                     AND ab.b140_prem_seq_no = rec.prem_seq_no
                     AND ac.gibr_branch_cd = curbranch.branch_cd
                     AND NOT EXISTS
                                (SELECT 'X'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE     x.reversing_tran_id = y.tran_id
                                        AND y.tran_flag <> 'D'
                                        AND x.gacc_tran_id = ab.gacc_tran_id
                                        -- if parameter is posting date, consider posting date of transaction  
                                        AND (   (    y.posting_date BETWEEN p_from_date
                                                                           AND p_to_date
                                                    AND DECODE (
                                                           p_cut_off_param,
                                                           '1', 0,
                                                           1) = 1)
                                                OR (DECODE (p_cut_off_param,
                                                            '1', 1,
                                                            0) = 1))          
                                        )
            GROUP BY ac.gibr_branch_cd, ab.gacc_tran_id, ac.tran_date, ac.posting_date;

            IF SQL%FOUND
            THEN
               v_cnt_prem_payts := v_premcolln.COUNT;
            END IF;



              -- get commission payments
              SELECT gcpt.gacc_tran_id,
                     SUM (gcpt.comm_amt) comm_amt,
                     SUM (gcpt.wtax_amt) wtax_amt,
                     SUM (gcpt.input_vat_amt) input_vat_amt,
                     gacc.gibr_branch_cd,
                     gacc.tran_date, 
                     gacc.posting_date
                BULK COLLECT INTO v_commcolln
                FROM giac_comm_payts gcpt, giac_acctrans gacc
               WHERE     gcpt.gacc_tran_id = gacc.tran_id
                     AND gacc.tran_flag != 'D'
                     AND NOT EXISTS
                                (SELECT c.gacc_tran_id
                                   FROM giac_reversals c, giac_acctrans d
                                  WHERE     c.reversing_tran_id = d.tran_id
                                        AND d.tran_flag != 'D'
                                        AND c.gacc_tran_id = gcpt.gacc_tran_id       
                                        )
                     AND gcpt.iss_cd = rec.iss_cd
                     AND gcpt.prem_seq_no = rec.prem_seq_no
                     AND gacc.gibr_branch_cd = curbranch.branch_cd
                     AND gcpt.intm_no = rec.intm_no
                     /*AND DECODE (p_cut_off_param,
                                 '1', TRUNC (gacc.tran_date),
                                 TRUNC (gacc.posting_date)) BETWEEN p_from_date
                                                                AND p_to_date*/
            GROUP BY gcpt.gacc_tran_id, gacc.gibr_branch_cd, gacc.tran_date, gacc.posting_date
            ORDER BY gacc.gibr_branch_cd, gcpt.gacc_tran_id;

            IF SQL%FOUND
            THEN
               v_cnt_comm_payts := v_commcolln.COUNT;
            END IF;

            v_last_indx := 0;



            -- using premium payment collection as basis check premium and commission records to be pipelined
            FOR ctr IN 1 .. v_premcolln.COUNT
            LOOP
               v_last_indx := ctr;

               BEGIN
                  SELECT branch_cd, branch_name
                    INTO v_giacr287.branch_cd, v_giacr287.branch_name
                    FROM giac_branches
                   WHERE branch_cd = v_premcolln (ctr).branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_giacr287.branch_cd := NULL;
                     v_giacr287.branch_name := NULL;
               END;

--               v_giacr287.prem_ref_date :=
--                  TRUNC (get_ref_date (v_premcolln (ctr).gacc_tran_id));
               IF p_cut_off_param = '1' THEN
                 v_giacr287.prem_ref_date := v_premcolln (ctr).tran_date;
               ELSE
                 v_giacr287.prem_ref_date := v_premcolln (ctr).posting_date;
               END IF;        

               v_giacr287.prem_ref_no :=
                  get_ref_no (v_premcolln (ctr).gacc_tran_id);

                  v_giacr287.coll_amt :=
                     ROUND (
                          (v_premcolln (ctr).collection_amt)
                        * rec.share_percentage
                        / 100,
                        2);
                  v_giacr287.prem_amt :=
                     ROUND (
                          (v_premcolln (ctr).premium_amt)
                        * rec.share_percentage
                        / 100,
                        2);
                  v_giacr287.tax_amt :=
                     ROUND (
                          (v_premcolln (ctr).tax_amt)
                        * rec.share_percentage
                        / 100,
                        2);

               IF v_cnt_comm_payts > 0
               THEN
                  IF v_cnt_comm_payts >= ctr
                  THEN
--                     v_giacr287.comm_ref_date :=
--                        TRUNC (get_ref_date (v_commcolln (ctr).gacc_tran_id));
                     IF p_cut_off_param = '1' THEN
                        v_giacr287.comm_ref_date := v_commcolln (ctr).tran_date;
                     ELSE
                        v_giacr287.comm_ref_date := v_commcolln (ctr).posting_date;
                     END IF;  

                     v_giacr287.comm_ref_no :=
                        get_ref_no (v_commcolln (ctr).gacc_tran_id);
                     v_giacr287.comm_amt_pd := v_commcolln (ctr).comm_amt;
                     v_giacr287.tax_comm_amt_pd := v_commcolln (ctr).wtax_amt;
                  ELSE
                     v_giacr287.comm_ref_date := NULL;
                     v_giacr287.comm_ref_no := NULL;
                     v_giacr287.comm_amt_pd := NULL;
                     v_giacr287.tax_comm_amt_pd := NULL;
                  END IF;
               ELSE
                  v_giacr287.comm_ref_date := NULL;
                  v_giacr287.comm_ref_no := NULL;
                  v_giacr287.comm_amt_pd := NULL;
                  v_giacr287.tax_comm_amt_pd := NULL;
               END IF;


               PIPE ROW (v_giacr287);
            END LOOP;

            -- if there are additional commission payments then pipelined
            IF v_cnt_comm_payts > v_cnt_prem_payts
            THEN
               v_last_indx := v_last_indx + 1;

               FOR ix IN v_last_indx .. v_commcolln.COUNT
               LOOP
                  BEGIN
                     SELECT branch_cd, branch_name
                       INTO v_giacr287.branch_cd, v_giacr287.branch_name
                       FROM giac_branches
                      WHERE branch_cd = v_commcolln (ix).branch_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_giacr287.branch_cd := NULL;
                        v_giacr287.branch_name := NULL;
                  END;


                  v_giacr287.prem_ref_date := NULL;

                  v_giacr287.prem_ref_no := NULL;

                  v_giacr287.coll_amt := NULL;
                  v_giacr287.prem_amt := NULL;
                  v_giacr287.tax_amt := NULL;
--                  v_giacr287.comm_ref_date :=
--                     TRUNC (get_ref_date (v_commcolln (ix).gacc_tran_id));
                  IF p_cut_off_param = '1' THEN
                     v_giacr287.comm_ref_date := v_commcolln (ix).tran_date;
                  ELSE
                     v_giacr287.comm_ref_date := v_commcolln (ix).posting_date;
                  END IF;        

                  v_giacr287.comm_ref_no :=
                     get_ref_no (v_commcolln (ix).gacc_tran_id);
                  v_giacr287.comm_amt_pd := v_commcolln (ix).comm_amt;
                  v_giacr287.tax_comm_amt_pd := v_commcolln (ix).wtax_amt;
                  PIPE ROW (v_giacr287);
               END LOOP;
            END IF;
         END LOOP;



         -- get commission payments of bills whose commission payment is made in another branch. User has access to the branch of the commission
         --====================================================================================================================================

         v_cnt_comm_payts := 0;


         IF v_cnt_comm_payts > 0
         THEN
            v_commcolln.delete;
         END IF;


           -- get commission payments
           SELECT gcpt.gacc_tran_id,
                  SUM (gcpt.comm_amt) comm_amt,
                  SUM (gcpt.wtax_amt) wtax_amt,
                  SUM (gcpt.input_vat_amt) input_vat_amt,
                  gacc.gibr_branch_cd,
                  gacc.tran_date,
                  gacc.posting_date
             BULK COLLECT INTO v_commcolln
             FROM giac_comm_payts gcpt, giac_acctrans gacc
            WHERE     gcpt.gacc_tran_id = gacc.tran_id
                  AND gacc.tran_flag != 'D'
                  AND NOT EXISTS
                             (SELECT c.gacc_tran_id
                                FROM giac_reversals c, giac_acctrans d
                               WHERE     c.reversing_tran_id = d.tran_id
                                     AND d.tran_flag != 'D'
                                     AND c.gacc_tran_id = gcpt.gacc_tran_id)
                  AND gcpt.iss_cd = rec.iss_cd
                  AND gcpt.prem_seq_no = rec.prem_seq_no
                  AND gacc.gibr_branch_cd IN
                         (SELECT *
                            FROM TABLE (
                                    split_comma_separated_string (
                                       v_branch_accessible)))
                  AND gacc.gibr_branch_cd NOT IN
                         (SELECT *
                            FROM TABLE (
                                    split_comma_separated_string (
                                       v_branch_directprem)))
                  AND gcpt.intm_no = rec.intm_no
                  AND DECODE (p_cut_off_param,
                              '1', TRUNC (gacc.tran_date),
                              TRUNC (gacc.posting_date)) BETWEEN p_from_date
                                                             AND p_to_date
                  AND gacc.gibr_branch_cd = NVL (p_branch_cd, gacc.gibr_branch_cd) --SR-5298 remove extra branch : Kevin
                  AND v_giacr287.prem_ref_no LIKE '%'||gacc.gibr_branch_cd||'%' --SR-5298 added to  remove duplicate data : Kevin
         GROUP BY gcpt.gacc_tran_id, gacc.gibr_branch_cd, gacc.tran_date, gacc.posting_date
         ORDER BY gacc.gibr_branch_cd, gcpt.gacc_tran_id;

         IF SQL%FOUND
         THEN
            v_cnt_comm_payts := v_commcolln.COUNT;

            FOR itr IN 1 .. v_commcolln.COUNT
            LOOP
               v_giacr287.prem_ref_date := NULL;
               v_giacr287.prem_ref_no := NULL;

               v_giacr287.coll_amt := NULL;
               v_giacr287.prem_amt := NULL;
               v_giacr287.tax_amt := NULL;

               BEGIN
                  SELECT branch_cd, branch_name
                    INTO v_giacr287.branch_cd, v_giacr287.branch_name
                    FROM giac_branches
                   WHERE branch_cd = v_commcolln (itr).branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_giacr287.branch_cd := NULL;
                     v_giacr287.branch_name := NULL;
               END;

--               v_giacr287.comm_ref_date :=
--                  TRUNC (get_ref_date (v_commcolln (itr).gacc_tran_id));
               IF p_cut_off_param = '1' THEN
                 v_giacr287.comm_ref_date:= v_commcolln (itr).tran_date;
               ELSE
                 v_giacr287.comm_ref_date := v_commcolln (itr).posting_date;
               END IF;       

               v_giacr287.comm_ref_no :=
                  get_ref_no (v_commcolln (itr).gacc_tran_id);
               v_giacr287.comm_amt_pd := v_commcolln (itr).comm_amt;
               v_giacr287.tax_comm_amt_pd := v_commcolln (itr).wtax_amt;

               PIPE ROW (v_giacr287);
            END LOOP;
         END IF;
      END LOOP;

      IF v_cnt_prem_payts > 0
      THEN
         v_premcolln.delete;
      END IF;


      IF v_cnt_comm_payts > 0
      THEN
         v_commcolln.delete;
      END IF;

      RETURN;
   END csv_giacr287;

   FUNCTION get_branch_withaccess (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_branches   VARCHAR2 (2000);
      v_cnt        NUMBER := 0;
   BEGIN
      FOR cur
         IN (SELECT branch_cd
               FROM TABLE (
                       security_access.get_branch_line ('AC',
                                                        p_module_id,
                                                        p_user_id)))
      LOOP
         v_cnt := v_cnt + 1;

         IF v_cnt = 1
         THEN
            v_branches := cur.branch_cd;
         ELSE
            v_branches := v_branches || ',' || cur.branch_cd;
         END IF;
      END LOOP;

      RETURN v_branches;
   END;
END csv_paid_prem_intm_assd;
/
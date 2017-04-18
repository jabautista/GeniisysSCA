CREATE OR REPLACE PACKAGE BODY CPI.giacr287_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.10.2013
    **  Reference By : GIACR287 - PAID PREMIUMS PER ASSD
    */
   FUNCTION get_details_old (
      p_cut_off_param   VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_assd_no         NUMBER,
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;
      
      BEGIN

         SELECT DECODE (p_cut_off_param,
                        1, 'Transaction Date',
                        2, 'Posting Date'
                       )
           INTO v_list.from_to
           FROM DUAL;

         v_list.from_to :=
               v_list.from_to
            || ' from '
            || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                        'fmMonth DD, RRRR'
                       )
            || ' to '
            || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'fmMonth DD, RRRR');
      END;

      FOR i IN (SELECT   gpcv.branch_cd || ' - ' || giss.iss_name branch,
                         gpol.line_cd || ' - ' || glin.line_name line,
                         gass.assd_no || ' - ' || gass.assd_name assd,
                         gass.assd_no,
                         DECODE (p_cut_off_param,
                                 '1', gpcv.posting_date,
                                 gpcv.tran_date
                                ) prem_ref_date,
                         gpcv.ref_no prem_ref_no,
                         get_policy_no (gpol.policy_id) policy_no,
                         gint.intm_name, gpol.incept_date,
                         gciv.iss_cd || '-' || gciv.prem_seq_no bill_no,
                           gpcv.collection_amt
                         * gciv.share_percentage
                         / 100 coll_amt,
                           gpcv.premium_amt
                         * gciv.share_percentage
                         / 100 prem_amt,
                         gpcv.tax_amt * gciv.share_percentage / 100 tax_amt,
                         DECODE (p_cut_off_param,
                                 '1', gpcv.posting_date,
                                 gpcv.tran_date
                                ) comm_ref_date,
                         gpcv.ref_no, gcpv.comm_amt, gcpv.wtax_amt
                    FROM giis_assured gass,
                         giac_premium_colln_v gpcv,
                         gipi_polbasic gpol,
                         giis_intermediary gint,
                         gipi_comm_invoice gciv,
                         giac_comm_paid_v gcpv,
                         giis_issource giss,
                         giis_line glin
                   WHERE 1 = 1
                     AND gass.assd_no = NVL (p_assd_no, gass.assd_no)
                     AND gass.assd_no = gpol.assd_no
                     AND gciv.intrmdry_intm_no = gint.intm_no
                     AND gint.intm_no = gcpv.intm_no
                     AND gpol.line_cd = NVL (p_line_cd, gpol.line_cd)
                     AND gpol.line_cd = glin.line_cd
                     AND gpol.iss_cd = NVL (p_branch_cd, gpol.iss_cd)
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                      gpcv.branch_cd,
                                                      'GIACS286',
                                                      p_user_id
                                                     ) = 1
                     AND gpol.policy_id = gciv.policy_id
                     AND gciv.prem_seq_no = gpcv.prem_seq_no
                     AND gpcv.prem_seq_no = gcpv.prem_seq_no
                     AND gciv.iss_cd = gpcv.iss_cd
                     AND gpcv.branch_cd = giss.iss_cd
                     AND DECODE (p_cut_off_param,
                                 '1', gpcv.tran_date,
                                 gpcv.posting_date
                                ) BETWEEN TO_DATE (p_from_date, 'MM-DD-YYYY')
                                      AND TO_DATE (p_to_date, 'MM-DD-YYYY')
                ORDER BY branch,line,gass.assd_no)
               
      LOOP
         v_list.branch := i.branch;
         v_list.line := i.line;
         v_list.assd_no := i.assd_no;
         v_list.assd := i.assd;
         v_list.prem_ref_date := i.prem_ref_date;
         v_list.prem_ref_no := i.prem_ref_no;
         v_list.bill_no := i.bill_no;
         v_list.coll_amt := i.coll_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.incept_date := i.incept_date;
         v_list.intm_name := i.intm_name;
         v_list.policy_no := i.policy_no;
         v_list.prem_amt := i.prem_amt;
         v_list.comm_ref_date := i.comm_ref_date;
         v_list.ref_no := i.ref_no;
         v_list.tax_amt := i.tax_amt;
         v_list.wtax_amt := i.wtax_amt;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_details_old ;
   
   FUNCTION get_details (
      p_cut_off_param   VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_assd_no         NUMBER,
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
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
      v_from_date           DATE  := TO_DATE (p_from_date, 'MM-DD-YYYY');
      v_to_date             DATE  := TO_DATE (p_to_date, 'MM-DD-YYYY'); 
      v_total_rec           NUMBER := 0 ;


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
                  UNION ALL
                    SELECT /*+ materialize */
                          gass.assd_no assd_no,
                           get_policy_no (gpol.policy_id) policy_no,
                           gpol.incept_date incept_date,
                           gass.assd_name,
                           glin.line_name,
                           glin.line_cd,
                           ginv.iss_cd,
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
                                   AND NVL(c.takeup_seq_no,1) = 1) gcomm,
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
                                       TRUNC (ac.posting_date)) BETWEEN v_from_date
                                                                    AND v_to_date
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
                                           AND (   (    y.posting_date BETWEEN v_from_date
                                                                           AND v_to_date
                                                    AND DECODE (
                                                           p_cut_off_param,
                                                           '1', 0,
                                                           1) = 1)
                                                OR (DECODE (p_cut_off_param,
                                                            '1', 1,
                                                            0) = 1))          
                                                   )  ) 
                            ORDER BY inv001.iss_cd, inv001.prem_seq_no, inv001.intm_no ;


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
                            TRUNC (ac.posting_date)) BETWEEN v_from_date
                                                         AND v_to_date
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
                                           AND (   (    y.posting_date BETWEEN v_from_date
                                                                           AND v_to_date
                                                    AND DECODE (
                                                           p_cut_off_param,
                                                           '1', 0,
                                                           1) = 1)
                                                OR (DECODE (p_cut_off_param,
                                                            '1', 1,
                                                            0) = 1))               
                                   );
      
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;
      
      BEGIN

         SELECT DECODE (p_cut_off_param,
                        1, 'Transaction Date',
                        2, 'Posting Date'
                       )
           INTO v_list.from_to
           FROM DUAL;

         v_list.from_to :=
               v_list.from_to
            || ' from '
            || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                        'fmMonth DD, RRRR'
                       )
            || ' to '
            || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'fmMonth DD, RRRR');
      END;

      v_premcolln := v_tab_premcolln ();
      v_commcolln := v_tab_commpaytscolln ();
      v_cnt_prem_payts := 0;
      v_cnt_comm_payts := 0;
      v_branch_accessible :=
      giacr287_pkg.get_branch_withaccess ('GIACS286',
                                                        p_user_id);

     FOR rec IN invrecords (v_branch_accessible)
      LOOP
         v_branch_directprem := NULL;

         v_list.assd := rec.assd_name;
         v_list.assd_no := rec.assd_no;
--         v_giacr287.line_cd := rec.line_cd;
--         v_giacr287.line_name := rec.line_name;
         v_list.line := rec.line_cd || ' - ' ||  rec.line_name;
         v_list.policy_no := rec.policy_no;
         v_list.intm_name := rec.intm_name;
         v_list.incept_date := TRUNC (rec.incept_date);
         v_list.bill_no :=
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
                     ac.gibr_branch_cd, ac.tran_date, ac.posting_date
                BULK COLLECT INTO v_premcolln
                FROM giac_direct_prem_collns ab, giac_acctrans ac
               WHERE     ab.gacc_tran_id = ac.tran_id
                     AND DECODE (p_cut_off_param,
                                 '1', TRUNC (ac.tran_date),
                                 TRUNC (ac.posting_date)) BETWEEN v_from_date
                                                              AND v_to_date
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
                                        AND (   (    y.posting_date BETWEEN v_from_date
                                                                           AND v_to_date
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
                  SELECT branch_cd || ' - ' || branch_name
                    INTO v_list.branch
                    FROM giac_branches
                   WHERE branch_cd = v_premcolln (ctr).branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.branch := NULL;
               END;

--               v_list.prem_ref_date :=
--                  TRUNC (get_ref_date (v_premcolln (ctr).gacc_tran_id));
               IF p_cut_off_param = '1' THEN
                v_list.prem_ref_date := v_premcolln (ctr).tran_date;
               ELSE
                v_list.prem_ref_date := v_premcolln (ctr).posting_date;
               END IF;                   
               v_list.prem_ref_no :=
                  get_ref_no (v_premcolln (ctr).gacc_tran_id);

                  v_list.coll_amt :=
                     ROUND (
                          (v_premcolln (ctr).collection_amt)
                        * rec.share_percentage
                        / 100,
                        2);
                  v_list.prem_amt :=
                     ROUND (
                          (v_premcolln (ctr).premium_amt)
                        * rec.share_percentage
                        / 100,
                        2);
                  v_list.tax_amt :=
                     ROUND (
                          (v_premcolln (ctr).tax_amt)
                        * rec.share_percentage
                        / 100,
                        2);

               IF v_cnt_comm_payts > 0
               THEN
                  IF v_cnt_comm_payts >= ctr
                  THEN
--                     v_list.comm_ref_date :=
--                        TRUNC (get_ref_date (v_commcolln (ctr).gacc_tran_id));
                    IF p_cut_off_param = '1' THEN
                     v_list.comm_ref_date := v_commcolln (ctr).tran_date;
                    ELSE
                     v_list.comm_ref_date := v_commcolln (ctr).posting_date;
                    END IF;                             
                        
                     v_list.ref_no :=
                        get_ref_no (v_commcolln (ctr).gacc_tran_id);
                     v_list.comm_amt := v_commcolln (ctr).comm_amt;
                     v_list.wtax_amt := v_commcolln (ctr).wtax_amt;
                  ELSE
                     v_list.comm_ref_date := NULL;
                     v_list.ref_no := NULL;
                     v_list.comm_amt := NULL;
                     v_list.wtax_amt := NULL;
                  END IF;
               ELSE
                  v_list.comm_ref_date := NULL;
                  v_list.ref_no := NULL;
                  v_list.comm_amt := NULL;
                  v_list.wtax_amt := NULL;
               END IF;

               v_total_rec := v_total_rec + 1;
               PIPE ROW (v_list);
            END LOOP;

            -- if there are additional commission payments then pipelined
            IF v_cnt_comm_payts > v_cnt_prem_payts
            THEN
               v_last_indx := v_last_indx + 1;

               FOR ix IN v_last_indx .. v_commcolln.COUNT
               LOOP
                  BEGIN
                     SELECT branch_cd || ' - ' || branch_name
                            INTO v_list.branch
                       FROM giac_branches
                      WHERE branch_cd = v_commcolln (ix).branch_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                         v_list.branch := NULL;
                  END;


                  v_list.prem_ref_date := NULL;

                  v_list.prem_ref_no := NULL;

                  v_list.coll_amt := NULL;
                  v_list.prem_amt := NULL;
                  v_list.tax_amt := NULL;
--                  v_list.comm_ref_date :=
--                     TRUNC (get_ref_date (v_commcolln (ix).gacc_tran_id));
                     
                    IF p_cut_off_param = '1' THEN
                     v_list.comm_ref_date := v_commcolln (ix).tran_date;
                    ELSE
                     v_list.comm_ref_date := v_commcolln (ix).posting_date;
                    END IF;                               
                  v_list.ref_no :=
                     get_ref_no (v_commcolln (ix).gacc_tran_id);
                  v_list.comm_amt := v_commcolln (ix).comm_amt;
                  v_list.wtax_amt := v_commcolln (ix).wtax_amt;
                  v_total_rec := v_total_rec + 1;
                  PIPE ROW (v_list);
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
                              TRUNC (gacc.posting_date)) BETWEEN v_from_date
                                                             AND v_to_date
                  AND gacc.gibr_branch_cd = NVL (p_branch_cd, gacc.gibr_branch_cd) --SR-5298 added to remove extra branch : Kevin
                  AND v_list.prem_ref_no LIKE '%'||gacc.gibr_branch_cd||'%' --SR-5298 added to  remove duplicate data : Kevin
         GROUP BY gcpt.gacc_tran_id, gacc.gibr_branch_cd, gacc.tran_date, gacc.posting_date
         ORDER BY gacc.gibr_branch_cd, gcpt.gacc_tran_id;

         IF SQL%FOUND
         THEN
            v_cnt_comm_payts := v_commcolln.COUNT;

            FOR itr IN 1 .. v_commcolln.COUNT
            LOOP
               v_list.prem_ref_date := NULL;
               v_list.prem_ref_no := NULL;

               v_list.coll_amt := NULL;
               v_list.prem_amt := NULL;
               v_list.tax_amt := NULL;

               BEGIN
                   SELECT branch_cd || ' - ' || branch_name
                    INTO v_list.branch
                    FROM giac_branches
                   WHERE branch_cd = v_commcolln (itr).branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                      v_list.branch := NULL;
               END;

--               v_list.comm_ref_date :=
--                  TRUNC (get_ref_date (v_commcolln (itr).gacc_tran_id));
               IF p_cut_off_param = '1' THEN
                 v_list.comm_ref_date := v_commcolln (itr).tran_date;
               ELSE
                 v_list.comm_ref_date := v_commcolln (itr).posting_date;
               END IF;       
               v_list.ref_no :=
                  get_ref_no (v_commcolln (itr).gacc_tran_id);
               v_list.comm_amt := v_commcolln (itr).comm_amt;
               v_list.wtax_amt := v_commcolln (itr).wtax_amt;
               
               v_total_rec := v_total_rec + 1;
               PIPE ROW (v_list);
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
      
      IF  v_total_rec = 0 THEN
        PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;  
    
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
   END get_branch_withaccess;   
   
END giacr287_pkg;
/



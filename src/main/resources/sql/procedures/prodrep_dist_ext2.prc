DROP PROCEDURE CPI.PRODREP_DIST_EXT2;

CREATE OR REPLACE PROCEDURE CPI.Prodrep_Dist_Ext2 (
   p_frm_date        DATE,
   p_to_date         DATE,
   p_module_id       VARCHAR2,
   p_branch_param    VARCHAR2,
   p_user_id         VARCHAR2                  --added by Jomar Diago 06222012
)
AS
   TYPE tab_policy_id IS TABLE OF GIAC_PRODREP_DIST_EXT.policy_id%TYPE;

   TYPE tab_line_cd IS TABLE OF GIAC_PRODREP_DIST_EXT.line_cd%TYPE;

   TYPE tab_subline_cd IS TABLE OF GIAC_PRODREP_DIST_EXT.subline_cd%TYPE;

   TYPE tab_dist_no IS TABLE OF GIAC_PRODREP_DIST_EXT.dist_no%TYPE;

   TYPE tab_dist_seq_no IS TABLE OF GIAC_PRODREP_DIST_EXT.dist_seq_no%TYPE;

   TYPE tab_dist_flag IS TABLE OF GIAC_PRODREP_DIST_EXT.dist_flag%TYPE;

   TYPE tab_item_grp IS TABLE OF GIAC_PRODREP_DIST_EXT.item_grp%TYPE;

   TYPE tab_share_cd IS TABLE OF GIAC_PRODREP_DIST_EXT.share_cd%TYPE;

   TYPE tab_share_type IS TABLE OF GIAC_PRODREP_DIST_EXT.share_type%TYPE;

   TYPE tab_trty_name IS TABLE OF GIAC_PRODREP_DIST_EXT.trty_name%TYPE;

   TYPE tab_trty_yy IS TABLE OF GIAC_PRODREP_DIST_EXT.trty_yy%TYPE;

   TYPE tab_nr_dist_tsi IS TABLE OF GIAC_PRODREP_DIST_EXT.nr_dist_tsi%TYPE;

   TYPE tab_nr_dist_prem IS TABLE OF GIAC_PRODREP_DIST_EXT.nr_dist_prem%TYPE;

   TYPE tab_nr_dist_spct IS TABLE OF GIAC_PRODREP_DIST_EXT.nr_dist_spct%TYPE;

   TYPE tab_tr_dist_tsi IS TABLE OF GIAC_PRODREP_DIST_EXT.tr_dist_tsi%TYPE;

   TYPE tab_tr_dist_prem IS TABLE OF GIAC_PRODREP_DIST_EXT.tr_dist_prem%TYPE;

   TYPE tab_tr_dist_spct IS TABLE OF GIAC_PRODREP_DIST_EXT.tr_dist_spct%TYPE;

   TYPE tab_fa_dist_tsi IS TABLE OF GIAC_PRODREP_DIST_EXT.fa_dist_tsi%TYPE;

   TYPE tab_fa_dist_prem IS TABLE OF GIAC_PRODREP_DIST_EXT.fa_dist_prem%TYPE;

   TYPE tab_fa_dist_spct IS TABLE OF GIAC_PRODREP_DIST_EXT.fa_dist_spct%TYPE;

   TYPE tab_currency_rt IS TABLE OF GIAC_PRODREP_DIST_EXT.currency_rt%TYPE;

   TYPE tab_acct_ent_date IS TABLE OF VARCHAR2 (10);

   --giac_prodrep_dist_ext.acct_ent_date%TYPE;

   TYPE tab_acct_neg_date IS TABLE OF VARCHAR2 (10);

   --giac_prodrep_dist_ext.acct_neg_date%TYPE;

   TYPE tab_policy_no IS TABLE OF GIAC_PRODREP_DIST_EXT.policy_no%TYPE;

   TYPE tab_polbasic_tsi IS TABLE OF GIAC_PRODREP_DIST_EXT.polbasic_tsi%TYPE;

   TYPE tab_polbasic_prem
   IS
      TABLE OF GIAC_PRODREP_DIST_EXT.polbasic_prem%TYPE;

   TYPE tab_item_no IS TABLE OF GIAC_PRODREP_DIST_EXT.item_no%TYPE;

   TYPE tab_iss_cd IS TABLE OF GIAC_PRODREP_DIST_EXT.iss_cd%TYPE;

   TYPE tab_issue_yy IS TABLE OF GIAC_PRODREP_DIST_EXT.issue_yy%TYPE;

   TYPE tab_pol_seq_no IS TABLE OF GIAC_PRODREP_DIST_EXT.pol_seq_no%TYPE;

   TYPE tab_renew_no IS TABLE OF GIAC_PRODREP_DIST_EXT.renew_no%TYPE;

   TYPE tab_endt_iss_cd IS TABLE OF GIAC_PRODREP_DIST_EXT.endt_iss_cd%TYPE;

   TYPE tab_endt_yy IS TABLE OF GIAC_PRODREP_DIST_EXT.endt_yy%TYPE;

   TYPE tab_endt_seq_no IS TABLE OF GIAC_PRODREP_DIST_EXT.endt_seq_no%TYPE;

   TYPE tab_pol_acct_ent_date IS TABLE OF VARCHAR2 (10);

   ---giac_prodrep_dist_ext.pol_acct_ent_date%TYPE;

   TYPE tab_pol_spld_acct_ent_date IS TABLE OF VARCHAR2 (10);

   ---giac_prodrep_dist_ext.pol_spld_acct_ent_date%TYPE;

   vv_policy_id                tab_policy_id;
   vv_line_cd                  tab_line_cd;
   vv_subline_cd               tab_subline_cd;
   vv_dist_no                  tab_dist_no;
   vv_dist_seq_no              tab_dist_seq_no;
   vv_dist_flag                tab_dist_flag;
   vv_item_grp                 tab_item_grp;
   vv_share_cd                 tab_share_cd;
   vv_share_type               tab_share_type;
   vv_trty_name                tab_trty_name;
   vv_trty_yy                  tab_trty_yy;
   vv_nr_dist_tsi              tab_nr_dist_tsi;
   vv_nr_dist_prem             tab_nr_dist_prem;
   vv_nr_dist_spct             tab_fa_dist_spct;
   vv_tr_dist_tsi              tab_tr_dist_tsi;
   vv_tr_dist_prem             tab_tr_dist_prem;
   vv_tr_dist_spct             tab_fa_dist_spct;
   vv_fa_dist_tsi              tab_fa_dist_tsi;
   vv_fa_dist_prem             tab_fa_dist_prem;
   vv_fa_dist_spct             tab_fa_dist_spct;
   vv_currency_rt              tab_currency_rt;
   vv_acct_ent_date            tab_acct_ent_date;
   vv_acct_neg_date            tab_acct_neg_date;
   vv_policy_no                tab_policy_no;
   vv_polbasic_tsi             tab_polbasic_tsi;
   vv_polbasic_prem            tab_polbasic_prem;
   vv_item_no                  tab_item_no;
   vv_iss_cd                   tab_iss_cd;
   vv_issue_yy                 tab_issue_yy;
   vv_pol_seq_no               tab_pol_seq_no;
   vv_renew_no                 tab_renew_no;
   vv_endt_iss_cd              tab_endt_iss_cd;
   vv_endt_yy                  tab_endt_yy;
   vv_endt_seq_no              tab_endt_seq_no;
   vv_pol_acct_ent_date        tab_pol_acct_ent_date;
   vv_pol_spld_acct_ent_date   tab_pol_spld_acct_ent_date;
   --p_frm_date                 DATE := '01-JAN-02';
   --p_to_date                  DATE := '31-JAN-02' ;
   v_date                      VARCHAR2 (10);
   v_from_date                 VARCHAR2 (10);
   v_to_date                   VARCHAR2 (10);
BEGIN
   DELETE   GIAC_PRODREP_DIST_EXT
    WHERE   USER_ID = p_user_id;

   COMMIT;

   SELECT   DISTINCT
            A.policy_id AS policy_id,
            b.line_cd AS line_cd,
            b.subline_cd AS subline_cd,
            A.dist_no AS dist_no,
            C.dist_seq_no AS dist_seq_no,
            A.dist_flag AS dist_flag,
            C.item_grp AS item_grp,
            d.share_cd AS share_cd,
            f.share_type AS share_type,
            f.trty_name AS trty_name,
            f.trty_yy AS trty_yy,
            DECODE (A.acct_neg_date,
                    p_to_date, DECODE (f.share_type, '1', d.dist_tsi * (-1)),
                    DECODE (f.share_type, '1', d.dist_tsi))
               AS nr_dist_tsi,
            DECODE (A.acct_neg_date,
                    p_to_date,
                    DECODE (f.share_type, '1', d.dist_prem * (-1)),
                    DECODE (f.share_type, '1', d.dist_prem))
               AS nr_dist_prem,
            DECODE (f.share_type, '1', d.dist_spct) AS nr_dist_spct,
            DECODE (A.acct_neg_date,
                    p_to_date, DECODE (f.share_type, '2', d.dist_tsi * (-1)),
                    DECODE (f.share_type, '2', d.dist_tsi))
               AS tr_dist_tsi,
            DECODE (A.acct_neg_date,
                    p_to_date,
                    DECODE (f.share_type, '2', d.dist_prem * (-1)),
                    DECODE (f.share_type, '2', d.dist_prem))
               AS tr_dist_prem,
            DECODE (f.share_type, '2', d.dist_spct) AS tr_dist_spct,
            DECODE (A.acct_neg_date,
                    p_to_date, DECODE (f.share_type, '3', d.dist_tsi * (-1)),
                    DECODE (f.share_type, '3', d.dist_tsi))
               AS fa_dist_tsi,
            DECODE (A.acct_neg_date,
                    p_to_date,
                    DECODE (f.share_type, '3', d.dist_prem * (-1)),
                    DECODE (f.share_type, '3', d.dist_prem))
               AS fa_dist_prem,
            DECODE (f.share_type, '3', d.dist_spct) AS fa_dist_spct,
            e.currency_rt AS currency_rt,
            TO_CHAR (A.acct_ent_date, 'MM-DD-YYYY') AS acct_ent_date,
            TO_CHAR (A.acct_neg_date, 'MM-DD-YYYY') AS acct_neg_date,
            TO_CHAR (b.acct_ent_date, 'MM-DD-YYYY') AS pol_acct_ent_date,
            TO_CHAR (b.spld_acct_ent_date, 'MM-DD-YYYY')
               AS spld_acct_ent_date,
            DECODE (
               b.endt_seq_no,
               0,
               SUBSTR (
                     b.line_cd
                  || '-'
                  || b.subline_cd
                  || '-'
                  || b.iss_cd
                  || '-'
                  || LPAD (TO_CHAR (b.issue_yy), 2, '00')
                  || '-'
                  || LPAD (TO_CHAR (b.pol_seq_no), 7, '0000000'),
                  1,
                  50
               )
               || '-'
               || LPAD (TO_CHAR (b.renew_no), 2, '00'),
               SUBSTR (
                     b.line_cd
                  || '-'
                  || b.subline_cd
                  || '-'
                  || b.iss_cd
                  || '-'
                  || LPAD (TO_CHAR (b.issue_yy), 2, '00')
                  || '-'
                  || LPAD (TO_CHAR (b.pol_seq_no), 7, '0000000')
                  || '-'
                  || b.endt_iss_cd
                  || '-'
                  || LPAD (TO_CHAR (b.endt_yy), 2, '00')
                  || '-'
                  || LPAD (TO_CHAR (b.endt_seq_no), 7, '0000000')
                  || '-'
                  || LPAD (TO_CHAR (b.renew_no), 2, '00'),
                  1,
                  50
               )
            )
               AS policy_no,
            b.tsi_amt AS tsi_amt,
            b.prem_amt AS prem_amt,
            b.endt_seq_no AS endt_seq_no,
            --b.iss_cd AS iss_cd,
            DECODE (p_branch_param, 'I', b.iss_cd, b.cred_branch) AS iss_cd, -- Added by Jomar Diago 06222012
            b.issue_yy AS issue_yy,
            b.pol_seq_no AS pol_seq_no,
            b.renew_no AS renew_no,
            b.endt_iss_cd AS endt_iss_cd,
            b.endt_yy AS endt_yy
     BULK   COLLECT
     INTO   vv_policy_id,
            vv_line_cd,
            vv_subline_cd,
            vv_dist_no,
            vv_dist_seq_no,
            vv_dist_flag,
            vv_item_grp,
            vv_share_cd,
            vv_share_type,
            vv_trty_name,
            vv_trty_yy,
            vv_nr_dist_tsi,
            vv_nr_dist_prem,
            vv_nr_dist_spct,
            vv_tr_dist_tsi,
            vv_tr_dist_prem,
            vv_tr_dist_spct,
            vv_fa_dist_tsi,
            vv_fa_dist_prem,
            vv_fa_dist_spct,
            vv_currency_rt,
            vv_acct_ent_date,
            vv_acct_neg_date,
            vv_pol_acct_ent_date,
            vv_pol_spld_acct_ent_date,
            vv_policy_no,
            vv_polbasic_tsi,
            vv_polbasic_prem,
            vv_endt_seq_no,
            vv_iss_cd,
            vv_issue_yy,
            vv_pol_seq_no,
            vv_renew_no,
            vv_endt_iss_cd,
            vv_endt_yy
     FROM   GIIS_DIST_SHARE f,
            GIPI_ITEM e,
            GIPI_POLBASIC b,
            GIUW_POLICYDS C,
            GIUW_POLICYDS_DTL d,
            GIUW_POL_DIST A
    WHERE       A.policy_id = b.policy_id
            AND A.dist_no = C.dist_no
            AND C.dist_no = d.dist_no
            AND C.dist_seq_no = d.dist_seq_no
            AND A.policy_id = e.policy_id
            AND C.item_grp = e.item_grp
            AND d.line_cd = f.line_cd
            AND d.share_cd = f.share_cd
            /*AND Check_User_Per_Iss_Cd2 (b.line_cd,
                                        NVL (b.cred_branch, b.iss_cd),
                                        p_module_id,
                                        p_user_id) = 1*/
            /*AND Check_User_Per_Line2 (b.line_cd,
                                      NVL (b.cred_branch, b.iss_cd),
                                      p_module_id,
                                      p_user_id) = 1*/
            AND check_user_per_iss_cd_acctg2 (
                  NULL,
                  DECODE (p_branch_param, 'I', b.iss_cd, b.cred_branch),
                  p_module_id,
                  p_user_id
               ) = 1                          -- Added by Jomar Diago 06222012
            AND ( (A.acct_ent_date >= p_frm_date
                   AND A.acct_ent_date <= p_to_date)
                 OR (A.acct_neg_date >= p_frm_date
                     AND A.acct_neg_date <= p_to_date));

   IF SQL%FOUND
   THEN
      v_date := TO_CHAR (SYSDATE, 'MM-DD-YYYY');
      v_from_date := TO_CHAR (p_frm_date, 'MM-DD-YYYY');
      v_to_date := TO_CHAR (p_to_date, 'MM-DD-YYYY');

      FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
         INSERT INTO GIAC_PRODREP_DIST_EXT (POLICY_ID,
                                            LINE_CD,
                                            SUBLINE_CD,
                                            DIST_NO,
                                            DIST_SEQ_NO,
                                            DIST_FLAG,
                                            ITEM_GRP,
                                            SHARE_CD,
                                            SHARE_TYPE,
                                            TRTY_NAME,
                                            TRTY_YY,
                                            ACCT_ENT_DATE,
                                            NR_DIST_TSI,
                                            NR_DIST_PREM,
                                            NR_DIST_SPCT,
                                            TR_DIST_TSI,
                                            TR_DIST_PREM,
                                            TR_DIST_SPCT,
                                            FA_DIST_TSI,
                                            FA_DIST_PREM,
                                            FA_DIST_SPCT,
                                            CURRENCY_RT,
                                            POLICY_NO,
                                            ACCT_NEG_DATE,
                                            ENDT_SEQ_NO,
                                            POLBASIC_TSI,
                                            POLBASIC_PREM,
                                            ISS_CD,
                                            ISSUE_YY,
                                            POL_SEQ_NO,
                                            RENEW_NO,
                                            ENDT_ISS_CD,
                                            ENDT_YY,
                                            POL_ACCT_ENT_DATE,
                                            POL_SPLD_ACCT_ENT_DATE,
                                            USER_ID,
                                            LAST_UPDATE,
                                            FROM_DATE1,
                                            TO_DATE1)
           VALUES   (vv_policy_id (i),
                     vv_line_cd (i),
                     vv_subline_cd (i),
                     vv_dist_no (i),
                     vv_dist_seq_no (i),
                     vv_dist_flag (i),
                     vv_item_grp (i),
                     vv_share_cd (i),
                     vv_share_type (i),
                     vv_trty_name (i),
                     vv_trty_yy (i),
                     TO_DATE (vv_acct_ent_date (i), 'MM-DD-YYYY'),
                     vv_nr_dist_tsi (i),
                     vv_nr_dist_prem (i),
                     vv_nr_dist_spct (i),
                     vv_tr_dist_tsi (i),
                     vv_tr_dist_prem (i),
                     vv_tr_dist_spct (i),
                     vv_fa_dist_tsi (i),
                     vv_fa_dist_prem (i),
                     vv_fa_dist_spct (i),
                     vv_currency_rt (i),
                     vv_policy_no (i),
                     TO_DATE (vv_acct_neg_date (i), 'MM-DD-YYYY'),
                     vv_endt_seq_no (i),
                     vv_polbasic_tsi (i),
                     vv_polbasic_prem (i),
                     vv_iss_cd (i),
                     vv_issue_yy (i),
                     vv_pol_seq_no (i),
                     vv_renew_no (i),
                     vv_endt_iss_cd (i),
                     vv_endt_yy (i),
                     TO_DATE (vv_pol_acct_ent_date (i), 'MM-DD-YYYY'),
                     TO_DATE (vv_pol_spld_acct_ent_date (i), 'MM-DD-YYYY'),
                     p_user_id,
                     TO_DATE (v_date, 'MM-DD-YYYY'),
                     TO_DATE (v_from_date, 'MM-DD-YYYY'),
                     TO_DATE (v_to_date, 'MM-DD-YYYY'));
   END IF;

   COMMIT;
END;
/



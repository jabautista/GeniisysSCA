DROP PROCEDURE CPI.PRODREP_PERIL_EXT;

CREATE OR REPLACE PROCEDURE CPI.Prodrep_Peril_Ext(p_from_date  DATE,
                                         p_to_date    DATE) AS
 TYPE tab_policy_id               IS TABLE OF giac_prodrep_peril_ext.policy_id%TYPE;
 TYPE tab_line_cd                 IS TABLE OF giac_prodrep_peril_ext.line_cd%TYPE;
 TYPE tab_subline_cd              IS TABLE OF giac_prodrep_peril_ext.subline_cd%TYPE;
 TYPE tab_dist_no                 IS TABLE OF giac_prodrep_peril_ext.dist_no%TYPE;
 TYPE tab_dist_seq_no             IS TABLE OF giac_prodrep_peril_ext.dist_seq_no%TYPE;
 TYPE tab_share_cd                IS TABLE OF giac_prodrep_peril_ext.share_cd%TYPE;
 TYPE tab_share_type              IS TABLE OF giac_prodrep_peril_ext.share_type%TYPE;
 TYPE tab_trty_name               IS TABLE OF giac_prodrep_peril_ext.trty_name%TYPE;
 TYPE tab_trty_yy                 IS TABLE OF giac_prodrep_peril_ext.trty_yy%TYPE;
 TYPE tab_nr_dist_tsi             IS TABLE OF giac_prodrep_peril_ext.nr_dist_tsi%TYPE;
 TYPE tab_nr_dist_prem            IS TABLE OF giac_prodrep_peril_ext.nr_dist_prem%TYPE;
 TYPE tab_nr_dist_spct            IS TABLE OF giac_prodrep_peril_ext.nr_dist_spct%TYPE;
 TYPE tab_tr_dist_tsi             IS TABLE OF giac_prodrep_peril_ext.tr_dist_tsi%TYPE;
 TYPE tab_tr_dist_prem            IS TABLE OF giac_prodrep_peril_ext.tr_dist_prem%TYPE;
 TYPE tab_tr_dist_spct            IS TABLE OF giac_prodrep_peril_ext.tr_dist_spct%TYPE;
 TYPE tab_fa_dist_tsi             IS TABLE OF giac_prodrep_peril_ext.fa_dist_tsi%TYPE;
 TYPE tab_fa_dist_prem            IS TABLE OF giac_prodrep_peril_ext.fa_dist_prem%TYPE;
 TYPE tab_fa_dist_spct            IS TABLE OF giac_prodrep_peril_ext.fa_dist_spct%TYPE;
 TYPE tab_currency_rt             IS TABLE OF giac_prodrep_peril_ext.currency_rt%TYPE;
 TYPE tab_peril_cd                IS TABLE OF giac_prodrep_peril_ext.peril_cd%TYPE;
 TYPE tab_peril_type              IS TABLE OF giac_prodrep_peril_ext.peril_type%TYPE;
 TYPE tab_acct_ent_date           IS TABLE OF VARCHAR2(10); --giac_prodrep_dist_ext.acct_ent_date%TYPE;
 TYPE tab_acct_neg_date           IS TABLE OF VARCHAR2(10);--giac_prodrep_dist_ext.acct_neg_date%TYPE;
 TYPE tab_policy_no               IS TABLE OF giac_prodrep_peril_ext.policy_no%TYPE;
 TYPE tab_iss_cd                  IS TABLE OF giac_prodrep_peril_ext.iss_cd%TYPE;
 TYPE tab_issue_yy                IS TABLE OF giac_prodrep_peril_ext.issue_yy%TYPE;
 TYPE tab_pol_seq_no              IS TABLE OF giac_prodrep_peril_ext.pol_seq_no%TYPE;
 TYPE tab_renew_no                IS TABLE OF giac_prodrep_peril_ext.renew_no%TYPE;
 TYPE tab_endt_iss_cd             IS TABLE OF giac_prodrep_peril_ext.endt_iss_cd%TYPE;
 TYPE tab_endt_yy                 IS TABLE OF giac_prodrep_peril_ext.endt_yy%TYPE;
 TYPE tab_endt_seq_no             IS TABLE OF giac_prodrep_peril_ext.endt_seq_no%TYPE;
 TYPE tab_pol_acct_ent_date       IS TABLE OF VARCHAR2(10);---giac_prodrep_dist_ext.pol_acct_ent_date%TYPE;
 TYPE tab_pol_spld_acct_ent_date  IS TABLE OF VARCHAR2(10);---giac_prodrep_dist_ext.pol_spld_acct_ent_date%TYPE;
 vv_policy_id               tab_policy_id;
 vv_line_cd                 tab_line_cd;
 vv_subline_cd              tab_subline_cd;
 vv_dist_no                 tab_dist_no;
 vv_dist_seq_no             tab_dist_seq_no;
 vv_share_cd                tab_share_cd;
 vv_share_type              tab_share_type;
 vv_trty_name               tab_trty_name;
 vv_trty_yy                 tab_trty_yy;
 vv_nr_dist_tsi             tab_nr_dist_tsi;
 vv_nr_dist_prem            tab_nr_dist_prem;
 vv_nr_dist_spct            tab_fa_dist_spct;
 vv_tr_dist_tsi             tab_tr_dist_tsi;
 vv_tr_dist_prem            tab_tr_dist_prem;
 vv_tr_dist_spct            tab_fa_dist_spct;
 vv_fa_dist_tsi             tab_fa_dist_tsi;
 vv_fa_dist_prem            tab_fa_dist_prem;
 vv_fa_dist_spct            tab_fa_dist_spct;
 vv_currency_rt             tab_currency_rt ;
 vv_peril_cd                tab_peril_cd;
 vv_peril_type              tab_peril_type;
 vv_acct_ent_date           tab_acct_ent_date;
 vv_acct_neg_date           tab_acct_neg_date;
 vv_policy_no               tab_policy_no;
 vv_iss_cd                  tab_iss_cd ;
 vv_issue_yy                tab_issue_yy;
 vv_pol_seq_no              tab_pol_seq_no;
 vv_renew_no                tab_renew_no;
 vv_endt_iss_cd             tab_endt_iss_cd;
 vv_endt_yy                 tab_endt_yy;
 vv_endt_seq_no             tab_endt_seq_no;
 vv_pol_acct_ent_date       tab_pol_acct_ent_date;
 vv_pol_spld_acct_ent_date  tab_pol_spld_acct_ent_date;
 v_date                     VARCHAR2(10);
 v_from_date                VARCHAR2(10);
 v_to_date                  VARCHAR2(10);
BEGIN
  DELETE giac_prodrep_peril_ext
  WHERE user_id= USER;
  COMMIT;
    SELECT
          b.policy_id      AS policy_id,
          b.policy_no      AS policy_no,
          a.line_cd        AS line_cd,
          b.subline_cd     AS subline_cd,
          a.share_cd       AS share_cd,
          b.share_type     AS share_type,
          b.trty_name      AS trty_name,
          b.trty_yy        AS trty_yy,
          a.dist_no        AS dist_no,
          a.dist_seq_no    AS dist_seq_no,
          a.peril_cd       AS peril_cd,
          c.peril_type     AS peril_type,
          /*added currency_rt dexter 01092013*/
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '1',NVL(a.dist_tsi,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type, '1',NVL(a.dist_tsi,0)*d.currency_rt))) AS nr_dist_tsi,
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '1',NVL(a.dist_prem,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type,'1',NVL(a.dist_prem,0)*d.currency_rt))) AS nr_dist_prem,
          DECODE(b.share_type, '1',a.dist_spct ) AS nr_dist_spct,
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '2',NVL(a.dist_tsi,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type, '2', NVL(a.dist_tsi,0)*d.currency_rt))) AS tr_dist_tsi,
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '2',NVL(a.dist_prem,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type, '2',NVL(a.dist_prem,0)*d.currency_rt))) AS tr_dist_prem,
          DECODE(b.share_type, '2',a.dist_spct ) AS tr_dist_spct,
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '3',NVL(a.dist_tsi,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type, '3',NVL(a.dist_tsi,0)*d.currency_rt))) AS fa_dist_tsi,
          DECODE(b.acct_neg_date,p_to_date,
               (DECODE(b.share_type, '3',NVL(a.dist_prem,0))*(-1)*d.currency_rt),
               (DECODE(b.share_type, '3',NVL(a.dist_prem,0)*d.currency_rt))) AS fa_dist_prem,
           DECODE(b.share_type, '3',a.dist_spct ) AS fa_dist_spct,
           b.currency_rt                                   AS currency_rt,
           TO_CHAR(b.acct_ent_date,'MM-DD-YYYY')           AS acct_ent_date,
           TO_CHAR(b.acct_neg_date,'MM-DD-YYYY')           AS acct_neg_date,
           TO_CHAR(b.pol_acct_ent_date,'MM-DD-YYYY')       AS pol_acct_ent_date,
           TO_CHAR(b.pol_spld_acct_ent_date,'MM-DD-YYYY')  AS pol_spld_acct_ent_date,
           b.endt_seq_no              AS endt_seq_no,
           b.iss_cd                   AS iss_cd,
           b.issue_yy                 AS issue_yy,
           b.pol_seq_no               AS pol_seq_no,
           b.renew_no                 AS renew_no,
           b.endt_iss_cd              AS endt_iss_cd,
           b.endt_yy                  AS endt_yy
     bulk collect INTO
           vv_policy_id,
           vv_policy_no,
           vv_line_cd,
           vv_subline_cd,
           vv_share_cd,
           vv_share_type,
           vv_trty_name,
           vv_trty_yy,
           vv_dist_no,
           vv_dist_seq_no,
           vv_peril_cd,
           vv_peril_type,
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
           vv_endt_seq_no,
           vv_iss_cd,
           vv_issue_yy,
           vv_pol_seq_no,
           vv_renew_no,
           vv_endt_iss_cd,
           vv_endt_yy
      FROM giuw_perilds_dtl a,
           giac_prodrep_dist_ext b,
           giis_peril       c,
		   gipi_invoice d --dexter 01092013
      WHERE a.dist_no = b.dist_no
        AND a.dist_seq_no = b.dist_seq_no
		AND b.user_id = USER
      AND a.line_cd   = b.line_cd
      AND a.share_cd  = b.share_cd
      AND a.line_cd   = c.line_cd
      AND a.peril_cd  = c.peril_cd
	  AND d.policy_id = b.policy_id--dexter 01092013
      AND TO_CHAR(a.dist_no) || TO_CHAR(a.dist_seq_no) IN
          (SELECT TO_CHAR(a.dist_no) || TO_CHAR(a.dist_seq_no)
              FROM giuw_policyds a,
                   giuw_pol_dist b
              WHERE a.dist_no = b.dist_no
  	        AND ((b.acct_ent_date >= p_from_date
                     AND b.acct_ent_date <= p_to_date)
		     OR
		     (b.acct_neg_date >=  p_from_date
                     AND b.acct_neg_date <= p_to_date)));
 IF SQL%FOUND THEN
      v_date      := TO_CHAR(SYSDATE,'MM-DD-YYYY');
      v_from_date := TO_CHAR(p_from_date,'MM-DD-YYYY');
      v_to_date   := TO_CHAR(p_to_date ,'MM-DD-YYYY');
      forall i IN vv_policy_id.first..vv_policy_id.last
       INSERT INTO giac_prodrep_peril_ext
            (policy_id             ,    line_cd                 ,   subline_cd               ,
            dist_no                ,    dist_seq_no             ,   peril_cd                 ,
            peril_type             ,    share_cd                ,   share_type               ,
            trty_name              ,    trty_yy                 ,   acct_ent_date            ,
            nr_dist_tsi            ,    nr_dist_prem            ,   nr_dist_spct             ,
            tr_dist_tsi            ,    tr_dist_prem            ,   tr_dist_spct             ,
            fa_dist_tsi            ,    fa_dist_prem            ,   fa_dist_spct             ,
            currency_rt            ,    policy_no               ,   acct_neg_date            ,
            endt_seq_no            ,    iss_cd                  ,   issue_yy                 ,
            pol_seq_no             ,    renew_no                ,   endt_iss_cd              ,
            endt_yy                ,    pol_acct_ent_date       ,   pol_spld_acct_ent_date   ,
            user_id                ,    last_update             ,
            from_date1             ,    to_date1)
    VALUES  (vv_policy_id(i)       ,    vv_line_cd(i)           ,   vv_subline_cd(i)     ,
             vv_dist_no(i)         ,    vv_dist_seq_no(i)       ,   vv_peril_cd(i)          ,
             vv_peril_type(i)      ,    vv_share_cd(i)          ,   vv_share_type(i)     ,
             vv_trty_name(i)       ,    vv_trty_yy(i)           ,   TO_DATE(vv_acct_ent_date(i),'MM-DD-YYYY') ,
             vv_nr_dist_tsi(i)     ,    vv_nr_dist_prem(i)      ,   vv_nr_dist_spct(i)   ,
             vv_tr_dist_tsi(i)     ,    vv_tr_dist_prem(i)      ,   vv_tr_dist_spct(i)   ,
             vv_fa_dist_tsi(i)     ,    vv_fa_dist_prem(i)      ,   vv_fa_dist_spct(i)   ,
             vv_currency_rt(i)     ,    vv_policy_no(i)         ,   TO_DATE(vv_acct_neg_date(i),'MM-DD-YYYY') ,
             vv_endt_seq_no(i)     ,    vv_iss_cd(i)            ,   vv_issue_yy(i)          ,
             vv_pol_seq_no(i)      ,    vv_renew_no(i)          ,    vv_endt_iss_cd(i)      ,
             vv_endt_yy(i)         ,
             TO_DATE(vv_pol_acct_ent_date(i),'MM-DD-YYYY'), TO_DATE(vv_pol_spld_acct_ent_date(i),'MM-DD-YYYY'),
             USER                  ,    TO_DATE(v_date,'MM-DD-YYYY'),
             TO_DATE(v_from_date,'MM-DD-YYYY') , TO_DATE(v_to_date,'MM-DD-YYYY'));
 END IF;
 COMMIT;
 END;
/



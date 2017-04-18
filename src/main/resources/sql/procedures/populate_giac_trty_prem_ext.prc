DROP PROCEDURE CPI.POPULATE_GIAC_TRTY_PREM_EXT;

CREATE OR REPLACE PROCEDURE CPI.Populate_Giac_Trty_Prem_Ext(p_from_date   giac_trty_prem_ext.from_date%TYPE,
                                                        p_to_date     giac_trty_prem_ext.TO_DATE%TYPE,
									                    p_user_id     giac_trty_prem_ext.user_id%TYPE)
IS
  TYPE tab_cession_year       IS TABLE OF giac_treaty_cessions.cession_year%TYPE;
  TYPE tab_cession_mm         IS TABLE OF giac_treaty_cessions.cession_mm%TYPE;
  TYPE tab_line_cd            IS TABLE OF giac_treaty_cessions.line_cd%TYPE;
  TYPE tab_branch_cd          IS TABLE OF giac_treaty_cessions.branch_cd%TYPE;
  TYPE tab_share_cd           IS TABLE OF giac_treaty_cessions.share_cd%TYPE;
  TYPE tab_treaty_yy          IS TABLE OF giac_treaty_cessions.treaty_yy%TYPE;
  TYPE tab_policy_id          IS TABLE OF giac_treaty_cessions.policy_id%TYPE;
  TYPE tab_dist_no            IS TABLE OF giac_treaty_cessions.dist_no%TYPE;
  TYPE tab_acct_ent_date      IS TABLE OF VARCHAR2(25); ---giac_treaty_cessions.acct_ent_date%type;
  TYPE tab_premium_amt        IS TABLE OF giac_treaty_cession_dtl.premium_amt%TYPE;
  TYPE tab_commission_amt     IS TABLE OF giac_treaty_cession_dtl.commission_amt%TYPE;
  TYPE tab_trty_com_rt        IS TABLE OF giis_trty_peril.trty_com_rt%TYPE;
  TYPE tab_peril_cd           IS TABLE OF giis_trty_peril.peril_cd%TYPE;
  TYPE tab_prnt_ri_cd         IS TABLE OF giis_trty_panel.prnt_ri_cd%TYPE;
  TYPE tab_trty_shr_pct       IS TABLE OF giis_trty_panel.trty_shr_pct%TYPE;
  TYPE tab_inv_prem_tax       IS TABLE OF NUMBER(16,2);
  vv_cession_year             tab_cession_year;
  vv_cession_mm               tab_cession_mm;
  vv_line_cd                  tab_line_cd;
  vv_branch_cd                tab_branch_cd;
  vv_share_cd                 tab_share_cd;
  vv_treaty_yy                tab_treaty_yy;
  vv_policy_id                tab_policy_id;
  vv_dist_no                  tab_dist_no;
  vv_acct_ent_date            tab_acct_ent_date;
  vv_premium_amt              tab_premium_amt;
  vv_commission_amt           tab_commission_amt;
  vv_trty_com_rt              tab_trty_com_rt;
  vv_peril_cd                 tab_peril_cd;
  vv_prnt_ri_cd               tab_prnt_ri_cd;
  vv_trty_shr_pct             tab_trty_shr_pct;
  vv_inv_prem_tax             tab_inv_prem_tax;
BEGIN
  DELETE
    FROM giac_trty_prem_ext
   WHERE user_id = p_user_id;
--     and from_date = p_from_date
--	 and to_date = p_to_date;

  COMMIT;
  SELECT c.cession_year,  c.cession_mm,  c.line_cd,  c.branch_cd,     c.share_cd,
         c.treaty_yy,     c.policy_id,   c.dist_no,
		 TO_CHAR(c.acct_ent_date,'MM-DD-YYYY'),
         g.premium_amt,   g.commission_amt,
         f.trty_com_rt,   f.peril_cd,
         NVL(a.prnt_ri_cd, a.ri_cd)prnt_ri_cd,       a.trty_shr_pct,
         (NVL(i.prem_amt,0) + NVL(i.tax_amt,0)) inv_prem_tax
  bulk collect INTO
         vv_cession_year, vv_cession_mm, vv_line_cd, vv_branch_cd,     vv_share_cd,
         vv_treaty_yy,    vv_policy_id,  vv_dist_no, vv_acct_ent_date,
         vv_premium_amt,  vv_commission_amt,
         vv_trty_com_rt,  vv_peril_cd,
         vv_prnt_ri_cd,    vv_trty_shr_pct,
         vv_inv_prem_tax
    FROM giac_treaty_cessions c,
         giac_treaty_cession_dtl g,
         giis_dist_share d,
         giis_trty_peril f,
	     giis_trty_panel a,
         gipi_invoice i
   WHERE 1=1
     AND c.acct_ent_date BETWEEN p_from_date AND p_to_date
     AND g.cession_id = c.cession_id
     AND d.share_type = 2
     AND d.line_cd = c.line_cd
     AND d.share_cd = c.share_cd
     AND d.trty_yy = c.treaty_yy
     AND f.trty_seq_no = d.share_cd
     AND f.line_cd = d.line_cd
     AND f.peril_cd = g.peril_cd
     AND a.trty_yy = d.trty_yy
     AND a.line_cd = d.line_cd
     AND a.trty_seq_no = d.share_cd
     AND NVL(a.prnt_ri_cd, a.ri_cd) = c.ri_cd
     AND i.policy_id = c.policy_id;
  IF SQL%FOUND THEN
     forall pol IN vv_cession_year.first..vv_cession_year.last
       INSERT INTO giac_trty_prem_ext
         (cession_year,         cession_mm,         line_cd,           branch_cd,
		  share_cd,             treaty_yy,          policy_id,         dist_no,
		  acct_ent_date,
		  premium_amt,          commission_amt,
          trty_com_rt,          peril_cd,
		  prnt_ri_cd,           trty_shr_pct,
          inv_prem_tax,
		  user_id,
		  from_date,
		  TO_DATE)
       VALUES
         (vv_cession_year(pol), vv_cession_mm(pol), vv_line_cd(pol),   vv_branch_cd(pol),
		  vv_share_cd(pol),     vv_treaty_yy(pol),  vv_policy_id(pol), vv_dist_no(pol),
		  TO_DATE(vv_acct_ent_date(pol),'MM-DD-YYYY'),
          vv_premium_amt(pol),  vv_commission_amt(pol),
          vv_trty_com_rt(pol),  vv_peril_cd(pol),
          vv_prnt_ri_cd(pol),   vv_trty_shr_pct(pol),
          vv_inv_prem_tax(pol),
		  p_user_id,
		  p_from_date,
		  p_to_date);
  END IF;
  COMMIT;
END;
/



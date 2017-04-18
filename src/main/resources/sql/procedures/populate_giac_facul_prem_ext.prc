DROP PROCEDURE CPI.POPULATE_GIAC_FACUL_PREM_EXT;

CREATE OR REPLACE PROCEDURE CPI.Populate_Giac_Facul_Prem_Ext(p_from_date   giac_facul_prem_ext.from_date%TYPE,
                                                         p_to_date     giac_facul_prem_ext.TO_DATE%TYPE,
									                     p_user_id     giac_facul_prem_ext.user_id%TYPE)
IS
  TYPE tab_acc_ent_date       IS TABLE OF VARCHAR2(25); ---giri_binder.acc_ent_date%type;
  TYPE tab_acc_rev_date       IS TABLE OF VARCHAR2(25); ---giri_binder.acc_rev_date%type;
  TYPE tab_fnl_binder_id      IS TABLE OF giri_binder.fnl_binder_id%TYPE;
  TYPE tab_binder_yy          IS TABLE OF giri_binder.binder_yy%TYPE;
  TYPE tab_binder_seq_no      IS TABLE OF giri_binder.binder_seq_no%TYPE;
  TYPE tab_line_cd            IS TABLE OF giri_frperil.line_cd%TYPE;
  TYPE tab_ri_cd              IS TABLE OF giri_frperil.ri_cd%TYPE;
  TYPE tab_ri_seq_no          IS TABLE OF giri_frperil.ri_seq_no%TYPE;
  TYPE tab_ri_shr_pct         IS TABLE OF giri_frperil.ri_shr_pct%TYPE;
  TYPE tab_frps_yy            IS TABLE OF giri_frperil.frps_yy%TYPE;
  TYPE tab_frps_seq_no        IS TABLE OF giri_frperil.frps_seq_no%TYPE;
  TYPE tab_peril_cd           IS TABLE OF giri_frperil.peril_cd%TYPE;
  TYPE tab_ri_tsi_amt         IS TABLE OF NUMBER(16,2);
  TYPE tab_ri_prem_amt        IS TABLE OF NUMBER(12,2);
  TYPE tab_ri_comm_rt         IS TABLE OF giri_frperil.ri_comm_rt%TYPE;
  TYPE tab_ri_comm_amt        IS TABLE OF giri_frperil.ri_comm_amt%TYPE;
  TYPE tab_ri_sname           IS TABLE OF giis_reinsurer.ri_sname%TYPE;
  TYPE tab_inv_prem_tax       IS TABLE OF NUMBER(16,2);
  vv_acc_ent_date             tab_acc_ent_date;
  vv_acc_rev_date             tab_acc_rev_date;
  vv_fnl_binder_id            tab_fnl_binder_id;
  vv_binder_yy                tab_binder_yy;
  vv_binder_seq_no            tab_binder_seq_no;
  vv_line_cd                  tab_line_cd;
  vv_ri_cd                    tab_ri_cd;
  vv_ri_seq_no                tab_ri_seq_no;
  vv_ri_shr_pct               tab_ri_shr_pct;
  vv_frps_yy                  tab_frps_yy;
  vv_frps_seq_no              tab_frps_seq_no;
  vv_peril_cd                 tab_peril_cd;
  vv_ri_tsi_amt               tab_ri_tsi_amt;
  vv_ri_prem_amt              tab_ri_prem_amt;
  vv_ri_comm_rt               tab_ri_comm_rt;
  vv_ri_comm_amt              tab_ri_comm_amt;
  vv_ri_sname                 tab_ri_sname;
  vv_inv_prem_tax             tab_inv_prem_tax;
BEGIN
  DELETE
    FROM giac_facul_prem_ext
   WHERE user_id = p_user_id;
--   	 and to_date = p_to_date
--	 and from_date = p_from_date;
  COMMIT;

  SELECT
         TO_CHAR(g.acc_ent_date,'MM-DD-YYYY'),
         TO_CHAR(g.acc_rev_date,'MM-DD-YYYY'),
		 g.fnl_binder_id,   g.binder_yy,    g.binder_seq_no,
         p.line_cd,       p.ri_cd,        p.ri_seq_no,       p.ri_shr_pct,   p.frps_yy,
         p.frps_seq_no,   p.peril_cd,     p.ri_comm_rt,      p.ri_comm_amt,
	    (p.ri_tsi_amt*d.currency_rt) ri_tsi_amt,
        (p.ri_prem_amt*d.currency_rt) ri_prem_amt,
        s.ri_sname,
        (NVL(i.prem_amt,0) + NVL(i.tax_amt,0)) inv_prem_tax
  bulk collect INTO
         vv_acc_ent_date,
         vv_acc_rev_date,
  		 vv_fnl_binder_id, vv_binder_yy,   vv_binder_seq_no,
         vv_line_cd,      vv_ri_cd,        vv_ri_seq_no,     vv_ri_shr_pct,  vv_frps_yy,
         vv_frps_seq_no,  vv_peril_cd,     vv_ri_comm_rt,    vv_ri_comm_amt,
         vv_ri_tsi_amt,
		 vv_ri_prem_amt,
		 vv_ri_sname,
         vv_inv_prem_tax
    FROM gipi_invoice i,
         giri_binder g,
         giri_frps_ri r,
     	 giri_distfrps d,
    	 giri_frperil p,
    	 giis_reinsurer s
   WHERE 1=1
     AND g.fnl_binder_id = r.fnl_binder_id
     AND r.frps_yy = d.frps_yy
     AND r.frps_seq_no = d.frps_seq_no
     AND r.line_cd = d.line_cd
     AND r.frps_yy = p.frps_yy
     AND r.frps_seq_no = p.frps_seq_no
     AND r.ri_seq_no = p.ri_seq_no
     AND r.line_cd = p.line_cd
     AND p.ri_cd = s.ri_cd
     AND g.policy_id = i.policy_id
     AND g.acc_ent_date BETWEEN p_from_date AND p_to_date;

  IF SQL%FOUND THEN
     forall pol IN vv_fnl_binder_id.first..vv_fnl_binder_id.last
       INSERT INTO giac_facul_prem_ext
         (acc_ent_date,
		  acc_rev_date,
		  fnl_binder_id,
		  binder_yy,            binder_seq_no,
          line_cd,              ri_cd,                ri_seq_no,
		  ri_shr_pct,           frps_yy,
          frps_seq_no,          peril_cd,       	  ri_comm_rt,
		  ri_comm_amt,
	      ri_tsi_amt,           ri_prem_amt,          ri_sname,
		  inv_prem_tax,
		  user_id,
		  from_date,
		  TO_DATE)
       VALUES
         (TO_DATE(vv_acc_ent_date(pol), 'MM-DD-YYYY'),
          TO_DATE(vv_acc_rev_date(pol), 'MM-DD-YYYY'),
          vv_fnl_binder_id(pol),
		  vv_binder_yy(pol),    vv_binder_seq_no(pol),
          vv_line_cd(pol),      vv_ri_cd(pol),        vv_ri_seq_no(pol),
		  vv_ri_shr_pct(pol),   vv_frps_yy(pol),
          vv_frps_seq_no(pol),  vv_peril_cd(pol),     vv_ri_comm_rt(pol),
		  vv_ri_comm_amt(pol),
          vv_ri_tsi_amt(pol),   vv_ri_prem_amt(pol),  vv_ri_sname(pol),
		  vv_inv_prem_tax(pol),
          p_user_id,
		  p_from_date,
		  p_to_date);
  END IF;
  COMMIT;

  vv_acc_ent_date.DELETE;    vv_line_cd.DELETE;       vv_frps_seq_no.DELETE;
  vv_acc_rev_date.DELETE;    vv_ri_cd.DELETE;         vv_peril_cd.DELETE;
  vv_fnl_binder_id.DELETE;   vv_ri_seq_no.DELETE;     vv_ri_tsi_amt.DELETE;
  vv_binder_yy.DELETE;       vv_ri_shr_pct.DELETE;    vv_ri_prem_amt.DELETE;
  vv_binder_seq_no.DELETE;   vv_frps_yy.DELETE;       vv_ri_comm_rt.DELETE;
  vv_ri_comm_amt.DELETE;     vv_ri_sname.DELETE;      vv_inv_prem_tax.DELETE;

  SELECT TO_CHAR(g.acc_ent_date,'MM-DD-YYYY'),
         TO_CHAR(g.acc_rev_date,'MM-DD-YYYY'),
		 g.fnl_binder_id,   g.binder_yy,    g.binder_seq_no,
         p.line_cd,       p.ri_cd,        p.ri_seq_no,       p.ri_shr_pct,   p.frps_yy,
         p.frps_seq_no,   p.peril_cd,     p.ri_comm_rt,      p.ri_comm_amt,
	    (p.ri_tsi_amt*d.currency_rt * -1) ri_tsi_amt,
        (p.ri_prem_amt*d.currency_rt * -1) ri_prem_amt,
        s.ri_sname,
        (NVL(i.prem_amt,0) + NVL(i.tax_amt,0)) inv_prem_tax
  bulk collect INTO
         vv_acc_ent_date, vv_acc_rev_date, vv_fnl_binder_id, vv_binder_yy,   vv_binder_seq_no,
         vv_line_cd,      vv_ri_cd,        vv_ri_seq_no,     vv_ri_shr_pct,  vv_frps_yy,
         vv_frps_seq_no,  vv_peril_cd,     vv_ri_comm_rt,    vv_ri_comm_amt,
         vv_ri_tsi_amt,
		 vv_ri_prem_amt,
		 vv_ri_sname,
         vv_inv_prem_tax
    FROM gipi_invoice i,
         giri_binder g,
         giri_frps_ri r,
     	 giri_distfrps d,
    	 giri_frperil p,
    	 giis_reinsurer s
   WHERE 1=1
     AND g.fnl_binder_id = r.fnl_binder_id
     AND r.frps_yy = d.frps_yy
     AND r.frps_seq_no = d.frps_seq_no
     AND r.line_cd = d.line_cd
     AND r.frps_yy = p.frps_yy
     AND r.frps_seq_no = p.frps_seq_no
     AND r.ri_seq_no = p.ri_seq_no
     AND r.line_cd = p.line_cd
     AND p.ri_cd = s.ri_cd
     AND g.policy_id = i.policy_id
     AND g.acc_rev_date BETWEEN p_from_date AND p_to_date;

  IF SQL%FOUND THEN
     forall pol IN vv_fnl_binder_id.first..vv_fnl_binder_id.last
       INSERT INTO giac_facul_prem_ext
         (acc_ent_date,         acc_rev_date,         fnl_binder_id,
		  binder_yy,            binder_seq_no,
          line_cd,              ri_cd,                ri_seq_no,
		  ri_shr_pct,           frps_yy,
          frps_seq_no,          peril_cd,       	  ri_comm_rt,
		  ri_comm_amt,
	      ri_tsi_amt,           ri_prem_amt,          ri_sname,
		  inv_prem_tax,
		  user_id,
		  from_date,
		  TO_DATE)
       VALUES
         (TO_DATE(vv_acc_ent_date(pol), 'MM-DD-YYYY'),
          TO_DATE(vv_acc_rev_date(pol), 'MM-DD-YYYY'),
		  vv_fnl_binder_id(pol),
		  vv_binder_yy(pol),    vv_binder_seq_no(pol),
          vv_line_cd(pol),      vv_ri_cd(pol),        vv_ri_seq_no(pol),
		  vv_ri_shr_pct(pol),   vv_frps_yy(pol),
          vv_frps_seq_no(pol),  vv_peril_cd(pol),     vv_ri_comm_rt(pol),
		  vv_ri_comm_amt(pol),
          vv_ri_tsi_amt(pol),   vv_ri_prem_amt(pol),  vv_ri_sname(pol),
		  vv_inv_prem_tax(pol),
          p_user_id,
		  p_from_date,
		  p_to_date);
  END IF;
  COMMIT;
END;
/



DROP PROCEDURE CPI.GIAC_PROD_SUM_REP;

CREATE OR REPLACE PROCEDURE CPI.Giac_Prod_Sum_Rep
 (param_date          DATE) AS
  -- janet ang  july, 2000
  -- this procedure is run after the production take up and stores the actual data at
  -- the time the run was made to giac_production_summary. it will store the data
  -- of gipi_polbasic, giuw_itemperilds_dtl and giri_binder into this table.
  -- this table will be the storage place of the actual data during take-up. it will
  -- act as the security during audit. production reports will also base its data here.
  TYPE gps_type  IS TABLE OF GIAC_PRODUCTION_SUMMARY%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE tsi_type  IS TABLE OF NUMBER(16,2)  INDEX BY BINARY_INTEGER;
  TYPE prem_type IS TABLE OF NUMBER(16,2)  INDEX BY BINARY_INTEGER;
  gps_tab              gps_type;
  tsi_tab              tsi_type;
  prem_tab             prem_type;
  counter              NUMBER;  -- gets the row number with the correct policy
  counter2             NUMBER;  -- gets the row number with the correct policy and item_no2
  counter3             NUMBER;  -- stores the item_no2 upon query
  item1_counter        NUMBER;  -- used to store the item_no1 for facul
  item2_counter        NUMBER;  -- used to store the item_no2 for facul
  v_rowid              NUMBER;  -- user to store the rowid of the original facul record
  v_bill_no            VARCHAR2(2000); --VARCHAR2(50); -- aron 06182008 to avoid ora-60502 for long term policies...
  v_intm_no            GIAC_PRODUCTION_SUMMARY.intm_no%TYPE;
  v_parent_intm_no     GIIS_INTERMEDIARY.parent_intm_no%TYPE;
  v_assd_no            GIIS_ASSURED.assd_no%TYPE;
  v_assd_name          GIIS_ASSURED.assd_name%TYPE;
  policy_id            GIPI_POLBASIC.policy_id%TYPE;
  pol_switch           VARCHAR2(1):='N';
  pol_switch2          VARCHAR2(1):='N';
  treaty_switch        VARCHAR2(1):='N';
  net_ret              GIIS_DIST_SHARE.share_type%TYPE;  -- stores value of share_type in giis_parameters
  facul                GIIS_DIST_SHARE.share_type%TYPE;  -- stores value of share_type in giis_parameters
  treaty               GIIS_DIST_SHARE.share_type%TYPE;  -- stores value of share_type in giis_parameters
  v_dummy              NUMBER;
  v_district           GIAC_PRODUCTION_SUMMARY.district%TYPE;
  v_eq_zone            GIAC_PRODUCTION_SUMMARY.eq_zone%TYPE;
  v_block_model_year   GIAC_PRODUCTION_SUMMARY.block_model_year%TYPE;
  v_item_title_make    GIAC_PRODUCTION_SUMMARY.item_title_make%TYPE;
  v_tariff_cd_coc      GIAC_PRODUCTION_SUMMARY.tariff_cd_coc%TYPE;
  var_column_width     NUMBER;
  -- start here is the variables used for passing to giac_prod_sum_rep_dtl --
  -- in order to get the policy details distribution or facul is the only  --
  -- production for the policy(meaning the polbasic record has already been--
  -- taken up before and only the dist/binder has been taken-up            --
  p_policy_id          GIAC_PRODUCTION_SUMMARY.policy_id%TYPE;
  p_par_id             GIPI_PARLIST.par_id%TYPE;
  p_line_cd            GIAC_PRODUCTION_SUMMARY.line_cd%TYPE;
  p_subline_cd         GIAC_PRODUCTION_SUMMARY.subline_cd%TYPE;
  p_iss_cd             GIAC_PRODUCTION_SUMMARY.iss_cd%TYPE;
  p_issue_yy           GIAC_PRODUCTION_SUMMARY.issue_yy%TYPE;
  p_pol_seq_no         GIAC_PRODUCTION_SUMMARY.pol_seq_no%TYPE;
  p_endt_iss_cd        GIAC_PRODUCTION_SUMMARY.endt_iss_cd%TYPE;
  p_endt_yy            GIAC_PRODUCTION_SUMMARY.endt_yy%TYPE;
  p_endt_seq_no        GIAC_PRODUCTION_SUMMARY.endt_seq_no%TYPE;
  p_renew_no           GIAC_PRODUCTION_SUMMARY.renew_no%TYPE;
  p_acct_ent_date      GIAC_PRODUCTION_SUMMARY.acct_ent_date%TYPE;
  p_spld_acct_ent_date GIAC_PRODUCTION_SUMMARY.spld_acct_ent_date%TYPE;
  p_incept_date        GIAC_PRODUCTION_SUMMARY.incept_date%TYPE;
  p_expiry_date        GIAC_PRODUCTION_SUMMARY.expiry_date%TYPE;
  p_intm_no            GIAC_PRODUCTION_SUMMARY.intm_no%TYPE;
  p_intm_name          GIAC_PRODUCTION_SUMMARY.intm_name%TYPE;
  p_intm_type          GIAC_PRODUCTION_SUMMARY.intm_type%TYPE;
  p_parent_intm_no     GIAC_PRODUCTION_SUMMARY.parent_intm_no%TYPE;
  p_parent_intm_name   GIAC_PRODUCTION_SUMMARY.parent_intm_name%TYPE;
  p_parent_intm_type   GIAC_PRODUCTION_SUMMARY.parent_intm_type%TYPE;
  p_bill_no            GIAC_PRODUCTION_SUMMARY.prem_seq_no%TYPE;
  p_assd_no            GIAC_PRODUCTION_SUMMARY.assd_no%TYPE;
  p_assd_name          GIAC_PRODUCTION_SUMMARY.assd_name%TYPE;
  p_ref_pol_no         GIAC_PRODUCTION_SUMMARY.ref_pol_no%TYPE;
  p_tax_amt            DBMS_SQL.NUMBER_TABLE;
  p_tax_cd             DBMS_SQL.NUMBER_TABLE;
  p_tax_row            DBMS_SQL.NUMBER_TABLE;
  p_tsi_amt            GIAC_PRODUCTION_SUMMARY.tsi_amt%TYPE;
  p_prem_amt           GIAC_PRODUCTION_SUMMARY.prem_amt%TYPE;
  CURSOR share_type IS
    SELECT rv_meaning, rv_low_value
 FROM CG_REF_CODES
 WHERE rv_domain LIKE 'GIIS_DIST_SHARE.SHARE_TYPE';
BEGIN
DBMS_OUTPUT.PUT_LINE('START OF PROCEDURE :  '||TO_CHAR(SYSDATE,'MM-DD-YYYY HH:MI:SS AM'));
  -- part i of iv
  -- for company production and net retention distribution
  -- to initialize the table in case a rerun or additional take up has been done
  DELETE FROM GIAC_PRODUCTION_SUMMARY WHERE TRUNC(take_up_date) = TRUNC(param_date);
  -- to get the share_type value from giis_parameters of retention, treaty and facul
  FOR j IN share_type LOOP
    IF UPPER(j.rv_meaning) = 'RETENTION' THEN
    net_ret := j.rv_low_value;
 ELSIF UPPER(j.rv_meaning) = 'TREATY' THEN
    treaty  := j.rv_low_value;
 ELSIF UPPER(j.rv_meaning) = 'FACULTATIVE' THEN
    facul   := j.rv_low_value;
 END IF;
  END LOOP j;
  FOR j IN (SELECT policy_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd,
    endt_yy, endt_seq_no, renew_no, acct_ent_date, spld_acct_ent_date, incept_date, expiry_date, assd_no, ref_pol_no
    FROM GIPI_POLBASIC a
    WHERE (TO_CHAR(acct_ent_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY')
    OR TO_CHAR(spld_acct_ent_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY'))
   ORDER BY policy_id ) LOOP
    counter := NVL(counter,0) + 1;
    -- for the intm_no
    v_intm_no := NULL;
    v_parent_intm_no := NULL;
    FOR intm IN (SELECT MIN(intrmdry_intm_no)  intm_no, parent_intm_no
      FROM GIPI_COMM_INVOICE
      WHERE policy_id = j.policy_id
      AND share_percentage = (SELECT MAX(share_percentage) FROM
         GIPI_COMM_INVOICE
         WHERE policy_id = j.policy_id)
      GROUP BY parent_intm_no)LOOP
         v_intm_no := intm.intm_no;
         v_parent_intm_no := intm.parent_intm_no;
         EXIT;
   END LOOP intm;
    p_intm_name := NULL;
 p_intm_type := NULL;
    FOR rec IN (SELECT intm_name, intm_type FROM GIIS_INTERMEDIARY
      WHERE intm_no = v_intm_no ) LOOP
         p_intm_name := rec.intm_name;
      p_intm_type := rec.intm_type;
    END LOOP;
    p_parent_intm_name := NULL;
 p_parent_intm_type := NULL;
    IF j.iss_cd != 'RI' THEN
       IF v_parent_intm_no IS NULL THEN
         v_parent_intm_no := Get_Parent_Intm_No(j.policy_id);
       END IF;
       FOR rec IN (SELECT intm_name, intm_type FROM GIIS_INTERMEDIARY
      WHERE intm_no = v_parent_intm_no ) LOOP
         p_parent_intm_name := rec.intm_name;
      p_parent_intm_type := rec.intm_type;
       END LOOP;
    ELSE
      p_parent_intm_name := 'REINSURANCE';
   p_parent_intm_type := 'RI';
      p_intm_name := 'REINSURANCE';
   p_intm_type := 'RI';
   v_parent_intm_no := 0;
      v_intm_no  := 0;
 END IF;
    -- to initialize table types
    FOR init IN 1..20 LOOP
      tsi_tab(init):= 0;
      prem_tab(init):= 0;
    END LOOP;
    -- for the bill no / invoice no
    FOR jj IN (SELECT data_length FROM all_tab_columns WHERE table_name LIKE 'GIAC_PRODUCTION_SUMMARY'
   AND column_name LIKE 'PREM_SEQ_NO' ) LOOP
      var_column_width := jj.data_length;
    END LOOP;
    v_bill_no := NULL;
    p_tax_amt.DELETE;
    FOR inv IN (SELECT iss_cd, prem_seq_no, currency_rt FROM GIPI_INVOICE
   WHERE iss_cd = j.iss_cd AND policy_id = j.policy_id) LOOP
      var_column_width := var_column_width - LENGTH(inv.iss_cd||'-'||inv.prem_seq_no);
      IF var_column_width <=0 THEN
        v_bill_no := '/VARIOUS';
      ELSE
  v_bill_no := v_bill_no ||'/'||inv.prem_seq_no;
      END IF;
      FOR tax IN (SELECT tax_cd, SUM(DECODE(TO_CHAR(j.spld_acct_ent_date,'MM-DD-YYYY'),
               TO_CHAR(param_date,'MM-DD-YYYY'),tax_amt * NVL(inv.currency_rt,1)*-1,NULL,tax_amt * NVL(inv.currency_rt,1))) tax_amt
     FROM GIPI_INV_TAX
  WHERE iss_cd = inv.iss_cd AND prem_seq_no = inv.prem_seq_no
  GROUP BY tax_cd) LOOP
  p_tax_amt(tax.tax_cd) := tax.tax_amt;
  p_tax_cd(tax.tax_cd)  := tax.tax_cd;
      END LOOP;
      FOR invp IN (SELECT NVL(b.column_no,10) column_no,
         SUM(DECODE(NVL(tsi_amt,0),0,0,DECODE(c.peril_type,'A',0,DECODE(TO_CHAR(j.spld_acct_ent_date,'MM-DD-YYYY'),
                TO_CHAR(param_date,'MM-DD-YYYY'),tsi_amt * NVL(inv.currency_rt,1)*-1,NULL,tsi_amt * NVL(inv.currency_rt,1))) )) tsi_amt,
         SUM(DECODE(NVL(prem_amt,0),0,0,DECODE(TO_CHAR(j.spld_acct_ent_date,'MM-DD-YYYY'),
               TO_CHAR(param_date,'MM-DD-YYYY'),prem_amt * NVL(inv.currency_rt,1)*-1,NULL,prem_amt * NVL(inv.currency_rt,1)))) prem_amt
         FROM GIPI_INVPERIL a, GIAC_ACCT_REGISTER_DTL b, GIIS_PERIL c
         WHERE b.peril_cd(+) = a.peril_cd
         AND b.line_cd(+) = j.line_cd
         AND a.peril_cd = c.peril_cd
         AND j.line_cd = c.line_cd
         AND a.iss_cd = inv.iss_cd
         AND a.prem_seq_no = inv.prem_seq_no
         GROUP BY NVL(b.column_no,10)  ) LOOP
         tsi_tab(invp.column_no) := tsi_tab(invp.column_no) + invp.tsi_amt;
   prem_tab(invp.column_no):= prem_tab(invp.column_no) + invp.prem_amt;
   END LOOP invp;
    END LOOP inv;
    v_dummy   := LENGTH(v_bill_no);
    v_bill_no := SUBSTR(v_bill_no,2,v_dummy);  -- take away the first slash
    v_assd_no := j.assd_no;
    IF j.assd_no IS NULL THEN
      FOR par IN (SELECT assd_no FROM GIPI_PARLIST WHERE par_id = j.par_id) LOOP
         v_assd_no := par.assd_no;
      END LOOP;
    END IF;
    FOR assd IN (SELECT assd_name FROM GIIS_ASSURED WHERE assd_no = v_assd_no) LOOP
   v_assd_name := assd.assd_name;
    END LOOP;
    v_district    := NULL;
    v_eq_zone     := NULL;
 v_block_model_year := NULL;
 v_item_title_make := NULL;
 v_tariff_cd_coc := NULL;
    IF j.line_cd = 'FI' THEN
   FOR fi IN (SELECT a.item_no, a.district_no, a.eq_zone, a.block_no, b.fr_itm_tp_ds, a.tarf_cd
     FROM GIPI_FIREITEM a, GIIS_FI_ITEM_TYPE b
  WHERE a.fr_item_type = b.fr_item_type
  AND a.policy_id = j.policy_id) LOOP
        v_district := fi.district_no;
        v_eq_zone     := fi.eq_zone;
  v_block_model_year := fi.block_no;
  v_item_title_make := fi.fr_itm_tp_ds;
  v_tariff_cd_coc := fi.tarf_cd;
      END LOOP;
    ELSIF j.line_cd = 'MC' THEN
      FOR mc IN (SELECT coc_serial_no, model_year, make
     FROM GIPI_VEHICLE
  WHERE policy_id = j.policy_id ) LOOP
  v_block_model_year := mc.model_year;
  v_item_title_make := mc.make;
  v_tariff_cd_coc := mc.coc_serial_no;
      END LOOP;
 END IF;
    gps_tab(counter).take_up_year  := TO_CHAR(param_date,'YYYY');
    gps_tab(counter).take_up_date  := param_date;
 gps_tab(counter).item_no1      := counter;
 gps_tab(counter).policy_id     := j.policy_id;   gps_tab(counter).line_cd       := j.line_cd;
 gps_tab(counter).subline_cd    := j.subline_cd;   gps_tab(counter).iss_cd        := j.iss_cd;
 gps_tab(counter).issue_yy      := j.issue_yy;    gps_tab(counter).pol_seq_no    :=
j.pol_seq_no;
 gps_tab(counter).endt_iss_cd   := j.endt_iss_cd;  gps_tab(counter).endt_yy       := j.endt_yy;
 gps_tab(counter).endt_seq_no   := j.endt_seq_no;  gps_tab(counter).renew_no      := j.renew_no;
 gps_tab(counter).incept_date   := j.incept_date;  gps_tab(counter).expiry_date   :=
j.expiry_date;
    gps_tab(counter).prem_seq_no   := v_bill_no;     gps_tab(counter).acct_ent_date :=
j.acct_ent_date;
    gps_tab(counter).eq_zone       := v_eq_zone;      gps_tab(counter).district      := v_district;
 gps_tab(counter).block_model_year := v_block_model_year;
 gps_tab(counter).ref_pol_no    := j.ref_pol_no;
 gps_tab(counter).item_title_make:=v_item_title_make;gps_tab(counter).tariff_cd_coc :=
v_tariff_cd_coc;
 gps_tab(counter).spld_acct_ent_date := j.spld_acct_ent_date;
    gps_tab(counter).intm_no       := v_intm_no;      gps_tab(counter).intm_name     := p_intm_name;
    gps_tab(counter).intm_type     := p_intm_type;    gps_tab(counter).parent_intm_no :=
v_parent_intm_no;
    gps_tab(counter).parent_intm_name := p_parent_intm_name;
    gps_tab(counter).parent_intm_type := p_parent_intm_type;
 gps_tab(counter).assd_no       := v_assd_no;      gps_tab(counter).assd_name     :=
v_assd_name;
    gps_tab(counter).tsi_amt1      := tsi_tab(1);     gps_tab(counter).prem_amt1     := prem_tab(1);
    gps_tab(counter).tsi_amt2      := tsi_tab(2);     gps_tab(counter).prem_amt2     := prem_tab(2);
    gps_tab(counter).tsi_amt3      := tsi_tab(3);     gps_tab(counter).prem_amt3     := prem_tab(3);
    gps_tab(counter).tsi_amt4      := tsi_tab(4);     gps_tab(counter).prem_amt4     := prem_tab(4);
    gps_tab(counter).tsi_amt5      := tsi_tab(5);     gps_tab(counter).prem_amt5     := prem_tab(5);
    gps_tab(counter).tsi_amt6      := tsi_tab(6);     gps_tab(counter).prem_amt6     := prem_tab(6);
    gps_tab(counter).tsi_amt7      := tsi_tab(7);     gps_tab(counter).prem_amt7     := prem_tab(7);
    gps_tab(counter).tsi_amt8      := tsi_tab(8);     gps_tab(counter).prem_amt8     := prem_tab(8);
    gps_tab(counter).tsi_amt9      := tsi_tab(9);     gps_tab(counter).prem_amt9     := prem_tab(9);
    gps_tab(counter).tsi_amt10     := tsi_tab(10);    gps_tab(counter).prem_amt10    := prem_tab(10);
    gps_tab(counter).tsi_amt := NVL(tsi_tab(1),0) + NVL(tsi_tab(2),0) + NVL(tsi_tab(3),0) + NVL(tsi_tab(4),0) + NVL(tsi_tab(5),0) +
    NVL(tsi_tab(6),0) + NVL(tsi_tab(7),0) + NVL(tsi_tab(8),0) + NVL(tsi_tab(9),0) + NVL(tsi_tab(10),0) ;
    gps_tab(counter).prem_amt := NVL(prem_tab(1),0) + NVL(prem_tab(2),0) + NVL(prem_tab(3),0) + NVL(prem_tab(4),0) + NVL(prem_tab(5),0) +
    NVL(prem_tab(6),0) + NVL(prem_tab(7),0) + NVL(prem_tab(8),0) + NVL(prem_tab(9),0) + NVL(prem_tab(10),0) ;
    IF j.iss_cd != 'RI' THEN
    FOR tax2 IN NVL(p_tax_amt.FIRST,1)..NVL(p_tax_amt.LAST,1) LOOP
      IF p_tax_amt.EXISTS(tax2) THEN
        IF tax2 IN (1) THEN
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).tax := NVL(gps_tab(counter).tax,0) + NVL(p_tax_amt(tax2),0);
          ELSE
      gps_tab(counter).tax := NVL(p_tax_amt(tax2),0);
          END IF;
        ELSIF tax2 IN (2) THEN
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).prem_tax := NVL(gps_tab(counter).prem_tax,0) + NVL(p_tax_amt(tax2),0);
          ELSE
            gps_tab(counter).prem_tax := NVL(p_tax_amt(tax2),0);
          END IF;
        ELSIF tax2 IN (10) THEN
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).fst := NVL(gps_tab(counter).fst,0) + NVL(p_tax_amt(tax2),0);
          ELSE
            gps_tab(counter).fst := NVL(p_tax_amt(tax2),0);
          END IF;
        ELSIF tax2 IN (9) THEN
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).lgt := NVL(gps_tab(counter).lgt,0) + NVL(p_tax_amt(tax2),0);
          ELSE
            gps_tab(counter).lgt := NVL(p_tax_amt(tax2),0);
          END IF;
        ELSIF tax2 IN (8) THEN
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).stamp := NVL(gps_tab(counter).stamp,0) + NVL(p_tax_amt(tax2),0);
          ELSE
            gps_tab(counter).stamp := NVL(p_tax_amt(tax2),0);
          END IF;
        ELSE
          IF gps_tab.EXISTS(tax2) THEN
            gps_tab(counter).other := NVL(gps_tab(counter).other,0) + NVL(p_tax_amt(tax2),0);
          ELSE
            gps_tab(counter).other := NVL(p_tax_amt(tax2),0);
          END IF;
  END IF;
      END IF;
    END LOOP;
    END IF;  -- iss_cd != 'ri'
  END LOOP j;
DBMS_OUTPUT.PUT_LINE('START OF TREATY   : '||TO_CHAR(SYSDATE,'MM-DD-YYYY HH:MI:SS AM'));
  -- part ii of iv
  -- for treaty distributions
  FOR ja_tr IN
   (SELECT a.policy_id, a.acct_ent_date, a.acct_neg_date, NVL(e.column_no,10) column_no,
    SUM(DECODE(NVL(c.dist_tsi,0),0,0,DECODE(f.peril_type,'A',0,DECODE(TO_CHAR(g.spld_acct_ent_date,'MM-DD-YYYY'),
TO_CHAR(param_date,'MM-DD-YYYY'),c.dist_tsi * NVL(b.currency_rt,1)*-1,DECODE(TO_CHAR(g.acct_ent_date,'MM-DD-YYYY'),TO_CHAR(param_date,'MM-DD-YYYY'),c.dist_tsi * NVL(b.currency_rt,1),0))))) dist_tsi,
    SUM(DECODE(NVL(c.dist_prem,0),0,0,DECODE(TO_CHAR(G.SPLD_acct_ent_date,'MM-DD-YYYY'),
TO_CHAR(param_date,'MM-DD-YYYY'),c.dist_prem * NVL(b.currency_rt,1)*-1,DECODE(TO_CHAR(g.acct_ent_date,'MM-DD-YYYY'),TO_CHAR(param_date,'MM-DD-YYYY'),c.dist_prem * NVL(b.currency_rt,1),0)))) dist_prem
    FROM GIUW_POL_DIST a,  GIPI_POLBASIC g,      GIPI_ITEM     b,          GIUW_ITEMPERILDS_DTL c,
         GIIS_DIST_SHARE d,      GIAC_ACCT_REGISTER_DTL e, GIIS_PERIL f
    WHERE a.policy_id = b.policy_id
 AND a.policy_id=g.policy_id
    AND a.dist_no = c.dist_no
    AND b.item_no = c.item_no
    AND c.line_cd = d.line_cd
    AND c.share_cd = d.share_cd
    AND c.line_cd = e.line_cd(+)
    AND c.peril_cd = e.peril_cd(+)
    AND c.line_cd = f.line_cd
    AND c.peril_cd = f.peril_cd
    AND d.share_type = treaty
--and a.policy_id in (18999 , 19019,19023,19025,19033,19036,19039,19041,19045,19083,19092)
    AND (TO_CHAR(a.acct_ent_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY')
      OR TO_CHAR(a.acct_neg_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY'))
    GROUP BY a.policy_id, a.acct_ent_date, a.acct_neg_date, NVL(e.column_no,10)  ) LOOP
    -- to check if policy exists in gps table type
    treaty_switch := 'Y';
    pol_switch := 'N';
    IF gps_tab.EXISTS(1) THEN
       FOR check_pol IN gps_tab.FIRST..gps_tab.LAST LOOP
           IF gps_tab(check_pol).policy_id = ja_tr.policy_id THEN
              pol_switch := 'Y';
              EXIT;
           END IF;
    END LOOP;
    END IF;
--dbms_output.put_line('policy_id and policy_sw  : '|| to_char(ja_tr.policy_id)||'-'|| pol_switch);
    IF pol_switch = 'N' THEN
       Giac_Prod_Sum_Rep_Dtl(ja_tr.policy_id,p_par_id ,p_line_cd ,p_subline_cd ,p_iss_cd ,p_issue_yy ,p_pol_seq_no ,
         p_endt_iss_cd ,p_endt_yy ,p_endt_seq_no ,p_renew_no ,p_acct_ent_date ,p_spld_acct_ent_date,
         p_incept_date ,p_expiry_date ,p_intm_no ,p_intm_name, p_intm_type, p_parent_intm_no ,
      p_parent_intm_name, p_parent_intm_type, p_bill_no ,p_assd_no ,p_assd_name, p_tsi_amt , p_prem_amt,
p_ref_pol_no);
--         for init in 1..20 loop
--            tsi_tab(init):= 0;
--            prem_tab(init):= 0;
--         end loop;
         IF gps_tab.EXISTS(1) THEN
            counter := gps_tab.LAST + 1;
         ELSE
            counter := 1;
   END IF;
       gps_tab(counter).take_up_year  := TO_CHAR(param_date,'YYYY');
       gps_tab(counter).take_up_date  := param_date;
       gps_tab(counter).item_no1      := counter;
       gps_tab(counter).intm_no       := v_intm_no;
       gps_tab(counter).intm_name     := p_intm_name;
       gps_tab(counter).intm_type     := p_intm_type;
       gps_tab(counter).parent_intm_no:= v_parent_intm_no;
       gps_tab(counter).parent_intm_name:= p_parent_intm_name;
       gps_tab(counter).parent_intm_type:= p_parent_intm_type;
    gps_tab(counter).policy_id     := ja_tr.policy_id;gps_tab(counter).line_cd       :=
p_line_cd;
    gps_tab(counter).subline_cd    := p_subline_cd;  gps_tab(counter).iss_cd        :=
p_iss_cd;
    gps_tab(counter).issue_yy      := p_issue_yy;  gps_tab(counter).pol_seq_no    :=
p_pol_seq_no;
    gps_tab(counter).endt_iss_cd   := p_endt_iss_cd;  gps_tab(counter).endt_yy       :=
p_endt_yy;
    gps_tab(counter).endt_seq_no   := p_endt_seq_no;  gps_tab(counter).renew_no      :=
p_renew_no;
    gps_tab(counter).incept_date   := p_incept_date;  gps_tab(counter).expiry_date   :=
p_expiry_date;
       gps_tab(counter).prem_seq_no   := p_bill_no;      gps_tab(counter).acct_ent_date :=
p_acct_ent_date;
    gps_tab(counter).spld_acct_ent_date := p_spld_acct_ent_date;
       gps_tab(counter).intm_no       := p_intm_no;        gps_tab(counter).parent_intm_no := p_parent_intm_no;
    gps_tab(counter).assd_no       := p_assd_no;      gps_tab(counter).assd_name     :=
p_assd_name;
       pol_switch := 'Y';
 END IF ;  --if pol_switch = 'n' then
    IF ja_tr.policy_id != NVL(policy_id,0) THEN
      IF policy_id IS NOT NULL THEN  -- so it won't enter here on the first run
        FOR rec IN gps_tab.FIRST..gps_tab.LAST LOOP
          IF gps_tab(rec).policy_id = policy_id THEN
             gps_tab(rec).tr_tsi_amt1    := tsi_tab(1);  gps_tab(rec).tr_prem_amt1   := prem_tab(1);
             gps_tab(rec).tr_tsi_amt2    := tsi_tab(2);  gps_tab(rec).tr_prem_amt2   := prem_tab(2);
             gps_tab(rec).tr_tsi_amt3    := tsi_tab(3);  gps_tab(rec).tr_prem_amt3   := prem_tab(3);
             gps_tab(rec).tr_tsi_amt4    := tsi_tab(4);  gps_tab(rec).tr_prem_amt4   := prem_tab(4);
             gps_tab(rec).tr_tsi_amt5    := tsi_tab(5);  gps_tab(rec).tr_prem_amt5   := prem_tab(5);
             gps_tab(rec).tr_tsi_amt6    := tsi_tab(6);  gps_tab(rec).tr_prem_amt6   := prem_tab(6);
             gps_tab(rec).tr_tsi_amt7    := tsi_tab(7);  gps_tab(rec).tr_prem_amt7   := prem_tab(7);
             gps_tab(rec).tr_tsi_amt8    := tsi_tab(8);  gps_tab(rec).tr_prem_amt8   := prem_tab(8);
             gps_tab(rec).tr_tsi_amt9    := tsi_tab(9);  gps_tab(rec).tr_prem_amt9   := prem_tab(9);
             gps_tab(rec).tr_tsi_amt10   := tsi_tab(10); gps_tab(rec).tr_prem_amt10  := prem_tab(10);
             gps_tab(rec).uw_acct_ent_date := ja_tr.acct_ent_date;
       gps_tab(rec).uw_acct_neg_date := ja_tr.acct_neg_date;
             EXIT;
          END IF;
        END LOOP rec;
      END IF;
      FOR init IN 1..20 LOOP
          tsi_tab(init):= 0;
          prem_tab(init):= 0;
      END LOOP;
      policy_id := ja_tr.policy_id;
      tsi_tab(ja_tr.column_no)  := ja_tr.dist_tsi;
   prem_tab(ja_tr.column_no) := ja_tr.dist_prem;
--dbms_output.put_line('tsi_tab(ja_tr.column_no)  : '|| to_char(tsi_tab(ja_tr.column_no)));
--dbms_output.put_line('prem_tab(ja_tr.column_no)  : '|| to_char(prem_tab(ja_tr.column_no)));
    ELSIF ja_tr.policy_id = NVL(policy_id,0) THEN
      tsi_tab(ja_tr.column_no)  := ja_tr.dist_tsi;
   prem_tab(ja_tr.column_no) := ja_tr.dist_prem;
 END IF;
  END LOOP ja;
  -- for the last record of the treaty which didn't enter the inner loop
  IF treaty_switch = 'Y' THEN
    FOR rec IN gps_tab.FIRST..gps_tab.LAST LOOP
      IF gps_tab(rec).policy_id = policy_id THEN
         gps_tab(rec).tr_tsi_amt1    := tsi_tab(1);  gps_tab(rec).tr_prem_amt1   := prem_tab(1);
         gps_tab(rec).tr_tsi_amt2    := tsi_tab(2);  gps_tab(rec).tr_prem_amt2   := prem_tab(2);
         gps_tab(rec).tr_tsi_amt3    := tsi_tab(3);  gps_tab(rec).tr_prem_amt3   := prem_tab(3);
         gps_tab(rec).tr_tsi_amt4    := tsi_tab(4);  gps_tab(rec).tr_prem_amt4   := prem_tab(4);
         gps_tab(rec).tr_tsi_amt5    := tsi_tab(5);  gps_tab(rec).tr_prem_amt5   := prem_tab(5);
         gps_tab(rec).tr_tsi_amt6    := tsi_tab(6);  gps_tab(rec).tr_prem_amt6   := prem_tab(6);
         gps_tab(rec).tr_tsi_amt7    := tsi_tab(7);  gps_tab(rec).tr_prem_amt7   := prem_tab(7);
         gps_tab(rec).tr_tsi_amt8    := tsi_tab(8);  gps_tab(rec).tr_prem_amt8   := prem_tab(8);
         gps_tab(rec).tr_tsi_amt9    := tsi_tab(9);  gps_tab(rec).tr_prem_amt9   := prem_tab(9);
         gps_tab(rec).tr_tsi_amt10   := tsi_tab(10); gps_tab(rec).tr_prem_amt10  := prem_tab(10);
         EXIT;
      END IF;
    END LOOP;
  END IF;
DBMS_OUTPUT.PUT_LINE('START OF FACUL  : '||TO_CHAR(SYSDATE,'MM-DD-YYYY HH:MI:SS AM'));
  -- part iii of iv
  -- for outward facul distribution
  policy_id := 0;
  FOR ja_fa IN
   (SELECT a.policy_id, a.fnl_binder_id, a.line_cd, a.binder_yy,
    a.binder_seq_no, a.ri_cd, a.ri_sname,
    NVL(b.column_no,10) column_no, a.peril_cd, a.acc_ent_date, a.acc_rev_date,
    a.tsi_amt, a.prem_amt,
    SUM(DECODE(TO_CHAR(a.acc_ent_date,'MM-DD-YYYY'),
  TO_CHAR(param_date,'MM-DD-YYYY'),
  NVL(ri_tsi_amt,0) * (a.ri_peril_prem_amt/a.ri_prem_amt) * NVL(currency_rt,1),
 (NVL(ri_tsi_amt,0) * NVL(currency_rt,1)) * -1 *
  (a.ri_peril_prem_amt/a.ri_prem_amt ))) ri_tsi_amt,
    SUM(DECODE(TO_CHAR(a.acc_ent_date,'MM-DD-YYYY'),
  TO_CHAR(param_date,'MM-DD-YYYY'), NVL(ri_peril_prem_amt,0) * NVL(currency_rt,1),
  NVL(ri_peril_prem_amt,0) * NVL(currency_rt,1) * -1 )) ri_prem_amt
    FROM giri_binder_pol_peril_v a,
         GIAC_ACCT_REGISTER_DTL  b
    WHERE a.line_cd = b.line_cd(+)
   AND a.peril_cd = b.peril_cd(+)
 AND NVL(a.ri_prem_amt,0) != 0
    AND (TO_CHAR(a.acc_ent_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY')
   OR TO_CHAR(a.acc_rev_date,'MM-DD-YYYY') = TO_CHAR(param_date,'MM-DD-YYYY'))
    GROUP BY a.policy_id, a.fnl_binder_id, a.line_cd, a.binder_yy, a.binder_seq_no, a.ri_cd, a.ri_sname,
    NVL(b.column_no,10) , a.peril_cd, a.acc_ent_date, a.acc_rev_date,a.tsi_amt, a.prem_amt
    UNION
  SELECT 999999999999,0,NULL,0,0,0,'X',0,0,SYSDATE,SYSDATE,0,0,0,0
 FROM dual
 ORDER BY 1,2,3,4,5,6,7,8,9,10,11,12,13 ) LOOP
    pol_switch := 'N';
 IF gps_tab.EXISTS(1) THEN -- just to check if the gps table type exists already
   FOR check_pol IN gps_tab.FIRST..gps_tab.LAST LOOP -- checks if policy already exists in table type
        IF gps_tab(check_pol).policy_id = ja_fa.policy_id AND gps_tab(check_pol).item_no2 IS NULL THEN
           pol_switch := 'Y';
     counter := check_pol;   --stores the rowid of the first record of the policy
     item1_counter := gps_tab(check_pol).item_no1; -- stores the item_no of the policy
           pol_switch2 := 'N';  item2_counter := 0;
           FOR rec IN gps_tab.FIRST..gps_tab.LAST LOOP
       IF gps_tab(rec).policy_id = ja_fa.policy_id AND gps_tab(rec).ri_cd = ja_fa.ri_cd THEN
                counter2 := rec;
    item2_counter := gps_tab(rec).item_no2;
                pol_switch2 := 'Y';
                EXIT;     --exit rec
             ELSIF gps_tab(rec).policy_id = ja_fa.policy_id THEN
                --accumulate the item_no2 to be used later for computation to get the next item_no2
       item2_counter := NVL(item2_counter,0) + NVL(gps_tab(rec).item_no2,0);
             END IF;
     END LOOP;      --end loop checking of ri
           IF pol_switch2 = 'N' THEN -- therefore the policy is existing but the ri is not
              IF item2_counter = 0 THEN
       item2_counter := 1;
     ELSE
                FOR a IN 1..500 LOOP   -- loop to get the next item_no2
                  IF item2_counter != a THEN
                    item2_counter := item2_counter - a;
                  ELSE
        item2_counter := item2_counter + 1;
        EXIT;
      END IF;
                END LOOP;
              END IF;
           counter2 := gps_tab.LAST + 1;
           END IF;
           EXIT;   --exit policy checking
        END IF;
      END LOOP check_pol;
 END IF; -- gps_tab.exists(1)
    IF pol_switch = 'N' THEN -- policy to be inserted is missing
      IF ja_fa.policy_id != 999999999999 THEN
       Giac_Prod_Sum_Rep_Dtl(ja_fa.policy_id, p_par_id ,p_line_cd ,p_subline_cd ,p_iss_cd ,p_issue_yy ,p_pol_seq_no ,
         p_endt_iss_cd ,p_endt_yy ,p_endt_seq_no ,p_renew_no ,p_acct_ent_date ,p_spld_acct_ent_date,
         p_incept_date ,p_expiry_date ,p_intm_no ,p_intm_name, p_intm_type, p_parent_intm_no ,
   p_parent_intm_name, p_parent_intm_type, p_bill_no ,p_assd_no ,p_assd_name, p_tsi_amt, p_prem_amt,
p_ref_pol_no);
         FOR init IN 1..20 LOOP
            tsi_tab(init):= 0;
            prem_tab(init):= 0;
         END LOOP;
         IF gps_tab.EXISTS(1) THEN
            counter := gps_tab.LAST + 1;
            item1_counter := gps_tab(gps_tab.LAST).item_no1 + 1;
            counter2 := counter + 1;
            item2_counter := 1;
         ELSE
            counter := 1;
            item1_counter := 1;
            counter2 := counter + 1;
        item2_counter := 1;
   END IF;
         gps_tab(counter).take_up_year  := TO_CHAR(param_date,'YYYY');
         gps_tab(counter).take_up_date  := param_date;
      gps_tab(counter).item_no1      := item1_counter;
         gps_tab(counter).intm_no       := v_intm_no;
         gps_tab(counter).intm_name     := p_intm_name;
         gps_tab(counter).intm_type     := p_intm_type;
         gps_tab(counter).parent_intm_no:= v_parent_intm_no;
         gps_tab(counter).parent_intm_name:= p_parent_intm_name;
         gps_tab(counter).parent_intm_type:= p_parent_intm_type;
      gps_tab(counter).policy_id     := ja_fa.policy_id;  gps_tab(counter).line_cd       :=
p_line_cd;
      gps_tab(counter).subline_cd    := p_subline_cd;  gps_tab(counter).iss_cd        :=
p_iss_cd;
      gps_tab(counter).issue_yy      := p_issue_yy;      gps_tab(counter).pol_seq_no    :=
p_pol_seq_no;
      gps_tab(counter).endt_iss_cd   := p_endt_iss_cd;  gps_tab(counter).endt_yy       :=
p_endt_yy;
      gps_tab(counter).endt_seq_no   := p_endt_seq_no;  gps_tab(counter).renew_no      :=
p_renew_no;
      gps_tab(counter).incept_date   := p_incept_date;  gps_tab(counter).expiry_date   :=
p_expiry_date;
         gps_tab(counter).prem_seq_no   := p_bill_no;      gps_tab(counter).acct_ent_date := p_acct_ent_date;
      gps_tab(counter).spld_acct_ent_date := p_spld_acct_ent_date;
         gps_tab(counter).intm_no       := p_intm_no;        gps_tab(counter).parent_intm_no := p_parent_intm_no;
      gps_tab(counter).assd_no       := p_assd_no;      gps_tab(counter).assd_name     :=
p_assd_name;
      END IF;
      pol_switch := 'Y';
 END IF;  --pol_switch = 'n'
    -- end of checking of the existence of the policy and ri in the table type
    -- start to transfer data to table type
    FOR a IN 1..50 LOOP
   tsi_tab(a)  := 0;
   prem_tab(a) := 0;
    END LOOP;
    tsi_tab(ja_fa.column_no) :=  ja_fa.ri_tsi_amt;
 prem_tab(ja_fa.column_no) := ja_fa.ri_prem_amt;
    IF ja_fa.policy_id != 999999999999 THEN
      -- to accumulate ri_tsi_amt and ri_prem_amt for the ri_data
      gps_tab(counter2).policy_id     := ja_fa.policy_id;
      gps_tab(counter2).line_cd       := ja_fa.line_cd;
      gps_tab(counter2).subline_cd    := gps_tab(counter).subline_cd;
      gps_tab(counter2).iss_cd        := gps_tab(counter).iss_cd;
      gps_tab(counter2).issue_yy      := gps_tab(counter).issue_yy;
      gps_tab(counter2).pol_seq_no    := gps_tab(counter).pol_seq_no;
      gps_tab(counter2).renew_no      := gps_tab(counter).renew_no;
      gps_tab(counter2).endt_iss_cd   := gps_tab(counter).endt_iss_cd;
      gps_tab(counter2).endt_yy       := gps_tab(counter).endt_yy;
      gps_tab(counter2).endt_seq_no   := gps_tab(counter).endt_seq_no;
      gps_tab(counter2).incept_date   := gps_tab(counter).incept_date;
      gps_tab(counter2).expiry_date   := gps_tab(counter).expiry_date;
      gps_tab(counter2).acct_ent_date := gps_tab(counter).acct_ent_date;
      gps_tab(counter2).spld_acct_ent_date := gps_tab(counter).spld_acct_ent_date;
      gps_tab(counter2).prem_seq_no   := gps_tab(counter).prem_seq_no;
      gps_tab(counter2).assd_no       := gps_tab(counter).assd_no;
      gps_tab(counter2).assd_name     := gps_tab(counter).assd_name;
      gps_tab(counter2).intm_no       := gps_tab(counter).intm_no;
      gps_tab(counter2).intm_type     := gps_tab(counter).intm_type;
      gps_tab(counter2).intm_name     := gps_tab(counter).intm_name;
      gps_tab(counter2).parent_intm_no:= gps_tab(counter).parent_intm_no;
      gps_tab(counter2).parent_intm_type:= gps_tab(counter).parent_intm_type;
      gps_tab(counter2).parent_intm_name:= gps_tab(counter).parent_intm_name;
      gps_tab(counter2).take_up_date  := param_date;
      gps_tab(counter2).take_up_year  := TO_CHAR(param_date,'YYYY');
      gps_tab(counter2).item_no1      := item1_counter;
      gps_tab(counter2).item_no2      := item2_counter;
        IF NVL(item2_counter,0) != 0 THEN
    gps_tab(counter2).tsi_amt := ja_fa.tsi_amt;
    gps_tab(counter2).prem_amt := ja_fa.prem_amt;
        END IF;
      gps_tab(counter2).ri_cd         := ja_fa.ri_cd;
      gps_tab(counter2).ri_name       := ja_fa.ri_sname;
      gps_tab(counter2).fnl_binder_id := ja_fa.fnl_binder_id;
      gps_tab(counter2).binder_line_cd:= ja_fa.line_cd;
      gps_tab(counter2).binder_yy     := ja_fa.binder_yy;
      gps_tab(counter2).binder_seq_no := ja_fa.binder_seq_no;
      gps_tab(counter2).of_acc_ent_date := ja_fa.acc_ent_date;
      gps_tab(counter2).of_acc_rev_date := ja_fa.acc_rev_date;
      gps_tab(counter2).fa_tsi_amt1   := NVL(gps_tab(counter2).fa_tsi_amt1,0) + tsi_tab(1);
      gps_tab(counter2).fa_tsi_amt2   := NVL(gps_tab(counter2).fa_tsi_amt2,0) + tsi_tab(2);
      gps_tab(counter2).fa_tsi_amt3   := NVL(gps_tab(counter2).fa_tsi_amt3,0) + tsi_tab(3);
      gps_tab(counter2).fa_tsi_amt4   := NVL(gps_tab(counter2).fa_tsi_amt4,0) + tsi_tab(4);
      gps_tab(counter2).fa_tsi_amt5   := NVL(gps_tab(counter2).fa_tsi_amt5,0) + tsi_tab(5);
      gps_tab(counter2).fa_tsi_amt6   := NVL(gps_tab(counter2).fa_tsi_amt6,0) + tsi_tab(6);
      gps_tab(counter2).fa_tsi_amt7   := NVL(gps_tab(counter2).fa_tsi_amt7,0) + tsi_tab(7);
      gps_tab(counter2).fa_tsi_amt8   := NVL(gps_tab(counter2).fa_tsi_amt8,0) + tsi_tab(8);
      gps_tab(counter2).fa_tsi_amt9   := NVL(gps_tab(counter2).fa_tsi_amt9,0) + tsi_tab(9);
      gps_tab(counter2).fa_tsi_amt10  := NVL(gps_tab(counter2).fa_tsi_amt10,0) + tsi_tab(10);
      gps_tab(counter2).fa_prem_amt1  := NVL(gps_tab(counter2).fa_prem_amt1,0) + prem_tab(1);
      gps_tab(counter2).fa_prem_amt2  := NVL(gps_tab(counter2).fa_prem_amt2,0) + prem_tab(2);
      gps_tab(counter2).fa_prem_amt3  := NVL(gps_tab(counter2).fa_prem_amt3,0) + prem_tab(3);
      gps_tab(counter2).fa_prem_amt4  := NVL(gps_tab(counter2).fa_prem_amt4,0) + prem_tab(4);
      gps_tab(counter2).fa_prem_amt5  := NVL(gps_tab(counter2).fa_prem_amt5,0) + prem_tab(5);
      gps_tab(counter2).fa_prem_amt6  := NVL(gps_tab(counter2).fa_prem_amt6,0) + prem_tab(6);
      gps_tab(counter2).fa_prem_amt7  := NVL(gps_tab(counter2).fa_prem_amt7,0) + prem_tab(7);
      gps_tab(counter2).fa_prem_amt8  := NVL(gps_tab(counter2).fa_prem_amt8,0) + prem_tab(8);
      gps_tab(counter2).fa_prem_amt9  := NVL(gps_tab(counter2).fa_prem_amt9,0) + prem_tab(9);
      gps_tab(counter2).fa_prem_amt10 := NVL(gps_tab(counter2).fa_prem_amt10,0)+ prem_tab(10);
      -- accumulate the ri_tsi_amt and ri_prem_amt to the the original policy data
      gps_tab(counter).fa_tsi_amt1   := NVL(gps_tab(counter).fa_tsi_amt1,0)  + tsi_tab(1);
      gps_tab(counter).fa_tsi_amt2   := NVL(gps_tab(counter).fa_tsi_amt2,0)  + tsi_tab(2);
      gps_tab(counter).fa_tsi_amt3   := NVL(gps_tab(counter).fa_tsi_amt3,0)  + tsi_tab(3);
      gps_tab(counter).fa_tsi_amt4   := NVL(gps_tab(counter).fa_tsi_amt4,0)  + tsi_tab(4);
      gps_tab(counter).fa_tsi_amt5   := NVL(gps_tab(counter).fa_tsi_amt5,0)  + tsi_tab(5);
      gps_tab(counter).fa_tsi_amt6   := NVL(gps_tab(counter).fa_tsi_amt6,0)  + tsi_tab(6);
      gps_tab(counter).fa_tsi_amt7   := NVL(gps_tab(counter).fa_tsi_amt7,0)  + tsi_tab(7);
      gps_tab(counter).fa_tsi_amt8   := NVL(gps_tab(counter).fa_tsi_amt8,0)  + tsi_tab(8);
      gps_tab(counter).fa_tsi_amt9   := NVL(gps_tab(counter).fa_tsi_amt9,0)  + tsi_tab(9);
      gps_tab(counter).fa_tsi_amt10  := NVL(gps_tab(counter).fa_tsi_amt10,0) + tsi_tab(10);
      gps_tab(counter).fa_prem_amt1  := NVL(gps_tab(counter).fa_prem_amt1,0) + prem_tab(1);
      gps_tab(counter).fa_prem_amt2  := NVL(gps_tab(counter).fa_prem_amt2,0) + prem_tab(2);
      gps_tab(counter).fa_prem_amt3  := NVL(gps_tab(counter).fa_prem_amt3,0) + prem_tab(3);
      gps_tab(counter).fa_prem_amt4  := NVL(gps_tab(counter).fa_prem_amt4,0) + prem_tab(4);
      gps_tab(counter).fa_prem_amt5  := NVL(gps_tab(counter).fa_prem_amt5,0) + prem_tab(5);
      gps_tab(counter).fa_prem_amt6  := NVL(gps_tab(counter).fa_prem_amt6,0) + prem_tab(6);
      gps_tab(counter).fa_prem_amt7  := NVL(gps_tab(counter).fa_prem_amt7,0) + prem_tab(7);
      gps_tab(counter).fa_prem_amt8  := NVL(gps_tab(counter).fa_prem_amt8,0) + prem_tab(8);
      gps_tab(counter).fa_prem_amt9  := NVL(gps_tab(counter).fa_prem_amt9,0) + prem_tab(9);
      gps_tab(counter).fa_prem_amt10 := NVL(gps_tab(counter).fa_prem_amt10,0)+ prem_tab(10);
    END IF;
  END LOOP ja_fa;
  -- insert table_type into giac_production_summary
DBMS_OUTPUT.PUT_LINE('START INSERT TO TABLE :  '||TO_CHAR(SYSDATE,'MM-DD-YYYY HH:MI:SS AM'));
  IF gps_tab.EXISTS(1) THEN
  FOR cur IN gps_tab.FIRST..gps_tab.LAST LOOP
--    if  nvl(gps_tab(cur).tsi_amt1,0) = 0 and nvl(gps_tab(cur).prem_amt1,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt1 := NVL(gps_tab(cur).tsi_amt1,0) - (NVL(gps_tab(cur).tr_tsi_amt1,0) +
NVL(gps_tab(cur).fa_tsi_amt1,0));
      gps_tab(cur).nr_prem_amt1 := NVL(gps_tab(cur).prem_amt1,0) - (NVL(gps_tab(cur).tr_prem_amt1,0) +
NVL(gps_tab(cur).fa_prem_amt1,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt2,0) = 0 and nvl(gps_tab(cur).prem_amt2,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt2 := NVL(gps_tab(cur).tsi_amt2,0) - (NVL(gps_tab(cur).tr_tsi_amt2,0) +
NVL(gps_tab(cur).fa_tsi_amt2,0));
      gps_tab(cur).nr_prem_amt2 := NVL(gps_tab(cur).prem_amt2,0) - (NVL(gps_tab(cur).tr_prem_amt2,0) +
NVL(gps_tab(cur).fa_prem_amt2,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt3,0) = 0 and nvl(gps_tab(cur).prem_amt3,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt3 := NVL(gps_tab(cur).tsi_amt3,0) - (NVL(gps_tab(cur).tr_tsi_amt3,0) +
NVL(gps_tab(cur).fa_tsi_amt3,0));
      gps_tab(cur).nr_prem_amt3 := NVL(gps_tab(cur).prem_amt3,0) - (NVL(gps_tab(cur).tr_prem_amt3,0) +
NVL(gps_tab(cur).fa_prem_amt3,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt4,0) = 0 and nvl(gps_tab(cur).prem_amt4,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt4 := NVL(gps_tab(cur).tsi_amt4,0) - (NVL(gps_tab(cur).tr_tsi_amt4,0) +
NVL(gps_tab(cur).fa_tsi_amt4,0));
      gps_tab(cur).nr_prem_amt4 := NVL(gps_tab(cur).prem_amt4,0) - (NVL(gps_tab(cur).tr_prem_amt4,0) +
NVL(gps_tab(cur).fa_prem_amt4,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt5,0) = 0 and nvl(gps_tab(cur).prem_amt5,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt5 := NVL(gps_tab(cur).tsi_amt5,0) - (NVL(gps_tab(cur).tr_tsi_amt5,0) +
NVL(gps_tab(cur).fa_tsi_amt5,0));
      gps_tab(cur).nr_prem_amt5 := NVL(gps_tab(cur).prem_amt5,0) - (NVL(gps_tab(cur).tr_prem_amt5,0) +
NVL(gps_tab(cur).fa_prem_amt5,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt6,0) = 0 and nvl(gps_tab(cur).prem_amt6,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt6 := NVL(gps_tab(cur).tsi_amt6,0) - (NVL(gps_tab(cur).tr_tsi_amt6,0) +
NVL(gps_tab(cur).fa_tsi_amt6,0));
      gps_tab(cur).nr_prem_amt6 := NVL(gps_tab(cur).prem_amt6,0) - (NVL(gps_tab(cur).tr_prem_amt6,0) +
NVL(gps_tab(cur).fa_prem_amt6,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt7,0) = 0 and nvl(gps_tab(cur).prem_amt7,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt7 := NVL(gps_tab(cur).tsi_amt7,0) - (NVL(gps_tab(cur).tr_tsi_amt7,0) +
NVL(gps_tab(cur).fa_tsi_amt7,0));
      gps_tab(cur).nr_prem_amt7 := NVL(gps_tab(cur).prem_amt7,0) - (NVL(gps_tab(cur).tr_prem_amt7,0) +
NVL(gps_tab(cur).fa_prem_amt7,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt8,0) = 0 and nvl(gps_tab(cur).prem_amt8,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt8 := NVL(gps_tab(cur).tsi_amt8,0) - (NVL(gps_tab(cur).tr_tsi_amt8,0) +
NVL(gps_tab(cur).fa_tsi_amt8,0));
      gps_tab(cur).nr_prem_amt8 := NVL(gps_tab(cur).prem_amt8,0) - (NVL(gps_tab(cur).tr_prem_amt8,0) +
NVL(gps_tab(cur).fa_prem_amt8,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt9,0) = 0 and nvl(gps_tab(cur).prem_amt9,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt9 := NVL(gps_tab(cur).tsi_amt9,0) - (NVL(gps_tab(cur).tr_tsi_amt9,0) +
NVL(gps_tab(cur).fa_tsi_amt9,0));
      gps_tab(cur).nr_prem_amt9 := NVL(gps_tab(cur).prem_amt9,0) - (NVL(gps_tab(cur).tr_prem_amt9,0) +
NVL(gps_tab(cur).fa_prem_amt9,0));
--    end if;
--    if  nvl(gps_tab(cur).tsi_amt10,0) = 0 and nvl(gps_tab(cur).prem_amt10,0) = 0 then   null;
--    else
      gps_tab(cur).nr_tsi_amt10:= NVL(gps_tab(cur).tsi_amt10,0)- (NVL(gps_tab(cur).tr_tsi_amt10,0) +
NVL(gps_tab(cur).fa_tsi_amt10,0));
      gps_tab(cur).nr_prem_amt10:= NVL(gps_tab(cur).prem_amt10,0)- (NVL(gps_tab(cur).tr_prem_amt10,0) +
NVL(gps_tab(cur).fa_prem_amt10,0));
--    end if;
    INSERT INTO GIAC_PRODUCTION_SUMMARY
      (take_up_year, take_up_date, item_no1, item_no2, policy_id, line_cd, subline_cd, iss_cd, issue_yy,
pol_seq_no, endt_iss_cd, endt_yy, endt_seq_no, renew_no, incept_date,
    expiry_date, assd_no, assd_name, intm_no, intm_name, intm_type, parent_intm_no,
parent_intm_name, parent_intm_type,
    acct_ent_date, spld_acct_ent_date, prem_seq_no, tsi_amt1, prem_amt1, tsi_amt2,
prem_amt2,
    tsi_amt3, prem_amt3, tsi_amt4, prem_amt4, tsi_amt5, prem_amt5, tsi_amt6, prem_amt6,
    tsi_amt7, prem_amt7, tsi_amt8, prem_amt8, tsi_amt9, prem_amt9, tsi_amt10,prem_amt10,
    nr_tsi_amt1, nr_prem_amt1, nr_tsi_amt2, nr_prem_amt2, nr_tsi_amt3, nr_prem_amt3,
    nr_tsi_amt4, nr_prem_amt4, nr_tsi_amt5, nr_prem_amt5, nr_tsi_amt6, nr_prem_amt6,
    nr_tsi_amt7, nr_prem_amt7, nr_tsi_amt8, nr_prem_amt8, nr_tsi_amt9, nr_prem_amt9,
    nr_tsi_amt10,nr_prem_amt10, tax, fst,lgt,other, stamp, prem_tax,
    tr_tsi_amt1, tr_prem_amt1, tr_tsi_amt2, tr_prem_amt2, tr_tsi_amt3, tr_prem_amt3,
    tr_tsi_amt4, tr_prem_amt4, tr_tsi_amt5, tr_prem_amt5, tr_tsi_amt6, tr_prem_amt6,
    tr_tsi_amt7, tr_prem_amt7, tr_tsi_amt8, tr_prem_amt8, tr_tsi_amt9, tr_prem_amt9,
    tr_tsi_amt10, tr_prem_amt10, uw_acct_ent_date, uw_acct_neg_date ,
    fa_tsi_amt1, fa_prem_amt1, fa_tsi_amt2, fa_prem_amt2, fa_tsi_amt3, fa_prem_amt3,
    fa_tsi_amt4, fa_prem_amt4, fa_tsi_amt5, fa_prem_amt5, fa_tsi_amt6, fa_prem_amt6,
    fa_tsi_amt7, fa_prem_amt7, fa_tsi_amt8, fa_prem_amt8, fa_tsi_amt9, fa_prem_amt9,
    fa_tsi_amt10, fa_prem_amt10, of_acc_ent_date, of_acc_rev_date,
    ri_cd, ri_name, fnl_binder_id, binder_line_cd, binder_yy, binder_seq_no,
    eq_zone, district, block_model_year, item_title_make, tariff_cd_coc,
       tsi_amt, prem_amt, ref_pol_no   )
 VALUES
      (gps_tab(cur).take_up_year, gps_tab(cur).take_up_date, gps_tab(cur).item_no1,
gps_tab(cur).item_no2, gps_tab(cur).policy_id, gps_tab(cur).line_cd, gps_tab(cur).subline_cd,
gps_tab(cur).iss_cd,
    gps_tab(cur).issue_yy, gps_tab(cur).pol_seq_no, gps_tab(cur).endt_iss_cd,
gps_tab(cur).endt_yy, gps_tab(cur).endt_seq_no, gps_tab(cur).renew_no,
gps_tab(cur).incept_date,
    gps_tab(cur).expiry_date, gps_tab(cur).assd_no, gps_tab(cur).assd_name,
gps_tab(cur).intm_no, gps_tab(cur).intm_name, gps_tab(cur).intm_type,
gps_tab(cur).parent_intm_no, gps_tab(cur).parent_intm_name, gps_tab(cur).parent_intm_type,
    gps_tab(cur).acct_ent_date, gps_tab(cur).spld_acct_ent_date,
gps_tab(cur).prem_seq_no, gps_tab(cur).tsi_amt1, gps_tab(cur).prem_amt1,
gps_tab(cur).tsi_amt2, gps_tab(cur).prem_amt2,
    gps_tab(cur).tsi_amt3, gps_tab(cur).prem_amt3, gps_tab(cur).tsi_amt4,
gps_tab(cur).prem_amt4, gps_tab(cur).tsi_amt5, gps_tab(cur).prem_amt5, gps_tab(cur).tsi_amt6,
gps_tab(cur).prem_amt6,
    gps_tab(cur).tsi_amt7, gps_tab(cur).prem_amt7, gps_tab(cur).tsi_amt8,
gps_tab(cur).prem_amt8, gps_tab(cur).tsi_amt9, gps_tab(cur).prem_amt9,
gps_tab(cur).tsi_amt10,gps_tab(cur).prem_amt10,
    gps_tab(cur).nr_tsi_amt1, gps_tab(cur).nr_prem_amt1, gps_tab(cur).nr_tsi_amt2,
gps_tab(cur).nr_prem_amt2, gps_tab(cur).nr_tsi_amt3, gps_tab(cur).nr_prem_amt3,
    gps_tab(cur).nr_tsi_amt4, gps_tab(cur).nr_prem_amt4, gps_tab(cur).nr_tsi_amt5,
gps_tab(cur).nr_prem_amt5, gps_tab(cur).nr_tsi_amt6, gps_tab(cur).nr_prem_amt6,
    gps_tab(cur).nr_tsi_amt7, gps_tab(cur).nr_prem_amt7, gps_tab(cur).nr_tsi_amt8,
gps_tab(cur).nr_prem_amt8, gps_tab(cur).nr_tsi_amt9, gps_tab(cur).nr_prem_amt9,
    gps_tab(cur).nr_tsi_amt10,gps_tab(cur).nr_prem_amt10,gps_tab(cur).tax,
gps_tab(cur).fst, gps_tab(cur).lgt, gps_tab(cur).other, gps_tab(cur).stamp,
gps_tab(cur).prem_tax,
    gps_tab(cur).tr_tsi_amt1, gps_tab(cur).tr_prem_amt1, gps_tab(cur).tr_tsi_amt2,
gps_tab(cur).tr_prem_amt2, gps_tab(cur).tr_tsi_amt3, gps_tab(cur).tr_prem_amt3,
    gps_tab(cur).tr_tsi_amt4, gps_tab(cur).tr_prem_amt4, gps_tab(cur).tr_tsi_amt5,
gps_tab(cur).tr_prem_amt5, gps_tab(cur).tr_tsi_amt6, gps_tab(cur).tr_prem_amt6,
    gps_tab(cur).tr_tsi_amt7, gps_tab(cur).tr_prem_amt7, gps_tab(cur).tr_tsi_amt8,
gps_tab(cur).tr_prem_amt8, gps_tab(cur).tr_tsi_amt9, gps_tab(cur).tr_prem_amt9,
    gps_tab(cur).tr_tsi_amt10, gps_tab(cur).tr_prem_amt10, gps_tab(cur).uw_acct_ent_date,
gps_tab(cur).uw_acct_neg_date,
    gps_tab(cur).fa_tsi_amt1, gps_tab(cur).fa_prem_amt1, gps_tab(cur).fa_tsi_amt2,
gps_tab(cur).fa_prem_amt2, gps_tab(cur).fa_tsi_amt3, gps_tab(cur).fa_prem_amt3,
    gps_tab(cur).fa_tsi_amt4, gps_tab(cur).fa_prem_amt4, gps_tab(cur).fa_tsi_amt5,
gps_tab(cur).fa_prem_amt5, gps_tab(cur).fa_tsi_amt6, gps_tab(cur).fa_prem_amt6,
    gps_tab(cur).fa_tsi_amt7, gps_tab(cur).fa_prem_amt7, gps_tab(cur).fa_tsi_amt8,
gps_tab(cur).fa_prem_amt8, gps_tab(cur).fa_tsi_amt9, gps_tab(cur).fa_prem_amt9,
    gps_tab(cur).fa_tsi_amt10, gps_tab(cur).fa_prem_amt10, gps_tab(cur).of_acc_ent_date,
gps_tab(cur).of_acc_rev_date ,
    gps_tab(cur).ri_cd, gps_tab(cur).ri_name, gps_tab(cur).fnl_binder_id,
gps_tab(cur).binder_line_cd, gps_tab(cur).binder_yy, gps_tab(cur).binder_seq_no ,
    gps_tab(cur).eq_zone, gps_tab(cur).district, gps_tab(cur).block_model_year,
gps_tab(cur).item_title_make, gps_tab(cur).tariff_cd_coc,
       gps_tab(cur).tsi_amt,  gps_tab(cur).prem_amt, gps_tab(cur).ref_pol_no    );
 END LOOP;
  END IF;
DBMS_OUTPUT.PUT_LINE('END OF PROCEDURE :  '||TO_CHAR(SYSDATE,'MM-DD-YYYY HH:MI:SS AM'));
END;
/



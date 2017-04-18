CREATE OR REPLACE PACKAGE BODY CPI.Casualty_Accum
/* Created By : Ramon
** Desciption : this package will hold all the procedures and functions that will
**              handle the extraction for casualty accumulation of GIPIS111 module.
** Modifications : v1.1 (08-09-2010) - extract records with 'PFL' subline_cd
**                  
*/

AS
  -- extraction of data will start and end in this procedure. this will function as the
  -- main module for the entire extraction for casualty accumulation.
  PROCEDURE EXTRACT (p_location_cd   gipi_casualty_item.location_cd%TYPE,
                     p_bus_type      NUMBER)
  IS
    TYPE tab_line_cd            IS TABLE OF gixx_ca_accum.line_cd%TYPE;
    TYPE tab_subline_cd         IS TABLE OF gixx_ca_accum.subline_cd%TYPE;
    TYPE tab_iss_cd             IS TABLE OF gixx_ca_accum.iss_cd%TYPE;
    TYPE tab_issue_yy           IS TABLE OF gixx_ca_accum.issue_yy%TYPE;
    TYPE tab_pol_seq_no         IS TABLE OF gixx_ca_accum.pol_seq_no%TYPE;
    TYPE tab_renew_no           IS TABLE OF gixx_ca_accum.renew_no%TYPE;
    TYPE tab_endt_iss_cd        IS TABLE OF gixx_ca_accum.endt_iss_cd%TYPE;
    TYPE tab_endt_yy            IS TABLE OF gixx_ca_accum.endt_yy%TYPE;
    TYPE tab_endt_seq_no        IS TABLE OF gixx_ca_accum.endt_seq_no%TYPE;
    TYPE tab_dist_flag          IS TABLE OF gixx_ca_accum.dist_flag%TYPE;
    TYPE tab_ann_tsi_amt        IS TABLE OF gixx_ca_accum.ann_tsi_amt%TYPE;
    TYPE tab_assd_no            IS TABLE OF gixx_ca_accum.assd_no%TYPE;
    TYPE tab_assd_name          IS TABLE OF gixx_ca_accum.assd_name%TYPE;
    TYPE tab_eff_date           IS TABLE OF VARCHAR2(25);  --gixx_ca_accum.eff_date%type;
    TYPE tab_incept_date        IS TABLE OF VARCHAR2(25);  --gixx_ca_accum.incept_date%type;
    TYPE tab_expiry_date        IS TABLE OF VARCHAR2(25);  --gixx_ca_accum.expiry_date%type;
    TYPE tab_endt_expiry_date   IS TABLE OF VARCHAR2(25);  --gixx_ca_accum.endt_expiry_date%type;
    TYPE tab_location_cd        IS TABLE OF gixx_ca_accum.location_cd%TYPE;
    TYPE tab_peril_cd           IS TABLE OF gixx_ca_accum.peril_cd%TYPE;
    TYPE tab_peril_name         IS TABLE OF gixx_ca_accum.peril_name%TYPE;
    TYPE tab_prem_rt            IS TABLE OF gixx_ca_accum.peril_name%TYPE;
    TYPE tab_item_no            IS TABLE OF gixx_ca_accum.item_no%TYPE;
    TYPE tab_policy_id          IS TABLE OF gipi_polbasic.policy_id%TYPE;
    TYPE tab_dist_no            IS TABLE OF gixx_ca_accum.dist_no%TYPE;
    TYPE tab_share_type         IS TABLE OF gixx_ca_accum_dist.share_type%TYPE;
    TYPE tab_share_cd           IS TABLE OF gixx_ca_accum_dist.share_cd%TYPE;
    TYPE tab_dist_tsi           IS TABLE OF gixx_ca_accum_dist.dist_tsi%TYPE;

    vv_line_cd            tab_line_cd;
    vv_subline_cd         tab_subline_cd;
    vv_iss_cd             tab_iss_cd;
    vv_issue_yy           tab_issue_yy;
    vv_pol_seq_no         tab_pol_seq_no;
    vv_renew_no           tab_renew_no;
    vv_endt_iss_cd        tab_endt_iss_cd;
    vv_endt_yy            tab_endt_yy;
    vv_endt_seq_no        tab_endt_seq_no;
    vv_dist_flag          tab_dist_flag;
    vv_ann_tsi_amt        tab_ann_tsi_amt;
    vv_assd_no            tab_assd_no;
    vv_assd_name          tab_assd_name;
    vv_eff_date           tab_eff_date;
    vv_incept_date        tab_incept_date;
    vv_expiry_date        tab_expiry_date;
    vv_endt_expiry_date   tab_endt_expiry_date;
    vv_location_cd        tab_location_cd;
    vv_peril_cd           tab_peril_cd;
    vv_temp_peril         tab_peril_cd;  --holds inserted perils temporarily
    vv_peril_name         tab_peril_name;
    vv_prem_rt            tab_prem_rt;
    vv_item_no            tab_item_no;
    vv_policy_id          tab_policy_id;
    vv_dist_no            tab_dist_no;
    vv_share_type         tab_share_type;
    vv_share_cd           tab_share_cd;
    vv_dist_tsi           tab_dist_tsi;

    v_dist_flag           giuw_pol_dist.dist_flag%TYPE;
    v_currency_rt         gipi_item.currency_rt%TYPE;
    v_prem_rt             gipi_itmperil.prem_rt%TYPE;
    v_peril_cd            giis_peril.peril_cd%TYPE;
    v_peril_name          giis_peril.peril_name%TYPE;
    v_assd_name           giis_assured.assd_name%TYPE;
    v_pol_flag            gipi_polbasic.pol_flag%TYPE;
    v_assd_no             giis_assured.assd_no%TYPE;
    v_policy_id           gipi_polbasic.policy_id%TYPE := 0;
    v_ann_tsi_amt         gipi_itmperil.ann_tsi_amt%TYPE;
    v_dist_no             giuw_pol_dist.dist_no%TYPE;
    v_item_no             gipi_item.item_no%TYPE;
    v_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
    v_incept_date         VARCHAR2(25);
    v_expiry_date         VARCHAR2(25);
    v_loop                NUMBER := 0;
    v_ri                  VARCHAR2(7);
  BEGIN
    v_ri := Giacp.v('RI_ISS_CD');
    DELETE FROM gixx_ca_accum WHERE location_cd = p_location_cd;
    COMMIT;
    DELETE FROM gixx_ca_accum_dist WHERE location_cd = p_location_cd;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(v_ri);
    DBMS_OUTPUT.PUT_LINE(p_bus_type);
     SELECT DISTINCT y.item_no,      x.line_cd,
           x.subline_cd,             x.iss_cd,                    x.issue_yy,
           x.pol_seq_no,             x.renew_no,
           x.endt_iss_cd,            x.endt_yy,                   x.endt_seq_no
      BULK COLLECT INTO
           vv_item_no,               vv_line_cd,
           vv_subline_cd,            vv_iss_cd,                   vv_issue_yy,
           vv_pol_seq_no,            vv_renew_no,
           vv_endt_iss_cd,           vv_endt_yy,                  vv_endt_seq_no
      FROM gipi_casualty_item  y,
           gipi_polbasic x,
           giis_ca_location  z
     WHERE 1=1
       AND x.pol_flag IN ('1', '2', '3','4','X')
       AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                        x.iss_cd, x.issue_yy,
                                                        x.pol_seq_no, x.renew_no),'Y') = 'Y'
       AND iss_cd             = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
       AND iss_cd            <> DECODE(p_bus_type,1,v_ri,'XX')
       AND y.location_cd     IS NOT NULL
       AND x.policy_id        = y.policy_id
       AND y.location_cd      = z.location_cd
       AND y.location_cd      = p_location_cd
       AND x.subline_cd       = NVL(giisp.v('CA_SUBLINE_PFL'),'PFL')--v1.1 
     ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, item_no;


    IF SQL%FOUND THEN
       vv_location_cd      := tab_location_cd();
       vv_eff_date         := tab_eff_date();
       vv_incept_date      := tab_incept_date();
       vv_expiry_date      := tab_expiry_date();
       vv_endt_expiry_date := tab_endt_expiry_date();
       vv_policy_id        := tab_policy_id();
       vv_temp_peril       := tab_peril_cd();
       vv_location_cd.EXTEND(vv_item_no.COUNT);
       vv_eff_date.EXTEND(vv_item_no.COUNT);
       vv_incept_date.EXTEND(vv_item_no.COUNT);
       vv_expiry_date.EXTEND(vv_item_no.COUNT);
       vv_endt_expiry_date.EXTEND(vv_item_no.COUNT);
       vv_policy_id.EXTEND(vv_item_no.COUNT);
       FOR pol IN vv_item_no.FIRST..vv_item_no.LAST
       LOOP
         Latest_Location(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                         vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                         vv_location_cd(pol));
         v_peril_cd := 0;
         FOR x IN (SELECT e.currency_rt,           f.prem_rt,
                          f.peril_cd,              g.peril_name,
                          c.policy_id,             i.dist_no,           SUM(c.ann_tsi_amt) ann_tsi_amt,
                          b.item_no,               c.endt_seq_no,       c.endt_yy,
                          c.eff_date,              c.endt_expiry_date,
                          c.pol_flag,          c.dist_flag
                     FROM
                          gipi_itmperil f,
                          gipi_parlist h,
                          gipi_item e,
                          gipi_polbasic c,
                          gipi_casualty_item b,
                          giis_peril g,
                          giuw_pol_dist i
                    WHERE 1=1
                      AND c.par_id      = h.par_id
                      AND c.pol_flag   IN  ('1', '2','3','4','X')
                      AND e.policy_id   = c.policy_id
                      AND b.policy_id   = e.policy_id
                      AND b.item_no     = e.item_no
                      AND f.policy_id   = e.policy_id
                      AND c.policy_id   = i.policy_id
                      AND b.policy_id   = i.policy_id
                      AND h.par_id      = i.par_id
                      AND c.par_id      = i.par_id
                      AND c.dist_flag   = i.dist_flag
                      AND f.item_no     = e.item_no
                      AND f.line_cd     = g.line_cd
                      AND f.peril_cd    = g.peril_cd
                      AND e.item_no     = vv_item_no(pol)
                      AND g.line_cd     = vv_line_cd(pol)
                      AND c.line_cd     = vv_line_cd(pol)
                      AND c.subline_cd  = vv_subline_cd(pol)
                      AND c.iss_cd      = vv_iss_cd(pol)
                      AND c.issue_yy    = vv_issue_yy(pol)
                      AND c.pol_seq_no  = vv_pol_seq_no(pol)
                      AND c.renew_no    = vv_renew_no(pol)
                      AND c.endt_iss_cd = vv_endt_iss_cd(pol)
                      AND c.endt_yy     = vv_endt_yy(pol)
                      AND c.endt_seq_no = vv_endt_seq_no(pol)
                      AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_casualty_item y,
                                         gipi_polbasic x
                                   WHERE 1=1
                                     AND NVL(x.back_stat,5) = 2
                                     AND x.pol_flag IN ('1','2','3','4','X')
                                     AND x.policy_id   = c.policy_id
                                     AND x.endt_seq_no > c.endt_seq_no
                                     AND y.location_cd IS NOT NULL
                                     AND x.policy_id   = y.policy_id
                                     AND y.item_no     = vv_item_no(pol)
                                     AND x.line_cd     = vv_line_cd(pol)
                                     AND x.subline_cd  = vv_subline_cd(pol)
                                     AND x.iss_cd      = vv_iss_cd(pol)
                                     AND x.issue_yy    = vv_issue_yy(pol)
                                     AND x.pol_seq_no  = vv_pol_seq_no(pol)
                                     AND x.renew_no    = vv_renew_no(pol)
                                     AND x.endt_iss_cd = vv_endt_iss_cd(pol)
                                     AND x.endt_yy     = vv_endt_yy(pol)
                                     AND x.endt_seq_no = vv_endt_seq_no(pol)
                                     )
                    GROUP BY e.currency_rt,           f.prem_rt,
                             f.peril_cd,              g.peril_name,
                             c.policy_id,             i.dist_no,           
                             b.item_no,               c.endt_seq_no,       c.endt_yy,
                             c.eff_date,              c.expiry_date,       c.endt_expiry_date,
                             c.incept_date,           c.pol_flag,          c.dist_flag
                    ORDER BY c.eff_date DESC)
         LOOP
    
           v_currency_rt      := x.currency_rt;
           v_prem_rt          := x.prem_rt;
           v_peril_cd         := x.peril_cd;
           v_peril_name       := x.peril_name;
           v_policy_id        := x.policy_id;
           v_dist_no          := x.dist_no;
           v_ann_tsi_amt      := x.ann_tsi_amt;
           v_item_no          := x.item_no;
           v_endt_seq_no      := x.endt_seq_no;
           v_pol_flag         := x.pol_flag;
           v_dist_flag        := x.dist_flag;
           
           --gets effectivity date of the POLICY where status is cancelled
           IF x.pol_flag = '4' AND 
              Get_Cancel_Effectivity(vv_line_cd(pol), vv_subline_cd(pol), vv_iss_cd(pol),
                                     vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol)) = 'Y' /*>= SYSDATE*/ THEN
              --get effectivity date of the policy instead
              --of the effectivity of the cancellation endorsement
              FOR dt IN (SELECT eff_date
                           FROM gipi_polbasic
                          WHERE line_cd    = vv_line_cd(pol)
                            AND subline_cd = vv_subline_cd(pol)
                            AND iss_cd     = vv_iss_cd(pol)
                            AND issue_yy   = vv_issue_yy(pol)
                            AND pol_seq_no = vv_pol_seq_no(pol)
                            AND renew_no   = vv_renew_no(pol)
                            AND endt_seq_no= 0)
              LOOP
                vv_eff_date(pol) := TO_CHAR(dt.eff_date,'MM/DD/YYYY HH:MI:SS AM');
                EXIT;
              END LOOP;
           ELSIF x.pol_flag IN ('1','2','3','X') THEN
              vv_eff_date(pol)         := TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM');
           END IF;

           vv_endt_expiry_date(pol) := TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM');
           vv_policy_id(pol)        := x.policy_id;

           vv_temp_peril.EXTEND(1);
           vv_temp_peril(vv_temp_peril.COUNT) := v_peril_cd;

           --gets the latest assured of the policy
           Latest_Assured(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                          vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                          v_assd_no, v_assd_name);
           Latest_Duration(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                           vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                           v_incept_date,    v_expiry_date);
           /*Get_Ann_Tsi(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                       vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                       v_ann_tsi_amt);*/
           Latest_Prem_Rt(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                          vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                          vv_item_no(pol),  v_peril_cd,         v_prem_rt);

           INSERT INTO gixx_ca_accum
             (line_cd,                  subline_cd,                  iss_cd,
              issue_yy,                 pol_seq_no,                  renew_no,
              endt_iss_cd,              endt_yy,                     endt_seq_no,
              dist_flag,                ann_tsi_amt,
              assd_no,                  assd_name,
              eff_date,
              incept_date,
              expiry_date,
              endt_expiry_date,
              location_cd,
              peril_cd,                 peril_name,                  prem_rt,
              item_no,                  policy_id,                   dist_no)
           VALUES
             (vv_line_cd(pol),          vv_subline_cd(pol),          vv_iss_cd(pol),
              vv_issue_yy(pol),         vv_pol_seq_no(pol),          vv_renew_no(pol),
              vv_endt_iss_cd(pol),      vv_endt_yy(pol),             v_endt_seq_no,
              v_dist_flag,              v_ann_tsi_amt,
              v_assd_no,                v_assd_name,
              TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              v_incept_date,
              v_expiry_date,
              TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              vv_location_cd(pol),
              v_peril_cd,               v_peril_name,                v_prem_rt,
              vv_item_no(pol),          vv_policy_id(pol),           v_dist_no);
         END LOOP;
       END LOOP;
   
       -- after populating gixx_ca_accum table, the same table will now be used
       -- to populate the gixx_ca_accum_dist.

       -- initialize collection
       vv_line_cd.DELETE;          vv_subline_cd.DELETE;        vv_iss_cd.DELETE;
       vv_issue_yy.DELETE;         vv_pol_seq_no.DELETE;        vv_renew_no.DELETE;
       vv_endt_iss_cd.DELETE;      vv_endt_yy.DELETE;           vv_endt_seq_no.DELETE;
       vv_eff_date.DELETE;         vv_incept_date.DELETE;       vv_expiry_date.DELETE;
       vv_endt_expiry_date.DELETE; vv_location_cd.DELETE;
       vv_item_no.DELETE;          vv_policy_id.DELETE;

       SELECT a.line_cd,           a.subline_cd,                a.iss_cd,
              a.issue_yy,          a.pol_seq_no,                a.renew_no,
              a.endt_iss_cd,       a.endt_yy,                   a.endt_seq_no,
              a.dist_flag,         f.ann_tsi_amt,
              a.assd_no,           a.assd_name,
              TO_CHAR(a.eff_date,'MM/DD/YYYY HH:MI:SS AM'),
              TO_CHAR(a.incept_date,'MM/DD/YYYY HH:MI:SS AM'),
              TO_CHAR(a.expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
              TO_CHAR(a.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
              a.location_cd,
              a.peril_cd,          a.peril_name,                a.prem_rt,
              a.item_no,           a.policy_id,                 a.dist_no,
              b.share_cd,          c.share_type,                b.dist_tsi
         BULK COLLECT INTO
              vv_line_cd,          vv_subline_cd,               vv_iss_cd,
              vv_issue_yy,         vv_pol_seq_no,               vv_renew_no,
              vv_endt_iss_cd,      vv_endt_yy,                  vv_endt_seq_no,
              vv_dist_flag,        vv_ann_tsi_amt,
              vv_assd_no,          vv_assd_name,
              vv_eff_date,
              vv_incept_date,
              vv_expiry_date,
              vv_endt_expiry_date,
              vv_location_cd,
              vv_peril_cd,         vv_peril_name,               vv_prem_rt,
              vv_item_no,          vv_policy_id,                vv_dist_no,
              vv_share_cd,         vv_share_type,               vv_dist_tsi
         FROM gipi_itmperil                   f,
              giuw_itemperilds_dtl            b,
              giuw_pol_dist                   e,
              gixx_ca_accum                   a,
              giis_dist_share                 c
        WHERE 1=1
          AND a.policy_id        = e.policy_id
          AND e.dist_flag       IN ('1','2','3')
          AND b.dist_no          = e.dist_no
          AND b.dist_seq_no     >= 0
          AND b.item_no          = a.item_no
          AND b.peril_cd         = a.peril_cd
          AND b.line_cd          = a.line_cd
          AND a.line_cd          = c.line_cd
          AND b.share_cd         = c.share_cd
          AND a.line_cd          = f.line_cd
          AND a.policy_id        = f.policy_id
          AND a.peril_cd         = f.peril_cd
          AND a.item_no          = f.item_no
          AND a.location_cd      = p_location_cd;
          
       IF SQL%FOUND THEN
          FORALL pol IN vv_line_cd.FIRST..vv_line_cd.LAST
            INSERT INTO gixx_ca_accum_dist
                   (line_cd,                  subline_cd,                  iss_cd,
                    issue_yy,                 pol_seq_no,                  renew_no,
                    endt_iss_cd,              endt_yy,                     endt_seq_no,
                    dist_flag,                ann_tsi_amt,
                    assd_no,                  assd_name,
                    eff_date,
                    incept_date,
                    expiry_date,
                    endt_expiry_date,
                    location_cd,
                    peril_cd,                 peril_name,                  prem_rt,
                    item_no,                  policy_id,                   dist_no,
                    share_type,               share_cd,                    dist_tsi)
            VALUES
                   (vv_line_cd(pol),          vv_subline_cd(pol),          vv_iss_cd(pol),
                    vv_issue_yy(pol),         vv_pol_seq_no(pol),          vv_renew_no(pol),
                    vv_endt_iss_cd(pol),      vv_endt_yy(pol),             vv_endt_seq_no(pol),
                    vv_dist_flag(pol),        vv_ann_tsi_amt(pol),
                    vv_assd_no(pol),          vv_assd_name(pol),
                    TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    vv_location_cd(pol),
                    vv_peril_cd(pol),         vv_peril_name(pol),          vv_prem_rt(pol),
                    vv_item_no(pol),          vv_policy_id(pol),           vv_dist_no(pol),
                    vv_share_type(pol),       vv_share_cd(pol),            vv_dist_tsi(pol));
       END IF;
       COMMIT;
    END IF;
  END EXTRACT;

  FUNCTION Get_Cancel_Effectivity (p_line_cd     gipi_polbasic.line_cd%TYPE,
                                   p_subline_cd  gipi_polbasic.subline_cd%TYPE,
                                   p_iss_cd      gipi_polbasic.iss_cd%TYPE,
                                   p_issue_yy    gipi_polbasic.issue_yy%TYPE,
                                   p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
                                   p_renew_no    gipi_polbasic.renew_no%TYPE)
  RETURN VARCHAR2 AS
    v_eff_date    DATE;
  BEGIN
    FOR pol IN (
      SELECT eff_date
        FROM gipi_polbasic
           WHERE line_cd    = p_line_cd
             AND subline_cd = p_subline_cd
             AND iss_cd     = p_iss_cd
             AND issue_yy   = p_issue_yy
             AND pol_seq_no = p_pol_seq_no
             AND renew_no   = p_renew_no
             AND pol_flag   = '4'
           ORDER BY endt_seq_no DESC)
    LOOP
       v_eff_date := pol.eff_date;
       EXIT;
    END LOOP;
    IF v_eff_date >= SYSDATE THEN
       RETURN ('Y');
    ELSE
       RETURN ('N');
    END IF;
  END;

  PROCEDURE Latest_Location (p_line_cd         IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd      IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd          IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy        IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no      IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no        IN gipi_polbasic.renew_no%TYPE,
                             p_location_cd    OUT gipi_casualty_item.location_cd%TYPE) IS
  BEGIN
    FOR loc  IN (SELECT z.location_cd, z.location_desc
                   FROM
                        gipi_casualty_item  y,
                        gipi_polbasic x,
                        giis_ca_location  z
                  WHERE 1=1
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'
                    AND y.location_cd IS NOT NULL
                    AND NOT EXISTS(SELECT 'X'
                                     FROM
                                          gipi_casualty_item  n,
                                          gipi_polbasic m,
                                          giis_ca_location  o
                                    WHERE 1 = 1
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(
                                                                  m.line_cd, m.subline_cd,
                                                                  m.iss_cd, m.issue_yy,
                                                                  m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND n.location_cd IS NOT NULL
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id = n.policy_id
                                      AND n.location_cd = o.location_cd
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND x.policy_id = y.policy_id
                    AND y.location_cd = z.location_cd
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_location_cd   := loc.location_cd;
      EXIT;
    END LOOP;
  END Latest_Location;

  PROCEDURE Latest_Assured (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                            p_assd_no     OUT giis_assured.assd_no%TYPE,
                            p_assd_name   OUT giis_assured.assd_name%TYPE) IS
  BEGIN
    FOR asd  IN (SELECT z.assd_no assd_no, z.assd_name assd_name
                   FROM
                        gipi_parlist  y,
                        gipi_polbasic x,
                        giis_assured  z
                  WHERE 1=1
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                               x.iss_cd, x.issue_yy,
                               x.pol_seq_no, x.renew_no),'Y') = 'Y'
                    AND NOT EXISTS(SELECT 'X'
                                     FROM
                                          gipi_parlist  n,
                                          gipi_polbasic m,
                                          giis_assured  o
                                    WHERE 1 = 1
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                 m.iss_cd, m.issue_yy,
                                                 m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.par_id     = n.par_id
                                      AND n.assd_no    = o.assd_no
                                      AND n.assd_no IS NOT NULL
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND x.par_id     = y.par_id
                    AND y.assd_no    = z.assd_no
                    AND y.assd_no IS NOT NULL
                    AND x.par_id     = y.par_id
                    AND y.assd_no    = z.assd_no
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_assd_no   := asd.assd_no;
      p_assd_name := asd.assd_name;
      EXIT;
    END LOOP;
  END Latest_Assured;

  PROCEDURE Latest_Duration (p_line_cd       IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd    IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no      IN gipi_polbasic.renew_no%TYPE,
                             p_incept_date  OUT gipi_polbasic.incept_date%TYPE,
                             p_expiry_date  OUT gipi_polbasic.expiry_date%TYPE) IS
  BEGIN
    FOR ied  IN (SELECT incept_date, expiry_date
                   FROM gipi_polbasic
                  WHERE 1=1
                    AND pol_flag IN ('1', '2', '3','4','X')
                    AND DECODE(pol_flag,'4',Get_Cancel_Effectivity(line_cd, subline_cd,
                               iss_cd, issue_yy,
                               pol_seq_no, renew_no),'Y') = 'Y'
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic
                                    WHERE 1 = 1
                                      AND pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(pol_flag,'4',Get_Cancel_Effectivity(line_cd, subline_cd,
                                                 iss_cd, issue_yy,
                                                 pol_seq_no, renew_no),'Y') = 'Y'
                                      AND endt_seq_no > endt_seq_no
                                      AND NVL(back_stat,5) = 2
                                      AND line_cd    = p_line_cd
                                      AND subline_cd = p_subline_cd
                                      AND iss_cd     = p_iss_cd
                                      AND issue_yy   = p_issue_yy
                                      AND pol_seq_no = p_pol_seq_no
                                      AND renew_no   = p_renew_no)
                    AND line_cd    = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd     = p_iss_cd
                    AND issue_yy   = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no   = p_renew_no
               ORDER BY eff_date DESC)
    LOOP
      p_incept_date := ied.incept_date;
      p_expiry_date := ied.expiry_date;
      EXIT;
    END LOOP;
  END Latest_Duration;

  PROCEDURE Get_Ann_Tsi (p_line_cd       IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
                         p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no      IN gipi_polbasic.renew_no%TYPE,
                         v_ann_tsi_amt  OUT gipi_polbasic.ann_tsi_amt%TYPE) IS
  BEGIN
    v_ann_tsi_amt := 0;
    SELECT SUM((NVL(c.tsi_amt,0) * NVL(b.currency_rt,0))) ann_tsi
      INTO v_ann_tsi_amt
      FROM gipi_itmperil c,
           gipi_item     b,
           gipi_polbasic a
     WHERE 1=1
       AND a.line_cd      = p_line_cd
       AND a.subline_cd   = p_subline_cd
       AND a.iss_cd       = p_iss_cd
       AND a.issue_yy     = p_issue_yy
       AND a.pol_seq_no   = p_pol_seq_no
       AND a.renew_no     = p_renew_no
       AND a.pol_flag IN ('1','2','3','4','X')
       AND DECODE(a.pol_flag,'4',Get_Cancel_Effectivity(
                                   a.line_cd, a.subline_cd,
                                   a.iss_cd, a.issue_yy,
                                   a.pol_seq_no, a.renew_no),'Y') = 'Y'
       AND a.policy_id    = b.policy_id
       AND b.policy_id    = c.policy_id
       AND c.line_cd      = a.line_cd;
  END Get_Ann_Tsi;

  PROCEDURE Latest_Prem_Rt (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                            p_item_no      IN gipi_itmperil.item_no%TYPE,
                            p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
                            p_prem_rt     OUT gipi_itmperil.prem_rt%TYPE) IS
  BEGIN
    FOR prem IN  (SELECT y.prem_rt prem_rt
                    FROM gipi_polbasic x,
                         gipi_itmperil y
                   WHERE x.line_cd    = p_line_cd
                     AND x.subline_cd = p_subline_cd
                     AND x.iss_cd     = p_iss_cd
                     AND x.issue_yy   = p_issue_yy
                     AND x.pol_seq_no = p_pol_seq_no
                     AND x.renew_no   = p_renew_no
                     AND x.pol_flag IN ('1','2','3','4','X')
                     AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(
                                                  x.line_cd, x.subline_cd,
                                                  x.iss_cd, x.issue_yy,
                                                  x.pol_seq_no, x.renew_no),'Y') = 'Y'
                     AND x.policy_id  = y.policy_id
                     AND y.item_no    = p_item_no
                     AND y.peril_cd   = p_peril_cd
                     AND y.prem_rt IS NOT NULL
                   ORDER BY x.endt_seq_no DESC)
    LOOP
      p_prem_rt := prem.prem_rt;
      EXIT;
    END LOOP;
  END Latest_Prem_Rt;

END Casualty_Accum;
/



CREATE OR REPLACE PACKAGE BODY CPI.Block_Accum
/* author     : boyet
** desciption : this package will hold all the procedures and functions that will
**              handle the extraction for block accumulation of gipis110 module.
*/
/* modified by : iris bordey  (01.31.2003)
** description : if policy is redistributed, two records are inserted in gixx_block_accumulation
                 for the earned and un-earned distribution.  this package is modified to specify
                 the distribution number (whether the un-earned or earned distribution)
*/
/*Modified by : iris bordey (06.04.2003)
**description : extraction was modified to allow extraction on cancelled policies given
              : that the effectivity of the cancellation endorsement is earlier than SYSDATE
*/
/*Modified
 by : rollie 21july2004     @    FGIC
**description : optimized query by arranging tables and WHERE clause positions
              : tables with most number of records must be the closest to FROM clause.
*/
/*Modified by : rollie 29july2004
**description : added new parameter for business type
              : business type = 1 THEN all iss code but not RI
                                     2 THEN RI only
                                3 combination
*/
/*Modified by : jen 21june2005
**description : extraction was modified to allow extraction of expired policies.
*/

/*Modified by : grace 21june2006
**description : extraction was modified to allow extraction of not yet effective policies.
*/

AS
  -- extraction of data will start and end in this procedure. this will function as the
  -- main module for the entire extraction for block accumulation.
  PROCEDURE EXTRACT (p_province_cd   GIIS_BLOCK.province_cd%TYPE,
                     p_city_cd       GIIS_BLOCK.city_cd%TYPE,
                     p_district_no   GIIS_BLOCK.district_no%TYPE,
                     p_block_no      GIIS_BLOCK.block_no%TYPE,
                     p_bus_type         NUMBER)
  IS
    TYPE tab_line_cd            IS TABLE OF GIXX_BLOCK_ACCUMULATION.line_cd%TYPE;
    TYPE tab_subline_cd         IS TABLE OF GIXX_BLOCK_ACCUMULATION.subline_cd%TYPE;
    TYPE tab_iss_cd             IS TABLE OF GIXX_BLOCK_ACCUMULATION.iss_cd%TYPE;
    TYPE tab_issue_yy           IS TABLE OF GIXX_BLOCK_ACCUMULATION.issue_yy%TYPE;
    TYPE tab_pol_seq_no         IS TABLE OF GIXX_BLOCK_ACCUMULATION.pol_seq_no%TYPE;
    TYPE tab_renew_no           IS TABLE OF GIXX_BLOCK_ACCUMULATION.renew_no%TYPE;
    TYPE tab_dist_flag          IS TABLE OF GIXX_BLOCK_ACCUMULATION.dist_flag%TYPE;
    TYPE tab_ann_tsi_amt        IS TABLE OF GIXX_BLOCK_ACCUMULATION.ann_tsi_amt%TYPE;
    TYPE tab_assd_no            IS TABLE OF GIXX_BLOCK_ACCUMULATION.assd_no%TYPE;
    TYPE tab_assd_name          IS TABLE OF GIXX_BLOCK_ACCUMULATION.assd_name%TYPE;
    TYPE tab_eff_date           IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.eff_date%type;
    TYPE tab_incept_date        IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.incept_date%type;
    TYPE tab_expiry_date        IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.expiry_date%type;
    TYPE tab_endt_expiry_date   IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.endt_expiry_date%type;
    TYPE tab_tarf_cd            IS TABLE OF GIXX_BLOCK_ACCUMULATION.tarf_cd%TYPE;
    TYPE tab_construction_cd    IS TABLE OF GIXX_BLOCK_ACCUMULATION.construction_cd%TYPE;
    TYPE tab_loc_risk           IS TABLE OF GIXX_BLOCK_ACCUMULATION.loc_risk%TYPE;
    TYPE tab_peril_cd           IS TABLE OF GIXX_BLOCK_ACCUMULATION.peril_cd%TYPE;
    TYPE tab_prem_rt            IS TABLE OF GIXX_BLOCK_ACCUMULATION.prem_rt%TYPE;
    TYPE tab_peril_sname        IS TABLE OF GIXX_BLOCK_ACCUMULATION.peril_sname%TYPE;
    TYPE tab_peril_name         IS TABLE OF GIXX_BLOCK_ACCUMULATION.peril_name%TYPE;
    TYPE tab_item_no            IS TABLE OF GIXX_BLOCK_ACCUMULATION.item_no%TYPE;
    TYPE tab_district_no        IS TABLE OF GIXX_BLOCK_ACCUMULATION.district_no%TYPE;
    TYPE tab_block_no           IS TABLE OF GIXX_BLOCK_ACCUMULATION.block_no%TYPE;
    TYPE tab_province_cd        IS TABLE OF GIXX_BLOCK_ACCUMULATION.province_cd%TYPE;
    TYPE tab_city               IS TABLE OF GIXX_BLOCK_ACCUMULATION.city%TYPE;
    TYPE tab_block_id            IS TABLE OF GIXX_BLOCK_ACCUMULATION.block_id%TYPE;
    TYPE tab_fr_item_type       IS TABLE OF GIXX_BLOCK_ACCUMULATION.fr_item_type%TYPE;
    TYPE tab_policy_id          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE tab_currency_rt        IS TABLE OF GIPI_ITEM.currency_rt%TYPE;
    TYPE tab_dist_no            IS TABLE OF GIUW_POL_DIST.dist_no%TYPE;
    TYPE tab_share_type         IS TABLE OF GIIS_DIST_SHARE.share_type%TYPE;
    TYPE tab_share_cd           IS TABLE OF GIIS_DIST_SHARE.share_cd%TYPE;
    TYPE tab_dist_tsi           IS TABLE OF GIXX_BLOCK_ACCUMULATION_DIST.dist_tsi%TYPE;
    TYPE tab_endt_seq_no        IS TABLE OF GIXX_BLOCK_ACCUMULATION.endt_seq_no%TYPE;
    TYPE tab_risk_cd            IS TABLE OF GIXX_BLOCK_ACCUMULATION.risk_cd%TYPE;

    vv_line_cd            tab_line_cd;
    vv_subline_cd         tab_subline_cd;
    vv_iss_cd             tab_iss_cd;
    vv_issue_yy           tab_issue_yy;
    vv_pol_seq_no         tab_pol_seq_no;
    vv_renew_no           tab_renew_no;
    vv_dist_flag          tab_dist_flag;
    vv_ann_tsi_amt        tab_ann_tsi_amt;
    vv_assd_no            tab_assd_no;
    vv_assd_name          tab_assd_name;
    vv_eff_date           tab_eff_date;
    vv_incept_date        tab_incept_date;
    vv_expiry_date        tab_expiry_date;
    vv_endt_expiry_date   tab_endt_expiry_date;
    vv_tarf_cd            tab_tarf_cd;
    vv_construction_cd    tab_construction_cd;
    vv_loc_risk           tab_loc_risk;
    vv_peril_cd           tab_peril_cd;
    vv_temp_peril         tab_peril_cd;  --holds inserted perils temporarily
    vv_prem_rt            tab_prem_rt;
    vv_peril_sname        tab_peril_sname;
    vv_peril_name         tab_peril_name;
    vv_item_no            tab_item_no;
    vv_district_no        tab_district_no;
    vv_block_no           tab_block_no;
    vv_province_cd        tab_province_cd;
    vv_city               tab_city;
    vv_block_id              tab_block_id;
    vv_fr_item_type       tab_fr_item_type;
    vv_policy_id          tab_policy_id;
    vv_currency_rt        tab_currency_rt;
    vv_dist_no            tab_dist_no;
    vv_share_type         tab_share_type;
    vv_share_cd           tab_share_cd;
    vv_dist_tsi           tab_dist_tsi;
    vv_endt_seq_no        tab_endt_seq_no;
    vv_risk_cd            tab_risk_cd;
    v_dist_flag           GIUW_POL_DIST.dist_flag%TYPE; --varchar2;
    v_currency_rt         GIPI_ITEM.currency_rt%TYPE;
    v_prem_rt             GIPI_ITMPERIL.prem_rt%TYPE;
    v_peril_cd            GIIS_PERIL.peril_cd%TYPE;
    v_peril_name          GIIS_PERIL.peril_name%TYPE;
    v_peril_sname         GIIS_PERIL.peril_sname%TYPE;
    v_assd_name           GIIS_ASSURED.assd_name%TYPE;
    v_assd_no             GIIS_ASSURED.assd_no%TYPE;
    v_policy_id           GIPI_POLBASIC.policy_id%TYPE := 0;
    v_ann_tsi_amt         GIPI_ITMPERIL.ann_tsi_amt%TYPE;
    v_dist_no             GIUW_POL_DIST.dist_no%TYPE;
    v_item_no             GIPI_ITEM.item_no%TYPE;
    v_endt_seq_no         GIPI_POLBASIC.endt_seq_no%TYPE;
    v_loop                NUMBER := 0;
    --by iris bordey var created on 03.28.2003
    v_new_rec             VARCHAR2(1) := 'Y';  --identifies if processing a new rec.
    v_insert_sw           VARCHAR2(1) := 'Y';  --identifies if rec. should be inserted on gixx_block_accumulation
    --v_distno              giuw_pol_dist.dist_no%TYPE := 0; --(iob (01.31.2003)- to handle specified dist. number)
    v_ri                  VARCHAR2(7);
    --==added by VJ 091707==--
    v_incept              GIPI_POLBASIC.incept_date%TYPE;
    v_expiry              GIPI_POLBASIC.expiry_date%TYPE;
    --===========V=========--
  BEGIN
    v_ri := Giacp.v('RI_ISS_CD');
    DELETE FROM GIXX_BLOCK_ACCUMULATION;
    COMMIT;
    DELETE FROM GIXX_BLOCK_ACCUMULATION_DIST;
    COMMIT;
     DBMS_OUTPUT.PUT_LINE(v_ri);
    DBMS_OUTPUT.PUT_LINE(p_bus_type);
/*    SELECT DISTINCT a.item_no,       x.line_cd,
           x.subline_cd,             x.iss_cd,                    x.issue_yy,
           x.pol_seq_no,             x.renew_no
         BULK COLLECT INTO
           vv_item_no,               vv_line_cd,
           vv_subline_cd,            vv_iss_cd,                  vv_issue_yy,
           vv_pol_seq_no,            vv_renew_no
      FROM gipi_fireitem a,
           giis_block b,
           gipi_polbasic x
     WHERE a.block_id    = b.block_id
       AND x.policy_id   = a.policy_id
       --AND x.pol_flag IN ('1', '2', '3','X')
       AND b.district_no = p_district_no
       AND b.block_no    = p_block_no
       AND b.province_cd = p_province_cd
       AND b.city_cd     = p_city_cd
       AND (x.pol_flag IN ('1', '2', '3','X')
            OR(x.pol_flag = '4' AND
               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                      x.iss_cd, x.issue_yy,
                                      x.pol_seq_no, x.renew_no) >= SYSDATE))
     ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, item_no;*/
     SELECT DISTINCT A.item_no,       x.line_cd,
           x.subline_cd,             x.iss_cd,                    x.issue_yy,
           x.pol_seq_no,             x.renew_no
         BULK COLLECT INTO
           vv_item_no,               vv_line_cd,
           vv_subline_cd,            vv_iss_cd,                  vv_issue_yy,
           vv_pol_seq_no,            vv_renew_no
      FROM GIPI_FIREITEM A,
           GIPI_POLBASIC x,
           GIIS_BLOCK b
     WHERE 1 = 1
       AND x.pol_flag IN ('1', '2', '3','4','X')
       /*
       ** nieko 01032017
       **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                            x.iss_cd, x.issue_yy,
                                                      x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
       AND A.block_id    = b.block_id
       AND x.policy_id   = A.policy_id
       AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
       AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
       AND b.district_no = p_district_no--'MANDAL'-- p_district_no
       AND b.block_no    = p_block_no--'000501'--p_block_no
       AND b.city_cd     = p_city_cd--997401 --p_city_cd
       AND b.province_cd = p_province_cd--9974--p_province_cd
     ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, item_no;
    --dbms_output.put_line('3');
    --iris bordey 07.23.2002
    --calls the procedure "latest_assured" then omits selection of assd_no and assd_name in the select
    --statement of the for loop..
    IF SQL%FOUND THEN
       --iris bordey 03.25.2003
       --initialize collection
       vv_district_no := tab_district_no();
        vv_block_no    := tab_block_no();
       vv_province_cd := tab_province_cd();
       vv_city        := tab_city();
       vv_block_id    := tab_block_id();
       vv_tarf_cd     := tab_tarf_cd();
         vv_construction_cd := tab_construction_cd();
       vv_loc_risk    := tab_loc_risk();
       vv_fr_item_type := tab_fr_item_type();
       vv_eff_date    := tab_eff_date();
       vv_incept_date := tab_incept_date();
       vv_expiry_date := tab_expiry_date();
       vv_endt_expiry_date := tab_endt_expiry_date();
       vv_endt_seq_no  := tab_endt_seq_no();
       vv_risk_cd  := tab_risk_cd();
       vv_policy_id    := tab_policy_id();
       vv_temp_peril   := tab_peril_cd();
       --dbms_output.put_line('2');
       vv_district_no.EXTEND(vv_item_no.COUNT);
       vv_block_no.EXTEND(vv_item_no.COUNT);
       vv_province_cd.EXTEND(vv_item_no.COUNT);
       vv_city.EXTEND(vv_item_no.COUNT);
       vv_block_id.EXTEND(vv_item_no.COUNT);
       vv_tarf_cd.EXTEND(vv_item_no.COUNT);
       vv_construction_cd.EXTEND(vv_item_no.COUNT);
       vv_loc_risk.EXTEND(vv_item_no.COUNT);
       vv_fr_item_type.EXTEND(vv_item_no.COUNT);
       vv_eff_date.EXTEND(vv_item_no.COUNT);
       vv_incept_date.EXTEND(vv_item_no.COUNT);
       vv_expiry_date.EXTEND(vv_item_no.COUNT);
       vv_endt_expiry_date.EXTEND(vv_item_no.COUNT);
       vv_endt_seq_no.EXTEND(vv_item_no.COUNT);
       vv_RISK_CD.EXTEND(vv_ITEM_NO.COUNT);
       vv_policy_id.EXTEND(vv_item_no.COUNT);
       FOR pol IN vv_item_no.FIRST..vv_item_no.LAST
       LOOP
         
         Latest_Tarf_Cd(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                        vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                        vv_item_no(pol),      vv_tarf_cd(pol));
         Latest_Block(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                      vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                      vv_item_no(pol),      vv_block_no(pol),     vv_district_no(pol),
                      vv_province_cd(pol),  vv_city(pol),         vv_block_id(pol),
                      vv_RISK_Cd(pol));
         Latest_Construct_Cd(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                             vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                             vv_item_no(pol),      vv_construction_cd(pol));
         Latest_Loc_Risk(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                         vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                         vv_item_no(pol),      vv_loc_risk(pol));
         Latest_Fr_Item_Type(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                             vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                                 vv_item_no(pol),  vv_fr_item_type(pol));
         --dbms_output.put_line(to_char(pol)||'-1');
         --iris 07.23.2002 omits selection of assd_no and assd_name from giis_assured
         v_peril_cd := 0;
         /*iris bordey (03.28.2003)
         **Commented script the fetch the dist_no of the policy since dist_no is not
         **neccessary on gixx_block_accumulation*/
         /*iris bordey (01.31.2003)
         **fetch the distribution number to be utilized on the for-loop query
         **the date of the distribution should be validated against the sysdate (such that
         **sysdate is between effectivity date and expiry date).  if in any case that
         **both distrbutions are expired then get the latest distribution
         */
         /*v_distno := 0;
         FOR dist IN (SELECT b.dist_no dist_no, b.eff_date, b.expiry_date
                        FROM gipi_polbasic a,
                             giuw_pol_dist b,
                             gipi_item     c
                       WHERE 1=1
                         AND a.policy_id = b.policy_id
                         AND a.policy_id   = c.policy_id
                         AND c.item_no   = vv_item_no(pol)
                         --filter giuw_pol_dist
                         AND b.dist_flag IN ('1', '2', '3')
                         AND SYSDATE BETWEEN b.eff_date AND b.expiry_date
                         --filter polbasic
                         AND a.line_cd     = vv_line_cd(pol)
                         AND a.subline_cd  = vv_subline_cd(pol)
                         AND a.iss_cd      = vv_iss_cd(pol)
                         AND a.issue_yy    = vv_issue_yy(pol)
                         AND a.pol_seq_no  = vv_pol_seq_no(pol)
                         AND a.renew_no    = vv_renew_no(pol))
         LOOP
           v_distno := dist.dist_no;
           EXIT;
         END LOOP;
         --iob get the latest distribution if ever no distribution were fetched
         --on the first query
         IF v_distno = 0 THEN
            FOR dist IN (SELECT MAX(b.dist_no) dist_no
                           FROM gipi_polbasic a,
                                giuw_pol_dist b,
                                giuw_itemds   c
                          WHERE 1=1
                            AND a.policy_id = b.policy_id
                            AND b.dist_no   = c.dist_no
                            AND c.item_no   = vv_item_no(pol)
                            --filter giuw_pol_dist
                            AND b.dist_flag IN ('1', '2', '3')
                            --filter polbasic
                            AND a.line_cd     = vv_line_cd(pol)
                            AND a.subline_cd  = vv_subline_cd(pol)
                            AND a.iss_cd      = vv_iss_cd(pol)
                            AND a.issue_yy    = vv_issue_yy(pol)
                            AND a.pol_seq_no  = vv_pol_seq_no(pol)
                            AND a.renew_no    = vv_renew_no(pol))
            LOOP
              v_distno := dist.dist_no;
               EXIT;
            END LOOP;
         END IF;*/
         --by iris bordey
         --modified by VJ 091707--
         v_new_rec := 'Y';
         FOR x IN (SELECT e.currency_rt,           f.prem_rt,
                          f.peril_cd,          g.peril_name,            g.peril_sname,
                             c.policy_id,
                          0 ann_tsi_amt,       b.item_no, c.endt_seq_no,
                          c.eff_date,          /*c.expiry_date,      */     c.endt_expiry_date,
                          /*c.incept_date, */      c.pol_flag,--d.dist_no,
                          c.dist_flag
                     FROM     --95k
                          GIPI_ITMPERIL  f,    --277k
                          GIPI_PARLIST   h,    -- 95k
                          GIPI_ITEM      e,    -- 92k   --giuw_pol_dist  d,
                          GIPI_POLBASIC  c,    -- 84k
                          GIPI_FIREITEM  b,    -- 29k
                           GIIS_PERIL     g
                    WHERE 1=1
                      AND c.par_id      = h.par_id
                      --and d.par_id    = h.par_id
                      --commented by iris bordey 03.28.2003
                      --AND d.policy_id   = c.policy_id
                      --AND d.dist_no     = v_distno
                      --AND d.dist_flag   IN ('1','2','3')
                      AND c.pol_flag   IN  ('1', '2','3','4','X')
                      AND e.policy_id   = c.policy_id
                      AND b.policy_id   = e.policy_id
                      AND b.item_no     = e.item_no
                      AND f.policy_id   = e.policy_id
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
                      AND NOT EXISTS(SELECT 'X'
                                    FROM GIPI_POLBASIC m,
                                         GIPI_ITEM  n,
                                         GIPI_ITMPERIL y
                                   WHERE 1=1
                                     AND NVL(m.back_stat,5) = 2
                                     AND m.pol_flag IN ('1','2','3','4','X')
                                     AND m.endt_seq_no > c.endt_seq_no
                                     AND y.peril_cd IS NOT NULL
                                     AND m.policy_id  = n.policy_id
                                     AND n.policy_id  = y.policy_id
                                     AND n.item_no    = y.item_no
                                     AND y.peril_cd  = f.peril_cd
                                     AND n.item_no    = vv_item_no(pol)
                                     AND m.line_cd    = vv_line_cd(pol)
                                     AND m.subline_cd = vv_subline_cd(pol)
                                     AND m.iss_cd     = vv_iss_cd(pol)
                                     AND m.issue_yy   = vv_issue_yy(pol)
                                     AND m.pol_seq_no = vv_pol_seq_no(pol)
                                     AND m.renew_no   = vv_renew_no (pol)
                                     )
                    ORDER BY c.eff_date DESC)
         LOOP
              v_dist_flag        := x.dist_flag;
              v_currency_rt      := x.currency_rt;
              v_prem_rt          := x.prem_rt;
              v_peril_cd         := x.peril_cd;
              v_peril_name       := x.peril_name;
              v_peril_sname      := x.peril_sname;
              v_policy_id        := x.policy_id;
              v_ann_tsi_amt      := x.ann_tsi_amt;
              --v_dist_no          := x.dist_no;
              v_endt_seq_no      := x.endt_seq_no;

              --modified by iris bordey (04.06.2003)
              --gets effectivity date of the POLICY where status is cancelled
              IF x.pol_flag = '4'
                 /*
                 ** nieko 01032017
                 **AND Get_Cancel_Effectivity(vv_line_cd(pol), vv_subline_cd(pol), vv_iss_cd(pol),
                             vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol)) = 'Y' /*>= SYSDATE*/ THEN
                 --get effectivity date of the policy instead
                 --of the effectivity of the cancellation endorsement
                 FOR dt IN (SELECT eff_date
                              FROM GIPI_POLBASIC
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
              --vv_eff_date(pol)         := TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM');
/*modified by VJ 091707*/
--              vv_incept_date(pol)      := TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM');
              vv_endt_expiry_date(pol) := TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM');
--              vv_expiry_date(pol)      := TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM');
              vv_endt_seq_no(pol)      := x.endt_seq_no;
              vv_policy_id(pol)        := x.policy_id;

              /*by iris bordey 03.28.2003
             **the added script is to check if peril is already inserted on gixx_block_accumulation
             **to resolve duplication of records*/
             --if processing a new rec (new policy no + item) then create a new vv_temp_peril collection
             --otherwise check existence of the peril from the collection
              v_insert_sw := 'Y';
              IF v_new_rec = 'Y' THEN
                 vv_temp_peril.DELETE;
                 v_new_rec   := 'N';
                 v_insert_sw := 'Y';
              ELSE
                 FOR tmp IN vv_temp_peril.FIRST..vv_temp_peril.LAST LOOP
                   IF v_peril_cd = vv_temp_peril(tmp) THEN
                      v_insert_sw := 'N';
                   END IF;
                 END LOOP;
              END IF;
              IF v_insert_sw = 'Y' THEN
                 vv_temp_peril.EXTEND(1);
                 vv_temp_peril(vv_temp_peril.COUNT) := v_peril_cd;

/*added by VJ 091707*/
                 latest_duration(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                           vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                               v_incept,v_expiry);

                 --iris 07.23.2002 gets the latest assured of the policy
                 latest_assured(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                           vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                               v_assd_no,  v_assd_name);
                 Compute_Ann_Tsi(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                              vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                              vv_item_no(pol),      v_peril_cd,      v_ann_tsi_amt);
                 Latest_Prem_Rt(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                             vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
                                  vv_item_no(pol),  v_peril_cd,         v_prem_rt);
                   IF vv_pol_seq_no(pol) = 1925 AND vv_item_no(pol) = 4 THEN
                    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_peril_cd)||'-INS');
                 END IF;
                 INSERT INTO GIXX_BLOCK_ACCUMULATION
                   (line_cd,                   subline_cd,                iss_cd,
                    issue_yy,                  pol_seq_no,                renew_no,
                    dist_flag,                 ann_tsi_amt,               assd_no,
                    assd_name,
                    eff_date,
                    incept_date,
                    expiry_date,
                    endt_expiry_date,
                      tarf_cd,
                    construction_cd,           loc_risk,                  peril_cd,
                    prem_rt,                   peril_sname,               peril_name,
                    item_no,                   district_no,               block_no,
                    province_cd,               city,                      block_id,
                    fr_item_type,              policy_id,                 dist_no,
                    endt_seq_no,               RISK_CD)
                 VALUES
                   (vv_line_cd(pol),           vv_subline_cd(pol),        vv_iss_cd(pol),
                    vv_issue_yy(pol),          vv_pol_seq_no(pol),        vv_renew_no(pol),
                    v_dist_flag,                v_ann_tsi_amt,            v_assd_no,
                    v_assd_name,
                    TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
/*modified by VJ 091707*/
/*                    TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),*/
                    V_INCEPT,V_EXPIRY,
                    TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    vv_tarf_cd(pol),
                    vv_construction_cd(pol),   vv_loc_risk(pol),          v_peril_cd,
                    v_prem_rt,           v_peril_sname,       v_peril_name,
                    vv_item_no(pol),           vv_district_no(pol),       vv_block_no(pol),
                    vv_province_cd(pol),       vv_city(pol),              vv_block_id(pol),
                    vv_fr_item_type(pol),      vv_policy_id(pol),         v_dist_no,
                       vv_endt_seq_no(pol),       VV_RISK_CD(POL));
                    -- exit;
                   --dbms_output.put_line(to_char(pol)||'-4');
              END IF;
         END LOOP;
       END LOOP;
      COMMIT;
      -- after populating gixx_block_accumulation table, the same table will now be used
      -- to populate the gixx_block_accumulation_dist.

      -- initialize collection
      vv_line_cd.DELETE;          vv_subline_cd.DELETE;        vv_iss_cd.DELETE;
      vv_issue_yy.DELETE;          vv_pol_seq_no.DELETE;        vv_renew_no.DELETE;
      vv_eff_date.DELETE;         vv_incept_date.DELETE;
      vv_expiry_date.DELETE;      vv_endt_expiry_date.DELETE;  vv_tarf_cd.DELETE;
      vv_construction_cd.DELETE;  vv_loc_risk.DELETE;
      vv_item_no.DELETE;          vv_district_no.DELETE;       vv_block_no.DELETE;
      vv_province_cd.DELETE;      vv_city.DELETE;              vv_block_id.DELETE;
      vv_fr_item_type.DELETE;     vv_policy_id.DELETE;         vv_endt_seq_no.DELETE;
       vv_RISK_CD.DELETE;
      /*Modified by  : Iris Bordey 06.10.2003
      **Modification : 1. Omitted query on table gipi_parlist (see from clause).
      **             : 2. Link gipi_polbasic and gixx_block_accumulation by policy no instead of pol. id
      */
      SELECT A.line_cd,           A.subline_cd,                A.iss_cd,
             A.issue_yy,          A.pol_seq_no,                A.renew_no,
             A.dist_flag,         A.ann_tsi_amt,               A.assd_no,
             A.assd_name,
             TO_CHAR(A.eff_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(A.incept_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(A.expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(A.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
             A.tarf_cd,           A.construction_cd,           A.loc_risk,
             A.peril_cd,          A.prem_rt,                   A.peril_sname,
             A.peril_name,        A.item_no,                   A.district_no,
             A.block_no,          A.province_cd,               A.city,
             A.block_id,          A.fr_item_type,              b.share_cd,
             b.dist_tsi * f.currency_rt,                                        --nieko 07132016 kb 894
                                  b.dist_no,                   c.share_type,
             A.endt_seq_no,
             A.RISK_CD
        BULK COLLECT INTO
             vv_line_cd,          vv_subline_cd,               vv_iss_cd,
             vv_issue_yy,         vv_pol_seq_no,               vv_renew_no,
             vv_dist_flag,        vv_ann_tsi_amt,              vv_assd_no,
             vv_assd_name,
             vv_eff_date,
             vv_incept_date,
             vv_expiry_date,
             vv_endt_expiry_date,
             vv_tarf_cd,          vv_construction_cd,          vv_loc_risk,
             vv_peril_cd,         vv_prem_rt,                  vv_peril_sname,
             vv_peril_name,       vv_item_no,                  vv_district_no,
             vv_block_no,         vv_province_cd,              vv_city,
             vv_block_id,         vv_fr_item_type,             vv_share_cd,
             vv_dist_tsi,         vv_dist_no,                  vv_share_type,
             vv_endt_seq_no,      VV_RISK_CD
        FROM GIUW_ITEMPERILDS_DTL            b,  --284k
             GIPI_POLBASIC                   d,  -- 84k
             GIUW_POL_DIST                   e,  --81k
             GIXX_BLOCK_ACCUMULATION         A, --249
             GIIS_DIST_SHARE                 c,
             GIPI_ITEM                       f --nieko 07132016 kb 894
       WHERE 1=1
       --link gipi_polbasic and gixx_block_accumulation by policy num.
         AND A.line_cd    = d.line_cd
         AND A.subline_cd = d.subline_cd
         AND A.iss_cd     = d.iss_cd
         AND A.issue_yy   = d.issue_yy
         AND A.pol_seq_no = d.pol_seq_no
         AND A.renew_no   = d.renew_no
         --link giuw_pol_dist and gipi_polbasic
         AND d.policy_id          = e.policy_id
         AND e.dist_flag         IN ('1','2','3')
         --AND TRUNC(e.eff_date)   <= TRUNC(SYSDATE) -- grace 21june2006
          --AND TRUNC(e.expiry_date)> TRUNC(SYSDATE) --by jen 21june2005
         --link giuw_itemperilds_dtl
         AND b.dist_no      = e.dist_no
         AND b.dist_seq_no >= 0
         AND b.item_no      = A.item_no
         AND b.peril_cd     = A.peril_cd
         AND b.line_cd      = A.line_cd
         --link giis_dist_share
         AND A.line_cd      = c.line_cd
         AND b.share_cd     = c.share_cd --nieko 07132016 kb 894
         AND d.policy_id = f.policy_id   --nieko 07132016 kb 894
         AND f.item_no = b.item_no;
--         AND a.iss_cd       = DECODE(p_bus_type,1,a.iss_cd,2,v_ri,a.iss_cd)
--         AND a.iss_cd      <> DECODE(p_bus_type,1,v_ri,'XX');
/*        FROM giis_dist_share         c,
             giuw_itemperilds_dtl    b,
             gipi_polbasic         d,
             giuw_pol_dist e,
             gipi_parlist f,
             gixx_block_accumulation a
       WHERE 1=1
         AND d.par_id = f.par_id
         AND e.par_id = f.par_id
         AND e.dist_no = b.dist_no
         AND b.dist_seq_no >= 0
         AND a.item_no      = b.item_no
         AND a.peril_cd     = b.peril_cd
         AND a.line_cd      = b.line_cd
         AND a.line_cd      = c.line_cd
         AND b.share_cd     = c.share_cd
         AND e.dist_flag IN ('1','2','3')
         AND TRUNC(e.eff_date) <= TRUNC(SYSDATE)
          AND TRUNC(e.expiry_date) > TRUNC(SYSDATE)
         AND a.policy_id = d.policy_id;*/
      IF SQL%FOUND THEN
         FORALL pol IN vv_line_cd.FIRST..vv_line_cd.LAST
           INSERT INTO GIXX_BLOCK_ACCUMULATION_DIST
             (line_cd,                   subline_cd,                  iss_cd,
              issue_yy,                  pol_seq_no,                  renew_no,
              dist_flag,                 ann_tsi_amt,                 assd_no,
              assd_name,
              eff_date,
              incept_date,
              expiry_date,
              endt_expiry_date,
              tarf_cd,
              construction_cd,           loc_risk,                    peril_cd,
              prem_rt,                   peril_sname,                 peril_name,
              item_no,                   district_no,                 block_no,
              province_cd,               city,                        block_id,
              fr_item_type,              share_cd,                    dist_tsi,
              share_type,                endt_seq_no,                 RISK_CD)
            VALUES
             (vv_line_cd(pol),           vv_subline_cd(pol),          vv_iss_cd(pol),
              vv_issue_yy(pol),          vv_pol_seq_no(pol),          vv_renew_no(pol),
              vv_dist_flag(pol),         vv_ann_tsi_amt(pol),         vv_assd_no(pol),
              vv_assd_name(pol),
              TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              vv_tarf_cd(pol),
              vv_construction_cd(pol),   vv_loc_risk(pol),            vv_peril_cd(pol),
              vv_prem_rt(pol),           vv_peril_sname(pol),         vv_peril_name(pol),
              vv_item_no(pol),           vv_district_no(pol),         vv_block_no(pol),
              vv_province_cd(pol),       vv_city(pol),                vv_block_id(pol),
              vv_fr_item_type(pol),      vv_share_cd(pol),            vv_dist_tsi(pol),
              vv_share_type(pol),        vv_endt_seq_no(pol),         VV_RISK_CD(POL));
      END IF;
    END IF;
  END EXTRACT;

  FUNCTION Get_Cancel_Effectivity
   (p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy    GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no    GIPI_POLBASIC.renew_no%TYPE)
  RETURN VARCHAR2 AS
    v_eff_date    DATE;
  BEGIN
    FOR pol IN (
      SELECT eff_date
        FROM GIPI_POLBASIC
       WHERE line_cd    = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd     = p_iss_cd
         AND issue_yy   = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND renew_no   = p_renew_no
         AND pol_flag   = '4'
        ORDER BY endt_seq_no DESC)
    LOOP
    --    RETURN(pol.eff_date);
       v_eff_date := pol.eff_date;
       EXIT;
    END LOOP;
    IF v_eff_date >= SYSDATE THEN
       RETURN ('Y');
    ELSE
       RETURN ('N');
    END IF;
  END;

  
  
  
  -- procedure returns the latest province_cd, city, district_no, block_no,
  PROCEDURE Latest_Block (p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                         p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                         p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
                         v_block_no    OUT GIPI_FIREITEM.block_no%TYPE,
                         v_district_no OUT GIPI_FIREITEM.district_no%TYPE,
                         v_province_cd OUT GIIS_BLOCK.province_cd%TYPE,
                         v_city        OUT GIIS_BLOCK.city%TYPE,
                         v_block_id    OUT GIIS_BLOCK.block_id%TYPE,
                         v_risk_cd     out GIPI_FIREITEM.RISK_CD%type) IS
  BEGIN
    FOR blk IN (SELECT z.block_no,     y.district_no,      z.province_cd,
                       z.city,         z.block_id, Y.RISK_CD RISK_CD
                  FROM GIPI_POLBASIC x,
                       GIPI_FIREITEM y,
                       GIIS_BLOCK z
                 WHERE 1 = 1
                   --AND x.pol_flag IN ('1','2','3','X')
                   AND x.pol_flag IN ('1', '2', '3','4','X')
                   /*
                   ** nieko 01032017
                   **AND DECODE (x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                             x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                   AND NOT EXISTS(SELECT 'X'
                                    FROM GIPI_POLBASIC m,
                                         GIPI_FIREITEM  n
                                   WHERE 1 = 1
                                     AND m.pol_flag IN ('1', '2', '3','4','X')
                                     AND DECODE (m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                                         m.iss_cd, m.issue_yy,
                                                                                         m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND NVL(m.back_stat,5) = 2
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND (n.block_no IS NOT NULL
                                       OR n.district_no IS NOT NULL)
                                     AND m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no)
                   AND (y.block_no IS NOT NULL OR y.district_no IS NOT NULL)
                   AND x.policy_id  = y.policy_id
                   AND y.block_id   = z.block_id
                   AND y.item_no    = p_item_no
                   AND x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
              ORDER BY x.eff_date DESC)
    LOOP
      v_block_no    := blk.block_no;
      v_district_no := blk.district_no;
      v_province_cd := blk.province_cd;
      v_city        := blk.city;
      v_block_id    := blk.block_id;
      V_RISK_CD     := BLK.RISK_CD;
      EXIT;
    END LOOP;
  END Latest_Block;
  


  
  -- procedure returns the latest tarf_cd
  PROCEDURE Latest_Tarf_Cd (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                            p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                            p_tarf_cd    OUT GIPI_FIREITEM.tarf_cd%TYPE) IS
  BEGIN
    FOR tarf IN (SELECT y.tarf_cd
                   FROM GIPI_POLBASIC x,
                        GIPI_FIREITEM y
                  WHERE 1 = 1
                    --AND x.pol_flag IN ('1','2','3','X')
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    /*
                    ** nieko 01032017
                    **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                    AND NOT EXISTS(SELECT 'X'
                                     FROM GIPI_POLBASIC m,
                                          GIPI_FIREITEM  n
                                    WHERE 1 = 1
                                      --AND m.pol_flag IN ('1','2','3','X')
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                     m.iss_cd, m.issue_yy,
                                                                     m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND n.tarf_cd IS NOT NULL
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND y.tarf_cd IS NOT NULL
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_tarf_cd := tarf.tarf_cd;
      EXIT;
    END LOOP;
  END Latest_Tarf_Cd;
  --proceudre returns the latest construction_cd
  PROCEDURE Latest_Construct_Cd (p_line_cd    IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_iss_cd     IN GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy   IN GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no   IN GIPI_POLBASIC.renew_no%TYPE,
                                 p_item_no    IN GIPI_FIREITEM.item_no%TYPE,
                                 p_constrc_cd OUT  GIPI_FIREITEM.tarf_cd%TYPE) IS
  BEGIN
    FOR cons IN (SELECT y.construction_cd
                   FROM GIPI_POLBASIC x,
                        GIPI_FIREITEM y
                  WHERE 1 = 1
                    --AND x.pol_flag IN ('1','2','3','X')
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    /*
                    ** nieko 01032017
                    **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                    AND NOT EXISTS(SELECT 'X'
                                     FROM GIPI_POLBASIC m,
                                          GIPI_FIREITEM  n
                                    WHERE 1 = 1
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                     m.iss_cd, m.issue_yy,
                                                                     m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND n.construction_cd IS NOT NULL
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND y.construction_cd IS NOT NULL
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_constrc_cd := cons.construction_cd;
      EXIT;
    END LOOP;
  END Latest_Construct_Cd;
  -- procedure returns the latest loc_risk
  PROCEDURE Latest_Loc_Risk (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                             p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                             p_loc_risk   OUT VARCHAR2) IS
  BEGIN
    FOR loc IN (SELECT y.loc_risk1||' '||y.loc_risk2||' '||y.loc_risk3 loc_risk
                  FROM GIPI_POLBASIC x,
                       GIPI_FIREITEM y
                 WHERE 1 = 1
                   AND x.pol_flag IN ('1', '2', '3','4','X')
                   /*
                   ** nieko 01032017
                   **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                   AND NOT EXISTS(SELECT 'X'
                                    FROM GIPI_POLBASIC m,
                                         GIPI_FIREITEM  n
                                   WHERE 1 = 1
                                     AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                     m.iss_cd, m.issue_yy,
                                                                     m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND NVL(m.back_stat,5) = 2
                                     AND (n.loc_risk1 IS NOT NULL
                                          OR n.loc_risk2 IS NOT NULL
                                          OR n.loc_risk3 IS NOT NULL)
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no      )
                   AND (y.loc_risk1 IS NOT NULL
                        OR y.loc_risk2 IS NOT NULL
                        OR y.loc_risk3 IS NOT NULL)
                   AND x.policy_id  = y.policy_id
                   AND y.item_no    = p_item_no
                   AND x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
              ORDER BY x.eff_date DESC)
    LOOP
      p_loc_risk := loc.loc_risk;
      EXIT;
    END LOOP;
  END Latest_Loc_Risk;
  -- the procedure computes the ann_tsi_amt per policy_no, item_no,
  PROCEDURE Compute_Ann_Tsi (p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                             p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
                             p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
                             v_ann_tsi_amt  OUT GIPI_POLBASIC.ann_tsi_amt%TYPE) IS
  BEGIN
    v_ann_tsi_amt := 0;
    SELECT SUM((NVL(c.tsi_amt,0) * NVL(b.currency_rt,0))) ann_tsi
      INTO v_ann_tsi_amt
      FROM GIPI_ITMPERIL c,
           GIPI_ITEM     b,
           GIPI_POLBASIC A
     WHERE 1=1
       AND A.policy_id    = b.policy_id
       AND b.policy_id    = c.policy_id
       AND c.line_cd      = A.line_cd
       AND c.item_no      = b.item_no
       AND b.item_no      = p_item_no
       AND c.peril_cd     = p_peril_cd
       AND A.line_cd      = p_line_cd
       AND A.subline_cd   = p_subline_cd
       AND A.iss_cd       = p_iss_cd
       AND A.issue_yy     = p_issue_yy
       AND A.pol_seq_no   = p_pol_seq_no
       AND A.renew_no     = p_renew_no;
  END Compute_Ann_Tsi;
  --the procedure returns the latest premium rate
  PROCEDURE Latest_Prem_Rt(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                           p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
                           p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
                              v_prem_rt     OUT GIPI_ITMPERIL.prem_rt%TYPE) IS
  BEGIN
    FOR prem IN  (SELECT y.prem_rt prem_rt
                    FROM GIPI_ITMPERIL y,
                         GIPI_POLBASIC x
                   WHERE 1 = 1
                     AND x.pol_flag IN ('1', '2', '3','4','X')
                     /*
                     ** nieko 01032017
                     **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                     AND y.prem_rt IS NOT NULL
                     AND x.policy_id  = y.policy_id
                     AND y.item_no    = p_item_no
                     AND y.peril_cd   = p_peril_cd
                     AND x.line_cd    = p_line_cd
                     AND x.subline_cd = p_subline_cd
                     AND x.iss_cd     = p_iss_cd
                     AND x.issue_yy   = p_issue_yy
                     AND x.pol_seq_no = p_pol_seq_no
                     AND x.renew_no   = p_renew_no
                   ORDER BY x.endt_seq_no DESC)
    LOOP
      v_prem_rt := prem.prem_rt;
    EXIT;
    END LOOP;
  END Latest_Prem_Rt;
  PROCEDURE Latest_Fr_Item_Type   (p_line_cd    IN GIPI_POLBASIC.line_cd%TYPE,
                                   p_subline_cd IN GIPI_POLBASIC.line_cd%TYPE,
                                   p_iss_cd     IN GIPI_POLBASIC.iss_cd%TYPE,
                                   p_issue_yy   IN GIPI_POLBASIC.issue_yy%TYPE,
                                   p_pol_seq_no IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                   p_renew_no   IN GIPI_POLBASIC.renew_no%TYPE,
                                   p_item_no    IN GIPI_FIREITEM.item_no%TYPE,
                                   p_fr_item_type OUT  GIPI_FIREITEM.fr_item_type%TYPE) IS
  BEGIN
    FOR fr   IN (SELECT y.fr_item_type fr_item_type
                   FROM GIPI_POLBASIC x,
                        GIPI_FIREITEM y
                  WHERE 1 = 1
                    --AND x.pol_flag IN ('1','2','3','X')
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    /*
                    ** nieko 01032017
                    **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                    AND NOT EXISTS(SELECT 'X'
                                     FROM GIPI_POLBASIC m,
                                          GIPI_FIREITEM  n
                                    WHERE 1 = 1
                                      --AND m.pol_flag IN ('1','2','3','X')
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                     m.iss_cd, m.issue_yy,
                                                                     m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.fr_item_type IS NOT NULL
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.fr_item_type IS NOT NULL
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_fr_item_type := fr.fr_item_type;
      EXIT;
    END LOOP;
  END Latest_Fr_Item_Type;
  PROCEDURE latest_assured (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                            p_assd_no     OUT GIIS_ASSURED.assd_no%TYPE,
                            p_assd_name   OUT GIIS_ASSURED.assd_name%TYPE) IS
  BEGIN
    FOR asd  IN (SELECT z.assd_no assd_no, z.assd_name assd_name
                   FROM
                        GIPI_PARLIST  y,
                        GIPI_POLBASIC x,
                        GIIS_ASSURED  z
                  WHERE 1=1
                    --AND x.pol_flag IN ('1','2','3','X')
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    /*
                    ** nieko 01032017
                    **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                    AND NOT EXISTS(SELECT 'X'
                                     FROM
                                          GIPI_PARLIST  n,
                                          GIPI_POLBASIC m,
                                          GIIS_ASSURED  o
                                    WHERE 1 = 1
                                      --AND m.pol_flag IN ('1','2','3','X')
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
  END latest_assured;






/*added by VJ 091707*/
  PROCEDURE latest_duration (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                             p_incept     OUT GIPI_POLBASIC.incept_date%TYPE,
                             p_expiry     OUT GIPI_POLBASIC.expiry_date%TYPE) IS
  BEGIN
    FOR asd  IN (SELECT x.incept_date,x.expiry_date
                   FROM GIPI_POLBASIC x
                  WHERE 1=1
                    --AND x.pol_flag IN ('1','2','3','X')
                    AND x.pol_flag IN ('1', '2', '3','4','X')
                    /*
                    ** nieko 01032017
                    **AND DECODE(x.pol_flag,'4',Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
                                                                     x.iss_cd, x.issue_yy,
                                                                     x.pol_seq_no, x.renew_no),'Y') = 'Y'*/
                    AND NOT EXISTS(SELECT 'X'
                                     FROM GIPI_POLBASIC m
                                    WHERE 1 = 1
                                      --AND m.pol_flag IN ('1','2','3','X')
                                      AND m.pol_flag IN ('1', '2', '3','4','X')
                                      AND DECODE(m.pol_flag,'4',Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
                                                                     m.iss_cd, m.issue_yy,
                                                                     m.pol_seq_no, m.renew_no),'Y') = 'Y'
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no)
                    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
               ORDER BY x.eff_date DESC)
    LOOP
      p_incept   := asd.incept_date;
      p_expiry   := asd.expiry_date;
      EXIT;
    END LOOP;
  END latest_duration;
--end VJ--
END Block_Accum;
/

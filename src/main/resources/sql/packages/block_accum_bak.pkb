CREATE OR REPLACE PACKAGE BODY CPI.Block_Accum_Bak
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
AS
  -- extraction of data will start and end in this procedure. this will function as the
  -- main module for the entire extraction for block accumulation.
  PROCEDURE extract (p_province_cd   giis_block.province_cd%TYPE,
                     p_city_cd       giis_block.city_cd%TYPE,
				     p_district_no   giis_block.district_no%TYPE,
					 p_block_no      giis_block.block_no%TYPE)
  IS
    TYPE tab_line_cd            IS TABLE OF gixx_block_accumulation.line_cd%TYPE;
    TYPE tab_subline_cd         IS TABLE OF gixx_block_accumulation.subline_cd%TYPE;
    TYPE tab_iss_cd             IS TABLE OF gixx_block_accumulation.iss_cd%TYPE;
    TYPE tab_issue_yy           IS TABLE OF gixx_block_accumulation.issue_yy%TYPE;
    TYPE tab_pol_seq_no         IS TABLE OF gixx_block_accumulation.pol_seq_no%TYPE;
    TYPE tab_renew_no           IS TABLE OF gixx_block_accumulation.renew_no%TYPE;
    TYPE tab_dist_flag          IS TABLE OF gixx_block_accumulation.dist_flag%TYPE;
    TYPE tab_ann_tsi_amt        IS TABLE OF gixx_block_accumulation.ann_tsi_amt%TYPE;
    TYPE tab_assd_no            IS TABLE OF gixx_block_accumulation.assd_no%TYPE;
    TYPE tab_assd_name          IS TABLE OF gixx_block_accumulation.assd_name%TYPE;
    TYPE tab_eff_date           IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.eff_date%type;
    TYPE tab_incept_date        IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.incept_date%type;
    TYPE tab_expiry_date        IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.expiry_date%type;
    TYPE tab_endt_expiry_date   IS TABLE OF VARCHAR2(25);  --gixx_block_accumulation.endt_expiry_date%type;
    TYPE tab_tarf_cd            IS TABLE OF gixx_block_accumulation.tarf_cd%TYPE;
    TYPE tab_construction_cd    IS TABLE OF gixx_block_accumulation.construction_cd%TYPE;
    TYPE tab_loc_risk           IS TABLE OF gixx_block_accumulation.loc_risk%TYPE;
    TYPE tab_peril_cd           IS TABLE OF gixx_block_accumulation.peril_cd%TYPE;
    TYPE tab_prem_rt            IS TABLE OF gixx_block_accumulation.prem_rt%TYPE;
    TYPE tab_peril_sname        IS TABLE OF gixx_block_accumulation.peril_sname%TYPE;
    TYPE tab_peril_name         IS TABLE OF gixx_block_accumulation.peril_name%TYPE;
    TYPE tab_item_no            IS TABLE OF gixx_block_accumulation.item_no%TYPE;
    TYPE tab_district_no        IS TABLE OF gixx_block_accumulation.district_no%TYPE;
    TYPE tab_block_no           IS TABLE OF gixx_block_accumulation.block_no%TYPE;
    TYPE tab_province_cd        IS TABLE OF gixx_block_accumulation.province_cd%TYPE;
    TYPE tab_city               IS TABLE OF gixx_block_accumulation.city%TYPE;
    TYPE tab_block_id			IS TABLE OF gixx_block_accumulation.block_id%TYPE;
	TYPE tab_fr_item_type       IS TABLE OF gixx_block_accumulation.fr_item_type%TYPE;
	TYPE tab_policy_id          IS TABLE OF gipi_polbasic.policy_id%TYPE;
	TYPE tab_currency_rt        IS TABLE OF gipi_item.currency_rt%TYPE;
    TYPE tab_dist_no            IS TABLE OF giuw_pol_dist.dist_no%TYPE;
	TYPE tab_share_type         IS TABLE OF giis_dist_share.share_type%TYPE;
	TYPE tab_share_cd           IS TABLE OF giis_dist_share.share_cd%TYPE;
	TYPE tab_dist_tsi           IS TABLE OF gixx_block_accumulation_dist.dist_tsi%TYPE;
	TYPE tab_endt_seq_no        IS TABLE OF gixx_block_accumulation.endt_seq_no%TYPE;

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
    vv_block_id			  tab_block_id;
	vv_fr_item_type       tab_fr_item_type;
	vv_policy_id          tab_policy_id;
	vv_currency_rt        tab_currency_rt;
	vv_dist_no            tab_dist_no;
	vv_share_type         tab_share_type;
	vv_share_cd           tab_share_cd;
	vv_dist_tsi           tab_dist_tsi;
	vv_endt_seq_no        tab_endt_seq_no;
	v_dist_flag           giuw_pol_dist.dist_flag%TYPE; --varchar2;
	v_currency_rt         gipi_item.currency_rt%TYPE;
	v_prem_rt             gipi_itmperil.prem_rt%TYPE;
	v_peril_cd            giis_peril.peril_cd%TYPE;
	v_peril_name          giis_peril.peril_name%TYPE;
	v_peril_sname         giis_peril.peril_sname%TYPE;
	v_assd_name           giis_assured.assd_name%TYPE;
	v_assd_no             giis_assured.assd_no%TYPE;
	v_policy_id           gipi_polbasic.policy_id%TYPE := 0;
	v_ann_tsi_amt         gipi_itmperil.ann_tsi_amt%TYPE;
	v_dist_no             giuw_pol_dist.dist_no%TYPE;
	v_item_no             gipi_item.item_no%TYPE;
	v_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
	v_loop                NUMBER := 0;
	--by iris bordey var created on 03.28.2003
	v_new_rec             VARCHAR2(1) := 'Y';  --identifies if processing a new rec.
	v_insert_sw           VARCHAR2(1) := 'Y';  --identifies if rec. should be inserted on gixx_block_accumulation
	--v_distno              giuw_pol_dist.dist_no%TYPE := 0; --(iob (01.31.2003)- to handle specified dist. number)
  BEGIN
    DELETE FROM gixx_block_accumulation;
	COMMIT;
	SELECT DISTINCT a.item_no,       x.line_cd,
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
	   vv_policy_id    := tab_policy_id();
	   vv_temp_peril   := tab_peril_cd();
	   --dbms_output.put_line('2');
	   vv_district_no.extend(vv_item_no.COUNT);
	   vv_block_no.extend(vv_item_no.COUNT);
	   vv_province_cd.extend(vv_item_no.COUNT);
	   vv_city.extend(vv_item_no.COUNT);
	   vv_block_id.extend(vv_item_no.COUNT);
	   vv_tarf_cd.extend(vv_item_no.COUNT);
	   vv_construction_cd.extend(vv_item_no.COUNT);
	   vv_loc_risk.extend(vv_item_no.COUNT);
	   vv_fr_item_type.extend(vv_item_no.COUNT);
	   vv_eff_date.extend(vv_item_no.COUNT);
	   vv_incept_date.extend(vv_item_no.COUNT);
	   vv_expiry_date.extend(vv_item_no.COUNT);
	   vv_endt_expiry_date.extend(vv_item_no.COUNT);
	   vv_endt_seq_no.extend(vv_item_no.COUNT);
	   vv_policy_id.extend(vv_item_no.COUNT);
       FOR pol IN vv_item_no.first..vv_item_no.last
	   LOOP
	     Latest_Block(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                      vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                      vv_item_no(pol),      vv_block_no(pol),     vv_district_no(pol),
                      vv_province_cd(pol),  vv_city(pol),         vv_block_id(pol));
		 Latest_Tarf_Cd(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                        vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                        vv_item_no(pol),      vv_tarf_cd(pol));
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
		 v_new_rec := 'Y';
		 FOR x IN (SELECT e.currency_rt,           f.prem_rt,
		                  f.peril_cd,          g.peril_name,            g.peril_sname,
           	              c.policy_id,
		                  0 ann_tsi_amt,       b.item_no, c.endt_seq_no,
						  c.eff_date,          c.expiry_date,           c.endt_expiry_date,
						  c.incept_date,       c.pol_flag,--d.dist_no,
						  c.dist_flag
                     FROM gipi_parlist   h,    giis_peril     g,
                          gipi_itmperil  f,    gipi_item      e,        --giuw_pol_dist  d,
                          gipi_polbasic  c,    gipi_fireitem  b
                    WHERE 1=1
	                  AND c.par_id      = h.par_id
	                  --and d.par_id    = h.par_id
					  --commented by iris bordey 03.28.2003
					  --AND d.policy_id   = c.policy_id
					  --AND d.dist_no     = v_distno
	                  --AND d.dist_flag   IN ('1','2','3')
	                  AND e.policy_id   = c.policy_id
	                  AND b.policy_id   = e.policy_id
	                  AND b.item_no     = e.item_no
	                  AND f.policy_id   = e.policy_id
	                  AND f.item_no     = e.item_no
	                  AND f.line_cd     = g.line_cd
	                  AND f.peril_cd    = g.peril_cd
					  AND c.pol_flag   IN  ('1', '2','3','4','X')
	                  AND e.item_no     = vv_item_no(pol)
					  AND g.line_cd     = vv_line_cd(pol)
	                  AND c.line_cd     = vv_line_cd(pol)
	                  AND c.subline_cd  = vv_subline_cd(pol)
	                  AND c.iss_cd      = vv_iss_cd(pol)
	                  AND c.issue_yy    = vv_issue_yy(pol)
	                  AND c.pol_seq_no  = vv_pol_seq_no(pol)
	                  AND c.renew_no    = vv_renew_no(pol)
					  AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m,
                                         gipi_item  n,
										 gipi_itmperil y
                                   WHERE 1=1
								     AND m.policy_id  = n.policy_id
                                     AND n.policy_id  = y.policy_id
									 AND n.item_no    = y.item_no
									 AND y.peril_cd  = f.peril_cd
									 AND NVL(m.back_stat,5) = 2
                                     AND n.item_no    = vv_item_no(pol)
									 AND m.line_cd    = vv_line_cd(pol)
                                     AND m.subline_cd = vv_subline_cd(pol)
                                     AND m.iss_cd     = vv_iss_cd(pol)
                                     AND m.issue_yy   = vv_issue_yy(pol)
                                     AND m.pol_seq_no = vv_pol_seq_no(pol)
                                     AND m.renew_no   = vv_renew_no (pol)
                                     AND m.pol_flag IN ('1','2','3','4','X')
                                     AND m.endt_seq_no > c.endt_seq_no
                                     AND y.peril_cd IS NOT NULL
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
			     AND Get_Cancel_Effectivity(vv_line_cd(pol), vv_subline_cd(pol), vv_iss_cd(pol),
				             vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol)) >= SYSDATE THEN
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
			  --vv_eff_date(pol)         := TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM');

			  vv_incept_date(pol)      := TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM');
			  vv_endt_expiry_date(pol) := TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM');
			  vv_expiry_date(pol)      := TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM');
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
			     FOR tmp IN vv_temp_peril.first..vv_temp_peril.last LOOP
				   IF v_peril_cd = vv_temp_peril(tmp) THEN
				      v_insert_sw := 'N';
				   END IF;
				 END LOOP;
			  END IF;
			  IF v_insert_sw = 'Y' THEN
			     vv_temp_peril.extend(1);
				 vv_temp_peril(vv_temp_peril.COUNT) := v_peril_cd;

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
		            dbms_output.put_line(TO_CHAR(v_peril_cd)||'-INS');
	             END IF;
			     INSERT INTO gixx_block_accumulation
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
			        endt_seq_no)
                 VALUES
		           (vv_line_cd(pol),           vv_subline_cd(pol),        vv_iss_cd(pol),
                    vv_issue_yy(pol),          vv_pol_seq_no(pol),        vv_renew_no(pol),
                    v_dist_flag,                v_ann_tsi_amt,            v_assd_no,
                    v_assd_name,
			        TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
			        TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                    TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
			        TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
			        vv_tarf_cd(pol),
                    vv_construction_cd(pol),   vv_loc_risk(pol),          v_peril_cd,
                    v_prem_rt,           v_peril_sname,       v_peril_name,
                    vv_item_no(pol),           vv_district_no(pol),       vv_block_no(pol),
                    vv_province_cd(pol),       vv_city(pol),              vv_block_id(pol),
                    vv_fr_item_type(pol),      vv_policy_id(pol),         v_dist_no,
	   		        vv_endt_seq_no(pol));
	 			   -- exit;
			       --dbms_output.put_line(to_char(pol)||'-4');
			  END IF;
		 END LOOP;
	   END LOOP;
	  COMMIT;
	  -- after populating gixx_block_accumulation table, the same table will now be used
	  -- to populate the gixx_block_accumulation_dist.
      DELETE FROM gixx_block_accumulation_dist;
	  COMMIT;
      -- initialize collection
      vv_line_cd.DELETE;          vv_subline_cd.DELETE;        vv_iss_cd.DELETE;
      vv_issue_yy.DELETE;	      vv_pol_seq_no.DELETE;        vv_renew_no.DELETE;
	  vv_eff_date.DELETE;         vv_incept_date.DELETE;
	  vv_expiry_date.DELETE;      vv_endt_expiry_date.DELETE;  vv_tarf_cd.DELETE;
	  vv_construction_cd.DELETE;  vv_loc_risk.DELETE;
	  vv_item_no.DELETE;          vv_district_no.DELETE;       vv_block_no.DELETE;
	  vv_province_cd.DELETE;      vv_city.DELETE;              vv_block_id.DELETE;
	  vv_fr_item_type.DELETE;     vv_policy_id.DELETE;         vv_endt_seq_no.DELETE;
	  /*Modified by  : Iris Bordey 06.10.2003
	  **Modification : 1. Omitted query on table gipi_parlist (see from clause).
	  **             : 2. Link gipi_polbasic and gixx_block_accumulation by policy no instead of pol. id
	  */
	  SELECT a.line_cd,           a.subline_cd,                a.iss_cd,
	         a.issue_yy,          a.pol_seq_no,                a.renew_no,
			 a.dist_flag,         a.ann_tsi_amt,               a.assd_no,
			 a.assd_name,
             TO_CHAR(a.eff_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.incept_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
			 a.tarf_cd,           a.construction_cd,           a.loc_risk,
			 a.peril_cd,          a.prem_rt,                   a.peril_sname,
			 a.peril_name,        a.item_no,                   a.district_no,
			 a.block_no,          a.province_cd,               a.city,
			 a.block_id,          a.fr_item_type,              b.share_cd,
			 b.dist_tsi,          b.dist_no,                   c.share_type,
			 a.endt_seq_no
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
			 vv_endt_seq_no
		FROM gixx_block_accumulation         a,
		     gipi_polbasic                   d,
			 giuw_pol_dist                   e,
			 giuw_itemperilds_dtl            b,
			 giis_dist_share                 c
	   WHERE 1=1
	   --link gipi_polbasic and gixx_block_accumulation by policy num.
	     AND a.line_cd    = d.line_cd
		 AND a.subline_cd = d.subline_cd
		 AND a.iss_cd     = d.iss_cd
		 AND a.issue_yy   = d.issue_yy
		 AND a.pol_seq_no = d.pol_seq_no
		 AND a.renew_no   = d.renew_no
		 --link giuw_pol_dist and gipi_polbasic
		 AND d.policy_id          = e.policy_id
		 AND e.dist_flag         IN ('1','2','3')
		 AND TRUNC(e.eff_date)   <= TRUNC(SYSDATE)
 		 AND TRUNC(e.expiry_date)> TRUNC(SYSDATE)
		 --link giuw_itemperilds_dtl
		 AND b.dist_no      = e.dist_no
		 AND b.dist_seq_no >= 0
		 AND b.item_no      = a.item_no
         AND b.peril_cd     = a.peril_cd
         AND b.line_cd      = a.line_cd
		 --link giis_dist_share
		 AND a.line_cd      = c.line_cd
         AND b.share_cd     = c.share_cd;
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
	     FORALL pol IN vv_line_cd.first..vv_line_cd.last
		   INSERT INTO gixx_block_accumulation_dist
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
			  share_type,                endt_seq_no)
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
			  vv_share_type(pol),        vv_endt_seq_no(pol));
	  END IF;
	END IF;
  END extract;
  -- procedure returns the latest province_cd, city, district_no, block_no,
  PROCEDURE Latest_Block(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                         p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                         p_item_no      IN gipi_fireitem.item_no%TYPE,
                         v_block_no    OUT gipi_fireitem.block_no%TYPE,
                         v_district_no OUT gipi_fireitem.district_no%TYPE,
                         v_province_cd OUT giis_block.province_cd%TYPE,
                         v_city        OUT giis_block.city%TYPE,
                         v_block_id    OUT giis_block.block_id%TYPE) IS
  BEGIN
    FOR blk IN (SELECT z.block_no,     y.district_no,      z.province_cd,
                       z.city,         z.block_id
                  FROM gipi_polbasic x,
                       gipi_fireitem y,
                       giis_block z
                 WHERE x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
                   --AND x.pol_flag IN ('1','2','3','X')
				   AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                   AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m,
                                         gipi_fireitem  n
                                   WHERE m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no
                                     --AND m.pol_flag IN ('1','2','3','X')
									 AND (m.pol_flag IN ('1', '2', '3','X')
	                                      OR(m.pol_flag = '4' AND
			                                 Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                                        m.iss_cd, m.issue_yy,
									                                m.pol_seq_no, m.renew_no) >= SYSDATE))
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND NVL(m.back_stat,5) = 2
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND (n.block_no IS NOT NULL
									   OR n.district_no IS NOT NULL))
                   AND x.policy_id  = y.policy_id
                   AND y.block_id   = z.block_id
                   AND y.item_no    = p_item_no
                   AND (y.block_no IS NOT NULL OR y.district_no IS NOT NULL)
              ORDER BY x.eff_date DESC)
    LOOP
      v_block_no    := blk.block_no;
      v_district_no := blk.district_no;
      v_province_cd := blk.province_cd;
      v_city        := blk.city;
      v_block_id    := blk.block_id;
      EXIT;
    END LOOP;
  END Latest_Block;
  -- procedure returns the latest tarf_cd
  PROCEDURE Latest_Tarf_Cd (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                            p_item_no     IN gipi_fireitem.item_no%TYPE,
                            p_tarf_cd    OUT gipi_fireitem.tarf_cd%TYPE) IS
  BEGIN
    FOR tarf IN (SELECT y.tarf_cd
                   FROM gipi_polbasic x,
                        gipi_fireitem y
                  WHERE x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
                    --AND x.pol_flag IN ('1','2','3','X')
					AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_fireitem  n
                                    WHERE m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no
                                      --AND m.pol_flag IN ('1','2','3','X')
									  AND (m.pol_flag IN ('1', '2', '3','X')
	                                       OR(m.pol_flag = '4' AND
			                               Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                                      m.iss_cd, m.issue_yy,
									                              m.pol_seq_no, m.renew_no) >= SYSDATE))
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.tarf_cd IS NOT NULL)
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.tarf_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      p_tarf_cd := tarf.tarf_cd;
      EXIT;
    END LOOP;
  END Latest_Tarf_Cd;
  --proceudre returns the latest construction_cd
  PROCEDURE Latest_Construct_Cd (p_line_cd    IN gipi_polbasic.line_cd%TYPE,
                                 p_subline_cd IN gipi_polbasic.line_cd%TYPE,
                                 p_iss_cd     IN gipi_polbasic.iss_cd%TYPE,
                                 p_issue_yy   IN gipi_polbasic.issue_yy%TYPE,
                                 p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
                                 p_renew_no   IN gipi_polbasic.renew_no%TYPE,
                                 p_item_no    IN gipi_fireitem.item_no%TYPE,
                                 p_constrc_cd OUT  gipi_fireitem.tarf_cd%TYPE) IS
  BEGIN
    FOR cons IN (SELECT y.construction_cd
                   FROM gipi_polbasic x,
                        gipi_fireitem y
                  WHERE x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
                    --AND x.pol_flag IN ('1','2','3','X')
					AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_fireitem  n
                                    WHERE m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no
                                      --AND m.pol_flag IN ('1','2','3','X')
									  AND (m.pol_flag IN ('1', '2', '3','X')
	                                       OR(m.pol_flag = '4' AND
 			                                  Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                              m.iss_cd, m.issue_yy,
									                      m.pol_seq_no, m.renew_no) >= SYSDATE))
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.construction_cd IS NOT NULL)
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.construction_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      p_constrc_cd := cons.construction_cd;
      EXIT;
    END LOOP;
  END Latest_Construct_Cd;
  -- procedure returns the latest loc_risk
  PROCEDURE Latest_Loc_Risk (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                             p_item_no     IN gipi_fireitem.item_no%TYPE,
                             p_loc_risk   OUT VARCHAR2) IS
  BEGIN
    FOR loc IN (SELECT y.loc_risk1||' '||y.loc_risk2||' '||y.loc_risk3 loc_risk
                  FROM gipi_polbasic x,
                       gipi_fireitem y
                 WHERE x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
                   --AND x.pol_flag IN ('1','2','3','X')
				   AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                   AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m,
                                         gipi_fireitem  n
                                   WHERE m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no
                                     --AND m.pol_flag IN ('1','2','3','X')
									 AND (m.pol_flag IN ('1', '2', '3','X')
 	                                      OR(m.pol_flag = '4' AND
			                              Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                      m.iss_cd, m.issue_yy,
									              m.pol_seq_no, m.renew_no) >= SYSDATE))
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND NVL(m.back_stat,5) = 2
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND (n.loc_risk1 IS NOT NULL
                                          OR n.loc_risk2 IS NOT NULL
                                          OR n.loc_risk3 IS NOT NULL))
                   AND x.policy_id  = y.policy_id
                   AND y.item_no    = p_item_no
                   AND (y.loc_risk1 IS NOT NULL
                        OR y.loc_risk2 IS NOT NULL
                        OR y.loc_risk3 IS NOT NULL)
              ORDER BY x.eff_date DESC)
    LOOP
      p_loc_risk := loc.loc_risk;
      EXIT;
    END LOOP;
  END Latest_Loc_Risk;
  -- the procedure computes the ann_tsi_amt per policy_no, item_no,
  PROCEDURE Compute_Ann_Tsi (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                             p_item_no      IN gipi_fireitem.item_no%TYPE,
                             p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
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
       AND a.policy_id    = b.policy_id
       AND b.item_no      = p_item_no
       AND b.policy_id    = c.policy_id
       AND c.item_no      = p_item_no
       AND c.line_cd      = a.line_cd
       AND c.peril_cd     = p_peril_cd;
  END Compute_Ann_Tsi;
  --the procedure returns the latest premium rate
  PROCEDURE Latest_Prem_Rt(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                           p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                           p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                           p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                           p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                           p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                           p_item_no      IN gipi_fireitem.item_no%TYPE,
						   p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
   			               v_prem_rt     OUT gipi_itmperil.prem_rt%TYPE) IS
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
                     --AND x.pol_flag IN ('1','2','3','X')
					 AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                     AND x.policy_id  = y.policy_id
                     AND y.item_no    = p_item_no
					 AND y.peril_cd   = p_peril_cd
                     AND y.prem_rt IS NOT NULL
		           ORDER BY x.endt_seq_no DESC)
    LOOP
      v_prem_rt := prem.prem_rt;
	EXIT;
    END LOOP;
  END Latest_Prem_Rt;
  PROCEDURE Latest_Fr_Item_Type   (p_line_cd    IN gipi_polbasic.line_cd%TYPE,
                                   p_subline_cd IN gipi_polbasic.line_cd%TYPE,
                                   p_iss_cd     IN gipi_polbasic.iss_cd%TYPE,
                                   p_issue_yy   IN gipi_polbasic.issue_yy%TYPE,
                                   p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
                                   p_renew_no   IN gipi_polbasic.renew_no%TYPE,
                                   p_item_no    IN gipi_fireitem.item_no%TYPE,
                                   p_fr_item_type OUT  gipi_fireitem.fr_item_type%TYPE) IS
  BEGIN
    FOR fr   IN (SELECT y.fr_item_type fr_item_type
                   FROM gipi_polbasic x,
                        gipi_fireitem y
                  WHERE x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
                    --AND x.pol_flag IN ('1','2','3','X')
					AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_fireitem  n
                                    WHERE m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no
                                      --AND m.pol_flag IN ('1','2','3','X')
									  AND (m.pol_flag IN ('1', '2', '3','X')
	                                      OR(m.pol_flag = '4' AND
			                              Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                      m.iss_cd, m.issue_yy,
									              m.pol_seq_no, m.renew_no) >= SYSDATE))
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.fr_item_type IS NOT NULL)
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.fr_item_type IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      p_fr_item_type := fr.fr_item_type;
      EXIT;
    END LOOP;
  END Latest_Fr_Item_Type;
  PROCEDURE latest_assured (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                            p_assd_no     OUT giis_assured.assd_no%TYPE,
                            p_assd_name   OUT giis_assured.assd_name%TYPE) IS
  BEGIN
    FOR asd  IN (SELECT z.assd_no assd_no, z.assd_name assd_name
                   FROM gipi_polbasic x,
                        gipi_parlist  y,
						giis_assured  z
                  WHERE 1=1
				    AND x.par_id     = y.par_id
					AND y.assd_no    = z.assd_no
				    AND x.line_cd    = p_line_cd
                    AND x.subline_cd = p_subline_cd
                    AND x.iss_cd     = p_iss_cd
                    AND x.issue_yy   = p_issue_yy
                    AND x.pol_seq_no = p_pol_seq_no
                    AND x.renew_no   = p_renew_no
                    --AND x.pol_flag IN ('1','2','3','X')
					AND (x.pol_flag IN ('1', '2', '3','X')
	                    OR(x.pol_flag = '4' AND
			               Get_Cancel_Effectivity(x.line_cd, x.subline_cd,
			                          x.iss_cd, x.issue_yy,
									  x.pol_seq_no, x.renew_no) >= SYSDATE))
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_parlist  n,
										  giis_assured  o
                                    WHERE m.line_cd    = p_line_cd
                                      AND m.subline_cd = p_subline_cd
                                      AND m.iss_cd     = p_iss_cd
                                      AND m.issue_yy   = p_issue_yy
                                      AND m.pol_seq_no = p_pol_seq_no
                                      AND m.renew_no   = p_renew_no
                                      --AND m.pol_flag IN ('1','2','3','X')
									  AND (m.pol_flag IN ('1', '2', '3','X')
	                                       OR(m.pol_flag = '4' AND
			                               Get_Cancel_Effectivity(m.line_cd, m.subline_cd,
			                                  m.iss_cd, m.issue_yy,
									          m.pol_seq_no, m.renew_no) >= SYSDATE))
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.par_id     = n.par_id
                                      AND n.assd_no    = o.assd_no
                                      AND n.assd_no IS NOT NULL)
                    AND x.par_id     = y.par_id
                    AND y.assd_no    = z.assd_no
                    AND y.assd_no IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      p_assd_no   := asd.assd_no;
	  p_assd_name := asd.assd_name;
      EXIT;
    END LOOP;
  END latest_assured;
END block_accum_bak;
/

DROP PACKAGE BODY CPI.BLOCK_ACCUM_BAK;


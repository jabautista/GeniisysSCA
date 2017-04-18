CREATE OR REPLACE PACKAGE BODY CPI.vessel_accum AS
PROCEDURE EXTRACT (p_vessel_cd       giis_vessel.vessel_cd%TYPE,
		  		   p_bus_type		 NUMBER) IS
    TYPE tab_line_cd             IS TABLE OF gixx_vessel_accumulation.line_cd%TYPE;
    TYPE tab_subline_cd          IS TABLE OF gixx_vessel_accumulation.subline_cd%TYPE;
    TYPE tab_iss_cd              IS TABLE OF gixx_vessel_accumulation.iss_cd%TYPE;
    TYPE tab_issue_yy            IS TABLE OF gixx_vessel_accumulation.issue_yy%TYPE;
    TYPE tab_pol_seq_no          IS TABLE OF gixx_vessel_accumulation.pol_seq_no%TYPE;
    TYPE tab_renew_no            IS TABLE OF gixx_vessel_accumulation.renew_no%TYPE;
    TYPE tab_dist_flag           IS TABLE OF gixx_vessel_accumulation.dist_flag%TYPE;
    TYPE tab_ann_tsi_amt         IS TABLE OF gixx_vessel_accumulation.ann_tsi_amt%TYPE;
    TYPE tab_assd_no             IS TABLE OF gixx_vessel_accumulation.assd_no%TYPE;
    TYPE tab_assd_name           IS TABLE OF gixx_vessel_accumulation.assd_name%TYPE;
    TYPE tab_eff_date            IS TABLE OF VARCHAR2(25);  --gixx_vessel_accumulation.eff_date%TYPE;
    TYPE tab_incept_date         IS TABLE OF VARCHAR2(25);  --gixx_vessel_accumulation.incept_date%TYPE;
    TYPE tab_expiry_date         IS TABLE OF VARCHAR2(25);  --gixx_vessel_accumulation.expiry_date%TYPE;
    TYPE tab_endt_expiry_date    IS TABLE OF VARCHAR2(25);  --gixx_vessel_accumulation.endt_expiry_date%TYPE;
    TYPE tab_peril_cd            IS TABLE OF gixx_vessel_accumulation.peril_cd%TYPE;
    TYPE tab_prem_rt             IS TABLE OF gixx_vessel_accumulation.prem_rt%TYPE;
    TYPE tab_peril_sname         IS TABLE OF gixx_vessel_accumulation.peril_sname%TYPE;
    TYPE tab_peril_name          IS TABLE OF gixx_vessel_accumulation.peril_name%TYPE;
    TYPE tab_item_no             IS TABLE OF gixx_vessel_accumulation.item_no%TYPE;
    TYPE tab_vessel_cd           IS TABLE OF gixx_vessel_accumulation.vessel_cd%TYPE;
    TYPE tab_eta                 IS TABLE OF VARCHAR2(25);
    TYPE tab_etd                 IS TABLE OF VARCHAR2(25);
    TYPE tab_bl_awb              IS TABLE OF gixx_vessel_accumulation.bl_awb%TYPE;
    TYPE tab_cargo_type          IS TABLE OF gixx_vessel_accumulation.cargo_type%TYPE;
    TYPE tab_cargo_class_cd      IS TABLE OF gixx_vessel_accumulation.cargo_class_cd%TYPE;
    TYPE tab_cargo_type_desc     IS TABLE OF gixx_vessel_accumulation.cargo_type_desc%TYPE;
    TYPE tab_cargo_class_desc    IS TABLE OF gixx_vessel_accumulation.cargo_class_desc%TYPE;
    TYPE tab_policy_id           IS TABLE OF gipi_polbasic.policy_id%TYPE;
    TYPE tab_currency_rt         IS TABLE OF gipi_item.currency_rt%TYPE;
    TYPE tab_dist_no             IS TABLE OF giuw_pol_dist.dist_no%TYPE;
    TYPE tab_share_type          IS TABLE OF giis_dist_share.share_type%TYPE;
    TYPE tab_share_cd            IS TABLE OF giis_dist_share.share_cd%TYPE;
    TYPE tab_dist_tsi            IS TABLE OF gixx_vessel_acc_dist.dist_tsi%TYPE;
    TYPE tab_endt_seq_no         IS TABLE OF gixx_vessel_accumulation.endt_seq_no%TYPE;
    vv_line_cd            	 tab_line_cd;
    vv_subline_cd         	 tab_subline_cd;
    vv_iss_cd             	 tab_iss_cd;
    vv_issue_yy           	 tab_issue_yy;
    vv_pol_seq_no         	 tab_pol_seq_no;
    vv_renew_no           	 tab_renew_no;
    vv_dist_flag          	 tab_dist_flag;
    vv_ann_tsi_amt        	 tab_ann_tsi_amt;
    vv_assd_no            	 tab_assd_no;
    vv_assd_name          	 tab_assd_name;
    vv_eff_date           	 tab_eff_date;
    vv_incept_date        	 tab_incept_date;
    vv_expiry_date        	 tab_expiry_date;
    vv_endt_expiry_date   	 tab_endt_expiry_date;
    vv_peril_cd           	 tab_peril_cd;
    vv_prem_rt            	 tab_prem_rt;
    vv_peril_sname        	 tab_peril_sname;
    vv_peril_name         	 tab_peril_name;
    vv_item_no             	 tab_item_no;
    vv_policy_id          	 tab_policy_id;
    vv_currency_rt        	 tab_currency_rt;
    vv_dist_no            	 tab_dist_no;
    vv_share_type         	 tab_share_type;
    vv_share_cd           	 tab_share_cd;
    vv_dist_tsi           	 tab_dist_tsi;
    vv_endt_seq_no        	 tab_endt_seq_no;
    vv_vessel_cd          	 tab_vessel_cd;
    vv_eta					 tab_eta;
    vv_etd					 tab_etd;
    vv_bl_awb           	 tab_bl_awb;
    vv_cargo_type     	     tab_cargo_type;
    vv_cargo_class_cd    	 tab_cargo_class_cd;
    vv_cargo_type_desc   	 tab_cargo_type_desc;
    vv_cargo_class_desc      tab_cargo_class_desc;
    v_dist_flag              giuw_pol_dist.dist_flag%TYPE; --VARCHAR2;
    v_currency_rt            gipi_item.currency_rt%TYPE;
    v_prem_rt                gipi_itmperil.prem_rt%TYPE;
    v_peril_cd               giis_peril.peril_cd%TYPE;
    v_peril_name             giis_peril.peril_name%TYPE;
    v_peril_sname            giis_peril.peril_sname%TYPE;
    v_assd_name              giis_assured.assd_name%TYPE;
    v_assd_no                giis_assured.assd_no%TYPE;
    v_policy_id              gipi_polbasic.policy_id%TYPE := 0;
    v_ann_tsi_amt            gipi_itmperil.ann_tsi_amt%TYPE;
    v_dist_no                giuw_pol_dist.dist_no%TYPE;
    v_item_no                gipi_item.item_no%TYPE;
    v_endt_seq_no         	 gipi_polbasic.endt_seq_no%TYPE;
    v_loop                	 NUMBER := 0;
	v_ri					 VARCHAR2(7);
  BEGIN
    v_ri := giacp.v('RI_ISS_CD');
	--dbms_output.put_line('DELETE FROM GIXX_VESSEL_ACCUMULATION');
    DELETE FROM gixx_vessel_accumulation;
    COMMIT;
	DELETE FROM gixx_vessel_acc_dist;
    COMMIT;
	--dbms_output.put_line(' START SELECT');
    SELECT item_no,			 vessel_cd,			policy_id,
		   subline_cd, 		 iss_cd, 			issue_yy,
		   line_cd, 		 pol_seq_no, 		renew_no,
		   endt_seq_no, 	 eff_date, 			incept_date,
		   expiry_date, 	 endt_expiry_date,  eta,
           etd, 			 bl_awb, 			cargo_type,
           cargo_class_cd, 	 cargo_type_desc, 	cargo_class_desc
    BULK COLLECT INTO
		   vv_item_no, 		 vv_vessel_cd,		vv_policy_id,
		   vv_subline_cd,    vv_iss_cd,         vv_issue_yy,
   	   	   vv_line_cd,     	 vv_pol_seq_no,     vv_renew_no,
		   vv_endt_seq_no,   vv_eff_date,    	vv_incept_date,
		   vv_expiry_date,   vv_endt_expiry_date, vv_eta,
           vv_etd, 			 vv_bl_awb, 		  vv_cargo_type,
           vv_cargo_class_cd,vv_cargo_type_desc, vv_cargo_class_desc
    FROM (
	  SELECT a.item_no 	   item_no,
	  		 a.vessel_cd   vessel_cd,
             x.policy_id   policy_id,
			 x.subline_cd  subline_cd,
			 x.iss_cd      iss_cd,
	         x.issue_yy    issue_yy,
			 x.line_cd     line_cd,
			 x.pol_seq_no  pol_seq_no,
	         x.renew_no    renew_no,
			 x.endt_seq_no endt_seq_no,
	         TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM') 		  eff_date,
	         TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM') 	  incept_date,
	         TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM')      expiry_date,
	         TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM') endt_expiry_date,
	         NULL eta,
             NULL etd, NULL bl_awb, NULL cargo_type,
             NULL cargo_class_cd,  NULL cargo_type_desc, NULL cargo_class_desc
        FROM gipi_polbasic x,
  	       	 gipi_cargo a
       WHERE 1=1
	     AND x.policy_id = a.policy_id
	     AND x.policy_id = x.policy_id
         AND x.policy_id > 0
	   	 AND x.line_cd LIKE '%'
		 AND x.iss_cd    = DECODE(p_bus_type,1,x.iss_cd,2,v_ri,x.iss_cd)
 	     AND x.iss_cd   <> DECODE(p_bus_type,1,v_ri,'XX')
         AND x.endt_seq_no = (SELECT MAX(a.endt_seq_no)
		                   	    FROM gipi_polbasic a,
			               			 gipi_cargo b
   			         		   WHERE 1=1
					             AND a.policy_id  = b.policy_id
					             AND b.policy_id  > 0
							     AND a.line_cd    = x.line_cd
							     AND a.subline_cd = x.subline_cd
							     AND a.iss_cd     = x.iss_cd
							     AND a.issue_yy   = x.issue_yy
							     AND a.pol_seq_no = x.pol_seq_no
							     AND a.renew_no   = x.renew_no
			   				     AND a.pol_flag IN ('1', '2', '3','X')
							     AND b.vessel_cd = p_vessel_cd)
         AND a.vessel_cd= p_vessel_cd
	     AND x.pol_flag IN ('1', '2', '3','X')
    UNION
    SELECT a.item_no item_no, a.vessel_cd vessel_cd,
           x.policy_id policy_id, x.subline_cd subline_cd, x.iss_cd iss_cd,
	   x.issue_yy issue_yy, x.line_cd line_cd, x.pol_seq_no pol_seq_no,
	   x.renew_no renew_no, x.endt_seq_no endt_seq_no,
	   TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM') eff_date,
	   TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM') incept_date,
	   TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM') expiry_date,
	   TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM') endt_expiry_date,
 	   NULL eta,
           NULL etd, NULL bl_awb, NULL cargo_type,
           NULL cargo_class_cd, NULL cargo_type_desc, NULL cargo_class_desc
      FROM gipi_polbasic x,
	   gipi_aviation_item a
     WHERE 1=1
       AND x.policy_id = a.policy_id
       AND x.policy_id = x.policy_id
       AND x.policy_id > 0
       AND x.line_cd LIKE '%'
	   AND x.iss_cd    = DECODE(p_bus_type,1,x.iss_cd,2,v_ri,x.iss_cd)
 	   AND x.iss_cd   <> DECODE(p_bus_type,1,v_ri,'XX')
       AND x.endt_seq_no = (SELECT MAX(a.endt_seq_no)
  		              FROM gipi_polbasic a,
			           gipi_cargo b
   			     WHERE 1=1
			       AND a.policy_id  = b.policy_id
			       AND b.policy_id  > 0
			       AND a.line_cd    = x.line_cd
			       AND a.subline_cd = x.subline_cd
			       AND a.iss_cd     = x.iss_cd
			       AND a.issue_yy   = x.issue_yy
			       AND a.pol_seq_no = x.pol_seq_no
			       AND a.renew_no   = x.renew_no
   			       AND a.pol_flag IN ('1', '2', '3','X')
			       AND b.vessel_cd = p_vessel_cd)
       AND a.vessel_cd= p_vessel_cd
       AND x.pol_flag IN ('1', '2', '3','X')
    UNION
    SELECT a.item_no item_no, a.vessel_cd vessel_cd,
           x.policy_id policy_id, x.subline_cd subline_cd, x.iss_cd iss_cd,
	   x.issue_yy issue_yy, x.line_cd line_cd, x.pol_seq_no pol_seq_no,
	   x.renew_no renew_no, x.endt_seq_no endt_seq_no,
	   TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM') eff_date,
	   TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM') incept_date,
	   TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM') expiry_date,
	   TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM') endt_expiry_date,
	   	   NULL eta,
           NULL etd, NULL bl_awb, NULL cargo_type,
           NULL cargo_class_cd, NULL cargo_type_desc, NULL cargo_class_desc
      FROM gipi_polbasic x,
	   gipi_cargo_carrier a
     WHERE 1=1
       AND x.policy_id = a.policy_id
       AND x.policy_id = x.policy_id
       AND x.policy_id > 0
       AND x.line_cd LIKE '%'
	   AND x.iss_cd    = DECODE(p_bus_type,1,x.iss_cd,2,v_ri,x.iss_cd)
 	   AND x.iss_cd   <> DECODE(p_bus_type,1,v_ri,'XX')
       AND x.endt_seq_no = (SELECT MAX(a.endt_seq_no)
		              FROM gipi_polbasic a,
		                   gipi_cargo b
   		             WHERE 1=1
			       AND a.policy_id  = b.policy_id
			       AND b.policy_id  > 0
			       AND a.line_cd    = x.line_cd
			       AND a.subline_cd = x.subline_cd
			       AND a.iss_cd     = x.iss_cd
			       AND a.issue_yy   = x.issue_yy
			       AND a.pol_seq_no = x.pol_seq_no
			       AND a.renew_no   = x.renew_no
   			       AND a.pol_flag IN ('1', '2', '3','X')
			       AND b.vessel_cd = p_vessel_cd)
       AND a.vessel_cd= p_vessel_cd
       AND x.pol_flag IN ('1', '2', '3','X')
    UNION
    SELECT a.item_no item_no, a.vessel_cd vessel_cd,
           x.policy_id policy_id, x.subline_cd subline_cd, x.iss_cd iss_cd,
	   x.issue_yy issue_yy, x.line_cd line_cd, x.pol_seq_no pol_seq_no,
	   x.renew_no renew_no, x.endt_seq_no endt_seq_no,
	   TO_CHAR(x.eff_date,'MM/DD/YYYY HH:MI:SS AM') eff_date,
	   TO_CHAR(x.incept_date,'MM/DD/YYYY HH:MI:SS AM') incept_date,
	   TO_CHAR(x.expiry_date,'MM/DD/YYYY HH:MI:SS AM') expiry_date,
	   TO_CHAR(x.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM') endt_expiry_date,
	   	 	   NULL eta,
       NULL etd, NULL bl_awb, NULL cargo_type,
       NULL cargo_class_cd, NULL cargo_type_desc, NULL cargo_class_desc
      FROM gipi_polbasic x,
	   gipi_item_ves a
     WHERE 1=1
       AND x.policy_id = a.policy_id
       AND x.policy_id = x.policy_id
       AND x.policy_id > 0
       AND x.line_cd LIKE '%'
	   AND x.iss_cd    = DECODE(p_bus_type,1,x.iss_cd,2,v_ri,x.iss_cd)
 	   AND x.iss_cd   <> DECODE(p_bus_type,1,v_ri,'XX')
       AND x.endt_seq_no = (SELECT MAX(a.endt_seq_no)
  		              FROM gipi_polbasic a,
		                   gipi_cargo b
   	  	             WHERE 1=1
			       AND a.policy_id  = b.policy_id
			       AND b.policy_id  > 0
			       AND a.line_cd    = x.line_cd
			       AND a.subline_cd = x.subline_cd
			       AND a.iss_cd     = x.iss_cd
			       AND a.issue_yy   = x.issue_yy
			       AND a.pol_seq_no = x.pol_seq_no
			       AND a.renew_no   = x.renew_no
   			       AND a.pol_flag IN ('1', '2', '3','X')
			       AND b.vessel_cd = p_vessel_cd)
      AND a.vessel_cd= p_vessel_cd
      AND x.pol_flag IN ('1', '2', '3','X'));
	--dbms_output.put_line(vv_policy_id(1)||'END SELECT');
    IF SQL%FOUND THEN
		--dbms_output.put_line('IF FOUND');
       FOR pol IN vv_policy_id.FIRST..vv_policy_id.LAST
       LOOP
	-- dbms_output.put_line('BL_AWB');
	 latest_bl_awb(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                       vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                       vv_item_no(pol),      vv_bl_awb(pol));
	 --dbms_output.put_line('ETA');
	 latest_eta(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                    vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                    vv_item_no(pol),      vv_eta(pol));
	 --dbms_output.put_line('ETD');
 	 latest_etd(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                    vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                    vv_item_no(pol),      vv_etd(pol));
--	 dbms_output.put_line('CARGO_TYPE');
	 latest_cargo_type(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                    vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                    vv_item_no(pol),      vv_cargo_type(pol), vv_cargo_type_desc(pol));
--		 dbms_output.put_line('CARGO_CLASS');
	 latest_cargo_class(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                    vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                    vv_item_no(pol),      vv_cargo_class_cd(pol), vv_cargo_class_desc(pol));
	--dbms_output.put_line('START LOOP');
         FOR x IN (SELECT c.endt_seq_no, c.policy_id,
                          f.prem_rt,     f.peril_cd,
 	                  g.peril_name,  g.peril_sname,
	                  d.dist_flag,   d.dist_no,
	                  i.assd_name,   i.assd_no,
	                  0 ann_tsi_amt
                    FROM  gipi_polbasic   c
                          ,gipi_itmperil  f
               	          ,giis_peril     g
	                  ,giuw_pol_dist  d
	                  ,giis_assured   i
	                  ,gipi_parlist   h
                    WHERE 1=1
                      AND c.pol_flag   IN  ('1', '2','3','X')
                      AND c.line_cd     = vv_line_cd(pol)
                      AND c.subline_cd  = vv_subline_cd(pol)
                      AND c.iss_cd      = vv_iss_cd(pol)
                      AND c.issue_yy    = vv_issue_yy(pol)
                      AND c.pol_seq_no  = vv_pol_seq_no(pol)
                      AND c.renew_no    = vv_renew_no(pol)
                      AND f.line_cd     = vv_line_cd(pol)
                      AND f.item_no     = vv_item_no(pol)
                      AND f.policy_id   = c.policy_id
                      AND f.peril_cd    = g.peril_cd
                      AND g.line_cd     = vv_line_cd(pol)
                      AND d.policy_id   = c.policy_id
                      AND d.dist_flag   IN ('1','2','3')
                      AND c.par_id      = h.par_id
                      AND i.assd_no     = h.assd_no
                      AND c.endt_seq_no = (SELECT MAX(a.endt_seq_no)
	  	                     	     FROM gipi_polbasic a,
   	                                          gipi_itmperil c
					    WHERE 1=1
					      AND c.line_cd    = vv_line_cd(pol)
					      AND c.item_no    = vv_item_no(pol)
					      AND c.policy_id  = a.policy_id
					      AND c.peril_cd   = f.peril_cd
					      AND a.renew_no   = vv_renew_no(pol)
					      AND a.pol_seq_no = vv_pol_seq_no(pol)
					      AND a.issue_yy   = vv_issue_yy(pol)
					      AND a.iss_cd     = vv_iss_cd(pol)
					      AND a.subline_cd = vv_subline_cd(pol)
					      AND a.line_cd    = vv_line_cd(pol)))
         LOOP
 	   v_dist_flag        := x.dist_flag;
	   v_prem_rt          := x.prem_rt;
	   v_peril_cd         := x.peril_cd;
	   v_peril_name       := x.peril_name;
	   v_peril_sname      := x.peril_sname;
	   v_assd_name        := x.assd_name;
	   v_assd_no          := x.assd_no;
	   v_policy_id        := x.policy_id;
	   v_ann_tsi_amt      := x.ann_tsi_amt;
	   v_dist_no          := x.dist_no;
	   v_endt_seq_no      := x.endt_seq_no;
	   latest_assured(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                          vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
 	           	   v_assd_no,        v_assd_name);
	   compute_ann_tsi(vv_line_cd(pol),      vv_subline_cd(pol),   vv_iss_cd(pol),
                           vv_issue_yy(pol),     vv_pol_seq_no(pol),   vv_renew_no(pol),
                           vv_item_no(pol),      v_peril_cd,      v_ann_tsi_amt);
	   latest_prem_rt(vv_line_cd(pol),  vv_subline_cd(pol), vv_iss_cd(pol),
                          vv_issue_yy(pol), vv_pol_seq_no(pol), vv_renew_no(pol),
 	      		  vv_item_no(pol),  v_peril_cd,         v_prem_rt);
	--dbms_output.put_line('INSERT GIXX_VESSEL');
	   INSERT INTO gixx_vessel_accumulation
	        ( policy_id,           line_cd,                 subline_cd,
   		  iss_cd,              issue_yy,                pol_seq_no,
    		  renew_no,            item_no,                 dist_flag,
                  ann_tsi_amt,         assd_no,                 assd_name,
                  eff_date,
                  incept_date,
                  expiry_date,
                  endt_expiry_date,
		  peril_cd,            prem_rt,                 peril_sname,
                  peril_name,          vessel_cd,	        eta,
                  etd,                 bl_awb,                  cargo_type,
                  cargo_class_cd,      cargo_type_desc,         cargo_class_desc,
                  endt_seq_no)
              VALUES
		(vv_policy_id(pol),      vv_line_cd(pol),         vv_subline_cd(pol),
                 vv_iss_cd(pol),         vv_issue_yy(pol),        vv_pol_seq_no(pol),
                 vv_renew_no(pol),       vv_item_no(pol),         v_dist_flag,
                 v_ann_tsi_amt,          v_assd_no,               v_assd_name,
	         TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
		 TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
                 TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
		 TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
		 v_peril_cd,             v_prem_rt,               v_peril_sname,
                 v_peril_name,	         vv_vessel_cd(pol),
                 TO_DATE(vv_eta(pol),'MM-DD-YYYY HH:MI:SS AM'),
		 TO_DATE(vv_etd(pol),'MM-DD-YYYY HH:MI:SS AM'),
		 vv_bl_awb(pol),          vv_cargo_type(pol),
	         vv_cargo_class_cd(pol), vv_cargo_type_desc(pol), vv_cargo_class_desc(pol),
  	         vv_endt_seq_no(pol));
		--dbms_output.put_line('END INSERT');
         END LOOP;
       END LOOP;
       COMMIT;
       -- AFTER POPULATING GIXX_VESSEL_ACCUMULATION TABLE, THE SAME TABLE WILL NOW BE USED
       -- TO POPULATE THE GIXX_VESSEL_ACC_DIST.
      --dbms_output.put_line('DELETE FROM GIXX_VESSEL_ACCU...DIST');
	  --DELETE FROM GIXX_VESSEL_ACC_DIST;
	  --COMMIT;
      -- INITIALIZE COLLECTION
      vv_line_cd.DELETE;          vv_subline_cd.DELETE;        vv_iss_cd.DELETE;
      vv_issue_yy.DELETE;	      vv_pol_seq_no.DELETE;        vv_renew_no.DELETE;
	  vv_eff_date.DELETE;         vv_incept_date.DELETE;
	  vv_expiry_date.DELETE;      vv_endt_expiry_date.DELETE;
	  vv_vessel_cd.DELETE;        vv_eta.DELETE;                vv_etd.DELETE;
	  vv_bl_awb.DELETE;           vv_cargo_type.DELETE;
      vv_cargo_class_cd.DELETE;   vv_cargo_type_desc.DELETE;    vv_cargo_class_desc.DELETE;
	  vv_item_no.DELETE;          vv_policy_id.DELETE;         vv_endt_seq_no.DELETE;
      	--dbms_output.put_line(' START SELECT 2');
	  	  SELECT a.policy_id,  a.line_cd,           a.subline_cd,                a.iss_cd,
	         a.issue_yy,          a.pol_seq_no,                a.renew_no,
			 a.dist_flag,         a.ann_tsi_amt,               a.assd_no,
			 a.assd_name,
             TO_CHAR(a.eff_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.incept_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
             TO_CHAR(a.endt_expiry_date,'MM/DD/YYYY HH:MI:SS AM'),
			 a.peril_cd,          a.prem_rt,                   a.peril_sname,
			 a.peril_name,        a.item_no,	               a.vessel_cd,
			 TO_CHAR(a.eta,'MM-DD-YYYY HH:MI:SS AM'),
			 TO_CHAR(a.etd,'MM-DD-YYYY HH:MI:SS AM'),
			 a.bl_awb,
			 a.cargo_type,        a.cargo_class_cd,            a.cargo_type_desc,
			 a.cargo_class_desc,  b.share_cd,   			   b.dist_tsi,
			 b.dist_no,           c.share_type,      		   a.endt_seq_no,
			 a.item_no
		BULK COLLECT INTO
             vv_policy_id,  vv_line_cd,          vv_subline_cd,               vv_iss_cd,
	         vv_issue_yy,         vv_pol_seq_no,               vv_renew_no,
			 vv_dist_flag,        vv_ann_tsi_amt,              vv_assd_no,
			 vv_assd_name,
             vv_eff_date,
             vv_incept_date,
             vv_expiry_date,
             vv_endt_expiry_date,
			 vv_peril_cd,         vv_prem_rt,                  vv_peril_sname,
			 vv_peril_name,       vv_item_no,                  vv_vessel_cd,
			 vv_eta,              vv_etd,                      vv_bl_awb,
			 vv_cargo_type,       vv_cargo_class_cd,           vv_cargo_type_desc,
			 vv_cargo_class_desc,  vv_share_cd,    			   vv_dist_tsi,
			 vv_dist_no,         vv_share_type,
			 vv_endt_seq_no,       vv_item_no
        FROM gixx_vessel_accumulation a,
             gipi_polbasic           d,
             giuw_pol_dist           e,
             giuw_itemperilds_dtl    b,
      	     giis_dist_share         c
       WHERE 1=1
         AND a.line_cd    = d.line_cd
         AND a.subline_cd = d.subline_cd
         AND a.iss_cd     = d.iss_cd
         AND a.issue_yy   = d.issue_yy
         AND a.pol_seq_no = d.pol_seq_no
         AND a.renew_no   = d.renew_no
         AND d.pol_flag IN ( '1','2','3','X'  )
         AND e.policy_id  = d.policy_id
         AND e.dist_flag IN ( '1','2','3'  )
         AND e.dist_no   = b.dist_no
         AND e.dist_no   = e.dist_no
         AND a.item_no  = b.item_no
         AND a.peril_cd = b.peril_cd
         AND b.dist_seq_no >= 0
		 AND a.line_cd LIKE '%'
         AND c.line_cd = NVL(b.line_cd, b.line_cd)
         AND c.line_cd = a.line_cd
         AND c.share_cd = b.share_cd;
	--dbms_output.put_line(vv_policy_id(1)||'END SELECT 2');
	  IF SQL%FOUND THEN
		--	dbms_output.put_line('INSERT GIXX_VESSEL_DIST');
	     FORALL pol IN vv_line_cd.FIRST..vv_line_cd.LAST
		   INSERT INTO gixx_vessel_acc_dist
		     (policy_id, line_cd,                   subline_cd,                  iss_cd,
              issue_yy,                  pol_seq_no,                  renew_no,
              dist_flag,                 ann_tsi_amt,                 assd_no,
			  assd_name,
			  eff_date,
			  incept_date,
              expiry_date,
			  endt_expiry_date,
           	  peril_cd,                  vessel_cd,    			      eta,
			  etd,                       bl_awb,			          cargo_type,
			  cargo_class_cd,            cargo_type_desc,	          cargo_class_desc,
			  prem_rt,                   peril_sname,                 peril_name,
			  item_no,                   share_cd,                    dist_tsi,
			  share_type,                endt_seq_no)
			VALUES
			 (vv_policy_id(pol), vv_line_cd(pol),           vv_subline_cd(pol),          vv_iss_cd(pol),
              vv_issue_yy(pol),          vv_pol_seq_no(pol),          vv_renew_no(pol),
              vv_dist_flag(pol),         NVL(vv_ann_tsi_amt(pol),0),         vv_assd_no(pol),
			  vv_assd_name(pol),
			  TO_DATE(vv_eff_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
			  TO_DATE(vv_incept_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              TO_DATE(vv_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
			  TO_DATE(vv_endt_expiry_date(pol),'MM-DD-YYYY HH:MI:SS AM'),
              vv_peril_cd(pol),          vv_vessel_cd(pol),
			  TO_DATE(vv_eta(pol),'MM-DD-YYYY HH:MI:SS AM'),
			  TO_DATE(vv_etd(pol),'MM-DD-YYYY HH:MI:SS AM'),
			  vv_bl_awb(pol),			 vv_cargo_type(pol),
			  vv_cargo_class_cd(pol),    vv_cargo_type_desc(pol),     vv_cargo_class_desc(pol),
			  vv_prem_rt(pol),           vv_peril_sname(pol),         vv_peril_name(pol),
			  vv_item_no(pol),           vv_share_cd(pol),            vv_dist_tsi(pol),
			  vv_share_type(pol),        vv_endt_seq_no(pol));
			--dbms_output.put_line('END INSERT GIXX_VESSEL_DIST');
			  COMMIT;
	  END IF;
	END IF;
  END EXTRACT;
  -- PROCEDURE RETURNS THE LATEST BL_AWB
  PROCEDURE latest_bl_awb  (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                            p_item_no     IN gipi_cargo.item_no%TYPE,
                            p_bl_awb     OUT gipi_cargo.bl_awb%TYPE) IS
  BEGIN
	 --dbms_output.put_line('IN BL_AWB');
    FOR bl_awb IN (SELECT y.bl_awb
                     FROM gipi_polbasic x,
                          gipi_cargo y
                    WHERE x.line_cd    = p_line_cd
                      AND x.subline_cd = p_subline_cd
                      AND x.iss_cd     = p_iss_cd
                      AND x.issue_yy   = p_issue_yy
                      AND x.pol_seq_no = p_pol_seq_no
                      AND x.renew_no   = p_renew_no
                      AND x.pol_flag IN ('1','2','3','X')
                      AND NOT EXISTS(SELECT 'X'
                                       FROM gipi_polbasic m,
                                            gipi_cargo  n
                                      WHERE m.line_cd    = p_line_cd
                                        AND m.subline_cd = p_subline_cd
                                        AND m.iss_cd     = p_iss_cd
                                        AND m.issue_yy   = p_issue_yy
                                        AND m.pol_seq_no = p_pol_seq_no
                                        AND m.renew_no   = p_renew_no
                                        AND m.pol_flag IN ('1','2','3','X')
                                        AND m.endt_seq_no > x.endt_seq_no
                                        AND NVL(m.back_stat,5) = 2
                                        AND m.policy_id  = n.policy_id
                                        AND n.item_no    = p_item_no
                                        AND n.bl_awb IS NOT NULL)
                      AND x.policy_id  = y.policy_id
                      AND y.item_no    = p_item_no
                      AND y.bl_awb IS NOT NULL
                    ORDER BY x.eff_date DESC)
    LOOP
      p_bl_awb := bl_awb.bl_awb;
      EXIT;
    END LOOP;
	 --dbms_output.put_line('END BL_AWB');
  END latest_bl_awb;
  -- PROCEDURE RETURNS THE LATEST ETA
  PROCEDURE latest_eta  (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                         p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                         p_item_no     IN gipi_cargo.item_no%TYPE,
                         p_eta        OUT VARCHAR2) IS
  BEGIN
    FOR cargo  IN (SELECT y.eta
                     FROM gipi_polbasic x,
                          gipi_cargo y
                    WHERE x.line_cd    = p_line_cd
                      AND x.subline_cd = p_subline_cd
                      AND x.iss_cd     = p_iss_cd
                      AND x.issue_yy   = p_issue_yy
                      AND x.pol_seq_no = p_pol_seq_no
                      AND x.renew_no   = p_renew_no
                      AND x.pol_flag IN ('1','2','3','X')
                      AND NOT EXISTS(SELECT 'X'
                                       FROM gipi_polbasic m,
                                            gipi_cargo  n
                                      WHERE m.line_cd    = p_line_cd
                                        AND m.subline_cd = p_subline_cd
                                        AND m.iss_cd     = p_iss_cd
                                        AND m.issue_yy   = p_issue_yy
                                        AND m.pol_seq_no = p_pol_seq_no
                                        AND m.renew_no   = p_renew_no
                                        AND m.pol_flag IN ('1','2','3','X')
                                        AND m.endt_seq_no > x.endt_seq_no
                                        AND NVL(m.back_stat,5) = 2
                                        AND m.policy_id  = n.policy_id
                                        AND n.item_no    = p_item_no
                                        AND n.eta IS NOT NULL)
                      AND x.policy_id  = y.policy_id
                      AND y.item_no    = p_item_no
                      AND y.eta IS NOT NULL
                    ORDER BY x.eff_date DESC)
    LOOP
      p_eta := TO_CHAR(cargo.eta,'MM/DD/YYYY HH:MI:SS AM');
      EXIT;
    END LOOP;
  END latest_eta;
  -- PROCEDURE RETURNS THE LATEST ETD
  PROCEDURE latest_etd  (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                         p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                         p_item_no     IN gipi_cargo.item_no%TYPE,
                         p_etd        OUT VARCHAR2) IS
  BEGIN
    FOR cargo  IN (SELECT y.etd
                     FROM gipi_polbasic x,
                          gipi_cargo y
                    WHERE x.line_cd    = p_line_cd
                      AND x.subline_cd = p_subline_cd
                      AND x.iss_cd     = p_iss_cd
                      AND x.issue_yy   = p_issue_yy
                      AND x.pol_seq_no = p_pol_seq_no
                      AND x.renew_no   = p_renew_no
                      AND x.pol_flag IN ('1','2','3','X')
                      AND NOT EXISTS(SELECT 'X'
                                       FROM gipi_polbasic m,
                                            gipi_cargo  n
                                      WHERE m.line_cd    = p_line_cd
                                        AND m.subline_cd = p_subline_cd
                                        AND m.iss_cd     = p_iss_cd
                                        AND m.issue_yy   = p_issue_yy
                                        AND m.pol_seq_no = p_pol_seq_no
                                        AND m.renew_no   = p_renew_no
                                        AND m.pol_flag IN ('1','2','3','X')
                                        AND m.endt_seq_no > x.endt_seq_no
                                        AND NVL(m.back_stat,5) = 2
                                        AND m.policy_id  = n.policy_id
                                        AND n.item_no    = p_item_no
                                        AND n.etd IS NOT NULL)
                      AND x.policy_id  = y.policy_id
                      AND y.item_no    = p_item_no
                      AND y.etd IS NOT NULL
                    ORDER BY x.eff_date DESC)
    LOOP
      p_etd := TO_CHAR(cargo.etd,'MM/DD/YYYY HH:MI:SS AM');
      EXIT;
    END LOOP;
  END latest_etd;
  --PROCEUDRE RETURNS THE LATEST CARGO_CLASS_CD, CARGO_CLASS_DESC
  PROCEDURE latest_cargo_class  (p_line_cd         IN gipi_polbasic.line_cd%TYPE,
                                 p_subline_cd        IN gipi_polbasic.line_cd%TYPE,
                                 p_iss_cd            IN gipi_polbasic.iss_cd%TYPE,
                                 p_issue_yy          IN gipi_polbasic.issue_yy%TYPE,
                                 p_pol_seq_no        IN gipi_polbasic.pol_seq_no%TYPE,
                                 p_renew_no          IN gipi_polbasic.renew_no%TYPE,
                                 p_item_no           IN gipi_cargo.item_no%TYPE,
                                 p_cargo_class_cd   OUT gipi_cargo.cargo_class_cd%TYPE,
								 p_cargo_class_desc OUT giis_cargo_class.cargo_class_desc%TYPE) IS
  BEGIN
    FOR cargo IN (SELECT z.cargo_class_cd cargo_class_cd, z.cargo_class_desc cargo_class_desc
                    FROM gipi_polbasic x,
                         gipi_cargo y,
                         giis_cargo_class z
                   WHERE x.line_cd    = p_line_cd
                     AND x.subline_cd = p_subline_cd
                     AND x.iss_cd     = p_iss_cd
                     AND x.issue_yy   = p_issue_yy
                     AND x.pol_seq_no = p_pol_seq_no
                     AND x.renew_no   = p_renew_no
                     AND x.pol_flag IN ('1','2','3','X')
                     AND NOT EXISTS(SELECT 'X'
                                      FROM gipi_polbasic m,
                                           gipi_cargo  n
                                     WHERE m.line_cd    = p_line_cd
                                       AND m.subline_cd = p_subline_cd
                                       AND m.iss_cd     = p_iss_cd
                                       AND m.issue_yy   = p_issue_yy
                                       AND m.pol_seq_no = p_pol_seq_no
                                       AND m.renew_no   = p_renew_no
                                       AND m.pol_flag IN ('1','2','3','X')
                                       AND m.endt_seq_no > x.endt_seq_no
                                       AND NVL(m.back_stat,5) = 2
                                       AND m.policy_id  = n.policy_id
                                       AND n.item_no    = p_item_no
                                       AND n.cargo_class_cd IS NOT NULL)
                     AND x.policy_id      = y.policy_id
                     AND y.cargo_class_cd = z.cargo_class_cd
                     AND y.item_no        = p_item_no
                     AND y.cargo_class_cd IS NOT NULL
                   ORDER BY x.eff_date DESC)
    LOOP
	  p_cargo_class_cd   := cargo.cargo_class_cd;
      p_cargo_class_desc := cargo.cargo_class_desc;
      EXIT;
    END LOOP;
  END latest_cargo_class;
  -- PROCEDURE RETURNS THE LATEST CARGO_TYPE
  PROCEDURE latest_cargo_type (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                               p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                               p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                               p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                               p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                               p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                               p_item_no     IN gipi_fireitem.item_no%TYPE,
                               p_cargo_type      OUT gipi_cargo.cargo_type%TYPE,
			       p_cargo_type_desc OUT giis_cargo_type.cargo_type_desc%TYPE) IS
  BEGIN
    FOR cargo IN (SELECT z.cargo_type cargo_type, z.cargo_type_desc cargo_type_desc
                    FROM gipi_polbasic x,
                         gipi_cargo y,
                         giis_cargo_type z
                   WHERE x.line_cd    = p_line_cd
                     AND x.subline_cd = p_subline_cd
                     AND x.iss_cd     = p_iss_cd
                     AND x.issue_yy   = p_issue_yy
                     AND x.pol_seq_no = p_pol_seq_no
                     AND x.renew_no   = p_renew_no
                     AND x.pol_flag IN ('1','2','3','X')
                     AND NOT EXISTS(SELECT 'X'
                                      FROM gipi_polbasic m,
                                           gipi_cargo  n
                                     WHERE m.line_cd    = p_line_cd
                                       AND m.subline_cd = p_subline_cd
                                       AND m.iss_cd     = p_iss_cd
                                       AND m.issue_yy   = p_issue_yy
                                       AND m.pol_seq_no = p_pol_seq_no
                                       AND m.renew_no   = p_renew_no
                                       AND m.pol_flag IN ('1','2','3','X')
                                       AND m.endt_seq_no > x.endt_seq_no
                                       AND NVL(m.back_stat,5) = 2
                                       AND m.policy_id  = n.policy_id
                                       AND n.item_no    = p_item_no
                                       AND n.cargo_type IS NOT NULL)
                      AND x.policy_id  = y.policy_id
                      AND y.cargo_type = z.cargo_type
                      AND y.item_no    = p_item_no
                      AND y.cargo_type IS NOT NULL
                    ORDER BY x.eff_date DESC)
    LOOP
      p_cargo_type      := cargo.cargo_type;
      p_cargo_type_desc := cargo.cargo_type_desc;
      EXIT;
    END LOOP;
  END latest_cargo_type;
  -- THE PROCEDURE COMPUTES THE ANN_TSI_AMT PER POLICY_NO, ITEM_NO,
  PROCEDURE compute_ann_tsi (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
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
    SELECT SUM((NVL(c.tsi_amt,0) * NVL(d.currency_rt,0))) ann_tsi
      INTO v_ann_tsi_amt
      FROM gipi_itmperil c,
           gipi_polbasic a,
		   gipi_item d
     WHERE 1=1
       AND a.pol_flag    IN ('1','2','3','X')
       AND a.line_cd      = p_line_cd
       AND a.subline_cd   = p_subline_cd
       AND a.iss_cd       = p_iss_cd
       AND a.issue_yy     = p_issue_yy
       AND a.pol_seq_no   = p_pol_seq_no
       AND a.renew_no     = p_renew_no
       AND c.policy_id    = a.policy_id
       AND c.item_no      = p_item_no
       AND NVL(c.peril_cd,c.peril_cd) = p_peril_cd --FOR OPTIMIZATION PUPOSES...
       AND NVL(c.line_cd,c.line_cd)   = p_line_cd --FOR OPTIMIZATION PUPOSES...
	   AND d.policy_id    = a.policy_id
	   AND d.item_no      = c.item_no;
  END compute_ann_tsi;
  --THE PROCEDURE RETURNS THE LATEST PREMIUM RATE
  PROCEDURE latest_prem_rt(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
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
                     AND x.pol_flag IN ('1','2','3','X')
                     AND x.policy_id  = y.policy_id
                     AND y.item_no    = p_item_no
					 AND y.peril_cd   = p_peril_cd
                     AND y.prem_rt IS NOT NULL
		           ORDER BY x.endt_seq_no DESC)
    LOOP
      v_prem_rt := prem.prem_rt;
	EXIT;
    END LOOP;
  END latest_prem_rt;
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
                    AND x.pol_flag IN ('1','2','3','X')
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
                                      AND m.pol_flag IN ('1','2','3','X')
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
END vessel_accum;
/



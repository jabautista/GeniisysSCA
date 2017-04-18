CREATE OR REPLACE PACKAGE BODY CPI.summarize_distribution
/*Modified by : Iris Bordey
**     date   : 10.07.2003
**To resolve ora-01476 (divisor  = 0) on computation of share %
**and ora - 01438.
*/
/*Created by : Iris Bordey
**    date   : 02.27.2003
**1. Package summarized distribution of a policy.
**2. Extract tables include giuw_policyds_ext, giuw_itemds_ext, giri_distfrps_ext
*/
AS
  PROCEDURE EXTRACT(p_line_cd VARCHAR2,
                    p_subline_cd VARCHAR2,
	  				p_iss_cd  VARCHAR2,
					p_issue_yy NUMBER,
					p_pol_seq_no NUMBER,
					p_renew_no NUMBER,
					p_date    DATE)

  AS
    v_exist       VARCHAR2(1) := 'N';
  BEGIN
    --check if there will be records to be extracted based from the paramter date (p_date)
    FOR chk IN (SELECT dst.dist_no
                  FROM gipi_polbasic pol,
                       giuw_pol_dist dst
                 WHERE 1=1
                   --link polbasic and giuw_pol_dist
                   AND dst.policy_id  = pol.policy_id
                   --filter gipi_polbasic
                   AND pol.line_cd    = p_line_cd
                   AND pol.subline_cd = p_subline_cd
                   AND pol.iss_cd     = p_iss_cd
                   AND pol.issue_yy   = p_issue_yy
                   AND pol.pol_seq_no = p_pol_seq_no
                   AND pol.renew_no   = p_renew_no
                   AND pol.pol_flag    IN ('1','2','3','4','X')
                   --filter giuw_pol_dist
                   AND dst.dist_flag    = '3'
                   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
                   AND TRUNC(dst.expiry_date) >= TRUNC(p_date))
    LOOP
      v_exist := 'Y';
	  EXIT;
    END LOOP;

    /*if v_exist = Y then summarized valid (effective) distributions only
      if v_exist = N then summarized ALL distribution*/

    IF v_exist = 'Y' THEN
	   DBMS_OUTPUT.PUT_LINE('EFF');
       summarize_eff_distribution(p_line_cd, p_subline_cd, p_iss_cd,
	                                  p_issue_yy, p_pol_seq_no, p_renew_no, p_date);
    ELSIF v_exist = 'N' THEN
      summarize_all_distribution(p_line_cd, p_subline_cd, p_iss_cd,
	                           p_issue_yy, p_pol_seq_no, p_renew_no);
    END IF;
  END;

   /*Procedure is to extract and summarize distribution of the policy plus endorsement.
     Procedure summarizes all destribution without validation on date*/
  PROCEDURE summarize_all_distribution(p_line_cd VARCHAR2,
                                       p_subline_cd VARCHAR2,
					                   p_iss_cd  VARCHAR2,
					                   p_issue_yy NUMBER,
					                   p_pol_seq_no NUMBER,
					                   p_renew_no NUMBER)
  AS

    v_total_tsi         giuw_pol_dist.tsi_amt%TYPE  := 0;
    v_total_prem        giuw_pol_dist.prem_amt%TYPE := 0;
    v_pol_exists        VARCHAR2(1) := 'N';
    v_redst_exists      VARCHAR2(1) := 'N';
    v_facultative       NUMBER;
    v_facul_share       NUMBER(12,9) := 0;

	--added by iris bordey 10.07.2003
	--to resolve ora 01476 (devisor = 0) on computation of share %
    v_tsi_spct			NUMBER(12,9) := 0;
    v_prem_spct			NUMBER(12,9) := 0;
	v_ri_spct			NUMBER(12,9) := 0;


    TYPE share_cd_tab      IS TABLE OF giuw_policyds_ext.share_cd%TYPE;
    TYPE trty_name_tab     IS TABLE OF giuw_policyds_ext.trty_name%TYPE;
    TYPE tsi_spct_tab      IS TABLE OF giuw_policyds_ext.tsi_spct%TYPE;
    TYPE dist_tsi_tab      IS TABLE OF giuw_policyds_ext.dist_tsi%TYPE;
    TYPE prem_spct_tab     IS TABLE OF giuw_policyds_ext.prem_spct%TYPE;
    TYPE dist_prem_tab     IS TABLE OF giuw_policyds_ext.dist_prem%TYPE;
    TYPE dist_no_tab       IS TABLE OF giuw_pol_dist.dist_no%TYPE;
    TYPE item_no_tab       IS TABLE OF giuw_itemds.item_no%TYPE;
	TYPE peril_cd_tab      IS TABLE OF giuw_itemperilds_ext.peril_cd%TYPE;
	TYPE peril_name_tab    IS TABLE OF giuw_itemperilds_ext.peril_name%TYPE;
    TYPE ri_cd_tab         IS TABLE OF giri_distfrps_ext.ri_cd%TYPE;
    TYPE ri_sname_tab      IS TABLE OF giri_distfrps_ext.ri_sname%TYPE;
    TYPE ri_tsi_tab        IS TABLE OF giri_distfrps_ext.ri_tsi_amt%TYPE;
    TYPE ri_prem_tab       IS TABLE OF giri_distfrps_ext.ri_prem_amt%TYPE;


    vv_trty_name           trty_name_tab;
    vv_dist_tsi            dist_tsi_tab;
    vv_dist_prem           dist_prem_tab;
    vv_shares              share_cd_tab;
    vv_redist_no           dist_no_tab;
    vv_item_no             item_no_tab;
    vv_ri_cd               ri_cd_tab;
    vv_ri_sname            ri_sname_tab;
    vv_ri_tsi_amt		   ri_tsi_tab;
    vv_ri_prem_amt         ri_prem_tab;
	vv_peril_cd            peril_cd_tab;
	vv_peril_name          peril_name_tab;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('1');
    /*************************EXTRACTION ON GIUW_POLICDS_EXT**********************************/
    DELETE FROM giuw_policyds_ext
     WHERE line_cd    = p_line_cd
       AND subline_cd = p_subline_cd
	   AND iss_cd     = p_iss_cd
	   AND issue_yy   = p_issue_yy
	   AND pol_seq_no = p_pol_seq_no
	   AND renew_no   = p_renew_no;
    --stores a collection of distinct share_cd and trty_names that this policy have
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
           vv_shares, vv_trty_name
     FROM  gipi_polbasic      pol
          ,giuw_pol_dist      dst
	      ,giuw_policyds_dtl  pdtl
	      ,giis_dist_share    shr
    WHERE 1=1
    --link polbasic and giuw_pol_dist
      AND pol.policy_id  = dst.policy_id
    --link giuw_pol_dist and giuw_policyds_dtl
      AND pdtl.dist_no   = dst.dist_no
      AND pdtl.line_cd   = p_line_cd
    --link giuw_policyds_dtl and giis_dist_share
      AND pdtl.line_cd   = shr.line_cd
      AND pdtl.share_cd   = shr.share_cd
    --filter gipi_polbasic
      AND pol.line_cd    = p_line_cd
      AND pol.subline_cd = p_subline_cd
      AND pol.iss_cd     = p_iss_cd
      AND pol.issue_yy   = p_issue_yy
      AND pol.pol_seq_no = p_pol_seq_no
      AND pol.renew_no   = p_renew_no
      AND pol.pol_flag   IN ('1','2','3','4','X')
    --filter giuw_pol_dist
      AND dst.dist_flag  = '3';

    --initialize collection
    vv_dist_tsi  := dist_tsi_tab();
    vv_dist_prem := dist_prem_tab();
    vv_dist_tsi.EXTEND(vv_shares.COUNT);
    vv_dist_prem.EXTEND(vv_shares.COUNT);

    --stores a collection of distribution number that were redistributed
    SELECT dst.dist_no
      BULK COLLECT INTO
           vv_redist_no
      FROM gipi_polbasic   pol
          ,giuw_pol_dist  dst
     WHERE 1=1
     --link gipi_polbasic and giuw_pol_dist
       AND pol.policy_id = dst.policy_id
     --filter gipi_polbasic
       AND pol.line_cd    = p_line_cd
       AND pol.subline_cd = p_subline_cd
       AND pol.iss_cd     = p_iss_cd
       AND pol.issue_yy   = p_issue_yy
       AND pol.pol_seq_no = p_pol_seq_no
       AND pol.renew_no   = p_renew_no
       AND pol.pol_flag  IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag = '5';
    DBMS_OUTPUT.PUT_LINE('4');
    IF SQL%FOUND THEN
       v_redst_exists := 'Y';
    END IF;
    --extraction is by shares of the policy
    FOR x IN vv_shares.FIRST..vv_shares.LAST
    LOOP
      --get details of dist_tsi and dist_prem for distributions where share_cd is specified and old_dist_no is null.
      FOR dtls IN (SELECT shr.share_cd, shr.trty_name, SUM(pdtl.dist_tsi) dist_tsi, SUM(pdtl.dist_prem) dist_prem
                     FROM gipi_polbasic       pol
                         ,giuw_pol_dist      dst
                         ,giuw_policyds_dtl  pdtl
   	                     ,giis_dist_share    shr
                    WHERE 1=1
                    --link polbasic and giuw_pol_dist
                      AND pol.policy_id  = dst.policy_id
                    --link giuw_pol_dist and giuw_policyds_dtl
                      AND pdtl.dist_no   = dst.dist_no
                      AND pdtl.line_cd   = p_line_cd
                    --link giuw_policyds_dtl and giis_dist_share
                      AND pdtl.line_cd   = shr.line_cd
                      AND pdtl.share_cd  = shr.share_cd
                    --filter gipi_polbasic
                      AND pol.line_cd    = p_line_cd
                      AND pol.subline_cd = p_subline_cd
                      AND pol.iss_cd     = p_iss_cd
                      AND pol.issue_yy   = p_issue_yy
                      AND pol.pol_seq_no = p_pol_seq_no
                      AND pol.renew_no   = p_renew_no
                      AND pol.pol_flag   IN ('1','2','3','4','X')
                    --filter giuw_pol_dist
                      AND dst.dist_flag  = '3'
                      AND dst.old_dist_no IS NULL
		  			  AND pdtl.share_cd  = vv_shares(x)
                    GROUP BY shr.share_cd, shr.trty_name)
      LOOP
	    vv_dist_tsi(x)  := dtls.dist_tsi;           vv_dist_prem(x) := dtls.dist_prem;
	    v_pol_exists := 'Y';
	  END LOOP;
	  --get the details of distribution where old_dist_no is not null and share_cd is specified
	  --this only considers records of latest distribution
	  IF v_redst_exists = 'Y' THEN
	      FOR b IN vv_redist_no.FIRST..vv_redist_no.LAST
		  LOOP
		    FOR dtls IN (SELECT shr.share_cd, shr.trty_name, pdtl.dist_tsi, pdtl.dist_prem
                           FROM gipi_polbasic      pol
                               ,giuw_pol_dist      dst
                       	       ,giuw_policyds_dtl  pdtl
          	                   ,giis_dist_share    shr
                         WHERE 1=1
                         --link polbasic and giuw_pol_dist
                           AND pol.policy_id  = dst.policy_id
                         --link giuw_pol_dist and giuw_policyds_dtl
                           AND pdtl.dist_no   = dst.dist_no
                           AND pdtl.line_cd   = p_line_cd
                          --link giuw_policyds_dtl and giis_dist_share
                           AND pdtl.line_cd   = shr.line_cd
                           AND pdtl.share_cd  = shr.share_cd
					      --filter gipi_polbasic
                           AND pol.line_cd    = p_line_cd
                           AND pol.subline_cd = p_subline_cd
                           AND pol.iss_cd     = p_iss_cd
                           AND pol.issue_yy   = p_issue_yy
                           AND pol.pol_seq_no = p_pol_seq_no
                           AND pol.renew_no   = p_renew_no
                           AND pol.pol_flag   IN ('1','2','3','4','X')
                          --filter giuw_pol_dist
                           AND dst.dist_flag  = '3'
                           AND dst.old_dist_no= vv_redist_no(b)
						   AND pdtl.share_cd  = vv_shares(x)
					     ORDER BY dst.dist_no DESC)
		    LOOP
		       vv_dist_tsi(x)  := NVL(vv_dist_tsi(x),0)  + NVL(dtls.dist_tsi,0);
			   vv_dist_prem(x) := NVL(vv_dist_prem(x),0) + NVL(dtls.dist_prem,0);
			   EXIT;
		    END LOOP;
		  END LOOP;
	  END IF;
	  v_total_tsi  := NVL(vv_dist_tsi(x),0)  + NVL(v_total_tsi,0);
	  v_total_prem := NVL(vv_dist_prem(x),0) + NVL(v_total_prem,0);
    END LOOP; --end of vv_shares.first

    --start insertion of records to guiw_policyds_ext
    FOR x IN vv_shares.FIRST..vv_shares.LAST
    LOOP
	  v_tsi_spct  := get_rate(vv_dist_tsi(x),NVL(v_total_tsi,0));
	  v_prem_spct := get_rate(vv_dist_prem(x),NVL(v_total_prem,0));

      INSERT INTO giuw_policyds_ext
	    (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	     share_cd, trty_name, tsi_spct, dist_tsi, prem_spct, dist_prem)
	  VALUES
	    (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	     vv_shares(x), vv_trty_name(x), DECODE(v_tsi_spct,0,NULL,v_tsi_spct), vv_dist_tsi(x),
	     DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(x));
    END LOOP;

    /************************EXTRACTION ON GIUW_ITEMDS_EXT************************************/

     DELETE FROM giuw_itemds_ext
      WHERE line_cd    = p_line_cd
	    AND subline_cd = p_subline_cd
	    AND iss_cd     = p_iss_cd
	    AND issue_yy   = p_issue_yy
	    AND pol_seq_no = p_pol_seq_no
	    AND renew_no   = p_renew_no;

     --initialize collection for use in extaracting records for giuw_itemds_ext
     vv_shares.DELETE;            vv_trty_name.DELETE;
     vv_dist_tsi.DELETE;          vv_dist_prem.DELETE;
    --holds collection of distinct share of this policy per item
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
	       vv_shares, vv_trty_name
      FROM gipi_polbasic      pol
          ,giuw_pol_dist     dst
	      ,giuw_itemds_dtl   idtl
	      ,giis_dist_share   shr
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id = dst.policy_id
     --link giuw_pol_dist and giuw_itemds_dtl
       AND idtl.line_cd       = p_line_cd
       AND idtl.dist_no       = dst.dist_no
     --link giuw_itemds_dtl and giis_dist_share
       AND idtl.line_cd       = shr.line_cd
       AND idtl.share_cd      = shr.share_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3';

    --holds collection of distinct item no
    SELECT DISTINCT itm.item_no
      BULK COLLECT INTO
	       vv_item_no
      FROM gipi_polbasic      pol
          ,giuw_pol_dist      dst
   	      ,giuw_itemds        itm
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id   = dst.policy_id
     --link giuw_pol_dist and giuw_itemds
       AND itm.dist_no     = dst.dist_no
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
  	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3';

    FOR itm IN vv_item_no.FIRST..vv_item_no.LAST
    LOOP
      --reset v_total_tsi and v_total_prem per item
   	  v_total_tsi := 0;                 v_total_prem := 0;
	  DBMS_OUTPUT.PUT_LINE('RESET');
	  vv_dist_tsi.DELETE;               vv_dist_prem.DELETE;
	  vv_dist_tsi.EXTEND(vv_shares.COUNT);
	  vv_dist_prem.EXTEND(vv_shares.COUNT);
      FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    FOR dtl IN (SELECT SUM(idtl.dist_tsi) dist_tsi, SUM(idtl.dist_prem) dist_prem
                      FROM gipi_polbasic      pol
	                      ,giuw_pol_dist     dst
		                  ,giuw_itemds_dtl   idtl
                     WHERE 1=1
                     --link polbasic and giuw_pol_dist
                       AND pol.policy_id   = dst.policy_id
                     --link giuw_pol_dist and giuw_itemds_dtl
                       AND idtl.dist_no     = dst.dist_no
	                   AND idtl.line_cd     = p_line_cd
		  		     --filter gipi_polbasic
				       AND pol.line_cd      = p_line_cd
					   AND pol.subline_cd   = p_subline_cd
					   AND pol.iss_cd       = p_iss_cd
					   AND pol.issue_yy     = p_issue_yy
					   AND pol.pol_seq_no   = p_pol_seq_no
					   AND pol.renew_no     = p_renew_no
					   AND pol.pol_flag    IN ('1','2','3','4','X')
				     --filter giuw_pol_dist
				       AND dst.dist_flag    = '3'
					   AND dst.old_dist_no IS NULL
				     --filter giuw_itemds_dtl
				       AND idtl.share_cd    = vv_shares(shr)
				       AND idtl.item_no     = vv_item_no(itm))
	    LOOP
	      vv_dist_tsi(shr)  := dtl.dist_tsi;
   		  vv_dist_prem(shr) := dtl.dist_prem;
	    END LOOP;
	    IF v_redst_exists = 'Y' THEN
	       FOR b IN vv_redist_no.FIRST..vv_redist_no.LAST
		   LOOP
		     FOR dtls IN (SELECT idtl.dist_tsi dist_tsi, idtl.dist_prem dist_prem
                            FROM gipi_polbasic      pol
	                            ,giuw_pol_dist     dst
		                        ,giuw_itemds_dtl   idtl
                           WHERE 1=1
                           --link polbasic and giuw_pol_dist
                             AND pol.policy_id   = dst.policy_id
                           --link giuw_pol_dist and giuw_itemds_dtl
                             AND idtl.dist_no     = dst.dist_no
	                         AND idtl.line_cd     = p_line_cd
  				           --filter gipi_polbasic
				             AND pol.line_cd      = p_line_cd
					         AND pol.subline_cd   = p_subline_cd
					         AND pol.iss_cd       = p_iss_cd
					         AND pol.issue_yy     = p_issue_yy
					         AND pol.pol_seq_no   = p_pol_seq_no
					         AND pol.renew_no     = p_renew_no
					         AND pol.pol_flag    IN ('1','2','3','4','X')
				           --filter giuw_pol_dist
				             AND dst.dist_flag    = '3'
						     AND dst.old_dist_no  = vv_redist_no(b)
				           --filter giuw_itemds_dtl
				             AND idtl.share_cd    = vv_shares(shr)
				             AND idtl.item_no     = vv_item_no(itm)
						     ORDER BY dst.dist_no DESC)
		     LOOP
		       vv_dist_tsi(shr)  := NVL(vv_dist_tsi(shr),0)  + NVL(dtls.dist_tsi,0);
			   vv_dist_prem(shr) := NVL(vv_dist_prem(shr),0) + NVL(dtls.dist_prem,0);
			   EXIT;
		     END LOOP; --end of details
		   END LOOP; --end of vv_redist_no
	    END IF;  --end of if v_redst_exists
	      v_total_tsi  := NVL(v_total_tsi,0) +  NVL(vv_dist_tsi(shr),0);
	      v_total_prem := NVL(v_total_prem,0) +  NVL(vv_dist_prem(shr),0);
	  END LOOP;--end of loop per shares
	  --start inserton of extracted records to giuw_itemds_ext
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    IF (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NOT NULL)
	      OR (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NULL)
		  OR (vv_dist_tsi(shr) IS NULL AND vv_dist_prem(shr) IS NOT NULL) THEN
		   v_tsi_spct  := get_rate(vv_dist_tsi(shr),NVL(v_total_tsi,0));
	       v_prem_spct := get_rate(vv_dist_prem(shr),NVL(v_total_prem,0));
		   INSERT INTO giuw_itemds_ext
	         (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	          item_no, share_cd, trty_name, tsi_spct, dist_tsi, prem_spct,
	          dist_prem)
	       VALUES
	         (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	          vv_item_no(itm), vv_shares(shr), vv_trty_name(shr),
			  DECODE(v_tsi_spct,0,NULL,v_tsi_spct),
	          vv_dist_tsi(shr),DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(shr));
        END IF;
	  END LOOP;
    END LOOP; --end of loop per item_no
    COMMIT;

  /************************EXTRACTION ON GIUW_ITEMPERILDS_EXT************************************/
     DELETE FROM giuw_itemperilds_ext
      WHERE line_cd    = p_line_cd
	    AND subline_cd = p_subline_cd
	    AND iss_cd     = p_iss_cd
	    AND issue_yy   = p_issue_yy
	    AND pol_seq_no = p_pol_seq_no
	    AND renew_no   = p_renew_no;
    --initialize collection for use in extaracting records for giuw_itemds_ext
     vv_shares.DELETE;            vv_trty_name.DELETE;
     vv_dist_tsi.DELETE;          vv_dist_prem.DELETE;

	 --holds collection of distinct share of this policy per item
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
	       vv_shares, vv_trty_name
      FROM gipi_polbasic      pol
          ,giuw_pol_dist     dst
	      ,giuw_itemds_dtl   idtl
	      ,giis_dist_share   shr
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id = dst.policy_id
     --link giuw_pol_dist and giuw_itemds_dtl
       AND idtl.line_cd       = p_line_cd
       AND idtl.dist_no       = dst.dist_no
     --link giuw_itemds_dtl and giis_dist_share
       AND idtl.line_cd       = shr.line_cd
       AND idtl.share_cd      = shr.share_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3';

	SELECT DISTINCT p.peril_cd, p.peril_name
      BULK COLLECT INTO
	       vv_peril_cd, vv_peril_name
      FROM gipi_polbasic      pol
          ,giuw_pol_dist      dst
   	      ,giuw_itemperilds   prl
		  ,giis_peril         p
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id   = dst.policy_id
     --link giuw_pol_dist and giuw_itemds
       AND prl.dist_no     = dst.dist_no
	 --link giis_peril and giuw_itemperilds
	   AND p.line_cd       = prl.line_cd
	   AND p.peril_cd      = prl.peril_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
  	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3';

	FOR prl IN vv_peril_cd.FIRST..vv_peril_cd.LAST
	LOOP
	  --reset v_total_tsi and v_total_prem per item
   	  v_total_tsi := 0;                 v_total_prem := 0;
	  DBMS_OUTPUT.PUT_LINE('RESET');
	  vv_dist_tsi.DELETE;               vv_dist_prem.DELETE;
	  vv_dist_tsi.EXTEND(vv_shares.COUNT);
	  vv_dist_prem.EXTEND(vv_shares.COUNT);
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    FOR dtl IN (SELECT SUM(pdtl.dist_tsi) dist_tsi, SUM(pdtl.dist_prem) dist_prem
                      FROM gipi_polbasic          pol
	                      ,giuw_pol_dist          dst
		                  ,giuw_itemperilds_dtl   pdtl
                     WHERE 1=1
                     --link polbasic and giuw_pol_dist
                       AND pol.policy_id   = dst.policy_id
                     --link giuw_pol_dist and giuw_itemds_dtl
                       AND pdtl.dist_no     = dst.dist_no
	                   AND NVL(pdtl.line_cd,pdtl.line_cd) = pol.line_cd
		  		     --filter gipi_polbasic
				       AND pol.line_cd      = p_line_cd
					   AND pol.subline_cd   = p_subline_cd
					   AND pol.iss_cd       = p_iss_cd
					   AND pol.issue_yy     = p_issue_yy
					   AND pol.pol_seq_no   = p_pol_seq_no
					   AND pol.renew_no     = p_renew_no
					   AND pol.pol_flag    IN ('1','2','3','4','X')
				     --filter giuw_pol_dist
				       AND dst.dist_flag    = '3'
					   AND dst.old_dist_no IS NULL
				     --filter giuw_itemds_dtl
				       AND pdtl.share_cd    = vv_shares(shr)
				       AND pdtl.peril_cd    = vv_peril_cd(prl))
		LOOP
		  vv_dist_tsi(shr)  := dtl.dist_tsi;
   		  vv_dist_prem(shr) := dtl.dist_prem;
		END LOOP; --end of detail
		IF v_redst_exists = 'Y' THEN
	       FOR b IN vv_redist_no.FIRST..vv_redist_no.LAST
		   LOOP
		     FOR dtls IN (SELECT pdtl.dist_tsi dist_tsi, pdtl.dist_prem dist_prem
                            FROM gipi_polbasic          pol
	                            ,giuw_pol_dist          dst
		                        ,giuw_itemperilds_dtl   pdtl
                           WHERE 1=1
                           --link polbasic and giuw_pol_dist
                             AND pol.policy_id   = dst.policy_id
                           --link giuw_pol_dist and giuw_itemds_dtl
                             AND pdtl.dist_no     = dst.dist_no
	                         AND pdtl.line_cd     = p_line_cd
  				           --filter gipi_polbasic
				             AND pol.line_cd      = p_line_cd
					         AND pol.subline_cd   = p_subline_cd
					         AND pol.iss_cd       = p_iss_cd
					         AND pol.issue_yy     = p_issue_yy
					         AND pol.pol_seq_no   = p_pol_seq_no
					         AND pol.renew_no     = p_renew_no
					         AND pol.pol_flag    IN ('1','2','3','4','X')
				           --filter giuw_pol_dist
				             AND dst.dist_flag    = '3'
						     AND dst.old_dist_no  = vv_redist_no(b)
				           --filter giuw_itemds_dtl
				             AND pdtl.share_cd    = vv_shares(shr)
				             AND pdtl.peril_cd    = vv_peril_cd(prl)
						     ORDER BY dst.dist_no DESC)
		     LOOP
		       vv_dist_tsi(shr)  := NVL(vv_dist_tsi(shr),0)  + NVL(dtls.dist_tsi,0);
			   vv_dist_prem(shr) := NVL(vv_dist_prem(shr),0) + NVL(dtls.dist_prem,0);
			   EXIT;
		     END LOOP; --end of details
		   END LOOP; --end of loop for vv_redist_no
		END IF; --end if for if v_redist_exists
  		  v_total_tsi  := NVL(v_total_tsi,0) +  NVL(vv_dist_tsi(shr),0);
	      v_total_prem := NVL(v_total_prem,0) +  NVL(vv_dist_prem(shr),0);
	  END LOOP; --end of loop per share
	  --start inserton of extracted records to giuw_itemds_ext
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    IF (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NOT NULL)
	      OR (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NULL)
		  OR (vv_dist_tsi(shr) IS NULL AND vv_dist_prem(shr) IS NOT NULL) THEN
		   v_tsi_spct  := get_rate(vv_dist_tsi(shr),NVL(v_total_tsi,0));
	       v_prem_spct := get_rate(vv_dist_prem(shr),NVL(v_total_prem,0));
   	       INSERT INTO giuw_itemperilds_ext
	         (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	          peril_cd, peril_name, share_cd, trty_name, tsi_spct, dist_tsi, prem_spct,
	          dist_prem)
	       VALUES
	         (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	          vv_peril_cd(prl), vv_peril_name(prl),  vv_shares(shr), vv_trty_name(shr),
			  DECODE(v_tsi_spct,0,NULL,v_tsi_spct), vv_dist_tsi(shr),
			  DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(shr));
        END IF;
	  END LOOP;
	END LOOP; --end of loop per peril
  /*************************EXTRACTION ON GIRI_DISTFRPS_EXT************************************/
    DELETE FROM giri_distfrps_ext
     WHERE 1=1
       AND line_cd    = p_line_cd
       AND subline_cd = p_subline_cd
	   AND iss_cd     = p_iss_cd
	   AND issue_yy   = p_issue_yy
  	   AND pol_seq_no = p_pol_seq_no
	   AND renew_no   = p_renew_no;

    FOR rec IN (SELECT param_value_n
                  FROM giis_parameters
                 WHERE param_name = 'FACULTATIVE')
    LOOP
      v_facultative := rec.param_value_n;
      EXIT;
    END LOOP;
    FOR shr IN (SELECT tsi_spct
                  FROM giuw_policyds_ext
		  	     WHERE line_cd    = p_line_cd
			       AND subline_cd = p_subline_cd
				   AND iss_cd     = p_iss_cd
				   AND issue_yy   = p_issue_yy
				   AND pol_seq_no = p_pol_seq_no
				   AND renew_no   = p_renew_no
				   AND share_cd   = NVL(v_facultative,999))
    LOOP
      v_facul_share := shr.tsi_spct/100;
	  EXIT;
    END LOOP;
    SELECT  ri.ri_cd, ri.ri_sname, SUM(frps.ri_tsi_amt) ri_tsi_amt, SUM(frps.ri_prem_amt) ri_prem_amt
      BULK COLLECT INTO
	        vv_ri_cd, vv_ri_sname, vv_ri_tsi_amt, vv_ri_prem_amt
      FROM  giuw_pol_dist        dst
           ,giri_distfrps        dfr
  	       ,giri_frps_ri         frps
  	       ,gipi_polbasic        pol
		   ,giis_reinsurer       ri
     WHERE 1=1
     --filter gipi_polbasic
       AND pol.line_cd    = p_line_cd
       AND pol.subline_cd = p_subline_cd
       AND pol.iss_cd     = p_iss_cd
       AND pol.issue_yy   = p_issue_yy
       AND pol.pol_seq_no = p_pol_seq_no
       AND pol.renew_no   = p_renew_no
       AND pol.pol_flag   IN ('1','2','3','4','X')
     --link giuw_pol_dist and gipi_polbasic
       AND dst.policy_id  = pol.policy_id
     --filter giuw_pol_dist
       AND dst.dist_flag  = '3'
     --link giri_distfrps and giuw_pol_dist
       AND dst.dist_no    = dfr.dist_no
       AND dfr.line_cd    = p_line_cd
     --link giri_distfrps and giri_frps_ri
       AND dfr.line_cd    = frps.line_cd
       AND dfr.frps_yy    = frps.frps_yy
       AND dfr.frps_seq_no = frps.frps_seq_no
	   AND NVL(frps.reverse_sw,'N') <> 'Y'
     --link giis_reinsurer and giri_frps_ri
       AND ri.ri_cd       = frps.ri_cd
	   GROUP BY ri.ri_cd,ri.ri_sname;

    IF SQL%FOUND THEN
       SELECT  SUM(frps.ri_tsi_amt)
         INTO v_total_tsi
         FROM  giuw_pol_dist        dst
              ,giri_distfrps        dfr
  	          ,giri_frps_ri         frps
  	          ,gipi_polbasic        pol
		      ,giis_reinsurer       ri
        WHERE 1=1
        --filter gipi_polbasic
          AND pol.line_cd    = p_line_cd
          AND pol.subline_cd = p_subline_cd
          AND pol.iss_cd     = p_iss_cd
          AND pol.issue_yy   = p_issue_yy
          AND pol.pol_seq_no = p_pol_seq_no
          AND pol.renew_no   = p_renew_no
          AND pol.pol_flag   IN ('1','2','3','4','X')
        --link giuw_pol_dist and gipi_polbasic
          AND dst.policy_id  = pol.policy_id
        --filter giuw_pol_dist
          AND dst.dist_flag  = '3'
        --link giri_distfrps and giuw_pol_dist
          AND dst.dist_no    = dfr.dist_no
          AND dfr.line_cd    = p_line_cd
        --link giri_distfrps and giri_frps_ri
          AND dfr.line_cd    = frps.line_cd
          AND dfr.frps_yy    = frps.frps_yy
          AND dfr.frps_seq_no = frps.frps_seq_no
		  AND NVL(frps.reverse_sw,'N') <> 'Y'
        --link giis_reinsurer and giri_frps_ri
          AND ri.ri_cd       = frps.ri_cd;

	   FOR x IN vv_ri_cd.FIRST..vv_ri_cd.LAST
	   LOOP
	     v_ri_spct := get_rate(vv_ri_tsi_amt(x),NVL(v_total_tsi,0)) * NVL(v_facul_share,0);
	     INSERT INTO giri_distfrps_ext
	       (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
		    ri_cd, ri_sname, ri_shr_pct, ri_tsi_amt, ri_prem_amt)
	     VALUES
	       (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
		    vv_ri_cd(x), vv_ri_sname(x), DECODE(v_ri_spct,0,NULL,v_ri_spct),
		    vv_ri_tsi_amt(x),vv_ri_prem_amt(x));
	   END LOOP;
    END IF;
    COMMIT;
  END;

  /***************************************************************************************************************/
  /*                                  PROCEDURE SUMMARIZE_EFF_DATE                                               */
  /***************************************************************************************************************/

  PROCEDURE summarize_eff_distribution(p_line_cd VARCHAR2,
                                       p_subline_cd VARCHAR2,
     			                       p_iss_cd  VARCHAR2,
					                   p_issue_yy NUMBER,
					                   p_pol_seq_no NUMBER,
					                   p_renew_no NUMBER,
					                   p_date    DATE)

  AS
    v_total_tsi         giuw_pol_dist.tsi_amt%TYPE  := 0;
    v_total_prem        giuw_pol_dist.prem_amt%TYPE := 0;
    v_pol_exists        VARCHAR2(1) := 'N';
    v_redst_exists      VARCHAR2(1) := 'N';
	v_facultative       NUMBER;
	v_facul_share       NUMBER(12,9) := 0;

	--added by iris bordey 10.07.2003
	--to resolve ora 01476 (devisor = 0) on computation of share %
    v_tsi_spct			NUMBER(12,9) := 0;
    v_prem_spct			NUMBER(12,9) := 0;
	v_ri_spct			NUMBER(12,9) := 0;

    TYPE dist_tsi_tab      IS TABLE OF giuw_policyds_ext.dist_tsi%TYPE;
    TYPE dist_prem_tab     IS TABLE OF giuw_policyds_ext.dist_prem%TYPE;
    TYPE tsi_spct_tab      IS TABLE OF giuw_policyds_ext.tsi_spct%TYPE;
    TYPE prem_spct_tab     IS TABLE OF giuw_policyds_ext.prem_spct%TYPE;
    TYPE share_cd_tab      IS TABLE OF giuw_policyds_ext.share_cd%TYPE;
    TYPE trty_name_tab     IS TABLE OF giuw_policyds_ext.trty_name%TYPE;
    TYPE item_no_tab       IS TABLE OF giuw_itemds.item_no%TYPE;
	TYPE peril_cd_tab      IS TABLE OF giuw_itemperilds_ext.peril_cd%TYPE;
	TYPE peril_name_tab    IS TABLE OF giuw_itemperilds_ext.peril_name%TYPE;
	TYPE ri_cd_tab         IS TABLE OF giri_distfrps_ext.ri_cd%TYPE;
    TYPE ri_sname_tab      IS TABLE OF giri_distfrps_ext.ri_sname%TYPE;
    TYPE ri_tsi_tab        IS TABLE OF giri_distfrps_ext.ri_tsi_amt%TYPE;
    TYPE ri_prem_tab       IS TABLE OF giri_distfrps_ext.ri_prem_amt%TYPE;

    vv_dist_tsi            dist_tsi_tab;
    vv_dist_prem           dist_prem_tab;
    vv_tsi_spct            tsi_spct_tab;
    vv_prem_spct           prem_spct_tab;
    vv_shares              share_cd_tab;
    vv_trty_name           trty_name_tab;
    vv_item_no             item_no_tab;
	vv_ri_cd               ri_cd_tab;
    vv_ri_sname            ri_sname_tab;
    vv_ri_tsi_amt		   ri_tsi_tab;
    vv_ri_prem_amt         ri_prem_tab;
	vv_peril_cd            peril_cd_tab;
	vv_peril_name          peril_name_tab;
  BEGIN
     /*************************EXTRACTION ON GIUW_POLICDS_EXT**********************************/
    DELETE FROM giuw_policyds_ext
     WHERE line_cd    = p_line_cd
       AND subline_cd = p_subline_cd
	   AND iss_cd     = p_iss_cd
	   AND issue_yy   = p_issue_yy
	   AND pol_seq_no = p_pol_seq_no
	   AND renew_no   = p_renew_no;

    --stores a collection of distinct share_cd and trty_names that this policy have
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
          vv_shares, vv_trty_name
    FROM  gipi_polbasic      pol
         ,giuw_pol_dist      dst
	     ,giuw_policyds_dtl  pdtl
	     ,giis_dist_share    shr
   WHERE 1=1
   --link polbasic and giuw_pol_dist
     AND pol.policy_id  = dst.policy_id
   --link giuw_pol_dist and giuw_policyds_dtl
     AND pdtl.dist_no   = dst.dist_no
     AND pdtl.line_cd   = p_line_cd
   --link giuw_policyds_dtl and giis_dist_share
     AND pdtl.line_cd   = shr.line_cd
     AND pdtl.share_cd   = shr.share_cd
   --filter gipi_polbasic
     AND pol.line_cd    = p_line_cd
     AND pol.subline_cd = p_subline_cd
     AND pol.iss_cd     = p_iss_cd
     AND pol.issue_yy   = p_issue_yy
     AND pol.pol_seq_no = p_pol_seq_no
     AND pol.renew_no   = p_renew_no
     AND pol.pol_flag   IN ('1','2','3','4','X')
   --filter giuw_pol_dist
     AND dst.dist_flag  = '3'
     AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
     AND TRUNC(dst.expiry_date) >= TRUNC(p_date);

     --initialize collection
    vv_dist_tsi  := dist_tsi_tab();
    vv_dist_prem := dist_prem_tab();
    vv_dist_tsi.EXTEND(vv_shares.COUNT);
    vv_dist_prem.EXTEND(vv_shares.COUNT);

    FOR x IN vv_shares.FIRST..vv_shares.LAST
    LOOP
      FOR dtls IN (SELECT shr.share_cd, shr.trty_name, SUM(pdtl.dist_tsi) dist_tsi, SUM(pdtl.dist_prem) dist_prem
                     FROM gipi_polbasic       pol
                         ,giuw_pol_dist      dst
                         ,giuw_policyds_dtl  pdtl
   	                     ,giis_dist_share    shr
                    WHERE 1=1
                    --link polbasic and giuw_pol_dist
                      AND pol.policy_id  = dst.policy_id
                    --LINK giuw_pol_dist AND giuw_policyds_dtl
                      AND pdtl.dist_no   = dst.dist_no
                      AND pdtl.line_cd   = p_line_cd
                    --link giuw_policyds_dtl and giis_dist_share
                      AND pdtl.line_cd   = shr.line_cd
                      AND pdtl.share_cd  = shr.share_cd
                    --filter gipi_polbasic
                      AND pol.line_cd    = p_line_cd
                      AND pol.subline_cd = p_subline_cd
                      AND pol.iss_cd     = p_iss_cd
                      AND pol.issue_yy   = p_issue_yy
                      AND pol.pol_seq_no = p_pol_seq_no
                      AND pol.renew_no   = p_renew_no
                      AND pol.pol_flag   IN ('1','2','3','4','X')
                    --filter giuw_pol_dist
                      AND dst.dist_flag  = '3'
	  	  			  AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
                      AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
  					  AND pdtl.share_cd  = vv_shares(x)
                    GROUP BY shr.share_cd, shr.trty_name)
  	  LOOP
	    vv_dist_tsi(x)  := dtls.dist_tsi;
	    vv_dist_prem(x) := dtls.dist_prem;
  	  END LOOP;
	  v_total_tsi  := NVL(v_total_tsi,0)  + NVL(vv_dist_tsi(x),0);
	  v_total_prem := NVL(v_total_prem,0) + NVL(vv_dist_prem(x),0);
    END LOOP; --end of vv_shares

    --start insertion of records to guiw_policyds_ext
    FOR x IN vv_shares.FIRST..vv_shares.LAST
    LOOP
	  v_tsi_spct  := get_rate(vv_dist_tsi(x),NVL(v_total_tsi,0));
      v_prem_spct := get_rate(vv_dist_prem(x),NVL(v_total_prem,0));
      INSERT INTO giuw_policyds_ext
	    (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	     share_cd, trty_name, tsi_spct, dist_tsi, prem_spct, dist_prem)
  	  VALUES
	    (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	     vv_shares(x), vv_trty_name(x), DECODE(v_tsi_spct,0,NULL,v_tsi_spct), vv_dist_tsi(x),
	    DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(x));
    END LOOP;

    /************************EXTRACTION ON GIUW_ITEMDS_EXT************************************/
    DELETE FROM giuw_itemds_ext
      WHERE line_cd    = p_line_cd
	    AND subline_cd = p_subline_cd
	    AND iss_cd     = p_iss_cd
	    AND issue_yy   = p_issue_yy
	    AND pol_seq_no = p_pol_seq_no
	    AND renew_no   = p_renew_no;

    --initialize collection for use in extaracting records for giuw_itemds_ext
     vv_shares.DELETE;            vv_trty_name.DELETE;
     vv_dist_tsi.DELETE;          vv_dist_prem.DELETE;

    --holds collection of distinct share of this policy per item
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
	       vv_shares, vv_trty_name
      FROM gipi_polbasic      pol
           ,giuw_pol_dist     dst
	       ,giuw_itemds_dtl   idtl
	       ,giis_dist_share   shr
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id = dst.policy_id
     --link giuw_pol_dist and giuw_itemds_dtl
       AND idtl.line_cd       = p_line_cd
       AND idtl.dist_no       = dst.dist_no
     --link giuw_itemds_dtl and giis_dist_share
       AND idtl.line_cd       = shr.line_cd
       AND idtl.share_cd      = shr.share_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
	   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
       AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3';

  	 --holds collection of distinct item no
    SELECT DISTINCT itm.item_no
      BULK COLLECT INTO
	       vv_item_no
      FROM gipi_polbasic      pol
          ,giuw_pol_dist      dst
	      ,giuw_itemds        itm
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id   = dst.policy_id
     --link giuw_pol_dist and giuw_itemds
       AND itm.dist_no     = dst.dist_no
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
       AND dst.dist_flag      = '3'
	   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
       AND TRUNC(dst.expiry_date) >= TRUNC(p_date);

    FOR itm IN vv_item_no.FIRST..vv_item_no.LAST
    LOOP
      --reset v_total_tsi and v_total_prem per item
      v_total_tsi := 0;                 v_total_prem := 0;
	  DBMS_OUTPUT.PUT_LINE('RESET');
  	  vv_dist_tsi.DELETE;               vv_dist_prem.DELETE;
	  vv_dist_tsi.EXTEND(vv_shares.COUNT);
	  vv_dist_prem.EXTEND(vv_shares.COUNT);
      FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    FOR dtl IN (SELECT SUM(idtl.dist_tsi) dist_tsi, SUM(idtl.dist_prem) dist_prem
                      FROM gipi_polbasic      pol
	                      ,giuw_pol_dist     dst
		                  ,giuw_itemds_dtl   idtl
                     WHERE 1=1
                     --link polbasic and giuw_pol_dist
                       AND pol.policy_id   = dst.policy_id
                     --link giuw_pol_dist and giuw_itemds_dtl
                       AND idtl.dist_no     = dst.dist_no
	                   AND idtl.line_cd     = p_line_cd
				     --filter gipi_polbasic
				       AND pol.line_cd      = p_line_cd
					   AND pol.subline_cd   = p_subline_cd
					   AND pol.iss_cd       = p_iss_cd
					   AND pol.issue_yy     = p_issue_yy
					   AND pol.pol_seq_no   = p_pol_seq_no
					   AND pol.renew_no     = p_renew_no
					   AND pol.pol_flag    IN ('1','2','3','4','X')
				     --filter giuw_pol_dist
				       AND dst.dist_flag    = '3'
					   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
                       AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
				     --filter giuw_itemds_dtl
				       AND idtl.share_cd    = vv_shares(shr)
				       AND idtl.item_no     = vv_item_no(itm))
	    LOOP
	      vv_dist_tsi(shr)  := dtl.dist_tsi;
   		  vv_dist_prem(shr) := dtl.dist_prem;
	    END LOOP;
	    v_total_tsi  := NVL(v_total_tsi,0)  +  NVL(vv_dist_tsi(shr),0);
	    v_total_prem := NVL(v_total_prem,0) +  NVL(vv_dist_prem(shr),0);
      END LOOP;--end of loop per shares
	  --start inserton of extracted records to giuw_itemds_ext
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    IF (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NOT NULL)
	      OR (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NULL)
		  OR (vv_dist_tsi(shr) IS NULL AND vv_dist_prem(shr) IS NOT NULL) THEN
		   v_tsi_spct  := get_rate(vv_dist_tsi(shr),NVL(v_total_tsi,0));
	       v_prem_spct := get_rate(vv_dist_prem(shr),NVL(v_total_prem,0));
   	       INSERT INTO giuw_itemds_ext
	         (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	          item_no, share_cd, trty_name, tsi_spct, dist_tsi, prem_spct,
	          dist_prem)
	       VALUES
	         (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	          vv_item_no(itm), vv_shares(shr), vv_trty_name(shr),
			   DECODE(v_tsi_spct,0,NULL,v_tsi_spct),
	          vv_dist_tsi(shr), DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(shr));
        END IF;
	  END LOOP;
    END LOOP; --end of loop per item_no
    COMMIT;

	/************************EXTRACTION ON GIUW_ITEMPERILDS_EXT************************************/
	DELETE FROM giuw_itemperilds_ext
      WHERE line_cd    = p_line_cd
	    AND subline_cd = p_subline_cd
	    AND iss_cd     = p_iss_cd
	    AND issue_yy   = p_issue_yy
	    AND pol_seq_no = p_pol_seq_no
	    AND renew_no   = p_renew_no;

	--initialize collection for use in extaracting records for giuw_itemds_ext
     vv_shares.DELETE;            vv_trty_name.DELETE;
     vv_dist_tsi.DELETE;          vv_dist_prem.DELETE;

	 --holds collection of distinct share of this policy per item
    SELECT DISTINCT shr.share_cd, shr.trty_name
      BULK COLLECT INTO
	       vv_shares, vv_trty_name
      FROM gipi_polbasic      pol
          ,giuw_pol_dist     dst
	      ,giuw_itemds_dtl   idtl
	      ,giis_dist_share   shr
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id = dst.policy_id
     --link giuw_pol_dist and giuw_itemds_dtl
       AND idtl.line_cd       = p_line_cd
       AND idtl.dist_no       = dst.dist_no
     --link giuw_itemds_dtl and giis_dist_share
       AND idtl.line_cd       = shr.line_cd
       AND idtl.share_cd      = shr.share_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
	   AND TRUNC(dst.eff_date)   <= TRUNC(p_date)
	   AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
       AND dst.dist_flag      = '3';

	SELECT DISTINCT p.peril_cd, p.peril_name
      BULK COLLECT INTO
	       vv_peril_cd, vv_peril_name
      FROM gipi_polbasic      pol
          ,giuw_pol_dist      dst
   	      ,giuw_itemperilds   prl
		  ,giis_peril         p
     WHERE 1=1
     --link polbasic and giuw_pol_dist
       AND pol.policy_id   = dst.policy_id
     --link giuw_pol_dist and giuw_itemds
       AND prl.dist_no     = dst.dist_no
	 --link giis_peril and giuw_itemperilds
	   AND p.line_cd       = prl.line_cd
	   AND p.peril_cd      = prl.peril_cd
     --filter gipi_polbasic
       AND pol.line_cd        = p_line_cd
       AND pol.subline_cd     = p_subline_cd
       AND pol.iss_cd         = p_iss_cd
       AND pol.issue_yy       = p_issue_yy
  	   AND pol.pol_seq_no     = p_pol_seq_no
       AND pol.renew_no       = p_renew_no
       AND pol.pol_flag      IN ('1','2','3','4','X')
     --filter giuw_pol_dist
	   AND TRUNC(dst.eff_date)   <= TRUNC(p_date)
	   AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
       AND dst.dist_flag      = '3';

	FOR prl IN vv_peril_cd.FIRST..vv_peril_cd.LAST
	LOOP
	  --reset v_total_tsi and v_total_prem per item
   	  v_total_tsi := 0;                 v_total_prem := 0;
	  DBMS_OUTPUT.PUT_LINE('RESET');
	  vv_dist_tsi.DELETE;               vv_dist_prem.DELETE;
	  vv_dist_tsi.EXTEND(vv_shares.COUNT);
	  vv_dist_prem.EXTEND(vv_shares.COUNT);
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    FOR dtl IN (SELECT SUM(pdtl.dist_tsi) dist_tsi, SUM(pdtl.dist_prem) dist_prem
                      FROM gipi_polbasic          pol
	                      ,giuw_pol_dist          dst
		                  ,giuw_itemperilds_dtl   pdtl
                     WHERE 1=1
                     --link polbasic and giuw_pol_dist
                       AND pol.policy_id   = dst.policy_id
                     --link giuw_pol_dist and giuw_itemds_dtl
                       AND pdtl.dist_no     = dst.dist_no
	                   AND NVL(pdtl.line_cd,pdtl.line_cd) = pol.line_cd
		  		     --filter gipi_polbasic
				       AND pol.line_cd      = p_line_cd
					   AND pol.subline_cd   = p_subline_cd
					   AND pol.iss_cd       = p_iss_cd
					   AND pol.issue_yy     = p_issue_yy
					   AND pol.pol_seq_no   = p_pol_seq_no
					   AND pol.renew_no     = p_renew_no
					   AND pol.pol_flag    IN ('1','2','3','4','X')
				     --filter giuw_pol_dist
					   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
                       AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
				       AND dst.dist_flag    = '3'
				     --filter giuw_itemds_dtl
				       AND pdtl.share_cd    = vv_shares(shr)
				       AND pdtl.peril_cd    = vv_peril_cd(prl))
		LOOP
		  vv_dist_tsi(shr)  := dtl.dist_tsi;
   		  vv_dist_prem(shr) := dtl.dist_prem;
		END LOOP; --end of detail
	  v_total_tsi  := NVL(v_total_tsi,0)  + NVL(vv_dist_tsi(shr),0);
	  v_total_prem := NVL(v_total_prem,0) + NVL(vv_dist_prem(shr),0);
	  END LOOP; --end of share
	  --start inserton of extracted records to giuw_itemds_ext
	  FOR shr IN vv_shares.FIRST..vv_shares.LAST
	  LOOP
	    IF (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NOT NULL)
	      OR (vv_dist_tsi(shr) IS NOT NULL AND vv_dist_prem(shr) IS NULL)
		  OR (vv_dist_tsi(shr) IS NULL AND vv_dist_prem(shr) IS NOT NULL) THEN
		   v_tsi_spct  := get_rate(vv_dist_tsi(shr),NVL(v_total_tsi,0));
	       v_prem_spct := get_rate(vv_dist_prem(shr),NVL(v_total_prem,0));
   	       INSERT INTO giuw_itemperilds_ext
	         (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
	          peril_cd, peril_name, share_cd, trty_name, tsi_spct, dist_tsi, prem_spct,
	          dist_prem)
	       VALUES
	         (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	          vv_peril_cd(prl), vv_peril_name(prl),  vv_shares(shr), vv_trty_name(shr),
			  DECODE(v_tsi_spct,0,NULL,v_tsi_spct), vv_dist_tsi(shr),
			  DECODE(v_prem_spct,0,NULL,v_prem_spct), vv_dist_prem(shr));
        END IF;
	  END LOOP;
	END LOOP; --end for loop in peril
	/*************************EXTRACTION ON GIRI_DISTFRPS_EXT************************************/
    DELETE FROM giri_distfrps_ext
     WHERE 1=1
       AND line_cd    = p_line_cd
       AND subline_cd = p_subline_cd
	   AND iss_cd     = p_iss_cd
	   AND issue_yy   = p_issue_yy
  	   AND pol_seq_no = p_pol_seq_no
	   AND renew_no   = p_renew_no;

    FOR rec IN (SELECT param_value_n
                  FROM giis_parameters
                 WHERE param_name = 'FACULTATIVE')
    LOOP
      v_facultative := rec.param_value_n;
      EXIT;
    END LOOP;
    FOR shr IN (SELECT tsi_spct
                  FROM giuw_policyds_ext
		  	     WHERE line_cd    = p_line_cd
			       AND subline_cd = p_subline_cd
				   AND iss_cd     = p_iss_cd
				   AND issue_yy   = p_issue_yy
				   AND pol_seq_no = p_pol_seq_no
				   AND renew_no   = p_renew_no
				   AND share_cd   = NVL(v_facultative,999))
    LOOP
      v_facul_share := shr.tsi_spct/100;
	  EXIT;
    END LOOP;
    SELECT  ri.ri_cd, ri.ri_sname, SUM(frps.ri_tsi_amt) ri_tsi_amt, SUM(frps.ri_prem_amt) ri_prem_amt
      BULK COLLECT INTO
	        vv_ri_cd, vv_ri_sname, vv_ri_tsi_amt, vv_ri_prem_amt
      FROM  giuw_pol_dist        dst
           ,giri_distfrps        dfr
  	       ,giri_frps_ri         frps
  	       ,gipi_polbasic        pol
		   ,giis_reinsurer       ri
     WHERE 1=1
     --filter gipi_polbasic
       AND pol.line_cd    = p_line_cd
       AND pol.subline_cd = p_subline_cd
       AND pol.iss_cd     = p_iss_cd
       AND pol.issue_yy   = p_issue_yy
       AND pol.pol_seq_no = p_pol_seq_no
       AND pol.renew_no   = p_renew_no
       AND pol.pol_flag   IN ('1','2','3','4','X')
     --link giuw_pol_dist and gipi_polbasic
       AND dst.policy_id  = pol.policy_id
     --filter giuw_pol_dist
       AND dst.dist_flag  = '3'
	   AND TRUNC(dst.eff_date)    <= TRUNC(p_date)
	   AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
     --link giri_distfrps and giuw_pol_dist
       AND dst.dist_no    = dfr.dist_no
       AND dfr.line_cd    = p_line_cd
     --link giri_distfrps and giri_frps_ri
       AND dfr.line_cd    = frps.line_cd
       AND dfr.frps_yy    = frps.frps_yy
       AND dfr.frps_seq_no = frps.frps_seq_no
	   AND NVL(frps.reverse_sw,'N') <> 'Y'
     --link giis_reinsurer and giri_frps_ri
       AND ri.ri_cd       = frps.ri_cd
	   GROUP BY ri.ri_cd,ri.ri_sname;

    IF SQL%FOUND THEN
       SELECT  SUM(frps.ri_tsi_amt)
         INTO v_total_tsi
         FROM  giuw_pol_dist        dst
              ,giri_distfrps        dfr
  	          ,giri_frps_ri         frps
  	          ,gipi_polbasic        pol
		      ,giis_reinsurer       ri
        WHERE 1=1
        --filter gipi_polbasic
          AND pol.line_cd    = p_line_cd
          AND pol.subline_cd = p_subline_cd
          AND pol.iss_cd     = p_iss_cd
          AND pol.issue_yy   = p_issue_yy
          AND pol.pol_seq_no = p_pol_seq_no
          AND pol.renew_no   = p_renew_no
          AND pol.pol_flag   IN ('1','2','3','4','X')
        --link giuw_pol_dist and gipi_polbasic
          AND dst.policy_id  = pol.policy_id
        --filter giuw_pol_dist
          AND dst.dist_flag  = '3'
		  AND TRUNC(dst.eff_date) <= TRUNC(p_date)
		  AND TRUNC(dst.expiry_date) >= TRUNC(p_date)
        --link giri_distfrps and giuw_pol_dist
          AND dst.dist_no    = dfr.dist_no
          AND dfr.line_cd    = p_line_cd
        --link giri_distfrps and giri_frps_ri
          AND dfr.line_cd    = frps.line_cd
          AND dfr.frps_yy    = frps.frps_yy
          AND dfr.frps_seq_no = frps.frps_seq_no
		  AND NVL(frps.reverse_sw,'N') <> 'Y'
        --link giis_reinsurer and giri_frps_ri
          AND ri.ri_cd       = frps.ri_cd;

	   FOR x IN vv_ri_cd.FIRST..vv_ri_cd.LAST
	   LOOP
	     v_ri_spct := get_rate(vv_ri_tsi_amt(x),NVL(v_total_tsi,0)) * NVL(v_facul_share,0);
	     INSERT INTO giri_distfrps_ext
	       (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
		    ri_cd, ri_sname, ri_shr_pct, ri_tsi_amt, ri_prem_amt)
	     VALUES
	       (p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
		    vv_ri_cd(x), vv_ri_sname(x), DECODE(v_ri_spct,0, NULL, v_ri_spct),
		    vv_ri_tsi_amt(x),vv_ri_prem_amt(x));
	   END LOOP;
    END IF;
    COMMIT;
  END;
  FUNCTION get_rate(p_numerator  NUMBER, p_denominator NUMBER)
  RETURN NUMBER IS
    v_rate    NUMBER(12,9) := 0;
  BEGIN
    IF p_denominator = 0 THEN
	   v_rate := 0;
	ELSE
	   v_rate := p_numerator / p_denominator * 100;
	END IF;
	RETURN(v_rate);
  END;
END summarize_distribution;
/



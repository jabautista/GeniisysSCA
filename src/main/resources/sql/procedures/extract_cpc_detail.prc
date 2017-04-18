DROP PROCEDURE CPI.EXTRACT_CPC_DETAIL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Cpc_Detail (p_year    NUMBER) AS
  TYPE intm_no_tab     			 IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE parent_intm_no_tab     	 IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE policy_id_tab   			 IS TABLE OF gipi_polbasic.policy_id%TYPE;
  TYPE peril_cd_tab    			 IS TABLE OF GIIS_PERIL.peril_cd%TYPE;
  TYPE line_cd_tab     			 IS TABLE OF GIIS_LINE.line_cd%TYPE;
  TYPE prem_amt_tab   			 IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE comm_amt_tab   			 IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE tarf_cd_tab				 IS TABLE OF GIAC_CPC_DTL.tarf_cd%TYPE;
  TYPE tran_id_tab      		 IS TABLE OF GIAC_CPC_DTL.tran_id%TYPE;
  TYPE prem_seq_no_tab     		 IS TABLE OF GIAC_CPC_DTL.prem_seq_no%TYPE;
  TYPE tran_doc_tab     		 IS TABLE OF GIAC_CPC_DTL.tran_doc%TYPE;
  TYPE tran_date_tab     		 IS TABLE OF GIAC_CPC_DTL.tran_date%TYPE;
  vv_intm_no					 intm_no_tab;
  vv_parent_intm_no				 parent_intm_no_tab;
  vv_policy_id					 policy_id_tab;
  vv_peril_cd					 peril_cd_tab;
  vv_line_cd           			 line_cd_tab;
  vv_prem_amt					 prem_amt_tab;
  vv_comm_amt 					 comm_amt_tab;
  vv_tarf_cd 					 tarf_cd_tab;
  vv_tran_id					 tran_id_tab;
  vv_prem_seq_no				 prem_seq_no_tab;
  vv_tran_doc					 tran_doc_tab;
  vv_tran_date					 tran_date_tab;
  v_insert                       VARCHAR2(1) := 'N';
BEGIN --main
  DELETE GIAC_CPC_DTL
   WHERE tran_year = p_year;
  --extract motor car paid premium
  BEGIN
    SELECT d.intrmdry_intm_no,
	       h.parent_intm_no,
	       g.line_cd,
		   d.peril_cd peril,
		   NULL tariff,
           d.policy_id,
		   f.gacc_tran_id,
		   e.iss_cd||'-'||TO_CHAR(e.prem_seq_no) prem_no,
 	       f.transaction_date,
		   f.transaction_doc,
           DECODE(f.premium_amt,0,0,f.premium_amt*DECODE(e.prem_amt,0,1,(d.premium_amt/e.prem_amt))) peril_prem ,
           DECODE(d.commission_amt,0,0, (f.premium_amt* DECODE(e.prem_amt,0,1,(d.premium_amt/e.prem_amt)))* (d.commission_rt/100)) peril_comm
      BULK COLLECT
      INTO vv_intm_no,
		   vv_parent_intm_no,
		   vv_line_cd,
		   vv_peril_cd,
           vv_tarf_cd,
		   vv_policy_id,
		   vv_tran_id,
           vv_prem_seq_no,
		   vv_tran_date,
           vv_tran_doc,
           vv_prem_amt,
           vv_comm_amt
      FROM gipi_polbasic g, GIPI_COMM_INV_PERIL d,
           (SELECT b.premium_amt, b.gacc_tran_id, b.b140_iss_cd, b.b140_prem_seq_no,
	               NVL(j.or_date,c.tran_date) transaction_date,
		 		   DECODE(c.tran_class,'COL',j.or_pref_suf||'-'||j.or_no,
			                           'JV'   ,'JV-'||c.jv_no,NULL) transaction_doc
              FROM giac_direct_prem_collns b,giac_acctrans c, giac_order_of_payts j
             WHERE b.gacc_tran_id+0=c.tran_id
	 	 	   AND b.gacc_tran_id+0=j.gacc_tran_id(+)
               AND b.gacc_tran_id>0
               AND c.tran_flag<>'D'
               AND TO_CHAR(NVL(j.or_date,c.tran_date), 'YYYY') = p_year
               AND NOT EXISTS (SELECT x.gacc_tran_id
                                 FROM giac_reversals x,
                                      giac_acctrans y
                                WHERE x.reversing_tran_id=y.tran_id
                                  AND y.tran_flag<>'D'
                                  AND TO_CHAR(Y.Tran_date, 'YYYY') = p_year
                                  AND x.gacc_tran_id=b.gacc_tran_id)) f,
	       gipi_comm_invoice h, GIIS_LINE x, GIIS_SUBLINE y, GIIS_PERIL z,
           (SELECT iss_cd, prem_seq_no, prem_amt, policy_id
              FROM gipi_invoice a
             WHERE prem_amt <= (SELECT SUM(premium_amt) prem_colln
                                  FROM giac_direct_prem_collns b,giac_acctrans c, giac_order_of_payts j
                                 WHERE b.gacc_tran_id+0=c.tran_id
					               AND b.gacc_tran_id+0=j.gacc_tran_id(+)
                                   AND b.b140_iss_cd= a.iss_cd
                                   AND b.b140_prem_seq_no = a.prem_seq_no
                                   AND b.gacc_tran_id>0
                                   AND c.tran_flag<>'D'
                                   AND TO_CHAR(NVL(j.or_date,c.tran_date), 'YYYY') = p_year
                                   AND NOT EXISTS (SELECT x.gacc_tran_id
                                                     FROM giac_reversals x,
                                                          giac_acctrans y
                                                    WHERE x.reversing_tran_id=y.tran_id
                                                      AND y.tran_flag<>'D'
                                   AND TO_CHAR(Y.Tran_date, 'YYYY') = p_year
                                   AND x.gacc_tran_id=b.gacc_tran_id))) e
     WHERE g.pol_flag <> '5'
       AND g.policy_id = e.policy_id
       AND g.policy_id = d.policy_id
       AND e.policy_id = d.policy_id
       AND e.iss_cd = d.iss_cd
       AND e.prem_seq_no = d.prem_seq_no
       AND e.iss_cd = f.b140_iss_cd
       AND h.policy_id = d.policy_id
       AND h.iss_cd = d.iss_cd
       AND h.prem_seq_no = d.prem_seq_no
       AND h.intrmdry_intm_no = d.intrmdry_intm_no
       AND e.prem_seq_no = f.b140_prem_seq_no
       AND g.line_cd <> Giacp.V('FIRE_LINE_CD')
	   AND g.line_cd = x.line_cd
	   AND NVL(x.prof_comm_tag, 'N') = 'Y'
  	   AND g.line_cd = y.line_cd
  	   AND g.subline_cd = y.subline_cd
	   AND NVL(y.prof_comm_tag, 'N') = 'Y'
   	   AND g.line_cd = z.line_cd
  	   AND d.peril_cd = z.peril_cd
	   AND NVL(z.prof_comm_tag, 'N') = 'Y';
    --insert record on table giac_cpc_dtl
    IF SQL%FOUND THEN
       FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
         INSERT INTO GIAC_CPC_DTL
		   (intm_no,             parent_intm_no,         policy_id,
            peril_cd,            line_cd,                prem_amt,
            comm_amt,            tarf_cd,                tran_id,
            prem_seq_no,         tran_doc,               tran_date,
			tran_year,           user_id,                last_update)
   	      VALUES
           (vv_intm_no(i),       vv_parent_intm_no(i),   vv_policy_id(i),
            vv_peril_cd(i),      vv_line_cd(i),          vv_prem_amt(i),
            vv_comm_amt(i),      vv_tarf_cd(i),          vv_tran_id(i),
            vv_prem_seq_no(i),   vv_tran_doc(i),         vv_tran_date(i),
			p_year,              USER,                   SYSDATE);
       --after insert refresh arrays by deleting data
       vv_intm_no.DELETE;
	   vv_parent_intm_no.DELETE;
	   vv_line_cd.DELETE;
	   vv_peril_cd.DELETE;
       vv_tarf_cd.DELETE;
 	   vv_policy_id.DELETE;
	   vv_tran_id.DELETE;
	   vv_prem_seq_no.DELETE;
	   vv_tran_date.DELETE;
	   vv_tran_doc.DELETE;
	   vv_prem_amt.DELETE;
	   vv_comm_amt.DELETE;
    END IF;
  END;--retrieve all records for MOTOR CAR
  --extract paid premium for FIRE
  BEGIN
    FOR get_fire IN (
      SELECT line_cd
        FROM GIIS_LINE
	   WHERE line_cd = Giacp.V('FIRE_LINE_CD')
	     AND NVL(prof_comm_tag, 'N') = 'Y')
	LOOP
      SELECT d.intrmdry_intm_no,
	         h.parent_intm_no,
	         g.line_cd,
		     NULL peril,
		     SUBSTR(iii.tarf_cd,1,1) tariff,
             d.policy_id,
		     f.gacc_tran_id,
		     e.iss_cd||'-'||TO_CHAR(e.prem_seq_no) prem_no,
 	         f.transaction_date,
		     f.transaction_doc,
             SUM(DECODE(f.premium_amt,0,0,(f.premium_amt* DECODE(e.prem_amt,0,1,(ii.prem_amt/e.prem_amt))) *( DECODE(dd.prem_amt,0,1,(d.premium_amt/dd.prem_amt))))) peril_prem ,
             SUM(DECODE(d.commission_amt,0,0, ((f.premium_amt*DECODE(e.prem_amt,0,1,(ii.prem_amt/e.prem_amt))) *( DECODE(dd.prem_amt,0,1,(d.premium_amt/dd.prem_amt))))* (d.commission_rt/100))) peril_comm
        BULK COLLECT
        INTO vv_intm_no,
	  	     vv_parent_intm_no,
		     vv_line_cd,
		     vv_peril_cd,
             vv_tarf_cd,
		     vv_policy_id,
		     vv_tran_id,
             vv_prem_seq_no,
		     vv_tran_date,
             vv_tran_doc,
             vv_prem_amt,
             vv_comm_amt
        FROM gipi_polbasic g, GIPI_COMM_INV_PERIL d,GIPI_INVPERIL dd,
             gipi_item i, GIPI_ITMPERIL ii, gipi_fireitem iii,
             (SELECT b.premium_amt, b.gacc_tran_id, b.b140_iss_cd, b.b140_prem_seq_no,
	                 NVL(j.or_date,c.tran_date) transaction_date,
		 		     DECODE(c.tran_class,'COL',j.or_pref_suf||'-'||j.or_no,
			                             'JV'   ,'JV-'||c.jv_no,NULL) transaction_doc
                FROM giac_direct_prem_collns b,giac_acctrans c, giac_order_of_payts j
               WHERE b.gacc_tran_id+0=c.tran_id
	   	 	     AND b.gacc_tran_id+0=j.gacc_tran_id(+)
                 AND b.gacc_tran_id>0
                 AND c.tran_flag<>'D'
                 AND TO_CHAR(NVL(j.or_date,c.tran_date), 'YYYY') = p_year
                 AND NOT EXISTS (SELECT x.gacc_tran_id
                                   FROM giac_reversals x,
                                        giac_acctrans y
                                  WHERE x.reversing_tran_id=y.tran_id
                                    AND y.tran_flag<>'D'
                                    AND TO_CHAR(Y.Tran_date, 'YYYY') = p_year
                                    AND x.gacc_tran_id=b.gacc_tran_id)) f,
	         gipi_comm_invoice h,GIIS_SUBLINE y, giis_peril z,
             (SELECT iss_cd, prem_seq_no, prem_amt, policy_id,item_grp
                FROM gipi_invoice a
               WHERE prem_amt <= (SELECT SUM(premium_amt) prem_colln
                                    FROM giac_direct_prem_collns b,giac_acctrans c, giac_order_of_payts j
                                   WHERE b.gacc_tran_id+0=c.tran_id
					                 AND b.gacc_tran_id+0=j.gacc_tran_id(+)
                                     AND b.b140_iss_cd= a.iss_cd
                                     AND b.b140_prem_seq_no = a.prem_seq_no
                                     AND b.gacc_tran_id>0
                                     AND c.tran_flag<>'D'
                                     AND TO_CHAR(NVL(j.or_date,c.tran_date), 'YYYY') = p_year
                                     AND NOT EXISTS (SELECT x.gacc_tran_id
                                                       FROM giac_reversals x,
                                                            giac_acctrans y
                                                      WHERE x.reversing_tran_id=y.tran_id
                                                        AND y.tran_flag<>'D'
                                     AND TO_CHAR(Y.Tran_date, 'YYYY') = p_year
                                     AND x.gacc_tran_id=b.gacc_tran_id))) e
       WHERE g.pol_flag <> '5'
         AND g.policy_id = e.policy_id
  	     AND e.policy_id = i.policy_id
  	     AND g.policy_id = i.policy_id
  	     AND e.item_grp  = i.item_grp
  	     AND ii.peril_cd = d.peril_cd
  	     AND i.policy_id = ii.policy_id
  	     AND i.item_no = ii.item_no
  	     AND i.policy_id = iii.policy_id
  	     AND i.item_no = iii.item_no
  	     AND g.policy_id = d.policy_id
  	     AND e.policy_id = d.policy_id
  	     AND e.iss_cd = d.iss_cd
  	     AND e.prem_seq_no = d.prem_seq_no
  	     AND e.iss_cd = f.b140_iss_cd
  	     AND dd.iss_cd = d.iss_cd
  	     AND dd.prem_seq_no = d.prem_seq_no
  	     AND dd.peril_cd = d.peril_cd
  	     AND h.policy_id = d.policy_id
  	     AND h.iss_cd = d.iss_cd
  	     AND h.prem_seq_no = d.prem_seq_no
  	     AND h.intrmdry_intm_no = d.intrmdry_intm_no
  	     AND e.prem_seq_no = f.b140_prem_seq_no
     	 AND g.line_cd = y.line_cd
  	     AND g.subline_cd = y.subline_cd
	     AND NVL(y.prof_comm_tag, 'N') = 'Y'
   	     AND g.line_cd = z.line_cd
  	     AND d.peril_cd = z.peril_cd
	     AND NVL(z.prof_comm_tag, 'N') = 'Y'
       GROUP BY d.intrmdry_intm_no, h.parent_intm_no,g.line_cd, SUBSTR(iii.tarf_cd,1,1),
                d.policy_id,f.gacc_tran_id,e.iss_cd||'-'||TO_CHAR(e.prem_seq_no),
	           f.transaction_date,f.transaction_doc;
      --insert record on table giac_cpc_dtl
      IF SQL%FOUND THEN
         FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
           INSERT INTO GIAC_CPC_DTL
		     (intm_no,             parent_intm_no,         policy_id,
              peril_cd,            line_cd,                prem_amt,
              comm_amt,            tarf_cd,                tran_id,
              prem_seq_no,         tran_doc,               tran_date,
	  		  tran_year,           user_id,                last_update)
   	        VALUES
             (vv_intm_no(i),       vv_parent_intm_no(i),   vv_policy_id(i),
              vv_peril_cd(i),      vv_line_cd(i),          vv_prem_amt(i),
              vv_comm_amt(i),      vv_tarf_cd(i),          vv_tran_id(i),
              vv_prem_seq_no(i),   vv_tran_doc(i),         vv_tran_date(i),
		  	  p_year,              USER,                   SYSDATE);
            --after insert refresh arrays by deleting data
         vv_intm_no.DELETE;
	     vv_parent_intm_no.DELETE;
	     vv_line_cd.DELETE;
  	     vv_peril_cd.DELETE;
         vv_tarf_cd.DELETE;
   	     vv_policy_id.DELETE;
	     vv_tran_id.DELETE;
	     vv_prem_seq_no.DELETE;
	     vv_tran_date.DELETE;
	     vv_tran_doc.DELETE;
	     vv_prem_amt.DELETE;
	     vv_comm_amt.DELETE;
      END IF;
	  EXIT;
	END LOOP;
  END;--retrieve all records for FIRE
  COMMIT;
END; --main
/



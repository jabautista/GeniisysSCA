CREATE OR REPLACE PACKAGE BODY CPI.GIACR163_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   08.14.2013
     ** Referenced By:  GIACR163 - Overriding Commission Voucher
     **/
    
    /* CF_AGENT_CODE program unit */
    FUNCTION CF_AGENT_CD(
        p_intm_no       giis_intermediary.INTM_NO%type
    ) RETURN VARCHAR2
    AS
        v_parent_intm_no    giis_intermediary.parent_intm_no%type;
        v_lic_tag           giis_intermediary.lic_tag%type;
        v_type              giis_intermediary.intm_type%type;
        v_ptype		        giis_intermediary.intm_type%type;
    BEGIN
        FOR i IN (SELECT DISTINCT intm_type, lic_tag, parent_intm_no, intm_no
                    FROM giis_intermediary
                   WHERE intm_no = p_intm_no)
        LOOP
            v_type := i.intm_type;
            v_lic_tag := i.lic_tag;
            v_parent_intm_no := i.parent_intm_no;
        END LOOP;

        /*IF v_lic_tag = 'N' AND v_parent_intm_no IS NULL THEN
            FOR p IN (SELECT intm_type
                       FROM giis_intermediary
                      WHERE intm_no = v_parent_intm_no)
            LOOP
                v_ptype := p.intm_type;
            END LOOP;	 
            RETURN (v_ptype||'-'||v_parent_intm_no||' / '||v_type||'-'||p_intm_no);
        ELSE
            RETURN (v_type||'-'||p_intm_no);
        END IF;*/

        RETURN (v_type||'-'||p_intm_no);
    END CF_AGENT_CD;
    
    
    /* CF_INTM program unit */
    FUNCTION CF_AGENT_NAME(
        p_intm_no       giis_intermediary.INTM_NO%type
    ) RETURN VARCHAR2
    AS
        v_intm_name        giis_intermediary.intm_name%type;
        v_parent_intm_no   giis_intermediary.parent_intm_no%type;
        v_intm_no		   giis_intermediary.intm_no%type;
        v_lic_tag          giis_intermediary.lic_tag%type;
    BEGIN
        select lic_tag, parent_intm_no, intm_no
	      into v_lic_tag, v_parent_intm_no, v_intm_no
	      from giis_intermediary
	     where intm_no = p_intm_no;
         
        --cheryl
        /*if v_lic_tag = 'N' and v_parent_intm_no is not null then
     
            select intm_name
              into v_intm_name
              from giis_intermediary
             where intm_no = v_parent_intm_no;*/
             --comment out by cris 05/18/09
             --replaced with the condition below to show the parent intermediary if ever it exists
            /*if v_lic_tag = 'N' and v_parent_intm_no is not null then             
                select a.intm_name||' / '||b.intm_name
                  into v_intm_name
                  from(select intm_name
                         from giis_intermediary
                        where parent_intm_no is null
                          and intm_no = :p_intm_no) a,
                      (select intm_name
                         from giis_intermediary
                        where intm_no = v_intm_no
                          and parent_intm_no = :P_intm_no)b;
        else
            select intm_name
              into v_intm_name
              from giis_intermediary
             where intm_no = :intm_no;
   
        end if;*/
 
        select intm_name
          into v_intm_name
          from giis_intermediary
         where intm_no = v_intm_no;  
  
        return(v_intm_name);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN null;
    END CF_AGENT_NAME;
     
    
    FUNCTION CF_POLICY_ID(
        p_iss_cd        giac_parent_comm_voucher.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_voucher.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        v_policy_id 	NUMBER;
    BEGIN
        SELECT policy_id
  	      INTO v_policy_id
		  FROM gipi_invoice
	     WHERE iss_cd = p_iss_cd
	 	  AND prem_seq_no = p_prem_seq_no;
	   
	    RETURN(v_policy_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END CF_POLICY_ID;
    
    
    FUNCTION CF_LINE_CD(
        p_policy_id     gipi_invoice.POLICY_ID%type
    ) RETURN VARCHAR
    AS
        v_line_cd  VARCHAR2(2);
    BEGIN
        FOR rec IN(SELECT line_cd
					 FROM gipi_polbasic
	 				WHERE policy_id = p_policy_id)
	    LOOP
		    v_line_cd := rec.line_cd;
		    EXIT;
	    END LOOP;
	    
        RETURN(v_line_cd);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END CF_LINE_CD;
    
    
    PROCEDURE CF_PARTIAL_AMT(
        p_iss_cd        IN  GIPI_COMM_INV_PERIL.ISS_CD%type,
        p_prem_seq_no   IN  GIPI_COMM_INV_PERIL.PREM_SEQ_NO%type,
        p_premium_amt   IN  GIPI_COMM_INV_PERIL.PREMIUM_AMT%type,
        p_comm_amt      IN  GIAC_PARENT_COMM_INVPRL.COMMISSION_AMT%type,
        p_partial_comm  OUT NUMBER,
        p_partial_prem  OUT NUMBER
    )
    AS
        v_full_prem     NUMBER(16,2);
        v_full_comm     NUMBER(16,2);  
        v_partial_prem  GIAC_COMM_VOUCHER_EXT.prem_amt%type;
    BEGIN
        SELECT SUM(NVL(gd.PREMIUM_AMT,0)) prem_amt
          INTO v_partial_prem
          FROM GIAC_DIRECT_PREM_COLLNS gd,
               GIAC_ACCTRANS gat
         WHERE gd.GACC_TRAN_ID = gat.TRAN_ID
            AND gat.TRAN_FLAG <> 'D'
            AND gd.B140_ISS_CD = p_iss_cd
            AND gd.B140_PREM_SEQ_NO = p_prem_seq_no
            AND NOT EXISTS (SELECT 1
                              FROM GIAC_REVERSALS x, GIAC_ACCTRANS y
                             WHERE x.gacc_tran_id = gat.tran_id
                               AND x.reversing_tran_id = y.tran_id
                               AND y.tran_flag <> 'D')
          GROUP BY gd.B140_ISS_CD, gd.B140_PREM_SEQ_NO;
          
        	/*
  	    SELECT nvl(prem_amt,0)
  	      INTO v_partial_prem
		  FROM GIAC_COMM_VOUCHER_EXT gcve
		 WHERE gcve.PREM_SEQ_NO = :prem_seq_no
		   AND gcve.iss_cd = :iss_cd;
	    */
        
        SELECT NVL((a.prem_amt),0) , NVL((b.COMMISSION_AMT),0)
	      INTO V_FULL_PREM, V_FULL_COMM
	      FROM GIPI_INVOICE A,
		 	   GIPI_COMM_INVOICE B
         WHERE A.POLICY_ID = B.POLICY_ID
           AND A.ISS_CD = B.ISS_CD
           AND A.PREM_SEQ_NO = B.PREM_SEQ_NO 
           AND A.iss_cd = p_iss_cd
           AND A.PREM_SEQ_NO = p_prem_seq_no;
           
        p_partial_prem := (p_premium_amt * (v_partial_prem / V_FULL_PREM));
        p_partial_comm := (p_comm_amt * (v_partial_prem / V_FULL_PREM));
    END CF_PARTIAL_AMT;
    
    
    FUNCTION CF_WTAX_I(
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        v_wtax NUMBER;
    BEGIN
        --added by aliza 11/02/2011
	    SELECT NVL(SUM (withholding_tax),0)
 	      INTO v_wtax
 	      FROM giac_parent_comm_voucher
	     WHERE iss_cd = p_iss_cd 
           AND prem_seq_no = p_prem_seq_no;
           --AND gacc_tran_id = :p_gacc_tran_id;	--comment out edison 12.06.2011
           --end of code added by aliza 11/02/2011
           --srw.message (1, :input_vat);
           --v_wtax := -1 * (:tax * :cf_share_pct);
           --v_wtax := -1 * (:tax); omment out by aliza 11/02/2011
           --srw.message (2, v_ivat);  
        --RETURN (v_wtax);
        RETURN(-1 * v_wtax); --edison 12.06.2011 to less the whtax
    END CF_WTAX_I;
    
    
    FUNCTION CF_INPUT_VAT_I(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        v_ivat 			NUMBER;
	    v_ivat_rate		NUMBER; --edison 12.06.2011
    BEGIN
        /*comment out by edison 12.06.2011	
        --added by aliza 11/02/2011
            SELECT NVL(SUM (input_vat),0)
             INTO v_ivat
             FROM giac_parent_comm_voucher
             WHERE iss_cd = :iss_cd AND prem_seq_no = :prem_seq_no AND gacc_tran_id = :p_gacc_tran_id;
        --end of code added by aliza 11/02/2011
        --srw.message (1, :input_vat);
        --v_ivat := :input_vat * :cf_share_pct;
        --v_ivat := input_vat; comment out by aliza 11/02/2011
        --srw.message (2, v_ivat);
        **/ --end 12.06.2011
        	
        /***added by edison 12.06.2011***/
        SELECT input_vat_rate / 100
          INTO v_ivat_rate
          FROM giis_intermediary
         WHERE intm_no = p_intm_no;     

        SELECT NVL(SUM(commission_due),0) * v_ivat_rate
          INTO v_ivat
          FROM giac_parent_comm_voucher
         WHERE iss_cd = p_iss_cd
          AND prem_seq_no = p_prem_seq_no;
        --end 12.06.2011
        
        RETURN (v_ivat);
    END CF_INPUT_VAT_I;
    
    
    FUNCTION CF_ADV(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        v_advances	NUMBER(12,2);
    BEGIN
        SELECT NVL(SUM(comm_amt-wtax_amt+input_vat),0)partial
          INTO v_advances
          FROM GIAC_OVRIDE_COMM_PAYTS A, GIAC_ACCTRANS b
         WHERE A.intm_no = P_INTM_NO
           AND A.prem_seq_no = P_PREM_SEQ_NO
           AND A.iss_cd = P_ISS_CD
           AND A.gacc_tran_id = b.tran_id
           AND A.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                        FROM GIAC_REVERSALS c, GIAC_ACCTRANS d
                                       WHERE c.reversing_tran_id = d.tran_id
                                         AND d.tran_flag <> 'D')
           AND b.tran_flag <> 'D';
           
        RETURN(v_advances);
    END CF_ADV;
    
    
    FUNCTION populate_report(
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_commv_pref        giac_parent_comm_voucher.OCV_PREF_SUF%type,
        p_comm_vcr_no       VARCHAR2,
        p_cv_date           VARCHAR2,
        p_user              giac_parent_comm_voucher.USER_ID%type    
    ) RETURN detail_tab PIPELINED
    AS
        rep             detail_type;
        v_rec_exist     boolean := false;
    BEGIN   
        --remove by steven 10.08.2014     
        /*FOR a IN (SELECT * 
                    FROM GIIS_DOCUMENT
                   WHERE title = 'GIACR163_IMAGE'
                     AND report_id = 'GIACR163')
        LOOP
            rep.header_img_path := a.text;
        END LOOP;*/
        
        rep.header_img_path := giisp.v ('LOGO_FILE');
   
        FOR i IN (SELECT DISTINCT A.intm_no agent_cd, A.policy_no, 
                            b.iss_cd || '-' || TO_CHAR (b.prem_seq_no) bill_no,
                            SUM (NVL (b.premium_amt, 0)) prem_amt,
                            SUM (NVL (b.commission_amt, 0)) comm_amt,               
                            SUM(NVL(b.wholding_tax,0)) tax,
                            SUM (NVL (A.advances, 0)) advances,                
                            /*ROUND(DECODE(NVL(c.INPUT_VAT,0),0,
                            DECODE(SUM(b.COMMISSION_AMT*0.12),NVL(A.INPUT_VAT,0),NVL(A.INPUT_VAT,0),SUM(b.COMMISSION_AMT*0.12)),
                            NVL(c.INPUT_VAT,0)),2) input_vat,*/ --edison09262011
                            --NVL(A.input_vat,0)input_vat, --edison09262011 comment out by aliza 11/02/2011                                                           
                            A.assd_no assd, ga.assd_name, A.intm_no intm_no,
                            b.iss_cd iss_cd, b.prem_seq_no prem_seq_no,
                            SUM (NVL (A.advances, 0)) comm,
                            A.ocv_pref_suf || '-' || A.ocv_no cv_number, --cheryl 05252009
                            A.print_date cvdate,                          --chryl 05252009
                            --       gd.gacc_tran_id, --cris 05/18/09
                            A.user_id created_by,      --cris 05/19/09                
                            --     A.tran_date, A.REF_NO, --cheryl 05252009
                            --    (a.commission_amt-a.withholding_tax) comm_payable --cheryl 05252009
                            gtd.prem_amt partial_prem
                    FROM giac_parent_comm_voucher A,
                         giac_parent_comm_invprl b,
                         giac_ovride_comm_payts c,
                         giis_assured ga,
                         (SELECT gd.b140_iss_cd iss_cd,
                                 gd.b140_prem_seq_no prem_seq_no,
                                 SUM (gd.collection_amt) colln_amt,
                                 SUM (gd.premium_amt) prem_amt,
                                 SUM (gd.tax_amt) tax_amt
                            FROM giac_direct_prem_collns gd, giac_acctrans gat
                           WHERE gd.gacc_tran_id = gat.tran_id
                             AND gat.tran_flag <> 'D'
                             AND NOT EXISTS (SELECT 1
                                               FROM giac_reversals x, giac_acctrans y
                                              WHERE x.gacc_tran_id = gat.tran_id
                                                AND x.reversing_tran_id = y.tran_id
                                                AND y.tran_flag <> 'D')
                           GROUP BY gd.b140_iss_cd, gd.b140_prem_seq_no) gtd
                         --, GIIS_INTERMEDIARY GI
                   WHERE  1 = 1
                     AND A.assd_no = ga.assd_no(+)
                     --   AND A.intm_no = NVL(:p_intm_no,A.intm_no)
                     AND A.print_tag = 'Y'                            --cheryl 05252009
                     -- AND A.user_id = :p_user_id --Vincent 012605: added condition --comment out by jeremy 061609
                     AND gtd.iss_cd = A.iss_cd
                     AND gtd.prem_seq_no = b.prem_seq_no
                     AND A.iss_cd = b.iss_cd
                     AND A.prem_seq_no = b.prem_seq_no
                     AND b.prem_seq_no = c.prem_seq_no(+)
                     AND b.iss_cd = c.iss_cd(+)
                     --  AND GI.intm_no = NVL(12,GI.intm_no) --comment out by jeremy 060509
                     --AND A.INTM_NO = GI.PARENT_INTM_NO
                     AND A.intm_no = p_intm_no                        -- jeremy 060509
                     AND c.intm_no(+) = b.intm_no                      --belle 11082010
                   GROUP BY A.intm_no, A.policy_no,
                         b.iss_cd || '-' || TO_CHAR (b.prem_seq_no),
                         A.assd_no, ga.assd_name, b.iss_cd,
                         b.prem_seq_no, c.iss_cd, c.prem_seq_no,
                         A.ocv_pref_suf || '-' || A.ocv_no,
                         A.print_date, --      gd.gacc_tran_id,
                         A.user_id,
                         --A.tran_date, comment by edison 12072011
                         --A.ref_no, --comment out edison02.02.2012
                         --    (a.commission_amt-a.withholding_tax), --cher05252009
                         --NVL (c.input_vat, 0), --comment out edison02.02.2012
                         --NVL (A.input_vat, 0), --comment out edison02.02.2012
                         gtd.prem_amt
                   ORDER BY SUM(NVL(b.wholding_tax,0)))
        LOOP
            v_rec_exist         := TRUE;
            rep.print_details   := 'Y';
            rep.cf_agent_cd     := CF_AGENT_CD(p_intm_no);
            rep.cf_agent_name   := CF_AGENT_NAME(p_intm_no);
            rep.cf_ocv_no       := (NVL(P_COMMV_PREF,' ') ||' - '||NVL(P_COMM_VCR_NO,' '));  -- CF_OCV_NO program unit
            --rep.cf_cv_date      := TO_DATE(p_cv_date, 'MM-DD-RRRR');
            rep.policy_no       := i.policy_no;
            rep.assd_name       := i.assd_name;
            rep.assd_no         := i.assd;
            rep.iss_cd          := i.iss_cd;
            rep.prem_seq_no     := i.prem_seq_no;
            rep.cf_policy_id    := CF_POLICY_ID(i.iss_cd, i.prem_seq_no);
            rep.cf_line_cd      := CF_LINE_CD(rep.cf_policy_id);
            rep.cf_wtax_i       := CF_WTAX_I(i.iss_cd, i.prem_seq_no);
            rep.cf_input_vat_i  := CF_INPUT_VAT_I(i.intm_no, i.iss_cd, i.prem_seq_no);
            rep.cf_adv          := CF_ADV(p_intm_no, i.iss_cd, i.prem_seq_no);
            rep.tax             := i.tax;
            rep.bill_no         := i.bill_no;
            rep.cv_number       := i.cv_number;
            rep.cvdate          := i.cvdate;
            rep.created_by      := i.created_by;
            
            SELECT count(*) count
 	          INTO rep.cf_policy_ctr
		      FROM GIAC_parent_COMM_VOUCHER a
	         WHERE 1=1
               AND a.intm_no = NVL(p_intm_no,a.intm_no)--CHERYL 
               --AND a.print_tag = 'Y'--Vincent 012605: comment out
               --AND a.cv_date IS NULL;--Vincent 012605: comment out
               AND a.print_tag = 'Y'--Vincent 012605: added condition
               AND a.user_id = p_user;
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_rec_exist = FALSE THEN
            rep.print_details    := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;
    

    FUNCTION get_tran_date_ref_no(
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN q1_tab PIPELINED
    AS
        rep     q1_type;
    BEGIN
        --Q_1
        FOR j IN (SELECT DISTINCT TRUNC(tran_date) tran_date, GET_REF_NO(GACC_TRAN_ID) ref_no, b140_iss_cd, b140_prem_seq_no
                    FROM GIAC_acctrans a, giac_direct_prem_collns b
                   WHERE a.tran_id = b.gacc_tran_id
                     AND b140_iss_cd = p_iss_cd
                     AND b140_prem_seq_no = p_prem_seq_no
                     AND a.tran_flag<>'D'
                     and not exists (select 1 
                                       from giac_reversals x,
                                            giac_acctrans y
                                      where x.gacc_tran_id=a.tran_id
                                        and x.reversing_tran_id=y.tran_id
                                        and y.tran_flag<>'D')
                                      ORDER BY TRAN_DATE, REF_NO)
        LOOP
            rep.tran_date   := j.tran_date;
            rep.ref_no      := j.ref_no;
                
            PIPE ROW(REP);
        END LOOP;
    END get_tran_date_ref_no;    
    
    
    FUNCTION get_policy_amounts(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type,
        p_cf_policy_id  gipi_invoice.POLICY_ID%type,
        p_cf_line_cd    gipi_polbasic.LINE_CD%type  
    ) RETURN amounts_tab PIPELINED
    AS
        rep     amounts_type;
    BEGIN
        --Q_PERIL
        FOR k IN (SELECT DISTINCT gper.peril_sname, gcip.premium_amt, GPCOM.COMMISSION_AMT COMM_AMT,
                           NVL(gpcom.commission_rt,0) COMM_RT, gcip.commission_rt, GCIP.ISS_CD, GCIP.PREM_SEQ_NO
                           -- ,(:cp_prem_amt / :cp_full_prem * gcip.premium_amt) partial_prem  --,(:cp_prem_amt / :cp_full_prem * GPCOM.COMMISSION_AMT) partial_comm
                    FROM GIIS_PERIL gper, 
                         GIPI_COMM_INV_PERIL gcip, 
                         GIIS_INTERMEDIARY GI,
                         GIAC_PARENT_COMM_INVPRL gpcom
                   WHERE gcip.intrmdry_intm_no = GI.INTM_NO
                      --   AND gcip.premium_amt <> 0
                      --   AND gcip.commission_amt <> 0
                     AND gcip.intrmdry_intm_no = gpcom.chld_intm_no (+)
                     AND gcip.iss_cd = gpcom.iss_cd (+)
                     AND gcip.prem_seq_no = gpcom.prem_seq_no (+)
                     AND gcip.peril_cd = gpcom.peril_cd (+)
                     AND GI.PARENT_INTM_NO = p_intm_no
                     AND gcip.iss_cd 		 =   p_iss_cd
                     AND gcip.prem_seq_no  = p_prem_seq_no
                     AND gper.line_cd 	 = p_cf_line_cd
                     AND gper.peril_cd 	 = gcip.peril_cd
                     AND gcip.policy_id	 = p_cf_policy_id
                   ORDER BY gper.peril_sname )
        LOOP
            rep.peril_sname := k.peril_sname;
            rep.comm_rt     := k.comm_rt;
                
            CF_PARTIAL_AMT(k.iss_cd, k.prem_seq_no, k.premium_amt, k.comm_amt, rep.partial_comm, rep.partial_prem);
            
            PIPE ROW(rep);
        END LOOP;
    END get_policy_amounts;
    
    
    FUNCTION get_signatories(
        p_user          GIAC_USERS.USER_ID%type,       
        p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%type
    ) RETURN signatory_tab PIPELINED
    AS
        rep     signatory_type;
    BEGIN
        FOR i IN(SELECT 'Prepared by:' LABEL, user_name signatory, designation, 0 item_no
                   FROM GIAC_USERS
                  WHERE user_id = p_user
                  UNION
                 SELECT b.LABEL, c.signatory, c.designation, b.item_no
                   FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c 
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id 
                    AND a.report_id = 'GIACR163'--:p_report_id
                    AND NVL(a.branch_cd,NVL(p_branch_cd,'**')) = NVL(p_branch_cd,'**')
                    AND b.signatory_id = c.signatory_id
                  MINUS
                 SELECT b.LABEL, c.signatory, c.designation, b.item_no
                   FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id
                    AND a.report_id = 'GIACR163'--:p_report_id
                    AND a.branch_cd IS NULL 
                    AND EXISTS (SELECT 1 
                                  FROM GIAC_DOCUMENTS
                                 WHERE report_id = 'GIACR163'--:p_report_id
                                   AND branch_cd = p_branch_cd)  
                    AND b.signatory_id = c.signatory_id 
                  ORDER BY item_no)
        LOOP
            rep.label       := i.label;
            rep.signatory   := i.signatory;
            rep.designation := i.designation;
            rep.item_no     := i.item_no;
            
            PIPE ROW(rep);
        END LOOP;
    END;

END GIACR163_PKG;
/



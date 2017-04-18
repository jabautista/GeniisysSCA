CREATE OR REPLACE PACKAGE BODY CPI.gicl_reqd_docs_pkg
AS
   FUNCTION get_document_listing (p_claim_id gicl_reqd_docs.claim_id%TYPE)
      RETURN gicl_reqd_docs_tab PIPELINED
   IS
      v_docs   gicl_reqd_docs_type;
   BEGIN
      FOR i IN (SELECT a.clm_doc_cd,
                       (SELECT clm_doc_desc
                          FROM gicl_clm_docs b
                         WHERE b.clm_doc_cd = a.clm_doc_cd
                           AND line_cd = a.line_cd
                           AND subline_cd = a.subline_cd) clm_doc_desc,
                       TO_CHAR (a.doc_sbmttd_dt, 'MM-DD-YYYY') doc_sbmttd_dt,
                       TO_CHAR (a.doc_cmpltd_dt, 'MM-DD-YYYY') doc_cmpltd_dt,
                       a.rcvd_by, 
					   --a.frwd_by, remove by steven base on SR 0011268
					   a.frwd_fr, a.remarks, a.user_id,
                       TO_CHAR (a.last_update,
                                'MM-DD-YYYY HH:MI:SS AM'
                               ) lastupdate,
                       a.last_update
                  FROM gicl_reqd_docs a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_docs.clm_doc_cd := i.clm_doc_cd;
         v_docs.clm_doc_desc := i.clm_doc_desc;
         v_docs.doc_sbmttd_dt := i.doc_sbmttd_dt;
         v_docs.doc_cmpltd_dt := i.doc_cmpltd_dt;
         v_docs.rcvd_by := i.rcvd_by;
         v_docs.frwd_by := GET_ISS_NAME(i.frwd_fr); --added by steven 11.13.2012
         v_docs.frwd_fr := i.frwd_fr;
         v_docs.remarks := i.remarks;
         v_docs.user_id := i.user_id;
         v_docs.last_update := i.last_update;
         v_docs.lastupdate := i.lastupdate;
         PIPE ROW (v_docs);
      END LOOP;
   END;

   PROCEDURE save_reqd_docs (
      p_claim_id        gicl_reqd_docs.claim_id%TYPE,
      p_clm_doc_cd      gicl_reqd_docs.clm_doc_cd%TYPE,
      p_line_cd         gicl_reqd_docs.line_cd%TYPE,
      p_subline_cd      gicl_reqd_docs.subline_cd%TYPE,
      p_iss_cd          gicl_reqd_docs.iss_cd%TYPE,
      p_doc_sbmttd_dt   gicl_reqd_docs.doc_sbmttd_dt%TYPE,
      p_doc_cmpltd_dt   gicl_reqd_docs.doc_cmpltd_dt%TYPE,
      p_rcvd_by         gicl_reqd_docs.rcvd_by%TYPE,
      p_frwd_by         gicl_reqd_docs.frwd_by%TYPE,
      p_frwd_fr         gicl_reqd_docs.frwd_fr%TYPE,
      p_remarks         gicl_reqd_docs.remarks%TYPE,
      p_user_id         gicl_reqd_docs.user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_reqd_docs
         USING DUAL
         ON (clm_doc_cd = p_clm_doc_cd AND claim_id = p_claim_id)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, line_cd, subline_cd, iss_cd, clm_doc_cd,
                    user_id, last_update)
            VALUES (p_claim_id, p_line_cd, p_subline_cd, p_iss_cd,
                    p_clm_doc_cd, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET doc_sbmttd_dt = p_doc_sbmttd_dt,
                   doc_cmpltd_dt = p_doc_cmpltd_dt, 
				   rcvd_by = p_rcvd_by,
                   --frwd_by = p_frwd_by, remove by steven base on SR 0011268 
				   frwd_fr = p_frwd_fr,
                   remarks = p_remarks, 
				   user_id = p_user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_reqd_docs (
      p_claim_id     gicl_reqd_docs.claim_id%TYPE,
      p_clm_doc_cd   gicl_reqd_docs.clm_doc_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_reqd_docs
            WHERE claim_id = p_claim_id AND clm_doc_cd = p_clm_doc_cd;
   END;

   FUNCTION get_pre_print_details (p_assured_name VARCHAR2, p_call_out VARCHAR2)
      RETURN pre_print_tab PIPELINED
   IS
      v_pre          pre_print_type;
      v_mail_addr1   VARCHAR2 (50);
      v_mail_addr2   VARCHAR2 (50);
      v_mail_addr3   VARCHAR2 (50);
   BEGIN
      FOR payee IN (SELECT a.class_desc,
                                        --(b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3)addr, --connie 10/13/06
                                        b.mail_addr1 mail_addr1,
                           b.mail_addr2 mail_addr2, b.mail_addr3 mail_addr3,
                           --NVL (b.contact_pers, b.payee_last_name) attention
						   NVL(DECODE(b.contact_pers,'*',b.payee_last_name,b.contact_pers),b.PAYEE_LAST_NAME) attention --added by steven 02.08.2013; replace the code above.
                      FROM giis_payee_class a, giis_payees b
                     WHERE a.payee_class_cd = b.payee_class_cd
                       AND b.payee_last_name = p_assured_name)
      LOOP
         v_pre.send_to_cd := payee.class_desc;
         --:report_print.address   := payee.addr; --connie 10/13/06
         v_mail_addr1 := payee.mail_addr1;
         v_mail_addr2 := payee.mail_addr2;
         v_mail_addr3 := payee.mail_addr3;

         IF v_mail_addr2 IS NULL OR v_mail_addr2 = '*'
         THEN
            v_pre.address := payee.mail_addr1;
         ELSIF v_mail_addr3 IS NULL OR v_mail_addr3 = '*'
         THEN
            v_pre.address := v_mail_addr1 || CHR (10) || v_mail_addr2;
         ELSE
            v_pre.address :=
                  v_mail_addr1
               || CHR (10)
               || v_mail_addr2
               || CHR (10)
               || v_mail_addr3;
         END IF;

         v_pre.attention := payee.attention;
      END LOOP;

      IF p_call_out = 'N'
      THEN
         FOR ack_text IN (SELECT text begn_text
                            FROM giis_document
                           WHERE report_id = 'GICLR011'
                             AND title = 'CLM_ACK_BEGIN_TEXT')
         LOOP
            v_pre.beginning_text := ack_text.begn_text;
         END LOOP;

         FOR ack_text IN (SELECT text end_text
                            FROM giis_document
                           WHERE report_id = 'GICLR011'
                             AND title = 'CLM_ACK_END_TEXT')
         LOOP
            v_pre.ending_text := ack_text.end_text;
         END LOOP;
      ELSIF p_call_out = 'Y'
      THEN
         FOR call_text IN (SELECT text begn_text
                             FROM giis_document
                            WHERE report_id = 'GICLR011'
                              AND title = 'CALL_OUT_BEGIN_TEXT')
         LOOP
            v_pre.beginning_text := call_text.begn_text;
         END LOOP;

         FOR call_text IN (SELECT text end_text
                             FROM giis_document
                            WHERE report_id = 'GICLR011'
                              AND title = 'CALL_OUT_END_TEXT')
         LOOP
            v_pre.ending_text := call_text.end_text;
         END LOOP;
      END IF;

      PIPE ROW (v_pre);
   END;
   
   /**
    **  Created by      : Niknok Orio 
    **  Date Created    : 10.19.2011 
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :        
    **/  
    FUNCTION validate_clm_req_docs(p_claim_id       gicl_claims.claim_id%TYPE)
    RETURN VARCHAR2 IS
      dummy                 gicl_claims.claim_id%TYPE;
      v_msg_alert           VARCHAR2(3200);
      v_doc_cmpltd_dt       gicl_reqd_docs.doc_cmpltd_dt%TYPE;
    BEGIN 
        BEGIN
        SELECT DISTINCT claim_id
          INTO dummy
    	  FROM gicl_reqd_docs
	  	 WHERE claim_id = p_claim_id;
		EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	 	    --:C003.NBT_CLM_STAT_CD := 'N';
			v_msg_alert := 'No Required Documents submitted.';--,'E',TRUE);
            RETURN (v_msg_alert);
		END;
	
		FOR A IN (SELECT doc_cmpltd_dt
 		   		    FROM gicl_reqd_docs
		    	   WHERE claim_id = p_claim_id)
		LOOP
			v_doc_cmpltd_dt := a.doc_cmpltd_dt;
			IF v_doc_cmpltd_dt is null then
				--:C003.NBT_CLM_STAT_CD := 'N';
				v_msg_alert := 'Required Document/s is not yet completed.';--,'E',TRUE);
                RETURN (v_msg_alert);
  		    END IF;
		END LOOP;
    RETURN (v_msg_alert);
    END; 
       
END;
/



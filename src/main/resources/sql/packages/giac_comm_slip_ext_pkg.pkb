CREATE OR REPLACE PACKAGE BODY CPI.GIAC_COMM_SLIP_EXT_PKG
AS
    
    FUNCTION get_comm_slip_ext (p_tran_id   GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE)
        RETURN giac_comm_slip_ext_tab PIPELINED
    IS
        v_comm_slip     giac_comm_slip_ext_type;
    BEGIN
        /*
        **  Created By:       d.alcantara
        **  Date Created:     03.17.2011        
        **  Description:      Retrives record for giacs154
        */
        FOR i IN ( SELECT a.rec_id, a.gacc_tran_id, a.comm_slip_pref, a.comm_slip_no,
                          a.intm_no, b.ref_intm_cd, a.iss_cd, a.prem_seq_no,
                          a.comm_amt, a.wtax_amt, a.input_vat_amt,
                          a.comm_slip_flag, a.comm_slip_tag
                    FROM giac_comm_slip_ext a,
                         giis_intermediary b
                    WHERE a.gacc_tran_id = p_tran_id
                         AND a.intm_no = b.intm_no)
         LOOP
            v_comm_slip.rec_id              :=  i.rec_id;
            v_comm_slip.gacc_tran_id        :=  i.gacc_tran_id;
            v_comm_slip.comm_slip_pref      :=  i.comm_slip_pref;
            v_comm_slip.comm_slip_no        :=  i.comm_slip_no;
            v_comm_slip.intm_no             :=  i.intm_no;
            v_comm_slip.ref_intm_cd         :=  i.ref_intm_cd;
            v_comm_slip.iss_cd              :=  i.iss_cd;
            v_comm_slip.prem_seq_no         :=  i.prem_seq_no;
            --v_comm_slip.bill_no             :=  (i.iss_cd || '-' || TO_CHAR(i.prem_seq_no, 'FM099999999999'));
            v_comm_slip.comm_amt            :=  i.comm_amt;
            v_comm_slip.wtax_amt            :=  i.wtax_amt;
            v_comm_slip.input_vat_amt       :=  i.input_vat_amt;
            v_comm_slip.net_amt             :=  NVL((i.comm_amt + i.input_vat_amt - i.wtax_amt),0);     
            v_comm_slip.comm_slip_flag      :=  i.comm_slip_flag;
            v_comm_slip.comm_slip_tag       :=  i.comm_slip_tag;
            --v_comm_slip.commission_slip_no  :=  i.comm_slip_pref || '-' || TO_CHAR(i.comm_slip_no, 'FM099999999999');
            
            --marco - comment out codes above; added lines below - 10.08.2013
            IF i.comm_slip_pref IS NULL OR i.comm_slip_no IS NULL THEN
               v_comm_slip.commission_slip_no := '';
            ELSE
               v_comm_slip.commission_slip_no := i.comm_slip_pref || '-' || TO_CHAR(i.comm_slip_no, 'FM099999999999');
            END IF;
            IF i.iss_cd IS NULL or i.prem_seq_no IS NULL THEN
               v_comm_slip.bill_no := '';
            ELSE
               v_comm_slip.bill_no := i.iss_cd || '-' || TO_CHAR(i.prem_seq_no, 'FM099999999999');
            END IF;
            
            PIPE ROW(v_comm_slip);
         END LOOP;       
         RETURN;
    END get_comm_slip_ext;
    
    PROCEDURE extract_comm_slip (
        p_tran_id  IN GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_user     IN GIIS_USERS.user_id%TYPE,
        p_pdc      OUT VARCHAR2)
    IS
        v_gacc_tran_id     NUMBER(12);
        v_intm_no          NUMBER(12);
        v_parent_intm_no   NUMBER(12);
        v_iss_cd           VARCHAR2(3);
        v_prem_seq_no      number(12);
        v_comm_amt         number(12,2);
        v_wtax_amt         number(12,2);
        v_input_vat        number(12,2);
        v_or_no	           varchar2(15);
        V_REC_ID           GIAC_COMM_SLIP_EXT.REC_ID%TYPE;
        v_exist            varchar2(1);
        v_pdc              VARCHAR2(3);
    BEGIN
        begin
            select 'X'
              into v_pdc
              from giac_pdc_checks
             where gacc_tran_id_new = p_tran_id ;
        exception 
            when no_data_found then
              v_pdc := null;
         end;
         
        FOR ctr IN (SELECT gacc_tran_id, 
							       iss_cd, 
  	     						 prem_seq_no, 
    	   					   intm_no,
    	   					   rec_id
  							FROM giac_comm_slip_ext
 							 WHERE gacc_tran_id = p_tran_id 							  
 							 MINUS
      				SELECT a.gacc_tran_id, 
								     a.iss_cd, 
       						   a.prem_seq_no, 
       							 a.intm_no,
    	   					   b.rec_id 
  							FROM giac_comm_payts a, giac_comm_slip_ext b      							 
 						 	 WHERE a.gacc_tran_id = p_tran_id
 						 	   AND a.gacc_tran_id = b.gacc_tran_id 
 						 	   AND a.intm_no = b.intm_no
 						 	   AND a.iss_cd = b.iss_cd
 						 	   AND a.prem_seq_no = b.prem_seq_no
 						 	   AND a.gacc_tran_id > 0 
 						 	   AND a.comm_amt = b.comm_amt
                 AND a.wtax_amt = b.wtax_amt
                 AND a.input_vat_amt = b.input_vat_amt
                 )
         
             LOOP
                                            
         DELETE FROM giac_comm_slip_ext
         WHERE gacc_tran_id = p_tran_id
             AND iss_cd = ctr.iss_cd 
          AND prem_seq_no = ctr.prem_seq_no
          AND intm_no = ctr.intm_no
          AND rec_id = ctr.rec_id;
        END LOOP;

    
    SELECT nvl(MAX(rec_id),0)
      INTO V_REC_ID
      FROM GIAC_COMM_SLIP_EXT;


  IF v_pdc IS NULL THEN 
----
        FOR i IN (SELECT a.gacc_tran_id, 
                                     a.iss_cd, 
                                     a.prem_seq_no, 
                                     a.intm_no, 
                                     a.parent_intm_no,
                     a.comm_amt, 
                     a.wtax_amt, 
                     a.input_vat_amt, 
                     b.or_pref_suf||'-'||to_char(b.or_no) or_no
                     
                FROM giac_comm_payts a, giac_order_of_payts b
               WHERE a.gacc_tran_id = p_tran_id 
                    AND a.gacc_tran_id=b.gacc_tran_id

                              MINUS
                            SELECT a.gacc_tran_id, 
                                   a.iss_cd, 
                                    a.prem_seq_no, 
                                  a.intm_no, 
                                    a.parent_intm_no,
                                    a.comm_amt, 
                                    a.wtax_amt, 
                                    a.input_vat_amt,
                                    b.or_pref_suf||'-'||to_char(b.or_no) or_no
                                
                              FROM giac_comm_slip_ext a, giac_order_of_payts b, giac_comm_payts c
                              WHERE a.gacc_tran_id=p_tran_id
                                AND a.gacc_tran_id=b.gacc_tran_id
                                AND a.gacc_tran_id=c.gacc_tran_id
                                AND a.intm_no = c.intm_no
                                 AND a.iss_cd = c.iss_cd
                                 AND a.prem_seq_no = c.prem_seq_no
                                 AND c.gacc_tran_id > 0
   
                                  ) 
 
        LOOP
          v_gacc_tran_id := i.gacc_tran_id;
          v_intm_no := i.intm_no;
          v_parent_intm_no := i.parent_intm_no;
          v_iss_cd  := i.iss_cd;
          v_prem_seq_no := i.prem_seq_no;
          v_comm_amt := i.comm_amt;
          v_wtax_amt := i.wtax_amt;
          v_input_vat := i.input_vat_amt;
          v_or_no := i.or_no;
          v_rec_id := v_rec_id +1;
          INSERT INTO giac_comm_slip_ext 
          (rec_id, gacc_tran_id, iss_cd, prem_seq_no, intm_no, comm_amt,
           wtax_amt, input_vat_amt, user_id, last_update, comm_slip_tag,or_no,PARENT_INTM_NO
           )
          VALUES 
          (v_rec_id, v_gacc_tran_id, v_iss_cd, v_prem_seq_no, v_intm_no, v_comm_amt,
           v_wtax_amt, v_input_vat, nvl(p_user, USER), sysdate, 'N',v_or_no,v_parent_intm_no
           );
        END LOOP;

      ELSE
        for i in (SELECT a.gacc_tran_id, 
                                         a.iss_cd, 
                                         a.prem_seq_no, 
                                         a.intm_no, 
                                         a.parent_intm_no,
                         a.comm_amt, 
                         a.wtax_amt, 
                         a.input_vat_amt, 
                         b.or_pref_suf||'-'||to_char(b.or_no) or_no
                    FROM giac_comm_payts a, giac_order_of_payts b, GIAC_PDC_CHECKS C
                   WHERE a.gacc_tran_id = p_tran_id
                     AND B.gacc_tran_id = C.gacc_tran_id 
                             AND a.gacc_tran_id = c.gacc_tran_id_NEW 
                   MINUS
                                SELECT a.gacc_tran_id, 
                                       a.iss_cd, 
                                     a.prem_seq_no, 
                                   a.intm_no, 
                                     a.parent_intm_no,
                                     a.comm_amt, 
                                     a.wtax_amt, 
                                     a.input_vat_amt,
                                     b.or_pref_suf||'-'||to_char(b.or_no) or_no
                                 
                                FROM giac_comm_slip_ext a, giac_order_of_payts b, giac_comm_payts c, GIAC_PDC_CHECKS D
                                 WHERE a.gacc_tran_id=p_tran_id
                                   AND a.gacc_tran_id=D.gacc_tran_id_NEW
                                   AND D.gacc_tran_id = B.gacc_tran_id
                                   AND a.gacc_tran_id=c.gacc_tran_id
                                   AND a.intm_no = c.intm_no
                                   AND a.iss_cd = c.iss_cd
                                   AND a.prem_seq_no = c.prem_seq_no
                                   AND c.gacc_tran_id > 0	) 
                             LOOP
          v_gacc_tran_id := i.gacc_tran_id;
          v_intm_no := i.intm_no;
          v_parent_intm_no := i.parent_intm_no;
          v_iss_cd  := i.iss_cd;
          v_prem_seq_no := i.prem_seq_no;
          v_comm_amt := i.comm_amt;
          v_wtax_amt := i.wtax_amt;
          v_input_vat := i.input_vat_amt;
          v_or_no := i.or_no;
          v_rec_id := v_rec_id +1;
          INSERT INTO giac_comm_slip_ext 
          (rec_id, gacc_tran_id, iss_cd, prem_seq_no, intm_no, comm_amt,
           wtax_amt, input_vat_amt, user_id, last_update, comm_slip_tag,or_no,PARENT_INTM_NO
           )
          VALUES 
          (v_rec_id, v_gacc_tran_id, v_iss_cd, v_prem_seq_no, v_intm_no, v_comm_amt,
           v_wtax_amt, v_input_vat, nvl(p_user, USER), sysdate, 'N',v_or_no,v_parent_intm_no
           );
            END LOOP;	   
        end if;					 
        p_pdc := v_pdc;
    END extract_comm_slip;
    
    
    PROCEDURE get_comm_print_values (
        p_tran_id             IN  GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_user                IN  GIIS_USERS.user_id%TYPE,
        p_pdc                 IN  VARCHAR2,
        p_comm_slip_pref      OUT GIAC_COMM_SLIP_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no        OUT GIAC_COMM_SLIP_EXT.comm_slip_no%TYPE,
        p_mesg                OUT VARCHAR2
    ) IS
        v_min			giac_doc_sequence_user.min_seq_no%TYPE;
        v_max			giac_doc_sequence_user.max_seq_no%TYPE;
        v_branch		giac_parameters.param_value_v%TYPE;
        v_fund			giac_parameters.param_value_v%TYPE;
        v_pref			giac_doc_sequence.doc_pref_suf%TYPE;
        v_flag			varchar2(1);
        v_doc_seq       GIAC_PARAMETERS.param_value_v%TYPE;
    BEGIN
        FOR doc IN (SELECT param_value_v
											FROM giac_parameters
										 WHERE param_name = 'CS_PER_USER')
				LOOP
					v_doc_seq := doc.param_value_v;
				END LOOP;
				
				IF v_doc_seq = 'Y' THEN
					--pop_slip;
                    p_mesg := 'Y';
                    IF p_pdc IS NULL THEN	
                        SELECT gibr_gfun_fund_cd, gibr_branch_cd
                            INTO v_fund, v_branch
                            FROM giac_order_of_payts
                         WHERE gacc_tran_id = p_tran_id;
                    ELSE
                        SELECT a.gibr_gfun_fund_cd, a.gibr_branch_cd
                            INTO v_fund, v_branch
                            FROM giac_order_of_payts a, giac_pdc_checks b
                         WHERE a.gacc_tran_id = b.gacc_tran_id
                           and b.gacc_tran_id_new = p_tran_id;
                    END IF;
                       
                    BEGIN
                      SELECT doc_pref
                        INTO v_pref
                        FROM giac_doc_sequence_user
                      WHERE doc_code = 'CS' 
                      AND branch_cd = v_branch
                      AND user_cd = (SELECT cashier_cd
                                                             FROM giac_dcb_users
                                                            WHERE gibr_branch_cd = v_branch
                                                                AND dcb_user_id = nvl(p_user, USER))
                      AND active_tag = 'Y'; 		    	    
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          --msg_alert('Commission Slip prefix parameter not found.', 'E', TRUE);
                          p_mesg := 'Commission Slip prefix parameter not found.';
                    END;

                    p_comm_slip_pref := v_pref;

                    BEGIN
                      SELECT min_seq_no, max_seq_no
                        INTO v_min, v_max
                        FROM giac_doc_sequence_user
                      WHERE doc_code = 'CS' 
                      AND branch_cd = v_branch
                      AND user_cd = (SELECT cashier_cd
                                                             FROM giac_dcb_users
                                                            WHERE gibr_branch_cd = v_branch
                                                                AND dcb_user_id = nvl(p_user, USER))
                      AND doc_pref = v_pref
                      AND active_tag = 'Y';
                  		    
                    v_flag := 'Y';
                  		    
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_min := 1;
                          v_max := 1;
                          v_flag := 'N';
                          --msg_alert('No range of Commission Slip Number found','E',FALSE);
                          p_mesg := 'No range of Commission Slip Number found';
                    END;
                    BEGIN
                    SELECT nvl(max(comm_slip_no)+1,v_min)
                       INTO p_comm_slip_no
                       FROM giac_comm_slip_ext
                       WHERE user_id = nvl(p_user, USER)
                             AND comm_slip_pref = v_pref
                       AND comm_slip_no between v_min and v_max;
                        	
                    IF p_comm_slip_no > v_max and v_flag = 'Y' THEN
                        p_mesg := 'Commission Slip Number exceeds maximum sequence number for the booklet.';
                    END IF;

                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_comm_slip_no := v_min;
                    END;  
                    --
				ELSE
                    if p_pdc = 'N' OR p_pdc IS NULL then
                      FOR a IN (SELECT doc_pref_suf slip_pref, doc_seq_no slip_no
                                       FROM giac_doc_sequence								
                                                        WHERE fund_cd 	= (SELECT gibr_gfun_fund_cd
                                                                                               FROM giac_order_of_payts
                                                                                              WHERE gacc_tran_id = p_tran_id)
                                        AND branch_cd = (SELECT gibr_branch_cd
                                                                                               FROM giac_order_of_payts
                                                                                            WHERE gacc_tran_id = p_tran_id)			   	          												
                                                    AND doc_name  = 'COMM_SLIP')
                      LOOP
                      p_comm_slip_pref := a.slip_pref;
                      p_comm_slip_no := a.slip_no;
                      p_mesg := 'Y';
                      END LOOP;
                    
                    else
                      FOR b IN (SELECT doc_pref_suf slip_pref, doc_seq_no slip_no
                                       FROM giac_doc_sequence								
                                                        WHERE fund_cd 	= (SELECT a.gibr_gfun_fund_cd
                                                                                               FROM giac_order_of_payts a, giac_pdc_checks b
                                                                                              WHERE a.gacc_tran_id = b.gacc_tran_id
                                                                                                AND b.gacc_tran_id_new = p_tran_id)
                                        AND branch_cd = (SELECT a.gibr_branch_cd
                                                                                               FROM giac_order_of_payts a, giac_pdc_checks b
                                                                                            WHERE a.gacc_tran_id = b.gacc_tran_id
                                                                                              AND b.gacc_tran_id_new = p_tran_id)			   	          												
                                                    AND doc_name  = 'COMM_SLIP')
                        LOOP
                      p_comm_slip_pref := b.slip_pref;
                      p_comm_slip_no := b.slip_no;
                      p_mesg := 'Y';
                      END LOOP;
                    end if;
                    IF p_mesg IS NULL THEN --marco - 10.08.2014
                     p_mesg := 'Commission Slip prefix parameter was not found in GIAC_DOC_SEQUENCE.';
                    END IF;
                END IF;
    END get_comm_print_values;
    
    
    PROCEDURE set_valid_comm_slip_tag (
        p_tran_id             GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE,
        p_intm_no             GIAC_COMM_SLIP_EXT.intm_no%TYPE,
        p_rec_id              GIAC_COMM_SLIP_EXT.rec_id%TYPE,
        p_iss_cd              GIAC_COMM_SLIP_EXT.iss_cd%TYPE,
        p_prem_seq            GIAC_COMM_SLIP_EXT.prem_seq_no%TYPE
    ) IS
    
    BEGIN
        UPDATE giac_comm_slip_ext
           SET comm_slip_tag = 'Y'
         WHERE intm_no = p_intm_no
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq
           AND rec_id = p_rec_id	
           AND gacc_tran_id = p_tran_id
           AND (comm_slip_flag !='C'
                OR comm_slip_flag IS NULL);
    END set_valid_comm_slip_tag;
    
    PROCEDURE reset_comm_slip_tag(p_tran_id     GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE) IS
    
    BEGIN
        UPDATE giac_comm_slip_ext
            SET comm_slip_tag = 'N'
        WHERE gacc_tran_id = p_tran_id;
    END reset_comm_slip_tag;
END GIAC_COMM_SLIP_EXT_PKG;
/



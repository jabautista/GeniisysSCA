CREATE OR REPLACE PACKAGE BODY CPI.giacs250_pkg
AS

   FUNCTION get_fund_lov(
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN fund_lov_tab PIPELINED
   IS
      v_row                   fund_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.fund_cd, a.fund_desc
                 FROM giis_funds a,
                      giac_dcb_users b
                WHERE a.fund_cd = b.gibr_fund_cd
                  AND b.dcb_user_id = p_user_id
                  AND (UPPER(a.fund_cd) LIKE UPPER(NVL(p_find_text, '%'))
                      OR UPPER(a.fund_desc) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.fund_cd := i.fund_cd;
         v_row.fund_desc := i.fund_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;

   FUNCTION get_branch_lov(
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN branch_lov_tab PIPELINED
   IS
      v_row                   branch_lov_type;
   BEGIN
      FOR i IN(SELECT gibr_branch_cd, branch_name
                 FROM giac_dcb_users a,
                      giac_branches b
                WHERE dcb_user_id = p_user_id
                  AND a.gibr_fund_cd = b.gfun_fund_cd
                  AND a.gibr_branch_cd = b.branch_cd
                  AND check_user_per_iss_cd_acctg2(NULL, a.gibr_branch_cd, 'GIACS250', p_user_id) = 1
                  AND (UPPER(gibr_branch_cd) LIKE UPPER(NVL(p_find_text, '%'))
                      OR UPPER(branch_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.branch_cd := i.gibr_branch_cd;
         v_row.branch_name := i.branch_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_batch_comm_slip(
      p_fund_cd               giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd             giac_acctrans.gibr_branch_cd%TYPE,
      p_or_no                 giac_order_of_payts.or_no%TYPE,
      p_or_pref               giac_order_of_payts.or_pref_suf%TYPE
   )
     RETURN batch_comm_slip_tab PIPELINED
   IS
      v_row                   batch_comm_slip_type;
   BEGIN
      FOR i IN(SELECT gibr_branch_cd iss_cd, gacc_tran_id, or_no, intm_no,
                      SUM(comm_amt) comm_amt, SUM(wtax_amt) wtax_amt, SUM(input_vat_amt) input_vat_amt
                 FROM giac_comm_slip_ext a,
                      giac_acctrans b
                WHERE NVL(comm_slip_flag, 'N') = 'N'
                  AND b.tran_id = a.gacc_tran_id
                  AND gfun_fund_cd = p_fund_cd
                  AND gibr_branch_cd = p_branch_cd
                  AND gacc_tran_id IN (SELECT gacc_tran_id
                                         FROM giac_order_of_payts a,
                                              giac_acctrans b
                                        WHERE or_flag = 'P'
                                          AND a.gacc_tran_id = b.tran_id
                                          AND tran_flag != 'D'
                                          AND or_no = NVL(p_or_no ,or_no)                     
                  AND or_pref_suf = NVL(p_or_pref, or_pref_suf))
                GROUP BY gibr_branch_cd, gacc_tran_id, or_no, intm_no
                ORDER BY gacc_tran_id)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.gacc_tran_id := i.gacc_tran_id;
         v_row.dsp_or_no := i.or_no;
         v_row.intm_no := i.intm_no;
         v_row.comm_amt := i.comm_amt;
         v_row.wtax_amt := i.wtax_amt;
         v_row.input_vat_amt := i.input_vat_amt;
         v_row.net_amt := i.comm_amt - i.wtax_amt + i.input_vat_amt;
         
         v_row.or_no := NULL;
         v_row.or_pref := NULL;
         FOR o IN (SELECT or_pref_suf, or_no
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = i.gacc_tran_id)
         LOOP
		      v_row.or_pref := o.or_pref_suf;
	         v_row.or_no := o.or_no;
            EXIT;
         END LOOP;
         
         v_row.intm_name := NULL;
         FOR j IN (SELECT intm_name
                     FROM giis_intermediary
                    WHERE intm_no = i.intm_no)
         LOOP
	         v_row.intm_name := j.intm_name;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE populate_batch_comm_slip_temp(
      p_fund_cd               giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd             giac_acctrans.gibr_branch_cd%TYPE,
      p_or_no                 giac_order_of_payts.or_no%TYPE,
      p_or_pref               giac_order_of_payts.or_pref_suf%TYPE
   )
   IS
   
   BEGIN
      DELETE FROM giac_comm_slip_ext_temp;
      
      INSERT INTO giac_comm_slip_ext_temp
       VALUE (SELECT a.*, NULL, NULL, NULL, NULL
                FROM TABLE(giacs250_pkg.get_batch_comm_slip(p_fund_cd, p_branch_cd, p_or_no, p_or_pref)) a);
      
      COMMIT;
   END;
   
   FUNCTION get_batch_comm_slip_listing(
      p_or_pref               VARCHAR2,
      p_or_no                 NUMBER,
      p_intm_no               NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat_amt         NUMBER,
      p_net_amt               NUMBER
   )
     RETURN batch_comm_slip_list_tab PIPELINED
   IS
      v_row                   batch_comm_slip_list_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giac_comm_slip_ext_temp
                WHERE UPPER(NVL(or_pref, '%')) LIKE UPPER(NVL(p_or_pref, NVL(or_pref, '%')))
                  AND NVL(TO_CHAR(or_no), '%') LIKE NVL(p_or_no, NVL(TO_CHAR(or_no), '%'))
                  AND NVL(intm_no, 0) = NVL(p_intm_no, NVL(intm_no, 0))
                  AND NVL(comm_amt, 0) = NVL(p_comm_amt, NVL(comm_amt, 0))
                  AND NVL(wtax_amt, 0) = NVL(p_wtax_amt, NVL(wtax_amt, 0))
                  AND NVL(input_vat_amt, 0) = NVL(p_input_vat_amt, NVL(input_vat_amt, 0))
                  AND NVL(net_amt, 0) = NVL(p_net_amt, NVL(net_amt, 0))
                ORDER BY gacc_tran_id)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.gacc_tran_id := i.gacc_tran_id;
         v_row.dsp_or_no := i.or_no;
         v_row.intm_no := i.intm_no;
         v_row.comm_amt := i.comm_amt;
         v_row.wtax_amt := i.wtax_amt;
         v_row.input_vat_amt := i.input_vat_amt;
         v_row.net_amt := i.net_amt;
         v_row.or_pref := i.or_pref;
	      v_row.or_no := i.or_no;
         v_row.intm_name := i.intm_name;
         v_row.generate_flag := i.generate_flag;
         v_row.printed_flag := i.printed_flag;
         v_row.comm_slip_pref := i.comm_slip_pref;
         v_row.comm_slip_no := i.comm_slip_no;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE get_comm_slip_seq(
      p_fund_cd         IN    giis_funds.fund_cd%TYPE,
      p_branch_cd       IN    giac_branches.branch_cd%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE,
      p_cs_pref         OUT   giac_doc_sequence.doc_pref_suf%TYPE,
      p_cs_seq_no       OUT   giac_doc_sequence.doc_seq_no%TYPE
   )
   IS
      v_user_seq_type         giac_parameters.param_value_v%TYPE;
   BEGIN
      v_user_seq_type := GIACP.v('CS_PER_USER');
      
      IF v_user_seq_type = 'N' THEN
         FOR k IN (SELECT doc_pref_suf slip_pref, doc_seq_no slip_no
      	            FROM giac_doc_sequence
                    WHERE fund_cd = p_fund_cd
                      AND branch_cd = p_branch_cd		   	          												
	 	            	 AND doc_name  = 'COMM_SLIP')
         LOOP 
	         p_cs_pref := k.slip_pref;
            p_cs_seq_no := k.slip_no;
            EXIT;
         END LOOP;
      ELSE
         FOR m IN (SELECT doc_pref slip_pref
	                  FROM giac_doc_sequence_user
  	                 WHERE doc_code = 'CS' 
  	                   AND branch_cd = p_branch_cd
  	                   AND user_cd = (SELECT cashier_cd
			 								      FROM giac_dcb_users
			 								     WHERE gibr_branch_cd = p_branch_cd
			 									    AND dcb_user_id = p_user_id)
  	                   AND active_tag = 'Y')
         LOOP
  	         p_cs_pref := m.slip_pref;
            	
  	         FOR n IN (SELECT MAX(comm_slip_no) + 1 slip_no
                        FROM giac_comm_slip_ext
                       WHERE user_id = p_user_id
			                AND comm_slip_pref = p_cs_pref
                         AND iss_cd = p_branch_cd)
            LOOP
    	         p_cs_seq_no := n.slip_no;
    	         EXIT;
            END LOOP;
            
            EXIT;
         END LOOP;
      END IF;
   END;
   
   PROCEDURE tag_all(
      p_or_pref               VARCHAR2,
      p_or_no                 NUMBER,
      p_intm_no               NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat_amt         NUMBER,
      p_net_amt               NUMBER
   )
   IS
   BEGIN
      UPDATE giac_comm_slip_ext_temp
         SET generate_flag = 'Y'
       WHERE UPPER(NVL(or_pref, '%')) LIKE UPPER(NVL(p_or_pref, NVL(or_pref, '%')))
         AND NVL(TO_CHAR(or_no), '%') LIKE NVL(p_or_no, NVL(TO_CHAR(or_no), '%'))
         AND NVL(intm_no, 0) = NVL(p_intm_no, NVL(intm_no, 0))
         AND NVL(comm_amt, 0) = NVL(p_comm_amt, NVL(comm_amt, 0))
         AND NVL(wtax_amt, 0) = NVL(p_wtax_amt, NVL(wtax_amt, 0))
         AND NVL(input_vat_amt, 0) = NVL(p_input_vat_amt, NVL(input_vat_amt, 0))
         AND NVL(net_amt, 0) = NVL(p_net_amt, NVL(net_amt, 0));
   END;
   
   PROCEDURE untag_all
   IS
   BEGIN
      UPDATE giac_comm_slip_ext_temp
         SET generate_flag = 'N',
             comm_slip_pref = NULL,
             comm_slip_no = NULL;
   END;
   
   PROCEDURE generate_comm_slip_numbers(
      p_comm_slip_pref  IN    giac_doc_sequence.doc_pref_suf%TYPE,
      p_comm_slip_seq   IN    giac_doc_sequence.doc_seq_no%TYPE,
      p_count           OUT   NUMBER
   )
   IS
      v_seq_no                giac_doc_sequence.doc_seq_no%TYPE;
   BEGIN
      v_seq_no := p_comm_slip_seq;
      p_count := 0;
   
      FOR i IN(SELECT gacc_tran_id, intm_no
                 FROM giac_comm_slip_ext_temp
                WHERE NVL(generate_flag, 'N') = 'Y'
                  AND NVL(printed_flag, 'N') NOT IN ('P', 'C')
                ORDER BY gacc_tran_id)
      LOOP
         UPDATE giac_comm_slip_ext_temp a
            SET a.comm_slip_pref = p_comm_slip_pref,
                a.comm_slip_no = v_seq_no
          WHERE a.gacc_tran_id = i.gacc_tran_id
            AND a.intm_no = i.intm_no;
            
         v_seq_no := v_seq_no + 1;
         p_count := p_count + 1;
      END LOOP;
   END;
   
   PROCEDURE save_generate_flag(
      p_gacc_tran_id          giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no               giac_comm_slip_ext.intm_no%TYPE,
      p_generate_flag         VARCHAR2
   )
   IS
   BEGIN
      UPDATE giac_comm_slip_ext_temp
         SET generate_flag = p_generate_flag
       WHERE gacc_tran_id = p_gacc_tran_id
         AND intm_no = p_intm_no;
   END;
   
   FUNCTION get_batch_comm_slip_reports
     RETURN report_params_tab PIPELINED
   IS
      v_row                   report_params_type;
   BEGIN
      FOR i IN(SELECT gacc_tran_id, iss_cd, intm_no, comm_slip_no, comm_slip_pref
                 FROM giac_comm_slip_ext_temp
                WHERE NVL(generate_flag, 'N') = 'Y'
                ORDER BY gacc_tran_id)
      LOOP
         v_row.gacc_tran_id := i.gacc_tran_id;
         v_row.branch_cd := i.iss_cd;
         v_row.intm_no := i.intm_no;
         v_row.cs_no := i.comm_slip_no;
         v_row.cs_pref := i.comm_slip_pref;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE update_comm_slip_ext(
      p_fund_cd        IN     giis_funds.fund_cd%TYPE,
      p_branch_cd      IN     giac_branches.branch_cd%TYPE,
      p_gacc_tran_id   IN     giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no        IN     giac_comm_slip_ext.intm_no%TYPE,
      p_comm_slip_pref IN OUT giac_doc_sequence.doc_pref_suf%TYPE,
      p_comm_slip_seq  IN OUT giac_doc_sequence.doc_seq_no%TYPE,
      p_user_id        IN     giis_users.user_id%TYPE
   )
   IS
      v_doc_seq               VARCHAR2(1);
   BEGIN
      UPDATE giac_comm_slip_ext_temp
         SET printed_flag = 'P',
             comm_slip_pref = p_comm_slip_pref,
             comm_slip_no = p_comm_slip_seq
       WHERE NVL(generate_flag, 'N') = 'Y'
         AND gacc_tran_id = p_gacc_tran_id
         AND intm_no = p_intm_no;
         
      UPDATE giac_comm_slip_ext
         SET comm_slip_flag = 'P',
             comm_slip_pref = p_comm_slip_pref,
             comm_slip_no = p_comm_slip_seq,
             comm_slip_date = SYSDATE,
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE gacc_tran_id  = p_gacc_tran_id
         AND intm_no = p_intm_no;
         
      FOR doc IN (SELECT param_value_v
                    FROM giac_parameters
                   WHERE param_name = 'CS_PER_USER')
      LOOP
         v_doc_seq := doc.param_value_v;
      END LOOP;
      
      IF v_doc_seq = 'N' THEN
         UPDATE giac_doc_sequence
            SET doc_seq_no = doc_seq_no + 1            
          WHERE fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd                                  
            AND doc_name = 'COMM_SLIP';
      END IF;
      
      p_comm_slip_seq := p_comm_slip_seq + 1;
   END;
   
   PROCEDURE clear_comm_slip_no(
      p_gacc_tran_id          giac_comm_slip_ext.gacc_tran_id%TYPE,
      p_intm_no               giac_comm_slip_ext.intm_no%TYPE
   )
   IS
   BEGIN
      UPDATE giac_comm_slip_ext_temp
         SET comm_slip_pref = NULL,
             comm_slip_no = NULL,
             printed_flag = 'C'
       WHERE gacc_tran_id = p_gacc_tran_id
         AND intm_no = p_intm_no;
   END;

END;
/



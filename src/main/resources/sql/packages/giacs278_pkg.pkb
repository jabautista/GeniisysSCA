CREATE OR REPLACE PACKAGE BODY CPI.giacs278_pkg
AS
   FUNCTION get_list_ri_loss_ol_rec(
        P_LINE_CD       giac_loss_ri_collns.e150_line_cd%TYPE,
        P_LA_YY         giac_loss_ri_collns.e150_la_yy%TYPE,
        P_FLA_SEQ_NO    giac_loss_ri_collns.e150_fla_seq_no%TYPE
    )RETURN acc_list_ri_loss_overlay_tab PIPELINED
   IS
        v_list   acc_list_ri_loss_overlay_type;
   BEGIN
       FOR i IN (
                SELECT i.tran_id, i.tran_date, i.tran_class, i.jv_pref_suff, i.jv_no, i.tran_year, i.tran_month, i.tran_seq_no, 
                j.collection_amt, j.e150_line_cd, j.e150_la_yy, j.e150_fla_seq_no, i.tran_flag, get_ref_no(i.tran_id) ref_no
                  FROM GIAC_ACCTRANS I, GIAC_LOSS_RI_COLLNS J
                 WHERE 1 = 1 
                   AND i.tran_id = j.gacc_tran_id
                   AND j.e150_line_cd = P_LINE_CD
                   AND j.e150_la_yy =  P_LA_YY
                   AND j.e150_fla_seq_no = P_FLA_SEQ_NO
       ) LOOP
       v_list.tran_id := i.tran_id;
       v_list.tran_date := i.tran_date;
       v_list.tran_class := i.tran_class;
       v_list.jv_pref_suff := i.jv_pref_suff;
       v_list.jv_no  := i.jv_no;
       v_list.tran_year := i.tran_year;
       v_list.tran_month := i.tran_month;
       v_list.tran_seq_no := i.tran_seq_no;
       v_list.collection_amt := i.collection_amt;
       v_list.e150_line_cd := i.e150_line_cd;
       v_list.e150_la_yy := i.e150_la_yy;
       v_list.e150_fla_seq_no := i.e150_fla_seq_no;
       v_list.tran_flag := i.tran_flag;
       v_list.ref_no := i.ref_no;
       PIPE ROW (v_list);
       END LOOP;
       RETURN;
   NULL;
   END get_list_ri_loss_ol_rec;
   
   FUNCTION get_list_ri_loss_rec (p_line_cd gicl_claims.line_cd%TYPE, p_ri_cd gicl_claims.ri_cd%TYPE)
      RETURN acc_list_ri_loss_recov_tab PIPELINED
   IS
      v_list   acc_list_ri_loss_recov_type;
   BEGIN
      FOR i IN ((SELECT a.claim_id, 
                    a.line_cd||'-'||a.la_yy||'-'||LTRIM (TO_CHAR (a.fla_seq_no, '0999999')) fla_number,
                    get_claim_number(a.claim_id) claim_number, 
                    b.payee_type, 
                    DECODE(b.payee_type, 'L', b.loss_shr_amt, 'E', b.exp_shr_amt) exp_shr_amt,
                    a.print_sw,
                    a.grp_seq_no,
                    a.fla_id,
                    a.line_cd,
                    a.ri_cd, 
                    a.la_yy, 
                    a.fla_seq_no, 
                    a.share_type,  
                    a.adv_fla_id,  
                    b.loss_shr_amt, 
                    b.exp_shr_amt exp_shr_amt2,
                    c.line_cd ||'-'||       
	                c.subline_cd||'-'||     
	                c.pol_iss_cd||'-'||
                    LTRIM (TO_CHAR (c.issue_yy, '09'))||'-'||     
                    LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))||'-'||   
                    LTRIM (TO_CHAR (c.renew_no, '09'))  policy_number, 
                    c.assured_name  
                   FROM   GICL_ADVS_FLA A, GICL_ADVS_FLA_TYPE B, GICL_CLAIMS C
                  WHERE 1 = 1
                    AND a.claim_id = b.claim_id
                    AND a.claim_id = c.claim_id
                    AND a.grp_seq_no = b.grp_seq_no
                    AND a.fla_id = b.fla_id
                    AND NVL (cancel_tag, 'N') = 'N'
                    AND a.share_type = 3
                    AND a.line_cd = p_line_cd                                                                                                                          --'MH'  -- temp
                    AND a.ri_cd = p_ri_cd                                                                                                                            --  262      --temp
                    AND NOT EXISTS (SELECT 1
                                      FROM gicl_advice c
                                     WHERE 1 = 1 AND c.claim_id = a.claim_id AND c.adv_fla_id = a.adv_fla_id AND NVL (c.advice_flag, 'N') = 'N')
                    AND (SELECT check_user_per_iss_cd_acctg (NULL, iss_cd, 'GIACS278')
                           FROM gicl_claims
                          WHERE 1 = 1 AND claim_id = a.claim_id AND line_cd = a.line_cd) = 1))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.fla_number := i.fla_number;
         v_list.claim_number := i.claim_number;
         v_list.payee_type := i.payee_type;
         v_list.exp_shr_amt := i.exp_shr_amt;
         v_list.print_sw := i.print_sw;
         v_list.grp_seq_no := i.grp_seq_no;
         v_list.fla_id := i.fla_id;
         v_list.line_cd  := i.line_cd ;
         v_list.ri_cd := i.ri_cd;
         v_list.la_yy := i.la_yy;
         v_list.fla_seq_no := i.fla_seq_no;
         v_list.share_type := i.share_type;
         v_list.adv_fla_id := i.adv_fla_id;
         v_list.loss_shr_amt := i.loss_shr_amt;
         v_list.exp_shr_amt2 := i.exp_shr_amt2;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_list_ri_loss_rec;
   
   --added by john dolon 7.30.2013
   FUNCTION get_ri_list(p_ri_cd VARCHAR2)
    RETURN ri_list_tab PIPELINED IS
     v_reinsurer ri_list_type;
    BEGIN
         FOR i IN (SELECT ri_cd, ri_name 
		 			FROM GIIS_REINSURER 
                    WHERE ri_cd = NVL(p_ri_cd, ri_cd)
					ORDER by ri_cd)
       LOOP
         v_reinsurer.ri_cd        := i.ri_cd;
         v_reinsurer.ri_name      := i.ri_name;
         PIPE ROW(v_reinsurer);
       END LOOP;        
    RETURN;
    END get_ri_list;
    
    FUNCTION get_line_list(p_line_cd VARCHAR2)
    RETURN line_list_tab PIPELINED
    IS
      v_giis_line   line_list_type;
    BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM GIIS_LINE
                    --WHERE line_cd = NVL(p_line_cd, line_cd)
                    WHERE line_cd LIKE NVL(p_line_cd, line_cd) --modified johndolon 9.2.2013
                ORDER BY line_cd)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
    END get_line_list;
END;
/



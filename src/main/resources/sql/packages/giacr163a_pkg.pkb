CREATE OR REPLACE PACKAGE BODY CPI.GIACR163A_PKG
AS
    /** Created By:      Shan Bati
     ** Date Created:   08.15.2013
     ** Referenced By:  GIACR163A - Overriding Commission Voucher (Detail)
     **/
    
    FUNCTION populate_report(
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_comm_vcr_no       VARCHAR2
    ) RETURN detail_tab PIPELINED
    AS
        rep         detail_type;
        v_rec_exist boolean := false;
        v_ctr       number := 0;
    BEGIN
        --remove by steven 10.08.2014     
        /*FOR a IN (SELECT *
                    FROM giis_document
                   WHERE title = 'GIACR163A_IMAGE'
                     AND report_id = 'GIACR163A')
        LOOP
            rep.header_img_path := a.text;
        END LOOP;*/
        
        rep.header_img_path := giisp.v ('LOGO_FILE');
            
        FOR i IN  ( SELECT intm_no, chld_intm_no, ref_no,
                           policy_id, policy_no, lpad(policy_no,2) line_cd, 
                           premium_amt prem_amt, commission_due comm_amt,
                           withholding_tax tax, advances adv, input_vat vat, 
                           assd_no assd, get_assd_name(assd_no) assd_name, iss_cd, prem_seq_no,
                           iss_cd ||'-'||prem_seq_no bill_no, ocv_no
                      FROM  giac_parent_comm_voucher
                     WHERE print_tag  = 'Y'
                       --AND print_date IS NULL
                       AND intm_no = nvl(p_intm_no,intm_no)
                       AND ocv_no = nvl(p_comm_vcr_no,ocv_no) 
                     ORDER BY assd_no)
        LOOP
            v_rec_exist         := TRUE;
            rep.print_details   := 'Y';
            rep.intm_no         := i.intm_no;
            rep.chld_intm_no    := i.chld_intm_no;
            rep.iss_cd          := i.iss_cd;
            rep.prem_seq_no     := i.prem_seq_no;
            rep.ref_no          := i.ref_no;
            rep.policy_id       := i.policy_id;
            rep.policy_no       := i.policy_no;
            rep.assd_no         := i.assd;
            rep.assd_name       := i.assd_name;
            rep.bill_no         := i.bill_no;
            
            IF i.ocv_no = p_comm_vcr_no THEN
                v_ctr   := v_ctr + 1;
            
                IF v_ctr = 1 THEN
                    BEGIN
                        --intermediary name
                        FOR d IN(SELECT intm_no||' - '||intm_name||' / '||ref_intm_cd intm
                                   FROM giis_intermediary
                                  WHERE intm_no = i.intm_no)--from main loop 
                        LOOP
                            rep.intm_name  := d.intm;
                        END LOOP;
                    EXCEPTION
                        WHEN no_data_found THEN
                            rep.intm_name   := null;
                    END;
                END IF;
            END IF;
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_rec_exist = FALSE THEN
            rep.print_details   := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;

    
    FUNCTION get_peril(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_chld_intm_no  giac_parent_comm_voucher.CHLD_INTM_NO%type,
        p_iss_cd        giac_parent_comm_voucher.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_voucher.PREM_SEQ_NO%type
    ) RETURN peril_tab PIPELINED
    AS
        rep     peril_type;
    BEGIN
        FOR j IN  ( SELECT a.intm_no, a.chld_intm_no, ref_no, policy_id,
                           policy_no, LPAD(policy_no,2) line_cd, b.premium_amt	prem_amt,		  
                           b.commission_amt comm_amt, commission_rt, b.wholding_tax,		  
                           withholding_tax tax, advances adv, input_vat vat,
                           assd_no assd, get_assd_name(assd_no) assd_name, a.iss_cd,a.prem_seq_no,
                           a.iss_cd ||'-'||a.prem_seq_no bill_no,peril_sname
                      FROM  giac_parent_comm_voucher a, giac_parent_comm_invprl b ,giis_peril c
                     WHERE a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.intm_no = b.intm_no
                       and LPAD(policy_no,2) = c.line_cd
                       and b.peril_cd = c.peril_cd
                       ----
                       AND a.intm_no = p_intm_no
                       AND a.iss_cd = p_iss_cd
                       AND a.chld_intm_no = p_chld_intm_no
                       AND a.prem_seq_no = p_prem_seq_no
                     ORDER BY peril_sname)
        LOOP
            rep.peril_sname     := j.peril_sname;
            rep.prem_amt        := j.prem_amt;
            rep.comm_rt         := j.commission_rt;
            rep.comm_amt        := j.comm_amt;
                
            PIPE ROW(rep);
        END LOOP;
    END get_peril;
    
    
    /** CF_Q_1 program unit **/
    FUNCTION compute_totals (
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_comm_vcr_no       VARCHAR2
    ) RETURN totals_tab PIPELINED
    AS
        rep                 totals_type;
        v_ctr               NUMBER  := 0;
        v_line_cd1          VARCHAR2(2);
        v_line_cd2          VARCHAR2(2);
        v_line_flag         VARCHAR2(1) := 'N';  
        v_assd_name1        VARCHAR2(750);
        v_assd_name2        VARCHAR2(750);
        v_assd_flag         VARCHAR2(1) := 'N';  
        v_pol1              VARCHAR2(50);
        v_pol2              VARCHAR2(50);
        v_pol_flag          VARCHAR2(1) := 'N';
        v_child_input_vat   NUMBER := 0;
        v_cp_sum_whtax      NUMBER(16,2);
        v_cp_sum_adv        NUMBER(16,2);
        v_cp_sum_comm       NUMBER(16,2);
        v_cp_sum_ivat       NUMBER(16,2);
    BEGIN
        --cp_sum_prem         := 0;
        v_cp_sum_comm         := 0;
        v_cp_sum_whtax        := 0;
        v_cp_sum_adv          := 0;
        v_cp_sum_ivat         := 0;
        --:cp_ctr              := 'N';
        
        FOR main IN  ( SELECT intm_no,
                               policy_id,
                               policy_no,
                               LPAD(policy_no, 2)  line_cd,
                               NVL(premium_amt, 0)	             prem_amt,
                               NVL(commission_due, 0)            comm_amt,
                               NVL(withholding_tax, 0)           whtax,
                               NVL(advances, 0)    	             adv,
                               NVL(input_vat, 0)    	         ivat,
                               get_assd_name(assd_no) assd_name,
                               iss_cd,
                               prem_seq_no,GFUN_FUND_CD,chld_intm_no
                          FROM giac_parent_comm_voucher
                         WHERE print_tag  = 'Y'
                           --AND print_date IS NULL
                           AND intm_no = p_intm_no
                           AND ocv_no = p_comm_vcr_no)
        LOOP
  	        v_ctr := v_ctr + 1;
            
            	IF v_ctr = 1 THEN--single record
                    /** commented for the mean time 08.16.2013 **/
                    /*:cp_pol_no := main.policy_no;
                    :cp_assd_name := main.assd_name;  		
                    v_line_cd1 := main.line_cd;
                    v_assd_name1 := main.assd_name;
                    v_pol1 := main.policy_no;
              		
                    --line name
                    FOR b IN (SELECT line_name
                                FROM giis_line
                               WHERE line_cd = main.line_cd)
                    LOOP
                        :cp_line_name := b.line_name;
                    END LOOP;--b	*/
                  
                    FOR civ IN (SELECT a.input_vat
                                  FROM giac_comm_voucher_ext a
                                 WHERE a.fund_cd = main.gfun_fund_cd
                                   AND a.intm_no = main.chld_intm_no)
                    LOOP
                        v_child_input_vat := civ.input_vat;
                    END LOOP;   	
            			
                    /*--endorsement
                    FOR e IN(SELECT endt_iss_cd||' -'||TO_CHAR(endt_yy,'09')||' -'||TO_CHAR(NVL(endt_seq_no, 0), '099999') endt, 
                                    NVL(endt_seq_no, 0) endt_seq_no
                               FROM gipi_polbasic
                              WHERE policy_id = main.policy_id) --from main loop 
                    LOOP
                        IF e.endt_seq_no = 0 THEN
                            :cp_endt_no := ' ';
                        ELSE
                            :cp_endt_no := e.endt;
                        END IF;      	
                    END LOOP;--e
                  
                    /***  already in the populate_report function  *** /
                    --intermediary name
                    FOR d IN(SELECT intm_no||' - '||intm_name||' / '||ref_intm_cd intm
                               FROM giis_intermediary
                              WHERE intm_no = main.intm_no)--from main loop 
                    LOOP
                      :cp_intm_name := d.intm;
                    END LOOP;--d */
            ELSE--for multiple data 
                NULL;
                /****** commented for the mean time 08.16.2013  *****/
                /*
                --for multiple Policies
                    v_pol2 := main.policy_no;
                    IF v_pol1 <> v_pol2  AND v_pol_flag = 'N' THEN
                        v_pol_flag := 'Y'; --indicates multiple policy
                        :cp_pol_no  := '   Various Policies';  		
                      :cp_endt_no := ' ';
                    :cp_ctr := 'Y';
                    END IF;	  	  

                --for multiple line
                    v_line_cd2 := main.line_cd;
                    IF v_line_cd1 <> v_line_cd2  AND v_line_flag = 'N' THEN
                        v_line_flag := 'Y'; --indicates multiple lines
                        :cp_line_name := '   Various Lines';
                    END IF;	  	  

                --for multiple assured
                    v_assd_name2 := main.assd_name;
                    IF v_assd_name1 <> v_assd_name2  AND v_assd_flag = 'N' THEN
                        v_assd_flag := 'Y'; --indicates multiple assd
                        :cp_assd_name := '   Various Assured';
                    END IF;	  */	  
            END IF;--v_ctr 
            
            --sums
            --:cp_sum_prem   := :cp_sum_prem + main.prem_amt;
            v_cp_sum_comm   := v_cp_sum_comm + main.comm_amt;
            v_cp_sum_whtax  := v_cp_sum_whtax + main.whtax;
            v_cp_sum_adv    := v_cp_sum_adv + main.adv;
            v_cp_sum_ivat   := v_cp_sum_ivat + main.ivat + v_child_input_vat;
        END LOOP;
        
        rep.sum_comm    := v_cp_sum_comm;
        rep.sum_ivat    := v_cp_sum_ivat;
        rep.sum_whtax_n := -1 * v_cp_sum_whtax;
        rep.sum_adv_n   := -1 * v_cp_sum_adv;
        
        --totals
        rep.net_due := v_cp_sum_comm + v_cp_sum_ivat - v_cp_sum_whtax - v_cp_sum_adv;
        rep.total := v_cp_sum_comm + v_cp_sum_ivat;
        
        PIPE ROW(rep);
    END compute_totals;

END GIACR163A_PKG;
/



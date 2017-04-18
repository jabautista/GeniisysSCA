CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_COMM_INV_PERIL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_comm_inv_peril (p_par_id 	GIPI_ORIG_COMM_INV_PERIL.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_COMM_INV_PERIL
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_comm_inv_peril;
    
    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 05.05.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Get gipi_orig_comm_inv_peril records of a given par_id
    */

    FUNCTION get_gipi_orig_comm_inv_peril(p_par_id    GIPI_ORIG_COMM_INV_PERIL.par_id%TYPE,
                                          p_line_cd   GIIS_LINE.line_cd%TYPE)
     
    RETURN gipi_orig_comm_inv_peril_tab PIPELINED

    IS

    v_orig_comm_inv_peril       gipi_orig_comm_inv_peril_type;

    BEGIN
        FOR i IN(SELECT a.par_id, a.intrmdry_intm_no, a.item_grp,
                        a.peril_cd, b.peril_name, a.premium_amt, a.policy_id,
                        a.iss_cd, a.prem_seq_no, a.commission_amt,
                        a.commission_rt, a.wholding_tax 
                FROM GIPI_ORIG_COMM_INV_PERIL a,
                     GIIS_PERIL b
                WHERE a.par_id = p_par_id
                  AND b.line_cd = p_line_cd
                  AND a.peril_cd = b.peril_cd
                ORDER BY a.item_grp)
        LOOP
            v_orig_comm_inv_peril.par_id            :=  i.par_id;             
            v_orig_comm_inv_peril.intrmdry_intm_no  :=  i.intrmdry_intm_no; 
            v_orig_comm_inv_peril.item_grp          :=  i.item_grp;  
            v_orig_comm_inv_peril.peril_cd          :=  i.peril_cd;  
            v_orig_comm_inv_peril.peril_name        :=  i.peril_name;  
            v_orig_comm_inv_peril.premium_amt       :=  i.premium_amt; 
            v_orig_comm_inv_peril.policy_id         :=  i.policy_id; 
            v_orig_comm_inv_peril.iss_cd            :=  i.iss_cd;  
            v_orig_comm_inv_peril.prem_seq_no       :=  i.prem_seq_no;  
            v_orig_comm_inv_peril.commission_amt    :=  i.commission_amt;
            v_orig_comm_inv_peril.commission_rt     :=  i.commission_rt;
            v_orig_comm_inv_peril.wholding_tax      :=  i.wholding_tax;
             v_orig_comm_inv_peril.net_commission    :=  NVL(i.commission_amt,0) - NVL(i.wholding_tax,0);
            
            GIPI_WCOMM_INV_PERILS_PKG.get_wcomm_inv_perils_amt_colmn(i.par_id,   i.item_grp,       
                                                                     i.intrmdry_intm_no, i.peril_cd, 
                                                                     v_orig_comm_inv_peril.share_premium_amt, 
                                                                     v_orig_comm_inv_peril.share_commission_rt,
                                                                     v_orig_comm_inv_peril.share_commission_amt, 
                                                                     v_orig_comm_inv_peril.share_wholding_tax,
                                                                     v_orig_comm_inv_peril.share_net_commission);
            PIPE ROW(v_orig_comm_inv_peril);
        END LOOP;
    END;
    
    /*
    **  Created by        : Moses Calma
    **  Date Created     : 05.30.2011
    **  Reference By     : (GIPIS100 - Policy Basic Info / Lead Policy )
    **  Description     : retrieves list of invoice commission perils 
    **                      given the policy_id,item_grp and intrmdry_intm_no
    */
    FUNCTION get_comm_inv_perils (
       p_policy_id          gipi_orig_comm_inv_peril.policy_id%TYPE,
       p_item_grp           gipi_orig_comm_inv_peril.item_grp%TYPE,
       p_intrmdry_intm_no   gipi_orig_comm_inv_peril.intrmdry_intm_no%TYPE
    )
       RETURN comm_inv_peril_tab PIPELINED
    IS
       v_comm_inv_peril   comm_inv_peril_type;
       v_line_cd          gipi_polbasic.line_cd%TYPE;
       v_peril_name       giis_peril.peril_name%TYPE;
       v_peril_sname      giis_peril.peril_sname%TYPE;
    BEGIN
       FOR i IN (SELECT par_id, intrmdry_intm_no, item_grp, peril_cd, policy_id,
                        iss_cd, prem_seq_no, premium_amt, commission_amt,
                        commission_rt, wholding_tax
                   FROM gipi_orig_comm_inv_peril
                  WHERE policy_id = p_policy_id
                    AND item_grp = p_item_grp
                    AND intrmdry_intm_no = p_intrmdry_intm_no)
       LOOP
          v_comm_inv_peril.par_id               := i.par_id;
          v_comm_inv_peril.item_grp             := i.item_grp;
          v_comm_inv_peril.peril_cd             := i.peril_cd;
          v_comm_inv_peril.policy_id            := i.policy_id;
          v_comm_inv_peril.iss_cd               := i.iss_cd;
          v_comm_inv_peril.prem_seq_no          := i.prem_seq_no;
          v_comm_inv_peril.intrmdry_intm_no     := i.intrmdry_intm_no;
          
          v_comm_inv_peril.full_premium_amt     := i.premium_amt;
          v_comm_inv_peril.full_commission_amt  := i.commission_amt;
          v_comm_inv_peril.full_commission_rt   := i.commission_rt;
          v_comm_inv_peril.full_wholding_tax    := i.wholding_tax;
          
          BEGIN
          
          SELECT line_cd
            INTO v_line_cd
            FROM gipi_polbasic
           WHERE policy_id = i.policy_id;
          
          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            v_line_cd := '';
            
          END;

          BEGIN
          
          SELECT premium_amt,
                 commission_rt,
                 wholding_tax,
                 commission_amt
            INTO v_comm_inv_peril.your_premium_amt,
                 v_comm_inv_peril.your_commission_rt,
                 v_comm_inv_peril.your_wholding_tax,
                 v_comm_inv_peril.your_commission_amt
            FROM gipi_comm_inv_peril
           WHERE iss_cd = i.iss_cd
             AND prem_seq_no = i.prem_seq_no
             AND intrmdry_intm_no = i.intrmdry_intm_no
             AND peril_cd = i.peril_cd;
                     
          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
          
            v_comm_inv_peril.your_premium_amt       := '';
            v_comm_inv_peril.your_commission_rt     := '';
            v_comm_inv_peril.your_commission_amt    := '';
            v_comm_inv_peril.your_wholding_tax      := '';
            
          END;

          BEGIN
          
          SELECT peril_name, peril_sname
            INTO v_peril_name, v_peril_sname
            FROM giis_peril
           WHERE line_cd = v_line_cd 
             AND peril_cd = i.peril_cd;
             
          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             
             v_peril_name   := '';
             v_peril_sname  := '';
             
          END;

          v_comm_inv_peril.full_peril_sname := v_peril_sname;
          v_comm_inv_peril.your_peril_sname := v_peril_sname;
          v_comm_inv_peril.full_peril_name := v_peril_name;
          v_comm_inv_peril.your_peril_name := v_peril_name;
          v_comm_inv_peril.your_net_commission :=
               NVL (v_comm_inv_peril.your_commission_amt, 0)
             - NVL (v_comm_inv_peril.your_wholding_tax, 0);
          v_comm_inv_peril.full_net_commission :=
               NVL (v_comm_inv_peril.full_commission_amt, 0)
             - NVL (v_comm_inv_peril.your_wholding_tax, 0);
             
          PIPE ROW (v_comm_inv_peril);
          
       END LOOP;
       
    END get_comm_inv_perils;

END GIPI_ORIG_COMM_INV_PERIL_PKG;
/



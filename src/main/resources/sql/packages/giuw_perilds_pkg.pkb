CREATE OR REPLACE PACKAGE BODY CPI.GIUW_PERILDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_perilds (p_dist_no 	GIUW_PERILDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIUW_PERILDS
		 WHERE dist_no  =  p_dist_no;
	END del_giuw_perilds;
    
    FUNCTION get_giuw_perilds (p_dist_no IN giuw_perilds.dist_no%TYPE)
      RETURN giuw_perilds_tab PIPELINED
    IS
        v_giuw_perilds giuw_perilds_type;
    BEGIN
        FOR i IN (
            SELECT a.dist_no,        a.dist_seq_no,     a.peril_cd,        a.line_cd,
                   a.tsi_amt,        a.prem_amt,        a.ann_tsi_amt,     a.cpi_rec_no,
                   a.cpi_branch_cd,  a.arc_ext_data,    b.peril_name,      c.policy_id  --added policy_id Halley 09.27.2013     
              FROM giuw_perilds a,
                   giis_peril b,
                   giuw_pol_dist c  --added giuw_pol_dist Halley 09.27.2013   
             WHERE a.dist_no = p_dist_no
               AND a.peril_cd = b.peril_cd
               AND a.line_cd = b.line_cd
               AND a.dist_no = c.dist_no)  
        LOOP
            v_giuw_perilds.dist_no            := i.dist_no;
            v_giuw_perilds.dist_seq_no        := i.dist_seq_no;
            v_giuw_perilds.peril_cd           := i.peril_cd;
            v_giuw_perilds.peril_name         := i.peril_name;
            v_giuw_perilds.line_cd            := i.line_cd;
            v_giuw_perilds.tsi_amt            := i.tsi_amt;
            v_giuw_perilds.prem_amt           := i.prem_amt;
            v_giuw_perilds.ann_tsi_amt        := i.ann_tsi_amt;
            v_giuw_perilds.cpi_rec_no         := i.cpi_rec_no;
            v_giuw_perilds.cpi_branch_cd      := i.cpi_branch_cd;
            v_giuw_perilds.arc_ext_data       := i.arc_ext_data;           
            
            --added by Halley 09.27.2013
            SELECT currency_desc
              INTO v_giuw_perilds.currency_desc
              FROM giis_currency
             WHERE main_currency_cd IN (SELECT currency_cd
                                          FROM gipi_invoice
                                         WHERE policy_id = i.policy_id
                                           AND item_grp IN (SELECT NVL(item_grp, 1)
                                                              FROM giuw_pol_dist
                                                             WHERE policy_id = i.policy_id));     
            --end 09.27.2013                                                              
            
            PIPE ROW(v_giuw_perilds);
        END LOOP;
        
        RETURN;
    END get_giuw_perilds;
    
END GIUW_PERILDS_PKG;
/



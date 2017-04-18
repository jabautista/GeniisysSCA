CREATE OR REPLACE PACKAGE BODY CPI.GIRI_WFRPS_PERIL_GRP_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/

	PROCEDURE del_giri_wfrps_peril_grp(
		p_line_cd		GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
		p_frps_yy		GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
		p_frps_seq_no	GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE)
	IS
	BEGIN
		DELETE GIRI_WFRPS_PERIL_GRP
		 WHERE line_cd = p_line_cd
		   AND frps_yy = p_frps_yy
		   AND frps_seq_no = p_frps_seq_no;
	END del_giri_wfrps_peril_grp;
	
   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : POPULATE_WFRGROUP program unit  
   */  
    PROCEDURE POPULATE_WFRGROUP(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        ) IS
      x        NUMBER;
      CURSOR tmp_area IS
        SELECT t1.peril_cd,
               peril_sname,  
               tsi_amt,
               prem_amt,     
               dist_spct tot_fac_spct, 
               dist_prem tot_fac_prem, 
               dist_tsi  tot_fac_tsi     
          FROM giuw_perilds_dtl T1
               ,giis_dist_share T2
               ,giuw_perilds    T3
               ,giis_peril      T4
         WHERE T1.line_cd     = T2.line_cd
           AND T1.share_cd    = T2.share_cd
           AND T2.share_type  = '3'   
           AND T1.dist_no     = T3.dist_no
           AND T1.dist_seq_no = T3.dist_seq_no
           AND T1.line_cd     = T3.line_cd
           AND T1.peril_cd    = T3.peril_cd 
           AND T1.line_cd     = T4.line_cd
           AND T1.peril_cd    = T4.peril_cd
           AND T1.dist_no     = p_dist_no
           AND T1.dist_seq_no = p_dist_seq_no 
         ORDER BY dist_tsi desc, T4.peril_cd; --Melvin John O. Ostia 07182014 added peril_cd -- applied by bonok :: 09.25.2014
     
    BEGIN
      x := 1;
      FOR c1_rec in tmp_area LOOP
          INSERT INTO GIRI_WFRPS_PERIL_GRP
            (line_cd, frps_yy, frps_seq_no, peril_seq_no,           
             peril_cd, tsi_amt, prem_amt, peril_title,
             remarks, tot_fac_spct, tot_fac_prem, tot_fac_tsi)
          VALUES
            (p_line_cd, p_frps_yy, p_frps_seq_no, x,
             c1_rec.peril_cd, c1_rec.tsi_amt, c1_rec.prem_amt, c1_rec.peril_sname,
             'insert', c1_rec.tot_fac_spct, c1_rec.tot_fac_prem, c1_rec.tot_fac_tsi);
        x := x+1;
      END LOOP;
    END;    
    
    /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Copy data from GIRI_FRPS_PERIL_GRP to GIRI_WFRPS_PERIL_GRP
     **                     for records not tagged for reversal
     */
    PROCEDURE copy_frps_peril_grp(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE
    ) 
    IS
      CURSOR frps_peril_grp IS
        SELECT line_cd, frps_yy, frps_seq_no,
               peril_seq_no, peril_cd, peril_title,
               tsi_amt, prem_amt, remarks,
               tot_fac_spct, tot_fac_prem, tot_fac_tsi
          FROM giri_frps_peril_grp a
         WHERE a.line_cd       = p_line_cd
           AND a.frps_yy       = p_frps_yy
           AND a.frps_seq_no   = p_frps_seq_no;
    BEGIN
      FOR c1_rec IN frps_peril_grp LOOP
        INSERT INTO giri_wfrps_peril_grp 
            (line_cd, frps_yy, frps_seq_no,
             peril_seq_no, peril_cd, peril_title,
             tsi_amt, prem_amt, remarks,
             tot_fac_spct, tot_fac_prem, tot_fac_tsi)
          VALUES
            (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
             c1_rec.peril_seq_no, c1_rec.peril_cd, c1_rec.peril_title,
             c1_rec.tsi_amt, c1_rec.prem_amt, c1_rec.remarks,
             c1_rec.tot_fac_spct, c1_rec.tot_fac_prem, c1_rec.tot_fac_tsi);
      END LOOP;
    END copy_frps_peril_grp;
     
END GIRI_WFRPS_PERIL_GRP_PKG;
/



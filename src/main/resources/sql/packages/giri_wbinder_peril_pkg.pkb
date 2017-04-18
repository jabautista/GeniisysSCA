CREATE OR REPLACE PACKAGE BODY CPI.GIRI_WBINDER_PERIL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/

	PROCEDURE del_giri_wbinder_peril(p_pre_binder_id	GIRI_WBINDER_PERIL.pre_binder_id%TYPE)
	IS
	BEGIN
		DELETE GIRI_WBINDER_PERIL
		 WHERE pre_binder_id = p_pre_binder_id;
	END del_giri_wbinder_peril;
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  07-05-2011
    **  Reference By : GIRIS002 - Enter RI Acceptance
    **  Description  :
    */    
    PROCEDURE create_binder_peril_giris002 (
        p_line_cd       giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
    ) IS
        v_ri_shr_pct            giri_wfrperil.ri_shr_pct%type;
        v_ri_comm_Rt            giri_wfrperil.ri_comm_Rt%type;
        v_ri_prem_vat     giri_wfrperil.ri_prem_vat%TYPE;
        CURSOR wperil_area IS
            SELECT pre_binder_id, peril_seq_no,
                         SUM(T1.prem_tax) prem_tax,
                       SUM(T1.ri_tsi_amt) ri_tsi_amt,     
                   SUM(T1.ri_prem_amt) ri_prem_amt, 
                   SUM(T1.ri_comm_amt) ri_comm_amt,
                   SUM(tsi_amt) tsi_amt,
                   SUM(prem_amt) prem_amt,
                   SUM(T1.ri_prem_vat) ri_prem_vat, 
                   SUM(T1.ri_comm_vat) ri_comm_vat
              FROM giri_wfrperil T1, giri_wfrps_ri T2, giri_wfrps_peril_grp T3, giis_parameters T4
             WHERE T1.line_cd     = T2.line_cd
               AND T1.frps_yy     = T2.frps_yy
               AND T1.frps_seq_no = T2.frps_seq_no
               AND T1.ri_seq_no   = T2.ri_seq_no
               AND T2.line_cd     = T3.line_cd
               AND T2.frps_yy     = T3.frps_yy
               AND T1.frps_seq_no = T3.frps_seq_no
               AND T1.peril_cd    = T3.peril_cd  
               AND T1.line_cd     = p_line_cd
               AND T1.frps_yy     = p_frps_yy
               AND T1.frps_seq_no = p_frps_seq_no
               AND T4.param_name = 'RI PREMIUM TAX'
               AND EXISTS(SELECT '1'
                            FROM giri_wbinder T4
                           WHERE T4.pre_binder_id = T2.pre_binder_id)
        GROUP BY pre_binder_id, peril_seq_no, param_value_n;
    BEGIN
          FOR c1_rec IN wperil_area LOOP
            IF c1_rec.tsi_amt != 0 THEN
              v_ri_shr_pct := (c1_rec.ri_tsi_amt/c1_rec.tsi_amt) * 100; 
            ELSE
              IF c1_rec.prem_amt != 0 THEN
                v_ri_shr_pct := (c1_rec.ri_prem_amt/c1_rec.prem_amt) * 100;
              ELSE
                v_ri_shr_pct := 0;
              END IF;
            END IF;
            IF c1_rec.prem_amt != 0 THEN
                 FOR A IN (SELECT A.ri_comm_rt
                             FROM giri_wfrperil A, giri_wfrps_peril_grp B
                           WHERE a.line_cd    = p_line_cd
                           AND a.frps_yy      = p_frps_yy
                           AND a.frps_seq_no  = p_frps_seq_no   
                           AND a.line_cd      = b.line_cd               
                           AND a.frps_yy      = b.frps_yy
                           AND a.frps_seq_no  = b.frps_seq_no   
                           AND b.peril_seq_no = c1_rec.peril_seq_no
                           AND a.peril_cd     = b.peril_cd ) LOOP
                v_ri_comm_rt := a.ri_comm_rt;
                EXIT;
               END LOOP; 
            ELSE
              v_ri_comm_rt := 0;
            END IF;
            INSERT INTO giri_wbinder_peril
              (pre_binder_id, peril_seq_no, ri_tsi_amt,     
               ri_shr_pct,    ri_prem_amt,  ri_comm_rt,
               ri_comm_amt,   ri_prem_vat,  ri_comm_vat
               ,prem_tax)
            VALUES
              (c1_rec.pre_binder_id, c1_rec.peril_seq_no, c1_rec.ri_tsi_amt,     
               v_ri_shr_pct,         c1_rec.ri_prem_amt,  v_ri_comm_rt,
               c1_rec.ri_comm_amt,   c1_rec.ri_prem_vat,  c1_rec.ri_comm_vat
               ,c1_rec.prem_tax);
          END LOOP;
    END create_binder_peril_giris002;
    
    
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Copy data from GIRI_BINDER_PERIL to GIRI_WBINDER_PERIL
     **                     for records not tagged for reversal.
     */
    PROCEDURE copy_binder_peril(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_fnl_binder_id IN giri_frps_ri.fnl_binder_id%TYPE
    ) 
    IS
      CURSOR binder_peril IS
        SELECT c.fnl_binder_id, c.peril_seq_no,
               c.ri_tsi_amt, c.ri_shr_pct, c.ri_prem_amt,
               c.ri_comm_rt, c.ri_comm_amt,
               --added other columns by j.diago 09.17.2014
               c.ri_prem_vat, c.ri_comm_vat,
       		   c.prem_tax--, c.peril_cd
          FROM giri_frps_ri a, giri_binder b, giri_binder_peril c
         WHERE a.line_cd         = p_line_cd
           AND a.frps_yy         = p_frps_yy
           AND a.frps_seq_no     = p_frps_seq_no
           AND a.fnl_binder_id   = b.fnl_binder_id
           AND b.fnl_binder_id   = c.fnl_binder_id
           AND c.fnl_binder_id   = p_fnl_binder_id;
    BEGIN
      FOR c1_rec IN binder_peril LOOP
        INSERT INTO giri_wbinder_peril
            (pre_binder_id, peril_seq_no,
             ri_tsi_amt, ri_shr_pct, ri_prem_amt,
             ri_comm_rt, ri_comm_amt,
             ri_prem_vat, ri_comm_vat,
       	     prem_tax/*, peril_cd*/)
          VALUES
            (c1_rec.fnl_binder_id, c1_rec.peril_seq_no,
             c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct, c1_rec.ri_prem_amt,
             c1_rec.ri_comm_rt, c1_rec.ri_comm_amt,
             c1_rec.ri_prem_vat, c1_rec.ri_comm_vat,
       	     c1_rec.prem_tax/*, c1_rec.peril_cd*/);
      END LOOP;
    END copy_binder_peril;
	
END GIRI_WBINDER_PERIL_PKG;
/



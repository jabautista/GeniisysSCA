DROP PROCEDURE CPI.SET_LIMIT_INTO_GIPI_WITMPERL;

CREATE OR REPLACE PROCEDURE CPI.SET_LIMIT_INTO_GIPI_WITMPERL(p_par_id          IN GIPI_WOPEN_LIAB.par_id%TYPE,
                                                             p_limit_liability IN GIPI_WOPEN_LIAB.limit_liability%TYPE,
                                                             p_line_cd         IN GIPI_WOPEN_PERIL.line_cd%TYPE,
                                                             p_iss_cd          IN GIPI_WPOLBAS.iss_cd%TYPE)
IS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to update witmperl record or insert if not existing. 
*/  
  p_dist_no  NUMBER;
  p_exist    NUMBER;
  v_exist    varchar2(1) := 'N';
  v_tsi_amt  gipi_wpolbas.tsi_amt%TYPE;
  v_cnt      NUMBER;
  
  CURSOR A IS
    SELECT   peril_cd, prem_rate
      FROM   gipi_wopen_peril
     WHERE   par_id  = p_par_id;
     
  CURSOR B(p_peril_cd  gipi_witmperl.peril_cd%TYPE) IS
    SELECT   peril_cd
      FROM   gipi_witmperl
     WHERE   par_id  = p_par_id
       AND   tsi_amt = p_limit_liability;
       
  CURSOR C IS
     SELECT  dist_no
       FROM  giuw_pol_dist
      WHERE  par_id  = p_par_id;
      
  CURSOR D IS
     SELECT  dist_no
       FROM  giuw_pol_dist
      WHERE  par_id  = p_par_id;
      
  CURSOR E(p_dist_no   giri_wdistfrps.dist_no%TYPE) IS
     SELECT  frps_seq_no,
             frps_yy
       FROM  giri_wdistfrps
      WHERE  dist_no = p_dist_no;
      
  CURSOR F(p_dist_no   giri_wdistfrps.dist_no%TYPE) IS
     SELECT  frps_seq_no,
             frps_yy
       FROM  giri_distfrps
      WHERE  dist_no = p_dist_no;

BEGIN
--  GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils_1(p_par_id);
--  GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_par_id); 
--  GIPI_WINVPERL_PKG.del_gipi_winvperl_1(p_par_id);
--  GIPI_WINV_TAX_PKG.del_gipi_winv_tax_1(p_par_id);
--  GIPI_WINSTALLMENT_PKG.del_gipi_winstallment_1(p_par_id);
--  GIPI_WINVOICE_PKG.del_gipi_winvoice(p_par_id);

  DELETE_WINVOICE(p_par_id);
 
  FOR B1 IN D LOOP
    GIUW_WITEMPERILDS_DTL_PKG.del_giuw_witemperilds_dtl(B1.dist_no);
    GIUW_WITEMPERILDS_PKG.del_giuw_witemperilds(B1.dist_no);
    GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(B1.dist_no);
    GIUW_WPERILDS_PKG.del_giuw_wperilds(B1.dist_no);
    GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(B1.dist_no);
    GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(B1.dist_no);
    GIUW_POLICYDS_DTL_PKG.del_giuw_policyds_dtl(B1.dist_no);
    GIUW_ITEMDS_DTL_PKG.del_giuw_itemds_dtl(B1.dist_no);
    GIUW_ITEMDS_PKG.del_giuw_itemds(B1.dist_no);                                                     
    GIUW_PERILDS_DTL_PKG.del_giuw_perilds_dtl(B1.dist_no);
    GIUW_PERILDS_PKG.del_giuw_perilds(B1.dist_no);
            
    GIUW_WITEMDS_PKG.del_giuw_witemds(B1.dist_no);
    GIUW_ITEMPERILDS_DTL_PKG.del_giuw_itemperilds_dtl(B1.dist_no);
    GIUW_ITEMPERILDS_PKG.del_giuw_itemperilds(B1.dist_no);
    
    FOR C1 IN E(B1.dist_no) LOOP
       GIRI_WDISTFRPS_PKG.del_giri_wdistfrps1(C1.frps_seq_no, C1.frps_yy);
    END LOOP;
    
    FOR C2 IN F(B1.dist_no) LOOP
       GIRI_FRPS_PERIL_GRP_PKG.del_giri_frps_peril_grp(C2.frps_seq_no, C2.frps_yy);
       GIRI_DISTFRPS_PKG.del_giri_distfrps(C2.frps_seq_no, C2.frps_yy);
    END LOOP;                        
    
    GIUW_POLICYDS_PKG.del_giuw_policyds(B1.dist_no);
    GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(B1.dist_no);         
    GIUW_POL_DIST_PKG.del_giuw_pol_dist(B1.dist_no);

  END LOOP;
   
  GIPI_WITMPERL_PKG.del_gipi_witmperl2(p_par_id);

  FOR cnt IN ( 
    SELECT COUNT(*) cnt
      FROM gipi_wopen_peril
     WHERE par_id = p_par_id)
  LOOP 
    v_cnt := cnt.cnt;
  END LOOP;
 
  FOR A1 IN A LOOP
     IF a1.prem_rate IS NOT NULL THEN
        v_tsi_amt := p_limit_liability;
     ELSE
       IF v_cnt = 1 THEN 
          v_tsi_amt := p_limit_liability;
       ELSE
          v_tsi_amt := 0;
       END IF;
     END IF;

     GIPI_WITMPERL_PKG.set_gipi_witmperl2(p_par_id, 1, p_line_cd, A1.peril_cd, 'N', a1.prem_rate,
                                          v_tsi_amt,ROUND(NVL(a1.prem_rate,0) * p_limit_liability / 100,2),
                                          v_tsi_amt,ROUND(NVL(a1.prem_rate,0) * p_limit_liability / 100,2));

     IF a1.prem_rate IS NOT NULL THEN
        v_exist := 'Y';
     END IF; 
     
  END LOOP;
  
  FOR item IN (
    SELECT item_no, SUM(prem_amt) prem_amt, tsi_amt,
           ann_tsi_amt, SUM(ann_prem_amt) ann_prem_amt
      FROM gipi_witmperl
     WHERE par_id = p_par_id
     GROUP BY item_no,tsi_amt,ann_tsi_amt)
  LOOP
    GIPI_WITEM_PKG.update_item_value(item.tsi_amt, item.prem_amt, item.ann_tsi_amt, item.ann_prem_amt, p_par_id, item.item_no);

    FOR tsi IN(SELECT sum(a.tsi_amt) tsi,
                      sum(a.ann_tsi_amt) ann_tsi
                 FROM gipi_witmperl a, giis_peril B
                WHERE a.par_id     = p_par_id
                  AND a.item_no    = item.item_no 
                  AND a.peril_cd   = b.peril_cd
                  AND a.line_cd    = b.line_cd
                  AND b.peril_type = 'B')
    LOOP
      GIPI_WITEM_PKG.SET_TSI(p_par_id, item.item_no, tsi.tsi, tsi.ann_tsi);
      EXIT;
    END LOOP;
  END LOOP;  
  
  IF v_exist = 'Y' THEN 
    CREATE_WINVOICE(0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
    CREATE_DISTRIBUTION_GIPIS005(p_par_id, p_dist_no);

     FOR A IN (
       SELECT par_id,par_status
         FROM gipi_parlist
        WHERE par_id = p_par_id
          FOR UPDATE OF par_id, par_status)
     LOOP
        GIPI_PARLIST_PKG.update_par_status(A.par_id, 5);
        EXIT;
     END LOOP;
  ELSE
     FOR A IN (
       SELECT par_id,par_status
         FROM gipi_parlist
        WHERE par_id = p_par_id
          FOR UPDATE OF par_id, par_status) 
     LOOP
        GIPI_PARLIST_PKG.update_par_status(A.par_id, 6);
        EXIT;
     END LOOP;       
  END IF;
  
END SET_LIMIT_INTO_GIPI_WITMPERL;
/



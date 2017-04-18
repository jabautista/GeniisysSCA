CREATE OR REPLACE PACKAGE BODY CPI.GIRI_WINPOLBAS_PKG AS
    
     /*
    **  Created by        : D.Alcantara
    **  Date Created      : 05.05.2011
    **  Reference By       : (GIRIS005 - ENTER INITIAL ACCEPTANCE)
    **  Description       :  saves / inserts records to giri_winpolbas
    */
    PROCEDURE set_giri_winpolbas (
        p_par_id            GIRI_WINPOLBAS.par_id%TYPE,
        p_accept_no         GIRI_WINPOLBAS.accept_no%TYPE,
        p_ri_cd             GIRI_WINPOLBAS.ri_cd%TYPE,
        p_accept_date       GIRI_WINPOLBAS.accept_date%TYPE,
        p_ri_policy_no      GIRI_WINPOLBAS.ri_policy_no%TYPE,
        p_ri_endt_no        GIRI_WINPOLBAS.ri_endt_no%TYPE,
        p_ri_binder_no      GIRI_WINPOLBAS.ri_binder_no%TYPE,
        p_writer_cd         GIRI_WINPOLBAS.writer_cd%TYPE,
        p_offer_date        GIRI_WINPOLBAS.accept_date%TYPE,
        p_accept_by         GIRI_WINPOLBAS.accept_by%TYPE,
        p_orig_tsi_amt      GIRI_WINPOLBAS.orig_tsi_amt%TYPE,
        p_orig_prem_amt     GIRI_WINPOLBAS.orig_prem_amt%TYPE,
        p_remarks           GIRI_WINPOLBAS.remarks%TYPE,
        p_ref_accept_no     GIRI_WINPOLBAS.ref_accept_no%TYPE,
        p_offered_by        GIRI_WINPOLBAS.offered_by%TYPE,
        p_amount_offered    GIRI_WINPOLBAS.amount_offered%TYPE,
        p_cedant_update     VARCHAR2 -- bonok :: 10.03.2014
    ) IS
    BEGIN        
        MERGE INTO giri_winpolbas
        USING DUAL ON (par_id = p_par_id)
            WHEN NOT MATCHED THEN
                INSERT (par_id, accept_no, ri_cd, accept_date, ri_policy_no,
                        ri_endt_no, ri_binder_no, writer_cd, offer_date, 
                        accept_by, orig_tsi_amt, orig_prem_amt, remarks, 
                        ref_accept_no, offered_by, amount_offered)
                VALUES (p_par_id, p_accept_no, p_ri_cd, p_accept_date, 
                        p_ri_policy_no, p_ri_endt_no, p_ri_binder_no, p_writer_cd, 
                        p_offer_date, p_accept_by, p_orig_tsi_amt, p_orig_prem_amt, 
                        p_remarks, p_ref_accept_no, p_offered_by, p_amount_offered)
            WHEN MATCHED THEN
                UPDATE SET accept_no = p_accept_no,
                           ri_cd            = p_ri_cd, 
                           accept_date      = p_accept_date, 
                           ri_policy_no     = p_ri_policy_no,
                           ri_endt_no       = p_ri_endt_no, 
                           ri_binder_no     = p_ri_binder_no, 
                           writer_cd        = p_writer_cd, 
                           offer_date       = p_offer_date, 
                           accept_by        = p_accept_by, 
                           orig_tsi_amt     = p_orig_tsi_amt, 
                           orig_prem_amt    = p_orig_prem_amt, 
                           remarks          = p_remarks, 
                           ref_accept_no    = p_ref_accept_no, 
                           offered_by       = p_offered_by, 
                           amount_offered   = p_amount_offered;     
                           
        IF p_cedant_update = 'Y' THEN -- bonok :: 10.03.2014 :: update tables if cedant is changed
            UPDATE giuw_pol_dist
               SET dist_flag = '1',
                   auto_dist = 'N'
             WHERE par_id = p_par_id;
             
            UPDATE gipi_parlist
               SET par_status = 5
             WHERE par_id = p_par_id;
        END IF;
    END set_giri_winpolbas;
    
     /*
    **  Created by        : D.Alcantara
    **  Date Created      : 05.05.2011
    **  Reference By       : (GIRIS005 - ENTER INITIAL ACCEPTANCE)
    **  Description       :  retrives records from giri_winpolbas
    */
    FUNCTION get_giri_winpolbas (p_par_id  GIRI_WINPOLBAS.par_id%TYPE)
        RETURN giri_winpolbas_tab PIPELINED
    IS
        v_winpolbas     GIRI_WINPOLBAS_TYPE;
        v_writer        GIIS_REINSURER.ri_sname%TYPE;
        v_ri            GIIS_REINSURER.ri_sname%TYPE;
    BEGIN
        FOR i IN (
            SELECT 1 ROWCOUNT, par_id, accept_no, ri_cd, accept_date, 
                   ri_policy_no, ri_endt_no, ri_binder_no, writer_cd, 
                   offer_date, accept_by, orig_tsi_amt, orig_prem_amt, 
                   remarks, ref_accept_no, offered_by, amount_offered
            FROM giri_winpolbas
                WHERE par_id = p_par_id
        ) LOOP
            v_winpolbas.par_id          := i.par_id;
            v_winpolbas.accept_no       := i.accept_no; 
            v_winpolbas.ri_cd           := i.ri_cd;
            v_winpolbas.accept_date     := i.accept_date; 
            v_winpolbas.ri_policy_no    := i.ri_policy_no;
            v_winpolbas.ri_endt_no      := i.ri_endt_no;
            v_winpolbas.ri_binder_no    := i.ri_binder_no;
            v_winpolbas.writer_cd       := i.writer_cd;
            v_winpolbas.offer_date      := i.offer_date; 
            v_winpolbas.accept_by       := i.accept_by;
            v_winpolbas.orig_tsi_amt    := i.orig_tsi_amt; 
            v_winpolbas.orig_prem_amt   := i.orig_prem_amt; 
            v_winpolbas.remarks         := i.remarks;
            v_winpolbas.ref_accept_no   := i.ref_accept_no; 
            v_winpolbas.offered_by      := i.offered_by;
            v_winpolbas.amount_offered  := i.amount_offered;
            v_winpolbas.writer_cd_sname := GIIS_REINSURER_PKG.get_insurer_sname(i.writer_cd);
            v_winpolbas.ri_cd_sname     := GIIS_REINSURER_PKG.get_insurer_sname(i.ri_cd);
                
            PIPE ROW(v_winpolbas);
        END LOOP;
    END get_giri_winpolbas;
    
    
    FUNCTION get_last_accept_no RETURN NUMBER
    IS
        v_accept_no     GIRI_WINPOLBAS.accept_no%TYPE;
    BEGIN
        BEGIN 
          SELECT WINPOLBAS_ACCEPT_NO_S.NEXTVAL
            INTO v_accept_no
            FROM DUAL;
        END;                
        RETURN v_accept_no;
    END get_last_accept_no;
    
    /*
    * Created by : J. Diago 09.11.2014
    * Referenced by : GIRIS005
    * Description : Check if PAR has existing posted binder
    */
    FUNCTION check_posted_binder(p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2
    IS
       v_exists VARCHAR2(1);
    BEGIN
       v_exists := 'N';
       FOR i IN (SELECT 'Y'
                   FROM giri_distfrps a, giuw_pol_dist b
                  WHERE a.dist_no = b.dist_no
                    AND b.par_id = p_par_id)
       LOOP
          v_exists := 'Y';
          EXIT;
       END LOOP;
       
       RETURN v_exists;
    END;
    
    /*
    * Created by : J. Diago 09.15.2014
    * Referenced by : GIRIS005
    * Description : Check if PAR has invoice
    */
    FUNCTION check_invoice_exists(p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2
    IS
       v_exists VARCHAR2(1);
    BEGIN
       v_exists := 'N';
       FOR i IN (SELECT 'Y'
                   FROM gipi_winvoice
                  WHERE par_id = p_par_id)
       LOOP
          v_exists := 'Y';
          EXIT;
       END LOOP;
       
       RETURN v_exists;
    END;
    
     /*
    * Created by : J. Diago 09.15.2014
    * Referenced by : GIRIS005
    * Description : Recreate Invoice Related Tables
    */
    PROCEDURE recreate_winvoice(
       p_par_id   gipi_parlist.par_id%TYPE
    )
    IS
       v_line_cd       gipi_parlist.line_cd%TYPE;
       v_iss_cd        gipi_parlist.iss_cd%TYPE;
       v_item_wo_peril VARCHAR2(1) := 'N';
    BEGIN
       SELECT line_cd, iss_cd
         INTO v_line_cd, v_iss_cd
         FROM gipi_parlist
        WHERE par_id = p_par_id;
       
       FOR dist_no IN (SELECT dist_no
                         FROM giuw_pol_dist
                        WHERE par_id = p_par_id)
       LOOP
          cpi.giuw_pol_dist_pkg.delete_binder_working_tables(dist_no.dist_no);
          /*cpi.giuw_pol_dist_pkg.delete_dist_working_tables(dist_no.dist_no);*/
          cpi.delete_dist_working_tables(dist_no.dist_no);
          cpi.giuw_pol_dist_pkg.delete_dist_master_tables(dist_no.dist_no);
       END LOOP; 
       
       FOR item_peril IN (SELECT DISTINCT par_id
                            FROM gipi_witem
                           WHERE par_id = p_par_id
                             AND item_no NOT IN (SELECT item_no
                                                   FROM gipi_witmperl
                                                  WHERE par_id = p_par_id))
       LOOP
          v_item_wo_peril := 'Y';
          EXIT;
       END LOOP;
       
       IF v_item_wo_peril = 'N' THEN
          create_winvoice(0,0,0,p_par_id,v_line_cd, v_iss_cd);
       ELSE
          DELETE FROM GIPI_WINSTALLMENT
           WHERE par_id = p_par_id;
          DELETE FROM GIPI_WINVPERL
           WHERE par_id = p_par_id;
          DELETE FROM GIPI_WINV_TAX
           WHERE par_id = p_par_id;
          DELETE FROM GIPI_WINVOICE
           WHERE par_id = p_par_id;
       END IF;
    END;

END GIRI_WINPOLBAS_PKG;
/



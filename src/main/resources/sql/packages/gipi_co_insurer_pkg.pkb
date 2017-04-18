CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Co_Insurer_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_CO_INSURER_PKG
	*/
	PROCEDURE del_gipi_co_insurer (p_par_id		GIPI_CO_INSURER.par_id%TYPE)
	IS
	BEGIN
		DELETE 
		  FROM GIPI_CO_INSURER
		 WHERE par_id = p_par_id;
	END del_gipi_co_insurer;
    
    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 04/28/2011
	**  Reference By 	: (GIPIS153 - Enter Co-Insurer)
	**  Description 	: retrieves co insurer records for a given par
	*/
    FUNCTION get_gipi_co_insurer (p_par_id  GIPI_CO_INSURER.par_id%TYPE)
        RETURN gipi_co_insurer_tab PIPELINED
    IS
        v_insurer       gipi_co_insurer_type;
        v_co_ri_cd      GIPI_CO_INSURER.co_ri_cd%TYPE;      
    BEGIN
        FOR co_ri IN (
          SELECT param_value_n
            FROM giis_parameters
           WHERE param_name = 'CO_INSURER_DEFAULT')
        LOOP
            v_co_ri_cd := co_ri.param_value_n;
        END LOOP;
        
        FOR i IN (
            SELECT a.par_id, a.co_ri_cd, a.co_ri_shr_pct, a.co_ri_prem_amt,
                   a.co_ri_tsi_amt, a.policy_id, b.ri_name, b.ri_sname
            FROM gipi_co_insurer a, giis_reinsurer b
                 WHERE a.par_id = p_par_id
                       AND b.ri_cd = a.co_ri_cd 
        ) LOOP
            v_insurer.par_id           := i.par_id;
            v_insurer.co_ri_cd         := i.co_ri_cd;
            v_insurer.co_ri_shr_pct    := i.co_ri_shr_pct;
            v_insurer.co_ri_prem_amt   := i.co_ri_prem_amt;
            v_insurer.co_ri_tsi_amt    := i.co_ri_tsi_amt;
            v_insurer.policy_id        := i.policy_id;
            v_insurer.ri_name          := i.ri_name;
            v_insurer.ri_sname         := i.ri_sname;
            IF i.co_ri_cd = v_co_ri_cd THEN
                v_insurer.is_default := 'Y';
            ELSE
                v_insurer.is_default := 'N';
            END IF;
            PIPE ROW(v_insurer);
        END LOOP;
    END get_gipi_co_insurer;

    /*
    **  Created by		: Veronica V. Raymundo
    **  Date Created 	: 04.26.2011
    **  Reference By 	: (GIPIS154 - Lead Policy Information)
    **  Description 	: Retrieves co_ri_shr_pct of a given par_id
    */
    PROCEDURE get_co_ins_shr_pct(p_par_id	IN	GIPI_CO_INSURER.par_id%TYPE,
                                 p_sve_rate OUT	GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
                                 p_rate	 	OUT	VARCHAR2)

    AS

    v_co_ri_cd        GIPI_CO_INSURER.co_ri_cd%TYPE;
    v_rate            varchar2(30);

    BEGIN
        v_co_ri_cd := GIISP.n('CO_INSURER_DEFAULT');
    	
        FOR rate IN (
            SELECT co_ri_shr_pct
              FROM GIPI_CO_INSURER
             WHERE par_id   = p_par_id
               AND co_ri_cd = v_co_ri_cd)
        LOOP
             p_sve_rate := rate.co_ri_shr_pct;
             v_rate := TO_CHAR(rate.co_ri_shr_pct,'FM990.999999999');
        END LOOP;
        
        IF substr(v_rate,NVL(length(v_rate), 0)) = '.' THEN
            p_rate := '('||substr(v_rate,1,NVL(length(v_rate), 0)-1)||'%)';
        ELSE
            p_rate := '('||v_rate||'%)';
        END IF;
    END get_co_ins_shr_pct;
	
    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 04/30/2011
	**  Reference By 	: (GIPIS153 - Enter Co-Insurer)
	**  Description 	: retrieves default co insurer records if a valid total prem 
                            amount and tsi amount has been entered
	*/
    FUNCTION get_default_co_insurers(p_policy_id GIPI_CO_INSURER.policy_id%TYPE)
        RETURN gipi_co_insurer_tab PIPELINED IS
        v_insurer       gipi_co_insurer_type;
        v_co_ri_cd      GIPI_CO_INSURER.co_ri_cd%TYPE;
    BEGIN
    
    FOR co_ri IN (
      SELECT param_value_n
        FROM giis_parameters
       WHERE param_name = 'CO_INSURER_DEFAULT')
    LOOP
       v_co_ri_cd := co_ri.param_value_n;
    END LOOP;
--    IF v_co_ri_cd IS NOT NULL THEN
       FOR ri IN (
         SELECT ri_sname, ri_name
           FROM giis_reinsurer
          WHERE ri_cd = v_co_ri_cd)
       LOOP
          v_insurer.co_ri_cd         := v_co_ri_cd;
          v_insurer.ri_name          := ri.ri_name;
          v_insurer.ri_sname         := ri.ri_sname;
          v_insurer.is_default       := 'Y';
          PIPE ROW(v_insurer);
       END LOOP;
 --   END IF;
   
    END get_default_co_insurers;
    
    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 05.02.2011
	**  Reference By 	: (GIPIS153 - Enter Co-Insurer)
	**  Description 	: 
	*/
    PROCEDURE del_gipi_co_insurer1(
        p_par_id    GIPI_CO_INSURER.par_id%TYPE,
        p_co_ri_cd  GIPI_CO_INSURER.co_ri_cd%TYPE
    ) IS
    BEGIN
        DELETE FROM GIPI_CO_INSURER
            WHERE par_id = p_par_id
                  AND co_ri_cd = p_co_ri_cd;
    END del_gipi_co_insurer1;
    
    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 05.02.2011
	**  Reference By 	: (GIPIS153 - Enter Co-Insurer)
	**  Description 	: 
	*/
    PROCEDURE set_gipi_co_insurer (
        p_par_id    GIPI_CO_INSURER.par_id%TYPE,
        p_co_ri_cd  GIPI_CO_INSURER.co_ri_cd%TYPE,
        p_co_ri_prem_amt    GIPI_CO_INSURER.co_ri_prem_amt%TYPE,
        p_co_ri_tsi_amt     GIPI_CO_INSURER.co_ri_tsi_amt%TYPE,
        p_co_ri_shr_pct     GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
        p_user_id           GIPI_CO_INSURER.user_id%TYPE
    ) IS
    BEGIN
        MERGE INTO GIPI_CO_INSURER
        USING DUAL ON (par_id = p_par_id AND co_ri_cd = p_co_ri_cd)
        WHEN NOT MATCHED THEN
            INSERT(par_id, co_ri_cd, co_ri_prem_amt, co_ri_tsi_amt,
                    co_ri_shr_pct, user_id, last_update)
             VALUES(p_par_id, p_co_ri_cd, p_co_ri_prem_amt, p_co_ri_tsi_amt, 
                   p_co_ri_shr_pct, NVL(p_user_id, USER), SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET --co_ri_cd         = p_co_ri_cd,
                       co_ri_prem_amt   = p_co_ri_prem_amt,
                       co_ri_tsi_amt    = p_co_ri_tsi_amt,
                       co_ri_shr_pct    = p_co_ri_shr_pct,
                       user_id          = NVL(p_user_id, USER),
                       last_update      = SYSDATE;
                       
    END set_gipi_co_insurer;
    
    /*
    **  Created by          :Moses Calma
    **  Date Created        :05.16.2011
    **  Reference By        :(GIPIS 100 - co insurers)
    **  Description         :Retrieves list of co - insurers for a particular policy
    */
    FUNCTION get_co_insurers (p_policy_id gipi_co_insurer.policy_id%TYPE)
       RETURN co_insurer_tab PIPELINED
    IS
       v_co_ins   co_insurer_type;
    BEGIN
       FOR i IN (SELECT   policy_id, par_id, co_ri_cd, co_ri_shr_pct,
                          co_ri_prem_amt, co_ri_tsi_amt
                     FROM gipi_co_insurer
                    WHERE policy_id = p_policy_id
                 ORDER BY co_insurer_order (co_ri_cd))
       LOOP
          v_co_ins.policy_id := i.policy_id;
          v_co_ins.par_id := i.par_id;
          v_co_ins.co_ri_cd := i.co_ri_cd;
          v_co_ins.co_ri_shr_pct := i.co_ri_shr_pct;
          v_co_ins.co_ri_prem_amt := i.co_ri_prem_amt;
          v_co_ins.co_ri_tsi_amt := i.co_ri_tsi_amt;

          BEGIN
             SELECT ri_sname
               INTO v_co_ins.ri_sname
               FROM giis_reinsurer
              WHERE ri_cd = i.co_ri_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_co_ins.ri_sname := '';
          END;

          PIPE ROW (v_co_ins);
       END LOOP;
    END get_co_insurers;
    
    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 04/30/2011
	**  Reference By 	: (GIPIS153 - Enter Co-Insurer)
	**  Description 	: 
	*/
    FUNCTION limit_entry(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE
   ) RETURN VARCHAR2 IS
        v_property    gipi_winvoice.property%TYPE;
        v_co_sw       gipi_wpolbas.co_insurance_sw%TYPE;
        v_iss_cd      gipi_wpolbas.iss_cd%TYPE;
        v_ri_cd       gipi_wpolbas.iss_cd%TYPE;
        v_ctr         NUMBER := 0;
        
        v_call_module VARCHAR2(200);
    BEGIN
        FOR cd IN (
            SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_ri_cd := cd.param_value_v;
        END LOOP;
        
        FOR ins IN (
            SELECT co_insurance_sw, iss_cd
              FROM gipi_wpolbas
             WHERE par_id = p_par_id)
        LOOP
            v_co_sw  := ins.co_insurance_sw;
            v_iss_cd := ins.iss_cd;
        END LOOP;
        
        IF v_co_sw = 2 THEN
            FOR inv IN (
              SELECT property
                FROM gipi_winvoice
               WHERE par_id = p_par_id)
            LOOP
                v_property := inv.property;
            END LOOP;
            
            IF v_property IS NULL THEN
                --Msg_alert('Please enter your BILL PREMIUM information for this PAR.','E',false);
                v_call_module := 'GIPIS026';
            ELSE
                IF v_iss_cd != v_ri_cd THEN
                    FOR comm IN (
                      SELECT 'a' 
                        FROM gipi_wcomm_invoices
                       WHERE par_id = p_par_id)
                    LOOP
                       v_ctr := v_ctr + 1;
                    END LOOP;
                         
                    FOR comm IN (
                      SELECT 'a'  
                        FROM gipi_wcomm_inv_perils
                       WHERE par_id = p_par_id)
                    LOOP
                       v_ctr := v_ctr + 1;
                    END LOOP;
                 
                    IF v_ctr = 0 THEN
                      --Msg_alert('Please enter your COMMISSION INVOICE information for this PAR.','E',false);
                      v_call_module := 'GIPIS085';
                    END IF;
                END IF;
            END IF;
        END IF;
        RETURN v_call_module;
    END limit_entry;
    
    PROCEDURE post_forms_commit_gipis153(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE,
        p_tsi_amt       IN  gipi_main_co_ins.tsi_amt%TYPE,
        p_prem_amt      IN  gipi_main_co_ins.prem_amt%TYPE,
        p_co_ins_sw     OUT gipi_wpolbas.co_insurance_sw%TYPE
    ) IS
        v_par_id         gipi_orig_itmperil.par_id%TYPE; 
        v_item_no        gipi_orig_itmperil.item_no%TYPE;
        v_line_cd        gipi_orig_itmperil.line_cd%TYPE;
        v_iss_cd         gipi_parlist.iss_cd%TYPE;
        v_peril_cd       gipi_orig_itmperil.peril_cd%TYPE;
        v_rec_flag       gipi_orig_itmperil.rec_flag%TYPE;
        v_discount_sw    gipi_orig_itmperil.discount_sw%TYPE;
        v_rec_flag       gipi_orig_itmperil.rec_flag%TYPE;
        v_prem_amt       gipi_orig_itmperil.prem_amt%TYPE;
        v_tsi_amt        gipi_orig_itmperil.tsi_amt%TYPE; 
        v_cnt            NUMBER:=0;
    BEGIN
        SELECT line_cd, iss_cd
          INTO v_line_cd, v_iss_cd
          FROM gipi_parlist
         WHERE par_id = p_par_id;
         
        FOR cnt IN (
            SELECT count(*) cnt
              FROM gipi_main_co_ins
             WHERE par_id = p_par_id)
        LOOP
            v_cnt := cnt.cnt;
        END LOOP;
    
        FOR sw IN (
            SELECT co_insurance_sw 
              FROM gipi_wpolbas
             WHERE par_id = p_par_id )
        LOOP
            p_co_ins_sw := sw.co_insurance_sw;
        END LOOP;
        
        IF nvl(p_co_ins_sw,'1')  = '2' THEN

            Gipi_Co_Insurer_Pkg.populate_itmperil_gipis153(p_par_id);
            CREATE_ORIG_INVOICE(p_par_id,v_line_cd,v_iss_cd);
        END IF;
        
    END post_forms_commit_gipis153;
    
    PROCEDURE populate_itmperil_gipis153(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE
    ) IS
        v_co_ri_cd    gipi_co_insurer.co_ri_cd%TYPE;
        v_rate        gipi_co_insurer.co_ri_shr_pct%TYPE;

    BEGIN
        DELETE FROM gipi_orig_itmperil
         WHERE  par_id  = p_par_id;

        FOR co_ri IN (
            SELECT param_value_n
              FROM giis_parameters
             WHERE param_name = 'CO_INSURER_DEFAULT')
        LOOP
            v_co_ri_cd := co_ri.param_value_n;
        END LOOP;

        FOR rate IN (
            SELECT co_ri_shr_pct
              FROM gipi_co_insurer
             WHERE par_id   = p_par_id
               AND co_ri_cd = v_co_ri_cd)
        LOOP
            v_rate := rate.co_ri_shr_pct;
        END LOOP;

        IF v_rate IS NOT NULL THEN
            FOR A IN(SELECT item_no, line_cd, peril_cd, rec_flag,
                            prem_rt, ((prem_amt/v_rate) * 100) prem_amt,
                            ((tsi_amt/v_rate) * 100) tsi_amt
                       FROM gipi_witmperl
                      WHERE par_id = p_par_id) LOOP
                  INSERT INTO gipi_orig_itmperil(par_id,       item_no,      line_cd,    peril_cd, 
                                                 rec_flag,     prem_rt,      prem_amt,   tsi_amt)
                                          VALUES(p_par_id, A.item_no,    A.line_cd,  A.peril_cd,
                                                 nvl(A.rec_flag,'A'),   A.prem_rt,    A.prem_amt, A.tsi_amt);
            END LOOP;
        END IF;
    END populate_itmperil_gipis153;
        
    PROCEDURE populate_orig_tab (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
    ) IS
        v_corp_tag             giis_intermediary.corp_tag%type;
        v_tax_rt               NUMBER;
        v_prem_amt             gipi_orig_comm_inv_peril.premium_amt%TYPE;
        v_comm_amt             gipi_orig_comm_inv_peril.commission_amt%TYPE;
        v_whold_tax            gipi_orig_comm_inv_peril.wholding_tax%TYPE;
        v_total_commission     gipi_orig_comm_invoice.commission_amt%type;
        v_total_wholding_tax   gipi_orig_comm_invoice.wholding_tax%type;
        v_total_premium_amt    gipi_orig_comm_invoice.premium_amt%type;
        v_total_net_commission gipi_orig_comm_invoice.commission_amt%type;
    BEGIN
        DELETE gipi_orig_comm_inv_peril
         WHERE par_id = p_par_id;
        DELETE gipi_orig_comm_invoice
         WHERE par_id = p_par_id;
         
        FOR comm_inv IN (
            SELECT item_grp, intrmdry_intm_no, share_percentage
              FROM gipi_wcomm_invoices
             WHERE par_id = p_par_id)
        LOOP
   
            INSERT INTO gipi_orig_comm_invoice (
                par_id,                    intrmdry_intm_no, 
                item_grp,                  premium_amt,  
                share_percentage,          commission_amt,
                wholding_tax,              policy_id,
                iss_cd,                    prem_seq_no)
            VALUES (
                p_par_id,    comm_inv.intrmdry_intm_no, 
                comm_inv.item_grp,         0,            
                comm_inv.share_percentage, 0,
                0,                         NULL,
                NULL,                      NULL);
           
            FOR tag IN (
                SELECT corp_tag	
                  FROM giis_intermediary
                 WHERE intm_no = comm_inv.intrmdry_intm_no )
            LOOP
                v_corp_tag := tag.corp_tag;
            END LOOP;  
       
            IF v_corp_tag  = 'Y' THEN
         
                FOR tax_rt IN (
                    SELECT param_value_n
                      FROM giac_parameters
                     WHERE param_name = 'CORP_INTM_WTAX')
                LOOP
                    v_tax_rt := tax_rt.param_value_n;
                END LOOP;
            ELSE
                FOR tax_rt1 IN (       
                    SELECT param_value_n
                      FROM giac_parameters
                    WHERE param_name = 'INTM_WTAX' )
                LOOP
                    v_tax_rt := tax_rt1.param_value_n;
                END LOOP;
            END IF;
          
            FOR perl IN (
                SELECT peril_cd, commission_rt
                  FROM gipi_wcomm_inv_perils
                 WHERE par_id           = p_par_id  
                   AND item_grp         = comm_inv.item_grp
                   AND intrmdry_intm_no = comm_inv.intrmdry_intm_no) 
            LOOP 
           
                FOR amt IN (
                    SELECT prem_amt
                      FROM gipi_orig_invperl
                     WHERE par_id   = p_par_id  
                        AND item_grp = comm_inv.item_grp
                        AND peril_cd = perl.peril_cd) 
                LOOP
                    v_prem_amt               := NVL(amt.prem_amt, 0) * NVL(comm_inv.share_percentage,0)/100;
                    v_comm_amt               := v_prem_amt * NVL(perl.commission_rt,0)/100;
                    v_whold_tax              := v_comm_amt * nvl(v_tax_rt,0)/100;
                    v_total_commission       := NVL(v_total_commission,0) + NVL(v_comm_amt,0);              
                    v_total_wholding_tax     := NVL(v_total_wholding_tax,0) + NVL(v_whold_tax,0);                
                    v_total_premium_amt      := NVL(v_total_premium_amt,0) + NVL(v_prem_amt,0);                
          
                    INSERT INTO gipi_orig_comm_inv_peril (
                        par_id,                  intrmdry_intm_no,                
                        item_grp,                peril_cd,               
                        premium_amt,             policy_id,
                        iss_cd,                  prem_seq_no,
                        commission_amt,          commission_rt,
                        wholding_tax)
                    VALUES (
                        p_par_id,  comm_inv.intrmdry_intm_no,          
                        comm_inv.item_grp,       perl.peril_cd,
                        v_prem_amt,              null,
                        null,                    null,
                        v_comm_amt,              perl.commission_rt,
                        v_whold_tax); 
                           
                END LOOP; -- End loop of amt --
         
            END LOOP;    -- End loop of perl --

            UPDATE gipi_orig_comm_invoice
               SET premium_amt      = NVL(v_total_premium_amt, 0),  
                   commission_amt   = NVL(v_total_commission, 0),
                   wholding_tax     = NVL(v_total_wholding_tax, 0)
             WHERE par_id           = p_par_id
               AND item_grp         = comm_inv.item_grp
               AND intrmdry_intm_no = comm_inv.intrmdry_intm_no;
            
                v_total_commission       := 0;              
                v_total_wholding_tax     := 0;              
                v_total_premium_amt      := 0;              
         
        END LOOP;
    END populate_orig_tab;
    
    
    PROCEDURE process_default_insurer (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
    ) IS
        v_co_ri_cd      gipi_co_insurer.co_ri_cd%TYPE;
        v_prem_amt      gipi_witmperl.prem_amt%TYPE;
        v_tsi_amt       gipi_witmperl.tsi_amt%TYPE;
        v_co_prem_amt   NUMBER;
        v_co_tsi_amt    NUMBER;
        v_ins_prem_amt  gipi_co_insurer.co_ri_prem_amt%TYPE;
        v_ins_tsi_amt   gipi_co_insurer.co_ri_tsi_amt%TYPE;
        v_share_pct     gipi_co_insurer.co_ri_shr_pct%TYPE;
    BEGIN
        FOR co_ri IN (
            SELECT param_value_n
              FROM giis_parameters
             WHERE param_name = 'CO_INSURER_DEFAULT')
        LOOP
            v_co_ri_cd := co_ri.param_value_n;
        END LOOP;
        -- loop a
        FOR pol IN (
            SELECT a.policy_id
              FROM gipi_polbasic a, gipi_wpolbas b
             WHERE a.line_cd     = b.line_cd
               AND a.subline_cd  = b.subline_cd
               AND a.iss_cd      = b.iss_cd
               AND a.issue_yy    = b.issue_yy
               AND a.pol_seq_no  = b.pol_seq_no
               AND a.renew_no    = b.renew_no
               AND a.endt_seq_no = 0
               AND b.par_id      = p_par_id)
        LOOP
            FOR get_shr IN (
              SELECT co_ri_shr_pct
                FROM gipi_co_insurer
               WHERE policy_id = pol.policy_id
                 AND co_ri_cd  = v_co_ri_cd)
            LOOP
                v_share_pct := get_shr.co_ri_shr_pct;
            END LOOP;
            
            FOR tot_prem IN (
              SELECT SUM(prem_amt) prem,
                     SUM(tsi_amt) tsi
                FROM gipi_witmperl        
               WHERE par_id = p_par_id)
            LOOP
               v_prem_amt := tot_prem.prem;
            END LOOP;
            
            FOR tot_tsi IN (
              SELECT SUM(a.tsi_amt) tsi
                FROM giis_peril b,
                     gipi_witmperl a        
               WHERE b.line_cd = a.line_cd
                 AND b.peril_cd = a.peril_cd
                 AND b.peril_type = 'B'
                 AND a.par_id = p_par_id)
            LOOP
               v_tsi_amt  := tot_tsi.tsi;
            END LOOP; 
            
            v_co_prem_amt := ROUND(NVL(v_prem_amt,0) / v_share_pct * 100 ,2);
            v_co_tsi_amt  := ROUND(NVL(v_tsi_amt,0)  / v_share_pct * 100 ,2);
            
            INSERT INTO gipi_main_co_ins(
              par_id,                 prem_amt,      tsi_amt )
             VALUES ( p_par_id, v_co_prem_amt, v_co_tsi_amt);
             
            FOR co_ins IN (
              SELECT co_ri_cd,  co_ri_shr_pct
                FROM gipi_co_insurer
               WHERE policy_id = pol.policy_id)
            LOOP
               v_ins_prem_amt := ROUND(ROUND(v_co_prem_amt * co_ins.co_ri_shr_pct,2) / 100 ,2);
               v_ins_tsi_amt  := ROUND(ROUND(v_co_tsi_amt  * co_ins.co_ri_shr_pct,2) / 100 ,2);
               INSERT INTO gipi_co_insurer(
                        par_id,                 co_ri_cd,        co_ri_shr_pct, 
                        co_ri_prem_amt,         co_ri_tsi_amt )
                 VALUES(p_par_id, co_ins.co_ri_cd, co_ins.co_ri_shr_pct,
                       v_ins_prem_amt,          v_ins_tsi_amt);
            END LOOP;
        END LOOP;
        -- /loop a
        
        FOR c1 IN (SELECT SUM(co_ri_prem_amt) co_ri_prem_amt, SUM(co_ri_tsi_amt) co_ri_tsi_amt
               FROM gipi_co_insurer 
              WHERE par_id = p_par_id)
        LOOP
            UPDATE gipi_main_co_ins
               SET prem_amt = c1.co_ri_prem_amt,
                   tsi_amt = c1.co_ri_tsi_amt
             WHERE par_id = p_par_id;
            EXIT;   	       
        END LOOP;
    END process_default_insurer;
    
    PROCEDURE process_default_lead (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
    ) IS
        v_co_ins_sw  gipi_wpolbas.co_insurance_sw%TYPE;
        v_line_cd    gipi_wpolbas.line_cd%TYPE;
        v_iss_cd     gipi_wpolbas.iss_cd%TYPE;
    BEGIN
        FOR sw IN (
            SELECT a.co_insurance_sw , b.line_cd, b.iss_cd
              FROM gipi_polbasic a, gipi_wpolbas b
             WHERE a.line_cd      = b.line_cd
               AND a.subline_cd   = b.subline_cd
               AND a.iss_cd       = b.iss_cd
               AND a.issue_yy     = b.issue_yy
               AND a.pol_seq_no   = b.pol_seq_no
               AND a.renew_no     = b.renew_no
               AND a.endt_seq_no  = 0
               AND b.par_id       = p_par_id )
        LOOP
             v_co_ins_sw := sw.co_insurance_sw;
             v_line_cd   := sw.line_cd;
             v_iss_cd    := sw.iss_cd;
        END LOOP;
          
        IF nvl(v_co_ins_sw,'1')  = '2' THEN
            Gipi_Co_Insurer_Pkg.populate_itmperil_gipis153(p_par_id);
            CREATE_ORIG_INVOICE(p_par_id,v_line_cd,v_iss_cd);
        END IF;
    END process_default_lead;
    
    PROCEDURE del_all_related_co_ins_recs(
      p_par_id gipi_co_insurer.par_id%TYPE
   )
   IS
   BEGIN

      DELETE FROM gipi_orig_itmperil
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_inv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_invperl
            WHERE par_id = p_par_id;
            
      DELETE FROM gipi_orig_comm_inv_peril
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_comm_invoice
            WHERE par_id = p_par_id;
            
      DELETE FROM gipi_orig_invoice
            WHERE par_id = p_par_id;
            
      DELETE FROM gipi_co_insurer
            WHERE par_id = p_par_id;
            
      DELETE FROM gipi_main_co_ins
            WHERE par_id = p_par_id;            
            
   END del_all_related_co_ins_recs;
END Gipi_Co_Insurer_Pkg;
/



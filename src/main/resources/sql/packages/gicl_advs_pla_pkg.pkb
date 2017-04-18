CREATE OR REPLACE PACKAGE BODY CPI.GICL_ADVS_PLA_PKG
AS
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 16, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   get PLA details for PLA 
    */
    FUNCTION get_gicl_advs_pla(
        p_claim_id              gicl_reserve_ds.claim_id%TYPE, 
        p_clm_res_hist_id       gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_grp_seq_no            gicl_reserve_ds.grp_seq_no%TYPE,
        p_share_type            gicl_reserve_ds.share_type%TYPE
        )
    RETURN gicl_advs_pla_tab PIPELINED IS
      v_list    gicl_advs_pla_type;
    BEGIN
        FOR i IN (SELECT pla_id, claim_id, grp_seq_no,     
                         ri_cd, line_cd, la_yy,          
                         pla_seq_no, user_id, last_update,    
                         share_type, peril_cd, loss_shr_amt,   
                         exp_shr_amt, pla_title, pla_header,     
                         pla_footer, print_sw, cpi_rec_no,     
                         cpi_branch_cd, item_no, cancel_tag,     
                         res_pla_id, pla_date, grouped_item_no
                    FROM gicl_advs_pla
                   WHERE claim_id = p_claim_id
                     AND grp_seq_no = p_grp_seq_no
                     AND share_type = p_share_type
                     AND cancel_tag = 'N'
                      OR cancel_tag IS NULL
                     AND pla_id IN (SELECT pla_id
                                      FROM gicl_reserve_rids
                                     WHERE claim_id = p_claim_id
                                       AND grp_seq_no = p_grp_seq_no
                                       AND share_type = p_share_type
                                       AND clm_res_hist_id = p_clm_res_hist_id))
        LOOP
            v_list.pla_id           		:= i.pla_id;
            v_list.claim_id         		:= i.claim_id;
            v_list.grp_seq_no       		:= i.grp_seq_no;
            v_list.ri_cd            		:= i.ri_cd;
            v_list.line_cd          		:= i.line_cd;
            v_list.la_yy            		:= i.la_yy;
            v_list.pla_seq_no       		:= i.pla_seq_no;
            v_list.user_id          		:= i.user_id;
            v_list.last_update      		:= i.last_update;
            v_list.share_type       		:= i.share_type;
            v_list.peril_cd         		:= i.peril_cd;
            v_list.loss_shr_amt     		:= i.loss_shr_amt;
            v_list.exp_shr_amt      		:= i.exp_shr_amt;
            v_list.pla_title        		:= i.pla_title;
            v_list.pla_header       		:= i.pla_header;
            v_list.pla_footer       		:= i.pla_footer;
            v_list.print_sw         		:= i.print_sw;
            v_list.cpi_rec_no       		:= i.cpi_rec_no;
            v_list.cpi_branch_cd    		:= i.cpi_branch_cd;
            v_list.item_no          		:= i.item_no;
            v_list.cancel_tag       		:= i.cancel_tag;
            v_list.res_pla_id       		:= i.res_pla_id;
            v_list.pla_date         		:= i.pla_date;
            v_list.grouped_item_no  		:= i.grouped_item_no;
            v_list.dsp_ri_name              := '';
            
            FOR ri IN (SELECT ri_name
                        FROM giis_reinsurer
                       WHERE ri_cd = i.ri_cd)
            LOOP
              v_list.dsp_ri_name := ri.ri_name;
            END LOOP;

            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 20, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   Cancel PLA 
    */    
    PROCEDURE cancel_pla(
        p_claim_id              gicl_advs_pla.claim_id%TYPE, 
        p_res_pla_id            gicl_advs_pla.res_pla_id%TYPE
        ) IS
    BEGIN 
        UPDATE gicl_advs_pla
           SET cancel_tag = 'Y'
         WHERE claim_id = p_claim_id 
           AND res_pla_id = p_res_pla_id;

        UPDATE gicl_reserve_rids
           SET pla_id = NULL
         WHERE claim_id = p_claim_id 
           AND res_pla_id = p_res_pla_id;
    END;

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 20, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   clm_pla_grp1 program unit 
    */  
    PROCEDURE get_pla_id(p_pla_id   OUT NUMBER) IS 
    BEGIN
      SELECT max(pla_id) + 1
        INTO p_pla_id
        FROM gicl_advs_pla;
        IF p_pla_id IS NULL THEN
          p_pla_id := 1;
        END IF;  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_pla_id := 1;
    END;

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 20, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   clm_pla_grp1 program unit 
    */    
    PROCEDURE clm_pla_grp1 (
        p_hist_id	        VARCHAR2,
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_clm_yy            gicl_claims.clm_yy%TYPE
        ) IS
      v_item_no 		gicl_advs_pla.pla_seq_no%type;
      v_count     	    NUMBER;
      v_ri_grp	  	    NUMBER;	
      v_loss_ri	  	    gicl_reserve_rids.shr_loss_ri_res_amt%type := 0;
      v_exp_ri	  	    gicl_reserve_rids.shr_exp_ri_res_amt%type := 0;
      v_exists    	    VARCHAR2(1);
      v_pla_title		VARCHAR2(150);
      v_pla_header      VARCHAR2(150);
      v_pla_footer      VARCHAR2(2000);

      v_ri_cd           gicl_reserve_rids.ri_cd%type;
      v_res_pla_id      NUMBER;
      v_pla_id          NUMBER;
      
      CURSOR C IS
        SELECT distinct m.claim_id ,
                        nvl(m.prnt_ri_cd,ri_cd) ri_cd,
                        m.grp_seq_no, 
                        m.share_type, 
                        m.grouped_item_no --added by gmi 02/23/06
          FROM gicl_reserve_rids m, gicl_reserve_ds e
         WHERE m.claim_id = e.claim_id
           AND m.clm_res_hist_id = e.clm_res_hist_id
           AND m.clm_dist_no = e.clm_dist_no
           AND (e.negate_tag = 'N' or e.negate_tag is null)
           AND m.claim_id = p_claim_id
           AND instr(p_hist_id,(','||to_char(m.clm_res_hist_id)||','),1) <> 0;
      
    BEGIN
      --RES_PLA_ID--
      SELECT nvl(max(res_pla_id),0) + 1
        INTO v_res_pla_id 
        FROM gicl_advs_pla;
      	
      --PLA_SEQ_NO--
      SELECT NVL(MAX(pla_seq_no),0)
        INTO v_item_no
        FROM gicl_advs_pla
       WHERE line_cd = p_line_cd
         AND la_yy   = p_clm_yy;

      v_count := v_item_no + 1;

      GICL_ADVS_PLA_PKG.get_pla_id(v_pla_id);

      FOR Crec IN C LOOP
        BEGIN
          SELECT SUM(loss) loss, SUM(exp) exp
            INTO v_loss_ri, v_exp_ri
            FROM gicl_for_pla_v
           WHERE claim_id = crec.claim_id
             AND nvl(prnt_ri_cd,ri_cd) = crec.ri_cd 
             AND grp_seq_no = crec.grp_seq_no
             AND share_type = crec.share_type
             AND instr(p_hist_id,(','||to_char(clm_res_hist_id)||','),1) <> 0;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;
         
        BEGIN
            SELECT param_value_v title
                    INTO v_pla_title
            FROM giac_parameters 
             WHERE param_name = 'PLA_TITLE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            NULL;
        END;
    		  
            BEGIN
              SELECT param_value_v 
                INTO v_pla_header
            FROM giac_parameters 
             WHERE param_name = 'PLA_HEADER';
            EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
            END;
      	
            BEGIN
              SELECT param_value_v 
                INTO v_pla_footer
            FROM giac_parameters 
           WHERE param_name = 'PLA_FOOTER';
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
          END;

        
        INSERT INTO gicl_advs_pla
               (pla_id,           claim_id,      grp_seq_no,           ri_cd,          line_cd,
                la_yy,            pla_seq_no,    share_type,           loss_shr_amt,   exp_shr_amt, 	      
                pla_title,        print_sw, 	 pla_date,             res_pla_id,
                pla_footer,       pla_header,    grouped_item_no)      --added by gmi 
        VALUES (v_pla_id,         crec.claim_id, crec.grp_seq_no,      crec.ri_cd,     p_line_cd,
                p_clm_yy,         v_count,       crec.share_type,      v_loss_ri,      v_exp_ri, 
                v_pla_title,      'N',           sysdate,              v_res_pla_id,
                v_pla_footer,     v_pla_header,  crec.grouped_item_no); --added by gmi 02/23/06
      
        v_pla_id := v_pla_id + 1; --increment pla_id

        v_count := v_count + 1; --increment pla_seq_no
      END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_count := 1;
    END;    

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 20, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   clm_pla_grp1A program unit 
    */  
    PROCEDURE clm_pla_grp1A (
        p_hist_id	        VARCHAR2,
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_clm_yy            gicl_claims.clm_yy%TYPE
        ) IS
      v_item_no 	    gicl_advs_pla.pla_seq_no%type;
      v_count           number;
      v_ri_grp	        number;	
      v_loss_ri	        gicl_reserve_rids.shr_loss_ri_res_amt%type := 0;
      v_exp_ri	        gicl_reserve_rids.shr_exp_ri_res_amt%type := 0;
      v_res_pla         gicl_advs_pla.res_pla_id%type;
      v_pla_title		varchar2(150);
      v_pla_header      varchar2(150);
      v_pla_footer      varchar2(2000);
      v_res_pla_id      NUMBER;
      v_pla_id          NUMBER;
    BEGIN
      DECLARE
        p_ri_cd    gicl_reserve_rids.ri_cd%type;
        CURSOR C IS
        SELECT distinct m.claim_id ,
               m.ri_cd ri_cd,
               m.grp_seq_no, m.share_type, m.grouped_item_no
          FROM gicl_reserve_rids m, gicl_reserve_ds e
         WHERE m.claim_id = e.claim_id
           AND m.clm_res_hist_id = e.clm_res_hist_id
           AND m.clm_dist_no = e.clm_dist_no
           AND (e.negate_tag = 'N' or e.negate_tag is null)
           AND m.claim_id = p_claim_id
           AND instr(p_hist_id,(','||to_char(m.clm_res_hist_id)||','),1) <> 0;


      BEGIN
        SELECT nvl(max(res_pla_id),0) + 1
          INTO v_res_pla
          FROM gicl_advs_pla;

        v_res_pla_id := v_res_pla;
        
        SELECT NVL(MAX(pla_seq_no),0)
          INTO v_item_no
          FROM gicl_advs_pla
         WHERE line_cd = p_line_cd
           AND la_yy   = p_clm_yy;
           
        v_count := v_item_no + 1;

        GICL_ADVS_PLA_PKG.get_pla_id(v_pla_id);
        
          FOR Crec IN C LOOP
            begin
              select sum(loss) loss, sum(exp) exp
                into v_loss_ri, v_exp_ri
                from gicl_for_pla_v
               where claim_id = crec.claim_id
                 and ri_cd = crec.ri_cd
                 and grp_seq_no = crec.grp_seq_no
                 and share_type = crec.share_type
                 and instr(p_hist_id,(','||to_char(clm_res_hist_id)||','),1) <> 0;
    --             and clm_res_hist_id in (p_hist_id);
            exception
              when NO_DATA_FOUND then
                null;
            end;
            
          BEGIN
            SELECT param_value_v title
                    INTO v_pla_title
              FROM giac_parameters 
             WHERE param_name = 'PLA_TITLE';
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
              NULL;
          END;
          
              BEGIN
                  SELECT param_value_v 
                  INTO v_pla_header
                FROM giac_parameters 
                 WHERE param_name = 'PLA_HEADER';
                EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
                END;
    			
                BEGIN
                    SELECT param_value_v 
                  INTO v_pla_footer
              FROM giac_parameters 
             WHERE param_name = 'PLA_FOOTER';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
            END;
            
            INSERT INTO gicl_advs_pla
                   (pla_id, 		claim_id, 	    grp_seq_no,	    ri_cd,		     line_cd, 
                    la_yy,			pla_seq_no,     share_type,     loss_shr_amt, 	 exp_shr_amt, 
                    pla_title,      print_sw,       pla_date,       res_pla_id,      pla_footer,
                    pla_header,     grouped_item_no)
            VALUES (v_pla_id, 	    crec.claim_id, 	crec.grp_seq_no, crec.ri_cd, 	 p_line_cd,
                    p_clm_yy, 	  	v_count, 	    crec.share_type, v_loss_ri, 	 v_exp_ri, 				
                    v_pla_title,    'N',            sysdate,         v_res_pla_id,
                    v_pla_footer,   v_pla_header,   crec.grouped_item_no);

          v_pla_id := v_pla_id + 1;

          v_count := v_count + 1; 
        END LOOP; 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_count := 1;
      END;
    END;

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 20, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   generate PLA details 
    */  
    PROCEDURE generate_pla(
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_hist_seq_no       gicl_clm_res_hist.hist_seq_no%TYPE,
        p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
        p_item_no           gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE
        ) IS
      v_pla_id	gicl_advs_pla.pla_id%type := null;	
      v_res_pla gicl_advs_pla.res_pla_id%type;
    BEGIN
      FOR i IN (SELECT distinct share_type, grp_seq_no, ri_cd
                  FROM gicl_advs_pla
                 WHERE claim_id = p_claim_id) LOOP

        BEGIN 
        	FOR p IN(SELECT pla_id, res_pla_id
                     FROM gicl_advs_pla
                    WHERE claim_id   = p_claim_id
                      AND grp_seq_no = i.grp_seq_no
                      AND share_type = i.share_type
                      AND ri_cd      = i.ri_cd
                      AND (cancel_tag = 'N' OR cancel_tag IS NULL))
          LOOP
            v_pla_id  := p.pla_id;
            v_res_pla := p.res_pla_id; 
          END LOOP; 
          
          UPDATE gicl_reserve_rids
             SET pla_id = v_pla_id,
                 res_pla_id = v_res_pla
           WHERE claim_id = p_claim_id
             AND item_no = p_item_no
             AND peril_cd = p_peril_cd
             AND nvl(grouped_item_no,0) = nvl(p_grouped_item_no,0)  
             AND grp_seq_no = i.grp_seq_no
             AND share_type = i.share_type
             AND nvl(prnt_ri_cd,ri_cd) = i.ri_cd   
             AND hist_seq_no = p_hist_seq_no; 
        END;
      END LOOP;    
    END;

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 24, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   update print_sw on Printing PLA
    */  
    PROCEDURE update_print_sw_pla(
        p_claim_id          gicl_advs_pla.claim_id%TYPE,
        p_ri_cd             gicl_advs_pla.ri_cd%TYPE,
        p_pla_seq_no        gicl_advs_pla.pla_seq_no%TYPE,
        p_line_cd           gicl_advs_pla.line_cd%TYPE,
        p_la_yy             gicl_advs_pla.la_yy%TYPE
        ) IS
    BEGIN
      UPDATE gicl_advs_pla
         SET print_sw   = 'Y'
       WHERE claim_id   = p_claim_id
         AND share_type = 4
         AND ri_cd      = p_ri_cd
         AND pla_seq_no = p_pla_seq_no
         AND line_cd    = p_line_cd
         AND la_yy      = p_la_yy;
    END;  
    
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 24, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   update print_sw on Printing PLA
    */  
    PROCEDURE update_print_sw_pla(
        p_claim_id          gicl_advs_pla.claim_id%TYPE,
        p_grp_seq_no        gicl_advs_pla.grp_seq_no%TYPE,
        p_ri_cd             gicl_advs_pla.ri_cd%TYPE,
        p_pla_seq_no        gicl_advs_pla.pla_seq_no%TYPE,
        p_line_cd           gicl_advs_pla.line_cd%TYPE,
        p_la_yy             gicl_advs_pla.la_yy%TYPE
        ) IS
    BEGIN
      UPDATE gicl_advs_pla
         SET print_sw   = 'Y'
       WHERE claim_id   = p_claim_id
         AND grp_seq_no = p_grp_seq_no
         AND ri_cd      = p_ri_cd
         AND pla_seq_no = p_pla_seq_no
         AND line_cd    = p_line_cd
         AND la_yy      = p_la_yy;
    END; 
      
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  March 23, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   Insert/update record 
    */  
    PROCEDURE set_gicl_advs_pla(
        p_pla_id                   gicl_advs_pla.pla_id%TYPE,
        p_claim_id                 gicl_advs_pla.claim_id%TYPE,
        p_grp_seq_no               gicl_advs_pla.grp_seq_no%TYPE,
        p_ri_cd                    gicl_advs_pla.ri_cd%TYPE,
        p_line_cd                  gicl_advs_pla.line_cd%TYPE,
        p_la_yy                    gicl_advs_pla.la_yy%TYPE,
        p_pla_seq_no               gicl_advs_pla.pla_seq_no%TYPE,
        p_user_id                  gicl_advs_pla.user_id%TYPE,
        p_last_update              gicl_advs_pla.last_update%TYPE,
        p_share_type               gicl_advs_pla.share_type%TYPE,
        p_peril_cd                 gicl_advs_pla.peril_cd%TYPE,
        p_loss_shr_amt             gicl_advs_pla.loss_shr_amt%TYPE,
        p_exp_shr_amt              gicl_advs_pla.exp_shr_amt%TYPE,
        p_pla_title                gicl_advs_pla.pla_title%TYPE,
        p_pla_header               gicl_advs_pla.pla_header%TYPE,
        p_pla_footer               gicl_advs_pla.pla_footer%TYPE,
        p_print_sw                 gicl_advs_pla.print_sw%TYPE,
        p_cpi_rec_no               gicl_advs_pla.cpi_rec_no%TYPE,
        p_cpi_branch_cd            gicl_advs_pla.cpi_branch_cd%TYPE,
        p_item_no                  gicl_advs_pla.item_no%TYPE,
        p_cancel_tag               gicl_advs_pla.cancel_tag%TYPE,
        p_res_pla_id               gicl_advs_pla.res_pla_id%TYPE,
        p_pla_date         		   gicl_advs_pla.pla_date%TYPE,
        p_grouped_item_no  		   gicl_advs_pla.grouped_item_no%TYPE
        ) IS
    BEGIN
        MERGE INTO gicl_advs_pla
             USING DUAL
                ON (pla_id = p_pla_id
               AND  grp_seq_no = p_grp_seq_no) 
        WHEN NOT MATCHED THEN
            INSERT (pla_id, claim_id, grp_seq_no,     
                    ri_cd, line_cd, la_yy,          
                    pla_seq_no, user_id, last_update,    
                    share_type, peril_cd, loss_shr_amt,   
                    exp_shr_amt, pla_title, pla_header,     
                    pla_footer, print_sw, cpi_rec_no,     
                    cpi_branch_cd, item_no, cancel_tag,     
                    res_pla_id, pla_date, grouped_item_no)
            VALUES (p_pla_id, p_claim_id, p_grp_seq_no,     
                    p_ri_cd, p_line_cd, p_la_yy,          
                    p_pla_seq_no, giis_users_pkg.app_user, SYSDATE,    
                    p_share_type, p_peril_cd, p_loss_shr_amt,   
                    p_exp_shr_amt, p_pla_title, p_pla_header,     
                    p_pla_footer, p_print_sw, p_cpi_rec_no,     
                    p_cpi_branch_cd, p_item_no, p_cancel_tag,     
                    p_res_pla_id, p_pla_date, p_grouped_item_no)
        WHEN MATCHED THEN
            UPDATE SET  
                    claim_id                 = p_claim_id, 
                    ri_cd                    = p_ri_cd,
                    line_cd                  = p_line_cd,
                    la_yy                    = p_la_yy,
                    pla_seq_no               = p_pla_seq_no,
                    user_id                  = p_user_id,
                    last_update              = p_last_update,
                    share_type               = p_share_type,
                    peril_cd                 = p_peril_cd,
                    loss_shr_amt             = p_loss_shr_amt,
                    exp_shr_amt              = p_exp_shr_amt,
                    pla_title                = p_pla_title,
                    pla_header               = p_pla_header,
                    pla_footer               = p_pla_footer,
                    print_sw                 = p_print_sw,
                    cpi_rec_no               = p_cpi_rec_no,
                    cpi_branch_cd            = p_cpi_branch_cd,
                    item_no                  = p_item_no,
                    cancel_tag               = p_cancel_tag,
                    res_pla_id               = p_res_pla_id,
                    pla_date         		 = p_pla_date,
                    grouped_item_no  		 = p_grouped_item_no;
    END;
    
    
    /*
    **  Created by   :  Kris Felipe
    **  Date Created :  August 13, 2013
    **  Reference By :  GICLS050 - Print PLA/FLA
    **  Description :   Tag PLA as printed
    */  
    PROCEDURE tag_pla_as_printed(
        p_pla   gicl_advs_pla%ROWTYPE
    ) IS
    
    BEGIN
    
        IF p_pla.print_sw = 'N' THEN
        
            IF p_pla.share_type = 4 THEN
            
                UPDATE gicl_advs_pla
                   SET print_sw   = 'Y',
                       pla_header = p_pla.pla_header,
                       pla_footer = p_pla.pla_footer,
                       pla_title  = p_pla.pla_title
                 WHERE claim_id   = p_pla.claim_id
                   AND grp_seq_no = p_pla.grp_seq_no
                   AND share_type = 4
                   AND ri_cd      = p_pla.ri_cd
                   AND pla_seq_no = p_pla.pla_seq_no
                   AND line_cd    = p_pla.line_cd
                   AND la_yy      = p_pla.la_yy;            
           
                --check_pla_fla_xol_to_print;--vj 030107
            ELSE 
             
                UPDATE gicl_advs_pla
                   SET print_sw   = 'Y',
                       pla_header = p_pla.pla_header,
                       pla_footer = p_pla.pla_footer,
                       pla_title  = p_pla.pla_title
                 WHERE claim_id   = p_pla.claim_id
                   AND grp_seq_no = p_pla.grp_seq_no
                   AND ri_cd      = p_pla.ri_cd
                   AND pla_seq_no = p_pla.pla_seq_no
                   AND line_cd    = p_pla.line_cd
                   AND la_yy      = p_pla.la_yy;
                      
                --check_pla_fla_to_print;
            END IF;
        
        END IF;
    END tag_pla_as_printed;
        
END GICL_ADVS_PLA_PKG;
/



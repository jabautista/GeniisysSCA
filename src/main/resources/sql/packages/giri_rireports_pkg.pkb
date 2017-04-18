CREATE OR REPLACE PACKAGE BODY CPI.GIRI_RIREPORTS_PKG
AS

    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Returns peril details of the given binder
    */
    FUNCTION get_binder_peril_dtls (
        p_line_cd           giri_binder.line_cd%TYPE, 
        p_binder_yy         giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE
    ) RETURN bndr_peril_dtls_tab PIPELINED
    AS
        v_bndr_peril_dtls      bndr_peril_dtls_type;
        
    BEGIN
        FOR i IN  (SELECT  t5.peril_sname  ,t1.fnl_binder_id
                           ,t1.peril_seq_no ,t1.ri_tsi_amt
                           ,t1.ri_shr_pct   ,t1.ri_prem_amt
                           ,t1.ri_comm_rt   ,t1.ri_comm_amt
                           ,t2.ri_prem_vat  ,nvl(t2.ri_wholding_vat, 0) ri_wholding_vat
                           ,t1.prem_tax     
                           ,nvl(t1.ri_comm_vat, 0) ri_comm_vat 
                           ,nvl(t4.prem_amt, 0) gross_prem_amt
                      FROM giri_binder_peril t1
                           ,giri_binder t2
                           ,giri_frps_ri t3
                           ,giri_frps_peril_grp t4
                           ,giis_peril t5
                     WHERE t1.fnl_binder_id = t2.fnl_binder_id
                       AND t2.fnl_binder_id = t3.fnl_binder_id
                       AND t3.line_cd             = t4.line_cd
                       AND t3.frps_yy             = t4.frps_yy
                       AND t3.frps_seq_no     = t4.frps_seq_no
                       AND t1.peril_seq_no  = t4.peril_seq_no
                       AND t5.line_cd             = t4.line_cd
                       AND t5.peril_cd             = t4.peril_cd
                       AND t2.line_cd                = p_line_cd
                       AND t2.binder_yy            = p_binder_yy
                       AND t2.binder_seq_no    = p_binder_seq_no
                     ORDER BY 3)
        LOOP
            v_bndr_peril_dtls.peril_sname       := i.peril_sname;
            v_bndr_peril_dtls.fnl_binder_id     := i.fnl_binder_id;
            v_bndr_peril_dtls.peril_seq_no      := i.peril_seq_no;            
            v_bndr_peril_dtls.ri_share_pct      := i.ri_shr_pct;
            v_bndr_peril_dtls.ri_tsi_amt        := i.ri_tsi_amt;     
            v_bndr_peril_dtls.ri_prem_amt       := i.ri_prem_amt;
            v_bndr_peril_dtls.ri_comm_amt       := i.ri_comm_amt;
            v_bndr_peril_dtls.ri_comm_rt        := i.ri_comm_rt;
            v_bndr_peril_dtls.ri_comm_vat       := i.ri_comm_vat;
            v_bndr_peril_dtls.ri_wholding_vat   := i.ri_wholding_vat;
            v_bndr_peril_dtls.ri_prem_vat       := i.ri_prem_vat;
            v_bndr_peril_dtls.ri_prem_tax       := i.prem_tax;
            v_bndr_peril_dtls.gross_prem        := i.gross_prem_amt;
            
            PIPE ROW(v_bndr_peril_dtls);
            
        END LOOP;
    END get_binder_peril_dtls;
    
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Returns required values for GIRIS051 Binder tab
    */
    PROCEDURE CHECK_RIREPORTS_BINDER (
        p_line_cd           IN VARCHAR2,
        p_binder_yy         IN NUMBER,
        p_binder_seq_no     IN NUMBER,
        p_is_line_cd        IN VARCHAR2,    --check if procedure was called by line_cd field 
        p_remarks_sw        IN VARCHAR2,
        p_local_curr        IN NUMBER,
        v_reversed          OUT VARCHAR2,
        v_replaced          OUT VARCHAR2,
        v_nbt_grp           OUT VARCHAR2,
        v_negated           OUT VARCHAR2,
        v_attention         OUT VARCHAR2,
        v_remarks           OUT VARCHAR2,
        v_bndr_remarks1     OUT VARCHAR2,
        v_bndr_remarks2     OUT VARCHAR2,
        v_bndr_remarks3     OUT VARCHAR2,
        v_read_only_attn    OUT VARCHAR2,
        --v_enable_nbt_grp    OUT VARCHAR2,
        v_enable_replaced   OUT VARCHAR2,
        v_enable_negated    OUT VARCHAR2,
        v_enable_local_curr OUT VARCHAR2,
        v_visible_prnt_opt  OUT VARCHAR2,
        v_giri_binder       OUT VARCHAR2,
        v_giri_group_binder OUT VARCHAR2  
    )
    AS
        CURSOR fnl_binder_id IS (SELECT fnl_binder_id
                                   FROM giri_binder
                                  WHERE line_cd = p_line_cd
                                    AND binder_yy = p_binder_yy
                                    AND binder_seq_no = p_binder_seq_no);
                                      
        CURSOR curr IS (SELECT currency_cd
                          FROM giri_distfrps a, 
                               giri_frps_ri b,
                               giri_binder c
                         WHERE a.line_cd = b.line_cd
                           AND a.frps_yy = b.frps_yy
                           AND a.frps_seq_no = b.frps_seq_no
                           AND b.fnl_binder_id = c.fnl_binder_id
                           AND c.line_cd = p_line_cd
                           AND c.binder_yy = p_binder_yy
                           AND c.binder_seq_no = p_binder_seq_no); 
                                      
        v_fnl_binder_id     giri_binder.fnl_binder_id%TYPE;
        v_master_bndr_id    giri_group_binder.master_bndr_id%TYPE;
        v_exist_sw          VARCHAR2(1) := 'N';
        v_exist             VARCHAR2(1) := 'N';
        a_exist             VARCHAR2(1) := 'N';
        y_exist             VARCHAR2(1) := 'N';
        v_negated1          VARCHAR2(1) := 'N';
        v_curr              NUMBER;
    BEGIN          
         OPEN fnl_binder_id;
           FETCH fnl_binder_id
           INTO v_fnl_binder_id;
         OPEN curr;
           FETCH curr
           INTO v_curr;
         IF v_curr != p_local_curr THEN
            v_enable_local_curr := 'Y';
         ELSE
            v_enable_local_curr := 'N';
         END IF;    
               
         v_reversed := 'N';
         v_replaced := 'N';
         v_nbt_grp  := 'N';
         v_negated  := 'N';
             
         --revised by mgc to retrieve the remarks from giri_group_binder
         --03-06-2001
         FOR A IN (SELECT bndr_remarks1, bndr_remarks2, bndr_remarks3, 
                          reverse_date, master_bndr_id
                     FROM giri_group_binder
                    WHERE line_cd = p_line_cd
                      AND binder_yy = p_binder_yy
                      AND binder_seq_no = p_binder_seq_no) LOOP
             v_nbt_grp := 'Y';
             v_master_bndr_id := a.master_bndr_id;
             v_read_only_attn := 'Y';              
             --v_enable_nbt_grp := 'Y';  
             
             IF p_is_line_cd = 'N' THEN
                 v_visible_prnt_opt := 'Y';
             END IF;
             
             v_bndr_remarks1 := a.bndr_remarks1;  
             v_bndr_remarks2 := a.bndr_remarks2;  
             v_bndr_remarks3 := a.bndr_remarks3; 
                  
             IF a.reverse_date IS NOT NULL THEN
                v_reversed := 'Y';
             END IF; 
                      
             y_exist := 'Y';
             EXIT;
         END LOOP;    
             
         FOR C IN (SELECT reverse_date
                     FROM giri_binder
                    WHERE line_cd = p_line_cd
                      AND binder_yy = p_binder_yy
                      AND binder_seq_no = p_binder_seq_no
                      AND reverse_date IS NOT NULL ) LOOP  
                 v_reversed := 'Y';
             EXIT;
         END LOOP;
             
         FOR E IN (SELECT lnk_binder_id
                     FROM giri_bindrel
                    WHERE fnl_binder_id = v_fnl_binder_id
                      AND lnk_binder_id IS NOT NULL) LOOP
             v_replaced := 'Y';
             v_enable_replaced := 'Y';
             EXIT;
         END LOOP;    
                       
         FOR F IN (SELECT line_cd, frps_yy, frps_seq_no
                     FROM giri_frps_ri
                    WHERE fnl_binder_id = v_fnl_binder_id
                        ORDER BY frps_yy DESC, frps_seq_no DESC ) LOOP   -- jhing 03.30.2016 GENQA 5092 added order by to enable correct tagging of negated for reused binder
             FOR G IN (SELECT ri_flag
                         FROM giri_distfrps
                        WHERE line_cd = f.line_cd
                          AND frps_yy = f.frps_yy
                          AND frps_seq_no = f.frps_seq_no
                          AND ri_flag = '4') LOOP
                 v_negated := 'Y';
                 v_enable_negated := 'Y';
                 EXIT;
             END LOOP;
        --         EXIT;             
        -- commented by rbd - to fetch all frps of that binder
            EXIT ; -- jhing 03.30.2016 GENQA 5092 added order by to enable correct tagging of negated for reused binder
         END LOOP;
             
         FOR F IN (SELECT line_cd, frps_yy, frps_seq_no, a.fnl_binder_id
                     FROM giri_frps_ri a, giri_group_bindrel_rev b
                    WHERE a.fnl_binder_id = b.fnl_binder_id
                      AND b.master_bndr_id = v_master_bndr_id) LOOP
             FOR G IN (SELECT ri_flag
                         FROM giri_distfrps
                        WHERE line_cd = f.line_cd
                          AND frps_yy = f.frps_yy
                          AND frps_seq_no = f.frps_seq_no
                          AND ri_flag = '4') LOOP
                 v_negated := 'Y';
                 v_fnl_binder_id := f.fnl_binder_id;
                 v_enable_negated := 'Y';
                 EXIT;
             END LOOP;
            --     EXIT;             
            -- commented by rbd - to fetch all frps of that binder
        END LOOP;           
            -- added by rbd - to enable Negated checkbox

        FOR G IN (SELECT 'A'
                 FROM giri_distfrps D060, giri_frps_ri D050
                WHERE D060.line_cd = D050.line_cd
                  AND D060.frps_yy = D050.frps_yy
                      AND D060.frps_seq_no = D050.frps_seq_no
                      AND D050.fnl_binder_id = v_fnl_binder_id
                      AND D060.ri_flag <> '4') LOOP
             IF v_negated1 = 'Y' THEN
                v_negated := 'N';
             END IF;
             EXIT;
         END LOOP;
        --         
        IF p_remarks_sw = 'N' OR v_nbt_grp = 'N' THEN -- apollo cruz sr# 19929 - added v_nbt_grp to fetch information for normal binders             
            FOR A IN (SELECT attention
                        FROM giri_binder
                       WHERE fnl_binder_id = v_fnl_binder_id) 
            LOOP  
                v_attention := a.attention;
                a_exist := 'Y';
                EXIT;
            END LOOP;
                
            FOR B IN (SELECT remarks,bndr_remarks1,bndr_remarks2,bndr_remarks3
                        FROM giri_frps_ri
                       WHERE fnl_binder_id = v_fnl_binder_id) LOOP 
               v_remarks := b.remarks;
               v_bndr_remarks1 := b.bndr_remarks1;  
               v_bndr_remarks2 := b.bndr_remarks2;  
               v_bndr_remarks3 := b.bndr_remarks3;  
               y_exist := 'Y';
               EXIT;
            END LOOP;           
            --:binder.remarks_sw := 'Y';             
         END IF;
             
         IF y_exist = 'N' THEN             
            v_remarks       := NULL;
            v_bndr_remarks1 := NULL;  
            v_bndr_remarks2 := NULL;  
            v_bndr_remarks3 := NULL;  
         END IF;  
             
         IF a_exist = 'N' THEN             
            v_attention := NULL;             
         END IF;   
             
        CLOSE fnl_binder_id;

        --for validation of giri_binder and giri_group_binder
        FOR C IN (SELECT '1' BINDER
 	    				FROM GIRI_BINDER
 					   WHERE LINE_CD       = p_line_cd
					     AND BINDER_YY     = p_binder_yy		
					     AND BINDER_SEQ_NO = p_binder_seq_no )LOOP
			v_giri_binder := C.BINDER;
        END LOOP;
        
        IF v_giri_binder IS NULL THEN
             FOR A IN (SELECT '1' BINDER
                         FROM GIRI_GROUP_BINDER
                        WHERE LINE_CD       = p_line_cd
                          AND BINDER_YY     = p_binder_yy		
                          AND BINDER_SEQ_NO = p_binder_seq_no )LOOP
                   v_giri_group_binder := A.BINDER;
             END LOOP;
        END IF;	
        
        
    END check_rireports_binder;
    
    
    /*
    * Referenced by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    * taken from function VALIDATE_BOND_RENEWAL to remove OUT parameters  
    */
    PROCEDURE validate_bond_rnwl (
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER,
        p_valid             OUT VARCHAR2, 
        p_old_fnl_binder_id OUT NUMBER, 
        p_fnl_binder_id     OUT NUMBER,
        p_return            OUT NUMBER
    )
    AS
        v_line_cd           VARCHAR2(20);
        v_frps_yy           NUMBER(2);
        v_frps_seq_no       NUMBER(10);
        v_ri_cd             NUMBER(5);  -- added: 4.18.11

        v_dist_no           NUMBER(10);

        v_subline_cd        VARCHAR2(20);
        v_iss_cd            VARCHAR2(20);
        v_issue_yy          NUMBER(2);
        v_pol_seq_no        NUMBER(10);
        v_renew_no          NUMBER(2); -- added: 4.19.11

        v_incept_date       DATE;
        v_expiry_date       DATE;
        v_eff_date          DATE;
        v_endt_expiry_date  DATE;
        v_endt_seq_no       NUMBER(10);

        v_orig_policy_id    NUMBER(10);
        v_endt_policy_id    NUMBER(10);

        v_orig_binder_id    NUMBER(10); -- added: 4.19.11
        v_endt_binder_id    NUMBER(10); -- added: 4.19.11

        TYPE va_number IS varray(2) of NUMBER(10);   -- type of array
        v_policy_ids        va_number;               -- array of policy_ids

        v_valid             CHAR;
        v_binder_ids        va_number;               -- array of binders

    BEGIN
        -- check if binder has values
        /*SELECT b.line_cd, b.frps_yy, b.frps_seq_no, b.ri_cd, a.fnl_binder_id
          INTO v_line_cd, v_frps_yy, v_frps_seq_no, v_ri_cd, v_endt_binder_id -- ri_cd, binder_id: 4.19.11
          FROM giri_binder a,
               giri_frps_ri b
         WHERE a.fnl_binder_id  = b.fnl_binder_id
           AND a.line_cd        = p_line_cd
           AND a.binder_yy      = p_binder_yy
           AND a.binder_seq_no  = p_binder_seq_no;*/
	
    -- jhing 03.30.2016 GENQA 5092 commented out and replaced query. Produces ORA-01422 
    -- for reused binders with different FRPS_YY
    /*
	   -- apollo cruz sr#19929 - for proper fetching of frps no and fnl_binder_id
       SELECT b.line_cd, b.frps_yy, MAX(b.frps_seq_no), b.ri_cd, a.fnl_binder_id
         INTO v_line_cd, v_frps_yy, v_frps_seq_no, v_ri_cd, v_endt_binder_id
         FROM giri_binder a, giri_frps_ri b
        WHERE a.fnl_binder_id = b.fnl_binder_id
          AND a.line_cd = p_line_cd
          AND a.binder_yy = p_binder_yy
          AND a.binder_seq_no = p_binder_seq_no
     GROUP BY b.line_cd, b.frps_yy, b.ri_cd, a.fnl_binder_id;  */
     -- jhing 03.30.2016 new query GENQA 5092 
         FOR bndr1 IN ( SELECT b.line_cd,
                                 b.frps_yy,
                                 b.frps_seq_no,
                                 b.ri_cd,
                                 a.fnl_binder_id
                            FROM giri_binder a, giri_frps_ri b
                           WHERE     a.fnl_binder_id = b.fnl_binder_id
                                 AND a.line_cd = p_line_cd
                                 AND a.binder_yy = p_binder_yy
                                 AND a.binder_seq_no = p_binder_seq_no
                        ORDER BY b.frps_yy DESC, b.frps_seq_no DESC)
         LOOP   
            v_line_cd := bndr1.line_cd ;
            v_frps_yy := bndr1.frps_yy ;
            v_frps_seq_no :=  bndr1.frps_seq_no ;
            v_ri_cd :=  bndr1.ri_cd  ;
            v_endt_binder_id :=  bndr1.fnl_binder_id ; 
            
            EXIT; 
         END LOOP; 
               
         IF v_line_cd IS NOT NULL AND v_frps_yy IS NOT NULL and v_frps_seq_no IS NOT NULL THEN
            -- get dist_no of binder based on binder values
            SELECT dist_no
              INTO v_dist_no
              FROM giri_distfrps a,
                   giri_frps_ri b
             WHERE a.line_cd = b.line_cd
               AND a.frps_yy = b.frps_yy
               AND a.frps_seq_no = b.frps_seq_no
               AND b.line_cd = v_line_cd
               AND b.frps_yy = v_frps_yy
               AND b.frps_seq_no = v_frps_seq_no
               AND b.ri_cd = v_ri_cd                    -- 4.18.11
             GROUP BY dist_no;
          
               IF v_dist_no IS NOT NULL THEN
                -- get policy no of binder and check binder validity based on no. of days
                SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no, b.incept_date, b.expiry_date, b.eff_date, b.endt_expiry_date, b.endt_seq_no
                  INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_incept_date, v_expiry_date, v_eff_date, v_endt_expiry_date, v_endt_seq_no
                  FROM giuw_pol_dist a,
                       gipi_polbasic b
                 WHERE a.policy_id = b.policy_id
                   AND a.dist_no = v_dist_no;
         
                 IF (v_expiry_date - v_incept_date) = (v_endt_expiry_date - v_eff_date) AND v_expiry_date = v_eff_date THEN
     
                     IF v_line_cd IS NOT NULL AND v_subline_cd IS NOT NULL and v_iss_cd IS NOT NULL AND v_issue_yy IS NOT NULL AND 
                        v_pol_seq_no IS NOT NULL AND v_renew_no IS NOT NULL THEN  -- added renew no 4.19.11
                       
                        --get policy_id of the original
                        SELECT policy_id
                          INTO v_orig_policy_id
                          FROM gipi_polbasic
                         WHERE line_cd      = v_line_cd
                           AND subline_cd   = v_subline_cd
                           AND iss_cd       = v_iss_cd
                           AND issue_yy     = v_issue_yy
                           AND pol_seq_no   = v_pol_seq_no
                           AND renew_no     = v_renew_no
                           AND endt_seq_no  = 0;            -- original policy
     
                        -- get Distribution No of original policy
                        SELECT dist_no
                          INTO v_dist_no
                          FROM giuw_pol_dist a,
                               gipi_polbasic b
                         WHERE a.policy_id = b.policy_id
                           AND b.policy_id = v_orig_policy_id;
                               
                        -- get line_cd, frps_yy, frps_seq_no, of original policy
                        SELECT line_cd, frps_yy, frps_seq_no
                          INTO v_line_cd, v_frps_yy, v_frps_seq_no
                          FROM giri_distfrps a,
                               giuw_pol_dist b
                         WHERE a.dist_no = b.dist_no
                           AND b.dist_no = v_dist_no;                           
                               
                        -- get final binder id of original policy
                        SELECT a.fnl_binder_id
                          INTO v_orig_binder_id
                          FROM giri_binder a,
                               giri_frps_ri b
                         WHERE a.fnl_binder_id = b.fnl_binder_id
                           AND b.ri_cd = v_ri_cd                    -- variable ri_cd : 4.18.11
                           AND b.line_cd = v_line_cd
                           AND b.frps_yy = v_frps_yy
                           AND b.frps_seq_no = v_frps_seq_no;
                    
                        p_valid := 'Y';
                        p_old_fnl_binder_id := v_orig_binder_id; -- original binder id
                        p_fnl_binder_id     := v_endt_binder_id; -- endorsement binder id
                        
                     END IF;
                      
                 ELSE
                     p_valid := 'N'; 
                     p_old_fnl_binder_id := 0;
                     p_fnl_binder_id     := 0; 
                 END IF;
               
               ELSE
                p_valid := 'N';
                p_old_fnl_binder_id := 0;
                p_fnl_binder_id     := 0;             
               END IF;
               
         ELSE
         p_valid := 'N';
         p_old_fnl_binder_id := 0;
         p_fnl_binder_id     := 0; 
         
         END IF;
        
        p_return := 1;
        
    EXCEPTION WHEN no_data_found THEN
        p_valid := 'N';
        p_old_fnl_binder_id := 0;
        p_fnl_binder_id     := 0;      
        p_return := 0;

    END validate_bond_rnwl;
    
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Returns lnk_binder_id to allow untagging of Replaced checkbox
    */
    FUNCTION check_binder_replaced(
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER        
    ) RETURN NUMBER
    AS
        v_link     giri_binder.fnl_binder_id%TYPE;
    BEGIN
        FOR A IN  (SELECT fnl_binder_id
                     FROM giri_binder
                    WHERE line_cd = p_line_cd
                      AND binder_yy = p_binder_yy
                      AND binder_seq_no = p_binder_seq_no) LOOP   
            FOR B IN  (SELECT lnk_binder_id
                         FROM giri_bindrel
                        WHERE fnl_binder_id = a.fnl_binder_id) LOOP
                v_link := b.lnk_binder_id;
                EXIT;
            END LOOP;    
               	
	        EXIT;
	   END LOOP;   
       
       RETURN (v_link);
    END check_binder_replaced;
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Returns record count of same fnl_binder_id that will be used to allow untagging of Negated checkbox
    */
    FUNCTION check_binder_negated(
        p_line_cd           VARCHAR2, 
        p_binder_yy         NUMBER, 
        p_binder_seq_no     NUMBER
    ) RETURN NUMBER
    AS
        v_count	    NUMBER;
        v_binder_id     giri_binder.fnl_binder_id%TYPE ; --  jhing 03.30.2016 GENQA 5092
    BEGIN
        -- jhing 03.30.2016 GENQA 5092 revised query. v_count is used as identifier for negated. if v_count = 1 then it is negated 
        -- hence query is incorrect since even recently posted binder will be considered as negated   
        /*FOR A IN  (SELECT fnl_binder_id
                     FROM giri_binder
                    WHERE line_cd = p_line_cd
                      AND binder_yy = p_binder_yy
                      AND binder_seq_no = p_binder_seq_no) LOOP   
  	        FOR B IN  (SELECT count (*) rec --more than 1 record of the same fnl_binder_id denotes that the binder is re-used
                         FROM giri_frps_ri
                        WHERE fnl_binder_id = a.fnl_binder_id) LOOP
                v_count := b.rec;
                EXIT;
            END LOOP;    
               	
	        EXIT;
  	    END LOOP; */

       -- jhing 03.30.2016 GENQA 5092 new query to identify negated 
        v_count :=  0 ; 
        FOR cur in ( select fnl_binder_id from giri_binder
                                WHERE line_cd = p_line_cd
                                        AND binder_yy = p_binder_yy
                                        AND binder_seq_no = p_binder_seq_no )
        LOOP
            v_binder_id := cur.fnl_binder_id ; 
            EXIT;
        END LOOP; 
        
        FOR cur2 IN (SELECT b.ri_flag 
                                FROM giri_frps_ri a , giri_distfrps b
                                        WHERE a.fnl_binder_id = v_binder_id 
                                            AND a.line_cd = b.line_cd
                                            AND a.frps_yy = b.frps_yy
                                            AND a.frps_seq_no = b.frps_seq_no
                                            ORDER BY a.line_cd, b.frps_yy DESC, b.frps_seq_no DESC )
        LOOP
            IF cur2.ri_flag = '4' THEN
                v_count := 1 ;
            END IF;
            EXIT; 
        END LOOP;        
        
        RETURN (v_count);
    END check_binder_negated;
    
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Updates GIRI_BINDER and GIRI_FRPS_RI tables
    */
    PROCEDURE update_binder_remarks(
        p_line_cd   		giri_binder.line_cd%TYPE, 
        p_binder_yy    	    giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE,
        p_attention         GIRI_BINDER.ATTENTION%TYPE,
        p_remarks           giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1     giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2     giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3     giri_frps_ri.BNDR_REMARKS3%TYPE
    )
    AS
    BEGIN
        UPDATE GIRI_BINDER
           SET ATTENTION     = p_attention
         WHERE LINE_CD       = p_line_cd
           AND BINDER_YY     = p_binder_yy
           AND BINDER_SEQ_NO = p_binder_seq_no;
           
        FOR A IN (SELECT fnl_binder_id
                    FROM giri_binder 
                   WHERE line_cd = p_line_cd
                     AND binder_yy = p_binder_yy
                     AND binder_seq_no = p_binder_seq_no) LOOP 
           UPDATE giri_frps_ri
           SET remarks = p_remarks,
               bndr_remarks1 = p_bndr_remarks1,
               bndr_remarks2 = p_bndr_remarks2,   
               bndr_remarks3 = p_bndr_remarks3
           WHERE fnl_binder_id = a.fnl_binder_id;
           EXIT;
        END LOOP;   
               
    END update_binder_remarks;
    
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Updates GIRI_BINDER and GIRI_FRPS_RI tables
    */
    PROCEDURE update_giri_bnder(
        p_line_cd   		IN OUT giri_binder.line_cd%TYPE, 
        p_binder_yy    	    IN OUT giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     IN OUT giri_binder.binder_seq_no%TYPE,
        p_reversed                 VARCHAR2,
        p_replaced                 VARCHAR2,
        p_negated                  VARCHAR2,
        p_attention                GIRI_BINDER.ATTENTION%TYPE,
        p_remarks                  giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1            giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2            giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3            giri_frps_ri.BNDR_REMARKS3%TYPE
    )
    AS
        CURSOR fnl_binder_id IS (SELECT fnl_binder_id
                                   FROM giri_binder 
                                  WHERE line_cd = p_line_cd
                                    AND binder_yy = p_binder_yy
                                    AND binder_seq_no = p_binder_seq_no);
        v_fnl_binder_id     giri_binder.fnl_binder_id%TYPE;
        v_line_cd           giri_binder.line_cd%TYPE;
        v_binder_yy         giri_binder.binder_yy%TYPE;
        v_binder_seq_no     giri_binder.binder_seq_no%TYPE;
        v_link              giri_binder.fnl_binder_id%TYPE;
    BEGIN
        update_binder_remarks(p_line_cd, p_binder_yy, p_binder_seq_no, p_attention, p_remarks, p_bndr_remarks1, p_bndr_remarks2, p_bndr_remarks3);
        
        OPEN fnl_binder_id;
       FETCH fnl_binder_id
        INTO v_fnl_binder_id;
       CLOSE fnl_binder_id;
                
        IF (p_reversed = 'N' AND p_replaced = 'N' AND p_negated = 'N') OR (p_reversed = 'N' AND p_replaced = 'N' AND p_negated = 'Y') THEN
            UPDATE giri_binder
               SET bndr_print_date = SYSDATE,
                   bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE fnl_binder_id = v_fnl_binder_id;    
            UPDATE giri_frps_ri
               SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE fnl_binder_id = v_fnl_binder_id;
        
        ELSIF (p_reversed = 'Y' AND p_replaced = 'N' AND p_negated = 'N') OR (p_reversed = 'Y' AND p_replaced = 'N' AND p_negated = 'Y') THEN
            UPDATE giri_binder
               SET bndr_print_date = SYSDATE,
                 bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE fnl_binder_id = v_fnl_binder_id;
            UPDATE giri_frps_ri
               SET revrs_bndr_printed_cnt = nvl(revrs_bndr_printed_cnt,0) + 1,
                    revrs_bndr_print_date = SYSDATE
             WHERE fnl_binder_id = v_fnl_binder_id;    
             
        ELSIF (p_reversed = 'N' AND p_replaced = 'Y' AND p_negated = 'N') OR (p_reversed = 'Y' AND p_replaced = 'Y' AND p_negated = 'N') OR
              (p_reversed = 'N' AND p_replaced = 'Y' AND p_negated = 'Y') OR (p_reversed = 'Y' AND p_replaced = 'Y' AND p_negated = 'Y') THEN
            FOR B IN (SELECT lnk_binder_id
                        FROM giri_bindrel
                       WHERE fnl_binder_id = v_fnl_binder_id) LOOP
                v_link := b.lnk_binder_id;
                EXIT;
            END LOOP;          	
            FOR D IN (SELECT line_cd,binder_yy,binder_seq_no 
                        FROM giri_binder
                       WHERE fnl_binder_id = v_link) LOOP
                p_line_cd := d.line_cd;
                p_binder_yy := d.binder_yy;
                p_binder_seq_no := d.binder_seq_no;       	               
                EXIT;
            END LOOP;  
        
            /*p_line_cd       := v_line_cd;
            p_binder_yy     := v_binder_yy;
            p_binder_seq_no := v_binder_seq_no;*/
            
            update_binder_remarks(p_line_cd, p_binder_yy, p_binder_seq_no, p_attention, p_remarks, p_bndr_remarks1, p_bndr_remarks2, p_bndr_remarks3);
            
            UPDATE giri_binder
               SET bndr_print_date = SYSDATE,
                   bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE line_cd = p_line_cd
               AND binder_yy = p_binder_yy
               AND binder_seq_no = p_binder_seq_no;                   
             FOR A IN (SELECT fnl_binder_id
                         FROM giri_binder 
                        WHERE line_cd = p_line_cd
                          AND binder_yy = p_binder_yy
                          AND binder_seq_no = p_binder_seq_no) LOOP 
                 UPDATE giri_frps_ri
                 SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
                 WHERE fnl_binder_id = a.fnl_binder_id;
                 EXIT;
             END LOOP;       
            
        END IF;    
    
    END update_giri_bnder;
    
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Updates GIRI_GROUP_BINDER and GIRI_FRPS_RI tables
    */
    PROCEDURE update_giri_group_bnder(
        p_line_cd   		IN OUT giri_binder.line_cd%TYPE, 
        p_binder_yy    	    IN OUT giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     IN OUT giri_binder.binder_seq_no%TYPE,
        p_reversed                 VARCHAR2,
        p_replaced                 VARCHAR2,
        p_remarks                  giri_frps_ri.REMARKS%TYPE,
        p_bndr_remarks1            giri_frps_ri.BNDR_REMARKS1%TYPE,
        p_bndr_remarks2            giri_frps_ri.BNDR_REMARKS2%TYPE,
        p_bndr_remarks3            giri_frps_ri.BNDR_REMARKS3%TYPE  
        
    )
    AS
        v_master_bndr_id    giri_frps_ri.master_bndr_id%TYPE; 
        v_fnl_binder_id     giri_frps_ri.fnl_binder_id%TYPE;  
        v_line_cd           giri_binder.line_cd%TYPE;
        v_binder_yy         giri_binder.binder_yy%TYPE;
        v_binder_seq_no     giri_binder.binder_seq_no%TYPE;
        v_link              giri_binder.fnl_binder_id%TYPE;   
        
    BEGIN
        UPDATE GIRI_GROUP_BINDER
           SET BNDR_REMARKS1 = p_bndr_remarks1,
               BNDR_REMARKS2 = p_bndr_remarks2,
               BNDR_REMARKS3 = p_bndr_remarks3
         WHERE LINE_CD       = p_line_cd
           AND BINDER_YY     = p_binder_yy
           AND BINDER_SEQ_NO = p_binder_seq_no;     

        FOR A IN (SELECT master_bndr_id
                    FROM giri_group_binder 
                   WHERE line_cd = p_line_cd
                     AND binder_yy = p_binder_yy
                     AND binder_seq_no = p_binder_seq_no) LOOP 
            v_master_bndr_id := a.master_bndr_id;
            UPDATE giri_frps_ri
               SET remarks = p_remarks,
                   bndr_remarks1 = p_bndr_remarks1,
                   bndr_remarks2 = p_bndr_remarks2,   
                   bndr_remarks3 = p_bndr_remarks3
             WHERE master_bndr_id = a.master_bndr_id;
            EXIT;
        END LOOP;          
        FOR B IN (SELECT fnl_binder_id
                    FROM giri_group_binder a, giri_group_bindrel_rev b
                   WHERE a.master_bndr_id = b.master_bndr_id
                     AND a.line_cd = p_line_cd
                     AND a.binder_yy = p_binder_yy
                     AND a.binder_seq_no = p_binder_seq_no) LOOP 
            v_fnl_binder_id := b.fnl_binder_id;
            UPDATE giri_frps_ri
               SET remarks = p_remarks,
                   bndr_remarks1 = p_bndr_remarks1,
                   bndr_remarks2 = p_bndr_remarks2,   
                   bndr_remarks3 = p_bndr_remarks3
             WHERE fnl_binder_id = b.fnl_binder_id;
            EXIT;
        END LOOP;          
    
        IF p_reversed = 'N' AND p_replaced = 'N' THEN
            FOR A IN (SELECT fnl_binder_id
                        FROM giri_frps_ri
                       WHERE master_bndr_id = v_master_bndr_id) LOOP
                UPDATE giri_frps_ri
                   SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
                 WHERE fnl_binder_id = a.fnl_binder_id;                 
                EXIT;
            END LOOP;                  
    
        ELSIF p_reversed = 'Y' AND p_replaced = 'N' THEN
            UPDATE giri_frps_ri
               SET revrs_bndr_printed_cnt = nvl(revrs_bndr_printed_cnt,0) + 1,
                  revrs_bndr_print_date = SYSDATE   
             WHERE fnl_binder_id = v_fnl_binder_id;
             
        ELSIF p_reversed = 'N' AND p_replaced = 'Y' THEN
            FOR A IN (SELECT fnl_binder_id
                        FROM giri_frps_ri
                       WHERE master_bndr_id = v_master_bndr_id) LOOP
                UPDATE giri_frps_ri
                   SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
                 WHERE fnl_binder_id = a.fnl_binder_id;
                FOR B IN (SELECT lnk_binder_id
                           FROM giri_bindrel
                          WHERE fnl_binder_id = a.fnl_binder_id) LOOP
                   v_link := b.lnk_binder_id;       	  
                   EXIT;
                END LOOP;    
            END LOOP;                    
                
            FOR D IN (SELECT line_cd,binder_yy,binder_seq_no 
                       FROM giri_binder
                      WHERE fnl_binder_id = v_link) LOOP
               v_line_cd := d.line_cd;
               v_binder_yy := d.binder_yy;
               v_binder_seq_no := d.binder_seq_no;       	               
               EXIT;
            END LOOP;    
           
            p_line_cd       := v_line_cd;
            p_binder_yy     := v_binder_yy;
            p_binder_seq_no := v_binder_seq_no;  
            
            UPDATE giri_binder
               SET bndr_print_date = SYSDATE,
                  bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE line_cd = v_line_cd
               AND binder_yy = v_binder_yy
               AND binder_seq_no = v_binder_seq_no;
            FOR X IN (SELECT fnl_binder_id
                        FROM giri_binder
                       WHERE line_cd = v_line_cd
                         AND binder_yy = v_binder_yy
                         AND binder_seq_no = v_binder_seq_no) LOOP
               UPDATE giri_frps_ri
                  SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
                WHERE fnl_binder_id = x.fnl_binder_id;
               EXIT;
            END LOOP;              
            	              
    
        ELSIF p_reversed = 'Y' AND p_replaced = 'Y' THEN
            UPDATE giri_frps_ri
               SET revrs_bndr_printed_cnt = nvl(revrs_bndr_printed_cnt,0) + 1,
                  revrs_bndr_print_date = SYSDATE       	 
             WHERE fnl_binder_id = v_fnl_binder_id;
            FOR B IN (SELECT lnk_binder_id   
                        FROM giri_bindrel
                       WHERE fnl_binder_id = v_fnl_binder_id) LOOP
                v_link := b.lnk_binder_id;
                EXIT;
            END LOOP;            
            FOR D IN (SELECT line_cd,binder_yy,binder_seq_no 
                        FROM giri_binder
                       WHERE fnl_binder_id = v_link) LOOP
               v_line_cd := d.line_cd;
               v_binder_yy := d.binder_yy;
               v_binder_seq_no := d.binder_seq_no;       	
               EXIT;
            END LOOP;    
            
            p_line_cd       := v_line_cd;
            p_binder_yy     := v_binder_yy;
            p_binder_seq_no := v_binder_seq_no;
            
            UPDATE giri_binder
               SET bndr_print_date = SYSDATE,
                  bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
             WHERE line_cd = v_line_cd
               AND binder_yy = v_binder_yy
               AND binder_seq_no = v_binder_seq_no;
            FOR A IN (SELECT fnl_binder_id
                        FROM giri_binder
                       WHERE line_cd = v_line_cd 
                         AND binder_yy = v_binder_yy
                         AND binder_seq_no = v_binder_seq_no ) LOOP
               UPDATE giri_frps_ri
                  SET bndr_printed_cnt = nvl(bndr_printed_cnt,0) + 1
                WHERE fnl_binder_id = a.fnl_binder_id;
               EXIT;
            END LOOP;  
            
        END IF;
        
    END update_giri_group_bnder;
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Insert a record on GIRI_BINDER_PERIL_PRINT_HIST every time the peril details is modified
    */
    PROCEDURE add_binder_peril_print_hist (
        p_fnl_binder_id         GIRI_BINDER_PERIL_PRINT_HIST.FNL_BINDER_ID%TYPE ,
        p_peril_seq_no          GIRI_BINDER_PERIL_PRINT_HIST.PERIL_SEQ_NO%TYPE ,                       
        p_ri_share_pct          GIRI_BINDER_PERIL_PRINT_HIST.RI_SHR_PCT%TYPE ,
        p_ri_tsi_amt            GIRI_BINDER_PERIL_PRINT_HIST.RI_TSI_AMT%TYPE ,
        p_ri_prem_amt           GIRI_BINDER_PERIL_PRINT_HIST.RI_PREM_AMT%TYPE ,
        p_ri_comm_rt            GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_RT%TYPE ,
        p_ri_comm_amt           GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_AMT%TYPE ,
        p_ri_comm_vat           GIRI_BINDER_PERIL_PRINT_HIST.RI_COMM_VAT%TYPE ,
        p_ri_wholding_vat       GIRI_BINDER_PERIL_PRINT_HIST.RI_WHOLDING_VAT%TYPE,
        p_ri_prem_vat           GIRI_BINDER_PERIL_PRINT_HIST.RI_PREM_VAT%TYPE ,
        p_ri_prem_tax           GIRI_BINDER_PERIL_PRINT_HIST.PREM_TAX%TYPE ,
        p_gross_prem            GIRI_BINDER_PERIL_PRINT_HIST.GROSS_PREM_AMT%TYPE
    )
    AS
        v_hist_no      giri_binder_peril_print_hist.hist_no%TYPE;
    BEGIN
        FOR A IN (SELECT NVL(MAX(hist_no), 0) hist_no
                    FROM giri_binder_peril_print_hist
                   WHERE fnl_binder_id = p_fnl_binder_id)
        LOOP
            v_hist_no := a.hist_no + 1;
        END LOOP;
        
        INSERT INTO GIRI_BINDER_PERIL_PRINT_HIST
                    (fnl_binder_id, 
                    peril_seq_no, 
                    hist_no, 
                    ri_tsi_amt,
                    ri_shr_pct, 
                    ri_prem_amt, 
                    ri_comm_rt, 
                    ri_comm_amt,
                    ri_prem_vat, 
                    ri_comm_vat, 
                    ri_wholding_vat, 
                    prem_tax, 
                    gross_prem_amt)
             VALUES (p_fnl_binder_id, 
                    p_peril_seq_no, 
                    v_hist_no, 
                    p_ri_tsi_amt,
                    p_ri_share_pct, 
                    p_ri_prem_amt, 
                    p_ri_comm_rt, 
                    p_ri_comm_amt,
                    p_ri_prem_vat, 
                    p_ri_comm_vat, 
                    p_ri_wholding_vat, 
                    p_ri_prem_tax, 
                    p_gross_prem);
             
    END add_binder_peril_print_hist;
    
    /*
    ** Reference by GIRIS051 - Generate Reinsurance Reports (Binder tab)
    ** Retrieves fnl_binder_id and policy_id based on the given GIRIR121 report version
    */    
    PROCEDURE get_girir121_fnl_binder_id(
        p_version           giis_reports.VERSION%TYPE,
        p_line_cd   		giri_binder.line_cd%TYPE, 
        p_binder_yy    	    giri_binder.binder_yy%TYPE, 
        p_binder_seq_no     giri_binder.binder_seq_no%TYPE,
        v_fnl_binder_id OUT giri_frps_ri.FNL_BINDER_ID%TYPE,
        v_policy_id     OUT giuw_pol_dist.POLICY_ID%TYPE
    ) 
    AS    
    BEGIN
        IF p_version = 'PCIC' OR p_version = 'SEICI' OR p_version = 'PNBGEN' OR p_version = 'TPISC' OR p_version = 'RSIC' THEN
            FOR I IN (select distinct b.dist_no, c.policy_id pol_id, a.fnl_binder_id
						from giri_frps_ri a,
                             giri_distfrps b, 
                             giuw_pol_dist c, 
                             giri_binder d
 					   where a.fnl_binder_id = d.fnl_binder_id
   						 and a.line_cd = b.line_cd
   						 and a.frps_yy = b.frps_yy
    					 and a.frps_seq_no = b.frps_seq_no
   						 and b.dist_no = c.dist_no
   						 and d.line_cd = p_line_cd
   						 and d.binder_yy = p_binder_yy
   						 and d.binder_seq_no = p_binder_seq_no
   						 and reverse_sw ='N'
	        )LOOP
                v_policy_id := I.pol_id;    
                v_fnl_binder_id := I.fnl_binder_id; 
            END LOOP;
            
        ELSIF p_version = 'UAC' THEN
            FOR I IN (SELECT DISTINCT b.dist_no, c.policy_id pol_id 
                        FROM giri_frps_ri a,
                             giri_distfrps b, 
                             giuw_pol_dist c
                       WHERE a.line_cd = p_line_cd 
                         AND a.frps_yy = p_binder_yy 
                         AND a.frps_seq_no = p_binder_seq_no 
                         AND reverse_sw ='N'
	                     AND b.line_cd = a.line_cd 
                         AND b.frps_yy = a.frps_yy 
                         AND b.frps_seq_no = a.frps_seq_no 
                         AND c.dist_no = b.dist_no 
	        )LOOP
                v_policy_id := I.pol_id;         	
            END LOOP;
            
            IF v_policy_id IS NOT NULL THEN
                FOR I IN (SELECT fnl_binder_id 
                            FROM GIRI_FRPS_RI 
                           WHERE LINE_CD = p_line_cd 
                             AND FRPS_YY = p_binder_yy
                             AND FRPS_SEQ_NO = p_binder_seq_no 
                             AND REVERSE_SW = 'N'
                )LOOP
                    v_fnl_binder_id := I.fnl_binder_id;         	
                END LOOP;	
            END IF;
        
        ELSE -- added ELSE condition - Nica 05.28.2013
            FOR i IN (SELECT DISTINCT b.dist_no, c.policy_id pol_id, a.fnl_binder_id
						FROM GIRI_FRPS_RI a,
                             GIRI_DISTFRPS b, 
                             GIUW_POL_DIST c, 
                             GIRI_BINDER d
 					   WHERE a.fnl_binder_id = d.fnl_binder_id
   						 AND a.line_cd = b.line_cd
   						 AND a.frps_yy = b.frps_yy
    					 AND a.frps_seq_no = b.frps_seq_no
   						 AND b.dist_no = c.dist_no
   						 AND d.line_cd = p_line_cd
   						 AND d.binder_yy = p_binder_yy
   						 AND d.binder_seq_no = p_binder_seq_no
   						 AND reverse_sw ='N'
	        )LOOP
                v_policy_id := i.pol_id;    
                v_fnl_binder_id := i.fnl_binder_id; 
            END LOOP;
        END IF;
        
    END get_girir121_fnl_binder_id;
    
    
    /*
    * Referenced by GIRIS051 - Generate RI Reports (Outstanding tab)
    * Checks the oar_print_date of the records
    */
    FUNCTION check_oar_print_date(
        p_ri_cd         giri_inpolbas.RI_CD%TYPE,
        p_line_cd       gipi_polbasic.LINE_CD%TYPE,
        p_as_of_date    giri_inpolbas.OAR_PRINT_DATE%TYPE,
        p_more_than     NUMBER,
        p_less_than     NUMBER
    ) RETURN VARCHAR2
    AS
        v_print_chk VARCHAR2(1) := 'N';
        
    BEGIN
        FOR X IN (SELECT 1
                  FROM gipi_polbasic A,
                       giri_inpolbas E   
                 WHERE E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                   AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                   AND A.policy_id = E.policy_id  
                   AND A.pol_flag IN ('1', '2', '3')
                   AND e.ri_binder_no IS NULL
                   AND A.REG_POLICY_SW <> 'N' 
                   AND trunc(e.oar_print_date) = trunc(p_as_of_date)
                   AND (trunc(p_as_of_date) - trunc(e.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
                 UNION
                SELECT 1
                  FROM gipi_wpolbas A,
                       giri_winpolbas E   
                 WHERE E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                   AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                   AND e.ri_binder_no IS NULL
                   AND A.REG_POLICY_SW <> 'N' -- analyn 03.16.2010
                   AND A.par_id = E.par_id  
                   AND A.pol_flag IN ('1', '2', '3')
                   AND trunc(e.oar_print_date) = trunc(p_as_of_date)
                   AND (trunc(p_as_of_date) - trunc(e.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
                 UNION
                SELECT 1
                  FROM gipi_parlist A,
                       giri_winpolbas E   
                 WHERE E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                   AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                   AND e.ri_binder_no IS NULL
                   AND A.par_id = E.par_id  
                   AND trunc(e.oar_print_date) = trunc(p_as_of_date)
                   AND a.par_status = 2 -- analyn 03.23.2010
                   AND (trunc(p_as_of_date) - trunc(e.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
                   AND NOT EXISTS (SELECT c.par_id  --petermkaw 02232010
                                     FROM gipi_wpolbas c
                                    WHERE e.par_id = c.par_id)
                )
        LOOP
            v_print_chk := 'Y';
            EXIT;
        END LOOP;
        
        RETURN (v_print_chk);
        
    END check_oar_print_date;  
    
    /*
    *   Referenced by GIRIS051 - Generate RI Reports (Outstanding tab)
    *   Updates OAR_PRINT_DATE
    */
    PROCEDURE update_oar_print_date(
        p_ri_cd         NUMBER,
        p_line_cd       VARCHAR2,
        p_as_of_date    DATE,
        p_more_than     NUMBER,
        p_less_than     NUMBER,
        p_print_chk     VARCHAR2
    )
    AS
    BEGIN
        IF p_print_chk = 'Y' THEN
            /* updates the value of oar_print_date in giri_inpolbas */
            UPDATE giri_inpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no IS NULL
               AND (trunc(b.oar_print_date) = trunc(p_as_of_date)
                   OR (trunc(b.accept_date) <= trunc(p_as_of_date)
                       AND b.oar_print_date IS NULL))
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.par_id
                             FROM gipi_polbasic A   
                            WHERE A.line_cd = NVL(p_line_cd, A.line_cd )     
                              AND A.policy_id = b.policy_id  
                              AND A.pol_flag IN ('1', '2', '3')
                              AND A.REG_POLICY_SW <> 'N');
            
            /* updates the value of oar_print_date in giri_winpolbas
            ** where par_id already has basic information. */
            UPDATE giri_winpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd   = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no IS NULL
               AND (trunc(b.oar_print_date) = trunc(p_as_of_date)
                   OR (trunc(b.accept_date) <= trunc(p_as_of_date)
                       AND b.oar_print_date IS NULL))
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.par_id
                             FROM gipi_wpolbas A   
                            WHERE A.line_cd = NVL(p_line_cd, A.line_cd)     
                              AND A.par_id  = b.par_id  
                              AND A.pol_flag IN ('1', '2', '3')
                              AND A.REG_POLICY_SW <> 'N'); -- analyn 03.16.2010  
                                
            /* added to accomodate PAR's that doesn't have basic information yet
            ** (not in gipi_wpolbas) but already has an accept_no and a PAR in 
            ** the table gipi_parlist. --petermkaw 02232010 */ 
            UPDATE giri_winpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no IS NULL
               AND (trunc(b.oar_print_date) = trunc(p_as_of_date)
                   OR (trunc(b.accept_date) <= trunc(p_as_of_date) 
                      AND b.oar_print_date IS NULL))
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.par_id
                             FROM gipi_parlist A
                            WHERE A.line_cd = NVL(p_line_cd, A.line_cd)
                              AND b.par_id  = A.par_id
                              AND a.par_status = 2) -- analyn 03.23.2010
               AND NOT EXISTS (SELECT c.par_id  --petermkaw 02232010
                                 FROM gipi_wpolbas c
                                WHERE b.par_id = c.par_id);
                                
        ELSE
            /* updates the value of oar_print_date in giri_inpolbas */
            UPDATE giri_inpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no IS NULL
               AND trunc(b.accept_date) <= trunc(p_as_of_date)
               AND b.oar_print_date IS NULL
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.policy_id
                             FROM gipi_polbasic A
                            WHERE A.line_cd = NVL(p_line_cd, A.line_cd )     
                              AND A.policy_id = b.policy_id  
                              AND A.pol_flag IN ('1', '2', '3')
                              AND A.REG_POLICY_SW <> 'N');
                              
            /* updates the value of oar_print_date in giri_winpolbas
            ** where par_id already has basic information. */
            UPDATE giri_winpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no IS NULL
               AND trunc(b.accept_date) <= trunc(p_as_of_date)
               AND b.oar_print_date IS NULL
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.par_id
                             FROM gipi_wpolbas A  
                            WHERE A.line_cd = NVL(p_line_cd, A.line_cd )     
                              AND A.par_id = b.par_id  
                              AND A.pol_flag IN ('1', '2', '3')
                              AND A.REG_POLICY_SW <> 'N'); -- analyn 03.16.2010  
                                
            /* added to accomodate PAR's not in gipi_wpolbas but already has
            ** an accept_no and a PAR in the table gipi_parlist.
            ** --petermkaw 02232010
            */ 
            UPDATE giri_winpolbas b
               SET b.oar_print_date = trunc(p_as_of_date)
             WHERE b.ri_cd = NVL(p_ri_cd, b.ri_cd)
               AND b.ri_binder_no is null
               AND trunc(b.accept_date) <= trunc(p_as_of_date)
               AND b.oar_print_date IS NULL
               AND (trunc(p_as_of_date) - trunc(b.accept_date)) BETWEEN p_more_than and p_less_than --petermkaw 04162010
               AND EXISTS (SELECT a.par_id
                             FROM gipi_parlist A
                            WHERE a.line_cd = NVL(p_line_cd, A.line_cd)
                              AND b.par_id  = a.par_id
                              AND a.par_status = 2) -- analyn 03.23.2010
               AND NOT EXISTS (SELECT c.par_id  --petermkaw 02232010
                                 FROM gipi_wpolbas c
                                WHERE b.par_id = c.par_id);
        END IF;
        
    END update_oar_print_date;  
    
    /*
    *   Referenced by GIRIS051 (Expiry List tab)
    *   Validates the input RI_SNAME
    */
    PROCEDURE validate_ri_sname(
        p_ri_sname      GIIS_REINSURER.RI_SNAME%TYPE,
        v_ri_cd     OUT GIIS_REINSURER.RI_CD%TYPE,
        v_stat      OUT VARCHAR2,
        v_msg       OUT VARCHAR2
    )
    AS
    BEGIN
        v_stat := 'N';
        
        SELECT ri_cd
          INTO v_ri_cd
          FROM giis_reinsurer
         WHERE ri_sname = p_ri_sname;
        
        FOR A IN (SELECT '1'
                    FROM giis_reinsurer 
                   WHERE ri_cd = v_ri_cd)
        LOOP
            v_stat := 'Y';  -- to check if Reinsurer is accredited
        END LOOP;
        
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN
            v_ri_cd := NULL;
            v_msg := 'Reinsurer does not exist in maintenance table.';
       WHEN TOO_MANY_ROWS THEN
            v_ri_cd := NULL;
            v_msg := 'Too many records for this reinsurer found in maintenance table.';
    END validate_ri_sname;    
    
    
    /*
    *   Referenced by GIRIS051 - Expiry List tab
    *   Extracting data for printing of Assumed
    *   Returns GIXX_INW_TRAN_EXTRACT_ID_S.NEXTVAL 
    */
    PROCEDURE extract_inw_tran(
        p_line_cd           GIIS_LINE.LINE_CD%TYPE,
        p_ri_cd             GIIS_REINSURER.RI_CD%TYPE,
        p_expiry_month      VARCHAR2,
        p_expiry_year       NUMBER,
        p_accept_month      VARCHAR2,
        p_accept_year       NUMBER,
        p_user_id           GIXX_INW_TRAN.USER_ID%TYPE,
        v_extract_id    OUT gixx_inw_tran.extract_id%TYPE
    ) 
    AS
        exist_sw        VARCHAR2(1);
        v_expiry_date   gipi_polbasic.expiry_date%TYPE;
        v_accept_date   gixx_inw_tran.accept_date%TYPE;
        v_our_tsi       gipi_polbasic.tsi_amt%TYPE;
        v_orig_tsi      gipi_polbasic.tsi_amt%TYPE;
        v_ri_cd         giri_inpolbas.ri_cd%TYPE;
        v_assd_no       gipi_polbasic.assd_no%TYPE;
        v_ri_policy_no  giri_inpolbas.RI_POLICY_NO%type; --gixx_inw_tran.ri_policy_no%TYPE;
        v_policy_no     gixx_inw_tran.policy_no%TYPE;
        v_count         number(12);
    BEGIN    
        SELECT GIXX_INW_TRAN_EXTRACT_ID_S.NEXTVAL
          INTO v_extract_id
          FROM dual;  
          
        FOR C1 IN (SELECT a.line_cd, a.subline_cd, a.iss_cd, b.ri_cd,
                        a.issue_yy, a.pol_seq_no, a.renew_no
                        ,a.policy_id --test mikel SR5790 10.25.2016
                   FROM gipi_polbasic A, giri_inpolbas B
                  WHERE a.policy_id = b.policy_id
                    AND a.pol_flag IN ('1','2','3')
                    AND NVL(a.endt_seq_no,0) = 0
                    AND TO_CHAR(a.expiry_date,'FMMONTH-YYYY')= DECODE(p_expiry_month, NULL,TO_CHAR(a.expiry_date,'FMMONTH-YYYY'),UPPER(LTRIM(p_expiry_month))||'-'||ltrim(to_char(p_expiry_year)))
                    AND TO_CHAR(b.accept_date,'FMMONTH-YYYY')= DECODE(p_accept_month,NULL,TO_CHAR(b.accept_date,'FMMONTH-YYYY'),
                                                               UPPER(LTRIM(p_accept_month))||'-'||ltrim(to_char(p_accept_year)))
                    AND a.line_cd = nvl(p_line_cd,a.line_cd)
                    AND b.ri_cd = nvl(p_ri_cd,b.ri_cd))
             
        LOOP   
            exist_sw          := 'N';
            v_expiry_date     := NULL;
            v_accept_date     := NULL;
            v_our_tsi         := 0;
            v_orig_tsi        := 0;
            v_assd_no         := NULL;
            v_ri_cd           := NULL;
            v_ri_policy_no    := NULL;
            v_policy_no       := NULL;
                
            FOR C2 IN (SELECT expiry_date
                         FROM gipi_polbasic A
                        WHERE a.line_cd = C1.line_cd
                          AND a.subline_cd = c1.subline_cd
                          AND a.iss_cd = c1.iss_cd
                          AND a.issue_yy = c1.issue_yy
                          AND a.pol_seq_no = c1.pol_seq_no 
                          AND a.renew_no = c1.renew_no
                          AND a.pol_flag IN ('1','2','3')
                          AND a.eff_date = (SELECT MAX(b.eff_date)
                                              FROM gipi_polbasic B
                                             WHERE b.line_cd = C1.line_cd
                                               AND b.subline_cd = c1.subline_cd
                                               AND b.iss_cd = c1.iss_cd
                                               AND b.issue_yy = c1.issue_yy
                                               AND b.pol_seq_no = c1.pol_seq_no 
                                               AND b.renew_no = c1.renew_no
                                               AND b.pol_flag IN ('1','2','3'))
                        ORDER BY a.endt_seq_no DESC )
            LOOP
                v_expiry_date := c2.expiry_date; 
                exist_sw := 'Y';
                EXIT;
            END LOOP;
            
            IF exist_sw = 'Y' THEN
                v_policy_no := LTRIM(c1.line_cd)||'-'||LTRIM(c1.subline_cd)||'-'||LTRIM(c1.iss_cd)||'-'|| LTRIM(TO_CHAR(c1.issue_yy,'09'))||'-'||
                               LTRIM(TO_CHAR(c1.pol_seq_no,'099999999'))||'-'||
                               LTRIM(TO_CHAR(c1.renew_no,'09'));
                FOR C3 IN (SELECT policy_id,tsi_amt,assd_no
                             FROM gipi_polbasic A
                            WHERE a.line_cd = C1.line_cd
                             AND a.subline_cd = c1.subline_cd
                             AND a.iss_cd = c1.iss_cd
                             AND a.issue_yy = c1.issue_yy
                             AND a.pol_seq_no = c1.pol_seq_no 
                             AND a.renew_no = c1.renew_no
                             AND a.pol_flag IN ('1','2','3')
                           ORDER BY a.eff_date )
                LOOP
              
                    v_assd_no := NVL(c3.assd_no,v_assd_no);
                    v_our_tsi := v_our_tsi + NVL(c3.tsi_amt,0);
                      
                    FOR C4 IN (SELECT ri_policy_no, accept_date, ri_cd, orig_tsi_amt
                                 FROM giri_inpolbas
                                WHERE policy_id = c3.policy_id)
                    LOOP
                 
                        v_ri_policy_no := NVL(c4.ri_policy_no, v_ri_policy_no);
                        v_accept_date  := NVL(c4.accept_date, v_accept_date);
                        v_ri_cd        := NVL(c4.ri_cd, v_ri_cd);
                        v_orig_tsi     := v_orig_tsi + NVL(c4.orig_tsi_amt,0);                          
                    END LOOP;
               END LOOP;
               
               IF NVL(p_ri_cd , v_ri_cd) = v_ri_cd THEN                  
                  INSERT INTO gixx_inw_tran
                       VALUES (v_extract_id, 
                               v_ri_cd, 
                               v_policy_no, 
                               c1.line_cd,
                               v_ri_policy_no, 
                               v_assd_no, 
                               v_accept_date, 
                               v_expiry_date,
                               v_orig_tsi, 
                               v_our_tsi,
                               p_user_id,
                               c1.policy_id); --test mikel SR5790 10.25.2016 
                        
               END IF;
            END IF;
                    
        END LOOP;
        
    END extract_inw_tran;
    
    /*  Referenced by: GIRIS051 - Generate RI Reports (Reciprocity tab)   
    */
    PROCEDURE get_reciprocity_details1(
        p_user_id       IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_inward_param  OUT GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        v_outward_param OUT GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_from_date     OUT GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        v_to_date       OUT GIRI_FAC_RECIPROCITY.TO_DATE%TYPE
    )
    AS
    BEGIN
        SELECT DISTINCT a.inward_param, a.outward_param, a.from_date, a.to_date
          INTO v_inward_param, v_outward_param, v_from_date, v_to_date
          FROM giri_fac_reciprocity a
         WHERE a.USER_ID = p_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            NULL;    
    END get_reciprocity_details1;
    
    /*  Referenced by: GIRIS051 - Generate RI Reports (Reciprocity tab)   
    */
    PROCEDURE get_reciprocity_details2(
        p_user_id   IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_ri_cd     OUT GIRI_FAC_RECIPROCITY.RI_CD%TYPE,
        v_ri_sname  OUT GIIS_REINSURER.RI_SNAME%TYPE
    )
    AS
    BEGIN
        SELECT DISTINCT a.ri_cd, b.ri_sname
          INTO v_ri_cd, v_ri_sname
          FROM giri_fac_reciprocity a, giis_reinsurer b
         WHERE a.ri_cd = b.ri_cd
           AND a.USER_ID = p_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            NULL;
    END get_reciprocity_details2;
    
    /* Referenced By:   GIRIS051 - Reciprocity tab
     * Retrieves initial values 
    */
    PROCEDURE get_reciprocity_initial_values(
        p_user_id       IN  GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_inward_param  OUT GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        v_outward_param OUT GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_from_date     OUT GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        v_to_date       OUT GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        v_ri_cd         OUT GIRI_FAC_RECIPROCITY.RI_CD%TYPE,
        v_ri_sname      OUT GIIS_REINSURER.RI_SNAME%TYPE
    )
    AS
    BEGIN
        BEGIN
            SELECT DISTINCT a.inward_param, a.outward_param, a.from_date, a.to_date
              INTO v_inward_param, v_outward_param, v_from_date, v_to_date
              FROM giri_fac_reciprocity a
             WHERE a.USER_ID = p_user_id;
        EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                v_inward_param  := NULL;
                v_outward_param := NULL;
                v_from_date     := NULL;
                v_to_date       := NULL;    
        END;
        
        BEGIN
            SELECT DISTINCT a.ri_cd, b.ri_sname
              INTO v_ri_cd, v_ri_sname
              FROM giri_fac_reciprocity a, giis_reinsurer b
             WHERE a.ri_cd = b.ri_cd
               AND a.USER_ID = p_user_id;
        EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                v_ri_sname  := NULL;
                v_ri_cd     := NULL;
        END;
    END get_reciprocity_initial_values;
    
    
    /*  Referenced by: GIRIS051 - Generate RI Reports (Reciprocity tab)
    *   Retrieves RI_CD from GIRI_FAC_RECIPROCITY table
    */
    FUNCTION get_reciprocity_ri_cd(
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE
    ) RETURN NUMBER
    IS
        v_inward_param         giri_fac_reciprocity.inward_param%type;
        v_outward_param        giri_fac_reciprocity.outward_param%type;
        v_from_date            giri_fac_reciprocity.from_date%type;
        v_to_date              giri_fac_reciprocity.to_date%type;
        v_ri_cd				   giri_fac_reciprocity.ri_cd%type;
    BEGIN         
        SELECT DISTINCT inward_param,outward_param,from_date, to_date
          INTO v_inward_param, v_outward_param, v_from_date, v_to_date
          FROM giri_fac_reciprocity	
         WHERE USER_ID       =  p_user_id
           AND from_date     =  p_from_date
           AND to_date       =  p_to_date
           AND inward_param  =  p_inward_param
           AND outward_param =  p_outward_param;
            
        IF v_inward_param IS NOT NULL THEN
	        BEGIN
		        SELECT DISTINCT ri_cd
  		          INTO v_ri_cd
	  	          FROM giri_fac_reciprocity
                 WHERE USER_ID = p_user_id;
            EXCEPTION
                WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                    v_ri_cd := 0;
            END;
        END IF;
        
        RETURN(v_ri_cd);
    END get_reciprocity_ri_cd;
    
    
    /*  Referenced by GIRIS051 - Reciprocity tab
    *   Counts reciprocity records 
    */
    PROCEDURE extract_reciprocity(
        p_ri_cd             GIRI_BINDER.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        v_count1        OUT NUMBER,
        v_count2        OUT NUMBER
    )
    AS
    BEGIN
	    SELECT count(*)
          INTO v_count1
          FROM giri_binder a, gipi_polbasic b
         WHERE a.policy_id = b.policy_id
         	 AND ri_cd = NVL(p_ri_cd,ri_cd)
             AND (--a.binder_date
                 trunc(DECODE(p_outward_param,'INCEPTIONDATE',B.incept_date,
                                              'BINDERDATE', A.binder_date,
                                              A.acc_ent_date)
                       ) between p_from_date and p_to_date
                  OR
				 --cond2
				 TRUNC(DECODE(p_outward_param,'ACCTENTDATE', DECODE(A.acc_rev_date,NULL,
                                                                    p_from_date + 1,
                                                                    A.acc_rev_date),
                                              p_from_date + 1)
					   ) between p_from_date and p_to_date
				 );
                                
        IF v_count1 = 0 THEN      
           SELECT count(*)
             INTO v_count2
             FROM giri_inpolbas d055, gipi_polbasic b245
            WHERE d055.policy_id = b245.policy_id
              AND d055.ri_cd     = NVL(p_ri_cd,d055.ri_cd)
              AND (
   				   (--cond.1
   	         		TRUNC(DECODE(p_inward_param,'EFFECTIVITYDATE',b245.EFF_DATE,
                                                'ACCEPTDATE', d055.ACCEPT_DATE,
								                'ACCTENTDATE',b245.ACCT_ENT_DATE,
                                                'ISSUEDATE',b245.ISSUE_DATE,
								                last_day(TO_DATE(b245.BOOKING_MTH||'01'||TO_CHAR(b245.BOOKING_YEAR),'FMMONTHDDYYYY'))
						        )
						  ) >= p_from_date  
					AND
					TRUNC(DECODE(p_inward_param,'EFFECTIVITYDATE',b245.EFF_DATE,
                                                'ACCEPTDATE',d055.ACCEPT_DATE,
								                'ACCTENTDATE',b245.ACCT_ENT_DATE,'ISSUEDATE',b245.ISSUE_DATE,
								                (TO_DATE(b245.BOOKING_MTH||'01'||TO_CHAR(b245.BOOKING_YEAR),'FMMONTHDDYYYY'))
								)
						  ) <= p_to_date  

					 )
					OR
                    ( --cond.2
                    DECODE(p_inward_param,'ACCTENTDATE',trunc(b245.spld_acct_ent_date),
                                           p_from_date -1 )
                         between p_from_date and p_to_date							   
                    )
				  );
        END IF;
    
    END extract_reciprocity;
    
    FUNCTION get_extracted_reciprocity(
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE
    ) RETURN NUMBER
    IS
        v_inward_param         giri_fac_reciprocity.inward_param%type;
        v_outward_param        giri_fac_reciprocity.outward_param%type;
        v_from_date            giri_fac_reciprocity.from_date%type;
        v_to_date              giri_fac_reciprocity.to_date%type;
    BEGIN         
        SELECT DISTINCT inward_param,outward_param,from_date, to_date
          INTO v_inward_param, v_outward_param, v_from_date, v_to_date
          FROM giri_fac_reciprocity	
         WHERE USER_ID       =  p_user_id
           AND from_date     =  p_from_date
           AND to_date       =  p_to_date
           AND inward_param  =  p_inward_param
           AND outward_param =  p_outward_param; 
            
        RETURN(1);
    EXCEPTION
        WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
             RETURN(0);
            
    END get_extracted_reciprocity;
    
    /*  Referenced by GIRIS051 (Reciprocity tab)
    *   Updates GIRI_FAC_RECIPROCITY
    */
    PROCEDURE update_aprem(
        p_ri_cd             GIRI_INPOLBAS.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_local_curr        VARCHAR2,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE,
        v_msg           OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM giri_fac_reciprocity;
        
        FOR C IN (SELECT A.line_cd, 
                         SUM(DECODE(p_inward_param,'ACCTENTDATE', DECODE(SIGN(to_number(to_char(a.acct_ent_date,'YYYYMMDD'))-to_number(TO_CHAR(p_from_date, 'YYYYMMDD'))), -1, 0
                                                                                ,DECODE(SIGN(to_number(to_char(a.acct_ent_date,'YYYYMMDD'))-to_number(TO_CHAR(p_to_date, 'YYYYMMDD'))),1, 0
                                                                                                        ,DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY', C.prem_amt*c.currency_rt, c.prem_amt))
                                                                        ),										
                                                 DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY',C.prem_amt*c.currency_rt, c.prem_amt)
                                   )						
                             ) aprem_amt,
                         SUM(DECODE(p_inward_param,'ACCTENTDATE',DECODE(SIGN(to_number(to_char(nvl(a.spld_acct_ent_date,p_to_date-1),'YYYYMMDD'))-to_number(TO_CHAR(p_from_date, 'YYYYMMDD'))),-1, 0
                                                                                    ,DECODE(SIGN(to_number(to_char(nvl(a.spld_acct_ent_date,p_to_date+1),'YYYYMMDD'))-to_number(TO_CHAR(p_to_date, 'YYYYMMDD'))),1, 0
                                                                                                        ,-1*DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY',(C.prem_amt*c.currency_rt),C.prem_amt))
                                                                       )
										
                                                 ,0
                                   )						
                            ) aprem_negamt,
	   				     C.currency_cd, b.ri_cd, to_number(to_char(a.acct_ent_date,'YY')) tran_yy, to_number(to_char(a.acct_ent_date,'MM')) tran_mm
	           
	                FROM gipi_polbasic A, giri_inpolbas B, gipi_invoice C
	               WHERE A.policy_id = B.policy_id
	                 AND A.policy_id   = C.policy_id
	                 AND B.ri_cd       = NVL(p_ri_cd,B.ri_cd)             
	                 AND A.iss_cd      = giisp.v('ISS_CD_RI')
					 AND a.acct_ent_date IS NOT NULL
                     AND (DECODE(p_inward_param,'ACCTENTDATE',1,2)=1 OR A.POL_FLAG IN ('1','2','3'))
                     AND ( (--cond.1
                           TRUNC(DECODE(p_inward_param,'EFFECTIVITYDATE',A.EFF_DATE,
                                                       'ACCEPTDATE',B.ACCEPT_DATE,
                                                       'ACCTENTDATE',A.ACCT_ENT_DATE,
                                                       'ISSUEDATE',A.ISSUE_DATE,
                                                       last_day(TO_DATE(A.BOOKING_MTH||'01'||TO_CHAR(A.BOOKING_YEAR),'FMMONTHDDYYYY'))
                                        )
                                 ) >= p_from_date  
							AND
							TRUNC(DECODE(p_inward_param,'EFFECTIVITYDATE',A.EFF_DATE,
                                                        'ACCEPTDATE',B.ACCEPT_DATE,
                                                        'ACCTENTDATE',A.ACCT_ENT_DATE,
                                                        'ISSUEDATE',A.ISSUE_DATE,
                                                        (TO_DATE(A.BOOKING_MTH||'01'||TO_CHAR(A.BOOKING_YEAR),'FMMONTHDDYYYY'))
										 )
								 ) <= p_to_date  
						   )
				         OR
						   ( --cond.2
						   DECODE(p_inward_param,'ACCTENTDATE',trunc(A.spld_acct_ent_date),p_from_date -1 )
											between p_from_date and p_to_date							   
						   )
						 )
							      
                   GROUP BY B.RI_CD,A.LINE_CD, C.CURRENCY_CD, to_number(to_char(a.acct_ent_date,'YY')), to_number(to_char(a.acct_ent_date,'MM')) ) 
        LOOP
            C.aprem_amt := C.aprem_amt + C.aprem_negamt;
            
            INSERT INTO giri_fac_reciprocity 
                        (from_date, to_date, 
                         line_cd,   ri_cd, 
                         aprem_amt, tran_yy,
                         tran_mm,   currency_cd, 
                         user_id,   last_update,
                         inward_param, outward_param) 
                 VALUES (p_from_date, p_to_date, 
                         c.line_cd, C.ri_cd, 
                         c.aprem_amt, c.tran_yy, 
                         c.tran_mm, c.currency_cd, 
                         p_user_id, SYSDATE, 
                         p_inward_param, p_outward_param);
                         
            v_msg := 'Y';
        END LOOP;        
       
    END update_aprem;
    
    
    PROCEDURE update_cprem(
        p_ri_cd             GIRI_INPOLBAS.RI_CD%TYPE,
        p_from_date         GIRI_FAC_RECIPROCITY.FROM_DATE%TYPE,
        p_to_date           GIRI_FAC_RECIPROCITY.TO_DATE%TYPE,
        p_inward_param      GIRI_FAC_RECIPROCITY.INWARD_PARAM%TYPE,
        p_outward_param     GIRI_FAC_RECIPROCITY.OUTWARD_PARAM%TYPE,
        p_local_curr        VARCHAR2,
        p_user_id           GIRI_FAC_RECIPROCITY.USER_ID%TYPE        
    )
    AS
        v_exist VARCHAR2(1) := 'N';
    BEGIN
        FOR c IN (SELECT A.line_cd, A.ri_cd,
                         SUM(DECODE(p_outward_param,'ACCTENTDATE',DECODE(SIGN(to_number(to_char(nvl(a.acc_ent_date,p_from_date-1),'YYYYMMDD'))-to_number(TO_CHAR(p_from_date, 'YYYYMMDD'))),-1, 0
                                                                                ,DECODE(SIGN(to_number(to_char(a.acc_ent_date,'YYYYMMDD'))-to_number(TO_CHAR(p_to_date, 'YYYYMMDD'))),1,0
                                                                                                        ,DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY', A.ri_prem_amt*C.currency_rt, a.ri_prem_amt) )
									                                    )									
											        ,DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY', A.ri_prem_amt*C.currency_rt, a.ri_prem_amt)) 
                             ) cprem_amt,	
					     SUM(DECODE(p_outward_param,'ACCTENTDATE',DECODE(SIGN(to_number(to_char(nvl(a.acc_rev_date,p_from_date-1),'YYYYMMDD'))-to_number(TO_CHAR(p_from_date, 'YYYYMMDD'))),-1,0
                                                                                ,DECODE(SIGN(to_number(to_char(a.acc_rev_date,'YYYYMMDD'))-to_number(TO_CHAR(p_to_date, 'YYYYMMDD'))),1,0
                                                                                                    ,-1*DECODE(UPPER(p_local_curr), 'LOCAL CURRENCY', (A.ri_prem_amt*c.currency_rt), A.ri_prem_amt))
									                                    )									
											        ,0
                                    )				
                             ) cprem_negamt,
						  C.currency_cd, to_number(to_char(d.acct_ent_date,'YY')) tran_yy, to_number(to_char(d.acct_ent_date,'MM')) tran_mm					    
          	        FROM giri_binder A , giri_frps_ri B, giri_distfrps C, gipi_polbasic D, giuw_pol_dist e -- aaron 052909 added giuw_pol_dist prf 2904
     		       WHERE A.ri_cd       = NVL(p_ri_cd, A.ri_cd)
       		         AND A.fnl_binder_id = B.fnl_binder_id
       		         AND e.policy_id = d.policy_id -- aaron 052909
       		         AND e.dist_no = c.dist_no  -- aaron 052909
                     AND B.line_cd       = C.line_cd
                     AND B.frps_yy       = C.frps_yy             
                     AND B.frps_seq_no   = C.frps_seq_no     
                     AND d.acct_ent_date IS NOT NULL
                     AND (DECODE(p_outward_param,'ACCTENTDATE',1,2)=1 OR A.reverse_date is null)  
                     AND (DECODE(p_outward_param,'ACCTENTDATE',1,2)=1 OR C.ri_flag <> 4)
                     AND (trunc(DECODE(p_outward_param,'INCEPTIONDATE',D.incept_date,'BINDERDATE',A.binder_date,A.acc_ent_date)
                                ) between p_from_date and p_to_date
                          OR
						  TRUNC(DECODE(p_outward_param,'ACCTENTDATE',DECODE(A.acc_rev_date,NULL,p_from_date - 1,
                                                                                                 A.acc_rev_date),
                                                             p_from_date - 1
                                      )
							    ) between p_from_date and p_to_date

                         )                   
      		   GROUP BY A.ri_cd, A.line_cd, C.currency_cd, to_number(to_char(d.acct_ent_date,'YY')), to_number(to_char(d.acct_ent_date,'MM')))
        LOOP  
            C.cprem_amt := C.cprem_amt + C.cprem_negamt;
            
            FOR A IN (SELECT from_date, to_date, ri_cd, line_cd
                        FROM giri_fac_reciprocity
                       WHERE from_date     = p_from_date
                         AND to_date       = p_to_date
                         AND ri_cd         = c.ri_cd
                         AND line_cd       = c.line_cd
                         AND currency_cd   = c.currency_cd)
            LOOP   
        	    v_exist := 'Y';
				 
                UPDATE giri_fac_reciprocity
                   SET cprem_amt     = c.cprem_amt,
                       currency_cd   = c.currency_cd,
                       user_id       = p_user_id,
                       last_update   = SYSDATE
                   WHERE from_date   = a.from_date
                     AND to_date     = a.to_date
                     AND ri_cd       = a.ri_cd
                     AND line_cd     = c.line_cd
                     AND currency_cd = c.currency_cd;
            END LOOP;
            
            IF v_exist = 'N' THEN
                INSERT INTO giri_fac_reciprocity 
                            (from_date, to_date, 
                             line_cd,   ri_cd,
                             cprem_amt, currency_cd, 
                             user_id,   last_update,
                             inward_param, outward_param,
                             tran_mm, tran_yy) 
                     VALUES (p_from_date, p_to_date, 
                             c.line_cd, c.ri_cd,
                             c.cprem_amt, c.currency_cd, 
                             p_user_id, SYSDATE, 
                             p_inward_param, p_outward_param,
                             c.tran_mm, c.tran_yy);
            END IF;
        END LOOP;
          
    END update_cprem;
    
    
END GIRI_RIREPORTS_PKG;
/
CREATE OR REPLACE PACKAGE BODY CPI.GIACS512_PKG
AS

    FUNCTION get_last_cutoff_date(
        p_extract_year      VARCHAR2
    ) RETURN VARCHAR2
    IS
        v_cut_off_date      VARCHAR2(10);
    BEGIN
        SELECT DISTINCT TO_CHAR(LAST_DAY('12-DEC-' || p_extract_year), 'mm-dd-yyyy')
	  	  INTO v_cut_off_date
	  	  FROM giac_cpc_dtl;
                  
        RETURN (v_cut_off_date);
        
    END get_last_cutoff_date;
    
    
    FUNCTION validate_before_extract(
        p_extract_year      giac_cpc_dtl.tran_year%TYPE,
        p_intm_no           giis_intermediary.intm_no%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_type              VARCHAR2
    ) RETURN VARCHAR2
    IS
        v_check     VARCHAR2(1) := 'N';
    BEGIN
    
        IF p_type = 'chkPremComm' THEN
        
            FOR A IN (SELECT DISTINCT ('X')
                        FROM giac_cpc_dtl
                       WHERE tran_year  = p_extract_year
                         AND intm_no    = NVL(p_intm_no, intm_no)
                         AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
        
        ELSIF p_type = 'chkOsLoss' THEN
            
            FOR A IN (SELECT DISTINCT ('X')
                        FROM giac_cpc_os_dtl
                       WHERE tran_year  = p_extract_year
                         AND intm_no    = NVL(p_intm_no, intm_no)
                         AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
        
        
        ELSIF p_type = 'chkLossPaid' THEN
        
            FOR A IN (SELECT DISTINCT ('X')
                        FROM giac_cpc_clm_paid_dtl
                       WHERE tran_year  = p_extract_year
                         AND intm_no    = NVL(p_intm_no, intm_no)
                         AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
        
        END IF;        
        
        RETURN (v_check);
        
    END validate_before_extract;
    
    FUNCTION validate_before_print(
        p_extract_year      giac_cpc_dtl.tran_year%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_type              VARCHAR2
    ) RETURN VARCHAR2
    IS
        v_check     VARCHAR2(1) := 'N';
    BEGIN
        
        IF p_type = 'chkPremCommRep' THEN
        
            FOR A IN (SELECT 1
   		                FROM giac_cpc_dtl
     		           WHERE tran_year  = p_extract_year
     		             AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
            
        ELSIF p_type = 'chkOsLossRep' THEN
        
            FOR A IN (SELECT 1
   		                FROM giac_cpc_os_dtl
     		           WHERE tran_year  = p_extract_year
     		             AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
        
        ELSIF p_type = 'chkLossPaidRep' THEN
        
            FOR A IN (SELECT 1
   		                FROM giac_cpc_clm_paid_dtl
     		           WHERE tran_year  = p_extract_year
     		             AND user_id    = p_user_id)
            LOOP
                v_check := 'Y';
                EXIT;
            END LOOP;
            
        END IF;
        
        RETURN (v_check);
        
    END validate_before_print;
    
    
    
    -- Procedure for extracting Prem Comm
    PROCEDURE CPC_EXTRACT_PREM_COMM(
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%TYPE,
		p_cut_off_date      IN  VARCHAR2,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    ) IS 
        v_exist          	  VARCHAR2(1)   := 'N';
        rec_counter           NUMBER        := 0;
        v_year                NUMBER;
        v_intm_no             GIIS_INTERMEDIARY.INTM_NO%TYPE;
        v_cut_off_date        DATE;
    BEGIN
        -- extract based on Premium Payment with Commission
        v_year          := p_extract_year;
        v_intm_no       := p_intm_no;
        v_cut_off_date  := TO_DATE(p_cut_off_date, 'mm-dd-yyyy');
        
        --message('Extracting claim records based on Paid Premium with Commission.',no_acknowledge);
        --MSG_ALERT('Extracting claim records based on Paid Premium with Commission.','I',FALSE);
        
        extract_cpc_detail_pcic(v_year, v_intm_no, v_cut_off_date, p_user_id); --benjo 01.11.2016 MAC-SR-21280 added p_user_id
        
        FOR rec IN (SELECT policy_id
                     FROM giac_cpc_dtl
                    WHERE 1 = 1
                      AND tran_year = p_extract_year
                      AND intm_no   = NVL(p_intm_no, intm_no) --p_intm_no
                      AND user_id   = p_user_id)
        LOOP              
            rec_counter := rec_counter + 1;
        END LOOP;
        
        p_rec_count := rec_counter;
        --clear_message;
        --message('Processed ('||TO_CHAR(rec_counter) ||') claim record/s.', NO_ACKNOWLEDGE);
        --GO_ITEM('cg$ctrl.print_button');
    END CPC_EXTRACT_PREM_COMM;
    
    
    PROCEDURE CPC_EXTRACT_OS_DTL (
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    ) IS 
        v_exist          	  VARCHAR2(1)   := 'N';
        rec_counter           NUMBER        := 0;
        v_year                NUMBER;
        v_intm_no			  giis_intermediary.intm_no%type;
    BEGIN
        -- extract based on Outstanding Loss
        v_year      := p_extract_year;
        v_intm_no   := p_intm_no;
        
        --message('Extracting claim records based on Outstanding Loss.',no_acknowledge);
        --MSG_ALERT('Extracting claim records based on Outstanding Loss.','I',FALSE);
        
        extract_cpc_os_pcic(v_year, v_intm_no, p_user_id); --p_user_id Added by Jerome Bautista 05.12.2016 SR 22335
        
        FOR rec IN(SELECT claim_id
                   FROM giac_cpc_os_dtl
                  WHERE 1 = 1
                    AND tran_year   = p_extract_year
                    AND intm_no     = NVL(p_intm_no, intm_no) --p_intm_no
                    AND user_id     = p_user_id)
        LOOP
            rec_counter := rec_counter + 1;
        END LOOP;
        
        p_rec_count := rec_counter;
        --clear_message;
        --message('Processed ('||TO_CHAR(rec_counter) ||') claim record/s.', NO_ACKNOWLEDGE);
        --GO_ITEM('cg$ctrl.print_button');
    END CPC_EXTRACT_OS_DTL;
    
    
    PROCEDURE CPC_EXTRACT_LOSS_PAID (
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%type,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    ) IS 
	    v_exist          	VARCHAR2(1) := 'N';
	    rec_counter         NUMBER      := 0;
	    v_year              NUMBER;
	    v_intm_no         	giis_intermediary.intm_no%type;
    BEGIN
        -- extract based on Losses Paid
        v_year := p_extract_year;
        v_intm_no := p_intm_no;
        
        --message('Extracting claim records based on Losses Paid.',no_acknowledge);
        --MSG_ALERT('Extracting claim records based on Losses Paid.','I',FALSE);
      
        extract_cpc_clm_paid_pcic(v_year, v_intm_no, p_user_id); --p_user_id Added by Jerome Bautista 05.12.2016 SR 22335
      
        FOR rec IN(SELECT claim_id
                     FROM giac_cpc_clm_paid_dtl
                    WHERE 1 = 1 
                      AND tran_year = p_extract_year
                      AND intm_no   = NVL(p_intm_no, intm_no) --p_intm_no
                      AND user_id   = p_user_id)
        LOOP
            rec_counter := rec_counter + 1;
        END LOOP;
        
        p_rec_count := rec_counter;
        --clear_message;
        --message('Processed ('||TO_CHAR(rec_counter) ||') claim record/s.', NO_ACKNOWLEDGE);
        --GO_ITEM('cg$ctrl.print_button');
    END CPC_EXTRACT_LOSS_PAID;

    
    
END GIACS512_PKG;
/



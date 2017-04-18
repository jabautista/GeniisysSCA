CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_CARGO_GICLR265
AS
/*created by carlo de guzman
 *date 03.08.2016
 */
   FUNCTION csv_giclr265 (
      p_as_of_date       VARCHAR2,
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_type       giis_cargo_type.cargo_type%TYPE,
      p_as_of_ldate      VARCHAR2,
      p_from_date        VARCHAR2,
      p_from_ldate       VARCHAR2,
      p_to_date          VARCHAR2,
      p_to_ldate         VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN populate_report_tab PIPELINED
   IS
      ntt               populate_report_type;
      v_dateFormat      VARCHAR2(200);
      v_p_as_of_date    DATE;
      v_p_as_of_ldate   DATE;
      v_currDate        DATE;
      v_date_type       VARCHAR (200);
      v_system_date     VARCHAR(100);
      v_system_time     VARCHAR(100);
   BEGIN
   
      BEGIN
      
        SELECT SYSDATE
          INTO v_currDate
          FROM DUAL;
        
        IF(p_as_of_date IS NOT NULL) THEN
            v_date_type := 'Claim File Date As of ' || to_char(TO_DATE(p_as_of_date, 'dd-MON-YY'),'fmMonth DD, YYYY');
        ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
              v_date_type := 'Claim File Date From '||to_char(TO_DATE(p_from_date, 'dd-MON-YY'),'fmMonth DD, YYYY')||' To '||to_char(TO_DATE(p_to_date, 'dd-MON-YY'),'fmMonth DD, YYYY');
        ELSIF p_as_of_ldate IS NOT NULL THEN
              v_date_type := 'Loss Date As of '||to_char(TO_DATE(p_as_of_ldate, 'dd-MON-YY'),'fmMonth DD, YYYY');
        ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
            v_date_type := 'Loss Date From '||to_char(TO_DATE(p_from_ldate, 'dd-MON-YY'),'fmMonth DD, YYYY')||' To '||to_char(TO_DATE(p_to_ldate, 'dd-MON-YY'),'fmMonth DD, YYYY');
        ELSIF p_as_of_date IS NULL AND p_from_date IS NULL AND p_to_date IS NULL THEN
            v_date_type := ' ';
            v_p_as_of_date := v_currDate;
        ELSIF p_as_of_ldate IS NULL AND p_from_ldate IS NULL AND p_to_ldate IS NULL THEN
            v_date_type := ' ';
            v_p_as_of_ldate := v_currDate;
        END IF;
        
        SELECT GET_REP_DATE_FORMAT
          INTO v_dateFormat
          FROM DUAL;
          
       v_system_date := TO_CHAR(v_currDate, v_dateFormat);
       v_system_time := TO_CHAR(v_currDate, 'HH12:MI:SS AM');
        
      END;
      
     
      
      BEGIN
         FOR x IN (SELECT    a.cargo_class_cd|| ' - '|| a.cargo_class_desc cargo_class,
                          b.cargo_type || ' - '|| b.cargo_type_desc cargo_type,
                          c.item_no, c.claim_id,
                          c.item_no || '-' || c.item_title itemnoitemtitle,
                          d.line_cd|| '-'|| d.subline_cd
                          || '-'|| d.iss_cd|| '-'
                          || LTRIM (TO_CHAR (d.clm_yy, '09'))
                          || '-'|| LTRIM (TO_CHAR (d.clm_seq_no, '0000009')) claim_number,
                          d.line_cd|| '-'|| d.subline_cd|| '-'|| d.pol_iss_cd
                          || '-'|| LTRIM (TO_CHAR (d.issue_yy, '09'))
                          || '-'|| LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                          || '-'|| LTRIM (TO_CHAR (d.renew_no, '09')) policy_number,
                          d.assured_name
                     FROM giis_cargo_class a, giis_cargo_type b, gicl_cargo_dtl c, gicl_claims d
                    WHERE a.cargo_class_cd = b.cargo_class_cd
                      AND b.cargo_class_cd = c.cargo_class_cd
                      AND b.cargo_type = c.cargo_type
                      AND c.claim_id = d.claim_id
                      AND check_user_per_line2 (line_cd, iss_cd, 'GICLS265', p_user_id) = 1
                      AND b.cargo_class_cd = SUBSTR (p_cargo_class_cd, 0, 40)
                      AND b.cargo_type = SUBSTR (p_cargo_type, 0, 40)
                      AND (( TRUNC (d.clm_file_date) >= TO_DATE (SUBSTR (p_from_date, 0, 40), 'DD-MON-YY')
                               AND TRUNC (d.clm_file_date) <= TO_DATE (SUBSTR (p_to_date, 0, 40),'DD-MON-YY')
                                OR TRUNC (d.clm_file_date) <= TO_DATE (SUBSTR (p_as_of_date, 0, 40),'DD-MON-YY')
                                OR (TRUNC (d.loss_date) >= TO_DATE (SUBSTR (p_from_ldate, 0,40),'DD-MON-YY')
                                      AND TRUNC (d.loss_date) <= TO_DATE (SUBSTR (p_to_ldate, 0, 40), 'DD-MON-YY')
                                       OR TRUNC (d.loss_date) <= TO_DATE (SUBSTR (p_as_of_ldate, 0, 40), 'DD-MON-YY')
                                   )
                           )))
         LOOP
            ntt.cargo_class         := x.cargo_class;
            ntt.cargo_type          := x.cargo_type;
           -- ntt.item_no             := x.item_no;
           -- ntt.claim_id            := x.claim_id;
            ntt.item_number_item_title  := x.itemnoitemtitle;
            ntt.claim_number        := x.claim_number;
            ntt.policy_number       := x.policy_number;
            ntt.assured      := x.assured_name;
            
            BEGIN
            FOR i IN(SELECT lossres, losspaid, expres, exppaid
            FROM TABLE(CSV_CLM_PER_CARGO_GICLR265.populate_giclr265items(x.claim_id)))
            
            LOOP
            ntt.loss_reserve := i.lossres;
            ntt.losses_paid := i.losspaid;
            ntt.expense_reserve := i.expres;
            ntt.expenses_paid := i.exppaid;           
            
            END LOOP;
            
            END;
            
            
            
            PIPE ROW (ntt);
         END LOOP;
      END;
   END;

   FUNCTION populate_giclr265items (
        p_claim_id      gicl_cargo_dtl.claim_id%TYPE
   
   )
   
   RETURN populate_report_items_tab PIPELINED
   IS
        ntt      populate_report_items_type;
   BEGIN
   
    BEGIN
        
        SELECT NVL(SUM(a.loss_reserve),0) 
          INTO ntt.lossres
          FROM gicl_clm_reserve a,gicl_cargo_dtl b
         WHERE b.item_no= a.item_no
           AND a.claim_id= p_claim_id
           AND a.claim_id= b.claim_id;
           
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       ntt.lossres := 0;
    END;
    
    BEGIN
        SELECT nvl(sum(a.losses_paid),0)
          INTO ntt.losspaid
          FROM gicl_clm_reserve a,gicl_cargo_dtl b
         WHERE b.item_no= a.item_no
           AND a.claim_id= p_claim_id
           AND a.claim_id= b.claim_id;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       ntt.losspaid := 0;
    END;
    
    BEGIN
        
        SELECT NVL(SUM(a.expense_reserve),0)
          INTO ntt.expres
          FROM gicl_clm_reserve a,gicl_cargo_dtl b
         WHERE b.item_no= a.item_no
           AND a.claim_id= p_claim_id
           AND a.claim_id= b.claim_id;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       ntt.expres := 0;
       
    END;
    
    BEGIN
        SELECT NVL(sum(a.expenses_paid),0)  
          INTO ntt.exppaid
          FROM gicl_clm_reserve a,gicl_cargo_dtl b
         WHERE b.item_no= a.item_no
           AND a.claim_id= b.claim_id
           AND a.claim_id= p_claim_id;
    
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        ntt.exppaid := 0;
    END;
    
    PIPE ROW(ntt);
   END;
END;
/

CREATE OR REPLACE PACKAGE BODY CPI.pkg_check_digit
IS   
   FUNCTION get_acct_iss_cd(p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE )  
   RETURN GIIS_ISSOURCE.acct_iss_cd%TYPE
   IS
     v_output   GIIS_ISSOURCE.acct_iss_cd%TYPE;
   BEGIN
     SELECT acct_iss_cd
       INTO v_output 
       FROM GIIS_ISSOURCE
     WHERE  iss_cd = p_iss_cd;
     RETURN v_output;
   EXCEPTION       
     WHEN OTHERS  
     THEN       
         RAISE_APPLICATION_ERROR(-20010, SQLERRM  || ':' || SQLCODE || CHR(10) ||  'get_acct_iss_cd: ' || p_iss_cd );
   END;   
   FUNCTION get_due_date(p_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE)
   RETURN   VARCHAR2    
   IS
   BEGIN
     SELECT TO_CHAR(due_date, v_tochar_due)
       INTO v_due_date
       FROM GIPI_INVOICE
      WHERE iss_cd      = REGEXP_SUBSTR(v_bill_num,v_substr_acct) 
        AND prem_seq_no = REGEXP_SUBSTR(v_bill_num, v_substr_prem )   ;
     RETURN v_due_date;
   EXCEPTION       
     WHEN OTHERS  
     THEN  
         RETURN NULL;     
         --RAISE_APPLICATION_ERROR(-20010, SQLERRM  || ':' || SQLCODE || CHR(10) ||  'get_due_date: ' || p_prem_seq_no );   
   END; 
   FUNCTION BUILD(p_bill_num VARCHAR2 DEFAULT NULL) 
   RETURN   VARCHAR2
   IS
     v_iss_cd    GIIS_ISSOURCE.iss_cd%TYPE ;
   BEGIN
     v_bill_num:=NVL(p_bill_num,v_bill_num);
     SELECT REGEXP_SUBSTR(v_bill_num,v_substr_acct),
            REGEXP_SUBSTR(v_bill_num, v_substr_prem ) 
       INTO v_iss_cd,
            v_prem_seq_no 
       FROM DUAL;     
       IF v_due_date IS  NULL
       THEN
        v_due_date :=get_due_date(v_prem_seq_no);
       END IF;
       v_acct_iss_cd:=get_acct_iss_cd(v_iss_cd);            
       RETURN   LPAD(v_acct_iss_cd,  v_acct_iss_pad ,v_acct_char_pad)  || v_prem_seq_no  || v_due_date;
   END; 
   FUNCTION generate_indv(p_bill_num VARCHAR2, p_type NUMBER )
   RETURN  VARCHAR2
   IS
     v_type NUMBER := p_type;
     
   BEGIN
      v_bill_num:=NVL(p_bill_num,v_bill_num);
      cd_algorithm(p_type => v_type);         
      RETURN v_check_digit;
   END;   
   FUNCTION  generate(p_iss_cd GIPI_INVOICE.iss_cd%TYPE, p_prem_seqno GIPI_INVOICE.prem_seq_no%TYPE , p_due_date GIPI_INVOICE.due_date%TYPE DEFAULT NULL  )
   RETURN  VARCHAR2
   IS     
        v_output VARCHAR2(16);
   BEGIN  
      IF UPPER(pkg_check_digit.get_giis_parameter) != 'Y'  OR  pkg_check_digit.get_giis_parameter  IS NULL
      THEN
         RETURN NULL;
      END IF;    
      v_due_date:=NULL;       
      v_due_date:=NVL(TO_CHAR(p_due_date, v_tochar_due  ),v_due_date);
      v_bill_num:=p_iss_cd || LPAD(p_prem_seqno,8,'0');
      v_build  := BUILD;
      v_output :=v_build;
      v_output :=v_output|| generate_indv(v_bill_num,   1 );
    --  v_output  := v_output || generate_indv(v_bill_num, 2);             
      RETURN v_output;
   END;   
   PROCEDURE cd_algorithm(p_build VARCHAR2 DEFAULT NULL, p_type NUMBER DEFAULT 1)
   IS    
     v_total_1         NUMBER:=0;
     v_total_2         NUMBER:=0;
     v_iter_value      NUMBER;
     v_product         NUMBER;
     v_mod             NUMBER;
     PROCEDURE algo
     IS
     BEGIN
              DBMS_OUTPUT.PUT_LINE('Original * ' || v_multiplier || '  :' ||  v_product   );
              IF  v_product > 9 AND v_digit_process = TRUE
              THEN
                    DBMS_OUTPUT.PUT_LINE('1st If not single digit '  || (MOD(v_product,v_divisor) + TRUNC((v_product/v_divisor)) ));
                 v_product:=    (MOD(v_product,v_divisor) + TRUNC((v_product/v_divisor)) );
              END IF;
     END;
     PROCEDURE display
     IS
     BEGIN
             DBMS_OUTPUT.PUT_LINE('Original :' ||  v_product  );
     END;
   BEGIN
        v_build:=NVL(p_build,v_build);
        FOR I IN 1..LENGTH(v_build)
        LOOP
           v_iter_value:=SUBSTR(v_build,I,1);
           DBMS_OUTPUT.PUT_LINE('****************************'); 
           DBMS_OUTPUT.PUT_LINE('Original  : ' || v_iter_value ); 
           v_product :=  (v_iter_value* v_multiplier);                                                
           IF MOD(I,2) =0 
           THEN       
               IF p_type = 1
               THEN               
                   algo;
                   v_total_1:=   v_total_1+v_product;
               ELSE
                   --display;
                   v_total_1:=   v_total_1+ v_iter_value;
               END IF;                                
           ELSIF MOD(I,2) >0  
           THEN
               IF p_type = 1
               THEN                              
                   display;
                   v_total_2:=   v_total_2+ v_iter_value;
               ELSE                   
                   algo;
                   v_total_2:=   v_total_2+v_product;
               END IF;        
           END IF;           
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'); 
        DBMS_OUTPUT.PUT_LINE('Total 1 : ' || v_total_1 );
        DBMS_OUTPUT.PUT_LINE('Total 2 : ' || v_total_2 );
        DBMS_OUTPUT.PUT_LINE('Total   : ' || (v_total_1+v_total_2) );
        v_mod:= (MOD(v_total_1+v_total_2,  v_divisor ));
        DBMS_OUTPUT.PUT_LINE('MOD     : ' || v_mod );
        IF v_mod != 0 THEN
           v_check_digit    :=v_divisor-v_mod;
        ELSE
           v_check_digit    :=0;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Check_digit : ' ||  v_check_digit  );
   EXCEPTION 
     WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20010, SQLERRM  || ':' || SQLCODE || CHR(10) ||  'cd_algorithm: ' || v_build);          
   END;
   FUNCTION  get_giis_parameter RETURN VARCHAR2
   IS
     v_value GIIS_PARAMETERS.param_value_v%TYPE;
   BEGIN
       SELECT param_value_v 
         INTO v_value
         FROM GIIS_PARAMETERS
        WHERE param_name = v_param_name;
        RETURN v_value;
   EXCEPTION 
   WHEN OTHERS THEN
       RETURN 'N'; 
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss018_pkg
AS
   /*
      **  Created by        : Kenneth L.
      **  Date Created     : 10.17.2012
      **  Reference By     : (GIISS018)
      */
   FUNCTION get_pay_terms_list
      RETURN pay_terms_list_tab PIPELINED
   IS
      v_terms   pay_terms_list_type;
   BEGIN
      FOR i IN (SELECT   payt_terms, payt_terms_desc, no_of_payt, DECODE(annual_sw, 'Y', 'Y', 'N') annual_sw,
                         no_of_days, on_incept_tag, remarks, user_id,
                         no_payt_days, TO_CHAR(last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
                    FROM giis_payterm
                ORDER BY payt_terms_desc)
      LOOP
         v_terms.payt_terms := i.payt_terms;
         v_terms.payt_terms_desc := i.payt_terms_desc;
         v_terms.no_of_payt := i.no_of_payt;
         v_terms.annual_sw := i.annual_sw;
         v_terms.no_of_days := i.no_of_days;
         v_terms.on_incept_tag := i.on_incept_tag;
         v_terms.remarks := i.remarks;
         v_terms.user_id := i.user_id;
         v_terms.no_payt_days := i.no_payt_days;
         v_terms.last_update := i.last_update;
         PIPE ROW (v_terms);
      END LOOP;

      RETURN;
   END get_pay_terms_list;

   PROCEDURE set_pay_terms_list (p_payterm giis_payterm%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_payterm
         USING DUAL
         ON (payt_terms = p_payterm.payt_terms)
         WHEN NOT MATCHED THEN
            INSERT (payt_terms, payt_terms_desc, no_of_payt, annual_sw,
                    no_of_days, on_incept_tag, remarks, user_id,
                    no_payt_days, last_update)
            VALUES (p_payterm.payt_terms, p_payterm.payt_terms_desc, p_payterm.no_of_payt,
                    p_payterm.annual_sw, p_payterm.no_of_days, p_payterm.on_incept_tag, p_payterm.remarks,
                    p_payterm.user_id, p_payterm.no_payt_days, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET payt_terms_desc = p_payterm.payt_terms_desc,
                   no_of_payt = p_payterm.no_of_payt, annual_sw = p_payterm.annual_sw,
                   no_of_days = p_payterm.no_of_days,
                   on_incept_tag = p_payterm.on_incept_tag, remarks = p_payterm.remarks,
                   user_id =p_payterm.user_id, no_payt_days = p_payterm.no_payt_days,
                   last_update = SYSDATE
            ;
   END set_pay_terms_list;

   PROCEDURE delete_pay_terms_list (p_payt_terms giis_payterm.payt_terms%TYPE)
   IS
   BEGIN
      DELETE FROM giis_payterm
            WHERE payt_terms = p_payt_terms;
   END delete_pay_terms_list;
    
   FUNCTION validate_add_paytterm (p_payt_terms giis_payterm.payt_terms%TYPE)

   /**  for validation of adding new payment term 
   **       checks if the PAYT_TERMS is already existing in the table
   **       Kenneth L.
   **/
   
   RETURN VARCHAR2
   IS
       v_payt_terms     VARCHAR2 (2);
    BEGIN
         SELECT( SELECT '0'
                     FROM GIIS_PAYTERM
                    WHERE LOWER (payt_terms) LIKE LOWER (p_payt_terms)
                )
           INTO v_payt_terms
         FROM DUAL;

       IF v_payt_terms IS NOT NULL
       THEN
          RETURN v_payt_terms;
      END IF;
       
       RETURN '1';
    END validate_add_paytterm;
    
     FUNCTION validate_del_paytterm (p_payt_terms giis_payterm.payt_terms%TYPE)
     
   /**  for validation of deleting payment term
   **       checks if the payment term is being used in gipi_winvoice or gipi_invoice
   **       Kenneth L.
   **/
   
       RETURN VARCHAR2
    IS
       v_payt_terms    VARCHAR2 (30);
       v_payt_terms2   VARCHAR2 (30);
    BEGIN
       SELECT (SELECT   UPPER ('gipi_winvoice')
                   FROM gipi_winvoice b450
                  WHERE LOWER (b450.payt_terms) LIKE LOWER (p_payt_terms)
               GROUP BY payt_terms) a,
              (SELECT   UPPER ('gipi_invoice')
                   FROM gipi_invoice b140
                  WHERE LOWER (b140.payt_terms) LIKE LOWER (p_payt_terms)
               GROUP BY payt_terms) b
         INTO v_payt_terms,
              v_payt_terms2
         FROM DUAL;

       IF v_payt_terms IS NOT NULL
       THEN
          RETURN v_payt_terms;
       END IF;

       IF v_payt_terms2 IS NOT NULL
       THEN
          RETURN v_payt_terms2;
       END IF;

       RETURN '1';
    END validate_del_paytterm;
    
    FUNCTION validate_add_paytermdesc (
       p_payt_terms        giis_payterm.payt_terms%TYPE,
       p_payt_terms_desc   giis_payterm.payt_terms_desc%TYPE
    )
       /**  for validation of adding new payment term
       **       checks if the PAYT_TERMS_DESC is already existing in the table
       **       Kenneth L.
       **/
    RETURN VARCHAR2
    IS
       v_payt_terms_desc   VARCHAR2 (2);
       v_term              VARCHAR2 (100);
    BEGIN
       BEGIN
          SELECT payt_terms
            INTO v_term
            FROM giis_payterm
           WHERE payt_terms = p_payt_terms;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_term := '';
       END;

       IF v_term IS NULL
       THEN
          SELECT (SELECT '0'
                    FROM giis_payterm
                   WHERE UPPER (payt_terms_desc) = UPPER (p_payt_terms_desc))
            INTO v_payt_terms_desc
            FROM DUAL;
       ELSE
          SELECT (SELECT '0'
                    FROM giis_payterm
                   WHERE UPPER (payt_terms_desc) = UPPER (p_payt_terms_desc)
                     AND payt_terms != p_payt_terms)
            INTO v_payt_terms_desc
            FROM DUAL;
       END IF;

       IF v_payt_terms_desc IS NOT NULL
       THEN
          RETURN v_payt_terms_desc;
       END IF;

       RETURN '1';
    END validate_add_paytermdesc;
END giiss018_pkg;
/



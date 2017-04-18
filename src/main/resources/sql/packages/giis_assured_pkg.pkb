CREATE OR REPLACE PACKAGE BODY CPI.Giis_Assured_Pkg
AS
   /*
     ** Created by: Whofeih
     ** Created date: 02/12/2010
     */

   FUNCTION get_assd_name (p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN GIIS_ASSURED.assd_name%TYPE
   IS
      v_assd_name   GIIS_ASSURED.assd_name%TYPE;
   BEGIN
      FOR rec IN (SELECT assd_name
                    FROM GIIS_ASSURED
                   WHERE assd_no = p_assd_no)
      LOOP
         v_assd_name := rec.assd_name;
         EXIT;
      END LOOP;

      RETURN (v_assd_name);
   END get_assd_name;


   FUNCTION get_giis_assured
      RETURN giis_assured_tab
      PIPELINED
   IS
      v_assured   giis_assured_type;
   BEGIN
      FOR i
         IN (SELECT assd_no,
                    assd_name || suffix AS assd_name,
                       mail_addr1
                    || DECODE (mail_addr2, NULL, '', ' ')
                    || mail_addr2
                    || DECODE (mail_addr3, NULL, '', ' ')
                    || mail_addr3
                       address,
                    active_tag,
                    corporate_tag
               FROM GIIS_ASSURED
               ORDER BY assd_name)
      LOOP
         v_assured.assd_no := i.assd_no;
         v_assured.assd_name := i.assd_name;
         v_assured.address := i.address;
         v_assured.active_tag := i.active_tag;
         v_assured.corporate_tag := i.corporate_tag;
         PIPE ROW (v_assured);
      END LOOP;

      RETURN;
   END get_giis_assured;


   FUNCTION get_giis_assured_details (p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN giis_assured_details_tab
      PIPELINED
   IS
      v_assured   giis_assured_details_type;
   BEGIN
      FOR i
         IN (SELECT A.assd_no,
                    A.assd_name,
                    A.govt_tag,
                    A.tran_date,
                    A.designation,
                    A.gsis_no,
                    A.mail_addr1,
                    A.mail_addr2,
                    A.mail_addr3,
                    A.bill_addr1,
                    A.bill_addr2,
                    A.bill_addr3,
                    A.contact_pers,
                    A.phone_no,
                    A.industry_cd,
                    c.industry_nm,
                    A.office_type,
                    A.govt_type,
                    A.reference_no,
                    A.corporate_tag,
                    A.institutional_tag,
                    A.first_name,
                    A.last_name,
                    A.middle_initial,
                    A.suffix,
                    A.user_id,
                    A.last_update,
                    A.remarks,
                    A.parent_assd_no,
                    b.assd_name parent_assd_name,
                    A.assd_name2,
                    A.assd_tin,
                    A.cp_no,
                    A.sun_no,
                    A.globe_no,
                    A.smart_no,
                    A.control_type_cd,
                    d.control_type_desc,
                    A.zip_cd,
                    A.vat_tag,
                    A.active_tag,
                    A.no_tin_reason,
                    a.birth_date,
                    a.birth_month,
                    a.birth_year,
                    a.email_address 
               FROM GIIS_ASSURED A,
                    GIIS_ASSURED b,
                    GIIS_INDUSTRY c,
                    GIIS_CONTROL_TYPE d
              WHERE     b.assd_no(+) = A.parent_assd_no
                    AND c.industry_cd(+) = A.industry_cd
                    AND d.control_type_cd(+) = A.control_type_cd
                    AND A.assd_no = p_assd_no)
      LOOP
         v_assured.assd_no := i.assd_no;
         v_assured.assd_name := i.assd_name;
         v_assured.govt_tag := i.govt_tag;
         v_assured.tran_date := i.tran_date;
         v_assured.designation := i.designation;
         v_assured.gsis_no := i.gsis_no;
         v_assured.mail_addr1 := i.mail_addr1;
         v_assured.mail_addr2 := i.mail_addr2;
         v_assured.mail_addr3 := i.mail_addr3;
         v_assured.bill_addr1 := i.bill_addr1;
         v_assured.bill_addr2 := i.bill_addr2;
         v_assured.bill_addr3 := i.bill_addr3;
         v_assured.contact_pers := i.contact_pers;
         v_assured.phone_no := i.phone_no;
         v_assured.industry_cd := i.industry_cd;
         v_assured.industry_nm := i.industry_nm;
         v_assured.office_type := i.office_type;
         v_assured.govt_type := i.govt_type;
         v_assured.reference_no := i.reference_no;
         v_assured.corporate_tag := i.corporate_tag;
         v_assured.institutional_tag := i.institutional_tag;
         v_assured.first_name := i.first_name;
         v_assured.last_name := i.last_name;
         v_assured.middle_initial := i.middle_initial;
         v_assured.suffix := i.suffix;
         v_assured.user_id := i.user_id;
         v_assured.last_update := i.last_update;
         v_assured.remarks := i.remarks;
         v_assured.parent_assd_no := i.parent_assd_no;
         v_assured.parent_assd_name := i.parent_assd_name;
         v_assured.assd_name2 := i.assd_name2;
         v_assured.assd_tin := i.assd_tin;
         v_assured.cp_no := i.cp_no;
         v_assured.sun_no := i.sun_no;
         v_assured.globe_no := i.globe_no;
         v_assured.smart_no := i.smart_no;
         v_assured.control_type_cd := i.control_type_cd;
         v_assured.control_type_desc := i.control_type_desc;
         v_assured.zip_cd := i.zip_cd;
         v_assured.vat_tag := i.vat_tag;
         v_assured.active_tag := i.active_tag;
         v_assured.no_tin_reason := i.no_tin_reason;
          v_assured.birth_date            := i.birth_date;
         v_assured.birth_month            := i.birth_month;
          v_assured.birth_year          := i.birth_year;
          v_assured.email_address       := i.email_address;
         PIPE ROW (v_assured);
      END LOOP;

      RETURN;
   END get_giis_assured_details;

   PROCEDURE set_giis_assured (
      v_assd_no             IN GIIS_ASSURED.assd_no%TYPE,
      v_assd_name           IN GIIS_ASSURED.assd_name%TYPE,
      v_govt_tag            IN GIIS_ASSURED.govt_tag%TYPE,
      v_tran_date           IN GIIS_ASSURED.tran_date%TYPE,
      v_designation         IN GIIS_ASSURED.designation%TYPE,
      v_gsis_no             IN GIIS_ASSURED.gsis_no%TYPE,
      v_mail_addr1          IN GIIS_ASSURED.mail_addr1%TYPE,
      v_mail_addr2          IN GIIS_ASSURED.mail_addr2%TYPE,
      v_mail_addr3          IN GIIS_ASSURED.mail_addr3%TYPE,
      v_bill_addr1          IN GIIS_ASSURED.bill_addr1%TYPE,
      v_bill_addr2          IN GIIS_ASSURED.bill_addr2%TYPE,
      v_bill_addr3          IN GIIS_ASSURED.bill_addr3%TYPE,
      v_contact_pers        IN GIIS_ASSURED.contact_pers%TYPE,
      v_phone_no            IN GIIS_ASSURED.phone_no%TYPE,
      v_industry_cd         IN GIIS_ASSURED.industry_cd%TYPE,
      v_office_type         IN GIIS_ASSURED.office_type%TYPE,
      v_govt_type           IN GIIS_ASSURED.govt_type%TYPE,
      v_reference_no        IN GIIS_ASSURED.reference_no%TYPE,
      v_corporate_tag       IN GIIS_ASSURED.corporate_tag%TYPE,
      v_institutional_tag   IN GIIS_ASSURED.institutional_tag%TYPE,
      v_first_name          IN GIIS_ASSURED.first_name%TYPE,
      v_last_name           IN GIIS_ASSURED.last_name%TYPE,
      v_middle_initial      IN GIIS_ASSURED.middle_initial%TYPE,
      v_suffix              IN GIIS_ASSURED.suffix%TYPE,
      v_user_id             IN GIIS_ASSURED.user_id%TYPE,
      v_remarks             IN GIIS_ASSURED.remarks%TYPE,
      v_parent_assd_no      IN GIIS_ASSURED.parent_assd_no%TYPE,
      v_parent_assd_name    IN GIIS_ASSURED.assd_name%TYPE,
      v_assd_name2          IN GIIS_ASSURED.assd_name2%TYPE,
      v_assd_tin            IN GIIS_ASSURED.assd_tin%TYPE,
      v_cp_no               IN GIIS_ASSURED.cp_no%TYPE,
      v_sun_no              IN GIIS_ASSURED.sun_no%TYPE,
      v_globe_no            IN GIIS_ASSURED.globe_no%TYPE,
      v_smart_no            IN GIIS_ASSURED.smart_no%TYPE,
      v_control_type_cd     IN GIIS_ASSURED.control_type_cd%TYPE,
      v_zip_cd              IN GIIS_ASSURED.zip_cd%TYPE,
      v_vat_tag             IN GIIS_ASSURED.vat_tag%TYPE,
      v_active_tag          IN GIIS_ASSURED.active_tag%TYPE,
      v_no_tin_reason       IN GIIS_ASSURED.no_tin_reason%TYPE,
      v_birth_date              IN GIIS_ASSURED.birth_date%TYPE,
      v_birth_month             IN GIIS_ASSURED.birth_month%TYPE,
      v_birth_year          IN GIIS_ASSURED.birth_year%TYPE,
      v_email_address       IN GIIS_ASSURED.email_address%TYPe)
   IS
      v_exist       VARCHAR2 (1) := 'N';
      var_assd_no   GIIS_ASSURED.assd_no%TYPE;
   BEGIN
      FOR A IN (SELECT 1
                  FROM GIIS_ASSURED
                 WHERE assd_no = v_assd_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      IF v_exist = 'Y'
      THEN
         UPDATE GIIS_ASSURED
            SET assd_name = v_assd_name,
                govt_tag = v_govt_tag,
                tran_date = v_tran_date,
                designation = v_designation,
                gsis_no = v_gsis_no,
                mail_addr1 = v_mail_addr1,
                mail_addr2 = v_mail_addr2,
                mail_addr3 = v_mail_addr3,
                bill_addr1 = v_bill_addr1,
                bill_addr2 = v_bill_addr2,
                bill_addr3 = v_bill_addr3,
                contact_pers = v_contact_pers,
                phone_no = v_phone_no,
                industry_cd = v_industry_cd,
                office_type = v_office_type,
                govt_type = v_govt_type,
                reference_no = v_reference_no,
                corporate_tag = v_corporate_tag,
                institutional_tag = v_institutional_tag,
                first_name = v_first_name,
                last_name = v_last_name,
                middle_initial = v_middle_initial,
                suffix = v_suffix,
                user_id = v_user_id,
                remarks = v_remarks,
                parent_assd_no = v_parent_assd_no,
                assd_name2 = v_assd_name2,
                assd_tin = v_assd_tin,
                cp_no = v_cp_no,
                sun_no = v_sun_no,
                globe_no = v_globe_no,
                smart_no = v_smart_no,
                control_type_cd = v_control_type_cd,
                zip_cd = v_zip_cd,
                vat_tag = v_vat_tag,
                active_tag = NVL(v_active_tag, 'N'),
                no_tin_reason = v_no_tin_reason,
                  birth_date = v_birth_date,
                 birth_month = v_birth_month,
                  birth_year = v_birth_year,
                email_address =  v_email_address      
          WHERE assd_no = v_assd_no;
      ELSE
         /*SELECT assd_no_seq.NEXTVAL
             INTO var_assd_no
           FROM dual;*/

         INSERT INTO GIIS_ASSURED (assd_no,
                                   assd_name,
                                   govt_tag,
                                   tran_date,
                                   designation,
                                   gsis_no,
                                   mail_addr1,
                                   mail_addr2,
                                   mail_addr3,
                                   bill_addr1,
                                   bill_addr2,
                                   bill_addr3,
                                   contact_pers,
                                   phone_no,
                                   industry_cd,
                                   office_type,
                                   govt_type,
                                   reference_no,
                                   corporate_tag,
                                   institutional_tag,
                                   first_name,
                                   last_name,
                                   middle_initial,
                                   suffix,
                                   user_id,
                                   remarks,
                                   parent_assd_no,
                                   assd_name2,
                                   assd_tin,
                                   cp_no,
                                   sun_no,
                                   globe_no,
                                   smart_no,
                                   control_type_cd,
                                   zip_cd,
                                   vat_tag,
                                   active_tag,
                                   no_tin_reason,
                                    birth_date ,
                                birth_month,
                                birth_year,
                                email_address)
              VALUES (v_assd_no,
                      v_assd_name,
                      v_govt_tag,
                      v_tran_date,
                      v_designation,
                      v_gsis_no,
                      v_mail_addr1,
                      v_mail_addr2,
                      v_mail_addr3,
                      v_bill_addr1,
                      v_bill_addr2,
                      v_bill_addr3,
                      v_contact_pers,
                      v_phone_no,
                      v_industry_cd,
                      v_office_type,
                      v_govt_type,
                      v_reference_no,
                      v_corporate_tag,
                      v_institutional_tag,
                      v_first_name,
                      v_last_name,
                      v_middle_initial,
                      v_suffix,
                      v_user_id,
                      v_remarks,
                      v_parent_assd_no,
                      v_assd_name2,
                      v_assd_tin,
                      v_cp_no,
                      v_sun_no,
                      v_globe_no,
                      v_smart_no,
                      v_control_type_cd,
                      v_zip_cd,
                      v_vat_tag,
                      NVL(v_active_tag, 'N'),
                      v_no_tin_reason,
                     v_birth_date,
                    v_birth_month,
                    v_birth_year,
                    v_email_address   
                      );
      END IF;

      COMMIT;
   END set_giis_assured;


   PROCEDURE del_giis_assured (p_assd_no GIIS_ASSURED.assd_no%TYPE)
   IS
   BEGIN
      DELETE FROM GIIS_ASSURED
            WHERE assd_no = p_assd_no;

      COMMIT;
   END del_giis_assured;


   /********************************** FUNCTION 1 ************************************/

   FUNCTION get_assured_list
      RETURN assured_list_tab
      PIPELINED
   IS
      v_assd   assured_list_type;
   BEGIN
      FOR i
         IN (SELECT A.assd_no,
                    A.assd_name,
                    b.birthdate,
                       A.mail_addr1
                    || ' '
                    || A.mail_addr2
                    || ' '
                    || A.mail_addr3
                       complete_address,
                    A.mail_addr1,
                    A.mail_addr2,
                    A.mail_addr3
               FROM GIIS_ASSURED A, GIIS_ASSD_IND_INFO b
              WHERE A.assd_no = b.assd_no AND NVL (A.active_tag, 'N') = 'Y')
      LOOP
         v_assd.assd_no := i.assd_no;
         v_assd.assd_name := i.assd_name;
         v_assd.birthdate := i.birthdate;
         v_assd.complete_address := i.complete_address;
         v_assd.address1 := i.mail_addr1;
         v_assd.address2 := i.mail_addr2;
         v_assd.address3 := i.mail_addr3;
         PIPE ROW (v_assd);
      END LOOP;

      RETURN;
   END get_assured_list;


   /********************************** FUNCTION 2 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: SAME_ASSURED_NAME
   ***********************************************************************************/

   FUNCTION get_same_assured_name_list (
      p_assured_name GIIS_ASSURED.assd_name%TYPE)
      RETURN same_assured_name_list_tab
      PIPELINED
   IS
      v_same_assd_name   same_assured_name_list_type;
   BEGIN
      FOR i
         IN (SELECT assd_name,
                    assd_no,
                    mail_addr1,
                    mail_addr2,
                    mail_addr3,
                    bill_addr1,
                    bill_addr2,
                    bill_addr3,
                    contact_pers,
                    phone_no,
                    first_name,
                    last_name,
                    middle_initial
               FROM GIIS_ASSURED
              WHERE     assd_name LIKE p_assured_name || '%'
                    AND p_assured_name IS NOT NULL
                    AND NVL (active_tag, 'N') = 'Y')
      LOOP
         v_same_assd_name.assd_name := i.assd_name;
         v_same_assd_name.assd_no := i.assd_no;
         v_same_assd_name.mail_addr1 := i.mail_addr1;
         v_same_assd_name.mail_addr2 := i.mail_addr2;
         v_same_assd_name.mail_addr3 := i.mail_addr3;
         v_same_assd_name.bill_addr1 := i.bill_addr1;
         v_same_assd_name.bill_addr2 := i.bill_addr2;
         v_same_assd_name.bill_addr3 := i.bill_addr3;
         v_same_assd_name.contact_pers := i.contact_pers;
         v_same_assd_name.phone_no := i.phone_no;
         v_same_assd_name.first_name := i.first_name;
         v_same_assd_name.last_name := i.last_name;
         v_same_assd_name.middle_initial := i.middle_initial;
         PIPE ROW (v_same_assd_name);
      END LOOP;

      RETURN;
   END get_same_assured_name_list;


   /********************************** FUNCTION 3 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ASSURED_NAMES
   ***********************************************************************************/

   /**
   * Modified By : Andrew Robes
   * Date : 02-16-2012
   * Modifications : commented columns that are not being used in calling the lov to optimize the retrieval of assured records
   */

   FUNCTION get_assured_names_list (
     p_find_text     VARCHAR2,
     p_order_by      VARCHAR2,
     p_asc_desc_flag VARCHAR2,
     p_from          NUMBER,
     p_to            NUMBER
   ) RETURN assured_names_list_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c cur_type;
      v_rec   assured_names_list_type;
      v_sql          VARCHAR2(3000);
      
      v_find_text    VARCHAR2(5000);   --nieko 06302016, SR 22566, KB 22566
   BEGIN
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                      SELECT a.assd_name, a.assd_no, a.mail_addr1, a.mail_addr2,
                                             a.mail_addr3, a.designation, a.active_tag, a.user_id,
                                             a.industry_cd
                                        FROM giis_assured a
                                       WHERE NVL (a.active_tag, ''N'') = ''Y''';
                         
      IF p_find_text IS NOT NULL
      THEN
        --nieko 06302016 , SR 22566, KB 3606
        v_find_text := REPLACE(p_find_text, '''', '''''');
        v_sql := v_sql || ' AND (UPPER (a.assd_name) LIKE UPPER('''||v_find_text||''') OR a.assd_no LIKE '''||v_find_text||''')';
        --v_sql := v_sql || ' AND (UPPER (a.assd_name) LIKE UPPER('''||p_find_text||''') OR a.assd_no LIKE '''||p_find_text||''')';
        --nieko 06302015 end
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'assdNo'
        THEN        
          v_sql := v_sql || ' ORDER BY a.assd_no ';
        ELSIF p_order_by = 'assdName'
        THEN
          v_sql := v_sql || ' ORDER BY a.assd_name ';
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE
        v_sql := v_sql || ' ORDER BY a.assd_name ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
            
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.assd_name, 
                      v_rec.assd_no, 
                      v_rec.mail_addr1,
                      v_rec.mail_addr2,
                      v_rec.mail_addr3, 
                      v_rec.designation, 
                      v_rec.active_tag, 
                      v_rec.user_id, 
                      v_rec.industry_cd;
         EXIT WHEN c%NOTFOUND;       
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;     
   END get_assured_names_list;

   /********************************** FUNCTION 3.1 **********************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ASSURED_NAMES - FOR TABLE GRID
   ***********************************************************************************/

   FUNCTION get_assured_names_list_tg (
      p_assd_no          GIIS_ASSURED.assd_no%TYPE,
      p_corporate_tag    GIIS_ASSURED.corporate_tag%TYPE,
      p_assd_name        GIIS_ASSURED.assd_name%TYPE,
      p_mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      p_active_tag       GIIS_ASSURED.active_tag%TYPE)
      RETURN assured_names_list_tab_tg
      PIPELINED
   IS
      v_assd_names   assured_names_list_type_tg;
      v_intm_name    GIIS_INTERMEDIARY.intm_name%TYPE;
   BEGIN
    IF p_assd_no IS NULL OR 
       p_corporate_tag IS NULL OR   --[START] Added by MJ 11.23.2012 For Optimization
       p_assd_name  IS NULL OR           
       p_mail_addr1  IS NULL OR     
       p_active_tag  IS NULL        --[END] Added by MJ 11.23.2012 For Optimization
       THEN -- Created by: Marvin P. 11.22.2012 For Optimization
    
       FOR i
          IN (  SELECT A.assd_name,
                       TO_CHAR(A.assd_no, '099999999999') assd_no, -- andrew - 08.10.2012
                       A.mail_addr1,
                       A.mail_addr2,
                       A.mail_addr3,
                       A.designation,
                       A.active_tag,
                       A.user_id,
                       b.industry_nm,
                       c.birthdate,
                       /*Cg_Ref_Codes_Pkg.get_rv_meaning (
                       'GIIS_ASSURED.CORPORATE_TAG',
                       corporate_tag)
                       corp_tag,*/ --commented out by Thor, 12.04.2013 for optimization(quesy became faster by 11 sec, same no. of records)
                       UPPER(d.rv_meaning) corp_tag,  --added by Thor, 12.05.2013, to replace Cg-Ref_Codes-Pkg, for optimization
                       A.industry_cd
                 FROM GIIS_ASSURED A, GIIS_INDUSTRY b, GIIS_ASSD_IND_INFO c, cg_ref_codes d
                WHERE /*NVL (A.active_tag, 'N') = 'Y' commented by: Nica 06.04.2012 - assured listing for maintenance should include inactive assured
                      AND*/ A.industry_cd = b.industry_cd(+)
                      AND  NVL(A.assd_no,0) = NVL(p_assd_no, c.assd_no(+)) 
                      AND UPPER (A.assd_name) LIKE
                             --UPPER (NVL (p_assd_name, A.assd_name))
                             UPPER (NVL (p_assd_name, '%')) --modified by Thor, 12.04.2013 for optimization
                      /*AND UPPER (
                             Cg_Ref_Codes_Pkg.get_rv_meaning (
                                'GIIS_ASSURED.CORPORATE_TAG',
                                corporate_tag)) LIKE
                             UPPER (
                                NVL (
                                   p_corporate_tag,
                                   Cg_Ref_Codes_Pkg.get_rv_meaning (
                                      'GIIS_ASSURED.CORPORATE_TAG',
                                      corporate_tag)))*/ --commented out by Thor 12.04.2013, for optimization (query became faster by 22 sec, same no. of records)

                      ----------START------added where statements------------------
                      AND d.rv_domain = 'GIIS_ASSURED.CORPORATE_TAG'
                      AND d.rv_low_value = corporate_tag
                      AND UPPER(d.rv_meaning) LIKE UPPER (NVL (p_corporate_tag,'%'))
                      ----------END------------------------------------------------ added by Thor, 12.05.2013, for optimization 
                      AND UPPER (NVL(A.mail_addr1, '*')) LIKE
                             UPPER (NVL (p_mail_addr1, NVL(A.mail_addr1, '*')))
                      AND UPPER (NVL(A.active_tag, 'N')) LIKE
                             UPPER (NVL (p_active_tag, NVL(A.active_tag, 'N')))
             ORDER BY UPPER (A.assd_name) ASC)
       LOOP
         v_assd_names.assd_name := i.assd_name;
         v_assd_names.assd_no := i.assd_no;
         v_assd_names.mail_addr1 := i.mail_addr1;
         v_assd_names.mail_addr2 := i.mail_addr2;
         v_assd_names.mail_addr3 := i.mail_addr3;
         v_assd_names.designation := i.designation;
         v_assd_names.active_tag := i.active_tag;
         v_assd_names.user_id := i.user_id;
         v_assd_names.industry_nm := i.industry_nm; 
         v_assd_names.industry_cd := i.industry_cd;
         v_assd_names.corp_tag := i.corp_tag;  
         v_assd_names.birthdate := i.birthdate;

         v_intm_name := NULL;

         FOR a IN (SELECT intm_name
                     FROM GIIS_INTERMEDIARY x, GIIS_ASSURED_INTM y
                    WHERE i.assd_no = y.assd_no AND y.intm_no = x.intm_no)
         LOOP
            v_intm_name := a.intm_name;
         END LOOP;

         v_assd_names.intm_name := v_intm_name;

         PIPE ROW (v_assd_names);
       END LOOP;
    ELSE 
       FOR i
         IN (  SELECT A.assd_name,
                      TO_CHAR(A.assd_no, '099999999999') assd_no, -- andrew - 08.10.2012
                      A.mail_addr1,
                      A.mail_addr2,
                      A.mail_addr3,
                      A.designation,
                      A.active_tag,
                      A.user_id,
                      b.industry_nm,
                      c.birthdate,
                      /*Cg_Ref_Codes_Pkg.get_rv_meaning (
                      'GIIS_ASSURED.CORPORATE_TAG',
                      corporate_tag)
                      corp_tag, */ --commented out by Thor, 12.04.2013, for optimization
                      UPPER(d.rv_meaning) corp_tag, --added by Thor, 12.05.2013, to replace Cg-Ref_Codes-Pkg, for optimization
                      A.industry_cd
                 FROM GIIS_ASSURED A, GIIS_INDUSTRY b, GIIS_ASSD_IND_INFO c, cg_ref_codes d
                WHERE /*NVL (A.active_tag, 'N') = 'Y' commented by: Nica 06.04.2012 - assured listing for maintenance should include inactive assured
                      AND*/ A.industry_cd = b.industry_cd(+)
                      AND  NVL(A.assd_no,0) LIKE NVL(p_assd_no, c.assd_no(+)) 
                      AND UPPER (A.assd_name) LIKE
                             --UPPER (NVL (p_assd_name, A.assd_name))
                             UPPER (NVL (p_assd_name, '%')) --modified by Thor, 12.04.2013, for optimization
                      /*AND UPPER (
                             Cg_Ref_Codes_Pkg.get_rv_meaning (
                                'GIIS_ASSURED.CORPORATE_TAG',
                                corporate_tag)) LIKE
                             UPPER (
                                NVL (
                                   p_corporate_tag,
                                   Cg_Ref_Codes_Pkg.get_rv_meaning (
                                      'GIIS_ASSURED.CORPORATE_TAG',
                                      corporate_tag)))*/ --commented out by Thor, 12.04.2013, for optimization
                      /*AND UPPER (DECODE(A.corporate_tag, 'I','INDIVIDUAL'
                                                       , 'C','CORPORATE'
                                                       , 'J','JOINT')) LIKE
                             UPPER (NVL (p_corporate_tag,'%')) */--added by Thor, 12.05.2013, to replace Cg-Ref_Codes-Pkg, for optimization
                      
                      ----------START------added where statements------------------
                      AND d.rv_domain = 'GIIS_ASSURED.CORPORATE_TAG'
                      AND d.rv_low_value = corporate_tag
                      AND UPPER(d.rv_meaning) LIKE UPPER (NVL (p_corporate_tag,'%'))
                      ----------END------------------------------------------------ added by Thor, 12.05.2013, for optimization 
                      AND UPPER (NVL(A.mail_addr1, '*')) LIKE
                             UPPER (NVL (p_mail_addr1, NVL(A.mail_addr1, '*')))
                      AND UPPER (NVL(A.active_tag, 'N')) LIKE
                             UPPER (NVL (p_active_tag, NVL(A.active_tag, 'N')))
             ORDER BY UPPER (A.assd_name) ASC)
       LOOP
         v_assd_names.assd_name := i.assd_name;
         v_assd_names.assd_no := i.assd_no;
         v_assd_names.mail_addr1 := i.mail_addr1;
         v_assd_names.mail_addr2 := i.mail_addr2;
         v_assd_names.mail_addr3 := i.mail_addr3;
         v_assd_names.designation := i.designation;
         v_assd_names.active_tag := i.active_tag;
         v_assd_names.user_id := i.user_id;
         v_assd_names.industry_nm := i.industry_nm; 
         v_assd_names.industry_cd := i.industry_cd;
         v_assd_names.corp_tag := i.corp_tag;  
         v_assd_names.birthdate := i.birthdate; 

         v_intm_name := NULL;

         FOR a IN (SELECT intm_name
                     FROM GIIS_INTERMEDIARY x, GIIS_ASSURED_INTM y
                    WHERE i.assd_no = y.assd_no AND y.intm_no = x.intm_no)
         LOOP
            v_intm_name := a.intm_name;
         END LOOP;

         v_assd_names.intm_name := v_intm_name;

         PIPE ROW (v_assd_names);
       END LOOP;
    END IF;

      RETURN;
   END get_assured_names_list_tg;

   FUNCTION get_assured_names_list_tg2 (
      p_assd_no          GIIS_ASSURED.assd_no%TYPE,
      p_corporate_tag    GIIS_ASSURED.corporate_tag%TYPE,
      p_assd_name        GIIS_ASSURED.assd_name%TYPE,
      p_mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      p_active_tag       GIIS_ASSURED.active_tag%TYPE,
      p_intm_name        GIIS_ASSURED.assd_name %TYPE,     --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_intm_no          GIIS_ASSURED_INTM.intm_no%TYPE,   --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_str_assd_no      GIIS_ASSURED.assd_no%TYPE,        --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_order_by          VARCHAR2,  --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_asc_desc_flag     VARCHAR2,  --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_first_row         NUMBER,    --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_last_row          NUMBER     --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      )
      RETURN assured_names_list_tab_tg
      PIPELINED
   IS 
      TYPE cur_type IS REF CURSOR;
      v_cursor cur_type;
      v_query VARCHAR2(32767);--modified by pjsantos 09/16/2016 @ pcic adjusted from 5000 to 32767.
      v_where VARCHAR2(2000);
      v_assd_names   assured_names_list_type_tg;
      v_intm_name    GIIS_INTERMEDIARY.intm_name%TYPE;
      v_corp_tag     VARCHAR2(5000) := 'UPPER(DECODE(corporate_tag'; --marco - 08.19.2014
      v_assd_name VARCHAR2(5000); --added by gab 11.11.2015
      
   BEGIN    
      --marco - 08-19-2014 - to optimize query
      FOR i IN(SELECT rv_low_value, rv_meaning
                 FROM CG_REF_CODES
                WHERE rv_domain = 'GIIS_ASSURED.CORPORATE_TAG')
      LOOP
         v_corp_tag := v_corp_tag || ',''' || i.rv_low_value || ''',''' ||  i.rv_meaning || '''';
      END LOOP;
      
       v_query := 'SELECT mainsql.*
                     FROM (
                           SELECT COUNT (1) OVER () count_, outersql.* 
                             FROM (
                                  SELECT ROWNUM rownum_, innersql.*
                                       FROM (SELECT  A.assd_name,
                       LTRIM(TO_CHAR(A.assd_no, ''099999999999'')) assd_no,
                       mail_addr1 || '' '' || mail_addr2 || '' '' || mail_addr3 mail1,
                       '''' mail2,
                       '''' mail3,
                       A.designation, 
                       A.active_tag,
                       A.user_id, ' || v_corp_tag   || ')) corp_tag ' ||
                       --Cg_Ref_Codes_Pkg.get_rv_meaning ( --marco - 08.19.2014 - replaced
                       --''GIIS_ASSURED.CORPORATE_TAG'',
                       --corporate_tag)
                       --corp_tag'
                 ',  LTRIM(TO_CHAR(intm_no, ''0999999999999'')) intm_no 
                  FROM GIIS_ASSURED A, (SELECT MIN(intm_no) intm_no, assd_no from GIIS_ASSURED_INTM group by assd_no) b
                 WHERE A.ASSD_NO = B.ASSD_NO(+)'; --merged address fields
        
        IF p_intm_name IS NOT NULL THEN
          v_where := v_where || ' AND UPPER(NVL(intm_name, ''x'')) LIKE UPPER(NVL('||p_intm_name||', NVL(intm_name, ''x'')))';          
        END IF;
        
        IF p_str_assd_no IS NOT NULL THEN
          v_where := v_where || ' AND TRUNC(a.assd_no) = TRUNC('||p_str_assd_no||')';
        END IF;
        
        IF p_intm_no IS NOT NULL THEN
          v_where := v_where ||' AND intm_no = '||p_intm_no;
        END IF;
       
               
        IF p_assd_no IS NOT NULL THEN
          v_where := v_where || ' AND a.assd_no = ' ||p_assd_no;
        END IF;        
       
                                  
        IF p_assd_name IS NOT NULL THEN
          --edited by gab 11.11.2015
--          v_where := v_where || ' AND UPPER(a.assd_name) LIKE UPPER('''||p_assd_name||''')';
          v_assd_name := REPLACE(p_assd_name, '''', '''''');
          v_where := v_where || ' AND UPPER(a.assd_name) LIKE UPPER('''||v_assd_name||''')';
        END IF;
        
        IF p_corporate_tag IS NOT NULL THEN
          ---v_where := v_where || ' AND UPPER (Cg_Ref_Codes_Pkg.get_rv_meaning (''GIIS_ASSURED.CORPORATE_TAG'', corporate_tag)) LIKE UPPER('''||p_corporate_tag||''')';
          v_where := v_where || ' AND ' || v_corp_tag || ')) LIKE UPPER('''||p_corporate_tag||''')'; --marco - 08.09.2014
        END IF;
                      
        IF p_mail_addr1 IS NOT NULL THEN 
          v_where := v_where || ' AND (UPPER (A.mail_addr1) LIKE UPPER('''||p_mail_addr1||''')' ||
                    ' OR UPPER (A.mail_addr2) LIKE UPPER('''||p_mail_addr1||''')' || 
                    ' OR UPPER (A.mail_addr3) LIKE UPPER('''||p_mail_addr1||'''))'; --added by angelo 04.02.2014 to compare to addr2 and addr3
        END IF;
        
        IF p_active_tag IS NOT NULL THEN
          v_where := v_where || ' AND NVL(a.active_tag, ''N'') LIKE '''||p_active_tag||'''';
        END IF;
    
       
      IF p_order_by IS NOT NULL 
      THEN
        IF p_order_by = 'corporateTag'
         THEN        
          v_where := v_where || ' ORDER BY corp_tag ';
        ELSIF  p_order_by = 'strAssdNo'
         THEN
          v_where := v_where || ' ORDER BY a.assd_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_where := v_where || ' ORDER BY a.assd_name ';
        ELSIF  p_order_by = 'mailAddress1'
         THEN
          v_where := v_where || ' ORDER BY a.mail_addr1 '; 
        ELSIF  p_order_by = 'activeTag'
         THEN
          v_where := v_where || ' ORDER BY a.active_tag ';   
        ELSIF p_order_by = 'intmNo'      
         THEN
         v_where := v_where || ' ORDER BY intm_no '; 
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_where := v_where || p_asc_desc_flag;
        ELSE         
           v_where := v_where || ' ASC'; 
        END IF;          
      END IF;
--      raise_application_error(-20001, v_where);
    
         
       v_query := v_query || v_where||') innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; --added by by pjsantos 09162016 for optimization GENQA 5667

        OPEN v_cursor FOR v_query;/* || v_where || ' ORDER BY A.assd_name ASC comment out by pjsantos 09162016 for optimization GENQA 5667*/
        LOOP
          FETCH v_cursor INTO v_assd_names.count_, v_assd_names.rownum_,v_assd_names.assd_name, v_assd_names.assd_no, v_assd_names.mail_addr1, v_assd_names.mail_addr2, v_assd_names.mail_addr3,--modified by pjsantos 09/16/2016
                       v_assd_names.designation, v_assd_names.active_tag, v_assd_names.user_id, v_assd_names.corp_tag,v_assd_names.intm_no;
          EXIT WHEN v_cursor%NOTFOUND;

         
          /*v_assd_names.intm_no := null;
           FOR a IN (SELECT LTRIM(TO_CHAR(intm_no, '0999999999999')) intm_no
                     FROM GIIS_ASSURED_INTM y
                    WHERE v_assd_names.assd_no = y.assd_no)
         LOOP
            v_assd_names.intm_no := a.intm_no;
            EXIT;
         END LOOP;*/
                                
         PIPE ROW (v_assd_names);
        END LOOP;
        
        CLOSE v_cursor;          

      RETURN;
   END get_assured_names_list_tg2;

   /********************************** FUNCTION 4 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: IN_ACCOUNT_OF
   ***********************************************************************************/
   FUNCTION get_in_account_of_list (
      p_assd_no       GIIS_ASSURED.assd_no%TYPE,
      p_in_acct_of    GIIS_ASSURED.assd_name%TYPE)
      RETURN in_account_of_list_tab
      PIPELINED
   IS
      v_assd_names   in_account_of_list_type;
   BEGIN
      FOR i
         IN (  SELECT A.assd_name,
                      A.assd_no,
                      A.active_tag,
                      b.industry_nm,
                      A.mail_addr1,
                      A.mail_addr2,
                      A.mail_addr3
                 FROM GIIS_ASSURED A, GIIS_INDUSTRY b
                WHERE     A.assd_no != p_assd_no
                      AND NVL (A.active_tag, 'N') = 'Y'
                      AND UPPER (A.assd_name) LIKE
                             UPPER ('%' || p_in_acct_of || '%')
                      AND A.industry_cd = b.industry_cd(+)
             ORDER BY UPPER (assd_name))
      LOOP
         v_assd_names.assd_name := i.assd_name;
         v_assd_names.assd_no := i.assd_no;
         v_assd_names.active_tag := i.active_tag;
         v_assd_names.industry_nm := i.industry_nm;
         v_assd_names.mail_addr1 := i.mail_addr1;
         v_assd_names.mail_addr2 := i.mail_addr2;
         v_assd_names.mail_addr3 := i.mail_addr3;
         PIPE ROW (v_assd_names);
      END LOOP;

      RETURN;
   END get_in_account_of_list;


   /********************************** FUNCTION 5 ************************************
     For Assured LOVs
   ***********************************************************************************/

   FUNCTION get_assd_lov_list
      RETURN assd_lov_list_tab
      PIPELINED
   IS
      v_assd   assd_lov_list_type;
   BEGIN
      FOR i IN (SELECT A.assd_name, A.assd_no
                  FROM GIIS_ASSURED A
                 WHERE NVL (A.active_tag, 'N') = 'Y')
      LOOP
         v_assd.assd_name := i.assd_name;
         v_assd.assd_no := i.assd_no;
         PIPE ROW (v_assd);
      END LOOP;

      RETURN;
   END get_assd_lov_list;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.08.2010
   **  Reference By     : (GIPIS003 - Item Information - Fire)
   **  Description     : Returns the mailing address of the assured
   */
   PROCEDURE get_assd_mailing_address (
      p_assd_no      IN     GIIS_ASSURED.assd_no%TYPE,
      p_mail_addr1      OUT GIIS_ASSURED.mail_addr1%TYPE,
      p_mail_addr2      OUT GIIS_ASSURED.mail_addr2%TYPE,
      p_mail_addr3      OUT GIIS_ASSURED.mail_addr3%TYPE)
   IS
   BEGIN
      FOR i IN (SELECT mail_addr1, mail_addr2, mail_addr3
                  FROM GIIS_ASSURED
                 WHERE assd_no = p_assd_no)
      LOOP
         p_mail_addr1 := i.mail_addr1;
         p_mail_addr2 := i.mail_addr2;
         p_mail_addr3 := i.mail_addr3;
      END LOOP;
   END get_assd_mailing_address;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 04.20.2010
   **  Reference By     : (Policy Documents)
   **  Description     : Returns the assd_name of a particular basic_assd_no
   */
   FUNCTION get_assd_name2 (p_assd_no IN GIIS_ASSURED.assd_no%TYPE)
      RETURN VARCHAR2
   IS
      v_assd_name   VARCHAR2 (1000);
   BEGIN
      FOR i
         IN (SELECT DECODE (
                       designation,
                       NULL, assd_name || ' ' || assd_name2,
                       designation || ' ' || assd_name || ' ' || assd_name2)
                       assd_name
               FROM GIIS_ASSURED
              WHERE assd_no = p_assd_no)
      LOOP
         v_assd_name := i.assd_name;
      END LOOP;

      RETURN v_assd_name;
   END get_assd_name2;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 04.26.2010
   **  Reference By     : (Policy Documents)
   **  Description     : Returns the assd_name with the given acct_of_cd
   */
   FUNCTION get_pol_doc_assd_name (
      p_acct_of_cd IN GIXX_POLBASIC.acct_of_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_assd_name   GIIS_ASSURED.assd_name%TYPE;
   BEGIN
      FOR A
         IN (SELECT A.assd_name assd_name
               FROM GIIS_ASSURED A, GIXX_POLBASIC b
              WHERE     b.acct_of_cd > 0
                    AND b.acct_of_cd = p_acct_of_cd
                    AND A.assd_no = b.acct_of_cd)
      LOOP
         v_assd_name := A.assd_name;
         EXIT;
      END LOOP;

      RETURN v_assd_name;
   END get_pol_doc_assd_name;

   FUNCTION check_assured_dependencies (p_assd_no NUMBER)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (100) := '';
   BEGIN
      /* Checks if the ASSD_NO to be deleted is being
      ** referenced by other tables, as such will prevent
      ** the record from being removed. */
      
      --added by gab 10.21.2015
      FOR c1 IN (SELECT 'a'
                   FROM gipi_quote
                    WHERE acct_of_cd = p_assd_no)
      LOOP
         v_result :=
           'Cannot delete the record. Record is already referenced by an existing transaction.';
      END LOOP;
      
      --added by gab 10.21.2015
      FOR c1 IN (SELECT 'a'
                   FROM gipi_quote
                    WHERE assd_no = p_assd_no)
      LOOP
         v_result :=
           'Cannot delete the record. Record is already referenced by an existing transaction.';
      END LOOP;
      
      --added by gab 10.21.2015
      FOR c1 IN (SELECT 'a'
                   FROM gipi_wpolbas
                    WHERE acct_of_cd = p_assd_no)
      LOOP
         v_result :=
            'Cannot delete the record. Record is already referenced by an existing transaction.';
      END LOOP;
      
      FOR c1 IN (SELECT 'a'
                   FROM gipi_parlist
                  WHERE assd_no = p_assd_no)
      LOOP
         v_result :=
            --'Cannot delete master record, while dependent record exists.';
            'Cannot delete record from GIIS_ASSURED while dependent record(s) in GIPI_PARLIST exists.'; --angelo 04.02.2014
      END LOOP;
      
      --added by gab 10.21.2015
      FOR c1 IN (SELECT 'a'
                   FROM gipi_polbasic
                    WHERE acct_of_cd = p_assd_no)
      LOOP
         v_result :=
            'Cannot delete the record. Record is already referenced by an existing transaction.';
      END LOOP;
     
     

      FOR c1 IN (SELECT 'a'
                   FROM gipi_polbasic
                  WHERE assd_no = p_assd_no)
      LOOP
         v_result :=
            --'Cannot delete master record, while dependent record exists.';
            'Cannot delete record from GIIS_ASSURED while dependent record(s) in GIPI_POLBASIC exists.';--angelo 04.02.2014
      END LOOP;

      RETURN v_result;
   END;

   PROCEDURE delete_giis_assured (p_assd_no NUMBER)
   AS
   BEGIN
      DELETE FROM GIIS_ASSURED
            WHERE assd_no = p_assd_no;

      COMMIT;
   END;

   /*
   **  Created by        : D.Alcantara
   **  Date Created     : 04.18.2011
   **  Reference By     : GIPIR913
   */
   FUNCTION get_assd_name_GIPIR913 (
      p_acct_of_cd    GIPI_POLBASIC.acct_of_cd%TYPE,
      p_label_tag     GIPI_POLBASIC.label_tag%TYPE)
      RETURN VARCHAR2
   IS
      v_ntemp   VARCHAR2 (551);
      v_name    VARCHAR2 (551);
   BEGIN
      IF p_acct_of_cd IS NOT NULL
      THEN
         SELECT assd_name
           INTO v_ntemp
           FROM giis_assured
          WHERE assd_no = p_acct_of_cd;

         IF p_label_tag = 'Y'
         THEN
            v_name := 'Leased to  :' || ' ' || v_ntemp;
         ELSIF p_label_tag = 'N'
         THEN
            v_name := 'In account of  :' || ' ' || v_ntemp;
         END IF;
      ELSE
         v_name := NULL;
      END IF;

      RETURN (v_name);
   END get_assd_name_GIPIR913;

   FUNCTION check_if_ref_no_exist (p_ref_no GIIS_ASSURED.reference_no%TYPE)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (100) := '';
   BEGIN
      FOR A IN (SELECT 1
                  FROM GIIS_ASSURED
                 WHERE reference_no = p_ref_no)
      LOOP
         v_result := 'This Reference Number/Code Already Exists.';
         EXIT;
      END LOOP;

      RETURN v_result;
   END;

   /*
   **  Created by       : Christian Santos
   **  Date Created     : 12.26.2012
   **  Description      : 
   */
   FUNCTION check_if_ref_no_exist2 (p_ref_no GIIS_ASSURED.reference_no%TYPE,
                                    p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (100) := '';
   BEGIN
      FOR A IN (SELECT 1
                  FROM GIIS_ASSURED
                 WHERE reference_no = p_ref_no
                   AND assd_no <> p_assd_no)
      LOOP
         v_result := 'This Reference Number/Code Already Exists.';
         EXIT;
      END LOOP;

      RETURN v_result;
   END;
   
   FUNCTION get_all_assd_list (p_keyword GIIS_ASSURED.assd_name%TYPE)
      RETURN assd_lov_list_tab
      PIPELINED
   AS
      v_assd   assd_lov_list_type;
   BEGIN
      FOR i
         IN (  SELECT assd_no, assd_name
                 FROM GIIS_ASSURED
                WHERE UPPER (assd_name) LIKE UPPER (NVL (p_keyword, assd_name))
             ORDER BY assd_name)
      LOOP
         v_assd.assd_no := i.assd_no;
         v_assd.assd_name := i.assd_name;
         PIPE ROW (v_assd);
      END LOOP;
   END;

   PROCEDURE validate_assd_no (
      p_assd_no     IN     GIIS_ASSURED.assd_no%TYPE,
      p_assd_name      OUT GIIS_ASSURED.assd_name%TYPE)
   AS
   BEGIN
      SELECT assd_name
        INTO p_assd_name
        FROM GIIS_ASSURED
       WHERE assd_no = p_assd_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_assd_name := NULL;
   END;

   FUNCTION validate_assd_no_giexs006 (p_assd_no giis_assured.assd_no%TYPE)
      RETURN giis_assured_tab
      PIPELINED
   AS
      v_assd   giis_assured_type;
   BEGIN
      FOR i IN (SELECT assd_no, assd_name
                  FROM giis_assured
                 WHERE assd_no = p_assd_no)
      LOOP
         v_assd.assd_no := i.assd_no;
         v_assd.assd_name := i.assd_name;
         PIPE ROW (v_assd);
      END LOOP;
   END validate_assd_no_giexs006;

   FUNCTION check_assured_exist_giiss006b (
      p_assd_name        IN giis_assured.assd_name%TYPE,
      p_last_name        IN giis_assured.last_name%TYPE,
      p_first_name       IN giis_assured.first_name%TYPE,
      p_middle_initial   IN giis_assured.middle_initial%TYPE,
      p_mail_addr1       IN giis_assured.mail_addr1%TYPE,
      p_mail_addr2       IN giis_assured.mail_addr2%TYPE,
      p_mail_addr3       IN giis_assured.mail_addr3%TYPE,
      p_assd_no          IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
       BEGIN
      SELECT 'Y'
        INTO v_exist
        FROM giis_assured
       --WHERE NVL(assd_name,' ')           = DECODE(:a020.assd_name,NULL,' ',:a020.assd_name) -original condition
       WHERE     assd_name = DECODE (p_assd_name, NULL, ' ', p_assd_name) --removed nvl to enable use of index
             AND NVL (last_name, ' ') =
                    DECODE (p_last_name, NULL, ' ', p_last_name)
             AND NVL (first_name, ' ') =
                    DECODE (p_first_name, NULL, ' ', p_first_name)
             AND NVL (middle_initial, ' ') =
                    DECODE (p_middle_initial, NULL, ' ', p_middle_initial)
             AND NVL (UPPER (mail_addr1), ' ') =
                    DECODE (p_mail_addr1, NULL, ' ', UPPER (p_mail_addr1))
             AND NVL (UPPER (mail_addr2), ' ') =
                    DECODE (p_mail_addr2, NULL, ' ', UPPER (p_mail_addr2))
             AND NVL (UPPER (mail_addr3), ' ') =
                    DECODE (p_mail_addr3, NULL, ' ', UPPER (p_mail_addr3))
             AND NVL (assd_no, 0) != DECODE (p_assd_no, NULL, 0, p_assd_no)
             AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        
         v_exist := 'N';
END;
         RETURN v_exist;
   END;

   FUNCTION check_assured_exist_giiss006b2 (
      p_assd_name        IN giis_assured.assd_name%TYPE,
      p_last_name        IN giis_assured.last_name%TYPE,
      p_first_name       IN giis_assured.first_name%TYPE,
      p_middle_initial   IN giis_assured.middle_initial%TYPE,
      p_assd_no          IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      v_exist := 'N';

      IF     p_last_name IS NOT NULL
         AND p_first_name IS NOT NULL
         --AND p_middle_initial IS NOT NULL  --added by steven 10/05/2012 "NOT"
      THEN
         FOR assd
            IN (SELECT '1'
                  FROM giis_assured
                 WHERE     last_name = p_last_name
                       AND first_name = p_first_name
                       --AND middle_initial = p_middle_initial --added by steven 10/05/2012
                       AND UPPER(NVL(middle_initial, '%')) LIKE UPPER(NVL(p_middle_initial, NVL(middle_initial, '%'))) -- marco - 12.11.2012
                       AND assd_no != DECODE(p_assd_no, NULL, -1, p_assd_no)
                       AND ROWNUM = 1)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;
      ELSE
         FOR assd IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_name = p_assd_name
                         AND assd_no != DECODE(p_assd_no, NULL, -1, p_assd_no)
                         AND ROWNUM = 1)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;
      END IF;

      RETURN v_exist;
   END;

   FUNCTION giiss066b_post_query (p_assd_no IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2
   IS
       
        v_name    varchar2(10000) :=null;
          v_exist varchar2(1) := 'N';
          v_count number := 1;
          v_count2 number := 1;
   BEGIN
      FOR b
         IN (SELECT line_name
               FROM giis_line
              WHERE line_cd IN
                       (SELECT DISTINCT a.line_cd line_cd
                          FROM gipi_polbasic a,
                               gipi_parlist b,
                               giis_assured c
                         WHERE     b.par_id = a.par_id
                               AND a.assd_no = b.assd_no
                               AND a.assd_no = c.assd_no
                               AND a.assd_no = p_assd_no))
      LOOP
         v_exist := 'Y';

         IF v_count = 1
         THEN
            v_name := v_name || ' and ' || b.line_name;
            v_count := v_count + 1;
         ELSE
            v_name := ',' || b.line_name || v_name;
            v_count2 := v_count2 + 1;
         END IF;
      END LOOP;
      
          if v_count2 = 1 then       
          v_name := substr(v_name,6);
        else
                  v_name := substr(v_name,2);
        end if;
        
        if v_exist = 'N' then 
              return 'out existing ';
        else
              return ' an existing '||v_name; 
        end if;
   END;
   
   FUNCTION get_giiss006b_exsiting_assd_tg (
      p_assd_name        IN   giis_assured.assd_name%TYPE,
      p_last_name        IN   giis_assured.last_name%TYPE,
      p_first_name       IN   giis_assured.first_name%TYPE,
      p_middle_initial   IN   giis_assured.middle_initial%TYPE,
      p_assd_no          IN   giis_assured.assd_no%TYPE
   )
      RETURN assured_names_list_tab2 PIPELINED
   IS
      v_assd_names   assured_names_list_type2;
   BEGIN
      IF p_assd_no IS NOT NULL
      THEN
         FOR i IN (SELECT   *
                       FROM giis_assured a
                      WHERE --assd_name LIKE p_assd_name    
                          --last_name LIKE p_last_name        --change by steven 10.05.2012
                           --AND first_name LIKE p_first_name --Commented out by Jerome Bautista 07.31.2015 SR 19507_4815
                           --AND middle_initial LIKE p_middle_initial --Commented out by Jerome Bautista 07.31.2015 SR 19507_4815
                        NVL(first_name, '%') LIKE NVL(p_first_name, NVL(first_name, '%')) --Added by Jerome Bautista 07.31.2015 SR 19507_4815
                        AND NVL(last_name, '%') LIKE NVL(p_last_name, NVL(last_name, '%')) --Added by Jerome Bautista 07.31.2015 SR 19507_4815
                        AND NVL(middle_initial, '%') LIKE NVL(p_middle_initial, NVL(middle_initial, '%')) 
                        AND NVL(assd_name, '%') LIKE NVL(p_assd_name, NVL(assd_name, '%')) --Added by Jerome Bautista 07.31.2015 SR 19507_4815
                        AND assd_no != p_assd_no
                   ORDER BY UPPER (a.assd_name) ASC)
         LOOP
            v_assd_names.assd_name := i.assd_name;
            v_assd_names.assd_no := i.assd_no;
            v_assd_names.mail_addr1 := i.mail_addr1;
            v_assd_names.mail_addr2 := i.mail_addr2;
            v_assd_names.mail_addr3 := i.mail_addr3;
            v_assd_names.BILL_ADDR1 := i.BILL_ADDR1;
            v_assd_names.BILL_ADDR2 := i.BILL_ADDR2;
            v_assd_names.BILL_ADDR3 := i.BILL_ADDR3;
            v_assd_names.contact_pers := i.contact_pers;
            v_assd_names.phone_no := i.phone_no;
            v_assd_names.first_name := i.first_name;
            v_assd_names.last_name := i.last_name;
            v_assd_names.middle_initial := i.middle_initial;
            PIPE ROW (v_assd_names);
         END LOOP;
      ELSE
         IF p_last_name IS NOT NULL AND p_first_name IS NOT NULL
            --AND p_middle_initial IS NOT NULL -- marco - 12.11.2012
         THEN
            FOR i IN (SELECT   *
                          FROM giis_assured a
                         WHERE --first_name LIKE p_first_name -- Commented out by Jerome Bautista 07.31.2015 SR 19507_4815
                               NVL(first_name, '%') LIKE NVL(p_first_name, NVL(first_name, '%')) -- Added by Jerome Bautista 07.31.2015 SR 19507_4815
                           --AND last_name LIKE p_last_name -- Commented out by Jerome Bautista 07.31.2015 SR 19507_4815
                           AND NVL(last_name, '%') LIKE NVL(p_last_name, NVL(last_name, '%')) -- Added by Jerome Bautista 07.31.2015 SR 19507_4815
                           AND UPPER(NVL(middle_initial, '%')) LIKE UPPER(NVL(p_middle_initial, NVL(middle_initial, '%'))) -- marco - 12.11.2012
                      ORDER BY UPPER (a.assd_name) ASC)
            LOOP
                v_assd_names.assd_name := i.assd_name;
            v_assd_names.assd_no := i.assd_no;
            v_assd_names.mail_addr1 := i.mail_addr1;
            v_assd_names.mail_addr2 := i.mail_addr2;
            v_assd_names.mail_addr3 := i.mail_addr3;
            v_assd_names.BILL_ADDR1 := i.BILL_ADDR1;
            v_assd_names.BILL_ADDR2 := i.BILL_ADDR2;
            v_assd_names.BILL_ADDR3 := i.BILL_ADDR3;
            v_assd_names.contact_pers := i.contact_pers;
            v_assd_names.phone_no := i.phone_no;
            v_assd_names.first_name := i.first_name;
            v_assd_names.last_name := i.last_name;
            v_assd_names.middle_initial := i.middle_initial;
               PIPE ROW (v_assd_names);
            END LOOP;
         ELSE
            FOR i IN (SELECT   *
                          FROM giis_assured a
                         WHERE assd_name LIKE  LTRIM(RTRIM(p_assd_name))
                      ORDER BY UPPER (a.assd_name) ASC)
            LOOP
                v_assd_names.assd_name := i.assd_name;
            v_assd_names.assd_no := i.assd_no;
            v_assd_names.mail_addr1 := i.mail_addr1;
            v_assd_names.mail_addr2 := i.mail_addr2;
            v_assd_names.mail_addr3 := i.mail_addr3;
            v_assd_names.BILL_ADDR1 := i.BILL_ADDR1;
            v_assd_names.BILL_ADDR2 := i.BILL_ADDR2;
            v_assd_names.BILL_ADDR3 := i.BILL_ADDR3;
            v_assd_names.contact_pers := i.contact_pers;
            v_assd_names.phone_no := i.phone_no;
            v_assd_names.first_name := i.first_name;
            v_assd_names.last_name := i.last_name;
            v_assd_names.middle_initial := i.middle_initial;
               PIPE ROW (v_assd_names);
            END LOOP;
         END IF;
      END IF;
   END;
   
   /*
    **  Created by     : Veronica V. Raymundo
    **  Date Created   : 11.13.2012
    **  Reference By   : Quick Policy Issuance
    **  Description    : Retrieve list of assured with their complete details
    */
   
   FUNCTION get_assured_details_list (p_keyword IN VARCHAR2)
      RETURN giis_assured_details_tab PIPELINED
   IS
      v_assured   giis_assured_details_type;
   BEGIN
      FOR i IN (SELECT A.assd_no,
                       A.assd_name,
                       A.assd_name2,
                       A.corporate_tag,
                       A.vat_tag,
                       A.govt_tag,
                       A.designation,
                       A.last_name,
                       A.first_name,
                       A.middle_initial,
                       A.suffix,
                       A.industry_cd,
                       A.control_type_cd,
                       A.mail_addr1,
                       A.mail_addr2,
                       A.mail_addr3,
                       A.bill_addr1,
                       A.bill_addr2,
                       A.bill_addr3,
                       A.zip_cd,
                       A.contact_pers,
                       A.assd_tin,
                       A.user_id,
                       A.last_update,
                       A.remarks,
                       A.tran_date,
                       A.active_tag
                 FROM GIIS_ASSURED A
                WHERE NVL (A.active_tag, 'N') = 'Y'
                  AND (UPPER (A.assd_name) LIKE NVL (UPPER (p_keyword), '%') 
                   OR a.assd_no LIKE NVL(p_keyword,'%'))
                ORDER BY UPPER (A.assd_name) ASC)
      LOOP
         v_assured.assd_no          := i.assd_no;
         v_assured.assd_name        := i.assd_name;
         v_assured.assd_name2       := i.assd_name2;
         v_assured.corporate_tag    := i.corporate_tag;
         v_assured.vat_tag          := i.vat_tag;
         v_assured.govt_tag         := i.govt_tag;
         v_assured.designation      := i.designation;
         v_assured.last_name        := i.last_name;
         v_assured.first_name       := i.first_name;
         v_assured.middle_initial   := i.middle_initial;
         v_assured.suffix           := i.suffix;
         v_assured.industry_cd      := i.industry_cd;
         v_assured.control_type_cd  := i.control_type_cd;
         v_assured.mail_addr1       := i.mail_addr1;
         v_assured.mail_addr2       := i.mail_addr2;
         v_assured.mail_addr3       := i.mail_addr3;
         v_assured.bill_addr1       := i.bill_addr1;
         v_assured.bill_addr2       := i.bill_addr2;
         v_assured.bill_addr3       := i.bill_addr3;
         v_assured.zip_cd           := i.zip_cd;
         v_assured.contact_pers     := i.contact_pers;
         v_assured.assd_tin         := i.assd_tin;
         v_assured.user_id          := i.user_id;
         v_assured.last_update      := i.last_update;
         v_assured.remarks          := i.remarks;
         v_assured.tran_date        := i.tran_date;
         v_assured.active_tag       := i.active_tag;
        
         PIPE ROW (v_assured);
         
      END LOOP;
   END get_assured_details_list;
   
   --added by : Kenneth L. 07.16.2013 :for giacs286
   FUNCTION get_giacs286_assd_lov
     RETURN assd_lov_list_tab PIPELINED
   AS
      v_assd   assd_lov_list_type;
   BEGIN
      FOR i
         IN (SELECT   assd_no, assd_name
                FROM giis_assured
            ORDER BY 2)
      LOOP
         v_assd.assd_no := i.assd_no;
         v_assd.assd_name := i.assd_name;
         PIPE ROW (v_assd);
      END LOOP;
   END get_giacs286_assd_lov;
   
   FUNCTION get_gisms008_assd_lov (p_name VARCHAR2)
      RETURN assd_lov_list_tab PIPELINED
   IS
      v_list assd_lov_list_type;
   BEGIN
      FOR i IN (SELECT assd_no, assd_name
                  FROM giis_assured
                 WHERE REPLACE(assd_name, ' ', NULL) LIKE REPLACE(p_name, ' ', NULL))
      LOOP
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_gisms008_assd_lov;      
   
   
   FUNCTION get_giiss022_assured_lov(
      p_assured_name       giis_assured.assd_name%TYPE
   ) RETURN assured_names_list_tab PIPELINED
   IS
      v_assd_names         assured_names_list_type;
   BEGIN
      FOR i IN (SELECT a.assd_name, a.assd_no, a.mail_addr1, a.mail_addr2, a.control_type_cd,
                       a.mail_addr3, a.designation, a.active_tag, a.user_id, a.industry_cd
                  FROM giis_assured a
                 WHERE NVL(a.active_tag, 'N') = 'Y'
                   AND (UPPER(a.assd_name) LIKE NVL(UPPER(p_assured_name),'%') OR a.assd_no LIKE NVL(p_assured_name,'%'))
                 ORDER BY UPPER(a.assd_name) ASC)
      LOOP
         v_assd_names.assd_name := i.assd_name;
         v_assd_names.assd_no := i.assd_no;
         v_assd_names.mail_addr1 := i.mail_addr1;
         v_assd_names.mail_addr2 := i.mail_addr2;
         v_assd_names.mail_addr3 := i.mail_addr3;
         v_assd_names.designation := i.designation;
         v_assd_names.active_tag := i.active_tag;
         v_assd_names.user_id := i.user_id;
         v_assd_names.industry_cd := i.industry_cd;
         v_assd_names.control_type_cd := i.control_type_cd;
         
         PIPE ROW (v_assd_names);
      END LOOP;
   END;
   
   FUNCTION get_giiss006_intm_list(
     p_assd_no giis_assured_intm.assd_no%TYPE,
     p_line_cd giis_assured_intm.line_cd%TYPE,
     p_intm_no giis_assured_intm.intm_no%TYPE,
     p_intm_name giis_intermediary.intm_name%TYPE 
   ) RETURN giiss006_intm_tab PIPELINED 
   AS
     v_rec giiss006_intm_type;
   BEGIN
     FOR i IN (
       SELECT a.line_cd, a.intm_no, b.intm_name
         FROM giis_assured_intm a
             ,giis_intermediary b
        WHERE a.assd_no = p_assd_no
          AND a.intm_no = b.intm_no
          AND UPPER(a.line_cd) LIKE UPPER(NVL(p_line_cd, '%'))
          AND a.intm_no = NVL(p_intm_no, a.intm_no)
          AND UPPER(b.intm_name) LIKE UPPER(NVL(p_intm_name, '%'))
        ORDER BY a.line_cd, a.intm_no
     )
     LOOP
       v_rec.line_cd := i.line_cd;
       v_rec.intm_no := i.intm_no;
       v_rec.intm_name := i.intm_name;
       
       PIPE ROW(v_rec);
     END LOOP;
     
     RETURN;
   END;
   
   /* benjo 09.07.2016 SR-5604 */
   FUNCTION check_default_intm (
      p_assd_no     giis_assured_intm.assd_no%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   AS
      v_iss_cd_ri   giis_parameters.param_value_v%TYPE := NVL(giisp.v('ISS_CD_RI'), 'RI');
      v_exists      NUMBER                             := 0;
      v_msg         VARCHAR2 (100)                     := 'SUCCESS';
   BEGIN
      IF NVL(giisp.v('REQUIRE_DEFAULT_INTM_PER_ASSURED'),'N') = 'Y' THEN
          v_msg := 'Please set-up the default intermediary.';
          
          FOR i IN (SELECT DISTINCT b.line_cd
                               FROM giis_users a,
                                    giis_user_grp_line b,
                                    giis_user_grp_modules c,
                                    giis_line d
                              WHERE a.user_grp = b.user_grp
                                AND a.user_grp = c.user_grp
                                AND b.tran_cd = c.tran_cd
                                AND b.line_cd = d.line_cd
                                AND a.user_id = p_user_id
                                AND c.module_id = p_module_id
                                AND DECODE(p_module_id, 'GIISS006B', d.pack_pol_flag, 'N') = d.pack_pol_flag
                                AND DECODE(p_module_id, 'GIRIS005', b.iss_cd, v_iss_cd_ri) = v_iss_cd_ri
                    UNION
                    SELECT DISTINCT b.line_cd
                               FROM giis_users a,
                                    giis_user_line b,
                                    giis_user_modules c,
                                    giis_line d
                              WHERE a.user_id = b.userid
                                AND a.user_id = c.userid
                                AND b.tran_cd = c.tran_cd
                                AND b.line_cd = d.line_cd
                                AND a.user_id = p_user_id
                                AND c.module_id = p_module_id
                                AND DECODE(p_module_id, 'GIISS006B', d.pack_pol_flag, 'N') = d.pack_pol_flag
                                AND DECODE(p_module_id, 'GIRIS005', b.iss_cd, v_iss_cd_ri) = v_iss_cd_ri)
          LOOP
             /* benjo 03.07.2017 SR-5893 */
             FOR x IN (SELECT 1
                         FROM giis_assured_intm
                        WHERE assd_no = p_assd_no 
                          AND line_cd = i.line_cd)
             LOOP
                v_msg := 'SUCCESS';
             END LOOP;
          END LOOP;
      END IF;

      RETURN v_msg;
   END;
END Giis_Assured_Pkg;
/

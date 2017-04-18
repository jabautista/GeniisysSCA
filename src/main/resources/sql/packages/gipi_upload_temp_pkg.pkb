CREATE OR REPLACE PACKAGE BODY CPI.GIPI_UPLOAD_TEMP_PKG
AS
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.09.2010  
    **  Reference By     : (GIPIS196- View Uploaded Files Detail)   
    **  Description     : Uploaded files Detail 
    */    
  FUNCTION get_gipi_upload_temp
    RETURN gipi_upload_temp_tab PIPELINED IS
    v_temp gipi_upload_temp_type;
  BEGIN    
    FOR i IN (SELECT DISTINCT a.upload_no,         a.filename,         a.grouped_item_title,                           
                            a.sex,                DECODE(a.civil_status,  'M', 'Married', 'S', 'Single', 'L', 'Legally Separated', 'D', 'Divorced', 'W', 'Widow(er)', '') civil_status, 
                      TRUNC(a.date_of_birth)  date_of_birth,
                         a.age,                a.salary,            a.salary_grade,
                         a.amount_coverage,   a.remarks,               a.user_id,
                         TRUNC(a.last_update) last_update,       
                      TRUNC(a.upload_date) upload_date,    
                      a.control_cd,        a.control_type_cd,  a.upload_seq_no,
                      TRUNC(a.from_date) from_date,       
                      TRUNC(a.to_date) to_date
                   FROM gipi_upload_temp a, gipi_load_hist b
               WHERE a.upload_no = b.upload_no
                 AND b.par_id IS NULL
               ORDER BY control_cd,upload_seq_no)
    LOOP
      v_temp.upload_no                    := i.upload_no;
      v_temp.filename                    := i.filename;
      v_temp.grouped_item_title         := i.grouped_item_title;                       
      v_temp.sex                         := i.sex;               
      v_temp.civil_status                 := i.civil_status; 
      v_temp.date_of_birth                 := i.date_of_birth;                                                 
      v_temp.age                         := i.age;                              
      v_temp.salary                     := i.salary;                           
      v_temp.salary_grade                 := i.salary_grade;                           
      v_temp.amount_coverage             := i.amount_coverage;
      v_temp.remarks                     := i.remarks;        
      v_temp.user_id                     := i.user_id;       
      v_temp.last_update                 := i.last_update;              
      v_temp.upload_date                 := i.upload_date;
      v_temp.control_cd                 := i.control_cd;
      v_temp.control_type_cd              := i.control_type_cd;
      v_temp.upload_seq_no                := i.upload_seq_no;
      v_temp.from_date                    := i.from_date;
      v_temp.to_date                    := i.to_date;
      PIPE ROW(v_temp);
    END LOOP;            
    RETURN;    
  END;
  
     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.10.2010  
    **  Reference By     : (GIPIS195- Grouped Accident Uploading Module)    
    **  Description     : insert the uploaded data 
    */    
  PROCEDURE set_gipi_upload_temp(
              p_upload_no                        GIPI_UPLOAD_TEMP.upload_no%TYPE,
               p_filename                       GIPI_UPLOAD_TEMP.filename%TYPE,
               p_grouped_item_title           GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,                               
               p_sex                           GIPI_UPLOAD_TEMP.sex%TYPE,        
               p_civil_status                   GIPI_UPLOAD_TEMP.civil_status%TYPE,            
               p_date_of_birth                   GIPI_UPLOAD_TEMP.date_of_birth%TYPE,        
               p_age                           GIPI_UPLOAD_TEMP.age%TYPE,        
               p_salary                       GIPI_UPLOAD_TEMP.salary%TYPE,        
               p_salary_grade                   GIPI_UPLOAD_TEMP.salary_grade%TYPE,        
               p_amount_coverage               GIPI_UPLOAD_TEMP.amount_coverage%TYPE,        
               p_remarks                       GIPI_UPLOAD_TEMP.remarks%TYPE,        
               p_user_id                       GIPI_UPLOAD_TEMP.user_id%TYPE,        
            p_last_update                   GIPI_UPLOAD_TEMP.last_update%TYPE,        
               p_upload_date                   GIPI_UPLOAD_TEMP.upload_date%TYPE,        
               p_control_cd                   GIPI_UPLOAD_TEMP.control_cd%TYPE,        
               p_control_type_cd               GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
               p_upload_seq_no                   GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
               p_from_date                       GIPI_UPLOAD_TEMP.from_date%TYPE,
               p_to_date                       GIPI_UPLOAD_TEMP.to_date%TYPE
              )
        IS
    v_flag        BOOLEAN := TRUE;
    v_errflag     BOOLEAN := FALSE; 
  BEGIN
    
    FOR x IN (SELECT 'X'
                  FROM GIPI_UPLOAD_TEMP
                 WHERE FILENAME LIKE p_filename
                   AND CONTROL_CD LIKE p_control_cd
                   AND control_type_cd = p_control_type_cd
                   AND upload_no = p_upload_no) --marco - 04.29.2014 - added condition
    LOOP
      v_flag := FALSE;
      EXIT;
    END LOOP;
    
    FOR i IN (SELECT 'X'
                FROM GIPI_ERROR_LOG
               WHERE FILENAME LIKE p_filename
                 AND CONTROL_CD LIKE p_control_cd
                 AND control_type_cd = p_control_type_cd
                 AND upload_no = p_upload_no) --marco - 04.29.2014 - added condition
    LOOP
      v_errflag := TRUE;
    END LOOP;
    
    IF NOT v_flag THEN
       IF NOT v_errflag THEN
         INSERT INTO GIPI_ERROR_LOG
               (upload_no,                       filename,                      grouped_item_title,
                sex,                      civil_status,                  date_of_birth,
                age,                      salary,                      salary_grade,
                amount_coverage,          remarks,                      user_id,
                last_update,              control_cd,                  control_type_cd)
                --grouped_item_no)
         VALUES (p_upload_no,                p_filename,                  p_grouped_item_title,
                p_sex,                      p_civil_status,              p_date_of_birth,
                p_age,                      p_salary,                      p_salary_grade,
                p_amount_coverage,          p_remarks,                  p_user_id,
                SYSDATE,                    p_control_cd,                  p_control_type_cd);
                --p_grouped_item_no);
       END IF;    
       v_flag := TRUE; 
       v_errflag := FALSE;    
     ELSIF v_flag THEN     
    
      IF p_grouped_item_title IS NULL THEN
         raise_application_error(-20001, 'Geniisys Exception#I#Grouped Item title of the file is NULL.');
      END IF;
                     
        INSERT INTO GIPI_UPLOAD_TEMP
               (upload_no,                     filename,                   grouped_item_title,                           
                   sex,                       civil_status,               date_of_birth,
                   age,                       salary,                       salary_grade,    
                   amount_coverage,           remarks,                         user_id,
                last_update,               upload_date,                     control_cd,
                   control_type_cd,           upload_seq_no,               from_date,
                   to_date)
        VALUES (p_upload_no,               p_filename,                   p_grouped_item_title,                           
                   p_sex,                       p_civil_status,               p_date_of_birth,
                   p_age,                       p_salary,                       p_salary_grade,    
                   p_amount_coverage,           p_remarks,                   p_user_id,
                SYSDATE,                     SYSDATE,                         p_control_cd,
                   p_control_type_cd,           p_upload_seq_no,               p_from_date,
                   p_to_date);       
     END IF; 
  END;            
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.10.2010  
    **  Reference By     : (GIPIS195- Grouped Accident Uploading Module)    
    **  Description     : insert the uploaded data with perils 
    */    
  PROCEDURE set_gipi_upload_temp_perils(
              p_upload_no                        GIPI_UPLOAD_TEMP.upload_no%TYPE,
               p_filename                       GIPI_UPLOAD_TEMP.filename%TYPE,
               p_grouped_item_title           GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,                               
               p_sex                           GIPI_UPLOAD_TEMP.sex%TYPE,        
               p_civil_status                   GIPI_UPLOAD_TEMP.civil_status%TYPE,            
               p_date_of_birth                   GIPI_UPLOAD_TEMP.date_of_birth%TYPE,        
               p_age                           GIPI_UPLOAD_TEMP.age%TYPE,        
               p_salary                       GIPI_UPLOAD_TEMP.salary%TYPE,        
               p_salary_grade                   GIPI_UPLOAD_TEMP.salary_grade%TYPE,        
               p_amount_coverage               GIPI_UPLOAD_TEMP.amount_coverage%TYPE,        
               p_remarks                       GIPI_UPLOAD_TEMP.remarks%TYPE,        
               p_user_id                       GIPI_UPLOAD_TEMP.user_id%TYPE,        
            p_last_update                   GIPI_UPLOAD_TEMP.last_update%TYPE,        
               p_upload_date                   GIPI_UPLOAD_TEMP.upload_date%TYPE,        
               p_control_cd                   GIPI_UPLOAD_TEMP.control_cd%TYPE,        
               p_control_type_cd               GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
               p_upload_seq_no                   GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
               p_from_date                       GIPI_UPLOAD_TEMP.from_date%TYPE,
               p_to_date                       GIPI_UPLOAD_TEMP.to_date%TYPE
              )
        IS
    v_flag        BOOLEAN := TRUE;
    v_errflag     BOOLEAN := FALSE; 
  BEGIN
    
    FOR x IN (SELECT 'X'
                  FROM GIPI_UPLOAD_TEMP
                 WHERE FILENAME LIKE p_filename
                   AND CONTROL_CD LIKE p_control_cd
                   AND CONTROL_TYPE_CD = p_control_type_cd
                   AND upload_no = p_upload_no)
    LOOP
      v_flag := FALSE;
      EXIT;
    END LOOP;
    
    FOR i IN (SELECT 'X'
                FROM GIPI_ERROR_LOG
               WHERE FILENAME LIKE p_filename
                 AND CONTROL_CD LIKE p_control_cd
                 AND CONTROL_TYPE_CD = p_control_type_cd
                 AND upload_no = p_upload_no)  
    LOOP
      v_errflag := TRUE;
      EXIT;
    END LOOP;
    
    IF NOT v_flag THEN
       IF NOT v_errflag THEN
         INSERT INTO GIPI_ERROR_LOG
               (upload_no,                       filename,                      grouped_item_title,
                sex,                      civil_status,                  date_of_birth,
                age,                      salary,                      salary_grade,
                amount_coverage,          remarks,                      user_id,
                last_update,              control_cd,                  control_type_cd)
                --grouped_item_no)
         VALUES (p_upload_no,                p_filename,                  p_grouped_item_title,
                p_sex,                      p_civil_status,              p_date_of_birth,
                p_age,                      p_salary,                      p_salary_grade,
                p_amount_coverage,          p_remarks,                  p_user_id,
                SYSDATE,                    p_control_cd,                  p_control_type_cd);
                --p_grouped_item_no);
       END IF;    
      v_flag := TRUE; 
      v_errflag := FALSE;    
     ELSIF v_flag THEN      
      IF p_grouped_item_title IS NULL THEN
         raise_application_error(-20001, 'Geniisys Exception#I#Grouped Item title of the file is NULL.');
      END IF;
                     
        INSERT INTO GIPI_UPLOAD_TEMP
               (upload_no,                     filename,                   grouped_item_title,                           
                   sex,                       civil_status,               date_of_birth,
                   age,                       salary,                       salary_grade,    
                   amount_coverage,           remarks,                         user_id,
                last_update,               upload_date,                     control_cd,
                   control_type_cd,           upload_seq_no,               from_date,
                   to_date)
        VALUES (p_upload_no,               p_filename,                   p_grouped_item_title,                           
                   p_sex,                       p_civil_status,               p_date_of_birth,
                   p_age,                       p_salary,                       p_salary_grade,    
                   p_amount_coverage,           p_remarks,                   p_user_id,
                SYSDATE,                     SYSDATE,                         p_control_cd,
                   p_control_type_cd,           p_upload_seq_no,               p_from_date,
                   p_to_date);       
     END IF; 
  END;            
  
     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.10.2010  
    **  Reference By     : (GIPIS195- Grouped Accident Uploading Module)    
    **  Description     : validate if the file is already uploaded  
    */    
  FUNCTION Validate_Upload_File (p_filename        GIPI_UPLOAD_TEMP.filename%TYPE)
    RETURN VARCHAR2 IS
    v_exist     BOOLEAN := FALSE;
    v_msg        VARCHAR2(4000) := '';
  BEGIN 
    FOR a IN (SELECT 1 
                   FROM GIPI_UPLOAD_TEMP
               WHERE filename LIKE p_filename)
    LOOP
      v_exist := TRUE;
    END LOOP;
    
    IF v_exist THEN
      v_msg := 'This file has already been uploaded';
    END IF;
  RETURN v_msg;
  END;
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.10.2010  
    **  Reference By     : (GIPIS195- Grouped Accident Uploading Module)    
    **  Description     : get upload no  
    */    
  FUNCTION get_upload_no (p_filename        GIPI_UPLOAD_TEMP.filename%TYPE)
    RETURN VARCHAR2 IS
    v_exist         BOOLEAN := FALSE;
    v_upload_no        VARCHAR2(4000) := '';
  BEGIN 
    FOR a IN (SELECT upload_no 
                   FROM GIPI_UPLOAD_TEMP
               WHERE filename LIKE p_filename)
    LOOP    
      --marco - 05.08.2014 - check if the file has already been created to PAR
      FOR i IN(SELECT par_id
                 FROM GIPI_LOAD_HIST
                WHERE upload_no = a.upload_no)
      LOOP
         IF i.par_id IS NULL THEN
            v_exist := TRUE;
         ELSE
            v_exist := FALSE;
         END IF;
      END LOOP;
    END LOOP;
    
    IF v_exist THEN
       FOR x IN(SELECT upload_no 
                     FROM GIPI_UPLOAD_TEMP
                       WHERE FILENAME LIKE p_filename)
         LOOP
            v_upload_no := x.upload_no;
         END LOOP;
    ELSE 
       BEGIN  
         SELECT UPLOAD_SEQ_NO.NEXTVAL
             INTO v_upload_no
             FROM DUAL;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_upload_no := '';
         END;   
    END IF;
  RETURN v_upload_no;
  END;

     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.16.2010  
    **  Reference By     : (GIPIS195- Grouped Accident Uploading Module)    
    **  Description     : insert_values program unit  
    */    
  PROCEDURE insert_values (p_upload_no          NUMBER)
              IS
    status_width    NUMBER;
    status_width2   NUMBER;
    v_row           NUMBER;
    v_records       NUMBER;
    v_values        VARCHAR2 (500);
    v_columns       VARCHAR2 (500);
    v_stmnt         VARCHAR2 (1000);
    v_exists        VARCHAR2(1) := 'N';
  BEGIN
     FOR i IN(SELECT 1
                FROM GIPI_LOAD_HIST
               WHERE upload_no = p_upload_no)
     LOOP
         v_exists := 'Y';
         EXIT;
     END LOOP;
  
     FOR a IN (SELECT upload_no, filename, TRUNC (upload_date) upload_date,
                      COUNT (upload_no) cnt
                 FROM gipi_upload_temp
                WHERE upload_no = p_upload_no
             GROUP BY upload_no, filename, TRUNC (upload_date))
     LOOP
       /*v_columns := 'upload_no, filename, date_loaded, no_of_records';
       v_values  := 'VALUES('||''''||a.upload_no||''''||', '||
                                ''''||a.filename||''''||', '||
                                ''''||a.upload_date||''''||', '||
                                ''''||a.cnt||''''||')';
       v_stmnt   := 'INSERT INTO GIPI_LOAD_HIST(' || v_columns || ') ' || v_values;*/
       
       --marco - 04.29.2014 - added condition; updated when record is already uploaded
       IF v_exists = 'Y' THEN
         UPDATE GIPI_LOAD_HIST
            SET date_loaded = a.upload_date,
                no_of_records = a.cnt
          WHERE upload_no = a.upload_no;
       ELSE
         INSERT INTO GIPI_LOAD_HIST(upload_no,    filename,    date_loaded,    no_of_records)
         VALUES(a.upload_no,  a.filename,  a.upload_date,  a.cnt);
       END IF;
       
     END LOOP;
     --exec_immediate (v_stmnt);
  END;
  
    /*    Date        Author            Description
    *    ==========    ===============    ============================
    *    10.21.2011    mark jm            retrieve records on gipi_upload_temp based on given parameters (tablegrid version)
    */
    FUNCTION get_gipi_upload_temp_tg (p_upload_no IN gipi_upload_temp.upload_no%TYPE)
    RETURN gipi_upload_temp_tab PIPELINED
    IS
        v_temp gipi_upload_temp_type;
    BEGIN    
        FOR i IN (
            SELECT DISTINCT a.upload_no,         a.filename,         a.grouped_item_title,                           
                   a.sex,                DECODE(a.civil_status,  'M', 'Married', 'S', 'Single', 'L', 'Legally Separated', 'D', 'Divorced', 'W', 'Widow(er)', '') civil_status, 
                   TRUNC(a.date_of_birth)  date_of_birth,
                   a.age,                a.salary,            a.salary_grade,
                   a.amount_coverage,   a.remarks,               a.user_id,
                   TRUNC(a.last_update) last_update,       
                   TRUNC(a.upload_date) upload_date,    
                   a.control_cd CONTROL_CD,        a.control_type_cd,  a.upload_seq_no,
                   TRUNC(a.from_date) from_date,       
                   TRUNC(a.to_date) to_date
              FROM gipi_upload_temp a
             WHERE a.upload_no = p_upload_no               
           --ORDER BY TRUNC(control_cd), upload_seq_no
		   )
        LOOP
          v_temp.upload_no            := i.upload_no;
          v_temp.filename            := i.filename;
          v_temp.grouped_item_title    := i.grouped_item_title;                       
          v_temp.sex                := i.sex;               
          v_temp.civil_status        := i.civil_status; 
          v_temp.date_of_birth        := i.date_of_birth;                                                 
          v_temp.age                := i.age;                              
          v_temp.salary                := i.salary;                           
          v_temp.salary_grade        := i.salary_grade;                           
          v_temp.amount_coverage    := i.amount_coverage;
          v_temp.remarks            := i.remarks;        
          v_temp.user_id            := i.user_id;       
          v_temp.last_update        := i.last_update;              
          v_temp.upload_date        := i.upload_date;
          v_temp.control_cd            := i.control_cd;
          v_temp.control_type_cd    := i.control_type_cd;
          v_temp.upload_seq_no        := i.upload_seq_no;
          v_temp.from_date            := i.from_date;
          v_temp.to_date            := i.to_date;
          PIPE ROW(v_temp);
        END LOOP;            
        RETURN;    
    END get_gipi_upload_temp_tg;
    
	/*
    **  Created by       : Christian Santos  
    **  Date Created     : 04/29/2013 
    **  Reference By     : GIPIS065  
    */
    FUNCTION get_gipi_uploaded_enrollees (p_upload_no   gipi_upload_temp.upload_no%TYPE,
                                          p_par_id      gipi_wgrouped_items.PAR_ID%TYPE,
                                          p_item_no     gipi_wgrouped_items.ITEM_NO%TYPE)
    RETURN gipi_uploaded_enrollees_tab PIPELINED
    IS
        v_temp      gipi_uploaded_enrollees_type;
        v_ctr       number := 0;
        v_grp_no    gipi_wgrouped_items.GROUPED_ITEM_NO%type;
    BEGIN    
        FOR i IN (
            SELECT DISTINCT a.upload_no,         a.filename,         a.grouped_item_title,                           
                   a.sex, DECODE(a.civil_status,  'M', 'Married', 'S', 'Single', 'L', 'Legally Separated', 'D', 'Divorced', 'W', 'Widow(er)', '') civil_status_desc, 
                   a.civil_status, TRUNC(a.date_of_birth)  date_of_birth,
                   a.age,                a.salary,            a.salary_grade,
                   a.amount_coverage,   a.remarks,               a.user_id,
                   TRUNC(a.last_update) last_update,       
                   TRUNC(a.upload_date) upload_date,    
                   TRUNC(a.control_cd) CONTROL_CD,        a.control_type_cd,  a.upload_seq_no,
                   TRUNC(a.from_date) from_date,       
                   TRUNC(a.to_date) to_date
              FROM gipi_upload_temp a
             WHERE a.upload_no = p_upload_no               
           --ORDER BY TRUNC(control_cd), upload_seq_no
		   )
        LOOP
          v_temp.grouped_item_title     := i.grouped_item_title;                       
          v_temp.sex                    := i.sex;               
          v_temp.civil_status           := i.civil_status; 
          v_temp.civil_status_desc      := i.civil_status_desc;
          v_temp.date_of_birth          := i.date_of_birth;                                                 
          v_temp.age                    := i.age;                              
          v_temp.salary                 := i.salary;                           
          v_temp.salary_grade           := i.salary_grade;                           
          v_temp.amount_coverage        := i.amount_coverage;
          v_temp.remarks                := i.remarks;        
          v_temp.user_id                := i.user_id;       
          v_temp.last_update            := i.last_update;              
          v_temp.upload_date            := i.upload_date;
          v_temp.control_cd             := i.control_cd;
          v_temp.control_type_cd        := i.control_type_cd;
          --v_temp.upload_seq_no          := i.upload_seq_no;
          v_temp.from_date              := i.from_date;
          v_temp.to_date                := i.to_date;
    
          --autonumbering of grouped_item_no--
          
         SELECT MAX (grouped_item_no)
           INTO v_grp_no
           FROM gipi_wgrouped_items
          WHERE par_id = p_par_id 
            AND item_no = p_item_no;
          
          v_ctr := v_ctr + 1;
          v_temp.grouped_item_no := NVL(v_grp_no, 0) + v_ctr;
          
          BEGIN
            SELECT control_type_desc
              INTO v_temp.control_type_desc
              FROM GIIS_CONTROL_TYPE
             WHERE control_type_cd = i.control_type_cd;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_temp.control_type_desc := NULL;
          END; 
          PIPE ROW(v_temp);
        END LOOP;            
        RETURN;  
          
    END get_gipi_uploaded_enrollees;
    
   --marco - 04.30.2014
   FUNCTION get_upload_count(
      p_upload_no                GIPI_UPLOAD_TEMP.upload_no%TYPE
   )
     RETURN NUMBER
   IS
      v_count              NUMBER;
      v_err_count          NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT(1)
           INTO v_count
           FROM GIPI_UPLOAD_TEMP
          WHERE upload_no = p_upload_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_count := 0;
      END;
      
      BEGIN
         SELECT COUNT(1)
           INTO v_err_count
           FROM GIPI_ERROR_LOG;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_err_count := 0;
      END;
       
      RETURN v_count - v_err_count;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN 0;
   END;
   
END;
/



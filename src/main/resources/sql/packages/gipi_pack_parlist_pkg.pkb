CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Pack_Parlist_Pkg AS

  FUNCTION get_gipi_pack_parlist (p_pack_par_id            GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED IS
    
    v_pack           gipi_pack_parlist_type;
    
  BEGIN
    FOR i IN (
        SELECT a.pack_par_id, a.line_cd,      a.iss_cd,     a.par_yy,
               a.par_seq_no,  a.quote_seq_no, a.assd_no,     
               a.par_status,  a.underwriter,   a.par_type,   a.assign_sw,
               a.remarks,     a.quote_id,  
               a.line_cd
               || ' - '
               || a.iss_cd
               || ' - '
               || LTRIM (TO_CHAR (a.par_yy, '09'))
               || ' - '
               || LTRIM (TO_CHAR (a.par_seq_no, '099999'))
               || ' - '
               || LTRIM (TO_CHAR (a.quote_seq_no, '09')) par_no
               
          FROM GIPI_PACK_PARLIST a
         WHERE a.pack_par_id = p_pack_par_id)
    LOOP
        v_pack.pack_par_id       := i.pack_par_id;
        v_pack.line_cd          := i.line_cd;
        v_pack.iss_cd          := i.iss_cd;
        v_pack.par_yy          := i.par_yy;
        v_pack.par_seq_no      := i.par_seq_no;
        v_pack.quote_seq_no      := i.quote_seq_no;
        v_pack.assd_no          := i.assd_no;
        v_pack.par_status      := i.par_status;    
        v_pack.underwriter      := i.underwriter;
        v_pack.par_type       := i.par_type;
        v_pack.assign_sw      := i.assign_sw;
        v_pack.par_status     := i.par_status;
        v_pack.remarks        := i.remarks;
        v_pack.quote_id       := i.quote_id;
        v_pack.pack_par_no    := i.par_no;
        
        FOR assd IN(SELECT assd_name
                    FROM GIIS_ASSURED
                    WHERE assd_no = i.assd_no)
        LOOP
            v_pack.assd_name  := assd.assd_name;
        END LOOP;
        
        FOR line_name IN (SELECT line_name from GIIS_LINE where line_cd = v_pack.line_cd)
        LOOP
            v_pack.line_name := line_name.line_name;
        END LOOP;
      
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;         
  END get_gipi_pack_parlist;    

  --for GIRIS005A
FUNCTION get_gipi_pack_parlist (p_line_cd            GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd            GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_par_yy            GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no        GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_assd_no            GIPI_PACK_PARLIST.assd_no%TYPE,
                                  p_underwriter        GIPI_PACK_PARLIST.underwriter%TYPE,
                                  p_line_cd_ndb        GIPI_PACK_PARLIST.line_cd%TYPE, --container for :GIPI_PARLIST.line_cd in GIRIS005A
                                  p_iss_cd_ndb        GIPI_PACK_PARLIST.iss_cd%TYPE, --container for :GIPI_PARLIST.iss_cd in GIRIS005A
                                  p_module            VARCHAR2,
                                  p_user_id giis_users.user_id%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED IS
    
    v_pack           gipi_pack_parlist_type;
    
  BEGIN
    FOR i IN (
        SELECT a.line_cd,      a.iss_cd,     a.par_yy,       a.par_seq_no,  
               a.quote_seq_no, a.assd_no,    b.assd_name,  a.remarks,
               a.underwriter
          FROM GIPI_PACK_PARLIST a
                ,GIIS_ASSURED         b
         WHERE a.assd_no       = b.assd_no
           AND a.line_cd      = NVL(p_line_cd, a.line_cd)
           AND a.iss_cd       = NVL(p_iss_cd, a.iss_cd)
           AND a.par_yy       = NVL(p_par_yy, a.par_yy)
           AND a.par_seq_no   = NVL(p_par_seq_no, a.par_seq_no)
           AND a.quote_seq_no = NVL(p_quote_seq_no, a.quote_seq_no)
           AND a.assd_no      = NVL(p_assd_no, a.assd_no)
           AND a.underwriter  = NVL(p_underwriter, a.underwriter)
           AND check_user_per_line2(p_line_cd, p_iss_cd_ndb, p_module, p_user_id) = 1
           AND Check_User_Per_Iss_Cd2(p_line_cd_ndb, p_iss_cd, p_module, p_user_id) = 1
           )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.iss_cd          := i.iss_cd;
        v_pack.par_yy          := i.par_yy;
        v_pack.par_seq_no      := i.par_seq_no;
        v_pack.quote_seq_no      := i.quote_seq_no;
        v_pack.assd_no          := i.assd_no;
        v_pack.assd_name      := i.assd_name;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;         
  END get_gipi_pack_parlist;    
  
  
  --for GIPIS001A
  FUNCTION get_gipi_pack_parlist (p_line_cd            GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd            GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_par_yy            GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no        GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_assd_no            GIPI_PACK_PARLIST.assd_no%TYPE,
                                  p_underwriter        GIPI_PACK_PARLIST.underwriter%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED IS
    
    v_pack           gipi_pack_parlist_type;
    
  BEGIN
    FOR i IN (
        SELECT a.line_cd,      a.iss_cd,     a.par_yy,       a.par_seq_no,  
               a.quote_seq_no, a.assd_no,    a.remarks,       a.underwriter,
               a.pack_par_id,  a.par_status, a.assign_sw
          FROM GIPI_PACK_PARLIST a
         WHERE a.line_cd      = NVL(p_line_cd, a.line_cd)
           AND a.iss_cd       = NVL(p_iss_cd, a.iss_cd)
           AND a.par_yy       = NVL(p_par_yy, a.par_yy)
           AND a.par_seq_no   = NVL(p_par_seq_no, a.par_seq_no)
           AND a.quote_seq_no = NVL(p_quote_seq_no, a.quote_seq_no)
           AND a.assd_no      = NVL(p_assd_no, a.assd_no)
           AND a.underwriter  = NVL(p_underwriter, a.underwriter)
           )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.iss_cd          := i.iss_cd;
        v_pack.par_yy          := i.par_yy;
        v_pack.par_seq_no      := i.par_seq_no;
        v_pack.quote_seq_no      := i.quote_seq_no;
        v_pack.assd_no          := i.assd_no;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id      := i.pack_par_id;
        v_pack.par_status      := i.par_status;
        v_pack.assign_sw      := i.assign_sw;
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;         
  END get_gipi_pack_parlist;    
  
  --for GIPIS058A
  FUNCTION get_gipi_pack_parlist (p_line_cd        GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd            GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_par_yy            GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no        GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_underwriter        GIPI_PACK_PARLIST.underwriter%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED IS
    
    v_pack           gipi_pack_parlist_type;
    
  BEGIN
    FOR i IN (
        SELECT a.line_cd,      a.iss_cd,     a.par_yy,       a.par_seq_no,  
               a.quote_seq_no, a.assd_no,    a.remarks,       a.underwriter,
               a.pack_par_id,  a.par_status, a.assign_sw
          FROM GIPI_PACK_PARLIST a
         WHERE a.par_status   < 10 
           AND a.par_status   > 1 
           AND assign_sw       = 'Y' 
           AND par_type       = 'E' 
           AND underwriter       = USER 
           --AND SECURITY(:cg$ctrl.module) 
           AND a.line_cd      = NVL(p_line_cd, a.line_cd)
           AND a.iss_cd       = NVL(p_iss_cd, a.iss_cd)
           AND a.par_yy       = NVL(p_par_yy, a.par_yy)
           AND a.par_seq_no   = NVL(p_par_seq_no, a.par_seq_no)
           AND a.quote_seq_no = NVL(p_quote_seq_no, a.quote_seq_no)
           AND a.underwriter  = NVL(p_underwriter, a.underwriter)
           )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.iss_cd          := i.iss_cd;
        v_pack.par_yy          := i.par_yy;
        v_pack.par_seq_no      := i.par_seq_no;
        v_pack.quote_seq_no      := i.quote_seq_no;
        v_pack.assd_no          := i.assd_no;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id      := i.pack_par_id;
        v_pack.par_status      := i.par_status;
        v_pack.assign_sw      := i.assign_sw;
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;         
  END get_gipi_pack_parlist;
  
  PROCEDURE del_gipi_pack_parlist (p_par_id        GIPI_PACK_PARLIST.pack_par_id%TYPE) 
  IS
  
  BEGIN
  
         DELETE FROM GIPI_PACK_PARLIST
        WHERE pack_par_id = p_par_id;
        
    COMMIT;
  END del_gipi_pack_parlist;   
  
  PROCEDURE set_gipi_pack_parlist ( 
                                     p_line_cd            GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd            GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_par_yy            GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no        GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_assd_no            GIPI_PACK_PARLIST.assd_no%TYPE,
                                  p_remarks            GIPI_PACK_PARLIST.remarks%TYPE,
                                  p_underwriter        GIPI_PACK_PARLIST.underwriter%TYPE) IS
     
      var_par_id  GIPI_PACK_PARLIST.pack_par_id%TYPE;
     
  BEGIN

     SELECT GIPI_PACK_PARLIST_PAR_ID.NEXTVAL
       INTO var_par_id
         FROM DUAL;
  
      MERGE INTO GIPI_PACK_PARLIST
     USING DUAL ON ( pack_par_id = var_par_id )
       WHEN NOT MATCHED THEN
         INSERT ( line_cd,        iss_cd,        par_yy,     par_seq_no,
                  quote_seq_no,   assd_no,       remarks,      underwriter)
         VALUES    ( p_line_cd,      p_iss_cd,      p_par_yy,   p_par_seq_no,
                  p_quote_seq_no, p_assd_no,     p_remarks,  p_underwriter)
       WHEN MATCHED THEN
         UPDATE SET line_cd              = p_line_cd,
                    iss_cd              = p_iss_cd,
                    par_yy              = p_par_yy,
                    par_seq_no         = p_par_seq_no,
                    quote_seq_no     = p_quote_seq_no,
                    assd_no              = p_assd_no,
                    underwriter         = p_underwriter,
                    remarks             = p_remarks;         
         
    COMMIT;
  END set_gipi_pack_parlist;
  
  PROCEDURE set_gipi_pack_parlist ( 
                                     p_line_cd            GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd            GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_par_yy            GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no        GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_remarks            GIPI_PACK_PARLIST.remarks%TYPE) IS
     
  BEGIN

    UPDATE GIPI_PACK_PARLIST
       SET remarks            = p_remarks
     WHERE line_cd            = p_line_cd
       AND iss_cd            = p_iss_cd
       AND par_yy            = p_par_yy
       AND par_seq_no        = p_par_seq_no
       AND quote_seq_no        = p_quote_seq_no; 
         
    COMMIT;
  END set_gipi_pack_parlist;
  /*
      added by Cris 05.19.2010
    for gipis050A 
  */
  PROCEDURE save_pack_par(p_gipi_pack_par IN GIPI_PACK_PARLIST%ROWTYPE) IS
       pack_par                              GIPI_PACK_PARLIST%ROWTYPE;
       v_assign_sw                       VARCHAR2(1);
       v_raise_no_data_found             VARCHAR2(30);
         v_cgte$other_exceptions              VARCHAR2(30);
       v_par_id                         NUMBER;
  BEGIN
    pack_par := p_gipi_pack_par;

    v_assign_sw := Giis_Parameters_Pkg.V('AUTOMATIC_PAR_ASSIGNMENT_FLAG');
  
    IF v_assign_sw = 'Y' THEN
      pack_par.assign_sw  := 'Y';
      pack_par.par_status := 2;  
    ELSE
      pack_par.assign_sw  := 'N';
      pack_par.par_status := 1;       
    END IF;
    
    IF (Giis_Parameters_Pkg.check_param_by_iss_cd(pack_par.iss_cd) = 'Y') THEN
      pack_par.assign_sw := 'Y';
      pack_par.par_status := '2';
    END IF;

  /*  BEGIN
      check_unique_par(
        par.QUOTE_SEQ_NO    
       ,par.PAR_SEQ_NO      
       ,par.PAR_YY          
       ,par.ISS_CD        
       ,par.LINE_CD         
       ,TRUE              
       ,v_RAISE_NO_DATA_FOUND
       ,v_CGTE$OTHER_EXCEPTIONS);  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
      WHEN OTHERS THEN
        NULL;--CGTE$OTHER_EXCEPTIONS;
    END;*/

    BEGIN
      v_assign_sw := Giis_Parameters_Pkg.V('AUTOMATIC_PAR_ASSIGNMENT_FLAG');
      IF v_assign_sw = 'Y' THEN
        pack_par.assign_sw  := 'Y';
        pack_par.par_status := 2;  
      ELSE
        pack_par.assign_sw  := 'N';
        pack_par.par_status := 1;       
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        pack_par.assign_sw  := 'N';
        pack_par.par_status := 1; 
    END; 
                
    Gipi_Pack_Parlist_Pkg.save_pack_parlist(pack_par);
      
                
    FOR A IN ( 
     SELECT PAR_SEQ_NO
       FROM GIPI_pack_PARLIST
      WHERE pack_par_id  = pack_par.pack_par_id) 
    LOOP
      pack_par.PAR_SEQ_NO := a.par_seq_no;
      EXIT;
    END LOOP;

    GIPI_PACK_PARHIST_PKG.check_pack_parhist(pack_par.PACK_PAR_ID, pack_par.UNDERWRITER);    
    
  END save_pack_par;
  
  PROCEDURE save_pack_parlist(p_gipi_pack_par IN GIPI_PACK_PARLIST%ROWTYPE)
    IS
    pack_par                 GIPI_PACK_PARLIST%ROWTYPE;
  BEGIN
    pack_par := p_gipi_pack_par;
    MERGE INTO GIPI_PACK_PARLIST
      USING DUAL ON ( pack_par_id = pack_par.pack_par_id)
           WHEN NOT MATCHED THEN
          INSERT( pack_par_id,           line_cd,      iss_cd,          par_yy, 
                     par_seq_no,            quote_seq_no, assd_no,         underwriter,
                  par_status,            par_type,     assign_sw,       remarks , quote_id)
          VALUES( pack_par.pack_par_id,       pack_par.line_cd,      pack_par.iss_cd,      pack_par.par_yy, 
                     pack_par.par_seq_no,        pack_par.quote_seq_no, pack_par.assd_no,     pack_par.underwriter, 
                  pack_par.par_status,         pack_par.par_type,     pack_par.assign_sw,   pack_par.remarks , pack_par.quote_id)
        WHEN MATCHED THEN
          UPDATE SET 
               line_cd = pack_par.line_cd,
             iss_cd     = pack_par.iss_cd,
             par_yy     = pack_par.par_yy,
             quote_seq_no = pack_par.quote_seq_no,
             assd_no     = pack_par.assd_no,
             underwriter = pack_par.underwriter,
             par_status     = pack_par.par_status,
             par_type     = pack_par.par_type,
             quote_id     = pack_par.quote_id,      
             assign_sw     = pack_par.assign_sw,
             remarks     = pack_par.remarks;
    --COMMIT;
  END save_pack_parlist;    
  
  PROCEDURE save_pack_parlist_from_endt (
        p_par_id         IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
        p_par_type        IN GIPI_PACK_PARLIST.par_type%TYPE,
        p_par_status    IN GIPI_PACK_PARLIST.par_status%TYPE,
        p_line_cd        IN GIPI_PACK_PARLIST.line_cd%TYPE,
        p_iss_cd        IN GIPI_PACK_PARLIST.iss_cd%TYPE,
        p_par_yy        IN GIPI_PACK_PARLIST.par_yy%TYPE,
        p_par_seq_no    IN GIPI_PACK_PARLIST.par_seq_no%TYPE,
        p_quote_seq_no    IN GIPI_PACK_PARLIST.quote_seq_no%TYPE,
        p_assd_no        IN GIPI_PACK_PARLIST.assd_no%TYPE,
        p_address1        IN GIPI_PACK_PARLIST.address1%TYPE,
        p_address2        IN GIPI_PACK_PARLIST.address2%TYPE,
        p_address3        IN GIPI_PACK_PARLIST.address3%TYPE)
    IS
        /*
        **  Created by        : Emman
        **  Date Created     : 11.26.2010
        **  Reference By     : (GIPIS031A - Package Endt Basic Information)
        **  Description     : This procedures inserts/updates record in GIPI_PACK_PARLIST table 
        **                    : based on the given parameters
        */
    BEGIN      
        MERGE INTO GIPI_PACK_PARLIST
        USING DUAL
        ON (pack_par_id = p_par_id)
        WHEN NOT MATCHED THEN
            INSERT (
                pack_par_id,     line_cd,         iss_cd,     par_yy, 
                par_seq_no, quote_seq_no,     assd_no,    par_status,
                par_type,     address1,         address2,     address3)
            VALUES (
                p_par_id,         p_line_cd,        p_iss_cd,    p_par_yy, 
                p_par_seq_no,     p_quote_seq_no,    p_assd_no,    p_par_status,
                p_par_type,     p_address1,        p_address2,    p_address3)
        WHEN MATCHED THEN
            UPDATE
               SET line_cd = p_line_cd,
                   iss_cd = p_iss_cd,
                   par_yy = p_par_yy,
                   par_seq_no = p_par_seq_no,
                   quote_seq_no = p_quote_seq_no,
                   assd_no = p_assd_no,
                   par_status = p_par_status,
                   par_type = p_par_type,
                   address1 = p_address1,
                   address2 = p_address2,
                   address3 = p_address3;      
   END save_pack_parlist_from_endt;
  
   
  PROCEDURE update_status_from_quote(p_quote_id       GIPI_PACK_PARLIST.quote_id%TYPE
                                      ,p_par_status    GIPI_PACK_PARLIST.par_status%TYPE)
   IS
    BEGIN
     UPDATE GIPI_PACK_PARLIST
       SET PAR_STATUS = p_par_status
     WHERE QUOTE_ID = p_quote_id;
    END update_status_from_quote;
    

  FUNCTION check_par_quote(p_pack_par_id             GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2 IS
    
    with_quote       GIPI_QUOTE.QUOTE_ID%TYPE;
    with_info        GIPI_POLBASIC.par_id%TYPE;
    par_quote_stat     VARCHAR2(1) := NULL;

  BEGIN
      -- FOR WQ IN(
       SELECT a.quote_id
         INTO with_quote
         FROM GIPI_PACK_PARLIST a, GIPI_PACK_QUOTE b
        WHERE a.quote_id = b.pack_quote_id 
          AND pack_par_id = p_pack_par_id;
        --) LOOP
       IF with_quote IS NOT NULL THEN
          par_quote_stat := 'Q';  
       ELSE    
         SELECT par_id
           INTO with_info
           FROM GIPI_POLBASIC
          WHERE par_id = p_pack_par_id;
         IF with_info IS NOT NULL THEN
             par_quote_stat := 'I';    
         END IF;
       END IF;
     RETURN par_quote_stat;
    -- END LOOP;
  END;
    
/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
  
  PROCEDURE create_parlist_wpack (p_pack_quote_id   NUMBER, 
                                    p_line_cd         giis_line.line_cd%TYPE,
                                  p_pack_par_id     NUMBER,
                                  p_iss_cd            gipi_parlist.iss_cd%TYPE,
                                  p_assd_no            gipi_parlist.assd_no%TYPE) 
  IS
    /*
    ** This package procedure will insert records into gipi_wpack_line_subline
    ** and gipi_parlist.
    */
    v_line_cd           VARCHAR2(10);
    v_subline_cd          VARCHAR2(20);
    v_remarks           VARCHAR2(4000);
    v_par_id            NUMBER(20);
    v_quote_id          NUMBER;
    v_assd_no              NUMBER;
    
    
    BEGIN
             
      FOR x IN (SELECT quote_id,line_cd, subline_cd,remarks,assd_no
                  FROM gipi_quote
                 WHERE pack_quote_id = p_pack_quote_id)
      LOOP
        v_quote_id     := x.quote_id;
        v_line_cd      := x.line_cd;
        v_subline_cd   := x.subline_cd;
        v_remarks      := x.remarks;
        --v_assd_no     := x.assd_no;
              
              
        SELECT  PARLIST_PAR_ID_S.NEXTVAL
          INTO  v_par_id
          FROM  SYS.DUAL;
              
        INSERT INTO gipi_wpack_line_subline (par_id, pack_line_cd, pack_subline_cd,
                                             line_cd, remarks, item_tag,pack_par_id)
                                      VALUES(v_par_id,v_line_cd, v_subline_cd,
                                             p_line_cd, v_remarks, NULL,p_pack_par_id);
                      
        INSERT INTO gipi_parlist (par_id, line_cd,iss_cd,par_yy,par_type,assign_sw,
                                par_status,quote_seq_no,pack_par_id,quote_id,assd_no)
                        VALUES (v_par_id,v_line_cd,p_ISS_CD,to_char(SYSDATE,'YY'),'P',
                 'Y',2,0,p_pack_par_id,v_quote_id,p_assd_no);
      
      END LOOP;
    END;
    
    
    
    PROCEDURE create_pack_wpolbas (p_pack_quote_id   NUMBER,
                                   p_pack_par_id        NUMBER,
                                   p_assd_no            NUMBER,
                                   p_line_cd         giis_line.line_cd%TYPE,
                                   p_iss_cd          gipi_parlist.iss_cd%TYPE,
                                   p_issue_date      gipi_wpolbas.issue_date%TYPE,
                                   p_user            gipi_pack_wpolbas.user_id%TYPE,
                                   p_booking_mth     gipi_wpolbas.booking_mth%TYPE,
                                   p_booking_yr      gipi_wpolbas.booking_year%TYPE) 
    
    /* This procedure will insert records into
    ** gipi_wpolbas and gipi_pack_wpolbas
    */
    IS
      v_line_cd                gipi_wpolbas.line_cd%TYPE;
      v_iss_cd                 gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd             gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy                 gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE;
      v_incept_date             gipi_wpolbas.incept_date%TYPE;
      v_expiry_date             gipi_wpolbas.expiry_date%TYPE;
      v_eff_date                 gipi_wpolbas.eff_date%TYPE;
      v_issue_date             gipi_wpolbas.issue_date%TYPE;
      v_assd_no                 gipi_wpolbas.assd_no%TYPE;
      v_designation             gipi_wpolbas.designation%TYPE;
      v_address1                 gipi_wpolbas.address1%TYPE;
      v_address2                 gipi_wpolbas.address2%TYPE;
      v_address3                 gipi_wpolbas.address3%TYPE;
      v_tsi_amt                 gipi_wpolbas.tsi_amt%TYPE;
      v_prem_amt                 gipi_wpolbas.prem_amt%TYPE;
      v_ann_tsi_amt             gipi_wpolbas.ann_tsi_amt%TYPE;
      v_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE;
      v_user_id                 gipi_wpolbas.user_id%TYPE;
      v_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE;  
      v_prorate_flag            gipi_wpolbas.prorate_flag%TYPE;
      v_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE;
      v_comp_sw                gipi_wpolbas.comp_sw%TYPE;
      v_booking_mth            gipi_wpolbas.booking_mth%TYPE;
      v_booking_yr             gipi_wpolbas.booking_year%TYPE;
      v_prod_take_up           giac_parameters.param_value_n%type;
      v_later_date             gipi_wpolbas.issue_date%TYPE;
      v_par_id                  NUMBER;
      v_label_tag              gipi_wpolbas.label_tag%TYPE; -- Added by Jerome 08.26.2016
      v_account_sw             gipi_pack_quote.account_sw%TYPE; -- Added by Jerome 08.26.2016
    
      
      CURSOR cur_b IS SELECT SUBLINE_CD,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(print_tag,'N'),
                             incept_date,expiry_date, address1, address2, address3, prorate_flag,
                             short_rt_percent, comp_sw, ann_prem_amt, ann_tsi_amt, account_sw --account_sw Added by Jerome 08.26.2016
                        FROM gipi_pack_quote 
                       WHERE pack_quote_id = p_pack_quote_id;
    
      CURSOR cur_a IS SELECT par_id, quote_id
                        FROM gipi_parlist
                       WHERE pack_par_id = p_pack_par_id;       
      
    BEGIN
    
      OPEN CUR_B;
     FETCH CUR_B 
      INTO v_subline_cd,
           v_tsi_amt,
           v_prem_amt,
           v_quotation_printed_sw,
           v_incept_date,
           v_expiry_date,
           v_address1,
           v_address2, 
           v_address3, 
           v_prorate_flag, 
           v_short_rt_percent, 
           v_comp_sw, 
           v_ann_prem_amt, 
           v_ann_tsi_amt,
           v_account_sw; -- Added by Jerome 08.26.2016
     CLOSE CUR_B; 
     
      FOR A IN (SELECT designation
                  FROM giis_assured
                  WHERE assd_no = p_assd_no) 
      LOOP
        v_designation := A.DESIGNATION;
        EXIT;
      END LOOP;
     
      v_line_cd      := p_line_cd;
      v_iss_cd       := p_iss_cd;
      v_issue_date   := p_issue_date;
      v_booking_mth  := p_booking_mth;
      v_booking_yr   := p_booking_yr;
      
      
      IF v_account_sw = 2 THEN -- Added by Jerome 08.26.2016
         v_label_tag := 'Y';
      ELSE
         v_label_tag := 'N';
      END IF;
    
      INSERT INTO gipi_pack_wpolbas
             (pack_par_id,line_cd,subline_cd,iss_cd, issue_yy, pol_seq_no,        
              endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
              incept_date, expiry_date, eff_date, issue_date,
              pol_flag, foreign_acc_sw, assd_no, designation,
              address1, address2, address3, mortg_name,
              tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,   
              invoice_sw, pool_pol_no, user_id, quotation_printed_sw,
              covernote_printed_sw, orig_policy_id, endt_expiry_date,  
              no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
              short_rt_percent, prov_prem_tag, type_cd, acct_of_cd,   
              prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
              prem_warr_tag,ref_pol_no,ref_open_pol_no,reg_policy_sw,co_insurance_sw,
              discount_sw,fleet_print_tag,incept_tag,comp_sw,booking_mth,
              endt_expiry_tag,booking_year, label_tag) 
      VALUES (p_pack_par_id,v_line_cd,v_subline_cd,v_iss_cd,
              TO_NUMBER(TO_CHAR(SYSDATE,'YY')), v_pol_seq_no,NULL,0, 
              0,0,NULL,v_incept_date,v_expiry_date,v_incept_date,
              v_issue_date,1, 'N', p_assd_no, v_designation,
              v_address1, v_address2, v_address3, NULL,v_tsi_amt, v_prem_amt, 
              v_ann_tsi_amt, v_ann_prem_amt,'N', NULL,p_user,
              v_quotation_printed_sw,'N',NULL,
              NULL,NULL,NULL, 'N',
              v_prorate_flag,v_short_rt_percent,'N',NULL,NULL,   
              NULL,'N','Y','N','N',
              NULL,NULL,'Y',1,
              'N','N','N',v_comp_sw,v_booking_mth,
              NULL,v_booking_yr, v_label_tag); 
           
      FOR d IN cur_a
      LOOP
        FOR x in (SELECT line_cd, SUBLINE_CD,NVL(a.tsi_amt,0) tsi_amt,NVL(a.prem_amt,0) prem_amt,NVL(a.print_tag,'N') print_tag,
                         a.incept_date,a.expiry_date, a.address1, a.address2, a.address3, a.prorate_flag,
                         a.short_rt_percent, a.comp_sw, a.ann_prem_amt, a.ann_tsi_amt, a.account_sw
                    FROM gipi_quote a
                   WHERE 1=1
                     AND a.quote_id = d.quote_id
                     AND a.pack_quote_id = p_pack_quote_id)
        LOOP
      
            v_line_cd                 := x.line_cd;
            v_subline_cd           := x.subline_cd;
            v_tsi_amt              := x.tsi_amt;
            v_prem_amt             := x.prem_amt;
            v_quotation_printed_sw := x.print_tag;
            v_incept_date          := x.incept_date;
            v_expiry_date          := x.expiry_date;
            v_address1              := x.address1;
            v_address2              := x.address2;
            v_address3              := x.address3;
            v_prorate_flag         := x.prorate_flag;
            v_short_rt_percent     := x.short_rt_percent;
            v_comp_sw              := x.comp_sw;
            v_ann_prem_amt         := x.ann_prem_Amt;
            v_ann_tsi_amt             := x.ann_Tsi_amt;
            v_par_id                  := d.par_id;
            v_account_sw           := x.account_sw;
            
            IF v_account_sw = 2 THEN -- Added by Jerome 08.26.2016
               v_label_tag := 'Y';
            ELSE
               v_label_tag := 'N';
            END IF;
    
        INSERT INTO gipi_wpolbas
               (par_id,line_cd,subline_cd,iss_cd, issue_yy, pol_seq_no,        
                endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
                incept_date, expiry_date, eff_date, issue_date,
                pol_flag, foreign_acc_sw, assd_no, designation,
                address1, address2, address3, mortg_name,
                tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,   
                invoice_sw, pool_pol_no, user_id, quotation_printed_sw,
                covernote_printed_sw, orig_policy_id, endt_expiry_date,  
                no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
                short_rt_percent, prov_prem_tag, type_cd, acct_of_cd,   
                prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
                prem_warr_tag,ref_pol_no,ref_open_pol_no,reg_policy_sw,co_insurance_sw,
                discount_sw,fleet_print_tag,incept_tag,comp_sw,booking_mth,
                endt_expiry_tag,booking_year,pack_par_id, label_tag) 
        VALUES (v_par_id,v_line_cd,v_subline_cd,v_iss_cd,
                TO_NUMBER(TO_CHAR(SYSDATE,'YY')), v_pol_seq_no,NULL,0, 
                0,0,NULL,v_incept_date,v_expiry_date,v_incept_date,
                v_issue_date,1, 'N', p_assd_no, v_designation,
                v_address1, v_address2, v_address3, NULL,v_tsi_amt, v_prem_amt, 
                v_ann_tsi_amt, v_ann_prem_amt,'N', NULL,p_user,
                v_quotation_printed_sw,'N',NULL,
                NULL,NULL,NULL, 'N',
                v_prorate_flag,v_short_rt_percent,'N',NULL,NULL,   
                NULL,'N','Y','N','N',
                NULL,NULL,'Y',1,
                'N','N','N',v_comp_sw,v_booking_mth,
                NULL,v_booking_yr,p_pack_par_id,v_label_tag);
      
        END LOOP;   
      END LOOP;   
       
      UPDATE GIPI_PACK_PARLIST
         SET PAR_STATUS = 3
       WHERE PACK_PAR_ID = p_pack_par_id;
     
      UPDATE GIPI_PARLIST
         SET PAR_STATUS = 3
       WHERE PACK_PAR_ID = p_pack_par_id;
       
    END;
    
    
            
    PROCEDURE create_item_info (p_pack_par_id NUMBER, p_pack_quote_id NUMBER) IS
        /* This procedure will check the lines included in a package quotation and
        ** then copy records from quotation tables to par tables depending on the 
        ** lines.
        */
        with_mc          VARCHAR2(1);
        with_av      VARCHAR2(1);
        with_mh          VARCHAR2(1);  
        with_mn          VARCHAR2(1);
        with_ca          VARCHAR2(1);
        with_ac          VARCHAR2(1);
        with_en          VARCHAR2(1);
        with_fi          VARCHAR2(1);
        v_line_cd   giis_line.line_cd%TYPE;
    
    
        CURSOR mc IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_MC');
        
        CURSOR av IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_AV');
          
        CURSOR mh IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_MH');
          
        CURSOR mn IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_MN');
          
        CURSOR ca IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_CA');
          
        CURSOR ac IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_AC');
          
        CURSOR en IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_EN');
          
        CURSOR fi IS
          SELECT par_id, quote_id
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id
             AND line_Cd = giisp.v('LINE_CODE_FI');    
        
            
    BEGIN
    
      FOR x IN (SELECT quote_id,line_cd, subline_cd,remarks,assd_no
                  FROM gipi_quote
                 WHERE pack_quote_id = p_pack_quote_id)
      LOOP
        v_line_cd := x.line_cd;
        IF v_line_cd = giisp.v('LINE_CODE_MC') THEN
           with_mc := 'Y';
        ELSIF v_line_cd = giisp.v('LINE_CODE_AV') THEN   
          with_av := 'Y';     
        ELSIF v_line_cd = giisp.v('LINE_CODE_MH') THEN
          with_mh := 'Y';         
        ELSIF v_line_cd = giisp.v('LINE_CODE_MN') THEN
          with_mn := 'Y';         
        ELSIF v_line_cd = giisp.v('LINE_CODE_CA') THEN
          with_ca := 'Y';         
        ELSIF v_line_cd = giisp.v('LINE_CODE_AC') THEN
          with_ac := 'Y';         
        ELSIF v_line_cd = giisp.v('LINE_CODE_EN') THEN
          with_en := 'Y';
        ELSIF v_line_cd = giisp.v('LINE_CODE_FI') THEN
          with_fi := 'Y';
        END IF;
      END LOOP;
      
    IF with_mc = 'Y' THEN
    /* This will copy records from gipi_quote_item_mc
    ** to gipi_wvehicle during creation of PAR from a package
    ** quotation.
    */ 
      FOR parlist_rec IN mc 
      LOOP
        FOR v IN (SELECT item_no,          plate_no,                  motor_no,
                         serial_no,        subline_type_cd,        mot_type,
                         coc_yy,           coc_seq_no,               coc_type,
                         repair_lim,       color,                     model_year,
                         make,             est_value,               towing,
                         assignee,         no_of_pass,               tariff_zone,
                         coc_issue_date,   mv_file_no,               acquired_from,
                         ctv_tag,          type_of_body_cd,        unladen_wt,
                         make_cd,          series_cd,               basic_color_cd,
                         color_cd,         origin,                 destination,
                            coc_atcn,         car_company_cd,            coc_serial_no,
                            subline_cd
                    FROM gipi_quote_item_mc
                   WHERE quote_id = parlist_rec.quote_id)
        LOOP
        INSERT INTO GIPI_WVEHICLE (par_id,         item_no,       subline_cd,         motor_no,
                                   plate_no,       serial_no,     subline_type_cd,    mot_type,
                                   coc_yy,         coc_seq_no,    coc_type,           repair_lim,
                                   color,          model_year,    make,               est_value,
                                   towing,         assignee,      no_of_pass,         tariff_zone,
                                   coc_issue_date, mv_file_no,    acquired_from,      ctv_tag,
                                   type_of_body_cd,unladen_wt,    make_cd,            series_cd,
                                   basic_color_cd, color_cd,      origin,             destination,
                                   coc_atcn,       car_company_cd, coc_serial_no)
                           VALUES (parlist_rec.par_id,    v.item_no,        v.subline_cd,       NVL(v.motor_no,'0'),
                                   v.plate_no,            v.serial_no,      v.subline_type_cd,  v.mot_type,
                                   v.coc_yy,              v.coc_seq_no,     v.coc_type,         v.repair_lim,
                                   v.color,               v.model_year,     v.make,             v.est_value,
                                   v.towing,              v.assignee,       v.no_of_pass,       v.tariff_zone,
                                   v.coc_issue_date,      v.mv_file_no,     v.acquired_from,    v.ctv_tag,
                                   v.type_of_body_cd,     v.unladen_wt,     v.make_cd,          v.series_cd,
                                   v.basic_color_cd,      v.color_cd,       v.origin,           v.destination,
                                   v.coc_atcn,            v.car_company_cd, v.coc_serial_no);
        END LOOP;
    
      END LOOP;
    
    END IF;  -- end of with_mc
    
    
    IF with_av = 'Y' THEN
    /* This will copy records from gipi_quote_av_item 
    ** to gipi_waviation_item during creation of PAR from a package
    ** quotation. 
    */
      FOR parlist_rec IN av 
        LOOP  
          FOR rec IN (SELECT item_no, vessel_cd, total_fly_time, qualification, purpose, geog_limit,
                             deduct_text, rec_flag, fixed_wing, rotor, prev_util_hrs, est_util_hrs
                        FROM gipi_quote_av_item
                       WHERE quote_id = parlist_rec.quote_id)
          LOOP
            INSERT INTO GIPI_WAVIATION_ITEM (par_id,item_no,vessel_cd, total_fly_time, qualification,
                                             purpose, geog_limit, deduct_text, rec_flag, fixed_wing, 
                                             rotor, prev_util_hrs, est_util_hrs)
                 VALUES (parlist_rec.par_id,rec.item_no,rec.vessel_cd, rec.total_fly_time, rec.qualification,
                        rec.purpose, rec.geog_limit, rec.deduct_text, rec.rec_flag, rec.fixed_wing, rec.rotor,
                        rec.prev_util_hrs, rec.est_util_hrs);
          END LOOP;
    
        END LOOP; 
    END IF; -- end of with_av    
    
    
       
    IF with_mh = 'Y' THEN
    
      FOR parlist_rec IN mh 
        LOOP 
          FOR rec IN (SELECT item_no, vessel_cd, geog_limit, rec_flag, deduct_text,
                             dry_date, dry_place
                        FROM gipi_quote_mh_item
                       WHERE quote_id = parlist_rec.quote_id)
          LOOP
           INSERT INTO gipi_witem_ves(par_id, item_no, vessel_cd, geog_limit, rec_flag, deduct_text,
                                      dry_date, dry_place)
                VALUES (parlist_rec.par_id, rec.item_no, rec.vessel_cd, rec.geog_limit, rec.rec_flag,
                        rec.deduct_text, rec.dry_date, rec.dry_place);
          END LOOP;
     
        END LOOP;
    END IF; -- end of with_mh        
       
    IF with_mn = 'Y' THEN
    /* This will copy recorsd from gipi_quote_cargo to gipi_wcargo.
    ** The column rec_flag in gipi_wcargo is hardcoded to 'A' since
    ** it cannot be null. In the marketing modules, the column rec_flag
    ** in gipi_quote_cargo is not populated.
    */
      FOR parlist_rec IN mn 
        LOOP
        FOR rec IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                           voyage_no, bl_awb, origin, destn, etd, eta,
                           cargo_type, pack_method, tranship_origin,
                           tranship_destination, lc_no, print_tag 
                      FROM gipi_quote_cargo
                     WHERE quote_id = parlist_rec.quote_id)
        LOOP
         INSERT INTO gipi_wcargo (par_id, item_no, vessel_cd, geog_cd, cargo_class_cd,
                                  voyage_no, bl_awb, origin, destn, etd, eta,
                                  cargo_type, pack_method, tranship_origin, 
                                  tranship_destination, lc_no, print_tag,rec_Flag)
              VALUES (parlist_rec.par_id, rec.item_no, rec.vessel_cd, rec.geog_cd, rec.cargo_class_cd,
                      rec.voyage_no, rec.bl_awb, rec.origin, rec.destn, rec.etd, rec.eta,
                      rec.cargo_type, rec.pack_method, rec.tranship_origin, rec.tranship_destination,
                      rec.lc_no, rec.print_tag,'A'); 
        END LOOP;
    
      END LOOP;
    END IF; -- end of with_mn         
       
    IF with_ca = 'Y' THEN
    
      FOR parlist_rec IN ca 
      LOOP
        FOR rec IN (SELECT item_no, capacity_cd, conveyance_info, interest_on_premises, limit_of_liability,
                           location, property_no, property_no_type, section_line_cd, section_or_hazard_cd, 
                           section_or_hazard_info, section_subline_cd
                      FROM gipi_quote_ca_item
                     WHERE quote_id = parlist_rec.quote_id)
        LOOP
         INSERT INTO gipi_wcasualty_item (par_id, item_no, capacity_cd, conveyance_info, interest_on_premises,
                                          limit_of_liability, location, property_no, property_no_type, 
                                          section_line_cd, section_or_hazard_cd, section_or_hazard_info,
                                          section_subline_cd)
              VALUES (parlist_rec.par_id, rec.item_no, rec.capacity_cd, rec.conveyance_info, rec.interest_on_premises,
                      rec.limit_of_liability, rec.location, rec.property_no, rec.property_no_type, 
                      rec.section_line_cd, rec.section_or_hazard_cd, rec.section_or_hazard_info, rec.section_subline_cd);
        END LOOP;
    
      END LOOP;
    END IF; -- end of with_ca
             
    IF with_ac = 'Y' THEN
      FOR parlist_rec IN ac 
      LOOP 
        FOR rec IN (SELECT item_no, destination, monthly_salary, no_of_persons, 
                           position_cd, salary_grade, age, civil_status, date_of_birth, height,
                           sex, weight
                      FROM gipi_quote_ac_item
                     WHERE quote_id = parlist_rec.quote_id)
        LOOP
         INSERT INTO gipi_waccident_item (par_id, item_no, destination, monthly_salary, no_of_persons,
                                          position_cd, salary_grade, age, civil_status, date_of_birth, height,
                                          sex, weight)
              VALUES (parlist_rec.par_id, rec.item_no, rec.destination, rec.monthly_salary,
                      rec.no_of_persons, rec.position_cd, rec.salary_grade, rec.age, rec.civil_status, 
                      rec.date_of_birth, rec.height, rec.sex, rec.weight);
        END LOOP;
    
      END LOOP;         
    END IF; -- end of with_ac  
          
    IF with_en = 'Y' THEN
    
    FOR parlist_rec IN en 
      LOOP 
        FOR rec IN (SELECT construct_end_date, construct_start_date, contract_proj_buss_title,
                           engg_basic_infonum, maintain_end_date, maintain_start_date, mbi_policy_no,
                           site_location, testing_end_date, testing_start_date, time_excess, weeks_test
                      FROM gipi_quote_en_item
                     WHERE quote_id = parlist_rec.quote_id)
        LOOP
         INSERT INTO gipi_wengg_basic (par_id, construct_end_date, construct_start_date,
                                       contract_proj_buss_title, engg_basic_infonum, maintain_end_date,
                                       maintain_start_date, mbi_policy_no, site_location, testing_end_date,
                                       testing_start_date, time_excess, weeks_test)
              VALUES (parlist_rec.par_id, rec.construct_end_date, rec.construct_start_date,
                      rec.contract_proj_buss_title, rec.engg_basic_infonum, rec.maintain_end_date, 
                      rec.maintain_start_date, rec.mbi_policy_no, rec.site_location, rec.testing_end_date,
                      rec.testing_start_date, rec.time_excess, rec.weeks_test);
        END LOOP;
    
      END LOOP;
    END IF; -- end of with_en  
          
    IF with_fi = 'Y' THEN
      FOR parlist_rec IN fi 
      LOOP 
        FOR rec IN (SELECT item_no, assignee, block_id, block_no, construction_cd, 
                           construction_remarks, district_no, eq_zone, flood_zone, 
                           fr_item_type, front, left, loc_risk1, loc_risk2, loc_risk3, 
                           occupancy_cd, occupancy_remarks, rear, right, tarf_cd, 
                           tariff_zone, typhoon_zone, risk_cd --added by annabelle 10.24.05
                      FROM gipi_quote_fi_item
                     WHERE quote_id = parlist_rec.quote_id)
        LOOP
         INSERT INTO gipi_wfireitm (par_id, item_no, assignee, block_id, block_no,
                                    construction_cd, construction_remarks, district_no,
                                    eq_zone, flood_zone, fr_item_type, front, left,
                                    loc_risk1, loc_risk2, loc_risk3, occupancy_cd,
                                    occupancy_remarks, rear, right, tarf_cd, 
                                    tariff_zone, typhoon_zone, risk_cd)
              VALUES (parlist_rec.par_id, rec.item_no, rec.assignee, rec.block_id, rec.block_no,
                      rec.construction_cd, rec.construction_remarks, rec.district_no,
                      rec.eq_zone, rec.flood_zone, rec.fr_item_type, rec.front, rec.left,
                      rec.loc_risk1, rec.loc_risk2, rec.loc_risk3, rec.occupancy_cd,
                      rec.occupancy_remarks, rec.rear, rec.right, rec.tarf_cd, rec.tariff_zone,
                    rec.typhoon_zone, rec.risk_cd);
     
      FOR a IN (SELECT region_cd
                       FROM giis_block a, giis_province b
                      WHERE a.province_cd = b.province_cd
                        AND a.block_id = rec.block_id)
         LOOP
          UPDATE gipi_witem 
             SET region_cd = a.region_cd
           WHERE par_id  = p_pack_par_id
             AND item_no = rec.item_no;
          EXIT;     
            END LOOP;
        END LOOP;
      END LOOP;
    
    END IF; -- end of with_fi
    
    
    END;
    
    PROCEDURE create_discounts (p_pack_par_id NUMBER) 
    /* This procedure will insert records into the discount tables
    */
    IS
    
    CURSOR par IS
      SELECT par_id, quote_id
        FROM gipi_parlist
       WHERE pack_par_id = p_pack_par_id;
    
    BEGIN
    
    FOR disc in par
    LOOP
      FOR itm IN (SELECT surcharge_rt, surcharge_amt, subline_cd, sequence, remarks, orig_prem_amt, 
                         net_prem_amt, net_gross_tag, line_cd, item_no, disc_rt, disc_amt
                    FROM gipi_quote_item_discount
                   WHERE quote_id = disc.quote_id)
      LOOP
       INSERT INTO gipi_witem_discount(par_id, line_cd, item_no, subline_cd, disc_rt, disc_amt,
                                       net_gross_tag, orig_prem_amt, sequence, remarks, net_prem_amt,
                                       surcharge_rt, surcharge_amt)
            VALUES (disc.par_id, itm.line_cd, itm.item_no, itm.subline_cd, itm.disc_rt, itm.disc_amt,
                    itm.net_gross_tag, itm.orig_prem_amt, itm.sequence, itm.remarks, itm.net_prem_amt,
                    itm.surcharge_rt, itm.surcharge_amt);                           
      END LOOP;
      
      FOR peril IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag, disc_amt,
                           net_gross_tag, discount_tag, subline_cd, orig_peril_prem_amt,
                           sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt
                      FROM gipi_quote_peril_discount
                     WHERE quote_id = disc.quote_id)
      LOOP
       INSERT INTO gipi_wperil_discount(par_id, item_no, line_cd, peril_cd, disc_rt, level_tag,
                   disc_amt, net_gross_tag, discount_tag, subline_cd, orig_peril_prem_amt,
                   sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt)
            VALUES (disc.par_id, peril.item_no, peril.line_cd, peril.peril_cd, peril.disc_rt, peril.level_tag,
                   peril.disc_amt, peril.net_gross_tag, peril.discount_tag, peril.subline_cd,
                   peril.orig_peril_prem_amt, peril.sequence, peril.net_prem_amt, peril.remarks, 
                   peril.surcharge_rt, peril.surcharge_amt);        
      END LOOP;
    
      FOR pol IN (SELECT line_cd, subline_cd, disc_rt, disc_amt, net_gross_tag, orig_prem_amt,
                         sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt
                    FROM gipi_quote_polbasic_discount
                   WHERE quote_id = disc.quote_id)
      LOOP
       INSERT INTO gipi_wpolbas_discount(par_id, line_cd, subline_cd, disc_rt, disc_amt, net_gross_tag,
                                         orig_prem_amt, sequence, remarks, net_prem_amt, surcharge_rt,
                                         surcharge_amt)
            VALUES (disc.par_id, pol.line_cd, pol.subline_cd, pol.disc_rt, pol.disc_amt,
                    pol.net_gross_tag, pol.orig_prem_amt, pol.sequence, pol.remarks, pol.net_prem_amt,
                    pol.surcharge_rt, pol.surcharge_amt);                                
      END LOOP;
    
    END LOOP;  
      
    END;
       
    PROCEDURE create_peril_wc (p_pack_par_id NUMBER) 
        /* This procedure will insert records in 
        ** gipi_witmperl and gipi_wpolwc.
        */
        IS
        
        v_item_no       gipi_witmperl.item_no%type;  
        v_line_cd       gipi_witmperl.line_cd%type;  
        v_peril_cd      gipi_witmperl.peril_cd%type;
        v_prem_rt       gipi_witmperl.prem_rt%type;
        v_tsi_amt       gipi_witmperl.tsi_amt%type;
        v_prem_amt      gipi_witmperl.prem_amt%type;
        v_ann_tsi_amt   gipi_witmperl.ann_tsi_amt%type;
        v_ann_prem_amt  gipi_witmperl.ann_prem_amt%type;
    
        CURSOR par IS
          SELECT par_id, quote_id, line_cd
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id;
           
        BEGIN
    
        FOR x IN par
        LOOP
          
          FOR A IN (SELECT item_no,peril_cd,prem_rt,tsi_amt,prem_amt,ann_prem_amt, ann_tsi_amt
                      FROM gipi_quote_itmperil 
                     WHERE quote_id = x.quote_id) 
          LOOP
            v_item_no      := A.ITEM_NO;
            v_peril_cd     := A.PERIL_CD;
            v_prem_rt      := A.PREM_RT;
            v_tsi_amt      := A.TSI_AMT;
            v_prem_amt     := A.PREM_AMT;                 
            v_ann_tsi_amt  := A.ann_tsi_amt;
            v_ann_prem_amt := A.ann_prem_amt;
          
         INSERT INTO gipi_witmperl
                   (par_id,item_no,line_cd,peril_cd,tarf_cd,prem_rt,
                    tsi_amt,prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,
                    comp_rem,discount_sw,ri_comm_rate,ri_comm_amt)
            VALUES (x.par_id,v_item_no,x.line_cd,v_peril_cd,NULL,v_prem_rt,
                    v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,NULL,
                    NULL,'N',NULL,0);
          END LOOP;          
         
          FOR wc IN (SELECT change_tag, line_cd, print_seq_no, print_sw, wc_cd, wc_remarks,
                             wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06,
                             wc_text07, wc_text08, wc_text09, wc_text10, wc_text11, wc_text12,
                             wc_text13, wc_text14, wc_text15, wc_text16, wc_text17, wc_title
                        FROM gipi_quote_wc
                       WHERE quote_id = x.quote_id)
          LOOP
           INSERT INTO gipi_wpolwc ( par_id, change_tag, line_cd, print_seq_no, print_sw, wc_cd, 
                                     wc_remarks, wc_text01, wc_text02, wc_text03, wc_text04,
                                     wc_text05, wc_text06, wc_text07, wc_text08, wc_text09,
                                     wc_text10, wc_text11, wc_text12, wc_text13, wc_text14,
                                     wc_text15, wc_text16, wc_text17, wc_title, swc_seq_no )
                VALUES ( x.par_id, wc.change_tag, wc.line_cd, wc.print_seq_no, wc.print_sw,
                         wc.wc_cd, wc.wc_remarks, wc.wc_text01, wc.wc_text02, wc.wc_text03,
                         wc.wc_text04, wc.wc_text05, wc.wc_text06, wc.wc_text07, wc.wc_text08,
                         wc.wc_text09, wc.wc_text10, wc.wc_text11, wc.wc_text12, wc.wc_text13,
                         wc.wc_text14, wc.wc_text15, wc.wc_text16, wc.wc_text17, wc.wc_title,0 );
          END LOOP;
        END LOOP;  
    END;   
    
    
    PROCEDURE create_dist_ded (p_pack_par_id NUMBER) 
        /* This procedure will create distribution and deductible records
        */
    IS
        
        p_dist_no        giuw_pol_dist.dist_no%TYPE;
        v_tsi_amt        gipi_polbasic.ann_tsi_amt%TYPE;
        v_ann_tsi_amt    gipi_polbasic.ann_tsi_amt%TYPE;
        v_prem_amt       gipi_polbasic.ann_prem_amt%TYPE;
        p_eff_date       gipi_wpolbas.incept_date%TYPE;
        p_expiry_date    gipi_wpolbas.expiry_date%TYPE;
      
        CURSOR par IS
          SELECT par_id, quote_id, line_cd
            FROM gipi_parlist
           WHERE pack_par_id = p_pack_par_id;  
    
    BEGIN
      
    FOR dist_ded IN par  
    LOOP
      SELECT POL_DIST_DIST_NO_S.NEXTVAL
        INTO p_dist_no
        FROM DUAL;
             
      FOR a IN ( SELECT sum(tsi_amt     * currency_rt) tsi,
                        sum(ann_tsi_amt * currency_rt) ann_tsi,
                        sum(prem_amt    * currency_rt) prem
                   FROM gipi_witem
                  WHERE par_id = dist_ded.par_id)
      LOOP
        v_tsi_amt     := a.tsi;
        v_ann_tsi_amt := a.ann_tsi;
        v_prem_amt    := a.prem;
      END LOOP;          
      
      FOR b IN ( SELECT incept_date, expiry_date
                   FROM gipi_quote
                  WHERE quote_id = dist_ded.quote_id)
      LOOP
        p_eff_date     := b.incept_date;
        p_expiry_date  := b.expiry_date;
      END LOOP;          
      
      INSERT INTO giuw_pol_dist(dist_no, par_id, tsi_amt,
                                prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                                eff_date, expiry_date, create_date, user_id,
                                last_upd_date, post_flag, auto_dist)
           VALUES (p_dist_no, dist_ded.par_id, NVL(v_tsi_amt,0),
                   NVL(v_prem_amt,0), NVL(v_ann_tsi_amt,0), 1, 1,
                   p_eff_date, p_expiry_date, SYSDATE, USER,
                   SYSDATE, 'O', 'N');
      
      FOR rec IN (SELECT ded_deductible_cd, deductible_amt, deductible_rt, deductible_text,
                         item_no, peril_cd
                    FROM gipi_quote_deductibles
                   WHERE quote_id = dist_ded.quote_id)
      LOOP
       FOR a IN (SELECT line_cd, subline_cd
                   FROM gipi_quote
                  WHERE quote_id = dist_ded.quote_id) 
       LOOP 
        INSERT INTO gipi_wdeductibles (par_id, ded_line_cd, ded_subline_cd, ded_deductible_cd, deductible_amt, deductible_rt,
                                      deductible_text, item_no, peril_cd)
             VALUES (dist_ded.par_id, a.line_cd, a.subline_cd, rec.ded_deductible_cd, rec.deductible_amt, rec.deductible_rt,
                    rec.deductible_text, rec.item_no, 0);
         EXIT;
       END LOOP;             
      END LOOP;  
      END LOOP;    
    
    
    END;   
     
    PROCEDURE return_to_quote (p_pack_quote_id NUMBER, p_pack_par_id NUMBER) 
    /* This procedure will return the package PAR to a quotation
    ** by updating its status from 'W' to 'N'
    */
    IS   
       
       CURSOR cur_b IS SELECT quotation_no,quotation_yy,subline_cd,iss_cd,line_cd
                      FROM gipi_pack_quote
                     WHERE pack_quote_id = p_pack_quote_id;
          
    BEGIN
    
      FOR x IN cur_b
      LOOP
      
           UPDATE gipi_pack_parlist
            SET par_status = 99
          WHERE quote_id = p_pack_quote_id;
             
         UPDATE gipi_parlist
            SET par_status = 99
          WHERE pack_par_id = p_pack_par_id;
             
         UPDATE gipi_pack_quote 
            SET status = 'N'
          WHERE line_cd = x.line_cd 
            AND iss_cd = x.iss_cd 
            AND quotation_yy = x.quotation_yy
            AND quotation_no = x.quotation_no
            AND subline_cd = x.subline_cd;
            
         UPDATE gipi_quote
            SET status = 'N'
          WHERE pack_quote_id = p_pack_quote_id;
      END LOOP;  
      COMMIT;
    END;
    
    ------anthony santos 10,17,07---------------
   PROCEDURE create_wmortgagee (p_pack_quote_id NUMBER, p_pack_par_id NUMBER)
   IS
      CURSOR cur_c
      IS
         SELECT c.par_id, b.quote_id, a.iss_cd, a.item_no, a.mortg_cd,
                a.amount, a.remarks, a.last_update, a.user_id, pack_quote_id
           FROM gipi_quote_mortgagee a, gipi_quote b, gipi_parlist c
          WHERE b.pack_quote_id = p_pack_quote_id
            AND b.quote_id = a.quote_id
            AND c.pack_par_id = p_pack_par_id
            AND c.quote_id = b.quote_id;
   BEGIN
      FOR x IN cur_c
      LOOP
         INSERT INTO gipi_wmortgagee
                     (par_id, iss_cd, item_no, mortg_cd, amount,
                      remarks, last_update, user_id
                     )
              VALUES (x.par_id, x.iss_cd, x.item_no, x.mortg_cd, x.amount,
                      x.remarks, x.last_update, x.user_id
                     );
      END LOOP;

      COMMIT;
   END;
------END anthony santos 10,17,07---------------
  
/*
**  Created by      : Menandro G.C. Robes
**  Date Created  : July 1, 2010
**  Reference By  : (GIPIS097 - Endt Item Peril Information)
**  Description   : Procedure to update pack par status. 
*/  
  PROCEDURE update_pack_par_status(p_pack_par_id  GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                   p_par_status   GIPI_PACK_PARLIST.par_status%TYPE)
  IS
  BEGIN
    UPDATE gipi_pack_parlist
       SET par_status  = p_par_status
     WHERE pack_par_id = p_pack_par_id;
  END; 
    
/*
**  Created by      : Jerome Orio 
**  Date Created  : July 12, 2011
**  Reference By  : (GIPIS055a - Posting Package PAR) 
**  Description   : Procedure to update pack par status. 
*/  
    PROCEDURE UPDATE_PACK_PAR_STATUS(p_pack_par_id  GIPI_PACK_PARLIST.pack_par_id%TYPE) IS
    BEGIN
      FOR A IN (
         SELECT pack_par_id ,par_status
           FROM gipi_pack_parlist
          WHERE pack_par_id = p_pack_par_id
         FOR UPDATE OF pack_par_id, par_status) LOOP
         UPDATE gipi_pack_parlist
            SET par_status = 10
          WHERE pack_par_id = p_pack_par_id;
         EXIT;
      END LOOP;
    END;  
  
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : November 3, 2010
**  Reference By  : (GIPIS001A- Package Par Listing)
**  Description   : Function returns necessary details for package par listing
*/  

FUNCTION get_gipi_pack_parlist (  p_line_cd     GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd      GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_module_id   GIIS_USER_GRP_MODULES.module_id%TYPE,
                                  p_user_id     GIIS_USERS.user_id%TYPE,
                                  p_keyword     VARCHAR2)
  RETURN gipi_pack_parlist_tab PIPELINED AS
  
  v_pack               gipi_pack_parlist_type;
  v_iss_cd          giis_issource.iss_cd%TYPE;

BEGIN
    FOR iss IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ISS_CD_RI')
    LOOP
        v_iss_cd := iss.param_value_v;
    END LOOP;
    
    FOR i IN ( SELECT  A.pack_par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, b.assd_name, A.underwriter,
                   c.pack_pol_flag, c.line_name,
                   Cg_Ref_Codes_Pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') pack_par_no
                   
              FROM GIPI_PACK_PARLIST A,
                   GIIS_ASSURED b,
                   GIIS_LINE c
             WHERE check_user_per_line2 (A.line_cd, p_iss_cd, p_module_id, p_user_id) = 1
               --AND Check_User_Per_Iss_Cd2 (NVL(p_line_cd, A.line_cd), A.iss_cd, p_module_id) = 1
               AND iss_cd <> v_iss_cd  
               AND par_status < 10
               AND underwriter = NVL(p_user_id, a.underwriter)
               AND par_type = 'P'
               AND c.pack_pol_flag = 'Y'
               AND A.assd_no = b.assd_no
               AND A.line_cd = c.line_cd
               AND A.line_cd = NVL(p_line_cd, A.line_cd) 
               AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
               AND (   UPPER (A.iss_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_yy) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.quote_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.underwriter) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER
                          (Cg_Ref_Codes_Pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                          ) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (b.assd_name) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.line_cd) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (c.line_name) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                   )
               
          ORDER BY    LTRIM(A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.line_name      := i.line_name;
        v_pack.iss_cd         := i.iss_cd;
        v_pack.par_yy         := i.par_yy;
        v_pack.par_seq_no     := i.par_seq_no;
        v_pack.quote_seq_no   := i.quote_seq_no;
        v_pack.quote_id       := i.quote_id;
        v_pack.assd_no        := i.assd_no;
        v_pack.assd_name      := i.assd_name;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id    := i.pack_par_id;
        v_pack.par_status     := i.par_status;
        v_pack.par_type       := i.par_type;
        v_pack.status         := i.status;
        v_pack.assign_sw      := i.assign_sw;
        v_pack.pack_par_no    := i.pack_par_no;
        
        FOR b IN (SELECT bank_ref_no
                   FROM GIPI_PACK_WPOLBAS
                   WHERE pack_par_id = i.pack_par_id)
        LOOP
            v_pack.bank_ref_no  := b.bank_ref_no;
        END LOOP;
        
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : November 3, 2010
**  Reference By  : (GIPIS001A- Package Par Listing)
**  Description   : Procedure deletes PAR that are under the package PAR and their details 
*/  

PROCEDURE delete_par    (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                         p_user_id        VARCHAR2)
IS

BEGIN
   FOR c IN (SELECT par_id 
             FROM gipi_parlist
             WHERE pack_par_id = p_pack_par_id)
   LOOP
                                        -- changed to c.par_id from p_pack_par_id
      GIPI_PARHIST_PKG.delete_parhist(c.par_id, p_user_id);
      GIPI_PARLIST_PKG.delete_fire_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_motorcar_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_accident_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_cargo_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_hull_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_casualty_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_engineering_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_bonds_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_aviation_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_wpolwc(c.par_id);
      GIPI_PARLIST_PKG.delete_oth_workfile(c.par_id);
      GIPI_PARLIST_PKG.delete_expiry(c.par_id);
      GIPI_PARLIST_PKG.delete_distribution(c.par_id);
      GIPI_PARLIST_PKG.delete_wpolnrep(c.par_id);
      GIPI_PARLIST_PKG.delete_wpolbas(c.par_id);
      GIPI_PARLIST_PKG.update_par_status(c.par_id, 99);
      
      DELETE_WORKFLOW_REC('PAR-Policy (ready for posting)','GIPIS085',USER,c.par_id);
      DELETE_WORKFLOW_REC('Facultative Placement','GIUWS003',USER,c.par_id);
      DELETE_WORKFLOW_REC('Facultative Placement','GIUWS004',USER,c.par_id); 
         
   END LOOP;

END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : November 3, 2010
**  Reference By  : (GIPIS001A- Package Par Listing)
**  Description   : Procedure deletes records from tables related to Package PAR 
*/  
                           
PROCEDURE delete_pack_tables    (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                 p_user_id        VARCHAR2)
IS

BEGIN
     DELETE FROM gipi_pack_wpolwc
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_winv_tax
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_winstallment
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_winvperl
      WHERE pack_par_id = p_pack_par_id;

     DELETE FROM gipi_pack_winvoice
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_wpolnrep
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_wpolgenin
      WHERE pack_par_id = p_pack_par_id;
      
     DELETE FROM gipi_pack_wpolbas
      WHERE pack_par_id = p_pack_par_id;
      
     UPDATE gipi_pack_parlist
      SET par_status = 99
      WHERE pack_par_id = p_pack_par_id;
      
     INSERT INTO gipi_pack_parhist(pack_par_id,user_id,parstat_date,entry_source,parstat_cd)
     VALUES (p_pack_par_id,p_user_id,SYSDATE + 1/86400,'DB','5');
     
     DELETE_WORKFLOW_REC('Package Policy - Ready for Posting','GIPIS085',USER,p_pack_par_id);
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : November 3, 2010
**  Reference By  : (GIPIS001A- Package Par Listing)
**  Description   : Procedure cancel Package PAR  
*/  

PROCEDURE cancel_pack_par    (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                              p_par_status     GIPI_PACK_PARLIST.par_status%TYPE,
                              p_user_id        VARCHAR2)
IS

BEGIN
   
   UPDATE gipi_parlist
     SET par_status = 98, 
         old_par_status = p_par_status
   WHERE pack_par_id = p_pack_par_id;

   
   FOR c IN (SELECT par_id 
             FROM gipi_parlist
             WHERE pack_par_id = p_pack_par_id)
   LOOP    
      
      DELETE_WORKFLOW_REC('PAR-Policy (ready for posting)','GIPIS085',USER,c.par_id);
      DELETE_WORKFLOW_REC('Facultative Placement','GIUWS003',USER,c.par_id);
      DELETE_WORKFLOW_REC('Facultative Placement','GIUWS004',USER,c.par_id);
      
      GIPI_PARHIST_PKG.set_gipi_parhist(c.par_id,p_user_id, NULL, p_par_status); 
         
   END LOOP;
   
   UPDATE gipi_pack_parlist
     SET par_status = 98, 
         old_par_status = p_par_status
   WHERE pack_par_id = p_pack_par_id;         
                      
   DELETE_WORKFLOW_REC('Package Policy - Ready for Posting','GIPIS085',USER,p_pack_par_id);
                    
   INSERT INTO gipi_pack_parhist(pack_par_id, user_id, parstat_date, entry_source, parstat_cd)
         VALUES (p_pack_par_id, p_user_id, SYSDATE, NULL, p_par_status);

END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : November 15, 2010
**  Reference By  : (GIPIS058A- Package Par Listing - Endt)
**  Description   : Function returns necessary details for endorsement package par listing
*/  

FUNCTION get_gipi_pack_endt_parlist (  p_line_cd     GIPI_PACK_PARLIST.line_cd%TYPE,
                                       p_iss_cd      GIPI_PACK_PARLIST.iss_cd%TYPE,
                                       p_module_id   GIIS_USER_GRP_MODULES.module_id%TYPE,
                                       p_user_id     GIIS_USERS.user_id%TYPE,
                                       p_keyword     VARCHAR2)
  RETURN gipi_pack_parlist_tab PIPELINED AS
  
  v_pack               gipi_pack_parlist_type;
  v_iss_cd          giis_issource.iss_cd%TYPE;

BEGIN
    FOR iss IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ISS_CD_RI')
    LOOP
        v_iss_cd := iss.param_value_v;
    END LOOP;
    
    FOR i IN ( SELECT  A.pack_par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, B.assd_name, A.underwriter,
                   C.subline_cd, C.issue_yy, C.pol_seq_no, C.renew_no, C.bank_ref_no,
                   Cg_Ref_Codes_Pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') pack_par_no
                   
              FROM GIPI_PACK_PARLIST A, GIIS_ASSURED B, GIPI_PACK_WPOLBAS C
             WHERE check_user_per_line2 (A.line_cd, p_iss_cd, p_module_id, p_user_id) = 1
               --AND Check_User_Per_Iss_Cd2 (NVL(p_line_cd, A.line_cd), A.iss_cd, p_module_id) = 1
               AND b.assd_no (+) = a.assd_no
               AND c.pack_par_id (+) = a.pack_par_id
               AND a.iss_cd <> v_iss_cd  
               AND a.par_status < 10
               AND underwriter = NVL(p_user_id, a.underwriter)
               AND a.par_type = 'E'
               AND a.assign_sw = 'Y'
               AND A.line_cd = NVL(p_line_cd, A.line_cd) 
               AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
               AND (   UPPER (A.iss_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_yy) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_seq_no) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.quote_seq_no) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.underwriter) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER
                          (Cg_Ref_Codes_Pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                          ) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.line_cd) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                   )
               
          ORDER BY    LTRIM(A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC )
    LOOP
        v_pack.line_cd         := i.line_cd;
        --v_pack.line_name       := i.line_name;
        v_pack.iss_cd          := i.iss_cd;
        v_pack.par_yy          := i.par_yy;
        v_pack.par_seq_no      := i.par_seq_no;
        v_pack.quote_seq_no    := i.quote_seq_no;
        v_pack.quote_id        := i.quote_id;
        v_pack.assd_no         := i.assd_no;
        --v_pack.assd_name       := i.assd_name;
        v_pack.remarks         := i.remarks;
        v_pack.underwriter     := i.underwriter;    
        v_pack.pack_par_id     := i.pack_par_id;
        v_pack.par_status      := i.par_status;
        v_pack.par_type        := i.par_type;
        v_pack.status          := i.status;
        v_pack.assign_sw       := i.assign_sw;
        v_pack.pack_par_no     := i.pack_par_no;
        v_pack.assd_name       := i.assd_name;
        v_pack.subline_cd      := i.subline_cd;
        v_pack.issue_yy           := i.issue_yy;
        v_pack.pol_seq_no       := i.pol_seq_no;
        v_pack.renew_no           := i.renew_no;
        v_pack.bank_ref_no     := i.bank_ref_no;
        
        /*FOR s IN (SELECT assd_name
                   FROM GIIS_ASSURED
                   WHERE assd_no = i.assd_no)
        LOOP
            v_pack.assd_name       := s.assd_name;
        END LOOP;
        
        FOR b IN (SELECT subline_cd, issue_yy, pol_seq_no, renew_no, bank_ref_no
                   FROM GIPI_PACK_WPOLBAS
                  WHERE pack_par_id = i.pack_par_id)
        LOOP
            v_pack.subline_cd   := b.subline_cd;
            v_pack.issue_yy        := b.issue_yy;
            v_pack.pol_seq_no    := b.pol_seq_no;
            v_pack.renew_no        := b.renew_no;
            v_pack.bank_ref_no  := b.bank_ref_no;
        END LOOP;*/
        
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;
END get_gipi_pack_endt_parlist;

    /*
    **  Created by   :  Emman
    **  Date Created :  11.18.2010
    **  Reference By : (GIPIS031A - Package Endt Basic Info)
    **  Description  : Fetches the info needed in loading the Package Endt Basic Info Page
    */
    PROCEDURE get_pack_endt_basic_info_recs (p_par_id                        IN     GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                               p_gipi_pack_parlist_cur           OUT GIPI_PACK_PARLIST_PKG.rc_gipi_pack_parlist_cur,
                                             p_gipi_pack_wpolbas_cur           OUT GIPI_PACK_WPOLBAS_PKG.rc_gipi_pack_wpolbas_cur,
                                             p_gipi_pack_wendttext_cur           OUT GIPI_PACK_WENDTTEXT_PKG.rc_gipi_pack_wendttext_cur,
                                             p_gipi_pack_wpolgenin_cur           OUT GIPI_PACK_WPOLGENIN_PKG.rc_gipi_pack_wpolgenin_cur,
                                             p_gipi_wopen_policy_cur           OUT GIPI_WOPEN_POLICY_PKG.rc_gipi_wopen_policy_cur
                                               )
    IS
    BEGIN
         /* creates new record cursor for GIPI_PACK_PARLIST based on the following data */
        OPEN p_gipi_pack_parlist_cur FOR
        SELECT b240.pack_par_id,          b240.assd_no,                b240.par_type,
               b240.line_cd,             b240.par_yy,                b240.iss_cd,
               b240.par_seq_no,             b240.quote_seq_no,            b240.address1,
               b240.address2,             b240.address3,                b240.par_status,
               b240.line_cd || ' - ' ||  b240.iss_cd  || ' - ' || to_char(b240.par_yy, '09') || ' - ' ||
                  to_char(b240.par_seq_no, '099999') || ' - ' || to_char(b240.quote_seq_no, '09') drv_par_seq_no,
               a.assd_name
          FROM GIPI_PACK_PARLIST b240, GIIS_ASSURED a
         WHERE b240.pack_par_id = p_par_id
           AND b240.assd_no = a.assd_no (+);
         
        OPEN p_gipi_pack_wpolbas_cur FOR
        SELECT b540.pack_par_id,         b540.label_tag,            b540.endt_expiry_tag,
               b540.line_cd,             b540.subline_cd,            b540.iss_cd,
               b540.issue_yy,             b540.pol_seq_no,            b540.renew_no,
               b540.assd_no,             b540.old_assd_no,            b540.acct_of_cd,
               b540.endt_iss_cd,         b540.endt_yy,                b540.endt_seq_no,
               b540.incept_date,         b540.incept_tag,            b540.expiry_date,
               b540.expiry_tag,             b540.prem_warr_tag,        b540.eff_date,
               b540.endt_expiry_date,     b540.place_cd,                a.place,                       b540.issue_date,
               b540.type_cd,             b540.ref_pol_no,            b540.manual_renew_no,
               b540.pol_flag,             b540.acct_of_cd_sw,        b540.region_cd,                 c.region_desc nbt_region_desc,
               b540.industry_cd,         b.industry_nm nbt_ind_desc,b540.address1,                b540.address2,
               b540.address3,             b540.old_address1,            b540.old_address2,
               b540.old_address3,         b540.cred_branch,            d.iss_name dsp_cred_branch, b540.bank_ref_no,
               b540.mortg_name,             b540.booking_year,            b540.booking_mth,
               b540.covernote_printed_sw,b540.quotation_printed_sw,    b540.foreign_acc_sw,
               b540.invoice_sw,             b540.auto_renew_flag,        b540.prorate_flag,
               b540.comp_sw,             b540.short_rt_percent,        b540.prov_prem_tag,
               b540.fleet_print_tag,     b540.with_tariff_sw,        b540.prov_prem_pct,
               b540.ref_open_pol_no,     b540.same_polno_sw,        b540.ann_tsi_amt,
               b540.prem_amt,             b540.tsi_amt,                b540.ann_prem_amt,
               b540.reg_policy_sw,         b540.co_insurance_sw,        b540.user_id,
               b540.pack_pol_flag,         b540.designation,            b540.back_stat,
               b540.risk_tag,             b540.bancassurance_sw,        b540.banc_type_cd,             e.banc_type_desc dsp_banc_type_desc,
               b540.area_cd,             f.area_desc dsp_area_desc, b540.branch_cd,                g.branch_desc dsp_branch_desc,
               g.area_cd dsp_area_cd,     b540.manager_cd,            h.assd_name
          FROM GIPI_PACK_WPOLBAS b540, GIIS_ISSOURCE_PLACE a, GIIS_INDUSTRY b, GIIS_REGION c,
                 GIIS_ISSOURCE d, GIIS_BANC_TYPE e, GIIS_BANC_AREA f, GIIS_BANC_BRANCH g, GIIS_ASSURED h
         WHERE b540.pack_par_id = p_par_id
           AND a.place_cd (+) = b540.place_cd
           AND a.iss_cd (+)   = b540.iss_cd
           AND b.industry_cd (+) = b540.industry_cd
           AND c.region_cd (+) = b540.region_cd
           AND d.iss_cd (+) = b540.cred_branch
           AND e.banc_type_cd (+) = b540.banc_type_cd
           AND f.area_cd (+) = b540.area_cd
           AND g.branch_cd (+) = b540.branch_cd
           AND h.assd_no (+) = b540.assd_no;
         
        OPEN p_gipi_pack_wendttext_cur FOR
        SELECT pack_par_id,     endt_cd,         endt_tax,
               endt_text01,        endt_text02,    endt_text03,
               endt_text04,        endt_text05,    endt_text06,
               endt_text07,        endt_text08,    endt_text09,
               endt_text10,        endt_text11,    endt_text12,
               endt_text13,        endt_text14,    endt_text15,
               endt_text16,        endt_text17,    endt_text01 dsp_endt_text
          FROM GIPI_PACK_WENDTTEXT
         WHERE pack_par_id = p_par_id;
         
        OPEN p_gipi_pack_wpolgenin_cur FOR
        SELECT b550.pack_par_id,             b550.genin_info_cd,              b550.gen_info01,
               b550.gen_info02,              b550.gen_info03,                  b550.gen_info04,
               b550.gen_info05,              b550.gen_info06,                  b550.gen_info07,
               b550.gen_info08,              b550.gen_info09,                  b550.gen_info10,
               b550.gen_info11,              b550.gen_info12,                  b550.gen_info13,
               b550.gen_info14,              b550.gen_info15,                  b550.gen_info16,
               b550.gen_info17,              b550.gen_info01 dsp_gen_info
          FROM GIPI_PACK_WPOLGENIN b550
         WHERE b550.pack_par_id = p_par_id;
         
        OPEN p_gipi_wopen_policy_cur FOR
        SELECT b530.par_id,                   b530.line_cd,                      b530.op_subline_cd,
               b530.op_iss_cd,              b530.op_issue_yy,                  b530.op_pol_seqno,
               b530.op_renew_no,          b530.decltn_no,                  b530.eff_date
          FROM GIPI_WOPEN_POLICY b530
         WHERE b530.par_id = p_par_id;
        
    END get_pack_endt_basic_info_recs;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : January 6, 20100
**  Reference By  : (GIPIS001A- Package Par Listing)
**  Description   : Procedure to update pack par remarks. 
*/  
  PROCEDURE update_pack_par_remarks(p_pack_par_id   GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                    p_par_remarks   GIPI_PACK_PARLIST.remarks%TYPE)
  IS
  
  BEGIN
    
    UPDATE gipi_pack_parlist
       SET remarks  = p_par_remarks
     WHERE pack_par_id = p_pack_par_id;
	 
	UPDATE gipi_parlist
       SET remarks  = p_par_remarks
     WHERE pack_par_id = p_pack_par_id;
  
  END update_pack_par_remarks;
  
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001A- Package Par Listing
**                  GIPIS058A - Package Endt Par Listing
**  Description   : Function returns necessary details for package par listings
*/ 
  
FUNCTION get_gipi_pack_parlist (  p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
                                  p_user_id         GIIS_USERS.user_id%TYPE,
                                  p_par_type        GIPI_PACK_PARLIST.par_type%TYPE,
                                  p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_assd_name       GIIS_ASSURED.assd_name%TYPE,
                                  p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
                                  p_status          VARCHAR2,
                                  p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE)
  
  RETURN gipi_pack_parlist_tab PIPELINED AS
  
  v_pack            gipi_pack_parlist_type;
  v_iss_cd          giis_issource.iss_cd%TYPE;

BEGIN
    FOR iss IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ISS_CD_RI')
    LOOP
        v_iss_cd := iss.param_value_v;
    END LOOP;
    
    FOR i IN ( SELECT   A.pack_par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                        A.quote_seq_no, A.assd_no, LTRIM(b.assd_name) assd_name, A.underwriter,
                        c.pack_pol_flag, c.line_name, d.bank_ref_no, d.pol_seq_no, 
                        d.renew_no, d.subline_cd, d.issue_yy,
                        Cg_Ref_Codes_Pkg.get_rv_meaning
                                   ('GIPI_PARLIST.PAR_STATUS',A.par_status) status,
                        A.par_type, A.par_status, A.quote_id, A.assign_sw,
                        A.remarks, 
                        A.line_cd
                        || '-'
                        || A.iss_cd
                        || '-'
                        || TO_CHAR (A.par_yy, '09')
                        || '-'
                        || TO_CHAR (A.par_seq_no, '000009')
                        || '-'
                        || TO_CHAR (A.quote_seq_no, '09') pack_par_no
                                   
                          FROM GIPI_PACK_PARLIST A,
                               GIIS_ASSURED b,
                               GIIS_LINE c,
                               GIPI_PACK_WPOLBAS d
                         WHERE check_user_per_line2 (A.line_cd, DECODE(p_user_id, null, null, a.iss_cd), p_module_id, p_user_id) = 1
                           AND Check_User_Per_Iss_Cd2 (NVL(p_line_cd, A.line_cd), A.iss_cd, p_module_id, p_user_id) = 1
                           AND A.iss_cd <> v_iss_cd  
                           AND A.par_status < 10
                           AND A.underwriter = NVL(p_user_id, a.underwriter)
                           AND A.par_type = NVL(p_par_type, 'P')
                           AND c.pack_pol_flag = 'Y'
                           AND A.assd_no = b.assd_no(+)
                           AND A.line_cd = c.line_cd
                           AND A.pack_par_id = d.pack_par_id(+)
                           AND A.line_cd = NVL(p_line_cd, A.line_cd) 
                           AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
                           AND UPPER(NVL(assd_name, '*')) LIKE UPPER(NVL(p_assd_name, DECODE(assd_name, null, '*', assd_name)))
                           AND UPPER (Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)) LIKE UPPER (NVL(p_status, Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)))
                           AND UPPER (A.par_yy) LIKE UPPER (NVL(p_par_yy,A.par_yy))
                           AND UPPER (A.par_seq_no) LIKE UPPER (NVL(p_par_seq_no, A.par_seq_no))
                           AND UPPER (A.quote_seq_no) LIKE UPPER (NVL(p_quote_seq_no, A.quote_seq_no))
                           AND UPPER (A.underwriter) LIKE UPPER (NVL(p_underwriter, A.underwriter))
                           AND UPPER(NVL(bank_ref_no, '*')) LIKE '%' || UPPER(NVL(p_bank_ref_no, DECODE(bank_ref_no, null, '*', bank_ref_no)))
                ORDER BY    LTRIM(A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.line_name      := i.line_name;
        v_pack.iss_cd         := i.iss_cd;
        v_pack.par_yy         := i.par_yy;
        v_pack.par_seq_no     := i.par_seq_no;
        v_pack.quote_seq_no   := i.quote_seq_no;
        v_pack.quote_id       := i.quote_id;
        v_pack.assd_no        := i.assd_no;
        v_pack.assd_name      := i.assd_name;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id    := i.pack_par_id;
        v_pack.par_status     := i.par_status;
        v_pack.par_type       := i.par_type;
        v_pack.status         := i.status;
        v_pack.assign_sw      := i.assign_sw;
        v_pack.pack_par_no    := i.pack_par_no;
        v_pack.bank_ref_no    := i.bank_ref_no;
        v_pack.subline_cd     := i.subline_cd;
        v_pack.issue_yy          := i.issue_yy;
        v_pack.pol_seq_no      := i.pol_seq_no;
        v_pack.renew_no          := i.renew_no;
        
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;
END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001A - Package Par Listing
**  Description   : Function returns necessary details for package par listing
*/ 
FUNCTION get_gipi_pack_parlist_policy (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
                                       p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
                                       p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
                                       p_user_id         GIIS_USERS.user_id%TYPE,
                                       p_all_user_sw     VARCHAR2,
                                       p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
                                       p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                       p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                       p_assd_name       GIIS_ASSURED.assd_name%TYPE,
                                       p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
                                       p_status          VARCHAR2,
                                       p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
									   p_ri_switch		 VARCHAR2)
  
  RETURN gipi_pack_parlist_tab PIPELINED AS
  
  v_pack            gipi_pack_parlist_type;
  v_iss_cd          giis_issource.iss_cd%TYPE;

BEGIN
    FOR iss IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ISS_CD_RI')
    LOOP
        v_iss_cd := iss.param_value_v;
    END LOOP;
    
    FOR i IN ( SELECT   A.pack_par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                        A.quote_seq_no, A.assd_no, LTRIM(b.assd_name) assd_name, A.underwriter,
                        c.pack_pol_flag, c.line_name, d.bank_ref_no, d.pol_seq_no, 
                        d.renew_no, d.subline_cd, d.issue_yy,
                        Cg_Ref_Codes_Pkg.get_rv_meaning
                                   ('GIPI_PARLIST.PAR_STATUS',A.par_status) status,
                        A.par_type, A.par_status, A.quote_id, A.assign_sw,
                        ESCAPE_VALUE(A.remarks) remarks, 
                        A.line_cd
                        || '-'
                        || A.iss_cd
                        || '-'
                        || TO_CHAR (A.par_yy, '09')
                        || '-'
                        || TO_CHAR (A.par_seq_no, '000009')
                        || '-'
                        || TO_CHAR (A.quote_seq_no, '09') pack_par_no
                                   
                          FROM GIPI_PACK_PARLIST A,
                               GIIS_ASSURED b,
                               GIIS_LINE c,
                               GIPI_PACK_WPOLBAS d
                         WHERE Check_User_Per_Line1 (NVL(p_line_cd, A.line_cd), A.iss_cd, p_user_id, p_module_id) = 1
                           AND Check_User_Per_Iss_Cd1 (NVL(p_line_cd, A.line_cd), A.iss_cd,p_user_id, p_module_id) = 1
                           AND A.par_status < 10
                           AND A.underwriter = DECODE(p_all_user_sw,'Y', a.underwriter, p_user_id)
                           AND A.par_type = 'P'
                           AND c.pack_pol_flag = 'Y'
                           AND A.assd_no = b.assd_no(+)
                           AND A.line_cd = c.line_cd
                           AND A.pack_par_id = d.pack_par_id(+)
                           AND A.line_cd = NVL(p_line_cd, A.line_cd) 
                           AND A.iss_cd LIKE UPPER(NVL (DECODE(p_ri_switch,'Y',v_iss_cd,p_iss_cd), A.iss_cd))
						   AND DECODE(p_ri_switch,'Y','1',A.iss_cd) != DECODE(p_ri_switch,'Y','2',v_iss_cd)
                           AND UPPER(NVL(assd_name, '*')) LIKE UPPER(NVL(p_assd_name, DECODE(assd_name, null, '*', assd_name)))
                           AND UPPER (Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)) LIKE UPPER (NVL(p_status, Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)))
                           AND UPPER (A.par_yy) LIKE UPPER (NVL(p_par_yy,A.par_yy))
                           AND UPPER (A.par_seq_no) LIKE UPPER (NVL(p_par_seq_no, A.par_seq_no))
                           AND UPPER (A.quote_seq_no) LIKE UPPER (NVL(p_quote_seq_no, A.quote_seq_no))
                           AND UPPER (A.underwriter) LIKE UPPER (NVL(p_underwriter, A.underwriter))
                           AND UPPER(NVL(bank_ref_no, '*')) LIKE '%' || UPPER(NVL(p_bank_ref_no, DECODE(bank_ref_no, null, '*', bank_ref_no)))
                ORDER BY    LTRIM(A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.line_name      := i.line_name;
        v_pack.iss_cd         := i.iss_cd;
        v_pack.par_yy         := i.par_yy;
        v_pack.par_seq_no     := i.par_seq_no;
        v_pack.quote_seq_no   := i.quote_seq_no;
        v_pack.quote_id       := i.quote_id;
        v_pack.assd_no        := i.assd_no;
        v_pack.assd_name      := i.assd_name;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id    := i.pack_par_id;
        v_pack.par_status     := i.par_status;
        v_pack.par_type       := i.par_type;
        v_pack.status         := i.status;
        v_pack.assign_sw      := i.assign_sw;
        v_pack.pack_par_no    := i.pack_par_no;
        v_pack.bank_ref_no    := i.bank_ref_no;
        v_pack.subline_cd     := i.subline_cd;
        v_pack.issue_yy       := i.issue_yy;
        v_pack.pol_seq_no     := i.pol_seq_no;
        v_pack.renew_no       := i.renew_no;
        
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;
END;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS058A - Package Endt Par Listing
**  Description   : Function returns necessary details for package par listing(endorsement)
*/ 
FUNCTION get_gipi_pack_parlist_endt  (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
                                      p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
                                      p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
                                      p_user_id         GIIS_USERS.user_id%TYPE,
                                      p_all_user_sw     VARCHAR2,
                                      p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
                                      p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                      p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                      p_assd_name       GIIS_ASSURED.assd_name%TYPE,
                                      p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
                                      p_status          VARCHAR2,
                                      p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
									  p_ri_switch		VARCHAR2)
  
  RETURN gipi_pack_parlist_tab PIPELINED AS
  
  v_pack            gipi_pack_parlist_type;
  v_iss_cd          giis_issource.iss_cd%TYPE;

BEGIN
    FOR iss IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'ISS_CD_RI')
    LOOP
        v_iss_cd := iss.param_value_v;
    END LOOP;
    
    FOR i IN ( SELECT   A.pack_par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                        A.quote_seq_no, A.assd_no, LTRIM(b.assd_name) assd_name, A.underwriter,
                        c.pack_pol_flag, c.line_name, d.bank_ref_no, d.pol_seq_no, 
                        d.renew_no, d.subline_cd, d.issue_yy,
                        Cg_Ref_Codes_Pkg.get_rv_meaning
                                   ('GIPI_PARLIST.PAR_STATUS',A.par_status) status,
                        A.par_type, A.par_status, A.quote_id, A.assign_sw,
                        ESCAPE_VALUE(A.remarks) remarks, 
                        A.line_cd
                        || '-'
                        || A.iss_cd
                        || '-'
                        || TO_CHAR (A.par_yy, '09')
                        || '-'
                        || TO_CHAR (A.par_seq_no, '000009')
                        || '-'
                        || TO_CHAR (A.quote_seq_no, '09') pack_par_no
                                   
                          FROM GIPI_PACK_PARLIST A,
                               GIIS_ASSURED b,
                               GIIS_LINE c,
                               GIPI_PACK_WPOLBAS d
                         WHERE Check_User_Per_Line1 (NVL(p_line_cd, A.line_cd), A.iss_cd, p_user_id, p_module_id) = 1
                           AND Check_User_Per_Iss_Cd1 (NVL(p_line_cd, A.line_cd), A.iss_cd,p_user_id, p_module_id) = 1
                           AND A.par_status < 10
                           AND A.underwriter = DECODE(p_all_user_sw,'Y', a.underwriter, p_user_id)
                           AND A.par_type = 'E'
                           AND c.pack_pol_flag = 'Y'
                           AND A.assd_no = b.assd_no(+)
                           AND A.line_cd = c.line_cd
                           AND A.pack_par_id = d.pack_par_id(+)
                           AND A.line_cd = NVL(p_line_cd, A.line_cd) 
                           AND A.iss_cd LIKE UPPER(NVL (DECODE(p_ri_switch,'Y',v_iss_cd,p_iss_cd), A.iss_cd))
						   AND DECODE(p_ri_switch,'Y','1',A.iss_cd) != DECODE(p_ri_switch,'Y','2',v_iss_cd)
                           AND UPPER(NVL(assd_name, '*')) LIKE UPPER(NVL(p_assd_name, DECODE(assd_name, null, '*', assd_name)))
                           AND UPPER (Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)) LIKE UPPER (NVL(p_status, Cg_Ref_Codes_Pkg.get_rv_meaning
                                                       ('GIPI_PARLIST.PAR_STATUS',A.par_status)))
                           AND UPPER (A.par_yy) LIKE UPPER (NVL(p_par_yy,A.par_yy))
                           AND UPPER (A.par_seq_no) LIKE UPPER (NVL(p_par_seq_no, A.par_seq_no))
                           AND UPPER (A.quote_seq_no) LIKE UPPER (NVL(p_quote_seq_no, A.quote_seq_no))
                           AND UPPER (A.underwriter) LIKE UPPER (NVL(p_underwriter, A.underwriter))
                           AND UPPER(NVL(bank_ref_no, '*')) LIKE '%' || UPPER(NVL(p_bank_ref_no, DECODE(bank_ref_no, null, '*', bank_ref_no)))
                ORDER BY    LTRIM(A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC )
    LOOP
        v_pack.line_cd        := i.line_cd;
        v_pack.line_name      := i.line_name;
        v_pack.iss_cd         := i.iss_cd;
        v_pack.par_yy         := i.par_yy;
        v_pack.par_seq_no     := i.par_seq_no;
        v_pack.quote_seq_no   := i.quote_seq_no;
        v_pack.quote_id       := i.quote_id;
        v_pack.assd_no        := i.assd_no;
        v_pack.assd_name      := i.assd_name;
        v_pack.remarks        := i.remarks;
        v_pack.underwriter    := i.underwriter;    
        v_pack.pack_par_id    := i.pack_par_id;
        v_pack.par_status     := i.par_status;
        v_pack.par_type       := i.par_type;
        v_pack.status         := i.status;
        v_pack.assign_sw      := i.assign_sw;
        v_pack.pack_par_no    := i.pack_par_no;
        v_pack.bank_ref_no    := i.bank_ref_no;
        v_pack.subline_cd     := i.subline_cd;
        v_pack.issue_yy          := i.issue_yy;
        v_pack.pol_seq_no      := i.pol_seq_no;
        v_pack.renew_no          := i.renew_no;
        
      PIPE ROW(v_pack);
    END LOOP;
    RETURN;
END;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 11, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This updates the assd_no in GIPI_PACK_PARLIST whenever. 
**                 assd_no is change in GIPI_PACK_WPOLBAS.
**                 (POST-FORM-COMMIT Trigger of GIPIS002A)               
*/

PROCEDURE update_assd_no
(p_pack_par_id          IN      GIPI_PACK_PARLIST.pack_par_id%TYPE,
 p_assd_no              IN      GIPI_PACK_PARLIST.assd_no%TYPE)
 
IS

BEGIN
    FOR B IN(SELECT assd_no
               FROM gipi_pack_parlist
              WHERE pack_par_id = p_pack_par_id)
    LOOP
        
        IF b.assd_no != p_assd_no THEN
          UPDATE gipi_pack_parlist
            SET assd_no = p_assd_no
          WHERE pack_par_id = p_pack_par_id;
        END IF;
        
    END LOOP;
END;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.20.2011
**  Reference By  : 
**  Description   : Get Pack Par No of a given pack_par_id
*/
FUNCTION get_pack_par_no (p_pack_par_id NUMBER)
  RETURN VARCHAR2
IS
  v_par_no   VARCHAR2 (40);
BEGIN
  FOR a IN (SELECT    line_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (par_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (par_seq_no, '099999'))
                   || '-'
                   || LTRIM (TO_CHAR (quote_seq_no, '09')) par_no
              FROM gipi_pack_parlist
             WHERE pack_par_id = p_pack_par_id)
  LOOP
     v_par_no := a.par_no;
     EXIT;
  END LOOP;

  RETURN (v_par_no);
END get_pack_par_no; 

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011  
  **  Reference By : (GIPIS055a - POST PACKAGE PAR) 
  **  Description  : check_package_cancellation program unit 
  */   
    PROCEDURE check_package_cancellation (
        p_ann_tsi           OUT NUMBER,
        p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE
        ) IS
        v_line_cd 				gipi_pack_wpolbas.line_cd%TYPE;
        v_subline_cd			gipi_pack_wpolbas.subline_cd%TYPE;
        v_iss_cd			    gipi_pack_wpolbas.iss_cd%TYPE;
        v_issue_yy				gipi_pack_wpolbas.issue_yy%TYPE;
        v_pol_seq_no			gipi_pack_wpolbas.pol_seq_no%TYPE;
        v_renew_no				gipi_pack_wpolbas.renew_no%TYPE;
        v_ann_tsi			    gipi_item.ann_tsi_amt%TYPE;
        v_ann_tsi2				gipi_item.ann_tsi_amt%TYPE;
    BEGIN
        /*  Retrieves the line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no
        **  renew_no of the package policy.
        */
      
      FOR pack IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM gipi_pack_wpolbas
                    WHERE pack_par_id = p_pack_par_id)
      LOOP
          v_line_cd 			:= pack.line_cd;
          v_subline_cd		    := pack.subline_cd;
          v_iss_cd				:= pack.iss_cd;
          v_issue_yy			:= pack.issue_yy;
          v_pol_seq_no		    := pack.pol_seq_no;
          v_renew_no			:= pack.renew_no;
        END LOOP;
      
      
      /*  Retrieves record of the subpolicies of the
      **  given package policy from gipi_item
      */
      
      FOR sub IN (SELECT SUM(tsi_amt) ann_tsi
                    FROM gipi_item
                   WHERE policy_id IN (SELECT policy_id
                                         FROM gipi_polbasic
                                        WHERE 1=1
                                          AND pol_flag NOT IN ('4','5','X')
                                          AND	pack_policy_id IN (SELECT pack_policy_id
                                                                     FROM gipi_pack_polbasic
                                                                    WHERE line_cd = v_line_cd
                                                                      AND subline_cd = v_subline_cd
                                                                      AND iss_cd = v_iss_cd
                                                                      AND issue_yy = v_issue_yy
                                                                      AND pol_seq_no = v_pol_seq_no
                                                                      AND renew_no = v_renew_no)))
      LOOP 
        v_ann_tsi := sub.ann_tsi;
      END LOOP;
      

      FOR par IN (SELECT SUM(tsi_amt) ann_tsi
                    FROM gipi_witem
                   WHERE par_id IN (SELECT par_id
                                      FROM gipi_wpolbas
                                     WHERE pack_par_id = p_pack_par_id))
      LOOP
        v_ann_tsi2 := NVL(par.ann_tsi,0);
      END LOOP; 			
      p_ann_tsi := v_ann_tsi + NVL(v_ann_tsi2, 0);  --NVL added by d.alcantara, 03-19-2012
    END;
	
	FUNCTION get_pack_parlist_giuts008a (
		p_policy_id		gipi_pack_polbasic.pack_policy_id%TYPE
	)
     	RETURN pack_parlist_giuts008a_tab PIPELINED
	IS
		v_res	 pack_parlist_giuts008a_type;
	BEGIN
		FOR i IN(SELECT a.line_cd,a.iss_cd,TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)) par_yy,b.par_type,
			       		b.assd_no,'Y',5,b.address1, b.address2, b.address3,'C'
     		  	   FROM gipi_pack_polbasic a, gipi_pack_parlist b
     		 	  WHERE a.pack_policy_id = p_policy_id 
			   		AND a.pack_par_id = b.pack_par_id)
		LOOP
			v_res.line_cd := i.line_cd;
			v_res.iss_cd := i.iss_cd;
			v_res.par_yy := i.par_yy;
			v_res.par_type := i.par_type;
			v_res.assd_no := i.assd_no;
			v_res.address1 := i.address1;
			v_res.address2 := i.address2;
			v_res.address3 := i.address3;
		END LOOP;
		
		FOR j IN(SELECT iss_cd
		           FROM gipi_polbasic
                  WHERE pack_policy_id = p_policy_id)
		LOOP
			v_res.pol_iss_cd := j.iss_cd;
		END LOOP;				  
		
		PIPE ROW(v_res);
	END;
	
	PROCEDURE insert_pack_parlist_giuts008a (
		p_pack_par_id	IN	gipi_pack_parlist.pack_par_id%TYPE,
		p_line_cd		IN	gipi_pack_parlist.line_cd%TYPE,
		p_iss_cd		IN	gipi_pack_parlist.iss_cd%TYPE,
		p_par_yy		IN	gipi_pack_parlist.par_yy%TYPE,
		p_par_type		IN	gipi_pack_parlist.par_type%TYPE,
		p_assd_no		IN	gipi_pack_parlist.assd_no%TYPE,
		p_underwriter	IN	gipi_pack_parlist.underwriter%TYPE,
		p_address1		IN	gipi_pack_parlist.address1%TYPE,
		p_address2		IN	gipi_pack_parlist.address2%TYPE,
		p_address3		IN	gipi_pack_parlist.address3%TYPE
	) IS
	BEGIN
		INSERT INTO gipi_pack_parlist
					(pack_par_id,line_cd,iss_cd,par_yy,quote_seq_no,par_type,assd_no,underwriter,
					 assign_sw,par_status,address1,address2,address3)
			 VALUES (p_pack_par_id,p_line_cd,p_iss_cd,p_par_yy,0,p_par_type,p_assd_no,p_underwriter,
			 		 'Y',5,p_address1,p_address2,p_address3);
		INSERT INTO gipi_pack_parhist
					(pack_par_id,user_id,parstat_date,entry_source,parstat_cd)
             VALUES (p_pack_par_id,p_underwriter,SYSDATE,'DB','1');
	END;
    
    /*
    **  Created by    : Steven Ramirez
    **  Date Created  : 10.17.2013
    **  Reference By  : GIPIS095 - Package Policy Items
    **  Description   : check if the select item has an existing peril.
    */ 
    FUNCTION check_pack_peril (
      p_item_no   gipi_witmperl.item_no%TYPE,
      p_par_id    gipi_witmperl.par_id%TYPE
   )
      RETURN NUMBER
   IS
      x   NUMBER (5);
   BEGIN
      SELECT DISTINCT a.item_no
                 INTO x
                 FROM gipi_witmperl a
                WHERE item_no = p_item_no AND par_id = p_par_id;

      RETURN x;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;
	
END Gipi_Pack_Parlist_Pkg;
/



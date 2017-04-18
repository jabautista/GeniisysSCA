CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WCASUALTY_PERSONNEL_PKG
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    05.04.2010    Jerome Orio        Get PAR record listing for PERSONNEL INFO 
    **                                Reference By : (GIPIS011- Item Information - Casualty - Personnel Info)
    **    12.14.2011    mark jm            added ESCAPE_VALUE_CLOB
    */
    FUNCTION get_gipi_wcasualty_personnels(p_par_id IN GIPI_WCASUALTY_PERSONNEL.par_id%TYPE)
    RETURN gipi_wcasualty_personnel_tab PIPELINED IS
        v_per    gipi_wcasualty_personnel_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.personnel_no,
                   a.name,            a.include_tag,    a.capacity_cd,
                   a.amount_covered,a.remarks,        a.delete_sw,
                   b.position 
              FROM gipi_wcasualty_personnel a,
                   giis_position b
             WHERE a.par_id = p_par_id
               AND a.capacity_cd = b.position_cd(+)
          ORDER BY par_id, item_no, personnel_no)     
        LOOP
            v_per.par_id            := i.par_id;
            v_per.item_no            := i.item_no;
            v_per.personnel_no        := i.personnel_no;
            v_per.name                := i.name;
            v_per.include_tag        := i.include_tag;
            v_per.capacity_cd        := i.capacity_cd;
            v_per.amount_covered    := i.amount_covered;
            v_per.remarks            := i.remarks; -- ESCAPE_VALUE_CLOB(i.remarks); changed by robert 09232013
            v_per.delete_sw            := i.delete_sw;
            v_per.capacity_desc        := i.position;   
            PIPE ROW(v_per);
        END LOOP;
        RETURN; 
    END;    
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.04.2010  
    **  Reference By     : (GIPIS011- Item Information - Casualty - Personnel Info)   
    **  Description     : Insert PAR record listing for PERSONNEL INFO        
    */    
  PROCEDURE set_gipi_wcasualty_personnels(
              p_par_id                GIPI_WCASUALTY_PERSONNEL.par_id%TYPE,
            p_item_no                GIPI_WCASUALTY_PERSONNEL.item_no%TYPE,
            p_personnel_no            GIPI_WCASUALTY_PERSONNEL.personnel_no%TYPE,
            p_name                    GIPI_WCASUALTY_PERSONNEL.name%TYPE,
            p_include_tag            GIPI_WCASUALTY_PERSONNEL.include_tag%TYPE,
            p_capacity_cd            GIPI_WCASUALTY_PERSONNEL.capacity_cd%TYPE,
            p_amount_covered        GIPI_WCASUALTY_PERSONNEL.amount_covered%TYPE,
            p_remarks                GIPI_WCASUALTY_PERSONNEL.remarks%TYPE
              )
        IS    
  BEGIN
         MERGE INTO GIPI_WCASUALTY_PERSONNEL
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no
                    AND personnel_no = p_personnel_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                   item_no,         personnel_no,
                       name,                 include_tag,      capacity_cd,
                    amount_covered,     remarks                
                   )
            VALUES (p_par_id,               p_item_no,          p_personnel_no,
                       p_name,             p_include_tag,      p_capacity_cd,
                    p_amount_covered,     p_remarks                          
                    )
        WHEN MATCHED THEN
            UPDATE SET 
                       name                 = p_name,                 
                    include_tag            = p_include_tag,      
                    capacity_cd            = p_capacity_cd,
                    amount_covered        = p_amount_covered,     
                    remarks                = p_remarks;
  END;
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.04.2010  
    **  Reference By     : (GIPIS011- Item Information - Casualty - Personnel Info)   
    **  Description     : Delete per item no PAR record listing for PERSONNEL INFO        
    */    
  PROCEDURE del_gipi_wcasualty_personnel(
              p_par_id    GIPI_WCASUALTY_PERSONNEL.par_id%TYPE,
              p_item_no   GIPI_WCASUALTY_PERSONNEL.item_no%TYPE
            )
        IS
  BEGIN
    DELETE GIPI_WCASUALTY_PERSONNEL
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;                        
    
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.04.2010  
    **  Reference By     : (GIPIS011- Item Information - Casualty - Personnel Info)   
    **  Description     : Delete per Item no and Personnel No PAR record listing for PERSONNEL INFO        
    */    
  PROCEDURE del_gipi_wcasualty_personnel2(
              p_par_id       GIPI_WCASUALTY_PERSONNEL.par_id%TYPE,
              p_item_no      GIPI_WCASUALTY_PERSONNEL.item_no%TYPE,
            p_personnel_no GIPI_WCASUALTY_PERSONNEL.personnel_no%TYPE
            )
        IS
  BEGIN
    DELETE GIPI_WCASUALTY_PERSONNEL
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND personnel_no = p_personnel_no;
  END;                    

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve rows from gipi_casualty_personnel based on the given parameters
    */
    FUNCTION get_gipi_wcas_prsnnel_pack_pol (
        p_par_id IN gipi_wcasualty_personnel.par_id%TYPE,
        p_item_no IN gipi_wcasualty_personnel.item_no%TYPE)
    RETURN gipi_wcasualty_personnel_tab PIPELINED
    IS
        v_cas_per    gipi_wcasualty_personnel_type;    
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wcasualty_personnel
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_cas_per.par_id    := i.par_id;
            v_cas_per.item_no    := i.item_no;
            
            PIPE ROW(v_cas_per);
        END LOOP;
        
        RETURN;
    END get_gipi_wcas_prsnnel_pack_pol;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    09.14.2011    mark jm            retrieve records on gipi_wcasualty_personnel based on given parameters (tablegrid varsion)
    */
    FUNCTION get_gipi_wcas_pers_tg(
        p_par_id IN gipi_wcasualty_personnel.par_id%TYPE,
        p_item_no IN gipi_wcasualty_personnel.item_no%TYPE,
        p_name IN VARCHAR2,
        p_position IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_wcasualty_personnel_tab PIPELINED
    IS
        v_per gipi_wcasualty_personnel_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.personnel_no,
                   a.name,            a.include_tag,    a.capacity_cd,
                   a.amount_covered,a.remarks,        a.delete_sw,
                   b.position 
              FROM gipi_wcasualty_personnel a,
                   giis_position b
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.capacity_cd = b.position_cd(+)
               AND UPPER(a.name) LIKE NVL(UPPER(p_name), '%%')
               AND UPPER(NVL(b.position, '***')) LIKE NVL(UPPER(p_position), '%%')
               AND UPPER(NVL(a.remarks, '***')) LIKE NVL(UPPER(p_remarks), '%%')
          ORDER BY par_id, item_no, personnel_no)     
        LOOP
            v_per.par_id            := i.par_id;
            v_per.item_no            := i.item_no;
            v_per.personnel_no        := i.personnel_no;
            v_per.name                := i.name;
            v_per.include_tag        := i.include_tag;
            v_per.capacity_cd        := i.capacity_cd;
            v_per.amount_covered    := i.amount_covered;
            v_per.remarks            := i.remarks; -- ESCAPE_VALUE_CLOB(i.remarks); changed by robert 09232013
            v_per.delete_sw            := i.delete_sw;
            v_per.capacity_desc        := i.position;
            
            PIPE ROW(v_per);
        END LOOP;
        RETURN; 
    END get_gipi_wcas_pers_tg;    
END;
/



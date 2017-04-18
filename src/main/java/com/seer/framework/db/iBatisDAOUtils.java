/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.apache.log4j.Logger;
import org.springframework.util.ClassUtils;

/**
 * The Class iBatisDAOUtils.
 * @author Bobby Diaz
 * @version 1.0
 * Updated the class to implement GenericDao by Bryan Noll.
 * This class used to be named BaseDaoiBATIS.
 */
public class iBatisDAOUtils {
    
    /** The Constant log. */
    protected static final Logger log = Logger.getLogger(iBatisDAOUtils.class);
    
    /**
     * Gets the primary key field name.
     * 
     * @param o the o
     * 
     * @return the primary key field name
     */
    protected static String getPrimaryKeyFieldName(Object o) {
        Field fieldlist[] = o.getClass().getDeclaredFields();
        String fieldName = null;
        for (int i = 0; i < fieldlist.length; i++) {
            Field fld = fieldlist[i];
            if (fld.getName().equals("id") || fld.getName().indexOf("Id") > -1 || fld.getName().equals("version")) {
                fieldName = fld.getName();
                break;
            }
        }
        return fieldName;
    }

    /**
     * Gets the primary key value.
     * 
     * @param o the o
     * 
     * @return the primary key value
     */
    protected static Object getPrimaryKeyValue(Object o) {
        // Use reflection to find the first property that has the name "id" or "Id"
        String fieldName = getPrimaryKeyFieldName(o);
        String getterMethod = "get" + Character.toUpperCase(fieldName.charAt(0)) + fieldName.substring(1); 
        
        try {
            Method getMethod = o.getClass().getMethod(getterMethod, null);
            return getMethod.invoke(o, null);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Could not invoke method '" + getterMethod + "' on " + ClassUtils.getShortName(o.getClass()));
        }
        return null;
    }
    
    /**
     * Prepare object for save or update.
     * 
     * @param o the o
     */
    protected static void prepareObjectForSaveOrUpdate(Object o) {
        try {
            Field fieldlist[] = o.getClass().getDeclaredFields();
            for (int i = 0; i < fieldlist.length; i++) {
                Field fld = fieldlist[i];
                String fieldName = fld.getName();
                if (fieldName.equals("version")) {
                    Method setMethod = o.getClass().getMethod("setVersion", new Class[]{Integer.class});
                    Object value = o.getClass().getMethod("getVersion", null).invoke(o, null);
                    if (value == null) {
                        setMethod.invoke(o, new Object[]{new Integer(1)});
                    } else {
                        setMethod.invoke(o, new Object[]{new Integer(((Integer) value).intValue()+1)});
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Could not prepare '" + ClassUtils.getShortName(o.getClass()) + "' for insert/update");
        }
    }

    /**
     * Gets the select query.
     * 
     * @param className the class name
     * 
     * @return Returns the select query name.
     */
    public static String getSelectQuery(String className) {
        return "get" + className + "s";
    }

    /**
     * Gets the find query.
     * 
     * @param className the class name
     * 
     * @return Returns the find query name.
     */
    public static String getFindQuery(String className) {
        return "get" + className;
    }

    /**
     * Gets the insert query.
     * 
     * @param className the class name
     * 
     * @return Returns the insert query name.
     */
    public static String getInsertQuery(String className) {
        return "add" + className;
    }

    /**
     * Gets the update query.
     * 
     * @param className the class name
     * 
     * @return Returns the update query name.
     */
    public static String getUpdateQuery(String className) {
        return "update" + className;
    }

    /**
     * Gets the delete query.
     * 
     * @param className the class name
     * 
     * @return Returns the delete query name.
     */
    public static String getDeleteQuery(String className) {
        return "delete" + className;
    }
}

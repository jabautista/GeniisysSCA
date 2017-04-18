/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.util.ClassUtils;

/**
 * The Class GenericDAOiBatis.
 * 
 * @param <T> the generic type
 * @author Bobby Diaz
 * @version 1.0
 * 
 * Updated the class to implement GenericDao by Bryan Noll.
 * This class used to be named BaseDaoiBATIS.
 */
@SuppressWarnings("unchecked")
public class GenericDAOiBatis<T extends Entity> 
     extends SqlMapClientDaoSupport 
  implements GenericDAO<T> {
    
    /** The log. */
    protected final Log log = LogFactory.getLog(getClass());
    
    /** The persistent class. */
    private Class<T> persistentClass;
    
    
    /**
     * Instantiates a new generic da oi batis.
     * 
     * @param persistentClass the persistent class
     */
    public GenericDAOiBatis(Class<T> persistentClass) {
        this.persistentClass = persistentClass;
    }

    /* (non-Javadoc)
     * @see com.seer.framework.util.GenericDAO#findAll()
     */
    public List<T> findAll() {
        return getSqlMapClientTemplate().queryForList(iBatisDAOUtils.getSelectQuery(ClassUtils.getShortName(this.persistentClass)), null);
    }

    /* (non-Javadoc)
     * @see com.seer.framework.util.GenericDAO#findById(java.lang.Object)
     */
    public T findById(Object id) {
    	System.out.println("FINDBY ID: " + id);
        T object = (T)getSqlMapClientTemplate().queryForObject(iBatisDAOUtils.getFindQuery(ClassUtils.getShortName(this.persistentClass)), id);
        if (object == null) {
            throw new ObjectRetrievalFailureException(ClassUtils.getShortName(this.persistentClass), id);
        }
        return object;
    }

    /* (non-Javadoc)
     * @see com.seer.framework.util.GenericDAO#save(com.seer.framework.util.Entity)
     */
    public void save(final T object) {
        String className = ClassUtils.getShortName(object.getClass());

        Object primaryKey = iBatisDAOUtils.getPrimaryKeyValue(object);
        
        @SuppressWarnings("unused")
		String keyId = null;

        // check for null id
        if (primaryKey != null) {
            keyId = primaryKey.toString();
        }
        
        // check for new record
        if (object.isNew) {  
            iBatisDAOUtils.prepareObjectForSaveOrUpdate(object);
            primaryKey = getSqlMapClientTemplate().insert(iBatisDAOUtils.getInsertQuery(className), object);

            // check for null id
            if (primaryKey != null) {
                keyId = primaryKey.toString();
            }
        } else {
            iBatisDAOUtils.prepareObjectForSaveOrUpdate(object);
            getSqlMapClientTemplate().update(iBatisDAOUtils.getUpdateQuery(className), object);
        }

        // check for null id
        if (iBatisDAOUtils.getPrimaryKeyValue(object) == null) {
            throw new ObjectRetrievalFailureException(className, object);
        }
    }

    /* (non-Javadoc)
     * @see com.seer.framework.util.GenericDAO#delete(com.seer.framework.util.Entity)
     */
    public void delete(final T object) {
        getSqlMapClientTemplate().delete(iBatisDAOUtils.getDeleteQuery(ClassUtils.getShortName(this.persistentClass)), object);
    }
    }

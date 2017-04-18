/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.log4j.Logger;



/**
 * The Class BaseBean.
 */
public class BaseBean {
	
	/** The log. */
	protected static Logger log = Logger.getLogger(BaseBean.class);

	/** The request id. */
	private String requestId;
	
	/** The status. */
	private String status;

	/**
	 * Instantiates a new base bean.
	 */
	public BaseBean() {
	}

	/**
	 * Inits the.
	 */
	protected void init() {
	}

	/**
	 * Creates the object from bean.
	 * 
	 * @param objectBean the object bean
	 * @param object the object
	 * 
	 * @throws Exception if any error occurs during the execution of the method
	 */
	public static void createObjectFromBean(Object objectBean, Object object)
			throws java.lang.Exception {
		try {
			// commented out by Jason, changed to PropertyUtils.copyProperties()
			// BeanUtils.copyProperties(objectBean, object);
			PropertyUtils.copyProperties(objectBean, object);
		} catch (Exception e) {
			throw new Exception("Could not populate object from bean "
					+ e.toString(), e);
		}
	}
 
	/**
	 * Creates the bean from object.
	 * 
	 * @param object the object
	 * @param objectBean the object bean
	 * 
	 * @throws Exception if any error occurs during the execution of the method
	 */
	public static void createBeanFromObject(Object object, Object objectBean)
			throws java.lang.Exception {
		try {
			// commented out by Jason, changed to PropertyUtils.copyProperties()
			// BeanUtils.copyProperties(object, objectBean);
			PropertyUtils.copyProperties(object, objectBean);
		} catch (Exception e) {
			throw new Exception("Could not populate bean from object "
					+ e.toString(), e);
		}
	}

	/**
	 * Save status.
	 * 
	 * @return the int
	 */
	public int saveStatus() {
		return 0;
	}
	
	/**
	 * Gets the status.
	 * 
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * Sets the status.
	 * 
	 * @param status the new status
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * Gets the request id.
	 * 
	 * @return the request id
	 */
	public String getRequestId() {
		return requestId;
	}

	/**
	 * Sets the request id.
	 * 
	 * @param requestId the new request id
	 */
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}



}

/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.entity.LOV;



/**
 * The Interface LOVDAO.
 */
public interface LOVDAO {

	/**
	 * Gets the list refcodes.
	 * 
	 * @param domain the domain
	 * @param args the args
	 * @return the list refcodes
	 * @throws SQLException the sQL exception
	 */
	public List<LOV> getListREFCODES(String domain, String[] args) throws SQLException;
	
	/**
	 * Gets the list packages.
	 * 
	 * @param domain the domain
	 * @param args the args
	 * @return the list packages
	 * @throws SQLException the sQL exception
	 */
	public List<LOV> getListPACKAGES(String domain, String[] args) throws SQLException;
	
}

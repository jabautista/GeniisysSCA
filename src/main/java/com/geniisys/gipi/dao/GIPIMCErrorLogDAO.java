/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIMCErrorLog;


/**
 * The Interface GIPIMCErrorLogDAO.
 */
public interface GIPIMCErrorLogDAO {

	/**
	 * Gets the gipi mc error list.
	 * 
	 * @param fileName the file name
	 * @return the gipi mc error list
	 * @throws SQLException the sQL exception
	 */
	List<GIPIMCErrorLog> getGipiMCErrorList(String fileName) throws SQLException;
	
}

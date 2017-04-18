/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.entity.GIISTransaction;


/**
 * The Interface GIISTransactionService.
 */
public interface GIISTransactionService {

	/**
	 * Gets the giis transaction list.
	 * 
	 * @return the giis transaction list
	 * @throws SQLException the sQL exception
	 */
	List<GIISTransaction> getGiisTransactionList() throws SQLException;
}

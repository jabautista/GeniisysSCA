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

import com.geniisys.common.entity.GIISGrpIsSource;


/**
 * The Interface GIISGrpIsSourceService.
 */
public interface GIISGrpIsSourceService {

	/**
	 * Gets the grp is source all list.
	 * 
	 * @return the grp is source all list
	 * @throws SQLException the sQL exception
	 */
	List<GIISGrpIsSource> getGrpIsSourceAllList() throws SQLException;
	
}

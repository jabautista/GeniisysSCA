/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.dao.GIISGrpIsSourceDAO;
import com.geniisys.common.entity.GIISGrpIsSource;
import com.geniisys.common.service.GIISGrpIsSourceService;


/**
 * The Class GIISGrpIsSourceServiceImpl.
 */
public class GIISGrpIsSourceServiceImpl implements GIISGrpIsSourceService {

	/** The giis grp is source dao. */
	private GIISGrpIsSourceDAO giisGrpIsSourceDAO;
	
	/**
	 * Gets the giis grp is source dao.
	 * 
	 * @return the giis grp is source dao
	 */
	public GIISGrpIsSourceDAO getGiisGrpIsSourceDAO() {
		return giisGrpIsSourceDAO;
	}
	
	/**
	 * Sets the giis grp is source dao.
	 * 
	 * @param giisGrpIsSourceDAO the new giis grp is source dao
	 */
	public void setGiisGrpIsSourceDAO(GIISGrpIsSourceDAO giisGrpIsSourceDAO) {
		this.giisGrpIsSourceDAO = giisGrpIsSourceDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISGrpIsSourceService#getGrpIsSourceAllList()
	 */
	@Override
	public List<GIISGrpIsSource> getGrpIsSourceAllList() throws SQLException {
		return this.getGiisGrpIsSourceDAO().getGrpIsSourceAllList();
	}

}

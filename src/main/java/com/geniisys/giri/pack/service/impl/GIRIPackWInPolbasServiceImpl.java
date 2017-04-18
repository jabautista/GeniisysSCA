/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giri.pack.service.impl
	File Name: GIRIPackWInPolbasService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 6, 2012
	Description: 
*/


package com.geniisys.giri.pack.service.impl;

import java.sql.SQLException;

import com.geniisys.giri.dao.GIRIPackWInPolbasDAO;
import com.geniisys.giri.entity.GIRIPackWInPolbas;
import com.geniisys.giri.pack.service.GIRIPackWInPolbasService;

public class GIRIPackWInPolbasServiceImpl implements GIRIPackWInPolbasService{

	private GIRIPackWInPolbasDAO giriPackWInPolbasDAO;
	
	
	/**
	 * @return the giriPackWInPolbasDAO
	 */
	public GIRIPackWInPolbasDAO getGiriPackWInPolbasDAO() {
		return giriPackWInPolbasDAO;
	}


	/**
	 * @param giriPackWInPolbasDAO the giriPackWInPolbasDAO to set
	 */
	public void setGiriPackWInPolbasDAO(GIRIPackWInPolbasDAO giriPackWInPolbasDAO) {
		this.giriPackWInPolbasDAO = giriPackWInPolbasDAO;
	}


	@Override
	public GIRIPackWInPolbas getGiriPackWInPolbas(Integer packParId)
			throws SQLException {
		return getGiriPackWInPolbasDAO().getGiriPackWInPolbas(packParId); 
	}

}

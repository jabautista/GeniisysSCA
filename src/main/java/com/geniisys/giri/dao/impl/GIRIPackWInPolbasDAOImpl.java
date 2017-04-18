/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giri.dao.impl
	File Name: GIRIPackWInPolbasDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 1, 2012
	Description: 
*/


package com.geniisys.giri.dao.impl;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.giri.dao.GIRIPackWInPolbasDAO;
import com.geniisys.giri.entity.GIRIPackWInPolbas;

public class GIRIPackWInPolbasDAOImpl extends DAOImpl implements GIRIPackWInPolbasDAO{
	private static Logger log = Logger.getLogger(GIPICoInsurer.class);
	@Override
	public void saveGiriPackWInpolbas(GIRIPackWInPolbas giriPackWInPolbas)
			throws SQLException {
		log.info("Saving records to GIRI_PACK_WINPOLBAS...");
			/*this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			removed start transaction because this method can be called in other methods with transaction */  
		this.getSqlMapClient().update("setGIRIPackWInPolbas", giriPackWInPolbas);
		
		
	}

	@Override
	public Integer getNewPackAcceptNo() throws SQLException {
		log.info("Getting pack accept no...");
		return (Integer) this.getSqlMapClient().queryForObject("getNewPackAcceptNo");
	}

	@Override
	public GIRIPackWInPolbas getGiriPackWInPolbas(Integer packParId)
			throws SQLException {
		log.info("GETTING GIRI_PACK_WINPOLBAS DETAILS FOR PACK PAR ID : "+packParId);
		return (GIRIPackWInPolbas) getSqlMapClient().queryForObject("getGiriPackWInPolbas",packParId);
	}

}

/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIWinvperlDAO;
import com.geniisys.gipi.entity.GIPIWinvperl;
import com.geniisys.gipi.service.GIPIWinvperlFacadeService;
import org.apache.log4j.Logger;


/**
 * The Class GIPIWinvperlFacadeServiceImpl.
 */
public class GIPIWinvperlFacadeServiceImpl implements GIPIWinvperlFacadeService {

/** The gipi winvperl dao. */
private GIPIWinvperlDAO  gipiWinvperlDao;
	
	/**
	 * Sets the gipi winvperl dao.
	 * 
	 * @param gipiWinvperlDAO the new gipi winvperl dao
	 */
	public void setGipiWinvperlDAO(GIPIWinvperlDAO gipiWinvperlDAO) {
		this.gipiWinvperlDao = gipiWinvperlDAO;
	}
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvperlFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi winvperl dao.
	 * 
	 * @return the gipi winvperl dao
	 */
	public GIPIWinvperlDAO getGipiWinvperlDAO() {
		return gipiWinvperlDao;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvperlFacadeService#getGIPIWinvperl(int, int, java.lang.String)
	 */
	@Override
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, int itemGrp, String lineCd) throws SQLException {
		log.info("Retrieving WInvperl...");
		List<GIPIWinvperl> gipiWinvperl = gipiWinvperlDao.getGIPIWinvperl(parId, itemGrp, lineCd);
		log.info("Winvperl Size():" + gipiWinvperl.size());
		return gipiWinvperl;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvperlFacadeService#getItemGrpWinvperl(int)
	 */
	@Override
	public List<GIPIWinvperl> getItemGrpWinvperl(int parId)throws SQLException {
		log.info("Retrieving Distinct WInvperl...");
		List<GIPIWinvperl> gipiWinvperl = gipiWinvperlDao. getItemGrpWinvperl(parId);
		log.info(" Distinct Winvperl Size():" + gipiWinvperl.size());
		return gipiWinvperl;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvperlFacadeService#getTakeupWinvperl(int)
	 */
	@Override
	public List<GIPIWinvperl> getTakeupWinvperl(int parId)throws SQLException {
		log.info("Retrieving Distinct takeup WInvperl...");
		List<GIPIWinvperl> gipiWinvperl = gipiWinvperlDao. getTakeupWinvperl(parId);
		log.info(" Distinct takeup Winvoice Size():" + gipiWinvperl.size());
		return gipiWinvperl;
	}

	@Override
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, String lineCd)
			throws SQLException {
		// TODO Auto-generated method stub
		List<GIPIWinvperl> gipiWinvperl = gipiWinvperlDao.getGIPIWinvperl(parId, lineCd);		
		return gipiWinvperl;
	}
	

}

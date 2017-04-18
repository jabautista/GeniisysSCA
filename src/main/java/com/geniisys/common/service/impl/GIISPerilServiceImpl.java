/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.dao.GIISPerilDAO;
import com.geniisys.common.entity.GIISPeril;
import com.geniisys.common.service.GIISPerilService;


/**
 * The Class GIISPerilServiceImpl.
 */
public class GIISPerilServiceImpl implements GIISPerilService {
	
	/** The giis peril dao. */
	private GIISPerilDAO giisPerilDAO;

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISPerilService#checkIfPerilExists(java.lang.String, java.lang.String)
	 */
	@Override
	public String checkIfPerilExists(String nbtSublineCd, String lineCd)
			throws SQLException {
		System.out.println(this.getGiisPerilDAO().checkIfPerilExists(nbtSublineCd, lineCd) );
		return this.getGiisPerilDAO().checkIfPerilExists(nbtSublineCd, lineCd);
	}

	/**
	 * Sets the giis peril dao.
	 * 
	 * @param giisPerilDAO the new giis peril dao
	 */
	public void setGiisPerilDAO(GIISPerilDAO giisPerilDAO) {
		this.giisPerilDAO = giisPerilDAO;
	}

	/**
	 * Gets the giis peril dao.
	 * 
	 * @return the giis peril dao
	 */
	public GIISPerilDAO getGiisPerilDAO() {
		return giisPerilDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISPerilService#getDefaultPerils(java.util.Map)
	 */
	@Override
	public List<GIISPeril> getDefaultPerils(Map<String, Object> params)
			throws SQLException {
		return this.getGiisPerilDAO().getDefaultPerils(params);
	}

	@Override
	public String getDefaultRate(String perilCd, String lineCd)
			throws SQLException {
		System.out.println(this.getGiisPerilDAO().getDefaultRate(perilCd, lineCd));
		return this.getGiisPerilDAO().getDefaultRate(perilCd, lineCd);
	}

	public List<GIISPeril> getPackPlanPerils(Map<String, Object> params)
			throws SQLException {
		return this.getGiisPerilDAO().getPackPlanPerils(params);
	}
	
	public String getDefPerilAmts(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd") == "" ? null : Integer.parseInt(request.getParameter("perilCd")));
		params.put("tsiAmt", request.getParameter("tsiAmt") == "" ? "0" : new BigDecimal(request.getParameter("tsiAmt")));
		params.put("coverageCd", request.getParameter("coverageCd") == "" ? null : Integer.parseInt(request.getParameter("coverageCd")));
		params.put("sublineTypeCd", request.getParameter("sublineTypeCd"));
		params.put("motortypeCd", request.getParameter("motortypeCd") == "" ? null : Integer.parseInt(request.getParameter("motortypeCd")));
		params.put("tariffZone", request.getParameter("tariffZone"));
		params.put("tarfCd", request.getParameter("tarfCd"));
		params.put("constructionCd", request.getParameter("constructionCd"));
		return this.giisPerilDAO.getDefPerilAmts(params);
	}

	@Override
	public String chkIfTariffPerilExsts(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("itemNo", request.getParameter("itemNo") == "" ? null : Integer.parseInt(request.getParameter("itemNo")));
		return this.giisPerilDAO.chkIfTariffPerilExsts(params);
	}
	
	@Override
	public String chkPerilZoneType(HttpServletRequest request) throws SQLException {	//Gzelle 05252015 SR4347
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parPolId", Integer.parseInt(request.getParameter("parPolId")));
		params.put("itemNo", request.getParameter("itemNo") == "" ? null : Integer.parseInt(request.getParameter("itemNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		return this.giisPerilDAO.chkPerilZoneType(params);
	}
	
}

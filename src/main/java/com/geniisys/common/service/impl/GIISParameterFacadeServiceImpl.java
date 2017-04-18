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
import java.util.Map;

import com.geniisys.common.dao.GIISParameterDAO;
import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.service.GIISParameterFacadeService;

/**
 * The Class GIISParameterFacadeServiceImpl.
 */
public class GIISParameterFacadeServiceImpl implements GIISParameterFacadeService {

	/** The giis parameter dao. */
	private GIISParameterDAO giisParameterDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getParamValueV(java.lang.String)
	 */
	@Override
	public GIISParameter getParamValueV(String paramName)
			throws SQLException {
		return this.getGiisParameterDAO().getParamValueV(paramName);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getParamValueV2(java.lang.String)
	 */
	@Override
	public String getParamValueV2(String paramName)
			throws SQLException {
		return this.getGiisParameterDAO().getParamValueV2(paramName);
	}
	
	/**
	 * Sets the giis parameter dao.
	 * 
	 * @param giisParameterDAO the new giis parameter dao
	 */
	public void setGiisParameterDAO(GIISParameterDAO giisParameterDAO) {
		this.giisParameterDAO = giisParameterDAO;
	}

	/**
	 * Gets the giis parameter dao.
	 * 
	 * @return the giis parameter dao
	 */
	public GIISParameterDAO getGiisParameterDAO() {
		return giisParameterDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getParamValueN(java.lang.String)
	 */
	@Override
	public Integer getParamValueN(String paramName1) throws SQLException {
		return this.giisParameterDAO.getParamValueN(paramName1);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getParamValues(java.lang.String)
	 */
	@Override
	public List<GIISParameter> getParamValues(String paramName)
			throws SQLException {
		return this.getGiisParameterDAO().getParamValues(paramName);
	}
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getParamByIssCd(java.lang.String)
	 */
	@Override
	public String getParamByIssCd(String paramName) throws SQLException {
		return this.getGiisParameterDAO().getParamByIssCd(paramName);
	}

	@Override
	public String getEngineeringParameterizedSubline(String sublineName)
			throws SQLException {		
		return this.getGiisParameterDAO().getEngineeringParameterizedSubline(sublineName);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISParameterFacadeService#getENParamSublineNames(java.lang.String)
	 */
	@Override
	public String getENParamSublineNames(String sublineCd) throws SQLException {
		return this.getGiisParameterDAO().getENParamSublineNames(sublineCd);
	}
	
	@Override
	public List<GIISParameter> getAllENParamSublineNames() throws SQLException {
		return this.getGiisParameterDAO().getAllENParamSublineNames();
	}

	@Override
	public Map<String, Object> getContextParameters() throws SQLException {
		return this.getGiisParameterDAO().getContextParameters();
	}
	
	@Override
	public Map<String, Object> initializeParamsGIEXS001(Map<String, Object> params)
			throws SQLException {
		return this.getGiisParameterDAO().initializeParamsGIEXS001(params);
	}

	@Override
	public Map<String, Object> initDateFormatGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiisParameterDAO().initDateFormatGIEXS004(params);
	}

	@Override
	public Map<String, Object> initLineCdGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiisParameterDAO().initLineCdGIEXS004(params);
	}

	@Override
	public Map<String, Object> initSublineCdGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiisParameterDAO().initSublineCdGIEXS004(params);
	}

	@Override
	public String getFormattedSysdate() throws SQLException {		
		return this.getGiisParameterDAO().getFormattedSysdate();
	}	

}

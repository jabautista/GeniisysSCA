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
import java.util.Map;

import com.geniisys.common.entity.GIISParameter;


/**
 * The Interface GIISParameterFacadeService.
 */
public interface GIISParameterFacadeService {

	/**
	 * Gets the param value v.
	 * 
	 * @param paramName the param name
	 * @return the param value v
	 * @throws SQLException the sQL exception
	 */
	public GIISParameter getParamValueV(String paramName) throws SQLException;
	public String getParamValueV2(String paramName) throws SQLException;
	public Integer getParamValueN(String paramName1) throws SQLException;
	public List<GIISParameter> getParamValues(String paramName) throws SQLException;
	public String getParamByIssCd(String paramName) throws SQLException;
	public String getEngineeringParameterizedSubline(String sublineName) throws SQLException;
	public String getENParamSublineNames(String sublineCd) throws SQLException;
	public List<GIISParameter> getAllENParamSublineNames() throws SQLException;
	public Map<String, Object> getContextParameters() throws SQLException;
	
	Map<String, Object> initializeParamsGIEXS001(Map<String, Object> params) throws SQLException;
	Map<String, Object> initDateFormatGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> initLineCdGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> initSublineCdGIEXS004(Map<String, Object> params) throws SQLException;
	String getFormattedSysdate() throws SQLException;
	
}

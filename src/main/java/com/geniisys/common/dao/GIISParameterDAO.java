/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISParameter;


/**
 * The Interface GIISParameterDAO.
 */
public interface GIISParameterDAO {
	
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
	Map<String, Object> getGiiss085Rec(Map<String, Object> params) throws SQLException;	
	void saveGiiss085(Map<String, Object> params) throws SQLException;	
	void saveGiiss061(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAssdNameFormat(String assdNameFormat) throws SQLException;
	void valIntmNameFormat(String intmNameFormat) throws SQLException;
	void valGisms011AddRec(Map<String, Object> params) throws SQLException;
	void saveGisms011(Map<String, Object> params) throws SQLException, JSONException;
}

package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.gipi.exceptions.PostingParException;

public interface PostParService {
	
	String postPar(Map<String, Object> params) throws SQLException, PostingParException, Exception;
	Map<String, String> checkBackEndt(Integer parId) throws SQLException;
	void validateMC(HttpServletRequest request) throws SQLException;
	String postFrps(Map<String, Object> params) throws SQLException;
	String postpackPar(Map<String, Object> params ) throws SQLException, Exception;
	String checkBackEndtPack(Integer packParId) throws SQLException;
	void doPostPar(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT) throws SQLException, JSONException;
	String getParCancellationMsg(HttpServletRequest request) throws SQLException, JSONException;
	void doPostPackPar(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT) throws SQLException, JSONException;
	String checkCOCAuthentication(Integer parId, String userId)	throws SQLException;
	String checkPackCOCAuthentication(Integer packParId, String userId) throws SQLException;
}

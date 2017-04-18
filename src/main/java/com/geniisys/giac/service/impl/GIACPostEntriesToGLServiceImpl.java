package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACPostEntriesToGLDAO;
import com.geniisys.giac.service.GIACPostEntriesToGLService;

public class GIACPostEntriesToGLServiceImpl implements GIACPostEntriesToGLService {

	private Logger log = Logger.getLogger(GIACPostEntriesToGLService.class);
	
	private GIACPostEntriesToGLDAO giacPostEntriesToGLDAO;
	
	public GIACPostEntriesToGLDAO getGiacPostEntriesToGLDAO() {
		return giacPostEntriesToGLDAO;
	}

	public void setGiacPostEntriesToGLDAO(GIACPostEntriesToGLDAO giacPostEntriesToGLDAO) {
		this.giacPostEntriesToGLDAO = giacPostEntriesToGLDAO;
	}

	@Override
	public Integer getGLNo() throws SQLException {
		return this.giacPostEntriesToGLDAO.getGLNo();
	}

	@Override
	public Integer getFinanceEnd() throws SQLException {
		return this.giacPostEntriesToGLDAO.getFinanceEnd();
	}

	@Override
	public Integer getFiscalEnd() throws SQLException {
		return this.giacPostEntriesToGLDAO.getFiscalEnd();
	}

	@Override
	public Integer validateTranYear(HttpServletRequest request) throws SQLException {
		return this.giacPostEntriesToGLDAO.validateTranYear(request.getParameter("tranYear"));
	}

	@Override
	public String validateTranMonth(HttpServletRequest request) throws SQLException { 
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		
		return this.giacPostEntriesToGLDAO.validateTranMonth(params);
	}

	@Override
	public void checkIsPrevMonthClosed(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		params.put("postTag", request.getParameter("postTag"));
		
		this.giacPostEntriesToGLDAO.checkIsPrevMonthClosed(params);
	}

	@Override
	public String postToGL(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		params.put("postTag", request.getParameter("postTag"));
		params.put("glNo", request.getParameter("glNo"));
		params.put("fiscalEnd", request.getParameter("fiscalEnd"));
		params.put("financeEnd", request.getParameter("financeEnd"));
		
		params = this.giacPostEntriesToGLDAO.postToGL(params);
		return (String) params.get("msg");
	}

}

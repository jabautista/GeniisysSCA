package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.CGRefCodesDAO;
import com.geniisys.common.service.CGRefCodesService;

public class CGRefCodesServiceImpl implements CGRefCodesService {
	
	/** The DAO **/
	private CGRefCodesDAO cgRefCodesDAO;
	
	/** The logger **/
	private Logger log = Logger.getLogger(CGRefCodesServiceImpl.class);

	public void setCgRefCodesDAO(CGRefCodesDAO cgRefCodesDAO) {
		this.cgRefCodesDAO = cgRefCodesDAO;
	}

	public CGRefCodesDAO getCgRefCodesDAO() {
		return cgRefCodesDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.CGRefCodesService#checkCharRefCodes(java.util.Map)
	 */
	@Override
	public void checkCharRefCodes(Map<String, Object> params)
			throws SQLException {
		log.info("check char ref codes");
		this.getCgRefCodesDAO().checkCharRefCodes(params);
	}

	@Override
	public String validateMemoType(HttpServletRequest request)
			throws SQLException {
		return cgRefCodesDAO.validateMemoType(request.getParameter("memoType"));
	}

	@Override
	public String validateGIACS127TranClass(HttpServletRequest request)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("rvLowValue", request.getParameter("rvLowValue"));
		params.put("chkInclude", request.getParameter("chkInclude"));
		params.put("result", "");
		return cgRefCodesDAO.validateGIACS127TranClass(params);
	}

	@Override
	public String validateGIACS127JVTran(HttpServletRequest request)
			throws SQLException {
		String jvTranCd = request.getParameter("jvTranCd");
		return cgRefCodesDAO.validateGIACS127JVTran(jvTranCd);
	}

	@Override
	public List<Map<String, Object>> getFileSourceList() throws SQLException {
		// TODO Auto-generated method stub
		return cgRefCodesDAO.getFileSourceList();
	}

}

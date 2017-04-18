package com.geniisys.gipi.service.impl;

import java.net.ConnectException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.dao.COCAuthenticationDAO;
import com.geniisys.gipi.dao.impl.PostParDAOImpl;
import com.geniisys.gipi.service.COCAuthenticationService;

public class COCAuthenticationServiceImpl implements COCAuthenticationService {

	private static Logger log = Logger.getLogger(PostParDAOImpl.class);
	private COCAuthenticationDAO cocAuthenticationDAO;
	
	public COCAuthenticationDAO getCocAuthenticationDAO() {
		return cocAuthenticationDAO;
	}

	public void setCocAuthenticationDAO(COCAuthenticationDAO cocAuthenticationDAO) {
		this.cocAuthenticationDAO = cocAuthenticationDAO;
	}

	@Override
	public Boolean registerCOCs(HttpServletRequest request, GIISUser user,
			String cocafAddress)
					throws ConnectException, SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", user.getUserId());
		params.put("cocafAddress", cocafAddress);
		params.put("parId", request.getParameter("parId"));
		params.put("isPackage", request.getParameter("isPackage"));
		params.put("useDefaultTin", request.getParameter("useDefaultTin"));
		
		return this.cocAuthenticationDAO.registerCOCs(params);
	}

}

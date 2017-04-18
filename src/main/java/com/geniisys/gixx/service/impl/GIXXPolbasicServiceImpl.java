package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXPolbasicDAO;
import com.geniisys.gixx.entity.GIXXPolbasic;
import com.geniisys.gixx.service.GIXXPolbasicService;

public class GIXXPolbasicServiceImpl implements GIXXPolbasicService {
	
	private GIXXPolbasicDAO gixxPolbasicDAO;
	
	public GIXXPolbasicDAO getGixxPolbasicDAO() {
		return gixxPolbasicDAO;
	}

	public void setGixxPolbasicDAO(GIXXPolbasicDAO gixxPolbasicDAO) {
		this.gixxPolbasicDAO = gixxPolbasicDAO;
	}

	@Override
	public GIXXPolbasic getPolicySummary(Map<String, Object> params) throws SQLException {	
		/*Map<String, Object> params2 = new HashMap<String, Object>();
		params2 = this.getGixxPolbasicDAO().getPolicySummary(params);
		System.out.println("GIXXPolbasicServiceImpl [params]: " + params2);*/
		//return params2;
		return this.getGixxPolbasicDAO().getPolicySummary(params);
	}

	@Override
	public GIXXPolbasic getPolicySummarySu(Map<String, Object> params) throws SQLException {
		return this.getGixxPolbasicDAO().getPolicySummarySu(params);
	}

	@Override
	public GIXXPolbasic getBondPolicyData(Map<String, Object> params) throws SQLException {
		return this.getGixxPolbasicDAO().getBondPolicyData(params);
	}

}

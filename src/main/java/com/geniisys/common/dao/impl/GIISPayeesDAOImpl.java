package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISPayeesDAO;
import com.geniisys.common.entity.GIISPayees;
import com.geniisys.framework.util.DAOImpl;

public class GIISPayeesDAOImpl extends DAOImpl implements GIISPayeesDAO{
	
	private static Logger log = Logger.getLogger(GIISPayeesDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISPayeesDAO#getPayeeByAdjusterListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPayeeByAdjusterListing(Map<String, Object> params) throws SQLException {
		log.info("getPayeeByAdjusterListing");
		return this.getSqlMapClient().queryForList("getPayeesByAdjusterLOV", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISPayeesDAO#getPayeeByAdjusterListing2(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPayeeByAdjusterListing2(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPayeesByAdjuster2LOV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISPayees> getPayeeMortgageeListing(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getLossExpPayeeMortgagees", params);
	}

	@Override
	public String getPayeeClassDesc(String payeeClassCd)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPayeeClassDesc", payeeClassCd);
	}
	
	@Override
	public String getPayeeClassSlTypeCd(String payeeClassCd)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPayeeClassSlTypeCd", payeeClassCd);
	}

	@Override
	public String getPayeeFullName(Map<String, Object> params)
			throws SQLException {
		log.info("GETTING FULL NAME OF PAYEE: "+params);
		return (String) getSqlMapClient().queryForObject("getPayeeFullName", params);
	}

}

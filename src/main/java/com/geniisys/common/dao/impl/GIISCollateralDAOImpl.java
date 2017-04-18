package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISCollateralDAO;
import com.geniisys.common.entity.GIISCollateral;
import com.geniisys.common.entity.GIISCollateralType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCollateralDAOImpl implements GIISCollateralDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISCollateralDAO.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISCollateral> getCollateralList(HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		//System.out.println(parId);
		log.info("collateral DAO +++++++++++++++++++++++++++++++++");
		return this.getSqlMapClient().queryForList("getGiisCollateralMap" , params);
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<GIISCollateralType> getCollType() throws SQLException {
		// TODO Auto-generated method stub
		log.info("get coll type");
		return this.getSqlMapClient().queryForList("getCollType");
	}


	@Override
	public void delCollateralPar(Integer parId, Integer collId,
			Integer collVal, String recDate) throws SQLException {
		// TODO Auto-generated method stub
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("parId" , parId);
		myMap.put("collId", collId);
		myMap.put("collVal", collVal);
		myMap.put("recDate", recDate);
		this.getSqlMapClient().delete("deleteCollateralpar",myMap);
		System.out.println("after delete");
	}


	@Override
	public void addCollateralPar(Integer parId, Integer collId,
			Integer collVal, String recDate) throws SQLException {
		// TODO Auto-generated method stub
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("parId" , parId);
		myMap.put("collId", collId);
		myMap.put("collVal", collVal);
		myMap.put("recDate", recDate);
		this.getSqlMapClient().insert("addCollateralPar",myMap);
		System.out.println("add colla dao impl");		
	}
}

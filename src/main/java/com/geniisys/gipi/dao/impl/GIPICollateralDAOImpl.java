package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.gipi.dao.GIPICollateralDAO;
import com.geniisys.gipi.entity.GIPICollateral;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPICollateralDAOImpl implements GIPICollateralDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIPICollateralDAO.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPICollateral> getCollateralList(HashMap<String, Object> params) throws SQLException {
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
			String collVal, String recDate) throws SQLException {
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
			String collVal, String recDate) throws SQLException {
		// TODO Auto-generated method stub
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("parId" , parId);
		myMap.put("collId", collId);
		myMap.put("collVal", collVal);
		myMap.put("recDate", recDate);
		this.getSqlMapClient().insert("addCollateralPar",myMap);
		System.out.println("add colla dao impl");		
	}


	@Override
	public void deleteCollateral(Integer parId, Integer rowNum)
			throws SQLException {
		// TODO Auto-generated method stub
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("parId" , parId);
		myMap.put("rowNum" , rowNum);
		this.getSqlMapClient().delete("deleteCollateralpar",myMap);
	}


	@Override
	public void updateCollateralPar(Integer parId, Integer collId, String collVal,
			String recDate, Integer parId2, Integer collId2, String collVal2,
			String recDate2) throws SQLException {
		// TODO Auto-generated method stub
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("parId" , parId);
		myMap.put("collId", collId);
		myMap.put("collVal", collVal);
		myMap.put("recDate", recDate);
		myMap.put("parId2" , parId2);
		myMap.put("collId2", collId2);
		myMap.put("collVal2", collVal2);
		myMap.put("recDate2", recDate2);
		this.getSqlMapClient().update("updateCollateralPar",myMap);
	}
}

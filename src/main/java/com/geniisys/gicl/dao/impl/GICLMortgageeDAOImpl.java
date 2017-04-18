package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.jfree.util.Log;

import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMortgageeDAOImpl implements GICLMortgageeDAO{

	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient){
		this.sqlMapClient = sqlMapClient;
	}
	
	public SqlMapClient getSqlMapClient(){
		return this.sqlMapClient;
	}

	@Override
	public void setClmItemMortgagee(Map<String, Object> params)
			throws SQLException {
		Log.info("Setting claim item info mortgagee");
		/*String lineCd = (String) params.get("lineCd");
		Class<?> strClass;
		
		if(lineCd.equals("FI")){
			strClass = GICLFireDtl.class;
			delGiclMortgageeRows = (List<Class>)params.get("giclFireDtlDelRows");
			setGiclMortgageeRows = (List<Class>)params.get("giclFireDtlSetRows");
		}else if (lineCd.equals("MC")) {
			delGiclMortgageeRows = (List<Class>)params.get("giclMotorCarDtlDelRows");
			setGiclMortgageeRows = (List<Class>)params.get("giclMotorCarDtlSetRows");
		}
		delGiclMortgageeRows.addAll(setGiclMortgageeRows);*/
		/*
		List<GICLFireDtl> giclFireDtlSetRows = (List<GICLFireDtl>) params.get(setKey);
		List<GICLFireDtl> giclFireDtlDelRows = (List<GICLFireDtl>) params.get(delKey);
		
		
		
		giclFireDtlDelRows.addAll(giclFireDtlSetRows);
		for (GICLFireDtl mort:giclFireDtlDelRows){
			params.put("itemNo", mort.getItemNo());
			this.sqlMapClient.delete("delGiclMortgagee", params);
			this.sqlMapClient.insert("insertClaimMortgagee", params);
		}*/
	}

	@Override
	public String checkIfGiclMortgageeExist(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkIfGiclMortgExist", params);
	}
	
}

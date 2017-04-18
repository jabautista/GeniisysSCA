package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACTaxPaymentsDAO;
import com.geniisys.giac.entity.GIACTaxPayments;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTaxPaymentsDAOImpl implements GIACTaxPaymentsDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIACS021Variables(Integer gaccTranId)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS021Variables", gaccTranId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getGIACS021Items(Integer gaccTranId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIACS021Items", gaccTranId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveTaxPayments(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIACTaxPayments> setRows = (List<GIACTaxPayments>) params.get("setRows");
			List<GIACTaxPayments> delRows = (List<GIACTaxPayments>) params.get("delRows");
			String userId = (String)params.get("userId");
			String tranSource = (String)params.get("tranSource");
			String orFlag = (String)params.get("orFlag");
			
			for(GIACTaxPayments del : delRows){
				this.getSqlMapClient().delete("deleteTaxPayment", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIACTaxPayments set : setRows){
				set.setUserId(userId);
				this.getSqlMapClient().insert("insertTaxPayment", set);
			}
			this.getSqlMapClient().executeBatch();
			
			if(tranSource.equals("OP") || tranSource.equals("OR")){
				if(!orFlag.equals("P")){
					this.getSqlMapClient().update("updateGiacOpTextGIACS021", params.get("gaccTranId"));
				}
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("aegParametersGIACS021", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
}

package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLLossProfileDAO;
import com.geniisys.gicl.entity.GICLLossProfile;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossProfileDAOImpl implements GICLLossProfileDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstance() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstance");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveProfile(Map<String, Object> params) throws SQLException, ParseException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			String type = (String) params.get("type");
			List<GICLLossProfile> delList = (List<GICLLossProfile>) params.get("delRows");
			List<GICLLossProfile> setList = (List<GICLLossProfile>) params.get("setRows");
			List<GICLLossProfile> delDtlList = (List<GICLLossProfile>) params.get("delDtlRows");
			List<GICLLossProfile> setDtlList = (List<GICLLossProfile>) params.get("setDtlRows");
			
			for(GICLLossProfile d : delDtlList){
				this.getSqlMapClient().update("deleteLossProfileRange", d);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GICLLossProfile d : delList){
				this.getSqlMapClient().update("deleteLossProfile", d);
			}
			this.getSqlMapClient().executeBatch();
			
			if(setList.size() > 0){
				if("update".equals(type)){
					for(GICLLossProfile s : setList){
						s.setType(type);
						this.getSqlMapClient().update("updateLossProfile", s);
					}
				}else{
					for(GICLLossProfile s : setList){
						s.setType(type);
						
						if("lineSubline".equals(type)){
							this.getSqlMapClient().update("deleteLossLineSubline", s);
						}else if("byLine".equals(type)){
							this.getSqlMapClient().update("deleteLossByLine", s);
						}else if("byLineAndSubline".equals(type)){
							this.getSqlMapClient().update("deleteLossByLineSubline", s);
						}else if("allLines".equals(type)){
							this.getSqlMapClient().update("deleteLossAllLines", s);
						}else if("allSubLines".equals(type)){
							this.getSqlMapClient().update("deleteLossAllSublines", s);
						}
						
						for(GICLLossProfile r : setDtlList){
							s.setRangeFrom(r.getRangeFrom());
							s.setRangeTo(r.getRangeTo());
							this.getSqlMapClient().update("setLossProfile", s);
							this.getSqlMapClient().executeBatch();
						}
					}
				}
				this.getSqlMapClient().executeBatch();
			}else if(setDtlList.size() > 0){
				for(GICLLossProfile r : setDtlList){
					r.setType(type);
					this.getSqlMapClient().update("setLossProfile", r);
					this.getSqlMapClient().executeBatch();
				}
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> extractLossProfile(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractLossProfile", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String checkRecovery(Integer claimId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkRecovery", claimId);
	}
	
	@Override
	public void validateRange(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("gicls211ValidateRange", params);
	}
	
}


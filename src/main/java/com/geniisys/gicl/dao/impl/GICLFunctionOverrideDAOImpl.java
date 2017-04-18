package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLFunctionOverrideDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLFunctionOverrideDAOImpl implements GICLFunctionOverrideDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLFunctionOverrideDAO.class);
		
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLFunctionOverrideDAO#updateFunctionOverride(java.util.Map)
	 */
	public void updateFunctionOverride(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> functions = (List<Map<String, Object>>) params.get("functions");
			for (Map<String,Object> f: functions){
				f.put("userId", params.get("userId"));
				String remarks = f.get("remarks") == null ? null : StringFormatter.unescapeHTML2(f.get("remarks").toString());
				f.put("remarks", remarks);
				System.out.println("UPDATING FUNCTION OF OVERRIDE ID: " + f.get("overrideId"));
				System.out.println("TAG: " + f.get("approveSw"));
				System.out.println("APPROVE_REC_FLG: " + params.get("approveRecFlg"));
				System.out.println("USER ID: " + f.get("userId"));
				
				if("true".equals(params.get("approveRecFlg"))){
					if (f.get("approveSw").equals("Y")){
						this.getSqlMapClient().update("approveGICLS183FunctionOverride", f);
					}//else {
						this.getSqlMapClient().update("updateGICLS183FunctionOverrideRemarks", f);
					//}
				}else if("false".equals(params.get("approveRecFlg"))){
					this.getSqlMapClient().update("updateGICLS183FunctionOverrideRemarks", f);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}	
	

}

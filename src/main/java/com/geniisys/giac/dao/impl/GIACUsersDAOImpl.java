/**
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACUsersDAO;
import com.geniisys.giac.entity.GIACUsers;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author steven
 *
 */
public class GIACUsersDAOImpl implements GIACUsersDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs313(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUsers> delList = (List<GIACUsers>) params.get("delRows");
			for(GIACUsers d: delList){
				this.sqlMapClient.update("delAccountingUser", d.getGiacUserId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUsers> setList = (List<GIACUsers>) params.get("setRows");
			for(GIACUsers s: setList){
				this.sqlMapClient.update("setAccountingUser", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteAccountingUser", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAccountingUser", recId);		
	}

}

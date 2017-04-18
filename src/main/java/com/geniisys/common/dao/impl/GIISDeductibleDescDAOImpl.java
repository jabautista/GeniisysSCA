package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISDeductibleDescDAO;
import com.geniisys.common.entity.GIISDeductibleDesc;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISDeductibleDescDAOImpl implements GIISDeductibleDescDAO{

	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss010(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISDeductibleDesc> delList = (List<GIISDeductibleDesc>) params.get("delRows");
			for(GIISDeductibleDesc d: delList){
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("lineCd", d.getLineCd());
				p.put("sublineCd", d.getSublineCd());
				p.put("deductibleCd", d.getDeductibleCd());
				p.put("checkBoth", "N");
				this.sqlMapClient.update("valDeleteDeductibleDesc", p);
				this.sqlMapClient.update("delDeductibleDesc", p);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISDeductibleDesc> setList = (List<GIISDeductibleDesc>) params.get("setRows");
			for(GIISDeductibleDesc s: setList){
				this.sqlMapClient.update("setDeductibleDesc", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteDeductibleDesc", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDeductibleDesc", params);		
	}

	/* start - Gzelle 08272015 SR4851 */
	@Override
	public Map<String, Object> getAllTDedType(Map<String, Object> params) throws SQLException {
		params.put("list", this.getSqlMapClient().queryForList("getAllTDedType", params));
		return params;
	}
	/* end - Gzelle 08272015 SR4851 */
}

package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISBondClass;
import com.geniisys.common.entity.GIISBondClassRt;
import com.geniisys.common.entity.GIISBondClassSubline;
import com.geniisys.giis.dao.GIISBondClassDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIISBondClassDAOImpl implements GIISBondClassDAO{

	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void saveGiiss043(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss043");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISBondClassRt> delListRt = (List<GIISBondClassRt>) params.get("delRowsRt");
			for(GIISBondClassRt d: delListRt){
				this.sqlMapClient.update("giiss043DelBondClassRt", d);
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISBondClassSubline> delListSubline = (List<GIISBondClassSubline>) params.get("delRowsSubline");
			for(GIISBondClassSubline d: delListSubline){
				d.setClassNo(StringFormatter.unescapeHTML2(d.getClassNo()));
				d.setSublineCd(StringFormatter.unescapeHTML2(d.getSublineCd()));
				d.setClauseType(StringFormatter.unescapeHTML2(d.getClauseType()));
				this.sqlMapClient.update("giiss043DelBondClassSubline", d);
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISBondClass> delList = (List<GIISBondClass>) params.get("delRows");
			for(GIISBondClass d: delList){
				this.sqlMapClient.update("giiss043DelBondClass", StringFormatter.unescapeHTML2(d.getClassNo()));
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISBondClass> setList = (List<GIISBondClass>) params.get("setRows");
			for(GIISBondClass s: setList){
				this.sqlMapClient.update("saveGiiss043BondClass", s);
			}
			
			@SuppressWarnings("unchecked")
			List<GIISBondClassSubline> setListSubline = (List<GIISBondClassSubline>) params.get("setRowsSubline");
			for(GIISBondClassSubline s: setListSubline){
				this.sqlMapClient.update("saveGiiss043BondClassSubline", s);
			}
			
			@SuppressWarnings("unchecked")
			List<GIISBondClassRt> setListRt = (List<GIISBondClassRt>) params.get("setRowsRt");
			for(GIISBondClassRt s: setListRt){
				this.sqlMapClient.update("saveGiiss043BondClassRt", s);
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
	public void giiss043ValAddBondClass(String classNo) throws SQLException {
		this.sqlMapClient.update("giiss043ValAddBondClass", classNo);
	}

	@Override
	public void giiss043ValDelBondClass(String classNo) throws SQLException {
		this.sqlMapClient.update("giiss043ValDelBondClass", classNo);
	}

	@Override
	public void giiss043ValAddBondClassSubline(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("giiss043ValAddBondClassSubline", params);
	}

	@Override
	public void giiss043ValDelBondClassSubline(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("giiss043ValDelBondClassSubline", params);
	}

	@Override
	public void giiss043ValAddBondClassRt(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("giiss043ValAddBondClassRt", params);
	}
	
}

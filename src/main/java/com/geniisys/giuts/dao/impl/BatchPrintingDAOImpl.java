package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.giuts.dao.BatchPrintingDAO;
import com.geniisys.gixx.entity.GIXXPolbasic;
import com.ibatis.sqlmap.client.SqlMapClient;

public class BatchPrintingDAOImpl implements BatchPrintingDAO{
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReports> getDocTypeList() throws SQLException {
		return this.getSqlMapClient().queryForList("populateDocList");
	}

	@Override
	public Map<String, Object> initializVariable(Map<String, Object> paramsOut) throws SQLException {
		this.getSqlMapClient().update("initializeVariable", paramsOut);
		return paramsOut;
	}
    
	@SuppressWarnings("unchecked")
	@Override
	public List<GIXXPolbasic> getPolicyEndtId(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyEndtId", params);
	}
	
	@Override
	public String extractPolDocRec(Map<String, Object> params) throws SQLException {
		String message = "Policy Extracted to GIXX Tables";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractPolDocRec", params);
			
			System.out.println("populate tables :::::::::::::::::" + params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}

	@Override
	public void deleteExtractTables(Integer extractId) throws SQLException {
		//this.getSqlMapClient().queryForObject("deleteExtractTables", extractId);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("deleteExtractTables", extractId);
			System.out.println("DELETE tables :::::::::::::::::" + extractId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
	}

	@Override
	public void updatePolRec(Integer policyId) throws SQLException {
	//public void updatePolRec(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updatePolRec", policyId);
			System.out.println("UPDATE RECORD tables :::::::::::::::::" + policyId);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIBinder> getBatchBinderId(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchBinderId", params);
	}
	
	@Override
	public void updateBinderRec(Integer binderId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateBinderRec", binderId);
			System.out.println("updating binder :::::::::::::::::" + binderId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolbas> getBatchCoverNote(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchCoverNote", params);
	}

	@Override
	public void updateCoverNoteRec(Integer parId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateCoverNoteRec", parId);
			System.out.println("updating Covernote detail :::::::::::::::::" + parId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIVehicle> getBatchCoc(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchCoc", params);
	}

	@Override
	public void updateCocRec(Integer policyId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateCocRec", policyId);
			System.out.println("updating coc detail :::::::::::::::::" + policyId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBatchInvoice(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchInvoice", params);
		
	}

	@Override
	public void updateInvoiceRec(Integer policyId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateInvoiceRec", policyId);
			System.out.println("updating invoice detail :::::::::::::::::" + policyId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBatchRiInvoice(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchRiInvoice", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBondsRenewalPolId(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBondsRenewalPolId", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getRenewalPolId(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getRenewalPolId", params);
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBondsPolicyPolId(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBondsPolicyPolId", params);
	}
}
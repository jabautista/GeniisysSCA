package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giuts.dao.SpoilageReinstatementDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class SpoilageReinstatementDAOImpl implements SpoilageReinstatementDAO{

	private Logger log = Logger.getLogger(SpoilageReinstatementDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> whenNewFormInstanceGiuts003() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGiuts003");
	}

	@Override
	public Map<String, Object> spoilPolicyGiuts003(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("spoilPolicyGiuts003", params);
			this.getSqlMapClient().executeBatch();
			
			String cont = (String) params.get("cont");
			if("Y".equals(cont)){
				this.getSqlMapClient().getCurrentConnection().commit();
			}else{
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		}catch(SQLException e){			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> unspoilPolicyGiuts003(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("unspoilPolicyGiuts003", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> postPolicyGiuts003(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("postPolicyGiuts003", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> postPolicy2Giuts003(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String alert = (String) params.get("alert");
			if(alert.equals("Y")){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("postPolicy2Giuts003", params);
				this.getSqlMapClient().executeBatch();
				
				String cont = (String) params.get("cont");
				if(cont.equals("Y")){
					this.getSqlMapClient().getCurrentConnection().commit();
				}else{
					this.getSqlMapClient().getCurrentConnection().rollback();
				}				
			}else{
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		}catch(SQLException e){			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormGiuts003a() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormGiuts003a");
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackPolicyDetailsGiuts003a(Map<String, Object> params)	throws SQLException {
		log.debug("Getting Package Policy Details...");
		System.out.println(params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiuts003aPackPolicyDetails", params);
	}
	
	@Override
	public void chkPackPolicyForSpoilageGiuts003a(Map<String, Object> params) throws SQLException { //changed by kenneth 07132015 SR 4753 
		 this.getSqlMapClient().update("chkPackPolicyForSpoilageGiuts003a", params);
	}

	@Override
	public Map<String, Object> spoilPackGiuts003a(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("packSpoilGiuts003a", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "Policy/Endorsement has been tagged for spoilage.";
			params.put("message", message);
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = message == "Policy/Endorsement has been tagged for spoilage." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) : message;
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			System.out.println("mensahe: "+message);
			this.getSqlMapClient().endTransaction();
		} 
		
		return params;
	}


	@Override
	public Map<String, Object> unspoilPackGiuts003a(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("packUnspoilGiuts003a", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "The policy / endorsement has been unspoiled.";
			params.put("message", message);
		}catch (SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = message == "The policy / endorsement has been unspoiled." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) : message;
		}catch (Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			System.out.println(message);
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	
	@Override
	public Map<String, Object> chkPackPolicyPostGiuts003a(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("chkPackPolicyPostGiuts003a", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGIUTS028()
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGIUTS028");
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateGIUTS028EndtRecord(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateGIUTS028EndtRecord", params);
	}

	@Override
	public void validateGIUTS028CheckPaid(Map<String, Object> params)
			throws SQLException {
		String vCancelPolicy = (String)params.get("vCancelPolicy");
		
		if (vCancelPolicy != null) {
			params.put("vCancelPolicy", (vCancelPolicy.isEmpty() ? null : new Integer(vCancelPolicy)));
		}
		this.getSqlMapClient().update("validateGIUTS028CheckPaid", params);
		Debug.print("validateGIUTS028CheckPaid params....." + params);
	}

	@Override
	public void validateGIUTS028CheckRIPayt(Map<String, Object> params)
			throws SQLException {
		String vCancelPolicy = (String) params.get("vCancelPolicy");
		
		if(vCancelPolicy != null){
			params.put("vCancelPolicy", (vCancelPolicy.isEmpty() ? null : new Integer(vCancelPolicy)));
		}
		this.getSqlMapClient().update("validateGIUTS028CheckRIPayt", params);
		Debug.print("validateGIUTS028CheckRIPayt params....." + params);
	}

	@Override
	public void validateGIUTS028RenewPol(Map<String, Object> params)
			throws SQLException {
		String issueYy = (String) params.get("issueYy");
		String polSeqNo = (String) params.get("polSeqNo");
		String renewNo = (String) params.get("renewNo");
		
		if(issueYy != null){
			params.put("issueYy", (issueYy.isEmpty() ? null : new Integer(issueYy)));
		}
		
		if(polSeqNo != null){
			params.put("polSeqNo", (polSeqNo.isEmpty() ? null : new Integer(polSeqNo)));
		}
		
		if(renewNo != null){
			params.put("renewNo", (renewNo.isEmpty() ? null : new Integer(renewNo)));
		}
		this.getSqlMapClient().update("validateGIUTS028RenewPol", params);
		Debug.print("validateGIUTS028RenewPol params....." + params);
	}

	@Override
	public void validateGIUTS028CheckAcctEntDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIUTS028CheckAcctEntDate", params);
		System.out.println("Validating Acct Ent Date of GIUTS028 ::::::::::" + params);
		Debug.print("validateGIUTS028CheckAcctEntDate params....." + params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkMrn(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkMrn", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkEndtOnProcess(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkEndtOnProcess", params);
	}

	@Override
	public HashMap<String, Object> processGIUTS028Reinstate(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("processGIUTS028Reinstate", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("processGIUTS028Reinstate params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	/* benjo 09.03.2015 UW-SPECS-2015-080 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkOrigRenewStatus(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkOrigRenewStatus", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGIUTS028A()
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGIUTS028A");
	}

	@Override
	public HashMap<String, Object> reinstatePackageGIUTS028A(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("reinstatePackageGIUTS028A", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("reinstatePackageGIUTS028A params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public HashMap<String, Object> postGIUTS028AReinstate(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("postGIUTS028AReinstate", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("postGIUTS028AReinstate params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String validateSpoilCdGiuts003(String spoilCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateSpoilCdGiuts003", spoilCd);
	}

	/* benjo 09.03.2015 UW-SPECS-2015-080 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkPackOrigRenewStatus(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkPackOrigRenewStatus", params);
	}
}

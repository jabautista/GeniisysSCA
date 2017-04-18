package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.dao.GIPIWReportsExtDAO;
import com.geniisys.gipi.entity.GIPIUWReportsParam;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWReportsExtDAOImpl implements GIPIWReportsExtDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String checkUwReportsEdst(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkUwReportsEdst", params);
	}

	@Override
	public String checkUwReports(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReports", params);
	}

	@Override
	public String extractUWReports(Map<String, Object> params)
			throws SQLException {
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String edst = (String)params.get("edstCtr");
			if(edst.equals("Y")){
				System.out.println("extractUwReportsEdst & " + edst);
				this.getSqlMapClient().update("extractUwReportsEdst", params);
			}else{
				System.out.println("extractUwReports & " + edst);
				this.getSqlMapClient().update("extractUwReports", params);
			}
			this.getSqlMapClient().executeBatch();
			
			Integer edstCtpPol =  Integer.parseInt((String) params.get("edstCtpPol"));
			if(edstCtpPol == 1 || edstCtpPol == 2){
				System.out.println("populateMcPolExt");
				this.getSqlMapClient().update("populateMcPolExt", params);
				this.getSqlMapClient().executeBatch();
			}
			
			String extractedData = (String)this.getSqlMapClient().queryForObject("checkExtractedData", params);
			if(extractedData == "" || extractedData == null){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) : message;
			throw e; //apollo cruz 06.23.2015 - to display sql errors correctly in jsp
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public GIPIUWReportsParam getLastExtractParams(Map<String, Object> params) throws SQLException {
		return (GIPIUWReportsParam) this.getSqlMapClient().queryForObject("getLastExtractParams", params);
	}

	@Override
	public Map<String, Object> validateCedant(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateCedant", params);
		return params;
	}

	@Override
	public String checkUwReportsDist(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsDist", params);
	}

	@Override
	public String extractUWReportsDist(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsDist", params);
			this.getSqlMapClient().executeBatch();
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataDist", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkUwReportsOutward(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsOutward", params);
	}

	@Override
	public String extractUWReportsOutward(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsOutward", params);
			this.getSqlMapClient().executeBatch();
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataOutward", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkUwReportsPerPeril(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsPerPeril", params);
	}

	@Override
	public String extractUWReportsPerPeril(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsPerPeril", params);
			this.getSqlMapClient().executeBatch();

			String riIssCd = (String) this.getSqlMapClient().queryForObject("getGIACParamValueV3", "RI_ISS_CD");
			if(params.get("issCd") == null || params.get("issCd") == "" || params.get("issCd").equals(riIssCd)){
				System.out.println("extractUwReportsPerPerilRi");
				this.getSqlMapClient().update("extractUwReportsPerPerilRi", params);
				this.getSqlMapClient().executeBatch();
			}
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataPerPeril", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) : message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkUwReportsPerAssd(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsPerAssd", params);
	}

	@Override
	public String extractUWReportsPerAssd(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsPerAssd", params);
			this.getSqlMapClient().executeBatch();
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataPerAssd", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkUwReportsInward(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsInward", params);
	}

	@Override
	public String extractUWReportsInward(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsInward", params);
			this.getSqlMapClient().executeBatch();
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataInward", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Integer getParamDate(String userId) throws SQLException {
		return (Integer)this.getSqlMapClient().queryForObject("getParamDate", userId);
	}

	@Override
	public String checkUwReportsPolicy(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkUwReportsPolicy", params);
	}

	@Override
	public String extractUWReportsPolicy(Map<String, Object> params)
			throws SQLException {
		String message = "";
	
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractUwReportsPolicy", params);
			this.getSqlMapClient().executeBatch();
			
			String extracted = (String)this.getSqlMapClient().queryForObject("checkExtractedDataPolicy", params);
			if(extracted == null || extracted == ""){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validatePrintPolEndt(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("validatePrintPolEndt", params);
	}

	@Override
	public String validatePrint(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("validatePrintDist", params);
	}

	@Override
	public Integer countNoShareCd(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("countNoShareCd", params);
	}

	@Override
	public String validatePrintAssd(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePrintAssd", params);
	}

	@Override
	public String validatePrintOutwardInwardRI(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePrintOutwardInwardRI", params);
	}
	
}

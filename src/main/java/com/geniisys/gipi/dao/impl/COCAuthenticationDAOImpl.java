package com.geniisys.gipi.dao.impl;

import java.lang.reflect.Method;
import java.net.ConnectException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.controllers.PostParController;
import com.geniisys.gipi.dao.COCAuthenticationDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class COCAuthenticationDAOImpl implements COCAuthenticationDAO {
	
	private static Logger log = Logger.getLogger(PostParDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	@Override
	public Boolean registerCOCs(Map<String, Object> params) throws SQLException, Exception {
		Boolean withAuthenticationError = false;
		boolean classExists = true;
		
		try
		{
			Class.forName("com.isap.api.COCRegistration", false, this.getClass().getClassLoader());
		}catch(ClassNotFoundException c){
			log.info("COC Authentication Plugin not found. Authentication cannot proceed.");
			classExists = false;
		}
		log.info(classExists + " -  PLUGIN TAG");
		
		if (classExists){
			try {
				this.getSqlMapClient().startTransaction();
				this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				this.getSqlMapClient().startBatch();
				
				String userId = (String) params.get("userId");
				Integer parId = Integer.parseInt((String) params.get("parId"));
				String isPackage = (String) params.get("isPackage");
				
				log.info("Authentication will proceed..");
				Map<String, Object> paramsGet = new HashMap<String, Object>();
				paramsGet.put("userId", userId);
				paramsGet.put("parId", parId);
				paramsGet.put("useDefaultTin", params.get("useDefaultTin"));
				System.out.println(paramsGet);
				
				List<Map<String, Object>> paramsDtls = null;
				
				if("Y".equals(isPackage)){
					paramsDtls = (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getPackCOCAuthenticationDetails", paramsGet);	
				} else {
					paramsDtls = (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getCOCAuthenticationDetails", paramsGet);	
				}
					
				if (paramsDtls.size() > 0){
					log.info("Calling web service..");
					for (int i = 0; i < paramsDtls.size(); i++){
						Map<String, Object> paramsAuth = new HashMap<String, Object>();
						paramsAuth.put("cocafAddress", params.get("cocafAddress"));
						paramsAuth.put("reg", paramsDtls.get(i));
						System.out.println("COC AUTH PARAMS: " + paramsAuth);
						Map<String, Object> response = (Map<String, Object>) this.registerCOC(paramsAuth);
						
						if (response.get("errorMessage") != null && response.get("errorMessage").toString().length() > 0) {
							log.info("ERROR IN AUTHENTICATION: " + response.get("errorMessage").toString());
							withAuthenticationError = true;
						}
						
						Map<String, Object> paramsCOC = new HashMap<String, Object>();
						paramsCOC.put("policyId", paramsDtls.get(i).get("policyId"));
						paramsCOC.put("itemNo", paramsDtls.get(i).get("itemNo"));
						paramsCOC.put("cocNo", response.get("cocNo"));
						paramsCOC.put("authNo", response.get("authNo"));
						paramsCOC.put("errMsg", response.get("errorMessage"));
						paramsCOC.put("cocafUser", paramsDtls.get(i).get("username"));
						paramsCOC.put("lastUserId", userId);
						System.out.println("COC PARAMETERS: " + paramsCOC);
						this.getSqlMapClient().update("setCOCAuthentication", paramsCOC);
					}
				}
				
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().getCurrentConnection().commit();						
			} catch (SQLException e) {
				this.getSqlMapClient().getCurrentConnection().rollback();
				throw e;
			} catch (Exception e) {
				this.getSqlMapClient().getCurrentConnection().rollback();
				throw e;
			} finally {
				this.getSqlMapClient().endTransaction();
			}
		}
		return withAuthenticationError;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> registerCOC(Map<String, Object> params) throws Exception {
		Map<String, Object> response = new HashMap<String, Object>();
		Method register = null;

		try {
			Class<?> authClass = Class.forName("com.isap.api.COCRegistrationProxy");
			Object obj = authClass.newInstance();

			register = authClass.getDeclaredMethod("register", Map.class);
			response = (Map<String, Object>) register.invoke(obj, params);
		} catch (Exception e) {
			throw e;
		}
		return response;

	}	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

}

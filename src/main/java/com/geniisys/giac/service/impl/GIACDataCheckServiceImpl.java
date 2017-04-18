package com.geniisys.giac.service.impl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import org.apache.commons.io.FileUtils;

import com.geniisys.csv.CreateCSV;
import com.geniisys.csv.dao.DatabaseManagerDAO;
import com.geniisys.csv.dao.impl.DatabaseManagerDAOImpl;
import com.geniisys.csv.entity.DBParam;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDataCheckDAO;
import com.geniisys.giac.service.GIACDataCheckService;
import com.mchange.v2.c3p0.DataSources;

public class GIACDataCheckServiceImpl implements GIACDataCheckService{
	
	private GIACDataCheckDAO giacDataCheckDAO;
	
	private GIACDataCheckDAO giacDataCheckDAO() {
		return giacDataCheckDAO;
	}
	
	public void setGiacDataCheckDAO(GIACDataCheckDAO giacDataCheckDAO) {
		this.giacDataCheckDAO = giacDataCheckDAO;
	}
	
	@SuppressWarnings("unused")
	private static DatabaseManagerDAO manager = DatabaseManagerDAOImpl.getDatabaseManager();
	
	public Map<String, Object> getConnection(ApplicationContext APPLICATION_CONTEXT) throws SQLException, ClassNotFoundException{
		DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
		
		String username = dataSource.getUsername();
		String password = dataSource.getPassword();
		
		DBParam dbParam = new DBParam();
		
		dbParam.setUserName(username);
		dbParam.setPassword(password);
		
		String driverName = "oracle.jdbc.driver.OracleDriver";
		
		@SuppressWarnings("rawtypes")
		Map properties = null;
		DataSource pooledDataSource;
		
		Class.forName(driverName);
		DataSource unpooledDatasource = DataSources.unpooledDataSource(dataSource.getUrl(), dbParam.getUserName(), dbParam.getPassword());
		pooledDataSource = DataSources.pooledDataSource(unpooledDatasource, properties);
		
		Connection connection = pooledDataSource.getConnection();
		Map<String, Object> connections = new HashMap<String, Object>();
		connections.put("connection", connection);
		connections.put("unpooledDatasource", unpooledDatasource);
		connections.put("pooledDataSource", pooledDataSource);
		return connections;
	}
	

	@Override
	public JSONObject getEOMCheckingScripts(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "GIACS353GetCheckingScripts");
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		params.put("pageSize", 50);
		Map<String, Object> TG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonEOMCheckingScripts = new JSONObject(TG);
		return jsonEOMCheckingScripts;
	}

	@Override
	public String createCSV(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, Connection connection, String uploadPath) throws IOException, SQLException, Exception {
		DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
		DateFormat dateFormat = new SimpleDateFormat("MMddyyyyHHmmss");
		Date date = new Date();
		String[] databaseInfo = dataSource.getUrl().split(":");
		String query = request.getParameter("query");
		String scriptTitle = request.getParameter("scriptTitle");
		String month = request.getParameter("month");
		String scriptNo = request.getParameter("scriptNo");
		String year = request.getParameter("year");
		String databaseName = databaseInfo[5];
		String ip = databaseInfo[3].replaceAll("@", "");
		String username = dataSource.getUsername();
		String password = dataSource.getPassword();
		String fileName = month + year + "_script_no" + scriptNo + "_" + dateFormat.format(date) + ".csv";
		String path = request.getSession().getServletContext().getRealPath("") + "/csv\\";
		String userPath = System.getProperty("user.home") + "/Geniisys/csv\\";
		(new File(path)).mkdirs();
		
		List<Map<String, Object>> result =  giacDataCheckDAO.checkQuery(month, year, query);
		
		query = (String) result.get(0).get("script");
		String stat = (String) result.get(0).get("stat");
		
		uploadPath += "csv/";
		(new File(uploadPath)).mkdirs();
		
		
		
		String checkingScriptFilename;
		
		if(request.getParameter("header").equals("true")) {
			File checkFile = new File(uploadPath + "checking_scripts.txt");
			
			checkingScriptFilename = null;
			
			if(checkFile.exists() && !checkFile.isDirectory()){
				checkingScriptFilename = "checking_scripts_" + dateFormat.format(date) + ".txt";
				this.copyFile(uploadPath + "checking_scripts.txt", path + checkingScriptFilename);
			}	
			
			checkingScriptFilename = this.printCheckingScriptsLogHeader(path, userPath, checkingScriptFilename);
		}			
		else
			checkingScriptFilename = request.getParameter("checkingScriptFilename");
		
		this.printCheckingScriptsLogBody(path + checkingScriptFilename, userPath, scriptNo, scriptTitle, query);
		
		this.copyFile(path + checkingScriptFilename, uploadPath + "checking_scripts.txt");
		
		String[] parameters = new String[6];		
		
		parameters[0] = ip;
		parameters[1] = databaseName;
		parameters[2] = username;
		parameters[3] = password;
		parameters[4] = path + fileName;
		parameters[5] = query;		
		
		String outParams = fileName + "@" + checkingScriptFilename + "@" + uploadPath + "@" + stat + "@" + request.getHeader("Referer") + "csv/"; 
		
		String temp = CreateCSV.main(parameters, connection);
		String[] tempArray = temp.split("[\\r?\\n]+");
		outParams += "@"+tempArray.length;
		
		if(temp.toUpperCase().contains("ERROR")){
			outParams += "@The system found error in the script. Kindly check the checking script or contact the administrator for assistance.";
		}
		
		return outParams;
	}

	@Override
	public String printCheckingScriptsLogHeader(String path, String userPath, String checkingScriptFilename) throws IOException {
		DateFormat dateFormat = new SimpleDateFormat("MMddyyyyHHmmss");
		DateFormat dateFormat2 = new SimpleDateFormat("MMMM dd, yyyy EEEE dd HH:mm:ss a");
		Date date = new Date();
		String filename = (checkingScriptFilename == null ?  "checking_scripts_" + dateFormat.format(date) + ".txt" : checkingScriptFilename);
		PrintWriter printWriter = new PrintWriter(new BufferedWriter(new FileWriter(path + filename, true)));
		printWriter.println(dateFormat2.format(date));
		printWriter.println();
		printWriter.close();
		
		return filename;
	}

	@Override
	public void printCheckingScriptsLogBody(String path, String userPath, String scriptNo, String scriptTitle, String query) throws IOException {
		PrintWriter printWriter = new PrintWriter(new BufferedWriter(new FileWriter(path, true)));
		printWriter.println("  EOM Script no " + scriptNo + " : " + scriptTitle);
		printWriter.println();
		printWriter.println(query);
		printWriter.println();
		printWriter.println("-------");
		printWriter.println();
		printWriter.close();
	}

	@Override
	public void copyFile(String source, String destination) throws IOException {
		File srcFile = new File(source);
		File destFile = new File(destination);
		FileUtils.copyFile(srcFile, destFile);
	}
	
	//mikel 06.20.2016; GENQA 5544
	public void patchRecords(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		params.put("scriptType", request.getParameter("scriptType"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		this.giacDataCheckDAO().patchRecords(params);
	}
	
	
}

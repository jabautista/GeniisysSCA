package com.geniisys.giac.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

public interface GIACDataCheckService {
	JSONObject getEOMCheckingScripts(HttpServletRequest request) throws SQLException, JSONException;
	String createCSV(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, Connection connection, String uploadPath) throws IOException, SQLException, Exception;
	String printCheckingScriptsLogHeader(String path, String userPath, String checkingScriptFilename) throws IOException;
	void printCheckingScriptsLogBody(String path,  String userPath, String scriptNo, String scriptTitle, String query) throws IOException;
	void copyFile(String source, String destination) throws IOException;
	public Map<String, Object> getConnection(ApplicationContext APPLICATION_CONTEXT) throws SQLException, ClassNotFoundException;
	void patchRecords(HttpServletRequest request, String userId) throws SQLException; //mikel 06.20.2016; GENQA 5544
}

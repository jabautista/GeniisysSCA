package com.geniisys.gipi.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;

public interface GIPICAUploadService{
	String validateUploadPropertyFloater(String fileName) throws SQLException;
	Map<String, Object> readAndPreparePropertyFloater(Map<String, Object> fileParams)throws InvalidUploadFeetDataException, FileNotFoundException, IOException, ParseException, SQLException, IllegalAccessException, InvocationTargetException, NoSuchMethodException;
	void setUploadedPropertyFloater(Map<String, Object> params) throws SQLException, IllegalAccessException, InvocationTargetException, NoSuchMethodException;
	JSONObject showCaErrorLog(HttpServletRequest request) throws SQLException, JSONException;
	void uploadFloater(Map<String, Object> params) throws SQLException,JSONException, ParseException,  IOException;
}
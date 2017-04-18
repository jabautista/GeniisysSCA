package com.geniisys.giac.service.impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACGeneralLedgerReportDAO;
import com.geniisys.giac.service.GIACGeneralLedgerReportService;
import com.geniisys.gipi.util.FileUtil;

public class GIACGeneralLedgerReportServiceImpl implements GIACGeneralLedgerReportService{

	private GIACGeneralLedgerReportDAO giacGeneralLedgerReportDAO;
	
	public GIACGeneralLedgerReportDAO getGiacGeneralLedgerReportDAO() {
		return giacGeneralLedgerReportDAO;
	}

	public void setGiacGeneralLedgerReportDAO(GIACGeneralLedgerReportDAO giacGeneralLedgerReportDAO) {
		this.giacGeneralLedgerReportDAO = giacGeneralLedgerReportDAO;
	}

	@Override
	public Map<String, Object> getGiacs503NewFormInstance() throws SQLException {
		return this.getGiacGeneralLedgerReportDAO().getGiacs503NewFormInstance();
	}

	@Override
	public Map<String, Object> postGiacs503SL(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacGeneralLedgerReportDAO().postGiacs503SL(params);
	}

	@Override
	public Integer validateGiacs503BeforePrint(Map<String, Object> params) throws SQLException {
		return this.getGiacGeneralLedgerReportDAO().validateGiacs503BeforePrint(params);
	}

	@Override
	public String extractGiacs501(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		message = this.getGiacGeneralLedgerReportDAO().extractGiacs501(params);
		return message;
	}

	@Override
	public String validatePayeeCdGiacs110(HttpServletRequest request) throws SQLException {
		String payeeCd = request.getParameter("payeeCd");
		return this.getGiacGeneralLedgerReportDAO().validatePayeeCdGiacs110(payeeCd);
	}

	@Override
	public String validateTaxCdGiacs110(HttpServletRequest request) throws SQLException {
		Integer whtaxId = Integer.parseInt(request.getParameter("whtaxId"));
		return this.getGiacGeneralLedgerReportDAO().validateTaxCdGiacs110(whtaxId); 
	}

	@Override
	public String validatePayeeNoGiacs110(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("payeeNo", Integer.parseInt(request.getParameter("payeeNo")));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		return this.getGiacGeneralLedgerReportDAO().validatePayeeNoGiacs110(params);
	}

	@Override
	public String extractMotherAccounts(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		message = this.getGiacGeneralLedgerReportDAO().extractMotherAccounts(params);
		return message;
	}

	@Override
	public String extractMotherAccountsDetail(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		message = this.getGiacGeneralLedgerReportDAO().extractMotherAccountsDetail(params);
		return message;
	}

	@Override
	public JSONObject showBIRAlphalist(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBIRAlphalistMap");
		params.put("repType", request.getParameter("repType"));
		params.put("alpType", request.getParameter("alpType"));
		params.put("birFreqTagQuery", request.getParameter("birFreqTagQuery"));
		
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}

	@Override
	public String checkExtractGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("repType", request.getParameter("repType"));
		params.put("alpType", request.getParameter("alpType"));
		params.put("birFreqTagQuery", request.getParameter("birFreqTagQuery"));
		params.put("reportId", request.getParameter("reportId"));
		params.put("month", Integer.parseInt(request.getParameter("month")));
		params.put("mYear", Integer.parseInt(request.getParameter("mYear")));
		params.put("yYear", Integer.parseInt(request.getParameter("yYear")));
		return this.getGiacGeneralLedgerReportDAO().checkExtractGIACS115(params);
	}

	@Override
	public String extractGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("repType", request.getParameter("repType"));
		params.put("alpType", request.getParameter("alpType"));
		params.put("birFreqTagQuery", request.getParameter("birFreqTagQuery"));
		params.put("reportId", request.getParameter("reportId"));
		params.put("month", Integer.parseInt(request.getParameter("month")));
		params.put("mYear", Integer.parseInt(request.getParameter("mYear")));
		params.put("yYear", Integer.parseInt(request.getParameter("yYear")));
		return this.getGiacGeneralLedgerReportDAO().extractGIACS115(params); 
	}

	@Override
	public String generateCSVGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException, IOException {
		String reportId = request.getParameter("reportId");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("reportId", reportId);
		params.put("month", request.getParameter("month") == null ? null : Integer.parseInt(request.getParameter("month")));
		params.put("mYear", request.getParameter("mYear") == null ? null : Integer.parseInt(request.getParameter("mYear")));
		params.put("yYear", request.getParameter("yYear") == null ? null : Integer.parseInt(request.getParameter("yYear")));
		params.put("birFreqTagQuery", request.getParameter("birFreqTagQuery"));
		params.put("amendedRtn", request.getParameter("amendedRtn"));
		params.put("noOfSheets", request.getParameter("noOfSheets") == null ? null : Integer.parseInt(request.getParameter("noOfSheets")));
		params.put("sawtForm", request.getParameter("sawtForm"));
		params.put("userId", USER.getUserId());
		
		List<Map<String, Object>> rows;
		List<Map<String, Object>> datRows = null;
		Map<String, Object> datParams = new HashMap<String, Object>();
		
		if(reportId.equals("SAWT")){
			rows = this.getGiacGeneralLedgerReportDAO().generateSAWTCSVGIACS115(params);
			datRows = this.getGiacGeneralLedgerReportDAO().generateDATSAWTRows(params);
			datParams = this.getGiacGeneralLedgerReportDAO().generateDATSAWTDetails(params);
		}else if(reportId.equals("2550M")){ //added by robert SR 5473 03.14.16
			rows = this.getGiacGeneralLedgerReportDAO().generateCSVRLFSLS(params);
			datRows = this.getGiacGeneralLedgerReportDAO().generateDATRLFSLSRows(params);
			datParams = this.getGiacGeneralLedgerReportDAO().generateDATRLFSLSDetails(params);
		}else{
			rows = this.getGiacGeneralLedgerReportDAO().generateCSVGIACS115(params);
			if(reportId.equals("1601E")){
				datRows = this.getGiacGeneralLedgerReportDAO().generateDATMAPRows(params);
				datParams = this.getGiacGeneralLedgerReportDAO().generateDATMAPDetails(params);
			}else if(reportId.equals("1604E")){
				datRows = this.getGiacGeneralLedgerReportDAO().generateDATMAPAnnualRows(params);
				datParams = this.getGiacGeneralLedgerReportDAO().generateDATMAPAnnualDetails(params);
			}
		}

		String header = (String) datParams.get("header");
		String footer = (String) datParams.get("footer");
		String fileName = (String) datParams.get("fileName");
		
		Map<String, Object> urlParams = new HashMap<String, Object>();
		urlParams.put("dat", request.getHeader("Referer")+"bir_temp/"+ generateDATFile(header, datRows, footer, fileName, request.getSession().getServletContext().getRealPath("")));
		urlParams.put("csv", request.getHeader("Referer")+"bir_temp/"+ generateCSVFile(rows, reportId, request.getSession().getServletContext().getRealPath("")));
		urlParams.put("datFileName", fileName);
		urlParams.put("csvFileName", generateCSVFile(rows, reportId, request.getSession().getServletContext().getRealPath("")));
		JSONObject url = new JSONObject(urlParams);
		return url.toString();
	}
	
	public static String generateCSVFile(List<Map<String, Object>> rows, String fileName, String realPath) throws IOException{
		SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyyHHmmss");
		fileName = fileName + "_" + sdf.format(new Date())  + ".csv";
		realPath = realPath + "/bir_temp\\";
		
		StringBuilder strBuilder = new StringBuilder();
		Set<String> headers = null;
		
		for(Map<String, Object> row : rows){
			if(headers == null){
				headers = row.keySet();
				for(String header : headers){
					strBuilder.append("\"");
					strBuilder.append(header);
					strBuilder.append("\",");
				}
				
				strBuilder.deleteCharAt(strBuilder.length()-1);
				strBuilder.append("\n");
			}
			
			for(String header : headers){
				strBuilder.append("\"");
				if(row.get(header) == null) { //added to handle null values by robert SR 5473 03.16.16
					strBuilder.append("");				
				} else
					strBuilder.append(row.get(header));
				strBuilder.append("\",");
			}
			strBuilder.deleteCharAt(strBuilder.length()-1);
			strBuilder.append("\n");
		}
		File file = new File(realPath+fileName);
		FileUtils.writeStringToFile(file, strBuilder.toString());
		
		return file.getName();
	}

	public static String generateDATFile(String title, List<Map<String, Object>> rows, String footer, String fileName, String realPath) throws IOException{
		realPath = realPath + "/bir_temp\\";
		
		StringBuilder strBuilder = new StringBuilder();
		Set<String> headers = null;

		strBuilder.append(title);
		strBuilder.append("\n");
		
		for(Map<String, Object> row : rows){
			if(headers == null){
				headers = row.keySet();
				for(@SuppressWarnings("unused") String header : headers){
					strBuilder.append("\n");
					strBuilder.append("");
				}
				strBuilder.deleteCharAt(strBuilder.length()-1);
			}
			
			for(String header : headers){
				strBuilder.append(row.get(header));
			}
			//strBuilder.deleteCharAt(strBuilder.length()-1); //removed by robert SR 5473 03.16.16
			strBuilder.append("\n");
		}
		
		if(!(footer == null)) { //added to handle null values by robert SR 5473 03.16.16
			strBuilder.append(footer);			
		}
		File file = new File(realPath+fileName);
		FileUtils.writeStringToFile(file, strBuilder.toString());
		
		return file.getName();
	}
}

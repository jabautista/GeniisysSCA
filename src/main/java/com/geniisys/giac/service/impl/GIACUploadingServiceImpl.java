package com.geniisys.giac.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACUploadingDAO;
import com.geniisys.giac.entity.GIACUploadCollnDtl;
import com.geniisys.giac.entity.GIACUploadDvPaytDtl;
import com.geniisys.giac.entity.GIACUploadJvPaytDtl;
import com.geniisys.giac.service.GIACUploadingService;
import com.seer.framework.util.StringFormatter;

public class GIACUploadingServiceImpl implements GIACUploadingService{
	
	private GIACUploadingDAO giacUploadingDAO;
	
	public GIACUploadingDAO getGiacUploadingDAO(){
		return giacUploadingDAO;
	}
	
	public void setGiacUploadingDAO(GIACUploadingDAO giacUploadingDAO){
		this.giacUploadingDAO = giacUploadingDAO;
	}
	
	

	@Override
	public String checkFileName(HttpServletRequest request) throws SQLException {
		Map <String, Object> params = new HashMap <String, Object>();
		params.put("fileName", request.getParameter("fileName"));
		params.put("transactionType", request.getParameter("transactionType"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		return giacUploadingDAO.checkFileName(params);
	}
	
	@Override
	public Map<String, Object> readFile(File fileName, Map<String, Object> params) throws SQLException, Exception {
		
		String tranTypeCd = (String) params.get("tranTypeCd");
		String sourceCd = (String) params.get("sourceCd");
		String atmTag = giacUploadingDAO.getATMTag(sourceCd);
		String orTag = giacUploadingDAO.getGIACS601ORTag(sourceCd);
		List <Map <String, Object>> recordList = new ArrayList<Map <String, Object>> ();
		
		System.out.println("ATM TAG : " + atmTag);
		
		if(atmTag.equals("X")){
			params.put("message", "Source " + sourceCd + " does not exist in giac_file_source");
			return params;
		}
		
		try {
			HSSFWorkbook workBook = readFile(fileName);
			HSSFSheet sheet = workBook.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			//params.put("rows", String.valueOf(rows - 1));
			int rowsParams = 0;
			
			HSSFRow header = sheet.getRow(0);
			int headerCols = header.getPhysicalNumberOfCells();
			
			//checking of columns
			for(int x = 0; x < headerCols; x++) {
				HSSFCell colTitleCell = header.getCell(x);
				String colName = colTitleCell.getStringCellValue().toUpperCase( );
				if(!colName.equals("")){
					String checkColumnName = checkExcelColumnName(colName, tranTypeCd, atmTag);
					params.put("message", checkColumnName);
					if(!checkColumnName.equals("Good")){
						return params;
					}
				}
			}
			
			for (int r = 1; r < rows; r++) {
				Map <String, Object> record = new HashMap <String, Object> ();
				int validateRows = 0;
				
				System.out.println("ROW : " + r);
				
				HSSFRow row = sheet.getRow(r);
				
				if (row == null)
					continue;
				
				int cells = header.getPhysicalNumberOfCells();
				String value = "";
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
				
				for (int c = 0; c < cells; c++) {
					HSSFCell cell = row.getCell(c);
					HSSFCell title = header.getCell(c);
					String column = title.getStringCellValue().toUpperCase().trim();
					
					if (row.getCell(c) == null || row.getCell(c).getCellType() == HSSFCell.CELL_TYPE_BLANK){
						value = null;
					} else{
						validateRows = 1;
						switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_NUMERIC:
								if(HSSFDateUtil.isCellDateFormatted(cell)){
									value = sdf.format(cell.getDateCellValue()).toString();
								} else {
									if(column.equals("CHECK_NO")){ //added condition to consider numeric value for CHECK_NO in adding decimal values.
										value = new BigDecimal(cell.getNumericCellValue()).toString();
									} else {
										if (column.equals("CONVERT_RATE")) { //Deo [11.29.2016]
											BigDecimal cellVal = new BigDecimal(cell.getNumericCellValue()).setScale(9, BigDecimal.ROUND_HALF_UP);
											value = cellVal.toString();
										} else {
											BigDecimal cellVal = new BigDecimal(cell.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP); 	//shan 06.09.2015 : conversion of GIACS607
											value = cellVal.toString(); //String.valueOf((int) cell.getNumericCellValue()); 	//shan 06.09.2015 : conversion of GIACS607
										}
									}
								}
								break;
							case HSSFCell.CELL_TYPE_FORMULA:
								BigDecimal cellVal = new BigDecimal(cell.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);		//shan 06.09.2015 : conversion of GIACS607
								value = cellVal.toString(); //String.valueOf((int) cell.getNumericCellValue());		//shan 06.09.2015 : conversion of GIACS607
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue();
								break;
							default:
								value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ? String.valueOf((int) cell.getNumericCellValue()) :cell.getStringCellValue());
						}
					}
					record.put(column, value);
					System.out.println("ROW n : " + column + " ^ " + value);
				}
				
				if(validateRows == 1){
					rowsParams = rowsParams + 1;
				}
				// if all cells are null, row will not be added to list	//shan 06.09.2015 : conversion of GIACS607
				if (Collections.frequency(record.values(), null) != record.size()){
					record.put("atmTag", atmTag);
					record.put("orTag", orTag);
					recordList.add(record);
				}
			}
			
			System.out.println("recordList : " + recordList.size());	//shan 06.09.2015 : conversion of GIACS607
			
			params.put("rows", rowsParams);
			params.put("recordsConverted", /*String.valueOf(rows - 1)*/ String.valueOf(recordList.size()));	//shan 06.09.2015 : conversion of GIACS607
			params.put("atmTag", atmTag);
			params.put("orTag", orTag);
			System.out.println("recordsConverted : " + params.get("recordsConverted"));
			System.out.println("rows : " + rows);
			
			if(tranTypeCd.equals("2"))
				createFile(giacUploadingDAO.uploadExcel(params, recordList));
			else
				giacUploadingDAO.uploadExcel(params, recordList);
			
		} catch (IOException e) {
			e.printStackTrace();
		} 
		
		return params;
		
	}
	
	private HSSFWorkbook readFile(File file) throws IOException {
		return new HSSFWorkbook(new FileInputStream(file));
	}

	private String checkExcelColumnName(String columnName, String tranTypeCd, String atmTag) throws SQLException {
		String [] columns1a = {"PAYOR","BILL_NO","FCOLLECTION_AMT","PAY_MODE","CHECK_CLASS","CHECK_NO","CHECK_DATE","BANK","PAYMENT_DATE","CURRENCY_CD","CONVERT_RATE"};
		String [] columns1b = {"PAYOR","POLICY_NO","FCOLLECTION_AMT","PAY_MODE","CHECK_CLASS","CHECK_NO","CHECK_DATE","BANK","PAYMENT_DATE","CURRENCY_CD","CONVERT_RATE"};
		String [] columns2 = {"PAYOR","POLICY_NO","ENDT_NO","FGROSS_PREM_AMT","FCOMM_AMT","FWHTAX_AMT","FINPUT_VAT_AMT","FNET_AMT_DUE","GROSS_TAG","INTM_NO","CURRENCY_CD","CONVERT_RATE"};
		//String [] columns2 = {"PAYOR","ENDT_NO","POLICY_NO","FINPUT_VAT_AMT","FCOMM_AMT","FGROSS_PREM_AMT","FWHTAX_AMT","FNET_AMT_DUE","GROSS_TAG","INTM_NO","CURRENCY_CD","CONVERT_RATE"};
		String [] columns3 = {"ASSURED","POLICY_NO","FPREM_AMT","FTAX_AMT","FCOMM_AMT","FCOMM_VAT","FCOLLECTION_AMT","CURRENCY_CD","CONVERT_RATE","RI_CD"};
		String [] columns4 = {"BINDER_NO","FPREM_AMT","FPREM_VAT","FCOMM_AMT","FCOMM_VAT","FWHOLDING_VAT","FDISB_AMT","CURRENCY_CD","CONVERT_RATE","RI_CD"};
		String [] columns5 = {"BANK_REFERENCE_NUMBER","PAYOR","AMOUNT","DEPOSIT_DATE"};
		String [] looper = {};
		
		if(tranTypeCd.equals("1")){
			if(atmTag.equals("Y"))
				looper = columns1a;
			else
				looper = columns1b;
		} else if (tranTypeCd.equals("2")) {
			looper = columns2;
		} else if (tranTypeCd.equals("3")) {
			looper = columns3;
		} else if (tranTypeCd.equals("4")) {
			looper = columns4;
		} else if (tranTypeCd.equals("5")) {
			looper = columns5;
		}
		
		//boolean checker = false;
		char checker = 'N';
		
		for (int x = 0; x < looper.length; x++) {
			if(looper[x].equals(columnName.trim().toUpperCase())){
				checker = 'Y';
			}
		}
		
		
		if(checker=='Y'){
			return "Good";
		}
		else{
			return "Error in converting file. Invalid column name: " + columnName + " found in excel file.";
		}
	}

	@Override
	public Integer countExcelRows(File file) throws IOException {
		HSSFWorkbook workBook = readFile(file);
		HSSFSheet sheet = workBook.getSheetAt(0);
		return sheet.getPhysicalNumberOfRows() - 1;
	}

	@Override
	public void createFile(List<String> queryList) throws IOException {
		
		String fileName = "C:\\select.txt";
		File file = new File(fileName);
		
		if(!file.exists())
			file.createNewFile();
		
		BufferedReader br = null;
		List<String> line = new ArrayList<String>();
		
		try {
			
			String currentLine;
			
			br = new BufferedReader(new FileReader(fileName));
			
			while ((currentLine = br.readLine()) != null) {
				line.add(currentLine);
			}
			
			PrintWriter pw = new PrintWriter(fileName, "UTF-8");
			
			for (int count = 0; count < line.size(); count++ ){
				pw.println(line.get(count));
			}
			
			for (int count = 0; count < queryList.size(); count++) {
				pw.println();
				pw.println(queryList.get(count));
			}
			
			pw.close();
			
		} finally {
			try {
				if(br != null)
					br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public JSONObject getProcessDataList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getProcessDataList");
		params.put("sourceCd", request.getParameter("sourceCd"));
		Map<String, Object> processDataTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonProcessDataList = new JSONObject(processDataTG);
		return jsonProcessDataList;
	}
	
	@Override
	public Map<String, Object> showGiacs603Head(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.showGiacs603Head(params);
	}
	
	@Override
	public JSONObject showGiacs603RecList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs603RecList");
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		System.out.println("test param nieko : " + params); //nieko 0824
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		System.out.println("test param nieko 2 : " + recList); //nieko 0824
		
		return new JSONObject(recList);
	}

	@Override
	public Map<String, Object> showGiacs603Legend(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		List<?> list = giacUploadingDAO.showGiacs603Legend();
		params.put("rows", new JSONArray());
		for (Object o: list) {
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		return params;
	}
	
	@Override
	public Map<String, Object> showGiacUploadDvPaytDtl(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadDvPaytDtl(params);
	}
	
	@Override
	public void saveGiacs603DVPaytDtl(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUploadDvPaytDtl.class));
		params.put("appUser", userId);
		giacUploadingDAO.setGiacs603DVPaytDtl(params);
	}
	
	@Override
	public void delGiacs603DVPaytDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		giacUploadingDAO.delGiacs603DVPaytDtl(params);
	}
	
	@Override
	public Map<String, Object> showGiacUploadJvPaytDtl(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadJvPaytDtl(params);
	}
	
	@Override
	public void saveGiacs603JVPaytDtl(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUploadJvPaytDtl.class));
		params.put("appUser", userId);
		giacUploadingDAO.setGiacs603JVPaytDtl(params);
	}
	
	@Override
	public void delGiacs603JVPaytDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		giacUploadingDAO.delGiacs603JVPaytDtl(params);
	}
	
	@Override
	public void checkDataGiacs603(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.checkDataGiacs603(params);
	}
	
	@Override
	public void cancelFileGiacs603(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.cancelFileGiacs603(params);
	}
	
	@Override
	public void validateUploadGiacs603(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.validateUploadGiacs603(params);
	}
	
	public Map<String, Object> getDefaultBank(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		return this.giacUploadingDAO.getDefaultBank(params);
	}
	
	public Map<String, Object> processGiacs603(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orDate", request.getParameter("orDate"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("userId", userId);
		return this.giacUploadingDAO.processGiacs603(params);
	}
	
	public Map<String, Object> giacs603CheckForOverride(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		return this.giacUploadingDAO.giacs603CheckForOverride(params);
	}
	
	@Override
	public void giacs603UploadPayments(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("paymentDate", request.getParameter("paymentDate"));
		params.put("dcbBankCd", request.getParameter("dcbBankCd"));
		params.put("dcbBankAcctCd", request.getParameter("dcbBankAcctCd"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("userId", userId);
		giacUploadingDAO.giacs603UploadPayments(params);
	}
	
	@Override
	public Map<String, Object> checkPaymentDetails(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("userId", userId);
		return giacUploadingDAO.checkPaymentDetails(params);
	}
	
	@Override
	public Map<String, Object> validatePrintOr(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.validatePrintOr(params);
	}
	
	@Override
	public Map<String, Object> validatePrintDv(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.validatePrintDv(params);
	}
	
	@Override
	public Map<String, Object> validatePrintJv(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.validatePrintJv(params);
	}
	
	public Map<String, Object> getGIACS607Parameters(String userId) throws SQLException{		//shan 06.09.2015 : conversion of GIACS607
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		
		return this.giacUploadingDAO.getGIACS607Parameters(params);
	}
	
	public String getGIACS607Legend(String rvDomain) throws SQLException{
		return this.giacUploadingDAO.getGIACS607Legend(rvDomain);
	}
	
	public JSONObject getGIACS607GUFDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		return new JSONObject(this.giacUploadingDAO.getGIACS607GUFDetails(params));
	}
	
	public JSONObject getGIACS607GUPCRecords(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS607GUPCRecords");
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		
		Map<String, Object> gupcTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(gupcTG);
	}
	
	public JSONObject getGIACS607GUDVDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		return new JSONObject(this.giacUploadingDAO.getGIACS607GUDVDetails(params));
	}
	
	public void saveGIACS607Gudv(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRec")), userId, GIACUploadDvPaytDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRec")), userId, GIACUploadDvPaytDtl.class));
		params.put("appUser", userId);
		
		this.giacUploadingDAO.saveGIACS607Gudv(params);
	}
	
	public JSONObject getGIACS607GUJVDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		return new JSONObject(this.giacUploadingDAO.getGIACS607GUJVDetails(params));
	}
	
	public void saveGIACS607Gujv(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("appUser", userId);
		
		this.giacUploadingDAO.saveGIACS607Gujv(params);
	}
	
	public JSONObject getGIACS607GUCDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS607GUCDetailRecords");
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		
		Map<String, Object> gucdTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGUCD = new JSONObject(gucdTG);
		
		return jsonGUCD;
	}
	
	public void saveGIACS607Gucd(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUploadCollnDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACUploadCollnDtl.class));
		params.put("appUser", userId);
		
		this.giacUploadingDAO.saveGIACS607Gucd(params);
	}
	
	public void checkNetCollnGIACS607(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		this.giacUploadingDAO.checkNetCollnGIACS607(params);
	}
	
	public void updateGIACS607GrossTag(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("grossTag", request.getParameter("grossTag"));
		
		this.giacUploadingDAO.updateGIACS607GrossTag(params);
	}
	
	public void cancelFileGIACS607(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		this.giacUploadingDAO.cancelFileGIACS607(params);
	}
	
	public String checkOrPaytsGIACS607(String tranId) throws SQLException{
		return this.giacUploadingDAO.checkOrPaytsGIACS607(tranId);
	}
	
	public void validateBeforeUploadGIACS607(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		params.put("tranClass", request.getParameter("tranClass"));
		
		this.giacUploadingDAO.validateBeforeUploadGIACS607(params);
	}
	
	public Map<String, Object> validatePolicyGIACS607(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		
		params = this.giacUploadingDAO.validatePolicyGIACS607(params);
		
		return params;
	}
	
	public String checkUserBranchAccessGIACS607(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		return this.giacUploadingDAO.checkUserBranchAccessGIACS607(params);
	}
	
	public Map<String, Object> checkUploadGIACS607(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("dspTranClass", request.getParameter("dspTranClass"));
		params.put("userId", userId);
		
		return this.giacUploadingDAO.checkUploadGIACS607(params);
	}
	
	public Integer getParentIntmNoGIACS607(String intmNo) throws SQLException{
		return this.giacUploadingDAO.getParentIntmNoGIACS607(intmNo);
	}
	
	public void uploadPaymentsGIACS607(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("nbtTranClass", request.getParameter("nbtTranClass"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("userId", userId);
		params.putAll(JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("parameters"))));
		
		this.giacUploadingDAO.uploadPaymentsGIACS607(params);
	}
	
	public Map<String, Object> validateOnPrintBtnGIACS607(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		
		return this.giacUploadingDAO.validateOnPrintBtnGIACS607(params);
	} 	//end conversion of GIACS607
	
	//john 9.3.2015 - conversion of GIACS604
	@Override
	public Map<String, Object> showGiacs604Head(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.showGiacs604Head(params);
	}
	
	@Override
	public JSONObject showGiacs604RecList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs604RecList");
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		System.out.println("test param nieko 604 : " + recList); //nieko 0824
		return new JSONObject(recList);
	}
	
	@Override
	public void checkDataGiacs604(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.checkDataGiacs604(params);
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintOr(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs604ValidatePrintOr(params);
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintDv(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs604ValidatePrintDv(params);
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintJv(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs604ValidatePrintJv(params);
	}
	
	@Override
	public void cancelFileGiacs604(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.cancelFileGiacs603(params);
	}
	
	@Override
	public Map<String, Object> showGiacUploadDvPaytDtlGiacs604(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadDvPaytDtlGiacs604(params);
	}
	
	@Override
	public Map<String, Object> showGiacUploadJvPaytDtlGiacs604(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadJvPaytDtlGiacs604(params);
	}
	
	@Override
	public void checkForClaim(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		giacUploadingDAO.checkForClaim(params);
	}
	
	@Override
	public void checkForOverride(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		giacUploadingDAO.checkForOverride(params);
	}
	
	@Override
	public void giacs604UploadPayments(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("paymentDate", request.getParameter("paymentDate"));
		params.put("dcbBankCd", request.getParameter("dcbBankCd"));
		params.put("dcbBankAcctCd", request.getParameter("dcbBankAcctCd"));
		params.put("tranClass", request.getParameter("tranClass"));
		giacUploadingDAO.giacs604UploadPayments(params);
	}
	
	
	//john 9.22.2015 : Conversion of GIACS608
	@Override
	public Map<String, Object> showGiacs608Legend(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		List<?> list = giacUploadingDAO.showGiacs608Legend();
		params.put("rows", new JSONArray());
		for (Object o: list) {
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		return params;
	}
	
	@Override
	public Map<String, Object> giacs608Guf(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs608Guf(params);
	}
	
	@Override
	public JSONObject showGiacs608RecList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs608GiupTable");
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public Map<String, Object> giacs608GiupTableTotal(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		System.out.println(giacUploadingDAO.giacs608GiupTableTotal(params));
		return giacUploadingDAO.giacs608GiupTableTotal(params);
	}
	
	public JSONObject getGIACS608GUCDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS608GUCDetailRecords");
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		
		Map<String, Object> gucdTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGUCD = new JSONObject(gucdTG);
		
		return jsonGUCD;
	}
	
	public void saveGIACS608Gucd(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUploadCollnDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACUploadCollnDtl.class));
		params.put("appUser", userId);
		
		this.giacUploadingDAO.saveGIACS608Gucd(params);
	}
	
	@Override
	public Map<String, Object> showGiacUploadDvPaytDtlGiacs608(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadDvPaytDtlGiacs608(params);
	}
	
	@Override
	public Map<String, Object> showGiacUploadJvPaytDtlGiacs608(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", USER.getUserId());
		return giacUploadingDAO.showGiacUploadJvPaytDtlGiacs608(params);
	}
	
	@Override
	public void checkDataGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.checkDataGiacs608(params);
	}
	
	@Override
	public void checkCollectionAmountGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		giacUploadingDAO.checkCollectionAmountGiacs608(params);
	}
	
	@Override
	public void checkPaymentDetailsGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		giacUploadingDAO.checkPaymentDetailsGiacs608(params);
	}
	
	@Override
	public Map<String, Object> getParametersGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.getParametersGiacs608(params);
	}
	
	@Override
	public void proceedUploadGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("override", request.getParameter("override"));
		params.put("orDate", request.getParameter("orDate")); //nieko Accounting Uploading
		giacUploadingDAO.proceedUploadGiacs608(params);
	}
	
	//GIACS610
	@Override
	public Map<String, Object> showGiacs610Legend(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		List<?> list = giacUploadingDAO.showGiacs610Legend();
		params.put("rows", new JSONArray());
		for (Object o: list) {
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		return params;
	}
	
	@Override
	public Map<String, Object> showGiacs610Guf(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.showGiacs610Guf(params);
	}
	
	@Override
	public JSONObject showGiacs610RecList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("ACTION", "getGiacs610GuprTable"); //Deo [10.06.2016]: comment out
		params.put("ACTION", "getGiacs610Records"); //Deo [10.06.2016]
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void checkDataGiacs610(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.checkDataGiacs610(params);
	}
	
	@Override
	public void checkValidatedGiacs610(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.checkValidatedGiacs610(params);
	}
	
	public Map<String, Object> getDefaultBankGiacs610(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		return this.giacUploadingDAO.getDefaultBankGiacs610(params);
	}
	
	@Override
	public void checkDcbNoGiacs610(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		giacUploadingDAO.checkDcbNoGiacs610(params);
	}
	
	@Override
	public void uploadPaymentsGiacs610(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("userId", userId);
		params.put("processAll", request.getParameter("processAll")); //Deo [10.06.2016]
		params.put("recId", request.getParameter("recId"));	//Deo [10.06.2016]
		giacUploadingDAO.uploadPaymentsGiacs610(params);
	}
	
	//Deo [10.06.2016]: add start
	@Override
	public void validateUploadTranDate(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.validateUploadTranDate(params);
	}
	
	@Override
	public void cancelFileGiacs610(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.cancelFileGiacs610(params);
	}
	
	@Override
	public Map<String, Object> giacs610ValidatePrintOr(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs610ValidatePrintOr(params);
	}
	
	@Override
	public void preUploadCheck(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.preUploadCheck(params);
	}
	
	@Override
	public Map<String, Object> getValidRecords(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		List<?> list = giacUploadingDAO.getValidRecords(params);
		params.put("rows", new JSONArray());
		for (Object o: list) {
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		return params;
	}
	
	@Override
	public JSONObject setTaggedRows(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		JSONObject json = new JSONObject(params);
		return json;
	}
	
	@Override
	public void saveGiacs610JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("appUser", userId);
		this.giacUploadingDAO.saveGiacs610JVDtls(params);
	}
	//Deo [10.06.2016]: add ends
	
	//Deo: GIACS609 conversion start
	@Override
	public Map<String, Object> showGiacs609Head(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		return giacUploadingDAO.showGiacs609Head(params);
	}
	
	@Override
	public String getGiacs609legend() throws SQLException{
		return this.giacUploadingDAO.getGiacs609legend();
	}
	
	@Override
	public JSONObject showGiacs609RecList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs609Records");
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public Map<String, Object> getGiacs609Parameters(String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return this.giacUploadingDAO.getGiacs609Parameters(params);
	}
	
	@Override
	public JSONObject getGiacs609CollnDtls(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs609CollnDtls");
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		Map<String, Object> gucdTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGUCD = new JSONObject(gucdTG);
		return jsonGUCD;
	}
	
	@Override
	public void saveGiacs609CollnDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUploadCollnDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACUploadCollnDtl.class));
		params.put("appUser", userId);
		params.put("delAll", request.getParameter("delAll"));
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		this.giacUploadingDAO.saveGiacs609CollnDtls(params);
	}
	
	@Override
	public List<Map<String, Object>> getGiacs609ORCollnDtls(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranId", request.getParameter("tranId"));
		return giacUploadingDAO.getGiacs609ORCollnDtls(params);
	}
	
	@Override
	public void validateCollnAmtGiacs609(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		this.giacUploadingDAO.validateCollnAmtGiacs609(params);
	}
	
	@Override
	public JSONObject getGiacs609DVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return new JSONObject(this.giacUploadingDAO.getGiacs609DVDtls(params));
	}
	
	@Override
	public void saveGiacs609DVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRec")), userId, GIACUploadDvPaytDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRec")), userId, GIACUploadDvPaytDtl.class));
		params.put("appUser", userId);
		this.giacUploadingDAO.saveGiacs609DVDtls(params);
	}
	
	@Override
	public JSONObject getGiacs609JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return new JSONObject(this.giacUploadingDAO.getGiacs609JVDtls(params));
	}
	
	@Override
	public void saveGiacs609JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRec")), userId, GIACUploadJvPaytDtl.class));
		params.put("appUser", userId);
		this.giacUploadingDAO.saveGiacs609JVDtls(params);
	}
	
	@Override
	public void checkDataGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("overridden", request.getParameter("overridden"));
		params.put("userId", userId);
		giacUploadingDAO.checkDataGiacs609(params);
	}
	
	@Override
	public Map<String, Object> validatePrintGiacs609(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("tranId", request.getParameter("tranId"));
		params.put("userId", userId);
		return this.giacUploadingDAO.validatePrintGiacs609(params);
	}
	
	@Override
	public Map<String, Object> uploadBeginGiacs609(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("userId", userId);
		return this.giacUploadingDAO.uploadBeginGiacs609(params);
	}
	
	@Override
	public Map<String, Object> validateTranDateGiacs609(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("userId", userId);
		return this.giacUploadingDAO.validateTranDateGiacs609(params);
	}
	
	@Override
	public Map<String, Object> checkUploadAllGiacs609(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("userId", userId);
		return this.giacUploadingDAO.checkUploadAllGiacs609(params);
	}
	
	@Override
	public void uploadPaymentsGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("userId", userId);
		giacUploadingDAO.uploadPaymentsGiacs609(params);
	}
	
	@Override
	public void cancelFileGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		giacUploadingDAO.cancelFileGiacs609(params);
	}
	//Deo: GIACS609 conversion ends
	
	@Override
	public Map<String, Object> giacs608ValidatePrintOr( HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		params.put("userId", userId);
		return giacUploadingDAO.giacs608ValidatePrintOr(params);
	}

	@Override
	public void checkDcbNoGiacs604(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("userId", userId);
		giacUploadingDAO.checkDcbNoGiacs604(params);
	}

	@Override
	public void checkDcbNoGiacs603(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("userId", userId);
		giacUploadingDAO.checkDcbNoGiacs603(params);
		
	}

	@Override
	public void checkDcbNoGiacs608(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("userId", userId);
		giacUploadingDAO.checkDcbNoGiacs608(params);
	}

	@Override
	public void checkDcbNoGiacs607(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orDate", request.getParameter("orDate"));
		params.put("userId", userId);
		giacUploadingDAO.checkDcbNoGiacs607(params);
	}

	@Override
	public void checkNetCollnGIACS608(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sourceCd", request.getParameter("sourceCd"));
		params.put("fileNo", request.getParameter("fileNo"));
		
		this.giacUploadingDAO.checkNetCollnGIACS608(params);
		
	}
}

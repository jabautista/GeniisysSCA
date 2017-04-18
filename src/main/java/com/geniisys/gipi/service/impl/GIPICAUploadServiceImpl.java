package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.exceptions.MediaAlreadyExistingException;
import com.geniisys.common.exceptions.UploadSizeLimitExceededException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPICAUploadDAO;
import com.geniisys.gipi.entity.GIPICAUpload;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;
import com.geniisys.gipi.service.GIPICAUploadService;
import com.geniisys.gipi.service.GIPIWCasualtyItemService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.util.FileUtil;

public class GIPICAUploadServiceImpl implements GIPICAUploadService{
	
	private GIPICAUploadDAO gipiCaUploadDAO;
	private GIPIWItemService gipiWItemService;
	private GIPIWCasualtyItemService gipiWCasualtyItemService;
	private static Logger log = Logger.getLogger(GIPICAUploadServiceImpl.class);
	
	public void setGipiCaUploadDAO(GIPICAUploadDAO gipiCaUploadDAO) {
		this.gipiCaUploadDAO = gipiCaUploadDAO;
	}
	
	public GIPICAUploadDAO getGipiCaUploadDAO() {
		return gipiCaUploadDAO;
	}
	
	public GIPIWItemService getGipiWItemService() {
		return gipiWItemService;
	}

	public void setGipiWItemService(GIPIWItemService gipiWItemService) {
		this.gipiWItemService = gipiWItemService;
	}

	public GIPIWCasualtyItemService getGipiWCasualtyItemService() {
		return gipiWCasualtyItemService;
	}

	public void setGipiWCasualtyItemService(
			GIPIWCasualtyItemService gipiWCasualtyItemService) {
		this.gipiWCasualtyItemService = gipiWCasualtyItemService;
	}

	@Override
	public String validateUploadPropertyFloater(String fileName) throws SQLException {
		return this.getGipiCaUploadDAO().validateUploadPropertyFloater(fileName);
	}

	private HSSFWorkbook readXlsFile(File file) throws IOException {
		return new HSSFWorkbook(new POIFSFileSystem(new FileInputStream(file)));
	}
	
	private XSSFWorkbook readXlsxFile(File file) throws IOException{
		return new XSSFWorkbook(new FileInputStream(file));
	}
	
	@Override
	public Map<String, Object> readAndPreparePropertyFloater(
			Map<String, Object> fileParams)
			throws InvalidUploadFeetDataException, FileNotFoundException,
			IOException, ParseException, SQLException, IllegalAccessException,
			InvocationTargetException, NoSuchMethodException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		List<GIPIWItem> items = null;
		List<GIPIWCasualtyItem> casualtyItem = null;
		List<GIPICAUpload> floaterUploads = null;
		List<Map<String, Object>> errorLogs = null;
		List<GIPIWItemPeril> perilList = null;
		
		File fileName  = (File) fileParams.get("uploadedFile");
		String userId  = (String) fileParams.get("userId");
		String myFileName = (String) fileParams.get("myFileName");
	    Integer parId  = (Integer)fileParams.get("parId");
	    String sublineCd  = (String) fileParams.get("sublineCd");
		String lineCd = (String) fileParams.get("lineCd");
		String packPolFlag = (String) fileParams.get("packPolFlag");
		String excelFileType = myFileName.substring(myFileName.indexOf("."));
		
		int uploadCtr = 0;
		int errorCtr = 0;
		Integer uploadNo = null;
		
		Boolean chkItem = false;
		Boolean chkCasualtyItem = false;
		Boolean chkUpload = false;
		Boolean checkRequiredFields = false;
		Boolean hasPeril = false;
		try {
			Workbook fleet = null;
			Sheet sheet = null;
			Row columnRow = null;
			Row row = null;
			Cell cell = null;
			if(excelFileType.equals(".xlsx")){
				fleet = (XSSFWorkbook) readXlsxFile(fileName);
				sheet = (XSSFSheet) fleet.getSheetAt(0);
				columnRow = (XSSFRow) sheet.getRow(0);
			}else{
				fleet = (HSSFWorkbook) readXlsFile(fileName);
				sheet = (HSSFSheet) fleet.getSheetAt(0);
				columnRow = (HSSFRow) sheet.getRow(0);
			}

			int rows = sheet.getPhysicalNumberOfRows();		
			if (rows >= 2) {
				 items = new ArrayList<GIPIWItem>();
				 casualtyItem = new ArrayList<GIPIWCasualtyItem>();
				 floaterUploads = new ArrayList<GIPICAUpload>();
				 errorLogs = new ArrayList<Map<String,Object>>();
				 perilList = new ArrayList<GIPIWItemPeril>();
			}
			
			int cells = 0;
			cells = columnRow.getPhysicalNumberOfCells();
			
			rowLoop: for (int r = 0; r < rows; r++) {
				if(excelFileType.equals(".xlsx")){
					row = (XSSFRow) sheet.getRow(r);
				}else{
					row = (HSSFRow) sheet.getRow(r);
				}
				
				if (row == null) {
					continue;
				}
				
				String value = null;
				GIPIWItem uItem = new GIPIWItem();
				GIPIWCasualtyItem uCasualtyItem = new GIPIWCasualtyItem();
				GIPICAUpload uFloaterUploads = new GIPICAUpload();
				Map<String, Object> errorLog = new HashMap<String, Object>();
				GIPIWItemPeril uPerilList = new GIPIWItemPeril();
				
				for (int c = 0; c < cells; c++) {
					
					if(excelFileType.equals(".xlsx")){
						cell = (XSSFCell) row.getCell(c);
					}else{
						cell = (HSSFCell) row.getCell(c);
					}
					
					if (r==0){
						if(cell.getStringCellValue().trim().equals("PERIL_CD")){
							hasPeril = true;
						}
					}else{
						
						if(row.getCell(c) == null) {
							value = null;
						}else{
							if(excelFileType.equals(".xlsx")){
								switch (cell.getCellType()) {
								case XSSFCell.CELL_TYPE_NUMERIC:
									value = String.valueOf((int) cell.getNumericCellValue()).trim();
									break;
								case XSSFCell.CELL_TYPE_STRING:
									value = cell.getStringCellValue().trim();
									break;
								default:
									value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ?  null :cell.getStringCellValue().trim());
								}
							}else{
								switch (cell.getCellType()) {
								case HSSFCell.CELL_TYPE_NUMERIC:
									value = String.valueOf((int) cell.getNumericCellValue()).trim();
									break;
								case HSSFCell.CELL_TYPE_STRING:
									value = cell.getStringCellValue().trim();
									break;
								default:
									value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ?  null :cell.getStringCellValue().trim());
								}
							}
						}
						
						switch (c) {
							case 0: break; 
							case 1:
								if(value == null || value.equals("")){
									log.info("Item no is null.");
									uCasualtyItem.setRemarks("Item no is null.");
									checkRequiredFields = true;
									continue rowLoop;
								} else {
									uItem.setItemNo(Integer.parseInt(value));
								}
								break;
							case 2:
								if (value == null || value.equals("")) {
									log.info("Item Title is null.");
									uCasualtyItem.setRemarks("Item Title no is null.");
									checkRequiredFields = true;
								}else {
									uItem.setItemTitle(value);
								}
								break;
							case 3:
								if (value == null || value.equals("")) {
									log.info("Currency Cd is null.");
									uCasualtyItem.setRemarks("Currency Cd is null.");
									checkRequiredFields = true;
								} else {
									uItem.setCurrencyCd(Integer.parseInt(value));
								}
								break;
							case 4:
								if (value == null || value.equals("")) {
									log.info("Currency Rate is null.");
									uCasualtyItem.setRemarks("Currency Rate is null.");
									checkRequiredFields = true;
								} else {
									uItem.setCurrencyRt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								}
								break;
							case 5: uItem.setItemDesc(null);
								break;
							case 6: uItem.setItemDesc2(value);
								break;
							case 8:
								if (value == null || value.equals("")) {
									log.info("Region Cd is null.");
									uCasualtyItem.setRemarks("Region Cd is null.");
									checkRequiredFields = true;
								} else {
									uItem.setRegionCd(Integer.parseInt(value));
								}	
								break;
							default:
						}
						
						uItem.setParId(parId);
						uItem.setUserId(userId);
						uItem.setItemGrp(Integer.parseInt("1"));
							
						if (packPolFlag.equals("Y")){
							uItem.setPackLineCd(lineCd);
							uItem.setPackSublineCd(sublineCd);
						}
							
						switch(c) {
							case 1: 
								if(value == null || value.equals("")){
									log.info("Item no is null.");
									uCasualtyItem.setRemarks("Item no is null.");
									checkRequiredFields = true;
								} else {
									uCasualtyItem.setItemNo(value);
								}
								break;
							case 7: 
								if(value == null || value.equals("")){
									log.info("Location Cd is null.");
									uCasualtyItem.setRemarks("Location Cd is null.");
									checkRequiredFields = true;
								} else {
									uCasualtyItem.setLocationCd(value);
								}
								break;
							case 9: 
								if(value == null || value.equals("")){
									log.info("Location is null.");
									uCasualtyItem.setRemarks("Location is null.");
									checkRequiredFields = true;
								} else {
									uCasualtyItem.setLocation(value);
								}
								break;
							case 10: uCasualtyItem.setLimitOfLiability(value);
									break;
							case 11: uCasualtyItem.setInterestOnPremises(value);
									break;
							case 12: uCasualtyItem.setSectionOrHazardInfo(value);
									break;
							case 13: uCasualtyItem.setConveyanceInfo(value);
									break;
							case 14: uCasualtyItem.setPropertyNoType(value);
									break;
							case 15: uCasualtyItem.setPropertyNo(value);
									break;
							default:
						}
						uCasualtyItem.setParId(parId.toString());
						uCasualtyItem.setAppUser(userId);
						
						if(hasPeril){
							switch(c) {
							case 16: 
								if(value == null || value.equals("")){
									log.info("Peril Cd is null.");
									uCasualtyItem.setRemarks("Peril Cd is null.");
									checkRequiredFields = true;
								} else {
									uPerilList.setPerilCd(Integer.parseInt(value));
								}
								break;
							case 17: 
								if(value == null || value.equals("")){
									log.info("Premium rate is null.");
									uCasualtyItem.setRemarks("Premium rate is null.");
									checkRequiredFields = true;
								} else {
									uPerilList.setPremRt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								}
								break;
							case 18: 
								if(value == null || value.equals("")){
									log.info("TSI amount is null.");
									uCasualtyItem.setRemarks("TSI amount is null.");
									checkRequiredFields = true;
								} else {
									uPerilList.setTsiAmt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								}
								break;
							case 19: 
								if(value == null || value.equals("")){
									log.info("Premium amount is null.");
									uCasualtyItem.setRemarks("Premium amount is null.");
									checkRequiredFields = true;
								} else {
									uPerilList.setPremAmt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								}
								break;
							case 20: uPerilList.setAggregateSw(value);
								break;
							case 21: uPerilList.setRiCommRate(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;
							case 22: uPerilList.setRiCommAmt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;
							default:
						}
							uPerilList.setParId(parId);
							uPerilList.setAppUser(userId);
							uPerilList.setLineCd(lineCd);
							uPerilList.setItemNo(uItem.getItemNo());
						}
					}
				}
				
				uFloaterUploads.setUserId(userId);
				uFloaterUploads.setFileName(myFileName);
				
				if(uItem.getItemNo() != null) {
					for(GIPIWItem itm : items){
						if(itm.getItemNo().equals(uItem.getItemNo())) {
							chkItem = true;
							break;
						}
					}

					for(GIPIWCasualtyItem cv: casualtyItem) {
						if(cv.getItemNo().equals(uCasualtyItem.getItemNo())) {
							chkCasualtyItem = true;
							break;
						}
					}
					
					if((!chkItem && !chkCasualtyItem && !chkUpload) && (uCasualtyItem.getRemarks() == null || uCasualtyItem.getRemarks() == "")) {
						if(uploadCtr == 0) {
							if(uploadNo == null || uploadNo < 1) uploadNo = this.getGipiCaUploadDAO().getCaNextUploadNo();
							uFloaterUploads.setUploadNo(uploadNo);
							floaterUploads.add(uFloaterUploads);
						}
						items.add(uItem);
						casualtyItem.add(uCasualtyItem);
						if(hasPeril){
							perilList.add(uPerilList);
						}
						uploadCtr++;
					} else if ((chkItem || chkCasualtyItem || chkUpload) && (uCasualtyItem.getRemarks() == null || uCasualtyItem.getRemarks() == "")) {
						if(uploadNo == null || uploadNo < 1) uploadNo = this.getGipiCaUploadDAO().getCaNextUploadNo();
						errorLog = this.prepareCAErrorLog(uItem, uCasualtyItem);
						errorLog.put("uploadNo", uploadNo);
						errorLog.put("fileName", myFileName.substring(0, myFileName.indexOf(".")));
						errorLog.put("remarks", "DUPLICATE RECORD EXISTS.");
						errorLogs.add(errorLog);
						errorCtr++;
					} else if (uCasualtyItem.getRemarks() != null || uCasualtyItem.getRemarks() != ""){
						if(uploadNo == null || uploadNo < 1) uploadNo = this.getGipiCaUploadDAO().getCaNextUploadNo();
						errorLog = this.prepareCAErrorLog(uItem, uCasualtyItem);
						errorLog.put("uploadNo", uploadNo);
						errorLog.put("fileName", myFileName.substring(0, myFileName.indexOf(".")));
						errorLog.put("remarks", uCasualtyItem.getRemarks());
						errorLogs.add(errorLog);
						errorCtr++;
					}
					chkItem = false;
					chkCasualtyItem = false;
					chkUpload = false;
				}
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new InvalidUploadFeetDataException("The file has invalid data formatting.");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		params.put("gipiWItem", items);
		params.put("gipiWCasualtyItem", casualtyItem);
		params.put("floaterUploads", floaterUploads);
		params.put("errorLogs", errorLogs);
		params.put("appUser", userId);
		params.put("recordsUploaded", uploadCtr);
		params.put("totalErrors", errorCtr);
		params.put("totalRecords", uploadCtr+errorCtr);
		params.put("checkRequiredFields", checkRequiredFields);
		params.put("gipiWItemPeril", perilList);
		return params;
	}

	@Override
	public void setUploadedPropertyFloater(Map<String, Object> params)
			throws SQLException, IllegalAccessException,
			InvocationTargetException, NoSuchMethodException {
		this.getGipiCaUploadDAO().setRecordsOnUpload(params);
	}

	private Map<String, Object> prepareCAErrorLog(GIPIWItem item, GIPIWCasualtyItem casualty) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.putAll(FormInputUtil.formMapFromEntity(casualty));
		params.putAll(FormInputUtil.formMapFromEntity(item));
		return params;
	}

	@Override
	public JSONObject showCaErrorLog(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCaErrorLog");		
		Map<String, Object> errorLog = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(errorLog);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void uploadFloater(Map<String, Object> params) throws SQLException, JSONException, ParseException, IOException {
		ApplicationContext APPLICATION_CONTEXT= (ApplicationContext) params.get("APPLICATION_CONTEXT");
		ServletContext servletContext = (ServletContext) params.get("servletContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		HttpServletResponse response = (HttpServletResponse) params.get("response");
		HttpSession session = (HttpSession) params.get("session");
		String filePath = (String) APPLICATION_CONTEXT.getBean("uploadPath");
		GIPICAUploadService gipiCaUploadService = (GIPICAUploadService) APPLICATION_CONTEXT.getBean("gipiCaUploadService");
		
		Integer parId = Integer.parseInt((null == request.getParameter("parId") || "".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId")));
		
		response.setContentType("text/html");

		// create file upload factory and upload servlet
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);

		// set file upload progress listener
		FileUploadListener listener = new FileUploadListener();
		
		session.setAttribute("LISTENER", listener);
		
		// upload servlet allows to set upload listener
		upload.setProgressListener(listener);

		// to be used to write response
		StringBuffer sb = new StringBuffer();
		
		List items = null;
		FileItem fileItem = null;
		String myFileName = "";
		
		try{
		Map<String, Object> params1 = new HashMap<String, Object>();
		
		(new File(filePath+"/"+parId)).mkdir();
		filePath = filePath + "/" + parId;
		
		// iterate over all uploaded files
		items = upload.parseRequest(request);
		File uploadedFile = null;
		for (Iterator i = items.iterator(); i.hasNext();) {
			fileItem = (FileItem) i.next();
			if (!fileItem.isFormField()) {
				if (fileItem.getSize() > 0) {
					// code that handle uploaded fileItem
					// don't forget to delete uploaded files after you done
					// with them! Use fileItem.delete();
					String myFullFileName = fileItem.getName();
                    
					String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
					int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
                    int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
                    
                    // Ignore the path and get the filename
                	myFileName = myFullFileName.substring(lastIndexOfSlash+1);
                    
                    if (!FileUtil.isExcel(myFullFileName, lastIndexOfPeriod)) {
                    	fileItem.delete();
                    	throw new FileUploadException("The file you are trying to upload is not supported.");
                    } else if (listener.getBytesRead() > 1048576) {
                    	fileItem.delete();
                    	throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
                    } else {
	                    // Create new File object
	                    uploadedFile = new File(filePath, myFileName);

	                    // Write the uploaded file to the system
	                    fileItem.write(uploadedFile);
	                    
	                    // write media to drive c:
	                    if ("".equals(gipiCaUploadService.validateUploadPropertyFloater(myFileName))){
	                    	throw new MediaAlreadyExistingException("The property floater you are trying to upload is already existing!");
	                    }
	                   
	                   
	                    Map<String, Object> fileParams = new HashMap<String, Object>();
	                    fileParams.put("uploadedFile", uploadedFile);
	                    fileParams.put("userId", params.get("userId"));
	                    fileParams.put("myFileName", myFileName);
	                    fileParams.put("parId", parId);
	                    fileParams.put("lineCd", request.getParameter("lineCd"));
	                    fileParams.put("packPolFlag", request.getParameter("packPolFlag"));
	                   
	                    params1 = gipiCaUploadService.readAndPreparePropertyFloater(fileParams);
	                    
	                    if (params1.get("checkRequiredFields").equals(null) ? false : (Boolean) params1.get("checkRequiredFields")) {
	                    	log.info("Required fields must be complete.");	
						}	   
	                    params1.put("parId", parId);
	                    gipiCaUploadService.setUploadedPropertyFloater(params1);
	                    
	                    Integer totalErrors = params1.get("totalErrors") == null || params1.get("totalErrors") == "" ? 0 : Integer.parseInt(params1.get("totalErrors").toString());
	                    if(totalErrors > 0) {
	                    	sb.append(totalErrors.toString() + " records were not uploaded.");
	                    	sb.append("-" + params1.get("recordsUploaded"));
	                    	sb.append("-" + params1.get("totalRecords"));
	                    } else {
	                    	sb.append("SUCCESS");
	                    	sb.append("-" + params1.get("recordsUploaded"));
	                    	sb.append("-" + params1.get("totalRecords"));
	                    }
                    }
				}
			}
		}
		
		log.info("Reading and saving of property floater is successful!");
		
		System.gc();
		response.getWriter().write(sb.toString());
		} catch (InvalidUploadFeetDataException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - " +e.getMessage());
		} catch (MediaAlreadyExistingException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (FileUploadException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (UploadSizeLimitExceededException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		}
	}
	
}
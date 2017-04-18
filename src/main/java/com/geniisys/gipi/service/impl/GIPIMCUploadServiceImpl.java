/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.gipi.dao.GIPIMCUploadDAO;
import com.geniisys.gipi.entity.GIPIMCUpload;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWVehicle;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;
import com.geniisys.gipi.service.GIPIMCErrorLogService;
import com.geniisys.gipi.service.GIPIMCUploadService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWVehicleService;


/**
 * The Class GIPIMCUploadServiceImpl.
 */
public class GIPIMCUploadServiceImpl implements GIPIMCUploadService {

	/** The gipi mc upload dao. */
	private GIPIMCUploadDAO gipiMCUploadDAO;
	private GIPIWItemService gipiWItemService;
	private GIPIWVehicleService gipiWVehicleService;
	private GIPIMCErrorLogService gipiMCErrorLogService;
	private static Logger log = Logger.getLogger(GIPIMCUploadServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIMCUploadService#validateUploadFile(java.lang.String)
	 */
	@Override
	public String validateUploadFile(String fileName) throws SQLException {
		return this.getGipiMCUploadDAO().validateUploadFile(fileName);
	}

	/**
	 * Sets the gipi mc upload dao.
	 * 
	 * @param gipiMCUploadDAO the new gipi mc upload dao
	 */
	public void setGipiMCUploadDAO(GIPIMCUploadDAO gipiMCUploadDAO) {
		this.gipiMCUploadDAO = gipiMCUploadDAO;
	}

	/**
	 * Gets the gipi mc upload dao.
	 * 
	 * @return the gipi mc upload dao
	 */
	public GIPIMCUploadDAO getGipiMCUploadDAO() {
		return gipiMCUploadDAO;
	}
	
	public GIPIWItemService getGipiWItemService() {
		return gipiWItemService;
	}

	public void setGipiWItemService(GIPIWItemService gipiWItemService) {
		this.gipiWItemService = gipiWItemService;
	}

	public GIPIWVehicleService getGipiWVehicleService() {
		return gipiWVehicleService;
	}

	public void setGipiWVehicleService(GIPIWVehicleService gipiWVehicleService) {
		this.gipiWVehicleService = gipiWVehicleService;
	}


	public GIPIMCErrorLogService getGipiMCErrorLogService() {
		return gipiMCErrorLogService;
	}

	public void setGipiMCErrorLogService(GIPIMCErrorLogService gipiMCErrorLogService) {
		this.gipiMCErrorLogService = gipiMCErrorLogService;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIMCUploadService#readAndPrepareRecords(java.io.File, java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIPIMCUpload> readAndPrepareRecords(File fileName, String userId, String myFileName) throws InvalidUploadFeetDataException, FileNotFoundException, IOException {
		List<GIPIMCUpload> fleetUploads = null;
		try {
			HSSFWorkbook fleet = readFile(fileName);
			HSSFSheet sheet = fleet.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			System.out.println("Rows: " + rows);
			if (rows > 2) {
				 fleetUploads = new ArrayList<GIPIMCUpload>();
			}
			
			for (int r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				if (row == null) {
					continue;
				}
	
				int cells = row.getPhysicalNumberOfCells();
				System.out.println("Cells: " + cells);
				String value = null;
				GIPIMCUpload uFleet = new GIPIMCUpload();
				for (short c = 0; c < cells; c++) {
					HSSFCell cell = row.getCell(c);
					switch (cell.getCellType()) {
						case HSSFCell.CELL_TYPE_NUMERIC:
							value = String.valueOf((int) cell.getNumericCellValue());
							break;
						case HSSFCell.CELL_TYPE_STRING:
							value = cell.getStringCellValue();
							break;
						default:
					}
					
					switch (c) {
						case 0: uFleet.setItemNo(Integer.parseInt(value));
							break;
						case 1: uFleet.setItemTitle(value);
							break;
						case 27: uFleet.setMotorNo(value);
							break;
						case 33: uFleet.setSerialNo(value);
							break;
						case 31: uFleet.setPlateNo(value);
							break;
						case 35: uFleet.setSublineTypeCd(value);
							break;
						default:
					}
					uFleet.setUserId(userId);
					uFleet.setUploadDate(new Date());
					System.out.print(value+"\t\t\t");
				}
				uFleet.setFileName(myFileName);
				//uFleet.setUploadNo(r);
				fleetUploads.add(uFleet);
			}
			System.out.println("\n");
			System.out.println("Fleet Size: " + fleetUploads.size());
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
		return fleetUploads;
	}
	
	/**
	 * Read file.
	 * 
	 * @param file the file
	 * @return the hSSF workbook
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private HSSFWorkbook readFile(File file) throws IOException {
		return new HSSFWorkbook(new FileInputStream(file));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIMCUploadService#setGipiMCUpload(java.util.List)
	 */
	@Override
	public void setGipiMCUpload(List<GIPIMCUpload> mcUploads) throws SQLException {
		this.getGipiMCUploadDAO().setGipiMCUpload(mcUploads);
	}

	@Override
	public Map<String, Object> readAndPrepareFleetMC(Map<String, Object> fileParams)
			throws InvalidUploadFeetDataException, FileNotFoundException,
			IOException, ParseException, SQLException, IllegalAccessException, 
			InvocationTargetException, NoSuchMethodException {
		Map<String, Object> params = new HashMap<String, Object>();
		List<GIPIWItem> items = null;
		List<GIPIWVehicle> vehicles = null;
		List<GIPIMCUpload> fleetUploads = null;
		List<Map<String, Object>> errorLogs = null;
		
		//belle 11.20.2012
		File fileName  = (File) fileParams.get("uploadedFile");
		String userId  = (String) fileParams.get("userId");
		String myFileName = (String) fileParams.get("myFileName");
	    Integer parId  = (Integer)fileParams.get("parId");
	    String sublineCd  = (String) fileParams.get("sublineCd");
		String lineCd = (String) fileParams.get("lineCd");
		String packPolFlag = (String) fileParams.get("packPolFlag");
		
		
		List<GIPIWItem> currItems = this.getGipiWItemService().getGIPIWItem(parId);
		List<GIPIWVehicle> currVehicles = this.getGipiWVehicleService().getVehiclesForPAR(parId);
		List<GIPIMCUpload> currMCUploads = this.getGipiMCUploadDAO().getUploadedMC(null);
		int uploadCtr = 0;
		int errorCtr = 0;
		Integer uploadNo = null;
		
		Boolean chkItem = false;
		Boolean chkVehicle = false;
		Boolean chkUpload = false;
		Boolean checkRequiredFields = false;	//	added by Gzelle 09232014 - used for validation of required fields in uploaded file
		try {
			HSSFWorkbook fleet = readFile(fileName);
			HSSFSheet sheet = fleet.getSheetAt(0);
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
			int rows = sheet.getPhysicalNumberOfRows();		
			System.out.println("Rows: " + rows);
			if (rows >= 2) { // andrew - 07.23.2012 - changed operator from > to >= to handle single item row upload
				 items = new ArrayList<GIPIWItem>();
				 vehicles = new ArrayList<GIPIWVehicle>();
				 fleetUploads = new ArrayList<GIPIMCUpload>();
				 errorLogs = new ArrayList<Map<String,Object>>();
			}
			
			int cells = 0;
			HSSFRow columnRow = sheet.getRow(0);
			cells = columnRow.getPhysicalNumberOfCells();
			rowLoop: for (int r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				if (row == null) {
					continue;
				}
				//if(r==1) cells = row.getPhysicalNumberOfCells();  //temporarily added r==1 condition to get base no. of cells only on 1st row
				System.out.println("# of Cells: " + cells);
				String value = null;
				GIPIWItem uItem = new GIPIWItem();
				GIPIWVehicle uVehicle = new GIPIWVehicle();
				GIPIMCUpload uFleet = new GIPIMCUpload();
				Map<String, Object> errorLog = new HashMap<String, Object>();
				
				for (int c = 0; c < cells; c++) {
					HSSFCell cell = row.getCell(c);
					/*if(c == 35) {
						System.out.println("Subline Type CD::: "+cell.getStringCellValue());
					}*/
					//System.out.println("\nvalue "+c+": "+row.getCell(c));
					if(row.getCell(c) == null) {
						value = null;
					} else {
						switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_NUMERIC:
								value = String.valueOf((int) cell.getNumericCellValue()).trim();
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue().trim();
								break;
							default:
								//value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ?  String.valueOf((int) cell.getNumericCellValue()) :cell.getStringCellValue());
								value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ?  null :cell.getStringCellValue().trim());
						}
						//System.out.println("\nvalue2 "+c+": "+value);
						//value = value.trim();
						switch (c) {
							case 0:
								if(value == null){ // andrew - 07.23.2012 - to handle extra blank row read
									log.info("Item no is null.");	//	modified by Gzelle 09232014
									checkRequiredFields = true;
									continue rowLoop;
								} else {
									uItem.setItemNo(Integer.parseInt(value));
								}
								break;
							case 1: //uItem.setItemTitle(value);	modified by Gzelle 09232014
								if (value == null || value.equals("")) {
									log.info("Item Title is null.");
									checkRequiredFields = true;
								}else {
									uItem.setItemTitle(value);
								}
								break;
							case 2: //uItem.setCoverageCd(value == null || value.equals("") ? null : Integer.parseInt(value));
								if (value == null || value.equals("")) {	//	modified by Gzelle 09232014
									log.info("Coverage Cd is null.");
									checkRequiredFields = true;
								}else {
									uItem.setCoverageCd(Integer.parseInt(value));
								}
								break;
							case 3: //uItem.setCurrencyCd(value == null || value.equals("") ? null : Integer.parseInt(value));
								if (value == null || value.equals("")) {	//	modified by Gzelle 10082014
									log.info("Currency Cd is null.");
									checkRequiredFields = true;
								} else {
									uItem.setCurrencyCd(Integer.parseInt(value));
								}
								break;
							case 4: //uItem.setCurrencyRt(value == null || value.equals("") ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								if (value == null || value.equals("")) {	//	modified by Gzelle 09232014
									log.info("Currency Rate is null.");
									checkRequiredFields = true;
								} else {
									uItem.setCurrencyRt(new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								}
								break;
							case 5: uItem.setItemDesc(value);
								break;
							case 6: uItem.setItemDesc2(value);
								break;
							case 7: //uItem.setRegionCd(Integer.parseInt(value));
								if (value == null || value.equals("")) {	//	modified by Gzelle 10082014
									log.info("Region Cd is null.");
									checkRequiredFields = true;
								} else {
									uItem.setRegionCd(Integer.parseInt(value));
								}	
								break;
							default:
						}
						uItem.setParId(parId);
						uItem.setUserId(userId);
						uItem.setItemGrp(Integer.parseInt("1")); // added by: Nica to temporarily assign item_grp for fleet data
						
						//belle 11.20.2012
						if (packPolFlag.equals("Y")){
							uItem.setPackLineCd(lineCd);
							uItem.setPackSublineCd(sublineCd);
						}
						
						switch(c) {
							case 0: uVehicle.setItemNo(Integer.parseInt(value));
									break;
							case 8: uVehicle.setAcquiredFrom(value);
									break;
							case 9: uVehicle.setAssignee(value);
									break;
							case 10: uVehicle.setBasicColorCd(value);
									break;
							case 11: uVehicle.setCarCompanyCd(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 12: uVehicle.setCocAtcn(value);
									break;
							case 13: /*uVehicle.setCocIssueDate((row.getCell(c) == null ? null : sdf.parse(sdf.format(cell.getDateCellValue()))));*/
									uVehicle.setCocIssueDate((value == null || value.equals("") ? null : sdf.parse(sdf.format(cell.getDateCellValue()))));
									break;
							case 14: uVehicle.setCocSeqNo(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 15: uVehicle.setCocSerialNo(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 16: uVehicle.setCocType(value);
									break;
							case 17: uVehicle.setCocYy(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 18: uVehicle.setColor(value);
									break;
							case 19: uVehicle.setColorCd(value == null ||value.equals("") ? null : Integer.parseInt(value));
									break;
							case 20: uVehicle.setCtvTag(value);
									break;
							case 21: uVehicle.setDestination(value);
									break;
							case 22: uVehicle.setEstValue(value == null || value.equals("") ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
									break;		
							case 23: uVehicle.setModelYear(value);
									break;
							case 24: uVehicle.setMake(value);
									break;
							case 25: uVehicle.setMakeCd(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 26: //uVehicle.setMotType(value == null || value.equals("") ? null : Integer.parseInt(value));
									if (value == null || value.equals("")) {	//	modified by Gzelle 09232014
										log.info("Motor Type is null.");
										checkRequiredFields = true;
									} else {
										uVehicle.setMotType(Integer.parseInt(value));
									}
									break;
							case 27: //uVehicle.setMotorNo(value);
								if (value == null || value.equals("")) {	//	modified by Gzelle 10082014
									log.info("Motor Eng is null.");
									checkRequiredFields = true;
								} else {
									uVehicle.setMotorNo(value);
								}	
								break;
							case 28: uVehicle.setMvFileNo(value);
									break;
							case 29: uVehicle.setNoOfPass(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 30: uVehicle.setOrigin(value);
									break;
							case 31: uVehicle.setPlateNo(value);
									break;
							case 32: uVehicle.setRepairLim(value == null || value.equals("") ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
									break;
							case 33: //uVehicle.setSerialNo(value);	modified by Gzelle 10082014
								if (value == null || value.equals("")) {
									log.info("Serial No is null.");
									checkRequiredFields = true;
								} else {
									uVehicle.setSerialNo(value);
								}	
								break;
							case 34: uVehicle.setSeriesCd(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 35: //uVehicle.setSublineTypeCd(value);	modified by Gzelle 09232014
									if (value == null || value.equals("")) {
										log.info("Subline Type is null.");
										checkRequiredFields = true;
									} else {
										uVehicle.setSublineTypeCd(value);
									}
									break;
							case 36: uVehicle.setTariffZone(value);
									break;
							case 37: uVehicle.setTowing(value == null || value.equals("") ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
									break;
							case 38: 				
									//uVehicle.setTypeOfBodyCd(cell.getStringCellValue() == null || (cell.getStringCellValue()).equals("") ? null : Integer.parseInt(cell.getStringCellValue()));
									uVehicle.setTypeOfBodyCd(value == null || value.equals("") ? null : Integer.parseInt(value));
									break;
							case 39: uVehicle.setUnladenWt(value);
									break;
							default:
						}
						uVehicle.setSublineCd(sublineCd);
						uVehicle.setParId(parId);
						uVehicle.setAppUser(userId);
						
						switch (c) {
							case 0: uFleet.setItemNo(Integer.parseInt(value));
								break;
							case 1: uFleet.setItemTitle(value);
								break;
							case 27: uFleet.setMotorNo(value);
								break;
							case 33: //uFleet.setSerialNo(value); modified by Gzelle 10082014
								if (value == null || value.equals("")) {
									log.info("Serial No is null.");
									checkRequiredFields = true;
								} else {
									uFleet.setSerialNo(value);
								}
								break;
							case 31: uFleet.setPlateNo(value);
								break;
							case 35: //uFleet.setSublineTypeCd(value);	modified by Gzelle 09232014
								if (value == null || value.equals("")) {
									log.info("Subline Type is null.");
									checkRequiredFields = true;
								} else {
									uFleet.setSublineTypeCd(value);
								}
								break;
							default:
						}
						uFleet.setUserId(userId);
						uFleet.setUploadDate(new Date());
						//System.out.print(value+"\t\t\t");
					}
				}
				//uFleet.setFileName(myFileName.substring(0, myFileName.indexOf(".")));
				uFleet.setFileName(myFileName);
				if(uItem.getItemNo() != null) {
					
					for(GIPIWItem itm: currItems) {
						if(itm.getItemNo().equals(uItem.getItemNo())) {
							chkItem = true;
							break;
						}
						//System.out.println(itm.getItemNo()+" == "+uItem.getItemNo());
					}
					
					for(GIPIWVehicle cv: currVehicles) {
						if(cv.getItemNo().equals(uVehicle.getItemNo())) {
							chkVehicle = true;
							break;
						}
					}
					
					//marco - 04.22.2014 - to check newly uploaded items
					for(GIPIWItem itm : items){
						if(itm.getItemNo().equals(uItem.getItemNo())) {
							chkItem = true;
							break;
						}
					}
					
					//marco - 04.22.2014 - to check newly uploaded vehicles
					for(GIPIWVehicle cv: vehicles) {
						if(cv.getItemNo().equals(uVehicle.getItemNo())) {
							chkVehicle = true;
							break;
						}
					}
					
					/*for(GIPIMCUpload mc: currMCUploads) {
						if( mc.getFileName().equals(uFleet.getFileName()) && 
						   (mc.getMotorNo().equals(uFleet.getMotorNo()) ||
							mc.getPlateNo().equals(uFleet.getPlateNo()) ||
							mc.getSerialNo().equals(uFleet.getSerialNo()) ||
							mc.getItemNo().equals(uFleet.getItemNo()))
							) {
								chkUpload = true;
								break;
						}
					}*/
					
					System.out.println("row" + r + ": check if add: "+chkItem+" - "+chkVehicle+" - "+chkUpload);
					if(!chkItem && !chkVehicle && !chkUpload) {
						if(uploadCtr == 0) {
							//uploadNo = 57;
							if(uploadNo == null || uploadNo < 1) uploadNo = this.getGipiMCUploadDAO().getNextUploadNo();
							uFleet.setUploadNo(uploadNo);
							fleetUploads.add(uFleet);
						}
						items.add(uItem);
						vehicles.add(uVehicle);
						//System.out.println("test motor no: "+uVehicle.getMotorNo());
						uploadCtr++;
					} else if (chkItem || chkVehicle || chkUpload) {
						//uploadNo = 57;
						if(uploadNo == null || uploadNo < 1) uploadNo = this.getGipiMCUploadDAO().getNextUploadNo();
						errorLog = this.prepareMCErrorLog(uItem, uVehicle, uFleet);
						errorLog.put("uploadNo", uploadNo);
						errorLog.put("fileName", myFileName.substring(0, myFileName.indexOf(".")));
						errorLog.put("remarks", "DUPLICATE RECORD EXISTS.");
						errorLogs.add(errorLog);
						errorCtr++;
					}
					
					chkItem = false;
					chkVehicle = false;
					chkUpload = false;
				}
			}
			System.out.println("\nFleet Size: " + fleetUploads.size());
			System.out.println("Item Size: " + items.size());
			System.out.println("Error Logs: " + errorLogs.size());
			//System.out.println("Fleet Filename: "+myFileName.substring(0, myFileName.indexOf(".")));
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
		params.put("gipiWVehicle", vehicles);
		params.put("fleetUploads", fleetUploads);
		params.put("errorLogs", errorLogs);
		params.put("appUser", userId);
		params.put("recordsUploaded", uploadCtr);
		params.put("totalErrors", errorCtr);
		params.put("totalRecords", uploadCtr+errorCtr);
		params.put("checkRequiredFields", checkRequiredFields);	//	added by Gzelle 09232014
		return params;
	}


	@Override
	public void setUploadedFleet(Map<String, Object> params)
			throws SQLException {
		this.getGipiMCUploadDAO().setRecordsOnUpload(params);
	}
	
	private Map<String, Object> prepareMCErrorLog(GIPIWItem item, GIPIWVehicle vehicle, GIPIMCUpload upload) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.putAll(FormInputUtil.formMapFromEntity(item));
		params.putAll(FormInputUtil.formMapFromEntity(vehicle));
		//params.putAll(FormInputUtil.formMapFromEntity(upload));
		//System.out.println("prepareMCErrorLog - "+params);
		return params;
	}

}

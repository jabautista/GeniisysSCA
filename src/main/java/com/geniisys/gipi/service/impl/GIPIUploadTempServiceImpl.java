package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
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

import com.geniisys.gipi.dao.GIPIUploadTempDAO;
import com.geniisys.gipi.entity.GIPIUploadItmperil;
import com.geniisys.gipi.entity.GIPIUploadTemp;
import com.geniisys.gipi.exceptions.InvalidUploadEnrolleesDataException;
import com.geniisys.gipi.service.GIPIUploadTempService;
import com.seer.framework.util.StringFormatter;

public class GIPIUploadTempServiceImpl implements GIPIUploadTempService{

	private GIPIUploadTempDAO gipiUploadTempDAO;
	private static Logger log = Logger.getLogger(GIPIUploadTempServiceImpl.class);
	
	public GIPIUploadTempDAO getGipiUploadTempDAO() {
		return gipiUploadTempDAO;
	}

	public void setGipiUploadTempDAO(GIPIUploadTempDAO gipiUploadTempDAO) {
		this.gipiUploadTempDAO = gipiUploadTempDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIUploadTempService#getGipiUploadTemp()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIUploadTemp> getGipiUploadTemp() throws SQLException {
		return (List<GIPIUploadTemp>) StringFormatter.replaceQuotesInList(this.gipiUploadTempDAO.getGipiUploadTemp());
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIUploadTempService#readAndPrepareRecords(java.io.File, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> readAndPrepareRecords(File fileName,
			String userId, String myFileName)
			throws InvalidUploadEnrolleesDataException, FileNotFoundException,
			IOException {
		List<GIPIUploadTemp> enrolleeUploads = null;
		List<GIPIUploadItmperil> enrolleeUploadsPerils = null;
		String doUpload = "";
		try {
			HSSFWorkbook fleet = readFile(fileName);
			HSSFSheet sheet = fleet.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			System.out.println("Total Rows: " + rows);
			String uploadNo = getUploadNo(myFileName.substring(0, myFileName.indexOf(".")));
			if (rows > 2) {
				enrolleeUploads = new ArrayList<GIPIUploadTemp>();
				if (myFileName.contains("PERILS")){
					enrolleeUploadsPerils = new ArrayList<GIPIUploadItmperil>();
				}
			}
			String lastRow = "0";
			
			for (int r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				if (row == null) {
					continue;
				}
	
				int cells = row.getPhysicalNumberOfCells();
				System.out.print("Row"+r+": ");
				String value = null;
				GIPIUploadTemp uEnrollee = new GIPIUploadTemp();
				GIPIUploadItmperil uEnrolleePerils = new GIPIUploadItmperil();
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");

				if (myFileName.contains("PERILS")){
					cells = 22;
				}else{
					cells = 11;
				}
				
				for (int c = 0; c < cells; c++) {
					HSSFCell cell = row.getCell(c);
					if (row.getCell(c) == null){
						value = null;
					}else{
						switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_NUMERIC:
								value = String.valueOf((int) cell.getNumericCellValue());
								break;
							case HSSFCell.CELL_TYPE_FORMULA:
								value = String.valueOf((int) cell.getNumericCellValue());
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue();
								break;
							default:
								value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ? String.valueOf((int) cell.getNumericCellValue()) :cell.getStringCellValue());
						}
					}
			
					switch (c) {
						case 0: uEnrollee.setControlCd(value);
							break;
						case 1: uEnrollee.setControlTypeCd(value);
							break;
						case 2: uEnrollee.setGroupedItemTitle(value);
							break;
						case 3: uEnrollee.setSex(value);
							break;	
						case 4: uEnrollee.setCivilStatus(value);
							break;
						case 5: uEnrollee.setDateOfBirth((row.getCell(c) == null ? null : sdf.parse(sdf.format(cell.getDateCellValue()))));
							break;
						case 6: uEnrollee.setFromDate((row.getCell(c) == null ? null : sdf.parse(sdf.format(cell.getDateCellValue()))));
							break;
						case 7: uEnrollee.setToDate((row.getCell(c) == null ? null : sdf.parse(sdf.format(cell.getDateCellValue()))));
							break;
						case 8: uEnrollee.setAge(value);
							break;
						case 9: uEnrollee.setSalary(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
							break;
						case 10: uEnrollee.setSalaryGrade(value);
							break;	
						case 11: uEnrollee.setAmountCoverage(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
							break;
						case 12: uEnrollee.setRemarks(value);
							break;
						
						default:
					}
					
					if (myFileName.contains("PERILS")){
						switch (c) {
							case 0: uEnrolleePerils.setControlCd(value);
								break;
							case 1: uEnrolleePerils.setControlTypeCd(value);
								break;
							case 13: uEnrolleePerils.setPerilCd(value);
								break;		
							case 14: uEnrolleePerils.setNoOfDays(value);
								break;
							case 15: uEnrolleePerils.setPremRt(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;
							case 16: uEnrolleePerils.setTsiAmt(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;
							case 17: uEnrolleePerils.setPremAmt(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;
							case 18: uEnrolleePerils.setAggregateSw(value);
								break;
							case 19: uEnrolleePerils.setBaseAmount(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;	
							case 20: uEnrolleePerils.setRiCommRate(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;	
							case 21: uEnrolleePerils.setRiCommAmt(value == null || value == "" ? null : new BigDecimal(String.valueOf(cell.getNumericCellValue()).replaceAll(",", "")));
								break;	
							default:
						}
						uEnrolleePerils.setUserId(userId);
						uEnrolleePerils.setUploadNo(uploadNo);
						uEnrolleePerils.setFilename(myFileName.substring(0, myFileName.indexOf(".")));
						if (uEnrollee.getControlCd() == null){
							lastRow = String.valueOf(enrolleeUploads.size()-1);
							uEnrolleePerils.setControlCd(enrolleeUploads.get(Integer.parseInt(lastRow)).getControlCd());
							uEnrolleePerils.setControlTypeCd(enrolleeUploads.get(Integer.parseInt(lastRow)).getControlTypeCd());
						}
					}
					
					uEnrollee.setUserId(userId);
					uEnrollee.setUploadDate(new Date());
					System.out.print(value+"\t");
				}
				System.out.println("\n");
				uEnrollee.setUploadNo(uploadNo);
				uEnrollee.setFilename(myFileName.substring(0, myFileName.indexOf(".")));
				
				if ((uEnrollee.getControlTypeCd() != null) && (uEnrollee.getControlCd() != null)){
					enrolleeUploads.add(uEnrollee);
				}
				
				//for perils
				if (myFileName.contains("PERILS")){
					if ((uEnrolleePerils.getPerilCd() != null)){
						doUpload = "PERILS";
						enrolleeUploadsPerils.add(uEnrolleePerils);
					}
				}
			}
			System.out.println("\n");
			System.out.println("Enrollee Size: " + enrolleeUploads.size());
			System.out.println("Upload No: "+uploadNo);
			System.out.println("Filename: "+myFileName.substring(0, myFileName.indexOf(".")));
			
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new InvalidUploadEnrolleesDataException("The file has invalid data formatting.");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new InvalidUploadEnrolleesDataException("The file has invalid data formatting.");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("enrolleeUploads", enrolleeUploads);
		params.put("enrolleeUploadsPerils", enrolleeUploadsPerils);
		params.put("doUpload", doUpload);
		return params;
	}

	private HSSFWorkbook readFile(File file) throws IOException {
		return new HSSFWorkbook(new FileInputStream(file));
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIUploadTempService#setGipiEnrolleeUpload(java.util.Map)
	 */
	@Override
	public void setGipiEnrolleeUpload(Map<String,Object> enrolleeUploads)
			throws SQLException {
		this.gipiUploadTempDAO.setGipiEnrolleeUpload(enrolleeUploads);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIUploadTempService#validateUploadFile(java.lang.String)
	 */
	@Override
	public String validateUploadFile(String fileName) throws SQLException {
		return this.gipiUploadTempDAO.validateUploadFile(fileName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIUploadTempService#getUploadNo(java.lang.String)
	 */
	@Override
	public String getUploadNo(String fileName) throws SQLException {
		return this.gipiUploadTempDAO.getUploadNo(fileName);
	}

	@Override
	public Map<String, Object> readAndPrepareRecords2(File fileName,
			String userId, String myFileName)
			throws InvalidUploadEnrolleesDataException, FileNotFoundException,
			IOException {
		List<GIPIUploadTemp> enrolleeUploads = null;
		List<GIPIUploadItmperil> enrolleeUploadsPerils = null;
		String doUpload = "";
		String uploadNo = "";
		
		try {
			HSSFWorkbook fleet = readFile(fileName);
			HSSFSheet sheet = fleet.getSheetAt(0);
			Integer rows = sheet.getPhysicalNumberOfRows();
			
			uploadNo = getUploadNo(myFileName.substring(0, myFileName.indexOf(".")));
			if (rows > 1) {
				enrolleeUploads = new ArrayList<GIPIUploadTemp>();
				if (myFileName.toUpperCase().contains("PERILS")){
					enrolleeUploadsPerils = new ArrayList<GIPIUploadItmperil>();
				}
			}
			String controlTypeCd = null;
			String controlCd = null;
			
			HSSFRow header = sheet.getRow(0);
			for (Integer r = 1; r < rows; r++) {
				HSSFRow row = sheet.getRow(r);
				Integer cells = header.getPhysicalNumberOfCells();
				boolean isRowEmpty = true;
				
				for(int c = 0; c < cells; c++){
					if (!(row.getCell(c) == null || row.getCell(c).getCellType() == HSSFCell.CELL_TYPE_BLANK)){
						isRowEmpty = false;
						break;
					}
				}
				
				if(isRowEmpty){
					continue;
				}
				
				String value = null;
				GIPIUploadTemp uEnrollee = new GIPIUploadTemp();
				GIPIUploadItmperil uEnrolleePerils = new GIPIUploadItmperil();
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
				
				for (Integer c = 0; c < cells; c++) {
					HSSFCell cell = row.getCell(c);
					HSSFCell title = header.getCell(c);
					String column = title.getStringCellValue().toUpperCase();
					if (row.getCell(c) == null || row.getCell(c).getCellType() == HSSFCell.CELL_TYPE_BLANK){
						value = null;
					}else{
						switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_NUMERIC:
								if(column.contains("DATE")){
									value = String.valueOf((int) cell.getNumericCellValue());
								}else{
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
									value = cell.getStringCellValue();
								}
								break;
							case HSSFCell.CELL_TYPE_FORMULA:
								if(column.contains("DATE")){
									value = String.valueOf((int) cell.getNumericCellValue());
								}else{
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
									value = cell.getStringCellValue();
								}
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue();
								break;
							default:
								value = (cell.getStringCellValue().equals("") || cell.getStringCellValue().equals(null) ? String.valueOf((int) cell.getNumericCellValue()) :cell.getStringCellValue());
						}
					}
					
					if(column.equals("CONTROL_CD")){
						uEnrollee.setControlCd(value);
						controlCd = (value == null || value == "" ? controlCd : value);
					}else if(column.equals("CONTROL_TYPE_CD")){
						uEnrollee.setControlTypeCd(value);
						controlTypeCd = (value == null || value == "" ? controlTypeCd : value);
					}else if(column.equals("GROUPED_ITEM_TITLE")){
						uEnrollee.setGroupedItemTitle(value == null || value == "" ? null : value);
					}else if(column.equals("SEX")){
						uEnrollee.setSex(value);
					}else if(column.equals("CIVIL_STATUS")){
						uEnrollee.setCivilStatus(value);
					}else if(column.equals("DATE_OF_BIRTH")){
						uEnrollee.setDateOfBirth(value == null || value == "" ? null : sdf.parse(sdf.format(cell.getDateCellValue())));
					}else if(column.equals("FROM_DATE")){
						uEnrollee.setFromDate(value == null || value == "" ? null : sdf.parse(sdf.format(cell.getDateCellValue())));
					}else if(column.equals("TO_DATE")){
						uEnrollee.setToDate(value == null || value == "" ? null : sdf.parse(sdf.format(cell.getDateCellValue())));
					}else if(column.equals("AGE")){
						uEnrollee.setAge(value);
					}else if(column.equals("SALARY")){
						uEnrollee.setSalary(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
					}else if(column.equals("SALARY_GRADE")){
						uEnrollee.setSalaryGrade(value);
					}else if(column.equals("AMOUNT_COVERAGE")){
						uEnrollee.setAmountCoverage(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
					}else if(column.equals("REMARKS")){
						uEnrollee.setRemarks(value);
					}
					uEnrollee.setUserId(userId);
					uEnrollee.setUploadDate(new Date());
					
					if (myFileName.toUpperCase().contains("PERILS")){
						if(column.equals("CONTROL_CD")){
							uEnrolleePerils.setControlCd(controlCd);
						}else if(column.equals("CONTROL_TYPE_CD")){
							uEnrolleePerils.setControlTypeCd(controlTypeCd);
						}else if(column.equals("PERIL_CD")){
							uEnrolleePerils.setPerilCd(value);
						}else if(column.equals("NO_OF_DAYS")){
							uEnrolleePerils.setNoOfDays(value);
						}else if(column.equals("PREM_RT")){
							uEnrolleePerils.setPremRt(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}else if(column.equals("TSI_AMT")){
							uEnrolleePerils.setTsiAmt(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}else if(column.equals("PREM_AMT")){
							uEnrolleePerils.setPremAmt(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}else if(column.equals("AGGREGATE_SW")){
							uEnrolleePerils.setAggregateSw(value);
						}else if(column.equals("BASE_AMT")){
							uEnrolleePerils.setBaseAmount(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}else if(column.equals("RI_COMM_RATE")){
							uEnrolleePerils.setRiCommRate(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}else if(column.equals("RI_COMM_AMT")){
							uEnrolleePerils.setRiCommAmt(value == null || value == "" ? null : new BigDecimal(value.replaceAll(",", "")));
						}
						
						uEnrolleePerils.setUserId(userId);
						uEnrolleePerils.setUploadNo(uploadNo);
						uEnrolleePerils.setFilename(myFileName.substring(0, myFileName.indexOf(".")));
					}
				}
				uEnrollee.setUploadNo(uploadNo);
				uEnrollee.setFilename(myFileName.substring(0, myFileName.indexOf(".")));
				uEnrollee.setUploadSeqNo(Integer.toString(enrolleeUploads.size() + 1));
				
				for(GIPIUploadTemp temp : enrolleeUploads){
					if(uEnrollee.getControlCd() != null && uEnrollee.getControlTypeCd() != null &&
						temp.getControlCd() != null && temp.getControlTypeCd() != null &&
						temp.getControlCd().equals(uEnrollee.getControlCd()) && temp.getControlTypeCd().equals(uEnrollee.getControlTypeCd())){
						throw new InvalidUploadEnrolleesDataException("Duplicate record exists.");
					}
				}
				
				if(!(myFileName.toUpperCase().contains("PERILS"))){
					enrolleeUploads.add(uEnrollee);
				}else{
					for(GIPIUploadItmperil temp : enrolleeUploadsPerils){
						if(uEnrolleePerils.getControlCd() != null && uEnrolleePerils.getControlTypeCd() != null && uEnrolleePerils.getPerilCd() != null &&
							temp.getControlCd() != null && temp.getControlTypeCd() != null && temp.getPerilCd() != null && 
							temp.getControlCd().equals(uEnrolleePerils.getControlCd()) && temp.getControlTypeCd().equals(uEnrolleePerils.getControlTypeCd()) &&
							temp.getPerilCd().equals(uEnrolleePerils.getPerilCd())){
							throw new InvalidUploadEnrolleesDataException("Duplicate record exists.");
						}
					}
					
					if(uEnrollee.getControlCd() != null || uEnrollee.getControlTypeCd() != null){
						enrolleeUploads.add(uEnrollee);
					}
					
					if ((uEnrolleePerils.getPerilCd() != null)){
						doUpload = "PERILS";
						enrolleeUploadsPerils.add(uEnrolleePerils);
					}
				}
			}
			
			System.out.println("Enrollee Size: " + enrolleeUploads.size());
			System.out.println("Upload No: "+uploadNo);
			System.out.println("Filename: "+myFileName.substring(0, myFileName.indexOf("."))+"\n");
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new InvalidUploadEnrolleesDataException("The file has invalid data formatting.");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new InvalidUploadEnrolleesDataException("The file has invalid data formatting.");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("enrolleeUploads", enrolleeUploads);
		params.put("enrolleeUploadsPerils", enrolleeUploadsPerils);
		params.put("doUpload", doUpload);
		params.put("enrolleeUploadsCount", enrolleeUploads.size());
		params.put("uploadNo", uploadNo);
		return params;
	}

	@Override
	public Integer getUploadCount(String uploadNo) throws SQLException {
		return this.getGipiUploadTempDAO().getUploadCount(Integer.parseInt(uploadNo));
	}
	
}

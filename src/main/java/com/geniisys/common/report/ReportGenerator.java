package com.geniisys.common.report;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRCsvExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRTextExporter;
import net.sf.jasperreports.engine.export.JRTextExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.export.oasis.JROdtExporter;
import net.sf.jasperreports.engine.export.ooxml.JRDocxExporterParameter;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.exceptions.ReportNotFoundException;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.util.FileUtil;

public class ReportGenerator {
	
	private static Logger log = Logger.getLogger(ReportGenerator.class);
	
	public boolean generateReport(Map<String, Object> parameters) throws SQLException, JRException, IOException {
		log.info("Generating report...");
		boolean result = false;
		try {
			JasperGenerator generator = new JasperGenerator();
			log.info("SUBREPORT_DIR: "+parameters.get("SUBREPORT_DIR").toString());
			log.info("MAIN_REPORT: "+parameters.get("MAIN_REPORT").toString());
			JasperReport report = generator.getReport(parameters.get("P_SUBREPORT_DIR").toString(), parameters.get("MAIN_REPORT").toString());
			log.info("REPORT QUERY TEXT: " + report.getQuery().getText());
			parameters.put("pageHeight", report.getPageHeight());
			parameters.put("pageWidth", report.getPageWidth());
			parameters.put("rightMargin", report.getRightMargin());
			parameters.put("leftMargin", report.getLeftMargin());
			parameters.put("topMargin", report.getTopMargin());
			parameters.put("bottomMargin", report.getBottomMargin());
			parameters.put("orientation", report.getOrientationValue());
			
			JasperPrint print = generator.generateJasper(report, parameters);

			if("XLS".equals(parameters.get("fileType"))){ //Dren Niebres SR-5374 04.26.2016 - End
			generateXLSFormatFromJasper(parameters, print); 
			}else if("CSV2".equals(parameters.get("fileType"))){
			generateCSV2FormatFromJasper(parameters, print); //Dren Niebres SR-5374 04.26.2016
			}else{
				generator.saveFile(parameters.get("GENERATED_REPORT_DIR").toString(), parameters.get("OUTPUT_REPORT_FILENAME").toString(), generator.exportReportToBytes(print, new JRPdfExporter()));
			}
			//generateODTFormatFromJasper(parameters, print);
			//generateTXTFormatFromJasper(parameters, print);
			//generateCSVFormatFromJasper(parameters, print);	        
			
			result = true;			
		} catch (JRException e) {
			if(e.getMessage().contains("java.io.FileNotFoundException")){
				StringBuilder message = new StringBuilder();
				String report = parameters.get("reportName").toString();
				message.append("The report");
				if(!report.isEmpty()){
					message.append(" (");
					message.append(report);
					message.append(")");
				}
				message.append(" you are trying to generate does not exist.");
				
				throw new ReportNotFoundException(message.toString());
			} else {
				throw e;
			}
		} catch (SQLException e) {
			throw e;
		} catch (IOException e) {
			throw e;
		}
		return result;
	}
	
	/**
	 * 
	 * @param parameters
	 * @param print
	 * @throws JRException
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	private void generateODTFormatFromJasper(Map<String, Object> parameters, JasperPrint print) throws JRException, IOException{					
		String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".odt";				
		FileOutputStream outputFile = new FileOutputStream(new File(outputFileName));
		ByteArrayOutputStream baos = new ByteArrayOutputStream();		
		
		JROdtExporter exporter = new JROdtExporter();
		exporter.setParameter(JRDocxExporterParameter.JASPER_PRINT, print);
		exporter.setParameter(JRDocxExporterParameter.CHARACTER_ENCODING, "UTF-8");
		exporter.setParameter(JRDocxExporterParameter.OUTPUT_STREAM, baos);		
		//exporter.setParameter(JRDocxExporterParameter.FLEXIBLE_ROW_HEIGHT, Boolean.TRUE);
		//exporter.setParameter(JRDocxExporterParameter.FRAMES_AS_NESTED_TABLES, Boolean.TRUE);
        
		exporter.exportReport();        
		
		outputFile.write(baos.toByteArray());	        
		outputFile.flush();             	        
		outputFile.close();
	}
	
	/**
	 * 
	 * @param parameters
	 * @param print
	 * @throws JRException
	 * @throws IOException
	 */
	private void generateXLSFormatFromJasper(Map<String, Object> parameters, JasperPrint print) throws JRException, IOException {
		File file = null;
		FileOutputStream outputFile = null;
		try {			
			if(!new File(parameters.get("GENERATED_REPORT_DIR").toString()).isDirectory()){
				System.out.println("GENERATE DIR: "+ parameters.get("GENERATED_REPORT_DIR").toString());
				new File(parameters.get("GENERATED_REPORT_DIR").toString()).mkdirs();
			}
			
			String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".xls";
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			outputFile = new FileOutputStream(new File(outputFileName));
			
	        JRXlsExporter xls = new JRXlsExporter();
	        xls.setParameter(JRXlsExporterParameter.JASPER_PRINT, print);
	        xls.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, baos);
	        xls.setParameter(JRXlsExporterParameter.CHARACTER_ENCODING, "UTF-8");
	        xls.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_COLUMNS, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_COLLAPSE_ROW_SPAN, Boolean.FALSE);
	        //xls.setParameter(JRXlsExporterParameter.IS_IGNORE_GRAPHICS, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_IGNORE_GRAPHICS, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_IGNORE_CELL_BORDER, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_FONT_SIZE_FIX_ENABLED, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.MAXIMUM_ROWS_PER_SHEET, Integer.decode("65535")); //to print records in another sheet when maximum row for XLS is exceeded : shan 09.03.2014  
	        xls.exportReport();
	        
	        outputFile.write(baos.toByteArray());
	        outputFile.flush();
	        
	        file = new File(parameters.get("GENERATED_REPORT_DIR").toString() + "/" + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".xls");
	        FileUtil.writeFile(parameters.get("realPath").toString(), file.getPath().toString(), "reports");
		} finally {
			if(outputFile != null) {
				outputFile.close();
			}
			if (file != null && file.isFile()) {
				file.delete();
			}
		}
	}
	
	private void generateCSV2FormatFromJasper(Map<String, Object> parameters, JasperPrint print) throws JRException, IOException {
		File file = null;
		FileOutputStream outputFile = null;
		try {			
			if(!new File(parameters.get("GENERATED_REPORT_DIR").toString()).isDirectory()){
				System.out.println("GENERATE DIR: "+ parameters.get("GENERATED_REPORT_DIR").toString());
				new File(parameters.get("GENERATED_REPORT_DIR").toString()).mkdirs();
			}
			
			String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".csv";
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			outputFile = new FileOutputStream(new File(outputFileName));
			
	        JRCsvExporter csv = new JRCsvExporter();
	        
			csv.setParameter(JRCsvExporterParameter.JASPER_PRINT, print);
			csv.setParameter(JRCsvExporterParameter.FIELD_DELIMITER, ",");
			csv.setParameter(JRCsvExporterParameter.RECORD_DELIMITER,System.getProperty("line.separator"));			
			csv.setParameter(JRCsvExporterParameter.OUTPUT_STREAM, baos);				
	        csv.setParameter(JRCsvExporterParameter.CHARACTER_ENCODING, "UTF-8");
	        csv.exportReport();   
	        
	        outputFile.write(baos.toByteArray());
	        outputFile.flush();
	        
	        file = new File(parameters.get("GENERATED_REPORT_DIR").toString() + "/" + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".csv");
	        FileUtil.writeFile(parameters.get("realPath").toString(), file.getPath().toString(), "reports");
		} finally {
			if(outputFile != null) {
				outputFile.close();
			}
			if (file != null && file.isFile()) {
				file.delete();
			}
		}
	} //Dren Niebres SR-5374 04.26.2016		
	
	/**
	 * 
	 * @param parameters
	 * @param print
	 * @throws JRException
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	private void generateCSVFormatFromJasper(Map<String, Object> parameters, JasperPrint print) throws JRException, IOException {
		String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".csv";
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		FileOutputStream outputFile = new FileOutputStream(new File(outputFileName));
		
		JRCsvExporter csv = new JRCsvExporter();		
		csv.setParameter(JRCsvExporterParameter.JASPER_PRINT, print);
		csv.setParameter(JRCsvExporterParameter.FIELD_DELIMITER, ",");
		csv.setParameter(JRCsvExporterParameter.RECORD_DELIMITER,System.getProperty("line.separator"));			
		csv.setParameter(JRCsvExporterParameter.OUTPUT_STREAM, baos);
		
		csv.exportReport();
		
		outputFile.write(baos.toByteArray());
		outputFile.flush();
		outputFile.close();
	}
	
	/**
	 * 
	 * @param parameters
	 * @param print
	 * @throws JRException
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	private void generateTXTFormatFromJasper(Map<String, Object> parameters, JasperPrint print) throws JRException, IOException {
		String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".txt";
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		FileOutputStream outputFile = new FileOutputStream(new File(outputFileName));
		
		JRTextExporter txt = new JRTextExporter();		
		txt.setParameter(JRExporterParameter.JASPER_PRINT, print);
		txt.setParameter(JRTextExporterParameter.CHARACTER_HEIGHT, new Integer(11));
		txt.setParameter(JRTextExporterParameter.CHARACTER_WIDTH, new Integer(7));
		//txt.setParameter(JRTextExporterParameter.PAGE_WIDTH, new Integer(800));
		//txt.setParameter(JRTextExporterParameter.PAGE_HEIGHT, new Integer(600));
		txt.setParameter(JRTextExporterParameter.OUTPUT_STREAM, baos);
		
		txt.exportReport();
		
		outputFile.write(baos.toByteArray());
		outputFile.flush();
		outputFile.close();
	}
	
	public static String generateJRPrintFileToServer(String realPath, Map<String, Object> params) throws JRException, SQLException, IOException{
		String url = realPath;
		File file = null;
		try {
			JasperGenerator generator = new JasperGenerator();
			file = generator.generateJRPrintFile(params);			
			FileUtil.writeFile(realPath, file.getPath().toString(), "reports");
			url = url + "\\reports\\" + file.getName();
			System.out.println("URL : " + url);
		} finally {			
			if (file != null && file.isFile()) {
				file.delete();
			}
		}	
		return url;
	}
	
	public static String generatePdfFileToServer(String realPath, Map<String, Object> params) throws JRException, SQLException, IOException{
		String url = realPath;
		File file = null;
		try {
			JasperGenerator generator = new JasperGenerator();
			file = generator.generatePdfFile(params);			
			FileUtil.writeFile(realPath, file.getPath().toString(), "reports");
			url = realPath + "\\reports\\" + file.getName();
			System.out.println("URL : " + url);	
		} catch (JRException e) {
			if(e.getMessage().contains("java.io.FileNotFoundException")){
				StringBuilder message = new StringBuilder();
				String report = params.get("reportName").toString();
				message.append("The report");
				if(!report.isEmpty()){
					message.append(" (");
					message.append(report);
					message.append(")");
				}
				message.append(" you are trying to generate does not exist.");
				
				throw new ReportNotFoundException(message.toString());
			} else {
				throw e;
			}
		}finally {			
			if (file != null && file.isFile()) {
				file.delete();
			}
		}	
		return url;
	}
	
	private void generateXLSMultiSheetFromJasper(Map<String, Object> parameters, List<JasperPrint> printList, String[] sheetNameList) throws JRException, IOException {
		File file = null;
		FileOutputStream outputFile = null;
		try {			
			if(!new File(parameters.get("GENERATED_REPORT_DIR").toString()).isDirectory()){
				System.out.println("GENERATE DIR: "+ parameters.get("GENERATED_REPORT_DIR").toString());
				new File(parameters.get("GENERATED_REPORT_DIR").toString()).mkdirs();
			}
			
			String outputFileName = parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".xls";
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			outputFile = new FileOutputStream(new File(outputFileName));
			
	        JRXlsExporter xls = new JRXlsExporter();
	        xls.setParameter(JRXlsExporterParameter.JASPER_PRINT_LIST, printList);
	        xls.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, baos);
	        xls.setParameter(JRXlsExporterParameter.CHARACTER_ENCODING, "UTF-8");
	        xls.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_COLUMNS, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.IS_COLLAPSE_ROW_SPAN, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_IGNORE_GRAPHICS, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_IGNORE_CELL_BORDER, Boolean.FALSE);
	        xls.setParameter(JRXlsExporterParameter.IS_FONT_SIZE_FIX_ENABLED, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.MAXIMUM_ROWS_PER_SHEET, Integer.decode("65535"));
	        xls.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);
	        xls.setParameter(JRXlsExporterParameter.SHEET_NAMES, sheetNameList);
	        xls.exportReport();
	        
	        outputFile.write(baos.toByteArray());
	        outputFile.flush();
	        
	        file = new File(parameters.get("GENERATED_REPORT_DIR").toString() + "/" + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".xls");
	        FileUtil.writeFile(parameters.get("realPath").toString(), file.getPath().toString(), "reports");
		} finally {
			if(outputFile != null) {
				outputFile.close();
			}
			if (file != null && file.isFile()) {
				file.delete();
			}
		}
	}
	
	public boolean generateMultiSheetReport(Map<String, Object> parameters) throws SQLException, JRException, IOException, JSONException {
		log.info("Generating report...");
		boolean result = false;
		Connection conn = (Connection) parameters.get("CONNECTION");
		
		try {
			List<Map<String, Object>> reportList = new ArrayList<Map<String, Object>>();
			JasperGenerator generator = new JasperGenerator();
			reportList = JSONUtil.prepareMapListFromJSON(new JSONArray(parameters.get("reportList").toString()));
			JasperReport report;
			List<JasperPrint> printList = new ArrayList<JasperPrint>();
			String[] sheetNameList = new String[reportList.size()];
			int sheetIndex = 0;
			
			for(Map<String, Object> rep : reportList){
				parameters.put("MAIN_REPORT", rep.get("reportId")+".jasper");
				report = generator.getReport(parameters.get("P_SUBREPORT_DIR").toString(), parameters.get("MAIN_REPORT").toString());
				log.info("REPORT QUERY TEXT: " + report.getQuery().getText());
				parameters.put("pageHeight", report.getPageHeight());
				parameters.put("pageWidth", report.getPageWidth());
				parameters.put("rightMargin", report.getRightMargin());
				parameters.put("leftMargin", report.getLeftMargin());
				parameters.put("topMargin", report.getTopMargin());
				parameters.put("bottomMargin", report.getBottomMargin());
				parameters.put("orientation", report.getOrientationValue());
				sheetNameList[sheetIndex] = rep.get("sheetName").toString();
				log.info("parameters: " + parameters);
				generator = new JasperGenerator();
				
				JasperPrint print = JasperFillManager.fillReport(report, parameters, conn);
				printList.add(print);
				sheetIndex += 1;
			}
			generateXLSMultiSheetFromJasper(parameters, printList, sheetNameList);
			
			result = true;			
		} catch (JRException e) {
			if(e.getMessage().contains("java.io.FileNotFoundException")){
				StringBuilder message = new StringBuilder();
				String report = parameters.get("reportName").toString();
				message.append("The report");
				if(!report.isEmpty()){
					message.append(" (");
					message.append(report);
					message.append(")");
				}
				message.append(" you are trying to generate does not exist.");
				
				throw new ReportNotFoundException(message.toString());
			} else {
				throw e;
			}
		} catch (IOException e) {
			throw e;
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
		}
		return result;
	}
}
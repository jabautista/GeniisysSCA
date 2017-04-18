/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.report;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRPropertiesMap;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;

import org.apache.log4j.Logger;

import com.geniisys.common.exceptions.ReportNotFoundException;


/**
 * The Class JasperGenerator.
 */
public class JasperGenerator {

	/** The logger. */
	private static Logger logger = Logger.getLogger(JasperGenerator.class);
	
	/**
	 * Gets the report.
	 * 
	 * @param propertiesLoc the properties loc
	 * @param fileName the file name
	 * @return the report
	 * @throws JRException the jR exception
	 */
	public JasperReport getReport(String propertiesLoc, String fileName) throws JRException{
		logger.info("Report dir and loc: "+propertiesLoc+fileName);
		logger.info("JR Version:"+JRPropertiesMap.class.getPackage().getImplementationVersion());
		logger.info("JR Map:"+JRPropertiesMap.class.getResource("/net/sf/jasperreports/engine/JRPropertiesMap.class"));
		logger.info("Getting report...");
		File file = new File(propertiesLoc+fileName);
		logger.info((propertiesLoc+fileName)+":"+file.isFile());
		JasperReport report = (JasperReport)JRLoader.loadObject(file);
		return report;
	}

	/**
	 * Generate jasper.
	 * 
	 * @param report the report
	 * @param map the map
	 * @return the jasper print
	 * @throws JRException the jR exception
	 * @throws SQLException the sQL exception
	 */
	public JasperPrint generateJasper(JasperReport report, Map<String, Object> map) throws JRException, SQLException{
		logger.info("Generating jasper...");
		Connection conn = (Connection) map.get("CONNECTION");
		JasperPrint print = null;
		try {
			print = JasperFillManager.fillReport(report, map, conn);
		} catch (JRException e){
			throw e;
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
		}
		return print;
	}

	public File generateJRPrintFile(Map<String, Object> parameters) throws JRException, SQLException{
		logger.info("Generating jrprint file...");
		Connection conn = (Connection) parameters.get("CONNECTION");
		File file = null;
		try {
			String REPORT_DIRECTORY = parameters.get("P_SUBREPORT_DIR").toString();
			String reportName = parameters.get("MAIN_REPORT").toString();  //parameters.get("reportName").toString(); - Halley 11.15.13
			System.out.println(REPORT_DIRECTORY + reportName + ".jasper");
			System.out.println(parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".jrprint");
			//JasperFillManager.fillReportToFile(REPORT_DIRECTORY + reportName + ".jasper", parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".jrprint", parameters, conn); 
			JasperFillManager.fillReportToFile(REPORT_DIRECTORY + reportName, parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".jrprint", parameters, conn);  //removed .jasper extension - Halley 11.15.13
			file = new File(parameters.get("GENERATED_REPORT_DIR").toString() + "/" + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".jrprint");
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
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
		}
		
		return file;
	}	
	
	public File generatePdfFile(Map<String, Object> parameters) throws JRException, SQLException{
		logger.info("Generating pdf file...");
		Connection conn = (Connection) parameters.get("CONNECTION");
		File file = null;
		try {
			String REPORT_DIRECTORY = parameters.get("P_SUBREPORT_DIR").toString();
			String reportName = parameters.get("MAIN_REPORT").toString();  //parameters.get("reportName").toString(); - Halley 11.15.13
			System.out.println(REPORT_DIRECTORY + reportName);  
			System.out.println(parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".pdf");
			//JasperRunManager.runReportToPdfFile(REPORT_DIRECTORY + reportName + ".jasper", parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".pdf", parameters, conn); 
			JasperRunManager.runReportToPdfFile(REPORT_DIRECTORY + reportName, parameters.get("GENERATED_REPORT_DIR").toString() + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".pdf", parameters, conn);  //removed .jasper extension - Halley 11.15.13
			file = new File(parameters.get("GENERATED_REPORT_DIR").toString() + "/" + parameters.get("OUTPUT_REPORT_FILENAME").toString() + ".pdf");
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
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
		}
		
		return file;
	}		
	
	/**
	 * Export report to bytes.
	 * 
	 * @param jasperPrint the jasper print
	 * @param exporter the exporter
	 * @return the byte[]
	 * @throws JRException the jR exception
	 */
	public byte[] exportReportToBytes(JasperPrint jasperPrint, JRExporter exporter) throws JRException {
		logger.info("Exporting jasper...");
		byte[] output;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT,jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);
        exporter.exportReport();
        output = baos.toByteArray();
        return output;
    }
	
	/**
	 * Export report to bytes.
	 * 
	 * @param jasperPrintList the jasper print list
	 * @param exporter the exporter
	 * @return the byte[]
	 * @throws JRException the jR exception
	 */
	public byte[] exportReportToBytes(List<JasperPrint> jasperPrintList, JRExporter exporter) throws JRException {
		logger.info("Exporting jasper list...");
		byte[] output;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST,jasperPrintList);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);
        exporter.exportReport();
        output = baos.toByteArray();
        return output;
    }
	
	/**
	 * Save file.
	 * 
	 * @param folderName the folder name
	 * @param fileName the file name
	 * @param jasperExported the jasper exported
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void saveFile(String folderName, String fileName, byte[] jasperExported) throws IOException{
		System.out.println("Jasper byte size: " + jasperExported.length);
		System.out.println("foldername: " + folderName + " filename: " + fileName);
		logger.info("Saving jasper report as " + folderName+fileName+".pdf");
		String filePath = folderName+fileName+".pdf";
		File propFile = new File(filePath);
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(propFile);
			fos.write(jasperExported);
			fos.flush();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw e;
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if(fos != null) {
				fos.close();		
			}
		}
	}
	
	/**
	 * Gets the pDF file.
	 * 
	 * @param folderName the folder name
	 * @param fileName the file name
	 * @return the pDF file
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public byte[] getPDFFile(String folderName, String fileName) throws IOException {
		logger.info("Getting PDF file...");
		String filePath = folderName+fileName+".pdf";
		FileInputStream fis;
		byte[] byteArray = null;
		fis = new FileInputStream(filePath);
		byteArray = new byte[fis.available()];
		fis.read(byteArray);
		fis.close();
		return byteArray;
	}
	

}

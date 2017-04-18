package com.geniisys.common.report;

import java.awt.print.Book;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import javax.print.PrintException;
import javax.print.PrintService;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.HashPrintServiceAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.PrintServiceAttributeSet;
import javax.print.attribute.Size2DSyntax;
import javax.print.attribute.standard.Copies;
import javax.print.attribute.standard.MediaPrintableArea;
import javax.print.attribute.standard.MediaSizeName;
import javax.print.attribute.standard.PrinterName;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPrintServiceExporter;
import net.sf.jasperreports.engine.export.JRPrintServiceExporterParameter;
import net.sf.jasperreports.engine.util.JRSaver;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import com.geniisys.common.exceptions.ReportNotFoundException;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.policydocs.reports.exception.EmptyFileReadException;
import com.sun.pdfview.PDFFile;
import com.sun.pdfview.PDFPrintPage;

public class PrintingUtil {
	
	/** The logger. */
	private static Logger log = Logger.getLogger(JasperGenerator.class);
	
	public boolean printPdfToPrinter(String fileName, String printerName, Map<String, Object> params) throws IOException, PrinterException{
		boolean result = true;
		FileInputStream fis = null;
		FileChannel fc = null;
		
		try {
			
			File f = new File(fileName);
			//FileInputStream fis = new FileInputStream(f);
			//FileChannel fc = fis.getChannel();
			fis = new FileInputStream(f);
			fc = fis.getChannel();
			
			ByteBuffer bb = fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());
			PDFFile pdfFile = new PDFFile(bb); // Create PDF Print Page
			System.out.println(pdfFile.getOutline());
			PDFPrintPage pages = new PDFPrintPage(pdfFile);

			// Create Print Job
			PrinterJob pjob = PrinterJob.getPrinterJob();
			PageFormat pf = PrinterJob.getPrinterJob().defaultPage();
			for(PrintService p: /*PrintServiceLookup.lookupPrintServices(null, null)*/PrinterJob.lookupPrintServices()) {
				if (p.getName().equalsIgnoreCase(printerName)) {
					log.info("Sending file "+fileName+" to printer "+p.getName()+"...");
					pjob.setPrintService(p);
					//pjob = null;
				}
			}

			double pageHeight = params.get("pageHeight") == null ? 0 : Double.parseDouble(params.get("pageHeight").toString());
			double pageWidth = params.get("pageWidth") == null ? 0 : Double.parseDouble(params.get("pageWidth").toString());
			
			Paper paper = new Paper();

			paper.setSize(pageWidth, pageHeight);
			if(pageHeight>=1000){
				paper.setImageableArea(0,0,1008,1008);//by bonok: 01.30.12 - for legal sized reports (8.5 x 14in)
			}else{
				paper.setImageableArea(10,10,800,800);
			}
			
			if(pageWidth >= 990 && pageWidth < 1000){
				paper.setImageableArea(0,0,990,792);//by bonok: 03.06.12 - for US std fanfold reports (11 x 14.87in)
			}
			
			pf.setPaper(paper);
			//pf.setOrientation(params.get("orientation").toString() == "PORTRAIT" ? PageFormat.PORTRAIT : PageFormat.LANDSCAPE);			
			
			pjob.setJobName(f.getName());
			Book book = new Book();
			book.append(pages, pf, pdfFile.getNumPages());
			pjob.setPageable(book);
			
			pjob.print();
			result = true;
		} catch (PrinterException e) {
			result = false;
			throw e;			
		} catch (IOException e) {
			result = false;
			throw e;
		} finally {
			if(fis != null){
				fis.close();
			}
			if(fc != null){
				fc.close();
			}
		}
		
		return result;
	}	
	
	/**
	 * Generate and print report
	 * @author andrew robes
	 * @date 03.07.2012
	 * @param params
	 * @return
	 * @throws JRException
	 * @throws SQLException
	 */
	public void printJRPrintFileToPrinter(Map<String, Object> params) throws JRException, SQLException {
		//boolean result = false;
		
		Connection conn = (Connection) params.get("CONNECTION");
		String filePath = params.get("GENERATED_REPORT_DIR").toString() + params.get("OUTPUT_REPORT_FILENAME") +".pdf";
		String printerName = params.get("printerName").toString();
		String fileName = params.get("GENERATED_REPORT_DIR").toString() + "/" + params.get("OUTPUT_REPORT_FILENAME").toString();
		File file = null;
		
		try {
			String REPORT_DIRECTORY = params.get("P_SUBREPORT_DIR").toString();			
			String reportName = params.get("MAIN_REPORT").toString();
			String mediaSizeName = params.get("mediaSizeName") == null ? "" : params.get("mediaSizeName").toString();
			
			int noOfCopies = Integer.parseInt((params.get("noOfCopies") == null ? "1" : params.get("noOfCopies").toString()));
			
			log.info("Jasper : " + REPORT_DIRECTORY + "/" + reportName);
			log.info("JRPrint : " + fileName + ".jrprint");

			JasperPrint jasper = JasperFillManager.fillReport(REPORT_DIRECTORY + "/" + reportName, params, conn);
			double pageHeight = params.get("pageHeight") == null ? jasper.getPageHeight() : Double.parseDouble(params.get("pageHeight").toString());
			
			JRSaver.saveObject(jasper, fileName + ".jrprint");
			file = new File(fileName + ".jrprint");
			
			PrintRequestAttributeSet requestAttributeSet = new HashPrintRequestAttributeSet();
			JRPrintServiceExporter exporter = new JRPrintServiceExporter();
			PrintServiceAttributeSet serviceAttributeSet = new HashPrintServiceAttributeSet();
			serviceAttributeSet.add(new PrinterName(printerName, null));

			requestAttributeSet.add(new Copies(noOfCopies));
			if(mediaSizeName.equals("US_STD_FANFOLD")){
				System.out.println("US_STD_FANFOLD ************ here");
				exporter.setParameter(JRPrintServiceExporterParameter.OFFSET_X, new  Integer(0)); //change by steven from: -20 to 0; napuputol kasi ung ibang mga character sa left side nung paper kapag nakaset siya sa -20.
				exporter.setParameter(JRPrintServiceExporterParameter.OFFSET_Y, new  Integer(3));
				requestAttributeSet.add(new MediaPrintableArea(0, 0, 355, 275, Size2DSyntax.MM));
				
				//requestAttributeSet.add(MediaSizeName.NA_10X14_ENVELOPE);
				//serviceAttributeSet.add(OrientationRequested.LANDSCAPE);
				//requestAttributeSet.add(new MediaPrintableArea(0, 0, 50, 50, Size2DSyntax.MM));
				
			    //MediaSize mediaSize = new MediaSize(990, 792, Size2DSyntax.MM);
			}else{
				if(pageHeight>=1000){				
					requestAttributeSet.add(MediaSizeName.NA_LEGAL);
				} else {
					requestAttributeSet.add(MediaSizeName.NA_LETTER);
				}
			}
			
			exporter.setParameter(JRExporterParameter.INPUT_FILE, file);			
			exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, requestAttributeSet);
			exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, serviceAttributeSet);
			exporter.exportReport();
			
			//result = true;		
		/*} catch (JRException e) {
			throw e;*/
			/*ExceptionHandler.logException(e);
			log.info("Printing to dot-matrix printer failed. Trying to print to laserjet ...");				
			printPdfToPrinter(filePath, printerName, params);*/
/*		} catch (Exception e){
			throw e;*/
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
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
			
			if (file != null && file.isFile()) {
				file.delete();
			}
			
			//return result;
		}
	}

	@SuppressWarnings("finally")
	public boolean printJRPrintFileToPrinter(String filePath, String printerName, Map<String, Object> params) throws JRException, SQLException{
		boolean result = false;
		
		Connection conn = (Connection) params.get("CONNECTION");
		
		try {
			String REPORT_DIRECTORY = params.get("P_SUBREPORT_DIR").toString();
			String fileName = params.get("GENERATED_REPORT_DIR").toString() + "/" + params.get("OUTPUT_REPORT_FILENAME").toString();
			String reportName = params.get("MAIN_REPORT").toString();
			double pageHeight = params.get("pageHeight") == null ? 0 : Double.parseDouble(params.get("pageHeight").toString());
			
			log.info("Jasper : " + REPORT_DIRECTORY + "/" + reportName);
			log.info("JRPrint : " + fileName + ".jrprint");

			JasperPrint jasper = JasperFillManager.fillReport(REPORT_DIRECTORY + "/" + reportName, params, conn);			
			
			JRSaver.saveObject(jasper, fileName + ".jrprint");
			File file = new File(fileName + ".jrprint");
			
			PrintRequestAttributeSet printRequestAttributeSet = new HashPrintRequestAttributeSet();
			
			if(pageHeight>=1000){
				printRequestAttributeSet.add(MediaSizeName.NA_LEGAL);
			} else {
				printRequestAttributeSet.add(MediaSizeName.NA_LETTER);
			}
			
			PrintServiceAttributeSet printServiceAttributeSet = new HashPrintServiceAttributeSet();		
			printServiceAttributeSet.add(new PrinterName(printerName, null));
			
			JRPrintServiceExporter exporter = new JRPrintServiceExporter();			
			
			exporter.setParameter(JRExporterParameter.INPUT_FILE, file);			
			exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);
			exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, printServiceAttributeSet);
			//exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.TRUE);
			//exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.TRUE);			
			
			exporter.exportReport();
			
			result = true;		
		} catch (JRException e) {
			ExceptionHandler.logException(e);
			log.info("Printing to dot-matrix printer failed. Trying to print to laserjet ...");				
			printPdfToPrinter(filePath, printerName, params);			
		} finally {
			if(conn != null && !conn.isClosed()){
				conn.close();
				conn = null;
			}
			return result;
		}
	}	
	
	public boolean printDocumentToPrinter(final String fileName, String printerName) throws IOException {		
		try {
			log.info("Printer Name: " + printerName);
			log.info("File Name: " + StringEscapeUtils.unescapeJava(fileName));
			
			final String[] windowsCommand = {/*"cmd", "/c", "start",*/ "soffice", "-writer", "-pt", printerName, StringEscapeUtils.unescapeJava(fileName)};
			
			final String[] command;
			final String os = System.getProperty("os.name");
			
			if(os.startsWith("Windows")){
				command = windowsCommand;
			}else{
				throw new IOException("Operating System not supported : " + os);				
			}
			
			final Process process = Runtime.getRuntime().exec(command);
			
			// Discard the stderr
			new Thread() {
				public void run() {
					try {
						InputStream errorStream = process.getErrorStream();
						while (errorStream.read() != -1) {
						};
						errorStream.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}				
			}.start();		
			
			return true;		
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			return false;
		}
	}	
	
	@SuppressWarnings("unused")
	public boolean generatePdfReport(HttpServletResponse response, Map<String, Object> params) throws IOException, SQLException, JRException{
		ReportGenerator reportGenerator = new ReportGenerator();
		boolean result = true;
		if (reportGenerator.generateReport(params)) {
			System.out.println("Opening report " + params.get("filePath").toString());
			FileInputStream fis = null;
			FileOutputStream os = null;
			ServletOutputStream out = null;
			ByteArrayInputStream bais = null;
			byte[] pdfByte = null;
			
			try {
				fis = new FileInputStream(params.get("filePath").toString());
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
				//fis.close();
				if (null==pdfByte) {
					try {
						throw new EmptyFileReadException("Failed to generate policy report because the file is empty...");
					} catch (EmptyFileReadException e) {
						result = false;
						ExceptionHandler.logException(e);
					}
				} else {
					File newFile = File.createTempFile("GENIISYS-REP", ".pdf");
					os = new FileOutputStream(newFile);
					System.out.println("byte size:" + pdfByte.length);
					os.write(pdfByte);
					os.flush();
					out = response.getOutputStream();
					response.setContentType("application/pdf");
					
					bais = new ByteArrayInputStream(pdfByte);
					
					int i = 0;
					while ((i = bais.read()) != -1) {
						out.write(i);
					}
					out.flush();
				}
			} catch (IOException e) {
				result = false;
				throw e;				
			} finally {
				if(fis!=null){
					fis.close();
				}
				if(os != null){
					os.close();
				}
				if(out != null){
					out.close();
				}
				if(bais != null){
					bais.close();
				}
				
				this.deleteDocument(params.get("filePath").toString());
			}
		}		
		return result;
	}
	
	/**
	 * Generates a report and prints it to printer if printerName is specified, otherwise generates a pdf report
	 * 
	 * @author andrew robes
	 * @date 03.07.2012
	 * @param request
	 * @param response
	 * @param params
	 * @throws ServletException
	 * @throws IOException
	 * @throws PrintException
	 * @throws JRException
	 * @throws SQLException
	 */
	public void startReportGeneration(Map<String, Object> params, HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException, PrintException, JRException, SQLException{		
		String printerName = request.getParameter("printerName") != null ? request.getParameter("printerName").toString() : null;
		
		if (null != printerName && "" != printerName && !("---".equals(printerName))){
			System.out.println("Printer Name: " + printerName);
			params.put("noOfCopies", Integer.parseInt((request.getParameter("noOfCopies") == null ? "1" : request.getParameter("noOfCopies"))));
			params.put("printerName", printerName);
			this.printJRPrintFileToPrinter(params);
			/*try {			
				if (this.printJRPrintFileToPrinter(params)){
					log.info("Document printed successfully (dot-matrix) ...");				    	
				} else {							
					log.info("Error printing.");
				}
			} catch (JRException e) {
				throw e;
			}*/
		}else{
			String filePath = params.get("GENERATED_REPORT_DIR").toString() + params.get("OUTPUT_REPORT_FILENAME") +".pdf";	
			if(!new File(params.get("GENERATED_REPORT_DIR").toString()).isDirectory()){
				System.out.println("GENERATE DIR: "+ params.get("GENERATED_REPORT_DIR").toString());
				new File(params.get("GENERATED_REPORT_DIR").toString()).mkdirs(); //to automatically generate the folder for the report Christian 01/30/2013
			}
			params.put("filePath", filePath);
			this.generatePdfReport(response, params);
			System.out.println("SHOW PDF!");
		}
	}	
	
	@Deprecated
	public void startReportGeneration(HttpServletRequest request, HttpServletResponse response, 
			Map<String, Object> params) throws ServletException, IOException, PrintException, JRException, SQLException{
		String filePath = params.get("GENERATED_REPORT_DIR").toString() + params.get("OUTPUT_REPORT_FILENAME") +".pdf";		
		params.put("filePath", filePath);
		String printerName = request.getParameter("printerName");
		if (this.generatePdfReport(response, params)){
			//next codes executes only if for printing to printer
			//String docFilePath = params.get("GENERATED_REPORT_DIR").toString() + params.get("OUTPUT_REPORT_FILENAME") +".odt";
			System.out.println("Printer Name: " + printerName);
			if ("" != printerName && !("---".equals(printerName)) && null != printerName){
				System.out.println("USE PRINTER!");
				int noOfCopies = Integer.parseInt((request.getParameter("noOfCopies") == null ? "1" : request.getParameter("noOfCopies")));
				for (int i=0; i<noOfCopies; i++){
					log.info("Printing copy no. "+(i+1) + " - " + StringEscapeUtils.escapeJava(printerName));					
					try {
						if (this.printJRPrintFileToPrinter(filePath, printerName, params)/*this.printPdfToPrinter(filePath, printerName, params)*/){
							log.info("Document printed successfully (dot-matrix) ...");				    	
						} else {
							log.info("Error printing.");
						}
					} catch (JRException e) {
						e.printStackTrace();
					}
				}
			}else{
				System.out.println("SHOW PDF!");
			}
			
			/*
			for(int i=0; i < 5; i++){
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());					
				}
			}
			deleteDocument(docFilePath);
			*/
		}
	}
	
	public void deleteDocument(String filePath) throws IOException {
		File deleteFile = new File(filePath);
		
		// make sure the file or directory exists and not write-protected
		if(!(deleteFile.exists())){
			throw new IllegalArgumentException("Document not exists.");
		}
		
		if(!(deleteFile.canWrite())){
			throw new IllegalArgumentException("Unable to delete write-protected document.");
		}
		
		boolean success = deleteFile.delete();
		
		if(!success){
			throw new IllegalArgumentException("Deletion failed.");
		}
	}

}

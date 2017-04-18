package com.geniisys.policydocs.reports.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRPdfExporter;

import org.apache.log4j.Logger;

import com.geniisys.common.report.JasperGenerator;

public class PolicyReportGenerator {

	private Logger log = Logger.getLogger(PolicyReportGenerator.class);
	
	public boolean generateReport(Map<String, Object> parameters) {
		log.info("Generating report...");
		boolean result = false;
		try {
			JasperGenerator generator = new JasperGenerator();
			JasperReport report = generator.getReport(parameters.get("SUBREPORT_DIR").toString(), "POLICY_DOCUMENT_MAIN.jasper");
			System.out.println("REPORT byte size: " + report.getQuery().getText());
			JasperPrint print = generator.generateJasper(report, parameters);
			generator.saveFile(parameters.get("GENERATED_REPORT_DIR").toString(), parameters.get("EXTRACT_ID").toString(), generator.exportReportToBytes(print, new JRPdfExporter()));
			result = true;
		} catch (JRException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return result;
	}
}
package com.geniisys.policydocs.reports.util;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

import org.apache.log4j.Logger;

public class PolicyReportsPropertiesUtil {

	public static final String reportsLocation = "/com/geniisys/policydocs/reports/";
	
	public static final String packReportsLocation = "/com/geniisys/policydocs/pack/reports/";
	
	public static final String bondReportsLocation = "/com/geniisys/policydocs/bonds/";
	
	public static final String invoiceReportsLocation = "/com/geniisys/underwriting/invoice/reports/";
	
	public static final String otherReportsLocation = "/com/geniisys/underwriting/other/reports/";
	
	public static final String packInvoiceReportsLocation = "/com/geniisys/underwriting/invoice/pack/reports";
	
	private static Logger log = Logger.getLogger(PolicyReportsPropertiesUtil.class);
		
	/*********************************************************************************************/
	//reports[0] are the DATABASE names of policy reports, reports[1] are their report names in Jasper
	private String[][] reports = {{"ACCIDENT", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"AVIATION", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"CASUALTY", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"ENGINEERING", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"MEDICAL", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"FIRE", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"MARINE_CARGO", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"MARINE_HULL", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"MOTORCAR", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"OTHER", "POLICY_DOCUMENT_MAIN", "POLICY_"},
								  {"PACKAGE", "PACK_POLICY_DOCUMENT_MAIN", "PACKAGE_POLICY_"},
								  {"C07", "CO7", "POLICY_"},
								  {"C(12)", "C(12)", "POLICY_"},
								  {"G02", "G02", "POLICY_"},
								  {"G2", "G(2)", "POLICY_"},
								  {"G(2)", "G(2)", "POLICY_"},
								  {"G(5)", "G(5)", "POLICY_"},
								  {"G07", "GO7", "POLICY_"},
								  {"G13", "G(13)", "POLICY_"},
								  {"G(13)", "G(13)", "POLICY_"},  //replaced G13 with G(13) 
								  {"G(18)", "G(18)", "POLICY_"},
								  {"G(17)", "G(17)", "POLICY_"},
								  {"G16", "G(16)", "POLICY_"},    //replaced G16 with G(16)
								  {"G(16)", "G(16)", "POLICY_"},
								  {"JCL5", "JCL5", "POLICY_"},
								  {"JCL(5)", "JCL(5)", "POLICY_"},
								  {"JCL7", "JCL(7)", "POLICY_"},
								  {"JCL(7)", "JCL(7)", "POLICY_"},
								  {"JCL(4)", "JCL(4)", "POLICY_"},
								   
								  {"JCL(15)", "JCL(15)", "POLICY_"},
								  
								  {"JCL(13)", "JCL(13)", "POLICY_"},
								  
								  //{"ACK", "ACK", "ACK_"},
								  
								  //ADDED BY Jeff Dojello for PHILFIRE 03.13.2013
							      {"JCL(3)", "JCL(3)", "POLICY_"}, //jeff 03.18.2013
							      {"JCL(8)", "JCL(8)", "POLICY_"}, 
							      {"JCL(9)", "JCL(9)", "POLICY_"},
								  {"JCR(2)", "JCR(2)", "POLICY_"}, 
								  {"G(02)", "G(2)", "POLICY_"}, 
								  {"G(16)-A", "G(16)", "POLICY_"}, 
								  {"G(16)-B", "G(16)", "POLICY_"}, 
								  {"G(16)-C", "G(16)", "POLICY_"},
								  {"G(16)-D", "G(16)", "POLICY_"}, 
								  {"G(16)-E", "G(16)", "POLICY_"}, 
								  {"G(16)-F", "G(16)", "POLICY_"}, 
								  //================================
								  
								  
								  //ADDED BY Jeff Dojello for AUII 10.23.2013
								  {"G16A", "G16A", "POLICY_"}, 
								  {"G16B", "G16B", "POLICY_"}, 
								  //================================
								  
								  {"ACK", "BOND_ACKNOWLEDGEMENT", "BOND_ACKNOWLEDGEMENT_"},	// mark jm 06.09.2011 - existing version
								  {"AOJ", "AOJ", "AOJ_"},
								  {"INDEM", "INDEM", "INDEM_"},
								  //{"GIPIR913", "GIPIR913_UCPB", "DEBIT_NOTE_"},
								  {"GIPIR913", "GIPIR913", "DEBIT_NOTE_"}, // andrew - 05.27.2011 - removed the hardcoded version
								  //{"GIPIR025", "GIPIR025_UCPB", "DEBIT_NOTE_"},								  
								  {"GIPIR025", "GIPIR025", "DEBIT_NOTE_"}, // andrew - 05.27.2011 - removed the hardcoded version
								  //{"GIPIR914", "GIPIR914_UCPB", "COC_REPORT_"},
								  {"GIPIR914", "GIPIR914", "COC_REPORT_"}, // andrew - 05.27.2011 - removed the hardcoded version
								  //{"GIPIR915", "GIPIR915_UCPB", "COC_REPORT_"}};
								  {"GIPIR915", "GIPIR915", "COC_REPORT_"}, // andrew - 05.27.2011 - removed the hardcoded version
								  {"GIRIR009", "GIRIR009", "GIRIR009_"},
								  {"GIPIR919", "GIPIR919_COVERNOTE", "COVER_NOTE_"}, // added by : nica 08.10.2011 - for cover note printing 
								  {"BONDS", "BOND_ENDT", "BOND_ENDT_"},
								  {"SURETYSHIP", "BOND_ENDT", "BOND_ENDT_"},
								  
								  {"JCL8", "JCL(8)", "POLICY_"}, //test robert
								  
								  //Added by PJD for MERIDIAN 09/27/2013
								  {"C9", "C9", "POLICY_"}, 
								  {"JCL4", "JCL4", "POLICY_"}, 
								  {"JCL15", "JCL15", "POLICY_"},
								  {"JCL13", "JCL13", "POLICY_"}, 
								  {"JCL8", "JCL8", "POLICY_"},
								  {"G2B", "G2B", "POLICY_"},
								  {"G2", "G2", "POLICY_"},
								  {"C26", "C26", "POLICY_"},
								  {"G16", "G16", "POLICY_"},
								  {"G13", "G13", "POLICY_"},
								  {"GIPIR152","GIPIR152", "POLICY_"},
								  
								  //Added by robert for AFPGEN 
								  {"FA(3)", "FA(3)", "POLICY_"}, 
								  {"FA(1)", "FA(1)", "POLICY_"}, 
								  {"FID(2)", "FID(2)", "POLICY_"},
								  {"C(22)", "C(22)", "POLICY_"}, 
								  {"C(25)", "C(25)", "POLICY_"},
								  //added by Gzelle for FGIC
								  {"JCL07", "JCL07", "POLICY_"},		
								  {"FID02", "FID02", "POLICY_"},		
								  {"C16", "C16", "POLICY_"},			
								  {"C23", "C23", "POLICY_"}
	}; // added by rencela...09/14/2011
								  
	
	
	public String getReportName(String reportCode){
		String reportName = "";
		for (String[] s: reports){
			if (s[0].equals(reportCode)){
				reportName = s[1];
			}
		}
		return reportName;
	}
	
	public String getTargetFilename(String reportCode){
		String targetFilename = "";
		for (String[] s: reports){
			if (s[0].equals(reportCode)){
				targetFilename = s[2];
			}
		}
		return targetFilename;
	}
	
	public JasperReport getSubReport(String report){
		JasperReport js = null;
		try {
			js =  (JasperReport)JRLoader.loadObject(this.getClass().getResourceAsStream(reportsLocation+report));
		} catch (JRException e) {		
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return js;
	}
}

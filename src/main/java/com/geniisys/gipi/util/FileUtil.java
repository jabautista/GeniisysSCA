/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;


/**
 * The Class FileUtil.
 */
public class FileUtil {

	/** The Constant EXCEL_FILE. */
	public static final String EXCEL_FILE = "xls";
	public static final String EXCEL_XLSX_FILE = "xlsx";	//kenneth SR 5307 04.14.2016
	private static Logger log = Logger.getLogger(FileUtil.class);
	/**
	 * Delete directory.
	 * 
	 * @param fileDir the file dir
	 * @throws FileNotFoundException the file not found exception
	 */
	public static void deleteDirectory(String fileDir) throws FileNotFoundException {
		File dir = new File(fileDir);
		File[] files = dir.listFiles();
		for (File file: files) {
			if (file.isFile()) {
				file.delete();
			}
		}
		System.gc();
		
		// delete main directory
		dir.delete();
	}
	
	/**
	 * Write file.
	 * 
	 * @param realPath the real path
	 * @param file the file
	 * @param genericId the generic id
	 * @return the file
	 * @throws IOException 
	 */
	public static File writeFile(String realPath, String file, int genericId) throws IOException {
		File newFile = null;
		FileInputStream fis = null;
		FileOutputStream os = null;
		try {
			//FileInputStream fis;
			byte[] pdfByte = null;
			try {
				fis = new FileInputStream(file);
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
				//fis.close();
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			
			String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
			int startIndex = file.lastIndexOf(slashType);
			String fileName = file.substring(startIndex+1);
			(new File(realPath+"/"+genericId)).mkdirs();
			newFile = new File(realPath+"/"+genericId+"/"+fileName);
			System.out.println("Writing to: " + newFile.getPath());
			//FileOutputStream os = new FileOutputStream(newFile);
			os = new FileOutputStream(newFile);
			os.write(pdfByte);
			os.flush();
			//os.close();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			if(fis != null) {
				fis.close();
			}
			if(os != null){
				os.close();
			}
		}
		
		return newFile;
	}
	
	public static File writeFile(String realPath, String file, String subFolder) throws IOException {
		File newFile = null;
		FileOutputStream os = null;
		FileInputStream fis = null;
		try {
			byte[] pdfByte = null;
			try {
				fis = new FileInputStream(file);
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
				//fis.close();
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			
			String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
			int startIndex = file.lastIndexOf(slashType);
			String fileName = file.substring(startIndex+1);
			(new File(realPath+"/"+subFolder)).mkdirs();
			newFile = new File(realPath+"/"+subFolder+"/"+fileName);
			System.out.println("Writing to: " + newFile.getPath());
			//FileOutputStream os = new FileOutputStream(newFile);
			os = new FileOutputStream(newFile);
			os.write(pdfByte);
			os.flush();
			//os.close();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			if(os != null){
				os.close();
			}
			if(fis != null){
				fis.close();
			}
		}
		
		return newFile;
	}	
	

	/**
	 * Checks if is excel file.
	 * 
	 * @param fileName the file name
	 * @param index the index
	 * @return true, if is excel file
	 */
	public static boolean isExcelFile(String fileName, int index) {
		boolean isXls = false;
		if (fileName.substring(index+1).equalsIgnoreCase(FileUtil.EXCEL_FILE)) {
			isXls = true;
		}
		
		return isXls;
	}
	
	/**
	 * Writes a file to the server directory
	 * @param realPath
	 * @param file
	 * @throws IOException
	 */
	public static void writeFileToServer(String realPath, String file) throws IOException {
		File newFile = null;
		FileInputStream fis = null;
		FileOutputStream os = null;
		try {
			byte[] fileByte = null;
			String subDir = file.substring(file.indexOf("/", 3), file.length());
			try {					
				fis = new FileInputStream(file);
				fileByte = new byte[fis.available()];
				fis.read(fileByte);
			} catch (IOException e) {
				throw e;
			}

			String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/"; // Windows
																			// or
																			// UNIX
			int startIndex = file.lastIndexOf(slashType);
			String fileName = file.substring(startIndex + 1);
			(new File(realPath + subDir)).mkdirs();
			String filePath = realPath + subDir + "/" + fileName;
			newFile = new File(filePath);
			System.out.println("Writing to: " + newFile.getPath());

			os = new FileOutputStream(newFile);
			os.write(fileByte);
			os.flush();
		} finally {
			if(fis != null) {
				fis.close();
			}
			if(os != null){
				os.close();
			}
		}
	}
	
	public static String writeFilesToServer(String realPath, List<String> files) throws IOException {
		File newFile = null;
		FileInputStream fis = null; 
		FileOutputStream os = null;
		String fileStat = null; /*Added by MarkS 02/15/2017 SR5918*/
		
		try {
			for(String file : files){
				byte[] fileByte = null;				
				try {					
					fis = new FileInputStream(file);
					fileByte = new byte[fis.available()];
					fis.read(fileByte);
				} catch (IOException e) {
					//throw e;
					fileStat="Missing some files.";
					continue; /* SR-5494 JET SEPT-26-2016; do not throw exception when file is not found, continue to next file instead */
				}
	
				String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/"; // Windows
																				// or
																				// UNIX
				int startIndex = file.lastIndexOf(slashType);
				String fileName = file.substring(startIndex + 1);
				String subDir = file.substring(file.indexOf(slashType, 3), file.length()-fileName.length());
				(new File(realPath + subDir)).mkdirs();
				String filePath = realPath + subDir + "/" + fileName;
				newFile = new File(filePath);
				System.out.println("Writing to: " + newFile.getPath());
	
				os = new FileOutputStream(newFile);
				os.write(fileByte);
				os.flush();
			}
		} finally {
			if(fis != null) {
				fis.close();
			}
			if(os != null){
				os.close();
			}
		}
		return fileStat;
	}

	public static void deleteFileDirectoryFromServer(String realPath, String fileDir) throws FileNotFoundException {
		if(!fileDir.isEmpty()){
			String slashType = (fileDir.lastIndexOf("\\") > 0) ? "\\" : "/";
			String subDir = fileDir.substring(fileDir.indexOf(slashType, 3), fileDir.length());
			
			StringBuilder fullPath = new StringBuilder();
			fullPath.append(realPath);
			fullPath.append(subDir);
			
			File dir = new File(fullPath.toString());
			System.out.println(dir.toString());
			if(dir.isDirectory()){
				File[] files = dir.listFiles();
				for (File file: files) {
					if (file.isFile()) {						
						if(file.delete()){
							log.info("Successfully deleted : " + file.getAbsoluteFile());
						} else {
							log.info("Failed to delete : " + file.getAbsoluteFile());
						}
					}
				}
				log.info("Deleting directory " + fullPath);
				dir.delete();
			}
		}
	}	
	
	public static void deleteFilesFromServer(String realPath, List<String> files) throws FileNotFoundException {
		if(files != null){
			for(String file : files){
				String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/";
				int startIndex = file.lastIndexOf(slashType);
				String fileName = file.substring(startIndex + 1);
				String subDir = file.substring(file.indexOf(slashType, 3), file.length()-fileName.length());
				
				String filePath = realPath + subDir + "/" + fileName;
				
				File f = new File(filePath.toString());
				System.out.println(f.toString());
				if (f.isFile()) {						
					f.delete();				
				}
			}
		}
	}
	
	/**
	 * Delete files
	 * @param files - list of one or more files absolute path
	 */
	public static void deleteFiles(List<String> files) {
		// fileNotFoundException is intentionally disregarded
		
		if (files != null) {
			for (String filePath : files) {
				if (!filePath.equals("")) {
					filePath = (StringEscapeUtils.unescapeHtml(filePath)).replace("\\", "/");
					
					File file = new File(filePath);
					
					log.info("Deleting " + file.getAbsolutePath().toString());
					file.delete();
					
					deleteParentDirectory(file, 2);
				}
			}
		}
	}
	
	/**
	 * Delete parent directory
	 * @param file - file
	 * @param depth - depth of directory to delete
	 */
	private static void deleteParentDirectory(File file, int depth) {		
		File parentDirectory = file.getParentFile();
		
		do {
			if (parentDirectory.isDirectory()) {
				if (parentDirectory.list().length <= 0) {
					log.info("Deleting " + parentDirectory.getAbsolutePath().toString());
					parentDirectory.delete();
					parentDirectory = parentDirectory.getParentFile();
				} else {
					return;
				}
			}
			depth--;
		} while(depth > 0);
	}
	
	/**
	 * Get file size
	 * @param filePath - file absolute path
	 * @throws IOException, FileNotFoundException
	 */
	public static Integer getFileSize(String filePath) throws IOException, FileNotFoundException {
		Integer fileSize = 0;
		
		if (filePath != null && !filePath.equals("")) {
			filePath = (StringEscapeUtils.unescapeHtml(filePath)).replace("\\", "/");
			
			FileInputStream fis = new FileInputStream(filePath);
			byte[] file = new byte[fis.available()];
			fis.read(file);
			fis.close();
			fileSize = file.length;
		}
		
		return fileSize;
	}
	
	/**
	 * Generate CSV File
	 * @param rows - records to write on CSV
	 * @param fileName - filename of CSV File
	 * @param realPath
	 * @throws IOException 
	 */
	public static String generateCSVFile(List<Map<String, Object>> rows, String fileName, String realPath) throws IOException{
		SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyyHHmmss");
		fileName = fileName + "_" + sdf.format(new Date())  + ".csv";
		realPath = realPath + "/csv\\";
		
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
	
	/**
	 * Checks xlsx and xls files
	 * kenneth SR 5307 04.14.2016
	 */
	public static boolean isExcel(String fileName, int index) {
		boolean isXls = false;
		if (fileName.substring(index+1).equalsIgnoreCase(FileUtil.EXCEL_FILE) || fileName.substring(index+1).equalsIgnoreCase(FileUtil.EXCEL_XLSX_FILE)) {
			isXls = true;
		}
		
		return isXls;
	}
	
}

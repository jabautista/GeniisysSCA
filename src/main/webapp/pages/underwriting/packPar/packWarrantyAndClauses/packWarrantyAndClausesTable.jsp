<!--Remarks: For deletion
	Date : 06-04-2012
	Developer: Steven P. Ramirez
	Replacement : /pages/underwriting/packPar/packWarrantyAndClauses/packWarrantyAndClausesTableGrid.jsp
 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="wcDiv" name="wcDiv" style="margin: 10px; margin-bottom: 30px;"">
	<div class="tableHeader" id="packWCTable" name="packWCTable">
		<label style="width: 28%; text-align: left; margin-left: 5px;">Warranty Title</label>
		<label style="width: 10%; text-align: left;">Type</label>
		<label style="width: 8%; text-align: left; margin-right: 15px;">Prt. Seq.</label>
		<label style="width: 41%; text-align: left;">Warranty Text</label>
		<label style="width: 3%; text-align: left;">P</label>
		<label style="width: 3%; text-align: left;">C</label>
	</div>
	
	<div class="tableContainer" id="packWCList" name="tableContainer" style="height: 155px; overflow-y:auto;"></div>
</div>

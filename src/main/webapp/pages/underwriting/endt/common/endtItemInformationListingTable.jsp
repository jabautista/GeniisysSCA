<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformation" style="width : 100%;">
	<div style="margin : 10px;" id="itemTable" name="itemTable">
		<div class="tableHeader">
			<label style="width: 80px; text-align: right; margin-right: 10px;" name="endtItemNo">Item No.</label>
			<label style="width: 180px; text-align: left;" name="endtItemTitle">Item Title</label>
			<label style="width: 180px; text-align: left;" name="endtItemDesc1">Description 1</label>
			<label style="width: 180px; text-align: left;" name="endtItemDesc2">Description 2</label>
			<label style="width: 120px; text-align: left;">Currency</label>
			<label style="width: 100px; text-align: right; margin-right: 10px;">Rate</label>
		</div>
		<div id="parItemTableContainer" class="tableContainer">			
		</div>
	</div>
</div>
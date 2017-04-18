<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformationMainDiv" style="width: 100%;">   
    <div id="searchResultParItem" align="center" style="margin: 10px;">
        <div style="margin: 10px;" id="itemTable" name="itemTable">          
            <div class="tableHeader">
                <label style="width: 40px; text-align: right; margin-right: 10px;" name="endtItemNo">No.</label>
				<label style="width: 200px; text-align: left;" name="endtItemTitle">Item Title</label>
				<label style="width: 190px; text-align: left;" name="endtItemDesc1">Description 1</label>
				<label style="width: 190px; text-align: left;" name="endtItemDesc2">Description 2</label>
				<label style="width: 120px; text-align: left;">Currency</label>
				<label style="width: 100px; text-align: right; margin-right: 10px;">Rate</label>
            </div>
            <div id="parItemTableContainer" class="tableContainer">
            	<!--input type="hidden" name="itemCount" id="itemCount" value="${itemCount}"-->
                               
            </div>                    
        </div>       
    </div>
</div>

<script type="text/javascript">
	
</script>
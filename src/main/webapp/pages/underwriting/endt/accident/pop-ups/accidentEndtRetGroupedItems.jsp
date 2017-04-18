<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="popGrpItemsInfo" class="sectionDiv" style="display: block;  background-color:white;">
	<div style="margin-left:65px; margin-right:20px; margin-top:5px; margin-bottom:0px; float:left; width:63%;" id="accidentRetGrpItemsTable" name="accidentRetGrpItemsTable">	
		<div class="tableHeader" style="margin-top:5px; ">
			<label style="text-align: left; width: 19px; margin-right: 6px;">&nbsp;</label>
			<label style="text-align: left; width: 45%; margin-right: 2px;">Grouped Item No.</label>
			<label style="text-align: left; width: 45%; margin-right: 2px;">Grouped Item Title</label>
		</div>
		<div class="tableContainer" id="accidentGrpItemsListing" style="display: block; margin:auto; width:100%;">
			
		</div>		
	</div>
	
	<div id="subButtonDiv" style="display: block; float:left; margin-top:40px;">
		<table border="0" style="margin-left:5px">
			<tr><td>
				<input type="button" class="button" id="btnRetSelectedGroupedItems" name="btnRetSelectedGroupedItems" value="Selected Grouped Items" style="width:160px" />
			</td></tr>
			<tr><td>
				<input type="button" class="button" id="btnRetAllGroupedItems" name="btnRetAllGroupedItems" value="All Grouped Items" style="width:160px" />
			</td></tr>
		</table>
	</div>
	
	<div style="width:100%; float:left;">
	<table align="center" style="margin-top:10px; margin-bottom:10px;">
		<tr>
			<td>
				<input type="button" class="button" 		id="btnOkPopRetGrpItems" 	    name="btnOkPopRetGrpItems" 		    	value="OK" 			style="width: 130px" />
				<input type="button" class="button" 		id="btnCancelPopRetGrpItems" 	name="btnCancelPopRetGrpItems" 			value="Cancel" 		style="width: 130px" />
			</td>
		</tr>
	</table>
	</div>
</div>

<script type="text/javascript">
/*
	var retGipiwGroupedItems = objRetGipiwGroupedItems;
	var retGipiwCoverageItems = objRetGipiwCoverageItems;
	var retGipiwGroupedBenItems = objRetGipiwGroupedBenItems;*/

	$("btnRetSelectedGroupedItems").observe("click", function (){
		$$("input[name='popRetCheck']").each(function (popRet){
			popRet.checked = false;
		});
	});

	$("btnRetAllGroupedItems").observe("click", function (){
		$$("input[name='popRetCheck']").each(function (popRet){
			popRet.checked = true;
		});
	});
</script>
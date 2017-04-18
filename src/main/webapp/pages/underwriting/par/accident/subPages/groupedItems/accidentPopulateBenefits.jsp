<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="popBenefitsInfo" class="sectionDiv" style="display:block; width:872px; background-color:white;">
	<div style="margin-left:65px; margin-right:20px; margin-top:5px; margin-bottom:0px; float:left; width:63%;" id="accidentPopBenTable" name="accidentPopBenTable">	
		<div class="tableHeader" style="margin-top:5px; ">
			<label style="text-align: left; width: 19px; margin-right: 6px;">&nbsp;</label>
			<label style="text-align: left; width: 45%; margin-right: 2px; font-size: 10px;">Enrollee Code</label>
			<label style="text-align: left; width: 45%; margin-right: 2px; font-size: 10px;">Enrollee Name</label>
		</div>
		<div id="accidentPopBenListing" name="accidentPopBenListing"></div>
	</div>
	<div id="subButtonDiv" style="display: block; float:left; margin-top:40px;">
		<table border="0" style="margin-left:5px">
			<tr><td>
				<input type="button" class="button" id="btnSelectedGroupedItems" name="btnSelectedGroupedItems" value="Selected Grouped Items" style="width:160px" />
			</td></tr>
			<tr><td>
				<input type="button" class="button" id="btnAllGroupedItems" name="btnAllGroupedItems" value="All Grouped Items" style="width:160px" />
			</td></tr>
		</table>
	</div>
	<div style="width:100%; float:left;">
		<table align="center" style="margin-top:10px; margin-bottom:10px;">
			<tr>
				<td>
					<input type="button" class="button" 		id="btnOkPopBen" 	    name="btnOkPopBen" 		    value="Populate" 	style="width: 65px" />
					<input type="button" class="button" 		id="btnOkCopyBen" 	    name="btnOkCopyBen" 		value="Copy" 		style="width: 60px" />
					<input type="button" class="button" 		id="btnOkDeleteBen" 	name="btnOkDeleteBen" 		value="Delete" 		style="width: 60px" />
					<input type="button" class="button" 		id="btnCancelPopBen" 	name="btnCancelPopBen" 		value="Cancel" 		style="width: 60px" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">

</script>
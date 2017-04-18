<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="outerDiv">
		<label id="">Delete/Add All Items</label>
		<span class="refreshers" style="margin-top: 0;">
   			<label id="showDeleteAddAllItems" name="gro" style="margin-left: 5px;">Show</label>
   		</span>
	</div>
</div>
<!-- form id="endtItemInfoAddDeleteItemForm" name="endtItemInfoAddDeleteItemForm" THIS PORTION IS INCLUDED AS A SUBPAGE SO CANNOT ENCLOSE IN FORM .BRY10.01.2010-->
	<!-- v_policy in OK button of Add/Delete Items -->
	<div class="sectionDiv" id="addDeleteItemDiv" name="addDeleteItemDiv">
		<input type="hidden" id="varDeductibleExist" name="varDeductibleExist" 	value="${message }" />
		<table width="100%" cellspacing="1" border="0">
			<tr>
				<td colspan="4" style="text-align: center;">
					<div style="width: 50%; margin-left: 10%" id="addDeleteItemTable" name="addDeleteItemTable" align="center">
						<div class="tableHeader">
							<label style="width: 20%; text-align: left;">Include</label>
						    <label style="width: 20%; text-align: left;">Item No.</label>
						</div>
						<div id="addDeleteItemTableContainer" class="tableContainer">
						</div>
					</div>
				</td>
			</tr>
			
			<tr>
				<td colspan="4" style="text-align: center;">
					<input type="button" style="width: 10%;" id="btnAddDeleteContinue"	name="btnAddDelItem" class="button" value="Continue"/>
					<input type="button" style="width: 10%;" id="btnAddDeleteCancel" 	name="btnAddDelItem" class="button" value="Cancel"/>
				</td>
			</tr>
		</table>
	</div>
<!-- /form -->
<script type="text/javascript">
var subjDiv = $("showDeleteAddAllItems");
subjDiv.innerHTML = "Hide";
subjDiv.observe("click", function ()	{
	subjDiv.innerHTML = (subjDiv.innerHTML == "Hide") ? "Show" : "Hide";
	Effect.toggle($("addDeleteItemDiv"), "blind", {duration: .3});
});
</script>
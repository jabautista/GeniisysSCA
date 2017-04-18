<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>    
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="motorCarAddtlInfoDiv" name="motorCarAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="motorCarItemInfogrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
	<div style="width: 100%;">
		<table border="0" style="margin-top: 50px; margin-bottom: 10px;" align="center">
			<tr>
				<td class="rightAligned" >Item</td>
				<td class="leftAligned"  style="width: 300px;">
					<div style="width: 70px;" class="required withIconDiv">
						<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 45px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
					</div>
					<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Plate No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 90px; float: left;" readonly="readonly">
					<!-- <label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Model Year</label> -->
					
				</td>
				<td class="leftAligned" >Model Year</td>
				<td>
					<input type="text" id="txtModelYear" name="txtModelYear" value="" style="width: 86px; float: left;" readonly="readonly">		
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Description</td>
				<td class="leftAligned" colspan="3" >
					<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
					</div>
				</td>
			</tr>
			<tr> 
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned">
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned" colspan="3" >
					<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<input type="text" id="txtMotcarCompDesc" name="txtMotcarCompCd" value="" style="width: 250px; text-align: left;" readonly="readonly">
					<input type="hidden" id="txtMotcarCompCd" name="txtMotcarCompDesc" value="" style="width: 173px;" readonly="readonly" >
				</td>
				<td class="rightAligned" >Motor No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtMotorNo" name="txtMotorNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Make</td>
				<td class="leftAligned">
					<input type="text" id="txtMakeCdDesc" name="txtMakeCd" value="" style="width: 250px; text-align: left;" readonly="readonly">
					<input type="hidden" id="txtMakeCd" name="txtMakeCdDesc" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Serial No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtSerialNo" name="txtSerialNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline Type</td>
				<td class="leftAligned">
					<input type="hidden" id="txtSublineTypeCd" name="txtSublineTypeCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtSublineTypeDesc" name="txtSublineTypeDesc" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >MV File No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtMvFileNo" name="txtMvFileNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Basic Color</td>
				<td class="leftAligned">
					<input type="hidden" id="txtBasicColorCd" name="txtBasicColorCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtBasicColorDesc" name="txtBasicColorDesc" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Motor Type</td>
				<td class="leftAligned" colspan="3" >
					<input type="hidden" id="txtMotType" name="txtMotType" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtMotTypeDesc" name="txtMotTypeDesc" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Color</td>
				<td class="leftAligned">
					<input type="hidden" id="txtColorCd" name="txtColorCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtColor" name="txtColor" value="" style="width: 250px	;" readonly="readonly">
				</td>
				<td class="rightAligned" >Series</td>
				<td class="leftAligned" colspan="3" >
					<input type="hidden" id="txtSeriesCd" name="txtSeriesCd" value="" style="width: 65px; text-align: right;" readonly="readonly" ignoreDelKey="true">
					<input type="text" id="txtEngineSeries" name="txtEngineSeries" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
			    <!-- Added condition for ora2010Sw by J. Diago 10.11.2013 -->
				<c:if test="${ora2010Sw eq 'Y'}">
				<td class="rightAligned" id="lblAssignee">Assignee</td>
				<td class="leftAligned">
					<input type="text" id="txtAssignee" name="txtAssignee" value="" style="width: 250px; text-align: left;" readonly="readonly" >
				</td>
				</c:if>
				<c:if test="${ora2010Sw eq 'N'}">
				<td class="rightAligned" id="lblAssignee"></td>
				<td class="leftAligned">
					<input type="hidden" id="txtAssignee" name="txtAssignee" value="" style="width: 250px; text-align: left;" readonly="readonly" >
				</td>
				</c:if>
				<!--End add condition for ora2010Sw by J. Diago 10.11.2013 -->
				<td class="rightAligned" >No. of Passengers</td>
				<td class="leftAligned"  >
					<input type="text" id="txtNoOfPass" name=""txtNoOfPass"" value="" style="width: 90px; float: left; " readonly="readonly"  class="rightAligned">
					<!-- <label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Model Year</label> -->
					
				</td>
				<td class="rightAligned" >Towing Limit</td>
				<td>
					<input type="text" id="txtTowing" name="txtTowing" class="money" value="" style="width: 86px; float: left;" readonly="readonly">		
				</td>
			</tr>
		</table>
	</div>	
	<div class="buttonsDiv" style="margin-bottom: 10px">
		<input type="button" id="btnAddItem" 	name="btnAddItem" 		class="button"	value="Add" />
		<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" />			
	</div>
</div>

<script type="text/javascript">
	// Added text editor - Nica 05.24.2013
	$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
	$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
</script>
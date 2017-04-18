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
<div id="casualtyAddtlInfoDiv" name="casualtyAddtlInfoDiv" class="sectionDiv" style="margin: 0px;" changeTagAttr="true">
	<div id="addtlCaInfoGrid" class="sectionDiv" style="border: none; position: relative; height: 206px; padding-left: 50px; padding-right: 50px; padding-top: 20px; padding-bottom: 20px; width: 800px;" changeTagAttr = true></div> 
	<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 120px;">Item</td>
			<td class="leftAligned">
				<div style="width: 90px;" class="required withIconDiv">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
				</div>
				<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 154px;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Description</td>
			<td class="leftAligned">
				<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Grouped Item</td>
			<td class="leftAligned"  >
				<div style="width: 90px;" class="withIconDiv">
					<input type="text" id="txtGrpCd" name="txtGrpCd" value="" style="width: 65px;" class="withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="groupNoDate" name="groupNoDate" alt="Go" />
				</div>				
				<input type="text" id="txtDspGrpDesc" name="txtDspGrpDesc" value="" style="width: 154px;" readonly="readonly">
			</td>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency</td>
			<td class="leftAligned"  >
				<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 173px;" readonly="readonly">		
			</td>
			<td class="rightAligned" >Property</td>
			<td class="leftAligned"  >
				<input type="text" id="txtProperty" name="txtProperty" value="" style="width: 65px; text-align: right;" readonly="readonly" ignoreDelKey="true">
				<input type="text" id="txtPropertyNo" name="txtPropertyNo" value="" style="width: 173px;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency Rate</td>
			<td class="leftAligned"  >
				<input type="text" id="txtCurencyRate" name="txtCurencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td class="rightAligned" >Location</td>
			<td class="leftAligned"  >
				<input type="text" id="txtLocation" name="txtLocation" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Section or Hazard</td>
			<td class="leftAligned"  >
				<input type="text" id="txtSecHaz" name="txtSecHaz" value="" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtSecHazCd" name="txtSecHazCd" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Conveyance</td>
			<td class="leftAligned"  >
				<input type="text" id="txtConveyance" name="txtConveyance" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtSecHazInfo" name="txtSecHazInfo" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtSecHazInfo" name="txtSecHazInfo" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtSecHazInfo" id="editTxtSecHazInfo" />
				</div>
			</td>
			<td class="rightAligned" >Interest in Premises</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtInterestPrems" name="txtInterestPrems" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtInterestPrems" name="txtInterestPrems" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtInterestPrems" id="editTxtInterestPrems" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Amount of Coverage</td>
			<td class="leftAligned"  >
			    <!-- added class = money2 by j.diago 04.14.204 -->
				<input class="money2" type="text" id="txtAmtCov" name="txtAmtCov" value="" style="width: 250px; text-align: right;" ignoreDelKey="true">
			</td>
			<td class="rightAligned" >Limit of Liability</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtLimLiablty" name="txtLimLiablty" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtLimLiablty" name="txtLimLiablty" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtLimLiablty" id="editTxtLimLiablty" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
			</td>
			<td class="rightAligned" >Position</td>
			<td class="leftAligned"  >
				<input type="text" id="txtCapacityCd" name="txtCapacityCd" value="" style="width: 65px; text-align: right;" readonly="readonly" ignoreDelKey="true">
				<input type="text" id="txtPosition" name="txtPosition" value="" style="width: 173px;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
	</table>
	<center>
		<div class="buttonsCaDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddItem" 	name="btnAddItem" class="button"	value="Add" />
			<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" /> 			
		</div> 
	</center>
</div>

<script type="text/javascript">
	// Added text editor - Nica 05.24.2013
	$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
	$("editTxtItemDesc2").observe("click", function(){showEditor("txtLimLiablty", 2000, 'true');});
	$("editTxtSecHazInfo").observe("click", function(){showEditor("txtSecHazInfo", 2000, 'true');});
	$("editTxtInterestPrems").observe("click", function(){showEditor("txtInterestPrems", 500, 'true');});
	$("editTxtLimLiablty").observe("click", function(){showEditor("txtLimLiablty", 500, 'true');});
</script>

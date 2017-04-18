<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- <div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Driver Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">hide</label>
		</span>
	</div>
</div> -->
<!-- <div id="motorCarDriverDetailsDiv" style=""  class="sectionDiv"> -->
	<table id="driverTable" border="0" style="margin-top: 30px; margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned">Driver Name</td>
			<td class="leftAligned">
				<input type="text" id="txtDrvrName" name="driverDetails" value="" style="width: 250px; text-align: right;" maxlength="100">
			</td>
			<td class="rightAligned" style="width: 100px;">Driving Experience</td>
			<td class="leftAligned"  style="width: 118px;">
				<input type="text" id="txtDrvngExp" name="driverDetails" value="" style="width: 90px; float: left;" class="integerNoNegative" errorMsg="Invalid Driving Experience. Valid value should be from 0 to 999." maxlength="3">
				<!-- <label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Model Year</label> -->
				
			</td>
			<td class="rightAligned" >Age</td>
			<td>
				<input type="text" id="txtDrvrAge" name="driverDetails" value="" style="width: 90px; float: left;" class="integerNoNegative" errorMsg="Invalid Age. Valid value should be from 0 to 99." maxlength="2">		
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;">Occupation</td>
			<td class="leftAligned"  style="width: 300px;">
				<div style="width: 70px;" class="withIconDiv">
					<input type="text" id="txtDrvrOccCd" name="driverDetails" value="" readonly="readonly" style="width: 45px;" class="withIcon" maxlength="9">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDrvrOccCdGo" name="txtDrvrOccCdGo" alt="Go" />
				</div>
				<input type="text" id="txtDrvrOccDesc" name="txtDrvrOccDesc" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Sex</td>
			<td class="leftAligned" colspan="3" >
				<select id="txtDrvrSex" name="driverDetails" style="width: 256px">
					<option></option>
					<option value="M">Male</option>
					<option value="F">Female</option>
				</select>
				<!-- <input type="text" id="txtDrvrSex" name="txtDrvrSex" value="" style="width: 249px;" readonly="readonly"> -->
			</td> 
		</tr>
		<tr>
			<td class="rightAligned">Address</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 255px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 225px; border: none; height: 13px;" id="txtDrvrAdd" name="driverDetails"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtDrvrAdd" id="editTxtDrvrAdd" />
				</div>
			</td>
			
			<td class="rightAligned" style="width: 120px;">Nationality</td>
			<td class="leftAligned"  style="width: 300px;" colspan="3">
				<div style="width: 70px;" class="withIconDiv">
					<input type="text" id="txtNationalityCd" name="driverDetails" value="" readonly="readonly" style="width: 45px;" class="withIcon" maxlength="9">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNationalityCdGo" name="txtNationalityCdGo" alt="Go" />
				</div>
				<input type="text" id="txtNationalityDesc" name="txtNationalityDesc" value="" style="width: 173px;" readonly="readonly">
			</td> 
			
			
		</tr>
		<tr>
			<td class="rightAligned">Relation to Assured</td>
			<td class="leftAligned">
				<!-- <input type="text" id="txtRelation" name="driverDetails" value="" style="width: 250px; text-align: right;" onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);"> -->
				<input type="text" id="txtRelation" name="driverDetails" value="" style="width: 250px; text-align: right;" maxlength="200">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnApplyChanges" value="Apply Changes">
	</div>
<!-- </div>	 -->
<script type="text/javascript">
	disableButton("btnApplyChanges");
	
	if(objCLMGlobal.currMcItem != null){
		populateMotorCarFields(itemGrid.rows[objCLMGlobal.currMcItem]);	
	}
	
	function updateDriverDetails(){ // andrew 04.20.2012
		try {		
			//modified by j.diago 04.15.2014 added escapeHTML2 function to handle special characters.
			itemGrid.setValueAt(escapeHTML2($F("txtNationalityCd")),itemGrid.getColumnIndex('nationalityCd'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtNationalityDesc")),itemGrid.getColumnIndex('nationalityDesc'), itemGrid.getCurrentPosition()[1]);			
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrAdd")),itemGrid.getColumnIndex('drvrAdd'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrName")),itemGrid.getColumnIndex('drvrName'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrOccCd")),itemGrid.getColumnIndex('drvrOccCd'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrOccDesc")),itemGrid.getColumnIndex('drvrOccDesc'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtRelation")),itemGrid.getColumnIndex('relation'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt($F("txtDrvngExp"),itemGrid.getColumnIndex('drvngExp'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt($F("txtDrvrAge"),itemGrid.getColumnIndex('drvrAge'), itemGrid.getCurrentPosition()[1]);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrSex")),itemGrid.getColumnIndex('drvrSex'), itemGrid.getCurrentPosition()[1]);
			
			$('mtgRow'+itemGrid._mtgId+'_'+objCLMItem.selItemIndex).removeClassName('selectedRow');			
			itemGrid.keys.removeFocus();
			itemGrid.keys.releaseKeys();
			populateMotorCarFields(null);
			disableButton("btnApplyChanges");
			changeTag = 1;
		} catch (e){
			showErrorMessage("updateDriverDetails", e);
		}
	}
	
	$("btnApplyChanges").observe("click", updateDriverDetails);
	
	$("editTxtDrvrAdd").observe("click", function () {
		//showOverlayEditor("txtDrvrAdd", 2000);
		//showEditor("txtDrvrAdd", 500);
		//showEditor("txtDrvrAdd", 2000);
		showOverlayEditor("txtDrvrAdd", 2000, $("txtDrvrAdd").hasAttribute("readonly"));
	});
	
	$("txtDrvrOccCdGo").observe("click",function(){
		showDriverOccupationLOV();
	});
	
	$("txtNationalityCdGo").observe("click",function(){
		showNationalityLOV();
	});
	
	$("txtDrvrName").observe("keyup", function(){
		$("txtDrvrName").value = $("txtDrvrName").value.toUpperCase();
	});
	
	$$("input[name='driverDetails']").each(function(val){
		val.observe("change", function(){
			var enabled = "N";
			$$("input[name='driverDetails']").each(function(hasVal){
				if(hasVal.value != ""){
					enableButton("btnApplyChanges");
					enabled = "Y";
				} else {
					if(enabled != "Y"){
						disableButton("btnApplyChanges");	
					}
				}
			});
		});
	});
	
	$$("select[name='driverDetails']").each(function(val){
		val.observe("change", function(){
			var enabled = "N";
			$$("input[name='driverDetails']").each(function(hasVal){
				if(hasVal.value != ""){
					enableButton("btnApplyChanges");
					enabled = "Y";
				} else {
					if(enabled != "Y"){
						disableButton("btnApplyChanges");	
					}
				}
			});
		});
	});
	
	$$("textarea[name='driverDetails']").each(function(val){
		val.observe("change", function(){
			var enabled = "N";
			$$("input[name='driverDetails']").each(function(hasVal){
				if(hasVal.value != ""){
					enableButton("btnApplyChanges");
					enabled = "Y";
				} else {
					if(enabled != "Y"){
						disableButton("btnApplyChanges");	
					}
				}
			});
		});
	});
	
	$("groDriverInfo").show();
	$("loadDriverInfo").hide();
</script>
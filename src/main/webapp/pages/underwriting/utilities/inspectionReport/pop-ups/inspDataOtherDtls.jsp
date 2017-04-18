<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="otherDtlsMainDiv" class="sectionDiv">
	<table style="width: 100%;" cellpadding="0" cellspacing="0">
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Fire Protection</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="fireProtection" name="fireProtection" style="width: 99%; height: 30px;">${inspDataDtl.fiProRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="fireProtection" name="fireProtection" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.fiProRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="fireProtection" name="fireProtection" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.fiProRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editFireProtection" id="editFireProtection" />
				</div>
				<%-- <input id="" name="" style="width: 99%;" value="${}" /> --%>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Fire Station</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="fireStation" name="fireStation" style="width: 99%; height: 30px;">${inspDataDtl.fiStationRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="fireStation" name="fireStation" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.fiStationRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="fireStation" name="fireStation" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.fiStationRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editFireStation" id="editFireStation" />
				</div>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Security System</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="securitySystem" name="securitySystem" style="width: 99%; height: 30px;">${inspDataDtl.secSysRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="securitySystem" name="securitySystem" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.secSysRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="securitySystem" name="securitySystem" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.secSysRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editSecuritySystem" id="editSecuritySystem" />
				</div>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">General Surroundings</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="generalSurroundings" name="generalSurroundings" style="width: 99%; height: 30px;">${inspDataDtl.genSurrRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="generalSurroundings" name="generalSurroundings" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.genSurrRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="generalSurroundings" name="generalSurroundings" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.genSurrRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editGenSurroundings" id="editGenSurroundings" />
				</div>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Maintenance</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="maintenance" name="maintenance" style="width: 99%; height: 30px;">${inspDataDtl.maintDtlRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="maintenance" name="maintenance" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.maintDtlRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="maintenance" name="maintenance" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.maintDtlRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editMaintenance" id="editMaintenance" />
				</div>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Electrical Installation</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="electricalInst" name="electricalInst" style="width: 99%; height: 30px;">${inspDataDtl.elecInstRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="electricalInst" name="electricalInst" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.elecInstRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="electricalInst" name="electricalInst" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.elecInstRemarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editElecInst" id="editElecInst" />
				</div>
			</td>
			<td></td>
		</tr>
		<tr style="height: 35px;">
			<td style="width: 5%;"></td>
			<td class="leftAligned" style="width: 25%;">Housekeeping</td>
			<td class="leftAligned" style="width: 1%;">:</td>
			<td class="leftAligned" style="width: 65%;">
				<%-- <textarea id="housekeeping" name="housekeeping" style="width: 99%; height: 30px;">${inspDataDtl.hkRemarks }</textarea> --%>
				<div style="border: 1px solid gray; height: 20px; width: 99%; ">
					<%-- <input type="text" id="housekeeping" name="housekeeping" style="width: 94%; border: none; height: 14px; margin-top: 2px; background-color: transparent;" value="${inspDataDtl.hkRemarks}" /> --%>
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="housekeeping" name="housekeeping" style="width: 94%; border: none; float: left; height: 13px; resize: none; background-color: transparent;" maxlength="2000"/>${inspDataDtl.hkRemarks }</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editHousekeeping" id="editHousekeeping" />
				</div>
			</td>
			<td></td>
		</tr>
	</table>
	<div style="width: 100%; height: 120px; margin-top: 5px; margin-bottom: 10px;" id="insuredPerilsInfo" name="insuredPerilsInfo">
		<div style="float: left; margin-left: 25px; width: 25%;">
			<b style="float: left;">Insured Perils</b><br />
			<input type="checkbox" id="flOption1" name="flOption1" value="Y" style="float: left; margin-top: 5px; margin-left: 5px;"
				<c:if test="${inspDataDtl2.perilOption1 eq 'Y'}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-top: 5px; margin-left: 5px; width: 85%;">Option 1 (F/L Only)</label>
			<input type="checkbox" id="flOption2" name="flOption2" value="Y" style="float: left; margin-top: 38px; margin-left: 5px;"
				<c:if test="${inspDataDtl2.perilOption2 eq 'Y'}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-top: 38px; margin-left: 5px; width: 85%;">Option 2 (F/L with Allied)</label>
		</div>
		<div style="float: left; margin-left: 35px; width: 30%;">
			<b style="float: left;">Final Rate</b><br />
			<label style="float: left; margin-left: 5px; margin-top: 4px;">Building</label>
			<!-- Added align and maxlength reymon 02212013 -->
			<input style="float: left; width: 100px; margin-left: 11px; text-align: right;" type="text" id="building1" name="rate" value="${inspDataDtl2.perilOption1BldgRate}" maxlength="13"
				<c:if test="${inspDataDtl2.perilOption1 ne 'Y'}">
					disabled="disabled"
				</c:if>
			/>
			<label style="float: left; margin-left: 5px; margin-top: 4px;">Contents</label>
			<!-- Added align and maxlength reymon 02212013 -->
			<input style="float: left; width: 100px; margin-left: 5px; text-align: right;" type="text" id="contents1" name="rate" value="${inspDataDtl2.perilOption1ContRate}" maxlength="13"
				<c:if test="${inspDataDtl2.perilOption1 ne 'Y'}">
					disabled="disabled"
				</c:if>
			/>
			<label style="float: left; margin-left: 5px; margin-top: 4px;">Building</label>
			<!-- Added align and maxlength reymon 02212013 -->
			<input style="float: left; width: 100px; margin-left: 11px; text-align: right;" type="text" id="building2" name="rate" value="${inspDataDtl2.perilOption2BldgRate}" maxlength="13"
				<c:if test="${inspDataDtl2.perilOption2 ne 'Y'}">
					disabled="disabled"
				</c:if>
			/>
			<label style="float: left; margin-left: 5px; margin-top: 4px;">Contents</label>
			
			<!-- Added align and maxlength reymon 02212013 --><input style="float: left; width: 100px; margin-left: 5px; text-align: right;" type="text" id="contents2" name="rate" value="${inspDataDtl2.perilOption2ContRate}" maxlength="13"
				<c:if test="${inspDataDtl2.perilOption2 ne 'Y'}">
					disabled="disabled"
				</c:if>
			/>
		</div>
		<div style="float: left; margin-left: 8px; width: 35%;">
			<b style="float: left;">Grading of Risk</b><br/>
			<input type="radio" id="riskGrading1" name="riskGrading" value="1" style="float: left; margin-left: 15px; margin-top: 10px;"
				<c:if test="${inspDataDtl2.riskGrade eq 1}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-left: 3px; margin-top: 10px;">Superior</label>
			<input type="radio" id="riskGrading4" name="riskGrading" value="4" style="float: left; margin-left: 60px; margin-top: 10px;"
				<c:if test="${inspDataDtl2.riskGrade eq 4}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-top: 10px; width: 65px;">Fair</label>
			<input type="radio" id="riskGrading2" name="riskGrading" value="2" style="float: left; margin-left: 15px; margin-top: 7px;"
				<c:if test="${inspDataDtl2.riskGrade eq 2}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-left: 3px; margin-top: 7px;">Good</label>
			<input type="radio" id="riskGrading5" name="riskGrading" value="5" style="float: left; margin-left: 78px; margin-top: 7px;"
				<c:if test="${inspDataDtl2.riskGrade eq 5}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-top: 7px; width: 65px;">Unacceptable</label>
			<input type="radio" id="riskGrading3" name="riskGrading" value="3" style="float: left; margin-left: 15px; margin-top: 7px;"
				<c:if test="${inspDataDtl2.riskGrade eq 3}">
					checked="checked"
				</c:if>
			/>
			<label style="float: left; margin-left: 3px; margin-top: 7px;">Satisfactory</label>
		</div>
	</div>
	<div align="center" style="margin-bottom: 10px;">	
		<input id="btnOtherDtlsOk" name="btnOtherDtlsOk" type="button" class="button" value="Ok" style="width: 100px;"/>
		<input id="btnOtherDtlsCancel" name="btnOtherDtlsCancel" type="button" class="button" value="Cancel" style="width: 100px;" onClick="Modalbox.hide();"/>
	</div>
</div>
<script type="text/javascript">
	giis197parameters = JSON.parse('${parameters}'); //moved by jeffdojello 11.20.2013 
	//resizeOtherDtlsModal(); //john 12.9.2015 SR#4019
	prepareEditOtherDtls();
	//temporary
	if ($("approvedTag").checked){
		$$("textarea").each(function (a){
			a.setAttribute("readonly", "readonly");
		});
		$$("input[type=checkbox]").each(function (b){
			b.setAttribute("disabled", "disabled");
		});
		$$("input[type=radio]").each(function (c){
			c.setAttribute("disabled", "disabled");
		});
		$$("input[type=text]").each(function (d){
			d.setAttribute("readonly", "readonly");
		});
	} else {
		$$("textarea").each(function (a){
			a.removeAttribute("readonly");
		});
		$$("input[type=checkbox]").each(function (b){
			b.removeAttribute("disabled");
		});
		$$("input[type=radio]").each(function (c){
			c.removeAttribute("disabled");
		});
		$$("input[type=text]").each(function (d){
			d.removeAttribute("readonly");
		});
	}
	
	if (inspectionReportObj.selectedItem == ""){
		$$("div[name=insuredPerilsInfo] input[type=radio]").each(function (a){
			a.setAttribute("disabled", "disabled");
		});
		
		$$("div[name=insuredPerilsInfo] input[type=checkbox]").each(function (a){
			a.setAttribute("disabled", "disabled");
		});
	} else {
		$$("div[name=insuredPerilsInfo] input[type=radio]").each(function (a){
			a.removeAttribute("disabled");
		});
		
		$$("div[name=insuredPerilsInfo] input[type=checkbox]").each(function (a){
			a.removeAttribute("disabled");
		});
	}

	//giis197parameters = JSON.parse('${parameters}'); commented out by jeffdojello 11.20.2013 moved to the upper portion

	function resizeOtherDtlsModal(){
		if (nvl(giis197parameters.ora2010Sw, 'N') == 'N'){ //NVL added by jeffdojello 11.20.2013 to make sure that default will be N
			$("insuredPerilsInfo").setStyle({display : 'none'});
			$("btnOtherDtlsOk").setStyle({margin : '10px'});
			Modalbox.resizeToContent();
		}
	}
	
	function prepareEditOtherDtls(){
		var added = inspectionReportObj.otherDtls;
		if (typeof(added.inspNo) != "undefined"){
			$("fireProtection").value = added.fiProRemarks;
			$("fireStation").value = added.fiStationRemarks;
			$("securitySystem").value = added.secSysRemarks;
			$("generalSurroundings").value = added.genSurrRemarks;
			$("maintenance").value = added.maintDtlRemarks;
			$("electricalInst").value = added.elecInstRemarks;
			$("housekeeping").value = added.hkRemarks;
	
			$("building1").value = added.perilOption1BldgRate;
			$("contents1").value = added.perilOption1ContRate;
			$("building2").value = added.perilOption2BldgRate;
			$("contents2").value = added.perilOption2ContRate;

			$("flOption1").checked = added.perilOption1 == 'Y' ? true : false;
			$("flOption2").checked = added.perilOption2 == 'Y' ? true : false;

			if (nvl(added.riskGrade, "") != ""){
				var id = "riskGrading"+added.riskGrade;
				$(id).checked = true;
			}

			observePerilOption1();
			observePerilOption2();
		}
	}

	function prepareOtherDtlsObject(){
		var otherDtlsObj = new Object();
		otherDtlsObj.inspNo = $F("inspNo");
		otherDtlsObj.itemNo = parseInt($F("itemNo"));
		otherDtlsObj.fiProRemarks = $F("fireProtection");
		otherDtlsObj.fiStationRemarks = $F("fireStation");
		otherDtlsObj.secSysRemarks = $F("securitySystem");
		otherDtlsObj.genSurrRemarks = $F("generalSurroundings");
		otherDtlsObj.maintDtlRemarks = $F("maintenance");
		otherDtlsObj.elecInstRemarks = $F("electricalInst");
		otherDtlsObj.hkRemarks = $F("housekeeping");

		otherDtlsObj.perilOption1 = nvl($F("flOption1"), 'N');
		otherDtlsObj.perilOption2 = nvl($F("flOption2"), 'N');
		otherDtlsObj.perilOption1BldgRate = $F("building1");
		otherDtlsObj.perilOption1ContRate = $F("contents1");
		otherDtlsObj.perilOption2BldgRate = $F("building2");
		otherDtlsObj.perilOption2ContRate = $F("contents2");
		var riskGrades = document.getElementsByName("riskGrading");
		for (var i = 0; i < riskGrades.length; i++){
			if (riskGrades[i].checked){
				otherDtlsObj.riskGrade = riskGrades[i].value;
			}
		}
		return otherDtlsObj; 
	}

	function observePerilOption1(){
		if ($("flOption1").checked){
			$("building1").removeAttribute("disabled");
			$("contents1").removeAttribute("disabled");
		} else {
			$("building1").value = "";
			$("contents1").value = "";
			$("building1").setAttribute("disabled", "disabled");
			$("contents1").setAttribute("disabled", "disabled");
		}
	}

	function observePerilOption2(){
		if ($("flOption2").checked){
			$("building2").removeAttribute("disabled");
			$("contents2").removeAttribute("disabled");
		} else {
			$("building2").value = "";
			$("contents2").value = "";
			$("building2").setAttribute("disabled", "disabled");
			$("contents2").setAttribute("disabled", "disabled");
		}
	}
	
	$("btnOtherDtlsOk").observe("click", function (){
		inspectionReportObj.otherDtls = prepareOtherDtlsObject();

		Modalbox.hide();
	});
	
	//added by robert 01.22.2014
	$("btnOtherDtlsCancel").observe("click", function (){
		changeTag = 0; 
		Modalbox.hide();
	});

	$$("input[name='rate']").each(function (input){
		input.observe("blur", function (){
			if (isNaN($F(input)) || Number($F(input)) > Number(100) || Number($F(input)) < Number(0)){
				customShowMessageBox("Invalid value. Value should be from 0 to 100.", imgMessage.ERROR, input);
				$(input).clear();
				return false;
			}
			//added by reymon 02212013
			//checking if input is greater than 1000
			/* if (Number($F(input)) > Number(999.999999999)){
				customShowMessageBox("Input must not be greater than 1000.", imgMessage.ERROR, input);
				$(input).clear();
				return false;
			} */ //remove by steven 9.20.2013
		});
	});

	$("flOption1").observe("change", function (){
		observePerilOption1();
	});
		
	$("flOption2").observe("change", function (){
		observePerilOption2();
	});
	// text fields
	$("editFireProtection").observe("click", function () {
		showEditor("fireProtection", 2000, 'false');
	});
	$("fireProtection").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editFireStation").observe("click", function () {
		showEditor("fireStation", 2000);
	});
	$("fireStation").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editSecuritySystem").observe("click", function () {
		showEditor("securitySystem", 2000);
	});
	$("securitySystem").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editGenSurroundings").observe("click", function () {
		showEditor("generalSurroundings", 2000);
	});
	$("generalSurroundings").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editMaintenance").observe("click", function () {
		showEditor("maintenance", 2000);
	});
	$("maintenance").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editElecInst").observe("click", function () {
		showEditor("electricalInst", 2000);
	});
	$("electricalInst").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editHousekeeping").observe("click", function () {
		showEditor("housekeeping", 2000);
	});
	$("housekeeping").observe("keyup", function () {
		limitText(this, 2000);
	});
</script>
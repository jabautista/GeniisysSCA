<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss076MainDiv" name="giiss076MainDiv" style="">
	<div id="intermediaryDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="intermediaryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Intermediary Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss076" name="giiss076">		
		<div class="sectionDiv">
			<form id="intermediaryMaintenanceForm" name="intermediaryMaintenanceForm">
				<div align="center" id="intermediaryFormDiv">
					<table style="margin-top: 20px; width: 870px;">
						<tr>
							<input id="recordStatus" name="recordStatus" type="hidden" value="${recordStatus }"/>
							<input id="hidIntmNo" name="hidIntmNo" type="hidden" value="${giisIntermediary.intmNo }"/>
							<td class="rightAligned">Intermediary No.</td>
							<td class="leftAligned">
								<input id="intmNo" name="intmNo" type="text" class="" readonly="readonly" value="${giisIntermediary.intmNo }" style="width: 140px; float:left; text-align: right;" tabindex="201" maxlength="12">
								<label style="padding: 6px 0px 0 4px;">/</label>
							</td>
							<td>
								<input id="refIntmCd" name="refIntmCd" type="text" class="" value="${giisIntermediary.refIntmCd }" style="width: 140px; " tabindex="202" maxlength="10">
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;">C.A. No./Date</td>
							<td>
								<input id="caNo" name="caNo" type="text" value="${giisIntermediary.caNo }" style="width: 120px; float:left;  margin: 0px 5px 0 0px;" tabindex="203" maxlength="15">
								<div id="caDateDiv" style="width: 120px; height: 20px; border: solid gray 1px; float: left;">
									<input id="caDate" name="caDate" readonly="readonly" type="text" value="${giisIntermediary.caDateChar}" class="" maxlength="10" style="border: none; float: left; width: 95px; height: 13px; margin: 0px;" value="" tabindex="204"/>
									<img id="imgCaDate" alt="imgDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="205"/>							
								</div>
							</td>
						</tr>		
						<tr>
							<td class="rightAligned">Intm. Name</td>
							<td class="leftAligned">
								<input id="designation" name="designation" type="text" value="${giisIntermediary.designation }" style="width: 140px; float:left;" tabindex="206" maxlength="5">
							</td>
							<td colspan="3">
								<input id="intmName" name="intmName" type="text" value="${giisIntermediary.intmName }" class="required" style="width: 550px; float:left;" tabindex="207" maxlength="240" lastValidValue="${giisIntermediary.intmName }">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Parent Intm No.</td>
							<td class="leftAligned">
								<div id="parentIntmNoDiv" style="width: 145px; height: 20px; border: solid gray 1px; float: left;">
									<input id="parentIntmNo" name="parentIntmNo" type="text" maxlength="12" class="rightAligned integerNoNegativeUnformattedNoComma" ignoreDelKey="1" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="${giisIntermediary.parentIntmNo}" tabindex="208" min="0" max="999999999999" tin=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchParentIntmNoLOV" alt="Go" style="float: right;" tabindex="209"/>							
								</div>
							</td>
							<td colspan="3">
								<input id="parentDesignation" name="parentDesignation" type="text" value="${giisIntermediary.parentDesignation }" readonly="readonly" style="width: 139px; float:left;" tabindex="210" >
								<input id="parentIntmName" name="parentIntmName" type="text" value="${giisIntermediary.parentIntmName }" readonly="readonly" style="width: 397px; margin-left: 5px" tabindex="211" >
							</td>
						</tr>		
						<tr>
							<td class="rightAligned">Contact Person</td>
							<td class="leftAligned" colspan="2">
								<input id="contactPerson" name="contactPerson" type="text" value="${giisIntermediary.contactPerson }" style="width: 310px; " tabindex="212" maxlength="50">
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;">Contact No.</td>
							<td>
								<input id="phoneNo" name="phoneNo" type="text" value="${giisIntermediary.phoneNo }" style="width: 245px; float:left;" tabindex="213" maxlength="40">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Issue Source</td>
							<td class="leftAligned" colspan="2">
								<div id="issCdDiv" class="required" style="width: 65px; height: 20px; border: solid gray 1px; float: left;">
									<input id="issCd" name="issCd" type="text" maxlength="2" class="required allCaps" ignoreDelKey="1" style="border: none; float: left; width: 40px; height: 13px; margin: 0px;" value="${giisIntermediary.issCd}" lastValidValue="${giisIntermediary.issCd}" tabindex="214"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCdLOV" alt="Go" style="float: right;" tabindex="215"/>							
								</div>
								<input id="issName" name="issName" type="text" class="" value="${giisIntermediary.issName }" readonly="readonly" style="width: 239px; float:left; margin: 0 0 0 5px;" tabindex="216" >
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;">Old Intm No.</td>
							<td>
								<input id="oldIntmNo" name="oldIntmNo" type="text" value="${giisIntermediary.oldIntmNo }" class="rightAligned integerNoNegativeUnformattedNoComma" maxlength="12" style="width: 245px; float:left;" tabindex="217" >
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Withholding Tax Code</td>
							<td class="leftAligned" colspan="2">
								<input id="whtaxId" name="whtaxId" type="hidden" value="${giisIntermediary.whtaxId }">
								<div id="whtaxCodeDiv" class="required" style="width: 65px; height: 20px; border: solid gray 1px; float: left;">
									<input type="hidden" id="reqWtaxCode" value="${reqWtaxCode }">
									<input id="whtaxCode" name="whtaxCode" type="text" maxlength="2" class="required rightAligned integerNoNegativeUnformattedNoComma" ignoreDelKey="1" style="border: none; float: left; width: 40px; height: 13px; margin: 0px;" value="${giisIntermediary.whtaxCode}" lastValidValue="${giisIntermediary.whtaxCode}" tabindex="218"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWhtaxCodeLOV" alt="Go" style="float: right;" tabindex="219"/>							
								</div>
								<input id="whtaxDesc" name="whtaxDesc" type="text" value="${giisIntermediary.whtaxDesc }" readonly="readonly" style="width: 239px; float:left; margin: 0 0 0 5px;" tabindex="220" >
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 20px;">Master Intermediary</td>
							<td>
								<input id="masterIntmNo" name="masterIntmNo" type="text" value="${giisIntermediary.masterIntmNo }" class="rightAligned" maxlength="12" readonly="readonly" style="width: 245px; float:left;" tabindex="221" >
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Intermediary Type</td>
							<td class="leftAligned" colspan="2">
								<div id="intmTypeDiv" class="required" style="width: 65px; height: 20px; border: solid gray 1px; float: left;">
									<input id="intmType" name="intmType" type="text" maxlength="2" class="required" ignoreDelKey="1" style="border: none; float: left; width: 40px; height: 13px; margin: 0px;" value="${giisIntermediary.intmType}" lastValidValue="${giisIntermediary.intmType}" tabindex="222"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmTypeLOV" alt="Go" style="float: right;" tabindex="223"/>							
								</div>
								<input id="intmTypeDesc" name="intmTypeDesc" type="text" class="" value="${giisIntermediary.intmTypeDesc }" readonly="readonly" style="width: 239px; float:left; margin: 0 0 0 5px;" tabindex="224" >
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 26px;">T.I.N.</td>
							<td>
								<input id="tin" name="tin" type="text" class="required allCaps" value="${giisIntermediary.tin }" maxlength="20" style="width: 245px; float:left;" tabindex="225" >
							</td>
						</tr>		
						<tr>
							<td class="rightAligned">Co. Intermediary Type</td>
							<td class="leftAligned" colspan="2">
								<div id="coIntmTypeDiv" class="required" style="width: 65px; height: 20px; border: solid gray 1px; float: left;">
									<input id="coIntmType" name="coIntmType" type="text" maxlength="5" class="required" ignoreDelKey="1" style="border: none; float: left; width: 40px; height: 13px; margin: 0px;" value="${giisIntermediary.coIntmType}" lastValidValue="${giisIntermediary.coIntmType}" tabindex="226"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCoIntmTypeLOV" alt="Go" style="float: right;" tabindex="227"/>							
								</div>
								<input id="coIntmTypeName" name="coIntmTypeName" type="text"class=""  value="${giisIntermediary.coIntmTypeName }" readonly="readonly" style="width: 239px; float:left; margin: 0 0 0 5px;" tabindex="228" >
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 15px;">Withholding Tax Rate</td>
							<td>
								<!-- nieko 02092017, SR 23817
									<input id="wtaxRate" name="wtaxRate" type="text" value="${giisIntermediary.wtaxRate }" class="applyDecimalRegExp required" regExpPatt="pDeci0303" style="width: 245px; float:left;" customLabel="Withholding Tax Rate" min="0.000" max="99.999" tabindex="229" >
								 -->
								<input id="wtaxRate" name="wtaxRate" type="text" value="${giisIntermediary.wtaxRate }" class="applyDecimalRegExp" readonly="readonly" regExpPatt="pDeci0303" style="width: 245px; float:left;" customLabel="Withholding Tax Rate" min="0.000" max="99.999" tabindex="229" >
							</td>
						</tr>							
						<tr>
							<td class="rightAligned">Payment Terms</td>
							<td class="leftAligned" colspan="2">
								<div id="paytTermsDiv" class="required" style="width: 65px; height: 20px; border: solid gray 1px; float: left;">
									<input id="paytTerms" name="paytTerms" type="text" class="required" ignoreDelKey="1" maxlength="3" style="border: none; float: left; width: 40px; height: 13px; margin: 0px;" value="${giisIntermediary.paytTerms}" lastValidValue="${giisIntermediary.paytTerms}" tabindex="230"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPaytTermsLOV" alt="Go" style="float: right;" tabindex="231"/>							
								</div>
								<input id="paytTermsDesc" name="paytTermsDesc" type="text" class="" value="${giisIntermediary.paytTermsDesc }" readonly="readonly" style="width: 239px; float:left; margin: 0 0 0 5px;" tabindex="232" >
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 26px;">Birth/Founding Date</td>
							<td>
								<div id="birthdateDiv" class="required" style="width: 250px; height: 21px; border: solid gray 1px; float: left;">
								 	<input id="birthdate" name="birthdate" class="required" readonly="readonly" type="text" value="${giisIntermediary.birthdateChar}" style="border: none; float: left; width: 225px; height: 13px; margin: 0px;" value="" tabindex="233"/>
									<img id="imgBirthdate" alt="imgDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="234"/>							
								</div>
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Mailing Address</td>
							<td class="leftAligned" colspan="2">
								<input id="mailAddr1" name="mailAddr1" type="text" class="required" value="${giisIntermediary.mailAddr1 }" style="width: 310px; " tabindex="235" maxlength="50">
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;">Billing Address</td>
							<td>
								<input id="billAddr1" name="billAddr1" type="text" value="${giisIntermediary.billAddr1 }" style="width: 245px; float:left;" tabindex="238" maxlength="50">
							</td>
						</tr>
						<tr>
							<td class="rightAligned"></td>
							<td class="leftAligned" colspan="2">
								<input id="mailAddr2" name="mailAddr2" type="text" value="${giisIntermediary.mailAddr2 }" style="width: 310px; " tabindex="236" maxlength="50">
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;"></td>
							<td>
								<input id="billAddr2" name="billAddr2" type="text" value="${giisIntermediary.billAddr2 }" style="width: 245px; float:left;" tabindex="239" maxlength="50">
							</td>
						</tr>	
						<tr>
							<td class="rightAligned"></td>
							<td class="leftAligned" colspan="2">
								<input id="mailAddr3" name="mailAddr3" type="text" value="${giisIntermediary.mailAddr3 }" style="width: 310px; " tabindex="237" maxlength="50">
							</td>
							<td class="rightAligned" style="padding: 0 5px 0 46px;"></td>
							<td>
								<input id="billAddr3" name="billAddr3" type="text" value="${giisIntermediary.billAddr3 }" style="width: 245px; float:left;" tabindex="240" maxlength="50">
							</td>
						</tr>			
						<tr>
							<td></td>
							<td colspan="5">
								<div class="sectionDiv" style="width: 99%; height: 95px; margin-left: 5px;">
									<table style="margin: 10px 0 0 8px;">
										<tr>
											<td class="rightAligned" style="">Parent Intm Tin ? (Y/N)</td>
											<td><input id="prntIntmTinSw"  name="prntIntmTinSw" type="text" altName="swInput" class="allCaps required" value="${giisIntermediary.prntIntmTinSw }" lastValidValue="${giisIntermediary.prntIntmTinSw }" style="width: 40px;" maxlength="1" customLabel="Parent Intermediary TIN Switch" validInput="Y/N" tabindex="241"></td>
											<td class="rightAligned" style="padding: 0 0px 0 10px;">Special Rate (Y/N)</td>
											<td><input id="specialRate" name="specialRate" type="text" altName="swInput" class="allCaps required" value="${giisIntermediary.specialRate}" style="width: 40px;" maxlength="1" customLabel="Special Rate" validInput="Y/N" tabindex="242"></td>
											<td class="rightAligned" style="padding: 0 0px 0 10px;">Local/Foreign (L/F)</td> 
											<td><input id="lfTag" name="lfTag" type="text" altName="swInput" class="allCaps" value="${giisIntermediary.lfTag}" style="width: 53px; float: left;" maxlength="1" customLabel="Local Foreign Tag" validInput="L/F" tabindex="243"></td>
											<td class="rightAligned" style="padding: 0 0px 0 10px;">Corporate ? (Y/N)</td>
											<td><input id="corpTag" name="corpTag" type="text" altName="swInput" class="allCaps required" value="${giisIntermediary.corpTag }" lastValidValue="${giisIntermediary.corpTag }" style="width: 40px;" maxlength="1" customLabel="Corporate Tag" validInput="Y/N" tabindex="244"></td>										
										</tr>
										<tr>
											<td class="rightAligned" style="">Active Tag (A/I)</td>
											<td><input id="activeTag" name="activeTag" type="text" altName="swInput" class="allCaps required" value="${giisIntermediary.activeTag}" style="width: 40px;" maxlength="1" customLabel="Active Tag" validInput="A/I" tabindex="245"></td>
											<td class="rightAligned" style="padding: 0 0px 0 10px;">Licensed? (Y/N)</td> 
											<td><input id="licTag" name="licTag" type="text" altName="swInput" class="allCaps required" value="${giisIntermediary.licTag}" style="width: 40px;" maxlength="1" customLabel="Licensed Tag" validInput="Y/N" tabindex="246"></td>
											<td class="rightAligned" style="padding: 0 0px 0 10px;">Input Vat Rate</td> 
											<td><input id="inputVatRate" name="inputVatRate" type="text" class="applyDecimalRegExp required" regExpPatt="pDeci0303" value="<fmt:formatNumber value="${giisIntermediary.inputVatRate}" pattern="##0.000"></fmt:formatNumber>" style="width: 53px;" tabindex="247" customLabel="Input Vat Rate" min="0.00" max="99.999"></td>
											<td colspan="2" style="padding-left: 80px;">
												<img id="btnHistory" title="View History" src="${pageContext.request.contextPath}/images/misc/history.PNG" onmouseover="this.style.cursor='pointer';" tabindex="248">
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="4">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 720px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 687px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="249">${giisIntermediary.remarks }</textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="250"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned" colspan="2"><input id="userId" type="text" class="" value="${giisIntermediary.userId }"style="width: 240px;" readonly="readonly" tabindex="251"></td>
							<td width="" class="rightAligned" style="padding-left: 46px;">Last Update</td>
							<td class="leftAligned"><input id="lastUpdate" type="text" class="" value="${giisIntermediary.lastUpdate }"style="width: 240px;" readonly="readonly" tabindex="252"></td>
							
							<input type="hidden" id="hidNickname" name="hidNickname" value="${giisIntermediary.nickname}"/>	
							<input type="hidden" id="hidEmailAdd" name="hidEmailAdd" value="${giisIntermediary.emailAdd}"/>	
							<input type="hidden" id="hidFaxNo" name="hidFaxNo" value="${giisIntermediary.faxNo}"/>	
							<input type="hidden" id="hidCpNo" name="hidCpNo" value="${giisIntermediary.cpNo}"/>	
							<input type="hidden" id="hidSunNo" name="hidSunNo" value="${giisIntermediary.sunNo}"/>	
							<input type="hidden" id="hidGlobeNo" name="hidGlobeNo" value="${giisIntermediary.globeNo}"/>	
							<input type="hidden" id="hidSmartNo" name="hidSmartNo" value="${giisIntermediary.smartNo}"/>	
							<input type="hidden" id="hidHomeAdd" name="hidHomeAdd" value="${giisIntermediary.homeAdd}"/>	
						</tr>						
					</table>
				</div>
			</form>
			<div class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" class="button" id="btnDelete" name="btnUpdateable" value="Delete" tabindex="253">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCopyIntm" name="btnUpdateable" value="Copy Intermediary" tabindex="254">
	<input type="button" class="button" id="btnAdditionalInfo" name="btnUpdateable" value="Additional Information" tabindex="255">  
	<input type="button" class="button" id="btnMasterIntmDetails" name="btnUpdateable" value="Master Intm Details" tabindex="256">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="257">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="258">
</div>
<script type="text/javascript">	
	setModuleId("GIISS076");
	setDocumentTitle("Intermediary Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	
	var rowIndex = -1;
	
	var ctrlSw1 = 0;
	var ctrlSw2 = 0;		
	var variables = [];
	
	variables.push({defaultTin: null,
					vIntmType: "",
					vWtaxRate: "",
					chgItem: ""
				  	});
	
	objUW.GIISS076.vDefault = null;
	objUW.GIISS076.vDefaultNo = null;
	
	objUW.GIISS076.giisIntm = [];
	objUW.GIISS076.giisIntm.push({nickname: '${giisIntermediary.nickname}',
								 emailAdd: 	'${giisIntermediary.emailAdd}',
								 faxNo: 	'${giisIntermediary.faxNo}',
								 cpNo: 		'${giisIntermediary.cpNo}',
								 sunNo: 	'${giisIntermediary.sunNo}',
								 globeNo: 	'${giisIntermediary.globeNo}',
								 smartNo: 	'${giisIntermediary.smartNo}',
								 homeAdd: 	'${giisIntermediary.homeAdd}'});
	
	if (objUW.GIISS076.giisIntm[0].cpNo == objUW.GIISS076.giisIntm[0].sunNo && objUW.GIISS076.giisIntm[0].sunNo != ""){
		objUW.GIISS076.vDefault = 1;
		objUW.GIISS076.vDefaultNo = objUW.GIISS076.giisIntm[0].sunNo;		
	}else if (objUW.GIISS076.giisIntm[0].cpNo == objUW.GIISS076.giisIntm[0].globeNo && objUW.GIISS076.giisIntm[0].globeNo != ""){
		objUW.GIISS076.vDefault = 2;
		objUW.GIISS076.vDefaultNo = objUW.GIISS076.giisIntm[0].globeNo;		
	}else if (objUW.GIISS076.giisIntm[0].cpNo == objUW.GIISS076.giisIntm[0].smartNo && objUW.GIISS076.giisIntm[0].smartNo != ""){
		objUW.GIISS076.vDefault = 3;
		objUW.GIISS076.vDefaultNo = objUW.GIISS076.giisIntm[0].smartNo;		
	}
	
	$("intmNo").value = $("intmNo").value == "" ? "" : formatNumberDigits($F("intmNo"), 12);
	$("parentIntmNo").value = $("parentIntmNo").value == "" ? "" : formatNumberDigits($F("parentIntmNo"), 12);
	$("parentIntmNo").setAttribute("lastValidValue", $("parentIntmNo").value);
	$("oldIntmNo").value = $("oldIntmNo").value == "" ? "" : formatNumberDigits($F("oldIntmNo"), 12);
	$("masterIntmNo").value = $("masterIntmNo").value == "" ? "" : formatNumberDigits($F("masterIntmNo"), 12);
	$("wtaxRate").value = $("wtaxRate").value == "" ? "" : formatToNthDecimal($F("wtaxRate"), 3);
	//$("whtaxCode").value = $("whtaxCode").value == "" ? "" : formatNumberDigits($F("whtaxCode"), 9);
	
	/*
	**nieko 02092017, SR 23817
	if ($F("reqWtaxCode") == "Y"){
		$("whtaxCodeDiv").addClassName("required");
		$("whtaxCode").addClassName("required");
	}else{
		$("whtaxCodeDiv").removeClassName("required");
		$("whtaxCode").removeClassName("required");		
	}*/
	
	observeReloadForm("reloadForm", function(){
		var addEditSw = null;
		if($F("recordStatus") == "0"){
			addEditSw = "ADD";
		}else{
			addEditSW = "EDIT";
		}
		
		showGiiss076($F("hidIntmNo"), addEditSw);
	});
	
	var objGIISS076 = {};	
	objGIISS076.afterSave = null;
	
	
	function saveGiiss076(){
		if($F("recordStatus") != -1){
			var ok = checkAllRequiredFieldsInDiv('intermediaryFormDiv');
			if(ok){
				if($F("billAddr1") == ""){
					$("billAddr1").value = $F("mailAddr1");
					$("billAddr2").value = $F("mailAddr2");
					$("billAddr3").value = $F("mailAddr3");
				}			
			}else{
				return false;
			}
					
		}
		
		//var addtlInfo = prepareJsonAsParameter(objUW.GIISS076.giisIntm[0]) ;	
		var vars = prepareJsonAsParameter(variables[0]);
		
		new Ajax.Request(contextPath+"/GIISIntermediaryController?action=saveGiiss076&addtlInfo=&variables="+encodeURI(vars),{
			method: "POST",
			postBody: Form.serialize("intermediaryMaintenanceForm"),
			evalScripts: true,
			asynchronous: true,
			onCreate: function(){
				$("intermediaryMaintenanceForm").disable();
				showNotice("Saving, please wait...");					
			},
			onComplete: function(response){
				hideNotice();
				$("intermediaryMaintenanceForm").enable();
				if(checkErrorOnResponse(response)){
					var json = JSON.parse(response.responseText);
					$("intmNo").value = json.intmNo == null || json.intmNo == "" ? "" : formatNumberDigits(json.intmNo, 12);
					$("hidIntmNo").value = $F("intmNo");
					$("recordStatus").value = json.recordStatus;
					
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS076.afterSave != null) {
							objGIISS076.afterSave();
						} else{
							fireEvent($("reloadForm"), "click");
						}
					});
					variables[0].chgItem = "";
					changeTag = 0;
				}
			}
		});
	}
	
	
	function cancelGiiss076(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS076.afterSave = showGiiss203;
						saveGiiss076();
					}, function(){
						showGiiss203();
					}, "");
		} else {
			showGiiss203();
		}
	}
	
	function showParentIntmLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("parentIntmNo").trim() == "" ? "%" : formatNumberDigits($F("parentIntmNo"),12));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS076ParentIntmLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Parent Intermediaries",
				width : 485,
				height : 390,
				columnModel : [  {
					id : "parentTin",
					width : '0px',
					visible: false
				},{
					id : "parentIntmNo",
					title : "Intermediary No.",
					align: 'right',
					width : '118px',
					renderer: function(value){
						return formatNumberDigits(value, 12);
					}
				},{
					id : "parentDesignation",
					title : "Designation",
					width : '100px',
				}, {
					id : "parentIntmName",
					title : "Intermediary Name",
					width : '245px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						if ($F("intmNo") == formatNumberDigits(row.parentIntmNo, 12)){
							showWaitingMessageBox("Parent intermediary no. must not be equal to intermediary no.", "E", function(){
								$("parentIntmNo").value = $("parentIntmNo").readAttribute("lastValidValue");
								$("parentIntmNo").focus();
							});
						}else{
							$("parentDesignation").value = unescapeHTML2(row.parentDesignation);
							$("parentIntmNo").value = formatNumberDigits(row.parentIntmNo, 12);
							$("parentIntmNo").setAttribute("lastValidValue", formatNumberDigits(row.parentIntmNo, 12));
							$("parentIntmName").value = unescapeHTML2(row.parentIntmName);
							variables[0].defaultTin = unescapeHTML2(row.parentTin);
							
							if ($F("prntIntmTinSw") == "Y"){
								$("tin").value = variables[0].defaultTin;
							}
						}			
						changeTag = 1;
					}
				},
				onCancel: function(){
					$("parentIntmNo").focus();
					$("parentIntmNo").value = $("parentIntmNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("parentIntmNo").value = $("parentIntmNo").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "parentIntmNo");
				} 
			});
		}catch(e){
			showErrorMessage("showParentIntmLOV", e);
		}		
	}
	
	function showIssourceLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("issCd").trim() == "" ? "%" : $F("issCd"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss076IssCdLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Issue Codes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Code",
					width : '120px',
				}, {
					id : "issName",
					title : "Issue Source",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("issCd").value = unescapeHTML2(row.issCd);
						$("issCd").setAttribute("lastValidValue", $F("issCd"));
						$("issName").value = unescapeHTML2(row.issName);
						changeTag = 1;
					}
				},
				onCancel: function(){
					$("issCd").focus();
					$("issCd").value = $("issCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("issCd").value = $("issCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "issCd");
				} 
			});
		}catch(e){
			showErrorMessage("showIssourceLOV", e);
		}		
	}
	
	function showWhtaxLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("whtaxCode").trim() == "" ? "%" : $F("whtaxCode"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					//action : "getGIISS076WhtaxLOV", nieko 02092017, SR 23817
					action : "getGIISS076WhtaxLOV2",
					searchString : searchString,
					page : 1
				},
				title : "List of Withholding Tax Codes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "whtaxId",
					width : '0px',
					visible: false
				/* }, { removed by robert 02.10.15 
					id : "gibrBranchCd",
					title : "Issue Code",
					width : '80px', */
				},{
					id : "whtaxCode",
					titleAlign: 'right',
					align: 'right',
					title : "Wtax Cd",
					width : '70px',
				}, {
					id : "whtaxDesc",
					title : "Withholding Tax Description", //modified by robert 02.10.2015
					width : '393px' //modified by robert 02.10.2015
				}, {//nieko 02092017, SR 23817
					id : "percentRate",
					width : '0px',
					visible: false
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("whtaxId").value = row.whtaxId;
						$("whtaxCode").value = row.whtaxCode;
						$("whtaxCode").setAttribute("lastValidValue", row.whtaxCode);
						$("whtaxDesc").value = unescapeHTML2(row.whtaxDesc);
						$("wtaxRate").value = formatToNthDecimal(nvl(row.percentRate,0), 3);; //nieko 02092017, SR 23817
						changeTag = 1;
					}
				},
				onCancel: function(){
					$("whtaxCode").focus();
					$("whtaxCode").value = $("whtaxCode").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("whtaxCode").value = $("whtaxCode").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "whtaxCode");
				} 
			});
		}catch(e){
			showErrorMessage("showWhtaxLOV", e);
		}		
	}
	
	function showIntmTypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("intmType").trim() == "" ? "%" : $F("intmType"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getIntmType3LOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Intermediary Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "intmType",
					title : "Type",
					width : '120px',
				}, {
					id : "intmDesc",
					title : "Description",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("intmType").value = unescapeHTML2(row.intmType);
						$("intmType").setAttribute("lastValidValue", $F("intmType"));
						$("intmTypeDesc").value = unescapeHTML2(row.intmDesc);
						changeTag = 1;
						if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
							variables[0].chgItem = "IT";
						}
					}
				},
				onCancel: function(){
					$("intmType").focus();
					$("intmType").value = $("intmType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("intmType").value = $("intmType").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "intmType");
				} 
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV", e);
		}		
	}
	
	function showCoIntmTypeLOV(isIconClicked){
		try{
			if ($F("issCd") == ""){
				$("coIntmType").clear();
				$("coIntmType").setAttribute("lastValidValue", "");
				showMessageBox("Please enter Issue Source first.", "I");
				return;
			}
			
			var searchString = isIconClicked ? "%" : ($F("coIntmType").trim() == "" ? "%" : $F("coIntmType"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS076CoIntmTypeLOV",
					issCd:	$F("issCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Co. Intermediary Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "coIntmType",
					title : "Type",
					width : '120px',
				}, {
					id : "typeName",
					title : "Type Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("coIntmType").value = unescapeHTML2(row.coIntmType);
						$("coIntmType").setAttribute("lastValidValue", $F("coIntmType"));
						$("coIntmTypeName").value = unescapeHTML2(row.typeName);
						changeTag = 1;
					}
				},
				onCancel: function(){
					$("coIntmType").focus();
					$("coIntmType").value = $("coIntmType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("coIntmType").value = $("coIntmType").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "coIntmType");
				} 
			});
		}catch(e){
			showErrorMessage("showCoIntmTypeLOV", e);
		}		
	}
	
	function showPaytTermsLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("paytTerms").trim() == "" ? "%" : $F("paytTerms"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS076PaytTermsLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Payment Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "paytTerms",
					title : "Payment Term",
					width : '120px',
				}, {
					id : "paytTermsDesc",
					title : "Payment Term Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("paytTerms").value = unescapeHTML2(row.paytTerms);
						$("paytTerms").setAttribute("lastValidValue", $F("paytTerms"));
						$("paytTermsDesc").value = unescapeHTML2(row.paytTermsDesc);
						changeTag = 1;
					}
				},
				onCancel: function(){
					$("paytTerms").focus();
					$("paytTerms").value = $("paytTerms").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("paytTerms").value = $("paytTerms").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "paytTerms");
				} 
			});
		}catch(e){
			showErrorMessage("showPaytTermsLOV", e);
		}		
	}
	
	function validateValidInput(fieldId){
		var valid = $(fieldId).readAttribute("validInput").split("/");
		var validInputs = "";
		var exist = false;
		
		for(var a = 0; a < valid.length; a++){
			if (valid[a] == $F(fieldId)){
				exist = true;
				break;
			}	
		}
		
		for(var a = 0; a < valid.length; a++){
			var or = "";
			if (a > 0) or = " or ";
			validInputs = validInputs + or + "'" + valid[a] + "'";
		}
		
		if (exist == false){
			showWaitingMessageBox("Invalid value for " + $(fieldId).readAttribute("customLabel") + ". Valid value should be " + validInputs + ".", "E", function(){
				$(fieldId).value = $(fieldId).readAttribute("lastValidValue");
				$(fieldId).focus();
			});
		}
	}
	
	$$("input[altName='swInput']").each(function(txt){
		txt.observe("focus", function(){
			this.setAttribute("lastValidValue", this.value);
		});
		
		txt.observe("blur", function(){			
			if (this.value != ""){
				validateValidInput(txt.id);
			}
			
			if(txt.id == "prntIntmTinSw"){
				if(this.value != this.readAttribute("lastValidValue")){
					if (this.value == "Y"){
						if($F("parentIntmNo") == ""){
							this.value = "N";
							showMessageBox("Please enter the Parent Intermediary first.", "I");
							return false;
						}
						
						new Ajax.Request(contextPath+"/GIISIntermediaryController",{
							parameters: {
								action:			"getParentTinGiiss076",
								parentIntmNo:	parseInt($F("parentIntmNo").trim())
							},
							onComplete: function(response){
								if(checkErrorOnResponse(response)){
									$("tin").value = response.responseText;
									variables[0].defaultTin = $F("tin");
								}
							}
						}); 					
						
					}else{
						if($("tin").value == variables[0].defaultTin){
							$("tin").clear();
						}
					}	
				}				
			}else if(txt.id == "specialRate"){
				if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
					variables[0].chgItem = "SR";
				}				
			}else if(txt.id == "corpTag"){
				if(this.value != this.readAttribute("lastValidValue") && (this.value == "Y" || this.value == "N")){
					var paramName = this.value == "Y" ? "CORP_INTM_WTAX" : "INTM_WTAX";
					
					new Ajax.Request(contextPath+"/GIISIntermediaryController", {
						parameters: {
							action:		"getGiacParamValueN",
							paramName:	paramName
						},
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								if ($F("wtaxRate") == ""){
									$("wtaxRate").value = formatToNthDecimal(response.responseText, 3);
								}
								if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
									variables[0].chgItem = "CT";
								}	
							}
						}
					});
				}
			}else if(txt.id == "activeTag"){
				if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
					variables[0].chgItem = "AT";
				}	
			}else if(txt.id == "licTag"){
				if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
					variables[0].chgItem = "LT";
				}	
			}
		});
		
		txt.observe("change", function(){
			fireEvent(txt, "blur");
		});
	});
	
	$$("input[type='text'], div#intermediaryFormDiv textarea").each(function(txt){
		txt.observe("change", function(){
			changeTag = 1;
			changeTagFunc = saveGiiss076;
		});
	});
	
	
	$("imgCaDate").observe("click", function(){
		var prevDate = $F("caDate");
		scwNextAction = function(){
							if(prevDate != $F("caDate")){
								changeTag = 1;
							}							
						}.runsAfterSCW(this, null);
		scwShow($("caDate"),this, null);
	});
	
	$("imgBirthdate").observe("click", function(){
		var prevDate = $F("birthdate");
		scwNextAction = function(){
							if(prevDate != $F("birthdate")){
								changeTag = 1;
							}							
						}.runsAfterSCW(this, null);
		scwShow($("birthdate"),this, null);
	});
	
	
	$("intmName").observe("change", function(){
		if (this.value != "" && this.value != this.readAttribute("")){
			new Ajax.Request(contextPath+"/GIISIntermediaryController",{
				parameters: {
					action:		"valIntmNameGiiss076",
					intmName:	this.value
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == 'Y'){
							showWaitingMessageBox("Record already exists with the same intm_name.", "I", function(){
								$("intmName").clear();
								$("intmName").focus();
							});
						}
					}
				}
			});
		}
	});
	
	$("oldIntmNo").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 12);
		}
	});
	
	$("searchParentIntmNoLOV").observe("click", function(){
		showParentIntmLOV(true);
	});
	
	/*$("parentIntmNo").observe("focus", function(){
		this.value = removeLeadingZero(this.value);	
	});*/
	
	$("parentIntmNo").observe("change", function(){
		if (this.value != ""){
			showParentIntmLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("parentDesignation").clear();
			$("parentIntmName").clear();
		}
	});
	
	$("searchIssCdLOV").observe("click", function(){
		showIssourceLOV(true);
	});
	
	$("issCd").observe("change", function(){
		if (this.value != ""){
			showIssourceLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("issName").clear();
		}
	});
	
	$("searchWhtaxCodeLOV").observe("click", function(){
		showWhtaxLOV(true);
	});
	
	$("whtaxCode").observe("change", function(){
		if (this.value != ""){
			showWhtaxLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("whtaxId").clear();
			$("whtaxDesc").clear();
			$("wtaxRate").clear();
		}
	});
	
	$("searchIntmTypeLOV").observe("click", function(){
		variables[0].vIntmType = $F("intmType");
		showIntmTypeLOV(true);
	});
	
	$("intmType").observe("focus", function(){
		if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
			variables[0].vIntmType = "";
		}else{
			variables[0].vIntmType = this.value;			
		}
	});
	
	$("intmType").observe("change", function(){
		if (this.value != ""){
			showIntmTypeLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("intmTypeDesc").clear();
		}
		if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
			variables[0].chgItem = "IT";
		}
	});
	
	$("searchCoIntmTypeLOV").observe("click", function(){
		showCoIntmTypeLOV(true);
	});
	
	$("coIntmType").observe("change", function(){
		if (this.value != ""){
			showCoIntmTypeLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("coIntmTypeName").clear();
		}
	});
	
	$("searchPaytTermsLOV").observe("click", function(){
		showPaytTermsLOV(true);
	});
	
	$("paytTerms").observe("change", function(){
		if (this.value != ""){
			showPaytTermsLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("paytTermsDesc").clear();
		}
	});
	
	$("tin").observe("change", function(){
		if ($F("prntIntmTinSw") == "Y"){
			if(variables[0].defaultTin != this.value && variables[0].defaultTin != null){
				showConfirmBox("CONFIRMATION", "Changing the T.I.N. will change Parent Intermediary TIN switch to 'N'. Do you want to continue?", "Yes", "No",
						function(){
							$("prntIntmTinSw").value = "N";
						},
						function(){
							$("tin").value = variables[0].defaultTin;
						}
				);
			}
		}
	});
	
	$("wtaxRate").observe("focus", function(){
		if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null)){
			variables[0].vWtaxRate = "";
		}else{
			variables[0].vWtaxRate = this.value;			
		}
	});
	
	$("wtaxRate").observe("change", function(){
		if(changeTag == 1 && ($F("recordStatus") == "" || $F("recordStatus") == null) ){
			variables[0].chgItem = "WR";
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnHistory").observe("click", function(){
		histOverlay = Overlay.show(contextPath+"/GIISIntermediaryController",{
			urlContent: true,
			urlParameters: {
				action: 		"showGiiss076IntmHist",
				intmNo:			$F("intmNo"),
				intmName:		$F("intmName")	
			},
			title: "Intermediary History",
			height: 530,
			width: 707,
			draggable: true
		});
	});
	
	$("btnCopyIntm").observe("click", function(){
		if($F("intmNo") == ""){
			showMessageBox("No available Intermediary", "I");
			return false;
		}
		new Ajax.Request(contextPath+"/GIISIntermediaryController", {
			parameters: {
				action:		"copyIntermediaryGiiss076",
				intmNo:		$F("intmNo")
			},
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					showMessageBox("Copy successful.", "I");
					//$("intmNo").value = formatNumberDigits(response.responseText, 12);
					showGiiss076(response.responseText, "EDIT");
				}
			}
		});
	});
	
	$("btnAdditionalInfo").observe("click", function(){
		aiOverlay = Overlay.show(contextPath+"/GIISIntermediaryController",{
			urlContent: true,
			urlParameters: {
				action: 		"showGiiss076AddtlInfo"
			},
			title: "Additional Information",
			height: 330,
			width: 490,
			draggable: true
		});
	});
	
	$("btnMasterIntmDetails").observe("click", function(){
		miOverlay = Overlay.show(contextPath+"/GIISIntermediaryController",{
			urlContent: true,
			urlParameters: {
				action: 		"showGiiss076MasterIntmDetails",
				masterIntmNo:	$F("masterIntmNo")
			},
			title: "Master Intermediary Details",
			height: 500,
			width: 540,
			draggable: true
		});
	});
	
	$("btnDelete").observe("click", function(){
		new Ajax.Request(contextPath+"/GIISIntermediaryController",{
			parameters: {
				action:		"valDeleteRecGiiss076",
				intmNo:		$F("intmNo")
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					$$("div#intermediaryFormDiv input[type='text'], div#intermediaryFormDiv textarea").each(function(txt){
						txt.clear();
						txt.readOnly = true;
					});
					
					$$("img[alt='Go']").each(function(img){
						disableSearch(img.id);	
					});	
					
					$$("img[alt='imgDate']").each(function(img){
						disableDate(img.id);	
					});	
					
					disableButton("btnDelete");
										
					objUW.GIISS076.giisIntm[0].nickname = null;
					objUW.GIISS076.giisIntm[0].emailAdd = null;
					objUW.GIISS076.giisIntm[0].faxNo = null;
					objUW.GIISS076.giisIntm[0].cpNo = null;
					objUW.GIISS076.giisIntm[0].sunNo = null;
					objUW.GIISS076.giisIntm[0].globeNo = null;
					objUW.GIISS076.giisIntm[0].smartNo = null;
					objUW.GIISS076.giisIntm[0].homeAdd = null;
					
					variables[0].defaultTin = null;
					variables[0].vIntmType = "";
					variables[0].vWtaxRate = null;
					variables[0].chgItem = "";
					
					$("recordStatus").value = -1;
					
					changeTag = 1;
				}
			}
		});
	});
	
	observeSaveForm("btnSave", saveGiiss076);
	
	$("btnCancel").observe("click", cancelGiiss076);
	
	
	$("intermediaryExit").stopObserving("click");
	$("intermediaryExit").observe("click", function(){
		cancelGiiss076();
	});
	
	
	
	$("refIntmCd").focus();
	
	initializeChangeTagBehavior(saveGiiss076);
</script>
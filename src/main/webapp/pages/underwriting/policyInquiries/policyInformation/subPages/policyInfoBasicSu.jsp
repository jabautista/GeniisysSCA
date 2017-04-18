<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="policyInfoBasicMainDiv" style="margin:0 auto 0 auto;">
	<c:if test="${moduleId eq 'GIPIS100' }"> <!-- added by Kris 02.20.2013: choose if GIPIS100 or GIPIS101 -->
	<table style="margin:20px auto 0 125px;">
		<tr id="trRow1">
			<td id="tdRow1Column1" class="rightAligned" style="width:87px;">Bond Status</td>
			<td id="tdRow1Column2" colspan="3">
				<input type="text" id="txtPolFlag" name="txtPolFlag" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow1Column5" class="rightAligned" style="width:100px;">Bond Type</td>
			<td id="tdRow1Column6" colspan="3">
				<input type="text" id="txtSublineCd2" name="txtSublineCd2" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow2">
			<td id="tdRow2Column1" class="rightAligned">Issue Date</td>
			<td id="tdRow2Column2" colspan="3">
				<input type="text" id="txtIssueDate2" name="txtIssueDate2" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow2Column5" class="rightAligned">Ref Bonds No.</td>
			<td id="tdRow2Column6" colspan="3">
				<input type="text" id="txtRefPolNo2" name="txtRefPolNo2" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow3">
			<td id="tdRow3Column1" class="rightAligned">Inception Date</td>
			<td id="tdRow3Column2" style="width:150px;">
				<input type="text" id="txtInceptDate" name="txtInceptDate" style="width:95%;" readonly="readonly"/>
			</td>
			<td id="tdRow3Column3" style="width:10px;">
				<input type="checkBox" id="chkInceptTag" name="chkInceptTag" value="Y" disabled="disabled"/>
			</td>
			<td id="tdRow3Column4" style="width:10px;">TBA</td>
			<td id="tdRow3Column5" class="rightAligned">Expiry Date</td>
			<td id="tdRow3Column6" style="width:150px;">
				<input type="text" id="txtExpiryDate" name="txtExpiryDate" style="width:95%;" readonly="readonly"/>
			</td>
			<td id="tdRow3Column7" style="width:10px;">
				<input type="checkBox" id="chkExpiryTag" name="chkExpiryTag" style="width:10px;" value="Y" disabled="disabled"/>
			</td>
			<td id="tdRow3Column8" style="width:10px;">TBA</td>
		</tr>
		<tr id="trRow4">
			<td id="tdRow4Column1" class="rightAligned">Effectivity Date</td>
			<td id="tdRow4Column2" colspan="3">
				<input type="text" id="txtEffectivityDate" name="txtEffectivityDate" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow4Column5" class="rightAligned">Industry</td>
			<td id="tdRow4Column6" colspan="3">
				<input type="text" id="txtDspIndustry" name="txtDspIndustry" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow5">
			<td id="tdRow5Column1" class="rightAligned">Address</td>
			<td id="tdRow5Column2" colspan="3">
				<input type="text" id="txtAddress1" name="txtAddress1" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow5Column5" class="rightAligned">Region</td>
			<td id="tdRow5Column6" colspan="3">
				<input type="text" id="txtDspRegion" name="txtDspRegion" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow6">
			<td id="tdRow6Column1"></td>
			<td id="tdRow6Column2" colspan="3">
				<input type="text" id="txtAddress2" name="txtAddress2" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow6Column5" class="rightAligned"></td>
			<td id="tdRow6Column6" colspan="3">
				<input type="text" id="txtEndtExpiryDate" name="txtEndtExpiryDate" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow7">
			<td id="tdRow7Column1"></td>
			<td id="tdRow7Column2" colspan="3">
				<input type="text" id="txtAddress3" name="txtAddress3" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow7Column5" colspan="4" rowspan="4">
				<div id="vitalityDiv" style="width:290px;margin-left:auto;margin-right:0;">
					<label>Validity Period:</label><br/>
					<div style="width:290px;border:1px solid grey;margin-top:3px;">
						<table>
							<tr>
								<td>No.</td>
								<td style="width:60px;">
									<input type="text" id="txtValPeriod" name="txtValPeriod"  style="width:90%;" readonly="readonly">
								</td>
								<td><input type="radio" id="rdoDays" name="rdoDays" value="D" disabled="disabled"/></td>
								<td>Days</td>
								<td><input type="radio" id="rdoMonths" name="rdoMonths" value="M" disabled="disabled"/></td>
								<td>Months</td>
								<td><input type="radio" id="rdoYears" name="rdoYears" value="Y" disabled="disabled"/></td>
								<td>Years</td>
							</tr>
						</table>
					</div>
				</div>
					
					<div style="margin:10px 0px 1px auto;width:285px;float:right;">
						<table>
							<tr>
								<td>
									<input type="checkbox" id="chkAutoRenewalFlag" name="chkAutoRenewalFlag" value="Y" disabled="disabled"/>
								</td>
								<td>Continuing Bond</td>
								<td width="10px">
									<input type="checkbox" id="chkRegPolicySw" name="chkRegPolicySw" value="Y" disabled="disabled"/>
								</td>
								<td>
									Regular Policy
								</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chkBancassuranceSw" name="chkBancassuranceSw" value="Y" disabled="disabled"/>
								</td>
								<td>Bancassurance</td>
								<td colspan="2">
									<input type="button" id="bancAssuranceDtl" name="bancAssuranceDtl" value="Bancassurance Details" class="button" style="width:100%" readonly="readonly"/>
								</td>
							</tr>
							
							<tr>
								<td></td>
								<td></td>
								<td colspan="2">
									<input type="button" id="bankPaymentDtl" name="bankPaymentDtl" value="Bank Payment Details" class="button" style="width:100%" readonly="readonly"/>
								</td>
							</tr>
						</table>
					</div>
				
			</td>
		</tr>
		<tr id="trRow8">
			<td id="tdRow8Column1" class="rightAligned">Mortgagee</td>
			<td id="tdRow8Column2" colspan="3">
				<input type="text" id="txtMortgName" name="txtMortgName" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow9">
			<td id="tdRow9Column1" class="rightAligned">Booking Date</td>
			<td id="tdRow9Column2" colspan="3">
				<input type="text" id="txtBookingYear" name="txtBookingYear" style="width:24%;" readonly="readonly"/>
				<input type="text" id="txtBookingMth" name="txtBookingMth" style="width:65%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow10">
			<td id="tdRow10Column1" class="rightAligned">Take-up Term</td>
			<td id="tdRow10Column2" colspan="3">
				<input type="text" id="txtTakeupTermDesc" name="txtTakeupTermDesc" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
	</table>
	
	<div style="width:700px;margin:30px auto 10px 125px;">
		<table width="700px">
			<tr>
				<td>General Information</td>
				<td id="tdPromptText"></td>
			</tr>
			<tr>
				<td  style="width:50%">
				<!--edited hdrtagudin 07222015 SR 4794 // edited gab 08.19.2015-->
				 <textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 90%; height: 60px; float: left; resize: none;" id="txtGenInfo" name="txtGenInfo" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditItemDesc" id="textGen" class="hover" />
				</td>
				<td>
				<!--edited hdrtagudin 07222015 SR 4794 // edited gab 08.19.2015-->
				<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 90%; height: 60px; float: left; resize: none;" id="txtDspEndtText" name="txtDspEndtText" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditItemDesc" id="textEndt" class="hover" />
				
				</td>
			</tr>
		</table>
	</div>
	</c:if>
	
	<c:if test="${moduleId eq 'GIPIS101' }">
	<table style="margin:20px auto 0 125px;" border="0" align="center" width="700px">
		<tr id="trRow1">
			<td id="tdRow1Column1" class="rightAligned" style="width:87px;">Bond Status</td>
			<td id="tdRow1Column2" colspan="3">
				<input type="text" id="txtPolFlag" name="txtPolFlag" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow1Column5" class="rightAligned" style="width:100px;">Bond Type</td>
			<td id="tdRow1Column6" colspan="3">
				<input type="text" id="txtSublineCd2" name="txtSublineCd2" style="width:96%;" readonly="readonly" value="" />
			</td>
		</tr>
		<tr id="trRow2">
			<td id="tdRow2Column1" class="rightAligned">Issue Date</td>
			<td id="tdRow2Column2" colspan="3">
				<input type="text" id="txtIssueDate2" name="txtIssueDate2" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow2Column5" class="rightAligned">Effectivity Date</td>
			<td id="tdRow2Column6" colspan="3">
				<input type="text" id="txtInceptDate" name="txtInceptDate" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow3">
			<td id="tdRow3Column1" class="rightAligned">Address</td>
			<td id="tdRow3Column2" colspan="3">
				<input type="text" id="txtAddress1" name="txtAddress1" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow3Column5" class="rightAligned">Expiry Date</td>
			<td id="tdRow3Column6" style="width:150px;">
				<input type="text" id="txtExpiryDate" name="txtExpiryDate" style="width:95%;" readonly="readonly"/>
			</td>			
		</tr>
		<tr id="trRow4">
			<td id="tdRow4Column1"></td>
			<td id="tdRow4Column2" colspan="3">
				<input type="text" id="txtAddress2" name="txtAddress2" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow4Column5" class="rightAligned">Industry</td>
			<td id="tdRow4Column6" colspan="3">
				<input type="text" id="txtDspIndustry" name="txtDspIndustry" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow5">
			<td id="tdRow5Column1"></td>
			<td id="tdRow5Column2" colspan="3">
				<input type="text" id="txtAddress3" name="txtAddress3" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow5Column5" class="rightAligned">Region</td>
			<td id="tdRow5Column6" colspan="3">
				<input type="text" id="txtDspRegion" name="txtDspRegion" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="trRow6">
			<td id="tdRow6Column1" class="rightAligned">Ref Bonds No.</td>
			<td id="tdRow6Column2" colspan="3">
				<input type="text" id="txtRefPolNo2" name="txtRefPolNo2" style="width:96%;" readonly="readonly"/>
			</td>
			<td id="tdRow7Column5" colspan="4" rowspan="4" >
				<div id="vitalityDiv" style="width:290px;margin-left: 10px;margin-right:0;">
					<label>Validity Period:</label><br/>
					<div style="width:290px;border:1px solid grey;margin-top:3px;">
						<table>
							<tr>
								<td>No.</td>
								<td style="width:60px;">
									<input type="text" id="txtValPeriod" name="txtValPeriod"  style="width:90%;" readonly="readonly">
								</td>
								<td><input type="radio" id="rdoDays" name="rdoDays" value="D" disabled="disabled" checked="checked"/></td>
								<td>Days</td>
								<td><input type="radio" id="rdoMonths" name="rdoMonths" value="M" disabled="disabled"/></td>
								<td>Months</td>
								<td><input type="radio" id="rdoYears" name="rdoYears" value="Y" disabled="disabled"/></td>
								<td>Years</td>
							</tr>
						</table>
					</div>
				</div>
					
					<div style="margin:10px 0px 1px auto;width:285px;float:right;">
						<table>
							<tr>
								<td>
									<input type="checkbox" id="chkAutoRenewalFlag" name="chkAutoRenewalFlag" value="Y" disabled="disabled"/>
								</td>
								<td>Continuing Bond</td>
								<td width="10px">
									<input type="checkbox" id="chkRegPolicySw" name="chkRegPolicySw" value="Y" disabled="disabled"/>
								</td>
								<td>
									Regular Policy
								</td>
							</tr>							
						</table>
					</div>			
			</td>
		</tr>
		<tr id="trRow7">
			<td id="tdRow7Column1" class="rightAligned">Mortgagee</td>
			<td id="tdRow7Column2" colspan="3">
				<input type="text" id="txtMortgName" name="txtMortgName" style="width:96%;" readonly="readonly"/>
			</td>
		</tr>
		
		<tr id="trRow8" height="35px">
			<td rowspan="2"></td>
		</tr>		
	</table>
	</c:if>
	
	<div style="margin:0 auto 20px auto;" align="center">
		<input id="bondPolicyBtn" name="bondPolicyBtn" type="button" class="button" value="Bond Policy Data" readonly="readonly"/>
	</div>
	<div id="bondPolicyData" name="bondPolicyData" style="border: none;"></div>
</div>

<script>
	var moduleId = '${moduleId}'; // added by Kris 02.20.2013
	setModuleId(moduleId);
	
	try{
		var policyBasicInfoSu = JSON.parse('${policyBasicInfoSu}'.replace(/\\/g, '\\\\'));
	}catch (e){
		showErrorMessage("policyBasicInfoSu", e);
	}
	
	/*var txtIssueDate2 = Date.parse(policyBasicInfoSu.issueDate);
	var txtInceptDate = Date.parse(policyBasicInfoSu.inceptDate);
	var txtExpiryDate = Date.parse(policyBasicInfoSu.expiryDate);*/
	
	//$("txtPolFlag").value			= policyBasicInfoSu.polFlag;
	$("txtPolFlag").value			= policyBasicInfoSu.polFlagDesc;
	$("txtSublineCd2").value		= policyBasicInfoSu.sublineCd;
	$("txtIssueDate2").value		= dateFormat(policyBasicInfoSu.issueDate, 'mm-dd-yyyy'); 
	$("txtRefPolNo2").value    		= unescapeHTML2(policyBasicInfoSu.refPolNo);
	$("txtInceptDate").value		= dateFormat(policyBasicInfoSu.inceptDate, 'mm-dd-yyyy');
	$("txtExpiryDate").value		= dateFormat(policyBasicInfoSu.expiryDate, 'mm-dd-yyyy'); //txtExpiryDate.format("mm-dd-yyyy");
	$("txtDspIndustry").value		= moduleId == "GIPIS101" ? unescapeHTML2(policyBasicInfoSu.dspIndustryNm) : unescapeHTML2(policyBasicInfoSu.industryNm);
	$("txtAddress1").value			= unescapeHTML2(policyBasicInfoSu.address1);
	$("txtDspRegion").value			= unescapeHTML2(policyBasicInfoSu.regionDesc);
	$("txtAddress2").value			= unescapeHTML2(policyBasicInfoSu.address2);
	$("txtAddress3").value			= unescapeHTML2(policyBasicInfoSu.address3);
	$("txtMortgName").value			= unescapeHTML2(policyBasicInfoSu.mortgName);
	
	//vitality period
	$("txtValPeriod").value	= policyBasicInfoSu.valPeriod;
	if ($("rdoDays").value == policyBasicInfoSu.valPeriodUnit){
		$("rdoDays").checked = true;
	}
	else if ($("rdoMonths").value == policyBasicInfoSu.valPeriodUnit){
		$("rdoMonths").checked = true;
	}else if ($("rdoYears").value == policyBasicInfoSu.valPeriodUnit){
		$("rdoYears").checked = true;
	}
	//others
	if ($("chkAutoRenewalFlag").value == policyBasicInfoSu.autoRenewFlag){
		$("chkAutoRenewalFlag").checked = true;
	}
	if ($("chkRegPolicySw").value == policyBasicInfoSu.regPolicySw){
		$("chkRegPolicySw").checked = true;
	}
	
	
	// for GIPIS100
	if(moduleId != "GIPIS101"){
		$("txtDspEndtText").hide();
		$("txtEndtExpiryDate").hide();	
		$("txtEffectivityDate").value	= policyBasicInfoSu.effDate;
		$("txtEndtExpiryDate").value	= policyBasicInfoSu.endtExpiryDate;
		//troRow9
		$("txtBookingYear").value		= policyBasicInfoSu.bookingYear;
		$("txtBookingMth").value		= policyBasicInfoSu.bookingMth;
		//trRow10
		$("txtTakeupTermDesc").value	= policyBasicInfoSu.takeupTermDesc;
		//information
		$("txtGenInfo").value			= unescapeHTML2(nvl(policyBasicInfoSu.genInfo01,"")+	//hdrtagudin 07222015 SR 4794
										  nvl(policyBasicInfoSu.genInfo02,"")+
										  nvl(policyBasicInfoSu.genInfo03,"")+
										  nvl(policyBasicInfoSu.genInfo04,"")+
										  nvl(policyBasicInfoSu.genInfo05,"")+
										  nvl(policyBasicInfoSu.genInfo06,"")+
										  nvl(policyBasicInfoSu.genInfo07,"")+
										  nvl(policyBasicInfoSu.genInfo08,"")+
										  nvl(policyBasicInfoSu.genInfo09,"")+
										  nvl(policyBasicInfoSu.genInfo10,"")+
										  nvl(policyBasicInfoSu.genInfo11,"")+
										  nvl(policyBasicInfoSu.genInfo12,"")+
										  nvl(policyBasicInfoSu.genInfo13,"")+
										  nvl(policyBasicInfoSu.genInfo14,"")+
										  nvl(policyBasicInfoSu.genInfo15,"")+
										  nvl(policyBasicInfoSu.genInfo16,"")+
										  nvl(policyBasicInfoSu.genInfo17,""));			//hdrtagudin 07222015 SR 4794
		$("txtDspEndtText").value		= unescapeHTML2(nvl(policyBasicInfoSu.endtText01,"")+	//hdrtagudin 07222015 SR 4794
										  nvl(policyBasicInfoSu.endtText02,"")+
										  nvl(policyBasicInfoSu.endtText03,"")+
										  nvl(policyBasicInfoSu.endtText04,"")+
										  nvl(policyBasicInfoSu.endtText05,"")+
										  nvl(policyBasicInfoSu.endtText06,"")+
										  nvl(policyBasicInfoSu.endtText07,"")+
										  nvl(policyBasicInfoSu.endtText08,"")+
										  nvl(policyBasicInfoSu.endtText09,"")+
										  nvl(policyBasicInfoSu.endtText10,"")+
										  nvl(policyBasicInfoSu.endtText11,"")+
										  nvl(policyBasicInfoSu.endtText12,"")+
										  nvl(policyBasicInfoSu.endtText13,"")+
										  nvl(policyBasicInfoSu.endtText14,"")+
										  nvl(policyBasicInfoSu.endtText15,"")+
										  nvl(policyBasicInfoSu.endtText16,"")+
										  nvl(policyBasicInfoSu.endtText17,""));	//hdrtagudin 07222015 SR 4794
		
		//START hdrtagudin 07222015 SR 4794 // edited by gab 08.19.2015
		$("textGen").observe("click", function () {
			showEditor5("txtGenInfo", 2000, 'true');
		});
		
		$("textEndt").observe("click", function () {
			showEditor5("txtDspEndtText", 2000, 'true');
		});
		//END hdrtagudin 07222015 SR 4794 // edited by gab 08.19.2015
		
		$("tdRow6Column5").innerHTML = policyBasicInfoSu.dspEndtExpiryDate;
		$("tdPromptText").innerHTML = policyBasicInfoSu.promptText;

		if ($("chkBancassuranceSw").value == policyBasicInfoSu.bancassuranceSsw){
			$("chkBancassuranceSw").checked = true;
		}
		if ($("chkInceptTag").value	== policyBasicInfoSu.inceptTag){
			$("chkInceptTag").checked = true;
		}
		if ($("chkExpiryTag").value 	== policyBasicInfoSu.expiryTag){
			$("chkExpiryTag").checked 	= true;
		}
		if(policyBasicInfoSu.endtSeqNo == 0){
			$("txtDspEndtText").hide();
			$("textEndt").hide();	//hdrtagudin 07222015 SR 4794
			$("txtEndtExpiryDate").hide();
		}else{
			$("txtDspEndtText").show();
			$("textEndt").show();	//hdrtagudin 07222015 SR 4794
			$("txtEndtExpiryDate").show();
		}
		if(policyBasicInfoSu.bancassuranceSsw == 'Y'){
			$("bancAssuranceDtl").enable();
		}
		else{		
			$("bancAssuranceDtl").disable();
			$("bancAssuranceDtl").writeAttribute("class","disabledButton");
		}
		$("bancAssuranceDtl").observe("click", function(){
			overlayBancassuranceDtl = Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {
					action 	 : "getBancassuranceDtl",
					policyId : policyBasicInfoSu.policyId},
				title: "Bancassurance Details",
				width: 605,
				height: 150,
				draggable: true,
				showNotice: true
			  });
			
		});
		$("bankPaymentDtl").observe("click",function(){ //Rey 08.16.2011 bank payment SU
			overlayBankPaymentDtl = Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {
					action 	 : "getBankPaymentDtl",
					policyId : policyBasicInfoSu.policyId},
				title: "Bank Payment Details",
				width: 630, //605
				height: 150, //120
				draggable: true,
				showNotice: true
			  });
		});
	} // end: if moduleId == GIPIS100
	
	
	
	$("bondPolicyBtn").observe("click", function(){  //Rey 08.16.2011 bond policy data
		if(moduleId != "GIPIS101") { // modified by Kris 02.21.2013: added if condition for GIPIS101
			new Ajax.Updater("bondPolicyData","GIPIPolbasicController?action=bondPolicyData",{
				method: "get",
				evalScripts: true,
				parameters: {
					policyId: policyBasicInfoSu.policyId	
				}
			});
		} else {
			new Ajax.Updater("bondPolicyData","GIXXBondBasicController?action=getGIXXBondBasic",{
				method: "get",
				evalScripts: true,
				parameters: {
					extractId: policyBasicInfoSu.extractId,
					policyId: policyBasicInfoSu.policyId	
				}
			});
		}
		
		$("bondPolicyBtn").hide();
	});
	
	/**/
</script>
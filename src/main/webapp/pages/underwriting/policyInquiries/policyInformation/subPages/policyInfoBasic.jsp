<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="policyInfoBasicMainDiv" style="height:700px;margin-top:10px;">
	<input type="hidden" id="hidGroupedItemsPolicyId"/>
	<input type="hidden" id="hidGroupedItemsExtractId"/> <!-- added by Kris 02.28.2013 -->
	<input type="hidden" id="hidGroupedItemsItemNo"/>
	<input type="hidden" id="hidGroupedItemsGroupedItemNo"/>
	
	<input type="hidden" id="hidAnnTsiAmt" name="hidAnnTsiAmt"/>
	<input type="hidden" id="hidAnnPremAmt" name="hidAnnPremAmt"/>
	<input type="hidden" id="hidDefaultCurrency" name="hidDefaultCurrency"/>
	
	<form>
		<c:if test="${moduleId ne 'GIPIS101' }">
		<table>
			<tr id="trRow1">
				<td id="tdRow1column1" class="rightAligned">Address</td>
				<td colspan="5" id="tdRow1column2">
					<input type="text" id="txtAddress1" name="txtAddress1" style="width:98.5%" readonly="readonly"/>
				</td>
				<td rowspan="14" id="tdRow1column7" style="width:100px;">
					<div style="border:1px solid rgb(224,224,224)">
												
						<div style="border:1px solid rgb(224,224,224);">
							<table>
								<tr>
									<td colspan="4" style="border:1px solid rgb(224,224,224);">
										<label style="padding:2px;width:100%;text-align:center;font-weight:bold;" title="Type">Type</label>
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkPackPolFlag" name="chkPackPolFlag" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										Package Plan
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkAutoRenewFlag" name="chkAutoRenewFlag" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										Auto Renewal
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkForeignAccSw" name="chkForeignAccSw" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										Foreign Acct
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkRegPolicySw" name="chkRegPolicySw" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										Regular Policy
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkPremWarrTag" name="chkPremWarrTag" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										W/ Prem Warranty
									</td>
								</tr>
								<tr>
									<td colspan="4"><input type="text" id="txtPremWarrDays" name="txtPremWarrDays" readonly="readonly"/></td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkFleetPrintTag" name="chkFleetPrintTag" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										Fleet Tag									
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkWithTariffSw" name="chkWithTariffSw" value="Y" disabled="disabled"/>
									</td>
									<td colspan="3">
										W/ Tariff
									</td>
								</tr>
								<tr>
									<td colspan="4" style="border:1px solid rgb(224,224,224);">
										<label style="padding:2px;width:100%;text-align:center;font-weight:bold;" title="Type">Co-Insurer</label>
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoNonCo" name="rdoNonCo" value="1" disabled="disabled"/>
									</td>
									<td colspan="3">
										Non-Co-Insurance
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoLead" name="rdoLead" value="2" disabled="disabled"/>
									</td>
									<td colspan="3">
										Lead Policy
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoNonLead" name="rdoNonLead" value="3" disabled="disabled"/>
									</td>
									<td colspan="3">
										Non-Lead Policy
									</td>
								</tr>
								
								<tr>
									<td colspan="4"  style="border:1px solid rgb(224,224,224);">
										<label style="padding:2px;width:100%;text-align:center;font-weight:bold;title:Condition;">Condition</label>
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoProRate" name="rdoProRate" value="1" disabled="disabled"/>
									</td>
									<td>
										Pro-Rate
									</td>
									<td>
										<input type="radio" id="rdoAdd" name="rdoAdd" value="Y" disabled="disabled"/>
									</td>
									<td>
										+1 day
									</td>
								</tr>
								<tr>
									<td></td>
									<td><input type="text" id="txtProRateDays" name="txtProRateDays" style="width:60%" readonly="readonly"/></td>
									<td>
										<input type="radio" id="rdoMinus" name="rdoMinus" value="M" disabled="disabled"/>
									</td>
									<td>
										-1 day
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoStraight" name="rdoStraight" value="2" disabled="disabled"/>
									</td>
									<td>
										Straight
									</td>
									<td>	
										<input type="radio" id="rdoOrdinary" name="rdoOrdinary" value="N" disabled="disabled"/>
									</td>
									<td class="leftAligned">
										ordinary
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" id="rdoShortRt" name="rdoShortRt" value="3" disabled="disabled"/>
									</td>
									<td colspan="2" class="leftAligned">
										Short Rate
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="4">
										<input type="text" id="txtShorRtPercent" name="txtShorRtPercent" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<td>
										<input type="checkbox" id="chkProvePremTag" name="chkProvePremTag" disabled="disabled"/>
									</td>
									<td colspan="3">
										Prov. Premium
									</td>
								</tr>
								<tr>
									<td colspan="4">
										<input type="text" id="txtProvPremPct" name="txtProvPremPct" readonly="readonly"/><br/>
									</td>
								</tr>
							</table>
						</div>
					</div>
			</tr>
				
			<tr id="trRow2">
				<td id="tdRow2Column1" class="rightAligned"></td>
				<td colspan="5" id="tdRow2Column2">
					<input type="text" id="txtAddress2" name="txtAddress2" style="width:98.5%" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow3">
				<td id="trRow3Column1" class="rightAligned"></td>
				<td colspan="5" id="trRow3Column2">
					<input type="text" id="txtAddress3" name="txtAddress3" style="width:98.5%" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow4">
				<td id="tdRow4Column1" class="rightAligned">Industry</td>
				<td id="tdRow4Column2" style="width:250px">
					<input type="text" id="txtNbtIndDesc" name="txtNbtIndDesc" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow4Column3" class="rightAligned" style="width:120px;">Ref. Policy No.</td>
				<td colspan="3" id="tdRow4Column4" style="width:250px">
					<input type="text" id="txtRefPolNo2" name="txtRefPolNo2" style="width:97%" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow5">
				<td id="tdRow5Column1" class="rightAligned">Region</td>
				<td id="tdRow5Column2">
					<input type="text" id="txtNbtRegionDesc" name="txtNbtRegionDesc" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow5Column3" class="rightAligned">Type of Policy</td>
				<td colspan="3" id="tdRow5Column4">
					<input type="text" id="txtDspPolicyType" name="txtDspPolicyType" style="width:97%" readonly="readonly"/>
				</td>
				
			</tr>
				
			<tr id="trRow6">
				<td id="tdRow6Column1" class="rightAligned">Crediting Branch</td>
				<td id="tdRow6Column2">
					<input type="text" id="txtDspCredBranch" name="txtDspCredBranch" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow6Column3" class="rightAligned">Manual Renew No.</td>
				<td colspan="3" id="tdRow6Column4">
					<input type="text" id="txtManualRenewNo" name="txtManualRenewNo" style="width:50%;" readonly="readonly"/>
					<input type="checkbox" id="chkSurchrgeSw" name="chkSurchrgeSw" disabled="disabled"/>
					w/ Surcharge
				</td>
				
			</tr>
				
			<tr id="trRow7">
				<td id="tdRow7Column1" class="rightAligned">Booking Date</td>
				<td id="tdRow7Column2">
					<input type="text" id="txtBookingYear" name="txtBookingYear" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtBookingMonth" name="txtBookingMonth" style="width:70%;" readonly="readonly"/>
				</td>
				<td id="tdRow7Column3" class="rightAligned">Actual Renew No.</td>
				<td colspan="3" id="tdRow7Column4">
					<input type="text" id="txtActualRenewNo" name="txtActualRenewNo" style="width:50%;" readonly="readonly"/>
					<input type="checkbox" id="chkDiscountSw" name="chkDiscountSw" disabled="disabled"/>
					w/ Discount
				</td>
				
			</tr>
			
			<tr id="trRow8">
				<td id="tdRow8Column1" class="rightAligned">Take-up Term</td>
				<td id="tdRow8Column2">
					<input type="text" id="txtTakeUpTermDesc" name="txtTakeUpTermDesc"style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow8Column3" class="rightAligned">U/W Year</td>
				<td colspan="3" id="tdRow8Column3">
					<input type="text" id="txtIssueYy2" name="txtIssueYy2" style="width:50%;" readonly="readonly"/>
					<input id="btnMortgageeInfo" class="button" type="button" value="Mortgagee Info" name="btnMortgageeInfo" style="width:45%"/>
				</td>
				
			</tr>
				
			<tr id="trRow9">
				<td id="tdRow9Column1" class="rightAligned">Incept Date</td>
				<td id="tdRow9Column2">
					<input type="text" id="txtInceptDate" name="txtInceptDate" style="width:88%" readonly="readonly"/>
					<input type="checkbox" id="chkInceptTag" name="chkInceptTag" value="Y" style="width:10px" disabled="disabled"/>
				</td>
				<td id="tdRow9Column3" class="rightAligned">Premium</td>
				<td colspan="3" id="tdRow9Column4">
					<input type="text" id="txtPhpPrem" name="txtPhpPrem" value="PHP" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtPremAmt" name="txtPremAmt" style="width:70%; text-align: right;" readonly="readonly"/>
				</td>
			</tr>
			
			<tr id="trRow10">
				<td id="tdRow10Column1" class="rightAligned">Expiry Date</td>
				<td id="tdRow10Column2">
					<input type="text" id="txtExpiryDate" name="txtExpiryDate" style="width:88%" readonly="readonly"/>
					<input type="checkbox" id="chkExpiryTag" name="chkExpiryTag" style="width:10px" disabled="disabled"/>
				</td>
				<td id="tdRow10Column3" class="rightAligned">TSI</td>
				<td colspan="3" id="tdRow10Column4">
					<input type="text" id="txtPhpTsi" name="txtPhpTsi" value="PHP" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtTsiAmt" name="txtTsiAmt" style="width:70%; text-align: right;" readonly="readonly"/>
				</td>
			</tr>
			
			<tr id="trRow11">
				<td id="tdRow11Column1" class="rightAligned">Issue Date</td>
				<td id="tdRow11Column2">
					<input type="text" id="txtIssueDate2" name="txtIssueDate2" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow11Column3" class="rightAligned">Risk Tag</td>
				<td colspan="3" id="tdRow11Column4">
					<input type="text" id="txtRiskTag" name="txtRiskTag" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtDspRiskDesc" name="txtDspRiskDesc" style="width:70%;" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow12">
				<td id="tdRow12Column1" class="rightAligned">Effectivity Date</td>
				<td id="tdRow12Column2">
					<input type="text" id="txtEffDate" name="txtEffDate" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow12Column3" class="rightAligned">
					<input type="checkbox" id="chkBancaTag" name="chkBancaTag" value="Y" disabled="disabled"/>Bancassurance
				</td>
				<td colspan="3" id="tdRow12Column4">
					<input id="btnBancaDtl" class="button" type="button" value="Bancassurance Details" name="btnBancaDtl" style="width:100%"/>
				</td>
				
			</tr>
			
			<tr id="trRow13">
				<td id="tdRow13Column1" class="rightAligned">DSP_TEXT
				</td>
				<td id="tdRow13Column2">
					<input type="text" id="txtEndtExpiryDate" name="txtEndtExpiryDate" style="width:88%" readonly="readonly"/>
					<input type="checkbox" id="chkEndtExpiryTag" name="chkEndtExpiryTag" value="Y" style="width:13px" disabled="disabled"/>
				</td>
				<td id="tdRow13Column3"></td>
				<td colspan="3" id="tdRow13Column4">
					<input id="btnBancPayDtl" class="button" type="button" value="Bank Payment Details" name="btnBancPayDtl" style="width:100%"/>
				</td>
				
			</tr>
			
			<tr id="trRow14">
				<td id="tdRow14Column1" class="rightAligned">
					<input type="checkbox" id="chkPlanSw" name="chkPlanSw" value="Y" disabled="disabled"/>Package Plan
				</td>
				<td id="tdRow14Column2">
					<input id="btnPlanDtl" class="button" type="button" value="Plan Details" name="btnPlanDtl" style="width:100%"/>
				</td>
				<!-- replaced by robert SR 21862 03.08.16			
				<td id="tdRow14Column3"></td>
				<td id="tdRow14Column4"></td>
				<td id="tdRow14Column5"></td>
				<td id="tdRow14Column6"></td> -->
				<td align="right"></td>
				<td align="right"><label id="isForeignCurrency" name="isForeignCurrency" style="padding:2px; text-align:center; font-size:140%; font-weight:bold;width:100%; color: #FF0000; "></label></td>
			</tr>
			
			<tr id="spacer" style="height:10px;"></tr>
			
			<tr id="trRow15">
				<td id="tdRow15Column1" class="rightAligned">General Information</td>
				<td id="tdRow15Column2">
					<textArea id="txtDspGenInfo" name="txtDspGenInfo" style="width:88%; resize: none;" readonly="readonly"/></textArea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" id="textDspGen" class="hover" />
				</td>
				<td id="tdRow15Column3" class="rightAligned">PROMPT_TEXT</td>
				<td colspan="3" id="trRow15Column4">
					<textArea id="txtInfo" name="txtInfo" style="width:88%; resize: none;" readonly="readonly"/></textArea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" id="textInfo" class="hover" />
				</td>
			</tr>
			
			<tr id="trRow16">
				<td id="tdRow16Column1" class="rightAligned">Remarks</td>
				<td colspan="5" id="tdRow16Column2">
					<textArea id="txtRemarks" name="txtRemarks" style="width:95.5%; resize: none;" readonly="readonly"/></textArea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" id="textRemarks" class="hover" />
				</td>
			</tr>
			
			<tr id="spacer" style="height:10px;"></tr>
			
			<tr id="trButtonsRow1">
				<td colspan="7" align="center">
				<input id="btnAnnualizedAmounts"  name="btnAnnualizedAmounts" class="button" type="button" value="Annualized Amounts" style="width:20%"/>
				<input id="btnMarineDetail"  name="btnMarineDetail" class="button" type="button" value="Marine Detail" style="width:20%"/>
				<input id="btnDeductibles"  name="btnDeductibles" class="button" type="button" value="Deductibles" style="width:20%"/>
				</td>
			</tr>
			<tr id="trButtonsRow2">
				<td colspan="7" align="center">
				<input id="btnReplacementRenewal"  name="btnReplacementRenewal" class="button" type="button" value="Replacement/Renewal" style="width:20%"/>
				<input id="btnAdditionalInfo"  name="btnAdditionalInfo" class="button" type="button" value="Additional Information" style="width:20%"/>
				<input id="btnCoInsurer"  name="btnCoInsurer" class="button" type="button" value="Co-Insurer" style="width:20%"/>
				</td>
			</tr>
			<tr id="trButtonsRow3">
				<td colspan="7" align="center">
				<input id="btnOpenPolicy"  name="btnOpenPolicy" class="button" type="button" value="Open Policy" style="width:20%"/>
				<input id="btnBankCollection"  name="btnBankCollection" class="button" type="button" value="Bank Collection" style="width:20%"/>
				<input id="btnLeadPolicy"  name="btnLeadPolicy" class="button" type="button" value="Lead Policy" style="width:20%"/>
				</td>
			</tr>
			
		</table>
		</c:if>
		
		<!-- kris 02.18.2013: to test if will call GIPIS101 -->
		<c:if test="${moduleId eq 'GIPIS101' }">
		<table border="0">
			<tr id="trRow1">
				<td id="tdRow1column1" class="rightAligned" width="13%">Address</td>
				<td colspan="5" id="tdRow1column2">
					<input type="text" id="txtAddress1" name="txtAddress1" style="width:98.9%" readonly="readonly"/>
				</td>
				<td>&nbsp;</td>
				<td rowspan="9" id="tdRow1column7" style="width:145px;" valign="top">
					<div style="border:1px solid rgb(224,224,224)">
												
						<div style="border:1px solid rgb(224,224,224);">
							<table cellpadding="0" border="0">
								<tr>
									<td width="100%" colspan="4" style="border:1px solid rgb(224,224,224);">
										<label style="padding:2px;width:100%;text-align:center;font-weight:bold;" title="Type" align="center">Type</label>
									</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chkPackPolFlag" name="chkPackPolFlag" disabled="disabled"/></td>
									<td colspan="3">Package Policy</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chkAutoRenewFlag" name="chkAutoRenewFlag" disabled="disabled"/></td>
									<td colspan="3">Auto Renewal</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chkForeignAccSw" name="chkForeignAccSw" disabled="disabled"/></td>
									<td colspan="3">Foreign Acct</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chkRegPolicySw" name="chkRegPolicySw" disabled="disabled"/></td>
									<td colspan="3">Regular Policy</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="chkPremWarrTag" name="chkPremWarrTag" disabled="disabled"/></td>
									<td colspan="3">W/ Prem Warranty<br/></td>
								</tr>
								<tr>
									<td width="100%" colspan="4" style="border:1px solid rgb(224,224,224);">
										<label style="padding:2px;width:100%;text-align:center;font-weight:bold;" title="Type" align="center">Co-Insurance</label>
									</td>
								</tr>
								<tr>
									<td><input type="radio" id="rdoNonCo" name="rdoNonCo" value="1" disabled="disabled"/></td>
									<td colspan="3">Non-Co-Insurance</td>
								</tr>
								<tr>
									<td><input type="radio" id="rdoLead" name="rdoLead" value="2" disabled="disabled"/></td>
									<td colspan="3">Lead Policy</td>
								</tr>
								<tr>
									<td><input type="radio" id="rdoNonLead" name="rdoNonLead" value="3" disabled="disabled"/></td>
									<td colspan="3">Non-Lead Policy</td>
								</tr>								
							</table>
						</div>
					</div>
				</td>
			</tr>
				
			<tr id="trRow2">
				<td id="tdRow2Column1" class="rightAligned"></td>
				<td colspan="3" id="tdRow2Column2">
					<input type="text" id="txtAddress2" name="txtAddress2" style="width:98.9%" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow3">
				<td id="trRow3Column1" class="rightAligned"></td>
				<td colspan="3" id="trRow3Column2">
					<input type="text" id="txtAddress3" name="txtAddress3" style="width:98.9%" readonly="readonly"/>
				</td>
				
			</tr>
			
			<tr id="trRow4">
				<td id="tdRow4Column1" class="rightAligned" style="width:120px;">Ref. Policy No.</td>
				<td colspan="3" id="tdRow4Column2" style="width:250px">
					<input type="text" id="txtRefPolNo2" name="txtRefPolNo2" style="width:98.9%" readonly="readonly"/>
				</td>
			</tr>
			
			<tr id="trRow5">
				<td id="tdRow5Column1" class="rightAligned">Type of Policy</td>
				<td id="tdRow5Column2" width="30%">
					<input type="text" id="txtDspPolicyType" name="txtDspPolicyType" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow5Column3" class="rightAligned">Industry</td>
				<td id="tdRow5Column4" style="width:250px">
					<input type="text" id="txtNbtIndDesc" name="txtNbtIndDesc" style="width:97%" readonly="readonly"/>
				</td>		
			</tr>
				
			<tr id="trRow6">
				<td id="tdRow6Column1" class="rightAligned">Manual Renew No.</td>
				<td id="tdRow6Column2">
					<input type="text" id="txtManualRenewNo" name="txtManualRenewNo" style="width:97%;" readonly="readonly"/>					
				</td>
				<td id="tdRow6Column3" class="rightAligned">Region</td>
				<td id="tdRow6Column4">
					<input type="text" id="txtNbtRegionDesc" name="txtNbtRegionDesc" style="width:97%" readonly="readonly"/>
				</td>		
			</tr>
				
			<tr id="trRow7">
				<td id="tdRow7Column1" class="rightAligned">Risk Tag</td>
				<td id="tdRow7Column2">
					<input type="text" id="txtRiskTag" name="txtRiskTag" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtDspRiskDesc" name="txtDspRiskDesc" style="width:70%;" readonly="readonly"/>
				</td>
				<td id="tdRow7Column3" class="rightAligned">Crediting Branch</td>
				<td id="tdRow7Column4">
					<input type="text" id="txtDspCredBranch" name="txtDspCredBranch" style="width:97%" readonly="readonly"/>
				</td>
			</tr>
			
			<tr id="trRow8">
				<td id="tdRow8Column1" class="rightAligned">Inception Date</td>
				<td id="tdRow8Column2">
					<input type="text" id="txtInceptDate" name="txtInceptDate" style="width:88%" readonly="readonly"/>
					<input type="checkbox" id="chkInceptTag" name="chkInceptTag" value="Y" style="width:10px" disabled="disabled"/>
				</td>
				<td id="tdRow8Column3" class="rightAligned">U/W Year</td>
				<td id="tdRow8Column4" class="alignRight">
					<input type="text" id="txtIssueYy2" name="txtIssueYy2" style="width:97%; text-align: right;" readonly="readonly"/>
				</td>
			</tr>
				
			<tr id="trRow9">
				<td id="tdRow9Column1" class="rightAligned">Expiry Date</td>
				<td id="tdRow9Column2">
					<input type="text" id="txtExpiryDate" name="txtExpiryDate" style="width:88%" readonly="readonly"/>
					<input type="checkbox" id="chkExpiryTag" name="chkExpiryTag" style="width:10px" disabled="disabled"/>
				</td>
				<td id="tdRow9Column3" class="rightAligned">Premium</td>
				<td id="tdRow9Column4">
					<input type="text" id="txtPhpPrem" name="txtPhpPrem" value="PHP" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtPremAmt" name="txtPremAmt" style="width:70%; text-align: right;" readonly="readonly" align="right" />
				</td>
			</tr>
			
			<tr id="trRow10">
				<td id="tdRow10Column1" class="rightAligned">Issue Date</td>
				<td id="tdRow10Column2">
					<input type="text" id="txtIssueDate2" name="txtIssueDate2" style="width:97%" readonly="readonly"/>
				</td>
				<td id="tdRow10Column3" class="rightAligned">TSI</td>
				<td id="tdRow10Column4">
					<input type="text" id="txtPhpTsi" name="txtPhpTsi" value="PHP" style="width:22%;" readonly="readonly"/>
					<input type="text" id="txtTsiAmt" name="txtTsiAmt" style="width:70%; text-align: right;" readonly="readonly" align="right" />
				</td>
			</tr>
			
			<tr id="trRow11">
				<td id="tdRow11Column1" class="rightAligned">Effectivity Date</td>
				<td id="tdRow11Column2">
					<input type="text" id="txtEffDate" name="txtEffDate" style="width:97%" readonly="readonly"/>
				</td>
				<td>&nbsp;</td>
				<td id="tdRow11Column4">
					<input id="btnMortgageeInfo" class="button" type="button" value="Mortgagee" name="btnMortgageeInfo" style="width:100%"/>
				</td>			
			</tr>
			
			<tr>
				<td colspan="3" align="right"></td>
				<td align="right"><label id="isForeignCurrency" name="isForeignCurrency" style="padding:2px; text-align:center; font-weight:bold;width:100%; color: #FF0000; "></label></td>
			</tr>
			
			<tr id="spacer" style="height:10px;"></tr>
			
			<tr id="trButtonsRow1">
				<div id="btnMarineDetailDiv">
				<td colspan="1"></td>
				<td colspan="6" align="left">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="button" id="btnMarineDetail" name="btnMarineDetail" value="Marine Detail" style="width:23.8%;" />
				</td>
				</div>
			</tr>			
			<tr id="trButtonsRow2">
				<td colspan="7" align="center">
				<input id="btnReplacementRenewal"  name="btnReplacementRenewal" class="button" type="button" value="Replacement/Renewal" style="width:20%"/>
				<input id="btnAdditionalInfo"  name="btnAdditionalInfo" class="button" type="button" value="Additional Information" style="width:20%"/>
				<input id="btnCoInsurer"  name="btnCoInsurer" class="button" type="button" value="Co-Insurer" style="width:20%"/>
				</td>
			</tr>
			<tr id="trButtonsRow3">
				<td colspan="7" align="center">
				<input id="btnOpenPolicy"  name="btnOpenPolicy" class="button" type="button" value="Open Policy" style="width:20%"/>
				<input id="btnBankCollection"  name="btnBankCollection" class="button" type="button" value="Bank Collection" style="width:20%"/>
				<input id="btnLeadPolicy"  name="btnLeadPolicy" class="button" type="button" value="Lead Policy" style="width:20%"/>
				</td>
			</tr>
			
		</table>
		</c:if>
	</form>

</div>

<script type="text/javascript">
	initializeAll();
	try{
		var policyBasicInfo = JSON.parse('${policyBasicInfo}');
	}catch (e){
		showErrorMessage("policyInfoBasic", e);
	}
	var moduleId = '${moduleId}';
	setModuleId(moduleId);
	
	/*var line_en = "EN";
	var line_mn = "MN";
	var line_fi = "FI";*/
	
	if(moduleId != "GIPIS101"){ // added by Kris 02.18.2013: IF condition added to separate the initialization of fields for GIPIS100
		if (policyBasicInfo.endtSeqNo == 0){
			$("tdRow13Column1").innerHTML = "";
			$("txtEndtExpiryDate").hide();
			$("chkEndtExpiryTag").hide();
		}else{
			$("tdRow13Column1").innerHTML = "Endt Expiry Date";
			$("txtEndtExpiryDate").show();
			$("chkEndtExpiryTag").show();
		}
			
		if(policyBasicInfo.policyIdType == "new"){
			
			$("btnReplacementRenewal").value = "Replacement/Renewal";
			$("btnReplacementRenewal").enable();
			$("btnReplacementRenewal").writeAttribute("class","button");
		}else if(policyBasicInfo.policyIdType == "old"){
			
			$("btnReplacementRenewal").value = "Replaced/Renewed";
			$("btnReplacementRenewal").enable();
			$("btnReplacementRenewal").writeAttribute("class","button");
		}else{
			
			$("btnReplacementRenewal").disable();
			$("btnReplacementRenewal").writeAttribute("class","disabledButton");
		}
		
		if(policyBasicInfo.lineType == "marine"){
			$("btnMarineDetail").enable();
			$("btnMarineDetail").writeAttribute("class","button");
			
		}else{
			$("btnMarineDetail").disable();
			$("btnMarineDetail").writeAttribute("class","disabledButton");
		}
	
		
		//hidden
		$("hidAnnPremAmt").value	 	 = policyBasicInfo.annPremAmt;
		$("hidAnnTsiAmt").value	 		 = policyBasicInfo.annTsiAmt;
		$("hidDefaultCurrency").value	 = policyBasicInfo.defaultCurrency;
		//trRow1
		$("txtAddress1").value	 		 = unescapeHTML2(policyBasicInfo.address1);
		//trRow2
		$("txtAddress2").value			 = unescapeHTML2(policyBasicInfo.address2);
		//trRow3
		$("txtAddress3").value			 = unescapeHTML2(policyBasicInfo.address3);
		//trRow4
		$("txtNbtIndDesc").value		 = policyBasicInfo.industryNm;
		$("txtRefPolNo2").value			 = policyBasicInfo.refPolNo;
		//trRow5
		$("txtNbtRegionDesc").value		 = policyBasicInfo.regionDesc;
		$("txtDspPolicyType").value		 = policyBasicInfo.typeDesc;
		//trRow6
		$("txtDspCredBranch").value		 = policyBasicInfo.issName;
		$("txtManualRenewNo").value		 = policyBasicInfo.manualRenewNo;
		if ($("chkSurchrgeSw").value    == policyBasicInfo.surchargeSw){
			$("chkSurchrgeSw").checked   = true;
		}
		//trRow7
		$("txtBookingYear").value		 = policyBasicInfo.bookingYear;
		$("txtBookingMonth").value		 = policyBasicInfo.bookingMth;
		$("txtActualRenewNo").value		 = policyBasicInfo.actualRenewNo;
		if ($("chkDiscountSw").value    == policyBasicInfo.discountSw){
			$("chkDiscountSw").checked   = true;
		}
		//trRow8
		$("txtTakeUpTermDesc").value	 = policyBasicInfo.takeupTermDesc;
		$("txtIssueYy2").value			 = policyBasicInfo.issueYy;
		//trRow9
		$("txtInceptDate").value		 = policyBasicInfo.inceptDate;
		if (policyBasicInfo.inceptTag == 'Y'){ //modified by Daniel Marasigan SR 22657 07.05.2016
			$("chkInceptTag").checked    = true;
		}
		$("txtPremAmt").value			 = formatCurrency(policyBasicInfo.premAmt);
		//trRow10
		$("txtExpiryDate").value		 = policyBasicInfo.expiryDate;
		if (policyBasicInfo.expiryTag == 'Y'){ //modified by Daniel Marasigan SR 22657 07.05.2016
			$("chkExpiryTag").checked    = true;
		}
		$("txtTsiAmt").value			 = formatCurrency(policyBasicInfo.tsiAmt);
		//trRow11
		$("txtIssueDate2").value		 = policyBasicInfo.issueDate;
		$("txtRiskTag").value			 = policyBasicInfo.riskTag;
		$("txtDspRiskDesc").value		 = policyBasicInfo.riskDesc;
		//trRow12
		$("txtEffDate").value			 = policyBasicInfo.effDate;
		if ($("chkBancaTag").value 	    == policyBasicInfo.bancassuranceSw){
			$("chkBancaTag").checked     = true;
		}
		//trRow13
		$("txtEndtExpiryDate").value	  = policyBasicInfo.endtExpirydate;
		if ($("chkEndtExpiryTag").value  == policyBasicInfo.endtExpiryTag){
			$("chkEndtExpiryTag").checked = true;
		}
		//trRow14
		if ($("chkPlanSw").value 		 == policyBasicInfo.planSw){
			$("chkPlanSw").checked 		  = true;
		}
		//trRow15
		$("tdRow15Column3").innerHTML	  = unescapeHTML2(policyBasicInfo.promptText);
		$("txtDspGenInfo").value		  = nvl(policyBasicInfo.genInfo01,"")+
											nvl(policyBasicInfo.genInfo02,"")+
											nvl(policyBasicInfo.genInfo03,"")+
											nvl(policyBasicInfo.genInfo04,"")+
											nvl(policyBasicInfo.genInfo05,"")+
											nvl(policyBasicInfo.genInfo06,"")+
											nvl(policyBasicInfo.genInfo07,"")+
											nvl(policyBasicInfo.genInfo08,"")+
											nvl(policyBasicInfo.genInfo09,"")+
											nvl(policyBasicInfo.genInfo10,"")+
											nvl(policyBasicInfo.genInfo11,"")+
											nvl(policyBasicInfo.genInfo12,"")+
											nvl(policyBasicInfo.genInfo13,"")+
											nvl(policyBasicInfo.genInfo14,"")+
											nvl(policyBasicInfo.genInfo15,"")+
											nvl(policyBasicInfo.genInfo16,"")+
											nvl(policyBasicInfo.genInfo17,"");
		$("txtDspGenInfo").value = unescapeHTML2($F("txtDspGenInfo"));
		
		$("txtInfo").value				  = nvl(policyBasicInfo.info01,"")+
											nvl(policyBasicInfo.info02,"")+
											nvl(policyBasicInfo.info03,"")+
											nvl(policyBasicInfo.info04,"")+
											nvl(policyBasicInfo.info05,"")+
											nvl(policyBasicInfo.info06,"")+
											nvl(policyBasicInfo.info07,"")+
											nvl(policyBasicInfo.info08,"")+
											nvl(policyBasicInfo.info09,"")+
											nvl(policyBasicInfo.info10,"")+
											nvl(policyBasicInfo.info11,"")+
											nvl(policyBasicInfo.info12,"")+
											nvl(policyBasicInfo.info13,"")+
											nvl(policyBasicInfo.info14,"")+
											nvl(policyBasicInfo.info15,"")+
											nvl(policyBasicInfo.info16,"")+
											nvl(policyBasicInfo.info17,"");
		$("txtInfo").value = unescapeHTML2($F("txtInfo"));
		//trRow16
		$("txtRemarks").value			  = unescapeHTML2(policyBasicInfo.remarks);
	
	
		//"Type"
		if ($("chkPackPolFlag").value    == policyBasicInfo.packPolFlag){
			$("chkPackPolFlag").checked   = true;
		}
		if ($("chkAutoRenewFlag").value  == policyBasicInfo.autoRenewFlag){
			$("chkAutoRenewFlag").checked = true;
		}
		if ($("chkForeignAccSw").value   == policyBasicInfo.foreignAccSw){
			$("chkForeignAccSw").checked  = true;
		}
		if ($("chkRegPolicySw").value 	 == policyBasicInfo.regPolicySw){
			$("chkRegPolicySw").checked   = true;
		}
		if ($("chkPremWarrTag").value 	 == policyBasicInfo.surchrgeSw){
			$("chkPremWarrTag").checked   = true;
			$("txtPremWarrDays").value	  =	policyBasicInfo.premWarrDays;
		}
		
		if ($("chkFleetPrintTag").value  == policyBasicInfo.fleetPrintTag){
			$("chkFleetPrintTag").checked = true;
		}
		if ($("chkWithTariffSw").value   == policyBasicInfo.withTariffSw){
			$("chkWithTariffSw").checked  = true;
		}
		//"Co-Insurance"
		//co_insurance_sw radio group
		if ($("rdoNonCo").value 		== policyBasicInfo.coInsuranceSw){
			$("rdoNonCo").checked 		 = true;
		}
		else if ($("rdoLead").value 	== policyBasicInfo.coInsuranceSw){
			$("rdoLead").checked 		 = true;
		}else if ($("rdoNonLead").value == policyBasicInfo.coInsuranceSw){
			$("rdoNonLead").checked 	 = true;
		}
		//"Condition"
		//prorate_flag radio group
		if ($("rdoProRate").value == policyBasicInfo.prorateFlag){
			$("rdoProRate").checked = true;
			$("txtProRateDays").enable();
			$("txtShorRtPercent").disable();
		}else if ($("rdoStraight").value == policyBasicInfo.prorateFlag){
			$("rdoStraight").checked = true;
			$("txtProRateDays").disable();
			$("txtShorRtPercent").disable();
		}else if ($("rdoShortRt").value == policyBasicInfo.prorateFlag){
			$("rdoShortRt").checked = true;
			$("txtProRateDays").disable();
			$("txtShorRtPercent").enable();
			$("txtShorRtPercent").value	= policyBasicInfo.shorRtPercent;
		}
		//comp_sw radio group
		if($("rdoAdd").value == policyBasicInfo.compSw){
			$("rdoAdd").checked = true;
		}else if ($("rdoMinus").value == policyBasicInfo.compSw){
			$("rdoMinus").checked = true;
		}else{
			$("rdoOrdinary").checked = true;
		}
		if ($("chkProvePremTag").value == policyBasicInfo.provePremTag){
			$("chkProvePremTag").checked = true;
			$("txtProvPremPct").enable();
			$("txtProvPremPct").value = policyBasicInfo.provPremPct;
		}else{
			$("txtProvPremPct").disable();
		}
	
		//button actions
		if($("chkBancaTag").checked){
			$("btnBancaDtl").enable();
			$("btnBancaDtl").writeAttribute("class","button");
		}else{
			$("btnBancaDtl").disable();
			$("btnBancaDtl").writeAttribute("class","disabledButton");
		}
		
		if($("chkPlanSw").checked){
			$("btnPlanDtl").enable();
			$("btnPlanDtl").writeAttribute("class","button");
		}else{
			$("btnPlanDtl").disable();
			$("btnPlanDtl").writeAttribute("class","disabledButton");
		}
		
		$("textDspGen").observe("click", function () {
			showEditor5("txtDspGenInfo", 2000, 'true'); //edited by gab 08.13.2015
		});
		$("textRemarks").observe("click", function () {
			showEditor5("txtRemarks", 2000, 'true'); //edited by gab 08.13.2015
		});
		$("textInfo").observe("click", function () {
			showEditor5("txtInfo", 2000, 'true'); //edited by gab 08.13.2015
		});
		
		$("btnBancPayDtl").observe("click", function(){
			overlayBankPaymentDtl = Overlay.show(contextPath+"/GIPIPolbasicController", {
							urlContent: true,
							urlParameters: {
								action 	 : "getBankPaymentDtl",
								policyId : policyBasicInfo.policyId},
							title: "Bank Payment Details",
							width: 630,
							height: 150,
							draggable: true,
							showNotice: true
						  });
		});

		$("btnBancaDtl").observe("click", function(){
			overlayBancassuranceDtl = Overlay.show(contextPath+"/GIPIPolbasicController", {
							urlContent: true,
							urlParameters: {
								action 	 : "getBancassuranceDtl",
								policyId : policyBasicInfo.policyId},
							title: "Bancassurance Details",
							width: 605,
							height: 150,
							draggable: true,
							showNotice: true
						  });
		});
		$("btnPlanDtl").observe("click", function(){
			overlayPlanDtl = Overlay.show(contextPath+"/GIPIPolbasicController", {
							urlContent: true,
							urlParameters: {
								action 	 : "getPlanDtl",
								policyId : policyBasicInfo.policyId},
							title: "Plan Details",
							width: 275,
							height: 90,
							draggable: true,
							showNotice: true
						  });
		});
		
		$("btnAnnualizedAmounts").observe("click", function(){
			overlayAnnAmounts = Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {
					action 	 : "showAnnualizedAmounts",
					policyId : policyBasicInfo.policyId},
				title: "Annualized Amounts",
				width: 300,
				height: 120,
				draggable: true,
				showNotice: true
			  });
		});
		
		$("btnDeductibles").observe("click", function(){

			overlayDeductibles = Overlay.show(contextPath+"/GIPIDeductiblesController", {
				urlContent: true,
				urlParameters: {
					action 	 	: "getDeductibles",
					policyId 	: policyBasicInfo.policyId
				},
				title: "Deductibles",
				width: 650,
				height: 310,
				draggable: true,
				showNotice: true,
				showNotice: true
			});
		});

	
	}// end: if moduleId != GIPIS101
	
	
	
	$("btnMortgageeInfo").observe("click", function(){
		if(moduleId == "GIPIS101") {
			overlayMortgageeList = Overlay.show(contextPath+"/GIXXMortgageeController", {
				urlContent: true,
				urlParameters: {
					action 	 : "getGIXXMortgageeList",
					extractId : policyBasicInfo.extractId},
				title: "Mortgagee",
				width: 550,
				height: 290,
				draggable: true,
				showNotice: true
			  });
		} else {
			overlayMortgageeList = Overlay.show(contextPath+"/GIPIMortgageeController", {
				urlContent: true,
				urlParameters: {
					action 	 : "getMortgageesTableGrid", //"getPolicyMortgageeList", replaced by Apollo 08.04.2014
					policyId : policyBasicInfo.policyId},
				title: "Mortgagee",
				width: 550,
				height: 290,
				draggable: true,
				showNotice: true
			  });
		}
	});

	

	$("btnReplacementRenewal").observe("click", function(){
		overlayRenewals = Overlay.show(contextPath+"/GIPIPolbasicController", {
			urlContent: true,
			urlParameters: {
				action 	 : "getPolicyRenewals",
				policyId : policyBasicInfo.policyId},
			title: "Replacement / Renewal Details",
			width: 300,
			height: 220,
			draggable: true,
			showNotice: true
		});
	});

	$("btnMarineDetail").observe("click", function(){
		overlayMarineDetails = Overlay.show(contextPath+ ( moduleId == "GIPIS101" ? "/GIXXPolbasicController" : "/GIPIPolbasicController" ), {
			urlContent: true,
			urlParameters: {
				action 	 : ( moduleId == "GIPIS101" ? "getGIXXMarineDetails" : "getMarineDetails" ),
				surveyAgentCd 	: policyBasicInfo.surveyAgentCd,
				surveyAgent	  	: policyBasicInfo.surveyAgent,
				settlingAgentCd	: policyBasicInfo.settlingAgentCd,
				settlingAgent 	: policyBasicInfo.settlingAgent
			},
			title: "Marine Details",
			width:500,
			height: 120,
			draggable: true,
			showNotice: true
		});
	});
	
	$("btnAdditionalInfo").observe("click", function(){
		var paramPolicyBasicInfo = JSON.stringify(policyBasicInfo);
		var displayPrincipal = policyBasicInfo.sublineCdParam == 'ERECTION_ALL_RISK' || policyBasicInfo.sublineCdParam == 'CONTRACTORS_ALL_RISK'; //added by robert SR 20307 10.27.15
		if(moduleId == "GIPIS101") {
			overlayAdditionalInfo = Overlay.show(contextPath+"/GIXXPolbasicController", {
				urlContent: true,
				urlParameters: {
					action 	 				: "getGIXXAdditionalInfo" ,
					paramPolicyBasicInfo 	: paramPolicyBasicInfo, //added by robert SR 20307 10.27.15
					extractId				: policyBasicInfo.extractId, //added by robert SR 20307 10.27.15
					displayPrincipal		: displayPrincipal ? "Y" : "N", //added by robert SR 20307 10.27.15
					summarySw				: "Y" //added by robert SR 20307 10.27.15
				},
				title: "Additional Information",
				width: 600,
				height: displayPrincipal ? 500 : 225, //added by robert SR 20307 10.27.15
				draggable: true,
				showNotice: true
			});
		} else {
			overlayAdditionalInfo = Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {
					action 	 				: "getAdditionalInfo" ,
					paramPolicyBasicInfo 	: paramPolicyBasicInfo, //added by robert SR 20307 10.27.15
					policyId				: policyBasicInfo.policyId, //added by robert SR 20307 10.27.15
					displayPrincipal		: displayPrincipal ? "Y" : "N", //added by robert SR 20307 10.27.15
					summarySw				: "N" //added by robert SR 20307 10.27.15
				},
				title: "Additional Information",
				width: 600,
				height: displayPrincipal ? 500 : 225, //added by robert SR 20307 10.27.15
				draggable: true,
				showNotice: true
			});
		}		
	});

	
	$("btnBankCollection").observe("click", function(){
		
		if(policyBasicInfo.bankBtnLabel == "Bank Collection"){
			
			overlayBankCollection = Overlay.show(contextPath+"/GIPIBankScheduleController", {
				urlContent: true,
				urlParameters: {
					action 		: "getBankCollections",
					policyId 	: policyBasicInfo.policyId
				},
				title: "Bank Collection",
				width: 600,
				height: 205,
				draggable: true,
				showNotice: true
			});
			  
		} else if(policyBasicInfo.bankBtnLabel == "Cargo Information" || $F("btnBankCollection") == "Carrier Information"){
			overlayCargoInformation = Overlay.show(contextPath+"/GIPIVesAirController", {
				urlContent: true,
				urlParameters: {
					action 	 	: "getCargoInformations",
					policyId 	: policyBasicInfo.policyId
				},
				title: "Cargo Information",
				width: 450,
				height: 220,
				draggable: true,
				showNotice: true
			});			  
		}		
	});

	
	
	$("btnCoInsurer").observe("click", function(){
		
		overlayCoInsurers = Overlay.show(contextPath+"/GIPIMainCoInsController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "getPolicyMainCoInsurer",
				policyId 	: policyBasicInfo.policyId
			},
			title: "Co Insurers",
			width: 600,
			height: 250,
			draggable: true,
			showNotice: true
		});
		
	});

	$("btnLeadPolicy").observe("click", function(){
		if(moduleId == "GIPIS101") {
			overlayLeadPolicy = Overlay.show(contextPath+"/GIXXItemController", {
				urlContent: true,
				urlParameters: {
					action 	 	: "getGIXXItemInfo",
					extractId 	: policyBasicInfo.extractId,
					policyId 	: policyBasicInfo.policyId,
					pageCalling	: "policyInfoBasic"
				},
				title: "Lead Policy",
				width: 825,
				height: 600,
				draggable: true,
				showNotice: true
			});
		} else {
			overlayLeadPolicy = Overlay.show(contextPath+"/GIPIItemMethodController", {
				urlContent: true,
				urlParameters: {
					action 	 	: "getRelatedItemInfo",
					policyId 	: policyBasicInfo.policyId,
					pageCalling	: "policyInfoBasic"
				},
				title: "Lead Policy",
				width: 825,
				height: 600,
				draggable: true,
				showNotice: true
			});	
		}		
	});
	
	$("btnOpenPolicy").observe("click", function(){
		if(moduleId == "GIPIS101") {
			if(policyBasicInfo.sublineCd == policyBasicInfo.varSublineOpen) {
				openPolicyOverlay = Overlay.show(contextPath+"/GIXXOpenPolicyController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXOpenPolicy",
						extractId 	: policyBasicInfo.extractId
					},
					title: "Open Policy",
					width: 400,
					height: 200,
					draggable: true,
					showNotice: true
				});
			} else if(policyBasicInfo.sublineCd == policyBasicInfo.varSublineMop){
				openLiabOverlay = Overlay.show(contextPath+"/GIXXOpenLiabController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXOpenLiabInfo",
						extractId 	: policyBasicInfo.extractId,
						issCd		: policyBasicInfo.issCd,
						lineCd		: policyBasicInfo.lineCd,
						sublineCd	: policyBasicInfo.sublineCd,
						issueYy		: nvl(policyBasicInfo.issueYy, 0),
						polSeqNo	: nvl(policyBasicInfo.polSeqNo, 0),
						renewNo		: policyBasicInfo.renewNo
					},
					title: "Cargo Limit of Liability",
					width: 800,
					height: 540,
					draggable: true,
					showNotice: true
				});
			}
		} else {
			if(policyBasicInfo.openPolicyView == "openPolicy"){
				//show gipi_open_policy
				// open_policy_sw = 'Y'
				//must submit policyBasicInfo.policyEndtseq0 to gipi_open_policy_pkg.get_endtseq0_open_policy(#)
				openPolicyOverlay = Overlay.show(contextPath+"/GIPIOpenPolicyController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getEndtseq0OpenPolicy",
						policyEndSeq0 	: policyBasicInfo.policyEndtseq0
					},
					title: "Open Policy",
					width: 400,
					height: 200,
					draggable: true,
					showNotice: true
				 });
				
			}else if (policyBasicInfo.openPolicyView == "openLiabFiMn"){
				//openliab 3
				// op_flag = 'Y' and line_cd = mn/fi
				openLiabOverlay = Overlay.show(contextPath+"/GIPIOpenPolicyController", {
					urlContent: true,
					urlParameters: {
						action : "showOpenLiabFiMn",
						policyId : policyBasicInfo.policyId,
						moduleId : moduleId
					},
					title: "Open Policy",
					width: 800,
					height: 530,
					draggable: true,
					showNotice: true
				 });
			}else if (policyBasicInfo.openPolicyView == "openLiab"){
				//openliab b
				// op_flag = 'Y' but line_cd != mn/fi
				openLiabOverlay = Overlay.show(contextPath+"/GIPIOpenPolicyController", {
					urlContent: true,
					urlParameters: {
						action : "showOpenLiab",
						policyId : policyBasicInfo.policyId,
						moduleId : moduleId
					},
					title: "Open Policy",
					width: 800,
					height: 380,
					draggable: true,
					showNotice: true
				 });
			}
		}
		
	});
	
	if(policyBasicInfo.bankBtnLabel == "Bank Collection"){
		$("btnBankCollection").enable();
		$("btnBankCollection").writeAttribute("class","button");
		$("btnBankCollection").value = "Bank Collection";
	}else if(policyBasicInfo.bankBtnLabel == "Cargo Information"){
		$("btnBankCollection").enable();
		$("btnBankCollection").writeAttribute("class","button");
		$("btnBankCollection").value = "Cargo Information";
	}else if (policyBasicInfo.bankBtnLabel == "Carrier Information") { // added by Kris for GIPIS101
		enableButton($("btnBankCollection"));
		$("btnBankCollection").value = "Carrier Information";
	}else{
		$("btnBankCollection").value = "Bank Collection";
		$("btnBankCollection").disable();
		$("btnBankCollection").writeAttribute("class","disabledButton");
	}

	policyBasicInfo.isForeignCurrency == "Y" ? $("isForeignCurrency").innerHTML = "FOREIGN CURRENCY POLICY" : $("isForeignCurrency").hide(); //added by robert SR 21862 03.08.16		
	
	// methods for GIPIS101
	if(moduleId == "GIPIS101"){
		$("policyInfoBasicMainDiv").writeAttribute("style", "height:475px;margin-top:10px;");		
		toggleButtons();
		populateFields();
		
		$("hidExtractId").value = policyBasicInfo.extractId;
		$("hidPolicyId").value  = policyBasicInfo.policyId;
		$("hidDspRate").value =  policyBasicInfo.dspRate;
		$("hidPackPolFlag").value = policyBasicInfo.packPolFlag;
		$("txtPhpPrem").value = policyBasicInfo.defaultCurrency;
		$("txtPhpTsi").value = policyBasicInfo.defaultCurrency;
		//
		policyBasicInfo.packPolFlag 	== "Y" ? $("chkPackPolFlag").checked = true 	: $("chkPackPolFlag").checked = false;
		policyBasicInfo.autoRenewFlag 	== "Y" ? $("chkAutoRenewFlag").checked = true 	: $("chkAutoRenewFlag").checked = false;
		policyBasicInfo.foreignAccSw 	== "Y" ? $("chkForeignAccSw").checked = true 	: $("chkForeignAccSw").checked = false;
		policyBasicInfo.regPolicySw 	== "Y" ? $("chkRegPolicySw").checked = true 	: $("chkRegPolicySw").checked = false;
		policyBasicInfo.premWarrTag 	== "Y" ? $("chkPremWarrTag").checked = true 	: $("chkPremWarrTag").checked = false;
		
		policyBasicInfo.coInsuranceSw == 1 ? $("rdoNonCo").checked = true : (policyBasicInfo.coInsuranceSw == 2 ? $("rdoLead").checked = true : $("rdoNonLead").checked = true);
		policyBasicInfo.lineType == "marine" ? $("btnMarineDetail").show() : $("btnMarineDetail").hide();
		policyBasicInfo.lineType == "engine" ? enableButton($("btnAdditionalInfo")) : disableButton($("btnAdditionalInfo"));
		policyBasicInfo.isForeignCurrency == "Y" ? $("isForeignCurrency").innerHTML = "FOREIGN CURRENCY POLICY" : $("isForeignCurrency").hide();		
	}
	
	function toggleButtons(){		
		/*if(policyBasicInfo.lineCd == line_mn){
			$("btnBankCollection").value = "Carrier Information";
			enableButton($("btnBankCollection"));
		} else {
			$("btnBankCollection").disable();
			$("btnBankCollection").writeAttribute("class","disabledButton"); 
		}*/
		
		/*if(policyBasicInfo.lineCd == line_en){
			enableButton($("btnAdditionalInfo"));
		} else {
			disableButton($("btnAdditionalInfo"));
			$("btnAdditionalInfo").disable();
			$("btnAdditionalInfo").writeAttribute("class","disabledButton");
		}*/
		
		if(policyBasicInfo.coInsuranceSw == "2"){
			enableButton($("btnCoInsurer"));
			enableButton($("btnLeadPolicy"));
		} else if (policyBasicInfo.coInsuranceSw == "3") {
			enableButton($("btnCoInsurer"));
			disableButton($("btnLeadPolicy"));
		} else {
			disableButton($("btnCoInsurer"));
			disableButton($("btnLeadPolicy"));
		}
		
		//$("btnOpenPolicy").disable();
		//$("btnOpenPolicy").writeAttribute("class","disabledButton");		
		
		// for open policy button
		if(policyBasicInfo.sublineCd == policyBasicInfo.varSublineOpen){
			$("btnOpenPolicy").value = "Open Policy";
			enableButton($("btnOpenPolicy"));
		} else if (policyBasicInfo.sublineCd == policyBasicInfo.varSublineMop) {
			if(policyBasicInfo.lineType == "marine"){ //policyBasicInfo.lineCd == line_mn
				$("btnOpenPolicy").value = "Cargo Limits of Liability";
				enableButton($("btnOpenPolicy"));
			} else if(policyBasicInfo.lineType == "fire"){ //policyBasicInfo.lineCd == line_fi
				$("btnOpenPolicy").value = "Fire Limits of Liability";
				enableButton($("btnOpenPolicy"));
			} else {
				$("btnOpenPolicy").value = "Cargo Limits of Liability";
				disableButton($("btnOpenPolicy"));
			}
		} else {
			disableButton($("btnOpenPolicy"));
		}
		
		if(policyBasicInfo.policyIdType == "new"){			
			$("btnReplacementRenewal").value = "Replaced/Renewed";
			$("btnReplacementRenewal").enable();
			$("btnReplacementRenewal").writeAttribute("class","button");
		}else if(policyBasicInfo.policyIdType == "old"){			
			$("btnReplacementRenewal").value = "Replacement/Renewal";
			$("btnReplacementRenewal").enable();
			$("btnReplacementRenewal").writeAttribute("class","button");
		}
	}
	
	function populateFields(){
		/*var inceptDate = Date.parse(policyBasicInfo.inceptDate);
		var expDate = Date.parse(policyBasicInfo.expiryDate);
		var issueDate = Date.parse(policyBasicInfo.issueDate);
		var effDate = Date.parse(policyBasicInfo.effDate);*/
		
		$("txtAddress1").value	 		 = unescapeHTML2(policyBasicInfo.address1);
		$("txtAddress2").value			 = unescapeHTML2(policyBasicInfo.address2);
		$("txtAddress3").value			 = unescapeHTML2(policyBasicInfo.address3);
		$("txtRefPolNo2").value 		 = unescapeHTML2(policyBasicInfo.refPolNo);
		$("txtNbtIndDesc").value		 = unescapeHTML2(policyBasicInfo.dspIndustryNm);
		$("txtManualRenewNo").value		 = policyBasicInfo.manualRenewNo;
		$("txtNbtRegionDesc").value		 = unescapeHTML2(policyBasicInfo.regionDesc);
		$("txtRiskTag").value			 = policyBasicInfo.riskTag;
		$("txtDspRiskDesc").value		 = policyBasicInfo.nbtRiskTag;
		$("txtDspCredBranch").value		 = unescapeHTML2(policyBasicInfo.dspCredBranch);
		$("txtInceptDate").value		 = dateFormat(policyBasicInfo.inceptDate, 'mm-dd-yyyy'); //inceptDate.format("mm-dd-yyyy");
		$("chkInceptTag").checked   	 = policyBasicInfo.inceptTag == "Y" ? true : false;
		$("txtIssueYy2").value		 	 = policyBasicInfo.issueYy;
		$("txtExpiryDate").value		 = dateFormat(policyBasicInfo.expiryDate, 'mm-dd-yyyy'); //expDate.format("mm-dd-yyyy"); 
		$("chkExpiryTag").checked		 = policyBasicInfo.expiryTag == "Y" ? true : false;
		$("txtPremAmt").value		 	 = formatCurrency(nvl(policyBasicInfo.premAmt,0));
		$("txtIssueDate2").value		 = dateFormat(policyBasicInfo.issueDate, 'mm-dd-yyyy'); //issueDate.format("mm-dd-yyyy");
		$("txtTsiAmt").value		 	 = formatCurrency(nvl(policyBasicInfo.tsiAmt,0));
		$("txtEffDate").value			 = dateFormat(policyBasicInfo.effDate, 'mm-dd-yyyy'); //effDate.format("mm-dd-yyyy");
		$("txtDspPolicyType").value		 = unescapeHTML2(policyBasicInfo.typeDesc);
		$("hidDefaultCurrency").value	 = policyBasicInfo.defaultCurrency;
	}
	
	
</script>
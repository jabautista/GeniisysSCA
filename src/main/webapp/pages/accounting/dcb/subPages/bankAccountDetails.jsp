<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Bank Account Details</label>
		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
	</div>
</div>

<div class="sectionDiv" id="bankAccountDetailsOuterDiv" style="border-bottom: none;" changeTagAttr="true">
	<div id="gdbdSelectedDiv" style="display: none;">
		<input type="hidden" id="selectedGdbdAmt" name="selectedGdbdAmt" value="" />
		<input type="hidden" id="selectedGdbdForCurrAmt" name="selectedGdbdForCurrAmt" value="" />
	</div>
	<div id="gdbdListTableGridSectionDiv" class="sectionDiv" style="height: 180px; border: none">
		<div id="gdbdListTableGridDiv" style="margin-left:-95px; padding:10px; border: none" align="center">
			<div id="gdbdListTableGrid" style="height: 135px; width: 800px; border: none" align="left"></div>
		</div>
	</div>
	
	<div class="sectionDiv" id="bankAccountDetailsDiv" style="border-left: white; border-right: white; margin-top: -2px;" >
		<table width="900px" align="center" cellspacing="1" border="0" style="margin-top: 5px;">
			<tr>
				<td style="width: 360px">&nbsp</td>
				<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
				<td class="leftAligned">
					<input type="text" id="controlDspGdbdSumAmt" name="controlDspGdbdSumAmt" style="width: 130px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td style="width: 230px">&nbsp</td>
			</tr>
			<tr>
				<td style="width: 360px"></td>
				<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
				<td class="leftAligned">
					<input type="text" id="gdpdSumDspFcSumAmt" name="gdpdSumDspFcSumAmt" style="width: 130px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td style="width: 230px">&nbsp</td>
			</tr>
		</table>
		<table width="900px" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
			<tr>
				<td class="rightAligned" style="width: 80px;">Item No</td>
				<td class="leftAligned">
					<input style="width: 50px; float: left; " id="gdbdItemNo" name="gdbdItemNo" type="text" value="" maxlength="4000" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Bank Account</td>
				<td class="leftAligned"  style="width: 360px;">
					<span>
						<div id="bankCdDiv" style="border: 1px solid gray; width: 136px; height: 21px; float: left;"> <!-- dren 07.16.2015 : SR 0017729 -->
							<input id="gdbdBankCd" name="gdbdBankCd"  style="width: 110px; border: none; float: left; height: 13px;" type="text"  readonly="readonly"/>							
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBankCd" alt="Go" style="float: right;" /> <!-- dren 07.16.2015 : SR 0017729 -->
						</div>						
						<div id="bankAcctCdDiv" style="border: 1px solid gray; width: 136px; height: 21px; float: left; margin-left: 4px;"> <!-- dren 07.16.2015 : SR 0017729 -->
							<input id="gdbdBankAcctCd" name="gdbdBankAcctCd"  style="width: 110px; border: none; float: left; height: 13px;" type="text"  readonly="readonly"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBankAcctCd" alt="Go" style="float: right;" /> <!-- dren 07.16.2015 : SR 0017729 -->
						</div>
					</span>
				</td>
					<input id="gdbdBankCdValue" name="gdbdBankCdValue"  style="width: 110px; border: 1px solid gray; float: left; height: 13px;" type="hidden"  readonly="readonly"/> <!-- dren 07.16.2015 : SR 0017729 -->
					<input id="gdbdBankAcctCdValue" name="gdbdBankAcctCdValue"  style="width: 110px; border: 1px solid gray; float: left; height: 13px;" type="hidden"  readonly="readonly"/> <!-- dren 07.16.2015 : SR 0017729 -->
					<input id="gdbdAmountTotal" name="gdbdAmountTotal"  style="width: 110px; float: left; height: 13px;" type="hidden"  readonly="readonly"/> <!-- dren 07.16.2015 : SR 0017729 -->
					<input id="gdbdForeignCurrAmtTotal" name="gdbdForeignCurrAmtTotal"  style="width: 110px; float: left; height: 13px;" type="hidden"  readonly="readonly"/> <!-- dren 07.16.2015 : SR 0017729 -->				
			</tr>
			<tr>
				<td class="rightAligned" style="width: 80px;">Deposit Type</td>
				<td class="leftAligned">
					<div id="depositTypeDiv" style="border: 1px solid gray; width: 186px; height: 21px; float: left;"> <!-- dren 07.16.2015 : SR 0017729 -->
						<input id="gdbdDepositType" name="gdbdDepositType"  style="width: 160px; border: none; float: left; height: 13px;" type="text"  readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDepositType" alt="Go" style="float: right;" /> <!-- dren 07.16.2015 : SR 0017729 -->
					</div>
				</td>
				<td class="rightAligned" style="width: 140px;">Local Curr Amt</td>
				<td class="leftAligned">
					<input type="text" id="gdbdLocalCurrAmt" name="gdbdLocalCurrAmt" style="width: 200px; text-align: right" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 80px;">Currency</td>
				<td class="leftAligned">
					<div id="currencyDiv" style="border: 1px solid gray; width: 186px; height: 21px; float: left;"> <!-- dren 07.16.2015 : SR 0017729 -->
						<input type="hidden" id="gdbdCurrencyCd" name= "gdbdCurrencyCd">
						<input id="gdbdCurrency" name="gdbdCurrency"  style="width: 160px; border: none; float: left; height: 13px;" type="text"  readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCurrency" alt="Go" style="float: right;" /> <!-- dren 07.16.2015 : SR 0017729 -->
					</div>
				</td>
				<td class="rightAligned" style="width: 150px;">Foreign Curr Amt</td>
				<td class="leftAligned">
					<input type="text" id="gdbdForeignCurrAmt" name="gdbdForeignCurrAmt" style="width: 200px; text-align: right" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 140px;">Currency Rt</td>
				<td class="leftAligned">
					<input type="text" id="gdbdCurrencyRt" name="gdbdCurrencyRt" style="width: 181px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned" style="width: 80px;">Old Deposit Amt</td>
				<td class="leftAligned">
					<input type="text" id="gdbdOldDepositAmt" name="gdbdOldDepositAmt" style="width: 200px; text-align: right" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Adjusting Amt</td>
				<td class="leftAligned">
					<input type="text" id="gdbdAdjustingAmt" name="gdbdAdjustingAmt" style="width: 181px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned" style="width: 80px;">Remarks</td>
				<td class="leftAligned" colspan="5">
					<div style="border: 1px solid gray; width: 400px; height: 21px; float: left;">
						<input style="width: 373px; float: left; border: none; height: 13px;" id="gdbdRemarks" name="gdbdRemarks" type="text" value="" readonly="readonly" maxlength="4000"/>  <!-- added readonly - Halley 11.21.13 -->
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGdbdRemarks" />
					</div>
				</td>
			</tr>
		</table>
		<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
			<tr >
				<td class="rightAligned" style="width: 62px"><input type="button" class="button" id="btnAddGDBD" name="btnSaveGDBD" value="Add" style="width: 60px;" /></td>
				<td class="leftAligned"  style="width: 62px"><input type="button" class="disabledButton" id="btnDeleteGDBD" name="btnDeleteGDBD" value="Delete" style="width: 60px;" disabled="disabled"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">

	// page item triggers
	
	/*$("editGdbdRemarks").observe("click", function() {
		showEditor("gdbdRemarks", 4000);
	});*/ //commented out, transferred to closeDCB.jsp - Halley 11.21.13
	
	var  adjustAmt = null;
	var localAmt = null;
	$("gdbdAdjustingAmt").observe("focus", function(){
		adjustAmt = this.value;
		localAmt = $("gdbdLocalCurrAmt").value;
	});
	
	$("gdbdAdjustingAmt").observe("change", function(){
		$("gdbdLocalCurrAmt").value = formatCurrency(parseFloat(unformatCurrencyValue(nvl($F("gdbdOldDepositAmt"),0))) + parseFloat(unformatCurrencyValue(nvl($F("gdbdAdjustingAmt"),0))));
		if (parseFloat(nvl(unformatCurrencyValue($F("gdbdOldDepositAmt")), "0")) != 0) {
			 if (parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) > parseFloat(unformatCurrencyValue(nvl($F("controlDspGicdSumAmt"), "0")))) {
				showMessageBox("Amount for deposit should not be greater than total collection.", imgMessage.INFO);
				$("gdbdLocalCurrAmt").value = localAmt;
				$("gdbdAdjustingAmt").value = adjustAmt;
				return false;
			}

			if (parseFloat(nvl($("gdbdLocalCurrAmt").value, "0")) < 0) {
				showMessageBox("Negative amount not allowed.", imgMessage.INFO);
				$("gdbdLocalCurrAmt").value = localAmt;
				$("gdbdAdjustingAmt").value = adjustAmt;
				return false;
			}

			if (parseFloat(unformatCurrencyValue(nvl(localAmt, "0"))) != parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0")))) {
				if (($F("gdbdCurrencyCd") != "" && $F("gdbdCurrencyRt") != "")) {
					new Ajax.Request(contextPath+"/GIACAccTransController?action=getGdbdAmtWhenValidate", {
						evalScripts: true,
						asynchronous: false,
						method: "GET",
						parameters: {
							gfunFundCd: $F("gaccGfunFundCd"),
							gibrBranchCd: $F("gaccGibrBranchCd"),
							dcbDate: $F("gaccDspDCBDate"),
							dcbYear: $F("gaccDspDCBYear"),
							dcbNo: $F("gaccDspDCBNo"),
							payMode: $F("gdbdDepositType"),
							currencyCd: $F("gdbdCurrencyCd"),
							currencyRt: $F("gdbdCurrencyRt")
						},
						onComplete: function(response) {
							if (checkErrorOnResponse(response)) {
								$("varTotAmtForGicdSumRec").value = response.responseText;
							}
						}
					});

					if (parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) > parseFloat(nvl($F("varTotAmtForGicdSumRec"),"0"))) {
						showMessageBox("Amount for deposit should not be greater than total collection for this pay mode, currency and currency rate.",imgMessage.INFO);
						$("gdbdLocalCurrAmt").value = localAmt;
						$("gdbdAdjustingAmt").value = adjustAmt;
						return false;
					}
				}
			}
		}
		
		if (parseFloat(unformatCurrencyValue(nvl(localAmt, "0"))) != parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0")))) {
			if((parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) > 0 || parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) == 0 
						&& parseFloat(unformatCurrencyValue(nvl($F("gdbdOldDepositAmt"),0))) != 0) && (($F("gdbdCurrencyCd") != "" && $F("gdbdCurrencyRt") != "0"))){
				$("gdbdForeignCurrAmt").value = formatCurrency(parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) / parseFloat($F("gdbdCurrencyRt")));
			}
		}
	});
</script>
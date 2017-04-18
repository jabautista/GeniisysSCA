<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Transaction Basic Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="directTransMainDiv" name="directTransMainDiv" style="margin-top: 1px;">
	<div style="float: left;" id="directTransDiv" name="directTransDiv">
		<form id="itemInformationForm" name="itemInformationForm">
			<div class="sectionDiv" style="border-bottom: none;">
				<!-- variables -->
				<!-- temporary value -->
				<!-- comment out by jerome orio 09.29.2010 please use acctgOrParametersForm for global variables
				<input type="hidden" id="globalGaccTranId" 		name="globalGaccTranId" 	value="${gaccTranId}"  />
				<input type="hidden" id="globalGaccBranchCd"	name="globalGaccBranchCd" 	value="${gaccBranchCd}"/> 
				<input type="hidden" id="globalGaccFundCd" 		name="globalGaccFundCd" 	value="${gaccFundCd}"  />
	-->
				  
				<input type="hidden" id="meanOpFlag" name="meanOpFlag" value="${meanOpFlag }"/>
				<input type="hidden" id="collectionAmt" name="collectionAmt" value="${collectionDtl.fCurrencyAmt }"/>
				<input type="hidden" id="defaultModAccessTag" name="defaultModAccessTag" value="${defModAccessTag}"/>
				<input type="hidden" id="vFlag" name="vFlag" value="${vFlag}"/>
				<input type="hidden" id="tranDate" name="tranDate" value="${tranDate}"/>
				<input type="hidden" id="gfunFundCd" name="gfunFundCd" value="${gfunFundCd}"/>
				<input type="hidden" id="transCurrCd" name="transCurrCd" value="${currDtls[0].code}"/>
				<input type="hidden" id="transCurrRt" name="transCurrRt" value="${currDtls[0].valueFloat}"/>
				<input type="hidden" id="transCurrDesc" name="transCurrDesc" value="${currDtls[0].valueString}"/>
				<input type="hidden" id="hidRiCommTag" name="hidRiCommTag" value="${riCommTag}"/>
				
				<table align="center" border="0" id="mainTranBasicInfo">
					<tr>
						<td style="width: 100%;" colspan="2">&nbsp</td>
					</tr>
					<tr>
						<td class="leftAligned" style="width: 4%;"></td>
						<td class="leftAligned" style="width: 9%; font-size: 11px;"> <label id="lblFundCd">Fund Code</label></td>
						<td class="leftAligned" style="width: 6%; font-size: 11px;"> <label id="lblBranch">Branch</label></td>
						<td class="leftAligned" style="width: 13%; font-size: 11px;"><label id="lblTranNo">Transaction No.</label></td>
						<td class="leftAligned" style="width: 11%; font-size: 11px;"><label id="lblOrNo">OR No.</label></td>
						<td class="leftAligned" style="width: 11%; font-size: 11px;"><label id="lblOrStatus">OR Status</label></td>
						<td class="leftAligned" style="width: 11%; font-size: 11px;"><label id="lblOrDate">OR Date</label></td>
						<td class="leftAligned" style="width: 32%;" colspan="4"></td>
					</tr>
					<tr>
						<td class="leftAligned" style="width: 4%;"></td>
						<td class="leftAligned" style="width: 11%;"><input type="text" style="width: 80%" id="fundCd" name="fundCd" value="${orderOfPayment.gibrGfunFundCd }" readonly="readonly" /> -</td>
						<td align="center" style="width: 7.5%;"><input type="text" style="width: 90%" id="branch" name="branch" value="${orderOfPayment.gibrBranchCd }" readonly="readonly" /></td>
						<td align="center" style="width: 15%;"><input type="text" style="width: 95%" id="transactionNo" name="transactionNo" value="${orderOfPayment.transactionNo }" readonly="readonly" /></td>
						<td align="center" style="width: 17%;"><input type="text" style="width: 95%" id="orNo" name="orNo" value="${orderOfPayment.orNo }" readonly="readonly" class="rightAligned list"/></td>
						<td align="center" style="width: 7%;"><input type="text" style="width: 90%" id="orStatus" name="orStatus" value="${meanORFlag }" readonly="readonly" /></td>
						<td align="center" style="width: 11%;"><input type="text" style="width: 95%" id="orDate" name="orDate" value="${orderOfPayment.orDate }" readonly="readonly" /></td>
						<td class="rightAligned" style="width: 7%;" id="lblAmount">Amount</td>
						<td align="center" style="width: 6%;"><input type="text" style="width: 80%" id="grossAmtCurrency" name="grossAmtCurrency" value="${currDtls[0].shortName}" readonly="readonly" /></td> 
						<td align="center" style="width: 20%;"><input type="text" id="grossAmt" name="grossAmt" value="
							<c:if test="${orderOfPayment.grossTag eq 'Y' }">
									${collectionDtl.fcGrossAmt}
							</c:if>
							<c:if test="${orderOfPayment.grossTag eq 'N' }"> 
									${collectionDtl.fCurrencyAmt}
							</c:if>
						" class="money"/ readonly="readonly"> 
						</td>
						<td class="leftAligned" style="width: 3%;"></td>
					</tr>
					<tr>
						<td id="payorText" class="rightAligned" style="width: 4%;">Payor</td>
						<td class="leftAligned" style="width: 61%;" colspan="6"><input type="text" style="width: 99%" id="payor" name="payor" value="${orderOfPayment.payor }" readonly="readonly" /></td>
						<td class="rightAligned" style="width: 7%;"><label id="lblLocAmt" style="margin:0; padding:0; text-align: right;">Local Amount</label></td>	
						<td align="center" style="width: 6%;"><input type="text" style="width: 80%" id="fCurrency" name="fCurrency" value="${currDtls[0].desc}" readonly="readonly" /></td> 
						<td align="center" style="width: 17%;"><input type="text" class="money" id="fCurrencyAmt" name="fCurrencyAmt" readonly="readonly" value="
							<c:choose>
								<c:when test="${orderOfPayment.grossTag eq 'N'}">
									${collectionDtl.amt }
								</c:when>
								<c:otherwise>
									${collectionDtl.grossAmt }
								</c:otherwise>
							</c:choose>
						"/></td>
					</tr>
				</table>
				<table align="center" border="0" id="pdcBasicInfo" style="display: none; margin-top: 10px;">
					<tr>
						<td colspan="8">
							<table align="center" border="0">
								<tr>
									<td class="rightAligned" style="width:60px;">Fund</td>
									<td class="leftAligned" style="width:350px;">
										<input type="text" id="txtGiacs032FundCd" name="txtGiacs032FundCd" ignoreDelKey="1" style="width: 50px; height: 15px;" class="allCaps " maxlength="50" readonly="readonly" />
										<input type="text" id="txtGiacs032FundDesc" name="txtGiacs032FundCd" ignoreDelKey="1" style="width: 280px; height: 15px;" class="allCaps " maxlength="50" readonly="readonly"/>
									</td>
									<td class="rightAligned" style="width:60px;">Branch</td>
									<td class="leftAligned" style="width:350px;">
										<input type="text" id="txtGiacs032BranchCd" name="txtGiacs032BranchCd" ignoreDelKey="1" style="width: 50px;  height: 15px;" class="allCaps " maxlength="20" readonly="readonly" />
										<input type="text" id="txtGiacs032BranchName" name="txtGiacs032BranchName" ignoreDelKey="1" style="width: 220px; height: 15px;" class="allCaps " maxlength="20" readonly="readonly"  />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="leftAligned" style="width: 8%; font-size: 11px;">&nbsp;</td>
						<td class="leftAligned" style="width: 10.5%; font-size: 11px;"><label id="lblFundCd">Ref No.</label></td>
						<td class="leftAligned" style="width: 10.5%; font-size: 11px;"><label id="lblBranch">Bank</label></td>
						<td class="leftAligned" style="width: 10.5%; font-size: 11px;"><label id="lblTranNo">Check No.</label></td>
						<td class="leftAligned" style="width: 10.5%; font-size: 11px;"><label id="lblOrNo">Check Date</label></td>
						<td class="rightAligned" style="width: 10.5%; font-size: 11px;"><label id="lblOrStatus">Amount</label></td>
						<td class="rightAligned" style="width: 10.5%; font-size: 11px;"><label id="lblOrDate">Total PDC Amount</label></td>
						<td class="leftAligned" style="width: 8%; font-size: 11px;">&nbsp;</td>
					</tr>
					<tr>
						<td class="leftAligned">&nbsp;</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032RefNo" name="txtGiacs032RefNo" readonly="readonly" />
						</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032Bank" name="txtGiacs032Bank" readonly="readonly" />
						</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032CheckNo" name="txtGiacs032CheckNo" readonly="readonly" />
						</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032CheckDate" name="txtGiacs032CheckDate" readonly="readonly" />
						</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032Amount" name="txtGiacs032Amount" readonly="readonly" class="rightAligned"  />
						</td>
						<td class="leftAligned" style="font-size: 11px;">
							<input type="text" style="width: 95%" id="txtGiacs032Total" name="txtGiacs032Total" readonly="readonly" class="rightAligned" />
						</td>
						<td class="leftAligned">&nbsp;</td>
					</tr>
				</table>
				<!-- GIACS004 TABS TONIO 07/28/2010 -->
				<div id="tabComponentsDiv1" class="tabComponents1" style="margin-top: 5px;">
					<ul>
						<li class="tab1 selectedTab1"><a id="directTransac">Direct Trans</a></li>
						<li class="tab1"><a id="riTrans">RI Trans</a></li>
						<li class="tab1"><a id="otherTrans">Other Trans</a></li>
						<li class="tab1"><a id="opPreview">OR Preview</a></li>
						<li class="tab1"><a id="acctEntries">Accounting Entries</a></li>
					</ul>
				</div>
				<div class="tabBorderBottom1"></div>
				<div id="directTransMenu" name="subMenuDiv" align="center" style="width: 100%; margin-bottom: 0px; float: left; <c:if test="${defModAccessTag eq '0'}">display: none; </c:if>">
					<div id="tabComponentsDiv2" class="tabComponents2" style="float: left;">
						<ul>
							<li class="tab2 selectedTab2"><a id="directTransTab1">Direct Premiums</a></li>
							<li class="tab2"><a id="directTransTab2">Premium Deposit</a></li>
							<li class="tab2"><a id="directTransTab3">Loss Recoveries</a></li>
							<li class="tab2"><a id="directTransTab4">Direct Claim Payts</a></li>
							<li class="tab2"><a id="directTransTab5">Commission Payts</a></li>
							<li class="tab2"><a id="directTransTab6">Input Vat</a></li>
							<li class="tab2"><a id="directTransTab7">Overriding Comm</a></li>
						</ul>			
					</div>
					<div class="tabBorderBottom2"></div>
				</div>
				<div id="riTransMenu" name="subMenuDiv" align="center" style="display: none; margin-bottom: 0px; float: left; width: 100%;" class="subMenuDivs">
					<div id="tabComponentsDiv2" class="tabComponents2" style="float: left;">
						<ul>
							<li class="tab2"><a id="riTransTab1">Inw Facul Prem Collns</a></li>
							<li class="tab2"><a id="riTransTab2">Losses Recov from RI</a></li>
							<li class="tab2"><a id="riTransTab3">Facul Claim Payts</a></li>
							<li class="tab2"><a id="riTransTab4">Out Facul Prem Payts</a></li>
						</ul>			
					</div>
					<div class="tabBorderBottom2"></div>
				</div>
				<div id="otherTransMenu" name="subMenuDiv" align="center" style="display: none; margin-bottom: 0px; float: left; width: 100%;" class="subMenuDivs">
					<div id="tabComponentsDiv2" class="tabComponents2" style="float: left;">
						<ul>
							<li class="tab2"><a id="otherTransTab1">Collns for Other Off</a></li>
						<!--<li class="tab2"><a id="otherTransTab2">Bank Collns</a></li> commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013-->
							<li class="tab2"><a id="otherTransTab3">Unspecified Collns</a></li>
							<li class="tab2"><a id="otherTransTab4">Tax Payments</a></li>
							<li class="tab2"><a id="otherTransTab5">Withholding Tax</a></li>
							<li class="tab2"><a id="otherTransTab6">Others</a></li>
							<li class="tab2"><a id="otherTransTab7"></a></li>				
						</ul>			
					</div>
					<div class="tabBorderBottom2"></div>
				</div>
				<div id="opPrev" name="subMenuDiv" align="center" style="display: none; margin-bottom: 0px; float: left;" class="subMenuDivs">
					<table align="left" border="0" style="margin-left: 15px; margin-top: 5px;">	
						<tr>
							<td style="width: 900px;"></td>
						</tr>
					</table>
				</div>
				<div id="acctEntry" name="subMenuDiv" align="center" style="display: none; margin-bottom: 0px; float: left;" class="subMenuDivs">
					<table align="left" border="0" style="margin-left: 15px; margin-top: 5px;">	
						<tr>
							<td style="width: 900px;"></td>
						</tr>
					</table>
				</div>
			</div>
			<!-- GIACS004 TABS TONIO 07/28/2010 -->
			<div id="transBasicInfoSubpage" name="transBasicInfoSubpage">
			</div>			
<!--		hide the ff during deploy	START	-->
			<div id="tabPanelContainer">
				
			</div>
<!--		hide the ff during deploy   END		-->
<!--		<div id="premiumDepositMainButtons" align="center" style="margin: 10px;"> -->
<!--				<div class="buttonsDiv" style="float:left; width: 100%;">			-->
<!--					<input type="button" style="width: 80px;" id="btnCancel" name="btnCancel"	class="button" value="Cancel" />-->
<!--					<input type="button" style="width: 80px;" id="btnSave" 	name="btnSave" 		class="button" value="Save" />-->
<!--				</div>  -->
<!--		</div> -->
		</form>
	</div>
</div>
<div id="dummyClaimPayeeDiv" style="display: none;"> <!-- added by steven 09.22.2014 -->
</div>

<script type="text/javaScript">
	
	/* remove comments when each tab has been added
	// This ajax.Responder notifies the user that a javascript process is ongoing
	var accountingResponder = {
		onCreate: function() {
		   showNotice("Processing Information...");
		},
		onComplete: function() {
		   hideNotice("SUCCESS");
		   Effect.Fade("notice", {			
			   duration : .001
		   });	
		}
	};
	
	//Ajax.Responders.register(accountingResponder);
	
	*/

	/*	addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
	*/

	//$("btnCancel").observe("click", showOrInfo);
	
	objCurrPostDatedCheck = [];
	
	$("orNo").value = '${orderOfPayment.orNo }' == '' ? '' :  parseFloat('${orderOfPayment.orNo }').toPaddedString(10); //added by robert 11.07.2013
	
	function setCurrentTab1(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	function setCurrentTab2(id){
		$$("div.tabComponents2 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab2");					
			}else{
				a.up("li").removeClassName("selectedTab2");	
			}	
		});
	}

	// main menu's
	/*$("directTransac").observe("click", function(){
		setSubMenuDivs();
		objACGlobal.tranClass = '1';	
      	$("directTransTab1").innerHTML = 'Direct Premiums';
		$("directTransTab2").innerHTML = 'Premium Deposit';
		$("directTransTab3").innerHTML = 'Loss Recoveries';	
		$("directTransTab4").innerHTML = 'Direct Claim Payts';	
		$("directTransTab5").innerHTML = 'Commission Payts';	
		$("directTransTab6").innerHTML = 'Input Vat';	
		$("directTransTab7").innerHTML = 'Overriding Comm'; 
		if ($F("defaultModAccessTag") != '0'){
			$("directTransMenu").show();			
			fireEvent($("directTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab
			//showDirectPremiumCollns();
			//getDirectPremiumCollns(); //alfie 12.01.2010
			loadDirectPremCollnsForm();  //alfie 12.07.2010
		}else{
			showMessageBox("You are not allowed to access this module.", imgMessage.ERROR);
		}
	});*/
	function showDirectTransac(){
		setSubMenuDivs();
		objACGlobal.tranClass = '1';
      	$("directTransTab1").innerHTML = 'Direct Premiums';
		$("directTransTab2").innerHTML = 'Premium Deposit';
		$("directTransTab3").innerHTML = 'Loss Recoveries';
		$("directTransTab4").innerHTML = 'Direct Claim Payts';
		$("directTransTab5").innerHTML = 'Commission Payts';	
		$("directTransTab6").innerHTML = 'Input Vat';	
		$("directTransTab7").innerHTML = 'Overriding Comm'; 
		if ($F("defaultModAccessTag") != '0'){
			$("directTransMenu").show();			
			fireEvent($("directTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab
			//showDirectPremiumCollns();
			//getDirectPremiumCollns(); //alfie 12.01.2010
			//loadDirectPremCollnsForm();  //alfie 12.07.2010			
		}else{
			showMessageBox("You are not allowed to access this module.", imgMessage.ERROR);
		}
	}
	observeAccessibleModule(accessType.MENU, "GIACS007", "directTransac", function(){setCurrentTab1("directTransac"); showDirectTransac();});

	/*$("riTrans").observe("click", function(){
		setSubMenuDivs();
		$("riTransTab1").innerHTML = 'Inw Facul Prem Collns';
		$("riTransTab2").innerHTML = 'Losses Recov from RI';
		$("riTransTab3").innerHTML = 'Facul Claim Payts';
		$("riTransTab4").innerHTML = 'Out Facul Prem Payts';
		$("riTransMenu").show();
		//showRiTransInwFaculPremCollns();
		fireEvent($("riTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab
	});*/
	function showRiTrans(){
		setSubMenuDivs();
		$("riTransTab1").innerHTML = 'Inw Facul Prem Collns';
		$("riTransTab2").innerHTML = 'Losses Recov from RI';
		$("riTransTab3").innerHTML = 'Facul Claim Payts';
		$("riTransTab4").innerHTML = 'Out Facul Prem Payts';
		$("riTransMenu").show();
		//showRiTransInwFaculPremCollns();
		//fireEvent($("riTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab //commented-out by steven 09.01.2014
		//added by steven 09.01.2014
		if(checkUserModule("GIACS008")){
			fireEvent($("riTransTab1"), "click");
		}else{
			disableMenu("riTransTab1");
			if(checkUserModule("GIACS009")){
				fireEvent($("riTransTab2"), "click");
			}else{
				disableMenu("riTransTab2");
				if(checkUserModule("GIACS018")){
					fireEvent($("riTransTab3"), "click");
				}else{
					disableMenu("riTransTab3");
					if(checkUserModule("GIACS019")){
						fireEvent($("riTransTab4"), "click");
					}else{
						disableMenu("riTransTab3");
					}
				}
			}
		}
	}	
	//observeAccessibleModule(accessType.MENU, "GIACS008", "riTrans", function(){setCurrentTab1("riTrans"); showRiTrans();});  //commented-out by steven 09.01.2014
	$("riTrans").observe("click", function(){
		setCurrentTab1("riTrans"); 
		showRiTrans();
	});

	/*$("otherTrans").observe("click", function(){
		setSubMenuDivs();
		$("otherTransTab1").innerHTML = 'Collns for Other Off';
        $("otherTransTab2").innerHTML = 'Bank Collns';
        $("otherTransTab3").innerHTML = 'Unspecified Collns';
        $("otherTransTab4").innerHTML = 'Tax Payments';
        $("otherTransTab5").innerHTML = 'Withholding Tax';
        $("otherTransTab6").innerHTML = 'Others';
        $("otherTransTab7").innerHTML = 'PDC Collections';
		$("otherTransMenu").show();
		fireEvent($("otherTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab
	});*/
	function showOtherTrans(){
		setSubMenuDivs();
		$("otherTransTab1").innerHTML = 'Collns for Other Off';
        //$("otherTransTab2").innerHTML = 'Bank Collns'; commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013
        $("otherTransTab3").innerHTML = 'Unspecified Collns';
        $("otherTransTab4").innerHTML = 'Tax Payments';
        $("otherTransTab5").innerHTML = 'Withholding Tax';
        $("otherTransTab6").innerHTML = 'Others';
        $("otherTransTab7").innerHTML = 'PDC Collections';
		$("otherTransMenu").show();
		if(objACGlobal.previousModule == "GIACS070"){	//shan 08.29.2013
			if(objACGlobal.tranSource == "DV" && objACGlobal.callingForm == "DISB_REQ"){
				fireEvent($("otherTransTab4"), "click");
				$$("div.tabComponents2 a").each(function(a){
					if(a.id == "otherTransTab4") {
						$("otherTransTab4").up("li").addClassName("selectedTab2");					
					}else{
						a.up("li").removeClassName("selectedTab2");	
					}					
				});
			}
		}else if(objACGlobal.previousModule == "GIACS002"){
			if(objACGlobal.callingForm == "DETAILS" || objACGlobal.callingForm == "GIACS004"){
				fireEvent($("otherTransTab4"), "click");
				$$("div.tabComponents2 a").each(function(a){
					if(a.id == "otherTransTab4") {
						$("otherTransTab4").up("li").addClassName("selectedTab2");					
					}else{
						a.up("li").removeClassName("selectedTab2");	
					}
				});
			}
		} else if(objACGlobal.previousModule == "GIACS032"){
			fireEvent($("otherTransTab7"), "click");
			$$("div.tabComponents2 a").each(function(a){
				if(a.id == "otherTransTab7") {
					$("otherTransTab7").up("li").addClassName("selectedTab2");					
				}else{
					a.up("li").removeClassName("selectedTab2");	
				}
			});
		}else {
			fireEvent($("otherTransTab1"), "click"); // andrew - 10.12.2010 - added this function call to fire the event click of the default tab
		}
			
	}	
	
	observeAccessibleModule(accessType.MENU, "GIACS012", "otherTrans", function(){setCurrentTab1("otherTrans"); showOtherTrans();});

	/*$("opPreview").observe("click", function(){
		setSubMenuDivs();
		$("opPrev").show();
		showORPreview();
	});*/
	if(objACGlobal.tranSource == "OP" || objACGlobal.tranSource == "OR"){ // andrew - added condition when to show the OR Preview tab 4.29.2013
		$("opPreview").up("li", 0).show();
		function showOpPreview(){
			setSubMenuDivs();
			$("opPrev").show();
			showORPreview();
		}	
		observeAccessibleModule(accessType.MENU, "GIACS025", "opPreview", function(){setCurrentTab1("opPreview"); showOpPreview();});
	} else {
		$("opPreview").up("li", 0).hide();
	}
	
	/*$("acctEntries").observe("click", function(){
		setSubMenuDivs();
		$("acctEntry").show();
		showAcctEntries();
	});*/
	function showAccountingEntries(){
		setSubMenuDivs();
		//$("acctEntry").show(); commented out by C.Santos 06.05.2012
		showAcctEntries();
	}
	observeAccessibleModule(accessType.MENU, "GIACS030", "acctEntries", function(){setCurrentTab1("acctEntries"); showAccountingEntries();});
	//End Main Menu's

	//directTransac Sub Menu's
	//$("directTransTab1").observe("click", showDirectPremiumCollns);	
	//$("directTransTab1").observe("click", getDirectPremiumCollns); //alfie
	/*$("directTransTab1").observe("click", loadDirectPremCollnsForm); //alfie
	$("directTransTab2").observe("click", showPremDep);
	$("directTransTab3").observe("click", showDirectTransLossRecoveries);
	$("directTransTab4").observe("click", showDirectClaimPayments);
	$("directTransTab5").observe("click", showDirectTransCommPayts);
	$("directTransTab6").observe("click", showDirectTransInputVat);
	$("directTransTab7").observe("click", showDirectTransOverridingComm);*/
	observeAccessibleModule(accessType.MENU, "GIACS007", "directTransTab1", function(){setCurrentTab2("directTransTab1"); loadDirectPremCollnsForm();});
	observeAccessibleModule(accessType.MENU, "GIACS026", "directTransTab2", function(){setCurrentTab2("directTransTab2"); showPremDepListing();});
	observeAccessibleModule(accessType.MENU, "GIACS010", "directTransTab3", function(){setCurrentTab2("directTransTab3"); showDirectTransLossRecoveries();});
	observeAccessibleModule(accessType.MENU, "GIACS017", "directTransTab4", function(){setCurrentTab2("directTransTab4"); showDirectClaimPayments();});
	observeAccessibleModule(accessType.MENU, "GIACS020", "directTransTab5", function(){setCurrentTab2("directTransTab5"); showDirectTransCommPayts();});
	observeAccessibleModule(accessType.MENU, "GIACS039", "directTransTab6", function(){setCurrentTab2("directTransTab6"); showDirectTransInputVat();});
	observeAccessibleModule(accessType.MENU, "GIACS040", "directTransTab7", function(){setCurrentTab2("directTransTab7"); showDirectTransOverridingComm();});
	
	//riTransac Sub Menu's
	/*$("riTransTab1").observe("click", showRiTransInwFaculPremCollns);
	$("riTransTab2").observe("click", showRiTransLossesRecovFromRi);
	$("riTransTab3").observe("click", showRITransFacultativeClaimPayts);
	$("riTransTab4").observe("click", showRITransOutFaculPremPayts);*/
	observeAccessibleModule(accessType.MENU, "GIACS008", "riTransTab1", function(){setCurrentTab2("riTransTab1"); showRiTransInwFaculPremCollns();});
	observeAccessibleModule(accessType.MENU, "GIACS009", "riTransTab2", function(){setCurrentTab2("riTransTab2"); showRiTransLossesRecovFromRi();});
	observeAccessibleModule(accessType.MENU, "GIACS018", "riTransTab3", function(){setCurrentTab2("riTransTab3"); showRITransFacultativeClaimPayts();});
	observeAccessibleModule(accessType.MENU, "GIACS019", "riTransTab4", function(){setCurrentTab2("riTransTab4"); showRITransOutFaculPremPayts();});
	
	//otherTransac Sub Menu's
	/*$("otherTransTab1").observe("click", showCollnsForOtherOffices);
	$("otherTransTab3").observe("click", showUnidentifiedCollection);
	$("otherTransTab5").observe("click", showOtherTransWithholdingTax);*/
	observeAccessibleModule(accessType.MENU, "GIACS012", "otherTransTab1", function(){setCurrentTab2("otherTransTab1"); showCollnsForOtherOffices();});
	//observeAccessibleModule(accessType.MENU, "GIACS013", "otherTransTab2", function(){setCurrentTab2("otherTransTab2"); null;}); //added by steven 11.21.2013 - the module is not yet converted, i added this function so that it will check if it is web-enable. commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013
	observeAccessibleModule(accessType.MENU, "GIACS014", "otherTransTab3", function(){setCurrentTab2("otherTransTab3"); showUnidentifiedCollection();});
	observeAccessibleModule(accessType.MENU, "GIACS021", "otherTransTab4", function(){setCurrentTab2("otherTransTab4"); showTaxPayments();});
	observeAccessibleModule(accessType.MENU, "GIACS022", "otherTransTab5", function(){setCurrentTab2("otherTransTab5"); showOtherTransWithholdingTax();});
	observeAccessibleModule(accessType.MENU, "GIACS015", "otherTransTab6", function(){setCurrentTab2("otherTransTab6"); showOtherCollection();});	//added by: kenneth L. 06.08.2012
	observeAccessibleModule(accessType.MENU, "GIACS031", "otherTransTab7", function(){setCurrentTab2("otherTransTab7"); showGiacs031();});	//john 9.18.2014
	
	function initializeDirectTransTabs() {
		$$("label.acctTransLbl").each(function (m) {
			m.observe("click", function ()	{
				if	(m.style.backgroundColor != '#F0F0F0') {
					$$("label.acctTransLbl").each(function (m) {
						m.style.backgroundColor = '#C0C0C0';
					});	
					m.style.backgroundColor = '#F0F0F0';
				}else {
					m.style.backgroundColor = '#C0C0C0';
				}
			});
		});	
	}

	/*
	*	
	*	
	*/
	function setSubMenuDivs() {
		$$("div[name='subMenuDiv']").each(function(row){
			row.hide();
		});
		
		/*// andrew - 10.12.2010 - commented this block
		$$("label.acctTransLbl").each(function (m) {
			m.style.backgroundColor = '#C0C0C0';
		});
		$("directTransTab1").style.backgroundColor = '#F0F0F0';
		$("riTransTab1").style.backgroundColor = '#F0F0F0';
		$("otherTransTab1").style.backgroundColor = '#F0F0F0';*/
			
		objACGlobal.tranClass = '0';
	}
	
	function initializeMenuValues(){
		if($("hidRiCommTag").value == "Y"){
			disableTab2("directTransac");
			disableTab2("riTrans");
			disableTab2("otherTrans");
		}
		if (objACGlobal.callingForm == 'DETAILS') {
			if (objACGlobal.tranSource == 'DV'){
				if (objACGlobal.documentName == 'CLM_PAYT_REQ_DOC' || objACGlobal.documentName == 'BATCH_CSR_DOC' || objACGlobal.documentName == 'COMM_PAYT_DOC'){
					$("directTransTab1").innerHTML = 'Direct Premiums';
					$("directTransTab2").innerHTML = 'Premium Deposit';
					$("directTransTab3").innerHTML = 'Loss Recoveries';	
					$("directTransTab4").innerHTML = 'Direct Claim Payts';	
					$("directTransTab5").innerHTML = 'Commission Payts';	
					$("directTransTab6").innerHTML = 'Input Vat';	
					$("directTransTab7").innerHTML = 'Overriding Comm'; 
					
					//added by Kris 05.24.2013
					$("directTransTab4").click();
					if(objACGlobal.documentName == "COMM_PAYT_DOC"){
						$("directTransTab5").click();
					}
				}else if (objACGlobal.documentName == 'FACUL_RI_PREM_PAYT_DOC'){
					$("riTransTab1").innerHTML = 'Inw Facul Prem Collns';
					$("riTransTab2").innerHTML = 'Losses Recov from RI';
					$("riTransTab3").innerHTML = 'Facul Claim Payts';
					$("riTransTab4").innerHTML = 'Out Facul Prem Payts';
					objACGlobal.tranClass = '2';
					
					$("riTrans").click(); //added by Halley 12.05.13
					$("riTransTab4").click(); //added by Kris 05.24.2013
				}else {
			        $("otherTransTab1").innerHTML = 'Collns for Other Off';
			        //$("otherTransTab2").innerHTML = 'Bank Collns'; commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013
			        $("otherTransTab3").innerHTML = 'Unspecified Collns';
			        $("otherTransTab4").innerHTML = 'Tax Payments';
			        $("otherTransTab5").innerHTML = 'Withholding Tax';
			        $("otherTransTab6").innerHTML = 'Others';
			        $("otherTransTab7").innerHTML = '';
			        objACGlobal.tranClass = '3';
			       
			      	//added by Kris 05.24.2013
			        $("otherTrans").click();	
			      	//$("otherTransTab4").click(); // comment out by andrew - event is fired twice, causing double execution of buttons event
				}
			}else {
				if (objACGlobal.implSwParam == 'Y'){
					if (objACGlobal.withPdc == 'Y'){
		                $("otherTransTab1").innerHTML = 'Collns for Other Off';
				        //$("otherTransTab2").innerHTML = 'Bank Collns'; commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013
				        $("otherTransTab3").innerHTML = 'Unspecified Collns';
				        $("otherTransTab4").innerHTML = 'Tax Payments';
				        $("otherTransTab5").innerHTML = 'Withholding Tax';
				        $("otherTransTab6").innerHTML = 'Others';
				        $("otherTransTab7").innerHTML = 'PDC Collections';
				        objACGlobal.tranClass = '3';
					}else{
						$("directTransTab1").innerHTML = 'Direct Premiums';
						$("directTransTab2").innerHTML = 'Premium Deposit';
						$("directTransTab3").innerHTML = 'Loss Recoveries';	
						$("directTransTab4").innerHTML = 'Direct Claim Payts';	
						$("directTransTab5").innerHTML = 'Commission Payts';
						$("directTransTab6").innerHTML = 'Input Vat';	
						$("directTransTab7").innerHTML = 'Overriding Comm'; 
					}
				}
			}
		}else if (objACGlobal.callingForm == 'DISB_REQ'){
			if (objACGlobal.tranSource == 'DV' && objACGlobal.previousModule != "GIACS016"){	//added by shan 08.28.2013 for GIACS070
				$("otherTransTab1").innerHTML = 'Collns for Other Off';
		        //$("otherTransTab2").innerHTML = 'Bank Collns'; commented out by CarloR SR 5567 07.05.2016 remove tab for giacs013
		        $("otherTransTab3").innerHTML = 'Unspecified Collns';
		        $("otherTransTab4").innerHTML = 'Tax Payments';
		        $("otherTransTab5").innerHTML = 'Withholding Tax';
		        $("otherTransTab6").innerHTML = 'Others';
		        $("otherTransTab7").innerHTML = '';
		        //objACGlobal.tranClass = '3';
		       
		        $("otherTrans").click();
		      	//$("otherTransTab4").click();
			}
		}else if (objACGlobal.callingForm == 'ACCT_ENTRIES') {
			$("directTransTab1").innerHTML = 'Direct Premiums';
			$("directTransTab2").innerHTML = 'Premium Deposit';
			$("directTransTab3").innerHTML = 'Loss Recoveries';	
			$("directTransTab4").innerHTML = 'Direct Claim Payts';	
			$("directTransTab5").innerHTML = 'Commission Payts';	
			$("directTransTab6").innerHTML = 'Input Vat';	
			$("directTransTab7").innerHTML = 'Overriding Comm'; 
		}else {
			$("directTransTab1").innerHTML = 'Direct Premiums';
			$("directTransTab2").innerHTML = 'Premium Deposit';
			$("directTransTab3").innerHTML = 'Loss Recoveries';	
			$("directTransTab4").innerHTML = 'Direct Claim Payts';	
			$("directTransTab5").innerHTML = 'Commission Payts';	
			$("directTransTab6").innerHTML = 'Input Vat';	
			$("directTransTab7").innerHTML = 'Overriding Comm'; 
		}
	}	

	$("orDate").value = dateFormat($("orDate").value, "mm/dd/yyyy");
	
	// exit menu for acct transaction - nok
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function () {
		if(objACGlobal.previousModule == "GIACS003"){//added by steven 04.09.2013
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;
			
		}else if(objACGlobal.previousModule == "GIACS071"){ // added by Kris 04.11.2013
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS002"){
			if (objGIACS002.fromGIACS054){	// added condition : shan 09.26.2014
				$("disbursementVoucherMainDiv").show();
				$("dvDetailsDiv").hide();
			}else {
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}
		}else if(objACGlobal.previousModule == "GIACS016"){ // added by Kris 05.17.2013
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){ //added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS032"){ //added john 9.26.2014
			$("giacs031MainDiv").hide();
			$("giacs032MainDiv").show();
			$("mainNav").hide();
		} else{
			if(changeTag == 1) {
				if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
					changeTag = 0;
					changeTagFunc = "";
					editORInformation(); 
				}else{
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
							function(){
								changeTagFunc(); 
								if (changeTag == 0){
									changeTagFunc = "";
									editORInformation(); 
								}
							}, 
							function(){
								changeTag = 0;
								changeTagFunc = "";
								editORInformation(); 
							}, 
							"");
				}	
			}else{
				changeTag = 0;
				changeTagFunc = "";
				editORInformation(); 
			}
		}
	});
	
	if(objACGlobal.previousModule == "GIACS003"){//added by steven 04.10.2013
		formatAcctEntriesField();
	}

	if(objACGlobal.previousModule == "GIACS071" ){
		populateAccountingEntriesForMemo();
	} else if(objACGlobal.previousModule == "GIACS002"){
		populateAcctEntriesForDV();
		/* if(objACGlobal.callingForm == "DETAILS"){
			showOtherTrans();
		} */
	} else if(objACGlobal.previousModule == "GIACS016"){
		objACGlobal.populateAcctEntriesForDisb();
		//objACGlobal.onClickDVDetails();
	}else if(objACGlobal.previousModule == "GIACS070"){
		if (objACGlobal.tranSource == "JV"){
			formatAcctEntriesField();
		}else if(objACGlobal.tranSource == "DV"){
			populateTaxPaymentForJournalVoucher();			
		}
	} else if(objACGlobal.previousModule == "GIACS032"){
		setCurrentTab1("otherTrans");
		showOtherTrans();
		$("mainTranBasicInfo").hide();
		$("pdcBasicInfo").show();
		pdcDisplayInfo();
	}
	
	//added john 10.16.2014
	function pdcDisplayInfo(){
		$("txtGiacs032RefNo").value = objGIAC032.refNo;
		$("txtGiacs032Bank").value = objGIAC032.bankSname;
		$("txtGiacs032CheckNo").value = objGIAC032.checkNo;
		$("txtGiacs032CheckDate").value = objGIAC032.checkDate;
		$("txtGiacs032Amount").value = formatCurrency(objGIAC032.amount);
		$("txtGiacs032Total").value = formatCurrency(objGIAC032.amount);
		$("txtGiacs032FundCd").value = $F("txtFundCdPdc");
		$("txtGiacs032FundDesc").value = $F("txtFundDesc");
		$("txtGiacs032BranchCd").value = $F("txtBranchCdPdc");
		$("txtGiacs032BranchName").value = $F("txtBranchName");
	}
	
	initializeDirectTransTabs();
	checkSelectedMenu();
	initializeMenuValues();
	initializeFormLabels();
	initializeAllMoneyFields();
	initializeTabs(); // andrew - 10.11.2010 - added this function call;
		
</script>
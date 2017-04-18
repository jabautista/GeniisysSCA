<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="polMainInfoMainDiv" name="polMainInfoMainDiv">
	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="back">Back</a></li>
				</ul>
			</div>
		</div>
	</div>	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="printPageId">Policy Information</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="mainInfoSectionDiv" class="sectionDiv" style="margin:3px auto 50px auto;">
		<input type="hidden" id="hidPolicyId" name="hidPolicyId">
		<input type="hidden" id="hidLineCd" name="hidLineCd">
		<input type="hidden" id="hidIssCd" name="hidIssCd">
		<input type="hidden" id="hidModuleId" name="hidModuleId" value='${moduleId}' /> <!-- added by Kris 02.20.2013 -->
		<input type="hidden" id="hidExtractId" name="hidExtractId">
		<input type="hidden" id="hidDspRate" name="hidDspRate"/> <!-- added by Kris 03.14.2013 for policyLeadOverlay -->
		<input type="hidden" id="hidPackPolFlag" name="hidPackPolFlag"/>
		
		<div id="polMainInfoDiv">
			<div id="polNoDiv" class="toolbar">
				<h3 id="ctrPolNo" style="margin:2.5px auto auto auto;font-weight:bold;" align="center">POLNO</h3>
			</div>
			<div id="polAssuredDiv" style="margin:10px 5px 5px auto;">
				<div style="width:98%;margin-left:2%;">
					<table style="width: 100%">
						<tr>
							<td>Assured:</td>
							<td><input type="text" id="txtAssuredName" name="txtAssuredName" style="width:400px;" readonly="readonly"/></td>
							<td style="text-align: right;"><label id="lblAcctOf">In Acct. Of:</label></td>
							<td style="width: 250px;"><input type="text" id="txtAcctOf" readonly="readonly" style="width: 250px; float: right; text-align: right;"/></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div id="tabComponentsDiv2" class="tabComponents1" style="align:center;width:100%">
			<ul>
				<li class="tab1 selectedTab1" style="width:16%"><a id="basicInfoTab">Basic Information</a></li>
				<li class="tab1" style="width:14.5%"><a id="itemInfoTab">Item Info/Perils</a></li>
				<li class="tab1" style="width:14.5%"><a id="warrClausesTab">Warr & Clauses</a></li>
				<li class="tab1" style="width:14.5%"><a id="billGroupTab">Bill Group</a></li>
				<li class="tab1" style="width:14.5%"><a id="premiumCollTab">Premium Coll</a></li>
				<li class="tab1" style="width:14.5%"><a id="claimsTab">Claims</a></li>				
			</ul>			
		</div>
		<div class="tabBorderBottom1"></div>

		<div id="tabPageContents" name="tabPageContents" style="width: 100%; float: left;">	
			<div id="tabBasicInfoContents" name="tabBasicInfoContents" style="width: 100%; float: left;"></div>
			<div id="tabItemInfoPerilsContents" name="tabItemInfoPerilsContents" style="width: 100%; float: left;"></div>
			<div id="tabWarrClausesContents" name="tabWarrClausesContents" style="width: 100%; float: left;"></div>
			<div id="tabBillGroupContents" name="tabBillGroupContents" style="width: 100%; float: left;"></div>
			<div id="tabPremiumCollContents" name="tabPremiumCollContents" style="width: 100%; float: left;"></div>
			<div id="tabClaimsContents" name="tabClaimsContents" style="width: 100%; float: left;"></div>
		</div>
	</div>
	<div>
		<div id="itemPerilDiv" style="margin:auto auto auto auto;width:100%;float:left;"></div>
	</div>
</div>

<script>
	//initialization
	var objPolMain = JSON.parse('${policyMainInfo}'.replace(/\\/g, '\\\\'));
	var moduleId = '${moduleId}';
	setModuleId(moduleId);
	initializeTabs();
	
	//Modified by Apollo Cruz 12.10.2014 - added objPolMain.menuLineCd, removed the comment in disableTab("billGroupTab")
	if(objPolMain.lineCd == "SU" || getLineCd(objPolMain.lineCd) == "SU" || objPolMain.menuLineCd == "SU"){	
		disableTab("itemInfoTab");
		disableTab("warrClausesTab");
		disableTab("billGroupTab");
	}
	
	$("hidPolicyId").value		=	 nvl(objPolMain.policyId, -1); // modified by Kris 02.18.2013
	$("hidExtractId").value		=	 objPolMain.extractId; 			// added by Kris 02.26.2013
	$("hidLineCd").value		=	 objPolMain.lineCd;
	$("hidIssCd").value			= 	 objPolMain.issCd;
	$("txtAssuredName").value 	=	 unescapeHTML2(objPolMain.assdName); //added by steven 9/12/2012
	$("txtAcctOf").value = unescapeHTML2(objPolMain.acctOf);
	
	objUW.lineCd = $F("hidLineCd"); //Added by Jerome Bautista SR 21374 01.15.2016
	objUW.issCd = $F("hidIssCd");
	
	if($F("txtAcctOf").trim() == ""){
		$("lblAcctOf").hide();
		$("txtAcctOf").hide();
	}
	
	if(objPolMain.endorsementNo == null){
		$("ctrPolNo").innerHTML 	=	 objPolMain.polNo;	
	}else{
		$("ctrPolNo").innerHTML 	=	 objPolMain.polNo+" - "+objPolMain.endorsementNo;
	}
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100(); // kris 02.18.2013
	
	function initializeGIPIS100(){
		//initalizing the basic info subPage
		new Ajax.Updater("tabBasicInfoContents","GIPIPolbasicController?action=showInfoBasic",{
			method:"get",
			evalScripts: true,
			parameters:{
				policyId : $F("hidPolicyId"),
				lineCd   : $F("hidLineCd"),
				issCd	 : $F("hidIssCd")
			}
		});
		$("tabBasicInfoContents").show();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").hide();
		$("tabClaimsContents").hide();
		$("itemPerilDiv").hide();
		
		if(objPolMain.sublineMopSw == "Y"){
			disableTab("itemInfoTab");
		}
	}
	
	//tab actions
	$("basicInfoTab").observe("click", function () {
		var controllerPath = moduleId != "GIPIS101" ? "GIPIPolbasicController?action=showInfoBasic" : contextPath+"/GIXXPolbasicController?action=showPolicySummary";
		
			if($("policyInfoBasicMainDiv") == null){
			//new Ajax.Updater("tabBasicInfoContents","GIPIPolbasicController?action=showInfoBasic",{
			new Ajax.Updater("tabBasicInfoContents", controllerPath,{
				method:"get",
				evalScripts: true,
				parameters:{
					policyId : $F("hidPolicyId"),
					lineCd   : $F("hidLineCd")
				}
			});
		}
		$("tabBasicInfoContents").show();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").hide();
		$("tabClaimsContents").hide();
		$("itemPerilDiv").hide();
		returnMainInfoDivAttribute();
	});
	
	$("itemInfoTab").observe("click", function () {
		if($("policyItemInfoMainDiv") == null){
			new Ajax.Updater("tabItemInfoPerilsContents","GIPIItemMethodController?action=showItemInfo",{
				method:"get",
				evalScripts: true
			});
			
		}
				
		$("tabBasicInfoContents").hide();
		$("tabItemInfoPerilsContents").show();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").hide();
		$("itemPerilDiv").show();
		$("tabClaimsContents").hide();
	});
	
	$("warrClausesTab").observe("click", function () {
		if($("policyWarrClauseMainDiv") == null){
			new Ajax.Updater("tabWarrClausesContents","GIPIPolwcController?action=showWarrClauses",{
				method:"get",
				evalScripts: true
			});
			
		}
		$("tabBasicInfoContents").hide();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").show();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").hide();
		$("tabClaimsContents").hide();
		$("itemPerilDiv").hide();
		returnMainInfoDivAttribute();
	});
	
	$("billGroupTab").observe("click", function () {		
		if($("policyBillGroupMainDiv") == null){
			new Ajax.Updater("tabBillGroupContents","GIPIPolbasicController?action=showPolicyBillGroup",{
				method:"get",
				evalScripts: true
			});
		}
		$("tabBasicInfoContents").hide();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").show();
		$("tabPremiumCollContents").hide();
		$("tabClaimsContents").hide();
		$("itemPerilDiv").hide();
		returnMainInfoDivAttribute();
	});
	
	$("premiumCollTab").observe("click", function () {
		if($("policyPremCollDiv") == null){
			new Ajax.Updater("tabPremiumCollContents","GIPIInvoiceController?action=showPremiumColl",{
				method:"get",
				evalScripts: true,
				parameters:{policyId : $F("hidPolicyId")}
			});
		}
		$("tabBasicInfoContents").hide();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").show();
		$("tabClaimsContents").hide();
		$("itemPerilDiv").hide();
		returnMainInfoDivAttribute();
	});
	
	$("claimsTab").observe("click", function () {
		if($("policyClaimsMainDiv") == null){
			new Ajax.Updater("tabClaimsContents","GICLClaimsController?action=showClaims",{
				method:"get",
				evalScripts: true,
				parameters:{
					policyId : $F("hidPolicyId"),
					lineCd   : $F("hidLineCd")
				}
			});
		}
		$("tabBasicInfoContents").hide();
		$("tabItemInfoPerilsContents").hide();
		$("tabWarrClausesContents").hide();
		$("tabBillGroupContents").hide();
		$("tabPremiumCollContents").hide();
		$("tabClaimsContents").show();
		$("itemPerilDiv").hide();
		returnMainInfoDivAttribute();
	});

	//exit
	$("back").observe("click", function () {
		if(objGIPIS100.fromEndtType == "Y"){
			showByEndorsementTypePage();
			$("polMainInfoDiv").hide();
			$("endtTypeDiv").show();
		}else if(objGIPIS100.callingForm == "GIPIS000" || objGIPIS100.callingForm == "GIPIS130"){						
			if(objGIPIS100.prevDocumentTitle == "Policies by Assured in Account Of"){
				objGIPIS100.prevDocumentTitle = "";
				showByAssuredAcctOfPage();
			} else if(objGIPIS100.prevDocumentTitle == "Policies by Obligee"){
				objGIPIS100.prevDocumentTitle = "";
				showByObligeePage();
			} else if(objGIPIS100.prevDocumentTitle == "Policies by Assured"){
				objGIPIS100.prevDocumentTitle = "";
				showByAssuredPage();
			} else {
				$("polMainInfoDiv").innerHTML = "";
				$("viewPolInfoMainDiv").show();
				setDocumentTitle("View Policy Information"); // added by: Nica to returm title and moduleId of GIPIS100
				setModuleId("GIPIS100");
			}
		} else if(objGIPIS100.callingForm == "GIPIS199"){ // added by Kris 01.24.2014 to return to GIPIS199
			showViewPolicyInformationPage(objGIPIS199.policyId);
		} else if(objGIPIS100.callingForm == "GIACS000"){ // added by gab 08.17.2015
			if(objGIPIS100.prevDocumentTitle == "Policies by Assured in Account Of"){
				objGIPIS100.prevDocumentTitle = "";
				showByAssuredAcctOfPage();
			} else if(objGIPIS100.prevDocumentTitle == "Policies by Obligee"){
				objGIPIS100.prevDocumentTitle = "";
				showByObligeePage();
			} else if(objGIPIS100.prevDocumentTitle == "Policies by Assured"){
				objGIPIS100.prevDocumentTitle = "";
				showByAssuredPage();
			} else {
				$("polMainInfoDiv").innerHTML = "";
				$("viewPolInfoMainDiv").show();
				setDocumentTitle("View Policy Information");
				setModuleId("GIPIS100");
			}
		} else { // dren 09.23.2015 SR 0020443 : Back Button not working - Start
			$("polMainInfoDiv").innerHTML = "";
			$("viewPolInfoMainDiv").show();
			setDocumentTitle("View Policy Information"); 
			setModuleId("GIPIS100");
		} // dren 09.23.2015 SR 0020443 : Back Button not working - End
	});
	
	// START OF METHODS for GIPIS101
	// added by Kris 02.18.2013 
	function initializeGIPIS101(){
		new Ajax.Updater("tabBasicInfoContents",contextPath+"/GIXXPolbasicController?action=showPolicySummary",{
			method: "POST",
			parameters: {
				lineCd		: $F("txtLineCd"),
				sublineCd	: $F("txtSublineCd"),
				issCd		: $F("txtIssCd"),
				issueYy		: $F("txtIssueYy"),
				polSeqNo	: $F("txtPolSeqNo"),
				renewNo		: $F("txtRenewNo"),
				refPolNo	: $F("txtRefPolNo")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Getting Policy Summary Information page, please wait..."),
			onComplete: function () {
				hideNotice();
				setDocumentTitle("Policy Summary Information");
			}
		});
		
		disableTab("billGroupTab");  
		disableTab("premiumCollTab");
		
		if(objPolMain.sublineCd == objPolMain.varSublineMop){
			disableTab("itemInfoTab");
			disableTab("warrClausesTab");
		}/*else if(objPolMain.lineCd == "SU"){
			disableTab("itemInfoTab");
			disableTab("warrClausesTab");
		} else {
			//enableTab("itemInfoTab");
			//enableTab("warrClausesTab");
		}*/
	}
	
	//added by gab 05.24.2016 SR 21694
	if (objCLMGlobal.callingForm == "GICLS260"){
		objCLMGlobal.callingForm = "GIPIS100";
		$("claimsTab").click();
	}

</script>
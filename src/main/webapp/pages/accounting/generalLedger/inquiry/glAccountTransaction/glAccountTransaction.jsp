<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="glAcctTranMainDiv" style="height: 680px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>	
		
	<div id="glAcctTranDiv" name="glAcctTranDiv">	
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>GL Account Transaction</label>				
			</div>
		</div>	
		<div id="glAcctTranHeaderDiv">
			<div class="sectionDiv" style="height: 50px;">
				<table id="glCodeTbl" align="center" style="padding-top: 5px;">
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">GL Account Code</td>
						<td style="padding-right: 5px;">
							<input id="hidGlAcctId" type="hidden">
							<input id="hidGlAcctType" type="hidden">
							<input id="txtGlAcctCat" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="1" style="width: 20px; padding-right: 3px;" tabindex="101"> 
							<input id="txtGlCtrlAcct" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="102" > 
							<input id="txtGlSubAcct1" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="103" > 
							<input id="txtGlSubAcct2" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="104" > 
							<input id="txtGlSubAcct3" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="105" > 
							<input id="txtGlSubAcct4" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="106" > 
							<input id="txtGlSubAcct5" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="107" > 
							<input id="txtGlSubAcct6" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="108" > 
							<input id="txtGlSubAcct7" name="glAcctTxt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;"  tabindex="109">	
							<img id="searchGLAcctLOV" alt="GL Account No" style="height: 17px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						</td>
						<td class="rightAligned" style="padding: 0 5px 0 10px;">GL Account Name</td>
						<td><input id="txtGlAcctName" type="text" readonly="readonly" style="width:360px;" tabindex="-1"></td>
					</tr>
				</table>
			</div>
			
			<div id="inputDiv" class="sectionDiv" style="height: 100px;">
				<table style="padding: 15px 0 0 50px; float: left">
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Company</td>
						<td> 
							<input id="hidGfunFundCd" type="hidden">
							<input id="hidFundCd" type="hidden">
							<input id="hidFundDesc" type="hidden">
							<span class="lovSpan required" style="width: 280px; ">
								<input id="txtCompany" name="txtCompany" class="upper required" type="text" style="width: 250px; float: left; border: none; height: 13px; margin: 0px;" tabindex="110">
								<img id="searchCompanyLOV" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Branch</td>
						<td> 
							<input id="hidBranchCd" type="hidden">
							<input id="hidBranchName" type="hidden">
							<span class="lovSpan required" style="width: 280px;">
								<input id="txtBranch" name="txtBranch" type="text" class="upper required" style="width: 250px; float: left; border: none; height: 13px; margin: 0px;" tabindex="111">
								<img id="searchBranchLOV" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
							</span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input id="chkTranOpen" type="checkbox" value="N" style="float: left;" tabindex="112"><label for="chkTranOpen" style="margin: 2px 0 4px 0">&nbsp Exclude open transactions</label>
						</td>
					</tr>
				</table>
				
				<table style="float: right; padding: 15px 0px 0 0; width: 480px;">
					<tr>						
						<td class="rightAligned" style="padding-right: 5px;">Period Covered</td>
						<td>
							<div id="dateDiv" name="dateDiv" style="width: 350px;">
								<div id="fromDateDiv" name="fromDateDiv" class="required" style="float: left; border: 1px solid gray; width: 156px; height: 20px; ">
									<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="rightAligned required" maxlength="10" style="border: none; float: left; width: 131px; height: 13px; margin: 0px;" value="" tabindex="113" />
									<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />
								</div>
								<label style="float: left; padding-top: 5px;">&nbsp&nbsp to &nbsp&nbsp</label>
								<div id="toDateDiv" name="toDateDiv" class="required" style="float: left; border: 1px solid gray; width: 155px; height: 20px; ">
									<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="rightAligned required" maxlength="10" style="border: none; float: left; width: 130px; height: 13px; margin: 0px;" value="" tabindex="114" />
									<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />
								</div>
							</div>
						</td>
					</tr>
				</table>
				<div style="float: right;">
					<fieldset style="height: 34px; width: 335px; margin-right: 22px;">
						<legend>Based On</legend>
						<input id="tranDateRB" name="dateBasisRG" type="radio" value="1" title="Tran Date" checked="checked" style="float: left; margin-left: 80px;"><label for="tranDateRB" style="margin: 2px 0 4px 0">Tran Date</label>
						<input id="postedDateRB" name="dateBasisRG" type="radio" value="2" title="Date Posted" style="float: left; margin-left: 30px;" ><label for="postedDateRB" style="margin: 2px 0 4px 0">Date Posted</label>
					</fieldset>
				</div>
			</div>
		</div>	
		
		<div id="glTransactionDiv" class="sectionDiv" style="height: 520px;">
			<jsp:include page="/pages/accounting/generalLedger/inquiry/glAccountTransaction/subpages/glAcctTranTableGrid.jsp"></jsp:include>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	initializeAccordion();
	initializeAll();
	setModuleId("GIACS230");
	setDocumentTitle("GL Account Inquiry");

	objACGlobal.previousModule = "GIACS230";
	objACGlobal.callingForm = "GIACS230";
	hideToolbarButton("btnToolbarPrint");
	
	/*function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIISUserController?action=checkUserAccessGiacs&moduleId=GIACS230",{
				method: "GET",
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
						}); 
					}
				}
			});
		}catch (e){
			showErrorMessage("checkUserAccess", e);
		}
	}*/
	
	
	function showGLAcctLOV(isIconClicked){
		var glSubAcct7 = $F("txtGlSubAcct7").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct7").trim(), 2);
		var glSubAcct6 = $F("txtGlSubAcct6").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct6").trim(), 2) + (glSubAcct7 == "" ? "%" : "");
		var glSubAcct5 = $F("txtGlSubAcct5").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct5").trim(), 2) + (glSubAcct6 == "" ? "%" : "");
		var glSubAcct4 = $F("txtGlSubAcct4").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct4").trim(), 2) + (glSubAcct5 == "" ? "%" : "");
		var glSubAcct3 = $F("txtGlSubAcct3").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct3").trim(), 2) + (glSubAcct4 == "" ? "%" : "");
		var glSubAcct2 = $F("txtGlSubAcct2").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct2").trim(), 2) + (glSubAcct3 == "" ? "%" : "");
		var glSubAcct1 = $F("txtGlSubAcct1").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlSubAcct1").trim(), 2) + (glSubAcct2 == "" ? "%" : "");
		var glCtrlAcct = $F("txtGlCtrlAcct").trim() == "" ? "" : "-" + formatNumberDigits($F("txtGlCtrlAcct").trim(), 2) + (glSubAcct1 == "" ? "%" : "");
		var glAcctCat = $F("txtGlAcctCat").trim() == "" ? "%" : formatNumberDigits($F("txtGlAcctCat").trim(), 2) + (glCtrlAcct == "" ? "%" : "");
		
		var glAcctNo = glAcctCat + glCtrlAcct + glSubAcct1 + glSubAcct2 + glSubAcct3 + glSubAcct4 + glSubAcct5 + glSubAcct6 + glSubAcct7;
		
		var searchString = isIconClicked ? '%' : glAcctNo /* ($F("txtGlAcctCat").trim() == "" ? "%" : $F("txtGlAcctCat")) */;
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {action: 'getGlAcctsGIACS230LOV',
							glAcctCat:	isIconClicked ? "" : $F("txtGlAcctCat"),
							glCtrlAcct:	isIconClicked ? "" : $F("txtGlCtrlAcct"),
							glSubAcct1:	isIconClicked ? "" : $F("txtGlSubAcct1"),
							glSubAcct2:	isIconClicked ? "" : $F("txtGlSubAcct2"),
							glSubAcct3:	isIconClicked ? "" : $F("txtGlSubAcct3"),
							glSubAcct4:	isIconClicked ? "" : $F("txtGlSubAcct4"),
							glSubAcct5:	isIconClicked ? "" : $F("txtGlSubAcct5"),
							glSubAcct6:	isIconClicked ? "" : $F("txtGlSubAcct6"),
							glSubAcct7:	isIconClicked ? "" : $F("txtGlSubAcct7"),
							searchString: searchString,
							page:		1 },
			title: 'List of GL Accounts',
			width: 550,
			height: 350,
			draggable: true,
			autoSelectOneRecord : true,
			filterText : searchString,
			columnModel: [
	              {
	            	  id: 'glAcctId',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glAcctType',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glAcctCategory',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glControlAcct',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct1',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct2',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct3',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct4',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct5',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct6',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glSubAcct7',
	            	  width: '0px',
	            	  visible: false
	              },
	              {
	            	  id: 'glAcctNo',
	            	  width: '250px',
	            	  title: 'GL Acct No.'
	              },
	              {
	            	  id: 'glAcctName',
	            	  width: '300px',
	            	  title: 'GL Account Name'
	              }
			],
			onSelect: function(row){
				$("hidGlAcctId").value = row.glAcctId;
				$("hidGlAcctType").value = row.glAcctType;
				$("txtGlAcctCat").value = row.glAcctCategory;
				$("txtGlCtrlAcct").value = row.glControlAcct;
				$("txtGlSubAcct1").value = row.glSubAcct1;
				$("txtGlSubAcct2").value = row.glSubAcct2;
				$("txtGlSubAcct3").value = row.glSubAcct3;
				$("txtGlSubAcct4").value = row.glSubAcct4;
				$("txtGlSubAcct5").value = row.glSubAcct5;
				$("txtGlSubAcct6").value = row.glSubAcct7;
				$("txtGlSubAcct7").value = row.glSubAcct7;
				$("txtGlAcctCat").setAttribute("lastValidValue", row.glAcctCategory);
				$("txtGlCtrlAcct").setAttribute("lastValidValue", row.glControlAcct);
				$("txtGlSubAcct1").setAttribute("lastValidValue", row.glSubAcct1);
				$("txtGlSubAcct2").setAttribute("lastValidValue", row.glSubAcct2);
				$("txtGlSubAcct3").setAttribute("lastValidValue", row.glSubAcct3);
				$("txtGlSubAcct4").setAttribute("lastValidValue", row.glSubAcct4);
				$("txtGlSubAcct5").setAttribute("lastValidValue", row.glSubAcct5);
				$("txtGlSubAcct6").setAttribute("lastValidValue", row.glSubAcct6);
				$("txtGlSubAcct7").setAttribute("lastValidValue", row.glSubAcct7);
				$("txtGlAcctName").value = unescapeHTML2(row.glAcctName);
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			},

			onUndefinedRow : function(){
				$("txtGlAcctCat").value = $("txtGlAcctCat").readAttribute("lastValidValue");
				$("txtGlCtrlAcct").value = $("txtGlCtrlAcct").readAttribute("lastValidValue");
				$("txtGlSubAcct1").value = $("txtGlSubAcct1").readAttribute("lastValidValue");
				$("txtGlSubAcct2").value = $("txtGlSubAcct2").readAttribute("lastValidValue");
				$("txtGlSubAcct3").value = $("txtGlSubAcct3").readAttribute("lastValidValue");
				$("txtGlSubAcct4").value = $("txtGlSubAcct4").readAttribute("lastValidValue");
				$("txtGlSubAcct5").value = $("txtGlSubAcct5").readAttribute("lastValidValue");
				$("txtGlSubAcct6").value = $("txtGlSubAcct6").readAttribute("lastValidValue");
				$("txtGlSubAcct7").value = $("txtGlSubAcct7").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, focus);
			},
			onCancel: function(){
				$("txtGlAcctCat").focus();
				$("txtGlAcctCat").value = $("txtGlAcctCat").readAttribute("lastValidValue");
				$("txtGlCtrlAcct").value = $("txtGlCtrlAcct").readAttribute("lastValidValue");
				$("txtGlSubAcct1").value = $("txtGlSubAcct1").readAttribute("lastValidValue");
				$("txtGlSubAcct2").value = $("txtGlSubAcct2").readAttribute("lastValidValue");
				$("txtGlSubAcct3").value = $("txtGlSubAcct3").readAttribute("lastValidValue");
				$("txtGlSubAcct4").value = $("txtGlSubAcct4").readAttribute("lastValidValue");
				$("txtGlSubAcct5").value = $("txtGlSubAcct5").readAttribute("lastValidValue");
				$("txtGlSubAcct6").value = $("txtGlSubAcct6").readAttribute("lastValidValue");
				$("txtGlSubAcct7").value = $("txtGlSubAcct7").readAttribute("lastValidValue");
			}
		});
	}
	
	function showGIACS230FundLOV(isIconClicked) {
		var searchString = isIconClicked ? '%' : ($F("txtCompany").trim() == "" ? "%" : $F("txtCompany"));
		
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACSInquiryFundLOV",
				company: searchString,
				page : 1
			},
			title : "List of Companies",
			width : 370,
			height : 400,
			columnModel : [ {
				id : "fundCd",
				title : "Company Cd",
				width : '100px'
			}, {
				id : "fundDesc",
				title : "Company Name",
				width : '235px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : searchString,
			onSelect : function(row) {
				$("hidFundCd").value = row.fundCd;
				$("hidFundDesc").value = row.fundDesc;
				$("txtCompany").value = row.fundCd + " - " + row.fundDesc;
				$("txtCompany").setAttribute("lastValidValue", $F("txtCompany"));
				
			},
			onUndefinedRow : function(){
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, focus);
			},
			onCancel: function(){
				$("txtCompany").focus();
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
			}
		});
	}
	
	function showGIACS230BranchLOV(isIconClicked){
		var searchString = isIconClicked ? '%' : ($F("txtBranch").trim() == "" ? "%" : $F("txtBranch"));
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {action:		'getGIACS230BranchLOV',
							gfunFundCd:	$F("hidFundCd"),
							moduleId:	'GIACS230',
							searchString: searchString,
							page:		1 },
			title:	'List of Branches',
			width : 370,
			height : 400,
			columnModel: [
	              {
	        		id: 'branchCd',
	        		title: 'Branch Code',
	        		width: '100px'
	              },
	              {
	            	id: 'branchName',
	            	title: 'Branch Name',
	            	width: '235px'
	              }
	        ],
			draggable: true,
			filterText: escapeHTML2(searchString),
			autoSelectOneRecord: true,
			onSelect: function(row){
				//$("hidGfunFundCd").value = row.gfunFundCd;
				$("hidBranchCd").value = row.branchCd;
				$("hidBranchName").value = row.branchName;
				$("txtBranch").value = row.branchCd + " - " + row.branchName;
				$("txtBranch").setAttribute("lastValidValue", $F("txtBranch"));
			},
			onUndefinedRow : function(){
				/*$("hidBranchCd").value = null;
				$("hidBranchName").value = null;
				$("txtBranch").value = "";*/
				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
				disableToolbarButton("btnToolbarExecuteQuery");
				customShowMessageBox("No record selected.", imgMessage.INFO, focus);
			},
			onCancel: function(){
				$("txtBranch").focus();
				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
			}			
		});	
	}
	
	function executeQuery(){
		try{
			objGIACS230.fieldVals.push({glAcctId:	$F("hidGlAcctId"),
										glAcctType:	$F("hidGlAcctType"),
										glAcctCat:	$F("txtGlAcctCat"),
										glCtrlAcct:	$F("txtGlCtrlAcct"),
										glSubAcct1:	$F("txtGlSubAcct1"),
										glSubAcct2:	$F("txtGlSubAcct2"),
										glSubAcct3:	$F("txtGlSubAcct3"),
										glSubAcct4:	$F("txtGlSubAcct4"),
										glSubAcct5:	$F("txtGlSubAcct5"),
										glSubAcct6:	$F("txtGlSubAcct6"),
										glSubAcct7:	$F("txtGlSubAcct7"),
										glAcctName:	$F("txtGlAcctName"),
										fundCd:		$F("hidFundCd"),
										company:	$F("txtCompany"),
										branchCd:	$F("hidBranchCd"),
										branchName:	$F("hidBranchName"),
										tranOpen:	$F("chkTranOpen") });
			
			objGIACS230.glTransURL = "&moduleId=GIACS230&glAcctId="+$F("hidGlAcctId")+"&glAcctType="+$F("hidGlAcctType")
								     +"&glAcctCat="+$F("txtGlAcctCat")+"&glCtrlAcct="+$F("txtGlCtrlAcct")+"&gfunFundCd="+$F("hidFundCd")
									 +"&branchCd="+$F("hidBranchCd")+"&dtBasis="+objGIACS230.dt_basis+"&fromDate="+$F("txtFromDate")
									 +"&toDate="+ $F("txtToDate")+"&tranOpenFlg="+tranOpenFlg;
			
			if (objGIACS230.multiSort != "" && objGIACS230.multiSort != null){
				objGIACS230.glTransURL = objGIACS230.glTransURL +"&multiSort="+objGIACS230.multiSort;
			}
			glTransTG.url = contextPath+"/GIACInquiryController?action=showGLAccountTransaction"+objGIACS230.glTransURL+"&refresh=1";
			glTransTG._refreshList();
			disableToolbarButton("btnToolbarExecuteQuery");
		}catch(e){
			showErrorMessage("executeQuery", e);
		}
	}
	
	function resetForm(){
		$("txtGlAcctCat").setAttribute("lastValidValue", "");
		$("txtGlCtrlAcct").setAttribute("lastValidValue", "");
		$("txtGlSubAcct1").setAttribute("lastValidValue", "");
		$("txtGlSubAcct2").setAttribute("lastValidValue", "");
		$("txtGlSubAcct3").setAttribute("lastValidValue", "");
		$("txtGlSubAcct4").setAttribute("lastValidValue", "");
		$("txtGlSubAcct5").setAttribute("lastValidValue", "");
		$("txtGlSubAcct6").setAttribute("lastValidValue", "");
		$("txtGlSubAcct7").setAttribute("lastValidValue", "");
		$("hidGlAcctId").value = "";
		$("hidGlAcctType").value = "";
		$("txtGlAcctCat").value = "";
		$("txtGlCtrlAcct").value = "";
		$("txtGlSubAcct1").value = "";
		$("txtGlSubAcct2").value = "";
		$("txtGlSubAcct3").value = "";
		$("txtGlSubAcct4").value = "";
		$("txtGlSubAcct5").value = "";
		$("txtGlSubAcct6").value = "";
		$("txtGlSubAcct7").value = "";
		$("txtGlAcctName").value = "";
		$("hidFundCd").value = "";
		$("txtCompany").value = "";
		$("hidBranchCd").value = "";
		$("hidBranchName").value = "";
		$("txtFromDate").clear();
		$("txtToDate").clear();
		$("txtBranch").value = "";
		$("chkTranOpen").checked = false;
		$("chkTranOpen").value = "N";
		tranOpenFlg = "N";
		objGIACS230.fieldVals = [];
		objGIACS230.sl_exists = 0;
		objGIACS230.glTransURL = null;
		objGIACS230.slSummaryURL = null;
		toggleGIACS230Buttons(false);
		toggleGIACS230Fields(true);
		$("txtGlAcctCat").focus();
		glTransTG.url = contextPath+"/GIACInquiryController?action=showGLAccountTransaction&refresh=1&multiSort="+objGIACS230.multiSort;
		glTransTG._refreshList();
	}
	
	
	//checkUserAccess();
	
	
	$("txtFromDate").value = objGIACS230.from_date;
	$("txtToDate").value = objGIACS230.to_date;
	//objGIACS230.glTransURL = contextPath + "/GIACInquiryController?action=showGLAccountTransaction&refresh=1";
	
	var tranOpenFlg = $F("chkTranOpen") == null? "N" : $F("chkTranOpen");	
	if(tranOpenFlg == "Y"){
		$("chkTranOpen").checked = true;
	}else{
		$("chkTranOpen").checked = false;
	}
	
	$$("div#glAcctTranHeaderDiv input[type='text']").each(function(txt){
		txt.observe("change", function(){
			if (txt.value == ""){
				disableToolbarButton("btnToolbarEnterQuery");
			}else{
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
	$$("input[name='glAcctTxt']").each(function(txt){
		txt.observe("change", function(){
			if (txt.id == "txtGlAcctCat"){
				$(txt).value = formatNumberDigits($F(txt), 1);
			}else{
				$(txt).value = formatNumberDigits($F(txt), 2);
			}
			
			if (txt.id == "txtGlSubAcct7" && ($F("txtGlCtrlAcct") != $("txtGlCtrlAcct").readAttribute("lastValidValue") || $F("txtGlAcctCat") != $("txtGlAcctCat").readAttribute("lastValidValue") 
												|| $F("txtGlSubAcct1") != $("txtGlSubAcct1").readAttribute("lastValidValue") || $F("txtGlSubAcct2") != $("txtGlSubAcct2").readAttribute("lastValidValue")  
												|| $F("txtGlSubAcct3") != $("txtGlSubAcct3").readAttribute("lastValidValue") || $F("txtGlSubAcct4") != $("txtGlSubAcct4").readAttribute("lastValidValue") 
												|| $F("txtGlSubAcct5") != $("txtGlSubAcct5").readAttribute("lastValidValue") || $F("txtGlSubAcct6") != $("txtGlSubAcct6").readAttribute("lastValidValue") 
												|| $F("txtGlSubAcct7") != $("txtGlSubAcct7").readAttribute("lastValidValue") )){
				showGLAcctLOV(false);
			}
		});
		
		txt.observe("keydown", function(e){
			if (e.keyCode == 13){
				showGLAcctLOV(false);
			}
		});
	});
	
	if (objGIACS230.dt_basis == null || objGIACS230.dt_basis == ""){
		objGIACS230.dt_basis = $F("tranDateRB");
	}else{
		if (objGIACS230.dt_basis == 1){
			$("tranDateRB").checked = true;
		}else{
			$("postedDateRB").checked = true;
		}
	}
	
	/*$("txtGlAcctCat").observe("change", function(){
		$("txtGlAcctCat").value = formatNumberDigits($F("txtGlAcctCat"), 1);
	});
	
	$("txtGlCtrlAcct").observe("change", function(){
		$("txtGlCtrlAcct").value = formatNumberDigits($F("txtGlCtrlAcct"), 2);
	});
	
	$("txtGlSubAcct1").observe("change", function(){
		$("txtGlSubAcct1").value = formatNumberDigits($F("txtGlSubAcct1"), 2);
	});
	
	$("txtGlSubAcct2").observe("change", function(){
		$("txtGlSubAcct2").value = formatNumberDigits($F("txtGlSubAcct2"), 2);
	});
	
	$("txtGlSubAcct3").observe("change", function(){
		$("txtGlSubAcct3").value = formatNumberDigits($F("txtGlSubAcct3"), 2);
	});
	
	$("txtGlSubAcct4").observe("change", function(){
		$("txtGlSubAcct4").value = formatNumberDigits($F("txtGlSubAcct4"), 2);
	});
	
	$("txtGlSubAcct5").observe("change", function(){
		$("txtGlSubAcct5").value = formatNumberDigits($F("txtGlSubAcct5"), 2);
	});
	
	$("txtGlSubAcct6").observe("chnage", function(){
		$("txtGlSubAcct6").value = formatNumberDigits($F("txtGlSubAcct6"), 2);
	});
	
	$("txtGlSubAcct7").observe("change", function(){
		$("txtGlSubAcct7").value = formatNumberDigits($F("txtGlSubAcct7"), 2);
		//showGLAcctLOV();
	});*/
	
	
	$("acExit").observe("click",function(){
		objACGlobal.previousModule = null;
		objACGlobal.callingForm = null;
		objGIACS230.fieldVals = [];
		objGIACS230.from_date = null;
		objGIACS230.to_date = null;
		objGIACS230.dt_basis = null;
		objGIACS230.sl_exists = 0;
		objGIACS230.glTransURL = null;
		objGIACS230.slSummaryURL = null;
		objGIACS230.multiSort = null;
		objGIACS230.msortOrder = [];
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		/*if ($F("txtGlAcctCat") == ""){
			showMessageBox("Please enter the GL Account Code", "I");
			$("txtGlActCat").focus();
			return false;
		}else if($F("txtFromDate") == ""){
			showMessageBox("Please enter the From Date", "I");		
			return false;
		}else if($F("txtToDate") == ""){
			showMessageBox("Please enter the To Date", "I");
			return false;
		}else if(Date.parse($F("txtFromDate")) > Date.parse($F("txtToDate"))){
			showMessageBox("To Date cannot be earlier than From Date", "I");
			return false;
		}*/
		if (checkAllRequiredFieldsInDiv('glAcctTranHeaderDiv')){
			toggleGIACS230Fields(false);
			enableButton("btnMultiSort");
			enableButton("btnShowSl");
			executeQuery();
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("acExit"), "click");
	});
	
	$("searchGLAcctLOV").observe("click", function(){
		var withValue = false;
		var glChanged = false;
		$$("input[name='glAcctTxt']").each(function(txt){
			if (txt.value != ""){
				withValue = true;
				return;
			}	
		});
		
		$$("input[name='glAcctTxt']").each(function(txt){
			if (txt.value != txt.readAttribute("lastValidValue")){
				glChanged = true;
				return;
			}	
		});
		
		if(((withValue == false &&  $F("txtGlAcctName") == "") ||
				(withValue && $F("txtGlAcctName") != "")) &&
				(glChanged == false && $F("txtGlAcctName") != "")){
			showGLAcctLOV(true);
		}else{
			showGLAcctLOV(false);
		}
	});
	
	$("searchCompanyLOV").observe("click", function(){
		/*showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtCompany"), "Company Code", "Company Name", $("hidFundCd"), $("txtBranch"), $("txtCompany"));
		enableToolbarButton("btnToolbarEnterQuery");*/
		showGIACS230FundLOV(true);
	});
	
	$("searchBranchLOV").observe("click", function(){
		/*if($F("hidFundCd") != ""){
			showGIACS230BranchLOV();
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}*/
		showGIACS230BranchLOV(true);
	});
	
	$("txtCompany").observe("keyup", function(){
		$("txtCompany").value = $("txtCompany").value.toUpperCase();	
	});
	
	$("txtBranch").observe("keyup", function(){
		$("txtBranch").value = $("txtBranch").value.toUpperCase();	
	});
	
	$("txtCompany").observe("change", function(){
		/*showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtCompany"), "Company Code", "Company Name", $("hidFundCd"), $("txtBranch"), $("txtCompany"));
		enableToolbarButton("btnToolbarEnterQuery");*/
		showGIACS230FundLOV(false);
	});
	
	$("txtBranch").observe("change", function(){
		/*if($F("hidFundCd") != ""){
			showGIACS230BranchLOV();
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}*/
		if (this.value == ""){
			$("hidBranchCd").clear();
			$("hidBranchName").clear();
		}else{
			showGIACS230BranchLOV(false);
		}
	});
	
	$("txtFromDate").observe("blur", function(){
		objGIACS230.from_date = $F("txtFromDate");
	});
	
	$("txtToDate").observe("blur", function(){
		objGIACS230.to_date = $F("txtToDate");
	});
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$$("input[name='dateBasisRG']").each(function(radio){
		radio.observe("click", function(){
			objGIACS230.dt_basis = radio.value;
		});
	});
	
	$("chkTranOpen").observe("click", function(){
		if ($("chkTranOpen").checked){
			$("chkTranOpen").value = "Y";
			tranOpenFlg = "Y";
		}else{
			$("chkTranOpen").value = "N";	
			tranOpenFlg = "N";	
		}
	});	
	
}catch(e){
	showErrorMessage("glAccountTransaction page: ", e);
}	
</script>
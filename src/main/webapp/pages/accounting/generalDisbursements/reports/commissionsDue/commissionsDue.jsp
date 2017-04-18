<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="commissionsDueMainDiv" name="commissionsDueMainDiv">
  	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="commissionsDueExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Commissions Due</label>
	   	</div>
	</div>
	
	<div id="commissionsDueSectionDiv" class="sectionDiv" style="height: 450px;">
		<div style="margin-left: 200px; margin-top:100px; width: 520px;" class="sectionDiv">
			<div id="commissionsDueDiv" name="commissionsDueDiv" class="sectionDiv" style="width: 500px; margin: 10px; margin-bottom: 15px;">
				<table style="margin-top: 20px;">
					<tr>
						<td class="rightAligned" style="width: 118px;">As of</td>
						<td class="leftAligned">
							<div style="float: left; width: 165px;" class="withIconDiv required" id="asOfDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" removeStyle="true" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="102"/>
							</div>
						</td>			
					</tr>
				</table>
				<table align="center" style="margin-bottom: 20px;">
					<tr>
						<td class="rightAligned">Intermediary Type</td>
						<td>
							<div id="intmTypeDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;" class="">
								<input id="txtIntmType" name="Intm Type" title="Intermediary Type" type="text" maxlength="2" class="" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="103">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntmType" name="imgIntmType" alt="Go" style="float: right;" tabindex="104"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtIntmTypeDesc" name="txtIntmTypeDesc" style="width: 275px; margin-top: 3x;" readonly="readonly" tabindex="105"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td>
							<div id="intmDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;" class="">
								<input id="txtIntmNo" name="Intm No" title="Intermediary" type="text" maxlength="12" class="" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="106">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntm" name="imgIntm" alt="Go" style="float: right;" tabindex="107"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtIntmName" name="txtIntmName" style="width: 275px; margin-top: 3x;" readonly="readonly" tabindex="108"/>
							<input type="hidden" id="sysdate" name="sysdate" />
						</td>
					</tr>
				</table>		
			</div>
			<div id="buttonsDiv" name="buttonsDiv" style="margin-left: 155px; float: left; height: 50px;">
				<table align="center">
					<tr>
						<td><input type="button" class="button" id="btnViewRecords" name="btnViewRecords" value="View Records" style="width: 120px;" tabindex="201"/></td>
						<td><input type="button" class="button" id="btnViewBankFiles" name="btnViewBankFiles" value="View Bank Files" style="width: 120px;" tabindex="202"/></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<div id="GIACS251Div"></div> <!-- // AFP SR-18481 : shan 05.21.2015 -->
<script type="text/javascript">
	setModuleId("GIACS158");
	setDocumentTitle("Commissions Due");
	mode = 0;
	objCurrBankFileNo = "";
	objCurrParentIntmNo = "";
	objCurrParentIntmType = "";
	
	function showIntmTypeLOV() {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getIntmTypeGIACS158",
					search : $F("txtIntmType")
				},
				title : "Intermediary Type",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $F("txtIntmType"),
				columnModel : [ 
				    {
						id : "intmType",
						title : "Intm Type",
						width : '100px'
					}, 
					{
						id : "intmDesc",
						title : "Intm Desc",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtIntmType").value = row.intmType;
					$("txtIntmTypeDesc").value = row.intmDesc;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("intmTypeLOV", e);
		}
	}

	function showIntmLOV() {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getIntmGIACS158",
				   intmType: $F("txtIntmType"),
					search : $F("txtIntmNo")
				},
				title : "Intermediaries",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $F("txtIntmNo"),
				columnModel : [ 
				    {
						id : "intmNo",
						title : "Intm No",
						width : '100px'
					}, 
					{
						id : "intmName",
						title : "Intm Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = row.intmName;
// 					$("txtIntmType").value = "";
// 					$("txtIntmDesc").value = "ALL INTERMEDIARY";
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("intmLOV", e);
		}
	}

	function checkLov(action, cd, desc, func, message) {
		if ($(cd).value == "") {
			$(desc).value = message;
		} else {
			var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value + "&intmType=" + $("txtIntmType").value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				//$(cd).clear();
				$(desc).value = message;
				//customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
				func();
				if ($(desc).value == "ALL INTERMEDIARY TYPE") {
					$("txtIntmType").clear();
				}else if ($(desc).value == "ALL INTERMEDIARIES") {
					$("txtIntmNo").clear();
				}
			} else {
				func();
			}
		}
	}
	overlayViewBankFiles = null;	// AFP SR-18481 : shan 05.21.2015
	
	function showViewBankFiles(){	
		overlayViewBankFiles = Overlay.show(contextPath + "/GIACGeneralDisbursementReportsController", {
			urlContent : true,
			urlParameters : {action : "showViewBankFiles"},
			title : 'View Bank Files',
			height : '400px',
			width : '560px',
			draggable : true
		});		
	}

	function checkViewRecords() {
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
			parameters: {
				action: "checkViewRecords",
				asOfDate: $F("txtAsOfDate"),
				intmType: $F("txtIntmType"),
				intm: $F("txtIntmNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText != "") {
						showConfirmBox("confirmation", response.responseText, "Yes", "No", invalidateBankFile,"","");
					}else{
						showViewRecords();
					}
				}
			}
		});	
	}
	
	function invalidateBankFile() {
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
			parameters: {
				action: "invalidateBankFile",
				asOfDate: $F("txtAsOfDate"),
				intmType: $F("txtIntmType"),
				intm: $F("txtIntmNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					showViewRecords();
				}
			}
		});			
	}
	
	function showViewRecords(){	//show details overlay per selected row
		overlayViewRecords = Overlay.show(contextPath + "/GIACGeneralDisbursementReportsController", {
			urlContent : true,
			urlParameters : {action : "processViewRecords",
				asOfDate: $F("txtAsOfDate"),
				intmType: $F("txtIntmType"),
				intm: $F("txtIntmNo")
			},
			title : 'View Records',
			height : '450px',
			width : '760px',
			draggable : true
		});		
	}
	$("sysdate").value =  dateFormat(new Date(), 'mm-dd-yyyy');
	$("txtAsOfDate").observe("focus", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		
		if ((asOfDate > sysdate) && asOfDate != "" ){
			customShowMessageBox("Enter a date earlier than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
		}else if ($F("txtAsOfDate") == $F("sysdate")) {
			customShowMessageBox("Enter a date earlier than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
		}
	});
	
	$("txtIntmType").observe("change", function() {
		checkLov("getIntmTypeGIACS158", "txtIntmType", "txtIntmTypeDesc", showIntmTypeLOV, "ALL INTERMEDIARY TYPE");
	});
	
	$("txtIntmNo").observe("change", function() {
		if (isNaN($F("txtIntmNo"))) {
			showMessageBox("Intm No must be a number.", imgMessage.INFO);
			$("txtIntmNo").clear();
		}else {
			checkLov("getIntmGIACS158", "txtIntmNo", "txtIntmName", showIntmLOV, "ALL INTERMEDIARIES");
		}
	});
	
	$("imgIntmType").observe("click", showIntmTypeLOV);
	
	$("imgIntm").observe("click", showIntmLOV);
	
	$("hrefAsOfDate").observe("click", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		scwShow($('txtAsOfDate'),this, null);
	});
	
	$("btnViewRecords").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("commissionsDueDiv")) {
			mode = 1;
			checkViewRecords();
		}
	});
	
	$("btnViewBankFiles").observe("click", function() {
		mode = 2;
		showViewBankFiles();
	});
	
	$("commissionsDueExit").stopObserving("click");
		observeCancelForm("commissionsDueExit", "", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	$("txtAsOfDate").focus();
	$("txtIntmTypeDesc").value = "ALL INTERMEDIARY TYPE";
	$("txtIntmName").value = "ALL INTERMEDIARIES";
	
	$("GIACS251Div").hide();	// AFP SR-18481 : shan 05.21.2015
</script>
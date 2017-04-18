<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="closeGLMainDiv" name="closeGLMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Close the General Ledger</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="closeGLBody" name=closeGLBody style="height: 350px;">
		<div class="sectionDiv" style="margin: 100px 0 0 185px; height: 35%; width: 60%;">
			<table align="center" style="padding: 40px; width: 100%;">
				<tr>
					<td class="rightAligned">Year</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 180px; height: 21px; margin: 2px 4px 0 0; float: left;">
							<input class="disableDelKey integerUnformatted" type="text" id="txtTranYear" name="txtTranYear" style="width: 150px; float: left; border: none; height: 13px; text-align: right;"/>								
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranYear" name="searchTranYear" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Month</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 130px; height: 21px; margin: 2px 4px 0 0; float: left;">
							<input class="disableDelKey integerUnformatted" type="text" id="txtTranMonth" name="txtCashierCd" style="width: 100px; float: left; border: none; height: 13px; text-align: right;" readonly="readonly"/>								
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranMonth" name="searchTranMonth" alt="Go" style="float: right;"/>
						</span>
					</td>
				</tr>
			</table>
		</div>
		<div id="closeGLButtonDiv" style="margin: 15px; float: left; width: 100%;">
			<input type="button" class="button" id="btnCloseGenLedger" name="btnCloseGenLedger" value="Close General Ledger" style="width: 200px;" />
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS411");
	setDocumentTitle("Close the General Ledger");
	disableSearch("searchTranMonth");
	disableButton("btnCloseGenLedger");
	var onSearchButton = true;
	var validateModuleId = false;
	
	// GIACS411 variables
	var glNo = validateVariables('${glNo}');
	var financeEnd = null;
	var fiscalEnd = null;
	var jsonModuleObj = JSON.parse('${jsonModuleObj}');
	if (glNo != null && glNo != "") {
		financeEnd = validateVariables('${financeEnd}');
		if (financeEnd != null && financeEnd != "") {
			if (glNo == '2') {
				fiscalEnd = validateVariables('${fiscalEnd}');
				if (fiscalEnd != null) {
					validateModuleId = true;
				}
			}else{
				validateModuleId = true;
			}
			
		}
	}
	if (validateModuleId && jsonModuleObj.msg != "" && jsonModuleObj.msg != null) {
		showMessageBox(jsonModuleObj.msg,"E");
	}
	
	function validateVariables(val) {
		if (val.include("Geniisys Exception")){
			var message = val.split("#"); 
			showMessageBox(message[2], message[1]);
			return null;
		} else {
			return val;
		}
	}
	
	function showTranYearLOV(findText2){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getTranYearLOV",
				findText2: findText2
			},
			title: "Valid Values for Year",
			width: 350,
			height: 388,
			columnModel : [
			               {
			            	   id : "tranYear",
			            	   title: "Year",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtTranYear").value = row.tranYear;
				$("txtTranMonth").readOnly = false;
				$("txtTranMonth").focus();
				enableSearch("searchTranMonth");
			},
	  		onCancel: function(){
  				$("txtTranYear").focus();
	  		}
		});
	}
	
	function showTranMonthLOV(findText2){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getTranMonthLOV",
				tranYear: $F("txtTranYear"),
				findText2: findText2
			},
			title: "Valid Values for Month",
			width: 400,
			height: 388,
			columnModel : [
			               {
			            	   id : "tranMonth",
			            	   title: "Month",
			            	   width: '180px'
			               },
			               {
			            	   id : "tranYear",
			            	   title: "Year",
			            	   width: '180px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtTranMonth").value = row.tranMonth;
				enableButton("btnCloseGenLedger");
			},
	  		onCancel: function(){
  				$("txtTranMonth").focus();
	  		}
		});
	}
	
	function lovOnChangeEvent(id,lovFunc,populateFunc,noRecordFunc,content) {
		try{
			var findText = $F(id).trim() == "" ? "%" : $F(id);
			var cond = validateTextFieldLOV(content,findText,"Searching, please wait...");
			if (cond == 2) {
				lovFunc(findText);
			} else if(cond == 0) {
				$(id).clear();
				noRecordFunc();
			}else{
				populateFunc(cond);
			}
		}catch (e) {
			showErrorMessage("lovOnChangeEvent",e);
		}
	}
	
	function closeGenLedger() {
		try {
			new Ajax.Request(contextPath+"/GIACCloseGLController",{
				parameters:{
							action : "closeGenLedger",
							tranYear : $F("txtTranYear"),
							tranMonth : $F("txtTranMonth"),
							glNo : glNo,
							financeEnd : financeEnd,
							fiscalEnd : fiscalEnd
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Closing General Ledger, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) && checkConfirmationErrorOnResponse(response,closeGenLedgerConfirmation,cancelConfirmation)){
						var result = JSON.parse(response.responseText);
						var msgArray =  result.msg.split("#");
						arrayMessagebox(msgArray,"E",0);
						disableButton("btnCloseGenLedger");
					}
				}
			});
		} catch (e){
			showErrorMessage("closeGenLedger", e);
		}
	}
	
	function arrayMessagebox(array,msgIcon,index) {
		for ( var i = index; i < array.length; i++) {
			if (array[i] != null && array[i] != "" && array[i] != "success") {
				showWaitingMessageBox(array[i],msgIcon, function(){
					arrayMessagebox(array,"E",i+1);
				});
				break;
			} else if(array[i] == "success") {
				showMessageBox("Finished.", imgMessage.SUCCESS);
			}							
		}
	}
	
	function checkConfirmationErrorOnResponse(response,okFunc,cancelFunc) {
		if (response.responseText.include("Geniisys Confirmation")){
			var message = response.responseText.split("#"); 
			showConfirmBox(message[1],message[2], "Yes", "No",okFunc,cancelFunc);
			return false;
		} else {
			return true;
		}
	}
	
	function closeGenLedgerConfirmation() {
		try {
			var moduleId = null;
			var genType = null;
			if (validateModuleId) {
				moduleId = jsonModuleObj.moduleId;
				genType = jsonModuleObj.genType;
			}
			new Ajax.Request(contextPath+"/GIACCloseGLController",{
				parameters:{
							action : "closeGenLedgerConfirmation",
							tranYear : $F("txtTranYear"),
							tranMonth : $F("txtTranMonth"),
							glNo : glNo,
							financeEnd : financeEnd,
							fiscalEnd : fiscalEnd,
							moduleId : moduleId,
							genType : genType
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Closing General Ledger, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						disableButton("btnCloseGenLedger");
					}
				}
			});
		} catch (e){
			showErrorMessage("closeGenLedgerConfirmation", e);
		}
	}
	
	function cancelConfirmation() {
		var glName = null;
		if (glNo == '2') {
			if ($F("txtTranMonth") == fiscalEnd) {
				glName = "Fiscal";
			} else if($F("txtTranMonth") == financeEnd) {
				glName = "Financial";
			}
		}
		if (glName != null) {
			showMessageBox("Cannot close the month unless the "+ glName +" Year will also be closed.","E");
		}else{
			showMessageBox("Cannot close the month unless the Financial Year will also be closed.","E");
		}
	}
	/* observe */
	$$("div#closeGLBody input[type='text'].disableDelKey").each(function (a) {
			$(a).observe("keydown",function(e){
				if($(a).readOnly && e.keyCode === 46){
					$(a).blur();
				}
			});
			$(a).observe("change",function(){
				if ($F("txtTranYear").trim() == "") {
					$("txtTranMonth").readOnly = true;
					disableSearch("searchTranMonth");
					disableButton("btnCloseGenLedger");
				}else if ($F("txtTranMonth").trim() == "") {
					disableButton("btnCloseGenLedger");
				}
			});
	});
	
	$("searchTranYear").observe("click", function() {
// 		var findText2 = $F("txtTranYear").trim() == "" ? "%" : $F("txtTranYear");
// 		showTranYearLOV(findText2);
		if (onSearchButton) {
			lovOnChangeEvent("txtTranYear",function(findText) {
												showTranYearLOV(findText);
										 	}, function(obj) {
												$("txtTranYear").value = obj.rows[0].tranYear;
												$("txtTranMonth").readOnly = false;
												$("txtTranMonth").focus();
												enableSearch("searchTranMonth");
										    },function() {
										    	$("txtTranMonth").readOnly = true;
												disableSearch("searchTranMonth");
												disableButton("btnCloseGenLedger");
												$("txtTranMonth").clear();
												showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
																														onSearchButton = true;		
																													});
										    }, "/AccountingLOVController?action=getTranYearLOV&findText2=''");
		}
	});
	
	$("searchTranMonth").observe("click", function() {
// 		var findText2 = $F("txtTranMonth").trim() == "" ? "%" : $F("txtTranMonth");
// 		showTranMonthLOV(findText2);
		if (onSearchButton) {
			lovOnChangeEvent("txtTranMonth",function(findText) {
												showTranMonthLOV(findText);
										 	}, function(obj) {
												$("txtTranMonth").value = obj.rows[0].tranMonth;
												enableButton("btnCloseGenLedger");
										    },function() {
										    	disableButton("btnCloseGenLedger");
										    	showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
									    																				onSearchButton = true;		
																													});
										    }, "/AccountingLOVController?action=getTranMonthLOV&findText2=''&tranYear="+$F("txtTranYear"));
		}
	});
	
	$("txtTranYear").observe("change", function() {
		lovOnChangeEvent("txtTranYear",function(findText) {
											showTranYearLOV(findText);
									 	}, function(obj) {
											$("txtTranYear").value = obj.rows[0].tranYear;
											$("txtTranMonth").readOnly = false;
											$("txtTranMonth").focus();
											enableSearch("searchTranMonth");
									    },function() {
									    	$("txtTranMonth").readOnly = true;
											disableSearch("searchTranMonth");
											disableButton("btnCloseGenLedger");
											$("txtTranMonth").clear();
											onSearchButton = false;
											showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
																													onSearchButton = true;		
																												});
									    }, "/AccountingLOVController?action=getTranYearLOV&findText2=''");
	});
	
	$("txtTranMonth").observe("change", function() {
		lovOnChangeEvent("txtTranMonth",function(findText) {
										showTranMonthLOV(findText);
									 	}, function(obj) {
											$("txtTranMonth").value = obj.rows[0].tranMonth;
											enableButton("btnCloseGenLedger");
									    },function() {
									    	disableButton("btnCloseGenLedger");
									    	onSearchButton = false;
									    	showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
																													onSearchButton = true;		
																												});
									    }, "/AccountingLOVController?action=getTranMonthLOV&findText2=''&tranYear="+$F("txtTranYear"));
	});
	
	$("btnCloseGenLedger").observe("click", function() {
		var tranMonthName = Date.parse($F("txtTranMonth")+"-01-2000");
		showConfirmBox("Confirm","Close " + dateFormat(tranMonthName,"mmmm") + " " + $F("txtTranYear") + " General Ledger?", "Yes", "No",
				closeGenLedger,""
		);
	});
</script>
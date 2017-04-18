<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<form id="transactionForm" name="transactionForm">
	<div id="outerDiv" name="outerDiv" style="width: 100%; float: left;">
		<div id="innerDiv" name="innerDiv">
			<label>User Group Transaction Maintenance</label>
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="float: left; margin: 10px;">
			<span class="spanHeader">
				<label style="margin-bottom: 5px;">User Group Details</label>
			</span>
			<div style="float: left; width: 95.5%; margin: 20px;">
				<div style="width: 50%; float: left;">
					<label style="float: left; width: 120px; padding: 0; margin-right: 5px;" class="rightAligned">User Group: </label> 
					<span style="float: left; width: 70%;">
						<input type="text" class="required integerNoNegativeUnformattedNoComma" id="userGrpId" name="userGrpId" value="${userGrpHdr.userGrp}" style="float: left; width: 100%;" maxlength="4" />
					</span> 
				</div>
				<div style="width: 50%; float: left;">
					<label style="float: left; width: 100px; padding: 0; margin-right: 5px;" class="rightAligned">Issue Source: </label>
					<span style="float: left; width: 70%;">
						<select class="required" id="grpIssCd" name="grpIssCd" style="float: left; width: 100%;">
							<option></option>
							<c:forEach var="i" items="${issSources}">
								<option value="${i.issCd}"
									<c:if test="${i.issCd eq userGrpHdr.grpIssCd}">
										selected="selected"
									</c:if>
								>${i.issName}</option>
							</c:forEach>
						</select>
					</span>
				</div>
				<div style="width: 100%; float: left; margin-top: 5px;">
					<label style="float: left; width: 120px; padding: 0; margin-right: 5px;" class="rightAligned">User Group Desc: </label> 
					<span style="float: left; width: 81.7%;">
						<input type="text" class="required upper" id="userGrpDesc" name="userGrpDesc" value="${userGrpHdr.userGrpDesc}" style="float: left; width: 100%;" maxlength="50" />
					</span> 
				</div>
			</div>
		</div>
	</div>
	
	<!-- TRANSACTIONS -->
	<div id="transactionList" name="transactionList" class="sectionDiv">
		<div style="margin: 10px; margin-bottom: 20px; float: left;">
			<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Transactions</label></span>
			<!-- <div style="float: left; width: 100%; display: none;" id="transferMessage">
				<span style="float: left; width: 100%; text-align: center;">
					<label style="float: left; -moz-border-radius: 5px;border: 1px solid green; margin: 10px 40%; padding: 5px; width: 18%;">Transferring, please wait...</label>
				</span>
			</div> -->
			<div style="float: left; margin: 0 auto%; width: 100%;">
				<div style="float: left; margin: 0 auto; width: 100%;">
					<div style="float: left; margin: 0 2.5%;">
						<span style="width: 100%; margin-bottom: 3px; float: left;">
							<label style="margin-bottom: 5px; width: 53%;">Available Transactions</label>
							<label style="margin-bottom: 5px; width: 47%;">Current Transactions</label>
						</span>
						
						<div style="float: left; width: 47%;">
							<div id="transactionSelect" name="transactionSelect" class="transactionDiv" style="width: 100%; height: 200px; overflow-y: auto;">
								<c:forEach var="t" items="${transactions}">
									<div id="row${t.tranCd}" name="row" class="smallTableRow"><input type="hidden" name="tranCds" value="${t.tranCd}" /><label>${t.tranDesc}</label></div>
								</c:forEach>
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right1"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left1"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="transactionSelect1" name="transactionSelect1" class="transactionDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
								<c:forEach var="t" items="${userGrouptransactions}">
									<div id="row${t.tranCd}" name="row" class="smallTableRow"><input type="hidden" name="tranCds1" value="${t.tranCd}" /><label>${t.tranDesc}</label></div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="tTransactions" name="tTransactions" style="display: none;">
		<json:object>
			<json:array name="tTransactions" var="t" items="${userGrouptransactions}">
				<json:object>
					<json:property name="tranCd" 		value="${t.tranCd}" />
					<json:property name="tranDesc" 		value="${i.t.tranDesc}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<div class="sectionDiv">
		<input type="button" id="btnModules" name="btnModules" class="button" style="margin: 10px auto;" value="Modules" />
	</div>
	<!-- MODULES --> 
	<div id="moduleList" name="moduleList" class="sectionDiv" style="display: none;">
	</div>
	
	<!-- ISSUES -->
	<div id="issueList" name="issueList" class="sectionDiv" style="float: left; width: 100%;">
		<div style="margin: 10px 10px 20px; float: left; width: 98.3%;">
			<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Issue Sources</label></span>
			<div style="margin: 0pt 2.5%; float: left; width: 100%;">
				<div style="float: left; width: 95%;">
					<div style="float: left; width: 100%;">
						<span style="width: 100%; margin-bottom: 3px; float: left;">
							<label style="margin-bottom: 5px; width: 53%;">Available Issue Sources</label>
							<label style="margin-bottom: 5px; width: 47%;">Current Issue Sources</label>
						</span>
						
						<div style="float: left; width: 47%;">
							<div id="issSourcesSelect" name="issSourcesSelect" class="transactionDiv" style="width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right1"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left1"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="issSourcesSelect1" name="issSourcesSelect1" class="transactionDiv" style="width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- LINES -->
	<div id="lineList" name="lineList" class="sectionDiv" style="float: left; width: 100%;">
		<div style="margin: 10px 10px 20px; float: left; width: 98.3%;">
			<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Line of Business</label></span>
			<div style="margin: 0pt 2.5%; float: left; width: 100%;">
				<div style="float: left; width: 95%;">
					<div style="float: left; width: 100%;">
						<span style="width: 100%; margin-bottom: 3px; float: left;">
							<label style="margin-bottom: 5px; width: 53%;">Available Line of Business</label>
							<label style="margin-bottom: 5px; width: 47%;">Current Line of Business</label>
						</span>
						
						<div style="float: left; width: 47%;">
							<div id="lineSelect" name="lineSelect" class="transactionDiv" style="width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right1"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left1"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft1" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="lineSelect1" name="lineSelect1" class="transactionDiv" style="width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="float: left; margin: 20px; width: 95.5%;">
			<div style="float: left; width: 100%; margin-left: 30px;">
				<div style="width: 100%; float: left; margin-bottom: 5px;">
					<label style="float: left; width: 100px; padding: 0; margin-right: 5px;" class="rightAligned">Remarks: </label> 
					<div style="float: left; width: 80.7%;">
						<div style="border: 1px solid gray; height: 20px; width: 100%;">
							<textarea id="remarks" name="remarks" style="float: left; width: 95%; border: none; height: 13px;" />${userGrpHdr.remarks}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</div> 
				</div>
				<!-- <div style="width: 50%; float: left;">
					<label style="float: left; width: 100px; padding: 0; margin-right: 5px;" class="rightAligned">User Id: </label>
					<span style="float: left; width: 60%;">
						<input type="text" id="userId" name="userId" style="float: left; width: 100%;" value="${userGrpHdr.userId}<c:if test="${empty userGrpHdr}">${tranUserId}</c:if>" readonly="readonly" />
					</span> 
				</div>
				<div style="width: 50%; float: left;">
					<label style="float: left; width: 100px; padding: 0; margin-right: 5px;" class="rightAligned">Last Update: </label>
					<span style="float: left; width: 60%;">
						<input type="text" id="lastUpdate" name="lastUpdate" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${sysdate}" />" style="float: left; width: 100%;" readonly="readonly" />
					</span>
				</div> -->
			</div>
		</div>
	</div>

	<div class="buttonsDiv" style="margin-top: 10px;">
		<input type="button" class="button" style="width: 60px;" id="btnSave" name="btnSave" value="Save" />
		<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	</div>
	
	<input type="hidden" id="userGrps" name="userGrps" value="${userGrps}" />
</form>

<script>
	$("allRight1").observe("click", function () {
		transferAllRight("transactionSelect", "transactionSelect1", "transactionDiv1", "tranCds", filterModulesIssSourcesByTranCd);
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
		deselectRows("transactionSelect1", "row");
	});
	$("right1").observe("click", function () {
		transferRight("transactionSelect", "transactionSelect1", "transactionDiv1", "tranCds", filterModulesIssSourcesByTranCd);
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
		deselectRows("transactionSelect1", "row");
	});
	$("left1").observe("click", function () {
		transferLeft("transactionSelect", "transactionSelect1", "transactionDiv", "tranCds");
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
	});
	$("allLeft1").observe("click", function () {
		transferAllLeft("transactionSelect", "transactionSelect1", "transactionDiv", "tranCds");
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
	});

	removeCurrentTransactionsFromAvailable("transactionSelect", "transactionSelect1");

	$("btnCancel").observe("click", function () {
		Effect.Fade("transactionDiv", {
			duration: .2,
			afterFinish: function () {
				$("transactionDiv").innerHTML = "";
				Effect.Appear("userGroupListingMainDiv", {duration: .3});
			}
		});
	});
	
/* 	// Populate modules
	new Ajax.Updater("moduleList", contextPath+"/GIISUserGroupMaintenanceController", {
		method: "GET",
		parameters: {
			action: "populateModules",
			ajax: 1,
			userGrp: $F("userGrpId")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Loading modules..."),
		onComplete: function () {
			// Populate issue sources
			new Ajax.Updater("issueList", contextPath+"/GIISUserGroupMaintenanceController", {
				method: "GET",
				parameters: {
					action: "populateIssueSources",
					ajax: 1,
					userGrp: $F("userGrpId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading issue sources..."),
				onComplete: function () {
					// Populate line of business
					new Ajax.Updater("lineList", contextPath+"/GIISUserGroupMaintenanceController", {
						method: "GET",
						parameters: {
							action: "populateLinesOfBusiness",
							ajax: 1,
							userGrp: $F("userGrpId")
						},
						evalScripts: true,
						asynchronous: false,
						onCreate: showNotice("Loading lines of business..."),
						onComplete: function () {
							hideNotice();
							initializeAll();
							initializeTable("transactionDiv", "row", "", "");
							initializeTable("transactionDiv1", "row", "", filterModulesIssSourcesByTranCd);
						}
					});
				}
			});	
		}
	}); */

	$("btnModules").observe("click", function () {
		Effect.toggle("moduleList", "blind", {duration: .3}); //$("moduleList").toggle();
	});

	tTransactions = $("tTransactions").innerHTML.evalJSON();
	
	$("btnSave").observe("click", function () {
		if ($F("userGrpId").blank() || $F("userGrpDesc").blank() || $F("grpIssCd").blank()) {
			showMessageBox("Please complete required fields...", imgMessage.ERROR);
			return false;
		} else if (parseInt($F("userGrpId")) < 0){ //added by angelo for negative user group id
			showMessageBox('Number Format Exception occurred. For input string ' + $F("userGrpId"), imgMessage.ERROR);
			return false; 
		} else if (validateUserGroup()) {
			showMessageBox("User group already exists...", imgMessage.ERROR);
			return false;
		} else {
			saveUserGrp(null);
		}
	});

	function validateUserGroup() {
		var exists = false;
		$F("userGrps").split(",").any(function (u) {
			if (u == $F("userGrpId")) {
				exists =  true;
			}
		});
		return exists;
	}

	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});
	
	$("userGrpId").observe("change", function(){
		if($F("userGrpId") != "" && validateUserGroup()){
			clearFocusElementOnError("userGrpId", "User group must be unique");
		}else{
			checkGroupDetails();
		}
	});
	
	$("grpIssCd").observe("change", function(){
		checkGroupDetails();
	});
	
	$("userGrpDesc").observe("change", function(){
		checkGroupDetails();
	});
	
	function saveUserGrp(userGrp){
		var pTransactions = new Array();
		var pIssueSources = new String();
		var pModules = new String();
		var pLines = new String();
		var tranCd = "";
		
		for (var i=0; i<tTransactions.tTransactions.length; i++) {
			tranCd = tTransactions.tTransactions[i].tranCd;
			pTransactions[i] = tranCd;

			// modules
			var ppModules = new Array();
			for (var l=0; l<grpModules.grpModules.length; l++) {
				if (grpModules.grpModules[l].tranCd == tranCd) {
					ppModules.push(grpModules.grpModules[l].moduleId);
				}
			}
			if (ppModules.length == 0) {
				pModules+= "void";
			} else {
				pModules+= ppModules;
			}

			// issue sources and lines
			var ppIssSources = new Array();
			for (var j=0; j<grpIssSources.grpIssSources.length; j++) {
				var ppLines = new Array();
				if (grpIssSources.grpIssSources[j].tranCd == tranCd) {
					var issCd = grpIssSources.grpIssSources[j].issCd;
					ppIssSources.push(issCd);

					curLines.curLines.findAll(function (k) {
						if (k.tranCd == tranCd && k.issCd == issCd) {
							ppLines.push(k.lineCd);
						}
					});

					if (ppLines.length == 0) {
						pLines+= "void";
					} else {
						pLines+= ppLines;
					}

					if (!(j == grpIssSources.grpIssSources[j].length-1)) {
						pLines+= "--";
					}
				}
			}
			if (ppIssSources.length == 0) {
				pIssueSources+= "void";
			} else {
				pIssueSources+= ppIssSources;
			}
			if (!(i == tTransactions.tTransactions.length-1)) {
				pIssueSources+= "--";
				pModules+= "--";
			}
			pLines+= "]";
			
		}

		//new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController?pTransactions="+pTransactions+"&pModules="+pModules+"&pIssSources="+pIssueSources+"&pLines="+pLines, {
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", { // replaced by: Nica 05.23.2013 - to prevent bad request error
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			parameters: {
				action: "setUserGrpHdr",
				ajax: 1,
				userGrp: $F("userGrpId"),
				userGrpDesc: $F("userGrpDesc"),
				grpIssCd: $F("grpIssCd"),
				remarks: $F("remarks"),
				pTransactions: pTransactions,
				pModules: pModules,
				pIssSources: pIssueSources,
				pLines: pLines
			},
			onCreate: showNotice("Saving, please wait..."),
			onComplete: function (response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if(nvl(userGrp, "") == ""){
						if(response.responseText.include("SUCCESS")){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);							
						}else{
							showMessageBox(response.responseText, "E");
						}
					}else{
						copyUserGrp(userGrp);
					}
				}
			}
		});
	}
	
	function checkGroupDetails(){
		if($F("userGrpId") != "" && $F("grpIssCd") != "" && $F("userGrpDesc") != ""){
			showConfirmBox("", "Do you want to copy records from another user group?", "Ok", "Cancel",
				function(){
					showConfirmBox("", "Transactions of the selected group will be saved on the newly created user group. Do you want to continue?",
						"Ok", "Cancel", showUserGrpLOV, "");
				},"");
		}
	}
	
	function showUserGrpLOV(){
		try{
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action: "getUserGrpLOV"},
				title: "User Groups",
				width: 400,
				height: 386,
				columnModel:[
				             	{
				             		id: "userGrp",
				             		title: "User Group",
				             		width: "85px",
				             	},
				             	{	id : "userGrpDesc",
				             		title: "Group Description",
									width: '300px'
								}
							],
				draggable: true,
				onSelect : function(row){
					saveUserGrp(row.userGrp);
				}
			});
		}catch(e){
			showErrorMessage("showUserGrpLOV", e);
		}
	}
	
	function copyUserGrp(userGrp){
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			parameters: {
						action : "copyUserGrp",
						userGrp	: userGrp,
						newUserGrp : $F("userGrpId")
						},
			asynchronous: true,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, reloadTransactionMaintenance);
				}
			}
		});
	}
	
	function reloadTransactionMaintenance(){
		new Ajax.Updater("transactionDiv", contextPath+"/GIISUserGroupMaintenanceController", {
			method: "GET",
			parameters: {
				action: "transactionMaintenance",
				userGrp: $F("userGrpId")
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function () {
				Effect.Fade("userGroupListingMainDiv", {
					duration: .3,
					afterFinish: showNotice("Getting transactions, please wait...")
				});
			},
			onComplete: function () {
				hideNotice();
				Effect.Appear("transactionDiv", {duration: .3});
				$("userGrpId").readOnly = true;
			}
		});
	}
	
	makeInputFieldUpperCase();
	
	new Ajax.Updater("moduleList", contextPath+"/GIISUserGroupMaintenanceController", {
		method: "GET",
		parameters: {
			action: "populateModules",
			userGrp: $F("userGrpId")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Loading modules..."),
		onComplete: function () {
			// Populate issue sources
		}
	});
</script>
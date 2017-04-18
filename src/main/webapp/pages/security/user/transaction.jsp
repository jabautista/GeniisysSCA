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
			<label>User Transaction Maintenance</label>
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="margin: 10px;">
			<span class="spanHeader">
				<label style="margin-bottom: 5px;">User Details</label>
			</span>
			<div style="float: left; width: 100%; margin-left: 30px;">
				<div style="width: 100%; float: left;">
					<label style="float: left; width: 100px; padding: 0;" class="leftAligned">User Id</label> 
					<span style="float: left; width: 90%;">
						<input type="text" id="userID" name="userID" value="${userID}" style="float: left; width: 39.3%;" readonly="readonly" />
					</span>
					<label style="float: left; width: 100px; padding: 0;" class="leftAligned">Username</label> 
					<span style="float: left; width: 90%;">
						<input type="text" id="username" name="username" value="${username}" style="float: left; width: 39.3%;" readonly="readonly" />
					</span> 
				</div>
			</div>
		</div>
	</div>
	
	<!-- TRANSACTIONS -->
	<div id="transactionList" name="transactionList" class="sectionDiv">
		<div style="margin: 10px; margin-bottom: 20px; float: left;">
			<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Transactions</label></span>
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
								<c:forEach var="t" items="${userTransactions}">
									<div id="row${t.tranCd}" name="row" class="smallTableRow"><input type="hidden" name="tranCds1" value="${t.tranCd}" /><label>${t.tranDesc}</label></div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="curUserTransactions" name="curUserTransactions" style="display: none;">
		<json:object>
			<json:array name="curUserTransactions" var="t" items="${userTransactions}">
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
		<div style="margin: 10px; margin-bottom: 20px; float: left; width: 98.3%;">
			<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Modules</label></span>
			<div style="float: left; margin: 0 auto%; width: 100%;">
				<div style="float: left; margin: 0 auto; width: 100%;">
					<div style="margin: 0pt 2.5%; float: left; width: 95%;">
						<span style="width: 100%; margin-bottom: 3px; float: left;">
							<label style="margin-bottom: 5px; width: 53%;">Available Modules</label>
							<label style="margin-bottom: 5px; width: 47%;">Current Modules</label>
						</span>
						
						<div style="float: left; width: 47%;">
							<div id="moduleSelect" name="moduleSelect" class="moduleDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight2" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right2"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left2"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft2" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="moduleSelect1" name="moduleSelect1" class="moduleDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>	
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
							<div id="issSourcesSelect" name="issSourcesSelect" class="issSourcesDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight3" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right3"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left3"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft3" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="issSourcesSelect1" name="issSourcesSelect1" class="issSourcesDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
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
							<div id="lineSelect" name="lineSelect" class="lineDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
						<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
							<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight4" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right4"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left4"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
							<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft4" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
						</div>
						<div style="float: left; width: 47%;">
							<div id="lineSelect1" name="lineSelect1" class="lineDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="buttonsDiv" style="margin-top: 10px;">
		<input type="button" class="button" style="width: 60px;" id="btnSave" name="btnSave" value="Save" />
		<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	</div>
	
</form>
<div id="detailsDiv" style="display: none;">
</div>
<script>
	// transactions buttons
	$("allRight1").observe("click", function () {
		userTransferAllRight("transactionSelect", "transactionSelect1", "transactionDiv1", "tranCds", userFilterModulesIssSourcesByTranCd);
		// added - 07.05.2010
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
		deselectRows("transactionSelect1", "row");
	});
	$("right1").observe("click", function () {
		userTransferRight("transactionSelect", "transactionSelect1", "transactionDiv1", "tranCds", userFilterModulesIssSourcesByTranCd);
		// added - 07.05.2010
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");
		deselectRows("transactionSelect1", "row");
	});
	$("left1").observe("click", function () {
		/*
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");*/
		userTransferLeft("transactionSelect", "transactionSelect1", "transactionDiv", "tranCds");
	});
	$("allLeft1").observe("click", function () {
		/*
		clearDiv("moduleSelect1");
		clearDiv("issSourcesSelect1");
		clearDiv("lineSelect1");*/
		userTransferAllLeft("transactionSelect", "transactionSelect1", "transactionDiv", "tranCds");
	});

	// module buttons
	
	$("allRight2").observe("click", function () {
		userTransferAllRight("moduleSelect", "moduleSelect1", "moduleDiv1", "moduleIds", "");
	});
	$("right2").observe("click", function () {
		userTransferRight("moduleSelect", "moduleSelect1", "moduleDiv1", "moduleIds", "");
	});
	$("left2").observe("click", function () {
		userTransferLeft("moduleSelect", "moduleSelect1", "moduleDiv", "moduleIds");
	});
	$("allLeft2").observe("click", function () {
		userTransferAllLeft("moduleSelect", "moduleSelect1", "moduleDiv", "moduleIds");
	});

	// issue sources buttons
	
	$("allRight3").observe("click", function () {
		userTransferAllRight("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv1", "issCds", userRemoveCurrentLinesFromAvailable);
		// added - 07.05.2010
		clearDiv("lineSelect1");
		deselectRows("issSourcesSelect1", "row");
	});
	$("right3").observe("click", function () {
		userTransferRight("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv1", "issCds", userRemoveCurrentLinesFromAvailable);
		// added - 07.05.2010
		clearDiv("lineSelect1");
		deselectRows("issSourcesSelect1", "row");
	});
	$("left3").observe("click", function () {
		userTransferLeft("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv", "issCds");
	});
	$("allLeft3").observe("click", function () {
		userTransferAllLeft("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv", "issCds");
	});

	// line buttons
	
	$("allRight4").observe("click", function () {
		userTransferAllRight("lineSelect", "lineSelect1", "lineDiv1", "lineCds", "");
		deselectRows("lineSelect1", "row");
	});
	$("right4").observe("click", function () {
		userTransferRight("lineSelect", "lineSelect1", "lineDiv1", "lineCds", "");
		deselectRows("lineSelect1", "row");
	});
	$("left4").observe("click", function () {
		userTransferLeft("lineSelect", "lineSelect1", "lineDiv", "lineCds");
	});
	$("allLeft4").observe("click", function () {
		userTransferAllLeft("lineSelect", "lineSelect1", "lineDiv", "lineCds");
	});

	userRemoveCurrentTransactionsFromAvailable("transactionSelect", "transactionSelect1");

	$("btnCancel").observe("click", function () {
		Effect.Fade("transactionDiv", {
			duration: .2,
			afterFinish: function () {
				$("transactionDiv").innerHTML = "";
				Effect.Appear("userListingMainDiv", {duration: .2});
			}
		});
	});
	
	// Populate modules
	new Ajax.Updater("detailsDiv", contextPath+"/GIISUserMaintenanceController", {
		method: "GET",
		parameters: {
			action: "populateModules",
			ajax: 1,
			userID: $F("userID")
		},
		insertion: "bottom",
		onCreate: showNotice("Loading modules..."),
		evalScripts: true,
		asynchronous: true,
		onComplete: function () {
			// Populate issue sources
			new Ajax.Updater("detailsDiv", contextPath+"/GIISUserMaintenanceController", {
				method: "GET",
				parameters: {
					action: "populateIssueSources",
					ajax: 1,
					userID: $F("userID")
				},
				insertion: "bottom",
				onCreate: showNotice("Loading issue sources..."),
				evalScripts: true,
				asynchronous: true,
				onComplete: function () {
					// Populate line of business
					new Ajax.Updater("detailsDiv", contextPath+"/GIISUserMaintenanceController", {
						method: "GET",
						parameters: {
							action: "populateLines",
							ajax: 1,
							userID: $F("userID")
						},
						insertion: "bottom",
						onCreate: showNotice("Loading lines of business..."),
						evalScripts: true,
						asynchronous: true,
						onComplete: function () {
							hideNotice("");
							initializeAll();
							initializeTable("transactionDiv", "row", "", "");
							initializeTable("transactionDiv1", "row", "", userFilterModulesIssSourcesByTranCd);
						}
					});
				}
			});
		}
	});

	$("btnModules").observe("click", function () {
		Effect.toggle("moduleList", "blind", {duration: .3}); //$("moduleList").toggle();
	});

	curUserTransactions = $("curUserTransactions").innerHTML.evalJSON();
	/*userModules = $("userModules").innerHTML.evalJSON();
	userIssSources = $("userIssSources").innerHTML.evalJSON();
	userLines = $("userLines").innerHTML.evalJSON();*/
	
	$("btnSave").observe("click", function () {
		var userID = $F("userID");
		var pTransactions = new Array();
		var pIssueSources = new String();
		var pModules = new String();
		var pLines = new String();
		var tranCd = "";

		for (var i=0; i<curUserTransactions.curUserTransactions.length; i++) {
			tranCd = curUserTransactions.curUserTransactions[i].tranCd;
			pTransactions[i] = tranCd;

			// modules
			var ppModules = new Array();
			for (var l=0; l<curUserModules.curUserModules.length; l++) {
				if (curUserModules.curUserModules[l].tranCd == tranCd) {
					ppModules.push(curUserModules.curUserModules[l].moduleId);
				}
			}
			if (ppModules.length == 0) {
				pModules+= "void";
			} else {
				pModules+= ppModules;
			}

			// issue sources and lines
			var ppIssSources = new Array();
			for (var j=0; j<curUserIssSources.curUserIssSources.length; j++) {
				var ppLines = new Array();
				if (curUserIssSources.curUserIssSources[j].tranCd == tranCd) {
					var issCd = curUserIssSources.curUserIssSources[j].issCd;
					ppIssSources.push(issCd);

					curUserLines.curUserLines.findAll(function (k) {
						if (k.tranCd == tranCd && k.issCd == issCd) {
							ppLines.push(k.lineCd);
						}
					});

					if (ppLines.length == 0) {
						pLines+= "void";
					} else {
						pLines+= ppLines;
					}

					if (!(j == curUserIssSources.curUserIssSources[j].length-1)) {
						pLines+= "--";
					}
				}
			}
			if (ppIssSources.length == 0) {
				pIssueSources+= "void";
			} else {
				pIssueSources+= ppIssSources;
			}
			if (!(i == curUserTransactions.curUserTransactions.length-1)) {
				pIssueSources+= "--";
				pModules+= "--";
			}
			pLines+= "]";
			
		}

		new Ajax.Request(contextPath+"/GIISUserMaintenanceController?pTransactions="+pTransactions+"&pModules="+pModules+"&pIssSources="+pIssueSources+"&pLines="+pLines, {
			method: "GET",
			parameters: {
				action: "setUserTransaction",
				ajax: 1,
				userID: userID
			},
			onCreate: function () {
				showNotice("Saving, please wait...");
				$("transactionForm").disable();
				$$("input[type='button']").invoke("removeClassName", "button");
				$$("input[type='button']").invoke("addClassName", "disabledButton");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					hideNotice(response.responseText);
				}
				$("transactionForm").enable();
				$$("input[type='button']").invoke("addClassName", "button");
				$$("input[type='button']").invoke("removeClassName", "disabledButton");
				showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS); //added for message when record is successfully saved
			},
			evalScripts: true,
			asynchronous: true
		});
	});
</script>
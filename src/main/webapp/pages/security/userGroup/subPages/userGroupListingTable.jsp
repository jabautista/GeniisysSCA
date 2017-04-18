<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="userGrp" name="userGrp" value="" />
<div style="margin: 5px; display: none;">
	
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>

	<div class="tableHeader">
		<label style="width: 10%; text-align: left; margin-left: 20px;">User Group</label>
		<label style="width: 30%; text-align: left;">User Group Desc</label>
		<label style="width: 20%; text-align: left;">Issue Source Name</label>
		<label style="width: 37%;">Remarks</label>
		<!-- <label style="width: 12%; text-align: center;">User Id</label> -->
	</div>
	<div id="userGroupListTable" class="tableContainer">
		<c:forEach var="userGroup" items="${searchResult}">
			<div id="row${userGroup.userGrp}" name="row" class="tableRow">
				<label style="width: 10%; text-align: left; margin-left: 20px;">${userGroup.userGrp}</label>
				<label style="width: 30%; text-align: left;" title="${userGroup.userGrpDesc}" name="userGrpDesc">${userGroup.userGrpDesc}</label>
				<label style="width: 20%; text-align: left;">${userGroup.issName}</label>
				<label style="width: 37%; text-align: left;" title="${userGroup.remarks}" name="remarks">${userGroup.remarks}</label>
				<!-- <label style="width: 12%; text-align: center;">${userGroup.userId}</label> -->
			</div>
		</c:forEach>
	</div>
	
	<div id="userGroupListingJSON" name="userGroupListingJSON" style="display: none;">
		<json:object>
			<json:array name="userGroup" var="p" items="${searchResult}">
				<json:object>
					<json:property name="userGrp" 		value="${p.userGrp}" />
					<json:property name="userGrpDesc" 	value="${p.userGrpDesc}" />
					<json:property name="issName" 		value="${p.issName}" />
					<json:property name="remarks" 		value="${p.remarks}" />
					<json:property name="userId" 		value="${p.userId}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
	initializeTable("tableContainer", "row", "userGrp", "");

	//$("delete").hide();
	$("delete").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a user group.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Delete Confirmation",
				   	   	   "Are you sure you want to delete this user group?",
				   	       "Yes", "No", continueDeleteUserGrp, "");
		}
	});

	//var userGroupList = ($("userGroupListingJSON").innerHTML).evalJSON();
	var userGroupList = eval((((('(' + $("userGroupListingJSON").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	
	var addtlTools = "<label id='transaction' name='transaction' style='width: 100px;'>Transaction</label>";
	
	$("delete").insert({after: addtlTools});
	$("edit").hide();
	if (!$("pager").innerHTML.blank()) {
		initializePagination("userGroupListingTable", "/GIISUserGroupMaintenanceController", "getUserGroupList");
	}

	$("filter").observe("click", function ()	{
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});
	
	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	function getTransactions() {
		try {
			if ($F("userGrp").blank()) {
				showMessageBox("Please select a user group.", imgMessage.ERROR);
				return false;
			} else {
				new Ajax.Updater("transactionDiv", contextPath+"/GIISUserGroupMaintenanceController", {
					method: "GET",
					parameters: {
						action: "transactionMaintenance",
						userGrp: $F("userGrp"),
						userGrpDesc: $("row"+$F("userGrp")).down("label", 1).innerHTML,
						issName: $("row"+$F("userGrp")).down("label", 2).innerHTML,
						ajax: 1
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: function () {
						Effect.Fade("userGroupListingMainDiv", {
							duration: .3,
							afterFinish: showNotice("Getting transactions, please wait...")
						});
					},
					onComplete: function () {
						hideNotice();
						//$("issName").value = $("row"+$F("userGrp")).down("label", 2).innerHTML;
						Effect.Appear("transactionDiv", {duration: .3});
						$("userGrpId").readOnly = true;
					}
				});
			}
		} catch (e) {
			showErrorMessage("getTransactions", e);
		}
	}

	$("transaction").observe("click", function () {
		getTransactions();
	});

	$("add").observe("click", function () {
		new Ajax.Updater("transactionDiv", contextPath+"/GIISUserGroupMaintenanceController", {
			method: "GET",
			parameters: {
				action: "transactionMaintenance",
				ajax: 1
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function () {
				Effect.Fade("userGroupListingMainDiv", {
					duration: .3,
					afterFinish: showNotice("Creating form, please wait...")
				});
			},
			onComplete: function () {
				hideNotice();
				Effect.Appear("transactionDiv", {duration: .3});
			}
		});
	});

	try {
		$("filterText").observe("keyup", function (evt) {
			if (evt.keyCode == 27) {
				$("filterText").clear();
				showAllRows("userGroupListTable", "row");
				Effect.Fade("filterSpan", {
					duration: .3
				});
			} else if (evt.keyCode == 13) {
				Effect.Fade("filterSpan", {
					duration: .3
				});
			} else {
				var text = ($F("filterText").strip()).toUpperCase();
				for (var i=0; i<userGroupList.userGroup.length; i++)	{
					if (userGroupList.userGroup[i].userGrp.toString().toUpperCase().match(text) != null || 
						userGroupList.userGroup[i].userGrpDesc.toUpperCase().match(text) != null || 
						userGroupList.userGroup[i].issName.toUpperCase().match(text) != null || 
						userGroupList.userGroup[i].remarks.toUpperCase().match(text) != null || 
						userGroupList.userGroup[i].userId.toUpperCase().match(text) != null) {
						$("row"+userGroupList.userGroup[i].userGrp).show();
					} else {
						$("row"+userGroupList.userGroup[i].userGrp).hide();
					}
				}
			}

			positionPageDiv();
		});
	} catch (e) {
		showErrorMessage("userGroupListingTable.jsp", e);
	}

	$$("label[name='remarks']").each(function (e) {
		e.update(e.innerHTML.truncate(50, "..."));
	});

	$$("label[name='userGrpDesc']").each(function (e) {
		e.update(e.innerHTML.truncate(35, "..."));
	});
	
	positionPageDiv();
</script>
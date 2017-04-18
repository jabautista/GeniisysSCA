<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="userId" name="userId" value="" />
<div style="margin: 5px; display: none;">
	
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	
	<div class="tableHeader">
		<label style="width: 12%; text-align: left; margin-left: 20px;">User Id</label>
		<label style="width: 18%; text-align: left;">User Name</label>
		<label style="width: 30%; text-align: left;">User Group</label>
		<label style="width: 21.3%; text-align: left;">Group Issue Source</label>
		<label style="width: 20px; text-align: center;" title="Active Flag ">A</label>
		<label style="width: 20px; text-align: center;" title="Commission Update Tag ">C</label>
		<label style="width: 20px; text-align: center;" title="All User Switch ">U</label>
		<label style="width: 20px; text-align: center;" title="Manager Switch ">M</label>
		<label style="width: 20px; text-align: center;" title="Marketing Switch ">K</label>
		<label style="width: 20px; text-align: center;" title="MIS Switch ">I</label>
		<label style="width: 20px; text-align: center;" title="Workflow Tag ">W</label>
	</div>
	<div id="userListTable" class="tableContainer">
		<c:forEach var="user" items="${searchResult}">
			<div id="row${user.userId}" name="row" class="tableRow" userGrp="${user.userGrp}">
				<label style="width: 12%; text-align: left; margin-left: 20px;">${user.userId}</label>
				<label style="width: 18%; text-align: left;">${user.username}</label>
				<label style="width: 30.3%; text-align: left;">${user.userGrpDesc}</label>
				<label style="width: 21.5%; text-align: left;">${user.issName}</label>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.activeFlag}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.commUpdateTag}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.allUserSw}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.mgrSw}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.mktngSw}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.misSw}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
				<span style="float: left; width: 20px; text-align: center;">
					<c:choose>
						<c:when test="${'Y' eq user.workflowTag}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<label style="float: left; width: 10px; height: 10px; text-align: center;">-</label>
						</c:otherwise>
					</c:choose>
				</span>
			</div>
		</c:forEach>
	</div>
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
	initializeTable("tableContainer", "row", "userId", "");

	$("filter").observe("click", function ()	{
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	var addtlTools = "<label id='changePassword' name='changePassword' style='width: 120px;'>Change Password</label>"+
					 "<label id='transaction' name='transaction' style='width: 100px;'>Transaction</label>"+
					 "<label id='groupAccess' name='groupAccess' style='width: 100px;'>Group Access</label>"+
					 "<label id='history' name='history'>History</label>";
	
	$("edit").insert({after: addtlTools});

	function getTransactions() {
		try {
			if ($F("userId").blank()) {
				showMessageBox("No user selected.", imgMessage.ERROR);
				return false;
			} else {
				new Ajax.Updater("transactionDiv", contextPath+"/GIISUserMaintenanceController", {
					method: "GET",
					parameters: {
						action: "transactionMaintenance",
						userID: $F("userId"),						
						username: $("row"+$F("userId")).down("label", 1).innerHTML, //test
						ajax: 1
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: function () {
						Effect.Fade("userListingMainDiv", {
							duration: .2,
							afterFinish: showNotice("Getting transactions, please wait...")
						});
					},
					onComplete: function () {
						//hideNotice();
						//$("issName").value = $("row"+$F("userGrp")).down("label", 2).innerHTML;
						Effect.Appear("transactionDiv", {duration: .2});
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
	
	$("changePassword").observe("click", function () {
		if ($F("userId").blank()) {
			showMessageBox("No user record selected!", imgMessage.ERROR);
			return false;
		} else {
			//showMe(contextPath+"/GIISUserMaintenanceController?action=changePasswordForm&userId="+$F("userId"), 425);
			showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=changePasswordForm&userId="+$F("userId"), "Change Password", "", $$("body").first().getWidth()/2-220, $$("body").first().getHeight()/2+150, 190);
		}
	});

	$("search").observe("click", function () {
		//$("searchSpan").setStyle("top: " + (parseInt($("search").cumulativeOffset()[1])+parseInt($("search").getHeight())+3)+"px");
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	/*$("delete").observe("click", function () {
		showMessageBox("Deletion of users id not allowed");
		if ($F("userId").blank()) {
			showMessageBox("No record selected!");
		} else {
			showConfirmBox("Delete Confirmation",
						   "Are you sure you want to delete this record?",
						   "Yes",
						   "Cancel",
						   continueUserDelete,"");
		}
	});*/
	$("delete").hide();

	$("edit").observe("click", function () {
		if ($F("userId").blank()) {
			showMessageBox("No user record selected!", imgMessage.ERROR);
		} else {
			//showMe(contextPath+"/GIISUserMaintenanceController?action=getEditUserForm&userId="+$F("userId"), 640);
			showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=getEditUserForm&userId="+encodeURIComponent($F("userId")), "Edit/Update User", "", $$("body").first().getWidth()/2-320, $$("body").first().getHeight()/2+150, 280);
		}
	});

	$("add").observe("click", function () {
		//showMe(contextPath+"/GIISUserMaintenanceController?action=getEditUserForm", 640);
		showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=getEditUserForm", "Add New User", "", $$("body").first().getWidth()/2-320, $$("body").first().getHeight()/2+150, 280);
	});

	changeCheckImageColor();

	// initialize pagination
	if (!$("pager").innerHTML.blank()) {
		initializePagination("userListingTable", "/GIISUserMaintenanceController?"+Form.serialize("searchForm"), "getUserList"); //marco - 05.22.2013 - added searchForm parameter
	}

	/*******************************/
	$("groupAccess").observe("click", function (){
		if ($F("userId").blank()){
			showMessageBox("No user record selected!", imgMessage.ERROR);
		} else {
			showOverlayContent(contextPath+"/GIISUserGroupMaintenanceController?action=getUserGroupAccess&userId="+encodeURIComponent($F("userId")), "User Group Access", "",
					$$("body").first().getWidth()/2-350, $$("body").first().getHeight()/2, 300);
		}
	});

	$("history").observe("click", function (){
		if ($F("userId").blank()){
			showMessageBox("No user record selected!", imgMessage.ERROR);
		} else {
			showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=getUserHistory&userId="+encodeURIComponent($F("userId")), "User History",
					"", $$("body").first().getWidth()/2-350, $$("body").first().getHeight()/2+40, 300);/*
			showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=getUserHistory&userId="+$F("userId"), "User History", "", $$("body").first().getWidth()/2-320, $$("body").first().getHeight()/2+150, 280);*/
		}
	});
</script>
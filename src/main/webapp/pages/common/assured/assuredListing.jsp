<!-- 
Remarks: For deletion
Date : 01-05-2012
Developer: Bonok
Replacement : /pages/common/assured/assuredListingTableGrid.jsp 
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="assuredNo" name="assuredNo" value="" />
<div id="assuredListingMainDiv" name="assuredListingMainDiv" style="display: none; float: left; width: 100%;">
	<div id="assuredListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="assuredListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%;">
		<div id="innerDiv" name="innerDiv">
			<label>Assured Listing</label>
			<!-- <span style="float: right; font-size: 10px; cursor: pointer;" id="search" name="search">Search</span> -->
			<!-- <span style="float: right; font-size: 10px; cursor: pointer; padding-right: 10px;" id="filter" name="filter">Filter</span> -->
		</div>
	</div>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<div id="assuredListingTable" name="assuredListingTable" class="sectionDiv tableContainer" style="height: 410px; width: 100%; padding: 0;">
		<div id="assuredListingTableDiv" style="margin: 5px;">
			<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
			<div class="tableHeader">
				<label style="width: 20%; text-align: left; margin-left: 20px;">Corporate Tag</label>
				<label style="width: 30%; text-align: left;">Assured Name</label>
				<label style="width: 37%; text-align: left;">Address</label>
				<label style="width: 10%; text-align: left;">Active Tag</label>
			</div>
			<div id="assuredListTable" name="assuredListTable" class="tableContainer" style="font-size: 12px;">
				
			</div>
			<div class="pager" id="pager">
				<div align="right" style="margin-top: 10px;">
				Page:
					<select id="page" name="page">
						
					</select> of <span id="totalPages"></span>
				</div>
			</div>
		</div>
	</div>
	<!-- <div class="buttonsDiv">
		<input type="button" class="button" id="btnCreateAssured" name="btnCreateAssured" value="Add Assured" />
		<input type="button" class="button" id="btnEditAssured" name="btnEditAssured" value="Edit Assured" />
	</div> -->
</div>

<div id="assuredDiv" name="assuredDiv" style="margin-top: 1px; display: none;">
</div>

<script type="text/javascript">
	setModuleId("GIISS006");
	setDocumentTitle("Assured Listing");
	var assuredList = "";
	var userId = '${userId}'; // ++ rmanalad 4.12.2011
	//initializeAll();

	//$("keyword").stopObserving();
	
	$("keyword").observe("keypress", function (evt) {
		onEnterEvent(evt, getAssuredList);
	});

	function submitSearch() {
		goToPageNo("assuredListingTable", "/GIISAssuredController?isFromAssuredListingMenu=true", "getAssuredListing", 1);
	}

	$("go").observe("click", function () {
		fadeElement(this.up("span", 1), .3, null);
		getAssuredList(1);
		//goToPageNo("assuredListingTable", "/GIISAssuredController?isFromAssuredListingMenu=true", "getAssuredListing", 1);
	});

	function getAssuredList(pageNo) {
		new Ajax.Request("GIISAssuredController", {
			method: "GET",
			parameters: {
				action: "getAssuredListing",
				isFromAssuredListingMenu: "true",
				pageNo: pageNo == undefined ? $F("page") : pageNo,
				keyword: $F("keyword")
			},
			onCreate: showLoading("assuredListTable", "Getting assured list, please wait...", "100px"),
			onComplete: function (response) {
				assuredList = response.responseText.evalJSON();
				generateAssuredTable(assuredList);
				initializeAssuredTable();
			}
		});
	}

	function generateAssuredTable(list) {
		$("assuredListTable").update();
		for (var i=0; i<list.jsonArray.length; i++) {
			var assd = list.jsonArray[i];
			var row = '<div id="row'+assd.assdNo+'" name="row" class="tableRow">'+
					  '<label style="width: 20%; text-align: left; margin-left: 20px;">'+assd.corporateTag+'</label>'+
					  '<label style="width: 30.5%; text-align: left;" name="assdName" title="'+assd.assdName+'">'+assd.assdName+'</label>';
			if (assd.mailAddress1.trim().blank() && assd.mailAddress2.trim().blank() && assd.mailAddress3.trim().blank()) {
				row+= '<label style="width: 36%; text-align: left;" name="address">-</label>';
			} else {
				assd.mailAddress1 = assd.mailAddress1 == null ? "" : assd.mailAddress1;
				assd.mailAddress2 = assd.mailAddress2 == null ? "" : assd.mailAddress2;
				assd.mailAddress3 = assd.mailAddress3 == null ? "" : assd.mailAddress3;
				row+= '<label style="width: 36%; text-align: left;" name="address" title="'+assd.mailAddress1+assd.mailAddress2+assd.mailAddress3+'">'+assd.mailAddress1+" "+assd.mailAddress2+" "+assd.mailAddress3+'</label>';
			}
			
			row+= '<label style="width: 10%; text-align: center;">'+assd.activeTag+'</label>'+
			      '<label style="display: none;">'+assd.userId+'</label>'+
				   '</div>';
			$("assuredListTable").insert({bottom: row});
		}
	}
	
	$("filterText").observe("keyup", function (evt) {
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("assuredListTable", "row");
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else if (evt.keyCode == 13) {
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else {
			var text = ($F("filterText").strip()).toUpperCase();

			$$("div[name='row']").each(function (row) {
				if (null != row.down("label", 0).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 1).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 2).innerHTML.toUpperCase().match(text)) {
					row.show();
				} else {
					row.hide();
				}
				if (!$("pager").innerHTML.blank()) {
					positionPageDiv();
				}
			});
		}
	});

	// moved from assuredListingTable.jsp - whofeih
	function initializeAssuredTable() {
		$("page").update();
		for (var i=1; i<=assuredList.noOfPages; i++) {
			$("page").insert({bottom: '<option value="'+i+'">'+i+'</option>'});
		}
		for (var i=0; i<$("page").length; i++) {
			if ($("page").options[i].value == assuredList.pageNo) {
				$("page").options[i].selected = "selected";
			}
		}
		
		$("totalPages").update(assuredList.noOfPages);
		//positionPageDiv();
		
		$$("label[name='address']").each(function (lbl) {
			lbl.update((lbl.innerHTML).truncate(40, "..."));
		});
	
		$$("label[name='assdName']").each(function (lbl) {
			lbl.update((lbl.innerHTML).truncate(35, "..."));
		});

		// initialize row events
		$$("div[name='row']").each(
			function (row)	{
				loadRowMouseOverMouseOutObserver(row);
				
				row.observe("click", function ()	{
					row.toggleClassName("selectedRow");
					if (row.hasClassName("selectedRow"))	{
						$("assuredNo").value = row.getAttribute("id").substring(3);
						($$("div#assuredListTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
						/*
						$$("div[name='row']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						*/
					} else {
						$("assuredNo").value = "";
					}
				});
				row.observe("dblclick", function(){ // rmanalad added for test-case 4.8.2011
					row.toggleClassName("selectedRow");
					if (row.hasClassName("selectedRow"))	{
						$("assuredNo").value = row.getAttribute("id").substring(3);
						($$("div#assuredListTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
						showAssuredMaintenance();
					} else {
						$("assuredNo").value = "";
					}							
				});
			}
		);
	}

	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	$("filter").observe("click", function () {
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	//modified by andrew - 03.02.2011
	observeAccessibleModule(accessType.TOOLBUTTON, "GIISS006B", "edit", showAssuredMaintenance);
				
	function showAssuredMaintenance(){
		var overideSw = 'N'; //-- rmanalad test-case 4.8.2011
		try {
			if ($F("assuredNo").blank()) {
				showMessageBox("Please select an assured first.", imgMessage.ERROR);
				return false;
			} else {
				//showMaintainAssuredForm($F("assuredNo"));
				if (checkIfEditAllowed()){
					//showMessageBox('You are allowed to edit the assured and industry.', imgMessage.INFO);
					//showMessageForPolicyChecking(); -- rmanalad 4.12.2011
					showMessageForPolicyChecking(overideSw); // ++rmanalad 4.12.2011
				} else {
					// modified by andrew - 02.09.2011
					showConfirmBox4('Edit Assured', 'You are not allowed to edit the assured and assured type. Do you wish to override?',
							"Override", "View Details", "Cancel",
							overideFunc, 
							function(){maintainAssured("assuredListingMainDiv", $F("assuredNo"), 'true');}, 
							"");
				}
			}
		} catch (e) {
			showErrorMessage("showAssuredMaintenance", e);
		}
	}	

	function overideFunc(){
		//shows login page as modalbox
		showOverlayContent2(contextPath+"/pages/common/subPages/assured/pop-ups/assuredOverideUser.jsp",
				'Overide User', 350, "");
	}

	$("add").observe("click", function () {
		//showMaintainAssuredForm($F("assuredNo"));
		maintainAssured("assuredListingMainDiv", "");
	});

	$("delete").observe("click", function () {
		if ($F("assuredNo").blank()) {
			//showMessageBox("No assured selected.", imgMessage.ERROR);
			showMessageBox("Please select an assured first.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Delete assured confirmation", "This will delete all information pertaining to this Assured.  Do you want to continue?", 
					"Yes", "No", deleteAssured, "");
		}
	});
	
	$("page").observe("change", function () {
		getAssuredList(this.value);
	});
		
	function deleteAssured() {
		new Ajax.Request(contextPath+"/GIISAssuredController?action=checkAssuredDependencies&assdNo="+$F("assuredNo"), {
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Checking assured dependencies, please wait..."),
			onComplete: function (response) {
				if (response.responseText.stripTags().trim().blank()) {
					new Ajax.Request(contextPath+"/GIISAssuredController?action=deleteAssured&assdNo="+$F("assuredNo"), {
						asynchronous: true,
						evalScripts: true,
						onCreate: showNotice("Deleting, please wait..."),
						onComplete: function (response1) {
							hideNotice();
							if (checkErrorOnResponse(response1)) {
								showMessageBox("Record Deleted");
								$("row"+$F("assuredNo")).remove();
								positionPageDiv();
							} 
						}
					});
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					return false;
				}
			}
		});
	}
	
	if (modules.all(function (mod) {return mod != 'GIISS006B';})) {
		$("add").hide();
	}

	var marRight = parseInt((screen.width - mainContainerWidth)/2);
	$("filterSpan").setStyle("right: " + marRight + "px; top: 105px;");
	$("searchSpan").setStyle("right: " + marRight + "px; top: 105px;");
	
	getAssuredList(1);
	/* end of moved from */
	
	/***************************/
	
	function checkIfEditAllowed(){
		var isAllowed = false;	
		//this function is created for checking if user is allowed to edit a record
		new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=checkIfUserAllowedForEdit", {
				method: "POST",
				parameters: {
					//userId: getUserIdParameter(), --rmanalad 4.12.2011
					userId: userId, // ++ rmanalad 4.12.2011
					moduleName: "GIISS006B"
				},
				evalScripts: true,
				asynchronous: false,
				onSuccess: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							isAllowed = true;
							
						} 
					}
				}
		});

		return isAllowed;
	}

	$("assuredListingExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
</script>
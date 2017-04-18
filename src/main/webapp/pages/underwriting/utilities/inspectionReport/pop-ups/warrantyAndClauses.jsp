<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="inspWcMainDiv" name="inspWcMainDiv" style="margin-top: 1px; float: left; width: 99%;">
	<div class="sectionDiv" style="float: left;">
		<div id="warrAndClauseInfo" name="warrAndClauseInfo" style="width : 100%; margin-bottom: 15px;">
			<div id="wcTable" style="margin : 5px;">
				<div class="tableHeader">
					<label style="text-align: right; width: 12%;">WC Code</label>
					<label style="text-align: left; width: 35%; margin-left: 10px;">WC Title</label>
					<label style="text-align: left; width: 35%; margin-left: 10px;">WC Text</label>
				</div>
				<div id="wcTableContainer" class="wcTableContainer">
		
				</div>
			</div>
		</div>
		 <table align="center">
		 	<tr>
		 		<td class="rightAligned">Main WC Cd</td>
		 		<td class="leftAligned">
		 			<input type="text" id="mainWcCd" name="mainWcCd" style="width: 50px;" readonly="readonly"/>
		 		</td>
		 		<td class="rightAligned">Warranty Title </td>
				<td colspan="3" class="leftAligned">
					<%-- <select id="warrantyTitle" name="warrantyTitle" style="width: 400px;" class="required">
						<option value=""></option>
						<c:forEach var="wc" items="${wcTitles}">
							<option value="${wc.wcCd}" wcTitle="${wc.wcTitle}" wcText="${wc.wcText}" >${wc.wcTitle}</option>										
						</c:forEach>
					</select> --%>
					<span class="required lovSpan" style="width: 400px;">
						<input type="text" id="warrantyTitle" name="warrantyTitle" style="width: 375px; float: left; border: none; height: 13px; margin: 0;" class="required" readonly="readonly"></input>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarranty" name="searchWarranty" alt="Go" style="float: right;"/>
					</span>
				</td>
		 	</tr>
		 	<tr>
				<td class="rightAligned">Warranty Text </td>
				<td colspan="5" class="leftAligned">
					<div id="remarksDiv" name="remarksDiv" style="border: 1px solid gray; height: 20px; width: 548px;">
						<textarea id="warrantyText" name="warrantyText" style="width: 521px; border: none; height: 13px; margin-top: 0;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
					</div>
				</td>
			</tr>
			<tr align="center">
				<td colspan="8">
					<input type="button" class="button" style="width: 60px; margin-top: 5px; margin-bottom: 5px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="button" style="width: 60px; margin-top: 5px; margin-bottom: 5px;" id="btnDelete" name="btnDelete" value="Delete" />
				</td>
			</tr>
		 </table>
	 </div>
	 <div class="sectionDiv" style="text-align: center; border: none;">
	 	<input type="button" class="button" id="btnWcOk" style="width: 100px; margin-top: 10px; margin-bottom: 10px;" name="btnWcOk" value="OK" />
	 	<input type="button" class="button" id="btnWcCancel" style="width: 100px; margin-top: 10px; margin-bottom: 10px;" name="btnWcCancel" value="Cancel" onclick="Modalbox.hide();" />
	 </div>
</div>
<script type="text/javascript">
	var updateAllowed = true;
	initializeAll();
	initializeAccordion();
	if ($("approvedTag").checked){
		$("mainWcCd").disable();
		//$("warrantyTitle").disable();
		//$("warrantyText").disable();
		//updateAllowed = false;
		disableSearch("searchWarranty");  //added by steven 9/3/2012
		disableButton("btnAdd");
		disableButton("btnDelete");
	}
	changeTag = 0;

	//var currentWc = JSON.parse('${currentWc}'.replace(/\\/g, '\\\\'));
	var currentWc = JSON.parse('${currentWc}');
	//currentWc = currentWc.concat(inspectionReportObj.insertedWcObjects); --john
	inspectionReportObj.insertedWcObjects = [];
	inspectionReportObj.deletedWcObjects = [];
	
	fillWcTable();
	//removeAddedWc();
	
	 function fillWcTable(){
		for (var i = 0; i < currentWc.length; i++){
			var wcCd = currentWc[i].wcCd;
			createWcRow(j, currentWc[i]);
			/* for (var j = 0; j < $("warrantyTitle").length; j++){
				if ($("warrantyTitle").options[j].value == wcCd){
					createWcRow(j);
				}
			} */ 
		}
	}
 	
	function createWcObject(){
		var wcObject = new Object();
		wcObject.inspNo = $F("inspNo");
		//wcObject.wcCd = id;
		wcObject.wcCd = $F("mainWcCd");
		wcObject.wcTitle = escapeHTML2($("warrantyTitle").value);
		wcObject.wcTexts = escapeHTML2($("warrantyText").value);
		return wcObject;
	}
	
	function createWcRow(index, obj){
		var row = new Element("div");
		/* var id = $("warrantyTitle").options[index].value;
		var title = $("warrantyTitle").options[index].innerHTML;
		var text = $("warrantyTitle").options[index].getAttribute("wcText"); */
		var id = obj == null ? $F("mainWcCd") : obj.wcCd;
		var title = obj == null ? $F("warrantyTitle") : obj.wcTitle;
		var text = obj == null ? $F("warrantyText") : obj.wcTexts;
		var recordStatus = obj == null ? 1 : 0;
		
		row.setAttribute("class", "tableRow");
		row.setAttribute("id", "wcRow"+id);
		row.setAttribute("wcCd", id);
		row.setAttribute("name", "wcRow");
		row.setAttribute("wcTitle", title);
		row.setAttribute("wcText", text);
		row.setAttribute("recordStatus", recordStatus);
		var content = '<label style="text-align: right; width: 12%;">' + id + '</label>' +
					  '<label style="text-align: left; width: 35%; margin-left: 10px;">' + title.truncate(30, "...") + '</label>' +
					  '<label style="text-align: left; width: 45%; margin-left: 10px;">' + text.truncate(45, "...") + '</label>';
		row.update(content);
		$("wcTableContainer").insert({bottom : row});
		//removeAddedWc();
		checkIfToResizeTable("wcTableContainer", "wcRow");
		Modalbox.resizeToContent();
		putObserverOnRow(row);
	}

	function putObserverOnRow(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function (){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div[name='wcRow']").each(function (row2){
					if (row.id != row2.id){
						row2.removeClassName("selectedRow");
					}
					$("warrantyTitle").value = unescapeHTML2(row.down("label", 0).innerHTML);
					$("mainWcCd").value = unescapeHTML2(row.down("label", 0).innerHTML);
					$("warrantyText").value = unescapeHTML2(row.getAttribute("wcText"));
					$("warrantyTitle").disable();
					disableSearch("searchWarranty");
					if (!$("approvedTag").checked){
						disableButton("btnAdd");
						enableButton("btnDelete");
						//$("btnAdd").value = "Delete";
					}
				});
			} else {
				clearWcDtls();
			}
		});
	}
	
	function addObserveRowFunctions(){
		$$("div[name='wcRow']").each(function (row){
			utObserverOnRow(row);
		});
	}
	
	function clearWcDtls(){
		/* $("warrantyTitle").selectedIndex = 0;
		$("warrantyTitle").enable(); */
		$("warrantyTitle").value = "";
		$("mainWcCd").value = "";
		$("warrantyText").value = "";
		enableSearch("searchWarranty");

		if (!$("approvedTag").checked){
			enableButton("btnAdd");
			disableButton("btnDelete");
			//$("btnAdd").value = "Add";
		}
	}

	/* function removeAddedWc(){
		var idArray = new Array();
		$$("div[name='wcRow']").each(function (row){
			idArray.push(row.down("label", 0).innerHTML);
		});

		for (var i = 0; i < idArray.length; i++){
			var id = idArray[i];
			for (j = 0; j < $("warrantyTitle").length; j++){
				if ($("warrantyTitle").options[j].value == id){
					$("warrantyTitle").options[j].setAttribute("disabled", "disabled");
				}
			}
		}
	} */

	/* $("warrantyTitle").observe("change", function(){
		$("mainWcCd").value = $F("warrantyTitle");
		$("warrantyText").value = $("warrantyTitle").options[$("warrantyTitle").selectedIndex].getAttribute("wcText");
	}); */
	function showInspectionWarrClaLOV(){
		var notIn = "";
		var withPrevious = false;
		$$("div[name='wcRow']").each(function(row) {
			if(withPrevious) notIn += ",";
			notIn += "'"+row.getAttribute("wcCd")+"'";
			withPrevious = true;
		});
		notIn = (notIn != "" ? "("+notIn+")" : "");
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISWarrClaLOV",
						    lineCd : "FI",
						    notIn : notIn,
						    page : 1},
			title: "Warranty / Clause",
			width: 650,
			height: 386,
			columnModel : [	{	id : "wcTitle",
								title: "Warranty Title",
								width: '450px'
							},
							{	id : "wcCd",
								title: "Code",
								width: '70px'
							},  
							{	id : "wcSw",
								title : "Type",
								width : '100px'
							}
						],
			draggable: true,
			onSelect: function(row){
					$("mainWcCd").value = unescapeHTML2(row.wcCd);
					$("warrantyTitle").value = unescapeHTML2(row.wcTitle);
					$("warrantyText").value = unescapeHTML2(row.wcText);
					changeTag = 1;
				}
		  });
	}
	
	$("searchWarranty").observe("click", function() {
		if(updateAllowed) {
			showInspectionWarrClaLOV();
		}
		
	});

	$("editWarrantyText").observe("click", function () {
		showOverlayEditor("warrantyText", 34000, $("warrantyText").hasAttribute("readonly"));
		
	});

	$("btnAdd").observe("click", function (){
		if ($F("warrantyTitle") == ""){
			showMessageBox("Please select a warranty.", imgMessage.ERROR);
			return false;
		} else {
			//createWcRow($("warrantyTitle").selectedIndex, null);
			createWcRow(null, null);
			//inspectionReportObj.insertedWcObjects.push(createWcObject($("warrantyTitle").options[$("warrantyTitle").selectedIndex].value));
			inspectionReportObj.insertedWcObjects.push(createWcObject());
			clearWcDtls();
		}
	});
	
	$("btnDelete").observe("click", function (){
		$$("div[name='wcRow']").each(function (row){
			if (row.hasClassName("selectedRow")){
				inspectionReportObj.deletedWcObjects.push(createWcObject(row.getAttribute("wcCd")));
				row.remove();
				//$("warrantyTitle").options[$("warrantyTitle").selectedIndex].removeAttribute("disabled");
				clearWcDtls();
				changeTag = 1;
			}
		});
	});

	/*
	$("btnDelete").observe("click", function (){
		$$("div[name='wcRow']").each(function (row){
			if (row.hasClassName("selectedRow")){
				//add saving of deleted row here
				inspectionReportObj.deletedWcObjects.push(createWcObject(row.getAttribute("wcCd")));
				row.remove();
				$("warrantyTitle").options[$("warrantyTitle").selectedIndex].removeAttribute("disabled");
				clearWcDtls();
			}
		});
	});*/

	$("btnWcOk").observe("click", function (){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			inspectionReportObj.insertedWcObjects2 = [];
			$$("div[name='wcRow']").each(function (row){
				if(row.getAttribute("recordStatus") == 1){
					for (var i = 0; i < inspectionReportObj.insertedWcObjects.length; i++){
						if (row.down(0).innerHTML == inspectionReportObj.insertedWcObjects[i].wcCd){
							inspectionReportObj.insertedWcObjects2.push(inspectionReportObj.insertedWcObjects[i]);
						}
					} 
				}
			});
			
			inspectionReportObj.insertedWcObjects = inspectionReportObj.insertedWcObjects2;
			
			saveWarrAndClauses();
		}
	});
	
	//added by robert 01.22.2014
	$("btnWcCancel").observe("click", function (){
		changeTag = 0; 
		Modalbox.hide();
	});
	
	checkIfToResizeTable("wcTableContainer", "wcRow");
	Modalbox.resizeToContent();
	
	function saveWarrAndClauses(){
		try{
			var params = unescapeInspectionReport(JSON.stringify(inspectionReportObj)); 
			new Ajax.Request(contextPath+"/GIPIInspectionReportController",{
				method: "POST",
				parameters: {
					action: "saveWarrAndClauses",
					params: params
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Saving inspection report. Please wait...");
				},
				onComplete: function (response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						hideNotice("");
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							inspectionReportObj.insertedWcObjects = [];
							inspectionReportObj.deletedWcObjects = [];
							changeTag = 0;
							Modalbox.hide();
						});
					}
				}
			});
		} catch (e){
			showErrorMessage("saveInspectionReport", e);
		}
	}
</script>
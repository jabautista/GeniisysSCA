<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="intermediaryDiv" name="intermediaryDiv" class="sectionDiv" style="width: 99%; margin-top: 3px;">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="intermediaryForm" name="intermediaryForm" style="margin: 10px;">
		<input type="hidden" id="assdNo" name="assdNo" value="${assdNo}" />
		<div id="intermediaryTable">
			<div class="tableHeader" id="intermediaryListingHeader" >
				<label style="text-align: center; width: 20%;">Line</label>
				<label style="text-align: left; width: 30%;">Intermediary No</label>
				<label style="text-align: left; width: 50%;">Intermediary Name</label>
			</div>
			<div id="intermediaryListing">
				<c:forEach var="i" items="${assdIntms}">
					<div name="intm" id="intm${fn:escapeXml(i.refIntmCd)}${i.intmNo}" class="tableRow" lineCd="${fn:escapeXml(i.refIntmCd)}" intmNo="${i.intmNo}" intmName="${fn:escapeXml(i.intmName)}">
						<label style="width: 20%; text-align: center;">${i.refIntmCd}</label>
						<label style="width: 30%;">${i.intmNo}</label>
						<label style="width: 50%;" title="${fn:escapeXml(i.intmName)}" name="intmName">${fn:escapeXml(i.intmName)}</label>
						<input type="hidden" name="lineCds" value="${fn:escapeXml(i.refIntmCd)}" />
						<input type="hidden" name="intmNo" value="${i.intmNo}" />
						<input type="hidden" name="intermediaryName" value="${fn:escapeXml(i.intmName)}" />
					</div>
				</c:forEach>
			</div>
		</div>
		
		<table id="tabDefaultIntermediary" align="center" style="width: 100%; margin-top: 10px;">
			<tr>
				<td class="rightAligned">Line</td>
				<td class="leftAligned">
					<select id="lineCd" name="lineCd" style="width: 220px;" class="required">
						<option value=""></option>
						<!-- marco - 07.11.2014 -->
						<c:forEach var="l" items="${lineListing}">
							<option value="${fn:escapeXml(l.lineCd)}" >${fn:escapeXml(l.lineName)}</option>
						</c:forEach>
					</select></td>
			</tr>
			<!-- benjo 09.07.2016 SR-5604 -->
			<%-- <tr>
				<td class="rightAligned">Intermediary</td>
				<td class="leftAligned">
					<select id="intermediaryNo" name="intermediaryNo" style="width: 218px;" class="required">
						<option value=""></option>
						<!-- marco - 06.19.2014 - escape HTML tags -->
						<c:forEach var="i" items="${intermediaries}">
							<option value="${i.intmNo}" >${fn:escapeXml(i.intmName)}</option>
						</c:forEach>
					</select></td>
			</tr> --%>
			<tr>
				<td class="rightAligned">Intermediary</td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 218px; height: 21px; margin-right: 3px;" class="required">
						<input type="hidden" id="txtIntmNo" name="txtIntmNo" value=""/>
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 190px; border: none;" id="txtIntmName" name="txtIntmName" readonly="readonly" class="required" />
						<img id="searchIntm" alt="goIntm" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>
				</td>
			</tr>
			<!-- end SR-5604 -->
			<!-- <tr>
				<td class="rightAligned">Intermediary Name</td>
				<td class="leftAligned">
					<input type="text" id="intermediaryName" name="intermediaryName" style="width: 210px;" /></td>
			</tr> -->
			<!-- <tr>
				<td></td>
				<td colspan="2" style="text-align: left; padding-left: 5px;">
					<input type="button" class="button" id="btnAddDI" name="btnAddDI" value="Add" style="width: 60px;" />
					<input type="button" class="disabledButton" id="btnDeleteDI" name="btnDeleteDI" value="Delete" style="width: 60px;" />
				</td>
			</tr> -->
		</table>
	</form>
	
	<div class="buttonsDivPopup">
		<input type="button" class="button" id="btnAddDI" name="btnAddDI" value="Add" style="width: 60px;" />
		<input type="button" class="disabledButton" id="btnDeleteDI" name="btnDeleteDI" value="Delete" style="width: 60px;" />
		<!--  robert, Cancel button first before Save button. -->
	</div>				
</div>
<div class="buttonsDivPopup">
	
	<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 60px;" id="btnSaveDI" name="btnSaveDI" value="Save" />
	<!--  robert, Cancel button first before Save button. -->
</div>

<script>
	// andrew - 03.02.2011 - added this 'if' block
	if($F("hidViewOnly") == "true") {
		$("btnSaveDI").hide();
		$("btnCancel").value = "Close";
		$("tabDefaultIntermediary").hide();
		var tempDiv = new Element("div", {id:"tempDiv"});
		tempDiv.update("No default intermediary records.");
		$("intermediaryListing").insert({bottom: tempDiv});
		/* benjo 03.07.2017 SR-5893 */
		//disableButton("btnAddDI");
		$("btnAddDI").hide();
		$("btnDeleteDI").hide();
		/* end SR-5893 */
	}
	
	addStyleToInputs();
	initializeAll();

	$("btnAddDI").observe("click", addDI);
	$("btnDeleteDI").observe("click", deleteDI);
	//$("btnSaveDI").observe("click", saveDI);
	$("btnSaveDI").observe("click", function() {
		if(changeTag == 1) {
			saveDI();
		}  else {
			showMessageBox("No changes to save.", imgMessage.INFO);
		}
	});
	/* $("btnCancel").observe("click", function () {
		Modalbox.hide();
	});  */ // --robert - 07.08.2011
	
	function exitDI(){
		/* benjo 09.07.2016 SR-5604 */
		//Modalbox.hide();
		//marco - 07.09.2014
		/* defaultIntmOverlay.close();
		delete defaultIntmOverlay;
		changeTag = 0; */
		if(nvl($F("hidViewOnly"),"false") != "true"){ //benjo 03.07.2017 SR-5893
			new Ajax.Request(contextPath+"/GIISAssuredController", {
				method: "POST",
				parameters: {action: "checkDfltIntm",
					         assdNo: $F("assuredNo"),
					         moduleId: "GIISS006B"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText=="SUCCESS"){
							defaultIntmOverlay.close();
							delete defaultIntmOverlay;
							changeTag = 0;
						}else{
							showMessageBox(response.responseText, imgMessage.INFO);
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}else{
			defaultIntmOverlay.close();
			delete defaultIntmOverlay;
			changeTag = 0;
		}
		/* end SR-5604 */
	}; // ++robert - 07.08.2011
	
	function saveAndExitDI(){
		saveDI("Y");
	};// ++robert - 07.11.2011

	$("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExitDI, exitDI, "");
		}  else {
			//Modalbox.hide();
			exitDI();
		}
	}); // ++robert - 07.08.2011

	$$("div[name='intm']").each(function (row) {
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				$$("div[name='intm']").each(function (it)	{
						if (row.getAttribute("id") != it.getAttribute("id"))	{
						it.removeClassName("selectedRow");
					}
				});

				var line = $("lineCd");
				for (var i=0; i<line.length; i++)	{
					if (line.options[i].value == row.getAttribute("lineCd"))	{
						line.selectedIndex = i;
					}
				}
				
				/* benjo 09.07.2016 SR-5604 */
				/* var intm = $("intermediaryNo");
				for (var i=0; i<intm.length; i++)	{
					if (intm.options[i].value == row.getAttribute("intmNo"))	{
						intm.selectedIndex = i;
					}
				} */
				$("txtIntmNo").value = row.getAttribute("intmNo");
				$("txtIntmName").value = unescapeHTML2(row.getAttribute("intmName"));
				/* end SR-5604 */
				
				//$("intermediaryName").value = row.down("input", 2).value;
				disableButton("btnAddDI");
				//$("btnAddDI").value = "Update";
				/*$("btnDeleteDI").enable();
				$("btnDeleteDI").removeClassName("disabledButton");
				$("btnDeleteDI").addClassName("button");*/
				enableButton("btnDeleteDI");
				$("lineCd").disable();
				//$("intermediaryNo").disable(); //benjo 09.07.2016 SR-5604
				disableSearch("searchIntm"); //benjo 09.07.2016 SR-5604
			} else {
				$("lineCd").enable();
				//$("intermediaryNo").enable(); //benjo 09.07.2016 SR-5604
				enableSearch("searchIntm"); //benjo 09.07.2016 SR-5604
				resetDIForm();
			}
		});
	});
	
	function resetDIForm() {
		$("lineCd").selectedIndex = 0;
		//$("intermediaryNo").selectedIndex = 0;  //benjo 09.07.2016 SR-5604
		$("txtIntmNo").value = ""; //benjo 09.07.2016 SR-5604
		$("txtIntmName").value = ""; //benjo 09.07.2016 SR-5604
		//$("intermediaryName").value= "";
		//$("btnAddDI").value = "Add";
		enableButton("btnAddDI");
		disableButton("btnDeleteDI");
		/*$("btnDeleteDI").removeClassName("button");
		$("btnDeleteDI").addClassName("disabledButton");
		$("btnDeleteDI").disable();*/
		$$("div[name='intm']").each(function (it)	{
			it.removeClassName("selectedRow");
		});
	}
	
	function addDI() {
		var lineCd = unescapeHTML2($F("lineCd"));
		
		//benjo 09.07.2016 SR-5604
		//var intermediaryNo = $F("intermediaryNo");
		//var intermediaryName = escapeHTML2($("intermediaryNo").options[$("intermediaryNo").selectedIndex].text);
		var intermediaryNo = $F("txtIntmNo");
		var intermediaryName = unescapeHTML2($F("txtIntmName"));
		/* end SR-5604 */
		
		if (lineCd.blank() || intermediaryNo.blank() || intermediaryName.blank()) {
			customShowMessageBox("Required fields must be entered.", "I", (lineCd.blank() ? "lineCd" : "intermediaryNo"));
			return false;
		}

		var exists = false;
		$$("div[name='intm']").each( function(i)	{
			if (unescapeHTML2(i.getAttribute("id")) == "intm"+lineCd+intermediaryNo)	{
				showMessageBox("Record already exists!", imgMessage.ERROR);
				exists = true;
				return false;
			}
		});

		if (!exists) {
			/*if ($F("btnAddDI") == "Update") {
				 $("intm"+lineCd+intermediaryNo).update('<label style="width: 20%; text-align: center;">'+lineCd+'</label>'+								  
						 '<label style="width: 30%; text-align: left;">'+intermediaryNo+'</label>'+	
						 '<label style="width: 50%; text-align: left;" title="'+intermediaryName+'">'+intermediaryName.truncate(30, "...")+'</label>'+		
						 '<input type="hidden" name="lineCds" 			value="'+lineCd+'" />'+ 
						 '<input type="hidden" name="intmNo" 			value="'+intermediaryNo+'" />'+
						 '<input type="hidden" name="intermediaryName" 	value="'+intermediaryName+'" />'); 
			}*/
				var newDIDiv = new Element('div');
				newDIDiv.setAttribute("name", "intm");
				newDIDiv.setAttribute("id", "intm"+escapeHTML2(lineCd)+intermediaryNo);
				newDIDiv.setAttribute("lineCd", escapeHTML2(lineCd));
				newDIDiv.setAttribute("intmNo", intermediaryNo);
				newDIDiv.setAttribute("intmName", escapeHTML2(intermediaryName)); //benjo 09.07.2016 SR-5604
				newDIDiv.addClassName("tableRow");
				newDIDiv.setStyle("display: none;");
				newDIDiv.update('<label style="width: 20%; text-align: center;">'+lineCd+'</label>'+								  
						 '<label style="width: 30%; text-align: left;">'+intermediaryNo+'</label>'+	
						 '<label style="width: 50%; text-align: left;" title="'+intermediaryName+'">'+intermediaryName.truncate(30, "...")+'</label>'+		
						 '<input type="hidden" name="lineCds" 			value="'+escapeHTML2(lineCd)+'" />'+ 
						 '<input type="hidden" name="intmNo" 			value="'+intermediaryNo+'" />'+
						 '<input type="hidden" name="intermediaryName" 	value="'+intermediaryName+'" />');
				
				$('intermediaryListing').insert({bottom: newDIDiv});
				filterLineCd();
	
				newDIDiv.observe("mouseover", function ()	{
					newDIDiv.addClassName("lightblue");
				});
				
				newDIDiv.observe("mouseout", function ()	{
					newDIDiv.removeClassName("lightblue");
				});
	
				newDIDiv.observe("click", function ()	{
					newDIDiv.toggleClassName("selectedRow");
					if (newDIDiv.hasClassName("selectedRow"))	{
						$$("div[name='intm']").each(function (it)	{
								if (unescapeHTML2(newDIDiv.getAttribute("id")) != unescapeHTML2(it.getAttribute("id")))	{
								it.removeClassName("selectedRow");
							}
						});

						var line = $("lineCd");
						for (var i=0; i<line.length; i++)	{
							if (unescapeHTML2(line.options[i].value) == unescapeHTML2(newDIDiv.getAttribute("lineCd")))	{
								line.selectedIndex = i;
							}
						}

						/*var intm = $("intermediaryNo");
						for (var i=0; i<intm.length; i++)	{
							if (intm.options[i].value == newDIDiv.getAttribute("intmNo"))	{
								intm.selectedIndex = i;
							}
						}*/ //benjo 09.07.2016 SR-5604
						$("txtIntmNo").value = newDIDiv.getAttribute("intmNo"); //benjo 09.07.2016 SR-5604
						$("txtIntmName").value = unescapeHTML2(newDIDiv.getAttribute("intmName")); //benjo 09.07.2016 SR-5604

						//$("intermediaryName").value = newDIDiv.down("input", 2).value;
						disableButton("btnAddDI");
						//$("btnAddDI").value = "Update";
						/*$("btnDeleteDI").removeClassName("disabledButton");
						$("btnDeleteDI").addClassName("button");
						$("btnDeleteDI").enable();*/
						enableButton("btnDeleteDI");
					} else {
						resetDIForm();
					}
				});
	
				Effect.Appear(newDIDiv, {
					duration: .5,
					afterFinish: function ()	{
						checkTableIfEmpty("intm", "intermediaryListingHeader");
						checkIfToResizeTable("intermediaryListing", "intm");
					}
				});

			resetDIForm();
			changeTag = 1; //marco - 07.08.2014
		}
	}

	function deleteDI(){
		$$("div[name='intm']").each(function (intm)	{
			if (intm.hasClassName("selectedRow")){
				Effect.Fade(intm, {
					duration: .5,
					afterFinish: function ()	{
						intm.remove();
						resetDIForm();
						checkTableIfEmpty("intm", "intermediaryListingHeader");
						checkIfToResizeTable("intermediaryListing", "intm");
						filterLineCd();
					} 
				});
			}
		});
		$("lineCd").enable();
		//$("intermediaryNo").enable(); //benjo 09.07.2016 SR-5604
		enableSearch("searchIntm"); //benjo 09.07.2016 SR-5604
		changeTag = 1; //marco - 07.08.2014
	}
	
	function filterLineCd(){
		(($$("select#lineCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
		
		$$("div#intermediaryListing div[name='intm']").each(function(row){
				var lineCd = row.getAttribute("lineCd");
				(($$("select#lineCd option[value='" + lineCd.replace("'", "&#39") + "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
		});
		$("lineCd").options[0].show();
		$("lineCd").options[0].disabled = false;
	}

	//$("intermediaryNo").observe("change", function () {
	//	$("intermediaryName").value = $("intermediaryNo").options[$("intermediaryNo").selectedIndex].text;
	//});
	
	checkTableIfEmpty("intm", "intermediaryListingHeader");
	checkIfToResizeTable("intermediaryListing", "intm");
	filterLineCd();

	function saveDI(exitSw){ //marco - 07.09.2014 - added parameter
		new Ajax.Request(contextPath+"/GIISAssuredController?ajax=1&action=saveDI", {
			method: "POST",
			postBody: Form.serialize("intermediaryForm"),
			onCreate: function() {
				showNotice("Saving, please wait...");
			}, 
			onComplete: function (response)	{
				if (checkErrorOnResponse(response)) {
					hideNotice();
					if (response.responseText == "SUCCESS") {
						changeTag = 0 ; //irwin
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(nvl(exitSw, "N") == "Y"){
								exitDI();
							}
						}); //++ robert 7.8.2011
					}
				}
			}
		});
	}

	$$("label[name='intmName']").each(function (i) {
		i.update((i.innerHTML).truncate(30, "..."));
	});
	
	// ++robert - 07.11.2011
	changeTag = 0;
	initializeChangeTagBehavior(saveDI);
	initializeChangeAttribute();
	
	//benjo 09.07.2016 SR-5604
	$("searchIntm").observe("click", function(){
		LOV.show({ 
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISS006BIntmLOV",
							page : 1},
			title: "Intermediary",
			width: 500,
			height: 390,
			columnModel : [	{id: "intmNo",
							 title: "Intermediary No.",
							 align: 'right',
							 width: '100px'
							},
							{id: "intmName",
							 title: "Intermediary Name",
							 width: '385px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$("txtIntmNo").value = row.intmNo;
				$("txtIntmName").value = row.intmName;
				changeTag = 1;
			}
		  });
	});
	
</script>
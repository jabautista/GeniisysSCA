<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="redistributionMainDiv" name="redistributionMainDiv" style="margin-top : 1px;">
	<div id="redistributionMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="redistributionQuery">Query</a></li>
					<li><a id="redistributionExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="redistributionForm" name="redistributionForm">
		<jsp:include page="/pages/underwriting/distribution/redistribution/redistributionHeader.jsp"></jsp:include>
		<!-- used to load the GIUW_POL_DIST, GIUW_WPERILDS, GIUW_WPERILDS_DTL records -->
		<input type="button" id="btnLoadRecords" value="" style="display: none;"/>
		<div id="distGroupMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Group</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistGroup" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			<div id="distGroupMain" class="sectionDiv" style="border: 0px;">	
				<div id="distTableDiv" class="sectionDiv" style="display: block;">
					<div id="distListingTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 160px; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 280px; text-align: left; margin-right: 5px;">Distribution Status</label>
							<label style="width: 280px; text-align: left; ">Multi Booking Date</label>
						</div>
						<div id="distListing" name="distListing" class="tableContainer">
						</div>
					</div>	
				</div>
				<div id="distGroupListingDiv" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTable" style="width: 800px; margin:auto; margin-top:10px;">
						<div class="tableHeader">
							<label style="width: 100px; text-align: right; margin-right: 50px;">Group No.</label>							
							<label style="width: 650px; text-align: left;">Currency</label>
						</div>
						<div id="distGroupListing" name="distGroupListing" class="tableContainer">
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="distPerilMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Listing</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistPeril" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			
			<div id="distPerilMain" class="sectionDiv" style="border: 0px;">	
				<div id="distPerilTableDiv" class="sectionDiv" style="display: block;">
					<div id="distPerilTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 250px; text-align: center; margin-right: 5px;">Peril</label>
						<label style="width: 250px; text-align: center; margin-right: 10px;">Peril Sum Insured</label>
						<label style="width: 250px; text-align: center; margin-right: 10px;">Peril Premium</label>
						</div>
						<div id="distPerilListing" name="distPerilListing" class="tableContainer">
						</div>
					</div>	
				</div>
			</div>
		</div>
		
		<div id="distShareMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Share</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistShare" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>					
			<div id="distShareDiv" class="sectionDiv" style="display: block;">
				<div id="distShareTable" style="width:100%; padding-bottom:5px;">
					<div class="tableHeader" style="margin:10px; margin-bottom:0px;">
						<label style="width: 220px; text-align: left; margin-right: 5px; margin-left: 5px;">Share</label>
						<label style="width: 200px; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 210px; text-align: right; margin-right: 5px;">Sum Insured</label>
						<label style="width: 210px; text-align: right; margin-right: 5px;">Premium</label>
					</div>
					<div id="distShareListing" name="distShareListing" style="margin:10px; margin-top:0px;" class="tableContainer">
					</div>
				</div>
				<div id="distShareTotalAmtDiv" class="tableHeader"  style="margin-left:10px; margin-right: 10px; display: none;">
					<label style="text-align:left; width: 220px; margin-right: 5px; margin-left: 5px; float:left; margin-left: 5px;">Total:</label>
					<label id="totalDistSpct" style="text-align:right; width: 200px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistTsi" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistPrem" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCancel" name="btnCancel" class="button"	value="Cancel" />			
			<input type="button" id="btnRedistribute" name="btnRedistribute" class="button"	value="Redistribute" />			
		</div>
	</form>
</div>
<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	resizeTableBasedOnVisibleRows("distListingTable", "distListing");
	resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
	resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
	resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

	/** Variables **/
	
	objUW.hidObjGIUTS021 = {};
	objGIPIPolbasic = {};
	changeTag = 0;

	var selectedGiuwPolDist = null;
	var selectedGiuwPolDistGroup = null;
	var selectedGiuwPerilds = null;
	var selectedGiuwPerildsDtl = {};

	var distShareRecordStatus = "INSERT";

	// misc variables
	var prevRedistributionDate = ""; // used for checking if redistrution date has changes. if yes, validate
	var oldDistNo = null;			 // used for reloading the distribution after saving
	
	/** end of Variables **/
	
	/** Page Functions **/
	
	function assignAmtToObj(amt, objPre, objSca, index){
		try{
			objPre[index] = parseInt(nvl(amt[0], "0"));
			objSca[index] = (nvl(amt[1], "0")).replace(/^0/, "");			
		}catch(e){
			showErrorMessage("assignAmtToObj", e);
		}						
	}
	
	function addDeciNumObject(preciseObj, scaleObj, divisor){
		try{
			var addends1 = 0;
			var addends2 = 0;

			for(att in preciseObj){
				addends1 = addends1 + preciseObj[att];
				addends2 = parseInt(addends2) + parseInt(scaleObj[att]);				
			}		
			
			if(addends2 >= divisor){
				addends1 = addends1 + parseInt(addends2 / divisor);
				addends2 = addends2 % divisor;
			}
			
			return (addends1 + "." + formatNumberDigits(addends2.abs(), (divisor.length - 1)));
		}catch(e){
			showErrorMessage("addDeciNumObject", e);
		}
		
	}
	
	/* compute dist share total values */
	function computeDistShareFieldsTotalValues(id1){
		try{
			if (id1 == null) {
				$("totalDistSpct").innerHTML = formatToNthDecimal(0, 14);
				$("totalDistTsi").innerHTML = formatCurrency(0);
				$("totalDistPrem").innerHTML = formatCurrency(0);
				return true;
			}
			
			var amount;
			var objPreDistSpct 	= new Object();
			var objScaDistSpct 	= new Object();
			var objPreDistTsi	= new Object();
			var objScaDistTsi	= new Object();
			var objPreDistPrem	= new Object();
			var objScaDistPrem	= new Object();
			var count = 0;			
			
			$$("div#distShareListing div[id1=" + id1 + "]").each(function(row){				
				amount = ((row.down("label", 1)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistSpct, objScaDistSpct, count);
				
				amount = ((row.down("label", 2)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistTsi, objScaDistTsi, count);
				
				amount = ((row.down("label", 3)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistPrem, objScaDistPrem, count);
				
				count++;
			});
			
			$("totalDistSpct").innerHTML = formatToNthDecimal(addDeciNumObject(objPreDistSpct, objScaDistSpct, 100000000000000), 14);
			$("totalDistTsi").innerHTML = formatCurrency(addDeciNumObject(objPreDistTsi, objScaDistTsi, 100));
			$("totalDistPrem").innerHTML = formatCurrency(addDeciNumObject(objPreDistPrem, objScaDistPrem, 100));
		}catch(e){
			showErrorMessage("computeDistShareFieldsTotalValues", e);
		}
	}
	
	/* 
	* generate row content for distribution
	* accepts a GIUW_POL_DIST object as parameter
	*/
	function prepareDistRowContent(obj) {
		try{
			var multiBookingDate = nvl(getMultiBookingDateByPolicy(objGIPIPolbasic.policyId, objGIPIPolbasic.distNo), "-");

			var content = 
				'<label style="width: 160px; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
				'<label style="width: 280px; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+' - '+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
				'<label style="width: 280px; text-align: left; ">'+multiBookingDate+'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistRowContent", e);
		}
	}

	/* 
	* generate row content for distribution group
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistGroupRowContent(obj){
		try{
			var groupNo 	= obj == null ? "" : obj.distSeqNo;
			var currency 	= obj == null ? "" : nvl(obj.currencyDesc, "-");
			
			var content = 
				'<label style="width: 100px; text-align: right; margin-right: 50px;">'+ groupNo.toPaddedString(2) +'</label>' +				
				'<label style="width: 600px; text-align: left;">'+ currency +'</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistGroupRowContent", e);
		}
	}

	/* 
	* generate row content for distribution peril
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistPerilRowContent(obj){
		try{			
			var perilName 	= obj == null ? "" : obj.perilName; 
			var perilTsi 	= obj == null ? "" : obj.tsiAmt == null ? "" : formatCurrency(obj.tsiAmt);
			var perilPrem 	= obj == null ? "" : obj.premAmt == null ? "" : formatCurrency(obj.premAmt);
				
			var content =				
				'<label style="width: 250px; text-align: left; margin-right: 5px; ">'+ perilName +'</label>' +
				'<label style="width: 250px; text-align: right; margin-right: 10px;">'+ perilTsi +'</label>' +
				'<label style="width: 250px; text-align: right; margin-right: 10px;">'+ perilPrem +'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistPerilRowContent", e);
		}
	}

	/* 
	* generate row content for dist share
	* accepts a GIUW_WPERILDS_DTL object as parameter
	*/
	function prepareDistShareRowContent(obj){
		try{			
			var treatyName 		= obj == null ? "" : obj.trtyName; 
			var percentShare	= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 14);
			var sumInsured		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			var premium			= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);

			var content =				
				'<label style="width: 220px; text-align: left; margin-right: 5px; margin-left: 5px;">' + treatyName + '</label>' +
				'<label style="width: 200px; text-align: right; margin-right: 5px;">' + percentShare + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + sumInsured + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + premium + '</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistShareRowContent", e);
		}
	}
	
	/* checks item info additional for share dist, with three attributes to compare */
	function checkTableItemInfoAdditional(tableName,tableRow,rowName,attr,pkValue,attr2,pkValue2,attr3,pkValue3){
		var exist = 0;
		$$("div#"+tableName+" div[name='"+rowName+"']").each(function (div) {
			div.removeClassName("selectedRow");
			if (div.getAttribute(attr) == pkValue && div.getAttribute(attr2) == pkValue2 && div.getAttribute(attr3) == pkValue3){
				exist = exist + 1;
				div.show();
			}else{
				div.hide();
			}
		});
		if (exist > 5) {
			$(tableName).setStyle("height: 186px;");
			$(tableName).down("div",0).setStyle("padding-right:17px");
	     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
	    } else if (exist == 0) {
	     	$(tableRow).setStyle("height: 31px;");
	     	$(tableName).down("div",0).setStyle("padding-right:0px");
	    } else {
	    	var tableHeight = (exist*31)+31;
	    	if(tableHeight == 0){
	    		tableHeight = 31;
	    	}

	    	// removed, because the div for the sum is being removed by this part (emman 06.07.2011)
	    	$(tableRow).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).down("div",0).setStyle("padding-right:0px");
		}

		if (exist == 0){
			Effect.Fade(tableName, {
				duration: .001
			});
		} else {
			Effect.Appear(tableName, {
				duration: .001
			});
		}
	}

	function saveRedistribution() {
		// for saving
		negateDistribution("Y");
		return true;
		new Ajax.Request(contextPath + "/GIUWPolDistController?action=saveRedistribution", {
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				policyId: objGIPIPolbasic.policyId,
				distNo: (oldDistNo == null) ? 0 : oldDistNo
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var param = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					
					objGIPIPolbasic = param.polBasic;
					objGIPIPolbasic.sveFacultativeCode = null;
					populateRedistributionPolicyInfoFields(objGIPIPolbasic);
					
					//loadRedistribution();
					objUW.hidObjGIUTS021 = {};
					objUW.hidObjGIUTS021.GIUWPolDist = param.polDistList;
					fireEvent($("btnLoadRecords"), "click");

					changeTag = 0;

					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	/* creates dist share row */
	function createDistShareRow(obj) {
		try{
			// create and add content div
			var content = prepareDistShareRowContent(obj);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowDistShare" + obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd + "_" + obj.shareCd);
			newDiv.setAttribute("id1", obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd);
			newDiv.setAttribute("name", "rowDistShare");
			newDiv.setAttribute("distNo", obj.distNo);
			newDiv.setAttribute("groupNo", obj.distSeqNo);
			newDiv.setAttribute("perilCd", obj.perilCd);
			newDiv.setAttribute("shareCd", obj.shareCd);
			newDiv.setAttribute("lineCd", obj.lineCd);
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display : none;");
			
			newDiv.update(content);

			$("distShareListing").insert({bottom : newDiv});

			// add observer
			loadRowMouseOverMouseOutObserver(newDiv);
			
			newDiv.observe("click",
					function() {
						newDiv.toggleClassName("selectedRow");
		
						if (newDiv.hasClassName("selectedRow")) {
							// remove classname of other rows							
							($$("div#distShareListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");
		
							// set selected pol dist share object
							selectedGiuwPerildsDtl = obj;
		
							distShareRecordStatus = "QUERY";
						} else {
							selectedGiuwPerildsDtl = {};
		
							distShareRecordStatus = "INSERT";
						}
					});
		}catch(e){
			showErrorMessage("createDistShareRow", e);
		}
	}

	/* creates peril row */
	function createDistPerilRow(obj) {
		try{
			// create and add content div
			var content = prepareDistPerilRowContent(obj);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowDistPeril" + obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd);
			newDiv.setAttribute("name", "rowDistPeril");
			newDiv.setAttribute("distNo", obj.distNo);
			newDiv.setAttribute("groupNo", obj.distSeqNo);
			newDiv.setAttribute("perilCd", obj.perilCd);
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display : none;");

			newDiv.update(content);

			$("distPerilListing").insert({bottom : newDiv});

			// create dist share rows
			for (var i = 0; i < obj.giuwPerildsDtl.length; i++) {
				createDistShareRow(obj.giuwPerildsDtl[i]);
			}

			// add observer
			loadRowMouseOverMouseOutObserver(newDiv);
			
			newDiv.observe("click",
					function() {
						newDiv.toggleClassName("selectedRow");

						if (newDiv.hasClassName("selectedRow")) {
							var id1 = obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd;	
							// remove classname of other rows							
							($$("div#distPerilListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

							// deselect highlighted rows
							unClickRow("distShareTable");

							// show groups with similar distNo
							($("distShareListing").childElements()).invoke("hide"); //distGroupListingTable
							($$("div#distShareListing div[id1='" + id1 + "']")).invoke("show");

							// set selected peril object
							selectedGiuwPerilds = obj;

							// show tables
							resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

							// show total amount div
							$("distShareTotalAmtDiv").show();
						} else {
							selectedGiuwPerilds = null;

							// deselect highlighted rows
							unClickRow("distShareTable");

							// hide all rows in peril & show rows related to the selected group
							($("distShareListing").childElements()).invoke("hide");
							$("distShareTable").hide();


							// hide total amount div
							$("distShareTotalAmtDiv").hide();
						}

						computeDistShareFieldsTotalValues(id1);
					});
		}catch(e){
			showErrorMessage("createDistPerilRow", e);
		}
	}

	/* creates dist group row */
	function createDistGroupRow(obj) {
		try{
			if($("rowDistGroup" + obj.distNo + "_" + obj.distSeqNo) == undefined){
				// create and add content div
				var content = prepareDistGroupRowContent(obj);
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowDistGroup" + obj.distNo + "_" + obj.distSeqNo);
				newDiv.setAttribute("name", "rowDistGroup");
				newDiv.setAttribute("distNo", obj.distNo);
				newDiv.setAttribute("groupNo", obj.distSeqNo);
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display : none;");

				newDiv.update(content);

				$("distGroupListing").insert({bottom : newDiv});

				// add observer
				loadRowMouseOverMouseOutObserver(newDiv);
				
				newDiv.observe("click",
						function() {
							newDiv.toggleClassName("selectedRow");

							if (newDiv.hasClassName("selectedRow")) {
								// remove classname of other rows							
								($$("div#distGroupListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

								// deselect highlighted rows
								unClickRow("distPerilTable");
								unClickRow("distShareTable");

								// show groups with similar distNo						
								($("distPerilListing").childElements()).invoke("hide"); //distGroupListingTable
								($$("div#distPerilListing div[groupNo='"+ newDiv.readAttribute("groupNo") +"']")).invoke("show"); //edited by steven 08.12.2014

								// hide all sub-rows
								($("distShareListing").childElements()).invoke("hide");
								$("distShareTable").hide();

								// set selected pol dist group object
								selectedGiuwPolDistGroup = obj;

								// show tables
								resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");

							} else {
								selectedGiuwPolDistGroup = null;

								// deselect highlighted rows
								unClickRow("distPerilTable");
								unClickRow("distShareTable");

								// hide all rows in peril & show rows related to the selected group
								($("distPerilListing").childElements()).invoke("hide");
								($("distShareListing").childElements()).invoke("hide");
								$("distPerilTable").hide();
								$("distShareTable").hide();
							}
						});
			}	
		}catch(e){
			showErrorMessage("createDistGroupRow", e);
		}
	}

	/* creates dist row */
	function createDistRow(pGiuwPolDist) {
		// create and add content div
		var content = prepareDistRowContent(pGiuwPolDist);
		var newDiv = new Element("div");

		newDiv.setAttribute("id", "rowDist" + pGiuwPolDist.parId + "_" + pGiuwPolDist.distNo);
		newDiv.setAttribute("name", "rowDist");
		newDiv.setAttribute("parId", pGiuwPolDist.parId);
		newDiv.setAttribute("distNo", pGiuwPolDist.distNo);
		newDiv.addClassName("tableRow");
		
		newDiv.update(content);

		$("distListing").insert({bottom : newDiv});

		// create dist group rows and peril rows
		for (var i = 0; i < pGiuwPolDist.giuwPerilds.length; i++) {
			createDistGroupRow(pGiuwPolDist.giuwPerilds[i]);
			createDistPerilRow(pGiuwPolDist.giuwPerilds[i]);
		}

		// add observer
		loadRowMouseOverMouseOutObserver(newDiv);
		
		newDiv.observe("click",
			function() {
				newDiv.toggleClassName("selectedRow");

				if (newDiv.hasClassName("selectedRow")) {
					// remove classname of other rows							
					($$("div#distListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

					// deselect highlighted rows
					unClickRow("distGroupListingTable");
					unClickRow("distPerilTable");
					unClickRow("distShareTable");

					// show groups with similar distNo						
					($("distGroupListing").childElements()).invoke("hide"); //distGroupListingTable
					($$("div#distGroupListing div[distNo='"+ newDiv.readAttribute("distNo") +"']")).invoke("show");

					// hide all rows in peril & show rows related to the selected group
					($("distPerilListing").childElements()).invoke("hide");
					($("distShareListing").childElements()).invoke("hide");
					$("distPerilTable").hide();
					$("distShareTable").hide();

					// set selected pol dist object
					selectedGiuwPolDist = pGiuwPolDist;

					// show tables
					resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
				} else {
					selectedGiuwPolDist = null;

					// deselect highlighted rows
					unClickRow("distGroupListingTable");
					unClickRow("distPerilTable");
					unClickRow("distShareTable");

					// hide all rows in peril & show rows related to the selected group
					($("distGroupListing").childElements()).invoke("hide");
					($("distPerilListing").childElements()).invoke("hide");
					($("distShareListing").childElements()).invoke("hide");
					$("distGroupListingTable").hide();
					$("distPerilTable").hide();
					$("distShareTable").hide();
				}
			});
		
		resizeTableBasedOnVisibleRows("distListingTable", "distListing");
	}
	
	/** end of Page Functions **/
	
	/** Form triggers, functions, and procedures **/
	
	/*+ PROCEDURES +*/
	
	// check_reinsurance_payment
	function checkReinsurancePaymentForRedistribution() {
		var ok = true;
		new Ajax.Request(contextPath + "/GIPIPolbasicController?action=checkReinsurancePaymentForRedistribution", {
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				policyId : (nvl(objGIPIPolbasic, null == null) ? null : objGIPIPolbasic.policyId),
				lineCd: (nvl(objGIPIPolbasic, null == null) ? null : objGIPIPolbasic.lineCd)
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var res = response.responseText;

					if (res == "HAS_COLLECTIONS") {
						showMessageBox("This policy has collections from FACUL Reinsurers", imgMessage.INFO);
					} else if (res == "") {
						ok = false;
						showMessageBox("This policy has collections from FACUL Reinsurers, Cannot redistribute policy/endorsement", imgMessage.INFO);
					}
				} else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return ok;
	}

	// negate_ditribution
	function negateDistribution(forSaving) {
		var tempDistNo = objGIPIPolbasic.distNo;
		new Ajax.Request(contextPath + "/GIUWPolDistController?action=negateDistributionGiuts021", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId: objGIPIPolbasic.policyId,
				distNo: objGIPIPolbasic.distNo,
				tempDistNo: objGIPIPolbasic.tempDistNo,
				negDistNo: objGIPIPolbasic.negDistNo,
				renewFlag: objGIPIPolbasic.renewFlag,
				redistributionDate: $F("txtRedistributionDate"),
				expiryDate: $F("txtExpiryDate"),
				effDate: $F("txtEffDate"),
				lineCd: objGIPIPolbasic.lineCd,
				sublineCd: objGIPIPolbasic.sublineCd,
				forSaving: nvl(forSaving, "Y")
			},
			onCreate: function (){
				showNotice("Negating distribution. Please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {//added checkCustomErrorOnResponse edgar 09/26/2014
					var param = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					var tempRedistributionDate = $F("txtRedistributionDate");
					hideNotice("");

					if (param.msgAlert == "SUCCESS") {
						if (nvl(forSaving, "N") == "Y") {
							objGIPIPolbasic = param.polBasic;
							objGIPIPolbasic.sveFacultativeCode = null;
							objGIPIPolbasic.distNo = param.distNo;
							objGIPIPolbasic.negDistNo = param.negDistNo;
							objGIPIPolbasic.tempDistNo = param.tempDistNo;
						}
						populateRedistributionPolicyInfoFields(objGIPIPolbasic);
						
						//loadRedistribution();
						objUW.hidObjGIUTS021 = {};
						objUW.hidObjGIUTS021.GIUWPolDist = param.polDistList;
						fireEvent($("btnLoadRecords"), "click");

						/* if (nvl(forSaving, "N") == "Y") {
							changeTag = 0;
							disableButton("btnSave");
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						} else {
							changeTag = 1;
							$("txtRedistributionDate").value = tempRedistributionDate;
							showMessageBox("Policy successfully redistributed!  The new Distribution No. for unearned portion is " + formatNumberDigits(param.tempDistNo, 9) + ". " +
									"Click the Save button to apply changes.", imgMessage.INFO);
						} */
						$("hrefCollnDate").style.display = "none";
						$("redistDateDiv").removeClassName("required");
						$("txtRedistributionDate").removeClassName("required");
						disableButton("btnRedistribute");
						
						changeTag = 0;
						$("txtRedistributionDate").value = tempRedistributionDate;
						showMessageBox("Policy successfully redistributed!  The new Distribution No. for unearned portion is " + formatNumberDigits(param.tempDistNo, 9) + ". ",
								imgMessage.INFO);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			}
		});
	}
	
	// executes NBT_RDATE (redistribution date) pre-text trigger
	function executeNbtRDatePreTextTrigger() {
		if (nvl(objGIPIPolbasic.tempDistNo, null) == null) {
			$("hrefCollnDate").style.display = "inline";
			$("redistDateDiv").addClassName("required");
			$("txtRedistributionDate").addClassName("required");
			enableButton("btnRedistribute");
			
		} else {
			$("hrefCollnDate").style.display = "none";
			$("redistDateDiv").removeClassName("required");
			$("txtRedistributionDate").removeClassName("required");
			disableButton("btnRedistribute");
		}
	}

	//added function for checking existing claims edgar 09/22/2014 from GIUTS002
	function checkExistingClaimGiuts002(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController", {
				method: "POST",
				parameters: {action     	: "checkExistingClaimGiuts002",
										lineCd			:  objGIPIPolbasic.lineCd,
	                    				sublineCd		:  objGIPIPolbasic.sublineCd,
	                   				 	issCd         		:  objGIPIPolbasic.issCd,
	                    				issueYy      	:  objGIPIPolbasic.issueYy,
	                    				polSeqNo   	:  objGIPIPolbasic.polSeqNo,
	                    				renewNo    	:  objGIPIPolbasic.renewNo,
	                    				effDate      	:  dateFormat(Date.parse($F("txtEffDate")), "MM-dd-yyyy"),
	                    				endtSeqNo 	:  objGIPIPolbasic.endtSeqNo},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == ""){
							validateFaculPremPaytGIUTS021();
						}else {
							var message = "";
						    if(response.responseText.contains("Restrict")){
						    	showMessageBox("This policy has an existing claim(s), redistribution is not allowed.", imgMessage.ERROR);
						    } else if(response.responseText.contains("Override")){
						    	if(response.responseText.contains("W Endorsement")){
						    		message = "The policy for this endt. has an existing claim(s), please inform the Claims Department before redistributing this distribution. Do you want to continue?";
						    	} else {
						    		message = "This policy has an existing claim(s), please inform the Claims Department before redistributing this distribution. Do you want to continue?";
						    	}
						    	
						    	showConfirmBox("Confirmation", message, "Yes", "No", 
						    						function(){
						    								   askForOverride("claims","RB");
						    								  },"");
						    } else {
						    	validateFaculPremPaytGIUTS021();
						    }
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
		}catch(e){
			showErrorMessage("checkExistingClaimGiuts002", e);
		}	
	}
	
	function askForOverride(fromValidation, funcCode){ //added by edgar 09/22/2014 base on codes fo Sir Joms in Negation of Distribution
		if (giacValidateUserFn(funcCode) == "FALSE") {
			var message = "";
			
			if(fromValidation == "claims"){
				message = "Cannot redistibute distribution of policy with claim(s).";	
			} else {
				message = "Cannot redistribute distribution of policy with FACULTATIVE PREMIUM PAYMENT(s).";
			}
			
			showConfirmBox("Confirmation", message + 
					" Would you like to override?","Yes","No", 
			   function(){
				override(funcCode, i, fromValidation);
			}, function(){
				return false;
			});
			
		} else {
			if(fromValidation == "claims"){
				validateFaculPremPaytGIUTS021();	
			} else{
				negateDistribution("Y");
			}
		}
	}
	
	function giacValidateUserFn(funcCode){ //added by edgar 09/22/2014 base on codes fo Sir Joms in Negation of Distribution
		try{
			var isOk;
			new Ajax.Request(contextPath+"/SpoilageReinstatementController", {
				method: "POST",
				parameters: {action : "validateUserFunc",
					funcCode: funcCode,
					moduleName: "GIUTS021"},
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						isOk = response.responseText;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
			return isOk;
		}catch(e){
			showErrorMessage("giacValidateUserFn", e);
		}
	}
	
	function override(funcCd,y,fromValidation){ //added by edgar 09/22/2014 base on codes fo Sir Joms in Negation of Distribution
		showGenericOverride(
				"GIUTS021",
				funcCd,
				function(ovr, userId, result){
					if(result == "FALSE"){
						showWaitingMessageBox("User " + userId + " is not allowed to process override.", imgMessage.ERROR, 
								function(){
									override(funcCd, i);
								}
						); 
					}else {
						if(result == "TRUE"){
							if(fromValidation == "claims"){
								validateFaculPremPaytGIUTS021();	
							}else {
								negateDistribution("Y");
							}
						}
						ovr.close();
						delete ovr;
					}
				},
				""
		);
	}
	
	function validateFaculPremPaytGIUTS021(){ //added by edgar 09/22/2014 base on codes fo Sir Joms in Negation of Distribution
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController", {
				method: "POST",
				parameters: {
					action : "validateFaculPremPaytGIUTS002",
					distNo : objGIPIPolbasic.negDistNo,
               	    distSeqNo : selectedGiuwPolDistGroup.distSeqNo,
               	    lineCd : objGIPIPolbasic.lineCd,
               	    endtSeqNo : objGIPIPolbasic.endtSeqNo
				},
			    onComplete: function(response){
			    	if(checkErrorOnResponse(response)){
			    		if(response.responseText == ""){
			    			negateDistribution("Y");
			    		} else {
			    			var message = "";
						    if(response.responseText.contains("Restrict")){
						    	showMessageBox("This policy has an existing FACULTATIVE PREMIUM  PAYMENT(s), redistribution is not allowed.", imgMessage.ERROR);
						    } else if(response.responseText.contains("Override")){
						    	if(response.responseText.contains("W Endorsement")){
						    		message = "The policy for this endt. has an existing FACULTATIVE PREMIUM PAYMENT(s), please inform the ACCOUNTING/FINANCE Department before redistributing this distribution. Do you want to continue?";
						    	} else {
						    		message = "This policy has an existing FACULTATIVE PREMIUM PAYMENT(s), please inform the ACCOUNTING/FINANCE Department before redistributing this distribution. Do you want to continue?";
						    	}
						    	
						    	showConfirmBox("Confirmation", message, "Yes", "No", 
						    					function(){
						    								askForOverride("payment","RF");
						    							  },"");
						    } else {
						    	negateDistribution("Y");
						    }
			    		}
			    	} else {
			    		showMessageBox(response.responseText, imgMessage.ERROR);
			    	}
			    }
			});
		}catch(e){
			showErrorMessage("validateFaculPremPaytGIUTS002",e);
		}
	}
	
	//added edgar 09/26/2014 to validate the takeup_term of policy, will restrict if it is long term
	function validateTakeupGiuts021(){
		var validated = true;
		new Ajax.Request(contextPath + "/GIUWPolDistController?action=validateTakeupGiuts021", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId: objGIPIPolbasic.policyId
			},
			onCreate: function (){
				showNotice("Checking Takeup Term. Please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					hideNotice("");
					validated = true;
					checkExistingClaimGiuts002();
				} else {
					$("txtRedistributionDate").value = "";
					prevRedistributionDate = "";
					validated = false;
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			}
		});
		return validated;
	}
	
	// execute NBT_RDATE (redistribution date) when-validate-item trigger
	function validateNbtRDate() {
		try {
			var ok = true;
			if(checkAllRequiredFieldsInDiv("policyInformation")){ // andrew - 09.14.2012 - added validation for required fields			
				if (!$F("txtRedistributionDate").blank() && nvl(objGIPIPolbasic.tempDistNo, null) == null) {
					if (checkReinsurancePaymentForRedistribution()) {
						var rDate = Date.parse($F("txtRedistributionDate"));
						var expiryDate = Date.parse($F("txtExpiryDate"));
						var effDate = Date.parse($F("txtEffDate"));
		
						if (compareDatesIgnoreTime(expiryDate, rDate) > 0) {
							$("txtRedistributionDate").value = prevRedistributionDate;
							showMessageBox("Redistribution Date should not be later than the Expiry date.", imgMessage.INFO);
							return false;
						} else if (compareDatesIgnoreTime(effDate, rDate) < 0) {
							$("txtRedistributionDate").value = prevRedistributionDate;
							showMessageBox("Redistribution Date should not be earlier than the Effectivity date.", imgMessage.INFO);
							return false;
						}else if (compareDatesIgnoreTime(effDate, rDate) == 0) {//added edgar 10/15/2014
							$("txtRedistributionDate").value = prevRedistributionDate;
							showMessageBox("Redistribution date should be later than the Effectivity Date.", imgMessage.INFO);
							return false;
						}else if (compareDatesIgnoreTime(expiryDate, rDate) == 0) {
							$("txtRedistributionDate").value = prevRedistributionDate;
							showMessageBox("Redistribution Date should be earlier than the Expiry date.", imgMessage.INFO);
							return false;
						}//ended edgar 10/15/2014
		
						showConfirmBox("Confirm Negation", 
											"Are you sure you want to redistribute the distribution record of Policy Number " +
											objGIPIPolbasic.policyNo + " (Distribution No. " + formatNumberDigits(nvl(objGIPIPolbasic.negDistNo, 0)) + ") ?",
											"OK", "Cancel",
											function() {
												showConfirmBox("Confirm Redistribution", 
														"This will create two(2) new distribution records for Policy Number " +
														objGIPIPolbasic.policyNo + ".",
														"OK", "Cancel",
														function() {
															//negateDistribution("Y"); //commented edgar 09/22/2014
															validateTakeupGiuts021(); //edgar 09/22/2014
														},
														function() {
															$("txtRedistributionDate").value = "";
															prevRedistributionDate = "";
															ok = false;
														});
											},
											function() {
												$("txtRedistributionDate").value = "";
												prevRedistributionDate = "";
												ok = false;
											});
					}
				}			
			}
			return ok;
		} catch(e){
			showErrorMessage("validateNbtRDate", e);
		}
	}
	
	function showGIUTS021PolbasicLOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIUTS021PolicyListing",
							lineCd : $F("txtPolLineCd"),
							sublineCd : $F("txtPolSublineCd"),
							issCd : $F("txtPolIssCd"),
							issueYy : $F("txtPolIssueYy"),
							polSeqNo : $F("txtPolPolSeqNo"),
							renewNo : $F("txtPolRenewNo"),
  			                page : 1},
			title: "Policy Listing",
			width: 910,
			height: 400,
			hideColumnChildTitle: true,
			filterVersion: "2",
			columnModel: [
							{	id: 'lineCd',
								title: 'Line Code',
								width: '0',
// 								filterOption: true, //remove by steven steven 1/21/2013 base on SR 0011247 
								visible: false
							},
							{	id: 'sublineCd',
								title: 'Subline Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issCd',
								title: 'Issue Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issueYy',
								width: '0',
								title: 'Issue Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'polSeqNo',
								width: '0',
								title: 'Pol. Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'renewNo',
								width: '0',
								title: 'Renew No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtIssCd',
								width: '0',
								title: 'Endt Iss Code',
								visible: false,
								filterOption: true
							},
							{	id: 'endtYy',
								width: '0',
								title: 'Endt. Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtSeqNo',
								width: '0',
								title: 'Endt Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{ 	id: 'policyNo',
								title : 'Policy No.',
								width : '180px'
							},
							{ 	id: 'endtNo',
								title : 'Endt. No.',
								width : '180px'
							},
							{	id: 'assdName',
								title: 'Assured Name',
								width: '280px',
								filterOption: true
							},
							{	id: 'effDate',
								title: 'Eff. Date',
								width: '114px',
								type: 'date',
								filterOptionType: 'formattedDate',
								align: 'center',
								titleAlign: 'center',
								format: 'mm-dd-yyyy',
								filterOption: true
							},
							{	id: 'expiryDate',
								title: 'Expiry Date',
								width: '114px',
								type: 'date',
								filterOptionType: 'formattedDate',
								align: 'center',
								titleAlign: 'center',
								format: 'mm-dd-yyyy',
								filterOption: true
							}
						],
						draggable: true,
				  		onSelect: function(row){
							 if(row != undefined) {
									objGIPIPolbasic = row;
									objGIPIPolbasic.sveFacultativeCode = null;
									objGIPIPolbasic.negDistNo = null;
									objGIPIPolbasic.tempDistNo = null;
									populateRedistributionPolicyInfoFields(objGIPIPolbasic);
									
									loadRedistribution();
							 }
				  		}
					});
	} 
//added edgar 11/21/2014 : for validation of already redistributed records
	function loadRedistribution2(){
		new Ajax.Request(contextPath + "/GIPIPolbasicController?action=executeGIUWS012V370PostQuery", {
			method: "GET",
			parameters: {
				policyId: objGIPIPolbasic.policyId
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					var obj = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
					objGIPIPolbasic.sveFacultativeCode = obj.sveFacultativeCode;
					
					if (obj.distStatus == "OK") {
						validateNbtRDate();
					} else if (obj.distStatus == "REDIST") {
						showMessageBox("Policies already redistributed cannot be process for redistribution.", imgMessage.INFO);
						
						$("hrefCollnDate").style.display = "none";
						$("redistDateDiv").removeClassName("required");
						$("txtRedistributionDate").removeClassName("required");
						disableButton("btnRedistribute");
						
					} else if (obj.distStatus == "NO_DIST") {
						showMessageBox("This policy has no valid distribution no."+
								       " Please check the policy pol flag or the policy distribution status."+
								       " Undistributed or spoiled policies cannot be processed for redistribution.", imgMessage.INFO);

						$("hrefCollnDate").style.display = "none";
						$("redistDateDiv").removeClassName("required");
						$("txtRedistributionDate").removeClassName("required");
						disableButton("btnRedistribute");

					} else {
						objUW.hidObjGIUTS021 = {};
						objUW.hidObjGIUTS021.GIUWPolDist = {};
						fireEvent($("btnLoadRecords"), "click");
					}
				}
			}
		});
	}
	/** end of Form triggers, functions, and procedures **/

	/** Field events **/
	
	/*+ Menu +*/
	
	$("redistributionExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});
	
	/*+ Main Fields +*/
	
	$("btnCancel").observe("click", function() {
		checkChangeTagBeforeUWMain();
	});

	/*+ V370 Block - GIPI_POLBASIC +*/
	
	$("hrefPolicyNo").observe("click", function() {
		/* if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveRedistribution, 
			function(){
				showPolicyListingForRedistribution();
			},"");
		} else {
			showPolicyListingForRedistribution();
		} */
		//showPolicyListingForRedistribution();
		showGIUTS021PolbasicLOV(); // andrew - 12.5.2012
	});

	$("btnLoadRecords").observe("click", function() {
		// remove all previous records first
		($("distListing").childElements()).each(function(row) {
			row.remove();
		});

		($("distGroupListing").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distPerilListing").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distShareListing").childElements()).each(function(row) {
			row.remove();
		});

		resizeTableBasedOnVisibleRows("distListingTable", "distListing");
		resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
		resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
		resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

		// reset variables
		prevRedistributionDate = "";
		oldDistNo = null;
		//resetVariables();

		// create new rows
		for (var i = 0; i < objUW.hidObjGIUTS021.GIUWPolDist.length; i++) {
			createDistRow(objUW.hidObjGIUTS021.GIUWPolDist[i]);
		}

		// clear form
		//clearForm();

		// reset change tag
		changeTag = 0;

		// hide total amount div
		$("distShareTotalAmtDiv").hide();

		// automatically select first GIUW_POL_DIST record
		if (objUW.hidObjGIUTS021.GIUWPolDist.length > 0) {
			// dist row
			var pGiuwPolDist = objUW.hidObjGIUTS021.GIUWPolDist[0];
			fireEvent($("rowDist" + pGiuwPolDist.parId + "_" + pGiuwPolDist.distNo), "click");
			if (pGiuwPolDist.giuwPerilds.length > 0) {
				var pGiuwPerilds = pGiuwPolDist.giuwPerilds[0];

				// dist group row
				fireEvent($("rowDistGroup" + pGiuwPerilds.distNo + "_" + pGiuwPerilds.distSeqNo), "click");

				// dist peril row
				fireEvent($("rowDistPeril" + pGiuwPerilds.distNo + "_" + pGiuwPerilds.distSeqNo + "_" + pGiuwPerilds.perilCd), "click");
			}
		}

		// execute NBT_RDATE (redistribution date) pre-text trigger
		executeNbtRDatePreTextTrigger();

		//enableButton("btnSave");
		//$("hrefCollnDate").style.display = "inline";
	});

	$("txtRedistributionDate").observe("focus", function() {
		changeTag = 1;
		/* if (!$F("txtRedistributionDate").blank() && prevRedistributionDate != $F("txtRedistributionDate")) {
			// execute NBT_RDATE (redistribution date) when-validate-item trigger
			if (validateNbtRDate()) {
				prevRedistributionDate = $F("txtRedistributionDate");
			}
		} */
	});

	/** end of Field events **/
	
	//initializeChangeTagBehavior(saveRedistribution);
	initializeChangeTagBehavior(validateNbtRDate); // andrew - 09.14.2012
	window.scrollTo(0,0);
	hideNotice("");
	observeReloadForm("reloadForm", showRedistribution);
	observeReloadForm("redistributionQuery", showRedistribution); // andrew - 12.5.2012
	//observeSaveForm("btnRedistribute", saveRedistribution);
	//observeSaveForm("btnRedistribute", validateNbtRDate);
	//window.onbeforeunload = endRedistributionTransaction;
	$("btnRedistribute").observe("click", loadRedistribution2/*validateNbtRDate*/); // andrew - 09.14.2012 //changed to loadRedistribution2 for validation of redistributed data : edgar 11/21/2014
	
	disableButton("btnRedistribute");
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="reverseBinderMainDiv" name="reverseBinderMainDiv" style="margin-top: 1px;">
	<div id="reverseBinderMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="reverseBinderQuery">Query</a></li>
					<li><a id="reverseBinderExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="reverseBinderForm" name="reverseBinderForm">
		<div id="frpsInfoMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>FRPS Information</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="frpsDetailsDiv">
				
				<table align="center">
					<tr>
						<td class="rightAligned" width="100px">FRPS No.</td>
						<td class="leftAligned" colspan="2" width="210px">
							<input id="riLineCd"   class="leftAligned  upper required" type="text" name="riLineCd"  style="width: 8%;"  value="" title="Line Code" maxlength="2"/>
							<input id="riFrpsYy"  class="integerNoNegativeUnformattedNoComma rightAligned" type="text" name="riFrpsYy"  style="width: 8%;" value="" title="Year" maxlength="2"/>
							<input id="riFrpsSeqNo"   class="integerNoNegativeUnformattedNoComma rightAligned" type="text" name="riFrpsSeqNo"  style="width: 15%;"  value="" title="FRPS Sequence No" maxlength="8"/>
							<input type="hidden" id="riDistNo" name="riDistNo"/>
			 				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFRPS" name="searchFRPS" alt="Go" style="margin-top: 2px;" title="Search FRPS"/>
						 	<input type="hidden" id="loadFromUWMenu" name="loadFromUWMenu" value="${fromUWMenu}" />	
						 </td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Policy No.</td>
						<td class="leftAligned" width="210px">
							<input type="text" id="riPolicyNo" name="riPolicyNo" style="width: 210px;" readonly="readonly" />
						</td>
						<td class="rightAligned" width="180px">Endorsement No.</td>
						<td class="leftAligned" width="210px">
							<input type="text" id="riEndtNo" name="riEndtNo" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Assured Name</td>
						<td class="leftAligned" colspan="3"  width="210px">
							<input type="text" id="riAssdName" name="riAssdName" style="width: 95%;" readonly="readonly" />
						</td>
					</tr>
				</table>
				
			</div>
		</div>
		
		<div id="binderListingMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Binder Listing</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<div id="binderListingDiv" class="sectionDiv">
				<div id="binderListingTableGrid" style="position:relative; height: 280px; margin-left: 3%; margin-top: 20px; margin-bottom: 10px; float: left"></div>
				<div class="buttonsDiv" style="padding: 2px; margin-bottom: 10px; margin-top: 0;">
					<input type="button" class="button" id="btnReverse" name="btnReverse" value="Reverse" style="margin-left: 18%; width: 12%"/>
					<div style="margin-right: 4%;  float: right">
						<strong>R- Reversed P- Print</strong>
					</div>
				</div>
		</div>	
	</form>
</div>

<script>
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	makeInputFieldUpperCase();
	
	//ENHANCEMENT - christian 12132012
	var restrictBndrWFacPayt = '${restrictBndrWFacPayt}'; 
	var restrictBndrWClaim = '${restrictBndrWClaim}';
	var overrideRF = "N";
	var overrideRB = "N";
	var isReversalAllowed = "Y";
	
	$("reverseBinderExit").observe("click", function(){
		if($F("loadFromUWMenu") == "Y") 
			objRiFrps = new Object();
			checkChangeTagBeforeUWMain();
	});

	var reports = [];
	$("btnReverse").observe("click", function(){
		if(checkReverseSw()){
			checkBinderWithFacPayt();
		}
	});
	
	function checkBinderWithFacPayt(){
		try{
			var rows = frpsRiGrid.geniisysRows; 
			var x = frpsRiGrid.getColumnIndex("reverseSw");
			var y = 0;
			var proceed = "Y";
			
			for(var i=0; i<rows.length;  i++){
				if(rows[i].reverseSw == "Y"){
					y = i; 
					fnlBinderId = rows[i].fnlBinderId;
					riCd = rows[i].riCd;
					var outFaculTotAmt = 0;
					
					new Ajax.Request(contextPath+"/GIRIFrpsRiController", {
						method: "POST",
						parameters: {action : "getOutFaculTotAmtGIUTS004",
									 lineCd : $F("riLineCd"),
									 riCd : riCd,
									 fnlBinderId : fnlBinderId,
									 frpsYy : $F("riFrpsYy"),
									 frpsSeqNo : $F("riFrpsSeqNo")},
						asynchronous: false,
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								outFaculTotAmt = response.responseText;
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}					
					});
					
					if(outFaculTotAmt != 0){
						if(nvl(restrictBndrWFacPayt, "N") == "Y"){
							printSw = "N";
							reverseSw = "N";
							$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
							rows[i].reverseSw = "N";
							showMessageBox("This policy has an existing FACULTATIVE PREMIUM  PAYMENT(s), " +
									"reversal/replacing this binder is not allowed.", imgMessage.ERROR);
							isReversalAllowed = "N";
							proceed = "N";
							break;
							return false;
						}else if(nvl(restrictBndrWFacPayt, 'N') == 'N'){
							showConfirmBox("Confirmation", "This policy has an existing FACULTATIVE PREMIUM PAYMENT(s), " +
									"please inform the ACCOUNTING/FINANCE Department before reversal/replacing this binder. " +
									"Do you want to continue?","Yes","No",
											function(){
												checkBinderWithClaimsGIUTS004();
											},
											function(){
												$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
												frpsRiGrid.geniisysRows[i].reverseSw = "N";
												printSw = "N";
												reverseSw = "N";
												isReversalAllowed = "N";
												return false;
											}
							);
							proceed = "N";
							break;
						}else if(nvl(restrictBndrWFacPayt, 'N') == 'O'){
							showConfirmBox("Confirmation", "This policy has an existing FACULTATIVE PREMIUM PAYMENT(s), " +
									"please inform the ACCOUNTING/FINANCE Department before reversal/replacing this binder. " +
									"Do you want to continue?","Yes","No",
											function(){
												if (giacValidateUserFn("RF") == "TRUE") {
													checkBinderWithClaimsGIUTS004();
												}else {
													showConfirmBox("Confirmation", "Cannot process reversal of binder(s) of policy with FACULTATIVE PREMIUM PAYMENT(s). "+
															"Would you like to override?","Yes","No",
																	function(){
																		if(overrideRF == "Y"){
																			checkBinderWithClaimsGIUTS004();
																		}else{
																			override("RF", i);
																		}
																	},
																	function(){
																		$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
																		frpsRiGrid.geniisysRows[i].reverseSw = "N";
																		printSw = "N";
																		reverseSw = "N";
																		isReversalAllowed = "N";
																		return false;
																	}
													);
												}
											},
											function(){
												$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
												frpsRiGrid.geniisysRows[i].reverseSw = "N";
												printSw = "N";
												reverseSw = "N";
												isReversalAllowed = "N";
												return false;
											}
							);
							proceed = "N";
							break;
						}
					}else{
						proceed = "Y";
					}
				}
			}
			
			if(proceed == "Y"){
				checkBinderWithClaimsGIUTS004();
			}
			
		}catch(e){
			showErrorMessage("checkBinderWithFacPayt", e);
		}
	}
	
	function checkBinderWithClaimsGIUTS004(){
		try{
			var rows = frpsRiGrid.geniisysRows; 
			var x = frpsRiGrid.getColumnIndex("reverseSw");
			var y = 0;
			var proceed = "Y";
			
			for(var i=0; i<rows.length;  i++){
				if(rows[i].reverseSw == "Y"){
					y = i;
					fnlBinderId = rows[i].fnlBinderId;
					riCd = rows[i].riCd;
					var withClaims = "N";
					
					new Ajax.Request(contextPath+"/GIRIFrpsRiController", {
						method: "POST",
						parameters: {action : "checkBinderWithClaimsGIUTS004",
							lineCd: $F("riLineCd"),
							fnlBinderId: fnlBinderId,
							frpsYy: $F("riFrpsYy"),
							frpsSeqNo: $F("riFrpsSeqNo"),
							distNo: $F("riDistNo")},
						asynchronous: false,
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								if (response.responseText == 'TRUE'){
									withClaims = "Y";
								}else{
									withClaims = "N";
								}	
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}					
					});
					
					if(withClaims == "Y"){
						if(nvl(restrictBndrWClaim, 'N') == 'Y'){
							$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
							frpsRiGrid.geniisysRows[i].reverseSw = "N";
							printSw = "N";
							reverseSw = "N";
							showMessageBox("This policy has an existing claim(s), reversal/replacing this binder is not allowed.", imgMessage.ERROR);
							proceed = "N";
							isReversalAllowed = "N";
							return false;
						}else if(nvl(restrictBndrWClaim, 'N') == 'N'){
							showConfirmBox("Confirmation", "This policy has an existing claim(s), "+
									"please inform the Claims Department before reversal/replacing this binder. "+
									"Do you want to continue?","Yes","No",
											function(){
												frpsRiGrid.geniisysRows[i].recordStatus = 1;
												isReversalAllowed = "Y";
												reverseBinders();
												return true;
											},
											function(){
												$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
												frpsRiGrid.geniisysRows[i].reverseSw = "N";
												printSw = "N";
												reverseSw = "N";
												isReversalAllowed = "N";
												return false;
											}
							);
							proceed = "N";
							break;
						}else if(nvl(restrictBndrWClaim, 'N') == 'O'){
							showConfirmBox("Confirmation", "This policy has an existing claim(s), "+
									"please inform the Claims Department before reversal/replacing this binder. "+
									"Do you want to continue?","Yes","No",
											function(){
												if (giacValidateUserFn("RB") == "TRUE") {
													frpsRiGrid.geniisysRows[i].recordStatus = 1;
													isReversalAllowed = "Y";
													reverseBinders();
													return true;
												}else {
													showConfirmBox("Confirmation", "Cannot process reversal of binder(s) of policy with claim(s). "+ 
															"Would you like to override?","Yes","No",
																	function(){
																		if(overrideRB == "Y"){
																			frpsRiGrid.geniisysRows[i].recordStatus = 1;
																			isReversalAllowed = "Y";
																			reverseBinders();
																		}else{
																			override("RB", i);
																		}
																	},
																	function(){
																		$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
																		frpsRiGrid.geniisysRows[i].reverseSw = "N";
																		printSw = "N";
																		reverseSw = "N";
																		isReversalAllowed = "N";
																		return false;
																	}
													);
												}
											},
											function(){
												$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
												frpsRiGrid.geniisysRows[i].reverseSw = "N";
												printSw = "N";
												reverseSw = "N";
												isReversalAllowed = "N";
												return false;
											}
							);
							proceed = "N";
							break;
						}
					}else{
						isReversalAllowed = "Y";
						proceed = "Y";
					}
				}
			}
			
			if (proceed == "Y"){
				reverseBinders();
			}
		}catch(e){
			showErrorMessage("checkBinderWithClaimsGIUTS004", e);
		}
	}
	
	function giacValidateUserFn(funcCode){
		try{
			var isOk;
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
				method: "POST",
				parameters: {action : "validateUserFunc",
					funcCode: funcCode,
					moduleName: "GIUTS004"},
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
			showErrorMessage("getOutFaculTotAmt", e);
		}
	}
	
	function override(funcCd, y){
		var x = frpsRiGrid.getColumnIndex("reverseSw");
		
		showGenericOverride(
				"GIUTS004",
				funcCd,
				function(ovr, userId, result){
					if(result == "FALSE"){
						if(funcCd == "RB"){
							showMessageBox("User " + userId + " does not have access in function REVERSE BINDER WITH CLAIM OVERRIDE. Please contact your administrator.", imgMessage.ERROR);
						}else{
							showMessageBox("User " + userId + " does not have access in function REVERSE BINDER WITH FACULTATIVE PREMIUM PAYMENT. Please contact your administrator.", imgMessage.ERROR);
						}
						$("txtOverrideUserName").clear();
						$("txtOverridePassword").clear();
						
						ovr.close();
						delete ovr;
						$("mtgInput"+mtgId+"_"+x+","+y).checked = false;
						frpsRiGrid.geniisysRows[i].reverseSw = "N";
						printSw = "N";
						reverseSw = "N";
						return false;
					}else {
						if(result == "TRUE"){
							if(funcCd == "RB"){
								overrideRB = "Y";
								frpsRiGrid.geniisysRows[i].recordStatus = 1;
								isReversalAllowed = "Y";
								reverseBinders();
							}else{
								overrideRF = "Y";
								checkBinderWithClaimsGIUTS004();
							}
							ovr.close();
							delete ovr;	
						}
					}
				},
				""
		);
	}
	
	function printTagged(){
		if (printSw == "Y"){
			var arr = frpsRiGrid.geniisysRows[i].binderNo.split(" - ");
			lineCd = arr[0];
			binderYy = arr[1];
			binderSeqNo = arr[2];
			printBinderReport();
		}
	}
	
	function reverseBinders(){
		var rows =   frpsRiGrid.geniisysRows; //frpsRiGrid.getModifiedRows();
		
		for(var i=0; i<rows.length;  i++){
			reverseSw = rows[i].reverseSw;
			fnlBinderId = rows[i].fnlBinderId;
			if (reverseSw == "N") {
				printSw = "N";
			}else{
				printSw = rows[i].printSw;
			}
			performReversal();
			if (printSw == "Y"){
				var arr = rows[i].binderNo.split(" - ");
				lineCd = arr[0];
				binderYy = arr[1];
				binderSeqNo = arr[2];
				printBinderReport();
			}
		}
		
		//added condition to prevent error when there's no record to be printed - apollo cruz 7.8.2014
		if(reports.length > 0) 
			showMultiPdfReport(reports);
		
		reports = [];
		updateDistFrps();
	}
	
	$("searchFRPS").observe("click", function() {
		if($F("riLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("riLineCd").focus();
			});
			return;
		}
		showDistFrpsLOV2($F("riLineCd"), $F("riFrpsYy"), $F("riFrpsSeqNo"));
	});
	
	observeReloadForm("reloadForm", 
			function() {
				if($F("loadFromUWMenu") == "Y") 
					objRiFrps = new Object();
					showReverseBinderPage($F("loadFromUWMenu"));
	});
	
	observeReloadForm("reverseBinderQuery",   // andrew - 12.6.2012 
			function() {
				if($F("loadFromUWMenu") == "Y") 
					objRiFrps = new Object();
					showReverseBinderPage($F("loadFromUWMenu"));
	});
	
	var fnlBinderId = "";
	var reverseSw = "";
	var printSw = "";
	var riCd = "";
	var lineCd = "";
	var binderYy = "";
	var bindeSeqNo = "";
	var objFrpsRi = new Object(); 
	var selectedFrpsRi = null;
	var selectedFrpsRiRow = new Object();
	var mtgId = null;
	objFrpsRi.binderListingTableGrid = JSON.parse('${frpsRiGrid}'.replace(/\\/g, '\\\\'));
	objFrpsRi.frpsRi = objFrpsRi.binderListingTableGrid.rows || [];
	
	try {
		var binderListingTable = {
			/*url: contextPath+"/GIRIFrpsRiController?action=refreshFrpsRiGrid&frpsYy="+objRiFrps.frpsYy
					+"&lineCd="+objRiFrps.lineCd+"&frpsSeqNo="+ objRiFrps.frpsSeqNo, replaced by: Nica 10.09.2012*/
			url: contextPath+"/GIRIFrpsRiController?action=showReverseBinderTableGrid&refresh=1&frpsYy="+objRiFrps.frpsYy
					+"&lineCd="+objRiFrps.lineCd+"&frpsSeqNo="+ objRiFrps.frpsSeqNo,
			options: {
				title: '',
				width: '870px',
				height: '275px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = frpsRiGrid._mtgId;
					selectedFrpsRi = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedFrpsRiRow = frpsRiGrid.geniisysRows[y];
					}
				}
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'fnlBinderId',
					width: '0',
					visible: false
				},
				{	
					id: 'riCd',
					width: '0',
					visible: false
				},
				{
					id: 'binderNo',
					title: 'Binder No',
					width: '165',
					titleAlign: 'left',
					editable: false,
					sortable:	false
				},
				{
					id: 'riSname',
					title: 'Reinsurer',
					width: '165',
					titleAlign: 'left',
					editable: false,
					sortable:	false
				},
				{
					id: 'riShrPct',
					title: 'RI Share %',
					width: '120px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					sortable:	false,
					geniisysClass: 'rate'
				},
				{
					id: 'riTsiAmt',
					title: 'RI TSI Amount',
					width: '165',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					sortable:	false,
					geniisysClass: 'money'
				},
				{
					id: 'riPremAmt',
					title: 'RI Premium Amount',
					width: '165',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					sortable:	false,
					geniisysClass: 'money'
				},
				{	id:			'reverseSw',
					sortable:	false,
					align:		'center',
					altTitle:   'Reversed',
					title:		'&#160;&#160;R',
					titleAlign:	'center',
					width:		'23px',
					editable:  true,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked) {
							if(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('reverseSw'), selectedFrpsRi) == "N") {
								$("mtgInput"+mtgId+"_10,"+selectedFrpsRi).checked = false;
								frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "N";
							}else {
								fnlBinderId = frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('fnlBinderId'), selectedFrpsRi);
								riCd = frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('riCd'), selectedFrpsRi);
								checkBinder();
							}
	 			    	}
		            })
				},
              	{	id:			'printSw',
					sortable:	false,
					align:		'center',
					altTitle:   'Print',
					title:		'&#160;&#160;P',
					titleAlign:	'center',
					width:		'23px',
					editable	: true,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	 
		            		}	
		            	},
		            	onClick: function(value, checked) {
							if(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('reverseSw'), selectedFrpsRi) == "N") {
								showMessageBox("Only Binders that are to be reversed can be printed", "E");
								$("mtgInput"+mtgId+"_10,"+selectedFrpsRi).checked = false;
								frpsRiGrid.geniisysRows[selectedFrpsRi].printSw = "N";
							}else{
								frpsRiGrid.geniisysRows[selectedFrpsRi].printSw = "Y";
							}
	 			    	}
		            })
              	}
			],
			resetChangeTag: true,
			rows: objFrpsRi.frpsRi
		};
		frpsRiGrid = new MyTableGrid(binderListingTable);
		//frpsRiGrid.pager = objFrpsRi.binderListingTableGrid;
		frpsRiGrid.render('binderListingTableGrid');
	}catch(e) {
		showErrorMessage("frpsRiGrid", e);
	}
	
	function setFrpsDetail(row) {
		try {
			if(row != null) {
				$("riLineCd").value				=	row.lineCd == null ? "" : row.lineCd;
				$("riFrpsYy").value				=	row.frpsYy	== null ? "" : row.frpsYy.toPaddedString(2);
				$("riFrpsSeqNo").value		=	row.frpsSeqNo == null ? "" : row.frpsSeqNo.toPaddedString(8);
				$("riPolicyNo").value			=	row.policyNo == null ? "" : row.policyNo;
				$("riEndtNo").value			=	row.endtNo == null ? "" : row.endtNo;
				$("riAssdName").value		=	row.assdName == null ? "" : unescapeHTML2(row.assdName);
				$("riDistNo").value				=	row.distNo == null ? "" : row.distNo;
			}
		} catch(e) {
			showErrorMessage("setFrpsDetail", e);
		}
	}
	setFrpsDetail(objRiFrps);
	
	function performReversal(){
		try{
			new Ajax.Request(contextPath+"/GIRIFrpsRiController", {
				method: "POST",
				parameters: {action 				 : "performReversalGiuts004",
										   lineCd		 			 : $F("riLineCd")	,
										   reverseSw		 : reverseSw,
										   fnlBinderId		 : fnlBinderId,
										   frpsYy					 : $F("riFrpsYy"),
										   frpsSeqNo	 		 : $F("riFrpsSeqNo"),
										   distNo				 : $F("riDistNo")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var arr = response.responseText.split(",");
						var workflowMsgr = arr[0];
						var msg = arr[1];
						if(workflowMsgr != ""){
							showMessageBox(workflowMsgr, imgMessage.ERROR);
							return false;
						} else if(msg == ("Invalid user.") ){
							showMessageBox(msg, imgMessage.ERROR);
							return false;
						} 
					}else
						showMessageBox(response.responseText, imgMessage.ERROR);
				}					
			});
		}catch(e){
			showErrorMessage("performReversal", e);
		}
	}
		
	function checkBinder(){
		try{
			new Ajax.Request(contextPath+"/GIRIFrpsRiController", {
				method: "POST",
				parameters: {action 			 : "checkBinderGiuts004",
										   riCd		 			 : riCd,
										   fnlBinderId	 : fnlBinderId},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var msg = response.responseText;
						if(msg ==  1){
							showMessageBox("This binder has payments to FACUL Reinsurers.", "I");
							frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "Y";
						}else if(msg ==  2){
							showMessageBox("This binder has payments to FACUL Reinsurers. Cannot reverse binder.", "I");
							$("mtgInput"+mtgId+"_9,"+selectedFrpsRi).checked = false;
							frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "N";
						}else if(msg == 3){ //added by j.diago 09.17.2014
							showMessageBox("Cannot reverse binder with binder included in a Package binder. Please reverse package binder before proceeding with the reversal.","I");
							$("mtgInput"+mtgId+"_9,"+selectedFrpsRi).checked = false;
							frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "N";
						}else if(msg == 4){ //added by j.diago 09.17.2014
							showMessageBox("Cannot reverse binder with binder included in a Grouped binder. Please un-grouped the grouped binder before proceeding with the reversal.","I");
							$("mtgInput"+mtgId+"_9,"+selectedFrpsRi).checked = false;
							frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "N";
						}
						else{
							frpsRiGrid.geniisysRows[selectedFrpsRi].reverseSw = "Y";
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
		}catch(e){
			showErrorMessage("checkBinder", e);
		}	
	}
	
	function updateDistFrps(){
		try{
			new Ajax.Request(contextPath+"/GIRIDistFrpsController", {
				method: "POST",
				parameters: {action 		 : "updateDistFrpsGiuts004",
						     lineCd		 	 : $F("riLineCd"),
						     frpsYy			 : $F("riFrpsYy"),
						     frpsSeqNo	 	 : $F("riFrpsSeqNo"),
						     distNo			 : $F("riDistNo")},
			   onComplete: function(){
				   showWaitingMessageBox("Reverse complete.", imgMessage.SUCCESS,
							function() { if($F("loadFromUWMenu") == "Y") 
													objRiFrps = new Object();
													showReverseBinderPage($F("loadFromUWMenu"));
							});
				}	
			});
		}catch(e){
			showErrorMessage("updateDistFrps", e);
		}
	}
	
	function checkReverseSw(){
		var result = true;
		var rows =   frpsRiGrid.getModifiedRows();
		var num = 0;
		for(var i=0; i<rows.length;  i++){
			reverseSw = rows[i].reverseSw;
			if (reverseSw == "Y"){
				num += 1;
			}
		}
		if (num <  1){
			result = false;
			showMessageBox("Please indicate which binder will be reversed.","E");
		}
		return result;
	}

	function printBinderReport(){
		try {
			
			var content = contextPath+"/ReverseBinderController?action=printBinderReport"
			+"&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo;
			
			reports.push({reportUrl : content, reportTitle : "Binder Report"});
		//window.open(content, "", "location=0, toolbar=0, menubar=0, fullscreen=1");
		//showPdfReport(content, "Binder Report"); // andrew - 12.12.2011
		//hideNotice("");
			
		} catch(e){
			showErrorMessage("printBinderReport", e);
		}
	}

	 // andrew - 12.6.2012
	$("riLineCd").focus(); 
	if(objRiFrps.policyNo != null){
		 $("riLineCd").writeAttribute("readonly", "readonly");
		 $("riFrpsYy").writeAttribute("readonly", "readonly");
		 $("riFrpsSeqNo").writeAttribute("readonly", "readonly");
	}
	// end andrew
}catch(e){
	showErrorMessage("GIUTS004 page", e);
}
</script>

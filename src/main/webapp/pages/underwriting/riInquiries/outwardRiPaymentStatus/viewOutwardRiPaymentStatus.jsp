<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Outward RI Payment Status</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="filterDiv">
	<table align="center" border="0" style="margin: 15px auto;">
		<tr>
			<td><label for="" style="float: right; margin-right: 5px;">FRPS No.</label></td>
			<td>
				<input type="text" id="txtLineCd" class="allCaps required" style="width: 50px; margin: 0;"/>
				<input type="text" id="txtFrpsYy" class="integerNoNegativeUnformattedNoComma" style="width: 70px; text-align: right; margin: 0;"/>
				<input type="text" id="txtFrpsSeqNo" class="integerNoNegativeUnformattedNoComma" style="width: 256px; text-align: right; margin: 0;"/>
				<input type="hidden" />
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFRPS" alt="Go" style="float: right; margin-top: 3px; margin-left: 3px;" tabindex=""/>
			</td>
			<td><label for="txtEffDate" style="float: right; margin-right: 5px;">Coverage Pd.</label></td>
			<td>
				<div style="float: left; width: 120px; height: 20px; margin: 0;" class="withIconDiv">
					<input type="text" id="txtEffDate" ignoreDelKey="true" class="withIcon" readonly="readonly" style="width: 96px;" tabindex="201"/>
					<img id="imgEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
				</div>
				<label for="txtExpiryDate" style="margin: 3px 10px 0 10px;">to</label>
				<div style="float: left; width: 120px; height: 20px; margin: 0;" class="withIconDiv">
					<input type="text" id="txtExpiryDate" ignoreDelKey="true" class="withIcon" readonly="readonly" style="width: 96px;" tabindex="201"/>
					<img id="imgExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
				</div>
			</td>
		</tr>
		<tr>
			<td><label for="txtLineCd" style="float: right; margin-right: 5px;">Policy No.</label></td>
			<td>
				<input type="text" id="txtDspLineCd" class="allCaps" style="width: 50px; margin: 0;" />
				<input type="text" id="txtSublineCd" class="allCaps" style="width: 70px; margin: 0;" />
				<input type="text" id="txtIssCd" class="allCaps" style="width: 50px; margin: 0;" />
				<input type="text" id="txtIssueYy" class="integerNoNegativeUnformattedNoComma" style="width: 50px; margin: 0; text-align: right;" />
				<input type="text" id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma" style="width: 70px; margin: 0; text-align: right;" />
				<input type="text" id="txtRenewNo" class="integerNoNegativeUnformattedNoComma" style="width: 50px; margin: 0; text-align: right;" />
			</td>
			<td><label for="txtEndtIssCd" style="float: right; margin-right: 5px;">Endorsement No.</label></td>
			<td>
				<input type="text" id="txtEndtIssCd" class="allCaps" style="width: 51px; margin: 0;" />
				<input type="text" id="txtEndtYy" class="integerNoNegativeUnformattedNoComma" style="width: 51px; margin: 0; text-align: right;" />
				<input type="text" id="txtEndtSeqNo" class="integerNoNegativeUnformattedNoComma" style="width: 141px; margin: 0; text-align: right;" />
			</td>
		</tr>
		<tr>
			<td><label for="txtAssured" style="float: right; margin-right: 5px;">Assured</label></td>
			<td colspan="3">
				<input type="text" id="txtAssured" class="allCaps" style="width: 808px; margin: 0;" />
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" style="clear: both; float: none; text-align: center; margin-bottom: 50px;">
	<div style="padding: 10px 0 0 10px;">
		<div id="mainTableGridDiv" style="height: 300px; margin-left: auto;"></div>
	</div>
	<input type="button" id="btnDetails" class="button" value="Details" style="width: 120px; margin-bottom: 10px;" />
</div>
<script type="text/javascript">
	try {

		objGIRIS012 = new Object();
		
		function initGIRIS012(){
			setModuleId("GIRIS012");
			setDocumentTitle("Outward RI Payment Status");
			$("txtLineCd").focus();
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			$("btnToolbarPrint").hide();
		}
		
		function resetForm(){
			objGIRIS012 = new Object();
			populateMainTG(null);
			mainTableGridDiv.url = contextPath+"/GIRIInpolbasController?action=showOutwardRiPaymentStatus&refresh=1";
			mainTableGridDiv._refreshList();
			enableSearch("imgFRPS");
			enableDate("imgEffDate");
			enableDate("imgExpiryDate");
			$$("div#filterDiv input[type='text']").each(function(obj){
				if(obj.id != "txtEffDate" && obj.id != "txtExpiryDate"){
					obj.readOnly = false;
				}
			});
		}
		
		//$("btnReloadForm").observe("click", showOutwardRiPaymentStatus);
		$("btnReloadForm").observe("click", resetForm);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		function populateMainTG(row){
			if(row != null){
				
				$("txtLineCd").value = row.lineCd;
				$("txtFrpsYy").value = row.frpsYy;
				$("txtFrpsSeqNo").value = formatNumberDigits(row.frpsSeqNo, 8);
				
				$("txtEffDate").value = dateFormat(row.effDate, "mm-dd-yyyy");
				$("txtExpiryDate").value = dateFormat(row.expiryDate, "mm-dd-yyyy");
				
				$("txtDspLineCd").value = row.lineCd;
				$("txtSublineCd").value = row.sublineCd;
				$("txtIssCd").value = row.issCd;
				$("txtIssueYy").value = row.issueYy;
				$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
				$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
				
				$("txtEndtIssCd").value = row.endtIssCd;
				$("txtEndtYy").value = row.endtYy;
				$("txtEndtSeqNo").value = formatNumberDigits(row.endtSeqNo, 6);
				
				$("txtAssured").value = unescapeHTML2(row.assured.toUpperCase());
				
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				
				objGIRIS012.effDate = $F("txtEffDate");
				objGIRIS012.expDate = $F("txtExpiryDate");
				
				/* disableDate("imgEffDate");
				disableDate("imgExpiryDate"); */
				
			} else {
				$$("div#filterDiv input[type='text']").each(function(obj){
					obj.clear();	
				});
				
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		}
		
		function getGIRIS012FRPSLov(){
			onLOV = true;
			LOV.show({
				id : "giris012FRPSLov",
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIRIS012FRPSLov",
					lineCd : $F("txtLineCd") != "" ? $F("txtLineCd") : $F("txtDspLineCd"),
					frpsYy : $F("txtFrpsYy"),
					frpsSeqNo : $F("txtFrpsSeqNo"),
					effDate : $F("txtEffDate"),
					expiryDate : $F("txtExpiryDate"),
					sublineCd : $F('txtSublineCd'),
					issCd : $F('txtIssCd'),
					issueYy : $F('txtIssueYy'),
					polSeqNo : $F('txtPolSeqNo'),
					renewNo : $F('txtRenewNo'),
					assured : $F('txtAssured'),
					endtIssCd : $F('txtEndtIssCd'),
					endtSeqNo : $F('txtEndtSeqNo'),
					endtYy : $F('txtEndtYy'),
					page : 1
				},
				hideColumnChildTitle : true,
				filterVersion: "2",
				title : "List of FRPS Nos.",
				width : 700,
				height : 403,
				columnModel : [
               		{
						id : "frpsNo",
						title : "FRPS No.",
						width: 150,
						children : [
							{
								id: 'lineCd',
								title: 'Line Cd',
								width: 50
							},
							{
								id: 'frpsYy',
								title: 'FRPS Yr',
								width: 40,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right"
							},
							{
								id: 'frpsSeqNo',
								title: 'FRPS Seq No',
								width: 60,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right",
								renderer: function(val){
									return formatNumberDigits(val, 8);
								}
							}
						]
					},
					{
						id: "effDate",
						title : "Effectivity Date",
						width: 100,
						align: "center",
						titleAlign: "center",
						filterOption: true,
						filterOptionType: "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{
						id: "expiryDate",
						title : "Expiry Date",
						width: 100,
						align: "center",
						titleAlign: "center",
						filterOption: true,
						filterOptionType: "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{
						id : 'policyNo',
						title : 'Policy No.',
						width: 330,
						children : [
							{
								id: 'lineCd',
								title : 'Line Cd',
								width: 50,
								filterOption: false
							},
							{
								id: 'sublineCd',
								title : 'Subline Cd',
								width: 70,
								filterOption: true
							}
							,
							{
								id: 'issCd',
								title : 'Iss Cd',
								width: 50,
								filterOption: true
							},
							{
								id: 'issueYy',
								title : 'Issue Yr',
								width: 40,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right"
							},
							{
								id: 'polSeqNo',
								title : 'Pol Seq No.',
								width: 70,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right",
								renderer: function(val){
									return formatNumberDigits(val, 7);
								}
							},
							{
								id: 'renewNo',
								title : 'Renew No.',
								width: 50,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right",
								renderer: function(val){
									return formatNumberDigits(val, 2);
								}
							}
						]
					},
					{
						id : 'endorsementNo',
						title : 'Endt No.',
						width: 150,
						children : [
							{
								id: 'endtIssCd',
								title : 'Endt Iss Cd',
								width: 50,
								filterOption: true
							},
							{
								id: 'endtYy',
								title : 'Endt Yr',
								width: 40,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right"
							},
							{
								id: 'endtSeqNo',
								title : 'Endt Seq No',
								width: 60,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								align: "right",
								titleAlign: "right",
								renderer: function(val){
									return formatNumberDigits(val, 6);
								}
							}
						]
					},
					{
						id : 'assured',
						title : 'Assured',
						width : 500,
						filterOption : true,
						renderer : function(val){
							return unescapeHTML2(val).toUpperCase();
						}
					}
          		],
				draggable : true,
				autoSelectOneRecord: true,
				onSelect : function(row) {
					onLOV = false;
					populateMainTG(row);
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					onLOV = false;
				}
			});
		}
		
		var jsonGIRIS012MainTG = JSON.parse('${jsonGIRIS012MainTG}');
		giris012TG = {
				url: contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1",
				id: 'tbgMain',		
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					height: '265px',
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						objGIRIS012.fnlBinderId = mainTableGridDiv.geniisysRows[y].fnlBinderId;
						mainTableGridDiv.keys.removeFocus(mainTableGridDiv.keys._nCurrentFocus, true);
						mainTableGridDiv.keys.releaseKeys();
						enableButton("btnDetails");
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						objGIRIS012.fnlBinderId = mainTableGridDiv.geniisysRows[0].fnlBinderId;
						mainTableGridDiv.keys.removeFocus(mainTableGridDiv.keys._nCurrentFocus, true);
						mainTableGridDiv.keys.releaseKeys();
						disableButton("btnDetails");
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'binderNo',
						title: 'Binder No.',
						width: 150,
						filterOption: true,
					},
					{
						id: 'riSname2',
						title: 'Reinsurer',
						width: 267,
						filterOption: true,
						renderer: function(val){
							return unescapeHTML2(val).toUpperCase();
						}
					},
					{
						id: 'netDueComputed',
						title: 'Net Due',
						width: 150,
						geniisysClass : "money",
						filterOption: true,
						filterOptionType: "number",
						align: "right",
						titleAlign: "right"
					},
					{
						id: 'totAmtPaid',
						title: 'Total Amt. Paid',
						width: 150,
						geniisysClass : "money",
						filterOption: true,
						filterOptionType: "number",
						align: "right",
						titleAlign: "right"
					},
					{
						id: 'balance',
						title: 'Balance',
						width: 150,
						geniisysClass : "money",
						filterOption: true,
						filterOptionType: "number",
						align: "right",
						titleAlign: "right"
					}
					
				],
				rows: jsonGIRIS012MainTG.rows
			};
		
		mainTableGridDiv = new MyTableGrid(giris012TG);
		mainTableGridDiv.pager = jsonGIRIS012MainTG;
		mainTableGridDiv.render('mainTableGridDiv');
		mainTableGridDiv.afterRender = function(){
			try{
				if(mainTableGridDiv.geniisysRows.length > 0){
					objGIRIS012.fnlBinderId = mainTableGridDiv.geniisysRows[0].fnlBinderId;
					//enableButton("btnDetails");
				} else {
					objGIRIS012.fnlBinderId = null;
					//disableButton("btnDetails");
				}					
				disableButton("btnDetails");
			}catch(e){
				showErrorMessage("Error: ", e);
			}
		};
		
		function executeQuery(){
			mainTableGridDiv.url = contextPath+"/GIRIInpolbasController?action=showOutwardRiPaymentStatus&refresh=1&lineCd=" + $F("txtLineCd")
																												+ "&frpsYy=" + $F("txtFrpsYy")
																												+ "&frpsSeqNo=" + $F("txtFrpsSeqNo");
			mainTableGridDiv._refreshList();
			
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgFRPS");
			disableDate("imgEffDate");
			disableDate("imgExpiryDate");
			
			$("imgFRPS").next().setStyle({marginLeft: "3px", marginTop: "3px"});
			$("imgEffDate").next().setStyle({margin: "1px 1px 0 0"});
			$("imgExpiryDate").next().setStyle({margin: "1px 1px 0 0"});
			
			$$("div#filterDiv input[type='text']").each(function(obj){
				if(obj.id != "txtEffDate" || obj.id != "txtExpiryDate"){
					obj.readOnly = true;
				}
			});
		}
		
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		
		function showDetails() {
			try {
			overlayDetails = 
				Overlay.show(contextPath+"/GIRIInpolbasController", {
					urlContent: true,
					urlParameters: {action : "showGIRIS012Details",																
									ajax : "1",
									fnlBinderId : objGIRIS012.fnlBinderId
					},
				    title: "Details",
				    height: 300,
				    width: 500,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay error: " , e);
			}
		}
		
		$("btnDetails").observe("click", showDetails);
		
		$("imgFRPS").observe("click", function(){
			
			if($F("txtLineCd").trim() == "" && $F("txtDspLineCd").trim() == ""){
				customShowMessageBox("Line Code must be entered.", "I", "txtLineCd");
				$("txtLineCd").clear();
				$("txtDspLineCd").clear();
				return;
			}				
			
			getGIRIS012FRPSLov();
		});
		
		$("imgEffDate").observe("click", function(){
			scwShow($("txtEffDate"), this, null);
		});
		
		$("imgExpiryDate").observe("click", function(){
			scwShow($("txtExpiryDate"), this, null);
		});
		
		
		$("txtEffDate").observe("focus", function(){
			if ($("imgEffDate").disabled == true) return;
			
			var effDate = $F("txtEffDate") != "" ? new Date($F("txtEffDate").replace(/-/g,"/")) :"";
			var expiryDate = $F("txtExpiryDate") != "" ? new Date($F("txtExpiryDate").replace(/-/g,"/")) :"";
			
			if (expiryDate < effDate && expiryDate != ""){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtEffDate");
				$("txtEffDate").clear();
				disableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
			
			if(this.value != objGIRIS012.effDate)
				disableToolbarButton("btnToolbarExecuteQuery");
			
			objGIRIS012.effDate = this.value;
		});
	 	
	 	$("txtExpiryDate").observe("focus", function(){
			if ($("imgExpiryDate").disabled == true) return;
			
			var expiryDate = $F("txtExpiryDate") != "" ? new Date($F("txtExpiryDate").replace(/-/g,"/")) :"";
			var effDate = $F("txtEffDate") != "" ? new Date($F("txtEffDate").replace(/-/g,"/")) :"";
			
			if (expiryDate < effDate && expiryDate != ""){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtExpiryDate");
				$("txtExpiryDate").clear();
				disableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
			
			if(this.value != objGIRIS012.expDate)
				disableToolbarButton("btnToolbarExecuteQuery");
			
			objGIRIS012.expDate = this.value;
		});
	 	
	 	$("txtEffDate").observe("keypress", function(event){
	 		if($("txtLineCd").readOnly)
	 			return;
	 		
	 		if(event.keyCode == 8 || event.keyCode == 46){
	 			this.clear();
	 			disableToolbarButton("btnToolbarExecuteQuery");
	 		}
	 	});
	 	
	 	$("txtExpiryDate").observe("keypress", function(event){
	 		if($("txtLineCd").readOnly)
	 			return;
	 		
	 		if(event.keyCode == 8 || event.keyCode == 46){
	 			this.clear();
	 			disableToolbarButton("btnToolbarExecuteQuery");
	 		}
	 	});
		
		$$("div#filterDiv input[type='text']").each(function(obj){
			if(obj.id != "txtEffDate" || obj.id != "txtExpiryDate"){
				obj.observe("keypress", function(event){
					if(obj.readOnly)
						return;
					
					if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 13 || event.keyCode == 46){
						disableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				});
			}
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		initializeAll();
		initGIRIS012();
		
	} catch (e) {
		showErrorMessage("Error" , e);
	}
</script>
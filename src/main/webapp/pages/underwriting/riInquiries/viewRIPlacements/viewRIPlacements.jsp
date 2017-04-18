<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewRIPlacementMainDiv" name="viewRIPlacementMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Reinsurance Placement</label>
		</div>
	</div>
	
	<div id="riPlacementHeaderDiv" class="sectionDiv" style="padding: 10px 0 10px 0;">
		<table style="margin-left: 28px;">
			<tr>
				<td class="rightAligned" style="margin-left: 20px;">Policy No.</td>
				<td><input id="lineCd" name="headerField" type="text" class="required upper" style="float: left; height: 13px; width: 40px;" maxlength="2" tabindex="101"/></td>
				<td><input id="sublineCd" name="headerField" type="text" class="upper" style="float: left; height: 13px; width: 80px;" maxlength="7" tabindex="102"/></td>
				<td><input id="issCd" name="headerField" type="text" class="upper" style="float: left; height: 13px; width: 40px;" maxlength="2" tabindex="103"/></td>
				<td><input id="issueYy" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 40px;" maxlength="2" tabindex="104"/></td>
				<td><input id="polSeqNo" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 80px;" maxlength="7" tabindex="105"/></td>
				<td><input id="renewNo" name="headerField" type="text" class="upper integerNoNegativeUnformatted" style="float: left; height: 13px; width: 40px;" maxlength="2" tabindex="106"/></td>
				<td style="width: 20px; float: left; margin: 2px 10px 0 0;"><img id="searchPolicy" name="searchPolicy" alt="Go" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/></td>
				
				<td class="rightAligned">Endt. No.</td>
				<td><input id="endtIssCd" name="endtIssCd" type="text" style="float: left; height: 13px; width: 40px;" readonly="readonly" tabindex="107"/></td>
				<td><input id="endtYy" name="endtYy" type="text" style="float: left; height: 13px; width: 40px;" readonly="readonly" tabindex="108"/></td>
				<td><input id="endtSeqNo" name="endtSeqNo" type="text" style="float: left; height: 13px; width: 100px;" readonly="readonly" maxlength="13" tabindex="109"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="7"><input id="assured" name="assured" type="text" style="float: left; height: 13px; width: 380px;" readonly="readonly" tabindex="110"/></td>
				
				<td class="rightAligned">FRPS No.</td>
				<td><input id="frpsYy" name="frpsYy" type="text" style="float: left; height: 13px; width: 40px;" readonly="readonly" tabindex="111"/></td>
				<td colspan="2"><input id="frpsSeqNo" name="frpsSeqNo" type="text" style="float: left; height: 13px; width: 152px;" readonly="readonly" tabindex="112"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Effectivity Date</td>
				<td colspan="7"><input id="effDate" name="effDate" type="text" style="float: left; height: 13px; width: 132px;" readonly="readonly" tabindex="113"/></td>
				
				<td class="rightAligned">Expiry Date</td>
				<td colspan="3"><input id="expiryDate" name="expiryDate" type="text" style="float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="114"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Facul. TSI %</td>
				<td colspan="2"><input id="totFacSpct" name="totFacSpct" type="text" style="text-align: right; float: left; height: 13px; width: 132px;" readonly="readonly" tabindex="115"/></td>
				<td colspan="2" class="rightAligned">Facul. Prem %</td>
				<td colspan="3"><input id="totFacSpct2" name="totFacSpct2" type="text" style="text-align: right; float: left; height: 13px; width: 132px;" readonly="readonly" tabindex="116"/></td>
				
				<td class="rightAligned">Total TSI</td>
				<td colspan="3"><input id="tsiAmt2" name="tsiAmt2" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="117"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Facul. TSI</td>
				<td colspan="7"><input id="totFacTsi" name="totFacTsi" type="text" style="text-align: right; float: left; height: 13px; width: 380px;" readonly="readonly" tabindex="118"/></td>
				
				<td class="rightAligned">Total Prem</td>
				<td colspan="3"><input id="premAmt" name="premAmt" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="119"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Facul. Prem</td>
				<td colspan="7"><input id="totFacPrem" name="totFacPrem" type="text" style="text-align: right; float: left; height: 13px; width: 380px;" readonly="readonly" tabindex="120"/></td>
				
				<td class="rightAligned">Total Comm</td>
				<td colspan="3"><input id="faculComm" name="faculComm" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="121"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Facul. Prem VAT</td>
				<td colspan="7"><input id="faculPremVat" name="faculPremVat" type="text" style="text-align: right; float: left; height: 13px; width: 380px;" readonly="readonly" tabindex="122"/></td>
				
				<td class="rightAligned">Total Comm VAT</td>
				<td colspan="3"><input id="faculCommVat" name="faculCommVat" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="123"/></td>
			</tr>
			
			<tr>
				<td class="rightAligned">Facul. Net Due</td>
				<td colspan="7"><input id="faculNetDue" name="faculNetDue" type="text" style="text-align: right; float: left; height: 13px; width: 380px;" readonly="readonly" tabindex="124"/></td>
				
				<td class="rightAligned" style="padding-left: 8px;">Facul W/holding VAT</td>
				<td colspan="3"><input id="faculWholdingVat" name="faculWholdingVat" type="text" style="text-align: right; float: left; height: 13px; width: 204px;" readonly="readonly" tabindex="125"/></td>
			</tr>
		</table>
	</div>
	
	<div id="riPlacementDiv" class="sectionDiv" style="height: 413px; margin-bottom: 25px;">
		<div id="riPlacementTGDiv" name="riPlacementTGDiv" style="height: 322px; margin: 12px 0 40px 11px;"></div>
		
		<div id="buttonsDiv" align="center">
		    <input id="btnViewBinder" name="btnViewBinder" value="View Binder" style="width: 120px;" type="button" class="disabledButton">
		</div>
	</div>
	
</div>

<script type="text/javascript">
	try{
		riPlacementModel = {
			url: contextPath+"/",
			options: {
	          	height: '326px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objGIRIS015 = riPlacementTG.geniisysRows[y];
	          		enableButton("btnViewBinder");
	          		riPlacementTG.keys.removeFocus(riPlacementTG.keys._nCurrentFocus, true);
	          		riPlacementTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objGIRIS015 = "";
	            	disableButton("btnViewBinder");
	            	riPlacementTG.keys.removeFocus(riPlacementTG.keys._nCurrentFocus, true);
	            	riPlacementTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	riPlacementTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		riPlacementTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		riPlacementTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'binderNumber',
							title: 'Binder No.',
							width: '110px',
							filterOption: true
						},
						{	id: 'riSname',
							title: 'Reinsurer',
							width: '100px',
							filterOption: true
						},
						{	id: 'riShrPct',
							title: 'RI %',
							width: '100px',
							align: 'right',
							geniisysClass: 'rate'
						},
						{	id: 'riTsiAmt',
							title: 'RI TSI Amt',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riPremAmt',
							title: 'RI Prem Amt',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riPremVat',
							title: 'RI Prem VAT',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'premTax',
							title: 'Prem Tax',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riCommAmt',
							title: 'RI Comm Amt',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riCommVat',
							title: 'RI Comm VAT',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riWholdingVat',
							title: 'Witholding VAT',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'riCommRt',
							title: 'RI Comm Rate',
							width: '100px',
							align: 'right',
							geniisysClass: 'rate'
						},
						{	id: 'netDue',
							title: 'RI Net Due',
							width: '120px',
							align: 'right',
							geniisysClass : 'money'
						},
						{	id: 'reverseSw',
							title: 'Status',
							width: '100px',
							filterOption: true
						},
						],
			rows: []
		};
		riPlacementTG = new MyTableGrid(riPlacementModel);
		riPlacementTG.pager = [];
		riPlacementTG.render('riPlacementTGDiv');
		riPlacementTG.afterRender = function(){
			//resizeColumns();
			riPlacementTG.keys.removeFocus(riPlacementTG.keys._nCurrentFocus, true);
        	riPlacementTG.keys.releaseKeys();
        	
			if(nvl(objUW.callingForm, "") == "GIRIS016" || nvl(objUW.callingForm, "") == "GIPIS130"){
				objUW.callingForm = "";
				queryOnLoad();
			}else{
				objGIRIS015 = "";
			}
		};
	}catch(e){
		showMessageBox("Error in RI Placement Table Grid: " + e, imgMessage.ERROR);
	}
	
	function newFormInstance(){
		if(objUW.callingForm != "GIRIS016"){
			objGIRIS015 = new Object();
		}
		
		$("lineCd").focus();
		initializeAll();
		makeInputFieldUpperCase();
		hideToolbarButton("btnToolbarPrint");
		setModuleId("GIRIS015");
		setDocumentTitle("View Reinsurance Placement");
	}
	
	function resetForm(){
		$$("input[type='text']").each(function(i){
			i.value = "";
			if(i.name == "headerField"){
				enableInputField(i.id);
			}
		});
		
		enableSearch("searchPolicy");
		disableButton("btnViewBinder");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	function resizeColumns(){
		if(riPlacementTG.geniisysRows.length > 0){
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('binderNumber'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riSname'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riShrPct'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riTsiAmt'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riPremAmt'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riPremVat'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('premTax'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommAmt'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommVat'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riWholdingVat'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommRt'), "100");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('netDue'), "100");
		}else{
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('binderNumber'), "61");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riSname'), "63");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riShrPct'), "30");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riTsiAmt'), "65");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riPremAmt'), "76");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riPremVat'), "74");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('premTax'), "58");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommAmt'), "83");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommVat'), "81");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riWholdingVat'), "88");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('riCommRt'), "84");
			riPlacementTG._resizeColumn(riPlacementTG.getColumnIndex('netDue'), "63");
		}
	}
	
	function toggleToolbar(){
		if($F("lineCd") != "" || $F("sublineCd") != "" || $F("issCd") != "" || $F("issueYy") != "" ||
				$F("polSeqNo") != "" || $F("renewNo") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
		}
	}
	
	function disableFields(){
		$$("input[name='headerField']").each(function(i){
			disableInputField(i.id);
		});
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("searchPolicy");
	}
	
	function queryOnLoad(){
		vDistNo = null; //benjo 07.20.2015 UCPBGEN-SR-19626
		vDistSeqNo = null; //benjo 07.20.2015 UCPBGEN-SR-19626
		
		if(nvl(objGipis130.callSw, "") == "Y"){
			$("lineCd").value = objGipis130.lineCd;
			$("sublineCd").value = objGipis130.sublineCd;
			$("issCd").value = objGipis130.issCd;
			$("issueYy").value = objGipis130.issueYy;
			$("polSeqNo").value = objGipis130.polSeqNo;
			$("renewNo").value = objGipis130.renewNo;
			vDistNo = objCurrPolicyDS.distNo; //benjo 07.20.2015 UCPBGEN-SR-19626
			vDistSeqNo = objCurrPolicyDS.distSeqNo; //benjo 07.20.2015 UCPBGEN-SR-19626
		} else {
			$("lineCd").value = objGIRIS015.lineCd;
			$("sublineCd").value = objGIRIS015.sublineCd;
			$("issCd").value = objGIRIS015.issCd;
			$("issueYy").value = objGIRIS015.issueYy;
			$("polSeqNo").value = objGIRIS015.polSeqNo;
			$("renewNo").value = objGIRIS015.renewNo;
		}
		
		getBinder();
		executeQuery();
		if(nvl(objGipis130.callSw, "") != "Y"){ //benjo 07.20.2015 UCPBGEN-SR-19626 added condition
			enableToolbarButton("btnToolbarEnterQuery");
		}
	}
	
	function getBinder(){	
		new Ajax.Request(contextPath+"/GIRIBinderController", {
			parameters: {
				action: "getPolicyFrps",
				lineCd: $F("lineCd"),
				sublineCd: $F("sublineCd"),
				issCd: $F("issCd"),
				issueYy: $F("issueYy"),
				polSeqNo: $F("polSeqNo"),
				renewNo: $F("renewNo"),
				frpsYy: objGIRIS015.frpsYy,
				frpsSeqNo: objGIRIS015.frpsSeqNo,
				distNo: vDistNo, //benjo 07.20.2015 UCPBGEN-SR-19626
				distSeqNo: vDistSeqNo //benjo 07.20.2015 UCPBGEN-SR-19626
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					populateFields(JSON.parse(response.responseText));
				}
			}
		});
	}
	
	function executeQuery(){
		riPlacementTG.url = contextPath +"/GIRIBinderController?action=showViewRIPlacements&refresh=1&"+
				"&lineCd="+$F("lineCd")+"&frpsYy="+$F("frpsYy")+"&frpsSeqNo="+$F("frpsSeqNo");
		riPlacementTG._refreshList();
		disableFields();
	}
	
	function populateHeaderFields(row){
		$("assured").value = unescapeHTML2(row.assured);
		$("effDate").value = row == null ? "" : row.effDate == null ? "" : row.effDate;
		$("expiryDate").value = row == null ? "" : row.expiryDate == null ? "" : row.expiryDate;
		$("totFacSpct").value = formatToNthDecimal(row.totFacSpct, 5);
		$("totFacSpct2").value = formatToNthDecimal(row.totFacSpct2, 5);
		$("totFacTsi").value = formatCurrency(row.totFacTsi);
		$("totFacPrem").value = formatCurrency(row.totFacPrem);
		$("faculPremVat").value = formatCurrency(row.faculPremVat);
		$("faculNetDue").value = formatCurrency(row.faculNetDue);
		$("tsiAmt2").value = formatCurrency(row.tsiAmt2);
		$("premAmt").value = formatCurrency(row.premAmt);
		$("faculComm").value = formatCurrency(row.faculComm);
		$("faculCommVat").value = formatCurrency(row.faculCommVat);
		$("faculWholdingVat").value = formatCurrency(row.faculWholdingVat);
	}
	
	function populateFields(row){
		$("lineCd").value = unescapeHTML2(row.lineCd);
		$("sublineCd").value = unescapeHTML2(row.sublineCd);
		$("issCd").value = unescapeHTML2(row.issCd);
		$("issueYy").value = lpad(row.issueYy, 2, '0');
		$("polSeqNo").value = lpad(row.polSeqNo, 7, '0');
		$("renewNo").value = lpad(row.renewNo, 2, '0');
		
		if(nvl(row.endtSeqNo, "") != "" && parseInt(row.endtSeqNo) > 0){
			$("endtIssCd").value = row.endtIssCd;
			$("endtYy").value = lpad(row.endtYy, 2, '0');
			$("endtSeqNo").value = lpad(row.endtSeqNo, 6, '0');
		}
		$("frpsYy").value = lpad(row.frpsYy, 2, '0');
		$("frpsSeqNo").value = lpad(row.frpsSeqNo, 8, '0');
		
		$w("lineCd sublineCd issCd issueYy polSeqNo renewNo").each(function(e){
			disableInputField(e);
		});
		
		enableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("searchPolicy");
		populateHeaderFields(row);
	}
	
	function checkBinderAccess(){
		new Ajax.Request(contextPath+"/GIRIBinderController", {
			method: "GET",
			parameters: {
				action: "checkBinderAccess",
				lineCd: $F("lineCd"),
				binderYy: objGIRIS015.binderYy,
				binderSeqNo: objGIRIS015.binderSeqNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					objUW.callingForm = "GIRIS015";
					objGIRIS015.query = "Y";
					objGIRIS015.sublineCd = $F("sublineCd");
					objGIRIS015.issCd = $F("issCd");
					objGIRIS015.issueYy = $F("issueYy");
					objGIRIS015.polSeqNo = $F("polSeqNo");
					objGIRIS015.renewNo = $F("renewNo");
					objGIRIS015.frpsYy = $F("frpsYy");
					objGIRIS015.frpsSeqNo = $F("frpsSeqNo");
					showViewBinder();
				}
			}
		});
	}
	
	function showPolicyLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getPolicyFrpsLOV",
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					issCd: $F("issCd"),
					issueYy: $F("issueYy"),
					polSeqNo: $F("polSeqNo"),
					renewNo: $F("renewNo")
				},
				title: "List of Policies",
				width: 440, //405,
				height: 386,
				columnModel:[
								{	id: "policyNumber",
									title: "Policy Number",
									width: "250px", //"215px",
								},
				             	{	id: "frpsNumber",
									title: "FRPS Number",
									width: "175px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined){
						populateFields(row);
					}
				}
			});
		}catch(e){
			showErrorMessage("showPolicyLOV", e);
		}
	}
	
	$$("input[name='headerField']").each(function(i){
		i.observe("change", function(){
			toggleToolbar();
		});
	});
	
	$("issueYy").observe("change", function(){
		if($F("issueYy") != ""){
			$("issueYy").value = lpad($F("issueYy"), 2, '0');
		}
	});
	
	$("polSeqNo").observe("change", function(){
		if($F("polSeqNo") != ""){
			$("polSeqNo").value = lpad($F("polSeqNo"), 7, '0');
		}
	});
	
	$("renewNo").observe("change", function(){
		if($F("renewNo") != ""){
			$("renewNo").value = lpad($F("renewNo"), 2, '0');
		}
	});
	
	$("searchPolicy").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("riPlacementHeaderDiv")){
			showPolicyLOV();
		}
	});
	
	$("btnViewBinder").observe("click", function(){
		checkBinderAccess();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		riPlacementTG.url = contextPath +"/GIRIBinderController?action=showViewRIPlacements&refresh=1&";
		riPlacementTG._refreshList();
		resetForm();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(nvl(objGipis130.callSw, "") == "Y"){ // Added by J. Diago 10.08.2013 : Kapag po may ibang kaganapang naganap na hindi inaasahan, naway ipagbigay alam lamang po sa akin.
			if(nvl(objGIPIS100.callSw, "") == "Y"){ //benjo 07.21.2015 UCPBGEN-SR-19626 added condition
				showViewDistributionStatus("GIPIS100", objGIPIS100.policyId);
			} else {
				objGipis130.withQuery = "Y";
				showViewDistributionStatus2();	
			}
		} else {
			delete objGIRIS015;
			objUW.callingForm = "";
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}
	});
	
	newFormInstance();
	resetForm();
</script>
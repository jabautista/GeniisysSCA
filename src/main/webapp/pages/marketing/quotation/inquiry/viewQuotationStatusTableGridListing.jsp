<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="marketingDiv">
	<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>View Quotation Status</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="hideForm" name="gro" style="margin-left: 5px;">Hide</label>
   					<label id="reloadForm" name="gro">Reload Form</label>
   				</span>
				<input type="hidden" id="quoteId" name="quoteId"/> 
				<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			</div>
	</div>
	<div id="quotationTableGridListingDiv" class="sectionDiv" style="height: 370px;">
		<div id="quotationTableGridDiv" style= "padding: 10px; ">
			<div id="quotationTableGridListing" style="height: 320px; width: 900px;"></div>
		</div>
	</div>
	<div id="frpsTableDetailsDiv" name="frpsTableDetailsDiv" class="sectionDiv" style="margin-top: 1px; margin-bottom: 50px; padding-bottom: 10px;">
		<table style="margin: auto; margin-top: 10px; margin-bottom: 10px;" border="0">
			<tr>
				<td width="130" class="rightAligned">Quotation No.</td>
				<td class="leftAligned" colspan="5">
					<input style="width: 500px;" type="text" id="quotationNo" name="quotationNo" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Quote Assured</td>
				<td class="leftAligned" colspan="5">
					<input style="width: 500px;" type="text" id="quoteAssured" name="quoteAssured" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">PAR Assured</td>
				<td class="leftAligned" colspan="5">
					<input style="width: 500px;" type="text" id="parAssured" name="parAssured" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Reason for Denial</td>
				<td class="leftAligned" colspan="5">
					<input style="width: 500px;" type="text" id="reasonForDenial" name="reasonForDenial" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">PAR No.</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: left;" type="text" id="parNo" name="parNo" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Policy No.</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="policyNo" name="policyNo" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Inception Date</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: left;" type="text" id="inceptDate" name="inceptDate" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Expiry Date</td>
					<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="expiryDate" name="expiryDate" value="" readonly="readonly"/>
				</td>
		   </tr>
		   <tr id="packQuoteNoRow" style="display:none;">
		   		<td class="rightAligned">Package Quotation No.</td>
				<td class="R" colspan="5">
					<input style="width: 500px;" type="text" id="packQuoteNo" name="packQuoteNo" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr id="showQuotationStatRow">
			   <td class="leftAligned" colspan="6" align="center" style="padding-top: 60px;">
			   </td>
		   </tr>
		   <tr>
			   <td class="leftAligned" colspan="6" align="center">
				   <center>
				   		<input id="btnShowQuotationStat" class="button hover" type="button" value="Quotation Information" style="width: 150px; position: static;" name="btnShowQuotationStat">
				   </center>
			   </td>
		   </tr>
		</table>
	</div>
</div>

<script type="text/javascript"> //Rey
	setModuleId("GIIMM004");
	setDocumentTitle("View Quotation Status"); //steven 3.7.2012
	$("home").hide();
	$("marketingMainMenu").hide();
	$("quotationProcessing").hide();
	$("reassignMenu").show();
	initializeMenu();
	$("quoteId").value = "0";  //added by steven 12/10/2012
	function quoteStatusTableGridList(){ //FOR reloadForm purposes
		try{
			var quotationStatus= new Object();
			quotationStatus.quotationStatusTableGrid = JSON.parse('${gipiQuotationStatus}'.replace(/\\/g,'\\\\'));
			quotationStatus.quotationStatus = quotationStatus.quotationStatusTableGrid.rows || [];
			//
			var quotationTableModel={
					url: contextPath+"/GIPIQuotationController?action=refreshQuotationListing2&moduleId=GIIMM004&lineCd="+encodeURIComponent($F("lineCd")),
					options: {
						title: '',
						width: '900px',
						onCellFocus: function(element, value, x, y, id){
							var obj = quotationTableGridListing.geniisysRows[y];
							$("quoteId").value = obj.quoteId; //steven 3.6.2012
							populateQuotationDetails(obj);
							if (obj.packQuoteNo==null){
								 $("packQuoteNoRow").hide(); 
								 resetQuotationStatRow();
							}else{
								 $("packQuoteNoRow").show();
								 arrangeQuotationStatRow(); //steven 3.7.2012
							}
							
						/* 	selectedQuoteListingIndex2 = y;
							objGIPIQuote.quoteId = quotationTableGridListing.geniisysRows[y].quoteId;
							observeChangeTagInTableGrid(quotationTableGridListing); */
						/* },
						onCellBlur: function(){
							observeChangeTagInTableGrid(quotationTableGridListing);			  			
					  	*/},
					  	prePager: function(){
					  		clearQuotationFields();
					  	},
						onRemoveRowFocus: function (element, value, x, y, id){
							populateQuotationDetails(null);
							resetQuotationStatRow();//steven 3.7.2012
							$("quoteId").value = "0";
							$("packQuoteNoRow").hide(); //steven 3.6.2012
						},
						onRowDoubleClick: function(y){
							var row = quotationTableGridListing.geniisysRows[y];
							/* quotationStatus.lineCd = row.lineCd; */
							quotationStatus.quoteId = row.quoteId;
							/*objRiFrps.frpsSeqNo = row.frpsSeqNo; */
							
							quotationTableGridListing.keys.removeFocus(quotationTableGridListing.keys._nCurrentFocus, true);
							quotationTableGridListing.keys.releaseKeys();
							//showCreateRiPlacementPage(); 
							isMakeQuotationInformationFormsHidden = 1;
							//$("quoteId").value = ($$("div#quotationTableGridListing .selectedRow"))[0].getAttribute("quoteId");
							$("quoteId").value = quotationStatus.quoteId;
							//showQuotationInformation2();  //marco - 10.29.2012 - replaced with code below (GIIMM005 calling function)
							showQuotationStatus();
						},
						toolbar:{
							elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
							onRefresh: function(){
								clearQuotationFields();
							},
							onFilter: function(){
								var filter = quotationTableGridListing.objFilter;
								if(filter.fromDate != null && filter.toDate != null){
									if(filter.fromDate > filter.toDate){
										showMessageBox("To date should not be earlier than from date.", imgMessage.ERROR);
									}
								}
								clearQuotationFields();
							}
						},
						onSort: function(){
							clearQuotationFields();
						}	
					},		
					columnModel: [
					          	{   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{	id: 'quoteNo',
									title: 'Quotation No.',
									titleAlign: 'center',
									width: '230px',
									sortable: true
								},
								{	id: 'assdName',
									title: 'Assured Name',
									titleAlign: 'center',
									width: '250px',
									sortable: true
								},
								{	id: 'acceptDate',
									title: 'Date Created', //Steven 3.6.2012
									titleAlign: 'center',
									align: 'center',
									width: '150px',
									sortable: true,
									type: 'date'
								},
								{	id: 'fromDate',
									title: 'From',
									width: '0',
									filterOption: true,
									filterOptionType: "formattedDate",
									visible: false
								},
								{	id: 'toDate',
									title: 'To',
									width: '0',
									filterOption: true,
									filterOptionType: "formattedDate",
									visible: false
								},
								{	id: 'inceptDate',
									title: 'Incept Date',
									width: '0',
									filterOption: true,
									filterOptionType: "formattedDate",
									visible: false
								},
								{	id: 'expiryDate',
									title: 'Expiry Date',
									width: '0',
									filterOption: true,
									filterOptionType: "formattedDate",
									visible: false
								},
								{	id: 'sublineCd',
									title: 'Subline Code',
									width: '0',
									filterOption: true,
									visible: false
								},
								{	id: 'issCd',
									title: 'Iss Code',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: true,
									visible: false
								},
								{	id: 'quotationYy',
									title: 'Quotation Year',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: true,
									visible: false
								},
								{	id: 'quoteNo',
									title: 'Quote No.',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: true,
									visible: false
								},
								{	id: 'proposalNo',
									title: 'Proposal No.',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: true,
									visible: false
								},
								{	id: 'assdName',
									title: 'Quote Assured',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: true,
									visible: false
								},
								{	id: 'quotationNo',
									title: 'Quotation No.',
									titleAlign: 'center',
									align: 'center',
									width: '0',
									sortable: true,
									filterOption: false,
									visible: false
								},
								{	id: 'userId',
									title: 'User Id',
									titleAlign: 'center',
									width: '100px',
									filterOption: true,
									sortable: true
								},
								{	id: 'status',
									title: 'Status',
									titleAlign: 'center',
									width: '120px',
									sortable: true,
									filterOption: true
								},
								{	id: 'packPolFlag',
									title: '',
									width: '0px',
									visible: false
								},
								{	id: 'packQuoteId',
									title: '',
									width: '0px',
									visible: false
								},
								{	id: 'packQuoteNo',
									title: '',
									width: '0px',
									visible: false
								}
					              ],
					rows: quotationStatus.quotationStatus          
			};
			quotationTableGridListing = new MyTableGrid(quotationTableModel);
			quotationTableGridListing.pager = quotationStatus.quotationStatusTableGrid;
			quotationTableGridListing.render('quotationTableGridListing');
		}catch(e){
			showErrormessage("viewQuotationStatusTableGridList.jsp",e);
		}
	}
	
	quoteStatusTableGridList();
	$("btnShowQuotationStat").observe("click", function() { 
		//$("quoteId").value = quotationTableGridListing.geniisysRows[0].quoteId;
		//showQuotationInformation2(); //marco - 10.29.2012 - replaced with code below (GIIMM005 calling function)
		quotationTableGridListing.keys.releaseKeys();
		if ($F("quoteId") == "0") { //added by steven 12/10/2012
			showMessageBox("There is no quotation selected.",imgMessage.INFO);
		}else{
			showQuotationStatus();
		}
	});
		
	$("hideForm").observe("click", function (){
		if ($("hideForm").innerHTML == "Show")  {
			$("quotationTableGridListingDiv").show();
			$("frpsTableDetailsDiv").show();
			$("hideForm").innerHTML = "Hide";
		}else{
			$("hideForm").innerHTML = "Show";
			$("quotationTableGridListingDiv").hide();
			$("frpsTableDetailsDiv").hide();
		}
	});
	
	$("reloadForm").observe("click", function(){
		quotationTableGridListing.keys.removeFocus(quotationTableGridListing.keys._nCurrentFocus, true);
		quotationTableGridListing.keys.releaseKeys();
		$("packQuoteNoRow").hide();
		resetQuotationStatRow();//steven 3.7.2012
		quoteStatusTableGridList();
		clearQuotationFields();
	});
	
	$("mtgBtnAddFilter1").observe("click", function(){
		if($("mtgFilterBy1").value == 'proposalNo'){
			if(validateFilterInput()){
				showMessageBox("Proposal No. must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}else if($("mtgFilterBy1").value == 'quotationYy'){
			if(validateFilterInput()){
				showMessageBox(	"Quotation Year must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}else if($("mtgFilterBy1").value == 'quoteNo'){
			if(validateFilterInput()){
				showMessageBox("Quote No. must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}
	});

	$("mtgKeyword1").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			if($("mtgFilterBy1").value == 'proposalNo'){
				if(validateFilterInput()){
					showMessageBox("Proposal No. must be a non-negative integer.", imgMessage.ERROR);
					$("mtgKeyword1").value = '';
				}
			}else if($("mtgFilterBy1").value == 'quotationYy'){
				if(validateFilterInput()){
					showMessageBox("Quotation Year must be a non-negative integer.", imgMessage.ERROR);
					$("mtgKeyword1").value = '';
				}
			}else if($("mtgFilterBy1").value == 'quoteNo'){
				if(validateFilterInput()){
					showMessageBox("Quote No. must be a non-negative integer.", imgMessage.ERROR);
					$("mtgKeyword1").value = '';
				}
			}
		}
	});
	
	
	$("mtgBtnOkFilter1").observe("click", function(){
		if($("mtgFilterBy1").value == 'proposalNo'){
			if(validateFilterInput()){
				showMessageBox("Proposal No. must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}else if($("mtgFilterBy1").value == 'quotationYy'){
			if(validateFilterInput()){
				showMessageBox("Quotation Year must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}else if($("mtgFilterBy1").value == 'quoteNo'){
			if(validateFilterInput()){
				showMessageBox("Quote No. must be a non-negative integer.", imgMessage.ERROR);
				$("mtgKeyword1").value = '';
			}
		}
	});
	
	function validateFilterInput(){
		if($F("mtgKeyword1") < 0 || isNaN($F("mtgKeyword1")) || checkDecimal()){
			return true;
		}
		return false;
	}
	
	function checkDecimal(){
		for(i = 0; i < $("mtgKeyword1").value.length; i++){
			if ($("mtgKeyword1").value.charAt(i)=='.'){
				  return true;
			}
		}
		return false;
	}
	
	//marco - 10.29.2012 - GIIMM005(View Quotation Information)
	function showQuotationStatus(){
		var quoteId = nvl($F("quoteId"), "") == "" ? objGIPIQuote.quoteId : $F("quoteId");
		
		new Ajax.Updater("mainContents", contextPath + "/GIPIQuoteController?action=showViewQuotationStatusPage", {
			method : "GET",
			parameters : {
				quoteId : quoteId,
				lineCd  : getLineCdMarketing()
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function(){ 
				showNotice("Getting quotation information, please wait...");
				resetQuoteInfoGlobals();
			},
			onComplete : function(){
				hideNotice("");
				Effect.Appear("quotationInformationMainDiv", {
					duration : .001
				});
				hideNotice("");
				setModuleId("GIIMM005");
				setDocumentTitle("View Quotation Information");
				//$("quotationMenus").show();					
				//$("marketingMainMenu").hide();
				$("quoteListingMainDiv").hide();
				$("quoteInfoDiv").show();
				initializeMenu();
				addStyleToInputs();
				initializeAll();
			}
		});
	}
	objQuoteGlobal.showQuotationStatus = showQuotationStatus;

</script>
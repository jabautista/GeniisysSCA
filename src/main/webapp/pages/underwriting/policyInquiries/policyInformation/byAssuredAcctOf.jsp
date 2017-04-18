<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewByAssuredAcctOfMainDiv" name="viewByAssuredAcctOfMainDiv" style="border: none;" class="sectionDiv">

	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="sectionDiv" style="margin: auto;">
		<%-- <div style="margin:10px 5px 5px auto;">
			<div style="width:98%;margin-left:2%;">
				Assured Name:
				<input type="text" id="txtAssdNo" name="txtAssdNo" style="width:50px;" readonly="readonly"/>
				<input type="text" id="txtAssdName" name="txtAssdName" style="width:700px;" readonly="readonly"/>
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForAssured" name="searchForAssured" alt="Go" style="margin-top: 2px;" title="Search Assured"/>
			</div>
		</div> --%>
		
		<div id="policyByAssuredAcctOfDiv" class="sectionDiv" style="border: none; height:314px;width:856px; padding: 10px; margin: auto; margin-bottom: 10px;"></div>
		
		<div class="sectionDiv" style="border: none; text-align:center; margin: auto; padding: 10px;">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/>
			<input type="button" class="button" id="btnPolEndtDetails" name="btnPolEndtDetails" value="Policy/Endorsement Details"/>
		</div>
	</div>
	
</div>

<script>
$("parExit").observe("click",showViewPolicyInformationPage);
	/* getPolicyByAssuredTable();
	
	
	$("searchForAssured").observe("click", function(){
		overlayAssuredList = Overlay.show(contextPath+"/GIPIPolbasicController", {
			urlContent: true,
			urlParameters: {action : "showPolicyAssuredOverLay"},
			title: "Assured",
			width: 416,
			height: 400,
			draggable: true
		});
	}); */
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	
	var rowIndex = -1;
	
	try{
		var policyByAssuredActOf = new Object();
		policyByAssuredActOf.policyByAssuredActOfTableGrid = JSON.parse('${policyByAssureActOf}'.replace(/\\/g,'\\\\'));
		policyByAssuredActOf.policyByAssuredActOf = policyByAssuredActOf.policyByAssuredActOfTableGrid || [];
		
		var polByAssrdAcctOfTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showByAssuredAcctOfPage&refresh=1",
				options: {
					hideColumnChildTitle: true,
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						//var obj = byAssuredAcctOf.geniisysRows[params];
						byAssuredAcctOf.keys.removeFocus(byAssuredAcctOf.keys._nCurrentFocus, true);
						byAssuredAcctOf.keys.releaseKeys();
						enableButton("btnSummarizedInfo");
						enableButton("btnPolEndtDetails");						
						rowIndex = y;
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						byAssuredAcctOf.keys.removeFocus(byAssuredAcctOf.keys._nCurrentFocus, true);
						byAssuredAcctOf.keys.releaseKeys();
						disableButton("btnSummarizedInfo");
						disableButton("btnPolEndtDetails");
						rowIndex = -1;
					},
					onRowDoubleClick: function(params){
						var row = byAssuredAcctOf.geniisysRows[params];
						getPolicyEndtSeq0(row.policyId);
					
					},
					toolbar: { //benjo 01.04.2016 GENQA-SR-4936
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							byAssuredAcctOf.onRemoveRowFocus();
						},
						onFilter: function(){
							byAssuredAcctOf.onRemoveRowFocus();
						}
					}
				},
				columnModel: [
								{   id: 'recordStatus',							    
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{	id: 'assdName',
									title: 'Assured Name',									
									width: '250px',
									filterOption: true //benjo 01.04.2016 GENQA-SR-4936
								},
								{	id: 'assdName2',
									title: 'In Account Of',
									width: '200px',
									filterOption: true //benjo 01.04.2016 GENQA-SR-4936
								},
								{	id: 'policyNo',
									title: 'Policy No.',
									titleAlign: 'center',
									width: '250px',
									filterOption: true //benjo 01.04.2016 GENQA-SR-4936
								},
								{	id: 'endtNo',
									title:'Endorsement No.',
									titleAlign: 'center',
									width: '186px',
									filterOption: true //benjo 01.04.2016 GENQA-SR-4936
								}
								
				              ],
				             	rows: policyByAssuredActOf.policyByAssuredActOfTableGrid.rows
		};
			byAssuredAcctOf = new MyTableGrid(polByAssrdAcctOfTableModel);
			byAssuredAcctOf.pager = policyByAssuredActOf.policyByAssuredActOfTableGrid;
			byAssuredAcctOf.render('policyByAssuredAcctOfDiv');
			byAssuredAcctOf.afterRender = function(){
				disableButton("btnSummarizedInfo");
				disableButton("btnPolEndtDetails");
				byAssuredAcctOf.keys.removeFocus(byAssuredAcctOf.keys._nCurrentFocus, true);
				byAssuredAcctOf.keys.releaseKeys();
				rowIndex = -1;
			};
		
	}
	catch(e){
		showErrorMessage("byAssuredAcctOf.jsp",e);
	}
	
	$("btnSummarizedInfo").observe("click", function () {
		if((byAssuredAcctOf.getCurrentPosition()[1])>0){
			getPolicyEndtSeq0(byAssuredAcctOf.geniisysRows[byAssuredAcctOf.getCurrentPosition()[1]].policyId);
		}
	});
	
	$("btnPolEndtDetails").observe("click", function () {
		var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv";
		objGIPIS100.policyId = byAssuredAcctOf.geniisysRows[rowIndex].policyId;
		objGIPIS100.prevDocumentTitle = "Policies by Assured in Account Of";
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "showPolicyMainInfo",
		    	policyId : 	objGIPIS100.policyId
		    },
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$(div).update(response.responseText);
					}
				} catch(e){
					showErrorMessage("btnPolEndtDetails", e);
				}								
			} 
		});		
	});
</script>
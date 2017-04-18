<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="height: 455px; width: 835px; margin: 10px 0 12px 0;">
	<div id="lineDetailsMainDiv" name="lineDetailsMainDiv" style="height: 445px; width: 815px; margin: 0 0 10px 10px; overflow: auto;">
		<div id="lineHeaderLabelDiv" name="lineHeaderLabelDiv" style="float: left;">
			<table style="margin: 10px 0 0 370px;">
				<tr>
					<td><label id="lineCededLbl" style="width: 100%; text-align: center;"></label></td>
					<td style="padding-right: 120px;"></td>
					<td><label id="lineInwLbl" style="width: 100%; text-align: center;"></label></td>
					<td><label id="lineRetLbl" style="width: 100%; text-align: center;"></label></td>
				</tr>
				<tr>
					<td>--------------------------------------------------------------------------</td>
					<td style="padding-right: 120px;"></td>
					<td>-------------------------------------------------------------------------</td>
					<td style="padding-left: 8px;">------------------------------------------------------------------------</td>
				</tr>
				<tr>
					<td><label style="font-size: 10px; padding-left: 190px;">Unauthorized Companies</label></td>
					<td style="padding-right: 120px;"></td>
					<td><label style="font-size: 10px; padding-left: 190px;"">Unauthorized Companies</label></td>
					<td><label style="font-size: 10px; padding-left: 198px;"">Unauthorized Companies</label></td>
				</tr>
			</table>
		</div>
		<div id="lineDetailTGDiv" name="lineDetailTGDiv" style="height: 304px; padding: 5px 0 0 0; margin-right: 15px; float: left;">
		
		</div>
		<div id="lineTotalsDiv" name="lineTotalsDiv" style="float: left; margin: 32px 0 0 252px;">
			<table>
				<tr>
					<td><input id="directAmtTotal" name="directAmtTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="301"></td>
					<td><input id="directAuthTotal" name="directAuthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="302"></td>
					<td><input id="directAseanTotal" name="directAseanTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="303"></td>
					<td><input id="directOthTotal" name="directOthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="304"></td>
					<td><input id="directNetTotal" name="directNetTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="305"></td>
					<td><input id="inwAuthTotal" name="inwAuthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="306"></td>
					<td><input id="inwAseanTotal" name="inwAseanTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="307"></td>
					<td><input id="inwOthTotal" name="inwOthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="308"></td>
					<td><input id="retAuthTotal" name="retAuthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="309"></td>
					<td><input id="retAseanTotal" name="retAseanTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="310"></td>
					<td><input id="retOthTotal" name="retOthTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="311"></td>
					<td><input id="netWrittenTotal" name="netWrittenTotal" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="312"></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div align="center">
	<input id="btnPrintLineDetails" name="btnPrintLineDetails" type="button" class="button" value="Print" style="width: 85px;" tabindex="313"/>
	<input id="btnLineReturn" name="btnLineReturn" type="button" class="button" value="Return" style="width: 85px;" tabindex="314"/>
</div>

<script type="text/javascript">
	objRecaps.lineDetailsTableGrid = JSON.parse('${lineDetailsJSON}');
	objRecaps.lineDetailsRows = objRecaps.lineDetailsTableGrid.rows || [];
	
	try{
		lineDetailsTableModel = {
			url: contextPath+"/GIACRecapDtlExtController?action=showLineDetails&refresh=1&type="+objRecaps.type+
					"&line="+objRecaps.selectedRow,
			id: "126",
			options: {
	          	height: '306px',
	          	width: '1732px',
	          	onCellFocus: function(element, value, x, y, id){
	          		lineDetailsTableGrid.keys.removeFocus(lineDetailsTableGrid.keys._nCurrentFocus, true);
	          		lineDetailsTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	lineDetailsTableGrid.keys.removeFocus(lineDetailsTableGrid.keys._nCurrentFocus, true);
	          		lineDetailsTableGrid.keys.releaseKeys();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
						{	id: 'rowTitle',
							title: objRecaps.rowTitle,
							width: '248px',
							filterOption: true
						},
						{	id: 'directAmt',
							title: objRecaps.directAmtLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directNet',
							title: objRecaps.directNetLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'netWritten',
							title: objRecaps.netWrittenLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						}
						],  				
			rows: objRecaps.lineDetailsRows
		};
		lineDetailsTableGrid = new MyTableGrid(lineDetailsTableModel);
		lineDetailsTableGrid.pager = objRecaps.lineDetailsTableGrid;
		lineDetailsTableGrid.render('lineDetailTGDiv');
		lineDetailsTableGrid.afterRender = function(){
			lineDetailsTableGrid.onRemoveRowFocus();
			if(lineDetailsTableGrid.geniisysRows.length > 0){
				populateLineTotals(true);
			}else{
				populateLineTotals(false);
			}
		};
	}catch(e){
		showMessageBox("Error in Recap Line Details Table Grid: " + e, imgMessage.ERROR);
	}
	
	function setLineHeaderLabels(){
		$("lineCededLbl").innerHTML = objRecaps.cededLbl;
		$("lineInwLbl").innerHTML = objRecaps.inwLbl;
		$("lineRetLbl").innerHTML = objRecaps.retLbl;
	}
	
	function populateLineTotals(populate){
		if(populate){
			var row = lineDetailsTableGrid.geniisysRows[0];
			$("directAmtTotal").value = formatCurrency(row.directAmtTotal);
			$("directAuthTotal").value = formatCurrency(row.directAuthTotal);
			$("directAseanTotal").value = formatCurrency(row.directAseanTotal);
			$("directOthTotal").value = formatCurrency(row.directOthTotal);
			$("directNetTotal").value = formatCurrency(row.directNetTotal);
			$("inwAuthTotal").value = formatCurrency(row.inwAuthTotal);
			$("inwAseanTotal").value = formatCurrency(row.inwAseanTotal);
			$("inwOthTotal").value = formatCurrency(row.inwOthTotal);
			$("retAuthTotal").value = formatCurrency(row.retAuthTotal);
			$("retAseanTotal").value = formatCurrency(row.retAseanTotal);
			$("retOthTotal").value = formatCurrency(row.retOthTotal);
			$("netWrittenTotal").value = formatCurrency(row.netWrittenTotal);
		}else{
			$$('div#lineTotalsDiv input').each(function(i){
				$(i).value = "0.00";
			});
		}
	}
	
	function printLineDetails(){
		var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
		var date = $F("toDate").substring(6);
		var content = contextPath+"/GeneralLedgerPrintController?action=printReport&reportType="+objRecaps.getReportType()+
						"&rowTitle="+objRecaps.selectedRow+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+
						$F("selDestination")+"&fileType="+fileType+"&reportId=GIACR290A"+"&date="+date;

		if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "E");
		}else{
			printGenericReport(content, "RECAP SUMMARY DETAIL");
		}
	}
	
	$("btnPrintLineDetails").observe("click", function(){
		var title = "Print Detail for Line of Business: " + objRecaps.selectedRow;
		
		lineDetailsTableGrid.keys.removeFocus(lineDetailsTableGrid.keys._nCurrentFocus, true);
     	lineDetailsTableGrid.keys.releaseKeys();
		showGenericPrintDialog(title, printLineDetails, function(){
			$("txtNoOfCopies").writeAttribute("maxlength", "3");
		}, true);
	});
	
	$("btnLineReturn").observe("click", function(){
		lineDetailsOverlay.close();
		delete lineDetailsOverlay;
	});
	
	$("directAmtTotal").focus();
	setLineHeaderLabels();
</script>
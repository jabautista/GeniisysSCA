<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="gbdsdLOVDiv" style="margin: 20px;">
	<form id="selectGbdsdLOVForm" name="selectGbdsdLOVForm">
		<div id="gbdsdListDiv">
			<div id="gbdsdTableHeader" class="tableHeader" align="center"">
				<label style="text-align: left; width: 40px; margin-left: 5px; text-align: center">A</label>
				<label style="text-align: left; width: 120px; margin-left: 5px; text-align: center">Check No.</label>
				<label style="text-align: left; width: 100px; margin-left: 5px; text-align: center">OR No.</label>
				<label style="text-align: left; width: 150px; margin-left: 5px; text-align: center">Local Currency Amt</label>
				<label style="text-align: left; width: 40px; margin-left:  5px; text-align: center">C</label>
				<label style="text-align: left; width: 150px; margin-left: 5px; text-align: center">Foreign Currency Amt</label>
				<label style="text-align: left; width: 130px; margin-left: 5px; text-align: center">Currency Rate</label>
			</div>
			<div id="gbdsdTableDiv" name="gbdsdTableDiv" style="min-height: 200px; max-height: 240px;" class="tableContainer"></div>
		</div>
	</form>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;">
		<input id="btnSelectGbdsd" name="btnSelectGbdsd" class="button" value="Ok" />
	</div>
</div>

<script type="text/javascript">
	var gbdsdObjArr = JSON.parse('${gbdsdList}'.replace(/\\/g, '\\\\'));
	var exists;
	var depNo = '${depNo }';
		
	for(var i=0; i<gbdsdObjArr.length; i++) {
		exists = false;
		$$("div[name='gbdsdRow']").each(function(row) {
			if(row.down("input", 0).value == gbdsdObjArr[i].dspCheckNo
					&& row.down("input", 1).value == gbdsdObjArr[i].dspOrPrefSuf) {
				exists = true;
			}
		});	
		if(!exists) {
			if (!gbdsdRowExists(gbdsdObjArr[i])) {
				var content = prepareGbdsdList(gbdsdObjArr[i]);
				
				var newRow = new Element("div");
				newRow.setAttribute("id", "gbdsdRow"+i);
				newRow.setAttribute("name", "gbdsdRow");
				newRow.addClassName("tableRow");
				newRow.setStyle({fontSize: '10px'});	
		
				newRow.update(content);
				$("gbdsdTableDiv").insert({bottom : newRow});	
		
				checkIfToResizeTable("gbdsdTableDiv", "gbdsdRow");
				checkTableIfEmpty("gbdsdRow", "gbdsdListDiv");
			}
		}
	}

	function prepareGbdsdList(obj) {
		try {
			var content = '<input type="hidden" id="hidGaccTranId'+obj.gaccTranId+'" name="hidGaccTranId" value="'+obj.gaccTranId+'" />'
						+'<input type="hidden" id="hidPayor'+obj.dspCheckNo+'" name="hidPayor" value="'+obj.payor+'" />'
						+'<input type="hidden" id="hidORNo'+obj.orNo+'" name="hidORNo" value="'+obj.orNo+'" />'
						+'<input type="hidden" id="hidORPrefSuf'+obj.orPrefSuf+'" name="hidORPrefSuf" value="'+obj.orPrefSuf+'" />'
						+'<input type="hidden" id="hidDCBNo'+obj.dcbNo+'" name="hidDCBNo" value="'+obj.dcbNo+'" />'
						+'<input type="hidden" id="hidCheckNo'+obj.checkNo+'" name="hidCheckNo" value="'+obj.checkNo+'" />'
						+'<input type="hidden" id="hidItemNo'+obj.itemNo+'" name="hidItemNo" value="'+obj.itemNo+'" />'
						+'<input type="hidden" id="hidAmount'+obj.amount+'" name="hidAmount" value="'+obj.amount+'" />'
						+'<input type="hidden" id="hidFcurrencyAmt'+obj.fcurrencyAmt+'" name="hidFcurrencyAmt" value="'+obj.fcurrencyAmt+'" />'
						+'<input type="hidden" id="hidCurrencyRt'+obj.currencyRt+'" name="hidCurrencyRt" value="'+obj.currencyRt+'" />'
						+'<input type="hidden" id="hidBankCd'+obj.bankCd+'" name="hidBankCd" value="'+obj.bankCd+'" />'
						+'<input type="hidden" id="hidBankSname'+obj.bankSname+'" name="hidBankSname" value="'+obj.bankSname+'" />'
						+'<input type="hidden" id="hidShortName'+obj.shortName+'" name="hidShortName" value="'+obj.shortName+'" />'
						+'<input type="hidden" id="hidMainCurrencyCd'+obj.mainCurrencyCd+'" name="hidMainCurrencyCd" value="'+obj.mainCurrencyCd+'" />'
						+'<input type="hidden" id="hidDspCheckNo'+obj.dspCheckNo+'" name="hidDspCheckNo" value="'+obj.dspCheckNo+'" />'
						+'<input type="hidden" id="hidDspOrPrefSuf'+obj.dspOrPrefSuf+'" name="hidDspOrPrefSuf" value="'+obj.dspOrPrefSuf+'" />'
						+'<label style="text-align: left; width:  40px; margin-left: 5px; text-align: center"><input type="checkbox" id="gdbdChecked" name="gdbdChecked"/></label>'
						+'<label style="text-align: left; width: 120px; margin-left: 5px; text-align: center">'+obj.dspCheckNo+'</label>'
						+'<label style="text-align: left; width: 100px; margin-left: 5px; text-align: center">'+obj.dspOrPrefSuf+'</label>'
						+'<label style="text-align: left; width: 150px; margin-left: 5px; text-align: center">'+obj.amount+'</label>'
						+'<label style="text-align: left; width:  40px; margin-left: 5px; text-align: center">'+obj.shortName+'</label>'
						+'<label style="text-align: left; width: 150px; margin-left: 5px; text-align: center">'+obj.fcurrencyAmt+'</label>'
						+'<label style="text-align: left; width: 130px; margin-left: 5px; text-align: center">'+obj.currencyRt+'</label>';
			return content;
		} catch(e) {
			showErrorMessage("prepareGbdsdList", e);
		}
	}

	$$("div[name='gbdsdRow']").each(function(row) {
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});

		row.observe("click", function() {
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")) {
				$$("div[name='gbdsdRow']").each(function(r) {
					if(row.getAttribute("id") != r.getAttribute("id")) {
						r.removeClassName("selectedRow");
					}
				});
			}
		});
		
	});

	function loadSelectedGbdsd() {
		try {
			var coords = gbdsdListTableGrid.getCurrentPosition();

			$$("div[name='gbdsdRow']").each(function(row) {
				if(row.down("label", 0).down("input", 0).checked) {
					gbdsdListTableGrid.addNewRow();
					
					var index = -gbdsdListTableGrid.newRowsAdded.length;

					gbdsdListTableGrid.setValueAt(depNo, gbdsdListTableGrid.getColumnIndex('depNo'), index);
					if (objACModalboxParams.otcRows != null) {
						if (objACModalboxParams.otcRows.length > 0) {
							gbdsdListTableGrid.setValueAt(objACModalboxParams.otcRows[0]['localSur'], gbdsdListTableGrid.getColumnIndex('localSur'), index);
							gbdsdListTableGrid.setValueAt(objACModalboxParams.otcRows[0]['foreignSur'], gbdsdListTableGrid.getColumnIndex('foreignSur'), index);
							gbdsdListTableGrid.setValueAt(objACModalboxParams.otcRows[0]['netCollnAmt'], gbdsdListTableGrid.getColumnIndex('netCollnAmt'), index);
						} else {
							gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('localSur'), index);
							gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('foreignSur'), index);
							gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('netCollnAmt'), index);
						}
					} else {
						gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('localSur'), index);
						gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('foreignSur'), index);
						gbdsdListTableGrid.setValueAt(null, gbdsdListTableGrid.getColumnIndex('netCollnAmt'), index);
					}
					
					/** GBDSD pre-insert */
					
					gbdsdListTableGrid.setValueAt(row.down("input", 5).value, gbdsdListTableGrid.getColumnIndex('checkNo'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 14).value, gbdsdListTableGrid.getColumnIndex('dspCheckNo'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 1).value, gbdsdListTableGrid.getColumnIndex('payor'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 2).value, gbdsdListTableGrid.getColumnIndex('orNo'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 7).value, gbdsdListTableGrid.getColumnIndex('amount'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 12).value, gbdsdListTableGrid.getColumnIndex('currencyShortName'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 8).value, gbdsdListTableGrid.getColumnIndex('foreignCurrAmt'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 9).value, gbdsdListTableGrid.getColumnIndex('currencyRt'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 13).value, gbdsdListTableGrid.getColumnIndex('currencyCd'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 10).value, gbdsdListTableGrid.getColumnIndex('bankCd'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 3).value, gbdsdListTableGrid.getColumnIndex('orPref'), index);
					gbdsdListTableGrid.setValueAt(row.down("input", 15).value, gbdsdListTableGrid.getColumnIndex('dspOrPrefSuf'), index);
					/** end of GBDSD pre-insert */
					
					//gbdsdListTableGrid.setValueAt(row.down("input", 0).value, gbdsdListTableGrid.getColumnIndex('checkNo'), coords[1]);
				}
			});
			
			hideOverlay();
		} catch(e) {
			showErrorMessage("loadSelectedGbdsd", e);
		}
	}

	function gbdsdRowExists(obj) {
		var exists = false;
		
		for (var i = 0; i < gbdsdListTableGrid.rows.length; i++) {
			if (obj.dspCheckNo == gbdsdListTableGrid.rows[i][gbdsdListTableGrid.getColumnIndex('dspCheckNo')]) {
				exists = true;
				break;
			}
		}

		if (!exists) {
			for (var i = 0; i < gbdsdListTableGrid.newRowsAdded.length; i++) {
				if (obj.dspCheckNo == gbdsdListTableGrid.newRowsAdded[i][gbdsdListTableGrid.getColumnIndex('dspCheckNo')]) {
					exists = true;
					break;
				}
			}
		}

		return exists;
	}

	$("btnSelectGbdsd").observe("click", function() {
		var exist = false;
		var tempRow = "";
		loadSelectedGbdsd();
		hideOverlay();
	});
</script>
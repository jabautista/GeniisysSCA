<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<span id="clMenus" name="clMenus" style="display: block;">
						<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
						<li><a>Claims Transaction</a>
							<ul style="width: 160px;">
								<li><a id="createClaim" name="createClaim">Create Claim</a></li>
								<li><a id="claimListing" name="claimListing">Claim Listing</a></li>
								<li><a id="lossExpense" name="lossExpense" class="disabledMenu" style="color: #B0B0B0">Loss/Expense History</a></li> <!-- disable menu temporarily kenneth L 12.18.2014 -->
								<li><a id="genAdvice" name="genAdvice" class="disabledMenu" style="color: #B0B0B0">Generate Advice</a></li> <!-- disable menu temporarily kenneth L 12.18.2014 -->
								<li><a id="genBatchCsr" name="genBatchCsr">Generate Batch CSR</a></li>
								<li><a id="genSpecialCsr" name="genSpecialCsr">Generate Special CSR</a></li>
								<li><a id="genSpecialCsrOffline" name="genSpecialCsrOffline">Generate SCSR (Offline)</a></li>
								<li><a id="evaluationReport" name="evaluationReport">MC Evaluation Report</a></li>
								<li><a id="menuFunctionOverride" name="menuFunctionOverride">Function Override</a></li>
								<!-- <li><a id="menuCancelClaim" name="menuCancelClaim">Cancel Claim</a></li> --> <!-- Removal of Cancel Claim Module menu Allan Burgos 10.05.2015 -->
								<li><a id="menuBatchClaimClosing" name="menuBatchClaimClosing">Batch Claim Closing</a></li>
								<li><a id="batchClaimRedistribution" name="batchClaimRedistribution">Batch Redistribution</a></li>
								<li><a id="menuReassignClaim" name="menuReassignClaim">Reassign Claim</a></li>
								<li><a id="noClaim" name="noClaim">No Claim</a></li>
								<li><a id="noClaimMultYy" name="noClaimMultYy">No Claim Multi-Year</a></li>
								<li><a id="lossRecovery" name="lossRecovery">Loss Recovery</a>
									<ul style="width: 180px;">
										<li><a id="recoveryListing" name="recoveryListing">Recovery Listing</a></li>
										<li><a id="updateLossRecoveryTag" name="updateLossRecoveryTag">Update Loss Recovery Tag</a></li>
										<li><a id="generateRecoveryAcct" name="generateRecoveryAcct">Generate Recovery Acct. Entries</a></li>
										<li><a id="reOpenLossRecovery" name="reOpenLossRecovery">Re-open Loss Recovery Record</a></li>
									</ul>
								</li>
							</ul>
						</li>
<!-- 						<li><a>Table Maintenance</a></li>  -->
						<li><a id="batchOsLoss" name="batchOsLoss">Batch O/S Loss</a></li>										
						<li><a>Inquiry</a>
							<ul style="width: 160px;">
								<li><a id="claimListingInquiry" name="claimListingInquiry">Claim Listing</a>
									<ul style="width: 250px;">										
										<li><a id="menuClaimListingPerAdjuster" name="">Claim Listing Per Adjuster</a></li>
										<li><a id="menuClaimListingPerAssured" name="">Claim Listing Per Assured</a></li>
										<li><a id="menuClaimListingPerBill" name="">Claim Listing Per Bill</a></li>
										<li><a id="menuClaimListingPerBlock" name="">Claim Listing Per Block</a></li>
										<li><a id="menuClaimListingPerCargoType" name="">Claims Listing Per Cargo Type</a></li>
										<li><a id="menuClaimListingPerCedingCompany" name="">Claim Listing Per Ceding Company</a></li>
										<li><a id="menuClaimListingPerColor" name="">Claim Listing Per Color</a></li>
										<li><a id="menuClaimListingPerIntermediary" name="">Claim Listing Per Intermediary</a></li>
										<li><a id="menuClaimListingPerLawyer" name="">Claim Listing Per Lawyer</a></li>
										<li><a id="menuClaimListingPerMake" name="">Claim Listing Per Make</a></li>
										<li><a id="menuClaimListingPerMotorshop" name="">Claim Listing Per Motorshop</a></li>
										<li><a id="menuClaimListingPerMotorcarReplacementParts" name="">Claim Listing Per Motor Car Replacement Part</a></li>
										<li><a id="menuClaimListingPerNatureOfLoss" name="">Claim Listing per Nature of Loss</a></li>
										<li><a id="menuClaimListingPerPayee" name="">Claim Listing Per Payee</a></li>
										<li><a id="menuClaimListingPerPlateNo" name="">Claim Listing Per Plate No</a></li>
										<li><a id="menuClaimListingPerPackagePolicy" name="">Claim Listing Per Package Policy</a></li>
										<li><a id="clmListingPerPolicy" name="">Claim Listing Per Policy</a></li>
										<li><a id="clmListingPerPolicyWithEnrollees" name="">Claim Listing Per Policy with Enrollees</a></li>
										<li><a id="menuClaimListingPerRecoveryType" name="">Claim Listing Per Recovery Type</a></li>
										<li><a id="menuClaimListingPerThirdParty" name="">Claim Listing Per Third Party</a></li>
										<li><a id="menuClaimListingPerUser" name="">Claim Listing Per User</a></li>
										<li><a id="menuClaimListingPerVessel" name="">Claim Listing Per Vessel</a></li>
									</ul>
								</li>
								<li><a id="menuClaimDistribution" name="menuClaimDistribution">Claim Distribution</a></li>
								<li><a id="claimHistoryInquiry" name="claimHistoryInquiry">Claim History</a></li>
								<li><a id="claimInformation" name="claimInformation">Claim Information</a></li>
								<li><a id="menuClaimPayment" name="menuClaimPayment">Claim Payment</a></li>
								<li><a id="menuClaimStatus">Claim Status</a></li>
								<li><a id="exGratiaClaimsInquiry" name="exGratiaClaimsInquiry">Ex-Gratia Claims Inquiry</a></li>
								<li><a id="menuLossRecoveryPayment" name="menuLossRecoveryPayment">Recovery Payment</a></li>
								<li><a id="menuSpecialCSRInquiries">Special CSR Inquiries</a></li>
								<li><a id="menuRecoveryStatusInquiry">Recovery Status</a></li>
							</ul>
						</li>
						<!-- <li><a>Catastrophic Event</a></li> -->
 						<li><a>Reports</a>
 							<ul style="width: 180px;">
 								<li><a id="batchOSPrinting">Batch O/S Printing</a></li>
 								<li><a id="bordereauxClaimsRegister">Bordereaux and Claims Register</a></li>
 								<li><a id="menuClaimsRecoveryRegister">Claims Recovery Register</a></li>
 								<li><a id="lossProfile">Loss Profile</a></li>
 								<li><a id="lossRatio">Loss Ratio</a></li>
								<li><a id="outstandingLOA" name="outstandingLOA">Outstanding LOA</a></li>
								<li><a id="menuGeneratePLAFLA">Generate PLA/FLA</a></li>
								<li><a id="menuPrintPLAFLA">Print PLA/FLA</a></li>
								<li><a id="reportedClaims" name="reportedClaims">Reported Claims</a></li>
 								<li><a id="biggestClaims">Biggest Claims</a></li>
 							</ul>
 						</li>
						<li><a>Catastrophic Event</a>
							<ul style="width: 160px;">
								<li><a id="catastrophicEventMaintenance">Maintenance</a></li>
 								<li><a id="catastrophicEventInquiry">Inquiry</a></li>
 								<li><a id="catastrophicEventReport">Report</a></li>
							</ul>
						</li>
						<li><a>Table Maintenance</a>
							<ul style="width: 180px;">
								<li><a id="menuAdviceApprovalLimit" name="menuAdviceApprovalLimit">Advice Approval Limit</a></li>
								<li><a id="menuClaimPayee" name="menuClaimPayee">Claim Payee</a></li>
								<li><a id="menuClaimStatusMaintenance" name="menuClaimStatusMaintenance">Claim Status</a></li>
								<li><a id="menuClaimStatusReasonsMaintenance" name="menuClaimStatusReasonsMaintenance">Claim Status Reasons</a></li>
								<li><a id="menuDriverOccupationMaintenance" name="menuDriverOccupationMaintenance">Driver Occupation</a></li>
								<li><a id="menuLossCategory" name="menuLossCategory">Loss Category</a></li>
								<li><a id="menuLossExpenseCode" name="menuLossExpenseCode">Loss/Expense</a></li>
								<li><a id="menuLossExpSettlementMaintenance" name="menuLossExpSettlementMaintenance">Loss/Expense Settlement Status</a></li>
								<li><a id="menuLossExpTaxMaintenance" name="menuLossExpTaxMaintenance">Loss/Expense Tax</a></li>
								<li><a id="motorCarDepreciationRate" name="motorCarDepreciationRate">Motor Car Depreciation Rate</a></li>
								<li><a id="motorCarLaborPointSystem" name="motorCarLaborPointSystem">Motor Car Labor Point System</a></li>
								<li><a id="motorCarRepairType" name="motorCarRepairType">Motor Car Repair Type</a></li>
								<li><a id="motorCarReplacementPart" name="motorCarReplacementPart">Motor Car Replacement Part</a></li>
								<li><a id="nationalityMaintenance" name="nationalityMaintenance">Nationality Maintenance</a></li>
								<li><a id="payeeClassMaintenance" name="payeeClassMaintenance">Payee Class Maintenance</a></li>
								<li><a id="menuPrivateAdjuster" name="menuPrivateAdjuster">Private Adjuster</a></li>
								<li><a id="menuRecoveryStatus" name="menuRecoveryStatus">Recovery Status</a></li>
								<li><a id="menuRecoveryType" name="menuRecoveryType">Recovery Type</a></li>
								<li><a id="menuReportDocument" name="menuReportDocument">Report Document</a></li>
								<li><a id="menuRepSignatory" name="menuRepSignatory">Report Document Signatory</a></li>
								<li><a id="menuClmDocs" name="menuClmDocs">Required Document</a></li>
							</ul>
						</li>							
					</span>
				</ul>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<script type="text/javascript">
	/**
		Created By: Irwin Tabisora
		Date: Dec. 1, 2011
	*/
	
	objCLMGlobal.transaction = ""; 
	objCLMGlobal.tranType = ""; 
	objCLMGlobal.claim = ""; 
	objCLMGlobal.clmSw = ""; 
	function initializeClaimsMenu(){
		try{
			initializeMenu();
			
			$("home").observe("mouseover", function(){
				new Effect.Opacity("home", {
						duration : 0.2,
						to : 1
					});
			});
			
			$("home").observe("mouseout", function(){
				new Effect.Opacity("home", {
						duration : 0.2,
						to : 0.8
					});
			});	
			
			$("home").observe("click", function () {
				goToModule("/GIISUserController?action=goToHome", "Home");
			});
			
			/* $("createClaim").observe("click", function (){
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS001"; 
				//viewClaimLineListing();
				showClaimBasicInformation();
			}); */ // bonok :: 10.25.2012
			
			observeAccessibleModule(accessType.MENU, "GICLS010", "createClaim", function(){
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS010"; 
				objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
				showClaimBasicInformation();
			}); // bonok :: 10.25.2012
			
			/*
			* Rey Jadlocon
			* 09-08-2011
			* Claim Line Listing
			*/
			/* $("claimListing").observe("click", function () {
				objCLMGlobal = new Object();
				setDocumentTitle("View Claim Listing");
				objCLMGlobal.callingForm = "GICLS002"; 
				viewClaimsLineListing();
			}); */ // bonok :: 10.25.2012
			
			observeAccessibleModule(accessType.MENU, "GICLS002", "claimListing", function () {
				objCLMGlobal = new Object();
				setDocumentTitle("View Claim Listing");
				objCLMGlobal.callingForm = "GICLS002"; 
				viewClaimsLineListing();
			}); // bonok :: 10.25.2012
			
			//Nica 03.01.2012
			/* $("lossExpense").observe("click", function(){
				objCLMGlobal = new Object();
				fromClaimMenu = "Y";
				setDocumentTitle("Loss/Expense History");
				objCLMGlobal.callingForm = "GICLS030";
				showLossExpenseHistory();
			}); */ // bonok :: 10.25.2012
			
			//disable menu temporarily kenneth L 12.18.2014
			/* observeAccessibleModule(accessType.MENU, "GICLS030", "lossExpense", function(){
				objCLMGlobal = new Object();
				fromClaimMenu = "Y";
				setDocumentTitle("Loss/Expense History");
				objCLMGlobal.callingForm = "GICLS030";
				showLossExpenseHistory();
			}); */ // bonok :: 10.25.2012
			
			observeAccessibleModule(accessType.MENU, "GICLS032", "genAdvice", function(){
				
			}); // bonok :: 10.25.2012
			
			/*observeAccessibleModule(accessType.MENU, "GICLS040", "menuCancelClaim", function(){		
				
			}); // bonok :: 10.25.2012 */ // Allan Burgos 10.05.2015
					
			/*
			* Rey Jadlocon
			* 09-12-2011
			* No Claim Multi Yy
			*/
			$("noClaimMultYy").observe("click",function(){
				objCLMGlobal = new Object();
				setDocumentTitle("No Claim Multi Year Listing");
				objCLMGlobal.callingForm = "GICLS062"; 
				showNoClaimMultiYyList();
			});
			
			//Loss Recovery
			observeAccessibleModule(accessType.MENU, "GICLS052", "recoveryListing", function(){
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS052"; 
				viewClaimsLineListing();
			});//Christian 07.06.2012
			observeAccessibleModule(accessType.MENU, "GICLS053", "updateLossRecoveryTag", function(){
				objCLMGlobal.callingForm = "GICLS053"; 
				viewClaimsLineListing();
			}); //IRWIN 12.01.2011
			observeAccessibleModule(accessType.MENU, "GICLS043", "genBatchCsr", function(){
				objCLMGlobal.callingForm = "GICLS043";
				showBatchCSRListing();
			});// Nica 12.07.2011
			observeAccessibleModule(accessType.MENU, "GIACS086", "genSpecialCsr", function(){
				objCLMGlobal.fromClaimMenu = 'Y'; //added by robert 11.28.2013
				objCLMGlobal.callingForm = "GIACS086"; 
				//showSpecialCSRListing();	//replaced by kenneth to display Branch listing 05272015 SR 4206
				showOtherBranchRequests("", "Y","SCSR", "", "Special Claim Settlement Request");
			}); //IRWIN 12.08.2011
			
			observeAccessibleModule(accessType.MENU, "GIACS086", "genSpecialCsrOffline", function(){
				/* objCLMGlobal.callingForm = "GIACS055"; 
				objCLMGlobal.transaction = "Disbursement"; 
				objCLMGlobal.tranType = "SCSR"; 
				objCLMGlobal.claim = "N"; 
				objCLMGlobal.clmSw = "Y";  */
				objCLMGlobal.callingForm = "GIACS055"; 
				showOtherBranchRequests("", "Y","SCSR");
			}); //IRWIN 12.08.2011
			
			
			
			observeAccessibleModule(accessType.MENU, "GICLS026", "noClaim", function(){
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS026"; 
				viewClaimsLineListing();
			}); //robert 12.08.2011
			
			observeAccessibleModule(accessType.MENU, "GICLS055", "generateRecoveryAcct", function() {
				objCLMGlobal.callingForm = "GICLS055";
				showGenerateRecoveryAcctEntries(null, null);
			}); //darwin 12.14.2011
			
			observeAccessibleModule(accessType.MENU, "GICLS070", "evaluationReport", function(){
				mcEvalFromItemInfo = "N"; // irwin april 14, 2012
				showMcEvaluationReport();
			}); //niknok 12.15.2011
			
			observeAccessibleModule(accessType.MENU, "GICLB001", "batchOsLoss", function(){
				objCLMGlobal.callingForm = "GICLB001"; 
				showBatchOsLoss();
			}); //robert 01.16.2012
			
			observeAccessibleModule(accessType.MENU, "GICLS150", "menuClaimPayee", function(){
				objCLMGlobal.callingForm = ""; 
				showMenuClaimPayeeClass(null, null);
			});//fons 4.24.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS160", "menuClaimStatusMaintenance", function(){
				objCLMGlobal.callingForm = ""; 
				showClaimStatusMaintenance();
			});//fons 8.16.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS170", "menuClaimStatusReasonsMaintenance", function(){
				objCLMGlobal.callingForm = ""; 
				showClmStatReasonsMaintenance();
			});//fons 8.23.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS511", "menuDriverOccupationMaintenance", function(){
				objCLMGlobal.callingForm = ""; 
				showDrvrOccptnMaintenance();
			});//fons 8.29.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS044", "menuReassignClaim", function(){
				// your function here
			});

			observeAccessibleModule(accessType.MENU, "GICLS252", "menuClaimStatus", function(){
				//objCLMGlobal.callingForm = "GICLS252";
				try{
					new Ajax.Request(contextPath + "/GICLClaimStatusController", {
					    parameters : {action : "showMenuClaimStatus",
					    			  clmStatusType : "%",
					    			  dateBy: "lossDate",
					    			  dateAsOf: getCurrentDate()
					    			 },
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showMenuClaimStatus - onComplete : ", e);
							}								
						} 
					});
				}catch(e){
					showErrorMessage("menuClaimStatus : ", e); 
				}				
			});//chamille 2.1.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS270", "menuLossRecoveryPayment", function(){
				new Ajax.Request(contextPath + "/GICLLossRecoveryPaymentController", {
					    parameters : {action : "showLossRecoveryPayment"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showLossRecoveryPayment - onComplete : ", e);
							}
						}
					});
			 });
			
			observeAccessibleModule(accessType.MENU, "GICLS039", "menuBatchClaimClosing", function(){
				showBatchClaimClosing(1);
			});//christian 10.xx.2012
			
			// J. Diago 09.02.2013
			observeAccessibleModule(accessType.MENU, "GICLS038", "batchClaimRedistribution", function(){
				objCLMGlobal = new Object();
				setDocumentTitle("View Claim Listing");
				objCLMGlobal.callingForm = "GICLS038";
				viewClaimsLineListing();
			});

			observeAccessibleModule(accessType.MENU, "GICLS183", "menuFunctionOverride", function(){
				showFunctionOverride();
			}); //shan 12.20.2012

			// Inquiry
			observeAccessibleModule(accessType.MENU, "GICLS250", "clmListingPerPolicy", function(){
				objCLMGlobal.callingForm = "GICLS250"; 
				showClmListingPerPolicy2();
			}); //niknok 12.15.2011
			
			observeAccessibleModule(accessType.MENU, "GICLS278", "clmListingPerPolicyWithEnrollees", function(){
				objCLMGlobal.callingForm = "GICLS278";
				try{
					new Ajax.Updater("dynamicDiv", contextPath+"/GICLClaimListingInquiryController", {
						parameters: {
							action: "showClaimListingPerPolicyWithEnrollees",
							moduleId: "GICLS278"
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: showNotice("Loading, please wait..."),
						onComplete: function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)){
								setModuleId("GICLS278");
								setDocumentTitle("Claim Listing Per Policy With Enrollees");
							}
						}
					});	
				}catch(e){
					showErrorMessage("showClaimListingPerPolicyWithEnrollees", e);
				}
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS254", "claimHistoryInquiry", function(){
				objCLMGlobal.callingForm = "GICLS254"; 
				showClmHistory();
			}); //cherrie 12.13.2012

			observeAccessibleModule(accessType.MENU, "GICLS258", "menuClaimListingPerRecoveryType", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {action : "showClaimListingPerRecoveryType"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								setModuleId("GICLS258");
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerRecoveryType - onComplete : ", e);
						}								
					} 
				});
				// joanne 1.28.2013
			});

			/**
			 * Dwight See 
			 * Claim Listing Per Third Party
			 * 06-18-2013
			 */
			observeAccessibleModule(accessType.MENU, "GICLS277", "menuClaimListingPerThirdParty", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {action : "showClaimListingPerThirdParty"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								setModuleId("GICLS277");
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerThirdParty - onComplete : ", e);
						}								
					} 
				});
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS257", "menuClaimListingPerAdjuster", function(){
				objCLMGlobal.callingForm = "";

				/**
				 * Shows Claim Listing Per Adjuster
				 * Module: GICLS257
				 * @author Sharon Olayon
				 * @date 01.28.2013
				 */
				 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {action : "showClmListingPerAdjuster"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClmListingPerAdjuster - onComplete : ", e);
						}								
					} 
				});
			});

			observeAccessibleModule(accessType.MENU, "GICLS251", "menuClaimListingPerAssured", function(){
				objCLMGlobal.callingForm = "";
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {action : "showClaimListingPerAssured"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerAssured - onComplete : ", e);
						}								
					} 
				});
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS266", "menuClaimListingPerIntermediary", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					evalScript : true,
				    parameters : {action : "showClaimListingPerIntermediary"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerIntermediary - onComplete : ", e);
						}								
					} 
				});
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS253", "menuClaimListingPerMotorshop", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					evalScript : true,
				    parameters : {action : "showClaimListingPerMotorshop"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerIntermediary - onComplete : ", e);
						}								
					} 
				});
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS275", "menuClaimListingPerMotorcarReplacementParts", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					evalScript : true,
				    parameters : {action : "showClaimListingPerMotorcarReplacementParts"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerMotorcarReplacementParts - onComplete : ", e);
						}								
					} 
				});
			});//justhel 06.07.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS256", "menuClaimListingPerNatureOfLoss", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					evalScript : true,
				    parameters : {action : "showClaimListingPerNatureOfLoss"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerIntermediary - onComplete : ", e);
						}								
					} 
				});
			});

			observeAccessibleModule(accessType.MENU, "GICLS263", "menuClaimListingPerMake", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					evalScript : true,
				    parameters : {action : "showClaimListingPerMake"},
				    onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClaimListingPerMake - onComplete : ", e);
						}								
					} 
				});
			});//justhel 05.24.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS259", "menuClaimListingPerPayee", function(){
				showClaimListingPerPayee(null,null,null);
			});
			

			observeAccessibleModule(accessType.MENU, "GICLS268", "menuClaimListingPerPlateNo", function(){
				objCLMGlobal.callingForm = "";   
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					    parameters : {action : "showClaimListingPerPlateNo"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerPlateNo - onComplete : ", e);
							}								
						} 
					});
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS274", "menuClaimListingPerPackagePolicy", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController",{
					parameters : {action : "getClmListPerPackagePolicy"},
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						try {
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} catch(e){
							showErrorMessage("showClmListingPerPackagePolicy - onComplete : ", e);
						}
					}
				});
			});//Koks 01.28.2013

			observeAccessibleModule(accessType.MENU, "GICLS264", "menuClaimListingPerColor", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {
				    	action : "showClaimListingPerColor"},
				    	onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerColor - onComplete : ", e);
							}								
						} 
					});
			});
			
				/* observeAccessibleModule(accessType.MENU, "GICLS276", "menuClaimListingPerLawyer", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					parameters : {
						action : "showClaimListingPerLawyer"},
						onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try{
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerColor - onComplete : ", e);
							}
						}
				});
			});	  */
			
			observeAccessibleModule(accessType.MENU, "GICLS276", "menuClaimListingPerLawyer", function(){
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController",{
					parameters : {
						action : "showClaimListingPerLawyer"},
						onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try{
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerColor - onComplete : ", e);
							}
						}
				});
			});
			
/*  			$("menuClaimListingPerLawyer").observe("click", function(){
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController",{
					parameters : {
						action : "showClaimListingPerLawyer"},
						onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try{
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerColor - onComplete : ", e);
							}
						}
				});
			}); 
 */			
			
			
			observeAccessibleModule(accessType.MENU, "GICLS265", "menuClaimListingPerCargoType", function(){
				
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					    parameters : {action : "showClaimListingPerCargoType"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerCargoType - onComplete : ", e);
							}								
						} 
					});
			});

			observeAccessibleModule(accessType.MENU, "GICLS271", "menuClaimListingPerUser", function(){
				objCLMGlobal.callingForm = "GICLS271"; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					    parameters : {action : "showClaimListingPerUser"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerUser - onComplete : ", e);
							}								
						} 
					});
			});			
			
			 observeAccessibleModule(accessType.MENU, "GICLS262", "menuClaimListingPerVessel", function(){
					objCLMGlobal.callingForm = ""; 
					new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
						    parameters : {action : "showClaimListingPerVessel"},
						    onCreate : showNotice("Loading, please wait..."),
							onComplete : function(response){
								hideNotice();
								try {
									if(checkErrorOnResponse(response)){
										$("dynamicDiv").update(response.responseText);
									}
								} catch(e){
									showErrorMessage("showClaimListingPerVessel - onComplete : ", e);
								}
							}
						});
				});
			
			 observeAccessibleModule(accessType.MENU, "GICLS267", "menuClaimListingPerCedingCompany", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					    parameters : {action : "showClaimListingPerCedingCompany"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerCeding - onComplete : ", e);
							}
						}
					});
			});//pj diaz 01/29/13 

			observeAccessibleModule(accessType.MENU, "GICLS202", "bordereauxClaimsRegister", showBordereauxClaimsRegister);
			observeAccessibleModule(accessType.MENU, "GICLS211", "lossProfile", showGICLS211);
			observeAccessibleModule(accessType.MENU, "GICLS204", "lossRatio", showGICLS204);
			observeAccessibleModule(accessType.MENU, "GICLS044", "menuReassignClaim", function(){
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS044"; 
				viewClaimsLineListing();
			});// Kenneth L. 05.23.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS260", "claimInformation", function () {
				objCLMGlobal = new Object();
				setDocumentTitle("Claim Information");
				objCLMGlobal.callingForm = "GICLS260"; 
				viewClaimsLineListing();
			}); 
			
			//shan 03.14.2013
			observeAccessibleModule(accessType.MENU, "GICLS201", "menuClaimsRecoveryRegister", function(){
				checkUserAccessGicls("GICLS201");
			});
			
			//jed 06.04.2013
			observeAccessibleModule(accessType.MENU, "GICLS272", "menuClaimListingPerBill", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				    parameters : {
				    	action : "showClaimListingPerBill"},
				    	onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerBill - onComplete : ", e);
							}								
						} 
					});
			});
			
			// wsvalle 05.10.13
			observeAccessibleModule(accessType.MENU, "GICLS279", "menuClaimListingPerBlock", function(){
				objCLMGlobal.callingForm = ""; 
				new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
					    parameters : {action : "showClaimListingPerBlock"},
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showClaimListingPerBlock - onComplete : ", e);
							}								
						} 
					});
			}); 
			
			//Aliza Garza 06.04.2013
			observeAccessibleModule(accessType.MENU, "GICLS261", "menuClaimPayment", function () {
				/* objCLMGlobal = new Object();
				setDocumentTitle("Claim Payment");
				objCLMGlobal.callingForm = "GICLS261";  */
				showClaimPayment();
			}); 			
			
			//adpascual 06.07.2013
			observeAccessibleModule(accessType.MENU, "GICLS255", "menuClaimDistribution", function () {
				checkUserAccessGicls('GICLS255');
			}); 		
			
			// wsvalle 06.11.2013
			observeAccessibleModule(accessType.MENU, "GICLS269", "menuRecoveryStatusInquiry", function(){
				try{
					new Ajax.Request(contextPath + "/GICLLossRecoveryStatusController", {
					    parameters : {action : "showLossRecoveryStatus",
					    			  recStatusType : "%",
					    			  //dateBy: "lossDate", //comment out by Fons 11.05.2013 to handle execute query button
					    			  dateAsOf: getCurrentDate()
					    			 },
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							try {
								if(checkErrorOnResponse(response)){
									$("dynamicDiv").update(response.responseText);
								}
							} catch(e){
								showErrorMessage("showLossRecoveryStatus - onComplete : ", e);
							}								
						} 
					});
				}catch(e){
					showErrorMessage("menuRecoveryStatusInquiry : ", e); 
				}	
			}); 
			
			observeAccessibleModule(accessType.MENU, "GICLS051", "menuGeneratePLAFLA", function(){
				objGICLS051 = new Object();
				showGeneratePLAFLAPage("P", null);
			});
			observeAccessibleModule(accessType.MENU, "GICLS050", "menuPrintPLAFLA", function(){
				objGICLS050 = new Object();
				showPrintPLAFLAPage("P", null);
			});
			
			//jomsdiago 07.18.2013 / comment by apollo cruz 07.25.2014
			/* observeAccessibleModule(accessType.MENU, "GICLS220", "biggestClaims", function () {
				checkUserAccessGicls('GICLS220');
			}); */
			
			observeAccessibleModule(accessType.MENU, "GICLS220", "biggestClaims", showBiggestClaims);
			
			observeAccessibleModule(accessType.MENU, "GICLS207", "batchOSPrinting", function(){
				try{
					new Ajax.Request(contextPath + "/GICLBatchOSPrintingController", {
					    parameters : {action : "showBatchOSPrinting"},
					    asynchronous: false,
						evalScripts: true,
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} 
					});
				}catch(e){
					showErrorMessage("batchOSPrinting menu:", e); 
				}	
			}); 
			
			//Gzelle 07.26.2013
			observeAccessibleModule(accessType.MENU, "GICLS219", "outstandingLOA", function () {
				showOutstandingLOA();
			});

			//Gzelle 08.01.2013
			observeAccessibleModule(accessType.MENU, "GICLS540", "reportedClaims", function () {
				showReportedClaims();
			});
			
			observeAccessibleModule(accessType.MENU, "GICLS056", "catastrophicEventMaintenance", showGICLS056);
			
			//Gzelle 08.01.2013
			observeAccessibleModule(accessType.MENU, "GICLS057", "catastrophicEventInquiry", showCatastrophicEventInquiry);
			
			observeAccessibleModule(accessType.MENU, "GICLS200", "catastrophicEventReport", showCatastrophicEventReport);
			
			//john 10.23.2013
			observeAccessibleModule(accessType.MENU, "GICLS060", "menuLossExpSettlementMaintenance", showLossExpSettlementMaintenance);
			
			observeAccessibleModule(accessType.MENU, "GICLS106", "menuLossExpTaxMaintenance", showGicls106); //john dolon 11.14.2013
			
			observeAccessibleModule(accessType.MENU, "GICLS101", "menuRecoveryType",showMenuRecoveryType);
			observeAccessibleModule(accessType.MENU, "GICLS100", "menuRecoveryStatus",showGicls100);
			observeAccessibleModule(accessType.MENU, "GICLS210", "menuPrivateAdjuster", showGicls210);
			observeAccessibleModule(accessType.MENU, "GICLS059", "motorCarDepreciationRate", showGicls059);
			observeAccessibleModule(accessType.MENU, "GICLS171", "motorCarLaborPointSystem", showGICLS171); // pol cruz 11.11.2013
			observeAccessibleModule(accessType.MENU, "GICLS172", "motorCarRepairType", showGICLS172);
			observeAccessibleModule(accessType.MENU, "GICLS180", "menuReportDocument", showGICLS180);
			observeAccessibleModule(accessType.MENU, "GICLS181", "menuRepSignatory", showGicls181);
			observeAccessibleModule(accessType.MENU, "GICLS110", "menuClmDocs", showGicls110);
			observeAccessibleModule(accessType.MENU, "GICLS058", "motorCarReplacementPart", showGICLS058);
			observeAccessibleModule(accessType.MENU, "GICLS184", "nationalityMaintenance", showGICLS184);
			observeAccessibleModule(accessType.MENU, "GICLS273", "exGratiaClaimsInquiry", showGICLS273); 	//Gzelle 07172014
			observeAccessibleModule(accessType.MENU, "GICLS140", "payeeClassMaintenance", showGICLS140);
			observeAccessibleModule(accessType.MENU, "GICLS105", "menuLossCategory", showGICLS105); 	// shan 10.23.2013
			observeAccessibleModule(accessType.MENU, "GICLS104", "menuLossExpenseCode", showGicls104);			
			observeAccessibleModule(accessType.MENU, "GICLS182", "menuAdviceApprovalLimit", showGICLS182); 	// shan 11.26.2013
			observeAccessibleModule(accessType.MENU, "GIACS087", "menuSpecialCSRInquiries", showGIACS087); 	// shan 07.17.2014
			observeAccessibleModule(accessType.MENU, "GICLS125", "reOpenLossRecovery", function () {
				objCLMGlobal = new Object();
				objCLMGlobal.callingForm = "GICLS125"; 
				viewClaimsLineListing();
			});
		}catch(e){
			showErrorMessage("initializeClaimsMenu");
		}
	}
	
	initializeClaimsMenu();
</script>
<!--END MAIN NAV-->
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="underwritingMainMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
				<li><a id="policyIssuance" name="policyIssuance">Policy Issuance</a>
					<ul style="width: 160px;">
						<li><a id="parCreation" name="parCreation">Policy PAR Creation</a></li>
						<li><a id="parListing" name="parListing">Policy PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="endtParCreation" name="endtParCreation">Endt PAR Creation</a></li>
						<li><a id="endtParListing" name="endtParListing">Endt PAR Listing</a></li>
						<li class="menuSeparator"></li> 
						<li><a id="packParCreation" name="packParCreation">Package PAR Creation</a></li>
						<li><a id="packParListing" name="packParListing">Package PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="packEndtParCreation" name="packEndtParCreation">Package Endt PAR Creation</a></li>
						<li><a id="packEndtParListing" name="packEndtParListing">Package Endt PAR Listing</a></li>
					</ul>
				</li>
				<li><a>Distribution</a>
					<ul style="width: 210px;">
						<li><a id="setupGroupsDistItem">Set-up Groups for Dist (Item)</a></li>
						<li><a id="setupGroupsDistPeril">Set-up Groups for Dist (Peril)</a></li>
						<li class="menuSeparator"></li>
						<li><a id="distByPeril">Distribution by Peril</a></li>
						<li><a id="distByTSIGrp">Distribution by Group</a></li>  <!-- added by robert SR 5053 11.11.15 -->
						<!-- <li><a id="distByGrp">Distribution by Group</a></li> removed by robert SR 5053 11.11.15-->
						<li class="menuSeparator"></li>
						<li><a id="batchDist">Batch Distribution</a></li>
						<!-- <li class="menuSeparator"></li> removed by robert SR 5053 11.11.15 -->
						<!-- <li><a id="distByTSIGrp">Dist by TSI/Prem</a></li> removed by robert SR 5053 11.11.15 -->
						<!-- <li><a id="distByTSIPeril">Dist by TSI/Prem (Peril)</a></li> removed by robert SR 5053 11.11.15 -->
						<li class="menuSeparator"></li>
						<li><a id="negPostedDist">Negate Posted Distribution</a></li>
						<li><a id="redistribution">Redistribution</a></li>
						<li><a id="popuMissDistRec">Populate Missing Distribution Records</a></li><!--  removed by robert SR 5053 11.11.15 --> <!-- re added by gab SR 5603 10.03.2016 -->
					</ul>
				</li>
				<li><a>Reinsurance</a>
					<ul style="width: 210px;">
						<li><a id="frpsListing" name="frpsListing">FRPS Listing</a></li> 
						<li><a id="createRiPlacement" name="createRiPlacement">Create RI Placement</a></li>
						<li><a id="enterRiAcceptance" name="enterRiAcceptance">Enter RI Acceptance</a></li>
						<li><a id="groupBinders" name="groupBinders">Group/Ungroup Binders</a></li>
						<li class="menuSeparator"></li>
						<li><a id="riGenPackageBinders" name="riGenPackageBinders">Generate Package Binders</a></li>
						<li class="menuSeparator"></li>
						<li><a id="intreatyListing" name="intreatyListing">Inward Treaty Listing</a></li> <!-- benjo 08.03.2016 SR-5512 -->
						<li class="menuSeparator"></li> <!-- benjo 08.03.2016 SR-5512 -->
						<li><a id="riParCreation" name="riParCreation">Policy PAR Creation</a></li>
						<li><a id="riParListing" name="riParListing">Policy PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="riEndtParCreation" name="riEndtParCreation">Endt PAR Creation</a></li>
						<li><a id="riEndtParListing" name="riEndtParListing">Endt PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="riPackParCreation" name="riPackParCreation">Package PAR Creation</a></li>
						<li><a id="riPackParListing" name="riPackParListing">Package PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="riPackEndtParCreation" name="riPackEndtParCreation">Package Endt PAR Creation</a></li>
						<li><a id="riPackEndtParListing" name="riPackEndtParListing">Package Endt PAR Listing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="riConfirmBinder" name="riConfirmBinder">Confirm Binder</a></li>
						<li><a id="riReportsPrinting" name="riReportsPrinting">Reports Printing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="reverseBinder" name="reverseBinder">Reverse and Replace Binder</a></li>
						<li><a id="updateInwardRIComm" name="updateInwardRIComm">Update Inward RI Commission</a></li>
						<li><a id="genBinderNonAffEndt" name="genBinderNonAffEndt">Generate Binder (Non-Affecting Endt.)</a></li>
					</ul>
				</li>
				<li><a>Renewal Processing</a>
					<ul style="width: 250px;">
						<li><a id="extractExpiringPolicies" name="extractExpiringPolicies">Extract Expiring Policies</a></li>
						<li><a id="purgeExtractedPolicies" name="purgeExtractedPolicies">Purge Extracted Policies</a></li> 
						<li><a id="processExpiringPolicies" name="processExpiringPolicies">Process Expiring Policies</a></li>
						<li><a id="printExpiryReportRenewals" name="printExpiryReportRenewals">Print Expiry Report/Renewals</a></li>
						<li class="menuSeparator"></li>
						<li><a id="assignExtractedExpiryRecord" name="assignExtractedExpiryRecord">Assign Extracted Expiry Record to a New User</a></li>
						<li><a id="viewRenewal" name="viewRenewal">View Renewal</a></li>
						<li><a id="businessConservation" name="businessConservation">Business Conservation</a></li>
					</ul>
				</li>
				<li><a id="reportsPrinting" name="reportsPrinting">Reports Printing</a>
					<ul style="width: 180px;">
						<li><a id="extractExpiringCovernote" name="extractExpiringCovernote">Extract Expiring Covernote</a></li>
						<li><a id="reprintPolicyDocuments" name="reprintPolicyDocuments">Reprint Policy Documents</a></li>
						<li class="menuSeparator"></li>
						<li><a id="menuGenerateStatisticalReports" name="menuGenerateStatisticalReports">Generate Statistical Reports</a></li>
						<li><a id="menuRiskAndLossProfile" name="menuRiskAndLossProfile">Risk and Loss Profile</a></li>
						<li class="menuSeparator"></li>
						<li><a id="uwProductionReports" name="uwProductionReports">Underwriting Production Reports</a></li>
						<li class="menuSeparator"></li>
						<li><a id="printPolicyCertificates" name="printPolicyCertificates">Print Policy Certificates</a></li>
						<li><a id="enrolleeCertificate" name="enrolleeCertificate">Enrollee Certificate</a></li> <!-- Pol Cruz,  4.29.2013 -->
						<li class="menuSeparator"></li>
						<li><a id="menuBatchPrinting" name="menuBatchPrinting">Batch Printing</a></li>
						<li class="menuSeparator"></li>
						<li><a id="menuRecapitulation" name="menuRecapitulation">Recapitulation</a></li>
						<li><a id="menuRiskCategory" name="menuRiskCategory">Risk Category</a></li>
					</ul>
				</li>
				<li><a>Utilities</a>
					<ul style="width: 160px;">
						<li><a id="batchPosting">Batch Posting</a></li>
						<li><a id="inspectionReport">Inspection Report</a></li>
						<li class="menuSeparator"></li>
						<li><a id="copyUtilities" name="copyUtilities">Copy Utilities</a>
							<ul style="width: 180px;">
								<li><a id="copyPAR" name="copyPAR">Copy PAR to a new PAR</a></li>
								<li><a id="copyPolicyEndt" name="copyPolicyEndt">Copy Policy to a new PAR</a></li>
								<li><a id="summarizePolicy" name="summarizePolicy">Summarize a Policy to a new PAR</a></li>
								<li class="menuSeparator"></li>
								<li><a id="copyPackPolicy" name="copyPackPolicy">Copy Package Policy to a new PAR</a></li>
							</ul>
						</li>
						<li class="menuSeparator"></li>
						<li><a id="spoilageReinstatement" name="spoilageReinstatement">Spoilage / Reinstatement</a>
							<ul style="width: 180px;">
								<li><a id="menuReinstatement" name="menuReinstatement">Reinstatement</a></li>
								<li><a id="menuReinstatementPack" name="menuReinstatementPack">Reinstatement - Package Policy</a></li>
								<li class="menuSeparator"></li>	
								<li><a id="spoilPolicy" name="spoilPolicy">Spoil a Posted Policy</a></li>
								<li><a id="menuSpoilPackPolicy" name="menuSpoilPackPolicy">Spoil a Posted Package Policy</a></li>						
							</ul>
						</li>
						<li class="menuSeparator"></li>
				<!--    <li><a id="bondCollateral" name="bondCollateral">Bond Collateral</a>
							<ul style="width: 180px;">
								<li><a id="menuEnterCollateralTransaction" name="menuEnterCollateralTransaction">Enter Collateral Transaction</a></li>
								<li><a id="menuReleaseCollateral" name="releaseCollateral">Release Collateral</a></li>													
							</ul>
						</li> -->
						<li class="menuSeparator"></li>
						<li><a id="reassignment" name="reassignment">Reassignment</a>
							<ul style="width: 180px;">
								<li><a id="reassignParPolicy" name="reassignParPolicy">Re-assign PAR Policy to a new User</a></li>
								<li><a id="menuReassignParEndt" name="menuReassignParEndt">Re-assign PAR Endt to a new User</a></li>													
							</ul>
						</li>
						<li class="menuSeparator"></li>
						<li><a id="updateInformation" name="updateInformation">Update Information</a>
							<ul style="width: 280px;">
								<li><a id="menuUpdateBondPolicy" name="menuUpdateBondPolicy">Update Bond Policy</a></li>
								<li><a id="menuUpdatePolicyDistrictEtc" name="menuUpdatePolicyDistrictEtc">Update Policy District/Block/EQ/FLD/TPN/TRF</a></li>
								<li><a id="menuUpdatePolicyBookingDateEtc" name="menuUpdatePolicyBookingDateEtc">Update Policy Booking Date/Cred Branch/Reg Pol Tag</a></li>
								<li><a id="menuUpdatePolicyBookingTag" name="menuUpdatePolicyBookingTag">Update Policy Booking Tag</a></li>
								<li><a id="updateInitialEtc" name="updateInitialEtc">Update Initial/General/Endt Text Info</a>
									<!-- SR-21812 JET MAY-04-2016 -->
									<ul style="width: 120px;">
										<li><a id="updateInitEtcNonPackPol" name="updateInitEtcNonPackPol">Non-Package Policies</a></li>
										<li><a id="updateInitEtcPackPol" name="updateInitEtcPackPol">Package Policies</a></li>
									</ul>
								</li>
								<li><a id="menuUpdateAddWarrCla" name="menuUpdateAddWarrCla">Update/Add Warranties and Clauses</a></li>
								<!-- <li><a id="menuUpdateAddTaxes" name="menuUpdateAddTaxes">Update/Add Taxes</a></li> removed by robert SR 4910 09.08.15-->
								<li><a id="menuUpdateManualInfo" name="menuUpdateManualInfo">Update Manual Information</a></li>
								<li><a id="menuUpdateInitialAcceptance" name="menuUpdateInitialAcceptance">Update Initial Acceptance</a></li>
								<li><a id="menuUpdatePolicyCoverage" name="menuUpdatePolicyCoverage">Update Policy Coverage</a></li>
								<li><a id="menuUpdatePictureAttachment" name="menuUpdatePictureAttachment">Update Picture Attachment</a></li>
								<li><a id="menuUpdateMVFileNo" name="menuUpdateMVFileNo">Update MV File No</a></li>
							</ul>
						</li>		
						<li class="menuSeparator"></li>
						<li><a id="generateNumber" name="generateNumber">Generate Number</a>
							<ul style="width: 180px;">
								<li><a id="menuGenBankRefNo" name="menuGenBankRefNo">Generate Bank Reference Number</a></li>
								<li><a id="genBondSeqNo" name="genBondSeqNo">Generate Bond Sequence Number</a></li>								
							</ul>
						</li>
					</ul>
				</li>
				<li><a>Policy Inquiries</a>
					<ul style="width: 230px;">
						<li><a id="viewParStatus">View PAR Status</a></li>
						<li><a id="viewPolicyStatus">View Policy Status</a></li>
						<li><a id="viewDistributionStatus">View Distribution Status</a></li>
						<li class="menuSeparator"></li>
						<li><a id="viewPolicyInformation">View Policy Information</a></li>
						<li><a id="viewInvoiceInformation">View Invoice Information</a></li>
						<li class="menuSeparator"></li>
						<li><a id="viewPackagePolicyInformation">View Package Policy Information</a></li>
						<li class="menuSeparator"></li>	
						<li><a id="viewBlockAccumulation">View Block Accumulation</a></li>
						<li><a id="viewVesselAccumulation">View Vessel Accumulation</a></li>
						<li><a id="viewPropertyFloaterAccumulation">View Property Floater Accumulation</a></li>
						<li class="menuSeparator"></li>
						<li><a id="viewProduction">View Production</a></li>
						<li class="menuSeparator"></li>
						<li><a id="viewMotorCarInquires" name="viewMotorCarInquires">View Motor Car Inquiries</a>
							<!-- <ul style="width: inherit;"> replaced by codes below robert SR 4938 09.08.15 --> 
							<ul style="width: 230px;"> <!-- robert SR 4938 09.08.15 -->
								<li><a id="viewMotorCarPolicy" name="viewMotorCarPolicy">View Motor Car Policy</a></li>
								<li><a id="motorCarPoliciesParListing" name="motorCarPoliciesParListing">Listing of Motorcar Policies/PARs</a></li>
								<li><a id="viewPolListingPerMake" name="viewPolListingPerMake">View Policy Listing per Make</a></li>
								<li><a id="viewPolListingPerMotorType" name="viewPolListingPerMotorType">View Policy Listing per Motor Type</a></li>
								<li><a id="viewPolListingPerPlateNo" name="viewPolListingPerPlateNo">View Policy Listing per Plate</a></li>
								<li><a id="viewCTPLPolicyListing" name="viewCTPLPolicyListing">View CTPL Policy Listing</a></li>
							</ul>
						</li>
						<li class="menuSeparator"></li>
						<li><a id="viewDeclarationPolicyPerOpenPolicy" name="viewDeclarationPolicyPerOpenPolicy">View Declaration Policy per Open Policy</a></li>
						<li class="menuSeparator"></li>
						<li><a id="viewPAInquires" name="viewPAInquires">View PA Inquiries</a>
							<!-- <ul style="width: inherit;"> replaced by codes below robert SR 4938 09.08.15 --> 
							<ul style="width: 230px;"> <!-- robert SR 4938 09.08.15 -->
								<li><a id="viewExposuresPerPAEnrollees" name="viewExposuresPerPAEnrollees">View Exposures per PA Enrollees</a></li>
								<li><a id="viewEnrolleeInformation" name="viewEnrolleeInformation">View Enrollee Information</a></li>
							</ul>
						</li>
						<li class="menuSeparator"></li>
						<li><a id="viewDiscountSurcharge">View Discounts/Surcharges</a></li>
						<li><a id="viewIntermediaryCommission">View Intermediary Commission</a></li>
						<li><a id="viewUserInformation">View User Information</a></li>
					</ul>
				</li>
				<li><a>RI Inquiries</a>
					<ul style="width: 260px;">
						<li><a id="viewInitialAcceptance">View Initial Acceptance</a></li>
						<li><a id="viewOutwardRiPaymentStatus">View Outward RI Payment Status</a></li>
						<li><a id="viewInwardRiPaymentStatus">View Inward RI Payment Status</a></li>
						<li><a id="viewRIPlacements">View RI Placements</a></li>
						<li><a id="inwardRIMenu">Inward RI/Broker Outstanding Accounts</a></li>
						<li><a id="viewOutwardRIMenu">View Outward RI/Broker Outstanding Accounts</a></li>
						<li><a id="viewBinderMenu">View Binder</a></li>
						<li><a id="viewBinderStatusMenu">View Binder Status</a></li>
						<li><a id="viewBinderList">View Binder List</a></li>
						<li><a id="viewPolWithPremPayments">List of Policies With Premium Payment Warranty</a></li>
						<li><a id="viewInwardTreaty">View Inward Treaty</a></li> <!-- benjo 08.03.2016 SR-5512 -->
					</ul>
				</li>
				<li><a>Maintenance</a>
					<ul style="width: 160px;">
						<li><a id="general" name="general">General</a>
							<ul style="width: 160px;">
								<li><a id="line" name="line">Line</a></li>
								<li><a id="menuSubline" name="menuSubline">Subline/Bond Type</a></li>
								<li><a id="menuIssuingSource" name="menuIssuingSource">Issuing Source</a></li>
								<li><a id="taxCharge" name="taxCharge">Tax Charge</a></li> <!-- Dren Niebres SR-5278 06.30.2016 - Start -->								
								<li><a id="perilMain" name="perilMain">Peril</a>
									<ul style="width: 160px;">
										<li><a id="peril" name="peril">Peril</a></li>
										<li><a id="menuPerilClass" name="menuPerilClass">Peril Class</a></li>
										<li><a id="perilsPerClass" name="perilsPerClass">Perils per Peril Class</a></li>
										<li><a id="perilGroup" name="perilGroup">Peril Group</a></li>
										<li><a id="defaultPerilRate" name="defaultPerilRate">Default Peril Rate</a></li>										
									</ul>
								</li>
								<li><a id="assuredMain" name="assuredMain">Assured</a>
									<ul style="width: 160px;">
										<!-- <li><a id="assured" name="assured">Assured</a></li> --> <!-- by bonok: old assured listing 01.03.2012 -->
										<li><a id="assuredTG" name="assured">Assured</a></li>
										<li><a id="menuControlType" name="menuControlType">Control Type</a></li>
										<li><a id="menuAssuredType" name="menuAssuredType">Assured Type</a></li>
										<li><a id="menuAssuredGroup" name="menuAssuredGroup">Assured Group</a></li>
										<li><a id="industryGroup" name="industryGroup">Industry Group</a></li>										
									</ul>
								</li>
								<li><a id="distributionMain" name="distributionMain">Distribution</a>
									<ul style="width: 160px;">
										<li><a id="distributionShare" name="distributionShare">Distribution Share</a></li>	
										<li><a id="defaultOneRiskDist" name="defaultOneRiskDist">Default One-Risk Dist</a></li>											
										<li><a id="menuDefPerilDist" name="menuDefPerilDist">Default Peril Dist</a></li>																		
									</ul>
								</li>
								<li><a id="menuBancassurance" name="menuBancassurance">Bancassurance</a>
									<ul style="width: 160px;">
										<li><a id="menuBancArea" name="menuBancArea">Area</a></li>
										<li><a id="menuBancBranch" name="menuBancBranch">Branch</a></li>
										<li><a id="menuBancaType" name="menuBancaType">Bancassurance Type</a></li>
									</ul>
								</li>
								<li><a id="depreciationMain" name="depreciationMain">Depreciation</a>
									<ul style="width: 160px;">
										<li><a id="perilDepreciation" name="perilDepreciation">Peril Depreciation</a></li>
										<li><a id="mcFairMarketValue" name="mcFairMarketValue">MC Fair Market Value</a></li>
										<li><a id="mcDepreciationRates" name="mcDepreciationRates">MC Depreciation Rates</a></li>																		
									</ul>
								</li>			
								<li><a id="reasons" name="reasons">Reasons</a>
									<ul style="width: 160px;">
										<li><a id="nonRenewalReason" name="nonRenewalReason">Non-Renewal Reason</a></li>
										<li><a id="menuReasonForSpoilage" name="menuReasonForSpoilage">Reason for Spoilage</a></li>
									</ul>																											
								</li>			
								<li><a id="signatoryMain" name="signatoryMain">Signatory</a>
									<ul style="width: 160px;">
										<li><a id="signatory" name="signatory">Signatory</a></li>	
										<li><a id="signatoryName" name="signatoryName">Signatory Name</a></li>	
									</ul>																											
								</li>	
								<li><a id="textMain" name="textMain">Text</a>
									<ul style="width: 160px;">
										<li><a id="warrantyAndClause" name="warrantyAndClause">Warranty and Clause</a></li>
										<li><a id="initialGeneralInfo" name="initialGeneralInfo">Initial/General Information</a></li>
										<li><a id="endorsementText" name="endorsementText">Endorsement Text</a></li>
									</ul>																											
								</li>		
								<li><a id="accessMain" name="accessMain">Access</a>
									<ul style="width: 160px;">
										<li><a id="postingLimit" name="postingLimit">Posting Limit</a></li>	
										<li><a id="approveInspection" name="approveInspection">Approve Inspection</a></li>											
									</ul>																											
								</li>															
								<li><a id="coverage" name="coverage">Coverage</a></li>											
								<li><a id="currency" name="currency">Currency</a>																
								<li><a id="deductibles" name="deductibles">Deductibles</a></li>								
								<li><a id="mortgagee" name="mortgagee">Mortgagee</a></li>																
								<li><a id="paymentTerm" name="paymentTerm">Payment Term</a></li>								
								<li><a id="policyType" name="policyType">Policy Type</a></li>								
								<li><a id="requiredPolicyDocument" name="requiredPolicyDocument">Required Policy Document</a></li>
								<li><a id="takeupTerm" name="takeupTerm">Take-Up Term</a></li> <!-- Dren Niebres SR-5278 06.30.2016 - End -->																
							</ul>							
						</li>						
						<li class="menuSeparator"></li>
	 					<li><a id="aviation" name="aviation">Aviation</a>
							<ul style="width: 160px;">
								<li><a id="aircraft" name="aircraft">Aircraft</a></li>		
								<li><a id="aircraftType" name="aircraftType">Aircraft Type</a></li>	
							</ul>
						</li>
						<li><a id="engineering" name="engineering">Engineering</a>
							<ul style="width: 160px;">
								<li><a id="enPrincipalContractor" name="enPrincipalContractor">Principal/Contractor</a></li>
								<li>
									<a id="enRegionProvince" name="enRegionProvince">Region/Province</a>
								</li>
							</ul>
						</li>
						<li><a id="fire" name="fire">Fire</a>
							<ul style="width: 160px;">
								<li><a id="fiRegionProvince" name="fiRegionProvince">Region/Province</a></li>
								<li><a id="districtBlock" name="districtBlock">District/Block</a></li>
								<li><a id="fireItemTypeMaintenance" name="fireItemTypeMaintenance">Fire Item Type</a></li>
								<li><a id="menuTariff" name="menuTariff">Tariff</a></li>
								<li><a id="tariffZone" name="tariffZone">Tariff Zone</a></li>
								<li><a id="earthquakeZone" name="earthquakeZone">Earthquake Zone</a></li>
								<li><a id="floodZone" name="floodZone">Flood Zone</a></li>
								<li><a id="typhoonZone" name="typhoonZone">Typhoon Zone</a></li>
								<li><a id="occupancy" name="occupancy">Occupancy</a></li>
								<li><a id="constructionType" name="constructionType">Construction Type</a></li>
								<li><a id="inspectorMaintenance" name="inspectorMaintenance">Inspector</a></li>								
							</ul>
						</li>
						<li><a id="marineCargo" name="marineCargo">Marine Cargo</a>
							<ul style="width: 160px;">
								<li>
									<a id="vesselMC" name="vesselMC">Vessel</a>
								</li>
								<li>
									<a id="vesselType" name="vesselType">Vessel Type</a>
								</li>
								<li>
									<a id="cargoType" name="cargoType">Cargo Type</a>
								</li>	
								<li>
									<a id="inlandVehicle" name="inlandVehicle">Inland Vehicle</a>
								</li>
								<li>
									<a id="cargoClass" name="cargoClass">Cargo Class</a>
								</li>	
								<li>
									<a id="geographyClass" name="geographyClass">Geography Class</a>
								</li>								
							</ul>
						</li>
	 					<li><a id="marineHull" name="marineHull">Marine Hull</a>
							<ul style="width: 160px;">
								<li>
									<a id="vesselMH" name="vesselMH">Vessel</a>
								</li>
								<li>
									<a id="vesselTypeMh" name="vesselTypeMh">Vessel Type</a>
								</li>
								<li>
									<a id="hullType" name="hullType">Hull Type</a>
								</li>
								<li>
									<a id="vesselClassification" name="vesselClassification">Vessel Classification</a>
								</li>															
							</ul>
						</li>
						<li><a id="motorCar" name="motorCar">Motor Car</a>
							<ul style="width: 160px;">
								<li><a id="MCSublineType" name="MCSublineType">Subline Type</a></li>
								<li><a id="motorType" name="motorType">Motor Type</a></li>
								<li><a id="menuCarMake" name="menuCarMake">Car Make</a></li>
								<li><a id="carManufacturer" name="carManufacturer">Car Manufacturer</a></li>
								<li><a id="carColor" name="carColor">Car Color</a></li>
								<li><a id="carTypeOfBody" name="carTypeOfBody">Car Type of Body</a></li>
								<li><a id="accessory" name="accessory">Accessory</a></li>
							</ul>
						</li>
						<li><a id="casualty" name="casualty">Misc. and Casualty</a>
							<ul style="width: 160px;">
								<li><a id="casualtySection" name="casualtySection">Casualty Section</a></li>
								<li><a id="casualtyLocation" name="casualtyLocation">Casualty Location</a></li>
							</ul>
						</li>
						<li><a id="accident" name="accident">Personal Accident</a>
							<ul style="width: 160px;">
								<li>
									<a id="employeePosition" name="employeePosition">Employee Position</a>
								</li>								
								<li>
									<a id="packageBenefit" name="packageBenefit">Package Benefit</a>	
								</li>
							</ul>
						</li>
						<li><a id="suretyBonds" name="suretyBonds">Surety Bonds</a>
							<ul style="width: 160px;">
								<li><a id="obligee" name="obligee">Obligee</a></li>
								<li><a id="menuNotaryPublic" name="menuNotaryPublic">Notary Public</a></li>
								<li><a id="principalSignatory" name="principalSignatory">Principal Signatory</a></li>
								<li><a id="menuSuretyBondsDefaultRateMaintenance" name="menuSuretyBondsDefaultRateMaintenance">Default Rate</a></li>								
								<li>
									<a id="bondClauseType" name="bondClauseType">Clause Type</a>
								</li>
								<li>
									<a id="collateralType" name="collateralType">Collateral Type</a>
								</li>
							</ul>
						</li>
 						<li class="menuSeparator"></li>
						<li><a id="package" name="package">Multi Line Package</a>
							<ul style="width: 190px;">
								<li>
									<a id="packageLineSublineCoverage" name="reportParameter">Package Line/Subline Coverage</a>
								</li>	
								<li>
									<a id="packageProductMaintenance" name="packageProductMaintenance">Package Product Maintenance</a>
								</li>						
							</ul>
						</li>
						<li><a id="reinsurance" name="reinsurance">Reinsurance</a>
							<ul style="width: 160px;">
								<li><a id="reinsurer" name="reinsurer">Reinsurer</a></li>	
								<li><a id="reinsurerType" name="reinsurerType">Reinsurer Type</a></li>	
								<li><a id="menuReinsurerStatus" name="menuReinsurerStatus">Reinsurer Status</a></li>	
								<li><a id="menuReinsuranceDocType" name="menuReinsuranceDocType">Reinsurance Document Type</a></li>	
								<li><a id="inwardTreaty" name="inwardTreaty">Inward Treaty</a></li>	
								<li><a id="nonProportionalTreaty" name="nonProportionalTreaty">Non-Proportional Treaty Peril</a></li>	
								<li><a id="proportionalTreaty" name="proportionalTreaty">Proportional Treaty Peril</a></li>	
								<li><a id="menuBinderStatus" name="menuBinderStatus">Binder Status</a></li>							
							</ul>
						</li>
						<li><a id="intermediary" name="intermediary">Intermediary</a> 
							<ul style="width: 200px;">
								<li><a id="intermediaryListing" name="intermediaryListing">Intermediary</a></li>	
								<li><a id="intermediaryType" name="intermediaryType">Intermediary Type</a></li>
								<li><a id="coIntermediaryType" name="coIntermediaryType">Co-Intermediary Type</a></li>
								<li><a id="menuIntmCommRate" name="menuIntmCommRate">Intermediary Commission Rate</a></li>
								<li><a id="intmTypeCommRt" name="intmTypeCommRt">Intermediary Type Commission Rate</a></li>
								<li><a id="coIntmTypeCommRt" name="coIntmTypeCommRt">Co-Intermediary Type Commission Rate</a></li>
								<li><a id="menuSpecialOverridingCommRateMaintenance">Special Overriding Commission Rate</a></li>
								<li><a id="menuSlidingCommRate" name="menuSlidingCommRate">Sliding Commission Rate</a></li>						
							</ul>
						</li>
						<li><a id="system" name="system">System</a> 
							<ul style="width: 160px;">
								<li><a id="systemParameter" name="systemParameter">System Parameter</a></li>
								<li><a id="programParameter" name="programParameter">Program Parameter</a></li>
								<li>
									<a id="reportParameter" name="reportParameter">Report Parameter</a>
								</li>
								<li><a id="reportMaintenance" name="reportMaintenance">Report</a></li>						
							</ul>
						</li>
					</ul>
				</li>
				<li><a id="menuWorkflow" name="menuWorkflow">Workflow</a></li>
			</ul>
		</div>
	</div>
</div>

<script type="text/JavaScript">	
	setModuleId();
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
	
	// Policy Issuance
	observeAccessibleModule(accessType.MENU, "GIPIS050", "parCreation", showPARCreationPage);
	observeAccessibleModule(accessType.MENU, "GIPIS001", "parListing", function() {getLineListingForPAR("N");});
	observeAccessibleModule(accessType.MENU, "GIPIS056", "endtParCreation", showEndtParCreationPage);
	observeAccessibleModule(accessType.MENU, "GIPIS058", "endtParListing", function() {getLineListingForEndtPAR("N");});
	observeAccessibleModule(accessType.MENU, "GIPIS050A", "packParCreation", function() {showPackPARCreationPage();});
	observeAccessibleModule(accessType.MENU, "GIPIS001A", "packParListing", function() {packRiTag = null;getLineListingForPackagePAR("N");}); // nica 11.03.2010
	observeAccessibleModule(accessType.MENU, "GIPIS056A", "packEndtParCreation", function() {showEndtPackParCreationPage();}); // nica 01.10.2011
	observeAccessibleModule(accessType.MENU, "GIPIS058A", "packEndtParListing", function() {packRiTag = null;getLineListingForEndtPackagePAR("N");}); // eman 11.17.2010

	//Distribution
	observeAccessibleModule(accessType.MENU, "GIUWS010", "setupGroupsDistItem", showSetUpGroupsForDistPage);
	observeAccessibleModule(accessType.MENU, "GIUWS018", "setupGroupsDistPeril", showSetUpGroupsForDistPeril);
	//observeAccessibleModule(accessType.MENU, "GIUWS013", "distByGrp", showDistributionByGroup); //tonio 07.15.2011 removed by robert SR 5053 11.11.15
	observeAccessibleModule(accessType.MENU, "GIUWS012", "distByPeril", showDistributionByPeril); // emman 07.19.2011
	observeAccessibleModule(accessType.MENU, "GIUTS002", "negPostedDist", showNegPostedDist); // robert 07.27.2011
	observeAccessibleModule(accessType.MENU, "GIUWS015", "batchDist", showBatchDistribution); // nica 07.28.2011
	observeAccessibleModule(accessType.MENU, "GIUWS016", "distByTSIGrp", showDistrByTsiPremGroup); // nica 07.28.2011
	//observeAccessibleModule(accessType.MENU, "GIUWS017", "distByTSIPeril", showDistByTsiPremPeril); removed by robert SR 5053 11.11.15
	observeAccessibleModule(accessType.MENU, "GIUTS021", "redistribution", showRedistribution); // emman 08.11.2011
	observeAccessibleModule(accessType.MENU, "GIUTS999", "popuMissDistRec", showPopuMissDistRec);  //removed by robert SR 5053 11.11.15 //re added by gab SR 5603 10.03.2016
			
	// Reinsurance
	//observeAccessibleModule(accessType.MENU, "GIPIS050", "riParCreation", function() {showPARCreationPage("Y");});
	observeAccessibleModule(accessType.MENU, "GIRIS001", "createRiPlacement", function() {showCreateRiPlacementPage();});
	observeAccessibleModule(accessType.MENU, "GIRIS002", "enterRiAcceptance", function() {riAcceptSearch="Y";showEnterRIAcceptancePage();});
	observeAccessibleModule(accessType.MENU, "GIRIS053", "groupBinders", function() {showGroupBindersTableGridListing();});// emsy 12.22.2011 
	observeAccessibleModule(accessType.MENU, "GIRIS006", "frpsListing", function() {getLineListingForFRPS();}); //belle 06.22.2011
	observeAccessibleModule(accessType.MENU, "GIRIS005", "riParCreation", function() {parCtr = 0; showRIParCreationPage("0","P");}); //Patrick Cruz 01.04.2012 - added parCtr
	observeAccessibleModule(accessType.MENU, "GIRIS053A", "riGenPackageBinders", function() {showGeneratePackageBinders();});
	observeAccessibleModule(accessType.MENU, "GIRIS056", "intreatyListing", showIntreatyListing); //benjo 08.03.2016 SR-5512
	observeAccessibleModule(accessType.MENU, "GIPIS001", "riParListing", function() {getLineListingForPAR("Y");});
	observeAccessibleModule(accessType.MENU, "GIPIS056", "riEndtParCreation", function() {parCtr = 1; showRIParCreationPage("0","E");}); //Patrick Cruz 01.04.2012 - added parCtr
	observeAccessibleModule(accessType.MENU, "GIPIS058", "riEndtParListing", function() {getLineListingForEndtPAR("Y");});
	observeAccessibleModule(accessType.MENU, "GIRIS005A", "riPackParCreation", function() {showRIPackParCreationPage("0","P");});// irwin 5.29.2012
	observeAccessibleModule(accessType.MENU, "GIPIS001A", "riPackParListing", function() {getLineListingForPackagePAR("Y");}); // nica 11.03.2010
	observeAccessibleModule(accessType.MENU, "GIRIS005A", "riPackEndtParCreation", function() {showRIPackParCreationPage("0","E");}); // irwin 5.29.2012
	observeAccessibleModule(accessType.MENU, "GIPIS058A", "riPackEndtParListing", function() {getLineListingForEndtPackagePAR("Y");}); // eman 11.17.2010
	observeAccessibleModule(accessType.MENU, "GIUTS004", "reverseBinder", function() {showReverseBinderPage("Y");}); // robert 08.09.2011
	observeAccessibleModule(accessType.MENU, "GIPIS175", "updateInwardRIComm", showUpdateInwardRIComm);
	observeAccessibleModule(accessType.MENU, "GIUTS024", "genBinderNonAffEndt", function() {showGenBinderNonAffEndtPage();}); // robert 01.03.2012
	observeAccessibleModule(accessType.MENU, "GIRIS051", "riReportsPrinting", function() {showGenerateRIReportsPage("binderTab");});	//shan 01.15.2013
	
	// Renewal Processing
	observeAccessibleModule(accessType.MENU, "GIEXS001", "extractExpiringPolicies", showExtractExpiringPoliciesPage); // robert 08.25.2011
	observeAccessibleModule(accessType.MENU, "GIEXS003", "purgeExtractedPolicies", showPurgeExtractTablePage); // marco 03.16.2012
	observeAccessibleModule(accessType.MENU, "GIEXS004", "processExpiringPolicies", showProcessExpiringPoliciesPage); // robert 09.16.2011
	observeAccessibleModule(accessType.MENU, "GIEXS009", "businessConservation", showBusinessConservationPage); // marco 01.10.2012
	observeAccessibleModule(accessType.MENU, "GIEXS006", "printExpiryReportRenewals", showPrintExpiryReportRenewalsPage); // bonok 03.21.2012
	observeAccessibleModule(accessType.MENU, "GIEXS008", "assignExtractedExpiryRecord", showAssignExtractedExpiryRecord); // Kenneth 07.31.2013 
	observeAccessibleModule(accessType.MENU, "GIPIS179", "viewRenewal", showViewRenewal);
	
	// Reports Printing
	observeAccessibleModule(accessType.MENU, "GIUTS031", "extractExpiringCovernote", showExtractExpiringCovernote);
	//shan 09.02.2013
	observeAccessibleModule(accessType.MENU, "GIPIS901", "menuGenerateStatisticalReports", function(){
		showGIPIS901("statisticalTab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIPIS902", "menuRiskAndLossProfile", showGIPIS902); //apollo 08.12.2014	
	
	observeAccessibleModule(accessType.MENU, "GIPIS170", "menuBatchPrinting", showBatchPrinting);
	observeAccessibleModule(accessType.MENU, "GIPIS203", "menuRecapitulation", showUWRecapsVI);
	observeAccessibleModule(accessType.MENU, "GIPIS191", "menuRiskCategory", showGIPIS191RiskCategory);
	observeAccessibleModule(accessType.MENU, "GIPIS091", "reprintPolicyDocuments", showRegeneratePolicyDocumentsPage);
	observeAccessibleModule(accessType.MENU, "GIPIS159", "printPolicyCertificates", showPolicyCertificatesPage);
	observeAccessibleModule(accessType.MENU, "GIUTS023", "enrolleeCertificate", showGIUTS023EnrolleeCertificate); // Pol Cruz 04.29.2013
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "uwProductionReports", showUWProductionReportsMainPage); // marco 04.20.2012

	// File Maintenance
	//observeAccessibleModule(accessType.MENU, "GIISS006", "assured", showAssuredListing); // WRING MODULE ID - TEMPORARY // rencela 03.01.2011
	observeAccessibleModule(accessType.MENU, "GIISS034", "warrantyAndClause", showWarrantyAndClause); //Gzelle 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIISS006", "assuredTG", function(){ //by Bonok: test case 01.03.2012
																			exitCtr = 0;
																			assuredListingTableGridExit = 0;//MarkS 04.08.2016 SR-21916
																			showAssuredListingTableGrid();	
																		});
	observeAccessibleModule(accessType.MENU, "GIISS096", "packageLineSublineCoverage", showPackageLineSublineCoverage); //Fons 09.06.2013	
	observeAccessibleModule(accessType.MENU, "GIISS119", "reportParameter", showReportParameterMaintenance); //Fons 08.06.2013	
	observeAccessibleModule(accessType.MENU, "GIISS090", "reportMaintenance", showGiiss090);
	observeAccessibleModule(accessType.MENU, "GIISS068", "enPrincipalContractor", showGiiss068);
	observeAccessibleModule(accessType.MENU, "GIISS024", "enRegionProvince", showGiiss024);
	observeAccessibleModule(accessType.MENU, "GIISS024", "fiRegionProvince", showGiiss024);
	observeAccessibleModule(accessType.MENU, "GIISS012", "fireItemTypeMaintenance", showGiiss012);
	observeAccessibleModule(accessType.MENU, "GIISS017", "obligee", function(){
		objUW.fromMenu = "obligee";
		showObligeeMaintenance();
	}); //Kris 10.29.2012
	observeAccessibleModule(accessType.MENU, "GIISS016", "menuNotaryPublic", function() {
		objUW.fromMenu = "notaryPublic";	//modified by Gzelle 10132014 
		showGiiss016();
	});
	observeAccessibleModule(accessType.MENU, "GIISS098", "constructionType", showGiiss098);
	observeAccessibleModule(accessType.MENU, "GIISS099", "bondClauseType", showGiiss099);//Gzelle 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS073", "menuReinsurerStatus", showGiiss073);
	observeAccessibleModule(accessType.MENU, "GIISS074", "menuReinsuranceDocType", showGIISS074); //john 11.05.2013
	
	observeAccessibleModule(accessType.MENU, "GIISS001", "line", showGiiss001); //Dwight 06.14.2012 //change by steven 12.11.2013
	observeAccessibleModule(accessType.MENU, "GIISS004", "menuIssuingSource", showGiiss004);	//shan 11.05.2013
	observeAccessibleModule(accessType.MENU, "GIISS014", "menuAssuredType", showGiiss014); //pol cruz 11.07.2013
	observeAccessibleModule(accessType.MENU, "GIISS108", "menuControlType", showGIISS108);
	observeAccessibleModule(accessType.MENU, "GIISS118", "menuAssuredGroup", showGiiss118);
	observeAccessibleModule(accessType.MENU, "GIISS210", "nonRenewalReason", showGIISS210); //Gzelle 11.26.2013
	observeAccessibleModule(accessType.MENU, "GIISS050", "inlandVehicle", showGIISS050); //Gzelle 11.27.2013
	observeAccessibleModule(accessType.MENU, "GIISS212", "menuReasonForSpoilage", showGiiss212);
	observeAccessibleModule(accessType.MENU, "GIISS002", "menuSubline", showSublineMaintenance); //Irene 09.26.2012
	observeAccessibleModule(accessType.MENU, "GIISS018", "paymentTerm", showPaymentTerm); //Kenneth 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIISS022", "principalSignatory", showPrincipalSignatory); // Irwin 05.23.2011
	observeAccessibleModule(accessType.MENU, "GIISS043", "menuSuretyBondsDefaultRateMaintenance", showGiiss043);	
	observeAccessibleModule(accessType.MENU, "GIISS003", "peril", showPerilMaintenance); // Cherrie 10.16.2012
	observeAccessibleModule(accessType.MENU, "GIISS060", "distributionShare", showDistributionShare); // Halley 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIISS116", "signatory", showSignatoryMaintenance); //Reymon 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIISS207", "postingLimit", showPostingLimitMaintenance); // Mae 10.16.2012
	observeAccessibleModule(accessType.MENU, "GIISS009", "currency", showGIISS009); // Joms 10.18.12	
	observeAccessibleModule(accessType.MENU, "GIISS062", "perilsPerClass", showPerilsPerClass); // Ronnie 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIISS208", "perilDepreciation", showPerilDepreciationMaintenance); // Christopher 10.16.2012
	/* observeAccessibleModule(accessType.MENU, "GIISS035", "requiredPolicyDocument", showRequiredPolicyDocument); */ // MAC 10.15.2012 - comment out: john 
	observeAccessibleModule(accessType.MENU, "GIISS035", "requiredPolicyDocument", showGiiss035);
	observeAccessibleModule(accessType.MENU, "GIISS105", "mortgagee", showMortgageeMaintenance); // JON 10.18.2012
	observeAccessibleModule(accessType.MENU, "GIISS052", "typhoonZone", showTyphoonZoneMaintenance); //Fons 09.02.2013
	observeAccessibleModule(accessType.MENU, "GIISS169", "inspectorMaintenance", showGiiss169); //bonok 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS053", "floodZone", showGiiss053);
	observeAccessibleModule(accessType.MENU, "GIISS008", "cargoType", showCargoClass); //Fons 09.11.2013	
	observeAccessibleModule(accessType.MENU, "GIISS051", "cargoClass", showGiiss051); //Fons 11.11.2013	
	observeAccessibleModule(accessType.MENU, "GIISS080", "geographyClass", showGeographyClass); //Fons 09.11.2013
	observeAccessibleModule(accessType.MENU, "GIISS209", "menuBinderStatus", showGiiss209); // J. Diago 09.19.2013
	observeAccessibleModule(accessType.MENU, "GIISS030", "reinsurer", showReinsurer); //Fons 09.16.2013	
	observeAccessibleModule(accessType.MENU, "GIISS025", "reinsurerType", showGiiss025); //Fons 10.22.2013	
	observeAccessibleModule(accessType.MENU, "GIISS047", "vesselClassification", showVesselClassification); //Fons 09.23.2013
	observeAccessibleModule(accessType.MENU, "GIISS056", "MCSublineType", showGiiss056);
	observeAccessibleModule(accessType.MENU, "GIISS055", "motorType", showMotorType); //Fons 09.24.2013
	observeAccessibleModule(accessType.MENU, "GIISS103", "menuCarMake", showGIISS103);
	observeAccessibleModule(accessType.MENU, "GIISS115", "carManufacturer", showGiiss115);
	observeAccessibleModule(accessType.MENU, "GIISS046", "hullType", showGiiss046); //Kenenth L. 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS083", "intermediaryType", showIntermediaryTypeMaintenance); //Fons 09.30.2013
	observeAccessibleModule(accessType.MENU, "GIISS063", "menuPerilClass", showGiiss063);
	observeAccessibleModule(accessType.MENU, "GIISS048", "aircraftType", showGIISS048); //John 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS049", "aircraft", showGIISS049); //John 10.29.2013
	observeAccessibleModule(accessType.MENU, "GIISS077", "vesselType", showGiiss077); //J. Diago 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS077", "vesselTypeMh", showGiiss077); //J. Diago 01.24.2013
	observeAccessibleModule(accessType.MENU, "GIISS091", "policyType", showGiiss091); //J. Diago 11.04.2013
	observeAccessibleModule(accessType.MENU, "GIISS113", "coverage", showGiiss113); //J. Diago 11.13.2013
	observeAccessibleModule(accessType.MENU, "GIISS117", "carTypeOfBody", showGIISS117); //John 10.31.2013
	observeAccessibleModule(accessType.MENU, "GIISS084", "coIntmTypeCommRt", showGiiss084); //J. Diago 11.05.2013
	observeAccessibleModule(accessType.MENU, "GIISS202", "menuSpecialOverridingCommRateMaintenance", showGiiss202);
	observeAccessibleModule(accessType.MENU, "GIISS213", "perilGroup", showGIISS213); //Kenneth 11.05.2013
	observeAccessibleModule(accessType.MENU, "GIISS020", "casualtySection", showGiiss020);
	observeAccessibleModule(accessType.MENU, "GIISS217", "casualtyLocation", showGiiss217); //Fons 11.06.2013
	observeAccessibleModule(accessType.MENU, "GIISS104", "endorsementText", showGiiss104); //J. Diago 11.14.2013
	observeAccessibleModule(accessType.MENU, "GIISS114", "carColor", showGiiss114); //Fons 11.12.2013
	observeAccessibleModule(accessType.MENU, "GIISS201", "intmTypeCommRt", showGiiss201);
	observeAccessibleModule(accessType.MENU, "GIISS011", "earthquakeZone", showGiiss011); //Fons 11.18.2013
	observeAccessibleModule(accessType.MENU, "GIISS028", "taxCharge", showGiiss028); //Kenneth 11.19.2013
	observeAccessibleModule(accessType.MENU, "GIISS054", "tariffZone", showGiiss054); //Fons 11.19.2013
	observeAccessibleModule(accessType.MENU, "GIISS215", "menuBancArea", showGiiss215);
	observeAccessibleModule(accessType.MENU, "GIISS216", "menuBancBranch", showGiiss216);
	observeAccessibleModule(accessType.MENU, "GIISS218", "menuBancaType", showGiiss218);
	observeAccessibleModule(accessType.MENU, "GIISS120", "packageBenefit", showGiiss120); //steven 11.25.2013
	observeAccessibleModule(accessType.MENU, "GIISS097", "occupancy", showGiiss097); //Fons 11.21.2013
	observeAccessibleModule(accessType.MENU, "GIISS205", "industryGroup", showGiiss205); //J. Diago 11.26.2013
	observeAccessibleModule(accessType.MENU, "GIISS023", "employeePosition", showGiiss023); //John 11.26.2013
	observeAccessibleModule(accessType.MENU, "GIISS107", "accessory", showGiiss107); //Fons 11.25.2013
	observeAccessibleModule(accessType.MENU, "GIISS219", "packageProductMaintenance", showGiiss219); //steven 11.27.2013
	observeAccessibleModule(accessType.MENU, "GIISS075", "coIntermediaryType", showGiiss075); //Fons 11.26.2013
	observeAccessibleModule(accessType.MENU, "GIISS085", "systemParameter", showGiiss085); //Fons 11.28.2013 
	observeAccessibleModule(accessType.MENU, "GIISS061", "programParameter", showGiiss061);
	observeAccessibleModule(accessType.MENU, "GIISS005", "menuTariff", showGIISS005);
	observeAccessibleModule(accessType.MENU, "GIISS082", "menuIntmCommRate", showGIISS082);
	observeAccessibleModule(accessType.MENU, "GIISS220", "menuSlidingCommRate", showGIISS220);
	observeAccessibleModule(accessType.MENU, "GIISS007", "districtBlock", showGiiss007);//Fons 11.28.2013 
	observeAccessibleModule(accessType.MENU, "GIISS165", "menuDefPerilDist", showGiiss165);
	
	//Policy Inquiries
	observeAccessibleModule(accessType.MENU, "GIPIS131", "viewParStatus", showGIPIS131); //Pol Cruz 4.11.2013
	observeAccessibleModule(accessType.MENU, "GIPIS132", "viewPolicyStatus", showGIPIS132); //Pol Cruz 4.16.2013
	observeAccessibleModule(accessType.MENU, "GIPIS100", "viewPolicyInformation", showViewPolicyInformationPage);
	observeAccessibleModule(accessType.MENU, "GIPIS137", "viewInvoiceInformation", showViewInvoiceInformationPage); // Kris 09.09.2013
	observeAccessibleModule(accessType.MENU, "GIPIS130", "viewDistributionStatus", showViewDistributionStatus); //Joms Diago 04.29.2013
	observeAccessibleModule(accessType.MENU, "GIPIS110", "viewBlockAccumulation", showViewBlockAccumulation); //steven 10.03.2013  
	observeAccessibleModule(accessType.MENU, "GIPIS109", "viewVesselAccumulation", showViewVesselAccumulation); //steven 09.06.2013  
	observeAccessibleModule(accessType.MENU, "GIPIS111", "viewPropertyFloaterAccumulation", showViewPropertyFloaterAccumulation); //steven 09.24.2013
	observeAccessibleModule(accessType.MENU, "GIPIS200", "viewProduction", showViewProduction); //Fons 10.01.2013
	observeAccessibleModule(accessType.MENU, "GIPIS100A", "viewPackagePolicyInformation", showPackagePolicyInformation); //John Dolon 9.2.2013
	observeAccessibleModule(accessType.MENU, "GIPIS190", "viewDiscountSurcharge", showGIPIS190);
	observeAccessibleModule(accessType.MENU, "GIPIS139", "viewIntermediaryCommission", showViewIntermediaryCommission); //steven 09.12.2013
	observeAccessibleModule(accessType.MENU, "GIPIS116", "viewMotorCarPolicy", getMotorCarInquiryRecords); //Kenneth L. 09.11.2013
	observeAccessibleModule(accessType.MENU, "GIISS223", "mcFairMarketValue", showMcFairMarketValueMaintenance);  // Dren Niebres SR-5278 06.30.2016
	observeAccessibleModule(accessType.MENU, "GIISS224", "mcDepreciationRates", showMcDepreciationRateMaintenance);  // Dren Niebres SR-5278 08.02.2016
	observeAccessibleModule(accessType.MENU, "GIPIS211", "motorCarPoliciesParListing", function(){ //shan 10.02.2013
		new Ajax.Request(contextPath+"/GIPIPARListController", {
			parameters: {
				action:			"showGIPIS211",
				globalParId:	objUWGlobal.parId,
				globalLineCd:	objUWGlobal.lineCd
			},
			onCreate: showNotice("Loading Listing of Motorcar Policies/PARs, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	});	
	observeAccessibleModule(accessType.MENU, "GIPIS152", "viewUserInformation", showViewUserInformation); //Gzelle 09.26.2013
	observeAccessibleModule(accessType.MENU, "GIPIS199", "viewDeclarationPolicyPerOpenPolicy", showViewDeclarationPolicyPerOpenPolicy); // Kris 10.29.2013
	observeAccessibleModule(accessType.MENU, "GIPIS206", "viewCTPLPolicyListing", showCTPLPolicyListing);
	observeAccessibleModule(accessType.MENU, "GIPIS209", "viewExposuresPerPAEnrollees", showExposuresPerPAEnrollees);
	observeAccessibleModule(accessType.MENU, "GIPIS193", "viewPolListingPerPlateNo", function(){	// shan 10.09.2013
		new Ajax.Request(contextPath+"/GIPIVehicleController", {
			parameters: {
				action:			"showGIPIS193PolListing"
			},
			onCreate: showNotice("Loading View Policy Listing Per Plate No page, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}); 
	observeAccessibleModule(accessType.MENU, "GIPIS212", "viewEnrolleeInformation", showGipis212); // J. Diago 10.08.2013
	
	observeAccessibleModule(accessType.MENU, "GIPIS192", "viewPolListingPerMake", showPolListingPerMake); //John Dolon 9.16.2013
	observeAccessibleModule(accessType.MENU, "GIPIS194", "viewPolListingPerMotorType", showPolListingPerMotorType);
	
	//RI Inquiries
	observeAccessibleModule(accessType.MENU, "GIRIS027", "viewInitialAcceptance", showGIRIS027); // Pol Cruz 07.17.2014
	observeAccessibleModule(accessType.MENU, "GIRIS012", "viewOutwardRiPaymentStatus", showOutwardRiPaymentStatus); // Pol Cruz 10.09.2013
	observeAccessibleModule(accessType.MENU, "GIRIS013", "viewInwardRiPaymentStatus", showInwardRiPaymentStatus); // J. Diago 09.09.2013
	
	//Utilities
	observeAccessibleModule(accessType.MENU, "GIPIS207", "batchPosting", getLineListingForBatchPosting);	//Gzelle 08.22.2013
	observeAccessibleModule(accessType.MENU, "GIPIS197", "inspectionReport", showInspectionListing); //angelo 04.05.2011
	observeAccessibleModule(accessType.MENU, "GIUTS008", "copyPolicyEndt", showCopyPolicyEndt);
	observeAccessibleModule(accessType.MENU, "GIUTS036", "genBondSeqNo", showGenerateBondSeqNoPage); // Udel 06.20.2012
	observeAccessibleModule(accessType.MENU, "GIUTS007", "copyPAR", showCopyParToNewPar); //rmanalad 06.13.2012	
	observeAccessibleModule(accessType.MENU, "GIUTS009", "summarizePolicy", showSummarizePolicy);
	observeAccessibleModule(accessType.MENU, "GIUTS008A", "copyPackPolicy", function (){ checkUserAccessGiuts("GIUTS008A");}); // bonok :: 02.11.2013
	observeAccessibleModule(accessType.MENU, "GIUTS003", "spoilPolicy", function (){ checkUserAccessGiuts("GIUTS003");}); // bonok :: 02.21.2013
	observeAccessibleModule(accessType.MENU, "GIUTS028", "menuReinstatement", function (){ checkUserAccessGiuts("GIUTS028");}); // jomsdiago 07.25.2013
	observeAccessibleModule(accessType.MENU, "GIUTS012", "riConfirmBinder", function() { checkUserAccessGiuts("GIUTS012");});	// Joms 08.14.2013
	observeAccessibleModule(accessType.MENU, "GIUTS028A", "menuReinstatementPack", function (){ checkUserAccessGiuts("GIUTS028A");}); // jomsdiago 07.29.2013
	observeAccessibleModule(accessType.MENU, "GIUTS003A", "menuSpoilPackPolicy", function (){ checkUserAccessGiuts("GIUTS003A");});	//shan 02.22.2013		
	//observeAccessibleModule(accessType.MENU, "GIPIS018", "menuEnterCollateralTransaction", ""/* your function here */);	
	//observeAccessibleModule(accessType.MENU, "GIPIS074", "menuReleaseCollateral", ""/* your function here */);
	observeAccessibleModule(accessType.MENU, "GIPIS051", "reassignParPolicy", showReassignParPolicyListing); // Steven 06.13.2012
	observeAccessibleModule(accessType.MENU, "GIPIS057", "menuReassignParEndt", showReassignParEndtListing); // Steven 03.13.2013
	observeAccessibleModule(accessType.MENU, "GIPIS047", "menuUpdateBondPolicy", showUpdateBondPolicy);// Steven 09.02.2013
	
	observeAccessibleModule(accessType.MENU, "GIPIS155", "menuUpdatePolicyDistrictEtc", function(){	//shan 09.26.2013
		/* new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
			parameters : {
					action : 	"getGipis155FireItemListing"
			},
			onCreate : showNotice("Loading Update Policy District/Block/EQ/FLD/TPN/TRF, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		}); */
		showGipis155();		// moved to underwriting.js 12.06.2013
	});
	
	observeAccessibleModule(accessType.MENU, "GIPIS156", "menuUpdatePolicyBookingDateEtc", showUpdatePolicyBookingDateEtc);
	//observeAccessibleModule(accessType.MENU, "GIPIS161", "updateInitialEtc", showUpdateInitialEtc); //Gzelle 09.13.2013 // SR-21812 JET JUN-22-2016
	observeAccessibleModule(accessType.MENU, "GIPIS161", "updateInitEtcNonPackPol", showUpdateInitialEtc); // SR-21812 JET JUN-20-2016
	observeAccessibleModule(accessType.MENU, "GIPIS161A", "updateInitEtcPackPol", showUpdateInitialEtcPack); // SR-21812 JET JUN-23-2016
	//observeAccessibleModule(accessType.MENU, "GIPIS177", "menuUpdateAddTaxes", ""/* your function here */); removed by robert SR 4910 09.08.15
	observeAccessibleModule(accessType.MENU, "GIUTS025", "menuUpdateManualInfo", showGIUTS025);		//shan 10.07.2013
	observeAccessibleModule(accessType.MENU, "GIUTS027", "menuUpdatePolicyCoverage", showUpdatePolicyCoverage);
	observeAccessibleModule(accessType.MENU, "GIUTS029", "menuUpdatePictureAttachment", showGIUTS029);
	observeAccessibleModule(accessType.MENU, "GIUTS032", "menuUpdateMVFileNo", showUpdateMVFileNo); //09.26.2013
	observeAccessibleModule(accessType.MENU, "GIUTS035", "menuGenBankRefNo", showGenerateBankRefNo);
	observeAccessibleModule(accessType.MENU, "GIPIS171", "menuUpdateAddWarrCla", function(){checkUserAccess2Gipis("GIPIS171");});//Edison 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIUTS026", "menuUpdateInitialAcceptance", showUpdateInitialAcceptance);//Joms 10.15.2012
	observeAccessibleModule(accessType.MENU, "GIPIS162", "menuUpdatePolicyBookingTag", checkUserAccessGipis162);  // Shan 02.19.2013
	
	//RI Inquiries
	observeAccessibleModule(accessType.MENU, "GIRIS015", "viewRIPlacements", showViewRIPlacements);
	observeAccessibleModule(accessType.MENU, "GIRIS016", "viewBinderMenu", showViewBinder);
	observeAccessibleModule(accessType.MENU, "GIRIS019", "inwardRIMenu", showInwardRIMenu);
	observeAccessibleModule(accessType.MENU, "GIRIS020", "viewOutwardRIMenu", showBrokerOutstandingAccts); 
	observeAccessibleModule(accessType.MENU, "GIUTS030", "viewBinderList", showBinderList);	
	observeAccessibleModule(accessType.MENU, "GIPIS214", "viewPolWithPremPayments", showPolWithPremPayments);
	observeAccessibleModule(accessType.MENU, "GIRIS055", "viewBinderStatusMenu", showGiris055); // J. Diago 10.02.2013
	observeAccessibleModule(accessType.MENU, "GIRIS057", "viewInwardTreaty", showViewIntreaty); //benjo 08.03.2016 SR-5512

	observeAccessibleModule(accessType.MENU, "GIISS102", "collateralType", showGiiss102); // shan 10.22.2013
	observeAccessibleModule(accessType.MENU, "GIISS010", "deductibles", showGiiss010); // shan 10.24.2013
	observeAccessibleModule(accessType.MENU, "GIISS211", "takeupTerm", showGiiss211); // shan 10.31.2013
	observeAccessibleModule(accessType.MENU, "GIISS203", "intermediaryListing", showGiiss203); // shan 11.07.2013
	observeAccessibleModule(accessType.MENU, "GIISS032", "inwardTreaty", showGiiss032);
	observeAccessibleModule(accessType.MENU, "GIISS071", "signatoryName", showGiiss071); // shan 11.27.2013
	observeAccessibleModule(accessType.MENU, "GIISS039", "vesselMC", showGiiss039); // shan 12.02.2013
	observeAccessibleModule(accessType.MENU, "GIISS039", "vesselMH", showGiiss039); // shan 12.02.2013
	observeAccessibleModule(accessType.MENU, "GIISS180", "initialGeneralInfo", showGiiss180); // shan 12.10.2013
	observeAccessibleModule(accessType.MENU, "GIISS065", "defaultOneRiskDist", showGiiss065);
	observeAccessibleModule(accessType.MENU, "GIISS106", "defaultPerilRate", showGiiss106); // shan 12.19.2013
	
	observeAccessibleModule(accessType.MENU, "WOFLO001", "menuWorkflow", function () {
		objWorkflow = {};
		showWorkflow();
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS007", "nonProportionalTreaty", function(){
		objUWGlobal.module = "menu";
		objGiris007.proportionalTreaty = "N";
		showGiris007();
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS007", "proportionalTreaty", function(){
		objUWGlobal.module = "menu";
		objGiris007.proportionalTreaty = "Y";
		showGiris007();
	});
</script>

<!--END UNDERWRITING NAV   -->
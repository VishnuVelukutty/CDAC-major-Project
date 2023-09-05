package chaincode
import (
	"encoding/json"
	"fmt"
	
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	// "github.com/hyperledger/fabric/msp"
	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"

)

type TestContract struct {
	contractapi.Contract
}

type LoanRequest struct {
	RequestID			string			`json:"RequestID"`
	RequesterName		string			`json:"RequesterName"`
	LoanAmount			string			`json:"LoanAmount"`
	InterestRate		float64			`json:"InterestRate"`
	NoOfYears			int				`json:"NoOfYears"`
	ModeOfRepayment		string			`json:"ModeOfRepayment"`
	ApprovedStatus		bool			`json:"ApprovedStatus"`
	DisbursedStatus		bool			`json:"DisbursedStatus"`
	RepaymentStatus		bool			`json:"RepaymentStatus"`
	Consent				bool			`json:"Consent"`
	RegulatoryCheck		bool			`json:"RegulatoryCheck"`
	ApprovedBy			ApproverGroup	`json:"ApprovedBy"`
}

type ApproverGroup struct {
	ApproverName	string	`json:"ApproverName"`
	LoanOffered		string		`json:LoanOffered`
}

type Regulator struct {
	MspId	string		`json:"MspId"`
}

//InitLEdger adds some loan requests to the ledger to set a base.
func (t *TestContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	
	loanRequests := []LoanRequest{
		{
			RequestID: "request1", 
			RequesterName: "John", 
			LoanAmount: "50 lakhs", 
			InterestRate: 3.5,
			NoOfYears: 5,
			ModeOfRepayment: "lumpsum",
			ApprovedStatus: false,
			DisbursedStatus: false,
			RepaymentStatus: false,
			Consent: false,
			RegulatoryCheck: false,
			ApprovedBy: ApproverGroup{ApproverName: "", LoanOffered: ""},
		},
		{
			RequestID: "request2", 
			RequesterName: "Mark", 
			LoanAmount: "10 lakhs", 
			InterestRate: 5.0,
			NoOfYears: 1,
			ModeOfRepayment: "emi",
			ApprovedStatus: true,
			DisbursedStatus: true,
			RepaymentStatus: true,
			Consent: true,
			RegulatoryCheck: true,
			ApprovedBy: ApproverGroup{ApproverName: "Axis", LoanOffered: "50 lakhs"},
		},
		{
			RequestID: "request3", 
			RequesterName: "Jane", 
			LoanAmount: "1 crore", 
			InterestRate: 2.0,
			NoOfYears: 7,
			ModeOfRepayment: "lumpsum",
			ApprovedStatus: true,
			DisbursedStatus: true,
			RepaymentStatus: true,
			Consent: true,
			RegulatoryCheck: true,
			ApprovedBy: ApproverGroup{ApproverName: "Hdfc", LoanOffered: "1 crore"},
		},
		{
			RequestID: "request4", 
			RequesterName: "David", 
			LoanAmount: "3 crore", 
			InterestRate: 1.0,
			NoOfYears: 2,
			ModeOfRepayment: "emi",
			ApprovedStatus: true,
			DisbursedStatus: true,
			RepaymentStatus: true,
			Consent: true,
			RegulatoryCheck: true,
			ApprovedBy: ApproverGroup{ApproverName: "Axis", LoanOffered: "3 crore"},
		},
		{
			RequestID: "request5", 
			RequesterName: "Smith", 
			LoanAmount: "5 lakhs", 
			InterestRate: 6.0,
			NoOfYears: 1,
			ModeOfRepayment: "lumpsum",
			ApprovedStatus: true,
			DisbursedStatus: true,
			RepaymentStatus: true,
			Consent: true,
			RegulatoryCheck: true,
			ApprovedBy: ApproverGroup{ApproverName: "Sbi", LoanOffered: "5 lakhs"},
		},
	}

	for _, loanRequest := range loanRequests{
		loanRequestJSON, err := json.Marshal(loanRequest)
		if err != nil {
			return err
		}

		err = ctx.GetStub().PutState(loanRequest.RequestID,loanRequestJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v",err)
		}
	}

	return nil
}

//CreateLoanRequest issues a new loanRequest to the world state with given details

func (t *TestContract) CreateLoanRequest(ctx contractapi.TransactionContextInterface, requestId string, requesterName string, loanAmount string, interestRate float64, noOfYears int, repaymentMode string) error {
	exists, err := t.RequestExists(ctx, requestId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("The request %s already exists", requestId)
	}

	loanRequest := LoanRequest{
		RequestID:			requestId,
		RequesterName:		requesterName,
		LoanAmount:			loanAmount,
		InterestRate:		interestRate,
		NoOfYears:			noOfYears,
		ModeOfRepayment:	repaymentMode,
		ApprovedStatus:		false,
		DisbursedStatus:	false,
		RepaymentStatus:	false,
		Consent:			false,
		RegulatoryCheck:	false,
		ApprovedBy:			ApproverGroup{ApproverName: "", LoanOffered: ""},
	}

	loanRequestJSON, err := json.Marshal(loanRequest)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(requestId,loanRequestJSON)
}


//ViewLoanRequest returns the loan request stored in the world state associated with the given id
func (t *TestContract) ViewLoanRequest(ctx contractapi.TransactionContextInterface, requestId string) (*LoanRequest,error){
	loanRequestJSON, err := ctx.GetStub().GetState(requestId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from the world state %v", err)
	}
	if loanRequestJSON == nil {
		return nil, fmt.Errorf("The asset %s does not exist", requestId)
	}

	var loanRequest LoanRequest
	err = json.Unmarshal(loanRequestJSON, &loanRequest)
	if err != nil {
		return nil, err
	}

	return &loanRequest, nil
}

//GetAllLaonrequest returns all the loan requests in the world state
func (t *TestContract) GetAllLoanRequest(ctx contractapi.TransactionContextInterface) ([]*LoanRequest,error){
	resultsIterator,err := ctx.GetStub().GetStateByRange("","")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var loanRequests []*LoanRequest
	for resultsIterator.HasNext(){
		queryResponse,err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var loanRequest LoanRequest
		err = json.Unmarshal(queryResponse.Value, &loanRequest)
		if err != nil {
			return nil, err
		}
		loanRequests = append(loanRequests, &loanRequest)
	}
	return loanRequests, nil
}

//DeleteLoanRequest deletes a loan request associated with the given id from the world state.
func (t *TestContract) DeleteLoanRequest(ctx contractapi.TransactionContextInterface, requestId string) error {
	exists, err := t.RequestExists(ctx, requestId)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("The asset %s does not exist", requestId)
	} 

	return ctx.GetStub().DelState(requestId)
}


// Fetches MSPID of the peer that calls the chaincode
/* func (t *TestContract) getMSPID(ctx contractapi.TransactionContextInterface) (string,error){
	creator,err := ctx.GetStub().GetCreator()
	if err != nil {
		return "", err
	}
	identity, err := msp.DeserializeIdentity(creator)
	if err != nil {
		return "", err
	}

	return identity.GetMSPID(), nil
}
 */
func (t *TestContract) getMSPID(ctx contractapi.TransactionContextInterface) (string, error) {
    mspID, err := cid.GetMSPID(ctx.GetStub())
    if err != nil {
        return "", err
    }

    return mspID, nil
}

//Sets the RegulatoryCheck field true if the loanRequest passes all regulatory checks
func (t *TestContract) RegulationCheck(ctx contractapi.TransactionContextInterface, requestId string) (bool, error){
	mspid, err := t.getMSPID(ctx)
	if err != nil {
		return false, fmt.Errorf("Failed to fetch MSPID ", err) 
	}

	if mspid == "RegulatorMSP" {
		exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return false, err
		}
		if !exists {
			return false, fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return false, fmt.Errorf("Failed to read from the world state: %v", err)
		}
		loanRequest.RegulatoryCheck = true

		loanRequestJSON, err := json.Marshal(loanRequest)
		if err != nil {
			return false, err
		}

		err = ctx.GetStub().PutState(requestId,loanRequestJSON)
	}else {
		return false, fmt.Errorf("Only Regulator can approve regulation checks.")
	}

	return true, nil
}

var loanApproverMap = map[string]ApproverGroup{}

//Sets ApprovedStatus true if the loan request passes all the approval checks
func (t *TestContract) LoanApprove(ctx contractapi.TransactionContextInterface, requestId string) (bool, error) {
	mspid, err := t.getMSPID(ctx)
	if err != nil {
		return false, fmt.Errorf("Failed to fetch MSPID ", err) 
	}

	if mspid == "AxisMSP"{
		exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return false, err
		}
		if !exists {
			return false, fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return false, fmt.Errorf("Failed to read from the world state: %v", err)
		}

		if !loanRequest.ApprovedStatus {
			approverGroup := ApproverGroup{
			ApproverName: "Axis",
			LoanOffered: loanRequest.LoanAmount,
		}

		loanApproverMap[requestId] = approverGroup
		loanRequest.ApprovedStatus = true
		}else {
			fmt.Errorf("Loan already approved for the %s id", requestId)
		}	
	}else if mspid == "HdfcMSP" {
		exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return false, err
		}
		if !exists {
			return false, fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return false, fmt.Errorf("Failed to read from the world state: %v", err)
		}

		if !loanRequest.ApprovedStatus {
			approverGroup := ApproverGroup{
			ApproverName: "Hdfc",
			LoanOffered: loanRequest.LoanAmount,
		}

		loanApproverMap[requestId] = approverGroup
		loanRequest.ApprovedStatus = true
		}		
	}else if mspid == "SbiMSP" {
		exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return false, err
		}
		if !exists {
			return false, fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return false, fmt.Errorf("Failed to read from the world state: %v", err)
		}

		if !loanRequest.ApprovedStatus {
			approverGroup := ApproverGroup{
			ApproverName: "Sbi",
			LoanOffered: loanRequest.LoanAmount,
		}

		loanApproverMap[requestId] = approverGroup
		loanRequest.ApprovedStatus = true
		}		
	}else {
		return false, fmt.Errorf("Only Approver Group can call this function")
	}
	
	return true, nil
}

//Sets Consent status true if the loan request passes all the required checks
func (t *TestContract) Consent(ctx contractapi.TransactionContextInterface, requestId string) error {

	exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return err
		}
		if !exists {
			return fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return fmt.Errorf("Failed to read from the world state: %v", err)
		}
		if loanRequest.ApprovedStatus {
		
			loanRequest.Consent = true
			loanRequestJSON, err := json.Marshal(loanRequest)
			if err != nil {
				return err
			}
			err = ctx.GetStub().PutState(requestId,loanRequestJSON)
		}else {
			fmt.Errorf("Consent failed as Loan request is not approved")
		}

		return nil
}

//Sets Disbursed status true if the loan request passes all the disbursal checks
func (t *TestContract) LoanDusburse(ctx contractapi.TransactionContextInterface, requestId string) error {

	exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return err
		}
		if !exists {
			return fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return fmt.Errorf("Failed to read from the world state: %v", err)
		}
		if loanRequest.Consent {
		
			loanRequest.DisbursedStatus = true
			loanRequestJSON, err := json.Marshal(loanRequest)
			if err != nil {
				return err
			}
			err = ctx.GetStub().PutState(requestId,loanRequestJSON)
		}else {
			return fmt.Errorf("Loan cannot be disbursed as consent is not provided")
		}
		return nil

}

//Sets Repayment status true if the loan request passes all the repayment checks
func (t *TestContract) LoanRepay(ctx contractapi.TransactionContextInterface, requestId string) error {

	exists, err := t.RequestExists(ctx, requestId)
		if err != nil {
			return err
		}
		if !exists {
			return fmt.Errorf("The asset %s does not exist", requestId)
		}

		loanRequest, err := t.ViewLoanRequest(ctx, requestId)
		if err != nil {
			return fmt.Errorf("Failed to read from the world state: %v", err)
		}
		if loanRequest.DisbursedStatus {
		
			loanRequest.RepaymentStatus = true
			loanRequestJSON, err := json.Marshal(loanRequest)
			if err != nil {
				return err
			}
			err = ctx.GetStub().PutState(requestId,loanRequestJSON)
		}else {
			fmt.Errorf("Cannot repay loan before disbursal")
		}

		return nil
}

//Checks if a loan request exists for the given request id
func (t *TestContract) RequestExists(ctx contractapi.TransactionContextInterface, requestId string) (bool, error) {
	loanRequestJSON, err := ctx.GetStub().GetState(requestId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return loanRequestJSON != nil, nil
}
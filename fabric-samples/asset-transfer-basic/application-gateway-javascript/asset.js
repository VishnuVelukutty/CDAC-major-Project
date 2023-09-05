const { Request, Response } = require("express");
const utf8Decoder = new TextDecoder();
const { Connection } = require("../api/connection.js");

class AssetRouter {
    routes(app) {
        app.route('/list')
            .get(async (req, res) => {
                const resultBytes = Connection.contract.evaluateTransaction('GetAllLoanRequest');
                const resultJson = utf8Decoder.decode(await resultBytes);
                const result = JSON.parse(resultJson);
                res.status(200).send(result);
            });

        app.route('/create')
            .post((req, res) => {
                console.log(req.body);
                var Id = Date.now();
                var json = JSON.stringify({
                    RequestID: Id + "",
                    //  :req.body.RequestID,
                    RequesterName: req.body.RequesterName,
                    LoanAmount: req.body.LoanAmount,
                    InterestRate: req.body.InterestRate,
                    NoOfYears: req.body.NoOfYears,
                    ModeOfRepayment: req.body.ModeOfRepayment,
                    /*                     ApprovedStatus		:req.body.ApprovedStatus,
                                        DisbursedStatus		:req.body.DisbursedStatus,
                                        RepaymentStatus		:req.body.RepaymentStatus,
                                        Consent				:req.body.Consent,
                                        RegulatoryCheck		:req.body.RegulatoryCheck, */
                    ApprovedBy: req.body.ApprovedBy
                });
                Connection.contract.submitTransaction('CreateLoanRequest', json);
                var response = ({ "AssetId": Id });
                res.status(200).send(response);
            });

        app.route('/get')
            .get(async (req, res) => {
                let id = req.body.RequestID;
                console.log('\n--> Evaluate Transaction: ReadAsset, function returns asset attributes');
                const resultBytes = Connection.contract.evaluateTransaction('ViewLoanRequest', id);
                const resultJson = utf8Decoder.decode(await resultBytes);
                const result = JSON.parse(resultJson);
                console.log('*** Result:', result);
                res.status(200).send(result);
            });

        app.route('/delete')
            .post((req, res) => {
                console.log(req.body);
                var response;
                try {
                    Connection.contract.submitTransaction('DeleteLoanRequest', req.body.RequestID);
                    response = ({ "status": 0, "message": "Delete success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);

            });


        // app.route('/mspId')
        app.route('/get/:id')
        .get(async (req, res) => {
            let id = req.params.id;
            console.log('\n--> Evaluate Transaction: ReadAsset, function returns asset attributes');
            const resultBytes = Connection.contract.evaluateTransaction('RequestExists', id);
            const resultJson = utf8Decoder.decode(await resultBytes);
            const result = JSON.parse(resultJson);
            console.log('*** Result:', result);
            res.status(200).send(result);
        });


        app.route('/regchk')
            .post((req, res) => {
                console.log(req.body);
                var response;
                try {
                    Connection.contract.submitTransaction('RegulationCheck', req.body.RequestID);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);
            })

        app.route('/approve')
            .post((req, res) => {
                console.log(req.body);
                var response;
                try {
                    Connection.contract.submitTransaction('LoanApprove', req.body.RequestID);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);
            })
        app.route('/consent')
            .post((req, res) => {
                console.log(req.body);
                var response;
                try {
                    Connection.contract.submitTransaction('Consent', req.body.RequestID);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);

            })

        app.route('/disburse')
            .post((req, res) => {
                console.log(req.body);
                var response;

                try {
                    Connection.contract.submitTransaction('LoanDusburse', req.body.RequestID);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);
            })

            app.route('/repay')
            .post((req, res) => {
                console.log(req.body);
                var response;

                try {
                    Connection.contract.submitTransaction('LoanRepay', req.body.RequestID);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);
            })




/*         app.route('/update')
            .post((req, res) => {
                console.log(req.body);
                var Id = Date.now();
                var json = JSON.stringify({
                    ID: req.body.ID,
                    Owner: req.body.Owner,
                    Color: req.body.Color,
                    Size: req.body.Size,
                    AppraisedValue: req.body.AppraisedValue,
                });
                var response;
                try {
                    Connection.contract.submitTransaction('UpdateAsset', json);
                    response = ({ "status": 0, "message": "Update success" });
                } catch (error) {
                    response = ({ "status": -1, "message": "Something went wrong" });
                }
                res.status(200).send(response);
            });

       app.route('/transfer')
            .post(async (req, res) => {
                console.log(req.body);

                console.log('\n--> Async Submit Transaction: TransferAsset, updates existing asset owner');

                const commit = Connection.contract.submitAsync('TransferAsset', {
                    arguments: [req.body.assetId, 'Saptha'],
                });
                const oldOwner = utf8Decoder.decode((await commit).getResult());

                console.log(`*** Successfully submitted transaction to transfer ownership from ${oldOwner} to Saptha`);
                console.log('*** Waiting for transaction commit');

                const status = await (await commit).getStatus();
                if (!status.successful) {
                    throw new Error(`Transaction ${status.transactionId} failed to commit with status code ${status.code}`);
                }
                console.log('*** Transaction committed successfully');
                res.status(200).send(status);
            });
        app.route('/updateNonExistentAsset')
            .post(async (req, res) => {
                try {
                    await Connection.contract.submitTransaction(
                        'UpdateAsset',
                        'asset70',
                        'blue',
                        '5',
                        'Tomoko',
                        '300'
                    );
                    console.log('******** FAILED to return an error');
                } catch (error) {
                    console.log('*** Successfully caught the error: \n', error);
                }
                res.status(200).send("Success");
            }); */

    }
}

module.exports = { AssetRouter };

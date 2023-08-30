const { Request, Response } = require("express");
const utf8Decoder = new TextDecoder();
const { Connection } = require("../api/connection.js");

class AssetRouter {
    routes(app) {
        app.route('/list')
            .get(async (req, res) => {
                const resultBytes = Connection.contract.evaluateTransaction('GetAllAssets');
                const resultJson = utf8Decoder.decode(await resultBytes);
                const result = JSON.parse(resultJson);
                res.status(200).send(result);
            });
        app.route('/create')
            .post((req, res) => {
                console.log(req.body);
                var Id = Date.now();
                var json = JSON.stringify({
                    ID: Id + "",
                    Owner: req.body.Owner,
                    Color: req.body.Color,
                    Size: req.body.Size,
                    AppraisedValue: req.body.AppraisedValue,
                });
                Connection.contract.submitTransaction('CreateAsset', json);
                var response = ({ "AssetId": Id });
                res.status(200).send(response);
            });
        app.route('/update')
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
        app.route('/delete')
            .post((req, res) => {
                console.log(req.body);
                var response;
                try {
                    Connection.contract.submitTransaction('DeleteAsset', req.body.id);
                    response = ({ "status": 0, "message": "Delete success" });
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
            });
        app.route('/get/:id')
            .get(async (req, res) => {
                let id = req.params.id;
                console.log('\n--> Evaluate Transaction: ReadAsset, function returns asset attributes');
                const resultBytes = Connection.contract.evaluateTransaction('ReadAsset', id);
                const resultJson = utf8Decoder.decode(await resultBytes);
                const result = JSON.parse(resultJson);
                console.log('*** Result:', result);
                res.status(200).send(result);
            });
    }
}

module.exports = { AssetRouter };

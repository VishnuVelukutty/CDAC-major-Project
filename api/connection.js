const grpc = require('@grpc/grpc-js');
const { connect, signers } = require('@hyperledger/fabric-gateway');
const crypto = require('crypto');
const path = require('path');
const fs = require('fs').promises;

const channelName = envOrDefault('CHANNEL_NAME', 'mychannel');
const chaincodeName = envOrDefault('CHAINCODE_NAME', 'testcontract');
const mspId = envOrDefault('MSP_ID', 'Org1MSP');



//Local development and testing changes required

const CRYPTO_PATH =envOrDefault('CRYPTO_PATH', path.resolve(__dirname, '..','..', '..', 'Major-Project', 'CDAC-major-Project', 'loan-transfer','network'));


// "/home/vishnu-velukutty/Desktop/testcode/loan-transfer/network"
// const keyPath = WORKSHOP_CRYPTO + "/enrollments/org1/users/org1user/msp/keystore/key.pem";
// const certPath = WORKSHOP_CRYPTO + "/enrollments/org1/users/org1user/msp/signcerts/cert.pem"
// const tlsCertPath = WORKSHOP_CRYPTO + "/channel-msp/peerOrganizations/org1/msp/tlscacerts/tlsca-signcert.pem";




const keyPath = CRYPTO_PATH + "/organizations/peerOrganizations/regulatorBody.bank.com/peers/peer0.regulatorBody.bank.com/msp/keystore/priv_sk";
const certPath = CRYPTO_PATH + "/organizations/peerOrganizations/regulatorBody.bank.com/peers/peer0.regulatorBody.bank.com/msp/signcerts/peer0.regulatorBody.bank.com-cert.pem"
const tlsCertPath = CRYPTO_PATH + "/organizations/peerOrganizations/regulatorBody.bank.com/peers/peer0.regulatorBody.bank.com/msp/tlscacerts/tlsca.regulatorBody.bank.com-cert.pem";




console.log("keyPath " + keyPath);
console.log("certPath " + certPath);
console.log("tlsCertPath " + tlsCertPath);
const peerEndpoint = "test-network-org1-peer1-peer.localho.st:443";
const peerHostAlias = "test-network-org1-peer1-peer.localho.st";

class Connection {
    static contract;
    init() {
        initFabric();
    }
}

async function initFabric() {
    const client = await newGrpcConnection();

    const gateway = connect({
        client,
        identity: await newIdentity(),
        signer: await newSigner(),
        evaluateOptions: () => {
            return { deadline: Date.now() + 5000 };
        },
        endorseOptions: () => {
            return { deadline: Date.now() + 15000 };
        },
        submitOptions: () => {
            return { deadline: Date.now() + 5000 };
        },
        commitStatusOptions: () => {
            return { deadline: Date.now() + 60000 };
        },
    });

    try {
        const network = gateway.getNetwork(channelName);
        const contract = network.getContract(chaincodeName);
        Connection.contract = contract;
        console.log("Working");
    } catch (e) {
        console.log('error log');
        console.log(e.message);
    } finally {
        console.log(' Running ');
    }
}

async function newGrpcConnection() {
    const tlsRootCert = await fs.readFile(tlsCertPath);
    const tlsCredentials = grpc.credentials.createSsl(tlsRootCert);
    return new grpc.Client(peerEndpoint, tlsCredentials, {
        'grpc.ssl_target_name_override': peerHostAlias,
    });
}

async function newIdentity() {
    const credentials = await fs.readFile(certPath);
    return { mspId, credentials };
}

async function newSigner() {
    const privateKeyPem = await fs.readFile(keyPath);
    const privateKey = crypto.createPrivateKey(privateKeyPem);
    return signers.newPrivateKeySigner(privateKey);
}

function envOrDefault(key, defaultValue) {
    return process.env[key] || defaultValue;
}

module.exports = { Connection };

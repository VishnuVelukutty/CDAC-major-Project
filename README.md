# CDAC Major Project: Decentralized Loan Management System using Hyperledger Fabric

## Project Description
The **Decentralized Loan Management System using Hyperledger Fabric** is a blockchain-based solution designed to streamline and enhance the loan requesting process by incorporating transparency, security, and efficiency through the Hyperledger Fabric framework. This system aims to serve as a robust platform for managing loan requests from a requester while involving multiple organizations and a regulator to oversee the entire process.

## Key Features
1. **Secure Loan Requesting**: Provide a secure and tamper-proof way for users to submit loan requests.
2. **Multi-Organization Approval**: Enable multiple organizations to collaborate on approving loan requests in a decentralized manner.
3. **Disbursement with Checks**: Implement a disbursement process that ensures transparency and security using checks.
4. **Smart Contract Automation**: Utilize smart contracts to automate various stages of the loan management process.
5. **Regulator Oversight**: Involve a regulator for overseeing the loan processes and ensuring compliance.
6. **Immutable Audit Trail**: Maintain an immutable record of all transactions and actions for auditing purposes.
7. **Real-time Notification**: Send real-time notifications to stakeholders about the status of loan requests and approvals.

## Advantages
1. **Enhanced Transparency**: All stakeholders can access a transparent view of the loan process, reducing mistrust.
2. **Improved Security**: Data is stored in a tamper-proof blockchain, minimizing the risk of unauthorized access.
3. **Reducing Processing Time**: Automation and decentralized approval streamline the loan process, reducing processing time.
4. **Enhanced Compliance**: The involvement of a regulator and smart contracts helps ensure compliance with regulations.

## Tech Stack
- Hyperledger Fabric
- Web3.js/Ether.js
- MongoDB
- Express.js
- React.js
- Node.js
- Git
- Docker/Kubernetes

## Setup
1. Check Dependencies or Install them using **install.sh** file  
```
chmod +x install.sh  

./install.sh
```

2. Download fabric binaries using 

```bash 
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

```  

> In case of error "*Cannot Download Fabric binaries*" or *Download a specific version of binary* use the following command and replace the version with required one 

```bash 
./install-fabric.sh --fabric-version 2.5.0 binary
```

3. Setting path incase of using Go Chain code


```bash 
nano .bashrc
```
then add the following line 
```bash 
export export PATH=$PATH:/usr/local/go/bin
```
then run 
```bash
source ~/.bashrc
```
to update your environment

4. Install Nodejs 
```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
```

node and npm to run node chaincode and applications
```bash
nvm install 18 
```

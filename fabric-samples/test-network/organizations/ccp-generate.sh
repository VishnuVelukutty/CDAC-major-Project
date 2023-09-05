#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/"\
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG="requestor"
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/requestor.banking.com/tlsca/tlsca.requestor.banking.com-cert.pem
CAPEM=organizations/peerOrganizations/requestor.banking.com/ca/ca.requestor.banking.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/requestor.banking.com/connection-requestor.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/requestor.banking.com/connection-requestor.yaml

ORG="axis"
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/axis.banking.com/tlsca/tlsca.axis.banking.com-cert.pem
CAPEM=organizations/peerOrganizations/axis.banking.com/ca/ca.axis.banking.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/axis.banking.com/connection-axis.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/axis.banking.com/connection-axis.yaml

ORG="hdfc"
P0PORT=11051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/hdfc.banking.com/tlsca/tlsca.hdfc.banking.com-cert.pem
CAPEM=organizations/peerOrganizations/hdfc.banking.com/ca/ca.hdfc.banking.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hdfc.banking.com/connection-hdfc.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hdfc.banking.com/connection-hdfc.yaml

ORG="sbi"
P0PORT=7089
CAPORT=11064
PEERPEM=organizations/peerOrganizations/sbi.banking.com/tlsca/tlsca.sbi.banking.com-cert.pem
CAPEM=organizations/peerOrganizations/sbi.banking.com/ca/ca.sbi.banking.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbi.banking.com/connection-sbi.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbi.banking.com/connection-sbi.yaml

ORG="regulator"
P0PORT=11071
CAPORT=11074
PEERPEM=organizations/peerOrganizations/regulator.banking.com/tlsca/tlsca.regulator.banking.com-cert.pem
CAPEM=organizations/peerOrganizations/regulator.banking.com/ca/ca.regulator.banking.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.banking.com/connection-regulator.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.banking.com/connection-regulator.yaml
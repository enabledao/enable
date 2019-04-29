import React from "react";
import { Link } from "react-router-dom";

import "../../styles/LandingPage.css";

import { Box, Flex, Heading, Image } from "rimble-ui";
import {
  Container,
  Row,
  Col,
  Card,
  CardBody,
  CardFooter,
  Badge,
  Button
} from "shards-react";

import { EmailOptIn } from "../EmailOptIn";

import world_dotted_map from "../../assets/world_dotted_map.png";
import loan_card from "../../assets/loan_card.png";
import dharma from "../../assets/dharma.png";
import bloom from "../../assets/bloom.png";
import usdc from "../../assets/usdc.png";

type MyState = {};

export class LandingPage extends React.Component<{}, MyState> {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Flex flexDirection="column" className="landingPage">
          <Box width={1} justifyContent="center" pt={144} pb={72}>
            <Heading.h1 textAlign="center" className="SF-Pro-Display-Semibold">
              Stablecoin Loans
            </Heading.h1>
            <Heading.h3
              textAlign="center"
              fontWeight="500"
              pb={48}
              style={{ color: "#484848" }}
              className="SF-Pro-Display-Medium"
            >
              Enabling opportunity through borderless credit
            </Heading.h3>
            <Box width={1 / 2} ml={"25%"}>
              <Image className="worldMap" src={world_dotted_map} />
            </Box>
          </Box>
          <Box width={1} justifyContent="center" pt={144} pb={72}>
            <Heading.h2 textAlign="center" className="sectionHeader">
              How it works
            </Heading.h2>
            <Flex width={"80%"} className="justifyCentered">
              <Box width={"48%"}>
                <Card className="partiesBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    For Borrowers
                  </Heading.h3>
                  <h4>0% processing fee through smart contracts</h4>
                  <h4>
                    Create loan request (i.e. interest rate, tenor, grace
                    period) and broadcast it on a global loans marketplace
                  </h4>
                  <h4>
                    Increase your chances of getting funded by having others
                    socially attest for you
                  </h4>
                  <h4>
                    Convert 1:1 USD backed stablecoins at your local exchange
                  </h4>
                </Card>
              </Box>
              <Box width={"48%"} ml={"4%"}>
                <Card className="partiesBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    For Lenders
                  </Heading.h3>
                  <h4>0% servicing fee for lenders through smart contracts</h4>
                  <h4>
                    Access funding opportunities in emerging or underserved
                    markets with potentially higher returns
                  </h4>
                  <h4>
                    New data sources for credit scoring such as social
                    attestations from colleagues and friends
                  </h4>
                  <h4>Earn interest on 1:1 USD backed stablecoins</h4>
                </Card>
              </Box>
            </Flex>
          </Box>
          <Box width={1} justifyContent="center" pt={144} pb={72}>
            <Heading.h2 textAlign="center" className="sectionHeader">
              Loans
            </Heading.h2>
            <Box width={"40%"} ml={"30%"}>
              <Image className="worldMap" src={loan_card} />
            </Box>
          </Box>
          <EmailOptIn />
          <Box width={1} justifyContent="center" pt={144} pb={72}>
            <Heading.h2 textAlign="center" className="sectionHeader">
              Features
            </Heading.h2>
            <Flex width={"80%"} className="justifyCentered" flexWrap="wrap">
              <Box width={"30%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Identity Verification
                  </Heading.h3>
                  <h4>
                    Cross-border credit scoring is made possible using Bloom’s
                    identity verification through social accounts and government
                    IDs
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Social Attestation
                  </Heading.h3>
                  <h4>
                    Credit worthiness can be attested to by an applicants’
                    colleagues, friends and family, who are notified if the loan
                    goes into default
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Underwriting Video Interview
                  </Heading.h3>
                  <h4>
                    Potential lenders can conduct a video interview with
                    verified borrower prior to funding loan
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Repayment Tracking
                  </Heading.h3>
                  <h4>
                    Repayments are tracked with a Dharma Protocol’s public loan
                    contracts for transparency and borrower accountability
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Stable Interest Rates
                  </Heading.h3>
                  <h4>
                    Stablecoins on blockchain remove volatility and allow for
                    planning of future cash flows
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="featuresBox border-radius-12">
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Tradeable Debt Tokens
                  </Heading.h3>
                  <h4>
                    Fractional ownership of a loan through a debt token allows
                    you access to earlier liquidity if needed
                  </h4>
                </Card>
              </Box>
            </Flex>
          </Box>
          <Box width={1} justifyContent="center" pt={144} pb={72}>
            <Heading.h2 textAlign="center" className="sectionHeader">
              Protocol Integrations
            </Heading.h2>
            <Flex
              width={"80%"}
              className="justifyCentered"
              flexWrap="wrap"
              mb="18em"
            >
              <Box width={"30%"}>
                <Card className="integrationsBox border-radius-12">
                  <Image className="logos" src={dharma} />
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Dharma
                  </Heading.h3>
                  <h4>
                    Open protocol for issuing and administering debt agreements
                    on the Ethereum blockchain
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="integrationsBox border-radius-12">
                  <Image className="logos" src={bloom} />
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    Bloom
                  </Heading.h3>
                  <h4>
                    End-to-end protocol for Identity attestation and credit
                    scoring, powered by Ethereum and IPFS
                  </h4>
                </Card>
              </Box>
              <Box width={"30%"} ml={"5%"}>
                <Card className="integrationsBox border-radius-12">
                  <Image className="logos width-auto" src={usdc} />
                  <Heading.h3
                    className="SF-Pro-Display-Semibold"
                    textAlign="center"
                  >
                    USDC
                  </Heading.h3>
                  <h4>
                    Coinbase's USD Coin is an Ethereum token stableCoin backed
                    by US Dollars held in a bak account
                  </h4>
                </Card>
              </Box>
            </Flex>
          </Box>
        </Flex>
      </div>
    );
  }
}

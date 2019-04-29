import React from "react";
import { string, number } from "prop-types";
import { Link } from "react-router-dom";

import { Flex, Box, Heading, Image, Text, PublicAddress } from 'rimble-ui';
import {
  Card,
  CardHeader,
  CardTitle,
  CardImg,
  CardBody,
  CardFooter,
  Button,
  Progress
} from "shards-react";
import "../../styles/Loan.css";

import dBox from "../../assets/3dbox.svg";
import bloomLogo from "../../assets/bloom-logo.svg";

import { EthereumComponent } from '../EthereumComponent';
import { ContributerMetadata, LoanMetadata, LoanParams, TokenMetadata, UserMetadata, RepaymentData, StakerMetadata } from '../../interfaces'
import { database } from '../../data/database';
import { LoanHeader } from '../loan/LoanHeader';
import { AvatarList, AvatarListData } from "../AvatarList";
import { UserData } from "./UserProfile";

enum VerifiedIdTypes {
  'BLOOM',
  '3BOX'
}

var LoanRequest = require("../../contractabi/LoanRequest.json");
var LoanRequestFactory = require("../../contractabi/LoanRequestFactory.json");
var UserStaking = require("../../contractabi/UserStaking.json");

type MyState = {
  web3: any;
  contributors: AvatarListData[];
  loanParams: LoanParams;
  loanMetadata: LoanMetadata;
  userData: UserData;
  tokenMetadata: TokenMetadata;
  isLoaded: boolean;
};

export class Loan extends EthereumComponent {

  state: MyState

  constructor(props) {
    super(props);
    this.state = {
      contributors: [] as AvatarListData[],
      loanParams: {} as LoanParams,
      loanMetadata: {} as LoanMetadata,
      userData: {} as UserData,
      tokenMetadata: {} as TokenMetadata,
      isLoaded: false,
      web3: null
    }
  }

  // @dev Get icons and names of contributors if they have shared their data, or ethereum blockie and address if not
  async getContributors(): Promise<AvatarListData[]> {
    return [] as AvatarListData[];
  }

  async getStakers(userAddress: string): Promise<string[]> {
    return [] as string[];
  }

  /* 
    Get a list of attestations, and the relevant data for each parsed down to what we need. The user gives these to the app via bloom when they create their account, or later. We then store the attestations in our datastore and display them to the potential lenders. Some information may be kept private which the lenders and borrower can communicate directly about
  */
  async getAttestations(userAddress: string): Promise<any> {
    return {};
  }

  // @dev Web3 call to get loan parameters from chain
  async getLoanParameters(): Promise<LoanParams> {
    return {} as LoanParams;
  }

  // @dev Get loan metadata from our servers or possibly IPFS
  async getLoanMetadata(): Promise<LoanMetadata> {
    return {} as LoanMetadata;
  }

  async getTokenMetadata(tokenAddress: string): Promise<TokenMetadata> {
    console.log(database.tokens.get(tokenAddress));
    return database.tokens.get(tokenAddress);
  }

  async getUserMetadata(userId: number): Promise<UserMetadata> {
    return database.users.get(userId);
  }

  async componentDidMount() {
    //Dummy Data
    this.setState({
      contributors: [
        {
          img: "https://airswap-token-images.s3.amazonaws.com/DAI.png",
          text: "Dai"
        },
        {
          img: "https://airswap-token-images.s3.amazonaws.com/DAI.png",
          text: "USDC"
        }
      ],
      loanParams: {
        principal: 60000,
        fundsRaised: 48000,
        interestRate: 6,
        tenor: 120,
        gracePeriod: 24,
        repayments: 100,
        repaymentSchedule: [],
        loanCurrency: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
      },
      loanMetadata: {
        location: "Jakarta, Indonesia",
        purpose: "University",
        description: "Student loan for Masters Degree in Human Resources at Cornell University, with the intention to work in the US HR sector post-graduation.",
        userStory: "Student loan for Masters Degree in Human Resources at Cornell University, with the intention to work in the US HR sector post-graduation.",
        imgSrc: "",
      },
      userData: {
        name: "Ines",
      },
      isLoaded: true
    });

    //Contract Instances
    if(!this.state.web3) {
      //Connect ot infura - at the previous component
    }

    // var MyContract = contract({
    //   abi: ...,
    //   unlinked_binary: ...,
    //   address: ..., // optional
    //   // many more
    // })

    //Will get real data
    const contributors = await this.getContributors();
    const loanParams = await this.getLoanParameters();
    const tokenMetadata = await this.getTokenMetadata(this.state.loanParams.loanCurrency);

    this.setState({
      tokenMetadata: tokenMetadata
    })
  }

  get getLoan () {
    return {
      category: "Education",
      metadata: Object.assign({}, this.state.loanMetadata, {
          imgSrc: "https://cdn.pixabay.com/photo/2017/02/17/23/15/duiker-island-2076042_960_720.jpg",
      }),
      borrower: {
        address:"0x0",
        metadata: this.state.userData
      },
      articles: [
        {name: "Medium Post", url: "weee"},
      ],
      documents: [
        {name: "Cornell Admission Letter", url: "weee"},
      ]
    }
  }

  render() {
    const { contributors, loanParams, loanMetadata, userData, isLoaded, tokenMetadata } = this.state;
    const percentFunded = loanParams.fundsRaised / loanParams.principal * 100;

    return (
      <div className="tight-page" style={{ marginTop: "48px"}}>
        <LoanHeader
          loan = {this.getLoan}
        />

        <Flex className="section-row" >
          <Box p={3} width={1 / 2} color="black" bg="white">
            <Card>
              <CardBody>
                <Flex >
                  <Box width={2/4}>
                    <Heading.h2 className="SF-Pro-Display-Semibold" textAlign="left">Identity</Heading.h2>
                  </Box>
                  <Box width={2/4}>
                    <div style={{ position: "relative", marginTop: "-20px", marginRight: "-5px", width: "100%" }}>
                      <Text textAlign="right" className="SF-Pro-Display-Light gray">Powered by</Text>
                      <div className="powered-by">
                        <a href="https://https://3box.io/" target="_blank"><Image src={dBox} /></a>
                        <a href="https://bloom.co/" target="_blank"><Image src={bloomLogo} /></a>
                      </div>
                    </div>
                  </Box>
                </Flex>
                <div>
                  <PublicAddress
                    className="pubAddress"
                    address={this.getLoan.borrower.address} 
                    label=""
                  />
                </div>
              </CardBody>
            </Card>
          </Box>
          <Box p={3} width={1 / 2} color="black" bg="white">
            <Card>
              <CardBody>
                <h2>{percentFunded}% Funded</h2>
                <Progress theme="primary" value={percentFunded} />
                <Text>Total Amount ${loanParams.principal}</Text>
                <Text>Powered by {contributors.length} lenders</Text>
                <h3>{userData.name}</h3>
                <Text>{loanMetadata.location} | {loanMetadata.purpose}</Text>
                <Text>"Default Amount + Call to action"</Text>
              </CardBody>
            </Card>
          </Box>
        </Flex>

        // Second Row
        <Flex>
          <Box p={3} width={1 / 2} color="black" bg="white">
            Loan Summary
          </Box>
        </Flex>

        // Third Row
        <Flex>
          <Box p={3} width={1 / 2} color="black" bg="white">
            <h3>{userData.name}'s Story</h3>

            <h3>Contributors</h3>
            <AvatarList data={contributors}></AvatarList>
          </Box>
          <Box p={3} width={1 / 2} color="black" bg="white">

            <Card>
              <CardBody>
                <h3>Loan Details</h3>
                <Text>Principal ${loanParams.principal} {tokenMetadata.name}</Text>
                <Text>Interest {loanParams.interestRate}% Effective Annual</Text>
                <Text>Tenor {loanParams.tenor / 12} Years</Text>
                <Text>Grace Period {loanParams.gracePeriod / 12} Years</Text>
                <Text>Expected Return {36}%</Text>
              </CardBody>
            </Card>
            <h3>Repayment Schedule</h3>
          </Box>
        </Flex>
      </div>
    );
  }
}